#pragma once

#include <drivers/trng.h>
#include <hal/peripherals.h>
#include <memory/kernel_heap.h>
#include <fs/filesystem.h>
#include <stdstring.h>

// virtualni TRNG soubor
class CTRNG_File : public IFile
{
private:
    bool mOpened;

public:
    CTRNG_File()
    {
        //
    }

    ~CTRNG_File()
    {
        Close();
    }

    virtual uint32_t Read(char* buffer, uint32_t num) override
    {
        const uint32_t wcount = num / 4;
        uint32_t* wbuf = reinterpret_cast<uint32_t*>(buffer);
        for (int i = 0; i < wcount; i++)
            wbuf[i] = sTRNG.Get_Random_Number();

        if (wcount * 4 != num)
        {
            // tohle by se dalo vyresit jednim generovanim a posunem na pozici, ale pro ted staci takhle
            // ted tomu trochu "krademe" entropii
            for (int i = wcount * 4; i < num; i++)
                buffer[i] = static_cast<uint8_t>(sTRNG.Get_Random_Number());
        }

        return 0;
    }

    virtual uint32_t Write(const char* buffer, uint32_t num) override
    {
        // do TRNG nelze zapisovat

        return 0;
    }

    virtual bool Close() override
    {
        if (!mOpened)
            return false;

        sTRNG.Close();
        mOpened = false;

        return true;
    }

    virtual bool IOCtl(NIOCtl_Operation dir, void* ctlptr) override
    {
        return false;
    }
};

class CTRNG_FS_Driver : public IFilesystem_Driver
{
public:
    virtual void On_Register() override
    {
        //
    }

    virtual IFile* Open_File(const char* path, NFile_Open_Mode mode) override
    {
        // TRNG je jen jeden a vyhrazeny, takze je jedno co je v ceste

        if (!sTRNG.Open(mode == NFile_Open_Mode::Read_Write)) // read_write povazujeme za "exkluzivni" mod
            return nullptr;

        CTRNG_File* f = new CTRNG_File();

        return f;
    }
};

CTRNG_FS_Driver fsTRNG_FS_Driver;
