#include <stdmutex.h>
#include <stdfile.h>
#include <stdstring.h>

static const char Mutex_File_Prefix[] = "SYS:mtx/";
static const char Sem_File_Prefix[] = "SYS:sem/";

mutex_t mutex_create(const char* name)
{
    char mtxfile[64];
    strncpy(mtxfile, Mutex_File_Prefix, sizeof(Mutex_File_Prefix));
    strncpy(mtxfile + sizeof(Mutex_File_Prefix), name, sizeof(mtxfile) - sizeof(Mutex_File_Prefix) - 1);

    mutex_t mtx = static_cast<mutex_t>(open(mtxfile, NFile_Open_Mode::Read_Write));

    return mtx;
}

bool mutex_lock(mutex_t mtx)
{
    NSWI_Result_Code res = wait(mtx);

    return (res == NSWI_Result_Code::OK);
}

bool mutex_unlock(mutex_t mtx)
{
    uint32_t res = notify(mtx);

    return true;
}

void mutex_destroy(mutex_t mtx)
{
    close(mtx);
}

semaphore_t sem_create(const char* name)
{
    char semfile[64];
    strncpy(semfile, Sem_File_Prefix, sizeof(Sem_File_Prefix));
    strncpy(semfile + sizeof(Sem_File_Prefix), name, sizeof(semfile) - sizeof(Sem_File_Prefix) - 1);

    semaphore_t sem = static_cast<semaphore_t>(open(semfile, NFile_Open_Mode::Read_Write));

    return sem;
}

bool sem_acquire(semaphore_t sem, uint32_t count)
{
    NSWI_Result_Code res = wait(sem, count);

    return (res == NSWI_Result_Code::OK);
}

bool sem_release(semaphore_t sem, uint32_t count)
{
    uint32_t res = notify(sem, count);

    return true;
}

void sem_destroy(semaphore_t sem)
{
    close(sem);
}
