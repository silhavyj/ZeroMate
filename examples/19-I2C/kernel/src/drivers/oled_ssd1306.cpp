#include <drivers/oled_ssd1306.h>
#include <drivers/monitor.h>
#include <memory/kernel_heap.h>

#include <drivers/bridges/display_protocol.h>

CDisplay_SSD1306 sDisplay_SSD1306(sI2C1);

CDisplay_SSD1306::CDisplay_SSD1306(CI2C& i2c)
    : mI2C(i2c), mOpened(false), mBuffer(nullptr), mWidth(0), mHeight(0)
{

}

bool CDisplay_SSD1306::Open(int width, int height)
{
    if (!mI2C.Open())
        return false;

    mOpened = true;

    // zaokrouhlime nahoru na nasobek osmi (na cele stranky)
    if (height % 8 != 0)
        height += 8 - (height % 8);

    mWidth = width;
    mHeight = height;

    // alokujeme si buffer, ten je velky tak jako displej
    // dalo by se to optimalizovat, napr. primym kreslenim, bufferovanim vyrezu, apod.
    // ale to my ted nepotrebujeme, obzvlast kdyz spotrebujeme max jednotky kB a mame k dispozici >512MB RAM
    mBuffer = new uint8_t[mWidth * mHeight / 8];

    // vypneme displej, nastavime clock ratio (z datasheetu, doporucena hodnota), nastavime multiplex ratio (vysku displeje)
    {
        auto& ta = mI2C.Begin_Transaction(SSD1306_Slave_Address);

        ta << SSD1306_Cmd::Command_Start
            << SSD1306_Cmd::Display_Off
            << SSD1306_Cmd::Set_Display_Clock_Div_Ratio
            << 0x80
            << SSD1306_Cmd::Set_Multiplex_Ratio;

        mI2C.End_Transaction(ta);
    }

    // pokracovani predchoziho - multiplex ratio
    {
        auto& ta = mI2C.Begin_Transaction(SSD1306_Slave_Address);

        ta << SSD1306_Cmd::Command_Start
            << height - 1;

        mI2C.End_Transaction(ta);
    }

    // nastavime display offset (pametovy offset a jeho matching na realnou matici), pocatecni radek a vlastnosti vnitrniho menice (nabojova pumúa)
    {
        auto& ta = mI2C.Begin_Transaction(SSD1306_Slave_Address);

        ta << SSD1306_Cmd::Command_Start
            << SSD1306_Cmd::Set_Display_Offset
            << 0x00
            << (static_cast<uint8_t>(SSD1306_Cmd::Set_Start_Line) | 0x00) // zacatek na radce 0
            << SSD1306_Cmd::Charge_Pump;

        mI2C.End_Transaction(ta);
    }

    // pokracovani predchoziho - nabojova pumpa, 0x14 je hodnota z datasheetu pro konkretni displej
    {
        auto& ta = mI2C.Begin_Transaction(SSD1306_Slave_Address);

        ta << SSD1306_Cmd::Command_Start
            << 0x14;

        mI2C.End_Transaction(ta);
    }

    // nastavime mod adresace (0x00 - po sloupcich a po strankach) a segment remapping (to, jak je displej "obraceny")
    // "smer" skenovani vystupu ridiciho obvodu
    {
        auto& ta = mI2C.Begin_Transaction(SSD1306_Slave_Address);

        ta << SSD1306_Cmd::Command_Start
            << SSD1306_Cmd::Memory_Addr_Mode
            << 0x00
            << (static_cast<uint8_t>(SSD1306_Cmd::Set_Segment_Remap) | 0x01)
            << SSD1306_Cmd::Com_Scan_Dir_Dec;

        mI2C.End_Transaction(ta);
    }

    // mapovani na piny ridiciho obvodu
    {
        auto& ta = mI2C.Begin_Transaction(SSD1306_Slave_Address);

        ta << SSD1306_Cmd::Command_Start
            << SSD1306_Cmd::Set_Com_Pins;

        mI2C.End_Transaction(ta);
    }

    // pokracovani predchoziho - neinvertovany a sekvencni pristup
    {
        auto& ta = mI2C.Begin_Transaction(SSD1306_Slave_Address);

        ta << SSD1306_Cmd::Command_Start
            << 0x02;

        mI2C.End_Transaction(ta);
    }

    // nastaveni kontrastu displeje
    {
        auto& ta = mI2C.Begin_Transaction(SSD1306_Slave_Address);

        ta << SSD1306_Cmd::Command_Start
            << SSD1306_Cmd::Set_Contrast;

        mI2C.End_Transaction(ta);
    }

    // pokracovani predchoziho - kontrast nastaven na 0x8F
    {
        auto& ta = mI2C.Begin_Transaction(SSD1306_Slave_Address);

        ta << SSD1306_Cmd::Command_Start
            << 0x8F;

        mI2C.End_Transaction(ta);
    }

    // perioda prednabiti
    {
        auto& ta = mI2C.Begin_Transaction(SSD1306_Slave_Address);

        ta << SSD1306_Cmd::Command_Start
            << SSD1306_Cmd::Set_Precharge_Period;

        mI2C.End_Transaction(ta);
    }

    // pokracovani predchoziho - pro externi napajeni muze byt tato hodnota kratsi
    {
        auto& ta = mI2C.Begin_Transaction(SSD1306_Slave_Address);

        ta << SSD1306_Cmd::Command_Start
            << 0xF1;

        mI2C.End_Transaction(ta);
    }

    // finalni aktivace displeje - uroven detekce vstupu, nahozeni panelu, neinvertovane barvy, neskrolujeme, zapneme podsviceni
    {
        auto& ta = mI2C.Begin_Transaction(SSD1306_Slave_Address);

        ta << SSD1306_Cmd::Command_Start
            << SSD1306_Cmd::Set_VCOM_Detect
            << 0x40
            << SSD1306_Cmd::Display_All_On_Resume
            << SSD1306_Cmd::Normal_Display
            << SSD1306_Cmd::Deactivate_Scroll
            << SSD1306_Cmd::Display_On;

        mI2C.End_Transaction(ta);
    }

    Clear();

    return true;
}

