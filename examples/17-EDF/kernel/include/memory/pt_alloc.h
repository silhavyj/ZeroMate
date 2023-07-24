#pragma once

#include "memmap.h"
#include "mmu.h"

// alokator tabulek stranek pro procesy - udrzuje pool tabulek stranek, ktere prideluje procesum na pozadani
// spravuje alokaci pomoci bitmapy

class CPage_Table_Allocator
{
private:
    // velikost tabulky stranek v bytech
    static constexpr uint32_t PT_Size_Bytes = (PT_Size * sizeof(uint32_t));

    // tolik tabulek stranek jsme schopni pridelit
    static constexpr uint32_t PT_Count = mem::PageSize / PT_Size_Bytes;

    // bitova mapa alokace (0 = volne, 1 = zabrane)
    uint8_t PT_Bitmap[PT_Count / 8];

    // alokovana stranka, ve ktere se udrzuji tabulky stranek procesu
    uint8_t* PT_Page = nullptr;

public:
    CPage_Table_Allocator();

    // alokuje tabulku stranek; vraci virtualni adresu (mapovanou do kerneloveho adr. prostoru) zacatku tabulky
    uint32_t* Alloc();
    // uvolni alokovanou tabulku stranek, prejima prvni
    void Free(uint32_t* pt);
};

extern CPage_Table_Allocator sPT_Alloc;
