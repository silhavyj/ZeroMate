#pragma once

#include <hal/intdef.h>
#include <drivers/shiftregister.h>

// driver pro (7-)segmentovy displej pripojeny za posuvny registr
class CSegment_Display
{
    private:
        // je driver pouzivan?
        bool mOpened;
        // zobrazeny znak (resp. ten co se snazime zobrazit)
        char mOutput;

        // mapa znaku - tisknutelne znaky bez codepage, tzn. 128 - 32 = 96
        static const uint8_t mCharacter_Map[128 - 32];

    public:
        CSegment_Display();

        // otevre kanal, inicializuje shift registr, rezervuje piny
        bool Open();
        // uzavre kanal, vrati registry
        void Close();
        // je driver pouzivan?
        bool Is_Opened() const;

        // zapise znak na vystup
        void Write(char c);
        // precte znak co je zrovna na vystupu
        char Read() const;
};

extern CSegment_Display sSegment_Display;
