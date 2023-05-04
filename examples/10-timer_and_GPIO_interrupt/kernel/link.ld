ENTRY(_start)

MEMORY
{
    ram : ORIGIN = 0x8000, LENGTH = 0x10000
}

SECTIONS
{
    .text :
	{
		*(.text.start*)
		*(.text*)
	} > ram
	
	.data :
    {
		__CTOR_LIST__ = .; *(.ctors) *(.init_array) __CTOR_END__ = .; 
		__DTOR_LIST__ = .; *(.dtors) *(.fini_array) __DTOR_END__ = .;
        data = .;
		_data = .;
		__data = .;
        *(.data)
    } > ram
    
    . = ALIGN(4);
	
	_bss_start = .;
	
    .bss :
	{
		*(.bss*)
	} > ram
	
	_bss_end = .;
}

