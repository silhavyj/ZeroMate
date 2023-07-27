#pragma once

#include <hal/peripherals.h>
#include <drivers/bcm_aux.h>

enum class NUART_Char_Length
{
    Char_7 = 0,
    Char_8 = 1,
};

enum class NUART_Baud_Rate
{
    BR_1200 = 1200,
    BR_2400 = 2400,
    BR_4800 = 4800,
    BR_9600 = 9600,
    BR_19200 = 19200,
    BR_38400 = 38400,
    BR_57600 = 57600,
    BR_115200 = 115200,
};

class CUART
{
private:
    CAUX& mAUX;

public:
    CUART(CAUX& aux);

    void Set_Char_Length(NUART_Char_Length len);
    void Set_Baud_Rate(NUART_Baud_Rate rate);

    // miniUART na RPi0 nepodporuje nic moc jineho uzitecneho, napr. paritni bity, vice stop-bitu nez 1, atd.

    void Write(char c);
    void Write(const char* str);
};

extern CUART sUART0;
