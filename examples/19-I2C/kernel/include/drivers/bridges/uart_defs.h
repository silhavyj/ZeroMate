#pragma once

enum class NUART_Char_Length
{
    Char_7 = 0,
    Char_8 = 1,
};

enum class NUART_Baud_Rate
{
    BR_1200     = 1200,
    BR_2400     = 2400,
    BR_4800     = 4800,
    BR_9600     = 9600,
    BR_19200    = 19200,
    BR_38400    = 38400,
    BR_57600    = 57600,
    BR_115200   = 115200,
};

// parametry UARTu pro prenos skrz IOCTL rozhrani
struct TUART_IOCtl_Params
{
    NUART_Char_Length char_length;
    NUART_Baud_Rate baud_rate;
};