void CDisplay_SSD1306::Send_Command(SSD1306_Cmd cmd, uint8_t lowPart)
{
    auto& ta = mI2C.Begin_Transaction(SSD1306_Slave_Address);

    ta << SSD1306_Cmd::Command_Start
       << (static_cast<uint8_t>(cmd) | lowPart);

    mI2C.End_Transaction(ta);
}

void CDisplay_SSD1306::Close()
{
    if (!mOpened)
        return;

    // posleme prikaz z vypnuti displeje
    {
        auto& ta = mI2C.Begin_Transaction(SSD1306_Slave_Address);

        ta << SSD1306_Cmd::Command_Start
            << SSD1306_Cmd::Display_Off;

        mI2C.End_Transaction(ta);
    }

    mI2C.Close();

    delete mBuffer;

    mOpened = false;
}

bool CDisplay_SSD1306::Is_Opened() const
{
    return mOpened;
}

void CDisplay_SSD1306::Clear(bool clearWhite)
{
    if (!mOpened)
        return;

    const uint8_t clearColor = clearWhite ? 0xFF : 0x00;

    const int maxIdx = mWidth * (mHeight / 8);

    for (int i = 0; i < maxIdx; i++)
        mBuffer[i] = clearColor;

    Flip();
}

void CDisplay_SSD1306::Set_Pixel(uint32_t x, uint32_t y, bool set)
{
    if (!mOpened)
        return;

    if (set)
        mBuffer[x + (y / 8) * mWidth] |= (1 << (y & 7));
    else
        mBuffer[x + (y / 8) * mWidth] &= ~(1 << (y & 7));
}

void CDisplay_SSD1306::Flip()
{
    if (!mOpened)
        return;

    int i;

    // nastavime kurzor na levy horni roh
    {
        auto& ta = mI2C.Begin_Transaction(SSD1306_Slave_Address);

        ta << SSD1306_Cmd::Command_Start
            << SSD1306_Cmd::Set_Page_Addr
            << 0x00
            << 0xFF
            << SSD1306_Cmd::Set_Column_Addr
            << 0x00
            << mWidth - 1;

        mI2C.End_Transaction(ta);
    }

    // budeme posilat pixely po balikach 4 sloupcu (po 8 pixelech)
    constexpr int PktSize = 4;

    const int maxIdx = mWidth * (mHeight / 8);

    for (int i = 0; i < maxIdx; i += PktSize)
    {
        auto& ta = mI2C.Begin_Transaction(SSD1306_Slave_Address);

        ta << SSD1306_Cmd::Data_Continue;
        for (int j = 0; j < PktSize; j++)
        {
            ta << mBuffer[i + j];
            // sMonitor << "Sending " << static_cast<unsigned int>(mBuffer[i + j]) << '\n';
        }

        mI2C.End_Transaction(ta);
    }
}

