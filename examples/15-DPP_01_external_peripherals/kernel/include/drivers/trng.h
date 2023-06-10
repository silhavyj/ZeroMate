#pragma once

#include <hal/peripherals.h>

// True Random Number Generator driver
class CTRNG
{
    private:
        // baze pro registry
        volatile unsigned int* const mTrng_Regs;

        // citac otevreni - 0 = zavreny, nenulove cislo = pocet otevreni; citac je to proto, ze muze byt pozadovan jak sdileny, tak exkluzivni pristup
        uint32_t mOpened;

    public:
        CTRNG(uint32_t trng_reg_base);

        // otevre TRNG, volitelne pro exkluzivni pristup (aby nikdo jiny "nezral entropii")
        bool Open(bool exclusive);
        // uzavre TRNG, pokud citac klesne na 0, vypne generovani uplne
        void Close();
        // je TRNG otevreny a spusteny?
        bool Is_Opened() const;

        // precte nahodne cislo
        uint32_t Get_Random_Number();
};

extern CTRNG sTRNG;
