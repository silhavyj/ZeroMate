#include <drivers/gpio.h>
#include <drivers/uart.h>
#include <drivers/monitor.h>

// GPIO pin 47 je pripojeny na LED na desce (tzv. ACT LED)
constexpr uint32_t ACT_Pin = 47;

extern "C" int _kernel_main(void)
{
    sMonitor.Clear();

    // nastavime ACT LED pin na vystupni
    sGPIO.Set_GPIO_Function(ACT_Pin, NGPIO_Function::Output);

    // inicializujeme UART kanal 0
    sUART0.Set_Baud_Rate(NUART_Baud_Rate::BR_115200);
    sUART0.Set_Char_Length(NUART_Char_Length::Char_8);

    // vypiseme ladici hlasku
    sUART0.Write("Welcome to KIV/OS RPiOS kernel\r\n");

    volatile unsigned int tim;

    while (1)
    {
        /*// spalime 500000 taktu (cekani par milisekund)
for(tim = 0; tim < 500000; tim++)
    ;

        // zhasneme LED
        sGPIO.Set_Output(ACT_Pin, true);

        // vypis neceho na UART
        sUART0.Write('A');

        // opet cekani
for(tim = 0; tim < 500000; tim++)
    ;

        // rozsvitime LED
        sGPIO.Set_Output(ACT_Pin, false);*/
    }

    return 0;
}
