#pragma once

#include <hal/intdef.h>

// prikazy pro monochromaticky displej
enum class NDisplay_Command : uint8_t
{
    // zadna operace
    // 0 bytu na vstupu
    // 0 bytu na vystupu
    Nop = 0,

    // "preklopi" interni buffer na displej
    // 0 bytu na vstupu
    // 0 bytu na vystupu
    Flip = 1,

    // vymaze interni buffer
    // 1 byte na vstupu: uint8_t clearSet (0 = cerna, 1 = bila)
    Clear = 2,

    // vykresli pixely do bufferu
    // 2 + count*5 bytu na vstupu: uint16_t count, TDisplay_Pixel_Spec[] pixels
    Draw_Pixel_Array = 3,

    // vykresli pixely z obdelniku do bufferu
    // 9 + n: uint16_t x1, y1, w, h, vflip, uint8_t[] bitArray
    Draw_Pixel_Array_To_Rect = 4,
};

#pragma pack(push, 1)

// specifikator pixelu ke zmene
struct TDisplay_Pixel_Spec
{
    uint16_t x;
    uint16_t y;
    uint8_t set;
};

// hlavicka paketu
struct TDisplay_Packet_Header
{
    NDisplay_Command cmd;
};

// bezparametricky paket
struct TDisplay_NonParametric_Packet
{
    TDisplay_Packet_Header header;
};

// paket pro vymazani obsahu
struct TDisplay_Clear_Packet
{
    TDisplay_Packet_Header header;
    uint8_t clearSet;
};

// paket pro vykresleni pole pixelu (bez struktury)
struct TDisplay_Draw_Pixel_Array_Packet
{
    TDisplay_Packet_Header header;
    uint16_t count;

    TDisplay_Pixel_Spec first;
};

// paket pro vykresleni pixelu v obdelniku
struct TDisplay_Pixels_To_Rect
{
    TDisplay_Packet_Header header;
    uint16_t x1, y1;
    uint16_t w, h;
    uint8_t vflip; // 0 = nepreklapet obdelnik, 1 = preklopit x a y

    uint8_t first;
};

#pragma pack(pop)
