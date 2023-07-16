#pragma once

#include <hal/intdef.h>
#include "memmap.h"

class CPage_Manager
{
private:
    uint8_t mPage_Bitmap[mem::PageCount / 8];

    void Mark(uint32_t page_idx, bool used);

public:
    CPage_Manager();

    // alokuje novou stranku, vraci virtualni adresu pridelene stranky v adresnim prostoru kernelu
    uint32_t Alloc_Page();
    // dealokuje stranku s danou virtualni adresou (adr. prostor kernelu)
    void Free_Page(uint32_t fa);
};

extern CPage_Manager sPage_Manager;
