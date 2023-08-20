#pragma once

#include <hal/intdef.h>
#include <hal/peripherals.h>

namespace mem
{
    // adresa od ktere zacneme alokovat - pro ted hardcoded, do budoucna je treba zjistit velikost kernelu a zarovnat
    // na nejblizsi vyssi nasobek velikosti stranky (4kB, popr. co si zvolime dle dostupnych moznosti)
    constexpr uint32_t LowMemory = 0x20000;

    // adresa do ktere je mozne alokovat (na tehle adrese uz muze zacinat nejaky mapovany region, napr. memory mapped
    // I/O)
    constexpr uint32_t HighMemory = hal::Peripheral_Base;

    // velikost jedne stranky (4kB)
    constexpr uint32_t PageSize = 0x4000;

    // kolik pameti muzeme vubec strankovat?
    constexpr uint32_t PagingMemorySize = HighMemory - LowMemory;

    // kolik stranek vlastne muzeme pridelit?
    constexpr uint32_t PageCount = PagingMemorySize / PageSize;
}
