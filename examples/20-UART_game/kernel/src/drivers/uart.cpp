#include <drivers/uart.h>
#include <drivers/bcm_aux.h>
#include <drivers/monitor.h>
#include <stdstring.h>

CUART sUART0(sAUX);

CUART::CUART(CAUX& aux)
: mAUX(aux)
{
    mAUX.Enable(hal::AUX_Peripherals::MiniUART);
    // mAUX.Set_Register(hal::AUX_Reg::ENABLES, mAUX.Get_Register(hal::AUX_Reg::ENABLES) | 0x01);
    mAUX.Set_Register(hal::AUX_Reg::MU_IIR, 0);
    mAUX.Set_Register(hal::AUX_Reg::MU_IER, 0);
    mAUX.Set_Register(hal::AUX_Reg::MU_MCR, 0);
    mAUX.Set_Register(hal::AUX_Reg::MU_CNTL, 3); // RX and TX enabled
}

void CUART::Set_Char_Length(NUART_Char_Length len)
{
    mAUX.Set_Register(hal::AUX_Reg::MU_LCR,
                      (mAUX.Get_Register(hal::AUX_Reg::MU_LCR) & 0xFFFFFFFE) | static_cast<unsigned int>(len));
}

void CUART::Set_Baud_Rate(NUART_Baud_Rate rate)
{
    constexpr unsigned int Clock_Rate = 250000000; // taktovaci frekvence hlavniho jadra
    const unsigned int val = ((Clock_Rate / static_cast<unsigned int>(rate)) / 8) - 1;

    mAUX.Set_Register(hal::AUX_Reg::MU_CNTL, 0);

    mAUX.Set_Register(hal::AUX_Reg::MU_BAUD, val);

    mAUX.Set_Register(hal::AUX_Reg::MU_CNTL, 3);
}

void CUART::Write(char c)
{
    // dokud ma status registr priznak "vystupni fronta plna", nelze prenaset dalsi bit
    while (!(mAUX.Get_Register(hal::AUX_Reg::MU_LSR) & (1 << 5)))
        ;

    mAUX.Set_Register(hal::AUX_Reg::MU_IO, c);
}

void CUART::Write(const char* str)
{
    int i;

    for (i = 0; str[i] != '\0'; i++)
        Write(str[i]);
}

void CUART::Write(const char* str, unsigned int len)
{
    unsigned int i;

    for (i = 0; i < len; i++)
        Write(str[i]);
}

void CUART::Write(unsigned int num)
{
    static char buf[16];

    itoa(num, buf, 10);
    Write(buf);
}

void CUART::Write(int num)
{
    Write(static_cast<unsigned int>(num));
}

void CUART::Write_Hex(unsigned int num)
{
    static char buf[16];

    itoa(num, buf, 16);
    Write(buf);
}

void CUART::Read(char* c)
{
    while (!(mAUX.Get_Register(hal::AUX_Reg::MU_LSR) & 1))
    {
        ;
    }

    *c = mAUX.Get_Register(hal::AUX_Reg::MU_IO) & 0xFF;
}

void CUART::Enable_Receive_Int()
{
    mAUX.Set_Register(hal::AUX_Reg::MU_IER, mAUX.Get_Register(hal::AUX_Reg::MU_IER) | (0b1U << 1U));
}

void CUART::Enable_Transmit_Int()
{
    mAUX.Set_Register(hal::AUX_Reg::MU_IER, mAUX.Get_Register(hal::AUX_Reg::MU_IER) | (0b1U << 0U));
}