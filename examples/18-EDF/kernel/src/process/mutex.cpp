#include <process/mutex.h>
#include <process/spinlock.h>
#include <process/process_manager.h>
#include <process/resource_manager.h>

#include <stdstring.h>

CMutex::CMutex()
: IFile(NFile_Type_Major::Mutex)
{
    spinlock_init(&mLock_State);
}

bool CMutex::Lock()
{
    auto* cur = sProcessMgr.Get_Current_Process();
    const unsigned int cpid = cur->pid;

    if (mHolder_PID == cpid)
        return false;

    while (spinlock_try_lock(&mLock_State) ==
           Lock_Locked) // try_lock vraci puvodni hodnotu zamku - pokud vrati "zamceno", zamknout se jiste nepovedlo
    {
        // vlozime ho do fronty cekajicich
        Wait_Enqueue_Current();

        // NOTE: tady by mohlo byt vhodne zavest podstav pro blokovany stav nad mutexem (a volat pak s parametrem)
        sProcessMgr.Block_Current_Process();
    }

    mHolder_PID = cpid;

    return true;
}

bool CMutex::Try_Lock()
{
    auto* cur = sProcessMgr.Get_Current_Process();
    const unsigned int cpid = cur->pid;

    if (mHolder_PID == cpid)
        return false;

    return spinlock_try_lock(&mLock_State);
}

bool CMutex::Unlock()
{
    auto* cur = sProcessMgr.Get_Current_Process();
    const unsigned int cpid = cur->pid;

    if (mHolder_PID != cpid || mLock_State != Lock_Locked)
        return false;

    mHolder_PID = 0;
    spinlock_unlock(&mLock_State);

    return IFile::Notify(1);
}

bool CMutex::Close()
{
    sProcess_Resource_Manager.Free_Mutex(this);

    return true;
}