void CDisplay_SSD1306::Process_External_Command(const char* input, uint32_t length)
{
    if (length <= 0)
        return;

    NDisplay_Command cmd = static_cast<NDisplay_Command>(input[0]);

    switch (cmd)
    {
        case NDisplay_Command::Nop:
            sMonitor << "External CMD: NOP\n";
            break;

        case NDisplay_Command::Flip:
            sMonitor << "External CMD: Flip\n";
            Flip();
            break;

        case NDisplay_Command::Clear:
        {
            sMonitor << "External CMD: Clear\n";

            if (length != sizeof(TDisplay_Clear_Packet))
                return;

            const TDisplay_Clear_Packet* pkt = reinterpret_cast<const TDisplay_Clear_Packet*>(input);

            Clear((pkt->clearSet != 0));

            break;
        }

        case NDisplay_Command::Draw_Pixel_Array:
        {
            sMonitor << "External CMD: Draw_Pixel_Array\n";

            if (length < sizeof(TDisplay_Draw_Pixel_Array_Packet))
                return;

            const TDisplay_Draw_Pixel_Array_Packet* pkt = reinterpret_cast<const TDisplay_Draw_Pixel_Array_Packet*>(input);

            const TDisplay_Pixel_Spec* ptr = &pkt->first;

            for (uint16_t i = 0; i < pkt->count; i++)
                Set_Pixel(ptr->x, ptr->y, (ptr->set != 0));

            break;
        }

        case NDisplay_Command::Draw_Pixel_Array_To_Rect:
        {
            sMonitor << "External CMD: Draw_Pixel_Array_To_Rect\n";

            if (length < sizeof(TDisplay_Pixels_To_Rect))
                return;

            const TDisplay_Pixels_To_Rect* pkt = reinterpret_cast<const TDisplay_Pixels_To_Rect*>(input);

            const uint8_t* data = &pkt->first;

            sMonitor << "pkt->vflip = " << (pkt->vflip == 0) << '\n';

            if (pkt->vflip == 0)
            {
                for (uint16_t x = pkt->x1; x < pkt->x1 + pkt->w; x++)
                {
                    for (uint16_t y = pkt->y1; y < pkt->y1 + pkt->h; y++)
                    {
                        const uint16_t pos = ((y - pkt->y1) * pkt->w + (x - pkt->x1));

                        
                        Set_Pixel(x, y, ((data[pos / 8] >> (7 - (pos % 8))) & 0x1) != 0);
                    }
                }
            }
            else
            {
                // sMonitor << "pkt->w = " << static_cast<unsigned int>(pkt->w) << '\n';
                // sMonitor << "pkt->h = " << static_cast<unsigned int>(pkt->h) << '\n';
                // sMonitor << "pkt->x1 = " << static_cast<unsigned int>(pkt->x1) << '\n';
                // sMonitor << "pkt->y1 = " << static_cast<unsigned int>(pkt->y1) << '\n';

                /*sMonitor << "data = ";
                for (uint16_t i = 0; i < 10; ++i)
                {
                    sMonitor << static_cast<unsigned int>(data[i]) << " ";
                }
                sMonitor << "\n";*/

                for (uint32_t x = 0; x < pkt->w; x++)
                {
                    for (uint32_t y = 0; y < pkt->h; y++)
                    {
                        const uint32_t pos = (x * pkt->h + y);

                        //sMonitor << "x = " << static_cast<unsigned int>(x) << "; y = " << static_cast<unsigned int>(y) << '\n';
                        //sMonitor << "pos = " << static_cast<unsigned int>(pos) << '\n';
                        //sMonitor << "[a; b] = [" << static_cast<unsigned int>(pos / 8) << "; " << static_cast<unsigned int>(7 - (pos % 8)) << "]\n";

                        const bool set = ((data[pos / 8] >> (7 - (pos % 8))) & 0x1) != 0;
                        //sMonitor << "[" << static_cast<unsigned int>((pkt->h - y) + pkt->y1) << "; " << static_cast<unsigned int>(x + pkt->x1) << "] = " << set << "\n";

                        Set_Pixel(x + pkt->x1, (pkt->h - y) + pkt->y1, set);
                    }
                }
            }

            break;
        }
    }
}
