#include <drivers/gpio.h>
#include <drivers/monitor.h>

// GPIO pin 47 je pripojeny na LED na desce (tzv. ACT LED)
constexpr uint32_t ACT_Pin = 47;

extern "C" int _kernel_main(void)
{
    sMonitor.Clear();
    sMonitor << "Hello from the kernel :)\n\n";

    sMonitor << "Running monitor tests...\nVariable x = " << 137U << "; variable y = 0x" << CMonitor::NNumber_Base::HEX
             << 199999U << '\n';
    sMonitor << "15 == 0 is " << (15 == 0) << '\n';
    sMonitor << "15 != 0 is " << (15 != 0) << "\n\n";

    // nastavime ACT LED pin na vystupni
    sGPIO.Set_GPIO_Function(ACT_Pin, NGPIO_Function::Output);

    volatile unsigned int tim;

    while (1)
    {
        // spalime 500000 taktu (cekani par milisekund)
        for (tim = 0; tim < 0x5000; tim++)
            ;

        // zhasneme LED
        sGPIO.Set_Output(ACT_Pin, true);
        sMonitor << "LED is ON\n";

        // opet cekani
        for (tim = 0; tim < 0x5000; tim++)
            ;

        // rozsvitime LED
        sGPIO.Set_Output(ACT_Pin, false);
        sMonitor << "LED is OFF\n";
    }

    return 0;
}
