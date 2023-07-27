#include <hal/peripherals.h>
#include <memory/mmu.h>

extern volatile __attribute__((section(".initsys.data"))) uint32_t Page_Directory_Kernel[PT_Size];

uint32_t* const Page_Directory_Kernel_High =
reinterpret_cast<uint32_t*>(_virt_data_start + reinterpret_cast<uint32_t>(&Page_Directory_Kernel));

extern "C" void __attribute__((section(".text"))) kernel_mode_start();

static inline uint32_t __attribute__((section(".text"))) PT_Entry(uint32_t addr)
{
    return addr >> 20;
}

extern "C" void __attribute__((section(".text"))) _init_system_memory_high()
{
    // nechame v tabulce stranek jen high mapping kernelu a dat
    unsigned int addr;
    for (addr = 0; addr < 0x20000000; addr += PT_Region_Size)
        Page_Directory_Kernel_High[PT_Entry(addr)] = 0;

    // po modifikaci nesmime zapomenout vymazat cache a TLB
    mmu_invalidate_cache();
    mmu_invalidate_tlb();

    // tady muzeme pak mapovat jeste dalsi veci, ale pro ted to nechme takto

    // odskocime "zpatky" do assembly, kde vykoname zbytek inicializace jadra, co uz musi probihat nad relokovanym kodem
    // a daty
    asm volatile("mov lr, %[kernel_mode_start]" : : [kernel_mode_start] "r"((unsigned int)&kernel_mode_start));
    asm volatile("bx lr");
}

void copy_kernel_page_table_to(uint32_t* target)
{
    // kopirovani by se dalo vyhnout pouzitim TTBR1 a prislusneho nastaveni boundary

    for (unsigned int i = 0; i < PT_Size; i++)
        target[i] = Page_Directory_Kernel_High[i];
}

void map_memory(uint32_t* target_pt, uint32_t phys, uint32_t virt)
{
    // zatim nechme vychozi sadu priznaku
    // do budoucna by se urcite hodilo oddelit kodovou stranku (read-only) a datovou stranku (read-write, execute-never)

    target_pt[PT_Entry(virt)] = (phys & 0xFFF00000) | DL1_Flags::Access_Type_Section_Address | DL1_Flags::Bufferable |
                                DL1_Flags::Cacheable | DL1_Flags::Domain_0 | DL1_Flags::Access_Full_RW |
                                DL1_Flags::TEX_001 | DL1_Flags::Shareable;
}
