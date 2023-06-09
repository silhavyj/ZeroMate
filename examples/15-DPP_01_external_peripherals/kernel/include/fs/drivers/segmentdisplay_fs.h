#pragma once

#include <drivers/segmentdisplay.h>
#include <hal/peripherals.h>
#include <memory/kernel_heap.h>
#include <fs/filesystem.h>
#include <stdstring.h>

// virtualni soubor pro segmentovy displej
class CSegment_Display_File : public IFile
{
    private:
        bool mOpened;

    public:
        CSegment_Display_File()
            : mOpened(true)
        {
            //
        }

        ~CSegment_Display_File()
        {
            Close();
        }

        virtual uint32_t Read(char* buffer, uint32_t num) override
        {
            // jen precteme posledni zapsany znak
            if (num > 0)
            {
                buffer[0] = sSegment_Display.Read();
                return 1;
            }

            return 0;
        }

        virtual uint32_t Write(const char* buffer, uint32_t num) override
        {
            // zapiseme vsechny znaky ze vstupu
            for (uint32_t i = 0; i < num; i++)
                sSegment_Display.Write(buffer[i]);

            return num;
        }

        virtual bool Close() override
        {
            if (!mOpened)
                return false;

            sSegment_Display.Close();
            mOpened = false;

            return true;
        }

        virtual bool IOCtl(NIOCtl_Operation dir, void* ctlptr) override
        {
            return false;
        }
};

class CSegment_Display_FS_Driver : public IFilesystem_Driver
{
	public:
		virtual void On_Register() override
        {
            //
        }

        virtual IFile* Open_File(const char* path, NFile_Open_Mode mode) override
        {
            // segmentovy displej je jen jeden a vyhrazeny, takze je jedno co je v ceste

            if (!sSegment_Display.Open())
                return nullptr;

            CSegment_Display_File* f = new CSegment_Display_File();

            return f;
        }
};

CSegment_Display_FS_Driver fsSegment_Display_FS_Driver;
