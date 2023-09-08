.global _start

;@ tady budou symboly, ktere chceme na zacatek kodove sekce
.section .text.start

;@ vstupni bod do kernelu - nechame ho vlozit na zacatek kodu

.equ    CPSR_MODE_FIQ,          0x11
.equ    CPSR_MODE_IRQ,          0x12
.equ    CPSR_MODE_SVR,          0x13
.equ    CPSR_IRQ_INHIBIT,       0x80
.equ    CPSR_FIQ_INHIBIT,       0x40


;@ kernel reset vektor - tento kod se vykona pri kazdem resetu zarizeni (i prvnim spusteni)
_start:
	mov sp, #0x8000			;@ nastavime stack pointer na spodek zasobniku

	;@ nacteni tabulky vektoru preruseni do pameti
	mov r0, #0x8000			;@ adresa 0x8000 (_start) do r0
    mov r1, #0x0000			;@ adresa 0x0000 (pocatek RAM) do r1 - tam budeme vkladat tabulku vektoru preruseni

	mrc p15, 0, r6, c1, c0, 2
    orr r6, r6, #0x300000
    mcr p15, 0, r6, c1, c0, 2
    mov r6, #0x40000000
    fmxr fpexc, r6

	;@ a vracime se zpet do supervisor modu, SP si nastavime zpet na nasi hodnotu
    mov r0, #(CPSR_MODE_SVR | CPSR_IRQ_INHIBIT | CPSR_FIQ_INHIBIT)
    msr cpsr_c, r0
    mov sp, #0x8000

	bl _c_startup			;@ C startup kod (inicializace prostredi)
	bl _cpp_startup			;@ C++ startup kod (volani globalnich konstruktoru, ...)
	bl _kernel_main			;@ skocime do hlavniho kodu jadra (v C)
	bl _cpp_shutdown		;@ C++ shutdown kod (volani globalnich destruktoru, ...)

hang:
	b hang
