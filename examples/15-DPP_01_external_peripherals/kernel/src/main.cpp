#include <drivers/gpio.h>
#include <drivers/trng.h>
#include <drivers/timer.h>
#include <drivers/segmentdisplay.h>
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

// "main" procesu 1
extern void Process_1();
extern void Process_2();
extern void Process_3();
extern void Process_4();
extern void Process_5();

extern "C" int _kernel_main(void)
{
	// debug output, kdyz budeme neco ladit; jinak vyzadujeme, aby si proces UART otevrel a spravoval
	/*
	sUART0.Open();
	sUART0.Set_Baud_Rate(NUART_Baud_Rate::BR_115200);
	sUART0.Set_Char_Length(NUART_Char_Length::Char_8);

	sUART0.Write("Welcome to KIV/OS RPiOS kernel\r\n");
	sUART0.Close();
	*/

	sMonitor.Clear();

	// inicializace souboroveho systemu
	sFilesystem.Initialize();

	// vytvoreni hlavniho procesu
	// sProcessMgr.Create_Main_Process();

	sProcessMgr.Create_Process(reinterpret_cast<unsigned long>(&Process_1));
	sProcessMgr.Create_Process(reinterpret_cast<unsigned long>(&Process_2));
	sProcessMgr.Create_Process(reinterpret_cast<unsigned long>(&Process_3));
	sProcessMgr.Create_Process(reinterpret_cast<unsigned long>(&Process_4));
	sProcessMgr.Create_Process(reinterpret_cast<unsigned long>(&Process_5));

	// zatim zakazeme IRQ casovace
	sInterruptCtl.Disable_Basic_IRQ(hal::IRQ_Basic_Source::Timer);

	// nastavime casovac - v callbacku se provadi planovani procesu
	sTimer.Enable(Timer_Callback, 0x20, NTimer_Prescaler::Prescaler_256);

	// povolime IRQ casovace
	sInterruptCtl.Enable_Basic_IRQ(hal::IRQ_Basic_Source::Timer);

	// povolime IRQ a od tohoto momentu je vse v rukou planovace
	enable_irq();

	// nekonecna smycka - tadyodsud se CPU uz nedostane jinak, nez treba prerusenim
    while (1)
		;

	return 0;
}
