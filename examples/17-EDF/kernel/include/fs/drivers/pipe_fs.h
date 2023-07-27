#pragma once

#include <hal/peripherals.h>
#include <fs/filesystem.h>
#include <stdstring.h>
#include <process/pipe.h>
#include <process/resource_manager.h>

// driver pro filesystem pro roury
class CPipe_FS_Driver : public IFilesystem_Driver
{
public:
    virtual void On_Register() override
    {
        //
    }

    virtual IFile* Open_File(const char* path, NFile_Open_Mode mode) override
    {
        // SYS:pipe/roura#16
        // SYS:pipe/roura#?
        // SYS:pipe/roura

        /*char pipename[Max_Pipe_Name_Length];
        strncpy(pipename, path, Max_Pipe_Name_Length);

        const int len = strlen(pipename);
        uint32_t pipesize = Pipe_Byte_Count_Unknown;
        for (int i = 1; i < len - 1; i++)
        {
            if (pipename[i] == '#')
            {
                pipename[i] = '\0';
                // explicitne receno, ze nevime, jak velka ma pipe byt
                if (pipename[i + 1 == '?'])
                    break;

                pipesize = atoi(&pipename[i + 1]);
                break;
            }
        }*/

        return sProcess_Resource_Manager.Alloc_Pipe("roura", 32 /*pipename, pipesize*/);
    }
};

CPipe_FS_Driver fsPipe_FS_Driver;
