#pragma once

#include <drivers/gpio.h>
#include <hal/peripherals.h>
#include <memory/kernel_heap.h>
#include <fs/filesystem.h>
#include <stdstring.h>
#include <process/process_manager.h>

// virtualni soubor pro GPIO pin
class CGPIO_File final : public IFile
{
private:
    // ulozeny ID pinu
    int mPinNo;
    // byl pin rezervovan pro cteni?
    bool mRead;
    // byl pin rezervovan pro zapis?
    bool mWrite;

public:
    CGPIO_File(int pinNo, bool read, bool write)
    : IFile(NFile_Type_Major::Character)
    , mPinNo(pinNo)
    , mRead(read)
    , mWrite(write)
    {
        //
    }

    ~CGPIO_File()
    {
        // pokud jeste je otevreny, zavreme
        Close();
    }

    virtual uint32_t Read(char* buffer, uint32_t num) override
    {
        if (num > 0 && buffer != nullptr)
        {
            // na prvni pozici v bufferu precteme bud znak 1 nebo 0 podle stavu digitalniho pinu
            buffer[0] = sGPIO.Get_Input(mPinNo) ? '1' : '0';
            return 1;
        }

        return 0;
    }

    virtual uint32_t Write(const char* buffer, uint32_t num) override
    {
        if (num > 0 && buffer != nullptr)
        {
            // podle prvniho znaku zapiseme bud hodnotu HIGH (true) nebo LOW (false)
            sGPIO.Set_Output(mPinNo, (buffer[0] != '0'));
            return 1;
        }

        return 0;
    }

    virtual bool Close() override
    {
        if (!mRead && !mWrite)
            return false;

        // uvolnime pin
        sGPIO.Free_Pin(mPinNo, mRead, mWrite);
        mRead = mWrite = false;

        return IFile::Close();
    }

    virtual bool IOCtl(NIOCtl_Operation op, void* ctlptr) override
    {
        NGPIO_Interrupt_Type evtype = *reinterpret_cast<NGPIO_Interrupt_Type*>(ctlptr);

        switch (op)
        {
            case NIOCtl_Operation::Enable_Event_Detection:
                sGPIO.Enable_Event_Detect(mPinNo, evtype);
                return true;
            case NIOCtl_Operation::Disable_Event_Detection:
                sGPIO.Disable_Event_Detect(mPinNo, evtype);
                return true;
        }

        return false;
    }

    virtual bool Wait(uint32_t count) override
    {
        Wait_Enqueue_Current();
        sGPIO.Wait_For_Event(this, mPinNo);

        // zablokujeme, probudi nas az notify
        sProcessMgr.Block_Current_Process();
        return true;
    }
};

// driver pro filesystem pro GPIO piny
class CGPIO_FS_Driver : public IFilesystem_Driver
{
public:
    virtual void On_Register() override
    {
        //
    }

    virtual IFile* Open_File(const char* path, NFile_Open_Mode mode) override
    {
        if (mode != NFile_Open_Mode::Read_Only && mode != NFile_Open_Mode::Write_Only)
            return nullptr;

        // tento driver ocekava na vstupu jen jednu jedinou uroven v 'path', a tou je cislo, tedy index GPIO pinu

        int gpionum = atoi(path);
        if (gpionum < 0 || gpionum >= hal::GPIO_Pin_Count)
            return nullptr;

        if (mode == NFile_Open_Mode::Read_Only)
        {
            if (!sGPIO.Reserve_Pin(gpionum, true, false))
                return nullptr;

            sGPIO.Set_GPIO_Function(gpionum, NGPIO_Function::Input);
        }
        else
        {
            if (!sGPIO.Reserve_Pin(gpionum, false, true))
                return nullptr;

            sGPIO.Set_GPIO_Function(gpionum, NGPIO_Function::Output);
        }

        CGPIO_File* f =
        new CGPIO_File(gpionum, mode == NFile_Open_Mode::Read_Only, mode == NFile_Open_Mode::Write_Only);

        return f;
    }
};

CGPIO_FS_Driver fsGPIO_FS_Driver;
