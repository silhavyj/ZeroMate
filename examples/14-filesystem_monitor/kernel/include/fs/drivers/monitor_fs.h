#pragma once

#include <drivers/monitor.h>
#include <hal/peripherals.h>
#include <memory/kernel_heap.h>
#include <fs/filesystem.h>
#include <stdstring.h>

class CMonitor_File : public IFile
{
    private:
        int mChannel;

    public:
        CMonitor_File(int channel)
            : mChannel(channel)
        {
        }

        ~CMonitor_File()
        {
            Close();
        }

        virtual uint32_t Read(char* buffer, uint32_t num) override
        {
            return 0;
        }

        virtual uint32_t Write(const char* buffer, uint32_t num) override
        {
            if (num > 0 && buffer != nullptr)
            {
                if (mChannel == 0)
                {
                    sMonitor << buffer;
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

class CMonitor_FS_Driver : public IFilesystem_Driver
{
	public:
		virtual void On_Register() override
        {
        }

        virtual IFile* Open_File(const char* path, NFile_Open_Mode mode) override
        {
            int channel = atoi(path);
            if (channel != 0)
                return nullptr;

            CMonitor_File* f = new CMonitor_File(channel);

            return f;
        }
};

CMonitor_FS_Driver fsMonitor_FS_Driver;
