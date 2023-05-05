#include <drivers/gpio.h>
#include <interrupt_controller.h>
#include <drivers/timer.h>

volatile int LED_State = 0;

extern "C" void ACT_LED_Blinker()
{
    // prepinani LED pri kazdem vytikani casovace

    if (LED_State)
    {
        LED_State = 0;
        sGPIO.Set_Output(47, true);
    }
    else
    {
        LED_State = 1;
        sGPIO.Set_Output(47, false);
    }
}

extern "C" int _kernel_main(void)
{
    sGPIO.Set_GPIO_Function(47, NGPIO_Function::Output);
    sGPIO.Set_GPIO_Function(48, NGPIO_Function::Output);

    sGPIO.Set_GPIO_Function(46, NGPIO_Function::Input);
    sGPIO.Enable_Event_Detect(46, NGPIO_Interrupt_Type::Rising_Edge);
    sGPIO.Enable_Event_Detect(46, NGPIO_Interrupt_Type::Falling_Edge);

    sInterruptCtl.Enable_IRQ(hal::IRQ_Source::GPIO_2);

    sInterruptCtl.Disable_Basic_IRQ(hal::IRQ_Basic_Source::Timer);

    // nastavime casovac - budeme pro ted blikat LEDkou, v budoucnu muzeme treba spoustet planovac procesu
    sTimer.Enable(ACT_LED_Blinker, 0x100, NTimer_Prescaler::Prescaler_16);

    // povolime IRQ casovace
    sInterruptCtl.Enable_Basic_IRQ(hal::IRQ_Basic_Source::Timer);

    enable_irq();

    while (1)
        ;

    return 0;
}
