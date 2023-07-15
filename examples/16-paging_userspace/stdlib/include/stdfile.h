#pragma once

#include <hal/intdef.h>
#include <process/swi.h>
#include <fs/filesystem.h>

uint32_t getpid();
void terminate(int exitcode);
void sched_yield();

uint32_t open(const char* filename, NFile_Open_Mode mode);
uint32_t read(uint32_t file, char* const buffer, uint32_t size);
uint32_t write(uint32_t file, const char* buffer, uint32_t size);
void close(uint32_t file);
uint32_t ioctl(uint32_t file, NIOCtl_Operation operation, void* param);
