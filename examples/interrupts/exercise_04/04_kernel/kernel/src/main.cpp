#include <drivers/gpio.h>

extern "C" void __attribute__((interrupt("SWI"))) software_interrupt_handler()
{
    sGPIO.Set_GPIO_Function(47, NGPIO_Function::Output);
    sGPIO.Set_Output(47, true);
}

extern "C" void __attribute__((interrupt("IRQ"))) irq_handler()
{
    // TODO
}

extern "C" void __attribute__((interrupt("FIQ"))) fast_interrupt_handler()
{
    // TODO
}

extern "C" int _kernel_main(void)
{
    __asm("swi 123");

    while (1)
    {
    }
	
    return 0;
}
