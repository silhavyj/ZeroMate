#include <process/semaphore.h>
#include <process/process_manager.h>
#include <process/resource_manager.h>

CSemaphore::CSemaphore()
: IFile(NFile_Type_Major::Semaphore)
{
    //
}

CSemaphore::~CSemaphore()
{
    Close();
}

uint32_t CSemaphore::Read(char* buffer, uint32_t num)
{
    // dovolime jen cist aktualne dostupny pocet zdroju
    if (mSemaphore_Max_Count && num >= sizeof(uint32_t) && buffer)
    {
        *reinterpret_cast<uint32_t*>(buffer) = mSemaphore_Count;
        return sizeof(uint32_t);
    }

    return 0;
}

uint32_t CSemaphore::Write(const char* buffer, uint32_t num)
{
    return 0;
}

bool CSemaphore::Close()
{
    if (mSemaphore_Max_Count > 0)
        sProcess_Resource_Manager.Free_Semaphore(this);

    return IFile::Close();
}

bool CSemaphore::Wait(uint32_t count)
{
    spinlock_lock(&mLock);

    // TODO: kdyz count > 1, pak musi byt fronta trochu slozitejsi (nelze pak vzdy probouzet vrchni proces)

    while (mSemaphore_Count < count)
    {
        Wait_Enqueue_Current();

        spinlock_unlock(&mLock);

        sProcessMgr.Block_Current_Process();

        spinlock_lock(&mLock);
    }

    mSemaphore_Count -= count;

    spinlock_unlock(&mLock);

    return true;
}

uint32_t CSemaphore::Notify(uint32_t count)
{
    spinlock_lock(&mLock);

    // orez na maximalni pocet zdroju
    if (mSemaphore_Count + count > mSemaphore_Max_Count)
        count = mSemaphore_Max_Count - mSemaphore_Count;

    // zjistime, kolik jsme realne probudili procesu
    uint32_t real_notify_cnt = IFile::Notify(count);

    // zdroje pricteme k semaforu (probuzene tasky si je zase odectou dle potreby)
    mSemaphore_Count += count;

    spinlock_unlock(&mLock);

    // vracime pocet probuzenych
    return real_notify_cnt;
}

void CSemaphore::Reset(uint32_t count, uint32_t initial_count)
{
    mSemaphore_Max_Count = count;
    mSemaphore_Count = initial_count;

    spinlock_init(&mLock);
}
