#pragma once

#include <hal/intdef.h>

#include "mutex.h"
#include "semaphore.h"
#include "condvar.h"
#include "pipe.h"

// pocet predalokovanych mutexu (a zaroven max. pocet)
constexpr uint32_t Mutex_Count = 32;
// maximalni delka jmena mutexu
constexpr uint32_t Max_Mutex_Name_Length = 16;

// pocet predalokovanych semaforu (a zaroven max. pocet)
constexpr uint32_t Semaphore_Count = 16;
// maximalni delka jmena semaforu
constexpr uint32_t Max_Semaphore_Name_Length = 16;

// pocet predalokovanych podminkovych promennych (a zaroven max. pocet)
constexpr uint32_t Cond_Var_Count = 16;
// maximalni delka jmena podminkove promenne
constexpr uint32_t Max_Cond_Var_Name_Length = 16;

// pocet predalokovanych pipe (a zaroven max. pocet)
constexpr uint32_t Pipe_Count = 16;
// maximalni delka jmena pipe
constexpr uint32_t Max_Pipe_Name_Length = 16;

// pri otevirani semaforu = pokud uz musel byt semafor otevreny
constexpr uint32_t Semaphore_Initial_Res_Count_Unknown = static_cast<uint32_t>(-1);
// pokud je pri otevirani pipe velikost neznama
constexpr uint32_t Pipe_Byte_Count_Unknown = static_cast<uint32_t>(-1);

class CProcess_Resource_Manager
{
private:
    struct TMutex_Record
    {
        CMutex mtx;
        char name[Max_Mutex_Name_Length];
        unsigned int alloc_count;
    };

    struct TSemaphore_Record
    {
        CSemaphore semaphore;
        char name[Max_Semaphore_Name_Length];
        unsigned int alloc_count;
    };

    struct TCond_Var_Record
    {
        CCondition_Variable cv;
        char name[Max_Cond_Var_Name_Length];
        unsigned int alloc_count;
    };

    struct TPipe_Record
    {
        CPipe pipe;
        char name[Max_Pipe_Name_Length];
        unsigned int alloc_count;
    };

    TMutex_Record mMutexes[Mutex_Count];
    TSemaphore_Record mSemaphores[Semaphore_Count];
    TCond_Var_Record mCondVars[Cond_Var_Count];
    TPipe_Record mPipes[Pipe_Count];

public:
    CProcess_Resource_Manager();
    ~CProcess_Resource_Manager();

    CMutex* Alloc_Mutex(const char* name);
    void Free_Mutex(CMutex* mtx);

    CSemaphore* Alloc_Semaphore(const char* name, uint32_t initial_res_count = Semaphore_Initial_Res_Count_Unknown);
    void Free_Semaphore(CSemaphore* sem);

    CCondition_Variable* Alloc_Condition_Variable(const char* name);
    void Free_Condition_Variable(CCondition_Variable* cv);

    CPipe* Alloc_Pipe(const char* name, uint32_t pipe_size);
    void Free_Pipe(CPipe* pipe);
};

extern CProcess_Resource_Manager sProcess_Resource_Manager;
