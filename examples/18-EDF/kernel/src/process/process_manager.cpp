#include <process/process_manager.h>
#include <process/resource_manager.h>

#include <memory/kernel_heap.h>
#include <memory/pages.h>
#include <memory/memmap.h>
#include <memory/mmu.h>
#include <memory/pt_alloc.h>

#include <fs/filesystem.h>
#include <drivers/monitor.h>

#include <drivers/timer.h>

// "importovane" funkce z asm
extern "C"
{
    void user_process_bootstrap();
    void system_process_bootstrap();
    void context_switch(TCPU_Context* ctx_to, TCPU_Context* ctx_from);
    void context_switch_first(TCPU_Context* ctx_to, TCPU_Context* ctx_from);
};

CProcess_Manager sProcessMgr;

CProcess_Manager::CProcess_Manager()
: mLast_PID(0)
, mProcess_List_Head(nullptr)
, mCurrent_Task_Node(nullptr)
{
    // mSchedule_Fnc = &CProcess_Manager::Schedule_RR;
    mSchedule_Fnc = &CProcess_Manager::Schedule_EDF;
}

TTask_Struct* CProcess_Manager::Get_Current_Process() const
{
    return mCurrent_Task_Node ? mCurrent_Task_Node->task : nullptr;
}

TTask_Struct* CProcess_Manager::Get_Process_By_PID(uint32_t pid) const
{
    CProcess_List_Node* node = mProcess_List_Head;
    while (node != nullptr)
    {
        if (node->task->pid == pid)
            return node->task;

        node = node->next;
    }

    return nullptr;
}

void CProcess_Manager::Block_Current_Process()
{
    TTask_Struct* cur = Get_Current_Process();

    cur->state = NTask_State::Blocked;

    // TODO: doopravdy to takto chceme?
    // if (cur->notified_deadline != Deadline_Unchanged)
    //    cur->deadline = Indefinite;

    Schedule();
}

bool CProcess_Manager::Notify_Process(uint32_t pid)
{
    TTask_Struct* task = Get_Process_By_PID(pid);
    if (!task || task->state != NTask_State::Blocked)
        return false;

    return Notify_Process(task);
}

bool CProcess_Manager::Notify_Process(TTask_Struct* proc)
{
    if (!proc)
        return false;

    // ve slozitejsich planovacich by tady mohl byt treba i presun do jine fronty procesu, apod.
    proc->state = NTask_State::Runnable;

    // pokud byla nastavena "budouci" deadline, nastavime skutecnou deadline
    if (proc->notified_deadline != Deadline_Unchanged)
        proc->deadline = sTimer.Get_Tick_Count() + proc->notified_deadline;
    // pozor: tady nesmime mazat budouci deadline - co kdyby byl proces probuzen falesne? (stolen wakeup)
    //        v kernelu by se to sice stavat uplne nemelo, ale co kdybychom se nekde upsali

    return true;
}

