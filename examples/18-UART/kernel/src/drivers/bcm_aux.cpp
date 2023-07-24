#include <drivers/bcm_aux.h>

CAUX sAUX(hal::AUX_Base);

CAUX::CAUX(unsigned int aux_base)
: mAUX_Reg(reinterpret_cast<unsigned int*>(aux_base))
{
    //
}

void CAUX::Enable(hal::AUX_Peripherals aux_peripheral)
{
    Set_Register(hal::AUX_Reg::ENABLES,
                 Get_Register(hal::AUX_Reg::ENABLES) | (1 << static_cast<uint32_t>(aux_peripheral)));
}

void CAUX::Disable(hal::AUX_Peripherals aux_peripheral)
{
    Set_Register(hal::AUX_Reg::ENABLES,
                 Get_Register(hal::AUX_Reg::ENABLES) & ~(1 << static_cast<uint32_t>(aux_peripheral)));
}

void CAUX::Set_Register(hal::AUX_Reg reg_idx, uint32_t value)
{
    mAUX_Reg[static_cast<unsigned int>(reg_idx)] = value;
}

uint32_t CAUX::Get_Register(hal::AUX_Reg reg_idx)
{
    return mAUX_Reg[static_cast<unsigned int>(reg_idx)];
}
