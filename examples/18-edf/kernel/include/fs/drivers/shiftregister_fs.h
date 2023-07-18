#pragma once

#include <drivers/shiftregister.h>
#include <hal/peripherals.h>
#include <memory/kernel_heap.h>
#include <fs/filesystem.h>
#include <stdstring.h>

// virtualni soubor pro posuvny registr
class CShift_Register_File final : public IFile
{
private:
    bool mOpened;

public:
    CShift_Register_File()
    : IFile(NFile_Type_Major::Character)
    , mOpened(true)
    {
        //
    }

    ~CShift_Register_File()
    {
        Close();
    }

    virtual uint32_t Read(char* buffer, uint32_t num) override
    {
        // neumime cist z posuvneho registru (samozrejme by to bylo mozne, jen ho tak nemame zapojeny)

        return 0;
    }

    virtual uint32_t Write(const char* buffer, uint32_t num) override
    {
        // umime jen znakovy pristup v tomto druhu souboru (tedy neumime nasouvat jednotlive bity)
        // teoreticky muze mit shift registr vice nez 8 bitu, tak proste nasuneme vsechno ze vstupu
        for (uint32_t i = 0; i < num; i++)
            sShift_Register.Shift_In(static_cast<uint8_t>(buffer[i]));

        return num;
    }

    virtual bool Close() override
    {
        if (!mOpened)
            return false;

        sShift_Register.Close();
        mOpened = false;

        return IFile::Close();
    }

    virtual bool IOCtl(NIOCtl_Operation dir, void* ctlptr) override
    {
        return false;
    }
};

class CShift_Register_FS_Driver : public IFilesystem_Driver
{
public:
    virtual void On_Register() override
    {
        //
    }

    virtual IFile* Open_File(const char* path, NFile_Open_Mode mode) override
    {
        // shift register je jen jeden a vyhrazeny, takze je jedno co je v ceste

        if (!sShift_Register.Open())
            return nullptr;

        CShift_Register_File* f = new CShift_Register_File();

        return f;
    }
};

CShift_Register_FS_Driver fsShift_Register_FS_Driver;
