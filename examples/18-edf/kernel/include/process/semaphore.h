#pragma once

#include <fs/filesystem.h>
#include <process/spinlock.h>

class CSemaphore final : public IFile
{
private:
    uint32_t mSemaphore_Count = 0;
    uint32_t mSemaphore_Max_Count = 0;

    spinlock_t mLock;

public:
    CSemaphore();
    ~CSemaphore();

    void Reset(uint32_t count = 0, uint32_t initial_count = 0);

    uint32_t Get_Current_Count() const
    {
        return mSemaphore_Count;
    }
    uint32_t Get_Max_Count() const
    {
        return mSemaphore_Max_Count;
    }

    // rozhrani IFile

    virtual uint32_t Read(char* buffer, uint32_t num) override;
    virtual uint32_t Write(const char* buffer, uint32_t num) override;
    virtual bool Close() override;
    virtual bool Wait(uint32_t count) override;
    virtual uint32_t Notify(uint32_t count) override;
};
