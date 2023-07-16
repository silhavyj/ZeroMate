#pragma once

#include <hal/peripherals.h>
#include <hal/intdef.h>

// symboly definovane v link.ld
extern "C"
{
    // virtualni adresa zacatku kodove sekce (0xF0000000)
    extern const uint32_t _virt_code_start;
    // virtualni adresa zacatku datove sekce (0xC0000000)
    extern const uint32_t _virt_data_start;

    // zacatek .bss sekce
    extern const uint32_t _phys_bss_start;
    // konec .bss sekce
    extern const uint32_t _phys_bss_end;
    // zacatek datove sekce
    extern const uint32_t _phys_data_start;
    // konec datove sekce
    extern const uint32_t _phys_data_end;
}

// pocet zaznamu v tabulce stranek
constexpr uint32_t PT_Size = 4096;

// velikost regionu (ramce) v 1. urovni tabulky stranek, pokud neni pouzita coarse page table
constexpr uint32_t PT_Region_Size = 0x100000;

// priznaky pro dolni bity TTBR registru (TTBR0 a TTBR1)
// https://developer.arm.com/documentation/ddi0301/h/system-control-coprocessor/system-control-processor-registers/c2--translation-table-base-register-0?lang=en
namespace TTBR_Flags
{
    enum : unsigned int
    {
        Inner_Cacheable = 1U << 0,      // cachovatele v L1
        Shared = 1U << 1,               // sdilene mezi procesorovymi jednotkami
        ECC_Enable = 1U << 2,           // error-checking-code (oprava pripadnych chyb) zapnuta
        Write_Back = 1U << 3,           // Write_Back / Write_Through
        No_Allocate_On_Write = 1U << 4, // nebude se provadet write-allocate
    };
}

// priznaky pro dolni bity TTBC registru
// https://developer.arm.com/documentation/ddi0301/h/system-control-coprocessor/system-control-processor-registers/c2--translation-table-base-control-register?lang=en
namespace TTBC_Flags
{
    enum : unsigned int
    {
        Boundary_16k = 0b000U,
        Boundary_8k = 0b001U,
        Boundary_4k = 0b010U,
        Boundary_2k = 0b011U,
        Boundary_1k = 0b100U,
        Boundary_512 = 0b101U,
        Boundary_256 = 0b110U,
        Boundary_128 = 0b111U,

        Disable_Page_Walk_TTBR0 = 1U << 4,
        Disable_Page_Walk_TTBR1 = 1U << 5,
    };
}

// priznaky domain access control registru
// https://developer.arm.com/documentation/ddi0301/h/system-control-coprocessor/system-control-processor-registers/c3--domain-access-control-register?lang=en
namespace DACR_Flags
{
    enum : unsigned int
    {
        No_Access = 0b00, // domena se nepouziva => pri pristupu vznikne abort
        Client = 0b01,    // domena se pouziva v klientskem rezimu
        Manager = 0b11,   // domena se pouziva v rezimu manazera ("supervizor", muze vse)
    };
}

// priznaky AUX control registru
// https://developer.arm.com/documentation/ddi0301/h/system-control-coprocessor/system-control-processor-registers/c1--auxiliary-control-register?lang=en
namespace AUXCtl_Flags
{
    enum : unsigned int
    {
        Return_Stack_Enable = 1U << 0,                // optimalizace navratu z funkci - predikce
        Dynamic_Branch_Prediction_Enable = 1U << 1,   // povoleni dynamicke predikce skoku
        Static_Branch_Prediction_Enable = 1U << 2,    // povoleni staticke predikce skoku
        MicroTLB_Random_Replacement_Enable = 1U << 3, // kdyz neni nastaveny, je strategie RoundRobin
        Clean_Entire_Data_Cache_Disable = 1U << 4,    // zakaze mazani cele cache pri vyprazdnovani
        Block_Transfer_Cache_Disable = 1U << 5,       // zakazuje cache pri blokovych presunech
        Cache_Size_16k =
        1U
        << 6, // omezuje velikost cache na 16kB (zpetne kompatibilni se starsimi procesory, zakazuje obarvovani stranek)
        Prefetch_Halt_Disable =
        1U << 28, // optimalizuje vyuziti prefetch bufferu pri vykonavani nepredikovatelnych instrukci
        Branch_Folding_Disable =
        1U
        << 29, // zakazuje branch folding
               // (https://developer.arm.com/documentation/ddi0211/h/program-flow-prediction/branch-prediction/branch-folding)
        Force_Speculative_Ops_Disable = 1U << 30,  // zakazuje spekulativni provadeni vybranych operaci
        Override_Low_Latency_Interrupt = 1U << 31, // zakazuje vybrane funkce pri zpracovani preruseni
    };
}

// priznaky MMU control registru
// https://developer.arm.com/documentation/ddi0301/h/system-control-coprocessor/system-control-processor-registers/c1--control-register?lang=en
namespace MMUCR_Flags
{
    enum : unsigned int
    {
        MMU_Enable = 1U << 0,                // povoli MMU (a lookup virtualnich adres)
        Strict_Alignment_Enable = 1U << 1,   // kdyz je zapnuto, pri pristupu do pameti adresy musi byt zarovnany na
                                             // nasobky 4 (nebo 2), jinak je vyhozen abort
        Data_Cache_Enable = 1U << 2,         // povoluje datovou cache

        Big_Endian_Mem = 1U << 7,            // prepina pristupy do pameti do big-endian rezimu
        MMU_Protection_Enable = 1U << 8,     // deprecated
        ROM_Protection_Enable = 1U << 9,     // deprecated

