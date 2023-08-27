#pragma once

#include <hal/peripherals.h>

// handler pro auxiliary periferie a registry
class CAUX
{
private:
    // bazova adresa AUX registru
    unsigned int* const mAUX_Reg;

public:
    CAUX(unsigned int aux_base);

    // povoli vybranou auxiliary periferii
    void Enable(hal::AUX_Peripherals aux_peripheral);
    // zakaze vybranou auxiliary periferii
    void Disable(hal::AUX_Peripherals aux_peripheral);

    // nastavi auxiliary registr
    void Set_Register(hal::AUX_Reg reg_idx, uint32_t value);
    // precte auxiliary registr
    uint32_t Get_Register(hal::AUX_Reg reg_idx);
};

extern CAUX sAUX;
