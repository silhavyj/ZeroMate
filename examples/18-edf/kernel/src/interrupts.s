.equ    CPSR_MODE_FIQ,          0x11
.equ    CPSR_MODE_IRQ,          0x12
.equ    CPSR_MODE_SVR,          0x13
.equ    CPSR_MODE_SYS,          0x1F
.equ    CPSR_IRQ_INHIBIT,       0x80
.equ    CPSR_FIQ_INHIBIT,       0x40

.global undefined_instruction_handler
.global software_interrupt_handler
.global irq_handler
.global prefetch_abort_handler
.global data_abort_handler


;@ tady budou ostatni symboly, ktere nevyzaduji zadne specialni misto
.section .text

hang:
    b hang

;@ povoleni preruseni (IRQ)
.global enable_irq
enable_irq:
    cpsie i				;@ povoli preruseni v danem rezimu
    bx lr

;@ zakazani preruseni (IRQ)
.global disable_irq
disable_irq:
	cpsid i				;@ zakaze preruseni v danem rezimu
	bx lr

.global _internal_software_interrupt_handler
software_interrupt_handler:
	mov r12, lr					;@ pouzijeme scratch registr pro ulozeni LR (nemeni se pri prechodu do jineho rezimu)

	srsdb #CPSR_MODE_SYS!		;@ ekvivalent k push lr a push spsr --> uklada do zasobniku specifikovaneho rezimu!
	cpsid if, #CPSR_MODE_SYS	;@ prechod do SYS modu + zakazeme preruseni
	push {r3-r12}				;@ ulozime registry (pro ted proste vsechny krome tech, ktere nebudeme vracet)
	push {lr}

	mov lr, r12					;@ nahrajeme si zpet LR registr, abychom pomoci nej mohli vycist instrukci, ktera vyvolala supervisor call

	ldr r3,[lr,#-4]				;@ do registru r3 nacteme instrukci, ktera vyvolala preruseni (lr = navratova adresa, -4 proto, ze ukazuje na nasledujici instrukci)
    bic r3,r3,#0xff000000		;@ vymaskujeme parametr (dolnich 24 bitu) a nechame ho v r3
	bl _internal_software_interrupt_handler		;@ zavolame nas interni handler
	mov r2, r0					;@ ten vraci pointer na result kontejner v r0, presuneme do r2 - potrebujeme obsah dostat do r0 a r1
	ldr r0, [r2, #0]			;@ nacteme navratove hodnoty do registru
	ldr r1, [r2, #4]

	pop {lr}
	pop {r3-r12}		    	;@ obnovime registry
	rfeia sp!					;@ vracime se do puvodniho stavu (ktery ulozila instrukce srsdb, takze vlastne delame pop cpsr, pop lr)


.global _internal_irq_handler
irq_handler:
	sub lr, lr, #4

	srsdb #CPSR_MODE_SYS!		;@ ekvivalent k push lr a push spsr --> uklada do zasobniku specifikovaneho rezimu!
	cpsid if, #CPSR_MODE_SYS	;@ prechod do SYS modu + zakazeme preruseni
	push {r0-r12}				;@ ulozime registry (pro ted proste vsechny)
	push {lr}

	and r4, sp, #7				;@ zarovname SP na nasobek 8 (viz volaci konvence ARM)
	sub sp, sp, r4

	bl _internal_irq_handler	;@ zavolame handler IRQ

	add sp, sp, r4				;@ "odzarovname" SP -> vracime do puvodniho stavu

	pop {lr}
	pop {r0-r12}		    	;@ obnovime registry
	rfeia sp!					;@ vracime se do puvodniho stavu (ktery ulozila instrukce srsdb, takze vlastne delame pop cpsr, pop lr)

.global generic_abort_handler

;@ momentalne se budeme ke vsem abortum chovat stejne - nejspis maji jedinou pricinu, kterou je pristup do pameti, ktera neni namapovana
;@ v tabulce stranek, nebo je, ale proces na ni nema prava

;@ prefetch a data abort by v systemu se swapem nejprve overil, zda neni stranka jen odlozena na disk (a pripadne ji nahral a vratil se
;@ korektne zpet); my swap ale nemame a asi ani mit nebudeme, a tak proste jen ukoncime proces, protoze nejspis dela neplechu

undefined_instruction_handler:
	b generic_abort_handler

prefetch_abort_handler:
	b generic_abort_handler

data_abort_handler:
	b generic_abort_handler

generic_abort_handler:
	;@ Pozn.: tyto instrukce jsou stejne, jako v handleru IRQ a supervisor callu; hodily by se v pripade, ze bychom meli swap a chteli se
	;@        z abortu jeste vratit. Swap ale nemame, a tak proste jen zavolame terminate a task ukoncime
	;@srsdb #CPSR_MODE_SYS!
	;@cpsid if, #CPSR_MODE_SYS
	;@push {r0-r12}
	;@push {lr}

	mov r0, #64			;@ nejaky navratovy kod, abychom mohli treba ladit
	svc #1

	b hang

