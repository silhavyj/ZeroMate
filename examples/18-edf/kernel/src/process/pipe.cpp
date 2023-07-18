#include <process/pipe.h>
#include <memory/kernel_heap.h>
#include <process/process_manager.h>
#include <process/resource_manager.h>

CPipe::CPipe()
: IFile(NFile_Type_Major::Pipe)
{
    //
}

CPipe::~CPipe()
{
    //
}

void CPipe::Reset(uint32_t size)
{
    if (mSem_Free)
    {
        delete mSem_Free;
        mSem_Free = nullptr;
    }

    if (mSem_Busy)
    {
        delete mSem_Busy;
        mSem_Busy = nullptr;
    }

    if (mBuffer)
    {
        sKernelMem.Free(mBuffer);
        mBuffer = nullptr;
    }

    // pokud jsme prave alokovani, alokujeme semafory a buffer
    if (size > 0)
    {
        mSem_Free = new CSemaphore;
        mSem_Free->Reset(size, size);

        mSem_Busy = new CSemaphore;
        mSem_Busy->Reset(size, 0);

        mBuffer = reinterpret_cast<char*>(sKernelMem.Alloc(sizeof(char) * size));

        spinlock_init(&mBuffer_Lock);
    }
}

uint32_t CPipe::Read(char* buffer, uint32_t num)
{
    spinlock_lock(&mBuffer_Lock);

    num = (num > mSem_Busy->Get_Current_Count()) ? mSem_Busy->Get_Current_Count() : num;

    spinlock_unlock(&mBuffer_Lock);

    // pockame az bude tolik prostredku k dispozici
    mSem_Busy->Wait(num);

    // kriticka sekce
    spinlock_lock(&mBuffer_Lock);

    for (uint32_t i = 0; i < num; i++)
    {
        buffer[i] = mBuffer[mRead_Cur++];

        if (mRead_Cur >= mSem_Busy->Get_Max_Count())
            mRead_Cur = 0;
    }

    spinlock_unlock(&mBuffer_Lock);

    // notifikujeme producenty
    mSem_Free->Notify(num);

    return num;
}

uint32_t CPipe::Write(const char* buffer, uint32_t num)
{
    // pockame az bude tolik mista k dispozici
    mSem_Free->Wait(num);

    // kriticka sekce
    spinlock_lock(&mBuffer_Lock);

    for (uint32_t i = 0; i < num; i++)
    {
        mBuffer[mWrite_Cur++] = buffer[i];

        if (mWrite_Cur >= mSem_Busy->Get_Max_Count())
            mWrite_Cur = 0;
    }

    spinlock_unlock(&mBuffer_Lock);

    // notifikujeme konzumenty
    mSem_Busy->Notify(num);

    Notify(num);

    return num;
}

bool CPipe::Close()
{
    sProcess_Resource_Manager.Free_Pipe(this);

    return true;
}

bool CPipe::Wait(uint32_t count)
{
    spinlock_lock(&mBuffer_Lock);

    if (mSem_Busy->Get_Current_Count() >= count)
    {
        spinlock_unlock(&mBuffer_Lock);
        return true;
    }

    Wait_Enqueue_Current();

    spinlock_unlock(&mBuffer_Lock);

    sProcessMgr.Block_Current_Process();

    return true;
}

uint32_t CPipe::Notify(uint32_t count)
{
    return IFile::Notify(count);
}
