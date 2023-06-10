.global _start

;@ tady budou symboly, ktere chceme na zacatek kodove sekce
.section .text.start

;@ vstupni bod do kernelu - nechame ho vlozit na zacatek kodu
_start:
	;@ tady je predloha tabulky vektoru preruseni, ma dve funkce:
	;@	- sem skoci bootloader, prvni na co narazi je "ldr pc, _reset_ptr" -> tedy se chova jako kdyby slo o reset a skoci na zacatek provadeni
	;@	- v cele svoji krase (vsechny "ldr" instrukce) slouzi jako predloha skutecne tabulce vektoru preruseni
	;@ na dany offset procesor skoci, kdyz je vyvolano libovolne preruseni
	;@ ARM nastavuje rovnou registr PC na tuto adresu, tzn. na teto adrese musi byt kodovana 4B instrukce skoku nekam jinam
	;@ oproti tomu napr. x86 (x86_64) obsahuje v tabulce rovnou adresu a procesor nastavuje PC (CS:IP) na adresu kterou najde v tabulce
	ldr pc, _reset_ptr						;@ 0x00 - reset - vyvolano pri resetu procesoru
	ldr pc, _undefined_instruction_ptr		;@ 0x04 - undefined instruction - vyjimka, vyvolana pri dekodovani nezname instrukce
	ldr pc, _software_interrupt_ptr			;@ 0x08 - software interrupt - vyvolano, kdyz procesor provede instrukci swi
	ldr pc, _prefetch_abort_ptr				;@ 0x0C - prefetch abort - vyvolano, kdyz se procesor snazi napr. nacist instrukci z mista, odkud nacist nejde
	ldr pc, _data_abort_ptr					;@ 0x10 - data abort - vyvolano, kdyz se procesor snazi napr. nacist data z mista, odkud nacist nejdou
	ldr pc, _unused_handler_ptr				;@ 0x14 - unused - ve specifikaci ARM neni uvedeno zadne vyuziti
	ldr pc, _irq_ptr						;@ 0x18 - IRQ - hardwarove preruseni (general purpose)
	ldr pc, _fast_interrupt_ptr				;@ 0x1C - fast interrupt request - prioritni IRQ pro vysokorychlostni zalezitosti

_reset_ptr:
	.word _reset
_undefined_instruction_ptr:
	.word undefined_instruction_handler
_software_interrupt_ptr:
	.word software_interrupt_handler
_prefetch_abort_ptr:
	.word prefetch_abort_handler
_data_abort_ptr:
	.word data_abort_handler
_unused_handler_ptr:
	.word _reset
_irq_ptr:
	.word irq_handler
_fast_interrupt_ptr:
	.word fast_interrupt_handler


.equ    CPSR_MODE_FIQ,          0x11
.equ    CPSR_MODE_IRQ,          0x12
.equ    CPSR_MODE_SVR,          0x13
.equ    CPSR_MODE_SYS,          0x1F
.equ    CPSR_IRQ_INHIBIT,       0x80
.equ    CPSR_FIQ_INHIBIT,       0x40


