#include <oled.h>
#include <stdfile.h>
#include <stdstring.h>

#include <drivers/monitor.h>
#include <drivers/bridges/display_protocol.h>

// tento soubor includujeme jen odtud
#include "oled_font.h"

COLED_Display::COLED_Display(const char* path)
    : mHandle{ open(path, NFile_Open_Mode::Write_Only) }, mOpened(false)
{
    // nastavime priznak dle toho, co vrati open
    mOpened = (mHandle != static_cast<uint32_t>(-1));
}

COLED_Display::~COLED_Display()
{
    // pokud byl displej otevreny, zavreme
    if (mOpened)
    {
        mOpened = false;
        close(mHandle);
    }
}

bool COLED_Display::Is_Opened() const
{
    return mOpened;
}

void COLED_Display::Clear(bool clearSet)
{
    if (!mOpened)
        return;

    TDisplay_Clear_Packet pkt;
	pkt.header.cmd = NDisplay_Command::Clear;
	pkt.clearSet = clearSet ? 1 : 0;
	write(mHandle, reinterpret_cast<char*>(&pkt), sizeof(pkt));
}

void COLED_Display::Set_Pixel(uint16_t x, uint16_t y, bool set)
{
    if (!mOpened)
        return;

    // nehospodarny zpusob, jak nastavit pixely, ale pro ted staci
    TDisplay_Draw_Pixel_Array_Packet pkt;
    pkt.header.cmd = NDisplay_Command::Draw_Pixel_Array;
    pkt.count = 1;
    pkt.first.x = x;
    pkt.first.y = y;
    pkt.first.set = set ? 1 : 0;
    write(mHandle, reinterpret_cast<char*>(&pkt), sizeof(pkt));
}

void COLED_Display::Put_Char(uint16_t x, uint16_t y, char c)
{
    if (!mOpened)
        return;

    // umime jen nektere znaky
    if (c < OLED_Font::Char_Begin || c >= OLED_Font::Char_End)
        return;

    char buf[sizeof(TDisplay_Pixels_To_Rect) + OLED_Font::Char_Width];

    TDisplay_Pixels_To_Rect* ptr = reinterpret_cast<TDisplay_Pixels_To_Rect*>(buf);
    ptr->header.cmd = NDisplay_Command::Draw_Pixel_Array_To_Rect;
    ptr->w = OLED_Font::Char_Width;
    ptr->h = OLED_Font::Char_Height;
    ptr->x1 = x;
    ptr->y1 = y;
    ptr->vflip = OLED_Font::Flip_Chars ? 1 : 0;
    
    memcpy(&OLED_Font::OLED_Font_Default[OLED_Font::Char_Width * (((uint16_t)c) - OLED_Font::Char_Begin)], &ptr->first, OLED_Font::Char_Width);

    /*char* memdst = reinterpret_cast<char*>(&ptr->first);

    for (uint16_t i = 0; i < OLED_Font::Char_Width; ++i)
    {
        sMonitor << static_cast<unsigned int>(memdst[i]) << '\n';
    }*/

    write(mHandle, buf, sizeof(buf));
}

void COLED_Display::Flip()
{
    if (!mOpened)
        return;

    TDisplay_NonParametric_Packet pkt;
    pkt.header.cmd = NDisplay_Command::Flip;

    write(mHandle, reinterpret_cast<char*>(&pkt), sizeof(pkt));
}

void COLED_Display::Put_String(uint16_t x, uint16_t y, const char* str)
{
    if (!mOpened)
        return;

    uint16_t xi = x;
    const char* ptr = str;
    // dokud nedojdeme na konec retezce nebo dokud nejsme 64 znaku daleko (limit, kdyby nahodou se neco pokazilo)
    while (*ptr != '\0' && ptr - str < 64)
    {
        Put_Char(xi, y, *ptr);
        xi += OLED_Font::Char_Width;
        ptr++;
    }
}
