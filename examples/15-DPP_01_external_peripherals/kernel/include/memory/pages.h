#pragma once

#include <hal/intdef.h>
#include "memmap.h"

// page manager pro ted jeste operuje s fyzickymi adresami, do budoucna, az prejdeme na praci s MMU, bude umet navic i
// operace s virtualnimi adresami a mapovani do adresnich prostoru uziv. procesu a jadra

class CPage_Manager
{
    private:
        uint8_t mPage_Bitmap[mem::PageCount / 8];

        void Mark(uint32_t page_idx, bool used);

    public:
        CPage_Manager();

        // alokuje novou stranku, vraci fyzickou adresu pridelene stranky (pro ted)
        uint32_t Alloc_Page();
        // dealokuje stranku s danou fyzickou adresou (pro ted)
        void Free_Page(uint32_t fa);
};

extern CPage_Manager sPage_Manager;
