#pragma once

#include <hal/intdef.h>

// tohle budeme vracet z kernelovskych handleru preruseni - asm kod to pak prekopiruje do registru
struct TSWI_Result
{
    uint32_t r0;
    uint32_t r1;
};

// genericke navratove kody, specificke si resi kazda facility po svem
enum class NSWI_Result_Code
{
    OK = 0,
    Fail = 1,
};

// instrukce SWI ma 1B parametr (v rozsahu 0-255)

// parametr volani SWI - horni 2 bity
enum class NSWI_Facility
{
    Process = 0b00,
    Filesystem = 0b01,
};

// zbyva dolnich 6 bitu, tzn. 2^6 (64) moznych sluzeb v ramci faciity

enum class NSWI_Process_Service
{
    // Vraci PID procesu
    // IN:  -
    // OUT: r0 = PID procesu
    Get_PID = 0,

    // Ukonci proces - prevede do stavu zombie a jiz ho nebude planovat
    // IN:  r0 = navratovy/exit kod procesu
    // OUT: -
    Terminate = 1,

    // Preda zbytek prideleneho casoveho kvanta jinemu tasku
    // IN:  -
    // OUT: -
    Yield = 2,
};

enum class NSWI_Filesystem_Service
{
    // Otevre soubor
    // IN:  r0 = ukazatel na retezec identifikujici soubor, r1 = rezim otevreni souboru
    // OUT: r0 = handle otevreneho souboru nebo Invalid_Handle
    Open = 0,

    // Precte ze souboru
    // IN:  r0 = handle otevreneho souboru, r1 = buffer, r2 = pocet znaku/velikost bufferu
    // OUT: r0 = pocet prectenych znaku
    Read = 1,

    // Zapise do souboru
    // IN:  r0 = handle otevreneho souboru, r1 = buffer, r2 = pocet znaku/velikost bufferu
    // OUT: r0 = pocet zapsanych znaku
    Write = 2,

    // Zavre soubor
    // IN:  r0 = handle otevreneho souboru
    // OUT: r0 = indikator uspechu (NSWI_Result_Code)
    Close = 3,

    // Ziska/zmeni parametry souboru dle jeho typu
    // IN:  r0 = handle otevreneho souboru, r1 = identifikator operace (NIOCtl_Operation), r2 = ukazatel na strukturu s
    // nastavenim (specificka pro soubor) OUT: r0 = indikator uspechu (NSWI_Result_Code)
    IOCtl = 4,
};

// mozne IOCtl operace nad souborem
enum class NIOCtl_Operation
{
    Get_Params = 0, // zjisti parametry (nakopiruje do poskytnute prepravky)
    Set_Params = 1, // nastavy parametry (z poskytnute prepravky)
};
