#pragma once

#include <hal/intdef.h>

#include "process.h"
#include "swi.h"
#include <fs/filesystem.h>

// neplatny handle (procesu, souboru, ...)
constexpr uint32_t Invalid_Handle = static_cast<uint32_t>(-1);

// podtypy pro Get_Sched_Info syscall
enum class NGet_Sched_Info_Type
{
    Active_Process_Count = 0, // pocet procesu, ktere jsou aktivne planovane (Runnable + Running)
    Tick_Count = 1,           // pocet ticku casovace
};

// deadline syscall
enum class NDeadline_Subservice
{
    Set_Relative = 0,  // nastaveni deadline
    Get_Remaining = 1, // ziska zbyvajici cas do deadline
};

// struktura uzlu v seznamu procesu
struct CProcess_List_Node
{
    CProcess_List_Node* prev;
    CProcess_List_Node* next;
    TTask_Struct* task;
};

class CProcess_Manager
{
private:
    // posledni pridelene PID
    uint32_t mLast_PID;

    // uvodni uzel spojoveho seznamu procesu
    CProcess_List_Node* mProcess_List_Head;

    // uzel procesu, ktery je prave naplanovan
    CProcess_List_Node* mCurrent_Task_Node;

private:
    void Switch_To(CProcess_List_Node* node);

    bool Notify_Process(TTask_Struct* proc);

protected:
    // round-robin planovac (se statickou prioritou)
    CProcess_List_Node* Schedule_RR();
    // earliest deadline first (real-time) planovac
    CProcess_List_Node* Schedule_EDF();

    CProcess_List_Node* (CProcess_Manager::*mSchedule_Fnc)() = nullptr;

public:
    CProcess_Manager();

    // vytvori proces, ktery bude vykonavat zadanou funkci, vraci jeho PID; volitelne muze jit o systemovy proces
    uint32_t Create_Process(unsigned char* elf_file_data, unsigned int elf_file_length, bool is_system);

    // metoda, kterou se explicitne spusti planovac - muze byt volana z IRQ handleru casovace, nebo treba i ze SW
    // preruseni (kdyz se proces zablokuje)
    void Schedule();

    // vrati strukturu procesu, ktery je v tento moment naplanovan
    TTask_Struct* Get_Current_Process() const;

    // vrati strukturu procesu se zadanym PID, nebo nullptr, pokud proces neexistuje
    TTask_Struct* Get_Process_By_PID(uint32_t pid) const;

    // blokuje soucasny proces (zatim v generickem stavu "Blocked"), preplanuje na jiny proces
    void Block_Current_Process();
    // notifikuje blokovany proces (napr. spici nad mutexem, souborem, ...)
    bool Notify_Process(uint32_t pid);

    // namapuje otevreny soubor na handle
    uint32_t Map_File_To_Current(IFile* file);

    // odmapuje soubor z daneho handle
    bool Unmap_File_Current(uint32_t handle);

    // softwarova preruseni pro process facility
    void Handle_Process_SWI(NSWI_Process_Service svc_idx, uint32_t r0, uint32_t r1, uint32_t r2, TSWI_Result& target);
    // softwarova preruseni pro filesystem facility
    void
    Handle_Filesystem_SWI(NSWI_Filesystem_Service svc_idx, uint32_t r0, uint32_t r1, uint32_t r2, TSWI_Result& target);

    // ziska info z planovace
    bool Get_Scheduler_Info(NGet_Sched_Info_Type type, void* target);
};

extern CProcess_Manager sProcessMgr;
