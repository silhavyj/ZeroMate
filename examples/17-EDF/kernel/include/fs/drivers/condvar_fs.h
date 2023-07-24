#pragma once

#include <hal/peripherals.h>
#include <fs/filesystem.h>
#include <process/condvar.h>
#include <process/resource_manager.h>

// driver pro filesystem pro podminkove promenne
class CCond_Var_FS_Driver : public IFilesystem_Driver
{
public:
    virtual void On_Register() override
    {
        //
    }

    virtual IFile* Open_File(const char* path, NFile_Open_Mode mode) override
    {
        // SYS:cv/podminka
        return sProcess_Resource_Manager.Alloc_Condition_Variable(path);
    }
};

CCond_Var_FS_Driver fsCond_Var_FS_Driver;
