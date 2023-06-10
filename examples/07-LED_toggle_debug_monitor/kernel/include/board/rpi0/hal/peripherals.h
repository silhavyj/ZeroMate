#pragma once

#ifdef RPI0

    #include "intdef.h"

namespace hal
{
    // baze pro memory-mapped I/O
    constexpr unsigned long Peripheral_Base = 0x20000000UL;

    // baze pro memory-mapped I/O pro GPIO
    constexpr unsigned long GPIO_Base = Peripheral_Base + 0x00200000UL;

    // pocet GPIO pinu
    constexpr uint32_t GPIO_Pin_Count = 54;

    // registry relevantni ke GPIO
    enum class GPIO_Reg
    {
        // vyber funkce GPIO pinu
        GPFSEL0 = 0,
        GPFSEL1 = 1,
        GPFSEL2 = 2,
        GPFSEL3 = 3,
        GPFSEL4 = 4,
        GPFSEL5 = 5,
        // registry pro zapis "nastavovaciho priznaku"
        GPSET0 = 7,
        GPSET1 = 8,
        // registry pro zapis "odnastavovaciho priznaku"
        GPCLR0 = 10,
        GPCLR1 = 11,
        // registry pro cteni aktualniho stavu pinu
        GPLEV0 = 13,
        GPLEV1 = 14,
        // registry kde se objevi priznak pri detekci udalosti
        GPEDS0 = 16,
        GPEDS1 = 17,
        // registry priznaku pro detekci vzestupne hrany
        GPREN0 = 19,
        GPREN1 = 20,
        // registry priznaku pro detekci sestupne hrany
        GPFEN0 = 22,
        GPFEN1 = 23,
        // registry priznaku pro detekci vysoke urovne napeti
        GPHEN0 = 25,
        GPHEN1 = 26,
        // registry priznaku pro detekci nizke urovne napeti
        GPLEN0 = 28,
        GPLEN1 = 29,
        // registry priznaku pro detekci vzestupne hrany (asynchronne)
        GPAREN0 = 31,
        GPAREN1 = 32,
        // registry priznaku pro detekci sestupne hrany (asynchronne)
        GPAFEN0 = 34,
        GPAFEN1 = 35,
        // registry pro nastaveni priznaku rizeni pull-up/down na pinech
        GPPUD = 37,
        // registry pro nastaveni pull-up/down na jednotlivych pinech
        GPPUDCLK0 = 38,
        GPPUDCLK1 = 39
    };
}

#endif
