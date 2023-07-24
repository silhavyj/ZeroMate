#pragma once

#include <hal/peripherals.h>
#include <fs/filesystem.h>

#include "spinlock.h"

class CMutex : public IFile
{
private:
    // kdo aktualne drzi mutex?
    unsigned int mHolder_PID = 0;

    // stav zamku - odemceny
    spinlock_t mLock_State = Lock_Unlocked;

public:
    CMutex();

    // Mutex ma rozhrani vlastni pro jadro, a pak pro userspace (IFile)

    // zamykani mutexu - muze blokovat proces, pokud zrovna neni mutex volny
    // vraci true kdyz se povede zamknout, false kdyz uz mutex je zamceny procesem, ktery o to zada
    bool Lock();

    // pokusi se zamknout mutex - nikdy neblokuje
    // vraci true kdyz se povede zamknout, false kdyz ne, nebo je mutex jiz zamceny procesem, ktery o to zada
    bool Try_Lock();

    // odemkne mutex - nikdy neblokuje
    // vraci true pokud se povede odemknout, false pokud je mutex jiz odemceny nebo je vlastneny jinym procesem
    bool Unlock();

    // ziska PID drzitele
    unsigned int Get_Holder_PID() const
    {
        return mHolder_PID;
    }

    // rozhrani IFile - pro userspace

    // mutex nelze "cist"
    virtual uint32_t Read(char* buffer, uint32_t num) override
    {
        return 0;
    };
    // mutex nelze "zapisovat"
    virtual uint32_t Write(const char* buffer, uint32_t num) override
    {
        return 0;
    };

    // "zavreni" mutexu = dealokace ve spravci zdroju
    virtual bool Close() override;
    virtual bool IOCtl(NIOCtl_Operation dir, void* ctlptr) override
    {
        return false;
    };

    virtual bool Wait(uint32_t count) override
    {
        return Lock();
    }
    virtual uint32_t Notify(uint32_t count)
    {
        return Unlock();
    };
};
