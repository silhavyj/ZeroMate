#pragma once

#include <hal/intdef.h>
#include <drivers/gpio.h>

// driver pro posuvny registr 74HC595N (a kupu jinych kompatibilnich)
class CShift_Register
{
    private:
        // pin pro flip interni pameti registru
        uint32_t mLatch_Pin;
        // datovy pin
        uint32_t mData_Pin;
        // pin casovani
        uint32_t mClock_Pin;

        // je driver pouzivan?
        bool mOpened;

    public:
        CShift_Register(uint32_t latchPin, uint32_t dataPin, uint32_t clockPin);

        // otevre kanal, inicializuje shift registr, rezervuje piny
        bool Open();
        // uzavre kanal, vrati registry
        void Close();
        // je driver pouzivan?
        bool Is_Opened() const;

        // nasune jeden bit na vstup
        void Shift_In(bool bit);
        // nasune cely bajt na vstup (nahradi obsah registru)
        void Shift_In(uint8_t byte);
};

extern CShift_Register sShift_Register;
