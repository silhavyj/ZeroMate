MEMORY
{
    ram : ORIGIN = 0x0, LENGTH = 0x10000
}

SECTIONS
{
    .text : { 
        *(.text*)
    } > ram
    
    . = ALIGN(4);

    .bss : {
        *(.bss*)
    } > ram
}
