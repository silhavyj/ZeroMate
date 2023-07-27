#pragma once

#include <hal/peripherals.h>
#include <fs/filesystem.h>
#include <process/mutex.h>
#include <process/resource_manager.h>

// driver pro filesystem pro mutexy
class CMutex_FS_Driver : public IFilesystem_Driver
{
public:
    virtual void On_Register() override
    {
        //
    }

    virtual IFile* Open_File(const char* path, NFile_Open_Mode mode) override
    {
        // SYS:mtx/zamek
        return sProcess_Resource_Manager.Alloc_Mutex(path);
    }
};

CMutex_FS_Driver fsMutex_FS_Driver;
