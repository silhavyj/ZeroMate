#pragma once

#include <hal/peripherals.h>
#include <fs/filesystem.h>
#include "mutex.h"

#include "spinlock.h"

class CCondition_Variable : public IFile
{
private:
    CMutex* mMutex;

public:
    CCondition_Variable();

    void Reset(CMutex* mtx);

    // rozhrani IFile - pro userspace

    // nelze "cist"
    virtual uint32_t Read(char* buffer, uint32_t num) override
    {
        return 0;
    };
    // nelze "zapisovat"
    virtual uint32_t Write(const char* buffer, uint32_t num) override
    {
        return 0;
    };

    // "zavreni" podminkove promenne = dealokace ve spravci zdroju
    virtual bool Close() override;
    virtual bool IOCtl(NIOCtl_Operation dir, void* ctlptr) override
    {
        return false;
    };

    virtual bool Wait(uint32_t count) override;
    virtual uint32_t Notify(uint32_t count);
};
