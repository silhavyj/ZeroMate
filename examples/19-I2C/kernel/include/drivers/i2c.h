#pragma once

#include <hal/peripherals.h>

// maximalni pocet bytu v jedne transakci
constexpr uint32_t I2C_Transaction_Max_Size = 8;

class CI2C;

// trida reprezentujici I2C "transakci"
class CI2C_Transaction
{
    friend class CI2C;
    private:
        bool mIn_Progress = false;
        // bufferovane byty
        uint8_t mBuffer[I2C_Transaction_Max_Size];
        // delka dat
        uint32_t mLength = 0;
        // cilova slave adresa
        uint16_t mAddress = 0;

    public:
        CI2C_Transaction() = default;

        void Set_Address(uint16_t addr)
        {
            mAddress = addr;
        } 

        // vlozeni znaku do bufferu
        template<typename T>
        CI2C_Transaction& operator<<(const T& chr)
        {
            if (mLength >= I2C_Transaction_Max_Size)
                return *this;

            mBuffer[mLength++] = static_cast<uint8_t>(chr);

            return *this;
        }
};

class CI2C
{
    private:
        // baze pro registry BSC (I2C)
        volatile uint32_t* const mBSC_Base;
        // priznak otevreni
        bool mOpened;

        // data pin I2C
        uint32_t mSDA_Pin;
        // clock pin I2C
        uint32_t mSCL_Pin;

        // probihajici transakce
        CI2C_Transaction mTransaction;

    protected:
        volatile uint32_t& Reg(hal::BSC_Reg reg);

        // vycka, az je dokoncena probihajici I2C operace
        void Wait_Ready();

    public:
        CI2C(unsigned long base, uint32_t pin_sda, uint32_t pin_scl);

        // otevre driver
        bool Open();
        // zavre driver
        void Close();
        // je driver otevreny?
        bool Is_Opened() const;

        // odesle pres I2C na danou adresu obsah bufferu
        void Send(uint16_t addr, const char* buffer, uint32_t len);
        // prijme z I2C z dane adresy obsah do bufferu o dane delce
        void Receive(uint16_t addr, char* buffer, uint32_t len);

        // zapocne novou transakci
        CI2C_Transaction& Begin_Transaction(uint16_t addr);
        // ukonci transakci
        void End_Transaction(CI2C_Transaction& transaction, bool commit = true);
};

// TODO: I2C0 a 2
extern CI2C sI2C1;
