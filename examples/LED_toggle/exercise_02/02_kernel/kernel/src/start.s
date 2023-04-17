.global _start

;@ tady budou symboly, ktere chceme na zacatek kodove sekce
.section .text.start

;@ vstupni bod do kernelu - nechame ho vlozit na zacatek kodu
_start:
    mov sp,#0x8000			;@ nastavime stack pointer na spodek zasobniku
	bl _c_startup			;@ C startup kod (inicializace prostredi)
	bl _cpp_startup			;@ C++ startup kod (volani globalnich konstruktoru, ...)
    bl _kernel_main			;@ skocime do hlavniho kodu jadra (v C)
	bl _cpp_shutdown		;@ C++ shutdown kod (volani globalnich destruktoru, ...)
hang:
    b hang

;@ tady budou ostatni symboly, ktere nevyzaduji zadne specialni misto
.section .text
	;@ ... zatim tu zadne nejsou
