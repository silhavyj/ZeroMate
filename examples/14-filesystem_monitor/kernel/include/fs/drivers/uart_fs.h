#pragma once

#include <drivers/monitor.h>
#include <hal/peripherals.h>
#include <memory/kernel_heap.h>
#include <fs/filesystem.h>
#include <stdstring.h>

extern "C" void enable_irq();
extern "C" void disable_irq();

// virtualni UART soubor
class CUART_File : public IFile
{
    private:
        // UART kanal
        int mChannel;

    public:
        CUART_File(int channel)
            : mChannel(channel)
        {
            //
        }

        ~CUART_File()
        {
            Close();
        }

        virtual uint32_t Read(char* buffer, uint32_t num) override
        {
            // NYI, prijde nejspis az s kernel buffery a prerusenimi z UARTu

            return 0;
        }

        virtual uint32_t Write(const char* buffer, uint32_t num) override
        {
            if (num > 0 && buffer != nullptr)
            {
                if (mChannel == 0)
                {
                    disable_irq();
                    sMonitor << buffer;
                    enable_irq();
                    return num;
                }
            }

            return 0;
        }

        virtual bool Close() override
        {
            if (mChannel < 0)
                return false;

            if (mChannel == 0)
            {

            }
        
            mChannel = -1;

            return true;
        }

        virtual bool IOCtl(NIOCtl_Operation dir, void* ctlptr) override
        {
            if (mChannel == 0)
            {
                return true;
            }

            return false;
        }
};

class CUART_FS_Driver : public IFilesystem_Driver
{
	public:
		virtual void On_Register() override
        {
            //
        }

        virtual IFile* Open_File(const char* path, NFile_Open_Mode mode) override
        {
            // jedina slozka path - kanal UARTu

            int channel = atoi(path);
            if (channel != 0) // mame jen jeden kanal
                return nullptr;

            CUART_File* f = new CUART_File(channel);

            return f;
        }
};

CUART_FS_Driver fsUART_FS_Driver;
