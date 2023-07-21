#pragma once

#include <hal/peripherals.h>
#include <fs/filesystem.h>
#include <stdstring.h>
#include <process/semaphore.h>
#include <process/resource_manager.h>

// driver pro filesystem pro semafory
class CSemaphore_FS_Driver : public IFilesystem_Driver
{
public:
    virtual void On_Register() override
    {
        //
    }

    virtual IFile* Open_File(const char* path, NFile_Open_Mode mode) override
    {
        // SYS:sem/semaf#16
        // SYS:sem/semaf#?
        // SYS:sem/semaf

        char semname[Max_Semaphore_Name_Length];
        strncpy(semname, path, Max_Semaphore_Name_Length);

        const int len = strlen(semname);
        uint32_t rescnt = Semaphore_Initial_Res_Count_Unknown;
        for (int i = 1; i < len - 1; i++)
        {
            if (semname[i] == '#')
            {
                semname[i] = '\0';
                // explicitne receno, ze nevime, kolik zdroju ma semafor mit
                if (semname[i + 1 == '?'])
                    break;

                rescnt = atoi(&semname[i + 1]);
                break;
            }
        }

        return sProcess_Resource_Manager.Alloc_Semaphore(semname, rescnt);
    }
};

CSemaphore_FS_Driver fsSemaphore_FS_Driver;
