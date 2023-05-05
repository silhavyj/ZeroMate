.global process_bootstrap
;@ Process bootstrapping - kernelovy "obal" procesu
;@ Vyzaduje na zasobniku pushnutou hodnotu vstupniho bodu procesu
process_bootstrap:
    add lr, pc, #8      ;@ ulozime do lr hodnotu PC+8, abychom se korektne vratili na instrukci po nasledujici
    pop {pc}            ;@ vyzvedneme si ulozenou hodnotu cile
    ;@ TODO: terminate, volani syscallu exit

.global context_switch
;@ Prepnuti procesu ze soucasneho na jiny, ktery jiz byl planovany
;@ r0 - novy proces
;@ r1 - stary proces
context_switch:
	mrs r12, cpsr           ;@ ulozit CPU state do r12
	push {r14}              ;@ push LR
	push {r0}              ;@ push SP
	push {r0-r12}           ;@ push registru
	str sp, [r1, #4]        ;@ ulozit SP stareho procesu

	ldr sp, [r0, #4]        ;@ nacist SP noveho procesu
	pop {r0-r12}            ;@ obnovit registry noveho procesu
	msr cpsr_c, r12         ;@ obnovit CPU state
	pop {lr, pc}            ;@ navrat do kontextu provadeni noveho procesu

.global context_switch_first
;@ Prepnuti procesu ze soucasneho na jiny, ktery jeste nebyl planovany
;@ r0 - novy proces
;@ r1 - stary proces
context_switch_first:
	mrs r12, cpsr           ;@ ulozit CPU state do r12
	push {r14}              ;@ push LR
	push {r13}              ;@ push SP
	push {r0-r12}           ;@ push registru
	str sp, [r1, #4]        ;@ ulozit SP stareho procesu

    ldr r3, [r0, #0]        ;@ "budouci" PC do r3 (entry point procesu)
    ldr r2, [r0, #8]        ;@ "vstupni" PC do r2 (bootstrap procesu v kernelu)
    ldr sp, [r0, #4]        ;@ nacteme stack pointer procesu
    push {r3}               ;@ budouci navratova adresa -> do zasobniku, bootstrap si ji tamodsud vyzvedne
    push {r2}               ;@ pushneme si i bootstrap adresu, abychom ji mohli obnovit do PC
    cpsie i                 ;@ povolime preruseni (v budoucich switchich uz bude flaga ulozena v cpsr/spsr)
    pop {pc}                ;@ vybereme ze zasobniku novou hodnotu PC (PC procesu)