uint32_t CProcess_Manager::Create_Process(unsigned char* elf_file_data, unsigned int elf_file_length, bool is_system)
{
    CProcess_List_Node* procnode = sKernelMem.Alloc<CProcess_List_Node>();

    procnode->next = mProcess_List_Head;
    procnode->prev = nullptr;
    mProcess_List_Head->prev = procnode;
    mProcess_List_Head = procnode;

    if (!mCurrent_Task_Node)
        mCurrent_Task_Node = procnode;

    procnode->task = sKernelMem.Alloc<TTask_Struct>();

    auto* task = procnode->task;

    task->pid = ++mLast_PID;
    task->sched_static_priority =
    5; // TODO: pro ted je to jen hardcoded hodnota, do budoucna urcite bude nutne dovolit specifikovat
    task->sched_counter = task->sched_static_priority;
    task->state = NTask_State::New;
    task->deadline = Indefinite; // task si zatim nestanovil deadline, udela to az to bude aktualni v deadline syscallu
    task->notified_deadline = Indefinite;

    sMonitor << "Creating a new process (pid = " << task->pid << ")\n";

    // lr = co zacit vykonavat po bootstrapu, 0x8000 je misto, kam je relokovany v kazde nasi binarce symbol _start,
    // tedy vstupni bod programu
    task->cpu_context.lr = 0x8000;
    // pc = "aktualni" kod k provadeni, tedy bootstrap procesu v jadre - lisi se fakticky jen tim, zda je do CPSR vlozen
    // rezim uzivatelsky nebo systemovy, ale teoreticky muzeme chtit pridat jeste dalsi veci specificke pro nejaky z
    // rezimu
    task->cpu_context.pc = is_system ? reinterpret_cast<unsigned long>(&system_process_bootstrap)
                                     : reinterpret_cast<unsigned long>(&user_process_bootstrap);
    // sp = zasobnik, vzdy je relokovany na nejakou fixni pamet, pro nas je jednoduche volit ho o velikosti 1MB
    // pozn. zasobnik roste na druhou stranu, takze musime SP nastavit na konec stranky
    task->cpu_context.sp = 0x90000000 + mem::PageSize;

    // alokujeme stranku pro kod a pro zasobnik
    uint32_t code_page_phys = static_cast<unsigned long>(sPage_Manager.Alloc_Page()) - mem::MemoryVirtualBase;
    uint32_t stack_page_phys = static_cast<unsigned long>(sPage_Manager.Alloc_Page()) - mem::MemoryVirtualBase;

    // alokujeme tabulku stranek procesu z poolu
    uint32_t* pt = sPT_Alloc.Alloc();

    // zkopirujeme zakladni kernelovou tabulku - to proto, aby zustalo mapovani 0xFxxxxxxx a 0xCxxxxxxx adres (kod a
    // data) a mohli jsme vykonavat napr. obsluhu systemoveho volani beze zmeny adresniho prostoru pozn.: tohle
    // kopirovani se da odbourat korektnim pouzitim TTBR1 - pak by TTBR1 prekladal vse napr. od 0x8xxxxxxx vyse a TTBR0
    // by zustal pro spodni cast adr. rozsahu
    //        pro jednoduchost ted nechme takto, dvojice bazovych registru pro tabulky stranek jsou spise specialita
    //        ARMu a pribuznych procesoru
    copy_kernel_page_table_to(pt);

    // namapujeme kodovou stranku na zacatek virtualni pameti
    map_memory(pt, code_page_phys, 0x00000000);
    // namapujeme zasobnik na 0x90000000
    map_memory(pt, stack_page_phys, 0x90000000);

    // nakopirujeme kod do kodove stranky, ale...:
    // TODO: cist sekce ELF formatu, pro ted zneuzivame toho, ze pro takto male binarky je ELF binarne kompatibilni se
    // skutecnym otiskem v pameti
    unsigned char* code_contents = reinterpret_cast<unsigned char*>(code_page_phys) + mem::MemoryVirtualBase;
    for (int i = 0; i < elf_file_length; i++)
        code_contents[i] = elf_file_data[i];

    // nastavime ulozene TTBR0 procesu - tady musi byt fyzicka adresa, proto odecitame bazi (vsechny fyzicke adresy jsou
    // v kernelovem modu mapovany na "0xC0000000 + offset")
    task->cpu_context.ttbr0 =
    (reinterpret_cast<unsigned long>(pt) - mem::MemoryVirtualBase) | TTBR_Flags::Inner_Cacheable | TTBR_Flags::Shared;

    for (uint32_t i = 0; i < Max_Process_Opened_Files; i++)
        task->opened_files[i] = nullptr;

    return task->pid;
}

void CProcess_Manager::Schedule()
{
    // projdeme vsechny uspane (sleep) procesy, zda je na case je vzbudit
    {
        CProcess_List_Node* node = mProcess_List_Head;

        // sMonitor << "tick count = " << sTimer.Get_Tick_Count() << '\n';

        while (node)
        {
            if (node->task->state == NTask_State::Interruptable_Sleep)
            {
                // sMonitor << "timer_sleep (notify) = " << node->task->sleep_timer << '\n';

                if (node->task->sleep_timer != Indefinite && node->task->sleep_timer <= sTimer.Get_Tick_Count())
                {
                    // sMonitor << "Notifying process " << node->task->pid << '\n';
                    Notify_Process(node->task);
                }
            }

            node = node->next;
        }
    }

    // invokujeme skutecny planovac
    CProcess_List_Node* next = (this->*mSchedule_Fnc)();
    if (!next)
        return;

    // tady bychom jeste meli osetrit nejakou hranicni situaci, kdy by nebylo co naplanovat - to se sice nesmi stat a
    // byla by to chyba programatora kernelu, ale kdyby k tomu doslo, obtizne by se to diagnostikovalo

    // planovac usoudil, ze ma byt naplanovany proces, ktery zrovna ma CPU pro sebe - nemusime nic menit
    if (next == mCurrent_Task_Node)
    {
        // sMonitor << "Staying in process " << next->task->pid << '\n';
        return;
    }

    // sMonitor << "Swithing to process " << next->task->pid << '\n';
    Switch_To(next);
}

