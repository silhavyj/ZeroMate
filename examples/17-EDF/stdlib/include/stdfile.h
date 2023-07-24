#pragma once

#include <hal/intdef.h>
#include <process/swi.h>
#include <fs/filesystem.h>
#include <process/process_manager.h>

uint32_t getpid();
void terminate(int exitcode);
void sched_yield();
uint32_t get_active_process_count();
uint32_t get_tick_count();
void set_task_deadline(uint32_t tick_count_required);
uint32_t get_task_ticks_to_deadline();

uint32_t open(const char* filename, NFile_Open_Mode mode);
uint32_t read(uint32_t file, char* const buffer, uint32_t size);
uint32_t write(uint32_t file, const char* buffer, uint32_t size);
void close(uint32_t file);
uint32_t ioctl(uint32_t file, NIOCtl_Operation operation, void* param);
uint32_t notify(uint32_t file, uint32_t count = 1);
NSWI_Result_Code wait(uint32_t file, uint32_t count = 1, uint32_t notified_deadline = Deadline_Unchanged);
bool sleep(uint32_t ticks, uint32_t notified_deadline = Deadline_Unchanged);

uint32_t pipe(const char* name, uint32_t buf_size);
