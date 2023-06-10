#include <process/process_manager.h>
#include <drivers/monitor.h>

#include <memory/kernel_heap.h>
#include <memory/pages.h>
#include <memory/memmap.h>

#include <fs/filesystem.h>

// "importovane" funkce z asm
extern "C" {
void process_bootstrap();
void context_switch(TCPU_Context* ctx_to, TCPU_Context* ctx_from);
void context_switch_first(TCPU_Context* ctx_to, TCPU_Context* ctx_from);
};

CProcess_Manager sProcessMgr;

CProcess_Manager::CProcess_Manager()
: mLast_PID(0)
, mProcess_List_Head(nullptr)
, mCurrent_Task_Node(nullptr)
{
    //
}

TTask_Struct* CProcess_Manager::Get_Current_Process() const
{
    return mCurrent_Task_Node ? mCurrent_Task_Node->task : nullptr;
}

void CProcess_Manager::Create_Main_Process()
{
    CProcess_List_Node* procnode = sKernelMem.Alloc<CProcess_List_Node>();

    procnode->next = mProcess_List_Head;
    procnode->prev = nullptr;
    mProcess_List_Head->prev = procnode;

    procnode->task = sKernelMem.Alloc<TTask_Struct>();

    auto* task = procnode->task;

    task->pid = ++mLast_PID;
    task->sched_static_priority =
    5; // TODO: pro ted je to jen hardcoded hodnota, do budoucna urcite bude nutne dovolit specifikovat
    task->sched_counter = task->sched_static_priority;
    task->state = NTask_State::Running;

    for (uint32_t i = 0; i < Max_Process_Opened_Files; i++)
        task->opened_files[i] = nullptr;

    mCurrent_Task_Node = mProcess_List_Head;
}

uint32_t CProcess_Manager::Create_Process(unsigned long funcptr)
{
    CProcess_List_Node* procnode = sKernelMem.Alloc<CProcess_List_Node>();

    procnode->next = mProcess_List_Head;
    procnode->prev = nullptr;
    mProcess_List_Head->prev = procnode;
    mProcess_List_Head = procnode;

    if (mCurrent_Task_Node == nullptr)
    {
        mCurrent_Task_Node = procnode;
    }

    procnode->task = sKernelMem.Alloc<TTask_Struct>();

    auto* task = procnode->task;

    task->pid = ++mLast_PID;
    task->sched_static_priority =
    5; // TODO: pro ted je to jen hardcoded hodnota, do budoucna urcite bude nutne dovolit specifikovat
    task->sched_counter = task->sched_static_priority;
    task->state = NTask_State::New;

    task->cpu_context.lr = funcptr;
    task->cpu_context.pc = reinterpret_cast<unsigned long>(&process_bootstrap);
    task->cpu_context.sp = static_cast<unsigned long>(sPage_Manager.Alloc_Page()) + mem::PageSize;

    for (uint32_t i = 0; i < Max_Process_Opened_Files; i++)
        task->opened_files[i] = nullptr;

    sMonitor << "Created process with pid " << (unsigned int)task->pid << " ("
             << "SP = 0x" << CMonitor::NNumber_Base::HEX << (unsigned int)task->cpu_context.sp << ")\n";

    return task->pid;
}

void CProcess_Manager::Schedule()
{
    // je nejaky proces naplanovany?
    if (mCurrent_Task_Node)
    {
        // snizime citac planovace
        mCurrent_Task_Node->task->sched_counter--;
        // pokud je citac vetsi nez 0, zatim nebudeme preplanovavat (a zaroven je proces stale ve stavu Running -
        // nezablokoval se nad necim)
        if (mCurrent_Task_Node->task->sched_counter > 0 && mCurrent_Task_Node->task->state == NTask_State::Running)
            return;
    }

    // najdeme dalsi proces na planovani

    // vybereme dalsi proces v rade
    CProcess_List_Node* next = mCurrent_Task_Node ? mCurrent_Task_Node->next : mProcess_List_Head;
    if (!next)
        next = mProcess_List_Head;

    // proces k naplanovani musi bud byt ve stavu runnable (jiz nekdy bezel a muze bezet znovu) nebo running (pak jde o
    // stavajici proces) a nebo new (novy proces, ktery jeste nebyl planovany)
    while (next->task->state != NTask_State::Runnable && next->task->state != NTask_State::Running &&
           next->task->state != NTask_State::New)
    {
        if (!next)
        {
            next = mCurrent_Task_Node;
            break;
        }
        else
            next = next->next;
    }

    // stavajici proces je jediny planovatelny - nemusime nic preplanovavat
    if (next == mCurrent_Task_Node)
    {
        // nastavime mu zase zpatky jeho pridel casovych kvant a vracime se
        mCurrent_Task_Node->task->sched_counter = mCurrent_Task_Node->task->sched_static_priority;
        return;
    }

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
            target.r0 = mCurrent_Task_Node->task->pid;
            break;
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
    }
}
