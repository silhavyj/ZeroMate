#pragma once

#include "intdef.h"

namespace hal
{
	constexpr unsigned int Default_Clock_Rate = 250000000; // taktovaci frekvence hlavniho jadra

	// baze pro memory-mapped I/O
	constexpr unsigned long Peripheral_Base = 0x20000000UL;

	// baze pro memory-mapped I/O pro GPIO
	constexpr unsigned long GPIO_Base = Peripheral_Base + 0x00200000UL;
	
	// pocet GPIO pinu
	constexpr uint32_t GPIO_Pin_Count = 54;
	
	// registry relevantni ke GPIO
	enum class GPIO_Reg
	{
		// vyber funkce GPIO pinu
		GPFSEL0   = 0,
		GPFSEL1   = 1,
		GPFSEL2   = 2,
		GPFSEL3   = 3,
		GPFSEL4   = 4,
		GPFSEL5   = 5,
		// registry pro zapis "nastavovaciho priznaku"
		GPSET0    = 7,
		GPSET1    = 8,
		// registry pro zapis "odnastavovaciho priznaku"
		GPCLR0    = 10,
		GPCLR1    = 11,
		// registry pro cteni aktualniho stavu pinu
		GPLEV0    = 13,
		GPLEV1    = 14,
		// registry kde se objevi priznak pri detekci udalosti
		GPEDS0    = 16,
		GPEDS1    = 17,
		// registry priznaku pro detekci vzestupne hrany
		GPREN0    = 19,
		GPREN1    = 20,
		// registry priznaku pro detekci sestupne hrany
		GPFEN0    = 22,
		GPFEN1    = 23,
		// registry priznaku pro detekci vysoke urovne napeti
		GPHEN0    = 25,
		GPHEN1    = 26,
		// registry priznaku pro detekci nizke urovne napeti
		GPLEN0    = 28,
		GPLEN1    = 29,
		// registry priznaku pro detekci vzestupne hrany (asynchronne)
		GPAREN0   = 31,
		GPAREN1   = 32,
		// registry priznaku pro detekci sestupne hrany (asynchronne)
		GPAFEN0   = 34,
		GPAFEN1   = 35,
		// registry pro nastaveni priznaku rizeni pull-up/down na pinech
		GPPUD     = 37,
		// registry pro nastaveni pull-up/down na jednotlivych pinech
		GPPUDCLK0 = 38,
		GPPUDCLK1 = 39
	};

	// baze pro memory-mapped I/O pro AUX funkce
	constexpr unsigned long AUX_Base = Peripheral_Base + 0x00215000UL;

	enum class AUX_Reg
	{
		// registr pro priznaky cekajicich preruseni
		IRQ	= 0,
		// registr pro povolovani AUX periferie (zapina a vypina cely HW subsystem)
		ENABLES = 1,

		// mini UART registry

		MU_IO = 16,
		MU_IER = 17,
		MU_IIR = 18,
		MU_LCR = 19,
		MU_MCR = 20,
		MU_LSR = 21,
		MU_MSR = 22,
		MU_SCRATCH = 23,
		MU_CNTL = 24,
		MU_STAT = 25,
		MU_BAUD = 26,

		// SPI0 master registry

		SPI0_CNTL0 = 32,
		SPI0_CNTL1 = 33,
		SPI0_STAT = 34,
		SPI0_IO = 36,
		SPI0_PEEK = 37,

		// SPI1 master registry

		SPI1_CNTL0 = 48,
		SPI1_CNTL1 = 49,
		SPI1_STAT = 50,
		SPI1_IO = 52,
		SPI1_PEEK = 53,
	};

	enum class AUX_Peripherals
	{
		MiniUART    = 0,
		SPI1        = 1,
		SPI2        = 2,
	};

	constexpr unsigned long Interrupt_Controller_Base = Peripheral_Base + 0x0000B200UL;

	enum class Interrupt_Controller_Reg
	{
		IRQ_Basic_Pending	= 0,
		IRQ_Pending_1		= 1,
		IRQ_Pending_2		= 2,
		FIQ_Control			= 3,
		IRQ_Enable_1		= 4,
		IRQ_Enable_2		= 5,
		IRQ_Basic_Enable	= 6,
		IRQ_Disable_1		= 7,
		IRQ_Disable_2		= 8,
		IRQ_Basic_Disable	= 9,
	};

	enum class IRQ_Basic_Source
	{
		Timer				= 0,
		Mailbox				= 1,
		Doorbell_0 			= 2,
		Doorbell_1			= 3,
		GPU0_Halt			= 4,
		GPU1_Halt			= 5,
		Illegal_Access_1	= 6,
		Illegal_Access_2	= 7,
	};

	enum class IRQ_Source
	{
		// 0-28 - vyhrazeno pro GPU
		AUX					= 29,
		// 30-42 - vyhrazeno pro GPU
		I2C_SPI_SLAVE_INIT	= 43,
		// 44 - vyhrazeno pro GPU
		PWA_0				= 45,
		PWA_1				= 46,
		// 47 - vyhrazeno pro GPU
		SMI					= 48,
		GPIO_0				= 49,
		GPIO_1				= 50,
		GPIO_2				= 51,
		GPIO_3				= 52,
		I2C					= 53,
		SPI					= 54,
		PCM					= 55,
		// 56 - vyhrazeno pro GPU
		UART				= 57,
		// 58-63 - vyhrazeno pro GPU
	};

	constexpr unsigned long Timer_Base = Peripheral_Base + 0x0000B400UL;

	enum class Timer_Reg
	{
		Load			= 0,
		Value			= 1,
		Control			= 2,
		IRQ_Clear		= 3,
		IRQ_Raw			= 4,
		IRQ_Masked		= 5,
		Reload			= 6,
		Pre_Divider 	= 7,
		Free_Running	= 8,
	};

	constexpr unsigned long TRNG_Base = Peripheral_Base + 0x00104000;

	enum class TRNG_Reg
	{
		Control			= 0,
		Status			= 1,
		Data			= 2,
		// 3 - nepouzivano
		Int_Mask		= 4,
	};

	constexpr unsigned long BSC0_Base = Peripheral_Base + 0x00205000;
	constexpr unsigned long BSC1_Base = Peripheral_Base + 0x00804000;
	constexpr unsigned long BSC2_Base = Peripheral_Base + 0x00805000;

	enum class BSC_Reg
	{
		Control			= 0,
		Status			= 1,
		Data_Length		= 2,
		Slave_Address	= 3,
		Data_FIFO		= 4,
		Clock_Div		= 5,
		Data_Delay		= 6,
		CLKT			= 7,	// clock stretch timeout
	};
}
