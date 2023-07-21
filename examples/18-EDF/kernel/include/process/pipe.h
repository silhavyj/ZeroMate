#pragma once

#include <fs/filesystem.h>

#include "semaphore.h"
#include "spinlock.h"

class CPipe final : public IFile
{
private:
    CSemaphore* mSem_Free = nullptr;
    CSemaphore* mSem_Busy = nullptr;

    char* mBuffer = nullptr;
    uint32_t mWrite_Cur = 0;
    uint32_t mRead_Cur = 0;

    spinlock_t mBuffer_Lock;

public:
    CPipe();
    ~CPipe();

    void Reset(uint32_t size);

    // rozhrani IFile

    virtual uint32_t Read(char* buffer, uint32_t num) override;
    virtual uint32_t Write(const char* buffer, uint32_t num) override;
    virtual bool Close() override;
    virtual bool Wait(uint32_t count) override;
    virtual uint32_t Notify(uint32_t count) override;
};
