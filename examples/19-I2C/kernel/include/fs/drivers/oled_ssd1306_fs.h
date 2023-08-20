#pragma once

#include <drivers/oled_ssd1306.h>
#include <drivers/monitor.h>
#include <hal/peripherals.h>
#include <memory/kernel_heap.h>
#include <fs/filesystem.h>
#include <stdstring.h>

// virtualni soubor pro OLED displej
class COLED_Display_File : public IFile
{
private:
    bool mOpened;

public:
    COLED_Display_File()
    : mOpened(true)
    {
        //
    }

    ~COLED_Display_File()
    {
        Close();
    }

    virtual uint32_t Read(char* buffer, uint32_t num) override
    {
        // neumime cist zatim - maximalne pro odezvy v ramci protokolu, ale to pro ted neni dulezite

        return 0;
    }

    virtual uint32_t Write(const char* buffer, uint32_t num) override
    {
        sDisplay_SSD1306.Process_External_Command(buffer, num);

        return num;
    }

    virtual bool Close() override
    {
        if (!mOpened)
            return false;

        sDisplay_SSD1306.Close();
        mOpened = false;

        return true;
    }

    virtual bool IOCtl(NIOCtl_Operation dir, void* ctlptr) override
    {
        return false;
    }
};

class COLED_Display_FS_Driver : public IFilesystem_Driver
{
public:
    virtual void On_Register() override
    {
        //
    }

    virtual IFile* Open_File(const char* path, NFile_Open_Mode mode) override
    {
        // OLED displej je jen jeden a vyhrazeny, takze je jedno co je v ceste

        if (!sDisplay_SSD1306.Open(128, 32)) // velikost by se dala nastavovat jinudy, napr. ioctl nebo protokolem; pro
                                             // jednoduchost to zkratime takhle
            return nullptr;

        COLED_Display_File* f = new COLED_Display_File();

        return f;
    }
};

COLED_Display_FS_Driver fsOLED_Display_FS_Driver;