;@ kernel reset vektor - tento kod se vykona pri kazdem resetu zarizeni (i prvnim spusteni)
_reset:
	;@ nacteni tabulky vektoru preruseni do pameti
	mov r0, #0x8000			;@ adresa 0x8000 (_start) do r0
    mov r1, #0x0000			;@ adresa 0x0000 (pocatek RAM) do r1 - tam budeme vkladat tabulku vektoru preruseni

	;@ Thumb instrukce - nacteni 4B slov z pameti ulozene v r0 (0x8000) do registru r2, 3, ... 9
	;@                 - ulozeni obsahu registru r2, 3, ... 9 do pameti ulozene v registru r1 (0x0000)
    ldmia r0!,{r2, r3, r4, r5, r6, r7, r8, r9}
    stmia r1!,{r2, r3, r4, r5, r6, r7, r8, r9}
    ldmia r0!,{r2, r3, r4, r5, r6, r7, r8, r9}
    stmia r1!,{r2, r3, r4, r5, r6, r7, r8, r9}

	;@ baze pro systemove zasobniky
	mov r4, #0x0

	;@ nejdrive supervisor mod a jeho stack
    mov r0, #(CPSR_MODE_SVR | CPSR_IRQ_INHIBIT | CPSR_FIQ_INHIBIT)
    msr cpsr_c, r0
	add sp, r4, #0x8000

	;@ na moment se prepneme do IRQ rezimu, nastavime mu stack pointer
	mov r0, #(CPSR_MODE_IRQ | CPSR_IRQ_INHIBIT | CPSR_FIQ_INHIBIT)
    msr cpsr_c, r0
	add sp, r4, #0x7000

	;@ na moment se prepneme do FIQ rezimu, nastavime mu stack pointer
	mov r0, #(CPSR_MODE_FIQ | CPSR_IRQ_INHIBIT | CPSR_FIQ_INHIBIT)
    msr cpsr_c, r0
	add sp, r4, #0x6000

	;@ nakonec system mod a stack
    mov r0, #(CPSR_MODE_SYS | CPSR_IRQ_INHIBIT | CPSR_FIQ_INHIBIT)
    msr cpsr_c, r0
	add sp, r4, #0x5000

	;@ zapneme nezarovnany pristup do pameti (nemusi byt zadouci, ale pro nase potreby je to v poradku)
	mrc p15, #0, r4, c1, c0, #0
	orr r4, #0x400000
	mcr p15, #0, r4, c1, c0, #0

	bl _c_startup			;@ C startup kod (inicializace prostredi)
	bl _cpp_startup			;@ C++ startup kod (volani globalnich konstruktoru, ...)
	bl _kernel_main			;@ skocime do hlavniho kodu jadra (v C)
	bl _cpp_shutdown		;@ C++ shutdown kod (volani globalnich destruktoru, ...)
hang:
	b hang

;@ tady budou ostatni symboly, ktere nevyzaduji zadne specialni misto
.section .text

.global disable_irq
disable_irq:
    cpsid i
    bx lr

.global enable_irq
enable_irq:
    mrs r0, cpsr		;@ presun ridiciho registru (CPSR) do general purpose registru (R0)
    bic r0, r0, #0x80	;@ vypne bit 7 v registru r0 ("IRQ mask bit")
    msr cpsr_c, r0		;@ nacteme upraveny general purpose (R0) registr do ridiciho (CPSR)
    cpsie i				;@ povoli preruseni
    bx lr

undefined_instruction_handler:
	b hang

.global _internal_software_interrupt_handler
software_interrupt_handler:
	stmfd sp!,{r2-r12,lr}		;@ ulozime na zasobnik stav

	;@ tady budeme mozna chtit prepinat do SYS rezimu v budoucnu

	ldr r3,[lr,#-4]				;@ do registru r3 nacteme instrukci, ktera vyvolala preruseni (lr = navratova adresa, -4 proto, ze ukazuje na nasledujici instrukci)
    bic r3,r3,#0xff000000		;@ vymaskujeme parametr (dolnich 24 bitu) a nechame ho v r3
	bl _internal_software_interrupt_handler		;@ zavolame nas interni handler
	mov r2, r0					;@ ten vraci pointer na result kontejner v r0, presuneme do r2 - potrebujeme obsah dostat do r0 a r1
	ldr r0, [r2, #0]			;@ nacteme navratove hodnoty do registru
	ldr r1, [r2, #4]
	ldmfd sp!, {r2-r12,pc}^		;@ obnovime ze zasobniku stav (jen puvodni lr nacteme do pc)


.global _internal_irq_handler
irq_handler:
	sub lr, lr, #4
	srsdb #CPSR_MODE_SYS!		;@ ekvivalent k push lr a msr+push spsr
	cpsid if, #CPSR_MODE_SYS	;@ prechod do SYS modu + zakazeme preruseni
	push {r0-r4, r12, lr}		;@ ulozime callee-saved registry

	and r4, sp, #7
	sub sp, sp, r4

	bl _internal_irq_handler	;@ zavolame handler IRQ

	add sp, sp, r4

	pop {r0-r4, r12, lr}		;@ obnovime callee-saved registry
	rfeia sp!					;@ vracime se do puvodniho stavu (ktery ulozila instrukce srsdb)

prefetch_abort_handler:
	;@ tady pak muzeme osetrit, kdyz program zasahne do mista, ktere nema mapovane ve svem virtualnim adr. prostoru
	;@ a treba vyvolat nasi obdobu segfaultu
	b hang

data_abort_handler:
	;@ tady pak muzeme osetrit, kdyz program zasahne do mista, ktere nema mapovane ve svem virtualnim adr. prostoru
	;@ a treba vyvolat nasi obdobu segfaultu
	b hang