        Branch_Prediction_Enable = 1U << 11, // povoluje branch prediction
        Instruction_Cache_Enable = 1U << 12, // povoluje instrukcni cache
        High_Exception_Vectors =
        1U << 13, // kdyz je zapnuto, handlery preruseni se hledaji na adrese 0xFFFF0000 - 0xFFFF001C
        Round_Robin_Cache_Replace = 1U << 14, // cache replace algoritmus se prepne na round-robin (z random)
        PC_Load_T_Bit = 1U << 15,             // pri kazdem update PC se nastavuje T bit (Thumb rezim procesoru)

        Low_Interrupt_Latency_Configuration_Enable = 1U << 21, // low latency podpora pro FIQ
        Unaligned_Memory_Access_Enable =
        1U << 22, // pri zapnuti tohoto bitu nebude vyzadovano zarovnani adres na nasobky 4 (resp. 2)
        Disable_Subpage_AP = 1U << 23, // zapina extended page table featuru
        VIC_Defined_Interrupt_Vectors =
        1U << 24,                      // VIC (vectored interrupt controller) definovana tabulka vektoru preruseni
        CPSR_E_Bit_Set_On_Exception = 1U << 25, // vyjimky budou nastavovat E bit v CPSR

        TEX_Remap_Enable = 1U << 28,            // povoluje premapovani TEX bitu (v deskriptoru stranek)
        Force_AP_Enable = 1U << 29,             // vynuceni kontroly AP a generovani access bit faultu
    };
}

// descriptor level 1 priznaky
namespace DL1_Flags
{
    enum : unsigned int
    {
        Access_Type_Translation_Fault =
        0b00U, // zaznam v tabulce chybi - pristup vygeneruje abort (data nebo prefetch, podle typu pristupu)
        Access_Type_Page_Table_Base_Address = 0b01U, // zaznam odkazuje na zanorenou tabulku stranek
        Access_Type_Section_Address = 0b10U,         // zaznam odkazuje uz na ramec pameti

        Cacheable = 1U << 2,  // tento kus pameti bude pri pristupech mozne cachovat, a to jak pro cteni, tak pro zapis
                              // (write-through nebo write-back dle jinych bitu)
        Bufferable = 1U << 3, // zapisy do teto pameti mohou byt bufferovany (tedy CPU muze pokracovat v praci, nez bude
                              // skutecny zapis dokoncen)

        Execute_Never = 1U << 4, // aktivni jen pokud je zapnuty v MMUCTR bit Disable_Subpage_AP

        Domain_0 = 0b0000U << 5,
        Domain_1 = 0b0001U << 5,
        Domain_2 = 0b0010U << 5,
        Domain_3 = 0b0011U << 5,
        Domain_4 = 0b0100U << 5,
        Domain_5 = 0b0101U << 5,
        Domain_6 = 0b0110U << 5,
        Domain_7 = 0b0111U << 5,
        Domain_8 = 0b1000U << 5,
        Domain_9 = 0b1001U << 5,
        Domain_10 = 0b1010U << 5,
        Domain_11 = 0b1011U << 5,
        Domain_12 = 0b1100U << 5,
        Domain_13 = 0b1101U << 5,
        Domain_14 = 0b1110U << 5,
        Domain_15 = 0b1111U << 5,

        ECC_Enabled = 1U << 9,                        // indikuje, ze tento region ma zapnuty ECC checking

        Access_None = 0b00U << 10,                    // nikdo nemuze pristupovat
        Access_Privileged_RW_User_None = 0b01U << 10, // privilegovany rezim - read/write, uzivatelsky nesmi pristupovat
        Access_Privileged_RW_User_R = 0b10U << 10,    // privilegovany rezim - read/write, uzivatelsky - read-only
        Access_Full_RW = 0b11U << 10,                 // kdokoliv - read/write

        TEX_000 = 0b000U << 12,                       // pro Type EXtension casto ponechame vychozi hodnotu
        TEX_001 = 0b001U << 12,
        // TEX spolu s Cacheable a Bufferable meni ruzne politiku cachovani a sdileni,
        // viz
        // https://developer.arm.com/documentation/ddi0301/h/memory-management-unit/memory-region-attributes/c-and-b-bit--and-type-extension-field-encodings?lang=en

        APX_RW = 0U << 15, // neomezuje privilegovany rezim v pristupu
        APX_R = 1U << 15,  // privilegovany rezim bude mit misto read/write prav jen read-only prava
        Shareable =
        1U << 16, // lze sdilet mezi procesory? typicky chceme sdilet, pokud nevyzadujeme nejakou uroven bezpecnosti
        Non_Global = 1U << 17, // pokud je nastaveny, do TLB se uklada i ID adresniho prostoru procesu (tasku), aby se
                               // zamezilo ponechavani zaznamu pri prepnuti kontextu

        // bit 18 je rezervovany a mel by byt nastaven na 0

        Non_Secure = 1U << 19, // pro secure monitor rezim - akce jsou vykonavany jako kdybychom byli v "nonsecure" modu
    };
}

// symboly z mmu.s

extern "C" void mmu_invalidate_cache();
extern "C" void mmu_data_sync_barrier();
extern "C" void mmu_invalidate_tlb();

// zkopiruje tabulku stranek jadra do dodane tabulky
void copy_kernel_page_table_to(uint32_t* target);
// namapuje do zadane tabulky dane adresy; pro ted jde jen o stranky velikosti 1MB
void map_memory(uint32_t* target_pt, uint32_t phys, uint32_t virt);