void CProcess_Manager::Switch_To(CProcess_List_Node* node)
{
    // pokud je stavajici proces ve stavu Running (muze teoreticky byt jeste Blocked), vratime ho do stavu Runnable
    // Blocked prehazovat nebudeme ze zjevnych duvodu
    if (mCurrent_Task_Node->task->state == NTask_State::Running)
        mCurrent_Task_Node->task->state = NTask_State::Runnable;

    // projistotu vynulujeme prideleny pocet casovych kvant
    mCurrent_Task_Node->task->sched_counter = 0;

    TCPU_Context* old = &mCurrent_Task_Node->task->cpu_context;
    bool is_first_time = (node->task->state == NTask_State::New);

    // prehodime na novy proces, pridelime casova kvanta a nastavime proces do stavu Running
    mCurrent_Task_Node = node;
    mCurrent_Task_Node->task->sched_counter = mCurrent_Task_Node->task->sched_static_priority;
    mCurrent_Task_Node->task->state = NTask_State::Running;

    // pokud je to poprve, co je proces planovany, musime to vzit jeste pres malou odbocku ("bootstrap")
    if (is_first_time)
        context_switch_first(&node->task->cpu_context, old);
    else
        context_switch(&node->task->cpu_context, old);
}

uint32_t CProcess_Manager::Map_File_To_Current(IFile* file)
{
    // TODO: zamek

    TTask_Struct* current = Get_Current_Process();
    if (!current)
        return Invalid_Handle;

    // najdeme volny slot, pokud je
    for (uint32_t i = 0; i < Max_Process_Opened_Files; i++)
    {
        // volny slot - namapujeme soubor a vracime handle (index do tabulky)
        if (current->opened_files[i] == nullptr)
        {
            current->opened_files[i] = file;
            return i;
        }
    }

    // nenasli jsme - vracime neplatny handle (vnejsi kod nejspis bude chtit soubor zase zavrit)
    return Invalid_Handle;
}

bool CProcess_Manager::Unmap_File_Current(uint32_t handle)
{
    TTask_Struct* current = Get_Current_Process();
    if (!current || handle >= Max_Process_Opened_Files)
        return false;

    if (!current->opened_files[handle])
        return false;

    current->opened_files[handle] = nullptr;
    return true;
}

void CProcess_Manager::Handle_Process_SWI(
NSWI_Process_Service svc_idx, uint32_t r0, uint32_t r1, uint32_t r2, TSWI_Result& target)
{
    // TODO: signalizace chyby
    if (!mCurrent_Task_Node)
        return;

    switch (svc_idx)
    {
        case NSWI_Process_Service::Get_PID:
            // sMonitor << "Handling SWI - Get_PID\n";
            target.r0 = mCurrent_Task_Node->task->pid;
            break;
        case NSWI_Process_Service::Terminate:
            // sMonitor << "Handling SWI - Terminate\n";
            mCurrent_Task_Node->task->sched_counter = 1;
            mCurrent_Task_Node->task->state = NTask_State::Zombie;
            mCurrent_Task_Node->task->exit_code = r0;
            Schedule();
            break;
        case NSWI_Process_Service::Yield:
            // sMonitor << "Handling SWI - Yield\n";
            Schedule();
            break;
        case NSWI_Process_Service::Sleep:
            // sMonitor << "Handling SWI - Sleep\n";
            mCurrent_Task_Node->task->sched_counter = 1;
            mCurrent_Task_Node->task->state = NTask_State::Interruptable_Sleep;
            mCurrent_Task_Node->task->notified_deadline = r1;
            mCurrent_Task_Node->task->sleep_timer = sTimer.Get_Tick_Count() + ((r0 == Indefinite) ? r0 + 1 : r0);
            // sMonitor << "sleep_timer = " << mCurrent_Task_Node->task->sleep_timer << '\n';
            Schedule();
            break;
        case NSWI_Process_Service::Get_Sched_Info:
            // sMonitor << "Handling SWI - Get_Sched_Info\n";
            Get_Scheduler_Info(static_cast<NGet_Sched_Info_Type>(r0), reinterpret_cast<void*>(r1));
            break;
        case NSWI_Process_Service::Deadline: {
            // sMonitor << "Handling SWI - Deadline\n";
            NDeadline_Subservice dtype = static_cast<NDeadline_Subservice>(r0);
            uint32_t* r1ptr = reinterpret_cast<uint32_t*>(r1);
            switch (dtype)
            {
                case NDeadline_Subservice::Set_Relative:
                    mCurrent_Task_Node->task->deadline =
                    ((*r1ptr == Indefinite) ? Indefinite : (sTimer.Get_Tick_Count() + *r1ptr));
                    mCurrent_Task_Node->task->notified_deadline = Indefinite;
                    break;
                case NDeadline_Subservice::Get_Remaining:
                    // TODO: co kdybychom prosvihli deadline?
                    *r1ptr = (mCurrent_Task_Node->task->deadline == Indefinite)
                             ? Indefinite
                             : mCurrent_Task_Node->task->deadline - sTimer.Get_Tick_Count();
                    break;
            }
            break;
        }
    }
}

