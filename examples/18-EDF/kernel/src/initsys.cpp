#include <hal/intdef.h>
#include <hal/peripherals.h>

#include <memory/mmu.h>

extern "C" void __attribute__((section(".text"))) _init_system_memory_high();

// hlavni kernelova tabulka stranek
volatile __attribute__((aligned(0x4000))) __attribute__((section(".initsys.data")))
uint32_t Page_Directory_Kernel[PT_Size];

// prevod virtualni adresy na index sekce v tabulce stranek (1. uroven prekladu)
static uint32_t __attribute__((section(".initsys"))) PT_Entry(uint32_t addr)
{
    return addr >> 20;
}

// inicializace prostredi
// volame jeste nez zapneme strankovani = musi byt v initsys sekci, ktera je "relokovana" 1:1 na fyzickou pamet
extern "C" int __attribute__((section(".initsys"))) _c_startup(void)
{
    int* i;

    // vynulujeme .bss sekci
    for (i = (int*)_phys_bss_start; i < (int*)_phys_bss_end; i++)
        *i = 0;

    return 0;
}

extern "C" void __attribute__((section(".initsys"))) __attribute__((noreturn)) _init_system_memory()
{
    // vyprazdnime tabulku stranek - budeme ji plnit konkretnimi zaznamy
    // cokoliv co konci dvema nulovymi bity vyvola pri pokusu o pristup abort
    for (uint32_t i = 0; i < PT_Size; i++)
        Page_Directory_Kernel[i] = DL1_Flags::Access_Type_Translation_Fault;

    // docasna zalezitost - 1:1 mapovani (tzv. "identity mapping") celeho spodku pameti (mapujeme vsechno pro ted, do
    // budoucna by mohlo stacit jen neco) kdybychom tohle neudelali, v momente, kdy bychom nahrali tabulku stranek a
    // zapnuli MMU, okamzite by doslo k page fault vyjimce (resp. abort na ARM) tohle pak zase odebereme, az budeme
    // provadet kod v higher half
    unsigned int addr;
    for (addr = 0; addr < 0x20000000; addr += PT_Region_Size)
    {
        Page_Directory_Kernel[PT_Entry(addr)] =
        addr | DL1_Flags::Access_Type_Section_Address | DL1_Flags::Bufferable | DL1_Flags::Cacheable |
        DL1_Flags::Domain_0 | DL1_Flags::Access_Privileged_RW_User_None | DL1_Flags::TEX_001 | DL1_Flags::Shareable;
    }

    // memory-mapped I/O pro periferie, necachovane (!), nebufferovane (!), RW jen pro privilegovany rezim (nechceme,
    // aby nam uzivatelske procesy manipulovaly s HW primo)
    for (addr = hal::Peripheral_Base; addr < hal::Peripheral_Base + 0x20000000; addr += PT_Region_Size)
    {
        Page_Directory_Kernel[PT_Entry(addr)] = addr | DL1_Flags::Access_Type_Section_Address | DL1_Flags::Domain_0 |
                                                DL1_Flags::Access_Privileged_RW_User_None | DL1_Flags::TEX_000 |
                                                DL1_Flags::Shareable;
    }

    // kernel kod - konstantni, budeme z nej v podstate jen cist a spoustet ho
    // mapujeme 0xF0000000-0xF0FFFFFF na 0x00000000-0x00FFFFFF
    for (addr = 0xF0000000; addr < 0xF1000000; addr += PT_Region_Size)
    {
        Page_Directory_Kernel[PT_Entry(addr)] =
        (addr - 0xF0000000) | DL1_Flags::Access_Type_Section_Address | DL1_Flags::Bufferable | DL1_Flags::Cacheable |
        DL1_Flags::Domain_0 | DL1_Flags::Access_Privileged_RW_User_None | DL1_Flags::TEX_001 | DL1_Flags::Shareable;
    }

    // mapujeme 0xC0000000-0xCFFFFFFF na 0x00000000-0x0FFFFFFF (abychom meli z kernelu pristup do veskere fyzicke pameti
    // "jako k datum")
    for (addr = 0xC0000000; addr < 0xD0000000; addr += PT_Region_Size)
    {
        Page_Directory_Kernel[PT_Entry(addr)] = (addr - 0xC0000000) | DL1_Flags::Access_Type_Section_Address |
                                                DL1_Flags::Cacheable | DL1_Flags::Domain_0 | DL1_Flags::Execute_Never |
                                                DL1_Flags::Access_Privileged_RW_User_None | DL1_Flags::TEX_000 |
                                                DL1_Flags::Shareable;
    }

    // systemove zasobniky (0xFFFF3000 - 0xFFFF8000), exception vektory (0xFFFF0000 - 0xFFFF001C)
    Page_Directory_Kernel[PT_Entry(0xFFF00000)] =
    0 | DL1_Flags::Access_Type_Section_Address | DL1_Flags::Bufferable | DL1_Flags::Cacheable | DL1_Flags::Domain_0 |
    DL1_Flags::Access_Privileged_RW_User_R | DL1_Flags::TEX_000 | DL1_Flags::Shareable;

    // velikost cache chceme na 16k - bude to pro nas ted jednodussi (zpetne kompatibilni, bez obarvovani zaznamu, ...)
    unsigned int auxctl_flags;
    asm volatile("mrc p15, 0, %0, c1, c0,  1" : "=r"(auxctl_flags));
    auxctl_flags |= AUXCtl_Flags::Cache_Size_16k;
    asm volatile("mcr p15, 0, %0, c1, c0,  1" ::"r"(auxctl_flags));

    // oznacime domenu 0 jako pouzivanou - klientsky (ne jako manazer domeny)
    unsigned int domain_access = DACR_Flags::Client << 0;
    asm volatile("mcr p15, 0, %0, c3, c0, 0" ::"r"(domain_access));

    // tady rozdelujeme prostor na ten, ktery bude prekladat registr TTBR0 a TTBR1, nastavenim na 16k boundary
    // zajistime, ze se vsechny preklady budou cinit jen pomoci TTBR0 registru
    unsigned int ttbc = TTBC_Flags::Boundary_16k;
    asm volatile("mcr p15, 0, %0, c2, c0, 2" ::"r"(ttbc));

    // nastavime nasi tabulku stranek do registru TTBR0 spolu s nastavenim - cachovatelne do L1, sdilena
    unsigned int ttbr0 =
    reinterpret_cast<volatile unsigned int>(&Page_Directory_Kernel) | TTBR_Flags::Inner_Cacheable | TTBR_Flags::Shared;
    asm volatile("mcr p15, 0, %0, c2, c0, 0" ::"r"(ttbr0));

    // invalidujeme datovou cache a prefetch buffer
    asm volatile("mcr p15, 0, %0, c7, c5,  4" ::"r"(0) : "memory");
    asm volatile("mcr p15, 0, %0, c7, c6,  0" ::"r"(0) : "memory");

    // zapneme vsechno mozne v MMUCR registru - zapneme MMU, datovou a instrukcni cache, predikci skoku a zapneme si
    // extended stranky
    unsigned int mmucr;
    asm volatile("mrc p15,0,%0,c1,c0,0" : "=r"(mmucr));

    mmucr = mmucr | MMUCR_Flags::MMU_Enable | MMUCR_Flags::Data_Cache_Enable | MMUCR_Flags::Branch_Prediction_Enable |
            MMUCR_Flags::Instruction_Cache_Enable | MMUCR_Flags::High_Exception_Vectors |
            MMUCR_Flags::Unaligned_Memory_Access_Enable // toto se muze negativne podepsat na vykonu
            | MMUCR_Flags::Disable_Subpage_AP;

    asm volatile("mcr p15,0,%0,c1,c0,0" ::"r"(mmucr) : "memory");

    /*
     * V tento moment je pametovy layout pripraveny na prepnuti do ciloveho rezimu
     * - kernel kod je v horni casti virtualni pameti
     * - kernel data jsou v horni casti pod kodem
     * - periferie jsou mapovane jen pro kernel
     * - zatim jeste stale mapujeme dolni kus pameti 1:1 - to musime po skoku do higher-half umazat
     *
     * Nyni skocime do higher half, odmapujeme spodek a pokracujeme dal (inicializace periferii, volani konstruktoru,
     * ...)
     *
     * Nutno dodat, ze kernel bude takto nahrany v KAZDEM pametovem prostoru VSECH procesu, coz dovoluje v kontextu
     * daneho procesu vykonavat napriklad obsluhy systemovych volani (prepne se tim jen privilege level, a razem muzeme
     * kod kernelu spoustet a data kernelu cist a zapisovat)
     */

    // skok do hlavniho kodu kernelu, ktery je relokovany na vrchi cast pameti (0xF0000000 a dal)
    asm volatile("mov lr, %[_init_system_memory_high]"
                 :
                 : [_init_system_memory_high] "r"((unsigned int)&_init_system_memory_high));
    asm volatile("bx lr");

    // uspokojeni kompilatoru - funkce je dekorovana atributem noreturn, takze kompilator neceka, ze se z teto funkce
    // budeme vracet fakticky se sice vracime ("bx lr" vyse), ale to kompilator nevidi a jde vlastne o trochu jiny druh
    // navratu
    while (true)
        ;
}
