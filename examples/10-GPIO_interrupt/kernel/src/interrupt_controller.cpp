#include <hal/intdef.h>
#include <hal/peripherals.h>
#include <drivers/gpio.h>
#include <interrupt_controller.h>

extern "C" void __attribute__((interrupt("SWI"))) software_interrupt_handler()
{
}

extern "C" void __attribute__((interrupt("IRQ"))) irq_handler()
{
    static bool status = true;
    sGPIO.Set_Output(47, status);
    status = !status;

    sGPIO.Clear_Detected_Event(5);
}

extern "C" void __attribute__((interrupt("FIQ"))) fast_interrupt_handler()
{
}

CInterrupt_Controller sInterruptCtl(hal::Interrupt_Controller_Base);

CInterrupt_Controller::CInterrupt_Controller(unsigned long base)
: mInterrupt_Regs(reinterpret_cast<unsigned int*>(base))
{
}

volatile unsigned int& CInterrupt_Controller::Regs(hal::Interrupt_Controller_Reg reg)
{
    return mInterrupt_Regs[static_cast<unsigned int>(reg)];
}

void CInterrupt_Controller::Enable_Basic_IRQ(hal::IRQ_Basic_Source source_idx)
{
    Regs(hal::Interrupt_Controller_Reg::IRQ_Basic_Enable) = (1 << static_cast<unsigned int>(source_idx));
}

void CInterrupt_Controller::Disable_Basic_IRQ(hal::IRQ_Basic_Source source_idx)
{
    Regs(hal::Interrupt_Controller_Reg::IRQ_Basic_Disable) = (1 << static_cast<unsigned int>(source_idx));
}

void CInterrupt_Controller::Enable_IRQ(hal::IRQ_Source source_idx)
{
    const unsigned int idx_base = static_cast<unsigned int>(source_idx);

    Regs(idx_base < 32 ? hal::Interrupt_Controller_Reg::IRQ_Enable_1 : hal::Interrupt_Controller_Reg::IRQ_Enable_2) =
    (1 << (idx_base % 32));
}

void CInterrupt_Controller::Disable_IRQ(hal::IRQ_Source source_idx)
{
    const unsigned int idx_base = static_cast<unsigned int>(source_idx);

    Regs(idx_base < 32 ? hal::Interrupt_Controller_Reg::IRQ_Disable_1 : hal::Interrupt_Controller_Reg::IRQ_Disable_2) =
    (1 << (idx_base % 32));
}
