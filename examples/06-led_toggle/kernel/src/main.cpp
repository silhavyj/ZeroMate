#include <drivers/gpio.h>

// GPIO pin 47 je pripojeny na LED na desce (tzv. ACT LED)
constexpr uint32_t ACT_Pin = 47;

extern "C" int _kernel_main(void)
{
	// nastavime ACT LED pin na vystupni
	sGPIO.Set_GPIO_Function(ACT_Pin, NGPIO_Function::Output);

	volatile unsigned int tim;
	
    while (1)
    {
		// spalime 500000 taktu (cekani par milisekund)
        for(tim = 0; tim < 0x5000; tim++)
            ;
		
		// zhasneme LED
		sGPIO.Set_Output(ACT_Pin, true);

		// opet cekani
        for(tim = 0; tim < 0x5000; tim++)
            ;

		// rozsvitime LED
		sGPIO.Set_Output(ACT_Pin, false);
    }
	
	return 0;
}
