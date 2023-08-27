
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
    8024:	00009e28 	andeq	r9, r0, r8, lsr #28

00008028 <_software_interrupt_ptr>:
_software_interrupt_ptr():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/start.s:21
    8028:	00009ae8 	andeq	r9, r0, r8, ror #21

0000802c <_prefetch_abort_ptr>:
_prefetch_abort_ptr():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/start.s:21
    802c:	00009e2c 	andeq	r9, r0, ip, lsr #28

00008030 <_data_abort_ptr>:
_data_abort_ptr():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/start.s:21
    8030:	00009e30 	andeq	r9, r0, r0, lsr lr

00008034 <_unused_handler_ptr>:
_unused_handler_ptr():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/start.s:21
    8034:	00008040 	andeq	r8, r0, r0, asr #32

00008038 <_irq_ptr>:
_irq_ptr():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/start.s:21
    8038:	00009b00 	andeq	r9, r0, r0, lsl #22

0000803c <_fast_interrupt_ptr>:
_fast_interrupt_ptr():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/start.s:21
    803c:	00009b58 	andeq	r9, r0, r8, asr fp

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
    8080:	eb00076b 	bl	9e34 <_c_startup>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/start.s:79
	bl _cpp_startup			;@ C++ startup kod (volani globalnich konstruktoru, ...)
    8084:	eb000784 	bl	9e9c <_cpp_startup>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/start.s:80
	bl _kernel_main			;@ skocime do hlavniho kodu jadra (v C)
    8088:	eb000743 	bl	9d9c <_kernel_main>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/start.s:81
	bl _cpp_shutdown		;@ C++ shutdown kod (volani globalnich destruktoru, ...)
    808c:	eb000798 	bl	9ef4 <_cpp_shutdown>

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
    8314:	0000aa6c 	andeq	sl, r0, ip, ror #20

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
    8b50:	0000aa70 	andeq	sl, r0, r0, ror sl

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
    8f64:	0000aa8c 	andeq	sl, r0, ip, lsl #21

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
    8fc0:	0000a7d4 	ldrdeq	sl, [r0], -r4
    8fc4:	0000a7dc 	ldrdeq	sl, [r0], -ip

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
    9004:	eb000579 	bl	a5f0 <__aeabi_uidivmod>
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
    9034:	eb0004f2 	bl	a404 <__udivsi3>
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
    9140:	0000a7e4 	andeq	sl, r0, r4, ror #15

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
    9198:	0000aa74 	andeq	sl, r0, r4, ror sl

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
    93cc:	eb00040c 	bl	a404 <__udivsi3>
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
    95a0:	eb000269 	bl	9f4c <_Z4itoajPcj>
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
    95bc:	0000aaa0 	andeq	sl, r0, r0, lsr #21

000095c0 <_ZN5CUART5WriteEi>:
_ZN5CUART5WriteEi():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:71

void CUART::Write(int num)
{
    95c0:	e92d4800 	push	{fp, lr}
    95c4:	e28db004 	add	fp, sp, #4
    95c8:	e24dd008 	sub	sp, sp, #8
    95cc:	e50b0008 	str	r0, [fp, #-8]
    95d0:	e50b100c 	str	r1, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:72
    Write(static_cast<unsigned int>(num));
    95d4:	e51b300c 	ldr	r3, [fp, #-12]
    95d8:	e1a01003 	mov	r1, r3
    95dc:	e51b0008 	ldr	r0, [fp, #-8]
    95e0:	ebffffe6 	bl	9580 <_ZN5CUART5WriteEj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:73
}
    95e4:	e320f000 	nop	{0}
    95e8:	e24bd004 	sub	sp, fp, #4
    95ec:	e8bd8800 	pop	{fp, pc}

000095f0 <_ZN5CUART9Write_HexEj>:
_ZN5CUART9Write_HexEj():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:76

void CUART::Write_Hex(unsigned int num)
{
    95f0:	e92d4800 	push	{fp, lr}
    95f4:	e28db004 	add	fp, sp, #4
    95f8:	e24dd008 	sub	sp, sp, #8
    95fc:	e50b0008 	str	r0, [fp, #-8]
    9600:	e50b100c 	str	r1, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:79
    static char buf[16];

    itoa(num, buf, 16);
    9604:	e3a02010 	mov	r2, #16
    9608:	e59f101c 	ldr	r1, [pc, #28]	; 962c <_ZN5CUART9Write_HexEj+0x3c>
    960c:	e51b000c 	ldr	r0, [fp, #-12]
    9610:	eb00024d 	bl	9f4c <_Z4itoajPcj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:80
    Write(buf);
    9614:	e59f1010 	ldr	r1, [pc, #16]	; 962c <_ZN5CUART9Write_HexEj+0x3c>
    9618:	e51b0008 	ldr	r0, [fp, #-8]
    961c:	ebffffa2 	bl	94ac <_ZN5CUART5WriteEPKc>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:81
}
    9620:	e320f000 	nop	{0}
    9624:	e24bd004 	sub	sp, fp, #4
    9628:	e8bd8800 	pop	{fp, pc}
    962c:	0000aab0 			; <UNDEFINED> instruction: 0x0000aab0

00009630 <_ZN5CUART4ReadEPc>:
_ZN5CUART4ReadEPc():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:84

void CUART::Read(char* c)
{
    9630:	e92d4800 	push	{fp, lr}
    9634:	e28db004 	add	fp, sp, #4
    9638:	e24dd008 	sub	sp, sp, #8
    963c:	e50b0008 	str	r0, [fp, #-8]
    9640:	e50b100c 	str	r1, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:85
    while (!(mAUX.Get_Register(hal::AUX_Reg::MU_LSR) & 1))
    9644:	e51b3008 	ldr	r3, [fp, #-8]
    9648:	e5933000 	ldr	r3, [r3]
    964c:	e3a01015 	mov	r1, #21
    9650:	e1a00003 	mov	r0, r3
    9654:	ebfffb0b 	bl	8288 <_ZN4CAUX12Get_RegisterEN3hal7AUX_RegE>
    9658:	e1a03000 	mov	r3, r0
    965c:	e2033001 	and	r3, r3, #1
    9660:	e3530000 	cmp	r3, #0
    9664:	03a03001 	moveq	r3, #1
    9668:	13a03000 	movne	r3, #0
    966c:	e6ef3073 	uxtb	r3, r3
    9670:	e3530000 	cmp	r3, #0
    9674:	0a000000 	beq	967c <_ZN5CUART4ReadEPc+0x4c>
    9678:	eafffff1 	b	9644 <_ZN5CUART4ReadEPc+0x14>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:90
    {
        ;
    }

    *c = mAUX.Get_Register(hal::AUX_Reg::MU_IO) & 0xFF;
    967c:	e51b3008 	ldr	r3, [fp, #-8]
    9680:	e5933000 	ldr	r3, [r3]
    9684:	e3a01010 	mov	r1, #16
    9688:	e1a00003 	mov	r0, r3
    968c:	ebfffafd 	bl	8288 <_ZN4CAUX12Get_RegisterEN3hal7AUX_RegE>
    9690:	e1a03000 	mov	r3, r0
    9694:	e6ef2073 	uxtb	r2, r3
    9698:	e51b300c 	ldr	r3, [fp, #-12]
    969c:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:91
}
    96a0:	e320f000 	nop	{0}
    96a4:	e24bd004 	sub	sp, fp, #4
    96a8:	e8bd8800 	pop	{fp, pc}

000096ac <_ZN5CUART18Enable_Receive_IntEv>:
_ZN5CUART18Enable_Receive_IntEv():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:94

void CUART::Enable_Receive_Int()
{
    96ac:	e92d4810 	push	{r4, fp, lr}
    96b0:	e28db008 	add	fp, sp, #8
    96b4:	e24dd00c 	sub	sp, sp, #12
    96b8:	e50b0010 	str	r0, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:95
    mAUX.Set_Register(hal::AUX_Reg::MU_IER, mAUX.Get_Register(hal::AUX_Reg::MU_IER) | (0b1U << 1U));
    96bc:	e51b3010 	ldr	r3, [fp, #-16]
    96c0:	e5934000 	ldr	r4, [r3]
    96c4:	e51b3010 	ldr	r3, [fp, #-16]
    96c8:	e5933000 	ldr	r3, [r3]
    96cc:	e3a01011 	mov	r1, #17
    96d0:	e1a00003 	mov	r0, r3
    96d4:	ebfffaeb 	bl	8288 <_ZN4CAUX12Get_RegisterEN3hal7AUX_RegE>
    96d8:	e1a03000 	mov	r3, r0
    96dc:	e3833002 	orr	r3, r3, #2
    96e0:	e1a02003 	mov	r2, r3
    96e4:	e3a01011 	mov	r1, #17
    96e8:	e1a00004 	mov	r0, r4
    96ec:	ebfffad4 	bl	8244 <_ZN4CAUX12Set_RegisterEN3hal7AUX_RegEj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:96
}
    96f0:	e320f000 	nop	{0}
    96f4:	e24bd008 	sub	sp, fp, #8
    96f8:	e8bd8810 	pop	{r4, fp, pc}

000096fc <_ZN5CUART19Enable_Transmit_IntEv>:
_ZN5CUART19Enable_Transmit_IntEv():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:99

void CUART::Enable_Transmit_Int()
{
    96fc:	e92d4810 	push	{r4, fp, lr}
    9700:	e28db008 	add	fp, sp, #8
    9704:	e24dd00c 	sub	sp, sp, #12
    9708:	e50b0010 	str	r0, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:100
    mAUX.Set_Register(hal::AUX_Reg::MU_IER, mAUX.Get_Register(hal::AUX_Reg::MU_IER) | (0b1U << 0U));
    970c:	e51b3010 	ldr	r3, [fp, #-16]
    9710:	e5934000 	ldr	r4, [r3]
    9714:	e51b3010 	ldr	r3, [fp, #-16]
    9718:	e5933000 	ldr	r3, [r3]
    971c:	e3a01011 	mov	r1, #17
    9720:	e1a00003 	mov	r0, r3
    9724:	ebfffad7 	bl	8288 <_ZN4CAUX12Get_RegisterEN3hal7AUX_RegE>
    9728:	e1a03000 	mov	r3, r0
    972c:	e3833001 	orr	r3, r3, #1
    9730:	e1a02003 	mov	r2, r3
    9734:	e3a01011 	mov	r1, #17
    9738:	e1a00004 	mov	r0, r4
    973c:	ebfffac0 	bl	8244 <_ZN4CAUX12Set_RegisterEN3hal7AUX_RegEj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:101
    9740:	e320f000 	nop	{0}
    9744:	e24bd008 	sub	sp, fp, #8
    9748:	e8bd8810 	pop	{r4, fp, pc}

0000974c <_Z41__static_initialization_and_destruction_0ii>:
_Z41__static_initialization_and_destruction_0ii():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:101
    974c:	e92d4800 	push	{fp, lr}
    9750:	e28db004 	add	fp, sp, #4
    9754:	e24dd008 	sub	sp, sp, #8
    9758:	e50b0008 	str	r0, [fp, #-8]
    975c:	e50b100c 	str	r1, [fp, #-12]
    9760:	e51b3008 	ldr	r3, [fp, #-8]
    9764:	e3530001 	cmp	r3, #1
    9768:	1a000006 	bne	9788 <_Z41__static_initialization_and_destruction_0ii+0x3c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:101 (discriminator 1)
    976c:	e51b300c 	ldr	r3, [fp, #-12]
    9770:	e59f201c 	ldr	r2, [pc, #28]	; 9794 <_Z41__static_initialization_and_destruction_0ii+0x48>
    9774:	e1530002 	cmp	r3, r2
    9778:	1a000002 	bne	9788 <_Z41__static_initialization_and_destruction_0ii+0x3c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:6
CUART sUART0(sAUX);
    977c:	e59f1014 	ldr	r1, [pc, #20]	; 9798 <_Z41__static_initialization_and_destruction_0ii+0x4c>
    9780:	e59f0014 	ldr	r0, [pc, #20]	; 979c <_Z41__static_initialization_and_destruction_0ii+0x50>
    9784:	ebfffec6 	bl	92a4 <_ZN5CUARTC1ER4CAUX>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:101
    9788:	e320f000 	nop	{0}
    978c:	e24bd004 	sub	sp, fp, #4
    9790:	e8bd8800 	pop	{fp, pc}
    9794:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>
    9798:	0000aa6c 	andeq	sl, r0, ip, ror #20
    979c:	0000aa9c 	muleq	r0, ip, sl

000097a0 <_GLOBAL__sub_I_sUART0>:
_GLOBAL__sub_I_sUART0():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:101
    97a0:	e92d4800 	push	{fp, lr}
    97a4:	e28db004 	add	fp, sp, #4
    97a8:	e59f1008 	ldr	r1, [pc, #8]	; 97b8 <_GLOBAL__sub_I_sUART0+0x18>
    97ac:	e3a00001 	mov	r0, #1
    97b0:	ebffffe5 	bl	974c <_Z41__static_initialization_and_destruction_0ii>
    97b4:	e8bd8800 	pop	{fp, pc}
    97b8:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>

000097bc <_Z13Guessing_Gamec>:
_Z13Guessing_Gamec():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:13
volatile int max_num = 100;
volatile int min_num = 0;
volatile int middle;

void Guessing_Game(char c)
{
    97bc:	e92d4800 	push	{fp, lr}
    97c0:	e28db004 	add	fp, sp, #4
    97c4:	e24dd010 	sub	sp, sp, #16
    97c8:	e1a03000 	mov	r3, r0
    97cc:	e54b300d 	strb	r3, [fp, #-13]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:16
    bool greater;

    switch (game_state)
    97d0:	e59f32dc 	ldr	r3, [pc, #732]	; 9ab4 <_Z13Guessing_Gamec+0x2f8>
    97d4:	e5933000 	ldr	r3, [r3]
    97d8:	e3530003 	cmp	r3, #3
    97dc:	979ff103 	ldrls	pc, [pc, r3, lsl #2]
    97e0:	ea0000af 	b	9aa4 <_Z13Guessing_Gamec+0x2e8>
    97e4:	000097f4 	strdeq	r9, [r0], -r4
    97e8:	00009844 	andeq	r9, r0, r4, asr #16
    97ec:	000098b8 			; <UNDEFINED> instruction: 0x000098b8
    97f0:	000099e4 	andeq	r9, r0, r4, ror #19
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:19
    {
        case 0:
            if (c == 'y' || c == 'Y')
    97f4:	e55b300d 	ldrb	r3, [fp, #-13]
    97f8:	e3530079 	cmp	r3, #121	; 0x79
    97fc:	0a000002 	beq	980c <_Z13Guessing_Gamec+0x50>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:19 (discriminator 1)
    9800:	e55b300d 	ldrb	r3, [fp, #-13]
    9804:	e3530059 	cmp	r3, #89	; 0x59
    9808:	1a000006 	bne	9828 <_Z13Guessing_Gamec+0x6c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:21
            {
                game_state = 1;
    980c:	e59f32a0 	ldr	r3, [pc, #672]	; 9ab4 <_Z13Guessing_Gamec+0x2f8>
    9810:	e3a02001 	mov	r2, #1
    9814:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:22
                sUART0.Write("Awesome! Let's get started then...\n\r");
    9818:	e59f1298 	ldr	r1, [pc, #664]	; 9ab8 <_Z13Guessing_Gamec+0x2fc>
    981c:	e59f0298 	ldr	r0, [pc, #664]	; 9abc <_Z13Guessing_Gamec+0x300>
    9820:	ebffff21 	bl	94ac <_ZN5CUART5WriteEPKc>
    9824:	ea000006 	b	9844 <_Z13Guessing_Gamec+0x88>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:26
            }
            else
            {
                sUART0.Write("Don't worry, we can always play the game next time! Have a good one :)");
    9828:	e59f1290 	ldr	r1, [pc, #656]	; 9ac0 <_Z13Guessing_Gamec+0x304>
    982c:	e59f0288 	ldr	r0, [pc, #648]	; 9abc <_Z13Guessing_Gamec+0x300>
    9830:	ebffff1d 	bl	94ac <_ZN5CUART5WriteEPKc>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:27
                game_state = 0xFFFFFFFFU;
    9834:	e59f3278 	ldr	r3, [pc, #632]	; 9ab4 <_Z13Guessing_Gamec+0x2f8>
    9838:	e3e02000 	mvn	r2, #0
    983c:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:28
                break;
    9840:	ea000098 	b	9aa8 <_Z13Guessing_Gamec+0x2ec>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:32
            }

        case 1:
            sUART0.Write("Is your number greater than ");
    9844:	e59f1278 	ldr	r1, [pc, #632]	; 9ac4 <_Z13Guessing_Gamec+0x308>
    9848:	e59f026c 	ldr	r0, [pc, #620]	; 9abc <_Z13Guessing_Gamec+0x300>
    984c:	ebffff16 	bl	94ac <_ZN5CUART5WriteEPKc>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:33
            middle = min_num + (max_num - min_num) / 2;
    9850:	e59f3270 	ldr	r3, [pc, #624]	; 9ac8 <_Z13Guessing_Gamec+0x30c>
    9854:	e5932000 	ldr	r2, [r3]
    9858:	e59f326c 	ldr	r3, [pc, #620]	; 9acc <_Z13Guessing_Gamec+0x310>
    985c:	e5933000 	ldr	r3, [r3]
    9860:	e0423003 	sub	r3, r2, r3
    9864:	e1a02fa3 	lsr	r2, r3, #31
    9868:	e0823003 	add	r3, r2, r3
    986c:	e1a030c3 	asr	r3, r3, #1
    9870:	e1a02003 	mov	r2, r3
    9874:	e59f3250 	ldr	r3, [pc, #592]	; 9acc <_Z13Guessing_Gamec+0x310>
    9878:	e5933000 	ldr	r3, [r3]
    987c:	e0823003 	add	r3, r2, r3
    9880:	e59f2248 	ldr	r2, [pc, #584]	; 9ad0 <_Z13Guessing_Gamec+0x314>
    9884:	e5823000 	str	r3, [r2]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:34
            sUART0.Write(middle);
    9888:	e59f3240 	ldr	r3, [pc, #576]	; 9ad0 <_Z13Guessing_Gamec+0x314>
    988c:	e5933000 	ldr	r3, [r3]
    9890:	e1a01003 	mov	r1, r3
    9894:	e59f0220 	ldr	r0, [pc, #544]	; 9abc <_Z13Guessing_Gamec+0x300>
    9898:	ebffff48 	bl	95c0 <_ZN5CUART5WriteEi>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:35
            sUART0.Write("? [y/n]: ");
    989c:	e59f1230 	ldr	r1, [pc, #560]	; 9ad4 <_Z13Guessing_Gamec+0x318>
    98a0:	e59f0214 	ldr	r0, [pc, #532]	; 9abc <_Z13Guessing_Gamec+0x300>
    98a4:	ebffff00 	bl	94ac <_ZN5CUART5WriteEPKc>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:36
            game_state = 2;
    98a8:	e59f3204 	ldr	r3, [pc, #516]	; 9ab4 <_Z13Guessing_Gamec+0x2f8>
    98ac:	e3a02002 	mov	r2, #2
    98b0:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:37
            break;
    98b4:	ea00007b 	b	9aa8 <_Z13Guessing_Gamec+0x2ec>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:40

        case 2:
            if (c == 'y' || c == 'Y')
    98b8:	e55b300d 	ldrb	r3, [fp, #-13]
    98bc:	e3530079 	cmp	r3, #121	; 0x79
    98c0:	0a000002 	beq	98d0 <_Z13Guessing_Gamec+0x114>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:40 (discriminator 1)
    98c4:	e55b300d 	ldrb	r3, [fp, #-13]
    98c8:	e3530059 	cmp	r3, #89	; 0x59
    98cc:	1a000007 	bne	98f0 <_Z13Guessing_Gamec+0x134>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:42
            {
                min_num = middle + 1;
    98d0:	e59f31f8 	ldr	r3, [pc, #504]	; 9ad0 <_Z13Guessing_Gamec+0x314>
    98d4:	e5933000 	ldr	r3, [r3]
    98d8:	e2833001 	add	r3, r3, #1
    98dc:	e59f21e8 	ldr	r2, [pc, #488]	; 9acc <_Z13Guessing_Gamec+0x310>
    98e0:	e5823000 	str	r3, [r2]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:43
                greater = true;
    98e4:	e3a03001 	mov	r3, #1
    98e8:	e54b3005 	strb	r3, [fp, #-5]
    98ec:	ea000006 	b	990c <_Z13Guessing_Gamec+0x150>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:47
            }
            else
            {
                max_num = middle - 1;
    98f0:	e59f31d8 	ldr	r3, [pc, #472]	; 9ad0 <_Z13Guessing_Gamec+0x314>
    98f4:	e5933000 	ldr	r3, [r3]
    98f8:	e2433001 	sub	r3, r3, #1
    98fc:	e59f21c4 	ldr	r2, [pc, #452]	; 9ac8 <_Z13Guessing_Gamec+0x30c>
    9900:	e5823000 	str	r3, [r2]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:48
                greater = false;
    9904:	e3a03000 	mov	r3, #0
    9908:	e54b3005 	strb	r3, [fp, #-5]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:51
            }

            if (min_num > max_num)
    990c:	e59f31b8 	ldr	r3, [pc, #440]	; 9acc <_Z13Guessing_Gamec+0x310>
    9910:	e5932000 	ldr	r2, [r3]
    9914:	e59f31ac 	ldr	r3, [pc, #428]	; 9ac8 <_Z13Guessing_Gamec+0x30c>
    9918:	e5933000 	ldr	r3, [r3]
    991c:	e1520003 	cmp	r2, r3
    9920:	c3a03001 	movgt	r3, #1
    9924:	d3a03000 	movle	r3, #0
    9928:	e6ef3073 	uxtb	r3, r3
    992c:	e3530000 	cmp	r3, #0
    9930:	0a000011 	beq	997c <_Z13Guessing_Gamec+0x1c0>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:53
            {
                sUART0.Write("The number you're thinking of must be ");
    9934:	e59f119c 	ldr	r1, [pc, #412]	; 9ad8 <_Z13Guessing_Gamec+0x31c>
    9938:	e59f017c 	ldr	r0, [pc, #380]	; 9abc <_Z13Guessing_Gamec+0x300>
    993c:	ebfffeda 	bl	94ac <_ZN5CUART5WriteEPKc>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:54
                sUART0.Write(min_num);
    9940:	e59f3184 	ldr	r3, [pc, #388]	; 9acc <_Z13Guessing_Gamec+0x310>
    9944:	e5933000 	ldr	r3, [r3]
    9948:	e1a01003 	mov	r1, r3
    994c:	e59f0168 	ldr	r0, [pc, #360]	; 9abc <_Z13Guessing_Gamec+0x300>
    9950:	ebffff1a 	bl	95c0 <_ZN5CUART5WriteEi>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:55
                sUART0.Write("!\n\r");
    9954:	e59f1180 	ldr	r1, [pc, #384]	; 9adc <_Z13Guessing_Gamec+0x320>
    9958:	e59f015c 	ldr	r0, [pc, #348]	; 9abc <_Z13Guessing_Gamec+0x300>
    995c:	ebfffed2 	bl	94ac <_ZN5CUART5WriteEPKc>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:56
                sUART0.Write("Do you wanna play again? [y/n]: ");
    9960:	e59f1178 	ldr	r1, [pc, #376]	; 9ae0 <_Z13Guessing_Gamec+0x324>
    9964:	e59f0150 	ldr	r0, [pc, #336]	; 9abc <_Z13Guessing_Gamec+0x300>
    9968:	ebfffecf 	bl	94ac <_ZN5CUART5WriteEPKc>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:57
                game_state = 3;
    996c:	e59f3140 	ldr	r3, [pc, #320]	; 9ab4 <_Z13Guessing_Gamec+0x2f8>
    9970:	e3a02003 	mov	r2, #3
    9974:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:58
                break;
    9978:	ea00004a 	b	9aa8 <_Z13Guessing_Gamec+0x2ec>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:61
            }

            middle = min_num + (max_num - min_num) / 2;
    997c:	e59f3144 	ldr	r3, [pc, #324]	; 9ac8 <_Z13Guessing_Gamec+0x30c>
    9980:	e5932000 	ldr	r2, [r3]
    9984:	e59f3140 	ldr	r3, [pc, #320]	; 9acc <_Z13Guessing_Gamec+0x310>
    9988:	e5933000 	ldr	r3, [r3]
    998c:	e0423003 	sub	r3, r2, r3
    9990:	e1a02fa3 	lsr	r2, r3, #31
    9994:	e0823003 	add	r3, r2, r3
    9998:	e1a030c3 	asr	r3, r3, #1
    999c:	e1a02003 	mov	r2, r3
    99a0:	e59f3124 	ldr	r3, [pc, #292]	; 9acc <_Z13Guessing_Gamec+0x310>
    99a4:	e5933000 	ldr	r3, [r3]
    99a8:	e0823003 	add	r3, r2, r3
    99ac:	e59f211c 	ldr	r2, [pc, #284]	; 9ad0 <_Z13Guessing_Gamec+0x314>
    99b0:	e5823000 	str	r3, [r2]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:62
            sUART0.Write("Is your number greater than ");
    99b4:	e59f1108 	ldr	r1, [pc, #264]	; 9ac4 <_Z13Guessing_Gamec+0x308>
    99b8:	e59f00fc 	ldr	r0, [pc, #252]	; 9abc <_Z13Guessing_Gamec+0x300>
    99bc:	ebfffeba 	bl	94ac <_ZN5CUART5WriteEPKc>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:63
            sUART0.Write(middle);
    99c0:	e59f3108 	ldr	r3, [pc, #264]	; 9ad0 <_Z13Guessing_Gamec+0x314>
    99c4:	e5933000 	ldr	r3, [r3]
    99c8:	e1a01003 	mov	r1, r3
    99cc:	e59f00e8 	ldr	r0, [pc, #232]	; 9abc <_Z13Guessing_Gamec+0x300>
    99d0:	ebfffefa 	bl	95c0 <_ZN5CUART5WriteEi>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:64
            sUART0.Write("? [y/n]: ");
    99d4:	e59f10f8 	ldr	r1, [pc, #248]	; 9ad4 <_Z13Guessing_Gamec+0x318>
    99d8:	e59f00dc 	ldr	r0, [pc, #220]	; 9abc <_Z13Guessing_Gamec+0x300>
    99dc:	ebfffeb2 	bl	94ac <_ZN5CUART5WriteEPKc>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:66

            break;
    99e0:	ea000030 	b	9aa8 <_Z13Guessing_Gamec+0x2ec>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:69

        case 3:
            if (c == 'y' || c == 'Y')
    99e4:	e55b300d 	ldrb	r3, [fp, #-13]
    99e8:	e3530079 	cmp	r3, #121	; 0x79
    99ec:	0a000002 	beq	99fc <_Z13Guessing_Gamec+0x240>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:69 (discriminator 1)
    99f0:	e55b300d 	ldrb	r3, [fp, #-13]
    99f4:	e3530059 	cmp	r3, #89	; 0x59
    99f8:	1a000022 	bne	9a88 <_Z13Guessing_Gamec+0x2cc>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:71
            {
                min_num = 0;
    99fc:	e59f30c8 	ldr	r3, [pc, #200]	; 9acc <_Z13Guessing_Gamec+0x310>
    9a00:	e3a02000 	mov	r2, #0
    9a04:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:72
                max_num = 100;
    9a08:	e59f30b8 	ldr	r3, [pc, #184]	; 9ac8 <_Z13Guessing_Gamec+0x30c>
    9a0c:	e3a02064 	mov	r2, #100	; 0x64
    9a10:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:74

                sUART0.Write("Is your number greater than ");
    9a14:	e59f10a8 	ldr	r1, [pc, #168]	; 9ac4 <_Z13Guessing_Gamec+0x308>
    9a18:	e59f009c 	ldr	r0, [pc, #156]	; 9abc <_Z13Guessing_Gamec+0x300>
    9a1c:	ebfffea2 	bl	94ac <_ZN5CUART5WriteEPKc>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:75
                middle = min_num + (max_num - min_num) / 2;
    9a20:	e59f30a0 	ldr	r3, [pc, #160]	; 9ac8 <_Z13Guessing_Gamec+0x30c>
    9a24:	e5932000 	ldr	r2, [r3]
    9a28:	e59f309c 	ldr	r3, [pc, #156]	; 9acc <_Z13Guessing_Gamec+0x310>
    9a2c:	e5933000 	ldr	r3, [r3]
    9a30:	e0423003 	sub	r3, r2, r3
    9a34:	e1a02fa3 	lsr	r2, r3, #31
    9a38:	e0823003 	add	r3, r2, r3
    9a3c:	e1a030c3 	asr	r3, r3, #1
    9a40:	e1a02003 	mov	r2, r3
    9a44:	e59f3080 	ldr	r3, [pc, #128]	; 9acc <_Z13Guessing_Gamec+0x310>
    9a48:	e5933000 	ldr	r3, [r3]
    9a4c:	e0823003 	add	r3, r2, r3
    9a50:	e59f2078 	ldr	r2, [pc, #120]	; 9ad0 <_Z13Guessing_Gamec+0x314>
    9a54:	e5823000 	str	r3, [r2]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:76
                sUART0.Write(middle);
    9a58:	e59f3070 	ldr	r3, [pc, #112]	; 9ad0 <_Z13Guessing_Gamec+0x314>
    9a5c:	e5933000 	ldr	r3, [r3]
    9a60:	e1a01003 	mov	r1, r3
    9a64:	e59f0050 	ldr	r0, [pc, #80]	; 9abc <_Z13Guessing_Gamec+0x300>
    9a68:	ebfffed4 	bl	95c0 <_ZN5CUART5WriteEi>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:77
                sUART0.Write("? [y/n]: ");
    9a6c:	e59f1060 	ldr	r1, [pc, #96]	; 9ad4 <_Z13Guessing_Gamec+0x318>
    9a70:	e59f0044 	ldr	r0, [pc, #68]	; 9abc <_Z13Guessing_Gamec+0x300>
    9a74:	ebfffe8c 	bl	94ac <_ZN5CUART5WriteEPKc>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:78
                game_state = 2;
    9a78:	e59f3034 	ldr	r3, [pc, #52]	; 9ab4 <_Z13Guessing_Gamec+0x2f8>
    9a7c:	e3a02002 	mov	r2, #2
    9a80:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:85
            else
            {
                sUART0.Write("See you next time!\n\r");
                game_state = 0xFFFFFFFFU;
            }
            break;
    9a84:	ea000007 	b	9aa8 <_Z13Guessing_Gamec+0x2ec>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:82
                sUART0.Write("See you next time!\n\r");
    9a88:	e59f1054 	ldr	r1, [pc, #84]	; 9ae4 <_Z13Guessing_Gamec+0x328>
    9a8c:	e59f0028 	ldr	r0, [pc, #40]	; 9abc <_Z13Guessing_Gamec+0x300>
    9a90:	ebfffe85 	bl	94ac <_ZN5CUART5WriteEPKc>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:83
                game_state = 0xFFFFFFFFU;
    9a94:	e59f3018 	ldr	r3, [pc, #24]	; 9ab4 <_Z13Guessing_Gamec+0x2f8>
    9a98:	e3e02000 	mvn	r2, #0
    9a9c:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:85
            break;
    9aa0:	ea000000 	b	9aa8 <_Z13Guessing_Gamec+0x2ec>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:88

        default:
            break;
    9aa4:	e320f000 	nop	{0}
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:90
    }
}
    9aa8:	e320f000 	nop	{0}
    9aac:	e24bd004 	sub	sp, fp, #4
    9ab0:	e8bd8800 	pop	{fp, pc}
    9ab4:	0000aac0 	andeq	sl, r0, r0, asr #21
    9ab8:	0000a830 	andeq	sl, r0, r0, lsr r8
    9abc:	0000aa9c 	muleq	r0, ip, sl
    9ac0:	0000a858 	andeq	sl, r0, r8, asr r8
    9ac4:	0000a8a0 	andeq	sl, r0, r0, lsr #17
    9ac8:	0000aa68 	andeq	sl, r0, r8, ror #20
    9acc:	0000aac4 	andeq	sl, r0, r4, asr #21
    9ad0:	0000aac8 	andeq	sl, r0, r8, asr #21
    9ad4:	0000a8c0 	andeq	sl, r0, r0, asr #17
    9ad8:	0000a8cc 	andeq	sl, r0, ip, asr #17
    9adc:	0000a8f4 	strdeq	sl, [r0], -r4
    9ae0:	0000a8f8 	strdeq	sl, [r0], -r8
    9ae4:	0000a91c 	andeq	sl, r0, ip, lsl r9

00009ae8 <software_interrupt_handler>:
software_interrupt_handler():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:93

extern "C" void __attribute__((interrupt("SWI"))) software_interrupt_handler()
{
    9ae8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9aec:	e28db000 	add	fp, sp, #0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:94
}
    9af0:	e320f000 	nop	{0}
    9af4:	e28bd000 	add	sp, fp, #0
    9af8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9afc:	e1b0f00e 	movs	pc, lr

00009b00 <irq_handler>:
irq_handler():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:97

extern "C" void __attribute__((interrupt("IRQ"))) irq_handler()
{
    9b00:	e24ee004 	sub	lr, lr, #4
    9b04:	e92d580f 	push	{r0, r1, r2, r3, fp, ip, lr}
    9b08:	e28db018 	add	fp, sp, #24
    9b0c:	e24dd00c 	sub	sp, sp, #12
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:100
    char c;

    sUART0.Read(&c);
    9b10:	e24b301d 	sub	r3, fp, #29
    9b14:	e1a01003 	mov	r1, r3
    9b18:	e59f0034 	ldr	r0, [pc, #52]	; 9b54 <irq_handler+0x54>
    9b1c:	ebfffec3 	bl	9630 <_ZN5CUART4ReadEPc>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:101
    if (c == '\n' || c == '\r')
    9b20:	e55b301d 	ldrb	r3, [fp, #-29]	; 0xffffffe3
    9b24:	e353000a 	cmp	r3, #10
    9b28:	0a000006 	beq	9b48 <irq_handler+0x48>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:101 (discriminator 1)
    9b2c:	e55b301d 	ldrb	r3, [fp, #-29]	; 0xffffffe3
    9b30:	e353000d 	cmp	r3, #13
    9b34:	0a000003 	beq	9b48 <irq_handler+0x48>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:104
        return;

    Guessing_Game(c);
    9b38:	e55b301d 	ldrb	r3, [fp, #-29]	; 0xffffffe3
    9b3c:	e1a00003 	mov	r0, r3
    9b40:	ebffff1d 	bl	97bc <_Z13Guessing_Gamec>
    9b44:	ea000000 	b	9b4c <irq_handler+0x4c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:102
        return;
    9b48:	e320f000 	nop	{0}
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:105
}
    9b4c:	e24bd018 	sub	sp, fp, #24
    9b50:	e8fd980f 	ldm	sp!, {r0, r1, r2, r3, fp, ip, pc}^
    9b54:	0000aa9c 	muleq	r0, ip, sl

00009b58 <fast_interrupt_handler>:
fast_interrupt_handler():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:108

extern "C" void __attribute__((interrupt("FIQ"))) fast_interrupt_handler()
{
    9b58:	e24db004 	sub	fp, sp, #4
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:109
}
    9b5c:	e320f000 	nop	{0}
    9b60:	e28bd004 	add	sp, fp, #4
    9b64:	e25ef004 	subs	pc, lr, #4

00009b68 <_ZN21CInterrupt_ControllerC1Em>:
_ZN21CInterrupt_ControllerC2Em():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:113

CInterrupt_Controller sInterruptCtl(hal::Interrupt_Controller_Base);

CInterrupt_Controller::CInterrupt_Controller(unsigned long base)
    9b68:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9b6c:	e28db000 	add	fp, sp, #0
    9b70:	e24dd00c 	sub	sp, sp, #12
    9b74:	e50b0008 	str	r0, [fp, #-8]
    9b78:	e50b100c 	str	r1, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:114
: mInterrupt_Regs(reinterpret_cast<unsigned int*>(base))
    9b7c:	e51b200c 	ldr	r2, [fp, #-12]
    9b80:	e51b3008 	ldr	r3, [fp, #-8]
    9b84:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:116
{
}
    9b88:	e51b3008 	ldr	r3, [fp, #-8]
    9b8c:	e1a00003 	mov	r0, r3
    9b90:	e28bd000 	add	sp, fp, #0
    9b94:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9b98:	e12fff1e 	bx	lr

00009b9c <_ZN21CInterrupt_Controller4RegsEN3hal24Interrupt_Controller_RegE>:
_ZN21CInterrupt_Controller4RegsEN3hal24Interrupt_Controller_RegE():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:119

volatile unsigned int& CInterrupt_Controller::Regs(hal::Interrupt_Controller_Reg reg)
{
    9b9c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9ba0:	e28db000 	add	fp, sp, #0
    9ba4:	e24dd00c 	sub	sp, sp, #12
    9ba8:	e50b0008 	str	r0, [fp, #-8]
    9bac:	e50b100c 	str	r1, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:120
    return mInterrupt_Regs[static_cast<unsigned int>(reg)];
    9bb0:	e51b3008 	ldr	r3, [fp, #-8]
    9bb4:	e5932000 	ldr	r2, [r3]
    9bb8:	e51b300c 	ldr	r3, [fp, #-12]
    9bbc:	e1a03103 	lsl	r3, r3, #2
    9bc0:	e0823003 	add	r3, r2, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:121
}
    9bc4:	e1a00003 	mov	r0, r3
    9bc8:	e28bd000 	add	sp, fp, #0
    9bcc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9bd0:	e12fff1e 	bx	lr

00009bd4 <_ZN21CInterrupt_Controller16Enable_Basic_IRQEN3hal16IRQ_Basic_SourceE>:
_ZN21CInterrupt_Controller16Enable_Basic_IRQEN3hal16IRQ_Basic_SourceE():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:124

void CInterrupt_Controller::Enable_Basic_IRQ(hal::IRQ_Basic_Source source_idx)
{
    9bd4:	e92d4810 	push	{r4, fp, lr}
    9bd8:	e28db008 	add	fp, sp, #8
    9bdc:	e24dd00c 	sub	sp, sp, #12
    9be0:	e50b0010 	str	r0, [fp, #-16]
    9be4:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:125
    Regs(hal::Interrupt_Controller_Reg::IRQ_Basic_Enable) = (1 << static_cast<unsigned int>(source_idx));
    9be8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9bec:	e3a02001 	mov	r2, #1
    9bf0:	e1a04312 	lsl	r4, r2, r3
    9bf4:	e3a01006 	mov	r1, #6
    9bf8:	e51b0010 	ldr	r0, [fp, #-16]
    9bfc:	ebffffe6 	bl	9b9c <_ZN21CInterrupt_Controller4RegsEN3hal24Interrupt_Controller_RegE>
    9c00:	e1a03000 	mov	r3, r0
    9c04:	e1a02004 	mov	r2, r4
    9c08:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:126
}
    9c0c:	e320f000 	nop	{0}
    9c10:	e24bd008 	sub	sp, fp, #8
    9c14:	e8bd8810 	pop	{r4, fp, pc}

00009c18 <_ZN21CInterrupt_Controller17Disable_Basic_IRQEN3hal16IRQ_Basic_SourceE>:
_ZN21CInterrupt_Controller17Disable_Basic_IRQEN3hal16IRQ_Basic_SourceE():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:129

void CInterrupt_Controller::Disable_Basic_IRQ(hal::IRQ_Basic_Source source_idx)
{
    9c18:	e92d4810 	push	{r4, fp, lr}
    9c1c:	e28db008 	add	fp, sp, #8
    9c20:	e24dd00c 	sub	sp, sp, #12
    9c24:	e50b0010 	str	r0, [fp, #-16]
    9c28:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:130
    Regs(hal::Interrupt_Controller_Reg::IRQ_Basic_Disable) = (1 << static_cast<unsigned int>(source_idx));
    9c2c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9c30:	e3a02001 	mov	r2, #1
    9c34:	e1a04312 	lsl	r4, r2, r3
    9c38:	e3a01009 	mov	r1, #9
    9c3c:	e51b0010 	ldr	r0, [fp, #-16]
    9c40:	ebffffd5 	bl	9b9c <_ZN21CInterrupt_Controller4RegsEN3hal24Interrupt_Controller_RegE>
    9c44:	e1a03000 	mov	r3, r0
    9c48:	e1a02004 	mov	r2, r4
    9c4c:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:131
}
    9c50:	e320f000 	nop	{0}
    9c54:	e24bd008 	sub	sp, fp, #8
    9c58:	e8bd8810 	pop	{r4, fp, pc}

00009c5c <_ZN21CInterrupt_Controller10Enable_IRQEN3hal10IRQ_SourceE>:
_ZN21CInterrupt_Controller10Enable_IRQEN3hal10IRQ_SourceE():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:134

void CInterrupt_Controller::Enable_IRQ(hal::IRQ_Source source_idx)
{
    9c5c:	e92d4810 	push	{r4, fp, lr}
    9c60:	e28db008 	add	fp, sp, #8
    9c64:	e24dd014 	sub	sp, sp, #20
    9c68:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    9c6c:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:135
    const unsigned int idx_base = static_cast<unsigned int>(source_idx);
    9c70:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    9c74:	e50b3010 	str	r3, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:138

    Regs(idx_base < 32 ? hal::Interrupt_Controller_Reg::IRQ_Enable_1 : hal::Interrupt_Controller_Reg::IRQ_Enable_2) =
    (1 << (idx_base % 32));
    9c78:	e51b3010 	ldr	r3, [fp, #-16]
    9c7c:	e203301f 	and	r3, r3, #31
    9c80:	e3a02001 	mov	r2, #1
    9c84:	e1a04312 	lsl	r4, r2, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:137
    Regs(idx_base < 32 ? hal::Interrupt_Controller_Reg::IRQ_Enable_1 : hal::Interrupt_Controller_Reg::IRQ_Enable_2) =
    9c88:	e51b3010 	ldr	r3, [fp, #-16]
    9c8c:	e353001f 	cmp	r3, #31
    9c90:	8a000001 	bhi	9c9c <_ZN21CInterrupt_Controller10Enable_IRQEN3hal10IRQ_SourceE+0x40>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:137 (discriminator 1)
    9c94:	e3a03004 	mov	r3, #4
    9c98:	ea000000 	b	9ca0 <_ZN21CInterrupt_Controller10Enable_IRQEN3hal10IRQ_SourceE+0x44>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:137 (discriminator 2)
    9c9c:	e3a03005 	mov	r3, #5
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:137 (discriminator 4)
    9ca0:	e1a01003 	mov	r1, r3
    9ca4:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    9ca8:	ebffffbb 	bl	9b9c <_ZN21CInterrupt_Controller4RegsEN3hal24Interrupt_Controller_RegE>
    9cac:	e1a03000 	mov	r3, r0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:138 (discriminator 4)
    (1 << (idx_base % 32));
    9cb0:	e1a02004 	mov	r2, r4
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:137 (discriminator 4)
    Regs(idx_base < 32 ? hal::Interrupt_Controller_Reg::IRQ_Enable_1 : hal::Interrupt_Controller_Reg::IRQ_Enable_2) =
    9cb4:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:139 (discriminator 4)
}
    9cb8:	e320f000 	nop	{0}
    9cbc:	e24bd008 	sub	sp, fp, #8
    9cc0:	e8bd8810 	pop	{r4, fp, pc}

00009cc4 <_ZN21CInterrupt_Controller11Disable_IRQEN3hal10IRQ_SourceE>:
_ZN21CInterrupt_Controller11Disable_IRQEN3hal10IRQ_SourceE():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:142

void CInterrupt_Controller::Disable_IRQ(hal::IRQ_Source source_idx)
{
    9cc4:	e92d4810 	push	{r4, fp, lr}
    9cc8:	e28db008 	add	fp, sp, #8
    9ccc:	e24dd014 	sub	sp, sp, #20
    9cd0:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    9cd4:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:143
    const unsigned int idx_base = static_cast<unsigned int>(source_idx);
    9cd8:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    9cdc:	e50b3010 	str	r3, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:146

    Regs(idx_base < 32 ? hal::Interrupt_Controller_Reg::IRQ_Disable_1 : hal::Interrupt_Controller_Reg::IRQ_Disable_2) =
    (1 << (idx_base % 32));
    9ce0:	e51b3010 	ldr	r3, [fp, #-16]
    9ce4:	e203301f 	and	r3, r3, #31
    9ce8:	e3a02001 	mov	r2, #1
    9cec:	e1a04312 	lsl	r4, r2, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:145
    Regs(idx_base < 32 ? hal::Interrupt_Controller_Reg::IRQ_Disable_1 : hal::Interrupt_Controller_Reg::IRQ_Disable_2) =
    9cf0:	e51b3010 	ldr	r3, [fp, #-16]
    9cf4:	e353001f 	cmp	r3, #31
    9cf8:	8a000001 	bhi	9d04 <_ZN21CInterrupt_Controller11Disable_IRQEN3hal10IRQ_SourceE+0x40>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:145 (discriminator 1)
    9cfc:	e3a03007 	mov	r3, #7
    9d00:	ea000000 	b	9d08 <_ZN21CInterrupt_Controller11Disable_IRQEN3hal10IRQ_SourceE+0x44>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:145 (discriminator 2)
    9d04:	e3a03008 	mov	r3, #8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:145 (discriminator 4)
    9d08:	e1a01003 	mov	r1, r3
    9d0c:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    9d10:	ebffffa1 	bl	9b9c <_ZN21CInterrupt_Controller4RegsEN3hal24Interrupt_Controller_RegE>
    9d14:	e1a03000 	mov	r3, r0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:146 (discriminator 4)
    (1 << (idx_base % 32));
    9d18:	e1a02004 	mov	r2, r4
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:145 (discriminator 4)
    Regs(idx_base < 32 ? hal::Interrupt_Controller_Reg::IRQ_Disable_1 : hal::Interrupt_Controller_Reg::IRQ_Disable_2) =
    9d1c:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:147 (discriminator 4)
}
    9d20:	e320f000 	nop	{0}
    9d24:	e24bd008 	sub	sp, fp, #8
    9d28:	e8bd8810 	pop	{r4, fp, pc}

00009d2c <_Z41__static_initialization_and_destruction_0ii>:
_Z41__static_initialization_and_destruction_0ii():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:147
    9d2c:	e92d4800 	push	{fp, lr}
    9d30:	e28db004 	add	fp, sp, #4
    9d34:	e24dd008 	sub	sp, sp, #8
    9d38:	e50b0008 	str	r0, [fp, #-8]
    9d3c:	e50b100c 	str	r1, [fp, #-12]
    9d40:	e51b3008 	ldr	r3, [fp, #-8]
    9d44:	e3530001 	cmp	r3, #1
    9d48:	1a000006 	bne	9d68 <_Z41__static_initialization_and_destruction_0ii+0x3c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:147 (discriminator 1)
    9d4c:	e51b300c 	ldr	r3, [fp, #-12]
    9d50:	e59f201c 	ldr	r2, [pc, #28]	; 9d74 <_Z41__static_initialization_and_destruction_0ii+0x48>
    9d54:	e1530002 	cmp	r3, r2
    9d58:	1a000002 	bne	9d68 <_Z41__static_initialization_and_destruction_0ii+0x3c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:111
CInterrupt_Controller sInterruptCtl(hal::Interrupt_Controller_Base);
    9d5c:	e59f1014 	ldr	r1, [pc, #20]	; 9d78 <_Z41__static_initialization_and_destruction_0ii+0x4c>
    9d60:	e59f0014 	ldr	r0, [pc, #20]	; 9d7c <_Z41__static_initialization_and_destruction_0ii+0x50>
    9d64:	ebffff7f 	bl	9b68 <_ZN21CInterrupt_ControllerC1Em>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:147
}
    9d68:	e320f000 	nop	{0}
    9d6c:	e24bd004 	sub	sp, fp, #4
    9d70:	e8bd8800 	pop	{fp, pc}
    9d74:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>
    9d78:	2000b200 	andcs	fp, r0, r0, lsl #4
    9d7c:	0000aacc 	andeq	sl, r0, ip, asr #21

00009d80 <_GLOBAL__sub_I_game_state>:
_GLOBAL__sub_I_game_state():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:147
    9d80:	e92d4800 	push	{fp, lr}
    9d84:	e28db004 	add	fp, sp, #4
    9d88:	e59f1008 	ldr	r1, [pc, #8]	; 9d98 <_GLOBAL__sub_I_game_state+0x18>
    9d8c:	e3a00001 	mov	r0, #1
    9d90:	ebffffe5 	bl	9d2c <_Z41__static_initialization_and_destruction_0ii>
    9d94:	e8bd8800 	pop	{fp, pc}
    9d98:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>

00009d9c <_kernel_main>:
_kernel_main():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/main.cpp:6
#include <drivers/gpio.h>
#include <drivers/uart.h>
#include <interrupt_controller.h>

extern "C" int _kernel_main(void)
{
    9d9c:	e92d4800 	push	{fp, lr}
    9da0:	e28db004 	add	fp, sp, #4
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/main.cpp:7
    sInterruptCtl.Enable_IRQ(hal::IRQ_Source::AUX);
    9da4:	e3a0101d 	mov	r1, #29
    9da8:	e59f004c 	ldr	r0, [pc, #76]	; 9dfc <_kernel_main+0x60>
    9dac:	ebffffaa 	bl	9c5c <_ZN21CInterrupt_Controller10Enable_IRQEN3hal10IRQ_SourceE>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/main.cpp:9

    sUART0.Set_Baud_Rate(NUART_Baud_Rate::BR_115200);
    9db0:	e59f1048 	ldr	r1, [pc, #72]	; 9e00 <_kernel_main+0x64>
    9db4:	e59f0048 	ldr	r0, [pc, #72]	; 9e04 <_kernel_main+0x68>
    9db8:	ebfffd79 	bl	93a4 <_ZN5CUART13Set_Baud_RateE15NUART_Baud_Rate>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/main.cpp:10
    sUART0.Set_Char_Length(NUART_Char_Length::Char_8);
    9dbc:	e3a01001 	mov	r1, #1
    9dc0:	e59f003c 	ldr	r0, [pc, #60]	; 9e04 <_kernel_main+0x68>
    9dc4:	ebfffd5f 	bl	9348 <_ZN5CUART15Set_Char_LengthE17NUART_Char_Length>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/main.cpp:12

    sUART0.Enable_Receive_Int();
    9dc8:	e59f0034 	ldr	r0, [pc, #52]	; 9e04 <_kernel_main+0x68>
    9dcc:	ebfffe36 	bl	96ac <_ZN5CUART18Enable_Receive_IntEv>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/main.cpp:14

    enable_irq();
    9dd0:	eb00000f 	bl	9e14 <enable_irq>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/main.cpp:16

    sUART0.Write("Welcome to a guessing game!\r\n");
    9dd4:	e59f102c 	ldr	r1, [pc, #44]	; 9e08 <_kernel_main+0x6c>
    9dd8:	e59f0024 	ldr	r0, [pc, #36]	; 9e04 <_kernel_main+0x68>
    9ddc:	ebfffdb2 	bl	94ac <_ZN5CUART5WriteEPKc>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/main.cpp:17
    sUART0.Write("---------------------------\r\n");
    9de0:	e59f1024 	ldr	r1, [pc, #36]	; 9e0c <_kernel_main+0x70>
    9de4:	e59f0018 	ldr	r0, [pc, #24]	; 9e04 <_kernel_main+0x68>
    9de8:	ebfffdaf 	bl	94ac <_ZN5CUART5WriteEPKc>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/main.cpp:18
    sUART0.Write("Think of a number between 0 and 100 and I'm gonna guess what it is. All you gotta do is to tell me "
    9dec:	e59f101c 	ldr	r1, [pc, #28]	; 9e10 <_kernel_main+0x74>
    9df0:	e59f000c 	ldr	r0, [pc, #12]	; 9e04 <_kernel_main+0x68>
    9df4:	ebfffdac 	bl	94ac <_ZN5CUART5WriteEPKc>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/main.cpp:21 (discriminator 1)
                 "whether my guess is larger than your number of choice or not, okay? [y/n]: ");

    while (1)
    9df8:	eafffffe 	b	9df8 <_kernel_main+0x5c>
    9dfc:	0000aacc 	andeq	sl, r0, ip, asr #21
    9e00:	0001c200 	andeq	ip, r1, r0, lsl #4
    9e04:	0000aa9c 	muleq	r0, ip, sl
    9e08:	0000a950 	andeq	sl, r0, r0, asr r9
    9e0c:	0000a970 	andeq	sl, r0, r0, ror r9
    9e10:	0000a990 	muleq	r0, r0, r9

00009e14 <enable_irq>:
enable_irq():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/start.s:90
;@ tady budou ostatni symboly, ktere nevyzaduji zadne specialni misto
.section .text

.global enable_irq
enable_irq:
    mrs r0, cpsr		;@ presun ridiciho registru (CPSR) do general purpose registru (R0)
    9e14:	e10f0000 	mrs	r0, CPSR
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/start.s:91
    bic r0, r0, #0x80	;@ vypne bit 7 v registru r0 ("IRQ mask bit")
    9e18:	e3c00080 	bic	r0, r0, #128	; 0x80
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/start.s:92
    msr cpsr_c, r0		;@ nacteme upraveny general purpose (R0) registr do ridiciho (CPSR)
    9e1c:	e121f000 	msr	CPSR_c, r0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/start.s:93
    cpsie i				;@ povoli preruseni
    9e20:	f1080080 	cpsie	i
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/start.s:94
    bx lr
    9e24:	e12fff1e 	bx	lr

00009e28 <undefined_instruction_handler>:
undefined_instruction_handler():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/start.s:97

undefined_instruction_handler:
	b hang
    9e28:	eafff898 	b	8090 <hang>

00009e2c <prefetch_abort_handler>:
prefetch_abort_handler():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/start.s:102

prefetch_abort_handler:
	;@ tady pak muzeme osetrit, kdyz program zasahne do mista, ktere nema mapovane ve svem virtualnim adr. prostoru
	;@ a treba vyvolat nasi obdobu segfaultu
	b hang
    9e2c:	eafff897 	b	8090 <hang>

00009e30 <data_abort_handler>:
data_abort_handler():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/start.s:107

data_abort_handler:
	;@ tady pak muzeme osetrit, kdyz program zasahne do mista, ktere nema mapovane ve svem virtualnim adr. prostoru
	;@ a treba vyvolat nasi obdobu segfaultu
	b hang
    9e30:	eafff896 	b	8090 <hang>

00009e34 <_c_startup>:
_c_startup():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/startup.cpp:21
extern "C" dtor_ptr __DTOR_LIST__[0];
// konec pole destruktoru
extern "C" dtor_ptr __DTOR_END__[0];

extern "C" int _c_startup(void)
{
    9e34:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9e38:	e28db000 	add	fp, sp, #0
    9e3c:	e24dd00c 	sub	sp, sp, #12
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/startup.cpp:25
    int* i;

    // vynulujeme .bss sekci
    for (i = (int*)_bss_start; i < (int*)_bss_end; i++)
    9e40:	e59f304c 	ldr	r3, [pc, #76]	; 9e94 <_c_startup+0x60>
    9e44:	e5933000 	ldr	r3, [r3]
    9e48:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/startup.cpp:25 (discriminator 3)
    9e4c:	e59f3044 	ldr	r3, [pc, #68]	; 9e98 <_c_startup+0x64>
    9e50:	e5933000 	ldr	r3, [r3]
    9e54:	e1a02003 	mov	r2, r3
    9e58:	e51b3008 	ldr	r3, [fp, #-8]
    9e5c:	e1530002 	cmp	r3, r2
    9e60:	2a000006 	bcs	9e80 <_c_startup+0x4c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/startup.cpp:26 (discriminator 2)
        *i = 0;
    9e64:	e51b3008 	ldr	r3, [fp, #-8]
    9e68:	e3a02000 	mov	r2, #0
    9e6c:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/startup.cpp:25 (discriminator 2)
    for (i = (int*)_bss_start; i < (int*)_bss_end; i++)
    9e70:	e51b3008 	ldr	r3, [fp, #-8]
    9e74:	e2833004 	add	r3, r3, #4
    9e78:	e50b3008 	str	r3, [fp, #-8]
    9e7c:	eafffff2 	b	9e4c <_c_startup+0x18>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/startup.cpp:28

    return 0;
    9e80:	e3a03000 	mov	r3, #0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/startup.cpp:29
}
    9e84:	e1a00003 	mov	r0, r3
    9e88:	e28bd000 	add	sp, fp, #0
    9e8c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9e90:	e12fff1e 	bx	lr
    9e94:	0000aa6c 	andeq	sl, r0, ip, ror #20
    9e98:	0000aae0 	andeq	sl, r0, r0, ror #21

00009e9c <_cpp_startup>:
_cpp_startup():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/startup.cpp:32

extern "C" int _cpp_startup(void)
{
    9e9c:	e92d4800 	push	{fp, lr}
    9ea0:	e28db004 	add	fp, sp, #4
    9ea4:	e24dd008 	sub	sp, sp, #8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/startup.cpp:37
    ctor_ptr* fnptr;

    // zavolame konstruktory globalnich C++ trid
    // v poli __CTOR_LIST__ jsou ukazatele na vygenerovane stuby volani konstruktoru
    for (fnptr = __CTOR_LIST__; fnptr < __CTOR_END__; fnptr++)
    9ea8:	e59f303c 	ldr	r3, [pc, #60]	; 9eec <_cpp_startup+0x50>
    9eac:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/startup.cpp:37 (discriminator 3)
    9eb0:	e51b3008 	ldr	r3, [fp, #-8]
    9eb4:	e59f2034 	ldr	r2, [pc, #52]	; 9ef0 <_cpp_startup+0x54>
    9eb8:	e1530002 	cmp	r3, r2
    9ebc:	2a000006 	bcs	9edc <_cpp_startup+0x40>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/startup.cpp:38 (discriminator 2)
        (*fnptr)();
    9ec0:	e51b3008 	ldr	r3, [fp, #-8]
    9ec4:	e5933000 	ldr	r3, [r3]
    9ec8:	e12fff33 	blx	r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/startup.cpp:37 (discriminator 2)
    for (fnptr = __CTOR_LIST__; fnptr < __CTOR_END__; fnptr++)
    9ecc:	e51b3008 	ldr	r3, [fp, #-8]
    9ed0:	e2833004 	add	r3, r3, #4
    9ed4:	e50b3008 	str	r3, [fp, #-8]
    9ed8:	eafffff4 	b	9eb0 <_cpp_startup+0x14>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/startup.cpp:40

    return 0;
    9edc:	e3a03000 	mov	r3, #0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/startup.cpp:41
}
    9ee0:	e1a00003 	mov	r0, r3
    9ee4:	e24bd004 	sub	sp, fp, #4
    9ee8:	e8bd8800 	pop	{fp, pc}
    9eec:	0000aa54 	andeq	sl, r0, r4, asr sl
    9ef0:	0000aa68 	andeq	sl, r0, r8, ror #20

00009ef4 <_cpp_shutdown>:
_cpp_shutdown():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/startup.cpp:44

extern "C" int _cpp_shutdown(void)
{
    9ef4:	e92d4800 	push	{fp, lr}
    9ef8:	e28db004 	add	fp, sp, #4
    9efc:	e24dd008 	sub	sp, sp, #8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/startup.cpp:48
    dtor_ptr* fnptr;

    // zavolame destruktory globalnich C++ trid
    for (fnptr = __DTOR_LIST__; fnptr < __DTOR_END__; fnptr++)
    9f00:	e59f303c 	ldr	r3, [pc, #60]	; 9f44 <_cpp_shutdown+0x50>
    9f04:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/startup.cpp:48 (discriminator 3)
    9f08:	e51b3008 	ldr	r3, [fp, #-8]
    9f0c:	e59f2034 	ldr	r2, [pc, #52]	; 9f48 <_cpp_shutdown+0x54>
    9f10:	e1530002 	cmp	r3, r2
    9f14:	2a000006 	bcs	9f34 <_cpp_shutdown+0x40>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/startup.cpp:49 (discriminator 2)
        (*fnptr)();
    9f18:	e51b3008 	ldr	r3, [fp, #-8]
    9f1c:	e5933000 	ldr	r3, [r3]
    9f20:	e12fff33 	blx	r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/startup.cpp:48 (discriminator 2)
    for (fnptr = __DTOR_LIST__; fnptr < __DTOR_END__; fnptr++)
    9f24:	e51b3008 	ldr	r3, [fp, #-8]
    9f28:	e2833004 	add	r3, r3, #4
    9f2c:	e50b3008 	str	r3, [fp, #-8]
    9f30:	eafffff4 	b	9f08 <_cpp_shutdown+0x14>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/startup.cpp:51

    return 0;
    9f34:	e3a03000 	mov	r3, #0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/startup.cpp:52
}
    9f38:	e1a00003 	mov	r0, r3
    9f3c:	e24bd004 	sub	sp, fp, #4
    9f40:	e8bd8800 	pop	{fp, pc}
    9f44:	0000aa68 	andeq	sl, r0, r8, ror #20
    9f48:	0000aa68 	andeq	sl, r0, r8, ror #20

00009f4c <_Z4itoajPcj>:
_Z4itoajPcj():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:9
{
    const char CharConvArr[] = "0123456789ABCDEF";
}

void itoa(unsigned int input, char* output, unsigned int base)
{
    9f4c:	e92d4800 	push	{fp, lr}
    9f50:	e28db004 	add	fp, sp, #4
    9f54:	e24dd020 	sub	sp, sp, #32
    9f58:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    9f5c:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    9f60:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:10
    int i = 0;
    9f64:	e3a03000 	mov	r3, #0
    9f68:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:12

    while (input > 0)
    9f6c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9f70:	e3530000 	cmp	r3, #0
    9f74:	0a000014 	beq	9fcc <_Z4itoajPcj+0x80>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:14
    {
        output[i] = CharConvArr[input % base];
    9f78:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9f7c:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    9f80:	e1a00003 	mov	r0, r3
    9f84:	eb000199 	bl	a5f0 <__aeabi_uidivmod>
    9f88:	e1a03001 	mov	r3, r1
    9f8c:	e1a01003 	mov	r1, r3
    9f90:	e51b3008 	ldr	r3, [fp, #-8]
    9f94:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    9f98:	e0823003 	add	r3, r2, r3
    9f9c:	e59f2118 	ldr	r2, [pc, #280]	; a0bc <_Z4itoajPcj+0x170>
    9fa0:	e7d22001 	ldrb	r2, [r2, r1]
    9fa4:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:15
        input /= base;
    9fa8:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    9fac:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    9fb0:	eb000113 	bl	a404 <__udivsi3>
    9fb4:	e1a03000 	mov	r3, r0
    9fb8:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:16
        i++;
    9fbc:	e51b3008 	ldr	r3, [fp, #-8]
    9fc0:	e2833001 	add	r3, r3, #1
    9fc4:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:12
    while (input > 0)
    9fc8:	eaffffe7 	b	9f6c <_Z4itoajPcj+0x20>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:19
    }

    if (i == 0)
    9fcc:	e51b3008 	ldr	r3, [fp, #-8]
    9fd0:	e3530000 	cmp	r3, #0
    9fd4:	1a000007 	bne	9ff8 <_Z4itoajPcj+0xac>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:21
    {
        output[i] = CharConvArr[0];
    9fd8:	e51b3008 	ldr	r3, [fp, #-8]
    9fdc:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    9fe0:	e0823003 	add	r3, r2, r3
    9fe4:	e3a02030 	mov	r2, #48	; 0x30
    9fe8:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:22
        i++;
    9fec:	e51b3008 	ldr	r3, [fp, #-8]
    9ff0:	e2833001 	add	r3, r3, #1
    9ff4:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:25
    }

    output[i] = '\0';
    9ff8:	e51b3008 	ldr	r3, [fp, #-8]
    9ffc:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    a000:	e0823003 	add	r3, r2, r3
    a004:	e3a02000 	mov	r2, #0
    a008:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:26
    i--;
    a00c:	e51b3008 	ldr	r3, [fp, #-8]
    a010:	e2433001 	sub	r3, r3, #1
    a014:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:28

    for (int j = 0; j <= i / 2; j++)
    a018:	e3a03000 	mov	r3, #0
    a01c:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:28 (discriminator 3)
    a020:	e51b3008 	ldr	r3, [fp, #-8]
    a024:	e1a02fa3 	lsr	r2, r3, #31
    a028:	e0823003 	add	r3, r2, r3
    a02c:	e1a030c3 	asr	r3, r3, #1
    a030:	e1a02003 	mov	r2, r3
    a034:	e51b300c 	ldr	r3, [fp, #-12]
    a038:	e1530002 	cmp	r3, r2
    a03c:	ca00001b 	bgt	a0b0 <_Z4itoajPcj+0x164>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:30 (discriminator 2)
    {
        char c = output[i - j];
    a040:	e51b2008 	ldr	r2, [fp, #-8]
    a044:	e51b300c 	ldr	r3, [fp, #-12]
    a048:	e0423003 	sub	r3, r2, r3
    a04c:	e1a02003 	mov	r2, r3
    a050:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    a054:	e0833002 	add	r3, r3, r2
    a058:	e5d33000 	ldrb	r3, [r3]
    a05c:	e54b300d 	strb	r3, [fp, #-13]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:31 (discriminator 2)
        output[i - j] = output[j];
    a060:	e51b300c 	ldr	r3, [fp, #-12]
    a064:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    a068:	e0822003 	add	r2, r2, r3
    a06c:	e51b1008 	ldr	r1, [fp, #-8]
    a070:	e51b300c 	ldr	r3, [fp, #-12]
    a074:	e0413003 	sub	r3, r1, r3
    a078:	e1a01003 	mov	r1, r3
    a07c:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    a080:	e0833001 	add	r3, r3, r1
    a084:	e5d22000 	ldrb	r2, [r2]
    a088:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:32 (discriminator 2)
        output[j] = c;
    a08c:	e51b300c 	ldr	r3, [fp, #-12]
    a090:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    a094:	e0823003 	add	r3, r2, r3
    a098:	e55b200d 	ldrb	r2, [fp, #-13]
    a09c:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:28 (discriminator 2)
    for (int j = 0; j <= i / 2; j++)
    a0a0:	e51b300c 	ldr	r3, [fp, #-12]
    a0a4:	e2833001 	add	r3, r3, #1
    a0a8:	e50b300c 	str	r3, [fp, #-12]
    a0ac:	eaffffdb 	b	a020 <_Z4itoajPcj+0xd4>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:34
    }
}
    a0b0:	e320f000 	nop	{0}
    a0b4:	e24bd004 	sub	sp, fp, #4
    a0b8:	e8bd8800 	pop	{fp, pc}
    a0bc:	0000aa40 	andeq	sl, r0, r0, asr #20

0000a0c0 <_Z4atoiPKc>:
_Z4atoiPKc():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:37

int atoi(const char* input)
{
    a0c0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    a0c4:	e28db000 	add	fp, sp, #0
    a0c8:	e24dd014 	sub	sp, sp, #20
    a0cc:	e50b0010 	str	r0, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:38
    int output = 0;
    a0d0:	e3a03000 	mov	r3, #0
    a0d4:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:40

    while (*input != '\0')
    a0d8:	e51b3010 	ldr	r3, [fp, #-16]
    a0dc:	e5d33000 	ldrb	r3, [r3]
    a0e0:	e3530000 	cmp	r3, #0
    a0e4:	0a000017 	beq	a148 <_Z4atoiPKc+0x88>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:42
    {
        output *= 10;
    a0e8:	e51b2008 	ldr	r2, [fp, #-8]
    a0ec:	e1a03002 	mov	r3, r2
    a0f0:	e1a03103 	lsl	r3, r3, #2
    a0f4:	e0833002 	add	r3, r3, r2
    a0f8:	e1a03083 	lsl	r3, r3, #1
    a0fc:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:43
        if (*input > '9' || *input < '0')
    a100:	e51b3010 	ldr	r3, [fp, #-16]
    a104:	e5d33000 	ldrb	r3, [r3]
    a108:	e3530039 	cmp	r3, #57	; 0x39
    a10c:	8a00000d 	bhi	a148 <_Z4atoiPKc+0x88>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:43 (discriminator 1)
    a110:	e51b3010 	ldr	r3, [fp, #-16]
    a114:	e5d33000 	ldrb	r3, [r3]
    a118:	e353002f 	cmp	r3, #47	; 0x2f
    a11c:	9a000009 	bls	a148 <_Z4atoiPKc+0x88>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:46
            break;

        output += *input - '0';
    a120:	e51b3010 	ldr	r3, [fp, #-16]
    a124:	e5d33000 	ldrb	r3, [r3]
    a128:	e2433030 	sub	r3, r3, #48	; 0x30
    a12c:	e51b2008 	ldr	r2, [fp, #-8]
    a130:	e0823003 	add	r3, r2, r3
    a134:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:48

        input++;
    a138:	e51b3010 	ldr	r3, [fp, #-16]
    a13c:	e2833001 	add	r3, r3, #1
    a140:	e50b3010 	str	r3, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:40
    while (*input != '\0')
    a144:	eaffffe3 	b	a0d8 <_Z4atoiPKc+0x18>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:51
    }

    return output;
    a148:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:52
}
    a14c:	e1a00003 	mov	r0, r3
    a150:	e28bd000 	add	sp, fp, #0
    a154:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    a158:	e12fff1e 	bx	lr

0000a15c <_Z7strncpyPcPKci>:
_Z7strncpyPcPKci():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:55

char* strncpy(char* dest, const char* src, int num)
{
    a15c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    a160:	e28db000 	add	fp, sp, #0
    a164:	e24dd01c 	sub	sp, sp, #28
    a168:	e50b0010 	str	r0, [fp, #-16]
    a16c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    a170:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:58
    int i;

    for (i = 0; i < num && src[i] != '\0'; i++)
    a174:	e3a03000 	mov	r3, #0
    a178:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:58 (discriminator 4)
    a17c:	e51b2008 	ldr	r2, [fp, #-8]
    a180:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    a184:	e1520003 	cmp	r2, r3
    a188:	aa000011 	bge	a1d4 <_Z7strncpyPcPKci+0x78>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:58 (discriminator 2)
    a18c:	e51b3008 	ldr	r3, [fp, #-8]
    a190:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    a194:	e0823003 	add	r3, r2, r3
    a198:	e5d33000 	ldrb	r3, [r3]
    a19c:	e3530000 	cmp	r3, #0
    a1a0:	0a00000b 	beq	a1d4 <_Z7strncpyPcPKci+0x78>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:59 (discriminator 3)
        dest[i] = src[i];
    a1a4:	e51b3008 	ldr	r3, [fp, #-8]
    a1a8:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    a1ac:	e0822003 	add	r2, r2, r3
    a1b0:	e51b3008 	ldr	r3, [fp, #-8]
    a1b4:	e51b1010 	ldr	r1, [fp, #-16]
    a1b8:	e0813003 	add	r3, r1, r3
    a1bc:	e5d22000 	ldrb	r2, [r2]
    a1c0:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:58 (discriminator 3)
    for (i = 0; i < num && src[i] != '\0'; i++)
    a1c4:	e51b3008 	ldr	r3, [fp, #-8]
    a1c8:	e2833001 	add	r3, r3, #1
    a1cc:	e50b3008 	str	r3, [fp, #-8]
    a1d0:	eaffffe9 	b	a17c <_Z7strncpyPcPKci+0x20>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:60 (discriminator 2)
    for (; i < num; i++)
    a1d4:	e51b2008 	ldr	r2, [fp, #-8]
    a1d8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    a1dc:	e1520003 	cmp	r2, r3
    a1e0:	aa000008 	bge	a208 <_Z7strncpyPcPKci+0xac>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:61 (discriminator 1)
        dest[i] = '\0';
    a1e4:	e51b3008 	ldr	r3, [fp, #-8]
    a1e8:	e51b2010 	ldr	r2, [fp, #-16]
    a1ec:	e0823003 	add	r3, r2, r3
    a1f0:	e3a02000 	mov	r2, #0
    a1f4:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:60 (discriminator 1)
    for (; i < num; i++)
    a1f8:	e51b3008 	ldr	r3, [fp, #-8]
    a1fc:	e2833001 	add	r3, r3, #1
    a200:	e50b3008 	str	r3, [fp, #-8]
    a204:	eafffff2 	b	a1d4 <_Z7strncpyPcPKci+0x78>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:63

    return dest;
    a208:	e51b3010 	ldr	r3, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:64
}
    a20c:	e1a00003 	mov	r0, r3
    a210:	e28bd000 	add	sp, fp, #0
    a214:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    a218:	e12fff1e 	bx	lr

0000a21c <_Z7strncmpPKcS0_i>:
_Z7strncmpPKcS0_i():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:67

int strncmp(const char* s1, const char* s2, int num)
{
    a21c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    a220:	e28db000 	add	fp, sp, #0
    a224:	e24dd01c 	sub	sp, sp, #28
    a228:	e50b0010 	str	r0, [fp, #-16]
    a22c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    a230:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:69
    unsigned char u1, u2;
    while (num-- > 0)
    a234:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    a238:	e2432001 	sub	r2, r3, #1
    a23c:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
    a240:	e3530000 	cmp	r3, #0
    a244:	c3a03001 	movgt	r3, #1
    a248:	d3a03000 	movle	r3, #0
    a24c:	e6ef3073 	uxtb	r3, r3
    a250:	e3530000 	cmp	r3, #0
    a254:	0a000016 	beq	a2b4 <_Z7strncmpPKcS0_i+0x98>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:71
    {
        u1 = (unsigned char)*s1++;
    a258:	e51b3010 	ldr	r3, [fp, #-16]
    a25c:	e2832001 	add	r2, r3, #1
    a260:	e50b2010 	str	r2, [fp, #-16]
    a264:	e5d33000 	ldrb	r3, [r3]
    a268:	e54b3005 	strb	r3, [fp, #-5]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:72
        u2 = (unsigned char)*s2++;
    a26c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    a270:	e2832001 	add	r2, r3, #1
    a274:	e50b2014 	str	r2, [fp, #-20]	; 0xffffffec
    a278:	e5d33000 	ldrb	r3, [r3]
    a27c:	e54b3006 	strb	r3, [fp, #-6]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:73
        if (u1 != u2)
    a280:	e55b2005 	ldrb	r2, [fp, #-5]
    a284:	e55b3006 	ldrb	r3, [fp, #-6]
    a288:	e1520003 	cmp	r2, r3
    a28c:	0a000003 	beq	a2a0 <_Z7strncmpPKcS0_i+0x84>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:74
            return u1 - u2;
    a290:	e55b2005 	ldrb	r2, [fp, #-5]
    a294:	e55b3006 	ldrb	r3, [fp, #-6]
    a298:	e0423003 	sub	r3, r2, r3
    a29c:	ea000005 	b	a2b8 <_Z7strncmpPKcS0_i+0x9c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:75
        if (u1 == '\0')
    a2a0:	e55b3005 	ldrb	r3, [fp, #-5]
    a2a4:	e3530000 	cmp	r3, #0
    a2a8:	1affffe1 	bne	a234 <_Z7strncmpPKcS0_i+0x18>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:76
            return 0;
    a2ac:	e3a03000 	mov	r3, #0
    a2b0:	ea000000 	b	a2b8 <_Z7strncmpPKcS0_i+0x9c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:79
    }

    return 0;
    a2b4:	e3a03000 	mov	r3, #0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:80
}
    a2b8:	e1a00003 	mov	r0, r3
    a2bc:	e28bd000 	add	sp, fp, #0
    a2c0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    a2c4:	e12fff1e 	bx	lr

0000a2c8 <_Z6strlenPKc>:
_Z6strlenPKc():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:83

int strlen(const char* s)
{
    a2c8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    a2cc:	e28db000 	add	fp, sp, #0
    a2d0:	e24dd014 	sub	sp, sp, #20
    a2d4:	e50b0010 	str	r0, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:84
    int i = 0;
    a2d8:	e3a03000 	mov	r3, #0
    a2dc:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:86

    while (s[i] != '\0')
    a2e0:	e51b3008 	ldr	r3, [fp, #-8]
    a2e4:	e51b2010 	ldr	r2, [fp, #-16]
    a2e8:	e0823003 	add	r3, r2, r3
    a2ec:	e5d33000 	ldrb	r3, [r3]
    a2f0:	e3530000 	cmp	r3, #0
    a2f4:	0a000003 	beq	a308 <_Z6strlenPKc+0x40>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:87
        i++;
    a2f8:	e51b3008 	ldr	r3, [fp, #-8]
    a2fc:	e2833001 	add	r3, r3, #1
    a300:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:86
    while (s[i] != '\0')
    a304:	eafffff5 	b	a2e0 <_Z6strlenPKc+0x18>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:89

    return i;
    a308:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:90
}
    a30c:	e1a00003 	mov	r0, r3
    a310:	e28bd000 	add	sp, fp, #0
    a314:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    a318:	e12fff1e 	bx	lr

0000a31c <_Z5bzeroPvi>:
_Z5bzeroPvi():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:93

void bzero(void* memory, int length)
{
    a31c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    a320:	e28db000 	add	fp, sp, #0
    a324:	e24dd014 	sub	sp, sp, #20
    a328:	e50b0010 	str	r0, [fp, #-16]
    a32c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:94
    char* mem = reinterpret_cast<char*>(memory);
    a330:	e51b3010 	ldr	r3, [fp, #-16]
    a334:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:96

    for (int i = 0; i < length; i++)
    a338:	e3a03000 	mov	r3, #0
    a33c:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:96 (discriminator 3)
    a340:	e51b2008 	ldr	r2, [fp, #-8]
    a344:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    a348:	e1520003 	cmp	r2, r3
    a34c:	aa000008 	bge	a374 <_Z5bzeroPvi+0x58>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:97 (discriminator 2)
        mem[i] = 0;
    a350:	e51b3008 	ldr	r3, [fp, #-8]
    a354:	e51b200c 	ldr	r2, [fp, #-12]
    a358:	e0823003 	add	r3, r2, r3
    a35c:	e3a02000 	mov	r2, #0
    a360:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:96 (discriminator 2)
    for (int i = 0; i < length; i++)
    a364:	e51b3008 	ldr	r3, [fp, #-8]
    a368:	e2833001 	add	r3, r3, #1
    a36c:	e50b3008 	str	r3, [fp, #-8]
    a370:	eafffff2 	b	a340 <_Z5bzeroPvi+0x24>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:98
}
    a374:	e320f000 	nop	{0}
    a378:	e28bd000 	add	sp, fp, #0
    a37c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    a380:	e12fff1e 	bx	lr

0000a384 <_Z6memcpyPKvPvi>:
_Z6memcpyPKvPvi():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:101

void memcpy(const void* src, void* dst, int num)
{
    a384:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    a388:	e28db000 	add	fp, sp, #0
    a38c:	e24dd024 	sub	sp, sp, #36	; 0x24
    a390:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    a394:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    a398:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:102
    const char* memsrc = reinterpret_cast<const char*>(src);
    a39c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    a3a0:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:103
    char* memdst = reinterpret_cast<char*>(dst);
    a3a4:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    a3a8:	e50b3010 	str	r3, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:105

    for (int i = 0; i < num; i++)
    a3ac:	e3a03000 	mov	r3, #0
    a3b0:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:105 (discriminator 3)
    a3b4:	e51b2008 	ldr	r2, [fp, #-8]
    a3b8:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    a3bc:	e1520003 	cmp	r2, r3
    a3c0:	aa00000b 	bge	a3f4 <_Z6memcpyPKvPvi+0x70>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:106 (discriminator 2)
        memdst[i] = memsrc[i];
    a3c4:	e51b3008 	ldr	r3, [fp, #-8]
    a3c8:	e51b200c 	ldr	r2, [fp, #-12]
    a3cc:	e0822003 	add	r2, r2, r3
    a3d0:	e51b3008 	ldr	r3, [fp, #-8]
    a3d4:	e51b1010 	ldr	r1, [fp, #-16]
    a3d8:	e0813003 	add	r3, r1, r3
    a3dc:	e5d22000 	ldrb	r2, [r2]
    a3e0:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:105 (discriminator 2)
    for (int i = 0; i < num; i++)
    a3e4:	e51b3008 	ldr	r3, [fp, #-8]
    a3e8:	e2833001 	add	r3, r3, #1
    a3ec:	e50b3008 	str	r3, [fp, #-8]
    a3f0:	eaffffef 	b	a3b4 <_Z6memcpyPKvPvi+0x30>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/stdlib/src/stdstring.cpp:107
}
    a3f4:	e320f000 	nop	{0}
    a3f8:	e28bd000 	add	sp, fp, #0
    a3fc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    a400:	e12fff1e 	bx	lr

0000a404 <__udivsi3>:
__udivsi3():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1104
    a404:	e2512001 	subs	r2, r1, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1106
    a408:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1107
    a40c:	3a000074 	bcc	a5e4 <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1108
    a410:	e1500001 	cmp	r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1109
    a414:	9a00006b 	bls	a5c8 <__udivsi3+0x1c4>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1110
    a418:	e1110002 	tst	r1, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1111
    a41c:	0a00006c 	beq	a5d4 <__udivsi3+0x1d0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1113
    a420:	e16f3f10 	clz	r3, r0
    a424:	e16f2f11 	clz	r2, r1
    a428:	e0423003 	sub	r3, r2, r3
    a42c:	e273301f 	rsbs	r3, r3, #31
    a430:	10833083 	addne	r3, r3, r3, lsl #1
    a434:	e3a02000 	mov	r2, #0
    a438:	108ff103 	addne	pc, pc, r3, lsl #2
    a43c:	e1a00000 	nop			; (mov r0, r0)
    a440:	e1500f81 	cmp	r0, r1, lsl #31
    a444:	e0a22002 	adc	r2, r2, r2
    a448:	20400f81 	subcs	r0, r0, r1, lsl #31
    a44c:	e1500f01 	cmp	r0, r1, lsl #30
    a450:	e0a22002 	adc	r2, r2, r2
    a454:	20400f01 	subcs	r0, r0, r1, lsl #30
    a458:	e1500e81 	cmp	r0, r1, lsl #29
    a45c:	e0a22002 	adc	r2, r2, r2
    a460:	20400e81 	subcs	r0, r0, r1, lsl #29
    a464:	e1500e01 	cmp	r0, r1, lsl #28
    a468:	e0a22002 	adc	r2, r2, r2
    a46c:	20400e01 	subcs	r0, r0, r1, lsl #28
    a470:	e1500d81 	cmp	r0, r1, lsl #27
    a474:	e0a22002 	adc	r2, r2, r2
    a478:	20400d81 	subcs	r0, r0, r1, lsl #27
    a47c:	e1500d01 	cmp	r0, r1, lsl #26
    a480:	e0a22002 	adc	r2, r2, r2
    a484:	20400d01 	subcs	r0, r0, r1, lsl #26
    a488:	e1500c81 	cmp	r0, r1, lsl #25
    a48c:	e0a22002 	adc	r2, r2, r2
    a490:	20400c81 	subcs	r0, r0, r1, lsl #25
    a494:	e1500c01 	cmp	r0, r1, lsl #24
    a498:	e0a22002 	adc	r2, r2, r2
    a49c:	20400c01 	subcs	r0, r0, r1, lsl #24
    a4a0:	e1500b81 	cmp	r0, r1, lsl #23
    a4a4:	e0a22002 	adc	r2, r2, r2
    a4a8:	20400b81 	subcs	r0, r0, r1, lsl #23
    a4ac:	e1500b01 	cmp	r0, r1, lsl #22
    a4b0:	e0a22002 	adc	r2, r2, r2
    a4b4:	20400b01 	subcs	r0, r0, r1, lsl #22
    a4b8:	e1500a81 	cmp	r0, r1, lsl #21
    a4bc:	e0a22002 	adc	r2, r2, r2
    a4c0:	20400a81 	subcs	r0, r0, r1, lsl #21
    a4c4:	e1500a01 	cmp	r0, r1, lsl #20
    a4c8:	e0a22002 	adc	r2, r2, r2
    a4cc:	20400a01 	subcs	r0, r0, r1, lsl #20
    a4d0:	e1500981 	cmp	r0, r1, lsl #19
    a4d4:	e0a22002 	adc	r2, r2, r2
    a4d8:	20400981 	subcs	r0, r0, r1, lsl #19
    a4dc:	e1500901 	cmp	r0, r1, lsl #18
    a4e0:	e0a22002 	adc	r2, r2, r2
    a4e4:	20400901 	subcs	r0, r0, r1, lsl #18
    a4e8:	e1500881 	cmp	r0, r1, lsl #17
    a4ec:	e0a22002 	adc	r2, r2, r2
    a4f0:	20400881 	subcs	r0, r0, r1, lsl #17
    a4f4:	e1500801 	cmp	r0, r1, lsl #16
    a4f8:	e0a22002 	adc	r2, r2, r2
    a4fc:	20400801 	subcs	r0, r0, r1, lsl #16
    a500:	e1500781 	cmp	r0, r1, lsl #15
    a504:	e0a22002 	adc	r2, r2, r2
    a508:	20400781 	subcs	r0, r0, r1, lsl #15
    a50c:	e1500701 	cmp	r0, r1, lsl #14
    a510:	e0a22002 	adc	r2, r2, r2
    a514:	20400701 	subcs	r0, r0, r1, lsl #14
    a518:	e1500681 	cmp	r0, r1, lsl #13
    a51c:	e0a22002 	adc	r2, r2, r2
    a520:	20400681 	subcs	r0, r0, r1, lsl #13
    a524:	e1500601 	cmp	r0, r1, lsl #12
    a528:	e0a22002 	adc	r2, r2, r2
    a52c:	20400601 	subcs	r0, r0, r1, lsl #12
    a530:	e1500581 	cmp	r0, r1, lsl #11
    a534:	e0a22002 	adc	r2, r2, r2
    a538:	20400581 	subcs	r0, r0, r1, lsl #11
    a53c:	e1500501 	cmp	r0, r1, lsl #10
    a540:	e0a22002 	adc	r2, r2, r2
    a544:	20400501 	subcs	r0, r0, r1, lsl #10
    a548:	e1500481 	cmp	r0, r1, lsl #9
    a54c:	e0a22002 	adc	r2, r2, r2
    a550:	20400481 	subcs	r0, r0, r1, lsl #9
    a554:	e1500401 	cmp	r0, r1, lsl #8
    a558:	e0a22002 	adc	r2, r2, r2
    a55c:	20400401 	subcs	r0, r0, r1, lsl #8
    a560:	e1500381 	cmp	r0, r1, lsl #7
    a564:	e0a22002 	adc	r2, r2, r2
    a568:	20400381 	subcs	r0, r0, r1, lsl #7
    a56c:	e1500301 	cmp	r0, r1, lsl #6
    a570:	e0a22002 	adc	r2, r2, r2
    a574:	20400301 	subcs	r0, r0, r1, lsl #6
    a578:	e1500281 	cmp	r0, r1, lsl #5
    a57c:	e0a22002 	adc	r2, r2, r2
    a580:	20400281 	subcs	r0, r0, r1, lsl #5
    a584:	e1500201 	cmp	r0, r1, lsl #4
    a588:	e0a22002 	adc	r2, r2, r2
    a58c:	20400201 	subcs	r0, r0, r1, lsl #4
    a590:	e1500181 	cmp	r0, r1, lsl #3
    a594:	e0a22002 	adc	r2, r2, r2
    a598:	20400181 	subcs	r0, r0, r1, lsl #3
    a59c:	e1500101 	cmp	r0, r1, lsl #2
    a5a0:	e0a22002 	adc	r2, r2, r2
    a5a4:	20400101 	subcs	r0, r0, r1, lsl #2
    a5a8:	e1500081 	cmp	r0, r1, lsl #1
    a5ac:	e0a22002 	adc	r2, r2, r2
    a5b0:	20400081 	subcs	r0, r0, r1, lsl #1
    a5b4:	e1500001 	cmp	r0, r1
    a5b8:	e0a22002 	adc	r2, r2, r2
    a5bc:	20400001 	subcs	r0, r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1115
    a5c0:	e1a00002 	mov	r0, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1116
    a5c4:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1119
    a5c8:	03a00001 	moveq	r0, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1120
    a5cc:	13a00000 	movne	r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1121
    a5d0:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1123
    a5d4:	e16f2f11 	clz	r2, r1
    a5d8:	e262201f 	rsb	r2, r2, #31
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1125
    a5dc:	e1a00230 	lsr	r0, r0, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1126
    a5e0:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1130
    a5e4:	e3500000 	cmp	r0, #0
    a5e8:	13e00000 	mvnne	r0, #0
    a5ec:	ea000007 	b	a610 <__aeabi_idiv0>

0000a5f0 <__aeabi_uidivmod>:
__aeabi_uidivmod():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1161
    a5f0:	e3510000 	cmp	r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1162
    a5f4:	0afffffa 	beq	a5e4 <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1163
    a5f8:	e92d4003 	push	{r0, r1, lr}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1164
    a5fc:	ebffff80 	bl	a404 <__udivsi3>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1165
    a600:	e8bd4006 	pop	{r1, r2, lr}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1166
    a604:	e0030092 	mul	r3, r2, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1167
    a608:	e0411003 	sub	r1, r1, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1168
    a60c:	e12fff1e 	bx	lr

0000a610 <__aeabi_idiv0>:
__aeabi_ldiv0():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1466
    a610:	e12fff1e 	bx	lr

Disassembly of section .ARM.extab:

0000a614 <.ARM.extab>:
    a614:	81019b40 	tsthi	r1, r0, asr #22
    a618:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    a61c:	00000000 	andeq	r0, r0, r0
    a620:	81019b41 	tsthi	r1, r1, asr #22
    a624:	8481b0b0 	strhi	fp, [r1], #176	; 0xb0
    a628:	00000000 	andeq	r0, r0, r0
    a62c:	81019b40 	tsthi	r1, r0, asr #22
    a630:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    a634:	00000000 	andeq	r0, r0, r0
    a638:	81019b40 	tsthi	r1, r0, asr #22
    a63c:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    a640:	00000000 	andeq	r0, r0, r0
    a644:	81019b40 	tsthi	r1, r0, asr #22
    a648:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    a64c:	00000000 	andeq	r0, r0, r0
    a650:	81019b40 	tsthi	r1, r0, asr #22
    a654:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    a658:	00000000 	andeq	r0, r0, r0
    a65c:	81019b40 	tsthi	r1, r0, asr #22
    a660:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    a664:	00000000 	andeq	r0, r0, r0
    a668:	81019b40 	tsthi	r1, r0, asr #22
    a66c:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    a670:	00000000 	andeq	r0, r0, r0
    a674:	81019b40 	tsthi	r1, r0, asr #22
    a678:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    a67c:	00000000 	andeq	r0, r0, r0
    a680:	81019b40 	tsthi	r1, r0, asr #22
    a684:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    a688:	00000000 	andeq	r0, r0, r0
    a68c:	81019b41 	tsthi	r1, r1, asr #22
    a690:	8481b0b0 	strhi	fp, [r1], #176	; 0xb0
    a694:	00000000 	andeq	r0, r0, r0
    a698:	81019b41 	tsthi	r1, r1, asr #22
    a69c:	8481b0b0 	strhi	fp, [r1], #176	; 0xb0
    a6a0:	00000000 	andeq	r0, r0, r0
    a6a4:	81019b40 	tsthi	r1, r0, asr #22
    a6a8:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    a6ac:	00000000 	andeq	r0, r0, r0
    a6b0:	81019b45 	tsthi	r1, r5, asr #22
    a6b4:	b10f8580 	smlabblt	pc, r0, r5, r8	; <UNPREDICTABLE>
    a6b8:	00000000 	andeq	r0, r0, r0
    a6bc:	81019b40 	tsthi	r1, r0, asr #22
    a6c0:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    a6c4:	00000000 	andeq	r0, r0, r0
    a6c8:	81019b40 	tsthi	r1, r0, asr #22
    a6cc:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    a6d0:	00000000 	andeq	r0, r0, r0
    a6d4:	81019b40 	tsthi	r1, r0, asr #22
    a6d8:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    a6dc:	00000000 	andeq	r0, r0, r0

Disassembly of section .ARM.exidx:

0000a6e0 <.ARM.exidx>:
    a6e0:	7fffd9b4 	svcvc	0x00ffd9b4
    a6e4:	00000001 	andeq	r0, r0, r1
    a6e8:	7fffebbc 	svcvc	0x00ffebbc
    a6ec:	7fffff28 	svcvc	0x00ffff28
    a6f0:	7fffec58 	svcvc	0x00ffec58
    a6f4:	7fffff2c 	svcvc	0x00ffff2c
    a6f8:	7fffecac 	svcvc	0x00ffecac
    a6fc:	7fffff30 	svcvc	0x00ffff30
    a700:	7fffed38 	svcvc	0x00ffed38
    a704:	7fffff34 	svcvc	0x00ffff34
    a708:	7fffeda4 	svcvc	0x00ffeda4
    a70c:	7fffff38 	svcvc	0x00ffff38
    a710:	7fffee08 	svcvc	0x00ffee08
    a714:	7fffff3c 	svcvc	0x00ffff3c
    a718:	7fffee68 	svcvc	0x00ffee68
    a71c:	7fffff40 	svcvc	0x00ffff40
    a720:	7fffeea0 	svcvc	0x00ffeea0
    a724:	7fffff44 	svcvc	0x00ffff44
    a728:	7fffeec8 	svcvc	0x00ffeec8
    a72c:	7fffff48 	svcvc	0x00ffff48
    a730:	7fffef00 	svcvc	0x00ffef00
    a734:	7fffff4c 	svcvc	0x00ffff4c
    a738:	7fffef74 	svcvc	0x00ffef74
    a73c:	7fffff50 	svcvc	0x00ffff50
    a740:	7fffefbc 	svcvc	0x00ffefbc
    a744:	7fffff54 	svcvc	0x00ffff54
    a748:	7ffff004 	svcvc	0x00fff004
    a74c:	00000001 	andeq	r0, r0, r1
    a750:	7ffff06c 	svcvc	0x00fff06c
    a754:	7fffff50 	svcvc	0x00ffff50
    a758:	7ffff390 	svcvc	0x00fff390
    a75c:	00000001 	andeq	r0, r0, r1
    a760:	7ffff3a0 	svcvc	0x00fff3a0
    a764:	7fffff4c 	svcvc	0x00ffff4c
    a768:	7ffff3f0 	svcvc	0x00fff3f0
    a76c:	00000001 	andeq	r0, r0, r1
    a770:	7ffff62c 	svcvc	0x00fff62c
    a774:	7fffff48 	svcvc	0x00ffff48
    a778:	7ffff69c 	svcvc	0x00fff69c
    a77c:	00000001 	andeq	r0, r0, r1
    a780:	7ffff71c 	svcvc	0x00fff71c
    a784:	7fffff44 	svcvc	0x00ffff44
    a788:	7ffff76c 	svcvc	0x00fff76c
    a78c:	7fffff48 	svcvc	0x00ffff48
    a790:	7ffff7bc 	svcvc	0x00fff7bc
    a794:	00000001 	andeq	r0, r0, r1

Disassembly of section .rodata:

0000a798 <_ZN3halL18Default_Clock_RateE>:
    a798:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

0000a79c <_ZN3halL15Peripheral_BaseE>:
    a79c:	20000000 	andcs	r0, r0, r0

0000a7a0 <_ZN3halL9GPIO_BaseE>:
    a7a0:	20200000 	eorcs	r0, r0, r0

0000a7a4 <_ZN3halL14GPIO_Pin_CountE>:
    a7a4:	00000036 	andeq	r0, r0, r6, lsr r0

0000a7a8 <_ZN3halL8AUX_BaseE>:
    a7a8:	20215000 	eorcs	r5, r1, r0

0000a7ac <_ZN3halL25Interrupt_Controller_BaseE>:
    a7ac:	2000b200 	andcs	fp, r0, r0, lsl #4

0000a7b0 <_ZN3halL10Timer_BaseE>:
    a7b0:	2000b400 	andcs	fp, r0, r0, lsl #8

0000a7b4 <_ZN3halL18Default_Clock_RateE>:
    a7b4:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

0000a7b8 <_ZN3halL15Peripheral_BaseE>:
    a7b8:	20000000 	andcs	r0, r0, r0

0000a7bc <_ZN3halL9GPIO_BaseE>:
    a7bc:	20200000 	eorcs	r0, r0, r0

0000a7c0 <_ZN3halL14GPIO_Pin_CountE>:
    a7c0:	00000036 	andeq	r0, r0, r6, lsr r0

0000a7c4 <_ZN3halL8AUX_BaseE>:
    a7c4:	20215000 	eorcs	r5, r1, r0

0000a7c8 <_ZN3halL25Interrupt_Controller_BaseE>:
    a7c8:	2000b200 	andcs	fp, r0, r0, lsl #4

0000a7cc <_ZN3halL10Timer_BaseE>:
    a7cc:	2000b400 	andcs	fp, r0, r0, lsl #8

0000a7d0 <_ZZN8CMonitorlsEjE11BUFFER_SIZE>:
    a7d0:	00000010 	andeq	r0, r0, r0, lsl r0
    a7d4:	65757274 	ldrbvs	r7, [r5, #-628]!	; 0xfffffd8c
    a7d8:	00000000 	andeq	r0, r0, r0
    a7dc:	736c6166 	cmnvc	ip, #-2147483623	; 0x80000019
    a7e0:	00000065 	andeq	r0, r0, r5, rrx
    a7e4:	33323130 	teqcc	r2, #48, 2
    a7e8:	37363534 			; <UNDEFINED> instruction: 0x37363534
    a7ec:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    a7f0:	46454443 	strbmi	r4, [r5], -r3, asr #8
    a7f4:	00000000 	andeq	r0, r0, r0

0000a7f8 <_ZN3halL18Default_Clock_RateE>:
    a7f8:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

0000a7fc <_ZN3halL15Peripheral_BaseE>:
    a7fc:	20000000 	andcs	r0, r0, r0

0000a800 <_ZN3halL9GPIO_BaseE>:
    a800:	20200000 	eorcs	r0, r0, r0

0000a804 <_ZN3halL14GPIO_Pin_CountE>:
    a804:	00000036 	andeq	r0, r0, r6, lsr r0

0000a808 <_ZN3halL8AUX_BaseE>:
    a808:	20215000 	eorcs	r5, r1, r0

0000a80c <_ZN3halL25Interrupt_Controller_BaseE>:
    a80c:	2000b200 	andcs	fp, r0, r0, lsl #4

0000a810 <_ZN3halL10Timer_BaseE>:
    a810:	2000b400 	andcs	fp, r0, r0, lsl #8

0000a814 <_ZN3halL18Default_Clock_RateE>:
    a814:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

0000a818 <_ZN3halL15Peripheral_BaseE>:
    a818:	20000000 	andcs	r0, r0, r0

0000a81c <_ZN3halL9GPIO_BaseE>:
    a81c:	20200000 	eorcs	r0, r0, r0

0000a820 <_ZN3halL14GPIO_Pin_CountE>:
    a820:	00000036 	andeq	r0, r0, r6, lsr r0

0000a824 <_ZN3halL8AUX_BaseE>:
    a824:	20215000 	eorcs	r5, r1, r0

0000a828 <_ZN3halL25Interrupt_Controller_BaseE>:
    a828:	2000b200 	andcs	fp, r0, r0, lsl #4

0000a82c <_ZN3halL10Timer_BaseE>:
    a82c:	2000b400 	andcs	fp, r0, r0, lsl #8
    a830:	73657741 	cmnvc	r5, #17039360	; 0x1040000
    a834:	21656d6f 	cmncs	r5, pc, ror #26
    a838:	74654c20 	strbtvc	r4, [r5], #-3104	; 0xfffff3e0
    a83c:	67207327 	strvs	r7, [r0, -r7, lsr #6]!
    a840:	73207465 			; <UNDEFINED> instruction: 0x73207465
    a844:	74726174 	ldrbtvc	r6, [r2], #-372	; 0xfffffe8c
    a848:	74206465 	strtvc	r6, [r0], #-1125	; 0xfffffb9b
    a84c:	2e6e6568 	cdpcs	5, 6, cr6, cr14, cr8, {3}
    a850:	0d0a2e2e 	stceq	14, cr2, [sl, #-184]	; 0xffffff48
    a854:	00000000 	andeq	r0, r0, r0
    a858:	276e6f44 	strbcs	r6, [lr, -r4, asr #30]!
    a85c:	6f772074 	svcvs	0x00772074
    a860:	2c797272 	lfmcs	f7, 2, [r9], #-456	; 0xfffffe38
    a864:	20657720 	rsbcs	r7, r5, r0, lsr #14
    a868:	206e6163 	rsbcs	r6, lr, r3, ror #2
    a86c:	61776c61 	cmnvs	r7, r1, ror #24
    a870:	70207379 	eorvc	r7, r0, r9, ror r3
    a874:	2079616c 	rsbscs	r6, r9, ip, ror #2
    a878:	20656874 	rsbcs	r6, r5, r4, ror r8
    a87c:	656d6167 	strbvs	r6, [sp, #-359]!	; 0xfffffe99
    a880:	78656e20 	stmdavc	r5!, {r5, r9, sl, fp, sp, lr}^
    a884:	69742074 	ldmdbvs	r4!, {r2, r4, r5, r6, sp}^
    a888:	2021656d 	eorcs	r6, r1, sp, ror #10
    a88c:	65766148 	ldrbvs	r6, [r6, #-328]!	; 0xfffffeb8
    a890:	67206120 	strvs	r6, [r0, -r0, lsr #2]!
    a894:	20646f6f 	rsbcs	r6, r4, pc, ror #30
    a898:	20656e6f 	rsbcs	r6, r5, pc, ror #28
    a89c:	0000293a 	andeq	r2, r0, sl, lsr r9
    a8a0:	79207349 	stmdbvc	r0!, {r0, r3, r6, r8, r9, ip, sp, lr}
    a8a4:	2072756f 	rsbscs	r7, r2, pc, ror #10
    a8a8:	626d756e 	rsbvs	r7, sp, #461373440	; 0x1b800000
    a8ac:	67207265 	strvs	r7, [r0, -r5, ror #4]!
    a8b0:	74616572 	strbtvc	r6, [r1], #-1394	; 0xfffffa8e
    a8b4:	74207265 	strtvc	r7, [r0], #-613	; 0xfffffd9b
    a8b8:	206e6168 	rsbcs	r6, lr, r8, ror #2
    a8bc:	00000000 	andeq	r0, r0, r0
    a8c0:	795b203f 	ldmdbvc	fp, {r0, r1, r2, r3, r4, r5, sp}^
    a8c4:	3a5d6e2f 	bcc	1766188 <_bss_end+0x175b6a8>
    a8c8:	00000020 	andeq	r0, r0, r0, lsr #32
    a8cc:	20656854 	rsbcs	r6, r5, r4, asr r8
    a8d0:	626d756e 	rsbvs	r7, sp, #461373440	; 0x1b800000
    a8d4:	79207265 	stmdbvc	r0!, {r0, r2, r5, r6, r9, ip, sp, lr}
    a8d8:	7227756f 	eorvc	r7, r7, #465567744	; 0x1bc00000
    a8dc:	68742065 	ldmdavs	r4!, {r0, r2, r5, r6, sp}^
    a8e0:	696b6e69 	stmdbvs	fp!, {r0, r3, r5, r6, r9, sl, fp, sp, lr}^
    a8e4:	6f20676e 	svcvs	0x0020676e
    a8e8:	756d2066 	strbvc	r2, [sp, #-102]!	; 0xffffff9a
    a8ec:	62207473 	eorvs	r7, r0, #1929379840	; 0x73000000
    a8f0:	00002065 	andeq	r2, r0, r5, rrx
    a8f4:	000d0a21 	andeq	r0, sp, r1, lsr #20
    a8f8:	79206f44 	stmdbvc	r0!, {r2, r6, r8, r9, sl, fp, sp, lr}
    a8fc:	7720756f 	strvc	r7, [r0, -pc, ror #10]!
    a900:	616e6e61 	cmnvs	lr, r1, ror #28
    a904:	616c7020 	cmnvs	ip, r0, lsr #32
    a908:	67612079 			; <UNDEFINED> instruction: 0x67612079
    a90c:	3f6e6961 	svccc	0x006e6961
    a910:	2f795b20 	svccs	0x00795b20
    a914:	203a5d6e 	eorscs	r5, sl, lr, ror #26
    a918:	00000000 	andeq	r0, r0, r0
    a91c:	20656553 	rsbcs	r6, r5, r3, asr r5
    a920:	20756f79 	rsbscs	r6, r5, r9, ror pc
    a924:	7478656e 	ldrbtvc	r6, [r8], #-1390	; 0xfffffa92
    a928:	6d697420 	cfstrdvs	mvd7, [r9, #-128]!	; 0xffffff80
    a92c:	0d0a2165 	stfeqs	f2, [sl, #-404]	; 0xfffffe6c
    a930:	00000000 	andeq	r0, r0, r0

0000a934 <_ZN3halL18Default_Clock_RateE>:
    a934:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

0000a938 <_ZN3halL15Peripheral_BaseE>:
    a938:	20000000 	andcs	r0, r0, r0

0000a93c <_ZN3halL9GPIO_BaseE>:
    a93c:	20200000 	eorcs	r0, r0, r0

0000a940 <_ZN3halL14GPIO_Pin_CountE>:
    a940:	00000036 	andeq	r0, r0, r6, lsr r0

0000a944 <_ZN3halL8AUX_BaseE>:
    a944:	20215000 	eorcs	r5, r1, r0

0000a948 <_ZN3halL25Interrupt_Controller_BaseE>:
    a948:	2000b200 	andcs	fp, r0, r0, lsl #4

0000a94c <_ZN3halL10Timer_BaseE>:
    a94c:	2000b400 	andcs	fp, r0, r0, lsl #8
    a950:	636c6557 	cmnvs	ip, #364904448	; 0x15c00000
    a954:	20656d6f 	rsbcs	r6, r5, pc, ror #26
    a958:	61206f74 			; <UNDEFINED> instruction: 0x61206f74
    a95c:	65756720 	ldrbvs	r6, [r5, #-1824]!	; 0xfffff8e0
    a960:	6e697373 	mcrvs	3, 3, r7, cr9, cr3, {3}
    a964:	61672067 	cmnvs	r7, r7, rrx
    a968:	0d21656d 	cfstr32eq	mvfx6, [r1, #-436]!	; 0xfffffe4c
    a96c:	0000000a 	andeq	r0, r0, sl
    a970:	2d2d2d2d 	stccs	13, cr2, [sp, #-180]!	; 0xffffff4c
    a974:	2d2d2d2d 	stccs	13, cr2, [sp, #-180]!	; 0xffffff4c
    a978:	2d2d2d2d 	stccs	13, cr2, [sp, #-180]!	; 0xffffff4c
    a97c:	2d2d2d2d 	stccs	13, cr2, [sp, #-180]!	; 0xffffff4c
    a980:	2d2d2d2d 	stccs	13, cr2, [sp, #-180]!	; 0xffffff4c
    a984:	2d2d2d2d 	stccs	13, cr2, [sp, #-180]!	; 0xffffff4c
    a988:	0d2d2d2d 	stceq	13, cr2, [sp, #-180]!	; 0xffffff4c
    a98c:	0000000a 	andeq	r0, r0, sl
    a990:	6e696854 	mcrvs	8, 3, r6, cr9, cr4, {2}
    a994:	666f206b 	strbtvs	r2, [pc], -fp, rrx
    a998:	6e206120 	sufvssp	f6, f0, f0
    a99c:	65626d75 	strbvs	r6, [r2, #-3445]!	; 0xfffff28b
    a9a0:	65622072 	strbvs	r2, [r2, #-114]!	; 0xffffff8e
    a9a4:	65657774 	strbvs	r7, [r5, #-1908]!	; 0xfffff88c
    a9a8:	2030206e 	eorscs	r2, r0, lr, rrx
    a9ac:	20646e61 	rsbcs	r6, r4, r1, ror #28
    a9b0:	20303031 	eorscs	r3, r0, r1, lsr r0
    a9b4:	20646e61 	rsbcs	r6, r4, r1, ror #28
    a9b8:	206d2749 	rsbcs	r2, sp, r9, asr #14
    a9bc:	6e6e6f67 	cdpvs	15, 6, cr6, cr14, cr7, {3}
    a9c0:	75672061 	strbvc	r2, [r7, #-97]!	; 0xffffff9f
    a9c4:	20737365 	rsbscs	r7, r3, r5, ror #6
    a9c8:	74616877 	strbtvc	r6, [r1], #-2167	; 0xfffff789
    a9cc:	20746920 	rsbscs	r6, r4, r0, lsr #18
    a9d0:	202e7369 	eorcs	r7, lr, r9, ror #6
    a9d4:	206c6c41 	rsbcs	r6, ip, r1, asr #24
    a9d8:	20756f79 	rsbscs	r6, r5, r9, ror pc
    a9dc:	74746f67 	ldrbtvc	r6, [r4], #-3943	; 0xfffff099
    a9e0:	6f642061 	svcvs	0x00642061
    a9e4:	20736920 	rsbscs	r6, r3, r0, lsr #18
    a9e8:	74206f74 	strtvc	r6, [r0], #-3956	; 0xfffff08c
    a9ec:	206c6c65 	rsbcs	r6, ip, r5, ror #24
    a9f0:	7720656d 	strvc	r6, [r0, -sp, ror #10]!
    a9f4:	68746568 	ldmdavs	r4!, {r3, r5, r6, r8, sl, sp, lr}^
    a9f8:	6d207265 	sfmvs	f7, 4, [r0, #-404]!	; 0xfffffe6c
    a9fc:	75672079 	strbvc	r2, [r7, #-121]!	; 0xffffff87
    aa00:	20737365 	rsbscs	r7, r3, r5, ror #6
    aa04:	6c207369 	stcvs	3, cr7, [r0], #-420	; 0xfffffe5c
    aa08:	65677261 	strbvs	r7, [r7, #-609]!	; 0xfffffd9f
    aa0c:	68742072 	ldmdavs	r4!, {r1, r4, r5, r6, sp}^
    aa10:	79206e61 	stmdbvc	r0!, {r0, r5, r6, r9, sl, fp, sp, lr}
    aa14:	2072756f 	rsbscs	r7, r2, pc, ror #10
    aa18:	626d756e 	rsbvs	r7, sp, #461373440	; 0x1b800000
    aa1c:	6f207265 	svcvs	0x00207265
    aa20:	68632066 	stmdavs	r3!, {r1, r2, r5, r6, sp}^
    aa24:	6563696f 	strbvs	r6, [r3, #-2415]!	; 0xfffff691
    aa28:	20726f20 	rsbscs	r6, r2, r0, lsr #30
    aa2c:	2c746f6e 	ldclcs	15, cr6, [r4], #-440	; 0xfffffe48
    aa30:	616b6f20 	cmnvs	fp, r0, lsr #30
    aa34:	5b203f79 	blpl	81a820 <_bss_end+0x80fd40>
    aa38:	5d6e2f79 	stclpl	15, cr2, [lr, #-484]!	; 0xfffffe1c
    aa3c:	0000203a 	andeq	r2, r0, sl, lsr r0

0000aa40 <_ZN12_GLOBAL__N_1L11CharConvArrE>:
    aa40:	33323130 	teqcc	r2, #48, 2
    aa44:	37363534 			; <UNDEFINED> instruction: 0x37363534
    aa48:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    aa4c:	46454443 	strbmi	r4, [r5], -r3, asr #8
	...

Disassembly of section .data:

0000aa54 <__CTOR_LIST__>:
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:2355
    aa54:	00008318 	andeq	r8, r0, r8, lsl r3
    aa58:	00008b54 	andeq	r8, r0, r4, asr fp
    aa5c:	0000919c 	muleq	r0, ip, r1
    aa60:	000097a0 	andeq	r9, r0, r0, lsr #15
    aa64:	00009d80 	andeq	r9, r0, r0, lsl #27

0000aa68 <__DTOR_LIST__>:
__DTOR_END__():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:8
volatile int max_num = 100;
    aa68:	00000064 	andeq	r0, r0, r4, rrx

Disassembly of section .bss:

0000aa6c <sAUX>:
_bss_start():
    aa6c:	00000000 	andeq	r0, r0, r0

0000aa70 <sGPIO>:
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/gpio.cpp:4
CGPIO_Handler sGPIO(hal::GPIO_Base);
    aa70:	00000000 	andeq	r0, r0, r0

0000aa74 <sMonitor>:
	...

0000aa8c <_ZZN8CMonitorlsEjE8s_buffer>:
	...

0000aa9c <sUART0>:
_ZZN8CMonitorlsEjE8s_buffer():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/drivers/uart.cpp:6
CUART sUART0(sAUX);
    aa9c:	00000000 	andeq	r0, r0, r0

0000aaa0 <_ZZN5CUART5WriteEjE3buf>:
	...

0000aab0 <_ZZN5CUART9Write_HexEjE3buf>:
	...

0000aac0 <game_state>:
_ZZN5CUART9Write_HexEjE3buf():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:7
volatile int game_state = 0;
    aac0:	00000000 	andeq	r0, r0, r0

0000aac4 <min_num>:
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:9
volatile int min_num = 0;
    aac4:	00000000 	andeq	r0, r0, r0

0000aac8 <middle>:
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/20-UART_game/kernel/src/interrupt_controller.cpp:10
volatile int middle;
    aac8:	00000000 	andeq	r0, r0, r0

0000aacc <sInterruptCtl>:
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
      a0:	bb050000 	bllt	1400a8 <_bss_end+0x1355c8>
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
     11c:	0a010067 	beq	402c0 <_bss_end+0x357e0>
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
     184:	1a0f0704 	bne	3c1d9c <_bss_end+0x3b72bc>
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
     258:	fa0b2200 	blx	2c8a60 <_bss_end+0x2bdf80>
     25c:	24000002 	strcs	r0, [r0], #-2
     260:	0003d80b 	andeq	sp, r3, fp, lsl #16
     264:	4b0b2500 	blmi	2c966c <_bss_end+0x2beb8c>
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
     2a0:	0b010000 	bleq	402a8 <_bss_end+0x357c8>
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
     2d0:	0a070402 	beq	1c12e0 <_bss_end+0x1b6800>
     2d4:	0500001a 	streq	r0, [r0, #-26]	; 0xffffffe6
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
     30c:	9a190a03 	bls	642b20 <_bss_end+0x638040>
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
     338:	00130712 	andseq	r0, r3, r2, lsl r7
     33c:	0a100300 	beq	400f44 <_bss_end+0x3f6464>
     340:	0000028e 	andeq	r0, r0, lr, lsl #5
     344:	00022301 	andeq	r2, r2, r1, lsl #6
     348:	00022e00 	andeq	r2, r2, r0, lsl #28
     34c:	029f1000 	addseq	r1, pc, #0
     350:	5b110000 	blpl	440358 <_bss_end+0x435878>
     354:	00000001 	andeq	r0, r0, r1
     358:	0011e712 	andseq	lr, r1, r2, lsl r7
     35c:	0a120300 	beq	480f64 <_bss_end+0x476484>
     360:	000004c9 	andeq	r0, r0, r9, asr #9
     364:	00024301 	andeq	r4, r2, r1, lsl #6
     368:	00024e00 	andeq	r4, r2, r0, lsl #28
     36c:	029f1000 	addseq	r1, pc, #0
     370:	5b110000 	blpl	440378 <_bss_end+0x435898>
     374:	00000001 	andeq	r0, r0, r1
     378:	00045712 	andeq	r5, r4, r2, lsl r7
     37c:	0a150300 	beq	540f84 <_bss_end+0x5364a4>
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
     3e8:	aa6c0305 	bge	1b01004 <_bss_end+0x1af6524>
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
     42c:	1a007091 	bne	1c678 <_bss_end+0x11b98>
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
     514:	ea1d0070 	b	7406dc <_bss_end+0x735bfc>
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
     5cc:	1a0f0704 	bne	3c21e4 <_bss_end+0x3b7704>
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
     630:	3a0a0000 	bcc	280638 <_bss_end+0x275b58>
     634:	00000005 	andeq	r0, r0, r5
     638:	0005420a 	andeq	r4, r5, sl, lsl #4
     63c:	4a0a0100 	bmi	280a44 <_bss_end+0x275f64>
     640:	02000005 	andeq	r0, r0, #5
     644:	0005520a 	andeq	r5, r5, sl, lsl #4
     648:	5a0a0300 	bpl	281250 <_bss_end+0x276770>
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
     718:	1a0a0704 	bne	282330 <_bss_end+0x277850>
     71c:	b1050000 	mrslt	r0, (UNDEF: 5)
     720:	0b000001 	bleq	72c <CPSR_IRQ_INHIBIT+0x6ac>
     724:	0000008d 	andeq	r0, r0, sp, lsl #1
     728:	00009d0b 	andeq	r9, r0, fp, lsl #26
     72c:	00ad0b00 	adceq	r0, sp, r0, lsl #22
     730:	7b0b0000 	blvc	2c0738 <_bss_end+0x2b5c58>
     734:	0b000001 	bleq	740 <CPSR_IRQ_INHIBIT+0x6c0>
     738:	0000018b 	andeq	r0, r0, fp, lsl #3
     73c:	00019b0b 	andeq	r9, r1, fp, lsl #22
     740:	09710900 	ldmdbeq	r1!, {r8, fp}^
     744:	01070000 	mrseq	r0, (UNDEF: 7)
     748:	0000003a 	andeq	r0, r0, sl, lsr r0
     74c:	240c0604 	strcs	r0, [ip], #-1540	; 0xfffff9fc
     750:	0a000002 	beq	760 <CPSR_IRQ_INHIBIT+0x6e0>
     754:	00000a01 	andeq	r0, r0, r1, lsl #20
     758:	0a120a00 	beq	482f60 <_bss_end+0x478480>
     75c:	0a010000 	beq	40764 <_bss_end+0x35c84>
     760:	00000a53 	andeq	r0, r0, r3, asr sl
     764:	0a4d0a02 	beq	1342f74 <_bss_end+0x1338494>
     768:	0a030000 	beq	c0770 <_bss_end+0xb5c90>
     76c:	00000a3b 	andeq	r0, r0, fp, lsr sl
     770:	0a410a04 	beq	1042f88 <_bss_end+0x10384a8>
     774:	0a050000 	beq	14077c <_bss_end+0x135c9c>
     778:	0000098c 	andeq	r0, r0, ip, lsl #19
     77c:	0a470a06 	beq	11c2f9c <_bss_end+0x11b84bc>
     780:	0a070000 	beq	1c0788 <_bss_end+0x1b5ca8>
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
     830:	ba0a2f04 	blt	28c448 <_bss_end+0x281968>
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
     8fc:	ea0f0000 	b	3c0904 <_bss_end+0x3b5e24>
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
     990:	0a420400 	beq	1081998 <_bss_end+0x1076eb8>
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
     a28:	aa700305 	bge	1c01644 <_bss_end+0x1bf6b64>
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
     a5c:	1a749102 	bne	1d24e6c <_bss_end+0x1d1a38c>
     a60:	0000042d 	andeq	r0, r0, sp, lsr #8
     a64:	3301b401 	movwcc	fp, #5121	; 0x1401
     a68:	02000000 	andeq	r0, r0, #0
     a6c:	1b007091 	blne	1ccb8 <_bss_end+0x121d8>
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
     b04:	1a6c9102 	bne	1b24f14 <_bss_end+0x1b1a434>
     b08:	000009b2 			; <UNDEFINED> instruction: 0x000009b2
     b0c:	9d4fa101 	stflsp	f2, [pc, #-4]	; b10 <CPSR_IRQ_INHIBIT+0xa90>
     b10:	02000004 	andeq	r0, r0, #4
     b14:	1b006891 	blne	1ad60 <_bss_end+0x10280>
     b18:	000003bc 			; <UNDEFINED> instruction: 0x000003bc
     b1c:	cb069801 	blgt	1a6b28 <_bss_end+0x19c048>
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
     bac:	1a609102 	bne	1824fbc <_bss_end+0x181a4dc>
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
     c34:	3a700100 	bcc	1c0103c <_bss_end+0x1bf655c>
     c38:	0000049d 	muleq	r0, sp, r4
     c3c:	1a689102 	bne	1a2504c <_bss_end+0x1a1a56c>
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
     cdc:	3a560100 	bcc	15810e4 <_bss_end+0x1576604>
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
     d38:	1a689102 	bne	1a25148 <_bss_end+0x1a1a668>
     d3c:	000009fc 	strdeq	r0, [r0], -ip
     d40:	db444d01 	blle	111414c <_bss_end+0x110966c>
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
     dd0:	ab9c0100 	blge	fe7011d8 <_bss_end+0xfe6f66f8>
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
     f18:	0bfc0400 	bleq	fff01f20 <_bss_end+0xffef7440>
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
     f88:	1b0c0200 	blne	301790 <_bss_end+0x2f6cb0>
     f8c:	00000052 	andeq	r0, r0, r2, asr r0
     f90:	b0090a01 	andlt	r0, r9, r1, lsl #20
     f94:	0200000b 	andeq	r0, r0, #11
     f98:	0278280d 	rsbseq	r2, r8, #851968	; 0xd0000
     f9c:	0a010000 	beq	40fa4 <_bss_end+0x364c4>
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
     fcc:	0a900d00 	beq	fe4043d4 <_bss_end+0xfe3f98f4>
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
    1094:	9a0c0000 	bls	30109c <_bss_end+0x2f65bc>
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
    10f0:	0be60a1f 	bleq	ff983974 <_bss_end+0xff978e94>
    10f4:	01f50000 	mvnseq	r0, r0
    10f8:	01fb0000 	mvnseq	r0, r0
    10fc:	890b0000 	stmdbhi	fp, {}	; <UNPREDICTABLE>
    1100:	00000002 	andeq	r0, r0, r2
    1104:	000ac70f 	andeq	ip, sl, pc, lsl #14
    1108:	0a210200 	beq	841910 <_bss_end+0x836e30>
    110c:	00000b90 	muleq	r0, r0, fp
    1110:	0000020f 	andeq	r0, r0, pc, lsl #4
    1114:	00000224 	andeq	r0, r0, r4, lsr #4
    1118:	0002890b 	andeq	r8, r2, fp, lsl #18
    111c:	02660c00 	rsbeq	r0, r6, #0, 24
    1120:	a10c0000 	mrsge	r0, (UNDEF: 12)
    1124:	0c000002 	stceq	0, cr0, [r0], {2}
    1128:	00000266 	andeq	r0, r0, r6, ror #4
    112c:	0b201000 	bleq	805134 <_bss_end+0x7fa654>
    1130:	2b020000 	blcs	81138 <_bss_end+0x76658>
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
    1160:	0a70100c 	beq	1c05198 <_bss_end+0x1bfa6b8>
    1164:	2f020000 	svccs	0x00020000
    1168:	00003212 	andeq	r3, r0, r2, lsl r2
    116c:	11001400 	tstne	r0, r0, lsl #8
    1170:	1a0f0704 	bne	3c2d88 <_bss_end+0x3b82a8>
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
    11dc:	00aa7403 	adceq	r7, sl, r3, lsl #8
    11e0:	0b2a1700 	bleq	a86de8 <_bss_end+0xa7c308>
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
    126c:	1709195c 	smlsdne	r9, ip, r9, r1
    1270:	87010000 	strhi	r0, [r1, -r0]
    1274:	00026644 	andeq	r6, r2, r4, asr #12
    1278:	58910200 	ldmpl	r1, {r9}
    127c:	0100691d 	tsteq	r0, sp, lsl r9
    1280:	03190989 	tsteq	r9, #2244608	; 0x224000
    1284:	91020000 	mrsls	r0, (UNDEF: 2)
    1288:	909c1e74 	addsls	r1, ip, r4, ror lr
    128c:	00980000 	addseq	r0, r8, r0
    1290:	6a1d0000 	bvs	741298 <_bss_end+0x7367b8>
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
    12bc:	0b770100 	bleq	1dc16c4 <_bss_end+0x1db6be4>
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
    12ec:	4b1b0073 	blmi	6c14c0 <_bss_end+0x6b69e0>
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
    1330:	00a7d003 	adceq	sp, r7, r3
    1334:	0cda2100 	ldfeqe	f2, [sl], {0}
    1338:	6e010000 	cdpvs	0, 0, cr0, cr1, cr0, {0}
    133c:	00043f11 	andeq	r3, r4, r1, lsl pc
    1340:	8c030500 	cfstr32hi	mvfx0, [r3], {-0}
    1344:	000000aa 	andeq	r0, r0, sl, lsr #1
    1348:	00027d22 	andeq	r7, r2, r2, lsr #26
    134c:	00044f00 	andeq	r4, r4, r0, lsl #30
    1350:	02662300 	rsbeq	r2, r6, #0, 6
    1354:	000f0000 	andeq	r0, pc, r0
    1358:	00012724 	andeq	r2, r1, r4, lsr #14
    135c:	0b630100 	bleq	18c1764 <_bss_end+0x18b6c84>
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
    1498:	3a010078 	bcc	41680 <_bss_end+0x36ba0>
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
    1514:	1b1a0100 	blne	68191c <_bss_end+0x676e3c>
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
    159c:	2a9c0100 	bcs	fe7019a4 <_bss_end+0xfe6f6ec4>
    15a0:	00000651 	andeq	r0, r0, r1, asr r6
    15a4:	2a749102 	bcs	1d259b4 <_bss_end+0x1d1aed4>
    15a8:	0000065a 	andeq	r0, r0, sl, asr r6
    15ac:	2a709102 	bcs	1c259bc <_bss_end+0x1c1aedc>
    15b0:	00000666 	andeq	r0, r0, r6, ror #12
    15b4:	2a6c9102 	bcs	1b259c4 <_bss_end+0x1b1aee4>
    15b8:	00000672 	andeq	r0, r0, r2, ror r6
    15bc:	00689102 	rsbeq	r9, r8, r2, lsl #2
    15c0:	00082d00 	andeq	r2, r8, r0, lsl #26
    15c4:	cd000400 	cfstrsgt	mvf0, [r0, #-0]
    15c8:	04000007 	streq	r0, [r0], #-7
    15cc:	0000b501 	andeq	fp, r0, r1, lsl #10
    15d0:	0f0a0400 	svceq	0x000a0400
    15d4:	00740000 	rsbseq	r0, r4, r0
    15d8:	92a40000 	adcls	r0, r4, #0
    15dc:	05180000 	ldreq	r0, [r8, #-0]
    15e0:	0a820000 	beq	fe0815e8 <_bss_end+0xfe076b08>
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
    1620:	1a0f0704 	bne	3c3238 <_bss_end+0x3b8758>
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
    16f4:	fa0b2200 	blx	2c9efc <_bss_end+0x2bf41c>
    16f8:	24000002 	strcs	r0, [r0], #-2
    16fc:	0003d80b 	andeq	sp, r3, fp, lsl #16
    1700:	4b0b2500 	blmi	2cab08 <_bss_end+0x2c0028>
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
    173c:	0b010000 	bleq	41744 <_bss_end+0x36c64>
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
    176c:	0a070402 	beq	1c277c <_bss_end+0x1b7c9c>
    1770:	0300001a 	movweq	r0, #26
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
    17d4:	00130712 	andseq	r0, r3, r2, lsl r7
    17d8:	0a100300 	beq	4023e0 <_bss_end+0x3f7900>
    17dc:	0000028e 	andeq	r0, r0, lr, lsl #5
    17e0:	00022801 	andeq	r2, r2, r1, lsl #16
    17e4:	00023300 	andeq	r3, r2, r0, lsl #6
    17e8:	02a41000 	adceq	r1, r4, #0
    17ec:	60110000 	andsvs	r0, r1, r0
    17f0:	00000001 	andeq	r0, r0, r1
    17f4:	0011e712 	andseq	lr, r1, r2, lsl r7
    17f8:	0a120300 	beq	482400 <_bss_end+0x477920>
    17fc:	000004c9 	andeq	r0, r0, r9, asr #9
    1800:	00024801 	andeq	r4, r2, r1, lsl #16
    1804:	00025300 	andeq	r5, r2, r0, lsl #6
    1808:	02a41000 	adceq	r1, r4, #0
    180c:	60110000 	andsvs	r0, r1, r0
    1810:	00000001 	andeq	r0, r0, r1
    1814:	00045712 	andeq	r5, r4, r2, lsl r7
    1818:	0a150300 	beq	542420 <_bss_end+0x537940>
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
    1878:	00000edc 	ldrdeq	r0, [r0], -ip
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
    18bc:	0f021612 	svceq	0x00021612
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
    18ec:	000004b8 			; <UNDEFINED> instruction: 0x000004b8
    18f0:	000d330e 	andeq	r3, sp, lr, lsl #6
    18f4:	0b1b0400 	bleq	6c28fc <_bss_end+0x6b7e1c>
    18f8:	000004b8 			; <UNDEFINED> instruction: 0x000004b8
    18fc:	0df20f00 	ldcleq	15, cr0, [r2]
    1900:	1e040000 	cdpne	0, 0, cr0, cr4, cr0, {0}
    1904:	000e8605 	andeq	r8, lr, r5, lsl #12
    1908:	0004be00 	andeq	fp, r4, r0, lsl #28
    190c:	03550100 	cmpeq	r5, #0, 2
    1910:	03600000 	cmneq	r0, #0
    1914:	be100000 	cdplt	0, 1, cr0, cr0, cr0, {0}
    1918:	11000004 	tstne	r0, r4
    191c:	000004b8 			; <UNDEFINED> instruction: 0x000004b8
    1920:	0d991200 	lfmeq	f1, 4, [r9]
    1924:	20040000 	andcs	r0, r4, r0
    1928:	000ebf0a 	andeq	fp, lr, sl, lsl #30
    192c:	03750100 	cmneq	r5, #0, 2
    1930:	03800000 	orreq	r0, r0, #0
    1934:	be100000 	cdplt	0, 1, cr0, cr0, cr0, {0}
    1938:	11000004 	tstne	r0, r4
    193c:	000002b6 			; <UNDEFINED> instruction: 0x000002b6
    1940:	0e291200 	cdpeq	2, 2, cr1, cr9, cr0, {0}
    1944:	21040000 	mrscs	r0, (UNDEF: 4)
    1948:	000e490a 	andeq	r4, lr, sl, lsl #18
    194c:	03950100 	orrseq	r0, r5, #0, 2
    1950:	03a00000 	moveq	r0, #0
    1954:	be100000 	cdplt	0, 1, cr0, cr0, cr0, {0}
    1958:	11000004 	tstne	r0, r4
    195c:	000002d5 	ldrdeq	r0, [r0], -r5
    1960:	0d171200 	lfmeq	f1, 4, [r7, #-0]
    1964:	25040000 	strcs	r0, [r4, #-0]
    1968:	000e740a 	andeq	r7, lr, sl, lsl #8
    196c:	03b50100 			; <UNDEFINED> instruction: 0x03b50100
    1970:	03c00000 	biceq	r0, r0, #0
    1974:	be100000 	cdplt	0, 1, cr0, cr0, cr0, {0}
    1978:	11000004 	tstne	r0, r4
    197c:	00000025 	andeq	r0, r0, r5, lsr #32
    1980:	0d171200 	lfmeq	f1, 4, [r7, #-0]
    1984:	26040000 	strcs	r0, [r4], -r0
    1988:	000eab0a 	andeq	sl, lr, sl, lsl #22
    198c:	03d50100 	bicseq	r0, r5, #0, 2
    1990:	03e00000 	mvneq	r0, #0
    1994:	be100000 	cdplt	0, 1, cr0, cr0, cr0, {0}
    1998:	11000004 	tstne	r0, r4
    199c:	000004c9 	andeq	r0, r0, r9, asr #9
    19a0:	0d171200 	lfmeq	f1, 4, [r7, #-0]
    19a4:	27040000 	strcs	r0, [r4, -r0]
    19a8:	000d6b0a 	andeq	r6, sp, sl, lsl #22
    19ac:	03f50100 	mvnseq	r0, #0, 2
    19b0:	04050000 	streq	r0, [r5], #-0
    19b4:	be100000 	cdplt	0, 1, cr0, cr0, cr0, {0}
    19b8:	11000004 	tstne	r0, r4
    19bc:	000004c9 	andeq	r0, r0, r9, asr #9
    19c0:	00005e11 	andeq	r5, r0, r1, lsl lr
    19c4:	17120000 	ldrne	r0, [r2, -r0]
    19c8:	0400000d 	streq	r0, [r0], #-13
    19cc:	0db00a28 			; <UNDEFINED> instruction: 0x0db00a28
    19d0:	1a010000 	bne	419d8 <_bss_end+0x36ef8>
    19d4:	25000004 	strcs	r0, [r0, #-4]
    19d8:	10000004 	andne	r0, r0, r4
    19dc:	000004be 			; <UNDEFINED> instruction: 0x000004be
    19e0:	00005e11 	andeq	r5, r0, r1, lsl lr
    19e4:	17120000 	ldrne	r0, [r2, -r0]
    19e8:	0400000d 	streq	r0, [r0], #-13
    19ec:	0e990a29 	vfnmseq.f32	s0, s18, s19
    19f0:	3a010000 	bcc	419f8 <_bss_end+0x36f18>
    19f4:	45000004 	strmi	r0, [r0, #-4]
    19f8:	10000004 	andne	r0, r0, r4
    19fc:	000004be 			; <UNDEFINED> instruction: 0x000004be
    1a00:	00003811 	andeq	r3, r0, r1, lsl r8
    1a04:	d5120000 	ldrle	r0, [r2, #-0]
    1a08:	0400000d 	streq	r0, [r0], #-13
    1a0c:	0d1d0a2a 	vldreq	s0, [sp, #-168]	; 0xffffff58
    1a10:	5a010000 	bpl	41a18 <_bss_end+0x36f38>
    1a14:	65000004 	strvs	r0, [r0, #-4]
    1a18:	10000004 	andne	r0, r0, r4
    1a1c:	000004be 			; <UNDEFINED> instruction: 0x000004be
    1a20:	00005e11 	andeq	r5, r0, r1, lsl lr
    1a24:	61120000 	tstvs	r2, r0
    1a28:	0400000d 	streq	r0, [r0], #-13
    1a2c:	0d800a2b 	vstreq	s0, [r0, #172]	; 0xac
    1a30:	7a010000 	bvc	41a38 <_bss_end+0x36f58>
    1a34:	85000004 	strhi	r0, [r0, #-4]
    1a38:	10000004 	andne	r0, r0, r4
    1a3c:	000004be 			; <UNDEFINED> instruction: 0x000004be
    1a40:	0004cf11 	andeq	ip, r4, r1, lsl pc
    1a44:	df120000 	svcle	0x00120000
    1a48:	0400000d 	streq	r0, [r0], #-13
    1a4c:	0cef0a2d 	vstmiaeq	pc!, {s1-s45}
    1a50:	9a010000 	bls	41a58 <_bss_end+0x36f78>
    1a54:	a0000004 	andge	r0, r0, r4
    1a58:	10000004 	andne	r0, r0, r4
    1a5c:	000004be 			; <UNDEFINED> instruction: 0x000004be
    1a60:	0eee1800 	cdpeq	8, 14, cr1, cr14, cr0, {0}
    1a64:	2e040000 	cdpcs	0, 0, cr0, cr4, cr0, {0}
    1a68:	000d400a 	andeq	r4, sp, sl
    1a6c:	04b10100 	ldrteq	r0, [r1], #256	; 0x100
    1a70:	be100000 	cdplt	0, 1, cr0, cr0, cr0, {0}
    1a74:	00000004 	andeq	r0, r0, r4
    1a78:	d5041900 	strle	r1, [r4, #-2304]	; 0xfffff700
    1a7c:	14000001 	strne	r0, [r0], #-1
    1a80:	00032204 	andeq	r2, r3, r4, lsl #4
    1a84:	04be0300 	ldrteq	r0, [lr], #768	; 0x300
    1a88:	04140000 	ldreq	r0, [r4], #-0
    1a8c:	0000002c 	andeq	r0, r0, ip, lsr #32
    1a90:	00250414 	eoreq	r0, r5, r4, lsl r4
    1a94:	07150000 	ldreq	r0, [r5, -r0]
    1a98:	0400000e 	streq	r0, [r0], #-14
    1a9c:	03220e31 			; <UNDEFINED> instruction: 0x03220e31
    1aa0:	01020000 	mrseq	r0, (UNDEF: 2)
    1aa4:	00067002 	andeq	r7, r6, r2
    1aa8:	04d51a00 	ldrbeq	r1, [r5], #2560	; 0xa00
    1aac:	06010000 	streq	r0, [r1], -r0
    1ab0:	9c030507 	cfstr32ls	mvfx0, [r3], {7}
    1ab4:	1b0000aa 	blne	1d64 <CPSR_IRQ_INHIBIT+0x1ce4>
    1ab8:	00000df8 	strdeq	r0, [r0], -r8
    1abc:	000097a0 	andeq	r9, r0, r0, lsr #15
    1ac0:	0000001c 	andeq	r0, r0, ip, lsl r0
    1ac4:	031c9c01 	tsteq	ip, #256	; 0x100
    1ac8:	4c000004 	stcmi	0, cr0, [r0], {4}
    1acc:	54000097 	strpl	r0, [r0], #-151	; 0xffffff69
    1ad0:	01000000 	mrseq	r0, (UNDEF: 0)
    1ad4:	0005379c 	muleq	r5, ip, r7
    1ad8:	033c1d00 	teqeq	ip, #0, 26
    1adc:	65010000 	strvs	r0, [r1, #-0]
    1ae0:	00003801 	andeq	r3, r0, r1, lsl #16
    1ae4:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1ae8:	00042d1d 	andeq	r2, r4, sp, lsl sp
    1aec:	01650100 	cmneq	r5, r0, lsl #2
    1af0:	00000038 	andeq	r0, r0, r8, lsr r0
    1af4:	00709102 	rsbseq	r9, r0, r2, lsl #2
    1af8:	0004a01e 	andeq	sl, r4, lr, lsl r0
    1afc:	06620100 	strbteq	r0, [r2], -r0, lsl #2
    1b00:	00000551 	andeq	r0, r0, r1, asr r5
    1b04:	000096fc 	strdeq	r9, [r0], -ip
    1b08:	00000050 	andeq	r0, r0, r0, asr r0
    1b0c:	055e9c01 	ldrbeq	r9, [lr, #-3073]	; 0xfffff3ff
    1b10:	381f0000 	ldmdacc	pc, {}	; <UNPREDICTABLE>
    1b14:	c4000004 	strgt	r0, [r0], #-4
    1b18:	02000004 	andeq	r0, r0, #4
    1b1c:	1e006c91 	mcrne	12, 0, r6, cr0, cr1, {4}
    1b20:	00000485 	andeq	r0, r0, r5, lsl #9
    1b24:	78065d01 	stmdavc	r6, {r0, r8, sl, fp, ip, lr}
    1b28:	ac000005 	stcge	0, cr0, [r0], {5}
    1b2c:	50000096 	mulpl	r0, r6, r0
    1b30:	01000000 	mrseq	r0, (UNDEF: 0)
    1b34:	0005859c 	muleq	r5, ip, r5
    1b38:	04381f00 	ldrteq	r1, [r8], #-3840	; 0xfffff100
    1b3c:	04c40000 	strbeq	r0, [r4], #0
    1b40:	91020000 	mrsls	r0, (UNDEF: 2)
    1b44:	651e006c 	ldrvs	r0, [lr, #-108]	; 0xffffff94
    1b48:	01000004 	tsteq	r0, r4
    1b4c:	059f0653 	ldreq	r0, [pc, #1619]	; 21a7 <CPSR_IRQ_INHIBIT+0x2127>
    1b50:	96300000 	ldrtls	r0, [r0], -r0
    1b54:	007c0000 	rsbseq	r0, ip, r0
    1b58:	9c010000 	stcls	0, cr0, [r1], {-0}
    1b5c:	000005b9 			; <UNDEFINED> instruction: 0x000005b9
    1b60:	0004381f 	andeq	r3, r4, pc, lsl r8
    1b64:	0004c400 	andeq	ip, r4, r0, lsl #8
    1b68:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1b6c:	01006320 	tsteq	r0, r0, lsr #6
    1b70:	04cf1853 	strbeq	r1, [pc], #2131	; 1b78 <CPSR_IRQ_INHIBIT+0x1af8>
    1b74:	91020000 	mrsls	r0, (UNDEF: 2)
    1b78:	451e0070 	ldrmi	r0, [lr, #-112]	; 0xffffff90
    1b7c:	01000004 	tsteq	r0, r4
    1b80:	05d3064b 	ldrbeq	r0, [r3, #1611]	; 0x64b
    1b84:	95f00000 	ldrbls	r0, [r0, #0]!
    1b88:	00400000 	subeq	r0, r0, r0
    1b8c:	9c010000 	stcls	0, cr0, [r1], {-0}
    1b90:	00000601 	andeq	r0, r0, r1, lsl #12
    1b94:	0004381f 	andeq	r3, r4, pc, lsl r8
    1b98:	0004c400 	andeq	ip, r4, r0, lsl #8
    1b9c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1ba0:	6d756e20 	ldclvs	14, cr6, [r5, #-128]!	; 0xffffff80
    1ba4:	244b0100 	strbcs	r0, [fp], #-256	; 0xffffff00
    1ba8:	0000005e 	andeq	r0, r0, lr, asr r0
    1bac:	21709102 	cmncs	r0, r2, lsl #2
    1bb0:	00667562 	rsbeq	r7, r6, r2, ror #10
    1bb4:	01114d01 	tsteq	r1, r1, lsl #26
    1bb8:	05000006 	streq	r0, [r0, #-6]
    1bbc:	00aab003 	adceq	fp, sl, r3
    1bc0:	25220000 	strcs	r0, [r2, #-0]!
    1bc4:	11000000 	mrsne	r0, (UNDEF: 0)
    1bc8:	23000006 	movwcs	r0, #6
    1bcc:	0000005e 	andeq	r0, r0, lr, asr r0
    1bd0:	251e000f 	ldrcs	r0, [lr, #-15]
    1bd4:	01000004 	tsteq	r0, r4
    1bd8:	062b0646 	strteq	r0, [fp], -r6, asr #12
    1bdc:	95c00000 	strbls	r0, [r0]
    1be0:	00300000 	eorseq	r0, r0, r0
    1be4:	9c010000 	stcls	0, cr0, [r1], {-0}
    1be8:	00000647 	andeq	r0, r0, r7, asr #12
    1bec:	0004381f 	andeq	r3, r4, pc, lsl r8
    1bf0:	0004c400 	andeq	ip, r4, r0, lsl #8
    1bf4:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1bf8:	6d756e20 	ldclvs	14, cr6, [r5, #-128]!	; 0xffffff80
    1bfc:	17460100 	strbne	r0, [r6, -r0, lsl #2]
    1c00:	00000038 	andeq	r0, r0, r8, lsr r0
    1c04:	00709102 	rsbseq	r9, r0, r2, lsl #2
    1c08:	0004051e 	andeq	r0, r4, lr, lsl r5
    1c0c:	063e0100 	ldrteq	r0, [lr], -r0, lsl #2
    1c10:	00000661 	andeq	r0, r0, r1, ror #12
    1c14:	00009580 	andeq	r9, r0, r0, lsl #11
    1c18:	00000040 	andeq	r0, r0, r0, asr #32
    1c1c:	068f9c01 	streq	r9, [pc], r1, lsl #24
    1c20:	381f0000 	ldmdacc	pc, {}	; <UNPREDICTABLE>
    1c24:	c4000004 	strgt	r0, [r0], #-4
    1c28:	02000004 	andeq	r0, r0, #4
    1c2c:	6e207491 	mcrvs	4, 1, r7, cr0, cr1, {4}
    1c30:	01006d75 	tsteq	r0, r5, ror sp
    1c34:	005e203e 	subseq	r2, lr, lr, lsr r0
    1c38:	91020000 	mrsls	r0, (UNDEF: 2)
    1c3c:	75622170 	strbvc	r2, [r2, #-368]!	; 0xfffffe90
    1c40:	40010066 	andmi	r0, r1, r6, rrx
    1c44:	00060111 	andeq	r0, r6, r1, lsl r1
    1c48:	a0030500 	andge	r0, r3, r0, lsl #10
    1c4c:	000000aa 	andeq	r0, r0, sl, lsr #1
    1c50:	0003e01e 	andeq	lr, r3, lr, lsl r0
    1c54:	06360100 	ldrteq	r0, [r6], -r0, lsl #2
    1c58:	000006a9 	andeq	r0, r0, r9, lsr #13
    1c5c:	00009518 	andeq	r9, r0, r8, lsl r5
    1c60:	00000068 	andeq	r0, r0, r8, rrx
    1c64:	06e19c01 	strbteq	r9, [r1], r1, lsl #24
    1c68:	381f0000 	ldmdacc	pc, {}	; <UNPREDICTABLE>
    1c6c:	c4000004 	strgt	r0, [r0], #-4
    1c70:	02000004 	andeq	r0, r0, #4
    1c74:	73206c91 			; <UNDEFINED> instruction: 0x73206c91
    1c78:	01007274 	tsteq	r0, r4, ror r2
    1c7c:	04c91f36 	strbeq	r1, [r9], #3894	; 0xf36
    1c80:	91020000 	mrsls	r0, (UNDEF: 2)
    1c84:	656c2068 	strbvs	r2, [ip, #-104]!	; 0xffffff98
    1c88:	3601006e 	strcc	r0, [r1], -lr, rrx
    1c8c:	00005e31 	andeq	r5, r0, r1, lsr lr
    1c90:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    1c94:	01006921 	tsteq	r0, r1, lsr #18
    1c98:	005e1238 	subseq	r1, lr, r8, lsr r2
    1c9c:	91020000 	mrsls	r0, (UNDEF: 2)
    1ca0:	c01e0074 	andsgt	r0, lr, r4, ror r0
    1ca4:	01000003 	tsteq	r0, r3
    1ca8:	06fb062e 	ldrbteq	r0, [fp], lr, lsr #12
    1cac:	94ac0000 	strtls	r0, [ip], #0
    1cb0:	006c0000 	rsbeq	r0, ip, r0
    1cb4:	9c010000 	stcls	0, cr0, [r1], {-0}
    1cb8:	00000724 	andeq	r0, r0, r4, lsr #14
    1cbc:	0004381f 	andeq	r3, r4, pc, lsl r8
    1cc0:	0004c400 	andeq	ip, r4, r0, lsl #8
    1cc4:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1cc8:	72747320 	rsbsvc	r7, r4, #32, 6	; 0x80000000
    1ccc:	1f2e0100 	svcne	0x002e0100
    1cd0:	000004c9 	andeq	r0, r0, r9, asr #9
    1cd4:	21689102 	cmncs	r8, r2, lsl #2
    1cd8:	30010069 	andcc	r0, r1, r9, rrx
    1cdc:	00003809 	andeq	r3, r0, r9, lsl #16
    1ce0:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1ce4:	03a02400 	moveq	r2, #0, 8
    1ce8:	06010000 	streq	r0, [r1], -r0
    1cec:	0000073d 	andeq	r0, r0, sp, lsr r7
    1cf0:	00009438 	andeq	r9, r0, r8, lsr r4
    1cf4:	00000074 	andeq	r0, r0, r4, ror r0
    1cf8:	07579c01 	ldrbeq	r9, [r7, -r1, lsl #24]
    1cfc:	381f0000 	ldmdacc	pc, {}	; <UNPREDICTABLE>
    1d00:	c4000004 	strgt	r0, [r0], #-4
    1d04:	02000004 	andeq	r0, r0, #4
    1d08:	63207491 			; <UNDEFINED> instruction: 0x63207491
    1d0c:	18250100 	stmdane	r5!, {r8}
    1d10:	00000025 	andeq	r0, r0, r5, lsr #32
    1d14:	00739102 	rsbseq	r9, r3, r2, lsl #2
    1d18:	0003801e 	andeq	r8, r3, lr, lsl r0
    1d1c:	06190100 	ldreq	r0, [r9], -r0, lsl #2
    1d20:	00000771 	andeq	r0, r0, r1, ror r7
    1d24:	000093a4 	andeq	r9, r0, r4, lsr #7
    1d28:	00000094 	muleq	r0, r4, r0
    1d2c:	07ab9c01 	streq	r9, [fp, r1, lsl #24]!
    1d30:	381f0000 	ldmdacc	pc, {}	; <UNPREDICTABLE>
    1d34:	c4000004 	strgt	r0, [r0], #-4
    1d38:	02000004 	andeq	r0, r0, #4
    1d3c:	661d6c91 			; <UNDEFINED> instruction: 0x661d6c91
    1d40:	0100000d 	tsteq	r0, sp
    1d44:	02d52b19 	sbcseq	r2, r5, #25600	; 0x6400
    1d48:	91020000 	mrsls	r0, (UNDEF: 2)
    1d4c:	04be2568 	ldrteq	r2, [lr], #1384	; 0x568
    1d50:	1b010000 	blne	41d58 <_bss_end+0x37278>
    1d54:	0000651c 	andeq	r6, r0, ip, lsl r5
    1d58:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1d5c:	6c617621 	stclvs	6, cr7, [r1], #-132	; 0xffffff7c
    1d60:	181c0100 	ldmdane	ip, {r8}
    1d64:	00000065 	andeq	r0, r0, r5, rrx
    1d68:	00709102 	rsbseq	r9, r0, r2, lsl #2
    1d6c:	0003601e 	andeq	r6, r3, lr, lsl r0
    1d70:	06130100 	ldreq	r0, [r3], -r0, lsl #2
    1d74:	000007c5 	andeq	r0, r0, r5, asr #15
    1d78:	00009348 	andeq	r9, r0, r8, asr #6
    1d7c:	0000005c 	andeq	r0, r0, ip, asr r0
    1d80:	07e19c01 	strbeq	r9, [r1, r1, lsl #24]!
    1d84:	381f0000 	ldmdacc	pc, {}	; <UNPREDICTABLE>
    1d88:	c4000004 	strgt	r0, [r0], #-4
    1d8c:	02000004 	andeq	r0, r0, #4
    1d90:	6c206c91 	stcvs	12, cr6, [r0], #-580	; 0xfffffdbc
    1d94:	01006e65 	tsteq	r0, r5, ror #28
    1d98:	02b62f13 	adcseq	r2, r6, #19, 30	; 0x4c
    1d9c:	91020000 	mrsls	r0, (UNDEF: 2)
    1da0:	3c260068 	stccc	0, cr0, [r6], #-416	; 0xfffffe60
    1da4:	01000003 	tsteq	r0, r3
    1da8:	07f20108 	ldrbeq	r0, [r2, r8, lsl #2]!
    1dac:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    1db0:	27000008 	strcs	r0, [r0, -r8]
    1db4:	00000438 	andeq	r0, r0, r8, lsr r4
    1db8:	000004c4 	andeq	r0, r0, r4, asr #9
    1dbc:	78756128 	ldmdavc	r5!, {r3, r5, r8, sp, lr}^
    1dc0:	14080100 	strne	r0, [r8], #-256	; 0xffffff00
    1dc4:	000004b8 			; <UNDEFINED> instruction: 0x000004b8
    1dc8:	07e12900 	strbeq	r2, [r1, r0, lsl #18]!
    1dcc:	0dc20000 	stcleq	0, cr0, [r2]
    1dd0:	081f0000 	ldmdaeq	pc, {}	; <UNPREDICTABLE>
    1dd4:	92a40000 	adcls	r0, r4, #0
    1dd8:	00a40000 	adceq	r0, r4, r0
    1ddc:	9c010000 	stcls	0, cr0, [r1], {-0}
    1de0:	0007f22a 	andeq	pc, r7, sl, lsr #4
    1de4:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1de8:	0007fb2a 	andeq	pc, r7, sl, lsr #22
    1dec:	70910200 	addsvc	r0, r1, r0, lsl #4
    1df0:	09640000 	stmdbeq	r4!, {}^	; <UNPREDICTABLE>
    1df4:	00040000 	andeq	r0, r4, r0
    1df8:	00000a59 	andeq	r0, r0, r9, asr sl
    1dfc:	00b50104 	adcseq	r0, r5, r4, lsl #2
    1e00:	68040000 	stmdavs	r4, {}	; <UNPREDICTABLE>
    1e04:	74000011 	strvc	r0, [r0], #-17	; 0xffffffef
    1e08:	bc000000 	stclt	0, cr0, [r0], {-0}
    1e0c:	e0000097 	mul	r0, r7, r0
    1e10:	23000005 	movwcs	r0, #5
    1e14:	0200000d 	andeq	r0, r0, #13
    1e18:	036a0801 	cmneq	sl, #65536	; 0x10000
    1e1c:	25030000 	strcs	r0, [r3, #-0]
    1e20:	02000000 	andeq	r0, r0, #0
    1e24:	022a0502 	eoreq	r0, sl, #8388608	; 0x800000
    1e28:	04040000 	streq	r0, [r4], #-0
    1e2c:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
    1e30:	00380500 	eorseq	r0, r8, r0, lsl #10
    1e34:	01020000 	mrseq	r0, (UNDEF: 2)
    1e38:	00036108 	andeq	r6, r3, r8, lsl #2
    1e3c:	07020200 	streq	r0, [r2, -r0, lsl #4]
    1e40:	000003b6 			; <UNDEFINED> instruction: 0x000003b6
    1e44:	00039406 	andeq	r9, r3, r6, lsl #8
    1e48:	070b0600 	streq	r0, [fp, -r0, lsl #12]
    1e4c:	00000063 	andeq	r0, r0, r3, rrx
    1e50:	00005203 	andeq	r5, r0, r3, lsl #4
    1e54:	07040200 	streq	r0, [r4, -r0, lsl #4]
    1e58:	00001a0f 	andeq	r1, r0, pc, lsl #20
    1e5c:	00006303 	andeq	r6, r0, r3, lsl #6
    1e60:	00630500 	rsbeq	r0, r3, r0, lsl #10
    1e64:	68070000 	stmdavs	r7, {}	; <UNPREDICTABLE>
    1e68:	02006c61 	andeq	r6, r0, #24832	; 0x6100
    1e6c:	02a30b07 	adceq	r0, r3, #7168	; 0x1c00
    1e70:	b6080000 	strlt	r0, [r8], -r0
    1e74:	02000004 	andeq	r0, r0, #4
    1e78:	006a1c09 	rsbeq	r1, sl, r9, lsl #24
    1e7c:	b2800000 	addlt	r0, r0, #0
    1e80:	2c080ee6 	stccs	14, cr0, [r8], {230}	; 0xe6
    1e84:	02000003 	andeq	r0, r0, #3
    1e88:	02af1d0c 	adceq	r1, pc, #12, 26	; 0x300
    1e8c:	00000000 	andeq	r0, r0, r0
    1e90:	7d082000 	stcvc	0, cr2, [r8, #-0]
    1e94:	02000003 	andeq	r0, r0, #3
    1e98:	02af1d0f 	adceq	r1, pc, #960	; 0x3c0
    1e9c:	00000000 	andeq	r0, r0, r0
    1ea0:	f4092020 	vst4.8	{d2-d5}, [r9 :128], r0
    1ea4:	02000003 	andeq	r0, r0, #3
    1ea8:	005e1812 	subseq	r1, lr, r2, lsl r8
    1eac:	08360000 	ldmdaeq	r6!, {}	; <UNPREDICTABLE>
    1eb0:	00000478 	andeq	r0, r0, r8, ror r4
    1eb4:	af1d4402 	svcge	0x001d4402
    1eb8:	00000002 	andeq	r0, r0, r2
    1ebc:	0a202150 	beq	80a404 <_bss_end+0x7ff924>
    1ec0:	00000249 	andeq	r0, r0, r9, asr #4
    1ec4:	00380405 	eorseq	r0, r8, r5, lsl #8
    1ec8:	46020000 	strmi	r0, [r2], -r0
    1ecc:	00016a10 	andeq	r6, r1, r0, lsl sl
    1ed0:	52490b00 	subpl	r0, r9, #0, 22
    1ed4:	0c000051 	stceq	0, cr0, [r0], {81}	; 0x51
    1ed8:	00000286 	andeq	r0, r0, r6, lsl #5
    1edc:	04980c01 	ldreq	r0, [r8], #3073	; 0xc01
    1ee0:	0c100000 	ldceq	0, cr0, [r0], {-0}
    1ee4:	0000036f 	andeq	r0, r0, pc, ror #6
    1ee8:	039d0c11 	orrseq	r0, sp, #4352	; 0x1100
    1eec:	0c120000 	ldceq	0, cr0, [r2], {-0}
    1ef0:	000003d1 	ldrdeq	r0, [r0], -r1
    1ef4:	03760c13 	cmneq	r6, #4864	; 0x1300
    1ef8:	0c140000 	ldceq	0, cr0, [r4], {-0}
    1efc:	000004a7 	andeq	r0, r0, r7, lsr #9
    1f00:	04640c15 	strbteq	r0, [r4], #-3093	; 0xfffff3eb
    1f04:	0c160000 	ldceq	0, cr0, [r6], {-0}
    1f08:	000004f2 	strdeq	r0, [r0], -r2
    1f0c:	03a40c17 			; <UNDEFINED> instruction: 0x03a40c17
    1f10:	0c180000 	ldceq	0, cr0, [r8], {-0}
    1f14:	00000481 	andeq	r0, r0, r1, lsl #9
    1f18:	03e20c19 	mvneq	r0, #6400	; 0x1900
    1f1c:	0c1a0000 	ldceq	0, cr0, [sl], {-0}
    1f20:	00000316 	andeq	r0, r0, r6, lsl r3
    1f24:	03210c20 			; <UNDEFINED> instruction: 0x03210c20
    1f28:	0c210000 	stceq	0, cr0, [r1], #-0
    1f2c:	000003ea 	andeq	r0, r0, sl, ror #7
    1f30:	02fa0c22 	rscseq	r0, sl, #8704	; 0x2200
    1f34:	0c240000 	stceq	0, cr0, [r4], #-0
    1f38:	000003d8 	ldrdeq	r0, [r0], -r8
    1f3c:	034b0c25 	movteq	r0, #48165	; 0xbc25
    1f40:	0c300000 	ldceq	0, cr0, [r0], #-0
    1f44:	00000356 	andeq	r0, r0, r6, asr r3
    1f48:	023e0c31 	eorseq	r0, lr, #12544	; 0x3100
    1f4c:	0c320000 	ldceq	0, cr0, [r2], #-0
    1f50:	000003c9 	andeq	r0, r0, r9, asr #7
    1f54:	02340c34 	eorseq	r0, r4, #52, 24	; 0x3400
    1f58:	00350000 	eorseq	r0, r5, r0
    1f5c:	0002b60a 	andeq	fp, r2, sl, lsl #12
    1f60:	38040500 	stmdacc	r4, {r8, sl}
    1f64:	02000000 	andeq	r0, r0, #0
    1f68:	018f106c 	orreq	r1, pc, ip, rrx
    1f6c:	9e0c0000 	cdpls	0, 0, cr0, cr12, cr0, {0}
    1f70:	00000004 	andeq	r0, r0, r4
    1f74:	0003ac0c 	andeq	sl, r3, ip, lsl #24
    1f78:	b10c0100 	mrslt	r0, (UNDEF: 28)
    1f7c:	02000003 	andeq	r0, r0, #3
    1f80:	043d0800 	ldrteq	r0, [sp], #-2048	; 0xfffff800
    1f84:	73020000 	movwvc	r0, #8192	; 0x2000
    1f88:	0002af1d 	andeq	sl, r2, sp, lsl pc
    1f8c:	00b20000 	adcseq	r0, r2, r0
    1f90:	10850a20 	addne	r0, r5, r0, lsr #20
    1f94:	04050000 	streq	r0, [r5], #-0
    1f98:	00000038 	andeq	r0, r0, r8, lsr r0
    1f9c:	ee107502 	cfmul32	mvfx7, mvfx0, mvfx2
    1fa0:	0c000001 	stceq	0, cr0, [r0], {1}
    1fa4:	00001156 	andeq	r1, r0, r6, asr r1
    1fa8:	13290c00 			; <UNDEFINED> instruction: 0x13290c00
    1fac:	0c010000 	stceq	0, cr0, [r1], {-0}
    1fb0:	00001337 	andeq	r1, r0, r7, lsr r3
    1fb4:	12e50c02 	rscne	r0, r5, #512	; 0x200
    1fb8:	0c030000 	stceq	0, cr0, [r3], {-0}
    1fbc:	00001024 	andeq	r1, r0, r4, lsr #32
    1fc0:	10310c04 	eorsne	r0, r1, r4, lsl #24
    1fc4:	0c050000 	stceq	0, cr0, [r5], {-0}
    1fc8:	000012fd 	strdeq	r1, [r0], -sp
    1fcc:	13900c06 	orrsne	r0, r0, #1536	; 0x600
    1fd0:	0c070000 	stceq	0, cr0, [r7], {-0}
    1fd4:	0000139e 	muleq	r0, lr, r3
    1fd8:	11dd0c08 	bicsne	r0, sp, r8, lsl #24
    1fdc:	00090000 	andeq	r0, r9, r0
    1fe0:	0010cc0a 	andseq	ip, r0, sl, lsl #24
    1fe4:	38040500 	stmdacc	r4, {r8, sl}
    1fe8:	02000000 	andeq	r0, r0, #0
    1fec:	02311083 	eorseq	r1, r1, #131	; 0x83
    1ff0:	fe0c0000 	cdp2	0, 0, cr0, cr12, cr0, {0}
    1ff4:	00000010 	andeq	r0, r0, r0, lsl r0
    1ff8:	000fef0c 	andeq	lr, pc, ip, lsl #30
    1ffc:	120c0100 	andne	r0, ip, #0, 2
    2000:	02000012 	andeq	r0, r0, #18
    2004:	00121d0c 	andseq	r1, r2, ip, lsl #26
    2008:	000c0300 	andeq	r0, ip, r0, lsl #6
    200c:	04000012 	streq	r0, [r0], #-18	; 0xffffffee
    2010:	000fe50c 	andeq	lr, pc, ip, lsl #10
    2014:	aa0c0500 	bge	30341c <_bss_end+0x2f893c>
    2018:	06000010 			; <UNDEFINED> instruction: 0x06000010
    201c:	0010bb0c 	andseq	fp, r0, ip, lsl #22
    2020:	0a000700 	beq	3c28 <CPSR_IRQ_INHIBIT+0x3ba8>
    2024:	00001345 	andeq	r1, r0, r5, asr #6
    2028:	00380405 	eorseq	r0, r8, r5, lsl #8
    202c:	8f020000 	svchi	0x00020000
    2030:	00029210 	andeq	r9, r2, r0, lsl r2
    2034:	55410b00 	strbpl	r0, [r1, #-2816]	; 0xfffff500
    2038:	0c1d0058 	ldceq	0, cr0, [sp], {88}	; 0x58
    203c:	000012d2 	ldrdeq	r1, [r0], -r2
    2040:	13ac0c2b 			; <UNDEFINED> instruction: 0x13ac0c2b
    2044:	0c2d0000 	stceq	0, cr0, [sp], #-0
    2048:	000013b2 			; <UNDEFINED> instruction: 0x000013b2
    204c:	4d530b2e 	vldrmi	d16, [r3, #-184]	; 0xffffff48
    2050:	0c300049 	ldceq	0, cr0, [r0], #-292	; 0xfffffedc
    2054:	00001350 	andeq	r1, r0, r0, asr r3
    2058:	13570c31 	cmpne	r7, #12544	; 0x3100
    205c:	0c320000 	ldceq	0, cr0, [r2], #-0
    2060:	0000135e 	andeq	r1, r0, lr, asr r3
    2064:	13650c33 	cmnne	r5, #13056	; 0x3300
    2068:	0b340000 	bleq	d02070 <_bss_end+0xcf7590>
    206c:	00433249 	subeq	r3, r3, r9, asr #4
    2070:	50530b35 	subspl	r0, r3, r5, lsr fp
    2074:	0b360049 	bleq	d821a0 <_bss_end+0xd776c0>
    2078:	004d4350 	subeq	r4, sp, r0, asr r3
    207c:	0df30c37 	ldcleq	12, cr0, [r3, #220]!	; 0xdc
    2080:	00390000 	eorseq	r0, r9, r0
    2084:	00021f08 	andeq	r1, r2, r8, lsl #30
    2088:	1da60200 	sfmne	f0, 4, [r6]
    208c:	000002af 	andeq	r0, r0, pc, lsr #5
    2090:	2000b400 	andcs	fp, r0, r0, lsl #8
    2094:	00800d00 	addeq	r0, r0, r0, lsl #26
    2098:	04020000 	streq	r0, [r2], #-0
    209c:	001a0a07 	andseq	r0, sl, r7, lsl #20
    20a0:	02a80300 	adceq	r0, r8, #0, 6
    20a4:	900d0000 	andls	r0, sp, r0
    20a8:	0d000000 	stceq	0, cr0, [r0, #-0]
    20ac:	000000a0 	andeq	r0, r0, r0, lsr #1
    20b0:	0000b00d 	andeq	fp, r0, sp
    20b4:	00bd0d00 	adcseq	r0, sp, r0, lsl #26
    20b8:	8f0d0000 	svchi	0x000d0000
    20bc:	0d000001 	stceq	0, cr0, [r0, #-4]
    20c0:	00000292 	muleq	r0, r2, r2
    20c4:	0063040e 	rsbeq	r0, r3, lr, lsl #8
    20c8:	d2030000 	andle	r0, r3, #0
    20cc:	02000002 	andeq	r0, r0, #2
    20d0:	06700201 	ldrbteq	r0, [r0], -r1, lsl #4
    20d4:	d00f0000 	andle	r0, pc, r0
    20d8:	0400000d 	streq	r0, [r0], #-13
    20dc:	a8070603 	stmdage	r7, {r0, r1, r9, sl}
    20e0:	10000003 	andne	r0, r0, r3
    20e4:	00000248 	andeq	r0, r0, r8, asr #4
    20e8:	d8190a03 	ldmdale	r9, {r0, r1, r9, fp}
    20ec:	00000002 	andeq	r0, r0, r2
    20f0:	000dd011 	andeq	sp, sp, r1, lsl r0
    20f4:	050d0300 	streq	r0, [sp, #-768]	; 0xfffffd00
    20f8:	000002c6 	andeq	r0, r0, r6, asr #5
    20fc:	000003a8 	andeq	r0, r0, r8, lsr #7
    2100:	00031701 	andeq	r1, r3, r1, lsl #14
    2104:	00032200 	andeq	r2, r3, r0, lsl #4
    2108:	03a81200 			; <UNDEFINED> instruction: 0x03a81200
    210c:	63130000 	tstvs	r3, #0
    2110:	00000000 	andeq	r0, r0, r0
    2114:	00130714 	andseq	r0, r3, r4, lsl r7
    2118:	0a100300 	beq	402d20 <_bss_end+0x3f8240>
    211c:	0000028e 	andeq	r0, r0, lr, lsl #5
    2120:	00033701 	andeq	r3, r3, r1, lsl #14
    2124:	00034200 	andeq	r4, r3, r0, lsl #4
    2128:	03a81200 			; <UNDEFINED> instruction: 0x03a81200
    212c:	6a130000 	bvs	4c2134 <_bss_end+0x4b7654>
    2130:	00000001 	andeq	r0, r0, r1
    2134:	0011e714 	andseq	lr, r1, r4, lsl r7
    2138:	0a120300 	beq	482d40 <_bss_end+0x478260>
    213c:	000004c9 	andeq	r0, r0, r9, asr #9
    2140:	00035701 	andeq	r5, r3, r1, lsl #14
    2144:	00036200 	andeq	r6, r3, r0, lsl #4
    2148:	03a81200 			; <UNDEFINED> instruction: 0x03a81200
    214c:	6a130000 	bvs	4c2154 <_bss_end+0x4b7674>
    2150:	00000001 	andeq	r0, r0, r1
    2154:	00045714 	andeq	r5, r4, r4, lsl r7
    2158:	0a150300 	beq	542d60 <_bss_end+0x538280>
    215c:	000002d3 	ldrdeq	r0, [r0], -r3
    2160:	00037701 	andeq	r7, r3, r1, lsl #14
    2164:	00038700 	andeq	r8, r3, r0, lsl #14
    2168:	03a81200 			; <UNDEFINED> instruction: 0x03a81200
    216c:	cd130000 	ldcgt	0, cr0, [r3, #-0]
    2170:	13000000 	movwne	r0, #0
    2174:	00000052 	andeq	r0, r0, r2, asr r0
    2178:	046b1500 	strbteq	r1, [fp], #-1280	; 0xfffffb00
    217c:	17030000 	strne	r0, [r3, -r0]
    2180:	0002510e 	andeq	r5, r2, lr, lsl #2
    2184:	00005200 	andeq	r5, r0, r0, lsl #4
    2188:	039c0100 	orrseq	r0, ip, #0, 2
    218c:	a8120000 	ldmdage	r2, {}	; <UNPREDICTABLE>
    2190:	13000003 	movwne	r0, #3
    2194:	000000cd 	andeq	r0, r0, sp, asr #1
    2198:	040e0000 	streq	r0, [lr], #-0
    219c:	000002e4 	andeq	r0, r0, r4, ror #5
    21a0:	000edc0a 	andeq	sp, lr, sl, lsl #24
    21a4:	38040500 	stmdacc	r4, {r8, sl}
    21a8:	04000000 	streq	r0, [r0], #-0
    21ac:	03cd0c06 	biceq	r0, sp, #1536	; 0x600
    21b0:	920c0000 	andls	r0, ip, #0
    21b4:	0000000d 	andeq	r0, r0, sp
    21b8:	000da90c 	andeq	sl, sp, ip, lsl #18
    21bc:	0a000100 	beq	25c4 <CPSR_IRQ_INHIBIT+0x2544>
    21c0:	00000e64 	andeq	r0, r0, r4, ror #28
    21c4:	00380405 	eorseq	r0, r8, r5, lsl #8
    21c8:	0c040000 	stceq	0, cr0, [r4], {-0}
    21cc:	00041a0c 	andeq	r1, r4, ip, lsl #20
    21d0:	0e411600 	cdpeq	6, 4, cr1, cr1, cr0, {0}
    21d4:	04b00000 	ldrteq	r0, [r0], #0
    21d8:	000d0f16 	andeq	r0, sp, r6, lsl pc
    21dc:	16096000 	strne	r6, [r9], -r0
    21e0:	00000d38 	andeq	r0, r0, r8, lsr sp
    21e4:	021612c0 	andseq	r1, r6, #192, 4
    21e8:	8000000f 	andhi	r0, r0, pc
    21ec:	0e0e1625 	cfmadd32eq	mvax1, mvfx1, mvfx14, mvfx5
    21f0:	4b000000 	blmi	21f8 <CPSR_IRQ_INHIBIT+0x2178>
    21f4:	000e1716 	andeq	r1, lr, r6, lsl r7
    21f8:	16960000 	ldrne	r0, [r6], r0
    21fc:	00000e20 	andeq	r0, r0, r0, lsr #28
    2200:	3717e100 	ldrcc	lr, [r7, -r0, lsl #2]
    2204:	0000000e 	andeq	r0, r0, lr
    2208:	000001c2 	andeq	r0, r0, r2, asr #3
    220c:	000df20f 	andeq	pc, sp, pc, lsl #4
    2210:	18040400 	stmdane	r4, {sl}
    2214:	0005b007 	andeq	fp, r5, r7
    2218:	0d331000 	ldceq	0, cr1, [r3, #-0]
    221c:	1b040000 	blne	102224 <_bss_end+0xf7744>
    2220:	0005b00b 	andeq	fp, r5, fp
    2224:	f2110000 	vhadd.s16	d0, d1, d0
    2228:	0400000d 	streq	r0, [r0], #-13
    222c:	0e86051e 	mcreq	5, 4, r0, cr6, cr14, {0}
    2230:	05b60000 	ldreq	r0, [r6, #0]!
    2234:	4d010000 	stcmi	0, cr0, [r1, #-0]
    2238:	58000004 	stmdapl	r0, {r2}
    223c:	12000004 	andne	r0, r0, #4
    2240:	000005b6 			; <UNDEFINED> instruction: 0x000005b6
    2244:	0005b013 	andeq	fp, r5, r3, lsl r0
    2248:	99140000 	ldmdbls	r4, {}	; <UNPREDICTABLE>
    224c:	0400000d 	streq	r0, [r0], #-13
    2250:	0ebf0a20 			; <UNDEFINED> instruction: 0x0ebf0a20
    2254:	6d010000 	stcvs	0, cr0, [r1, #-0]
    2258:	78000004 	stmdavc	r0, {r2}
    225c:	12000004 	andne	r0, r0, #4
    2260:	000005b6 			; <UNDEFINED> instruction: 0x000005b6
    2264:	0003ae13 	andeq	sl, r3, r3, lsl lr
    2268:	29140000 	ldmdbcs	r4, {}	; <UNPREDICTABLE>
    226c:	0400000e 	streq	r0, [r0], #-14
    2270:	0e490a21 	vmlaeq.f32	s1, s18, s3
    2274:	8d010000 	stchi	0, cr0, [r1, #-0]
    2278:	98000004 	stmdals	r0, {r2}
    227c:	12000004 	andne	r0, r0, #4
    2280:	000005b6 			; <UNDEFINED> instruction: 0x000005b6
    2284:	0003cd13 	andeq	ip, r3, r3, lsl sp
    2288:	17140000 	ldrne	r0, [r4, -r0]
    228c:	0400000d 	streq	r0, [r0], #-13
    2290:	0e740a25 	vaddeq.f32	s1, s8, s11
    2294:	ad010000 	stcge	0, cr0, [r1, #-0]
    2298:	b8000004 	stmdalt	r0, {r2}
    229c:	12000004 	andne	r0, r0, #4
    22a0:	000005b6 			; <UNDEFINED> instruction: 0x000005b6
    22a4:	00002513 	andeq	r2, r0, r3, lsl r5
    22a8:	17140000 	ldrne	r0, [r4, -r0]
    22ac:	0400000d 	streq	r0, [r0], #-13
    22b0:	0eab0a26 	vfmaeq.f32	s0, s22, s13
    22b4:	cd010000 	stcgt	0, cr0, [r1, #-0]
    22b8:	d8000004 	stmdale	r0, {r2}
    22bc:	12000004 	andne	r0, r0, #4
    22c0:	000005b6 			; <UNDEFINED> instruction: 0x000005b6
    22c4:	0005bc13 	andeq	fp, r5, r3, lsl ip
    22c8:	17140000 	ldrne	r0, [r4, -r0]
    22cc:	0400000d 	streq	r0, [r0], #-13
    22d0:	0d6b0a27 	vstmdbeq	fp!, {s1-s39}
    22d4:	ed010000 	stc	0, cr0, [r1, #-0]
    22d8:	fd000004 	stc2	0, cr0, [r0, #-16]
    22dc:	12000004 	andne	r0, r0, #4
    22e0:	000005b6 			; <UNDEFINED> instruction: 0x000005b6
    22e4:	0005bc13 	andeq	fp, r5, r3, lsl ip
    22e8:	00631300 	rsbeq	r1, r3, r0, lsl #6
    22ec:	14000000 	strne	r0, [r0], #-0
    22f0:	00000d17 	andeq	r0, r0, r7, lsl sp
    22f4:	b00a2804 	andlt	r2, sl, r4, lsl #16
    22f8:	0100000d 	tsteq	r0, sp
    22fc:	00000512 	andeq	r0, r0, r2, lsl r5
    2300:	0000051d 	andeq	r0, r0, sp, lsl r5
    2304:	0005b612 	andeq	fp, r5, r2, lsl r6
    2308:	00631300 	rsbeq	r1, r3, r0, lsl #6
    230c:	14000000 	strne	r0, [r0], #-0
    2310:	00000d17 	andeq	r0, r0, r7, lsl sp
    2314:	990a2904 	stmdbls	sl, {r2, r8, fp, sp}
    2318:	0100000e 	tsteq	r0, lr
    231c:	00000532 	andeq	r0, r0, r2, lsr r5
    2320:	0000053d 	andeq	r0, r0, sp, lsr r5
    2324:	0005b612 	andeq	fp, r5, r2, lsl r6
    2328:	00381300 	eorseq	r1, r8, r0, lsl #6
    232c:	14000000 	strne	r0, [r0], #-0
    2330:	00000dd5 	ldrdeq	r0, [r0], -r5
    2334:	1d0a2a04 	vstrne	s4, [sl, #-16]
    2338:	0100000d 	tsteq	r0, sp
    233c:	00000552 	andeq	r0, r0, r2, asr r5
    2340:	0000055d 	andeq	r0, r0, sp, asr r5
    2344:	0005b612 	andeq	fp, r5, r2, lsl r6
    2348:	00631300 	rsbeq	r1, r3, r0, lsl #6
    234c:	14000000 	strne	r0, [r0], #-0
    2350:	00000d61 	andeq	r0, r0, r1, ror #26
    2354:	800a2b04 	andhi	r2, sl, r4, lsl #22
    2358:	0100000d 	tsteq	r0, sp
    235c:	00000572 	andeq	r0, r0, r2, ror r5
    2360:	0000057d 	andeq	r0, r0, sp, ror r5
    2364:	0005b612 	andeq	fp, r5, r2, lsl r6
    2368:	05c21300 	strbeq	r1, [r2, #768]	; 0x300
    236c:	14000000 	strne	r0, [r0], #-0
    2370:	00000ddf 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    2374:	ef0a2d04 	svc	0x000a2d04
    2378:	0100000c 	tsteq	r0, ip
    237c:	00000592 	muleq	r0, r2, r5
    2380:	00000598 	muleq	r0, r8, r5
    2384:	0005b612 	andeq	fp, r5, r2, lsl r6
    2388:	ee180000 	cdp	0, 1, cr0, cr8, cr0, {0}
    238c:	0400000e 	streq	r0, [r0], #-14
    2390:	0d400a2e 	vstreq	s1, [r0, #-184]	; 0xffffff48
    2394:	a9010000 	stmdbge	r1, {}	; <UNPREDICTABLE>
    2398:	12000005 	andne	r0, r0, #5
    239c:	000005b6 			; <UNDEFINED> instruction: 0x000005b6
    23a0:	04190000 	ldreq	r0, [r9], #-0
    23a4:	000002e4 	andeq	r0, r0, r4, ror #5
    23a8:	041a040e 	ldreq	r0, [sl], #-1038	; 0xfffffbf2
    23ac:	040e0000 	streq	r0, [lr], #-0
    23b0:	0000002c 	andeq	r0, r0, ip, lsr #32
    23b4:	0025040e 	eoreq	r0, r5, lr, lsl #8
    23b8:	071a0000 	ldreq	r0, [sl, -r0]
    23bc:	0400000e 	streq	r0, [r0], #-14
    23c0:	041a0e31 	ldreq	r0, [sl], #-3633	; 0xfffff1cf
    23c4:	c70f0000 	strgt	r0, [pc, -r0]
    23c8:	04000011 	streq	r0, [r0], #-17	; 0xffffffef
    23cc:	b3070a05 	movwlt	r0, #31237	; 0x7a05
    23d0:	10000006 	andne	r0, r0, r6
    23d4:	00001255 	andeq	r1, r0, r5, asr r2
    23d8:	b31c0e05 	tstlt	ip, #5, 28	; 0x50
    23dc:	00000006 	andeq	r0, r0, r6
    23e0:	00126011 	andseq	r6, r2, r1, lsl r0
    23e4:	1c110500 	cfldr32ne	mvfx0, [r1], {-0}
    23e8:	00000fa4 	andeq	r0, r0, r4, lsr #31
    23ec:	000006b9 			; <UNDEFINED> instruction: 0x000006b9
    23f0:	00060702 	andeq	r0, r6, r2, lsl #14
    23f4:	00061200 	andeq	r1, r6, r0, lsl #4
    23f8:	06bf1200 	ldrteq	r1, [pc], r0, lsl #4
    23fc:	9f130000 	svcls	0x00130000
    2400:	00000001 	andeq	r0, r0, r1
    2404:	0011c711 	andseq	ip, r1, r1, lsl r7
    2408:	05140500 	ldreq	r0, [r4, #-1280]	; 0xfffffb00
    240c:	000012ab 	andeq	r1, r0, fp, lsr #5
    2410:	000006bf 			; <UNDEFINED> instruction: 0x000006bf
    2414:	00062b01 	andeq	r2, r6, r1, lsl #22
    2418:	00063600 	andeq	r3, r6, r0, lsl #12
    241c:	06bf1200 	ldrteq	r1, [pc], r0, lsl #4
    2420:	a8130000 	ldmdage	r3, {}	; <UNPREDICTABLE>
    2424:	00000002 	andeq	r0, r0, r2
    2428:	0011ef14 	andseq	lr, r1, r4, lsl pc
    242c:	0a170500 	beq	5c3834 <_bss_end+0x5b8d54>
    2430:	00001265 	andeq	r1, r0, r5, ror #4
    2434:	00064b01 	andeq	r4, r6, r1, lsl #22
    2438:	00065600 	andeq	r5, r6, r0, lsl #12
    243c:	06bf1200 	ldrteq	r1, [pc], r0, lsl #4
    2440:	ee130000 	cdp	0, 1, cr0, cr3, cr0, {0}
    2444:	00000001 	andeq	r0, r0, r1
    2448:	00136c14 	andseq	r6, r3, r4, lsl ip
    244c:	0a190500 	beq	643854 <_bss_end+0x638d74>
    2450:	0000103e 	andeq	r1, r0, lr, lsr r0
    2454:	00066b01 	andeq	r6, r6, r1, lsl #22
    2458:	00067600 	andeq	r7, r6, r0, lsl #12
    245c:	06bf1200 	ldrteq	r1, [pc], r0, lsl #4
    2460:	ee130000 	cdp	0, 1, cr0, cr3, cr0, {0}
    2464:	00000001 	andeq	r0, r0, r1
    2468:	000ff714 	andeq	pc, pc, r4, lsl r7	; <UNPREDICTABLE>
    246c:	0a1c0500 	beq	703874 <_bss_end+0x6f8d94>
    2470:	00000f61 	andeq	r0, r0, r1, ror #30
    2474:	00068b01 	andeq	r8, r6, r1, lsl #22
    2478:	00069600 	andeq	r9, r6, r0, lsl #12
    247c:	06bf1200 	ldrteq	r1, [pc], r0, lsl #4
    2480:	31130000 	tstcc	r3, r0
    2484:	00000002 	andeq	r0, r0, r2
    2488:	00109e18 	andseq	r9, r0, r8, lsl lr
    248c:	0a1e0500 	beq	783894 <_bss_end+0x778db4>
    2490:	00001104 	andeq	r1, r0, r4, lsl #2
    2494:	0006a701 	andeq	sl, r6, r1, lsl #14
    2498:	06bf1200 	ldrteq	r1, [pc], r0, lsl #4
    249c:	31130000 	tstcc	r3, r0
    24a0:	00000002 	andeq	r0, r0, r2
    24a4:	6f040e00 	svcvs	0x00040e00
    24a8:	19000000 	stmdbne	r0, {}	; <UNPREDICTABLE>
    24ac:	00006f04 	andeq	r6, r0, r4, lsl #30
    24b0:	d4040e00 	strle	r0, [r4], #-3584	; 0xfffff200
    24b4:	03000005 	movweq	r0, #5
    24b8:	000006bf 			; <UNDEFINED> instruction: 0x000006bf
    24bc:	0012281a 	andseq	r2, r2, sl, lsl r8
    24c0:	1e210500 	cfsh64ne	mvdx0, mvdx1, #0
    24c4:	000005d4 	ldrdeq	r0, [r0], -r4
    24c8:	0010111b 	andseq	r1, r0, fp, lsl r1
    24cc:	0e070100 	adfeqs	f0, f7, f0
    24d0:	0000003f 	andeq	r0, r0, pc, lsr r0
    24d4:	aac00305 	bge	ff0030f0 <_bss_end+0xfeff8610>
    24d8:	0a1b0000 	beq	6c24e0 <_bss_end+0x6b7a00>
    24dc:	01000012 	tsteq	r0, r2, lsl r0
    24e0:	003f0e08 	eorseq	r0, pc, r8, lsl #28
    24e4:	03050000 	movweq	r0, #20480	; 0x5000
    24e8:	0000aa68 	andeq	sl, r0, r8, ror #20
    24ec:	00101c1b 	andseq	r1, r0, fp, lsl ip
    24f0:	0e090100 	adfeqe	f0, f1, f0
    24f4:	0000003f 	andeq	r0, r0, pc, lsr r0
    24f8:	aac40305 	bge	ff103114 <_bss_end+0xff0f8634>
    24fc:	7e1b0000 	cdpvc	0, 1, cr0, cr11, cr0, {0}
    2500:	01000013 	tsteq	r0, r3, lsl r0
    2504:	003f0e0a 	eorseq	r0, pc, sl, lsl #28
    2508:	03050000 	movweq	r0, #20480	; 0x5000
    250c:	0000aac8 	andeq	sl, r0, r8, asr #21
    2510:	0006ca1c 	andeq	ip, r6, ip, lsl sl
    2514:	176f0100 	strbne	r0, [pc, -r0, lsl #2]!
    2518:	aacc0305 	bge	ff303134 <_bss_end+0xff2f8654>
    251c:	021d0000 	andseq	r0, sp, #0
    2520:	80000010 	andhi	r0, r0, r0, lsl r0
    2524:	1c00009d 	stcne	0, cr0, [r0], {157}	; 0x9d
    2528:	01000000 	mrseq	r0, (UNDEF: 0)
    252c:	04031e9c 	streq	r1, [r3], #-3740	; 0xfffff164
    2530:	9d2c0000 	stcls	0, cr0, [ip, #-0]
    2534:	00540000 	subseq	r0, r4, r0
    2538:	9c010000 	stcls	0, cr0, [r1], {-0}
    253c:	0000076d 	andeq	r0, r0, sp, ror #14
    2540:	00033c1f 	andeq	r3, r3, pc, lsl ip
    2544:	01930100 	orrseq	r0, r3, r0, lsl #2
    2548:	00000038 	andeq	r0, r0, r8, lsr r0
    254c:	1f749102 	svcne	0x00749102
    2550:	0000042d 	andeq	r0, r0, sp, lsr #8
    2554:	38019301 	stmdacc	r1, {r0, r8, r9, ip, pc}
    2558:	02000000 	andeq	r0, r0, #0
    255c:	20007091 	mulcs	r0, r1, r0
    2560:	00000696 	muleq	r0, r6, r6
    2564:	87068d01 	strhi	r8, [r6, -r1, lsl #26]
    2568:	c4000007 	strgt	r0, [r0], #-7
    256c:	6800009c 	stmdavs	r0, {r2, r3, r4, r7}
    2570:	01000000 	mrseq	r0, (UNDEF: 0)
    2574:	0007b29c 	muleq	r7, ip, r2
    2578:	04382100 	ldrteq	r2, [r8], #-256	; 0xffffff00
    257c:	06c50000 	strbeq	r0, [r5], r0
    2580:	91020000 	mrsls	r0, (UNDEF: 2)
    2584:	13851f64 	orrne	r1, r5, #100, 30	; 0x190
    2588:	8d010000 	stchi	0, cr0, [r1, #-0]
    258c:	00023139 	andeq	r3, r2, r9, lsr r1
    2590:	60910200 	addsvs	r0, r1, r0, lsl #4
    2594:	000f9b22 	andeq	r9, pc, r2, lsr #22
    2598:	188f0100 	stmne	pc, {r8}	; <UNPREDICTABLE>
    259c:	0000006a 	andeq	r0, r0, sl, rrx
    25a0:	006c9102 	rsbeq	r9, ip, r2, lsl #2
    25a4:	00067620 	andeq	r7, r6, r0, lsr #12
    25a8:	06850100 	streq	r0, [r5], r0, lsl #2
    25ac:	000007cc 	andeq	r0, r0, ip, asr #15
    25b0:	00009c5c 	andeq	r9, r0, ip, asr ip
    25b4:	00000068 	andeq	r0, r0, r8, rrx
    25b8:	07f79c01 	ldrbeq	r9, [r7, r1, lsl #24]!
    25bc:	38210000 	stmdacc	r1!, {}	; <UNPREDICTABLE>
    25c0:	c5000004 	strgt	r0, [r0, #-4]
    25c4:	02000006 	andeq	r0, r0, #6
    25c8:	851f6491 	ldrhi	r6, [pc, #-1169]	; 213f <CPSR_IRQ_INHIBIT+0x20bf>
    25cc:	01000013 	tsteq	r0, r3, lsl r0
    25d0:	02313885 	eorseq	r3, r1, #8716288	; 0x850000
    25d4:	91020000 	mrsls	r0, (UNDEF: 2)
    25d8:	0f9b2260 	svceq	0x009b2260
    25dc:	87010000 	strhi	r0, [r1, -r0]
    25e0:	00006a18 	andeq	r6, r0, r8, lsl sl
    25e4:	6c910200 	lfmvs	f0, 4, [r1], {0}
    25e8:	06562000 	ldrbeq	r2, [r6], -r0
    25ec:	80010000 	andhi	r0, r1, r0
    25f0:	00081106 	andeq	r1, r8, r6, lsl #2
    25f4:	009c1800 	addseq	r1, ip, r0, lsl #16
    25f8:	00004400 	andeq	r4, r0, r0, lsl #8
    25fc:	2d9c0100 	ldfcss	f0, [ip]
    2600:	21000008 	tstcs	r0, r8
    2604:	00000438 	andeq	r0, r0, r8, lsr r4
    2608:	000006c5 	andeq	r0, r0, r5, asr #13
    260c:	1f6c9102 	svcne	0x006c9102
    2610:	00001385 	andeq	r1, r0, r5, lsl #7
    2614:	ee458001 	cdp	0, 4, cr8, cr5, cr1, {0}
    2618:	02000001 	andeq	r0, r0, #1
    261c:	20006891 	mulcs	r0, r1, r8
    2620:	00000636 	andeq	r0, r0, r6, lsr r6
    2624:	47067b01 	strmi	r7, [r6, -r1, lsl #22]
    2628:	d4000008 	strle	r0, [r0], #-8
    262c:	4400009b 	strmi	r0, [r0], #-155	; 0xffffff65
    2630:	01000000 	mrseq	r0, (UNDEF: 0)
    2634:	0008639c 	muleq	r8, ip, r3
    2638:	04382100 	ldrteq	r2, [r8], #-256	; 0xffffff00
    263c:	06c50000 	strbeq	r0, [r5], r0
    2640:	91020000 	mrsls	r0, (UNDEF: 2)
    2644:	13851f6c 	orrne	r1, r5, #108, 30	; 0x1b0
    2648:	7b010000 	blvc	42650 <_bss_end+0x37b70>
    264c:	0001ee44 	andeq	lr, r1, r4, asr #28
    2650:	68910200 	ldmvs	r1, {r9}
    2654:	05ee2300 	strbeq	r2, [lr, #768]!	; 0x300
    2658:	76010000 	strvc	r0, [r1], -r0
    265c:	00087d18 	andeq	r7, r8, r8, lsl sp
    2660:	009b9c00 	addseq	r9, fp, r0, lsl #24
    2664:	00003800 	andeq	r3, r0, r0, lsl #16
    2668:	999c0100 	ldmibls	ip, {r8}
    266c:	21000008 	tstcs	r0, r8
    2670:	00000438 	andeq	r0, r0, r8, lsr r4
    2674:	000006c5 	andeq	r0, r0, r5, asr #13
    2678:	24749102 	ldrbtcs	r9, [r4], #-258	; 0xfffffefe
    267c:	00676572 	rsbeq	r6, r7, r2, ror r5
    2680:	9f527601 	svcls	0x00527601
    2684:	02000001 	andeq	r0, r0, #1
    2688:	25007091 	strcs	r7, [r0, #-145]	; 0xffffff6f
    268c:	00000612 	andeq	r0, r0, r2, lsl r6
    2690:	aa017101 	bge	5ea9c <_bss_end+0x53fbc>
    2694:	00000008 	andeq	r0, r0, r8
    2698:	000008c0 	andeq	r0, r0, r0, asr #17
    269c:	00043826 	andeq	r3, r4, r6, lsr #16
    26a0:	0006c500 	andeq	ip, r6, r0, lsl #10
    26a4:	17092700 	strne	r2, [r9, -r0, lsl #14]
    26a8:	71010000 	mrsvc	r0, (UNDEF: 1)
    26ac:	0002a83c 	andeq	sl, r2, ip, lsr r8
    26b0:	99280000 	stmdbls	r8!, {}	; <UNPREDICTABLE>
    26b4:	36000008 	strcc	r0, [r0], -r8
    26b8:	db000012 	blle	2708 <CPSR_IRQ_INHIBIT+0x2688>
    26bc:	68000008 	stmdavs	r0, {r3}
    26c0:	3400009b 	strcc	r0, [r0], #-155	; 0xffffff65
    26c4:	01000000 	mrseq	r0, (UNDEF: 0)
    26c8:	0008ec9c 	muleq	r8, ip, ip
    26cc:	08aa2900 	stmiaeq	sl!, {r8, fp, sp}
    26d0:	91020000 	mrsls	r0, (UNDEF: 2)
    26d4:	08b32974 	ldmeq	r3!, {r2, r4, r5, r6, r8, fp, sp}
    26d8:	91020000 	mrsls	r0, (UNDEF: 2)
    26dc:	3f2a0070 	svccc	0x002a0070
    26e0:	01000011 	tsteq	r0, r1, lsl r0
    26e4:	9b58336b 	blls	160f498 <_bss_end+0x16049b8>
    26e8:	00100000 	andseq	r0, r0, r0
    26ec:	9c010000 	stcls	0, cr0, [r1], {-0}
    26f0:	0012f12b 	andseq	pc, r2, fp, lsr #2
    26f4:	33600100 	cmncc	r0, #0, 2
    26f8:	00009b00 	andeq	r9, r0, r0, lsl #22
    26fc:	00000058 	andeq	r0, r0, r8, asr r0
    2700:	09229c01 	stmdbeq	r2!, {r0, sl, fp, ip, pc}
    2704:	632c0000 			; <UNDEFINED> instruction: 0x632c0000
    2708:	0a620100 	beq	1882b10 <_bss_end+0x1878030>
    270c:	00000025 	andeq	r0, r0, r5, lsr #32
    2710:	005f9102 	subseq	r9, pc, r2, lsl #2
    2714:	00130e2a 	andseq	r0, r3, sl, lsr #28
    2718:	335c0100 	cmpcc	ip, #0, 2
    271c:	00009ae8 	andeq	r9, r0, r8, ror #21
    2720:	00000018 	andeq	r0, r0, r8, lsl r0
    2724:	dd2d9c01 	stcle	12, cr9, [sp, #-4]!
    2728:	01000010 	tsteq	r0, r0, lsl r0
    272c:	10eb060c 	rscne	r0, fp, ip, lsl #12
    2730:	97bc0000 	ldrls	r0, [ip, r0]!
    2734:	032c0000 			; <UNDEFINED> instruction: 0x032c0000
    2738:	9c010000 	stcls	0, cr0, [r1], {-0}
    273c:	01006324 	tsteq	r0, r4, lsr #6
    2740:	0025190c 	eoreq	r1, r5, ip, lsl #18
    2744:	91020000 	mrsls	r0, (UNDEF: 2)
    2748:	12ca226f 	sbcne	r2, sl, #-268435450	; 0xf0000006
    274c:	0e010000 	cdpeq	0, 0, cr0, cr1, cr0, {0}
    2750:	0002dd0a 	andeq	sp, r2, sl, lsl #26
    2754:	77910200 	ldrvc	r0, [r1, r0, lsl #4]
    2758:	06df0000 	ldrbeq	r0, [pc], r0
    275c:	00040000 	andeq	r0, r4, r0
    2760:	00000d3b 	andeq	r0, r0, fp, lsr sp
    2764:	00b50104 	adcseq	r0, r5, r4, lsl #2
    2768:	b8040000 	stmdalt	r4, {}	; <UNPREDICTABLE>
    276c:	74000013 	strvc	r0, [r0], #-19	; 0xffffffed
    2770:	9c000000 	stcls	0, cr0, [r0], {-0}
    2774:	7800009d 	stmdavc	r0, {r0, r2, r3, r4, r7}
    2778:	9f000000 	svcls	0x00000000
    277c:	02000010 	andeq	r0, r0, #16
    2780:	036a0801 	cmneq	sl, #65536	; 0x10000
    2784:	25030000 	strcs	r0, [r3, #-0]
    2788:	02000000 	andeq	r0, r0, #0
    278c:	022a0502 	eoreq	r0, sl, #8388608	; 0x800000
    2790:	04040000 	streq	r0, [r4], #-0
    2794:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
    2798:	08010200 	stmdaeq	r1, {r9}
    279c:	00000361 	andeq	r0, r0, r1, ror #6
    27a0:	b6070202 	strlt	r0, [r7], -r2, lsl #4
    27a4:	05000003 	streq	r0, [r0, #-3]
    27a8:	00000394 	muleq	r0, r4, r3
    27ac:	5e070b06 	vmlapl.f64	d0, d7, d6
    27b0:	03000000 	movweq	r0, #0
    27b4:	0000004d 	andeq	r0, r0, sp, asr #32
    27b8:	0f070402 	svceq	0x00070402
    27bc:	0300001a 	movweq	r0, #26
    27c0:	0000005e 	andeq	r0, r0, lr, asr r0
    27c4:	00005e06 	andeq	r5, r0, r6, lsl #28
    27c8:	5e040700 	cdppl	7, 0, cr0, cr4, cr0, {0}
    27cc:	03000000 	movweq	r0, #0
    27d0:	0000006f 	andeq	r0, r0, pc, rrx
    27d4:	70020102 	andvc	r0, r2, r2, lsl #2
    27d8:	08000006 	stmdaeq	r0, {r1, r2}
    27dc:	006c6168 	rsbeq	r6, ip, r8, ror #2
    27e0:	b00b0702 	andlt	r0, fp, r2, lsl #14
    27e4:	09000002 	stmdbeq	r0, {r1}
    27e8:	000004b6 			; <UNDEFINED> instruction: 0x000004b6
    27ec:	651c0902 	ldrvs	r0, [ip, #-2306]	; 0xfffff6fe
    27f0:	80000000 	andhi	r0, r0, r0
    27f4:	090ee6b2 	stmdbeq	lr, {r1, r4, r5, r7, r9, sl, sp, lr, pc}
    27f8:	0000032c 	andeq	r0, r0, ip, lsr #6
    27fc:	bc1d0c02 	ldclt	12, cr0, [sp], {2}
    2800:	00000002 	andeq	r0, r0, r2
    2804:	09200000 	stmdbeq	r0!, {}	; <UNPREDICTABLE>
    2808:	0000037d 	andeq	r0, r0, sp, ror r3
    280c:	bc1d0f02 	ldclt	15, cr0, [sp], {2}
    2810:	00000002 	andeq	r0, r0, r2
    2814:	0a202000 	beq	80a81c <_bss_end+0x7ffd3c>
    2818:	000003f4 	strdeq	r0, [r0], -r4
    281c:	59181202 	ldmdbpl	r8, {r1, r9, ip}
    2820:	36000000 	strcc	r0, [r0], -r0
    2824:	00047809 	andeq	r7, r4, r9, lsl #16
    2828:	1d440200 	sfmne	f0, 2, [r4, #-0]
    282c:	000002bc 			; <UNDEFINED> instruction: 0x000002bc
    2830:	20215000 	eorcs	r5, r1, r0
    2834:	0002490b 	andeq	r4, r2, fp, lsl #18
    2838:	38040500 	stmdacc	r4, {r8, sl}
    283c:	02000000 	andeq	r0, r0, #0
    2840:	01771046 	cmneq	r7, r6, asr #32
    2844:	490c0000 	stmdbmi	ip, {}	; <UNPREDICTABLE>
    2848:	00005152 	andeq	r5, r0, r2, asr r1
    284c:	0002860d 	andeq	r8, r2, sp, lsl #12
    2850:	980d0100 	stmdals	sp, {r8}
    2854:	10000004 	andne	r0, r0, r4
    2858:	00036f0d 	andeq	r6, r3, sp, lsl #30
    285c:	9d0d1100 	stflss	f1, [sp, #-0]
    2860:	12000003 	andne	r0, r0, #3
    2864:	0003d10d 	andeq	sp, r3, sp, lsl #2
    2868:	760d1300 	strvc	r1, [sp], -r0, lsl #6
    286c:	14000003 	strne	r0, [r0], #-3
    2870:	0004a70d 	andeq	sl, r4, sp, lsl #14
    2874:	640d1500 	strvs	r1, [sp], #-1280	; 0xfffffb00
    2878:	16000004 	strne	r0, [r0], -r4
    287c:	0004f20d 	andeq	pc, r4, sp, lsl #4
    2880:	a40d1700 	strge	r1, [sp], #-1792	; 0xfffff900
    2884:	18000003 	stmdane	r0, {r0, r1}
    2888:	0004810d 	andeq	r8, r4, sp, lsl #2
    288c:	e20d1900 	and	r1, sp, #0, 18
    2890:	1a000003 	bne	28a4 <CPSR_IRQ_INHIBIT+0x2824>
    2894:	0003160d 	andeq	r1, r3, sp, lsl #12
    2898:	210d2000 	mrscs	r2, (UNDEF: 13)
    289c:	21000003 	tstcs	r0, r3
    28a0:	0003ea0d 	andeq	lr, r3, sp, lsl #20
    28a4:	fa0d2200 	blx	34b0ac <_bss_end+0x3405cc>
    28a8:	24000002 	strcs	r0, [r0], #-2
    28ac:	0003d80d 	andeq	sp, r3, sp, lsl #16
    28b0:	4b0d2500 	blmi	34bcb8 <_bss_end+0x3411d8>
    28b4:	30000003 	andcc	r0, r0, r3
    28b8:	0003560d 	andeq	r5, r3, sp, lsl #12
    28bc:	3e0d3100 	adfcce	f3, f5, f0
    28c0:	32000002 	andcc	r0, r0, #2
    28c4:	0003c90d 	andeq	ip, r3, sp, lsl #18
    28c8:	340d3400 	strcc	r3, [sp], #-1024	; 0xfffffc00
    28cc:	35000002 	strcc	r0, [r0, #-2]
    28d0:	02b60b00 	adcseq	r0, r6, #0, 22
    28d4:	04050000 	streq	r0, [r5], #-0
    28d8:	00000038 	andeq	r0, r0, r8, lsr r0
    28dc:	9c106c02 	ldcls	12, cr6, [r0], {2}
    28e0:	0d000001 	stceq	0, cr0, [r0, #-4]
    28e4:	0000049e 	muleq	r0, lr, r4
    28e8:	03ac0d00 			; <UNDEFINED> instruction: 0x03ac0d00
    28ec:	0d010000 	stceq	0, cr0, [r1, #-0]
    28f0:	000003b1 			; <UNDEFINED> instruction: 0x000003b1
    28f4:	3d090002 	stccc	0, cr0, [r9, #-8]
    28f8:	02000004 	andeq	r0, r0, #4
    28fc:	02bc1d73 	adcseq	r1, ip, #7360	; 0x1cc0
    2900:	b2000000 	andlt	r0, r0, #0
    2904:	850b2000 	strhi	r2, [fp, #-0]
    2908:	05000010 	streq	r0, [r0, #-16]
    290c:	00003804 	andeq	r3, r0, r4, lsl #16
    2910:	10750200 	rsbsne	r0, r5, r0, lsl #4
    2914:	000001fb 	strdeq	r0, [r0], -fp
    2918:	0011560d 	andseq	r5, r1, sp, lsl #12
    291c:	290d0000 	stmdbcs	sp, {}	; <UNPREDICTABLE>
    2920:	01000013 	tsteq	r0, r3, lsl r0
    2924:	0013370d 	andseq	r3, r3, sp, lsl #14
    2928:	e50d0200 	str	r0, [sp, #-512]	; 0xfffffe00
    292c:	03000012 	movweq	r0, #18
    2930:	0010240d 	andseq	r2, r0, sp, lsl #8
    2934:	310d0400 	tstcc	sp, r0, lsl #8
    2938:	05000010 	streq	r0, [r0, #-16]
    293c:	0012fd0d 	andseq	pc, r2, sp, lsl #26
    2940:	900d0600 	andls	r0, sp, r0, lsl #12
    2944:	07000013 	smladeq	r0, r3, r0, r0
    2948:	00139e0d 	andseq	r9, r3, sp, lsl #28
    294c:	dd0d0800 	stcle	8, cr0, [sp, #-0]
    2950:	09000011 	stmdbeq	r0, {r0, r4}
    2954:	10cc0b00 	sbcne	r0, ip, r0, lsl #22
    2958:	04050000 	streq	r0, [r5], #-0
    295c:	00000038 	andeq	r0, r0, r8, lsr r0
    2960:	3e108302 	cdpcc	3, 1, cr8, cr0, cr2, {0}
    2964:	0d000002 	stceq	0, cr0, [r0, #-8]
    2968:	000010fe 	strdeq	r1, [r0], -lr
    296c:	0fef0d00 	svceq	0x00ef0d00
    2970:	0d010000 	stceq	0, cr0, [r1, #-0]
    2974:	00001212 	andeq	r1, r0, r2, lsl r2
    2978:	121d0d02 	andsne	r0, sp, #2, 26	; 0x80
    297c:	0d030000 	stceq	0, cr0, [r3, #-0]
    2980:	00001200 	andeq	r1, r0, r0, lsl #4
    2984:	0fe50d04 	svceq	0x00e50d04
    2988:	0d050000 	stceq	0, cr0, [r5, #-0]
    298c:	000010aa 	andeq	r1, r0, sl, lsr #1
    2990:	10bb0d06 	adcsne	r0, fp, r6, lsl #26
    2994:	00070000 	andeq	r0, r7, r0
    2998:	0013450b 	andseq	r4, r3, fp, lsl #10
    299c:	38040500 	stmdacc	r4, {r8, sl}
    29a0:	02000000 	andeq	r0, r0, #0
    29a4:	029f108f 	addseq	r1, pc, #143	; 0x8f
    29a8:	410c0000 	mrsmi	r0, (UNDEF: 12)
    29ac:	1d005855 	stcne	8, cr5, [r0, #-340]	; 0xfffffeac
    29b0:	0012d20d 	andseq	sp, r2, sp, lsl #4
    29b4:	ac0d2b00 			; <UNDEFINED> instruction: 0xac0d2b00
    29b8:	2d000013 	stccs	0, cr0, [r0, #-76]	; 0xffffffb4
    29bc:	0013b20d 	andseq	fp, r3, sp, lsl #4
    29c0:	530c2e00 	movwpl	r2, #52736	; 0xce00
    29c4:	3000494d 	andcc	r4, r0, sp, asr #18
    29c8:	0013500d 	andseq	r5, r3, sp
    29cc:	570d3100 	strpl	r3, [sp, -r0, lsl #2]
    29d0:	32000013 	andcc	r0, r0, #19
    29d4:	00135e0d 	andseq	r5, r3, sp, lsl #28
    29d8:	650d3300 	strvs	r3, [sp, #-768]	; 0xfffffd00
    29dc:	34000013 	strcc	r0, [r0], #-19	; 0xffffffed
    29e0:	4332490c 	teqmi	r2, #12, 18	; 0x30000
    29e4:	530c3500 	movwpl	r3, #50432	; 0xc500
    29e8:	36004950 			; <UNDEFINED> instruction: 0x36004950
    29ec:	4d43500c 	stclmi	0, cr5, [r3, #-48]	; 0xffffffd0
    29f0:	f30d3700 	vabd.u8	d3, d13, d0
    29f4:	3900000d 	stmdbcc	r0, {r0, r2, r3}
    29f8:	021f0900 	andseq	r0, pc, #0, 18
    29fc:	a6020000 	strge	r0, [r2], -r0
    2a00:	0002bc1d 	andeq	fp, r2, sp, lsl ip
    2a04:	00b40000 	adcseq	r0, r4, r0
    2a08:	8d0e0020 	stchi	0, cr0, [lr, #-128]	; 0xffffff80
    2a0c:	02000000 	andeq	r0, r0, #0
    2a10:	1a0a0704 	bne	284628 <_bss_end+0x279b48>
    2a14:	b5030000 	strlt	r0, [r3, #-0]
    2a18:	0e000002 	cdpeq	0, 0, cr0, cr0, cr2, {0}
    2a1c:	0000009d 	muleq	r0, sp, r0
    2a20:	0000ad0e 	andeq	sl, r0, lr, lsl #26
    2a24:	00bd0e00 	adcseq	r0, sp, r0, lsl #28
    2a28:	ca0e0000 	bgt	382a30 <_bss_end+0x377f50>
    2a2c:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    2a30:	0000019c 	muleq	r0, ip, r1
    2a34:	00029f0e 	andeq	r9, r2, lr, lsl #30
    2a38:	0dd00f00 	ldcleq	15, cr0, [r0]
    2a3c:	03040000 	movweq	r0, #16384	; 0x4000
    2a40:	03a30706 			; <UNDEFINED> instruction: 0x03a30706
    2a44:	48100000 	ldmdami	r0, {}	; <UNPREDICTABLE>
    2a48:	03000002 	movweq	r0, #2
    2a4c:	0075190a 	rsbseq	r1, r5, sl, lsl #18
    2a50:	11000000 	mrsne	r0, (UNDEF: 0)
    2a54:	00000dd0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    2a58:	c6050d03 	strgt	r0, [r5], -r3, lsl #26
    2a5c:	a3000002 	movwge	r0, #2
    2a60:	01000003 	tsteq	r0, r3
    2a64:	00000312 	andeq	r0, r0, r2, lsl r3
    2a68:	0000031d 	andeq	r0, r0, sp, lsl r3
    2a6c:	0003a312 	andeq	sl, r3, r2, lsl r3
    2a70:	005e1300 	subseq	r1, lr, r0, lsl #6
    2a74:	14000000 	strne	r0, [r0], #-0
    2a78:	00001307 	andeq	r1, r0, r7, lsl #6
    2a7c:	8e0a1003 	cdphi	0, 0, cr1, cr10, cr3, {0}
    2a80:	01000002 	tsteq	r0, r2
    2a84:	00000332 	andeq	r0, r0, r2, lsr r3
    2a88:	0000033d 	andeq	r0, r0, sp, lsr r3
    2a8c:	0003a312 	andeq	sl, r3, r2, lsl r3
    2a90:	01771300 	cmneq	r7, r0, lsl #6
    2a94:	14000000 	strne	r0, [r0], #-0
    2a98:	000011e7 	andeq	r1, r0, r7, ror #3
    2a9c:	c90a1203 	stmdbgt	sl, {r0, r1, r9, ip}
    2aa0:	01000004 	tsteq	r0, r4
    2aa4:	00000352 	andeq	r0, r0, r2, asr r3
    2aa8:	0000035d 	andeq	r0, r0, sp, asr r3
    2aac:	0003a312 	andeq	sl, r3, r2, lsl r3
    2ab0:	01771300 	cmneq	r7, r0, lsl #6
    2ab4:	14000000 	strne	r0, [r0], #-0
    2ab8:	00000457 	andeq	r0, r0, r7, asr r4
    2abc:	d30a1503 	movwle	r1, #42243	; 0xa503
    2ac0:	01000002 	tsteq	r0, r2
    2ac4:	00000372 	andeq	r0, r0, r2, ror r3
    2ac8:	00000382 	andeq	r0, r0, r2, lsl #7
    2acc:	0003a312 	andeq	sl, r3, r2, lsl r3
    2ad0:	00da1300 	sbcseq	r1, sl, r0, lsl #6
    2ad4:	4d130000 	ldcmi	0, cr0, [r3, #-0]
    2ad8:	00000000 	andeq	r0, r0, r0
    2adc:	00046b15 	andeq	r6, r4, r5, lsl fp
    2ae0:	0e170300 	cdpeq	3, 1, cr0, cr7, cr0, {0}
    2ae4:	00000251 	andeq	r0, r0, r1, asr r2
    2ae8:	0000004d 	andeq	r0, r0, sp, asr #32
    2aec:	00039701 	andeq	r9, r3, r1, lsl #14
    2af0:	03a31200 			; <UNDEFINED> instruction: 0x03a31200
    2af4:	da130000 	ble	4c2afc <_bss_end+0x4b801c>
    2af8:	00000000 	andeq	r0, r0, r0
    2afc:	df040700 	svcle	0x00040700
    2b00:	0b000002 	bleq	2b10 <CPSR_IRQ_INHIBIT+0x2a90>
    2b04:	00000edc 	ldrdeq	r0, [r0], -ip
    2b08:	00380405 	eorseq	r0, r8, r5, lsl #8
    2b0c:	06040000 	streq	r0, [r4], -r0
    2b10:	0003c80c 	andeq	ip, r3, ip, lsl #16
    2b14:	0d920d00 	ldceq	13, cr0, [r2]
    2b18:	0d000000 	stceq	0, cr0, [r0, #-0]
    2b1c:	00000da9 	andeq	r0, r0, r9, lsr #27
    2b20:	640b0001 	strvs	r0, [fp], #-1
    2b24:	0500000e 	streq	r0, [r0, #-14]
    2b28:	00003804 	andeq	r3, r0, r4, lsl #16
    2b2c:	0c0c0400 	cfstrseq	mvf0, [ip], {-0}
    2b30:	00000415 	andeq	r0, r0, r5, lsl r4
    2b34:	000e4116 	andeq	r4, lr, r6, lsl r1
    2b38:	1604b000 	strne	fp, [r4], -r0
    2b3c:	00000d0f 	andeq	r0, r0, pc, lsl #26
    2b40:	38160960 	ldmdacc	r6, {r5, r6, r8, fp}
    2b44:	c000000d 	andgt	r0, r0, sp
    2b48:	0f021612 	svceq	0x00021612
    2b4c:	25800000 	strcs	r0, [r0]
    2b50:	000e0e16 	andeq	r0, lr, r6, lsl lr
    2b54:	164b0000 	strbne	r0, [fp], -r0
    2b58:	00000e17 	andeq	r0, r0, r7, lsl lr
    2b5c:	20169600 	andscs	r9, r6, r0, lsl #12
    2b60:	0000000e 	andeq	r0, r0, lr
    2b64:	0e3717e1 	cdpeq	7, 3, cr1, cr7, cr1, {7}
    2b68:	c2000000 	andgt	r0, r0, #0
    2b6c:	0f000001 	svceq	0x00000001
    2b70:	00000df2 	strdeq	r0, [r0], -r2
    2b74:	07180404 	ldreq	r0, [r8, -r4, lsl #8]
    2b78:	000005ab 	andeq	r0, r0, fp, lsr #11
    2b7c:	000d3310 	andeq	r3, sp, r0, lsl r3
    2b80:	0b1b0400 	bleq	6c3b88 <_bss_end+0x6b90a8>
    2b84:	000005ab 	andeq	r0, r0, fp, lsr #11
    2b88:	0df21100 	ldfeqe	f1, [r2]
    2b8c:	1e040000 	cdpne	0, 0, cr0, cr4, cr0, {0}
    2b90:	000e8605 	andeq	r8, lr, r5, lsl #12
    2b94:	0005b100 	andeq	fp, r5, r0, lsl #2
    2b98:	04480100 	strbeq	r0, [r8], #-256	; 0xffffff00
    2b9c:	04530000 	ldrbeq	r0, [r3], #-0
    2ba0:	b1120000 	tstlt	r2, r0
    2ba4:	13000005 	movwne	r0, #5
    2ba8:	000005ab 	andeq	r0, r0, fp, lsr #11
    2bac:	0d991400 	cfldrseq	mvf1, [r9]
    2bb0:	20040000 	andcs	r0, r4, r0
    2bb4:	000ebf0a 	andeq	fp, lr, sl, lsl #30
    2bb8:	04680100 	strbteq	r0, [r8], #-256	; 0xffffff00
    2bbc:	04730000 	ldrbteq	r0, [r3], #-0
    2bc0:	b1120000 	tstlt	r2, r0
    2bc4:	13000005 	movwne	r0, #5
    2bc8:	000003a9 	andeq	r0, r0, r9, lsr #7
    2bcc:	0e291400 	cdpeq	4, 2, cr1, cr9, cr0, {0}
    2bd0:	21040000 	mrscs	r0, (UNDEF: 4)
    2bd4:	000e490a 	andeq	r4, lr, sl, lsl #18
    2bd8:	04880100 	streq	r0, [r8], #256	; 0x100
    2bdc:	04930000 	ldreq	r0, [r3], #0
    2be0:	b1120000 	tstlt	r2, r0
    2be4:	13000005 	movwne	r0, #5
    2be8:	000003c8 	andeq	r0, r0, r8, asr #7
    2bec:	0d171400 	cfldrseq	mvf1, [r7, #-0]
    2bf0:	25040000 	strcs	r0, [r4, #-0]
    2bf4:	000e740a 	andeq	r7, lr, sl, lsl #8
    2bf8:	04a80100 	strteq	r0, [r8], #256	; 0x100
    2bfc:	04b30000 	ldrteq	r0, [r3], #0
    2c00:	b1120000 	tstlt	r2, r0
    2c04:	13000005 	movwne	r0, #5
    2c08:	00000025 	andeq	r0, r0, r5, lsr #32
    2c0c:	0d171400 	cfldrseq	mvf1, [r7, #-0]
    2c10:	26040000 	strcs	r0, [r4], -r0
    2c14:	000eab0a 	andeq	sl, lr, sl, lsl #22
    2c18:	04c80100 	strbeq	r0, [r8], #256	; 0x100
    2c1c:	04d30000 	ldrbeq	r0, [r3], #0
    2c20:	b1120000 	tstlt	r2, r0
    2c24:	13000005 	movwne	r0, #5
    2c28:	000005b7 			; <UNDEFINED> instruction: 0x000005b7
    2c2c:	0d171400 	cfldrseq	mvf1, [r7, #-0]
    2c30:	27040000 	strcs	r0, [r4, -r0]
    2c34:	000d6b0a 	andeq	r6, sp, sl, lsl #22
    2c38:	04e80100 	strbteq	r0, [r8], #256	; 0x100
    2c3c:	04f80000 	ldrbteq	r0, [r8], #0
    2c40:	b1120000 	tstlt	r2, r0
    2c44:	13000005 	movwne	r0, #5
    2c48:	000005b7 			; <UNDEFINED> instruction: 0x000005b7
    2c4c:	00005e13 	andeq	r5, r0, r3, lsl lr
    2c50:	17140000 	ldrne	r0, [r4, -r0]
    2c54:	0400000d 	streq	r0, [r0], #-13
    2c58:	0db00a28 			; <UNDEFINED> instruction: 0x0db00a28
    2c5c:	0d010000 	stceq	0, cr0, [r1, #-0]
    2c60:	18000005 	stmdane	r0, {r0, r2}
    2c64:	12000005 	andne	r0, r0, #5
    2c68:	000005b1 			; <UNDEFINED> instruction: 0x000005b1
    2c6c:	00005e13 	andeq	r5, r0, r3, lsl lr
    2c70:	17140000 	ldrne	r0, [r4, -r0]
    2c74:	0400000d 	streq	r0, [r0], #-13
    2c78:	0e990a29 	vfnmseq.f32	s0, s18, s19
    2c7c:	2d010000 	stccs	0, cr0, [r1, #-0]
    2c80:	38000005 	stmdacc	r0, {r0, r2}
    2c84:	12000005 	andne	r0, r0, #5
    2c88:	000005b1 			; <UNDEFINED> instruction: 0x000005b1
    2c8c:	00003813 	andeq	r3, r0, r3, lsl r8
    2c90:	d5140000 	ldrle	r0, [r4, #-0]
    2c94:	0400000d 	streq	r0, [r0], #-13
    2c98:	0d1d0a2a 	vldreq	s0, [sp, #-168]	; 0xffffff58
    2c9c:	4d010000 	stcmi	0, cr0, [r1, #-0]
    2ca0:	58000005 	stmdapl	r0, {r0, r2}
    2ca4:	12000005 	andne	r0, r0, #5
    2ca8:	000005b1 			; <UNDEFINED> instruction: 0x000005b1
    2cac:	00005e13 	andeq	r5, r0, r3, lsl lr
    2cb0:	61140000 	tstvs	r4, r0
    2cb4:	0400000d 	streq	r0, [r0], #-13
    2cb8:	0d800a2b 	vstreq	s0, [r0, #172]	; 0xac
    2cbc:	6d010000 	stcvs	0, cr0, [r1, #-0]
    2cc0:	78000005 	stmdavc	r0, {r0, r2}
    2cc4:	12000005 	andne	r0, r0, #5
    2cc8:	000005b1 			; <UNDEFINED> instruction: 0x000005b1
    2ccc:	0005bd13 	andeq	fp, r5, r3, lsl sp
    2cd0:	df140000 	svcle	0x00140000
    2cd4:	0400000d 	streq	r0, [r0], #-13
    2cd8:	0cef0a2d 	vstmiaeq	pc!, {s1-s45}
    2cdc:	8d010000 	stchi	0, cr0, [r1, #-0]
    2ce0:	93000005 	movwls	r0, #5
    2ce4:	12000005 	andne	r0, r0, #5
    2ce8:	000005b1 			; <UNDEFINED> instruction: 0x000005b1
    2cec:	0eee1800 	cdpeq	8, 14, cr1, cr14, cr0, {0}
    2cf0:	2e040000 	cdpcs	0, 0, cr0, cr4, cr0, {0}
    2cf4:	000d400a 	andeq	r4, sp, sl
    2cf8:	05a40100 	streq	r0, [r4, #256]!	; 0x100
    2cfc:	b1120000 	tstlt	r2, r0
    2d00:	00000005 	andeq	r0, r0, r5
    2d04:	df041900 	svcle	0x00041900
    2d08:	07000002 	streq	r0, [r0, -r2]
    2d0c:	00041504 	andeq	r1, r4, r4, lsl #10
    2d10:	2c040700 	stccs	7, cr0, [r4], {-0}
    2d14:	07000000 	streq	r0, [r0, -r0]
    2d18:	00002504 	andeq	r2, r0, r4, lsl #10
    2d1c:	0e071a00 	vmlaeq.f32	s2, s14, s0
    2d20:	31040000 	mrscc	r0, (UNDEF: 4)
    2d24:	0004150e 	andeq	r1, r4, lr, lsl #10
    2d28:	11c70f00 	bicne	r0, r7, r0, lsl #30
    2d2c:	05040000 	streq	r0, [r4, #-0]
    2d30:	06ae070a 	strteq	r0, [lr], sl, lsl #14
    2d34:	55100000 	ldrpl	r0, [r0, #-0]
    2d38:	05000012 	streq	r0, [r0, #-18]	; 0xffffffee
    2d3c:	06ae1c0e 	strteq	r1, [lr], lr, lsl #24
    2d40:	11000000 	mrsne	r0, (UNDEF: 0)
    2d44:	00001260 	andeq	r1, r0, r0, ror #4
    2d48:	a41c1105 	ldrge	r1, [ip], #-261	; 0xfffffefb
    2d4c:	b400000f 	strlt	r0, [r0], #-15
    2d50:	02000006 	andeq	r0, r0, #6
    2d54:	00000602 	andeq	r0, r0, r2, lsl #12
    2d58:	0000060d 	andeq	r0, r0, sp, lsl #12
    2d5c:	0006ba12 	andeq	fp, r6, r2, lsl sl
    2d60:	01ac1300 			; <UNDEFINED> instruction: 0x01ac1300
    2d64:	11000000 	mrsne	r0, (UNDEF: 0)
    2d68:	000011c7 	andeq	r1, r0, r7, asr #3
    2d6c:	ab051405 	blge	147d88 <_bss_end+0x13d2a8>
    2d70:	ba000012 	blt	2dc0 <CPSR_IRQ_INHIBIT+0x2d40>
    2d74:	01000006 	tsteq	r0, r6
    2d78:	00000626 	andeq	r0, r0, r6, lsr #12
    2d7c:	00000631 	andeq	r0, r0, r1, lsr r6
    2d80:	0006ba12 	andeq	fp, r6, r2, lsl sl
    2d84:	02b51300 	adcseq	r1, r5, #0, 6
    2d88:	14000000 	strne	r0, [r0], #-0
    2d8c:	000011ef 	andeq	r1, r0, pc, ror #3
    2d90:	650a1705 	strvs	r1, [sl, #-1797]	; 0xfffff8fb
    2d94:	01000012 	tsteq	r0, r2, lsl r0
    2d98:	00000646 	andeq	r0, r0, r6, asr #12
    2d9c:	00000651 	andeq	r0, r0, r1, asr r6
    2da0:	0006ba12 	andeq	fp, r6, r2, lsl sl
    2da4:	01fb1300 	mvnseq	r1, r0, lsl #6
    2da8:	14000000 	strne	r0, [r0], #-0
    2dac:	0000136c 	andeq	r1, r0, ip, ror #6
    2db0:	3e0a1905 	vmlacc.f16	s2, s20, s10	; <UNPREDICTABLE>
    2db4:	01000010 	tsteq	r0, r0, lsl r0
    2db8:	00000666 	andeq	r0, r0, r6, ror #12
    2dbc:	00000671 	andeq	r0, r0, r1, ror r6
    2dc0:	0006ba12 	andeq	fp, r6, r2, lsl sl
    2dc4:	01fb1300 	mvnseq	r1, r0, lsl #6
    2dc8:	14000000 	strne	r0, [r0], #-0
    2dcc:	00000ff7 	strdeq	r0, [r0], -r7
    2dd0:	610a1c05 	tstvs	sl, r5, lsl #24
    2dd4:	0100000f 	tsteq	r0, pc
    2dd8:	00000686 	andeq	r0, r0, r6, lsl #13
    2ddc:	00000691 	muleq	r0, r1, r6
    2de0:	0006ba12 	andeq	fp, r6, r2, lsl sl
    2de4:	023e1300 	eorseq	r1, lr, #0, 6
    2de8:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
    2dec:	0000109e 	muleq	r0, lr, r0
    2df0:	040a1e05 	streq	r1, [sl], #-3589	; 0xfffff1fb
    2df4:	01000011 	tsteq	r0, r1, lsl r0
    2df8:	000006a2 	andeq	r0, r0, r2, lsr #13
    2dfc:	0006ba12 	andeq	fp, r6, r2, lsl sl
    2e00:	023e1300 	eorseq	r1, lr, #0, 6
    2e04:	00000000 	andeq	r0, r0, r0
    2e08:	006a0407 	rsbeq	r0, sl, r7, lsl #8
    2e0c:	04190000 	ldreq	r0, [r9], #-0
    2e10:	0000006a 	andeq	r0, r0, sl, rrx
    2e14:	05cf0407 	strbeq	r0, [pc, #1031]	; 3223 <CPSR_IRQ_INHIBIT+0x31a3>
    2e18:	281a0000 	ldmdacs	sl, {}	; <UNPREDICTABLE>
    2e1c:	05000012 	streq	r0, [r0, #-18]	; 0xffffffee
    2e20:	05cf1e21 	strbeq	r1, [pc, #3617]	; 3c49 <CPSR_IRQ_INHIBIT+0x3bc9>
    2e24:	071b0000 	ldreq	r0, [fp, -r0]
    2e28:	01000014 	tsteq	r0, r4, lsl r0
    2e2c:	00381005 	eorseq	r1, r8, r5
    2e30:	9d9c0000 	ldcls	0, cr0, [ip]
    2e34:	00780000 	rsbseq	r0, r8, r0
    2e38:	9c010000 	stcls	0, cr0, [r1], {-0}
    2e3c:	00001e00 	andeq	r1, r0, r0, lsl #28
    2e40:	d2000200 	andle	r0, r0, #0, 4
    2e44:	0400000e 	streq	r0, [r0], #-14
    2e48:	00127b01 	andseq	r7, r2, r1, lsl #22
    2e4c:	00002800 	andeq	r2, r0, r0, lsl #16
    2e50:	00141400 	andseq	r1, r4, r0, lsl #8
    2e54:	00007400 	andeq	r7, r0, r0, lsl #8
    2e58:	00146200 	andseq	r6, r4, r0, lsl #4
    2e5c:	4b800100 	blmi	fe003264 <_bss_end+0xfdff8784>
    2e60:	04000001 	streq	r0, [r0], #-1
    2e64:	000ee400 	andeq	lr, lr, r0, lsl #8
    2e68:	b5010400 	strlt	r0, [r1, #-1024]	; 0xfffffc00
    2e6c:	04000000 	streq	r0, [r0], #-0
    2e70:	0000146e 	andeq	r1, r0, lr, ror #8
    2e74:	00000074 	andeq	r0, r0, r4, ror r0
    2e78:	00009e34 	andeq	r9, r0, r4, lsr lr
    2e7c:	00000118 	andeq	r0, r0, r8, lsl r1
    2e80:	0000132e 	andeq	r1, r0, lr, lsr #6
    2e84:	00151302 	andseq	r1, r5, r2, lsl #6
    2e88:	07020100 	streq	r0, [r2, -r0, lsl #2]
    2e8c:	00000031 	andeq	r0, r0, r1, lsr r0
    2e90:	00370403 	eorseq	r0, r7, r3, lsl #8
    2e94:	02040000 	andeq	r0, r4, #0
    2e98:	0000150a 	andeq	r1, r0, sl, lsl #10
    2e9c:	31070301 	tstcc	r7, r1, lsl #6
    2ea0:	05000000 	streq	r0, [r0, #-0]
    2ea4:	000014c0 	andeq	r1, r0, r0, asr #9
    2ea8:	50100601 	andspl	r0, r0, r1, lsl #12
    2eac:	06000000 	streq	r0, [r0], -r0
    2eb0:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
    2eb4:	f3050074 	vqadd.u8	q0, <illegal reg q2.5>, q10
    2eb8:	01000014 	tsteq	r0, r4, lsl r0
    2ebc:	00501008 	subseq	r1, r0, r8
    2ec0:	25070000 	strcs	r0, [r7, #-0]
    2ec4:	76000000 	strvc	r0, [r0], -r0
    2ec8:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    2ecc:	00000076 	andeq	r0, r0, r6, ror r0
    2ed0:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
    2ed4:	07040900 	streq	r0, [r4, -r0, lsl #18]
    2ed8:	00001a0f 	andeq	r1, r0, pc, lsl #20
    2edc:	00151c05 	andseq	r1, r5, r5, lsl #24
    2ee0:	150b0100 	strne	r0, [fp, #-256]	; 0xffffff00
    2ee4:	00000063 	andeq	r0, r0, r3, rrx
    2ee8:	0014cb05 	andseq	ip, r4, r5, lsl #22
    2eec:	150d0100 	strne	r0, [sp, #-256]	; 0xffffff00
    2ef0:	00000063 	andeq	r0, r0, r3, rrx
    2ef4:	00003807 	andeq	r3, r0, r7, lsl #16
    2ef8:	0000a800 	andeq	sl, r0, r0, lsl #16
    2efc:	00760800 	rsbseq	r0, r6, r0, lsl #16
    2f00:	ffff0000 			; <UNDEFINED> instruction: 0xffff0000
    2f04:	0500ffff 	streq	pc, [r0, #-4095]	; 0xfffff001
    2f08:	000014fc 	strdeq	r1, [r0], -ip
    2f0c:	95151001 	ldrls	r1, [r5, #-1]
    2f10:	05000000 	streq	r0, [r0, #-0]
    2f14:	000014d8 	ldrdeq	r1, [r0], -r8
    2f18:	95151201 	ldrls	r1, [r5, #-513]	; 0xfffffdff
    2f1c:	0a000000 	beq	2f24 <CPSR_IRQ_INHIBIT+0x2ea4>
    2f20:	000014e5 	andeq	r1, r0, r5, ror #9
    2f24:	50102b01 	andspl	r2, r0, r1, lsl #22
    2f28:	f4000000 	vst4.8	{d0-d3}, [r0], r0
    2f2c:	5800009e 	stmdapl	r0, {r1, r2, r3, r4, r7}
    2f30:	01000000 	mrseq	r0, (UNDEF: 0)
    2f34:	0000ea9c 	muleq	r0, ip, sl
    2f38:	15420b00 	strbne	r0, [r2, #-2816]	; 0xfffff500
    2f3c:	2d010000 	stccs	0, cr0, [r1, #-0]
    2f40:	0000ea0f 	andeq	lr, r0, pc, lsl #20
    2f44:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    2f48:	38040300 	stmdacc	r4, {r8, r9}
    2f4c:	0a000000 	beq	2f54 <CPSR_IRQ_INHIBIT+0x2ed4>
    2f50:	00001535 	andeq	r1, r0, r5, lsr r5
    2f54:	50101f01 	andspl	r1, r0, r1, lsl #30
    2f58:	9c000000 	stcls	0, cr0, [r0], {-0}
    2f5c:	5800009e 	stmdapl	r0, {r1, r2, r3, r4, r7}
    2f60:	01000000 	mrseq	r0, (UNDEF: 0)
    2f64:	00011a9c 	muleq	r1, ip, sl
    2f68:	15420b00 	strbne	r0, [r2, #-2816]	; 0xfffff500
    2f6c:	21010000 	mrscs	r0, (UNDEF: 1)
    2f70:	00011a0f 	andeq	r1, r1, pc, lsl #20
    2f74:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    2f78:	25040300 	strcs	r0, [r4, #-768]	; 0xfffffd00
    2f7c:	0c000000 	stceq	0, cr0, [r0], {-0}
    2f80:	0000152a 	andeq	r1, r0, sl, lsr #10
    2f84:	50101401 	andspl	r1, r0, r1, lsl #8
    2f88:	34000000 	strcc	r0, [r0], #-0
    2f8c:	6800009e 	stmdavs	r0, {r1, r2, r3, r4, r7}
    2f90:	01000000 	mrseq	r0, (UNDEF: 0)
    2f94:	0001489c 	muleq	r1, ip, r8
    2f98:	00690d00 	rsbeq	r0, r9, r0, lsl #26
    2f9c:	480a1601 	stmdami	sl, {r0, r9, sl, ip}
    2fa0:	02000001 	andeq	r0, r0, #1
    2fa4:	03007491 	movweq	r7, #1169	; 0x491
    2fa8:	00005004 	andeq	r5, r0, r4
    2fac:	032e0000 			; <UNDEFINED> instruction: 0x032e0000
    2fb0:	00040000 	andeq	r0, r4, r0
    2fb4:	00000faa 	andeq	r0, r0, sl, lsr #31
    2fb8:	00b50104 	adcseq	r0, r5, r4, lsl #2
    2fbc:	8f040000 	svchi	0x00040000
    2fc0:	74000015 	strvc	r0, [r0], #-21	; 0xffffffeb
    2fc4:	4c000000 	stcmi	0, cr0, [r0], {-0}
    2fc8:	b800009f 	stmdalt	r0, {r0, r1, r2, r3, r4, r7}
    2fcc:	1b000004 	blne	2fe4 <CPSR_IRQ_INHIBIT+0x2f64>
    2fd0:	02000014 	andeq	r0, r0, #20
    2fd4:	00000049 	andeq	r0, r0, r9, asr #32
    2fd8:	000bb003 	andeq	fp, fp, r3
    2fdc:	10050100 	andne	r0, r5, r0, lsl #2
    2fe0:	00000061 	andeq	r0, r0, r1, rrx
    2fe4:	32313011 	eorscc	r3, r1, #17
    2fe8:	36353433 			; <UNDEFINED> instruction: 0x36353433
    2fec:	41393837 	teqmi	r9, r7, lsr r8
    2ff0:	45444342 	strbmi	r4, [r4, #-834]	; 0xfffffcbe
    2ff4:	04000046 	streq	r0, [r0], #-70	; 0xffffffba
    2ff8:	25010301 	strcs	r0, [r1, #-769]	; 0xfffffcff
    2ffc:	05000000 	streq	r0, [r0, #-0]
    3000:	00000074 	andeq	r0, r0, r4, ror r0
    3004:	00000061 	andeq	r0, r0, r1, rrx
    3008:	00006606 	andeq	r6, r0, r6, lsl #12
    300c:	07001000 	streq	r1, [r0, -r0]
    3010:	00000051 	andeq	r0, r0, r1, asr r0
    3014:	0f070408 	svceq	0x00070408
    3018:	0800001a 	stmdaeq	r0, {r1, r3, r4}
    301c:	036a0801 	cmneq	sl, #65536	; 0x10000
    3020:	6d070000 	stcvs	0, cr0, [r7, #-0]
    3024:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
    3028:	0000002a 	andeq	r0, r0, sl, lsr #32
    302c:	0015880a 	andseq	r8, r5, sl, lsl #16
    3030:	06640100 	strbteq	r0, [r4], -r0, lsl #2
    3034:	00001578 	andeq	r1, r0, r8, ror r5
    3038:	0000a384 	andeq	sl, r0, r4, lsl #7
    303c:	00000080 	andeq	r0, r0, r0, lsl #1
    3040:	00fb9c01 	rscseq	r9, fp, r1, lsl #24
    3044:	730b0000 	movwvc	r0, #45056	; 0xb000
    3048:	01006372 	tsteq	r0, r2, ror r3
    304c:	00fb1964 	rscseq	r1, fp, r4, ror #18
    3050:	91020000 	mrsls	r0, (UNDEF: 2)
    3054:	73640b64 	cmnvc	r4, #100, 22	; 0x19000
    3058:	64010074 	strvs	r0, [r1], #-116	; 0xffffff8c
    305c:	00010224 	andeq	r0, r1, r4, lsr #4
    3060:	60910200 	addsvs	r0, r1, r0, lsl #4
    3064:	6d756e0b 	ldclvs	14, cr6, [r5, #-44]!	; 0xffffffd4
    3068:	2d640100 	stfcse	f0, [r4, #-0]
    306c:	00000104 	andeq	r0, r0, r4, lsl #2
    3070:	0c5c9102 	ldfeqp	f1, [ip], {2}
    3074:	00001636 	andeq	r1, r0, r6, lsr r6
    3078:	0b116601 	bleq	45c884 <_bss_end+0x451da4>
    307c:	02000001 	andeq	r0, r0, #1
    3080:	480c7091 	stmdami	ip, {r0, r4, r7, ip, sp, lr}
    3084:	01000015 	tsteq	r0, r5, lsl r0
    3088:	01110b67 	tsteq	r1, r7, ror #22
    308c:	91020000 	mrsls	r0, (UNDEF: 2)
    3090:	a3ac0d6c 			; <UNDEFINED> instruction: 0xa3ac0d6c
    3094:	00480000 	subeq	r0, r8, r0
    3098:	690e0000 	stmdbvs	lr, {}	; <UNPREDICTABLE>
    309c:	0e690100 	poweqe	f0, f1, f0
    30a0:	00000104 	andeq	r0, r0, r4, lsl #2
    30a4:	00749102 	rsbseq	r9, r4, r2, lsl #2
    30a8:	01040f00 	tsteq	r4, r0, lsl #30
    30ac:	10000001 	andne	r0, r0, r1
    30b0:	04120411 	ldreq	r0, [r2], #-1041	; 0xfffffbef
    30b4:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
    30b8:	74040f00 	strvc	r0, [r4], #-3840	; 0xfffff100
    30bc:	0f000000 	svceq	0x00000000
    30c0:	00006d04 	andeq	r6, r0, r4, lsl #26
    30c4:	15540a00 	ldrbne	r0, [r4, #-2560]	; 0xfffff600
    30c8:	5c010000 	stcpl	0, cr0, [r1], {-0}
    30cc:	00156106 	andseq	r6, r5, r6, lsl #2
    30d0:	00a31c00 	adceq	r1, r3, r0, lsl #24
    30d4:	00006800 	andeq	r6, r0, r0, lsl #16
    30d8:	769c0100 	ldrvc	r0, [ip], r0, lsl #2
    30dc:	13000001 	movwne	r0, #1
    30e0:	0000162f 	andeq	r1, r0, pc, lsr #12
    30e4:	02125c01 	andseq	r5, r2, #256	; 0x100
    30e8:	02000001 	andeq	r0, r0, #1
    30ec:	5a136c91 	bpl	4de338 <_bss_end+0x4d3858>
    30f0:	01000015 	tsteq	r0, r5, lsl r0
    30f4:	01041e5c 	tsteq	r4, ip, asr lr
    30f8:	91020000 	mrsls	r0, (UNDEF: 2)
    30fc:	656d0e68 	strbvs	r0, [sp, #-3688]!	; 0xfffff198
    3100:	5e01006d 	cdppl	0, 0, cr0, cr1, cr13, {3}
    3104:	0001110b 	andeq	r1, r1, fp, lsl #2
    3108:	70910200 	addsvc	r0, r1, r0, lsl #4
    310c:	00a3380d 	adceq	r3, r3, sp, lsl #16
    3110:	00003c00 	andeq	r3, r0, r0, lsl #24
    3114:	00690e00 	rsbeq	r0, r9, r0, lsl #28
    3118:	040e6001 	streq	r6, [lr], #-1
    311c:	02000001 	andeq	r0, r0, #1
    3120:	00007491 	muleq	r0, r1, r4
    3124:	0015e314 	andseq	lr, r5, r4, lsl r3
    3128:	05520100 	ldrbeq	r0, [r2, #-256]	; 0xffffff00
    312c:	000015fc 	strdeq	r1, [r0], -ip
    3130:	00000104 	andeq	r0, r0, r4, lsl #2
    3134:	0000a2c8 	andeq	sl, r0, r8, asr #5
    3138:	00000054 	andeq	r0, r0, r4, asr r0
    313c:	01af9c01 			; <UNDEFINED> instruction: 0x01af9c01
    3140:	730b0000 	movwvc	r0, #45056	; 0xb000
    3144:	18520100 	ldmdane	r2, {r8}^
    3148:	0000010b 	andeq	r0, r0, fp, lsl #2
    314c:	0e6c9102 	lgneqe	f1, f2
    3150:	54010069 	strpl	r0, [r1], #-105	; 0xffffff97
    3154:	00010409 	andeq	r0, r1, r9, lsl #8
    3158:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    315c:	161f1400 	ldrne	r1, [pc], -r0, lsl #8
    3160:	42010000 	andmi	r0, r1, #0
    3164:	0015ea05 	andseq	lr, r5, r5, lsl #20
    3168:	00010400 	andeq	r0, r1, r0, lsl #8
    316c:	00a21c00 	adceq	r1, r2, r0, lsl #24
    3170:	0000ac00 	andeq	sl, r0, r0, lsl #24
    3174:	159c0100 	ldrne	r0, [ip, #256]	; 0x100
    3178:	0b000002 	bleq	3188 <CPSR_IRQ_INHIBIT+0x3108>
    317c:	01003173 	tsteq	r0, r3, ror r1
    3180:	010b1942 	tsteq	fp, r2, asr #18
    3184:	91020000 	mrsls	r0, (UNDEF: 2)
    3188:	32730b6c 	rsbscc	r0, r3, #108, 22	; 0x1b000
    318c:	29420100 	stmdbcs	r2, {r8}^
    3190:	0000010b 	andeq	r0, r0, fp, lsl #2
    3194:	0b689102 	bleq	1a275a4 <_bss_end+0x1a1cac4>
    3198:	006d756e 	rsbeq	r7, sp, lr, ror #10
    319c:	04314201 	ldrteq	r4, [r1], #-513	; 0xfffffdff
    31a0:	02000001 	andeq	r0, r0, #1
    31a4:	750e6491 	strvc	r6, [lr, #-1169]	; 0xfffffb6f
    31a8:	44010031 	strmi	r0, [r1], #-49	; 0xffffffcf
    31ac:	00021513 	andeq	r1, r2, r3, lsl r5
    31b0:	77910200 	ldrvc	r0, [r1, r0, lsl #4]
    31b4:	0032750e 	eorseq	r7, r2, lr, lsl #10
    31b8:	15174401 	ldrne	r4, [r7, #-1025]	; 0xfffffbff
    31bc:	02000002 	andeq	r0, r0, #2
    31c0:	08007691 	stmdaeq	r0, {r0, r4, r7, r9, sl, ip, sp, lr}
    31c4:	03610801 	cmneq	r1, #65536	; 0x10000
    31c8:	27140000 	ldrcs	r0, [r4, -r0]
    31cc:	01000016 	tsteq	r0, r6, lsl r0
    31d0:	160e0736 			; <UNDEFINED> instruction: 0x160e0736
    31d4:	01110000 	tsteq	r1, r0
    31d8:	a15c0000 	cmpge	ip, r0
    31dc:	00c00000 	sbceq	r0, r0, r0
    31e0:	9c010000 	stcls	0, cr0, [r1], {-0}
    31e4:	00000275 	andeq	r0, r0, r5, ror r2
    31e8:	00154f13 	andseq	r4, r5, r3, lsl pc
    31ec:	15360100 	ldrne	r0, [r6, #-256]!	; 0xffffff00
    31f0:	00000111 	andeq	r0, r0, r1, lsl r1
    31f4:	0b6c9102 	bleq	1b27604 <_bss_end+0x1b1cb24>
    31f8:	00637273 	rsbeq	r7, r3, r3, ror r2
    31fc:	0b273601 	bleq	9d0a08 <_bss_end+0x9c5f28>
    3200:	02000001 	andeq	r0, r0, #1
    3204:	6e0b6891 	mcrvs	8, 0, r6, cr11, cr1, {4}
    3208:	01006d75 	tsteq	r0, r5, ror sp
    320c:	01043036 	tsteq	r4, r6, lsr r0
    3210:	91020000 	mrsls	r0, (UNDEF: 2)
    3214:	00690e64 	rsbeq	r0, r9, r4, ror #28
    3218:	04093801 	streq	r3, [r9], #-2049	; 0xfffff7ff
    321c:	02000001 	andeq	r0, r0, #1
    3220:	14007491 	strne	r7, [r0], #-1169	; 0xfffffb6f
    3224:	00001609 	andeq	r1, r0, r9, lsl #12
    3228:	6d052401 	cfstrsvs	mvf2, [r5, #-4]
    322c:	04000015 	streq	r0, [r0], #-21	; 0xffffffeb
    3230:	c0000001 	andgt	r0, r0, r1
    3234:	9c0000a0 	stcls	0, cr0, [r0], {160}	; 0xa0
    3238:	01000000 	mrseq	r0, (UNDEF: 0)
    323c:	0002b29c 	muleq	r2, ip, r2
    3240:	0cd41300 	ldcleq	3, cr1, [r4], {0}
    3244:	24010000 	strcs	r0, [r1], #-0
    3248:	00010b16 	andeq	r0, r1, r6, lsl fp
    324c:	6c910200 	lfmvs	f0, 4, [r1], {0}
    3250:	000ccd0c 	andeq	ip, ip, ip, lsl #26
    3254:	09260100 	stmdbeq	r6!, {r8}
    3258:	00000104 	andeq	r0, r0, r4, lsl #2
    325c:	00749102 	rsbseq	r9, r4, r2, lsl #2
    3260:	000ac715 	andeq	ip, sl, r5, lsl r7
    3264:	06080100 	streq	r0, [r8], -r0, lsl #2
    3268:	0000163d 	andeq	r1, r0, sp, lsr r6
    326c:	00009f4c 	andeq	r9, r0, ip, asr #30
    3270:	00000174 	andeq	r0, r0, r4, ror r1
    3274:	d4139c01 	ldrle	r9, [r3], #-3073	; 0xfffff3ff
    3278:	0100000c 	tsteq	r0, ip
    327c:	00661808 	rsbeq	r1, r6, r8, lsl #16
    3280:	91020000 	mrsls	r0, (UNDEF: 2)
    3284:	0ccd1364 	stcleq	3, cr1, [sp], {100}	; 0x64
    3288:	08010000 	stmdaeq	r1, {}	; <UNPREDICTABLE>
    328c:	00011125 	andeq	r1, r1, r5, lsr #2
    3290:	60910200 	addsvs	r0, r1, r0, lsl #4
    3294:	00170913 	andseq	r0, r7, r3, lsl r9
    3298:	3a080100 	bcc	2036a0 <_bss_end+0x1f8bc0>
    329c:	00000066 	andeq	r0, r0, r6, rrx
    32a0:	0e5c9102 	logeqe	f1, f2
    32a4:	0a010069 	beq	43450 <_bss_end+0x38970>
    32a8:	00010409 	andeq	r0, r1, r9, lsl #8
    32ac:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    32b0:	00a0180d 	adceq	r1, r0, sp, lsl #16
    32b4:	00009800 	andeq	r9, r0, r0, lsl #16
    32b8:	006a0e00 	rsbeq	r0, sl, r0, lsl #28
    32bc:	040e1c01 	streq	r1, [lr], #-3073	; 0xfffff3ff
    32c0:	02000001 	andeq	r0, r0, #1
    32c4:	400d7091 	mulmi	sp, r1, r0
    32c8:	600000a0 	andvs	r0, r0, r0, lsr #1
    32cc:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    32d0:	1e010063 	cdpne	0, 0, cr0, cr1, cr3, {3}
    32d4:	00006d0e 	andeq	r6, r0, lr, lsl #26
    32d8:	6f910200 	svcvs	0x00910200
    32dc:	00000000 	andeq	r0, r0, r0
    32e0:	00000022 	andeq	r0, r0, r2, lsr #32
    32e4:	10d10002 	sbcsne	r0, r1, r2
    32e8:	01040000 	mrseq	r0, (UNDEF: 4)
    32ec:	000016ac 	andeq	r1, r0, ip, lsr #13
    32f0:	0000a404 	andeq	sl, r0, r4, lsl #8
    32f4:	0000a610 	andeq	sl, r0, r0, lsl r6
    32f8:	00001649 	andeq	r1, r0, r9, asr #12
    32fc:	00001679 	andeq	r1, r0, r9, ror r6
    3300:	000016e1 	andeq	r1, r0, r1, ror #13
    3304:	00228001 	eoreq	r8, r2, r1
    3308:	00020000 	andeq	r0, r2, r0
    330c:	000010e5 	andeq	r1, r0, r5, ror #1
    3310:	17290104 	strne	r0, [r9, -r4, lsl #2]!
    3314:	a6100000 	ldrge	r0, [r0], -r0
    3318:	a6140000 	ldrge	r0, [r4], -r0
    331c:	16490000 	strbne	r0, [r9], -r0
    3320:	16790000 	ldrbtne	r0, [r9], -r0
    3324:	16e10000 	strbtne	r0, [r1], r0
    3328:	80010000 	andhi	r0, r1, r0
    332c:	0000032a 	andeq	r0, r0, sl, lsr #6
    3330:	10f90004 	rscsne	r0, r9, r4
    3334:	01040000 	mrseq	r0, (UNDEF: 4)
    3338:	0000180d 	andeq	r1, r0, sp, lsl #16
    333c:	0019c60c 	andseq	ip, r9, ip, lsl #12
    3340:	00167900 	andseq	r7, r6, r0, lsl #18
    3344:	00178900 	andseq	r8, r7, r0, lsl #18
    3348:	05040200 	streq	r0, [r4, #-512]	; 0xfffffe00
    334c:	00746e69 	rsbseq	r6, r4, r9, ror #28
    3350:	0f070403 	svceq	0x00070403
    3354:	0300001a 	movweq	r0, #26
    3358:	01b70508 			; <UNDEFINED> instruction: 0x01b70508
    335c:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    3360:	0019ba04 	andseq	fp, r9, r4, lsl #20
    3364:	08010300 	stmdaeq	r1, {r8, r9}
    3368:	00000361 	andeq	r0, r0, r1, ror #6
    336c:	63060103 	movwvs	r0, #24835	; 0x6103
    3370:	04000003 	streq	r0, [r0], #-3
    3374:	00001b92 	muleq	r0, r2, fp
    3378:	00390107 	eorseq	r0, r9, r7, lsl #2
    337c:	17010000 	strne	r0, [r1, -r0]
    3380:	0001d406 	andeq	sp, r1, r6, lsl #8
    3384:	171c0500 	ldrne	r0, [ip, -r0, lsl #10]
    3388:	05000000 	streq	r0, [r0, #-0]
    338c:	00001c41 	andeq	r1, r0, r1, asr #24
    3390:	18ef0501 	stmiane	pc!, {r0, r8, sl}^	; <UNPREDICTABLE>
    3394:	05020000 	streq	r0, [r2, #-0]
    3398:	000019ad 	andeq	r1, r0, sp, lsr #19
    339c:	1bab0503 	blne	feac47b0 <_bss_end+0xfeab9cd0>
    33a0:	05040000 	streq	r0, [r4, #-0]
    33a4:	00001c51 	andeq	r1, r0, r1, asr ip
    33a8:	1bc10505 	blne	ff0447c4 <_bss_end+0xff039ce4>
    33ac:	05060000 	streq	r0, [r6, #-0]
    33b0:	000019f6 	strdeq	r1, [r0], -r6
    33b4:	1b3c0507 	blne	f047d8 <_bss_end+0xef9cf8>
    33b8:	05080000 	streq	r0, [r8, #-0]
    33bc:	00001b4a 	andeq	r1, r0, sl, asr #22
    33c0:	1b580509 	blne	16047ec <_bss_end+0x15f9d0c>
    33c4:	050a0000 	streq	r0, [sl, #-0]
    33c8:	00001a5f 	andeq	r1, r0, pc, asr sl
    33cc:	1a4f050b 	bne	13c4800 <_bss_end+0x13b9d20>
    33d0:	050c0000 	streq	r0, [ip, #-0]
    33d4:	00001738 	andeq	r1, r0, r8, lsr r7
    33d8:	1751050d 	ldrbne	r0, [r1, -sp, lsl #10]
    33dc:	050e0000 	streq	r0, [lr, #-0]
    33e0:	00001a40 	andeq	r1, r0, r0, asr #20
    33e4:	1c04050f 	cfstr32ne	mvfx0, [r4], {15}
    33e8:	05100000 	ldreq	r0, [r0, #-0]
    33ec:	00001b81 	andeq	r1, r0, r1, lsl #23
    33f0:	1bf50511 	blne	ffd4483c <_bss_end+0xffd39d5c>
    33f4:	05120000 	ldreq	r0, [r2, #-0]
    33f8:	000017fe 	strdeq	r1, [r0], -lr
    33fc:	177b0513 			; <UNDEFINED> instruction: 0x177b0513
    3400:	05140000 	ldreq	r0, [r4, #-0]
    3404:	00001745 	andeq	r1, r0, r5, asr #14
    3408:	1ade0515 	bne	ff784864 <_bss_end+0xff779d84>
    340c:	05160000 	ldreq	r0, [r6, #-0]
    3410:	000017b2 			; <UNDEFINED> instruction: 0x000017b2
    3414:	16ed0517 	usatne	r0, #13, r7, lsl #10
    3418:	05180000 	ldreq	r0, [r8, #-0]
    341c:	00001be7 	andeq	r1, r0, r7, ror #23
    3420:	1a1c0519 	bne	70488c <_bss_end+0x6f9dac>
    3424:	051a0000 	ldreq	r0, [sl, #-0]
    3428:	00001af6 	strdeq	r1, [r0], -r6
    342c:	1786051b 	usada8ne	r6, fp, r5, r0
    3430:	051c0000 	ldreq	r0, [ip, #-0]
    3434:	00001992 	muleq	r0, r2, r9
    3438:	18e1051d 	stmiane	r1!, {r0, r2, r3, r4, r8, sl}^
    343c:	051e0000 	ldreq	r0, [lr, #-0]
    3440:	00001b73 	andeq	r1, r0, r3, ror fp
    3444:	1bcf051f 	blne	ff3c48c8 <_bss_end+0xff3b9de8>
    3448:	05200000 	streq	r0, [r0, #-0]!
    344c:	00001c10 	andeq	r1, r0, r0, lsl ip
    3450:	1c1e0521 	cfldr32ne	mvfx0, [lr], {33}	; 0x21
    3454:	05220000 	streq	r0, [r2, #-0]!
    3458:	00001a33 	andeq	r1, r0, r3, lsr sl
    345c:	19560523 	ldmdbne	r6, {r0, r1, r5, r8, sl}^
    3460:	05240000 	streq	r0, [r4, #-0]!
    3464:	00001795 	muleq	r0, r5, r7
    3468:	19e90525 	stmibne	r9!, {r0, r2, r5, r8, sl}^
    346c:	05260000 	streq	r0, [r6, #-0]!
    3470:	000018fb 	strdeq	r1, [r0], -fp
    3474:	1b9e0527 	blne	fe784918 <_bss_end+0xfe779e38>
    3478:	05280000 	streq	r0, [r8, #-0]!
    347c:	0000190b 	andeq	r1, r0, fp, lsl #18
    3480:	191a0529 	ldmdbne	sl, {r0, r3, r5, r8, sl}
    3484:	052a0000 	streq	r0, [sl, #-0]!
    3488:	00001929 	andeq	r1, r0, r9, lsr #18
    348c:	1938052b 	ldmdbne	r8!, {r0, r1, r3, r5, r8, sl}
    3490:	052c0000 	streq	r0, [ip, #-0]!
    3494:	000018c6 	andeq	r1, r0, r6, asr #17
    3498:	1947052d 	stmdbne	r7, {r0, r2, r3, r5, r8, sl}^
    349c:	052e0000 	streq	r0, [lr, #-0]!
    34a0:	00001b2d 	andeq	r1, r0, sp, lsr #22
    34a4:	1965052f 	stmdbne	r5!, {r0, r1, r2, r3, r5, r8, sl}^
    34a8:	05300000 	ldreq	r0, [r0, #-0]!
    34ac:	00001974 	andeq	r1, r0, r4, ror r9
    34b0:	17260531 			; <UNDEFINED> instruction: 0x17260531
    34b4:	05320000 	ldreq	r0, [r2, #-0]!
    34b8:	00001a7e 	andeq	r1, r0, lr, ror sl
    34bc:	1a8e0533 	bne	fe384990 <_bss_end+0xfe379eb0>
    34c0:	05340000 	ldreq	r0, [r4, #-0]!
    34c4:	00001a9e 	muleq	r0, lr, sl
    34c8:	18b40535 	ldmne	r4!, {r0, r2, r4, r5, r8, sl}
    34cc:	05360000 	ldreq	r0, [r6, #-0]!
    34d0:	00001aae 	andeq	r1, r0, lr, lsr #21
    34d4:	1abe0537 	bne	fef849b8 <_bss_end+0xfef79ed8>
    34d8:	05380000 	ldreq	r0, [r8, #-0]!
    34dc:	00001ace 	andeq	r1, r0, lr, asr #21
    34e0:	17a50539 			; <UNDEFINED> instruction: 0x17a50539
    34e4:	053a0000 	ldreq	r0, [sl, #-0]!
    34e8:	0000175e 	andeq	r1, r0, lr, asr r7
    34ec:	1983053b 	stmibne	r3, {r0, r1, r3, r4, r5, r8, sl}
    34f0:	053c0000 	ldreq	r0, [ip, #-0]!
    34f4:	000016fd 	strdeq	r1, [r0], -sp
    34f8:	1ae9053d 	bne	ffa449f4 <_bss_end+0xffa39f14>
    34fc:	003e0000 	eorseq	r0, lr, r0
    3500:	0017e506 	andseq	lr, r7, r6, lsl #10
    3504:	6b010200 	blvs	43d0c <_bss_end+0x3922c>
    3508:	01ff0802 	mvnseq	r0, r2, lsl #16
    350c:	a8070000 	stmdage	r7, {}	; <UNPREDICTABLE>
    3510:	01000019 	tsteq	r0, r9, lsl r0
    3514:	47140270 			; <UNDEFINED> instruction: 0x47140270
    3518:	00000000 	andeq	r0, r0, r0
    351c:	0018c107 	andseq	ip, r8, r7, lsl #2
    3520:	02710100 	rsbseq	r0, r1, #0, 2
    3524:	00004714 	andeq	r4, r0, r4, lsl r7
    3528:	08000100 	stmdaeq	r0, {r8}
    352c:	000001d4 	ldrdeq	r0, [r0], -r4
    3530:	0001ff09 	andeq	pc, r1, r9, lsl #30
    3534:	00021400 	andeq	r1, r2, r0, lsl #8
    3538:	00240a00 	eoreq	r0, r4, r0, lsl #20
    353c:	00110000 	andseq	r0, r1, r0
    3540:	00020408 	andeq	r0, r2, r8, lsl #8
    3544:	1a6c0b00 	bne	1b0614c <_bss_end+0x1afb66c>
    3548:	74010000 	strvc	r0, [r1], #-0
    354c:	02142602 	andseq	r2, r4, #2097152	; 0x200000
    3550:	3a240000 	bcc	903558 <_bss_end+0x8f8a78>
    3554:	0f3d0a3d 	svceq	0x003d0a3d
    3558:	323d243d 	eorscc	r2, sp, #1023410176	; 0x3d000000
    355c:	053d023d 	ldreq	r0, [sp, #-573]!	; 0xfffffdc3
    3560:	0d3d133d 	ldceq	3, cr1, [sp, #-244]!	; 0xffffff0c
    3564:	233d0c3d 	teqcs	sp, #15616	; 0x3d00
    3568:	263d113d 			; <UNDEFINED> instruction: 0x263d113d
    356c:	173d013d 			; <UNDEFINED> instruction: 0x173d013d
    3570:	093d083d 	ldmdbeq	sp!, {r0, r2, r3, r4, r5, fp}
    3574:	0300003d 	movweq	r0, #61	; 0x3d
    3578:	03b60702 			; <UNDEFINED> instruction: 0x03b60702
    357c:	01030000 	mrseq	r0, (UNDEF: 3)
    3580:	00036a08 	andeq	r6, r3, r8, lsl #20
    3584:	040d0c00 	streq	r0, [sp], #-3072	; 0xfffff400
    3588:	00000259 	andeq	r0, r0, r9, asr r2
    358c:	001c2c0e 	andseq	r2, ip, lr, lsl #24
    3590:	39010700 	stmdbcc	r1, {r8, r9, sl}
    3594:	02000000 	andeq	r0, r0, #0
    3598:	9e0604f7 	mcrls	4, 0, r0, cr6, cr7, {7}
    359c:	05000002 	streq	r0, [r0, #-2]
    35a0:	000017bf 			; <UNDEFINED> instruction: 0x000017bf
    35a4:	17ca0500 	strbne	r0, [sl, r0, lsl #10]
    35a8:	05010000 	streq	r0, [r1, #-0]
    35ac:	000017dc 	ldrdeq	r1, [r0], -ip
    35b0:	17f60502 	ldrbne	r0, [r6, r2, lsl #10]!
    35b4:	05030000 	streq	r0, [r3, #-0]
    35b8:	00001b66 	andeq	r1, r0, r6, ror #22
    35bc:	18d50504 	ldmne	r5, {r2, r8, sl}^
    35c0:	05050000 	streq	r0, [r5, #-0]
    35c4:	00001b1f 	andeq	r1, r0, pc, lsl fp
    35c8:	02030006 	andeq	r0, r3, #6
    35cc:	00022a05 	andeq	r2, r2, r5, lsl #20
    35d0:	07080300 	streq	r0, [r8, -r0, lsl #6]
    35d4:	00001a05 	andeq	r1, r0, r5, lsl #20
    35d8:	16040403 	strne	r0, [r4], -r3, lsl #8
    35dc:	03000017 	movweq	r0, #23
    35e0:	170e0308 	strne	r0, [lr, -r8, lsl #6]
    35e4:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    35e8:	0019bf04 	andseq	fp, r9, r4, lsl #30
    35ec:	03100300 	tsteq	r0, #0, 6
    35f0:	00001b10 	andeq	r1, r0, r0, lsl fp
    35f4:	001b070f 	andseq	r0, fp, pc, lsl #14
    35f8:	102a0300 	eorne	r0, sl, r0, lsl #6
    35fc:	0000025a 	andeq	r0, r0, sl, asr r2
    3600:	0002c809 	andeq	ip, r2, r9, lsl #16
    3604:	0002df00 	andeq	sp, r2, r0, lsl #30
    3608:	11001000 	mrsne	r1, (UNDEF: 0)
    360c:	0000151c 	andeq	r1, r0, ip, lsl r5
    3610:	d4112f03 	ldrle	r2, [r1], #-3843	; 0xfffff0fd
    3614:	11000002 	tstne	r0, r2
    3618:	000014fc 	strdeq	r1, [r0], -ip
    361c:	d4113003 	ldrle	r3, [r1], #-3
    3620:	09000002 	stmdbeq	r0, {r1}
    3624:	000002c8 	andeq	r0, r0, r8, asr #5
    3628:	00000307 	andeq	r0, r0, r7, lsl #6
    362c:	0000240a 	andeq	r2, r0, sl, lsl #8
    3630:	12000100 	andne	r0, r0, #0, 2
    3634:	000002df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    3638:	0a093304 	beq	250250 <_bss_end+0x245770>
    363c:	000002f7 	strdeq	r0, [r0], -r7
    3640:	aa540305 	bge	150425c <_bss_end+0x14f977c>
    3644:	eb120000 	bl	48364c <_bss_end+0x478b6c>
    3648:	04000002 	streq	r0, [r0], #-2
    364c:	f70a0934 			; <UNDEFINED> instruction: 0xf70a0934
    3650:	05000002 	streq	r0, [r0, #-2]
    3654:	00aa6803 	adceq	r6, sl, r3, lsl #16
	...

Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
       0:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
       4:	030b130e 	movweq	r1, #45838	; 0xb30e
       8:	110e1b0e 	tstne	lr, lr, lsl #22
       c:	10061201 	andne	r1, r6, r1, lsl #4
      10:	02000017 	andeq	r0, r0, #23
      14:	193f002e 	ldmdbne	pc!, {r1, r2, r3, r5}	; <UNPREDICTABLE>
      18:	0b3a0e03 	bleq	e8382c <_bss_end+0xe78d4c>
      1c:	0b390b3b 	bleq	e42d10 <_bss_end+0xe38230>
      20:	06120111 			; <UNDEFINED> instruction: 0x06120111
      24:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
      28:	03000019 	movweq	r0, #25
      2c:	0e030139 	mcreq	1, 0, r0, cr3, cr9, {1}
      30:	0b3b0b3a 	bleq	ec2d20 <_bss_end+0xeb8240>
      34:	00001301 	andeq	r1, r0, r1, lsl #6
      38:	3f012e04 	svccc	0x00012e04
      3c:	3a0e0319 	bcc	380ca8 <_bss_end+0x3761c8>
      40:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
      44:	01193c0b 	tsteq	r9, fp, lsl #24
      48:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
      4c:	13490005 	movtne	r0, #36869	; 0x9005
      50:	16060000 	strne	r0, [r6], -r0
      54:	3a0e0300 	bcc	380c5c <_bss_end+0x37617c>
      58:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
      5c:	0013490b 	andseq	r4, r3, fp, lsl #18
      60:	012e0700 			; <UNDEFINED> instruction: 0x012e0700
      64:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
      68:	0b3b0b3a 	bleq	ec2d58 <_bss_end+0xeb8278>
      6c:	13490b39 	movtne	r0, #39737	; 0x9b39
      70:	0000193c 	andeq	r1, r0, ip, lsr r9
      74:	0b000f08 	bleq	3c9c <CPSR_IRQ_INHIBIT+0x3c1c>
      78:	0013490b 	andseq	r4, r3, fp, lsl #18
      7c:	00240900 	eoreq	r0, r4, r0, lsl #18
      80:	0b3e0b0b 	bleq	f82cb4 <_bss_end+0xf781d4>
      84:	00000e03 	andeq	r0, r0, r3, lsl #28
      88:	47012e0a 	strmi	r2, [r1, -sl, lsl #28]
      8c:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
      90:	97184006 	ldrls	r4, [r8, -r6]
      94:	13011942 	movwne	r1, #6466	; 0x1942
      98:	050b0000 	streq	r0, [fp, #-0]
      9c:	02134900 	andseq	r4, r3, #0, 18
      a0:	0c000018 	stceq	0, cr0, [r0], {24}
      a4:	08030005 	stmdaeq	r3, {r0, r2}
      a8:	0b3b0b3a 	bleq	ec2d98 <_bss_end+0xeb82b8>
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
      e4:	0b0b0024 	bleq	2c017c <_bss_end+0x2b569c>
      e8:	0e030b3e 	vmoveq.16	d3[0], r0
      ec:	24030000 	strcs	r0, [r3], #-0
      f0:	3e0b0b00 	vmlacc.f64	d0, d11, d0
      f4:	0008030b 	andeq	r0, r8, fp, lsl #6
      f8:	00160400 	andseq	r0, r6, r0, lsl #8
      fc:	0b3a0e03 	bleq	e83910 <_bss_end+0xe78e30>
     100:	0b390b3b 	bleq	e42df4 <_bss_end+0xe38314>
     104:	00001349 	andeq	r1, r0, r9, asr #6
     108:	49002605 	stmdbmi	r0, {r0, r2, r9, sl, sp}
     10c:	06000013 			; <UNDEFINED> instruction: 0x06000013
     110:	08030139 	stmdaeq	r3, {r0, r3, r4, r5, r8}
     114:	0b3b0b3a 	bleq	ec2e04 <_bss_end+0xeb8324>
     118:	13010b39 	movwne	r0, #6969	; 0x1b39
     11c:	34070000 	strcc	r0, [r7], #-0
     120:	3a0e0300 	bcc	380d28 <_bss_end+0x376248>
     124:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     128:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
     12c:	6c061c19 	stcvs	12, cr1, [r6], {25}
     130:	08000019 	stmdaeq	r0, {r0, r3, r4}
     134:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
     138:	0b3b0b3a 	bleq	ec2e28 <_bss_end+0xeb8348>
     13c:	13490b39 	movtne	r0, #39737	; 0x9b39
     140:	0b1c193c 	bleq	706638 <_bss_end+0x6fbb58>
     144:	0000196c 	andeq	r1, r0, ip, ror #18
     148:	03010409 	movweq	r0, #5129	; 0x1409
     14c:	3e196d0e 	cdpcc	13, 1, cr6, cr9, cr14, {0}
     150:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
     154:	3b0b3a13 	blcc	2ce9a8 <_bss_end+0x2c3ec8>
     158:	010b390b 	tsteq	fp, fp, lsl #18
     15c:	0a000013 	beq	1b0 <CPSR_IRQ_INHIBIT+0x130>
     160:	08030028 	stmdaeq	r3, {r3, r5}
     164:	00000b1c 	andeq	r0, r0, ip, lsl fp
     168:	0300280b 	movweq	r2, #2059	; 0x80b
     16c:	000b1c0e 	andeq	r1, fp, lr, lsl #24
     170:	00340c00 	eorseq	r0, r4, r0, lsl #24
     174:	00001347 	andeq	r1, r0, r7, asr #6
     178:	0301020d 	movweq	r0, #4621	; 0x120d
     17c:	3a0b0b0e 	bcc	2c2dbc <_bss_end+0x2b82dc>
     180:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     184:	0013010b 	andseq	r0, r3, fp, lsl #2
     188:	000d0e00 	andeq	r0, sp, r0, lsl #28
     18c:	0b3a0e03 	bleq	e839a0 <_bss_end+0xe78ec0>
     190:	0b390b3b 	bleq	e42e84 <_bss_end+0xe383a4>
     194:	0b381349 	bleq	e04ec0 <_bss_end+0xdfa3e0>
     198:	2e0f0000 	cdpcs	0, 0, cr0, cr15, cr0, {0}
     19c:	03193f01 	tsteq	r9, #1, 30
     1a0:	3b0b3a0e 	blcc	2ce9e0 <_bss_end+0x2c3f00>
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
     1cc:	0b3b0b3a 	bleq	ec2ebc <_bss_end+0xeb83dc>
     1d0:	0e6e0b39 	vmoveq.8	d14[5], r0
     1d4:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
     1d8:	13011364 	movwne	r1, #4964	; 0x1364
     1dc:	2e130000 	cdpcs	0, 1, cr0, cr3, cr0, {0}
     1e0:	03193f01 	tsteq	r9, #1, 30
     1e4:	3b0b3a0e 	blcc	2cea24 <_bss_end+0x2c3f44>
     1e8:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     1ec:	3213490e 	andscc	r4, r3, #229376	; 0x38000
     1f0:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
     1f4:	14000013 	strne	r0, [r0], #-19	; 0xffffffed
     1f8:	0b0b000f 	bleq	2c023c <_bss_end+0x2b575c>
     1fc:	00001349 	andeq	r1, r0, r9, asr #6
     200:	03003415 	movweq	r3, #1045	; 0x415
     204:	3b0b3a0e 	blcc	2cea44 <_bss_end+0x2c3f64>
     208:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     20c:	3c193f13 	ldccc	15, cr3, [r9], {19}
     210:	16000019 			; <UNDEFINED> instruction: 0x16000019
     214:	13470034 	movtne	r0, #28724	; 0x7034
     218:	0b3b0b3a 	bleq	ec2f08 <_bss_end+0xeb8428>
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
     24c:	3b0b3a0e 	blcc	2cea8c <_bss_end+0x2c3fac>
     250:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     254:	00180213 	andseq	r0, r8, r3, lsl r2
     258:	012e1a00 			; <UNDEFINED> instruction: 0x012e1a00
     25c:	0b3a1347 	bleq	e84f80 <_bss_end+0xe7a4a0>
     260:	0b390b3b 	bleq	e42f54 <_bss_end+0xe38474>
     264:	01111364 	tsteq	r1, r4, ror #6
     268:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
     26c:	01194297 			; <UNDEFINED> instruction: 0x01194297
     270:	1b000013 	blne	2c4 <CPSR_IRQ_INHIBIT+0x244>
     274:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
     278:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
     27c:	00001802 	andeq	r1, r0, r2, lsl #16
     280:	47012e1c 	smladmi	r1, ip, lr, r2
     284:	3b0b3a13 	blcc	2cead8 <_bss_end+0x2c3ff8>
     288:	640b390b 	strvs	r3, [fp], #-2315	; 0xfffff6f5
     28c:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
     290:	96184006 	ldrls	r4, [r8], -r6
     294:	13011942 	movwne	r1, #6466	; 0x1942
     298:	2e1d0000 	cdpcs	0, 1, cr0, cr13, cr0, {0}
     29c:	3a134701 	bcc	4d1ea8 <_bss_end+0x4c73c8>
     2a0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     2a4:	2013640b 	andscs	r6, r3, fp, lsl #8
     2a8:	0013010b 	andseq	r0, r3, fp, lsl #2
     2ac:	00051e00 	andeq	r1, r5, r0, lsl #28
     2b0:	13490e03 	movtne	r0, #40451	; 0x9e03
     2b4:	00001934 	andeq	r1, r0, r4, lsr r9
     2b8:	0300051f 	movweq	r0, #1311	; 0x51f
     2bc:	3b0b3a0e 	blcc	2ceafc <_bss_end+0x2c401c>
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
     2e8:	0b130e25 	bleq	4c3b84 <_bss_end+0x4b90a4>
     2ec:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
     2f0:	06120111 			; <UNDEFINED> instruction: 0x06120111
     2f4:	00001710 	andeq	r1, r0, r0, lsl r7
     2f8:	0b002402 	bleq	9308 <_ZN5CUARTC1ER4CAUX+0x64>
     2fc:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
     300:	0300000e 	movweq	r0, #14
     304:	0b0b0024 	bleq	2c039c <_bss_end+0x2b58bc>
     308:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
     30c:	16040000 	strne	r0, [r4], -r0
     310:	3a0e0300 	bcc	380f18 <_bss_end+0x376438>
     314:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     318:	0013490b 	andseq	r4, r3, fp, lsl #18
     31c:	00260500 	eoreq	r0, r6, r0, lsl #10
     320:	00001349 	andeq	r1, r0, r9, asr #6
     324:	03013906 	movweq	r3, #6406	; 0x1906
     328:	3b0b3a08 	blcc	2ceb50 <_bss_end+0x2c4070>
     32c:	010b390b 	tsteq	fp, fp, lsl #18
     330:	07000013 	smladeq	r0, r3, r0, r0
     334:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
     338:	0b3b0b3a 	bleq	ec3028 <_bss_end+0xeb8548>
     33c:	13490b39 	movtne	r0, #39737	; 0x9b39
     340:	061c193c 			; <UNDEFINED> instruction: 0x061c193c
     344:	0000196c 	andeq	r1, r0, ip, ror #18
     348:	03003408 	movweq	r3, #1032	; 0x408
     34c:	3b0b3a0e 	blcc	2ceb8c <_bss_end+0x2c40ac>
     350:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     354:	1c193c13 	ldcne	12, cr3, [r9], {19}
     358:	00196c0b 	andseq	r6, r9, fp, lsl #24
     35c:	01040900 	tsteq	r4, r0, lsl #18
     360:	196d0e03 	stmdbne	sp!, {r0, r1, r9, sl, fp}^
     364:	0b0b0b3e 	bleq	2c3064 <_bss_end+0x2b8584>
     368:	0b3a1349 	bleq	e85094 <_bss_end+0xe7a5b4>
     36c:	0b390b3b 	bleq	e43060 <_bss_end+0xe38580>
     370:	00001301 	andeq	r1, r0, r1, lsl #6
     374:	0300280a 	movweq	r2, #2058	; 0x80a
     378:	000b1c0e 	andeq	r1, fp, lr, lsl #24
     37c:	00340b00 	eorseq	r0, r4, r0, lsl #22
     380:	00001347 	andeq	r1, r0, r7, asr #6
     384:	0300280c 	movweq	r2, #2060	; 0x80c
     388:	000b1c08 	andeq	r1, fp, r8, lsl #24
     38c:	01020d00 	tsteq	r2, r0, lsl #26
     390:	0b0b0e03 	bleq	2c3ba4 <_bss_end+0x2b90c4>
     394:	0b3b0b3a 	bleq	ec3084 <_bss_end+0xeb85a4>
     398:	13010b39 	movwne	r0, #6969	; 0x1b39
     39c:	0d0e0000 	stceq	0, cr0, [lr, #-0]
     3a0:	3a0e0300 	bcc	380fa8 <_bss_end+0x3764c8>
     3a4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     3a8:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
     3ac:	0f00000b 	svceq	0x0000000b
     3b0:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
     3b4:	0b3a0e03 	bleq	e83bc8 <_bss_end+0xe790e8>
     3b8:	0b390b3b 	bleq	e430ac <_bss_end+0xe385cc>
     3bc:	13490e6e 	movtne	r0, #40558	; 0x9e6e
     3c0:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
     3c4:	13011364 	movwne	r1, #4964	; 0x1364
     3c8:	05100000 	ldreq	r0, [r0, #-0]
     3cc:	34134900 	ldrcc	r4, [r3], #-2304	; 0xfffff700
     3d0:	11000019 	tstne	r0, r9, lsl r0
     3d4:	13490005 	movtne	r0, #36869	; 0x9005
     3d8:	2e120000 	cdpcs	0, 1, cr0, cr2, cr0, {0}
     3dc:	03193f01 	tsteq	r9, #1, 30
     3e0:	3b0b3a0e 	blcc	2cec20 <_bss_end+0x2c4140>
     3e4:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     3e8:	3c0b320e 	sfmcc	f3, 4, [fp], {14}
     3ec:	01136419 	tsteq	r3, r9, lsl r4
     3f0:	13000013 	movwne	r0, #19
     3f4:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
     3f8:	0b3a0e03 	bleq	e83c0c <_bss_end+0xe7912c>
     3fc:	0b390b3b 	bleq	e430f0 <_bss_end+0xe38610>
     400:	13490e6e 	movtne	r0, #40558	; 0x9e6e
     404:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
     408:	00001364 	andeq	r1, r0, r4, ror #6
     40c:	0b000f14 	bleq	4064 <CPSR_IRQ_INHIBIT+0x3fe4>
     410:	0013490b 	andseq	r4, r3, fp, lsl #18
     414:	00101500 	andseq	r1, r0, r0, lsl #10
     418:	13490b0b 	movtne	r0, #39691	; 0x9b0b
     41c:	34160000 	ldrcc	r0, [r6], #-0
     420:	3a0e0300 	bcc	381028 <_bss_end+0x376548>
     424:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     428:	3f13490b 	svccc	0x0013490b
     42c:	00193c19 	andseq	r3, r9, r9, lsl ip
     430:	00341700 	eorseq	r1, r4, r0, lsl #14
     434:	0b3a1347 	bleq	e85158 <_bss_end+0xe7a678>
     438:	0b390b3b 	bleq	e4312c <_bss_end+0xe3864c>
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
     468:	3a0e0300 	bcc	381070 <_bss_end+0x376590>
     46c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     470:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
     474:	1b000018 	blne	4dc <CPSR_IRQ_INHIBIT+0x45c>
     478:	1347012e 	movtne	r0, #28974	; 0x712e
     47c:	0b3b0b3a 	bleq	ec316c <_bss_end+0xeb868c>
     480:	13640b39 	cmnne	r4, #58368	; 0xe400
     484:	06120111 			; <UNDEFINED> instruction: 0x06120111
     488:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
     48c:	00130119 	andseq	r0, r3, r9, lsl r1
     490:	00051c00 	andeq	r1, r5, r0, lsl #24
     494:	13490e03 	movtne	r0, #40451	; 0x9e03
     498:	18021934 	stmdane	r2, {r2, r4, r5, r8, fp, ip}
     49c:	051d0000 	ldreq	r0, [sp, #-0]
     4a0:	3a080300 	bcc	2010a8 <_bss_end+0x1f65c8>
     4a4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     4a8:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
     4ac:	1e000018 	mcrne	0, 0, r0, cr0, cr8, {0}
     4b0:	08030034 	stmdaeq	r3, {r2, r4, r5}
     4b4:	0b3b0b3a 	bleq	ec31a4 <_bss_end+0xeb86c4>
     4b8:	13490b39 	movtne	r0, #39737	; 0x9b39
     4bc:	00001802 	andeq	r1, r0, r2, lsl #16
     4c0:	47012e1f 	smladmi	r1, pc, lr, r2	; <UNPREDICTABLE>
     4c4:	3b0b3a13 	blcc	2ced18 <_bss_end+0x2c4238>
     4c8:	640b390b 	strvs	r3, [fp], #-2315	; 0xfffff6f5
     4cc:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
     4d0:	97184006 	ldrls	r4, [r8, -r6]
     4d4:	13011942 	movwne	r1, #6466	; 0x1942
     4d8:	2e200000 	cdpcs	0, 2, cr0, cr0, cr0, {0}
     4dc:	3a134701 	bcc	4d20e8 <_bss_end+0x4c7608>
     4e0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     4e4:	2013640b 	andscs	r6, r3, fp, lsl #8
     4e8:	0013010b 	andseq	r0, r3, fp, lsl #2
     4ec:	00052100 	andeq	r2, r5, r0, lsl #2
     4f0:	13490e03 	movtne	r0, #40451	; 0x9e03
     4f4:	00001934 	andeq	r1, r0, r4, lsr r9
     4f8:	03000522 	movweq	r0, #1314	; 0x522
     4fc:	3b0b3a0e 	blcc	2ced3c <_bss_end+0x2c425c>
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
     528:	0b130e25 	bleq	4c3dc4 <_bss_end+0x4b92e4>
     52c:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
     530:	01111755 	tsteq	r1, r5, asr r7
     534:	00001710 	andeq	r1, r0, r0, lsl r7
     538:	03010202 	movweq	r0, #4610	; 0x1202
     53c:	3a0b0b0e 	bcc	2c317c <_bss_end+0x2b869c>
     540:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     544:	0013010b 	andseq	r0, r3, fp, lsl #2
     548:	01040300 	mrseq	r0, LR_abt
     54c:	196d0e03 	stmdbne	sp!, {r0, r1, r9, sl, fp}^
     550:	0b0b0b3e 	bleq	2c3250 <_bss_end+0x2b8770>
     554:	0b3a1349 	bleq	e85280 <_bss_end+0xe7a7a0>
     558:	0b390b3b 	bleq	e4324c <_bss_end+0xe3876c>
     55c:	13010b32 	movwne	r0, #6962	; 0x1b32
     560:	28040000 	stmdacs	r4, {}	; <UNPREDICTABLE>
     564:	1c080300 	stcne	3, cr0, [r8], {-0}
     568:	0500000b 	streq	r0, [r0, #-11]
     56c:	13490026 	movtne	r0, #36902	; 0x9026
     570:	13060000 	movwne	r0, #24576	; 0x6000
     574:	0b0e0301 	bleq	381180 <_bss_end+0x3766a0>
     578:	3b0b3a0b 	blcc	2cedac <_bss_end+0x2c42cc>
     57c:	010b390b 	tsteq	fp, fp, lsl #18
     580:	07000013 	smladeq	r0, r3, r0, r0
     584:	0803000d 	stmdaeq	r3, {r0, r2, r3}
     588:	0b3b0b3a 	bleq	ec3278 <_bss_end+0xeb8798>
     58c:	13490b39 	movtne	r0, #39737	; 0x9b39
     590:	00000b38 	andeq	r0, r0, r8, lsr fp
     594:	03000d08 	movweq	r0, #3336	; 0xd08
     598:	3b0b3a0e 	blcc	2cedd8 <_bss_end+0x2c42f8>
     59c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     5a0:	32193f13 	andscc	r3, r9, #19, 30	; 0x4c
     5a4:	1c193c0b 	ldcne	12, cr3, [r9], {11}
     5a8:	00196c0b 	andseq	r6, r9, fp, lsl #24
     5ac:	000d0900 	andeq	r0, sp, r0, lsl #18
     5b0:	0b3a0e03 	bleq	e83dc4 <_bss_end+0xe792e4>
     5b4:	0b390b3b 	bleq	e432a8 <_bss_end+0xe387c8>
     5b8:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
     5bc:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
     5c0:	0000196c 	andeq	r1, r0, ip, ror #18
     5c4:	3f012e0a 	svccc	0x00012e0a
     5c8:	3a0e0319 	bcc	381234 <_bss_end+0x376754>
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
     5f8:	0b3b0b3a 	bleq	ec32e8 <_bss_end+0xeb8808>
     5fc:	0e6e0b39 	vmoveq.8	d14[5], r0
     600:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
     604:	13011364 	movwne	r1, #4964	; 0x1364
     608:	2e0e0000 	cdpcs	0, 0, cr0, cr14, cr0, {0}
     60c:	03193f01 	tsteq	r9, #1, 30
     610:	3b0b3a0e 	blcc	2cee50 <_bss_end+0x2c4370>
     614:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     618:	3213490e 	andscc	r4, r3, #229376	; 0x38000
     61c:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
     620:	00130113 	andseq	r0, r3, r3, lsl r1
     624:	012e0f00 			; <UNDEFINED> instruction: 0x012e0f00
     628:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     62c:	0b3b0b3a 	bleq	ec331c <_bss_end+0xeb883c>
     630:	0e6e0b39 	vmoveq.8	d14[5], r0
     634:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
     638:	00001301 	andeq	r1, r0, r1, lsl #6
     63c:	03000d10 	movweq	r0, #3344	; 0xd10
     640:	3b0b3a0e 	blcc	2cee80 <_bss_end+0x2c43a0>
     644:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     648:	000b3813 	andeq	r3, fp, r3, lsl r8
     64c:	00241100 	eoreq	r1, r4, r0, lsl #2
     650:	0b3e0b0b 	bleq	f83284 <_bss_end+0xf787a4>
     654:	00000e03 	andeq	r0, r0, r3, lsl #28
     658:	0b000f12 	bleq	42a8 <CPSR_IRQ_INHIBIT+0x4228>
     65c:	0013490b 	andseq	r4, r3, fp, lsl #18
     660:	00101300 	andseq	r1, r0, r0, lsl #6
     664:	13490b0b 	movtne	r0, #39691	; 0x9b0b
     668:	35140000 	ldrcc	r0, [r4, #-0]
     66c:	00134900 	andseq	r4, r3, r0, lsl #18
     670:	00341500 	eorseq	r1, r4, r0, lsl #10
     674:	0b3a0e03 	bleq	e83e88 <_bss_end+0xe793a8>
     678:	0b390b3b 	bleq	e4336c <_bss_end+0xe3888c>
     67c:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
     680:	0000193c 	andeq	r1, r0, ip, lsr r9
     684:	47003416 	smladmi	r0, r6, r4, r3
     688:	3b0b3a13 	blcc	2ceedc <_bss_end+0x2c43fc>
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
     6bc:	0b3a0e03 	bleq	e83ed0 <_bss_end+0xe793f0>
     6c0:	0b390b3b 	bleq	e433b4 <_bss_end+0xe388d4>
     6c4:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
     6c8:	241a0000 	ldrcs	r0, [sl], #-0
     6cc:	3e0b0b00 	vmlacc.f64	d0, d11, d0
     6d0:	0008030b 	andeq	r0, r8, fp, lsl #6
     6d4:	012e1b00 			; <UNDEFINED> instruction: 0x012e1b00
     6d8:	0b3a1347 	bleq	e853fc <_bss_end+0xe7a91c>
     6dc:	0b390b3b 	bleq	e433d0 <_bss_end+0xe388f0>
     6e0:	01111364 	tsteq	r1, r4, ror #6
     6e4:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
     6e8:	01194296 			; <UNDEFINED> instruction: 0x01194296
     6ec:	1c000013 	stcne	0, cr0, [r0], {19}
     6f0:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
     6f4:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
     6f8:	00001802 	andeq	r1, r0, r2, lsl #16
     6fc:	0300341d 	movweq	r3, #1053	; 0x41d
     700:	3b0b3a08 	blcc	2cef28 <_bss_end+0x2c4448>
     704:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     708:	00180213 	andseq	r0, r8, r3, lsl r2
     70c:	010b1e00 	tsteq	fp, r0, lsl #28
     710:	06120111 			; <UNDEFINED> instruction: 0x06120111
     714:	051f0000 	ldreq	r0, [pc, #-0]	; 71c <CPSR_IRQ_INHIBIT+0x69c>
     718:	3a080300 	bcc	201320 <_bss_end+0x1f6840>
     71c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     720:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
     724:	20000018 	andcs	r0, r0, r8, lsl r0
     728:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
     72c:	0b3b0b3a 	bleq	ec341c <_bss_end+0xeb893c>
     730:	13490b39 	movtne	r0, #39737	; 0x9b39
     734:	1802196c 	stmdane	r2, {r2, r3, r5, r6, r8, fp, ip}
     738:	34210000 	strtcc	r0, [r1], #-0
     73c:	3a0e0300 	bcc	381344 <_bss_end+0x376864>
     740:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     744:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
     748:	22000018 	andcs	r0, r0, #24
     74c:	13490101 	movtne	r0, #37121	; 0x9101
     750:	00001301 	andeq	r1, r0, r1, lsl #6
     754:	49002123 	stmdbmi	r0, {r0, r1, r5, r8, sp}
     758:	000b2f13 	andeq	r2, fp, r3, lsl pc
     75c:	012e2400 			; <UNDEFINED> instruction: 0x012e2400
     760:	0b3a1347 	bleq	e85484 <_bss_end+0xe7a9a4>
     764:	0b390b3b 	bleq	e43458 <_bss_end+0xe38978>
     768:	01111364 	tsteq	r1, r4, ror #6
     76c:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
     770:	01194297 			; <UNDEFINED> instruction: 0x01194297
     774:	25000013 	strcs	r0, [r0, #-19]	; 0xffffffed
     778:	0111010b 	tsteq	r1, fp, lsl #2
     77c:	13010612 	movwne	r0, #5650	; 0x1612
     780:	2e260000 	cdpcs	0, 2, cr0, cr6, cr0, {0}
     784:	3a134701 	bcc	4d2390 <_bss_end+0x4c78b0>
     788:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     78c:	2013640b 	andscs	r6, r3, fp, lsl #8
     790:	0013010b 	andseq	r0, r3, fp, lsl #2
     794:	00052700 	andeq	r2, r5, r0, lsl #14
     798:	13490e03 	movtne	r0, #40451	; 0x9e03
     79c:	00001934 	andeq	r1, r0, r4, lsr r9
     7a0:	03000528 	movweq	r0, #1320	; 0x528
     7a4:	3b0b3a0e 	blcc	2cefe4 <_bss_end+0x2c4504>
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
     7d0:	0b130e25 	bleq	4c406c <_bss_end+0x4b958c>
     7d4:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
     7d8:	06120111 			; <UNDEFINED> instruction: 0x06120111
     7dc:	00001710 	andeq	r1, r0, r0, lsl r7
     7e0:	0b002402 	bleq	97f0 <_Z13Guessing_Gamec+0x34>
     7e4:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
     7e8:	0300000e 	movweq	r0, #14
     7ec:	13490026 	movtne	r0, #36902	; 0x9026
     7f0:	24040000 	strcs	r0, [r4], #-0
     7f4:	3e0b0b00 	vmlacc.f64	d0, d11, d0
     7f8:	0008030b 	andeq	r0, r8, fp, lsl #6
     7fc:	00160500 	andseq	r0, r6, r0, lsl #10
     800:	0b3a0e03 	bleq	e84014 <_bss_end+0xe79534>
     804:	0b390b3b 	bleq	e434f8 <_bss_end+0xe38a18>
     808:	00001349 	andeq	r1, r0, r9, asr #6
     80c:	03013906 	movweq	r3, #6406	; 0x1906
     810:	3b0b3a08 	blcc	2cf038 <_bss_end+0x2c4558>
     814:	010b390b 	tsteq	fp, fp, lsl #18
     818:	07000013 	smladeq	r0, r3, r0, r0
     81c:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
     820:	0b3b0b3a 	bleq	ec3510 <_bss_end+0xeb8a30>
     824:	13490b39 	movtne	r0, #39737	; 0x9b39
     828:	061c193c 			; <UNDEFINED> instruction: 0x061c193c
     82c:	0000196c 	andeq	r1, r0, ip, ror #18
     830:	03003408 	movweq	r3, #1032	; 0x408
     834:	3b0b3a0e 	blcc	2cf074 <_bss_end+0x2c4594>
     838:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     83c:	1c193c13 	ldcne	12, cr3, [r9], {19}
     840:	00196c0b 	andseq	r6, r9, fp, lsl #24
     844:	01040900 	tsteq	r4, r0, lsl #18
     848:	196d0e03 	stmdbne	sp!, {r0, r1, r9, sl, fp}^
     84c:	0b0b0b3e 	bleq	2c354c <_bss_end+0x2b8a6c>
     850:	0b3a1349 	bleq	e8557c <_bss_end+0xe7aa9c>
     854:	0b390b3b 	bleq	e43548 <_bss_end+0xe38a68>
     858:	00001301 	andeq	r1, r0, r1, lsl #6
     85c:	0300280a 	movweq	r2, #2058	; 0x80a
     860:	000b1c08 	andeq	r1, fp, r8, lsl #24
     864:	00280b00 	eoreq	r0, r8, r0, lsl #22
     868:	0b1c0e03 	bleq	70407c <_bss_end+0x6f959c>
     86c:	340c0000 	strcc	r0, [ip], #-0
     870:	00134700 	andseq	r4, r3, r0, lsl #14
     874:	01020d00 	tsteq	r2, r0, lsl #26
     878:	0b0b0e03 	bleq	2c408c <_bss_end+0x2b95ac>
     87c:	0b3b0b3a 	bleq	ec356c <_bss_end+0xeb8a8c>
     880:	13010b39 	movwne	r0, #6969	; 0x1b39
     884:	0d0e0000 	stceq	0, cr0, [lr, #-0]
     888:	3a0e0300 	bcc	381490 <_bss_end+0x3769b0>
     88c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     890:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
     894:	0f00000b 	svceq	0x0000000b
     898:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
     89c:	0b3a0e03 	bleq	e840b0 <_bss_end+0xe795d0>
     8a0:	0b390b3b 	bleq	e43594 <_bss_end+0xe38ab4>
     8a4:	13490e6e 	movtne	r0, #40558	; 0x9e6e
     8a8:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
     8ac:	13011364 	movwne	r1, #4964	; 0x1364
     8b0:	05100000 	ldreq	r0, [r0, #-0]
     8b4:	34134900 	ldrcc	r4, [r3], #-2304	; 0xfffff700
     8b8:	11000019 	tstne	r0, r9, lsl r0
     8bc:	13490005 	movtne	r0, #36869	; 0x9005
     8c0:	2e120000 	cdpcs	0, 1, cr0, cr2, cr0, {0}
     8c4:	03193f01 	tsteq	r9, #1, 30
     8c8:	3b0b3a0e 	blcc	2cf108 <_bss_end+0x2c4628>
     8cc:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     8d0:	3c0b320e 	sfmcc	f3, 4, [fp], {14}
     8d4:	01136419 	tsteq	r3, r9, lsl r4
     8d8:	13000013 	movwne	r0, #19
     8dc:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
     8e0:	0b3a0e03 	bleq	e840f4 <_bss_end+0xe79614>
     8e4:	0b390b3b 	bleq	e435d8 <_bss_end+0xe38af8>
     8e8:	13490e6e 	movtne	r0, #40558	; 0x9e6e
     8ec:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
     8f0:	00001364 	andeq	r1, r0, r4, ror #6
     8f4:	0b000f14 	bleq	454c <CPSR_IRQ_INHIBIT+0x44cc>
     8f8:	0013490b 	andseq	r4, r3, fp, lsl #18
     8fc:	00341500 	eorseq	r1, r4, r0, lsl #10
     900:	0b3a0e03 	bleq	e84114 <_bss_end+0xe79634>
     904:	0b390b3b 	bleq	e435f8 <_bss_end+0xe38b18>
     908:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
     90c:	0000193c 	andeq	r1, r0, ip, lsr r9
     910:	03002816 	movweq	r2, #2070	; 0x816
     914:	00051c0e 	andeq	r1, r5, lr, lsl #24
     918:	00281700 	eoreq	r1, r8, r0, lsl #14
     91c:	061c0e03 	ldreq	r0, [ip], -r3, lsl #28
     920:	2e180000 	cdpcs	0, 1, cr0, cr8, cr0, {0}
     924:	03193f01 	tsteq	r9, #1, 30
     928:	3b0b3a0e 	blcc	2cf168 <_bss_end+0x2c4688>
     92c:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     930:	3c0b320e 	sfmcc	f3, 4, [fp], {14}
     934:	00136419 	andseq	r6, r3, r9, lsl r4
     938:	00101900 	andseq	r1, r0, r0, lsl #18
     93c:	13490b0b 	movtne	r0, #39691	; 0x9b0b
     940:	341a0000 	ldrcc	r0, [sl], #-0
     944:	3a134700 	bcc	4d254c <_bss_end+0x4c7a6c>
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
     97c:	0b3b0b3a 	bleq	ec366c <_bss_end+0xeb8b8c>
     980:	13490b39 	movtne	r0, #39737	; 0x9b39
     984:	00001802 	andeq	r1, r0, r2, lsl #16
     988:	47012e1e 	smladmi	r1, lr, lr, r2
     98c:	3b0b3a13 	blcc	2cf1e0 <_bss_end+0x2c4700>
     990:	640b390b 	strvs	r3, [fp], #-2315	; 0xfffff6f5
     994:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
     998:	96184006 	ldrls	r4, [r8], -r6
     99c:	13011942 	movwne	r1, #6466	; 0x1942
     9a0:	051f0000 	ldreq	r0, [pc, #-0]	; 9a8 <CPSR_IRQ_INHIBIT+0x928>
     9a4:	490e0300 	stmdbmi	lr, {r8, r9}
     9a8:	02193413 	andseq	r3, r9, #318767104	; 0x13000000
     9ac:	20000018 	andcs	r0, r0, r8, lsl r0
     9b0:	08030005 	stmdaeq	r3, {r0, r2}
     9b4:	0b3b0b3a 	bleq	ec36a4 <_bss_end+0xeb8bc4>
     9b8:	13490b39 	movtne	r0, #39737	; 0x9b39
     9bc:	00001802 	andeq	r1, r0, r2, lsl #16
     9c0:	03003421 	movweq	r3, #1057	; 0x421
     9c4:	3b0b3a08 	blcc	2cf1ec <_bss_end+0x2c470c>
     9c8:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     9cc:	00180213 	andseq	r0, r8, r3, lsl r2
     9d0:	01012200 	mrseq	r2, R9_usr
     9d4:	13011349 	movwne	r1, #4937	; 0x1349
     9d8:	21230000 			; <UNDEFINED> instruction: 0x21230000
     9dc:	2f134900 	svccs	0x00134900
     9e0:	2400000b 	strcs	r0, [r0], #-11
     9e4:	1347012e 	movtne	r0, #28974	; 0x712e
     9e8:	0b390b3a 	bleq	e436d8 <_bss_end+0xe38bf8>
     9ec:	01111364 	tsteq	r1, r4, ror #6
     9f0:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
     9f4:	01194296 			; <UNDEFINED> instruction: 0x01194296
     9f8:	25000013 	strcs	r0, [r0, #-19]	; 0xffffffed
     9fc:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
     a00:	0b3b0b3a 	bleq	ec36f0 <_bss_end+0xeb8c10>
     a04:	13490b39 	movtne	r0, #39737	; 0x9b39
     a08:	1802196c 	stmdane	r2, {r2, r3, r5, r6, r8, fp, ip}
     a0c:	2e260000 	cdpcs	0, 2, cr0, cr6, cr0, {0}
     a10:	3a134701 	bcc	4d261c <_bss_end+0x4c7b3c>
     a14:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     a18:	2013640b 	andscs	r6, r3, fp, lsl #8
     a1c:	0013010b 	andseq	r0, r3, fp, lsl #2
     a20:	00052700 	andeq	r2, r5, r0, lsl #14
     a24:	13490e03 	movtne	r0, #40451	; 0x9e03
     a28:	00001934 	andeq	r1, r0, r4, lsr r9
     a2c:	03000528 	movweq	r0, #1320	; 0x528
     a30:	3b0b3a08 	blcc	2cf258 <_bss_end+0x2c4778>
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
     a5c:	0b130e25 	bleq	4c42f8 <_bss_end+0x4b9818>
     a60:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
     a64:	06120111 			; <UNDEFINED> instruction: 0x06120111
     a68:	00001710 	andeq	r1, r0, r0, lsl r7
     a6c:	0b002402 	bleq	9a7c <_Z13Guessing_Gamec+0x2c0>
     a70:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
     a74:	0300000e 	movweq	r0, #14
     a78:	13490026 	movtne	r0, #36902	; 0x9026
     a7c:	24040000 	strcs	r0, [r4], #-0
     a80:	3e0b0b00 	vmlacc.f64	d0, d11, d0
     a84:	0008030b 	andeq	r0, r8, fp, lsl #6
     a88:	00350500 	eorseq	r0, r5, r0, lsl #10
     a8c:	00001349 	andeq	r1, r0, r9, asr #6
     a90:	03001606 	movweq	r1, #1542	; 0x606
     a94:	3b0b3a0e 	blcc	2cf2d4 <_bss_end+0x2c47f4>
     a98:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     a9c:	07000013 	smladeq	r0, r3, r0, r0
     aa0:	08030139 	stmdaeq	r3, {r0, r3, r4, r5, r8}
     aa4:	0b3b0b3a 	bleq	ec3794 <_bss_end+0xeb8cb4>
     aa8:	13010b39 	movwne	r0, #6969	; 0x1b39
     aac:	34080000 	strcc	r0, [r8], #-0
     ab0:	3a0e0300 	bcc	3816b8 <_bss_end+0x376bd8>
     ab4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     ab8:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
     abc:	6c061c19 	stcvs	12, cr1, [r6], {25}
     ac0:	09000019 	stmdbeq	r0, {r0, r3, r4}
     ac4:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
     ac8:	0b3b0b3a 	bleq	ec37b8 <_bss_end+0xeb8cd8>
     acc:	13490b39 	movtne	r0, #39737	; 0x9b39
     ad0:	0b1c193c 	bleq	706fc8 <_bss_end+0x6fc4e8>
     ad4:	0000196c 	andeq	r1, r0, ip, ror #18
     ad8:	0301040a 	movweq	r0, #5130	; 0x140a
     adc:	3e196d0e 	cdpcc	13, 1, cr6, cr9, cr14, {0}
     ae0:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
     ae4:	3b0b3a13 	blcc	2cf338 <_bss_end+0x2c4858>
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
     b14:	0b0b0e03 	bleq	2c4328 <_bss_end+0x2b9848>
     b18:	0b3b0b3a 	bleq	ec3808 <_bss_end+0xeb8d28>
     b1c:	13010b39 	movwne	r0, #6969	; 0x1b39
     b20:	0d100000 	ldceq	0, cr0, [r0, #-0]
     b24:	3a0e0300 	bcc	38172c <_bss_end+0x376c4c>
     b28:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     b2c:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
     b30:	1100000b 	tstne	r0, fp
     b34:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
     b38:	0b3a0e03 	bleq	e8434c <_bss_end+0xe7986c>
     b3c:	0b390b3b 	bleq	e43830 <_bss_end+0xe38d50>
     b40:	13490e6e 	movtne	r0, #40558	; 0x9e6e
     b44:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
     b48:	13011364 	movwne	r1, #4964	; 0x1364
     b4c:	05120000 	ldreq	r0, [r2, #-0]
     b50:	34134900 	ldrcc	r4, [r3], #-2304	; 0xfffff700
     b54:	13000019 	movwne	r0, #25
     b58:	13490005 	movtne	r0, #36869	; 0x9005
     b5c:	2e140000 	cdpcs	0, 1, cr0, cr4, cr0, {0}
     b60:	03193f01 	tsteq	r9, #1, 30
     b64:	3b0b3a0e 	blcc	2cf3a4 <_bss_end+0x2c48c4>
     b68:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     b6c:	3c0b320e 	sfmcc	f3, 4, [fp], {14}
     b70:	01136419 	tsteq	r3, r9, lsl r4
     b74:	15000013 	strne	r0, [r0, #-19]	; 0xffffffed
     b78:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
     b7c:	0b3a0e03 	bleq	e84390 <_bss_end+0xe798b0>
     b80:	0b390b3b 	bleq	e43874 <_bss_end+0xe38d94>
     b84:	13490e6e 	movtne	r0, #40558	; 0x9e6e
     b88:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
     b8c:	00001364 	andeq	r1, r0, r4, ror #6
     b90:	03002816 	movweq	r2, #2070	; 0x816
     b94:	00051c0e 	andeq	r1, r5, lr, lsl #24
     b98:	00281700 	eoreq	r1, r8, r0, lsl #14
     b9c:	061c0e03 	ldreq	r0, [ip], -r3, lsl #28
     ba0:	2e180000 	cdpcs	0, 1, cr0, cr8, cr0, {0}
     ba4:	03193f01 	tsteq	r9, #1, 30
     ba8:	3b0b3a0e 	blcc	2cf3e8 <_bss_end+0x2c4908>
     bac:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     bb0:	3c0b320e 	sfmcc	f3, 4, [fp], {14}
     bb4:	00136419 	andseq	r6, r3, r9, lsl r4
     bb8:	00101900 	andseq	r1, r0, r0, lsl #18
     bbc:	13490b0b 	movtne	r0, #39691	; 0x9b0b
     bc0:	341a0000 	ldrcc	r0, [sl], #-0
     bc4:	3a0e0300 	bcc	3817cc <_bss_end+0x376cec>
     bc8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     bcc:	3f13490b 	svccc	0x0013490b
     bd0:	00193c19 	andseq	r3, r9, r9, lsl ip
     bd4:	00341b00 	eorseq	r1, r4, r0, lsl #22
     bd8:	0b3a0e03 	bleq	e843ec <_bss_end+0xe7990c>
     bdc:	0b390b3b 	bleq	e438d0 <_bss_end+0xe38df0>
     be0:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
     be4:	00001802 	andeq	r1, r0, r2, lsl #16
     be8:	4700341c 	smladmi	r0, ip, r4, r3
     bec:	3b0b3a13 	blcc	2cf440 <_bss_end+0x2c4960>
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
     c20:	0b3a0e03 	bleq	e84434 <_bss_end+0xe79954>
     c24:	0b390b3b 	bleq	e43918 <_bss_end+0xe38e38>
     c28:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
     c2c:	2e200000 	cdpcs	0, 2, cr0, cr0, cr0, {0}
     c30:	3a134701 	bcc	4d283c <_bss_end+0x4c7d5c>
     c34:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     c38:	1113640b 	tstne	r3, fp, lsl #8
     c3c:	40061201 	andmi	r1, r6, r1, lsl #4
     c40:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
     c44:	00001301 	andeq	r1, r0, r1, lsl #6
     c48:	03000521 	movweq	r0, #1313	; 0x521
     c4c:	3413490e 	ldrcc	r4, [r3], #-2318	; 0xfffff6f2
     c50:	00180219 	andseq	r0, r8, r9, lsl r2
     c54:	00342200 	eorseq	r2, r4, r0, lsl #4
     c58:	0b3a0e03 	bleq	e8446c <_bss_end+0xe7998c>
     c5c:	0b390b3b 	bleq	e43950 <_bss_end+0xe38e70>
     c60:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
     c64:	2e230000 	cdpcs	0, 2, cr0, cr3, cr0, {0}
     c68:	3a134701 	bcc	4d2874 <_bss_end+0x4c7d94>
     c6c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     c70:	1113640b 	tstne	r3, fp, lsl #8
     c74:	40061201 	andmi	r1, r6, r1, lsl #4
     c78:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
     c7c:	00001301 	andeq	r1, r0, r1, lsl #6
     c80:	03000524 	movweq	r0, #1316	; 0x524
     c84:	3b0b3a08 	blcc	2cf4ac <_bss_end+0x2c49cc>
     c88:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     c8c:	00180213 	andseq	r0, r8, r3, lsl r2
     c90:	012e2500 			; <UNDEFINED> instruction: 0x012e2500
     c94:	0b3a1347 	bleq	e859b8 <_bss_end+0xe7aed8>
     c98:	0b390b3b 	bleq	e4398c <_bss_end+0xe38eac>
     c9c:	0b201364 	bleq	805a34 <_bss_end+0x7faf54>
     ca0:	00001301 	andeq	r1, r0, r1, lsl #6
     ca4:	03000526 	movweq	r0, #1318	; 0x526
     ca8:	3413490e 	ldrcc	r4, [r3], #-2318	; 0xfffff6f2
     cac:	27000019 	smladcs	r0, r9, r0, r0
     cb0:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
     cb4:	0b3b0b3a 	bleq	ec39a4 <_bss_end+0xeb8ec4>
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
     ce4:	0b3b0b3a 	bleq	ec39d4 <_bss_end+0xeb8ef4>
     ce8:	01110b39 	tsteq	r1, r9, lsr fp
     cec:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
     cf0:	00194297 	mulseq	r9, r7, r2
     cf4:	012e2b00 			; <UNDEFINED> instruction: 0x012e2b00
     cf8:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     cfc:	0b3b0b3a 	bleq	ec39ec <_bss_end+0xeb8f0c>
     d00:	01110b39 	tsteq	r1, r9, lsr fp
     d04:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
     d08:	01194296 			; <UNDEFINED> instruction: 0x01194296
     d0c:	2c000013 	stccs	0, cr0, [r0], {19}
     d10:	08030034 	stmdaeq	r3, {r2, r4, r5}
     d14:	0b3b0b3a 	bleq	ec3a04 <_bss_end+0xeb8f24>
     d18:	13490b39 	movtne	r0, #39737	; 0x9b39
     d1c:	00001802 	andeq	r1, r0, r2, lsl #16
     d20:	3f012e2d 	svccc	0x00012e2d
     d24:	3a0e0319 	bcc	381990 <_bss_end+0x376eb0>
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
     d60:	0b002404 	bleq	9d78 <_Z41__static_initialization_and_destruction_0ii+0x4c>
     d64:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
     d68:	05000008 	streq	r0, [r0, #-8]
     d6c:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
     d70:	0b3b0b3a 	bleq	ec3a60 <_bss_end+0xeb8f80>
     d74:	13490b39 	movtne	r0, #39737	; 0x9b39
     d78:	35060000 	strcc	r0, [r6, #-0]
     d7c:	00134900 	andseq	r4, r3, r0, lsl #18
     d80:	000f0700 	andeq	r0, pc, r0, lsl #14
     d84:	13490b0b 	movtne	r0, #39691	; 0x9b0b
     d88:	39080000 	stmdbcc	r8, {}	; <UNPREDICTABLE>
     d8c:	3a080301 	bcc	201998 <_bss_end+0x1f6eb8>
     d90:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     d94:	0013010b 	andseq	r0, r3, fp, lsl #2
     d98:	00340900 	eorseq	r0, r4, r0, lsl #18
     d9c:	0b3a0e03 	bleq	e845b0 <_bss_end+0xe79ad0>
     da0:	0b390b3b 	bleq	e43a94 <_bss_end+0xe38fb4>
     da4:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
     da8:	196c061c 	stmdbne	ip!, {r2, r3, r4, r9, sl}^
     dac:	340a0000 	strcc	r0, [sl], #-0
     db0:	3a0e0300 	bcc	3819b8 <_bss_end+0x376ed8>
     db4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     db8:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
     dbc:	6c0b1c19 	stcvs	12, cr1, [fp], {25}
     dc0:	0b000019 	bleq	e2c <CPSR_IRQ_INHIBIT+0xdac>
     dc4:	0e030104 	adfeqs	f0, f3, f4
     dc8:	0b3e196d 	bleq	f87384 <_bss_end+0xf7c8a4>
     dcc:	13490b0b 	movtne	r0, #39691	; 0x9b0b
     dd0:	0b3b0b3a 	bleq	ec3ac0 <_bss_end+0xeb8fe0>
     dd4:	13010b39 	movwne	r0, #6969	; 0x1b39
     dd8:	280c0000 	stmdacs	ip, {}	; <UNPREDICTABLE>
     ddc:	1c080300 	stcne	3, cr0, [r8], {-0}
     de0:	0d00000b 	stceq	0, cr0, [r0, #-44]	; 0xffffffd4
     de4:	0e030028 	cdpeq	0, 0, cr0, cr3, cr8, {1}
     de8:	00000b1c 	andeq	r0, r0, ip, lsl fp
     dec:	4700340e 	strmi	r3, [r0, -lr, lsl #8]
     df0:	0f000013 	svceq	0x00000013
     df4:	0e030102 	adfeqs	f0, f3, f2
     df8:	0b3a0b0b 	bleq	e83a2c <_bss_end+0xe78f4c>
     dfc:	0b390b3b 	bleq	e43af0 <_bss_end+0xe39010>
     e00:	00001301 	andeq	r1, r0, r1, lsl #6
     e04:	03000d10 	movweq	r0, #3344	; 0xd10
     e08:	3b0b3a0e 	blcc	2cf648 <_bss_end+0x2c4b68>
     e0c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     e10:	000b3813 	andeq	r3, fp, r3, lsl r8
     e14:	012e1100 			; <UNDEFINED> instruction: 0x012e1100
     e18:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     e1c:	0b3b0b3a 	bleq	ec3b0c <_bss_end+0xeb902c>
     e20:	0e6e0b39 	vmoveq.8	d14[5], r0
     e24:	0b321349 	bleq	c85b50 <_bss_end+0xc7b070>
     e28:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
     e2c:	00001301 	andeq	r1, r0, r1, lsl #6
     e30:	49000512 	stmdbmi	r0, {r1, r4, r8, sl}
     e34:	00193413 	andseq	r3, r9, r3, lsl r4
     e38:	00051300 	andeq	r1, r5, r0, lsl #6
     e3c:	00001349 	andeq	r1, r0, r9, asr #6
     e40:	3f012e14 	svccc	0x00012e14
     e44:	3a0e0319 	bcc	381ab0 <_bss_end+0x376fd0>
     e48:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     e4c:	320e6e0b 	andcc	r6, lr, #11, 28	; 0xb0
     e50:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
     e54:	00130113 	andseq	r0, r3, r3, lsl r1
     e58:	012e1500 			; <UNDEFINED> instruction: 0x012e1500
     e5c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     e60:	0b3b0b3a 	bleq	ec3b50 <_bss_end+0xeb9070>
     e64:	0e6e0b39 	vmoveq.8	d14[5], r0
     e68:	0b321349 	bleq	c85b94 <_bss_end+0xc7b0b4>
     e6c:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
     e70:	28160000 	ldmdacs	r6, {}	; <UNPREDICTABLE>
     e74:	1c0e0300 	stcne	3, cr0, [lr], {-0}
     e78:	17000005 	strne	r0, [r0, -r5]
     e7c:	0e030028 	cdpeq	0, 0, cr0, cr3, cr8, {1}
     e80:	0000061c 	andeq	r0, r0, ip, lsl r6
     e84:	3f012e18 	svccc	0x00012e18
     e88:	3a0e0319 	bcc	381af4 <_bss_end+0x377014>
     e8c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     e90:	320e6e0b 	andcc	r6, lr, #11, 28	; 0xb0
     e94:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
     e98:	19000013 	stmdbne	r0, {r0, r1, r4}
     e9c:	0b0b0010 	bleq	2c0ee4 <_bss_end+0x2b6404>
     ea0:	00001349 	andeq	r1, r0, r9, asr #6
     ea4:	0300341a 	movweq	r3, #1050	; 0x41a
     ea8:	3b0b3a0e 	blcc	2cf6e8 <_bss_end+0x2c4c08>
     eac:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     eb0:	3c193f13 	ldccc	15, cr3, [r9], {19}
     eb4:	1b000019 	blne	f20 <CPSR_IRQ_INHIBIT+0xea0>
     eb8:	193f002e 	ldmdbne	pc!, {r1, r2, r3, r5}	; <UNPREDICTABLE>
     ebc:	0b3a0e03 	bleq	e846d0 <_bss_end+0xe79bf0>
     ec0:	0b390b3b 	bleq	e43bb4 <_bss_end+0xe390d4>
     ec4:	01111349 	tsteq	r1, r9, asr #6
     ec8:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
     ecc:	00194296 	mulseq	r9, r6, r2
     ed0:	11010000 	mrsne	r0, (UNDEF: 1)
     ed4:	55061000 	strpl	r1, [r6, #-0]
     ed8:	1b0e0306 	blne	381af8 <_bss_end+0x377018>
     edc:	130e250e 	movwne	r2, #58638	; 0xe50e
     ee0:	00000005 	andeq	r0, r0, r5
     ee4:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
     ee8:	030b130e 	movweq	r1, #45838	; 0xb30e
     eec:	110e1b0e 	tstne	lr, lr, lsl #22
     ef0:	10061201 	andne	r1, r6, r1, lsl #4
     ef4:	02000017 	andeq	r0, r0, #23
     ef8:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
     efc:	0b3b0b3a 	bleq	ec3bec <_bss_end+0xeb910c>
     f00:	13490b39 	movtne	r0, #39737	; 0x9b39
     f04:	0f030000 	svceq	0x00030000
     f08:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
     f0c:	04000013 	streq	r0, [r0], #-19	; 0xffffffed
     f10:	00000015 	andeq	r0, r0, r5, lsl r0
     f14:	03003405 	movweq	r3, #1029	; 0x405
     f18:	3b0b3a0e 	blcc	2cf758 <_bss_end+0x2c4c78>
     f1c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     f20:	3c193f13 	ldccc	15, cr3, [r9], {19}
     f24:	06000019 			; <UNDEFINED> instruction: 0x06000019
     f28:	0b0b0024 	bleq	2c0fc0 <_bss_end+0x2b64e0>
     f2c:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
     f30:	01070000 	mrseq	r0, (UNDEF: 7)
     f34:	01134901 	tsteq	r3, r1, lsl #18
     f38:	08000013 	stmdaeq	r0, {r0, r1, r4}
     f3c:	13490021 	movtne	r0, #36897	; 0x9021
     f40:	0000062f 	andeq	r0, r0, pc, lsr #12
     f44:	0b002409 	bleq	9f70 <_Z4itoajPcj+0x24>
     f48:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
     f4c:	0a00000e 	beq	f8c <CPSR_IRQ_INHIBIT+0xf0c>
     f50:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
     f54:	0b3a0e03 	bleq	e84768 <_bss_end+0xe79c88>
     f58:	0b390b3b 	bleq	e43c4c <_bss_end+0xe3916c>
     f5c:	01111349 	tsteq	r1, r9, asr #6
     f60:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
     f64:	01194296 			; <UNDEFINED> instruction: 0x01194296
     f68:	0b000013 	bleq	fbc <CPSR_IRQ_INHIBIT+0xf3c>
     f6c:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
     f70:	0b3b0b3a 	bleq	ec3c60 <_bss_end+0xeb9180>
     f74:	13490b39 	movtne	r0, #39737	; 0x9b39
     f78:	00001802 	andeq	r1, r0, r2, lsl #16
     f7c:	3f012e0c 	svccc	0x00012e0c
     f80:	3a0e0319 	bcc	381bec <_bss_end+0x37710c>
     f84:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     f88:	1113490b 	tstne	r3, fp, lsl #18
     f8c:	40061201 	andmi	r1, r6, r1, lsl #4
     f90:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
     f94:	00001301 	andeq	r1, r0, r1, lsl #6
     f98:	0300340d 	movweq	r3, #1037	; 0x40d
     f9c:	3b0b3a08 	blcc	2cf7c4 <_bss_end+0x2c4ce4>
     fa0:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     fa4:	00180213 	andseq	r0, r8, r3, lsl r2
     fa8:	11010000 	mrsne	r0, (UNDEF: 1)
     fac:	130e2501 	movwne	r2, #58625	; 0xe501
     fb0:	1b0e030b 	blne	381be4 <_bss_end+0x377104>
     fb4:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
     fb8:	00171006 	andseq	r1, r7, r6
     fbc:	01390200 	teqeq	r9, r0, lsl #4
     fc0:	00001301 	andeq	r1, r0, r1, lsl #6
     fc4:	03003403 	movweq	r3, #1027	; 0x403
     fc8:	3b0b3a0e 	blcc	2cf808 <_bss_end+0x2c4d28>
     fcc:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     fd0:	1c193c13 	ldcne	12, cr3, [r9], {19}
     fd4:	0400000a 	streq	r0, [r0], #-10
     fd8:	0b3a003a 	bleq	e810c8 <_bss_end+0xe765e8>
     fdc:	0b390b3b 	bleq	e43cd0 <_bss_end+0xe391f0>
     fe0:	00001318 	andeq	r1, r0, r8, lsl r3
     fe4:	49010105 	stmdbmi	r1, {r0, r2, r8}
     fe8:	00130113 	andseq	r0, r3, r3, lsl r1
     fec:	00210600 	eoreq	r0, r1, r0, lsl #12
     ff0:	0b2f1349 	bleq	bc5d1c <_bss_end+0xbbb23c>
     ff4:	26070000 	strcs	r0, [r7], -r0
     ff8:	00134900 	andseq	r4, r3, r0, lsl #18
     ffc:	00240800 	eoreq	r0, r4, r0, lsl #16
    1000:	0b3e0b0b 	bleq	f83c34 <_bss_end+0xf79154>
    1004:	00000e03 	andeq	r0, r0, r3, lsl #28
    1008:	47003409 	strmi	r3, [r0, -r9, lsl #8]
    100c:	0a000013 	beq	1060 <CPSR_IRQ_INHIBIT+0xfe0>
    1010:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
    1014:	0b3a0e03 	bleq	e84828 <_bss_end+0xe79d48>
    1018:	0b390b3b 	bleq	e43d0c <_bss_end+0xe3922c>
    101c:	01110e6e 	tsteq	r1, lr, ror #28
    1020:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
    1024:	01194297 			; <UNDEFINED> instruction: 0x01194297
    1028:	0b000013 	bleq	107c <CPSR_IRQ_INHIBIT+0xffc>
    102c:	08030005 	stmdaeq	r3, {r0, r2}
    1030:	0b3b0b3a 	bleq	ec3d20 <_bss_end+0xeb9240>
    1034:	13490b39 	movtne	r0, #39737	; 0x9b39
    1038:	00001802 	andeq	r1, r0, r2, lsl #16
    103c:	0300340c 	movweq	r3, #1036	; 0x40c
    1040:	3b0b3a0e 	blcc	2cf880 <_bss_end+0x2c4da0>
    1044:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
    1048:	00180213 	andseq	r0, r8, r3, lsl r2
    104c:	010b0d00 	tsteq	fp, r0, lsl #26
    1050:	06120111 			; <UNDEFINED> instruction: 0x06120111
    1054:	340e0000 	strcc	r0, [lr], #-0
    1058:	3a080300 	bcc	201c60 <_bss_end+0x1f7180>
    105c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    1060:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
    1064:	0f000018 	svceq	0x00000018
    1068:	0b0b000f 	bleq	2c10ac <_bss_end+0x2b65cc>
    106c:	00001349 	andeq	r1, r0, r9, asr #6
    1070:	00002610 	andeq	r2, r0, r0, lsl r6
    1074:	000f1100 	andeq	r1, pc, r0, lsl #2
    1078:	00000b0b 	andeq	r0, r0, fp, lsl #22
    107c:	0b002412 	bleq	a0cc <_Z4atoiPKc+0xc>
    1080:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
    1084:	13000008 	movwne	r0, #8
    1088:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
    108c:	0b3b0b3a 	bleq	ec3d7c <_bss_end+0xeb929c>
    1090:	13490b39 	movtne	r0, #39737	; 0x9b39
    1094:	00001802 	andeq	r1, r0, r2, lsl #16
    1098:	3f012e14 	svccc	0x00012e14
    109c:	3a0e0319 	bcc	381d08 <_bss_end+0x377228>
    10a0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    10a4:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
    10a8:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
    10ac:	97184006 	ldrls	r4, [r8, -r6]
    10b0:	13011942 	movwne	r1, #6466	; 0x1942
    10b4:	2e150000 	cdpcs	0, 1, cr0, cr5, cr0, {0}
    10b8:	03193f01 	tsteq	r9, #1, 30
    10bc:	3b0b3a0e 	blcc	2cf8fc <_bss_end+0x2c4e1c>
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
    10fc:	0b130e25 	bleq	4c4998 <_bss_end+0x4b9eb8>
    1100:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
    1104:	00001710 	andeq	r1, r0, r0, lsl r7
    1108:	0b002402 	bleq	a118 <_Z4atoiPKc+0x58>
    110c:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
    1110:	03000008 	movweq	r0, #8
    1114:	0b0b0024 	bleq	2c11ac <_bss_end+0x2b66cc>
    1118:	0e030b3e 	vmoveq.16	d3[0], r0
    111c:	04040000 	streq	r0, [r4], #-0
    1120:	3e0e0301 	cdpcc	3, 0, cr0, cr14, cr1, {0}
    1124:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
    1128:	3b0b3a13 	blcc	2cf97c <_bss_end+0x2c4e9c>
    112c:	010b390b 	tsteq	fp, fp, lsl #18
    1130:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
    1134:	0e030028 	cdpeq	0, 0, cr0, cr3, cr8, {1}
    1138:	00000b1c 	andeq	r0, r0, ip, lsl fp
    113c:	03011306 	movweq	r1, #4870	; 0x1306
    1140:	3a0b0b0e 	bcc	2c3d80 <_bss_end+0x2b92a0>
    1144:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
    1148:	0013010b 	andseq	r0, r3, fp, lsl #2
    114c:	000d0700 	andeq	r0, sp, r0, lsl #14
    1150:	0b3a0e03 	bleq	e84964 <_bss_end+0xe79e84>
    1154:	0b39053b 	bleq	e42648 <_bss_end+0xe37b68>
    1158:	0b381349 	bleq	e05e84 <_bss_end+0xdfb3a4>
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
    1190:	0b0b000f 	bleq	2c11d4 <_bss_end+0x2b66f4>
    1194:	00001349 	andeq	r1, r0, r9, asr #6
    1198:	0301040e 	movweq	r0, #5134	; 0x140e
    119c:	0b0b3e0e 	bleq	2d09dc <_bss_end+0x2c5efc>
    11a0:	3a13490b 	bcc	4d35d4 <_bss_end+0x4c8af4>
    11a4:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
    11a8:	0013010b 	andseq	r0, r3, fp, lsl #2
    11ac:	00160f00 	andseq	r0, r6, r0, lsl #30
    11b0:	0b3a0e03 	bleq	e849c4 <_bss_end+0xe79ee4>
    11b4:	0b390b3b 	bleq	e43ea8 <_bss_end+0xe393c8>
    11b8:	00001349 	andeq	r1, r0, r9, asr #6
    11bc:	00002110 	andeq	r2, r0, r0, lsl r1
    11c0:	00341100 	eorseq	r1, r4, r0, lsl #2
    11c4:	0b3a0e03 	bleq	e849d8 <_bss_end+0xe79ef8>
    11c8:	0b390b3b 	bleq	e43ebc <_bss_end+0xe393dc>
    11cc:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
    11d0:	0000193c 	andeq	r1, r0, ip, lsr r9
    11d4:	47003412 	smladmi	r0, r2, r4, r3
    11d8:	3b0b3a13 	blcc	2cfa2c <_bss_end+0x2c4f4c>
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
  ac:	00000518 	andeq	r0, r0, r8, lsl r5
	...
  b8:	0000001c 	andeq	r0, r0, ip, lsl r0
  bc:	1df20002 	ldclne	0, cr0, [r2, #8]!
  c0:	00040000 	andeq	r0, r4, r0
  c4:	00000000 	andeq	r0, r0, r0
  c8:	000097bc 			; <UNDEFINED> instruction: 0x000097bc
  cc:	000005e0 	andeq	r0, r0, r0, ror #11
	...
  d8:	0000001c 	andeq	r0, r0, ip, lsl r0
  dc:	275a0002 	ldrbcs	r0, [sl, -r2]
  e0:	00040000 	andeq	r0, r4, r0
  e4:	00000000 	andeq	r0, r0, r0
  e8:	00009d9c 	muleq	r0, ip, sp
  ec:	00000078 	andeq	r0, r0, r8, ror r0
	...
  f8:	00000024 	andeq	r0, r0, r4, lsr #32
  fc:	2e3d0002 	cdpcs	0, 3, cr0, cr13, cr2, {0}
 100:	00040000 	andeq	r0, r4, r0
 104:	00000000 	andeq	r0, r0, r0
 108:	00008000 	andeq	r8, r0, r0
 10c:	00000094 	muleq	r0, r4, r0
 110:	00009e14 	andeq	r9, r0, r4, lsl lr
 114:	00000020 	andeq	r0, r0, r0, lsr #32
	...
 120:	0000001c 	andeq	r0, r0, ip, lsl r0
 124:	2e5f0002 	cdpcs	0, 5, cr0, cr15, cr2, {0}
 128:	00040000 	andeq	r0, r4, r0
 12c:	00000000 	andeq	r0, r0, r0
 130:	00009e34 	andeq	r9, r0, r4, lsr lr
 134:	00000118 	andeq	r0, r0, r8, lsl r1
	...
 140:	0000001c 	andeq	r0, r0, ip, lsl r0
 144:	2fae0002 	svccs	0x00ae0002
 148:	00040000 	andeq	r0, r4, r0
 14c:	00000000 	andeq	r0, r0, r0
 150:	00009f4c 	andeq	r9, r0, ip, asr #30
 154:	000004b8 			; <UNDEFINED> instruction: 0x000004b8
	...
 160:	0000001c 	andeq	r0, r0, ip, lsl r0
 164:	32e00002 	rsccc	r0, r0, #2
 168:	00040000 	andeq	r0, r4, r0
 16c:	00000000 	andeq	r0, r0, r0
 170:	0000a404 	andeq	sl, r0, r4, lsl #8
 174:	0000020c 	andeq	r0, r0, ip, lsl #4
	...
 180:	0000001c 	andeq	r0, r0, ip, lsl r0
 184:	33060002 	movwcc	r0, #24578	; 0x6002
 188:	00040000 	andeq	r0, r4, r0
 18c:	00000000 	andeq	r0, r0, r0
 190:	0000a610 	andeq	sl, r0, r0, lsl r6
 194:	00000004 	andeq	r0, r0, r4
	...
 1a0:	00000014 	andeq	r0, r0, r4, lsl r0
 1a4:	332c0002 			; <UNDEFINED> instruction: 0x332c0002
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
      34:	5a2f7374 	bpl	bdce0c <_bss_end+0xbd232c>
      38:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; fffffeac <_bss_end+0xffff53cc>
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
      b8:	fb010200 	blx	408c2 <_bss_end+0x35de2>
      bc:	01000d0e 	tsteq	r0, lr, lsl #26
      c0:	00010101 	andeq	r0, r1, r1, lsl #2
      c4:	00010000 	andeq	r0, r1, r0
      c8:	6d2f0100 	stfvss	f0, [pc, #-0]	; d0 <CPSR_IRQ_INHIBIT+0x50>
      cc:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
      d0:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
      d4:	4b2f7372 	blmi	bdcea4 <_bss_end+0xbd23c4>
      d8:	2f616275 	svccs	0x00616275
      dc:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
      e0:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
      e4:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
      e8:	614d6f72 	hvcvs	55026	; 0xd6f2
      ec:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffb80 <_bss_end+0xffff50a0>
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
     11c:	552f632f 	strpl	r6, [pc, #-815]!	; fffffdf5 <_bss_end+0xffff5315>
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
     150:	6b2f656d 	blvs	bd970c <_bss_end+0xbcec2c>
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
     234:	4a0e05bb 	bmi	381928 <_bss_end+0x376e48>
     238:	052e3005 	streq	r3, [lr, #-5]!
     23c:	01054a32 	tsteq	r5, r2, lsr sl
     240:	0c05854b 	cfstr32eq	mvfx8, [r5], {75}	; 0x4b
     244:	4a15059f 	bmi	5418c8 <_bss_end+0x536de8>
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
     29c:	5a2f7374 	bpl	bdd074 <_bss_end+0xbd2594>
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
     334:	4b2f7372 	blmi	bdd104 <_bss_end+0xbd2624>
     338:	2f616275 	svccs	0x00616275
     33c:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
     340:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
     344:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
     348:	614d6f72 	hvcvs	55026	; 0xd6f2
     34c:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffde0 <_bss_end+0xffff5300>
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
     3f4:	1a053114 	bne	14c84c <_bss_end+0x141d6c>
     3f8:	0d052008 	stceq	0, cr2, [r5, #-32]	; 0xffffffe0
     3fc:	4c0c0566 	cfstr32mi	mvfx0, [ip], {102}	; 0x66
     400:	a12f0105 			; <UNDEFINED> instruction: 0xa12f0105
     404:	05d70505 	ldrbeq	r0, [r7, #1285]	; 0x505
     408:	0b056710 	bleq	15a050 <_bss_end+0x14f570>
     40c:	0402004c 	streq	r0, [r2], #-76	; 0xffffffb4
     410:	00660601 	rsbeq	r0, r6, r1, lsl #12
     414:	4a020402 	bmi	81424 <_bss_end+0x76944>
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
     458:	4b040402 	blmi	101468 <_bss_end+0xf6988>
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
     494:	4a040402 	bmi	1014a4 <_bss_end+0xf69c4>
     498:	02000c05 	andeq	r0, r0, #1280	; 0x500
     49c:	054c0404 	strbeq	r0, [ip, #-1028]	; 0xfffffbfc
     4a0:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
     4a4:	0905d81d 	stmdbeq	r5, {r0, r2, r3, r4, fp, ip, lr, pc}
     4a8:	4a0505ba 	bmi	141b98 <_bss_end+0x1370b8>
     4ac:	054d1305 	strbeq	r1, [sp, #-773]	; 0xfffffcfb
     4b0:	3e054a1c 			; <UNDEFINED> instruction: 0x3e054a1c
     4b4:	66210582 	strtvs	r0, [r1], -r2, lsl #11
     4b8:	052e1e05 	streq	r1, [lr, #-3589]!	; 0xfffff1fb
     4bc:	6b052e4b 	blvs	14bdf0 <_bss_end+0x141310>
     4c0:	4a05052e 	bmi	141980 <_bss_end+0x136ea0>
     4c4:	054a0e05 	strbeq	r0, [sl, #-3589]	; 0xfffff1fb
     4c8:	10056648 	andne	r6, r5, r8, asr #12
     4cc:	4809052e 	stmdami	r9, {r1, r2, r3, r5, r8, sl}
     4d0:	4d310105 	ldfmis	f0, [r1, #-20]!	; 0xffffffec
     4d4:	05a01d05 	streq	r1, [r0, #3333]!	; 0xd05
     4d8:	0505ba09 	streq	fp, [r5, #-2569]	; 0xfffff5f7
     4dc:	4b20054a 	blmi	801a0c <_bss_end+0x7f6f2c>
     4e0:	054c2905 	strbeq	r2, [ip, #-2309]	; 0xfffff6fb
     4e4:	34054a32 	strcc	r4, [r5], #-2610	; 0xfffff5ce
     4e8:	4a0c0582 	bmi	301af8 <_bss_end+0x2f7018>
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
     56c:	4a020402 	bmi	8157c <_bss_end+0x76a9c>
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
     598:	4b040402 	blmi	1015a8 <_bss_end+0xf6ac8>
     59c:	05301405 	ldreq	r1, [r0, #-1029]!	; 0xfffffbfb
     5a0:	01054d0c 	tsteq	r5, ip, lsl #26
     5a4:	2405852f 	strcs	r8, [r5], #-1327	; 0xfffffad1
     5a8:	080905bc 	stmdaeq	r9, {r2, r3, r4, r5, r7, r8, sl}
     5ac:	4a050520 	bmi	141a34 <_bss_end+0x136f54>
     5b0:	054d1405 	strbeq	r1, [sp, #-1029]	; 0xfffffbfb
     5b4:	0e054a1d 			; <UNDEFINED> instruction: 0x0e054a1d
     5b8:	4b100566 	blmi	401b58 <_bss_end+0x3f7078>
     5bc:	05660c05 	strbeq	r0, [r6, #-3077]!	; 0xfffff3fb
     5c0:	05054a09 	streq	r4, [r5, #-2569]	; 0xfffff5f7
     5c4:	4a0e0567 	bmi	381b68 <_bss_end+0x377088>
     5c8:	05661005 	strbeq	r1, [r6, #-5]!
     5cc:	01056209 	tsteq	r5, r9, lsl #4
     5d0:	0b054d33 	bleq	153aa4 <_bss_end+0x148fc4>
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
     604:	4a060804 	bmi	18261c <_bss_end+0x177b3c>
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
     64c:	4a040402 	bmi	10165c <_bss_end+0xf6b7c>
     650:	02000c05 	andeq	r0, r0, #1280	; 0x500
     654:	054c0404 	strbeq	r0, [ip, #-1028]	; 0xfffffbfc
     658:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
     65c:	0905a01c 	stmdbeq	r5, {r2, r3, r4, sp, pc}
     660:	4a0505ba 	bmi	141d50 <_bss_end+0x137270>
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
     68c:	4aba6601 	bmi	fee99e98 <_bss_end+0xfee8f3b8>
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
     6e8:	6b2f656d 	blvs	bd9ca4 <_bss_end+0xbcf1c4>
     6ec:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
     6f0:	72732f6c 	rsbsvc	r2, r3, #108, 30	; 0x1b0
     6f4:	72642f63 	rsbvc	r2, r4, #396	; 0x18c
     6f8:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
     6fc:	6d2f0073 	stcvs	0, cr0, [pc, #-460]!	; 538 <CPSR_IRQ_INHIBIT+0x4b8>
     700:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
     704:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
     708:	4b2f7372 	blmi	bdd4d8 <_bss_end+0xbd29f8>
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
     798:	1b054a01 	blne	152fa4 <_bss_end+0x1484c4>
     79c:	00260568 	eoreq	r0, r6, r8, ror #10
     7a0:	4a030402 	bmi	c17b0 <_bss_end+0xb6cd0>
     7a4:	02002405 	andeq	r2, r0, #83886080	; 0x5000000
     7a8:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
     7ac:	0402000d 	streq	r0, [r2], #-13
     7b0:	1c056802 	stcne	8, cr6, [r5], {2}
     7b4:	02040200 	andeq	r0, r4, #0, 4
     7b8:	001a054a 	andseq	r0, sl, sl, asr #10
     7bc:	4a020402 	bmi	817cc <_bss_end+0x76cec>
     7c0:	02002505 	andeq	r2, r0, #20971520	; 0x1400000
     7c4:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
     7c8:	04020028 	streq	r0, [r2], #-40	; 0xffffffd8
     7cc:	2a054a02 	bcs	152fdc <_bss_end+0x1484fc>
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
     7f8:	1b054a01 	blne	153004 <_bss_end+0x148524>
     7fc:	00260568 	eoreq	r0, r6, r8, ror #10
     800:	4a030402 	bmi	c1810 <_bss_end+0xb6d30>
     804:	02002405 	andeq	r2, r0, #83886080	; 0x5000000
     808:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
     80c:	04020032 	streq	r0, [r2], #-50	; 0xffffffce
     810:	41056802 	tstmi	r5, r2, lsl #16
     814:	02040200 	andeq	r0, r4, #0, 4
     818:	003f054a 	eorseq	r0, pc, sl, asr #10
     81c:	4a020402 	bmi	8182c <_bss_end+0x76d4c>
     820:	02004a05 	andeq	r4, r0, #20480	; 0x5000
     824:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
     828:	0402004d 	streq	r0, [r2], #-77	; 0xffffffb3
     82c:	0d054a02 	vstreq	s8, [r5, #-8]
     830:	02040200 	andeq	r0, r4, #0, 4
     834:	001b052e 	andseq	r0, fp, lr, lsr #10
     838:	4a020402 	bmi	81848 <_bss_end+0x76d68>
     83c:	02002205 	andeq	r2, r0, #1342177280	; 0x50000000
     840:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
     844:	04020020 	streq	r0, [r2], #-32	; 0xffffffe0
     848:	2b054a02 	blcs	153058 <_bss_end+0x148578>
     84c:	02040200 	andeq	r0, r4, #0, 4
     850:	002e052e 	eoreq	r0, lr, lr, lsr #10
     854:	4a020402 	bmi	81864 <_bss_end+0x76d84>
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
     8a4:	4a020402 	bmi	818b4 <_bss_end+0x76dd4>
     8a8:	02002e05 	andeq	r2, r0, #5, 28	; 0x50
     8ac:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
     8b0:	04020031 	streq	r0, [r2], #-49	; 0xffffffcf
     8b4:	33054a02 	movwcc	r4, #23042	; 0x5a02
     8b8:	02040200 	andeq	r0, r4, #0, 4
     8bc:	0005052e 	andeq	r0, r5, lr, lsr #10
     8c0:	48020402 	stmdami	r2, {r1, sl}
     8c4:	8a860105 	bhi	fe180ce0 <_bss_end+0xfe176200>
     8c8:	05bb0505 	ldreq	r0, [fp, #1285]!	; 0x505
     8cc:	1d056809 	stcne	8, cr6, [r5, #-36]	; 0xffffffdc
     8d0:	4a21054a 	bmi	841e00 <_bss_end+0x837320>
     8d4:	054a1f05 	strbeq	r1, [sl, #-3845]	; 0xfffff0fb
     8d8:	2a052e35 	bcs	14c1b4 <_bss_end+0x1416d4>
     8dc:	2e36054a 	cdpcs	5, 3, cr0, cr6, cr10, {2}
     8e0:	052e3805 	streq	r3, [lr, #-2053]!	; 0xfffff7fb
     8e4:	09054b14 	stmdbeq	r5, {r2, r4, r8, r9, fp, lr}
     8e8:	8614054a 	ldrhi	r0, [r4], -sl, asr #10
     8ec:	4a090567 	bmi	241e90 <_bss_end+0x2373b0>
     8f0:	05691205 	strbeq	r1, [r9, #-517]!	; 0xfffffdfb
     8f4:	01054c0d 	tsteq	r5, sp, lsl #24
     8f8:	1705692f 	strne	r6, [r5, -pc, lsr #18]
     8fc:	0023059f 	mlaeq	r3, pc, r5, r0	; <UNPREDICTABLE>
     900:	4a030402 	bmi	c1910 <_bss_end+0xb6e30>
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
     95c:	4a1005ba 	bmi	40204c <_bss_end+0x3f756c>
     960:	052e1105 	streq	r1, [lr, #-261]!	; 0xfffffefb
     964:	13054a2d 	movwne	r4, #23085	; 0x5a2d
     968:	2f0f052e 	svccs	0x000f052e
     96c:	05a00a05 	streq	r0, [r0, #2565]!	; 0xa05
     970:	05366105 	ldreq	r6, [r6, #-261]!	; 0xfffffefb
     974:	11056810 	tstne	r5, r0, lsl r8
     978:	4a22052e 	bmi	881e38 <_bss_end+0x877358>
     97c:	052e1305 	streq	r1, [lr, #-773]!	; 0xfffffcfb
     980:	0c052f0a 	stceq	15, cr2, [r5], {10}
     984:	2e0d0569 	cfsh32cs	mvfx0, mvfx13, #57
     988:	054a0f05 	strbeq	r0, [sl, #-3845]	; 0xfffff0fb
     98c:	0e054b06 	vmlaeq.f64	d4, d5, d6
     990:	001d0568 	andseq	r0, sp, r8, ror #10
     994:	4a030402 	bmi	c19a4 <_bss_end+0xb6ec4>
     998:	02001705 	andeq	r1, r0, #1310720	; 0x140000
     99c:	059e0304 	ldreq	r0, [lr, #772]	; 0x304
     9a0:	0402001b 	streq	r0, [r2], #-27	; 0xffffffe5
     9a4:	1e056802 	cdpne	8, 0, cr6, cr5, cr2, {0}
     9a8:	02040200 	andeq	r0, r4, #0, 4
     9ac:	000e0582 	andeq	r0, lr, r2, lsl #11
     9b0:	4a020402 	bmi	819c0 <_bss_end+0x76ee0>
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
     a10:	4a9e9e01 	bmi	fe7a821c <_bss_end+0xfe79d73c>
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
     a58:	4b16054c 	blmi	581f90 <_bss_end+0x5774b0>
     a5c:	054a1f05 	strbeq	r1, [sl, #-3845]	; 0xfffff0fb
     a60:	01052e14 	tsteq	r5, r4, lsl lr
     a64:	0006024c 	andeq	r0, r6, ip, asr #4
     a68:	01050101 	tsteq	r5, r1, lsl #2
     a6c:	78020500 	stmdavc	r2, {r8, sl}
     a70:	03000092 	movweq	r0, #146	; 0x92
     a74:	050100c0 	streq	r0, [r1, #-192]	; 0xffffff40
     a78:	01058313 	tsteq	r5, r3, lsl r3
     a7c:	00080267 	andeq	r0, r8, r7, ror #4
     a80:	029d0101 	addseq	r0, sp, #1073741824	; 0x40000000
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
     b04:	5a2f7374 	bpl	bdd8dc <_bss_end+0xbd2dfc>
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
     b7c:	6b2f656d 	blvs	bda138 <_bss_end+0xbcf658>
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
     be0:	0b051900 	bleq	146fe8 <_bss_end+0x13c508>
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
     c0c:	4a29054b 	bmi	a42140 <_bss_end+0xa37660>
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
     c5c:	4a030402 	bmi	c1c6c <_bss_end+0xb718c>
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
     c94:	4a030402 	bmi	c1ca4 <_bss_end+0xb71c4>
     c98:	02001405 	andeq	r1, r0, #83886080	; 0x5000000
     c9c:	05830204 	streq	r0, [r3, #516]	; 0x204
     ca0:	0402000e 	streq	r0, [r2], #-14
     ca4:	05056602 	streq	r6, [r5, #-1538]	; 0xfffff9fe
     ca8:	02040200 	andeq	r0, r4, #0, 4
     cac:	84010581 	strhi	r0, [r1], #-1409	; 0xfffffa7f
     cb0:	a1090569 	tstge	r9, r9, ror #10
     cb4:	05830a05 	streq	r0, [r3, #2565]	; 0xa05
     cb8:	05856701 	streq	r6, [r5, #1793]	; 0x701
     cbc:	01059f0a 	tsteq	r5, sl, lsl #30
     cc0:	09056983 	stmdbeq	r5, {r0, r1, r7, r8, fp, sp, lr}
     cc4:	830a05a1 	movwhi	r0, #42401	; 0xa5a1
     cc8:	85670105 	strbhi	r0, [r7, #-261]!	; 0xfffffefb
     ccc:	059f0e05 	ldreq	r0, [pc, #3589]	; 1ad9 <CPSR_IRQ_INHIBIT+0x1a59>
     cd0:	36054a1f 			; <UNDEFINED> instruction: 0x36054a1f
     cd4:	2e0c0582 	cfsh32cs	mvfx0, mvfx12, #-62
     cd8:	05ba0505 	ldreq	r0, [sl, #1285]!	; 0x505
     cdc:	1b05330a 	blne	14d90c <_bss_end+0x142e2c>
     ce0:	8208054a 	andhi	r0, r8, #310378496	; 0x12800000
     ce4:	69670105 	stmdbvs	r7!, {r0, r2, r8}^
     ce8:	05830505 	streq	r0, [r3, #1285]	; 0x505
     cec:	3e054a2d 	vmlacc.f32	s8, s10, s27
     cf0:	8216054a 	andshi	r0, r6, #310378496	; 0x12800000
     cf4:	699f0105 	ldmibvs	pc, {r0, r2, r8}	; <UNPREDICTABLE>
     cf8:	05830505 	streq	r0, [r3, #1285]	; 0x505
     cfc:	3e054a2d 	vmlacc.f32	s8, s10, s27
     d00:	8216054a 	andshi	r0, r6, #310378496	; 0x12800000
     d04:	669f0105 	ldrvs	r0, [pc], r5, lsl #2
     d08:	0402009e 	streq	r0, [r2], #-158	; 0xffffff62
     d0c:	05660601 	strbeq	r0, [r6, #-1537]!	; 0xfffff9ff
     d10:	a1030612 	tstge	r3, r2, lsl r6
     d14:	0105827f 	tsteq	r5, pc, ror r2
     d18:	6600df03 	strvs	sp, [r0], -r3, lsl #30
     d1c:	0a024aba 	beq	9380c <_bss_end+0x88d2c>
     d20:	78010100 	stmdavc	r1, {r8}
     d24:	03000003 	movweq	r0, #3
     d28:	0001b800 	andeq	fp, r1, r0, lsl #16
     d2c:	fb010200 	blx	41536 <_bss_end+0x36a56>
     d30:	01000d0e 	tsteq	r0, lr, lsl #26
     d34:	00010101 	andeq	r0, r1, r1, lsl #2
     d38:	00010000 	andeq	r0, r1, r0
     d3c:	6d2f0100 	stfvss	f0, [pc, #-0]	; d44 <CPSR_IRQ_INHIBIT+0xcc4>
     d40:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
     d44:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
     d48:	4b2f7372 	blmi	bddb18 <_bss_end+0xbd3038>
     d4c:	2f616275 	svccs	0x00616275
     d50:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
     d54:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
     d58:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
     d5c:	614d6f72 	hvcvs	55026	; 0xd6f2
     d60:	652f6574 	strvs	r6, [pc, #-1396]!	; 7f4 <CPSR_IRQ_INHIBIT+0x774>
     d64:	706d6178 	rsbvc	r6, sp, r8, ror r1
     d68:	2f73656c 	svccs	0x0073656c
     d6c:	552d3032 	strpl	r3, [sp, #-50]!	; 0xffffffce
     d70:	5f545241 	svcpl	0x00545241
     d74:	656d6167 	strbvs	r6, [sp, #-359]!	; 0xfffffe99
     d78:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
     d7c:	2f6c656e 	svccs	0x006c656e
     d80:	00637273 	rsbeq	r7, r3, r3, ror r2
     d84:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
     d88:	552f632f 	strpl	r6, [pc, #-815]!	; a61 <CPSR_IRQ_INHIBIT+0x9e1>
     d8c:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
     d90:	62754b2f 	rsbsvs	r4, r5, #48128	; 0xbc00
     d94:	6f442f61 	svcvs	0x00442f61
     d98:	656d7563 	strbvs	r7, [sp, #-1379]!	; 0xfffffa9d
     d9c:	2f73746e 	svccs	0x0073746e
     da0:	6f72655a 	svcvs	0x0072655a
     da4:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
     da8:	6178652f 	cmnvs	r8, pc, lsr #10
     dac:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
     db0:	30322f73 	eorscc	r2, r2, r3, ror pc
     db4:	5241552d 	subpl	r5, r1, #188743680	; 0xb400000
     db8:	61675f54 	cmnvs	r7, r4, asr pc
     dbc:	6b2f656d 	blvs	bda378 <_bss_end+0xbcf898>
     dc0:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
     dc4:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
     dc8:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
     dcc:	6f622f65 	svcvs	0x00622f65
     dd0:	2f647261 	svccs	0x00647261
     dd4:	30697072 	rsbcc	r7, r9, r2, ror r0
     dd8:	6c61682f 	stclvs	8, cr6, [r1], #-188	; 0xffffff44
     ddc:	6e6d2f00 	cdpvs	15, 6, cr2, cr13, cr0, {0}
     de0:	2f632f74 	svccs	0x00632f74
     de4:	72657355 	rsbvc	r7, r5, #1409286145	; 0x54000001
     de8:	754b2f73 	strbvc	r2, [fp, #-3955]	; 0xfffff08d
     dec:	442f6162 	strtmi	r6, [pc], #-354	; df4 <CPSR_IRQ_INHIBIT+0xd74>
     df0:	6d75636f 	ldclvs	3, cr6, [r5, #-444]!	; 0xfffffe44
     df4:	73746e65 	cmnvc	r4, #1616	; 0x650
     df8:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
     dfc:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
     e00:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
     e04:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
     e08:	322f7365 	eorcc	r7, pc, #-1811939327	; 0x94000001
     e0c:	41552d30 	cmpmi	r5, r0, lsr sp
     e10:	675f5452 			; <UNDEFINED> instruction: 0x675f5452
     e14:	2f656d61 	svccs	0x00656d61
     e18:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
     e1c:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
     e20:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
     e24:	642f6564 	strtvs	r6, [pc], #-1380	; e2c <CPSR_IRQ_INHIBIT+0xdac>
     e28:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
     e2c:	2f007372 	svccs	0x00007372
     e30:	2f746e6d 	svccs	0x00746e6d
     e34:	73552f63 	cmpvc	r5, #396	; 0x18c
     e38:	2f737265 	svccs	0x00737265
     e3c:	6162754b 	cmnvs	r2, fp, asr #10
     e40:	636f442f 	cmnvs	pc, #788529152	; 0x2f000000
     e44:	6e656d75 	mcrvs	13, 3, r6, cr5, cr5, {3}
     e48:	5a2f7374 	bpl	bddc20 <_bss_end+0xbd3140>
     e4c:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; cc0 <CPSR_IRQ_INHIBIT+0xc40>
     e50:	2f657461 	svccs	0x00657461
     e54:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
     e58:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
     e5c:	2d30322f 	lfmcs	f3, 4, [r0, #-188]!	; 0xffffff44
     e60:	54524155 	ldrbpl	r4, [r2], #-341	; 0xfffffeab
     e64:	6d61675f 	stclvs	7, cr6, [r1, #-380]!	; 0xfffffe84
     e68:	656b2f65 	strbvs	r2, [fp, #-3941]!	; 0xfffff09b
     e6c:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
     e70:	636e692f 	cmnvs	lr, #770048	; 0xbc000
     e74:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
     e78:	6e690000 	cdpvs	0, 6, cr0, cr9, cr0, {0}
     e7c:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
     e80:	5f747075 	svcpl	0x00747075
     e84:	746e6f63 	strbtvc	r6, [lr], #-3939	; 0xfffff09d
     e88:	6c6c6f72 	stclvs	15, cr6, [ip], #-456	; 0xfffffe38
     e8c:	632e7265 			; <UNDEFINED> instruction: 0x632e7265
     e90:	01007070 	tsteq	r0, r0, ror r0
     e94:	65700000 	ldrbvs	r0, [r0, #-0]!
     e98:	68706972 	ldmdavs	r0!, {r1, r4, r5, r6, r8, fp, sp, lr}^
     e9c:	6c617265 	sfmvs	f7, 2, [r1], #-404	; 0xfffffe6c
     ea0:	00682e73 	rsbeq	r2, r8, r3, ror lr
     ea4:	62000002 	andvs	r0, r0, #2
     ea8:	615f6d63 	cmpvs	pc, r3, ror #26
     eac:	682e7875 	stmdavs	lr!, {r0, r2, r4, r5, r6, fp, ip, sp, lr}
     eb0:	00000300 	andeq	r0, r0, r0, lsl #6
     eb4:	74726175 	ldrbtvc	r6, [r2], #-373	; 0xfffffe8b
     eb8:	0300682e 	movweq	r6, #2094	; 0x82e
     ebc:	6e690000 	cdpvs	0, 6, cr0, cr9, cr0, {0}
     ec0:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
     ec4:	5f747075 	svcpl	0x00747075
     ec8:	746e6f63 	strbtvc	r6, [lr], #-3939	; 0xfffff09d
     ecc:	6c6c6f72 	stclvs	15, cr6, [ip], #-456	; 0xfffffe38
     ed0:	682e7265 	stmdavs	lr!, {r0, r2, r5, r6, r9, ip, sp, lr}
     ed4:	00000400 	andeq	r0, r0, r0, lsl #8
     ed8:	64746e69 	ldrbtvs	r6, [r4], #-3689	; 0xfffff197
     edc:	682e6665 	stmdavs	lr!, {r0, r2, r5, r6, r9, sl, sp, lr}
     ee0:	00000200 	andeq	r0, r0, r0, lsl #4
     ee4:	00010500 	andeq	r0, r1, r0, lsl #10
     ee8:	97bc0205 	ldrls	r0, [ip, r5, lsl #4]!
     eec:	0c030000 	stceq	0, cr0, [r3], {-0}
     ef0:	a10d0501 	tstge	sp, r1, lsl #10
     ef4:	054a0505 	strbeq	r0, [sl, #-1285]	; 0xfffffafb
     ef8:	1a05d90d 	bne	177334 <_bss_end+0x16c854>
     efc:	01040200 	mrseq	r0, R12_usr
     f00:	681c0566 	ldmdavs	ip, {r1, r2, r5, r6, r8, sl}
     f04:	86671d05 	strbthi	r1, [r7], -r5, lsl #26
     f08:	05671c05 	strbeq	r1, [r7, #-3077]!	; 0xfffff3fb
     f0c:	19056711 	stmdbne	r5, {r0, r4, r8, r9, sl, sp, lr}
     f10:	67210532 			; <UNDEFINED> instruction: 0x67210532
     f14:	054a2b05 	strbeq	r2, [sl, #-2821]	; 0xfffff4fb
     f18:	34054a29 	strcc	r4, [r5], #-2601	; 0xfffff5d7
     f1c:	8216052e 	andshi	r0, r6, #192937984	; 0xb800000
     f20:	054a1e05 	strbeq	r1, [sl, #-3589]	; 0xfffff1fb
     f24:	19052e14 	stmdbne	r5, {r2, r4, r9, sl, fp, sp}
     f28:	18059f4b 	stmdane	r5, {r0, r1, r3, r6, r8, r9, sl, fp, ip, pc}
     f2c:	670d0567 	strvs	r0, [sp, -r7, ror #10]
     f30:	001a0531 	andseq	r0, sl, r1, lsr r5
     f34:	66010402 	strvs	r0, [r1], -r2, lsl #8
     f38:	05681b05 	strbeq	r1, [r8, #-2821]!	; 0xfffff4fb
     f3c:	19054a22 	stmdbne	r5, {r1, r5, r9, fp, lr}
     f40:	1b054b2e 	blne	153c00 <_bss_end+0x149120>
     f44:	4a22056a 	bmi	8824f4 <_bss_end+0x877a14>
     f48:	4b2e1905 	blmi	b87364 <_bss_end+0xb7c884>
     f4c:	054d1105 	strbeq	r1, [sp, #-261]	; 0xfffffefb
     f50:	19054a1b 	stmdbne	r5, {r0, r1, r3, r4, r9, fp, lr}
     f54:	820d054a 	andhi	r0, sp, #310378496	; 0x12800000
     f58:	674c1d05 	strbvs	r1, [ip, -r5, lsl #26]
     f5c:	1c05679f 	stcne	7, cr6, [r5], {159}	; 0x9f
     f60:	67110567 	ldrvs	r0, [r1, -r7, ror #10]
     f64:	05312105 	ldreq	r2, [r1, #-261]!	; 0xfffffefb
     f68:	29054a2b 	stmdbcs	r5, {r0, r1, r3, r5, r9, fp, lr}
     f6c:	2e34054a 	cdpcs	5, 3, cr0, cr4, cr10, {2}
     f70:	05821605 	streq	r1, [r2, #1541]	; 0x605
     f74:	14054a1e 	strne	r4, [r5], #-2590	; 0xfffff5e2
     f78:	4b19052e 	blmi	642438 <_bss_end+0x637958>
     f7c:	0d059f67 	stceq	15, cr9, [r5, #-412]	; 0xfffffe64
     f80:	1a053168 	bne	14d528 <_bss_end+0x142a48>
     f84:	01040200 	mrseq	r0, R12_usr
     f88:	68190566 	ldmdavs	r9, {r1, r2, r5, r6, r8, sl}
     f8c:	681d0567 	ldmdavs	sp, {r0, r1, r2, r5, r6, r8, sl}
     f90:	05672505 	strbeq	r2, [r7, #-1285]!	; 0xfffffafb
     f94:	2d054a2f 	vstrcs	s8, [r5, #-188]	; 0xffffff44
     f98:	2e38054a 	cdpcs	5, 3, cr0, cr8, cr10, {2}
     f9c:	05821a05 	streq	r1, [r2, #2565]	; 0xa05
     fa0:	18054a22 	stmdane	r5, {r1, r5, r9, fp, lr}
     fa4:	4b1d052e 	blmi	742464 <_bss_end+0x737984>
     fa8:	671c059f 			; <UNDEFINED> instruction: 0x671c059f
     fac:	056d0d05 	strbeq	r0, [sp, #-3333]!	; 0xfffff2fb
     fb0:	1c052b1d 			; <UNDEFINED> instruction: 0x1c052b1d
     fb4:	680d0567 	stmdavs	sp, {r0, r1, r2, r5, r6, r8, sl}
     fb8:	30010531 	andcc	r0, r1, r1, lsr r5
     fbc:	854be708 	strbhi	lr, [fp, #-1800]	; 0xfffff8f8
     fc0:	05851005 	streq	r1, [r5, #5]
     fc4:	0505830b 	streq	r8, [r5, #-779]	; 0xfffffcf5
     fc8:	0018052e 	andseq	r0, r8, lr, lsr #10
     fcc:	4a010402 	bmi	41fdc <_bss_end+0x374fc>
     fd0:	02001305 	andeq	r1, r0, #335544320	; 0x14000000
     fd4:	052e0104 	streq	r0, [lr, #-260]!	; 0xfffffefc
     fd8:	09054d12 	stmdbeq	r5, {r1, r4, r8, sl, fp, lr}
     fdc:	31010580 	smlabbcc	r1, r0, r5, r0
     fe0:	056a2f69 	strbeq	r2, [sl, #-3945]!	; 0xfffff097
     fe4:	38059f13 	stmdacc	r5, {r0, r1, r4, r8, r9, sl, fp, ip, pc}
     fe8:	4c01052e 	cfstr32mi	mvfx0, [r1], {46}	; 0x2e
     fec:	9f0c05a1 	svcls	0x000c05a1
     ff0:	054a1c05 	strbeq	r1, [sl, #-3077]	; 0xfffff3fb
     ff4:	01052e3a 	tsteq	r5, sl, lsr lr
     ff8:	4305854b 	movwmi	r8, #21835	; 0x554b
     ffc:	2e40059f 	mcrcs	5, 2, r0, cr0, cr15, {4}
    1000:	054a3905 	strbeq	r3, [sl, #-2309]	; 0xfffff6fb
    1004:	3b058240 	blcc	16190c <_bss_end+0x156e2c>
    1008:	2f01052e 	svccs	0x0001052e
    100c:	9f440569 	svcls	0x00440569
    1010:	052e4105 	streq	r4, [lr, #-261]!	; 0xfffffefb
    1014:	41054a3a 	tstmi	r5, sl, lsr sl
    1018:	2e3c0582 	cfadd32cs	mvfx0, mvfx12, mvfx2
    101c:	692f0105 	stmdbvs	pc!, {r0, r2, r8}	; <UNPREDICTABLE>
    1020:	059f1805 	ldreq	r1, [pc, #2053]	; 182d <CPSR_IRQ_INHIBIT+0x17ad>
    1024:	08054d15 	stmdaeq	r5, {r0, r2, r4, r8, sl, fp, lr}
    1028:	4973054a 	ldmdbmi	r3!, {r1, r3, r6, r8, sl}^
    102c:	01040200 	mrseq	r0, R12_usr
    1030:	02006606 	andeq	r6, r0, #6291456	; 0x600000
    1034:	004a0204 	subeq	r0, sl, r4, lsl #4
    1038:	2e040402 	cdpcs	4, 0, cr0, cr4, cr2, {0}
    103c:	02000805 	andeq	r0, r0, #327680	; 0x50000
    1040:	83060404 	movwhi	r0, #25604	; 0x6404
    1044:	02007505 	andeq	r7, r0, #20971520	; 0x1400000
    1048:	052d0404 	streq	r0, [sp, #-1028]!	; 0xfffffbfc
    104c:	04020001 	streq	r0, [r2], #-1
    1050:	05693004 	strbeq	r3, [r9, #-4]!
    1054:	15059f18 	strne	r9, [r5, #-3864]	; 0xfffff0e8
    1058:	4a08054d 	bmi	202594 <_bss_end+0x1f7ab4>
    105c:	00497505 	subeq	r7, r9, r5, lsl #10
    1060:	06010402 	streq	r0, [r1], -r2, lsl #8
    1064:	04020066 	streq	r0, [r2], #-102	; 0xffffff9a
    1068:	02004a02 	andeq	r4, r0, #8192	; 0x2000
    106c:	052e0404 	streq	r0, [lr, #-1028]!	; 0xfffffbfc
    1070:	04020008 	streq	r0, [r2], #-8
    1074:	05830604 	streq	r0, [r3, #1540]	; 0x604
    1078:	04020077 	streq	r0, [r2], #-119	; 0xffffff89
    107c:	01052d04 	tsteq	r5, r4, lsl #26
    1080:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
    1084:	009e6630 	addseq	r6, lr, r0, lsr r6
    1088:	06010402 	streq	r0, [r1], -r2, lsl #8
    108c:	06430566 	strbeq	r0, [r3], -r6, ror #10
    1090:	05825c03 	streq	r5, [r2, #3075]	; 0xc03
    1094:	66240301 	strtvs	r0, [r4], -r1, lsl #6
    1098:	0a024aba 	beq	93b88 <_bss_end+0x890a8>
    109c:	d8010100 	stmdale	r1, {r8}
    10a0:	03000001 	movweq	r0, #1
    10a4:	0001a800 	andeq	sl, r1, r0, lsl #16
    10a8:	fb010200 	blx	418b2 <_bss_end+0x36dd2>
    10ac:	01000d0e 	tsteq	r0, lr, lsl #26
    10b0:	00010101 	andeq	r0, r1, r1, lsl #2
    10b4:	00010000 	andeq	r0, r1, r0
    10b8:	6d2f0100 	stfvss	f0, [pc, #-0]	; 10c0 <CPSR_IRQ_INHIBIT+0x1040>
    10bc:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
    10c0:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
    10c4:	4b2f7372 	blmi	bdde94 <_bss_end+0xbd33b4>
    10c8:	2f616275 	svccs	0x00616275
    10cc:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
    10d0:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
    10d4:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
    10d8:	614d6f72 	hvcvs	55026	; 0xd6f2
    10dc:	652f6574 	strvs	r6, [pc, #-1396]!	; b70 <CPSR_IRQ_INHIBIT+0xaf0>
    10e0:	706d6178 	rsbvc	r6, sp, r8, ror r1
    10e4:	2f73656c 	svccs	0x0073656c
    10e8:	552d3032 	strpl	r3, [sp, #-50]!	; 0xffffffce
    10ec:	5f545241 	svcpl	0x00545241
    10f0:	656d6167 	strbvs	r6, [sp, #-359]!	; 0xfffffe99
    10f4:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
    10f8:	2f6c656e 	svccs	0x006c656e
    10fc:	00637273 	rsbeq	r7, r3, r3, ror r2
    1100:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
    1104:	552f632f 	strpl	r6, [pc, #-815]!	; ddd <CPSR_IRQ_INHIBIT+0xd5d>
    1108:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
    110c:	62754b2f 	rsbsvs	r4, r5, #48128	; 0xbc00
    1110:	6f442f61 	svcvs	0x00442f61
    1114:	656d7563 	strbvs	r7, [sp, #-1379]!	; 0xfffffa9d
    1118:	2f73746e 	svccs	0x0073746e
    111c:	6f72655a 	svcvs	0x0072655a
    1120:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
    1124:	6178652f 	cmnvs	r8, pc, lsr #10
    1128:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
    112c:	30322f73 	eorscc	r2, r2, r3, ror pc
    1130:	5241552d 	subpl	r5, r1, #188743680	; 0xb400000
    1134:	61675f54 	cmnvs	r7, r4, asr pc
    1138:	6b2f656d 	blvs	bda6f4 <_bss_end+0xbcfc14>
    113c:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
    1140:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
    1144:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
    1148:	6f622f65 	svcvs	0x00622f65
    114c:	2f647261 	svccs	0x00647261
    1150:	30697072 	rsbcc	r7, r9, r2, ror r0
    1154:	6c61682f 	stclvs	8, cr6, [r1], #-188	; 0xffffff44
    1158:	6e6d2f00 	cdpvs	15, 6, cr2, cr13, cr0, {0}
    115c:	2f632f74 	svccs	0x00632f74
    1160:	72657355 	rsbvc	r7, r5, #1409286145	; 0x54000001
    1164:	754b2f73 	strbvc	r2, [fp, #-3955]	; 0xfffff08d
    1168:	442f6162 	strtmi	r6, [pc], #-354	; 1170 <CPSR_IRQ_INHIBIT+0x10f0>
    116c:	6d75636f 	ldclvs	3, cr6, [r5, #-444]!	; 0xfffffe44
    1170:	73746e65 	cmnvc	r4, #1616	; 0x650
    1174:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
    1178:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
    117c:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
    1180:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
    1184:	322f7365 	eorcc	r7, pc, #-1811939327	; 0x94000001
    1188:	41552d30 	cmpmi	r5, r0, lsr sp
    118c:	675f5452 			; <UNDEFINED> instruction: 0x675f5452
    1190:	2f656d61 	svccs	0x00656d61
    1194:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
    1198:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
    119c:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
    11a0:	642f6564 	strtvs	r6, [pc], #-1380	; 11a8 <CPSR_IRQ_INHIBIT+0x1128>
    11a4:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
    11a8:	2f007372 	svccs	0x00007372
    11ac:	2f746e6d 	svccs	0x00746e6d
    11b0:	73552f63 	cmpvc	r5, #396	; 0x18c
    11b4:	2f737265 	svccs	0x00737265
    11b8:	6162754b 	cmnvs	r2, fp, asr #10
    11bc:	636f442f 	cmnvs	pc, #788529152	; 0x2f000000
    11c0:	6e656d75 	mcrvs	13, 3, r6, cr5, cr5, {3}
    11c4:	5a2f7374 	bpl	bddf9c <_bss_end+0xbd34bc>
    11c8:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 103c <CPSR_IRQ_INHIBIT+0xfbc>
    11cc:	2f657461 	svccs	0x00657461
    11d0:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
    11d4:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
    11d8:	2d30322f 	lfmcs	f3, 4, [r0, #-188]!	; 0xffffff44
    11dc:	54524155 	ldrbpl	r4, [r2], #-341	; 0xfffffeab
    11e0:	6d61675f 	stclvs	7, cr6, [r1, #-380]!	; 0xfffffe84
    11e4:	656b2f65 	strbvs	r2, [fp, #-3941]!	; 0xfffff09b
    11e8:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
    11ec:	636e692f 	cmnvs	lr, #770048	; 0xbc000
    11f0:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
    11f4:	616d0000 	cmnvs	sp, r0
    11f8:	632e6e69 			; <UNDEFINED> instruction: 0x632e6e69
    11fc:	01007070 	tsteq	r0, r0, ror r0
    1200:	65700000 	ldrbvs	r0, [r0, #-0]!
    1204:	68706972 	ldmdavs	r0!, {r1, r4, r5, r6, r8, fp, sp, lr}^
    1208:	6c617265 	sfmvs	f7, 2, [r1], #-404	; 0xfffffe6c
    120c:	00682e73 	rsbeq	r2, r8, r3, ror lr
    1210:	62000002 	andvs	r0, r0, #2
    1214:	615f6d63 	cmpvs	pc, r3, ror #26
    1218:	682e7875 	stmdavs	lr!, {r0, r2, r4, r5, r6, fp, ip, sp, lr}
    121c:	00000300 	andeq	r0, r0, r0, lsl #6
    1220:	74726175 	ldrbtvc	r6, [r2], #-373	; 0xfffffe8b
    1224:	0300682e 	movweq	r6, #2094	; 0x82e
    1228:	6e690000 	cdpvs	0, 6, cr0, cr9, cr0, {0}
    122c:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
    1230:	5f747075 	svcpl	0x00747075
    1234:	746e6f63 	strbtvc	r6, [lr], #-3939	; 0xfffff09d
    1238:	6c6c6f72 	stclvs	15, cr6, [ip], #-456	; 0xfffffe38
    123c:	682e7265 	stmdavs	lr!, {r0, r2, r5, r6, r9, ip, sp, lr}
    1240:	00000400 	andeq	r0, r0, r0, lsl #8
    1244:	64746e69 	ldrbtvs	r6, [r4], #-3689	; 0xfffff197
    1248:	682e6665 	stmdavs	lr!, {r0, r2, r5, r6, r9, sl, sp, lr}
    124c:	00000200 	andeq	r0, r0, r0, lsl #4
    1250:	00010500 	andeq	r0, r1, r0, lsl #10
    1254:	9d9c0205 	lfmls	f0, 4, [ip, #20]
    1258:	05170000 	ldreq	r0, [r7, #-0]
    125c:	19054b1d 	stmdbne	r5, {r0, r2, r3, r4, r8, r9, fp, lr}
    1260:	671b0568 	ldrvs	r0, [fp, -r8, ror #10]
    1264:	05681e05 	strbeq	r1, [r8, #-3589]!	; 0xfffff1fb
    1268:	11054c0f 	tstne	r5, pc, lsl #24
    126c:	05676730 	strbeq	r6, [r7, #-1840]!	; 0xfffff8d0
    1270:	04020005 	streq	r0, [r2], #-5
    1274:	0e026901 	vmlaeq.f16	s12, s4, s2	; <UNPREDICTABLE>
    1278:	af010100 	svcge	0x00010100
    127c:	03000000 	movweq	r0, #0
    1280:	00006400 	andeq	r6, r0, r0, lsl #8
    1284:	fb010200 	blx	41a8e <_bss_end+0x36fae>
    1288:	01000d0e 	tsteq	r0, lr, lsl #26
    128c:	00010101 	andeq	r0, r1, r1, lsl #2
    1290:	00010000 	andeq	r0, r1, r0
    1294:	6d2f0100 	stfvss	f0, [pc, #-0]	; 129c <CPSR_IRQ_INHIBIT+0x121c>
    1298:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
    129c:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
    12a0:	4b2f7372 	blmi	bde070 <_bss_end+0xbd3590>
    12a4:	2f616275 	svccs	0x00616275
    12a8:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
    12ac:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
    12b0:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
    12b4:	614d6f72 	hvcvs	55026	; 0xd6f2
    12b8:	652f6574 	strvs	r6, [pc, #-1396]!	; d4c <CPSR_IRQ_INHIBIT+0xccc>
    12bc:	706d6178 	rsbvc	r6, sp, r8, ror r1
    12c0:	2f73656c 	svccs	0x0073656c
    12c4:	552d3032 	strpl	r3, [sp, #-50]!	; 0xffffffce
    12c8:	5f545241 	svcpl	0x00545241
    12cc:	656d6167 	strbvs	r6, [sp, #-359]!	; 0xfffffe99
    12d0:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
    12d4:	2f6c656e 	svccs	0x006c656e
    12d8:	00637273 	rsbeq	r7, r3, r3, ror r2
    12dc:	61747300 	cmnvs	r4, r0, lsl #6
    12e0:	732e7472 			; <UNDEFINED> instruction: 0x732e7472
    12e4:	00000100 	andeq	r0, r0, r0, lsl #2
    12e8:	02050000 	andeq	r0, r5, #0
    12ec:	00008000 	andeq	r8, r0, r0
    12f0:	2f010d03 	svccs	0x00010d03
    12f4:	2f2f2f2f 	svccs	0x002f2f2f
    12f8:	1d032f2f 	stcne	15, cr2, [r3, #-188]	; 0xffffff44
    12fc:	2f312008 	svccs	0x00312008
    1300:	2f2f2f32 	svccs	0x002f2f32
    1304:	312f2f31 			; <UNDEFINED> instruction: 0x312f2f31
    1308:	2f312f2f 	svccs	0x00312f2f
    130c:	2f2f302f 	svccs	0x002f302f
    1310:	0202302f 	andeq	r3, r2, #47	; 0x2f
    1314:	00010100 	andeq	r0, r1, r0, lsl #2
    1318:	9e140205 	cdpls	2, 1, cr0, cr4, cr5, {0}
    131c:	d9030000 	stmdble	r3, {}	; <UNPREDICTABLE>
    1320:	2f2f0100 	svccs	0x002f0100
    1324:	33312f2f 	teqcc	r1, #47, 30	; 0xbc
    1328:	00020233 	andeq	r0, r2, r3, lsr r2
    132c:	00e90101 	rsceq	r0, r9, r1, lsl #2
    1330:	00030000 	andeq	r0, r3, r0
    1334:	00000068 	andeq	r0, r0, r8, rrx
    1338:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
    133c:	0101000d 	tsteq	r1, sp
    1340:	00000101 	andeq	r0, r0, r1, lsl #2
    1344:	00000100 	andeq	r0, r0, r0, lsl #2
    1348:	6e6d2f01 	cdpvs	15, 6, cr2, cr13, cr1, {0}
    134c:	2f632f74 	svccs	0x00632f74
    1350:	72657355 	rsbvc	r7, r5, #1409286145	; 0x54000001
    1354:	754b2f73 	strbvc	r2, [fp, #-3955]	; 0xfffff08d
    1358:	442f6162 	strtmi	r6, [pc], #-354	; 1360 <CPSR_IRQ_INHIBIT+0x12e0>
    135c:	6d75636f 	ldclvs	3, cr6, [r5, #-444]!	; 0xfffffe44
    1360:	73746e65 	cmnvc	r4, #1616	; 0x650
    1364:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
    1368:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
    136c:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
    1370:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
    1374:	322f7365 	eorcc	r7, pc, #-1811939327	; 0x94000001
    1378:	41552d30 	cmpmi	r5, r0, lsr sp
    137c:	675f5452 			; <UNDEFINED> instruction: 0x675f5452
    1380:	2f656d61 	svccs	0x00656d61
    1384:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
    1388:	732f6c65 			; <UNDEFINED> instruction: 0x732f6c65
    138c:	00006372 	andeq	r6, r0, r2, ror r3
    1390:	72617473 	rsbvc	r7, r1, #1929379840	; 0x73000000
    1394:	2e707574 	mrccs	5, 3, r7, cr0, cr4, {3}
    1398:	00707063 	rsbseq	r7, r0, r3, rrx
    139c:	00000001 	andeq	r0, r0, r1
    13a0:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
    13a4:	009e3402 	addseq	r3, lr, r2, lsl #8
    13a8:	01140300 	tsteq	r4, r0, lsl #6
    13ac:	056a0c05 	strbeq	r0, [sl, #-3077]!	; 0xfffff3fb
    13b0:	04020022 	streq	r0, [r2], #-34	; 0xffffffde
    13b4:	0c056603 	stceq	6, cr6, [r5], {3}
    13b8:	02040200 	andeq	r0, r4, #0, 4
    13bc:	000505bb 			; <UNDEFINED> instruction: 0x000505bb
    13c0:	65020402 	strvs	r0, [r2, #-1026]	; 0xfffffbfe
    13c4:	05850c05 	streq	r0, [r5, #3077]	; 0xc05
    13c8:	05bd2f01 	ldreq	r2, [sp, #3841]!	; 0xf01
    13cc:	27056b10 	smladcs	r5, r0, fp, r6
    13d0:	03040200 	movweq	r0, #16896	; 0x4200
    13d4:	000a054a 	andeq	r0, sl, sl, asr #10
    13d8:	83020402 	movwhi	r0, #9218	; 0x2402
    13dc:	02001105 	andeq	r1, r0, #1073741825	; 0x40000001
    13e0:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
    13e4:	04020005 	streq	r0, [r2], #-5
    13e8:	0c052d02 	stceq	13, cr2, [r5], {2}
    13ec:	2f010585 	svccs	0x00010585
    13f0:	6a1005a1 	bvs	402a7c <_bss_end+0x3f7f9c>
    13f4:	02002705 	andeq	r2, r0, #1310720	; 0x140000
    13f8:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
    13fc:	0402000a 	streq	r0, [r2], #-10
    1400:	11058302 	tstne	r5, r2, lsl #6
    1404:	02040200 	andeq	r0, r4, #0, 4
    1408:	0005054a 	andeq	r0, r5, sl, asr #10
    140c:	2d020402 	cfstrscs	mvf0, [r2, #-8]
    1410:	05850c05 	streq	r0, [r5, #3077]	; 0xc05
    1414:	0a022f01 	beq	8d020 <_bss_end+0x82540>
    1418:	8d010100 	stfhis	f0, [r1, #-0]
    141c:	03000002 	movweq	r0, #2
    1420:	00006a00 	andeq	r6, r0, r0, lsl #20
    1424:	fb010200 	blx	41c2e <_bss_end+0x3714e>
    1428:	01000d0e 	tsteq	r0, lr, lsl #26
    142c:	00010101 	andeq	r0, r1, r1, lsl #2
    1430:	00010000 	andeq	r0, r1, r0
    1434:	6d2f0100 	stfvss	f0, [pc, #-0]	; 143c <CPSR_IRQ_INHIBIT+0x13bc>
    1438:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
    143c:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
    1440:	4b2f7372 	blmi	bde210 <_bss_end+0xbd3730>
    1444:	2f616275 	svccs	0x00616275
    1448:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
    144c:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
    1450:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
    1454:	614d6f72 	hvcvs	55026	; 0xd6f2
    1458:	652f6574 	strvs	r6, [pc, #-1396]!	; eec <CPSR_IRQ_INHIBIT+0xe6c>
    145c:	706d6178 	rsbvc	r6, sp, r8, ror r1
    1460:	2f73656c 	svccs	0x0073656c
    1464:	552d3032 	strpl	r3, [sp, #-50]!	; 0xffffffce
    1468:	5f545241 	svcpl	0x00545241
    146c:	656d6167 	strbvs	r6, [sp, #-359]!	; 0xfffffe99
    1470:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
    1474:	2f62696c 	svccs	0x0062696c
    1478:	00637273 	rsbeq	r7, r3, r3, ror r2
    147c:	64747300 	ldrbtvs	r7, [r4], #-768	; 0xfffffd00
    1480:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
    1484:	632e676e 			; <UNDEFINED> instruction: 0x632e676e
    1488:	01007070 	tsteq	r0, r0, ror r0
    148c:	05000000 	streq	r0, [r0, #-0]
    1490:	02050001 	andeq	r0, r5, #1
    1494:	00009f4c 	andeq	r9, r0, ip, asr #30
    1498:	bb09051a 	bllt	242908 <_bss_end+0x237e28>
    149c:	054c1205 	strbeq	r1, [ip, #-517]	; 0xfffffdfb
    14a0:	10056827 	andne	r6, r5, r7, lsr #16
    14a4:	2e1105ba 	cfcmp64cs	r0, mvdx1, mvdx10
    14a8:	054a2d05 	strbeq	r2, [sl, #-3333]	; 0xfffff2fb
    14ac:	0f054a13 	svceq	0x00054a13
    14b0:	9f0a052f 	svcls	0x000a052f
    14b4:	35620505 	strbcc	r0, [r2, #-1285]!	; 0xfffffafb
    14b8:	05681005 	strbeq	r1, [r8, #-5]!
    14bc:	22052e11 	andcs	r2, r5, #272	; 0x110
    14c0:	2e13054a 	cfmac32cs	mvfx0, mvfx3, mvfx10
    14c4:	052f0a05 	streq	r0, [pc, #-2565]!	; ac7 <CPSR_IRQ_INHIBIT+0xa47>
    14c8:	0d05690c 	vstreq.16	s12, [r5, #-24]	; 0xffffffe8	; <UNPREDICTABLE>
    14cc:	4a0f052e 	bmi	3c298c <_bss_end+0x3b7eac>
    14d0:	054b0605 	strbeq	r0, [fp, #-1541]	; 0xfffff9fb
    14d4:	1c05680e 	stcne	8, cr6, [r5], {14}
    14d8:	03040200 	movweq	r0, #16896	; 0x4200
    14dc:	0017054a 	andseq	r0, r7, sl, asr #10
    14e0:	9e030402 	cdpls	4, 0, cr0, cr3, cr2, {0}
    14e4:	02001b05 	andeq	r1, r0, #5120	; 0x1400
    14e8:	05680204 	strbeq	r0, [r8, #-516]!	; 0xfffffdfc
    14ec:	0402001e 	streq	r0, [r2], #-30	; 0xffffffe2
    14f0:	0e058202 	cdpeq	2, 0, cr8, cr5, cr2, {0}
    14f4:	02040200 	andeq	r0, r4, #0, 4
    14f8:	0020054a 	eoreq	r0, r0, sl, asr #10
    14fc:	4b020402 	blmi	8250c <_bss_end+0x77a2c>
    1500:	02002105 	andeq	r2, r0, #1073741825	; 0x40000001
    1504:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
    1508:	04020012 	streq	r0, [r2], #-18	; 0xffffffee
    150c:	15054a02 	strne	r4, [r5, #-2562]	; 0xfffff5fe
    1510:	02040200 	andeq	r0, r4, #0, 4
    1514:	00210582 	eoreq	r0, r1, r2, lsl #11
    1518:	4a020402 	bmi	82528 <_bss_end+0x77a48>
    151c:	02001705 	andeq	r1, r0, #1310720	; 0x140000
    1520:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
    1524:	04020010 	streq	r0, [r2], #-16
    1528:	11052f02 	tstne	r5, r2, lsl #30
    152c:	02040200 	andeq	r0, r4, #0, 4
    1530:	0013052e 	andseq	r0, r3, lr, lsr #10
    1534:	4a020402 	bmi	82544 <_bss_end+0x77a64>
    1538:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
    153c:	05460204 	strbeq	r0, [r6, #-516]	; 0xfffffdfc
    1540:	05858801 	streq	r8, [r5, #2049]	; 0x801
    1544:	0c058309 	stceq	3, cr8, [r5], {9}
    1548:	4a13054c 	bmi	4c2a80 <_bss_end+0x4b7fa0>
    154c:	054c1005 	strbeq	r1, [ip, #-5]
    1550:	0905bb0d 	stmdbeq	r5, {r0, r2, r3, r8, r9, fp, ip, sp, pc}
    1554:	001d054a 	andseq	r0, sp, sl, asr #10
    1558:	4a010402 	bmi	42568 <_bss_end+0x37a88>
    155c:	02001a05 	andeq	r1, r0, #20480	; 0x5000
    1560:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
    1564:	1a054d13 	bne	1549b8 <_bss_end+0x149ed8>
    1568:	2e10054a 	cfmac32cs	mvfx0, mvfx0, mvfx10
    156c:	05680e05 	strbeq	r0, [r8, #-3589]!	; 0xfffff1fb
    1570:	66780305 	ldrbtvs	r0, [r8], -r5, lsl #6
    1574:	0b030c05 	bleq	c4590 <_bss_end+0xb9ab0>
    1578:	2f01052e 	svccs	0x0001052e
    157c:	bd0c0585 	cfstr32lt	mvfx0, [ip, #-532]	; 0xfffffdec
    1580:	02001905 	andeq	r1, r0, #81920	; 0x14000
    1584:	054a0404 	strbeq	r0, [sl, #-1028]	; 0xfffffbfc
    1588:	04020020 	streq	r0, [r2], #-32	; 0xffffffe0
    158c:	21058202 	tstcs	r5, r2, lsl #4
    1590:	02040200 	andeq	r0, r4, #0, 4
    1594:	0019052e 	andseq	r0, r9, lr, lsr #10
    1598:	66020402 	strvs	r0, [r2], -r2, lsl #8
    159c:	02001705 	andeq	r1, r0, #1310720	; 0x140000
    15a0:	054b0304 	strbeq	r0, [fp, #-772]	; 0xfffffcfc
    15a4:	04020018 	streq	r0, [r2], #-24	; 0xffffffe8
    15a8:	0e052e03 	cdpeq	14, 0, cr2, cr5, cr3, {0}
    15ac:	03040200 	movweq	r0, #16896	; 0x4200
    15b0:	000f054a 	andeq	r0, pc, sl, asr #10
    15b4:	2e030402 	cdpcs	4, 0, cr0, cr3, cr2, {0}
    15b8:	02001805 	andeq	r1, r0, #327680	; 0x50000
    15bc:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
    15c0:	04020011 	streq	r0, [r2], #-17	; 0xffffffef
    15c4:	05052e03 	streq	r2, [r5, #-3587]	; 0xfffff1fd
    15c8:	03040200 	movweq	r0, #16896	; 0x4200
    15cc:	000e052d 	andeq	r0, lr, sp, lsr #10
    15d0:	84020402 	strhi	r0, [r2], #-1026	; 0xfffffbfe
    15d4:	01040200 	mrseq	r0, R12_usr
    15d8:	000f0583 	andeq	r0, pc, r3, lsl #11
    15dc:	2e010402 	cdpcs	4, 0, cr0, cr1, cr2, {0}
    15e0:	02001105 	andeq	r1, r0, #1073741825	; 0x40000001
    15e4:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
    15e8:	04020005 	streq	r0, [r2], #-5
    15ec:	0c054901 			; <UNDEFINED> instruction: 0x0c054901
    15f0:	2f010585 	svccs	0x00010585
    15f4:	bc0f0585 	cfstr32lt	mvfx0, [pc], {133}	; 0x85
    15f8:	05661205 	strbeq	r1, [r6, #-517]!	; 0xfffffdfb
    15fc:	0c05bc20 	stceq	12, cr11, [r5], {32}
    1600:	4b200566 	blmi	802ba0 <_bss_end+0x7f80c0>
    1604:	05660c05 	strbeq	r0, [r6, #-3077]!	; 0xfffff3fb
    1608:	14054b09 	strne	r4, [r5], #-2825	; 0xfffff4f7
    160c:	2e190583 	cdpcs	5, 1, cr0, cr9, cr3, {4}
    1610:	05670905 	strbeq	r0, [r7, #-2309]!	; 0xfffff6fb
    1614:	0c056714 	stceq	7, cr6, [r5], {20}
    1618:	2f01054d 	svccs	0x0001054d
    161c:	83090585 	movwhi	r0, #38277	; 0x9585
    1620:	054c0e05 	strbeq	r0, [ip, #-3589]	; 0xfffff1fb
    1624:	11052e0f 	tstne	r5, pc, lsl #28
    1628:	4b0a0566 	blmi	282bc8 <_bss_end+0x2780e8>
    162c:	05650505 	strbeq	r0, [r5, #-1285]!	; 0xfffffafb
    1630:	0105310c 	tsteq	r5, ip, lsl #2
    1634:	0b05852f 	bleq	162af8 <_bss_end+0x158018>
    1638:	4c0e059f 	cfstr32mi	mvfx0, [lr], {159}	; 0x9f
    163c:	02001705 	andeq	r1, r0, #1310720	; 0x140000
    1640:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
    1644:	0402000d 	streq	r0, [r2], #-13
    1648:	0e058302 	cdpeq	3, 0, cr8, cr5, cr2, {0}
    164c:	02040200 	andeq	r0, r4, #0, 4
    1650:	0010052e 	andseq	r0, r0, lr, lsr #10
    1654:	4a020402 	bmi	82664 <_bss_end+0x77b84>
    1658:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
    165c:	05490204 	strbeq	r0, [r9, #-516]	; 0xfffffdfc
    1660:	05858401 	streq	r8, [r5, #1025]	; 0x401
    1664:	0b05bb11 	bleq	1702b0 <_bss_end+0x1657d0>
    1668:	4c0e054b 	cfstr32mi	mvfx0, [lr], {75}	; 0x4b
    166c:	02001705 	andeq	r1, r0, #1310720	; 0x140000
    1670:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
    1674:	0402001c 	streq	r0, [r2], #-28	; 0xffffffe4
    1678:	1d058302 	stcne	3, cr8, [r5, #-8]
    167c:	02040200 	andeq	r0, r4, #0, 4
    1680:	0010052e 	andseq	r0, r0, lr, lsr #10
    1684:	4a020402 	bmi	82694 <_bss_end+0x77bb4>
    1688:	02001105 	andeq	r1, r0, #1073741825	; 0x40000001
    168c:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
    1690:	0402001d 	streq	r0, [r2], #-29	; 0xffffffe3
    1694:	13054a02 	movwne	r4, #23042	; 0x5a02
    1698:	02040200 	andeq	r0, r4, #0, 4
    169c:	0005052e 	andeq	r0, r5, lr, lsr #10
    16a0:	2d020402 	cfstrscs	mvf0, [r2, #-8]
    16a4:	02840105 	addeq	r0, r4, #1073741825	; 0x40000001
    16a8:	01010008 	tsteq	r1, r8
    16ac:	00000079 	andeq	r0, r0, r9, ror r0
    16b0:	00460003 	subeq	r0, r6, r3
    16b4:	01020000 	mrseq	r0, (UNDEF: 2)
    16b8:	000d0efb 	strdeq	r0, [sp], -fp
    16bc:	01010101 	tsteq	r1, r1, lsl #2
    16c0:	01000000 	mrseq	r0, (UNDEF: 0)
    16c4:	2e010000 	cdpcs	0, 0, cr0, cr1, cr0, {0}
    16c8:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    16cc:	2f2e2e2f 	svccs	0x002e2e2f
    16d0:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    16d4:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    16d8:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    16dc:	2f636367 	svccs	0x00636367
    16e0:	666e6f63 	strbtvs	r6, [lr], -r3, ror #30
    16e4:	612f6769 			; <UNDEFINED> instruction: 0x612f6769
    16e8:	00006d72 	andeq	r6, r0, r2, ror sp
    16ec:	3162696c 	cmncc	r2, ip, ror #18
    16f0:	636e7566 	cmnvs	lr, #427819008	; 0x19800000
    16f4:	00532e73 	subseq	r2, r3, r3, ror lr
    16f8:	00000001 	andeq	r0, r0, r1
    16fc:	04020500 	streq	r0, [r2], #-1280	; 0xfffffb00
    1700:	030000a4 	movweq	r0, #164	; 0xa4
    1704:	300108cf 	andcc	r0, r1, pc, asr #17
    1708:	2f2f2f2f 	svccs	0x002f2f2f
    170c:	d002302f 	andle	r3, r2, pc, lsr #32
    1710:	312f1401 			; <UNDEFINED> instruction: 0x312f1401
    1714:	4c302f2f 	ldcmi	15, cr2, [r0], #-188	; 0xffffff44
    1718:	1f03322f 	svcne	0x0003322f
    171c:	2f2f2f66 	svccs	0x002f2f66
    1720:	2f2f2f2f 	svccs	0x002f2f2f
    1724:	01000202 	tsteq	r0, r2, lsl #4
    1728:	00005c01 	andeq	r5, r0, r1, lsl #24
    172c:	46000300 	strmi	r0, [r0], -r0, lsl #6
    1730:	02000000 	andeq	r0, r0, #0
    1734:	0d0efb01 	vstreq	d15, [lr, #-4]
    1738:	01010100 	mrseq	r0, (UNDEF: 17)
    173c:	00000001 	andeq	r0, r0, r1
    1740:	01000001 	tsteq	r0, r1
    1744:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1748:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    174c:	2f2e2e2f 	svccs	0x002e2e2f
    1750:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1754:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
    1758:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    175c:	6e6f632f 	cdpvs	3, 6, cr6, cr15, cr15, {1}
    1760:	2f676966 	svccs	0x00676966
    1764:	006d7261 	rsbeq	r7, sp, r1, ror #4
    1768:	62696c00 	rsbvs	r6, r9, #0, 24
    176c:	6e756631 	mrcvs	6, 3, r6, cr5, cr1, {1}
    1770:	532e7363 			; <UNDEFINED> instruction: 0x532e7363
    1774:	00000100 	andeq	r0, r0, r0, lsl #2
    1778:	02050000 	andeq	r0, r5, #0
    177c:	0000a610 	andeq	sl, r0, r0, lsl r6
    1780:	010bb903 	tsteq	fp, r3, lsl #18
    1784:	01000202 	tsteq	r0, r2, lsl #4
    1788:	0000a401 	andeq	sl, r0, r1, lsl #8
    178c:	9e000300 	cdpls	3, 0, cr0, cr0, cr0, {0}
    1790:	02000000 	andeq	r0, r0, #0
    1794:	0d0efb01 	vstreq	d15, [lr, #-4]
    1798:	01010100 	mrseq	r0, (UNDEF: 17)
    179c:	00000001 	andeq	r0, r0, r1
    17a0:	01000001 	tsteq	r0, r1
    17a4:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    17a8:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    17ac:	2f2e2e2f 	svccs	0x002e2e2f
    17b0:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    17b4:	6363672f 	cmnvs	r3, #12320768	; 0xbc0000
    17b8:	2f2e2e00 	svccs	0x002e2e00
    17bc:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    17c0:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    17c4:	2f2e2e2f 	svccs	0x002e2e2f
    17c8:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 1718 <CPSR_IRQ_INHIBIT+0x1698>
    17cc:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    17d0:	2e2e2f63 	cdpcs	15, 2, cr2, cr14, cr3, {3}
    17d4:	6363672f 	cmnvs	r3, #12320768	; 0xbc0000
    17d8:	6e6f632f 	cdpvs	3, 6, cr6, cr15, cr15, {1}
    17dc:	2f676966 	svccs	0x00676966
    17e0:	006d7261 	rsbeq	r7, sp, r1, ror #4
    17e4:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    17e8:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    17ec:	2f2e2e2f 	svccs	0x002e2e2f
    17f0:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    17f4:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
    17f8:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    17fc:	72610000 	rsbvc	r0, r1, #0
    1800:	73692d6d 	cmnvc	r9, #6976	; 0x1b40
    1804:	00682e61 	rsbeq	r2, r8, r1, ror #28
    1808:	61000001 	tstvs	r0, r1
    180c:	682e6d72 	stmdavs	lr!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}
    1810:	00000200 	andeq	r0, r0, r0, lsl #4
    1814:	2d6c6267 	sfmcs	f6, 2, [ip, #-412]!	; 0xfffffe64
    1818:	726f7463 	rsbvc	r7, pc, #1660944384	; 0x63000000
    181c:	00682e73 	rsbeq	r2, r8, r3, ror lr
    1820:	6c000003 	stcvs	0, cr0, [r0], {3}
    1824:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1828:	632e3263 			; <UNDEFINED> instruction: 0x632e3263
    182c:	00000300 	andeq	r0, r0, r0, lsl #6
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
      24:	6d2f0074 	stcvs	0, cr0, [pc, #-464]!	; fffffe5c <_bss_end+0xffff537c>
      28:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
      2c:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
      30:	4b2f7372 	blmi	bdce00 <_bss_end+0xbd2320>
      34:	2f616275 	svccs	0x00616275
      38:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
      3c:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
      40:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
      44:	614d6f72 	hvcvs	55026	; 0xd6f2
      48:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffadc <_bss_end+0xffff4ffc>
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
      78:	552f632f 	strpl	r6, [pc, #-815]!	; fffffd51 <_bss_end+0xffff5271>
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
      b8:	2b2b4320 	blcs	ad0d40 <_bss_end+0xac6260>
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
     134:	2b6b7a36 	blcs	1adea14 <_bss_end+0x1ad3f34>
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
     28c:	5a5f0053 	bpl	17c03e0 <_bss_end+0x17b5900>
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
     2c4:	5a5f0073 	bpl	17c0498 <_bss_end+0x17b59b8>
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
     524:	6a526a45 	bvs	149ae40 <_bss_end+0x1490360>
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
     5a8:	4b4c4344 	blmi	13112c0 <_bss_end+0x13067e0>
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
     788:	5a5f006a 	bpl	17c0938 <_bss_end+0x17b5e58>
     78c:	4333314e 	teqmi	r3, #-2147483629	; 0x80000013
     790:	4f495047 	svcmi	0x00495047
     794:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     798:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     79c:	6a453243 	bvs	114d0b0 <_bss_end+0x11425d0>
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
     7d8:	6a526a45 	bvs	149b0f4 <_bss_end+0x1490614>
     7dc:	005f3053 	subseq	r3, pc, r3, asr r0	; <UNPREDICTABLE>
     7e0:	314e5a5f 	cmpcc	lr, pc, asr sl
     7e4:	50474333 	subpl	r4, r7, r3, lsr r3
     7e8:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     7ec:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     7f0:	30317265 	eorscc	r7, r1, r5, ror #4
     7f4:	5f746553 	svcpl	0x00746553
     7f8:	7074754f 	rsbsvc	r7, r4, pc, asr #10
     7fc:	6a457475 	bvs	115d9d8 <_bss_end+0x1152ef8>
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
     884:	6a456e6f 	bvs	115c248 <_bss_end+0x1151768>
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
     8c0:	5a2f7374 	bpl	bdd698 <_bss_end+0xbd2bb8>
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
     9b8:	5a5f0078 	bpl	17c0ba0 <_bss_end+0x17b60c0>
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
     a10:	754f5f74 	strbvc	r5, [pc, #-3956]	; fffffaa4 <_bss_end+0xffff4fc4>
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
     a94:	5a5f0072 	bpl	17c0c64 <_bss_end+0x17b6184>
     a98:	4d43384e 	stclmi	8, cr3, [r3, #-312]	; 0xfffffec8
     a9c:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
     aa0:	3243726f 	subcc	r7, r3, #-268435450	; 0xf0000006
     aa4:	6a6a6a45 	bvs	1a9b3c0 <_bss_end+0x1a908e0>
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
     ad8:	6a644100 	bvs	1910ee0 <_bss_end+0x1906400>
     adc:	5f747375 	svcpl	0x00747375
     ae0:	73727543 	cmnvc	r2, #281018368	; 0x10c00000
     ae4:	4e00726f 	cdpmi	2, 0, cr7, cr0, cr15, {3}
     ae8:	626d754e 	rsbvs	r7, sp, #327155712	; 0x13800000
     aec:	425f7265 	subsmi	r7, pc, #1342177286	; 0x50000006
     af0:	00657361 	rsbeq	r7, r5, r1, ror #6
     af4:	736f5054 	cmnvc	pc, #84	; 0x54
     af8:	6f697469 	svcvs	0x00697469
     afc:	5a5f006e 	bpl	17c0cbc <_bss_end+0x17b61dc>
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
     be4:	5a5f0068 	bpl	17c0d8c <_bss_end+0x17b62ac>
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
     c34:	6b2f656d 	blvs	bda1f0 <_bss_end+0xbcf710>
     c38:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
     c3c:	72732f6c 	rsbsvc	r2, r3, #108, 30	; 0x1b0
     c40:	72642f63 	rsbvc	r2, r4, #396	; 0x18c
     c44:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
     c48:	6f6d2f73 	svcvs	0x006d2f73
     c4c:	6f74696e 	svcvs	0x0074696e
     c50:	70632e72 	rsbvc	r2, r3, r2, ror lr
     c54:	5a5f0070 	bpl	17c0e1c <_bss_end+0x17b633c>
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
     c80:	6a6a4534 	bvs	1a92158 <_bss_end+0x1a87678>
     c84:	5a5f006a 	bpl	17c0e34 <_bss_end+0x17b6354>
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
     dc0:	5a5f006a 	bpl	17c0f70 <_bss_end+0x17b6490>
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
     e84:	5a5f0063 	bpl	17c1018 <_bss_end+0x17b6538>
     e88:	5543354e 	strbpl	r3, [r3, #-1358]	; 0xfffffab2
     e8c:	43545241 	cmpmi	r4, #268435460	; 0x10000004
     e90:	34524534 	ldrbcc	r4, [r2], #-1332	; 0xfffffacc
     e94:	58554143 	ldmdapl	r5, {r0, r1, r6, r8, lr}^
     e98:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     e9c:	41554335 	cmpmi	r5, r5, lsr r3
     ea0:	57355452 			; <UNDEFINED> instruction: 0x57355452
     ea4:	65746972 	ldrbvs	r6, [r4, #-2418]!	; 0xfffff68e
     ea8:	5f006945 	svcpl	0x00006945
     eac:	43354e5a 	teqmi	r5, #1440	; 0x5a0
     eb0:	54524155 	ldrbpl	r4, [r2], #-341	; 0xfffffeab
     eb4:	69725735 	ldmdbvs	r2!, {r0, r2, r4, r5, r8, r9, sl, ip, lr}^
     eb8:	50456574 	subpl	r6, r5, r4, ror r5
     ebc:	5f00634b 	svcpl	0x0000634b
     ec0:	43354e5a 	teqmi	r5, #1440	; 0x5a0
     ec4:	54524155 	ldrbpl	r4, [r2], #-341	; 0xfffffeab
     ec8:	65533531 	ldrbvs	r3, [r3, #-1329]	; 0xfffffacf
     ecc:	68435f74 	stmdavs	r3, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     ed0:	4c5f7261 	lfmmi	f7, 2, [pc], {97}	; 0x61
     ed4:	74676e65 	strbtvc	r6, [r7], #-3685	; 0xfffff19b
     ed8:	37314568 	ldrcc	r4, [r1, -r8, ror #10]!
     edc:	5241554e 	subpl	r5, r1, #327155712	; 0x13800000
     ee0:	68435f54 	stmdavs	r3, {r2, r4, r6, r8, r9, sl, fp, ip, lr}^
     ee4:	4c5f7261 	lfmmi	f7, 2, [pc], {97}	; 0x61
     ee8:	74676e65 	strbtvc	r6, [r7], #-3685	; 0xfffff19b
     eec:	6e450068 	cdpvs	0, 4, cr0, cr5, cr8, {3}
     ef0:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     ef4:	6172545f 	cmnvs	r2, pc, asr r4
     ef8:	696d736e 	stmdbvs	sp!, {r1, r2, r3, r5, r6, r8, r9, ip, sp, lr}^
     efc:	6e495f74 	mcrvs	15, 2, r5, cr9, cr4, {3}
     f00:	52420074 	subpl	r0, r2, #116	; 0x74
     f04:	3036395f 	eorscc	r3, r6, pc, asr r9
     f08:	6d2f0030 	stcvs	0, cr0, [pc, #-192]!	; e50 <CPSR_IRQ_INHIBIT+0xdd0>
     f0c:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
     f10:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
     f14:	4b2f7372 	blmi	bddce4 <_bss_end+0xbd3204>
     f18:	2f616275 	svccs	0x00616275
     f1c:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
     f20:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
     f24:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
     f28:	614d6f72 	hvcvs	55026	; 0xd6f2
     f2c:	652f6574 	strvs	r6, [pc, #-1396]!	; 9c0 <CPSR_IRQ_INHIBIT+0x940>
     f30:	706d6178 	rsbvc	r6, sp, r8, ror r1
     f34:	2f73656c 	svccs	0x0073656c
     f38:	552d3032 	strpl	r3, [sp, #-50]!	; 0xffffffce
     f3c:	5f545241 	svcpl	0x00545241
     f40:	656d6167 	strbvs	r6, [sp, #-359]!	; 0xfffffe99
     f44:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
     f48:	2f6c656e 	svccs	0x006c656e
     f4c:	2f637273 	svccs	0x00637273
     f50:	76697264 	strbtvc	r7, [r9], -r4, ror #4
     f54:	2f737265 	svccs	0x00737265
     f58:	74726175 	ldrbtvc	r6, [r2], #-373	; 0xfffffe8b
     f5c:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
     f60:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     f64:	49433132 	stmdbmi	r3, {r1, r4, r5, r8, ip, sp}^
     f68:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
     f6c:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
     f70:	6e6f435f 	mcrvs	3, 3, r4, cr15, cr15, {2}
     f74:	6c6f7274 	sfmvs	f7, 2, [pc], #-464	; dac <CPSR_IRQ_INHIBIT+0xd2c>
     f78:	3172656c 	cmncc	r2, ip, ror #10
     f7c:	616e4530 	cmnvs	lr, r0, lsr r5
     f80:	5f656c62 	svcpl	0x00656c62
     f84:	45515249 	ldrbmi	r5, [r1, #-585]	; 0xfffffdb7
     f88:	6168334e 	cmnvs	r8, lr, asr #6
     f8c:	4930316c 	ldmdbmi	r0!, {r2, r3, r5, r6, r8, ip, sp}
     f90:	535f5152 	cmppl	pc, #-2147483628	; 0x80000014
     f94:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     f98:	69004565 	stmdbvs	r0, {r0, r2, r5, r6, r8, sl, lr}
     f9c:	625f7864 	subsvs	r7, pc, #100, 16	; 0x640000
     fa0:	00657361 	rsbeq	r7, r5, r1, ror #6
     fa4:	324e5a5f 	subcc	r5, lr, #389120	; 0x5f000
     fa8:	6e494331 	mcrvs	3, 2, r4, cr9, cr1, {1}
     fac:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
     fb0:	5f747075 	svcpl	0x00747075
     fb4:	746e6f43 	strbtvc	r6, [lr], #-3907	; 0xfffff0bd
     fb8:	6c6c6f72 	stclvs	15, cr6, [ip], #-456	; 0xfffffe38
     fbc:	52347265 	eorspl	r7, r4, #1342177286	; 0x50000006
     fc0:	45736765 	ldrbmi	r6, [r3, #-1893]!	; 0xfffff89b
     fc4:	6168334e 	cmnvs	r8, lr, asr #6
     fc8:	4934326c 	ldmdbmi	r4!, {r2, r3, r5, r6, r9, ip, sp}
     fcc:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
     fd0:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
     fd4:	6e6f435f 	mcrvs	3, 3, r4, cr15, cr15, {2}
     fd8:	6c6f7274 	sfmvs	f7, 2, [pc], #-464	; e10 <CPSR_IRQ_INHIBIT+0xd90>
     fdc:	5f72656c 	svcpl	0x0072656c
     fe0:	45676552 	strbmi	r6, [r7, #-1362]!	; 0xfffffaae
     fe4:	55504700 	ldrbpl	r4, [r0, #-1792]	; 0xfffff900
     fe8:	61485f31 	cmpvs	r8, r1, lsr pc
     fec:	4d00746c 	cfstrsmi	mvf7, [r0, #-432]	; 0xfffffe50
     ff0:	626c6961 	rsbvs	r6, ip, #1589248	; 0x184000
     ff4:	4500786f 	strmi	r7, [r0, #-2159]	; 0xfffff791
     ff8:	6c62616e 	stfvse	f6, [r2], #-440	; 0xfffffe48
     ffc:	52495f65 	subpl	r5, r9, #404	; 0x194
    1000:	475f0051 			; <UNDEFINED> instruction: 0x475f0051
    1004:	41424f4c 	cmpmi	r2, ip, asr #30
    1008:	735f5f4c 	cmpvc	pc, #76, 30	; 0x130
    100c:	495f6275 	ldmdbmi	pc, {r0, r2, r4, r5, r6, r9, sp, lr}^	; <UNPREDICTABLE>
    1010:	6d61675f 	stclvs	7, cr6, [r1, #-380]!	; 0xfffffe84
    1014:	74735f65 	ldrbtvc	r5, [r3], #-3941	; 0xfffff09b
    1018:	00657461 	rsbeq	r7, r5, r1, ror #8
    101c:	5f6e696d 	svcpl	0x006e696d
    1020:	006d756e 	rsbeq	r7, sp, lr, ror #10
    1024:	5f515249 	svcpl	0x00515249
    1028:	62616e45 	rsbvs	r6, r1, #1104	; 0x450
    102c:	315f656c 	cmpcc	pc, ip, ror #10
    1030:	51524900 	cmppl	r2, r0, lsl #18
    1034:	616e455f 	cmnvs	lr, pc, asr r5
    1038:	5f656c62 	svcpl	0x00656c62
    103c:	5a5f0032 	bpl	17c110c <_bss_end+0x17b662c>
    1040:	4331324e 	teqmi	r1, #-536870908	; 0xe0000004
    1044:	65746e49 	ldrbvs	r6, [r4, #-3657]!	; 0xfffff1b7
    1048:	70757272 	rsbsvc	r7, r5, r2, ror r2
    104c:	6f435f74 	svcvs	0x00435f74
    1050:	6f72746e 	svcvs	0x0072746e
    1054:	72656c6c 	rsbvc	r6, r5, #108, 24	; 0x6c00
    1058:	69443731 	stmdbvs	r4, {r0, r4, r5, r8, r9, sl, ip, sp}^
    105c:	6c626173 	stfvse	f6, [r2], #-460	; 0xfffffe34
    1060:	61425f65 	cmpvs	r2, r5, ror #30
    1064:	5f636973 	svcpl	0x00636973
    1068:	45515249 	ldrbmi	r5, [r1, #-585]	; 0xfffffdb7
    106c:	6168334e 	cmnvs	r8, lr, asr #6
    1070:	4936316c 	ldmdbmi	r6!, {r2, r3, r5, r6, r8, ip, sp}
    1074:	425f5152 	subsmi	r5, pc, #-2147483628	; 0x80000014
    1078:	63697361 	cmnvs	r9, #-2080374783	; 0x84000001
    107c:	756f535f 	strbvc	r5, [pc, #-863]!	; d25 <CPSR_IRQ_INHIBIT+0xca5>
    1080:	45656372 	strbmi	r6, [r5, #-882]!	; 0xfffffc8e
    1084:	746e4900 	strbtvc	r4, [lr], #-2304	; 0xfffff700
    1088:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
    108c:	435f7470 	cmpmi	pc, #112, 8	; 0x70000000
    1090:	72746e6f 	rsbsvc	r6, r4, #1776	; 0x6f0
    1094:	656c6c6f 	strbvs	r6, [ip, #-3183]!	; 0xfffff391
    1098:	65525f72 	ldrbvs	r5, [r2, #-3954]	; 0xfffff08e
    109c:	69440067 	stmdbvs	r4, {r0, r1, r2, r5, r6}^
    10a0:	6c626173 	stfvse	f6, [r2], #-460	; 0xfffffe34
    10a4:	52495f65 	subpl	r5, r9, #404	; 0x194
    10a8:	6c490051 	mcrrvs	0, 5, r0, r9, cr1
    10ac:	6167656c 	cmnvs	r7, ip, ror #10
    10b0:	63415f6c 	movtvs	r5, #8044	; 0x1f6c
    10b4:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    10b8:	4900315f 	stmdbmi	r0, {r0, r1, r2, r3, r4, r6, r8, ip, sp}
    10bc:	67656c6c 	strbvs	r6, [r5, -ip, ror #24]!
    10c0:	415f6c61 	cmpmi	pc, r1, ror #24
    10c4:	73656363 	cmnvc	r5, #-1946157055	; 0x8c000001
    10c8:	00325f73 	eorseq	r5, r2, r3, ror pc
    10cc:	5f515249 	svcpl	0x00515249
    10d0:	69736142 	ldmdbvs	r3!, {r1, r6, r8, sp, lr}^
    10d4:	6f535f63 	svcvs	0x00535f63
    10d8:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
    10dc:	65754700 	ldrbvs	r4, [r5, #-1792]!	; 0xfffff900
    10e0:	6e697373 	mcrvs	3, 3, r7, cr9, cr3, {3}
    10e4:	61475f67 	cmpvs	r7, r7, ror #30
    10e8:	5f00656d 	svcpl	0x0000656d
    10ec:	4733315a 			; <UNDEFINED> instruction: 0x4733315a
    10f0:	73736575 	cmnvc	r3, #490733568	; 0x1d400000
    10f4:	5f676e69 	svcpl	0x00676e69
    10f8:	656d6147 	strbvs	r6, [sp, #-327]!	; 0xfffffeb9
    10fc:	69540063 	ldmdbvs	r4, {r0, r1, r5, r6}^
    1100:	0072656d 	rsbseq	r6, r2, sp, ror #10
    1104:	324e5a5f 	subcc	r5, lr, #389120	; 0x5f000
    1108:	6e494331 	mcrvs	3, 2, r4, cr9, cr1, {1}
    110c:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
    1110:	5f747075 	svcpl	0x00747075
    1114:	746e6f43 	strbtvc	r6, [lr], #-3907	; 0xfffff0bd
    1118:	6c6c6f72 	stclvs	15, cr6, [ip], #-456	; 0xfffffe38
    111c:	31317265 	teqcc	r1, r5, ror #4
    1120:	61736944 	cmnvs	r3, r4, asr #18
    1124:	5f656c62 	svcpl	0x00656c62
    1128:	45515249 	ldrbmi	r5, [r1, #-585]	; 0xfffffdb7
    112c:	6168334e 	cmnvs	r8, lr, asr #6
    1130:	4930316c 	ldmdbmi	r0!, {r2, r3, r5, r6, r8, ip, sp}
    1134:	535f5152 	cmppl	pc, #-2147483628	; 0x80000014
    1138:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
    113c:	66004565 	strvs	r4, [r0], -r5, ror #10
    1140:	5f747361 	svcpl	0x00747361
    1144:	65746e69 	ldrbvs	r6, [r4, #-3689]!	; 0xfffff197
    1148:	70757272 	rsbsvc	r7, r5, r2, ror r2
    114c:	61685f74 	smcvs	34292	; 0x85f4
    1150:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
    1154:	52490072 	subpl	r0, r9, #114	; 0x72
    1158:	61425f51 	cmpvs	r2, r1, asr pc
    115c:	5f636973 	svcpl	0x00636973
    1160:	646e6550 	strbtvs	r6, [lr], #-1360	; 0xfffffab0
    1164:	00676e69 	rsbeq	r6, r7, r9, ror #28
    1168:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
    116c:	552f632f 	strpl	r6, [pc, #-815]!	; e45 <CPSR_IRQ_INHIBIT+0xdc5>
    1170:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
    1174:	62754b2f 	rsbsvs	r4, r5, #48128	; 0xbc00
    1178:	6f442f61 	svcvs	0x00442f61
    117c:	656d7563 	strbvs	r7, [sp, #-1379]!	; 0xfffffa9d
    1180:	2f73746e 	svccs	0x0073746e
    1184:	6f72655a 	svcvs	0x0072655a
    1188:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
    118c:	6178652f 	cmnvs	r8, pc, lsr #10
    1190:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
    1194:	30322f73 	eorscc	r2, r2, r3, ror pc
    1198:	5241552d 	subpl	r5, r1, #188743680	; 0xb400000
    119c:	61675f54 	cmnvs	r7, r4, asr pc
    11a0:	6b2f656d 	blvs	bda75c <_bss_end+0xbcfc7c>
    11a4:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
    11a8:	72732f6c 	rsbsvc	r2, r3, #108, 30	; 0x1b0
    11ac:	6e692f63 	cdpvs	15, 6, cr2, cr9, cr3, {3}
    11b0:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
    11b4:	5f747075 	svcpl	0x00747075
    11b8:	746e6f63 	strbtvc	r6, [lr], #-3939	; 0xfffff09d
    11bc:	6c6c6f72 	stclvs	15, cr6, [ip], #-456	; 0xfffffe38
    11c0:	632e7265 			; <UNDEFINED> instruction: 0x632e7265
    11c4:	43007070 	movwmi	r7, #112	; 0x70
    11c8:	65746e49 	ldrbvs	r6, [r4, #-3657]!	; 0xfffff1b7
    11cc:	70757272 	rsbsvc	r7, r5, r2, ror r2
    11d0:	6f435f74 	svcvs	0x00435f74
    11d4:	6f72746e 	svcvs	0x0072746e
    11d8:	72656c6c 	rsbvc	r6, r5, #108, 24	; 0x6c00
    11dc:	51524900 	cmppl	r2, r0, lsl #18
    11e0:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
    11e4:	445f6369 	ldrbmi	r6, [pc], #-873	; 11ec <CPSR_IRQ_INHIBIT+0x116c>
    11e8:	62617369 	rsbvs	r7, r1, #-1543503871	; 0xa4000001
    11ec:	4500656c 	strmi	r6, [r0, #-1388]	; 0xfffffa94
    11f0:	6c62616e 	stfvse	f6, [r2], #-440	; 0xfffffe48
    11f4:	61425f65 	cmpvs	r2, r5, ror #30
    11f8:	5f636973 	svcpl	0x00636973
    11fc:	00515249 	subseq	r5, r1, r9, asr #4
    1200:	30555047 	subscc	r5, r5, r7, asr #32
    1204:	6c61485f 	stclvs	8, cr4, [r1], #-380	; 0xfffffe84
    1208:	616d0074 	smcvs	53252	; 0xd004
    120c:	756e5f78 	strbvc	r5, [lr, #-3960]!	; 0xfffff088
    1210:	6f44006d 	svcvs	0x0044006d
    1214:	6562726f 	strbvs	r7, [r2, #-623]!	; 0xfffffd91
    1218:	305f6c6c 	subscc	r6, pc, ip, ror #24
    121c:	6f6f4400 	svcvs	0x006f4400
    1220:	6c656272 	sfmvs	f6, 2, [r5], #-456	; 0xfffffe38
    1224:	00315f6c 	eorseq	r5, r1, ip, ror #30
    1228:	746e4973 	strbtvc	r4, [lr], #-2419	; 0xfffff68d
    122c:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
    1230:	74437470 	strbvc	r7, [r3], #-1136	; 0xfffffb90
    1234:	5a5f006c 	bpl	17c13ec <_bss_end+0x17b690c>
    1238:	4331324e 	teqmi	r1, #-536870908	; 0xe0000004
    123c:	65746e49 	ldrbvs	r6, [r4, #-3657]!	; 0xfffff1b7
    1240:	70757272 	rsbsvc	r7, r5, r2, ror r2
    1244:	6f435f74 	svcvs	0x00435f74
    1248:	6f72746e 	svcvs	0x0072746e
    124c:	72656c6c 	rsbvc	r6, r5, #108, 24	; 0x6c00
    1250:	6d453243 	sfmvs	f3, 2, [r5, #-268]	; 0xfffffef4
    1254:	6e496d00 	cdpvs	13, 4, cr6, cr9, cr0, {0}
    1258:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
    125c:	5f747075 	svcpl	0x00747075
    1260:	73676552 	cmnvc	r7, #343932928	; 0x14800000
    1264:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
    1268:	49433132 	stmdbmi	r3, {r1, r4, r5, r8, ip, sp}^
    126c:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
    1270:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
    1274:	6e6f435f 	mcrvs	3, 3, r4, cr15, cr15, {2}
    1278:	6c6f7274 	sfmvs	f7, 2, [pc], #-464	; 10b0 <CPSR_IRQ_INHIBIT+0x1030>
    127c:	3172656c 	cmncc	r2, ip, ror #10
    1280:	616e4536 	cmnvs	lr, r6, lsr r5
    1284:	5f656c62 	svcpl	0x00656c62
    1288:	69736142 	ldmdbvs	r3!, {r1, r6, r8, sp, lr}^
    128c:	52495f63 	subpl	r5, r9, #396	; 0x18c
    1290:	334e4551 	movtcc	r4, #58705	; 0xe551
    1294:	316c6168 	cmncc	ip, r8, ror #2
    1298:	51524936 	cmppl	r2, r6, lsr r9
    129c:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
    12a0:	535f6369 	cmppl	pc, #-1543503871	; 0xa4000001
    12a4:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
    12a8:	5f004565 	svcpl	0x00004565
    12ac:	31324e5a 	teqcc	r2, sl, asr lr
    12b0:	746e4943 	strbtvc	r4, [lr], #-2371	; 0xfffff6bd
    12b4:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
    12b8:	435f7470 	cmpmi	pc, #112, 8	; 0x70000000
    12bc:	72746e6f 	rsbsvc	r6, r4, #1776	; 0x6f0
    12c0:	656c6c6f 	strbvs	r6, [ip, #-3183]!	; 0xfffff391
    12c4:	45344372 	ldrmi	r4, [r4, #-882]!	; 0xfffffc8e
    12c8:	7267006d 	rsbvc	r0, r7, #109	; 0x6d
    12cc:	65746165 	ldrbvs	r6, [r4, #-357]!	; 0xfffffe9b
    12d0:	32490072 	subcc	r0, r9, #114	; 0x72
    12d4:	50535f43 	subspl	r5, r3, r3, asr #30
    12d8:	4c535f49 	mrrcmi	15, 4, r5, r3, cr9
    12dc:	5f455641 	svcpl	0x00455641
    12e0:	54494e49 	strbpl	r4, [r9], #-3657	; 0xfffff1b7
    12e4:	51494600 	cmppl	r9, r0, lsl #12
    12e8:	6e6f435f 	mcrvs	3, 3, r4, cr15, cr15, {2}
    12ec:	6c6f7274 	sfmvs	f7, 2, [pc], #-464	; 1124 <CPSR_IRQ_INHIBIT+0x10a4>
    12f0:	71726900 	cmnvc	r2, r0, lsl #18
    12f4:	6e61685f 	mcrvs	8, 3, r6, cr1, cr15, {2}
    12f8:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
    12fc:	51524900 	cmppl	r2, r0, lsl #18
    1300:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
    1304:	455f6369 	ldrbmi	r6, [pc, #-873]	; fa3 <CPSR_IRQ_INHIBIT+0xf23>
    1308:	6c62616e 	stfvse	f6, [r2], #-440	; 0xfffffe48
    130c:	6f730065 	svcvs	0x00730065
    1310:	61777466 	cmnvs	r7, r6, ror #8
    1314:	695f6572 	ldmdbvs	pc, {r1, r4, r5, r6, r8, sl, sp, lr}^	; <UNPREDICTABLE>
    1318:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
    131c:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
    1320:	6e61685f 	mcrvs	8, 3, r6, cr1, cr15, {2}
    1324:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
    1328:	51524900 	cmppl	r2, r0, lsl #18
    132c:	6e65505f 	mcrvs	0, 3, r5, cr5, cr15, {2}
    1330:	676e6964 	strbvs	r6, [lr, -r4, ror #18]!
    1334:	4900315f 	stmdbmi	r0, {r0, r1, r2, r3, r4, r6, r8, ip, sp}
    1338:	505f5152 	subspl	r5, pc, r2, asr r1	; <UNPREDICTABLE>
    133c:	69646e65 	stmdbvs	r4!, {r0, r2, r5, r6, r9, sl, fp, sp, lr}^
    1340:	325f676e 	subscc	r6, pc, #28835840	; 0x1b80000
    1344:	51524900 	cmppl	r2, r0, lsl #18
    1348:	756f535f 	strbvc	r5, [pc, #-863]!	; ff1 <CPSR_IRQ_INHIBIT+0xf71>
    134c:	00656372 	rsbeq	r6, r5, r2, ror r3
    1350:	4f495047 	svcmi	0x00495047
    1354:	4700305f 	smlsdmi	r0, pc, r0, r3	; <UNPREDICTABLE>
    1358:	5f4f4950 	svcpl	0x004f4950
    135c:	50470031 	subpl	r0, r7, r1, lsr r0
    1360:	325f4f49 	subscc	r4, pc, #292	; 0x124
    1364:	49504700 	ldmdbmi	r0, {r8, r9, sl, lr}^
    1368:	00335f4f 	eorseq	r5, r3, pc, asr #30
    136c:	61736944 	cmnvs	r3, r4, asr #18
    1370:	5f656c62 	svcpl	0x00656c62
    1374:	69736142 	ldmdbvs	r3!, {r1, r6, r8, sp, lr}^
    1378:	52495f63 	subpl	r5, r9, #396	; 0x18c
    137c:	696d0051 	stmdbvs	sp!, {r0, r4, r6}^
    1380:	656c6464 	strbvs	r6, [ip, #-1124]!	; 0xfffffb9c
    1384:	756f7300 	strbvc	r7, [pc, #-768]!	; 108c <CPSR_IRQ_INHIBIT+0x100c>
    1388:	5f656372 	svcpl	0x00656372
    138c:	00786469 	rsbseq	r6, r8, r9, ror #8
    1390:	5f515249 	svcpl	0x00515249
    1394:	61736944 	cmnvs	r3, r4, asr #18
    1398:	5f656c62 	svcpl	0x00656c62
    139c:	52490031 	subpl	r0, r9, #49	; 0x31
    13a0:	69445f51 	stmdbvs	r4, {r0, r4, r6, r8, r9, sl, fp, ip, lr}^
    13a4:	6c626173 	stfvse	f6, [r2], #-460	; 0xfffffe34
    13a8:	00325f65 	eorseq	r5, r2, r5, ror #30
    13ac:	5f415750 	svcpl	0x00415750
    13b0:	57500030 	smmlarpl	r0, r0, r0, r0
    13b4:	00315f41 	eorseq	r5, r1, r1, asr #30
    13b8:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
    13bc:	552f632f 	strpl	r6, [pc, #-815]!	; 1095 <CPSR_IRQ_INHIBIT+0x1015>
    13c0:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
    13c4:	62754b2f 	rsbsvs	r4, r5, #48128	; 0xbc00
    13c8:	6f442f61 	svcvs	0x00442f61
    13cc:	656d7563 	strbvs	r7, [sp, #-1379]!	; 0xfffffa9d
    13d0:	2f73746e 	svccs	0x0073746e
    13d4:	6f72655a 	svcvs	0x0072655a
    13d8:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
    13dc:	6178652f 	cmnvs	r8, pc, lsr #10
    13e0:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
    13e4:	30322f73 	eorscc	r2, r2, r3, ror pc
    13e8:	5241552d 	subpl	r5, r1, #188743680	; 0xb400000
    13ec:	61675f54 	cmnvs	r7, r4, asr pc
    13f0:	6b2f656d 	blvs	bda9ac <_bss_end+0xbcfecc>
    13f4:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
    13f8:	72732f6c 	rsbsvc	r2, r3, #108, 30	; 0x1b0
    13fc:	616d2f63 	cmnvs	sp, r3, ror #30
    1400:	632e6e69 			; <UNDEFINED> instruction: 0x632e6e69
    1404:	5f007070 	svcpl	0x00007070
    1408:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
    140c:	6d5f6c65 	ldclvs	12, cr6, [pc, #-404]	; 1280 <CPSR_IRQ_INHIBIT+0x1200>
    1410:	006e6961 	rsbeq	r6, lr, r1, ror #18
    1414:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
    1418:	552f632f 	strpl	r6, [pc, #-815]!	; 10f1 <CPSR_IRQ_INHIBIT+0x1071>
    141c:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
    1420:	62754b2f 	rsbsvs	r4, r5, #48128	; 0xbc00
    1424:	6f442f61 	svcvs	0x00442f61
    1428:	656d7563 	strbvs	r7, [sp, #-1379]!	; 0xfffffa9d
    142c:	2f73746e 	svccs	0x0073746e
    1430:	6f72655a 	svcvs	0x0072655a
    1434:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
    1438:	6178652f 	cmnvs	r8, pc, lsr #10
    143c:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
    1440:	30322f73 	eorscc	r2, r2, r3, ror pc
    1444:	5241552d 	subpl	r5, r1, #188743680	; 0xb400000
    1448:	61675f54 	cmnvs	r7, r4, asr pc
    144c:	6b2f656d 	blvs	bdaa08 <_bss_end+0xbcff28>
    1450:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
    1454:	72732f6c 	rsbsvc	r2, r3, #108, 30	; 0x1b0
    1458:	74732f63 	ldrbtvc	r2, [r3], #-3939	; 0xfffff09d
    145c:	2e747261 	cdpcs	2, 7, cr7, cr4, cr1, {3}
    1460:	4e470073 	mcrmi	0, 2, r0, cr7, cr3, {3}
    1464:	53412055 	movtpl	r2, #4181	; 0x1055
    1468:	332e3220 			; <UNDEFINED> instruction: 0x332e3220
    146c:	6d2f0038 	stcvs	0, cr0, [pc, #-224]!	; 1394 <CPSR_IRQ_INHIBIT+0x1314>
    1470:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
    1474:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
    1478:	4b2f7372 	blmi	bde248 <_bss_end+0xbd3768>
    147c:	2f616275 	svccs	0x00616275
    1480:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
    1484:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
    1488:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
    148c:	614d6f72 	hvcvs	55026	; 0xd6f2
    1490:	652f6574 	strvs	r6, [pc, #-1396]!	; f24 <CPSR_IRQ_INHIBIT+0xea4>
    1494:	706d6178 	rsbvc	r6, sp, r8, ror r1
    1498:	2f73656c 	svccs	0x0073656c
    149c:	552d3032 	strpl	r3, [sp, #-50]!	; 0xffffffce
    14a0:	5f545241 	svcpl	0x00545241
    14a4:	656d6167 	strbvs	r6, [sp, #-359]!	; 0xfffffe99
    14a8:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
    14ac:	2f6c656e 	svccs	0x006c656e
    14b0:	2f637273 	svccs	0x00637273
    14b4:	72617473 	rsbvc	r7, r1, #1929379840	; 0x73000000
    14b8:	2e707574 	mrccs	5, 3, r7, cr0, cr4, {3}
    14bc:	00707063 	rsbseq	r7, r0, r3, rrx
    14c0:	7373625f 	cmnvc	r3, #-268435451	; 0xf0000005
    14c4:	6174735f 	cmnvs	r4, pc, asr r3
    14c8:	5f007472 	svcpl	0x00007472
    14cc:	4f54435f 	svcmi	0x0054435f
    14d0:	4e455f52 	mcrmi	15, 2, r5, cr5, cr2, {2}
    14d4:	005f5f44 	subseq	r5, pc, r4, asr #30
    14d8:	54445f5f 	strbpl	r5, [r4], #-3935	; 0xfffff0a1
    14dc:	455f524f 	ldrbmi	r5, [pc, #-591]	; 1295 <CPSR_IRQ_INHIBIT+0x1215>
    14e0:	5f5f444e 	svcpl	0x005f444e
    14e4:	70635f00 	rsbvc	r5, r3, r0, lsl #30
    14e8:	68735f70 	ldmdavs	r3!, {r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    14ec:	6f647475 	svcvs	0x00647475
    14f0:	5f006e77 	svcpl	0x00006e77
    14f4:	5f737362 	svcpl	0x00737362
    14f8:	00646e65 	rsbeq	r6, r4, r5, ror #28
    14fc:	54445f5f 	strbpl	r5, [r4], #-3935	; 0xfffff0a1
    1500:	4c5f524f 	lfmmi	f5, 2, [pc], {79}	; 0x4f
    1504:	5f545349 	svcpl	0x00545349
    1508:	7464005f 	strbtvc	r0, [r4], #-95	; 0xffffffa1
    150c:	705f726f 	subsvc	r7, pc, pc, ror #4
    1510:	63007274 	movwvs	r7, #628	; 0x274
    1514:	5f726f74 	svcpl	0x00726f74
    1518:	00727470 	rsbseq	r7, r2, r0, ror r4
    151c:	54435f5f 	strbpl	r5, [r3], #-3935	; 0xfffff0a1
    1520:	4c5f524f 	lfmmi	f5, 2, [pc], {79}	; 0x4f
    1524:	5f545349 	svcpl	0x00545349
    1528:	635f005f 	cmpvs	pc, #95	; 0x5f
    152c:	6174735f 	cmnvs	r4, pc, asr r3
    1530:	70757472 	rsbsvc	r7, r5, r2, ror r4
    1534:	70635f00 	rsbvc	r5, r3, r0, lsl #30
    1538:	74735f70 	ldrbtvc	r5, [r3], #-3952	; 0xfffff090
    153c:	75747261 	ldrbvc	r7, [r4, #-609]!	; 0xfffffd9f
    1540:	6e660070 	mcrvs	0, 3, r0, cr6, cr0, {3}
    1544:	00727470 	rsbseq	r7, r2, r0, ror r4
    1548:	646d656d 	strbtvs	r6, [sp], #-1389	; 0xfffffa93
    154c:	64007473 	strvs	r7, [r0], #-1139	; 0xfffffb8d
    1550:	00747365 	rsbseq	r7, r4, r5, ror #6
    1554:	72657a62 	rsbvc	r7, r5, #401408	; 0x62000
    1558:	656c006f 	strbvs	r0, [ip, #-111]!	; 0xffffff91
    155c:	6874676e 	ldmdavs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}^
    1560:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
    1564:	72657a62 	rsbvc	r7, r5, #401408	; 0x62000
    1568:	6976506f 	ldmdbvs	r6!, {r0, r1, r2, r3, r5, r6, ip, lr}^
    156c:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
    1570:	696f7461 	stmdbvs	pc!, {r0, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    1574:	00634b50 	rsbeq	r4, r3, r0, asr fp
    1578:	6d365a5f 	vldmdbvs	r6!, {s10-s104}
    157c:	70636d65 	rsbvc	r6, r3, r5, ror #26
    1580:	764b5079 			; <UNDEFINED> instruction: 0x764b5079
    1584:	00697650 	rsbeq	r7, r9, r0, asr r6
    1588:	636d656d 	cmnvs	sp, #457179136	; 0x1b400000
    158c:	2f007970 	svccs	0x00007970
    1590:	2f746e6d 	svccs	0x00746e6d
    1594:	73552f63 	cmpvc	r5, #396	; 0x18c
    1598:	2f737265 	svccs	0x00737265
    159c:	6162754b 	cmnvs	r2, fp, asr #10
    15a0:	636f442f 	cmnvs	pc, #788529152	; 0x2f000000
    15a4:	6e656d75 	mcrvs	13, 3, r6, cr5, cr5, {3}
    15a8:	5a2f7374 	bpl	bde380 <_bss_end+0xbd38a0>
    15ac:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 1420 <CPSR_IRQ_INHIBIT+0x13a0>
    15b0:	2f657461 	svccs	0x00657461
    15b4:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
    15b8:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
    15bc:	2d30322f 	lfmcs	f3, 4, [r0, #-188]!	; 0xffffff44
    15c0:	54524155 	ldrbpl	r4, [r2], #-341	; 0xfffffeab
    15c4:	6d61675f 	stclvs	7, cr6, [r1, #-380]!	; 0xfffffe84
    15c8:	74732f65 	ldrbtvc	r2, [r3], #-3941	; 0xfffff09b
    15cc:	62696c64 	rsbvs	r6, r9, #100, 24	; 0x6400
    15d0:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
    15d4:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
    15d8:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
    15dc:	632e676e 			; <UNDEFINED> instruction: 0x632e676e
    15e0:	73007070 	movwvc	r7, #112	; 0x70
    15e4:	656c7274 	strbvs	r7, [ip, #-628]!	; 0xfffffd8c
    15e8:	5a5f006e 	bpl	17c17a8 <_bss_end+0x17b6cc8>
    15ec:	72747337 	rsbsvc	r7, r4, #-603979776	; 0xdc000000
    15f0:	706d636e 	rsbvc	r6, sp, lr, ror #6
    15f4:	53634b50 	cmnpl	r3, #80, 22	; 0x14000
    15f8:	00695f30 	rsbeq	r5, r9, r0, lsr pc
    15fc:	73365a5f 	teqvc	r6, #389120	; 0x5f000
    1600:	656c7274 	strbvs	r7, [ip, #-628]!	; 0xfffffd8c
    1604:	634b506e 	movtvs	r5, #45166	; 0xb06e
    1608:	6f746100 	svcvs	0x00746100
    160c:	5a5f0069 	bpl	17c17b8 <_bss_end+0x17b6cd8>
    1610:	72747337 	rsbsvc	r7, r4, #-603979776	; 0xdc000000
    1614:	7970636e 	ldmdbvc	r0!, {r1, r2, r3, r5, r6, r8, r9, sp, lr}^
    1618:	4b506350 	blmi	141a360 <_bss_end+0x140f880>
    161c:	73006963 	movwvc	r6, #2403	; 0x963
    1620:	636e7274 	cmnvs	lr, #116, 4	; 0x40000007
    1624:	7300706d 	movwvc	r7, #109	; 0x6d
    1628:	636e7274 	cmnvs	lr, #116, 4	; 0x40000007
    162c:	6d007970 	vstrvs.16	s14, [r0, #-224]	; 0xffffff20	; <UNPREDICTABLE>
    1630:	726f6d65 	rsbvc	r6, pc, #6464	; 0x1940
    1634:	656d0079 	strbvs	r0, [sp, #-121]!	; 0xffffff87
    1638:	6372736d 	cmnvs	r2, #-1275068415	; 0xb4000001
    163c:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
    1640:	616f7469 	cmnvs	pc, r9, ror #8
    1644:	6a63506a 	bvs	18d57f4 <_bss_end+0x18cad14>
    1648:	2f2e2e00 	svccs	0x002e2e00
    164c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1650:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1654:	2f2e2e2f 	svccs	0x002e2e2f
    1658:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 15a8 <CPSR_IRQ_INHIBIT+0x1528>
    165c:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1660:	6f632f63 	svcvs	0x00632f63
    1664:	6769666e 	strbvs	r6, [r9, -lr, ror #12]!
    1668:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
    166c:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    1670:	6e756631 	mrcvs	6, 3, r6, cr5, cr1, {1}
    1674:	532e7363 			; <UNDEFINED> instruction: 0x532e7363
    1678:	75622f00 	strbvc	r2, [r2, #-3840]!	; 0xfffff100
    167c:	2f646c69 	svccs	0x00646c69
    1680:	2d636367 	stclcs	3, cr6, [r3, #-412]!	; 0xfffffe64
    1684:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
    1688:	656e6f6e 	strbvs	r6, [lr, #-3950]!	; 0xfffff092
    168c:	6261652d 	rsbvs	r6, r1, #188743680	; 0xb400000
    1690:	59682d69 	stmdbpl	r8!, {r0, r3, r5, r6, r8, sl, fp, sp}^
    1694:	344b6766 	strbcc	r6, [fp], #-1894	; 0xfffff89a
    1698:	6363672f 	cmnvs	r3, #12320768	; 0xbc0000
    169c:	6d72612d 	ldfvse	f6, [r2, #-180]!	; 0xffffff4c
    16a0:	6e6f6e2d 	cdpvs	14, 6, cr6, cr15, cr13, {1}
    16a4:	61652d65 	cmnvs	r5, r5, ror #26
    16a8:	312d6962 			; <UNDEFINED> instruction: 0x312d6962
    16ac:	2d332e30 	ldccs	14, cr2, [r3, #-192]!	; 0xffffff40
    16b0:	31323032 	teqcc	r2, r2, lsr r0
    16b4:	2f37302e 	svccs	0x0037302e
    16b8:	6c697562 	cfstr64vs	mvdx7, [r9], #-392	; 0xfffffe78
    16bc:	72612f64 	rsbvc	r2, r1, #100, 30	; 0x190
    16c0:	6f6e2d6d 	svcvs	0x006e2d6d
    16c4:	652d656e 	strvs	r6, [sp, #-1390]!	; 0xfffffa92
    16c8:	2f696261 	svccs	0x00696261
    16cc:	2f6d7261 	svccs	0x006d7261
    16d0:	65743576 	ldrbvs	r3, [r4, #-1398]!	; 0xfffffa8a
    16d4:	7261682f 	rsbvc	r6, r1, #3080192	; 0x2f0000
    16d8:	696c2f64 	stmdbvs	ip!, {r2, r5, r6, r8, r9, sl, fp, sp}^
    16dc:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    16e0:	554e4700 	strbpl	r4, [lr, #-1792]	; 0xfffff900
    16e4:	20534120 	subscs	r4, r3, r0, lsr #2
    16e8:	37332e32 			; <UNDEFINED> instruction: 0x37332e32
    16ec:	61736900 	cmnvs	r3, r0, lsl #18
    16f0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    16f4:	6572705f 	ldrbvs	r7, [r2, #-95]!	; 0xffffffa1
    16f8:	73657264 	cmnvc	r5, #100, 4	; 0x40000006
    16fc:	61736900 	cmnvs	r3, r0, lsl #18
    1700:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1704:	7066765f 	rsbvc	r7, r6, pc, asr r6
    1708:	7361625f 	cmnvc	r1, #-268435451	; 0xf0000005
    170c:	6f630065 	svcvs	0x00630065
    1710:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
    1714:	6c662078 	stclvs	0, cr2, [r6], #-480	; 0xfffffe20
    1718:	0074616f 	rsbseq	r6, r4, pc, ror #2
    171c:	5f617369 	svcpl	0x00617369
    1720:	69626f6e 	stmdbvs	r2!, {r1, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
    1724:	73690074 	cmnvc	r9, #116	; 0x74
    1728:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    172c:	766d5f74 	uqsub16vc	r5, sp, r4
    1730:	6c665f65 	stclvs	15, cr5, [r6], #-404	; 0xfffffe6c
    1734:	0074616f 	rsbseq	r6, r4, pc, ror #2
    1738:	5f617369 	svcpl	0x00617369
    173c:	5f746962 	svcpl	0x00746962
    1740:	36317066 	ldrtcc	r7, [r1], -r6, rrx
    1744:	61736900 	cmnvs	r3, r0, lsl #18
    1748:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    174c:	6365735f 	cmnvs	r5, #2080374785	; 0x7c000001
    1750:	61736900 	cmnvs	r3, r0, lsl #18
    1754:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1758:	6964615f 	stmdbvs	r4!, {r0, r1, r2, r3, r4, r6, r8, sp, lr}^
    175c:	73690076 	cmnvc	r9, #118	; 0x76
    1760:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1764:	75715f74 	ldrbvc	r5, [r1, #-3956]!	; 0xfffff08c
    1768:	5f6b7269 	svcpl	0x006b7269
    176c:	765f6f6e 	ldrbvc	r6, [pc], -lr, ror #30
    1770:	74616c6f 	strbtvc	r6, [r1], #-3183	; 0xfffff391
    1774:	5f656c69 	svcpl	0x00656c69
    1778:	69006563 	stmdbvs	r0, {r0, r1, r5, r6, r8, sl, sp, lr}
    177c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1780:	6d5f7469 	cfldrdvs	mvd7, [pc, #-420]	; 15e4 <CPSR_IRQ_INHIBIT+0x1564>
    1784:	73690070 	cmnvc	r9, #112	; 0x70
    1788:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    178c:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1790:	7435766d 	ldrtvc	r7, [r5], #-1645	; 0xfffff993
    1794:	61736900 	cmnvs	r3, r0, lsl #18
    1798:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    179c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    17a0:	65743576 	ldrbvs	r3, [r4, #-1398]!	; 0xfffffa8a
    17a4:	61736900 	cmnvs	r3, r0, lsl #18
    17a8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    17ac:	6f656e5f 	svcvs	0x00656e5f
    17b0:	7369006e 	cmnvc	r9, #110	; 0x6e
    17b4:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    17b8:	66625f74 	uqsub16vs	r5, r2, r4
    17bc:	46003631 			; <UNDEFINED> instruction: 0x46003631
    17c0:	52435350 	subpl	r5, r3, #80, 6	; 0x40000001
    17c4:	554e455f 	strbpl	r4, [lr, #-1375]	; 0xfffffaa1
    17c8:	5046004d 	subpl	r0, r6, sp, asr #32
    17cc:	5f524353 	svcpl	0x00524353
    17d0:	76637a6e 	strbtvc	r7, [r3], -lr, ror #20
    17d4:	455f6371 	ldrbmi	r6, [pc, #-881]	; 146b <CPSR_IRQ_INHIBIT+0x13eb>
    17d8:	004d554e 	subeq	r5, sp, lr, asr #10
    17dc:	5f525056 	svcpl	0x00525056
    17e0:	4d554e45 	ldclmi	14, cr4, [r5, #-276]	; 0xfffffeec
    17e4:	69626600 	stmdbvs	r2!, {r9, sl, sp, lr}^
    17e8:	6d695f74 	stclvs	15, cr5, [r9, #-464]!	; 0xfffffe30
    17ec:	63696c70 	cmnvs	r9, #112, 24	; 0x7000
    17f0:	6f697461 	svcvs	0x00697461
    17f4:	3050006e 	subscc	r0, r0, lr, rrx
    17f8:	554e455f 	strbpl	r4, [lr, #-1375]	; 0xfffffaa1
    17fc:	7369004d 	cmnvc	r9, #77	; 0x4d
    1800:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1804:	72635f74 	rsbvc	r5, r3, #116, 30	; 0x1d0
    1808:	6f747079 	svcvs	0x00747079
    180c:	554e4700 	strbpl	r4, [lr, #-1792]	; 0xfffff900
    1810:	37314320 	ldrcc	r4, [r1, -r0, lsr #6]!
    1814:	2e303120 	rsfcssp	f3, f0, f0
    1818:	20312e33 	eorscs	r2, r1, r3, lsr lr
    181c:	31323032 	teqcc	r2, r2, lsr r0
    1820:	31323630 	teqcc	r2, r0, lsr r6
    1824:	65722820 	ldrbvs	r2, [r2, #-2080]!	; 0xfffff7e0
    1828:	7361656c 	cmnvc	r1, #108, 10	; 0x1b000000
    182c:	2d202965 			; <UNDEFINED> instruction: 0x2d202965
    1830:	6d72616d 	ldfvse	f6, [r2, #-436]!	; 0xfffffe4c
    1834:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
    1838:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
    183c:	6962612d 	stmdbvs	r2!, {r0, r2, r3, r5, r8, sp, lr}^
    1840:	7261683d 	rsbvc	r6, r1, #3997696	; 0x3d0000
    1844:	6d2d2064 	stcvs	0, cr2, [sp, #-400]!	; 0xfffffe70
    1848:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    184c:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
    1850:	65743576 	ldrbvs	r3, [r4, #-1398]!	; 0xfffffa8a
    1854:	2070662b 	rsbscs	r6, r0, fp, lsr #12
    1858:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
    185c:	672d2067 	strvs	r2, [sp, -r7, rrx]!
    1860:	324f2d20 	subcc	r2, pc, #32, 26	; 0x800
    1864:	324f2d20 	subcc	r2, pc, #32, 26	; 0x800
    1868:	324f2d20 	subcc	r2, pc, #32, 26	; 0x800
    186c:	62662d20 	rsbvs	r2, r6, #32, 26	; 0x800
    1870:	646c6975 	strbtvs	r6, [ip], #-2421	; 0xfffff68b
    1874:	2d676e69 	stclcs	14, cr6, [r7, #-420]!	; 0xfffffe5c
    1878:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    187c:	2d206363 	stccs	3, cr6, [r0, #-396]!	; 0xfffffe74
    1880:	2d6f6e66 	stclcs	14, cr6, [pc, #-408]!	; 16f0 <CPSR_IRQ_INHIBIT+0x1670>
    1884:	63617473 	cmnvs	r1, #1929379840	; 0x73000000
    1888:	72702d6b 	rsbsvc	r2, r0, #6848	; 0x1ac0
    188c:	6365746f 	cmnvs	r5, #1862270976	; 0x6f000000
    1890:	20726f74 	rsbscs	r6, r2, r4, ror pc
    1894:	6f6e662d 	svcvs	0x006e662d
    1898:	6c6e692d 			; <UNDEFINED> instruction: 0x6c6e692d
    189c:	20656e69 	rsbcs	r6, r5, r9, ror #28
    18a0:	6976662d 	ldmdbvs	r6!, {r0, r2, r3, r5, r9, sl, sp, lr}^
    18a4:	69626973 	stmdbvs	r2!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
    18a8:	7974696c 	ldmdbvc	r4!, {r2, r3, r5, r6, r8, fp, sp, lr}^
    18ac:	6469683d 	strbtvs	r6, [r9], #-2109	; 0xfffff7c3
    18b0:	006e6564 	rsbeq	r6, lr, r4, ror #10
    18b4:	5f617369 	svcpl	0x00617369
    18b8:	5f746962 	svcpl	0x00746962
    18bc:	76696474 			; <UNDEFINED> instruction: 0x76696474
    18c0:	6e6f6300 	cdpvs	3, 6, cr6, cr15, cr0, {0}
    18c4:	73690073 	cmnvc	r9, #115	; 0x73
    18c8:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    18cc:	77695f74 			; <UNDEFINED> instruction: 0x77695f74
    18d0:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
    18d4:	43504600 	cmpmi	r0, #0, 12
    18d8:	5f535458 	svcpl	0x00535458
    18dc:	4d554e45 	ldclmi	14, cr4, [r5, #-276]	; 0xfffffeec
    18e0:	61736900 	cmnvs	r3, r0, lsl #18
    18e4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    18e8:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    18ec:	69003676 	stmdbvs	r0, {r1, r2, r4, r5, r6, r9, sl, ip, sp}
    18f0:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    18f4:	6d5f7469 	cfldrdvs	mvd7, [pc, #-420]	; 1758 <CPSR_IRQ_INHIBIT+0x16d8>
    18f8:	69006576 	stmdbvs	r0, {r1, r2, r4, r5, r6, r8, sl, sp, lr}
    18fc:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1900:	695f7469 	ldmdbvs	pc, {r0, r3, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    1904:	786d6d77 	stmdavc	sp!, {r0, r1, r2, r4, r5, r6, r8, sl, fp, sp, lr}^
    1908:	69003274 	stmdbvs	r0, {r2, r4, r5, r6, r9, ip, sp}
    190c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1910:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    1914:	70636564 	rsbvc	r6, r3, r4, ror #10
    1918:	73690030 	cmnvc	r9, #48	; 0x30
    191c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1920:	64635f74 	strbtvs	r5, [r3], #-3956	; 0xfffff08c
    1924:	31706365 	cmncc	r0, r5, ror #6
    1928:	61736900 	cmnvs	r3, r0, lsl #18
    192c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1930:	6564635f 	strbvs	r6, [r4, #-863]!	; 0xfffffca1
    1934:	00327063 	eorseq	r7, r2, r3, rrx
    1938:	5f617369 	svcpl	0x00617369
    193c:	5f746962 	svcpl	0x00746962
    1940:	63656463 	cmnvs	r5, #1660944384	; 0x63000000
    1944:	69003370 	stmdbvs	r0, {r4, r5, r6, r8, r9, ip, sp}
    1948:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    194c:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    1950:	70636564 	rsbvc	r6, r3, r4, ror #10
    1954:	73690034 	cmnvc	r9, #52	; 0x34
    1958:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    195c:	70665f74 	rsbvc	r5, r6, r4, ror pc
    1960:	6c62645f 	cfstrdvs	mvd6, [r2], #-380	; 0xfffffe84
    1964:	61736900 	cmnvs	r3, r0, lsl #18
    1968:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    196c:	6564635f 	strbvs	r6, [r4, #-863]!	; 0xfffffca1
    1970:	00367063 	eorseq	r7, r6, r3, rrx
    1974:	5f617369 	svcpl	0x00617369
    1978:	5f746962 	svcpl	0x00746962
    197c:	63656463 	cmnvs	r5, #1660944384	; 0x63000000
    1980:	69003770 	stmdbvs	r0, {r4, r5, r6, r8, r9, sl, ip, sp}
    1984:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1988:	615f7469 	cmpvs	pc, r9, ror #8
    198c:	36766d72 			; <UNDEFINED> instruction: 0x36766d72
    1990:	7369006b 	cmnvc	r9, #107	; 0x6b
    1994:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1998:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    199c:	5f38766d 	svcpl	0x0038766d
    19a0:	6d5f6d31 	ldclvs	13, cr6, [pc, #-196]	; 18e4 <CPSR_IRQ_INHIBIT+0x1864>
    19a4:	006e6961 	rsbeq	r6, lr, r1, ror #18
    19a8:	65746e61 	ldrbvs	r6, [r4, #-3681]!	; 0xfffff19f
    19ac:	61736900 	cmnvs	r3, r0, lsl #18
    19b0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    19b4:	736d635f 	cmnvc	sp, #2080374785	; 0x7c000001
    19b8:	6f6c0065 	svcvs	0x006c0065
    19bc:	6420676e 	strtvs	r6, [r0], #-1902	; 0xfffff892
    19c0:	6c62756f 	cfstr64vs	mvdx7, [r2], #-444	; 0xfffffe44
    19c4:	2e2e0065 	cdpcs	0, 2, cr0, cr14, cr5, {3}
    19c8:	2f2e2e2f 	svccs	0x002e2e2f
    19cc:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    19d0:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    19d4:	2f2e2e2f 	svccs	0x002e2e2f
    19d8:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    19dc:	6c2f6363 	stcvs	3, cr6, [pc], #-396	; 1858 <CPSR_IRQ_INHIBIT+0x17d8>
    19e0:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    19e4:	632e3263 			; <UNDEFINED> instruction: 0x632e3263
    19e8:	61736900 	cmnvs	r3, r0, lsl #18
    19ec:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    19f0:	7670665f 			; <UNDEFINED> instruction: 0x7670665f
    19f4:	73690035 	cmnvc	r9, #53	; 0x35
    19f8:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    19fc:	73785f74 	cmnvc	r8, #116, 30	; 0x1d0
    1a00:	656c6163 	strbvs	r6, [ip, #-355]!	; 0xfffffe9d
    1a04:	6e6f6c00 	cdpvs	12, 6, cr6, cr15, cr0, {0}
    1a08:	6f6c2067 	svcvs	0x006c2067
    1a0c:	7520676e 	strvc	r6, [r0, #-1902]!	; 0xfffff892
    1a10:	6769736e 	strbvs	r7, [r9, -lr, ror #6]!
    1a14:	2064656e 	rsbcs	r6, r4, lr, ror #10
    1a18:	00746e69 	rsbseq	r6, r4, r9, ror #28
    1a1c:	5f617369 	svcpl	0x00617369
    1a20:	5f746962 	svcpl	0x00746962
    1a24:	72697571 	rsbvc	r7, r9, #473956352	; 0x1c400000
    1a28:	6d635f6b 	stclvs	15, cr5, [r3, #-428]!	; 0xfffffe54
    1a2c:	646c5f33 	strbtvs	r5, [ip], #-3891	; 0xfffff0cd
    1a30:	69006472 	stmdbvs	r0, {r1, r4, r5, r6, sl, sp, lr}
    1a34:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1a38:	695f7469 	ldmdbvs	pc, {r0, r3, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    1a3c:	006d6d38 	rsbeq	r6, sp, r8, lsr sp
    1a40:	5f617369 	svcpl	0x00617369
    1a44:	5f746962 	svcpl	0x00746962
    1a48:	645f7066 	ldrbvs	r7, [pc], #-102	; 1a50 <CPSR_IRQ_INHIBIT+0x19d0>
    1a4c:	69003233 	stmdbvs	r0, {r0, r1, r4, r5, r9, ip, sp}
    1a50:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1a54:	615f7469 	cmpvs	pc, r9, ror #8
    1a58:	37766d72 			; <UNDEFINED> instruction: 0x37766d72
    1a5c:	69006d65 	stmdbvs	r0, {r0, r2, r5, r6, r8, sl, fp, sp, lr}
    1a60:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1a64:	6c5f7469 	cfldrdvs	mvd7, [pc], {105}	; 0x69
    1a68:	00656170 	rsbeq	r6, r5, r0, ror r1
    1a6c:	5f6c6c61 	svcpl	0x006c6c61
    1a70:	6c706d69 	ldclvs	13, cr6, [r0], #-420	; 0xfffffe5c
    1a74:	5f646569 	svcpl	0x00646569
    1a78:	74696266 	strbtvc	r6, [r9], #-614	; 0xfffffd9a
    1a7c:	73690073 	cmnvc	r9, #115	; 0x73
    1a80:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1a84:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1a88:	5f38766d 	svcpl	0x0038766d
    1a8c:	73690031 	cmnvc	r9, #49	; 0x31
    1a90:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1a94:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1a98:	5f38766d 	svcpl	0x0038766d
    1a9c:	73690032 	cmnvc	r9, #50	; 0x32
    1aa0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1aa4:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1aa8:	5f38766d 	svcpl	0x0038766d
    1aac:	73690033 	cmnvc	r9, #51	; 0x33
    1ab0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1ab4:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1ab8:	5f38766d 	svcpl	0x0038766d
    1abc:	73690034 	cmnvc	r9, #52	; 0x34
    1ac0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1ac4:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1ac8:	5f38766d 	svcpl	0x0038766d
    1acc:	73690035 	cmnvc	r9, #53	; 0x35
    1ad0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1ad4:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1ad8:	5f38766d 	svcpl	0x0038766d
    1adc:	73690036 	cmnvc	r9, #54	; 0x36
    1ae0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1ae4:	62735f74 	rsbsvs	r5, r3, #116, 30	; 0x1d0
    1ae8:	61736900 	cmnvs	r3, r0, lsl #18
    1aec:	6d756e5f 	ldclvs	14, cr6, [r5, #-380]!	; 0xfffffe84
    1af0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1af4:	73690073 	cmnvc	r9, #115	; 0x73
    1af8:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1afc:	6d735f74 	ldclvs	15, cr5, [r3, #-464]!	; 0xfffffe30
    1b00:	6d6c6c61 	stclvs	12, cr6, [ip, #-388]!	; 0xfffffe7c
    1b04:	66006c75 			; <UNDEFINED> instruction: 0x66006c75
    1b08:	5f636e75 	svcpl	0x00636e75
    1b0c:	00727470 	rsbseq	r7, r2, r0, ror r4
    1b10:	706d6f63 	rsbvc	r6, sp, r3, ror #30
    1b14:	2078656c 	rsbscs	r6, r8, ip, ror #10
    1b18:	62756f64 	rsbsvs	r6, r5, #100, 30	; 0x190
    1b1c:	4e00656c 	cfsh32mi	mvfx6, mvfx0, #60
    1b20:	50465f42 	subpl	r5, r6, r2, asr #30
    1b24:	5359535f 	cmppl	r9, #2080374785	; 0x7c000001
    1b28:	53474552 	movtpl	r4, #30034	; 0x7552
    1b2c:	61736900 	cmnvs	r3, r0, lsl #18
    1b30:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1b34:	6564635f 	strbvs	r6, [r4, #-863]!	; 0xfffffca1
    1b38:	00357063 	eorseq	r7, r5, r3, rrx
    1b3c:	5f617369 	svcpl	0x00617369
    1b40:	5f746962 	svcpl	0x00746962
    1b44:	76706676 			; <UNDEFINED> instruction: 0x76706676
    1b48:	73690032 	cmnvc	r9, #50	; 0x32
    1b4c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1b50:	66765f74 	uhsub16vs	r5, r6, r4
    1b54:	00337670 	eorseq	r7, r3, r0, ror r6
    1b58:	5f617369 	svcpl	0x00617369
    1b5c:	5f746962 	svcpl	0x00746962
    1b60:	76706676 			; <UNDEFINED> instruction: 0x76706676
    1b64:	50460034 	subpl	r0, r6, r4, lsr r0
    1b68:	4e545843 	cdpmi	8, 5, cr5, cr4, cr3, {2}
    1b6c:	4e455f53 	mcrmi	15, 2, r5, cr5, cr3, {2}
    1b70:	69004d55 	stmdbvs	r0, {r0, r2, r4, r6, r8, sl, fp, lr}
    1b74:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1b78:	745f7469 	ldrbvc	r7, [pc], #-1129	; 1b80 <CPSR_IRQ_INHIBIT+0x1b00>
    1b7c:	626d7568 	rsbvs	r7, sp, #104, 10	; 0x1a000000
    1b80:	61736900 	cmnvs	r3, r0, lsl #18
    1b84:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1b88:	3170665f 	cmncc	r0, pc, asr r6
    1b8c:	6e6f6336 	mcrvs	3, 3, r6, cr15, cr6, {1}
    1b90:	73690076 	cmnvc	r9, #118	; 0x76
    1b94:	65665f61 	strbvs	r5, [r6, #-3937]!	; 0xfffff09f
    1b98:	72757461 	rsbsvc	r7, r5, #1627389952	; 0x61000000
    1b9c:	73690065 	cmnvc	r9, #101	; 0x65
    1ba0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1ba4:	6f6e5f74 	svcvs	0x006e5f74
    1ba8:	69006d74 	stmdbvs	r0, {r2, r4, r5, r6, r8, sl, fp, sp, lr}
    1bac:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1bb0:	715f7469 	cmpvc	pc, r9, ror #8
    1bb4:	6b726975 	blvs	1c9c190 <_bss_end+0x1c916b0>
    1bb8:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1bbc:	7a6b3676 	bvc	1acf59c <_bss_end+0x1ac4abc>
    1bc0:	61736900 	cmnvs	r3, r0, lsl #18
    1bc4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1bc8:	6372635f 	cmnvs	r2, #2080374785	; 0x7c000001
    1bcc:	69003233 	stmdbvs	r0, {r0, r1, r4, r5, r9, ip, sp}
    1bd0:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1bd4:	715f7469 	cmpvc	pc, r9, ror #8
    1bd8:	6b726975 	blvs	1c9c1b4 <_bss_end+0x1c916d4>
    1bdc:	5f6f6e5f 	svcpl	0x006f6e5f
    1be0:	636d7361 	cmnvs	sp, #-2080374783	; 0x84000001
    1be4:	69007570 	stmdbvs	r0, {r4, r5, r6, r8, sl, ip, sp, lr}
    1be8:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1bec:	615f7469 	cmpvs	pc, r9, ror #8
    1bf0:	34766d72 	ldrbtcc	r6, [r6], #-3442	; 0xfffff28e
    1bf4:	61736900 	cmnvs	r3, r0, lsl #18
    1bf8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1bfc:	7568745f 	strbvc	r7, [r8, #-1119]!	; 0xfffffba1
    1c00:	0032626d 	eorseq	r6, r2, sp, ror #4
    1c04:	5f617369 	svcpl	0x00617369
    1c08:	5f746962 	svcpl	0x00746962
    1c0c:	00386562 	eorseq	r6, r8, r2, ror #10
    1c10:	5f617369 	svcpl	0x00617369
    1c14:	5f746962 	svcpl	0x00746962
    1c18:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1c1c:	73690037 	cmnvc	r9, #55	; 0x37
    1c20:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1c24:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1c28:	0038766d 	eorseq	r7, r8, sp, ror #12
    1c2c:	5f706676 	svcpl	0x00706676
    1c30:	72737973 	rsbsvc	r7, r3, #1884160	; 0x1cc000
    1c34:	5f736765 	svcpl	0x00736765
    1c38:	6f636e65 	svcvs	0x00636e65
    1c3c:	676e6964 	strbvs	r6, [lr, -r4, ror #18]!
    1c40:	61736900 	cmnvs	r3, r0, lsl #18
    1c44:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1c48:	3170665f 	cmncc	r0, pc, asr r6
    1c4c:	6c6d6636 	stclvs	6, cr6, [sp], #-216	; 0xffffff28
    1c50:	61736900 	cmnvs	r3, r0, lsl #18
    1c54:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1c58:	746f645f 	strbtvc	r6, [pc], #-1119	; 1c60 <CPSR_IRQ_INHIBIT+0x1be0>
    1c5c:	646f7270 	strbtvs	r7, [pc], #-624	; 1c64 <CPSR_IRQ_INHIBIT+0x1be4>
	...

Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347 	bcc	10d0d24 <_bss_end+0x10c6244>
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
  10:	4b5a3605 	blmi	168d82c <_bss_end+0x1682d4c>
  14:	08070600 	stmdaeq	r7, {r9, sl}
  18:	0a010901 	beq	42424 <_bss_end+0x37944>
  1c:	14041202 	strne	r1, [r4], #-514	; 0xfffffdfe
  20:	17011501 	strne	r1, [r1, -r1, lsl #10]
  24:	1a011803 	bne	46038 <_bss_end+0x3b558>
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
  20:	8b040e42 	blhi	103930 <_bss_end+0xf8e50>
  24:	0b0d4201 	bleq	350830 <_bss_end+0x345d50>
  28:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
  2c:	00000ecb 	andeq	r0, r0, fp, asr #29
  30:	0000001c 	andeq	r0, r0, ip, lsl r0
  34:	00000000 	andeq	r0, r0, r0
  38:	000080cc 	andeq	r8, r0, ip, asr #1
  3c:	0000002c 	andeq	r0, r0, ip, lsr #32
  40:	8b040e42 	blhi	103950 <_bss_end+0xf8e70>
  44:	0b0d4201 	bleq	350850 <_bss_end+0x345d70>
  48:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
  4c:	00000ecb 	andeq	r0, r0, fp, asr #29
  50:	0000001c 	andeq	r0, r0, ip, lsl r0
  54:	00000000 	andeq	r0, r0, r0
  58:	000080f8 	strdeq	r8, [r0], -r8	; <UNPREDICTABLE>
  5c:	00000020 	andeq	r0, r0, r0, lsr #32
  60:	8b040e42 	blhi	103970 <_bss_end+0xf8e90>
  64:	0b0d4201 	bleq	350870 <_bss_end+0x345d90>
  68:	420d0d48 	andmi	r0, sp, #72, 26	; 0x1200
  6c:	00000ecb 	andeq	r0, r0, fp, asr #29
  70:	0000001c 	andeq	r0, r0, ip, lsl r0
  74:	00000000 	andeq	r0, r0, r0
  78:	00008118 	andeq	r8, r0, r8, lsl r1
  7c:	00000018 	andeq	r0, r0, r8, lsl r0
  80:	8b040e42 	blhi	103990 <_bss_end+0xf8eb0>
  84:	0b0d4201 	bleq	350890 <_bss_end+0x345db0>
  88:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  8c:	00000ecb 	andeq	r0, r0, fp, asr #29
  90:	0000001c 	andeq	r0, r0, ip, lsl r0
  94:	00000000 	andeq	r0, r0, r0
  98:	00008130 	andeq	r8, r0, r0, lsr r1
  9c:	00000018 	andeq	r0, r0, r8, lsl r0
  a0:	8b040e42 	blhi	1039b0 <_bss_end+0xf8ed0>
  a4:	0b0d4201 	bleq	3508b0 <_bss_end+0x345dd0>
  a8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  ac:	00000ecb 	andeq	r0, r0, fp, asr #29
  b0:	0000001c 	andeq	r0, r0, ip, lsl r0
  b4:	00000000 	andeq	r0, r0, r0
  b8:	00008148 	andeq	r8, r0, r8, asr #2
  bc:	00000018 	andeq	r0, r0, r8, lsl r0
  c0:	8b040e42 	blhi	1039d0 <_bss_end+0xf8ef0>
  c4:	0b0d4201 	bleq	3508d0 <_bss_end+0x345df0>
  c8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  cc:	00000ecb 	andeq	r0, r0, fp, asr #29
  d0:	00000014 	andeq	r0, r0, r4, lsl r0
  d4:	00000000 	andeq	r0, r0, r0
  d8:	00008160 	andeq	r8, r0, r0, ror #2
  dc:	0000000c 	andeq	r0, r0, ip
  e0:	8b040e42 	blhi	1039f0 <_bss_end+0xf8f10>
  e4:	0b0d4201 	bleq	3508f0 <_bss_end+0x345e10>
  e8:	0000000c 	andeq	r0, r0, ip
  ec:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  f0:	7c020001 	stcvc	0, cr0, [r2], {1}
  f4:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  f8:	0000001c 	andeq	r0, r0, ip, lsl r0
  fc:	000000e8 	andeq	r0, r0, r8, ror #1
 100:	0000816c 	andeq	r8, r0, ip, ror #2
 104:	00000034 	andeq	r0, r0, r4, lsr r0
 108:	8b040e42 	blhi	103a18 <_bss_end+0xf8f38>
 10c:	0b0d4201 	bleq	350918 <_bss_end+0x345e38>
 110:	420d0d52 	andmi	r0, sp, #5248	; 0x1480
 114:	00000ecb 	andeq	r0, r0, fp, asr #29
 118:	0000001c 	andeq	r0, r0, ip, lsl r0
 11c:	000000e8 	andeq	r0, r0, r8, ror #1
 120:	000081a0 	andeq	r8, r0, r0, lsr #3
 124:	00000050 	andeq	r0, r0, r0, asr r0
 128:	8b080e42 	blhi	203a38 <_bss_end+0x1f8f58>
 12c:	42018e02 	andmi	r8, r1, #2, 28
 130:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 134:	00080d0c 	andeq	r0, r8, ip, lsl #26
 138:	0000001c 	andeq	r0, r0, ip, lsl r0
 13c:	000000e8 	andeq	r0, r0, r8, ror #1
 140:	000081f0 	strdeq	r8, [r0], -r0
 144:	00000054 	andeq	r0, r0, r4, asr r0
 148:	8b080e42 	blhi	203a58 <_bss_end+0x1f8f78>
 14c:	42018e02 	andmi	r8, r1, #2, 28
 150:	64040b0c 	strvs	r0, [r4], #-2828	; 0xfffff4f4
 154:	00080d0c 	andeq	r0, r8, ip, lsl #26
 158:	0000001c 	andeq	r0, r0, ip, lsl r0
 15c:	000000e8 	andeq	r0, r0, r8, ror #1
 160:	00008244 	andeq	r8, r0, r4, asr #4
 164:	00000044 	andeq	r0, r0, r4, asr #32
 168:	8b040e42 	blhi	103a78 <_bss_end+0xf8f98>
 16c:	0b0d4201 	bleq	350978 <_bss_end+0x345e98>
 170:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 174:	00000ecb 	andeq	r0, r0, fp, asr #29
 178:	0000001c 	andeq	r0, r0, ip, lsl r0
 17c:	000000e8 	andeq	r0, r0, r8, ror #1
 180:	00008288 	andeq	r8, r0, r8, lsl #5
 184:	0000003c 	andeq	r0, r0, ip, lsr r0
 188:	8b040e42 	blhi	103a98 <_bss_end+0xf8fb8>
 18c:	0b0d4201 	bleq	350998 <_bss_end+0x345eb8>
 190:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 194:	00000ecb 	andeq	r0, r0, fp, asr #29
 198:	0000001c 	andeq	r0, r0, ip, lsl r0
 19c:	000000e8 	andeq	r0, r0, r8, ror #1
 1a0:	000082c4 	andeq	r8, r0, r4, asr #5
 1a4:	00000054 	andeq	r0, r0, r4, asr r0
 1a8:	8b080e42 	blhi	203ab8 <_bss_end+0x1f8fd8>
 1ac:	42018e02 	andmi	r8, r1, #2, 28
 1b0:	5e040b0c 	vmlapl.f64	d0, d4, d12
 1b4:	00080d0c 	andeq	r0, r8, ip, lsl #26
 1b8:	00000018 	andeq	r0, r0, r8, lsl r0
 1bc:	000000e8 	andeq	r0, r0, r8, ror #1
 1c0:	00008318 	andeq	r8, r0, r8, lsl r3
 1c4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1c8:	8b080e42 	blhi	203ad8 <_bss_end+0x1f8ff8>
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
 1f4:	8b040e42 	blhi	103b04 <_bss_end+0xf9024>
 1f8:	0b0d4201 	bleq	350a04 <_bss_end+0x345f24>
 1fc:	420d0d52 	andmi	r0, sp, #5248	; 0x1480
 200:	00000ecb 	andeq	r0, r0, fp, asr #29
 204:	0000001c 	andeq	r0, r0, ip, lsl r0
 208:	000001d4 	ldrdeq	r0, [r0], -r4
 20c:	00008368 	andeq	r8, r0, r8, ror #6
 210:	00000114 	andeq	r0, r0, r4, lsl r1
 214:	8b040e42 	blhi	103b24 <_bss_end+0xf9044>
 218:	0b0d4201 	bleq	350a24 <_bss_end+0x345f44>
 21c:	0d0d8002 	stceq	0, cr8, [sp, #-8]
 220:	000ecb42 	andeq	ip, lr, r2, asr #22
 224:	0000001c 	andeq	r0, r0, ip, lsl r0
 228:	000001d4 	ldrdeq	r0, [r0], -r4
 22c:	0000847c 	andeq	r8, r0, ip, ror r4
 230:	00000074 	andeq	r0, r0, r4, ror r0
 234:	8b040e42 	blhi	103b44 <_bss_end+0xf9064>
 238:	0b0d4201 	bleq	350a44 <_bss_end+0x345f64>
 23c:	420d0d72 	andmi	r0, sp, #7296	; 0x1c80
 240:	00000ecb 	andeq	r0, r0, fp, asr #29
 244:	0000001c 	andeq	r0, r0, ip, lsl r0
 248:	000001d4 	ldrdeq	r0, [r0], -r4
 24c:	000084f0 	strdeq	r8, [r0], -r0
 250:	00000074 	andeq	r0, r0, r4, ror r0
 254:	8b040e42 	blhi	103b64 <_bss_end+0xf9084>
 258:	0b0d4201 	bleq	350a64 <_bss_end+0x345f84>
 25c:	420d0d72 	andmi	r0, sp, #7296	; 0x1c80
 260:	00000ecb 	andeq	r0, r0, fp, asr #29
 264:	0000001c 	andeq	r0, r0, ip, lsl r0
 268:	000001d4 	ldrdeq	r0, [r0], -r4
 26c:	00008564 	andeq	r8, r0, r4, ror #10
 270:	00000074 	andeq	r0, r0, r4, ror r0
 274:	8b040e42 	blhi	103b84 <_bss_end+0xf90a4>
 278:	0b0d4201 	bleq	350a84 <_bss_end+0x345fa4>
 27c:	420d0d72 	andmi	r0, sp, #7296	; 0x1c80
 280:	00000ecb 	andeq	r0, r0, fp, asr #29
 284:	0000001c 	andeq	r0, r0, ip, lsl r0
 288:	000001d4 	ldrdeq	r0, [r0], -r4
 28c:	000085d8 	ldrdeq	r8, [r0], -r8	; <UNPREDICTABLE>
 290:	000000a8 	andeq	r0, r0, r8, lsr #1
 294:	8b080e42 	blhi	203ba4 <_bss_end+0x1f90c4>
 298:	42018e02 	andmi	r8, r1, #2, 28
 29c:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 2a0:	080d0c4e 	stmdaeq	sp, {r1, r2, r3, r6, sl, fp}
 2a4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2a8:	000001d4 	ldrdeq	r0, [r0], -r4
 2ac:	00008680 	andeq	r8, r0, r0, lsl #13
 2b0:	0000007c 	andeq	r0, r0, ip, ror r0
 2b4:	8b080e42 	blhi	203bc4 <_bss_end+0x1f90e4>
 2b8:	42018e02 	andmi	r8, r1, #2, 28
 2bc:	78040b0c 	stmdavc	r4, {r2, r3, r8, r9, fp}
 2c0:	00080d0c 	andeq	r0, r8, ip, lsl #26
 2c4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2c8:	000001d4 	ldrdeq	r0, [r0], -r4
 2cc:	000086fc 	strdeq	r8, [r0], -ip
 2d0:	00000084 	andeq	r0, r0, r4, lsl #1
 2d4:	8b080e42 	blhi	203be4 <_bss_end+0x1f9104>
 2d8:	42018e02 	andmi	r8, r1, #2, 28
 2dc:	7c040b0c 			; <UNDEFINED> instruction: 0x7c040b0c
 2e0:	00080d0c 	andeq	r0, r8, ip, lsl #26
 2e4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2e8:	000001d4 	ldrdeq	r0, [r0], -r4
 2ec:	00008780 	andeq	r8, r0, r0, lsl #15
 2f0:	0000010c 	andeq	r0, r0, ip, lsl #2
 2f4:	8b040e42 	blhi	103c04 <_bss_end+0xf9124>
 2f8:	0b0d4201 	bleq	350b04 <_bss_end+0x346024>
 2fc:	0d0d7e02 	stceq	14, cr7, [sp, #-8]
 300:	000ecb42 	andeq	ip, lr, r2, asr #22
 304:	0000001c 	andeq	r0, r0, ip, lsl r0
 308:	000001d4 	ldrdeq	r0, [r0], -r4
 30c:	0000888c 	andeq	r8, r0, ip, lsl #17
 310:	000000b4 	strheq	r0, [r0], -r4
 314:	8b080e42 	blhi	203c24 <_bss_end+0x1f9144>
 318:	42018e02 	andmi	r8, r1, #2, 28
 31c:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 320:	080d0c54 	stmdaeq	sp, {r2, r4, r6, sl, fp}
 324:	0000001c 	andeq	r0, r0, ip, lsl r0
 328:	000001d4 	ldrdeq	r0, [r0], -r4
 32c:	00008940 	andeq	r8, r0, r0, asr #18
 330:	000000d8 	ldrdeq	r0, [r0], -r8
 334:	8b080e42 	blhi	203c44 <_bss_end+0x1f9164>
 338:	42018e02 	andmi	r8, r1, #2, 28
 33c:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 340:	080d0c66 	stmdaeq	sp, {r1, r2, r5, r6, sl, fp}
 344:	0000001c 	andeq	r0, r0, ip, lsl r0
 348:	000001d4 	ldrdeq	r0, [r0], -r4
 34c:	00008a18 	andeq	r8, r0, r8, lsl sl
 350:	00000074 	andeq	r0, r0, r4, ror r0
 354:	8b040e42 	blhi	103c64 <_bss_end+0xf9184>
 358:	0b0d4201 	bleq	350b64 <_bss_end+0x346084>
 35c:	420d0d72 	andmi	r0, sp, #7296	; 0x1c80
 360:	00000ecb 	andeq	r0, r0, fp, asr #29
 364:	0000001c 	andeq	r0, r0, ip, lsl r0
 368:	000001d4 	ldrdeq	r0, [r0], -r4
 36c:	00008a8c 	andeq	r8, r0, ip, lsl #21
 370:	00000074 	andeq	r0, r0, r4, ror r0
 374:	8b080e42 	blhi	203c84 <_bss_end+0x1f91a4>
 378:	42018e02 	andmi	r8, r1, #2, 28
 37c:	74040b0c 	strvc	r0, [r4], #-2828	; 0xfffff4f4
 380:	00080d0c 	andeq	r0, r8, ip, lsl #26
 384:	0000001c 	andeq	r0, r0, ip, lsl r0
 388:	000001d4 	ldrdeq	r0, [r0], -r4
 38c:	00008b00 	andeq	r8, r0, r0, lsl #22
 390:	00000054 	andeq	r0, r0, r4, asr r0
 394:	8b080e42 	blhi	203ca4 <_bss_end+0x1f91c4>
 398:	42018e02 	andmi	r8, r1, #2, 28
 39c:	5e040b0c 	vmlapl.f64	d0, d4, d12
 3a0:	00080d0c 	andeq	r0, r8, ip, lsl #26
 3a4:	00000018 	andeq	r0, r0, r8, lsl r0
 3a8:	000001d4 	ldrdeq	r0, [r0], -r4
 3ac:	00008b54 	andeq	r8, r0, r4, asr fp
 3b0:	0000001c 	andeq	r0, r0, ip, lsl r0
 3b4:	8b080e42 	blhi	203cc4 <_bss_end+0x1f91e4>
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
 3e0:	8b040e42 	blhi	103cf0 <_bss_end+0xf9210>
 3e4:	0b0d4201 	bleq	350bf0 <_bss_end+0x346110>
 3e8:	420d0d74 	andmi	r0, sp, #116, 26	; 0x1d00
 3ec:	00000ecb 	andeq	r0, r0, fp, asr #29
 3f0:	0000001c 	andeq	r0, r0, ip, lsl r0
 3f4:	000003c0 	andeq	r0, r0, r0, asr #7
 3f8:	000091b8 			; <UNDEFINED> instruction: 0x000091b8
 3fc:	00000038 	andeq	r0, r0, r8, lsr r0
 400:	8b040e42 	blhi	103d10 <_bss_end+0xf9230>
 404:	0b0d4201 	bleq	350c10 <_bss_end+0x346130>
 408:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
 40c:	00000ecb 	andeq	r0, r0, fp, asr #29
 410:	0000001c 	andeq	r0, r0, ip, lsl r0
 414:	000003c0 	andeq	r0, r0, r0, asr #7
 418:	00008be8 	andeq	r8, r0, r8, ror #23
 41c:	000000a8 	andeq	r0, r0, r8, lsr #1
 420:	8b080e42 	blhi	203d30 <_bss_end+0x1f9250>
 424:	42018e02 	andmi	r8, r1, #2, 28
 428:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 42c:	080d0c4e 	stmdaeq	sp, {r1, r2, r3, r6, sl, fp}
 430:	0000001c 	andeq	r0, r0, ip, lsl r0
 434:	000003c0 	andeq	r0, r0, r0, asr #7
 438:	000091f0 	strdeq	r9, [r0], -r0
 43c:	00000088 	andeq	r0, r0, r8, lsl #1
 440:	8b080e42 	blhi	203d50 <_bss_end+0x1f9270>
 444:	42018e02 	andmi	r8, r1, #2, 28
 448:	7e040b0c 	vmlavc.f64	d0, d4, d12
 44c:	00080d0c 	andeq	r0, r8, ip, lsl #26
 450:	0000001c 	andeq	r0, r0, ip, lsl r0
 454:	000003c0 	andeq	r0, r0, r0, asr #7
 458:	00008c90 	muleq	r0, r0, ip
 45c:	00000130 	andeq	r0, r0, r0, lsr r1
 460:	8b040e42 	blhi	103d70 <_bss_end+0xf9290>
 464:	0b0d4201 	bleq	350c70 <_bss_end+0x346190>
 468:	0d0d9002 	stceq	0, cr9, [sp, #-8]
 46c:	000ecb42 	andeq	ip, lr, r2, asr #22
 470:	0000001c 	andeq	r0, r0, ip, lsl r0
 474:	000003c0 	andeq	r0, r0, r0, asr #7
 478:	00009278 	andeq	r9, r0, r8, ror r2
 47c:	0000002c 	andeq	r0, r0, ip, lsr #32
 480:	8b040e42 	blhi	103d90 <_bss_end+0xf92b0>
 484:	0b0d4201 	bleq	350c90 <_bss_end+0x3461b0>
 488:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 48c:	00000ecb 	andeq	r0, r0, fp, asr #29
 490:	0000001c 	andeq	r0, r0, ip, lsl r0
 494:	000003c0 	andeq	r0, r0, r0, asr #7
 498:	00008dc0 	andeq	r8, r0, r0, asr #27
 49c:	000000a8 	andeq	r0, r0, r8, lsr #1
 4a0:	8b080e42 	blhi	203db0 <_bss_end+0x1f92d0>
 4a4:	42018e02 	andmi	r8, r1, #2, 28
 4a8:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 4ac:	080d0c4e 	stmdaeq	sp, {r1, r2, r3, r6, sl, fp}
 4b0:	0000001c 	andeq	r0, r0, ip, lsl r0
 4b4:	000003c0 	andeq	r0, r0, r0, asr #7
 4b8:	00008e68 	andeq	r8, r0, r8, ror #28
 4bc:	00000078 	andeq	r0, r0, r8, ror r0
 4c0:	8b080e42 	blhi	203dd0 <_bss_end+0x1f92f0>
 4c4:	42018e02 	andmi	r8, r1, #2, 28
 4c8:	76040b0c 	strvc	r0, [r4], -ip, lsl #22
 4cc:	00080d0c 	andeq	r0, r8, ip, lsl #26
 4d0:	0000001c 	andeq	r0, r0, ip, lsl r0
 4d4:	000003c0 	andeq	r0, r0, r0, asr #7
 4d8:	00008ee0 	andeq	r8, r0, r0, ror #29
 4dc:	00000034 	andeq	r0, r0, r4, lsr r0
 4e0:	8b040e42 	blhi	103df0 <_bss_end+0xf9310>
 4e4:	0b0d4201 	bleq	350cf0 <_bss_end+0x346210>
 4e8:	420d0d52 	andmi	r0, sp, #5248	; 0x1480
 4ec:	00000ecb 	andeq	r0, r0, fp, asr #29
 4f0:	0000001c 	andeq	r0, r0, ip, lsl r0
 4f4:	000003c0 	andeq	r0, r0, r0, asr #7
 4f8:	00008f14 	andeq	r8, r0, r4, lsl pc
 4fc:	00000054 	andeq	r0, r0, r4, asr r0
 500:	8b080e42 	blhi	203e10 <_bss_end+0x1f9330>
 504:	42018e02 	andmi	r8, r1, #2, 28
 508:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 50c:	00080d0c 	andeq	r0, r8, ip, lsl #26
 510:	0000001c 	andeq	r0, r0, ip, lsl r0
 514:	000003c0 	andeq	r0, r0, r0, asr #7
 518:	00008f68 	andeq	r8, r0, r8, ror #30
 51c:	00000060 	andeq	r0, r0, r0, rrx
 520:	8b080e42 	blhi	203e30 <_bss_end+0x1f9350>
 524:	42018e02 	andmi	r8, r1, #2, 28
 528:	66040b0c 	strvs	r0, [r4], -ip, lsl #22
 52c:	00080d0c 	andeq	r0, r8, ip, lsl #26
 530:	0000001c 	andeq	r0, r0, ip, lsl r0
 534:	000003c0 	andeq	r0, r0, r0, asr #7
 538:	00008fc8 	andeq	r8, r0, r8, asr #31
 53c:	0000017c 	andeq	r0, r0, ip, ror r1
 540:	8b080e42 	blhi	203e50 <_bss_end+0x1f9370>
 544:	42018e02 	andmi	r8, r1, #2, 28
 548:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 54c:	080d0cb6 	stmdaeq	sp, {r1, r2, r4, r5, r7, sl, fp}
 550:	0000001c 	andeq	r0, r0, ip, lsl r0
 554:	000003c0 	andeq	r0, r0, r0, asr #7
 558:	00009144 	andeq	r9, r0, r4, asr #2
 55c:	00000058 	andeq	r0, r0, r8, asr r0
 560:	8b080e42 	blhi	203e70 <_bss_end+0x1f9390>
 564:	42018e02 	andmi	r8, r1, #2, 28
 568:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 56c:	00080d0c 	andeq	r0, r8, ip, lsl #26
 570:	00000018 	andeq	r0, r0, r8, lsl r0
 574:	000003c0 	andeq	r0, r0, r0, asr #7
 578:	0000919c 	muleq	r0, ip, r1
 57c:	0000001c 	andeq	r0, r0, ip, lsl r0
 580:	8b080e42 	blhi	203e90 <_bss_end+0x1f93b0>
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
 5ac:	8b080e42 	blhi	203ebc <_bss_end+0x1f93dc>
 5b0:	42018e02 	andmi	r8, r1, #2, 28
 5b4:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 5b8:	080d0c4c 	stmdaeq	sp, {r2, r3, r6, sl, fp}
 5bc:	00000020 	andeq	r0, r0, r0, lsr #32
 5c0:	0000058c 	andeq	r0, r0, ip, lsl #11
 5c4:	00009348 	andeq	r9, r0, r8, asr #6
 5c8:	0000005c 	andeq	r0, r0, ip, asr r0
 5cc:	840c0e42 	strhi	r0, [ip], #-3650	; 0xfffff1be
 5d0:	8e028b03 	vmlahi.f64	d8, d2, d3
 5d4:	0b0c4201 	bleq	310de0 <_bss_end+0x306300>
 5d8:	0d0c6804 	stceq	8, cr6, [ip, #-16]
 5dc:	0000000c 	andeq	r0, r0, ip
 5e0:	0000001c 	andeq	r0, r0, ip, lsl r0
 5e4:	0000058c 	andeq	r0, r0, ip, lsl #11
 5e8:	000093a4 	andeq	r9, r0, r4, lsr #7
 5ec:	00000094 	muleq	r0, r4, r0
 5f0:	8b080e42 	blhi	203f00 <_bss_end+0x1f9420>
 5f4:	42018e02 	andmi	r8, r1, #2, 28
 5f8:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 5fc:	080d0c40 	stmdaeq	sp, {r6, sl, fp}
 600:	0000001c 	andeq	r0, r0, ip, lsl r0
 604:	0000058c 	andeq	r0, r0, ip, lsl #11
 608:	00009438 	andeq	r9, r0, r8, lsr r4
 60c:	00000074 	andeq	r0, r0, r4, ror r0
 610:	8b080e42 	blhi	203f20 <_bss_end+0x1f9440>
 614:	42018e02 	andmi	r8, r1, #2, 28
 618:	74040b0c 	strvc	r0, [r4], #-2828	; 0xfffff4f4
 61c:	00080d0c 	andeq	r0, r8, ip, lsl #26
 620:	0000001c 	andeq	r0, r0, ip, lsl r0
 624:	0000058c 	andeq	r0, r0, ip, lsl #11
 628:	000094ac 	andeq	r9, r0, ip, lsr #9
 62c:	0000006c 	andeq	r0, r0, ip, rrx
 630:	8b080e42 	blhi	203f40 <_bss_end+0x1f9460>
 634:	42018e02 	andmi	r8, r1, #2, 28
 638:	70040b0c 	andvc	r0, r4, ip, lsl #22
 63c:	00080d0c 	andeq	r0, r8, ip, lsl #26
 640:	0000001c 	andeq	r0, r0, ip, lsl r0
 644:	0000058c 	andeq	r0, r0, ip, lsl #11
 648:	00009518 	andeq	r9, r0, r8, lsl r5
 64c:	00000068 	andeq	r0, r0, r8, rrx
 650:	8b080e42 	blhi	203f60 <_bss_end+0x1f9480>
 654:	42018e02 	andmi	r8, r1, #2, 28
 658:	6e040b0c 	vmlavs.f64	d0, d4, d12
 65c:	00080d0c 	andeq	r0, r8, ip, lsl #26
 660:	0000001c 	andeq	r0, r0, ip, lsl r0
 664:	0000058c 	andeq	r0, r0, ip, lsl #11
 668:	00009580 	andeq	r9, r0, r0, lsl #11
 66c:	00000040 	andeq	r0, r0, r0, asr #32
 670:	8b080e42 	blhi	203f80 <_bss_end+0x1f94a0>
 674:	42018e02 	andmi	r8, r1, #2, 28
 678:	58040b0c 	stmdapl	r4, {r2, r3, r8, r9, fp}
 67c:	00080d0c 	andeq	r0, r8, ip, lsl #26
 680:	0000001c 	andeq	r0, r0, ip, lsl r0
 684:	0000058c 	andeq	r0, r0, ip, lsl #11
 688:	000095c0 	andeq	r9, r0, r0, asr #11
 68c:	00000030 	andeq	r0, r0, r0, lsr r0
 690:	8b080e42 	blhi	203fa0 <_bss_end+0x1f94c0>
 694:	42018e02 	andmi	r8, r1, #2, 28
 698:	52040b0c 	andpl	r0, r4, #12, 22	; 0x3000
 69c:	00080d0c 	andeq	r0, r8, ip, lsl #26
 6a0:	0000001c 	andeq	r0, r0, ip, lsl r0
 6a4:	0000058c 	andeq	r0, r0, ip, lsl #11
 6a8:	000095f0 	strdeq	r9, [r0], -r0
 6ac:	00000040 	andeq	r0, r0, r0, asr #32
 6b0:	8b080e42 	blhi	203fc0 <_bss_end+0x1f94e0>
 6b4:	42018e02 	andmi	r8, r1, #2, 28
 6b8:	58040b0c 	stmdapl	r4, {r2, r3, r8, r9, fp}
 6bc:	00080d0c 	andeq	r0, r8, ip, lsl #26
 6c0:	0000001c 	andeq	r0, r0, ip, lsl r0
 6c4:	0000058c 	andeq	r0, r0, ip, lsl #11
 6c8:	00009630 	andeq	r9, r0, r0, lsr r6
 6cc:	0000007c 	andeq	r0, r0, ip, ror r0
 6d0:	8b080e42 	blhi	203fe0 <_bss_end+0x1f9500>
 6d4:	42018e02 	andmi	r8, r1, #2, 28
 6d8:	78040b0c 	stmdavc	r4, {r2, r3, r8, r9, fp}
 6dc:	00080d0c 	andeq	r0, r8, ip, lsl #26
 6e0:	00000020 	andeq	r0, r0, r0, lsr #32
 6e4:	0000058c 	andeq	r0, r0, ip, lsl #11
 6e8:	000096ac 	andeq	r9, r0, ip, lsr #13
 6ec:	00000050 	andeq	r0, r0, r0, asr r0
 6f0:	840c0e42 	strhi	r0, [ip], #-3650	; 0xfffff1be
 6f4:	8e028b03 	vmlahi.f64	d8, d2, d3
 6f8:	0b0c4201 	bleq	310f04 <_bss_end+0x306424>
 6fc:	0d0c6204 	sfmeq	f6, 4, [ip, #-16]
 700:	0000000c 	andeq	r0, r0, ip
 704:	00000020 	andeq	r0, r0, r0, lsr #32
 708:	0000058c 	andeq	r0, r0, ip, lsl #11
 70c:	000096fc 	strdeq	r9, [r0], -ip
 710:	00000050 	andeq	r0, r0, r0, asr r0
 714:	840c0e42 	strhi	r0, [ip], #-3650	; 0xfffff1be
 718:	8e028b03 	vmlahi.f64	d8, d2, d3
 71c:	0b0c4201 	bleq	310f28 <_bss_end+0x306448>
 720:	0d0c6204 	sfmeq	f6, 4, [ip, #-16]
 724:	0000000c 	andeq	r0, r0, ip
 728:	0000001c 	andeq	r0, r0, ip, lsl r0
 72c:	0000058c 	andeq	r0, r0, ip, lsl #11
 730:	0000974c 	andeq	r9, r0, ip, asr #14
 734:	00000054 	andeq	r0, r0, r4, asr r0
 738:	8b080e42 	blhi	204048 <_bss_end+0x1f9568>
 73c:	42018e02 	andmi	r8, r1, #2, 28
 740:	5e040b0c 	vmlapl.f64	d0, d4, d12
 744:	00080d0c 	andeq	r0, r8, ip, lsl #26
 748:	00000018 	andeq	r0, r0, r8, lsl r0
 74c:	0000058c 	andeq	r0, r0, ip, lsl #11
 750:	000097a0 	andeq	r9, r0, r0, lsr #15
 754:	0000001c 	andeq	r0, r0, ip, lsl r0
 758:	8b080e42 	blhi	204068 <_bss_end+0x1f9588>
 75c:	42018e02 	andmi	r8, r1, #2, 28
 760:	00040b0c 	andeq	r0, r4, ip, lsl #22
 764:	0000000c 	andeq	r0, r0, ip
 768:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 76c:	7c020001 	stcvc	0, cr0, [r2], {1}
 770:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 774:	00000020 	andeq	r0, r0, r0, lsr #32
 778:	00000764 	andeq	r0, r0, r4, ror #14
 77c:	000097bc 			; <UNDEFINED> instruction: 0x000097bc
 780:	0000032c 	andeq	r0, r0, ip, lsr #6
 784:	8b080e42 	blhi	204094 <_bss_end+0x1f95b4>
 788:	42018e02 	andmi	r8, r1, #2, 28
 78c:	03040b0c 	movweq	r0, #19212	; 0x4b0c
 790:	0d0c0176 	stfeqs	f0, [ip, #-472]	; 0xfffffe28
 794:	00000008 	andeq	r0, r0, r8
 798:	0000001c 	andeq	r0, r0, ip, lsl r0
 79c:	00000764 	andeq	r0, r0, r4, ror #14
 7a0:	00009ae8 	andeq	r9, r0, r8, ror #21
 7a4:	00000018 	andeq	r0, r0, r8, lsl r0
 7a8:	8b040e42 	blhi	1040b8 <_bss_end+0xf95d8>
 7ac:	0b0d4201 	bleq	350fb8 <_bss_end+0x3464d8>
 7b0:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
 7b4:	00000ecb 	andeq	r0, r0, fp, asr #29
 7b8:	00000028 	andeq	r0, r0, r8, lsr #32
 7bc:	00000764 	andeq	r0, r0, r4, ror #14
 7c0:	00009b00 	andeq	r9, r0, r0, lsl #22
 7c4:	00000058 	andeq	r0, r0, r8, asr r0
 7c8:	801c0e44 	andshi	r0, ip, r4, asr #28
 7cc:	82068107 	andhi	r8, r6, #-1073741823	; 0xc0000001
 7d0:	8b048305 	blhi	1213ec <_bss_end+0x11690c>
 7d4:	8e028c03 	cdphi	12, 0, cr8, cr2, cr3, {0}
 7d8:	0b0c4201 	bleq	310fe4 <_bss_end+0x306504>
 7dc:	0d0c6204 	sfmeq	f6, 4, [ip, #-16]
 7e0:	0000001c 	andeq	r0, r0, ip, lsl r0
 7e4:	00000014 	andeq	r0, r0, r4, lsl r0
 7e8:	00000764 	andeq	r0, r0, r4, ror #14
 7ec:	00009b58 	andeq	r9, r0, r8, asr fp
 7f0:	00000010 	andeq	r0, r0, r0, lsl r0
 7f4:	040b0c42 	streq	r0, [fp], #-3138	; 0xfffff3be
 7f8:	000d0c44 	andeq	r0, sp, r4, asr #24
 7fc:	0000001c 	andeq	r0, r0, ip, lsl r0
 800:	00000764 	andeq	r0, r0, r4, ror #14
 804:	00009b68 	andeq	r9, r0, r8, ror #22
 808:	00000034 	andeq	r0, r0, r4, lsr r0
 80c:	8b040e42 	blhi	10411c <_bss_end+0xf963c>
 810:	0b0d4201 	bleq	35101c <_bss_end+0x34653c>
 814:	420d0d52 	andmi	r0, sp, #5248	; 0x1480
 818:	00000ecb 	andeq	r0, r0, fp, asr #29
 81c:	0000001c 	andeq	r0, r0, ip, lsl r0
 820:	00000764 	andeq	r0, r0, r4, ror #14
 824:	00009b9c 	muleq	r0, ip, fp
 828:	00000038 	andeq	r0, r0, r8, lsr r0
 82c:	8b040e42 	blhi	10413c <_bss_end+0xf965c>
 830:	0b0d4201 	bleq	35103c <_bss_end+0x34655c>
 834:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
 838:	00000ecb 	andeq	r0, r0, fp, asr #29
 83c:	00000020 	andeq	r0, r0, r0, lsr #32
 840:	00000764 	andeq	r0, r0, r4, ror #14
 844:	00009bd4 	ldrdeq	r9, [r0], -r4
 848:	00000044 	andeq	r0, r0, r4, asr #32
 84c:	840c0e42 	strhi	r0, [ip], #-3650	; 0xfffff1be
 850:	8e028b03 	vmlahi.f64	d8, d2, d3
 854:	0b0c4201 	bleq	311060 <_bss_end+0x306580>
 858:	0d0c5c04 	stceq	12, cr5, [ip, #-16]
 85c:	0000000c 	andeq	r0, r0, ip
 860:	00000020 	andeq	r0, r0, r0, lsr #32
 864:	00000764 	andeq	r0, r0, r4, ror #14
 868:	00009c18 	andeq	r9, r0, r8, lsl ip
 86c:	00000044 	andeq	r0, r0, r4, asr #32
 870:	840c0e42 	strhi	r0, [ip], #-3650	; 0xfffff1be
 874:	8e028b03 	vmlahi.f64	d8, d2, d3
 878:	0b0c4201 	bleq	311084 <_bss_end+0x3065a4>
 87c:	0d0c5c04 	stceq	12, cr5, [ip, #-16]
 880:	0000000c 	andeq	r0, r0, ip
 884:	00000020 	andeq	r0, r0, r0, lsr #32
 888:	00000764 	andeq	r0, r0, r4, ror #14
 88c:	00009c5c 	andeq	r9, r0, ip, asr ip
 890:	00000068 	andeq	r0, r0, r8, rrx
 894:	840c0e42 	strhi	r0, [ip], #-3650	; 0xfffff1be
 898:	8e028b03 	vmlahi.f64	d8, d2, d3
 89c:	0b0c4201 	bleq	3110a8 <_bss_end+0x3065c8>
 8a0:	0d0c6e04 	stceq	14, cr6, [ip, #-16]
 8a4:	0000000c 	andeq	r0, r0, ip
 8a8:	00000020 	andeq	r0, r0, r0, lsr #32
 8ac:	00000764 	andeq	r0, r0, r4, ror #14
 8b0:	00009cc4 	andeq	r9, r0, r4, asr #25
 8b4:	00000068 	andeq	r0, r0, r8, rrx
 8b8:	840c0e42 	strhi	r0, [ip], #-3650	; 0xfffff1be
 8bc:	8e028b03 	vmlahi.f64	d8, d2, d3
 8c0:	0b0c4201 	bleq	3110cc <_bss_end+0x3065ec>
 8c4:	0d0c6e04 	stceq	14, cr6, [ip, #-16]
 8c8:	0000000c 	andeq	r0, r0, ip
 8cc:	0000001c 	andeq	r0, r0, ip, lsl r0
 8d0:	00000764 	andeq	r0, r0, r4, ror #14
 8d4:	00009d2c 	andeq	r9, r0, ip, lsr #26
 8d8:	00000054 	andeq	r0, r0, r4, asr r0
 8dc:	8b080e42 	blhi	2041ec <_bss_end+0x1f970c>
 8e0:	42018e02 	andmi	r8, r1, #2, 28
 8e4:	5e040b0c 	vmlapl.f64	d0, d4, d12
 8e8:	00080d0c 	andeq	r0, r8, ip, lsl #26
 8ec:	00000018 	andeq	r0, r0, r8, lsl r0
 8f0:	00000764 	andeq	r0, r0, r4, ror #14
 8f4:	00009d80 	andeq	r9, r0, r0, lsl #27
 8f8:	0000001c 	andeq	r0, r0, ip, lsl r0
 8fc:	8b080e42 	blhi	20420c <_bss_end+0x1f972c>
 900:	42018e02 	andmi	r8, r1, #2, 28
 904:	00040b0c 	andeq	r0, r4, ip, lsl #22
 908:	0000000c 	andeq	r0, r0, ip
 90c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 910:	7c020001 	stcvc	0, cr0, [r2], {1}
 914:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 918:	00000018 	andeq	r0, r0, r8, lsl r0
 91c:	00000908 	andeq	r0, r0, r8, lsl #18
 920:	00009d9c 	muleq	r0, ip, sp
 924:	00000078 	andeq	r0, r0, r8, ror r0
 928:	8b080e42 	blhi	204238 <_bss_end+0x1f9758>
 92c:	42018e02 	andmi	r8, r1, #2, 28
 930:	00040b0c 	andeq	r0, r4, ip, lsl #22
 934:	0000000c 	andeq	r0, r0, ip
 938:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 93c:	7c020001 	stcvc	0, cr0, [r2], {1}
 940:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 944:	0000001c 	andeq	r0, r0, ip, lsl r0
 948:	00000934 	andeq	r0, r0, r4, lsr r9
 94c:	00009e34 	andeq	r9, r0, r4, lsr lr
 950:	00000068 	andeq	r0, r0, r8, rrx
 954:	8b040e42 	blhi	104264 <_bss_end+0xf9784>
 958:	0b0d4201 	bleq	351164 <_bss_end+0x346684>
 95c:	420d0d68 	andmi	r0, sp, #104, 26	; 0x1a00
 960:	00000ecb 	andeq	r0, r0, fp, asr #29
 964:	0000001c 	andeq	r0, r0, ip, lsl r0
 968:	00000934 	andeq	r0, r0, r4, lsr r9
 96c:	00009e9c 	muleq	r0, ip, lr
 970:	00000058 	andeq	r0, r0, r8, asr r0
 974:	8b080e42 	blhi	204284 <_bss_end+0x1f97a4>
 978:	42018e02 	andmi	r8, r1, #2, 28
 97c:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 980:	00080d0c 	andeq	r0, r8, ip, lsl #26
 984:	0000001c 	andeq	r0, r0, ip, lsl r0
 988:	00000934 	andeq	r0, r0, r4, lsr r9
 98c:	00009ef4 	strdeq	r9, [r0], -r4
 990:	00000058 	andeq	r0, r0, r8, asr r0
 994:	8b080e42 	blhi	2042a4 <_bss_end+0x1f97c4>
 998:	42018e02 	andmi	r8, r1, #2, 28
 99c:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 9a0:	00080d0c 	andeq	r0, r8, ip, lsl #26
 9a4:	0000000c 	andeq	r0, r0, ip
 9a8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 9ac:	7c020001 	stcvc	0, cr0, [r2], {1}
 9b0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 9b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 9b8:	000009a4 	andeq	r0, r0, r4, lsr #19
 9bc:	00009f4c 	andeq	r9, r0, ip, asr #30
 9c0:	00000174 	andeq	r0, r0, r4, ror r1
 9c4:	8b080e42 	blhi	2042d4 <_bss_end+0x1f97f4>
 9c8:	42018e02 	andmi	r8, r1, #2, 28
 9cc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 9d0:	080d0cb2 	stmdaeq	sp, {r1, r4, r5, r7, sl, fp}
 9d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 9d8:	000009a4 	andeq	r0, r0, r4, lsr #19
 9dc:	0000a0c0 	andeq	sl, r0, r0, asr #1
 9e0:	0000009c 	muleq	r0, ip, r0
 9e4:	8b040e42 	blhi	1042f4 <_bss_end+0xf9814>
 9e8:	0b0d4201 	bleq	3511f4 <_bss_end+0x346714>
 9ec:	0d0d4602 	stceq	6, cr4, [sp, #-8]
 9f0:	000ecb42 	andeq	ip, lr, r2, asr #22
 9f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 9f8:	000009a4 	andeq	r0, r0, r4, lsr #19
 9fc:	0000a15c 	andeq	sl, r0, ip, asr r1
 a00:	000000c0 	andeq	r0, r0, r0, asr #1
 a04:	8b040e42 	blhi	104314 <_bss_end+0xf9834>
 a08:	0b0d4201 	bleq	351214 <_bss_end+0x346734>
 a0c:	0d0d5802 	stceq	8, cr5, [sp, #-8]
 a10:	000ecb42 	andeq	ip, lr, r2, asr #22
 a14:	0000001c 	andeq	r0, r0, ip, lsl r0
 a18:	000009a4 	andeq	r0, r0, r4, lsr #19
 a1c:	0000a21c 	andeq	sl, r0, ip, lsl r2
 a20:	000000ac 	andeq	r0, r0, ip, lsr #1
 a24:	8b040e42 	blhi	104334 <_bss_end+0xf9854>
 a28:	0b0d4201 	bleq	351234 <_bss_end+0x346754>
 a2c:	0d0d4e02 	stceq	14, cr4, [sp, #-8]
 a30:	000ecb42 	andeq	ip, lr, r2, asr #22
 a34:	0000001c 	andeq	r0, r0, ip, lsl r0
 a38:	000009a4 	andeq	r0, r0, r4, lsr #19
 a3c:	0000a2c8 	andeq	sl, r0, r8, asr #5
 a40:	00000054 	andeq	r0, r0, r4, asr r0
 a44:	8b040e42 	blhi	104354 <_bss_end+0xf9874>
 a48:	0b0d4201 	bleq	351254 <_bss_end+0x346774>
 a4c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 a50:	00000ecb 	andeq	r0, r0, fp, asr #29
 a54:	0000001c 	andeq	r0, r0, ip, lsl r0
 a58:	000009a4 	andeq	r0, r0, r4, lsr #19
 a5c:	0000a31c 	andeq	sl, r0, ip, lsl r3
 a60:	00000068 	andeq	r0, r0, r8, rrx
 a64:	8b040e42 	blhi	104374 <_bss_end+0xf9894>
 a68:	0b0d4201 	bleq	351274 <_bss_end+0x346794>
 a6c:	420d0d6c 	andmi	r0, sp, #108, 26	; 0x1b00
 a70:	00000ecb 	andeq	r0, r0, fp, asr #29
 a74:	0000001c 	andeq	r0, r0, ip, lsl r0
 a78:	000009a4 	andeq	r0, r0, r4, lsr #19
 a7c:	0000a384 	andeq	sl, r0, r4, lsl #7
 a80:	00000080 	andeq	r0, r0, r0, lsl #1
 a84:	8b040e42 	blhi	104394 <_bss_end+0xf98b4>
 a88:	0b0d4201 	bleq	351294 <_bss_end+0x3467b4>
 a8c:	420d0d78 	andmi	r0, sp, #120, 26	; 0x1e00
 a90:	00000ecb 	andeq	r0, r0, fp, asr #29
 a94:	0000000c 	andeq	r0, r0, ip
 a98:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 a9c:	7c010001 	stcvc	0, cr0, [r1], {1}
 aa0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 aa4:	0000000c 	andeq	r0, r0, ip
 aa8:	00000a94 	muleq	r0, r4, sl
 aac:	0000a404 	andeq	sl, r0, r4, lsl #8
 ab0:	000001ec 	andeq	r0, r0, ip, ror #3

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
  38:	00009e14 	andeq	r9, r0, r4, lsl lr
  3c:	00009e34 	andeq	r9, r0, r4, lsr lr
	...
