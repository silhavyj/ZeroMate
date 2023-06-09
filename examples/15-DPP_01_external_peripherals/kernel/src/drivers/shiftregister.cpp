#include <drivers/shiftregister.h>

// na tvrdo definujeme, ze jsme shift registr pripojili sem - volitelne muzeme pak oddelit do nejake HAL vrstvy pro dany header
CShift_Register sShift_Register(2, 3, 4);

CShift_Register::CShift_Register(uint32_t latchPin, uint32_t dataPin, uint32_t clockPin)
    : mLatch_Pin(latchPin), mData_Pin(dataPin), mClock_Pin(clockPin)
{
    //
}

bool CShift_Register::Open()
{
    if (mOpened)
        return false;

    // rezervujeme vsechny piny pro shift registr

    if (!sGPIO.Reserve_Pin(mLatch_Pin, true, true))
        return false;

    if (!sGPIO.Reserve_Pin(mData_Pin, true, true))
    {
        sGPIO.Free_Pin(mLatch_Pin, true, true);
        return false;
    }

    if (!sGPIO.Reserve_Pin(mClock_Pin, true, true))
    {
        sGPIO.Free_Pin(mLatch_Pin, true, true);
        sGPIO.Free_Pin(mData_Pin, true, true);
        return false;
    }

    // vsechny jsou vystupni
    sGPIO.Set_GPIO_Function(mLatch_Pin, NGPIO_Function::Output);
    sGPIO.Set_GPIO_Function(mData_Pin, NGPIO_Function::Output);
    sGPIO.Set_GPIO_Function(mClock_Pin, NGPIO_Function::Output);

    mOpened = true;

    return true;
}

void CShift_Register::Close()
{
    if (!mOpened)
        return;

    // prepneme piny na vstupni (setreni energii)
    sGPIO.Set_GPIO_Function(mLatch_Pin, NGPIO_Function::Input);
    sGPIO.Set_GPIO_Function(mData_Pin, NGPIO_Function::Input);
    sGPIO.Set_GPIO_Function(mClock_Pin, NGPIO_Function::Input);

    // a vratime je
    sGPIO.Free_Pin(mLatch_Pin, true, true);
    sGPIO.Free_Pin(mData_Pin, true, true);
    sGPIO.Free_Pin(mClock_Pin, true, true);

    mOpened = false;
}

bool CShift_Register::Is_Opened() const
{
    return mOpened;
}

void CShift_Register::Shift_In(bool bit)
{
    if (!mOpened)
        return;

    volatile int i;

    // budeme nahravat bity do banku
    sGPIO.Set_Output(mLatch_Pin, false);

    // nastavime bit
    sGPIO.Set_Output(mData_Pin, bit);
    // clock -> shift registr nasune bit ze vstupu do banku
    sGPIO.Set_Output(mClock_Pin, true);

    // pockat par milisekund
    for (i = 0; i < 0x10; i++)
        ;

    // vratit clock zpatky
    sGPIO.Set_Output(mClock_Pin, false);

    // pockat par milisekund
    for (i = 0; i < 0x10; i++)
        ;

    // propiseme bank do vystupu
    sGPIO.Set_Output(mLatch_Pin, true);
}

void CShift_Register::Shift_In(uint8_t byte)
{
    if (!mOpened)
        return;

    volatile int i;

    // zapisovat do banku
    sGPIO.Set_Output(mLatch_Pin, false);

    // nasuneme bity od nejvyssiho po nejnizsi (aby na vystupu byly v poradi)
    for (int j = 7; j >= 0; j--)
    {
        sGPIO.Set_Output(mData_Pin, ((byte >> j) & 0x1) );
        sGPIO.Set_Output(mClock_Pin, true);
        
        for (i = 0; i < 0x10; i++)
            ;

        sGPIO.Set_Output(mClock_Pin, false);

        for (i = 0; i < 0x10; i++)
            ;
    }

    // propiseme bank na vystup
    sGPIO.Set_Output(mLatch_Pin, true);
}
