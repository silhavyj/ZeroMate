#pragma once

#include <hal/intdef.h>

// knihovni implementace OLED displeje
class COLED_Display
{
    private:
        // otevreny soubor displeje
        uint32_t mHandle;
        // byl soubor otevren?
        bool mOpened;

    public:
        // konstruktor - otevira soubor displeje
        COLED_Display(const char* path = "DEV:oled");
        // destruktor - zavira soubor displeje
        /*virtual*/ ~COLED_Display();

        // je soubor/displej otevreny?
        bool Is_Opened() const;

        // prekresli interni jaderny buffer na vystup displeje
        void Flip();

        // vymaze displej (clearSet - 0 = cernou, 1 = bilou)
        void Clear(bool clearSet = false);
        // nastavi pixel na dane souradnici (set - false = na cernou, true = na bilou)
        void Set_Pixel(uint16_t x, uint16_t y, bool set = true);
        // vykresli znak na vystup displeje z interni sady znaku
        void Put_Char(uint16_t x, uint16_t y, char c);
        // vykresli retezec znaku na displej
        void Put_String(uint16_t x, uint16_t y, const char* str);
};
