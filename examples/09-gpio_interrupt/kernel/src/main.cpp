#include <drivers/gpio.h>
#include <interrupt_controller.h>

extern "C" int _kernel_main(void)
{
    sGPIO.Set_GPIO_Function(47, NGPIO_Function::Output);
    sGPIO.Set_GPIO_Function(5, NGPIO_Function::Input);

    sGPIO.Enable_Event_Detect(5, NGPIO_Interrupt_Type::Rising_Edge);
    sGPIO.Enable_Event_Detect(5, NGPIO_Interrupt_Type::Falling_Edge);

    sInterruptCtl.Enable_IRQ(hal::IRQ_Source::GPIO_0);

    enable_irq();

    while (1)
        ;

    return 0;
}
