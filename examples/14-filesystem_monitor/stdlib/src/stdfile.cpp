#include <stdfile.h>

uint32_t getpid()
{
    uint32_t pid;

    asm volatile("swi 0");
    asm volatile("mov %0, r0" : "=r" (pid));

    return pid;
}

uint32_t open(const char* filename, NFile_Open_Mode mode)
{
    uint32_t file;

    asm volatile("mov r0, %0" : : "r" (filename));
    asm volatile("mov r1, %0" : : "r" (mode));
    asm volatile("swi 64");
    asm volatile("mov %0, r0" : "=r" (file));

    return file;
}

uint32_t read(uint32_t file, char* const buffer, uint32_t size)
{
    uint32_t rdnum;

    asm volatile("mov r0, %0" : : "r" (file));
    asm volatile("mov r1, %0" : : "r" (buffer));
    asm volatile("mov r2, %0" : : "r" (size));
    asm volatile("swi 65");
    asm volatile("mov %0, r0" : "=r" (rdnum));

    return rdnum;
}

uint32_t write(uint32_t file, const char* buffer, uint32_t size)
{
    uint32_t wrnum;

    asm volatile("mov r0, %0" : : "r" (file));
    asm volatile("mov r1, %0" : : "r" (buffer));
    asm volatile("mov r2, %0" : : "r" (size));
    asm volatile("swi 66");
    asm volatile("mov %0, r0" : "=r" (wrnum));

    return wrnum;
}

void close(uint32_t file)
{
    asm volatile("mov r0, %0" : : "r" (file));
    asm volatile("swi 67");
}

uint32_t ioctl(uint32_t file, NIOCtl_Operation operation, void* param)
{
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    asm volatile("mov r1, %0" : : "r" (operation));
    asm volatile("mov r2, %0" : : "r" (param));
    asm volatile("swi 68");
    asm volatile("mov %0, r0" : "=r" (retcode));

    return retcode;
}
