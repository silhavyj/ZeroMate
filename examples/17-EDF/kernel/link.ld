ENTRY(_start)

MEMORY
{
	/* initsys_base = oblast, ktera bude mapovana 1:1 do virtualni pameti, ale jakmile bude nacten kernel v higher-half, bude zase odmapovana */
    initsys_base : ORIGIN = 0x8000, LENGTH = 0x10000

	/* virtualni adresa (a oblast) kerneloveho kodu a read-only dat (rx) */
	kernel : ORIGIN = 0xF0000000, LENGTH = 0x100000
	/* virtualni adresa (a oblast) kernelovych dat (rw) */
	kerneldata : ORIGIN = 0xC0000000, LENGTH = 0x100000
}

SECTIONS
{
	/* INITSYS - sekce pro prvotni nacteni jadra do pameti a inicializaci pametove mapy */

	.initsys :
	{
		*(.initsys.start*)
		*(.initsys*)
	} > initsys_base

	.initsys.data :
	{
		*(.initsys.data*)
	} > initsys_base

	__kernel_high_code = ALIGN(4k);
	_virt_code_start = 0xF0000000;

	/* KERNEL - sekce pro jaderny kod a data; zacatek zarovnany na nasobek 4k */

    .text (__kernel_high_code + _virt_code_start) : AT(__kernel_high_code)
	{
		*(.text*)
	} > kernel

	.rodata : {
		*(.rodata*)
	} > kernel

	_virt_code_end = ABSOLUTE(.);
	__high_data_start = ALIGN(4k);

	_virt_data_start = 0xC0000000;
	
	.data (_virt_data_start + __high_data_start - _virt_code_start) : AT(__high_data_start - _virt_code_start)
    {
		__CTOR_LIST__ = .; *(.ctors) *(.init_array) __CTOR_END__ = .; 
		__DTOR_LIST__ = .; *(.dtors) *(.fini_array) __DTOR_END__ = .;
        data = .;
		_data = .;
		__data = .;
        *(.data)

    } > kerneldata
	
	_virt_bss_start = .;
	
    .bss :
	{
		*(.bss*)
		*(COMMON)
	} > kerneldata
	
	_virt_bss_end = .;
	_virt_data_end = ALIGN(4k);


	/* fyzicky rozsah kodove oblasti */
	_phys_code_start = 0x00000000;
	_phys_code_end = _phys_code_start + (_virt_code_end - _virt_code_start);

	/* fyzicky rozsah datove oblasti */
	_phys_data_start = __high_data_start - _virt_code_start;
	_phys_data_end = _phys_data_start + (_virt_data_end - _virt_data_start);

	/* fyzicky rozsah BSS oblasti */
	_phys_bss_start = _phys_data_start + (_virt_bss_start - _virt_data_start);
	_phys_bss_end = _phys_data_start + (_virt_bss_end - _virt_data_start);
}
