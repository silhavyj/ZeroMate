#include <drivers/gpio.h>
#include <drivers/monitor.h>
#include <drivers/timer.h>
#include <interrupt_controller.h>

#include <memory/memmap.h>
#include <memory/kernel_heap.h>

#include <process/process_manager.h>

#include <fs/filesystem.h>

#include <stdstring.h>
#include <stdfile.h>

extern "C" void Timer_Callback()
{
    sProcessMgr.Schedule();
}

extern "C" unsigned char __init_task[];
extern "C" unsigned int __init_task_len;

extern "C" unsigned char __sos_task[];
extern "C" unsigned int __sos_task_len;

extern "C" unsigned char __oled_task[];
extern "C" unsigned int __oled_task_len;

extern "C" unsigned char __logger_task[];
extern "C" unsigned int __logger_task_len;

extern "C" unsigned char __counter_task[];
extern "C" unsigned int __counter_task_len;

extern "C" unsigned char __tilt_task[];
extern "C" unsigned int __tilt_task_len;

extern "C" int _kernel_main(void)
{
    sMonitor.Clear();
    sMonitor << "Welcome to the kernel :)\n";

    // inicializace souboroveho systemu
    sFilesystem.Initialize();

    // vytvoreni hlavniho systemoveho (idle) procesu
    sProcessMgr.Create_Process(__init_task, __init_task_len, true);

    // vytvoreni vsech tasku
    // TODO: presunuti do init procesu a nejake inicializacni sekce
    sProcessMgr.Create_Process(__sos_task, __sos_task_len, false);
    // sProcessMgr.Create_Process(__oled_task, __oled_task_len, false);
    sProcessMgr.Create_Process(__logger_task, __logger_task_len, false);
    sProcessMgr.Create_Process(__counter_task, __counter_task_len, false);
    sProcessMgr.Create_Process(__tilt_task, __tilt_task_len, false);

    // zatim zakazeme IRQ casovace
    sInterruptCtl.Disable_Basic_IRQ(hal::IRQ_Basic_Source::Timer);

    // nastavime casovac - v callbacku se provadi planovani procesu
    sTimer.Enable(Timer_Callback, 0x40, NTimer_Prescaler::Prescaler_256);

    // povolime IRQ casovace
    sInterruptCtl.Enable_Basic_IRQ(hal::IRQ_Basic_Source::Timer);

    // povolime IRQ (nebudeme je maskovat) a od tohoto momentu je vse v rukou planovace
    sInterruptCtl.Set_Mask_IRQ(false);

    // vynutime prvni spusteni planovace
    sProcessMgr.Schedule();

    // tohle uz se mockrat nespusti - dalsi IRQ preplanuje procesor na nejaky z tasku (bud systemovy nebo uzivatelsky)
    while (true)
        ;

    return 0;
}
