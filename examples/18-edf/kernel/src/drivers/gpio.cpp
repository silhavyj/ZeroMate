#include <hal/peripherals.h>
#include <drivers/gpio.h>
#include <process/process_manager.h>
#include <interrupt_controller.h>
#include <drivers/monitor.h>

#include <stdstring.h>

CGPIO_Handler sGPIO(hal::GPIO_Base);

CGPIO_Handler::CGPIO_Handler(unsigned int gpio_base_addr)
: mGPIO(reinterpret_cast<unsigned int*>(gpio_base_addr))
, mWaiting_Files(nullptr)
{
    bzero(&mPin_Reservations_Read, sizeof(mPin_Reservations_Read));
    bzero(&mPin_Reservations_Write, sizeof(mPin_Reservations_Write));

    // projistotu promazeme detekovane udalosti
    mGPIO[static_cast<uint32_t>(hal::GPIO_Reg::GPEDS0)] = 0;
    mGPIO[static_cast<uint32_t>(hal::GPIO_Reg::GPEDS1)] = 0;

    spinlock_init(&mLock);
}

bool CGPIO_Handler::Get_GPFSEL_Location(uint32_t pin, uint32_t& reg, uint32_t& bit_idx) const
{
    if (pin > hal::GPIO_Pin_Count)
        return false;

    reg = pin / 10;
    /*switch (pin / 10)
    {
            case 0: reg = static_cast<uint32_t>(hal::GPIO_Reg::GPFSEL0); break;
            case 1: reg = static_cast<uint32_t>(hal::GPIO_Reg::GPFSEL1); break;
            case 2: reg = static_cast<uint32_t>(hal::GPIO_Reg::GPFSEL2); break;
            case 3: reg = static_cast<uint32_t>(hal::GPIO_Reg::GPFSEL3); break;
            case 4: reg = static_cast<uint32_t>(hal::GPIO_Reg::GPFSEL4); break;
            case 5: reg = static_cast<uint32_t>(hal::GPIO_Reg::GPFSEL5); break;
    }*/

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

bool CGPIO_Handler::Get_GPEDS_Location(uint32_t pin, uint32_t& reg, uint32_t& bit_idx) const
{
    if (pin > hal::GPIO_Pin_Count)
        return false;

    reg = static_cast<uint32_t>((pin < 32) ? hal::GPIO_Reg::GPEDS0 : hal::GPIO_Reg::GPEDS1);
    bit_idx = pin % 32;

    return true;
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

void CGPIO_Handler::Set_GPIO_Function(uint32_t pin, NGPIO_Function func)
{
    uint32_t reg, bit;
    if (!Get_GPFSEL_Location(pin, reg, bit))
        return;

    unsigned int mode = static_cast<unsigned int>(func);

    unsigned int rd = mGPIO[reg];
    rd &= ~(7 << bit);
    rd |= (mode << bit);

    mGPIO[reg] = rd;
}

NGPIO_Function CGPIO_Handler::Get_GPIO_Function(uint32_t pin) const
{
    uint32_t reg, bit;
    if (!Get_GPFSEL_Location(pin, reg, bit))
        return NGPIO_Function::Unspecified;

    return static_cast<NGPIO_Function>((mGPIO[reg] >> bit) & 7);
}

void CGPIO_Handler::Set_Output(uint32_t pin, bool set)
{
    uint32_t reg, bit;
    if (!(set && Get_GPSET_Location(pin, reg, bit)) && !(!set && Get_GPCLR_Location(pin, reg, bit)))
        return;

    mGPIO[reg] = (1 << bit);
}

bool CGPIO_Handler::Get_Input(uint32_t pin)
{
    uint32_t reg, bit;
    if (!Get_GPLEV_Location(pin, reg, bit))
        return false;

    return (mGPIO[reg] >> bit) & 0x1;
}

bool CGPIO_Handler::Reserve_Pin(uint32_t pin, bool read, bool write)
{
    // TODO: zamek, tady by se neco mohlo sejit

    uint32_t bank_idx = pin / 32;
    uint32_t bit_idx = pin % 32;

    if (read && (mPin_Reservations_Read[bank_idx] >> bit_idx) & 0x1)
        return false;

    if (write && (mPin_Reservations_Write[bank_idx] >> bit_idx) & 0x1)
        return false;

    if (read)
        mPin_Reservations_Read[bank_idx] |= 1ULL << bit_idx;

    if (write)
        mPin_Reservations_Write[bank_idx] |= 1ULL << bit_idx;

    return true;
}

bool CGPIO_Handler::Free_Pin(uint32_t pin, bool read, bool write)
{
    uint32_t bank_idx = pin / 32;
    uint32_t bit_idx = pin % 32;

    if (read && !((mPin_Reservations_Read[bank_idx] >> bit_idx) & 0x1))
        return false;

    if (write && !((mPin_Reservations_Write[bank_idx] >> bit_idx) & 0x1))
        return false;

    if (read)
        mPin_Reservations_Read[bank_idx] &= ~(1ULL << bit_idx);

    if (write)
        mPin_Reservations_Write[bank_idx] &= ~(1ULL << bit_idx);

    return true;
}

void CGPIO_Handler::Enable_Event_Detect(uint32_t pin, NGPIO_Interrupt_Type type)
{
    uint32_t reg, bit;
    if (!Get_GP_IRQ_Detect_Location(pin, type, reg, bit))
        return;

    mGPIO[reg] = (1 << bit);

    // TODO: vyresit tohle trochu lepe
    sInterruptCtl.Enable_IRQ(hal::IRQ_Source::GPIO_0);
    sInterruptCtl.Enable_IRQ(hal::IRQ_Source::GPIO_1);
    sInterruptCtl.Enable_IRQ(hal::IRQ_Source::GPIO_2);
    sInterruptCtl.Enable_IRQ(hal::IRQ_Source::GPIO_3);
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

uint32_t CGPIO_Handler::Get_Detected_Event_Pin() const
{
    uint32_t reg, bit;
    for (uint32_t i = 0; i < hal::GPIO_Pin_Count; i++)
    {
        if (!Get_GPEDS_Location(i, reg, bit))
            return Invalid_Pin;

        if ((mGPIO[reg] >> bit) & 0x1)
            return i;
    }

    return Invalid_Pin;
}

void CGPIO_Handler::Clear_Detected_Event(uint32_t pin)
{
    uint32_t reg, bit;
    if (!Get_GPEDS_Location(pin, reg, bit))
        return;

    // BCM2835 manual: "The bit is cleared by writing a '1' to the relevant bit."
    mGPIO[reg] = 1 << bit;
}

void CGPIO_Handler::Wait_For_Event(IFile* file, uint32_t pin)
{
    spinlock_lock(&mLock);

    TWaiting_File* wf = new TWaiting_File;
    wf->file = file;
    wf->pin_idx = pin;
    wf->prev = nullptr;
    wf->next = mWaiting_Files;

    mWaiting_Files = wf;

    spinlock_unlock(&mLock);
}

void CGPIO_Handler::Handle_IRQ()
{
    TWaiting_File *wf, *tmpwf;

    // NOTE: kdybychom meli mala casova kvanta a timer by tikal velice casto, tak by se na nasledujici kus kodu
    //       spotrebovalo obrovske mnozstvi casu zbytecne
    // lepsi by pak bylo rozdelit kod na bottom a top half, napr. tak, ze:
    // - top half: zde pouze koukat do registru GPEDS0 a 1, a pokud by v nich neco bylo, jejich obsah naORovat do
    // nejakeho bufferu a notifikovat systemovy proces (bottom half)
    // - bottom half: atomicky "vybirat" z bufferu notifikovane piny a probouzet procesy, ktere cekaji
    // pro ted mejme vetsi casova kvanta, ale na problem bychom narazili hned, jak by vice driveru vyzadovalo svoje
    // obsluhy

    // sMonitor << "Checking for a GPIO int\n";

    uint32_t reg, bit, pin;
    // projdeme vsechny piny a podivame se, zda byla detekovana udalost
    for (pin = 0; pin < hal::GPIO_Pin_Count; pin++)
    {
        if (!Get_GPEDS_Location(pin, reg, bit))
            continue;

        // byla na tomto pinu detekovana udalost?
        if ((mGPIO[reg] >> bit) & 0x1)
        {
            // sMonitor << "GPIO Event detected: pin = " << pin << '\n';
            spinlock_lock(&mLock);

            // zkusime najit proces, ktery na udalost na tomto pinu ceka
            wf = mWaiting_Files;
            while (wf != nullptr)
            {
                if (wf->pin_idx == pin)
                {
                    // probudime proces
                    wf->file->Notify(NotifyAll);

                    // prelinkujeme spojovy seznam atd.

                    if (wf->prev)
                        wf->prev->next = wf->next;
                    if (wf->next)
                        wf->next->prev = wf->prev;

                    tmpwf = wf;

                    if (mWaiting_Files == wf)
                        mWaiting_Files = wf->next;

                    wf = wf->next;

                    delete tmpwf;
                }
                else
                    wf = wf->next;
            }

            spinlock_unlock(&mLock);

            // sMonitor << "Clearing GPIO interrupt\n";

            // nesmime zapomenout vycistit udalost, jinak by priznak zustal a my "detekovali" udalost stale dokola
            Clear_Detected_Event(pin);
        }
    }
}
