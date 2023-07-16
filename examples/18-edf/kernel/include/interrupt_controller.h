#pragma once

#include <hal/peripherals.h>

class CInterrupt_Controller
{
private:
    // baze pro registry radice preruseni
    volatile unsigned int* mInterrupt_Regs;

protected:
    volatile unsigned int& Regs(hal::Interrupt_Controller_Reg reg);

public:
    CInterrupt_Controller(unsigned long base);

    // povoli basic IRQ se zadanym indexem
    void Enable_Basic_IRQ(hal::IRQ_Basic_Source source_idx);
    // zakaze basic IRQ se zadanym indexem
    void Disable_Basic_IRQ(hal::IRQ_Basic_Source source_idx);

    // povoli IRQ se zadanym indexem
    void Enable_IRQ(hal::IRQ_Source source_idx);
    // zakaze IRQ se zadanym indexem
    void Disable_IRQ(hal::IRQ_Source source_idx);

    // nastavi (globalni) stav maskovani IRQ pro aktualni procesorovy rezim
    void Set_Mask_IRQ(bool state);
};

class CIRQ_Mask_Guard
{
private:
    static unsigned int gMask_Counter;

public:
    CIRQ_Mask_Guard();
    ~CIRQ_Mask_Guard();
};

extern CInterrupt_Controller sInterruptCtl;
