#include <drivers/segmentdisplay.h>

CSegment_Display sSegment_Display;

/*
 * znaky jsou definovany sekvenci bitu, ktere reprezentuji, zda ma dany segment svitit (1) nebo ne (0)
 * ve skutecnosti maji segmenty na headeru spolecnou katodu, takze je to fyzicky obracene, ale to zajima az kod ktery to tam posila
 * 
 * Indexy bitu:
 * 
 *       7
 *      ---- 
 *   1 |    | 4
 *     | 0  |
 *      ---- 
 *   6 |    | 2
 *     | 3  |
 *      ----   . 5
 */
const uint8_t CSegment_Display::mCharacter_Map[128 - 32] = {
    0b11111111, // mezera
    0, // !
    0, // "
    0, // #
    0, // $
    0, // %
    0, // &
    0, // '
    0, // (
    0, // )
    0, // *
    0, // +
    0, // ,
    0, // -
    0, // .
    0, // /
    0b11011110, // 0
    0b00010100, // 1
    0b11011001, // 2
    0b10011101, // 3
    0b00010111, // 4
    0b10001111, // 5
    0b11001111, // 6
    0b10010100, // 7
    0b11011111, // 8
    0b10011111, // 9
    0, // :
    0, // ;
    0, // <
    0, // =
    0, // >
    0, // ?
    0, // @

    0, // A
    0, // B
    0, // C
    0, // D
    0, // E
    0, // F
    0, // G
    0, // H
    0, // I
    0, // J
    0, // K
    0, // L
    0, // M
    0, // N
    0, // O
    0, // P
    0, // Q
    0, // R
    0, // S
    0, // T
    0, // U
    0, // V
    0, // W
    0, // X
    0, // Y
    0, // Z

    0, // [
    0, // zpetne lomitko
    0, // ]
    0, // ^
    0, // _
    0, // `

    0, // a
    0, // b
    0, // c
    0, // d
    0, // e
    0, // f
    0, // g
    0, // h
    0, // i
    0, // j
    0, // k
    0, // l
    0, // m
    0, // n
    0, // o
    0, // p
    0, // q
    0, // r
    0, // s
    0, // t
    0, // u
    0, // v
    0, // w
    0, // x
    0, // y
    0, // z

    0, // {
    0, // |
    0, // }
    0, // ~
    0, // DEL
};

CSegment_Display::CSegment_Display()
    : mOpened(false), mOutput('\0')
{
    //
}

bool CSegment_Display::Open()
{
    if (mOpened)
        return false;

    if (!sShift_Register.Open())
        return false;

    mOpened = true;

    return true;
}

void CSegment_Display::Close()
{
    if (!mOpened)
        return;

    sShift_Register.Close();

    mOpened = false;
}

bool CSegment_Display::Is_Opened() const
{
    return mOpened;
}

void CSegment_Display::Write(char c)
{
    if (!mOpened)
        return;

    uint8_t idx = static_cast<uint8_t>(c);

    // jen tisknutelne zakladni znaky
    if (idx < 32 || idx >= 128)
        return;

    // segmenty jsou invertovane (spolecna katoda), takze tam kde je 0 bude segment svitit
    sShift_Register.Shift_In(static_cast<uint8_t>(~(mCharacter_Map[idx - 32])));
}

char CSegment_Display::Read() const
{
    if (!mOpened)
        return '\0';

    return mOutput;
}