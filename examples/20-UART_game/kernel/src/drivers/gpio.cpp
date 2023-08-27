#include <hal/peripherals.h>
#include <drivers/gpio.h>

CGPIO_Handler sGPIO(hal::GPIO_Base);

CGPIO_Handler::CGPIO_Handler(unsigned int gpio_base_addr)
: mGPIO(reinterpret_cast<unsigned int*>(gpio_base_addr))
{
    //
}

bool CGPIO_Handler::Get_GPFSEL_Location(uint32_t pin, uint32_t& reg, uint32_t& bit_idx) const
{
    if (pin > hal::GPIO_Pin_Count)
        return false;

    switch (pin / 10)
    {
        case 0:
            reg = static_cast<uint32_t>(hal::GPIO_Reg::GPFSEL0);
            break;
        case 1:
            reg = static_cast<uint32_t>(hal::GPIO_Reg::GPFSEL1);
            break;
        case 2:
            reg = static_cast<uint32_t>(hal::GPIO_Reg::GPFSEL2);
            break;
        case 3:
            reg = static_cast<uint32_t>(hal::GPIO_Reg::GPFSEL3);
            break;
        case 4:
            reg = static_cast<uint32_t>(hal::GPIO_Reg::GPFSEL4);
            break;
        case 5:
            reg = static_cast<uint32_t>(hal::GPIO_Reg::GPFSEL5);
            break;
    }

    bit_idx = (pin % 10) * 3;

    return true;
}

bool CGPIO_Handler::Get_GPCLR_Location(uint32_t pin, uint32_t& reg, uint32_t& bit_idx) const
{
    if (pin > hal::GPIO_Pin_Count)
        return false;

    reg = static_cast<uint32_t>((pin < 32) ? hal::GPIO_Reg::GPCLR0 : hal::GPIO_Reg::GPCLR1);
    bit_idx = pin % 32;

    return true;
}

bool CGPIO_Handler::Get_GPSET_Location(uint32_t pin, uint32_t& reg, uint32_t& bit_idx) const
{
    if (pin > hal::GPIO_Pin_Count)
        return false;

    reg = static_cast<uint32_t>((pin < 32) ? hal::GPIO_Reg::GPSET0 : hal::GPIO_Reg::GPSET1);
    bit_idx = pin % 32;

    return true;
}

bool CGPIO_Handler::Get_GPLEV_Location(uint32_t pin, uint32_t& reg, uint32_t& bit_idx) const
{
    if (pin > hal::GPIO_Pin_Count)
        return false;

    reg = static_cast<uint32_t>((pin < 32) ? hal::GPIO_Reg::GPLEV0 : hal::GPIO_Reg::GPLEV1);
    bit_idx = pin % 32;

    return true;
}

void CGPIO_Handler::Set_GPIO_Function(uint32_t pin, NGPIO_Function func)
{
    uint32_t reg, bit;
    if (!Get_GPFSEL_Location(pin, reg, bit))
        return;

    mGPIO[reg] = (mGPIO[reg] & (~static_cast<unsigned int>(7 << bit))) | (static_cast<unsigned int>(func) << bit);
}

NGPIO_Function CGPIO_Handler::Get_GPIO_Function(uint32_t pin) const
{
    uint32_t reg, bit;
    if (!Get_GPFSEL_Location(pin, reg, bit))
        return NGPIO_Function::Unspecified;

    return static_cast<NGPIO_Function>((mGPIO[reg] >> bit) & 7);
}

void CGPIO_Handler::Enable_Event_Detect(uint32_t pin, NGPIO_Interrupt_Type type)
{
    uint32_t reg, bit;
    if (!Get_GP_IRQ_Detect_Location(pin, type, reg, bit))
        return;

    mGPIO[reg] = (1 << bit);

    // TODO: vyresit tohle trochu lepe
    // sInterruptCtl.Enable_IRQ(hal::IRQ_Source::GPIO_0);
    // sInterruptCtl.Enable_IRQ(hal::IRQ_Source::GPIO_1);
    // sInterruptCtl.Enable_IRQ(hal::IRQ_Source::GPIO_2);
    // sInterruptCtl.Enable_IRQ(hal::IRQ_Source::GPIO_3);
}

bool CGPIO_Handler::Get_GP_IRQ_Detect_Location(uint32_t pin,
                                               NGPIO_Interrupt_Type type,
                                               uint32_t& reg,
                                               uint32_t& bit_idx) const
{
    if (pin > hal::GPIO_Pin_Count)
        return false;

    bit_idx = pin % 32;

    switch (type)
    {
        case NGPIO_Interrupt_Type::Rising_Edge:
            reg = static_cast<uint32_t>((pin < 32) ? hal::GPIO_Reg::GPREN0 : hal::GPIO_Reg::GPREN1);
            break;
        case NGPIO_Interrupt_Type::Falling_Edge:
            reg = static_cast<uint32_t>((pin < 32) ? hal::GPIO_Reg::GPFEN0 : hal::GPIO_Reg::GPFEN1);
            break;
        case NGPIO_Interrupt_Type::High:
            reg = static_cast<uint32_t>((pin < 32) ? hal::GPIO_Reg::GPHEN0 : hal::GPIO_Reg::GPHEN1);
            break;
        case NGPIO_Interrupt_Type::Low:
            reg = static_cast<uint32_t>((pin < 32) ? hal::GPIO_Reg::GPLEN0 : hal::GPIO_Reg::GPLEN1);
            break;
        default:
            return false;
    }

    return true;
}

void CGPIO_Handler::Disable_Event_Detect(uint32_t pin, NGPIO_Interrupt_Type type)
{
    uint32_t reg, bit;
    if (!Get_GP_IRQ_Detect_Location(pin, type, reg, bit))
        return;

    uint32_t val = mGPIO[reg];
    val &= ~(1 << bit);
    mGPIO[reg] = val;
}

void CGPIO_Handler::Set_Output(uint32_t pin, bool set)
{
    uint32_t reg, bit;
    if (!(set && Get_GPSET_Location(pin, reg, bit)) && !(!set && Get_GPCLR_Location(pin, reg, bit)))
        return;

    mGPIO[reg] = (1 << bit);
}

bool CGPIO_Handler::Get_GPEDS_Location(uint32_t pin, uint32_t& reg, uint32_t& bit_idx) const
{
    if (pin > hal::GPIO_Pin_Count)
        return false;

    reg = static_cast<uint32_t>((pin < 32) ? hal::GPIO_Reg::GPEDS0 : hal::GPIO_Reg::GPEDS1);
    bit_idx = pin % 32;

    return true;
}

void CGPIO_Handler::Clear_Detected_Event(uint32_t pin)
{
    uint32_t reg, bit;
    if (!Get_GPEDS_Location(pin, reg, bit))
        return;

    // BCM2835 manual: "The bit is cleared by writing a '1' to the relevant bit."
    mGPIO[reg] = 1 << bit;
}