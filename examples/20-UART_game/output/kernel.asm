
./kernel:     file format elf32-littlearm


Disassembly of section .text:

00008000 <_start>:
_start():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/start.s:14
	;@	- sem skoci bootloader, prvni na co narazi je "ldr pc, _reset_ptr" -> tedy se chova jako kdyby slo o reset a skoci na zacatek provadeni
	;@	- v cele svoji krase (vsechny "ldr" instrukce) slouzi jako predloha skutecne tabulce vektoru preruseni
	;@ na dany offset procesor skoci, kdyz je vyvolano libovolne preruseni
	;@ ARM nastavuje rovnou registr PC na tuto adresu, tzn. na teto adrese musi byt kodovana 4B instrukce skoku nekam jinam
	;@ oproti tomu napr. x86 (x86_64) obsahuje v tabulce rovnou adresu a procesor nastavuje PC (CS:IP) na adresu kterou najde v tabulce
	ldr pc, _reset_ptr						;@ 0x00 - reset - vyvolano pri resetu procesoru
    8000:	e59ff018 	ldr	pc, [pc, #24]	; 8020 <_reset_ptr>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/start.s:15
	ldr pc, _undefined_instruction_ptr		;@ 0x04 - undefined instruction - vyjimka, vyvolana pri dekodovani nezname instrukce
    8004:	e59ff018 	ldr	pc, [pc, #24]	; 8024 <_undefined_instruction_ptr>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/start.s:16
	ldr pc, _software_interrupt_ptr			;@ 0x08 - software interrupt - vyvolano, kdyz procesor provede instrukci swi
    8008:	e59ff018 	ldr	pc, [pc, #24]	; 8028 <_software_interrupt_ptr>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/start.s:17
	ldr pc, _prefetch_abort_ptr				;@ 0x0C - prefetch abort - vyvolano, kdyz se procesor snazi napr. nacist instrukci z mista, odkud nacist nejde
    800c:	e59ff018 	ldr	pc, [pc, #24]	; 802c <_prefetch_abort_ptr>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/start.s:18
	ldr pc, _data_abort_ptr					;@ 0x10 - data abort - vyvolano, kdyz se procesor snazi napr. nacist data z mista, odkud nacist nejdou
    8010:	e59ff018 	ldr	pc, [pc, #24]	; 8030 <_data_abort_ptr>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/start.s:19
	ldr pc, _unused_handler_ptr				;@ 0x14 - unused - ve specifikaci ARM neni uvedeno zadne vyuziti
    8014:	e59ff018 	ldr	pc, [pc, #24]	; 8034 <_unused_handler_ptr>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/start.s:20
	ldr pc, _irq_ptr						;@ 0x18 - IRQ - hardwarove preruseni (general purpose)
    8018:	e59ff018 	ldr	pc, [pc, #24]	; 8038 <_irq_ptr>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/start.s:21
	ldr pc, _fast_interrupt_ptr				;@ 0x1C - fast interrupt request - prioritni IRQ pro vysokorychlostni zalezitosti
    801c:	e59ff018 	ldr	pc, [pc, #24]	; 803c <_fast_interrupt_ptr>

00008020 <_reset_ptr>:
_reset_ptr():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/start.s:21
    8020:	00008040 	andeq	r8, r0, r0, asr #32

00008024 <_undefined_instruction_ptr>:
_undefined_instruction_ptr():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/start.s:21
    8024:	00009de4 	andeq	r9, r0, r4, ror #27

00008028 <_software_interrupt_ptr>:
_software_interrupt_ptr():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/start.s:21
    8028:	00009ac0 	andeq	r9, r0, r0, asr #21

0000802c <_prefetch_abort_ptr>:
_prefetch_abort_ptr():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/start.s:21
    802c:	00009de8 	andeq	r9, r0, r8, ror #27

00008030 <_data_abort_ptr>:
_data_abort_ptr():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/start.s:21
    8030:	00009dec 	andeq	r9, r0, ip, ror #27

00008034 <_unused_handler_ptr>:
_unused_handler_ptr():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/start.s:21
    8034:	00008040 	andeq	r8, r0, r0, asr #32

00008038 <_irq_ptr>:
_irq_ptr():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/start.s:21
    8038:	00009ad8 	ldrdeq	r9, [r0], -r8

0000803c <_fast_interrupt_ptr>:
_fast_interrupt_ptr():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/start.s:21
    803c:	00009b14 	andeq	r9, r0, r4, lsl fp

00008040 <_reset>:
_reset():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/start.s:50
.equ    CPSR_FIQ_INHIBIT,       0x40


;@ kernel reset vektor - tento kod se vykona pri kazdem resetu zarizeni (i prvnim spusteni)
_reset:
	mov sp, #0x8000			;@ nastavime stack pointer na spodek zasobniku
    8040:	e3a0d902 	mov	sp, #32768	; 0x8000
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/start.s:53

	;@ nacteni tabulky vektoru preruseni do pameti
	mov r0, #0x8000			;@ adresa 0x8000 (_start) do r0
    8044:	e3a00902 	mov	r0, #32768	; 0x8000
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/start.s:54
    mov r1, #0x0000			;@ adresa 0x0000 (pocatek RAM) do r1 - tam budeme vkladat tabulku vektoru preruseni
    8048:	e3a01000 	mov	r1, #0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/start.s:58

	;@ Thumb instrukce - nacteni 4B slov z pameti ulozene v r0 (0x8000) do registru r2, 3, ... 9
	;@                 - ulozeni obsahu registru r2, 3, ... 9 do pameti ulozene v registru r1 (0x0000)
    ldmia r0!,{r2, r3, r4, r5, r6, r7, r8, r9}
    804c:	e8b003fc 	ldm	r0!, {r2, r3, r4, r5, r6, r7, r8, r9}
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/start.s:59
    stmia r1!,{r2, r3, r4, r5, r6, r7, r8, r9}
    8050:	e8a103fc 	stmia	r1!, {r2, r3, r4, r5, r6, r7, r8, r9}
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/start.s:60
    ldmia r0!,{r2, r3, r4, r5, r6, r7, r8, r9}
    8054:	e8b003fc 	ldm	r0!, {r2, r3, r4, r5, r6, r7, r8, r9}
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/start.s:61
    stmia r1!,{r2, r3, r4, r5, r6, r7, r8, r9}
    8058:	e8a103fc 	stmia	r1!, {r2, r3, r4, r5, r6, r7, r8, r9}
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/start.s:64

	;@ na moment se prepneme do IRQ rezimu, nastavime mu stack pointer
	mov r0, #(CPSR_MODE_IRQ | CPSR_IRQ_INHIBIT | CPSR_FIQ_INHIBIT)
    805c:	e3a000d2 	mov	r0, #210	; 0xd2
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/start.s:65
    msr cpsr_c, r0
    8060:	e121f000 	msr	CPSR_c, r0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/start.s:66
    mov sp, #0x7000
    8064:	e3a0da07 	mov	sp, #28672	; 0x7000
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/start.s:69

	;@ na moment se prepneme do FIQ rezimu, nastavime mu stack pointer
	mov r0, #(CPSR_MODE_FIQ | CPSR_IRQ_INHIBIT | CPSR_FIQ_INHIBIT)
    8068:	e3a000d1 	mov	r0, #209	; 0xd1
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/start.s:70
    msr cpsr_c, r0
    806c:	e121f000 	msr	CPSR_c, r0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/start.s:71
    mov sp, #0x6000
    8070:	e3a0da06 	mov	sp, #24576	; 0x6000
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/start.s:74

	;@ a vracime se zpet do supervisor modu, SP si nastavime zpet na nasi hodnotu
    mov r0, #(CPSR_MODE_SVR | CPSR_IRQ_INHIBIT | CPSR_FIQ_INHIBIT)
    8074:	e3a000d3 	mov	r0, #211	; 0xd3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/start.s:75
    msr cpsr_c, r0
    8078:	e121f000 	msr	CPSR_c, r0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/start.s:76
    mov sp, #0x8000
    807c:	e3a0d902 	mov	sp, #32768	; 0x8000
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/start.s:78

	bl _c_startup			;@ C startup kod (inicializace prostredi)
    8080:	eb00075a 	bl	9df0 <_c_startup>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/start.s:79
	bl _cpp_startup			;@ C++ startup kod (volani globalnich konstruktoru, ...)
    8084:	eb000773 	bl	9e58 <_cpp_startup>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/start.s:80
	bl _kernel_main			;@ skocime do hlavniho kodu jadra (v C)
    8088:	eb000732 	bl	9d58 <_kernel_main>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/start.s:81
	bl _cpp_shutdown		;@ C++ shutdown kod (volani globalnich destruktoru, ...)
    808c:	eb000787 	bl	9eb0 <_cpp_shutdown>

00008090 <hang>:
hang():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/start.s:83
hang:
	b hang
    8090:	eafffffe 	b	8090 <hang>

00008094 <__cxa_guard_acquire>:
__cxa_guard_acquire():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/cxx.cpp:11
    extern "C" int __cxa_guard_acquire(__guard*);
    extern "C" void __cxa_guard_release(__guard*);
    extern "C" void __cxa_guard_abort(__guard*);

    extern "C" int __cxa_guard_acquire(__guard* g)
    {
    8094:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8098:	e28db000 	add	fp, sp, #0
    809c:	e24dd00c 	sub	sp, sp, #12
    80a0:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/cxx.cpp:12
        return !*(char*)(g);
    80a4:	e51b3008 	ldr	r3, [fp, #-8]
    80a8:	e5d33000 	ldrb	r3, [r3]
    80ac:	e3530000 	cmp	r3, #0
    80b0:	03a03001 	moveq	r3, #1
    80b4:	13a03000 	movne	r3, #0
    80b8:	e6ef3073 	uxtb	r3, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/cxx.cpp:13
    }
    80bc:	e1a00003 	mov	r0, r3
    80c0:	e28bd000 	add	sp, fp, #0
    80c4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    80c8:	e12fff1e 	bx	lr

000080cc <__cxa_guard_release>:
__cxa_guard_release():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/cxx.cpp:16

    extern "C" void __cxa_guard_release(__guard* g)
    {
    80cc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    80d0:	e28db000 	add	fp, sp, #0
    80d4:	e24dd00c 	sub	sp, sp, #12
    80d8:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/cxx.cpp:17
        *(char*)g = 1;
    80dc:	e51b3008 	ldr	r3, [fp, #-8]
    80e0:	e3a02001 	mov	r2, #1
    80e4:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/cxx.cpp:18
    }
    80e8:	e320f000 	nop	{0}
    80ec:	e28bd000 	add	sp, fp, #0
    80f0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    80f4:	e12fff1e 	bx	lr

000080f8 <__cxa_guard_abort>:
__cxa_guard_abort():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/cxx.cpp:21

    extern "C" void __cxa_guard_abort(__guard*)
    {
    80f8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    80fc:	e28db000 	add	fp, sp, #0
    8100:	e24dd00c 	sub	sp, sp, #12
    8104:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/cxx.cpp:22
    }
    8108:	e320f000 	nop	{0}
    810c:	e28bd000 	add	sp, fp, #0
    8110:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8114:	e12fff1e 	bx	lr

00008118 <__dso_handle>:
__dso_handle():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/cxx.cpp:26
}

extern "C" void __dso_handle()
{
    8118:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    811c:	e28db000 	add	fp, sp, #0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/cxx.cpp:28
    // ignore dtors for now
}
    8120:	e320f000 	nop	{0}
    8124:	e28bd000 	add	sp, fp, #0
    8128:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    812c:	e12fff1e 	bx	lr

00008130 <__cxa_atexit>:
__cxa_atexit():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/cxx.cpp:31

extern "C" void __cxa_atexit()
{
    8130:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8134:	e28db000 	add	fp, sp, #0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/cxx.cpp:33
    // ignore dtors for now
}
    8138:	e320f000 	nop	{0}
    813c:	e28bd000 	add	sp, fp, #0
    8140:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8144:	e12fff1e 	bx	lr

00008148 <__cxa_pure_virtual>:
__cxa_pure_virtual():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/cxx.cpp:36

extern "C" void __cxa_pure_virtual()
{
    8148:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    814c:	e28db000 	add	fp, sp, #0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/cxx.cpp:38
    // pure virtual method called
}
    8150:	e320f000 	nop	{0}
    8154:	e28bd000 	add	sp, fp, #0
    8158:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    815c:	e12fff1e 	bx	lr

00008160 <__aeabi_unwind_cpp_pr1>:
__aeabi_unwind_cpp_pr1():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/cxx.cpp:41

extern "C" void __aeabi_unwind_cpp_pr1()
{
    8160:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8164:	e28db000 	add	fp, sp, #0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/cxx.cpp:42 (discriminator 1)
    while (true)
    8168:	eafffffe 	b	8168 <__aeabi_unwind_cpp_pr1+0x8>

0000816c <_ZN4CAUXC1Ej>:
_ZN4CAUXC2Ej():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/bcm_aux.cpp:5
#include <drivers/bcm_aux.h>

CAUX sAUX(hal::AUX_Base);

CAUX::CAUX(unsigned int aux_base)
    816c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8170:	e28db000 	add	fp, sp, #0
    8174:	e24dd00c 	sub	sp, sp, #12
    8178:	e50b0008 	str	r0, [fp, #-8]
    817c:	e50b100c 	str	r1, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/bcm_aux.cpp:6
: mAUX_Reg(reinterpret_cast<unsigned int*>(aux_base))
    8180:	e51b200c 	ldr	r2, [fp, #-12]
    8184:	e51b3008 	ldr	r3, [fp, #-8]
    8188:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/bcm_aux.cpp:9
{
    //
}
    818c:	e51b3008 	ldr	r3, [fp, #-8]
    8190:	e1a00003 	mov	r0, r3
    8194:	e28bd000 	add	sp, fp, #0
    8198:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    819c:	e12fff1e 	bx	lr

000081a0 <_ZN4CAUX6EnableEN3hal15AUX_PeripheralsE>:
_ZN4CAUX6EnableEN3hal15AUX_PeripheralsE():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/bcm_aux.cpp:12

void CAUX::Enable(hal::AUX_Peripherals aux_peripheral)
{
    81a0:	e92d4800 	push	{fp, lr}
    81a4:	e28db004 	add	fp, sp, #4
    81a8:	e24dd008 	sub	sp, sp, #8
    81ac:	e50b0008 	str	r0, [fp, #-8]
    81b0:	e50b100c 	str	r1, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/bcm_aux.cpp:14
    Set_Register(hal::AUX_Reg::ENABLES,
                 Get_Register(hal::AUX_Reg::ENABLES) | (1 << static_cast<uint32_t>(aux_peripheral)));
    81b4:	e3a01001 	mov	r1, #1
    81b8:	e51b0008 	ldr	r0, [fp, #-8]
    81bc:	eb000031 	bl	8288 <_ZN4CAUX12Get_RegisterEN3hal7AUX_RegE>
    81c0:	e1a02000 	mov	r2, r0
    81c4:	e51b300c 	ldr	r3, [fp, #-12]
    81c8:	e3a01001 	mov	r1, #1
    81cc:	e1a03311 	lsl	r3, r1, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/bcm_aux.cpp:13
    Set_Register(hal::AUX_Reg::ENABLES,
    81d0:	e1823003 	orr	r3, r2, r3
    81d4:	e1a02003 	mov	r2, r3
    81d8:	e3a01001 	mov	r1, #1
    81dc:	e51b0008 	ldr	r0, [fp, #-8]
    81e0:	eb000017 	bl	8244 <_ZN4CAUX12Set_RegisterEN3hal7AUX_RegEj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/bcm_aux.cpp:15
}
    81e4:	e320f000 	nop	{0}
    81e8:	e24bd004 	sub	sp, fp, #4
    81ec:	e8bd8800 	pop	{fp, pc}

000081f0 <_ZN4CAUX7DisableEN3hal15AUX_PeripheralsE>:
_ZN4CAUX7DisableEN3hal15AUX_PeripheralsE():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/bcm_aux.cpp:18

void CAUX::Disable(hal::AUX_Peripherals aux_peripheral)
{
    81f0:	e92d4800 	push	{fp, lr}
    81f4:	e28db004 	add	fp, sp, #4
    81f8:	e24dd008 	sub	sp, sp, #8
    81fc:	e50b0008 	str	r0, [fp, #-8]
    8200:	e50b100c 	str	r1, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/bcm_aux.cpp:20
    Set_Register(hal::AUX_Reg::ENABLES,
                 Get_Register(hal::AUX_Reg::ENABLES) & ~(1 << static_cast<uint32_t>(aux_peripheral)));
    8204:	e3a01001 	mov	r1, #1
    8208:	e51b0008 	ldr	r0, [fp, #-8]
    820c:	eb00001d 	bl	8288 <_ZN4CAUX12Get_RegisterEN3hal7AUX_RegE>
    8210:	e1a02000 	mov	r2, r0
    8214:	e51b300c 	ldr	r3, [fp, #-12]
    8218:	e3a01001 	mov	r1, #1
    821c:	e1a03311 	lsl	r3, r1, r3
    8220:	e1e03003 	mvn	r3, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/bcm_aux.cpp:19
    Set_Register(hal::AUX_Reg::ENABLES,
    8224:	e0033002 	and	r3, r3, r2
    8228:	e1a02003 	mov	r2, r3
    822c:	e3a01001 	mov	r1, #1
    8230:	e51b0008 	ldr	r0, [fp, #-8]
    8234:	eb000002 	bl	8244 <_ZN4CAUX12Set_RegisterEN3hal7AUX_RegEj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/bcm_aux.cpp:21
}
    8238:	e320f000 	nop	{0}
    823c:	e24bd004 	sub	sp, fp, #4
    8240:	e8bd8800 	pop	{fp, pc}

00008244 <_ZN4CAUX12Set_RegisterEN3hal7AUX_RegEj>:
_ZN4CAUX12Set_RegisterEN3hal7AUX_RegEj():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/bcm_aux.cpp:24

void CAUX::Set_Register(hal::AUX_Reg reg_idx, uint32_t value)
{
    8244:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8248:	e28db000 	add	fp, sp, #0
    824c:	e24dd014 	sub	sp, sp, #20
    8250:	e50b0008 	str	r0, [fp, #-8]
    8254:	e50b100c 	str	r1, [fp, #-12]
    8258:	e50b2010 	str	r2, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/bcm_aux.cpp:25
    mAUX_Reg[static_cast<unsigned int>(reg_idx)] = value;
    825c:	e51b3008 	ldr	r3, [fp, #-8]
    8260:	e5932000 	ldr	r2, [r3]
    8264:	e51b300c 	ldr	r3, [fp, #-12]
    8268:	e1a03103 	lsl	r3, r3, #2
    826c:	e0823003 	add	r3, r2, r3
    8270:	e51b2010 	ldr	r2, [fp, #-16]
    8274:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/bcm_aux.cpp:26
}
    8278:	e320f000 	nop	{0}
    827c:	e28bd000 	add	sp, fp, #0
    8280:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8284:	e12fff1e 	bx	lr

00008288 <_ZN4CAUX12Get_RegisterEN3hal7AUX_RegE>:
_ZN4CAUX12Get_RegisterEN3hal7AUX_RegE():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/bcm_aux.cpp:29

uint32_t CAUX::Get_Register(hal::AUX_Reg reg_idx)
{
    8288:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    828c:	e28db000 	add	fp, sp, #0
    8290:	e24dd00c 	sub	sp, sp, #12
    8294:	e50b0008 	str	r0, [fp, #-8]
    8298:	e50b100c 	str	r1, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/bcm_aux.cpp:30
    return mAUX_Reg[static_cast<unsigned int>(reg_idx)];
    829c:	e51b3008 	ldr	r3, [fp, #-8]
    82a0:	e5932000 	ldr	r2, [r3]
    82a4:	e51b300c 	ldr	r3, [fp, #-12]
    82a8:	e1a03103 	lsl	r3, r3, #2
    82ac:	e0823003 	add	r3, r2, r3
    82b0:	e5933000 	ldr	r3, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/bcm_aux.cpp:31
}
    82b4:	e1a00003 	mov	r0, r3
    82b8:	e28bd000 	add	sp, fp, #0
    82bc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    82c0:	e12fff1e 	bx	lr

000082c4 <_Z41__static_initialization_and_destruction_0ii>:
_Z41__static_initialization_and_destruction_0ii():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/bcm_aux.cpp:31
    82c4:	e92d4800 	push	{fp, lr}
    82c8:	e28db004 	add	fp, sp, #4
    82cc:	e24dd008 	sub	sp, sp, #8
    82d0:	e50b0008 	str	r0, [fp, #-8]
    82d4:	e50b100c 	str	r1, [fp, #-12]
    82d8:	e51b3008 	ldr	r3, [fp, #-8]
    82dc:	e3530001 	cmp	r3, #1
    82e0:	1a000006 	bne	8300 <_Z41__static_initialization_and_destruction_0ii+0x3c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/bcm_aux.cpp:31 (discriminator 1)
    82e4:	e51b300c 	ldr	r3, [fp, #-12]
    82e8:	e59f201c 	ldr	r2, [pc, #28]	; 830c <_Z41__static_initialization_and_destruction_0ii+0x48>
    82ec:	e1530002 	cmp	r3, r2
    82f0:	1a000002 	bne	8300 <_Z41__static_initialization_and_destruction_0ii+0x3c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/bcm_aux.cpp:3
CAUX sAUX(hal::AUX_Base);
    82f4:	e59f1014 	ldr	r1, [pc, #20]	; 8310 <_Z41__static_initialization_and_destruction_0ii+0x4c>
    82f8:	e59f0014 	ldr	r0, [pc, #20]	; 8314 <_Z41__static_initialization_and_destruction_0ii+0x50>
    82fc:	ebffff9a 	bl	816c <_ZN4CAUXC1Ej>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/bcm_aux.cpp:31
}
    8300:	e320f000 	nop	{0}
    8304:	e24bd004 	sub	sp, fp, #4
    8308:	e8bd8800 	pop	{fp, pc}
    830c:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>
    8310:	20215000 	eorcs	r5, r1, r0
    8314:	0000aa18 	andeq	sl, r0, r8, lsl sl

00008318 <_GLOBAL__sub_I_sAUX>:
_GLOBAL__sub_I_sAUX():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/bcm_aux.cpp:31
    8318:	e92d4800 	push	{fp, lr}
    831c:	e28db004 	add	fp, sp, #4
    8320:	e59f1008 	ldr	r1, [pc, #8]	; 8330 <_GLOBAL__sub_I_sAUX+0x18>
    8324:	e3a00001 	mov	r0, #1
    8328:	ebffffe5 	bl	82c4 <_Z41__static_initialization_and_destruction_0ii>
    832c:	e8bd8800 	pop	{fp, pc}
    8330:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>

00008334 <_ZN13CGPIO_HandlerC1Ej>:
_ZN13CGPIO_HandlerC2Ej():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:6
#include <hal/peripherals.h>
#include <drivers/gpio.h>

CGPIO_Handler sGPIO(hal::GPIO_Base);

CGPIO_Handler::CGPIO_Handler(unsigned int gpio_base_addr)
    8334:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8338:	e28db000 	add	fp, sp, #0
    833c:	e24dd00c 	sub	sp, sp, #12
    8340:	e50b0008 	str	r0, [fp, #-8]
    8344:	e50b100c 	str	r1, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:7
: mGPIO(reinterpret_cast<unsigned int*>(gpio_base_addr))
    8348:	e51b200c 	ldr	r2, [fp, #-12]
    834c:	e51b3008 	ldr	r3, [fp, #-8]
    8350:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:10
{
    //
}
    8354:	e51b3008 	ldr	r3, [fp, #-8]
    8358:	e1a00003 	mov	r0, r3
    835c:	e28bd000 	add	sp, fp, #0
    8360:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8364:	e12fff1e 	bx	lr

00008368 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_>:
_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:13

bool CGPIO_Handler::Get_GPFSEL_Location(uint32_t pin, uint32_t& reg, uint32_t& bit_idx) const
{
    8368:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    836c:	e28db000 	add	fp, sp, #0
    8370:	e24dd014 	sub	sp, sp, #20
    8374:	e50b0008 	str	r0, [fp, #-8]
    8378:	e50b100c 	str	r1, [fp, #-12]
    837c:	e50b2010 	str	r2, [fp, #-16]
    8380:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:14
    if (pin > hal::GPIO_Pin_Count)
    8384:	e51b300c 	ldr	r3, [fp, #-12]
    8388:	e3530036 	cmp	r3, #54	; 0x36
    838c:	9a000001 	bls	8398 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0x30>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:15
        return false;
    8390:	e3a03000 	mov	r3, #0
    8394:	ea000033 	b	8468 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0x100>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:17

    switch (pin / 10)
    8398:	e51b300c 	ldr	r3, [fp, #-12]
    839c:	e59f20d4 	ldr	r2, [pc, #212]	; 8478 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0x110>
    83a0:	e0832392 	umull	r2, r3, r2, r3
    83a4:	e1a031a3 	lsr	r3, r3, #3
    83a8:	e3530005 	cmp	r3, #5
    83ac:	979ff103 	ldrls	pc, [pc, r3, lsl #2]
    83b0:	ea00001d 	b	842c <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0xc4>
    83b4:	000083cc 	andeq	r8, r0, ip, asr #7
    83b8:	000083dc 	ldrdeq	r8, [r0], -ip
    83bc:	000083ec 	andeq	r8, r0, ip, ror #7
    83c0:	000083fc 	strdeq	r8, [r0], -ip
    83c4:	0000840c 	andeq	r8, r0, ip, lsl #8
    83c8:	0000841c 	andeq	r8, r0, ip, lsl r4
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:20
    {
        case 0:
            reg = static_cast<uint32_t>(hal::GPIO_Reg::GPFSEL0);
    83cc:	e51b3010 	ldr	r3, [fp, #-16]
    83d0:	e3a02000 	mov	r2, #0
    83d4:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:21
            break;
    83d8:	ea000013 	b	842c <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0xc4>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:23
        case 1:
            reg = static_cast<uint32_t>(hal::GPIO_Reg::GPFSEL1);
    83dc:	e51b3010 	ldr	r3, [fp, #-16]
    83e0:	e3a02001 	mov	r2, #1
    83e4:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:24
            break;
    83e8:	ea00000f 	b	842c <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0xc4>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:26
        case 2:
            reg = static_cast<uint32_t>(hal::GPIO_Reg::GPFSEL2);
    83ec:	e51b3010 	ldr	r3, [fp, #-16]
    83f0:	e3a02002 	mov	r2, #2
    83f4:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:27
            break;
    83f8:	ea00000b 	b	842c <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0xc4>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:29
        case 3:
            reg = static_cast<uint32_t>(hal::GPIO_Reg::GPFSEL3);
    83fc:	e51b3010 	ldr	r3, [fp, #-16]
    8400:	e3a02003 	mov	r2, #3
    8404:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:30
            break;
    8408:	ea000007 	b	842c <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0xc4>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:32
        case 4:
            reg = static_cast<uint32_t>(hal::GPIO_Reg::GPFSEL4);
    840c:	e51b3010 	ldr	r3, [fp, #-16]
    8410:	e3a02004 	mov	r2, #4
    8414:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:33
            break;
    8418:	ea000003 	b	842c <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0xc4>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:35
        case 5:
            reg = static_cast<uint32_t>(hal::GPIO_Reg::GPFSEL5);
    841c:	e51b3010 	ldr	r3, [fp, #-16]
    8420:	e3a02005 	mov	r2, #5
    8424:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:36
            break;
    8428:	e320f000 	nop	{0}
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:39
    }

    bit_idx = (pin % 10) * 3;
    842c:	e51b100c 	ldr	r1, [fp, #-12]
    8430:	e59f3040 	ldr	r3, [pc, #64]	; 8478 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0x110>
    8434:	e0832193 	umull	r2, r3, r3, r1
    8438:	e1a021a3 	lsr	r2, r3, #3
    843c:	e1a03002 	mov	r3, r2
    8440:	e1a03103 	lsl	r3, r3, #2
    8444:	e0833002 	add	r3, r3, r2
    8448:	e1a03083 	lsl	r3, r3, #1
    844c:	e0412003 	sub	r2, r1, r3
    8450:	e1a03002 	mov	r3, r2
    8454:	e1a03083 	lsl	r3, r3, #1
    8458:	e0832002 	add	r2, r3, r2
    845c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8460:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:41

    return true;
    8464:	e3a03001 	mov	r3, #1
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:42
}
    8468:	e1a00003 	mov	r0, r3
    846c:	e28bd000 	add	sp, fp, #0
    8470:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8474:	e12fff1e 	bx	lr
    8478:	cccccccd 	stclgt	12, cr12, [ip], {205}	; 0xcd

0000847c <_ZNK13CGPIO_Handler18Get_GPCLR_LocationEjRjS0_>:
_ZNK13CGPIO_Handler18Get_GPCLR_LocationEjRjS0_():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:45

bool CGPIO_Handler::Get_GPCLR_Location(uint32_t pin, uint32_t& reg, uint32_t& bit_idx) const
{
    847c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8480:	e28db000 	add	fp, sp, #0
    8484:	e24dd014 	sub	sp, sp, #20
    8488:	e50b0008 	str	r0, [fp, #-8]
    848c:	e50b100c 	str	r1, [fp, #-12]
    8490:	e50b2010 	str	r2, [fp, #-16]
    8494:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:46
    if (pin > hal::GPIO_Pin_Count)
    8498:	e51b300c 	ldr	r3, [fp, #-12]
    849c:	e3530036 	cmp	r3, #54	; 0x36
    84a0:	9a000001 	bls	84ac <_ZNK13CGPIO_Handler18Get_GPCLR_LocationEjRjS0_+0x30>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:47
        return false;
    84a4:	e3a03000 	mov	r3, #0
    84a8:	ea00000c 	b	84e0 <_ZNK13CGPIO_Handler18Get_GPCLR_LocationEjRjS0_+0x64>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:49

    reg = static_cast<uint32_t>((pin < 32) ? hal::GPIO_Reg::GPCLR0 : hal::GPIO_Reg::GPCLR1);
    84ac:	e51b300c 	ldr	r3, [fp, #-12]
    84b0:	e353001f 	cmp	r3, #31
    84b4:	8a000001 	bhi	84c0 <_ZNK13CGPIO_Handler18Get_GPCLR_LocationEjRjS0_+0x44>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:49 (discriminator 1)
    84b8:	e3a0200a 	mov	r2, #10
    84bc:	ea000000 	b	84c4 <_ZNK13CGPIO_Handler18Get_GPCLR_LocationEjRjS0_+0x48>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:49 (discriminator 2)
    84c0:	e3a0200b 	mov	r2, #11
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:49 (discriminator 4)
    84c4:	e51b3010 	ldr	r3, [fp, #-16]
    84c8:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:50 (discriminator 4)
    bit_idx = pin % 32;
    84cc:	e51b300c 	ldr	r3, [fp, #-12]
    84d0:	e203201f 	and	r2, r3, #31
    84d4:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    84d8:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:52 (discriminator 4)

    return true;
    84dc:	e3a03001 	mov	r3, #1
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:53
}
    84e0:	e1a00003 	mov	r0, r3
    84e4:	e28bd000 	add	sp, fp, #0
    84e8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    84ec:	e12fff1e 	bx	lr

000084f0 <_ZNK13CGPIO_Handler18Get_GPSET_LocationEjRjS0_>:
_ZNK13CGPIO_Handler18Get_GPSET_LocationEjRjS0_():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:56

bool CGPIO_Handler::Get_GPSET_Location(uint32_t pin, uint32_t& reg, uint32_t& bit_idx) const
{
    84f0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    84f4:	e28db000 	add	fp, sp, #0
    84f8:	e24dd014 	sub	sp, sp, #20
    84fc:	e50b0008 	str	r0, [fp, #-8]
    8500:	e50b100c 	str	r1, [fp, #-12]
    8504:	e50b2010 	str	r2, [fp, #-16]
    8508:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:57
    if (pin > hal::GPIO_Pin_Count)
    850c:	e51b300c 	ldr	r3, [fp, #-12]
    8510:	e3530036 	cmp	r3, #54	; 0x36
    8514:	9a000001 	bls	8520 <_ZNK13CGPIO_Handler18Get_GPSET_LocationEjRjS0_+0x30>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:58
        return false;
    8518:	e3a03000 	mov	r3, #0
    851c:	ea00000c 	b	8554 <_ZNK13CGPIO_Handler18Get_GPSET_LocationEjRjS0_+0x64>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:60

    reg = static_cast<uint32_t>((pin < 32) ? hal::GPIO_Reg::GPSET0 : hal::GPIO_Reg::GPSET1);
    8520:	e51b300c 	ldr	r3, [fp, #-12]
    8524:	e353001f 	cmp	r3, #31
    8528:	8a000001 	bhi	8534 <_ZNK13CGPIO_Handler18Get_GPSET_LocationEjRjS0_+0x44>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:60 (discriminator 1)
    852c:	e3a02007 	mov	r2, #7
    8530:	ea000000 	b	8538 <_ZNK13CGPIO_Handler18Get_GPSET_LocationEjRjS0_+0x48>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:60 (discriminator 2)
    8534:	e3a02008 	mov	r2, #8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:60 (discriminator 4)
    8538:	e51b3010 	ldr	r3, [fp, #-16]
    853c:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:61 (discriminator 4)
    bit_idx = pin % 32;
    8540:	e51b300c 	ldr	r3, [fp, #-12]
    8544:	e203201f 	and	r2, r3, #31
    8548:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    854c:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:63 (discriminator 4)

    return true;
    8550:	e3a03001 	mov	r3, #1
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:64
}
    8554:	e1a00003 	mov	r0, r3
    8558:	e28bd000 	add	sp, fp, #0
    855c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8560:	e12fff1e 	bx	lr

00008564 <_ZNK13CGPIO_Handler18Get_GPLEV_LocationEjRjS0_>:
_ZNK13CGPIO_Handler18Get_GPLEV_LocationEjRjS0_():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:67

bool CGPIO_Handler::Get_GPLEV_Location(uint32_t pin, uint32_t& reg, uint32_t& bit_idx) const
{
    8564:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8568:	e28db000 	add	fp, sp, #0
    856c:	e24dd014 	sub	sp, sp, #20
    8570:	e50b0008 	str	r0, [fp, #-8]
    8574:	e50b100c 	str	r1, [fp, #-12]
    8578:	e50b2010 	str	r2, [fp, #-16]
    857c:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:68
    if (pin > hal::GPIO_Pin_Count)
    8580:	e51b300c 	ldr	r3, [fp, #-12]
    8584:	e3530036 	cmp	r3, #54	; 0x36
    8588:	9a000001 	bls	8594 <_ZNK13CGPIO_Handler18Get_GPLEV_LocationEjRjS0_+0x30>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:69
        return false;
    858c:	e3a03000 	mov	r3, #0
    8590:	ea00000c 	b	85c8 <_ZNK13CGPIO_Handler18Get_GPLEV_LocationEjRjS0_+0x64>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:71

    reg = static_cast<uint32_t>((pin < 32) ? hal::GPIO_Reg::GPLEV0 : hal::GPIO_Reg::GPLEV1);
    8594:	e51b300c 	ldr	r3, [fp, #-12]
    8598:	e353001f 	cmp	r3, #31
    859c:	8a000001 	bhi	85a8 <_ZNK13CGPIO_Handler18Get_GPLEV_LocationEjRjS0_+0x44>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:71 (discriminator 1)
    85a0:	e3a0200d 	mov	r2, #13
    85a4:	ea000000 	b	85ac <_ZNK13CGPIO_Handler18Get_GPLEV_LocationEjRjS0_+0x48>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:71 (discriminator 2)
    85a8:	e3a0200e 	mov	r2, #14
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:71 (discriminator 4)
    85ac:	e51b3010 	ldr	r3, [fp, #-16]
    85b0:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:72 (discriminator 4)
    bit_idx = pin % 32;
    85b4:	e51b300c 	ldr	r3, [fp, #-12]
    85b8:	e203201f 	and	r2, r3, #31
    85bc:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    85c0:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:74 (discriminator 4)

    return true;
    85c4:	e3a03001 	mov	r3, #1
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:75
}
    85c8:	e1a00003 	mov	r0, r3
    85cc:	e28bd000 	add	sp, fp, #0
    85d0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    85d4:	e12fff1e 	bx	lr

000085d8 <_ZN13CGPIO_Handler17Set_GPIO_FunctionEj14NGPIO_Function>:
_ZN13CGPIO_Handler17Set_GPIO_FunctionEj14NGPIO_Function():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:78

void CGPIO_Handler::Set_GPIO_Function(uint32_t pin, NGPIO_Function func)
{
    85d8:	e92d4800 	push	{fp, lr}
    85dc:	e28db004 	add	fp, sp, #4
    85e0:	e24dd018 	sub	sp, sp, #24
    85e4:	e50b0010 	str	r0, [fp, #-16]
    85e8:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    85ec:	e1a03002 	mov	r3, r2
    85f0:	e54b3015 	strb	r3, [fp, #-21]	; 0xffffffeb
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:80
    uint32_t reg, bit;
    if (!Get_GPFSEL_Location(pin, reg, bit))
    85f4:	e24b300c 	sub	r3, fp, #12
    85f8:	e24b2008 	sub	r2, fp, #8
    85fc:	e51b1014 	ldr	r1, [fp, #-20]	; 0xffffffec
    8600:	e51b0010 	ldr	r0, [fp, #-16]
    8604:	ebffff57 	bl	8368 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_>
    8608:	e1a03000 	mov	r3, r0
    860c:	e2233001 	eor	r3, r3, #1
    8610:	e6ef3073 	uxtb	r3, r3
    8614:	e3530000 	cmp	r3, #0
    8618:	1a000015 	bne	8674 <_ZN13CGPIO_Handler17Set_GPIO_FunctionEj14NGPIO_Function+0x9c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:83
        return;

    mGPIO[reg] = (mGPIO[reg] & (~static_cast<unsigned int>(7 << bit))) | (static_cast<unsigned int>(func) << bit);
    861c:	e51b3010 	ldr	r3, [fp, #-16]
    8620:	e5932000 	ldr	r2, [r3]
    8624:	e51b3008 	ldr	r3, [fp, #-8]
    8628:	e1a03103 	lsl	r3, r3, #2
    862c:	e0823003 	add	r3, r2, r3
    8630:	e5932000 	ldr	r2, [r3]
    8634:	e51b300c 	ldr	r3, [fp, #-12]
    8638:	e3a01007 	mov	r1, #7
    863c:	e1a03311 	lsl	r3, r1, r3
    8640:	e1e03003 	mvn	r3, r3
    8644:	e0021003 	and	r1, r2, r3
    8648:	e55b2015 	ldrb	r2, [fp, #-21]	; 0xffffffeb
    864c:	e51b300c 	ldr	r3, [fp, #-12]
    8650:	e1a02312 	lsl	r2, r2, r3
    8654:	e51b3010 	ldr	r3, [fp, #-16]
    8658:	e5930000 	ldr	r0, [r3]
    865c:	e51b3008 	ldr	r3, [fp, #-8]
    8660:	e1a03103 	lsl	r3, r3, #2
    8664:	e0803003 	add	r3, r0, r3
    8668:	e1812002 	orr	r2, r1, r2
    866c:	e5832000 	str	r2, [r3]
    8670:	ea000000 	b	8678 <_ZN13CGPIO_Handler17Set_GPIO_FunctionEj14NGPIO_Function+0xa0>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:81
        return;
    8674:	e320f000 	nop	{0}
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:84
}
    8678:	e24bd004 	sub	sp, fp, #4
    867c:	e8bd8800 	pop	{fp, pc}

00008680 <_ZNK13CGPIO_Handler17Get_GPIO_FunctionEj>:
_ZNK13CGPIO_Handler17Get_GPIO_FunctionEj():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:87

NGPIO_Function CGPIO_Handler::Get_GPIO_Function(uint32_t pin) const
{
    8680:	e92d4800 	push	{fp, lr}
    8684:	e28db004 	add	fp, sp, #4
    8688:	e24dd010 	sub	sp, sp, #16
    868c:	e50b0010 	str	r0, [fp, #-16]
    8690:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:89
    uint32_t reg, bit;
    if (!Get_GPFSEL_Location(pin, reg, bit))
    8694:	e24b300c 	sub	r3, fp, #12
    8698:	e24b2008 	sub	r2, fp, #8
    869c:	e51b1014 	ldr	r1, [fp, #-20]	; 0xffffffec
    86a0:	e51b0010 	ldr	r0, [fp, #-16]
    86a4:	ebffff2f 	bl	8368 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_>
    86a8:	e1a03000 	mov	r3, r0
    86ac:	e2233001 	eor	r3, r3, #1
    86b0:	e6ef3073 	uxtb	r3, r3
    86b4:	e3530000 	cmp	r3, #0
    86b8:	0a000001 	beq	86c4 <_ZNK13CGPIO_Handler17Get_GPIO_FunctionEj+0x44>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:90
        return NGPIO_Function::Unspecified;
    86bc:	e3a03008 	mov	r3, #8
    86c0:	ea00000a 	b	86f0 <_ZNK13CGPIO_Handler17Get_GPIO_FunctionEj+0x70>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:92

    return static_cast<NGPIO_Function>((mGPIO[reg] >> bit) & 7);
    86c4:	e51b3010 	ldr	r3, [fp, #-16]
    86c8:	e5932000 	ldr	r2, [r3]
    86cc:	e51b3008 	ldr	r3, [fp, #-8]
    86d0:	e1a03103 	lsl	r3, r3, #2
    86d4:	e0823003 	add	r3, r2, r3
    86d8:	e5932000 	ldr	r2, [r3]
    86dc:	e51b300c 	ldr	r3, [fp, #-12]
    86e0:	e1a03332 	lsr	r3, r2, r3
    86e4:	e6ef3073 	uxtb	r3, r3
    86e8:	e2033007 	and	r3, r3, #7
    86ec:	e6ef3073 	uxtb	r3, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:93 (discriminator 1)
}
    86f0:	e1a00003 	mov	r0, r3
    86f4:	e24bd004 	sub	sp, fp, #4
    86f8:	e8bd8800 	pop	{fp, pc}

000086fc <_ZN13CGPIO_Handler19Enable_Event_DetectEj20NGPIO_Interrupt_Type>:
_ZN13CGPIO_Handler19Enable_Event_DetectEj20NGPIO_Interrupt_Type():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:96

void CGPIO_Handler::Enable_Event_Detect(uint32_t pin, NGPIO_Interrupt_Type type)
{
    86fc:	e92d4800 	push	{fp, lr}
    8700:	e28db004 	add	fp, sp, #4
    8704:	e24dd020 	sub	sp, sp, #32
    8708:	e50b0010 	str	r0, [fp, #-16]
    870c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8710:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:98
    uint32_t reg, bit;
    if (!Get_GP_IRQ_Detect_Location(pin, type, reg, bit))
    8714:	e24b2008 	sub	r2, fp, #8
    8718:	e24b300c 	sub	r3, fp, #12
    871c:	e58d3000 	str	r3, [sp]
    8720:	e1a03002 	mov	r3, r2
    8724:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    8728:	e51b1014 	ldr	r1, [fp, #-20]	; 0xffffffec
    872c:	e51b0010 	ldr	r0, [fp, #-16]
    8730:	eb000012 	bl	8780 <_ZNK13CGPIO_Handler26Get_GP_IRQ_Detect_LocationEj20NGPIO_Interrupt_TypeRjS1_>
    8734:	e1a03000 	mov	r3, r0
    8738:	e2233001 	eor	r3, r3, #1
    873c:	e6ef3073 	uxtb	r3, r3
    8740:	e3530000 	cmp	r3, #0
    8744:	1a00000a 	bne	8774 <_ZN13CGPIO_Handler19Enable_Event_DetectEj20NGPIO_Interrupt_Type+0x78>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:101
        return;

    mGPIO[reg] = (1 << bit);
    8748:	e51b300c 	ldr	r3, [fp, #-12]
    874c:	e3a02001 	mov	r2, #1
    8750:	e1a01312 	lsl	r1, r2, r3
    8754:	e51b3010 	ldr	r3, [fp, #-16]
    8758:	e5932000 	ldr	r2, [r3]
    875c:	e51b3008 	ldr	r3, [fp, #-8]
    8760:	e1a03103 	lsl	r3, r3, #2
    8764:	e0823003 	add	r3, r2, r3
    8768:	e1a02001 	mov	r2, r1
    876c:	e5832000 	str	r2, [r3]
    8770:	ea000000 	b	8778 <_ZN13CGPIO_Handler19Enable_Event_DetectEj20NGPIO_Interrupt_Type+0x7c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:99
        return;
    8774:	e320f000 	nop	{0}
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:108
    // TODO: vyresit tohle trochu lepe
    // sInterruptCtl.Enable_IRQ(hal::IRQ_Source::GPIO_0);
    // sInterruptCtl.Enable_IRQ(hal::IRQ_Source::GPIO_1);
    // sInterruptCtl.Enable_IRQ(hal::IRQ_Source::GPIO_2);
    // sInterruptCtl.Enable_IRQ(hal::IRQ_Source::GPIO_3);
}
    8778:	e24bd004 	sub	sp, fp, #4
    877c:	e8bd8800 	pop	{fp, pc}

00008780 <_ZNK13CGPIO_Handler26Get_GP_IRQ_Detect_LocationEj20NGPIO_Interrupt_TypeRjS1_>:
_ZNK13CGPIO_Handler26Get_GP_IRQ_Detect_LocationEj20NGPIO_Interrupt_TypeRjS1_():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:114

bool CGPIO_Handler::Get_GP_IRQ_Detect_Location(uint32_t pin,
                                               NGPIO_Interrupt_Type type,
                                               uint32_t& reg,
                                               uint32_t& bit_idx) const
{
    8780:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8784:	e28db000 	add	fp, sp, #0
    8788:	e24dd014 	sub	sp, sp, #20
    878c:	e50b0008 	str	r0, [fp, #-8]
    8790:	e50b100c 	str	r1, [fp, #-12]
    8794:	e50b2010 	str	r2, [fp, #-16]
    8798:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:115
    if (pin > hal::GPIO_Pin_Count)
    879c:	e51b300c 	ldr	r3, [fp, #-12]
    87a0:	e3530036 	cmp	r3, #54	; 0x36
    87a4:	9a000001 	bls	87b0 <_ZNK13CGPIO_Handler26Get_GP_IRQ_Detect_LocationEj20NGPIO_Interrupt_TypeRjS1_+0x30>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:116
        return false;
    87a8:	e3a03000 	mov	r3, #0
    87ac:	ea000032 	b	887c <_ZNK13CGPIO_Handler26Get_GP_IRQ_Detect_LocationEj20NGPIO_Interrupt_TypeRjS1_+0xfc>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:118

    bit_idx = pin % 32;
    87b0:	e51b300c 	ldr	r3, [fp, #-12]
    87b4:	e203201f 	and	r2, r3, #31
    87b8:	e59b3004 	ldr	r3, [fp, #4]
    87bc:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:120

    switch (type)
    87c0:	e51b3010 	ldr	r3, [fp, #-16]
    87c4:	e3530003 	cmp	r3, #3
    87c8:	979ff103 	ldrls	pc, [pc, r3, lsl #2]
    87cc:	ea000027 	b	8870 <_ZNK13CGPIO_Handler26Get_GP_IRQ_Detect_LocationEj20NGPIO_Interrupt_TypeRjS1_+0xf0>
    87d0:	000087e0 	andeq	r8, r0, r0, ror #15
    87d4:	00008804 	andeq	r8, r0, r4, lsl #16
    87d8:	00008828 	andeq	r8, r0, r8, lsr #16
    87dc:	0000884c 	andeq	r8, r0, ip, asr #16
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:123
    {
        case NGPIO_Interrupt_Type::Rising_Edge:
            reg = static_cast<uint32_t>((pin < 32) ? hal::GPIO_Reg::GPREN0 : hal::GPIO_Reg::GPREN1);
    87e0:	e51b300c 	ldr	r3, [fp, #-12]
    87e4:	e353001f 	cmp	r3, #31
    87e8:	8a000001 	bhi	87f4 <_ZNK13CGPIO_Handler26Get_GP_IRQ_Detect_LocationEj20NGPIO_Interrupt_TypeRjS1_+0x74>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:123 (discriminator 1)
    87ec:	e3a02013 	mov	r2, #19
    87f0:	ea000000 	b	87f8 <_ZNK13CGPIO_Handler26Get_GP_IRQ_Detect_LocationEj20NGPIO_Interrupt_TypeRjS1_+0x78>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:123 (discriminator 2)
    87f4:	e3a02014 	mov	r2, #20
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:123 (discriminator 4)
    87f8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    87fc:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:124 (discriminator 4)
            break;
    8800:	ea00001c 	b	8878 <_ZNK13CGPIO_Handler26Get_GP_IRQ_Detect_LocationEj20NGPIO_Interrupt_TypeRjS1_+0xf8>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:126
        case NGPIO_Interrupt_Type::Falling_Edge:
            reg = static_cast<uint32_t>((pin < 32) ? hal::GPIO_Reg::GPFEN0 : hal::GPIO_Reg::GPFEN1);
    8804:	e51b300c 	ldr	r3, [fp, #-12]
    8808:	e353001f 	cmp	r3, #31
    880c:	8a000001 	bhi	8818 <_ZNK13CGPIO_Handler26Get_GP_IRQ_Detect_LocationEj20NGPIO_Interrupt_TypeRjS1_+0x98>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:126 (discriminator 1)
    8810:	e3a02016 	mov	r2, #22
    8814:	ea000000 	b	881c <_ZNK13CGPIO_Handler26Get_GP_IRQ_Detect_LocationEj20NGPIO_Interrupt_TypeRjS1_+0x9c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:126 (discriminator 2)
    8818:	e3a02017 	mov	r2, #23
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:126 (discriminator 4)
    881c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8820:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:127 (discriminator 4)
            break;
    8824:	ea000013 	b	8878 <_ZNK13CGPIO_Handler26Get_GP_IRQ_Detect_LocationEj20NGPIO_Interrupt_TypeRjS1_+0xf8>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:129
        case NGPIO_Interrupt_Type::High:
            reg = static_cast<uint32_t>((pin < 32) ? hal::GPIO_Reg::GPHEN0 : hal::GPIO_Reg::GPHEN1);
    8828:	e51b300c 	ldr	r3, [fp, #-12]
    882c:	e353001f 	cmp	r3, #31
    8830:	8a000001 	bhi	883c <_ZNK13CGPIO_Handler26Get_GP_IRQ_Detect_LocationEj20NGPIO_Interrupt_TypeRjS1_+0xbc>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:129 (discriminator 1)
    8834:	e3a02019 	mov	r2, #25
    8838:	ea000000 	b	8840 <_ZNK13CGPIO_Handler26Get_GP_IRQ_Detect_LocationEj20NGPIO_Interrupt_TypeRjS1_+0xc0>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:129 (discriminator 2)
    883c:	e3a0201a 	mov	r2, #26
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:129 (discriminator 4)
    8840:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8844:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:130 (discriminator 4)
            break;
    8848:	ea00000a 	b	8878 <_ZNK13CGPIO_Handler26Get_GP_IRQ_Detect_LocationEj20NGPIO_Interrupt_TypeRjS1_+0xf8>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:132
        case NGPIO_Interrupt_Type::Low:
            reg = static_cast<uint32_t>((pin < 32) ? hal::GPIO_Reg::GPLEN0 : hal::GPIO_Reg::GPLEN1);
    884c:	e51b300c 	ldr	r3, [fp, #-12]
    8850:	e353001f 	cmp	r3, #31
    8854:	8a000001 	bhi	8860 <_ZNK13CGPIO_Handler26Get_GP_IRQ_Detect_LocationEj20NGPIO_Interrupt_TypeRjS1_+0xe0>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:132 (discriminator 1)
    8858:	e3a0201c 	mov	r2, #28
    885c:	ea000000 	b	8864 <_ZNK13CGPIO_Handler26Get_GP_IRQ_Detect_LocationEj20NGPIO_Interrupt_TypeRjS1_+0xe4>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:132 (discriminator 2)
    8860:	e3a0201d 	mov	r2, #29
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:132 (discriminator 4)
    8864:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8868:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:133 (discriminator 4)
            break;
    886c:	ea000001 	b	8878 <_ZNK13CGPIO_Handler26Get_GP_IRQ_Detect_LocationEj20NGPIO_Interrupt_TypeRjS1_+0xf8>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:135
        default:
            return false;
    8870:	e3a03000 	mov	r3, #0
    8874:	ea000000 	b	887c <_ZNK13CGPIO_Handler26Get_GP_IRQ_Detect_LocationEj20NGPIO_Interrupt_TypeRjS1_+0xfc>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:138
    }

    return true;
    8878:	e3a03001 	mov	r3, #1
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:139
}
    887c:	e1a00003 	mov	r0, r3
    8880:	e28bd000 	add	sp, fp, #0
    8884:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8888:	e12fff1e 	bx	lr

0000888c <_ZN13CGPIO_Handler20Disable_Event_DetectEj20NGPIO_Interrupt_Type>:
_ZN13CGPIO_Handler20Disable_Event_DetectEj20NGPIO_Interrupt_Type():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:142

void CGPIO_Handler::Disable_Event_Detect(uint32_t pin, NGPIO_Interrupt_Type type)
{
    888c:	e92d4800 	push	{fp, lr}
    8890:	e28db004 	add	fp, sp, #4
    8894:	e24dd028 	sub	sp, sp, #40	; 0x28
    8898:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    889c:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    88a0:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:144
    uint32_t reg, bit;
    if (!Get_GP_IRQ_Detect_Location(pin, type, reg, bit))
    88a4:	e24b200c 	sub	r2, fp, #12
    88a8:	e24b3010 	sub	r3, fp, #16
    88ac:	e58d3000 	str	r3, [sp]
    88b0:	e1a03002 	mov	r3, r2
    88b4:	e51b2020 	ldr	r2, [fp, #-32]	; 0xffffffe0
    88b8:	e51b101c 	ldr	r1, [fp, #-28]	; 0xffffffe4
    88bc:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    88c0:	ebffffae 	bl	8780 <_ZNK13CGPIO_Handler26Get_GP_IRQ_Detect_LocationEj20NGPIO_Interrupt_TypeRjS1_>
    88c4:	e1a03000 	mov	r3, r0
    88c8:	e2233001 	eor	r3, r3, #1
    88cc:	e6ef3073 	uxtb	r3, r3
    88d0:	e3530000 	cmp	r3, #0
    88d4:	1a000016 	bne	8934 <_ZN13CGPIO_Handler20Disable_Event_DetectEj20NGPIO_Interrupt_Type+0xa8>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:147
        return;

    uint32_t val = mGPIO[reg];
    88d8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    88dc:	e5932000 	ldr	r2, [r3]
    88e0:	e51b300c 	ldr	r3, [fp, #-12]
    88e4:	e1a03103 	lsl	r3, r3, #2
    88e8:	e0823003 	add	r3, r2, r3
    88ec:	e5933000 	ldr	r3, [r3]
    88f0:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:148
    val &= ~(1 << bit);
    88f4:	e51b3010 	ldr	r3, [fp, #-16]
    88f8:	e3a02001 	mov	r2, #1
    88fc:	e1a03312 	lsl	r3, r2, r3
    8900:	e1e03003 	mvn	r3, r3
    8904:	e1a02003 	mov	r2, r3
    8908:	e51b3008 	ldr	r3, [fp, #-8]
    890c:	e0033002 	and	r3, r3, r2
    8910:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:149
    mGPIO[reg] = val;
    8914:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8918:	e5932000 	ldr	r2, [r3]
    891c:	e51b300c 	ldr	r3, [fp, #-12]
    8920:	e1a03103 	lsl	r3, r3, #2
    8924:	e0823003 	add	r3, r2, r3
    8928:	e51b2008 	ldr	r2, [fp, #-8]
    892c:	e5832000 	str	r2, [r3]
    8930:	ea000000 	b	8938 <_ZN13CGPIO_Handler20Disable_Event_DetectEj20NGPIO_Interrupt_Type+0xac>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:145
        return;
    8934:	e320f000 	nop	{0}
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:150
}
    8938:	e24bd004 	sub	sp, fp, #4
    893c:	e8bd8800 	pop	{fp, pc}

00008940 <_ZN13CGPIO_Handler10Set_OutputEjb>:
_ZN13CGPIO_Handler10Set_OutputEjb():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:153

void CGPIO_Handler::Set_Output(uint32_t pin, bool set)
{
    8940:	e92d4800 	push	{fp, lr}
    8944:	e28db004 	add	fp, sp, #4
    8948:	e24dd018 	sub	sp, sp, #24
    894c:	e50b0010 	str	r0, [fp, #-16]
    8950:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8954:	e1a03002 	mov	r3, r2
    8958:	e54b3015 	strb	r3, [fp, #-21]	; 0xffffffeb
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:155
    uint32_t reg, bit;
    if (!(set && Get_GPSET_Location(pin, reg, bit)) && !(!set && Get_GPCLR_Location(pin, reg, bit)))
    895c:	e55b3015 	ldrb	r3, [fp, #-21]	; 0xffffffeb
    8960:	e2233001 	eor	r3, r3, #1
    8964:	e6ef3073 	uxtb	r3, r3
    8968:	e3530000 	cmp	r3, #0
    896c:	1a000009 	bne	8998 <_ZN13CGPIO_Handler10Set_OutputEjb+0x58>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:155 (discriminator 2)
    8970:	e24b300c 	sub	r3, fp, #12
    8974:	e24b2008 	sub	r2, fp, #8
    8978:	e51b1014 	ldr	r1, [fp, #-20]	; 0xffffffec
    897c:	e51b0010 	ldr	r0, [fp, #-16]
    8980:	ebfffeda 	bl	84f0 <_ZNK13CGPIO_Handler18Get_GPSET_LocationEjRjS0_>
    8984:	e1a03000 	mov	r3, r0
    8988:	e2233001 	eor	r3, r3, #1
    898c:	e6ef3073 	uxtb	r3, r3
    8990:	e3530000 	cmp	r3, #0
    8994:	0a00000e 	beq	89d4 <_ZN13CGPIO_Handler10Set_OutputEjb+0x94>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:155 (discriminator 3)
    8998:	e55b3015 	ldrb	r3, [fp, #-21]	; 0xffffffeb
    899c:	e3530000 	cmp	r3, #0
    89a0:	1a000009 	bne	89cc <_ZN13CGPIO_Handler10Set_OutputEjb+0x8c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:155 (discriminator 6)
    89a4:	e24b300c 	sub	r3, fp, #12
    89a8:	e24b2008 	sub	r2, fp, #8
    89ac:	e51b1014 	ldr	r1, [fp, #-20]	; 0xffffffec
    89b0:	e51b0010 	ldr	r0, [fp, #-16]
    89b4:	ebfffeb0 	bl	847c <_ZNK13CGPIO_Handler18Get_GPCLR_LocationEjRjS0_>
    89b8:	e1a03000 	mov	r3, r0
    89bc:	e2233001 	eor	r3, r3, #1
    89c0:	e6ef3073 	uxtb	r3, r3
    89c4:	e3530000 	cmp	r3, #0
    89c8:	0a000001 	beq	89d4 <_ZN13CGPIO_Handler10Set_OutputEjb+0x94>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:155 (discriminator 7)
    89cc:	e3a03001 	mov	r3, #1
    89d0:	ea000000 	b	89d8 <_ZN13CGPIO_Handler10Set_OutputEjb+0x98>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:155 (discriminator 8)
    89d4:	e3a03000 	mov	r3, #0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:155 (discriminator 10)
    89d8:	e3530000 	cmp	r3, #0
    89dc:	1a00000a 	bne	8a0c <_ZN13CGPIO_Handler10Set_OutputEjb+0xcc>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:158
        return;

    mGPIO[reg] = (1 << bit);
    89e0:	e51b300c 	ldr	r3, [fp, #-12]
    89e4:	e3a02001 	mov	r2, #1
    89e8:	e1a01312 	lsl	r1, r2, r3
    89ec:	e51b3010 	ldr	r3, [fp, #-16]
    89f0:	e5932000 	ldr	r2, [r3]
    89f4:	e51b3008 	ldr	r3, [fp, #-8]
    89f8:	e1a03103 	lsl	r3, r3, #2
    89fc:	e0823003 	add	r3, r2, r3
    8a00:	e1a02001 	mov	r2, r1
    8a04:	e5832000 	str	r2, [r3]
    8a08:	ea000000 	b	8a10 <_ZN13CGPIO_Handler10Set_OutputEjb+0xd0>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:156
        return;
    8a0c:	e320f000 	nop	{0}
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:159
}
    8a10:	e24bd004 	sub	sp, fp, #4
    8a14:	e8bd8800 	pop	{fp, pc}

00008a18 <_ZNK13CGPIO_Handler18Get_GPEDS_LocationEjRjS0_>:
_ZNK13CGPIO_Handler18Get_GPEDS_LocationEjRjS0_():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:162

bool CGPIO_Handler::Get_GPEDS_Location(uint32_t pin, uint32_t& reg, uint32_t& bit_idx) const
{
    8a18:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8a1c:	e28db000 	add	fp, sp, #0
    8a20:	e24dd014 	sub	sp, sp, #20
    8a24:	e50b0008 	str	r0, [fp, #-8]
    8a28:	e50b100c 	str	r1, [fp, #-12]
    8a2c:	e50b2010 	str	r2, [fp, #-16]
    8a30:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:163
    if (pin > hal::GPIO_Pin_Count)
    8a34:	e51b300c 	ldr	r3, [fp, #-12]
    8a38:	e3530036 	cmp	r3, #54	; 0x36
    8a3c:	9a000001 	bls	8a48 <_ZNK13CGPIO_Handler18Get_GPEDS_LocationEjRjS0_+0x30>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:164
        return false;
    8a40:	e3a03000 	mov	r3, #0
    8a44:	ea00000c 	b	8a7c <_ZNK13CGPIO_Handler18Get_GPEDS_LocationEjRjS0_+0x64>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:166

    reg = static_cast<uint32_t>((pin < 32) ? hal::GPIO_Reg::GPEDS0 : hal::GPIO_Reg::GPEDS1);
    8a48:	e51b300c 	ldr	r3, [fp, #-12]
    8a4c:	e353001f 	cmp	r3, #31
    8a50:	8a000001 	bhi	8a5c <_ZNK13CGPIO_Handler18Get_GPEDS_LocationEjRjS0_+0x44>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:166 (discriminator 1)
    8a54:	e3a02010 	mov	r2, #16
    8a58:	ea000000 	b	8a60 <_ZNK13CGPIO_Handler18Get_GPEDS_LocationEjRjS0_+0x48>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:166 (discriminator 2)
    8a5c:	e3a02011 	mov	r2, #17
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:166 (discriminator 4)
    8a60:	e51b3010 	ldr	r3, [fp, #-16]
    8a64:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:167 (discriminator 4)
    bit_idx = pin % 32;
    8a68:	e51b300c 	ldr	r3, [fp, #-12]
    8a6c:	e203201f 	and	r2, r3, #31
    8a70:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8a74:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:169 (discriminator 4)

    return true;
    8a78:	e3a03001 	mov	r3, #1
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:170
}
    8a7c:	e1a00003 	mov	r0, r3
    8a80:	e28bd000 	add	sp, fp, #0
    8a84:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8a88:	e12fff1e 	bx	lr

00008a8c <_ZN13CGPIO_Handler20Clear_Detected_EventEj>:
_ZN13CGPIO_Handler20Clear_Detected_EventEj():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:173

void CGPIO_Handler::Clear_Detected_Event(uint32_t pin)
{
    8a8c:	e92d4800 	push	{fp, lr}
    8a90:	e28db004 	add	fp, sp, #4
    8a94:	e24dd010 	sub	sp, sp, #16
    8a98:	e50b0010 	str	r0, [fp, #-16]
    8a9c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:175
    uint32_t reg, bit;
    if (!Get_GPEDS_Location(pin, reg, bit))
    8aa0:	e24b300c 	sub	r3, fp, #12
    8aa4:	e24b2008 	sub	r2, fp, #8
    8aa8:	e51b1014 	ldr	r1, [fp, #-20]	; 0xffffffec
    8aac:	e51b0010 	ldr	r0, [fp, #-16]
    8ab0:	ebffffd8 	bl	8a18 <_ZNK13CGPIO_Handler18Get_GPEDS_LocationEjRjS0_>
    8ab4:	e1a03000 	mov	r3, r0
    8ab8:	e2233001 	eor	r3, r3, #1
    8abc:	e6ef3073 	uxtb	r3, r3
    8ac0:	e3530000 	cmp	r3, #0
    8ac4:	1a00000a 	bne	8af4 <_ZN13CGPIO_Handler20Clear_Detected_EventEj+0x68>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:179
        return;

    // BCM2835 manual: "The bit is cleared by writing a '1' to the relevant bit."
    mGPIO[reg] = 1 << bit;
    8ac8:	e51b300c 	ldr	r3, [fp, #-12]
    8acc:	e3a02001 	mov	r2, #1
    8ad0:	e1a01312 	lsl	r1, r2, r3
    8ad4:	e51b3010 	ldr	r3, [fp, #-16]
    8ad8:	e5932000 	ldr	r2, [r3]
    8adc:	e51b3008 	ldr	r3, [fp, #-8]
    8ae0:	e1a03103 	lsl	r3, r3, #2
    8ae4:	e0823003 	add	r3, r2, r3
    8ae8:	e1a02001 	mov	r2, r1
    8aec:	e5832000 	str	r2, [r3]
    8af0:	ea000000 	b	8af8 <_ZN13CGPIO_Handler20Clear_Detected_EventEj+0x6c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:176
        return;
    8af4:	e320f000 	nop	{0}
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:180
    8af8:	e24bd004 	sub	sp, fp, #4
    8afc:	e8bd8800 	pop	{fp, pc}

00008b00 <_Z41__static_initialization_and_destruction_0ii>:
_Z41__static_initialization_and_destruction_0ii():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:180
    8b00:	e92d4800 	push	{fp, lr}
    8b04:	e28db004 	add	fp, sp, #4
    8b08:	e24dd008 	sub	sp, sp, #8
    8b0c:	e50b0008 	str	r0, [fp, #-8]
    8b10:	e50b100c 	str	r1, [fp, #-12]
    8b14:	e51b3008 	ldr	r3, [fp, #-8]
    8b18:	e3530001 	cmp	r3, #1
    8b1c:	1a000006 	bne	8b3c <_Z41__static_initialization_and_destruction_0ii+0x3c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:180 (discriminator 1)
    8b20:	e51b300c 	ldr	r3, [fp, #-12]
    8b24:	e59f201c 	ldr	r2, [pc, #28]	; 8b48 <_Z41__static_initialization_and_destruction_0ii+0x48>
    8b28:	e1530002 	cmp	r3, r2
    8b2c:	1a000002 	bne	8b3c <_Z41__static_initialization_and_destruction_0ii+0x3c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:4
CGPIO_Handler sGPIO(hal::GPIO_Base);
    8b30:	e59f1014 	ldr	r1, [pc, #20]	; 8b4c <_Z41__static_initialization_and_destruction_0ii+0x4c>
    8b34:	e59f0014 	ldr	r0, [pc, #20]	; 8b50 <_Z41__static_initialization_and_destruction_0ii+0x50>
    8b38:	ebfffdfd 	bl	8334 <_ZN13CGPIO_HandlerC1Ej>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:180
    8b3c:	e320f000 	nop	{0}
    8b40:	e24bd004 	sub	sp, fp, #4
    8b44:	e8bd8800 	pop	{fp, pc}
    8b48:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>
    8b4c:	20200000 	eorcs	r0, r0, r0
    8b50:	0000aa1c 	andeq	sl, r0, ip, lsl sl

00008b54 <_GLOBAL__sub_I_sGPIO>:
_GLOBAL__sub_I_sGPIO():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:180
    8b54:	e92d4800 	push	{fp, lr}
    8b58:	e28db004 	add	fp, sp, #4
    8b5c:	e59f1008 	ldr	r1, [pc, #8]	; 8b6c <_GLOBAL__sub_I_sGPIO+0x18>
    8b60:	e3a00001 	mov	r0, #1
    8b64:	ebffffe5 	bl	8b00 <_Z41__static_initialization_and_destruction_0ii>
    8b68:	e8bd8800 	pop	{fp, pc}
    8b6c:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>

00008b70 <_ZN8CMonitorC1Ejjj>:
_ZN8CMonitorC2Ejjj():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:5
#include <drivers/monitor.h>

CMonitor sMonitor{ 0x30000000, 80, 25 };

CMonitor::CMonitor(unsigned int monitor_base_addr, unsigned int width, unsigned int height)
    8b70:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8b74:	e28db000 	add	fp, sp, #0
    8b78:	e24dd014 	sub	sp, sp, #20
    8b7c:	e50b0008 	str	r0, [fp, #-8]
    8b80:	e50b100c 	str	r1, [fp, #-12]
    8b84:	e50b2010 	str	r2, [fp, #-16]
    8b88:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:6
: m_monitor{ reinterpret_cast<unsigned char*>(monitor_base_addr) }
    8b8c:	e51b200c 	ldr	r2, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:10
, m_width{ width }
, m_height{ height }
, m_cursor{ 0, 0 }
, m_number_base{ DEFAULT_NUMBER_BASE }
    8b90:	e51b3008 	ldr	r3, [fp, #-8]
    8b94:	e5832000 	str	r2, [r3]
    8b98:	e51b3008 	ldr	r3, [fp, #-8]
    8b9c:	e51b2010 	ldr	r2, [fp, #-16]
    8ba0:	e5832004 	str	r2, [r3, #4]
    8ba4:	e51b3008 	ldr	r3, [fp, #-8]
    8ba8:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8bac:	e5832008 	str	r2, [r3, #8]
    8bb0:	e51b3008 	ldr	r3, [fp, #-8]
    8bb4:	e3a02000 	mov	r2, #0
    8bb8:	e583200c 	str	r2, [r3, #12]
    8bbc:	e51b3008 	ldr	r3, [fp, #-8]
    8bc0:	e3a02000 	mov	r2, #0
    8bc4:	e5832010 	str	r2, [r3, #16]
    8bc8:	e51b3008 	ldr	r3, [fp, #-8]
    8bcc:	e3a0200a 	mov	r2, #10
    8bd0:	e5832014 	str	r2, [r3, #20]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:12
{
}
    8bd4:	e51b3008 	ldr	r3, [fp, #-8]
    8bd8:	e1a00003 	mov	r0, r3
    8bdc:	e28bd000 	add	sp, fp, #0
    8be0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8be4:	e12fff1e 	bx	lr

00008be8 <_ZN8CMonitor5ClearEv>:
_ZN8CMonitor5ClearEv():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:21
    m_cursor.y = 0;
    m_cursor.y = 0;
}

void CMonitor::Clear()
{
    8be8:	e92d4800 	push	{fp, lr}
    8bec:	e28db004 	add	fp, sp, #4
    8bf0:	e24dd010 	sub	sp, sp, #16
    8bf4:	e50b0010 	str	r0, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:22
    Reset_Cursor();
    8bf8:	e51b0010 	ldr	r0, [fp, #-16]
    8bfc:	eb00016d 	bl	91b8 <_ZN8CMonitor12Reset_CursorEv>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:24

    for (unsigned int y = 0; y < m_height; ++y)
    8c00:	e3a03000 	mov	r3, #0
    8c04:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:24 (discriminator 1)
    8c08:	e51b3010 	ldr	r3, [fp, #-16]
    8c0c:	e5933008 	ldr	r3, [r3, #8]
    8c10:	e51b2008 	ldr	r2, [fp, #-8]
    8c14:	e1520003 	cmp	r2, r3
    8c18:	2a000019 	bcs	8c84 <_ZN8CMonitor5ClearEv+0x9c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:26
    {
        for (unsigned int x = 0; x < m_width; ++x)
    8c1c:	e3a03000 	mov	r3, #0
    8c20:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:26 (discriminator 3)
    8c24:	e51b3010 	ldr	r3, [fp, #-16]
    8c28:	e5933004 	ldr	r3, [r3, #4]
    8c2c:	e51b200c 	ldr	r2, [fp, #-12]
    8c30:	e1520003 	cmp	r2, r3
    8c34:	2a00000e 	bcs	8c74 <_ZN8CMonitor5ClearEv+0x8c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:28 (discriminator 2)
        {
            m_monitor[(y * m_width) + x] = ' ';
    8c38:	e51b3010 	ldr	r3, [fp, #-16]
    8c3c:	e5932000 	ldr	r2, [r3]
    8c40:	e51b3010 	ldr	r3, [fp, #-16]
    8c44:	e5933004 	ldr	r3, [r3, #4]
    8c48:	e51b1008 	ldr	r1, [fp, #-8]
    8c4c:	e0010391 	mul	r1, r1, r3
    8c50:	e51b300c 	ldr	r3, [fp, #-12]
    8c54:	e0813003 	add	r3, r1, r3
    8c58:	e0823003 	add	r3, r2, r3
    8c5c:	e3a02020 	mov	r2, #32
    8c60:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:26 (discriminator 2)
        for (unsigned int x = 0; x < m_width; ++x)
    8c64:	e51b300c 	ldr	r3, [fp, #-12]
    8c68:	e2833001 	add	r3, r3, #1
    8c6c:	e50b300c 	str	r3, [fp, #-12]
    8c70:	eaffffeb 	b	8c24 <_ZN8CMonitor5ClearEv+0x3c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:24 (discriminator 2)
    for (unsigned int y = 0; y < m_height; ++y)
    8c74:	e51b3008 	ldr	r3, [fp, #-8]
    8c78:	e2833001 	add	r3, r3, #1
    8c7c:	e50b3008 	str	r3, [fp, #-8]
    8c80:	eaffffe0 	b	8c08 <_ZN8CMonitor5ClearEv+0x20>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:31
        }
    }
}
    8c84:	e320f000 	nop	{0}
    8c88:	e24bd004 	sub	sp, fp, #4
    8c8c:	e8bd8800 	pop	{fp, pc}

00008c90 <_ZN8CMonitor6ScrollEv>:
_ZN8CMonitor6ScrollEv():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:49
        m_cursor.y = m_height - 1;
    }
}

void CMonitor::Scroll()
{
    8c90:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8c94:	e28db000 	add	fp, sp, #0
    8c98:	e24dd01c 	sub	sp, sp, #28
    8c9c:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:50
    for (unsigned int y = 1; y < m_height; ++y)
    8ca0:	e3a03001 	mov	r3, #1
    8ca4:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:50 (discriminator 1)
    8ca8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8cac:	e5933008 	ldr	r3, [r3, #8]
    8cb0:	e51b2008 	ldr	r2, [fp, #-8]
    8cb4:	e1520003 	cmp	r2, r3
    8cb8:	2a000024 	bcs	8d50 <_ZN8CMonitor6ScrollEv+0xc0>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:52
    {
        for (unsigned int x = 0; x < m_width; ++x)
    8cbc:	e3a03000 	mov	r3, #0
    8cc0:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:52 (discriminator 3)
    8cc4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8cc8:	e5933004 	ldr	r3, [r3, #4]
    8ccc:	e51b200c 	ldr	r2, [fp, #-12]
    8cd0:	e1520003 	cmp	r2, r3
    8cd4:	2a000019 	bcs	8d40 <_ZN8CMonitor6ScrollEv+0xb0>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:54 (discriminator 2)
        {
            m_monitor[((y - 1) * m_width) + x] = m_monitor[(y * m_width) + x];
    8cd8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8cdc:	e5932000 	ldr	r2, [r3]
    8ce0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8ce4:	e5933004 	ldr	r3, [r3, #4]
    8ce8:	e51b1008 	ldr	r1, [fp, #-8]
    8cec:	e0010391 	mul	r1, r1, r3
    8cf0:	e51b300c 	ldr	r3, [fp, #-12]
    8cf4:	e0813003 	add	r3, r1, r3
    8cf8:	e0822003 	add	r2, r2, r3
    8cfc:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8d00:	e5931000 	ldr	r1, [r3]
    8d04:	e51b3008 	ldr	r3, [fp, #-8]
    8d08:	e2433001 	sub	r3, r3, #1
    8d0c:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    8d10:	e5900004 	ldr	r0, [r0, #4]
    8d14:	e0000390 	mul	r0, r0, r3
    8d18:	e51b300c 	ldr	r3, [fp, #-12]
    8d1c:	e0803003 	add	r3, r0, r3
    8d20:	e0813003 	add	r3, r1, r3
    8d24:	e5d22000 	ldrb	r2, [r2]
    8d28:	e6ef2072 	uxtb	r2, r2
    8d2c:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:52 (discriminator 2)
        for (unsigned int x = 0; x < m_width; ++x)
    8d30:	e51b300c 	ldr	r3, [fp, #-12]
    8d34:	e2833001 	add	r3, r3, #1
    8d38:	e50b300c 	str	r3, [fp, #-12]
    8d3c:	eaffffe0 	b	8cc4 <_ZN8CMonitor6ScrollEv+0x34>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:50 (discriminator 2)
    for (unsigned int y = 1; y < m_height; ++y)
    8d40:	e51b3008 	ldr	r3, [fp, #-8]
    8d44:	e2833001 	add	r3, r3, #1
    8d48:	e50b3008 	str	r3, [fp, #-8]
    8d4c:	eaffffd5 	b	8ca8 <_ZN8CMonitor6ScrollEv+0x18>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:58
        }
    }

    for (unsigned int x = 0; x < m_width; ++x)
    8d50:	e3a03000 	mov	r3, #0
    8d54:	e50b3010 	str	r3, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:58 (discriminator 3)
    8d58:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8d5c:	e5933004 	ldr	r3, [r3, #4]
    8d60:	e51b2010 	ldr	r2, [fp, #-16]
    8d64:	e1520003 	cmp	r2, r3
    8d68:	2a000010 	bcs	8db0 <_ZN8CMonitor6ScrollEv+0x120>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:60 (discriminator 2)
    {
        m_monitor[((m_height - 1) * m_width) + x] = ' ';
    8d6c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8d70:	e5932000 	ldr	r2, [r3]
    8d74:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8d78:	e5933008 	ldr	r3, [r3, #8]
    8d7c:	e2433001 	sub	r3, r3, #1
    8d80:	e51b1018 	ldr	r1, [fp, #-24]	; 0xffffffe8
    8d84:	e5911004 	ldr	r1, [r1, #4]
    8d88:	e0010391 	mul	r1, r1, r3
    8d8c:	e51b3010 	ldr	r3, [fp, #-16]
    8d90:	e0813003 	add	r3, r1, r3
    8d94:	e0823003 	add	r3, r2, r3
    8d98:	e3a02020 	mov	r2, #32
    8d9c:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:58 (discriminator 2)
    for (unsigned int x = 0; x < m_width; ++x)
    8da0:	e51b3010 	ldr	r3, [fp, #-16]
    8da4:	e2833001 	add	r3, r3, #1
    8da8:	e50b3010 	str	r3, [fp, #-16]
    8dac:	eaffffe9 	b	8d58 <_ZN8CMonitor6ScrollEv+0xc8>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:62
    }
}
    8db0:	e320f000 	nop	{0}
    8db4:	e28bd000 	add	sp, fp, #0
    8db8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8dbc:	e12fff1e 	bx	lr

00008dc0 <_ZN8CMonitorlsEc>:
_ZN8CMonitorlsEc():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:70
{
    m_number_base = DEFAULT_NUMBER_BASE;
}

CMonitor& CMonitor::operator<<(char c)
{
    8dc0:	e92d4800 	push	{fp, lr}
    8dc4:	e28db004 	add	fp, sp, #4
    8dc8:	e24dd008 	sub	sp, sp, #8
    8dcc:	e50b0008 	str	r0, [fp, #-8]
    8dd0:	e1a03001 	mov	r3, r1
    8dd4:	e54b3009 	strb	r3, [fp, #-9]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:71
    if (c != '\n')
    8dd8:	e55b3009 	ldrb	r3, [fp, #-9]
    8ddc:	e353000a 	cmp	r3, #10
    8de0:	0a000012 	beq	8e30 <_ZN8CMonitorlsEc+0x70>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:73
    {
        m_monitor[(m_cursor.y * m_width) + m_cursor.x] = static_cast<unsigned char>(c);
    8de4:	e51b3008 	ldr	r3, [fp, #-8]
    8de8:	e5932000 	ldr	r2, [r3]
    8dec:	e51b3008 	ldr	r3, [fp, #-8]
    8df0:	e593300c 	ldr	r3, [r3, #12]
    8df4:	e51b1008 	ldr	r1, [fp, #-8]
    8df8:	e5911004 	ldr	r1, [r1, #4]
    8dfc:	e0010391 	mul	r1, r1, r3
    8e00:	e51b3008 	ldr	r3, [fp, #-8]
    8e04:	e5933010 	ldr	r3, [r3, #16]
    8e08:	e0813003 	add	r3, r1, r3
    8e0c:	e0823003 	add	r3, r2, r3
    8e10:	e55b2009 	ldrb	r2, [fp, #-9]
    8e14:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:74
        ++m_cursor.x;
    8e18:	e51b3008 	ldr	r3, [fp, #-8]
    8e1c:	e5933010 	ldr	r3, [r3, #16]
    8e20:	e2832001 	add	r2, r3, #1
    8e24:	e51b3008 	ldr	r3, [fp, #-8]
    8e28:	e5832010 	str	r2, [r3, #16]
    8e2c:	ea000007 	b	8e50 <_ZN8CMonitorlsEc+0x90>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:78
    }
    else
    {
        m_cursor.x = 0;
    8e30:	e51b3008 	ldr	r3, [fp, #-8]
    8e34:	e3a02000 	mov	r2, #0
    8e38:	e5832010 	str	r2, [r3, #16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:79
        ++m_cursor.y;
    8e3c:	e51b3008 	ldr	r3, [fp, #-8]
    8e40:	e593300c 	ldr	r3, [r3, #12]
    8e44:	e2832001 	add	r2, r3, #1
    8e48:	e51b3008 	ldr	r3, [fp, #-8]
    8e4c:	e583200c 	str	r2, [r3, #12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:82
    }

    Adjust_Cursor();
    8e50:	e51b0008 	ldr	r0, [fp, #-8]
    8e54:	eb0000e5 	bl	91f0 <_ZN8CMonitor13Adjust_CursorEv>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:84

    return *this;
    8e58:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:85
}
    8e5c:	e1a00003 	mov	r0, r3
    8e60:	e24bd004 	sub	sp, fp, #4
    8e64:	e8bd8800 	pop	{fp, pc}

00008e68 <_ZN8CMonitorlsEPKc>:
_ZN8CMonitorlsEPKc():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:88

CMonitor& CMonitor::operator<<(const char* str)
{
    8e68:	e92d4800 	push	{fp, lr}
    8e6c:	e28db004 	add	fp, sp, #4
    8e70:	e24dd010 	sub	sp, sp, #16
    8e74:	e50b0010 	str	r0, [fp, #-16]
    8e78:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:89
    for (unsigned int i = 0; str[i] != '\0'; ++i)
    8e7c:	e3a03000 	mov	r3, #0
    8e80:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:89 (discriminator 3)
    8e84:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8e88:	e51b3008 	ldr	r3, [fp, #-8]
    8e8c:	e0823003 	add	r3, r2, r3
    8e90:	e5d33000 	ldrb	r3, [r3]
    8e94:	e3530000 	cmp	r3, #0
    8e98:	0a00000a 	beq	8ec8 <_ZN8CMonitorlsEPKc+0x60>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:91 (discriminator 2)
    {
        *this << str[i];
    8e9c:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8ea0:	e51b3008 	ldr	r3, [fp, #-8]
    8ea4:	e0823003 	add	r3, r2, r3
    8ea8:	e5d33000 	ldrb	r3, [r3]
    8eac:	e1a01003 	mov	r1, r3
    8eb0:	e51b0010 	ldr	r0, [fp, #-16]
    8eb4:	ebffffc1 	bl	8dc0 <_ZN8CMonitorlsEc>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:89 (discriminator 2)
    for (unsigned int i = 0; str[i] != '\0'; ++i)
    8eb8:	e51b3008 	ldr	r3, [fp, #-8]
    8ebc:	e2833001 	add	r3, r3, #1
    8ec0:	e50b3008 	str	r3, [fp, #-8]
    8ec4:	eaffffee 	b	8e84 <_ZN8CMonitorlsEPKc+0x1c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:94
    }

    Reset_Number_Base();
    8ec8:	e51b0010 	ldr	r0, [fp, #-16]
    8ecc:	eb0000e9 	bl	9278 <_ZN8CMonitor17Reset_Number_BaseEv>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:96

    return *this;
    8ed0:	e51b3010 	ldr	r3, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:97
}
    8ed4:	e1a00003 	mov	r0, r3
    8ed8:	e24bd004 	sub	sp, fp, #4
    8edc:	e8bd8800 	pop	{fp, pc}

00008ee0 <_ZN8CMonitorlsENS_12NNumber_BaseE>:
_ZN8CMonitorlsENS_12NNumber_BaseE():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:100

CMonitor& CMonitor::operator<<(CMonitor::NNumber_Base number_base)
{
    8ee0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8ee4:	e28db000 	add	fp, sp, #0
    8ee8:	e24dd00c 	sub	sp, sp, #12
    8eec:	e50b0008 	str	r0, [fp, #-8]
    8ef0:	e50b100c 	str	r1, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:101
    m_number_base = number_base;
    8ef4:	e51b3008 	ldr	r3, [fp, #-8]
    8ef8:	e51b200c 	ldr	r2, [fp, #-12]
    8efc:	e5832014 	str	r2, [r3, #20]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:103

    return *this;
    8f00:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:104
}
    8f04:	e1a00003 	mov	r0, r3
    8f08:	e28bd000 	add	sp, fp, #0
    8f0c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8f10:	e12fff1e 	bx	lr

00008f14 <_ZN8CMonitorlsEj>:
_ZN8CMonitorlsEj():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:107

CMonitor& CMonitor::operator<<(unsigned int num)
{
    8f14:	e92d4800 	push	{fp, lr}
    8f18:	e28db004 	add	fp, sp, #4
    8f1c:	e24dd008 	sub	sp, sp, #8
    8f20:	e50b0008 	str	r0, [fp, #-8]
    8f24:	e50b100c 	str	r1, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:112
    static constexpr unsigned int BUFFER_SIZE = 16;

    static char s_buffer[BUFFER_SIZE];

    itoa(num, s_buffer, static_cast<unsigned int>(m_number_base));
    8f28:	e51b3008 	ldr	r3, [fp, #-8]
    8f2c:	e5933014 	ldr	r3, [r3, #20]
    8f30:	e59f202c 	ldr	r2, [pc, #44]	; 8f64 <_ZN8CMonitorlsEj+0x50>
    8f34:	e51b100c 	ldr	r1, [fp, #-12]
    8f38:	e51b0008 	ldr	r0, [fp, #-8]
    8f3c:	eb000021 	bl	8fc8 <_ZN8CMonitor4itoaEjPcj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:113
    *this << s_buffer;
    8f40:	e59f101c 	ldr	r1, [pc, #28]	; 8f64 <_ZN8CMonitorlsEj+0x50>
    8f44:	e51b0008 	ldr	r0, [fp, #-8]
    8f48:	ebffffc6 	bl	8e68 <_ZN8CMonitorlsEPKc>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:114
    Reset_Number_Base();
    8f4c:	e51b0008 	ldr	r0, [fp, #-8]
    8f50:	eb0000c8 	bl	9278 <_ZN8CMonitor17Reset_Number_BaseEv>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:116

    return *this;
    8f54:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:117
}
    8f58:	e1a00003 	mov	r0, r3
    8f5c:	e24bd004 	sub	sp, fp, #4
    8f60:	e8bd8800 	pop	{fp, pc}
    8f64:	0000aa38 	andeq	sl, r0, r8, lsr sl

00008f68 <_ZN8CMonitorlsEb>:
_ZN8CMonitorlsEb():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:120

CMonitor& CMonitor::operator<<(bool value)
{
    8f68:	e92d4800 	push	{fp, lr}
    8f6c:	e28db004 	add	fp, sp, #4
    8f70:	e24dd008 	sub	sp, sp, #8
    8f74:	e50b0008 	str	r0, [fp, #-8]
    8f78:	e1a03001 	mov	r3, r1
    8f7c:	e54b3009 	strb	r3, [fp, #-9]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:121
    if (value)
    8f80:	e55b3009 	ldrb	r3, [fp, #-9]
    8f84:	e3530000 	cmp	r3, #0
    8f88:	0a000003 	beq	8f9c <_ZN8CMonitorlsEb+0x34>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:123
    {
        *this << "true";
    8f8c:	e59f102c 	ldr	r1, [pc, #44]	; 8fc0 <_ZN8CMonitorlsEb+0x58>
    8f90:	e51b0008 	ldr	r0, [fp, #-8]
    8f94:	ebffffb3 	bl	8e68 <_ZN8CMonitorlsEPKc>
    8f98:	ea000002 	b	8fa8 <_ZN8CMonitorlsEb+0x40>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:127
    }
    else
    {
        *this << "false";
    8f9c:	e59f1020 	ldr	r1, [pc, #32]	; 8fc4 <_ZN8CMonitorlsEb+0x5c>
    8fa0:	e51b0008 	ldr	r0, [fp, #-8]
    8fa4:	ebffffaf 	bl	8e68 <_ZN8CMonitorlsEPKc>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:130
    }

    Reset_Number_Base();
    8fa8:	e51b0008 	ldr	r0, [fp, #-8]
    8fac:	eb0000b1 	bl	9278 <_ZN8CMonitor17Reset_Number_BaseEv>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:132

    return *this;
    8fb0:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:133
}
    8fb4:	e1a00003 	mov	r0, r3
    8fb8:	e24bd004 	sub	sp, fp, #4
    8fbc:	e8bd8800 	pop	{fp, pc}
    8fc0:	0000a77c 	andeq	sl, r0, ip, ror r7
    8fc4:	0000a784 	andeq	sl, r0, r4, lsl #15

00008fc8 <_ZN8CMonitor4itoaEjPcj>:
_ZN8CMonitor4itoaEjPcj():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:136

void CMonitor::itoa(unsigned int input, char* output, unsigned int base)
{
    8fc8:	e92d4800 	push	{fp, lr}
    8fcc:	e28db004 	add	fp, sp, #4
    8fd0:	e24dd020 	sub	sp, sp, #32
    8fd4:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8fd8:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    8fdc:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    8fe0:	e50b3024 	str	r3, [fp, #-36]	; 0xffffffdc
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:137
    int i = 0;
    8fe4:	e3a03000 	mov	r3, #0
    8fe8:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:139

    while (input > 0)
    8fec:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8ff0:	e3530000 	cmp	r3, #0
    8ff4:	0a000015 	beq	9050 <_ZN8CMonitor4itoaEjPcj+0x88>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:141
    {
        output[i] = CharConvArr[input % base];
    8ff8:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8ffc:	e51b1024 	ldr	r1, [fp, #-36]	; 0xffffffdc
    9000:	e1a00003 	mov	r0, r3
    9004:	eb000568 	bl	a5ac <__aeabi_uidivmod>
    9008:	e1a03001 	mov	r3, r1
    900c:	e1a02003 	mov	r2, r3
    9010:	e59f3128 	ldr	r3, [pc, #296]	; 9140 <_ZN8CMonitor4itoaEjPcj+0x178>
    9014:	e0822003 	add	r2, r2, r3
    9018:	e51b3008 	ldr	r3, [fp, #-8]
    901c:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    9020:	e0813003 	add	r3, r1, r3
    9024:	e5d22000 	ldrb	r2, [r2]
    9028:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:142
        input /= base;
    902c:	e51b1024 	ldr	r1, [fp, #-36]	; 0xffffffdc
    9030:	e51b001c 	ldr	r0, [fp, #-28]	; 0xffffffe4
    9034:	eb0004e1 	bl	a3c0 <__udivsi3>
    9038:	e1a03000 	mov	r3, r0
    903c:	e50b301c 	str	r3, [fp, #-28]	; 0xffffffe4
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:144

        i++;
    9040:	e51b3008 	ldr	r3, [fp, #-8]
    9044:	e2833001 	add	r3, r3, #1
    9048:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:139
    while (input > 0)
    904c:	eaffffe6 	b	8fec <_ZN8CMonitor4itoaEjPcj+0x24>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:147
    }

    if (i == 0)
    9050:	e51b3008 	ldr	r3, [fp, #-8]
    9054:	e3530000 	cmp	r3, #0
    9058:	1a000007 	bne	907c <_ZN8CMonitor4itoaEjPcj+0xb4>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:149
    {
        output[i] = CharConvArr[0];
    905c:	e51b3008 	ldr	r3, [fp, #-8]
    9060:	e51b2020 	ldr	r2, [fp, #-32]	; 0xffffffe0
    9064:	e0823003 	add	r3, r2, r3
    9068:	e3a02030 	mov	r2, #48	; 0x30
    906c:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:150
        i++;
    9070:	e51b3008 	ldr	r3, [fp, #-8]
    9074:	e2833001 	add	r3, r3, #1
    9078:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:153
    }

    output[i] = '\0';
    907c:	e51b3008 	ldr	r3, [fp, #-8]
    9080:	e51b2020 	ldr	r2, [fp, #-32]	; 0xffffffe0
    9084:	e0823003 	add	r3, r2, r3
    9088:	e3a02000 	mov	r2, #0
    908c:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:154
    i--;
    9090:	e51b3008 	ldr	r3, [fp, #-8]
    9094:	e2433001 	sub	r3, r3, #1
    9098:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:156

    for (int j = 0; j <= (i / 2); j++)
    909c:	e3a03000 	mov	r3, #0
    90a0:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:156 (discriminator 3)
    90a4:	e51b3008 	ldr	r3, [fp, #-8]
    90a8:	e1a02fa3 	lsr	r2, r3, #31
    90ac:	e0823003 	add	r3, r2, r3
    90b0:	e1a030c3 	asr	r3, r3, #1
    90b4:	e1a02003 	mov	r2, r3
    90b8:	e51b300c 	ldr	r3, [fp, #-12]
    90bc:	e1530002 	cmp	r3, r2
    90c0:	ca00001b 	bgt	9134 <_ZN8CMonitor4itoaEjPcj+0x16c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:158 (discriminator 2)
    {
        char c = output[i - j];
    90c4:	e51b2008 	ldr	r2, [fp, #-8]
    90c8:	e51b300c 	ldr	r3, [fp, #-12]
    90cc:	e0423003 	sub	r3, r2, r3
    90d0:	e1a02003 	mov	r2, r3
    90d4:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    90d8:	e0833002 	add	r3, r3, r2
    90dc:	e5d33000 	ldrb	r3, [r3]
    90e0:	e54b300d 	strb	r3, [fp, #-13]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:159 (discriminator 2)
        output[i - j] = output[j];
    90e4:	e51b300c 	ldr	r3, [fp, #-12]
    90e8:	e51b2020 	ldr	r2, [fp, #-32]	; 0xffffffe0
    90ec:	e0822003 	add	r2, r2, r3
    90f0:	e51b1008 	ldr	r1, [fp, #-8]
    90f4:	e51b300c 	ldr	r3, [fp, #-12]
    90f8:	e0413003 	sub	r3, r1, r3
    90fc:	e1a01003 	mov	r1, r3
    9100:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    9104:	e0833001 	add	r3, r3, r1
    9108:	e5d22000 	ldrb	r2, [r2]
    910c:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:160 (discriminator 2)
        output[j] = c;
    9110:	e51b300c 	ldr	r3, [fp, #-12]
    9114:	e51b2020 	ldr	r2, [fp, #-32]	; 0xffffffe0
    9118:	e0823003 	add	r3, r2, r3
    911c:	e55b200d 	ldrb	r2, [fp, #-13]
    9120:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:156 (discriminator 2)
    for (int j = 0; j <= (i / 2); j++)
    9124:	e51b300c 	ldr	r3, [fp, #-12]
    9128:	e2833001 	add	r3, r3, #1
    912c:	e50b300c 	str	r3, [fp, #-12]
    9130:	eaffffdb 	b	90a4 <_ZN8CMonitor4itoaEjPcj+0xdc>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:162
    }
}
    9134:	e320f000 	nop	{0}
    9138:	e24bd004 	sub	sp, fp, #4
    913c:	e8bd8800 	pop	{fp, pc}
    9140:	0000a78c 	andeq	sl, r0, ip, lsl #15

00009144 <_Z41__static_initialization_and_destruction_0ii>:
_Z41__static_initialization_and_destruction_0ii():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:162
    9144:	e92d4800 	push	{fp, lr}
    9148:	e28db004 	add	fp, sp, #4
    914c:	e24dd008 	sub	sp, sp, #8
    9150:	e50b0008 	str	r0, [fp, #-8]
    9154:	e50b100c 	str	r1, [fp, #-12]
    9158:	e51b3008 	ldr	r3, [fp, #-8]
    915c:	e3530001 	cmp	r3, #1
    9160:	1a000008 	bne	9188 <_Z41__static_initialization_and_destruction_0ii+0x44>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:162 (discriminator 1)
    9164:	e51b300c 	ldr	r3, [fp, #-12]
    9168:	e59f2024 	ldr	r2, [pc, #36]	; 9194 <_Z41__static_initialization_and_destruction_0ii+0x50>
    916c:	e1530002 	cmp	r3, r2
    9170:	1a000004 	bne	9188 <_Z41__static_initialization_and_destruction_0ii+0x44>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:3
CMonitor sMonitor{ 0x30000000, 80, 25 };
    9174:	e3a03019 	mov	r3, #25
    9178:	e3a02050 	mov	r2, #80	; 0x50
    917c:	e3a01203 	mov	r1, #805306368	; 0x30000000
    9180:	e59f0010 	ldr	r0, [pc, #16]	; 9198 <_Z41__static_initialization_and_destruction_0ii+0x54>
    9184:	ebfffe79 	bl	8b70 <_ZN8CMonitorC1Ejjj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:162
}
    9188:	e320f000 	nop	{0}
    918c:	e24bd004 	sub	sp, fp, #4
    9190:	e8bd8800 	pop	{fp, pc}
    9194:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>
    9198:	0000aa20 	andeq	sl, r0, r0, lsr #20

0000919c <_GLOBAL__sub_I_sMonitor>:
_GLOBAL__sub_I_sMonitor():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:162
    919c:	e92d4800 	push	{fp, lr}
    91a0:	e28db004 	add	fp, sp, #4
    91a4:	e59f1008 	ldr	r1, [pc, #8]	; 91b4 <_GLOBAL__sub_I_sMonitor+0x18>
    91a8:	e3a00001 	mov	r0, #1
    91ac:	ebffffe4 	bl	9144 <_Z41__static_initialization_and_destruction_0ii>
    91b0:	e8bd8800 	pop	{fp, pc}
    91b4:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>

000091b8 <_ZN8CMonitor12Reset_CursorEv>:
_ZN8CMonitor12Reset_CursorEv():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:15
{
    91b8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    91bc:	e28db000 	add	fp, sp, #0
    91c0:	e24dd00c 	sub	sp, sp, #12
    91c4:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:16
    m_cursor.y = 0;
    91c8:	e51b3008 	ldr	r3, [fp, #-8]
    91cc:	e3a02000 	mov	r2, #0
    91d0:	e583200c 	str	r2, [r3, #12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:17
    m_cursor.y = 0;
    91d4:	e51b3008 	ldr	r3, [fp, #-8]
    91d8:	e3a02000 	mov	r2, #0
    91dc:	e583200c 	str	r2, [r3, #12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:18
}
    91e0:	e320f000 	nop	{0}
    91e4:	e28bd000 	add	sp, fp, #0
    91e8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    91ec:	e12fff1e 	bx	lr

000091f0 <_ZN8CMonitor13Adjust_CursorEv>:
_ZN8CMonitor13Adjust_CursorEv():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:34
{
    91f0:	e92d4800 	push	{fp, lr}
    91f4:	e28db004 	add	fp, sp, #4
    91f8:	e24dd008 	sub	sp, sp, #8
    91fc:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:35
    if (m_cursor.x >= m_width)
    9200:	e51b3008 	ldr	r3, [fp, #-8]
    9204:	e5932010 	ldr	r2, [r3, #16]
    9208:	e51b3008 	ldr	r3, [fp, #-8]
    920c:	e5933004 	ldr	r3, [r3, #4]
    9210:	e1520003 	cmp	r2, r3
    9214:	3a000007 	bcc	9238 <_ZN8CMonitor13Adjust_CursorEv+0x48>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:37
        m_cursor.x = 0;
    9218:	e51b3008 	ldr	r3, [fp, #-8]
    921c:	e3a02000 	mov	r2, #0
    9220:	e5832010 	str	r2, [r3, #16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:38
        ++m_cursor.y;
    9224:	e51b3008 	ldr	r3, [fp, #-8]
    9228:	e593300c 	ldr	r3, [r3, #12]
    922c:	e2832001 	add	r2, r3, #1
    9230:	e51b3008 	ldr	r3, [fp, #-8]
    9234:	e583200c 	str	r2, [r3, #12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:41
    if (m_cursor.y >= m_height)
    9238:	e51b3008 	ldr	r3, [fp, #-8]
    923c:	e593200c 	ldr	r2, [r3, #12]
    9240:	e51b3008 	ldr	r3, [fp, #-8]
    9244:	e5933008 	ldr	r3, [r3, #8]
    9248:	e1520003 	cmp	r2, r3
    924c:	3a000006 	bcc	926c <_ZN8CMonitor13Adjust_CursorEv+0x7c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:43
        Scroll();
    9250:	e51b0008 	ldr	r0, [fp, #-8]
    9254:	ebfffe8d 	bl	8c90 <_ZN8CMonitor6ScrollEv>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:44
        m_cursor.y = m_height - 1;
    9258:	e51b3008 	ldr	r3, [fp, #-8]
    925c:	e5933008 	ldr	r3, [r3, #8]
    9260:	e2432001 	sub	r2, r3, #1
    9264:	e51b3008 	ldr	r3, [fp, #-8]
    9268:	e583200c 	str	r2, [r3, #12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:46
}
    926c:	e320f000 	nop	{0}
    9270:	e24bd004 	sub	sp, fp, #4
    9274:	e8bd8800 	pop	{fp, pc}

00009278 <_ZN8CMonitor17Reset_Number_BaseEv>:
_ZN8CMonitor17Reset_Number_BaseEv():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:65
{
    9278:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    927c:	e28db000 	add	fp, sp, #0
    9280:	e24dd00c 	sub	sp, sp, #12
    9284:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:66
    m_number_base = DEFAULT_NUMBER_BASE;
    9288:	e51b3008 	ldr	r3, [fp, #-8]
    928c:	e3a0200a 	mov	r2, #10
    9290:	e5832014 	str	r2, [r3, #20]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/monitor.cpp:67
}
    9294:	e320f000 	nop	{0}
    9298:	e28bd000 	add	sp, fp, #0
    929c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    92a0:	e12fff1e 	bx	lr

000092a4 <_ZN5CUARTC1ER4CAUX>:
_ZN5CUARTC2ER4CAUX():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:8
#include <drivers/monitor.h>
#include <stdstring.h>

CUART sUART0(sAUX);

CUART::CUART(CAUX& aux)
    92a4:	e92d4800 	push	{fp, lr}
    92a8:	e28db004 	add	fp, sp, #4
    92ac:	e24dd008 	sub	sp, sp, #8
    92b0:	e50b0008 	str	r0, [fp, #-8]
    92b4:	e50b100c 	str	r1, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:9
: mAUX(aux)
    92b8:	e51b3008 	ldr	r3, [fp, #-8]
    92bc:	e51b200c 	ldr	r2, [fp, #-12]
    92c0:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:11
{
    mAUX.Enable(hal::AUX_Peripherals::MiniUART);
    92c4:	e51b3008 	ldr	r3, [fp, #-8]
    92c8:	e5933000 	ldr	r3, [r3]
    92cc:	e3a01000 	mov	r1, #0
    92d0:	e1a00003 	mov	r0, r3
    92d4:	ebfffbb1 	bl	81a0 <_ZN4CAUX6EnableEN3hal15AUX_PeripheralsE>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:13
    // mAUX.Set_Register(hal::AUX_Reg::ENABLES, mAUX.Get_Register(hal::AUX_Reg::ENABLES) | 0x01);
    mAUX.Set_Register(hal::AUX_Reg::MU_IIR, 0);
    92d8:	e51b3008 	ldr	r3, [fp, #-8]
    92dc:	e5933000 	ldr	r3, [r3]
    92e0:	e3a02000 	mov	r2, #0
    92e4:	e3a01012 	mov	r1, #18
    92e8:	e1a00003 	mov	r0, r3
    92ec:	ebfffbd4 	bl	8244 <_ZN4CAUX12Set_RegisterEN3hal7AUX_RegEj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:14
    mAUX.Set_Register(hal::AUX_Reg::MU_IER, 0);
    92f0:	e51b3008 	ldr	r3, [fp, #-8]
    92f4:	e5933000 	ldr	r3, [r3]
    92f8:	e3a02000 	mov	r2, #0
    92fc:	e3a01011 	mov	r1, #17
    9300:	e1a00003 	mov	r0, r3
    9304:	ebfffbce 	bl	8244 <_ZN4CAUX12Set_RegisterEN3hal7AUX_RegEj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:15
    mAUX.Set_Register(hal::AUX_Reg::MU_MCR, 0);
    9308:	e51b3008 	ldr	r3, [fp, #-8]
    930c:	e5933000 	ldr	r3, [r3]
    9310:	e3a02000 	mov	r2, #0
    9314:	e3a01014 	mov	r1, #20
    9318:	e1a00003 	mov	r0, r3
    931c:	ebfffbc8 	bl	8244 <_ZN4CAUX12Set_RegisterEN3hal7AUX_RegEj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:16
    mAUX.Set_Register(hal::AUX_Reg::MU_CNTL, 3); // RX and TX enabled
    9320:	e51b3008 	ldr	r3, [fp, #-8]
    9324:	e5933000 	ldr	r3, [r3]
    9328:	e3a02003 	mov	r2, #3
    932c:	e3a01018 	mov	r1, #24
    9330:	e1a00003 	mov	r0, r3
    9334:	ebfffbc2 	bl	8244 <_ZN4CAUX12Set_RegisterEN3hal7AUX_RegEj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:17
}
    9338:	e51b3008 	ldr	r3, [fp, #-8]
    933c:	e1a00003 	mov	r0, r3
    9340:	e24bd004 	sub	sp, fp, #4
    9344:	e8bd8800 	pop	{fp, pc}

00009348 <_ZN5CUART15Set_Char_LengthE17NUART_Char_Length>:
_ZN5CUART15Set_Char_LengthE17NUART_Char_Length():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:20

void CUART::Set_Char_Length(NUART_Char_Length len)
{
    9348:	e92d4810 	push	{r4, fp, lr}
    934c:	e28db008 	add	fp, sp, #8
    9350:	e24dd00c 	sub	sp, sp, #12
    9354:	e50b0010 	str	r0, [fp, #-16]
    9358:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:21
    mAUX.Set_Register(hal::AUX_Reg::MU_LCR,
    935c:	e51b3010 	ldr	r3, [fp, #-16]
    9360:	e5934000 	ldr	r4, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:22
                      (mAUX.Get_Register(hal::AUX_Reg::MU_LCR) & 0xFFFFFFFE) | static_cast<unsigned int>(len));
    9364:	e51b3010 	ldr	r3, [fp, #-16]
    9368:	e5933000 	ldr	r3, [r3]
    936c:	e3a01013 	mov	r1, #19
    9370:	e1a00003 	mov	r0, r3
    9374:	ebfffbc3 	bl	8288 <_ZN4CAUX12Get_RegisterEN3hal7AUX_RegE>
    9378:	e1a03000 	mov	r3, r0
    937c:	e3c32001 	bic	r2, r3, #1
    9380:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:21
    mAUX.Set_Register(hal::AUX_Reg::MU_LCR,
    9384:	e1823003 	orr	r3, r2, r3
    9388:	e1a02003 	mov	r2, r3
    938c:	e3a01013 	mov	r1, #19
    9390:	e1a00004 	mov	r0, r4
    9394:	ebfffbaa 	bl	8244 <_ZN4CAUX12Set_RegisterEN3hal7AUX_RegEj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:23
}
    9398:	e320f000 	nop	{0}
    939c:	e24bd008 	sub	sp, fp, #8
    93a0:	e8bd8810 	pop	{r4, fp, pc}

000093a4 <_ZN5CUART13Set_Baud_RateE15NUART_Baud_Rate>:
_ZN5CUART13Set_Baud_RateE15NUART_Baud_Rate():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:26

void CUART::Set_Baud_Rate(NUART_Baud_Rate rate)
{
    93a4:	e92d4800 	push	{fp, lr}
    93a8:	e28db004 	add	fp, sp, #4
    93ac:	e24dd010 	sub	sp, sp, #16
    93b0:	e50b0010 	str	r0, [fp, #-16]
    93b4:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:27
    constexpr unsigned int Clock_Rate = 250000000; // taktovaci frekvence hlavniho jadra
    93b8:	e59f3070 	ldr	r3, [pc, #112]	; 9430 <_ZN5CUART13Set_Baud_RateE15NUART_Baud_Rate+0x8c>
    93bc:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:28
    const unsigned int val = ((Clock_Rate / static_cast<unsigned int>(rate)) / 8) - 1;
    93c0:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    93c4:	e1a01003 	mov	r1, r3
    93c8:	e59f0064 	ldr	r0, [pc, #100]	; 9434 <_ZN5CUART13Set_Baud_RateE15NUART_Baud_Rate+0x90>
    93cc:	eb0003fb 	bl	a3c0 <__udivsi3>
    93d0:	e1a03000 	mov	r3, r0
    93d4:	e2433001 	sub	r3, r3, #1
    93d8:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:30

    mAUX.Set_Register(hal::AUX_Reg::MU_CNTL, 0);
    93dc:	e51b3010 	ldr	r3, [fp, #-16]
    93e0:	e5933000 	ldr	r3, [r3]
    93e4:	e3a02000 	mov	r2, #0
    93e8:	e3a01018 	mov	r1, #24
    93ec:	e1a00003 	mov	r0, r3
    93f0:	ebfffb93 	bl	8244 <_ZN4CAUX12Set_RegisterEN3hal7AUX_RegEj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:32

    mAUX.Set_Register(hal::AUX_Reg::MU_BAUD, val);
    93f4:	e51b3010 	ldr	r3, [fp, #-16]
    93f8:	e5933000 	ldr	r3, [r3]
    93fc:	e51b200c 	ldr	r2, [fp, #-12]
    9400:	e3a0101a 	mov	r1, #26
    9404:	e1a00003 	mov	r0, r3
    9408:	ebfffb8d 	bl	8244 <_ZN4CAUX12Set_RegisterEN3hal7AUX_RegEj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:34

    mAUX.Set_Register(hal::AUX_Reg::MU_CNTL, 3);
    940c:	e51b3010 	ldr	r3, [fp, #-16]
    9410:	e5933000 	ldr	r3, [r3]
    9414:	e3a02003 	mov	r2, #3
    9418:	e3a01018 	mov	r1, #24
    941c:	e1a00003 	mov	r0, r3
    9420:	ebfffb87 	bl	8244 <_ZN4CAUX12Set_RegisterEN3hal7AUX_RegEj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:35
}
    9424:	e320f000 	nop	{0}
    9428:	e24bd004 	sub	sp, fp, #4
    942c:	e8bd8800 	pop	{fp, pc}
    9430:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}
    9434:	01dcd650 	bicseq	sp, ip, r0, asr r6

00009438 <_ZN5CUART5WriteEc>:
_ZN5CUART5WriteEc():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:38

void CUART::Write(char c)
{
    9438:	e92d4800 	push	{fp, lr}
    943c:	e28db004 	add	fp, sp, #4
    9440:	e24dd008 	sub	sp, sp, #8
    9444:	e50b0008 	str	r0, [fp, #-8]
    9448:	e1a03001 	mov	r3, r1
    944c:	e54b3009 	strb	r3, [fp, #-9]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:40
    // dokud ma status registr priznak "vystupni fronta plna", nelze prenaset dalsi bit
    while (!(mAUX.Get_Register(hal::AUX_Reg::MU_LSR) & (1 << 5)))
    9450:	e51b3008 	ldr	r3, [fp, #-8]
    9454:	e5933000 	ldr	r3, [r3]
    9458:	e3a01015 	mov	r1, #21
    945c:	e1a00003 	mov	r0, r3
    9460:	ebfffb88 	bl	8288 <_ZN4CAUX12Get_RegisterEN3hal7AUX_RegE>
    9464:	e1a03000 	mov	r3, r0
    9468:	e2033020 	and	r3, r3, #32
    946c:	e3530000 	cmp	r3, #0
    9470:	03a03001 	moveq	r3, #1
    9474:	13a03000 	movne	r3, #0
    9478:	e6ef3073 	uxtb	r3, r3
    947c:	e3530000 	cmp	r3, #0
    9480:	0a000000 	beq	9488 <_ZN5CUART5WriteEc+0x50>
    9484:	eafffff1 	b	9450 <_ZN5CUART5WriteEc+0x18>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:43
        ;

    mAUX.Set_Register(hal::AUX_Reg::MU_IO, c);
    9488:	e51b3008 	ldr	r3, [fp, #-8]
    948c:	e5933000 	ldr	r3, [r3]
    9490:	e55b2009 	ldrb	r2, [fp, #-9]
    9494:	e3a01010 	mov	r1, #16
    9498:	e1a00003 	mov	r0, r3
    949c:	ebfffb68 	bl	8244 <_ZN4CAUX12Set_RegisterEN3hal7AUX_RegEj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:44
}
    94a0:	e320f000 	nop	{0}
    94a4:	e24bd004 	sub	sp, fp, #4
    94a8:	e8bd8800 	pop	{fp, pc}

000094ac <_ZN5CUART5WriteEPKc>:
_ZN5CUART5WriteEPKc():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:47

void CUART::Write(const char* str)
{
    94ac:	e92d4800 	push	{fp, lr}
    94b0:	e28db004 	add	fp, sp, #4
    94b4:	e24dd010 	sub	sp, sp, #16
    94b8:	e50b0010 	str	r0, [fp, #-16]
    94bc:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:50
    int i;

    for (i = 0; str[i] != '\0'; i++)
    94c0:	e3a03000 	mov	r3, #0
    94c4:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:50 (discriminator 3)
    94c8:	e51b3008 	ldr	r3, [fp, #-8]
    94cc:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    94d0:	e0823003 	add	r3, r2, r3
    94d4:	e5d33000 	ldrb	r3, [r3]
    94d8:	e3530000 	cmp	r3, #0
    94dc:	0a00000a 	beq	950c <_ZN5CUART5WriteEPKc+0x60>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:51 (discriminator 2)
        Write(str[i]);
    94e0:	e51b3008 	ldr	r3, [fp, #-8]
    94e4:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    94e8:	e0823003 	add	r3, r2, r3
    94ec:	e5d33000 	ldrb	r3, [r3]
    94f0:	e1a01003 	mov	r1, r3
    94f4:	e51b0010 	ldr	r0, [fp, #-16]
    94f8:	ebffffce 	bl	9438 <_ZN5CUART5WriteEc>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:50 (discriminator 2)
    for (i = 0; str[i] != '\0'; i++)
    94fc:	e51b3008 	ldr	r3, [fp, #-8]
    9500:	e2833001 	add	r3, r3, #1
    9504:	e50b3008 	str	r3, [fp, #-8]
    9508:	eaffffee 	b	94c8 <_ZN5CUART5WriteEPKc+0x1c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:52
}
    950c:	e320f000 	nop	{0}
    9510:	e24bd004 	sub	sp, fp, #4
    9514:	e8bd8800 	pop	{fp, pc}

00009518 <_ZN5CUART5WriteEPKcj>:
_ZN5CUART5WriteEPKcj():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:55

void CUART::Write(const char* str, unsigned int len)
{
    9518:	e92d4800 	push	{fp, lr}
    951c:	e28db004 	add	fp, sp, #4
    9520:	e24dd018 	sub	sp, sp, #24
    9524:	e50b0010 	str	r0, [fp, #-16]
    9528:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    952c:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:58
    unsigned int i;

    for (i = 0; i < len; i++)
    9530:	e3a03000 	mov	r3, #0
    9534:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:58 (discriminator 3)
    9538:	e51b2008 	ldr	r2, [fp, #-8]
    953c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9540:	e1520003 	cmp	r2, r3
    9544:	2a00000a 	bcs	9574 <_ZN5CUART5WriteEPKcj+0x5c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:59 (discriminator 2)
        Write(str[i]);
    9548:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    954c:	e51b3008 	ldr	r3, [fp, #-8]
    9550:	e0823003 	add	r3, r2, r3
    9554:	e5d33000 	ldrb	r3, [r3]
    9558:	e1a01003 	mov	r1, r3
    955c:	e51b0010 	ldr	r0, [fp, #-16]
    9560:	ebffffb4 	bl	9438 <_ZN5CUART5WriteEc>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:58 (discriminator 2)
    for (i = 0; i < len; i++)
    9564:	e51b3008 	ldr	r3, [fp, #-8]
    9568:	e2833001 	add	r3, r3, #1
    956c:	e50b3008 	str	r3, [fp, #-8]
    9570:	eafffff0 	b	9538 <_ZN5CUART5WriteEPKcj+0x20>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:60
}
    9574:	e320f000 	nop	{0}
    9578:	e24bd004 	sub	sp, fp, #4
    957c:	e8bd8800 	pop	{fp, pc}

00009580 <_ZN5CUART5WriteEj>:
_ZN5CUART5WriteEj():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:63

void CUART::Write(unsigned int num)
{
    9580:	e92d4800 	push	{fp, lr}
    9584:	e28db004 	add	fp, sp, #4
    9588:	e24dd008 	sub	sp, sp, #8
    958c:	e50b0008 	str	r0, [fp, #-8]
    9590:	e50b100c 	str	r1, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:66
    static char buf[16];

    itoa(num, buf, 10);
    9594:	e3a0200a 	mov	r2, #10
    9598:	e59f101c 	ldr	r1, [pc, #28]	; 95bc <_ZN5CUART5WriteEj+0x3c>
    959c:	e51b000c 	ldr	r0, [fp, #-12]
    95a0:	eb000258 	bl	9f08 <_Z4itoajPcj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:67
    Write(buf);
    95a4:	e59f1010 	ldr	r1, [pc, #16]	; 95bc <_ZN5CUART5WriteEj+0x3c>
    95a8:	e51b0008 	ldr	r0, [fp, #-8]
    95ac:	ebffffbe 	bl	94ac <_ZN5CUART5WriteEPKc>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:68
}
    95b0:	e320f000 	nop	{0}
    95b4:	e24bd004 	sub	sp, fp, #4
    95b8:	e8bd8800 	pop	{fp, pc}
    95bc:	0000aa4c 	andeq	sl, r0, ip, asr #20

000095c0 <_ZN5CUART9Write_HexEj>:
_ZN5CUART9Write_HexEj():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:71

void CUART::Write_Hex(unsigned int num)
{
    95c0:	e92d4800 	push	{fp, lr}
    95c4:	e28db004 	add	fp, sp, #4
    95c8:	e24dd008 	sub	sp, sp, #8
    95cc:	e50b0008 	str	r0, [fp, #-8]
    95d0:	e50b100c 	str	r1, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:74
    static char buf[16];

    itoa(num, buf, 16);
    95d4:	e3a02010 	mov	r2, #16
    95d8:	e59f101c 	ldr	r1, [pc, #28]	; 95fc <_ZN5CUART9Write_HexEj+0x3c>
    95dc:	e51b000c 	ldr	r0, [fp, #-12]
    95e0:	eb000248 	bl	9f08 <_Z4itoajPcj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:75
    Write(buf);
    95e4:	e59f1010 	ldr	r1, [pc, #16]	; 95fc <_ZN5CUART9Write_HexEj+0x3c>
    95e8:	e51b0008 	ldr	r0, [fp, #-8]
    95ec:	ebffffae 	bl	94ac <_ZN5CUART5WriteEPKc>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:76
}
    95f0:	e320f000 	nop	{0}
    95f4:	e24bd004 	sub	sp, fp, #4
    95f8:	e8bd8800 	pop	{fp, pc}
    95fc:	0000aa5c 	andeq	sl, r0, ip, asr sl

00009600 <_ZN5CUART4ReadEPc>:
_ZN5CUART4ReadEPc():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:79

void CUART::Read(char* c)
{
    9600:	e92d4800 	push	{fp, lr}
    9604:	e28db004 	add	fp, sp, #4
    9608:	e24dd008 	sub	sp, sp, #8
    960c:	e50b0008 	str	r0, [fp, #-8]
    9610:	e50b100c 	str	r1, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:80
    while (!(mAUX.Get_Register(hal::AUX_Reg::MU_LSR) & 1)) {
    9614:	e51b3008 	ldr	r3, [fp, #-8]
    9618:	e5933000 	ldr	r3, [r3]
    961c:	e3a01015 	mov	r1, #21
    9620:	e1a00003 	mov	r0, r3
    9624:	ebfffb17 	bl	8288 <_ZN4CAUX12Get_RegisterEN3hal7AUX_RegE>
    9628:	e1a03000 	mov	r3, r0
    962c:	e2033001 	and	r3, r3, #1
    9630:	e3530000 	cmp	r3, #0
    9634:	03a03001 	moveq	r3, #1
    9638:	13a03000 	movne	r3, #0
    963c:	e6ef3073 	uxtb	r3, r3
    9640:	e3530000 	cmp	r3, #0
    9644:	0a000000 	beq	964c <_ZN5CUART4ReadEPc+0x4c>
    9648:	eafffff1 	b	9614 <_ZN5CUART4ReadEPc+0x14>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:84
        ;
    }
    
    *c = mAUX.Get_Register(hal::AUX_Reg::MU_IO) & 0xFF;
    964c:	e51b3008 	ldr	r3, [fp, #-8]
    9650:	e5933000 	ldr	r3, [r3]
    9654:	e3a01010 	mov	r1, #16
    9658:	e1a00003 	mov	r0, r3
    965c:	ebfffb09 	bl	8288 <_ZN4CAUX12Get_RegisterEN3hal7AUX_RegE>
    9660:	e1a03000 	mov	r3, r0
    9664:	e6ef2073 	uxtb	r2, r3
    9668:	e51b300c 	ldr	r3, [fp, #-12]
    966c:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:85
}
    9670:	e320f000 	nop	{0}
    9674:	e24bd004 	sub	sp, fp, #4
    9678:	e8bd8800 	pop	{fp, pc}

0000967c <_ZN5CUART18Enable_Receive_IntEv>:
_ZN5CUART18Enable_Receive_IntEv():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:88

void CUART::Enable_Receive_Int()
{
    967c:	e92d4810 	push	{r4, fp, lr}
    9680:	e28db008 	add	fp, sp, #8
    9684:	e24dd00c 	sub	sp, sp, #12
    9688:	e50b0010 	str	r0, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:89
    mAUX.Set_Register(hal::AUX_Reg::MU_IER, mAUX.Get_Register(hal::AUX_Reg::MU_IER) | (0b1U << 1U));
    968c:	e51b3010 	ldr	r3, [fp, #-16]
    9690:	e5934000 	ldr	r4, [r3]
    9694:	e51b3010 	ldr	r3, [fp, #-16]
    9698:	e5933000 	ldr	r3, [r3]
    969c:	e3a01011 	mov	r1, #17
    96a0:	e1a00003 	mov	r0, r3
    96a4:	ebfffaf7 	bl	8288 <_ZN4CAUX12Get_RegisterEN3hal7AUX_RegE>
    96a8:	e1a03000 	mov	r3, r0
    96ac:	e3833002 	orr	r3, r3, #2
    96b0:	e1a02003 	mov	r2, r3
    96b4:	e3a01011 	mov	r1, #17
    96b8:	e1a00004 	mov	r0, r4
    96bc:	ebfffae0 	bl	8244 <_ZN4CAUX12Set_RegisterEN3hal7AUX_RegEj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:90
}
    96c0:	e320f000 	nop	{0}
    96c4:	e24bd008 	sub	sp, fp, #8
    96c8:	e8bd8810 	pop	{r4, fp, pc}

000096cc <_ZN5CUART19Enable_Transmit_IntEv>:
_ZN5CUART19Enable_Transmit_IntEv():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:93

void CUART::Enable_Transmit_Int()
{
    96cc:	e92d4810 	push	{r4, fp, lr}
    96d0:	e28db008 	add	fp, sp, #8
    96d4:	e24dd00c 	sub	sp, sp, #12
    96d8:	e50b0010 	str	r0, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:94
    mAUX.Set_Register(hal::AUX_Reg::MU_IER, mAUX.Get_Register(hal::AUX_Reg::MU_IER) | (0b1U << 0U));
    96dc:	e51b3010 	ldr	r3, [fp, #-16]
    96e0:	e5934000 	ldr	r4, [r3]
    96e4:	e51b3010 	ldr	r3, [fp, #-16]
    96e8:	e5933000 	ldr	r3, [r3]
    96ec:	e3a01011 	mov	r1, #17
    96f0:	e1a00003 	mov	r0, r3
    96f4:	ebfffae3 	bl	8288 <_ZN4CAUX12Get_RegisterEN3hal7AUX_RegE>
    96f8:	e1a03000 	mov	r3, r0
    96fc:	e3833001 	orr	r3, r3, #1
    9700:	e1a02003 	mov	r2, r3
    9704:	e3a01011 	mov	r1, #17
    9708:	e1a00004 	mov	r0, r4
    970c:	ebfffacc 	bl	8244 <_ZN4CAUX12Set_RegisterEN3hal7AUX_RegEj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:95
    9710:	e320f000 	nop	{0}
    9714:	e24bd008 	sub	sp, fp, #8
    9718:	e8bd8810 	pop	{r4, fp, pc}

0000971c <_Z41__static_initialization_and_destruction_0ii>:
_Z41__static_initialization_and_destruction_0ii():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:95
    971c:	e92d4800 	push	{fp, lr}
    9720:	e28db004 	add	fp, sp, #4
    9724:	e24dd008 	sub	sp, sp, #8
    9728:	e50b0008 	str	r0, [fp, #-8]
    972c:	e50b100c 	str	r1, [fp, #-12]
    9730:	e51b3008 	ldr	r3, [fp, #-8]
    9734:	e3530001 	cmp	r3, #1
    9738:	1a000006 	bne	9758 <_Z41__static_initialization_and_destruction_0ii+0x3c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:95 (discriminator 1)
    973c:	e51b300c 	ldr	r3, [fp, #-12]
    9740:	e59f201c 	ldr	r2, [pc, #28]	; 9764 <_Z41__static_initialization_and_destruction_0ii+0x48>
    9744:	e1530002 	cmp	r3, r2
    9748:	1a000002 	bne	9758 <_Z41__static_initialization_and_destruction_0ii+0x3c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:6
CUART sUART0(sAUX);
    974c:	e59f1014 	ldr	r1, [pc, #20]	; 9768 <_Z41__static_initialization_and_destruction_0ii+0x4c>
    9750:	e59f0014 	ldr	r0, [pc, #20]	; 976c <_Z41__static_initialization_and_destruction_0ii+0x50>
    9754:	ebfffed2 	bl	92a4 <_ZN5CUARTC1ER4CAUX>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:95
    9758:	e320f000 	nop	{0}
    975c:	e24bd004 	sub	sp, fp, #4
    9760:	e8bd8800 	pop	{fp, pc}
    9764:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>
    9768:	0000aa18 	andeq	sl, r0, r8, lsl sl
    976c:	0000aa48 	andeq	sl, r0, r8, asr #20

00009770 <_GLOBAL__sub_I_sUART0>:
_GLOBAL__sub_I_sUART0():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:95
    9770:	e92d4800 	push	{fp, lr}
    9774:	e28db004 	add	fp, sp, #4
    9778:	e59f1008 	ldr	r1, [pc, #8]	; 9788 <_GLOBAL__sub_I_sUART0+0x18>
    977c:	e3a00001 	mov	r0, #1
    9780:	ebffffe5 	bl	971c <_Z41__static_initialization_and_destruction_0ii>
    9784:	e8bd8800 	pop	{fp, pc}
    9788:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>

0000978c <_Z13Guessing_Gamec>:
_Z13Guessing_Gamec():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:13
volatile unsigned int max_num = 100;
volatile unsigned int min_num = 1;
volatile unsigned int middle;

void Guessing_Game(char c)
{
    978c:	e92d4800 	push	{fp, lr}
    9790:	e28db004 	add	fp, sp, #4
    9794:	e24dd010 	sub	sp, sp, #16
    9798:	e1a03000 	mov	r3, r0
    979c:	e54b300d 	strb	r3, [fp, #-13]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:16
    bool greater;

    switch (game_state)
    97a0:	e59f32e4 	ldr	r3, [pc, #740]	; 9a8c <_Z13Guessing_Gamec+0x300>
    97a4:	e5933000 	ldr	r3, [r3]
    97a8:	e3530003 	cmp	r3, #3
    97ac:	979ff103 	ldrls	pc, [pc, r3, lsl #2]
    97b0:	ea0000b1 	b	9a7c <_Z13Guessing_Gamec+0x2f0>
    97b4:	000097c4 	andeq	r9, r0, r4, asr #15
    97b8:	00009814 	andeq	r9, r0, r4, lsl r8
    97bc:	0000987c 	andeq	r9, r0, ip, ror r8
    97c0:	000099c8 	andeq	r9, r0, r8, asr #19
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:19
    {
        case 0:
            if (c == 'y' || c == 'Y')
    97c4:	e55b300d 	ldrb	r3, [fp, #-13]
    97c8:	e3530079 	cmp	r3, #121	; 0x79
    97cc:	0a000002 	beq	97dc <_Z13Guessing_Gamec+0x50>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:19 (discriminator 1)
    97d0:	e55b300d 	ldrb	r3, [fp, #-13]
    97d4:	e3530059 	cmp	r3, #89	; 0x59
    97d8:	1a000006 	bne	97f8 <_Z13Guessing_Gamec+0x6c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:21
            {
                game_state = 1;
    97dc:	e59f32a8 	ldr	r3, [pc, #680]	; 9a8c <_Z13Guessing_Gamec+0x300>
    97e0:	e3a02001 	mov	r2, #1
    97e4:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:22
                sUART0.Write("Awesome! Let's get started then...\n\r");
    97e8:	e59f12a0 	ldr	r1, [pc, #672]	; 9a90 <_Z13Guessing_Gamec+0x304>
    97ec:	e59f02a0 	ldr	r0, [pc, #672]	; 9a94 <_Z13Guessing_Gamec+0x308>
    97f0:	ebffff2d 	bl	94ac <_ZN5CUART5WriteEPKc>
    97f4:	ea000006 	b	9814 <_Z13Guessing_Gamec+0x88>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:26
            }
            else
            {
                sUART0.Write("Don't worry, we can always play the game next time! Have a good one :)");
    97f8:	e59f1298 	ldr	r1, [pc, #664]	; 9a98 <_Z13Guessing_Gamec+0x30c>
    97fc:	e59f0290 	ldr	r0, [pc, #656]	; 9a94 <_Z13Guessing_Gamec+0x308>
    9800:	ebffff29 	bl	94ac <_ZN5CUART5WriteEPKc>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:27
                game_state = 0xFFFFFFFFU;
    9804:	e59f3280 	ldr	r3, [pc, #640]	; 9a8c <_Z13Guessing_Gamec+0x300>
    9808:	e3e02000 	mvn	r2, #0
    980c:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:28
                break;
    9810:	ea00009a 	b	9a80 <_Z13Guessing_Gamec+0x2f4>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:32
            }

        case 1:
            sUART0.Write("Is your number greater than ");
    9814:	e59f1280 	ldr	r1, [pc, #640]	; 9a9c <_Z13Guessing_Gamec+0x310>
    9818:	e59f0274 	ldr	r0, [pc, #628]	; 9a94 <_Z13Guessing_Gamec+0x308>
    981c:	ebffff22 	bl	94ac <_ZN5CUART5WriteEPKc>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:33
            middle = min_num + (max_num - min_num) / 2;
    9820:	e59f3278 	ldr	r3, [pc, #632]	; 9aa0 <_Z13Guessing_Gamec+0x314>
    9824:	e5932000 	ldr	r2, [r3]
    9828:	e59f3274 	ldr	r3, [pc, #628]	; 9aa4 <_Z13Guessing_Gamec+0x318>
    982c:	e5933000 	ldr	r3, [r3]
    9830:	e0423003 	sub	r3, r2, r3
    9834:	e1a020a3 	lsr	r2, r3, #1
    9838:	e59f3264 	ldr	r3, [pc, #612]	; 9aa4 <_Z13Guessing_Gamec+0x318>
    983c:	e5933000 	ldr	r3, [r3]
    9840:	e0823003 	add	r3, r2, r3
    9844:	e59f225c 	ldr	r2, [pc, #604]	; 9aa8 <_Z13Guessing_Gamec+0x31c>
    9848:	e5823000 	str	r3, [r2]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:34
            sUART0.Write(middle);
    984c:	e59f3254 	ldr	r3, [pc, #596]	; 9aa8 <_Z13Guessing_Gamec+0x31c>
    9850:	e5933000 	ldr	r3, [r3]
    9854:	e1a01003 	mov	r1, r3
    9858:	e59f0234 	ldr	r0, [pc, #564]	; 9a94 <_Z13Guessing_Gamec+0x308>
    985c:	ebffff47 	bl	9580 <_ZN5CUART5WriteEj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:35
            sUART0.Write("? [y/n]: ");
    9860:	e59f1244 	ldr	r1, [pc, #580]	; 9aac <_Z13Guessing_Gamec+0x320>
    9864:	e59f0228 	ldr	r0, [pc, #552]	; 9a94 <_Z13Guessing_Gamec+0x308>
    9868:	ebffff0f 	bl	94ac <_ZN5CUART5WriteEPKc>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:36
            game_state = 2;
    986c:	e59f3218 	ldr	r3, [pc, #536]	; 9a8c <_Z13Guessing_Gamec+0x300>
    9870:	e3a02002 	mov	r2, #2
    9874:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:37
            break;
    9878:	ea000080 	b	9a80 <_Z13Guessing_Gamec+0x2f4>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:40

        case 2:
            if (c == 'y' || c == 'Y')
    987c:	e55b300d 	ldrb	r3, [fp, #-13]
    9880:	e3530079 	cmp	r3, #121	; 0x79
    9884:	0a000002 	beq	9894 <_Z13Guessing_Gamec+0x108>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:40 (discriminator 1)
    9888:	e55b300d 	ldrb	r3, [fp, #-13]
    988c:	e3530059 	cmp	r3, #89	; 0x59
    9890:	1a00000a 	bne	98c0 <_Z13Guessing_Gamec+0x134>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:42
            {
                min_num += middle + 1;
    9894:	e59f320c 	ldr	r3, [pc, #524]	; 9aa8 <_Z13Guessing_Gamec+0x31c>
    9898:	e5933000 	ldr	r3, [r3]
    989c:	e2832001 	add	r2, r3, #1
    98a0:	e59f31fc 	ldr	r3, [pc, #508]	; 9aa4 <_Z13Guessing_Gamec+0x318>
    98a4:	e5933000 	ldr	r3, [r3]
    98a8:	e0823003 	add	r3, r2, r3
    98ac:	e59f21f0 	ldr	r2, [pc, #496]	; 9aa4 <_Z13Guessing_Gamec+0x318>
    98b0:	e5823000 	str	r3, [r2]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:43
                greater = true;
    98b4:	e3a03001 	mov	r3, #1
    98b8:	e54b3005 	strb	r3, [fp, #-5]
    98bc:	ea000006 	b	98dc <_Z13Guessing_Gamec+0x150>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:47
            }
            else
            {
                max_num = middle - 1;
    98c0:	e59f31e0 	ldr	r3, [pc, #480]	; 9aa8 <_Z13Guessing_Gamec+0x31c>
    98c4:	e5933000 	ldr	r3, [r3]
    98c8:	e2433001 	sub	r3, r3, #1
    98cc:	e59f21cc 	ldr	r2, [pc, #460]	; 9aa0 <_Z13Guessing_Gamec+0x314>
    98d0:	e5823000 	str	r3, [r2]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:48
                greater = false;
    98d4:	e3a03000 	mov	r3, #0
    98d8:	e54b3005 	strb	r3, [fp, #-5]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:51
            }

            if (min_num > max_num)
    98dc:	e59f31c0 	ldr	r3, [pc, #448]	; 9aa4 <_Z13Guessing_Gamec+0x318>
    98e0:	e5932000 	ldr	r2, [r3]
    98e4:	e59f31b4 	ldr	r3, [pc, #436]	; 9aa0 <_Z13Guessing_Gamec+0x314>
    98e8:	e5933000 	ldr	r3, [r3]
    98ec:	e1520003 	cmp	r2, r3
    98f0:	83a03001 	movhi	r3, #1
    98f4:	93a03000 	movls	r3, #0
    98f8:	e6ef3073 	uxtb	r3, r3
    98fc:	e3530000 	cmp	r3, #0
    9900:	0a000019 	beq	996c <_Z13Guessing_Gamec+0x1e0>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:53
            {
                sUART0.Write("The number you're thinking of must be ");
    9904:	e59f11a4 	ldr	r1, [pc, #420]	; 9ab0 <_Z13Guessing_Gamec+0x324>
    9908:	e59f0184 	ldr	r0, [pc, #388]	; 9a94 <_Z13Guessing_Gamec+0x308>
    990c:	ebfffee6 	bl	94ac <_ZN5CUART5WriteEPKc>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:54
                sUART0.Write(greater ? (middle + 1) : (middle - 1));
    9910:	e55b3005 	ldrb	r3, [fp, #-5]
    9914:	e3530000 	cmp	r3, #0
    9918:	0a000003 	beq	992c <_Z13Guessing_Gamec+0x1a0>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:54 (discriminator 1)
    991c:	e59f3184 	ldr	r3, [pc, #388]	; 9aa8 <_Z13Guessing_Gamec+0x31c>
    9920:	e5933000 	ldr	r3, [r3]
    9924:	e2833001 	add	r3, r3, #1
    9928:	ea000002 	b	9938 <_Z13Guessing_Gamec+0x1ac>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:54 (discriminator 2)
    992c:	e59f3174 	ldr	r3, [pc, #372]	; 9aa8 <_Z13Guessing_Gamec+0x31c>
    9930:	e5933000 	ldr	r3, [r3]
    9934:	e2433001 	sub	r3, r3, #1
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:54 (discriminator 4)
    9938:	e1a01003 	mov	r1, r3
    993c:	e59f0150 	ldr	r0, [pc, #336]	; 9a94 <_Z13Guessing_Gamec+0x308>
    9940:	ebffff0e 	bl	9580 <_ZN5CUART5WriteEj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:55 (discriminator 4)
                sUART0.Write("!\n\r");
    9944:	e59f1168 	ldr	r1, [pc, #360]	; 9ab4 <_Z13Guessing_Gamec+0x328>
    9948:	e59f0144 	ldr	r0, [pc, #324]	; 9a94 <_Z13Guessing_Gamec+0x308>
    994c:	ebfffed6 	bl	94ac <_ZN5CUART5WriteEPKc>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:56 (discriminator 4)
                sUART0.Write("Do you wanna play again? [y/n]: ");
    9950:	e59f1160 	ldr	r1, [pc, #352]	; 9ab8 <_Z13Guessing_Gamec+0x32c>
    9954:	e59f0138 	ldr	r0, [pc, #312]	; 9a94 <_Z13Guessing_Gamec+0x308>
    9958:	ebfffed3 	bl	94ac <_ZN5CUART5WriteEPKc>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:57 (discriminator 4)
                game_state = 3;
    995c:	e59f3128 	ldr	r3, [pc, #296]	; 9a8c <_Z13Guessing_Gamec+0x300>
    9960:	e3a02003 	mov	r2, #3
    9964:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:58 (discriminator 4)
                break;
    9968:	ea000044 	b	9a80 <_Z13Guessing_Gamec+0x2f4>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:61
            }

            middle = min_num + (max_num - min_num) / 2;
    996c:	e59f312c 	ldr	r3, [pc, #300]	; 9aa0 <_Z13Guessing_Gamec+0x314>
    9970:	e5932000 	ldr	r2, [r3]
    9974:	e59f3128 	ldr	r3, [pc, #296]	; 9aa4 <_Z13Guessing_Gamec+0x318>
    9978:	e5933000 	ldr	r3, [r3]
    997c:	e0423003 	sub	r3, r2, r3
    9980:	e1a020a3 	lsr	r2, r3, #1
    9984:	e59f3118 	ldr	r3, [pc, #280]	; 9aa4 <_Z13Guessing_Gamec+0x318>
    9988:	e5933000 	ldr	r3, [r3]
    998c:	e0823003 	add	r3, r2, r3
    9990:	e59f2110 	ldr	r2, [pc, #272]	; 9aa8 <_Z13Guessing_Gamec+0x31c>
    9994:	e5823000 	str	r3, [r2]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:62
            sUART0.Write("Is your number greater than ");
    9998:	e59f10fc 	ldr	r1, [pc, #252]	; 9a9c <_Z13Guessing_Gamec+0x310>
    999c:	e59f00f0 	ldr	r0, [pc, #240]	; 9a94 <_Z13Guessing_Gamec+0x308>
    99a0:	ebfffec1 	bl	94ac <_ZN5CUART5WriteEPKc>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:63
            sUART0.Write(middle);
    99a4:	e59f30fc 	ldr	r3, [pc, #252]	; 9aa8 <_Z13Guessing_Gamec+0x31c>
    99a8:	e5933000 	ldr	r3, [r3]
    99ac:	e1a01003 	mov	r1, r3
    99b0:	e59f00dc 	ldr	r0, [pc, #220]	; 9a94 <_Z13Guessing_Gamec+0x308>
    99b4:	ebfffef1 	bl	9580 <_ZN5CUART5WriteEj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:64
            sUART0.Write("? [y/n]: ");
    99b8:	e59f10ec 	ldr	r1, [pc, #236]	; 9aac <_Z13Guessing_Gamec+0x320>
    99bc:	e59f00d0 	ldr	r0, [pc, #208]	; 9a94 <_Z13Guessing_Gamec+0x308>
    99c0:	ebfffeb9 	bl	94ac <_ZN5CUART5WriteEPKc>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:66

            break;
    99c4:	ea00002d 	b	9a80 <_Z13Guessing_Gamec+0x2f4>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:69

        case 3:
            if (c == 'y' || c == 'Y')
    99c8:	e55b300d 	ldrb	r3, [fp, #-13]
    99cc:	e3530079 	cmp	r3, #121	; 0x79
    99d0:	0a000002 	beq	99e0 <_Z13Guessing_Gamec+0x254>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:69 (discriminator 1)
    99d4:	e55b300d 	ldrb	r3, [fp, #-13]
    99d8:	e3530059 	cmp	r3, #89	; 0x59
    99dc:	1a00001f 	bne	9a60 <_Z13Guessing_Gamec+0x2d4>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:71
            {
                min_num = 1;
    99e0:	e59f30bc 	ldr	r3, [pc, #188]	; 9aa4 <_Z13Guessing_Gamec+0x318>
    99e4:	e3a02001 	mov	r2, #1
    99e8:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:72
                max_num = 100;
    99ec:	e59f30ac 	ldr	r3, [pc, #172]	; 9aa0 <_Z13Guessing_Gamec+0x314>
    99f0:	e3a02064 	mov	r2, #100	; 0x64
    99f4:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:74
                
                sUART0.Write("Is your number greater than ");
    99f8:	e59f109c 	ldr	r1, [pc, #156]	; 9a9c <_Z13Guessing_Gamec+0x310>
    99fc:	e59f0090 	ldr	r0, [pc, #144]	; 9a94 <_Z13Guessing_Gamec+0x308>
    9a00:	ebfffea9 	bl	94ac <_ZN5CUART5WriteEPKc>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:75
                middle = min_num + (max_num - min_num) / 2;
    9a04:	e59f3094 	ldr	r3, [pc, #148]	; 9aa0 <_Z13Guessing_Gamec+0x314>
    9a08:	e5932000 	ldr	r2, [r3]
    9a0c:	e59f3090 	ldr	r3, [pc, #144]	; 9aa4 <_Z13Guessing_Gamec+0x318>
    9a10:	e5933000 	ldr	r3, [r3]
    9a14:	e0423003 	sub	r3, r2, r3
    9a18:	e1a020a3 	lsr	r2, r3, #1
    9a1c:	e59f3080 	ldr	r3, [pc, #128]	; 9aa4 <_Z13Guessing_Gamec+0x318>
    9a20:	e5933000 	ldr	r3, [r3]
    9a24:	e0823003 	add	r3, r2, r3
    9a28:	e59f2078 	ldr	r2, [pc, #120]	; 9aa8 <_Z13Guessing_Gamec+0x31c>
    9a2c:	e5823000 	str	r3, [r2]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:76
                sUART0.Write(middle);
    9a30:	e59f3070 	ldr	r3, [pc, #112]	; 9aa8 <_Z13Guessing_Gamec+0x31c>
    9a34:	e5933000 	ldr	r3, [r3]
    9a38:	e1a01003 	mov	r1, r3
    9a3c:	e59f0050 	ldr	r0, [pc, #80]	; 9a94 <_Z13Guessing_Gamec+0x308>
    9a40:	ebfffece 	bl	9580 <_ZN5CUART5WriteEj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:77
                sUART0.Write("? [y/n]: ");
    9a44:	e59f1060 	ldr	r1, [pc, #96]	; 9aac <_Z13Guessing_Gamec+0x320>
    9a48:	e59f0044 	ldr	r0, [pc, #68]	; 9a94 <_Z13Guessing_Gamec+0x308>
    9a4c:	ebfffe96 	bl	94ac <_ZN5CUART5WriteEPKc>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:78
                game_state = 2;
    9a50:	e59f3034 	ldr	r3, [pc, #52]	; 9a8c <_Z13Guessing_Gamec+0x300>
    9a54:	e3a02002 	mov	r2, #2
    9a58:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:85
            else
            {
                sUART0.Write("See you next time!\n\r");
                game_state = 0xFFFFFFFFU;
            }
            break;
    9a5c:	ea000007 	b	9a80 <_Z13Guessing_Gamec+0x2f4>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:82
                sUART0.Write("See you next time!\n\r");
    9a60:	e59f1054 	ldr	r1, [pc, #84]	; 9abc <_Z13Guessing_Gamec+0x330>
    9a64:	e59f0028 	ldr	r0, [pc, #40]	; 9a94 <_Z13Guessing_Gamec+0x308>
    9a68:	ebfffe8f 	bl	94ac <_ZN5CUART5WriteEPKc>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:83
                game_state = 0xFFFFFFFFU;
    9a6c:	e59f3018 	ldr	r3, [pc, #24]	; 9a8c <_Z13Guessing_Gamec+0x300>
    9a70:	e3e02000 	mvn	r2, #0
    9a74:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:85
            break;
    9a78:	ea000000 	b	9a80 <_Z13Guessing_Gamec+0x2f4>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:88

        default:
            break;
    9a7c:	e320f000 	nop	{0}
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:90
    }
}
    9a80:	e320f000 	nop	{0}
    9a84:	e24bd004 	sub	sp, fp, #4
    9a88:	e8bd8800 	pop	{fp, pc}
    9a8c:	0000aa6c 	andeq	sl, r0, ip, ror #20
    9a90:	0000a7d8 	ldrdeq	sl, [r0], -r8
    9a94:	0000aa48 	andeq	sl, r0, r8, asr #20
    9a98:	0000a800 	andeq	sl, r0, r0, lsl #16
    9a9c:	0000a848 	andeq	sl, r0, r8, asr #16
    9aa0:	0000aa10 	andeq	sl, r0, r0, lsl sl
    9aa4:	0000aa14 	andeq	sl, r0, r4, lsl sl
    9aa8:	0000aa70 	andeq	sl, r0, r0, ror sl
    9aac:	0000a868 	andeq	sl, r0, r8, ror #16
    9ab0:	0000a874 	andeq	sl, r0, r4, ror r8
    9ab4:	0000a89c 	muleq	r0, ip, r8
    9ab8:	0000a8a0 	andeq	sl, r0, r0, lsr #17
    9abc:	0000a8c4 	andeq	sl, r0, r4, asr #17

00009ac0 <software_interrupt_handler>:
software_interrupt_handler():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:93

extern "C" void __attribute__((interrupt("SWI"))) software_interrupt_handler()
{
    9ac0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9ac4:	e28db000 	add	fp, sp, #0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:94
}
    9ac8:	e320f000 	nop	{0}
    9acc:	e28bd000 	add	sp, fp, #0
    9ad0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9ad4:	e1b0f00e 	movs	pc, lr

00009ad8 <irq_handler>:
irq_handler():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:97

extern "C" void __attribute__((interrupt("IRQ"))) irq_handler()
{
    9ad8:	e24ee004 	sub	lr, lr, #4
    9adc:	e92d580f 	push	{r0, r1, r2, r3, fp, ip, lr}
    9ae0:	e28db018 	add	fp, sp, #24
    9ae4:	e24dd00c 	sub	sp, sp, #12
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:100
    char c;
    
    sUART0.Read(&c);
    9ae8:	e24b301d 	sub	r3, fp, #29
    9aec:	e1a01003 	mov	r1, r3
    9af0:	e59f0018 	ldr	r0, [pc, #24]	; 9b10 <irq_handler+0x38>
    9af4:	ebfffec1 	bl	9600 <_ZN5CUART4ReadEPc>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:101
    Guessing_Game(c);
    9af8:	e55b301d 	ldrb	r3, [fp, #-29]	; 0xffffffe3
    9afc:	e1a00003 	mov	r0, r3
    9b00:	ebffff21 	bl	978c <_Z13Guessing_Gamec>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:102
}
    9b04:	e320f000 	nop	{0}
    9b08:	e24bd018 	sub	sp, fp, #24
    9b0c:	e8fd980f 	ldm	sp!, {r0, r1, r2, r3, fp, ip, pc}^
    9b10:	0000aa48 	andeq	sl, r0, r8, asr #20

00009b14 <fast_interrupt_handler>:
fast_interrupt_handler():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:105

extern "C" void __attribute__((interrupt("FIQ"))) fast_interrupt_handler()
{
    9b14:	e24db004 	sub	fp, sp, #4
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:106
}
    9b18:	e320f000 	nop	{0}
    9b1c:	e28bd004 	add	sp, fp, #4
    9b20:	e25ef004 	subs	pc, lr, #4

00009b24 <_ZN21CInterrupt_ControllerC1Em>:
_ZN21CInterrupt_ControllerC2Em():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:110

CInterrupt_Controller sInterruptCtl(hal::Interrupt_Controller_Base);

CInterrupt_Controller::CInterrupt_Controller(unsigned long base)
    9b24:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9b28:	e28db000 	add	fp, sp, #0
    9b2c:	e24dd00c 	sub	sp, sp, #12
    9b30:	e50b0008 	str	r0, [fp, #-8]
    9b34:	e50b100c 	str	r1, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:111
: mInterrupt_Regs(reinterpret_cast<unsigned int*>(base))
    9b38:	e51b200c 	ldr	r2, [fp, #-12]
    9b3c:	e51b3008 	ldr	r3, [fp, #-8]
    9b40:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:113
{
}
    9b44:	e51b3008 	ldr	r3, [fp, #-8]
    9b48:	e1a00003 	mov	r0, r3
    9b4c:	e28bd000 	add	sp, fp, #0
    9b50:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9b54:	e12fff1e 	bx	lr

00009b58 <_ZN21CInterrupt_Controller4RegsEN3hal24Interrupt_Controller_RegE>:
_ZN21CInterrupt_Controller4RegsEN3hal24Interrupt_Controller_RegE():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:116

volatile unsigned int& CInterrupt_Controller::Regs(hal::Interrupt_Controller_Reg reg)
{
    9b58:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9b5c:	e28db000 	add	fp, sp, #0
    9b60:	e24dd00c 	sub	sp, sp, #12
    9b64:	e50b0008 	str	r0, [fp, #-8]
    9b68:	e50b100c 	str	r1, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:117
    return mInterrupt_Regs[static_cast<unsigned int>(reg)];
    9b6c:	e51b3008 	ldr	r3, [fp, #-8]
    9b70:	e5932000 	ldr	r2, [r3]
    9b74:	e51b300c 	ldr	r3, [fp, #-12]
    9b78:	e1a03103 	lsl	r3, r3, #2
    9b7c:	e0823003 	add	r3, r2, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:118
}
    9b80:	e1a00003 	mov	r0, r3
    9b84:	e28bd000 	add	sp, fp, #0
    9b88:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9b8c:	e12fff1e 	bx	lr

00009b90 <_ZN21CInterrupt_Controller16Enable_Basic_IRQEN3hal16IRQ_Basic_SourceE>:
_ZN21CInterrupt_Controller16Enable_Basic_IRQEN3hal16IRQ_Basic_SourceE():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:121

void CInterrupt_Controller::Enable_Basic_IRQ(hal::IRQ_Basic_Source source_idx)
{
    9b90:	e92d4810 	push	{r4, fp, lr}
    9b94:	e28db008 	add	fp, sp, #8
    9b98:	e24dd00c 	sub	sp, sp, #12
    9b9c:	e50b0010 	str	r0, [fp, #-16]
    9ba0:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:122
    Regs(hal::Interrupt_Controller_Reg::IRQ_Basic_Enable) = (1 << static_cast<unsigned int>(source_idx));
    9ba4:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9ba8:	e3a02001 	mov	r2, #1
    9bac:	e1a04312 	lsl	r4, r2, r3
    9bb0:	e3a01006 	mov	r1, #6
    9bb4:	e51b0010 	ldr	r0, [fp, #-16]
    9bb8:	ebffffe6 	bl	9b58 <_ZN21CInterrupt_Controller4RegsEN3hal24Interrupt_Controller_RegE>
    9bbc:	e1a03000 	mov	r3, r0
    9bc0:	e1a02004 	mov	r2, r4
    9bc4:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:123
}
    9bc8:	e320f000 	nop	{0}
    9bcc:	e24bd008 	sub	sp, fp, #8
    9bd0:	e8bd8810 	pop	{r4, fp, pc}

00009bd4 <_ZN21CInterrupt_Controller17Disable_Basic_IRQEN3hal16IRQ_Basic_SourceE>:
_ZN21CInterrupt_Controller17Disable_Basic_IRQEN3hal16IRQ_Basic_SourceE():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:126

void CInterrupt_Controller::Disable_Basic_IRQ(hal::IRQ_Basic_Source source_idx)
{
    9bd4:	e92d4810 	push	{r4, fp, lr}
    9bd8:	e28db008 	add	fp, sp, #8
    9bdc:	e24dd00c 	sub	sp, sp, #12
    9be0:	e50b0010 	str	r0, [fp, #-16]
    9be4:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:127
    Regs(hal::Interrupt_Controller_Reg::IRQ_Basic_Disable) = (1 << static_cast<unsigned int>(source_idx));
    9be8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9bec:	e3a02001 	mov	r2, #1
    9bf0:	e1a04312 	lsl	r4, r2, r3
    9bf4:	e3a01009 	mov	r1, #9
    9bf8:	e51b0010 	ldr	r0, [fp, #-16]
    9bfc:	ebffffd5 	bl	9b58 <_ZN21CInterrupt_Controller4RegsEN3hal24Interrupt_Controller_RegE>
    9c00:	e1a03000 	mov	r3, r0
    9c04:	e1a02004 	mov	r2, r4
    9c08:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:128
}
    9c0c:	e320f000 	nop	{0}
    9c10:	e24bd008 	sub	sp, fp, #8
    9c14:	e8bd8810 	pop	{r4, fp, pc}

00009c18 <_ZN21CInterrupt_Controller10Enable_IRQEN3hal10IRQ_SourceE>:
_ZN21CInterrupt_Controller10Enable_IRQEN3hal10IRQ_SourceE():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:131

void CInterrupt_Controller::Enable_IRQ(hal::IRQ_Source source_idx)
{
    9c18:	e92d4810 	push	{r4, fp, lr}
    9c1c:	e28db008 	add	fp, sp, #8
    9c20:	e24dd014 	sub	sp, sp, #20
    9c24:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    9c28:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:132
    const unsigned int idx_base = static_cast<unsigned int>(source_idx);
    9c2c:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    9c30:	e50b3010 	str	r3, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:135

    Regs(idx_base < 32 ? hal::Interrupt_Controller_Reg::IRQ_Enable_1 : hal::Interrupt_Controller_Reg::IRQ_Enable_2) =
    (1 << (idx_base % 32));
    9c34:	e51b3010 	ldr	r3, [fp, #-16]
    9c38:	e203301f 	and	r3, r3, #31
    9c3c:	e3a02001 	mov	r2, #1
    9c40:	e1a04312 	lsl	r4, r2, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:134
    Regs(idx_base < 32 ? hal::Interrupt_Controller_Reg::IRQ_Enable_1 : hal::Interrupt_Controller_Reg::IRQ_Enable_2) =
    9c44:	e51b3010 	ldr	r3, [fp, #-16]
    9c48:	e353001f 	cmp	r3, #31
    9c4c:	8a000001 	bhi	9c58 <_ZN21CInterrupt_Controller10Enable_IRQEN3hal10IRQ_SourceE+0x40>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:134 (discriminator 1)
    9c50:	e3a03004 	mov	r3, #4
    9c54:	ea000000 	b	9c5c <_ZN21CInterrupt_Controller10Enable_IRQEN3hal10IRQ_SourceE+0x44>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:134 (discriminator 2)
    9c58:	e3a03005 	mov	r3, #5
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:134 (discriminator 4)
    9c5c:	e1a01003 	mov	r1, r3
    9c60:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    9c64:	ebffffbb 	bl	9b58 <_ZN21CInterrupt_Controller4RegsEN3hal24Interrupt_Controller_RegE>
    9c68:	e1a03000 	mov	r3, r0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:135 (discriminator 4)
    (1 << (idx_base % 32));
    9c6c:	e1a02004 	mov	r2, r4
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:134 (discriminator 4)
    Regs(idx_base < 32 ? hal::Interrupt_Controller_Reg::IRQ_Enable_1 : hal::Interrupt_Controller_Reg::IRQ_Enable_2) =
    9c70:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:136 (discriminator 4)
}
    9c74:	e320f000 	nop	{0}
    9c78:	e24bd008 	sub	sp, fp, #8
    9c7c:	e8bd8810 	pop	{r4, fp, pc}

00009c80 <_ZN21CInterrupt_Controller11Disable_IRQEN3hal10IRQ_SourceE>:
_ZN21CInterrupt_Controller11Disable_IRQEN3hal10IRQ_SourceE():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:139

void CInterrupt_Controller::Disable_IRQ(hal::IRQ_Source source_idx)
{
    9c80:	e92d4810 	push	{r4, fp, lr}
    9c84:	e28db008 	add	fp, sp, #8
    9c88:	e24dd014 	sub	sp, sp, #20
    9c8c:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    9c90:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:140
    const unsigned int idx_base = static_cast<unsigned int>(source_idx);
    9c94:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    9c98:	e50b3010 	str	r3, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:143

    Regs(idx_base < 32 ? hal::Interrupt_Controller_Reg::IRQ_Disable_1 : hal::Interrupt_Controller_Reg::IRQ_Disable_2) =
    (1 << (idx_base % 32));
    9c9c:	e51b3010 	ldr	r3, [fp, #-16]
    9ca0:	e203301f 	and	r3, r3, #31
    9ca4:	e3a02001 	mov	r2, #1
    9ca8:	e1a04312 	lsl	r4, r2, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:142
    Regs(idx_base < 32 ? hal::Interrupt_Controller_Reg::IRQ_Disable_1 : hal::Interrupt_Controller_Reg::IRQ_Disable_2) =
    9cac:	e51b3010 	ldr	r3, [fp, #-16]
    9cb0:	e353001f 	cmp	r3, #31
    9cb4:	8a000001 	bhi	9cc0 <_ZN21CInterrupt_Controller11Disable_IRQEN3hal10IRQ_SourceE+0x40>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:142 (discriminator 1)
    9cb8:	e3a03007 	mov	r3, #7
    9cbc:	ea000000 	b	9cc4 <_ZN21CInterrupt_Controller11Disable_IRQEN3hal10IRQ_SourceE+0x44>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:142 (discriminator 2)
    9cc0:	e3a03008 	mov	r3, #8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:142 (discriminator 4)
    9cc4:	e1a01003 	mov	r1, r3
    9cc8:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    9ccc:	ebffffa1 	bl	9b58 <_ZN21CInterrupt_Controller4RegsEN3hal24Interrupt_Controller_RegE>
    9cd0:	e1a03000 	mov	r3, r0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:143 (discriminator 4)
    (1 << (idx_base % 32));
    9cd4:	e1a02004 	mov	r2, r4
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:142 (discriminator 4)
    Regs(idx_base < 32 ? hal::Interrupt_Controller_Reg::IRQ_Disable_1 : hal::Interrupt_Controller_Reg::IRQ_Disable_2) =
    9cd8:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:144 (discriminator 4)
}
    9cdc:	e320f000 	nop	{0}
    9ce0:	e24bd008 	sub	sp, fp, #8
    9ce4:	e8bd8810 	pop	{r4, fp, pc}

00009ce8 <_Z41__static_initialization_and_destruction_0ii>:
_Z41__static_initialization_and_destruction_0ii():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:144
    9ce8:	e92d4800 	push	{fp, lr}
    9cec:	e28db004 	add	fp, sp, #4
    9cf0:	e24dd008 	sub	sp, sp, #8
    9cf4:	e50b0008 	str	r0, [fp, #-8]
    9cf8:	e50b100c 	str	r1, [fp, #-12]
    9cfc:	e51b3008 	ldr	r3, [fp, #-8]
    9d00:	e3530001 	cmp	r3, #1
    9d04:	1a000006 	bne	9d24 <_Z41__static_initialization_and_destruction_0ii+0x3c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:144 (discriminator 1)
    9d08:	e51b300c 	ldr	r3, [fp, #-12]
    9d0c:	e59f201c 	ldr	r2, [pc, #28]	; 9d30 <_Z41__static_initialization_and_destruction_0ii+0x48>
    9d10:	e1530002 	cmp	r3, r2
    9d14:	1a000002 	bne	9d24 <_Z41__static_initialization_and_destruction_0ii+0x3c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:108
CInterrupt_Controller sInterruptCtl(hal::Interrupt_Controller_Base);
    9d18:	e59f1014 	ldr	r1, [pc, #20]	; 9d34 <_Z41__static_initialization_and_destruction_0ii+0x4c>
    9d1c:	e59f0014 	ldr	r0, [pc, #20]	; 9d38 <_Z41__static_initialization_and_destruction_0ii+0x50>
    9d20:	ebffff7f 	bl	9b24 <_ZN21CInterrupt_ControllerC1Em>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:144
}
    9d24:	e320f000 	nop	{0}
    9d28:	e24bd004 	sub	sp, fp, #4
    9d2c:	e8bd8800 	pop	{fp, pc}
    9d30:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>
    9d34:	2000b200 	andcs	fp, r0, r0, lsl #4
    9d38:	0000aa74 	andeq	sl, r0, r4, ror sl

00009d3c <_GLOBAL__sub_I_game_state>:
_GLOBAL__sub_I_game_state():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:144
    9d3c:	e92d4800 	push	{fp, lr}
    9d40:	e28db004 	add	fp, sp, #4
    9d44:	e59f1008 	ldr	r1, [pc, #8]	; 9d54 <_GLOBAL__sub_I_game_state+0x18>
    9d48:	e3a00001 	mov	r0, #1
    9d4c:	ebffffe5 	bl	9ce8 <_Z41__static_initialization_and_destruction_0ii>
    9d50:	e8bd8800 	pop	{fp, pc}
    9d54:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>

00009d58 <_kernel_main>:
_kernel_main():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/main.cpp:6
#include <drivers/gpio.h>
#include <drivers/uart.h>
#include <interrupt_controller.h>

extern "C" int _kernel_main(void)
{
    9d58:	e92d4800 	push	{fp, lr}
    9d5c:	e28db004 	add	fp, sp, #4
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/main.cpp:7
    sInterruptCtl.Enable_IRQ(hal::IRQ_Source::AUX);
    9d60:	e3a0101d 	mov	r1, #29
    9d64:	e59f004c 	ldr	r0, [pc, #76]	; 9db8 <_kernel_main+0x60>
    9d68:	ebffffaa 	bl	9c18 <_ZN21CInterrupt_Controller10Enable_IRQEN3hal10IRQ_SourceE>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/main.cpp:9

    sUART0.Set_Baud_Rate(NUART_Baud_Rate::BR_115200);
    9d6c:	e59f1048 	ldr	r1, [pc, #72]	; 9dbc <_kernel_main+0x64>
    9d70:	e59f0048 	ldr	r0, [pc, #72]	; 9dc0 <_kernel_main+0x68>
    9d74:	ebfffd8a 	bl	93a4 <_ZN5CUART13Set_Baud_RateE15NUART_Baud_Rate>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/main.cpp:10
    sUART0.Set_Char_Length(NUART_Char_Length::Char_8);
    9d78:	e3a01001 	mov	r1, #1
    9d7c:	e59f003c 	ldr	r0, [pc, #60]	; 9dc0 <_kernel_main+0x68>
    9d80:	ebfffd70 	bl	9348 <_ZN5CUART15Set_Char_LengthE17NUART_Char_Length>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/main.cpp:12
    
    sUART0.Enable_Receive_Int();
    9d84:	e59f0034 	ldr	r0, [pc, #52]	; 9dc0 <_kernel_main+0x68>
    9d88:	ebfffe3b 	bl	967c <_ZN5CUART18Enable_Receive_IntEv>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/main.cpp:14

    enable_irq();
    9d8c:	eb00000f 	bl	9dd0 <enable_irq>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/main.cpp:16

    sUART0.Write("Welcome to a guessing game!\r\n");
    9d90:	e59f102c 	ldr	r1, [pc, #44]	; 9dc4 <_kernel_main+0x6c>
    9d94:	e59f0024 	ldr	r0, [pc, #36]	; 9dc0 <_kernel_main+0x68>
    9d98:	ebfffdc3 	bl	94ac <_ZN5CUART5WriteEPKc>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/main.cpp:17
    sUART0.Write("---------------------------\r\n");
    9d9c:	e59f1024 	ldr	r1, [pc, #36]	; 9dc8 <_kernel_main+0x70>
    9da0:	e59f0018 	ldr	r0, [pc, #24]	; 9dc0 <_kernel_main+0x68>
    9da4:	ebfffdc0 	bl	94ac <_ZN5CUART5WriteEPKc>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/main.cpp:18
    sUART0.Write("Think of a number between 1 and 100 and I'm gonna guess what it is. All you gotta do is to tell me whether my guess is larger than your number of choice or not, okay? [y/n]: ");
    9da8:	e59f101c 	ldr	r1, [pc, #28]	; 9dcc <_kernel_main+0x74>
    9dac:	e59f000c 	ldr	r0, [pc, #12]	; 9dc0 <_kernel_main+0x68>
    9db0:	ebfffdbd 	bl	94ac <_ZN5CUART5WriteEPKc>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/main.cpp:20 (discriminator 1)

    while (1)
    9db4:	eafffffe 	b	9db4 <_kernel_main+0x5c>
    9db8:	0000aa74 	andeq	sl, r0, r4, ror sl
    9dbc:	0001c200 	andeq	ip, r1, r0, lsl #4
    9dc0:	0000aa48 	andeq	sl, r0, r8, asr #20
    9dc4:	0000a8f8 	strdeq	sl, [r0], -r8
    9dc8:	0000a918 	andeq	sl, r0, r8, lsl r9
    9dcc:	0000a938 	andeq	sl, r0, r8, lsr r9

00009dd0 <enable_irq>:
enable_irq():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/start.s:90
;@ tady budou ostatni symboly, ktere nevyzaduji zadne specialni misto
.section .text

.global enable_irq
enable_irq:
    mrs r0, cpsr		;@ presun ridiciho registru (CPSR) do general purpose registru (R0)
    9dd0:	e10f0000 	mrs	r0, CPSR
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/start.s:91
    bic r0, r0, #0x80	;@ vypne bit 7 v registru r0 ("IRQ mask bit")
    9dd4:	e3c00080 	bic	r0, r0, #128	; 0x80
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/start.s:92
    msr cpsr_c, r0		;@ nacteme upraveny general purpose (R0) registr do ridiciho (CPSR)
    9dd8:	e121f000 	msr	CPSR_c, r0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/start.s:93
    cpsie i				;@ povoli preruseni
    9ddc:	f1080080 	cpsie	i
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/start.s:94
    bx lr
    9de0:	e12fff1e 	bx	lr

00009de4 <undefined_instruction_handler>:
undefined_instruction_handler():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/start.s:97

undefined_instruction_handler:
	b hang
    9de4:	eafff8a9 	b	8090 <hang>

00009de8 <prefetch_abort_handler>:
prefetch_abort_handler():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/start.s:102

prefetch_abort_handler:
	;@ tady pak muzeme osetrit, kdyz program zasahne do mista, ktere nema mapovane ve svem virtualnim adr. prostoru
	;@ a treba vyvolat nasi obdobu segfaultu
	b hang
    9de8:	eafff8a8 	b	8090 <hang>

00009dec <data_abort_handler>:
data_abort_handler():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/start.s:107

data_abort_handler:
	;@ tady pak muzeme osetrit, kdyz program zasahne do mista, ktere nema mapovane ve svem virtualnim adr. prostoru
	;@ a treba vyvolat nasi obdobu segfaultu
	b hang
    9dec:	eafff8a7 	b	8090 <hang>

00009df0 <_c_startup>:
_c_startup():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/startup.cpp:21
extern "C" dtor_ptr __DTOR_LIST__[0];
// konec pole destruktoru
extern "C" dtor_ptr __DTOR_END__[0];

extern "C" int _c_startup(void)
{
    9df0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9df4:	e28db000 	add	fp, sp, #0
    9df8:	e24dd00c 	sub	sp, sp, #12
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/startup.cpp:25
    int* i;

    // vynulujeme .bss sekci
    for (i = (int*)_bss_start; i < (int*)_bss_end; i++)
    9dfc:	e59f304c 	ldr	r3, [pc, #76]	; 9e50 <_c_startup+0x60>
    9e00:	e5933000 	ldr	r3, [r3]
    9e04:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/startup.cpp:25 (discriminator 3)
    9e08:	e59f3044 	ldr	r3, [pc, #68]	; 9e54 <_c_startup+0x64>
    9e0c:	e5933000 	ldr	r3, [r3]
    9e10:	e1a02003 	mov	r2, r3
    9e14:	e51b3008 	ldr	r3, [fp, #-8]
    9e18:	e1530002 	cmp	r3, r2
    9e1c:	2a000006 	bcs	9e3c <_c_startup+0x4c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/startup.cpp:26 (discriminator 2)
        *i = 0;
    9e20:	e51b3008 	ldr	r3, [fp, #-8]
    9e24:	e3a02000 	mov	r2, #0
    9e28:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/startup.cpp:25 (discriminator 2)
    for (i = (int*)_bss_start; i < (int*)_bss_end; i++)
    9e2c:	e51b3008 	ldr	r3, [fp, #-8]
    9e30:	e2833004 	add	r3, r3, #4
    9e34:	e50b3008 	str	r3, [fp, #-8]
    9e38:	eafffff2 	b	9e08 <_c_startup+0x18>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/startup.cpp:28

    return 0;
    9e3c:	e3a03000 	mov	r3, #0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/startup.cpp:29
}
    9e40:	e1a00003 	mov	r0, r3
    9e44:	e28bd000 	add	sp, fp, #0
    9e48:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9e4c:	e12fff1e 	bx	lr
    9e50:	0000aa18 	andeq	sl, r0, r8, lsl sl
    9e54:	0000aa88 	andeq	sl, r0, r8, lsl #21

00009e58 <_cpp_startup>:
_cpp_startup():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/startup.cpp:32

extern "C" int _cpp_startup(void)
{
    9e58:	e92d4800 	push	{fp, lr}
    9e5c:	e28db004 	add	fp, sp, #4
    9e60:	e24dd008 	sub	sp, sp, #8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/startup.cpp:37
    ctor_ptr* fnptr;

    // zavolame konstruktory globalnich C++ trid
    // v poli __CTOR_LIST__ jsou ukazatele na vygenerovane stuby volani konstruktoru
    for (fnptr = __CTOR_LIST__; fnptr < __CTOR_END__; fnptr++)
    9e64:	e59f303c 	ldr	r3, [pc, #60]	; 9ea8 <_cpp_startup+0x50>
    9e68:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/startup.cpp:37 (discriminator 3)
    9e6c:	e51b3008 	ldr	r3, [fp, #-8]
    9e70:	e59f2034 	ldr	r2, [pc, #52]	; 9eac <_cpp_startup+0x54>
    9e74:	e1530002 	cmp	r3, r2
    9e78:	2a000006 	bcs	9e98 <_cpp_startup+0x40>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/startup.cpp:38 (discriminator 2)
        (*fnptr)();
    9e7c:	e51b3008 	ldr	r3, [fp, #-8]
    9e80:	e5933000 	ldr	r3, [r3]
    9e84:	e12fff33 	blx	r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/startup.cpp:37 (discriminator 2)
    for (fnptr = __CTOR_LIST__; fnptr < __CTOR_END__; fnptr++)
    9e88:	e51b3008 	ldr	r3, [fp, #-8]
    9e8c:	e2833004 	add	r3, r3, #4
    9e90:	e50b3008 	str	r3, [fp, #-8]
    9e94:	eafffff4 	b	9e6c <_cpp_startup+0x14>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/startup.cpp:40

    return 0;
    9e98:	e3a03000 	mov	r3, #0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/startup.cpp:41
}
    9e9c:	e1a00003 	mov	r0, r3
    9ea0:	e24bd004 	sub	sp, fp, #4
    9ea4:	e8bd8800 	pop	{fp, pc}
    9ea8:	0000a9fc 	strdeq	sl, [r0], -ip
    9eac:	0000aa10 	andeq	sl, r0, r0, lsl sl

00009eb0 <_cpp_shutdown>:
_cpp_shutdown():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/startup.cpp:44

extern "C" int _cpp_shutdown(void)
{
    9eb0:	e92d4800 	push	{fp, lr}
    9eb4:	e28db004 	add	fp, sp, #4
    9eb8:	e24dd008 	sub	sp, sp, #8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/startup.cpp:48
    dtor_ptr* fnptr;

    // zavolame destruktory globalnich C++ trid
    for (fnptr = __DTOR_LIST__; fnptr < __DTOR_END__; fnptr++)
    9ebc:	e59f303c 	ldr	r3, [pc, #60]	; 9f00 <_cpp_shutdown+0x50>
    9ec0:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/startup.cpp:48 (discriminator 3)
    9ec4:	e51b3008 	ldr	r3, [fp, #-8]
    9ec8:	e59f2034 	ldr	r2, [pc, #52]	; 9f04 <_cpp_shutdown+0x54>
    9ecc:	e1530002 	cmp	r3, r2
    9ed0:	2a000006 	bcs	9ef0 <_cpp_shutdown+0x40>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/startup.cpp:49 (discriminator 2)
        (*fnptr)();
    9ed4:	e51b3008 	ldr	r3, [fp, #-8]
    9ed8:	e5933000 	ldr	r3, [r3]
    9edc:	e12fff33 	blx	r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/startup.cpp:48 (discriminator 2)
    for (fnptr = __DTOR_LIST__; fnptr < __DTOR_END__; fnptr++)
    9ee0:	e51b3008 	ldr	r3, [fp, #-8]
    9ee4:	e2833004 	add	r3, r3, #4
    9ee8:	e50b3008 	str	r3, [fp, #-8]
    9eec:	eafffff4 	b	9ec4 <_cpp_shutdown+0x14>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/startup.cpp:51

    return 0;
    9ef0:	e3a03000 	mov	r3, #0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/startup.cpp:52
}
    9ef4:	e1a00003 	mov	r0, r3
    9ef8:	e24bd004 	sub	sp, fp, #4
    9efc:	e8bd8800 	pop	{fp, pc}
    9f00:	0000aa10 	andeq	sl, r0, r0, lsl sl
    9f04:	0000aa10 	andeq	sl, r0, r0, lsl sl

00009f08 <_Z4itoajPcj>:
_Z4itoajPcj():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:9
{
    const char CharConvArr[] = "0123456789ABCDEF";
}

void itoa(unsigned int input, char* output, unsigned int base)
{
    9f08:	e92d4800 	push	{fp, lr}
    9f0c:	e28db004 	add	fp, sp, #4
    9f10:	e24dd020 	sub	sp, sp, #32
    9f14:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    9f18:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    9f1c:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:10
    int i = 0;
    9f20:	e3a03000 	mov	r3, #0
    9f24:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:12

    while (input > 0)
    9f28:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9f2c:	e3530000 	cmp	r3, #0
    9f30:	0a000014 	beq	9f88 <_Z4itoajPcj+0x80>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:14
    {
        output[i] = CharConvArr[input % base];
    9f34:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9f38:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    9f3c:	e1a00003 	mov	r0, r3
    9f40:	eb000199 	bl	a5ac <__aeabi_uidivmod>
    9f44:	e1a03001 	mov	r3, r1
    9f48:	e1a01003 	mov	r1, r3
    9f4c:	e51b3008 	ldr	r3, [fp, #-8]
    9f50:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    9f54:	e0823003 	add	r3, r2, r3
    9f58:	e59f2118 	ldr	r2, [pc, #280]	; a078 <_Z4itoajPcj+0x170>
    9f5c:	e7d22001 	ldrb	r2, [r2, r1]
    9f60:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:15
        input /= base;
    9f64:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    9f68:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    9f6c:	eb000113 	bl	a3c0 <__udivsi3>
    9f70:	e1a03000 	mov	r3, r0
    9f74:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:16
        i++;
    9f78:	e51b3008 	ldr	r3, [fp, #-8]
    9f7c:	e2833001 	add	r3, r3, #1
    9f80:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:12
    while (input > 0)
    9f84:	eaffffe7 	b	9f28 <_Z4itoajPcj+0x20>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:19
    }

    if (i == 0)
    9f88:	e51b3008 	ldr	r3, [fp, #-8]
    9f8c:	e3530000 	cmp	r3, #0
    9f90:	1a000007 	bne	9fb4 <_Z4itoajPcj+0xac>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:21
    {
        output[i] = CharConvArr[0];
    9f94:	e51b3008 	ldr	r3, [fp, #-8]
    9f98:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    9f9c:	e0823003 	add	r3, r2, r3
    9fa0:	e3a02030 	mov	r2, #48	; 0x30
    9fa4:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:22
        i++;
    9fa8:	e51b3008 	ldr	r3, [fp, #-8]
    9fac:	e2833001 	add	r3, r3, #1
    9fb0:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:25
    }

    output[i] = '\0';
    9fb4:	e51b3008 	ldr	r3, [fp, #-8]
    9fb8:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    9fbc:	e0823003 	add	r3, r2, r3
    9fc0:	e3a02000 	mov	r2, #0
    9fc4:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:26
    i--;
    9fc8:	e51b3008 	ldr	r3, [fp, #-8]
    9fcc:	e2433001 	sub	r3, r3, #1
    9fd0:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:28

    for (int j = 0; j <= i / 2; j++)
    9fd4:	e3a03000 	mov	r3, #0
    9fd8:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:28 (discriminator 3)
    9fdc:	e51b3008 	ldr	r3, [fp, #-8]
    9fe0:	e1a02fa3 	lsr	r2, r3, #31
    9fe4:	e0823003 	add	r3, r2, r3
    9fe8:	e1a030c3 	asr	r3, r3, #1
    9fec:	e1a02003 	mov	r2, r3
    9ff0:	e51b300c 	ldr	r3, [fp, #-12]
    9ff4:	e1530002 	cmp	r3, r2
    9ff8:	ca00001b 	bgt	a06c <_Z4itoajPcj+0x164>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:30 (discriminator 2)
    {
        char c = output[i - j];
    9ffc:	e51b2008 	ldr	r2, [fp, #-8]
    a000:	e51b300c 	ldr	r3, [fp, #-12]
    a004:	e0423003 	sub	r3, r2, r3
    a008:	e1a02003 	mov	r2, r3
    a00c:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    a010:	e0833002 	add	r3, r3, r2
    a014:	e5d33000 	ldrb	r3, [r3]
    a018:	e54b300d 	strb	r3, [fp, #-13]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:31 (discriminator 2)
        output[i - j] = output[j];
    a01c:	e51b300c 	ldr	r3, [fp, #-12]
    a020:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    a024:	e0822003 	add	r2, r2, r3
    a028:	e51b1008 	ldr	r1, [fp, #-8]
    a02c:	e51b300c 	ldr	r3, [fp, #-12]
    a030:	e0413003 	sub	r3, r1, r3
    a034:	e1a01003 	mov	r1, r3
    a038:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    a03c:	e0833001 	add	r3, r3, r1
    a040:	e5d22000 	ldrb	r2, [r2]
    a044:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:32 (discriminator 2)
        output[j] = c;
    a048:	e51b300c 	ldr	r3, [fp, #-12]
    a04c:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    a050:	e0823003 	add	r3, r2, r3
    a054:	e55b200d 	ldrb	r2, [fp, #-13]
    a058:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:28 (discriminator 2)
    for (int j = 0; j <= i / 2; j++)
    a05c:	e51b300c 	ldr	r3, [fp, #-12]
    a060:	e2833001 	add	r3, r3, #1
    a064:	e50b300c 	str	r3, [fp, #-12]
    a068:	eaffffdb 	b	9fdc <_Z4itoajPcj+0xd4>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:34
    }
}
    a06c:	e320f000 	nop	{0}
    a070:	e24bd004 	sub	sp, fp, #4
    a074:	e8bd8800 	pop	{fp, pc}
    a078:	0000a9e8 	andeq	sl, r0, r8, ror #19

0000a07c <_Z4atoiPKc>:
_Z4atoiPKc():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:37

int atoi(const char* input)
{
    a07c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    a080:	e28db000 	add	fp, sp, #0
    a084:	e24dd014 	sub	sp, sp, #20
    a088:	e50b0010 	str	r0, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:38
    int output = 0;
    a08c:	e3a03000 	mov	r3, #0
    a090:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:40

    while (*input != '\0')
    a094:	e51b3010 	ldr	r3, [fp, #-16]
    a098:	e5d33000 	ldrb	r3, [r3]
    a09c:	e3530000 	cmp	r3, #0
    a0a0:	0a000017 	beq	a104 <_Z4atoiPKc+0x88>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:42
    {
        output *= 10;
    a0a4:	e51b2008 	ldr	r2, [fp, #-8]
    a0a8:	e1a03002 	mov	r3, r2
    a0ac:	e1a03103 	lsl	r3, r3, #2
    a0b0:	e0833002 	add	r3, r3, r2
    a0b4:	e1a03083 	lsl	r3, r3, #1
    a0b8:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:43
        if (*input > '9' || *input < '0')
    a0bc:	e51b3010 	ldr	r3, [fp, #-16]
    a0c0:	e5d33000 	ldrb	r3, [r3]
    a0c4:	e3530039 	cmp	r3, #57	; 0x39
    a0c8:	8a00000d 	bhi	a104 <_Z4atoiPKc+0x88>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:43 (discriminator 1)
    a0cc:	e51b3010 	ldr	r3, [fp, #-16]
    a0d0:	e5d33000 	ldrb	r3, [r3]
    a0d4:	e353002f 	cmp	r3, #47	; 0x2f
    a0d8:	9a000009 	bls	a104 <_Z4atoiPKc+0x88>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:46
            break;

        output += *input - '0';
    a0dc:	e51b3010 	ldr	r3, [fp, #-16]
    a0e0:	e5d33000 	ldrb	r3, [r3]
    a0e4:	e2433030 	sub	r3, r3, #48	; 0x30
    a0e8:	e51b2008 	ldr	r2, [fp, #-8]
    a0ec:	e0823003 	add	r3, r2, r3
    a0f0:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:48

        input++;
    a0f4:	e51b3010 	ldr	r3, [fp, #-16]
    a0f8:	e2833001 	add	r3, r3, #1
    a0fc:	e50b3010 	str	r3, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:40
    while (*input != '\0')
    a100:	eaffffe3 	b	a094 <_Z4atoiPKc+0x18>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:51
    }

    return output;
    a104:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:52
}
    a108:	e1a00003 	mov	r0, r3
    a10c:	e28bd000 	add	sp, fp, #0
    a110:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    a114:	e12fff1e 	bx	lr

0000a118 <_Z7strncpyPcPKci>:
_Z7strncpyPcPKci():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:55

char* strncpy(char* dest, const char* src, int num)
{
    a118:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    a11c:	e28db000 	add	fp, sp, #0
    a120:	e24dd01c 	sub	sp, sp, #28
    a124:	e50b0010 	str	r0, [fp, #-16]
    a128:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    a12c:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:58
    int i;

    for (i = 0; i < num && src[i] != '\0'; i++)
    a130:	e3a03000 	mov	r3, #0
    a134:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:58 (discriminator 4)
    a138:	e51b2008 	ldr	r2, [fp, #-8]
    a13c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    a140:	e1520003 	cmp	r2, r3
    a144:	aa000011 	bge	a190 <_Z7strncpyPcPKci+0x78>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:58 (discriminator 2)
    a148:	e51b3008 	ldr	r3, [fp, #-8]
    a14c:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    a150:	e0823003 	add	r3, r2, r3
    a154:	e5d33000 	ldrb	r3, [r3]
    a158:	e3530000 	cmp	r3, #0
    a15c:	0a00000b 	beq	a190 <_Z7strncpyPcPKci+0x78>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:59 (discriminator 3)
        dest[i] = src[i];
    a160:	e51b3008 	ldr	r3, [fp, #-8]
    a164:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    a168:	e0822003 	add	r2, r2, r3
    a16c:	e51b3008 	ldr	r3, [fp, #-8]
    a170:	e51b1010 	ldr	r1, [fp, #-16]
    a174:	e0813003 	add	r3, r1, r3
    a178:	e5d22000 	ldrb	r2, [r2]
    a17c:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:58 (discriminator 3)
    for (i = 0; i < num && src[i] != '\0'; i++)
    a180:	e51b3008 	ldr	r3, [fp, #-8]
    a184:	e2833001 	add	r3, r3, #1
    a188:	e50b3008 	str	r3, [fp, #-8]
    a18c:	eaffffe9 	b	a138 <_Z7strncpyPcPKci+0x20>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:60 (discriminator 2)
    for (; i < num; i++)
    a190:	e51b2008 	ldr	r2, [fp, #-8]
    a194:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    a198:	e1520003 	cmp	r2, r3
    a19c:	aa000008 	bge	a1c4 <_Z7strncpyPcPKci+0xac>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:61 (discriminator 1)
        dest[i] = '\0';
    a1a0:	e51b3008 	ldr	r3, [fp, #-8]
    a1a4:	e51b2010 	ldr	r2, [fp, #-16]
    a1a8:	e0823003 	add	r3, r2, r3
    a1ac:	e3a02000 	mov	r2, #0
    a1b0:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:60 (discriminator 1)
    for (; i < num; i++)
    a1b4:	e51b3008 	ldr	r3, [fp, #-8]
    a1b8:	e2833001 	add	r3, r3, #1
    a1bc:	e50b3008 	str	r3, [fp, #-8]
    a1c0:	eafffff2 	b	a190 <_Z7strncpyPcPKci+0x78>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:63

    return dest;
    a1c4:	e51b3010 	ldr	r3, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:64
}
    a1c8:	e1a00003 	mov	r0, r3
    a1cc:	e28bd000 	add	sp, fp, #0
    a1d0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    a1d4:	e12fff1e 	bx	lr

0000a1d8 <_Z7strncmpPKcS0_i>:
_Z7strncmpPKcS0_i():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:67

int strncmp(const char* s1, const char* s2, int num)
{
    a1d8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    a1dc:	e28db000 	add	fp, sp, #0
    a1e0:	e24dd01c 	sub	sp, sp, #28
    a1e4:	e50b0010 	str	r0, [fp, #-16]
    a1e8:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    a1ec:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:69
    unsigned char u1, u2;
    while (num-- > 0)
    a1f0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    a1f4:	e2432001 	sub	r2, r3, #1
    a1f8:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
    a1fc:	e3530000 	cmp	r3, #0
    a200:	c3a03001 	movgt	r3, #1
    a204:	d3a03000 	movle	r3, #0
    a208:	e6ef3073 	uxtb	r3, r3
    a20c:	e3530000 	cmp	r3, #0
    a210:	0a000016 	beq	a270 <_Z7strncmpPKcS0_i+0x98>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:71
    {
        u1 = (unsigned char)*s1++;
    a214:	e51b3010 	ldr	r3, [fp, #-16]
    a218:	e2832001 	add	r2, r3, #1
    a21c:	e50b2010 	str	r2, [fp, #-16]
    a220:	e5d33000 	ldrb	r3, [r3]
    a224:	e54b3005 	strb	r3, [fp, #-5]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:72
        u2 = (unsigned char)*s2++;
    a228:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    a22c:	e2832001 	add	r2, r3, #1
    a230:	e50b2014 	str	r2, [fp, #-20]	; 0xffffffec
    a234:	e5d33000 	ldrb	r3, [r3]
    a238:	e54b3006 	strb	r3, [fp, #-6]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:73
        if (u1 != u2)
    a23c:	e55b2005 	ldrb	r2, [fp, #-5]
    a240:	e55b3006 	ldrb	r3, [fp, #-6]
    a244:	e1520003 	cmp	r2, r3
    a248:	0a000003 	beq	a25c <_Z7strncmpPKcS0_i+0x84>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:74
            return u1 - u2;
    a24c:	e55b2005 	ldrb	r2, [fp, #-5]
    a250:	e55b3006 	ldrb	r3, [fp, #-6]
    a254:	e0423003 	sub	r3, r2, r3
    a258:	ea000005 	b	a274 <_Z7strncmpPKcS0_i+0x9c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:75
        if (u1 == '\0')
    a25c:	e55b3005 	ldrb	r3, [fp, #-5]
    a260:	e3530000 	cmp	r3, #0
    a264:	1affffe1 	bne	a1f0 <_Z7strncmpPKcS0_i+0x18>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:76
            return 0;
    a268:	e3a03000 	mov	r3, #0
    a26c:	ea000000 	b	a274 <_Z7strncmpPKcS0_i+0x9c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:79
    }

    return 0;
    a270:	e3a03000 	mov	r3, #0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:80
}
    a274:	e1a00003 	mov	r0, r3
    a278:	e28bd000 	add	sp, fp, #0
    a27c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    a280:	e12fff1e 	bx	lr

0000a284 <_Z6strlenPKc>:
_Z6strlenPKc():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:83

int strlen(const char* s)
{
    a284:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    a288:	e28db000 	add	fp, sp, #0
    a28c:	e24dd014 	sub	sp, sp, #20
    a290:	e50b0010 	str	r0, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:84
    int i = 0;
    a294:	e3a03000 	mov	r3, #0
    a298:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:86

    while (s[i] != '\0')
    a29c:	e51b3008 	ldr	r3, [fp, #-8]
    a2a0:	e51b2010 	ldr	r2, [fp, #-16]
    a2a4:	e0823003 	add	r3, r2, r3
    a2a8:	e5d33000 	ldrb	r3, [r3]
    a2ac:	e3530000 	cmp	r3, #0
    a2b0:	0a000003 	beq	a2c4 <_Z6strlenPKc+0x40>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:87
        i++;
    a2b4:	e51b3008 	ldr	r3, [fp, #-8]
    a2b8:	e2833001 	add	r3, r3, #1
    a2bc:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:86
    while (s[i] != '\0')
    a2c0:	eafffff5 	b	a29c <_Z6strlenPKc+0x18>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:89

    return i;
    a2c4:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:90
}
    a2c8:	e1a00003 	mov	r0, r3
    a2cc:	e28bd000 	add	sp, fp, #0
    a2d0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    a2d4:	e12fff1e 	bx	lr

0000a2d8 <_Z5bzeroPvi>:
_Z5bzeroPvi():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:93

void bzero(void* memory, int length)
{
    a2d8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    a2dc:	e28db000 	add	fp, sp, #0
    a2e0:	e24dd014 	sub	sp, sp, #20
    a2e4:	e50b0010 	str	r0, [fp, #-16]
    a2e8:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:94
    char* mem = reinterpret_cast<char*>(memory);
    a2ec:	e51b3010 	ldr	r3, [fp, #-16]
    a2f0:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:96

    for (int i = 0; i < length; i++)
    a2f4:	e3a03000 	mov	r3, #0
    a2f8:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:96 (discriminator 3)
    a2fc:	e51b2008 	ldr	r2, [fp, #-8]
    a300:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    a304:	e1520003 	cmp	r2, r3
    a308:	aa000008 	bge	a330 <_Z5bzeroPvi+0x58>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:97 (discriminator 2)
        mem[i] = 0;
    a30c:	e51b3008 	ldr	r3, [fp, #-8]
    a310:	e51b200c 	ldr	r2, [fp, #-12]
    a314:	e0823003 	add	r3, r2, r3
    a318:	e3a02000 	mov	r2, #0
    a31c:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:96 (discriminator 2)
    for (int i = 0; i < length; i++)
    a320:	e51b3008 	ldr	r3, [fp, #-8]
    a324:	e2833001 	add	r3, r3, #1
    a328:	e50b3008 	str	r3, [fp, #-8]
    a32c:	eafffff2 	b	a2fc <_Z5bzeroPvi+0x24>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:98
}
    a330:	e320f000 	nop	{0}
    a334:	e28bd000 	add	sp, fp, #0
    a338:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    a33c:	e12fff1e 	bx	lr

0000a340 <_Z6memcpyPKvPvi>:
_Z6memcpyPKvPvi():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:101

void memcpy(const void* src, void* dst, int num)
{
    a340:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    a344:	e28db000 	add	fp, sp, #0
    a348:	e24dd024 	sub	sp, sp, #36	; 0x24
    a34c:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    a350:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    a354:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:102
    const char* memsrc = reinterpret_cast<const char*>(src);
    a358:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    a35c:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:103
    char* memdst = reinterpret_cast<char*>(dst);
    a360:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    a364:	e50b3010 	str	r3, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:105

    for (int i = 0; i < num; i++)
    a368:	e3a03000 	mov	r3, #0
    a36c:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:105 (discriminator 3)
    a370:	e51b2008 	ldr	r2, [fp, #-8]
    a374:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    a378:	e1520003 	cmp	r2, r3
    a37c:	aa00000b 	bge	a3b0 <_Z6memcpyPKvPvi+0x70>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:106 (discriminator 2)
        memdst[i] = memsrc[i];
    a380:	e51b3008 	ldr	r3, [fp, #-8]
    a384:	e51b200c 	ldr	r2, [fp, #-12]
    a388:	e0822003 	add	r2, r2, r3
    a38c:	e51b3008 	ldr	r3, [fp, #-8]
    a390:	e51b1010 	ldr	r1, [fp, #-16]
    a394:	e0813003 	add	r3, r1, r3
    a398:	e5d22000 	ldrb	r2, [r2]
    a39c:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:105 (discriminator 2)
    for (int i = 0; i < num; i++)
    a3a0:	e51b3008 	ldr	r3, [fp, #-8]
    a3a4:	e2833001 	add	r3, r3, #1
    a3a8:	e50b3008 	str	r3, [fp, #-8]
    a3ac:	eaffffef 	b	a370 <_Z6memcpyPKvPvi+0x30>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:107
}
    a3b0:	e320f000 	nop	{0}
    a3b4:	e28bd000 	add	sp, fp, #0
    a3b8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    a3bc:	e12fff1e 	bx	lr

0000a3c0 <__udivsi3>:
__udivsi3():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1104
    a3c0:	e2512001 	subs	r2, r1, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1106
    a3c4:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1107
    a3c8:	3a000074 	bcc	a5a0 <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1108
    a3cc:	e1500001 	cmp	r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1109
    a3d0:	9a00006b 	bls	a584 <__udivsi3+0x1c4>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1110
    a3d4:	e1110002 	tst	r1, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1111
    a3d8:	0a00006c 	beq	a590 <__udivsi3+0x1d0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1113
    a3dc:	e16f3f10 	clz	r3, r0
    a3e0:	e16f2f11 	clz	r2, r1
    a3e4:	e0423003 	sub	r3, r2, r3
    a3e8:	e273301f 	rsbs	r3, r3, #31
    a3ec:	10833083 	addne	r3, r3, r3, lsl #1
    a3f0:	e3a02000 	mov	r2, #0
    a3f4:	108ff103 	addne	pc, pc, r3, lsl #2
    a3f8:	e1a00000 	nop			; (mov r0, r0)
    a3fc:	e1500f81 	cmp	r0, r1, lsl #31
    a400:	e0a22002 	adc	r2, r2, r2
    a404:	20400f81 	subcs	r0, r0, r1, lsl #31
    a408:	e1500f01 	cmp	r0, r1, lsl #30
    a40c:	e0a22002 	adc	r2, r2, r2
    a410:	20400f01 	subcs	r0, r0, r1, lsl #30
    a414:	e1500e81 	cmp	r0, r1, lsl #29
    a418:	e0a22002 	adc	r2, r2, r2
    a41c:	20400e81 	subcs	r0, r0, r1, lsl #29
    a420:	e1500e01 	cmp	r0, r1, lsl #28
    a424:	e0a22002 	adc	r2, r2, r2
    a428:	20400e01 	subcs	r0, r0, r1, lsl #28
    a42c:	e1500d81 	cmp	r0, r1, lsl #27
    a430:	e0a22002 	adc	r2, r2, r2
    a434:	20400d81 	subcs	r0, r0, r1, lsl #27
    a438:	e1500d01 	cmp	r0, r1, lsl #26
    a43c:	e0a22002 	adc	r2, r2, r2
    a440:	20400d01 	subcs	r0, r0, r1, lsl #26
    a444:	e1500c81 	cmp	r0, r1, lsl #25
    a448:	e0a22002 	adc	r2, r2, r2
    a44c:	20400c81 	subcs	r0, r0, r1, lsl #25
    a450:	e1500c01 	cmp	r0, r1, lsl #24
    a454:	e0a22002 	adc	r2, r2, r2
    a458:	20400c01 	subcs	r0, r0, r1, lsl #24
    a45c:	e1500b81 	cmp	r0, r1, lsl #23
    a460:	e0a22002 	adc	r2, r2, r2
    a464:	20400b81 	subcs	r0, r0, r1, lsl #23
    a468:	e1500b01 	cmp	r0, r1, lsl #22
    a46c:	e0a22002 	adc	r2, r2, r2
    a470:	20400b01 	subcs	r0, r0, r1, lsl #22
    a474:	e1500a81 	cmp	r0, r1, lsl #21
    a478:	e0a22002 	adc	r2, r2, r2
    a47c:	20400a81 	subcs	r0, r0, r1, lsl #21
    a480:	e1500a01 	cmp	r0, r1, lsl #20
    a484:	e0a22002 	adc	r2, r2, r2
    a488:	20400a01 	subcs	r0, r0, r1, lsl #20
    a48c:	e1500981 	cmp	r0, r1, lsl #19
    a490:	e0a22002 	adc	r2, r2, r2
    a494:	20400981 	subcs	r0, r0, r1, lsl #19
    a498:	e1500901 	cmp	r0, r1, lsl #18
    a49c:	e0a22002 	adc	r2, r2, r2
    a4a0:	20400901 	subcs	r0, r0, r1, lsl #18
    a4a4:	e1500881 	cmp	r0, r1, lsl #17
    a4a8:	e0a22002 	adc	r2, r2, r2
    a4ac:	20400881 	subcs	r0, r0, r1, lsl #17
    a4b0:	e1500801 	cmp	r0, r1, lsl #16
    a4b4:	e0a22002 	adc	r2, r2, r2
    a4b8:	20400801 	subcs	r0, r0, r1, lsl #16
    a4bc:	e1500781 	cmp	r0, r1, lsl #15
    a4c0:	e0a22002 	adc	r2, r2, r2
    a4c4:	20400781 	subcs	r0, r0, r1, lsl #15
    a4c8:	e1500701 	cmp	r0, r1, lsl #14
    a4cc:	e0a22002 	adc	r2, r2, r2
    a4d0:	20400701 	subcs	r0, r0, r1, lsl #14
    a4d4:	e1500681 	cmp	r0, r1, lsl #13
    a4d8:	e0a22002 	adc	r2, r2, r2
    a4dc:	20400681 	subcs	r0, r0, r1, lsl #13
    a4e0:	e1500601 	cmp	r0, r1, lsl #12
    a4e4:	e0a22002 	adc	r2, r2, r2
    a4e8:	20400601 	subcs	r0, r0, r1, lsl #12
    a4ec:	e1500581 	cmp	r0, r1, lsl #11
    a4f0:	e0a22002 	adc	r2, r2, r2
    a4f4:	20400581 	subcs	r0, r0, r1, lsl #11
    a4f8:	e1500501 	cmp	r0, r1, lsl #10
    a4fc:	e0a22002 	adc	r2, r2, r2
    a500:	20400501 	subcs	r0, r0, r1, lsl #10
    a504:	e1500481 	cmp	r0, r1, lsl #9
    a508:	e0a22002 	adc	r2, r2, r2
    a50c:	20400481 	subcs	r0, r0, r1, lsl #9
    a510:	e1500401 	cmp	r0, r1, lsl #8
    a514:	e0a22002 	adc	r2, r2, r2
    a518:	20400401 	subcs	r0, r0, r1, lsl #8
    a51c:	e1500381 	cmp	r0, r1, lsl #7
    a520:	e0a22002 	adc	r2, r2, r2
    a524:	20400381 	subcs	r0, r0, r1, lsl #7
    a528:	e1500301 	cmp	r0, r1, lsl #6
    a52c:	e0a22002 	adc	r2, r2, r2
    a530:	20400301 	subcs	r0, r0, r1, lsl #6
    a534:	e1500281 	cmp	r0, r1, lsl #5
    a538:	e0a22002 	adc	r2, r2, r2
    a53c:	20400281 	subcs	r0, r0, r1, lsl #5
    a540:	e1500201 	cmp	r0, r1, lsl #4
    a544:	e0a22002 	adc	r2, r2, r2
    a548:	20400201 	subcs	r0, r0, r1, lsl #4
    a54c:	e1500181 	cmp	r0, r1, lsl #3
    a550:	e0a22002 	adc	r2, r2, r2
    a554:	20400181 	subcs	r0, r0, r1, lsl #3
    a558:	e1500101 	cmp	r0, r1, lsl #2
    a55c:	e0a22002 	adc	r2, r2, r2
    a560:	20400101 	subcs	r0, r0, r1, lsl #2
    a564:	e1500081 	cmp	r0, r1, lsl #1
    a568:	e0a22002 	adc	r2, r2, r2
    a56c:	20400081 	subcs	r0, r0, r1, lsl #1
    a570:	e1500001 	cmp	r0, r1
    a574:	e0a22002 	adc	r2, r2, r2
    a578:	20400001 	subcs	r0, r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1115
    a57c:	e1a00002 	mov	r0, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1116
    a580:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1119
    a584:	03a00001 	moveq	r0, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1120
    a588:	13a00000 	movne	r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1121
    a58c:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1123
    a590:	e16f2f11 	clz	r2, r1
    a594:	e262201f 	rsb	r2, r2, #31
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1125
    a598:	e1a00230 	lsr	r0, r0, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1126
    a59c:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1130
    a5a0:	e3500000 	cmp	r0, #0
    a5a4:	13e00000 	mvnne	r0, #0
    a5a8:	ea000007 	b	a5cc <__aeabi_idiv0>

0000a5ac <__aeabi_uidivmod>:
__aeabi_uidivmod():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1161
    a5ac:	e3510000 	cmp	r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1162
    a5b0:	0afffffa 	beq	a5a0 <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1163
    a5b4:	e92d4003 	push	{r0, r1, lr}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1164
    a5b8:	ebffff80 	bl	a3c0 <__udivsi3>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1165
    a5bc:	e8bd4006 	pop	{r1, r2, lr}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1166
    a5c0:	e0030092 	mul	r3, r2, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1167
    a5c4:	e0411003 	sub	r1, r1, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1168
    a5c8:	e12fff1e 	bx	lr

0000a5cc <__aeabi_idiv0>:
__aeabi_ldiv0():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1466
    a5cc:	e12fff1e 	bx	lr

Disassembly of section .ARM.extab:

0000a5d0 <.ARM.extab>:
    a5d0:	81019b40 	tsthi	r1, r0, asr #22
    a5d4:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    a5d8:	00000000 	andeq	r0, r0, r0
    a5dc:	81019b41 	tsthi	r1, r1, asr #22
    a5e0:	8481b0b0 	strhi	fp, [r1], #176	; 0xb0
    a5e4:	00000000 	andeq	r0, r0, r0
    a5e8:	81019b40 	tsthi	r1, r0, asr #22
    a5ec:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    a5f0:	00000000 	andeq	r0, r0, r0
    a5f4:	81019b40 	tsthi	r1, r0, asr #22
    a5f8:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    a5fc:	00000000 	andeq	r0, r0, r0
    a600:	81019b40 	tsthi	r1, r0, asr #22
    a604:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    a608:	00000000 	andeq	r0, r0, r0
    a60c:	81019b40 	tsthi	r1, r0, asr #22
    a610:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    a614:	00000000 	andeq	r0, r0, r0
    a618:	81019b40 	tsthi	r1, r0, asr #22
    a61c:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    a620:	00000000 	andeq	r0, r0, r0
    a624:	81019b40 	tsthi	r1, r0, asr #22
    a628:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    a62c:	00000000 	andeq	r0, r0, r0
    a630:	81019b40 	tsthi	r1, r0, asr #22
    a634:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    a638:	00000000 	andeq	r0, r0, r0
    a63c:	81019b41 	tsthi	r1, r1, asr #22
    a640:	8481b0b0 	strhi	fp, [r1], #176	; 0xb0
    a644:	00000000 	andeq	r0, r0, r0
    a648:	81019b41 	tsthi	r1, r1, asr #22
    a64c:	8481b0b0 	strhi	fp, [r1], #176	; 0xb0
    a650:	00000000 	andeq	r0, r0, r0
    a654:	81019b40 	tsthi	r1, r0, asr #22
    a658:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    a65c:	00000000 	andeq	r0, r0, r0
    a660:	81019b45 	tsthi	r1, r5, asr #22
    a664:	b10f8580 	smlabblt	pc, r0, r5, r8	; <UNPREDICTABLE>
    a668:	00000000 	andeq	r0, r0, r0
    a66c:	81019b40 	tsthi	r1, r0, asr #22
    a670:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    a674:	00000000 	andeq	r0, r0, r0
    a678:	81019b40 	tsthi	r1, r0, asr #22
    a67c:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    a680:	00000000 	andeq	r0, r0, r0
    a684:	81019b40 	tsthi	r1, r0, asr #22
    a688:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    a68c:	00000000 	andeq	r0, r0, r0

Disassembly of section .ARM.exidx:

0000a690 <.ARM.exidx>:
    a690:	7fffda04 	svcvc	0x00ffda04
    a694:	00000001 	andeq	r0, r0, r1
    a698:	7fffec0c 	svcvc	0x00ffec0c
    a69c:	7fffff34 	svcvc	0x00ffff34
    a6a0:	7fffeca8 	svcvc	0x00ffeca8
    a6a4:	7fffff38 	svcvc	0x00ffff38
    a6a8:	7fffecfc 	svcvc	0x00ffecfc
    a6ac:	7fffff3c 	svcvc	0x00ffff3c
    a6b0:	7fffed88 	svcvc	0x00ffed88
    a6b4:	7fffff40 	svcvc	0x00ffff40
    a6b8:	7fffedf4 	svcvc	0x00ffedf4
    a6bc:	7fffff44 	svcvc	0x00ffff44
    a6c0:	7fffee58 	svcvc	0x00ffee58
    a6c4:	7fffff48 	svcvc	0x00ffff48
    a6c8:	7fffeeb8 	svcvc	0x00ffeeb8
    a6cc:	7fffff4c 	svcvc	0x00ffff4c
    a6d0:	7fffeef0 	svcvc	0x00ffeef0
    a6d4:	7fffff50 	svcvc	0x00ffff50
    a6d8:	7fffef28 	svcvc	0x00ffef28
    a6dc:	7fffff54 	svcvc	0x00ffff54
    a6e0:	7fffef9c 	svcvc	0x00ffef9c
    a6e4:	7fffff58 	svcvc	0x00ffff58
    a6e8:	7fffefe4 	svcvc	0x00ffefe4
    a6ec:	7fffff5c 	svcvc	0x00ffff5c
    a6f0:	7ffff02c 	svcvc	0x00fff02c
    a6f4:	00000001 	andeq	r0, r0, r1
    a6f8:	7ffff094 	svcvc	0x00fff094
    a6fc:	7fffff58 	svcvc	0x00ffff58
    a700:	7ffff3c0 	svcvc	0x00fff3c0
    a704:	00000001 	andeq	r0, r0, r1
    a708:	7ffff3d0 	svcvc	0x00fff3d0
    a70c:	7fffff54 	svcvc	0x00ffff54
    a710:	7ffff404 	svcvc	0x00fff404
    a714:	00000001 	andeq	r0, r0, r1
    a718:	7ffff640 	svcvc	0x00fff640
    a71c:	7fffff50 	svcvc	0x00ffff50
    a720:	7ffff6b0 	svcvc	0x00fff6b0
    a724:	00000001 	andeq	r0, r0, r1
    a728:	7ffff730 	svcvc	0x00fff730
    a72c:	7fffff4c 	svcvc	0x00ffff4c
    a730:	7ffff780 	svcvc	0x00fff780
    a734:	7fffff50 	svcvc	0x00ffff50
    a738:	7ffff7d0 	svcvc	0x00fff7d0
    a73c:	00000001 	andeq	r0, r0, r1

Disassembly of section .rodata:

0000a740 <_ZN3halL18Default_Clock_RateE>:
    a740:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

0000a744 <_ZN3halL15Peripheral_BaseE>:
    a744:	20000000 	andcs	r0, r0, r0

0000a748 <_ZN3halL9GPIO_BaseE>:
    a748:	20200000 	eorcs	r0, r0, r0

0000a74c <_ZN3halL14GPIO_Pin_CountE>:
    a74c:	00000036 	andeq	r0, r0, r6, lsr r0

0000a750 <_ZN3halL8AUX_BaseE>:
    a750:	20215000 	eorcs	r5, r1, r0

0000a754 <_ZN3halL25Interrupt_Controller_BaseE>:
    a754:	2000b200 	andcs	fp, r0, r0, lsl #4

0000a758 <_ZN3halL10Timer_BaseE>:
    a758:	2000b400 	andcs	fp, r0, r0, lsl #8

0000a75c <_ZN3halL18Default_Clock_RateE>:
    a75c:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

0000a760 <_ZN3halL15Peripheral_BaseE>:
    a760:	20000000 	andcs	r0, r0, r0

0000a764 <_ZN3halL9GPIO_BaseE>:
    a764:	20200000 	eorcs	r0, r0, r0

0000a768 <_ZN3halL14GPIO_Pin_CountE>:
    a768:	00000036 	andeq	r0, r0, r6, lsr r0

0000a76c <_ZN3halL8AUX_BaseE>:
    a76c:	20215000 	eorcs	r5, r1, r0

0000a770 <_ZN3halL25Interrupt_Controller_BaseE>:
    a770:	2000b200 	andcs	fp, r0, r0, lsl #4

0000a774 <_ZN3halL10Timer_BaseE>:
    a774:	2000b400 	andcs	fp, r0, r0, lsl #8

0000a778 <_ZZN8CMonitorlsEjE11BUFFER_SIZE>:
    a778:	00000010 	andeq	r0, r0, r0, lsl r0
    a77c:	65757274 	ldrbvs	r7, [r5, #-628]!	; 0xfffffd8c
    a780:	00000000 	andeq	r0, r0, r0
    a784:	736c6166 	cmnvc	ip, #-2147483623	; 0x80000019
    a788:	00000065 	andeq	r0, r0, r5, rrx
    a78c:	33323130 	teqcc	r2, #48, 2
    a790:	37363534 			; <UNDEFINED> instruction: 0x37363534
    a794:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    a798:	46454443 	strbmi	r4, [r5], -r3, asr #8
    a79c:	00000000 	andeq	r0, r0, r0

0000a7a0 <_ZN3halL18Default_Clock_RateE>:
    a7a0:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

0000a7a4 <_ZN3halL15Peripheral_BaseE>:
    a7a4:	20000000 	andcs	r0, r0, r0

0000a7a8 <_ZN3halL9GPIO_BaseE>:
    a7a8:	20200000 	eorcs	r0, r0, r0

0000a7ac <_ZN3halL14GPIO_Pin_CountE>:
    a7ac:	00000036 	andeq	r0, r0, r6, lsr r0

0000a7b0 <_ZN3halL8AUX_BaseE>:
    a7b0:	20215000 	eorcs	r5, r1, r0

0000a7b4 <_ZN3halL25Interrupt_Controller_BaseE>:
    a7b4:	2000b200 	andcs	fp, r0, r0, lsl #4

0000a7b8 <_ZN3halL10Timer_BaseE>:
    a7b8:	2000b400 	andcs	fp, r0, r0, lsl #8

0000a7bc <_ZN3halL18Default_Clock_RateE>:
    a7bc:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

0000a7c0 <_ZN3halL15Peripheral_BaseE>:
    a7c0:	20000000 	andcs	r0, r0, r0

0000a7c4 <_ZN3halL9GPIO_BaseE>:
    a7c4:	20200000 	eorcs	r0, r0, r0

0000a7c8 <_ZN3halL14GPIO_Pin_CountE>:
    a7c8:	00000036 	andeq	r0, r0, r6, lsr r0

0000a7cc <_ZN3halL8AUX_BaseE>:
    a7cc:	20215000 	eorcs	r5, r1, r0

0000a7d0 <_ZN3halL25Interrupt_Controller_BaseE>:
    a7d0:	2000b200 	andcs	fp, r0, r0, lsl #4

0000a7d4 <_ZN3halL10Timer_BaseE>:
    a7d4:	2000b400 	andcs	fp, r0, r0, lsl #8
    a7d8:	73657741 	cmnvc	r5, #17039360	; 0x1040000
    a7dc:	21656d6f 	cmncs	r5, pc, ror #26
    a7e0:	74654c20 	strbtvc	r4, [r5], #-3104	; 0xfffff3e0
    a7e4:	67207327 	strvs	r7, [r0, -r7, lsr #6]!
    a7e8:	73207465 			; <UNDEFINED> instruction: 0x73207465
    a7ec:	74726174 	ldrbtvc	r6, [r2], #-372	; 0xfffffe8c
    a7f0:	74206465 	strtvc	r6, [r0], #-1125	; 0xfffffb9b
    a7f4:	2e6e6568 	cdpcs	5, 6, cr6, cr14, cr8, {3}
    a7f8:	0d0a2e2e 	stceq	14, cr2, [sl, #-184]	; 0xffffff48
    a7fc:	00000000 	andeq	r0, r0, r0
    a800:	276e6f44 	strbcs	r6, [lr, -r4, asr #30]!
    a804:	6f772074 	svcvs	0x00772074
    a808:	2c797272 	lfmcs	f7, 2, [r9], #-456	; 0xfffffe38
    a80c:	20657720 	rsbcs	r7, r5, r0, lsr #14
    a810:	206e6163 	rsbcs	r6, lr, r3, ror #2
    a814:	61776c61 	cmnvs	r7, r1, ror #24
    a818:	70207379 	eorvc	r7, r0, r9, ror r3
    a81c:	2079616c 	rsbscs	r6, r9, ip, ror #2
    a820:	20656874 	rsbcs	r6, r5, r4, ror r8
    a824:	656d6167 	strbvs	r6, [sp, #-359]!	; 0xfffffe99
    a828:	78656e20 	stmdavc	r5!, {r5, r9, sl, fp, sp, lr}^
    a82c:	69742074 	ldmdbvs	r4!, {r2, r4, r5, r6, sp}^
    a830:	2021656d 	eorcs	r6, r1, sp, ror #10
    a834:	65766148 	ldrbvs	r6, [r6, #-328]!	; 0xfffffeb8
    a838:	67206120 	strvs	r6, [r0, -r0, lsr #2]!
    a83c:	20646f6f 	rsbcs	r6, r4, pc, ror #30
    a840:	20656e6f 	rsbcs	r6, r5, pc, ror #28
    a844:	0000293a 	andeq	r2, r0, sl, lsr r9
    a848:	79207349 	stmdbvc	r0!, {r0, r3, r6, r8, r9, ip, sp, lr}
    a84c:	2072756f 	rsbscs	r7, r2, pc, ror #10
    a850:	626d756e 	rsbvs	r7, sp, #461373440	; 0x1b800000
    a854:	67207265 	strvs	r7, [r0, -r5, ror #4]!
    a858:	74616572 	strbtvc	r6, [r1], #-1394	; 0xfffffa8e
    a85c:	74207265 	strtvc	r7, [r0], #-613	; 0xfffffd9b
    a860:	206e6168 	rsbcs	r6, lr, r8, ror #2
    a864:	00000000 	andeq	r0, r0, r0
    a868:	795b203f 	ldmdbvc	fp, {r0, r1, r2, r3, r4, r5, sp}^
    a86c:	3a5d6e2f 	bcc	1766130 <_bss_end+0x175b6a8>
    a870:	00000020 	andeq	r0, r0, r0, lsr #32
    a874:	20656854 	rsbcs	r6, r5, r4, asr r8
    a878:	626d756e 	rsbvs	r7, sp, #461373440	; 0x1b800000
    a87c:	79207265 	stmdbvc	r0!, {r0, r2, r5, r6, r9, ip, sp, lr}
    a880:	7227756f 	eorvc	r7, r7, #465567744	; 0x1bc00000
    a884:	68742065 	ldmdavs	r4!, {r0, r2, r5, r6, sp}^
    a888:	696b6e69 	stmdbvs	fp!, {r0, r3, r5, r6, r9, sl, fp, sp, lr}^
    a88c:	6f20676e 	svcvs	0x0020676e
    a890:	756d2066 	strbvc	r2, [sp, #-102]!	; 0xffffff9a
    a894:	62207473 	eorvs	r7, r0, #1929379840	; 0x73000000
    a898:	00002065 	andeq	r2, r0, r5, rrx
    a89c:	000d0a21 	andeq	r0, sp, r1, lsr #20
    a8a0:	79206f44 	stmdbvc	r0!, {r2, r6, r8, r9, sl, fp, sp, lr}
    a8a4:	7720756f 	strvc	r7, [r0, -pc, ror #10]!
    a8a8:	616e6e61 	cmnvs	lr, r1, ror #28
    a8ac:	616c7020 	cmnvs	ip, r0, lsr #32
    a8b0:	67612079 			; <UNDEFINED> instruction: 0x67612079
    a8b4:	3f6e6961 	svccc	0x006e6961
    a8b8:	2f795b20 	svccs	0x00795b20
    a8bc:	203a5d6e 	eorscs	r5, sl, lr, ror #26
    a8c0:	00000000 	andeq	r0, r0, r0
    a8c4:	20656553 	rsbcs	r6, r5, r3, asr r5
    a8c8:	20756f79 	rsbscs	r6, r5, r9, ror pc
    a8cc:	7478656e 	ldrbtvc	r6, [r8], #-1390	; 0xfffffa92
    a8d0:	6d697420 	cfstrdvs	mvd7, [r9, #-128]!	; 0xffffff80
    a8d4:	0d0a2165 	stfeqs	f2, [sl, #-404]	; 0xfffffe6c
    a8d8:	00000000 	andeq	r0, r0, r0

0000a8dc <_ZN3halL18Default_Clock_RateE>:
    a8dc:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

0000a8e0 <_ZN3halL15Peripheral_BaseE>:
    a8e0:	20000000 	andcs	r0, r0, r0

0000a8e4 <_ZN3halL9GPIO_BaseE>:
    a8e4:	20200000 	eorcs	r0, r0, r0

0000a8e8 <_ZN3halL14GPIO_Pin_CountE>:
    a8e8:	00000036 	andeq	r0, r0, r6, lsr r0

0000a8ec <_ZN3halL8AUX_BaseE>:
    a8ec:	20215000 	eorcs	r5, r1, r0

0000a8f0 <_ZN3halL25Interrupt_Controller_BaseE>:
    a8f0:	2000b200 	andcs	fp, r0, r0, lsl #4

0000a8f4 <_ZN3halL10Timer_BaseE>:
    a8f4:	2000b400 	andcs	fp, r0, r0, lsl #8
    a8f8:	636c6557 	cmnvs	ip, #364904448	; 0x15c00000
    a8fc:	20656d6f 	rsbcs	r6, r5, pc, ror #26
    a900:	61206f74 			; <UNDEFINED> instruction: 0x61206f74
    a904:	65756720 	ldrbvs	r6, [r5, #-1824]!	; 0xfffff8e0
    a908:	6e697373 	mcrvs	3, 3, r7, cr9, cr3, {3}
    a90c:	61672067 	cmnvs	r7, r7, rrx
    a910:	0d21656d 	cfstr32eq	mvfx6, [r1, #-436]!	; 0xfffffe4c
    a914:	0000000a 	andeq	r0, r0, sl
    a918:	2d2d2d2d 	stccs	13, cr2, [sp, #-180]!	; 0xffffff4c
    a91c:	2d2d2d2d 	stccs	13, cr2, [sp, #-180]!	; 0xffffff4c
    a920:	2d2d2d2d 	stccs	13, cr2, [sp, #-180]!	; 0xffffff4c
    a924:	2d2d2d2d 	stccs	13, cr2, [sp, #-180]!	; 0xffffff4c
    a928:	2d2d2d2d 	stccs	13, cr2, [sp, #-180]!	; 0xffffff4c
    a92c:	2d2d2d2d 	stccs	13, cr2, [sp, #-180]!	; 0xffffff4c
    a930:	0d2d2d2d 	stceq	13, cr2, [sp, #-180]!	; 0xffffff4c
    a934:	0000000a 	andeq	r0, r0, sl
    a938:	6e696854 	mcrvs	8, 3, r6, cr9, cr4, {2}
    a93c:	666f206b 	strbtvs	r2, [pc], -fp, rrx
    a940:	6e206120 	sufvssp	f6, f0, f0
    a944:	65626d75 	strbvs	r6, [r2, #-3445]!	; 0xfffff28b
    a948:	65622072 	strbvs	r2, [r2, #-114]!	; 0xffffff8e
    a94c:	65657774 	strbvs	r7, [r5, #-1908]!	; 0xfffff88c
    a950:	2031206e 	eorscs	r2, r1, lr, rrx
    a954:	20646e61 	rsbcs	r6, r4, r1, ror #28
    a958:	20303031 	eorscs	r3, r0, r1, lsr r0
    a95c:	20646e61 	rsbcs	r6, r4, r1, ror #28
    a960:	206d2749 	rsbcs	r2, sp, r9, asr #14
    a964:	6e6e6f67 	cdpvs	15, 6, cr6, cr14, cr7, {3}
    a968:	75672061 	strbvc	r2, [r7, #-97]!	; 0xffffff9f
    a96c:	20737365 	rsbscs	r7, r3, r5, ror #6
    a970:	74616877 	strbtvc	r6, [r1], #-2167	; 0xfffff789
    a974:	20746920 	rsbscs	r6, r4, r0, lsr #18
    a978:	202e7369 	eorcs	r7, lr, r9, ror #6
    a97c:	206c6c41 	rsbcs	r6, ip, r1, asr #24
    a980:	20756f79 	rsbscs	r6, r5, r9, ror pc
    a984:	74746f67 	ldrbtvc	r6, [r4], #-3943	; 0xfffff099
    a988:	6f642061 	svcvs	0x00642061
    a98c:	20736920 	rsbscs	r6, r3, r0, lsr #18
    a990:	74206f74 	strtvc	r6, [r0], #-3956	; 0xfffff08c
    a994:	206c6c65 	rsbcs	r6, ip, r5, ror #24
    a998:	7720656d 	strvc	r6, [r0, -sp, ror #10]!
    a99c:	68746568 	ldmdavs	r4!, {r3, r5, r6, r8, sl, sp, lr}^
    a9a0:	6d207265 	sfmvs	f7, 4, [r0, #-404]!	; 0xfffffe6c
    a9a4:	75672079 	strbvc	r2, [r7, #-121]!	; 0xffffff87
    a9a8:	20737365 	rsbscs	r7, r3, r5, ror #6
    a9ac:	6c207369 	stcvs	3, cr7, [r0], #-420	; 0xfffffe5c
    a9b0:	65677261 	strbvs	r7, [r7, #-609]!	; 0xfffffd9f
    a9b4:	68742072 	ldmdavs	r4!, {r1, r4, r5, r6, sp}^
    a9b8:	79206e61 	stmdbvc	r0!, {r0, r5, r6, r9, sl, fp, sp, lr}
    a9bc:	2072756f 	rsbscs	r7, r2, pc, ror #10
    a9c0:	626d756e 	rsbvs	r7, sp, #461373440	; 0x1b800000
    a9c4:	6f207265 	svcvs	0x00207265
    a9c8:	68632066 	stmdavs	r3!, {r1, r2, r5, r6, sp}^
    a9cc:	6563696f 	strbvs	r6, [r3, #-2415]!	; 0xfffff691
    a9d0:	20726f20 	rsbscs	r6, r2, r0, lsr #30
    a9d4:	2c746f6e 	ldclcs	15, cr6, [r4], #-440	; 0xfffffe48
    a9d8:	616b6f20 	cmnvs	fp, r0, lsr #30
    a9dc:	5b203f79 	blpl	81a7c8 <_bss_end+0x80fd40>
    a9e0:	5d6e2f79 	stclpl	15, cr2, [lr, #-484]!	; 0xfffffe1c
    a9e4:	0000203a 	andeq	r2, r0, sl, lsr r0

0000a9e8 <_ZN12_GLOBAL__N_1L11CharConvArrE>:
    a9e8:	33323130 	teqcc	r2, #48, 2
    a9ec:	37363534 			; <UNDEFINED> instruction: 0x37363534
    a9f0:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    a9f4:	46454443 	strbmi	r4, [r5], -r3, asr #8
	...

Disassembly of section .data:

0000a9fc <__CTOR_LIST__>:
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:2355
    a9fc:	00008318 	andeq	r8, r0, r8, lsl r3
    aa00:	00008b54 	andeq	r8, r0, r4, asr fp
    aa04:	0000919c 	muleq	r0, ip, r1
    aa08:	00009770 	andeq	r9, r0, r0, ror r7
    aa0c:	00009d3c 	andeq	r9, r0, ip, lsr sp

0000aa10 <__DTOR_LIST__>:
__DTOR_END__():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:8
volatile unsigned int max_num = 100;
    aa10:	00000064 	andeq	r0, r0, r4, rrx

0000aa14 <min_num>:
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:9
volatile unsigned int min_num = 1;
    aa14:	00000001 	andeq	r0, r0, r1

Disassembly of section .bss:

0000aa18 <sAUX>:
_bss_start():
    aa18:	00000000 	andeq	r0, r0, r0

0000aa1c <sGPIO>:
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:4
CGPIO_Handler sGPIO(hal::GPIO_Base);
    aa1c:	00000000 	andeq	r0, r0, r0

0000aa20 <sMonitor>:
	...

0000aa38 <_ZZN8CMonitorlsEjE8s_buffer>:
	...

0000aa48 <sUART0>:
_ZZN8CMonitorlsEjE8s_buffer():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:6
CUART sUART0(sAUX);
    aa48:	00000000 	andeq	r0, r0, r0

0000aa4c <_ZZN5CUART5WriteEjE3buf>:
	...

0000aa5c <_ZZN5CUART9Write_HexEjE3buf>:
	...

0000aa6c <game_state>:
_ZZN5CUART9Write_HexEjE3buf():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:7
volatile int game_state = 0;
    aa6c:	00000000 	andeq	r0, r0, r0

0000aa70 <middle>:
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:10
volatile unsigned int middle;
    aa70:	00000000 	andeq	r0, r0, r0

0000aa74 <sInterruptCtl>:
	...

Disassembly of section .debug_info:

00000000 <.debug_info>:
       0:	00000126 	andeq	r0, r0, r6, lsr #2
       4:	00000004 	andeq	r0, r0, r4
       8:	01040000 	mrseq	r0, (UNDEF: 4)
       c:	000000b5 	strheq	r0, [r0], -r5
      10:	00002604 	andeq	r2, r0, r4, lsl #12
      14:	00007400 	andeq	r7, r0, r0, lsl #8
      18:	00809400 	addeq	r9, r0, r0, lsl #8
      1c:	0000d800 	andeq	sp, r0, r0, lsl #16
      20:	00000000 	andeq	r0, r0, r0
      24:	01980200 	orrseq	r0, r8, r0, lsl #4
      28:	28010000 	stmdacs	r1, {}	; <UNPREDICTABLE>
      2c:	00816011 	addeq	r6, r1, r1, lsl r0
      30:	00000c00 	andeq	r0, r0, r0, lsl #24
      34:	029c0100 	addseq	r0, ip, #0, 2
      38:	00000185 	andeq	r0, r0, r5, lsl #3
      3c:	48112301 	ldmdami	r1, {r0, r8, r9, sp}
      40:	18000081 	stmdane	r0, {r0, r7}
      44:	01000000 	mrseq	r0, (UNDEF: 0)
      48:	014c029c 			; <UNDEFINED> instruction: 0x014c029c
      4c:	1e010000 	cdpne	0, 0, cr0, cr1, cr0, {0}
      50:	00813011 	addeq	r3, r1, r1, lsl r0
      54:	00001800 	andeq	r1, r0, r0, lsl #16
      58:	029c0100 	addseq	r0, ip, #0, 2
      5c:	00000159 	andeq	r0, r0, r9, asr r1
      60:	18111901 	ldmdane	r1, {r0, r8, fp, ip}
      64:	18000081 	stmdane	r0, {r0, r7}
      68:	01000000 	mrseq	r0, (UNDEF: 0)
      6c:	017a039c 			; <UNDEFINED> instruction: 0x017a039c
      70:	00020000 	andeq	r0, r2, r0
      74:	000000bb 	strheq	r0, [r0], -fp
      78:	00001404 	andeq	r1, r0, r4, lsl #8
      7c:	15140100 	ldrne	r0, [r4, #-256]	; 0xffffff00
      80:	0000008a 	andeq	r0, r0, sl, lsl #1
      84:	0000bb05 	andeq	fp, r0, r5, lsl #22
      88:	af060000 	svcge	0x00060000
      8c:	01000001 	tsteq	r0, r1
      90:	00c11f04 	sbceq	r1, r1, r4, lsl #30
      94:	00040000 	andeq	r0, r4, r0
      98:	01000000 	mrseq	r0, (UNDEF: 0)
      9c:	00a8150f 	adceq	r1, r8, pc, lsl #10
      a0:	bb050000 	bllt	1400a8 <_bss_end+0x135620>
      a4:	00000000 	andeq	r0, r0, r0
      a8:	00016607 	andeq	r6, r1, r7, lsl #12
      ac:	140a0100 	strne	r0, [sl], #-256	; 0xffffff00
      b0:	00000105 	andeq	r0, r0, r5, lsl #2
      b4:	0000bb05 	andeq	fp, r0, r5, lsl #22
      b8:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
      bc:	00008a04 	andeq	r8, r0, r4, lsl #20
      c0:	05080900 	streq	r0, [r8, #-2304]	; 0xfffff700
      c4:	000001b7 			; <UNDEFINED> instruction: 0x000001b7
      c8:	0000780a 	andeq	r7, r0, sl, lsl #16
      cc:	0080f800 	addeq	pc, r0, r0, lsl #16
      d0:	00002000 	andeq	r2, r0, r0
      d4:	e49c0100 	ldr	r0, [ip], #256	; 0x100
      d8:	0b000000 	bleq	e0 <CPSR_IRQ_INHIBIT+0x60>
      dc:	000000bb 	strheq	r0, [r0], -fp
      e0:	00749102 	rsbseq	r9, r4, r2, lsl #2
      e4:	0000960a 	andeq	r9, r0, sl, lsl #12
      e8:	0080cc00 	addeq	ip, r0, r0, lsl #24
      ec:	00002c00 	andeq	r2, r0, r0, lsl #24
      f0:	059c0100 	ldreq	r0, [ip, #256]	; 0x100
      f4:	0c000001 	stceq	0, cr0, [r0], {1}
      f8:	0f010067 	svceq	0x00010067
      fc:	0000bb32 	andeq	fp, r0, r2, lsr fp
     100:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     104:	05040d00 	streq	r0, [r4, #-3328]	; 0xfffff300
     108:	00746e69 	rsbseq	r6, r4, r9, ror #28
     10c:	0000a80e 	andeq	sl, r0, lr, lsl #16
     110:	00809400 	addeq	r9, r0, r0, lsl #8
     114:	00003800 	andeq	r3, r0, r0, lsl #16
     118:	0c9c0100 	ldfeqs	f0, [ip], {0}
     11c:	0a010067 	beq	402c0 <_bss_end+0x35838>
     120:	0000bb31 	andeq	fp, r0, r1, lsr fp
     124:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     128:	04380000 	ldrteq	r0, [r8], #-0
     12c:	00040000 	andeq	r0, r4, r0
     130:	000000d0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     134:	00b50104 	adcseq	r0, r5, r4, lsl #2
     138:	c5040000 	strgt	r0, [r4, #-0]
     13c:	74000001 	strvc	r0, [r0], #-1
     140:	6c000000 	stcvs	0, cr0, [r0], {-0}
     144:	c8000081 	stmdagt	r0, {r0, r7}
     148:	af000001 	svcge	0x00000001
     14c:	02000000 	andeq	r0, r0, #0
     150:	036a0801 	cmneq	sl, #65536	; 0x10000
     154:	02020000 	andeq	r0, r2, #0
     158:	00022a05 	andeq	r2, r2, r5, lsl #20
     15c:	05040300 	streq	r0, [r4, #-768]	; 0xfffffd00
     160:	00746e69 	rsbseq	r6, r4, r9, ror #28
     164:	61080102 	tstvs	r8, r2, lsl #2
     168:	02000003 	andeq	r0, r0, #3
     16c:	03b60702 			; <UNDEFINED> instruction: 0x03b60702
     170:	94040000 	strls	r0, [r4], #-0
     174:	04000003 	streq	r0, [r0], #-3
     178:	0059070b 	subseq	r0, r9, fp, lsl #14
     17c:	48050000 	stmdami	r5, {}	; <UNPREDICTABLE>
     180:	02000000 	andeq	r0, r0, #0
     184:	19fd0704 	ldmibne	sp!, {r2, r8, r9, sl}^
     188:	59050000 	stmdbpl	r5, {}	; <UNPREDICTABLE>
     18c:	06000000 	streq	r0, [r0], -r0
     190:	006c6168 	rsbeq	r6, ip, r8, ror #2
     194:	a10b0702 	tstge	fp, r2, lsl #14
     198:	07000001 	streq	r0, [r0, -r1]
     19c:	000004b6 			; <UNDEFINED> instruction: 0x000004b6
     1a0:	601c0902 	andsvs	r0, ip, r2, lsl #18
     1a4:	80000000 	andhi	r0, r0, r0
     1a8:	070ee6b2 			; <UNDEFINED> instruction: 0x070ee6b2
     1ac:	0000032c 	andeq	r0, r0, ip, lsr #6
     1b0:	ad1d0c02 	ldcge	12, cr0, [sp, #-8]
     1b4:	00000001 	andeq	r0, r0, r1
     1b8:	07200000 	streq	r0, [r0, -r0]!
     1bc:	0000037d 	andeq	r0, r0, sp, ror r3
     1c0:	ad1d0f02 	ldcge	15, cr0, [sp, #-8]
     1c4:	00000001 	andeq	r0, r0, r1
     1c8:	08202000 	stmdaeq	r0!, {sp}
     1cc:	000003f4 	strdeq	r0, [r0], -r4
     1d0:	54181202 	ldrpl	r1, [r8], #-514	; 0xfffffdfe
     1d4:	36000000 	strcc	r0, [r0], -r0
     1d8:	00047807 	andeq	r7, r4, r7, lsl #16
     1dc:	1d440200 	sfmne	f0, 2, [r4, #-0]
     1e0:	000001ad 	andeq	r0, r0, sp, lsr #3
     1e4:	20215000 	eorcs	r5, r1, r0
     1e8:	00024909 	andeq	r4, r2, r9, lsl #18
     1ec:	33040500 	movwcc	r0, #17664	; 0x4500
     1f0:	02000000 	andeq	r0, r0, #0
     1f4:	015b1046 	cmpeq	fp, r6, asr #32
     1f8:	490a0000 	stmdbmi	sl, {}	; <UNPREDICTABLE>
     1fc:	00005152 	andeq	r5, r0, r2, asr r1
     200:	0002860b 	andeq	r8, r2, fp, lsl #12
     204:	980b0100 	stmdals	fp, {r8}
     208:	10000004 	andne	r0, r0, r4
     20c:	00036f0b 	andeq	r6, r3, fp, lsl #30
     210:	9d0b1100 	stflss	f1, [fp, #-0]
     214:	12000003 	andne	r0, r0, #3
     218:	0003d10b 	andeq	sp, r3, fp, lsl #2
     21c:	760b1300 	strvc	r1, [fp], -r0, lsl #6
     220:	14000003 	strne	r0, [r0], #-3
     224:	0004a70b 	andeq	sl, r4, fp, lsl #14
     228:	640b1500 	strvs	r1, [fp], #-1280	; 0xfffffb00
     22c:	16000004 	strne	r0, [r0], -r4
     230:	0004f20b 	andeq	pc, r4, fp, lsl #4
     234:	a40b1700 	strge	r1, [fp], #-1792	; 0xfffff900
     238:	18000003 	stmdane	r0, {r0, r1}
     23c:	0004810b 	andeq	r8, r4, fp, lsl #2
     240:	e20b1900 	and	r1, fp, #0, 18
     244:	1a000003 	bne	258 <CPSR_IRQ_INHIBIT+0x1d8>
     248:	0003160b 	andeq	r1, r3, fp, lsl #12
     24c:	210b2000 	mrscs	r2, (UNDEF: 11)
     250:	21000003 	tstcs	r0, r3
     254:	0003ea0b 	andeq	lr, r3, fp, lsl #20
     258:	fa0b2200 	blx	2c8a60 <_bss_end+0x2bdfd8>
     25c:	24000002 	strcs	r0, [r0], #-2
     260:	0003d80b 	andeq	sp, r3, fp, lsl #16
     264:	4b0b2500 	blmi	2c966c <_bss_end+0x2bebe4>
     268:	30000003 	andcc	r0, r0, r3
     26c:	0003560b 	andeq	r5, r3, fp, lsl #12
     270:	3e0b3100 	adfcce	f3, f3, f0
     274:	32000002 	andcc	r0, r0, #2
     278:	0003c90b 	andeq	ip, r3, fp, lsl #18
     27c:	340b3400 	strcc	r3, [fp], #-1024	; 0xfffffc00
     280:	35000002 	strcc	r0, [r0, #-2]
     284:	02b60900 	adcseq	r0, r6, #0, 18
     288:	04050000 	streq	r0, [r5], #-0
     28c:	00000033 	andeq	r0, r0, r3, lsr r0
     290:	80106c02 	andshi	r6, r0, r2, lsl #24
     294:	0b000001 	bleq	2a0 <CPSR_IRQ_INHIBIT+0x220>
     298:	0000049e 	muleq	r0, lr, r4
     29c:	03ac0b00 			; <UNDEFINED> instruction: 0x03ac0b00
     2a0:	0b010000 	bleq	402a8 <_bss_end+0x35820>
     2a4:	000003b1 			; <UNDEFINED> instruction: 0x000003b1
     2a8:	3d070002 	stccc	0, cr0, [r7, #-8]
     2ac:	02000004 	andeq	r0, r0, #4
     2b0:	01ad1d73 			; <UNDEFINED> instruction: 0x01ad1d73
     2b4:	b2000000 	andlt	r0, r0, #0
     2b8:	1f072000 	svcne	0x00072000
     2bc:	02000002 	andeq	r0, r0, #2
     2c0:	01ad1da6 			; <UNDEFINED> instruction: 0x01ad1da6
     2c4:	b4000000 	strlt	r0, [r0], #-0
     2c8:	0c002000 	stceq	0, cr2, [r0], {-0}
     2cc:	00000071 	andeq	r0, r0, r1, ror r0
     2d0:	f8070402 			; <UNDEFINED> instruction: 0xf8070402
     2d4:	05000019 	streq	r0, [r0, #-25]	; 0xffffffe7
     2d8:	000001a6 	andeq	r0, r0, r6, lsr #3
     2dc:	0000810c 	andeq	r8, r0, ip, lsl #2
     2e0:	00910c00 	addseq	r0, r1, r0, lsl #24
     2e4:	a10c0000 	mrsge	r0, (UNDEF: 12)
     2e8:	0c000000 	stceq	0, cr0, [r0], {-0}
     2ec:	000000ae 	andeq	r0, r0, lr, lsr #1
     2f0:	0001800c 	andeq	r8, r1, ip
     2f4:	01900c00 	orrseq	r0, r0, r0, lsl #24
     2f8:	d00d0000 	andle	r0, sp, r0
     2fc:	0400000d 	streq	r0, [r0], #-13
     300:	94070603 	strls	r0, [r7], #-1539	; 0xfffff9fd
     304:	0e000002 	cdpeq	0, 0, cr0, cr0, cr2, {0}
     308:	00000248 	andeq	r0, r0, r8, asr #4
     30c:	9a190a03 	bls	642b20 <_bss_end+0x638098>
     310:	00000002 	andeq	r0, r0, r2
     314:	000dd00f 	andeq	sp, sp, pc
     318:	050d0300 	streq	r0, [sp, #-768]	; 0xfffffd00
     31c:	000002c6 	andeq	r0, r0, r6, asr #5
     320:	0000029f 	muleq	r0, pc, r2	; <UNPREDICTABLE>
     324:	00020301 	andeq	r0, r2, r1, lsl #6
     328:	00020e00 	andeq	r0, r2, r0, lsl #28
     32c:	029f1000 	addseq	r1, pc, #0
     330:	59110000 	ldmdbpl	r1, {}	; <UNPREDICTABLE>
     334:	00000000 	andeq	r0, r0, r0
     338:	0012f512 	andseq	pc, r2, r2, lsl r5	; <UNPREDICTABLE>
     33c:	0a100300 	beq	400f44 <_bss_end+0x3f64bc>
     340:	0000028e 	andeq	r0, r0, lr, lsl #5
     344:	00022301 	andeq	r2, r2, r1, lsl #6
     348:	00022e00 	andeq	r2, r2, r0, lsl #28
     34c:	029f1000 	addseq	r1, pc, #0
     350:	5b110000 	blpl	440358 <_bss_end+0x4358d0>
     354:	00000001 	andeq	r0, r0, r1
     358:	0011d512 	andseq	sp, r1, r2, lsl r5
     35c:	0a120300 	beq	480f64 <_bss_end+0x4764dc>
     360:	000004c9 	andeq	r0, r0, r9, asr #9
     364:	00024301 	andeq	r4, r2, r1, lsl #6
     368:	00024e00 	andeq	r4, r2, r0, lsl #28
     36c:	029f1000 	addseq	r1, pc, #0
     370:	5b110000 	blpl	440378 <_bss_end+0x4358f0>
     374:	00000001 	andeq	r0, r0, r1
     378:	00045712 	andeq	r5, r4, r2, lsl r7
     37c:	0a150300 	beq	540f84 <_bss_end+0x5364fc>
     380:	000002d3 	ldrdeq	r0, [r0], -r3
     384:	00026301 	andeq	r6, r2, r1, lsl #6
     388:	00027300 	andeq	r7, r2, r0, lsl #6
     38c:	029f1000 	addseq	r1, pc, #0
     390:	be110000 	cdplt	0, 1, cr0, cr1, cr0, {0}
     394:	11000000 	mrsne	r0, (UNDEF: 0)
     398:	00000048 	andeq	r0, r0, r8, asr #32
     39c:	046b1300 	strbteq	r1, [fp], #-768	; 0xfffffd00
     3a0:	17030000 	strne	r0, [r3, -r0]
     3a4:	0002510e 	andeq	r5, r2, lr, lsl #2
     3a8:	00004800 	andeq	r4, r0, r0, lsl #16
     3ac:	02880100 	addeq	r0, r8, #0, 2
     3b0:	9f100000 	svcls	0x00100000
     3b4:	11000002 	tstne	r0, r2
     3b8:	000000be 	strheq	r0, [r0], -lr
     3bc:	04140000 	ldreq	r0, [r4], #-0
     3c0:	00000059 	andeq	r0, r0, r9, asr r0
     3c4:	00029405 	andeq	r9, r2, r5, lsl #8
     3c8:	d0041400 	andle	r1, r4, r0, lsl #8
     3cc:	05000001 	streq	r0, [r0, #-1]
     3d0:	0000029f 	muleq	r0, pc, r2	; <UNPREDICTABLE>
     3d4:	00031115 	andeq	r1, r3, r5, lsl r1
     3d8:	0d1a0300 	ldceq	3, cr0, [sl, #-0]
     3dc:	000001d0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     3e0:	0002aa16 	andeq	sl, r2, r6, lsl sl
     3e4:	06030100 	streq	r0, [r3], -r0, lsl #2
     3e8:	aa180305 	bge	601004 <_bss_end+0x5f657c>
     3ec:	02170000 	andseq	r0, r7, #0
     3f0:	18000003 	stmdane	r0, {r0, r1}
     3f4:	1c000083 	stcne	0, cr0, [r0], {131}	; 0x83
     3f8:	01000000 	mrseq	r0, (UNDEF: 0)
     3fc:	0403189c 	streq	r1, [r3], #-2204	; 0xfffff764
     400:	82c40000 	sbchi	r0, r4, #0
     404:	00540000 	subseq	r0, r4, r0
     408:	9c010000 	stcls	0, cr0, [r1], {-0}
     40c:	00000305 	andeq	r0, r0, r5, lsl #6
     410:	00033c19 	andeq	r3, r3, r9, lsl ip
     414:	011f0100 	tsteq	pc, r0, lsl #2
     418:	00000033 	andeq	r0, r0, r3, lsr r0
     41c:	19749102 	ldmdbne	r4!, {r1, r8, ip, pc}^
     420:	0000042d 	andeq	r0, r0, sp, lsr #8
     424:	33011f01 	movwcc	r1, #7937	; 0x1f01
     428:	02000000 	andeq	r0, r0, #0
     42c:	1a007091 	bne	1c678 <_bss_end+0x11bf0>
     430:	00000273 	andeq	r0, r0, r3, ror r2
     434:	1f0a1c01 	svcne	0x000a1c01
     438:	88000003 	stmdahi	r0, {r0, r1}
     43c:	3c000082 	stccc	0, cr0, [r0], {130}	; 0x82
     440:	01000000 	mrseq	r0, (UNDEF: 0)
     444:	00033b9c 	muleq	r3, ip, fp
     448:	04381b00 	ldrteq	r1, [r8], #-2816	; 0xfffff500
     44c:	02a50000 	adceq	r0, r5, #0
     450:	91020000 	mrsls	r0, (UNDEF: 2)
     454:	04ae1974 	strteq	r1, [lr], #2420	; 0x974
     458:	1c010000 	stcne	0, cr0, [r1], {-0}
     45c:	0000be2a 	andeq	fp, r0, sl, lsr #28
     460:	70910200 	addsvc	r0, r1, r0, lsl #4
     464:	024e1a00 	subeq	r1, lr, #0, 20
     468:	17010000 	strne	r0, [r1, -r0]
     46c:	00035506 	andeq	r5, r3, r6, lsl #10
     470:	00824400 	addeq	r4, r2, r0, lsl #8
     474:	00004400 	andeq	r4, r0, r0, lsl #8
     478:	809c0100 	addshi	r0, ip, r0, lsl #2
     47c:	1b000003 	blne	490 <CPSR_IRQ_INHIBIT+0x410>
     480:	00000438 	andeq	r0, r0, r8, lsr r4
     484:	000002a5 	andeq	r0, r0, r5, lsr #5
     488:	19749102 	ldmdbne	r4!, {r1, r8, ip, pc}^
     48c:	000004ae 	andeq	r0, r0, lr, lsr #9
     490:	be261701 	cdplt	7, 2, cr1, cr6, cr1, {0}
     494:	02000000 	andeq	r0, r0, #0
     498:	77197091 			; <UNDEFINED> instruction: 0x77197091
     49c:	01000002 	tsteq	r0, r2
     4a0:	00483817 	subeq	r3, r8, r7, lsl r8
     4a4:	91020000 	mrsls	r0, (UNDEF: 2)
     4a8:	2e1c006c 	cdpcs	0, 1, cr0, cr12, cr12, {3}
     4ac:	01000002 	tsteq	r0, r2
     4b0:	039a0611 	orrseq	r0, sl, #17825792	; 0x1100000
     4b4:	81f00000 	mvnshi	r0, r0
     4b8:	00540000 	subseq	r0, r4, r0
     4bc:	9c010000 	stcls	0, cr0, [r1], {-0}
     4c0:	000003b6 			; <UNDEFINED> instruction: 0x000003b6
     4c4:	0004381b 	andeq	r3, r4, fp, lsl r8
     4c8:	0002a500 	andeq	sl, r2, r0, lsl #10
     4cc:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     4d0:	00048919 	andeq	r8, r4, r9, lsl r9
     4d4:	29110100 	ldmdbcs	r1, {r8}
     4d8:	0000015b 	andeq	r0, r0, fp, asr r1
     4dc:	00709102 	rsbseq	r9, r0, r2, lsl #2
     4e0:	00020e1c 	andeq	r0, r2, ip, lsl lr
     4e4:	060b0100 	streq	r0, [fp], -r0, lsl #2
     4e8:	000003d0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     4ec:	000081a0 	andeq	r8, r0, r0, lsr #3
     4f0:	00000050 	andeq	r0, r0, r0, asr r0
     4f4:	03ec9c01 	mvneq	r9, #256	; 0x100
     4f8:	381b0000 	ldmdacc	fp, {}	; <UNPREDICTABLE>
     4fc:	a5000004 	strge	r0, [r0, #-4]
     500:	02000002 	andeq	r0, r0, #2
     504:	89197491 	ldmdbhi	r9, {r0, r4, r7, sl, ip, sp, lr}
     508:	01000004 	tsteq	r0, r4
     50c:	015b280b 	cmpeq	fp, fp, lsl #16
     510:	91020000 	mrsls	r0, (UNDEF: 2)
     514:	ea1d0070 	b	7406dc <_bss_end+0x735c54>
     518:	01000001 	tsteq	r0, r1
     51c:	03fd0105 	mvnseq	r0, #1073741825	; 0x40000001
     520:	13000000 	movwne	r0, #0
     524:	1e000004 	cdpne	0, 0, cr0, cr0, cr4, {0}
     528:	00000438 	andeq	r0, r0, r8, lsr r4
     52c:	000002a5 	andeq	r0, r0, r5, lsr #5
     530:	00027d1f 	andeq	r7, r2, pc, lsl sp
     534:	19050100 	stmdbne	r5, {r8}
     538:	00000059 	andeq	r0, r0, r9, asr r0
     53c:	03ec2000 	mvneq	r2, #0
     540:	03870000 	orreq	r0, r7, #0
     544:	042a0000 	strteq	r0, [sl], #-0
     548:	816c0000 	cmnhi	ip, r0
     54c:	00340000 	eorseq	r0, r4, r0
     550:	9c010000 	stcls	0, cr0, [r1], {-0}
     554:	0003fd21 	andeq	pc, r3, r1, lsr #26
     558:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     55c:	00040621 	andeq	r0, r4, r1, lsr #12
     560:	70910200 	addsvc	r0, r1, r0, lsl #4
     564:	099f0000 	ldmibeq	pc, {}	; <UNPREDICTABLE>
     568:	00040000 	andeq	r0, r4, r0
     56c:	000002e5 	andeq	r0, r0, r5, ror #5
     570:	00b50104 	adcseq	r0, r5, r4, lsl #2
     574:	a7040000 	strge	r0, [r4, -r0]
     578:	74000008 	strvc	r0, [r0], #-8
     57c:	34000000 	strcc	r0, [r0], #-0
     580:	3c000083 	stccc	0, cr0, [r0], {131}	; 0x83
     584:	68000008 	stmdavs	r0, {r3}
     588:	02000002 	andeq	r0, r0, #2
     58c:	036a0801 	cmneq	sl, #65536	; 0x10000
     590:	02020000 	andeq	r0, r2, #0
     594:	00022a05 	andeq	r2, r2, r5, lsl #20
     598:	05040300 	streq	r0, [r4, #-768]	; 0xfffffd00
     59c:	00746e69 	rsbseq	r6, r4, r9, ror #28
     5a0:	00065a04 	andeq	r5, r6, r4, lsl #20
     5a4:	07090200 	streq	r0, [r9, -r0, lsl #4]
     5a8:	00000046 	andeq	r0, r0, r6, asr #32
     5ac:	61080102 	tstvs	r8, r2, lsl #2
     5b0:	02000003 	andeq	r0, r0, #3
     5b4:	03b60702 			; <UNDEFINED> instruction: 0x03b60702
     5b8:	94040000 	strls	r0, [r4], #-0
     5bc:	02000003 	andeq	r0, r0, #3
     5c0:	0065070b 	rsbeq	r0, r5, fp, lsl #14
     5c4:	54050000 	strpl	r0, [r5], #-0
     5c8:	02000000 	andeq	r0, r0, #0
     5cc:	19fd0704 	ldmibne	sp!, {r2, r8, r9, sl}^
     5d0:	65050000 	strvs	r0, [r5, #-0]
     5d4:	06000000 	streq	r0, [r0], -r0
     5d8:	006c6168 	rsbeq	r6, ip, r8, ror #2
     5dc:	ac0b0703 	stcge	7, cr0, [fp], {3}
     5e0:	07000001 	streq	r0, [r0, -r1]
     5e4:	000004b6 			; <UNDEFINED> instruction: 0x000004b6
     5e8:	6c1c0903 			; <UNDEFINED> instruction: 0x6c1c0903
     5ec:	80000000 	andhi	r0, r0, r0
     5f0:	070ee6b2 			; <UNDEFINED> instruction: 0x070ee6b2
     5f4:	0000032c 	andeq	r0, r0, ip, lsr #6
     5f8:	b81d0c03 	ldmdalt	sp, {r0, r1, sl, fp}
     5fc:	00000001 	andeq	r0, r0, r1
     600:	07200000 	streq	r0, [r0, -r0]!
     604:	0000037d 	andeq	r0, r0, sp, ror r3
     608:	b81d0f03 	ldmdalt	sp, {r0, r1, r8, r9, sl, fp}
     60c:	00000001 	andeq	r0, r0, r1
     610:	08202000 	stmdaeq	r0!, {sp}
     614:	000003f4 	strdeq	r0, [r0], -r4
     618:	60181203 	andsvs	r1, r8, r3, lsl #4
     61c:	36000000 	strcc	r0, [r0], -r0
     620:	0008fe09 	andeq	pc, r8, r9, lsl #28
     624:	33040500 	movwcc	r0, #17664	; 0x4500
     628:	03000000 	movweq	r0, #0
     62c:	017b1015 	cmneq	fp, r5, lsl r0
     630:	3a0a0000 	bcc	280638 <_bss_end+0x275bb0>
     634:	00000005 	andeq	r0, r0, r5
     638:	0005420a 	andeq	r4, r5, sl, lsl #4
     63c:	4a0a0100 	bmi	280a44 <_bss_end+0x275fbc>
     640:	02000005 	andeq	r0, r0, #5
     644:	0005520a 	andeq	r5, r5, sl, lsl #4
     648:	5a0a0300 	bpl	281250 <_bss_end+0x2767c8>
     64c:	04000005 	streq	r0, [r0], #-5
     650:	0005620a 	andeq	r6, r5, sl, lsl #4
     654:	2c0a0500 	cfstr32cs	mvfx0, [sl], {-0}
     658:	07000005 	streq	r0, [r0, -r5]
     65c:	0005330a 	andeq	r3, r5, sl, lsl #6
     660:	590a0800 	stmdbpl	sl, {fp}
     664:	0a00000a 	beq	694 <CPSR_IRQ_INHIBIT+0x614>
     668:	0008170a 	andeq	r1, r8, sl, lsl #14
     66c:	920a0b00 	andls	r0, sl, #0, 22
     670:	0d000009 	stceq	0, cr0, [r0, #-36]	; 0xffffffdc
     674:	0009990a 	andeq	r9, r9, sl, lsl #18
     678:	620a0e00 	andvs	r0, sl, #0, 28
     67c:	10000006 	andne	r0, r0, r6
     680:	0006690a 	andeq	r6, r6, sl, lsl #18
     684:	f80a1100 			; <UNDEFINED> instruction: 0xf80a1100
     688:	13000005 	movwne	r0, #5
     68c:	0005ff0a 	andeq	pc, r5, sl, lsl #30
     690:	070a1400 	streq	r1, [sl, -r0, lsl #8]
     694:	1600000a 	strne	r0, [r0], -sl
     698:	00056a0a 	andeq	r6, r5, sl, lsl #20
     69c:	2e0a1700 	cdpcs	7, 0, cr1, cr10, cr0, {0}
     6a0:	19000008 	stmdbne	r0, {r3}
     6a4:	0006060a 	andeq	r0, r6, sl, lsl #12
     6a8:	960a1a00 	strls	r1, [sl], -r0, lsl #20
     6ac:	1c000006 	stcne	0, cr0, [r0], {6}
     6b0:	0008440a 	andeq	r4, r8, sl, lsl #8
     6b4:	1e0a1d00 	cdpne	13, 0, cr1, cr10, cr0, {0}
     6b8:	1f000008 	svcne	0x00000008
     6bc:	0008260a 	andeq	r2, r8, sl, lsl #12
     6c0:	a10a2000 	mrsge	r2, (UNDEF: 10)
     6c4:	22000007 	andcs	r0, r0, #7
     6c8:	0007a90a 	andeq	sl, r7, sl, lsl #18
     6cc:	1d0a2300 	stcne	3, cr2, [sl, #-0]
     6d0:	25000007 	strcs	r0, [r0, #-7]
     6d4:	0005a40a 	andeq	sl, r5, sl, lsl #8
     6d8:	ae0a2600 	cfmadd32ge	mvax0, mvfx2, mvfx10, mvfx0
     6dc:	27000005 	strcs	r0, [r0, -r5]
     6e0:	04780700 	ldrbteq	r0, [r8], #-1792	; 0xfffff900
     6e4:	44030000 	strmi	r0, [r3], #-0
     6e8:	0001b81d 	andeq	fp, r1, sp, lsl r8
     6ec:	21500000 	cmpcs	r0, r0
     6f0:	043d0720 	ldrteq	r0, [sp], #-1824	; 0xfffff8e0
     6f4:	73030000 	movwvc	r0, #12288	; 0x3000
     6f8:	0001b81d 	andeq	fp, r1, sp, lsl r8
     6fc:	00b20000 	adcseq	r0, r2, r0
     700:	021f0720 	andseq	r0, pc, #32, 14	; 0x800000
     704:	a6030000 	strge	r0, [r3], -r0
     708:	0001b81d 	andeq	fp, r1, sp, lsl r8
     70c:	00b40000 	adcseq	r0, r4, r0
     710:	7d0b0020 	stcvc	0, cr0, [fp, #-128]	; 0xffffff80
     714:	02000000 	andeq	r0, r0, #0
     718:	19f80704 	ldmibne	r8!, {r2, r8, r9, sl}^
     71c:	b1050000 	mrslt	r0, (UNDEF: 5)
     720:	0b000001 	bleq	72c <CPSR_IRQ_INHIBIT+0x6ac>
     724:	0000008d 	andeq	r0, r0, sp, lsl #1
     728:	00009d0b 	andeq	r9, r0, fp, lsl #26
     72c:	00ad0b00 	adceq	r0, sp, r0, lsl #22
     730:	7b0b0000 	blvc	2c0738 <_bss_end+0x2b5cb0>
     734:	0b000001 	bleq	740 <CPSR_IRQ_INHIBIT+0x6c0>
     738:	0000018b 	andeq	r0, r0, fp, lsl #3
     73c:	00019b0b 	andeq	r9, r1, fp, lsl #22
     740:	09710900 	ldmdbeq	r1!, {r8, fp}^
     744:	01070000 	mrseq	r0, (UNDEF: 7)
     748:	0000003a 	andeq	r0, r0, sl, lsr r0
     74c:	240c0604 	strcs	r0, [ip], #-1540	; 0xfffff9fc
     750:	0a000002 	beq	760 <CPSR_IRQ_INHIBIT+0x6e0>
     754:	00000a01 	andeq	r0, r0, r1, lsl #20
     758:	0a120a00 	beq	482f60 <_bss_end+0x4784d8>
     75c:	0a010000 	beq	40764 <_bss_end+0x35cdc>
     760:	00000a53 	andeq	r0, r0, r3, asr sl
     764:	0a4d0a02 	beq	1342f74 <_bss_end+0x13384ec>
     768:	0a030000 	beq	c0770 <_bss_end+0xb5ce8>
     76c:	00000a3b 	andeq	r0, r0, fp, lsr sl
     770:	0a410a04 	beq	1042f88 <_bss_end+0x1038500>
     774:	0a050000 	beq	14077c <_bss_end+0x135cf4>
     778:	0000098c 	andeq	r0, r0, ip, lsl #19
     77c:	0a470a06 	beq	11c2f9c <_bss_end+0x11b8514>
     780:	0a070000 	beq	1c0788 <_bss_end+0x1b5d00>
     784:	00000675 	andeq	r0, r0, r5, ror r6
     788:	e3090008 	movw	r0, #36872	; 0x9008
     78c:	05000005 	streq	r0, [r0, #-5]
     790:	00003304 	andeq	r3, r0, r4, lsl #6
     794:	0c180400 	cfldrseq	mvf0, [r8], {-0}
     798:	0000024f 	andeq	r0, r0, pc, asr #4
     79c:	0009800a 	andeq	r8, r9, sl
     7a0:	2e0a0000 	cdpcs	0, 0, cr0, cr10, cr0, {0}
     7a4:	0100000a 	tsteq	r0, sl
     7a8:	00059f0a 	andeq	r9, r5, sl, lsl #30
     7ac:	4c0c0200 	sfmmi	f0, 4, [ip], {-0}
     7b0:	0300776f 	movweq	r7, #1903	; 0x76f
     7b4:	06fc0d00 	ldrbteq	r0, [ip], r0, lsl #26
     7b8:	04040000 	streq	r0, [r4], #-0
     7bc:	047b0723 	ldrbteq	r0, [fp], #-1827	; 0xfffff8dd
     7c0:	3d0e0000 	stccc	0, cr0, [lr, #-0]
     7c4:	04000006 	streq	r0, [r0], #-6
     7c8:	04861927 	streq	r1, [r6], #2343	; 0x927
     7cc:	0f000000 	svceq	0x00000000
     7d0:	0000088e 	andeq	r0, r0, lr, lsl #17
     7d4:	0d0a2b04 	vstreq	d2, [sl, #-16]
     7d8:	8b000006 	blhi	7f8 <CPSR_IRQ_INHIBIT+0x778>
     7dc:	02000004 	andeq	r0, r0, #4
     7e0:	00000282 	andeq	r0, r0, r2, lsl #5
     7e4:	00000297 	muleq	r0, r7, r2
     7e8:	00049210 	andeq	r9, r4, r0, lsl r2
     7ec:	00541100 	subseq	r1, r4, r0, lsl #2
     7f0:	9d110000 	ldcls	0, cr0, [r1, #-0]
     7f4:	11000004 	tstne	r0, r4
     7f8:	0000049d 	muleq	r0, sp, r4
     7fc:	09e90f00 	stmibeq	r9!, {r8, r9, sl, fp}^
     800:	2d040000 	stccs	0, cr0, [r4, #-0]
     804:	0007b10a 	andeq	fp, r7, sl, lsl #2
     808:	00048b00 	andeq	r8, r4, r0, lsl #22
     80c:	02b00200 	adcseq	r0, r0, #0, 4
     810:	02c50000 	sbceq	r0, r5, #0
     814:	92100000 	andsls	r0, r0, #0
     818:	11000004 	tstne	r0, r4
     81c:	00000054 	andeq	r0, r0, r4, asr r0
     820:	00049d11 	andeq	r9, r4, r1, lsl sp
     824:	049d1100 	ldreq	r1, [sp], #256	; 0x100
     828:	0f000000 	svceq	0x00000000
     82c:	0000070a 	andeq	r0, r0, sl, lsl #14
     830:	ba0a2f04 	blt	28c448 <_bss_end+0x2819c0>
     834:	8b000009 	blhi	860 <CPSR_IRQ_INHIBIT+0x7e0>
     838:	02000004 	andeq	r0, r0, #4
     83c:	000002de 	ldrdeq	r0, [r0], -lr
     840:	000002f3 	strdeq	r0, [r0], -r3
     844:	00049210 	andeq	r9, r4, r0, lsl r2
     848:	00541100 	subseq	r1, r4, r0, lsl #2
     84c:	9d110000 	ldcls	0, cr0, [r1, #-0]
     850:	11000004 	tstne	r0, r4
     854:	0000049d 	muleq	r0, sp, r4
     858:	074e0f00 	strbeq	r0, [lr, -r0, lsl #30]
     85c:	31040000 	mrscc	r0, (UNDEF: 4)
     860:	0004fd0a 	andeq	pc, r4, sl, lsl #26
     864:	00048b00 	andeq	r8, r4, r0, lsl #22
     868:	030c0200 	movweq	r0, #49664	; 0xc200
     86c:	03210000 			; <UNDEFINED> instruction: 0x03210000
     870:	92100000 	andsls	r0, r0, #0
     874:	11000004 	tstne	r0, r4
     878:	00000054 	andeq	r0, r0, r4, asr r0
     87c:	00049d11 	andeq	r9, r4, r1, lsl sp
     880:	049d1100 	ldreq	r1, [sp], #256	; 0x100
     884:	0f000000 	svceq	0x00000000
     888:	0000058c 	andeq	r0, r0, ip, lsl #11
     88c:	5f0a3204 	svcpl	0x000a3204
     890:	8b000008 	blhi	8b8 <CPSR_IRQ_INHIBIT+0x838>
     894:	02000004 	andeq	r0, r0, #4
     898:	0000033a 	andeq	r0, r0, sl, lsr r3
     89c:	0000034f 	andeq	r0, r0, pc, asr #6
     8a0:	00049210 	andeq	r9, r4, r0, lsl r2
     8a4:	00541100 	subseq	r1, r4, r0, lsl #2
     8a8:	9d110000 	ldcls	0, cr0, [r1, #-0]
     8ac:	11000004 	tstne	r0, r4
     8b0:	0000049d 	muleq	r0, sp, r4
     8b4:	06fc0f00 	ldrbteq	r0, [ip], r0, lsl #30
     8b8:	35040000 	strcc	r0, [r4, #-0]
     8bc:	00064305 	andeq	r4, r6, r5, lsl #6
     8c0:	0004a300 	andeq	sl, r4, r0, lsl #6
     8c4:	03680100 	cmneq	r8, #0, 2
     8c8:	03730000 	cmneq	r3, #0
     8cc:	a3100000 	tstge	r0, #0
     8d0:	11000004 	tstne	r0, r4
     8d4:	00000065 	andeq	r0, r0, r5, rrx
     8d8:	09a01200 	stmibeq	r0!, {r9, ip}
     8dc:	38040000 	stmdacc	r4, {}	; <UNPREDICTABLE>
     8e0:	0009480a 	andeq	r4, r9, sl, lsl #16
     8e4:	03880100 	orreq	r0, r8, #0, 2
     8e8:	03980000 	orrseq	r0, r8, #0
     8ec:	a3100000 	tstge	r0, #0
     8f0:	11000004 	tstne	r0, r4
     8f4:	00000054 	andeq	r0, r0, r4, asr r0
     8f8:	0001db11 	andeq	sp, r1, r1, lsl fp
     8fc:	ea0f0000 	b	3c0904 <_bss_end+0x3b5e7c>
     900:	04000006 	streq	r0, [r0], #-6
     904:	0761143a 			; <UNDEFINED> instruction: 0x0761143a
     908:	01db0000 	bicseq	r0, fp, r0
     90c:	b1010000 	mrslt	r0, (UNDEF: 1)
     910:	bc000003 	stclt	0, cr0, [r0], {3}
     914:	10000003 	andne	r0, r0, r3
     918:	00000492 	muleq	r0, r2, r4
     91c:	00005411 	andeq	r5, r0, r1, lsl r4
     920:	0e120000 	cdpeq	0, 1, cr0, cr2, cr0, {0}
     924:	0400000a 	streq	r0, [r0], #-10
     928:	07e00a3d 			; <UNDEFINED> instruction: 0x07e00a3d
     92c:	d1010000 	mrsle	r0, (UNDEF: 1)
     930:	e1000003 	tst	r0, r3
     934:	10000003 	andne	r0, r0, r3
     938:	000004a3 	andeq	r0, r0, r3, lsr #9
     93c:	00005411 	andeq	r5, r0, r1, lsl r4
     940:	048b1100 	streq	r1, [fp], #256	; 0x100
     944:	12000000 	andne	r0, r0, #0
     948:	00000681 	andeq	r0, r0, r1, lsl #13
     94c:	230a3f04 	movwcs	r3, #44804	; 0xaf04
     950:	01000007 	tsteq	r0, r7
     954:	000003f6 	strdeq	r0, [r0], -r6
     958:	00000401 	andeq	r0, r0, r1, lsl #8
     95c:	0004a310 	andeq	sl, r4, r0, lsl r3
     960:	00541100 	subseq	r1, r4, r0, lsl #2
     964:	12000000 	andne	r0, r0, #0
     968:	0000084b 	andeq	r0, r0, fp, asr #16
     96c:	b80a4104 	stmdalt	sl, {r2, r8, lr}
     970:	01000005 	tsteq	r0, r5
     974:	00000416 	andeq	r0, r0, r6, lsl r4
     978:	00000426 	andeq	r0, r0, r6, lsr #8
     97c:	0004a310 	andeq	sl, r4, r0, lsl r3
     980:	00541100 	subseq	r1, r4, r0, lsl #2
     984:	24110000 	ldrcs	r0, [r1], #-0
     988:	00000002 	andeq	r0, r0, r2
     98c:	000a1912 	andeq	r1, sl, r2, lsl r9
     990:	0a420400 	beq	1081998 <_bss_end+0x1076f10>
     994:	00000907 	andeq	r0, r0, r7, lsl #18
     998:	00043b01 	andeq	r3, r4, r1, lsl #22
     99c:	00044b00 	andeq	r4, r4, r0, lsl #22
     9a0:	04a31000 	strteq	r1, [r3], #0
     9a4:	54110000 	ldrpl	r0, [r1], #-0
     9a8:	11000000 	mrsne	r0, (UNDEF: 0)
     9ac:	00000224 	andeq	r0, r0, r4, lsr #4
     9b0:	05711300 	ldrbeq	r1, [r1, #-768]!	; 0xfffffd00
     9b4:	43040000 	movwmi	r0, #16384	; 0x4000
     9b8:	00069d0a 	andeq	r9, r6, sl, lsl #26
     9bc:	00048b00 	andeq	r8, r4, r0, lsl #22
     9c0:	04600100 	strbteq	r0, [r0], #-256	; 0xffffff00
     9c4:	92100000 	andsls	r0, r0, #0
     9c8:	11000004 	tstne	r0, r4
     9cc:	00000054 	andeq	r0, r0, r4, asr r0
     9d0:	00022411 	andeq	r2, r2, r1, lsl r4
     9d4:	049d1100 	ldreq	r1, [sp], #256	; 0x100
     9d8:	9d110000 	ldcls	0, cr0, [r1, #-0]
     9dc:	00000004 	andeq	r0, r0, r4
     9e0:	024f0500 	subeq	r0, pc, #0, 10
     9e4:	04140000 	ldreq	r0, [r4], #-0
     9e8:	00000065 	andeq	r0, r0, r5, rrx
     9ec:	00048005 	andeq	r8, r4, r5
     9f0:	02010200 	andeq	r0, r1, #0, 4
     9f4:	00000670 	andeq	r0, r0, r0, ror r6
     9f8:	047b0414 	ldrbteq	r0, [fp], #-1044	; 0xfffffbec
     9fc:	92050000 	andls	r0, r5, #0
     a00:	15000004 	strne	r0, [r0, #-4]
     a04:	00005404 	andeq	r5, r0, r4, lsl #8
     a08:	4f041400 	svcmi	0x00041400
     a0c:	05000002 	streq	r0, [r0, #-2]
     a10:	000004a3 	andeq	r0, r0, r3, lsr #9
     a14:	00081116 	andeq	r1, r8, r6, lsl r1
     a18:	16470400 	strbne	r0, [r7], -r0, lsl #8
     a1c:	0000024f 	andeq	r0, r0, pc, asr #4
     a20:	0004ae17 	andeq	sl, r4, r7, lsl lr
     a24:	0f040100 	svceq	0x00040100
     a28:	aa1c0305 	bge	701644 <_bss_end+0x6f6bbc>
     a2c:	02180000 	andseq	r0, r8, #0
     a30:	54000008 	strpl	r0, [r0], #-8
     a34:	1c00008b 	stcne	0, cr0, [r0], {139}	; 0x8b
     a38:	01000000 	mrseq	r0, (UNDEF: 0)
     a3c:	0403199c 	streq	r1, [r3], #-2460	; 0xfffff664
     a40:	8b000000 	blhi	a48 <CPSR_IRQ_INHIBIT+0x9c8>
     a44:	00540000 	subseq	r0, r4, r0
     a48:	9c010000 	stcls	0, cr0, [r1], {-0}
     a4c:	00000509 	andeq	r0, r0, r9, lsl #10
     a50:	00033c1a 	andeq	r3, r3, sl, lsl ip
     a54:	01b40100 			; <UNDEFINED> instruction: 0x01b40100
     a58:	00000033 	andeq	r0, r0, r3, lsr r0
     a5c:	1a749102 	bne	1d24e6c <_bss_end+0x1d1a3e4>
     a60:	0000042d 	andeq	r0, r0, sp, lsr #8
     a64:	3301b401 	movwcc	fp, #5121	; 0x1401
     a68:	02000000 	andeq	r0, r0, #0
     a6c:	1b007091 	blne	1ccb8 <_bss_end+0x12230>
     a70:	000003e1 	andeq	r0, r0, r1, ror #7
     a74:	2306ac01 	movwcs	sl, #27649	; 0x6c01
     a78:	8c000005 	stchi	0, cr0, [r0], {5}
     a7c:	7400008a 	strvc	r0, [r0], #-138	; 0xffffff76
     a80:	01000000 	mrseq	r0, (UNDEF: 0)
     a84:	00055d9c 	muleq	r5, ip, sp
     a88:	04381c00 	ldrteq	r1, [r8], #-3072	; 0xfffff400
     a8c:	04a90000 	strteq	r0, [r9], #0
     a90:	91020000 	mrsls	r0, (UNDEF: 2)
     a94:	69701d6c 	ldmdbvs	r0!, {r2, r3, r5, r6, r8, sl, fp, ip}^
     a98:	ac01006e 	stcge	0, cr0, [r1], {110}	; 0x6e
     a9c:	00005433 	andeq	r5, r0, r3, lsr r4
     aa0:	68910200 	ldmvs	r1, {r9}
     aa4:	6765721e 			; <UNDEFINED> instruction: 0x6765721e
     aa8:	0eae0100 	fdveqe	f0, f6, f0
     aac:	00000054 	andeq	r0, r0, r4, asr r0
     ab0:	1e749102 	expnes	f1, f2
     ab4:	00746962 	rsbseq	r6, r4, r2, ror #18
     ab8:	5413ae01 	ldrpl	sl, [r3], #-3585	; 0xfffff1ff
     abc:	02000000 	andeq	r0, r0, #0
     ac0:	1f007091 	svcne	0x00007091
     ac4:	00000321 	andeq	r0, r0, r1, lsr #6
     ac8:	7706a101 	strvc	sl, [r6, -r1, lsl #2]
     acc:	18000005 	stmdane	r0, {r0, r2}
     ad0:	7400008a 	strvc	r0, [r0], #-138	; 0xffffff76
     ad4:	01000000 	mrseq	r0, (UNDEF: 0)
     ad8:	0005b19c 	muleq	r5, ip, r1
     adc:	04381c00 	ldrteq	r1, [r8], #-3072	; 0xfffff400
     ae0:	04980000 	ldreq	r0, [r8], #0
     ae4:	91020000 	mrsls	r0, (UNDEF: 2)
     ae8:	69701d74 	ldmdbvs	r0!, {r2, r4, r5, r6, r8, sl, fp, ip}^
     aec:	a101006e 	tstge	r1, lr, rrx
     af0:	00005431 	andeq	r5, r0, r1, lsr r4
     af4:	70910200 	addsvc	r0, r1, r0, lsl #4
     af8:	6765721d 			; <UNDEFINED> instruction: 0x6765721d
     afc:	40a10100 	adcmi	r0, r1, r0, lsl #2
     b00:	0000049d 	muleq	r0, sp, r4
     b04:	1a6c9102 	bne	1b24f14 <_bss_end+0x1b1a48c>
     b08:	000009b2 			; <UNDEFINED> instruction: 0x000009b2
     b0c:	9d4fa101 	stflsp	f2, [pc, #-4]	; b10 <CPSR_IRQ_INHIBIT+0xa90>
     b10:	02000004 	andeq	r0, r0, #4
     b14:	1b006891 	blne	1ad60 <_bss_end+0x102d8>
     b18:	000003bc 			; <UNDEFINED> instruction: 0x000003bc
     b1c:	cb069801 	blgt	1a6b28 <_bss_end+0x19c0a0>
     b20:	40000005 	andmi	r0, r0, r5
     b24:	d8000089 	stmdale	r0, {r0, r3, r7}
     b28:	01000000 	mrseq	r0, (UNDEF: 0)
     b2c:	0006149c 	muleq	r6, ip, r4
     b30:	04381c00 	ldrteq	r1, [r8], #-3072	; 0xfffff400
     b34:	04a90000 	strteq	r0, [r9], #0
     b38:	91020000 	mrsls	r0, (UNDEF: 2)
     b3c:	69701d6c 	ldmdbvs	r0!, {r2, r3, r5, r6, r8, sl, fp, ip}^
     b40:	9801006e 	stmdals	r1, {r1, r2, r3, r5, r6}
     b44:	00005429 	andeq	r5, r0, r9, lsr #8
     b48:	68910200 	ldmvs	r1, {r9}
     b4c:	7465731d 	strbtvc	r7, [r5], #-797	; 0xfffffce3
     b50:	33980100 	orrscc	r0, r8, #0, 2
     b54:	0000048b 	andeq	r0, r0, fp, lsl #9
     b58:	1e679102 	lgnnes	f1, f2
     b5c:	00676572 	rsbeq	r6, r7, r2, ror r5
     b60:	540e9a01 	strpl	r9, [lr], #-2561	; 0xfffff5ff
     b64:	02000000 	andeq	r0, r0, #0
     b68:	621e7491 	andsvs	r7, lr, #-1862270976	; 0x91000000
     b6c:	01007469 	tsteq	r0, r9, ror #8
     b70:	0054139a 			; <UNDEFINED> instruction: 0x0054139a
     b74:	91020000 	mrsls	r0, (UNDEF: 2)
     b78:	261b0070 			; <UNDEFINED> instruction: 0x261b0070
     b7c:	01000004 	tsteq	r0, r4
     b80:	062e068d 	strteq	r0, [lr], -sp, lsl #13
     b84:	888c0000 	stmhi	ip, {}	; <UNPREDICTABLE>
     b88:	00b40000 	adcseq	r0, r4, r0
     b8c:	9c010000 	stcls	0, cr0, [r1], {-0}
     b90:	00000686 	andeq	r0, r0, r6, lsl #13
     b94:	0004381c 	andeq	r3, r4, ip, lsl r8
     b98:	0004a900 	andeq	sl, r4, r0, lsl #18
     b9c:	64910200 	ldrvs	r0, [r1], #512	; 0x200
     ba0:	6e69701d 	mcrvs	0, 3, r7, cr9, cr13, {0}
     ba4:	338d0100 	orrcc	r0, sp, #0, 2
     ba8:	00000054 	andeq	r0, r0, r4, asr r0
     bac:	1a609102 	bne	1824fbc <_bss_end+0x181a534>
     bb0:	000008a2 	andeq	r0, r0, r2, lsr #17
     bb4:	244d8d01 	strbcs	r8, [sp], #-3329	; 0xfffff2ff
     bb8:	02000002 	andeq	r0, r0, #2
     bbc:	721e5c91 	andsvc	r5, lr, #37120	; 0x9100
     bc0:	01006765 	tsteq	r0, r5, ror #14
     bc4:	00540e8f 	subseq	r0, r4, pc, lsl #29
     bc8:	91020000 	mrsls	r0, (UNDEF: 2)
     bcc:	69621e70 	stmdbvs	r2!, {r4, r5, r6, r9, sl, fp, ip}^
     bd0:	8f010074 	svchi	0x00010074
     bd4:	00005413 	andeq	r5, r0, r3, lsl r4
     bd8:	6c910200 	lfmvs	f0, 4, [r1], {0}
     bdc:	6c61761e 	stclvs	6, cr7, [r1], #-120	; 0xffffff88
     be0:	0e930100 	fmleqs	f0, f3, f0
     be4:	00000054 	andeq	r0, r0, r4, asr r0
     be8:	00749102 	rsbseq	r9, r4, r2, lsl #2
     bec:	00044b1f 	andeq	r4, r4, pc, lsl fp
     bf0:	066e0100 	strbteq	r0, [lr], -r0, lsl #2
     bf4:	000006a0 	andeq	r0, r0, r0, lsr #13
     bf8:	00008780 	andeq	r8, r0, r0, lsl #15
     bfc:	0000010c 	andeq	r0, r0, ip, lsl #2
     c00:	06e99c01 	strbteq	r9, [r9], r1, lsl #24
     c04:	381c0000 	ldmdacc	ip, {}	; <UNPREDICTABLE>
     c08:	98000004 	stmdals	r0, {r2}
     c0c:	02000004 	andeq	r0, r0, #4
     c10:	701d7491 	mulsvc	sp, r1, r4
     c14:	01006e69 	tsteq	r0, r9, ror #28
     c18:	0054396e 	subseq	r3, r4, lr, ror #18
     c1c:	91020000 	mrsls	r0, (UNDEF: 2)
     c20:	08a21a70 	stmiaeq	r2!, {r4, r5, r6, r9, fp, ip}
     c24:	6f010000 	svcvs	0x00010000
     c28:	00022445 	andeq	r2, r2, r5, asr #8
     c2c:	6c910200 	lfmvs	f0, 4, [r1], {0}
     c30:	6765721d 			; <UNDEFINED> instruction: 0x6765721d
     c34:	3a700100 	bcc	1c0103c <_bss_end+0x1bf65b4>
     c38:	0000049d 	muleq	r0, sp, r4
     c3c:	1a689102 	bne	1a2504c <_bss_end+0x1a1a5c4>
     c40:	000009b2 			; <UNDEFINED> instruction: 0x000009b2
     c44:	9d3a7101 	ldflss	f7, [sl, #-4]!
     c48:	02000004 	andeq	r0, r0, #4
     c4c:	1b000091 	blne	e98 <CPSR_IRQ_INHIBIT+0xe18>
     c50:	00000401 	andeq	r0, r0, r1, lsl #8
     c54:	03065f01 	movweq	r5, #28417	; 0x6f01
     c58:	fc000007 	stc2	0, cr0, [r0], {7}
     c5c:	84000086 	strhi	r0, [r0], #-134	; 0xffffff7a
     c60:	01000000 	mrseq	r0, (UNDEF: 0)
     c64:	00074c9c 	muleq	r7, ip, ip
     c68:	04381c00 	ldrteq	r1, [r8], #-3072	; 0xfffff400
     c6c:	04a90000 	strteq	r0, [r9], #0
     c70:	91020000 	mrsls	r0, (UNDEF: 2)
     c74:	69701d6c 	ldmdbvs	r0!, {r2, r3, r5, r6, r8, sl, fp, ip}^
     c78:	5f01006e 	svcpl	0x0001006e
     c7c:	00005432 	andeq	r5, r0, r2, lsr r4
     c80:	68910200 	ldmvs	r1, {r9}
     c84:	0008a21a 	andeq	sl, r8, sl, lsl r2
     c88:	4c5f0100 	ldfmie	f0, [pc], {-0}
     c8c:	00000224 	andeq	r0, r0, r4, lsr #4
     c90:	1e649102 	lgnnes	f1, f2
     c94:	00676572 	rsbeq	r6, r7, r2, ror r5
     c98:	540e6101 	strpl	r6, [lr], #-257	; 0xfffffeff
     c9c:	02000000 	andeq	r0, r0, #0
     ca0:	621e7491 	andsvs	r7, lr, #-1862270976	; 0x91000000
     ca4:	01007469 	tsteq	r0, r9, ror #8
     ca8:	00541361 	subseq	r1, r4, r1, ror #6
     cac:	91020000 	mrsls	r0, (UNDEF: 2)
     cb0:	981b0070 	ldmdals	fp, {r4, r5, r6}
     cb4:	01000003 	tsteq	r0, r3
     cb8:	07661056 			; <UNDEFINED> instruction: 0x07661056
     cbc:	86800000 	strhi	r0, [r0], r0
     cc0:	007c0000 	rsbseq	r0, ip, r0
     cc4:	9c010000 	stcls	0, cr0, [r1], {-0}
     cc8:	000007a0 	andeq	r0, r0, r0, lsr #15
     ccc:	0004381c 	andeq	r3, r4, ip, lsl r8
     cd0:	00049800 	andeq	r9, r4, r0, lsl #16
     cd4:	6c910200 	lfmvs	f0, 4, [r1], {0}
     cd8:	6e69701d 	mcrvs	0, 3, r7, cr9, cr13, {0}
     cdc:	3a560100 	bcc	15810e4 <_bss_end+0x157665c>
     ce0:	00000054 	andeq	r0, r0, r4, asr r0
     ce4:	1e689102 	lgnnee	f1, f2
     ce8:	00676572 	rsbeq	r6, r7, r2, ror r5
     cec:	540e5801 	strpl	r5, [lr], #-2049	; 0xfffff7ff
     cf0:	02000000 	andeq	r0, r0, #0
     cf4:	621e7491 	andsvs	r7, lr, #-1862270976	; 0x91000000
     cf8:	01007469 	tsteq	r0, r9, ror #8
     cfc:	00541358 	subseq	r1, r4, r8, asr r3
     d00:	91020000 	mrsls	r0, (UNDEF: 2)
     d04:	731b0070 	tstvc	fp, #112	; 0x70
     d08:	01000003 	tsteq	r0, r3
     d0c:	07ba064d 	ldreq	r0, [sl, sp, asr #12]!
     d10:	85d80000 	ldrbhi	r0, [r8]
     d14:	00a80000 	adceq	r0, r8, r0
     d18:	9c010000 	stcls	0, cr0, [r1], {-0}
     d1c:	00000803 	andeq	r0, r0, r3, lsl #16
     d20:	0004381c 	andeq	r3, r4, ip, lsl r8
     d24:	0004a900 	andeq	sl, r4, r0, lsl #18
     d28:	6c910200 	lfmvs	f0, 4, [r1], {0}
     d2c:	6e69701d 	mcrvs	0, 3, r7, cr9, cr13, {0}
     d30:	304d0100 	subcc	r0, sp, r0, lsl #2
     d34:	00000054 	andeq	r0, r0, r4, asr r0
     d38:	1a689102 	bne	1a25148 <_bss_end+0x1a1a6c0>
     d3c:	000009fc 	strdeq	r0, [r0], -ip
     d40:	db444d01 	blle	111414c <_bss_end+0x11096c4>
     d44:	02000001 	andeq	r0, r0, #1
     d48:	721e6791 	andsvc	r6, lr, #38010880	; 0x2440000
     d4c:	01006765 	tsteq	r0, r5, ror #14
     d50:	00540e4f 	subseq	r0, r4, pc, asr #28
     d54:	91020000 	mrsls	r0, (UNDEF: 2)
     d58:	69621e74 	stmdbvs	r2!, {r2, r4, r5, r6, r9, sl, fp, ip}^
     d5c:	4f010074 	svcmi	0x00010074
     d60:	00005413 	andeq	r5, r0, r3, lsl r4
     d64:	70910200 	addsvc	r0, r1, r0, lsl #4
     d68:	02f31f00 	rscseq	r1, r3, #0, 30
     d6c:	42010000 	andmi	r0, r1, #0
     d70:	00081d06 	andeq	r1, r8, r6, lsl #26
     d74:	00856400 	addeq	r6, r5, r0, lsl #8
     d78:	00007400 	andeq	r7, r0, r0, lsl #8
     d7c:	579c0100 	ldrpl	r0, [ip, r0, lsl #2]
     d80:	1c000008 	stcne	0, cr0, [r0], {8}
     d84:	00000438 	andeq	r0, r0, r8, lsr r4
     d88:	00000498 	muleq	r0, r8, r4
     d8c:	1d749102 	ldfnep	f1, [r4, #-8]!
     d90:	006e6970 	rsbeq	r6, lr, r0, ror r9
     d94:	54314201 	ldrtpl	r4, [r1], #-513	; 0xfffffdff
     d98:	02000000 	andeq	r0, r0, #0
     d9c:	721d7091 	andsvc	r7, sp, #145	; 0x91
     da0:	01006765 	tsteq	r0, r5, ror #14
     da4:	049d4042 	ldreq	r4, [sp], #66	; 0x42
     da8:	91020000 	mrsls	r0, (UNDEF: 2)
     dac:	09b21a6c 	ldmibeq	r2!, {r2, r3, r5, r6, r9, fp, ip}
     db0:	42010000 	andmi	r0, r1, #0
     db4:	00049d4f 	andeq	r9, r4, pc, asr #26
     db8:	68910200 	ldmvs	r1, {r9}
     dbc:	02c51f00 	sbceq	r1, r5, #0, 30
     dc0:	37010000 	strcc	r0, [r1, -r0]
     dc4:	00087106 	andeq	r7, r8, r6, lsl #2
     dc8:	0084f000 	addeq	pc, r4, r0
     dcc:	00007400 	andeq	r7, r0, r0, lsl #8
     dd0:	ab9c0100 	blge	fe7011d8 <_bss_end+0xfe6f6750>
     dd4:	1c000008 	stcne	0, cr0, [r0], {8}
     dd8:	00000438 	andeq	r0, r0, r8, lsr r4
     ddc:	00000498 	muleq	r0, r8, r4
     de0:	1d749102 	ldfnep	f1, [r4, #-8]!
     de4:	006e6970 	rsbeq	r6, lr, r0, ror r9
     de8:	54313701 	ldrtpl	r3, [r1], #-1793	; 0xfffff8ff
     dec:	02000000 	andeq	r0, r0, #0
     df0:	721d7091 	andsvc	r7, sp, #145	; 0x91
     df4:	01006765 	tsteq	r0, r5, ror #14
     df8:	049d4037 	ldreq	r4, [sp], #55	; 0x37
     dfc:	91020000 	mrsls	r0, (UNDEF: 2)
     e00:	09b21a6c 	ldmibeq	r2!, {r2, r3, r5, r6, r9, fp, ip}
     e04:	37010000 	strcc	r0, [r1, -r0]
     e08:	00049d4f 	andeq	r9, r4, pc, asr #26
     e0c:	68910200 	ldmvs	r1, {r9}
     e10:	02971f00 	addseq	r1, r7, #0, 30
     e14:	2c010000 	stccs	0, cr0, [r1], {-0}
     e18:	0008c506 	andeq	ip, r8, r6, lsl #10
     e1c:	00847c00 	addeq	r7, r4, r0, lsl #24
     e20:	00007400 	andeq	r7, r0, r0, lsl #8
     e24:	ff9c0100 			; <UNDEFINED> instruction: 0xff9c0100
     e28:	1c000008 	stcne	0, cr0, [r0], {8}
     e2c:	00000438 	andeq	r0, r0, r8, lsr r4
     e30:	00000498 	muleq	r0, r8, r4
     e34:	1d749102 	ldfnep	f1, [r4, #-8]!
     e38:	006e6970 	rsbeq	r6, lr, r0, ror r9
     e3c:	54312c01 	ldrtpl	r2, [r1], #-3073	; 0xfffff3ff
     e40:	02000000 	andeq	r0, r0, #0
     e44:	721d7091 	andsvc	r7, sp, #145	; 0x91
     e48:	01006765 	tsteq	r0, r5, ror #14
     e4c:	049d402c 	ldreq	r4, [sp], #44	; 0x2c
     e50:	91020000 	mrsls	r0, (UNDEF: 2)
     e54:	09b21a6c 	ldmibeq	r2!, {r2, r3, r5, r6, r9, fp, ip}
     e58:	2c010000 	stccs	0, cr0, [r1], {-0}
     e5c:	00049d4f 	andeq	r9, r4, pc, asr #26
     e60:	68910200 	ldmvs	r1, {r9}
     e64:	02691f00 	rsbeq	r1, r9, #0, 30
     e68:	0c010000 	stceq	0, cr0, [r1], {-0}
     e6c:	00091906 	andeq	r1, r9, r6, lsl #18
     e70:	00836800 	addeq	r6, r3, r0, lsl #16
     e74:	00011400 	andeq	r1, r1, r0, lsl #8
     e78:	539c0100 	orrspl	r0, ip, #0, 2
     e7c:	1c000009 	stcne	0, cr0, [r0], {9}
     e80:	00000438 	andeq	r0, r0, r8, lsr r4
     e84:	00000498 	muleq	r0, r8, r4
     e88:	1d749102 	ldfnep	f1, [r4, #-8]!
     e8c:	006e6970 	rsbeq	r6, lr, r0, ror r9
     e90:	54320c01 	ldrtpl	r0, [r2], #-3073	; 0xfffff3ff
     e94:	02000000 	andeq	r0, r0, #0
     e98:	721d7091 	andsvc	r7, sp, #145	; 0x91
     e9c:	01006765 	tsteq	r0, r5, ror #14
     ea0:	049d410c 	ldreq	r4, [sp], #268	; 0x10c
     ea4:	91020000 	mrsls	r0, (UNDEF: 2)
     ea8:	09b21a6c 	ldmibeq	r2!, {r2, r3, r5, r6, r9, fp, ip}
     eac:	0c010000 	stceq	0, cr0, [r1], {-0}
     eb0:	00049d50 	andeq	r9, r4, r0, asr sp
     eb4:	68910200 	ldmvs	r1, {r9}
     eb8:	034f2000 	movteq	r2, #61440	; 0xf000
     ebc:	06010000 	streq	r0, [r1], -r0
     ec0:	00096401 	andeq	r6, r9, r1, lsl #8
     ec4:	097a0000 	ldmdbeq	sl!, {}^	; <UNPREDICTABLE>
     ec8:	38210000 	stmdacc	r1!, {}	; <UNPREDICTABLE>
     ecc:	a9000004 	stmdbge	r0, {r2}
     ed0:	22000004 	andcs	r0, r0, #4
     ed4:	00000835 	andeq	r0, r0, r5, lsr r8
     ed8:	652b0601 	strvs	r0, [fp, #-1537]!	; 0xfffff9ff
     edc:	00000000 	andeq	r0, r0, r0
     ee0:	00095323 	andeq	r5, r9, r3, lsr #6
     ee4:	00078a00 	andeq	r8, r7, r0, lsl #20
     ee8:	00099100 	andeq	r9, r9, r0, lsl #2
     eec:	00833400 	addeq	r3, r3, r0, lsl #8
     ef0:	00003400 	andeq	r3, r0, r0, lsl #8
     ef4:	249c0100 	ldrcs	r0, [ip], #256	; 0x100
     ef8:	00000964 	andeq	r0, r0, r4, ror #18
     efc:	24749102 	ldrbtcs	r9, [r4], #-258	; 0xfffffefe
     f00:	0000096d 	andeq	r0, r0, sp, ror #18
     f04:	00709102 	rsbseq	r9, r0, r2, lsl #2
     f08:	0006b400 	andeq	fp, r6, r0, lsl #8
     f0c:	25000400 	strcs	r0, [r0, #-1024]	; 0xfffffc00
     f10:	04000005 	streq	r0, [r0], #-5
     f14:	0000b501 	andeq	fp, r0, r1, lsl #10
     f18:	0bfc0400 	bleq	fff01f20 <_bss_end+0xffef7498>
     f1c:	00740000 	rsbseq	r0, r4, r0
	...
     f28:	06950000 	ldreq	r0, [r5], r0
     f2c:	69020000 	stmdbvs	r2, {}	; <UNPREDICTABLE>
     f30:	1800000b 	stmdane	r0, {r0, r1, r3}
     f34:	66070302 	strvs	r0, [r7], -r2, lsl #6
     f38:	03000002 	movweq	r0, #2
     f3c:	00000ae7 	andeq	r0, r0, r7, ror #21
     f40:	02660407 	rsbeq	r0, r6, #117440512	; 0x7000000
     f44:	06020000 	streq	r0, [r2], -r0
     f48:	00520110 	subseq	r0, r2, r0, lsl r1
     f4c:	48040000 	stmdami	r4, {}	; <UNPREDICTABLE>
     f50:	10005845 	andne	r5, r0, r5, asr #16
     f54:	43454404 	movtmi	r4, #21508	; 0x5404
     f58:	05000a00 	streq	r0, [r0, #-2560]	; 0xfffff600
     f5c:	00000032 	andeq	r0, r0, r2, lsr r0
     f60:	000af406 	andeq	pc, sl, r6, lsl #8
     f64:	24020800 	strcs	r0, [r2], #-2048	; 0xfffff800
     f68:	00007b0c 	andeq	r7, r0, ip, lsl #22
     f6c:	00790700 	rsbseq	r0, r9, r0, lsl #14
     f70:	66162602 	ldrvs	r2, [r6], -r2, lsl #12
     f74:	00000002 	andeq	r0, r0, r2
     f78:	02007807 	andeq	r7, r0, #458752	; 0x70000
     f7c:	02661627 	rsbeq	r1, r6, #40894464	; 0x2700000
     f80:	00040000 	andeq	r0, r4, r0
     f84:	000c9708 	andeq	r9, ip, r8, lsl #14
     f88:	1b0c0200 	blne	301790 <_bss_end+0x2f6d08>
     f8c:	00000052 	andeq	r0, r0, r2, asr r0
     f90:	b0090a01 	andlt	r0, r9, r1, lsl #20
     f94:	0200000b 	andeq	r0, r0, #11
     f98:	0278280d 	rsbseq	r2, r8, #851968	; 0xd0000
     f9c:	0a010000 	beq	40fa4 <_bss_end+0x3651c>
     fa0:	00000b69 	andeq	r0, r0, r9, ror #22
     fa4:	730e1002 	movwvc	r1, #57346	; 0xe002
     fa8:	8900000c 	stmdbhi	r0, {r2, r3}
     fac:	01000002 	tsteq	r0, r2
     fb0:	000000af 	andeq	r0, r0, pc, lsr #1
     fb4:	000000c4 	andeq	r0, r0, r4, asr #1
     fb8:	0002890b 	andeq	r8, r2, fp, lsl #18
     fbc:	02660c00 	rsbeq	r0, r6, #0, 24
     fc0:	660c0000 	strvs	r0, [ip], -r0
     fc4:	0c000002 	stceq	0, cr0, [r0], {2}
     fc8:	00000266 	andeq	r0, r0, r6, ror #4
     fcc:	0a900d00 	beq	fe4043d4 <_bss_end+0xfe3f994c>
     fd0:	12020000 	andne	r0, r2, #0
     fd4:	000b540a 	andeq	r5, fp, sl, lsl #8
     fd8:	00d90100 	sbcseq	r0, r9, r0, lsl #2
     fdc:	00df0000 	sbcseq	r0, pc, r0
     fe0:	890b0000 	stmdbhi	fp, {}	; <UNPREDICTABLE>
     fe4:	00000002 	andeq	r0, r0, r2
     fe8:	000b720e 	andeq	r7, fp, lr, lsl #4
     fec:	0f140200 	svceq	0x00140200
     ff0:	00000bcd 	andeq	r0, r0, sp, asr #23
     ff4:	00000294 	muleq	r0, r4, r2
     ff8:	0000f801 	andeq	pc, r0, r1, lsl #16
     ffc:	00010300 	andeq	r0, r1, r0, lsl #6
    1000:	02890b00 	addeq	r0, r9, #0, 22
    1004:	7d0c0000 	stcvc	0, cr0, [ip, #-0]
    1008:	00000002 	andeq	r0, r0, r2
    100c:	000b720e 	andeq	r7, fp, lr, lsl #4
    1010:	0f150200 	svceq	0x00150200
    1014:	00000b7d 	andeq	r0, r0, sp, ror fp
    1018:	00000294 	muleq	r0, r4, r2
    101c:	00011c01 	andeq	r1, r1, r1, lsl #24
    1020:	00012700 	andeq	r2, r1, r0, lsl #14
    1024:	02890b00 	addeq	r0, r9, #0, 22
    1028:	720c0000 	andvc	r0, ip, #0
    102c:	00000002 	andeq	r0, r0, r2
    1030:	000b720e 	andeq	r7, fp, lr, lsl #4
    1034:	0f160200 	svceq	0x00160200
    1038:	00000cab 	andeq	r0, r0, fp, lsr #25
    103c:	00000294 	muleq	r0, r4, r2
    1040:	00014001 	andeq	r4, r1, r1
    1044:	00014b00 	andeq	r4, r1, r0, lsl #22
    1048:	02890b00 	addeq	r0, r9, #0, 22
    104c:	320c0000 	andcc	r0, ip, #0
    1050:	00000000 	andeq	r0, r0, r0
    1054:	000b720e 	andeq	r7, fp, lr, lsl #4
    1058:	0f170200 	svceq	0x00170200
    105c:	00000c86 	andeq	r0, r0, r6, lsl #25
    1060:	00000294 	muleq	r0, r4, r2
    1064:	00016401 	andeq	r6, r1, r1, lsl #8
    1068:	00016f00 	andeq	r6, r1, r0, lsl #30
    106c:	02890b00 	addeq	r0, r9, #0, 22
    1070:	660c0000 	strvs	r0, [ip], -r0
    1074:	00000002 	andeq	r0, r0, r2
    1078:	000b720e 	andeq	r7, fp, lr, lsl #4
    107c:	0f180200 	svceq	0x00180200
    1080:	00000bbc 			; <UNDEFINED> instruction: 0x00000bbc
    1084:	00000294 	muleq	r0, r4, r2
    1088:	00018801 	andeq	r8, r1, r1, lsl #16
    108c:	00019300 	andeq	r9, r1, r0, lsl #6
    1090:	02890b00 	addeq	r0, r9, #0, 22
    1094:	9a0c0000 	bls	30109c <_bss_end+0x2f6614>
    1098:	00000002 	andeq	r0, r0, r2
    109c:	000ad90f 	andeq	sp, sl, pc, lsl #18
    10a0:	111b0200 	tstne	fp, r0, lsl #4
    10a4:	00000aa9 	andeq	r0, r0, r9, lsr #21
    10a8:	000001a7 	andeq	r0, r0, r7, lsr #3
    10ac:	000001ad 	andeq	r0, r0, sp, lsr #3
    10b0:	0002890b 	andeq	r8, r2, fp, lsl #18
    10b4:	cc0f0000 	stcgt	0, cr0, [pc], {-0}
    10b8:	0200000a 	andeq	r0, r0, #10
    10bc:	0c56111c 	ldfeqe	f1, [r6], {28}
    10c0:	01c10000 	biceq	r0, r1, r0
    10c4:	01c70000 	biceq	r0, r7, r0
    10c8:	890b0000 	stmdbhi	fp, {}	; <UNPREDICTABLE>
    10cc:	00000002 	andeq	r0, r0, r2
    10d0:	000a7e0f 	andeq	r7, sl, pc, lsl #28
    10d4:	111d0200 	tstne	sp, r0, lsl #4
    10d8:	00000afe 	strdeq	r0, [r0], -lr
    10dc:	000001db 	ldrdeq	r0, [r0], -fp
    10e0:	000001e1 	andeq	r0, r0, r1, ror #3
    10e4:	0002890b 	andeq	r8, r2, fp, lsl #18
    10e8:	690f0000 	stmdbvs	pc, {}	; <UNPREDICTABLE>
    10ec:	0200000a 	andeq	r0, r0, #10
    10f0:	0be60a1f 	bleq	ff983974 <_bss_end+0xff978eec>
    10f4:	01f50000 	mvnseq	r0, r0
    10f8:	01fb0000 	mvnseq	r0, r0
    10fc:	890b0000 	stmdbhi	fp, {}	; <UNPREDICTABLE>
    1100:	00000002 	andeq	r0, r0, r2
    1104:	000ac70f 	andeq	ip, sl, pc, lsl #14
    1108:	0a210200 	beq	841910 <_bss_end+0x836e88>
    110c:	00000b90 	muleq	r0, r0, fp
    1110:	0000020f 	andeq	r0, r0, pc, lsl #4
    1114:	00000224 	andeq	r0, r0, r4, lsr #4
    1118:	0002890b 	andeq	r8, r2, fp, lsl #18
    111c:	02660c00 	rsbeq	r0, r6, #0, 24
    1120:	a10c0000 	mrsge	r0, (UNDEF: 12)
    1124:	0c000002 	stceq	0, cr0, [r0], {2}
    1128:	00000266 	andeq	r0, r0, r6, ror #4
    112c:	0b201000 	bleq	805134 <_bss_end+0x7fa6ac>
    1130:	2b020000 	blcs	81138 <_bss_end+0x766b0>
    1134:	0002ad23 	andeq	sl, r2, r3, lsr #26
    1138:	de100000 	cdple	0, 1, cr0, cr0, cr0, {0}
    113c:	0200000b 	andeq	r0, r0, #11
    1140:	0266122c 	rsbeq	r1, r6, #44, 4	; 0xc0000002
    1144:	10040000 	andne	r0, r4, r0
    1148:	00000ba7 	andeq	r0, r0, r7, lsr #23
    114c:	66122d02 	ldrvs	r2, [r2], -r2, lsl #26
    1150:	08000002 	stmdaeq	r0, {r1}
    1154:	000a6010 	andeq	r6, sl, r0, lsl r0
    1158:	0f2e0200 	svceq	0x002e0200
    115c:	00000057 	andeq	r0, r0, r7, asr r0
    1160:	0a70100c 	beq	1c05198 <_bss_end+0x1bfa710>
    1164:	2f020000 	svccs	0x00020000
    1168:	00003212 	andeq	r3, r0, r2, lsl r2
    116c:	11001400 	tstne	r0, r0, lsl #8
    1170:	19fd0704 	ldmibne	sp!, {r2, r8, r9, sl}^
    1174:	66050000 	strvs	r0, [r5], -r0
    1178:	12000002 	andne	r0, r0, #2
    117c:	00028404 	andeq	r8, r2, r4, lsl #8
    1180:	02720500 	rsbseq	r0, r2, #0, 10
    1184:	01110000 	tsteq	r1, r0
    1188:	00036a08 	andeq	r6, r3, r8, lsl #20
    118c:	027d0500 	rsbseq	r0, sp, #0, 10
    1190:	04120000 	ldreq	r0, [r2], #-0
    1194:	00000025 	andeq	r0, r0, r5, lsr #32
    1198:	00028905 	andeq	r8, r2, r5, lsl #18
    119c:	25041300 	strcs	r1, [r4, #-768]	; 0xfffffd00
    11a0:	11000000 	mrsne	r0, (UNDEF: 0)
    11a4:	06700201 	ldrbteq	r0, [r0], -r1, lsl #4
    11a8:	04120000 	ldreq	r0, [r2], #-0
    11ac:	0000027d 	andeq	r0, r0, sp, ror r2
    11b0:	02b90412 	adcseq	r0, r9, #301989888	; 0x12000000
    11b4:	a7050000 	strge	r0, [r5, -r0]
    11b8:	11000002 	tstne	r0, r2
    11bc:	03610801 	cmneq	r1, #65536	; 0x10000
    11c0:	b2140000 	andslt	r0, r4, #0
    11c4:	15000002 	strne	r0, [r0, #-2]
    11c8:	00000b39 	andeq	r0, r0, r9, lsr fp
    11cc:	25113202 	ldrcs	r3, [r1, #-514]	; 0xfffffdfe
    11d0:	16000000 	strne	r0, [r0], -r0
    11d4:	000002be 			; <UNDEFINED> instruction: 0x000002be
    11d8:	050a0301 	streq	r0, [sl, #-769]	; 0xfffffcff
    11dc:	00aa2003 	adceq	r2, sl, r3
    11e0:	0b2a1700 	bleq	a86de8 <_bss_end+0xa7c360>
    11e4:	919c0000 	orrsls	r0, ip, r0
    11e8:	001c0000 	andseq	r0, ip, r0
    11ec:	9c010000 	stcls	0, cr0, [r1], {-0}
    11f0:	00040318 	andeq	r0, r4, r8, lsl r3
    11f4:	00914400 	addseq	r4, r1, r0, lsl #8
    11f8:	00005800 	andeq	r5, r0, r0, lsl #16
    11fc:	199c0100 	ldmibne	ip, {r8}
    1200:	19000003 	stmdbne	r0, {r0, r1}
    1204:	0000033c 	andeq	r0, r0, ip, lsr r3
    1208:	1901a201 	stmdbne	r1, {r0, r9, sp, pc}
    120c:	02000003 	andeq	r0, r0, #3
    1210:	2d197491 	cfldrscs	mvf7, [r9, #-580]	; 0xfffffdbc
    1214:	01000004 	tsteq	r0, r4
    1218:	031901a2 	tsteq	r9, #-2147483608	; 0x80000028
    121c:	91020000 	mrsls	r0, (UNDEF: 2)
    1220:	041a0070 	ldreq	r0, [sl], #-112	; 0xffffff90
    1224:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
    1228:	01fb1b00 	mvnseq	r1, r0, lsl #22
    122c:	87010000 	strhi	r0, [r1, -r0]
    1230:	00033a06 	andeq	r3, r3, r6, lsl #20
    1234:	008fc800 	addeq	ip, pc, r0, lsl #16
    1238:	00017c00 	andeq	r7, r1, r0, lsl #24
    123c:	af9c0100 	svcge	0x009c0100
    1240:	1c000003 	stcne	0, cr0, [r0], {3}
    1244:	00000438 	andeq	r0, r0, r8, lsr r4
    1248:	0000028f 	andeq	r0, r0, pc, lsl #5
    124c:	19649102 	stmdbne	r4!, {r1, r8, ip, pc}^
    1250:	00000cd4 	ldrdeq	r0, [r0], -r4
    1254:	66228701 	strtvs	r8, [r2], -r1, lsl #14
    1258:	02000002 	andeq	r0, r0, #2
    125c:	cd196091 	ldcgt	0, cr6, [r9, #-580]	; 0xfffffdbc
    1260:	0100000c 	tsteq	r0, ip
    1264:	02a12f87 	adceq	r2, r1, #540	; 0x21c
    1268:	91020000 	mrsls	r0, (UNDEF: 2)
    126c:	16f7195c 	usatne	r1, #23, ip, asr #18
    1270:	87010000 	strhi	r0, [r1, -r0]
    1274:	00026644 	andeq	r6, r2, r4, asr #12
    1278:	58910200 	ldmpl	r1, {r9}
    127c:	0100691d 	tsteq	r0, sp, lsl r9
    1280:	03190989 	tsteq	r9, #2244608	; 0x224000
    1284:	91020000 	mrsls	r0, (UNDEF: 2)
    1288:	909c1e74 	addsls	r1, ip, r4, ror lr
    128c:	00980000 	addseq	r0, r8, r0
    1290:	6a1d0000 	bvs	741298 <_bss_end+0x736810>
    1294:	0e9c0100 	fmleqe	f0, f4, f0
    1298:	00000319 	andeq	r0, r0, r9, lsl r3
    129c:	1e709102 	expnes	f1, f2
    12a0:	000090c4 	andeq	r9, r0, r4, asr #1
    12a4:	00000060 	andeq	r0, r0, r0, rrx
    12a8:	0100631d 	tsteq	r0, sp, lsl r3
    12ac:	027d0e9e 	rsbseq	r0, sp, #2528	; 0x9e0
    12b0:	91020000 	mrsls	r0, (UNDEF: 2)
    12b4:	0000006f 	andeq	r0, r0, pc, rrx
    12b8:	00016f1b 	andeq	r6, r1, fp, lsl pc
    12bc:	0b770100 	bleq	1dc16c4 <_bss_end+0x1db6c3c>
    12c0:	000003c9 	andeq	r0, r0, r9, asr #7
    12c4:	00008f68 	andeq	r8, r0, r8, ror #30
    12c8:	00000060 	andeq	r0, r0, r0, rrx
    12cc:	03e59c01 	mvneq	r9, #256	; 0x100
    12d0:	381c0000 	ldmdacc	ip, {}	; <UNPREDICTABLE>
    12d4:	8f000004 	svchi	0x00000004
    12d8:	02000002 	andeq	r0, r0, #2
    12dc:	77197491 			; <UNDEFINED> instruction: 0x77197491
    12e0:	01000002 	tsteq	r0, r2
    12e4:	029a2577 	addseq	r2, sl, #499122176	; 0x1dc00000
    12e8:	91020000 	mrsls	r0, (UNDEF: 2)
    12ec:	4b1b0073 	blmi	6c14c0 <_bss_end+0x6b6a38>
    12f0:	01000001 	tsteq	r0, r1
    12f4:	03ff0b6a 	mvnseq	r0, #108544	; 0x1a800
    12f8:	8f140000 	svchi	0x00140000
    12fc:	00540000 	subseq	r0, r4, r0
    1300:	9c010000 	stcls	0, cr0, [r1], {-0}
    1304:	0000043f 	andeq	r0, r0, pc, lsr r4
    1308:	0004381c 	andeq	r3, r4, ip, lsl r8
    130c:	00028f00 	andeq	r8, r2, r0, lsl #30
    1310:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1314:	6d756e1f 	ldclvs	14, cr6, [r5, #-124]!	; 0xffffff84
    1318:	2d6a0100 	stfcse	f0, [sl, #-0]
    131c:	00000266 	andeq	r0, r0, r6, ror #4
    1320:	20709102 	rsbscs	r9, r0, r2, lsl #2
    1324:	00000ce3 	andeq	r0, r0, r3, ror #25
    1328:	6d236c01 	stcvs	12, cr6, [r3, #-4]!
    132c:	05000002 	streq	r0, [r0, #-2]
    1330:	00a77803 	adceq	r7, r7, r3, lsl #16
    1334:	0cda2100 	ldfeqe	f2, [sl], {0}
    1338:	6e010000 	cdpvs	0, 0, cr0, cr1, cr0, {0}
    133c:	00043f11 	andeq	r3, r4, r1, lsl pc
    1340:	38030500 	stmdacc	r3, {r8, sl}
    1344:	000000aa 	andeq	r0, r0, sl, lsr #1
    1348:	00027d22 	andeq	r7, r2, r2, lsr #26
    134c:	00044f00 	andeq	r4, r4, r0, lsl #30
    1350:	02662300 	rsbeq	r2, r6, #0, 6
    1354:	000f0000 	andeq	r0, pc, r0
    1358:	00012724 	andeq	r2, r1, r4, lsr #14
    135c:	0b630100 	bleq	18c1764 <_bss_end+0x18b6cdc>
    1360:	00000469 	andeq	r0, r0, r9, ror #8
    1364:	00008ee0 	andeq	r8, r0, r0, ror #29
    1368:	00000034 	andeq	r0, r0, r4, lsr r0
    136c:	04859c01 	streq	r9, [r5], #3073	; 0xc01
    1370:	381c0000 	ldmdacc	ip, {}	; <UNPREDICTABLE>
    1374:	8f000004 	svchi	0x00000004
    1378:	02000002 	andeq	r0, r0, #2
    137c:	72197491 	andsvc	r7, r9, #-1862270976	; 0x91000000
    1380:	0100000a 	tsteq	r0, sl
    1384:	00323763 	eorseq	r3, r2, r3, ror #14
    1388:	91020000 	mrsls	r0, (UNDEF: 2)
    138c:	031b0070 	tsteq	fp, #112	; 0x70
    1390:	01000001 	tsteq	r0, r1
    1394:	049f0b57 	ldreq	r0, [pc], #2903	; 139c <CPSR_IRQ_INHIBIT+0x131c>
    1398:	8e680000 	cdphi	0, 6, cr0, cr8, cr0, {0}
    139c:	00780000 	rsbseq	r0, r8, r0
    13a0:	9c010000 	stcls	0, cr0, [r1], {-0}
    13a4:	000004d2 	ldrdeq	r0, [r0], -r2
    13a8:	0004381c 	andeq	r3, r4, ip, lsl r8
    13ac:	00028f00 	andeq	r8, r2, r0, lsl #30
    13b0:	6c910200 	lfmvs	f0, 4, [r1], {0}
    13b4:	7274731f 	rsbsvc	r7, r4, #2080374784	; 0x7c000000
    13b8:	2c570100 	ldfcse	f0, [r7], {-0}
    13bc:	00000272 	andeq	r0, r0, r2, ror r2
    13c0:	1e689102 	lgnnee	f1, f2
    13c4:	00008e7c 	andeq	r8, r0, ip, ror lr
    13c8:	0000004c 	andeq	r0, r0, ip, asr #32
    13cc:	0100691d 	tsteq	r0, sp, lsl r9
    13d0:	02661759 	rsbeq	r1, r6, #23330816	; 0x1640000
    13d4:	91020000 	mrsls	r0, (UNDEF: 2)
    13d8:	1b000074 	blne	15b0 <CPSR_IRQ_INHIBIT+0x1530>
    13dc:	000000df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    13e0:	ec0b4501 	cfstr32	mvfx4, [fp], {1}
    13e4:	c0000004 	andgt	r0, r0, r4
    13e8:	a800008d 	stmdage	r0, {r0, r2, r3, r7}
    13ec:	01000000 	mrseq	r0, (UNDEF: 0)
    13f0:	0005069c 	muleq	r5, ip, r6
    13f4:	04381c00 	ldrteq	r1, [r8], #-3072	; 0xfffff400
    13f8:	028f0000 	addeq	r0, pc, #0
    13fc:	91020000 	mrsls	r0, (UNDEF: 2)
    1400:	00631f74 	rsbeq	r1, r3, r4, ror pc
    1404:	7d254501 	cfstr32vc	mvfx4, [r5, #-4]!
    1408:	02000002 	andeq	r0, r0, #2
    140c:	24007391 	strcs	r7, [r0], #-913	; 0xfffffc6f
    1410:	000001c7 	andeq	r0, r0, r7, asr #3
    1414:	20064001 	andcs	r4, r6, r1
    1418:	78000005 	stmdavc	r0, {r0, r2}
    141c:	2c000092 	stccs	0, cr0, [r0], {146}	; 0x92
    1420:	01000000 	mrseq	r0, (UNDEF: 0)
    1424:	00052d9c 	muleq	r5, ip, sp
    1428:	04381c00 	ldrteq	r1, [r8], #-3072	; 0xfffff400
    142c:	028f0000 	addeq	r0, pc, #0
    1430:	91020000 	mrsls	r0, (UNDEF: 2)
    1434:	e1240074 	bkpt	0x4004
    1438:	01000001 	tsteq	r0, r1
    143c:	05470630 	strbeq	r0, [r7, #-1584]	; 0xfffff9d0
    1440:	8c900000 	ldchi	0, cr0, [r0], {0}
    1444:	01300000 	teqeq	r0, r0
    1448:	9c010000 	stcls	0, cr0, [r1], {-0}
    144c:	0000059d 	muleq	r0, sp, r5
    1450:	0004381c 	andeq	r3, r4, ip, lsl r8
    1454:	00028f00 	andeq	r8, r2, r0, lsl #30
    1458:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    145c:	008ca025 	addeq	sl, ip, r5, lsr #32
    1460:	0000b000 	andeq	fp, r0, r0
    1464:	00058500 	andeq	r8, r5, r0, lsl #10
    1468:	00791d00 	rsbseq	r1, r9, r0, lsl #26
    146c:	66173201 	ldrvs	r3, [r7], -r1, lsl #4
    1470:	02000002 	andeq	r0, r0, #2
    1474:	bc1e7491 	cfldrslt	mvf7, [lr], {145}	; 0x91
    1478:	8400008c 	strhi	r0, [r0], #-140	; 0xffffff74
    147c:	1d000000 	stcne	0, cr0, [r0, #-0]
    1480:	34010078 	strcc	r0, [r1], #-120	; 0xffffff88
    1484:	0002661b 	andeq	r6, r2, fp, lsl r6
    1488:	70910200 	addsvc	r0, r1, r0, lsl #4
    148c:	501e0000 	andspl	r0, lr, r0
    1490:	6000008d 	andvs	r0, r0, sp, lsl #1
    1494:	1d000000 	stcne	0, cr0, [r0, #-0]
    1498:	3a010078 	bcc	41680 <_bss_end+0x36bf8>
    149c:	00026617 	andeq	r6, r2, r7, lsl r6
    14a0:	6c910200 	lfmvs	f0, 4, [r1], {0}
    14a4:	931b0000 	tstls	fp, #0
    14a8:	01000001 	tsteq	r0, r1
    14ac:	05b70621 	ldreq	r0, [r7, #1569]!	; 0x621
    14b0:	91f00000 	mvnsls	r0, r0
    14b4:	00880000 	addeq	r0, r8, r0
    14b8:	9c010000 	stcls	0, cr0, [r1], {-0}
    14bc:	000005c4 	andeq	r0, r0, r4, asr #11
    14c0:	0004381c 	andeq	r3, r4, ip, lsl r8
    14c4:	00028f00 	andeq	r8, r2, r0, lsl #30
    14c8:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    14cc:	00c41b00 	sbceq	r1, r4, r0, lsl #22
    14d0:	14010000 	strne	r0, [r1], #-0
    14d4:	0005de06 	andeq	sp, r5, r6, lsl #28
    14d8:	008be800 	addeq	lr, fp, r0, lsl #16
    14dc:	0000a800 	andeq	sl, r0, r0, lsl #16
    14e0:	199c0100 	ldmibne	ip, {r8}
    14e4:	1c000006 	stcne	0, cr0, [r0], {6}
    14e8:	00000438 	andeq	r0, r0, r8, lsr r4
    14ec:	0000028f 	andeq	r0, r0, pc, lsl #5
    14f0:	1e6c9102 	lgnnee	f1, f2
    14f4:	00008c00 	andeq	r8, r0, r0, lsl #24
    14f8:	00000084 	andeq	r0, r0, r4, lsl #1
    14fc:	0100791d 	tsteq	r0, sp, lsl r9
    1500:	02661718 	rsbeq	r1, r6, #24, 14	; 0x600000
    1504:	91020000 	mrsls	r0, (UNDEF: 2)
    1508:	8c1c1e74 	ldchi	14, cr1, [ip], {116}	; 0x74
    150c:	00580000 	subseq	r0, r8, r0
    1510:	781d0000 	ldmdavc	sp, {}	; <UNPREDICTABLE>
    1514:	1b1a0100 	blne	68191c <_bss_end+0x676e94>
    1518:	00000266 	andeq	r0, r0, r6, ror #4
    151c:	00709102 	rsbseq	r9, r0, r2, lsl #2
    1520:	ad240000 	stcge	0, cr0, [r4, #-0]
    1524:	01000001 	tsteq	r0, r1
    1528:	0633060e 	ldrteq	r0, [r3], -lr, lsl #12
    152c:	91b80000 			; <UNDEFINED> instruction: 0x91b80000
    1530:	00380000 	eorseq	r0, r8, r0
    1534:	9c010000 	stcls	0, cr0, [r1], {-0}
    1538:	00000640 	andeq	r0, r0, r0, asr #12
    153c:	0004381c 	andeq	r3, r4, ip, lsl r8
    1540:	00028f00 	andeq	r8, r2, r0, lsl #30
    1544:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1548:	00962600 	addseq	r2, r6, r0, lsl #12
    154c:	05010000 	streq	r0, [r1, #-0]
    1550:	00065101 	andeq	r5, r6, r1, lsl #2
    1554:	067f0000 	ldrbteq	r0, [pc], -r0
    1558:	38270000 	stmdacc	r7!, {}	; <UNPREDICTABLE>
    155c:	8f000004 	svchi	0x00000004
    1560:	28000002 	stmdacs	r0, {r1}
    1564:	00000b42 	andeq	r0, r0, r2, asr #22
    1568:	66210501 	strtvs	r0, [r1], -r1, lsl #10
    156c:	28000002 	stmdacs	r0, {r1}
    1570:	00000be0 	andeq	r0, r0, r0, ror #23
    1574:	66410501 	strbvs	r0, [r1], -r1, lsl #10
    1578:	28000002 	stmdacs	r0, {r1}
    157c:	00000ba9 	andeq	r0, r0, r9, lsr #23
    1580:	66550501 	ldrbvs	r0, [r5], -r1, lsl #10
    1584:	00000002 	andeq	r0, r0, r2
    1588:	00064029 	andeq	r4, r6, r9, lsr #32
    158c:	000a9600 	andeq	r9, sl, r0, lsl #12
    1590:	00069600 	andeq	r9, r6, r0, lsl #12
    1594:	008b7000 	addeq	r7, fp, r0
    1598:	00007800 	andeq	r7, r0, r0, lsl #16
    159c:	2a9c0100 	bcs	fe7019a4 <_bss_end+0xfe6f6f1c>
    15a0:	00000651 	andeq	r0, r0, r1, asr r6
    15a4:	2a749102 	bcs	1d259b4 <_bss_end+0x1d1af2c>
    15a8:	0000065a 	andeq	r0, r0, sl, asr r6
    15ac:	2a709102 	bcs	1c259bc <_bss_end+0x1c1af34>
    15b0:	00000666 	andeq	r0, r0, r6, ror #12
    15b4:	2a6c9102 	bcs	1b259c4 <_bss_end+0x1b1af3c>
    15b8:	00000672 	andeq	r0, r0, r2, ror r6
    15bc:	00689102 	rsbeq	r9, r8, r2, lsl #2
    15c0:	0007d700 	andeq	sp, r7, r0, lsl #14
    15c4:	cd000400 	cfstrsgt	mvf0, [r0, #-0]
    15c8:	04000007 	streq	r0, [r0], #-7
    15cc:	0000b501 	andeq	fp, r0, r1, lsl #10
    15d0:	0ef80400 	cdpeq	4, 15, cr0, cr8, cr0, {0}
    15d4:	00740000 	rsbseq	r0, r4, r0
    15d8:	92a40000 	adcls	r0, r4, #0
    15dc:	04e80000 	strbteq	r0, [r8], #0
    15e0:	0a820000 	beq	fe0815e8 <_bss_end+0xfe076b60>
    15e4:	01020000 	mrseq	r0, (UNDEF: 2)
    15e8:	00036a08 	andeq	r6, r3, r8, lsl #20
    15ec:	00250300 	eoreq	r0, r5, r0, lsl #6
    15f0:	02020000 	andeq	r0, r2, #0
    15f4:	00022a05 	andeq	r2, r2, r5, lsl #20
    15f8:	05040400 	streq	r0, [r4, #-1024]	; 0xfffffc00
    15fc:	00746e69 	rsbseq	r6, r4, r9, ror #28
    1600:	61080102 	tstvs	r8, r2, lsl #2
    1604:	02000003 	andeq	r0, r0, #3
    1608:	03b60702 			; <UNDEFINED> instruction: 0x03b60702
    160c:	94050000 	strls	r0, [r5], #-0
    1610:	05000003 	streq	r0, [r0, #-3]
    1614:	005e070b 	subseq	r0, lr, fp, lsl #14
    1618:	4d030000 	stcmi	0, cr0, [r3, #-0]
    161c:	02000000 	andeq	r0, r0, #0
    1620:	19fd0704 	ldmibne	sp!, {r2, r8, r9, sl}^
    1624:	5e030000 	cdppl	0, 0, cr0, cr3, cr0, {0}
    1628:	06000000 	streq	r0, [r0], -r0
    162c:	006c6168 	rsbeq	r6, ip, r8, ror #2
    1630:	a60b0702 	strge	r0, [fp], -r2, lsl #14
    1634:	07000001 	streq	r0, [r0, -r1]
    1638:	000004b6 			; <UNDEFINED> instruction: 0x000004b6
    163c:	651c0902 	ldrvs	r0, [ip, #-2306]	; 0xfffff6fe
    1640:	80000000 	andhi	r0, r0, r0
    1644:	070ee6b2 			; <UNDEFINED> instruction: 0x070ee6b2
    1648:	0000032c 	andeq	r0, r0, ip, lsr #6
    164c:	b21d0c02 	andslt	r0, sp, #512	; 0x200
    1650:	00000001 	andeq	r0, r0, r1
    1654:	07200000 	streq	r0, [r0, -r0]!
    1658:	0000037d 	andeq	r0, r0, sp, ror r3
    165c:	b21d0f02 	andslt	r0, sp, #2, 30
    1660:	00000001 	andeq	r0, r0, r1
    1664:	08202000 	stmdaeq	r0!, {sp}
    1668:	000003f4 	strdeq	r0, [r0], -r4
    166c:	59181202 	ldmdbpl	r8, {r1, r9, ip}
    1670:	36000000 	strcc	r0, [r0], -r0
    1674:	00047807 	andeq	r7, r4, r7, lsl #16
    1678:	1d440200 	sfmne	f0, 2, [r4, #-0]
    167c:	000001b2 			; <UNDEFINED> instruction: 0x000001b2
    1680:	20215000 	eorcs	r5, r1, r0
    1684:	00024909 	andeq	r4, r2, r9, lsl #18
    1688:	38040500 	stmdacc	r4, {r8, sl}
    168c:	02000000 	andeq	r0, r0, #0
    1690:	01601046 	cmneq	r0, r6, asr #32
    1694:	490a0000 	stmdbmi	sl, {}	; <UNPREDICTABLE>
    1698:	00005152 	andeq	r5, r0, r2, asr r1
    169c:	0002860b 	andeq	r8, r2, fp, lsl #12
    16a0:	980b0100 	stmdals	fp, {r8}
    16a4:	10000004 	andne	r0, r0, r4
    16a8:	00036f0b 	andeq	r6, r3, fp, lsl #30
    16ac:	9d0b1100 	stflss	f1, [fp, #-0]
    16b0:	12000003 	andne	r0, r0, #3
    16b4:	0003d10b 	andeq	sp, r3, fp, lsl #2
    16b8:	760b1300 	strvc	r1, [fp], -r0, lsl #6
    16bc:	14000003 	strne	r0, [r0], #-3
    16c0:	0004a70b 	andeq	sl, r4, fp, lsl #14
    16c4:	640b1500 	strvs	r1, [fp], #-1280	; 0xfffffb00
    16c8:	16000004 	strne	r0, [r0], -r4
    16cc:	0004f20b 	andeq	pc, r4, fp, lsl #4
    16d0:	a40b1700 	strge	r1, [fp], #-1792	; 0xfffff900
    16d4:	18000003 	stmdane	r0, {r0, r1}
    16d8:	0004810b 	andeq	r8, r4, fp, lsl #2
    16dc:	e20b1900 	and	r1, fp, #0, 18
    16e0:	1a000003 	bne	16f4 <CPSR_IRQ_INHIBIT+0x1674>
    16e4:	0003160b 	andeq	r1, r3, fp, lsl #12
    16e8:	210b2000 	mrscs	r2, (UNDEF: 11)
    16ec:	21000003 	tstcs	r0, r3
    16f0:	0003ea0b 	andeq	lr, r3, fp, lsl #20
    16f4:	fa0b2200 	blx	2c9efc <_bss_end+0x2bf474>
    16f8:	24000002 	strcs	r0, [r0], #-2
    16fc:	0003d80b 	andeq	sp, r3, fp, lsl #16
    1700:	4b0b2500 	blmi	2cab08 <_bss_end+0x2c0080>
    1704:	30000003 	andcc	r0, r0, r3
    1708:	0003560b 	andeq	r5, r3, fp, lsl #12
    170c:	3e0b3100 	adfcce	f3, f3, f0
    1710:	32000002 	andcc	r0, r0, #2
    1714:	0003c90b 	andeq	ip, r3, fp, lsl #18
    1718:	340b3400 	strcc	r3, [fp], #-1024	; 0xfffffc00
    171c:	35000002 	strcc	r0, [r0, #-2]
    1720:	02b60900 	adcseq	r0, r6, #0, 18
    1724:	04050000 	streq	r0, [r5], #-0
    1728:	00000038 	andeq	r0, r0, r8, lsr r0
    172c:	85106c02 	ldrhi	r6, [r0, #-3074]	; 0xfffff3fe
    1730:	0b000001 	bleq	173c <CPSR_IRQ_INHIBIT+0x16bc>
    1734:	0000049e 	muleq	r0, lr, r4
    1738:	03ac0b00 			; <UNDEFINED> instruction: 0x03ac0b00
    173c:	0b010000 	bleq	41744 <_bss_end+0x36cbc>
    1740:	000003b1 			; <UNDEFINED> instruction: 0x000003b1
    1744:	3d070002 	stccc	0, cr0, [r7, #-8]
    1748:	02000004 	andeq	r0, r0, #4
    174c:	01b21d73 			; <UNDEFINED> instruction: 0x01b21d73
    1750:	b2000000 	andlt	r0, r0, #0
    1754:	1f072000 	svcne	0x00072000
    1758:	02000002 	andeq	r0, r0, #2
    175c:	01b21da6 			; <UNDEFINED> instruction: 0x01b21da6
    1760:	b4000000 	strlt	r0, [r0], #-0
    1764:	0c002000 	stceq	0, cr2, [r0], {-0}
    1768:	00000076 	andeq	r0, r0, r6, ror r0
    176c:	f8070402 			; <UNDEFINED> instruction: 0xf8070402
    1770:	03000019 	movweq	r0, #25
    1774:	000001ab 	andeq	r0, r0, fp, lsr #3
    1778:	0000860c 	andeq	r8, r0, ip, lsl #12
    177c:	00960c00 	addseq	r0, r6, r0, lsl #24
    1780:	a60c0000 	strge	r0, [ip], -r0
    1784:	0c000000 	stceq	0, cr0, [r0], {-0}
    1788:	000000b3 	strheq	r0, [r0], -r3
    178c:	0001850c 	andeq	r8, r1, ip, lsl #10
    1790:	01950c00 	orrseq	r0, r5, r0, lsl #24
    1794:	d00d0000 	andle	r0, sp, r0
    1798:	0400000d 	streq	r0, [r0], #-13
    179c:	99070603 	stmdbls	r7, {r0, r1, r9, sl}
    17a0:	0e000002 	cdpeq	0, 0, cr0, cr0, cr2, {0}
    17a4:	00000248 	andeq	r0, r0, r8, asr #4
    17a8:	9f190a03 	svcls	0x00190a03
    17ac:	00000002 	andeq	r0, r0, r2
    17b0:	000dd00f 	andeq	sp, sp, pc
    17b4:	050d0300 	streq	r0, [sp, #-768]	; 0xfffffd00
    17b8:	000002c6 	andeq	r0, r0, r6, asr #5
    17bc:	000002a4 	andeq	r0, r0, r4, lsr #5
    17c0:	00020801 	andeq	r0, r2, r1, lsl #16
    17c4:	00021300 	andeq	r1, r2, r0, lsl #6
    17c8:	02a41000 	adceq	r1, r4, #0
    17cc:	5e110000 	cdppl	0, 1, cr0, cr1, cr0, {0}
    17d0:	00000000 	andeq	r0, r0, r0
    17d4:	0012f512 	andseq	pc, r2, r2, lsl r5	; <UNPREDICTABLE>
    17d8:	0a100300 	beq	4023e0 <_bss_end+0x3f7958>
    17dc:	0000028e 	andeq	r0, r0, lr, lsl #5
    17e0:	00022801 	andeq	r2, r2, r1, lsl #16
    17e4:	00023300 	andeq	r3, r2, r0, lsl #6
    17e8:	02a41000 	adceq	r1, r4, #0
    17ec:	60110000 	andsvs	r0, r1, r0
    17f0:	00000001 	andeq	r0, r0, r1
    17f4:	0011d512 	andseq	sp, r1, r2, lsl r5
    17f8:	0a120300 	beq	482400 <_bss_end+0x477978>
    17fc:	000004c9 	andeq	r0, r0, r9, asr #9
    1800:	00024801 	andeq	r4, r2, r1, lsl #16
    1804:	00025300 	andeq	r5, r2, r0, lsl #6
    1808:	02a41000 	adceq	r1, r4, #0
    180c:	60110000 	andsvs	r0, r1, r0
    1810:	00000001 	andeq	r0, r0, r1
    1814:	00045712 	andeq	r5, r4, r2, lsl r7
    1818:	0a150300 	beq	542420 <_bss_end+0x537998>
    181c:	000002d3 	ldrdeq	r0, [r0], -r3
    1820:	00026801 	andeq	r6, r2, r1, lsl #16
    1824:	00027800 	andeq	r7, r2, r0, lsl #16
    1828:	02a41000 	adceq	r1, r4, #0
    182c:	c3110000 	tstgt	r1, #0
    1830:	11000000 	mrsne	r0, (UNDEF: 0)
    1834:	0000004d 	andeq	r0, r0, sp, asr #32
    1838:	046b1300 	strbteq	r1, [fp], #-768	; 0xfffffd00
    183c:	17030000 	strne	r0, [r3, -r0]
    1840:	0002510e 	andeq	r5, r2, lr, lsl #2
    1844:	00004d00 	andeq	r4, r0, r0, lsl #26
    1848:	028d0100 	addeq	r0, sp, #0, 2
    184c:	a4100000 	ldrge	r0, [r0], #-0
    1850:	11000002 	tstne	r0, r2
    1854:	000000c3 	andeq	r0, r0, r3, asr #1
    1858:	04140000 	ldreq	r0, [r4], #-0
    185c:	0000005e 	andeq	r0, r0, lr, asr r0
    1860:	00029903 	andeq	r9, r2, r3, lsl #18
    1864:	d5041400 	strle	r1, [r4, #-1024]	; 0xfffffc00
    1868:	15000001 	strne	r0, [r0, #-1]
    186c:	00000311 	andeq	r0, r0, r1, lsl r3
    1870:	d50d1a03 	strle	r1, [sp, #-2563]	; 0xfffff5fd
    1874:	09000001 	stmdbeq	r0, {r0}
    1878:	00000eca 	andeq	r0, r0, sl, asr #29
    187c:	00380405 	eorseq	r0, r8, r5, lsl #8
    1880:	06040000 	streq	r0, [r4], -r0
    1884:	0002d50c 	andeq	sp, r2, ip, lsl #10
    1888:	0d920b00 	vldreq	d0, [r2]
    188c:	0b000000 	bleq	1894 <CPSR_IRQ_INHIBIT+0x1814>
    1890:	00000da9 	andeq	r0, r0, r9, lsr #27
    1894:	64090001 	strvs	r0, [r9], #-1
    1898:	0500000e 	streq	r0, [r0, #-14]
    189c:	00003804 	andeq	r3, r0, r4, lsl #16
    18a0:	0c0c0400 	cfstrseq	mvf0, [ip], {-0}
    18a4:	00000322 	andeq	r0, r0, r2, lsr #6
    18a8:	000e4116 	andeq	r4, lr, r6, lsl r1
    18ac:	1604b000 	strne	fp, [r4], -r0
    18b0:	00000d0f 	andeq	r0, r0, pc, lsl #26
    18b4:	38160960 	ldmdacc	r6, {r5, r6, r8, fp}
    18b8:	c000000d 	andgt	r0, r0, sp
    18bc:	0ef01612 	mrceq	6, 7, r1, cr0, cr2, {0}
    18c0:	25800000 	strcs	r0, [r0]
    18c4:	000e0e16 	andeq	r0, lr, r6, lsl lr
    18c8:	164b0000 	strbne	r0, [fp], -r0
    18cc:	00000e17 	andeq	r0, r0, r7, lsl lr
    18d0:	20169600 	andscs	r9, r6, r0, lsl #12
    18d4:	0000000e 	andeq	r0, r0, lr
    18d8:	0e3717e1 	cdpeq	7, 3, cr1, cr7, cr1, {7}
    18dc:	c2000000 	andgt	r0, r0, #0
    18e0:	0d000001 	stceq	0, cr0, [r0, #-4]
    18e4:	00000df2 	strdeq	r0, [r0], -r2
    18e8:	07180404 	ldreq	r0, [r8, -r4, lsl #8]
    18ec:	00000498 	muleq	r0, r8, r4
    18f0:	000d330e 	andeq	r3, sp, lr, lsl #6
    18f4:	0b1b0400 	bleq	6c28fc <_bss_end+0x6b7e74>
    18f8:	00000498 	muleq	r0, r8, r4
    18fc:	0df20f00 	ldcleq	15, cr0, [r2]
    1900:	1e040000 	cdpne	0, 0, cr0, cr4, cr0, {0}
    1904:	000e8605 	andeq	r8, lr, r5, lsl #12
    1908:	00049e00 	andeq	r9, r4, r0, lsl #28
    190c:	03550100 	cmpeq	r5, #0, 2
    1910:	03600000 	cmneq	r0, #0
    1914:	9e100000 	cdpls	0, 1, cr0, cr0, cr0, {0}
    1918:	11000004 	tstne	r0, r4
    191c:	00000498 	muleq	r0, r8, r4
    1920:	0d991200 	lfmeq	f1, 4, [r9]
    1924:	20040000 	andcs	r0, r4, r0
    1928:	000ead0a 	andeq	sl, lr, sl, lsl #26
    192c:	03750100 	cmneq	r5, #0, 2
    1930:	03800000 	orreq	r0, r0, #0
    1934:	9e100000 	cdpls	0, 1, cr0, cr0, cr0, {0}
    1938:	11000004 	tstne	r0, r4
    193c:	000002b6 			; <UNDEFINED> instruction: 0x000002b6
    1940:	0e291200 	cdpeq	2, 2, cr1, cr9, cr0, {0}
    1944:	21040000 	mrscs	r0, (UNDEF: 4)
    1948:	000e490a 	andeq	r4, lr, sl, lsl #18
    194c:	03950100 	orrseq	r0, r5, #0, 2
    1950:	03a00000 	moveq	r0, #0
    1954:	9e100000 	cdpls	0, 1, cr0, cr0, cr0, {0}
    1958:	11000004 	tstne	r0, r4
    195c:	000002d5 	ldrdeq	r0, [r0], -r5
    1960:	0d171200 	lfmeq	f1, 4, [r7, #-0]
    1964:	25040000 	strcs	r0, [r4, #-0]
    1968:	000e740a 	andeq	r7, lr, sl, lsl #8
    196c:	03b50100 			; <UNDEFINED> instruction: 0x03b50100
    1970:	03c00000 	biceq	r0, r0, #0
    1974:	9e100000 	cdpls	0, 1, cr0, cr0, cr0, {0}
    1978:	11000004 	tstne	r0, r4
    197c:	00000025 	andeq	r0, r0, r5, lsr #32
    1980:	0d171200 	lfmeq	f1, 4, [r7, #-0]
    1984:	26040000 	strcs	r0, [r4], -r0
    1988:	000e990a 	andeq	r9, lr, sl, lsl #18
    198c:	03d50100 	bicseq	r0, r5, #0, 2
    1990:	03e00000 	mvneq	r0, #0
    1994:	9e100000 	cdpls	0, 1, cr0, cr0, cr0, {0}
    1998:	11000004 	tstne	r0, r4
    199c:	000004a9 	andeq	r0, r0, r9, lsr #9
    19a0:	0d171200 	lfmeq	f1, 4, [r7, #-0]
    19a4:	27040000 	strcs	r0, [r4, -r0]
    19a8:	000d6b0a 	andeq	r6, sp, sl, lsl #22
    19ac:	03f50100 	mvnseq	r0, #0, 2
    19b0:	04050000 	streq	r0, [r5], #-0
    19b4:	9e100000 	cdpls	0, 1, cr0, cr0, cr0, {0}
    19b8:	11000004 	tstne	r0, r4
    19bc:	000004a9 	andeq	r0, r0, r9, lsr #9
    19c0:	00005e11 	andeq	r5, r0, r1, lsl lr
    19c4:	17120000 	ldrne	r0, [r2, -r0]
    19c8:	0400000d 	streq	r0, [r0], #-13
    19cc:	0db00a28 			; <UNDEFINED> instruction: 0x0db00a28
    19d0:	1a010000 	bne	419d8 <_bss_end+0x36f50>
    19d4:	25000004 	strcs	r0, [r0, #-4]
    19d8:	10000004 	andne	r0, r0, r4
    19dc:	0000049e 	muleq	r0, lr, r4
    19e0:	00005e11 	andeq	r5, r0, r1, lsl lr
    19e4:	d5120000 	ldrle	r0, [r2, #-0]
    19e8:	0400000d 	streq	r0, [r0], #-13
    19ec:	0d1d0a29 	vldreq	s0, [sp, #-164]	; 0xffffff5c
    19f0:	3a010000 	bcc	419f8 <_bss_end+0x36f70>
    19f4:	45000004 	strmi	r0, [r0, #-4]
    19f8:	10000004 	andne	r0, r0, r4
    19fc:	0000049e 	muleq	r0, lr, r4
    1a00:	00005e11 	andeq	r5, r0, r1, lsl lr
    1a04:	61120000 	tstvs	r2, r0
    1a08:	0400000d 	streq	r0, [r0], #-13
    1a0c:	0d800a2a 	vstreq	s0, [r0, #168]	; 0xa8
    1a10:	5a010000 	bpl	41a18 <_bss_end+0x36f90>
    1a14:	65000004 	strvs	r0, [r0, #-4]
    1a18:	10000004 	andne	r0, r0, r4
    1a1c:	0000049e 	muleq	r0, lr, r4
    1a20:	0004af11 	andeq	sl, r4, r1, lsl pc
    1a24:	df120000 	svcle	0x00120000
    1a28:	0400000d 	streq	r0, [r0], #-13
    1a2c:	0cef0a2c 	vstmiaeq	pc!, {s1-s44}
    1a30:	7a010000 	bvc	41a38 <_bss_end+0x36fb0>
    1a34:	80000004 	andhi	r0, r0, r4
    1a38:	10000004 	andne	r0, r0, r4
    1a3c:	0000049e 	muleq	r0, lr, r4
    1a40:	0edc1800 	cdpeq	8, 13, cr1, cr12, cr0, {0}
    1a44:	2d040000 	stccs	0, cr0, [r4, #-0]
    1a48:	000d400a 	andeq	r4, sp, sl
    1a4c:	04910100 	ldreq	r0, [r1], #256	; 0x100
    1a50:	9e100000 	cdpls	0, 1, cr0, cr0, cr0, {0}
    1a54:	00000004 	andeq	r0, r0, r4
    1a58:	d5041900 	strle	r1, [r4, #-2304]	; 0xfffff700
    1a5c:	14000001 	strne	r0, [r0], #-1
    1a60:	00032204 	andeq	r2, r3, r4, lsl #4
    1a64:	049e0300 	ldreq	r0, [lr], #768	; 0x300
    1a68:	04140000 	ldreq	r0, [r4], #-0
    1a6c:	0000002c 	andeq	r0, r0, ip, lsr #32
    1a70:	00250414 	eoreq	r0, r5, r4, lsl r4
    1a74:	07150000 	ldreq	r0, [r5, -r0]
    1a78:	0400000e 	streq	r0, [r0], #-14
    1a7c:	03220e30 			; <UNDEFINED> instruction: 0x03220e30
    1a80:	01020000 	mrseq	r0, (UNDEF: 2)
    1a84:	00067002 	andeq	r7, r6, r2
    1a88:	04b51a00 	ldrteq	r1, [r5], #2560	; 0xa00
    1a8c:	06010000 	streq	r0, [r1], -r0
    1a90:	48030507 	stmdami	r3, {r0, r1, r2, r8, sl}
    1a94:	1b0000aa 	blne	1d44 <CPSR_IRQ_INHIBIT+0x1cc4>
    1a98:	00000df8 	strdeq	r0, [r0], -r8
    1a9c:	00009770 	andeq	r9, r0, r0, ror r7
    1aa0:	0000001c 	andeq	r0, r0, ip, lsl r0
    1aa4:	031c9c01 	tsteq	ip, #256	; 0x100
    1aa8:	1c000004 	stcne	0, cr0, [r0], {4}
    1aac:	54000097 	strpl	r0, [r0], #-151	; 0xffffff69
    1ab0:	01000000 	mrseq	r0, (UNDEF: 0)
    1ab4:	0005179c 	muleq	r5, ip, r7
    1ab8:	033c1d00 	teqeq	ip, #0, 26
    1abc:	5f010000 	svcpl	0x00010000
    1ac0:	00003801 	andeq	r3, r0, r1, lsl #16
    1ac4:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1ac8:	00042d1d 	andeq	r2, r4, sp, lsl sp
    1acc:	015f0100 	cmpeq	pc, r0, lsl #2
    1ad0:	00000038 	andeq	r0, r0, r8, lsr r0
    1ad4:	00709102 	rsbseq	r9, r0, r2, lsl #2
    1ad8:	0004801e 	andeq	r8, r4, lr, lsl r0
    1adc:	065c0100 	ldrbeq	r0, [ip], -r0, lsl #2
    1ae0:	00000531 	andeq	r0, r0, r1, lsr r5
    1ae4:	000096cc 	andeq	r9, r0, ip, asr #13
    1ae8:	00000050 	andeq	r0, r0, r0, asr r0
    1aec:	053e9c01 	ldreq	r9, [lr, #-3073]!	; 0xfffff3ff
    1af0:	381f0000 	ldmdacc	pc, {}	; <UNPREDICTABLE>
    1af4:	a4000004 	strge	r0, [r0], #-4
    1af8:	02000004 	andeq	r0, r0, #4
    1afc:	1e006c91 	mcrne	12, 0, r6, cr0, cr1, {4}
    1b00:	00000465 	andeq	r0, r0, r5, ror #8
    1b04:	58065701 	stmdapl	r6, {r0, r8, r9, sl, ip, lr}
    1b08:	7c000005 	stcvc	0, cr0, [r0], {5}
    1b0c:	50000096 	mulpl	r0, r6, r0
    1b10:	01000000 	mrseq	r0, (UNDEF: 0)
    1b14:	0005659c 	muleq	r5, ip, r5
    1b18:	04381f00 	ldrteq	r1, [r8], #-3840	; 0xfffff100
    1b1c:	04a40000 	strteq	r0, [r4], #0
    1b20:	91020000 	mrsls	r0, (UNDEF: 2)
    1b24:	451e006c 	ldrmi	r0, [lr, #-108]	; 0xffffff94
    1b28:	01000004 	tsteq	r0, r4
    1b2c:	057f064e 	ldrbeq	r0, [pc, #-1614]!	; 14e6 <CPSR_IRQ_INHIBIT+0x1466>
    1b30:	96000000 	strls	r0, [r0], -r0
    1b34:	007c0000 	rsbseq	r0, ip, r0
    1b38:	9c010000 	stcls	0, cr0, [r1], {-0}
    1b3c:	00000599 	muleq	r0, r9, r5
    1b40:	0004381f 	andeq	r3, r4, pc, lsl r8
    1b44:	0004a400 	andeq	sl, r4, r0, lsl #8
    1b48:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1b4c:	01006320 	tsteq	r0, r0, lsr #6
    1b50:	04af184e 	strteq	r1, [pc], #2126	; 1b58 <CPSR_IRQ_INHIBIT+0x1ad8>
    1b54:	91020000 	mrsls	r0, (UNDEF: 2)
    1b58:	251e0070 	ldrcs	r0, [lr, #-112]	; 0xffffff90
    1b5c:	01000004 	tsteq	r0, r4
    1b60:	05b30646 	ldreq	r0, [r3, #1606]!	; 0x646
    1b64:	95c00000 	strbls	r0, [r0]
    1b68:	00400000 	subeq	r0, r0, r0
    1b6c:	9c010000 	stcls	0, cr0, [r1], {-0}
    1b70:	000005e1 	andeq	r0, r0, r1, ror #11
    1b74:	0004381f 	andeq	r3, r4, pc, lsl r8
    1b78:	0004a400 	andeq	sl, r4, r0, lsl #8
    1b7c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1b80:	6d756e20 	ldclvs	14, cr6, [r5, #-128]!	; 0xffffff80
    1b84:	24460100 	strbcs	r0, [r6], #-256	; 0xffffff00
    1b88:	0000005e 	andeq	r0, r0, lr, asr r0
    1b8c:	21709102 	cmncs	r0, r2, lsl #2
    1b90:	00667562 	rsbeq	r7, r6, r2, ror #10
    1b94:	e1114801 	tst	r1, r1, lsl #16
    1b98:	05000005 	streq	r0, [r0, #-5]
    1b9c:	00aa5c03 	adceq	r5, sl, r3, lsl #24
    1ba0:	25220000 	strcs	r0, [r2, #-0]!
    1ba4:	f1000000 	cps	#0
    1ba8:	23000005 	movwcs	r0, #5
    1bac:	0000005e 	andeq	r0, r0, lr, asr r0
    1bb0:	051e000f 	ldreq	r0, [lr, #-15]
    1bb4:	01000004 	tsteq	r0, r4
    1bb8:	060b063e 			; <UNDEFINED> instruction: 0x060b063e
    1bbc:	95800000 	strls	r0, [r0]
    1bc0:	00400000 	subeq	r0, r0, r0
    1bc4:	9c010000 	stcls	0, cr0, [r1], {-0}
    1bc8:	00000639 	andeq	r0, r0, r9, lsr r6
    1bcc:	0004381f 	andeq	r3, r4, pc, lsl r8
    1bd0:	0004a400 	andeq	sl, r4, r0, lsl #8
    1bd4:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1bd8:	6d756e20 	ldclvs	14, cr6, [r5, #-128]!	; 0xffffff80
    1bdc:	203e0100 	eorscs	r0, lr, r0, lsl #2
    1be0:	0000005e 	andeq	r0, r0, lr, asr r0
    1be4:	21709102 	cmncs	r0, r2, lsl #2
    1be8:	00667562 	rsbeq	r7, r6, r2, ror #10
    1bec:	e1114001 	tst	r1, r1
    1bf0:	05000005 	streq	r0, [r0, #-5]
    1bf4:	00aa4c03 	adceq	r4, sl, r3, lsl #24
    1bf8:	e01e0000 	ands	r0, lr, r0
    1bfc:	01000003 	tsteq	r0, r3
    1c00:	06530636 			; <UNDEFINED> instruction: 0x06530636
    1c04:	95180000 	ldrls	r0, [r8, #-0]
    1c08:	00680000 	rsbeq	r0, r8, r0
    1c0c:	9c010000 	stcls	0, cr0, [r1], {-0}
    1c10:	0000068b 	andeq	r0, r0, fp, lsl #13
    1c14:	0004381f 	andeq	r3, r4, pc, lsl r8
    1c18:	0004a400 	andeq	sl, r4, r0, lsl #8
    1c1c:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1c20:	72747320 	rsbsvc	r7, r4, #32, 6	; 0x80000000
    1c24:	1f360100 	svcne	0x00360100
    1c28:	000004a9 	andeq	r0, r0, r9, lsr #9
    1c2c:	20689102 	rsbcs	r9, r8, r2, lsl #2
    1c30:	006e656c 	rsbeq	r6, lr, ip, ror #10
    1c34:	5e313601 	cfmsuba32pl	mvax0, mvax3, mvfx1, mvfx1
    1c38:	02000000 	andeq	r0, r0, #0
    1c3c:	69216491 	stmdbvs	r1!, {r0, r4, r7, sl, sp, lr}
    1c40:	12380100 	eorsne	r0, r8, #0, 2
    1c44:	0000005e 	andeq	r0, r0, lr, asr r0
    1c48:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1c4c:	0003c01e 	andeq	ip, r3, lr, lsl r0
    1c50:	062e0100 	strteq	r0, [lr], -r0, lsl #2
    1c54:	000006a5 	andeq	r0, r0, r5, lsr #13
    1c58:	000094ac 	andeq	r9, r0, ip, lsr #9
    1c5c:	0000006c 	andeq	r0, r0, ip, rrx
    1c60:	06ce9c01 	strbeq	r9, [lr], r1, lsl #24
    1c64:	381f0000 	ldmdacc	pc, {}	; <UNPREDICTABLE>
    1c68:	a4000004 	strge	r0, [r0], #-4
    1c6c:	02000004 	andeq	r0, r0, #4
    1c70:	73206c91 			; <UNDEFINED> instruction: 0x73206c91
    1c74:	01007274 	tsteq	r0, r4, ror r2
    1c78:	04a91f2e 	strteq	r1, [r9], #3886	; 0xf2e
    1c7c:	91020000 	mrsls	r0, (UNDEF: 2)
    1c80:	00692168 	rsbeq	r2, r9, r8, ror #2
    1c84:	38093001 	stmdacc	r9, {r0, ip, sp}
    1c88:	02000000 	andeq	r0, r0, #0
    1c8c:	24007491 	strcs	r7, [r0], #-1169	; 0xfffffb6f
    1c90:	000003a0 	andeq	r0, r0, r0, lsr #7
    1c94:	06e70601 	strbteq	r0, [r7], r1, lsl #12
    1c98:	94380000 	ldrtls	r0, [r8], #-0
    1c9c:	00740000 	rsbseq	r0, r4, r0
    1ca0:	9c010000 	stcls	0, cr0, [r1], {-0}
    1ca4:	00000701 	andeq	r0, r0, r1, lsl #14
    1ca8:	0004381f 	andeq	r3, r4, pc, lsl r8
    1cac:	0004a400 	andeq	sl, r4, r0, lsl #8
    1cb0:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1cb4:	01006320 	tsteq	r0, r0, lsr #6
    1cb8:	00251825 	eoreq	r1, r5, r5, lsr #16
    1cbc:	91020000 	mrsls	r0, (UNDEF: 2)
    1cc0:	801e0073 	andshi	r0, lr, r3, ror r0
    1cc4:	01000003 	tsteq	r0, r3
    1cc8:	071b0619 			; <UNDEFINED> instruction: 0x071b0619
    1ccc:	93a40000 			; <UNDEFINED> instruction: 0x93a40000
    1cd0:	00940000 	addseq	r0, r4, r0
    1cd4:	9c010000 	stcls	0, cr0, [r1], {-0}
    1cd8:	00000755 	andeq	r0, r0, r5, asr r7
    1cdc:	0004381f 	andeq	r3, r4, pc, lsl r8
    1ce0:	0004a400 	andeq	sl, r4, r0, lsl #8
    1ce4:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1ce8:	000d661d 	andeq	r6, sp, sp, lsl r6
    1cec:	2b190100 	blcs	6420f4 <_bss_end+0x63766c>
    1cf0:	000002d5 	ldrdeq	r0, [r0], -r5
    1cf4:	25689102 	strbcs	r9, [r8, #-258]!	; 0xfffffefe
    1cf8:	000004be 			; <UNDEFINED> instruction: 0x000004be
    1cfc:	651c1b01 	ldrvs	r1, [ip, #-2817]	; 0xfffff4ff
    1d00:	02000000 	andeq	r0, r0, #0
    1d04:	76217491 			; <UNDEFINED> instruction: 0x76217491
    1d08:	01006c61 	tsteq	r0, r1, ror #24
    1d0c:	0065181c 	rsbeq	r1, r5, ip, lsl r8
    1d10:	91020000 	mrsls	r0, (UNDEF: 2)
    1d14:	601e0070 	andsvs	r0, lr, r0, ror r0
    1d18:	01000003 	tsteq	r0, r3
    1d1c:	076f0613 			; <UNDEFINED> instruction: 0x076f0613
    1d20:	93480000 	movtls	r0, #32768	; 0x8000
    1d24:	005c0000 	subseq	r0, ip, r0
    1d28:	9c010000 	stcls	0, cr0, [r1], {-0}
    1d2c:	0000078b 	andeq	r0, r0, fp, lsl #15
    1d30:	0004381f 	andeq	r3, r4, pc, lsl r8
    1d34:	0004a400 	andeq	sl, r4, r0, lsl #8
    1d38:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1d3c:	6e656c20 	cdpvs	12, 6, cr6, cr5, cr0, {1}
    1d40:	2f130100 	svccs	0x00130100
    1d44:	000002b6 			; <UNDEFINED> instruction: 0x000002b6
    1d48:	00689102 	rsbeq	r9, r8, r2, lsl #2
    1d4c:	00033c26 	andeq	r3, r3, r6, lsr #24
    1d50:	01080100 	mrseq	r0, (UNDEF: 24)
    1d54:	0000079c 	muleq	r0, ip, r7
    1d58:	0007b200 	andeq	fp, r7, r0, lsl #4
    1d5c:	04382700 	ldrteq	r2, [r8], #-1792	; 0xfffff900
    1d60:	04a40000 	strteq	r0, [r4], #0
    1d64:	61280000 			; <UNDEFINED> instruction: 0x61280000
    1d68:	01007875 	tsteq	r0, r5, ror r8
    1d6c:	04981408 	ldreq	r1, [r8], #1032	; 0x408
    1d70:	29000000 	stmdbcs	r0, {}	; <UNPREDICTABLE>
    1d74:	0000078b 	andeq	r0, r0, fp, lsl #15
    1d78:	00000dc2 	andeq	r0, r0, r2, asr #27
    1d7c:	000007c9 	andeq	r0, r0, r9, asr #15
    1d80:	000092a4 	andeq	r9, r0, r4, lsr #5
    1d84:	000000a4 	andeq	r0, r0, r4, lsr #1
    1d88:	9c2a9c01 	stcls	12, cr9, [sl], #-4
    1d8c:	02000007 	andeq	r0, r0, #7
    1d90:	a52a7491 	strge	r7, [sl, #-1169]!	; 0xfffffb6f
    1d94:	02000007 	andeq	r0, r0, #7
    1d98:	00007091 	muleq	r0, r1, r0
    1d9c:	00000944 	andeq	r0, r0, r4, asr #18
    1da0:	0a590004 	beq	1641db8 <_bss_end+0x1637330>
    1da4:	01040000 	mrseq	r0, (UNDEF: 4)
    1da8:	000000b5 	strheq	r0, [r0], -r5
    1dac:	00115604 	andseq	r5, r1, r4, lsl #12
    1db0:	00007400 	andeq	r7, r0, r0, lsl #8
    1db4:	00978c00 	addseq	r8, r7, r0, lsl #24
    1db8:	0005cc00 	andeq	ip, r5, r0, lsl #24
    1dbc:	000d1c00 	andeq	r1, sp, r0, lsl #24
    1dc0:	08010200 	stmdaeq	r1, {r9}
    1dc4:	0000036a 	andeq	r0, r0, sl, ror #6
    1dc8:	00002503 	andeq	r2, r0, r3, lsl #10
    1dcc:	05020200 	streq	r0, [r2, #-512]	; 0xfffffe00
    1dd0:	0000022a 	andeq	r0, r0, sl, lsr #4
    1dd4:	69050404 	stmdbvs	r5, {r2, sl}
    1dd8:	0500746e 	streq	r7, [r0, #-1134]	; 0xfffffb92
    1ddc:	00000038 	andeq	r0, r0, r8, lsr r0
    1de0:	61080102 	tstvs	r8, r2, lsl #2
    1de4:	02000003 	andeq	r0, r0, #3
    1de8:	03b60702 			; <UNDEFINED> instruction: 0x03b60702
    1dec:	94060000 	strls	r0, [r6], #-0
    1df0:	06000003 	streq	r0, [r0], -r3
    1df4:	0063070b 	rsbeq	r0, r3, fp, lsl #14
    1df8:	52030000 	andpl	r0, r3, #0
    1dfc:	02000000 	andeq	r0, r0, #0
    1e00:	19fd0704 	ldmibne	sp!, {r2, r8, r9, sl}^
    1e04:	63030000 	movwvs	r0, #12288	; 0x3000
    1e08:	05000000 	streq	r0, [r0, #-0]
    1e0c:	00000063 	andeq	r0, r0, r3, rrx
    1e10:	6c616807 	stclvs	8, cr6, [r1], #-28	; 0xffffffe4
    1e14:	0b070200 	bleq	1c261c <_bss_end+0x1b7b94>
    1e18:	000002a3 	andeq	r0, r0, r3, lsr #5
    1e1c:	0004b608 	andeq	fp, r4, r8, lsl #12
    1e20:	1c090200 	sfmne	f0, 4, [r9], {-0}
    1e24:	0000006a 	andeq	r0, r0, sl, rrx
    1e28:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}
    1e2c:	00032c08 	andeq	r2, r3, r8, lsl #24
    1e30:	1d0c0200 	sfmne	f0, 4, [ip, #-0]
    1e34:	000002af 	andeq	r0, r0, pc, lsr #5
    1e38:	20000000 	andcs	r0, r0, r0
    1e3c:	00037d08 	andeq	r7, r3, r8, lsl #26
    1e40:	1d0f0200 	sfmne	f0, 4, [pc, #-0]	; 1e48 <CPSR_IRQ_INHIBIT+0x1dc8>
    1e44:	000002af 	andeq	r0, r0, pc, lsr #5
    1e48:	20200000 	eorcs	r0, r0, r0
    1e4c:	0003f409 	andeq	pc, r3, r9, lsl #8
    1e50:	18120200 	ldmdane	r2, {r9}
    1e54:	0000005e 	andeq	r0, r0, lr, asr r0
    1e58:	04780836 	ldrbteq	r0, [r8], #-2102	; 0xfffff7ca
    1e5c:	44020000 	strmi	r0, [r2], #-0
    1e60:	0002af1d 	andeq	sl, r2, sp, lsl pc
    1e64:	21500000 	cmpcs	r0, r0
    1e68:	02490a20 	subeq	r0, r9, #32, 20	; 0x20000
    1e6c:	04050000 	streq	r0, [r5], #-0
    1e70:	00000038 	andeq	r0, r0, r8, lsr r0
    1e74:	6a104602 	bvs	413684 <_bss_end+0x408bfc>
    1e78:	0b000001 	bleq	1e84 <CPSR_IRQ_INHIBIT+0x1e04>
    1e7c:	00515249 	subseq	r5, r1, r9, asr #4
    1e80:	02860c00 	addeq	r0, r6, #0, 24
    1e84:	0c010000 	stceq	0, cr0, [r1], {-0}
    1e88:	00000498 	muleq	r0, r8, r4
    1e8c:	036f0c10 	cmneq	pc, #16, 24	; 0x1000
    1e90:	0c110000 	ldceq	0, cr0, [r1], {-0}
    1e94:	0000039d 	muleq	r0, sp, r3
    1e98:	03d10c12 	bicseq	r0, r1, #4608	; 0x1200
    1e9c:	0c130000 	ldceq	0, cr0, [r3], {-0}
    1ea0:	00000376 	andeq	r0, r0, r6, ror r3
    1ea4:	04a70c14 	strteq	r0, [r7], #3092	; 0xc14
    1ea8:	0c150000 	ldceq	0, cr0, [r5], {-0}
    1eac:	00000464 	andeq	r0, r0, r4, ror #8
    1eb0:	04f20c16 	ldrbteq	r0, [r2], #3094	; 0xc16
    1eb4:	0c170000 	ldceq	0, cr0, [r7], {-0}
    1eb8:	000003a4 	andeq	r0, r0, r4, lsr #7
    1ebc:	04810c18 	streq	r0, [r1], #3096	; 0xc18
    1ec0:	0c190000 	ldceq	0, cr0, [r9], {-0}
    1ec4:	000003e2 	andeq	r0, r0, r2, ror #7
    1ec8:	03160c1a 	tsteq	r6, #6656	; 0x1a00
    1ecc:	0c200000 	stceq	0, cr0, [r0], #-0
    1ed0:	00000321 	andeq	r0, r0, r1, lsr #6
    1ed4:	03ea0c21 	mvneq	r0, #8448	; 0x2100
    1ed8:	0c220000 	stceq	0, cr0, [r2], #-0
    1edc:	000002fa 	strdeq	r0, [r0], -sl
    1ee0:	03d80c24 	bicseq	r0, r8, #36, 24	; 0x2400
    1ee4:	0c250000 	stceq	0, cr0, [r5], #-0
    1ee8:	0000034b 	andeq	r0, r0, fp, asr #6
    1eec:	03560c30 	cmpeq	r6, #48, 24	; 0x3000
    1ef0:	0c310000 	ldceq	0, cr0, [r1], #-0
    1ef4:	0000023e 	andeq	r0, r0, lr, lsr r2
    1ef8:	03c90c32 	biceq	r0, r9, #12800	; 0x3200
    1efc:	0c340000 	ldceq	0, cr0, [r4], #-0
    1f00:	00000234 	andeq	r0, r0, r4, lsr r2
    1f04:	b60a0035 			; <UNDEFINED> instruction: 0xb60a0035
    1f08:	05000002 	streq	r0, [r0, #-2]
    1f0c:	00003804 	andeq	r3, r0, r4, lsl #16
    1f10:	106c0200 	rsbne	r0, ip, r0, lsl #4
    1f14:	0000018f 	andeq	r0, r0, pc, lsl #3
    1f18:	00049e0c 	andeq	r9, r4, ip, lsl #28
    1f1c:	ac0c0000 	stcge	0, cr0, [ip], {-0}
    1f20:	01000003 	tsteq	r0, r3
    1f24:	0003b10c 	andeq	fp, r3, ip, lsl #2
    1f28:	08000200 	stmdaeq	r0, {r9}
    1f2c:	0000043d 	andeq	r0, r0, sp, lsr r4
    1f30:	af1d7302 	svcge	0x001d7302
    1f34:	00000002 	andeq	r0, r0, r2
    1f38:	0a2000b2 	beq	802208 <_bss_end+0x7f7780>
    1f3c:	00001073 	andeq	r1, r0, r3, ror r0
    1f40:	00380405 	eorseq	r0, r8, r5, lsl #8
    1f44:	75020000 	strvc	r0, [r2, #-0]
    1f48:	0001ee10 	andeq	lr, r1, r0, lsl lr
    1f4c:	11440c00 	cmpne	r4, r0, lsl #24
    1f50:	0c000000 	stceq	0, cr0, [r0], {-0}
    1f54:	00001317 	andeq	r1, r0, r7, lsl r3
    1f58:	13250c01 			; <UNDEFINED> instruction: 0x13250c01
    1f5c:	0c020000 	stceq	0, cr0, [r2], {-0}
    1f60:	000012d3 	ldrdeq	r1, [r0], -r3
    1f64:	10120c03 	andsne	r0, r2, r3, lsl #24
    1f68:	0c040000 	stceq	0, cr0, [r4], {-0}
    1f6c:	0000101f 	andeq	r1, r0, pc, lsl r0
    1f70:	12eb0c05 	rscne	r0, fp, #1280	; 0x500
    1f74:	0c060000 	stceq	0, cr0, [r6], {-0}
    1f78:	0000137e 	andeq	r1, r0, lr, ror r3
    1f7c:	138c0c07 	orrne	r0, ip, #1792	; 0x700
    1f80:	0c080000 	stceq	0, cr0, [r8], {-0}
    1f84:	000011cb 	andeq	r1, r0, fp, asr #3
    1f88:	ba0a0009 	blt	281fb4 <_bss_end+0x27752c>
    1f8c:	05000010 	streq	r0, [r0, #-16]
    1f90:	00003804 	andeq	r3, r0, r4, lsl #16
    1f94:	10830200 	addne	r0, r3, r0, lsl #4
    1f98:	00000231 	andeq	r0, r0, r1, lsr r2
    1f9c:	0010ec0c 	andseq	lr, r0, ip, lsl #24
    1fa0:	dd0c0000 	stcle	0, cr0, [ip, #-0]
    1fa4:	0100000f 	tsteq	r0, pc
    1fa8:	0012000c 	andseq	r0, r2, ip
    1fac:	0b0c0200 	bleq	3027b4 <_bss_end+0x2f7d2c>
    1fb0:	03000012 	movweq	r0, #18
    1fb4:	0011ee0c 	andseq	lr, r1, ip, lsl #28
    1fb8:	d30c0400 	movwle	r0, #50176	; 0xc400
    1fbc:	0500000f 	streq	r0, [r0, #-15]
    1fc0:	0010980c 	andseq	r9, r0, ip, lsl #16
    1fc4:	a90c0600 	stmdbge	ip, {r9, sl}
    1fc8:	07000010 	smladeq	r0, r0, r0, r0
    1fcc:	13330a00 	teqne	r3, #0, 20
    1fd0:	04050000 	streq	r0, [r5], #-0
    1fd4:	00000038 	andeq	r0, r0, r8, lsr r0
    1fd8:	92108f02 	andsls	r8, r0, #2, 30
    1fdc:	0b000002 	bleq	1fec <CPSR_IRQ_INHIBIT+0x1f6c>
    1fe0:	00585541 	subseq	r5, r8, r1, asr #10
    1fe4:	12c00c1d 	sbcne	r0, r0, #7424	; 0x1d00
    1fe8:	0c2b0000 	stceq	0, cr0, [fp], #-0
    1fec:	0000139a 	muleq	r0, sl, r3
    1ff0:	13a00c2d 	movne	r0, #11520	; 0x2d00
    1ff4:	0b2e0000 	bleq	b81ffc <_bss_end+0xb77574>
    1ff8:	00494d53 	subeq	r4, r9, r3, asr sp
    1ffc:	133e0c30 	teqne	lr, #48, 24	; 0x3000
    2000:	0c310000 	ldceq	0, cr0, [r1], #-0
    2004:	00001345 	andeq	r1, r0, r5, asr #6
    2008:	134c0c32 	movtne	r0, #52274	; 0xcc32
    200c:	0c330000 	ldceq	0, cr0, [r3], #-0
    2010:	00001353 	andeq	r1, r0, r3, asr r3
    2014:	32490b34 	subcc	r0, r9, #52, 22	; 0xd000
    2018:	0b350043 	bleq	d4212c <_bss_end+0xd376a4>
    201c:	00495053 	subeq	r5, r9, r3, asr r0
    2020:	43500b36 	cmpmi	r0, #55296	; 0xd800
    2024:	0c37004d 	ldceq	0, cr0, [r7], #-308	; 0xfffffecc
    2028:	00000df3 	strdeq	r0, [r0], -r3
    202c:	1f080039 	svcne	0x00080039
    2030:	02000002 	andeq	r0, r0, #2
    2034:	02af1da6 	adceq	r1, pc, #10624	; 0x2980
    2038:	b4000000 	strlt	r0, [r0], #-0
    203c:	0d002000 	stceq	0, cr2, [r0, #-0]
    2040:	00000080 	andeq	r0, r0, r0, lsl #1
    2044:	f8070402 			; <UNDEFINED> instruction: 0xf8070402
    2048:	03000019 	movweq	r0, #25
    204c:	000002a8 	andeq	r0, r0, r8, lsr #5
    2050:	0000900d 	andeq	r9, r0, sp
    2054:	00a00d00 	adceq	r0, r0, r0, lsl #26
    2058:	b00d0000 	andlt	r0, sp, r0
    205c:	0d000000 	stceq	0, cr0, [r0, #-0]
    2060:	000000bd 	strheq	r0, [r0], -sp
    2064:	00018f0d 	andeq	r8, r1, sp, lsl #30
    2068:	02920d00 	addseq	r0, r2, #0, 26
    206c:	040e0000 	streq	r0, [lr], #-0
    2070:	00000063 	andeq	r0, r0, r3, rrx
    2074:	0002d203 	andeq	sp, r2, r3, lsl #4
    2078:	02010200 	andeq	r0, r1, #0, 4
    207c:	00000670 	andeq	r0, r0, r0, ror r6
    2080:	000dd00f 	andeq	sp, sp, pc
    2084:	06030400 	streq	r0, [r3], -r0, lsl #8
    2088:	0003a807 	andeq	sl, r3, r7, lsl #16
    208c:	02481000 	subeq	r1, r8, #0
    2090:	0a030000 	beq	c2098 <_bss_end+0xb7610>
    2094:	0002d819 	andeq	sp, r2, r9, lsl r8
    2098:	d0110000 	andsle	r0, r1, r0
    209c:	0300000d 	movweq	r0, #13
    20a0:	02c6050d 	sbceq	r0, r6, #54525952	; 0x3400000
    20a4:	03a80000 			; <UNDEFINED> instruction: 0x03a80000
    20a8:	17010000 	strne	r0, [r1, -r0]
    20ac:	22000003 	andcs	r0, r0, #3
    20b0:	12000003 	andne	r0, r0, #3
    20b4:	000003a8 	andeq	r0, r0, r8, lsr #7
    20b8:	00006313 	andeq	r6, r0, r3, lsl r3
    20bc:	f5140000 			; <UNDEFINED> instruction: 0xf5140000
    20c0:	03000012 	movweq	r0, #18
    20c4:	028e0a10 	addeq	r0, lr, #16, 20	; 0x10000
    20c8:	37010000 	strcc	r0, [r1, -r0]
    20cc:	42000003 	andmi	r0, r0, #3
    20d0:	12000003 	andne	r0, r0, #3
    20d4:	000003a8 	andeq	r0, r0, r8, lsr #7
    20d8:	00016a13 	andeq	r6, r1, r3, lsl sl
    20dc:	d5140000 	ldrle	r0, [r4, #-0]
    20e0:	03000011 	movweq	r0, #17
    20e4:	04c90a12 	strbeq	r0, [r9], #2578	; 0xa12
    20e8:	57010000 	strpl	r0, [r1, -r0]
    20ec:	62000003 	andvs	r0, r0, #3
    20f0:	12000003 	andne	r0, r0, #3
    20f4:	000003a8 	andeq	r0, r0, r8, lsr #7
    20f8:	00016a13 	andeq	r6, r1, r3, lsl sl
    20fc:	57140000 	ldrpl	r0, [r4, -r0]
    2100:	03000004 	movweq	r0, #4
    2104:	02d30a15 	sbcseq	r0, r3, #86016	; 0x15000
    2108:	77010000 	strvc	r0, [r1, -r0]
    210c:	87000003 	strhi	r0, [r0, -r3]
    2110:	12000003 	andne	r0, r0, #3
    2114:	000003a8 	andeq	r0, r0, r8, lsr #7
    2118:	0000cd13 	andeq	ip, r0, r3, lsl sp
    211c:	00521300 	subseq	r1, r2, r0, lsl #6
    2120:	15000000 	strne	r0, [r0, #-0]
    2124:	0000046b 	andeq	r0, r0, fp, ror #8
    2128:	510e1703 	tstpl	lr, r3, lsl #14
    212c:	52000002 	andpl	r0, r0, #2
    2130:	01000000 	mrseq	r0, (UNDEF: 0)
    2134:	0000039c 	muleq	r0, ip, r3
    2138:	0003a812 	andeq	sl, r3, r2, lsl r8
    213c:	00cd1300 	sbceq	r1, sp, r0, lsl #6
    2140:	00000000 	andeq	r0, r0, r0
    2144:	02e4040e 	rsceq	r0, r4, #234881024	; 0xe000000
    2148:	ca0a0000 	bgt	282150 <_bss_end+0x2776c8>
    214c:	0500000e 	streq	r0, [r0, #-14]
    2150:	00003804 	andeq	r3, r0, r4, lsl #16
    2154:	0c060400 	cfstrseq	mvf0, [r6], {-0}
    2158:	000003cd 	andeq	r0, r0, sp, asr #7
    215c:	000d920c 	andeq	r9, sp, ip, lsl #4
    2160:	a90c0000 	stmdbge	ip, {}	; <UNPREDICTABLE>
    2164:	0100000d 	tsteq	r0, sp
    2168:	0e640a00 	vmuleq.f32	s1, s8, s0
    216c:	04050000 	streq	r0, [r5], #-0
    2170:	00000038 	andeq	r0, r0, r8, lsr r0
    2174:	1a0c0c04 	bne	30518c <_bss_end+0x2fa704>
    2178:	16000004 	strne	r0, [r0], -r4
    217c:	00000e41 	andeq	r0, r0, r1, asr #28
    2180:	0f1604b0 	svceq	0x001604b0
    2184:	6000000d 	andvs	r0, r0, sp
    2188:	0d381609 	ldceq	6, cr1, [r8, #-36]!	; 0xffffffdc
    218c:	12c00000 	sbcne	r0, r0, #0
    2190:	000ef016 	andeq	pc, lr, r6, lsl r0	; <UNPREDICTABLE>
    2194:	16258000 	strtne	r8, [r5], -r0
    2198:	00000e0e 	andeq	r0, r0, lr, lsl #28
    219c:	17164b00 	ldrne	r4, [r6, -r0, lsl #22]
    21a0:	0000000e 	andeq	r0, r0, lr
    21a4:	0e201696 	mcreq	6, 1, r1, cr0, cr6, {4}
    21a8:	e1000000 	mrs	r0, (UNDEF: 0)
    21ac:	000e3717 	andeq	r3, lr, r7, lsl r7
    21b0:	01c20000 	biceq	r0, r2, r0
    21b4:	f20f0000 	vhadd.s8	d0, d15, d0
    21b8:	0400000d 	streq	r0, [r0], #-13
    21bc:	90071804 	andls	r1, r7, r4, lsl #16
    21c0:	10000005 	andne	r0, r0, r5
    21c4:	00000d33 	andeq	r0, r0, r3, lsr sp
    21c8:	900b1b04 	andls	r1, fp, r4, lsl #22
    21cc:	00000005 	andeq	r0, r0, r5
    21d0:	000df211 	andeq	pc, sp, r1, lsl r2	; <UNPREDICTABLE>
    21d4:	051e0400 	ldreq	r0, [lr, #-1024]	; 0xfffffc00
    21d8:	00000e86 	andeq	r0, r0, r6, lsl #29
    21dc:	00000596 	muleq	r0, r6, r5
    21e0:	00044d01 	andeq	r4, r4, r1, lsl #26
    21e4:	00045800 	andeq	r5, r4, r0, lsl #16
    21e8:	05961200 	ldreq	r1, [r6, #512]	; 0x200
    21ec:	90130000 	andsls	r0, r3, r0
    21f0:	00000005 	andeq	r0, r0, r5
    21f4:	000d9914 	andeq	r9, sp, r4, lsl r9
    21f8:	0a200400 	beq	803200 <_bss_end+0x7f8778>
    21fc:	00000ead 	andeq	r0, r0, sp, lsr #29
    2200:	00046d01 	andeq	r6, r4, r1, lsl #26
    2204:	00047800 	andeq	r7, r4, r0, lsl #16
    2208:	05961200 	ldreq	r1, [r6, #512]	; 0x200
    220c:	ae130000 	cdpge	0, 1, cr0, cr3, cr0, {0}
    2210:	00000003 	andeq	r0, r0, r3
    2214:	000e2914 	andeq	r2, lr, r4, lsl r9
    2218:	0a210400 	beq	843220 <_bss_end+0x838798>
    221c:	00000e49 	andeq	r0, r0, r9, asr #28
    2220:	00048d01 	andeq	r8, r4, r1, lsl #26
    2224:	00049800 	andeq	r9, r4, r0, lsl #16
    2228:	05961200 	ldreq	r1, [r6, #512]	; 0x200
    222c:	cd130000 	ldcgt	0, cr0, [r3, #-0]
    2230:	00000003 	andeq	r0, r0, r3
    2234:	000d1714 	andeq	r1, sp, r4, lsl r7
    2238:	0a250400 	beq	943240 <_bss_end+0x9387b8>
    223c:	00000e74 	andeq	r0, r0, r4, ror lr
    2240:	0004ad01 	andeq	sl, r4, r1, lsl #26
    2244:	0004b800 	andeq	fp, r4, r0, lsl #16
    2248:	05961200 	ldreq	r1, [r6, #512]	; 0x200
    224c:	25130000 	ldrcs	r0, [r3, #-0]
    2250:	00000000 	andeq	r0, r0, r0
    2254:	000d1714 	andeq	r1, sp, r4, lsl r7
    2258:	0a260400 	beq	983260 <_bss_end+0x9787d8>
    225c:	00000e99 	muleq	r0, r9, lr
    2260:	0004cd01 	andeq	ip, r4, r1, lsl #26
    2264:	0004d800 	andeq	sp, r4, r0, lsl #16
    2268:	05961200 	ldreq	r1, [r6, #512]	; 0x200
    226c:	9c130000 	ldcls	0, cr0, [r3], {-0}
    2270:	00000005 	andeq	r0, r0, r5
    2274:	000d1714 	andeq	r1, sp, r4, lsl r7
    2278:	0a270400 	beq	9c3280 <_bss_end+0x9b87f8>
    227c:	00000d6b 	andeq	r0, r0, fp, ror #26
    2280:	0004ed01 	andeq	lr, r4, r1, lsl #26
    2284:	0004fd00 	andeq	pc, r4, r0, lsl #26
    2288:	05961200 	ldreq	r1, [r6, #512]	; 0x200
    228c:	9c130000 	ldcls	0, cr0, [r3], {-0}
    2290:	13000005 	movwne	r0, #5
    2294:	00000063 	andeq	r0, r0, r3, rrx
    2298:	0d171400 	cfldrseq	mvf1, [r7, #-0]
    229c:	28040000 	stmdacs	r4, {}	; <UNPREDICTABLE>
    22a0:	000db00a 	andeq	fp, sp, sl
    22a4:	05120100 	ldreq	r0, [r2, #-256]	; 0xffffff00
    22a8:	051d0000 	ldreq	r0, [sp, #-0]
    22ac:	96120000 	ldrls	r0, [r2], -r0
    22b0:	13000005 	movwne	r0, #5
    22b4:	00000063 	andeq	r0, r0, r3, rrx
    22b8:	0dd51400 	cfldrdeq	mvd1, [r5]
    22bc:	29040000 	stmdbcs	r4, {}	; <UNPREDICTABLE>
    22c0:	000d1d0a 	andeq	r1, sp, sl, lsl #26
    22c4:	05320100 	ldreq	r0, [r2, #-256]!	; 0xffffff00
    22c8:	053d0000 	ldreq	r0, [sp, #-0]!
    22cc:	96120000 	ldrls	r0, [r2], -r0
    22d0:	13000005 	movwne	r0, #5
    22d4:	00000063 	andeq	r0, r0, r3, rrx
    22d8:	0d611400 	cfstrdeq	mvd1, [r1, #-0]
    22dc:	2a040000 	bcs	1022e4 <_bss_end+0xf785c>
    22e0:	000d800a 	andeq	r8, sp, sl
    22e4:	05520100 	ldrbeq	r0, [r2, #-256]	; 0xffffff00
    22e8:	055d0000 	ldrbeq	r0, [sp, #-0]
    22ec:	96120000 	ldrls	r0, [r2], -r0
    22f0:	13000005 	movwne	r0, #5
    22f4:	000005a2 	andeq	r0, r0, r2, lsr #11
    22f8:	0ddf1400 	cfldrdeq	mvd1, [pc]	; 2300 <CPSR_IRQ_INHIBIT+0x2280>
    22fc:	2c040000 	stccs	0, cr0, [r4], {-0}
    2300:	000cef0a 	andeq	lr, ip, sl, lsl #30
    2304:	05720100 	ldrbeq	r0, [r2, #-256]!	; 0xffffff00
    2308:	05780000 	ldrbeq	r0, [r8, #-0]!
    230c:	96120000 	ldrls	r0, [r2], -r0
    2310:	00000005 	andeq	r0, r0, r5
    2314:	000edc18 	andeq	sp, lr, r8, lsl ip
    2318:	0a2d0400 	beq	b43320 <_bss_end+0xb38898>
    231c:	00000d40 	andeq	r0, r0, r0, asr #26
    2320:	00058901 	andeq	r8, r5, r1, lsl #18
    2324:	05961200 	ldreq	r1, [r6, #512]	; 0x200
    2328:	00000000 	andeq	r0, r0, r0
    232c:	02e40419 	rsceq	r0, r4, #419430400	; 0x19000000
    2330:	040e0000 	streq	r0, [lr], #-0
    2334:	0000041a 	andeq	r0, r0, sl, lsl r4
    2338:	002c040e 	eoreq	r0, ip, lr, lsl #8
    233c:	040e0000 	streq	r0, [lr], #-0
    2340:	00000025 	andeq	r0, r0, r5, lsr #32
    2344:	000e071a 	andeq	r0, lr, sl, lsl r7
    2348:	0e300400 	cfabsseq	mvf0, mvf0
    234c:	0000041a 	andeq	r0, r0, sl, lsl r4
    2350:	0011b50f 	andseq	fp, r1, pc, lsl #10
    2354:	09050400 	stmdbeq	r5, {sl}
    2358:	00069307 	andeq	r9, r6, r7, lsl #6
    235c:	12431000 	subne	r1, r3, #0
    2360:	0d050000 	stceq	0, cr0, [r5, #-0]
    2364:	0006931c 	andeq	r9, r6, ip, lsl r3
    2368:	4e110000 	cdpmi	0, 1, cr0, cr1, cr0, {0}
    236c:	05000012 	streq	r0, [r0, #-18]	; 0xffffffee
    2370:	0f921c10 	svceq	0x00921c10
    2374:	06990000 	ldreq	r0, [r9], r0
    2378:	e7020000 	str	r0, [r2, -r0]
    237c:	f2000005 	vhadd.s8	d0, d0, d5
    2380:	12000005 	andne	r0, r0, #5
    2384:	0000069f 	muleq	r0, pc, r6	; <UNPREDICTABLE>
    2388:	00019f13 	andeq	r9, r1, r3, lsl pc
    238c:	b5110000 	ldrlt	r0, [r1, #-0]
    2390:	05000011 	streq	r0, [r0, #-17]	; 0xffffffef
    2394:	12990513 	addsne	r0, r9, #79691776	; 0x4c00000
    2398:	069f0000 	ldreq	r0, [pc], r0
    239c:	0b010000 	bleq	423a4 <_bss_end+0x3791c>
    23a0:	16000006 	strne	r0, [r0], -r6
    23a4:	12000006 	andne	r0, r0, #6
    23a8:	0000069f 	muleq	r0, pc, r6	; <UNPREDICTABLE>
    23ac:	0002a813 	andeq	sl, r2, r3, lsl r8
    23b0:	dd140000 	ldcle	0, cr0, [r4, #-0]
    23b4:	05000011 	streq	r0, [r0, #-17]	; 0xffffffef
    23b8:	12530a16 	subsne	r0, r3, #90112	; 0x16000
    23bc:	2b010000 	blcs	423c4 <_bss_end+0x3793c>
    23c0:	36000006 	strcc	r0, [r0], -r6
    23c4:	12000006 	andne	r0, r0, #6
    23c8:	0000069f 	muleq	r0, pc, r6	; <UNPREDICTABLE>
    23cc:	0001ee13 	andeq	lr, r1, r3, lsl lr
    23d0:	5a140000 	bpl	5023d8 <_bss_end+0x4f7950>
    23d4:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
    23d8:	102c0a18 	eorne	r0, ip, r8, lsl sl
    23dc:	4b010000 	blmi	423e4 <_bss_end+0x3795c>
    23e0:	56000006 	strpl	r0, [r0], -r6
    23e4:	12000006 	andne	r0, r0, #6
    23e8:	0000069f 	muleq	r0, pc, r6	; <UNPREDICTABLE>
    23ec:	0001ee13 	andeq	lr, r1, r3, lsl lr
    23f0:	e5140000 	ldr	r0, [r4, #-0]
    23f4:	0500000f 	streq	r0, [r0, #-15]
    23f8:	0f4f0a1b 	svceq	0x004f0a1b
    23fc:	6b010000 	blvs	42404 <_bss_end+0x3797c>
    2400:	76000006 	strvc	r0, [r0], -r6
    2404:	12000006 	andne	r0, r0, #6
    2408:	0000069f 	muleq	r0, pc, r6	; <UNPREDICTABLE>
    240c:	00023113 	andeq	r3, r2, r3, lsl r1
    2410:	8c180000 	ldchi	0, cr0, [r8], {-0}
    2414:	05000010 	streq	r0, [r0, #-16]
    2418:	10f20a1d 	rscsne	r0, r2, sp, lsl sl
    241c:	87010000 	strhi	r0, [r1, -r0]
    2420:	12000006 	andne	r0, r0, #6
    2424:	0000069f 	muleq	r0, pc, r6	; <UNPREDICTABLE>
    2428:	00023113 	andeq	r3, r2, r3, lsl r1
    242c:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    2430:	00006f04 	andeq	r6, r0, r4, lsl #30
    2434:	6f041900 	svcvs	0x00041900
    2438:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    243c:	0005b404 	andeq	fp, r5, r4, lsl #8
    2440:	069f0300 	ldreq	r0, [pc], r0, lsl #6
    2444:	161a0000 	ldrne	r0, [sl], -r0
    2448:	05000012 	streq	r0, [r0, #-18]	; 0xffffffee
    244c:	05b41e20 	ldreq	r1, [r4, #3616]!	; 0xe20
    2450:	ff1b0000 			; <UNDEFINED> instruction: 0xff1b0000
    2454:	0100000f 	tsteq	r0, pc
    2458:	003f0e07 	eorseq	r0, pc, r7, lsl #28
    245c:	03050000 	movweq	r0, #20480	; 0x5000
    2460:	0000aa6c 	andeq	sl, r0, ip, ror #20
    2464:	0011f81b 	andseq	pc, r1, fp, lsl r8	; <UNPREDICTABLE>
    2468:	17080100 	strne	r0, [r8, -r0, lsl #2]
    246c:	0000006f 	andeq	r0, r0, pc, rrx
    2470:	aa100305 	bge	40308c <_bss_end+0x3f8604>
    2474:	0a1b0000 	beq	6c247c <_bss_end+0x6b79f4>
    2478:	01000010 	tsteq	r0, r0, lsl r0
    247c:	006f1709 	rsbeq	r1, pc, r9, lsl #14
    2480:	03050000 	movweq	r0, #20480	; 0x5000
    2484:	0000aa14 	andeq	sl, r0, r4, lsl sl
    2488:	00136c1b 	andseq	r6, r3, fp, lsl ip
    248c:	170a0100 	strne	r0, [sl, -r0, lsl #2]
    2490:	0000006f 	andeq	r0, r0, pc, rrx
    2494:	aa700305 	bge	1c030b0 <_bss_end+0x1bf8628>
    2498:	aa1c0000 	bge	7024a0 <_bss_end+0x6f7a18>
    249c:	01000006 	tsteq	r0, r6
    24a0:	0305176c 	movweq	r1, #22380	; 0x576c
    24a4:	0000aa74 	andeq	sl, r0, r4, ror sl
    24a8:	000ff01d 	andeq	pc, pc, sp, lsl r0	; <UNPREDICTABLE>
    24ac:	009d3c00 	addseq	r3, sp, r0, lsl #24
    24b0:	00001c00 	andeq	r1, r0, r0, lsl #24
    24b4:	1e9c0100 	fmlnee	f0, f4, f0
    24b8:	00000403 	andeq	r0, r0, r3, lsl #8
    24bc:	00009ce8 	andeq	r9, r0, r8, ror #25
    24c0:	00000054 	andeq	r0, r0, r4, asr r0
    24c4:	074d9c01 	strbeq	r9, [sp, -r1, lsl #24]
    24c8:	3c1f0000 	ldccc	0, cr0, [pc], {-0}
    24cc:	01000003 	tsteq	r0, r3
    24d0:	00380190 	mlaseq	r8, r0, r1, r0
    24d4:	91020000 	mrsls	r0, (UNDEF: 2)
    24d8:	042d1f74 	strteq	r1, [sp], #-3956	; 0xfffff08c
    24dc:	90010000 	andls	r0, r1, r0
    24e0:	00003801 	andeq	r3, r0, r1, lsl #16
    24e4:	70910200 	addsvc	r0, r1, r0, lsl #4
    24e8:	06762000 	ldrbteq	r2, [r6], -r0
    24ec:	8a010000 	bhi	424f4 <_bss_end+0x37a6c>
    24f0:	00076706 	andeq	r6, r7, r6, lsl #14
    24f4:	009c8000 	addseq	r8, ip, r0
    24f8:	00006800 	andeq	r6, r0, r0, lsl #16
    24fc:	929c0100 	addsls	r0, ip, #0, 2
    2500:	21000007 	tstcs	r0, r7
    2504:	00000438 	andeq	r0, r0, r8, lsr r4
    2508:	000006a5 	andeq	r0, r0, r5, lsr #13
    250c:	1f649102 	svcne	0x00649102
    2510:	00001373 	andeq	r1, r0, r3, ror r3
    2514:	31398a01 	teqcc	r9, r1, lsl #20
    2518:	02000002 	andeq	r0, r0, #2
    251c:	89226091 	stmdbhi	r2!, {r0, r4, r7, sp, lr}
    2520:	0100000f 	tsteq	r0, pc
    2524:	006a188c 	rsbeq	r1, sl, ip, lsl #17
    2528:	91020000 	mrsls	r0, (UNDEF: 2)
    252c:	5620006c 	strtpl	r0, [r0], -ip, rrx
    2530:	01000006 	tsteq	r0, r6
    2534:	07ac0682 	streq	r0, [ip, r2, lsl #13]!
    2538:	9c180000 	ldcls	0, cr0, [r8], {-0}
    253c:	00680000 	rsbeq	r0, r8, r0
    2540:	9c010000 	stcls	0, cr0, [r1], {-0}
    2544:	000007d7 	ldrdeq	r0, [r0], -r7
    2548:	00043821 	andeq	r3, r4, r1, lsr #16
    254c:	0006a500 	andeq	sl, r6, r0, lsl #10
    2550:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    2554:	0013731f 	andseq	r7, r3, pc, lsl r3
    2558:	38820100 	stmcc	r2, {r8}
    255c:	00000231 	andeq	r0, r0, r1, lsr r2
    2560:	22609102 	rsbcs	r9, r0, #-2147483648	; 0x80000000
    2564:	00000f89 	andeq	r0, r0, r9, lsl #31
    2568:	6a188401 	bvs	623574 <_bss_end+0x618aec>
    256c:	02000000 	andeq	r0, r0, #0
    2570:	20006c91 	mulcs	r0, r1, ip
    2574:	00000636 	andeq	r0, r0, r6, lsr r6
    2578:	f1067d01 			; <UNDEFINED> instruction: 0xf1067d01
    257c:	d4000007 	strle	r0, [r0], #-7
    2580:	4400009b 	strmi	r0, [r0], #-155	; 0xffffff65
    2584:	01000000 	mrseq	r0, (UNDEF: 0)
    2588:	00080d9c 	muleq	r8, ip, sp
    258c:	04382100 	ldrteq	r2, [r8], #-256	; 0xffffff00
    2590:	06a50000 	strteq	r0, [r5], r0
    2594:	91020000 	mrsls	r0, (UNDEF: 2)
    2598:	13731f6c 	cmnne	r3, #108, 30	; 0x1b0
    259c:	7d010000 	stcvc	0, cr0, [r1, #-0]
    25a0:	0001ee45 	andeq	lr, r1, r5, asr #28
    25a4:	68910200 	ldmvs	r1, {r9}
    25a8:	06162000 	ldreq	r2, [r6], -r0
    25ac:	78010000 	stmdavc	r1, {}	; <UNPREDICTABLE>
    25b0:	00082706 	andeq	r2, r8, r6, lsl #14
    25b4:	009b9000 	addseq	r9, fp, r0
    25b8:	00004400 	andeq	r4, r0, r0, lsl #8
    25bc:	439c0100 	orrsmi	r0, ip, #0, 2
    25c0:	21000008 	tstcs	r0, r8
    25c4:	00000438 	andeq	r0, r0, r8, lsr r4
    25c8:	000006a5 	andeq	r0, r0, r5, lsr #13
    25cc:	1f6c9102 	svcne	0x006c9102
    25d0:	00001373 	andeq	r1, r0, r3, ror r3
    25d4:	ee447801 	cdp	8, 4, cr7, cr4, cr1, {0}
    25d8:	02000001 	andeq	r0, r0, #1
    25dc:	23006891 	movwcs	r6, #2193	; 0x891
    25e0:	000005ce 	andeq	r0, r0, lr, asr #11
    25e4:	5d187301 	ldcpl	3, cr7, [r8, #-4]
    25e8:	58000008 	stmdapl	r0, {r3}
    25ec:	3800009b 	stmdacc	r0, {r0, r1, r3, r4, r7}
    25f0:	01000000 	mrseq	r0, (UNDEF: 0)
    25f4:	0008799c 	muleq	r8, ip, r9
    25f8:	04382100 	ldrteq	r2, [r8], #-256	; 0xffffff00
    25fc:	06a50000 	strteq	r0, [r5], r0
    2600:	91020000 	mrsls	r0, (UNDEF: 2)
    2604:	65722474 	ldrbvs	r2, [r2, #-1140]!	; 0xfffffb8c
    2608:	73010067 	movwvc	r0, #4199	; 0x1067
    260c:	00019f52 	andeq	r9, r1, r2, asr pc
    2610:	70910200 	addsvc	r0, r1, r0, lsl #4
    2614:	05f22500 	ldrbeq	r2, [r2, #1280]!	; 0x500
    2618:	6e010000 	cdpvs	0, 0, cr0, cr1, cr0, {0}
    261c:	00088a01 	andeq	r8, r8, r1, lsl #20
    2620:	08a00000 	stmiaeq	r0!, {}	; <UNPREDICTABLE>
    2624:	38260000 	stmdacc	r6!, {}	; <UNPREDICTABLE>
    2628:	a5000004 	strge	r0, [r0, #-4]
    262c:	27000006 	strcs	r0, [r0, -r6]
    2630:	000016f7 	strdeq	r1, [r0], -r7
    2634:	a83c6e01 	ldmdage	ip!, {r0, r9, sl, fp, sp, lr}
    2638:	00000002 	andeq	r0, r0, r2
    263c:	00087928 	andeq	r7, r8, r8, lsr #18
    2640:	00122400 	andseq	r2, r2, r0, lsl #8
    2644:	0008bb00 	andeq	fp, r8, r0, lsl #22
    2648:	009b2400 	addseq	r2, fp, r0, lsl #8
    264c:	00003400 	andeq	r3, r0, r0, lsl #8
    2650:	cc9c0100 	ldfgts	f0, [ip], {0}
    2654:	29000008 	stmdbcs	r0, {r3}
    2658:	0000088a 	andeq	r0, r0, sl, lsl #17
    265c:	29749102 	ldmdbcs	r4!, {r1, r8, ip, pc}^
    2660:	00000893 	muleq	r0, r3, r8
    2664:	00709102 	rsbseq	r9, r0, r2, lsl #2
    2668:	00112d2a 	andseq	r2, r1, sl, lsr #26
    266c:	33680100 	cmncc	r8, #0, 2
    2670:	00009b14 	andeq	r9, r0, r4, lsl fp
    2674:	00000010 	andeq	r0, r0, r0, lsl r0
    2678:	df2b9c01 	svcle	0x002b9c01
    267c:	01000012 	tsteq	r0, r2, lsl r0
    2680:	9ad83360 	bls	ff60f408 <_bss_end+0xff604980>
    2684:	003c0000 	eorseq	r0, ip, r0
    2688:	9c010000 	stcls	0, cr0, [r1], {-0}
    268c:	00000902 	andeq	r0, r0, r2, lsl #18
    2690:	0100632c 	tsteq	r0, ip, lsr #6
    2694:	00250a62 	eoreq	r0, r5, r2, ror #20
    2698:	91020000 	mrsls	r0, (UNDEF: 2)
    269c:	fc2a005f 	stc2	0, cr0, [sl], #-380	; 0xfffffe84
    26a0:	01000012 	tsteq	r0, r2, lsl r0
    26a4:	9ac0335c 	bls	ff00f41c <_bss_end+0xff004994>
    26a8:	00180000 	andseq	r0, r8, r0
    26ac:	9c010000 	stcls	0, cr0, [r1], {-0}
    26b0:	0010cb2d 	andseq	ip, r0, sp, lsr #22
    26b4:	060c0100 	streq	r0, [ip], -r0, lsl #2
    26b8:	000010d9 	ldrdeq	r1, [r0], -r9
    26bc:	0000978c 	andeq	r9, r0, ip, lsl #15
    26c0:	00000334 	andeq	r0, r0, r4, lsr r3
    26c4:	63249c01 			; <UNDEFINED> instruction: 0x63249c01
    26c8:	190c0100 	stmdbne	ip, {r8}
    26cc:	00000025 	andeq	r0, r0, r5, lsr #32
    26d0:	226f9102 	rsbcs	r9, pc, #-2147483648	; 0x80000000
    26d4:	000012b8 			; <UNDEFINED> instruction: 0x000012b8
    26d8:	dd0a0e01 	stcle	14, cr0, [sl, #-4]
    26dc:	02000002 	andeq	r0, r0, #2
    26e0:	00007791 	muleq	r0, r1, r7
    26e4:	000006bf 			; <UNDEFINED> instruction: 0x000006bf
    26e8:	0d3b0004 	ldceq	0, cr0, [fp, #-16]!
    26ec:	01040000 	mrseq	r0, (UNDEF: 4)
    26f0:	000000b5 	strheq	r0, [r0], -r5
    26f4:	0013a604 	andseq	sl, r3, r4, lsl #12
    26f8:	00007400 	andeq	r7, r0, r0, lsl #8
    26fc:	009d5800 	addseq	r5, sp, r0, lsl #16
    2700:	00007800 	andeq	r7, r0, r0, lsl #16
    2704:	0010b400 	andseq	fp, r0, r0, lsl #8
    2708:	08010200 	stmdaeq	r1, {r9}
    270c:	0000036a 	andeq	r0, r0, sl, ror #6
    2710:	00002503 	andeq	r2, r0, r3, lsl #10
    2714:	05020200 	streq	r0, [r2, #-512]	; 0xfffffe00
    2718:	0000022a 	andeq	r0, r0, sl, lsr #4
    271c:	69050404 	stmdbvs	r5, {r2, sl}
    2720:	0200746e 	andeq	r7, r0, #1845493760	; 0x6e000000
    2724:	03610801 	cmneq	r1, #65536	; 0x10000
    2728:	02020000 	andeq	r0, r2, #0
    272c:	0003b607 	andeq	fp, r3, r7, lsl #12
    2730:	03940500 	orrseq	r0, r4, #0, 10
    2734:	0b060000 	bleq	18273c <_bss_end+0x177cb4>
    2738:	00005e07 	andeq	r5, r0, r7, lsl #28
    273c:	004d0300 	subeq	r0, sp, r0, lsl #6
    2740:	04020000 	streq	r0, [r2], #-0
    2744:	0019fd07 	andseq	pc, r9, r7, lsl #26
    2748:	005e0300 	subseq	r0, lr, r0, lsl #6
    274c:	5e060000 	cdppl	0, 0, cr0, cr6, cr0, {0}
    2750:	07000000 	streq	r0, [r0, -r0]
    2754:	00005e04 	andeq	r5, r0, r4, lsl #28
    2758:	006f0300 	rsbeq	r0, pc, r0, lsl #6
    275c:	01020000 	mrseq	r0, (UNDEF: 2)
    2760:	00067002 	andeq	r7, r6, r2
    2764:	61680800 	cmnvs	r8, r0, lsl #16
    2768:	0702006c 	streq	r0, [r2, -ip, rrx]
    276c:	0002b00b 	andeq	fp, r2, fp
    2770:	04b60900 	ldrteq	r0, [r6], #2304	; 0x900
    2774:	09020000 	stmdbeq	r2, {}	; <UNPREDICTABLE>
    2778:	0000651c 	andeq	r6, r0, ip, lsl r5
    277c:	e6b28000 	ldrt	r8, [r2], r0
    2780:	032c090e 			; <UNDEFINED> instruction: 0x032c090e
    2784:	0c020000 	stceq	0, cr0, [r2], {-0}
    2788:	0002bc1d 	andeq	fp, r2, sp, lsl ip
    278c:	00000000 	andeq	r0, r0, r0
    2790:	037d0920 	cmneq	sp, #32, 18	; 0x80000
    2794:	0f020000 	svceq	0x00020000
    2798:	0002bc1d 	andeq	fp, r2, sp, lsl ip
    279c:	20000000 	andcs	r0, r0, r0
    27a0:	03f40a20 	mvnseq	r0, #32, 20	; 0x20000
    27a4:	12020000 	andne	r0, r2, #0
    27a8:	00005918 	andeq	r5, r0, r8, lsl r9
    27ac:	78093600 	stmdavc	r9, {r9, sl, ip, sp}
    27b0:	02000004 	andeq	r0, r0, #4
    27b4:	02bc1d44 	adcseq	r1, ip, #68, 26	; 0x1100
    27b8:	50000000 	andpl	r0, r0, r0
    27bc:	490b2021 	stmdbmi	fp, {r0, r5, sp}
    27c0:	05000002 	streq	r0, [r0, #-2]
    27c4:	00003804 	andeq	r3, r0, r4, lsl #16
    27c8:	10460200 	subne	r0, r6, r0, lsl #4
    27cc:	00000177 	andeq	r0, r0, r7, ror r1
    27d0:	5152490c 	cmppl	r2, ip, lsl #18
    27d4:	860d0000 	strhi	r0, [sp], -r0
    27d8:	01000002 	tsteq	r0, r2
    27dc:	0004980d 	andeq	r9, r4, sp, lsl #16
    27e0:	6f0d1000 	svcvs	0x000d1000
    27e4:	11000003 	tstne	r0, r3
    27e8:	00039d0d 	andeq	r9, r3, sp, lsl #26
    27ec:	d10d1200 	mrsle	r1, SP_fiq
    27f0:	13000003 	movwne	r0, #3
    27f4:	0003760d 	andeq	r7, r3, sp, lsl #12
    27f8:	a70d1400 	strge	r1, [sp, -r0, lsl #8]
    27fc:	15000004 	strne	r0, [r0, #-4]
    2800:	0004640d 	andeq	r6, r4, sp, lsl #8
    2804:	f20d1600 	vmax.s8	d1, d13, d0
    2808:	17000004 	strne	r0, [r0, -r4]
    280c:	0003a40d 	andeq	sl, r3, sp, lsl #8
    2810:	810d1800 	tsthi	sp, r0, lsl #16
    2814:	19000004 	stmdbne	r0, {r2}
    2818:	0003e20d 	andeq	lr, r3, sp, lsl #4
    281c:	160d1a00 	strne	r1, [sp], -r0, lsl #20
    2820:	20000003 	andcs	r0, r0, r3
    2824:	0003210d 	andeq	r2, r3, sp, lsl #2
    2828:	ea0d2100 	b	34ac30 <_bss_end+0x3401a8>
    282c:	22000003 	andcs	r0, r0, #3
    2830:	0002fa0d 	andeq	pc, r2, sp, lsl #20
    2834:	d80d2400 	stmdale	sp, {sl, sp}
    2838:	25000003 	strcs	r0, [r0, #-3]
    283c:	00034b0d 	andeq	r4, r3, sp, lsl #22
    2840:	560d3000 	strpl	r3, [sp], -r0
    2844:	31000003 	tstcc	r0, r3
    2848:	00023e0d 	andeq	r3, r2, sp, lsl #28
    284c:	c90d3200 	stmdbgt	sp, {r9, ip, sp}
    2850:	34000003 	strcc	r0, [r0], #-3
    2854:	0002340d 	andeq	r3, r2, sp, lsl #8
    2858:	0b003500 	bleq	fc60 <_bss_end+0x51d8>
    285c:	000002b6 			; <UNDEFINED> instruction: 0x000002b6
    2860:	00380405 	eorseq	r0, r8, r5, lsl #8
    2864:	6c020000 	stcvs	0, cr0, [r2], {-0}
    2868:	00019c10 	andeq	r9, r1, r0, lsl ip
    286c:	049e0d00 	ldreq	r0, [lr], #3328	; 0xd00
    2870:	0d000000 	stceq	0, cr0, [r0, #-0]
    2874:	000003ac 	andeq	r0, r0, ip, lsr #7
    2878:	03b10d01 			; <UNDEFINED> instruction: 0x03b10d01
    287c:	00020000 	andeq	r0, r2, r0
    2880:	00043d09 	andeq	r3, r4, r9, lsl #26
    2884:	1d730200 	lfmne	f0, 2, [r3, #-0]
    2888:	000002bc 			; <UNDEFINED> instruction: 0x000002bc
    288c:	2000b200 	andcs	fp, r0, r0, lsl #4
    2890:	0010730b 	andseq	r7, r0, fp, lsl #6
    2894:	38040500 	stmdacc	r4, {r8, sl}
    2898:	02000000 	andeq	r0, r0, #0
    289c:	01fb1075 	mvnseq	r1, r5, ror r0
    28a0:	440d0000 	strmi	r0, [sp], #-0
    28a4:	00000011 	andeq	r0, r0, r1, lsl r0
    28a8:	0013170d 	andseq	r1, r3, sp, lsl #14
    28ac:	250d0100 	strcs	r0, [sp, #-256]	; 0xffffff00
    28b0:	02000013 	andeq	r0, r0, #19
    28b4:	0012d30d 	andseq	sp, r2, sp, lsl #6
    28b8:	120d0300 	andne	r0, sp, #0, 6
    28bc:	04000010 	streq	r0, [r0], #-16
    28c0:	00101f0d 	andseq	r1, r0, sp, lsl #30
    28c4:	eb0d0500 	bl	343ccc <_bss_end+0x339244>
    28c8:	06000012 			; <UNDEFINED> instruction: 0x06000012
    28cc:	00137e0d 	andseq	r7, r3, sp, lsl #28
    28d0:	8c0d0700 	stchi	7, cr0, [sp], {-0}
    28d4:	08000013 	stmdaeq	r0, {r0, r1, r4}
    28d8:	0011cb0d 	andseq	ip, r1, sp, lsl #22
    28dc:	0b000900 	bleq	4ce4 <CPSR_IRQ_INHIBIT+0x4c64>
    28e0:	000010ba 	strheq	r1, [r0], -sl
    28e4:	00380405 	eorseq	r0, r8, r5, lsl #8
    28e8:	83020000 	movwhi	r0, #8192	; 0x2000
    28ec:	00023e10 	andeq	r3, r2, r0, lsl lr
    28f0:	10ec0d00 	rscne	r0, ip, r0, lsl #26
    28f4:	0d000000 	stceq	0, cr0, [r0, #-0]
    28f8:	00000fdd 	ldrdeq	r0, [r0], -sp
    28fc:	12000d01 	andne	r0, r0, #1, 26	; 0x40
    2900:	0d020000 	stceq	0, cr0, [r2, #-0]
    2904:	0000120b 	andeq	r1, r0, fp, lsl #4
    2908:	11ee0d03 	mvnne	r0, r3, lsl #26
    290c:	0d040000 	stceq	0, cr0, [r4, #-0]
    2910:	00000fd3 	ldrdeq	r0, [r0], -r3
    2914:	10980d05 	addsne	r0, r8, r5, lsl #26
    2918:	0d060000 	stceq	0, cr0, [r6, #-0]
    291c:	000010a9 	andeq	r1, r0, r9, lsr #1
    2920:	330b0007 	movwcc	r0, #45063	; 0xb007
    2924:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
    2928:	00003804 	andeq	r3, r0, r4, lsl #16
    292c:	108f0200 	addne	r0, pc, r0, lsl #4
    2930:	0000029f 	muleq	r0, pc, r2	; <UNPREDICTABLE>
    2934:	5855410c 	ldmdapl	r5, {r2, r3, r8, lr}^
    2938:	c00d1d00 	andgt	r1, sp, r0, lsl #26
    293c:	2b000012 	blcs	298c <CPSR_IRQ_INHIBIT+0x290c>
    2940:	00139a0d 	andseq	r9, r3, sp, lsl #20
    2944:	a00d2d00 	andge	r2, sp, r0, lsl #26
    2948:	2e000013 	mcrcs	0, 0, r0, cr0, cr3, {0}
    294c:	494d530c 	stmdbmi	sp, {r2, r3, r8, r9, ip, lr}^
    2950:	3e0d3000 	cdpcc	0, 0, cr3, cr13, cr0, {0}
    2954:	31000013 	tstcc	r0, r3, lsl r0
    2958:	0013450d 	andseq	r4, r3, sp, lsl #10
    295c:	4c0d3200 	sfmmi	f3, 4, [sp], {-0}
    2960:	33000013 	movwcc	r0, #19
    2964:	0013530d 	andseq	r5, r3, sp, lsl #6
    2968:	490c3400 	stmdbmi	ip, {sl, ip, sp}
    296c:	35004332 	strcc	r4, [r0, #-818]	; 0xfffffcce
    2970:	4950530c 	ldmdbmi	r0, {r2, r3, r8, r9, ip, lr}^
    2974:	500c3600 	andpl	r3, ip, r0, lsl #12
    2978:	37004d43 	strcc	r4, [r0, -r3, asr #26]
    297c:	000df30d 	andeq	pc, sp, sp, lsl #6
    2980:	09003900 	stmdbeq	r0, {r8, fp, ip, sp}
    2984:	0000021f 	andeq	r0, r0, pc, lsl r2
    2988:	bc1da602 	ldclt	6, cr10, [sp], {2}
    298c:	00000002 	andeq	r0, r0, r2
    2990:	002000b4 	strhteq	r0, [r0], -r4
    2994:	00008d0e 	andeq	r8, r0, lr, lsl #26
    2998:	07040200 	streq	r0, [r4, -r0, lsl #4]
    299c:	000019f8 	strdeq	r1, [r0], -r8
    29a0:	0002b503 	andeq	fp, r2, r3, lsl #10
    29a4:	009d0e00 	addseq	r0, sp, r0, lsl #28
    29a8:	ad0e0000 	stcge	0, cr0, [lr, #-0]
    29ac:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    29b0:	000000bd 	strheq	r0, [r0], -sp
    29b4:	0000ca0e 	andeq	ip, r0, lr, lsl #20
    29b8:	019c0e00 	orrseq	r0, ip, r0, lsl #28
    29bc:	9f0e0000 	svcls	0x000e0000
    29c0:	0f000002 	svceq	0x00000002
    29c4:	00000dd0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    29c8:	07060304 	streq	r0, [r6, -r4, lsl #6]
    29cc:	000003a3 	andeq	r0, r0, r3, lsr #7
    29d0:	00024810 	andeq	r4, r2, r0, lsl r8
    29d4:	190a0300 	stmdbne	sl, {r8, r9}
    29d8:	00000075 	andeq	r0, r0, r5, ror r0
    29dc:	0dd01100 	ldfeqe	f1, [r0]
    29e0:	0d030000 	stceq	0, cr0, [r3, #-0]
    29e4:	0002c605 	andeq	ip, r2, r5, lsl #12
    29e8:	0003a300 	andeq	sl, r3, r0, lsl #6
    29ec:	03120100 	tsteq	r2, #0, 2
    29f0:	031d0000 	tsteq	sp, #0
    29f4:	a3120000 	tstge	r2, #0
    29f8:	13000003 	movwne	r0, #3
    29fc:	0000005e 	andeq	r0, r0, lr, asr r0
    2a00:	12f51400 	rscsne	r1, r5, #0, 8
    2a04:	10030000 	andne	r0, r3, r0
    2a08:	00028e0a 	andeq	r8, r2, sl, lsl #28
    2a0c:	03320100 	teqeq	r2, #0, 2
    2a10:	033d0000 	teqeq	sp, #0
    2a14:	a3120000 	tstge	r2, #0
    2a18:	13000003 	movwne	r0, #3
    2a1c:	00000177 	andeq	r0, r0, r7, ror r1
    2a20:	11d51400 	bicsne	r1, r5, r0, lsl #8
    2a24:	12030000 	andne	r0, r3, #0
    2a28:	0004c90a 	andeq	ip, r4, sl, lsl #18
    2a2c:	03520100 	cmpeq	r2, #0, 2
    2a30:	035d0000 	cmpeq	sp, #0
    2a34:	a3120000 	tstge	r2, #0
    2a38:	13000003 	movwne	r0, #3
    2a3c:	00000177 	andeq	r0, r0, r7, ror r1
    2a40:	04571400 	ldrbeq	r1, [r7], #-1024	; 0xfffffc00
    2a44:	15030000 	strne	r0, [r3, #-0]
    2a48:	0002d30a 	andeq	sp, r2, sl, lsl #6
    2a4c:	03720100 	cmneq	r2, #0, 2
    2a50:	03820000 	orreq	r0, r2, #0
    2a54:	a3120000 	tstge	r2, #0
    2a58:	13000003 	movwne	r0, #3
    2a5c:	000000da 	ldrdeq	r0, [r0], -sl
    2a60:	00004d13 	andeq	r4, r0, r3, lsl sp
    2a64:	6b150000 	blvs	542a6c <_bss_end+0x537fe4>
    2a68:	03000004 	movweq	r0, #4
    2a6c:	02510e17 	subseq	r0, r1, #368	; 0x170
    2a70:	004d0000 	subeq	r0, sp, r0
    2a74:	97010000 	strls	r0, [r1, -r0]
    2a78:	12000003 	andne	r0, r0, #3
    2a7c:	000003a3 	andeq	r0, r0, r3, lsr #7
    2a80:	0000da13 	andeq	sp, r0, r3, lsl sl
    2a84:	07000000 	streq	r0, [r0, -r0]
    2a88:	0002df04 	andeq	sp, r2, r4, lsl #30
    2a8c:	0eca0b00 	vdiveq.f64	d16, d10, d0
    2a90:	04050000 	streq	r0, [r5], #-0
    2a94:	00000038 	andeq	r0, r0, r8, lsr r0
    2a98:	c80c0604 	stmdagt	ip, {r2, r9, sl}
    2a9c:	0d000003 	stceq	0, cr0, [r0, #-12]
    2aa0:	00000d92 	muleq	r0, r2, sp
    2aa4:	0da90d00 	stceq	13, cr0, [r9]
    2aa8:	00010000 	andeq	r0, r1, r0
    2aac:	000e640b 	andeq	r6, lr, fp, lsl #8
    2ab0:	38040500 	stmdacc	r4, {r8, sl}
    2ab4:	04000000 	streq	r0, [r0], #-0
    2ab8:	04150c0c 	ldreq	r0, [r5], #-3084	; 0xfffff3f4
    2abc:	41160000 	tstmi	r6, r0
    2ac0:	b000000e 	andlt	r0, r0, lr
    2ac4:	0d0f1604 	stceq	6, cr1, [pc, #-16]	; 2abc <CPSR_IRQ_INHIBIT+0x2a3c>
    2ac8:	09600000 	stmdbeq	r0!, {}^	; <UNPREDICTABLE>
    2acc:	000d3816 	andeq	r3, sp, r6, lsl r8
    2ad0:	1612c000 	ldrne	ip, [r2], -r0
    2ad4:	00000ef0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    2ad8:	0e162580 	cfcvts32eq	mvfx2, mvf6
    2adc:	0000000e 	andeq	r0, r0, lr
    2ae0:	0e17164b 	cfmsub32eq	mvax2, mvfx1, mvfx7, mvfx11
    2ae4:	96000000 	strls	r0, [r0], -r0
    2ae8:	000e2016 	andeq	r2, lr, r6, lsl r0
    2aec:	17e10000 	strbne	r0, [r1, r0]!
    2af0:	00000e37 	andeq	r0, r0, r7, lsr lr
    2af4:	0001c200 	andeq	ip, r1, r0, lsl #4
    2af8:	0df20f00 	ldcleq	15, cr0, [r2]
    2afc:	04040000 	streq	r0, [r4], #-0
    2b00:	058b0718 	streq	r0, [fp, #1816]	; 0x718
    2b04:	33100000 	tstcc	r0, #0
    2b08:	0400000d 	streq	r0, [r0], #-13
    2b0c:	058b0b1b 	streq	r0, [fp, #2843]	; 0xb1b
    2b10:	11000000 	mrsne	r0, (UNDEF: 0)
    2b14:	00000df2 	strdeq	r0, [r0], -r2
    2b18:	86051e04 	strhi	r1, [r5], -r4, lsl #28
    2b1c:	9100000e 	tstls	r0, lr
    2b20:	01000005 	tsteq	r0, r5
    2b24:	00000448 	andeq	r0, r0, r8, asr #8
    2b28:	00000453 	andeq	r0, r0, r3, asr r4
    2b2c:	00059112 	andeq	r9, r5, r2, lsl r1
    2b30:	058b1300 	streq	r1, [fp, #768]	; 0x300
    2b34:	14000000 	strne	r0, [r0], #-0
    2b38:	00000d99 	muleq	r0, r9, sp
    2b3c:	ad0a2004 	stcge	0, cr2, [sl, #-16]
    2b40:	0100000e 	tsteq	r0, lr
    2b44:	00000468 	andeq	r0, r0, r8, ror #8
    2b48:	00000473 	andeq	r0, r0, r3, ror r4
    2b4c:	00059112 	andeq	r9, r5, r2, lsl r1
    2b50:	03a91300 			; <UNDEFINED> instruction: 0x03a91300
    2b54:	14000000 	strne	r0, [r0], #-0
    2b58:	00000e29 	andeq	r0, r0, r9, lsr #28
    2b5c:	490a2104 	stmdbmi	sl, {r2, r8, sp}
    2b60:	0100000e 	tsteq	r0, lr
    2b64:	00000488 	andeq	r0, r0, r8, lsl #9
    2b68:	00000493 	muleq	r0, r3, r4
    2b6c:	00059112 	andeq	r9, r5, r2, lsl r1
    2b70:	03c81300 	biceq	r1, r8, #0, 6
    2b74:	14000000 	strne	r0, [r0], #-0
    2b78:	00000d17 	andeq	r0, r0, r7, lsl sp
    2b7c:	740a2504 	strvc	r2, [sl], #-1284	; 0xfffffafc
    2b80:	0100000e 	tsteq	r0, lr
    2b84:	000004a8 	andeq	r0, r0, r8, lsr #9
    2b88:	000004b3 			; <UNDEFINED> instruction: 0x000004b3
    2b8c:	00059112 	andeq	r9, r5, r2, lsl r1
    2b90:	00251300 	eoreq	r1, r5, r0, lsl #6
    2b94:	14000000 	strne	r0, [r0], #-0
    2b98:	00000d17 	andeq	r0, r0, r7, lsl sp
    2b9c:	990a2604 	stmdbls	sl, {r2, r9, sl, sp}
    2ba0:	0100000e 	tsteq	r0, lr
    2ba4:	000004c8 	andeq	r0, r0, r8, asr #9
    2ba8:	000004d3 	ldrdeq	r0, [r0], -r3
    2bac:	00059112 	andeq	r9, r5, r2, lsl r1
    2bb0:	05971300 	ldreq	r1, [r7, #768]	; 0x300
    2bb4:	14000000 	strne	r0, [r0], #-0
    2bb8:	00000d17 	andeq	r0, r0, r7, lsl sp
    2bbc:	6b0a2704 	blvs	28c7d4 <_bss_end+0x281d4c>
    2bc0:	0100000d 	tsteq	r0, sp
    2bc4:	000004e8 	andeq	r0, r0, r8, ror #9
    2bc8:	000004f8 	strdeq	r0, [r0], -r8
    2bcc:	00059112 	andeq	r9, r5, r2, lsl r1
    2bd0:	05971300 	ldreq	r1, [r7, #768]	; 0x300
    2bd4:	5e130000 	cdppl	0, 1, cr0, cr3, cr0, {0}
    2bd8:	00000000 	andeq	r0, r0, r0
    2bdc:	000d1714 	andeq	r1, sp, r4, lsl r7
    2be0:	0a280400 	beq	a03be8 <_bss_end+0x9f9160>
    2be4:	00000db0 			; <UNDEFINED> instruction: 0x00000db0
    2be8:	00050d01 	andeq	r0, r5, r1, lsl #26
    2bec:	00051800 	andeq	r1, r5, r0, lsl #16
    2bf0:	05911200 	ldreq	r1, [r1, #512]	; 0x200
    2bf4:	5e130000 	cdppl	0, 1, cr0, cr3, cr0, {0}
    2bf8:	00000000 	andeq	r0, r0, r0
    2bfc:	000dd514 	andeq	sp, sp, r4, lsl r5
    2c00:	0a290400 	beq	a43c08 <_bss_end+0xa39180>
    2c04:	00000d1d 	andeq	r0, r0, sp, lsl sp
    2c08:	00052d01 	andeq	r2, r5, r1, lsl #26
    2c0c:	00053800 	andeq	r3, r5, r0, lsl #16
    2c10:	05911200 	ldreq	r1, [r1, #512]	; 0x200
    2c14:	5e130000 	cdppl	0, 1, cr0, cr3, cr0, {0}
    2c18:	00000000 	andeq	r0, r0, r0
    2c1c:	000d6114 	andeq	r6, sp, r4, lsl r1
    2c20:	0a2a0400 	beq	a83c28 <_bss_end+0xa791a0>
    2c24:	00000d80 	andeq	r0, r0, r0, lsl #27
    2c28:	00054d01 	andeq	r4, r5, r1, lsl #26
    2c2c:	00055800 	andeq	r5, r5, r0, lsl #16
    2c30:	05911200 	ldreq	r1, [r1, #512]	; 0x200
    2c34:	9d130000 	ldcls	0, cr0, [r3, #-0]
    2c38:	00000005 	andeq	r0, r0, r5
    2c3c:	000ddf14 	andeq	sp, sp, r4, lsl pc
    2c40:	0a2c0400 	beq	b03c48 <_bss_end+0xaf91c0>
    2c44:	00000cef 	andeq	r0, r0, pc, ror #25
    2c48:	00056d01 	andeq	r6, r5, r1, lsl #26
    2c4c:	00057300 	andeq	r7, r5, r0, lsl #6
    2c50:	05911200 	ldreq	r1, [r1, #512]	; 0x200
    2c54:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
    2c58:	00000edc 	ldrdeq	r0, [r0], -ip
    2c5c:	400a2d04 	andmi	r2, sl, r4, lsl #26
    2c60:	0100000d 	tsteq	r0, sp
    2c64:	00000584 	andeq	r0, r0, r4, lsl #11
    2c68:	00059112 	andeq	r9, r5, r2, lsl r1
    2c6c:	19000000 	stmdbne	r0, {}	; <UNPREDICTABLE>
    2c70:	0002df04 	andeq	sp, r2, r4, lsl #30
    2c74:	15040700 	strne	r0, [r4, #-1792]	; 0xfffff900
    2c78:	07000004 	streq	r0, [r0, -r4]
    2c7c:	00002c04 	andeq	r2, r0, r4, lsl #24
    2c80:	25040700 	strcs	r0, [r4, #-1792]	; 0xfffff900
    2c84:	1a000000 	bne	2c8c <CPSR_IRQ_INHIBIT+0x2c0c>
    2c88:	00000e07 	andeq	r0, r0, r7, lsl #28
    2c8c:	150e3004 	strne	r3, [lr, #-4]
    2c90:	0f000004 	svceq	0x00000004
    2c94:	000011b5 			; <UNDEFINED> instruction: 0x000011b5
    2c98:	07090504 	streq	r0, [r9, -r4, lsl #10]
    2c9c:	0000068e 	andeq	r0, r0, lr, lsl #13
    2ca0:	00124310 	andseq	r4, r2, r0, lsl r3
    2ca4:	1c0d0500 	cfstr32ne	mvfx0, [sp], {-0}
    2ca8:	0000068e 	andeq	r0, r0, lr, lsl #13
    2cac:	124e1100 	subne	r1, lr, #0, 2
    2cb0:	10050000 	andne	r0, r5, r0
    2cb4:	000f921c 	andeq	r9, pc, ip, lsl r2	; <UNPREDICTABLE>
    2cb8:	00069400 	andeq	r9, r6, r0, lsl #8
    2cbc:	05e20200 	strbeq	r0, [r2, #512]!	; 0x200
    2cc0:	05ed0000 	strbeq	r0, [sp, #0]!
    2cc4:	9a120000 	bls	482ccc <_bss_end+0x478244>
    2cc8:	13000006 	movwne	r0, #6
    2ccc:	000001ac 	andeq	r0, r0, ip, lsr #3
    2cd0:	11b51100 			; <UNDEFINED> instruction: 0x11b51100
    2cd4:	13050000 	movwne	r0, #20480	; 0x5000
    2cd8:	00129905 	andseq	r9, r2, r5, lsl #18
    2cdc:	00069a00 	andeq	r9, r6, r0, lsl #20
    2ce0:	06060100 	streq	r0, [r6], -r0, lsl #2
    2ce4:	06110000 	ldreq	r0, [r1], -r0
    2ce8:	9a120000 	bls	482cf0 <_bss_end+0x478268>
    2cec:	13000006 	movwne	r0, #6
    2cf0:	000002b5 			; <UNDEFINED> instruction: 0x000002b5
    2cf4:	11dd1400 	bicsne	r1, sp, r0, lsl #8
    2cf8:	16050000 	strne	r0, [r5], -r0
    2cfc:	0012530a 	andseq	r5, r2, sl, lsl #6
    2d00:	06260100 	strteq	r0, [r6], -r0, lsl #2
    2d04:	06310000 	ldrteq	r0, [r1], -r0
    2d08:	9a120000 	bls	482d10 <_bss_end+0x478288>
    2d0c:	13000006 	movwne	r0, #6
    2d10:	000001fb 	strdeq	r0, [r0], -fp
    2d14:	135a1400 	cmpne	sl, #0, 8
    2d18:	18050000 	stmdane	r5, {}	; <UNPREDICTABLE>
    2d1c:	00102c0a 	andseq	r2, r0, sl, lsl #24
    2d20:	06460100 	strbeq	r0, [r6], -r0, lsl #2
    2d24:	06510000 	ldrbeq	r0, [r1], -r0
    2d28:	9a120000 	bls	482d30 <_bss_end+0x4782a8>
    2d2c:	13000006 	movwne	r0, #6
    2d30:	000001fb 	strdeq	r0, [r0], -fp
    2d34:	0fe51400 	svceq	0x00e51400
    2d38:	1b050000 	blne	142d40 <_bss_end+0x1382b8>
    2d3c:	000f4f0a 	andeq	r4, pc, sl, lsl #30
    2d40:	06660100 	strbteq	r0, [r6], -r0, lsl #2
    2d44:	06710000 	ldrbteq	r0, [r1], -r0
    2d48:	9a120000 	bls	482d50 <_bss_end+0x4782c8>
    2d4c:	13000006 	movwne	r0, #6
    2d50:	0000023e 	andeq	r0, r0, lr, lsr r2
    2d54:	108c1800 	addne	r1, ip, r0, lsl #16
    2d58:	1d050000 	stcne	0, cr0, [r5, #-0]
    2d5c:	0010f20a 	andseq	pc, r0, sl, lsl #4
    2d60:	06820100 	streq	r0, [r2], r0, lsl #2
    2d64:	9a120000 	bls	482d6c <_bss_end+0x4782e4>
    2d68:	13000006 	movwne	r0, #6
    2d6c:	0000023e 	andeq	r0, r0, lr, lsr r2
    2d70:	04070000 	streq	r0, [r7], #-0
    2d74:	0000006a 	andeq	r0, r0, sl, rrx
    2d78:	006a0419 	rsbeq	r0, sl, r9, lsl r4
    2d7c:	04070000 	streq	r0, [r7], #-0
    2d80:	000005af 	andeq	r0, r0, pc, lsr #11
    2d84:	0012161a 	andseq	r1, r2, sl, lsl r6
    2d88:	1e200500 	cfsh64ne	mvdx0, mvdx0, #0
    2d8c:	000005af 	andeq	r0, r0, pc, lsr #11
    2d90:	0013f51b 	andseq	pc, r3, fp, lsl r5	; <UNPREDICTABLE>
    2d94:	10050100 	andne	r0, r5, r0, lsl #2
    2d98:	00000038 	andeq	r0, r0, r8, lsr r0
    2d9c:	00009d58 	andeq	r9, r0, r8, asr sp
    2da0:	00000078 	andeq	r0, r0, r8, ror r0
    2da4:	1e009c01 	cdpne	12, 0, cr9, cr0, cr1, {0}
    2da8:	02000000 	andeq	r0, r0, #0
    2dac:	000ed200 	andeq	sp, lr, r0, lsl #4
    2db0:	90010400 	andls	r0, r1, r0, lsl #8
    2db4:	28000012 	stmdacs	r0, {r1, r4}
    2db8:	02000000 	andeq	r0, r0, #0
    2dbc:	74000014 	strvc	r0, [r0], #-20	; 0xffffffec
    2dc0:	50000000 	andpl	r0, r0, r0
    2dc4:	01000014 	tsteq	r0, r4, lsl r0
    2dc8:	00014b80 	andeq	r4, r1, r0, lsl #23
    2dcc:	e4000400 	str	r0, [r0], #-1024	; 0xfffffc00
    2dd0:	0400000e 	streq	r0, [r0], #-14
    2dd4:	0000b501 	andeq	fp, r0, r1, lsl #10
    2dd8:	145c0400 	ldrbne	r0, [ip], #-1024	; 0xfffffc00
    2ddc:	00740000 	rsbseq	r0, r4, r0
    2de0:	9df00000 	ldclls	0, cr0, [r0]
    2de4:	01180000 	tsteq	r8, r0
    2de8:	13430000 	movtne	r0, #12288	; 0x3000
    2dec:	01020000 	mrseq	r0, (UNDEF: 2)
    2df0:	01000015 	tsteq	r0, r5, lsl r0
    2df4:	00310702 	eorseq	r0, r1, r2, lsl #14
    2df8:	04030000 	streq	r0, [r3], #-0
    2dfc:	00000037 	andeq	r0, r0, r7, lsr r0
    2e00:	14f80204 	ldrbtne	r0, [r8], #516	; 0x204
    2e04:	03010000 	movweq	r0, #4096	; 0x1000
    2e08:	00003107 	andeq	r3, r0, r7, lsl #2
    2e0c:	14ae0500 	strtne	r0, [lr], #1280	; 0x500
    2e10:	06010000 	streq	r0, [r1], -r0
    2e14:	00005010 	andeq	r5, r0, r0, lsl r0
    2e18:	05040600 	streq	r0, [r4, #-1536]	; 0xfffffa00
    2e1c:	00746e69 	rsbseq	r6, r4, r9, ror #28
    2e20:	0014e105 	andseq	lr, r4, r5, lsl #2
    2e24:	10080100 	andne	r0, r8, r0, lsl #2
    2e28:	00000050 	andeq	r0, r0, r0, asr r0
    2e2c:	00002507 	andeq	r2, r0, r7, lsl #10
    2e30:	00007600 	andeq	r7, r0, r0, lsl #12
    2e34:	00760800 	rsbseq	r0, r6, r0, lsl #16
    2e38:	ffff0000 			; <UNDEFINED> instruction: 0xffff0000
    2e3c:	0900ffff 	stmdbeq	r0, {r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, fp, ip, sp, lr, pc}
    2e40:	19fd0704 	ldmibne	sp!, {r2, r8, r9, sl}^
    2e44:	0a050000 	beq	142e4c <_bss_end+0x1383c4>
    2e48:	01000015 	tsteq	r0, r5, lsl r0
    2e4c:	0063150b 	rsbeq	r1, r3, fp, lsl #10
    2e50:	b9050000 	stmdblt	r5, {}	; <UNPREDICTABLE>
    2e54:	01000014 	tsteq	r0, r4, lsl r0
    2e58:	0063150d 	rsbeq	r1, r3, sp, lsl #10
    2e5c:	38070000 	stmdacc	r7, {}	; <UNPREDICTABLE>
    2e60:	a8000000 	stmdage	r0, {}	; <UNPREDICTABLE>
    2e64:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    2e68:	00000076 	andeq	r0, r0, r6, ror r0
    2e6c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
    2e70:	14ea0500 	strbtne	r0, [sl], #1280	; 0x500
    2e74:	10010000 	andne	r0, r1, r0
    2e78:	00009515 	andeq	r9, r0, r5, lsl r5
    2e7c:	14c60500 	strbne	r0, [r6], #1280	; 0x500
    2e80:	12010000 	andne	r0, r1, #0
    2e84:	00009515 	andeq	r9, r0, r5, lsl r5
    2e88:	14d30a00 	ldrbne	r0, [r3], #2560	; 0xa00
    2e8c:	2b010000 	blcs	42e94 <_bss_end+0x3840c>
    2e90:	00005010 	andeq	r5, r0, r0, lsl r0
    2e94:	009eb000 	addseq	fp, lr, r0
    2e98:	00005800 	andeq	r5, r0, r0, lsl #16
    2e9c:	ea9c0100 	b	fe7032a4 <_bss_end+0xfe6f881c>
    2ea0:	0b000000 	bleq	2ea8 <CPSR_IRQ_INHIBIT+0x2e28>
    2ea4:	00001530 	andeq	r1, r0, r0, lsr r5
    2ea8:	ea0f2d01 	b	3ce2b4 <_bss_end+0x3c382c>
    2eac:	02000000 	andeq	r0, r0, #0
    2eb0:	03007491 	movweq	r7, #1169	; 0x491
    2eb4:	00003804 	andeq	r3, r0, r4, lsl #16
    2eb8:	15230a00 	strne	r0, [r3, #-2560]!	; 0xfffff600
    2ebc:	1f010000 	svcne	0x00010000
    2ec0:	00005010 	andeq	r5, r0, r0, lsl r0
    2ec4:	009e5800 	addseq	r5, lr, r0, lsl #16
    2ec8:	00005800 	andeq	r5, r0, r0, lsl #16
    2ecc:	1a9c0100 	bne	fe7032d4 <_bss_end+0xfe6f884c>
    2ed0:	0b000001 	bleq	2edc <CPSR_IRQ_INHIBIT+0x2e5c>
    2ed4:	00001530 	andeq	r1, r0, r0, lsr r5
    2ed8:	1a0f2101 	bne	3cb2e4 <_bss_end+0x3c085c>
    2edc:	02000001 	andeq	r0, r0, #1
    2ee0:	03007491 	movweq	r7, #1169	; 0x491
    2ee4:	00002504 	andeq	r2, r0, r4, lsl #10
    2ee8:	15180c00 	ldrne	r0, [r8, #-3072]	; 0xfffff400
    2eec:	14010000 	strne	r0, [r1], #-0
    2ef0:	00005010 	andeq	r5, r0, r0, lsl r0
    2ef4:	009df000 	addseq	pc, sp, r0
    2ef8:	00006800 	andeq	r6, r0, r0, lsl #16
    2efc:	489c0100 	ldmmi	ip, {r8}
    2f00:	0d000001 	stceq	0, cr0, [r0, #-4]
    2f04:	16010069 	strne	r0, [r1], -r9, rrx
    2f08:	0001480a 	andeq	r4, r1, sl, lsl #16
    2f0c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    2f10:	50040300 	andpl	r0, r4, r0, lsl #6
    2f14:	00000000 	andeq	r0, r0, r0
    2f18:	0000032e 	andeq	r0, r0, lr, lsr #6
    2f1c:	0faa0004 	svceq	0x00aa0004
    2f20:	01040000 	mrseq	r0, (UNDEF: 4)
    2f24:	000000b5 	strheq	r0, [r0], -r5
    2f28:	00157d04 	andseq	r7, r5, r4, lsl #26
    2f2c:	00007400 	andeq	r7, r0, r0, lsl #8
    2f30:	009f0800 	addseq	r0, pc, r0, lsl #16
    2f34:	0004b800 	andeq	fp, r4, r0, lsl #16
    2f38:	00143000 	andseq	r3, r4, r0
    2f3c:	00490200 	subeq	r0, r9, r0, lsl #4
    2f40:	b0030000 	andlt	r0, r3, r0
    2f44:	0100000b 	tsteq	r0, fp
    2f48:	00611005 	rsbeq	r1, r1, r5
    2f4c:	30110000 	andscc	r0, r1, r0
    2f50:	34333231 	ldrtcc	r3, [r3], #-561	; 0xfffffdcf
    2f54:	38373635 	ldmdacc	r7!, {r0, r2, r4, r5, r9, sl, ip, sp}
    2f58:	43424139 	movtmi	r4, #8505	; 0x2139
    2f5c:	00464544 	subeq	r4, r6, r4, asr #10
    2f60:	03010400 	movweq	r0, #5120	; 0x1400
    2f64:	00002501 	andeq	r2, r0, r1, lsl #10
    2f68:	00740500 	rsbseq	r0, r4, r0, lsl #10
    2f6c:	00610000 	rsbeq	r0, r1, r0
    2f70:	66060000 	strvs	r0, [r6], -r0
    2f74:	10000000 	andne	r0, r0, r0
    2f78:	00510700 	subseq	r0, r1, r0, lsl #14
    2f7c:	04080000 	streq	r0, [r8], #-0
    2f80:	0019fd07 	andseq	pc, r9, r7, lsl #26
    2f84:	08010800 	stmdaeq	r1, {fp}
    2f88:	0000036a 	andeq	r0, r0, sl, ror #6
    2f8c:	00006d07 	andeq	r6, r0, r7, lsl #26
    2f90:	002a0900 	eoreq	r0, sl, r0, lsl #18
    2f94:	760a0000 	strvc	r0, [sl], -r0
    2f98:	01000015 	tsteq	r0, r5, lsl r0
    2f9c:	15660664 	strbne	r0, [r6, #-1636]!	; 0xfffff99c
    2fa0:	a3400000 	movtge	r0, #0
    2fa4:	00800000 	addeq	r0, r0, r0
    2fa8:	9c010000 	stcls	0, cr0, [r1], {-0}
    2fac:	000000fb 	strdeq	r0, [r0], -fp
    2fb0:	6372730b 	cmnvs	r2, #738197504	; 0x2c000000
    2fb4:	19640100 	stmdbne	r4!, {r8}^
    2fb8:	000000fb 	strdeq	r0, [r0], -fp
    2fbc:	0b649102 	bleq	19273cc <_bss_end+0x191c944>
    2fc0:	00747364 	rsbseq	r7, r4, r4, ror #6
    2fc4:	02246401 	eoreq	r6, r4, #16777216	; 0x1000000
    2fc8:	02000001 	andeq	r0, r0, #1
    2fcc:	6e0b6091 	mcrvs	0, 0, r6, cr11, cr1, {4}
    2fd0:	01006d75 	tsteq	r0, r5, ror sp
    2fd4:	01042d64 	tsteq	r4, r4, ror #26
    2fd8:	91020000 	mrsls	r0, (UNDEF: 2)
    2fdc:	16240c5c 			; <UNDEFINED> instruction: 0x16240c5c
    2fe0:	66010000 	strvs	r0, [r1], -r0
    2fe4:	00010b11 	andeq	r0, r1, r1, lsl fp
    2fe8:	70910200 	addsvc	r0, r1, r0, lsl #4
    2fec:	0015360c 	andseq	r3, r5, ip, lsl #12
    2ff0:	0b670100 	bleq	19c33f8 <_bss_end+0x19b8970>
    2ff4:	00000111 	andeq	r0, r0, r1, lsl r1
    2ff8:	0d6c9102 	stfeqp	f1, [ip, #-8]!
    2ffc:	0000a368 	andeq	sl, r0, r8, ror #6
    3000:	00000048 	andeq	r0, r0, r8, asr #32
    3004:	0100690e 	tsteq	r0, lr, lsl #18
    3008:	01040e69 	tsteq	r4, r9, ror #28
    300c:	91020000 	mrsls	r0, (UNDEF: 2)
    3010:	0f000074 	svceq	0x00000074
    3014:	00010104 	andeq	r0, r1, r4, lsl #2
    3018:	04111000 	ldreq	r1, [r1], #-0
    301c:	69050412 	stmdbvs	r5, {r1, r4, sl}
    3020:	0f00746e 	svceq	0x0000746e
    3024:	00007404 	andeq	r7, r0, r4, lsl #8
    3028:	6d040f00 	stcvs	15, cr0, [r4, #-0]
    302c:	0a000000 	beq	3034 <CPSR_IRQ_INHIBIT+0x2fb4>
    3030:	00001542 	andeq	r1, r0, r2, asr #10
    3034:	4f065c01 	svcmi	0x00065c01
    3038:	d8000015 	stmdale	r0, {r0, r2, r4}
    303c:	680000a2 	stmdavs	r0, {r1, r5, r7}
    3040:	01000000 	mrseq	r0, (UNDEF: 0)
    3044:	0001769c 	muleq	r1, ip, r6
    3048:	161d1300 	ldrne	r1, [sp], -r0, lsl #6
    304c:	5c010000 	stcpl	0, cr0, [r1], {-0}
    3050:	00010212 	andeq	r0, r1, r2, lsl r2
    3054:	6c910200 	lfmvs	f0, 4, [r1], {0}
    3058:	00154813 	andseq	r4, r5, r3, lsl r8
    305c:	1e5c0100 	rdfnee	f0, f4, f0
    3060:	00000104 	andeq	r0, r0, r4, lsl #2
    3064:	0e689102 	lgneqe	f1, f2
    3068:	006d656d 	rsbeq	r6, sp, sp, ror #10
    306c:	110b5e01 	tstne	fp, r1, lsl #28
    3070:	02000001 	andeq	r0, r0, #1
    3074:	f40d7091 	vst4.32	{d7-d10}, [sp :64], r1
    3078:	3c0000a2 	stccc	0, cr0, [r0], {162}	; 0xa2
    307c:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    3080:	60010069 	andvs	r0, r1, r9, rrx
    3084:	0001040e 	andeq	r0, r1, lr, lsl #8
    3088:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    308c:	d1140000 	tstle	r4, r0
    3090:	01000015 	tsteq	r0, r5, lsl r0
    3094:	15ea0552 	strbne	r0, [sl, #1362]!	; 0x552
    3098:	01040000 	mrseq	r0, (UNDEF: 4)
    309c:	a2840000 	addge	r0, r4, #0
    30a0:	00540000 	subseq	r0, r4, r0
    30a4:	9c010000 	stcls	0, cr0, [r1], {-0}
    30a8:	000001af 	andeq	r0, r0, pc, lsr #3
    30ac:	0100730b 	tsteq	r0, fp, lsl #6
    30b0:	010b1852 	tsteq	fp, r2, asr r8
    30b4:	91020000 	mrsls	r0, (UNDEF: 2)
    30b8:	00690e6c 	rsbeq	r0, r9, ip, ror #28
    30bc:	04095401 	streq	r5, [r9], #-1025	; 0xfffffbff
    30c0:	02000001 	andeq	r0, r0, #1
    30c4:	14007491 	strne	r7, [r0], #-1169	; 0xfffffb6f
    30c8:	0000160d 	andeq	r1, r0, sp, lsl #12
    30cc:	d8054201 	stmdale	r5, {r0, r9, lr}
    30d0:	04000015 	streq	r0, [r0], #-21	; 0xffffffeb
    30d4:	d8000001 	stmdale	r0, {r0}
    30d8:	ac0000a1 	stcge	0, cr0, [r0], {161}	; 0xa1
    30dc:	01000000 	mrseq	r0, (UNDEF: 0)
    30e0:	0002159c 	muleq	r2, ip, r5
    30e4:	31730b00 	cmncc	r3, r0, lsl #22
    30e8:	19420100 	stmdbne	r2, {r8}^
    30ec:	0000010b 	andeq	r0, r0, fp, lsl #2
    30f0:	0b6c9102 	bleq	1b27500 <_bss_end+0x1b1ca78>
    30f4:	01003273 	tsteq	r0, r3, ror r2
    30f8:	010b2942 	tsteq	fp, r2, asr #18
    30fc:	91020000 	mrsls	r0, (UNDEF: 2)
    3100:	756e0b68 	strbvc	r0, [lr, #-2920]!	; 0xfffff498
    3104:	4201006d 	andmi	r0, r1, #109	; 0x6d
    3108:	00010431 	andeq	r0, r1, r1, lsr r4
    310c:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    3110:	0031750e 	eorseq	r7, r1, lr, lsl #10
    3114:	15134401 	ldrne	r4, [r3, #-1025]	; 0xfffffbff
    3118:	02000002 	andeq	r0, r0, #2
    311c:	750e7791 	strvc	r7, [lr, #-1937]	; 0xfffff86f
    3120:	44010032 	strmi	r0, [r1], #-50	; 0xffffffce
    3124:	00021517 	andeq	r1, r2, r7, lsl r5
    3128:	76910200 	ldrvc	r0, [r1], r0, lsl #4
    312c:	08010800 	stmdaeq	r1, {fp}
    3130:	00000361 	andeq	r0, r0, r1, ror #6
    3134:	00161514 	andseq	r1, r6, r4, lsl r5
    3138:	07360100 	ldreq	r0, [r6, -r0, lsl #2]!
    313c:	000015fc 	strdeq	r1, [r0], -ip
    3140:	00000111 	andeq	r0, r0, r1, lsl r1
    3144:	0000a118 	andeq	sl, r0, r8, lsl r1
    3148:	000000c0 	andeq	r0, r0, r0, asr #1
    314c:	02759c01 	rsbseq	r9, r5, #256	; 0x100
    3150:	3d130000 	ldccc	0, cr0, [r3, #-0]
    3154:	01000015 	tsteq	r0, r5, lsl r0
    3158:	01111536 	tsteq	r1, r6, lsr r5
    315c:	91020000 	mrsls	r0, (UNDEF: 2)
    3160:	72730b6c 	rsbsvc	r0, r3, #108, 22	; 0x1b000
    3164:	36010063 	strcc	r0, [r1], -r3, rrx
    3168:	00010b27 	andeq	r0, r1, r7, lsr #22
    316c:	68910200 	ldmvs	r1, {r9}
    3170:	6d756e0b 	ldclvs	14, cr6, [r5, #-44]!	; 0xffffffd4
    3174:	30360100 	eorscc	r0, r6, r0, lsl #2
    3178:	00000104 	andeq	r0, r0, r4, lsl #2
    317c:	0e649102 	lgneqs	f1, f2
    3180:	38010069 	stmdacc	r1, {r0, r3, r5, r6}
    3184:	00010409 	andeq	r0, r1, r9, lsl #8
    3188:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    318c:	15f71400 	ldrbne	r1, [r7, #1024]!	; 0x400
    3190:	24010000 	strcs	r0, [r1], #-0
    3194:	00155b05 	andseq	r5, r5, r5, lsl #22
    3198:	00010400 	andeq	r0, r1, r0, lsl #8
    319c:	00a07c00 	adceq	r7, r0, r0, lsl #24
    31a0:	00009c00 	andeq	r9, r0, r0, lsl #24
    31a4:	b29c0100 	addslt	r0, ip, #0, 2
    31a8:	13000002 	movwne	r0, #2
    31ac:	00000cd4 	ldrdeq	r0, [r0], -r4
    31b0:	0b162401 	bleq	58c1bc <_bss_end+0x581734>
    31b4:	02000001 	andeq	r0, r0, #1
    31b8:	cd0c6c91 	stcgt	12, cr6, [ip, #-580]	; 0xfffffdbc
    31bc:	0100000c 	tsteq	r0, ip
    31c0:	01040926 	tsteq	r4, r6, lsr #18
    31c4:	91020000 	mrsls	r0, (UNDEF: 2)
    31c8:	c7150074 			; <UNDEFINED> instruction: 0xc7150074
    31cc:	0100000a 	tsteq	r0, sl
    31d0:	162b0608 	strtne	r0, [fp], -r8, lsl #12
    31d4:	9f080000 	svcls	0x00080000
    31d8:	01740000 	cmneq	r4, r0
    31dc:	9c010000 	stcls	0, cr0, [r1], {-0}
    31e0:	000cd413 	andeq	sp, ip, r3, lsl r4
    31e4:	18080100 	stmdane	r8, {r8}
    31e8:	00000066 	andeq	r0, r0, r6, rrx
    31ec:	13649102 	cmnne	r4, #-2147483648	; 0x80000000
    31f0:	00000ccd 	andeq	r0, r0, sp, asr #25
    31f4:	11250801 			; <UNDEFINED> instruction: 0x11250801
    31f8:	02000001 	andeq	r0, r0, #1
    31fc:	f7136091 			; <UNDEFINED> instruction: 0xf7136091
    3200:	01000016 	tsteq	r0, r6, lsl r0
    3204:	00663a08 	rsbeq	r3, r6, r8, lsl #20
    3208:	91020000 	mrsls	r0, (UNDEF: 2)
    320c:	00690e5c 	rsbeq	r0, r9, ip, asr lr
    3210:	04090a01 	streq	r0, [r9], #-2561	; 0xfffff5ff
    3214:	02000001 	andeq	r0, r0, #1
    3218:	d40d7491 	strle	r7, [sp], #-1169	; 0xfffffb6f
    321c:	9800009f 	stmdals	r0, {r0, r1, r2, r3, r4, r7}
    3220:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    3224:	1c01006a 	stcne	0, cr0, [r1], {106}	; 0x6a
    3228:	0001040e 	andeq	r0, r1, lr, lsl #8
    322c:	70910200 	addsvc	r0, r1, r0, lsl #4
    3230:	009ffc0d 	addseq	pc, pc, sp, lsl #24
    3234:	00006000 	andeq	r6, r0, r0
    3238:	00630e00 	rsbeq	r0, r3, r0, lsl #28
    323c:	6d0e1e01 	stcvs	14, cr1, [lr, #-4]
    3240:	02000000 	andeq	r0, r0, #0
    3244:	00006f91 	muleq	r0, r1, pc	; <UNPREDICTABLE>
    3248:	00220000 	eoreq	r0, r2, r0
    324c:	00020000 	andeq	r0, r2, r0
    3250:	000010d1 	ldrdeq	r1, [r0], -r1	; <UNPREDICTABLE>
    3254:	16c10104 	strbne	r0, [r1], r4, lsl #2
    3258:	a3c00000 	bicge	r0, r0, #0
    325c:	a5cc0000 	strbge	r0, [ip]
    3260:	16370000 	ldrtne	r0, [r7], -r0
    3264:	16670000 	strbtne	r0, [r7], -r0
    3268:	16cf0000 	strbne	r0, [pc], r0
    326c:	80010000 	andhi	r0, r1, r0
    3270:	00000022 	andeq	r0, r0, r2, lsr #32
    3274:	10e50002 	rscne	r0, r5, r2
    3278:	01040000 	mrseq	r0, (UNDEF: 4)
    327c:	0000173e 	andeq	r1, r0, lr, lsr r7
    3280:	0000a5cc 	andeq	sl, r0, ip, asr #11
    3284:	0000a5d0 	ldrdeq	sl, [r0], -r0
    3288:	00001637 	andeq	r1, r0, r7, lsr r6
    328c:	00001667 	andeq	r1, r0, r7, ror #12
    3290:	000016cf 	andeq	r1, r0, pc, asr #13
    3294:	032a8001 			; <UNDEFINED> instruction: 0x032a8001
    3298:	00040000 	andeq	r0, r4, r0
    329c:	000010f9 	strdeq	r1, [r0], -r9
    32a0:	17fb0104 	ldrbne	r0, [fp, r4, lsl #2]!
    32a4:	b40c0000 	strlt	r0, [ip], #-0
    32a8:	67000019 	smladvs	r0, r9, r0, r0
    32ac:	9e000016 	mcrls	0, 0, r0, cr0, cr6, {0}
    32b0:	02000017 	andeq	r0, r0, #23
    32b4:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
    32b8:	04030074 	streq	r0, [r3], #-116	; 0xffffff8c
    32bc:	0019fd07 	andseq	pc, r9, r7, lsl #26
    32c0:	05080300 	streq	r0, [r8, #-768]	; 0xfffffd00
    32c4:	000001b7 			; <UNDEFINED> instruction: 0x000001b7
    32c8:	a8040803 	stmdage	r4, {r0, r1, fp}
    32cc:	03000019 	movweq	r0, #25
    32d0:	03610801 	cmneq	r1, #65536	; 0x10000
    32d4:	01030000 	mrseq	r0, (UNDEF: 3)
    32d8:	00036306 	andeq	r6, r3, r6, lsl #6
    32dc:	1b800400 	blne	fe0042e4 <_bss_end+0xfdff985c>
    32e0:	01070000 	mrseq	r0, (UNDEF: 7)
    32e4:	00000039 	andeq	r0, r0, r9, lsr r0
    32e8:	d4061701 	strle	r1, [r6], #-1793	; 0xfffff8ff
    32ec:	05000001 	streq	r0, [r0, #-1]
    32f0:	0000170a 	andeq	r1, r0, sl, lsl #14
    32f4:	1c2f0500 	cfstr32ne	mvfx0, [pc], #-0	; 32fc <CPSR_IRQ_INHIBIT+0x327c>
    32f8:	05010000 	streq	r0, [r1, #-0]
    32fc:	000018dd 	ldrdeq	r1, [r0], -sp
    3300:	199b0502 	ldmibne	fp, {r1, r8, sl}
    3304:	05030000 	streq	r0, [r3, #-0]
    3308:	00001b99 	muleq	r0, r9, fp
    330c:	1c3f0504 	cfldr32ne	mvfx0, [pc], #-16	; 3304 <CPSR_IRQ_INHIBIT+0x3284>
    3310:	05050000 	streq	r0, [r5, #-0]
    3314:	00001baf 	andeq	r1, r0, pc, lsr #23
    3318:	19e40506 	stmibne	r4!, {r1, r2, r8, sl}^
    331c:	05070000 	streq	r0, [r7, #-0]
    3320:	00001b2a 	andeq	r1, r0, sl, lsr #22
    3324:	1b380508 	blne	e0474c <_bss_end+0xdf9cc4>
    3328:	05090000 	streq	r0, [r9, #-0]
    332c:	00001b46 	andeq	r1, r0, r6, asr #22
    3330:	1a4d050a 	bne	1344760 <_bss_end+0x1339cd8>
    3334:	050b0000 	streq	r0, [fp, #-0]
    3338:	00001a3d 	andeq	r1, r0, sp, lsr sl
    333c:	1726050c 	strne	r0, [r6, -ip, lsl #10]!
    3340:	050d0000 	streq	r0, [sp, #-0]
    3344:	0000173f 	andeq	r1, r0, pc, lsr r7
    3348:	1a2e050e 	bne	b84788 <_bss_end+0xb79d00>
    334c:	050f0000 	streq	r0, [pc, #-0]	; 3354 <CPSR_IRQ_INHIBIT+0x32d4>
    3350:	00001bf2 	strdeq	r1, [r0], -r2
    3354:	1b6f0510 	blne	1bc479c <_bss_end+0x1bb9d14>
    3358:	05110000 	ldreq	r0, [r1, #-0]
    335c:	00001be3 	andeq	r1, r0, r3, ror #23
    3360:	17ec0512 			; <UNDEFINED> instruction: 0x17ec0512
    3364:	05130000 	ldreq	r0, [r3, #-0]
    3368:	00001769 	andeq	r1, r0, r9, ror #14
    336c:	17330514 			; <UNDEFINED> instruction: 0x17330514
    3370:	05150000 	ldreq	r0, [r5, #-0]
    3374:	00001acc 	andeq	r1, r0, ip, asr #21
    3378:	17a00516 			; <UNDEFINED> instruction: 0x17a00516
    337c:	05170000 	ldreq	r0, [r7, #-0]
    3380:	000016db 	ldrdeq	r1, [r0], -fp
    3384:	1bd50518 	blne	ff5447ec <_bss_end+0xff539d64>
    3388:	05190000 	ldreq	r0, [r9, #-0]
    338c:	00001a0a 	andeq	r1, r0, sl, lsl #20
    3390:	1ae4051a 	bne	ff904800 <_bss_end+0xff8f9d78>
    3394:	051b0000 	ldreq	r0, [fp, #-0]
    3398:	00001774 	andeq	r1, r0, r4, ror r7
    339c:	1980051c 	stmibne	r0, {r2, r3, r4, r8, sl}
    33a0:	051d0000 	ldreq	r0, [sp, #-0]
    33a4:	000018cf 	andeq	r1, r0, pc, asr #17
    33a8:	1b61051e 	blne	1844828 <_bss_end+0x1839da0>
    33ac:	051f0000 	ldreq	r0, [pc, #-0]	; 33b4 <CPSR_IRQ_INHIBIT+0x3334>
    33b0:	00001bbd 			; <UNDEFINED> instruction: 0x00001bbd
    33b4:	1bfe0520 	blne	fff8483c <_bss_end+0xfff79db4>
    33b8:	05210000 	streq	r0, [r1, #-0]!
    33bc:	00001c0c 	andeq	r1, r0, ip, lsl #24
    33c0:	1a210522 	bne	844850 <_bss_end+0x839dc8>
    33c4:	05230000 	streq	r0, [r3, #-0]!
    33c8:	00001944 	andeq	r1, r0, r4, asr #18
    33cc:	17830524 	strne	r0, [r3, r4, lsr #10]
    33d0:	05250000 	streq	r0, [r5, #-0]!
    33d4:	000019d7 	ldrdeq	r1, [r0], -r7
    33d8:	18e90526 	stmiane	r9!, {r1, r2, r5, r8, sl}^
    33dc:	05270000 	streq	r0, [r7, #-0]!
    33e0:	00001b8c 	andeq	r1, r0, ip, lsl #23
    33e4:	18f90528 	ldmne	r9!, {r3, r5, r8, sl}^
    33e8:	05290000 	streq	r0, [r9, #-0]!
    33ec:	00001908 	andeq	r1, r0, r8, lsl #18
    33f0:	1917052a 	ldmdbne	r7, {r1, r3, r5, r8, sl}
    33f4:	052b0000 	streq	r0, [fp, #-0]!
    33f8:	00001926 	andeq	r1, r0, r6, lsr #18
    33fc:	18b4052c 	ldmne	r4!, {r2, r3, r5, r8, sl}
    3400:	052d0000 	streq	r0, [sp, #-0]!
    3404:	00001935 	andeq	r1, r0, r5, lsr r9
    3408:	1b1b052e 	blne	6c48c8 <_bss_end+0x6b9e40>
    340c:	052f0000 	streq	r0, [pc, #-0]!	; 3414 <CPSR_IRQ_INHIBIT+0x3394>
    3410:	00001953 	andeq	r1, r0, r3, asr r9
    3414:	19620530 	stmdbne	r2!, {r4, r5, r8, sl}^
    3418:	05310000 	ldreq	r0, [r1, #-0]!
    341c:	00001714 	andeq	r1, r0, r4, lsl r7
    3420:	1a6c0532 	bne	1b048f0 <_bss_end+0x1af9e68>
    3424:	05330000 	ldreq	r0, [r3, #-0]!
    3428:	00001a7c 	andeq	r1, r0, ip, ror sl
    342c:	1a8c0534 	bne	fe304904 <_bss_end+0xfe2f9e7c>
    3430:	05350000 	ldreq	r0, [r5, #-0]!
    3434:	000018a2 	andeq	r1, r0, r2, lsr #17
    3438:	1a9c0536 	bne	fe704918 <_bss_end+0xfe6f9e90>
    343c:	05370000 	ldreq	r0, [r7, #-0]!
    3440:	00001aac 	andeq	r1, r0, ip, lsr #21
    3444:	1abc0538 	bne	fef0492c <_bss_end+0xfeef9ea4>
    3448:	05390000 	ldreq	r0, [r9, #-0]!
    344c:	00001793 	muleq	r0, r3, r7
    3450:	174c053a 	smlaldxne	r0, ip, sl, r5
    3454:	053b0000 	ldreq	r0, [fp, #-0]!
    3458:	00001971 	andeq	r1, r0, r1, ror r9
    345c:	16eb053c 			; <UNDEFINED> instruction: 0x16eb053c
    3460:	053d0000 	ldreq	r0, [sp, #-0]!
    3464:	00001ad7 	ldrdeq	r1, [r0], -r7
    3468:	d306003e 	movwle	r0, #24638	; 0x603e
    346c:	02000017 	andeq	r0, r0, #23
    3470:	08026b01 	stmdaeq	r2, {r0, r8, r9, fp, sp, lr}
    3474:	000001ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    3478:	00199607 	andseq	r9, r9, r7, lsl #12
    347c:	02700100 	rsbseq	r0, r0, #0, 2
    3480:	00004714 	andeq	r4, r0, r4, lsl r7
    3484:	af070000 	svcge	0x00070000
    3488:	01000018 	tsteq	r0, r8, lsl r0
    348c:	47140271 			; <UNDEFINED> instruction: 0x47140271
    3490:	01000000 	mrseq	r0, (UNDEF: 0)
    3494:	01d40800 	bicseq	r0, r4, r0, lsl #16
    3498:	ff090000 			; <UNDEFINED> instruction: 0xff090000
    349c:	14000001 	strne	r0, [r0], #-1
    34a0:	0a000002 	beq	34b0 <CPSR_IRQ_INHIBIT+0x3430>
    34a4:	00000024 	andeq	r0, r0, r4, lsr #32
    34a8:	04080011 	streq	r0, [r8], #-17	; 0xffffffef
    34ac:	0b000002 	bleq	34bc <CPSR_IRQ_INHIBIT+0x343c>
    34b0:	00001a5a 	andeq	r1, r0, sl, asr sl
    34b4:	26027401 	strcs	r7, [r2], -r1, lsl #8
    34b8:	00000214 	andeq	r0, r0, r4, lsl r2
    34bc:	0a3d3a24 	beq	f51d54 <_bss_end+0xf472cc>
    34c0:	243d0f3d 	ldrtcs	r0, [sp], #-3901	; 0xfffff0c3
    34c4:	023d323d 	eorseq	r3, sp, #-805306365	; 0xd0000003
    34c8:	133d053d 	teqne	sp, #255852544	; 0xf400000
    34cc:	0c3d0d3d 	ldceq	13, cr0, [sp], #-244	; 0xffffff0c
    34d0:	113d233d 	teqne	sp, sp, lsr r3
    34d4:	013d263d 	teqeq	sp, sp, lsr r6
    34d8:	083d173d 	ldmdaeq	sp!, {r0, r2, r3, r4, r5, r8, r9, sl, ip}
    34dc:	003d093d 	eorseq	r0, sp, sp, lsr r9
    34e0:	07020300 	streq	r0, [r2, -r0, lsl #6]
    34e4:	000003b6 			; <UNDEFINED> instruction: 0x000003b6
    34e8:	6a080103 	bvs	2038fc <_bss_end+0x1f8e74>
    34ec:	0c000003 	stceq	0, cr0, [r0], {3}
    34f0:	0259040d 	subseq	r0, r9, #218103808	; 0xd000000
    34f4:	1a0e0000 	bne	3834fc <_bss_end+0x378a74>
    34f8:	0700001c 	smladeq	r0, ip, r0, r0
    34fc:	00003901 	andeq	r3, r0, r1, lsl #18
    3500:	04f70200 	ldrbteq	r0, [r7], #512	; 0x200
    3504:	00029e06 	andeq	r9, r2, r6, lsl #28
    3508:	17ad0500 	strne	r0, [sp, r0, lsl #10]!
    350c:	05000000 	streq	r0, [r0, #-0]
    3510:	000017b8 			; <UNDEFINED> instruction: 0x000017b8
    3514:	17ca0501 	strbne	r0, [sl, r1, lsl #10]
    3518:	05020000 	streq	r0, [r2, #-0]
    351c:	000017e4 	andeq	r1, r0, r4, ror #15
    3520:	1b540503 	blne	1504934 <_bss_end+0x14f9eac>
    3524:	05040000 	streq	r0, [r4, #-0]
    3528:	000018c3 	andeq	r1, r0, r3, asr #17
    352c:	1b0d0505 	blne	344948 <_bss_end+0x339ec0>
    3530:	00060000 	andeq	r0, r6, r0
    3534:	2a050203 	bcs	143d48 <_bss_end+0x1392c0>
    3538:	03000002 	movweq	r0, #2
    353c:	19f30708 	ldmibne	r3!, {r3, r8, r9, sl}^
    3540:	04030000 	streq	r0, [r3], #-0
    3544:	00170404 	andseq	r0, r7, r4, lsl #8
    3548:	03080300 	movweq	r0, #33536	; 0x8300
    354c:	000016fc 	strdeq	r1, [r0], -ip
    3550:	ad040803 	stcge	8, cr0, [r4, #-12]
    3554:	03000019 	movweq	r0, #25
    3558:	1afe0310 	bne	fff841a0 <_bss_end+0xfff79718>
    355c:	f50f0000 			; <UNDEFINED> instruction: 0xf50f0000
    3560:	0300001a 	movweq	r0, #26
    3564:	025a102a 	subseq	r1, sl, #42	; 0x2a
    3568:	c8090000 	stmdagt	r9, {}	; <UNPREDICTABLE>
    356c:	df000002 	svcle	0x00000002
    3570:	10000002 	andne	r0, r0, r2
    3574:	150a1100 	strne	r1, [sl, #-256]	; 0xffffff00
    3578:	2f030000 	svccs	0x00030000
    357c:	0002d411 	andeq	sp, r2, r1, lsl r4
    3580:	14ea1100 	strbtne	r1, [sl], #256	; 0x100
    3584:	30030000 	andcc	r0, r3, r0
    3588:	0002d411 	andeq	sp, r2, r1, lsl r4
    358c:	02c80900 	sbceq	r0, r8, #0, 18
    3590:	03070000 	movweq	r0, #28672	; 0x7000
    3594:	240a0000 	strcs	r0, [sl], #-0
    3598:	01000000 	mrseq	r0, (UNDEF: 0)
    359c:	02df1200 	sbcseq	r1, pc, #0, 4
    35a0:	33040000 	movwcc	r0, #16384	; 0x4000
    35a4:	02f70a09 	rscseq	r0, r7, #36864	; 0x9000
    35a8:	03050000 	movweq	r0, #20480	; 0x5000
    35ac:	0000a9fc 	strdeq	sl, [r0], -ip
    35b0:	0002eb12 	andeq	lr, r2, r2, lsl fp
    35b4:	09340400 	ldmdbeq	r4!, {sl}
    35b8:	0002f70a 	andeq	pc, r2, sl, lsl #14
    35bc:	10030500 	andne	r0, r3, r0, lsl #10
    35c0:	000000aa 	andeq	r0, r0, sl, lsr #1

Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
       0:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
       4:	030b130e 	movweq	r1, #45838	; 0xb30e
       8:	110e1b0e 	tstne	lr, lr, lsl #22
       c:	10061201 	andne	r1, r6, r1, lsl #4
      10:	02000017 	andeq	r0, r0, #23
      14:	193f002e 	ldmdbne	pc!, {r1, r2, r3, r5}	; <UNPREDICTABLE>
      18:	0b3a0e03 	bleq	e8382c <_bss_end+0xe78da4>
      1c:	0b390b3b 	bleq	e42d10 <_bss_end+0xe38288>
      20:	06120111 			; <UNDEFINED> instruction: 0x06120111
      24:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
      28:	03000019 	movweq	r0, #25
      2c:	0e030139 	mcreq	1, 0, r0, cr3, cr9, {1}
      30:	0b3b0b3a 	bleq	ec2d20 <_bss_end+0xeb8298>
      34:	00001301 	andeq	r1, r0, r1, lsl #6
      38:	3f012e04 	svccc	0x00012e04
      3c:	3a0e0319 	bcc	380ca8 <_bss_end+0x376220>
      40:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
      44:	01193c0b 	tsteq	r9, fp, lsl #24
      48:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
      4c:	13490005 	movtne	r0, #36869	; 0x9005
      50:	16060000 	strne	r0, [r6], -r0
      54:	3a0e0300 	bcc	380c5c <_bss_end+0x3761d4>
      58:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
      5c:	0013490b 	andseq	r4, r3, fp, lsl #18
      60:	012e0700 			; <UNDEFINED> instruction: 0x012e0700
      64:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
      68:	0b3b0b3a 	bleq	ec2d58 <_bss_end+0xeb82d0>
      6c:	13490b39 	movtne	r0, #39737	; 0x9b39
      70:	0000193c 	andeq	r1, r0, ip, lsr r9
      74:	0b000f08 	bleq	3c9c <CPSR_IRQ_INHIBIT+0x3c1c>
      78:	0013490b 	andseq	r4, r3, fp, lsl #18
      7c:	00240900 	eoreq	r0, r4, r0, lsl #18
      80:	0b3e0b0b 	bleq	f82cb4 <_bss_end+0xf7822c>
      84:	00000e03 	andeq	r0, r0, r3, lsl #28
      88:	47012e0a 	strmi	r2, [r1, -sl, lsl #28]
      8c:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
      90:	97184006 	ldrls	r4, [r8, -r6]
      94:	13011942 	movwne	r1, #6466	; 0x1942
      98:	050b0000 	streq	r0, [fp, #-0]
      9c:	02134900 	andseq	r4, r3, #0, 18
      a0:	0c000018 	stceq	0, cr0, [r0], {24}
      a4:	08030005 	stmdaeq	r3, {r0, r2}
      a8:	0b3b0b3a 	bleq	ec2d98 <_bss_end+0xeb8310>
      ac:	13490b39 	movtne	r0, #39737	; 0x9b39
      b0:	00001802 	andeq	r1, r0, r2, lsl #16
      b4:	0b00240d 	bleq	90f0 <_ZN8CMonitor4itoaEjPcj+0x128>
      b8:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
      bc:	0e000008 	cdpeq	0, 0, cr0, cr0, cr8, {0}
      c0:	1347012e 	movtne	r0, #28974	; 0x712e
      c4:	06120111 			; <UNDEFINED> instruction: 0x06120111
      c8:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
      cc:	00000019 	andeq	r0, r0, r9, lsl r0
      d0:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
      d4:	030b130e 	movweq	r1, #45838	; 0xb30e
      d8:	110e1b0e 	tstne	lr, lr, lsl #22
      dc:	10061201 	andne	r1, r6, r1, lsl #4
      e0:	02000017 	andeq	r0, r0, #23
      e4:	0b0b0024 	bleq	2c017c <_bss_end+0x2b56f4>
      e8:	0e030b3e 	vmoveq.16	d3[0], r0
      ec:	24030000 	strcs	r0, [r3], #-0
      f0:	3e0b0b00 	vmlacc.f64	d0, d11, d0
      f4:	0008030b 	andeq	r0, r8, fp, lsl #6
      f8:	00160400 	andseq	r0, r6, r0, lsl #8
      fc:	0b3a0e03 	bleq	e83910 <_bss_end+0xe78e88>
     100:	0b390b3b 	bleq	e42df4 <_bss_end+0xe3836c>
     104:	00001349 	andeq	r1, r0, r9, asr #6
     108:	49002605 	stmdbmi	r0, {r0, r2, r9, sl, sp}
     10c:	06000013 			; <UNDEFINED> instruction: 0x06000013
     110:	08030139 	stmdaeq	r3, {r0, r3, r4, r5, r8}
     114:	0b3b0b3a 	bleq	ec2e04 <_bss_end+0xeb837c>
     118:	13010b39 	movwne	r0, #6969	; 0x1b39
     11c:	34070000 	strcc	r0, [r7], #-0
     120:	3a0e0300 	bcc	380d28 <_bss_end+0x3762a0>
     124:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     128:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
     12c:	6c061c19 	stcvs	12, cr1, [r6], {25}
     130:	08000019 	stmdaeq	r0, {r0, r3, r4}
     134:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
     138:	0b3b0b3a 	bleq	ec2e28 <_bss_end+0xeb83a0>
     13c:	13490b39 	movtne	r0, #39737	; 0x9b39
     140:	0b1c193c 	bleq	706638 <_bss_end+0x6fbbb0>
     144:	0000196c 	andeq	r1, r0, ip, ror #18
     148:	03010409 	movweq	r0, #5129	; 0x1409
     14c:	3e196d0e 	cdpcc	13, 1, cr6, cr9, cr14, {0}
     150:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
     154:	3b0b3a13 	blcc	2ce9a8 <_bss_end+0x2c3f20>
     158:	010b390b 	tsteq	fp, fp, lsl #18
     15c:	0a000013 	beq	1b0 <CPSR_IRQ_INHIBIT+0x130>
     160:	08030028 	stmdaeq	r3, {r3, r5}
     164:	00000b1c 	andeq	r0, r0, ip, lsl fp
     168:	0300280b 	movweq	r2, #2059	; 0x80b
     16c:	000b1c0e 	andeq	r1, fp, lr, lsl #24
     170:	00340c00 	eorseq	r0, r4, r0, lsl #24
     174:	00001347 	andeq	r1, r0, r7, asr #6
     178:	0301020d 	movweq	r0, #4621	; 0x120d
     17c:	3a0b0b0e 	bcc	2c2dbc <_bss_end+0x2b8334>
     180:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     184:	0013010b 	andseq	r0, r3, fp, lsl #2
     188:	000d0e00 	andeq	r0, sp, r0, lsl #28
     18c:	0b3a0e03 	bleq	e839a0 <_bss_end+0xe78f18>
     190:	0b390b3b 	bleq	e42e84 <_bss_end+0xe383fc>
     194:	0b381349 	bleq	e04ec0 <_bss_end+0xdfa438>
     198:	2e0f0000 	cdpcs	0, 0, cr0, cr15, cr0, {0}
     19c:	03193f01 	tsteq	r9, #1, 30
     1a0:	3b0b3a0e 	blcc	2ce9e0 <_bss_end+0x2c3f58>
     1a4:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     1a8:	3213490e 	andscc	r4, r3, #229376	; 0x38000
     1ac:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
     1b0:	00130113 	andseq	r0, r3, r3, lsl r1
     1b4:	00051000 	andeq	r1, r5, r0
     1b8:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
     1bc:	05110000 	ldreq	r0, [r1, #-0]
     1c0:	00134900 	andseq	r4, r3, r0, lsl #18
     1c4:	012e1200 			; <UNDEFINED> instruction: 0x012e1200
     1c8:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     1cc:	0b3b0b3a 	bleq	ec2ebc <_bss_end+0xeb8434>
     1d0:	0e6e0b39 	vmoveq.8	d14[5], r0
     1d4:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
     1d8:	13011364 	movwne	r1, #4964	; 0x1364
     1dc:	2e130000 	cdpcs	0, 1, cr0, cr3, cr0, {0}
     1e0:	03193f01 	tsteq	r9, #1, 30
     1e4:	3b0b3a0e 	blcc	2cea24 <_bss_end+0x2c3f9c>
     1e8:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     1ec:	3213490e 	andscc	r4, r3, #229376	; 0x38000
     1f0:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
     1f4:	14000013 	strne	r0, [r0], #-19	; 0xffffffed
     1f8:	0b0b000f 	bleq	2c023c <_bss_end+0x2b57b4>
     1fc:	00001349 	andeq	r1, r0, r9, asr #6
     200:	03003415 	movweq	r3, #1045	; 0x415
     204:	3b0b3a0e 	blcc	2cea44 <_bss_end+0x2c3fbc>
     208:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     20c:	3c193f13 	ldccc	15, cr3, [r9], {19}
     210:	16000019 			; <UNDEFINED> instruction: 0x16000019
     214:	13470034 	movtne	r0, #28724	; 0x7034
     218:	0b3b0b3a 	bleq	ec2f08 <_bss_end+0xeb8480>
     21c:	18020b39 	stmdane	r2, {r0, r3, r4, r5, r8, r9, fp}
     220:	2e170000 	cdpcs	0, 1, cr0, cr7, cr0, {0}
     224:	340e0300 	strcc	r0, [lr], #-768	; 0xfffffd00
     228:	12011119 	andne	r1, r1, #1073741830	; 0x40000006
     22c:	96184006 	ldrls	r4, [r8], -r6
     230:	00001942 	andeq	r1, r0, r2, asr #18
     234:	03012e18 	movweq	r2, #7704	; 0x1e18
     238:	1119340e 	tstne	r9, lr, lsl #8
     23c:	40061201 	andmi	r1, r6, r1, lsl #4
     240:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
     244:	00001301 	andeq	r1, r0, r1, lsl #6
     248:	03000519 	movweq	r0, #1305	; 0x519
     24c:	3b0b3a0e 	blcc	2cea8c <_bss_end+0x2c4004>
     250:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     254:	00180213 	andseq	r0, r8, r3, lsl r2
     258:	012e1a00 			; <UNDEFINED> instruction: 0x012e1a00
     25c:	0b3a1347 	bleq	e84f80 <_bss_end+0xe7a4f8>
     260:	0b390b3b 	bleq	e42f54 <_bss_end+0xe384cc>
     264:	01111364 	tsteq	r1, r4, ror #6
     268:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
     26c:	01194297 			; <UNDEFINED> instruction: 0x01194297
     270:	1b000013 	blne	2c4 <CPSR_IRQ_INHIBIT+0x244>
     274:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
     278:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
     27c:	00001802 	andeq	r1, r0, r2, lsl #16
     280:	47012e1c 	smladmi	r1, ip, lr, r2
     284:	3b0b3a13 	blcc	2cead8 <_bss_end+0x2c4050>
     288:	640b390b 	strvs	r3, [fp], #-2315	; 0xfffff6f5
     28c:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
     290:	96184006 	ldrls	r4, [r8], -r6
     294:	13011942 	movwne	r1, #6466	; 0x1942
     298:	2e1d0000 	cdpcs	0, 1, cr0, cr13, cr0, {0}
     29c:	3a134701 	bcc	4d1ea8 <_bss_end+0x4c7420>
     2a0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     2a4:	2013640b 	andscs	r6, r3, fp, lsl #8
     2a8:	0013010b 	andseq	r0, r3, fp, lsl #2
     2ac:	00051e00 	andeq	r1, r5, r0, lsl #28
     2b0:	13490e03 	movtne	r0, #40451	; 0x9e03
     2b4:	00001934 	andeq	r1, r0, r4, lsr r9
     2b8:	0300051f 	movweq	r0, #1311	; 0x51f
     2bc:	3b0b3a0e 	blcc	2ceafc <_bss_end+0x2c4074>
     2c0:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     2c4:	20000013 	andcs	r0, r0, r3, lsl r0
     2c8:	1331012e 	teqne	r1, #-2147483637	; 0x8000000b
     2cc:	13640e6e 	cmnne	r4, #1760	; 0x6e0
     2d0:	06120111 			; <UNDEFINED> instruction: 0x06120111
     2d4:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
     2d8:	21000019 	tstcs	r0, r9, lsl r0
     2dc:	13310005 	teqne	r1, #5
     2e0:	00001802 	andeq	r1, r0, r2, lsl #16
     2e4:	01110100 	tsteq	r1, r0, lsl #2
     2e8:	0b130e25 	bleq	4c3b84 <_bss_end+0x4b90fc>
     2ec:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
     2f0:	06120111 			; <UNDEFINED> instruction: 0x06120111
     2f4:	00001710 	andeq	r1, r0, r0, lsl r7
     2f8:	0b002402 	bleq	9308 <_ZN5CUARTC1ER4CAUX+0x64>
     2fc:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
     300:	0300000e 	movweq	r0, #14
     304:	0b0b0024 	bleq	2c039c <_bss_end+0x2b5914>
     308:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
     30c:	16040000 	strne	r0, [r4], -r0
     310:	3a0e0300 	bcc	380f18 <_bss_end+0x376490>
     314:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     318:	0013490b 	andseq	r4, r3, fp, lsl #18
     31c:	00260500 	eoreq	r0, r6, r0, lsl #10
     320:	00001349 	andeq	r1, r0, r9, asr #6
     324:	03013906 	movweq	r3, #6406	; 0x1906
     328:	3b0b3a08 	blcc	2ceb50 <_bss_end+0x2c40c8>
     32c:	010b390b 	tsteq	fp, fp, lsl #18
     330:	07000013 	smladeq	r0, r3, r0, r0
     334:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
     338:	0b3b0b3a 	bleq	ec3028 <_bss_end+0xeb85a0>
     33c:	13490b39 	movtne	r0, #39737	; 0x9b39
     340:	061c193c 			; <UNDEFINED> instruction: 0x061c193c
     344:	0000196c 	andeq	r1, r0, ip, ror #18
     348:	03003408 	movweq	r3, #1032	; 0x408
     34c:	3b0b3a0e 	blcc	2ceb8c <_bss_end+0x2c4104>
     350:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     354:	1c193c13 	ldcne	12, cr3, [r9], {19}
     358:	00196c0b 	andseq	r6, r9, fp, lsl #24
     35c:	01040900 	tsteq	r4, r0, lsl #18
     360:	196d0e03 	stmdbne	sp!, {r0, r1, r9, sl, fp}^
     364:	0b0b0b3e 	bleq	2c3064 <_bss_end+0x2b85dc>
     368:	0b3a1349 	bleq	e85094 <_bss_end+0xe7a60c>
     36c:	0b390b3b 	bleq	e43060 <_bss_end+0xe385d8>
     370:	00001301 	andeq	r1, r0, r1, lsl #6
     374:	0300280a 	movweq	r2, #2058	; 0x80a
     378:	000b1c0e 	andeq	r1, fp, lr, lsl #24
     37c:	00340b00 	eorseq	r0, r4, r0, lsl #22
     380:	00001347 	andeq	r1, r0, r7, asr #6
     384:	0300280c 	movweq	r2, #2060	; 0x80c
     388:	000b1c08 	andeq	r1, fp, r8, lsl #24
     38c:	01020d00 	tsteq	r2, r0, lsl #26
     390:	0b0b0e03 	bleq	2c3ba4 <_bss_end+0x2b911c>
     394:	0b3b0b3a 	bleq	ec3084 <_bss_end+0xeb85fc>
     398:	13010b39 	movwne	r0, #6969	; 0x1b39
     39c:	0d0e0000 	stceq	0, cr0, [lr, #-0]
     3a0:	3a0e0300 	bcc	380fa8 <_bss_end+0x376520>
     3a4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     3a8:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
     3ac:	0f00000b 	svceq	0x0000000b
     3b0:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
     3b4:	0b3a0e03 	bleq	e83bc8 <_bss_end+0xe79140>
     3b8:	0b390b3b 	bleq	e430ac <_bss_end+0xe38624>
     3bc:	13490e6e 	movtne	r0, #40558	; 0x9e6e
     3c0:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
     3c4:	13011364 	movwne	r1, #4964	; 0x1364
     3c8:	05100000 	ldreq	r0, [r0, #-0]
     3cc:	34134900 	ldrcc	r4, [r3], #-2304	; 0xfffff700
     3d0:	11000019 	tstne	r0, r9, lsl r0
     3d4:	13490005 	movtne	r0, #36869	; 0x9005
     3d8:	2e120000 	cdpcs	0, 1, cr0, cr2, cr0, {0}
     3dc:	03193f01 	tsteq	r9, #1, 30
     3e0:	3b0b3a0e 	blcc	2cec20 <_bss_end+0x2c4198>
     3e4:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     3e8:	3c0b320e 	sfmcc	f3, 4, [fp], {14}
     3ec:	01136419 	tsteq	r3, r9, lsl r4
     3f0:	13000013 	movwne	r0, #19
     3f4:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
     3f8:	0b3a0e03 	bleq	e83c0c <_bss_end+0xe79184>
     3fc:	0b390b3b 	bleq	e430f0 <_bss_end+0xe38668>
     400:	13490e6e 	movtne	r0, #40558	; 0x9e6e
     404:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
     408:	00001364 	andeq	r1, r0, r4, ror #6
     40c:	0b000f14 	bleq	4064 <CPSR_IRQ_INHIBIT+0x3fe4>
     410:	0013490b 	andseq	r4, r3, fp, lsl #18
     414:	00101500 	andseq	r1, r0, r0, lsl #10
     418:	13490b0b 	movtne	r0, #39691	; 0x9b0b
     41c:	34160000 	ldrcc	r0, [r6], #-0
     420:	3a0e0300 	bcc	381028 <_bss_end+0x3765a0>
     424:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     428:	3f13490b 	svccc	0x0013490b
     42c:	00193c19 	andseq	r3, r9, r9, lsl ip
     430:	00341700 	eorseq	r1, r4, r0, lsl #14
     434:	0b3a1347 	bleq	e85158 <_bss_end+0xe7a6d0>
     438:	0b390b3b 	bleq	e4312c <_bss_end+0xe386a4>
     43c:	00001802 	andeq	r1, r0, r2, lsl #16
     440:	03002e18 	movweq	r2, #3608	; 0xe18
     444:	1119340e 	tstne	r9, lr, lsl #8
     448:	40061201 	andmi	r1, r6, r1, lsl #4
     44c:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
     450:	2e190000 	cdpcs	0, 1, cr0, cr9, cr0, {0}
     454:	340e0301 	strcc	r0, [lr], #-769	; 0xfffffcff
     458:	12011119 	andne	r1, r1, #1073741830	; 0x40000006
     45c:	96184006 	ldrls	r4, [r8], -r6
     460:	13011942 	movwne	r1, #6466	; 0x1942
     464:	051a0000 	ldreq	r0, [sl, #-0]
     468:	3a0e0300 	bcc	381070 <_bss_end+0x3765e8>
     46c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     470:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
     474:	1b000018 	blne	4dc <CPSR_IRQ_INHIBIT+0x45c>
     478:	1347012e 	movtne	r0, #28974	; 0x712e
     47c:	0b3b0b3a 	bleq	ec316c <_bss_end+0xeb86e4>
     480:	13640b39 	cmnne	r4, #58368	; 0xe400
     484:	06120111 			; <UNDEFINED> instruction: 0x06120111
     488:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
     48c:	00130119 	andseq	r0, r3, r9, lsl r1
     490:	00051c00 	andeq	r1, r5, r0, lsl #24
     494:	13490e03 	movtne	r0, #40451	; 0x9e03
     498:	18021934 	stmdane	r2, {r2, r4, r5, r8, fp, ip}
     49c:	051d0000 	ldreq	r0, [sp, #-0]
     4a0:	3a080300 	bcc	2010a8 <_bss_end+0x1f6620>
     4a4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     4a8:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
     4ac:	1e000018 	mcrne	0, 0, r0, cr0, cr8, {0}
     4b0:	08030034 	stmdaeq	r3, {r2, r4, r5}
     4b4:	0b3b0b3a 	bleq	ec31a4 <_bss_end+0xeb871c>
     4b8:	13490b39 	movtne	r0, #39737	; 0x9b39
     4bc:	00001802 	andeq	r1, r0, r2, lsl #16
     4c0:	47012e1f 	smladmi	r1, pc, lr, r2	; <UNPREDICTABLE>
     4c4:	3b0b3a13 	blcc	2ced18 <_bss_end+0x2c4290>
     4c8:	640b390b 	strvs	r3, [fp], #-2315	; 0xfffff6f5
     4cc:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
     4d0:	97184006 	ldrls	r4, [r8, -r6]
     4d4:	13011942 	movwne	r1, #6466	; 0x1942
     4d8:	2e200000 	cdpcs	0, 2, cr0, cr0, cr0, {0}
     4dc:	3a134701 	bcc	4d20e8 <_bss_end+0x4c7660>
     4e0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     4e4:	2013640b 	andscs	r6, r3, fp, lsl #8
     4e8:	0013010b 	andseq	r0, r3, fp, lsl #2
     4ec:	00052100 	andeq	r2, r5, r0, lsl #2
     4f0:	13490e03 	movtne	r0, #40451	; 0x9e03
     4f4:	00001934 	andeq	r1, r0, r4, lsr r9
     4f8:	03000522 	movweq	r0, #1314	; 0x522
     4fc:	3b0b3a0e 	blcc	2ced3c <_bss_end+0x2c42b4>
     500:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     504:	23000013 	movwcs	r0, #19
     508:	1331012e 	teqne	r1, #-2147483637	; 0x8000000b
     50c:	13640e6e 	cmnne	r4, #1760	; 0x6e0
     510:	06120111 			; <UNDEFINED> instruction: 0x06120111
     514:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
     518:	24000019 	strcs	r0, [r0], #-25	; 0xffffffe7
     51c:	13310005 	teqne	r1, #5
     520:	00001802 	andeq	r1, r0, r2, lsl #16
     524:	01110100 	tsteq	r1, r0, lsl #2
     528:	0b130e25 	bleq	4c3dc4 <_bss_end+0x4b933c>
     52c:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
     530:	01111755 	tsteq	r1, r5, asr r7
     534:	00001710 	andeq	r1, r0, r0, lsl r7
     538:	03010202 	movweq	r0, #4610	; 0x1202
     53c:	3a0b0b0e 	bcc	2c317c <_bss_end+0x2b86f4>
     540:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     544:	0013010b 	andseq	r0, r3, fp, lsl #2
     548:	01040300 	mrseq	r0, LR_abt
     54c:	196d0e03 	stmdbne	sp!, {r0, r1, r9, sl, fp}^
     550:	0b0b0b3e 	bleq	2c3250 <_bss_end+0x2b87c8>
     554:	0b3a1349 	bleq	e85280 <_bss_end+0xe7a7f8>
     558:	0b390b3b 	bleq	e4324c <_bss_end+0xe387c4>
     55c:	13010b32 	movwne	r0, #6962	; 0x1b32
     560:	28040000 	stmdacs	r4, {}	; <UNPREDICTABLE>
     564:	1c080300 	stcne	3, cr0, [r8], {-0}
     568:	0500000b 	streq	r0, [r0, #-11]
     56c:	13490026 	movtne	r0, #36902	; 0x9026
     570:	13060000 	movwne	r0, #24576	; 0x6000
     574:	0b0e0301 	bleq	381180 <_bss_end+0x3766f8>
     578:	3b0b3a0b 	blcc	2cedac <_bss_end+0x2c4324>
     57c:	010b390b 	tsteq	fp, fp, lsl #18
     580:	07000013 	smladeq	r0, r3, r0, r0
     584:	0803000d 	stmdaeq	r3, {r0, r2, r3}
     588:	0b3b0b3a 	bleq	ec3278 <_bss_end+0xeb87f0>
     58c:	13490b39 	movtne	r0, #39737	; 0x9b39
     590:	00000b38 	andeq	r0, r0, r8, lsr fp
     594:	03000d08 	movweq	r0, #3336	; 0xd08
     598:	3b0b3a0e 	blcc	2cedd8 <_bss_end+0x2c4350>
     59c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     5a0:	32193f13 	andscc	r3, r9, #19, 30	; 0x4c
     5a4:	1c193c0b 	ldcne	12, cr3, [r9], {11}
     5a8:	00196c0b 	andseq	r6, r9, fp, lsl #24
     5ac:	000d0900 	andeq	r0, sp, r0, lsl #18
     5b0:	0b3a0e03 	bleq	e83dc4 <_bss_end+0xe7933c>
     5b4:	0b390b3b 	bleq	e432a8 <_bss_end+0xe38820>
     5b8:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
     5bc:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
     5c0:	0000196c 	andeq	r1, r0, ip, ror #18
     5c4:	3f012e0a 	svccc	0x00012e0a
     5c8:	3a0e0319 	bcc	381234 <_bss_end+0x3767ac>
     5cc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     5d0:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
     5d4:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
     5d8:	64196319 	ldrvs	r6, [r9], #-793	; 0xfffffce7
     5dc:	00130113 	andseq	r0, r3, r3, lsl r1
     5e0:	00050b00 	andeq	r0, r5, r0, lsl #22
     5e4:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
     5e8:	050c0000 	streq	r0, [ip, #-0]
     5ec:	00134900 	andseq	r4, r3, r0, lsl #18
     5f0:	012e0d00 			; <UNDEFINED> instruction: 0x012e0d00
     5f4:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     5f8:	0b3b0b3a 	bleq	ec32e8 <_bss_end+0xeb8860>
     5fc:	0e6e0b39 	vmoveq.8	d14[5], r0
     600:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
     604:	13011364 	movwne	r1, #4964	; 0x1364
     608:	2e0e0000 	cdpcs	0, 0, cr0, cr14, cr0, {0}
     60c:	03193f01 	tsteq	r9, #1, 30
     610:	3b0b3a0e 	blcc	2cee50 <_bss_end+0x2c43c8>
     614:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     618:	3213490e 	andscc	r4, r3, #229376	; 0x38000
     61c:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
     620:	00130113 	andseq	r0, r3, r3, lsl r1
     624:	012e0f00 			; <UNDEFINED> instruction: 0x012e0f00
     628:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     62c:	0b3b0b3a 	bleq	ec331c <_bss_end+0xeb8894>
     630:	0e6e0b39 	vmoveq.8	d14[5], r0
     634:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
     638:	00001301 	andeq	r1, r0, r1, lsl #6
     63c:	03000d10 	movweq	r0, #3344	; 0xd10
     640:	3b0b3a0e 	blcc	2cee80 <_bss_end+0x2c43f8>
     644:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     648:	000b3813 	andeq	r3, fp, r3, lsl r8
     64c:	00241100 	eoreq	r1, r4, r0, lsl #2
     650:	0b3e0b0b 	bleq	f83284 <_bss_end+0xf787fc>
     654:	00000e03 	andeq	r0, r0, r3, lsl #28
     658:	0b000f12 	bleq	42a8 <CPSR_IRQ_INHIBIT+0x4228>
     65c:	0013490b 	andseq	r4, r3, fp, lsl #18
     660:	00101300 	andseq	r1, r0, r0, lsl #6
     664:	13490b0b 	movtne	r0, #39691	; 0x9b0b
     668:	35140000 	ldrcc	r0, [r4, #-0]
     66c:	00134900 	andseq	r4, r3, r0, lsl #18
     670:	00341500 	eorseq	r1, r4, r0, lsl #10
     674:	0b3a0e03 	bleq	e83e88 <_bss_end+0xe79400>
     678:	0b390b3b 	bleq	e4336c <_bss_end+0xe388e4>
     67c:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
     680:	0000193c 	andeq	r1, r0, ip, lsr r9
     684:	47003416 	smladmi	r0, r6, r4, r3
     688:	3b0b3a13 	blcc	2ceedc <_bss_end+0x2c4454>
     68c:	020b390b 	andeq	r3, fp, #180224	; 0x2c000
     690:	17000018 	smladne	r0, r8, r0, r0
     694:	0e03002e 	cdpeq	0, 0, cr0, cr3, cr14, {1}
     698:	01111934 	tsteq	r1, r4, lsr r9
     69c:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
     6a0:	00194296 	mulseq	r9, r6, r2
     6a4:	012e1800 			; <UNDEFINED> instruction: 0x012e1800
     6a8:	19340e03 	ldmdbne	r4!, {r0, r1, r9, sl, fp}
     6ac:	06120111 			; <UNDEFINED> instruction: 0x06120111
     6b0:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
     6b4:	00130119 	andseq	r0, r3, r9, lsl r1
     6b8:	00051900 	andeq	r1, r5, r0, lsl #18
     6bc:	0b3a0e03 	bleq	e83ed0 <_bss_end+0xe79448>
     6c0:	0b390b3b 	bleq	e433b4 <_bss_end+0xe3892c>
     6c4:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
     6c8:	241a0000 	ldrcs	r0, [sl], #-0
     6cc:	3e0b0b00 	vmlacc.f64	d0, d11, d0
     6d0:	0008030b 	andeq	r0, r8, fp, lsl #6
     6d4:	012e1b00 			; <UNDEFINED> instruction: 0x012e1b00
     6d8:	0b3a1347 	bleq	e853fc <_bss_end+0xe7a974>
     6dc:	0b390b3b 	bleq	e433d0 <_bss_end+0xe38948>
     6e0:	01111364 	tsteq	r1, r4, ror #6
     6e4:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
     6e8:	01194296 			; <UNDEFINED> instruction: 0x01194296
     6ec:	1c000013 	stcne	0, cr0, [r0], {19}
     6f0:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
     6f4:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
     6f8:	00001802 	andeq	r1, r0, r2, lsl #16
     6fc:	0300341d 	movweq	r3, #1053	; 0x41d
     700:	3b0b3a08 	blcc	2cef28 <_bss_end+0x2c44a0>
     704:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     708:	00180213 	andseq	r0, r8, r3, lsl r2
     70c:	010b1e00 	tsteq	fp, r0, lsl #28
     710:	06120111 			; <UNDEFINED> instruction: 0x06120111
     714:	051f0000 	ldreq	r0, [pc, #-0]	; 71c <CPSR_IRQ_INHIBIT+0x69c>
     718:	3a080300 	bcc	201320 <_bss_end+0x1f6898>
     71c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     720:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
     724:	20000018 	andcs	r0, r0, r8, lsl r0
     728:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
     72c:	0b3b0b3a 	bleq	ec341c <_bss_end+0xeb8994>
     730:	13490b39 	movtne	r0, #39737	; 0x9b39
     734:	1802196c 	stmdane	r2, {r2, r3, r5, r6, r8, fp, ip}
     738:	34210000 	strtcc	r0, [r1], #-0
     73c:	3a0e0300 	bcc	381344 <_bss_end+0x3768bc>
     740:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     744:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
     748:	22000018 	andcs	r0, r0, #24
     74c:	13490101 	movtne	r0, #37121	; 0x9101
     750:	00001301 	andeq	r1, r0, r1, lsl #6
     754:	49002123 	stmdbmi	r0, {r0, r1, r5, r8, sp}
     758:	000b2f13 	andeq	r2, fp, r3, lsl pc
     75c:	012e2400 			; <UNDEFINED> instruction: 0x012e2400
     760:	0b3a1347 	bleq	e85484 <_bss_end+0xe7a9fc>
     764:	0b390b3b 	bleq	e43458 <_bss_end+0xe389d0>
     768:	01111364 	tsteq	r1, r4, ror #6
     76c:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
     770:	01194297 			; <UNDEFINED> instruction: 0x01194297
     774:	25000013 	strcs	r0, [r0, #-19]	; 0xffffffed
     778:	0111010b 	tsteq	r1, fp, lsl #2
     77c:	13010612 	movwne	r0, #5650	; 0x1612
     780:	2e260000 	cdpcs	0, 2, cr0, cr6, cr0, {0}
     784:	3a134701 	bcc	4d2390 <_bss_end+0x4c7908>
     788:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     78c:	2013640b 	andscs	r6, r3, fp, lsl #8
     790:	0013010b 	andseq	r0, r3, fp, lsl #2
     794:	00052700 	andeq	r2, r5, r0, lsl #14
     798:	13490e03 	movtne	r0, #40451	; 0x9e03
     79c:	00001934 	andeq	r1, r0, r4, lsr r9
     7a0:	03000528 	movweq	r0, #1320	; 0x528
     7a4:	3b0b3a0e 	blcc	2cefe4 <_bss_end+0x2c455c>
     7a8:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     7ac:	29000013 	stmdbcs	r0, {r0, r1, r4}
     7b0:	1331012e 	teqne	r1, #-2147483637	; 0x8000000b
     7b4:	13640e6e 	cmnne	r4, #1760	; 0x6e0
     7b8:	06120111 			; <UNDEFINED> instruction: 0x06120111
     7bc:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
     7c0:	2a000019 	bcs	82c <CPSR_IRQ_INHIBIT+0x7ac>
     7c4:	13310005 	teqne	r1, #5
     7c8:	00001802 	andeq	r1, r0, r2, lsl #16
     7cc:	01110100 	tsteq	r1, r0, lsl #2
     7d0:	0b130e25 	bleq	4c406c <_bss_end+0x4b95e4>
     7d4:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
     7d8:	06120111 			; <UNDEFINED> instruction: 0x06120111
     7dc:	00001710 	andeq	r1, r0, r0, lsl r7
     7e0:	0b002402 	bleq	97f0 <_Z13Guessing_Gamec+0x64>
     7e4:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
     7e8:	0300000e 	movweq	r0, #14
     7ec:	13490026 	movtne	r0, #36902	; 0x9026
     7f0:	24040000 	strcs	r0, [r4], #-0
     7f4:	3e0b0b00 	vmlacc.f64	d0, d11, d0
     7f8:	0008030b 	andeq	r0, r8, fp, lsl #6
     7fc:	00160500 	andseq	r0, r6, r0, lsl #10
     800:	0b3a0e03 	bleq	e84014 <_bss_end+0xe7958c>
     804:	0b390b3b 	bleq	e434f8 <_bss_end+0xe38a70>
     808:	00001349 	andeq	r1, r0, r9, asr #6
     80c:	03013906 	movweq	r3, #6406	; 0x1906
     810:	3b0b3a08 	blcc	2cf038 <_bss_end+0x2c45b0>
     814:	010b390b 	tsteq	fp, fp, lsl #18
     818:	07000013 	smladeq	r0, r3, r0, r0
     81c:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
     820:	0b3b0b3a 	bleq	ec3510 <_bss_end+0xeb8a88>
     824:	13490b39 	movtne	r0, #39737	; 0x9b39
     828:	061c193c 			; <UNDEFINED> instruction: 0x061c193c
     82c:	0000196c 	andeq	r1, r0, ip, ror #18
     830:	03003408 	movweq	r3, #1032	; 0x408
     834:	3b0b3a0e 	blcc	2cf074 <_bss_end+0x2c45ec>
     838:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     83c:	1c193c13 	ldcne	12, cr3, [r9], {19}
     840:	00196c0b 	andseq	r6, r9, fp, lsl #24
     844:	01040900 	tsteq	r4, r0, lsl #18
     848:	196d0e03 	stmdbne	sp!, {r0, r1, r9, sl, fp}^
     84c:	0b0b0b3e 	bleq	2c354c <_bss_end+0x2b8ac4>
     850:	0b3a1349 	bleq	e8557c <_bss_end+0xe7aaf4>
     854:	0b390b3b 	bleq	e43548 <_bss_end+0xe38ac0>
     858:	00001301 	andeq	r1, r0, r1, lsl #6
     85c:	0300280a 	movweq	r2, #2058	; 0x80a
     860:	000b1c08 	andeq	r1, fp, r8, lsl #24
     864:	00280b00 	eoreq	r0, r8, r0, lsl #22
     868:	0b1c0e03 	bleq	70407c <_bss_end+0x6f95f4>
     86c:	340c0000 	strcc	r0, [ip], #-0
     870:	00134700 	andseq	r4, r3, r0, lsl #14
     874:	01020d00 	tsteq	r2, r0, lsl #26
     878:	0b0b0e03 	bleq	2c408c <_bss_end+0x2b9604>
     87c:	0b3b0b3a 	bleq	ec356c <_bss_end+0xeb8ae4>
     880:	13010b39 	movwne	r0, #6969	; 0x1b39
     884:	0d0e0000 	stceq	0, cr0, [lr, #-0]
     888:	3a0e0300 	bcc	381490 <_bss_end+0x376a08>
     88c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     890:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
     894:	0f00000b 	svceq	0x0000000b
     898:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
     89c:	0b3a0e03 	bleq	e840b0 <_bss_end+0xe79628>
     8a0:	0b390b3b 	bleq	e43594 <_bss_end+0xe38b0c>
     8a4:	13490e6e 	movtne	r0, #40558	; 0x9e6e
     8a8:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
     8ac:	13011364 	movwne	r1, #4964	; 0x1364
     8b0:	05100000 	ldreq	r0, [r0, #-0]
     8b4:	34134900 	ldrcc	r4, [r3], #-2304	; 0xfffff700
     8b8:	11000019 	tstne	r0, r9, lsl r0
     8bc:	13490005 	movtne	r0, #36869	; 0x9005
     8c0:	2e120000 	cdpcs	0, 1, cr0, cr2, cr0, {0}
     8c4:	03193f01 	tsteq	r9, #1, 30
     8c8:	3b0b3a0e 	blcc	2cf108 <_bss_end+0x2c4680>
     8cc:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     8d0:	3c0b320e 	sfmcc	f3, 4, [fp], {14}
     8d4:	01136419 	tsteq	r3, r9, lsl r4
     8d8:	13000013 	movwne	r0, #19
     8dc:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
     8e0:	0b3a0e03 	bleq	e840f4 <_bss_end+0xe7966c>
     8e4:	0b390b3b 	bleq	e435d8 <_bss_end+0xe38b50>
     8e8:	13490e6e 	movtne	r0, #40558	; 0x9e6e
     8ec:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
     8f0:	00001364 	andeq	r1, r0, r4, ror #6
     8f4:	0b000f14 	bleq	454c <CPSR_IRQ_INHIBIT+0x44cc>
     8f8:	0013490b 	andseq	r4, r3, fp, lsl #18
     8fc:	00341500 	eorseq	r1, r4, r0, lsl #10
     900:	0b3a0e03 	bleq	e84114 <_bss_end+0xe7968c>
     904:	0b390b3b 	bleq	e435f8 <_bss_end+0xe38b70>
     908:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
     90c:	0000193c 	andeq	r1, r0, ip, lsr r9
     910:	03002816 	movweq	r2, #2070	; 0x816
     914:	00051c0e 	andeq	r1, r5, lr, lsl #24
     918:	00281700 	eoreq	r1, r8, r0, lsl #14
     91c:	061c0e03 	ldreq	r0, [ip], -r3, lsl #28
     920:	2e180000 	cdpcs	0, 1, cr0, cr8, cr0, {0}
     924:	03193f01 	tsteq	r9, #1, 30
     928:	3b0b3a0e 	blcc	2cf168 <_bss_end+0x2c46e0>
     92c:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     930:	3c0b320e 	sfmcc	f3, 4, [fp], {14}
     934:	00136419 	andseq	r6, r3, r9, lsl r4
     938:	00101900 	andseq	r1, r0, r0, lsl #18
     93c:	13490b0b 	movtne	r0, #39691	; 0x9b0b
     940:	341a0000 	ldrcc	r0, [sl], #-0
     944:	3a134700 	bcc	4d254c <_bss_end+0x4c7ac4>
     948:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     94c:	0018020b 	andseq	r0, r8, fp, lsl #4
     950:	002e1b00 	eoreq	r1, lr, r0, lsl #22
     954:	19340e03 	ldmdbne	r4!, {r0, r1, r9, sl, fp}
     958:	06120111 			; <UNDEFINED> instruction: 0x06120111
     95c:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
     960:	1c000019 	stcne	0, cr0, [r0], {25}
     964:	0e03012e 	adfeqsp	f0, f3, #0.5
     968:	01111934 	tsteq	r1, r4, lsr r9
     96c:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
     970:	01194296 			; <UNDEFINED> instruction: 0x01194296
     974:	1d000013 	stcne	0, cr0, [r0, #-76]	; 0xffffffb4
     978:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
     97c:	0b3b0b3a 	bleq	ec366c <_bss_end+0xeb8be4>
     980:	13490b39 	movtne	r0, #39737	; 0x9b39
     984:	00001802 	andeq	r1, r0, r2, lsl #16
     988:	47012e1e 	smladmi	r1, lr, lr, r2
     98c:	3b0b3a13 	blcc	2cf1e0 <_bss_end+0x2c4758>
     990:	640b390b 	strvs	r3, [fp], #-2315	; 0xfffff6f5
     994:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
     998:	96184006 	ldrls	r4, [r8], -r6
     99c:	13011942 	movwne	r1, #6466	; 0x1942
     9a0:	051f0000 	ldreq	r0, [pc, #-0]	; 9a8 <CPSR_IRQ_INHIBIT+0x928>
     9a4:	490e0300 	stmdbmi	lr, {r8, r9}
     9a8:	02193413 	andseq	r3, r9, #318767104	; 0x13000000
     9ac:	20000018 	andcs	r0, r0, r8, lsl r0
     9b0:	08030005 	stmdaeq	r3, {r0, r2}
     9b4:	0b3b0b3a 	bleq	ec36a4 <_bss_end+0xeb8c1c>
     9b8:	13490b39 	movtne	r0, #39737	; 0x9b39
     9bc:	00001802 	andeq	r1, r0, r2, lsl #16
     9c0:	03003421 	movweq	r3, #1057	; 0x421
     9c4:	3b0b3a08 	blcc	2cf1ec <_bss_end+0x2c4764>
     9c8:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     9cc:	00180213 	andseq	r0, r8, r3, lsl r2
     9d0:	01012200 	mrseq	r2, R9_usr
     9d4:	13011349 	movwne	r1, #4937	; 0x1349
     9d8:	21230000 			; <UNDEFINED> instruction: 0x21230000
     9dc:	2f134900 	svccs	0x00134900
     9e0:	2400000b 	strcs	r0, [r0], #-11
     9e4:	1347012e 	movtne	r0, #28974	; 0x712e
     9e8:	0b390b3a 	bleq	e436d8 <_bss_end+0xe38c50>
     9ec:	01111364 	tsteq	r1, r4, ror #6
     9f0:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
     9f4:	01194296 			; <UNDEFINED> instruction: 0x01194296
     9f8:	25000013 	strcs	r0, [r0, #-19]	; 0xffffffed
     9fc:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
     a00:	0b3b0b3a 	bleq	ec36f0 <_bss_end+0xeb8c68>
     a04:	13490b39 	movtne	r0, #39737	; 0x9b39
     a08:	1802196c 	stmdane	r2, {r2, r3, r5, r6, r8, fp, ip}
     a0c:	2e260000 	cdpcs	0, 2, cr0, cr6, cr0, {0}
     a10:	3a134701 	bcc	4d261c <_bss_end+0x4c7b94>
     a14:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     a18:	2013640b 	andscs	r6, r3, fp, lsl #8
     a1c:	0013010b 	andseq	r0, r3, fp, lsl #2
     a20:	00052700 	andeq	r2, r5, r0, lsl #14
     a24:	13490e03 	movtne	r0, #40451	; 0x9e03
     a28:	00001934 	andeq	r1, r0, r4, lsr r9
     a2c:	03000528 	movweq	r0, #1320	; 0x528
     a30:	3b0b3a08 	blcc	2cf258 <_bss_end+0x2c47d0>
     a34:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     a38:	29000013 	stmdbcs	r0, {r0, r1, r4}
     a3c:	1331012e 	teqne	r1, #-2147483637	; 0x8000000b
     a40:	13640e6e 	cmnne	r4, #1760	; 0x6e0
     a44:	06120111 			; <UNDEFINED> instruction: 0x06120111
     a48:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
     a4c:	2a000019 	bcs	ab8 <CPSR_IRQ_INHIBIT+0xa38>
     a50:	13310005 	teqne	r1, #5
     a54:	00001802 	andeq	r1, r0, r2, lsl #16
     a58:	01110100 	tsteq	r1, r0, lsl #2
     a5c:	0b130e25 	bleq	4c42f8 <_bss_end+0x4b9870>
     a60:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
     a64:	06120111 			; <UNDEFINED> instruction: 0x06120111
     a68:	00001710 	andeq	r1, r0, r0, lsl r7
     a6c:	0b002402 	bleq	9a7c <_Z13Guessing_Gamec+0x2f0>
     a70:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
     a74:	0300000e 	movweq	r0, #14
     a78:	13490026 	movtne	r0, #36902	; 0x9026
     a7c:	24040000 	strcs	r0, [r4], #-0
     a80:	3e0b0b00 	vmlacc.f64	d0, d11, d0
     a84:	0008030b 	andeq	r0, r8, fp, lsl #6
     a88:	00350500 	eorseq	r0, r5, r0, lsl #10
     a8c:	00001349 	andeq	r1, r0, r9, asr #6
     a90:	03001606 	movweq	r1, #1542	; 0x606
     a94:	3b0b3a0e 	blcc	2cf2d4 <_bss_end+0x2c484c>
     a98:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     a9c:	07000013 	smladeq	r0, r3, r0, r0
     aa0:	08030139 	stmdaeq	r3, {r0, r3, r4, r5, r8}
     aa4:	0b3b0b3a 	bleq	ec3794 <_bss_end+0xeb8d0c>
     aa8:	13010b39 	movwne	r0, #6969	; 0x1b39
     aac:	34080000 	strcc	r0, [r8], #-0
     ab0:	3a0e0300 	bcc	3816b8 <_bss_end+0x376c30>
     ab4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     ab8:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
     abc:	6c061c19 	stcvs	12, cr1, [r6], {25}
     ac0:	09000019 	stmdbeq	r0, {r0, r3, r4}
     ac4:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
     ac8:	0b3b0b3a 	bleq	ec37b8 <_bss_end+0xeb8d30>
     acc:	13490b39 	movtne	r0, #39737	; 0x9b39
     ad0:	0b1c193c 	bleq	706fc8 <_bss_end+0x6fc540>
     ad4:	0000196c 	andeq	r1, r0, ip, ror #18
     ad8:	0301040a 	movweq	r0, #5130	; 0x140a
     adc:	3e196d0e 	cdpcc	13, 1, cr6, cr9, cr14, {0}
     ae0:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
     ae4:	3b0b3a13 	blcc	2cf338 <_bss_end+0x2c48b0>
     ae8:	010b390b 	tsteq	fp, fp, lsl #18
     aec:	0b000013 	bleq	b40 <CPSR_IRQ_INHIBIT+0xac0>
     af0:	08030028 	stmdaeq	r3, {r3, r5}
     af4:	00000b1c 	andeq	r0, r0, ip, lsl fp
     af8:	0300280c 	movweq	r2, #2060	; 0x80c
     afc:	000b1c0e 	andeq	r1, fp, lr, lsl #24
     b00:	00340d00 	eorseq	r0, r4, r0, lsl #26
     b04:	00001347 	andeq	r1, r0, r7, asr #6
     b08:	0b000f0e 	bleq	4748 <CPSR_IRQ_INHIBIT+0x46c8>
     b0c:	0013490b 	andseq	r4, r3, fp, lsl #18
     b10:	01020f00 	tsteq	r2, r0, lsl #30
     b14:	0b0b0e03 	bleq	2c4328 <_bss_end+0x2b98a0>
     b18:	0b3b0b3a 	bleq	ec3808 <_bss_end+0xeb8d80>
     b1c:	13010b39 	movwne	r0, #6969	; 0x1b39
     b20:	0d100000 	ldceq	0, cr0, [r0, #-0]
     b24:	3a0e0300 	bcc	38172c <_bss_end+0x376ca4>
     b28:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     b2c:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
     b30:	1100000b 	tstne	r0, fp
     b34:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
     b38:	0b3a0e03 	bleq	e8434c <_bss_end+0xe798c4>
     b3c:	0b390b3b 	bleq	e43830 <_bss_end+0xe38da8>
     b40:	13490e6e 	movtne	r0, #40558	; 0x9e6e
     b44:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
     b48:	13011364 	movwne	r1, #4964	; 0x1364
     b4c:	05120000 	ldreq	r0, [r2, #-0]
     b50:	34134900 	ldrcc	r4, [r3], #-2304	; 0xfffff700
     b54:	13000019 	movwne	r0, #25
     b58:	13490005 	movtne	r0, #36869	; 0x9005
     b5c:	2e140000 	cdpcs	0, 1, cr0, cr4, cr0, {0}
     b60:	03193f01 	tsteq	r9, #1, 30
     b64:	3b0b3a0e 	blcc	2cf3a4 <_bss_end+0x2c491c>
     b68:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     b6c:	3c0b320e 	sfmcc	f3, 4, [fp], {14}
     b70:	01136419 	tsteq	r3, r9, lsl r4
     b74:	15000013 	strne	r0, [r0, #-19]	; 0xffffffed
     b78:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
     b7c:	0b3a0e03 	bleq	e84390 <_bss_end+0xe79908>
     b80:	0b390b3b 	bleq	e43874 <_bss_end+0xe38dec>
     b84:	13490e6e 	movtne	r0, #40558	; 0x9e6e
     b88:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
     b8c:	00001364 	andeq	r1, r0, r4, ror #6
     b90:	03002816 	movweq	r2, #2070	; 0x816
     b94:	00051c0e 	andeq	r1, r5, lr, lsl #24
     b98:	00281700 	eoreq	r1, r8, r0, lsl #14
     b9c:	061c0e03 	ldreq	r0, [ip], -r3, lsl #28
     ba0:	2e180000 	cdpcs	0, 1, cr0, cr8, cr0, {0}
     ba4:	03193f01 	tsteq	r9, #1, 30
     ba8:	3b0b3a0e 	blcc	2cf3e8 <_bss_end+0x2c4960>
     bac:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     bb0:	3c0b320e 	sfmcc	f3, 4, [fp], {14}
     bb4:	00136419 	andseq	r6, r3, r9, lsl r4
     bb8:	00101900 	andseq	r1, r0, r0, lsl #18
     bbc:	13490b0b 	movtne	r0, #39691	; 0x9b0b
     bc0:	341a0000 	ldrcc	r0, [sl], #-0
     bc4:	3a0e0300 	bcc	3817cc <_bss_end+0x376d44>
     bc8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     bcc:	3f13490b 	svccc	0x0013490b
     bd0:	00193c19 	andseq	r3, r9, r9, lsl ip
     bd4:	00341b00 	eorseq	r1, r4, r0, lsl #22
     bd8:	0b3a0e03 	bleq	e843ec <_bss_end+0xe79964>
     bdc:	0b390b3b 	bleq	e438d0 <_bss_end+0xe38e48>
     be0:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
     be4:	00001802 	andeq	r1, r0, r2, lsl #16
     be8:	4700341c 	smladmi	r0, ip, r4, r3
     bec:	3b0b3a13 	blcc	2cf440 <_bss_end+0x2c49b8>
     bf0:	020b390b 	andeq	r3, fp, #180224	; 0x2c000
     bf4:	1d000018 	stcne	0, cr0, [r0, #-96]	; 0xffffffa0
     bf8:	0e03002e 	cdpeq	0, 0, cr0, cr3, cr14, {1}
     bfc:	01111934 	tsteq	r1, r4, lsr r9
     c00:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
     c04:	00194296 	mulseq	r9, r6, r2
     c08:	012e1e00 			; <UNDEFINED> instruction: 0x012e1e00
     c0c:	19340e03 	ldmdbne	r4!, {r0, r1, r9, sl, fp}
     c10:	06120111 			; <UNDEFINED> instruction: 0x06120111
     c14:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
     c18:	00130119 	andseq	r0, r3, r9, lsl r1
     c1c:	00051f00 	andeq	r1, r5, r0, lsl #30
     c20:	0b3a0e03 	bleq	e84434 <_bss_end+0xe799ac>
     c24:	0b390b3b 	bleq	e43918 <_bss_end+0xe38e90>
     c28:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
     c2c:	2e200000 	cdpcs	0, 2, cr0, cr0, cr0, {0}
     c30:	3a134701 	bcc	4d283c <_bss_end+0x4c7db4>
     c34:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     c38:	1113640b 	tstne	r3, fp, lsl #8
     c3c:	40061201 	andmi	r1, r6, r1, lsl #4
     c40:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
     c44:	00001301 	andeq	r1, r0, r1, lsl #6
     c48:	03000521 	movweq	r0, #1313	; 0x521
     c4c:	3413490e 	ldrcc	r4, [r3], #-2318	; 0xfffff6f2
     c50:	00180219 	andseq	r0, r8, r9, lsl r2
     c54:	00342200 	eorseq	r2, r4, r0, lsl #4
     c58:	0b3a0e03 	bleq	e8446c <_bss_end+0xe799e4>
     c5c:	0b390b3b 	bleq	e43950 <_bss_end+0xe38ec8>
     c60:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
     c64:	2e230000 	cdpcs	0, 2, cr0, cr3, cr0, {0}
     c68:	3a134701 	bcc	4d2874 <_bss_end+0x4c7dec>
     c6c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     c70:	1113640b 	tstne	r3, fp, lsl #8
     c74:	40061201 	andmi	r1, r6, r1, lsl #4
     c78:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
     c7c:	00001301 	andeq	r1, r0, r1, lsl #6
     c80:	03000524 	movweq	r0, #1316	; 0x524
     c84:	3b0b3a08 	blcc	2cf4ac <_bss_end+0x2c4a24>
     c88:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     c8c:	00180213 	andseq	r0, r8, r3, lsl r2
     c90:	012e2500 			; <UNDEFINED> instruction: 0x012e2500
     c94:	0b3a1347 	bleq	e859b8 <_bss_end+0xe7af30>
     c98:	0b390b3b 	bleq	e4398c <_bss_end+0xe38f04>
     c9c:	0b201364 	bleq	805a34 <_bss_end+0x7fafac>
     ca0:	00001301 	andeq	r1, r0, r1, lsl #6
     ca4:	03000526 	movweq	r0, #1318	; 0x526
     ca8:	3413490e 	ldrcc	r4, [r3], #-2318	; 0xfffff6f2
     cac:	27000019 	smladcs	r0, r9, r0, r0
     cb0:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
     cb4:	0b3b0b3a 	bleq	ec39a4 <_bss_end+0xeb8f1c>
     cb8:	13490b39 	movtne	r0, #39737	; 0x9b39
     cbc:	2e280000 	cdpcs	0, 2, cr0, cr8, cr0, {0}
     cc0:	6e133101 	mufvss	f3, f3, f1
     cc4:	1113640e 	tstne	r3, lr, lsl #8
     cc8:	40061201 	andmi	r1, r6, r1, lsl #4
     ccc:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
     cd0:	00001301 	andeq	r1, r0, r1, lsl #6
     cd4:	31000529 	tstcc	r0, r9, lsr #10
     cd8:	00180213 	andseq	r0, r8, r3, lsl r2
     cdc:	002e2a00 	eoreq	r2, lr, r0, lsl #20
     ce0:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     ce4:	0b3b0b3a 	bleq	ec39d4 <_bss_end+0xeb8f4c>
     ce8:	01110b39 	tsteq	r1, r9, lsr fp
     cec:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
     cf0:	00194297 	mulseq	r9, r7, r2
     cf4:	012e2b00 			; <UNDEFINED> instruction: 0x012e2b00
     cf8:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     cfc:	0b3b0b3a 	bleq	ec39ec <_bss_end+0xeb8f64>
     d00:	01110b39 	tsteq	r1, r9, lsr fp
     d04:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
     d08:	01194296 			; <UNDEFINED> instruction: 0x01194296
     d0c:	2c000013 	stccs	0, cr0, [r0], {19}
     d10:	08030034 	stmdaeq	r3, {r2, r4, r5}
     d14:	0b3b0b3a 	bleq	ec3a04 <_bss_end+0xeb8f7c>
     d18:	13490b39 	movtne	r0, #39737	; 0x9b39
     d1c:	00001802 	andeq	r1, r0, r2, lsl #16
     d20:	3f012e2d 	svccc	0x00012e2d
     d24:	3a0e0319 	bcc	381990 <_bss_end+0x376f08>
     d28:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     d2c:	110e6e0b 	tstne	lr, fp, lsl #28
     d30:	40061201 	andmi	r1, r6, r1, lsl #4
     d34:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
     d38:	01000000 	mrseq	r0, (UNDEF: 0)
     d3c:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
     d40:	0e030b13 	vmoveq.32	d3[0], r0
     d44:	01110e1b 	tsteq	r1, fp, lsl lr
     d48:	17100612 			; <UNDEFINED> instruction: 0x17100612
     d4c:	24020000 	strcs	r0, [r2], #-0
     d50:	3e0b0b00 	vmlacc.f64	d0, d11, d0
     d54:	000e030b 	andeq	r0, lr, fp, lsl #6
     d58:	00260300 	eoreq	r0, r6, r0, lsl #6
     d5c:	00001349 	andeq	r1, r0, r9, asr #6
     d60:	0b002404 	bleq	9d78 <_kernel_main+0x20>
     d64:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
     d68:	05000008 	streq	r0, [r0, #-8]
     d6c:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
     d70:	0b3b0b3a 	bleq	ec3a60 <_bss_end+0xeb8fd8>
     d74:	13490b39 	movtne	r0, #39737	; 0x9b39
     d78:	35060000 	strcc	r0, [r6, #-0]
     d7c:	00134900 	andseq	r4, r3, r0, lsl #18
     d80:	000f0700 	andeq	r0, pc, r0, lsl #14
     d84:	13490b0b 	movtne	r0, #39691	; 0x9b0b
     d88:	39080000 	stmdbcc	r8, {}	; <UNPREDICTABLE>
     d8c:	3a080301 	bcc	201998 <_bss_end+0x1f6f10>
     d90:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     d94:	0013010b 	andseq	r0, r3, fp, lsl #2
     d98:	00340900 	eorseq	r0, r4, r0, lsl #18
     d9c:	0b3a0e03 	bleq	e845b0 <_bss_end+0xe79b28>
     da0:	0b390b3b 	bleq	e43a94 <_bss_end+0xe3900c>
     da4:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
     da8:	196c061c 	stmdbne	ip!, {r2, r3, r4, r9, sl}^
     dac:	340a0000 	strcc	r0, [sl], #-0
     db0:	3a0e0300 	bcc	3819b8 <_bss_end+0x376f30>
     db4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     db8:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
     dbc:	6c0b1c19 	stcvs	12, cr1, [fp], {25}
     dc0:	0b000019 	bleq	e2c <CPSR_IRQ_INHIBIT+0xdac>
     dc4:	0e030104 	adfeqs	f0, f3, f4
     dc8:	0b3e196d 	bleq	f87384 <_bss_end+0xf7c8fc>
     dcc:	13490b0b 	movtne	r0, #39691	; 0x9b0b
     dd0:	0b3b0b3a 	bleq	ec3ac0 <_bss_end+0xeb9038>
     dd4:	13010b39 	movwne	r0, #6969	; 0x1b39
     dd8:	280c0000 	stmdacs	ip, {}	; <UNPREDICTABLE>
     ddc:	1c080300 	stcne	3, cr0, [r8], {-0}
     de0:	0d00000b 	stceq	0, cr0, [r0, #-44]	; 0xffffffd4
     de4:	0e030028 	cdpeq	0, 0, cr0, cr3, cr8, {1}
     de8:	00000b1c 	andeq	r0, r0, ip, lsl fp
     dec:	4700340e 	strmi	r3, [r0, -lr, lsl #8]
     df0:	0f000013 	svceq	0x00000013
     df4:	0e030102 	adfeqs	f0, f3, f2
     df8:	0b3a0b0b 	bleq	e83a2c <_bss_end+0xe78fa4>
     dfc:	0b390b3b 	bleq	e43af0 <_bss_end+0xe39068>
     e00:	00001301 	andeq	r1, r0, r1, lsl #6
     e04:	03000d10 	movweq	r0, #3344	; 0xd10
     e08:	3b0b3a0e 	blcc	2cf648 <_bss_end+0x2c4bc0>
     e0c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     e10:	000b3813 	andeq	r3, fp, r3, lsl r8
     e14:	012e1100 			; <UNDEFINED> instruction: 0x012e1100
     e18:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     e1c:	0b3b0b3a 	bleq	ec3b0c <_bss_end+0xeb9084>
     e20:	0e6e0b39 	vmoveq.8	d14[5], r0
     e24:	0b321349 	bleq	c85b50 <_bss_end+0xc7b0c8>
     e28:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
     e2c:	00001301 	andeq	r1, r0, r1, lsl #6
     e30:	49000512 	stmdbmi	r0, {r1, r4, r8, sl}
     e34:	00193413 	andseq	r3, r9, r3, lsl r4
     e38:	00051300 	andeq	r1, r5, r0, lsl #6
     e3c:	00001349 	andeq	r1, r0, r9, asr #6
     e40:	3f012e14 	svccc	0x00012e14
     e44:	3a0e0319 	bcc	381ab0 <_bss_end+0x377028>
     e48:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     e4c:	320e6e0b 	andcc	r6, lr, #11, 28	; 0xb0
     e50:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
     e54:	00130113 	andseq	r0, r3, r3, lsl r1
     e58:	012e1500 			; <UNDEFINED> instruction: 0x012e1500
     e5c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     e60:	0b3b0b3a 	bleq	ec3b50 <_bss_end+0xeb90c8>
     e64:	0e6e0b39 	vmoveq.8	d14[5], r0
     e68:	0b321349 	bleq	c85b94 <_bss_end+0xc7b10c>
     e6c:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
     e70:	28160000 	ldmdacs	r6, {}	; <UNPREDICTABLE>
     e74:	1c0e0300 	stcne	3, cr0, [lr], {-0}
     e78:	17000005 	strne	r0, [r0, -r5]
     e7c:	0e030028 	cdpeq	0, 0, cr0, cr3, cr8, {1}
     e80:	0000061c 	andeq	r0, r0, ip, lsl r6
     e84:	3f012e18 	svccc	0x00012e18
     e88:	3a0e0319 	bcc	381af4 <_bss_end+0x37706c>
     e8c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     e90:	320e6e0b 	andcc	r6, lr, #11, 28	; 0xb0
     e94:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
     e98:	19000013 	stmdbne	r0, {r0, r1, r4}
     e9c:	0b0b0010 	bleq	2c0ee4 <_bss_end+0x2b645c>
     ea0:	00001349 	andeq	r1, r0, r9, asr #6
     ea4:	0300341a 	movweq	r3, #1050	; 0x41a
     ea8:	3b0b3a0e 	blcc	2cf6e8 <_bss_end+0x2c4c60>
     eac:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     eb0:	3c193f13 	ldccc	15, cr3, [r9], {19}
     eb4:	1b000019 	blne	f20 <CPSR_IRQ_INHIBIT+0xea0>
     eb8:	193f002e 	ldmdbne	pc!, {r1, r2, r3, r5}	; <UNPREDICTABLE>
     ebc:	0b3a0e03 	bleq	e846d0 <_bss_end+0xe79c48>
     ec0:	0b390b3b 	bleq	e43bb4 <_bss_end+0xe3912c>
     ec4:	01111349 	tsteq	r1, r9, asr #6
     ec8:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
     ecc:	00194296 	mulseq	r9, r6, r2
     ed0:	11010000 	mrsne	r0, (UNDEF: 1)
     ed4:	55061000 	strpl	r1, [r6, #-0]
     ed8:	1b0e0306 	blne	381af8 <_bss_end+0x377070>
     edc:	130e250e 	movwne	r2, #58638	; 0xe50e
     ee0:	00000005 	andeq	r0, r0, r5
     ee4:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
     ee8:	030b130e 	movweq	r1, #45838	; 0xb30e
     eec:	110e1b0e 	tstne	lr, lr, lsl #22
     ef0:	10061201 	andne	r1, r6, r1, lsl #4
     ef4:	02000017 	andeq	r0, r0, #23
     ef8:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
     efc:	0b3b0b3a 	bleq	ec3bec <_bss_end+0xeb9164>
     f00:	13490b39 	movtne	r0, #39737	; 0x9b39
     f04:	0f030000 	svceq	0x00030000
     f08:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
     f0c:	04000013 	streq	r0, [r0], #-19	; 0xffffffed
     f10:	00000015 	andeq	r0, r0, r5, lsl r0
     f14:	03003405 	movweq	r3, #1029	; 0x405
     f18:	3b0b3a0e 	blcc	2cf758 <_bss_end+0x2c4cd0>
     f1c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     f20:	3c193f13 	ldccc	15, cr3, [r9], {19}
     f24:	06000019 			; <UNDEFINED> instruction: 0x06000019
     f28:	0b0b0024 	bleq	2c0fc0 <_bss_end+0x2b6538>
     f2c:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
     f30:	01070000 	mrseq	r0, (UNDEF: 7)
     f34:	01134901 	tsteq	r3, r1, lsl #18
     f38:	08000013 	stmdaeq	r0, {r0, r1, r4}
     f3c:	13490021 	movtne	r0, #36897	; 0x9021
     f40:	0000062f 	andeq	r0, r0, pc, lsr #12
     f44:	0b002409 	bleq	9f70 <_Z4itoajPcj+0x68>
     f48:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
     f4c:	0a00000e 	beq	f8c <CPSR_IRQ_INHIBIT+0xf0c>
     f50:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
     f54:	0b3a0e03 	bleq	e84768 <_bss_end+0xe79ce0>
     f58:	0b390b3b 	bleq	e43c4c <_bss_end+0xe391c4>
     f5c:	01111349 	tsteq	r1, r9, asr #6
     f60:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
     f64:	01194296 			; <UNDEFINED> instruction: 0x01194296
     f68:	0b000013 	bleq	fbc <CPSR_IRQ_INHIBIT+0xf3c>
     f6c:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
     f70:	0b3b0b3a 	bleq	ec3c60 <_bss_end+0xeb91d8>
     f74:	13490b39 	movtne	r0, #39737	; 0x9b39
     f78:	00001802 	andeq	r1, r0, r2, lsl #16
     f7c:	3f012e0c 	svccc	0x00012e0c
     f80:	3a0e0319 	bcc	381bec <_bss_end+0x377164>
     f84:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     f88:	1113490b 	tstne	r3, fp, lsl #18
     f8c:	40061201 	andmi	r1, r6, r1, lsl #4
     f90:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
     f94:	00001301 	andeq	r1, r0, r1, lsl #6
     f98:	0300340d 	movweq	r3, #1037	; 0x40d
     f9c:	3b0b3a08 	blcc	2cf7c4 <_bss_end+0x2c4d3c>
     fa0:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     fa4:	00180213 	andseq	r0, r8, r3, lsl r2
     fa8:	11010000 	mrsne	r0, (UNDEF: 1)
     fac:	130e2501 	movwne	r2, #58625	; 0xe501
     fb0:	1b0e030b 	blne	381be4 <_bss_end+0x37715c>
     fb4:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
     fb8:	00171006 	andseq	r1, r7, r6
     fbc:	01390200 	teqeq	r9, r0, lsl #4
     fc0:	00001301 	andeq	r1, r0, r1, lsl #6
     fc4:	03003403 	movweq	r3, #1027	; 0x403
     fc8:	3b0b3a0e 	blcc	2cf808 <_bss_end+0x2c4d80>
     fcc:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     fd0:	1c193c13 	ldcne	12, cr3, [r9], {19}
     fd4:	0400000a 	streq	r0, [r0], #-10
     fd8:	0b3a003a 	bleq	e810c8 <_bss_end+0xe76640>
     fdc:	0b390b3b 	bleq	e43cd0 <_bss_end+0xe39248>
     fe0:	00001318 	andeq	r1, r0, r8, lsl r3
     fe4:	49010105 	stmdbmi	r1, {r0, r2, r8}
     fe8:	00130113 	andseq	r0, r3, r3, lsl r1
     fec:	00210600 	eoreq	r0, r1, r0, lsl #12
     ff0:	0b2f1349 	bleq	bc5d1c <_bss_end+0xbbb294>
     ff4:	26070000 	strcs	r0, [r7], -r0
     ff8:	00134900 	andseq	r4, r3, r0, lsl #18
     ffc:	00240800 	eoreq	r0, r4, r0, lsl #16
    1000:	0b3e0b0b 	bleq	f83c34 <_bss_end+0xf791ac>
    1004:	00000e03 	andeq	r0, r0, r3, lsl #28
    1008:	47003409 	strmi	r3, [r0, -r9, lsl #8]
    100c:	0a000013 	beq	1060 <CPSR_IRQ_INHIBIT+0xfe0>
    1010:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
    1014:	0b3a0e03 	bleq	e84828 <_bss_end+0xe79da0>
    1018:	0b390b3b 	bleq	e43d0c <_bss_end+0xe39284>
    101c:	01110e6e 	tsteq	r1, lr, ror #28
    1020:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
    1024:	01194297 			; <UNDEFINED> instruction: 0x01194297
    1028:	0b000013 	bleq	107c <CPSR_IRQ_INHIBIT+0xffc>
    102c:	08030005 	stmdaeq	r3, {r0, r2}
    1030:	0b3b0b3a 	bleq	ec3d20 <_bss_end+0xeb9298>
    1034:	13490b39 	movtne	r0, #39737	; 0x9b39
    1038:	00001802 	andeq	r1, r0, r2, lsl #16
    103c:	0300340c 	movweq	r3, #1036	; 0x40c
    1040:	3b0b3a0e 	blcc	2cf880 <_bss_end+0x2c4df8>
    1044:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
    1048:	00180213 	andseq	r0, r8, r3, lsl r2
    104c:	010b0d00 	tsteq	fp, r0, lsl #26
    1050:	06120111 			; <UNDEFINED> instruction: 0x06120111
    1054:	340e0000 	strcc	r0, [lr], #-0
    1058:	3a080300 	bcc	201c60 <_bss_end+0x1f71d8>
    105c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    1060:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
    1064:	0f000018 	svceq	0x00000018
    1068:	0b0b000f 	bleq	2c10ac <_bss_end+0x2b6624>
    106c:	00001349 	andeq	r1, r0, r9, asr #6
    1070:	00002610 	andeq	r2, r0, r0, lsl r6
    1074:	000f1100 	andeq	r1, pc, r0, lsl #2
    1078:	00000b0b 	andeq	r0, r0, fp, lsl #22
    107c:	0b002412 	bleq	a0cc <_Z4atoiPKc+0x50>
    1080:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
    1084:	13000008 	movwne	r0, #8
    1088:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
    108c:	0b3b0b3a 	bleq	ec3d7c <_bss_end+0xeb92f4>
    1090:	13490b39 	movtne	r0, #39737	; 0x9b39
    1094:	00001802 	andeq	r1, r0, r2, lsl #16
    1098:	3f012e14 	svccc	0x00012e14
    109c:	3a0e0319 	bcc	381d08 <_bss_end+0x377280>
    10a0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    10a4:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
    10a8:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
    10ac:	97184006 	ldrls	r4, [r8, -r6]
    10b0:	13011942 	movwne	r1, #6466	; 0x1942
    10b4:	2e150000 	cdpcs	0, 1, cr0, cr5, cr0, {0}
    10b8:	03193f01 	tsteq	r9, #1, 30
    10bc:	3b0b3a0e 	blcc	2cf8fc <_bss_end+0x2c4e74>
    10c0:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
    10c4:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
    10c8:	96184006 	ldrls	r4, [r8], -r6
    10cc:	00001942 	andeq	r1, r0, r2, asr #18
    10d0:	00110100 	andseq	r0, r1, r0, lsl #2
    10d4:	01110610 	tsteq	r1, r0, lsl r6
    10d8:	0e030112 	mcreq	1, 0, r0, cr3, cr2, {0}
    10dc:	0e250e1b 	mcreq	14, 1, r0, cr5, cr11, {0}
    10e0:	00000513 	andeq	r0, r0, r3, lsl r5
    10e4:	00110100 	andseq	r0, r1, r0, lsl #2
    10e8:	01110610 	tsteq	r1, r0, lsl r6
    10ec:	0e030112 	mcreq	1, 0, r0, cr3, cr2, {0}
    10f0:	0e250e1b 	mcreq	14, 1, r0, cr5, cr11, {0}
    10f4:	00000513 	andeq	r0, r0, r3, lsl r5
    10f8:	01110100 	tsteq	r1, r0, lsl #2
    10fc:	0b130e25 	bleq	4c4998 <_bss_end+0x4b9f10>
    1100:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
    1104:	00001710 	andeq	r1, r0, r0, lsl r7
    1108:	0b002402 	bleq	a118 <_Z7strncpyPcPKci>
    110c:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
    1110:	03000008 	movweq	r0, #8
    1114:	0b0b0024 	bleq	2c11ac <_bss_end+0x2b6724>
    1118:	0e030b3e 	vmoveq.16	d3[0], r0
    111c:	04040000 	streq	r0, [r4], #-0
    1120:	3e0e0301 	cdpcc	3, 0, cr0, cr14, cr1, {0}
    1124:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
    1128:	3b0b3a13 	blcc	2cf97c <_bss_end+0x2c4ef4>
    112c:	010b390b 	tsteq	fp, fp, lsl #18
    1130:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
    1134:	0e030028 	cdpeq	0, 0, cr0, cr3, cr8, {1}
    1138:	00000b1c 	andeq	r0, r0, ip, lsl fp
    113c:	03011306 	movweq	r1, #4870	; 0x1306
    1140:	3a0b0b0e 	bcc	2c3d80 <_bss_end+0x2b92f8>
    1144:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
    1148:	0013010b 	andseq	r0, r3, fp, lsl #2
    114c:	000d0700 	andeq	r0, sp, r0, lsl #14
    1150:	0b3a0e03 	bleq	e84964 <_bss_end+0xe79edc>
    1154:	0b39053b 	bleq	e42648 <_bss_end+0xe37bc0>
    1158:	0b381349 	bleq	e05e84 <_bss_end+0xdfb3fc>
    115c:	26080000 	strcs	r0, [r8], -r0
    1160:	00134900 	andseq	r4, r3, r0, lsl #18
    1164:	01010900 	tsteq	r1, r0, lsl #18
    1168:	13011349 	movwne	r1, #4937	; 0x1349
    116c:	210a0000 	mrscs	r0, (UNDEF: 10)
    1170:	2f134900 	svccs	0x00134900
    1174:	0b00000b 	bleq	11a8 <CPSR_IRQ_INHIBIT+0x1128>
    1178:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
    117c:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
    1180:	13490b39 	movtne	r0, #39737	; 0x9b39
    1184:	00000a1c 	andeq	r0, r0, ip, lsl sl
    1188:	2700150c 	strcs	r1, [r0, -ip, lsl #10]
    118c:	0d000019 	stceq	0, cr0, [r0, #-100]	; 0xffffff9c
    1190:	0b0b000f 	bleq	2c11d4 <_bss_end+0x2b674c>
    1194:	00001349 	andeq	r1, r0, r9, asr #6
    1198:	0301040e 	movweq	r0, #5134	; 0x140e
    119c:	0b0b3e0e 	bleq	2d09dc <_bss_end+0x2c5f54>
    11a0:	3a13490b 	bcc	4d35d4 <_bss_end+0x4c8b4c>
    11a4:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
    11a8:	0013010b 	andseq	r0, r3, fp, lsl #2
    11ac:	00160f00 	andseq	r0, r6, r0, lsl #30
    11b0:	0b3a0e03 	bleq	e849c4 <_bss_end+0xe79f3c>
    11b4:	0b390b3b 	bleq	e43ea8 <_bss_end+0xe39420>
    11b8:	00001349 	andeq	r1, r0, r9, asr #6
    11bc:	00002110 	andeq	r2, r0, r0, lsl r1
    11c0:	00341100 	eorseq	r1, r4, r0, lsl #2
    11c4:	0b3a0e03 	bleq	e849d8 <_bss_end+0xe79f50>
    11c8:	0b390b3b 	bleq	e43ebc <_bss_end+0xe39434>
    11cc:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
    11d0:	0000193c 	andeq	r1, r0, ip, lsr r9
    11d4:	47003412 	smladmi	r0, r2, r4, r3
    11d8:	3b0b3a13 	blcc	2cfa2c <_bss_end+0x2c4fa4>
    11dc:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
    11e0:	00180213 	andseq	r0, r8, r3, lsl r2
	...

Disassembly of section .debug_aranges:

00000000 <.debug_aranges>:
   0:	0000001c 	andeq	r0, r0, ip, lsl r0
   4:	00000002 	andeq	r0, r0, r2
   8:	00040000 	andeq	r0, r4, r0
   c:	00000000 	andeq	r0, r0, r0
  10:	00008094 	muleq	r0, r4, r0
  14:	000000d8 	ldrdeq	r0, [r0], -r8
	...
  20:	0000001c 	andeq	r0, r0, ip, lsl r0
  24:	012a0002 			; <UNDEFINED> instruction: 0x012a0002
  28:	00040000 	andeq	r0, r4, r0
  2c:	00000000 	andeq	r0, r0, r0
  30:	0000816c 	andeq	r8, r0, ip, ror #2
  34:	000001c8 	andeq	r0, r0, r8, asr #3
	...
  40:	0000001c 	andeq	r0, r0, ip, lsl r0
  44:	05660002 	strbeq	r0, [r6, #-2]!
  48:	00040000 	andeq	r0, r4, r0
  4c:	00000000 	andeq	r0, r0, r0
  50:	00008334 	andeq	r8, r0, r4, lsr r3
  54:	0000083c 	andeq	r0, r0, ip, lsr r8
	...
  60:	00000034 	andeq	r0, r0, r4, lsr r0
  64:	0f090002 	svceq	0x00090002
  68:	00040000 	andeq	r0, r4, r0
  6c:	00000000 	andeq	r0, r0, r0
  70:	00008b70 	andeq	r8, r0, r0, ror fp
  74:	00000648 	andeq	r0, r0, r8, asr #12
  78:	000091b8 			; <UNDEFINED> instruction: 0x000091b8
  7c:	00000038 	andeq	r0, r0, r8, lsr r0
  80:	000091f0 	strdeq	r9, [r0], -r0
  84:	00000088 	andeq	r0, r0, r8, lsl #1
  88:	00009278 	andeq	r9, r0, r8, ror r2
  8c:	0000002c 	andeq	r0, r0, ip, lsr #32
	...
  98:	0000001c 	andeq	r0, r0, ip, lsl r0
  9c:	15c10002 	strbne	r0, [r1, #2]
  a0:	00040000 	andeq	r0, r4, r0
  a4:	00000000 	andeq	r0, r0, r0
  a8:	000092a4 	andeq	r9, r0, r4, lsr #5
  ac:	000004e8 	andeq	r0, r0, r8, ror #9
	...
  b8:	0000001c 	andeq	r0, r0, ip, lsl r0
  bc:	1d9c0002 	ldcne	0, cr0, [ip, #8]
  c0:	00040000 	andeq	r0, r4, r0
  c4:	00000000 	andeq	r0, r0, r0
  c8:	0000978c 	andeq	r9, r0, ip, lsl #15
  cc:	000005cc 	andeq	r0, r0, ip, asr #11
	...
  d8:	0000001c 	andeq	r0, r0, ip, lsl r0
  dc:	26e40002 	strbtcs	r0, [r4], r2
  e0:	00040000 	andeq	r0, r4, r0
  e4:	00000000 	andeq	r0, r0, r0
  e8:	00009d58 	andeq	r9, r0, r8, asr sp
  ec:	00000078 	andeq	r0, r0, r8, ror r0
	...
  f8:	00000024 	andeq	r0, r0, r4, lsr #32
  fc:	2da70002 	stccs	0, cr0, [r7, #8]!
 100:	00040000 	andeq	r0, r4, r0
 104:	00000000 	andeq	r0, r0, r0
 108:	00008000 	andeq	r8, r0, r0
 10c:	00000094 	muleq	r0, r4, r0
 110:	00009dd0 	ldrdeq	r9, [r0], -r0
 114:	00000020 	andeq	r0, r0, r0, lsr #32
	...
 120:	0000001c 	andeq	r0, r0, ip, lsl r0
 124:	2dc90002 	stclcs	0, cr0, [r9, #8]
 128:	00040000 	andeq	r0, r4, r0
 12c:	00000000 	andeq	r0, r0, r0
 130:	00009df0 	strdeq	r9, [r0], -r0
 134:	00000118 	andeq	r0, r0, r8, lsl r1
	...
 140:	0000001c 	andeq	r0, r0, ip, lsl r0
 144:	2f180002 	svccs	0x00180002
 148:	00040000 	andeq	r0, r4, r0
 14c:	00000000 	andeq	r0, r0, r0
 150:	00009f08 	andeq	r9, r0, r8, lsl #30
 154:	000004b8 			; <UNDEFINED> instruction: 0x000004b8
	...
 160:	0000001c 	andeq	r0, r0, ip, lsl r0
 164:	324a0002 	subcc	r0, sl, #2
 168:	00040000 	andeq	r0, r4, r0
 16c:	00000000 	andeq	r0, r0, r0
 170:	0000a3c0 	andeq	sl, r0, r0, asr #7
 174:	0000020c 	andeq	r0, r0, ip, lsl #4
	...
 180:	0000001c 	andeq	r0, r0, ip, lsl r0
 184:	32700002 	rsbscc	r0, r0, #2
 188:	00040000 	andeq	r0, r4, r0
 18c:	00000000 	andeq	r0, r0, r0
 190:	0000a5cc 	andeq	sl, r0, ip, asr #11
 194:	00000004 	andeq	r0, r0, r4
	...
 1a0:	00000014 	andeq	r0, r0, r4, lsl r0
 1a4:	32960002 	addscc	r0, r6, #2
 1a8:	00040000 	andeq	r0, r4, r0
	...

Disassembly of section .debug_line:

00000000 <.debug_line>:
       0:	000000ab 	andeq	r0, r0, fp, lsr #1
       4:	00720003 	rsbseq	r0, r2, r3
       8:	01020000 	mrseq	r0, (UNDEF: 2)
       c:	000d0efb 	strdeq	r0, [sp], -fp
      10:	01010101 	tsteq	r1, r1, lsl #2
      14:	01000000 	mrseq	r0, (UNDEF: 0)
      18:	2f010000 	svccs	0x00010000
      1c:	2f746e6d 	svccs	0x00746e6d
      20:	73552f63 	cmpvc	r5, #396	; 0x18c
      24:	2f737265 	svccs	0x00737265
      28:	6162754b 	cmnvs	r2, fp, asr #10
      2c:	636f442f 	cmnvs	pc, #788529152	; 0x2f000000
      30:	6e656d75 	mcrvs	13, 3, r6, cr5, cr5, {3}
      34:	5a2f7374 	bpl	bdce0c <_bss_end+0xbd2384>
      38:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; fffffeac <_bss_end+0xffff5424>
      3c:	2f657461 	svccs	0x00657461
      40:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
      44:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
      48:	2d30322f 	lfmcs	f3, 4, [r0, #-188]!	; 0xffffff44
      4c:	54524155 	ldrbpl	r4, [r2], #-341	; 0xfffffeab
      50:	6d61675f 	stclvs	7, cr6, [r1, #-380]!	; 0xfffffe84
      54:	656b2f65 	strbvs	r2, [fp, #-3941]!	; 0xfffff09b
      58:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
      5c:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
      60:	78630000 	stmdavc	r3!, {}^	; <UNPREDICTABLE>
      64:	70632e78 	rsbvc	r2, r3, r8, ror lr
      68:	00010070 	andeq	r0, r1, r0, ror r0
      6c:	75623c00 	strbvc	r3, [r2, #-3072]!	; 0xfffff400
      70:	2d746c69 	ldclcs	12, cr6, [r4, #-420]!	; 0xfffffe5c
      74:	003e6e69 	eorseq	r6, lr, r9, ror #28
      78:	00000000 	andeq	r0, r0, r0
      7c:	05000505 	streq	r0, [r0, #-1285]	; 0xfffffafb
      80:	00809402 	addeq	r9, r0, r2, lsl #8
      84:	010a0300 	mrseq	r0, (UNDEF: 58)
      88:	05831105 	streq	r1, [r3, #261]	; 0x105
      8c:	05054a10 	streq	r4, [r5, #-2576]	; 0xfffff5f0
      90:	13058583 	movwne	r8, #21891	; 0x5583
      94:	67050583 	strvs	r0, [r5, -r3, lsl #11]
      98:	01058385 	smlabbeq	r5, r5, r3, r8
      9c:	4c854c86 	stcmi	12, cr4, [r5], {134}	; 0x86
      a0:	05854c85 	streq	r4, [r5, #3205]	; 0xc85
      a4:	04020005 	streq	r0, [r2], #-5
      a8:	02024b01 	andeq	r4, r2, #1024	; 0x400
      ac:	b5010100 	strlt	r0, [r1, #-256]	; 0xffffff00
      b0:	03000001 	movweq	r0, #1
      b4:	00014500 	andeq	r4, r1, r0, lsl #10
      b8:	fb010200 	blx	408c2 <_bss_end+0x35e3a>
      bc:	01000d0e 	tsteq	r0, lr, lsl #26
      c0:	00010101 	andeq	r0, r1, r1, lsl #2
      c4:	00010000 	andeq	r0, r1, r0
      c8:	6d2f0100 	stfvss	f0, [pc, #-0]	; d0 <CPSR_IRQ_INHIBIT+0x50>
      cc:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
      d0:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
      d4:	4b2f7372 	blmi	bdcea4 <_bss_end+0xbd241c>
      d8:	2f616275 	svccs	0x00616275
      dc:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
      e0:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
      e4:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
      e8:	614d6f72 	hvcvs	55026	; 0xd6f2
      ec:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffb80 <_bss_end+0xffff50f8>
      f0:	706d6178 	rsbvc	r6, sp, r8, ror r1
      f4:	2f73656c 	svccs	0x0073656c
      f8:	552d3032 	strpl	r3, [sp, #-50]!	; 0xffffffce
      fc:	5f545241 	svcpl	0x00545241
     100:	656d6167 	strbvs	r6, [sp, #-359]!	; 0xfffffe99
     104:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
     108:	2f6c656e 	svccs	0x006c656e
     10c:	2f637273 	svccs	0x00637273
     110:	76697264 	strbtvc	r7, [r9], -r4, ror #4
     114:	00737265 	rsbseq	r7, r3, r5, ror #4
     118:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
     11c:	552f632f 	strpl	r6, [pc, #-815]!	; fffffdf5 <_bss_end+0xffff536d>
     120:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
     124:	62754b2f 	rsbsvs	r4, r5, #48128	; 0xbc00
     128:	6f442f61 	svcvs	0x00442f61
     12c:	656d7563 	strbvs	r7, [sp, #-1379]!	; 0xfffffa9d
     130:	2f73746e 	svccs	0x0073746e
     134:	6f72655a 	svcvs	0x0072655a
     138:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
     13c:	6178652f 	cmnvs	r8, pc, lsr #10
     140:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
     144:	30322f73 	eorscc	r2, r2, r3, ror pc
     148:	5241552d 	subpl	r5, r1, #188743680	; 0xb400000
     14c:	61675f54 	cmnvs	r7, r4, asr pc
     150:	6b2f656d 	blvs	bd970c <_bss_end+0xbcec84>
     154:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
     158:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
     15c:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
     160:	6f622f65 	svcvs	0x00622f65
     164:	2f647261 	svccs	0x00647261
     168:	30697072 	rsbcc	r7, r9, r2, ror r0
     16c:	6c61682f 	stclvs	8, cr6, [r1], #-188	; 0xffffff44
     170:	6e6d2f00 	cdpvs	15, 6, cr2, cr13, cr0, {0}
     174:	2f632f74 	svccs	0x00632f74
     178:	72657355 	rsbvc	r7, r5, #1409286145	; 0x54000001
     17c:	754b2f73 	strbvc	r2, [fp, #-3955]	; 0xfffff08d
     180:	442f6162 	strtmi	r6, [pc], #-354	; 188 <CPSR_IRQ_INHIBIT+0x108>
     184:	6d75636f 	ldclvs	3, cr6, [r5, #-444]!	; 0xfffffe44
     188:	73746e65 	cmnvc	r4, #1616	; 0x650
     18c:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
     190:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
     194:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
     198:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
     19c:	322f7365 	eorcc	r7, pc, #-1811939327	; 0x94000001
     1a0:	41552d30 	cmpmi	r5, r0, lsr sp
     1a4:	675f5452 			; <UNDEFINED> instruction: 0x675f5452
     1a8:	2f656d61 	svccs	0x00656d61
     1ac:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
     1b0:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
     1b4:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
     1b8:	642f6564 	strtvs	r6, [pc], #-1380	; 1c0 <CPSR_IRQ_INHIBIT+0x140>
     1bc:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
     1c0:	00007372 	andeq	r7, r0, r2, ror r3
     1c4:	5f6d6362 	svcpl	0x006d6362
     1c8:	2e787561 	cdpcs	5, 7, cr7, cr8, cr1, {3}
     1cc:	00707063 	rsbseq	r7, r0, r3, rrx
     1d0:	70000001 	andvc	r0, r0, r1
     1d4:	70697265 	rsbvc	r7, r9, r5, ror #4
     1d8:	61726568 	cmnvs	r2, r8, ror #10
     1dc:	682e736c 	stmdavs	lr!, {r2, r3, r5, r6, r8, r9, ip, sp, lr}
     1e0:	00000200 	andeq	r0, r0, r0, lsl #4
     1e4:	5f6d6362 	svcpl	0x006d6362
     1e8:	2e787561 	cdpcs	5, 7, cr7, cr8, cr1, {3}
     1ec:	00030068 	andeq	r0, r3, r8, rrx
     1f0:	746e6900 	strbtvc	r6, [lr], #-2304	; 0xfffff700
     1f4:	2e666564 	cdpcs	5, 6, cr6, cr6, cr4, {3}
     1f8:	00020068 	andeq	r0, r2, r8, rrx
     1fc:	01050000 	mrseq	r0, (UNDEF: 5)
     200:	6c020500 	cfstr32vs	mvfx0, [r2], {-0}
     204:	16000081 	strne	r0, [r0], -r1, lsl #1
     208:	059f3505 	ldreq	r3, [pc, #1285]	; 715 <CPSR_IRQ_INHIBIT+0x695>
     20c:	05a16901 	streq	r6, [r1, #2305]!	; 0x901
     210:	3e05a01e 	mcrcc	0, 0, sl, cr5, cr14, {0}
     214:	2e3b0582 	cfadd32cs	mvfx0, mvfx11, mvfx2
     218:	05491105 	strbeq	r1, [r9, #-261]	; 0xfffffefb
     21c:	0569a001 	strbeq	sl, [r9, #-1]!
     220:	3f05a01e 	svccc	0x0005a01e
     224:	2e3c0582 	cfadd32cs	mvfx0, mvfx12, mvfx2
     228:	054a3805 	strbeq	r3, [sl, #-2053]	; 0xfffff7fb
     22c:	01052d11 	tsteq	r5, r1, lsl sp
     230:	050569a0 	streq	r6, [r5, #-2464]	; 0xfffff660
     234:	4a0e05bb 	bmi	381928 <_bss_end+0x376ea0>
     238:	052e3005 	streq	r3, [lr, #-5]!
     23c:	01054a32 	tsteq	r5, r2, lsr sl
     240:	0c05854b 	cfstr32eq	mvfx8, [r5], {75}	; 0x4b
     244:	4a15059f 	bmi	5418c8 <_bss_end+0x536e40>
     248:	052e3705 	streq	r3, [lr, #-1797]!	; 0xfffff8fb
     24c:	9e826701 	cdpls	7, 8, cr6, cr2, cr1, {0}
     250:	01040200 	mrseq	r0, R12_usr
     254:	18056606 	stmdane	r5, {r1, r2, r9, sl, sp, lr}
     258:	82640306 	rsbhi	r0, r4, #402653184	; 0x18000000
     25c:	1c030105 	stfnes	f0, [r3], {5}
     260:	024aba66 	subeq	fp, sl, #417792	; 0x66000
     264:	0101000a 	tsteq	r1, sl
     268:	00000429 	andeq	r0, r0, r9, lsr #8
     26c:	013f0003 	teqeq	pc, r3
     270:	01020000 	mrseq	r0, (UNDEF: 2)
     274:	000d0efb 	strdeq	r0, [sp], -fp
     278:	01010101 	tsteq	r1, r1, lsl #2
     27c:	01000000 	mrseq	r0, (UNDEF: 0)
     280:	2f010000 	svccs	0x00010000
     284:	2f746e6d 	svccs	0x00746e6d
     288:	73552f63 	cmpvc	r5, #396	; 0x18c
     28c:	2f737265 	svccs	0x00737265
     290:	6162754b 	cmnvs	r2, fp, asr #10
     294:	636f442f 	cmnvs	pc, #788529152	; 0x2f000000
     298:	6e656d75 	mcrvs	13, 3, r6, cr5, cr5, {3}
     29c:	5a2f7374 	bpl	bdd074 <_bss_end+0xbd25ec>
     2a0:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 114 <CPSR_IRQ_INHIBIT+0x94>
     2a4:	2f657461 	svccs	0x00657461
     2a8:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
     2ac:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
     2b0:	2d30322f 	lfmcs	f3, 4, [r0, #-188]!	; 0xffffff44
     2b4:	54524155 	ldrbpl	r4, [r2], #-341	; 0xfffffeab
     2b8:	6d61675f 	stclvs	7, cr6, [r1, #-380]!	; 0xfffffe84
     2bc:	656b2f65 	strbvs	r2, [fp, #-3941]!	; 0xfffff09b
     2c0:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
     2c4:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
     2c8:	6972642f 	ldmdbvs	r2!, {r0, r1, r2, r3, r5, sl, sp, lr}^
     2cc:	73726576 	cmnvc	r2, #494927872	; 0x1d800000
     2d0:	6e6d2f00 	cdpvs	15, 6, cr2, cr13, cr0, {0}
     2d4:	2f632f74 	svccs	0x00632f74
     2d8:	72657355 	rsbvc	r7, r5, #1409286145	; 0x54000001
     2dc:	754b2f73 	strbvc	r2, [fp, #-3955]	; 0xfffff08d
     2e0:	442f6162 	strtmi	r6, [pc], #-354	; 2e8 <CPSR_IRQ_INHIBIT+0x268>
     2e4:	6d75636f 	ldclvs	3, cr6, [r5, #-444]!	; 0xfffffe44
     2e8:	73746e65 	cmnvc	r4, #1616	; 0x650
     2ec:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
     2f0:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
     2f4:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
     2f8:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
     2fc:	322f7365 	eorcc	r7, pc, #-1811939327	; 0x94000001
     300:	41552d30 	cmpmi	r5, r0, lsr sp
     304:	675f5452 			; <UNDEFINED> instruction: 0x675f5452
     308:	2f656d61 	svccs	0x00656d61
     30c:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
     310:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
     314:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
     318:	622f6564 	eorvs	r6, pc, #100, 10	; 0x19000000
     31c:	6472616f 	ldrbtvs	r6, [r2], #-367	; 0xfffffe91
     320:	6970722f 	ldmdbvs	r0!, {r0, r1, r2, r3, r5, r9, ip, sp, lr}^
     324:	61682f30 	cmnvs	r8, r0, lsr pc
     328:	6d2f006c 	stcvs	0, cr0, [pc, #-432]!	; 180 <CPSR_IRQ_INHIBIT+0x100>
     32c:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
     330:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
     334:	4b2f7372 	blmi	bdd104 <_bss_end+0xbd267c>
     338:	2f616275 	svccs	0x00616275
     33c:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
     340:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
     344:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
     348:	614d6f72 	hvcvs	55026	; 0xd6f2
     34c:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffde0 <_bss_end+0xffff5358>
     350:	706d6178 	rsbvc	r6, sp, r8, ror r1
     354:	2f73656c 	svccs	0x0073656c
     358:	552d3032 	strpl	r3, [sp, #-50]!	; 0xffffffce
     35c:	5f545241 	svcpl	0x00545241
     360:	656d6167 	strbvs	r6, [sp, #-359]!	; 0xfffffe99
     364:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
     368:	2f6c656e 	svccs	0x006c656e
     36c:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
     370:	2f656475 	svccs	0x00656475
     374:	76697264 	strbtvc	r7, [r9], -r4, ror #4
     378:	00737265 	rsbseq	r7, r3, r5, ror #4
     37c:	69706700 	ldmdbvs	r0!, {r8, r9, sl, sp, lr}^
     380:	70632e6f 	rsbvc	r2, r3, pc, ror #28
     384:	00010070 	andeq	r0, r1, r0, ror r0
     388:	746e6900 	strbtvc	r6, [lr], #-2304	; 0xfffff700
     38c:	2e666564 	cdpcs	5, 6, cr6, cr6, cr4, {3}
     390:	00020068 	andeq	r0, r2, r8, rrx
     394:	72657000 	rsbvc	r7, r5, #0
     398:	65687069 	strbvs	r7, [r8, #-105]!	; 0xffffff97
     39c:	736c6172 	cmnvc	ip, #-2147483620	; 0x8000001c
     3a0:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
     3a4:	70670000 	rsbvc	r0, r7, r0
     3a8:	682e6f69 	stmdavs	lr!, {r0, r3, r5, r6, r8, r9, sl, fp, sp, lr}
     3ac:	00000300 	andeq	r0, r0, r0, lsl #6
     3b0:	00010500 	andeq	r0, r1, r0, lsl #10
     3b4:	83340205 	teqhi	r4, #1342177280	; 0x50000000
     3b8:	05170000 	ldreq	r0, [r7, #-0]
     3bc:	01059f38 	tsteq	r5, r8, lsr pc
     3c0:	0505a169 	streq	sl, [r5, #-361]	; 0xfffffe97
     3c4:	671005d7 			; <UNDEFINED> instruction: 0x671005d7
     3c8:	054c1105 	strbeq	r1, [ip, #-261]	; 0xfffffefb
     3cc:	11058205 	tstne	r5, r5, lsl #4
     3d0:	0d052308 	stceq	3, cr2, [r5, #-32]	; 0xffffffe0
     3d4:	30110567 	andscc	r0, r1, r7, ror #10
     3d8:	05670d05 	strbeq	r0, [r7, #-3333]!	; 0xfffff2fb
     3dc:	0d053011 	stceq	0, cr3, [r5, #-68]	; 0xffffffbc
     3e0:	30110567 	andscc	r0, r1, r7, ror #10
     3e4:	05670d05 	strbeq	r0, [r7, #-3333]!	; 0xfffff2fb
     3e8:	0d053011 	stceq	0, cr3, [r5, #-68]	; 0xffffffbc
     3ec:	30110567 	andscc	r0, r1, r7, ror #10
     3f0:	05670d05 	strbeq	r0, [r7, #-3333]!	; 0xfffff2fb
     3f4:	1a053114 	bne	14c84c <_bss_end+0x141dc4>
     3f8:	0d052008 	stceq	0, cr2, [r5, #-32]	; 0xffffffe0
     3fc:	4c0c0566 	cfstr32mi	mvfx0, [ip], {102}	; 0x66
     400:	a12f0105 			; <UNDEFINED> instruction: 0xa12f0105
     404:	05d70505 	ldrbeq	r0, [r7, #1285]	; 0x505
     408:	0b056710 	bleq	15a050 <_bss_end+0x14f5c8>
     40c:	0402004c 	streq	r0, [r2], #-76	; 0xffffffb4
     410:	00660601 	rsbeq	r0, r6, r1, lsl #12
     414:	4a020402 	bmi	81424 <_bss_end+0x7699c>
     418:	02000905 	andeq	r0, r0, #81920	; 0x14000
     41c:	2e060404 	cdpcs	4, 0, cr0, cr6, cr4, {0}
     420:	02001305 	andeq	r1, r0, #335544320	; 0x14000000
     424:	054b0404 	strbeq	r0, [fp, #-1028]	; 0xfffffbfc
     428:	0402000d 	streq	r0, [r2], #-13
     42c:	0c054a04 			; <UNDEFINED> instruction: 0x0c054a04
     430:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
     434:	2f01054c 	svccs	0x0001054c
     438:	d7050585 	strle	r0, [r5, -r5, lsl #11]
     43c:	05671005 	strbeq	r1, [r7, #-5]!
     440:	02004c0b 	andeq	r4, r0, #2816	; 0xb00
     444:	66060104 	strvs	r0, [r6], -r4, lsl #2
     448:	02040200 	andeq	r0, r4, #0, 4
     44c:	0009054a 	andeq	r0, r9, sl, asr #10
     450:	06040402 	streq	r0, [r4], -r2, lsl #8
     454:	0013052e 	andseq	r0, r3, lr, lsr #10
     458:	4b040402 	blmi	101468 <_bss_end+0xf69e0>
     45c:	02000d05 	andeq	r0, r0, #320	; 0x140
     460:	054a0404 	strbeq	r0, [sl, #-1028]	; 0xfffffbfc
     464:	0402000c 	streq	r0, [r2], #-12
     468:	01054c04 	tsteq	r5, r4, lsl #24
     46c:	0505852f 	streq	r8, [r5, #-1327]	; 0xfffffad1
     470:	671005d7 			; <UNDEFINED> instruction: 0x671005d7
     474:	004c0b05 	subeq	r0, ip, r5, lsl #22
     478:	06010402 	streq	r0, [r1], -r2, lsl #8
     47c:	04020066 	streq	r0, [r2], #-102	; 0xffffff9a
     480:	09054a02 	stmdbeq	r5, {r1, r9, fp, lr}
     484:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
     488:	13052e06 	movwne	r2, #24070	; 0x5e06
     48c:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
     490:	000d054b 	andeq	r0, sp, fp, asr #10
     494:	4a040402 	bmi	1014a4 <_bss_end+0xf6a1c>
     498:	02000c05 	andeq	r0, r0, #1280	; 0x500
     49c:	054c0404 	strbeq	r0, [ip, #-1028]	; 0xfffffbfc
     4a0:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
     4a4:	0905d81d 	stmdbeq	r5, {r0, r2, r3, r4, fp, ip, lr, pc}
     4a8:	4a0505ba 	bmi	141b98 <_bss_end+0x137110>
     4ac:	054d1305 	strbeq	r1, [sp, #-773]	; 0xfffffcfb
     4b0:	3e054a1c 			; <UNDEFINED> instruction: 0x3e054a1c
     4b4:	66210582 	strtvs	r0, [r1], -r2, lsl #11
     4b8:	052e1e05 	streq	r1, [lr, #-3589]!	; 0xfffff1fb
     4bc:	6b052e4b 	blvs	14bdf0 <_bss_end+0x141368>
     4c0:	4a05052e 	bmi	141980 <_bss_end+0x136ef8>
     4c4:	054a0e05 	strbeq	r0, [sl, #-3589]	; 0xfffff1fb
     4c8:	10056648 	andne	r6, r5, r8, asr #12
     4cc:	4809052e 	stmdami	r9, {r1, r2, r3, r5, r8, sl}
     4d0:	4d310105 	ldfmis	f0, [r1, #-20]!	; 0xffffffec
     4d4:	05a01d05 	streq	r1, [r0, #3333]!	; 0xd05
     4d8:	0505ba09 	streq	fp, [r5, #-2569]	; 0xfffff5f7
     4dc:	4b20054a 	blmi	801a0c <_bss_end+0x7f6f84>
     4e0:	054c2905 	strbeq	r2, [ip, #-2309]	; 0xfffff6fb
     4e4:	34054a32 	strcc	r4, [r5], #-2610	; 0xfffff5ce
     4e8:	4a0c0582 	bmi	301af8 <_bss_end+0x2f7070>
     4ec:	052e3f05 	streq	r3, [lr, #-3845]!	; 0xfffff0fb
     4f0:	04020001 	streq	r0, [r2], #-1
     4f4:	05694b01 	strbeq	r4, [r9, #-2817]!	; 0xfffff4ff
     4f8:	0905bc24 	stmdbeq	r5, {r2, r5, sl, fp, ip, sp, pc}
     4fc:	05052008 	streq	r2, [r5, #-8]
     500:	4d15054a 	cfldr32mi	mvfx0, [r5, #-296]	; 0xfffffed8
     504:	05660505 	strbeq	r0, [r6, #-1285]!	; 0xfffffafb
     508:	15054a0e 	strne	r4, [r5, #-2574]	; 0xfffff5f2
     50c:	2e100566 	cfmsc32cs	mvfx0, mvfx0, mvfx6
     510:	05480905 	strbeq	r0, [r8, #-2309]	; 0xfffff6fb
     514:	2e090301 	cdpcs	3, 0, cr0, cr9, cr1, {0}
     518:	d7050550 	smlsdle	r5, r0, r5, r0
     51c:	05671005 	strbeq	r1, [r7, #-5]!
     520:	0d054c13 	stceq	12, cr4, [r5, #-76]	; 0xffffffb4
     524:	4c05054a 	cfstr32mi	mvfx0, [r5], {74}	; 0x4a
     528:	00f51305 	rscseq	r1, r5, r5, lsl #6
     52c:	06010402 	streq	r0, [r1], -r2, lsl #8
     530:	04020066 	streq	r0, [r2], #-102	; 0xffffff9a
     534:	11054a02 	tstne	r5, r2, lsl #20
     538:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
     53c:	0d052e06 	stceq	14, cr2, [r5, #-24]	; 0xffffffe8
     540:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
     544:	3013054b 	andscc	r0, r3, fp, asr #10
     548:	01040200 	mrseq	r0, R12_usr
     54c:	02006606 	andeq	r6, r0, #6291456	; 0x600000
     550:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
     554:	04020011 	streq	r0, [r2], #-17	; 0xffffffef
     558:	052e0604 	streq	r0, [lr, #-1540]!	; 0xfffff9fc
     55c:	0402000d 	streq	r0, [r2], #-13
     560:	13054b04 	movwne	r4, #23300	; 0x5b04
     564:	04020030 	streq	r0, [r2], #-48	; 0xffffffd0
     568:	00660601 	rsbeq	r0, r6, r1, lsl #12
     56c:	4a020402 	bmi	8157c <_bss_end+0x76af4>
     570:	02001105 	andeq	r1, r0, #1073741825	; 0x40000001
     574:	2e060404 	cdpcs	4, 0, cr0, cr6, cr4, {0}
     578:	02000d05 	andeq	r0, r0, #320	; 0x140
     57c:	054b0404 	strbeq	r0, [fp, #-1028]	; 0xfffffbfc
     580:	02003013 	andeq	r3, r0, #19
     584:	66060104 	strvs	r0, [r6], -r4, lsl #2
     588:	02040200 	andeq	r0, r4, #0, 4
     58c:	0011054a 	andseq	r0, r1, sl, asr #10
     590:	06040402 	streq	r0, [r4], -r2, lsl #8
     594:	000d052e 	andeq	r0, sp, lr, lsr #10
     598:	4b040402 	blmi	1015a8 <_bss_end+0xf6b20>
     59c:	05301405 	ldreq	r1, [r0, #-1029]!	; 0xfffffbfb
     5a0:	01054d0c 	tsteq	r5, ip, lsl #26
     5a4:	2405852f 	strcs	r8, [r5], #-1327	; 0xfffffad1
     5a8:	080905bc 	stmdaeq	r9, {r2, r3, r4, r5, r7, r8, sl}
     5ac:	4a050520 	bmi	141a34 <_bss_end+0x136fac>
     5b0:	054d1405 	strbeq	r1, [sp, #-1029]	; 0xfffffbfb
     5b4:	0e054a1d 			; <UNDEFINED> instruction: 0x0e054a1d
     5b8:	4b100566 	blmi	401b58 <_bss_end+0x3f70d0>
     5bc:	05660c05 	strbeq	r0, [r6, #-3077]!	; 0xfffff3fb
     5c0:	05054a09 	streq	r4, [r5, #-2569]	; 0xfffff5f7
     5c4:	4a0e0567 	bmi	381b68 <_bss_end+0x3770e0>
     5c8:	05661005 	strbeq	r1, [r6, #-5]!
     5cc:	01056209 	tsteq	r5, r9, lsl #4
     5d0:	0b054d33 	bleq	153aa4 <_bss_end+0x14901c>
     5d4:	663505d8 			; <UNDEFINED> instruction: 0x663505d8
     5d8:	02002405 	andeq	r2, r0, #83886080	; 0x5000000
     5dc:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
     5e0:	04020009 	streq	r0, [r2], #-9
     5e4:	3505f202 	strcc	pc, [r5, #-514]	; 0xfffffdfe
     5e8:	03040200 	movweq	r0, #16896	; 0x4200
     5ec:	0054054a 	subseq	r0, r4, sl, asr #10
     5f0:	66060402 	strvs	r0, [r6], -r2, lsl #8
     5f4:	02003805 	andeq	r3, r0, #327680	; 0x50000
     5f8:	05f20604 	ldrbeq	r0, [r2, #1540]!	; 0x604
     5fc:	04020035 	streq	r0, [r2], #-53	; 0xffffffcb
     600:	02004a07 	andeq	r4, r0, #28672	; 0x7000
     604:	4a060804 	bmi	18261c <_bss_end+0x177b94>
     608:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
     60c:	2e060a04 	vmlacs.f32	s0, s12, s8
     610:	054d1505 	strbeq	r1, [sp, #-1285]	; 0xfffffafb
     614:	0e056605 	cfmadd32eq	mvax0, mvfx6, mvfx5, mvfx5
     618:	6615054a 	ldrvs	r0, [r5], -sl, asr #10
     61c:	052e1005 	streq	r1, [lr, #-5]!
     620:	01054809 	tsteq	r5, r9, lsl #16
     624:	05054d31 	streq	r4, [r5, #-3377]	; 0xfffff2cf
     628:	671005d7 			; <UNDEFINED> instruction: 0x671005d7
     62c:	004c0b05 	subeq	r0, ip, r5, lsl #22
     630:	06010402 	streq	r0, [r1], -r2, lsl #8
     634:	04020066 	streq	r0, [r2], #-102	; 0xffffff9a
     638:	09054a02 	stmdbeq	r5, {r1, r9, fp, lr}
     63c:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
     640:	13052e06 	movwne	r2, #24070	; 0x5e06
     644:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
     648:	000d054b 	andeq	r0, sp, fp, asr #10
     64c:	4a040402 	bmi	10165c <_bss_end+0xf6bd4>
     650:	02000c05 	andeq	r0, r0, #1280	; 0x500
     654:	054c0404 	strbeq	r0, [ip, #-1028]	; 0xfffffbfc
     658:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
     65c:	0905a01c 	stmdbeq	r5, {r2, r3, r4, sp, pc}
     660:	4a0505ba 	bmi	141d50 <_bss_end+0x1372c8>
     664:	054e1405 	strbeq	r1, [lr, #-1029]	; 0xfffffbfb
     668:	0e056605 	cfmadd32eq	mvax0, mvfx6, mvfx5, mvfx5
     66c:	6614054a 	ldrvs	r0, [r4], -sl, asr #10
     670:	052e1005 	streq	r1, [lr, #-5]!
     674:	01054709 	tsteq	r5, r9, lsl #14
     678:	009e4a32 	addseq	r4, lr, r2, lsr sl
     67c:	06010402 	streq	r0, [r1], -r2, lsl #8
     680:	06230566 	strteq	r0, [r3], -r6, ror #10
     684:	827ed003 	rsbshi	sp, lr, #3
     688:	b0030105 	andlt	r0, r3, r5, lsl #2
     68c:	4aba6601 	bmi	fee99e98 <_bss_end+0xfee8f410>
     690:	01000a02 	tsteq	r0, r2, lsl #20
     694:	0003e901 	andeq	lr, r3, r1, lsl #18
     698:	cf000300 	svcgt	0x00000300
     69c:	02000000 	andeq	r0, r0, #0
     6a0:	0d0efb01 	vstreq	d15, [lr, #-4]
     6a4:	01010100 	mrseq	r0, (UNDEF: 17)
     6a8:	00000001 	andeq	r0, r0, r1
     6ac:	01000001 	tsteq	r0, r1
     6b0:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
     6b4:	552f632f 	strpl	r6, [pc, #-815]!	; 38d <CPSR_IRQ_INHIBIT+0x30d>
     6b8:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
     6bc:	62754b2f 	rsbsvs	r4, r5, #48128	; 0xbc00
     6c0:	6f442f61 	svcvs	0x00442f61
     6c4:	656d7563 	strbvs	r7, [sp, #-1379]!	; 0xfffffa9d
     6c8:	2f73746e 	svccs	0x0073746e
     6cc:	6f72655a 	svcvs	0x0072655a
     6d0:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
     6d4:	6178652f 	cmnvs	r8, pc, lsr #10
     6d8:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
     6dc:	30322f73 	eorscc	r2, r2, r3, ror pc
     6e0:	5241552d 	subpl	r5, r1, #188743680	; 0xb400000
     6e4:	61675f54 	cmnvs	r7, r4, asr pc
     6e8:	6b2f656d 	blvs	bd9ca4 <_bss_end+0xbcf21c>
     6ec:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
     6f0:	72732f6c 	rsbsvc	r2, r3, #108, 30	; 0x1b0
     6f4:	72642f63 	rsbvc	r2, r4, #396	; 0x18c
     6f8:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
     6fc:	6d2f0073 	stcvs	0, cr0, [pc, #-460]!	; 538 <CPSR_IRQ_INHIBIT+0x4b8>
     700:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
     704:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
     708:	4b2f7372 	blmi	bdd4d8 <_bss_end+0xbd2a50>
     70c:	2f616275 	svccs	0x00616275
     710:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
     714:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
     718:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
     71c:	614d6f72 	hvcvs	55026	; 0xd6f2
     720:	652f6574 	strvs	r6, [pc, #-1396]!	; 1b4 <CPSR_IRQ_INHIBIT+0x134>
     724:	706d6178 	rsbvc	r6, sp, r8, ror r1
     728:	2f73656c 	svccs	0x0073656c
     72c:	552d3032 	strpl	r3, [sp, #-50]!	; 0xffffffce
     730:	5f545241 	svcpl	0x00545241
     734:	656d6167 	strbvs	r6, [sp, #-359]!	; 0xfffffe99
     738:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
     73c:	2f6c656e 	svccs	0x006c656e
     740:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
     744:	2f656475 	svccs	0x00656475
     748:	76697264 	strbtvc	r7, [r9], -r4, ror #4
     74c:	00737265 	rsbseq	r7, r3, r5, ror #4
     750:	6e6f6d00 	cdpvs	13, 6, cr6, cr15, cr0, {0}
     754:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
     758:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
     75c:	00000100 	andeq	r0, r0, r0, lsl #2
     760:	696e6f6d 	stmdbvs	lr!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
     764:	2e726f74 	mrccs	15, 3, r6, cr2, cr4, {3}
     768:	00020068 	andeq	r0, r2, r8, rrx
     76c:	01050000 	mrseq	r0, (UNDEF: 5)
     770:	70020500 	andvc	r0, r2, r0, lsl #10
     774:	1600008b 	strne	r0, [r0], -fp, lsl #1
     778:	05d70e05 	ldrbeq	r0, [r7, #3589]	; 0xe05
     77c:	01053226 	tsteq	r5, r6, lsr #4
     780:	03142202 	tsteq	r4, #536870912	; 0x20000000
     784:	11059e09 	tstne	r5, r9, lsl #28
     788:	4c170583 	cfldr32mi	mvfx0, [r7], {131}	; 0x83
     78c:	02002205 	andeq	r2, r0, #1342177280	; 0x50000000
     790:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
     794:	04020020 	streq	r0, [r2], #-32	; 0xffffffe0
     798:	1b054a01 	blne	152fa4 <_bss_end+0x14851c>
     79c:	00260568 	eoreq	r0, r6, r8, ror #10
     7a0:	4a030402 	bmi	c17b0 <_bss_end+0xb6d28>
     7a4:	02002405 	andeq	r2, r0, #83886080	; 0x5000000
     7a8:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
     7ac:	0402000d 	streq	r0, [r2], #-13
     7b0:	1c056802 	stcne	8, cr6, [r5], {2}
     7b4:	02040200 	andeq	r0, r4, #0, 4
     7b8:	001a054a 	andseq	r0, sl, sl, asr #10
     7bc:	4a020402 	bmi	817cc <_bss_end+0x76d44>
     7c0:	02002505 	andeq	r2, r0, #20971520	; 0x1400000
     7c4:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
     7c8:	04020028 	streq	r0, [r2], #-40	; 0xffffffd8
     7cc:	2a054a02 	bcs	152fdc <_bss_end+0x148554>
     7d0:	02040200 	andeq	r0, r4, #0, 4
     7d4:	0009052e 	andeq	r0, r9, lr, lsr #10
     7d8:	48020402 	stmdami	r2, {r1, sl}
     7dc:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
     7e0:	05800204 	streq	r0, [r0, #516]	; 0x204
     7e4:	12038901 	andne	r8, r3, #16384	; 0x4000
     7e8:	83170566 	tsthi	r7, #427819008	; 0x19800000
     7ec:	02002205 	andeq	r2, r0, #1342177280	; 0x50000000
     7f0:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
     7f4:	04020020 	streq	r0, [r2], #-32	; 0xffffffe0
     7f8:	1b054a01 	blne	153004 <_bss_end+0x14857c>
     7fc:	00260568 	eoreq	r0, r6, r8, ror #10
     800:	4a030402 	bmi	c1810 <_bss_end+0xb6d88>
     804:	02002405 	andeq	r2, r0, #83886080	; 0x5000000
     808:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
     80c:	04020032 	streq	r0, [r2], #-50	; 0xffffffce
     810:	41056802 	tstmi	r5, r2, lsl #16
     814:	02040200 	andeq	r0, r4, #0, 4
     818:	003f054a 	eorseq	r0, pc, sl, asr #10
     81c:	4a020402 	bmi	8182c <_bss_end+0x76da4>
     820:	02004a05 	andeq	r4, r0, #20480	; 0x5000
     824:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
     828:	0402004d 	streq	r0, [r2], #-77	; 0xffffffb3
     82c:	0d054a02 	vstreq	s8, [r5, #-8]
     830:	02040200 	andeq	r0, r4, #0, 4
     834:	001b052e 	andseq	r0, fp, lr, lsr #10
     838:	4a020402 	bmi	81848 <_bss_end+0x76dc0>
     83c:	02002205 	andeq	r2, r0, #1342177280	; 0x50000000
     840:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
     844:	04020020 	streq	r0, [r2], #-32	; 0xffffffe0
     848:	2b054a02 	blcs	153058 <_bss_end+0x1485d0>
     84c:	02040200 	andeq	r0, r4, #0, 4
     850:	002e052e 	eoreq	r0, lr, lr, lsr #10
     854:	4a020402 	bmi	81864 <_bss_end+0x76ddc>
     858:	02004d05 	andeq	r4, r0, #320	; 0x140
     85c:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
     860:	04020030 	streq	r0, [r2], #-48	; 0xffffffd0
     864:	09054a02 	stmdbeq	r5, {r1, r9, fp, lr}
     868:	02040200 	andeq	r0, r4, #0, 4
     86c:	0005052c 	andeq	r0, r5, ip, lsr #10
     870:	80020402 	andhi	r0, r2, r2, lsl #8
     874:	058a1705 	streq	r1, [sl, #1797]	; 0x705
     878:	04020022 	streq	r0, [r2], #-34	; 0xffffffde
     87c:	20054a03 	andcs	r4, r5, r3, lsl #20
     880:	03040200 	movweq	r0, #16896	; 0x4200
     884:	0009054a 	andeq	r0, r9, sl, asr #10
     888:	68020402 	stmdavs	r2, {r1, sl}
     88c:	02001505 	andeq	r1, r0, #20971520	; 0x1400000
     890:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
     894:	0402001e 	streq	r0, [r2], #-30	; 0xffffffe2
     898:	25054a02 	strcs	r4, [r5, #-2562]	; 0xfffff5fe
     89c:	02040200 	andeq	r0, r4, #0, 4
     8a0:	0023052e 	eoreq	r0, r3, lr, lsr #10
     8a4:	4a020402 	bmi	818b4 <_bss_end+0x76e2c>
     8a8:	02002e05 	andeq	r2, r0, #5, 28	; 0x50
     8ac:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
     8b0:	04020031 	streq	r0, [r2], #-49	; 0xffffffcf
     8b4:	33054a02 	movwcc	r4, #23042	; 0x5a02
     8b8:	02040200 	andeq	r0, r4, #0, 4
     8bc:	0005052e 	andeq	r0, r5, lr, lsr #10
     8c0:	48020402 	stmdami	r2, {r1, sl}
     8c4:	8a860105 	bhi	fe180ce0 <_bss_end+0xfe176258>
     8c8:	05bb0505 	ldreq	r0, [fp, #1285]!	; 0x505
     8cc:	1d056809 	stcne	8, cr6, [r5, #-36]	; 0xffffffdc
     8d0:	4a21054a 	bmi	841e00 <_bss_end+0x837378>
     8d4:	054a1f05 	strbeq	r1, [sl, #-3845]	; 0xfffff0fb
     8d8:	2a052e35 	bcs	14c1b4 <_bss_end+0x14172c>
     8dc:	2e36054a 	cdpcs	5, 3, cr0, cr6, cr10, {2}
     8e0:	052e3805 	streq	r3, [lr, #-2053]!	; 0xfffff7fb
     8e4:	09054b14 	stmdbeq	r5, {r2, r4, r8, r9, fp, lr}
     8e8:	8614054a 	ldrhi	r0, [r4], -sl, asr #10
     8ec:	4a090567 	bmi	241e90 <_bss_end+0x237408>
     8f0:	05691205 	strbeq	r1, [r9, #-517]!	; 0xfffffdfb
     8f4:	01054c0d 	tsteq	r5, sp, lsl #24
     8f8:	1705692f 	strne	r6, [r5, -pc, lsr #18]
     8fc:	0023059f 	mlaeq	r3, pc, r5, r0	; <UNPREDICTABLE>
     900:	4a030402 	bmi	c1910 <_bss_end+0xb6e88>
     904:	02002505 	andeq	r2, r0, #20971520	; 0x1400000
     908:	05820304 	streq	r0, [r2, #772]	; 0x304
     90c:	04020017 	streq	r0, [r2], #-23	; 0xffffffe9
     910:	05054c02 	streq	r4, [r5, #-3074]	; 0xfffff3fe
     914:	02040200 	andeq	r0, r4, #0, 4
     918:	871605d4 			; <UNDEFINED> instruction: 0x871605d4
     91c:	054c0d05 	strbeq	r0, [ip, #-3333]	; 0xfffff2fb
     920:	05692f01 	strbeq	r2, [r9, #-3841]!	; 0xfffff0ff
     924:	0d059f13 	stceq	15, cr9, [r5, #-76]	; 0xffffffb4
     928:	2f010568 	svccs	0x00010568
     92c:	a3330585 	teqge	r3, #557842432	; 0x21400000
     930:	054a0905 	strbeq	r0, [sl, #-2309]	; 0xfffff6fb
     934:	1605830e 	strne	r8, [r5], -lr, lsl #6
     938:	4c0d0567 	cfstr32mi	mvfx0, [sp], {103}	; 0x67
     93c:	852f0105 	strhi	r0, [pc, #-261]!	; 83f <CPSR_IRQ_INHIBIT+0x7bf>
     940:	05bb0505 	ldreq	r0, [fp, #1285]!	; 0x505
     944:	05866812 	streq	r6, [r6, #2066]	; 0x812
     948:	0d056916 	vstreq.16	s12, [r5, #-44]	; 0xffffffd4	; <UNPREDICTABLE>
     94c:	2f01054c 	svccs	0x0001054c
     950:	d70905a1 	strle	r0, [r9, -r1, lsr #11]
     954:	054c1205 	strbeq	r1, [ip, #-517]	; 0xfffffdfb
     958:	2d056827 	stccs	8, cr6, [r5, #-156]	; 0xffffff64
     95c:	4a1005ba 	bmi	40204c <_bss_end+0x3f75c4>
     960:	052e1105 	streq	r1, [lr, #-261]!	; 0xfffffefb
     964:	13054a2d 	movwne	r4, #23085	; 0x5a2d
     968:	2f0f052e 	svccs	0x000f052e
     96c:	05a00a05 	streq	r0, [r0, #2565]!	; 0xa05
     970:	05366105 	ldreq	r6, [r6, #-261]!	; 0xfffffefb
     974:	11056810 	tstne	r5, r0, lsl r8
     978:	4a22052e 	bmi	881e38 <_bss_end+0x8773b0>
     97c:	052e1305 	streq	r1, [lr, #-773]!	; 0xfffffcfb
     980:	0c052f0a 	stceq	15, cr2, [r5], {10}
     984:	2e0d0569 	cfsh32cs	mvfx0, mvfx13, #57
     988:	054a0f05 	strbeq	r0, [sl, #-3845]	; 0xfffff0fb
     98c:	0e054b06 	vmlaeq.f64	d4, d5, d6
     990:	001d0568 	andseq	r0, sp, r8, ror #10
     994:	4a030402 	bmi	c19a4 <_bss_end+0xb6f1c>
     998:	02001705 	andeq	r1, r0, #1310720	; 0x140000
     99c:	059e0304 	ldreq	r0, [lr, #772]	; 0x304
     9a0:	0402001b 	streq	r0, [r2], #-27	; 0xffffffe5
     9a4:	1e056802 	cdpne	8, 0, cr6, cr5, cr2, {0}
     9a8:	02040200 	andeq	r0, r4, #0, 4
     9ac:	000e0582 	andeq	r0, lr, r2, lsl #11
     9b0:	4a020402 	bmi	819c0 <_bss_end+0x76f38>
     9b4:	02002005 	andeq	r2, r0, #5
     9b8:	054b0204 	strbeq	r0, [fp, #-516]	; 0xfffffdfc
     9bc:	04020021 	streq	r0, [r2], #-33	; 0xffffffdf
     9c0:	12052e02 	andne	r2, r5, #2, 28
     9c4:	02040200 	andeq	r0, r4, #0, 4
     9c8:	0015054a 	andseq	r0, r5, sl, asr #10
     9cc:	82020402 	andhi	r0, r2, #33554432	; 0x2000000
     9d0:	02002105 	andeq	r2, r0, #1073741825	; 0x40000001
     9d4:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
     9d8:	04020017 	streq	r0, [r2], #-23	; 0xffffffe9
     9dc:	10052e02 	andne	r2, r5, r2, lsl #28
     9e0:	02040200 	andeq	r0, r4, #0, 4
     9e4:	0011052f 	andseq	r0, r1, pc, lsr #10
     9e8:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
     9ec:	02001305 	andeq	r1, r0, #335544320	; 0x14000000
     9f0:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
     9f4:	04020005 	streq	r0, [r2], #-5
     9f8:	01054602 	tsteq	r5, r2, lsl #12
     9fc:	009e8288 	addseq	r8, lr, r8, lsl #5
     a00:	06010402 	streq	r0, [r1], -r2, lsl #8
     a04:	06270566 	strteq	r0, [r7], -r6, ror #10
     a08:	827ee103 	rsbshi	lr, lr, #-1073741824	; 0xc0000000
     a0c:	9f030105 	svcls	0x00030105
     a10:	4a9e9e01 	bmi	fe7a821c <_bss_end+0xfe79d794>
     a14:	01000a02 	tsteq	r0, r2, lsl #20
     a18:	00010501 	andeq	r0, r1, r1, lsl #10
     a1c:	91b80205 			; <UNDEFINED> instruction: 0x91b80205
     a20:	0e030000 	cdpeq	0, 0, cr0, cr3, cr0, {0}
     a24:	83100501 	tsthi	r0, #4194304	; 0x400000
     a28:	67010567 	strvs	r0, [r1, -r7, ror #10]
     a2c:	01000802 	tsteq	r0, r2, lsl #16
     a30:	00010501 	andeq	r0, r1, r1, lsl #10
     a34:	91f00205 	mvnsls	r0, r5, lsl #4
     a38:	21030000 	mrscs	r0, (UNDEF: 3)
     a3c:	83120501 	tsthi	r2, #4194304	; 0x400000
     a40:	054a1705 	strbeq	r1, [sl, #-1797]	; 0xfffff8fb
     a44:	14054a05 	strne	r4, [r5], #-2565	; 0xfffff5fb
     a48:	0905674c 	stmdbeq	r5, {r2, r3, r6, r8, r9, sl, sp, lr}
     a4c:	6912054a 	ldmdbvs	r2, {r1, r3, r6, r8, sl}
     a50:	054a1705 	strbeq	r1, [sl, #-1797]	; 0xfffff8fb
     a54:	0f054a05 	svceq	0x00054a05
     a58:	4b16054c 	blmi	581f90 <_bss_end+0x577508>
     a5c:	054a1f05 	strbeq	r1, [sl, #-3845]	; 0xfffff0fb
     a60:	01052e14 	tsteq	r5, r4, lsl lr
     a64:	0006024c 	andeq	r0, r6, ip, asr #4
     a68:	01050101 	tsteq	r5, r1, lsl #2
     a6c:	78020500 	stmdavc	r2, {r8, sl}
     a70:	03000092 	movweq	r0, #146	; 0x92
     a74:	050100c0 	streq	r0, [r1, #-192]	; 0xffffff40
     a78:	01058313 	tsteq	r5, r3, lsl r3
     a7c:	00080267 	andeq	r0, r8, r7, ror #4
     a80:	02960101 	addseq	r0, r6, #1073741824	; 0x40000000
     a84:	00030000 	andeq	r0, r3, r0
     a88:	0000014c 	andeq	r0, r0, ip, asr #2
     a8c:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
     a90:	0101000d 	tsteq	r1, sp
     a94:	00000101 	andeq	r0, r0, r1, lsl #2
     a98:	00000100 	andeq	r0, r0, r0, lsl #2
     a9c:	6e6d2f01 	cdpvs	15, 6, cr2, cr13, cr1, {0}
     aa0:	2f632f74 	svccs	0x00632f74
     aa4:	72657355 	rsbvc	r7, r5, #1409286145	; 0x54000001
     aa8:	754b2f73 	strbvc	r2, [fp, #-3955]	; 0xfffff08d
     aac:	442f6162 	strtmi	r6, [pc], #-354	; ab4 <CPSR_IRQ_INHIBIT+0xa34>
     ab0:	6d75636f 	ldclvs	3, cr6, [r5, #-444]!	; 0xfffffe44
     ab4:	73746e65 	cmnvc	r4, #1616	; 0x650
     ab8:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
     abc:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
     ac0:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
     ac4:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
     ac8:	322f7365 	eorcc	r7, pc, #-1811939327	; 0x94000001
     acc:	41552d30 	cmpmi	r5, r0, lsr sp
     ad0:	675f5452 			; <UNDEFINED> instruction: 0x675f5452
     ad4:	2f656d61 	svccs	0x00656d61
     ad8:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
     adc:	732f6c65 			; <UNDEFINED> instruction: 0x732f6c65
     ae0:	642f6372 	strtvs	r6, [pc], #-882	; ae8 <CPSR_IRQ_INHIBIT+0xa68>
     ae4:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
     ae8:	2f007372 	svccs	0x00007372
     aec:	2f746e6d 	svccs	0x00746e6d
     af0:	73552f63 	cmpvc	r5, #396	; 0x18c
     af4:	2f737265 	svccs	0x00737265
     af8:	6162754b 	cmnvs	r2, fp, asr #10
     afc:	636f442f 	cmnvs	pc, #788529152	; 0x2f000000
     b00:	6e656d75 	mcrvs	13, 3, r6, cr5, cr5, {3}
     b04:	5a2f7374 	bpl	bdd8dc <_bss_end+0xbd2e54>
     b08:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 97c <CPSR_IRQ_INHIBIT+0x8fc>
     b0c:	2f657461 	svccs	0x00657461
     b10:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
     b14:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
     b18:	2d30322f 	lfmcs	f3, 4, [r0, #-188]!	; 0xffffff44
     b1c:	54524155 	ldrbpl	r4, [r2], #-341	; 0xfffffeab
     b20:	6d61675f 	stclvs	7, cr6, [r1, #-380]!	; 0xfffffe84
     b24:	656b2f65 	strbvs	r2, [fp, #-3941]!	; 0xfffff09b
     b28:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
     b2c:	636e692f 	cmnvs	lr, #770048	; 0xbc000
     b30:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
     b34:	616f622f 	cmnvs	pc, pc, lsr #4
     b38:	722f6472 	eorvc	r6, pc, #1912602624	; 0x72000000
     b3c:	2f306970 	svccs	0x00306970
     b40:	006c6168 	rsbeq	r6, ip, r8, ror #2
     b44:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
     b48:	552f632f 	strpl	r6, [pc, #-815]!	; 821 <CPSR_IRQ_INHIBIT+0x7a1>
     b4c:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
     b50:	62754b2f 	rsbsvs	r4, r5, #48128	; 0xbc00
     b54:	6f442f61 	svcvs	0x00442f61
     b58:	656d7563 	strbvs	r7, [sp, #-1379]!	; 0xfffffa9d
     b5c:	2f73746e 	svccs	0x0073746e
     b60:	6f72655a 	svcvs	0x0072655a
     b64:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
     b68:	6178652f 	cmnvs	r8, pc, lsr #10
     b6c:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
     b70:	30322f73 	eorscc	r2, r2, r3, ror pc
     b74:	5241552d 	subpl	r5, r1, #188743680	; 0xb400000
     b78:	61675f54 	cmnvs	r7, r4, asr pc
     b7c:	6b2f656d 	blvs	bda138 <_bss_end+0xbcf6b0>
     b80:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
     b84:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
     b88:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
     b8c:	72642f65 	rsbvc	r2, r4, #404	; 0x194
     b90:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
     b94:	75000073 	strvc	r0, [r0, #-115]	; 0xffffff8d
     b98:	2e747261 	cdpcs	2, 7, cr7, cr4, cr1, {3}
     b9c:	00707063 	rsbseq	r7, r0, r3, rrx
     ba0:	70000001 	andvc	r0, r0, r1
     ba4:	70697265 	rsbvc	r7, r9, r5, ror #4
     ba8:	61726568 	cmnvs	r2, r8, ror #10
     bac:	682e736c 	stmdavs	lr!, {r2, r3, r5, r6, r8, r9, ip, sp, lr}
     bb0:	00000200 	andeq	r0, r0, r0, lsl #4
     bb4:	5f6d6362 	svcpl	0x006d6362
     bb8:	2e787561 	cdpcs	5, 7, cr7, cr8, cr1, {3}
     bbc:	00030068 	andeq	r0, r3, r8, rrx
     bc0:	72617500 	rsbvc	r7, r1, #0, 10
     bc4:	00682e74 	rsbeq	r2, r8, r4, ror lr
     bc8:	69000003 	stmdbvs	r0, {r0, r1}
     bcc:	6564746e 	strbvs	r7, [r4, #-1134]!	; 0xfffffb92
     bd0:	00682e66 	rsbeq	r2, r8, r6, ror #28
     bd4:	00000002 	andeq	r0, r0, r2
     bd8:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
     bdc:	0092a402 	addseq	sl, r2, r2, lsl #8
     be0:	0b051900 	bleq	146fe8 <_bss_end+0x13c560>
     be4:	6805059f 	stmdavs	r5, {r0, r1, r2, r3, r4, r7, r8, sl}
     be8:	054a1005 	strbeq	r1, [sl, #-5]
     bec:	16056805 	strne	r6, [r5], -r5, lsl #16
     bf0:	8305054a 	movwhi	r0, #21834	; 0x554a
     bf4:	054a1605 	strbeq	r1, [sl, #-1541]	; 0xfffff9fb
     bf8:	16058305 	strne	r8, [r5], -r5, lsl #6
     bfc:	8305054a 	movwhi	r0, #21834	; 0x554a
     c00:	054a1605 	strbeq	r1, [sl, #-1541]	; 0xfffff9fb
     c04:	05858301 	streq	r8, [r5, #769]	; 0x301
     c08:	18059f05 	stmdane	r5, {r0, r2, r8, r9, sl, fp, ip, pc}
     c0c:	4a29054b 	bmi	a42140 <_bss_end+0xa376b8>
     c10:	05824005 	streq	r4, [r2, #5]
     c14:	16052e50 			; <UNDEFINED> instruction: 0x16052e50
     c18:	a001052d 	andge	r0, r1, sp, lsr #10
     c1c:	9f1c0569 	svcls	0x001c0569
     c20:	054b2d05 	strbeq	r2, [fp, #-3333]	; 0xfffff2fb
     c24:	18052e53 	stmdane	r5, {r0, r1, r4, r6, r9, sl, fp, sp}
     c28:	4c050582 	cfstr32mi	mvfx0, [r5], {130}	; 0x82
     c2c:	054a1605 	strbeq	r1, [sl, #-1541]	; 0xfffff9fb
     c30:	16058405 	strne	r8, [r5], -r5, lsl #8
     c34:	8405054a 	strhi	r0, [r5], #-1354	; 0xfffffab6
     c38:	054a1605 	strbeq	r1, [sl, #-1541]	; 0xfffff9fb
     c3c:	05a18301 	streq	r8, [r1, #769]!	; 0x301
     c40:	1f05bc0e 	svcne	0x0005bc0e
     c44:	8236054a 	eorshi	r0, r6, #310378496	; 0x12800000
     c48:	052e0c05 	streq	r0, [lr, #-3077]!	; 0xfffff3fb
     c4c:	0531ba05 	ldreq	fp, [r1, #-2565]!	; 0xfffff5fb
     c50:	01054a16 	tsteq	r5, r6, lsl sl
     c54:	0c056983 			; <UNDEFINED> instruction: 0x0c056983
     c58:	001505a1 	andseq	r0, r5, r1, lsr #11
     c5c:	4a030402 	bmi	c1c6c <_bss_end+0xb71e4>
     c60:	02001605 	andeq	r1, r0, #5242880	; 0x500000
     c64:	052e0304 	streq	r0, [lr, #-772]!	; 0xfffffcfc
     c68:	04020018 	streq	r0, [r2], #-24	; 0xffffffe8
     c6c:	13056603 	movwne	r6, #22019	; 0x5603
     c70:	02040200 	andeq	r0, r4, #0, 4
     c74:	0014054b 	andseq	r0, r4, fp, asr #10
     c78:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
     c7c:	02000e05 	andeq	r0, r0, #5, 28	; 0x50
     c80:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
     c84:	04020005 	streq	r0, [r2], #-5
     c88:	01058102 	tsteq	r5, r2, lsl #2
     c8c:	0c056984 			; <UNDEFINED> instruction: 0x0c056984
     c90:	001305bd 			; <UNDEFINED> instruction: 0x001305bd
     c94:	4a030402 	bmi	c1ca4 <_bss_end+0xb721c>
     c98:	02001405 	andeq	r1, r0, #83886080	; 0x5000000
     c9c:	05830204 	streq	r0, [r3, #516]	; 0x204
     ca0:	0402000e 	streq	r0, [r2], #-14
     ca4:	05056602 	streq	r6, [r5, #-1538]	; 0xfffff9fe
     ca8:	02040200 	andeq	r0, r4, #0, 4
     cac:	84010581 	strhi	r0, [r1], #-1409	; 0xfffffa7f
     cb0:	a1090569 	tstge	r9, r9, ror #10
     cb4:	05830a05 	streq	r0, [r3, #2565]	; 0xa05
     cb8:	05856701 	streq	r6, [r5, #1793]	; 0x701
     cbc:	0a05a109 	beq	1690e8 <_bss_end+0x15e660>
     cc0:	67010583 	strvs	r0, [r1, -r3, lsl #11]
     cc4:	9f0e0585 	svcls	0x000e0585
     cc8:	054a1f05 	strbeq	r1, [sl, #-3845]	; 0xfffff0fb
     ccc:	0c058236 	sfmeq	f0, 1, [r5], {54}	; 0x36
     cd0:	ba05052e 	blt	142190 <_bss_end+0x137708>
     cd4:	05320a05 	ldreq	r0, [r2, #-2565]!	; 0xfffff5fb
     cd8:	08054a1b 	stmdaeq	r5, {r0, r1, r3, r4, r9, fp, lr}
     cdc:	67010582 	strvs	r0, [r1, -r2, lsl #11]
     ce0:	83050569 	movwhi	r0, #21865	; 0x5569
     ce4:	054a2d05 	strbeq	r2, [sl, #-3333]	; 0xfffff2fb
     ce8:	16054a3e 			; <UNDEFINED> instruction: 0x16054a3e
     cec:	9f010582 	svcls	0x00010582
     cf0:	83050569 	movwhi	r0, #21865	; 0x5569
     cf4:	054a2d05 	strbeq	r2, [sl, #-3333]	; 0xfffff2fb
     cf8:	16054a3e 			; <UNDEFINED> instruction: 0x16054a3e
     cfc:	9f010582 	svcls	0x00010582
     d00:	02009e66 	andeq	r9, r0, #1632	; 0x660
     d04:	66060104 	strvs	r0, [r6], -r4, lsl #2
     d08:	03061205 	movweq	r1, #25093	; 0x6205
     d0c:	05827fa7 	streq	r7, [r2, #4007]	; 0xfa7
     d10:	00d90301 	sbcseq	r0, r9, r1, lsl #6
     d14:	024aba66 	subeq	fp, sl, #417792	; 0x66000
     d18:	0101000a 	tsteq	r1, sl
     d1c:	00000394 	muleq	r0, r4, r3
     d20:	01b80003 			; <UNDEFINED> instruction: 0x01b80003
     d24:	01020000 	mrseq	r0, (UNDEF: 2)
     d28:	000d0efb 	strdeq	r0, [sp], -fp
     d2c:	01010101 	tsteq	r1, r1, lsl #2
     d30:	01000000 	mrseq	r0, (UNDEF: 0)
     d34:	2f010000 	svccs	0x00010000
     d38:	2f746e6d 	svccs	0x00746e6d
     d3c:	73552f63 	cmpvc	r5, #396	; 0x18c
     d40:	2f737265 	svccs	0x00737265
     d44:	6162754b 	cmnvs	r2, fp, asr #10
     d48:	636f442f 	cmnvs	pc, #788529152	; 0x2f000000
     d4c:	6e656d75 	mcrvs	13, 3, r6, cr5, cr5, {3}
     d50:	5a2f7374 	bpl	bddb28 <_bss_end+0xbd30a0>
     d54:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; bc8 <CPSR_IRQ_INHIBIT+0xb48>
     d58:	2f657461 	svccs	0x00657461
     d5c:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
     d60:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
     d64:	2d30322f 	lfmcs	f3, 4, [r0, #-188]!	; 0xffffff44
     d68:	54524155 	ldrbpl	r4, [r2], #-341	; 0xfffffeab
     d6c:	6d61675f 	stclvs	7, cr6, [r1, #-380]!	; 0xfffffe84
     d70:	656b2f65 	strbvs	r2, [fp, #-3941]!	; 0xfffff09b
     d74:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
     d78:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
     d7c:	6e6d2f00 	cdpvs	15, 6, cr2, cr13, cr0, {0}
     d80:	2f632f74 	svccs	0x00632f74
     d84:	72657355 	rsbvc	r7, r5, #1409286145	; 0x54000001
     d88:	754b2f73 	strbvc	r2, [fp, #-3955]	; 0xfffff08d
     d8c:	442f6162 	strtmi	r6, [pc], #-354	; d94 <CPSR_IRQ_INHIBIT+0xd14>
     d90:	6d75636f 	ldclvs	3, cr6, [r5, #-444]!	; 0xfffffe44
     d94:	73746e65 	cmnvc	r4, #1616	; 0x650
     d98:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
     d9c:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
     da0:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
     da4:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
     da8:	322f7365 	eorcc	r7, pc, #-1811939327	; 0x94000001
     dac:	41552d30 	cmpmi	r5, r0, lsr sp
     db0:	675f5452 			; <UNDEFINED> instruction: 0x675f5452
     db4:	2f656d61 	svccs	0x00656d61
     db8:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
     dbc:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
     dc0:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
     dc4:	622f6564 	eorvs	r6, pc, #100, 10	; 0x19000000
     dc8:	6472616f 	ldrbtvs	r6, [r2], #-367	; 0xfffffe91
     dcc:	6970722f 	ldmdbvs	r0!, {r0, r1, r2, r3, r5, r9, ip, sp, lr}^
     dd0:	61682f30 	cmnvs	r8, r0, lsr pc
     dd4:	6d2f006c 	stcvs	0, cr0, [pc, #-432]!	; c2c <CPSR_IRQ_INHIBIT+0xbac>
     dd8:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
     ddc:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
     de0:	4b2f7372 	blmi	bddbb0 <_bss_end+0xbd3128>
     de4:	2f616275 	svccs	0x00616275
     de8:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
     dec:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
     df0:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
     df4:	614d6f72 	hvcvs	55026	; 0xd6f2
     df8:	652f6574 	strvs	r6, [pc, #-1396]!	; 88c <CPSR_IRQ_INHIBIT+0x80c>
     dfc:	706d6178 	rsbvc	r6, sp, r8, ror r1
     e00:	2f73656c 	svccs	0x0073656c
     e04:	552d3032 	strpl	r3, [sp, #-50]!	; 0xffffffce
     e08:	5f545241 	svcpl	0x00545241
     e0c:	656d6167 	strbvs	r6, [sp, #-359]!	; 0xfffffe99
     e10:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
     e14:	2f6c656e 	svccs	0x006c656e
     e18:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
     e1c:	2f656475 	svccs	0x00656475
     e20:	76697264 	strbtvc	r7, [r9], -r4, ror #4
     e24:	00737265 	rsbseq	r7, r3, r5, ror #4
     e28:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
     e2c:	552f632f 	strpl	r6, [pc, #-815]!	; b05 <CPSR_IRQ_INHIBIT+0xa85>
     e30:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
     e34:	62754b2f 	rsbsvs	r4, r5, #48128	; 0xbc00
     e38:	6f442f61 	svcvs	0x00442f61
     e3c:	656d7563 	strbvs	r7, [sp, #-1379]!	; 0xfffffa9d
     e40:	2f73746e 	svccs	0x0073746e
     e44:	6f72655a 	svcvs	0x0072655a
     e48:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
     e4c:	6178652f 	cmnvs	r8, pc, lsr #10
     e50:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
     e54:	30322f73 	eorscc	r2, r2, r3, ror pc
     e58:	5241552d 	subpl	r5, r1, #188743680	; 0xb400000
     e5c:	61675f54 	cmnvs	r7, r4, asr pc
     e60:	6b2f656d 	blvs	bda41c <_bss_end+0xbcf994>
     e64:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
     e68:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
     e6c:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
     e70:	69000065 	stmdbvs	r0, {r0, r2, r5, r6}
     e74:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
     e78:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
     e7c:	6e6f635f 	mcrvs	3, 3, r6, cr15, cr15, {2}
     e80:	6c6f7274 	sfmvs	f7, 2, [pc], #-464	; cb8 <CPSR_IRQ_INHIBIT+0xc38>
     e84:	2e72656c 	cdpcs	5, 7, cr6, cr2, cr12, {3}
     e88:	00707063 	rsbseq	r7, r0, r3, rrx
     e8c:	70000001 	andvc	r0, r0, r1
     e90:	70697265 	rsbvc	r7, r9, r5, ror #4
     e94:	61726568 	cmnvs	r2, r8, ror #10
     e98:	682e736c 	stmdavs	lr!, {r2, r3, r5, r6, r8, r9, ip, sp, lr}
     e9c:	00000200 	andeq	r0, r0, r0, lsl #4
     ea0:	5f6d6362 	svcpl	0x006d6362
     ea4:	2e787561 	cdpcs	5, 7, cr7, cr8, cr1, {3}
     ea8:	00030068 	andeq	r0, r3, r8, rrx
     eac:	72617500 	rsbvc	r7, r1, #0, 10
     eb0:	00682e74 	rsbeq	r2, r8, r4, ror lr
     eb4:	69000003 	stmdbvs	r0, {r0, r1}
     eb8:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
     ebc:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
     ec0:	6e6f635f 	mcrvs	3, 3, r6, cr15, cr15, {2}
     ec4:	6c6f7274 	sfmvs	f7, 2, [pc], #-464	; cfc <CPSR_IRQ_INHIBIT+0xc7c>
     ec8:	2e72656c 	cdpcs	5, 7, cr6, cr2, cr12, {3}
     ecc:	00040068 	andeq	r0, r4, r8, rrx
     ed0:	746e6900 	strbtvc	r6, [lr], #-2304	; 0xfffff700
     ed4:	2e666564 	cdpcs	5, 6, cr6, cr6, cr4, {3}
     ed8:	00020068 	andeq	r0, r2, r8, rrx
     edc:	01050000 	mrseq	r0, (UNDEF: 5)
     ee0:	8c020500 	cfstr32hi	mvfx0, [r2], {-0}
     ee4:	03000097 	movweq	r0, #151	; 0x97
     ee8:	0d05010c 	stfeqs	f0, [r5, #-48]	; 0xffffffd0
     eec:	4a0505a1 	bmi	142578 <_bss_end+0x137af0>
     ef0:	05d90d05 	ldrbeq	r0, [r9, #3333]	; 0xd05
     ef4:	0402001a 	streq	r0, [r2], #-26	; 0xffffffe6
     ef8:	1c056601 	stcne	6, cr6, [r5], {1}
     efc:	671d0568 	ldrvs	r0, [sp, -r8, ror #10]
     f00:	671c0586 	ldrvs	r0, [ip, -r6, lsl #11]
     f04:	05671105 	strbeq	r1, [r7, #-261]!	; 0xfffffefb
     f08:	21053219 	tstcs	r5, r9, lsl r2
     f0c:	4a2b0567 	bmi	ac24b0 <_bss_end+0xab7a28>
     f10:	054a2905 	strbeq	r2, [sl, #-2309]	; 0xfffff6fb
     f14:	16052e34 			; <UNDEFINED> instruction: 0x16052e34
     f18:	4a1e052e 	bmi	7823d8 <_bss_end+0x777950>
     f1c:	052e1405 	streq	r1, [lr, #-1029]!	; 0xfffffbfb
     f20:	059f4b19 	ldreq	r4, [pc, #2841]	; 1a41 <CPSR_IRQ_INHIBIT+0x19c1>
     f24:	0d056718 	stceq	7, cr6, [r5, #-96]	; 0xffffffa0
     f28:	1a053167 	bne	14d4cc <_bss_end+0x142a44>
     f2c:	01040200 	mrseq	r0, R12_usr
     f30:	681c0566 	ldmdavs	ip, {r1, r2, r5, r6, r8, sl}
     f34:	054a2305 	strbeq	r2, [sl, #-773]	; 0xfffffcfb
     f38:	059f2e19 	ldreq	r2, [pc, #3609]	; 1d59 <CPSR_IRQ_INHIBIT+0x1cd9>
     f3c:	22056a1b 	andcs	r6, r5, #110592	; 0x1b000
     f40:	2e19054a 	cfmac32cs	mvfx0, mvfx9, mvfx10
     f44:	4d11054b 	cfldr32mi	mvfx0, [r1, #-300]	; 0xfffffed4
     f48:	054a1b05 	strbeq	r1, [sl, #-2821]	; 0xfffff4fb
     f4c:	0d054a19 	vstreq	s8, [r5, #-100]	; 0xffffff9c
     f50:	4c1d0582 	cfldr32mi	mvfx0, [sp], {130}	; 0x82
     f54:	00290567 	eoreq	r0, r9, r7, ror #10
     f58:	66010402 	strvs	r0, [r1], -r2, lsl #8
     f5c:	02001d05 	andeq	r1, r0, #320	; 0x140
     f60:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
     f64:	04020038 	streq	r0, [r2], #-56	; 0xffffffc8
     f68:	1d054a02 	vstrne	s8, [r5, #-8]
     f6c:	02040200 	andeq	r0, r4, #0, 4
     f70:	0402004a 	streq	r0, [r2], #-74	; 0xffffffb6
     f74:	002e0604 	eoreq	r0, lr, r4, lsl #12
     f78:	06040402 	streq	r0, [r4], -r2, lsl #8
     f7c:	04020067 	streq	r0, [r2], #-103	; 0xffffff99
     f80:	1c056704 	stcne	7, cr6, [r5], {4}
     f84:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
     f88:	00110567 	andseq	r0, r1, r7, ror #10
     f8c:	67040402 	strvs	r0, [r4, -r2, lsl #8]
     f90:	05312105 	ldreq	r2, [r1, #-261]!	; 0xfffffefb
     f94:	29054a2b 	stmdbcs	r5, {r0, r1, r3, r5, r9, fp, lr}
     f98:	2e34054a 	cdpcs	5, 3, cr0, cr4, cr10, {2}
     f9c:	052e1605 	streq	r1, [lr, #-1541]!	; 0xfffff9fb
     fa0:	14054a1e 	strne	r4, [r5], #-2590	; 0xfffff5e2
     fa4:	4b19052e 	blmi	642464 <_bss_end+0x6379dc>
     fa8:	0d059f67 	stceq	15, cr9, [r5, #-412]	; 0xfffffe64
     fac:	1a053168 	bne	14d554 <_bss_end+0x142acc>
     fb0:	01040200 	mrseq	r0, R12_usr
     fb4:	68190566 	ldmdavs	r9, {r1, r2, r5, r6, r8, sl}
     fb8:	681d0567 	ldmdavs	sp, {r0, r1, r2, r5, r6, r8, sl}
     fbc:	05672505 	strbeq	r2, [r7, #-1285]!	; 0xfffffafb
     fc0:	2d054a2f 	vstrcs	s8, [r5, #-188]	; 0xffffff44
     fc4:	2e38054a 	cdpcs	5, 3, cr0, cr8, cr10, {2}
     fc8:	052e1a05 	streq	r1, [lr, #-2565]!	; 0xfffff5fb
     fcc:	18054a22 	stmdane	r5, {r1, r5, r9, fp, lr}
     fd0:	4b1d052e 	blmi	742490 <_bss_end+0x737a08>
     fd4:	671c059f 			; <UNDEFINED> instruction: 0x671c059f
     fd8:	056d0d05 	strbeq	r0, [sp, #-3333]!	; 0xfffff2fb
     fdc:	1c052b1d 			; <UNDEFINED> instruction: 0x1c052b1d
     fe0:	680d0567 	stmdavs	sp, {r0, r1, r2, r5, r6, r8, sl}
     fe4:	30010531 	andcc	r0, r1, r1, lsr r5
     fe8:	854be708 	strbhi	lr, [fp, #-1800]	; 0xfffff8f8
     fec:	05851005 	streq	r1, [r5, #5]
     ff0:	01058312 	tsteq	r5, r2, lsl r3
     ff4:	6a2f8567 	bvs	be2598 <_bss_end+0xbd7b10>
     ff8:	059f1305 	ldreq	r1, [pc, #773]	; 1305 <CPSR_IRQ_INHIBIT+0x1285>
     ffc:	01052e38 	tsteq	r5, r8, lsr lr
    1000:	0c05a14c 	stfeqd	f2, [r5], {76}	; 0x4c
    1004:	4a1c059f 	bmi	702688 <_bss_end+0x6f7c00>
    1008:	052e3a05 	streq	r3, [lr, #-2565]!	; 0xfffff5fb
    100c:	05854b01 	streq	r4, [r5, #2817]	; 0xb01
    1010:	40059f43 	andmi	r9, r5, r3, asr #30
    1014:	4a39052e 	bmi	e424d4 <_bss_end+0xe37a4c>
    1018:	05824005 	streq	r4, [r2, #5]
    101c:	01052e3b 	tsteq	r5, fp, lsr lr
    1020:	4405692f 	strmi	r6, [r5], #-2351	; 0xfffff6d1
    1024:	2e41059f 	mcrcs	5, 2, r0, cr1, cr15, {4}
    1028:	054a3a05 	strbeq	r3, [sl, #-2565]	; 0xfffff5fb
    102c:	3c058241 	sfmcc	f0, 1, [r5], {65}	; 0x41
    1030:	2f01052e 	svccs	0x0001052e
    1034:	9f180569 	svcls	0x00180569
    1038:	054d1505 	strbeq	r1, [sp, #-1285]	; 0xfffffafb
    103c:	73054a08 	movwvc	r4, #23048	; 0x5a08
    1040:	04020049 	streq	r0, [r2], #-73	; 0xffffffb7
    1044:	00660601 	rsbeq	r0, r6, r1, lsl #12
    1048:	4a020402 	bmi	82058 <_bss_end+0x775d0>
    104c:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
    1050:	0008052e 	andeq	r0, r8, lr, lsr #10
    1054:	06040402 	streq	r0, [r4], -r2, lsl #8
    1058:	00750583 	rsbseq	r0, r5, r3, lsl #11
    105c:	2d040402 	cfstrscs	mvf0, [r4, #-8]
    1060:	02000105 	andeq	r0, r0, #1073741825	; 0x40000001
    1064:	69300404 	ldmdbvs	r0!, {r2, sl}
    1068:	059f1805 	ldreq	r1, [pc, #2053]	; 1875 <CPSR_IRQ_INHIBIT+0x17f5>
    106c:	08054d15 	stmdaeq	r5, {r0, r2, r4, r8, sl, fp, lr}
    1070:	4975054a 	ldmdbmi	r5!, {r1, r3, r6, r8, sl}^
    1074:	01040200 	mrseq	r0, R12_usr
    1078:	02006606 	andeq	r6, r0, #6291456	; 0x600000
    107c:	004a0204 	subeq	r0, sl, r4, lsl #4
    1080:	2e040402 	cdpcs	4, 0, cr0, cr4, cr2, {0}
    1084:	02000805 	andeq	r0, r0, #327680	; 0x50000
    1088:	83060404 	movwhi	r0, #25604	; 0x6404
    108c:	02007705 	andeq	r7, r0, #1310720	; 0x140000
    1090:	052d0404 	streq	r0, [sp, #-1028]!	; 0xfffffbfc
    1094:	04020001 	streq	r0, [r2], #-1
    1098:	9e663004 	cdpls	0, 6, cr3, cr6, cr4, {0}
    109c:	01040200 	mrseq	r0, R12_usr
    10a0:	43056606 	movwmi	r6, #22022	; 0x5606
    10a4:	825c0306 	subshi	r0, ip, #402653184	; 0x18000000
    10a8:	24030105 	strcs	r0, [r3], #-261	; 0xfffffefb
    10ac:	024aba66 	subeq	fp, sl, #417792	; 0x66000
    10b0:	0101000a 	tsteq	r1, sl
    10b4:	000001d8 	ldrdeq	r0, [r0], -r8
    10b8:	01a80003 			; <UNDEFINED> instruction: 0x01a80003
    10bc:	01020000 	mrseq	r0, (UNDEF: 2)
    10c0:	000d0efb 	strdeq	r0, [sp], -fp
    10c4:	01010101 	tsteq	r1, r1, lsl #2
    10c8:	01000000 	mrseq	r0, (UNDEF: 0)
    10cc:	2f010000 	svccs	0x00010000
    10d0:	2f746e6d 	svccs	0x00746e6d
    10d4:	73552f63 	cmpvc	r5, #396	; 0x18c
    10d8:	2f737265 	svccs	0x00737265
    10dc:	6162754b 	cmnvs	r2, fp, asr #10
    10e0:	636f442f 	cmnvs	pc, #788529152	; 0x2f000000
    10e4:	6e656d75 	mcrvs	13, 3, r6, cr5, cr5, {3}
    10e8:	5a2f7374 	bpl	bddec0 <_bss_end+0xbd3438>
    10ec:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; f60 <CPSR_IRQ_INHIBIT+0xee0>
    10f0:	2f657461 	svccs	0x00657461
    10f4:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
    10f8:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
    10fc:	2d30322f 	lfmcs	f3, 4, [r0, #-188]!	; 0xffffff44
    1100:	54524155 	ldrbpl	r4, [r2], #-341	; 0xfffffeab
    1104:	6d61675f 	stclvs	7, cr6, [r1, #-380]!	; 0xfffffe84
    1108:	656b2f65 	strbvs	r2, [fp, #-3941]!	; 0xfffff09b
    110c:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
    1110:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
    1114:	6e6d2f00 	cdpvs	15, 6, cr2, cr13, cr0, {0}
    1118:	2f632f74 	svccs	0x00632f74
    111c:	72657355 	rsbvc	r7, r5, #1409286145	; 0x54000001
    1120:	754b2f73 	strbvc	r2, [fp, #-3955]	; 0xfffff08d
    1124:	442f6162 	strtmi	r6, [pc], #-354	; 112c <CPSR_IRQ_INHIBIT+0x10ac>
    1128:	6d75636f 	ldclvs	3, cr6, [r5, #-444]!	; 0xfffffe44
    112c:	73746e65 	cmnvc	r4, #1616	; 0x650
    1130:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
    1134:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
    1138:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
    113c:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
    1140:	322f7365 	eorcc	r7, pc, #-1811939327	; 0x94000001
    1144:	41552d30 	cmpmi	r5, r0, lsr sp
    1148:	675f5452 			; <UNDEFINED> instruction: 0x675f5452
    114c:	2f656d61 	svccs	0x00656d61
    1150:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
    1154:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
    1158:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
    115c:	622f6564 	eorvs	r6, pc, #100, 10	; 0x19000000
    1160:	6472616f 	ldrbtvs	r6, [r2], #-367	; 0xfffffe91
    1164:	6970722f 	ldmdbvs	r0!, {r0, r1, r2, r3, r5, r9, ip, sp, lr}^
    1168:	61682f30 	cmnvs	r8, r0, lsr pc
    116c:	6d2f006c 	stcvs	0, cr0, [pc, #-432]!	; fc4 <CPSR_IRQ_INHIBIT+0xf44>
    1170:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
    1174:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
    1178:	4b2f7372 	blmi	bddf48 <_bss_end+0xbd34c0>
    117c:	2f616275 	svccs	0x00616275
    1180:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
    1184:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
    1188:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
    118c:	614d6f72 	hvcvs	55026	; 0xd6f2
    1190:	652f6574 	strvs	r6, [pc, #-1396]!	; c24 <CPSR_IRQ_INHIBIT+0xba4>
    1194:	706d6178 	rsbvc	r6, sp, r8, ror r1
    1198:	2f73656c 	svccs	0x0073656c
    119c:	552d3032 	strpl	r3, [sp, #-50]!	; 0xffffffce
    11a0:	5f545241 	svcpl	0x00545241
    11a4:	656d6167 	strbvs	r6, [sp, #-359]!	; 0xfffffe99
    11a8:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
    11ac:	2f6c656e 	svccs	0x006c656e
    11b0:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
    11b4:	2f656475 	svccs	0x00656475
    11b8:	76697264 	strbtvc	r7, [r9], -r4, ror #4
    11bc:	00737265 	rsbseq	r7, r3, r5, ror #4
    11c0:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
    11c4:	552f632f 	strpl	r6, [pc, #-815]!	; e9d <CPSR_IRQ_INHIBIT+0xe1d>
    11c8:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
    11cc:	62754b2f 	rsbsvs	r4, r5, #48128	; 0xbc00
    11d0:	6f442f61 	svcvs	0x00442f61
    11d4:	656d7563 	strbvs	r7, [sp, #-1379]!	; 0xfffffa9d
    11d8:	2f73746e 	svccs	0x0073746e
    11dc:	6f72655a 	svcvs	0x0072655a
    11e0:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
    11e4:	6178652f 	cmnvs	r8, pc, lsr #10
    11e8:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
    11ec:	30322f73 	eorscc	r2, r2, r3, ror pc
    11f0:	5241552d 	subpl	r5, r1, #188743680	; 0xb400000
    11f4:	61675f54 	cmnvs	r7, r4, asr pc
    11f8:	6b2f656d 	blvs	bda7b4 <_bss_end+0xbcfd2c>
    11fc:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
    1200:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
    1204:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
    1208:	6d000065 	stcvs	0, cr0, [r0, #-404]	; 0xfffffe6c
    120c:	2e6e6961 	vnmulcs.f16	s13, s28, s3	; <UNPREDICTABLE>
    1210:	00707063 	rsbseq	r7, r0, r3, rrx
    1214:	70000001 	andvc	r0, r0, r1
    1218:	70697265 	rsbvc	r7, r9, r5, ror #4
    121c:	61726568 	cmnvs	r2, r8, ror #10
    1220:	682e736c 	stmdavs	lr!, {r2, r3, r5, r6, r8, r9, ip, sp, lr}
    1224:	00000200 	andeq	r0, r0, r0, lsl #4
    1228:	5f6d6362 	svcpl	0x006d6362
    122c:	2e787561 	cdpcs	5, 7, cr7, cr8, cr1, {3}
    1230:	00030068 	andeq	r0, r3, r8, rrx
    1234:	72617500 	rsbvc	r7, r1, #0, 10
    1238:	00682e74 	rsbeq	r2, r8, r4, ror lr
    123c:	69000003 	stmdbvs	r0, {r0, r1}
    1240:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
    1244:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
    1248:	6e6f635f 	mcrvs	3, 3, r6, cr15, cr15, {2}
    124c:	6c6f7274 	sfmvs	f7, 2, [pc], #-464	; 1084 <CPSR_IRQ_INHIBIT+0x1004>
    1250:	2e72656c 	cdpcs	5, 7, cr6, cr2, cr12, {3}
    1254:	00040068 	andeq	r0, r4, r8, rrx
    1258:	746e6900 	strbtvc	r6, [lr], #-2304	; 0xfffff700
    125c:	2e666564 	cdpcs	5, 6, cr6, cr6, cr4, {3}
    1260:	00020068 	andeq	r0, r2, r8, rrx
    1264:	01050000 	mrseq	r0, (UNDEF: 5)
    1268:	58020500 	stmdapl	r2, {r8, sl}
    126c:	1700009d 			; <UNDEFINED> instruction: 0x1700009d
    1270:	054b1d05 	strbeq	r1, [fp, #-3333]	; 0xfffff2fb
    1274:	1b056819 	blne	15b2e0 <_bss_end+0x150858>
    1278:	681e0567 	ldmdavs	lr, {r0, r1, r2, r5, r6, r8, sl}
    127c:	054c0f05 	strbeq	r0, [ip, #-3845]	; 0xfffff0fb
    1280:	67673011 			; <UNDEFINED> instruction: 0x67673011
    1284:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
    1288:	02680104 	rsbeq	r0, r8, #4, 2
    128c:	0101000e 	tsteq	r1, lr
    1290:	000000af 	andeq	r0, r0, pc, lsr #1
    1294:	00640003 	rsbeq	r0, r4, r3
    1298:	01020000 	mrseq	r0, (UNDEF: 2)
    129c:	000d0efb 	strdeq	r0, [sp], -fp
    12a0:	01010101 	tsteq	r1, r1, lsl #2
    12a4:	01000000 	mrseq	r0, (UNDEF: 0)
    12a8:	2f010000 	svccs	0x00010000
    12ac:	2f746e6d 	svccs	0x00746e6d
    12b0:	73552f63 	cmpvc	r5, #396	; 0x18c
    12b4:	2f737265 	svccs	0x00737265
    12b8:	6162754b 	cmnvs	r2, fp, asr #10
    12bc:	636f442f 	cmnvs	pc, #788529152	; 0x2f000000
    12c0:	6e656d75 	mcrvs	13, 3, r6, cr5, cr5, {3}
    12c4:	5a2f7374 	bpl	bde09c <_bss_end+0xbd3614>
    12c8:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 113c <CPSR_IRQ_INHIBIT+0x10bc>
    12cc:	2f657461 	svccs	0x00657461
    12d0:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
    12d4:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
    12d8:	2d30322f 	lfmcs	f3, 4, [r0, #-188]!	; 0xffffff44
    12dc:	54524155 	ldrbpl	r4, [r2], #-341	; 0xfffffeab
    12e0:	6d61675f 	stclvs	7, cr6, [r1, #-380]!	; 0xfffffe84
    12e4:	656b2f65 	strbvs	r2, [fp, #-3941]!	; 0xfffff09b
    12e8:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
    12ec:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
    12f0:	74730000 	ldrbtvc	r0, [r3], #-0
    12f4:	2e747261 	cdpcs	2, 7, cr7, cr4, cr1, {3}
    12f8:	00010073 	andeq	r0, r1, r3, ror r0
    12fc:	05000000 	streq	r0, [r0, #-0]
    1300:	00800002 	addeq	r0, r0, r2
    1304:	010d0300 	mrseq	r0, SP_mon
    1308:	2f2f2f2f 	svccs	0x002f2f2f
    130c:	032f2f2f 			; <UNDEFINED> instruction: 0x032f2f2f
    1310:	3120081d 			; <UNDEFINED> instruction: 0x3120081d
    1314:	2f2f322f 	svccs	0x002f322f
    1318:	2f2f312f 	svccs	0x002f312f
    131c:	312f2f31 			; <UNDEFINED> instruction: 0x312f2f31
    1320:	2f302f2f 	svccs	0x00302f2f
    1324:	02302f2f 	eorseq	r2, r0, #47, 30	; 0xbc
    1328:	01010002 	tsteq	r1, r2
    132c:	d0020500 	andle	r0, r2, r0, lsl #10
    1330:	0300009d 	movweq	r0, #157	; 0x9d
    1334:	2f0100d9 	svccs	0x000100d9
    1338:	312f2f2f 			; <UNDEFINED> instruction: 0x312f2f2f
    133c:	02023333 	andeq	r3, r2, #-872415232	; 0xcc000000
    1340:	e9010100 	stmdb	r1, {r8}
    1344:	03000000 	movweq	r0, #0
    1348:	00006800 	andeq	r6, r0, r0, lsl #16
    134c:	fb010200 	blx	41b56 <_bss_end+0x370ce>
    1350:	01000d0e 	tsteq	r0, lr, lsl #26
    1354:	00010101 	andeq	r0, r1, r1, lsl #2
    1358:	00010000 	andeq	r0, r1, r0
    135c:	6d2f0100 	stfvss	f0, [pc, #-0]	; 1364 <CPSR_IRQ_INHIBIT+0x12e4>
    1360:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
    1364:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
    1368:	4b2f7372 	blmi	bde138 <_bss_end+0xbd36b0>
    136c:	2f616275 	svccs	0x00616275
    1370:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
    1374:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
    1378:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
    137c:	614d6f72 	hvcvs	55026	; 0xd6f2
    1380:	652f6574 	strvs	r6, [pc, #-1396]!	; e14 <CPSR_IRQ_INHIBIT+0xd94>
    1384:	706d6178 	rsbvc	r6, sp, r8, ror r1
    1388:	2f73656c 	svccs	0x0073656c
    138c:	552d3032 	strpl	r3, [sp, #-50]!	; 0xffffffce
    1390:	5f545241 	svcpl	0x00545241
    1394:	656d6167 	strbvs	r6, [sp, #-359]!	; 0xfffffe99
    1398:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
    139c:	2f6c656e 	svccs	0x006c656e
    13a0:	00637273 	rsbeq	r7, r3, r3, ror r2
    13a4:	61747300 	cmnvs	r4, r0, lsl #6
    13a8:	70757472 	rsbsvc	r7, r5, r2, ror r4
    13ac:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
    13b0:	00000100 	andeq	r0, r0, r0, lsl #2
    13b4:	00010500 	andeq	r0, r1, r0, lsl #10
    13b8:	9df00205 	lfmls	f0, 2, [r0, #20]!
    13bc:	14030000 	strne	r0, [r3], #-0
    13c0:	6a0c0501 	bvs	3027cc <_bss_end+0x2f7d44>
    13c4:	02002205 	andeq	r2, r0, #1342177280	; 0x50000000
    13c8:	05660304 	strbeq	r0, [r6, #-772]!	; 0xfffffcfc
    13cc:	0402000c 	streq	r0, [r2], #-12
    13d0:	0505bb02 	streq	fp, [r5, #-2818]	; 0xfffff4fe
    13d4:	02040200 	andeq	r0, r4, #0, 4
    13d8:	850c0565 	strhi	r0, [ip, #-1381]	; 0xfffffa9b
    13dc:	bd2f0105 	stflts	f0, [pc, #-20]!	; 13d0 <CPSR_IRQ_INHIBIT+0x1350>
    13e0:	056b1005 	strbeq	r1, [fp, #-5]!
    13e4:	04020027 	streq	r0, [r2], #-39	; 0xffffffd9
    13e8:	0a054a03 	beq	153bfc <_bss_end+0x149174>
    13ec:	02040200 	andeq	r0, r4, #0, 4
    13f0:	00110583 	andseq	r0, r1, r3, lsl #11
    13f4:	4a020402 	bmi	82404 <_bss_end+0x7797c>
    13f8:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
    13fc:	052d0204 	streq	r0, [sp, #-516]!	; 0xfffffdfc
    1400:	0105850c 	tsteq	r5, ip, lsl #10
    1404:	1005a12f 	andne	sl, r5, pc, lsr #2
    1408:	0027056a 	eoreq	r0, r7, sl, ror #10
    140c:	4a030402 	bmi	c241c <_bss_end+0xb7994>
    1410:	02000a05 	andeq	r0, r0, #20480	; 0x5000
    1414:	05830204 	streq	r0, [r3, #516]	; 0x204
    1418:	04020011 	streq	r0, [r2], #-17	; 0xffffffef
    141c:	05054a02 	streq	r4, [r5, #-2562]	; 0xfffff5fe
    1420:	02040200 	andeq	r0, r4, #0, 4
    1424:	850c052d 	strhi	r0, [ip, #-1325]	; 0xfffffad3
    1428:	022f0105 	eoreq	r0, pc, #1073741825	; 0x40000001
    142c:	0101000a 	tsteq	r1, sl
    1430:	0000028d 	andeq	r0, r0, sp, lsl #5
    1434:	006a0003 	rsbeq	r0, sl, r3
    1438:	01020000 	mrseq	r0, (UNDEF: 2)
    143c:	000d0efb 	strdeq	r0, [sp], -fp
    1440:	01010101 	tsteq	r1, r1, lsl #2
    1444:	01000000 	mrseq	r0, (UNDEF: 0)
    1448:	2f010000 	svccs	0x00010000
    144c:	2f746e6d 	svccs	0x00746e6d
    1450:	73552f63 	cmpvc	r5, #396	; 0x18c
    1454:	2f737265 	svccs	0x00737265
    1458:	6162754b 	cmnvs	r2, fp, asr #10
    145c:	636f442f 	cmnvs	pc, #788529152	; 0x2f000000
    1460:	6e656d75 	mcrvs	13, 3, r6, cr5, cr5, {3}
    1464:	5a2f7374 	bpl	bde23c <_bss_end+0xbd37b4>
    1468:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 12dc <CPSR_IRQ_INHIBIT+0x125c>
    146c:	2f657461 	svccs	0x00657461
    1470:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
    1474:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
    1478:	2d30322f 	lfmcs	f3, 4, [r0, #-188]!	; 0xffffff44
    147c:	54524155 	ldrbpl	r4, [r2], #-341	; 0xfffffeab
    1480:	6d61675f 	stclvs	7, cr6, [r1, #-380]!	; 0xfffffe84
    1484:	74732f65 	ldrbtvc	r2, [r3], #-3941	; 0xfffff09b
    1488:	62696c64 	rsbvs	r6, r9, #100, 24	; 0x6400
    148c:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
    1490:	74730000 	ldrbtvc	r0, [r3], #-0
    1494:	72747364 	rsbsvc	r7, r4, #100, 6	; 0x90000001
    1498:	2e676e69 	cdpcs	14, 6, cr6, cr7, cr9, {3}
    149c:	00707063 	rsbseq	r7, r0, r3, rrx
    14a0:	00000001 	andeq	r0, r0, r1
    14a4:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
    14a8:	009f0802 	addseq	r0, pc, r2, lsl #16
    14ac:	09051a00 	stmdbeq	r5, {r9, fp, ip}
    14b0:	4c1205bb 	cfldr32mi	mvfx0, [r2], {187}	; 0xbb
    14b4:	05682705 	strbeq	r2, [r8, #-1797]!	; 0xfffff8fb
    14b8:	1105ba10 	tstne	r5, r0, lsl sl
    14bc:	4a2d052e 	bmi	b4297c <_bss_end+0xb37ef4>
    14c0:	054a1305 	strbeq	r1, [sl, #-773]	; 0xfffffcfb
    14c4:	0a052f0f 	beq	14d108 <_bss_end+0x142680>
    14c8:	6205059f 	andvs	r0, r5, #666894336	; 0x27c00000
    14cc:	68100535 	ldmdavs	r0, {r0, r2, r4, r5, r8, sl}
    14d0:	052e1105 	streq	r1, [lr, #-261]!	; 0xfffffefb
    14d4:	13054a22 	movwne	r4, #23074	; 0x5a22
    14d8:	2f0a052e 	svccs	0x000a052e
    14dc:	05690c05 	strbeq	r0, [r9, #-3077]!	; 0xfffff3fb
    14e0:	0f052e0d 	svceq	0x00052e0d
    14e4:	4b06054a 	blmi	182a14 <_bss_end+0x177f8c>
    14e8:	05680e05 	strbeq	r0, [r8, #-3589]!	; 0xfffff1fb
    14ec:	0402001c 	streq	r0, [r2], #-28	; 0xffffffe4
    14f0:	17054a03 	strne	r4, [r5, -r3, lsl #20]
    14f4:	03040200 	movweq	r0, #16896	; 0x4200
    14f8:	001b059e 	mulseq	fp, lr, r5
    14fc:	68020402 	stmdavs	r2, {r1, sl}
    1500:	02001e05 	andeq	r1, r0, #5, 28	; 0x50
    1504:	05820204 	streq	r0, [r2, #516]	; 0x204
    1508:	0402000e 	streq	r0, [r2], #-14
    150c:	20054a02 	andcs	r4, r5, r2, lsl #20
    1510:	02040200 	andeq	r0, r4, #0, 4
    1514:	0021054b 	eoreq	r0, r1, fp, asr #10
    1518:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
    151c:	02001205 	andeq	r1, r0, #1342177280	; 0x50000000
    1520:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
    1524:	04020015 	streq	r0, [r2], #-21	; 0xffffffeb
    1528:	21058202 	tstcs	r5, r2, lsl #4
    152c:	02040200 	andeq	r0, r4, #0, 4
    1530:	0017054a 	andseq	r0, r7, sl, asr #10
    1534:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
    1538:	02001005 	andeq	r1, r0, #5
    153c:	052f0204 	streq	r0, [pc, #-516]!	; 1340 <CPSR_IRQ_INHIBIT+0x12c0>
    1540:	04020011 	streq	r0, [r2], #-17	; 0xffffffef
    1544:	13052e02 	movwne	r2, #24066	; 0x5e02
    1548:	02040200 	andeq	r0, r4, #0, 4
    154c:	0005054a 	andeq	r0, r5, sl, asr #10
    1550:	46020402 	strmi	r0, [r2], -r2, lsl #8
    1554:	85880105 	strhi	r0, [r8, #261]	; 0x105
    1558:	05830905 	streq	r0, [r3, #2309]	; 0x905
    155c:	13054c0c 	movwne	r4, #23564	; 0x5c0c
    1560:	4c10054a 	cfldr32mi	mvfx0, [r0], {74}	; 0x4a
    1564:	05bb0d05 	ldreq	r0, [fp, #3333]!	; 0xd05
    1568:	1d054a09 	vstrne	s8, [r5, #-36]	; 0xffffffdc
    156c:	01040200 	mrseq	r0, R12_usr
    1570:	001a054a 	andseq	r0, sl, sl, asr #10
    1574:	4a010402 	bmi	42584 <_bss_end+0x37afc>
    1578:	054d1305 	strbeq	r1, [sp, #-773]	; 0xfffffcfb
    157c:	10054a1a 	andne	r4, r5, sl, lsl sl
    1580:	680e052e 	stmdavs	lr, {r1, r2, r3, r5, r8, sl}
    1584:	78030505 	stmdavc	r3, {r0, r2, r8, sl}
    1588:	030c0566 	movweq	r0, #50534	; 0xc566
    158c:	01052e0b 	tsteq	r5, fp, lsl #28
    1590:	0c05852f 	cfstr32eq	mvfx8, [r5], {47}	; 0x2f
    1594:	001905bd 			; <UNDEFINED> instruction: 0x001905bd
    1598:	4a040402 	bmi	1025a8 <_bss_end+0xf7b20>
    159c:	02002005 	andeq	r2, r0, #5
    15a0:	05820204 	streq	r0, [r2, #516]	; 0x204
    15a4:	04020021 	streq	r0, [r2], #-33	; 0xffffffdf
    15a8:	19052e02 	stmdbne	r5, {r1, r9, sl, fp, sp}
    15ac:	02040200 	andeq	r0, r4, #0, 4
    15b0:	00170566 	andseq	r0, r7, r6, ror #10
    15b4:	4b030402 	blmi	c25c4 <_bss_end+0xb7b3c>
    15b8:	02001805 	andeq	r1, r0, #327680	; 0x50000
    15bc:	052e0304 	streq	r0, [lr, #-772]!	; 0xfffffcfc
    15c0:	0402000e 	streq	r0, [r2], #-14
    15c4:	0f054a03 	svceq	0x00054a03
    15c8:	03040200 	movweq	r0, #16896	; 0x4200
    15cc:	0018052e 	andseq	r0, r8, lr, lsr #10
    15d0:	4a030402 	bmi	c25e0 <_bss_end+0xb7b58>
    15d4:	02001105 	andeq	r1, r0, #1073741825	; 0x40000001
    15d8:	052e0304 	streq	r0, [lr, #-772]!	; 0xfffffcfc
    15dc:	04020005 	streq	r0, [r2], #-5
    15e0:	0e052d03 	cdpeq	13, 0, cr2, cr5, cr3, {0}
    15e4:	02040200 	andeq	r0, r4, #0, 4
    15e8:	04020084 	streq	r0, [r2], #-132	; 0xffffff7c
    15ec:	0f058301 	svceq	0x00058301
    15f0:	01040200 	mrseq	r0, R12_usr
    15f4:	0011052e 	andseq	r0, r1, lr, lsr #10
    15f8:	4a010402 	bmi	42608 <_bss_end+0x37b80>
    15fc:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
    1600:	05490104 	strbeq	r0, [r9, #-260]	; 0xfffffefc
    1604:	0105850c 	tsteq	r5, ip, lsl #10
    1608:	0f05852f 	svceq	0x0005852f
    160c:	661205bc 			; <UNDEFINED> instruction: 0x661205bc
    1610:	05bc2005 	ldreq	r2, [ip, #5]!
    1614:	2005660c 	andcs	r6, r5, ip, lsl #12
    1618:	660c054b 	strvs	r0, [ip], -fp, asr #10
    161c:	054b0905 	strbeq	r0, [fp, #-2309]	; 0xfffff6fb
    1620:	19058314 	stmdbne	r5, {r2, r4, r8, r9, pc}
    1624:	6709052e 	strvs	r0, [r9, -lr, lsr #10]
    1628:	05671405 	strbeq	r1, [r7, #-1029]!	; 0xfffffbfb
    162c:	01054d0c 	tsteq	r5, ip, lsl #26
    1630:	0905852f 	stmdbeq	r5, {r0, r1, r2, r3, r5, r8, sl, pc}
    1634:	4c0e0583 	cfstr32mi	mvfx0, [lr], {131}	; 0x83
    1638:	052e0f05 	streq	r0, [lr, #-3845]!	; 0xfffff0fb
    163c:	0a056611 	beq	15ae88 <_bss_end+0x150400>
    1640:	6505054b 	strvs	r0, [r5, #-1355]	; 0xfffffab5
    1644:	05310c05 	ldreq	r0, [r1, #-3077]!	; 0xfffff3fb
    1648:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
    164c:	0e059f0b 	cdpeq	15, 0, cr9, cr5, cr11, {0}
    1650:	0017054c 	andseq	r0, r7, ip, asr #10
    1654:	4a030402 	bmi	c2664 <_bss_end+0xb7bdc>
    1658:	02000d05 	andeq	r0, r0, #320	; 0x140
    165c:	05830204 	streq	r0, [r3, #516]	; 0x204
    1660:	0402000e 	streq	r0, [r2], #-14
    1664:	10052e02 	andne	r2, r5, r2, lsl #28
    1668:	02040200 	andeq	r0, r4, #0, 4
    166c:	0005054a 	andeq	r0, r5, sl, asr #10
    1670:	49020402 	stmdbmi	r2, {r1, sl}
    1674:	85840105 	strhi	r0, [r4, #261]	; 0x105
    1678:	05bb1105 	ldreq	r1, [fp, #261]!	; 0x105
    167c:	0e054b0b 	vmlaeq.f64	d4, d5, d11
    1680:	0017054c 	andseq	r0, r7, ip, asr #10
    1684:	4a030402 	bmi	c2694 <_bss_end+0xb7c0c>
    1688:	02001c05 	andeq	r1, r0, #1280	; 0x500
    168c:	05830204 	streq	r0, [r3, #516]	; 0x204
    1690:	0402001d 	streq	r0, [r2], #-29	; 0xffffffe3
    1694:	10052e02 	andne	r2, r5, r2, lsl #28
    1698:	02040200 	andeq	r0, r4, #0, 4
    169c:	0011054a 	andseq	r0, r1, sl, asr #10
    16a0:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
    16a4:	02001d05 	andeq	r1, r0, #320	; 0x140
    16a8:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
    16ac:	04020013 	streq	r0, [r2], #-19	; 0xffffffed
    16b0:	05052e02 	streq	r2, [r5, #-3586]	; 0xfffff1fe
    16b4:	02040200 	andeq	r0, r4, #0, 4
    16b8:	8401052d 	strhi	r0, [r1], #-1325	; 0xfffffad3
    16bc:	01000802 	tsteq	r0, r2, lsl #16
    16c0:	00007901 	andeq	r7, r0, r1, lsl #18
    16c4:	46000300 	strmi	r0, [r0], -r0, lsl #6
    16c8:	02000000 	andeq	r0, r0, #0
    16cc:	0d0efb01 	vstreq	d15, [lr, #-4]
    16d0:	01010100 	mrseq	r0, (UNDEF: 17)
    16d4:	00000001 	andeq	r0, r0, r1
    16d8:	01000001 	tsteq	r0, r1
    16dc:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    16e0:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    16e4:	2f2e2e2f 	svccs	0x002e2e2f
    16e8:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    16ec:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
    16f0:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    16f4:	6e6f632f 	cdpvs	3, 6, cr6, cr15, cr15, {1}
    16f8:	2f676966 	svccs	0x00676966
    16fc:	006d7261 	rsbeq	r7, sp, r1, ror #4
    1700:	62696c00 	rsbvs	r6, r9, #0, 24
    1704:	6e756631 	mrcvs	6, 3, r6, cr5, cr1, {1}
    1708:	532e7363 			; <UNDEFINED> instruction: 0x532e7363
    170c:	00000100 	andeq	r0, r0, r0, lsl #2
    1710:	02050000 	andeq	r0, r5, #0
    1714:	0000a3c0 	andeq	sl, r0, r0, asr #7
    1718:	0108cf03 	tsteq	r8, r3, lsl #30
    171c:	2f2f2f30 	svccs	0x002f2f30
    1720:	02302f2f 	eorseq	r2, r0, #47, 30	; 0xbc
    1724:	2f1401d0 	svccs	0x001401d0
    1728:	302f2f31 	eorcc	r2, pc, r1, lsr pc	; <UNPREDICTABLE>
    172c:	03322f4c 	teqeq	r2, #76, 30	; 0x130
    1730:	2f2f661f 	svccs	0x002f661f
    1734:	2f2f2f2f 	svccs	0x002f2f2f
    1738:	0002022f 	andeq	r0, r2, pc, lsr #4
    173c:	005c0101 	subseq	r0, ip, r1, lsl #2
    1740:	00030000 	andeq	r0, r3, r0
    1744:	00000046 	andeq	r0, r0, r6, asr #32
    1748:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
    174c:	0101000d 	tsteq	r1, sp
    1750:	00000101 	andeq	r0, r0, r1, lsl #2
    1754:	00000100 	andeq	r0, r0, r0, lsl #2
    1758:	2f2e2e01 	svccs	0x002e2e01
    175c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1760:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1764:	2f2e2e2f 	svccs	0x002e2e2f
    1768:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 16b8 <CPSR_IRQ_INHIBIT+0x1638>
    176c:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1770:	6f632f63 	svcvs	0x00632f63
    1774:	6769666e 	strbvs	r6, [r9, -lr, ror #12]!
    1778:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
    177c:	696c0000 	stmdbvs	ip!, {}^	; <UNPREDICTABLE>
    1780:	75663162 	strbvc	r3, [r6, #-354]!	; 0xfffffe9e
    1784:	2e73636e 	cdpcs	3, 7, cr6, cr3, cr14, {3}
    1788:	00010053 	andeq	r0, r1, r3, asr r0
    178c:	05000000 	streq	r0, [r0, #-0]
    1790:	00a5cc02 	adceq	ip, r5, r2, lsl #24
    1794:	0bb90300 	bleq	fee4239c <_bss_end+0xfee37914>
    1798:	00020201 	andeq	r0, r2, r1, lsl #4
    179c:	00a40101 	adceq	r0, r4, r1, lsl #2
    17a0:	00030000 	andeq	r0, r3, r0
    17a4:	0000009e 	muleq	r0, lr, r0
    17a8:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
    17ac:	0101000d 	tsteq	r1, sp
    17b0:	00000101 	andeq	r0, r0, r1, lsl #2
    17b4:	00000100 	andeq	r0, r0, r0, lsl #2
    17b8:	2f2e2e01 	svccs	0x002e2e01
    17bc:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    17c0:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    17c4:	2f2e2e2f 	svccs	0x002e2e2f
    17c8:	63672f2e 	cmnvs	r7, #46, 30	; 0xb8
    17cc:	2e2e0063 	cdpcs	0, 2, cr0, cr14, cr3, {3}
    17d0:	2f2e2e2f 	svccs	0x002e2e2f
    17d4:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    17d8:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    17dc:	2f2e2e2f 	svccs	0x002e2e2f
    17e0:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    17e4:	2e2f6363 	cdpcs	3, 2, cr6, cr15, cr3, {3}
    17e8:	63672f2e 	cmnvs	r7, #46, 30	; 0xb8
    17ec:	6f632f63 	svcvs	0x00632f63
    17f0:	6769666e 	strbvs	r6, [r9, -lr, ror #12]!
    17f4:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
    17f8:	2f2e2e00 	svccs	0x002e2e00
    17fc:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1800:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1804:	2f2e2e2f 	svccs	0x002e2e2f
    1808:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 1758 <CPSR_IRQ_INHIBIT+0x16d8>
    180c:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1810:	61000063 	tstvs	r0, r3, rrx
    1814:	692d6d72 	pushvs	{r1, r4, r5, r6, r8, sl, fp, sp, lr}
    1818:	682e6173 	stmdavs	lr!, {r0, r1, r4, r5, r6, r8, sp, lr}
    181c:	00000100 	andeq	r0, r0, r0, lsl #2
    1820:	2e6d7261 	cdpcs	2, 6, cr7, cr13, cr1, {3}
    1824:	00020068 	andeq	r0, r2, r8, rrx
    1828:	6c626700 	stclvs	7, cr6, [r2], #-0
    182c:	6f74632d 	svcvs	0x0074632d
    1830:	682e7372 	stmdavs	lr!, {r1, r4, r5, r6, r8, r9, ip, sp, lr}
    1834:	00000300 	andeq	r0, r0, r0, lsl #6
    1838:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    183c:	2e326363 	cdpcs	3, 3, cr6, cr2, cr3, {3}
    1840:	00030063 	andeq	r0, r3, r3, rrx
	...

Disassembly of section .debug_str:

00000000 <.debug_str>:
       0:	78635f5f 	stmdavc	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, sl, fp, ip, lr}^
       4:	75675f61 	strbvc	r5, [r7, #-3937]!	; 0xfffff09f
       8:	5f647261 	svcpl	0x00647261
       c:	656c6572 	strbvs	r6, [ip, #-1394]!	; 0xfffffa8e
      10:	00657361 	rsbeq	r7, r5, r1, ror #6
      14:	78635f5f 	stmdavc	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, sl, fp, ip, lr}^
      18:	75675f61 	strbvc	r5, [r7, #-3937]!	; 0xfffff09f
      1c:	5f647261 	svcpl	0x00647261
      20:	726f6261 	rsbvc	r6, pc, #268435462	; 0x10000006
      24:	6d2f0074 	stcvs	0, cr0, [pc, #-464]!	; fffffe5c <_bss_end+0xffff53d4>
      28:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
      2c:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
      30:	4b2f7372 	blmi	bdce00 <_bss_end+0xbd2378>
      34:	2f616275 	svccs	0x00616275
      38:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
      3c:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
      40:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
      44:	614d6f72 	hvcvs	55026	; 0xd6f2
      48:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffadc <_bss_end+0xffff5054>
      4c:	706d6178 	rsbvc	r6, sp, r8, ror r1
      50:	2f73656c 	svccs	0x0073656c
      54:	552d3032 	strpl	r3, [sp, #-50]!	; 0xffffffce
      58:	5f545241 	svcpl	0x00545241
      5c:	656d6167 	strbvs	r6, [sp, #-359]!	; 0xfffffe99
      60:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
      64:	2f6c656e 	svccs	0x006c656e
      68:	2f637273 	svccs	0x00637273
      6c:	2e787863 	cdpcs	8, 7, cr7, cr8, cr3, {3}
      70:	00707063 	rsbseq	r7, r0, r3, rrx
      74:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
      78:	552f632f 	strpl	r6, [pc, #-815]!	; fffffd51 <_bss_end+0xffff52c9>
      7c:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
      80:	62754b2f 	rsbsvs	r4, r5, #48128	; 0xbc00
      84:	6f442f61 	svcvs	0x00442f61
      88:	656d7563 	strbvs	r7, [sp, #-1379]!	; 0xfffffa9d
      8c:	2f73746e 	svccs	0x0073746e
      90:	6f72655a 	svcvs	0x0072655a
      94:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
      98:	6178652f 	cmnvs	r8, pc, lsr #10
      9c:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
      a0:	30322f73 	eorscc	r2, r2, r3, ror pc
      a4:	5241552d 	subpl	r5, r1, #188743680	; 0xb400000
      a8:	61675f54 	cmnvs	r7, r4, asr pc
      ac:	622f656d 	eorvs	r6, pc, #457179136	; 0x1b400000
      b0:	646c6975 	strbtvs	r6, [ip], #-2421	; 0xfffff68b
      b4:	554e4700 	strbpl	r4, [lr, #-1792]	; 0xfffff900
      b8:	2b2b4320 	blcs	ad0d40 <_bss_end+0xac62b8>
      bc:	31203431 			; <UNDEFINED> instruction: 0x31203431
      c0:	2e332e30 	mrccs	14, 1, r2, cr3, cr0, {1}
      c4:	30322031 	eorscc	r2, r2, r1, lsr r0
      c8:	36303132 			; <UNDEFINED> instruction: 0x36303132
      cc:	28203132 	stmdacs	r0!, {r1, r4, r5, r8, ip, sp}
      d0:	656c6572 	strbvs	r6, [ip, #-1394]!	; 0xfffffa8e
      d4:	29657361 	stmdbcs	r5!, {r0, r5, r6, r8, r9, ip, sp, lr}^
      d8:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
      dc:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
      e0:	6962612d 	stmdbvs	r2!, {r0, r2, r3, r5, r8, sp, lr}^
      e4:	7261683d 	rsbvc	r6, r1, #3997696	; 0x3d0000
      e8:	6d2d2064 	stcvs	0, cr2, [sp, #-400]!	; 0xfffffe70
      ec:	3d757066 	ldclcc	0, cr7, [r5, #-408]!	; 0xfffffe68
      f0:	20706676 	rsbscs	r6, r0, r6, ror r6
      f4:	6c666d2d 	stclvs	13, cr6, [r6], #-180	; 0xffffff4c
      f8:	2d74616f 	ldfcse	f6, [r4, #-444]!	; 0xfffffe44
      fc:	3d696261 	sfmcc	f6, 2, [r9, #-388]!	; 0xfffffe7c
     100:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
     104:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
     108:	763d7570 			; <UNDEFINED> instruction: 0x763d7570
     10c:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
     110:	6e75746d 	cdpvs	4, 7, cr7, cr5, cr13, {3}
     114:	72613d65 	rsbvc	r3, r1, #6464	; 0x1940
     118:	3731316d 	ldrcc	r3, [r1, -sp, ror #2]!
     11c:	667a6a36 			; <UNDEFINED> instruction: 0x667a6a36
     120:	2d20732d 	stccs	3, cr7, [r0, #-180]!	; 0xffffff4c
     124:	6d72616d 	ldfvse	f6, [r2, #-436]!	; 0xfffffe4c
     128:	616d2d20 	cmnvs	sp, r0, lsr #26
     12c:	3d686372 	stclcc	3, cr6, [r8, #-456]!	; 0xfffffe38
     130:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
     134:	2b6b7a36 	blcs	1adea14 <_bss_end+0x1ad3f8c>
     138:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
     13c:	672d2067 	strvs	r2, [sp, -r7, rrx]!
     140:	20672d20 	rsbcs	r2, r7, r0, lsr #26
     144:	20304f2d 	eorscs	r4, r0, sp, lsr #30
     148:	00304f2d 	eorseq	r4, r0, sp, lsr #30
     14c:	78635f5f 	stmdavc	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, sl, fp, ip, lr}^
     150:	74615f61 	strbtvc	r5, [r1], #-3937	; 0xfffff09f
     154:	74697865 	strbtvc	r7, [r9], #-2149	; 0xfffff79b
     158:	645f5f00 	ldrbvs	r5, [pc], #-3840	; 160 <CPSR_IRQ_INHIBIT+0xe0>
     15c:	685f6f73 	ldmdavs	pc, {r0, r1, r4, r5, r6, r8, r9, sl, fp, sp, lr}^	; <UNPREDICTABLE>
     160:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     164:	5f5f0065 	svcpl	0x005f0065
     168:	5f617863 	svcpl	0x00617863
     16c:	72617567 	rsbvc	r7, r1, #432013312	; 0x19c00000
     170:	63615f64 	cmnvs	r1, #100, 30	; 0x190
     174:	72697571 	rsbvc	r7, r9, #473956352	; 0x1c400000
     178:	5f5f0065 	svcpl	0x005f0065
     17c:	61787863 	cmnvs	r8, r3, ror #16
     180:	31766962 	cmncc	r6, r2, ror #18
     184:	635f5f00 	cmpvs	pc, #0, 30
     188:	705f6178 	subsvc	r6, pc, r8, ror r1	; <UNPREDICTABLE>
     18c:	5f657275 	svcpl	0x00657275
     190:	74726976 	ldrbtvc	r6, [r2], #-2422	; 0xfffff68a
     194:	006c6175 	rsbeq	r6, ip, r5, ror r1
     198:	65615f5f 	strbvs	r5, [r1, #-3935]!	; 0xfffff0a1
     19c:	5f696261 	svcpl	0x00696261
     1a0:	69776e75 	ldmdbvs	r7!, {r0, r2, r4, r5, r6, r9, sl, fp, sp, lr}^
     1a4:	635f646e 	cmpvs	pc, #1845493760	; 0x6e000000
     1a8:	705f7070 	subsvc	r7, pc, r0, ror r0	; <UNPREDICTABLE>
     1ac:	5f003172 	svcpl	0x00003172
     1b0:	6175675f 	cmnvs	r5, pc, asr r7
     1b4:	6c006472 	cfstrsvs	mvf6, [r0], {114}	; 0x72
     1b8:	20676e6f 	rsbcs	r6, r7, pc, ror #28
     1bc:	676e6f6c 	strbvs	r6, [lr, -ip, ror #30]!
     1c0:	746e6920 	strbtvc	r6, [lr], #-2336	; 0xfffff6e0
     1c4:	6e6d2f00 	cdpvs	15, 6, cr2, cr13, cr0, {0}
     1c8:	2f632f74 	svccs	0x00632f74
     1cc:	72657355 	rsbvc	r7, r5, #1409286145	; 0x54000001
     1d0:	754b2f73 	strbvc	r2, [fp, #-3955]	; 0xfffff08d
     1d4:	442f6162 	strtmi	r6, [pc], #-354	; 1dc <CPSR_IRQ_INHIBIT+0x15c>
     1d8:	6d75636f 	ldclvs	3, cr6, [r5, #-444]!	; 0xfffffe44
     1dc:	73746e65 	cmnvc	r4, #1616	; 0x650
     1e0:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
     1e4:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
     1e8:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
     1ec:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
     1f0:	322f7365 	eorcc	r7, pc, #-1811939327	; 0x94000001
     1f4:	41552d30 	cmpmi	r5, r0, lsr sp
     1f8:	675f5452 			; <UNDEFINED> instruction: 0x675f5452
     1fc:	2f656d61 	svccs	0x00656d61
     200:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
     204:	732f6c65 			; <UNDEFINED> instruction: 0x732f6c65
     208:	642f6372 	strtvs	r6, [pc], #-882	; 210 <CPSR_IRQ_INHIBIT+0x190>
     20c:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
     210:	622f7372 	eorvs	r7, pc, #-939524095	; 0xc8000001
     214:	615f6d63 	cmpvs	pc, r3, ror #26
     218:	632e7875 			; <UNDEFINED> instruction: 0x632e7875
     21c:	54007070 	strpl	r7, [r0], #-112	; 0xffffff90
     220:	72656d69 	rsbvc	r6, r5, #6720	; 0x1a40
     224:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
     228:	68730065 	ldmdavs	r3!, {r0, r2, r5, r6}^
     22c:	2074726f 	rsbscs	r7, r4, pc, ror #4
     230:	00746e69 	rsbseq	r6, r4, r9, ror #28
     234:	31495053 	qdaddcc	r5, r3, r9
     238:	4545505f 	strbmi	r5, [r5, #-95]	; 0xffffffa1
     23c:	5053004b 	subspl	r0, r3, fp, asr #32
     240:	535f3149 	cmppl	pc, #1073741842	; 0x40000012
     244:	00544154 	subseq	r4, r4, r4, asr r1
     248:	5855416d 	ldmdapl	r5, {r0, r2, r3, r5, r6, r8, lr}^
     24c:	6765525f 			; <UNDEFINED> instruction: 0x6765525f
     250:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     254:	55414334 	strbpl	r4, [r1, #-820]	; 0xfffffccc
     258:	47323158 			; <UNDEFINED> instruction: 0x47323158
     25c:	525f7465 	subspl	r7, pc, #1694498816	; 0x65000000
     260:	73696765 	cmnvc	r9, #26476544	; 0x1940000
     264:	45726574 	ldrbmi	r6, [r2, #-1396]!	; 0xfffffa8c
     268:	6168334e 	cmnvs	r8, lr, asr #6
     26c:	5541376c 	strbpl	r3, [r1, #-1900]	; 0xfffff894
     270:	65525f58 	ldrbvs	r5, [r2, #-3928]	; 0xfffff0a8
     274:	76004567 	strvc	r4, [r0], -r7, ror #10
     278:	65756c61 	ldrbvs	r6, [r5, #-3169]!	; 0xfffff39f
     27c:	78756100 	ldmdavc	r5!, {r8, sp, lr}^
     280:	7361625f 	cmnvc	r1, #-268435451	; 0xf0000005
     284:	4e450065 	cdpmi	0, 4, cr0, cr5, cr5, {3}
     288:	454c4241 	strbmi	r4, [ip, #-577]	; 0xfffffdbf
     28c:	5a5f0053 	bpl	17c03e0 <_bss_end+0x17b5958>
     290:	4143344e 	cmpmi	r3, lr, asr #8
     294:	45365855 	ldrmi	r5, [r6, #-2133]!	; 0xfffff7ab
     298:	6c62616e 	stfvse	f6, [r2], #-440	; 0xfffffe48
     29c:	334e4565 	movtcc	r4, #58725	; 0xe565
     2a0:	316c6168 	cmncc	ip, r8, ror #2
     2a4:	58554135 	ldmdapl	r5, {r0, r2, r4, r5, r8, lr}^
     2a8:	7265505f 	rsbvc	r5, r5, #95	; 0x5f
     2ac:	65687069 	strbvs	r7, [r8, #-105]!	; 0xffffff97
     2b0:	736c6172 	cmnvc	ip, #-2147483620	; 0x8000001c
     2b4:	55410045 	strbpl	r0, [r1, #-69]	; 0xffffffbb
     2b8:	65505f58 	ldrbvs	r5, [r0, #-3928]	; 0xfffff0a8
     2bc:	68706972 	ldmdavs	r0!, {r1, r4, r5, r6, r8, fp, sp, lr}^
     2c0:	6c617265 	sfmvs	f7, 2, [r1], #-404	; 0xfffffe6c
     2c4:	5a5f0073 	bpl	17c0498 <_bss_end+0x17b5a10>
     2c8:	4143344e 	cmpmi	r3, lr, asr #8
     2cc:	34435855 	strbcc	r5, [r3], #-2133	; 0xfffff7ab
     2d0:	5f006a45 	svcpl	0x00006a45
     2d4:	43344e5a 	teqmi	r4, #1440	; 0x5a0
     2d8:	31585541 	cmpcc	r8, r1, asr #10
     2dc:	74655332 	strbtvc	r5, [r5], #-818	; 0xfffffcce
     2e0:	6765525f 			; <UNDEFINED> instruction: 0x6765525f
     2e4:	65747369 	ldrbvs	r7, [r4, #-873]!	; 0xfffffc97
     2e8:	334e4572 	movtcc	r4, #58738	; 0xe572
     2ec:	376c6168 	strbcc	r6, [ip, -r8, ror #2]!
     2f0:	5f585541 	svcpl	0x00585541
     2f4:	45676552 	strbmi	r6, [r7, #-1362]!	; 0xfffffaae
     2f8:	5053006a 	subspl	r0, r3, sl, rrx
     2fc:	495f3049 	ldmdbmi	pc, {r0, r3, r6, ip, sp}^	; <UNPREDICTABLE>
     300:	475f004f 	ldrbmi	r0, [pc, -pc, asr #32]
     304:	41424f4c 	cmpmi	r2, ip, asr #30
     308:	735f5f4c 	cmpvc	pc, #76, 30	; 0x130
     30c:	495f6275 	ldmdbmi	pc, {r0, r2, r4, r5, r6, r9, sp, lr}^	; <UNPREDICTABLE>
     310:	5541735f 	strbpl	r7, [r1, #-863]	; 0xfffffca1
     314:	50530058 	subspl	r0, r3, r8, asr r0
     318:	435f3049 	cmpmi	pc, #73	; 0x49
     31c:	304c544e 	subcc	r5, ip, lr, asr #8
     320:	49505300 	ldmdbmi	r0, {r8, r9, ip, lr}^
     324:	4e435f30 	mcrmi	15, 2, r5, cr3, cr0, {1}
     328:	00314c54 	eorseq	r4, r1, r4, asr ip
     32c:	69726550 	ldmdbvs	r2!, {r4, r6, r8, sl, sp, lr}^
     330:	72656870 	rsbvc	r6, r5, #112, 16	; 0x700000
     334:	425f6c61 	subsmi	r6, pc, #24832	; 0x6100
     338:	00657361 	rsbeq	r7, r5, r1, ror #6
     33c:	6e695f5f 	mcrvs	15, 3, r5, cr9, cr15, {2}
     340:	61697469 	cmnvs	r9, r9, ror #8
     344:	657a696c 	ldrbvs	r6, [sl, #-2412]!	; 0xfffff694
     348:	5300705f 	movwpl	r7, #95	; 0x5f
     34c:	5f314950 	svcpl	0x00314950
     350:	4c544e43 	mrrcmi	14, 4, r4, r4, cr3	; <UNPREDICTABLE>
     354:	50530030 	subspl	r0, r3, r0, lsr r0
     358:	435f3149 	cmpmi	pc, #1073741842	; 0x40000012
     35c:	314c544e 	cmpcc	ip, lr, asr #8
     360:	736e7500 	cmnvc	lr, #0, 10
     364:	656e6769 	strbvs	r6, [lr, #-1897]!	; 0xfffff897
     368:	68632064 	stmdavs	r3!, {r2, r5, r6, sp}^
     36c:	4d007261 	sfmmi	f7, 4, [r0, #-388]	; 0xfffffe7c
     370:	45495f55 	strbmi	r5, [r9, #-3925]	; 0xfffff0ab
     374:	554d0052 	strbpl	r0, [sp, #-82]	; 0xffffffae
     378:	52434d5f 	subpl	r4, r3, #6080	; 0x17c0
     37c:	49504700 	ldmdbmi	r0, {r8, r9, sl, lr}^
     380:	61425f4f 	cmpvs	r2, pc, asr #30
     384:	5f006573 	svcpl	0x00006573
     388:	43344e5a 	teqmi	r4, #1440	; 0x5a0
     38c:	43585541 	cmpmi	r8, #272629760	; 0x10400000
     390:	006a4532 	rsbeq	r4, sl, r2, lsr r5
     394:	746e6975 	strbtvc	r6, [lr], #-2421	; 0xfffff68b
     398:	745f3233 	ldrbvc	r3, [pc], #-563	; 3a0 <CPSR_IRQ_INHIBIT+0x320>
     39c:	5f554d00 	svcpl	0x00554d00
     3a0:	00524949 	subseq	r4, r2, r9, asr #18
     3a4:	435f554d 	cmpmi	pc, #322961408	; 0x13400000
     3a8:	004c544e 	subeq	r5, ip, lr, asr #8
     3ac:	31495053 	qdaddcc	r5, r3, r9
     3b0:	49505300 	ldmdbmi	r0, {r8, r9, ip, lr}^
     3b4:	68730032 	ldmdavs	r3!, {r1, r4, r5}^
     3b8:	2074726f 	rsbscs	r7, r4, pc, ror #4
     3bc:	69736e75 	ldmdbvs	r3!, {r0, r2, r4, r5, r6, r9, sl, fp, sp, lr}^
     3c0:	64656e67 	strbtvs	r6, [r5], #-3687	; 0xfffff199
     3c4:	746e6920 	strbtvc	r6, [lr], #-2336	; 0xfffff6e0
     3c8:	49505300 	ldmdbmi	r0, {r8, r9, ip, lr}^
     3cc:	4f495f31 	svcmi	0x00495f31
     3d0:	5f554d00 	svcpl	0x00554d00
     3d4:	0052434c 	subseq	r4, r2, ip, asr #6
     3d8:	30495053 	subcc	r5, r9, r3, asr r0
     3dc:	4545505f 	strbmi	r5, [r5, #-95]	; 0xffffffa1
     3e0:	554d004b 	strbpl	r0, [sp, #-75]	; 0xffffffb5
     3e4:	5541425f 	strbpl	r4, [r1, #-607]	; 0xfffffda1
     3e8:	50530044 	subspl	r0, r3, r4, asr #32
     3ec:	535f3049 	cmppl	pc, #73	; 0x49
     3f0:	00544154 	subseq	r4, r4, r4, asr r1
     3f4:	4f495047 	svcmi	0x00495047
     3f8:	6e69505f 	mcrvs	0, 3, r5, cr9, cr15, {2}
     3fc:	756f435f 	strbvc	r4, [pc, #-863]!	; a5 <CPSR_IRQ_INHIBIT+0x25>
     400:	5f00746e 	svcpl	0x0000746e
     404:	6174735f 	cmnvs	r4, pc, asr r3
     408:	5f636974 	svcpl	0x00636974
     40c:	74696e69 	strbtvc	r6, [r9], #-3689	; 0xfffff197
     410:	696c6169 	stmdbvs	ip!, {r0, r3, r5, r6, r8, sp, lr}^
     414:	6974617a 	ldmdbvs	r4!, {r1, r3, r4, r5, r6, r8, sp, lr}^
     418:	615f6e6f 	cmpvs	pc, pc, ror #28
     41c:	645f646e 	ldrbvs	r6, [pc], #-1134	; 424 <CPSR_IRQ_INHIBIT+0x3a4>
     420:	72747365 	rsbsvc	r7, r4, #-1811939327	; 0x94000001
     424:	69746375 	ldmdbvs	r4!, {r0, r2, r4, r5, r6, r8, r9, sp, lr}^
     428:	305f6e6f 	subscc	r6, pc, pc, ror #28
     42c:	705f5f00 	subsvc	r5, pc, r0, lsl #30
     430:	726f6972 	rsbvc	r6, pc, #1867776	; 0x1c8000
     434:	00797469 	rsbseq	r7, r9, r9, ror #8
     438:	73696874 	cmnvc	r9, #116, 16	; 0x740000
     43c:	746e4900 	strbtvc	r4, [lr], #-2304	; 0xfffff700
     440:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
     444:	435f7470 	cmpmi	pc, #112, 8	; 0x70000000
     448:	72746e6f 	rsbsvc	r6, r4, #1776	; 0x6f0
     44c:	656c6c6f 	strbvs	r6, [ip, #-3183]!	; 0xfffff391
     450:	61425f72 	hvcvs	9714	; 0x25f2
     454:	53006573 	movwpl	r6, #1395	; 0x573
     458:	525f7465 	subspl	r7, pc, #1694498816	; 0x65000000
     45c:	73696765 	cmnvc	r9, #26476544	; 0x1940000
     460:	00726574 	rsbseq	r6, r2, r4, ror r5
     464:	4d5f554d 	cfldr64mi	mvdx5, [pc, #-308]	; 338 <CPSR_IRQ_INHIBIT+0x2b8>
     468:	47005253 	smlsdmi	r0, r3, r2, r5
     46c:	525f7465 	subspl	r7, pc, #1694498816	; 0x65000000
     470:	73696765 	cmnvc	r9, #26476544	; 0x1940000
     474:	00726574 	rsbseq	r6, r2, r4, ror r5
     478:	5f585541 	svcpl	0x00585541
     47c:	65736142 	ldrbvs	r6, [r3, #-322]!	; 0xfffffebe
     480:	5f554d00 	svcpl	0x00554d00
     484:	54415453 	strbpl	r5, [r1], #-1107	; 0xfffffbad
     488:	78756100 	ldmdavc	r5!, {r8, sp, lr}^
     48c:	7265705f 	rsbvc	r7, r5, #95	; 0x5f
     490:	65687069 	strbvs	r7, [r8, #-105]!	; 0xffffff97
     494:	006c6172 	rsbeq	r6, ip, r2, ror r1
     498:	495f554d 	ldmdbmi	pc, {r0, r2, r3, r6, r8, sl, ip, lr}^	; <UNPREDICTABLE>
     49c:	694d004f 	stmdbvs	sp, {r0, r1, r2, r3, r6}^
     4a0:	4155696e 	cmpmi	r5, lr, ror #18
     4a4:	4d005452 	cfstrsmi	mvf5, [r0, #-328]	; 0xfffffeb8
     4a8:	534c5f55 	movtpl	r5, #53077	; 0xcf55
     4ac:	65720052 	ldrbvs	r0, [r2, #-82]!	; 0xffffffae
     4b0:	64695f67 	strbtvs	r5, [r9], #-3943	; 0xfffff099
     4b4:	65440078 	strbvs	r0, [r4, #-120]	; 0xffffff88
     4b8:	6c756166 	ldfvse	f6, [r5], #-408	; 0xfffffe68
     4bc:	6c435f74 	mcrrvs	15, 7, r5, r3, cr4
     4c0:	5f6b636f 	svcpl	0x006b636f
     4c4:	65746152 	ldrbvs	r6, [r4, #-338]!	; 0xfffffeae
     4c8:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     4cc:	55414334 	strbpl	r4, [r1, #-820]	; 0xfffffccc
     4d0:	69443758 	stmdbvs	r4, {r3, r4, r6, r8, r9, sl, ip, sp}^
     4d4:	6c626173 	stfvse	f6, [r2], #-460	; 0xfffffe34
     4d8:	334e4565 	movtcc	r4, #58725	; 0xe565
     4dc:	316c6168 	cmncc	ip, r8, ror #2
     4e0:	58554135 	ldmdapl	r5, {r0, r2, r4, r5, r8, lr}^
     4e4:	7265505f 	rsbvc	r5, r5, #95	; 0x5f
     4e8:	65687069 	strbvs	r7, [r8, #-105]!	; 0xffffff97
     4ec:	736c6172 	cmnvc	ip, #-2147483620	; 0x8000001c
     4f0:	554d0045 	strbpl	r0, [sp, #-69]	; 0xffffffbb
     4f4:	5243535f 	subpl	r5, r3, #2080374785	; 0x7c000001
     4f8:	48435441 	stmdami	r3, {r0, r6, sl, ip, lr}^
     4fc:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     500:	4333314b 	teqmi	r3, #-1073741806	; 0xc0000012
     504:	4f495047 	svcmi	0x00495047
     508:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     50c:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     510:	65473831 	strbvs	r3, [r7, #-2097]	; 0xfffff7cf
     514:	50475f74 	subpl	r5, r7, r4, ror pc
     518:	5f56454c 	svcpl	0x0056454c
     51c:	61636f4c 	cmnvs	r3, ip, asr #30
     520:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     524:	6a526a45 	bvs	149ae40 <_bss_end+0x14903b8>
     528:	005f3053 	subseq	r3, pc, r3, asr r0	; <UNPREDICTABLE>
     52c:	45535047 	ldrbmi	r5, [r3, #-71]	; 0xffffffb9
     530:	47003054 	smlsdmi	r0, r4, r0, r3
     534:	54455350 	strbpl	r5, [r5], #-848	; 0xfffffcb0
     538:	50470031 	subpl	r0, r7, r1, lsr r0
     53c:	4c455346 	mcrrmi	3, 4, r5, r5, cr6
     540:	50470030 	subpl	r0, r7, r0, lsr r0
     544:	4c455346 	mcrrmi	3, 4, r5, r5, cr6
     548:	50470031 	subpl	r0, r7, r1, lsr r0
     54c:	4c455346 	mcrrmi	3, 4, r5, r5, cr6
     550:	50470032 	subpl	r0, r7, r2, lsr r0
     554:	4c455346 	mcrrmi	3, 4, r5, r5, cr6
     558:	50470033 	subpl	r0, r7, r3, lsr r0
     55c:	4c455346 	mcrrmi	3, 4, r5, r5, cr6
     560:	50470034 	subpl	r0, r7, r4, lsr r0
     564:	4c455346 	mcrrmi	3, 4, r5, r5, cr6
     568:	50470035 	subpl	r0, r7, r5, lsr r0
     56c:	314e4546 	cmpcc	lr, r6, asr #10
     570:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     574:	5f50475f 	svcpl	0x0050475f
     578:	5f515249 	svcpl	0x00515249
     57c:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
     580:	4c5f7463 	cfldrdmi	mvd7, [pc], {99}	; 0x63
     584:	7461636f 	strbtvc	r6, [r1], #-879	; 0xfffffc91
     588:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     58c:	5f746547 	svcpl	0x00746547
     590:	44455047 	strbmi	r5, [r5], #-71	; 0xffffffb9
     594:	6f4c5f53 	svcvs	0x004c5f53
     598:	69746163 	ldmdbvs	r4!, {r0, r1, r5, r6, r8, sp, lr}^
     59c:	48006e6f 	stmdami	r0, {r0, r1, r2, r3, r5, r6, r9, sl, fp, sp, lr}
     5a0:	00686769 	rsbeq	r6, r8, r9, ror #14
     5a4:	55505047 	ldrbpl	r5, [r0, #-71]	; 0xffffffb9
     5a8:	4b4c4344 	blmi	13112c0 <_bss_end+0x1306838>
     5ac:	50470030 	subpl	r0, r7, r0, lsr r0
     5b0:	43445550 	movtmi	r5, #17744	; 0x4550
     5b4:	00314b4c 	eorseq	r4, r1, ip, asr #22
     5b8:	314e5a5f 	cmpcc	lr, pc, asr sl
     5bc:	50474333 	subpl	r4, r7, r3, lsr r3
     5c0:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     5c4:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     5c8:	39317265 	ldmdbcc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     5cc:	62616e45 	rsbvs	r6, r1, #1104	; 0x450
     5d0:	455f656c 	ldrbmi	r6, [pc, #-1388]	; 6c <CPSR_FIQ_INHIBIT+0x2c>
     5d4:	746e6576 	strbtvc	r6, [lr], #-1398	; 0xfffffa8a
     5d8:	7465445f 	strbtvc	r4, [r5], #-1119	; 0xfffffba1
     5dc:	45746365 	ldrbmi	r6, [r4, #-869]!	; 0xfffffc9b
     5e0:	4e30326a 	cdpmi	2, 3, cr3, cr0, cr10, {3}
     5e4:	4f495047 	svcmi	0x00495047
     5e8:	746e495f 	strbtvc	r4, [lr], #-2399	; 0xfffff6a1
     5ec:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
     5f0:	545f7470 	ldrbpl	r7, [pc], #-1136	; 5f8 <CPSR_IRQ_INHIBIT+0x578>
     5f4:	00657079 	rsbeq	r7, r5, r9, ror r0
     5f8:	45525047 	ldrbmi	r5, [r2, #-71]	; 0xffffffb9
     5fc:	4700304e 	strmi	r3, [r0, -lr, asr #32]
     600:	4e455250 	mcrmi	2, 2, r5, cr5, cr0, {2}
     604:	50470031 	subpl	r0, r7, r1, lsr r0
     608:	314e4548 	cmpcc	lr, r8, asr #10
     60c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     610:	4333314b 	teqmi	r3, #-1073741806	; 0xc0000012
     614:	4f495047 	svcmi	0x00495047
     618:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     61c:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     620:	65473931 	strbvs	r3, [r7, #-2353]	; 0xfffff6cf
     624:	50475f74 	subpl	r5, r7, r4, ror pc
     628:	4c455346 	mcrrmi	3, 4, r5, r5, cr6
     62c:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     630:	6f697461 	svcvs	0x00697461
     634:	526a456e 	rsbpl	r4, sl, #461373440	; 0x1b800000
     638:	5f30536a 	svcpl	0x0030536a
     63c:	50476d00 	subpl	r6, r7, r0, lsl #26
     640:	5f004f49 	svcpl	0x00004f49
     644:	33314e5a 	teqcc	r1, #1440	; 0x5a0
     648:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     64c:	61485f4f 	cmpvs	r8, pc, asr #30
     650:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     654:	45344372 	ldrmi	r4, [r4, #-882]!	; 0xfffffc8e
     658:	6975006a 	ldmdbvs	r5!, {r1, r3, r5, r6}^
     65c:	5f38746e 	svcpl	0x0038746e
     660:	50470074 	subpl	r0, r7, r4, ror r0
     664:	30534445 	subscc	r4, r3, r5, asr #8
     668:	45504700 	ldrbmi	r4, [r0, #-1792]	; 0xfffff900
     66c:	00315344 	eorseq	r5, r1, r4, asr #6
     670:	6c6f6f62 	stclvs	15, cr6, [pc], #-392	; 4f0 <CPSR_IRQ_INHIBIT+0x470>
     674:	736e5500 	cmnvc	lr, #0, 10
     678:	69636570 	stmdbvs	r3!, {r4, r5, r6, r8, sl, sp, lr}^
     67c:	64656966 	strbtvs	r6, [r5], #-2406	; 0xfffff69a
     680:	656c4300 	strbvs	r4, [ip, #-768]!	; 0xfffffd00
     684:	445f7261 	ldrbmi	r7, [pc], #-609	; 68c <CPSR_IRQ_INHIBIT+0x60c>
     688:	63657465 	cmnvs	r5, #1694498816	; 0x65000000
     68c:	5f646574 	svcpl	0x00646574
     690:	6e657645 	cdpvs	6, 6, cr7, cr5, cr5, {2}
     694:	50470074 	subpl	r0, r7, r4, ror r0
     698:	304e454c 	subcc	r4, lr, ip, asr #10
     69c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     6a0:	4333314b 	teqmi	r3, #-1073741806	; 0xc0000012
     6a4:	4f495047 	svcmi	0x00495047
     6a8:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     6ac:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     6b0:	65473632 	strbvs	r3, [r7, #-1586]	; 0xfffff9ce
     6b4:	50475f74 	subpl	r5, r7, r4, ror pc
     6b8:	5152495f 	cmppl	r2, pc, asr r9
     6bc:	7465445f 	strbtvc	r4, [r5], #-1119	; 0xfffffba1
     6c0:	5f746365 	svcpl	0x00746365
     6c4:	61636f4c 	cmnvs	r3, ip, asr #30
     6c8:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     6cc:	30326a45 	eorscc	r6, r2, r5, asr #20
     6d0:	4950474e 	ldmdbmi	r0, {r1, r2, r3, r6, r8, r9, sl, lr}^
     6d4:	6e495f4f 	cdpvs	15, 4, cr5, cr9, cr15, {2}
     6d8:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
     6dc:	5f747075 	svcpl	0x00747075
     6e0:	65707954 	ldrbvs	r7, [r0, #-2388]!	; 0xfffff6ac
     6e4:	31536a52 	cmpcc	r3, r2, asr sl
     6e8:	6547005f 	strbvs	r0, [r7, #-95]	; 0xffffffa1
     6ec:	50475f74 	subpl	r5, r7, r4, ror pc
     6f0:	465f4f49 	ldrbmi	r4, [pc], -r9, asr #30
     6f4:	74636e75 	strbtvc	r6, [r3], #-3701	; 0xfffff18b
     6f8:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     6fc:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     700:	61485f4f 	cmpvs	r8, pc, asr #30
     704:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     708:	65470072 	strbvs	r0, [r7, #-114]	; 0xffffff8e
     70c:	50475f74 	subpl	r5, r7, r4, ror pc
     710:	5f544553 	svcpl	0x00544553
     714:	61636f4c 	cmnvs	r3, ip, asr #30
     718:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     71c:	50504700 	subspl	r4, r0, r0, lsl #14
     720:	5f004455 	svcpl	0x00004455
     724:	33314e5a 	teqcc	r1, #1440	; 0x5a0
     728:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     72c:	61485f4f 	cmpvs	r8, pc, asr #30
     730:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     734:	43303272 	teqmi	r0, #536870919	; 0x20000007
     738:	7261656c 	rsbvc	r6, r1, #108, 10	; 0x1b000000
     73c:	7465445f 	strbtvc	r4, [r5], #-1119	; 0xfffffba1
     740:	65746365 	ldrbvs	r6, [r4, #-869]!	; 0xfffffc9b
     744:	76455f64 	strbvc	r5, [r5], -r4, ror #30
     748:	45746e65 	ldrbmi	r6, [r4, #-3685]!	; 0xfffff19b
     74c:	6547006a 	strbvs	r0, [r7, #-106]	; 0xffffff96
     750:	50475f74 	subpl	r5, r7, r4, ror pc
     754:	5f56454c 	svcpl	0x0056454c
     758:	61636f4c 	cmnvs	r3, ip, asr #30
     75c:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     760:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     764:	4333314b 	teqmi	r3, #-1073741806	; 0xc0000012
     768:	4f495047 	svcmi	0x00495047
     76c:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     770:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     774:	65473731 	strbvs	r3, [r7, #-1841]	; 0xfffff8cf
     778:	50475f74 	subpl	r5, r7, r4, ror pc
     77c:	465f4f49 	ldrbmi	r4, [pc], -r9, asr #30
     780:	74636e75 	strbtvc	r6, [r3], #-3701	; 0xfffff18b
     784:	456e6f69 	strbmi	r6, [lr, #-3945]!	; 0xfffff097
     788:	5a5f006a 	bpl	17c0938 <_bss_end+0x17b5eb0>
     78c:	4333314e 	teqmi	r3, #-2147483629	; 0x80000013
     790:	4f495047 	svcmi	0x00495047
     794:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     798:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     79c:	6a453243 	bvs	114d0b0 <_bss_end+0x1142628>
     7a0:	41504700 	cmpmi	r0, r0, lsl #14
     7a4:	304e4546 	subcc	r4, lr, r6, asr #10
     7a8:	41504700 	cmpmi	r0, r0, lsl #14
     7ac:	314e4546 	cmpcc	lr, r6, asr #10
     7b0:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     7b4:	4333314b 	teqmi	r3, #-1073741806	; 0xc0000012
     7b8:	4f495047 	svcmi	0x00495047
     7bc:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     7c0:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     7c4:	65473831 	strbvs	r3, [r7, #-2097]	; 0xfffff7cf
     7c8:	50475f74 	subpl	r5, r7, r4, ror pc
     7cc:	5f524c43 	svcpl	0x00524c43
     7d0:	61636f4c 	cmnvs	r3, ip, asr #30
     7d4:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     7d8:	6a526a45 	bvs	149b0f4 <_bss_end+0x149066c>
     7dc:	005f3053 	subseq	r3, pc, r3, asr r0	; <UNPREDICTABLE>
     7e0:	314e5a5f 	cmpcc	lr, pc, asr sl
     7e4:	50474333 	subpl	r4, r7, r3, lsr r3
     7e8:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     7ec:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     7f0:	30317265 	eorscc	r7, r1, r5, ror #4
     7f4:	5f746553 	svcpl	0x00746553
     7f8:	7074754f 	rsbsvc	r7, r4, pc, asr #10
     7fc:	6a457475 	bvs	115d9d8 <_bss_end+0x1152f50>
     800:	475f0062 	ldrbmi	r0, [pc, -r2, rrx]
     804:	41424f4c 	cmpmi	r2, ip, asr #30
     808:	735f5f4c 	cmpvc	pc, #76, 30	; 0x130
     80c:	495f6275 	ldmdbmi	pc, {r0, r2, r4, r5, r6, r9, sp, lr}^	; <UNPREDICTABLE>
     810:	5047735f 	subpl	r7, r7, pc, asr r3
     814:	47004f49 	strmi	r4, [r0, -r9, asr #30]
     818:	524c4350 	subpl	r4, ip, #80, 6	; 0x40000001
     81c:	50470031 	subpl	r0, r7, r1, lsr r0
     820:	4e455241 	cdpmi	2, 4, cr5, cr5, cr1, {2}
     824:	50470030 	subpl	r0, r7, r0, lsr r0
     828:	4e455241 	cdpmi	2, 4, cr5, cr5, cr1, {2}
     82c:	50470031 	subpl	r0, r7, r1, lsr r0
     830:	304e4548 	subcc	r4, lr, r8, asr #10
     834:	69706700 	ldmdbvs	r0!, {r8, r9, sl, sp, lr}^
     838:	61625f6f 	cmnvs	r2, pc, ror #30
     83c:	615f6573 	cmpvs	pc, r3, ror r5	; <UNPREDICTABLE>
     840:	00726464 	rsbseq	r6, r2, r4, ror #8
     844:	454c5047 	strbmi	r5, [ip, #-71]	; 0xffffffb9
     848:	4500314e 	strmi	r3, [r0, #-334]	; 0xfffffeb2
     84c:	6c62616e 	stfvse	f6, [r2], #-440	; 0xfffffe48
     850:	76455f65 	strbvc	r5, [r5], -r5, ror #30
     854:	5f746e65 	svcpl	0x00746e65
     858:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
     85c:	5f007463 	svcpl	0x00007463
     860:	314b4e5a 	cmpcc	fp, sl, asr lr
     864:	50474333 	subpl	r4, r7, r3, lsr r3
     868:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     86c:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     870:	38317265 	ldmdacc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     874:	5f746547 	svcpl	0x00746547
     878:	44455047 	strbmi	r5, [r5], #-71	; 0xffffffb9
     87c:	6f4c5f53 	svcvs	0x004c5f53
     880:	69746163 	ldmdbvs	r4!, {r0, r1, r5, r6, r8, sp, lr}^
     884:	6a456e6f 	bvs	115c248 <_bss_end+0x11517c0>
     888:	30536a52 	subscc	r6, r3, r2, asr sl
     88c:	6547005f 	strbvs	r0, [r7, #-95]	; 0xffffffa1
     890:	50475f74 	subpl	r5, r7, r4, ror pc
     894:	4c455346 	mcrrmi	3, 4, r5, r5, cr6
     898:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     89c:	6f697461 	svcvs	0x00697461
     8a0:	7974006e 	ldmdbvc	r4!, {r1, r2, r3, r5, r6}^
     8a4:	2f006570 	svccs	0x00006570
     8a8:	2f746e6d 	svccs	0x00746e6d
     8ac:	73552f63 	cmpvc	r5, #396	; 0x18c
     8b0:	2f737265 	svccs	0x00737265
     8b4:	6162754b 	cmnvs	r2, fp, asr #10
     8b8:	636f442f 	cmnvs	pc, #788529152	; 0x2f000000
     8bc:	6e656d75 	mcrvs	13, 3, r6, cr5, cr5, {3}
     8c0:	5a2f7374 	bpl	bdd698 <_bss_end+0xbd2c10>
     8c4:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 738 <CPSR_IRQ_INHIBIT+0x6b8>
     8c8:	2f657461 	svccs	0x00657461
     8cc:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
     8d0:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
     8d4:	2d30322f 	lfmcs	f3, 4, [r0, #-188]!	; 0xffffff44
     8d8:	54524155 	ldrbpl	r4, [r2], #-341	; 0xfffffeab
     8dc:	6d61675f 	stclvs	7, cr6, [r1, #-380]!	; 0xfffffe84
     8e0:	656b2f65 	strbvs	r2, [fp, #-3941]!	; 0xfffff09b
     8e4:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
     8e8:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
     8ec:	6972642f 	ldmdbvs	r2!, {r0, r1, r2, r3, r5, sl, sp, lr}^
     8f0:	73726576 	cmnvc	r2, #494927872	; 0x1d800000
     8f4:	6970672f 	ldmdbvs	r0!, {r0, r1, r2, r3, r5, r8, r9, sl, sp, lr}^
     8f8:	70632e6f 	rsbvc	r2, r3, pc, ror #28
     8fc:	50470070 	subpl	r0, r7, r0, ror r0
     900:	525f4f49 	subspl	r4, pc, #292	; 0x124
     904:	5f006765 	svcpl	0x00006765
     908:	33314e5a 	teqcc	r1, #1440	; 0x5a0
     90c:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     910:	61485f4f 	cmpvs	r8, pc, asr #30
     914:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     918:	44303272 	ldrtmi	r3, [r0], #-626	; 0xfffffd8e
     91c:	62617369 	rsbvs	r7, r1, #-1543503871	; 0xa4000001
     920:	455f656c 	ldrbmi	r6, [pc, #-1388]	; 3bc <CPSR_IRQ_INHIBIT+0x33c>
     924:	746e6576 	strbtvc	r6, [lr], #-1398	; 0xfffffa8a
     928:	7465445f 	strbtvc	r4, [r5], #-1119	; 0xfffffba1
     92c:	45746365 	ldrbmi	r6, [r4, #-869]!	; 0xfffffc9b
     930:	4e30326a 	cdpmi	2, 3, cr3, cr0, cr10, {3}
     934:	4f495047 	svcmi	0x00495047
     938:	746e495f 	strbtvc	r4, [lr], #-2399	; 0xfffff6a1
     93c:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
     940:	545f7470 	ldrbpl	r7, [pc], #-1136	; 948 <CPSR_IRQ_INHIBIT+0x8c8>
     944:	00657079 	rsbeq	r7, r5, r9, ror r0
     948:	314e5a5f 	cmpcc	lr, pc, asr sl
     94c:	50474333 	subpl	r4, r7, r3, lsr r3
     950:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     954:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     958:	37317265 	ldrcc	r7, [r1, -r5, ror #4]!
     95c:	5f746553 	svcpl	0x00746553
     960:	4f495047 	svcmi	0x00495047
     964:	6e75465f 	mrcvs	6, 3, r4, cr5, cr15, {2}
     968:	6f697463 	svcvs	0x00697463
     96c:	316a456e 	cmncc	sl, lr, ror #10
     970:	50474e34 	subpl	r4, r7, r4, lsr lr
     974:	465f4f49 	ldrbmi	r4, [pc], -r9, asr #30
     978:	74636e75 	strbtvc	r6, [r3], #-3701	; 0xfffff18b
     97c:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     980:	69736952 	ldmdbvs	r3!, {r1, r4, r6, r8, fp, sp, lr}^
     984:	455f676e 	ldrbmi	r6, [pc, #-1902]	; 21e <CPSR_IRQ_INHIBIT+0x19e>
     988:	00656764 	rsbeq	r6, r5, r4, ror #14
     98c:	5f746c41 	svcpl	0x00746c41
     990:	50470032 	subpl	r0, r7, r2, lsr r0
     994:	3056454c 	subscc	r4, r6, ip, asr #10
     998:	4c504700 	mrrcmi	7, 0, r4, r0, cr0
     99c:	00315645 	eorseq	r5, r1, r5, asr #12
     9a0:	5f746553 	svcpl	0x00746553
     9a4:	4f495047 	svcmi	0x00495047
     9a8:	6e75465f 	mrcvs	6, 3, r4, cr5, cr15, {2}
     9ac:	6f697463 	svcvs	0x00697463
     9b0:	6962006e 	stmdbvs	r2!, {r1, r2, r3, r5, r6}^
     9b4:	64695f74 	strbtvs	r5, [r9], #-3956	; 0xfffff08c
     9b8:	5a5f0078 	bpl	17c0ba0 <_bss_end+0x17b6118>
     9bc:	33314b4e 	teqcc	r1, #79872	; 0x13800
     9c0:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     9c4:	61485f4f 	cmpvs	r8, pc, asr #30
     9c8:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     9cc:	47383172 			; <UNDEFINED> instruction: 0x47383172
     9d0:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     9d4:	54455350 	strbpl	r5, [r5], #-848	; 0xfffffcb0
     9d8:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     9dc:	6f697461 	svcvs	0x00697461
     9e0:	526a456e 	rsbpl	r4, sl, #461373440	; 0x1b800000
     9e4:	5f30536a 	svcpl	0x0030536a
     9e8:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     9ec:	4350475f 	cmpmi	r0, #24903680	; 0x17c0000
     9f0:	4c5f524c 	lfmmi	f5, 2, [pc], {76}	; 0x4c
     9f4:	7461636f 	strbtvc	r6, [r1], #-879	; 0xfffffc91
     9f8:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     9fc:	636e7566 	cmnvs	lr, #427819008	; 0x19800000
     a00:	706e4900 	rsbvc	r4, lr, r0, lsl #18
     a04:	47007475 	smlsdxmi	r0, r5, r4, r7
     a08:	4e454650 	mcrmi	6, 2, r4, cr5, cr0, {2}
     a0c:	65530030 	ldrbvs	r0, [r3, #-48]	; 0xffffffd0
     a10:	754f5f74 	strbvc	r5, [pc, #-3956]	; fffffaa4 <_bss_end+0xffff501c>
     a14:	74757074 	ldrbtvc	r7, [r5], #-116	; 0xffffff8c
     a18:	73694400 	cmnvc	r9, #0, 8
     a1c:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     a20:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
     a24:	445f746e 	ldrbmi	r7, [pc], #-1134	; a2c <CPSR_IRQ_INHIBIT+0x9ac>
     a28:	63657465 	cmnvs	r5, #1694498816	; 0x65000000
     a2c:	61460074 	hvcvs	24580	; 0x6004
     a30:	6e696c6c 	cdpvs	12, 6, cr6, cr9, cr12, {3}
     a34:	64455f67 	strbvs	r5, [r5], #-3943	; 0xfffff099
     a38:	41006567 	tstmi	r0, r7, ror #10
     a3c:	305f746c 	subscc	r7, pc, ip, ror #8
     a40:	746c4100 	strbtvc	r4, [ip], #-256	; 0xffffff00
     a44:	4100315f 	tstmi	r0, pc, asr r1
     a48:	335f746c 	cmpcc	pc, #108, 8	; 0x6c000000
     a4c:	746c4100 	strbtvc	r4, [ip], #-256	; 0xffffff00
     a50:	4100345f 	tstmi	r0, pc, asr r4
     a54:	355f746c 	ldrbcc	r7, [pc, #-1132]	; 5f0 <CPSR_IRQ_INHIBIT+0x570>
     a58:	43504700 	cmpmi	r0, #0, 14
     a5c:	0030524c 	eorseq	r5, r0, ip, asr #4
     a60:	75635f6d 	strbvc	r5, [r3, #-3949]!	; 0xfffff093
     a64:	726f7372 	rsbvc	r7, pc, #-939524095	; 0xc8000001
     a68:	72635300 	rsbvc	r5, r3, #0, 6
     a6c:	006c6c6f 	rsbeq	r6, ip, pc, ror #24
     a70:	756e5f6d 	strbvc	r5, [lr, #-3949]!	; 0xfffff093
     a74:	7265626d 	rsbvc	r6, r5, #-805306362	; 0xd0000006
     a78:	7361625f 	cmnvc	r1, #-268435451	; 0xf0000005
     a7c:	65520065 	ldrbvs	r0, [r2, #-101]	; 0xffffff9b
     a80:	5f746573 	svcpl	0x00746573
     a84:	626d754e 	rsbvs	r7, sp, #327155712	; 0x13800000
     a88:	425f7265 	subsmi	r7, pc, #1342177286	; 0x50000006
     a8c:	00657361 	rsbeq	r7, r5, r1, ror #6
     a90:	61656c43 	cmnvs	r5, r3, asr #24
     a94:	5a5f0072 	bpl	17c0c64 <_bss_end+0x17b61dc>
     a98:	4d43384e 	stclmi	8, cr3, [r3, #-312]	; 0xfffffec8
     a9c:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
     aa0:	3243726f 	subcc	r7, r3, #-268435450	; 0xf0000006
     aa4:	6a6a6a45 	bvs	1a9b3c0 <_bss_end+0x1a90938>
     aa8:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     aac:	6f4d4338 	svcvs	0x004d4338
     ab0:	6f74696e 	svcvs	0x0074696e
     ab4:	41333172 	teqmi	r3, r2, ror r1
     ab8:	73756a64 	cmnvc	r5, #100, 20	; 0x64000
     abc:	75435f74 	strbvc	r5, [r3, #-3956]	; 0xfffff08c
     ac0:	726f7372 	rsbvc	r7, pc, #-939524095	; 0xc8000001
     ac4:	69007645 	stmdbvs	r0, {r0, r2, r6, r9, sl, ip, sp, lr}
     ac8:	00616f74 	rsbeq	r6, r1, r4, ror pc
     acc:	65736552 	ldrbvs	r6, [r3, #-1362]!	; 0xfffffaae
     ad0:	75435f74 	strbvc	r5, [r3, #-3956]	; 0xfffff08c
     ad4:	726f7372 	rsbvc	r7, pc, #-939524095	; 0xc8000001
     ad8:	6a644100 	bvs	1910ee0 <_bss_end+0x1906458>
     adc:	5f747375 	svcpl	0x00747375
     ae0:	73727543 	cmnvc	r2, #281018368	; 0x10c00000
     ae4:	4e00726f 	cdpmi	2, 0, cr7, cr0, cr15, {3}
     ae8:	626d754e 	rsbvs	r7, sp, #327155712	; 0x13800000
     aec:	425f7265 	subsmi	r7, pc, #1342177286	; 0x50000006
     af0:	00657361 	rsbeq	r7, r5, r1, ror #6
     af4:	736f5054 	cmnvc	pc, #84	; 0x54
     af8:	6f697469 	svcvs	0x00697469
     afc:	5a5f006e 	bpl	17c0cbc <_bss_end+0x17b6234>
     b00:	4d43384e 	stclmi	8, cr3, [r3, #-312]	; 0xfffffec8
     b04:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
     b08:	3731726f 	ldrcc	r7, [r1, -pc, ror #4]!
     b0c:	65736552 	ldrbvs	r6, [r3, #-1362]!	; 0xfffffaae
     b10:	754e5f74 	strbvc	r5, [lr, #-3956]	; 0xfffff08c
     b14:	7265626d 	rsbvc	r6, r5, #-805306362	; 0xd0000006
     b18:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
     b1c:	00764565 	rsbseq	r4, r6, r5, ror #10
     b20:	6f6d5f6d 	svcvs	0x006d5f6d
     b24:	6f74696e 	svcvs	0x0074696e
     b28:	475f0072 			; <UNDEFINED> instruction: 0x475f0072
     b2c:	41424f4c 	cmpmi	r2, ip, asr #30
     b30:	735f5f4c 	cmpvc	pc, #76, 30	; 0x130
     b34:	495f6275 	ldmdbmi	pc, {r0, r2, r4, r5, r6, r9, sp, lr}^	; <UNPREDICTABLE>
     b38:	6f4d735f 	svcvs	0x004d735f
     b3c:	6f74696e 	svcvs	0x0074696e
     b40:	6f6d0072 	svcvs	0x006d0072
     b44:	6f74696e 	svcvs	0x0074696e
     b48:	61625f72 	smcvs	9714	; 0x25f2
     b4c:	615f6573 	cmpvs	pc, r3, ror r5	; <UNPREDICTABLE>
     b50:	00726464 	rsbseq	r6, r2, r4, ror #8
     b54:	384e5a5f 	stmdacc	lr, {r0, r1, r2, r3, r4, r6, r9, fp, ip, lr}^
     b58:	6e6f4d43 	cdpvs	13, 6, cr4, cr15, cr3, {2}
     b5c:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
     b60:	656c4335 	strbvs	r4, [ip, #-821]!	; 0xfffffccb
     b64:	76457261 	strbvc	r7, [r5], -r1, ror #4
     b68:	6f4d4300 	svcvs	0x004d4300
     b6c:	6f74696e 	svcvs	0x0074696e
     b70:	706f0072 	rsbvc	r0, pc, r2, ror r0	; <UNPREDICTABLE>
     b74:	74617265 	strbtvc	r7, [r1], #-613	; 0xfffffd9b
     b78:	3c3c726f 	lfmcc	f7, 4, [ip], #-444	; 0xfffffe44
     b7c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     b80:	6f4d4338 	svcvs	0x004d4338
     b84:	6f74696e 	svcvs	0x0074696e
     b88:	45736c72 	ldrbmi	r6, [r3, #-3186]!	; 0xfffff38e
     b8c:	00634b50 	rsbeq	r4, r3, r0, asr fp
     b90:	384e5a5f 	stmdacc	lr, {r0, r1, r2, r3, r4, r6, r9, fp, ip, lr}^
     b94:	6e6f4d43 	cdpvs	13, 6, cr4, cr15, cr3, {2}
     b98:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
     b9c:	6f746934 	svcvs	0x00746934
     ba0:	506a4561 	rsbpl	r4, sl, r1, ror #10
     ba4:	6d006a63 	vstrvs	s12, [r0, #-396]	; 0xfffffe74
     ba8:	6965685f 	stmdbvs	r5!, {r0, r1, r2, r3, r4, r6, fp, sp, lr}^
     bac:	00746867 	rsbseq	r6, r4, r7, ror #16
     bb0:	72616843 	rsbvc	r6, r1, #4390912	; 0x430000
     bb4:	766e6f43 	strbtvc	r6, [lr], -r3, asr #30
     bb8:	00727241 	rsbseq	r7, r2, r1, asr #4
     bbc:	384e5a5f 	stmdacc	lr, {r0, r1, r2, r3, r4, r6, r9, fp, ip, lr}^
     bc0:	6e6f4d43 	cdpvs	13, 6, cr4, cr15, cr3, {2}
     bc4:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
     bc8:	6245736c 	subvs	r7, r5, #108, 6	; 0xb0000001
     bcc:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     bd0:	6f4d4338 	svcvs	0x004d4338
     bd4:	6f74696e 	svcvs	0x0074696e
     bd8:	45736c72 	ldrbmi	r6, [r3, #-3186]!	; 0xfffff38e
     bdc:	5f6d0063 	svcpl	0x006d0063
     be0:	74646977 	strbtvc	r6, [r4], #-2423	; 0xfffff689
     be4:	5a5f0068 	bpl	17c0d8c <_bss_end+0x17b6304>
     be8:	4d43384e 	stclmi	8, cr3, [r3, #-312]	; 0xfffffec8
     bec:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
     bf0:	5336726f 	teqpl	r6, #-268435450	; 0xf0000006
     bf4:	6c6f7263 	sfmvs	f7, 2, [pc], #-396	; a70 <CPSR_IRQ_INHIBIT+0x9f0>
     bf8:	0076456c 	rsbseq	r4, r6, ip, ror #10
     bfc:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
     c00:	552f632f 	strpl	r6, [pc, #-815]!	; 8d9 <CPSR_IRQ_INHIBIT+0x859>
     c04:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
     c08:	62754b2f 	rsbsvs	r4, r5, #48128	; 0xbc00
     c0c:	6f442f61 	svcvs	0x00442f61
     c10:	656d7563 	strbvs	r7, [sp, #-1379]!	; 0xfffffa9d
     c14:	2f73746e 	svccs	0x0073746e
     c18:	6f72655a 	svcvs	0x0072655a
     c1c:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
     c20:	6178652f 	cmnvs	r8, pc, lsr #10
     c24:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
     c28:	30322f73 	eorscc	r2, r2, r3, ror pc
     c2c:	5241552d 	subpl	r5, r1, #188743680	; 0xb400000
     c30:	61675f54 	cmnvs	r7, r4, asr pc
     c34:	6b2f656d 	blvs	bda1f0 <_bss_end+0xbcf768>
     c38:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
     c3c:	72732f6c 	rsbsvc	r2, r3, #108, 30	; 0x1b0
     c40:	72642f63 	rsbvc	r2, r4, #396	; 0x18c
     c44:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
     c48:	6f6d2f73 	svcvs	0x006d2f73
     c4c:	6f74696e 	svcvs	0x0074696e
     c50:	70632e72 	rsbvc	r2, r3, r2, ror lr
     c54:	5a5f0070 	bpl	17c0e1c <_bss_end+0x17b6394>
     c58:	4d43384e 	stclmi	8, cr3, [r3, #-312]	; 0xfffffec8
     c5c:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
     c60:	3231726f 	eorscc	r7, r1, #-268435450	; 0xf0000006
     c64:	65736552 	ldrbvs	r6, [r3, #-1362]!	; 0xfffffaae
     c68:	75435f74 	strbvc	r5, [r3, #-3956]	; 0xfffff08c
     c6c:	726f7372 	rsbvc	r7, pc, #-939524095	; 0xc8000001
     c70:	5f007645 	svcpl	0x00007645
     c74:	43384e5a 	teqmi	r8, #1440	; 0x5a0
     c78:	696e6f4d 	stmdbvs	lr!, {r0, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     c7c:	43726f74 	cmnmi	r2, #116, 30	; 0x1d0
     c80:	6a6a4534 	bvs	1a92158 <_bss_end+0x1a876d0>
     c84:	5a5f006a 	bpl	17c0e34 <_bss_end+0x17b63ac>
     c88:	4d43384e 	stclmi	8, cr3, [r3, #-312]	; 0xfffffec8
     c8c:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
     c90:	736c726f 	cmnvc	ip, #-268435450	; 0xf0000006
     c94:	44006a45 	strmi	r6, [r0], #-2629	; 0xfffff5bb
     c98:	55414645 	strbpl	r4, [r1, #-1605]	; 0xfffff9bb
     c9c:	4e5f544c 	cdpmi	4, 5, cr5, cr15, cr12, {2}
     ca0:	45424d55 	strbmi	r4, [r2, #-3413]	; 0xfffff2ab
     ca4:	41425f52 	cmpmi	r2, r2, asr pc
     ca8:	5f004553 	svcpl	0x00004553
     cac:	43384e5a 	teqmi	r8, #1440	; 0x5a0
     cb0:	696e6f4d 	stmdbvs	lr!, {r0, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     cb4:	6c726f74 	ldclvs	15, cr6, [r2], #-464	; 0xfffffe30
     cb8:	534e4573 	movtpl	r4, #58739	; 0xe573
     cbc:	4e32315f 	mrcmi	1, 1, r3, cr2, cr15, {2}
     cc0:	626d754e 	rsbvs	r7, sp, #327155712	; 0x13800000
     cc4:	425f7265 	subsmi	r7, pc, #1342177286	; 0x50000006
     cc8:	45657361 	strbmi	r7, [r5, #-865]!	; 0xfffffc9f
     ccc:	74756f00 	ldrbtvc	r6, [r5], #-3840	; 0xfffff100
     cd0:	00747570 	rsbseq	r7, r4, r0, ror r5
     cd4:	75706e69 	ldrbvc	r6, [r0, #-3689]!	; 0xfffff197
     cd8:	5f730074 	svcpl	0x00730074
     cdc:	66667562 	strbtvs	r7, [r6], -r2, ror #10
     ce0:	42007265 	andmi	r7, r0, #1342177286	; 0x50000006
     ce4:	45464655 	strbmi	r4, [r6, #-1621]	; 0xfffff9ab
     ce8:	49535f52 	ldmdbmi	r3, {r1, r4, r6, r8, r9, sl, fp, ip, lr}^
     cec:	5f00455a 	svcpl	0x0000455a
     cf0:	43354e5a 	teqmi	r5, #1440	; 0x5a0
     cf4:	54524155 	ldrbpl	r4, [r2], #-341	; 0xfffffeab
     cf8:	6e453831 	mcrvs	8, 2, r3, cr5, cr1, {1}
     cfc:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     d00:	6365525f 	cmnvs	r5, #-268435451	; 0xf0000005
     d04:	65766965 	ldrbvs	r6, [r6, #-2405]!	; 0xfffff69b
     d08:	746e495f 	strbtvc	r4, [lr], #-2399	; 0xfffff6a1
     d0c:	42007645 	andmi	r7, r0, #72351744	; 0x4500000
     d10:	34325f52 	ldrtcc	r5, [r2], #-3922	; 0xfffff0ae
     d14:	57003030 	smladxpl	r0, r0, r0, r3
     d18:	65746972 	ldrbvs	r6, [r4, #-2418]!	; 0xfffff68e
     d1c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     d20:	41554335 	cmpmi	r5, r5, lsr r3
     d24:	57395452 			; <UNDEFINED> instruction: 0x57395452
     d28:	65746972 	ldrbvs	r6, [r4, #-2418]!	; 0xfffff68e
     d2c:	7865485f 	stmdavc	r5!, {r0, r1, r2, r3, r4, r6, fp, lr}^
     d30:	6d006a45 	vstrvs	s12, [r0, #-276]	; 0xfffffeec
     d34:	00585541 	subseq	r5, r8, r1, asr #10
     d38:	345f5242 	ldrbcc	r5, [pc], #-578	; d40 <CPSR_IRQ_INHIBIT+0xcc0>
     d3c:	00303038 	eorseq	r3, r0, r8, lsr r0
     d40:	354e5a5f 	strbcc	r5, [lr, #-2655]	; 0xfffff5a1
     d44:	52415543 	subpl	r5, r1, #281018368	; 0x10c00000
     d48:	45393154 	ldrmi	r3, [r9, #-340]!	; 0xfffffeac
     d4c:	6c62616e 	stfvse	f6, [r2], #-440	; 0xfffffe48
     d50:	72545f65 	subsvc	r5, r4, #404	; 0x194
     d54:	6d736e61 	ldclvs	14, cr6, [r3, #-388]!	; 0xfffffe7c
     d58:	495f7469 	ldmdbmi	pc, {r0, r3, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
     d5c:	7645746e 	strbvc	r7, [r5], -lr, ror #8
     d60:	61655200 	cmnvs	r5, r0, lsl #4
     d64:	61720064 	cmnvs	r2, r4, rrx
     d68:	5f006574 	svcpl	0x00006574
     d6c:	43354e5a 	teqmi	r5, #1440	; 0x5a0
     d70:	54524155 	ldrbpl	r4, [r2], #-341	; 0xfffffeab
     d74:	69725735 	ldmdbvs	r2!, {r0, r2, r4, r5, r8, r9, sl, ip, lr}^
     d78:	50456574 	subpl	r6, r5, r4, ror r5
     d7c:	006a634b 	rsbeq	r6, sl, fp, asr #6
     d80:	354e5a5f 	strbcc	r5, [lr, #-2655]	; 0xfffff5a1
     d84:	52415543 	subpl	r5, r1, #281018368	; 0x10c00000
     d88:	65523454 	ldrbvs	r3, [r2, #-1108]	; 0xfffffbac
     d8c:	50456461 	subpl	r6, r5, r1, ror #8
     d90:	68430063 	stmdavs	r3, {r0, r1, r5, r6}^
     d94:	375f7261 	ldrbcc	r7, [pc, -r1, ror #4]
     d98:	74655300 	strbtvc	r5, [r5], #-768	; 0xfffffd00
     d9c:	6168435f 	cmnvs	r8, pc, asr r3
     da0:	654c5f72 	strbvs	r5, [ip, #-3954]	; 0xfffff08e
     da4:	6874676e 	ldmdavs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}^
     da8:	61684300 	cmnvs	r8, r0, lsl #6
     dac:	00385f72 	eorseq	r5, r8, r2, ror pc
     db0:	354e5a5f 	strbcc	r5, [lr, #-2655]	; 0xfffff5a1
     db4:	52415543 	subpl	r5, r1, #281018368	; 0x10c00000
     db8:	72573554 	subsvc	r3, r7, #84, 10	; 0x15000000
     dbc:	45657469 	strbmi	r7, [r5, #-1129]!	; 0xfffffb97
     dc0:	5a5f006a 	bpl	17c0f70 <_bss_end+0x17b64e8>
     dc4:	5543354e 	strbpl	r3, [r3, #-1358]	; 0xfffffab2
     dc8:	43545241 	cmpmi	r4, #268435460	; 0x10000004
     dcc:	34524532 	ldrbcc	r4, [r2], #-1330	; 0xffffface
     dd0:	58554143 	ldmdapl	r5, {r0, r1, r6, r8, lr}^
     dd4:	69725700 	ldmdbvs	r2!, {r8, r9, sl, ip, lr}^
     dd8:	485f6574 	ldmdami	pc, {r2, r4, r5, r6, r8, sl, sp, lr}^	; <UNPREDICTABLE>
     ddc:	45007865 	strmi	r7, [r0, #-2149]	; 0xfffff79b
     de0:	6c62616e 	stfvse	f6, [r2], #-440	; 0xfffffe48
     de4:	65525f65 	ldrbvs	r5, [r2, #-3941]	; 0xfffff09b
     de8:	76696563 	strbtvc	r6, [r9], -r3, ror #10
     dec:	6e495f65 	cdpvs	15, 4, cr5, cr9, cr5, {3}
     df0:	55430074 	strbpl	r0, [r3, #-116]	; 0xffffff8c
     df4:	00545241 	subseq	r5, r4, r1, asr #4
     df8:	4f4c475f 	svcmi	0x004c475f
     dfc:	5f4c4142 	svcpl	0x004c4142
     e00:	6275735f 	rsbsvs	r7, r5, #2080374785	; 0x7c000001
     e04:	735f495f 	cmpvc	pc, #1556480	; 0x17c000
     e08:	54524155 	ldrbpl	r4, [r2], #-341	; 0xfffffeab
     e0c:	52420030 	subpl	r0, r2, #48	; 0x30
     e10:	3239315f 	eorscc	r3, r9, #-1073741801	; 0xc0000017
     e14:	42003030 	andmi	r3, r0, #48	; 0x30
     e18:	38335f52 	ldmdacc	r3!, {r1, r4, r6, r8, r9, sl, fp, ip, lr}
     e1c:	00303034 	eorseq	r3, r0, r4, lsr r0
     e20:	355f5242 	ldrbcc	r5, [pc, #-578]	; be6 <CPSR_IRQ_INHIBIT+0xb66>
     e24:	30303637 	eorscc	r3, r0, r7, lsr r6
     e28:	74655300 	strbtvc	r5, [r5], #-768	; 0xfffffd00
     e2c:	7561425f 	strbvc	r4, [r1, #-607]!	; 0xfffffda1
     e30:	61525f64 	cmpvs	r2, r4, ror #30
     e34:	42006574 	andmi	r6, r0, #116, 10	; 0x1d000000
     e38:	31315f52 	teqcc	r1, r2, asr pc
     e3c:	30303235 	eorscc	r3, r0, r5, lsr r2
     e40:	5f524200 	svcpl	0x00524200
     e44:	30303231 	eorscc	r3, r0, r1, lsr r2
     e48:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     e4c:	41554335 	cmpmi	r5, r5, lsr r3
     e50:	33315452 	teqcc	r1, #1375731712	; 0x52000000
     e54:	5f746553 	svcpl	0x00746553
     e58:	64756142 	ldrbtvs	r6, [r5], #-322	; 0xfffffebe
     e5c:	7461525f 	strbtvc	r5, [r1], #-607	; 0xfffffda1
     e60:	35314565 	ldrcc	r4, [r1, #-1381]!	; 0xfffffa9b
     e64:	5241554e 	subpl	r5, r1, #327155712	; 0x13800000
     e68:	61425f54 	cmpvs	r2, r4, asr pc
     e6c:	525f6475 	subspl	r6, pc, #1962934272	; 0x75000000
     e70:	00657461 	rsbeq	r7, r5, r1, ror #8
     e74:	354e5a5f 	strbcc	r5, [lr, #-2655]	; 0xfffff5a1
     e78:	52415543 	subpl	r5, r1, #281018368	; 0x10c00000
     e7c:	72573554 	subsvc	r3, r7, #84, 10	; 0x15000000
     e80:	45657469 	strbmi	r7, [r5, #-1129]!	; 0xfffffb97
     e84:	5a5f0063 	bpl	17c1018 <_bss_end+0x17b6590>
     e88:	5543354e 	strbpl	r3, [r3, #-1358]	; 0xfffffab2
     e8c:	43545241 	cmpmi	r4, #268435460	; 0x10000004
     e90:	34524534 	ldrbcc	r4, [r2], #-1332	; 0xfffffacc
     e94:	58554143 	ldmdapl	r5, {r0, r1, r6, r8, lr}^
     e98:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     e9c:	41554335 	cmpmi	r5, r5, lsr r3
     ea0:	57355452 			; <UNDEFINED> instruction: 0x57355452
     ea4:	65746972 	ldrbvs	r6, [r4, #-2418]!	; 0xfffff68e
     ea8:	634b5045 	movtvs	r5, #45125	; 0xb045
     eac:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     eb0:	41554335 	cmpmi	r5, r5, lsr r3
     eb4:	35315452 	ldrcc	r5, [r1, #-1106]!	; 0xfffffbae
     eb8:	5f746553 	svcpl	0x00746553
     ebc:	72616843 	rsbvc	r6, r1, #4390912	; 0x430000
     ec0:	6e654c5f 	mcrvs	12, 3, r4, cr5, cr15, {2}
     ec4:	45687467 	strbmi	r7, [r8, #-1127]!	; 0xfffffb99
     ec8:	554e3731 	strbpl	r3, [lr, #-1841]	; 0xfffff8cf
     ecc:	5f545241 	svcpl	0x00545241
     ed0:	72616843 	rsbvc	r6, r1, #4390912	; 0x430000
     ed4:	6e654c5f 	mcrvs	12, 3, r4, cr5, cr15, {2}
     ed8:	00687467 	rsbeq	r7, r8, r7, ror #8
     edc:	62616e45 	rsbvs	r6, r1, #1104	; 0x450
     ee0:	545f656c 	ldrbpl	r6, [pc], #-1388	; ee8 <CPSR_IRQ_INHIBIT+0xe68>
     ee4:	736e6172 	cmnvc	lr, #-2147483620	; 0x8000001c
     ee8:	5f74696d 	svcpl	0x0074696d
     eec:	00746e49 	rsbseq	r6, r4, r9, asr #28
     ef0:	395f5242 	ldmdbcc	pc, {r1, r6, r9, ip, lr}^	; <UNPREDICTABLE>
     ef4:	00303036 	eorseq	r3, r0, r6, lsr r0
     ef8:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
     efc:	552f632f 	strpl	r6, [pc, #-815]!	; bd5 <CPSR_IRQ_INHIBIT+0xb55>
     f00:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
     f04:	62754b2f 	rsbsvs	r4, r5, #48128	; 0xbc00
     f08:	6f442f61 	svcvs	0x00442f61
     f0c:	656d7563 	strbvs	r7, [sp, #-1379]!	; 0xfffffa9d
     f10:	2f73746e 	svccs	0x0073746e
     f14:	6f72655a 	svcvs	0x0072655a
     f18:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
     f1c:	6178652f 	cmnvs	r8, pc, lsr #10
     f20:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
     f24:	30322f73 	eorscc	r2, r2, r3, ror pc
     f28:	5241552d 	subpl	r5, r1, #188743680	; 0xb400000
     f2c:	61675f54 	cmnvs	r7, r4, asr pc
     f30:	6b2f656d 	blvs	bda4ec <_bss_end+0xbcfa64>
     f34:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
     f38:	72732f6c 	rsbsvc	r2, r3, #108, 30	; 0x1b0
     f3c:	72642f63 	rsbvc	r2, r4, #396	; 0x18c
     f40:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
     f44:	61752f73 	cmnvs	r5, r3, ror pc
     f48:	632e7472 			; <UNDEFINED> instruction: 0x632e7472
     f4c:	5f007070 	svcpl	0x00007070
     f50:	31324e5a 	teqcc	r2, sl, asr lr
     f54:	746e4943 	strbtvc	r4, [lr], #-2371	; 0xfffff6bd
     f58:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
     f5c:	435f7470 	cmpmi	pc, #112, 8	; 0x70000000
     f60:	72746e6f 	rsbsvc	r6, r4, #1776	; 0x6f0
     f64:	656c6c6f 	strbvs	r6, [ip, #-3183]!	; 0xfffff391
     f68:	45303172 	ldrmi	r3, [r0, #-370]!	; 0xfffffe8e
     f6c:	6c62616e 	stfvse	f6, [r2], #-440	; 0xfffffe48
     f70:	52495f65 	subpl	r5, r9, #404	; 0x194
     f74:	334e4551 	movtcc	r4, #58705	; 0xe551
     f78:	316c6168 	cmncc	ip, r8, ror #2
     f7c:	51524930 	cmppl	r2, r0, lsr r9
     f80:	756f535f 	strbvc	r5, [pc, #-863]!	; c29 <CPSR_IRQ_INHIBIT+0xba9>
     f84:	45656372 	strbmi	r6, [r5, #-882]!	; 0xfffffc8e
     f88:	78646900 	stmdavc	r4!, {r8, fp, sp, lr}^
     f8c:	7361625f 	cmnvc	r1, #-268435451	; 0xf0000005
     f90:	5a5f0065 	bpl	17c112c <_bss_end+0x17b66a4>
     f94:	4331324e 	teqmi	r1, #-536870908	; 0xe0000004
     f98:	65746e49 	ldrbvs	r6, [r4, #-3657]!	; 0xfffff1b7
     f9c:	70757272 	rsbsvc	r7, r5, r2, ror r2
     fa0:	6f435f74 	svcvs	0x00435f74
     fa4:	6f72746e 	svcvs	0x0072746e
     fa8:	72656c6c 	rsbvc	r6, r5, #108, 24	; 0x6c00
     fac:	67655234 			; <UNDEFINED> instruction: 0x67655234
     fb0:	334e4573 	movtcc	r4, #58739	; 0xe573
     fb4:	326c6168 	rsbcc	r6, ip, #104, 2
     fb8:	746e4934 	strbtvc	r4, [lr], #-2356	; 0xfffff6cc
     fbc:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
     fc0:	435f7470 	cmpmi	pc, #112, 8	; 0x70000000
     fc4:	72746e6f 	rsbsvc	r6, r4, #1776	; 0x6f0
     fc8:	656c6c6f 	strbvs	r6, [ip, #-3183]!	; 0xfffff391
     fcc:	65525f72 	ldrbvs	r5, [r2, #-3954]	; 0xfffff08e
     fd0:	47004567 	strmi	r4, [r0, -r7, ror #10]
     fd4:	5f315550 	svcpl	0x00315550
     fd8:	746c6148 	strbtvc	r6, [ip], #-328	; 0xfffffeb8
     fdc:	69614d00 	stmdbvs	r1!, {r8, sl, fp, lr}^
     fe0:	786f626c 	stmdavc	pc!, {r2, r3, r5, r6, r9, sp, lr}^	; <UNPREDICTABLE>
     fe4:	616e4500 	cmnvs	lr, r0, lsl #10
     fe8:	5f656c62 	svcpl	0x00656c62
     fec:	00515249 	subseq	r5, r1, r9, asr #4
     ff0:	4f4c475f 	svcmi	0x004c475f
     ff4:	5f4c4142 	svcpl	0x004c4142
     ff8:	6275735f 	rsbsvs	r7, r5, #2080374785	; 0x7c000001
     ffc:	675f495f 			; <UNDEFINED> instruction: 0x675f495f
    1000:	5f656d61 	svcpl	0x00656d61
    1004:	74617473 	strbtvc	r7, [r1], #-1139	; 0xfffffb8d
    1008:	696d0065 	stmdbvs	sp!, {r0, r2, r5, r6}^
    100c:	756e5f6e 	strbvc	r5, [lr, #-3950]!	; 0xfffff092
    1010:	5249006d 	subpl	r0, r9, #109	; 0x6d
    1014:	6e455f51 	mcrvs	15, 2, r5, cr5, cr1, {2}
    1018:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
    101c:	4900315f 	stmdbmi	r0, {r0, r1, r2, r3, r4, r6, r8, ip, sp}
    1020:	455f5152 	ldrbmi	r5, [pc, #-338]	; ed6 <CPSR_IRQ_INHIBIT+0xe56>
    1024:	6c62616e 	stfvse	f6, [r2], #-440	; 0xfffffe48
    1028:	00325f65 	eorseq	r5, r2, r5, ror #30
    102c:	324e5a5f 	subcc	r5, lr, #389120	; 0x5f000
    1030:	6e494331 	mcrvs	3, 2, r4, cr9, cr1, {1}
    1034:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
    1038:	5f747075 	svcpl	0x00747075
    103c:	746e6f43 	strbtvc	r6, [lr], #-3907	; 0xfffff0bd
    1040:	6c6c6f72 	stclvs	15, cr6, [ip], #-456	; 0xfffffe38
    1044:	37317265 	ldrcc	r7, [r1, -r5, ror #4]!
    1048:	61736944 	cmnvs	r3, r4, asr #18
    104c:	5f656c62 	svcpl	0x00656c62
    1050:	69736142 	ldmdbvs	r3!, {r1, r6, r8, sp, lr}^
    1054:	52495f63 	subpl	r5, r9, #396	; 0x18c
    1058:	334e4551 	movtcc	r4, #58705	; 0xe551
    105c:	316c6168 	cmncc	ip, r8, ror #2
    1060:	51524936 	cmppl	r2, r6, lsr r9
    1064:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
    1068:	535f6369 	cmppl	pc, #-1543503871	; 0xa4000001
    106c:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
    1070:	49004565 	stmdbmi	r0, {r0, r2, r5, r6, r8, sl, lr}
    1074:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
    1078:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
    107c:	6e6f435f 	mcrvs	3, 3, r4, cr15, cr15, {2}
    1080:	6c6f7274 	sfmvs	f7, 2, [pc], #-464	; eb8 <CPSR_IRQ_INHIBIT+0xe38>
    1084:	5f72656c 	svcpl	0x0072656c
    1088:	00676552 	rsbeq	r6, r7, r2, asr r5
    108c:	61736944 	cmnvs	r3, r4, asr #18
    1090:	5f656c62 	svcpl	0x00656c62
    1094:	00515249 	subseq	r5, r1, r9, asr #4
    1098:	656c6c49 	strbvs	r6, [ip, #-3145]!	; 0xfffff3b7
    109c:	5f6c6167 	svcpl	0x006c6167
    10a0:	65636341 	strbvs	r6, [r3, #-833]!	; 0xfffffcbf
    10a4:	315f7373 	cmpcc	pc, r3, ror r3	; <UNPREDICTABLE>
    10a8:	6c6c4900 			; <UNDEFINED> instruction: 0x6c6c4900
    10ac:	6c616765 	stclvs	7, cr6, [r1], #-404	; 0xfffffe6c
    10b0:	6363415f 	cmnvs	r3, #-1073741801	; 0xc0000017
    10b4:	5f737365 	svcpl	0x00737365
    10b8:	52490032 	subpl	r0, r9, #50	; 0x32
    10bc:	61425f51 	cmpvs	r2, r1, asr pc
    10c0:	5f636973 	svcpl	0x00636973
    10c4:	72756f53 	rsbsvc	r6, r5, #332	; 0x14c
    10c8:	47006563 	strmi	r6, [r0, -r3, ror #10]
    10cc:	73736575 	cmnvc	r3, #490733568	; 0x1d400000
    10d0:	5f676e69 	svcpl	0x00676e69
    10d4:	656d6147 	strbvs	r6, [sp, #-327]!	; 0xfffffeb9
    10d8:	315a5f00 	cmpcc	sl, r0, lsl #30
    10dc:	65754733 	ldrbvs	r4, [r5, #-1843]!	; 0xfffff8cd
    10e0:	6e697373 	mcrvs	3, 3, r7, cr9, cr3, {3}
    10e4:	61475f67 	cmpvs	r7, r7, ror #30
    10e8:	0063656d 	rsbeq	r6, r3, sp, ror #10
    10ec:	656d6954 	strbvs	r6, [sp, #-2388]!	; 0xfffff6ac
    10f0:	5a5f0072 	bpl	17c12c0 <_bss_end+0x17b6838>
    10f4:	4331324e 	teqmi	r1, #-536870908	; 0xe0000004
    10f8:	65746e49 	ldrbvs	r6, [r4, #-3657]!	; 0xfffff1b7
    10fc:	70757272 	rsbsvc	r7, r5, r2, ror r2
    1100:	6f435f74 	svcvs	0x00435f74
    1104:	6f72746e 	svcvs	0x0072746e
    1108:	72656c6c 	rsbvc	r6, r5, #108, 24	; 0x6c00
    110c:	69443131 	stmdbvs	r4, {r0, r4, r5, r8, ip, sp}^
    1110:	6c626173 	stfvse	f6, [r2], #-460	; 0xfffffe34
    1114:	52495f65 	subpl	r5, r9, #404	; 0x194
    1118:	334e4551 	movtcc	r4, #58705	; 0xe551
    111c:	316c6168 	cmncc	ip, r8, ror #2
    1120:	51524930 	cmppl	r2, r0, lsr r9
    1124:	756f535f 	strbvc	r5, [pc, #-863]!	; dcd <CPSR_IRQ_INHIBIT+0xd4d>
    1128:	45656372 	strbmi	r6, [r5, #-882]!	; 0xfffffc8e
    112c:	73616600 	cmnvc	r1, #0, 12
    1130:	6e695f74 	mcrvs	15, 3, r5, cr9, cr4, {3}
    1134:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
    1138:	5f747075 	svcpl	0x00747075
    113c:	646e6168 	strbtvs	r6, [lr], #-360	; 0xfffffe98
    1140:	0072656c 	rsbseq	r6, r2, ip, ror #10
    1144:	5f515249 	svcpl	0x00515249
    1148:	69736142 	ldmdbvs	r3!, {r1, r6, r8, sp, lr}^
    114c:	65505f63 	ldrbvs	r5, [r0, #-3939]	; 0xfffff09d
    1150:	6e69646e 	cdpvs	4, 6, cr6, cr9, cr14, {3}
    1154:	6d2f0067 	stcvs	0, cr0, [pc, #-412]!	; fc0 <CPSR_IRQ_INHIBIT+0xf40>
    1158:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
    115c:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
    1160:	4b2f7372 	blmi	bddf30 <_bss_end+0xbd34a8>
    1164:	2f616275 	svccs	0x00616275
    1168:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
    116c:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
    1170:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
    1174:	614d6f72 	hvcvs	55026	; 0xd6f2
    1178:	652f6574 	strvs	r6, [pc, #-1396]!	; c0c <CPSR_IRQ_INHIBIT+0xb8c>
    117c:	706d6178 	rsbvc	r6, sp, r8, ror r1
    1180:	2f73656c 	svccs	0x0073656c
    1184:	552d3032 	strpl	r3, [sp, #-50]!	; 0xffffffce
    1188:	5f545241 	svcpl	0x00545241
    118c:	656d6167 	strbvs	r6, [sp, #-359]!	; 0xfffffe99
    1190:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
    1194:	2f6c656e 	svccs	0x006c656e
    1198:	2f637273 	svccs	0x00637273
    119c:	65746e69 	ldrbvs	r6, [r4, #-3689]!	; 0xfffff197
    11a0:	70757272 	rsbsvc	r7, r5, r2, ror r2
    11a4:	6f635f74 	svcvs	0x00635f74
    11a8:	6f72746e 	svcvs	0x0072746e
    11ac:	72656c6c 	rsbvc	r6, r5, #108, 24	; 0x6c00
    11b0:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
    11b4:	6e494300 	cdpvs	3, 4, cr4, cr9, cr0, {0}
    11b8:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
    11bc:	5f747075 	svcpl	0x00747075
    11c0:	746e6f43 	strbtvc	r6, [lr], #-3907	; 0xfffff0bd
    11c4:	6c6c6f72 	stclvs	15, cr6, [ip], #-456	; 0xfffffe38
    11c8:	49007265 	stmdbmi	r0, {r0, r2, r5, r6, r9, ip, sp, lr}
    11cc:	425f5152 	subsmi	r5, pc, #-2147483628	; 0x80000014
    11d0:	63697361 	cmnvs	r9, #-2080374783	; 0x84000001
    11d4:	7369445f 	cmnvc	r9, #1593835520	; 0x5f000000
    11d8:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
    11dc:	616e4500 	cmnvs	lr, r0, lsl #10
    11e0:	5f656c62 	svcpl	0x00656c62
    11e4:	69736142 	ldmdbvs	r3!, {r1, r6, r8, sp, lr}^
    11e8:	52495f63 	subpl	r5, r9, #396	; 0x18c
    11ec:	50470051 	subpl	r0, r7, r1, asr r0
    11f0:	485f3055 	ldmdami	pc, {r0, r2, r4, r6, ip, sp}^	; <UNPREDICTABLE>
    11f4:	00746c61 	rsbseq	r6, r4, r1, ror #24
    11f8:	5f78616d 	svcpl	0x0078616d
    11fc:	006d756e 	rsbeq	r7, sp, lr, ror #10
    1200:	726f6f44 	rsbvc	r6, pc, #68, 30	; 0x110
    1204:	6c6c6562 	cfstr64vs	mvdx6, [ip], #-392	; 0xfffffe78
    1208:	4400305f 	strmi	r3, [r0], #-95	; 0xffffffa1
    120c:	62726f6f 	rsbsvs	r6, r2, #444	; 0x1bc
    1210:	5f6c6c65 	svcpl	0x006c6c65
    1214:	49730031 	ldmdbmi	r3!, {r0, r4, r5}^
    1218:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
    121c:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
    1220:	006c7443 	rsbeq	r7, ip, r3, asr #8
    1224:	324e5a5f 	subcc	r5, lr, #389120	; 0x5f000
    1228:	6e494331 	mcrvs	3, 2, r4, cr9, cr1, {1}
    122c:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
    1230:	5f747075 	svcpl	0x00747075
    1234:	746e6f43 	strbtvc	r6, [lr], #-3907	; 0xfffff0bd
    1238:	6c6c6f72 	stclvs	15, cr6, [ip], #-456	; 0xfffffe38
    123c:	32437265 	subcc	r7, r3, #1342177286	; 0x50000006
    1240:	6d006d45 	stcvs	13, cr6, [r0, #-276]	; 0xfffffeec
    1244:	65746e49 	ldrbvs	r6, [r4, #-3657]!	; 0xfffff1b7
    1248:	70757272 	rsbsvc	r7, r5, r2, ror r2
    124c:	65525f74 	ldrbvs	r5, [r2, #-3956]	; 0xfffff08c
    1250:	5f007367 	svcpl	0x00007367
    1254:	31324e5a 	teqcc	r2, sl, asr lr
    1258:	746e4943 	strbtvc	r4, [lr], #-2371	; 0xfffff6bd
    125c:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
    1260:	435f7470 	cmpmi	pc, #112, 8	; 0x70000000
    1264:	72746e6f 	rsbsvc	r6, r4, #1776	; 0x6f0
    1268:	656c6c6f 	strbvs	r6, [ip, #-3183]!	; 0xfffff391
    126c:	45363172 	ldrmi	r3, [r6, #-370]!	; 0xfffffe8e
    1270:	6c62616e 	stfvse	f6, [r2], #-440	; 0xfffffe48
    1274:	61425f65 	cmpvs	r2, r5, ror #30
    1278:	5f636973 	svcpl	0x00636973
    127c:	45515249 	ldrbmi	r5, [r1, #-585]	; 0xfffffdb7
    1280:	6168334e 	cmnvs	r8, lr, asr #6
    1284:	4936316c 	ldmdbmi	r6!, {r2, r3, r5, r6, r8, ip, sp}
    1288:	425f5152 	subsmi	r5, pc, #-2147483628	; 0x80000014
    128c:	63697361 	cmnvs	r9, #-2080374783	; 0x84000001
    1290:	756f535f 	strbvc	r5, [pc, #-863]!	; f39 <CPSR_IRQ_INHIBIT+0xeb9>
    1294:	45656372 	strbmi	r6, [r5, #-882]!	; 0xfffffc8e
    1298:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
    129c:	49433132 	stmdbmi	r3, {r1, r4, r5, r8, ip, sp}^
    12a0:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
    12a4:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
    12a8:	6e6f435f 	mcrvs	3, 3, r4, cr15, cr15, {2}
    12ac:	6c6f7274 	sfmvs	f7, 2, [pc], #-464	; 10e4 <CPSR_IRQ_INHIBIT+0x1064>
    12b0:	4372656c 	cmnmi	r2, #108, 10	; 0x1b000000
    12b4:	006d4534 	rsbeq	r4, sp, r4, lsr r5
    12b8:	61657267 	cmnvs	r5, r7, ror #4
    12bc:	00726574 	rsbseq	r6, r2, r4, ror r5
    12c0:	5f433249 	svcpl	0x00433249
    12c4:	5f495053 	svcpl	0x00495053
    12c8:	56414c53 			; <UNDEFINED> instruction: 0x56414c53
    12cc:	4e495f45 	cdpmi	15, 4, cr5, cr9, cr5, {2}
    12d0:	46005449 	strmi	r5, [r0], -r9, asr #8
    12d4:	435f5149 	cmpmi	pc, #1073741842	; 0x40000012
    12d8:	72746e6f 	rsbsvc	r6, r4, #1776	; 0x6f0
    12dc:	69006c6f 	stmdbvs	r0, {r0, r1, r2, r3, r5, r6, sl, fp, sp, lr}
    12e0:	685f7172 	ldmdavs	pc, {r1, r4, r5, r6, r8, ip, sp, lr}^	; <UNPREDICTABLE>
    12e4:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
    12e8:	49007265 	stmdbmi	r0, {r0, r2, r5, r6, r9, ip, sp, lr}
    12ec:	425f5152 	subsmi	r5, pc, #-2147483628	; 0x80000014
    12f0:	63697361 	cmnvs	r9, #-2080374783	; 0x84000001
    12f4:	616e455f 	cmnvs	lr, pc, asr r5
    12f8:	00656c62 	rsbeq	r6, r5, r2, ror #24
    12fc:	74666f73 	strbtvc	r6, [r6], #-3955	; 0xfffff08d
    1300:	65726177 	ldrbvs	r6, [r2, #-375]!	; 0xfffffe89
    1304:	746e695f 	strbtvc	r6, [lr], #-2399	; 0xfffff6a1
    1308:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
    130c:	685f7470 	ldmdavs	pc, {r4, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    1310:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
    1314:	49007265 	stmdbmi	r0, {r0, r2, r5, r6, r9, ip, sp, lr}
    1318:	505f5152 	subspl	r5, pc, r2, asr r1	; <UNPREDICTABLE>
    131c:	69646e65 	stmdbvs	r4!, {r0, r2, r5, r6, r9, sl, fp, sp, lr}^
    1320:	315f676e 	cmpcc	pc, lr, ror #14
    1324:	51524900 	cmppl	r2, r0, lsl #18
    1328:	6e65505f 	mcrvs	0, 3, r5, cr5, cr15, {2}
    132c:	676e6964 	strbvs	r6, [lr, -r4, ror #18]!
    1330:	4900325f 	stmdbmi	r0, {r0, r1, r2, r3, r4, r6, r9, ip, sp}
    1334:	535f5152 	cmppl	pc, #-2147483628	; 0x80000014
    1338:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
    133c:	50470065 	subpl	r0, r7, r5, rrx
    1340:	305f4f49 	subscc	r4, pc, r9, asr #30
    1344:	49504700 	ldmdbmi	r0, {r8, r9, sl, lr}^
    1348:	00315f4f 	eorseq	r5, r1, pc, asr #30
    134c:	4f495047 	svcmi	0x00495047
    1350:	4700325f 	smlsdmi	r0, pc, r2, r3	; <UNPREDICTABLE>
    1354:	5f4f4950 	svcpl	0x004f4950
    1358:	69440033 	stmdbvs	r4, {r0, r1, r4, r5}^
    135c:	6c626173 	stfvse	f6, [r2], #-460	; 0xfffffe34
    1360:	61425f65 	cmpvs	r2, r5, ror #30
    1364:	5f636973 	svcpl	0x00636973
    1368:	00515249 	subseq	r5, r1, r9, asr #4
    136c:	6464696d 	strbtvs	r6, [r4], #-2413	; 0xfffff693
    1370:	7300656c 	movwvc	r6, #1388	; 0x56c
    1374:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
    1378:	64695f65 	strbtvs	r5, [r9], #-3941	; 0xfffff09b
    137c:	52490078 	subpl	r0, r9, #120	; 0x78
    1380:	69445f51 	stmdbvs	r4, {r0, r4, r6, r8, r9, sl, fp, ip, lr}^
    1384:	6c626173 	stfvse	f6, [r2], #-460	; 0xfffffe34
    1388:	00315f65 	eorseq	r5, r1, r5, ror #30
    138c:	5f515249 	svcpl	0x00515249
    1390:	61736944 	cmnvs	r3, r4, asr #18
    1394:	5f656c62 	svcpl	0x00656c62
    1398:	57500032 	smmlarpl	r0, r2, r0, r0
    139c:	00305f41 	eorseq	r5, r0, r1, asr #30
    13a0:	5f415750 	svcpl	0x00415750
    13a4:	6d2f0031 	stcvs	0, cr0, [pc, #-196]!	; 12e8 <CPSR_IRQ_INHIBIT+0x1268>
    13a8:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
    13ac:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
    13b0:	4b2f7372 	blmi	bde180 <_bss_end+0xbd36f8>
    13b4:	2f616275 	svccs	0x00616275
    13b8:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
    13bc:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
    13c0:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
    13c4:	614d6f72 	hvcvs	55026	; 0xd6f2
    13c8:	652f6574 	strvs	r6, [pc, #-1396]!	; e5c <CPSR_IRQ_INHIBIT+0xddc>
    13cc:	706d6178 	rsbvc	r6, sp, r8, ror r1
    13d0:	2f73656c 	svccs	0x0073656c
    13d4:	552d3032 	strpl	r3, [sp, #-50]!	; 0xffffffce
    13d8:	5f545241 	svcpl	0x00545241
    13dc:	656d6167 	strbvs	r6, [sp, #-359]!	; 0xfffffe99
    13e0:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
    13e4:	2f6c656e 	svccs	0x006c656e
    13e8:	2f637273 	svccs	0x00637273
    13ec:	6e69616d 	powvsez	f6, f1, #5.0
    13f0:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
    13f4:	656b5f00 	strbvs	r5, [fp, #-3840]!	; 0xfffff100
    13f8:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
    13fc:	69616d5f 	stmdbvs	r1!, {r0, r1, r2, r3, r4, r6, r8, sl, fp, sp, lr}^
    1400:	6d2f006e 	stcvs	0, cr0, [pc, #-440]!	; 1250 <CPSR_IRQ_INHIBIT+0x11d0>
    1404:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
    1408:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
    140c:	4b2f7372 	blmi	bde1dc <_bss_end+0xbd3754>
    1410:	2f616275 	svccs	0x00616275
    1414:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
    1418:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
    141c:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
    1420:	614d6f72 	hvcvs	55026	; 0xd6f2
    1424:	652f6574 	strvs	r6, [pc, #-1396]!	; eb8 <CPSR_IRQ_INHIBIT+0xe38>
    1428:	706d6178 	rsbvc	r6, sp, r8, ror r1
    142c:	2f73656c 	svccs	0x0073656c
    1430:	552d3032 	strpl	r3, [sp, #-50]!	; 0xffffffce
    1434:	5f545241 	svcpl	0x00545241
    1438:	656d6167 	strbvs	r6, [sp, #-359]!	; 0xfffffe99
    143c:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
    1440:	2f6c656e 	svccs	0x006c656e
    1444:	2f637273 	svccs	0x00637273
    1448:	72617473 	rsbvc	r7, r1, #1929379840	; 0x73000000
    144c:	00732e74 	rsbseq	r2, r3, r4, ror lr
    1450:	20554e47 	subscs	r4, r5, r7, asr #28
    1454:	32205341 	eorcc	r5, r0, #67108865	; 0x4000001
    1458:	0038332e 	eorseq	r3, r8, lr, lsr #6
    145c:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
    1460:	552f632f 	strpl	r6, [pc, #-815]!	; 1139 <CPSR_IRQ_INHIBIT+0x10b9>
    1464:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
    1468:	62754b2f 	rsbsvs	r4, r5, #48128	; 0xbc00
    146c:	6f442f61 	svcvs	0x00442f61
    1470:	656d7563 	strbvs	r7, [sp, #-1379]!	; 0xfffffa9d
    1474:	2f73746e 	svccs	0x0073746e
    1478:	6f72655a 	svcvs	0x0072655a
    147c:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
    1480:	6178652f 	cmnvs	r8, pc, lsr #10
    1484:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
    1488:	30322f73 	eorscc	r2, r2, r3, ror pc
    148c:	5241552d 	subpl	r5, r1, #188743680	; 0xb400000
    1490:	61675f54 	cmnvs	r7, r4, asr pc
    1494:	6b2f656d 	blvs	bdaa50 <_bss_end+0xbcffc8>
    1498:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
    149c:	72732f6c 	rsbsvc	r2, r3, #108, 30	; 0x1b0
    14a0:	74732f63 	ldrbtvc	r2, [r3], #-3939	; 0xfffff09d
    14a4:	75747261 	ldrbvc	r7, [r4, #-609]!	; 0xfffffd9f
    14a8:	70632e70 	rsbvc	r2, r3, r0, ror lr
    14ac:	625f0070 	subsvs	r0, pc, #112	; 0x70
    14b0:	735f7373 	cmpvc	pc, #-872415231	; 0xcc000001
    14b4:	74726174 	ldrbtvc	r6, [r2], #-372	; 0xfffffe8c
    14b8:	435f5f00 	cmpmi	pc, #0, 30
    14bc:	5f524f54 	svcpl	0x00524f54
    14c0:	5f444e45 	svcpl	0x00444e45
    14c4:	5f5f005f 	svcpl	0x005f005f
    14c8:	524f5444 	subpl	r5, pc, #68, 8	; 0x44000000
    14cc:	444e455f 	strbmi	r4, [lr], #-1375	; 0xfffffaa1
    14d0:	5f005f5f 	svcpl	0x00005f5f
    14d4:	5f707063 	svcpl	0x00707063
    14d8:	74756873 	ldrbtvc	r6, [r5], #-2163	; 0xfffff78d
    14dc:	6e776f64 	cdpvs	15, 7, cr6, cr7, cr4, {3}
    14e0:	73625f00 	cmnvc	r2, #0, 30
    14e4:	6e655f73 	mcrvs	15, 3, r5, cr5, cr3, {3}
    14e8:	5f5f0064 	svcpl	0x005f0064
    14ec:	524f5444 	subpl	r5, pc, #68, 8	; 0x44000000
    14f0:	53494c5f 	movtpl	r4, #40031	; 0x9c5f
    14f4:	005f5f54 	subseq	r5, pc, r4, asr pc	; <UNPREDICTABLE>
    14f8:	726f7464 	rsbvc	r7, pc, #100, 8	; 0x64000000
    14fc:	7274705f 	rsbsvc	r7, r4, #95	; 0x5f
    1500:	6f746300 	svcvs	0x00746300
    1504:	74705f72 	ldrbtvc	r5, [r0], #-3954	; 0xfffff08e
    1508:	5f5f0072 	svcpl	0x005f0072
    150c:	524f5443 	subpl	r5, pc, #1124073472	; 0x43000000
    1510:	53494c5f 	movtpl	r4, #40031	; 0x9c5f
    1514:	005f5f54 	subseq	r5, pc, r4, asr pc	; <UNPREDICTABLE>
    1518:	735f635f 	cmpvc	pc, #2080374785	; 0x7c000001
    151c:	74726174 	ldrbtvc	r6, [r2], #-372	; 0xfffffe8c
    1520:	5f007075 	svcpl	0x00007075
    1524:	5f707063 	svcpl	0x00707063
    1528:	72617473 	rsbvc	r7, r1, #1929379840	; 0x73000000
    152c:	00707574 	rsbseq	r7, r0, r4, ror r5
    1530:	74706e66 	ldrbtvc	r6, [r0], #-3686	; 0xfffff19a
    1534:	656d0072 	strbvs	r0, [sp, #-114]!	; 0xffffff8e
    1538:	7473646d 	ldrbtvc	r6, [r3], #-1133	; 0xfffffb93
    153c:	73656400 	cmnvc	r5, #0, 8
    1540:	7a620074 	bvc	1881718 <_bss_end+0x1876c90>
    1544:	006f7265 	rsbeq	r7, pc, r5, ror #4
    1548:	676e656c 	strbvs	r6, [lr, -ip, ror #10]!
    154c:	5f006874 	svcpl	0x00006874
    1550:	7a62355a 	bvc	188eac0 <_bss_end+0x1884038>
    1554:	506f7265 	rsbpl	r7, pc, r5, ror #4
    1558:	5f006976 	svcpl	0x00006976
    155c:	7461345a 	strbtvc	r3, [r1], #-1114	; 0xfffffba6
    1560:	4b50696f 	blmi	141bb24 <_bss_end+0x141109c>
    1564:	5a5f0063 	bpl	17c16f8 <_bss_end+0x17b6c70>
    1568:	6d656d36 	stclvs	13, cr6, [r5, #-216]!	; 0xffffff28
    156c:	50797063 	rsbspl	r7, r9, r3, rrx
    1570:	7650764b 	ldrbvc	r7, [r0], -fp, asr #12
    1574:	656d0069 	strbvs	r0, [sp, #-105]!	; 0xffffff97
    1578:	7970636d 	ldmdbvc	r0!, {r0, r2, r3, r5, r6, r8, r9, sp, lr}^
    157c:	6e6d2f00 	cdpvs	15, 6, cr2, cr13, cr0, {0}
    1580:	2f632f74 	svccs	0x00632f74
    1584:	72657355 	rsbvc	r7, r5, #1409286145	; 0x54000001
    1588:	754b2f73 	strbvc	r2, [fp, #-3955]	; 0xfffff08d
    158c:	442f6162 	strtmi	r6, [pc], #-354	; 1594 <CPSR_IRQ_INHIBIT+0x1514>
    1590:	6d75636f 	ldclvs	3, cr6, [r5, #-444]!	; 0xfffffe44
    1594:	73746e65 	cmnvc	r4, #1616	; 0x650
    1598:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
    159c:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
    15a0:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
    15a4:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
    15a8:	322f7365 	eorcc	r7, pc, #-1811939327	; 0x94000001
    15ac:	41552d30 	cmpmi	r5, r0, lsr sp
    15b0:	675f5452 			; <UNDEFINED> instruction: 0x675f5452
    15b4:	2f656d61 	svccs	0x00656d61
    15b8:	6c647473 	cfstrdvs	mvd7, [r4], #-460	; 0xfffffe34
    15bc:	732f6269 			; <UNDEFINED> instruction: 0x732f6269
    15c0:	732f6372 			; <UNDEFINED> instruction: 0x732f6372
    15c4:	74736474 	ldrbtvc	r6, [r3], #-1140	; 0xfffffb8c
    15c8:	676e6972 			; <UNDEFINED> instruction: 0x676e6972
    15cc:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
    15d0:	72747300 	rsbsvc	r7, r4, #0, 6
    15d4:	006e656c 	rsbeq	r6, lr, ip, ror #10
    15d8:	73375a5f 	teqvc	r7, #389120	; 0x5f000
    15dc:	636e7274 	cmnvs	lr, #116, 4	; 0x40000007
    15e0:	4b50706d 	blmi	141d79c <_bss_end+0x1412d14>
    15e4:	5f305363 	svcpl	0x00305363
    15e8:	5a5f0069 	bpl	17c1794 <_bss_end+0x17b6d0c>
    15ec:	72747336 	rsbsvc	r7, r4, #-671088640	; 0xd8000000
    15f0:	506e656c 	rsbpl	r6, lr, ip, ror #10
    15f4:	6100634b 	tstvs	r0, fp, asr #6
    15f8:	00696f74 	rsbeq	r6, r9, r4, ror pc
    15fc:	73375a5f 	teqvc	r7, #389120	; 0x5f000
    1600:	636e7274 	cmnvs	lr, #116, 4	; 0x40000007
    1604:	63507970 	cmpvs	r0, #112, 18	; 0x1c0000
    1608:	69634b50 	stmdbvs	r3!, {r4, r6, r8, r9, fp, lr}^
    160c:	72747300 	rsbsvc	r7, r4, #0, 6
    1610:	706d636e 	rsbvc	r6, sp, lr, ror #6
    1614:	72747300 	rsbsvc	r7, r4, #0, 6
    1618:	7970636e 	ldmdbvc	r0!, {r1, r2, r3, r5, r6, r8, r9, sp, lr}^
    161c:	6d656d00 	stclvs	13, cr6, [r5, #-0]
    1620:	0079726f 	rsbseq	r7, r9, pc, ror #4
    1624:	736d656d 	cmnvc	sp, #457179136	; 0x1b400000
    1628:	5f006372 	svcpl	0x00006372
    162c:	7469345a 	strbtvc	r3, [r9], #-1114	; 0xfffffba6
    1630:	506a616f 	rsbpl	r6, sl, pc, ror #2
    1634:	2e006a63 	vmlscs.f32	s12, s0, s7
    1638:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    163c:	2f2e2e2f 	svccs	0x002e2e2f
    1640:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1644:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1648:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    164c:	2f636367 	svccs	0x00636367
    1650:	666e6f63 	strbtvs	r6, [lr], -r3, ror #30
    1654:	612f6769 			; <UNDEFINED> instruction: 0x612f6769
    1658:	6c2f6d72 	stcvs	13, cr6, [pc], #-456	; 1498 <CPSR_IRQ_INHIBIT+0x1418>
    165c:	66316269 	ldrtvs	r6, [r1], -r9, ror #4
    1660:	73636e75 	cmnvc	r3, #1872	; 0x750
    1664:	2f00532e 	svccs	0x0000532e
    1668:	6c697562 	cfstr64vs	mvdx7, [r9], #-392	; 0xfffffe78
    166c:	63672f64 	cmnvs	r7, #100, 30	; 0x190
    1670:	72612d63 	rsbvc	r2, r1, #6336	; 0x18c0
    1674:	6f6e2d6d 	svcvs	0x006e2d6d
    1678:	652d656e 	strvs	r6, [sp, #-1390]!	; 0xfffffa92
    167c:	2d696261 	sfmcs	f6, 2, [r9, #-388]!	; 0xfffffe7c
    1680:	67665968 	strbvs	r5, [r6, -r8, ror #18]!
    1684:	672f344b 	strvs	r3, [pc, -fp, asr #8]!
    1688:	612d6363 			; <UNDEFINED> instruction: 0x612d6363
    168c:	6e2d6d72 	mcrvs	13, 1, r6, cr13, cr2, {3}
    1690:	2d656e6f 	stclcs	14, cr6, [r5, #-444]!	; 0xfffffe44
    1694:	69626165 	stmdbvs	r2!, {r0, r2, r5, r6, r8, sp, lr}^
    1698:	2e30312d 	rsfcssp	f3, f0, #5.0
    169c:	30322d33 	eorscc	r2, r2, r3, lsr sp
    16a0:	302e3132 	eorcc	r3, lr, r2, lsr r1
    16a4:	75622f37 	strbvc	r2, [r2, #-3895]!	; 0xfffff0c9
    16a8:	2f646c69 	svccs	0x00646c69
    16ac:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
    16b0:	656e6f6e 	strbvs	r6, [lr, #-3950]!	; 0xfffff092
    16b4:	6261652d 	rsbvs	r6, r1, #188743680	; 0xb400000
    16b8:	72612f69 	rsbvc	r2, r1, #420	; 0x1a4
    16bc:	35762f6d 	ldrbcc	r2, [r6, #-3949]!	; 0xfffff093
    16c0:	682f6574 	stmdavs	pc!, {r2, r4, r5, r6, r8, sl, sp, lr}	; <UNPREDICTABLE>
    16c4:	2f647261 	svccs	0x00647261
    16c8:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    16cc:	47006363 	strmi	r6, [r0, -r3, ror #6]
    16d0:	4120554e 			; <UNDEFINED> instruction: 0x4120554e
    16d4:	2e322053 	mrccs	0, 1, r2, cr2, cr3, {2}
    16d8:	69003733 	stmdbvs	r0, {r0, r1, r4, r5, r8, r9, sl, ip, sp}
    16dc:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    16e0:	705f7469 	subsvc	r7, pc, r9, ror #8
    16e4:	72646572 	rsbvc	r6, r4, #478150656	; 0x1c800000
    16e8:	69007365 	stmdbvs	r0, {r0, r2, r5, r6, r8, r9, ip, sp, lr}
    16ec:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    16f0:	765f7469 	ldrbvc	r7, [pc], -r9, ror #8
    16f4:	625f7066 	subsvs	r7, pc, #102	; 0x66
    16f8:	00657361 	rsbeq	r7, r5, r1, ror #6
    16fc:	706d6f63 	rsbvc	r6, sp, r3, ror #30
    1700:	2078656c 	rsbscs	r6, r8, ip, ror #10
    1704:	616f6c66 	cmnvs	pc, r6, ror #24
    1708:	73690074 	cmnvc	r9, #116	; 0x74
    170c:	6f6e5f61 	svcvs	0x006e5f61
    1710:	00746962 	rsbseq	r6, r4, r2, ror #18
    1714:	5f617369 	svcpl	0x00617369
    1718:	5f746962 	svcpl	0x00746962
    171c:	5f65766d 	svcpl	0x0065766d
    1720:	616f6c66 	cmnvs	pc, r6, ror #24
    1724:	73690074 	cmnvc	r9, #116	; 0x74
    1728:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    172c:	70665f74 	rsbvc	r5, r6, r4, ror pc
    1730:	69003631 	stmdbvs	r0, {r0, r4, r5, r9, sl, ip, sp}
    1734:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1738:	735f7469 	cmpvc	pc, #1761607680	; 0x69000000
    173c:	69006365 	stmdbvs	r0, {r0, r2, r5, r6, r8, r9, sp, lr}
    1740:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1744:	615f7469 	cmpvs	pc, r9, ror #8
    1748:	00766964 	rsbseq	r6, r6, r4, ror #18
    174c:	5f617369 	svcpl	0x00617369
    1750:	5f746962 	svcpl	0x00746962
    1754:	72697571 	rsbvc	r7, r9, #473956352	; 0x1c400000
    1758:	6f6e5f6b 	svcvs	0x006e5f6b
    175c:	6c6f765f 	stclvs	6, cr7, [pc], #-380	; 15e8 <CPSR_IRQ_INHIBIT+0x1568>
    1760:	6c697461 	cfstrdvs	mvd7, [r9], #-388	; 0xfffffe7c
    1764:	65635f65 	strbvs	r5, [r3, #-3941]!	; 0xfffff09b
    1768:	61736900 	cmnvs	r3, r0, lsl #18
    176c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1770:	00706d5f 	rsbseq	r6, r0, pc, asr sp
    1774:	5f617369 	svcpl	0x00617369
    1778:	5f746962 	svcpl	0x00746962
    177c:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1780:	69007435 	stmdbvs	r0, {r0, r2, r4, r5, sl, ip, sp, lr}
    1784:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1788:	615f7469 	cmpvs	pc, r9, ror #8
    178c:	35766d72 	ldrbcc	r6, [r6, #-3442]!	; 0xfffff28e
    1790:	69006574 	stmdbvs	r0, {r2, r4, r5, r6, r8, sl, sp, lr}
    1794:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1798:	6e5f7469 	cdpvs	4, 5, cr7, cr15, cr9, {3}
    179c:	006e6f65 	rsbeq	r6, lr, r5, ror #30
    17a0:	5f617369 	svcpl	0x00617369
    17a4:	5f746962 	svcpl	0x00746962
    17a8:	36316662 	ldrtcc	r6, [r1], -r2, ror #12
    17ac:	53504600 	cmppl	r0, #0, 12
    17b0:	455f5243 	ldrbmi	r5, [pc, #-579]	; 1575 <CPSR_IRQ_INHIBIT+0x14f5>
    17b4:	004d554e 	subeq	r5, sp, lr, asr #10
    17b8:	43535046 	cmpmi	r3, #70	; 0x46
    17bc:	7a6e5f52 	bvc	1b9950c <_bss_end+0x1b8ea84>
    17c0:	63717663 	cmnvs	r1, #103809024	; 0x6300000
    17c4:	554e455f 	strbpl	r4, [lr, #-1375]	; 0xfffffaa1
    17c8:	5056004d 	subspl	r0, r6, sp, asr #32
    17cc:	4e455f52 	mcrmi	15, 2, r5, cr5, cr2, {2}
    17d0:	66004d55 			; <UNDEFINED> instruction: 0x66004d55
    17d4:	5f746962 	svcpl	0x00746962
    17d8:	6c706d69 	ldclvs	13, cr6, [r0], #-420	; 0xfffffe5c
    17dc:	74616369 	strbtvc	r6, [r1], #-873	; 0xfffffc97
    17e0:	006e6f69 	rsbeq	r6, lr, r9, ror #30
    17e4:	455f3050 	ldrbmi	r3, [pc, #-80]	; 179c <CPSR_IRQ_INHIBIT+0x171c>
    17e8:	004d554e 	subeq	r5, sp, lr, asr #10
    17ec:	5f617369 	svcpl	0x00617369
    17f0:	5f746962 	svcpl	0x00746962
    17f4:	70797263 	rsbsvc	r7, r9, r3, ror #4
    17f8:	47006f74 	smlsdxmi	r0, r4, pc, r6	; <UNPREDICTABLE>
    17fc:	4320554e 			; <UNDEFINED> instruction: 0x4320554e
    1800:	31203731 			; <UNDEFINED> instruction: 0x31203731
    1804:	2e332e30 	mrccs	14, 1, r2, cr3, cr0, {1}
    1808:	30322031 	eorscc	r2, r2, r1, lsr r0
    180c:	36303132 			; <UNDEFINED> instruction: 0x36303132
    1810:	28203132 	stmdacs	r0!, {r1, r4, r5, r8, ip, sp}
    1814:	656c6572 	strbvs	r6, [ip, #-1394]!	; 0xfffffa8e
    1818:	29657361 	stmdbcs	r5!, {r0, r5, r6, r8, r9, ip, sp, lr}^
    181c:	616d2d20 	cmnvs	sp, r0, lsr #26
    1820:	2d206d72 	stccs	13, cr6, [r0, #-456]!	; 0xfffffe38
    1824:	6f6c666d 	svcvs	0x006c666d
    1828:	612d7461 			; <UNDEFINED> instruction: 0x612d7461
    182c:	683d6962 	ldmdavs	sp!, {r1, r5, r6, r8, fp, sp, lr}
    1830:	20647261 	rsbcs	r7, r4, r1, ror #4
    1834:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
    1838:	613d6863 	teqvs	sp, r3, ror #16
    183c:	35766d72 	ldrbcc	r6, [r6, #-3442]!	; 0xfffff28e
    1840:	662b6574 			; <UNDEFINED> instruction: 0x662b6574
    1844:	672d2070 			; <UNDEFINED> instruction: 0x672d2070
    1848:	20672d20 	rsbcs	r2, r7, r0, lsr #26
    184c:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
    1850:	2d20324f 	sfmcs	f3, 4, [r0, #-316]!	; 0xfffffec4
    1854:	2d20324f 	sfmcs	f3, 4, [r0, #-316]!	; 0xfffffec4
    1858:	2d20324f 	sfmcs	f3, 4, [r0, #-316]!	; 0xfffffec4
    185c:	69756266 	ldmdbvs	r5!, {r1, r2, r5, r6, r9, sp, lr}^
    1860:	6e69646c 	cdpvs	4, 6, cr6, cr9, cr12, {3}
    1864:	696c2d67 	stmdbvs	ip!, {r0, r1, r2, r5, r6, r8, sl, fp, sp}^
    1868:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    186c:	6e662d20 	cdpvs	13, 6, cr2, cr6, cr0, {1}
    1870:	74732d6f 	ldrbtvc	r2, [r3], #-3439	; 0xfffff291
    1874:	2d6b6361 	stclcs	3, cr6, [fp, #-388]!	; 0xfffffe7c
    1878:	746f7270 	strbtvc	r7, [pc], #-624	; 1880 <CPSR_IRQ_INHIBIT+0x1800>
    187c:	6f746365 	svcvs	0x00746365
    1880:	662d2072 			; <UNDEFINED> instruction: 0x662d2072
    1884:	692d6f6e 	pushvs	{r1, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}
    1888:	6e696c6e 	cdpvs	12, 6, cr6, cr9, cr14, {3}
    188c:	662d2065 	strtvs	r2, [sp], -r5, rrx
    1890:	69736976 	ldmdbvs	r3!, {r1, r2, r4, r5, r6, r8, fp, sp, lr}^
    1894:	696c6962 	stmdbvs	ip!, {r1, r5, r6, r8, fp, sp, lr}^
    1898:	683d7974 	ldmdavs	sp!, {r2, r4, r5, r6, r8, fp, ip, sp, lr}
    189c:	65646469 	strbvs	r6, [r4, #-1129]!	; 0xfffffb97
    18a0:	7369006e 	cmnvc	r9, #110	; 0x6e
    18a4:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    18a8:	64745f74 	ldrbtvs	r5, [r4], #-3956	; 0xfffff08c
    18ac:	63007669 	movwvs	r7, #1641	; 0x669
    18b0:	00736e6f 	rsbseq	r6, r3, pc, ror #28
    18b4:	5f617369 	svcpl	0x00617369
    18b8:	5f746962 	svcpl	0x00746962
    18bc:	6d6d7769 	stclvs	7, cr7, [sp, #-420]!	; 0xfffffe5c
    18c0:	46007478 			; <UNDEFINED> instruction: 0x46007478
    18c4:	54584350 	ldrbpl	r4, [r8], #-848	; 0xfffffcb0
    18c8:	4e455f53 	mcrmi	15, 2, r5, cr5, cr3, {2}
    18cc:	69004d55 	stmdbvs	r0, {r0, r2, r4, r6, r8, sl, fp, lr}
    18d0:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    18d4:	615f7469 	cmpvs	pc, r9, ror #8
    18d8:	36766d72 			; <UNDEFINED> instruction: 0x36766d72
    18dc:	61736900 	cmnvs	r3, r0, lsl #18
    18e0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    18e4:	65766d5f 	ldrbvs	r6, [r6, #-3423]!	; 0xfffff2a1
    18e8:	61736900 	cmnvs	r3, r0, lsl #18
    18ec:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    18f0:	6d77695f 			; <UNDEFINED> instruction: 0x6d77695f
    18f4:	3274786d 	rsbscc	r7, r4, #7143424	; 0x6d0000
    18f8:	61736900 	cmnvs	r3, r0, lsl #18
    18fc:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1900:	6564635f 	strbvs	r6, [r4, #-863]!	; 0xfffffca1
    1904:	00307063 	eorseq	r7, r0, r3, rrx
    1908:	5f617369 	svcpl	0x00617369
    190c:	5f746962 	svcpl	0x00746962
    1910:	63656463 	cmnvs	r5, #1660944384	; 0x63000000
    1914:	69003170 	stmdbvs	r0, {r4, r5, r6, r8, ip, sp}
    1918:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    191c:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    1920:	70636564 	rsbvc	r6, r3, r4, ror #10
    1924:	73690032 	cmnvc	r9, #50	; 0x32
    1928:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    192c:	64635f74 	strbtvs	r5, [r3], #-3956	; 0xfffff08c
    1930:	33706365 	cmncc	r0, #-1811939327	; 0x94000001
    1934:	61736900 	cmnvs	r3, r0, lsl #18
    1938:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    193c:	6564635f 	strbvs	r6, [r4, #-863]!	; 0xfffffca1
    1940:	00347063 	eorseq	r7, r4, r3, rrx
    1944:	5f617369 	svcpl	0x00617369
    1948:	5f746962 	svcpl	0x00746962
    194c:	645f7066 	ldrbvs	r7, [pc], #-102	; 1954 <CPSR_IRQ_INHIBIT+0x18d4>
    1950:	69006c62 	stmdbvs	r0, {r1, r5, r6, sl, fp, sp, lr}
    1954:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1958:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    195c:	70636564 	rsbvc	r6, r3, r4, ror #10
    1960:	73690036 	cmnvc	r9, #54	; 0x36
    1964:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1968:	64635f74 	strbtvs	r5, [r3], #-3956	; 0xfffff08c
    196c:	37706365 	ldrbcc	r6, [r0, -r5, ror #6]!
    1970:	61736900 	cmnvs	r3, r0, lsl #18
    1974:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1978:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    197c:	006b3676 	rsbeq	r3, fp, r6, ror r6
    1980:	5f617369 	svcpl	0x00617369
    1984:	5f746962 	svcpl	0x00746962
    1988:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    198c:	6d315f38 	ldcvs	15, cr5, [r1, #-224]!	; 0xffffff20
    1990:	69616d5f 	stmdbvs	r1!, {r0, r1, r2, r3, r4, r6, r8, sl, fp, sp, lr}^
    1994:	6e61006e 	cdpvs	0, 6, cr0, cr1, cr14, {3}
    1998:	69006574 	stmdbvs	r0, {r2, r4, r5, r6, r8, sl, sp, lr}
    199c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    19a0:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    19a4:	0065736d 	rsbeq	r7, r5, sp, ror #6
    19a8:	676e6f6c 	strbvs	r6, [lr, -ip, ror #30]!
    19ac:	756f6420 	strbvc	r6, [pc, #-1056]!	; 1594 <CPSR_IRQ_INHIBIT+0x1514>
    19b0:	00656c62 	rsbeq	r6, r5, r2, ror #24
    19b4:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    19b8:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    19bc:	2f2e2e2f 	svccs	0x002e2e2f
    19c0:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    19c4:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
    19c8:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    19cc:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    19d0:	32636367 	rsbcc	r6, r3, #-1677721599	; 0x9c000001
    19d4:	6900632e 	stmdbvs	r0, {r1, r2, r3, r5, r8, r9, sp, lr}
    19d8:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    19dc:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    19e0:	00357670 	eorseq	r7, r5, r0, ror r6
    19e4:	5f617369 	svcpl	0x00617369
    19e8:	5f746962 	svcpl	0x00746962
    19ec:	61637378 	smcvs	14136	; 0x3738
    19f0:	6c00656c 	cfstr32vs	mvfx6, [r0], {108}	; 0x6c
    19f4:	20676e6f 	rsbcs	r6, r7, pc, ror #28
    19f8:	676e6f6c 	strbvs	r6, [lr, -ip, ror #30]!
    19fc:	736e7520 	cmnvc	lr, #32, 10	; 0x8000000
    1a00:	656e6769 	strbvs	r6, [lr, #-1897]!	; 0xfffff897
    1a04:	6e692064 	cdpvs	0, 6, cr2, cr9, cr4, {3}
    1a08:	73690074 	cmnvc	r9, #116	; 0x74
    1a0c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1a10:	75715f74 	ldrbvc	r5, [r1, #-3956]!	; 0xfffff08c
    1a14:	5f6b7269 	svcpl	0x006b7269
    1a18:	5f336d63 	svcpl	0x00336d63
    1a1c:	6472646c 	ldrbtvs	r6, [r2], #-1132	; 0xfffffb94
    1a20:	61736900 	cmnvs	r3, r0, lsl #18
    1a24:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1a28:	6d38695f 			; <UNDEFINED> instruction: 0x6d38695f
    1a2c:	7369006d 	cmnvc	r9, #109	; 0x6d
    1a30:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1a34:	70665f74 	rsbvc	r5, r6, r4, ror pc
    1a38:	3233645f 	eorscc	r6, r3, #1593835520	; 0x5f000000
    1a3c:	61736900 	cmnvs	r3, r0, lsl #18
    1a40:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1a44:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1a48:	6d653776 	stclvs	7, cr3, [r5, #-472]!	; 0xfffffe28
    1a4c:	61736900 	cmnvs	r3, r0, lsl #18
    1a50:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1a54:	61706c5f 	cmnvs	r0, pc, asr ip
    1a58:	6c610065 	stclvs	0, cr0, [r1], #-404	; 0xfffffe6c
    1a5c:	6d695f6c 	stclvs	15, cr5, [r9, #-432]!	; 0xfffffe50
    1a60:	65696c70 	strbvs	r6, [r9, #-3184]!	; 0xfffff390
    1a64:	62665f64 	rsbvs	r5, r6, #100, 30	; 0x190
    1a68:	00737469 	rsbseq	r7, r3, r9, ror #8
    1a6c:	5f617369 	svcpl	0x00617369
    1a70:	5f746962 	svcpl	0x00746962
    1a74:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1a78:	00315f38 	eorseq	r5, r1, r8, lsr pc
    1a7c:	5f617369 	svcpl	0x00617369
    1a80:	5f746962 	svcpl	0x00746962
    1a84:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1a88:	00325f38 	eorseq	r5, r2, r8, lsr pc
    1a8c:	5f617369 	svcpl	0x00617369
    1a90:	5f746962 	svcpl	0x00746962
    1a94:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1a98:	00335f38 	eorseq	r5, r3, r8, lsr pc
    1a9c:	5f617369 	svcpl	0x00617369
    1aa0:	5f746962 	svcpl	0x00746962
    1aa4:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1aa8:	00345f38 	eorseq	r5, r4, r8, lsr pc
    1aac:	5f617369 	svcpl	0x00617369
    1ab0:	5f746962 	svcpl	0x00746962
    1ab4:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1ab8:	00355f38 	eorseq	r5, r5, r8, lsr pc
    1abc:	5f617369 	svcpl	0x00617369
    1ac0:	5f746962 	svcpl	0x00746962
    1ac4:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1ac8:	00365f38 	eorseq	r5, r6, r8, lsr pc
    1acc:	5f617369 	svcpl	0x00617369
    1ad0:	5f746962 	svcpl	0x00746962
    1ad4:	69006273 	stmdbvs	r0, {r0, r1, r4, r5, r6, r9, sp, lr}
    1ad8:	6e5f6173 	mrcvs	1, 2, r6, cr15, cr3, {3}
    1adc:	625f6d75 	subsvs	r6, pc, #7488	; 0x1d40
    1ae0:	00737469 	rsbseq	r7, r3, r9, ror #8
    1ae4:	5f617369 	svcpl	0x00617369
    1ae8:	5f746962 	svcpl	0x00746962
    1aec:	6c616d73 	stclvs	13, cr6, [r1], #-460	; 0xfffffe34
    1af0:	6c756d6c 	ldclvs	13, cr6, [r5], #-432	; 0xfffffe50
    1af4:	6e756600 	cdpvs	6, 7, cr6, cr5, cr0, {0}
    1af8:	74705f63 	ldrbtvc	r5, [r0], #-3939	; 0xfffff09d
    1afc:	6f630072 	svcvs	0x00630072
    1b00:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
    1b04:	6f642078 	svcvs	0x00642078
    1b08:	656c6275 	strbvs	r6, [ip, #-629]!	; 0xfffffd8b
    1b0c:	5f424e00 	svcpl	0x00424e00
    1b10:	535f5046 	cmppl	pc, #70	; 0x46
    1b14:	45525359 	ldrbmi	r5, [r2, #-857]	; 0xfffffca7
    1b18:	69005347 	stmdbvs	r0, {r0, r1, r2, r6, r8, r9, ip, lr}
    1b1c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1b20:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    1b24:	70636564 	rsbvc	r6, r3, r4, ror #10
    1b28:	73690035 	cmnvc	r9, #53	; 0x35
    1b2c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1b30:	66765f74 	uhsub16vs	r5, r6, r4
    1b34:	00327670 	eorseq	r7, r2, r0, ror r6
    1b38:	5f617369 	svcpl	0x00617369
    1b3c:	5f746962 	svcpl	0x00746962
    1b40:	76706676 			; <UNDEFINED> instruction: 0x76706676
    1b44:	73690033 	cmnvc	r9, #51	; 0x33
    1b48:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1b4c:	66765f74 	uhsub16vs	r5, r6, r4
    1b50:	00347670 	eorseq	r7, r4, r0, ror r6
    1b54:	58435046 	stmdapl	r3, {r1, r2, r6, ip, lr}^
    1b58:	5f534e54 	svcpl	0x00534e54
    1b5c:	4d554e45 	ldclmi	14, cr4, [r5, #-276]	; 0xfffffeec
    1b60:	61736900 	cmnvs	r3, r0, lsl #18
    1b64:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1b68:	7568745f 	strbvc	r7, [r8, #-1119]!	; 0xfffffba1
    1b6c:	6900626d 	stmdbvs	r0, {r0, r2, r3, r5, r6, r9, sp, lr}
    1b70:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1b74:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    1b78:	63363170 	teqvs	r6, #112, 2
    1b7c:	00766e6f 	rsbseq	r6, r6, pc, ror #28
    1b80:	5f617369 	svcpl	0x00617369
    1b84:	74616566 	strbtvc	r6, [r1], #-1382	; 0xfffffa9a
    1b88:	00657275 	rsbeq	r7, r5, r5, ror r2
    1b8c:	5f617369 	svcpl	0x00617369
    1b90:	5f746962 	svcpl	0x00746962
    1b94:	6d746f6e 	ldclvs	15, cr6, [r4, #-440]!	; 0xfffffe48
    1b98:	61736900 	cmnvs	r3, r0, lsl #18
    1b9c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1ba0:	6975715f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, r8, ip, sp, lr}^
    1ba4:	615f6b72 	cmpvs	pc, r2, ror fp	; <UNPREDICTABLE>
    1ba8:	36766d72 			; <UNDEFINED> instruction: 0x36766d72
    1bac:	69007a6b 	stmdbvs	r0, {r0, r1, r3, r5, r6, r9, fp, ip, sp, lr}
    1bb0:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1bb4:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    1bb8:	32336372 	eorscc	r6, r3, #-939524095	; 0xc8000001
    1bbc:	61736900 	cmnvs	r3, r0, lsl #18
    1bc0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1bc4:	6975715f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, r8, ip, sp, lr}^
    1bc8:	6e5f6b72 	vmovvs.s8	r6, d15[3]
    1bcc:	73615f6f 	cmnvc	r1, #444	; 0x1bc
    1bd0:	7570636d 	ldrbvc	r6, [r0, #-877]!	; 0xfffffc93
    1bd4:	61736900 	cmnvs	r3, r0, lsl #18
    1bd8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1bdc:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1be0:	69003476 	stmdbvs	r0, {r1, r2, r4, r5, r6, sl, ip, sp}
    1be4:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1be8:	745f7469 	ldrbvc	r7, [pc], #-1129	; 1bf0 <CPSR_IRQ_INHIBIT+0x1b70>
    1bec:	626d7568 	rsbvs	r7, sp, #104, 10	; 0x1a000000
    1bf0:	73690032 	cmnvc	r9, #50	; 0x32
    1bf4:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1bf8:	65625f74 	strbvs	r5, [r2, #-3956]!	; 0xfffff08c
    1bfc:	73690038 	cmnvc	r9, #56	; 0x38
    1c00:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1c04:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1c08:	0037766d 	eorseq	r7, r7, sp, ror #12
    1c0c:	5f617369 	svcpl	0x00617369
    1c10:	5f746962 	svcpl	0x00746962
    1c14:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1c18:	66760038 			; <UNDEFINED> instruction: 0x66760038
    1c1c:	79735f70 	ldmdbvc	r3!, {r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    1c20:	67657273 			; <UNDEFINED> instruction: 0x67657273
    1c24:	6e655f73 	mcrvs	15, 3, r5, cr5, cr3, {3}
    1c28:	69646f63 	stmdbvs	r4!, {r0, r1, r5, r6, r8, r9, sl, fp, sp, lr}^
    1c2c:	6900676e 	stmdbvs	r0, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}
    1c30:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1c34:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    1c38:	66363170 			; <UNDEFINED> instruction: 0x66363170
    1c3c:	69006c6d 	stmdbvs	r0, {r0, r2, r3, r5, r6, sl, fp, sp, lr}
    1c40:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1c44:	645f7469 	ldrbvs	r7, [pc], #-1129	; 1c4c <CPSR_IRQ_INHIBIT+0x1bcc>
    1c48:	7270746f 	rsbsvc	r7, r0, #1862270976	; 0x6f000000
    1c4c:	Address 0x0000000000001c4c is out of bounds.


Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347 	bcc	10d0d24 <_bss_end+0x10c629c>
   4:	35312820 	ldrcc	r2, [r1, #-2080]!	; 0xfffff7e0
   8:	2e30313a 	mrccs	1, 1, r3, cr0, cr10, {1}
   c:	30322d33 	eorscc	r2, r2, r3, lsr sp
  10:	302e3132 	eorcc	r3, lr, r2, lsr r1
  14:	29342d37 	ldmdbcs	r4!, {r0, r1, r2, r4, r5, r8, sl, fp, sp}
  18:	2e303120 	rsfcssp	f3, f0, f0
  1c:	20312e33 	eorscs	r2, r1, r3, lsr lr
  20:	31323032 	teqcc	r2, r2, lsr r0
  24:	31323630 	teqcc	r2, r0, lsr r6
  28:	65722820 	ldrbvs	r2, [r2, #-2080]!	; 0xfffff7e0
  2c:	7361656c 	cmnvc	r1, #108, 10	; 0x1b000000
  30:	Address 0x0000000000000030 is out of bounds.


Disassembly of section .ARM.attributes:

00000000 <.ARM.attributes>:
   0:	00003041 	andeq	r3, r0, r1, asr #32
   4:	61656100 	cmnvs	r5, r0, lsl #2
   8:	01006962 	tsteq	r0, r2, ror #18
   c:	00000026 	andeq	r0, r0, r6, lsr #32
  10:	4b5a3605 	blmi	168d82c <_bss_end+0x1682da4>
  14:	08070600 	stmdaeq	r7, {r9, sl}
  18:	0a010901 	beq	42424 <_bss_end+0x3799c>
  1c:	14041202 	strne	r1, [r4], #-514	; 0xfffffdfe
  20:	17011501 	strne	r1, [r1, -r1, lsl #10]
  24:	1a011803 	bne	46038 <_bss_end+0x3b5b0>
  28:	1e011c01 	cdpne	12, 0, cr1, cr1, cr1, {0}
  2c:	44012206 	strmi	r2, [r1], #-518	; 0xfffffdfa
  30:	Address 0x0000000000000030 is out of bounds.


Disassembly of section .debug_frame:

00000000 <.debug_frame>:
   0:	0000000c 	andeq	r0, r0, ip
   4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
   8:	7c020001 	stcvc	0, cr0, [r2], {1}
   c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  10:	0000001c 	andeq	r0, r0, ip, lsl r0
  14:	00000000 	andeq	r0, r0, r0
  18:	00008094 	muleq	r0, r4, r0
  1c:	00000038 	andeq	r0, r0, r8, lsr r0
  20:	8b040e42 	blhi	103930 <_bss_end+0xf8ea8>
  24:	0b0d4201 	bleq	350830 <_bss_end+0x345da8>
  28:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
  2c:	00000ecb 	andeq	r0, r0, fp, asr #29
  30:	0000001c 	andeq	r0, r0, ip, lsl r0
  34:	00000000 	andeq	r0, r0, r0
  38:	000080cc 	andeq	r8, r0, ip, asr #1
  3c:	0000002c 	andeq	r0, r0, ip, lsr #32
  40:	8b040e42 	blhi	103950 <_bss_end+0xf8ec8>
  44:	0b0d4201 	bleq	350850 <_bss_end+0x345dc8>
  48:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
  4c:	00000ecb 	andeq	r0, r0, fp, asr #29
  50:	0000001c 	andeq	r0, r0, ip, lsl r0
  54:	00000000 	andeq	r0, r0, r0
  58:	000080f8 	strdeq	r8, [r0], -r8	; <UNPREDICTABLE>
  5c:	00000020 	andeq	r0, r0, r0, lsr #32
  60:	8b040e42 	blhi	103970 <_bss_end+0xf8ee8>
  64:	0b0d4201 	bleq	350870 <_bss_end+0x345de8>
  68:	420d0d48 	andmi	r0, sp, #72, 26	; 0x1200
  6c:	00000ecb 	andeq	r0, r0, fp, asr #29
  70:	0000001c 	andeq	r0, r0, ip, lsl r0
  74:	00000000 	andeq	r0, r0, r0
  78:	00008118 	andeq	r8, r0, r8, lsl r1
  7c:	00000018 	andeq	r0, r0, r8, lsl r0
  80:	8b040e42 	blhi	103990 <_bss_end+0xf8f08>
  84:	0b0d4201 	bleq	350890 <_bss_end+0x345e08>
  88:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  8c:	00000ecb 	andeq	r0, r0, fp, asr #29
  90:	0000001c 	andeq	r0, r0, ip, lsl r0
  94:	00000000 	andeq	r0, r0, r0
  98:	00008130 	andeq	r8, r0, r0, lsr r1
  9c:	00000018 	andeq	r0, r0, r8, lsl r0
  a0:	8b040e42 	blhi	1039b0 <_bss_end+0xf8f28>
  a4:	0b0d4201 	bleq	3508b0 <_bss_end+0x345e28>
  a8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  ac:	00000ecb 	andeq	r0, r0, fp, asr #29
  b0:	0000001c 	andeq	r0, r0, ip, lsl r0
  b4:	00000000 	andeq	r0, r0, r0
  b8:	00008148 	andeq	r8, r0, r8, asr #2
  bc:	00000018 	andeq	r0, r0, r8, lsl r0
  c0:	8b040e42 	blhi	1039d0 <_bss_end+0xf8f48>
  c4:	0b0d4201 	bleq	3508d0 <_bss_end+0x345e48>
  c8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  cc:	00000ecb 	andeq	r0, r0, fp, asr #29
  d0:	00000014 	andeq	r0, r0, r4, lsl r0
  d4:	00000000 	andeq	r0, r0, r0
  d8:	00008160 	andeq	r8, r0, r0, ror #2
  dc:	0000000c 	andeq	r0, r0, ip
  e0:	8b040e42 	blhi	1039f0 <_bss_end+0xf8f68>
  e4:	0b0d4201 	bleq	3508f0 <_bss_end+0x345e68>
  e8:	0000000c 	andeq	r0, r0, ip
  ec:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  f0:	7c020001 	stcvc	0, cr0, [r2], {1}
  f4:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  f8:	0000001c 	andeq	r0, r0, ip, lsl r0
  fc:	000000e8 	andeq	r0, r0, r8, ror #1
 100:	0000816c 	andeq	r8, r0, ip, ror #2
 104:	00000034 	andeq	r0, r0, r4, lsr r0
 108:	8b040e42 	blhi	103a18 <_bss_end+0xf8f90>
 10c:	0b0d4201 	bleq	350918 <_bss_end+0x345e90>
 110:	420d0d52 	andmi	r0, sp, #5248	; 0x1480
 114:	00000ecb 	andeq	r0, r0, fp, asr #29
 118:	0000001c 	andeq	r0, r0, ip, lsl r0
 11c:	000000e8 	andeq	r0, r0, r8, ror #1
 120:	000081a0 	andeq	r8, r0, r0, lsr #3
 124:	00000050 	andeq	r0, r0, r0, asr r0
 128:	8b080e42 	blhi	203a38 <_bss_end+0x1f8fb0>
 12c:	42018e02 	andmi	r8, r1, #2, 28
 130:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 134:	00080d0c 	andeq	r0, r8, ip, lsl #26
 138:	0000001c 	andeq	r0, r0, ip, lsl r0
 13c:	000000e8 	andeq	r0, r0, r8, ror #1
 140:	000081f0 	strdeq	r8, [r0], -r0
 144:	00000054 	andeq	r0, r0, r4, asr r0
 148:	8b080e42 	blhi	203a58 <_bss_end+0x1f8fd0>
 14c:	42018e02 	andmi	r8, r1, #2, 28
 150:	64040b0c 	strvs	r0, [r4], #-2828	; 0xfffff4f4
 154:	00080d0c 	andeq	r0, r8, ip, lsl #26
 158:	0000001c 	andeq	r0, r0, ip, lsl r0
 15c:	000000e8 	andeq	r0, r0, r8, ror #1
 160:	00008244 	andeq	r8, r0, r4, asr #4
 164:	00000044 	andeq	r0, r0, r4, asr #32
 168:	8b040e42 	blhi	103a78 <_bss_end+0xf8ff0>
 16c:	0b0d4201 	bleq	350978 <_bss_end+0x345ef0>
 170:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 174:	00000ecb 	andeq	r0, r0, fp, asr #29
 178:	0000001c 	andeq	r0, r0, ip, lsl r0
 17c:	000000e8 	andeq	r0, r0, r8, ror #1
 180:	00008288 	andeq	r8, r0, r8, lsl #5
 184:	0000003c 	andeq	r0, r0, ip, lsr r0
 188:	8b040e42 	blhi	103a98 <_bss_end+0xf9010>
 18c:	0b0d4201 	bleq	350998 <_bss_end+0x345f10>
 190:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 194:	00000ecb 	andeq	r0, r0, fp, asr #29
 198:	0000001c 	andeq	r0, r0, ip, lsl r0
 19c:	000000e8 	andeq	r0, r0, r8, ror #1
 1a0:	000082c4 	andeq	r8, r0, r4, asr #5
 1a4:	00000054 	andeq	r0, r0, r4, asr r0
 1a8:	8b080e42 	blhi	203ab8 <_bss_end+0x1f9030>
 1ac:	42018e02 	andmi	r8, r1, #2, 28
 1b0:	5e040b0c 	vmlapl.f64	d0, d4, d12
 1b4:	00080d0c 	andeq	r0, r8, ip, lsl #26
 1b8:	00000018 	andeq	r0, r0, r8, lsl r0
 1bc:	000000e8 	andeq	r0, r0, r8, ror #1
 1c0:	00008318 	andeq	r8, r0, r8, lsl r3
 1c4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1c8:	8b080e42 	blhi	203ad8 <_bss_end+0x1f9050>
 1cc:	42018e02 	andmi	r8, r1, #2, 28
 1d0:	00040b0c 	andeq	r0, r4, ip, lsl #22
 1d4:	0000000c 	andeq	r0, r0, ip
 1d8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 1dc:	7c020001 	stcvc	0, cr0, [r2], {1}
 1e0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 1e4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1e8:	000001d4 	ldrdeq	r0, [r0], -r4
 1ec:	00008334 	andeq	r8, r0, r4, lsr r3
 1f0:	00000034 	andeq	r0, r0, r4, lsr r0
 1f4:	8b040e42 	blhi	103b04 <_bss_end+0xf907c>
 1f8:	0b0d4201 	bleq	350a04 <_bss_end+0x345f7c>
 1fc:	420d0d52 	andmi	r0, sp, #5248	; 0x1480
 200:	00000ecb 	andeq	r0, r0, fp, asr #29
 204:	0000001c 	andeq	r0, r0, ip, lsl r0
 208:	000001d4 	ldrdeq	r0, [r0], -r4
 20c:	00008368 	andeq	r8, r0, r8, ror #6
 210:	00000114 	andeq	r0, r0, r4, lsl r1
 214:	8b040e42 	blhi	103b24 <_bss_end+0xf909c>
 218:	0b0d4201 	bleq	350a24 <_bss_end+0x345f9c>
 21c:	0d0d8002 	stceq	0, cr8, [sp, #-8]
 220:	000ecb42 	andeq	ip, lr, r2, asr #22
 224:	0000001c 	andeq	r0, r0, ip, lsl r0
 228:	000001d4 	ldrdeq	r0, [r0], -r4
 22c:	0000847c 	andeq	r8, r0, ip, ror r4
 230:	00000074 	andeq	r0, r0, r4, ror r0
 234:	8b040e42 	blhi	103b44 <_bss_end+0xf90bc>
 238:	0b0d4201 	bleq	350a44 <_bss_end+0x345fbc>
 23c:	420d0d72 	andmi	r0, sp, #7296	; 0x1c80
 240:	00000ecb 	andeq	r0, r0, fp, asr #29
 244:	0000001c 	andeq	r0, r0, ip, lsl r0
 248:	000001d4 	ldrdeq	r0, [r0], -r4
 24c:	000084f0 	strdeq	r8, [r0], -r0
 250:	00000074 	andeq	r0, r0, r4, ror r0
 254:	8b040e42 	blhi	103b64 <_bss_end+0xf90dc>
 258:	0b0d4201 	bleq	350a64 <_bss_end+0x345fdc>
 25c:	420d0d72 	andmi	r0, sp, #7296	; 0x1c80
 260:	00000ecb 	andeq	r0, r0, fp, asr #29
 264:	0000001c 	andeq	r0, r0, ip, lsl r0
 268:	000001d4 	ldrdeq	r0, [r0], -r4
 26c:	00008564 	andeq	r8, r0, r4, ror #10
 270:	00000074 	andeq	r0, r0, r4, ror r0
 274:	8b040e42 	blhi	103b84 <_bss_end+0xf90fc>
 278:	0b0d4201 	bleq	350a84 <_bss_end+0x345ffc>
 27c:	420d0d72 	andmi	r0, sp, #7296	; 0x1c80
 280:	00000ecb 	andeq	r0, r0, fp, asr #29
 284:	0000001c 	andeq	r0, r0, ip, lsl r0
 288:	000001d4 	ldrdeq	r0, [r0], -r4
 28c:	000085d8 	ldrdeq	r8, [r0], -r8	; <UNPREDICTABLE>
 290:	000000a8 	andeq	r0, r0, r8, lsr #1
 294:	8b080e42 	blhi	203ba4 <_bss_end+0x1f911c>
 298:	42018e02 	andmi	r8, r1, #2, 28
 29c:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 2a0:	080d0c4e 	stmdaeq	sp, {r1, r2, r3, r6, sl, fp}
 2a4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2a8:	000001d4 	ldrdeq	r0, [r0], -r4
 2ac:	00008680 	andeq	r8, r0, r0, lsl #13
 2b0:	0000007c 	andeq	r0, r0, ip, ror r0
 2b4:	8b080e42 	blhi	203bc4 <_bss_end+0x1f913c>
 2b8:	42018e02 	andmi	r8, r1, #2, 28
 2bc:	78040b0c 	stmdavc	r4, {r2, r3, r8, r9, fp}
 2c0:	00080d0c 	andeq	r0, r8, ip, lsl #26
 2c4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2c8:	000001d4 	ldrdeq	r0, [r0], -r4
 2cc:	000086fc 	strdeq	r8, [r0], -ip
 2d0:	00000084 	andeq	r0, r0, r4, lsl #1
 2d4:	8b080e42 	blhi	203be4 <_bss_end+0x1f915c>
 2d8:	42018e02 	andmi	r8, r1, #2, 28
 2dc:	7c040b0c 			; <UNDEFINED> instruction: 0x7c040b0c
 2e0:	00080d0c 	andeq	r0, r8, ip, lsl #26
 2e4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2e8:	000001d4 	ldrdeq	r0, [r0], -r4
 2ec:	00008780 	andeq	r8, r0, r0, lsl #15
 2f0:	0000010c 	andeq	r0, r0, ip, lsl #2
 2f4:	8b040e42 	blhi	103c04 <_bss_end+0xf917c>
 2f8:	0b0d4201 	bleq	350b04 <_bss_end+0x34607c>
 2fc:	0d0d7e02 	stceq	14, cr7, [sp, #-8]
 300:	000ecb42 	andeq	ip, lr, r2, asr #22
 304:	0000001c 	andeq	r0, r0, ip, lsl r0
 308:	000001d4 	ldrdeq	r0, [r0], -r4
 30c:	0000888c 	andeq	r8, r0, ip, lsl #17
 310:	000000b4 	strheq	r0, [r0], -r4
 314:	8b080e42 	blhi	203c24 <_bss_end+0x1f919c>
 318:	42018e02 	andmi	r8, r1, #2, 28
 31c:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 320:	080d0c54 	stmdaeq	sp, {r2, r4, r6, sl, fp}
 324:	0000001c 	andeq	r0, r0, ip, lsl r0
 328:	000001d4 	ldrdeq	r0, [r0], -r4
 32c:	00008940 	andeq	r8, r0, r0, asr #18
 330:	000000d8 	ldrdeq	r0, [r0], -r8
 334:	8b080e42 	blhi	203c44 <_bss_end+0x1f91bc>
 338:	42018e02 	andmi	r8, r1, #2, 28
 33c:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 340:	080d0c66 	stmdaeq	sp, {r1, r2, r5, r6, sl, fp}
 344:	0000001c 	andeq	r0, r0, ip, lsl r0
 348:	000001d4 	ldrdeq	r0, [r0], -r4
 34c:	00008a18 	andeq	r8, r0, r8, lsl sl
 350:	00000074 	andeq	r0, r0, r4, ror r0
 354:	8b040e42 	blhi	103c64 <_bss_end+0xf91dc>
 358:	0b0d4201 	bleq	350b64 <_bss_end+0x3460dc>
 35c:	420d0d72 	andmi	r0, sp, #7296	; 0x1c80
 360:	00000ecb 	andeq	r0, r0, fp, asr #29
 364:	0000001c 	andeq	r0, r0, ip, lsl r0
 368:	000001d4 	ldrdeq	r0, [r0], -r4
 36c:	00008a8c 	andeq	r8, r0, ip, lsl #21
 370:	00000074 	andeq	r0, r0, r4, ror r0
 374:	8b080e42 	blhi	203c84 <_bss_end+0x1f91fc>
 378:	42018e02 	andmi	r8, r1, #2, 28
 37c:	74040b0c 	strvc	r0, [r4], #-2828	; 0xfffff4f4
 380:	00080d0c 	andeq	r0, r8, ip, lsl #26
 384:	0000001c 	andeq	r0, r0, ip, lsl r0
 388:	000001d4 	ldrdeq	r0, [r0], -r4
 38c:	00008b00 	andeq	r8, r0, r0, lsl #22
 390:	00000054 	andeq	r0, r0, r4, asr r0
 394:	8b080e42 	blhi	203ca4 <_bss_end+0x1f921c>
 398:	42018e02 	andmi	r8, r1, #2, 28
 39c:	5e040b0c 	vmlapl.f64	d0, d4, d12
 3a0:	00080d0c 	andeq	r0, r8, ip, lsl #26
 3a4:	00000018 	andeq	r0, r0, r8, lsl r0
 3a8:	000001d4 	ldrdeq	r0, [r0], -r4
 3ac:	00008b54 	andeq	r8, r0, r4, asr fp
 3b0:	0000001c 	andeq	r0, r0, ip, lsl r0
 3b4:	8b080e42 	blhi	203cc4 <_bss_end+0x1f923c>
 3b8:	42018e02 	andmi	r8, r1, #2, 28
 3bc:	00040b0c 	andeq	r0, r4, ip, lsl #22
 3c0:	0000000c 	andeq	r0, r0, ip
 3c4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 3c8:	7c020001 	stcvc	0, cr0, [r2], {1}
 3cc:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 3d0:	0000001c 	andeq	r0, r0, ip, lsl r0
 3d4:	000003c0 	andeq	r0, r0, r0, asr #7
 3d8:	00008b70 	andeq	r8, r0, r0, ror fp
 3dc:	00000078 	andeq	r0, r0, r8, ror r0
 3e0:	8b040e42 	blhi	103cf0 <_bss_end+0xf9268>
 3e4:	0b0d4201 	bleq	350bf0 <_bss_end+0x346168>
 3e8:	420d0d74 	andmi	r0, sp, #116, 26	; 0x1d00
 3ec:	00000ecb 	andeq	r0, r0, fp, asr #29
 3f0:	0000001c 	andeq	r0, r0, ip, lsl r0
 3f4:	000003c0 	andeq	r0, r0, r0, asr #7
 3f8:	000091b8 			; <UNDEFINED> instruction: 0x000091b8
 3fc:	00000038 	andeq	r0, r0, r8, lsr r0
 400:	8b040e42 	blhi	103d10 <_bss_end+0xf9288>
 404:	0b0d4201 	bleq	350c10 <_bss_end+0x346188>
 408:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
 40c:	00000ecb 	andeq	r0, r0, fp, asr #29
 410:	0000001c 	andeq	r0, r0, ip, lsl r0
 414:	000003c0 	andeq	r0, r0, r0, asr #7
 418:	00008be8 	andeq	r8, r0, r8, ror #23
 41c:	000000a8 	andeq	r0, r0, r8, lsr #1
 420:	8b080e42 	blhi	203d30 <_bss_end+0x1f92a8>
 424:	42018e02 	andmi	r8, r1, #2, 28
 428:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 42c:	080d0c4e 	stmdaeq	sp, {r1, r2, r3, r6, sl, fp}
 430:	0000001c 	andeq	r0, r0, ip, lsl r0
 434:	000003c0 	andeq	r0, r0, r0, asr #7
 438:	000091f0 	strdeq	r9, [r0], -r0
 43c:	00000088 	andeq	r0, r0, r8, lsl #1
 440:	8b080e42 	blhi	203d50 <_bss_end+0x1f92c8>
 444:	42018e02 	andmi	r8, r1, #2, 28
 448:	7e040b0c 	vmlavc.f64	d0, d4, d12
 44c:	00080d0c 	andeq	r0, r8, ip, lsl #26
 450:	0000001c 	andeq	r0, r0, ip, lsl r0
 454:	000003c0 	andeq	r0, r0, r0, asr #7
 458:	00008c90 	muleq	r0, r0, ip
 45c:	00000130 	andeq	r0, r0, r0, lsr r1
 460:	8b040e42 	blhi	103d70 <_bss_end+0xf92e8>
 464:	0b0d4201 	bleq	350c70 <_bss_end+0x3461e8>
 468:	0d0d9002 	stceq	0, cr9, [sp, #-8]
 46c:	000ecb42 	andeq	ip, lr, r2, asr #22
 470:	0000001c 	andeq	r0, r0, ip, lsl r0
 474:	000003c0 	andeq	r0, r0, r0, asr #7
 478:	00009278 	andeq	r9, r0, r8, ror r2
 47c:	0000002c 	andeq	r0, r0, ip, lsr #32
 480:	8b040e42 	blhi	103d90 <_bss_end+0xf9308>
 484:	0b0d4201 	bleq	350c90 <_bss_end+0x346208>
 488:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 48c:	00000ecb 	andeq	r0, r0, fp, asr #29
 490:	0000001c 	andeq	r0, r0, ip, lsl r0
 494:	000003c0 	andeq	r0, r0, r0, asr #7
 498:	00008dc0 	andeq	r8, r0, r0, asr #27
 49c:	000000a8 	andeq	r0, r0, r8, lsr #1
 4a0:	8b080e42 	blhi	203db0 <_bss_end+0x1f9328>
 4a4:	42018e02 	andmi	r8, r1, #2, 28
 4a8:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 4ac:	080d0c4e 	stmdaeq	sp, {r1, r2, r3, r6, sl, fp}
 4b0:	0000001c 	andeq	r0, r0, ip, lsl r0
 4b4:	000003c0 	andeq	r0, r0, r0, asr #7
 4b8:	00008e68 	andeq	r8, r0, r8, ror #28
 4bc:	00000078 	andeq	r0, r0, r8, ror r0
 4c0:	8b080e42 	blhi	203dd0 <_bss_end+0x1f9348>
 4c4:	42018e02 	andmi	r8, r1, #2, 28
 4c8:	76040b0c 	strvc	r0, [r4], -ip, lsl #22
 4cc:	00080d0c 	andeq	r0, r8, ip, lsl #26
 4d0:	0000001c 	andeq	r0, r0, ip, lsl r0
 4d4:	000003c0 	andeq	r0, r0, r0, asr #7
 4d8:	00008ee0 	andeq	r8, r0, r0, ror #29
 4dc:	00000034 	andeq	r0, r0, r4, lsr r0
 4e0:	8b040e42 	blhi	103df0 <_bss_end+0xf9368>
 4e4:	0b0d4201 	bleq	350cf0 <_bss_end+0x346268>
 4e8:	420d0d52 	andmi	r0, sp, #5248	; 0x1480
 4ec:	00000ecb 	andeq	r0, r0, fp, asr #29
 4f0:	0000001c 	andeq	r0, r0, ip, lsl r0
 4f4:	000003c0 	andeq	r0, r0, r0, asr #7
 4f8:	00008f14 	andeq	r8, r0, r4, lsl pc
 4fc:	00000054 	andeq	r0, r0, r4, asr r0
 500:	8b080e42 	blhi	203e10 <_bss_end+0x1f9388>
 504:	42018e02 	andmi	r8, r1, #2, 28
 508:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 50c:	00080d0c 	andeq	r0, r8, ip, lsl #26
 510:	0000001c 	andeq	r0, r0, ip, lsl r0
 514:	000003c0 	andeq	r0, r0, r0, asr #7
 518:	00008f68 	andeq	r8, r0, r8, ror #30
 51c:	00000060 	andeq	r0, r0, r0, rrx
 520:	8b080e42 	blhi	203e30 <_bss_end+0x1f93a8>
 524:	42018e02 	andmi	r8, r1, #2, 28
 528:	66040b0c 	strvs	r0, [r4], -ip, lsl #22
 52c:	00080d0c 	andeq	r0, r8, ip, lsl #26
 530:	0000001c 	andeq	r0, r0, ip, lsl r0
 534:	000003c0 	andeq	r0, r0, r0, asr #7
 538:	00008fc8 	andeq	r8, r0, r8, asr #31
 53c:	0000017c 	andeq	r0, r0, ip, ror r1
 540:	8b080e42 	blhi	203e50 <_bss_end+0x1f93c8>
 544:	42018e02 	andmi	r8, r1, #2, 28
 548:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 54c:	080d0cb6 	stmdaeq	sp, {r1, r2, r4, r5, r7, sl, fp}
 550:	0000001c 	andeq	r0, r0, ip, lsl r0
 554:	000003c0 	andeq	r0, r0, r0, asr #7
 558:	00009144 	andeq	r9, r0, r4, asr #2
 55c:	00000058 	andeq	r0, r0, r8, asr r0
 560:	8b080e42 	blhi	203e70 <_bss_end+0x1f93e8>
 564:	42018e02 	andmi	r8, r1, #2, 28
 568:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 56c:	00080d0c 	andeq	r0, r8, ip, lsl #26
 570:	00000018 	andeq	r0, r0, r8, lsl r0
 574:	000003c0 	andeq	r0, r0, r0, asr #7
 578:	0000919c 	muleq	r0, ip, r1
 57c:	0000001c 	andeq	r0, r0, ip, lsl r0
 580:	8b080e42 	blhi	203e90 <_bss_end+0x1f9408>
 584:	42018e02 	andmi	r8, r1, #2, 28
 588:	00040b0c 	andeq	r0, r4, ip, lsl #22
 58c:	0000000c 	andeq	r0, r0, ip
 590:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 594:	7c020001 	stcvc	0, cr0, [r2], {1}
 598:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 59c:	0000001c 	andeq	r0, r0, ip, lsl r0
 5a0:	0000058c 	andeq	r0, r0, ip, lsl #11
 5a4:	000092a4 	andeq	r9, r0, r4, lsr #5
 5a8:	000000a4 	andeq	r0, r0, r4, lsr #1
 5ac:	8b080e42 	blhi	203ebc <_bss_end+0x1f9434>
 5b0:	42018e02 	andmi	r8, r1, #2, 28
 5b4:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 5b8:	080d0c4c 	stmdaeq	sp, {r2, r3, r6, sl, fp}
 5bc:	00000020 	andeq	r0, r0, r0, lsr #32
 5c0:	0000058c 	andeq	r0, r0, ip, lsl #11
 5c4:	00009348 	andeq	r9, r0, r8, asr #6
 5c8:	0000005c 	andeq	r0, r0, ip, asr r0
 5cc:	840c0e42 	strhi	r0, [ip], #-3650	; 0xfffff1be
 5d0:	8e028b03 	vmlahi.f64	d8, d2, d3
 5d4:	0b0c4201 	bleq	310de0 <_bss_end+0x306358>
 5d8:	0d0c6804 	stceq	8, cr6, [ip, #-16]
 5dc:	0000000c 	andeq	r0, r0, ip
 5e0:	0000001c 	andeq	r0, r0, ip, lsl r0
 5e4:	0000058c 	andeq	r0, r0, ip, lsl #11
 5e8:	000093a4 	andeq	r9, r0, r4, lsr #7
 5ec:	00000094 	muleq	r0, r4, r0
 5f0:	8b080e42 	blhi	203f00 <_bss_end+0x1f9478>
 5f4:	42018e02 	andmi	r8, r1, #2, 28
 5f8:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 5fc:	080d0c40 	stmdaeq	sp, {r6, sl, fp}
 600:	0000001c 	andeq	r0, r0, ip, lsl r0
 604:	0000058c 	andeq	r0, r0, ip, lsl #11
 608:	00009438 	andeq	r9, r0, r8, lsr r4
 60c:	00000074 	andeq	r0, r0, r4, ror r0
 610:	8b080e42 	blhi	203f20 <_bss_end+0x1f9498>
 614:	42018e02 	andmi	r8, r1, #2, 28
 618:	74040b0c 	strvc	r0, [r4], #-2828	; 0xfffff4f4
 61c:	00080d0c 	andeq	r0, r8, ip, lsl #26
 620:	0000001c 	andeq	r0, r0, ip, lsl r0
 624:	0000058c 	andeq	r0, r0, ip, lsl #11
 628:	000094ac 	andeq	r9, r0, ip, lsr #9
 62c:	0000006c 	andeq	r0, r0, ip, rrx
 630:	8b080e42 	blhi	203f40 <_bss_end+0x1f94b8>
 634:	42018e02 	andmi	r8, r1, #2, 28
 638:	70040b0c 	andvc	r0, r4, ip, lsl #22
 63c:	00080d0c 	andeq	r0, r8, ip, lsl #26
 640:	0000001c 	andeq	r0, r0, ip, lsl r0
 644:	0000058c 	andeq	r0, r0, ip, lsl #11
 648:	00009518 	andeq	r9, r0, r8, lsl r5
 64c:	00000068 	andeq	r0, r0, r8, rrx
 650:	8b080e42 	blhi	203f60 <_bss_end+0x1f94d8>
 654:	42018e02 	andmi	r8, r1, #2, 28
 658:	6e040b0c 	vmlavs.f64	d0, d4, d12
 65c:	00080d0c 	andeq	r0, r8, ip, lsl #26
 660:	0000001c 	andeq	r0, r0, ip, lsl r0
 664:	0000058c 	andeq	r0, r0, ip, lsl #11
 668:	00009580 	andeq	r9, r0, r0, lsl #11
 66c:	00000040 	andeq	r0, r0, r0, asr #32
 670:	8b080e42 	blhi	203f80 <_bss_end+0x1f94f8>
 674:	42018e02 	andmi	r8, r1, #2, 28
 678:	58040b0c 	stmdapl	r4, {r2, r3, r8, r9, fp}
 67c:	00080d0c 	andeq	r0, r8, ip, lsl #26
 680:	0000001c 	andeq	r0, r0, ip, lsl r0
 684:	0000058c 	andeq	r0, r0, ip, lsl #11
 688:	000095c0 	andeq	r9, r0, r0, asr #11
 68c:	00000040 	andeq	r0, r0, r0, asr #32
 690:	8b080e42 	blhi	203fa0 <_bss_end+0x1f9518>
 694:	42018e02 	andmi	r8, r1, #2, 28
 698:	58040b0c 	stmdapl	r4, {r2, r3, r8, r9, fp}
 69c:	00080d0c 	andeq	r0, r8, ip, lsl #26
 6a0:	0000001c 	andeq	r0, r0, ip, lsl r0
 6a4:	0000058c 	andeq	r0, r0, ip, lsl #11
 6a8:	00009600 	andeq	r9, r0, r0, lsl #12
 6ac:	0000007c 	andeq	r0, r0, ip, ror r0
 6b0:	8b080e42 	blhi	203fc0 <_bss_end+0x1f9538>
 6b4:	42018e02 	andmi	r8, r1, #2, 28
 6b8:	78040b0c 	stmdavc	r4, {r2, r3, r8, r9, fp}
 6bc:	00080d0c 	andeq	r0, r8, ip, lsl #26
 6c0:	00000020 	andeq	r0, r0, r0, lsr #32
 6c4:	0000058c 	andeq	r0, r0, ip, lsl #11
 6c8:	0000967c 	andeq	r9, r0, ip, ror r6
 6cc:	00000050 	andeq	r0, r0, r0, asr r0
 6d0:	840c0e42 	strhi	r0, [ip], #-3650	; 0xfffff1be
 6d4:	8e028b03 	vmlahi.f64	d8, d2, d3
 6d8:	0b0c4201 	bleq	310ee4 <_bss_end+0x30645c>
 6dc:	0d0c6204 	sfmeq	f6, 4, [ip, #-16]
 6e0:	0000000c 	andeq	r0, r0, ip
 6e4:	00000020 	andeq	r0, r0, r0, lsr #32
 6e8:	0000058c 	andeq	r0, r0, ip, lsl #11
 6ec:	000096cc 	andeq	r9, r0, ip, asr #13
 6f0:	00000050 	andeq	r0, r0, r0, asr r0
 6f4:	840c0e42 	strhi	r0, [ip], #-3650	; 0xfffff1be
 6f8:	8e028b03 	vmlahi.f64	d8, d2, d3
 6fc:	0b0c4201 	bleq	310f08 <_bss_end+0x306480>
 700:	0d0c6204 	sfmeq	f6, 4, [ip, #-16]
 704:	0000000c 	andeq	r0, r0, ip
 708:	0000001c 	andeq	r0, r0, ip, lsl r0
 70c:	0000058c 	andeq	r0, r0, ip, lsl #11
 710:	0000971c 	andeq	r9, r0, ip, lsl r7
 714:	00000054 	andeq	r0, r0, r4, asr r0
 718:	8b080e42 	blhi	204028 <_bss_end+0x1f95a0>
 71c:	42018e02 	andmi	r8, r1, #2, 28
 720:	5e040b0c 	vmlapl.f64	d0, d4, d12
 724:	00080d0c 	andeq	r0, r8, ip, lsl #26
 728:	00000018 	andeq	r0, r0, r8, lsl r0
 72c:	0000058c 	andeq	r0, r0, ip, lsl #11
 730:	00009770 	andeq	r9, r0, r0, ror r7
 734:	0000001c 	andeq	r0, r0, ip, lsl r0
 738:	8b080e42 	blhi	204048 <_bss_end+0x1f95c0>
 73c:	42018e02 	andmi	r8, r1, #2, 28
 740:	00040b0c 	andeq	r0, r4, ip, lsl #22
 744:	0000000c 	andeq	r0, r0, ip
 748:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 74c:	7c020001 	stcvc	0, cr0, [r2], {1}
 750:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 754:	00000020 	andeq	r0, r0, r0, lsr #32
 758:	00000744 	andeq	r0, r0, r4, asr #14
 75c:	0000978c 	andeq	r9, r0, ip, lsl #15
 760:	00000334 	andeq	r0, r0, r4, lsr r3
 764:	8b080e42 	blhi	204074 <_bss_end+0x1f95ec>
 768:	42018e02 	andmi	r8, r1, #2, 28
 76c:	03040b0c 	movweq	r0, #19212	; 0x4b0c
 770:	0d0c017a 	stfeqs	f0, [ip, #-488]	; 0xfffffe18
 774:	00000008 	andeq	r0, r0, r8
 778:	0000001c 	andeq	r0, r0, ip, lsl r0
 77c:	00000744 	andeq	r0, r0, r4, asr #14
 780:	00009ac0 	andeq	r9, r0, r0, asr #21
 784:	00000018 	andeq	r0, r0, r8, lsl r0
 788:	8b040e42 	blhi	104098 <_bss_end+0xf9610>
 78c:	0b0d4201 	bleq	350f98 <_bss_end+0x346510>
 790:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
 794:	00000ecb 	andeq	r0, r0, fp, asr #29
 798:	00000028 	andeq	r0, r0, r8, lsr #32
 79c:	00000744 	andeq	r0, r0, r4, asr #14
 7a0:	00009ad8 	ldrdeq	r9, [r0], -r8
 7a4:	0000003c 	andeq	r0, r0, ip, lsr r0
 7a8:	801c0e44 	andshi	r0, ip, r4, asr #28
 7ac:	82068107 	andhi	r8, r6, #-1073741823	; 0xc0000001
 7b0:	8b048305 	blhi	1213cc <_bss_end+0x116944>
 7b4:	8e028c03 	cdphi	12, 0, cr8, cr2, cr3, {0}
 7b8:	0b0c4201 	bleq	310fc4 <_bss_end+0x30653c>
 7bc:	0d0c5404 	cfstrseq	mvf5, [ip, #-16]
 7c0:	0000001c 	andeq	r0, r0, ip, lsl r0
 7c4:	00000014 	andeq	r0, r0, r4, lsl r0
 7c8:	00000744 	andeq	r0, r0, r4, asr #14
 7cc:	00009b14 	andeq	r9, r0, r4, lsl fp
 7d0:	00000010 	andeq	r0, r0, r0, lsl r0
 7d4:	040b0c42 	streq	r0, [fp], #-3138	; 0xfffff3be
 7d8:	000d0c44 	andeq	r0, sp, r4, asr #24
 7dc:	0000001c 	andeq	r0, r0, ip, lsl r0
 7e0:	00000744 	andeq	r0, r0, r4, asr #14
 7e4:	00009b24 	andeq	r9, r0, r4, lsr #22
 7e8:	00000034 	andeq	r0, r0, r4, lsr r0
 7ec:	8b040e42 	blhi	1040fc <_bss_end+0xf9674>
 7f0:	0b0d4201 	bleq	350ffc <_bss_end+0x346574>
 7f4:	420d0d52 	andmi	r0, sp, #5248	; 0x1480
 7f8:	00000ecb 	andeq	r0, r0, fp, asr #29
 7fc:	0000001c 	andeq	r0, r0, ip, lsl r0
 800:	00000744 	andeq	r0, r0, r4, asr #14
 804:	00009b58 	andeq	r9, r0, r8, asr fp
 808:	00000038 	andeq	r0, r0, r8, lsr r0
 80c:	8b040e42 	blhi	10411c <_bss_end+0xf9694>
 810:	0b0d4201 	bleq	35101c <_bss_end+0x346594>
 814:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
 818:	00000ecb 	andeq	r0, r0, fp, asr #29
 81c:	00000020 	andeq	r0, r0, r0, lsr #32
 820:	00000744 	andeq	r0, r0, r4, asr #14
 824:	00009b90 	muleq	r0, r0, fp
 828:	00000044 	andeq	r0, r0, r4, asr #32
 82c:	840c0e42 	strhi	r0, [ip], #-3650	; 0xfffff1be
 830:	8e028b03 	vmlahi.f64	d8, d2, d3
 834:	0b0c4201 	bleq	311040 <_bss_end+0x3065b8>
 838:	0d0c5c04 	stceq	12, cr5, [ip, #-16]
 83c:	0000000c 	andeq	r0, r0, ip
 840:	00000020 	andeq	r0, r0, r0, lsr #32
 844:	00000744 	andeq	r0, r0, r4, asr #14
 848:	00009bd4 	ldrdeq	r9, [r0], -r4
 84c:	00000044 	andeq	r0, r0, r4, asr #32
 850:	840c0e42 	strhi	r0, [ip], #-3650	; 0xfffff1be
 854:	8e028b03 	vmlahi.f64	d8, d2, d3
 858:	0b0c4201 	bleq	311064 <_bss_end+0x3065dc>
 85c:	0d0c5c04 	stceq	12, cr5, [ip, #-16]
 860:	0000000c 	andeq	r0, r0, ip
 864:	00000020 	andeq	r0, r0, r0, lsr #32
 868:	00000744 	andeq	r0, r0, r4, asr #14
 86c:	00009c18 	andeq	r9, r0, r8, lsl ip
 870:	00000068 	andeq	r0, r0, r8, rrx
 874:	840c0e42 	strhi	r0, [ip], #-3650	; 0xfffff1be
 878:	8e028b03 	vmlahi.f64	d8, d2, d3
 87c:	0b0c4201 	bleq	311088 <_bss_end+0x306600>
 880:	0d0c6e04 	stceq	14, cr6, [ip, #-16]
 884:	0000000c 	andeq	r0, r0, ip
 888:	00000020 	andeq	r0, r0, r0, lsr #32
 88c:	00000744 	andeq	r0, r0, r4, asr #14
 890:	00009c80 	andeq	r9, r0, r0, lsl #25
 894:	00000068 	andeq	r0, r0, r8, rrx
 898:	840c0e42 	strhi	r0, [ip], #-3650	; 0xfffff1be
 89c:	8e028b03 	vmlahi.f64	d8, d2, d3
 8a0:	0b0c4201 	bleq	3110ac <_bss_end+0x306624>
 8a4:	0d0c6e04 	stceq	14, cr6, [ip, #-16]
 8a8:	0000000c 	andeq	r0, r0, ip
 8ac:	0000001c 	andeq	r0, r0, ip, lsl r0
 8b0:	00000744 	andeq	r0, r0, r4, asr #14
 8b4:	00009ce8 	andeq	r9, r0, r8, ror #25
 8b8:	00000054 	andeq	r0, r0, r4, asr r0
 8bc:	8b080e42 	blhi	2041cc <_bss_end+0x1f9744>
 8c0:	42018e02 	andmi	r8, r1, #2, 28
 8c4:	5e040b0c 	vmlapl.f64	d0, d4, d12
 8c8:	00080d0c 	andeq	r0, r8, ip, lsl #26
 8cc:	00000018 	andeq	r0, r0, r8, lsl r0
 8d0:	00000744 	andeq	r0, r0, r4, asr #14
 8d4:	00009d3c 	andeq	r9, r0, ip, lsr sp
 8d8:	0000001c 	andeq	r0, r0, ip, lsl r0
 8dc:	8b080e42 	blhi	2041ec <_bss_end+0x1f9764>
 8e0:	42018e02 	andmi	r8, r1, #2, 28
 8e4:	00040b0c 	andeq	r0, r4, ip, lsl #22
 8e8:	0000000c 	andeq	r0, r0, ip
 8ec:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 8f0:	7c020001 	stcvc	0, cr0, [r2], {1}
 8f4:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 8f8:	00000018 	andeq	r0, r0, r8, lsl r0
 8fc:	000008e8 	andeq	r0, r0, r8, ror #17
 900:	00009d58 	andeq	r9, r0, r8, asr sp
 904:	00000078 	andeq	r0, r0, r8, ror r0
 908:	8b080e42 	blhi	204218 <_bss_end+0x1f9790>
 90c:	42018e02 	andmi	r8, r1, #2, 28
 910:	00040b0c 	andeq	r0, r4, ip, lsl #22
 914:	0000000c 	andeq	r0, r0, ip
 918:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 91c:	7c020001 	stcvc	0, cr0, [r2], {1}
 920:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 924:	0000001c 	andeq	r0, r0, ip, lsl r0
 928:	00000914 	andeq	r0, r0, r4, lsl r9
 92c:	00009df0 	strdeq	r9, [r0], -r0
 930:	00000068 	andeq	r0, r0, r8, rrx
 934:	8b040e42 	blhi	104244 <_bss_end+0xf97bc>
 938:	0b0d4201 	bleq	351144 <_bss_end+0x3466bc>
 93c:	420d0d68 	andmi	r0, sp, #104, 26	; 0x1a00
 940:	00000ecb 	andeq	r0, r0, fp, asr #29
 944:	0000001c 	andeq	r0, r0, ip, lsl r0
 948:	00000914 	andeq	r0, r0, r4, lsl r9
 94c:	00009e58 	andeq	r9, r0, r8, asr lr
 950:	00000058 	andeq	r0, r0, r8, asr r0
 954:	8b080e42 	blhi	204264 <_bss_end+0x1f97dc>
 958:	42018e02 	andmi	r8, r1, #2, 28
 95c:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 960:	00080d0c 	andeq	r0, r8, ip, lsl #26
 964:	0000001c 	andeq	r0, r0, ip, lsl r0
 968:	00000914 	andeq	r0, r0, r4, lsl r9
 96c:	00009eb0 			; <UNDEFINED> instruction: 0x00009eb0
 970:	00000058 	andeq	r0, r0, r8, asr r0
 974:	8b080e42 	blhi	204284 <_bss_end+0x1f97fc>
 978:	42018e02 	andmi	r8, r1, #2, 28
 97c:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 980:	00080d0c 	andeq	r0, r8, ip, lsl #26
 984:	0000000c 	andeq	r0, r0, ip
 988:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 98c:	7c020001 	stcvc	0, cr0, [r2], {1}
 990:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 994:	0000001c 	andeq	r0, r0, ip, lsl r0
 998:	00000984 	andeq	r0, r0, r4, lsl #19
 99c:	00009f08 	andeq	r9, r0, r8, lsl #30
 9a0:	00000174 	andeq	r0, r0, r4, ror r1
 9a4:	8b080e42 	blhi	2042b4 <_bss_end+0x1f982c>
 9a8:	42018e02 	andmi	r8, r1, #2, 28
 9ac:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 9b0:	080d0cb2 	stmdaeq	sp, {r1, r4, r5, r7, sl, fp}
 9b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 9b8:	00000984 	andeq	r0, r0, r4, lsl #19
 9bc:	0000a07c 	andeq	sl, r0, ip, ror r0
 9c0:	0000009c 	muleq	r0, ip, r0
 9c4:	8b040e42 	blhi	1042d4 <_bss_end+0xf984c>
 9c8:	0b0d4201 	bleq	3511d4 <_bss_end+0x34674c>
 9cc:	0d0d4602 	stceq	6, cr4, [sp, #-8]
 9d0:	000ecb42 	andeq	ip, lr, r2, asr #22
 9d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 9d8:	00000984 	andeq	r0, r0, r4, lsl #19
 9dc:	0000a118 	andeq	sl, r0, r8, lsl r1
 9e0:	000000c0 	andeq	r0, r0, r0, asr #1
 9e4:	8b040e42 	blhi	1042f4 <_bss_end+0xf986c>
 9e8:	0b0d4201 	bleq	3511f4 <_bss_end+0x34676c>
 9ec:	0d0d5802 	stceq	8, cr5, [sp, #-8]
 9f0:	000ecb42 	andeq	ip, lr, r2, asr #22
 9f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 9f8:	00000984 	andeq	r0, r0, r4, lsl #19
 9fc:	0000a1d8 	ldrdeq	sl, [r0], -r8
 a00:	000000ac 	andeq	r0, r0, ip, lsr #1
 a04:	8b040e42 	blhi	104314 <_bss_end+0xf988c>
 a08:	0b0d4201 	bleq	351214 <_bss_end+0x34678c>
 a0c:	0d0d4e02 	stceq	14, cr4, [sp, #-8]
 a10:	000ecb42 	andeq	ip, lr, r2, asr #22
 a14:	0000001c 	andeq	r0, r0, ip, lsl r0
 a18:	00000984 	andeq	r0, r0, r4, lsl #19
 a1c:	0000a284 	andeq	sl, r0, r4, lsl #5
 a20:	00000054 	andeq	r0, r0, r4, asr r0
 a24:	8b040e42 	blhi	104334 <_bss_end+0xf98ac>
 a28:	0b0d4201 	bleq	351234 <_bss_end+0x3467ac>
 a2c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 a30:	00000ecb 	andeq	r0, r0, fp, asr #29
 a34:	0000001c 	andeq	r0, r0, ip, lsl r0
 a38:	00000984 	andeq	r0, r0, r4, lsl #19
 a3c:	0000a2d8 	ldrdeq	sl, [r0], -r8
 a40:	00000068 	andeq	r0, r0, r8, rrx
 a44:	8b040e42 	blhi	104354 <_bss_end+0xf98cc>
 a48:	0b0d4201 	bleq	351254 <_bss_end+0x3467cc>
 a4c:	420d0d6c 	andmi	r0, sp, #108, 26	; 0x1b00
 a50:	00000ecb 	andeq	r0, r0, fp, asr #29
 a54:	0000001c 	andeq	r0, r0, ip, lsl r0
 a58:	00000984 	andeq	r0, r0, r4, lsl #19
 a5c:	0000a340 	andeq	sl, r0, r0, asr #6
 a60:	00000080 	andeq	r0, r0, r0, lsl #1
 a64:	8b040e42 	blhi	104374 <_bss_end+0xf98ec>
 a68:	0b0d4201 	bleq	351274 <_bss_end+0x3467ec>
 a6c:	420d0d78 	andmi	r0, sp, #120, 26	; 0x1e00
 a70:	00000ecb 	andeq	r0, r0, fp, asr #29
 a74:	0000000c 	andeq	r0, r0, ip
 a78:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 a7c:	7c010001 	stcvc	0, cr0, [r1], {1}
 a80:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 a84:	0000000c 	andeq	r0, r0, ip
 a88:	00000a74 	andeq	r0, r0, r4, ror sl
 a8c:	0000a3c0 	andeq	sl, r0, r0, asr #7
 a90:	000001ec 	andeq	r0, r0, ip, ror #3

Disassembly of section .debug_ranges:

00000000 <.debug_ranges>:
   0:	00008b70 	andeq	r8, r0, r0, ror fp
   4:	000091b8 			; <UNDEFINED> instruction: 0x000091b8
   8:	000091b8 			; <UNDEFINED> instruction: 0x000091b8
   c:	000091f0 	strdeq	r9, [r0], -r0
  10:	000091f0 	strdeq	r9, [r0], -r0
  14:	00009278 	andeq	r9, r0, r8, ror r2
  18:	00009278 	andeq	r9, r0, r8, ror r2
  1c:	000092a4 	andeq	r9, r0, r4, lsr #5
	...
  28:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  2c:	00000000 	andeq	r0, r0, r0
  30:	00008000 	andeq	r8, r0, r0
  34:	00008094 	muleq	r0, r4, r0
  38:	00009dd0 	ldrdeq	r9, [r0], -r0
  3c:	00009df0 	strdeq	r9, [r0], -r0
	...
