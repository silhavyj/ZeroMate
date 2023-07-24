#include <hal/intdef.h>
#include <drivers/timer.h>

CTimer sTimer(hal::Timer_Base);

#pragma pack(push, 1)

struct TTimer_Ctl_Flags
{
    uint8_t unused_0 : 1;
    uint8_t counter_32b : 1;
    uint8_t prescaler : 2; // ve skutecnosti jde o typ NTimer_Prescaler
    uint8_t unused_1 : 1;
    uint8_t interrupt_enabled : 1;
    uint8_t unused_2 : 1;
    uint8_t timer_enabled : 1;
    uint8_t halt_in_debug_break : 1;
    uint8_t free_running_enable : 1;
    uint16_t unused_3 : 10;
    uint16_t free_running_prescaler : 16;
    uint16_t unused_4 : 10;
};

#pragma pack(pop)

CTimer::CTimer(unsigned long timer_reg_base)
: mTimer_Regs(reinterpret_cast<unsigned int*>(timer_reg_base))
, mCallback(nullptr)
, mTick_Count(0)
{
    //
}

volatile unsigned int& CTimer::Regs(hal::Timer_Reg reg)
{
    return mTimer_Regs[static_cast<unsigned int>(reg)];
}

void CTimer::Enable(TTimer_Callback callback, unsigned int delay, NTimer_Prescaler prescaler)
{
    Regs(hal::Timer_Reg::Load) = delay;

    TTimer_Ctl_Flags reg;
    reg.counter_32b = 1;
    reg.interrupt_enabled = 1;
    reg.timer_enabled = 1;
    reg.prescaler = static_cast<uint8_t>(prescaler);

    Regs(hal::Timer_Reg::Control) = *reinterpret_cast<unsigned int*>(&reg);

    Regs(hal::Timer_Reg::IRQ_Clear) = 1;

    mCallback = callback;
}

void CTimer::Disable()
{
    volatile TTimer_Ctl_Flags& reg = reinterpret_cast<volatile TTimer_Ctl_Flags&>(Regs(hal::Timer_Reg::Control));

    reg.interrupt_enabled = 0;
    reg.timer_enabled = 0;
}

void CTimer::IRQ_Callback()
{
    Regs(hal::Timer_Reg::IRQ_Clear) = 1;

    mTick_Count++;

    if (mCallback)
        mCallback();
}

bool CTimer::Is_Timer_IRQ_Pending()
{
    return Regs(hal::Timer_Reg::IRQ_Masked);
}

uint32_t CTimer::Get_Tick_Count() const
{
    return mTick_Count;
}
