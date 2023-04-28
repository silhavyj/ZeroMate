#pragma once

#include <hal/intdef.h>

// funkce GPIO pinu
enum class NGPIO_Function : uint8_t
{
	Input	= 0, // 000 - vstupni pin
	Output	= 1, // 001 - vystupni pin
	Alt_5	= 2, // 010 - alternativni funkce 5
	Alt_4	= 3, // 011 - alternativni funkce 4
	Alt_0	= 4, // 100 - alternativni funkce 0
	Alt_1	= 5, // 101 - alternativni funkce 1
	Alt_2	= 6, // 110 - alternativni funkce 2
	Alt_3	= 7, // 111 - alternativni funkce 3
	
	// pro alternativni funkce viz dokumentace desky/SoC
	// alternativni funkce mohou byt napr. UART, SPI, I2C, atd. (kde treba existuje HW podpora)
	
	Unspecified = 8, // 1000 - deska takove nezna, je to jen pro nas
};

/*
 * Trida obstaravajici komunikaci s GPIO piny
 */
class CGPIO_Handler
{
	private:
		// bazova adresa memory-mapped IO, inicializuje konstruktor
		unsigned int* const mGPIO;
		
	protected:
		// vybira GPFSEL registr a pozici bitu pro dany pin
		bool Get_GPFSEL_Location(uint32_t pin, uint32_t& reg, uint32_t& bit_idx) const;
		// vybira GPCLR registr a pozici bitu pro dany pin
		bool Get_GPCLR_Location(uint32_t pin, uint32_t& reg, uint32_t& bit_idx) const;
		// vybira GPSET registr a pozici bitu pro dany pin
		bool Get_GPSET_Location(uint32_t pin, uint32_t& reg, uint32_t& bit_idx) const;
		// vybira GPLEV registr a pozici bitu pro dany pin
		bool Get_GPLEV_Location(uint32_t pin, uint32_t& reg, uint32_t& bit_idx) const;
	
	public:
		CGPIO_Handler(unsigned int gpio_base_addr);
		
		// nastavi funkci GPIO pinu
		void Set_GPIO_Function(uint32_t pin, NGPIO_Function func);
		// vraci, jakou funkci ma dany GPIO pin
		NGPIO_Function Get_GPIO_Function(uint32_t pin) const;
		
		// nastavi vystupni uroven GPIO pinu
		void Set_Output(uint32_t pin, bool set);
};

// globalni instance pro hlavni GPIO port
extern CGPIO_Handler sGPIO;
