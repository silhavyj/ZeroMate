#pragma once

#include <hal/intdef.h>

#include "process.h"

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
};

extern CProcess_Manager sProcessMgr;
