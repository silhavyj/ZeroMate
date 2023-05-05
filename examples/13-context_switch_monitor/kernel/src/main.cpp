#include <drivers/gpio.h>
#include <drivers/timer.h>
#include <interrupt_controller.h>
#include <drivers/monitor.h>

#include <memory/memmap.h>
#include <memory/kernel_heap.h>

#include <process/process_manager.h>

#include <stdstring.h>

// je LEDka zapnuta?
volatile bool LED_State = false;

// GPIO pin 47 je pripojeny na LED na desce (tzv. ACT LED)
constexpr uint32_t ACT_Pin = 47;

// externi funkce pro povoleni IRQ
extern "C" void enable_irq();
extern "C" void disable_irq();

extern "C" void Timer_Callback()
{
	sProcessMgr.Schedule();

	sGPIO.Set_Output(ACT_Pin, LED_State);
	LED_State = !LED_State;
}

extern "C" void Process_1()
{
	volatile int i;

	//sUART0.Write("Process 1\r\n");
    sGPIO.Set_GPIO_Function(49, NGPIO_Function::Output);
    bool state = true;

	while (true)
	{
        sGPIO.Set_Output(49, state);
        
	//	sUART0.Write('1');
        
        disable_irq();
    	sMonitor << "1";
        enable_irq();

		for (i = 0; i < 0x100; i++)
			;
        
        state = !state;
	}
}

extern "C" void Process_2()
{
	volatile int i;

	//sUART0.Write("Process 2\r\n");
    sGPIO.Set_GPIO_Function(50, NGPIO_Function::Output);
    bool state = true;

	while (true)
	{
		//sUART0.Write('2');
        sGPIO.Set_Output(50, state);

        disable_irq();
		sMonitor << "2";
        enable_irq();

		for (i = 0; i < 0x200; i++)
			;
        
        state = !state;
	}
}

extern "C" void Process_3()
{
	volatile int i;

	//sUART0.Write("Process 2\r\n");
    sGPIO.Set_GPIO_Function(51, NGPIO_Function::Output);
    bool state = true;

	while (true)
	{
		//sUART0.Write('2');
        sGPIO.Set_Output(51, state);

        disable_irq();
		sMonitor << "3";
        enable_irq();

		for (i = 0; i < 0x150; i++)
			;
        
        state = !state;
	}
}

extern "C" void Process_4()
{
	volatile int i;

	//sUART0.Write("Process 2\r\n");
    sGPIO.Set_GPIO_Function(52, NGPIO_Function::Output);
    bool state = true;

	while (true)
	{
		//sUART0.Write('2');
        sGPIO.Set_Output(51, state);

        disable_irq();
		sMonitor << "4";
        enable_irq();

		for (i = 0; i < 0x250; i++)
			;
        
        state = !state;
	}
}

extern "C" int _kernel_main(void)
{
	// nastavime ACT LED pin na vystupni
	sGPIO.Set_GPIO_Function(ACT_Pin, NGPIO_Function::Output);
	sGPIO.Set_Output(ACT_Pin, false);

	// sProcessMgr.Create_Main_Process();

    sMonitor.Clear();
    
	sProcessMgr.Create_Process(reinterpret_cast<unsigned long>(&Process_1));
	sProcessMgr.Create_Process(reinterpret_cast<unsigned long>(&Process_2));
    sProcessMgr.Create_Process(reinterpret_cast<unsigned long>(&Process_3));
    sProcessMgr.Create_Process(reinterpret_cast<unsigned long>(&Process_4));

	// zatim zakazeme IRQ casovace
	sInterruptCtl.Disable_Basic_IRQ(hal::IRQ_Basic_Source::Timer);

	// nastavime casovac - v callbacku se provadi planovani procesu
	sTimer.Enable(Timer_Callback, 0x20, NTimer_Prescaler::Prescaler_256);

	// povolime IRQ casovace
	sInterruptCtl.Enable_Basic_IRQ(hal::IRQ_Basic_Source::Timer);
    
	enable_irq();

	// nekonecna smycka - tadyodsud se CPU uz nedostane jinak, nez treba prerusenim
    while (1)
    {
    }
    
	return 0;
}
