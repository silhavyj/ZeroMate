#include <drivers/gpio.h>
#include <drivers/timer.h>
#include <drivers/monitor.h>
#include <interrupt_controller.h>

#include <memory/memmap.h>
#include <memory/kernel_heap.h>

#include <process/process_manager.h>

#include <fs/filesystem.h>

#include <stdstring.h>
#include <stdfile.h>

// externi funkce pro povoleni IRQ
extern "C" void enable_irq();

extern "C" void Timer_Callback()
{
    sProcessMgr.Schedule();
}

extern "C" unsigned char __idle_process[];
extern "C" unsigned char __proc_test_1[];
extern "C" unsigned char __proc_test_2[];
extern "C" unsigned int __idle_process_len;
extern "C" unsigned int __proc_test_1_len;
extern "C" unsigned int __proc_test_2_len;

extern "C" int _kernel_main(void)
{
    sMonitor.Clear();
    sMonitor << "Welcome to the kernel :)\n";

    // inicializace souboroveho systemu
    sFilesystem.Initialize();

    // vytvoreni hlavniho systemoveho (idle) procesu
    sProcessMgr.Create_Process(__idle_process, __idle_process_len, true);

    // vytvoreni jednoho testovaciho procesu
    sProcessMgr.Create_Process(__proc_test_1, __proc_test_1_len, false);
    // vytvoreni druheho testovaciho procesu
    sProcessMgr.Create_Process(__proc_test_2, __proc_test_2_len, false);

    sMonitor << "All processes have been created\n";

    // zatim zakazeme IRQ casovace
    sInterruptCtl.Disable_Basic_IRQ(hal::IRQ_Basic_Source::Timer);

    // nastavime casovac - v callbacku se provadi planovani procesu
    sTimer.Enable(Timer_Callback, 0x40, NTimer_Prescaler::Prescaler_256);

    // povolime IRQ casovace
    sInterruptCtl.Enable_Basic_IRQ(hal::IRQ_Basic_Source::Timer);

    // povolime IRQ a od tohoto momentu je vse v rukou planovace
    enable_irq();

    sProcessMgr.Schedule();

    // tohle uz se mockrat nespusti - dalsi IRQ preplanuje procesor na nejaky z tasku (bud systemovy nebo uzivatelsky)
    while (true)
        ;

    return 0;
}
