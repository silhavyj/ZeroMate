#include <drivers/gpio.h>
#include <drivers/uart.h>
#include <drivers/monitor.h>

extern "C" int _kernel_main(void)
{
    // inicializujeme UART kanal 0
    sUART0.Set_Baud_Rate(NUART_Baud_Rate::BR_115200);
    sUART0.Set_Char_Length(NUART_Char_Length::Char_8);

    volatile unsigned int tim;

    while (1)
    {
        sUART0.Write("Welcome to KIV/OS RPiOS kernel\r\n");

        for (tim = 0; tim < 0x100; tim++)
            ;
    }

    return 0;
}