void CProcess_Manager::Handle_Filesystem_SWI(
NSWI_Filesystem_Service svc_idx, uint32_t r0, uint32_t r1, uint32_t r2, TSWI_Result& target)
{
    // TODO: signalizace chyby
    if (!mCurrent_Task_Node)
        return;

    switch (svc_idx)
    {
        case NSWI_Filesystem_Service::Open: {
            target.r0 = Invalid_Handle;

            IFile* f = sFilesystem.Open(reinterpret_cast<const char*>(r0), static_cast<NFile_Open_Mode>(r1));
            if (!f)
                return;

            target.r0 = Map_File_To_Current(f);

            // nepodarilo se namapovat, napr. proto, ze jsme dosahli limitu otevrenych souboru
            if (target.r0 == Invalid_Handle)
            {
                f->Close();
                delete f;
            }
            break;
        }
        case NSWI_Filesystem_Service::Read: {
            target.r0 = 0;

            if (r0 > Max_Process_Opened_Files || !mCurrent_Task_Node->task->opened_files[r0])
                return;

            target.r0 = mCurrent_Task_Node->task->opened_files[r0]->Read(reinterpret_cast<char*>(r1), r2);
            break;
        }
        case NSWI_Filesystem_Service::Write: {
            target.r0 = 0;

            if (r0 > Max_Process_Opened_Files || !mCurrent_Task_Node->task->opened_files[r0])
                return;

            target.r0 = mCurrent_Task_Node->task->opened_files[r0]->Write(reinterpret_cast<const char*>(r1), r2);
            break;
        }
        case NSWI_Filesystem_Service::Close: {
            if (r0 > Max_Process_Opened_Files || !mCurrent_Task_Node->task->opened_files[r0])
                return;

            target.r0 = mCurrent_Task_Node->task->opened_files[r0]->Close();
            Unmap_File_Current(r0);

            break;
        }
        case NSWI_Filesystem_Service::IOCtl: {
            if (r0 > Max_Process_Opened_Files || !mCurrent_Task_Node->task->opened_files[r0])
                return;

            target.r0 = mCurrent_Task_Node->task->opened_files[r0]->IOCtl(static_cast<NIOCtl_Operation>(r1),
                                                                          reinterpret_cast<void*>(r2));
            break;
        }
        case NSWI_Filesystem_Service::Notify: {
            if (r0 > Max_Process_Opened_Files || !mCurrent_Task_Node->task->opened_files[r0])
                return;

            target.r0 = mCurrent_Task_Node->task->opened_files[r0]->Notify(r1);
            break;
        }
        case NSWI_Filesystem_Service::Wait: {
            if (r0 > Max_Process_Opened_Files || !mCurrent_Task_Node->task->opened_files[r0])
                return;

            mCurrent_Task_Node->task->notified_deadline = r2;

            // nastavme deadline, kdyby Wait nahodou neblokoval
            if (r2 != Deadline_Unchanged)
                mCurrent_Task_Node->task->deadline = r2;

            target.r0 = mCurrent_Task_Node->task->opened_files[r0]->Wait(r1);

            // v tento moment uz lze "budouci" deadline vymazat, uz je nastavena ve skutecne deadline bud shora nebo z
            // notify kodu
            mCurrent_Task_Node->task->notified_deadline = Deadline_Unchanged;
            break;
        }
    }
}

bool CProcess_Manager::Get_Scheduler_Info(NGet_Sched_Info_Type type, void* target)
{
    if (!target)
        return false;

    switch (type)
    {
        case NGet_Sched_Info_Type::Active_Process_Count: {
            CProcess_List_Node* node = mProcess_List_Head;
            uint32_t procCnt = 0;
            while (node)
            {
                if (node->task->state == NTask_State::Running || node->task->state == NTask_State::Runnable)
                    procCnt++;

                node = node->next;
            }

            *reinterpret_cast<uint32_t*>(target) = procCnt;
            break;
        }
        case NGet_Sched_Info_Type::Tick_Count: {
            *reinterpret_cast<uint32_t*>(target) = sTimer.Get_Tick_Count();
            break;
        }
        default:
            return false;
    }

    return true;
}
