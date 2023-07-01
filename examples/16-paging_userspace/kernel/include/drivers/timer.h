#pragma once

#include <hal/peripherals.h>

// hardwarovy "prescaler" - tedy vlastne delic, urcuje, jaky rad ma hodnota casovace
enum class NTimer_Prescaler : uint8_t
{
    Prescaler_1 = 0,  // 00
    Prescaler_16 = 1, // 01
    Prescaler_256 = 2 // 10
};

class CTimer
{
public:
    // typ callbacku casovace
    using TTimer_Callback = void (*)();

private:
    // bazova adresa registru casovace
    volatile unsigned int* mTimer_Regs;

    // callback co se ma vyvolat po vytikani casovace
    TTimer_Callback mCallback;

protected:
    volatile unsigned int& Regs(hal::Timer_Reg reg);

public:
    CTimer(unsigned long timer_reg_base);

    // povoli casovac se zadanou frekvenci, prescalerem a callback funkci; frekvence = prescaler / Takt_Jadra * delay
    void
    Enable(TTimer_Callback callback, unsigned int delay, NTimer_Prescaler prescaler = NTimer_Prescaler::Prescaler_256);
    // zakaze povoleny casovac
    void Disable();

    // IRQ handler vola tuto rutinu po signalizaci IRQ
    void IRQ_Callback();
    // pokud casovac signalizoval preruseni, tato metoda vraci true
    bool Is_Timer_IRQ_Pending();
};

extern CTimer sTimer;
