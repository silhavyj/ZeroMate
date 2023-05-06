#include <drivers/gpio.h>
#include <drivers/monitor.h>
#include <drivers/timer.h>
#include <interrupt_controller.h>

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

    sMonitor << "Process 1\n";

    while (true)
    {
        for (i = 0; i < 0x200; i++)
            ;
        
        disable_irq();
        sMonitor << '1';
        enable_irq();
    }
}

extern "C" void Process_2()
{
    volatile int i;

    sMonitor << "Process 2\n";

    while (true)
    {
        for (i = 0; i < 0x200; i++)
            ;
        
        disable_irq();
        sMonitor << '2';
        enable_irq();
    }
}

extern "C" void Process_3()
{
    volatile int i;

    sMonitor << "Process 3\n";

    while (true)
    {
        for (i = 0; i < 0x200; i++)
            ;
        
        disable_irq();
        sMonitor << '3';
        enable_irq();
    }
}

extern "C" void Process_4()
{
    volatile int i;

    sMonitor << "Process 4\n";

    while (true)
    {
        for (i = 0; i < 0x200; i++)
            ;
        
        disable_irq();
        sMonitor << '4';
        enable_irq();
    }
}

extern "C" int _kernel_main(void)
{
    // nastavime ACT LED pin na vystupni
    sGPIO.Set_GPIO_Function(ACT_Pin, NGPIO_Function::Output);
    sGPIO.Set_Output(ACT_Pin, false);

    // vypiseme ladici hlasku
    sMonitor.Clear();
    sMonitor << "Welcome to KIV/OS RPiOS kernel\n";

    // sProcessMgr.Create_Main_Process();

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
        ;

    return 0;
}
