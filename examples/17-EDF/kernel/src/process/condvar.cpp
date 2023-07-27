#include <process/condvar.h>
#include <process/process_manager.h>
#include <process/resource_manager.h>

CCondition_Variable::CCondition_Variable()
: IFile(NFile_Type_Major::Condition_Var)
{
    //
}

void CCondition_Variable::Reset(CMutex* mtx)
{
    mMutex = mtx;
}

bool CCondition_Variable::Close()
{
    sProcess_Resource_Manager.Free_Condition_Variable(this);

    return true;
}

bool CCondition_Variable::Wait(uint32_t count)
{
    Wait_Enqueue_Current();

    mMutex->Unlock();

    sProcessMgr.Block_Current_Process();

    mMutex->Lock();

    return true;
}

uint32_t CCondition_Variable::Notify(uint32_t count)
{
    return IFile::Notify(count);
}
