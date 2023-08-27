#include <drivers/gpio.h>
#include <drivers/uart.h>
#include <interrupt_controller.h>

extern "C" int _kernel_main(void)
{
    sInterruptCtl.Enable_IRQ(hal::IRQ_Source::AUX);

    sUART0.Set_Baud_Rate(NUART_Baud_Rate::BR_115200);
    sUART0.Set_Char_Length(NUART_Char_Length::Char_8);

    sUART0.Enable_Receive_Int();

    enable_irq();

    sUART0.Write("Welcome to a guessing game!\r\n");
    sUART0.Write("---------------------------\r\n");
    sUART0.Write("Think of a number between 0 and 100 and I'm gonna guess what it is. All you gotta do is to tell me "
                 "whether my guess is larger than your number of choice or not, okay? [y/n]: ");

    while (1)
    {
    }

    return 0;
}
