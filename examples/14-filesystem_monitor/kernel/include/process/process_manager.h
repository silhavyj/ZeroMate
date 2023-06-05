#pragma once

#include <hal/intdef.h>

#include "process.h"
#include "swi.h"
#include <fs/filesystem.h>

// neplatny handle (procesu, souboru, ...)
constexpr uint32_t Invalid_Handle = static_cast<uint32_t>(-1);

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

    public:
        CProcess_Manager();

        // vytvori systemovy proces
        void Create_Main_Process();

        // vytvori proces, ktery bude vykonavat zadanou funkci, vraci jeho PID
        uint32_t Create_Process(unsigned long funcptr);

        // metoda, kterou se explicitne spusti planovac - muze byt volana z IRQ handleru casovace, nebo treba i ze SW preruseni (kdyz se proces zablokuje)
        void Schedule();

        // vrati strukturu procesu, ktery je v tento moment naplanovan
        TTask_Struct* Get_Current_Process() const;

        // namapuje otevreny soubor na handle
        uint32_t Map_File_To_Current(IFile* file);

        // odmapuje soubor z daneho handle
        bool Unmap_File_Current(uint32_t handle);

        // softwarova preruseni pro process facility
        void Handle_Process_SWI(NSWI_Process_Service svc_idx, uint32_t r0, uint32_t r1, uint32_t r2, TSWI_Result& target);
        // softwarova preruseni pro filesystem facility
        void Handle_Filesystem_SWI(NSWI_Filesystem_Service svc_idx, uint32_t r0, uint32_t r1, uint32_t r2, TSWI_Result& target);
};

extern CProcess_Manager sProcessMgr;
