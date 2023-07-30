;@ konstanty rezimu procesoru
.equ    CPSR_MODE_USR,          0x10	;@ uzivatelsky rezim - v tom bezi uzivatelske procesy
.equ    CPSR_MODE_SYS,          0x1F	;@ systemovy rezim - v tom bezi systemove procesy (napr. s plnymi pravy na hardware)

.global mmu_invalidate_cache
.global mmu_invalidate_tlb

.global user_process_bootstrap
;@ Process bootstrapping pro uzivatelsky proces - kernelovy "obal" procesu
;@ Vyzaduje na zasobniku pushnutou hodnotu vstupniho bodu procesu
user_process_bootstrap:
	mrs r0, cpsr
	bic r0, #0x1F				;@ odmaskujeme z CPSR rezim a nasledne ho priORujeme
	orr r0, r0, #CPSR_MODE_USR	;@ chceme prepnuti do uzivatelskeho rezimu
	b process_bootstrap_common

.global system_process_bootstrap
;@ Process bootstrapping pro systemovy proces - kernelovy "obal" procesu
;@ Vyzaduje na zasobniku pushnutou hodnotu vstupniho bodu procesu
system_process_bootstrap:
	mrs r0, cpsr
	bic r0, #0x1F				;@ odmaskujeme z CPSR rezim a nasledne ho priORujeme
	orr r0, r0, #CPSR_MODE_SYS	;@ chceme prepnuti do systemoveho rezimu
	b process_bootstrap_common

.global process_bootstrap_common
;@ Spolecna cast procesoveho bootstrapu - provede vlastni prepnuti do ciloveho rezimu
;@ Vyzaduje v r0 pozadovanou budouci hodnotu CPSR a na zasobniku pushnutou hodnotu vstupniho bodu procesu
process_bootstrap_common:
	pop {r1}
	push {r0}					;@ nejdriv CPSR
	push {r1}					;@ pak LR
	rfeia sp!					;@ naraz ze zasobniku prebere CPSR a LR --> tim docilime zmeny rezimu a skok do uzivatelskeho programu

	;@ sem by se uz provadeni programu dostat nemelo, ale ...
	;@ kdyby CRT0 nevolalo terminate syscall, tak by mohlo
	;@   - user procesy by tady vyvolaly prefetch abort vyjimku (nemaji prava vykonavat kod)
	;@   - system procesy by ale mohly vesele pokracovat dal, proto si tady umele zavolame terminate
	mov r0, #1
	svc #1
	;@ no a kdyby v kodu planovace byla chyba, tak jeste projistotu zacyklime program
bootstrap_hang:
	b bootstrap_hang

.global context_switch
;@ Prepnuti procesu ze soucasneho na jiny, ktery jiz byl planovany
;@ r0 - novy proces
;@ r1 - stary proces
context_switch:
	mrs r12, cpsr           ;@ ulozit CPU state do r12
	push {lr}               ;@ push LR
	push {r0}               ;@ push SP
	push {r0-r12}           ;@ push registru
	str sp, [r1, #4]        ;@ ulozit SP stareho procesu

	ldr r12, [r0, #12]		;@ nacist TTBR0 (tabulka stranek a priznaky) do r12
	mcr p15, 0, r12, c2, c0, 0	;@ nacist novy obsah TTBR0

	mov r1, #0					;@ data barrier, vymazat cache a TLB
	mcr p15, 0, r1, c7, c10, 4
	mcr p15, 0, r1, c8, c7, 0
	mcr p15, 0, r1, c7, c7, 0

	ldr sp, [r0, #4]        ;@ nacist SP noveho procesu

	pop {r0-r12}            ;@ obnovit registry noveho procesu
	msr cpsr_c, r12         ;@ obnovit CPU state
	pop {lr}
	pop {pc}				;@ navrat do kontextu provadeni noveho procesu - do PC se nahraje puvodni LR (navratova adresa)

.global context_switch_first
;@ Prepnuti procesu ze soucasneho na jiny, ktery jeste nebyl planovany
;@ r0 - novy proces
;@ r1 - stary proces
context_switch_first:
	mrs r12, cpsr           ;@ ulozit CPU state do r12
	push {lr}               ;@ push LR
	push {r13}              ;@ push SP
	push {r0-r12}           ;@ push registru
	str sp, [r1, #4]        ;@ ulozit SP stareho procesu

	ldr r12, [r0, #12]			;@ nacist TTBR0 (tabulka stranek a priznaky) do r12
	mcr p15, 0, r12, c2, c0, 0	;@ nacist novy obsah TTBR0
	mov r1, #0					;@ data barrier, vymazat cache a TLB
	mcr p15, 0, r1, c7, c10, 4
	mcr p15, 0, r1, c8, c7, 0
	mcr p15, 0, r1, c7, c7, 0

	ldr sp, [r0, #4]        ;@ nacteme stack pointer procesu
    ldr r3, [r0, #0]        ;@ "budouci" PC do r3 (entry point procesu)
    ldr r2, [r0, #8]        ;@ "vstupni" PC do r2 (bootstrap procesu v kernelu)

    push {r3}               ;@ budouci navratova adresa -> do zasobniku, bootstrap si ji tamodsud vyzvedne
    push {r2}               ;@ pushneme si i bootstrap adresu, abychom ji mohli obnovit do PC
    cpsie i                 ;@ povolime preruseni (v budoucich switchich uz bude flaga ulozena v cpsr/spsr)
    pop {pc}                ;@ vybereme ze zasobniku novou hodnotu PC (PC procesu)
