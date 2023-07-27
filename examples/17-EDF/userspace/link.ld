ENTRY(_start)

MEMORY
{
    main : ORIGIN = 0x8000, LENGTH = 0x10000
}

SECTIONS
{
    .text :
	{
		*(.text*)
	} > main

	.rodata :
    {
		*(.rodata*)
	} > main
	
	.data :
    {
		__CTOR_LIST__ = .; *(.ctors) *(.init_array) __CTOR_END__ = .; 
		__DTOR_LIST__ = .; *(.dtors) *(.fini_array) __DTOR_END__ = .;
        data = .;
		_data = .;
		__data = .;
        *(.data)
    } > main
	
    .bss :
	{
        __bss_start = .;

		*(.bss*)
		*(COMMON)

        __bss_end = .;
	} > main
}
