MEMORY
{
    ram : ORIGIN = 0x1000, LENGTH = 0x1000
}

SECTIONS
{
    .text : { 
        *(.text*)
    } > ram

    .bss : {
        *(.bss*)
    } > ram
}
