#pragma once

#include <hal/intdef.h>
#include <hal/peripherals.h>

namespace mem
{
    // adresa od ktere zacneme alokovat - pro ted hardcoded, do budoucna je treba zjistit velikost kernelu a zarovnat
    // na nejblizsi vyssi nasobek velikosti stranky (1MB, popr. co si zvolime dle dostupnych moznosti)
    // adresa je v adresnim prostoru kernelu
    constexpr uint32_t LowMemory = 0xC1000000;

    // adresa do ktere je mozne alokovat - opet stanovene jen pocitove (256 MB), melo by byt vyziskane z HW a korektne
    // oriznuto
    constexpr uint32_t HighMemory = LowMemory + 256 * 0x100000;

    // baze alokovane pameti - pri praci s pameti v jadre plati to, ze po odectu teto hodnoty od adresy virtualni
    // ziskame fyzickou adresu u procesu jako takovych to pochopitelne neplati, ty sice maji v tabulce stranek
    // namapovane adresy 0xC0000000 a vyse, ale nemohou je cist
    constexpr uint32_t MemoryVirtualBase = 0xC0000000;

    // velikost jedne stranky (1MB)
    constexpr uint32_t PageSize = 0x100000;

    // kolik pameti muzeme vubec strankovat?
    constexpr uint32_t PagingMemorySize = HighMemory - LowMemory;

    // kolik stranek vlastne muzeme pridelit?
    constexpr uint32_t PageCount = PagingMemorySize / PageSize;
}
