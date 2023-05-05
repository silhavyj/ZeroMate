
./kernel:     file format elf32-littlearm


Disassembly of section .text:

00008000 <_start>:
_start():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:14
	;@	- sem skoci bootloader, prvni na co narazi je "ldr pc, _reset_ptr" -> tedy se chova jako kdyby slo o reset a skoci na zacatek provadeni
	;@	- v cele svoji krase (vsechny "ldr" instrukce) slouzi jako predloha skutecne tabulce vektoru preruseni
	;@ na dany offset procesor skoci, kdyz je vyvolano libovolne preruseni
	;@ ARM nastavuje rovnou registr PC na tuto adresu, tzn. na teto adrese musi byt kodovana 4B instrukce skoku nekam jinam
	;@ oproti tomu napr. x86 (x86_64) obsahuje v tabulce rovnou adresu a procesor nastavuje PC (CS:IP) na adresu kterou najde v tabulce
	ldr pc, _reset_ptr						;@ 0x00 - reset - vyvolano pri resetu procesoru
    8000:	e59ff018 	ldr	pc, [pc, #24]	; 8020 <_reset_ptr>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:15
	ldr pc, _undefined_instruction_ptr		;@ 0x04 - undefined instruction - vyjimka, vyvolana pri dekodovani nezname instrukce
    8004:	e59ff018 	ldr	pc, [pc, #24]	; 8024 <_undefined_instruction_ptr>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:16
	ldr pc, _software_interrupt_ptr			;@ 0x08 - software interrupt - vyvolano, kdyz procesor provede instrukci swi
    8008:	e59ff018 	ldr	pc, [pc, #24]	; 8028 <_software_interrupt_ptr>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:17
	ldr pc, _prefetch_abort_ptr				;@ 0x0C - prefetch abort - vyvolano, kdyz se procesor snazi napr. nacist instrukci z mista, odkud nacist nejde
    800c:	e59ff018 	ldr	pc, [pc, #24]	; 802c <_prefetch_abort_ptr>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:18
	ldr pc, _data_abort_ptr					;@ 0x10 - data abort - vyvolano, kdyz se procesor snazi napr. nacist data z mista, odkud nacist nejdou
    8010:	e59ff018 	ldr	pc, [pc, #24]	; 8030 <_data_abort_ptr>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:19
	ldr pc, _unused_handler_ptr				;@ 0x14 - unused - ve specifikaci ARM neni uvedeno zadne vyuziti
    8014:	e59ff018 	ldr	pc, [pc, #24]	; 8034 <_unused_handler_ptr>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:20
	ldr pc, _irq_ptr						;@ 0x18 - IRQ - hardwarove preruseni (general purpose)
    8018:	e59ff018 	ldr	pc, [pc, #24]	; 8038 <_irq_ptr>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:21
	ldr pc, _fast_interrupt_ptr				;@ 0x1C - fast interrupt request - prioritni IRQ pro vysokorychlostni zalezitosti
    801c:	e59ff018 	ldr	pc, [pc, #24]	; 803c <_fast_interrupt_ptr>

00008020 <_reset_ptr>:
_reset_ptr():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:21
    8020:	00008040 	andeq	r8, r0, r0, asr #32

00008024 <_undefined_instruction_ptr>:
_undefined_instruction_ptr():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:21
    8024:	0000a5c8 	andeq	sl, r0, r8, asr #11

00008028 <_software_interrupt_ptr>:
_software_interrupt_ptr():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:21
    8028:	00009174 	andeq	r9, r0, r4, ror r1

0000802c <_prefetch_abort_ptr>:
_prefetch_abort_ptr():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:21
    802c:	0000a5f4 	strdeq	sl, [r0], -r4

00008030 <_data_abort_ptr>:
_data_abort_ptr():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:21
    8030:	0000a5f8 	strdeq	sl, [r0], -r8

00008034 <_unused_handler_ptr>:
_unused_handler_ptr():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:21
    8034:	00008040 	andeq	r8, r0, r0, asr #32

00008038 <_irq_ptr>:
_irq_ptr():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:21
    8038:	0000a5cc 	andeq	sl, r0, ip, asr #11

0000803c <_fast_interrupt_ptr>:
_fast_interrupt_ptr():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:21
    803c:	000091bc 			; <UNDEFINED> instruction: 0x000091bc

00008040 <_reset>:
_reset():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:52


;@ kernel reset vektor - tento kod se vykona pri kazdem resetu zarizeni (i prvnim spusteni)
_reset:
	;@ nacteni tabulky vektoru preruseni do pameti
	mov r0, #0x8000			;@ adresa 0x8000 (_start) do r0
    8040:	e3a00902 	mov	r0, #32768	; 0x8000
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:53
    mov r1, #0x0000			;@ adresa 0x0000 (pocatek RAM) do r1 - tam budeme vkladat tabulku vektoru preruseni
    8044:	e3a01000 	mov	r1, #0
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:57

	;@ Thumb instrukce - nacteni 4B slov z pameti ulozene v r0 (0x8000) do registru r2, 3, ... 9
	;@                 - ulozeni obsahu registru r2, 3, ... 9 do pameti ulozene v registru r1 (0x0000)
    ldmia r0!,{r2, r3, r4, r5, r6, r7, r8, r9}
    8048:	e8b003fc 	ldm	r0!, {r2, r3, r4, r5, r6, r7, r8, r9}
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:58
    stmia r1!,{r2, r3, r4, r5, r6, r7, r8, r9}
    804c:	e8a103fc 	stmia	r1!, {r2, r3, r4, r5, r6, r7, r8, r9}
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:59
    ldmia r0!,{r2, r3, r4, r5, r6, r7, r8, r9}
    8050:	e8b003fc 	ldm	r0!, {r2, r3, r4, r5, r6, r7, r8, r9}
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:60
    stmia r1!,{r2, r3, r4, r5, r6, r7, r8, r9}
    8054:	e8a103fc 	stmia	r1!, {r2, r3, r4, r5, r6, r7, r8, r9}
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:64

	;@ baze pro systemove zasobniky
	;@ mov r4, #0x80000000
	mov r4, #0
    8058:	e3a04000 	mov	r4, #0
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:67

	;@ nejdrive supervisor mod a jeho stack
    mov r0, #(CPSR_MODE_SVR | CPSR_IRQ_INHIBIT | CPSR_FIQ_INHIBIT)
    805c:	e3a000d3 	mov	r0, #211	; 0xd3
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:68
    msr cpsr_c, r0
    8060:	e121f000 	msr	CPSR_c, r0
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:69
	add sp, r4, #0x8000
    8064:	e284d902 	add	sp, r4, #32768	; 0x8000
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:72

	;@ na moment se prepneme do IRQ rezimu, nastavime mu stack pointer
	mov r0, #(CPSR_MODE_IRQ | CPSR_IRQ_INHIBIT | CPSR_FIQ_INHIBIT)
    8068:	e3a000d2 	mov	r0, #210	; 0xd2
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:73
    msr cpsr_c, r0
    806c:	e121f000 	msr	CPSR_c, r0
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:74
	add sp, r4, #0x7000
    8070:	e284da07 	add	sp, r4, #28672	; 0x7000
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:77

	;@ na moment se prepneme do FIQ rezimu, nastavime mu stack pointer
	mov r0, #(CPSR_MODE_FIQ | CPSR_IRQ_INHIBIT | CPSR_FIQ_INHIBIT)
    8074:	e3a000d1 	mov	r0, #209	; 0xd1
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:78
    msr cpsr_c, r0
    8078:	e121f000 	msr	CPSR_c, r0
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:79
	add sp, r4, #0x6000
    807c:	e284da06 	add	sp, r4, #24576	; 0x6000
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:82

	;@ nakonec system mod a stack
    mov r0, #(CPSR_MODE_SYS | CPSR_IRQ_INHIBIT | CPSR_FIQ_INHIBIT)
    8080:	e3a000df 	mov	r0, #223	; 0xdf
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:83
    msr cpsr_c, r0
    8084:	e121f000 	msr	CPSR_c, r0
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:84
	add sp, r4, #0x5000
    8088:	e284da05 	add	sp, r4, #20480	; 0x5000
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:87

	;@ zapneme nezarovnany pristup do pameti (nemusi byt zadouci, ale pro nase potreby je to v poradku)
    mrc p15, #0, r4, c1, c0, #0
    808c:	ee114f10 	mrc	15, 0, r4, cr1, cr0, {0}
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:88
	orr r4, #0x400000
    8090:	e3844501 	orr	r4, r4, #4194304	; 0x400000
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:89
	mcr p15, #0, r4, c1, c0, #0
    8094:	ee014f10 	mcr	15, 0, r4, cr1, cr0, {0}
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:91

	bl _c_startup			;@ C startup kod (inicializace prostredi)
    8098:	eb000957 	bl	a5fc <_c_startup>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:92
	bl _cpp_startup			;@ C++ startup kod (volani globalnich konstruktoru, ...)
    809c:	eb000970 	bl	a664 <_cpp_startup>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:93
	bl _kernel_main			;@ skocime do hlavniho kodu jadra (v C)
    80a0:	eb00057d 	bl	969c <_kernel_main>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:94
	bl _cpp_shutdown		;@ C++ shutdown kod (volani globalnich destruktoru, ...)
    80a4:	eb000984 	bl	a6bc <_cpp_shutdown>

000080a8 <hang>:
hang():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:96
hang:
	b hang
    80a8:	eafffffe 	b	80a8 <hang>

000080ac <__cxa_guard_acquire>:
__cxa_guard_acquire():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/cxx.cpp:11
	extern "C" int __cxa_guard_acquire (__guard *);
	extern "C" void __cxa_guard_release (__guard *);
	extern "C" void __cxa_guard_abort (__guard *);

	extern "C" int __cxa_guard_acquire (__guard *g)
	{
    80ac:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    80b0:	e28db000 	add	fp, sp, #0
    80b4:	e24dd00c 	sub	sp, sp, #12
    80b8:	e50b0008 	str	r0, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/cxx.cpp:12
		return !*(char *)(g);
    80bc:	e51b3008 	ldr	r3, [fp, #-8]
    80c0:	e5d33000 	ldrb	r3, [r3]
    80c4:	e3530000 	cmp	r3, #0
    80c8:	03a03001 	moveq	r3, #1
    80cc:	13a03000 	movne	r3, #0
    80d0:	e6ef3073 	uxtb	r3, r3
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/cxx.cpp:13
	}
    80d4:	e1a00003 	mov	r0, r3
    80d8:	e28bd000 	add	sp, fp, #0
    80dc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    80e0:	e12fff1e 	bx	lr

000080e4 <__cxa_guard_release>:
__cxa_guard_release():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/cxx.cpp:16

	extern "C" void __cxa_guard_release (__guard *g)
	{
    80e4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    80e8:	e28db000 	add	fp, sp, #0
    80ec:	e24dd00c 	sub	sp, sp, #12
    80f0:	e50b0008 	str	r0, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/cxx.cpp:17
		*(char *)g = 1;
    80f4:	e51b3008 	ldr	r3, [fp, #-8]
    80f8:	e3a02001 	mov	r2, #1
    80fc:	e5c32000 	strb	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/cxx.cpp:18
	}
    8100:	e320f000 	nop	{0}
    8104:	e28bd000 	add	sp, fp, #0
    8108:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    810c:	e12fff1e 	bx	lr

00008110 <__cxa_guard_abort>:
__cxa_guard_abort():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/cxx.cpp:21

	extern "C" void __cxa_guard_abort (__guard *)
	{
    8110:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8114:	e28db000 	add	fp, sp, #0
    8118:	e24dd00c 	sub	sp, sp, #12
    811c:	e50b0008 	str	r0, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/cxx.cpp:23

	}
    8120:	e320f000 	nop	{0}
    8124:	e28bd000 	add	sp, fp, #0
    8128:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    812c:	e12fff1e 	bx	lr

00008130 <__dso_handle>:
__dso_handle():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/cxx.cpp:27
}

extern "C" void __dso_handle()
{
    8130:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8134:	e28db000 	add	fp, sp, #0
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/cxx.cpp:29
    // ignore dtors for now
}
    8138:	e320f000 	nop	{0}
    813c:	e28bd000 	add	sp, fp, #0
    8140:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8144:	e12fff1e 	bx	lr

00008148 <__cxa_atexit>:
__cxa_atexit():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/cxx.cpp:32

extern "C" void __cxa_atexit()
{
    8148:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    814c:	e28db000 	add	fp, sp, #0
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/cxx.cpp:34
    // ignore dtors for now
}
    8150:	e320f000 	nop	{0}
    8154:	e28bd000 	add	sp, fp, #0
    8158:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    815c:	e12fff1e 	bx	lr

00008160 <__cxa_pure_virtual>:
__cxa_pure_virtual():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/cxx.cpp:37

extern "C" void __cxa_pure_virtual()
{
    8160:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8164:	e28db000 	add	fp, sp, #0
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/cxx.cpp:39
    // pure virtual method called
}
    8168:	e320f000 	nop	{0}
    816c:	e28bd000 	add	sp, fp, #0
    8170:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8174:	e12fff1e 	bx	lr

00008178 <__aeabi_unwind_cpp_pr1>:
__aeabi_unwind_cpp_pr1():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/cxx.cpp:42

extern "C" void __aeabi_unwind_cpp_pr1()
{
    8178:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    817c:	e28db000 	add	fp, sp, #0
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/cxx.cpp:43 (discriminator 1)
	while (true)
    8180:	eafffffe 	b	8180 <__aeabi_unwind_cpp_pr1+0x8>

00008184 <_ZN13CGPIO_HandlerC1Ej>:
_ZN13CGPIO_HandlerC2Ej():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:6
#include <hal/peripherals.h>
#include <drivers/gpio.h>

CGPIO_Handler sGPIO(hal::GPIO_Base);

CGPIO_Handler::CGPIO_Handler(unsigned int gpio_base_addr)
    8184:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8188:	e28db000 	add	fp, sp, #0
    818c:	e24dd00c 	sub	sp, sp, #12
    8190:	e50b0008 	str	r0, [fp, #-8]
    8194:	e50b100c 	str	r1, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:7
	: mGPIO(reinterpret_cast<unsigned int*>(gpio_base_addr))
    8198:	e51b200c 	ldr	r2, [fp, #-12]
    819c:	e51b3008 	ldr	r3, [fp, #-8]
    81a0:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:10
{
	//
}
    81a4:	e51b3008 	ldr	r3, [fp, #-8]
    81a8:	e1a00003 	mov	r0, r3
    81ac:	e28bd000 	add	sp, fp, #0
    81b0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    81b4:	e12fff1e 	bx	lr

000081b8 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_>:
_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:13

bool CGPIO_Handler::Get_GPFSEL_Location(uint32_t pin, uint32_t& reg, uint32_t& bit_idx) const
{
    81b8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    81bc:	e28db000 	add	fp, sp, #0
    81c0:	e24dd014 	sub	sp, sp, #20
    81c4:	e50b0008 	str	r0, [fp, #-8]
    81c8:	e50b100c 	str	r1, [fp, #-12]
    81cc:	e50b2010 	str	r2, [fp, #-16]
    81d0:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:14
	if (pin > hal::GPIO_Pin_Count)
    81d4:	e51b300c 	ldr	r3, [fp, #-12]
    81d8:	e3530036 	cmp	r3, #54	; 0x36
    81dc:	9a000001 	bls	81e8 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0x30>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:15
		return false;
    81e0:	e3a03000 	mov	r3, #0
    81e4:	ea000014 	b	823c <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0x84>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:17
	
	reg = pin / 10;
    81e8:	e51b300c 	ldr	r3, [fp, #-12]
    81ec:	e59f2058 	ldr	r2, [pc, #88]	; 824c <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0x94>
    81f0:	e0832392 	umull	r2, r3, r2, r3
    81f4:	e1a021a3 	lsr	r2, r3, #3
    81f8:	e51b3010 	ldr	r3, [fp, #-16]
    81fc:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:28
		case 3: reg = static_cast<uint32_t>(hal::GPIO_Reg::GPFSEL3); break;
		case 4: reg = static_cast<uint32_t>(hal::GPIO_Reg::GPFSEL4); break;
		case 5: reg = static_cast<uint32_t>(hal::GPIO_Reg::GPFSEL5); break;
	}*/
	
	bit_idx = (pin % 10) * 3;
    8200:	e51b100c 	ldr	r1, [fp, #-12]
    8204:	e59f3040 	ldr	r3, [pc, #64]	; 824c <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0x94>
    8208:	e0832193 	umull	r2, r3, r3, r1
    820c:	e1a021a3 	lsr	r2, r3, #3
    8210:	e1a03002 	mov	r3, r2
    8214:	e1a03103 	lsl	r3, r3, #2
    8218:	e0833002 	add	r3, r3, r2
    821c:	e1a03083 	lsl	r3, r3, #1
    8220:	e0412003 	sub	r2, r1, r3
    8224:	e1a03002 	mov	r3, r2
    8228:	e1a03083 	lsl	r3, r3, #1
    822c:	e0832002 	add	r2, r3, r2
    8230:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8234:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:30
	
	return true;
    8238:	e3a03001 	mov	r3, #1
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:31
}
    823c:	e1a00003 	mov	r0, r3
    8240:	e28bd000 	add	sp, fp, #0
    8244:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8248:	e12fff1e 	bx	lr
    824c:	cccccccd 	stclgt	12, cr12, [ip], {205}	; 0xcd

00008250 <_ZNK13CGPIO_Handler18Get_GPCLR_LocationEjRjS0_>:
_ZNK13CGPIO_Handler18Get_GPCLR_LocationEjRjS0_():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:34

bool CGPIO_Handler::Get_GPCLR_Location(uint32_t pin, uint32_t& reg, uint32_t& bit_idx) const
{
    8250:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8254:	e28db000 	add	fp, sp, #0
    8258:	e24dd014 	sub	sp, sp, #20
    825c:	e50b0008 	str	r0, [fp, #-8]
    8260:	e50b100c 	str	r1, [fp, #-12]
    8264:	e50b2010 	str	r2, [fp, #-16]
    8268:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:35
	if (pin > hal::GPIO_Pin_Count)
    826c:	e51b300c 	ldr	r3, [fp, #-12]
    8270:	e3530036 	cmp	r3, #54	; 0x36
    8274:	9a000001 	bls	8280 <_ZNK13CGPIO_Handler18Get_GPCLR_LocationEjRjS0_+0x30>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:36
		return false;
    8278:	e3a03000 	mov	r3, #0
    827c:	ea00000c 	b	82b4 <_ZNK13CGPIO_Handler18Get_GPCLR_LocationEjRjS0_+0x64>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:38
	
	reg = static_cast<uint32_t>((pin < 32) ? hal::GPIO_Reg::GPCLR0 : hal::GPIO_Reg::GPCLR1);
    8280:	e51b300c 	ldr	r3, [fp, #-12]
    8284:	e353001f 	cmp	r3, #31
    8288:	8a000001 	bhi	8294 <_ZNK13CGPIO_Handler18Get_GPCLR_LocationEjRjS0_+0x44>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:38 (discriminator 1)
    828c:	e3a0200a 	mov	r2, #10
    8290:	ea000000 	b	8298 <_ZNK13CGPIO_Handler18Get_GPCLR_LocationEjRjS0_+0x48>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:38 (discriminator 2)
    8294:	e3a0200b 	mov	r2, #11
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:38 (discriminator 4)
    8298:	e51b3010 	ldr	r3, [fp, #-16]
    829c:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:39 (discriminator 4)
	bit_idx = pin % 32;
    82a0:	e51b300c 	ldr	r3, [fp, #-12]
    82a4:	e203201f 	and	r2, r3, #31
    82a8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    82ac:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:41 (discriminator 4)
	
	return true;
    82b0:	e3a03001 	mov	r3, #1
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:42
}
    82b4:	e1a00003 	mov	r0, r3
    82b8:	e28bd000 	add	sp, fp, #0
    82bc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    82c0:	e12fff1e 	bx	lr

000082c4 <_ZNK13CGPIO_Handler18Get_GPSET_LocationEjRjS0_>:
_ZNK13CGPIO_Handler18Get_GPSET_LocationEjRjS0_():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:45

bool CGPIO_Handler::Get_GPSET_Location(uint32_t pin, uint32_t& reg, uint32_t& bit_idx) const
{
    82c4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    82c8:	e28db000 	add	fp, sp, #0
    82cc:	e24dd014 	sub	sp, sp, #20
    82d0:	e50b0008 	str	r0, [fp, #-8]
    82d4:	e50b100c 	str	r1, [fp, #-12]
    82d8:	e50b2010 	str	r2, [fp, #-16]
    82dc:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:46
	if (pin > hal::GPIO_Pin_Count)
    82e0:	e51b300c 	ldr	r3, [fp, #-12]
    82e4:	e3530036 	cmp	r3, #54	; 0x36
    82e8:	9a000001 	bls	82f4 <_ZNK13CGPIO_Handler18Get_GPSET_LocationEjRjS0_+0x30>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:47
		return false;
    82ec:	e3a03000 	mov	r3, #0
    82f0:	ea00000c 	b	8328 <_ZNK13CGPIO_Handler18Get_GPSET_LocationEjRjS0_+0x64>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:49
	
	reg = static_cast<uint32_t>((pin < 32) ? hal::GPIO_Reg::GPSET0 : hal::GPIO_Reg::GPSET1);
    82f4:	e51b300c 	ldr	r3, [fp, #-12]
    82f8:	e353001f 	cmp	r3, #31
    82fc:	8a000001 	bhi	8308 <_ZNK13CGPIO_Handler18Get_GPSET_LocationEjRjS0_+0x44>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:49 (discriminator 1)
    8300:	e3a02007 	mov	r2, #7
    8304:	ea000000 	b	830c <_ZNK13CGPIO_Handler18Get_GPSET_LocationEjRjS0_+0x48>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:49 (discriminator 2)
    8308:	e3a02008 	mov	r2, #8
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:49 (discriminator 4)
    830c:	e51b3010 	ldr	r3, [fp, #-16]
    8310:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:50 (discriminator 4)
	bit_idx = pin % 32;
    8314:	e51b300c 	ldr	r3, [fp, #-12]
    8318:	e203201f 	and	r2, r3, #31
    831c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8320:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:52 (discriminator 4)
	
	return true;
    8324:	e3a03001 	mov	r3, #1
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:53
}
    8328:	e1a00003 	mov	r0, r3
    832c:	e28bd000 	add	sp, fp, #0
    8330:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8334:	e12fff1e 	bx	lr

00008338 <_ZNK13CGPIO_Handler18Get_GPLEV_LocationEjRjS0_>:
_ZNK13CGPIO_Handler18Get_GPLEV_LocationEjRjS0_():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:56

bool CGPIO_Handler::Get_GPLEV_Location(uint32_t pin, uint32_t& reg, uint32_t& bit_idx) const
{
    8338:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    833c:	e28db000 	add	fp, sp, #0
    8340:	e24dd014 	sub	sp, sp, #20
    8344:	e50b0008 	str	r0, [fp, #-8]
    8348:	e50b100c 	str	r1, [fp, #-12]
    834c:	e50b2010 	str	r2, [fp, #-16]
    8350:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:57
	if (pin > hal::GPIO_Pin_Count)
    8354:	e51b300c 	ldr	r3, [fp, #-12]
    8358:	e3530036 	cmp	r3, #54	; 0x36
    835c:	9a000001 	bls	8368 <_ZNK13CGPIO_Handler18Get_GPLEV_LocationEjRjS0_+0x30>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:58
		return false;
    8360:	e3a03000 	mov	r3, #0
    8364:	ea00000c 	b	839c <_ZNK13CGPIO_Handler18Get_GPLEV_LocationEjRjS0_+0x64>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:60
	
	reg = static_cast<uint32_t>((pin < 32) ? hal::GPIO_Reg::GPLEV0 : hal::GPIO_Reg::GPLEV1);
    8368:	e51b300c 	ldr	r3, [fp, #-12]
    836c:	e353001f 	cmp	r3, #31
    8370:	8a000001 	bhi	837c <_ZNK13CGPIO_Handler18Get_GPLEV_LocationEjRjS0_+0x44>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:60 (discriminator 1)
    8374:	e3a0200d 	mov	r2, #13
    8378:	ea000000 	b	8380 <_ZNK13CGPIO_Handler18Get_GPLEV_LocationEjRjS0_+0x48>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:60 (discriminator 2)
    837c:	e3a0200e 	mov	r2, #14
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:60 (discriminator 4)
    8380:	e51b3010 	ldr	r3, [fp, #-16]
    8384:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:61 (discriminator 4)
	bit_idx = pin % 32;
    8388:	e51b300c 	ldr	r3, [fp, #-12]
    838c:	e203201f 	and	r2, r3, #31
    8390:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8394:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:63 (discriminator 4)
	
	return true;
    8398:	e3a03001 	mov	r3, #1
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:64
}
    839c:	e1a00003 	mov	r0, r3
    83a0:	e28bd000 	add	sp, fp, #0
    83a4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    83a8:	e12fff1e 	bx	lr

000083ac <_ZN13CGPIO_Handler17Set_GPIO_FunctionEj14NGPIO_Function>:
_ZN13CGPIO_Handler17Set_GPIO_FunctionEj14NGPIO_Function():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:67
		
void CGPIO_Handler::Set_GPIO_Function(uint32_t pin, NGPIO_Function func)
{
    83ac:	e92d4800 	push	{fp, lr}
    83b0:	e28db004 	add	fp, sp, #4
    83b4:	e24dd020 	sub	sp, sp, #32
    83b8:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    83bc:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    83c0:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:69
	uint32_t reg, bit;
	if (!Get_GPFSEL_Location(pin, reg, bit))
    83c4:	e24b3014 	sub	r3, fp, #20
    83c8:	e24b2010 	sub	r2, fp, #16
    83cc:	e51b101c 	ldr	r1, [fp, #-28]	; 0xffffffe4
    83d0:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    83d4:	ebffff77 	bl	81b8 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_>
    83d8:	e1a03000 	mov	r3, r0
    83dc:	e2233001 	eor	r3, r3, #1
    83e0:	e6ef3073 	uxtb	r3, r3
    83e4:	e3530000 	cmp	r3, #0
    83e8:	1a00001e 	bne	8468 <_ZN13CGPIO_Handler17Set_GPIO_FunctionEj14NGPIO_Function+0xbc>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:72
		return;

	unsigned int mode = static_cast<unsigned int>(func);
    83ec:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    83f0:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:74

	unsigned int rd = mGPIO[reg];
    83f4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    83f8:	e5932000 	ldr	r2, [r3]
    83fc:	e51b3010 	ldr	r3, [fp, #-16]
    8400:	e1a03103 	lsl	r3, r3, #2
    8404:	e0823003 	add	r3, r2, r3
    8408:	e5933000 	ldr	r3, [r3]
    840c:	e50b300c 	str	r3, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:75
	rd &= ~(7 << bit);
    8410:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8414:	e3a02007 	mov	r2, #7
    8418:	e1a03312 	lsl	r3, r2, r3
    841c:	e1e03003 	mvn	r3, r3
    8420:	e1a02003 	mov	r2, r3
    8424:	e51b300c 	ldr	r3, [fp, #-12]
    8428:	e0033002 	and	r3, r3, r2
    842c:	e50b300c 	str	r3, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:76
	rd |= (mode << bit);
    8430:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8434:	e51b2008 	ldr	r2, [fp, #-8]
    8438:	e1a03312 	lsl	r3, r2, r3
    843c:	e51b200c 	ldr	r2, [fp, #-12]
    8440:	e1823003 	orr	r3, r2, r3
    8444:	e50b300c 	str	r3, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:78
	
	mGPIO[reg] = rd;
    8448:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    844c:	e5932000 	ldr	r2, [r3]
    8450:	e51b3010 	ldr	r3, [fp, #-16]
    8454:	e1a03103 	lsl	r3, r3, #2
    8458:	e0823003 	add	r3, r2, r3
    845c:	e51b200c 	ldr	r2, [fp, #-12]
    8460:	e5832000 	str	r2, [r3]
    8464:	ea000000 	b	846c <_ZN13CGPIO_Handler17Set_GPIO_FunctionEj14NGPIO_Function+0xc0>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:70
		return;
    8468:	e320f000 	nop	{0}
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:79
}
    846c:	e24bd004 	sub	sp, fp, #4
    8470:	e8bd8800 	pop	{fp, pc}

00008474 <_ZNK13CGPIO_Handler17Get_GPIO_FunctionEj>:
_ZNK13CGPIO_Handler17Get_GPIO_FunctionEj():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:82

NGPIO_Function CGPIO_Handler::Get_GPIO_Function(uint32_t pin) const
{
    8474:	e92d4800 	push	{fp, lr}
    8478:	e28db004 	add	fp, sp, #4
    847c:	e24dd010 	sub	sp, sp, #16
    8480:	e50b0010 	str	r0, [fp, #-16]
    8484:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:84
	uint32_t reg, bit;
	if (!Get_GPFSEL_Location(pin, reg, bit))
    8488:	e24b300c 	sub	r3, fp, #12
    848c:	e24b2008 	sub	r2, fp, #8
    8490:	e51b1014 	ldr	r1, [fp, #-20]	; 0xffffffec
    8494:	e51b0010 	ldr	r0, [fp, #-16]
    8498:	ebffff46 	bl	81b8 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_>
    849c:	e1a03000 	mov	r3, r0
    84a0:	e2233001 	eor	r3, r3, #1
    84a4:	e6ef3073 	uxtb	r3, r3
    84a8:	e3530000 	cmp	r3, #0
    84ac:	0a000001 	beq	84b8 <_ZNK13CGPIO_Handler17Get_GPIO_FunctionEj+0x44>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:85
		return NGPIO_Function::Unspecified;
    84b0:	e3a03008 	mov	r3, #8
    84b4:	ea000008 	b	84dc <_ZNK13CGPIO_Handler17Get_GPIO_FunctionEj+0x68>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:87
	
	return static_cast<NGPIO_Function>((mGPIO[reg] >> bit) & 7);
    84b8:	e51b3010 	ldr	r3, [fp, #-16]
    84bc:	e5932000 	ldr	r2, [r3]
    84c0:	e51b3008 	ldr	r3, [fp, #-8]
    84c4:	e1a03103 	lsl	r3, r3, #2
    84c8:	e0823003 	add	r3, r2, r3
    84cc:	e5932000 	ldr	r2, [r3]
    84d0:	e51b300c 	ldr	r3, [fp, #-12]
    84d4:	e1a03332 	lsr	r3, r2, r3
    84d8:	e2033007 	and	r3, r3, #7
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:88 (discriminator 1)
}
    84dc:	e1a00003 	mov	r0, r3
    84e0:	e24bd004 	sub	sp, fp, #4
    84e4:	e8bd8800 	pop	{fp, pc}

000084e8 <_ZN13CGPIO_Handler10Set_OutputEjb>:
_ZN13CGPIO_Handler10Set_OutputEjb():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:91

void CGPIO_Handler::Set_Output(uint32_t pin, bool set)
{
    84e8:	e92d4800 	push	{fp, lr}
    84ec:	e28db004 	add	fp, sp, #4
    84f0:	e24dd018 	sub	sp, sp, #24
    84f4:	e50b0010 	str	r0, [fp, #-16]
    84f8:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    84fc:	e1a03002 	mov	r3, r2
    8500:	e54b3015 	strb	r3, [fp, #-21]	; 0xffffffeb
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:93
	uint32_t reg, bit;
	if (!(set && Get_GPSET_Location(pin, reg, bit)) && !(!set && Get_GPCLR_Location(pin, reg, bit)))
    8504:	e55b3015 	ldrb	r3, [fp, #-21]	; 0xffffffeb
    8508:	e2233001 	eor	r3, r3, #1
    850c:	e6ef3073 	uxtb	r3, r3
    8510:	e3530000 	cmp	r3, #0
    8514:	1a000009 	bne	8540 <_ZN13CGPIO_Handler10Set_OutputEjb+0x58>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:93 (discriminator 2)
    8518:	e24b300c 	sub	r3, fp, #12
    851c:	e24b2008 	sub	r2, fp, #8
    8520:	e51b1014 	ldr	r1, [fp, #-20]	; 0xffffffec
    8524:	e51b0010 	ldr	r0, [fp, #-16]
    8528:	ebffff65 	bl	82c4 <_ZNK13CGPIO_Handler18Get_GPSET_LocationEjRjS0_>
    852c:	e1a03000 	mov	r3, r0
    8530:	e2233001 	eor	r3, r3, #1
    8534:	e6ef3073 	uxtb	r3, r3
    8538:	e3530000 	cmp	r3, #0
    853c:	0a00000e 	beq	857c <_ZN13CGPIO_Handler10Set_OutputEjb+0x94>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:93 (discriminator 3)
    8540:	e55b3015 	ldrb	r3, [fp, #-21]	; 0xffffffeb
    8544:	e3530000 	cmp	r3, #0
    8548:	1a000009 	bne	8574 <_ZN13CGPIO_Handler10Set_OutputEjb+0x8c>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:93 (discriminator 6)
    854c:	e24b300c 	sub	r3, fp, #12
    8550:	e24b2008 	sub	r2, fp, #8
    8554:	e51b1014 	ldr	r1, [fp, #-20]	; 0xffffffec
    8558:	e51b0010 	ldr	r0, [fp, #-16]
    855c:	ebffff3b 	bl	8250 <_ZNK13CGPIO_Handler18Get_GPCLR_LocationEjRjS0_>
    8560:	e1a03000 	mov	r3, r0
    8564:	e2233001 	eor	r3, r3, #1
    8568:	e6ef3073 	uxtb	r3, r3
    856c:	e3530000 	cmp	r3, #0
    8570:	0a000001 	beq	857c <_ZN13CGPIO_Handler10Set_OutputEjb+0x94>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:93 (discriminator 7)
    8574:	e3a03001 	mov	r3, #1
    8578:	ea000000 	b	8580 <_ZN13CGPIO_Handler10Set_OutputEjb+0x98>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:93 (discriminator 8)
    857c:	e3a03000 	mov	r3, #0
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:93 (discriminator 10)
    8580:	e3530000 	cmp	r3, #0
    8584:	1a00000a 	bne	85b4 <_ZN13CGPIO_Handler10Set_OutputEjb+0xcc>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:96
		return;
	
	mGPIO[reg] = (1 << bit);
    8588:	e51b300c 	ldr	r3, [fp, #-12]
    858c:	e3a02001 	mov	r2, #1
    8590:	e1a01312 	lsl	r1, r2, r3
    8594:	e51b3010 	ldr	r3, [fp, #-16]
    8598:	e5932000 	ldr	r2, [r3]
    859c:	e51b3008 	ldr	r3, [fp, #-8]
    85a0:	e1a03103 	lsl	r3, r3, #2
    85a4:	e0823003 	add	r3, r2, r3
    85a8:	e1a02001 	mov	r2, r1
    85ac:	e5832000 	str	r2, [r3]
    85b0:	ea000000 	b	85b8 <_ZN13CGPIO_Handler10Set_OutputEjb+0xd0>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:94
		return;
    85b4:	e320f000 	nop	{0}
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:97
}
    85b8:	e24bd004 	sub	sp, fp, #4
    85bc:	e8bd8800 	pop	{fp, pc}

000085c0 <_ZN13CGPIO_Handler9Get_InputEj>:
_ZN13CGPIO_Handler9Get_InputEj():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:100

bool CGPIO_Handler::Get_Input(uint32_t pin)
{
    85c0:	e92d4800 	push	{fp, lr}
    85c4:	e28db004 	add	fp, sp, #4
    85c8:	e24dd010 	sub	sp, sp, #16
    85cc:	e50b0010 	str	r0, [fp, #-16]
    85d0:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:102
	uint32_t reg, bit;
	if (!Get_GPLEV_Location(pin, reg, bit))
    85d4:	e24b300c 	sub	r3, fp, #12
    85d8:	e24b2008 	sub	r2, fp, #8
    85dc:	e51b1014 	ldr	r1, [fp, #-20]	; 0xffffffec
    85e0:	e51b0010 	ldr	r0, [fp, #-16]
    85e4:	ebffff53 	bl	8338 <_ZNK13CGPIO_Handler18Get_GPLEV_LocationEjRjS0_>
    85e8:	e1a03000 	mov	r3, r0
    85ec:	e2233001 	eor	r3, r3, #1
    85f0:	e6ef3073 	uxtb	r3, r3
    85f4:	e3530000 	cmp	r3, #0
    85f8:	0a000001 	beq	8604 <_ZN13CGPIO_Handler9Get_InputEj+0x44>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:103
		return false;
    85fc:	e3a03000 	mov	r3, #0
    8600:	ea00000c 	b	8638 <_ZN13CGPIO_Handler9Get_InputEj+0x78>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:105
	
	return (mGPIO[reg] >> bit) & 0x1;
    8604:	e51b3010 	ldr	r3, [fp, #-16]
    8608:	e5932000 	ldr	r2, [r3]
    860c:	e51b3008 	ldr	r3, [fp, #-8]
    8610:	e1a03103 	lsl	r3, r3, #2
    8614:	e0823003 	add	r3, r2, r3
    8618:	e5932000 	ldr	r2, [r3]
    861c:	e51b300c 	ldr	r3, [fp, #-12]
    8620:	e1a03332 	lsr	r3, r2, r3
    8624:	e2033001 	and	r3, r3, #1
    8628:	e3530000 	cmp	r3, #0
    862c:	13a03001 	movne	r3, #1
    8630:	03a03000 	moveq	r3, #0
    8634:	e6ef3073 	uxtb	r3, r3
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:106 (discriminator 1)
}
    8638:	e1a00003 	mov	r0, r3
    863c:	e24bd004 	sub	sp, fp, #4
    8640:	e8bd8800 	pop	{fp, pc}

00008644 <_Z41__static_initialization_and_destruction_0ii>:
_Z41__static_initialization_and_destruction_0ii():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:106
    8644:	e92d4800 	push	{fp, lr}
    8648:	e28db004 	add	fp, sp, #4
    864c:	e24dd008 	sub	sp, sp, #8
    8650:	e50b0008 	str	r0, [fp, #-8]
    8654:	e50b100c 	str	r1, [fp, #-12]
    8658:	e51b3008 	ldr	r3, [fp, #-8]
    865c:	e3530001 	cmp	r3, #1
    8660:	1a000006 	bne	8680 <_Z41__static_initialization_and_destruction_0ii+0x3c>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:106 (discriminator 1)
    8664:	e51b300c 	ldr	r3, [fp, #-12]
    8668:	e59f201c 	ldr	r2, [pc, #28]	; 868c <_Z41__static_initialization_and_destruction_0ii+0x48>
    866c:	e1530002 	cmp	r3, r2
    8670:	1a000002 	bne	8680 <_Z41__static_initialization_and_destruction_0ii+0x3c>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:4
CGPIO_Handler sGPIO(hal::GPIO_Base);
    8674:	e59f1014 	ldr	r1, [pc, #20]	; 8690 <_Z41__static_initialization_and_destruction_0ii+0x4c>
    8678:	e59f0014 	ldr	r0, [pc, #20]	; 8694 <_Z41__static_initialization_and_destruction_0ii+0x50>
    867c:	ebfffec0 	bl	8184 <_ZN13CGPIO_HandlerC1Ej>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:106
}
    8680:	e320f000 	nop	{0}
    8684:	e24bd004 	sub	sp, fp, #4
    8688:	e8bd8800 	pop	{fp, pc}
    868c:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>
    8690:	20200000 	eorcs	r0, r0, r0
    8694:	0000ae08 	andeq	sl, r0, r8, lsl #28

00008698 <_GLOBAL__sub_I_sGPIO>:
_GLOBAL__sub_I_sGPIO():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/gpio.cpp:106
    8698:	e92d4800 	push	{fp, lr}
    869c:	e28db004 	add	fp, sp, #4
    86a0:	e59f1008 	ldr	r1, [pc, #8]	; 86b0 <_GLOBAL__sub_I_sGPIO+0x18>
    86a4:	e3a00001 	mov	r0, #1
    86a8:	ebffffe5 	bl	8644 <_Z41__static_initialization_and_destruction_0ii>
    86ac:	e8bd8800 	pop	{fp, pc}
    86b0:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>

000086b4 <_ZN8CMonitorC1Ejjj>:
_ZN8CMonitorC2Ejjj():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:5
#include <drivers/monitor.h>

CMonitor sMonitor{ 0x30000000, 80, 25 };

CMonitor::CMonitor(unsigned int monitor_base_addr, unsigned int width, unsigned int height)
    86b4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    86b8:	e28db000 	add	fp, sp, #0
    86bc:	e24dd014 	sub	sp, sp, #20
    86c0:	e50b0008 	str	r0, [fp, #-8]
    86c4:	e50b100c 	str	r1, [fp, #-12]
    86c8:	e50b2010 	str	r2, [fp, #-16]
    86cc:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:6
: m_monitor{ reinterpret_cast<unsigned char*>(monitor_base_addr) }
    86d0:	e51b200c 	ldr	r2, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:10
, m_width{ width }
, m_height{ height }
, m_cursor{ 0, 0 }
, m_number_base{ DEFAULT_NUMBER_BASE }
    86d4:	e51b3008 	ldr	r3, [fp, #-8]
    86d8:	e5832000 	str	r2, [r3]
    86dc:	e51b3008 	ldr	r3, [fp, #-8]
    86e0:	e51b2010 	ldr	r2, [fp, #-16]
    86e4:	e5832004 	str	r2, [r3, #4]
    86e8:	e51b3008 	ldr	r3, [fp, #-8]
    86ec:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    86f0:	e5832008 	str	r2, [r3, #8]
    86f4:	e51b3008 	ldr	r3, [fp, #-8]
    86f8:	e3a02000 	mov	r2, #0
    86fc:	e583200c 	str	r2, [r3, #12]
    8700:	e51b3008 	ldr	r3, [fp, #-8]
    8704:	e3a02000 	mov	r2, #0
    8708:	e5832010 	str	r2, [r3, #16]
    870c:	e51b3008 	ldr	r3, [fp, #-8]
    8710:	e3a0200a 	mov	r2, #10
    8714:	e5832014 	str	r2, [r3, #20]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:12
{
}
    8718:	e51b3008 	ldr	r3, [fp, #-8]
    871c:	e1a00003 	mov	r0, r3
    8720:	e28bd000 	add	sp, fp, #0
    8724:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8728:	e12fff1e 	bx	lr

0000872c <_ZN8CMonitor5ClearEv>:
_ZN8CMonitor5ClearEv():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:21
    m_cursor.y = 0;
    m_cursor.y = 0;
}

void CMonitor::Clear()
{
    872c:	e92d4800 	push	{fp, lr}
    8730:	e28db004 	add	fp, sp, #4
    8734:	e24dd010 	sub	sp, sp, #16
    8738:	e50b0010 	str	r0, [fp, #-16]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:22
    Reset_Cursor();
    873c:	e51b0010 	ldr	r0, [fp, #-16]
    8740:	eb000169 	bl	8cec <_ZN8CMonitor12Reset_CursorEv>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:24

    for (unsigned int y = 0; y < m_height; ++y)
    8744:	e3a03000 	mov	r3, #0
    8748:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:24 (discriminator 1)
    874c:	e51b3010 	ldr	r3, [fp, #-16]
    8750:	e5933008 	ldr	r3, [r3, #8]
    8754:	e51b2008 	ldr	r2, [fp, #-8]
    8758:	e1520003 	cmp	r2, r3
    875c:	2a000019 	bcs	87c8 <_ZN8CMonitor5ClearEv+0x9c>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:26
    {
        for (unsigned int x = 0; x < m_width; ++x)
    8760:	e3a03000 	mov	r3, #0
    8764:	e50b300c 	str	r3, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:26 (discriminator 3)
    8768:	e51b3010 	ldr	r3, [fp, #-16]
    876c:	e5933004 	ldr	r3, [r3, #4]
    8770:	e51b200c 	ldr	r2, [fp, #-12]
    8774:	e1520003 	cmp	r2, r3
    8778:	2a00000e 	bcs	87b8 <_ZN8CMonitor5ClearEv+0x8c>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:28 (discriminator 2)
        {
            m_monitor[(y * m_width) + x] = ' ';
    877c:	e51b3010 	ldr	r3, [fp, #-16]
    8780:	e5932000 	ldr	r2, [r3]
    8784:	e51b3010 	ldr	r3, [fp, #-16]
    8788:	e5933004 	ldr	r3, [r3, #4]
    878c:	e51b1008 	ldr	r1, [fp, #-8]
    8790:	e0010391 	mul	r1, r1, r3
    8794:	e51b300c 	ldr	r3, [fp, #-12]
    8798:	e0813003 	add	r3, r1, r3
    879c:	e0823003 	add	r3, r2, r3
    87a0:	e3a02020 	mov	r2, #32
    87a4:	e5c32000 	strb	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:26 (discriminator 2)
        for (unsigned int x = 0; x < m_width; ++x)
    87a8:	e51b300c 	ldr	r3, [fp, #-12]
    87ac:	e2833001 	add	r3, r3, #1
    87b0:	e50b300c 	str	r3, [fp, #-12]
    87b4:	eaffffeb 	b	8768 <_ZN8CMonitor5ClearEv+0x3c>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:24 (discriminator 2)
    for (unsigned int y = 0; y < m_height; ++y)
    87b8:	e51b3008 	ldr	r3, [fp, #-8]
    87bc:	e2833001 	add	r3, r3, #1
    87c0:	e50b3008 	str	r3, [fp, #-8]
    87c4:	eaffffe0 	b	874c <_ZN8CMonitor5ClearEv+0x20>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:31
        }
    }
}
    87c8:	e320f000 	nop	{0}
    87cc:	e24bd004 	sub	sp, fp, #4
    87d0:	e8bd8800 	pop	{fp, pc}

000087d4 <_ZN8CMonitor6ScrollEv>:
_ZN8CMonitor6ScrollEv():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:49
        m_cursor.y = m_height - 1;
    }
}

void CMonitor::Scroll()
{
    87d4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    87d8:	e28db000 	add	fp, sp, #0
    87dc:	e24dd01c 	sub	sp, sp, #28
    87e0:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:50
    for (unsigned int y = 1; y < m_height; ++y)
    87e4:	e3a03001 	mov	r3, #1
    87e8:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:50 (discriminator 1)
    87ec:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    87f0:	e5933008 	ldr	r3, [r3, #8]
    87f4:	e51b2008 	ldr	r2, [fp, #-8]
    87f8:	e1520003 	cmp	r2, r3
    87fc:	2a000024 	bcs	8894 <_ZN8CMonitor6ScrollEv+0xc0>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:52
    {
        for (unsigned int x = 0; x < m_width; ++x)
    8800:	e3a03000 	mov	r3, #0
    8804:	e50b300c 	str	r3, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:52 (discriminator 3)
    8808:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    880c:	e5933004 	ldr	r3, [r3, #4]
    8810:	e51b200c 	ldr	r2, [fp, #-12]
    8814:	e1520003 	cmp	r2, r3
    8818:	2a000019 	bcs	8884 <_ZN8CMonitor6ScrollEv+0xb0>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:54 (discriminator 2)
        {
            m_monitor[((y - 1) * m_width) + x] = m_monitor[(y * m_width) + x];
    881c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8820:	e5932000 	ldr	r2, [r3]
    8824:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8828:	e5933004 	ldr	r3, [r3, #4]
    882c:	e51b1008 	ldr	r1, [fp, #-8]
    8830:	e0010391 	mul	r1, r1, r3
    8834:	e51b300c 	ldr	r3, [fp, #-12]
    8838:	e0813003 	add	r3, r1, r3
    883c:	e0822003 	add	r2, r2, r3
    8840:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8844:	e5931000 	ldr	r1, [r3]
    8848:	e51b3008 	ldr	r3, [fp, #-8]
    884c:	e2433001 	sub	r3, r3, #1
    8850:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    8854:	e5900004 	ldr	r0, [r0, #4]
    8858:	e0000390 	mul	r0, r0, r3
    885c:	e51b300c 	ldr	r3, [fp, #-12]
    8860:	e0803003 	add	r3, r0, r3
    8864:	e0813003 	add	r3, r1, r3
    8868:	e5d22000 	ldrb	r2, [r2]
    886c:	e6ef2072 	uxtb	r2, r2
    8870:	e5c32000 	strb	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:52 (discriminator 2)
        for (unsigned int x = 0; x < m_width; ++x)
    8874:	e51b300c 	ldr	r3, [fp, #-12]
    8878:	e2833001 	add	r3, r3, #1
    887c:	e50b300c 	str	r3, [fp, #-12]
    8880:	eaffffe0 	b	8808 <_ZN8CMonitor6ScrollEv+0x34>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:50 (discriminator 2)
    for (unsigned int y = 1; y < m_height; ++y)
    8884:	e51b3008 	ldr	r3, [fp, #-8]
    8888:	e2833001 	add	r3, r3, #1
    888c:	e50b3008 	str	r3, [fp, #-8]
    8890:	eaffffd5 	b	87ec <_ZN8CMonitor6ScrollEv+0x18>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:58
        }
    }

    for (unsigned int x = 0; x < m_width; ++x)
    8894:	e3a03000 	mov	r3, #0
    8898:	e50b3010 	str	r3, [fp, #-16]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:58 (discriminator 3)
    889c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    88a0:	e5933004 	ldr	r3, [r3, #4]
    88a4:	e51b2010 	ldr	r2, [fp, #-16]
    88a8:	e1520003 	cmp	r2, r3
    88ac:	2a000010 	bcs	88f4 <_ZN8CMonitor6ScrollEv+0x120>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:60 (discriminator 2)
    {
        m_monitor[((m_height - 1) * m_width) + x] = ' ';
    88b0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    88b4:	e5932000 	ldr	r2, [r3]
    88b8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    88bc:	e5933008 	ldr	r3, [r3, #8]
    88c0:	e2433001 	sub	r3, r3, #1
    88c4:	e51b1018 	ldr	r1, [fp, #-24]	; 0xffffffe8
    88c8:	e5911004 	ldr	r1, [r1, #4]
    88cc:	e0010391 	mul	r1, r1, r3
    88d0:	e51b3010 	ldr	r3, [fp, #-16]
    88d4:	e0813003 	add	r3, r1, r3
    88d8:	e0823003 	add	r3, r2, r3
    88dc:	e3a02020 	mov	r2, #32
    88e0:	e5c32000 	strb	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:58 (discriminator 2)
    for (unsigned int x = 0; x < m_width; ++x)
    88e4:	e51b3010 	ldr	r3, [fp, #-16]
    88e8:	e2833001 	add	r3, r3, #1
    88ec:	e50b3010 	str	r3, [fp, #-16]
    88f0:	eaffffe9 	b	889c <_ZN8CMonitor6ScrollEv+0xc8>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:62
    }
}
    88f4:	e320f000 	nop	{0}
    88f8:	e28bd000 	add	sp, fp, #0
    88fc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8900:	e12fff1e 	bx	lr

00008904 <_ZN8CMonitorlsEc>:
_ZN8CMonitorlsEc():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:70
{
    m_number_base = DEFAULT_NUMBER_BASE;
}

CMonitor& CMonitor::operator<<(char c)
{
    8904:	e92d4800 	push	{fp, lr}
    8908:	e28db004 	add	fp, sp, #4
    890c:	e24dd008 	sub	sp, sp, #8
    8910:	e50b0008 	str	r0, [fp, #-8]
    8914:	e1a03001 	mov	r3, r1
    8918:	e54b3009 	strb	r3, [fp, #-9]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:71
    if (c != '\n')
    891c:	e55b3009 	ldrb	r3, [fp, #-9]
    8920:	e353000a 	cmp	r3, #10
    8924:	0a000012 	beq	8974 <_ZN8CMonitorlsEc+0x70>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:73
    {
        m_monitor[(m_cursor.y * m_width) + m_cursor.x] = static_cast<unsigned char>(c);
    8928:	e51b3008 	ldr	r3, [fp, #-8]
    892c:	e5932000 	ldr	r2, [r3]
    8930:	e51b3008 	ldr	r3, [fp, #-8]
    8934:	e593300c 	ldr	r3, [r3, #12]
    8938:	e51b1008 	ldr	r1, [fp, #-8]
    893c:	e5911004 	ldr	r1, [r1, #4]
    8940:	e0010391 	mul	r1, r1, r3
    8944:	e51b3008 	ldr	r3, [fp, #-8]
    8948:	e5933010 	ldr	r3, [r3, #16]
    894c:	e0813003 	add	r3, r1, r3
    8950:	e0823003 	add	r3, r2, r3
    8954:	e55b2009 	ldrb	r2, [fp, #-9]
    8958:	e5c32000 	strb	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:74
        ++m_cursor.x;
    895c:	e51b3008 	ldr	r3, [fp, #-8]
    8960:	e5933010 	ldr	r3, [r3, #16]
    8964:	e2832001 	add	r2, r3, #1
    8968:	e51b3008 	ldr	r3, [fp, #-8]
    896c:	e5832010 	str	r2, [r3, #16]
    8970:	ea000007 	b	8994 <_ZN8CMonitorlsEc+0x90>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:78
    }
    else
    {
        m_cursor.x = 0;
    8974:	e51b3008 	ldr	r3, [fp, #-8]
    8978:	e3a02000 	mov	r2, #0
    897c:	e5832010 	str	r2, [r3, #16]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:79
        ++m_cursor.y;
    8980:	e51b3008 	ldr	r3, [fp, #-8]
    8984:	e593300c 	ldr	r3, [r3, #12]
    8988:	e2832001 	add	r2, r3, #1
    898c:	e51b3008 	ldr	r3, [fp, #-8]
    8990:	e583200c 	str	r2, [r3, #12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:82
    }

    Adjust_Cursor();
    8994:	e51b0008 	ldr	r0, [fp, #-8]
    8998:	eb0000e1 	bl	8d24 <_ZN8CMonitor13Adjust_CursorEv>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:84

    return *this;
    899c:	e51b3008 	ldr	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:85
}
    89a0:	e1a00003 	mov	r0, r3
    89a4:	e24bd004 	sub	sp, fp, #4
    89a8:	e8bd8800 	pop	{fp, pc}

000089ac <_ZN8CMonitorlsEPKc>:
_ZN8CMonitorlsEPKc():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:88

CMonitor& CMonitor::operator<<(const char* str)
{
    89ac:	e92d4800 	push	{fp, lr}
    89b0:	e28db004 	add	fp, sp, #4
    89b4:	e24dd010 	sub	sp, sp, #16
    89b8:	e50b0010 	str	r0, [fp, #-16]
    89bc:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:89
    for (unsigned int i = 0; str[i] != '\0'; ++i)
    89c0:	e3a03000 	mov	r3, #0
    89c4:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:89 (discriminator 3)
    89c8:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    89cc:	e51b3008 	ldr	r3, [fp, #-8]
    89d0:	e0823003 	add	r3, r2, r3
    89d4:	e5d33000 	ldrb	r3, [r3]
    89d8:	e3530000 	cmp	r3, #0
    89dc:	0a00000a 	beq	8a0c <_ZN8CMonitorlsEPKc+0x60>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:91 (discriminator 2)
    {
        *this << str[i];
    89e0:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    89e4:	e51b3008 	ldr	r3, [fp, #-8]
    89e8:	e0823003 	add	r3, r2, r3
    89ec:	e5d33000 	ldrb	r3, [r3]
    89f0:	e1a01003 	mov	r1, r3
    89f4:	e51b0010 	ldr	r0, [fp, #-16]
    89f8:	ebffffc1 	bl	8904 <_ZN8CMonitorlsEc>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:89 (discriminator 2)
    for (unsigned int i = 0; str[i] != '\0'; ++i)
    89fc:	e51b3008 	ldr	r3, [fp, #-8]
    8a00:	e2833001 	add	r3, r3, #1
    8a04:	e50b3008 	str	r3, [fp, #-8]
    8a08:	eaffffee 	b	89c8 <_ZN8CMonitorlsEPKc+0x1c>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:94
    }

    Reset_Number_Base();
    8a0c:	e51b0010 	ldr	r0, [fp, #-16]
    8a10:	eb0000e5 	bl	8dac <_ZN8CMonitor17Reset_Number_BaseEv>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:96

    return *this;
    8a14:	e51b3010 	ldr	r3, [fp, #-16]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:97
}
    8a18:	e1a00003 	mov	r0, r3
    8a1c:	e24bd004 	sub	sp, fp, #4
    8a20:	e8bd8800 	pop	{fp, pc}

00008a24 <_ZN8CMonitorlsENS_12NNumber_BaseE>:
_ZN8CMonitorlsENS_12NNumber_BaseE():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:100

CMonitor& CMonitor::operator<<(CMonitor::NNumber_Base number_base)
{
    8a24:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8a28:	e28db000 	add	fp, sp, #0
    8a2c:	e24dd00c 	sub	sp, sp, #12
    8a30:	e50b0008 	str	r0, [fp, #-8]
    8a34:	e50b100c 	str	r1, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:101
    m_number_base = number_base;
    8a38:	e51b3008 	ldr	r3, [fp, #-8]
    8a3c:	e51b200c 	ldr	r2, [fp, #-12]
    8a40:	e5832014 	str	r2, [r3, #20]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:103

    return *this;
    8a44:	e51b3008 	ldr	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:104
}
    8a48:	e1a00003 	mov	r0, r3
    8a4c:	e28bd000 	add	sp, fp, #0
    8a50:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8a54:	e12fff1e 	bx	lr

00008a58 <_ZN8CMonitorlsEj>:
_ZN8CMonitorlsEj():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:107

CMonitor& CMonitor::operator<<(unsigned int num)
{
    8a58:	e92d4800 	push	{fp, lr}
    8a5c:	e28db004 	add	fp, sp, #4
    8a60:	e24dd008 	sub	sp, sp, #8
    8a64:	e50b0008 	str	r0, [fp, #-8]
    8a68:	e50b100c 	str	r1, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:112
    static constexpr unsigned int BUFFER_SIZE = 16;

    static char s_buffer[BUFFER_SIZE];

    itoa(num, s_buffer, static_cast<unsigned int>(m_number_base));
    8a6c:	e51b3008 	ldr	r3, [fp, #-8]
    8a70:	e5933014 	ldr	r3, [r3, #20]
    8a74:	e59f202c 	ldr	r2, [pc, #44]	; 8aa8 <_ZN8CMonitorlsEj+0x50>
    8a78:	e51b100c 	ldr	r1, [fp, #-12]
    8a7c:	e51b0008 	ldr	r0, [fp, #-8]
    8a80:	eb000021 	bl	8b0c <_ZN8CMonitor4itoaEjPcj>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:113
    *this << s_buffer;
    8a84:	e59f101c 	ldr	r1, [pc, #28]	; 8aa8 <_ZN8CMonitorlsEj+0x50>
    8a88:	e51b0008 	ldr	r0, [fp, #-8]
    8a8c:	ebffffc6 	bl	89ac <_ZN8CMonitorlsEPKc>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:114
    Reset_Number_Base();
    8a90:	e51b0008 	ldr	r0, [fp, #-8]
    8a94:	eb0000c4 	bl	8dac <_ZN8CMonitor17Reset_Number_BaseEv>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:116

    return *this;
    8a98:	e51b3008 	ldr	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:117
}
    8a9c:	e1a00003 	mov	r0, r3
    8aa0:	e24bd004 	sub	sp, fp, #4
    8aa4:	e8bd8800 	pop	{fp, pc}
    8aa8:	0000ae24 	andeq	sl, r0, r4, lsr #28

00008aac <_ZN8CMonitorlsEb>:
_ZN8CMonitorlsEb():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:120

CMonitor& CMonitor::operator<<(bool value)
{
    8aac:	e92d4800 	push	{fp, lr}
    8ab0:	e28db004 	add	fp, sp, #4
    8ab4:	e24dd008 	sub	sp, sp, #8
    8ab8:	e50b0008 	str	r0, [fp, #-8]
    8abc:	e1a03001 	mov	r3, r1
    8ac0:	e54b3009 	strb	r3, [fp, #-9]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:121
    if (value)
    8ac4:	e55b3009 	ldrb	r3, [fp, #-9]
    8ac8:	e3530000 	cmp	r3, #0
    8acc:	0a000003 	beq	8ae0 <_ZN8CMonitorlsEb+0x34>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:123
    {
        *this << "true";
    8ad0:	e59f102c 	ldr	r1, [pc, #44]	; 8b04 <_ZN8CMonitorlsEb+0x58>
    8ad4:	e51b0008 	ldr	r0, [fp, #-8]
    8ad8:	ebffffb3 	bl	89ac <_ZN8CMonitorlsEPKc>
    8adc:	ea000002 	b	8aec <_ZN8CMonitorlsEb+0x40>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:127
    }
    else
    {
        *this << "false";
    8ae0:	e59f1020 	ldr	r1, [pc, #32]	; 8b08 <_ZN8CMonitorlsEb+0x5c>
    8ae4:	e51b0008 	ldr	r0, [fp, #-8]
    8ae8:	ebffffaf 	bl	89ac <_ZN8CMonitorlsEPKc>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:130
    }

    Reset_Number_Base();
    8aec:	e51b0008 	ldr	r0, [fp, #-8]
    8af0:	eb0000ad 	bl	8dac <_ZN8CMonitor17Reset_Number_BaseEv>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:132

    return *this;
    8af4:	e51b3008 	ldr	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:133
}
    8af8:	e1a00003 	mov	r0, r3
    8afc:	e24bd004 	sub	sp, fp, #4
    8b00:	e8bd8800 	pop	{fp, pc}
    8b04:	0000ac44 	andeq	sl, r0, r4, asr #24
    8b08:	0000ac4c 	andeq	sl, r0, ip, asr #24

00008b0c <_ZN8CMonitor4itoaEjPcj>:
_ZN8CMonitor4itoaEjPcj():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:178

    return a;
}

void CMonitor::itoa(unsigned int input, char* output, unsigned int base)
{
    8b0c:	e92d4800 	push	{fp, lr}
    8b10:	e28db004 	add	fp, sp, #4
    8b14:	e24dd020 	sub	sp, sp, #32
    8b18:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8b1c:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    8b20:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    8b24:	e50b3024 	str	r3, [fp, #-36]	; 0xffffffdc
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:179
    int i = 0;
    8b28:	e3a03000 	mov	r3, #0
    8b2c:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:181

    while (input > 0)
    8b30:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8b34:	e3530000 	cmp	r3, #0
    8b38:	0a000014 	beq	8b90 <_ZN8CMonitor4itoaEjPcj+0x84>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:183
    {
        output[i] = CharConvArr[Remainder(input, base)];
    8b3c:	e51b2024 	ldr	r2, [fp, #-36]	; 0xffffffdc
    8b40:	e51b101c 	ldr	r1, [fp, #-28]	; 0xffffffe4
    8b44:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    8b48:	eb0000c6 	bl	8e68 <_ZN8CMonitor9RemainderEjj>
    8b4c:	e1a03000 	mov	r3, r0
    8b50:	e59f211c 	ldr	r2, [pc, #284]	; 8c74 <_ZN8CMonitor4itoaEjPcj+0x168>
    8b54:	e0832002 	add	r2, r3, r2
    8b58:	e51b3008 	ldr	r3, [fp, #-8]
    8b5c:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    8b60:	e0813003 	add	r3, r1, r3
    8b64:	e5d22000 	ldrb	r2, [r2]
    8b68:	e5c32000 	strb	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:184
        input = Divide(input, base);
    8b6c:	e51b2024 	ldr	r2, [fp, #-36]	; 0xffffffdc
    8b70:	e51b101c 	ldr	r1, [fp, #-28]	; 0xffffffe4
    8b74:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    8b78:	eb000096 	bl	8dd8 <_ZN8CMonitor6DivideEjj>
    8b7c:	e50b001c 	str	r0, [fp, #-28]	; 0xffffffe4
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:185
        i++;
    8b80:	e51b3008 	ldr	r3, [fp, #-8]
    8b84:	e2833001 	add	r3, r3, #1
    8b88:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:181
    while (input > 0)
    8b8c:	eaffffe7 	b	8b30 <_ZN8CMonitor4itoaEjPcj+0x24>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:188
    }

    if (i == 0)
    8b90:	e51b3008 	ldr	r3, [fp, #-8]
    8b94:	e3530000 	cmp	r3, #0
    8b98:	1a000007 	bne	8bbc <_ZN8CMonitor4itoaEjPcj+0xb0>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:190
    {
        output[i] = CharConvArr[0];
    8b9c:	e51b3008 	ldr	r3, [fp, #-8]
    8ba0:	e51b2020 	ldr	r2, [fp, #-32]	; 0xffffffe0
    8ba4:	e0823003 	add	r3, r2, r3
    8ba8:	e3a02030 	mov	r2, #48	; 0x30
    8bac:	e5c32000 	strb	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:191
        i++;
    8bb0:	e51b3008 	ldr	r3, [fp, #-8]
    8bb4:	e2833001 	add	r3, r3, #1
    8bb8:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:194
    }

    output[i] = '\0';
    8bbc:	e51b3008 	ldr	r3, [fp, #-8]
    8bc0:	e51b2020 	ldr	r2, [fp, #-32]	; 0xffffffe0
    8bc4:	e0823003 	add	r3, r2, r3
    8bc8:	e3a02000 	mov	r2, #0
    8bcc:	e5c32000 	strb	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:195
    i--;
    8bd0:	e51b3008 	ldr	r3, [fp, #-8]
    8bd4:	e2433001 	sub	r3, r3, #1
    8bd8:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:197

    for (int j = 0; j <= (i >> 1); j++)
    8bdc:	e3a03000 	mov	r3, #0
    8be0:	e50b300c 	str	r3, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:197 (discriminator 3)
    8be4:	e51b3008 	ldr	r3, [fp, #-8]
    8be8:	e1a030c3 	asr	r3, r3, #1
    8bec:	e51b200c 	ldr	r2, [fp, #-12]
    8bf0:	e1520003 	cmp	r2, r3
    8bf4:	ca00001b 	bgt	8c68 <_ZN8CMonitor4itoaEjPcj+0x15c>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:199 (discriminator 2)
    {
        char c = output[i - j];
    8bf8:	e51b2008 	ldr	r2, [fp, #-8]
    8bfc:	e51b300c 	ldr	r3, [fp, #-12]
    8c00:	e0423003 	sub	r3, r2, r3
    8c04:	e1a02003 	mov	r2, r3
    8c08:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8c0c:	e0833002 	add	r3, r3, r2
    8c10:	e5d33000 	ldrb	r3, [r3]
    8c14:	e54b300d 	strb	r3, [fp, #-13]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:200 (discriminator 2)
        output[i - j] = output[j];
    8c18:	e51b300c 	ldr	r3, [fp, #-12]
    8c1c:	e51b2020 	ldr	r2, [fp, #-32]	; 0xffffffe0
    8c20:	e0822003 	add	r2, r2, r3
    8c24:	e51b1008 	ldr	r1, [fp, #-8]
    8c28:	e51b300c 	ldr	r3, [fp, #-12]
    8c2c:	e0413003 	sub	r3, r1, r3
    8c30:	e1a01003 	mov	r1, r3
    8c34:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8c38:	e0833001 	add	r3, r3, r1
    8c3c:	e5d22000 	ldrb	r2, [r2]
    8c40:	e5c32000 	strb	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:201 (discriminator 2)
        output[j] = c;
    8c44:	e51b300c 	ldr	r3, [fp, #-12]
    8c48:	e51b2020 	ldr	r2, [fp, #-32]	; 0xffffffe0
    8c4c:	e0823003 	add	r3, r2, r3
    8c50:	e55b200d 	ldrb	r2, [fp, #-13]
    8c54:	e5c32000 	strb	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:197 (discriminator 2)
    for (int j = 0; j <= (i >> 1); j++)
    8c58:	e51b300c 	ldr	r3, [fp, #-12]
    8c5c:	e2833001 	add	r3, r3, #1
    8c60:	e50b300c 	str	r3, [fp, #-12]
    8c64:	eaffffde 	b	8be4 <_ZN8CMonitor4itoaEjPcj+0xd8>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:203
    }
}
    8c68:	e320f000 	nop	{0}
    8c6c:	e24bd004 	sub	sp, fp, #4
    8c70:	e8bd8800 	pop	{fp, pc}
    8c74:	0000ac54 	andeq	sl, r0, r4, asr ip

00008c78 <_Z41__static_initialization_and_destruction_0ii>:
_Z41__static_initialization_and_destruction_0ii():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:203
    8c78:	e92d4800 	push	{fp, lr}
    8c7c:	e28db004 	add	fp, sp, #4
    8c80:	e24dd008 	sub	sp, sp, #8
    8c84:	e50b0008 	str	r0, [fp, #-8]
    8c88:	e50b100c 	str	r1, [fp, #-12]
    8c8c:	e51b3008 	ldr	r3, [fp, #-8]
    8c90:	e3530001 	cmp	r3, #1
    8c94:	1a000008 	bne	8cbc <_Z41__static_initialization_and_destruction_0ii+0x44>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:203 (discriminator 1)
    8c98:	e51b300c 	ldr	r3, [fp, #-12]
    8c9c:	e59f2024 	ldr	r2, [pc, #36]	; 8cc8 <_Z41__static_initialization_and_destruction_0ii+0x50>
    8ca0:	e1530002 	cmp	r3, r2
    8ca4:	1a000004 	bne	8cbc <_Z41__static_initialization_and_destruction_0ii+0x44>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:3
CMonitor sMonitor{ 0x30000000, 80, 25 };
    8ca8:	e3a03019 	mov	r3, #25
    8cac:	e3a02050 	mov	r2, #80	; 0x50
    8cb0:	e3a01203 	mov	r1, #805306368	; 0x30000000
    8cb4:	e59f0010 	ldr	r0, [pc, #16]	; 8ccc <_Z41__static_initialization_and_destruction_0ii+0x54>
    8cb8:	ebfffe7d 	bl	86b4 <_ZN8CMonitorC1Ejjj>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:203
}
    8cbc:	e320f000 	nop	{0}
    8cc0:	e24bd004 	sub	sp, fp, #4
    8cc4:	e8bd8800 	pop	{fp, pc}
    8cc8:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>
    8ccc:	0000ae0c 	andeq	sl, r0, ip, lsl #28

00008cd0 <_GLOBAL__sub_I_sMonitor>:
_GLOBAL__sub_I_sMonitor():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:203
    8cd0:	e92d4800 	push	{fp, lr}
    8cd4:	e28db004 	add	fp, sp, #4
    8cd8:	e59f1008 	ldr	r1, [pc, #8]	; 8ce8 <_GLOBAL__sub_I_sMonitor+0x18>
    8cdc:	e3a00001 	mov	r0, #1
    8ce0:	ebffffe4 	bl	8c78 <_Z41__static_initialization_and_destruction_0ii>
    8ce4:	e8bd8800 	pop	{fp, pc}
    8ce8:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>

00008cec <_ZN8CMonitor12Reset_CursorEv>:
_ZN8CMonitor12Reset_CursorEv():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:15
{
    8cec:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8cf0:	e28db000 	add	fp, sp, #0
    8cf4:	e24dd00c 	sub	sp, sp, #12
    8cf8:	e50b0008 	str	r0, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:16
    m_cursor.y = 0;
    8cfc:	e51b3008 	ldr	r3, [fp, #-8]
    8d00:	e3a02000 	mov	r2, #0
    8d04:	e583200c 	str	r2, [r3, #12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:17
    m_cursor.y = 0;
    8d08:	e51b3008 	ldr	r3, [fp, #-8]
    8d0c:	e3a02000 	mov	r2, #0
    8d10:	e583200c 	str	r2, [r3, #12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:18
}
    8d14:	e320f000 	nop	{0}
    8d18:	e28bd000 	add	sp, fp, #0
    8d1c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8d20:	e12fff1e 	bx	lr

00008d24 <_ZN8CMonitor13Adjust_CursorEv>:
_ZN8CMonitor13Adjust_CursorEv():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:34
{
    8d24:	e92d4800 	push	{fp, lr}
    8d28:	e28db004 	add	fp, sp, #4
    8d2c:	e24dd008 	sub	sp, sp, #8
    8d30:	e50b0008 	str	r0, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:35
    if (m_cursor.x >= m_width)
    8d34:	e51b3008 	ldr	r3, [fp, #-8]
    8d38:	e5932010 	ldr	r2, [r3, #16]
    8d3c:	e51b3008 	ldr	r3, [fp, #-8]
    8d40:	e5933004 	ldr	r3, [r3, #4]
    8d44:	e1520003 	cmp	r2, r3
    8d48:	3a000007 	bcc	8d6c <_ZN8CMonitor13Adjust_CursorEv+0x48>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:37
        m_cursor.x = 0;
    8d4c:	e51b3008 	ldr	r3, [fp, #-8]
    8d50:	e3a02000 	mov	r2, #0
    8d54:	e5832010 	str	r2, [r3, #16]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:38
        ++m_cursor.y;
    8d58:	e51b3008 	ldr	r3, [fp, #-8]
    8d5c:	e593300c 	ldr	r3, [r3, #12]
    8d60:	e2832001 	add	r2, r3, #1
    8d64:	e51b3008 	ldr	r3, [fp, #-8]
    8d68:	e583200c 	str	r2, [r3, #12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:41
    if (m_cursor.y >= m_height)
    8d6c:	e51b3008 	ldr	r3, [fp, #-8]
    8d70:	e593200c 	ldr	r2, [r3, #12]
    8d74:	e51b3008 	ldr	r3, [fp, #-8]
    8d78:	e5933008 	ldr	r3, [r3, #8]
    8d7c:	e1520003 	cmp	r2, r3
    8d80:	3a000006 	bcc	8da0 <_ZN8CMonitor13Adjust_CursorEv+0x7c>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:43
        Scroll();
    8d84:	e51b0008 	ldr	r0, [fp, #-8]
    8d88:	ebfffe91 	bl	87d4 <_ZN8CMonitor6ScrollEv>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:44
        m_cursor.y = m_height - 1;
    8d8c:	e51b3008 	ldr	r3, [fp, #-8]
    8d90:	e5933008 	ldr	r3, [r3, #8]
    8d94:	e2432001 	sub	r2, r3, #1
    8d98:	e51b3008 	ldr	r3, [fp, #-8]
    8d9c:	e583200c 	str	r2, [r3, #12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:46
}
    8da0:	e320f000 	nop	{0}
    8da4:	e24bd004 	sub	sp, fp, #4
    8da8:	e8bd8800 	pop	{fp, pc}

00008dac <_ZN8CMonitor17Reset_Number_BaseEv>:
_ZN8CMonitor17Reset_Number_BaseEv():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:65
{
    8dac:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8db0:	e28db000 	add	fp, sp, #0
    8db4:	e24dd00c 	sub	sp, sp, #12
    8db8:	e50b0008 	str	r0, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:66
    m_number_base = DEFAULT_NUMBER_BASE;
    8dbc:	e51b3008 	ldr	r3, [fp, #-8]
    8dc0:	e3a0200a 	mov	r2, #10
    8dc4:	e5832014 	str	r2, [r3, #20]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:67
}
    8dc8:	e320f000 	nop	{0}
    8dcc:	e28bd000 	add	sp, fp, #0
    8dd0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8dd4:	e12fff1e 	bx	lr

00008dd8 <_ZN8CMonitor6DivideEjj>:
_ZN8CMonitor6DivideEjj():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:136
{
    8dd8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8ddc:	e28db000 	add	fp, sp, #0
    8de0:	e24dd01c 	sub	sp, sp, #28
    8de4:	e50b0010 	str	r0, [fp, #-16]
    8de8:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8dec:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:137
    if (b == 0)
    8df0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8df4:	e3530000 	cmp	r3, #0
    8df8:	1a000001 	bne	8e04 <_ZN8CMonitor6DivideEjj+0x2c>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:140
        return 0;
    8dfc:	e3a03000 	mov	r3, #0
    8e00:	ea000014 	b	8e58 <_ZN8CMonitor6DivideEjj+0x80>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:142
    if (a < b)
    8e04:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8e08:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8e0c:	e1520003 	cmp	r2, r3
    8e10:	2a000001 	bcs	8e1c <_ZN8CMonitor6DivideEjj+0x44>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:144
        return 0;
    8e14:	e3a03000 	mov	r3, #0
    8e18:	ea00000e 	b	8e58 <_ZN8CMonitor6DivideEjj+0x80>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:147
    unsigned int quotient = 0;
    8e1c:	e3a03000 	mov	r3, #0
    8e20:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:149
    while (a >= b)
    8e24:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8e28:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8e2c:	e1520003 	cmp	r2, r3
    8e30:	3a000007 	bcc	8e54 <_ZN8CMonitor6DivideEjj+0x7c>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:151
        a -= b;
    8e34:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8e38:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8e3c:	e0423003 	sub	r3, r2, r3
    8e40:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:152
        quotient++;
    8e44:	e51b3008 	ldr	r3, [fp, #-8]
    8e48:	e2833001 	add	r3, r3, #1
    8e4c:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:149
    while (a >= b)
    8e50:	eafffff3 	b	8e24 <_ZN8CMonitor6DivideEjj+0x4c>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:155
    return quotient;
    8e54:	e51b3008 	ldr	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:156
}
    8e58:	e1a00003 	mov	r0, r3
    8e5c:	e28bd000 	add	sp, fp, #0
    8e60:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8e64:	e12fff1e 	bx	lr

00008e68 <_ZN8CMonitor9RemainderEjj>:
_ZN8CMonitor9RemainderEjj():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:159
{
    8e68:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8e6c:	e28db000 	add	fp, sp, #0
    8e70:	e24dd014 	sub	sp, sp, #20
    8e74:	e50b0008 	str	r0, [fp, #-8]
    8e78:	e50b100c 	str	r1, [fp, #-12]
    8e7c:	e50b2010 	str	r2, [fp, #-16]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:160
    if (b == 0)
    8e80:	e51b3010 	ldr	r3, [fp, #-16]
    8e84:	e3530000 	cmp	r3, #0
    8e88:	1a000001 	bne	8e94 <_ZN8CMonitor9RemainderEjj+0x2c>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:163
        return 0;
    8e8c:	e3a03000 	mov	r3, #0
    8e90:	ea00000f 	b	8ed4 <_ZN8CMonitor9RemainderEjj+0x6c>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:165
    if (a < b)
    8e94:	e51b200c 	ldr	r2, [fp, #-12]
    8e98:	e51b3010 	ldr	r3, [fp, #-16]
    8e9c:	e1520003 	cmp	r2, r3
    8ea0:	2a000001 	bcs	8eac <_ZN8CMonitor9RemainderEjj+0x44>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:167
        return a;
    8ea4:	e51b300c 	ldr	r3, [fp, #-12]
    8ea8:	ea000009 	b	8ed4 <_ZN8CMonitor9RemainderEjj+0x6c>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:169
    while (a >= b)
    8eac:	e51b200c 	ldr	r2, [fp, #-12]
    8eb0:	e51b3010 	ldr	r3, [fp, #-16]
    8eb4:	e1520003 	cmp	r2, r3
    8eb8:	3a000004 	bcc	8ed0 <_ZN8CMonitor9RemainderEjj+0x68>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:171
        a -= b;
    8ebc:	e51b200c 	ldr	r2, [fp, #-12]
    8ec0:	e51b3010 	ldr	r3, [fp, #-16]
    8ec4:	e0423003 	sub	r3, r2, r3
    8ec8:	e50b300c 	str	r3, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:169
    while (a >= b)
    8ecc:	eafffff6 	b	8eac <_ZN8CMonitor9RemainderEjj+0x44>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:174
    return a;
    8ed0:	e51b300c 	ldr	r3, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:175
}
    8ed4:	e1a00003 	mov	r0, r3
    8ed8:	e28bd000 	add	sp, fp, #0
    8edc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8ee0:	e12fff1e 	bx	lr

00008ee4 <_ZN6CTimerC1Em>:
_ZN6CTimerC2Em():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/timer.cpp:26
    uint16_t unused_4 : 10;
};

#pragma pack(pop)

CTimer::CTimer(unsigned long timer_reg_base)
    8ee4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8ee8:	e28db000 	add	fp, sp, #0
    8eec:	e24dd00c 	sub	sp, sp, #12
    8ef0:	e50b0008 	str	r0, [fp, #-8]
    8ef4:	e50b100c 	str	r1, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/timer.cpp:27
    : mTimer_Regs(reinterpret_cast<unsigned int*>(timer_reg_base)), mCallback(nullptr)
    8ef8:	e51b200c 	ldr	r2, [fp, #-12]
    8efc:	e51b3008 	ldr	r3, [fp, #-8]
    8f00:	e5832000 	str	r2, [r3]
    8f04:	e51b3008 	ldr	r3, [fp, #-8]
    8f08:	e3a02000 	mov	r2, #0
    8f0c:	e5832004 	str	r2, [r3, #4]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/timer.cpp:30
{
    //
}
    8f10:	e51b3008 	ldr	r3, [fp, #-8]
    8f14:	e1a00003 	mov	r0, r3
    8f18:	e28bd000 	add	sp, fp, #0
    8f1c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8f20:	e12fff1e 	bx	lr

00008f24 <_ZN6CTimer4RegsEN3hal9Timer_RegE>:
_ZN6CTimer4RegsEN3hal9Timer_RegE():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/timer.cpp:33

volatile unsigned int& CTimer::Regs(hal::Timer_Reg reg)
{
    8f24:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8f28:	e28db000 	add	fp, sp, #0
    8f2c:	e24dd00c 	sub	sp, sp, #12
    8f30:	e50b0008 	str	r0, [fp, #-8]
    8f34:	e50b100c 	str	r1, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/timer.cpp:34
    return mTimer_Regs[static_cast<unsigned int>(reg)];
    8f38:	e51b3008 	ldr	r3, [fp, #-8]
    8f3c:	e5932000 	ldr	r2, [r3]
    8f40:	e51b300c 	ldr	r3, [fp, #-12]
    8f44:	e1a03103 	lsl	r3, r3, #2
    8f48:	e0823003 	add	r3, r2, r3
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/timer.cpp:35
}
    8f4c:	e1a00003 	mov	r0, r3
    8f50:	e28bd000 	add	sp, fp, #0
    8f54:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8f58:	e12fff1e 	bx	lr

00008f5c <_ZN6CTimer6EnableEPFvvEj16NTimer_Prescaler>:
_ZN6CTimer6EnableEPFvvEj16NTimer_Prescaler():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/timer.cpp:38

void CTimer::Enable(TTimer_Callback callback, unsigned int delay, NTimer_Prescaler prescaler)
{
    8f5c:	e92d4810 	push	{r4, fp, lr}
    8f60:	e28db008 	add	fp, sp, #8
    8f64:	e24dd01c 	sub	sp, sp, #28
    8f68:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8f6c:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    8f70:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    8f74:	e54b3021 	strb	r3, [fp, #-33]	; 0xffffffdf
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/timer.cpp:39
    Regs(hal::Timer_Reg::Load) = delay;
    8f78:	e3a01000 	mov	r1, #0
    8f7c:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    8f80:	ebffffe7 	bl	8f24 <_ZN6CTimer4RegsEN3hal9Timer_RegE>
    8f84:	e1a02000 	mov	r2, r0
    8f88:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8f8c:	e5823000 	str	r3, [r2]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/timer.cpp:42

    TTimer_Ctl_Flags reg;
    reg.counter_32b = 1;
    8f90:	e55b3014 	ldrb	r3, [fp, #-20]	; 0xffffffec
    8f94:	e3833002 	orr	r3, r3, #2
    8f98:	e54b3014 	strb	r3, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/timer.cpp:43
    reg.interrupt_enabled = 1;
    8f9c:	e55b3014 	ldrb	r3, [fp, #-20]	; 0xffffffec
    8fa0:	e3833020 	orr	r3, r3, #32
    8fa4:	e54b3014 	strb	r3, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/timer.cpp:44
    reg.timer_enabled = 1;
    8fa8:	e55b3014 	ldrb	r3, [fp, #-20]	; 0xffffffec
    8fac:	e3833080 	orr	r3, r3, #128	; 0x80
    8fb0:	e54b3014 	strb	r3, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/timer.cpp:45
    reg.prescaler = static_cast<uint8_t>(prescaler);
    8fb4:	e55b3021 	ldrb	r3, [fp, #-33]	; 0xffffffdf
    8fb8:	e2033003 	and	r3, r3, #3
    8fbc:	e6ef3073 	uxtb	r3, r3
    8fc0:	e55b2014 	ldrb	r2, [fp, #-20]	; 0xffffffec
    8fc4:	e2033003 	and	r3, r3, #3
    8fc8:	e3c2200c 	bic	r2, r2, #12
    8fcc:	e1a03103 	lsl	r3, r3, #2
    8fd0:	e1833002 	orr	r3, r3, r2
    8fd4:	e1a02003 	mov	r2, r3
    8fd8:	e54b2014 	strb	r2, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/timer.cpp:47

    Regs(hal::Timer_Reg::Control) = *reinterpret_cast<unsigned int*>(&reg);
    8fdc:	e24b4014 	sub	r4, fp, #20
    8fe0:	e3a01002 	mov	r1, #2
    8fe4:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    8fe8:	ebffffcd 	bl	8f24 <_ZN6CTimer4RegsEN3hal9Timer_RegE>
    8fec:	e1a02000 	mov	r2, r0
    8ff0:	e5943000 	ldr	r3, [r4]
    8ff4:	e5823000 	str	r3, [r2]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/timer.cpp:49
   
    Regs(hal::Timer_Reg::IRQ_Clear) = 1;
    8ff8:	e3a01003 	mov	r1, #3
    8ffc:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    9000:	ebffffc7 	bl	8f24 <_ZN6CTimer4RegsEN3hal9Timer_RegE>
    9004:	e1a03000 	mov	r3, r0
    9008:	e3a02001 	mov	r2, #1
    900c:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/timer.cpp:51

    mCallback = callback;
    9010:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9014:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    9018:	e5832004 	str	r2, [r3, #4]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/timer.cpp:52
}
    901c:	e320f000 	nop	{0}
    9020:	e24bd008 	sub	sp, fp, #8
    9024:	e8bd8810 	pop	{r4, fp, pc}

00009028 <_ZN6CTimer7DisableEv>:
_ZN6CTimer7DisableEv():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/timer.cpp:55

void CTimer::Disable()
{
    9028:	e92d4800 	push	{fp, lr}
    902c:	e28db004 	add	fp, sp, #4
    9030:	e24dd010 	sub	sp, sp, #16
    9034:	e50b0010 	str	r0, [fp, #-16]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/timer.cpp:56
    volatile TTimer_Ctl_Flags& reg = reinterpret_cast<volatile TTimer_Ctl_Flags&>(Regs(hal::Timer_Reg::Control));
    9038:	e3a01002 	mov	r1, #2
    903c:	e51b0010 	ldr	r0, [fp, #-16]
    9040:	ebffffb7 	bl	8f24 <_ZN6CTimer4RegsEN3hal9Timer_RegE>
    9044:	e50b0008 	str	r0, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/timer.cpp:58

    reg.interrupt_enabled = 0;
    9048:	e51b2008 	ldr	r2, [fp, #-8]
    904c:	e5d23000 	ldrb	r3, [r2]
    9050:	e3c33020 	bic	r3, r3, #32
    9054:	e5c23000 	strb	r3, [r2]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/timer.cpp:59
    reg.timer_enabled = 0;
    9058:	e51b2008 	ldr	r2, [fp, #-8]
    905c:	e5d23000 	ldrb	r3, [r2]
    9060:	e3c33080 	bic	r3, r3, #128	; 0x80
    9064:	e5c23000 	strb	r3, [r2]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/timer.cpp:60
}
    9068:	e320f000 	nop	{0}
    906c:	e24bd004 	sub	sp, fp, #4
    9070:	e8bd8800 	pop	{fp, pc}

00009074 <_ZN6CTimer12IRQ_CallbackEv>:
_ZN6CTimer12IRQ_CallbackEv():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/timer.cpp:63

void CTimer::IRQ_Callback()
{
    9074:	e92d4800 	push	{fp, lr}
    9078:	e28db004 	add	fp, sp, #4
    907c:	e24dd008 	sub	sp, sp, #8
    9080:	e50b0008 	str	r0, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/timer.cpp:64
    Regs(hal::Timer_Reg::IRQ_Clear) = 1;
    9084:	e3a01003 	mov	r1, #3
    9088:	e51b0008 	ldr	r0, [fp, #-8]
    908c:	ebffffa4 	bl	8f24 <_ZN6CTimer4RegsEN3hal9Timer_RegE>
    9090:	e1a03000 	mov	r3, r0
    9094:	e3a02001 	mov	r2, #1
    9098:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/timer.cpp:66

    if (mCallback)
    909c:	e51b3008 	ldr	r3, [fp, #-8]
    90a0:	e5933004 	ldr	r3, [r3, #4]
    90a4:	e3530000 	cmp	r3, #0
    90a8:	0a000002 	beq	90b8 <_ZN6CTimer12IRQ_CallbackEv+0x44>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/timer.cpp:67
        mCallback();
    90ac:	e51b3008 	ldr	r3, [fp, #-8]
    90b0:	e5933004 	ldr	r3, [r3, #4]
    90b4:	e12fff33 	blx	r3
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/timer.cpp:68
}
    90b8:	e320f000 	nop	{0}
    90bc:	e24bd004 	sub	sp, fp, #4
    90c0:	e8bd8800 	pop	{fp, pc}

000090c4 <_ZN6CTimer20Is_Timer_IRQ_PendingEv>:
_ZN6CTimer20Is_Timer_IRQ_PendingEv():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/timer.cpp:71

bool CTimer::Is_Timer_IRQ_Pending()
{
    90c4:	e92d4800 	push	{fp, lr}
    90c8:	e28db004 	add	fp, sp, #4
    90cc:	e24dd008 	sub	sp, sp, #8
    90d0:	e50b0008 	str	r0, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/timer.cpp:72
    return Regs(hal::Timer_Reg::IRQ_Masked);
    90d4:	e3a01005 	mov	r1, #5
    90d8:	e51b0008 	ldr	r0, [fp, #-8]
    90dc:	ebffff90 	bl	8f24 <_ZN6CTimer4RegsEN3hal9Timer_RegE>
    90e0:	e1a03000 	mov	r3, r0
    90e4:	e5933000 	ldr	r3, [r3]
    90e8:	e3530000 	cmp	r3, #0
    90ec:	13a03001 	movne	r3, #1
    90f0:	03a03000 	moveq	r3, #0
    90f4:	e6ef3073 	uxtb	r3, r3
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/timer.cpp:73
}
    90f8:	e1a00003 	mov	r0, r3
    90fc:	e24bd004 	sub	sp, fp, #4
    9100:	e8bd8800 	pop	{fp, pc}

00009104 <_Z41__static_initialization_and_destruction_0ii>:
_Z41__static_initialization_and_destruction_0ii():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/timer.cpp:73
    9104:	e92d4800 	push	{fp, lr}
    9108:	e28db004 	add	fp, sp, #4
    910c:	e24dd008 	sub	sp, sp, #8
    9110:	e50b0008 	str	r0, [fp, #-8]
    9114:	e50b100c 	str	r1, [fp, #-12]
    9118:	e51b3008 	ldr	r3, [fp, #-8]
    911c:	e3530001 	cmp	r3, #1
    9120:	1a000006 	bne	9140 <_Z41__static_initialization_and_destruction_0ii+0x3c>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/timer.cpp:73 (discriminator 1)
    9124:	e51b300c 	ldr	r3, [fp, #-12]
    9128:	e59f201c 	ldr	r2, [pc, #28]	; 914c <_Z41__static_initialization_and_destruction_0ii+0x48>
    912c:	e1530002 	cmp	r3, r2
    9130:	1a000002 	bne	9140 <_Z41__static_initialization_and_destruction_0ii+0x3c>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/timer.cpp:4
CTimer sTimer(hal::Timer_Base);
    9134:	e59f1014 	ldr	r1, [pc, #20]	; 9150 <_Z41__static_initialization_and_destruction_0ii+0x4c>
    9138:	e59f0014 	ldr	r0, [pc, #20]	; 9154 <_Z41__static_initialization_and_destruction_0ii+0x50>
    913c:	ebffff68 	bl	8ee4 <_ZN6CTimerC1Em>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/timer.cpp:73
}
    9140:	e320f000 	nop	{0}
    9144:	e24bd004 	sub	sp, fp, #4
    9148:	e8bd8800 	pop	{fp, pc}
    914c:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>
    9150:	2000b400 	andcs	fp, r0, r0, lsl #8
    9154:	0000ae34 	andeq	sl, r0, r4, lsr lr

00009158 <_GLOBAL__sub_I_sTimer>:
_GLOBAL__sub_I_sTimer():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/timer.cpp:73
    9158:	e92d4800 	push	{fp, lr}
    915c:	e28db004 	add	fp, sp, #4
    9160:	e59f1008 	ldr	r1, [pc, #8]	; 9170 <_GLOBAL__sub_I_sTimer+0x18>
    9164:	e3a00001 	mov	r0, #1
    9168:	ebffffe5 	bl	9104 <_Z41__static_initialization_and_destruction_0ii>
    916c:	e8bd8800 	pop	{fp, pc}
    9170:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>

00009174 <software_interrupt_handler>:
software_interrupt_handler():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/interrupt_controller.cpp:12
CInterrupt_Controller sInterruptCtl(hal::Interrupt_Controller_Base);

// handlery jednotlivych zdroju preruseni

extern "C" void __attribute__((interrupt("SWI"))) software_interrupt_handler()
{
    9174:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9178:	e28db000 	add	fp, sp, #0
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/interrupt_controller.cpp:14
    // tady nekdy v budoucnu definujeme obsluhu volani sluzeb jadra z uzivatelskeho procesu
}
    917c:	e320f000 	nop	{0}
    9180:	e28bd000 	add	sp, fp, #0
    9184:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9188:	e1b0f00e 	movs	pc, lr

0000918c <_internal_irq_handler>:
_internal_irq_handler():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/interrupt_controller.cpp:17

extern "C" void _internal_irq_handler()
{
    918c:	e92d4800 	push	{fp, lr}
    9190:	e28db004 	add	fp, sp, #4
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/interrupt_controller.cpp:22
    // jelikoz ARM nerozlisuje zdroje IRQ implicitne, ani nezarucuje, ze se navzajen nemaskuji, musime
    // projit vsechny mozne zdroje a podivat se (poll), zda nebylo vyvolano preruseni

    // casovac
    if (sTimer.Is_Timer_IRQ_Pending())
    9194:	e59f001c 	ldr	r0, [pc, #28]	; 91b8 <_internal_irq_handler+0x2c>
    9198:	ebffffc9 	bl	90c4 <_ZN6CTimer20Is_Timer_IRQ_PendingEv>
    919c:	e1a03000 	mov	r3, r0
    91a0:	e3530000 	cmp	r3, #0
    91a4:	0a000001 	beq	91b0 <_internal_irq_handler+0x24>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/interrupt_controller.cpp:23
        sTimer.IRQ_Callback();
    91a8:	e59f0008 	ldr	r0, [pc, #8]	; 91b8 <_internal_irq_handler+0x2c>
    91ac:	ebffffb0 	bl	9074 <_ZN6CTimer12IRQ_CallbackEv>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/interrupt_controller.cpp:24
}
    91b0:	e320f000 	nop	{0}
    91b4:	e8bd8800 	pop	{fp, pc}
    91b8:	0000ae34 	andeq	sl, r0, r4, lsr lr

000091bc <fast_interrupt_handler>:
fast_interrupt_handler():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/interrupt_controller.cpp:27

extern "C" void __attribute__((interrupt("FIQ"))) fast_interrupt_handler()
{
    91bc:	e24db004 	sub	fp, sp, #4
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/interrupt_controller.cpp:29
    // zatim nepouzivame
}
    91c0:	e320f000 	nop	{0}
    91c4:	e28bd004 	add	sp, fp, #4
    91c8:	e25ef004 	subs	pc, lr, #4

000091cc <_ZN21CInterrupt_ControllerC1Em>:
_ZN21CInterrupt_ControllerC2Em():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/interrupt_controller.cpp:33

// implementace controlleru

CInterrupt_Controller::CInterrupt_Controller(unsigned long base)
    91cc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    91d0:	e28db000 	add	fp, sp, #0
    91d4:	e24dd00c 	sub	sp, sp, #12
    91d8:	e50b0008 	str	r0, [fp, #-8]
    91dc:	e50b100c 	str	r1, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/interrupt_controller.cpp:34
    : mInterrupt_Regs(reinterpret_cast<unsigned int*>(base))
    91e0:	e51b200c 	ldr	r2, [fp, #-12]
    91e4:	e51b3008 	ldr	r3, [fp, #-8]
    91e8:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/interrupt_controller.cpp:37
{
    //
}
    91ec:	e51b3008 	ldr	r3, [fp, #-8]
    91f0:	e1a00003 	mov	r0, r3
    91f4:	e28bd000 	add	sp, fp, #0
    91f8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    91fc:	e12fff1e 	bx	lr

00009200 <_ZN21CInterrupt_Controller4RegsEN3hal24Interrupt_Controller_RegE>:
_ZN21CInterrupt_Controller4RegsEN3hal24Interrupt_Controller_RegE():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/interrupt_controller.cpp:40

volatile unsigned int& CInterrupt_Controller::Regs(hal::Interrupt_Controller_Reg reg)
{
    9200:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9204:	e28db000 	add	fp, sp, #0
    9208:	e24dd00c 	sub	sp, sp, #12
    920c:	e50b0008 	str	r0, [fp, #-8]
    9210:	e50b100c 	str	r1, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/interrupt_controller.cpp:41
    return mInterrupt_Regs[static_cast<unsigned int>(reg)];
    9214:	e51b3008 	ldr	r3, [fp, #-8]
    9218:	e5932000 	ldr	r2, [r3]
    921c:	e51b300c 	ldr	r3, [fp, #-12]
    9220:	e1a03103 	lsl	r3, r3, #2
    9224:	e0823003 	add	r3, r2, r3
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/interrupt_controller.cpp:42
}
    9228:	e1a00003 	mov	r0, r3
    922c:	e28bd000 	add	sp, fp, #0
    9230:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9234:	e12fff1e 	bx	lr

00009238 <_ZN21CInterrupt_Controller16Enable_Basic_IRQEN3hal16IRQ_Basic_SourceE>:
_ZN21CInterrupt_Controller16Enable_Basic_IRQEN3hal16IRQ_Basic_SourceE():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/interrupt_controller.cpp:45

void CInterrupt_Controller::Enable_Basic_IRQ(hal::IRQ_Basic_Source source_idx)
{
    9238:	e92d4810 	push	{r4, fp, lr}
    923c:	e28db008 	add	fp, sp, #8
    9240:	e24dd00c 	sub	sp, sp, #12
    9244:	e50b0010 	str	r0, [fp, #-16]
    9248:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/interrupt_controller.cpp:46
    Regs(hal::Interrupt_Controller_Reg::IRQ_Basic_Enable) = (1 << static_cast<unsigned int>(source_idx));
    924c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9250:	e3a02001 	mov	r2, #1
    9254:	e1a04312 	lsl	r4, r2, r3
    9258:	e3a01006 	mov	r1, #6
    925c:	e51b0010 	ldr	r0, [fp, #-16]
    9260:	ebffffe6 	bl	9200 <_ZN21CInterrupt_Controller4RegsEN3hal24Interrupt_Controller_RegE>
    9264:	e1a03000 	mov	r3, r0
    9268:	e1a02004 	mov	r2, r4
    926c:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/interrupt_controller.cpp:47
}
    9270:	e320f000 	nop	{0}
    9274:	e24bd008 	sub	sp, fp, #8
    9278:	e8bd8810 	pop	{r4, fp, pc}

0000927c <_ZN21CInterrupt_Controller17Disable_Basic_IRQEN3hal16IRQ_Basic_SourceE>:
_ZN21CInterrupt_Controller17Disable_Basic_IRQEN3hal16IRQ_Basic_SourceE():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/interrupt_controller.cpp:50

void CInterrupt_Controller::Disable_Basic_IRQ(hal::IRQ_Basic_Source source_idx)
{
    927c:	e92d4810 	push	{r4, fp, lr}
    9280:	e28db008 	add	fp, sp, #8
    9284:	e24dd00c 	sub	sp, sp, #12
    9288:	e50b0010 	str	r0, [fp, #-16]
    928c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/interrupt_controller.cpp:51
    Regs(hal::Interrupt_Controller_Reg::IRQ_Basic_Disable) = (1 << static_cast<unsigned int>(source_idx));
    9290:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9294:	e3a02001 	mov	r2, #1
    9298:	e1a04312 	lsl	r4, r2, r3
    929c:	e3a01009 	mov	r1, #9
    92a0:	e51b0010 	ldr	r0, [fp, #-16]
    92a4:	ebffffd5 	bl	9200 <_ZN21CInterrupt_Controller4RegsEN3hal24Interrupt_Controller_RegE>
    92a8:	e1a03000 	mov	r3, r0
    92ac:	e1a02004 	mov	r2, r4
    92b0:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/interrupt_controller.cpp:52
}
    92b4:	e320f000 	nop	{0}
    92b8:	e24bd008 	sub	sp, fp, #8
    92bc:	e8bd8810 	pop	{r4, fp, pc}

000092c0 <_ZN21CInterrupt_Controller10Enable_IRQEN3hal10IRQ_SourceE>:
_ZN21CInterrupt_Controller10Enable_IRQEN3hal10IRQ_SourceE():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/interrupt_controller.cpp:55

void CInterrupt_Controller::Enable_IRQ(hal::IRQ_Source source_idx)
{
    92c0:	e92d4810 	push	{r4, fp, lr}
    92c4:	e28db008 	add	fp, sp, #8
    92c8:	e24dd014 	sub	sp, sp, #20
    92cc:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    92d0:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/interrupt_controller.cpp:56
    const unsigned int idx_base = static_cast<unsigned int>(source_idx);
    92d4:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    92d8:	e50b3010 	str	r3, [fp, #-16]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/interrupt_controller.cpp:58

    Regs(idx_base < 32 ? hal::Interrupt_Controller_Reg::IRQ_Enable_1 : hal::Interrupt_Controller_Reg::IRQ_Enable_1) = (1 << (idx_base % 32));
    92dc:	e51b3010 	ldr	r3, [fp, #-16]
    92e0:	e203301f 	and	r3, r3, #31
    92e4:	e3a02001 	mov	r2, #1
    92e8:	e1a04312 	lsl	r4, r2, r3
    92ec:	e3a01004 	mov	r1, #4
    92f0:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    92f4:	ebffffc1 	bl	9200 <_ZN21CInterrupt_Controller4RegsEN3hal24Interrupt_Controller_RegE>
    92f8:	e1a03000 	mov	r3, r0
    92fc:	e1a02004 	mov	r2, r4
    9300:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/interrupt_controller.cpp:59
}
    9304:	e320f000 	nop	{0}
    9308:	e24bd008 	sub	sp, fp, #8
    930c:	e8bd8810 	pop	{r4, fp, pc}

00009310 <_ZN21CInterrupt_Controller11Disable_IRQEN3hal10IRQ_SourceE>:
_ZN21CInterrupt_Controller11Disable_IRQEN3hal10IRQ_SourceE():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/interrupt_controller.cpp:62

void CInterrupt_Controller::Disable_IRQ(hal::IRQ_Source source_idx)
{
    9310:	e92d4810 	push	{r4, fp, lr}
    9314:	e28db008 	add	fp, sp, #8
    9318:	e24dd014 	sub	sp, sp, #20
    931c:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    9320:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/interrupt_controller.cpp:63
    const unsigned int idx_base = static_cast<unsigned int>(source_idx);
    9324:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    9328:	e50b3010 	str	r3, [fp, #-16]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/interrupt_controller.cpp:65

    Regs(idx_base < 32 ? hal::Interrupt_Controller_Reg::IRQ_Disable_1 : hal::Interrupt_Controller_Reg::IRQ_Disable_1) = (1 << (idx_base % 32));
    932c:	e51b3010 	ldr	r3, [fp, #-16]
    9330:	e203301f 	and	r3, r3, #31
    9334:	e3a02001 	mov	r2, #1
    9338:	e1a04312 	lsl	r4, r2, r3
    933c:	e3a01007 	mov	r1, #7
    9340:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    9344:	ebffffad 	bl	9200 <_ZN21CInterrupt_Controller4RegsEN3hal24Interrupt_Controller_RegE>
    9348:	e1a03000 	mov	r3, r0
    934c:	e1a02004 	mov	r2, r4
    9350:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/interrupt_controller.cpp:66
}
    9354:	e320f000 	nop	{0}
    9358:	e24bd008 	sub	sp, fp, #8
    935c:	e8bd8810 	pop	{r4, fp, pc}

00009360 <_Z41__static_initialization_and_destruction_0ii>:
_Z41__static_initialization_and_destruction_0ii():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/interrupt_controller.cpp:66
    9360:	e92d4800 	push	{fp, lr}
    9364:	e28db004 	add	fp, sp, #4
    9368:	e24dd008 	sub	sp, sp, #8
    936c:	e50b0008 	str	r0, [fp, #-8]
    9370:	e50b100c 	str	r1, [fp, #-12]
    9374:	e51b3008 	ldr	r3, [fp, #-8]
    9378:	e3530001 	cmp	r3, #1
    937c:	1a000006 	bne	939c <_Z41__static_initialization_and_destruction_0ii+0x3c>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/interrupt_controller.cpp:66 (discriminator 1)
    9380:	e51b300c 	ldr	r3, [fp, #-12]
    9384:	e59f201c 	ldr	r2, [pc, #28]	; 93a8 <_Z41__static_initialization_and_destruction_0ii+0x48>
    9388:	e1530002 	cmp	r3, r2
    938c:	1a000002 	bne	939c <_Z41__static_initialization_and_destruction_0ii+0x3c>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/interrupt_controller.cpp:7
CInterrupt_Controller sInterruptCtl(hal::Interrupt_Controller_Base);
    9390:	e59f1014 	ldr	r1, [pc, #20]	; 93ac <_Z41__static_initialization_and_destruction_0ii+0x4c>
    9394:	e59f0014 	ldr	r0, [pc, #20]	; 93b0 <_Z41__static_initialization_and_destruction_0ii+0x50>
    9398:	ebffff8b 	bl	91cc <_ZN21CInterrupt_ControllerC1Em>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/interrupt_controller.cpp:66
}
    939c:	e320f000 	nop	{0}
    93a0:	e24bd004 	sub	sp, fp, #4
    93a4:	e8bd8800 	pop	{fp, pc}
    93a8:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>
    93ac:	2000b200 	andcs	fp, r0, r0, lsl #4
    93b0:	0000ae3c 	andeq	sl, r0, ip, lsr lr

000093b4 <_GLOBAL__sub_I_sInterruptCtl>:
_GLOBAL__sub_I_sInterruptCtl():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/interrupt_controller.cpp:66
    93b4:	e92d4800 	push	{fp, lr}
    93b8:	e28db004 	add	fp, sp, #4
    93bc:	e59f1008 	ldr	r1, [pc, #8]	; 93cc <_GLOBAL__sub_I_sInterruptCtl+0x18>
    93c0:	e3a00001 	mov	r0, #1
    93c4:	ebffffe5 	bl	9360 <_Z41__static_initialization_and_destruction_0ii>
    93c8:	e8bd8800 	pop	{fp, pc}
    93cc:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>

000093d0 <Timer_Callback>:
Timer_Callback():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:24
// externi funkce pro povoleni IRQ
extern "C" void enable_irq();
extern "C" void disable_irq();

extern "C" void Timer_Callback()
{
    93d0:	e92d4800 	push	{fp, lr}
    93d4:	e28db004 	add	fp, sp, #4
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:25
	sProcessMgr.Schedule();
    93d8:	e59f0040 	ldr	r0, [pc, #64]	; 9420 <Timer_Callback+0x50>
    93dc:	eb0003c2 	bl	a2ec <_ZN16CProcess_Manager8ScheduleEv>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:27

	sGPIO.Set_Output(ACT_Pin, LED_State);
    93e0:	e59f303c 	ldr	r3, [pc, #60]	; 9424 <Timer_Callback+0x54>
    93e4:	e5d33000 	ldrb	r3, [r3]
    93e8:	e6ef3073 	uxtb	r3, r3
    93ec:	e1a02003 	mov	r2, r3
    93f0:	e3a0102f 	mov	r1, #47	; 0x2f
    93f4:	e59f002c 	ldr	r0, [pc, #44]	; 9428 <Timer_Callback+0x58>
    93f8:	ebfffc3a 	bl	84e8 <_ZN13CGPIO_Handler10Set_OutputEjb>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:28
	LED_State = !LED_State;
    93fc:	e59f3020 	ldr	r3, [pc, #32]	; 9424 <Timer_Callback+0x54>
    9400:	e5d33000 	ldrb	r3, [r3]
    9404:	e6ef3073 	uxtb	r3, r3
    9408:	e2233001 	eor	r3, r3, #1
    940c:	e6ef2073 	uxtb	r2, r3
    9410:	e59f300c 	ldr	r3, [pc, #12]	; 9424 <Timer_Callback+0x54>
    9414:	e5c32000 	strb	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:29
}
    9418:	e320f000 	nop	{0}
    941c:	e8bd8800 	pop	{fp, pc}
    9420:	0000be48 	andeq	fp, r0, r8, asr #28
    9424:	0000ae40 	andeq	sl, r0, r0, asr #28
    9428:	0000ae08 	andeq	sl, r0, r8, lsl #28

0000942c <Process_1>:
Process_1():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:32

extern "C" void Process_1()
{
    942c:	e92d4800 	push	{fp, lr}
    9430:	e28db004 	add	fp, sp, #4
    9434:	e24dd008 	sub	sp, sp, #8
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:36
	volatile int i;

	//sUART0.Write("Process 1\r\n");
    sGPIO.Set_GPIO_Function(49, NGPIO_Function::Output);
    9438:	e3a02001 	mov	r2, #1
    943c:	e3a01031 	mov	r1, #49	; 0x31
    9440:	e59f0074 	ldr	r0, [pc, #116]	; 94bc <Process_1+0x90>
    9444:	ebfffbd8 	bl	83ac <_ZN13CGPIO_Handler17Set_GPIO_FunctionEj14NGPIO_Function>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:37
    bool state = true;
    9448:	e3a03001 	mov	r3, #1
    944c:	e54b3005 	strb	r3, [fp, #-5]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:41

	while (true)
	{
        sGPIO.Set_Output(49, state);
    9450:	e55b3005 	ldrb	r3, [fp, #-5]
    9454:	e1a02003 	mov	r2, r3
    9458:	e3a01031 	mov	r1, #49	; 0x31
    945c:	e59f0058 	ldr	r0, [pc, #88]	; 94bc <Process_1+0x90>
    9460:	ebfffc20 	bl	84e8 <_ZN13CGPIO_Handler10Set_OutputEjb>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:45
        
	//	sUART0.Write('1');
        
        disable_irq();
    9464:	eb000455 	bl	a5c0 <disable_irq>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:46
    	sMonitor << "1";
    9468:	e59f1050 	ldr	r1, [pc, #80]	; 94c0 <Process_1+0x94>
    946c:	e59f0050 	ldr	r0, [pc, #80]	; 94c4 <Process_1+0x98>
    9470:	ebfffd4d 	bl	89ac <_ZN8CMonitorlsEPKc>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:47
        enable_irq();
    9474:	eb00044c 	bl	a5ac <enable_irq>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:49

		for (i = 0; i < 0x100; i++)
    9478:	e3a03000 	mov	r3, #0
    947c:	e50b300c 	str	r3, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:49 (discriminator 3)
    9480:	e51b300c 	ldr	r3, [fp, #-12]
    9484:	e35300ff 	cmp	r3, #255	; 0xff
    9488:	d3a03001 	movle	r3, #1
    948c:	c3a03000 	movgt	r3, #0
    9490:	e6ef3073 	uxtb	r3, r3
    9494:	e3530000 	cmp	r3, #0
    9498:	0a000003 	beq	94ac <Process_1+0x80>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:49 (discriminator 2)
    949c:	e51b300c 	ldr	r3, [fp, #-12]
    94a0:	e2833001 	add	r3, r3, #1
    94a4:	e50b300c 	str	r3, [fp, #-12]
    94a8:	eafffff4 	b	9480 <Process_1+0x54>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:52
			;
        
        state = !state;
    94ac:	e55b3005 	ldrb	r3, [fp, #-5]
    94b0:	e2233001 	eor	r3, r3, #1
    94b4:	e54b3005 	strb	r3, [fp, #-5]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:41
        sGPIO.Set_Output(49, state);
    94b8:	eaffffe4 	b	9450 <Process_1+0x24>
    94bc:	0000ae08 	andeq	sl, r0, r8, lsl #28
    94c0:	0000acd4 	ldrdeq	sl, [r0], -r4
    94c4:	0000ae0c 	andeq	sl, r0, ip, lsl #28

000094c8 <Process_2>:
Process_2():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:57
	}
}

extern "C" void Process_2()
{
    94c8:	e92d4800 	push	{fp, lr}
    94cc:	e28db004 	add	fp, sp, #4
    94d0:	e24dd008 	sub	sp, sp, #8
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:61
	volatile int i;

	//sUART0.Write("Process 2\r\n");
    sGPIO.Set_GPIO_Function(50, NGPIO_Function::Output);
    94d4:	e3a02001 	mov	r2, #1
    94d8:	e3a01032 	mov	r1, #50	; 0x32
    94dc:	e59f0074 	ldr	r0, [pc, #116]	; 9558 <Process_2+0x90>
    94e0:	ebfffbb1 	bl	83ac <_ZN13CGPIO_Handler17Set_GPIO_FunctionEj14NGPIO_Function>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:62
    bool state = true;
    94e4:	e3a03001 	mov	r3, #1
    94e8:	e54b3005 	strb	r3, [fp, #-5]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:67

	while (true)
	{
		//sUART0.Write('2');
        sGPIO.Set_Output(50, state);
    94ec:	e55b3005 	ldrb	r3, [fp, #-5]
    94f0:	e1a02003 	mov	r2, r3
    94f4:	e3a01032 	mov	r1, #50	; 0x32
    94f8:	e59f0058 	ldr	r0, [pc, #88]	; 9558 <Process_2+0x90>
    94fc:	ebfffbf9 	bl	84e8 <_ZN13CGPIO_Handler10Set_OutputEjb>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:69

        disable_irq();
    9500:	eb00042e 	bl	a5c0 <disable_irq>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:70
		sMonitor << "2";
    9504:	e59f1050 	ldr	r1, [pc, #80]	; 955c <Process_2+0x94>
    9508:	e59f0050 	ldr	r0, [pc, #80]	; 9560 <Process_2+0x98>
    950c:	ebfffd26 	bl	89ac <_ZN8CMonitorlsEPKc>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:71
        enable_irq();
    9510:	eb000425 	bl	a5ac <enable_irq>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:73

		for (i = 0; i < 0x200; i++)
    9514:	e3a03000 	mov	r3, #0
    9518:	e50b300c 	str	r3, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:73 (discriminator 3)
    951c:	e51b300c 	ldr	r3, [fp, #-12]
    9520:	e3530c02 	cmp	r3, #512	; 0x200
    9524:	b3a03001 	movlt	r3, #1
    9528:	a3a03000 	movge	r3, #0
    952c:	e6ef3073 	uxtb	r3, r3
    9530:	e3530000 	cmp	r3, #0
    9534:	0a000003 	beq	9548 <Process_2+0x80>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:73 (discriminator 2)
    9538:	e51b300c 	ldr	r3, [fp, #-12]
    953c:	e2833001 	add	r3, r3, #1
    9540:	e50b300c 	str	r3, [fp, #-12]
    9544:	eafffff4 	b	951c <Process_2+0x54>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:76
			;
        
        state = !state;
    9548:	e55b3005 	ldrb	r3, [fp, #-5]
    954c:	e2233001 	eor	r3, r3, #1
    9550:	e54b3005 	strb	r3, [fp, #-5]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:67
        sGPIO.Set_Output(50, state);
    9554:	eaffffe4 	b	94ec <Process_2+0x24>
    9558:	0000ae08 	andeq	sl, r0, r8, lsl #28
    955c:	0000acd8 	ldrdeq	sl, [r0], -r8
    9560:	0000ae0c 	andeq	sl, r0, ip, lsl #28

00009564 <Process_3>:
Process_3():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:81
	}
}

extern "C" void Process_3()
{
    9564:	e92d4800 	push	{fp, lr}
    9568:	e28db004 	add	fp, sp, #4
    956c:	e24dd008 	sub	sp, sp, #8
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:85
	volatile int i;

	//sUART0.Write("Process 2\r\n");
    sGPIO.Set_GPIO_Function(51, NGPIO_Function::Output);
    9570:	e3a02001 	mov	r2, #1
    9574:	e3a01033 	mov	r1, #51	; 0x33
    9578:	e59f0074 	ldr	r0, [pc, #116]	; 95f4 <Process_3+0x90>
    957c:	ebfffb8a 	bl	83ac <_ZN13CGPIO_Handler17Set_GPIO_FunctionEj14NGPIO_Function>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:86
    bool state = true;
    9580:	e3a03001 	mov	r3, #1
    9584:	e54b3005 	strb	r3, [fp, #-5]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:91

	while (true)
	{
		//sUART0.Write('2');
        sGPIO.Set_Output(51, state);
    9588:	e55b3005 	ldrb	r3, [fp, #-5]
    958c:	e1a02003 	mov	r2, r3
    9590:	e3a01033 	mov	r1, #51	; 0x33
    9594:	e59f0058 	ldr	r0, [pc, #88]	; 95f4 <Process_3+0x90>
    9598:	ebfffbd2 	bl	84e8 <_ZN13CGPIO_Handler10Set_OutputEjb>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:93

        disable_irq();
    959c:	eb000407 	bl	a5c0 <disable_irq>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:94
		sMonitor << "3";
    95a0:	e59f1050 	ldr	r1, [pc, #80]	; 95f8 <Process_3+0x94>
    95a4:	e59f0050 	ldr	r0, [pc, #80]	; 95fc <Process_3+0x98>
    95a8:	ebfffcff 	bl	89ac <_ZN8CMonitorlsEPKc>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:95
        enable_irq();
    95ac:	eb0003fe 	bl	a5ac <enable_irq>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:97

		for (i = 0; i < 0x150; i++)
    95b0:	e3a03000 	mov	r3, #0
    95b4:	e50b300c 	str	r3, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:97 (discriminator 3)
    95b8:	e51b300c 	ldr	r3, [fp, #-12]
    95bc:	e3530e15 	cmp	r3, #336	; 0x150
    95c0:	b3a03001 	movlt	r3, #1
    95c4:	a3a03000 	movge	r3, #0
    95c8:	e6ef3073 	uxtb	r3, r3
    95cc:	e3530000 	cmp	r3, #0
    95d0:	0a000003 	beq	95e4 <Process_3+0x80>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:97 (discriminator 2)
    95d4:	e51b300c 	ldr	r3, [fp, #-12]
    95d8:	e2833001 	add	r3, r3, #1
    95dc:	e50b300c 	str	r3, [fp, #-12]
    95e0:	eafffff4 	b	95b8 <Process_3+0x54>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:100
			;
        
        state = !state;
    95e4:	e55b3005 	ldrb	r3, [fp, #-5]
    95e8:	e2233001 	eor	r3, r3, #1
    95ec:	e54b3005 	strb	r3, [fp, #-5]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:91
        sGPIO.Set_Output(51, state);
    95f0:	eaffffe4 	b	9588 <Process_3+0x24>
    95f4:	0000ae08 	andeq	sl, r0, r8, lsl #28
    95f8:	0000acdc 	ldrdeq	sl, [r0], -ip
    95fc:	0000ae0c 	andeq	sl, r0, ip, lsl #28

00009600 <Process_4>:
Process_4():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:105
	}
}

extern "C" void Process_4()
{
    9600:	e92d4800 	push	{fp, lr}
    9604:	e28db004 	add	fp, sp, #4
    9608:	e24dd008 	sub	sp, sp, #8
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:109
	volatile int i;

	//sUART0.Write("Process 2\r\n");
    sGPIO.Set_GPIO_Function(52, NGPIO_Function::Output);
    960c:	e3a02001 	mov	r2, #1
    9610:	e3a01034 	mov	r1, #52	; 0x34
    9614:	e59f0074 	ldr	r0, [pc, #116]	; 9690 <Process_4+0x90>
    9618:	ebfffb63 	bl	83ac <_ZN13CGPIO_Handler17Set_GPIO_FunctionEj14NGPIO_Function>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:110
    bool state = true;
    961c:	e3a03001 	mov	r3, #1
    9620:	e54b3005 	strb	r3, [fp, #-5]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:115

	while (true)
	{
		//sUART0.Write('2');
        sGPIO.Set_Output(51, state);
    9624:	e55b3005 	ldrb	r3, [fp, #-5]
    9628:	e1a02003 	mov	r2, r3
    962c:	e3a01033 	mov	r1, #51	; 0x33
    9630:	e59f0058 	ldr	r0, [pc, #88]	; 9690 <Process_4+0x90>
    9634:	ebfffbab 	bl	84e8 <_ZN13CGPIO_Handler10Set_OutputEjb>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:117

        disable_irq();
    9638:	eb0003e0 	bl	a5c0 <disable_irq>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:118
		sMonitor << "4";
    963c:	e59f1050 	ldr	r1, [pc, #80]	; 9694 <Process_4+0x94>
    9640:	e59f0050 	ldr	r0, [pc, #80]	; 9698 <Process_4+0x98>
    9644:	ebfffcd8 	bl	89ac <_ZN8CMonitorlsEPKc>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:119
        enable_irq();
    9648:	eb0003d7 	bl	a5ac <enable_irq>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:121

		for (i = 0; i < 0x250; i++)
    964c:	e3a03000 	mov	r3, #0
    9650:	e50b300c 	str	r3, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:121 (discriminator 3)
    9654:	e51b300c 	ldr	r3, [fp, #-12]
    9658:	e3530e25 	cmp	r3, #592	; 0x250
    965c:	b3a03001 	movlt	r3, #1
    9660:	a3a03000 	movge	r3, #0
    9664:	e6ef3073 	uxtb	r3, r3
    9668:	e3530000 	cmp	r3, #0
    966c:	0a000003 	beq	9680 <Process_4+0x80>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:121 (discriminator 2)
    9670:	e51b300c 	ldr	r3, [fp, #-12]
    9674:	e2833001 	add	r3, r3, #1
    9678:	e50b300c 	str	r3, [fp, #-12]
    967c:	eafffff4 	b	9654 <Process_4+0x54>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:124
			;
        
        state = !state;
    9680:	e55b3005 	ldrb	r3, [fp, #-5]
    9684:	e2233001 	eor	r3, r3, #1
    9688:	e54b3005 	strb	r3, [fp, #-5]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:115
        sGPIO.Set_Output(51, state);
    968c:	eaffffe4 	b	9624 <Process_4+0x24>
    9690:	0000ae08 	andeq	sl, r0, r8, lsl #28
    9694:	0000ace0 	andeq	sl, r0, r0, ror #25
    9698:	0000ae0c 	andeq	sl, r0, ip, lsl #28

0000969c <_kernel_main>:
_kernel_main():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:129
	}
}

extern "C" int _kernel_main(void)
{
    969c:	e92d4800 	push	{fp, lr}
    96a0:	e28db004 	add	fp, sp, #4
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:131
	// nastavime ACT LED pin na vystupni
	sGPIO.Set_GPIO_Function(ACT_Pin, NGPIO_Function::Output);
    96a4:	e3a02001 	mov	r2, #1
    96a8:	e3a0102f 	mov	r1, #47	; 0x2f
    96ac:	e59f008c 	ldr	r0, [pc, #140]	; 9740 <_kernel_main+0xa4>
    96b0:	ebfffb3d 	bl	83ac <_ZN13CGPIO_Handler17Set_GPIO_FunctionEj14NGPIO_Function>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:132
	sGPIO.Set_Output(ACT_Pin, false);
    96b4:	e3a02000 	mov	r2, #0
    96b8:	e3a0102f 	mov	r1, #47	; 0x2f
    96bc:	e59f007c 	ldr	r0, [pc, #124]	; 9740 <_kernel_main+0xa4>
    96c0:	ebfffb88 	bl	84e8 <_ZN13CGPIO_Handler10Set_OutputEjb>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:136

	// sProcessMgr.Create_Main_Process();

    sMonitor.Clear();
    96c4:	e59f0078 	ldr	r0, [pc, #120]	; 9744 <_kernel_main+0xa8>
    96c8:	ebfffc17 	bl	872c <_ZN8CMonitor5ClearEv>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:138
    
	sProcessMgr.Create_Process(reinterpret_cast<unsigned long>(&Process_1));
    96cc:	e59f3074 	ldr	r3, [pc, #116]	; 9748 <_kernel_main+0xac>
    96d0:	e1a01003 	mov	r1, r3
    96d4:	e59f0070 	ldr	r0, [pc, #112]	; 974c <_kernel_main+0xb0>
    96d8:	eb0002a2 	bl	a168 <_ZN16CProcess_Manager14Create_ProcessEm>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:139
	sProcessMgr.Create_Process(reinterpret_cast<unsigned long>(&Process_2));
    96dc:	e59f306c 	ldr	r3, [pc, #108]	; 9750 <_kernel_main+0xb4>
    96e0:	e1a01003 	mov	r1, r3
    96e4:	e59f0060 	ldr	r0, [pc, #96]	; 974c <_kernel_main+0xb0>
    96e8:	eb00029e 	bl	a168 <_ZN16CProcess_Manager14Create_ProcessEm>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:140
    sProcessMgr.Create_Process(reinterpret_cast<unsigned long>(&Process_3));
    96ec:	e59f3060 	ldr	r3, [pc, #96]	; 9754 <_kernel_main+0xb8>
    96f0:	e1a01003 	mov	r1, r3
    96f4:	e59f0050 	ldr	r0, [pc, #80]	; 974c <_kernel_main+0xb0>
    96f8:	eb00029a 	bl	a168 <_ZN16CProcess_Manager14Create_ProcessEm>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:141
    sProcessMgr.Create_Process(reinterpret_cast<unsigned long>(&Process_4));
    96fc:	e59f3054 	ldr	r3, [pc, #84]	; 9758 <_kernel_main+0xbc>
    9700:	e1a01003 	mov	r1, r3
    9704:	e59f0040 	ldr	r0, [pc, #64]	; 974c <_kernel_main+0xb0>
    9708:	eb000296 	bl	a168 <_ZN16CProcess_Manager14Create_ProcessEm>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:144

	// zatim zakazeme IRQ casovace
	sInterruptCtl.Disable_Basic_IRQ(hal::IRQ_Basic_Source::Timer);
    970c:	e3a01000 	mov	r1, #0
    9710:	e59f0044 	ldr	r0, [pc, #68]	; 975c <_kernel_main+0xc0>
    9714:	ebfffed8 	bl	927c <_ZN21CInterrupt_Controller17Disable_Basic_IRQEN3hal16IRQ_Basic_SourceE>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:147

	// nastavime casovac - v callbacku se provadi planovani procesu
	sTimer.Enable(Timer_Callback, 0x20, NTimer_Prescaler::Prescaler_256);
    9718:	e3a03002 	mov	r3, #2
    971c:	e3a02020 	mov	r2, #32
    9720:	e59f1038 	ldr	r1, [pc, #56]	; 9760 <_kernel_main+0xc4>
    9724:	e59f0038 	ldr	r0, [pc, #56]	; 9764 <_kernel_main+0xc8>
    9728:	ebfffe0b 	bl	8f5c <_ZN6CTimer6EnableEPFvvEj16NTimer_Prescaler>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:150

	// povolime IRQ casovace
	sInterruptCtl.Enable_Basic_IRQ(hal::IRQ_Basic_Source::Timer);
    972c:	e3a01000 	mov	r1, #0
    9730:	e59f0024 	ldr	r0, [pc, #36]	; 975c <_kernel_main+0xc0>
    9734:	ebfffebf 	bl	9238 <_ZN21CInterrupt_Controller16Enable_Basic_IRQEN3hal16IRQ_Basic_SourceE>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:152
    
	enable_irq();
    9738:	eb00039b 	bl	a5ac <enable_irq>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:155 (discriminator 1)

	// nekonecna smycka - tadyodsud se CPU uz nedostane jinak, nez treba prerusenim
    while (1)
    973c:	eafffffe 	b	973c <_kernel_main+0xa0>
    9740:	0000ae08 	andeq	sl, r0, r8, lsl #28
    9744:	0000ae0c 	andeq	sl, r0, ip, lsl #28
    9748:	0000942c 	andeq	r9, r0, ip, lsr #8
    974c:	0000be48 	andeq	fp, r0, r8, asr #28
    9750:	000094c8 	andeq	r9, r0, r8, asr #9
    9754:	00009564 	andeq	r9, r0, r4, ror #10
    9758:	00009600 	andeq	r9, r0, r0, lsl #12
    975c:	0000ae3c 	andeq	sl, r0, ip, lsr lr
    9760:	000093d0 	ldrdeq	r9, [r0], -r0
    9764:	0000ae34 	andeq	sl, r0, r4, lsr lr

00009768 <_ZN20CKernel_Heap_ManagerC1Ev>:
_ZN20CKernel_Heap_ManagerC2Ev():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:6
#include <memory/kernel_heap.h>
#include <memory/pages.h>

CKernel_Heap_Manager sKernelMem;

CKernel_Heap_Manager::CKernel_Heap_Manager()
    9768:	e92d4800 	push	{fp, lr}
    976c:	e28db004 	add	fp, sp, #4
    9770:	e24dd008 	sub	sp, sp, #8
    9774:	e50b0008 	str	r0, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:9
{
    // na zacatku si alokujeme jednu stranku dopredu, protoze je temer jiste, ze budeme docela brzy potrebovat nejakou pamet
    mFirst = Alloc_Next_Page();
    9778:	e51b0008 	ldr	r0, [fp, #-8]
    977c:	eb000006 	bl	979c <_ZN20CKernel_Heap_Manager15Alloc_Next_PageEv>
    9780:	e1a02000 	mov	r2, r0
    9784:	e51b3008 	ldr	r3, [fp, #-8]
    9788:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:10
}
    978c:	e51b3008 	ldr	r3, [fp, #-8]
    9790:	e1a00003 	mov	r0, r3
    9794:	e24bd004 	sub	sp, fp, #4
    9798:	e8bd8800 	pop	{fp, pc}

0000979c <_ZN20CKernel_Heap_Manager15Alloc_Next_PageEv>:
_ZN20CKernel_Heap_Manager15Alloc_Next_PageEv():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:13

TKernel_Heap_Chunk_Header* CKernel_Heap_Manager::Alloc_Next_Page()
{
    979c:	e92d4800 	push	{fp, lr}
    97a0:	e28db004 	add	fp, sp, #4
    97a4:	e24dd010 	sub	sp, sp, #16
    97a8:	e50b0010 	str	r0, [fp, #-16]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:14
    TKernel_Heap_Chunk_Header* chunk = reinterpret_cast<TKernel_Heap_Chunk_Header*>(sPage_Manager.Alloc_Page());
    97ac:	e59f0048 	ldr	r0, [pc, #72]	; 97fc <_ZN20CKernel_Heap_Manager15Alloc_Next_PageEv+0x60>
    97b0:	eb000165 	bl	9d4c <_ZN13CPage_Manager10Alloc_PageEv>
    97b4:	e1a03000 	mov	r3, r0
    97b8:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:15
    chunk->prev = nullptr;
    97bc:	e51b3008 	ldr	r3, [fp, #-8]
    97c0:	e3a02000 	mov	r2, #0
    97c4:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:16
    chunk->next = nullptr;
    97c8:	e51b3008 	ldr	r3, [fp, #-8]
    97cc:	e3a02000 	mov	r2, #0
    97d0:	e5832004 	str	r2, [r3, #4]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:17
    chunk->size = mem::PageSize - sizeof(TKernel_Heap_Chunk_Header); // z alokovane stranky musime ubrat velikost hlavicky
    97d4:	e51b3008 	ldr	r3, [fp, #-8]
    97d8:	e59f2020 	ldr	r2, [pc, #32]	; 9800 <_ZN20CKernel_Heap_Manager15Alloc_Next_PageEv+0x64>
    97dc:	e5832008 	str	r2, [r3, #8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:18
    chunk->is_free = true;
    97e0:	e51b3008 	ldr	r3, [fp, #-8]
    97e4:	e3a02001 	mov	r2, #1
    97e8:	e5c3200c 	strb	r2, [r3, #12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:20

    return chunk;
    97ec:	e51b3008 	ldr	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:21
}
    97f0:	e1a00003 	mov	r0, r3
    97f4:	e24bd004 	sub	sp, fp, #4
    97f8:	e8bd8800 	pop	{fp, pc}
    97fc:	0000ae48 	andeq	sl, r0, r8, asr #28
    9800:	00003ff0 	strdeq	r3, [r0], -r0

00009804 <_ZN20CKernel_Heap_Manager5AllocEj>:
_ZN20CKernel_Heap_Manager5AllocEj():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:24

void* CKernel_Heap_Manager::Alloc(uint32_t size)
{
    9804:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9808:	e28db000 	add	fp, sp, #0
    980c:	e24dd014 	sub	sp, sp, #20
    9810:	e50b0010 	str	r0, [fp, #-16]
    9814:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:25
    TKernel_Heap_Chunk_Header* chunk = mFirst;
    9818:	e51b3010 	ldr	r3, [fp, #-16]
    981c:	e5933000 	ldr	r3, [r3]
    9820:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:28

    // potrebujeme najit prvni blok, ktery je volny a zaroven alespon tak velky, jak potrebujeme (pro ted pouzivame proste first-fit)
    while (chunk != nullptr && (!chunk->is_free || chunk->size < size))
    9824:	e51b3008 	ldr	r3, [fp, #-8]
    9828:	e3530000 	cmp	r3, #0
    982c:	0a00000c 	beq	9864 <_ZN20CKernel_Heap_Manager5AllocEj+0x60>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:28 (discriminator 1)
    9830:	e51b3008 	ldr	r3, [fp, #-8]
    9834:	e5d3300c 	ldrb	r3, [r3, #12]
    9838:	e3530000 	cmp	r3, #0
    983c:	0a000004 	beq	9854 <_ZN20CKernel_Heap_Manager5AllocEj+0x50>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:28 (discriminator 2)
    9840:	e51b3008 	ldr	r3, [fp, #-8]
    9844:	e5933008 	ldr	r3, [r3, #8]
    9848:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    984c:	e1520003 	cmp	r2, r3
    9850:	9a000003 	bls	9864 <_ZN20CKernel_Heap_Manager5AllocEj+0x60>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:30
    {
        chunk = chunk->next;
    9854:	e51b3008 	ldr	r3, [fp, #-8]
    9858:	e5933004 	ldr	r3, [r3, #4]
    985c:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:28
    while (chunk != nullptr && (!chunk->is_free || chunk->size < size))
    9860:	eaffffef 	b	9824 <_ZN20CKernel_Heap_Manager5AllocEj+0x20>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:33
    }

    if (!chunk)
    9864:	e51b3008 	ldr	r3, [fp, #-8]
    9868:	e3530000 	cmp	r3, #0
    986c:	1a000001 	bne	9878 <_ZN20CKernel_Heap_Manager5AllocEj+0x74>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:37
    {
        // TODO: tady by se hodila alokace dalsi stranky (Alloc_Next_Page) a navazani na predchozi chunk
        // pro ted nechme byt, vic jak 4kB snad v tomto prikladu potrebovat nebudeme
        return nullptr;
    9870:	e3a03000 	mov	r3, #0
    9874:	ea000031 	b	9940 <_ZN20CKernel_Heap_Manager5AllocEj+0x13c>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:42
    }

    // pokud je pozadovane misto uz tak velke, jak potrebujeme, tak je to snadne - jen ho oznacime za alokovane a vratime
    // vzdy zarovname tak, aby se do dalsiho potencialniho bloku vesla alespon hlavicka dalsiho bloku a nejaky overlap (alespon jeden bajt)
    if (chunk->size >= size && chunk->size <= size + sizeof(TKernel_Heap_Chunk_Header) + 1)
    9878:	e51b3008 	ldr	r3, [fp, #-8]
    987c:	e5933008 	ldr	r3, [r3, #8]
    9880:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    9884:	e1520003 	cmp	r2, r3
    9888:	8a00000b 	bhi	98bc <_ZN20CKernel_Heap_Manager5AllocEj+0xb8>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:42 (discriminator 1)
    988c:	e51b3008 	ldr	r3, [fp, #-8]
    9890:	e5932008 	ldr	r2, [r3, #8]
    9894:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9898:	e2833011 	add	r3, r3, #17
    989c:	e1520003 	cmp	r2, r3
    98a0:	8a000005 	bhi	98bc <_ZN20CKernel_Heap_Manager5AllocEj+0xb8>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:44
    {
        chunk->is_free = false;
    98a4:	e51b3008 	ldr	r3, [fp, #-8]
    98a8:	e3a02000 	mov	r2, #0
    98ac:	e5c3200c 	strb	r2, [r3, #12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:45
        return reinterpret_cast<uint8_t*>(chunk) + sizeof(TKernel_Heap_Chunk_Header); // vracime az pouzitelnou pamet, tedy to co nasleduje po hlavicce
    98b0:	e51b3008 	ldr	r3, [fp, #-8]
    98b4:	e2833010 	add	r3, r3, #16
    98b8:	ea000020 	b	9940 <_ZN20CKernel_Heap_Manager5AllocEj+0x13c>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:51
    }

    // pokud je vetsi, musime blok rozdelit
    // to, ze se tam vejde dalsi hlavicka jsme garantovali prekryvem, viz vyse

    TKernel_Heap_Chunk_Header* hdr2 = reinterpret_cast<TKernel_Heap_Chunk_Header*>(reinterpret_cast<uint8_t*>(chunk) + sizeof(TKernel_Heap_Chunk_Header) + size);
    98bc:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    98c0:	e2833010 	add	r3, r3, #16
    98c4:	e51b2008 	ldr	r2, [fp, #-8]
    98c8:	e0823003 	add	r3, r2, r3
    98cc:	e50b300c 	str	r3, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:53

    hdr2->size = chunk->size - size - sizeof(TKernel_Heap_Chunk_Header);
    98d0:	e51b3008 	ldr	r3, [fp, #-8]
    98d4:	e5932008 	ldr	r2, [r3, #8]
    98d8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    98dc:	e0423003 	sub	r3, r2, r3
    98e0:	e2432010 	sub	r2, r3, #16
    98e4:	e51b300c 	ldr	r3, [fp, #-12]
    98e8:	e5832008 	str	r2, [r3, #8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:55

    hdr2->prev = chunk;
    98ec:	e51b300c 	ldr	r3, [fp, #-12]
    98f0:	e51b2008 	ldr	r2, [fp, #-8]
    98f4:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:56
    hdr2->next = chunk->next;
    98f8:	e51b3008 	ldr	r3, [fp, #-8]
    98fc:	e5932004 	ldr	r2, [r3, #4]
    9900:	e51b300c 	ldr	r3, [fp, #-12]
    9904:	e5832004 	str	r2, [r3, #4]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:57
    hdr2->is_free = true;
    9908:	e51b300c 	ldr	r3, [fp, #-12]
    990c:	e3a02001 	mov	r2, #1
    9910:	e5c3200c 	strb	r2, [r3, #12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:58
    chunk->next = hdr2;
    9914:	e51b3008 	ldr	r3, [fp, #-8]
    9918:	e51b200c 	ldr	r2, [fp, #-12]
    991c:	e5832004 	str	r2, [r3, #4]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:60

    chunk->size = size;
    9920:	e51b3008 	ldr	r3, [fp, #-8]
    9924:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    9928:	e5832008 	str	r2, [r3, #8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:61
    chunk->is_free = false;
    992c:	e51b3008 	ldr	r3, [fp, #-8]
    9930:	e3a02000 	mov	r2, #0
    9934:	e5c3200c 	strb	r2, [r3, #12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:63

    return reinterpret_cast<uint8_t*>(chunk) + sizeof(TKernel_Heap_Chunk_Header); // vracime az pouzitelnou pamet, tedy to co nasleduje po hlavicce
    9938:	e51b3008 	ldr	r3, [fp, #-8]
    993c:	e2833010 	add	r3, r3, #16
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:64
}
    9940:	e1a00003 	mov	r0, r3
    9944:	e28bd000 	add	sp, fp, #0
    9948:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    994c:	e12fff1e 	bx	lr

00009950 <_ZN20CKernel_Heap_Manager4FreeEPv>:
_ZN20CKernel_Heap_Manager4FreeEPv():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:67

void CKernel_Heap_Manager::Free(void* mem)
{
    9950:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9954:	e28db000 	add	fp, sp, #0
    9958:	e24dd014 	sub	sp, sp, #20
    995c:	e50b0010 	str	r0, [fp, #-16]
    9960:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:68
    TKernel_Heap_Chunk_Header* chunk = reinterpret_cast<TKernel_Heap_Chunk_Header*>(reinterpret_cast<uint8_t*>(mem) - sizeof(TKernel_Heap_Chunk_Header));
    9964:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9968:	e2433010 	sub	r3, r3, #16
    996c:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:70

    chunk->is_free = true;
    9970:	e51b3008 	ldr	r3, [fp, #-8]
    9974:	e3a02001 	mov	r2, #1
    9978:	e5c3200c 	strb	r2, [r3, #12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:73

    // pokud je dalsi blok volny, spojme tento a dalsi blok do jednoho
    if (chunk->next && chunk->next->is_free)
    997c:	e51b3008 	ldr	r3, [fp, #-8]
    9980:	e5933004 	ldr	r3, [r3, #4]
    9984:	e3530000 	cmp	r3, #0
    9988:	0a000016 	beq	99e8 <_ZN20CKernel_Heap_Manager4FreeEPv+0x98>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:73 (discriminator 1)
    998c:	e51b3008 	ldr	r3, [fp, #-8]
    9990:	e5933004 	ldr	r3, [r3, #4]
    9994:	e5d3300c 	ldrb	r3, [r3, #12]
    9998:	e3530000 	cmp	r3, #0
    999c:	0a000011 	beq	99e8 <_ZN20CKernel_Heap_Manager4FreeEPv+0x98>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:75
    {
        chunk->size += chunk->next->size + sizeof(TKernel_Heap_Chunk_Header);   // zvetsit soucasny
    99a0:	e51b3008 	ldr	r3, [fp, #-8]
    99a4:	e5932008 	ldr	r2, [r3, #8]
    99a8:	e51b3008 	ldr	r3, [fp, #-8]
    99ac:	e5933004 	ldr	r3, [r3, #4]
    99b0:	e5933008 	ldr	r3, [r3, #8]
    99b4:	e0823003 	add	r3, r2, r3
    99b8:	e2832010 	add	r2, r3, #16
    99bc:	e51b3008 	ldr	r3, [fp, #-8]
    99c0:	e5832008 	str	r2, [r3, #8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:76
        chunk->next = chunk->next->next;                                        // navazat nasledujici nasledujiciho jako dalsi
    99c4:	e51b3008 	ldr	r3, [fp, #-8]
    99c8:	e5933004 	ldr	r3, [r3, #4]
    99cc:	e5932004 	ldr	r2, [r3, #4]
    99d0:	e51b3008 	ldr	r3, [fp, #-8]
    99d4:	e5832004 	str	r2, [r3, #4]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:77
        chunk->next->prev = chunk;                                              // nasledujicimu nastavit predchozi na sebe
    99d8:	e51b3008 	ldr	r3, [fp, #-8]
    99dc:	e5933004 	ldr	r3, [r3, #4]
    99e0:	e51b2008 	ldr	r2, [fp, #-8]
    99e4:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:81
    }

    // pokud je predchozi blok volny, spojme predchozi a tento blok do jednoho
    if (chunk->prev && chunk->prev->is_free)
    99e8:	e51b3008 	ldr	r3, [fp, #-8]
    99ec:	e5933000 	ldr	r3, [r3]
    99f0:	e3530000 	cmp	r3, #0
    99f4:	0a000018 	beq	9a5c <_ZN20CKernel_Heap_Manager4FreeEPv+0x10c>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:81 (discriminator 1)
    99f8:	e51b3008 	ldr	r3, [fp, #-8]
    99fc:	e5933000 	ldr	r3, [r3]
    9a00:	e5d3300c 	ldrb	r3, [r3, #12]
    9a04:	e3530000 	cmp	r3, #0
    9a08:	0a000013 	beq	9a5c <_ZN20CKernel_Heap_Manager4FreeEPv+0x10c>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:83
    {
        chunk->prev->size += chunk->size + sizeof(TKernel_Heap_Chunk_Header);
    9a0c:	e51b3008 	ldr	r3, [fp, #-8]
    9a10:	e5933000 	ldr	r3, [r3]
    9a14:	e5932008 	ldr	r2, [r3, #8]
    9a18:	e51b3008 	ldr	r3, [fp, #-8]
    9a1c:	e5933008 	ldr	r3, [r3, #8]
    9a20:	e0822003 	add	r2, r2, r3
    9a24:	e51b3008 	ldr	r3, [fp, #-8]
    9a28:	e5933000 	ldr	r3, [r3]
    9a2c:	e2822010 	add	r2, r2, #16
    9a30:	e5832008 	str	r2, [r3, #8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:84
        chunk->prev->next = chunk->next;
    9a34:	e51b3008 	ldr	r3, [fp, #-8]
    9a38:	e5933000 	ldr	r3, [r3]
    9a3c:	e51b2008 	ldr	r2, [fp, #-8]
    9a40:	e5922004 	ldr	r2, [r2, #4]
    9a44:	e5832004 	str	r2, [r3, #4]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:85
        chunk->next->prev = chunk->prev;
    9a48:	e51b3008 	ldr	r3, [fp, #-8]
    9a4c:	e5933004 	ldr	r3, [r3, #4]
    9a50:	e51b2008 	ldr	r2, [fp, #-8]
    9a54:	e5922000 	ldr	r2, [r2]
    9a58:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:87
    }
    9a5c:	e320f000 	nop	{0}
    9a60:	e28bd000 	add	sp, fp, #0
    9a64:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9a68:	e12fff1e 	bx	lr

00009a6c <_Z41__static_initialization_and_destruction_0ii>:
_Z41__static_initialization_and_destruction_0ii():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:87
    9a6c:	e92d4800 	push	{fp, lr}
    9a70:	e28db004 	add	fp, sp, #4
    9a74:	e24dd008 	sub	sp, sp, #8
    9a78:	e50b0008 	str	r0, [fp, #-8]
    9a7c:	e50b100c 	str	r1, [fp, #-12]
    9a80:	e51b3008 	ldr	r3, [fp, #-8]
    9a84:	e3530001 	cmp	r3, #1
    9a88:	1a000005 	bne	9aa4 <_Z41__static_initialization_and_destruction_0ii+0x38>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:87 (discriminator 1)
    9a8c:	e51b300c 	ldr	r3, [fp, #-12]
    9a90:	e59f2018 	ldr	r2, [pc, #24]	; 9ab0 <_Z41__static_initialization_and_destruction_0ii+0x44>
    9a94:	e1530002 	cmp	r3, r2
    9a98:	1a000001 	bne	9aa4 <_Z41__static_initialization_and_destruction_0ii+0x38>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:4
CKernel_Heap_Manager sKernelMem;
    9a9c:	e59f0010 	ldr	r0, [pc, #16]	; 9ab4 <_Z41__static_initialization_and_destruction_0ii+0x48>
    9aa0:	ebffff30 	bl	9768 <_ZN20CKernel_Heap_ManagerC1Ev>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:87
    9aa4:	e320f000 	nop	{0}
    9aa8:	e24bd004 	sub	sp, fp, #4
    9aac:	e8bd8800 	pop	{fp, pc}
    9ab0:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>
    9ab4:	0000ae44 	andeq	sl, r0, r4, asr #28

00009ab8 <_GLOBAL__sub_I_sKernelMem>:
_GLOBAL__sub_I_sKernelMem():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:87
    9ab8:	e92d4800 	push	{fp, lr}
    9abc:	e28db004 	add	fp, sp, #4
    9ac0:	e59f1008 	ldr	r1, [pc, #8]	; 9ad0 <_GLOBAL__sub_I_sKernelMem+0x18>
    9ac4:	e3a00001 	mov	r0, #1
    9ac8:	ebffffe7 	bl	9a6c <_Z41__static_initialization_and_destruction_0ii>
    9acc:	e8bd8800 	pop	{fp, pc}
    9ad0:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>

00009ad4 <_ZL11fast_dividejj>:
_ZL11fast_dividejj():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:6
#include <memory/pages.h>
#include <drivers/monitor.h>

CPage_Manager sPage_Manager;

static unsigned fast_divide(unsigned dividend, unsigned divisor) {
    9ad4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9ad8:	e28db000 	add	fp, sp, #0
    9adc:	e24dd014 	sub	sp, sp, #20
    9ae0:	e50b0010 	str	r0, [fp, #-16]
    9ae4:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:7
    unsigned quotient = 0;
    9ae8:	e3a03000 	mov	r3, #0
    9aec:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:8
    unsigned temp = divisor;
    9af0:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9af4:	e50b300c 	str	r3, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:11

    // Shift the divisor left until it's greater than or equal to the dividend
    while (temp <= dividend) {
    9af8:	e51b200c 	ldr	r2, [fp, #-12]
    9afc:	e51b3010 	ldr	r3, [fp, #-16]
    9b00:	e1520003 	cmp	r2, r3
    9b04:	8a000003 	bhi	9b18 <_ZL11fast_dividejj+0x44>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:12
        temp <<= 1;
    9b08:	e51b300c 	ldr	r3, [fp, #-12]
    9b0c:	e1a03083 	lsl	r3, r3, #1
    9b10:	e50b300c 	str	r3, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:11
    while (temp <= dividend) {
    9b14:	eafffff7 	b	9af8 <_ZL11fast_dividejj+0x24>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:16
    }

    // Shift the result right and subtract the divisor repeatedly
    while (divisor <= temp) {
    9b18:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    9b1c:	e51b300c 	ldr	r3, [fp, #-12]
    9b20:	e1520003 	cmp	r2, r3
    9b24:	8a000011 	bhi	9b70 <_ZL11fast_dividejj+0x9c>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:17
        quotient <<= 1;
    9b28:	e51b3008 	ldr	r3, [fp, #-8]
    9b2c:	e1a03083 	lsl	r3, r3, #1
    9b30:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:18
        if (dividend >= temp) {
    9b34:	e51b2010 	ldr	r2, [fp, #-16]
    9b38:	e51b300c 	ldr	r3, [fp, #-12]
    9b3c:	e1520003 	cmp	r2, r3
    9b40:	3a000006 	bcc	9b60 <_ZL11fast_dividejj+0x8c>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:19
            dividend -= temp;
    9b44:	e51b2010 	ldr	r2, [fp, #-16]
    9b48:	e51b300c 	ldr	r3, [fp, #-12]
    9b4c:	e0423003 	sub	r3, r2, r3
    9b50:	e50b3010 	str	r3, [fp, #-16]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:20
            quotient |= 1;
    9b54:	e51b3008 	ldr	r3, [fp, #-8]
    9b58:	e3833001 	orr	r3, r3, #1
    9b5c:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:22
        }
        temp >>= 1;
    9b60:	e51b300c 	ldr	r3, [fp, #-12]
    9b64:	e1a030a3 	lsr	r3, r3, #1
    9b68:	e50b300c 	str	r3, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:16
    while (divisor <= temp) {
    9b6c:	eaffffe9 	b	9b18 <_ZL11fast_dividejj+0x44>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:25
    }

    return quotient;
    9b70:	e51b3008 	ldr	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:26
}
    9b74:	e1a00003 	mov	r0, r3
    9b78:	e28bd000 	add	sp, fp, #0
    9b7c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9b80:	e12fff1e 	bx	lr

00009b84 <_Z12fast_modulusjj>:
_Z12fast_modulusjj():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:28

unsigned fast_modulus(unsigned dividend, unsigned divisor) {
    9b84:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9b88:	e28db000 	add	fp, sp, #0
    9b8c:	e24dd014 	sub	sp, sp, #20
    9b90:	e50b0010 	str	r0, [fp, #-16]
    9b94:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:29
    unsigned temp = divisor;
    9b98:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9b9c:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:32

    // Shift the divisor left until it's greater than or equal to the dividend
    while (temp <= dividend) {
    9ba0:	e51b2008 	ldr	r2, [fp, #-8]
    9ba4:	e51b3010 	ldr	r3, [fp, #-16]
    9ba8:	e1520003 	cmp	r2, r3
    9bac:	8a000003 	bhi	9bc0 <_Z12fast_modulusjj+0x3c>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:33
        temp <<= 1;
    9bb0:	e51b3008 	ldr	r3, [fp, #-8]
    9bb4:	e1a03083 	lsl	r3, r3, #1
    9bb8:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:32
    while (temp <= dividend) {
    9bbc:	eafffff7 	b	9ba0 <_Z12fast_modulusjj+0x1c>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:37
    }

    // Subtract the divisor repeatedly and shift it right until it's less than the original divisor
    while (divisor <= temp) {
    9bc0:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    9bc4:	e51b3008 	ldr	r3, [fp, #-8]
    9bc8:	e1520003 	cmp	r2, r3
    9bcc:	8a00000b 	bhi	9c00 <_Z12fast_modulusjj+0x7c>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:38
        if (dividend >= temp) {
    9bd0:	e51b2010 	ldr	r2, [fp, #-16]
    9bd4:	e51b3008 	ldr	r3, [fp, #-8]
    9bd8:	e1520003 	cmp	r2, r3
    9bdc:	3a000003 	bcc	9bf0 <_Z12fast_modulusjj+0x6c>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:39
            dividend -= temp;
    9be0:	e51b2010 	ldr	r2, [fp, #-16]
    9be4:	e51b3008 	ldr	r3, [fp, #-8]
    9be8:	e0423003 	sub	r3, r2, r3
    9bec:	e50b3010 	str	r3, [fp, #-16]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:41
        }
        temp >>= 1;
    9bf0:	e51b3008 	ldr	r3, [fp, #-8]
    9bf4:	e1a030a3 	lsr	r3, r3, #1
    9bf8:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:37
    while (divisor <= temp) {
    9bfc:	eaffffef 	b	9bc0 <_Z12fast_modulusjj+0x3c>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:44
    }

    return dividend;
    9c00:	e51b3010 	ldr	r3, [fp, #-16]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:45
}
    9c04:	e1a00003 	mov	r0, r3
    9c08:	e28bd000 	add	sp, fp, #0
    9c0c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9c10:	e12fff1e 	bx	lr

00009c14 <_ZN13CPage_ManagerC1Ev>:
_ZN13CPage_ManagerC2Ev():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:47

CPage_Manager::CPage_Manager()
    9c14:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9c18:	e28db000 	add	fp, sp, #0
    9c1c:	e24dd014 	sub	sp, sp, #20
    9c20:	e50b0010 	str	r0, [fp, #-16]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:50
{
    // zadna stranka neni alokovana
    for (int i = 0; i < sizeof(mPage_Bitmap); i++)
    9c24:	e3a03000 	mov	r3, #0
    9c28:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:50 (discriminator 3)
    9c2c:	e51b3008 	ldr	r3, [fp, #-8]
    9c30:	e59f203c 	ldr	r2, [pc, #60]	; 9c74 <_ZN13CPage_ManagerC1Ev+0x60>
    9c34:	e1530002 	cmp	r3, r2
    9c38:	8a000008 	bhi	9c60 <_ZN13CPage_ManagerC1Ev+0x4c>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:51 (discriminator 2)
        mPage_Bitmap[i] = 0;
    9c3c:	e51b2010 	ldr	r2, [fp, #-16]
    9c40:	e51b3008 	ldr	r3, [fp, #-8]
    9c44:	e0823003 	add	r3, r2, r3
    9c48:	e3a02000 	mov	r2, #0
    9c4c:	e5c32000 	strb	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:50 (discriminator 2)
    for (int i = 0; i < sizeof(mPage_Bitmap); i++)
    9c50:	e51b3008 	ldr	r3, [fp, #-8]
    9c54:	e2833001 	add	r3, r3, #1
    9c58:	e50b3008 	str	r3, [fp, #-8]
    9c5c:	eafffff2 	b	9c2c <_ZN13CPage_ManagerC1Ev+0x18>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:54

    // nutno dodat, ze strankovatelna pamet implicitne nezahrnuje pamet, kam se nahralo jadro
}
    9c60:	e51b3010 	ldr	r3, [fp, #-16]
    9c64:	e1a00003 	mov	r0, r3
    9c68:	e28bd000 	add	sp, fp, #0
    9c6c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9c70:	e12fff1e 	bx	lr
    9c74:	00000ffe 	strdeq	r0, [r0], -lr

00009c78 <_ZN13CPage_Manager4MarkEjb>:
_ZN13CPage_Manager4MarkEjb():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:57

void CPage_Manager::Mark(uint32_t page_idx, bool used)
{
    9c78:	e92d4810 	push	{r4, fp, lr}
    9c7c:	e28db008 	add	fp, sp, #8
    9c80:	e24dd014 	sub	sp, sp, #20
    9c84:	e50b0010 	str	r0, [fp, #-16]
    9c88:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    9c8c:	e1a03002 	mov	r3, r2
    9c90:	e54b3015 	strb	r3, [fp, #-21]	; 0xffffffeb
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:58
    if (used)
    9c94:	e55b3015 	ldrb	r3, [fp, #-21]	; 0xffffffeb
    9c98:	e3530000 	cmp	r3, #0
    9c9c:	0a000013 	beq	9cf0 <_ZN13CPage_Manager4MarkEjb+0x78>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:59
        mPage_Bitmap[fast_divide(page_idx, 8)] |= 1 << fast_modulus(page_idx, 8);
    9ca0:	e3a01008 	mov	r1, #8
    9ca4:	e51b0014 	ldr	r0, [fp, #-20]	; 0xffffffec
    9ca8:	ebffffb5 	bl	9b84 <_Z12fast_modulusjj>
    9cac:	e1a03000 	mov	r3, r0
    9cb0:	e3a02001 	mov	r2, #1
    9cb4:	e1a04312 	lsl	r4, r2, r3
    9cb8:	e3a01008 	mov	r1, #8
    9cbc:	e51b0014 	ldr	r0, [fp, #-20]	; 0xffffffec
    9cc0:	ebffff83 	bl	9ad4 <_ZL11fast_dividejj>
    9cc4:	e1a03000 	mov	r3, r0
    9cc8:	e51b2010 	ldr	r2, [fp, #-16]
    9ccc:	e7d22003 	ldrb	r2, [r2, r3]
    9cd0:	e6af1072 	sxtb	r1, r2
    9cd4:	e6af2074 	sxtb	r2, r4
    9cd8:	e1812002 	orr	r2, r1, r2
    9cdc:	e6af2072 	sxtb	r2, r2
    9ce0:	e6ef1072 	uxtb	r1, r2
    9ce4:	e51b2010 	ldr	r2, [fp, #-16]
    9ce8:	e7c21003 	strb	r1, [r2, r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:62
    else
        mPage_Bitmap[fast_divide(page_idx, 8)] &= ~(1 << fast_modulus(page_idx, 8));
}
    9cec:	ea000013 	b	9d40 <_ZN13CPage_Manager4MarkEjb+0xc8>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:61
        mPage_Bitmap[fast_divide(page_idx, 8)] &= ~(1 << fast_modulus(page_idx, 8));
    9cf0:	e3a01008 	mov	r1, #8
    9cf4:	e51b0014 	ldr	r0, [fp, #-20]	; 0xffffffec
    9cf8:	ebffffa1 	bl	9b84 <_Z12fast_modulusjj>
    9cfc:	e1a03000 	mov	r3, r0
    9d00:	e3a02001 	mov	r2, #1
    9d04:	e1a03312 	lsl	r3, r2, r3
    9d08:	e1e04003 	mvn	r4, r3
    9d0c:	e3a01008 	mov	r1, #8
    9d10:	e51b0014 	ldr	r0, [fp, #-20]	; 0xffffffec
    9d14:	ebffff6e 	bl	9ad4 <_ZL11fast_dividejj>
    9d18:	e1a03000 	mov	r3, r0
    9d1c:	e51b2010 	ldr	r2, [fp, #-16]
    9d20:	e7d22003 	ldrb	r2, [r2, r3]
    9d24:	e6af1072 	sxtb	r1, r2
    9d28:	e6af2074 	sxtb	r2, r4
    9d2c:	e0022001 	and	r2, r2, r1
    9d30:	e6af2072 	sxtb	r2, r2
    9d34:	e6ef1072 	uxtb	r1, r2
    9d38:	e51b2010 	ldr	r2, [fp, #-16]
    9d3c:	e7c21003 	strb	r1, [r2, r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:62
}
    9d40:	e320f000 	nop	{0}
    9d44:	e24bd008 	sub	sp, fp, #8
    9d48:	e8bd8810 	pop	{r4, fp, pc}

00009d4c <_ZN13CPage_Manager10Alloc_PageEv>:
_ZN13CPage_Manager10Alloc_PageEv():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:65

uint32_t CPage_Manager::Alloc_Page()
{
    9d4c:	e92d4800 	push	{fp, lr}
    9d50:	e28db004 	add	fp, sp, #4
    9d54:	e24dd020 	sub	sp, sp, #32
    9d58:	e50b0020 	str	r0, [fp, #-32]	; 0xffffffe0
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:71
    // VELMI jednoduchy alokator stranek, prochazi bitmapu a hleda prvni volne misto
    // to je samozrejme O(n) a pro prakticke pouziti ne uplne dobre, ale k tomuto problemu az jindy

    uint32_t i, j;
    
    sMonitor << "mem::PageCount = \0" << mem::PageCount << '\n';
    9d5c:	e59f11cc 	ldr	r1, [pc, #460]	; 9f30 <_ZN13CPage_Manager10Alloc_PageEv+0x1e4>
    9d60:	e59f01cc 	ldr	r0, [pc, #460]	; 9f34 <_ZN13CPage_Manager10Alloc_PageEv+0x1e8>
    9d64:	ebfffb10 	bl	89ac <_ZN8CMonitorlsEPKc>
    9d68:	e1a03000 	mov	r3, r0
    9d6c:	e59f11c4 	ldr	r1, [pc, #452]	; 9f38 <_ZN13CPage_Manager10Alloc_PageEv+0x1ec>
    9d70:	e1a00003 	mov	r0, r3
    9d74:	ebfffb37 	bl	8a58 <_ZN8CMonitorlsEj>
    9d78:	e1a03000 	mov	r3, r0
    9d7c:	e3a0100a 	mov	r1, #10
    9d80:	e1a00003 	mov	r0, r3
    9d84:	ebfffade 	bl	8904 <_ZN8CMonitorlsEc>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:74

    // projdeme vsechny stranky
    for (i = 0; i < mem::PageCount; i++)
    9d88:	e3a03000 	mov	r3, #0
    9d8c:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:74 (discriminator 1)
    9d90:	e51b3008 	ldr	r3, [fp, #-8]
    9d94:	e59f21a0 	ldr	r2, [pc, #416]	; 9f3c <_ZN13CPage_Manager10Alloc_PageEv+0x1f0>
    9d98:	e1530002 	cmp	r3, r2
    9d9c:	8a00005f 	bhi	9f20 <_ZN13CPage_Manager10Alloc_PageEv+0x1d4>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:77
    {
        // je v dane osmici volna nejaka stranka? (0xFF = vse obsazeno)
        if (mPage_Bitmap[i] != 0xFF)
    9da0:	e51b2020 	ldr	r2, [fp, #-32]	; 0xffffffe0
    9da4:	e51b3008 	ldr	r3, [fp, #-8]
    9da8:	e0823003 	add	r3, r2, r3
    9dac:	e5d33000 	ldrb	r3, [r3]
    9db0:	e35300ff 	cmp	r3, #255	; 0xff
    9db4:	0a000055 	beq	9f10 <_ZN13CPage_Manager10Alloc_PageEv+0x1c4>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:80
        {
            // projdeme vsechny bity a najdeme ten co je volny
            for (j = 0; j < 8; j++)
    9db8:	e3a03000 	mov	r3, #0
    9dbc:	e50b300c 	str	r3, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:80 (discriminator 1)
    9dc0:	e51b300c 	ldr	r3, [fp, #-12]
    9dc4:	e3530007 	cmp	r3, #7
    9dc8:	8a000050 	bhi	9f10 <_ZN13CPage_Manager10Alloc_PageEv+0x1c4>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:82
            {
                const uint32_t slot = mPage_Bitmap[i];
    9dcc:	e51b2020 	ldr	r2, [fp, #-32]	; 0xffffffe0
    9dd0:	e51b3008 	ldr	r3, [fp, #-8]
    9dd4:	e0823003 	add	r3, r2, r3
    9dd8:	e5d33000 	ldrb	r3, [r3]
    9ddc:	e50b3010 	str	r3, [fp, #-16]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:83
                const uint32_t mask = 1 << j; 
    9de0:	e3a02001 	mov	r2, #1
    9de4:	e51b300c 	ldr	r3, [fp, #-12]
    9de8:	e1a03312 	lsl	r3, r2, r3
    9dec:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:85
                
                if ((slot & mask) == 0)
    9df0:	e51b2010 	ldr	r2, [fp, #-16]
    9df4:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9df8:	e0033002 	and	r3, r3, r2
    9dfc:	e3530000 	cmp	r3, #0
    9e00:	1a00003e 	bne	9f00 <_ZN13CPage_Manager10Alloc_PageEv+0x1b4>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:88
                {
                    // oznacime 
                    const uint32_t page_idx = i*8 + j;
    9e04:	e51b3008 	ldr	r3, [fp, #-8]
    9e08:	e1a03183 	lsl	r3, r3, #3
    9e0c:	e51b200c 	ldr	r2, [fp, #-12]
    9e10:	e0823003 	add	r3, r2, r3
    9e14:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:89
                    sMonitor << "j = \0" << j << '\n';
    9e18:	e59f1120 	ldr	r1, [pc, #288]	; 9f40 <_ZN13CPage_Manager10Alloc_PageEv+0x1f4>
    9e1c:	e59f0110 	ldr	r0, [pc, #272]	; 9f34 <_ZN13CPage_Manager10Alloc_PageEv+0x1e8>
    9e20:	ebfffae1 	bl	89ac <_ZN8CMonitorlsEPKc>
    9e24:	e1a03000 	mov	r3, r0
    9e28:	e51b100c 	ldr	r1, [fp, #-12]
    9e2c:	e1a00003 	mov	r0, r3
    9e30:	ebfffb08 	bl	8a58 <_ZN8CMonitorlsEj>
    9e34:	e1a03000 	mov	r3, r0
    9e38:	e3a0100a 	mov	r1, #10
    9e3c:	e1a00003 	mov	r0, r3
    9e40:	ebfffaaf 	bl	8904 <_ZN8CMonitorlsEc>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:90
                    sMonitor << "mPage_Bitmap[i] = \0" << (unsigned int)mPage_Bitmap[i] << '\n';
    9e44:	e59f10f8 	ldr	r1, [pc, #248]	; 9f44 <_ZN13CPage_Manager10Alloc_PageEv+0x1f8>
    9e48:	e59f00e4 	ldr	r0, [pc, #228]	; 9f34 <_ZN13CPage_Manager10Alloc_PageEv+0x1e8>
    9e4c:	ebfffad6 	bl	89ac <_ZN8CMonitorlsEPKc>
    9e50:	e51b2020 	ldr	r2, [fp, #-32]	; 0xffffffe0
    9e54:	e51b3008 	ldr	r3, [fp, #-8]
    9e58:	e0823003 	add	r3, r2, r3
    9e5c:	e5d33000 	ldrb	r3, [r3]
    9e60:	e1a01003 	mov	r1, r3
    9e64:	ebfffafb 	bl	8a58 <_ZN8CMonitorlsEj>
    9e68:	e1a03000 	mov	r3, r0
    9e6c:	e3a0100a 	mov	r1, #10
    9e70:	e1a00003 	mov	r0, r3
    9e74:	ebfffaa2 	bl	8904 <_ZN8CMonitorlsEc>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:91
                    sMonitor << (unsigned int)mPage_Bitmap[fast_divide(page_idx, 8)] << '\n';
    9e78:	e3a01008 	mov	r1, #8
    9e7c:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    9e80:	ebffff13 	bl	9ad4 <_ZL11fast_dividejj>
    9e84:	e1a02000 	mov	r2, r0
    9e88:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    9e8c:	e7d33002 	ldrb	r3, [r3, r2]
    9e90:	e1a01003 	mov	r1, r3
    9e94:	e59f0098 	ldr	r0, [pc, #152]	; 9f34 <_ZN13CPage_Manager10Alloc_PageEv+0x1e8>
    9e98:	ebfffaee 	bl	8a58 <_ZN8CMonitorlsEj>
    9e9c:	e1a03000 	mov	r3, r0
    9ea0:	e3a0100a 	mov	r1, #10
    9ea4:	e1a00003 	mov	r0, r3
    9ea8:	ebfffa95 	bl	8904 <_ZN8CMonitorlsEc>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:92
                    Mark(page_idx, true);
    9eac:	e3a02001 	mov	r2, #1
    9eb0:	e51b1018 	ldr	r1, [fp, #-24]	; 0xffffffe8
    9eb4:	e51b0020 	ldr	r0, [fp, #-32]	; 0xffffffe0
    9eb8:	ebffff6e 	bl	9c78 <_ZN13CPage_Manager4MarkEjb>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:93
                    sMonitor << (unsigned int)mPage_Bitmap[fast_divide(page_idx, 8)] << '\n';
    9ebc:	e3a01008 	mov	r1, #8
    9ec0:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    9ec4:	ebffff02 	bl	9ad4 <_ZL11fast_dividejj>
    9ec8:	e1a02000 	mov	r2, r0
    9ecc:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    9ed0:	e7d33002 	ldrb	r3, [r3, r2]
    9ed4:	e1a01003 	mov	r1, r3
    9ed8:	e59f0054 	ldr	r0, [pc, #84]	; 9f34 <_ZN13CPage_Manager10Alloc_PageEv+0x1e8>
    9edc:	ebfffadd 	bl	8a58 <_ZN8CMonitorlsEj>
    9ee0:	e1a03000 	mov	r3, r0
    9ee4:	e3a0100a 	mov	r1, #10
    9ee8:	e1a00003 	mov	r0, r3
    9eec:	ebfffa84 	bl	8904 <_ZN8CMonitorlsEc>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:95
                    
                    return mem::LowMemory + page_idx * mem::PageSize;
    9ef0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9ef4:	e2833008 	add	r3, r3, #8
    9ef8:	e1a03703 	lsl	r3, r3, #14
    9efc:	ea000008 	b	9f24 <_ZN13CPage_Manager10Alloc_PageEv+0x1d8>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:80 (discriminator 2)
            for (j = 0; j < 8; j++)
    9f00:	e51b300c 	ldr	r3, [fp, #-12]
    9f04:	e2833001 	add	r3, r3, #1
    9f08:	e50b300c 	str	r3, [fp, #-12]
    9f0c:	eaffffab 	b	9dc0 <_ZN13CPage_Manager10Alloc_PageEv+0x74>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:74 (discriminator 2)
    for (i = 0; i < mem::PageCount; i++)
    9f10:	e51b3008 	ldr	r3, [fp, #-8]
    9f14:	e2833001 	add	r3, r3, #1
    9f18:	e50b3008 	str	r3, [fp, #-8]
    9f1c:	eaffff9b 	b	9d90 <_ZN13CPage_Manager10Alloc_PageEv+0x44>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:101
                }
            }
        }
    }

    return 0;
    9f20:	e3a03000 	mov	r3, #0
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:102
}
    9f24:	e1a00003 	mov	r0, r3
    9f28:	e24bd004 	sub	sp, fp, #4
    9f2c:	e8bd8800 	pop	{fp, pc}
    9f30:	0000ad44 	andeq	sl, r0, r4, asr #26
    9f34:	0000ae0c 	andeq	sl, r0, ip, lsl #28
    9f38:	00007ff8 	strdeq	r7, [r0], -r8
    9f3c:	00007ff7 	strdeq	r7, [r0], -r7	; <UNPREDICTABLE>
    9f40:	0000ad58 	andeq	sl, r0, r8, asr sp
    9f44:	0000ad60 	andeq	sl, r0, r0, ror #26

00009f48 <_ZN13CPage_Manager9Free_PageEj>:
_ZN13CPage_Manager9Free_PageEj():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:105

void CPage_Manager::Free_Page(uint32_t fa)
{
    9f48:	e92d4800 	push	{fp, lr}
    9f4c:	e28db004 	add	fp, sp, #4
    9f50:	e24dd008 	sub	sp, sp, #8
    9f54:	e50b0008 	str	r0, [fp, #-8]
    9f58:	e50b100c 	str	r1, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:108
    // pro vyssi bezpecnost v nejakych safe systemech lze tady data stranky premazavat napr. nulami po dealokaci

    Mark(fa / mem::PageSize, false);
    9f5c:	e51b300c 	ldr	r3, [fp, #-12]
    9f60:	e1a03723 	lsr	r3, r3, #14
    9f64:	e3a02000 	mov	r2, #0
    9f68:	e1a01003 	mov	r1, r3
    9f6c:	e51b0008 	ldr	r0, [fp, #-8]
    9f70:	ebffff40 	bl	9c78 <_ZN13CPage_Manager4MarkEjb>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:109
}
    9f74:	e320f000 	nop	{0}
    9f78:	e24bd004 	sub	sp, fp, #4
    9f7c:	e8bd8800 	pop	{fp, pc}

00009f80 <_Z41__static_initialization_and_destruction_0ii>:
_Z41__static_initialization_and_destruction_0ii():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:109
    9f80:	e92d4800 	push	{fp, lr}
    9f84:	e28db004 	add	fp, sp, #4
    9f88:	e24dd008 	sub	sp, sp, #8
    9f8c:	e50b0008 	str	r0, [fp, #-8]
    9f90:	e50b100c 	str	r1, [fp, #-12]
    9f94:	e51b3008 	ldr	r3, [fp, #-8]
    9f98:	e3530001 	cmp	r3, #1
    9f9c:	1a000005 	bne	9fb8 <_Z41__static_initialization_and_destruction_0ii+0x38>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:109 (discriminator 1)
    9fa0:	e51b300c 	ldr	r3, [fp, #-12]
    9fa4:	e59f2018 	ldr	r2, [pc, #24]	; 9fc4 <_Z41__static_initialization_and_destruction_0ii+0x44>
    9fa8:	e1530002 	cmp	r3, r2
    9fac:	1a000001 	bne	9fb8 <_Z41__static_initialization_and_destruction_0ii+0x38>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:4
CPage_Manager sPage_Manager;
    9fb0:	e59f0010 	ldr	r0, [pc, #16]	; 9fc8 <_Z41__static_initialization_and_destruction_0ii+0x48>
    9fb4:	ebffff16 	bl	9c14 <_ZN13CPage_ManagerC1Ev>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:109
}
    9fb8:	e320f000 	nop	{0}
    9fbc:	e24bd004 	sub	sp, fp, #4
    9fc0:	e8bd8800 	pop	{fp, pc}
    9fc4:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>
    9fc8:	0000ae48 	andeq	sl, r0, r8, asr #28

00009fcc <_GLOBAL__sub_I_sPage_Manager>:
_GLOBAL__sub_I_sPage_Manager():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:109
    9fcc:	e92d4800 	push	{fp, lr}
    9fd0:	e28db004 	add	fp, sp, #4
    9fd4:	e59f1008 	ldr	r1, [pc, #8]	; 9fe4 <_GLOBAL__sub_I_sPage_Manager+0x18>
    9fd8:	e3a00001 	mov	r0, #1
    9fdc:	ebffffe7 	bl	9f80 <_Z41__static_initialization_and_destruction_0ii>
    9fe0:	e8bd8800 	pop	{fp, pc}
    9fe4:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>

00009fe8 <_ZN16CProcess_ManagerC1Ev>:
_ZN16CProcess_ManagerC2Ev():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:18
    void context_switch_first(TCPU_Context* ctx_to, TCPU_Context* ctx_from);
};

CProcess_Manager sProcessMgr;

CProcess_Manager::CProcess_Manager()
    9fe8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9fec:	e28db000 	add	fp, sp, #0
    9ff0:	e24dd00c 	sub	sp, sp, #12
    9ff4:	e50b0008 	str	r0, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:19
    : mLast_PID(0), mProcess_List_Head(nullptr), mCurrent_Task_Node(nullptr)
    9ff8:	e51b3008 	ldr	r3, [fp, #-8]
    9ffc:	e3a02000 	mov	r2, #0
    a000:	e5832000 	str	r2, [r3]
    a004:	e51b3008 	ldr	r3, [fp, #-8]
    a008:	e3a02000 	mov	r2, #0
    a00c:	e5832004 	str	r2, [r3, #4]
    a010:	e51b3008 	ldr	r3, [fp, #-8]
    a014:	e3a02000 	mov	r2, #0
    a018:	e5832008 	str	r2, [r3, #8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:22
{
    //
}
    a01c:	e51b3008 	ldr	r3, [fp, #-8]
    a020:	e1a00003 	mov	r0, r3
    a024:	e28bd000 	add	sp, fp, #0
    a028:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    a02c:	e12fff1e 	bx	lr

0000a030 <_ZNK16CProcess_Manager19Get_Current_ProcessEv>:
_ZNK16CProcess_Manager19Get_Current_ProcessEv():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:25

TTask_Struct* CProcess_Manager::Get_Current_Process() const
{
    a030:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    a034:	e28db000 	add	fp, sp, #0
    a038:	e24dd00c 	sub	sp, sp, #12
    a03c:	e50b0008 	str	r0, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:26
    return mCurrent_Task_Node ? mCurrent_Task_Node->task : nullptr;
    a040:	e51b3008 	ldr	r3, [fp, #-8]
    a044:	e5933008 	ldr	r3, [r3, #8]
    a048:	e3530000 	cmp	r3, #0
    a04c:	0a000003 	beq	a060 <_ZNK16CProcess_Manager19Get_Current_ProcessEv+0x30>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:26 (discriminator 1)
    a050:	e51b3008 	ldr	r3, [fp, #-8]
    a054:	e5933008 	ldr	r3, [r3, #8]
    a058:	e5933008 	ldr	r3, [r3, #8]
    a05c:	ea000000 	b	a064 <_ZNK16CProcess_Manager19Get_Current_ProcessEv+0x34>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:26 (discriminator 2)
    a060:	e3a03000 	mov	r3, #0
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:27 (discriminator 5)
}
    a064:	e1a00003 	mov	r0, r3
    a068:	e28bd000 	add	sp, fp, #0
    a06c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    a070:	e12fff1e 	bx	lr

0000a074 <_ZN16CProcess_Manager19Create_Main_ProcessEv>:
_ZN16CProcess_Manager19Create_Main_ProcessEv():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:30

void CProcess_Manager::Create_Main_Process()
{
    a074:	e92d4800 	push	{fp, lr}
    a078:	e28db004 	add	fp, sp, #4
    a07c:	e24dd010 	sub	sp, sp, #16
    a080:	e50b0010 	str	r0, [fp, #-16]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:31
    CProcess_List_Node* procnode = sKernelMem.Alloc<CProcess_List_Node>();
    a084:	e59f00d8 	ldr	r0, [pc, #216]	; a164 <_ZN16CProcess_Manager19Create_Main_ProcessEv+0xf0>
    a088:	eb00011a 	bl	a4f8 <_ZN20CKernel_Heap_Manager5AllocI18CProcess_List_NodeEEPT_v>
    a08c:	e1a03000 	mov	r3, r0
    a090:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:33

    procnode->next = mProcess_List_Head;
    a094:	e51b3010 	ldr	r3, [fp, #-16]
    a098:	e5932004 	ldr	r2, [r3, #4]
    a09c:	e51b3008 	ldr	r3, [fp, #-8]
    a0a0:	e5832004 	str	r2, [r3, #4]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:34
    procnode->prev = nullptr;
    a0a4:	e51b3008 	ldr	r3, [fp, #-8]
    a0a8:	e3a02000 	mov	r2, #0
    a0ac:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:35
    if (mProcess_List_Head == nullptr)
    a0b0:	e51b3010 	ldr	r3, [fp, #-16]
    a0b4:	e5933004 	ldr	r3, [r3, #4]
    a0b8:	e3530000 	cmp	r3, #0
    a0bc:	1a000002 	bne	a0cc <_ZN16CProcess_Manager19Create_Main_ProcessEv+0x58>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:37
    {
        mProcess_List_Head = procnode;
    a0c0:	e51b3010 	ldr	r3, [fp, #-16]
    a0c4:	e51b2008 	ldr	r2, [fp, #-8]
    a0c8:	e5832004 	str	r2, [r3, #4]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:39
    }
    mProcess_List_Head->prev = procnode;
    a0cc:	e51b3010 	ldr	r3, [fp, #-16]
    a0d0:	e5933004 	ldr	r3, [r3, #4]
    a0d4:	e51b2008 	ldr	r2, [fp, #-8]
    a0d8:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:41

    procnode->task = sKernelMem.Alloc<TTask_Struct>();
    a0dc:	e59f0080 	ldr	r0, [pc, #128]	; a164 <_ZN16CProcess_Manager19Create_Main_ProcessEv+0xf0>
    a0e0:	eb00010f 	bl	a524 <_ZN20CKernel_Heap_Manager5AllocI12TTask_StructEEPT_v>
    a0e4:	e1a02000 	mov	r2, r0
    a0e8:	e51b3008 	ldr	r3, [fp, #-8]
    a0ec:	e5832008 	str	r2, [r3, #8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:43

    auto* task = procnode->task;
    a0f0:	e51b3008 	ldr	r3, [fp, #-8]
    a0f4:	e5933008 	ldr	r3, [r3, #8]
    a0f8:	e50b300c 	str	r3, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:45

    task->pid = ++mLast_PID;
    a0fc:	e51b3010 	ldr	r3, [fp, #-16]
    a100:	e5933000 	ldr	r3, [r3]
    a104:	e2832001 	add	r2, r3, #1
    a108:	e51b3010 	ldr	r3, [fp, #-16]
    a10c:	e5832000 	str	r2, [r3]
    a110:	e51b3010 	ldr	r3, [fp, #-16]
    a114:	e5932000 	ldr	r2, [r3]
    a118:	e51b300c 	ldr	r3, [fp, #-12]
    a11c:	e583200c 	str	r2, [r3, #12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:46
    task->sched_static_priority = 5;
    a120:	e51b300c 	ldr	r3, [fp, #-12]
    a124:	e3a02005 	mov	r2, #5
    a128:	e5832018 	str	r2, [r3, #24]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:47
    task->sched_counter = task->sched_static_priority;
    a12c:	e51b300c 	ldr	r3, [fp, #-12]
    a130:	e5932018 	ldr	r2, [r3, #24]
    a134:	e51b300c 	ldr	r3, [fp, #-12]
    a138:	e5832014 	str	r2, [r3, #20]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:48
    task->state = NTask_State::Running;
    a13c:	e51b300c 	ldr	r3, [fp, #-12]
    a140:	e3a02002 	mov	r2, #2
    a144:	e5832010 	str	r2, [r3, #16]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:50

    mCurrent_Task_Node = mProcess_List_Head;
    a148:	e51b3010 	ldr	r3, [fp, #-16]
    a14c:	e5932004 	ldr	r2, [r3, #4]
    a150:	e51b3010 	ldr	r3, [fp, #-16]
    a154:	e5832008 	str	r2, [r3, #8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:51
}
    a158:	e320f000 	nop	{0}
    a15c:	e24bd004 	sub	sp, fp, #4
    a160:	e8bd8800 	pop	{fp, pc}
    a164:	0000ae44 	andeq	sl, r0, r4, asr #28

0000a168 <_ZN16CProcess_Manager14Create_ProcessEm>:
_ZN16CProcess_Manager14Create_ProcessEm():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:54

uint32_t CProcess_Manager::Create_Process(unsigned long funcptr)
{
    a168:	e92d4800 	push	{fp, lr}
    a16c:	e28db004 	add	fp, sp, #4
    a170:	e24dd010 	sub	sp, sp, #16
    a174:	e50b0010 	str	r0, [fp, #-16]
    a178:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:55
    CProcess_List_Node* procnode = sKernelMem.Alloc<CProcess_List_Node>();
    a17c:	e59f0154 	ldr	r0, [pc, #340]	; a2d8 <_ZN16CProcess_Manager14Create_ProcessEm+0x170>
    a180:	eb0000dc 	bl	a4f8 <_ZN20CKernel_Heap_Manager5AllocI18CProcess_List_NodeEEPT_v>
    a184:	e1a03000 	mov	r3, r0
    a188:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:57

    procnode->next = mProcess_List_Head;
    a18c:	e51b3010 	ldr	r3, [fp, #-16]
    a190:	e5932004 	ldr	r2, [r3, #4]
    a194:	e51b3008 	ldr	r3, [fp, #-8]
    a198:	e5832004 	str	r2, [r3, #4]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:58
    procnode->prev = nullptr;
    a19c:	e51b3008 	ldr	r3, [fp, #-8]
    a1a0:	e3a02000 	mov	r2, #0
    a1a4:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:59
    if (mProcess_List_Head != nullptr)
    a1a8:	e51b3010 	ldr	r3, [fp, #-16]
    a1ac:	e5933004 	ldr	r3, [r3, #4]
    a1b0:	e3530000 	cmp	r3, #0
    a1b4:	0a000007 	beq	a1d8 <_ZN16CProcess_Manager14Create_ProcessEm+0x70>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:61
    {
        mProcess_List_Head->prev = procnode;
    a1b8:	e51b3010 	ldr	r3, [fp, #-16]
    a1bc:	e5933004 	ldr	r3, [r3, #4]
    a1c0:	e51b2008 	ldr	r2, [fp, #-8]
    a1c4:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:62
        mCurrent_Task_Node = mProcess_List_Head;
    a1c8:	e51b3010 	ldr	r3, [fp, #-16]
    a1cc:	e5932004 	ldr	r2, [r3, #4]
    a1d0:	e51b3010 	ldr	r3, [fp, #-16]
    a1d4:	e5832008 	str	r2, [r3, #8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:64
    }
    mProcess_List_Head = procnode;
    a1d8:	e51b3010 	ldr	r3, [fp, #-16]
    a1dc:	e51b2008 	ldr	r2, [fp, #-8]
    a1e0:	e5832004 	str	r2, [r3, #4]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:66

    procnode->task = sKernelMem.Alloc<TTask_Struct>();
    a1e4:	e59f00ec 	ldr	r0, [pc, #236]	; a2d8 <_ZN16CProcess_Manager14Create_ProcessEm+0x170>
    a1e8:	eb0000cd 	bl	a524 <_ZN20CKernel_Heap_Manager5AllocI12TTask_StructEEPT_v>
    a1ec:	e1a02000 	mov	r2, r0
    a1f0:	e51b3008 	ldr	r3, [fp, #-8]
    a1f4:	e5832008 	str	r2, [r3, #8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:68

    auto* task = procnode->task;
    a1f8:	e51b3008 	ldr	r3, [fp, #-8]
    a1fc:	e5933008 	ldr	r3, [r3, #8]
    a200:	e50b300c 	str	r3, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:70

    task->pid = ++mLast_PID;
    a204:	e51b3010 	ldr	r3, [fp, #-16]
    a208:	e5933000 	ldr	r3, [r3]
    a20c:	e2832001 	add	r2, r3, #1
    a210:	e51b3010 	ldr	r3, [fp, #-16]
    a214:	e5832000 	str	r2, [r3]
    a218:	e51b3010 	ldr	r3, [fp, #-16]
    a21c:	e5932000 	ldr	r2, [r3]
    a220:	e51b300c 	ldr	r3, [fp, #-12]
    a224:	e583200c 	str	r2, [r3, #12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:71
    task->sched_static_priority = 5;
    a228:	e51b300c 	ldr	r3, [fp, #-12]
    a22c:	e3a02005 	mov	r2, #5
    a230:	e5832018 	str	r2, [r3, #24]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:72
    task->sched_counter = task->sched_static_priority;
    a234:	e51b300c 	ldr	r3, [fp, #-12]
    a238:	e5932018 	ldr	r2, [r3, #24]
    a23c:	e51b300c 	ldr	r3, [fp, #-12]
    a240:	e5832014 	str	r2, [r3, #20]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:73
    task->state = NTask_State::New;
    a244:	e51b300c 	ldr	r3, [fp, #-12]
    a248:	e3a02000 	mov	r2, #0
    a24c:	e5832010 	str	r2, [r3, #16]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:75
    
    task->cpu_context.lr = funcptr;
    a250:	e51b300c 	ldr	r3, [fp, #-12]
    a254:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    a258:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:76
    task->cpu_context.pc = reinterpret_cast<unsigned long>(&process_bootstrap);
    a25c:	e59f2078 	ldr	r2, [pc, #120]	; a2dc <_ZN16CProcess_Manager14Create_ProcessEm+0x174>
    a260:	e51b300c 	ldr	r3, [fp, #-12]
    a264:	e5832008 	str	r2, [r3, #8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:77
    task->cpu_context.sp = static_cast<unsigned long>(sPage_Manager.Alloc_Page()) + mem::PageSize;
    a268:	e59f0070 	ldr	r0, [pc, #112]	; a2e0 <_ZN16CProcess_Manager14Create_ProcessEm+0x178>
    a26c:	ebfffeb6 	bl	9d4c <_ZN13CPage_Manager10Alloc_PageEv>
    a270:	e1a03000 	mov	r3, r0
    a274:	e2832901 	add	r2, r3, #16384	; 0x4000
    a278:	e51b300c 	ldr	r3, [fp, #-12]
    a27c:	e5832004 	str	r2, [r3, #4]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:79
    
    sMonitor << "0x" << CMonitor::NNumber_Base::HEX << (unsigned int)task->cpu_context.sp << '\n';
    a280:	e59f105c 	ldr	r1, [pc, #92]	; a2e4 <_ZN16CProcess_Manager14Create_ProcessEm+0x17c>
    a284:	e59f005c 	ldr	r0, [pc, #92]	; a2e8 <_ZN16CProcess_Manager14Create_ProcessEm+0x180>
    a288:	ebfff9c7 	bl	89ac <_ZN8CMonitorlsEPKc>
    a28c:	e1a03000 	mov	r3, r0
    a290:	e3a01010 	mov	r1, #16
    a294:	e1a00003 	mov	r0, r3
    a298:	ebfff9e1 	bl	8a24 <_ZN8CMonitorlsENS_12NNumber_BaseE>
    a29c:	e1a02000 	mov	r2, r0
    a2a0:	e51b300c 	ldr	r3, [fp, #-12]
    a2a4:	e5933004 	ldr	r3, [r3, #4]
    a2a8:	e1a01003 	mov	r1, r3
    a2ac:	e1a00002 	mov	r0, r2
    a2b0:	ebfff9e8 	bl	8a58 <_ZN8CMonitorlsEj>
    a2b4:	e1a03000 	mov	r3, r0
    a2b8:	e3a0100a 	mov	r1, #10
    a2bc:	e1a00003 	mov	r0, r3
    a2c0:	ebfff98f 	bl	8904 <_ZN8CMonitorlsEc>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:81

    return task->pid;
    a2c4:	e51b300c 	ldr	r3, [fp, #-12]
    a2c8:	e593300c 	ldr	r3, [r3, #12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:82
}
    a2cc:	e1a00003 	mov	r0, r3
    a2d0:	e24bd004 	sub	sp, fp, #4
    a2d4:	e8bd8800 	pop	{fp, pc}
    a2d8:	0000ae44 	andeq	sl, r0, r4, asr #28
    a2dc:	0000a550 	andeq	sl, r0, r0, asr r5
    a2e0:	0000ae48 	andeq	sl, r0, r8, asr #28
    a2e4:	0000ada4 	andeq	sl, r0, r4, lsr #27
    a2e8:	0000ae0c 	andeq	sl, r0, ip, lsl #28

0000a2ec <_ZN16CProcess_Manager8ScheduleEv>:
_ZN16CProcess_Manager8ScheduleEv():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:85

void CProcess_Manager::Schedule()
{
    a2ec:	e92d4800 	push	{fp, lr}
    a2f0:	e28db004 	add	fp, sp, #4
    a2f4:	e24dd010 	sub	sp, sp, #16
    a2f8:	e50b0010 	str	r0, [fp, #-16]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:86
    CProcess_List_Node* next = mCurrent_Task_Node != nullptr ? mCurrent_Task_Node->next : mProcess_List_Head;
    a2fc:	e51b3010 	ldr	r3, [fp, #-16]
    a300:	e5933008 	ldr	r3, [r3, #8]
    a304:	e3530000 	cmp	r3, #0
    a308:	0a000003 	beq	a31c <_ZN16CProcess_Manager8ScheduleEv+0x30>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:86 (discriminator 1)
    a30c:	e51b3010 	ldr	r3, [fp, #-16]
    a310:	e5933008 	ldr	r3, [r3, #8]
    a314:	e5933004 	ldr	r3, [r3, #4]
    a318:	ea000001 	b	a324 <_ZN16CProcess_Manager8ScheduleEv+0x38>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:86 (discriminator 2)
    a31c:	e51b3010 	ldr	r3, [fp, #-16]
    a320:	e5933004 	ldr	r3, [r3, #4]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:86 (discriminator 4)
    a324:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:87 (discriminator 4)
    if (next == nullptr)
    a328:	e51b3008 	ldr	r3, [fp, #-8]
    a32c:	e3530000 	cmp	r3, #0
    a330:	1a000002 	bne	a340 <_ZN16CProcess_Manager8ScheduleEv+0x54>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:89
    {
        next = mProcess_List_Head;
    a334:	e51b3010 	ldr	r3, [fp, #-16]
    a338:	e5933004 	ldr	r3, [r3, #4]
    a33c:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:92
    }

    if (next == mCurrent_Task_Node)
    a340:	e51b3010 	ldr	r3, [fp, #-16]
    a344:	e5933008 	ldr	r3, [r3, #8]
    a348:	e51b2008 	ldr	r2, [fp, #-8]
    a34c:	e1520003 	cmp	r2, r3
    a350:	1a000008 	bne	a378 <_ZN16CProcess_Manager8ScheduleEv+0x8c>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:94
    {
        mCurrent_Task_Node->task->sched_counter = mCurrent_Task_Node->task->sched_static_priority;
    a354:	e51b3010 	ldr	r3, [fp, #-16]
    a358:	e5933008 	ldr	r3, [r3, #8]
    a35c:	e5932008 	ldr	r2, [r3, #8]
    a360:	e51b3010 	ldr	r3, [fp, #-16]
    a364:	e5933008 	ldr	r3, [r3, #8]
    a368:	e5933008 	ldr	r3, [r3, #8]
    a36c:	e5922018 	ldr	r2, [r2, #24]
    a370:	e5832014 	str	r2, [r3, #20]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:95
        return;
    a374:	ea000002 	b	a384 <_ZN16CProcess_Manager8ScheduleEv+0x98>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:99
    }

    // sMonitor << "Next PID = " << next->task->pid << '\n';
    Switch_To(next);
    a378:	e51b1008 	ldr	r1, [fp, #-8]
    a37c:	e51b0010 	ldr	r0, [fp, #-16]
    a380:	eb000001 	bl	a38c <_ZN16CProcess_Manager9Switch_ToEP18CProcess_List_Node>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:100
}
    a384:	e24bd004 	sub	sp, fp, #4
    a388:	e8bd8800 	pop	{fp, pc}

0000a38c <_ZN16CProcess_Manager9Switch_ToEP18CProcess_List_Node>:
_ZN16CProcess_Manager9Switch_ToEP18CProcess_List_Node():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:103

void CProcess_Manager::Switch_To(CProcess_List_Node* node)
{
    a38c:	e92d4800 	push	{fp, lr}
    a390:	e28db004 	add	fp, sp, #4
    a394:	e24dd010 	sub	sp, sp, #16
    a398:	e50b0010 	str	r0, [fp, #-16]
    a39c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:107
    // pokud je stavajici proces ve stavu Running (muze teoreticky byt jeste Blocked), vratime ho do stavu Runnable
    // Blocked prehazovat nebudeme ze zjevnych duvodu
    
    if (mCurrent_Task_Node->task->state == NTask_State::Running)
    a3a0:	e51b3010 	ldr	r3, [fp, #-16]
    a3a4:	e5933008 	ldr	r3, [r3, #8]
    a3a8:	e5933008 	ldr	r3, [r3, #8]
    a3ac:	e5933010 	ldr	r3, [r3, #16]
    a3b0:	e3530002 	cmp	r3, #2
    a3b4:	1a000004 	bne	a3cc <_ZN16CProcess_Manager9Switch_ToEP18CProcess_List_Node+0x40>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:108
        mCurrent_Task_Node->task->state = NTask_State::Runnable;
    a3b8:	e51b3010 	ldr	r3, [fp, #-16]
    a3bc:	e5933008 	ldr	r3, [r3, #8]
    a3c0:	e5933008 	ldr	r3, [r3, #8]
    a3c4:	e3a02001 	mov	r2, #1
    a3c8:	e5832010 	str	r2, [r3, #16]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:111

    // projistotu vynulujeme prideleny pocet casovych kvant
    mCurrent_Task_Node->task->sched_counter = 0;
    a3cc:	e51b3010 	ldr	r3, [fp, #-16]
    a3d0:	e5933008 	ldr	r3, [r3, #8]
    a3d4:	e5933008 	ldr	r3, [r3, #8]
    a3d8:	e3a02000 	mov	r2, #0
    a3dc:	e5832014 	str	r2, [r3, #20]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:113

    TCPU_Context* old = &mCurrent_Task_Node->task->cpu_context;
    a3e0:	e51b3010 	ldr	r3, [fp, #-16]
    a3e4:	e5933008 	ldr	r3, [r3, #8]
    a3e8:	e5933008 	ldr	r3, [r3, #8]
    a3ec:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:114
    bool is_first_time = (node->task->state == NTask_State::New);
    a3f0:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    a3f4:	e5933008 	ldr	r3, [r3, #8]
    a3f8:	e5933010 	ldr	r3, [r3, #16]
    a3fc:	e3530000 	cmp	r3, #0
    a400:	03a03001 	moveq	r3, #1
    a404:	13a03000 	movne	r3, #0
    a408:	e54b3009 	strb	r3, [fp, #-9]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:117

    // prehodime na novy proces, pridelime casova kvanta a nastavime proces do stavu Running
    mCurrent_Task_Node = node;
    a40c:	e51b3010 	ldr	r3, [fp, #-16]
    a410:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    a414:	e5832008 	str	r2, [r3, #8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:118
    mCurrent_Task_Node->task->sched_counter = mCurrent_Task_Node->task->sched_static_priority;
    a418:	e51b3010 	ldr	r3, [fp, #-16]
    a41c:	e5933008 	ldr	r3, [r3, #8]
    a420:	e5932008 	ldr	r2, [r3, #8]
    a424:	e51b3010 	ldr	r3, [fp, #-16]
    a428:	e5933008 	ldr	r3, [r3, #8]
    a42c:	e5933008 	ldr	r3, [r3, #8]
    a430:	e5922018 	ldr	r2, [r2, #24]
    a434:	e5832014 	str	r2, [r3, #20]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:119
    mCurrent_Task_Node->task->state = NTask_State::Running;
    a438:	e51b3010 	ldr	r3, [fp, #-16]
    a43c:	e5933008 	ldr	r3, [r3, #8]
    a440:	e5933008 	ldr	r3, [r3, #8]
    a444:	e3a02002 	mov	r2, #2
    a448:	e5832010 	str	r2, [r3, #16]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:122

    // pokud je to poprve, co je proces planovany, musime to vzit jeste pres malou odbocku ("bootstrap")
    if (is_first_time)
    a44c:	e55b3009 	ldrb	r3, [fp, #-9]
    a450:	e3530000 	cmp	r3, #0
    a454:	0a000005 	beq	a470 <_ZN16CProcess_Manager9Switch_ToEP18CProcess_List_Node+0xe4>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:125
    {
        // sMonitor << "First context switch; pid = " << mCurrent_Task_Node->task->pid << "\n";
        context_switch_first(&node->task->cpu_context, old);
    a458:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    a45c:	e5933008 	ldr	r3, [r3, #8]
    a460:	e51b1008 	ldr	r1, [fp, #-8]
    a464:	e1a00003 	mov	r0, r3
    a468:	eb000043 	bl	a57c <context_switch_first>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:132
    else
    {
        // sMonitor << "Normal context switch; pid = " << mCurrent_Task_Node->task->pid << "\n";
        context_switch(&node->task->cpu_context, old);
    }
}
    a46c:	ea000004 	b	a484 <_ZN16CProcess_Manager9Switch_ToEP18CProcess_List_Node+0xf8>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:130
        context_switch(&node->task->cpu_context, old);
    a470:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    a474:	e5933008 	ldr	r3, [r3, #8]
    a478:	e51b1008 	ldr	r1, [fp, #-8]
    a47c:	e1a00003 	mov	r0, r3
    a480:	eb000034 	bl	a558 <context_switch>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:132
}
    a484:	e320f000 	nop	{0}
    a488:	e24bd004 	sub	sp, fp, #4
    a48c:	e8bd8800 	pop	{fp, pc}

0000a490 <_Z41__static_initialization_and_destruction_0ii>:
_Z41__static_initialization_and_destruction_0ii():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:132
    a490:	e92d4800 	push	{fp, lr}
    a494:	e28db004 	add	fp, sp, #4
    a498:	e24dd008 	sub	sp, sp, #8
    a49c:	e50b0008 	str	r0, [fp, #-8]
    a4a0:	e50b100c 	str	r1, [fp, #-12]
    a4a4:	e51b3008 	ldr	r3, [fp, #-8]
    a4a8:	e3530001 	cmp	r3, #1
    a4ac:	1a000005 	bne	a4c8 <_Z41__static_initialization_and_destruction_0ii+0x38>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:132 (discriminator 1)
    a4b0:	e51b300c 	ldr	r3, [fp, #-12]
    a4b4:	e59f2018 	ldr	r2, [pc, #24]	; a4d4 <_Z41__static_initialization_and_destruction_0ii+0x44>
    a4b8:	e1530002 	cmp	r3, r2
    a4bc:	1a000001 	bne	a4c8 <_Z41__static_initialization_and_destruction_0ii+0x38>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:16
CProcess_Manager sProcessMgr;
    a4c0:	e59f0010 	ldr	r0, [pc, #16]	; a4d8 <_Z41__static_initialization_and_destruction_0ii+0x48>
    a4c4:	ebfffec7 	bl	9fe8 <_ZN16CProcess_ManagerC1Ev>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:132
}
    a4c8:	e320f000 	nop	{0}
    a4cc:	e24bd004 	sub	sp, fp, #4
    a4d0:	e8bd8800 	pop	{fp, pc}
    a4d4:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>
    a4d8:	0000be48 	andeq	fp, r0, r8, asr #28

0000a4dc <_GLOBAL__sub_I_sProcessMgr>:
_GLOBAL__sub_I_sProcessMgr():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:132
    a4dc:	e92d4800 	push	{fp, lr}
    a4e0:	e28db004 	add	fp, sp, #4
    a4e4:	e59f1008 	ldr	r1, [pc, #8]	; a4f4 <_GLOBAL__sub_I_sProcessMgr+0x18>
    a4e8:	e3a00001 	mov	r0, #1
    a4ec:	ebffffe7 	bl	a490 <_Z41__static_initialization_and_destruction_0ii>
    a4f0:	e8bd8800 	pop	{fp, pc}
    a4f4:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>

0000a4f8 <_ZN20CKernel_Heap_Manager5AllocI18CProcess_List_NodeEEPT_v>:
_ZN20CKernel_Heap_Manager5AllocI18CProcess_List_NodeEEPT_v():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/include/memory/kernel_heap.h:30

        void* Alloc(uint32_t size);
        void Free(void* mem);

        template<class T>
        T* Alloc()
    a4f8:	e92d4800 	push	{fp, lr}
    a4fc:	e28db004 	add	fp, sp, #4
    a500:	e24dd008 	sub	sp, sp, #8
    a504:	e50b0008 	str	r0, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/include/memory/kernel_heap.h:32
        {
            return reinterpret_cast<T*>(Alloc(sizeof(T)));
    a508:	e3a0100c 	mov	r1, #12
    a50c:	e51b0008 	ldr	r0, [fp, #-8]
    a510:	ebfffcbb 	bl	9804 <_ZN20CKernel_Heap_Manager5AllocEj>
    a514:	e1a03000 	mov	r3, r0
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/include/memory/kernel_heap.h:33
        }
    a518:	e1a00003 	mov	r0, r3
    a51c:	e24bd004 	sub	sp, fp, #4
    a520:	e8bd8800 	pop	{fp, pc}

0000a524 <_ZN20CKernel_Heap_Manager5AllocI12TTask_StructEEPT_v>:
_ZN20CKernel_Heap_Manager5AllocI12TTask_StructEEPT_v():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/include/memory/kernel_heap.h:30
        T* Alloc()
    a524:	e92d4800 	push	{fp, lr}
    a528:	e28db004 	add	fp, sp, #4
    a52c:	e24dd008 	sub	sp, sp, #8
    a530:	e50b0008 	str	r0, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/include/memory/kernel_heap.h:32
            return reinterpret_cast<T*>(Alloc(sizeof(T)));
    a534:	e3a0101c 	mov	r1, #28
    a538:	e51b0008 	ldr	r0, [fp, #-8]
    a53c:	ebfffcb0 	bl	9804 <_ZN20CKernel_Heap_Manager5AllocEj>
    a540:	e1a03000 	mov	r3, r0
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/include/memory/kernel_heap.h:33
        }
    a544:	e1a00003 	mov	r0, r3
    a548:	e24bd004 	sub	sp, fp, #4
    a54c:	e8bd8800 	pop	{fp, pc}

0000a550 <process_bootstrap>:
process_bootstrap():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/switch.s:5
.global process_bootstrap
;@ Process bootstrapping - kernelovy "obal" procesu
;@ Vyzaduje na zasobniku pushnutou hodnotu vstupniho bodu procesu
process_bootstrap:
    add lr, pc, #8      ;@ ulozime do lr hodnotu PC+8, abychom se korektne vratili na instrukci po nasledujici
    a550:	e28fe008 	add	lr, pc, #8
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/switch.s:6
    pop {pc}            ;@ vyzvedneme si ulozenou hodnotu cile
    a554:	e49df004 	pop	{pc}		; (ldr pc, [sp], #4)

0000a558 <context_switch>:
context_switch():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/switch.s:14
.global context_switch
;@ Prepnuti procesu ze soucasneho na jiny, ktery jiz byl planovany
;@ r0 - novy proces
;@ r1 - stary proces
context_switch:
	mrs r12, cpsr           ;@ ulozit CPU state do r12
    a558:	e10fc000 	mrs	ip, CPSR
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/switch.s:15
	push {r14}              ;@ push LR
    a55c:	e52de004 	push	{lr}		; (str lr, [sp, #-4]!)
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/switch.s:16
	push {r0}              ;@ push SP
    a560:	e52d0004 	push	{r0}		; (str r0, [sp, #-4]!)
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/switch.s:17
	push {r0-r12}           ;@ push registru
    a564:	e92d1fff 	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, fp, ip}
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/switch.s:18
	str sp, [r1, #4]        ;@ ulozit SP stareho procesu
    a568:	e581d004 	str	sp, [r1, #4]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/switch.s:20

	ldr sp, [r0, #4]        ;@ nacist SP noveho procesu
    a56c:	e590d004 	ldr	sp, [r0, #4]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/switch.s:21
	pop {r0-r12}            ;@ obnovit registry noveho procesu
    a570:	e8bd1fff 	pop	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, fp, ip}
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/switch.s:22
	msr cpsr_c, r12         ;@ obnovit CPU state
    a574:	e121f00c 	msr	CPSR_c, ip
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/switch.s:23
	pop {lr, pc}            ;@ navrat do kontextu provadeni noveho procesu
    a578:	e8bdc000 	pop	{lr, pc}

0000a57c <context_switch_first>:
context_switch_first():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/switch.s:30
.global context_switch_first
;@ Prepnuti procesu ze soucasneho na jiny, ktery jeste nebyl planovany
;@ r0 - novy proces
;@ r1 - stary proces
context_switch_first:
	mrs r12, cpsr           ;@ ulozit CPU state do r12
    a57c:	e10fc000 	mrs	ip, CPSR
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/switch.s:31
	push {r14}              ;@ push LR
    a580:	e52de004 	push	{lr}		; (str lr, [sp, #-4]!)
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/switch.s:32
	push {r13}              ;@ push SP
    a584:	e92d2000 	stmfd	sp!, {sp}
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/switch.s:33
	push {r0-r12}           ;@ push registru
    a588:	e92d1fff 	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, fp, ip}
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/switch.s:34
	str sp, [r1, #4]        ;@ ulozit SP stareho procesu
    a58c:	e581d004 	str	sp, [r1, #4]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/switch.s:36

    ldr r3, [r0, #0]        ;@ "budouci" PC do r3 (entry point procesu)
    a590:	e5903000 	ldr	r3, [r0]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/switch.s:37
    ldr r2, [r0, #8]        ;@ "vstupni" PC do r2 (bootstrap procesu v kernelu)
    a594:	e5902008 	ldr	r2, [r0, #8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/switch.s:38
    ldr sp, [r0, #4]        ;@ nacteme stack pointer procesu
    a598:	e590d004 	ldr	sp, [r0, #4]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/switch.s:39
    push {r3}               ;@ budouci navratova adresa -> do zasobniku, bootstrap si ji tamodsud vyzvedne
    a59c:	e52d3004 	push	{r3}		; (str r3, [sp, #-4]!)
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/switch.s:40
    push {r2}               ;@ pushneme si i bootstrap adresu, abychom ji mohli obnovit do PC
    a5a0:	e52d2004 	push	{r2}		; (str r2, [sp, #-4]!)
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/switch.s:41
    cpsie i                 ;@ povolime preruseni (v budoucich switchich uz bude flaga ulozena v cpsr/spsr)
    a5a4:	f1080080 	cpsie	i
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/switch.s:42
    pop {pc}                ;@ vybereme ze zasobniku novou hodnotu PC (PC procesu)
    a5a8:	e49df004 	pop	{pc}		; (ldr pc, [sp], #4)

0000a5ac <enable_irq>:
enable_irq():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:103
;@ tady budou ostatni symboly, ktere nevyzaduji zadne specialni misto
.section .text

.global enable_irq
enable_irq:
    mrs r0, cpsr		;@ presun ridiciho registru (CPSR) do general purpose registru (R0)
    a5ac:	e10f0000 	mrs	r0, CPSR
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:104
    bic r0, r0, #0x80	;@ vypne bit 7 v registru r0 ("IRQ mask bit")
    a5b0:	e3c00080 	bic	r0, r0, #128	; 0x80
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:105
    msr cpsr_c, r0		;@ nacteme upraveny general purpose (R0) registr do ridiciho (CPSR)
    a5b4:	e121f000 	msr	CPSR_c, r0
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:106
    cpsie i				;@ povoli preruseni
    a5b8:	f1080080 	cpsie	i
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:107
    bx lr
    a5bc:	e12fff1e 	bx	lr

0000a5c0 <disable_irq>:
disable_irq():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:111
    
.global disable_irq
disable_irq:
    cpsid i
    a5c0:	f10c0080 	cpsid	i
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:112
    bx lr
    a5c4:	e12fff1e 	bx	lr

0000a5c8 <undefined_instruction_handler>:
undefined_instruction_handler():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:115

undefined_instruction_handler:
	b hang
    a5c8:	eafff6b6 	b	80a8 <hang>

0000a5cc <irq_handler>:
irq_handler():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:119

.global _internal_irq_handler
irq_handler:
	sub lr, lr, #4
    a5cc:	e24ee004 	sub	lr, lr, #4
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:120
	srsdb #CPSR_MODE_SYS!		;@ ekvivalent k push lr a msr+push spsr
    a5d0:	f96d051f 	srsdb	sp!, #31
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:121
	cpsid if, #CPSR_MODE_SYS	;@ prechod do SYS modu + zakazeme preruseni
    a5d4:	f10e00df 	cpsid	if,#31
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:122
	push {r0-r4, r12, lr}		;@ ulozime callee-saved registry
    a5d8:	e92d501f 	push	{r0, r1, r2, r3, r4, ip, lr}
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:124

	and r4, sp, #7
    a5dc:	e20d4007 	and	r4, sp, #7
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:125
	sub sp, sp, r4
    a5e0:	e04dd004 	sub	sp, sp, r4
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:127

	bl _internal_irq_handler	;@ zavolame handler IRQ
    a5e4:	ebfffae8 	bl	918c <_internal_irq_handler>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:129

	add sp, sp, r4
    a5e8:	e08dd004 	add	sp, sp, r4
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:131

	pop {r0-r4, r12, lr}		;@ obnovime callee-saved registry
    a5ec:	e8bd501f 	pop	{r0, r1, r2, r3, r4, ip, lr}
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:132
	rfeia sp!					;@ vracime se do puvodniho stavu (ktery ulozila instrukce srsdb)
    a5f0:	f8bd0a00 	rfeia	sp!

0000a5f4 <prefetch_abort_handler>:
prefetch_abort_handler():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:137

prefetch_abort_handler:
	;@ tady pak muzeme osetrit, kdyz program zasahne do mista, ktere nema mapovane ve svem virtualnim adr. prostoru
	;@ a treba vyvolat nasi obdobu segfaultu
	b hang
    a5f4:	eafff6ab 	b	80a8 <hang>

0000a5f8 <data_abort_handler>:
data_abort_handler():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:142

data_abort_handler:
	;@ tady pak muzeme osetrit, kdyz program zasahne do mista, ktere nema mapovane ve svem virtualnim adr. prostoru
	;@ a treba vyvolat nasi obdobu segfaultu
	b hang
    a5f8:	eafff6aa 	b	80a8 <hang>

0000a5fc <_c_startup>:
_c_startup():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/startup.cpp:21
extern "C" dtor_ptr __DTOR_LIST__[0];
// konec pole destruktoru
extern "C" dtor_ptr __DTOR_END__[0];

extern "C" int _c_startup(void)
{
    a5fc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    a600:	e28db000 	add	fp, sp, #0
    a604:	e24dd00c 	sub	sp, sp, #12
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/startup.cpp:25
	int* i;
	
	// vynulujeme .bss sekci
	for (i = (int*)_bss_start; i < (int*)_bss_end; i++)
    a608:	e59f304c 	ldr	r3, [pc, #76]	; a65c <_c_startup+0x60>
    a60c:	e5933000 	ldr	r3, [r3]
    a610:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/startup.cpp:25 (discriminator 3)
    a614:	e59f3044 	ldr	r3, [pc, #68]	; a660 <_c_startup+0x64>
    a618:	e5933000 	ldr	r3, [r3]
    a61c:	e1a02003 	mov	r2, r3
    a620:	e51b3008 	ldr	r3, [fp, #-8]
    a624:	e1530002 	cmp	r3, r2
    a628:	2a000006 	bcs	a648 <_c_startup+0x4c>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/startup.cpp:26 (discriminator 2)
		*i = 0;
    a62c:	e51b3008 	ldr	r3, [fp, #-8]
    a630:	e3a02000 	mov	r2, #0
    a634:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/startup.cpp:25 (discriminator 2)
	for (i = (int*)_bss_start; i < (int*)_bss_end; i++)
    a638:	e51b3008 	ldr	r3, [fp, #-8]
    a63c:	e2833004 	add	r3, r3, #4
    a640:	e50b3008 	str	r3, [fp, #-8]
    a644:	eafffff2 	b	a614 <_c_startup+0x18>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/startup.cpp:28
	
	return 0;
    a648:	e3a03000 	mov	r3, #0
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/startup.cpp:29
}
    a64c:	e1a00003 	mov	r0, r3
    a650:	e28bd000 	add	sp, fp, #0
    a654:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    a658:	e12fff1e 	bx	lr
    a65c:	0000ae08 	andeq	sl, r0, r8, lsl #28
    a660:	0000be64 	andeq	fp, r0, r4, ror #28

0000a664 <_cpp_startup>:
_cpp_startup():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/startup.cpp:32

extern "C" int _cpp_startup(void)
{
    a664:	e92d4800 	push	{fp, lr}
    a668:	e28db004 	add	fp, sp, #4
    a66c:	e24dd008 	sub	sp, sp, #8
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/startup.cpp:37
	ctor_ptr* fnptr;
	
	// zavolame konstruktory globalnich C++ trid
	// v poli __CTOR_LIST__ jsou ukazatele na vygenerovane stuby volani konstruktoru
	for (fnptr = __CTOR_LIST__; fnptr < __CTOR_END__; fnptr++)
    a670:	e59f303c 	ldr	r3, [pc, #60]	; a6b4 <_cpp_startup+0x50>
    a674:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/startup.cpp:37 (discriminator 3)
    a678:	e51b3008 	ldr	r3, [fp, #-8]
    a67c:	e59f2034 	ldr	r2, [pc, #52]	; a6b8 <_cpp_startup+0x54>
    a680:	e1530002 	cmp	r3, r2
    a684:	2a000006 	bcs	a6a4 <_cpp_startup+0x40>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/startup.cpp:38 (discriminator 2)
		(*fnptr)();
    a688:	e51b3008 	ldr	r3, [fp, #-8]
    a68c:	e5933000 	ldr	r3, [r3]
    a690:	e12fff33 	blx	r3
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/startup.cpp:37 (discriminator 2)
	for (fnptr = __CTOR_LIST__; fnptr < __CTOR_END__; fnptr++)
    a694:	e51b3008 	ldr	r3, [fp, #-8]
    a698:	e2833004 	add	r3, r3, #4
    a69c:	e50b3008 	str	r3, [fp, #-8]
    a6a0:	eafffff4 	b	a678 <_cpp_startup+0x14>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/startup.cpp:40
	
	return 0;
    a6a4:	e3a03000 	mov	r3, #0
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/startup.cpp:41
}
    a6a8:	e1a00003 	mov	r0, r3
    a6ac:	e24bd004 	sub	sp, fp, #4
    a6b0:	e8bd8800 	pop	{fp, pc}
    a6b4:	0000adec 	andeq	sl, r0, ip, ror #27
    a6b8:	0000ae08 	andeq	sl, r0, r8, lsl #28

0000a6bc <_cpp_shutdown>:
_cpp_shutdown():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/startup.cpp:44

extern "C" int _cpp_shutdown(void)
{
    a6bc:	e92d4800 	push	{fp, lr}
    a6c0:	e28db004 	add	fp, sp, #4
    a6c4:	e24dd008 	sub	sp, sp, #8
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/startup.cpp:48
	dtor_ptr* fnptr;
	
	// zavolame destruktory globalnich C++ trid
	for (fnptr = __DTOR_LIST__; fnptr < __DTOR_END__; fnptr++)
    a6c8:	e59f303c 	ldr	r3, [pc, #60]	; a70c <_cpp_shutdown+0x50>
    a6cc:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/startup.cpp:48 (discriminator 3)
    a6d0:	e51b3008 	ldr	r3, [fp, #-8]
    a6d4:	e59f2034 	ldr	r2, [pc, #52]	; a710 <_cpp_shutdown+0x54>
    a6d8:	e1530002 	cmp	r3, r2
    a6dc:	2a000006 	bcs	a6fc <_cpp_shutdown+0x40>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/startup.cpp:49 (discriminator 2)
		(*fnptr)();
    a6e0:	e51b3008 	ldr	r3, [fp, #-8]
    a6e4:	e5933000 	ldr	r3, [r3]
    a6e8:	e12fff33 	blx	r3
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/startup.cpp:48 (discriminator 2)
	for (fnptr = __DTOR_LIST__; fnptr < __DTOR_END__; fnptr++)
    a6ec:	e51b3008 	ldr	r3, [fp, #-8]
    a6f0:	e2833004 	add	r3, r3, #4
    a6f4:	e50b3008 	str	r3, [fp, #-8]
    a6f8:	eafffff4 	b	a6d0 <_cpp_shutdown+0x14>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/startup.cpp:51
	
	return 0;
    a6fc:	e3a03000 	mov	r3, #0
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/startup.cpp:52
}
    a700:	e1a00003 	mov	r0, r3
    a704:	e24bd004 	sub	sp, fp, #4
    a708:	e8bd8800 	pop	{fp, pc}
    a70c:	0000ae08 	andeq	sl, r0, r8, lsl #28
    a710:	0000ae08 	andeq	sl, r0, r8, lsl #28

0000a714 <_Z4itoajPcj>:
_Z4itoajPcj():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/stdlib/src/stdstring.cpp:9
{
    const char CharConvArr[] = "0123456789ABCDEF";
}

void itoa(unsigned int input, char* output, unsigned int base)
{
    a714:	e92d4800 	push	{fp, lr}
    a718:	e28db004 	add	fp, sp, #4
    a71c:	e24dd020 	sub	sp, sp, #32
    a720:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    a724:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    a728:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/stdlib/src/stdstring.cpp:10
	int i = 0;
    a72c:	e3a03000 	mov	r3, #0
    a730:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/stdlib/src/stdstring.cpp:12

	while (input > 0)
    a734:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    a738:	e3530000 	cmp	r3, #0
    a73c:	0a000014 	beq	a794 <_Z4itoajPcj+0x80>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/stdlib/src/stdstring.cpp:14
	{
		output[i] = CharConvArr[input % base];
    a740:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    a744:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    a748:	e1a00003 	mov	r0, r3
    a74c:	eb0000c8 	bl	aa74 <__aeabi_uidivmod>
    a750:	e1a03001 	mov	r3, r1
    a754:	e1a01003 	mov	r1, r3
    a758:	e51b3008 	ldr	r3, [fp, #-8]
    a75c:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    a760:	e0823003 	add	r3, r2, r3
    a764:	e59f2118 	ldr	r2, [pc, #280]	; a884 <_Z4itoajPcj+0x170>
    a768:	e7d22001 	ldrb	r2, [r2, r1]
    a76c:	e5c32000 	strb	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/stdlib/src/stdstring.cpp:15
		input /= base;
    a770:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    a774:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    a778:	eb000042 	bl	a888 <__udivsi3>
    a77c:	e1a03000 	mov	r3, r0
    a780:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/stdlib/src/stdstring.cpp:16
		i++;
    a784:	e51b3008 	ldr	r3, [fp, #-8]
    a788:	e2833001 	add	r3, r3, #1
    a78c:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/stdlib/src/stdstring.cpp:12
	while (input > 0)
    a790:	eaffffe7 	b	a734 <_Z4itoajPcj+0x20>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/stdlib/src/stdstring.cpp:19
	}

    if (i == 0)
    a794:	e51b3008 	ldr	r3, [fp, #-8]
    a798:	e3530000 	cmp	r3, #0
    a79c:	1a000007 	bne	a7c0 <_Z4itoajPcj+0xac>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/stdlib/src/stdstring.cpp:21
    {
        output[i] = CharConvArr[0];
    a7a0:	e51b3008 	ldr	r3, [fp, #-8]
    a7a4:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    a7a8:	e0823003 	add	r3, r2, r3
    a7ac:	e3a02030 	mov	r2, #48	; 0x30
    a7b0:	e5c32000 	strb	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/stdlib/src/stdstring.cpp:22
        i++;
    a7b4:	e51b3008 	ldr	r3, [fp, #-8]
    a7b8:	e2833001 	add	r3, r3, #1
    a7bc:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/stdlib/src/stdstring.cpp:25
    }

	output[i] = '\0';
    a7c0:	e51b3008 	ldr	r3, [fp, #-8]
    a7c4:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    a7c8:	e0823003 	add	r3, r2, r3
    a7cc:	e3a02000 	mov	r2, #0
    a7d0:	e5c32000 	strb	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/stdlib/src/stdstring.cpp:26
	i--;
    a7d4:	e51b3008 	ldr	r3, [fp, #-8]
    a7d8:	e2433001 	sub	r3, r3, #1
    a7dc:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/stdlib/src/stdstring.cpp:28

	for (int j = 0; j <= i/2; j++)
    a7e0:	e3a03000 	mov	r3, #0
    a7e4:	e50b300c 	str	r3, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/stdlib/src/stdstring.cpp:28 (discriminator 3)
    a7e8:	e51b3008 	ldr	r3, [fp, #-8]
    a7ec:	e1a02fa3 	lsr	r2, r3, #31
    a7f0:	e0823003 	add	r3, r2, r3
    a7f4:	e1a030c3 	asr	r3, r3, #1
    a7f8:	e1a02003 	mov	r2, r3
    a7fc:	e51b300c 	ldr	r3, [fp, #-12]
    a800:	e1530002 	cmp	r3, r2
    a804:	ca00001b 	bgt	a878 <_Z4itoajPcj+0x164>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/stdlib/src/stdstring.cpp:30 (discriminator 2)
	{
		char c = output[i - j];
    a808:	e51b2008 	ldr	r2, [fp, #-8]
    a80c:	e51b300c 	ldr	r3, [fp, #-12]
    a810:	e0423003 	sub	r3, r2, r3
    a814:	e1a02003 	mov	r2, r3
    a818:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    a81c:	e0833002 	add	r3, r3, r2
    a820:	e5d33000 	ldrb	r3, [r3]
    a824:	e54b300d 	strb	r3, [fp, #-13]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/stdlib/src/stdstring.cpp:31 (discriminator 2)
		output[i - j] = output[j];
    a828:	e51b300c 	ldr	r3, [fp, #-12]
    a82c:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    a830:	e0822003 	add	r2, r2, r3
    a834:	e51b1008 	ldr	r1, [fp, #-8]
    a838:	e51b300c 	ldr	r3, [fp, #-12]
    a83c:	e0413003 	sub	r3, r1, r3
    a840:	e1a01003 	mov	r1, r3
    a844:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    a848:	e0833001 	add	r3, r3, r1
    a84c:	e5d22000 	ldrb	r2, [r2]
    a850:	e5c32000 	strb	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/stdlib/src/stdstring.cpp:32 (discriminator 2)
		output[j] = c;
    a854:	e51b300c 	ldr	r3, [fp, #-12]
    a858:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    a85c:	e0823003 	add	r3, r2, r3
    a860:	e55b200d 	ldrb	r2, [fp, #-13]
    a864:	e5c32000 	strb	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/stdlib/src/stdstring.cpp:28 (discriminator 2)
	for (int j = 0; j <= i/2; j++)
    a868:	e51b300c 	ldr	r3, [fp, #-12]
    a86c:	e2833001 	add	r3, r3, #1
    a870:	e50b300c 	str	r3, [fp, #-12]
    a874:	eaffffdb 	b	a7e8 <_Z4itoajPcj+0xd4>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/stdlib/src/stdstring.cpp:34
	}
}
    a878:	e320f000 	nop	{0}
    a87c:	e24bd004 	sub	sp, fp, #4
    a880:	e8bd8800 	pop	{fp, pc}
    a884:	0000ada8 	andeq	sl, r0, r8, lsr #27

0000a888 <__udivsi3>:
__udivsi3():
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1099
    a888:	e2512001 	subs	r2, r1, #1
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1101
    a88c:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1102
    a890:	3a000074 	bcc	aa68 <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1103
    a894:	e1500001 	cmp	r0, r1
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1104
    a898:	9a00006b 	bls	aa4c <__udivsi3+0x1c4>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1105
    a89c:	e1110002 	tst	r1, r2
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1106
    a8a0:	0a00006c 	beq	aa58 <__udivsi3+0x1d0>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1108
    a8a4:	e16f3f10 	clz	r3, r0
    a8a8:	e16f2f11 	clz	r2, r1
    a8ac:	e0423003 	sub	r3, r2, r3
    a8b0:	e273301f 	rsbs	r3, r3, #31
    a8b4:	10833083 	addne	r3, r3, r3, lsl #1
    a8b8:	e3a02000 	mov	r2, #0
    a8bc:	108ff103 	addne	pc, pc, r3, lsl #2
    a8c0:	e1a00000 	nop			; (mov r0, r0)
    a8c4:	e1500f81 	cmp	r0, r1, lsl #31
    a8c8:	e0a22002 	adc	r2, r2, r2
    a8cc:	20400f81 	subcs	r0, r0, r1, lsl #31
    a8d0:	e1500f01 	cmp	r0, r1, lsl #30
    a8d4:	e0a22002 	adc	r2, r2, r2
    a8d8:	20400f01 	subcs	r0, r0, r1, lsl #30
    a8dc:	e1500e81 	cmp	r0, r1, lsl #29
    a8e0:	e0a22002 	adc	r2, r2, r2
    a8e4:	20400e81 	subcs	r0, r0, r1, lsl #29
    a8e8:	e1500e01 	cmp	r0, r1, lsl #28
    a8ec:	e0a22002 	adc	r2, r2, r2
    a8f0:	20400e01 	subcs	r0, r0, r1, lsl #28
    a8f4:	e1500d81 	cmp	r0, r1, lsl #27
    a8f8:	e0a22002 	adc	r2, r2, r2
    a8fc:	20400d81 	subcs	r0, r0, r1, lsl #27
    a900:	e1500d01 	cmp	r0, r1, lsl #26
    a904:	e0a22002 	adc	r2, r2, r2
    a908:	20400d01 	subcs	r0, r0, r1, lsl #26
    a90c:	e1500c81 	cmp	r0, r1, lsl #25
    a910:	e0a22002 	adc	r2, r2, r2
    a914:	20400c81 	subcs	r0, r0, r1, lsl #25
    a918:	e1500c01 	cmp	r0, r1, lsl #24
    a91c:	e0a22002 	adc	r2, r2, r2
    a920:	20400c01 	subcs	r0, r0, r1, lsl #24
    a924:	e1500b81 	cmp	r0, r1, lsl #23
    a928:	e0a22002 	adc	r2, r2, r2
    a92c:	20400b81 	subcs	r0, r0, r1, lsl #23
    a930:	e1500b01 	cmp	r0, r1, lsl #22
    a934:	e0a22002 	adc	r2, r2, r2
    a938:	20400b01 	subcs	r0, r0, r1, lsl #22
    a93c:	e1500a81 	cmp	r0, r1, lsl #21
    a940:	e0a22002 	adc	r2, r2, r2
    a944:	20400a81 	subcs	r0, r0, r1, lsl #21
    a948:	e1500a01 	cmp	r0, r1, lsl #20
    a94c:	e0a22002 	adc	r2, r2, r2
    a950:	20400a01 	subcs	r0, r0, r1, lsl #20
    a954:	e1500981 	cmp	r0, r1, lsl #19
    a958:	e0a22002 	adc	r2, r2, r2
    a95c:	20400981 	subcs	r0, r0, r1, lsl #19
    a960:	e1500901 	cmp	r0, r1, lsl #18
    a964:	e0a22002 	adc	r2, r2, r2
    a968:	20400901 	subcs	r0, r0, r1, lsl #18
    a96c:	e1500881 	cmp	r0, r1, lsl #17
    a970:	e0a22002 	adc	r2, r2, r2
    a974:	20400881 	subcs	r0, r0, r1, lsl #17
    a978:	e1500801 	cmp	r0, r1, lsl #16
    a97c:	e0a22002 	adc	r2, r2, r2
    a980:	20400801 	subcs	r0, r0, r1, lsl #16
    a984:	e1500781 	cmp	r0, r1, lsl #15
    a988:	e0a22002 	adc	r2, r2, r2
    a98c:	20400781 	subcs	r0, r0, r1, lsl #15
    a990:	e1500701 	cmp	r0, r1, lsl #14
    a994:	e0a22002 	adc	r2, r2, r2
    a998:	20400701 	subcs	r0, r0, r1, lsl #14
    a99c:	e1500681 	cmp	r0, r1, lsl #13
    a9a0:	e0a22002 	adc	r2, r2, r2
    a9a4:	20400681 	subcs	r0, r0, r1, lsl #13
    a9a8:	e1500601 	cmp	r0, r1, lsl #12
    a9ac:	e0a22002 	adc	r2, r2, r2
    a9b0:	20400601 	subcs	r0, r0, r1, lsl #12
    a9b4:	e1500581 	cmp	r0, r1, lsl #11
    a9b8:	e0a22002 	adc	r2, r2, r2
    a9bc:	20400581 	subcs	r0, r0, r1, lsl #11
    a9c0:	e1500501 	cmp	r0, r1, lsl #10
    a9c4:	e0a22002 	adc	r2, r2, r2
    a9c8:	20400501 	subcs	r0, r0, r1, lsl #10
    a9cc:	e1500481 	cmp	r0, r1, lsl #9
    a9d0:	e0a22002 	adc	r2, r2, r2
    a9d4:	20400481 	subcs	r0, r0, r1, lsl #9
    a9d8:	e1500401 	cmp	r0, r1, lsl #8
    a9dc:	e0a22002 	adc	r2, r2, r2
    a9e0:	20400401 	subcs	r0, r0, r1, lsl #8
    a9e4:	e1500381 	cmp	r0, r1, lsl #7
    a9e8:	e0a22002 	adc	r2, r2, r2
    a9ec:	20400381 	subcs	r0, r0, r1, lsl #7
    a9f0:	e1500301 	cmp	r0, r1, lsl #6
    a9f4:	e0a22002 	adc	r2, r2, r2
    a9f8:	20400301 	subcs	r0, r0, r1, lsl #6
    a9fc:	e1500281 	cmp	r0, r1, lsl #5
    aa00:	e0a22002 	adc	r2, r2, r2
    aa04:	20400281 	subcs	r0, r0, r1, lsl #5
    aa08:	e1500201 	cmp	r0, r1, lsl #4
    aa0c:	e0a22002 	adc	r2, r2, r2
    aa10:	20400201 	subcs	r0, r0, r1, lsl #4
    aa14:	e1500181 	cmp	r0, r1, lsl #3
    aa18:	e0a22002 	adc	r2, r2, r2
    aa1c:	20400181 	subcs	r0, r0, r1, lsl #3
    aa20:	e1500101 	cmp	r0, r1, lsl #2
    aa24:	e0a22002 	adc	r2, r2, r2
    aa28:	20400101 	subcs	r0, r0, r1, lsl #2
    aa2c:	e1500081 	cmp	r0, r1, lsl #1
    aa30:	e0a22002 	adc	r2, r2, r2
    aa34:	20400081 	subcs	r0, r0, r1, lsl #1
    aa38:	e1500001 	cmp	r0, r1
    aa3c:	e0a22002 	adc	r2, r2, r2
    aa40:	20400001 	subcs	r0, r0, r1
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1110
    aa44:	e1a00002 	mov	r0, r2
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1111
    aa48:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1114
    aa4c:	03a00001 	moveq	r0, #1
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1115
    aa50:	13a00000 	movne	r0, #0
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1116
    aa54:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1118
    aa58:	e16f2f11 	clz	r2, r1
    aa5c:	e262201f 	rsb	r2, r2, #31
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1120
    aa60:	e1a00230 	lsr	r0, r0, r2
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1121
    aa64:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1125
    aa68:	e3500000 	cmp	r0, #0
    aa6c:	13e00000 	mvnne	r0, #0
    aa70:	ea000007 	b	aa94 <__aeabi_idiv0>

0000aa74 <__aeabi_uidivmod>:
__aeabi_uidivmod():
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1156
    aa74:	e3510000 	cmp	r1, #0
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1157
    aa78:	0afffffa 	beq	aa68 <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1158
    aa7c:	e92d4003 	push	{r0, r1, lr}
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1159
    aa80:	ebffff80 	bl	a888 <__udivsi3>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1160
    aa84:	e8bd4006 	pop	{r1, r2, lr}
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1161
    aa88:	e0030092 	mul	r3, r2, r0
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1162
    aa8c:	e0411003 	sub	r1, r1, r3
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1163
    aa90:	e12fff1e 	bx	lr

0000aa94 <__aeabi_idiv0>:
__aeabi_ldiv0():
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1461
    aa94:	e12fff1e 	bx	lr

Disassembly of section .ARM.extab:

0000aa98 <.ARM.extab>:
    aa98:	81019b40 	tsthi	r1, r0, asr #22
    aa9c:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    aaa0:	00000000 	andeq	r0, r0, r0
    aaa4:	81019b40 	tsthi	r1, r0, asr #22
    aaa8:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    aaac:	00000000 	andeq	r0, r0, r0
    aab0:	81019b40 	tsthi	r1, r0, asr #22
    aab4:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    aab8:	00000000 	andeq	r0, r0, r0
    aabc:	81019b40 	tsthi	r1, r0, asr #22
    aac0:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    aac4:	00000000 	andeq	r0, r0, r0
    aac8:	81019b40 	tsthi	r1, r0, asr #22
    aacc:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    aad0:	00000000 	andeq	r0, r0, r0
    aad4:	81019b40 	tsthi	r1, r0, asr #22
    aad8:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    aadc:	00000000 	andeq	r0, r0, r0
    aae0:	81019b40 	tsthi	r1, r0, asr #22
    aae4:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    aae8:	00000000 	andeq	r0, r0, r0
    aaec:	81019b40 	tsthi	r1, r0, asr #22
    aaf0:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    aaf4:	00000000 	andeq	r0, r0, r0
    aaf8:	81019b40 	tsthi	r1, r0, asr #22
    aafc:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    ab00:	00000000 	andeq	r0, r0, r0
    ab04:	81019b40 	tsthi	r1, r0, asr #22
    ab08:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    ab0c:	00000000 	andeq	r0, r0, r0
    ab10:	81019b40 	tsthi	r1, r0, asr #22
    ab14:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    ab18:	00000000 	andeq	r0, r0, r0
    ab1c:	81019b40 	tsthi	r1, r0, asr #22
    ab20:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    ab24:	00000000 	andeq	r0, r0, r0
    ab28:	81019b40 	tsthi	r1, r0, asr #22
    ab2c:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    ab30:	00000000 	andeq	r0, r0, r0
    ab34:	81019b40 	tsthi	r1, r0, asr #22
    ab38:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    ab3c:	00000000 	andeq	r0, r0, r0
    ab40:	81019b40 	tsthi	r1, r0, asr #22
    ab44:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    ab48:	00000000 	andeq	r0, r0, r0
    ab4c:	81019b40 	tsthi	r1, r0, asr #22
    ab50:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    ab54:	00000000 	andeq	r0, r0, r0
    ab58:	81019b40 	tsthi	r1, r0, asr #22
    ab5c:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    ab60:	00000000 	andeq	r0, r0, r0

Disassembly of section .ARM.exidx:

0000ab64 <.ARM.exidx>:
    ab64:	7fffd548 	svcvc	0x00ffd548
    ab68:	00000001 	andeq	r0, r0, r1
    ab6c:	7fffe508 	svcvc	0x00ffe508
    ab70:	7fffff28 	svcvc	0x00ffff28
    ab74:	7fffe550 	svcvc	0x00ffe550
    ab78:	00000001 	andeq	r0, r0, r1
    ab7c:	7fffe610 	svcvc	0x00ffe610
    ab80:	7fffff24 	svcvc	0x00ffff24
    ab84:	7fffe638 	svcvc	0x00ffe638
    ab88:	00000001 	andeq	r0, r0, r1
    ab8c:	7fffe844 	svcvc	0x00ffe844
    ab90:	7fffff20 	svcvc	0x00ffff20
    ab94:	7fffe898 	svcvc	0x00ffe898
    ab98:	7fffff24 	svcvc	0x00ffff24
    ab9c:	7fffe92c 	svcvc	0x00ffe92c
    aba0:	7fffff28 	svcvc	0x00ffff28
    aba4:	7fffe9c0 	svcvc	0x00ffe9c0
    aba8:	7fffff2c 	svcvc	0x00ffff2c
    abac:	7fffea54 	svcvc	0x00ffea54
    abb0:	7fffff30 	svcvc	0x00ffff30
    abb4:	7fffeae8 	svcvc	0x00ffeae8
    abb8:	7fffff34 	svcvc	0x00ffff34
    abbc:	7fffebac 	svcvc	0x00ffebac
    abc0:	7fffff38 	svcvc	0x00ffff38
    abc4:	7fffebd8 	svcvc	0x00ffebd8
    abc8:	7fffff3c 	svcvc	0x00ffff3c
    abcc:	7fffec38 	svcvc	0x00ffec38
    abd0:	00000001 	andeq	r0, r0, r1
    abd4:	7ffff178 	svcvc	0x00fff178
    abd8:	7fffff38 	svcvc	0x00ffff38
    abdc:	7ffff36c 	svcvc	0x00fff36c
    abe0:	00000001 	andeq	r0, r0, r1
    abe4:	7ffff490 	svcvc	0x00fff490
    abe8:	7fffff34 	svcvc	0x00ffff34
    abec:	7ffff57c 	svcvc	0x00fff57c
    abf0:	7fffff38 	svcvc	0x00ffff38
    abf4:	7ffff6f8 	svcvc	0x00fff6f8
    abf8:	7fffff3c 	svcvc	0x00ffff3c
    abfc:	7ffff790 	svcvc	0x00fff790
    ac00:	7fffff40 	svcvc	0x00ffff40
    ac04:	7ffff88c 	svcvc	0x00fff88c
    ac08:	00000001 	andeq	r0, r0, r1
    ac0c:	7ffffa58 	svcvc	0x00fffa58
    ac10:	7fffff3c 	svcvc	0x00ffff3c
    ac14:	7ffffaa8 	svcvc	0x00fffaa8
    ac18:	7fffff40 	svcvc	0x00ffff40
    ac1c:	7ffffaf8 	svcvc	0x00fffaf8
    ac20:	00000001 	andeq	r0, r0, r1

Disassembly of section .rodata:

0000ac24 <_ZN3halL18Default_Clock_RateE>:
    ac24:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

0000ac28 <_ZN3halL15Peripheral_BaseE>:
    ac28:	20000000 	andcs	r0, r0, r0

0000ac2c <_ZN3halL9GPIO_BaseE>:
    ac2c:	20200000 	eorcs	r0, r0, r0

0000ac30 <_ZN3halL14GPIO_Pin_CountE>:
    ac30:	00000036 	andeq	r0, r0, r6, lsr r0

0000ac34 <_ZN3halL8AUX_BaseE>:
    ac34:	20215000 	eorcs	r5, r1, r0

0000ac38 <_ZN3halL25Interrupt_Controller_BaseE>:
    ac38:	2000b200 	andcs	fp, r0, r0, lsl #4

0000ac3c <_ZN3halL10Timer_BaseE>:
    ac3c:	2000b400 	andcs	fp, r0, r0, lsl #8

0000ac40 <_ZZN8CMonitorlsEjE11BUFFER_SIZE>:
    ac40:	00000010 	andeq	r0, r0, r0, lsl r0
    ac44:	65757274 	ldrbvs	r7, [r5, #-628]!	; 0xfffffd8c
    ac48:	00000000 	andeq	r0, r0, r0
    ac4c:	736c6166 	cmnvc	ip, #-2147483623	; 0x80000019
    ac50:	00000065 	andeq	r0, r0, r5, rrx
    ac54:	33323130 	teqcc	r2, #48, 2
    ac58:	37363534 			; <UNDEFINED> instruction: 0x37363534
    ac5c:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    ac60:	46454443 	strbmi	r4, [r5], -r3, asr #8
    ac64:	00000000 	andeq	r0, r0, r0

0000ac68 <_ZN3halL18Default_Clock_RateE>:
    ac68:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

0000ac6c <_ZN3halL15Peripheral_BaseE>:
    ac6c:	20000000 	andcs	r0, r0, r0

0000ac70 <_ZN3halL9GPIO_BaseE>:
    ac70:	20200000 	eorcs	r0, r0, r0

0000ac74 <_ZN3halL14GPIO_Pin_CountE>:
    ac74:	00000036 	andeq	r0, r0, r6, lsr r0

0000ac78 <_ZN3halL8AUX_BaseE>:
    ac78:	20215000 	eorcs	r5, r1, r0

0000ac7c <_ZN3halL25Interrupt_Controller_BaseE>:
    ac7c:	2000b200 	andcs	fp, r0, r0, lsl #4

0000ac80 <_ZN3halL10Timer_BaseE>:
    ac80:	2000b400 	andcs	fp, r0, r0, lsl #8

0000ac84 <_ZN3halL18Default_Clock_RateE>:
    ac84:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

0000ac88 <_ZN3halL15Peripheral_BaseE>:
    ac88:	20000000 	andcs	r0, r0, r0

0000ac8c <_ZN3halL9GPIO_BaseE>:
    ac8c:	20200000 	eorcs	r0, r0, r0

0000ac90 <_ZN3halL14GPIO_Pin_CountE>:
    ac90:	00000036 	andeq	r0, r0, r6, lsr r0

0000ac94 <_ZN3halL8AUX_BaseE>:
    ac94:	20215000 	eorcs	r5, r1, r0

0000ac98 <_ZN3halL25Interrupt_Controller_BaseE>:
    ac98:	2000b200 	andcs	fp, r0, r0, lsl #4

0000ac9c <_ZN3halL10Timer_BaseE>:
    ac9c:	2000b400 	andcs	fp, r0, r0, lsl #8

0000aca0 <_ZN3halL18Default_Clock_RateE>:
    aca0:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

0000aca4 <_ZN3halL15Peripheral_BaseE>:
    aca4:	20000000 	andcs	r0, r0, r0

0000aca8 <_ZN3halL9GPIO_BaseE>:
    aca8:	20200000 	eorcs	r0, r0, r0

0000acac <_ZN3halL14GPIO_Pin_CountE>:
    acac:	00000036 	andeq	r0, r0, r6, lsr r0

0000acb0 <_ZN3halL8AUX_BaseE>:
    acb0:	20215000 	eorcs	r5, r1, r0

0000acb4 <_ZN3halL25Interrupt_Controller_BaseE>:
    acb4:	2000b200 	andcs	fp, r0, r0, lsl #4

0000acb8 <_ZN3halL10Timer_BaseE>:
    acb8:	2000b400 	andcs	fp, r0, r0, lsl #8

0000acbc <_ZN3memL9LowMemoryE>:
    acbc:	00020000 	andeq	r0, r2, r0

0000acc0 <_ZN3memL10HighMemoryE>:
    acc0:	20000000 	andcs	r0, r0, r0

0000acc4 <_ZN3memL8PageSizeE>:
    acc4:	00004000 	andeq	r4, r0, r0

0000acc8 <_ZN3memL16PagingMemorySizeE>:
    acc8:	1ffe0000 	svcne	0x00fe0000

0000accc <_ZN3memL9PageCountE>:
    accc:	00007ff8 	strdeq	r7, [r0], -r8

0000acd0 <_ZL7ACT_Pin>:
    acd0:	0000002f 	andeq	r0, r0, pc, lsr #32
    acd4:	00000031 	andeq	r0, r0, r1, lsr r0
    acd8:	00000032 	andeq	r0, r0, r2, lsr r0
    acdc:	00000033 	andeq	r0, r0, r3, lsr r0
    ace0:	00000034 	andeq	r0, r0, r4, lsr r0

0000ace4 <_ZN3halL18Default_Clock_RateE>:
    ace4:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

0000ace8 <_ZN3halL15Peripheral_BaseE>:
    ace8:	20000000 	andcs	r0, r0, r0

0000acec <_ZN3halL9GPIO_BaseE>:
    acec:	20200000 	eorcs	r0, r0, r0

0000acf0 <_ZN3halL14GPIO_Pin_CountE>:
    acf0:	00000036 	andeq	r0, r0, r6, lsr r0

0000acf4 <_ZN3halL8AUX_BaseE>:
    acf4:	20215000 	eorcs	r5, r1, r0

0000acf8 <_ZN3halL25Interrupt_Controller_BaseE>:
    acf8:	2000b200 	andcs	fp, r0, r0, lsl #4

0000acfc <_ZN3halL10Timer_BaseE>:
    acfc:	2000b400 	andcs	fp, r0, r0, lsl #8

0000ad00 <_ZN3memL9LowMemoryE>:
    ad00:	00020000 	andeq	r0, r2, r0

0000ad04 <_ZN3memL10HighMemoryE>:
    ad04:	20000000 	andcs	r0, r0, r0

0000ad08 <_ZN3memL8PageSizeE>:
    ad08:	00004000 	andeq	r4, r0, r0

0000ad0c <_ZN3memL16PagingMemorySizeE>:
    ad0c:	1ffe0000 	svcne	0x00fe0000

0000ad10 <_ZN3memL9PageCountE>:
    ad10:	00007ff8 	strdeq	r7, [r0], -r8

0000ad14 <_ZN3halL18Default_Clock_RateE>:
    ad14:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

0000ad18 <_ZN3halL15Peripheral_BaseE>:
    ad18:	20000000 	andcs	r0, r0, r0

0000ad1c <_ZN3halL9GPIO_BaseE>:
    ad1c:	20200000 	eorcs	r0, r0, r0

0000ad20 <_ZN3halL14GPIO_Pin_CountE>:
    ad20:	00000036 	andeq	r0, r0, r6, lsr r0

0000ad24 <_ZN3halL8AUX_BaseE>:
    ad24:	20215000 	eorcs	r5, r1, r0

0000ad28 <_ZN3halL25Interrupt_Controller_BaseE>:
    ad28:	2000b200 	andcs	fp, r0, r0, lsl #4

0000ad2c <_ZN3halL10Timer_BaseE>:
    ad2c:	2000b400 	andcs	fp, r0, r0, lsl #8

0000ad30 <_ZN3memL9LowMemoryE>:
    ad30:	00020000 	andeq	r0, r2, r0

0000ad34 <_ZN3memL10HighMemoryE>:
    ad34:	20000000 	andcs	r0, r0, r0

0000ad38 <_ZN3memL8PageSizeE>:
    ad38:	00004000 	andeq	r4, r0, r0

0000ad3c <_ZN3memL16PagingMemorySizeE>:
    ad3c:	1ffe0000 	svcne	0x00fe0000

0000ad40 <_ZN3memL9PageCountE>:
    ad40:	00007ff8 	strdeq	r7, [r0], -r8
    ad44:	3a6d656d 	bcc	1b64300 <_bss_end+0x1b5849c>
    ad48:	6761503a 			; <UNDEFINED> instruction: 0x6761503a
    ad4c:	756f4365 	strbvc	r4, [pc, #-869]!	; a9ef <__udivsi3+0x167>
    ad50:	3d20746e 	cfstrscc	mvf7, [r0, #-440]!	; 0xfffffe48
    ad54:	00000020 	andeq	r0, r0, r0, lsr #32
    ad58:	203d206a 	eorscs	r2, sp, sl, rrx
    ad5c:	00000000 	andeq	r0, r0, r0
    ad60:	6761506d 	strbvs	r5, [r1, -sp, rrx]!
    ad64:	69425f65 	stmdbvs	r2, {r0, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
    ad68:	70616d74 	rsbvc	r6, r1, r4, ror sp
    ad6c:	205d695b 	subscs	r6, sp, fp, asr r9
    ad70:	0000203d 	andeq	r2, r0, sp, lsr r0

0000ad74 <_ZN3halL18Default_Clock_RateE>:
    ad74:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

0000ad78 <_ZN3halL15Peripheral_BaseE>:
    ad78:	20000000 	andcs	r0, r0, r0

0000ad7c <_ZN3halL9GPIO_BaseE>:
    ad7c:	20200000 	eorcs	r0, r0, r0

0000ad80 <_ZN3halL14GPIO_Pin_CountE>:
    ad80:	00000036 	andeq	r0, r0, r6, lsr r0

0000ad84 <_ZN3halL8AUX_BaseE>:
    ad84:	20215000 	eorcs	r5, r1, r0

0000ad88 <_ZN3halL25Interrupt_Controller_BaseE>:
    ad88:	2000b200 	andcs	fp, r0, r0, lsl #4

0000ad8c <_ZN3halL10Timer_BaseE>:
    ad8c:	2000b400 	andcs	fp, r0, r0, lsl #8

0000ad90 <_ZN3memL9LowMemoryE>:
    ad90:	00020000 	andeq	r0, r2, r0

0000ad94 <_ZN3memL10HighMemoryE>:
    ad94:	20000000 	andcs	r0, r0, r0

0000ad98 <_ZN3memL8PageSizeE>:
    ad98:	00004000 	andeq	r4, r0, r0

0000ad9c <_ZN3memL16PagingMemorySizeE>:
    ad9c:	1ffe0000 	svcne	0x00fe0000

0000ada0 <_ZN3memL9PageCountE>:
    ada0:	00007ff8 	strdeq	r7, [r0], -r8
    ada4:	00007830 	andeq	r7, r0, r0, lsr r8

0000ada8 <_ZN12_GLOBAL__N_1L11CharConvArrE>:
    ada8:	33323130 	teqcc	r2, #48, 2
    adac:	37363534 			; <UNDEFINED> instruction: 0x37363534
    adb0:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    adb4:	46454443 	strbmi	r4, [r5], -r3, asr #8
	...

Disassembly of section .ARM.extab.text._ZN20CKernel_Heap_Manager5AllocI18CProcess_List_NodeEEPT_v:

0000adbc <.ARM.extab.text._ZN20CKernel_Heap_Manager5AllocI18CProcess_List_NodeEEPT_v>:
    adbc:	81019b40 	tsthi	r1, r0, asr #22
    adc0:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    adc4:	00000000 	andeq	r0, r0, r0

Disassembly of section .ARM.exidx.text._ZN20CKernel_Heap_Manager5AllocI18CProcess_List_NodeEEPT_v:

0000adc8 <.ARM.exidx.text._ZN20CKernel_Heap_Manager5AllocI18CProcess_List_NodeEEPT_v>:
    adc8:	7ffff730 	svcvc	0x00fff730
    adcc:	7ffffff0 	svcvc	0x00fffff0

Disassembly of section .ARM.extab.text._ZN20CKernel_Heap_Manager5AllocI12TTask_StructEEPT_v:

0000add0 <.ARM.extab.text._ZN20CKernel_Heap_Manager5AllocI12TTask_StructEEPT_v>:
    add0:	81019b40 	tsthi	r1, r0, asr #22
    add4:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    add8:	00000000 	andeq	r0, r0, r0

Disassembly of section .ARM.exidx.text._ZN20CKernel_Heap_Manager5AllocI12TTask_StructEEPT_v:

0000addc <.ARM.exidx.text._ZN20CKernel_Heap_Manager5AllocI12TTask_StructEEPT_v>:
    addc:	7ffff748 	svcvc	0x00fff748
    ade0:	7ffffff0 	svcvc	0x00fffff0
    ade4:	7ffff76c 	svcvc	0x00fff76c
    ade8:	00000001 	andeq	r0, r0, r1

Disassembly of section .data:

0000adec <__CTOR_LIST__>:
    adec:	00008698 	muleq	r0, r8, r6
    adf0:	00008cd0 	ldrdeq	r8, [r0], -r0
    adf4:	00009158 	andeq	r9, r0, r8, asr r1
    adf8:	000093b4 			; <UNDEFINED> instruction: 0x000093b4
    adfc:	00009ab8 			; <UNDEFINED> instruction: 0x00009ab8
    ae00:	00009fcc 	andeq	r9, r0, ip, asr #31
    ae04:	0000a4dc 	ldrdeq	sl, [r0], -ip

Disassembly of section .bss:

0000ae08 <sGPIO>:
    ae08:	00000000 	andeq	r0, r0, r0

0000ae0c <sMonitor>:
	...

0000ae24 <_ZZN8CMonitorlsEjE8s_buffer>:
	...

0000ae34 <sTimer>:
	...

0000ae3c <sInterruptCtl>:
_ZZN8CMonitorlsEjE8s_buffer():
    ae3c:	00000000 	andeq	r0, r0, r0

0000ae40 <LED_State>:
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:14
volatile bool LED_State = false;
    ae40:	00000000 	andeq	r0, r0, r0

0000ae44 <sKernelMem>:
    ae44:	00000000 	andeq	r0, r0, r0

0000ae48 <sPage_Manager>:
	...

0000be48 <sProcessMgr>:
	...

Disassembly of section .debug_info:

00000000 <.debug_info>:
       0:	00000126 	andeq	r0, r0, r6, lsr #2
       4:	00000004 	andeq	r0, r0, r4
       8:	01040000 	mrseq	r0, (UNDEF: 4)
       c:	00000000 	andeq	r0, r0, r0
      10:	00018f04 	andeq	r8, r1, r4, lsl #30
      14:	0000b600 	andeq	fp, r0, r0, lsl #12
      18:	0080ac00 	addeq	sl, r0, r0, lsl #24
      1c:	0000d800 	andeq	sp, r0, r0, lsl #16
      20:	00000000 	andeq	r0, r0, r0
      24:	01780200 	cmneq	r8, r0, lsl #4
      28:	29010000 	stmdbcs	r1, {}	; <UNPREDICTABLE>
      2c:	00817811 	addeq	r7, r1, r1, lsl r8
      30:	00000c00 	andeq	r0, r0, r0, lsl #24
      34:	029c0100 	addseq	r0, ip, #0, 2
      38:	00000165 	andeq	r0, r0, r5, ror #2
      3c:	60112401 	andsvs	r2, r1, r1, lsl #8
      40:	18000081 	stmdane	r0, {r0, r7}
      44:	01000000 	mrseq	r0, (UNDEF: 0)
      48:	0131029c 	teqeq	r1, ip	; <illegal shifter operand>
      4c:	1f010000 	svcne	0x00010000
      50:	00814811 	addeq	r4, r1, r1, lsl r8
      54:	00001800 	andeq	r1, r0, r0, lsl #16
      58:	029c0100 	addseq	r0, ip, #0, 2
      5c:	00000124 	andeq	r0, r0, r4, lsr #2
      60:	30111a01 	andscc	r1, r1, r1, lsl #20
      64:	18000081 	stmdane	r0, {r0, r7}
      68:	01000000 	mrseq	r0, (UNDEF: 0)
      6c:	015a039c 			; <UNDEFINED> instruction: 0x015a039c
      70:	00020000 	andeq	r0, r2, r0
      74:	000000bb 	strheq	r0, [r0], -fp
      78:	00011204 	andeq	r1, r1, r4, lsl #4
      7c:	12140100 	andsne	r0, r4, #0, 2
      80:	0000008a 	andeq	r0, r0, sl, lsl #1
      84:	0000bb05 	andeq	fp, r0, r5, lsl #22
      88:	3e060000 	cdpcc	0, 0, cr0, cr6, cr0, {0}
      8c:	01000001 	tsteq	r0, r1
      90:	00c11c04 	sbceq	r1, r1, r4, lsl #24
      94:	fe040000 	cdp2	0, 0, cr0, cr4, cr0, {0}
      98:	01000000 	mrseq	r0, (UNDEF: 0)
      9c:	00a8120f 	adceq	r1, r8, pc, lsl #4
      a0:	bb050000 	bllt	1400a8 <_bss_end+0x134244>
      a4:	00000000 	andeq	r0, r0, r0
      a8:	00014607 	andeq	r4, r1, r7, lsl #12
      ac:	110a0100 	mrsne	r0, (UNDEF: 26)
      b0:	00000105 	andeq	r0, r0, r5, lsl #2
      b4:	0000bb05 	andeq	fp, r0, r5, lsl #22
      b8:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
      bc:	00008a04 	andeq	r8, r0, r4, lsl #20
      c0:	05080900 	streq	r0, [r8, #-2304]	; 0xfffff700
      c4:	000001e4 	andeq	r0, r0, r4, ror #3
      c8:	0000780a 	andeq	r7, r0, sl, lsl #16
      cc:	00811000 	addeq	r1, r1, r0
      d0:	00002000 	andeq	r2, r0, r0
      d4:	e49c0100 	ldr	r0, [ip], #256	; 0x100
      d8:	0b000000 	bleq	e0 <CPSR_IRQ_INHIBIT+0x60>
      dc:	000000bb 	strheq	r0, [r0], -fp
      e0:	00749102 	rsbseq	r9, r4, r2, lsl #2
      e4:	0000960a 	andeq	r9, r0, sl, lsl #12
      e8:	0080e400 	addeq	lr, r0, r0, lsl #8
      ec:	00002c00 	andeq	r2, r0, r0, lsl #24
      f0:	059c0100 	ldreq	r0, [ip, #256]	; 0x100
      f4:	0c000001 	stceq	0, cr0, [r0], {1}
      f8:	0f010067 	svceq	0x00010067
      fc:	0000bb30 	andeq	fp, r0, r0, lsr fp
     100:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     104:	05040d00 	streq	r0, [r4, #-3328]	; 0xfffff300
     108:	00746e69 	rsbseq	r6, r4, r9, ror #28
     10c:	0000a80e 	andeq	sl, r0, lr, lsl #16
     110:	0080ac00 	addeq	sl, r0, r0, lsl #24
     114:	00003800 	andeq	r3, r0, r0, lsl #16
     118:	0c9c0100 	ldfeqs	f0, [ip], {0}
     11c:	0a010067 	beq	402c0 <_bss_end+0x3445c>
     120:	0000bb2f 	andeq	fp, r0, pc, lsr #22
     124:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     128:	07570000 	ldrbeq	r0, [r7, -r0]
     12c:	00040000 	andeq	r0, r4, r0
     130:	000000d0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     134:	00000104 	andeq	r0, r0, r4, lsl #2
     138:	88040000 	stmdahi	r4, {}	; <UNPREDICTABLE>
     13c:	b6000003 	strlt	r0, [r0], -r3
     140:	84000000 	strhi	r0, [r0], #-0
     144:	30000081 	andcc	r0, r0, r1, lsl #1
     148:	b6000005 	strlt	r0, [r0], -r5
     14c:	02000000 	andeq	r0, r0, #0
     150:	04a00801 	strteq	r0, [r0], #2049	; 0x801
     154:	02020000 	andeq	r0, r2, #0
     158:	00028005 	andeq	r8, r2, r5
     15c:	05040300 	streq	r0, [r4, #-768]	; 0xfffffd00
     160:	00746e69 	rsbseq	r6, r4, r9, ror #28
     164:	97080102 	strls	r0, [r8, -r2, lsl #2]
     168:	02000004 	andeq	r0, r0, #4
     16c:	05020702 	streq	r0, [r2, #-1794]	; 0xfffff8fe
     170:	29040000 	stmdbcs	r4, {}	; <UNPREDICTABLE>
     174:	04000003 	streq	r0, [r0], #-3
     178:	0059070b 	subseq	r0, r9, fp, lsl #14
     17c:	48050000 	stmdami	r5, {}	; <UNPREDICTABLE>
     180:	02000000 	andeq	r0, r0, #0
     184:	1ef90704 	cdpne	7, 15, cr0, cr9, cr4, {0}
     188:	59050000 	stmdbpl	r5, {}	; <UNPREDICTABLE>
     18c:	06000000 	streq	r0, [r0], -r0
     190:	00000059 	andeq	r0, r0, r9, asr r0
     194:	6c616807 	stclvs	8, cr6, [r1], #-28	; 0xffffffe4
     198:	0b070200 	bleq	1c09a0 <_bss_end+0x1b4b3c>
     19c:	000001a5 	andeq	r0, r0, r5, lsr #3
     1a0:	00068008 	andeq	r8, r6, r8
     1a4:	19090200 	stmdbne	r9, {r9}
     1a8:	00000060 	andeq	r0, r0, r0, rrx
     1ac:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}
     1b0:	0003e608 	andeq	lr, r3, r8, lsl #12
     1b4:	1a0c0200 	bne	3009bc <_bss_end+0x2f4b58>
     1b8:	000001b1 			; <UNDEFINED> instruction: 0x000001b1
     1bc:	20000000 	andcs	r0, r0, r0
     1c0:	0004c408 	andeq	ip, r4, r8, lsl #8
     1c4:	1a0f0200 	bne	3c09cc <_bss_end+0x3b4b68>
     1c8:	000001b1 			; <UNDEFINED> instruction: 0x000001b1
     1cc:	20200000 	eorcs	r0, r0, r0
     1d0:	00053009 	andeq	r3, r5, r9
     1d4:	15120200 	ldrne	r0, [r2, #-512]	; 0xfffffe00
     1d8:	00000054 	andeq	r0, r0, r4, asr r0
     1dc:	05790a36 	ldrbeq	r0, [r9, #-2614]!	; 0xfffff5ca
     1e0:	04050000 	streq	r0, [r5], #-0
     1e4:	00000033 	andeq	r0, r0, r3, lsr r0
     1e8:	740d1502 	strvc	r1, [sp], #-1282	; 0xfffffafe
     1ec:	0b000001 	bleq	1f8 <CPSR_IRQ_INHIBIT+0x178>
     1f0:	0000022f 	andeq	r0, r0, pc, lsr #4
     1f4:	02370b00 	eorseq	r0, r7, #0, 22
     1f8:	0b010000 	bleq	40200 <_bss_end+0x3439c>
     1fc:	0000023f 	andeq	r0, r0, pc, lsr r2
     200:	02470b02 	subeq	r0, r7, #2048	; 0x800
     204:	0b030000 	bleq	c020c <_bss_end+0xb43a8>
     208:	0000024f 	andeq	r0, r0, pc, asr #4
     20c:	02570b04 	subseq	r0, r7, #4, 22	; 0x1000
     210:	0b050000 	bleq	140218 <_bss_end+0x1343b4>
     214:	00000221 	andeq	r0, r0, r1, lsr #4
     218:	02280b07 	eoreq	r0, r8, #7168	; 0x1c00
     21c:	0b080000 	bleq	200224 <_bss_end+0x1f43c0>
     220:	000006a5 	andeq	r0, r0, r5, lsr #13
     224:	04ce0b0a 	strbeq	r0, [lr], #2826	; 0xb0a
     228:	0b0b0000 	bleq	2c0230 <_bss_end+0x2b43cc>
     22c:	000005c5 	andeq	r0, r0, r5, asr #11
     230:	05cc0b0d 	strbeq	r0, [ip, #2829]	; 0xb0d
     234:	0b0e0000 	bleq	38023c <_bss_end+0x3743d8>
     238:	0000031b 	andeq	r0, r0, fp, lsl r3
     23c:	03220b10 			; <UNDEFINED> instruction: 0x03220b10
     240:	0b110000 	bleq	440248 <_bss_end+0x4343e4>
     244:	0000029e 	muleq	r0, lr, r2
     248:	02a50b13 	adceq	r0, r5, #19456	; 0x4c00
     24c:	0b140000 	bleq	500254 <_bss_end+0x4f43f0>
     250:	00000643 	andeq	r0, r0, r3, asr #12
     254:	025f0b16 	subseq	r0, pc, #22528	; 0x5800
     258:	0b170000 	bleq	5c0260 <_bss_end+0x5b43fc>
     25c:	000004e5 	andeq	r0, r0, r5, ror #9
     260:	04ec0b19 	strbteq	r0, [ip], #2841	; 0xb19
     264:	0b1a0000 	bleq	68026c <_bss_end+0x674408>
     268:	00000343 	andeq	r0, r0, r3, asr #6
     26c:	05150b1c 	ldreq	r0, [r5, #-2844]	; 0xfffff4e4
     270:	0b1d0000 	bleq	740278 <_bss_end+0x734414>
     274:	000004d5 	ldrdeq	r0, [r0], -r5
     278:	04dd0b1f 	ldrbeq	r0, [sp], #2847	; 0xb1f
     27c:	0b200000 	bleq	800284 <_bss_end+0x7f4420>
     280:	00000458 	andeq	r0, r0, r8, asr r4
     284:	04600b22 	strbteq	r0, [r0], #-2850	; 0xfffff4de
     288:	0b230000 	bleq	8c0290 <_bss_end+0x8b442c>
     28c:	00000382 	andeq	r0, r0, r2, lsl #7
     290:	028a0b25 	addeq	r0, sl, #37888	; 0x9400
     294:	0b260000 	bleq	98029c <_bss_end+0x974438>
     298:	00000294 	muleq	r0, r4, r2
     29c:	27080027 	strcs	r0, [r8, -r7, lsr #32]
     2a0:	02000006 	andeq	r0, r0, #6
     2a4:	01b11a44 			; <UNDEFINED> instruction: 0x01b11a44
     2a8:	50000000 	andpl	r0, r0, r0
     2ac:	66082021 	strvs	r2, [r8], -r1, lsr #32
     2b0:	02000002 	andeq	r0, r0, #2
     2b4:	01b11a73 			; <UNDEFINED> instruction: 0x01b11a73
     2b8:	b2000000 	andlt	r0, r0, #0
     2bc:	44082000 	strmi	r2, [r8], #-0
     2c0:	02000005 	andeq	r0, r0, #5
     2c4:	01b11aa6 			; <UNDEFINED> instruction: 0x01b11aa6
     2c8:	b4000000 	strlt	r0, [r0], #-0
     2cc:	0c002000 	stceq	0, cr2, [r0], {-0}
     2d0:	00000076 	andeq	r0, r0, r6, ror r0
     2d4:	f4070402 	vst3.8	{d0-d2}, [r7], r2
     2d8:	0500001e 	streq	r0, [r0, #-30]	; 0xffffffe2
     2dc:	000001aa 	andeq	r0, r0, sl, lsr #3
     2e0:	0000860c 	andeq	r8, r0, ip, lsl #12
     2e4:	00960c00 	addseq	r0, r6, r0, lsl #24
     2e8:	a60c0000 	strge	r0, [ip], -r0
     2ec:	0c000000 	stceq	0, cr0, [r0], {-0}
     2f0:	00000174 	andeq	r0, r0, r4, ror r1
     2f4:	0001840c 	andeq	r8, r1, ip, lsl #8
     2f8:	01940c00 	orrseq	r0, r4, r0, lsl #24
     2fc:	b00a0000 	andlt	r0, sl, r0
     300:	07000005 	streq	r0, [r0, -r5]
     304:	00005904 	andeq	r5, r0, r4, lsl #18
     308:	0c060300 	stceq	3, cr0, [r6], {-0}
     30c:	0000021d 	andeq	r0, r0, sp, lsl r2
     310:	0004be0b 	andeq	fp, r4, fp, lsl #28
     314:	4e0b0000 	cdpmi	0, 0, cr0, cr11, cr0, {0}
     318:	01000006 	tsteq	r0, r6
     31c:	00069f0b 	andeq	r9, r6, fp, lsl #30
     320:	990b0200 	stmdbls	fp, {r9}
     324:	03000006 	movweq	r0, #6
     328:	0006740b 	andeq	r7, r6, fp, lsl #8
     32c:	7a0b0400 	bvc	2c1334 <_bss_end+0x2b54d0>
     330:	05000006 	streq	r0, [r0, #-6]
     334:	0005bf0b 	andeq	fp, r5, fp, lsl #30
     338:	930b0600 	movwls	r0, #46592	; 0xb600
     33c:	07000006 	streq	r0, [r0, -r6]
     340:	0003370b 	andeq	r3, r3, fp, lsl #14
     344:	0d000800 	stceq	8, cr0, [r0, #-0]
     348:	00000361 	andeq	r0, r0, r1, ror #6
     34c:	071a0304 	ldreq	r0, [sl, -r4, lsl #6]
     350:	000003a2 	andeq	r0, r0, r2, lsr #7
     354:	0002fe0e 	andeq	pc, r2, lr, lsl #28
     358:	201e0300 	andscs	r0, lr, r0, lsl #6
     35c:	000003ad 	andeq	r0, r0, sp, lsr #7
     360:	051c0f00 	ldreq	r0, [ip, #-3840]	; 0xfffff100
     364:	22030000 	andcs	r0, r3, #0
     368:	0002ce08 	andeq	ip, r2, r8, lsl #28
     36c:	0003b200 	andeq	fp, r3, r0, lsl #4
     370:	02500200 	subseq	r0, r0, #0, 4
     374:	02650000 	rsbeq	r0, r5, #0
     378:	b9100000 	ldmdblt	r0, {}	; <UNPREDICTABLE>
     37c:	11000003 	tstne	r0, r3
     380:	00000048 	andeq	r0, r0, r8, asr #32
     384:	0003c411 	andeq	ip, r3, r1, lsl r4
     388:	03c41100 	biceq	r1, r4, #0, 2
     38c:	0f000000 	svceq	0x00000000
     390:	00000630 	andeq	r0, r0, r0, lsr r6
     394:	68082403 	stmdavs	r8, {r0, r1, sl, sp}
     398:	b2000004 	andlt	r0, r0, #4
     39c:	02000003 	andeq	r0, r0, #3
     3a0:	0000027e 	andeq	r0, r0, lr, ror r2
     3a4:	00000293 	muleq	r0, r3, r2
     3a8:	0003b910 	andeq	fp, r3, r0, lsl r9
     3ac:	00481100 	subeq	r1, r8, r0, lsl #2
     3b0:	c4110000 	ldrgt	r0, [r1], #-0
     3b4:	11000003 	tstne	r0, r3
     3b8:	000003c4 	andeq	r0, r0, r4, asr #7
     3bc:	036f0f00 	cmneq	pc, #0, 30
     3c0:	26030000 	strcs	r0, [r3], -r0
     3c4:	0005f808 	andeq	pc, r5, r8, lsl #16
     3c8:	0003b200 	andeq	fp, r3, r0, lsl #4
     3cc:	02ac0200 	adceq	r0, ip, #0, 4
     3d0:	02c10000 	sbceq	r0, r1, #0
     3d4:	b9100000 	ldmdblt	r0, {}	; <UNPREDICTABLE>
     3d8:	11000003 	tstne	r0, r3
     3dc:	00000048 	andeq	r0, r0, r8, asr #32
     3e0:	0003c411 	andeq	ip, r3, r1, lsl r4
     3e4:	03c41100 	biceq	r1, r4, #0, 2
     3e8:	0f000000 	svceq	0x00000000
     3ec:	000003f6 	strdeq	r0, [r0], -r6
     3f0:	f2082803 	vadd.i8	d2, d8, d3
     3f4:	b2000001 	andlt	r0, r0, #1
     3f8:	02000003 	andeq	r0, r0, #3
     3fc:	000002da 	ldrdeq	r0, [r0], -sl
     400:	000002ef 	andeq	r0, r0, pc, ror #5
     404:	0003b910 	andeq	fp, r3, r0, lsl r9
     408:	00481100 	subeq	r1, r8, r0, lsl #2
     40c:	c4110000 	ldrgt	r0, [r1], #-0
     410:	11000003 	tstne	r0, r3
     414:	000003c4 	andeq	r0, r0, r4, asr #7
     418:	03610f00 	cmneq	r1, #0, 30
     41c:	2b030000 	blcs	c0424 <_bss_end+0xb45c0>
     420:	00030403 	andeq	r0, r3, r3, lsl #8
     424:	0003ca00 	andeq	ip, r3, r0, lsl #20
     428:	03080100 	movweq	r0, #33024	; 0x8100
     42c:	03130000 	tsteq	r3, #0
     430:	ca100000 	bgt	400438 <_bss_end+0x3f45d4>
     434:	11000003 	tstne	r0, r3
     438:	00000059 	andeq	r0, r0, r9, asr r0
     43c:	05d31200 	ldrbeq	r1, [r3, #512]	; 0x200
     440:	2e030000 	cdpcs	0, 0, cr0, cr3, cr0, {0}
     444:	00058708 	andeq	r8, r5, r8, lsl #14
     448:	03280100 			; <UNDEFINED> instruction: 0x03280100
     44c:	03380000 	teqeq	r8, #0
     450:	ca100000 	bgt	400458 <_bss_end+0x3f45f4>
     454:	11000003 	tstne	r0, r3
     458:	00000048 	andeq	r0, r0, r8, asr #32
     45c:	0001d411 	andeq	sp, r1, r1, lsl r4
     460:	4f0f0000 	svcmi	0x000f0000
     464:	03000003 	movweq	r0, #3
     468:	04091230 	streq	r1, [r9], #-560	; 0xfffffdd0
     46c:	01d40000 	bicseq	r0, r4, r0
     470:	51010000 	mrspl	r0, (UNDEF: 1)
     474:	5c000003 	stcpl	0, cr0, [r0], {3}
     478:	10000003 	andne	r0, r0, r3
     47c:	000003b9 			; <UNDEFINED> instruction: 0x000003b9
     480:	00004811 	andeq	r4, r0, r1, lsl r8
     484:	4a120000 	bmi	48048c <_bss_end+0x474628>
     488:	03000006 	movweq	r0, #6
     48c:	02ac0833 	adceq	r0, ip, #3342336	; 0x330000
     490:	71010000 	mrsvc	r0, (UNDEF: 1)
     494:	81000003 	tsthi	r0, r3
     498:	10000003 	andne	r0, r0, r3
     49c:	000003ca 	andeq	r0, r0, sl, asr #7
     4a0:	00004811 	andeq	r4, r0, r1, lsl r8
     4a4:	03b21100 			; <UNDEFINED> instruction: 0x03b21100
     4a8:	13000000 	movwne	r0, #0
     4ac:	000004ba 			; <UNDEFINED> instruction: 0x000004ba
     4b0:	55083603 	strpl	r3, [r8, #-1539]	; 0xfffff9fd
     4b4:	b2000006 	andlt	r0, r0, #6
     4b8:	01000003 	tsteq	r0, r3
     4bc:	00000396 	muleq	r0, r6, r3
     4c0:	0003ca10 	andeq	ip, r3, r0, lsl sl
     4c4:	00481100 	subeq	r1, r8, r0, lsl #2
     4c8:	00000000 	andeq	r0, r0, r0
     4cc:	00021d05 	andeq	r1, r2, r5, lsl #26
     4d0:	65041400 	strvs	r1, [r4, #-1024]	; 0xfffffc00
     4d4:	05000000 	streq	r0, [r0, #-0]
     4d8:	000003a7 	andeq	r0, r0, r7, lsr #7
     4dc:	32020102 	andcc	r0, r2, #-2147483648	; 0x80000000
     4e0:	14000003 	strne	r0, [r0], #-3
     4e4:	0003a204 	andeq	sl, r3, r4, lsl #4
     4e8:	03b90500 			; <UNDEFINED> instruction: 0x03b90500
     4ec:	04150000 	ldreq	r0, [r5], #-0
     4f0:	00000048 	andeq	r0, r0, r8, asr #32
     4f4:	021d0414 	andseq	r0, sp, #20, 8	; 0x14000000
     4f8:	ca050000 	bgt	140500 <_bss_end+0x13469c>
     4fc:	16000003 	strne	r0, [r0], -r3
     500:	000004b4 			; <UNDEFINED> instruction: 0x000004b4
     504:	1d163a03 	vldrne	s6, [r6, #-12]
     508:	17000002 	strne	r0, [r0, -r2]
     50c:	000003d5 	ldrdeq	r0, [r0], -r5
     510:	050f0401 	streq	r0, [pc, #-1025]	; 117 <CPSR_IRQ_INHIBIT+0x97>
     514:	00ae0803 	adceq	r0, lr, r3, lsl #16
     518:	04a51800 	strteq	r1, [r5], #2048	; 0x800
     51c:	86980000 	ldrhi	r0, [r8], r0
     520:	001c0000 	andseq	r0, ip, r0
     524:	9c010000 	stcls	0, cr0, [r1], {-0}
     528:	00054f19 	andeq	r4, r5, r9, lsl pc
     52c:	00864400 	addeq	r4, r6, r0, lsl #8
     530:	00005400 	andeq	r5, r0, r0, lsl #8
     534:	309c0100 	addscc	r0, ip, r0, lsl #2
     538:	1a000004 	bne	550 <CPSR_IRQ_INHIBIT+0x4d0>
     53c:	00000432 	andeq	r0, r0, r2, lsr r4
     540:	33016a01 	movwcc	r6, #6657	; 0x1a01
     544:	02000000 	andeq	r0, r0, #0
     548:	ed1a7491 	cfldrs	mvf7, [sl, #-580]	; 0xfffffdbc
     54c:	01000005 	tsteq	r0, r5
     550:	0033016a 	eorseq	r0, r3, sl, ror #2
     554:	91020000 	mrsls	r0, (UNDEF: 2)
     558:	811b0070 	tsthi	fp, r0, ror r0
     55c:	01000003 	tsteq	r0, r3
     560:	044a0663 	strbeq	r0, [sl], #-1635	; 0xfffff99d
     564:	85c00000 	strbhi	r0, [r0]
     568:	00840000 	addeq	r0, r4, r0
     56c:	9c010000 	stcls	0, cr0, [r1], {-0}
     570:	00000484 	andeq	r0, r0, r4, lsl #9
     574:	0005821c 	andeq	r8, r5, ip, lsl r2
     578:	0003d000 	andeq	sp, r3, r0
     57c:	6c910200 	lfmvs	f0, 4, [r1], {0}
     580:	6e69701d 	mcrvs	0, 3, r7, cr9, cr13, {0}
     584:	28630100 	stmdacs	r3!, {r8}^
     588:	00000048 	andeq	r0, r0, r8, asr #32
     58c:	1e689102 	lgnnee	f1, f2
     590:	00676572 	rsbeq	r6, r7, r2, ror r5
     594:	480b6501 	stmdami	fp, {r0, r8, sl, sp, lr}
     598:	02000000 	andeq	r0, r0, #0
     59c:	621e7491 	andsvs	r7, lr, #-1862270976	; 0x91000000
     5a0:	01007469 	tsteq	r0, r9, ror #8
     5a4:	00481065 	subeq	r1, r8, r5, rrx
     5a8:	91020000 	mrsls	r0, (UNDEF: 2)
     5ac:	5c1b0070 	ldcpl	0, cr0, [fp], {112}	; 0x70
     5b0:	01000003 	tsteq	r0, r3
     5b4:	049e065a 	ldreq	r0, [lr], #1626	; 0x65a
     5b8:	84e80000 	strbthi	r0, [r8], #0
     5bc:	00d80000 	sbcseq	r0, r8, r0
     5c0:	9c010000 	stcls	0, cr0, [r1], {-0}
     5c4:	000004e7 	andeq	r0, r0, r7, ror #9
     5c8:	0005821c 	andeq	r8, r5, ip, lsl r2
     5cc:	0003d000 	andeq	sp, r3, r0
     5d0:	6c910200 	lfmvs	f0, 4, [r1], {0}
     5d4:	6e69701d 	mcrvs	0, 3, r7, cr9, cr13, {0}
     5d8:	295a0100 	ldmdbcs	sl, {r8}^
     5dc:	00000048 	andeq	r0, r0, r8, asr #32
     5e0:	1d689102 	stfnep	f1, [r8, #-8]!
     5e4:	00746573 	rsbseq	r6, r4, r3, ror r5
     5e8:	b2335a01 	eorslt	r5, r3, #4096	; 0x1000
     5ec:	02000003 	andeq	r0, r0, #3
     5f0:	721e6791 	andsvc	r6, lr, #38010880	; 0x2440000
     5f4:	01006765 	tsteq	r0, r5, ror #14
     5f8:	00480b5c 	subeq	r0, r8, ip, asr fp
     5fc:	91020000 	mrsls	r0, (UNDEF: 2)
     600:	69621e74 	stmdbvs	r2!, {r2, r4, r5, r6, r9, sl, fp, ip}^
     604:	5c010074 	stcpl	0, cr0, [r1], {116}	; 0x74
     608:	00004810 	andeq	r4, r0, r0, lsl r8
     60c:	70910200 	addsvc	r0, r1, r0, lsl #4
     610:	03381b00 	teqeq	r8, #0, 22
     614:	51010000 	mrspl	r0, (UNDEF: 1)
     618:	00050110 	andeq	r0, r5, r0, lsl r1
     61c:	00847400 	addeq	r7, r4, r0, lsl #8
     620:	00007400 	andeq	r7, r0, r0, lsl #8
     624:	3b9c0100 	blcc	fe700a2c <_bss_end+0xfe6f4bc8>
     628:	1c000005 	stcne	0, cr0, [r0], {5}
     62c:	00000582 	andeq	r0, r0, r2, lsl #11
     630:	000003bf 			; <UNDEFINED> instruction: 0x000003bf
     634:	1d6c9102 	stfnep	f1, [ip, #-8]!
     638:	006e6970 	rsbeq	r6, lr, r0, ror r9
     63c:	483a5101 	ldmdami	sl!, {r0, r8, ip, lr}
     640:	02000000 	andeq	r0, r0, #0
     644:	721e6891 	andsvc	r6, lr, #9502720	; 0x910000
     648:	01006765 	tsteq	r0, r5, ror #14
     64c:	00480b53 	subeq	r0, r8, r3, asr fp
     650:	91020000 	mrsls	r0, (UNDEF: 2)
     654:	69621e74 	stmdbvs	r2!, {r2, r4, r5, r6, r9, sl, fp, ip}^
     658:	53010074 	movwpl	r0, #4212	; 0x1074
     65c:	00004810 	andeq	r4, r0, r0, lsl r8
     660:	70910200 	addsvc	r0, r1, r0, lsl #4
     664:	03131b00 	tsteq	r3, #0, 22
     668:	42010000 	andmi	r0, r1, #0
     66c:	00055506 	andeq	r5, r5, r6, lsl #10
     670:	0083ac00 	addeq	sl, r3, r0, lsl #24
     674:	0000c800 	andeq	ip, r0, r0, lsl #16
     678:	bb9c0100 	bllt	fe700a80 <_bss_end+0xfe6f4c1c>
     67c:	1c000005 	stcne	0, cr0, [r0], {5}
     680:	00000582 	andeq	r0, r0, r2, lsl #11
     684:	000003d0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     688:	1d649102 	stfnep	f1, [r4, #-8]!
     68c:	006e6970 	rsbeq	r6, lr, r0, ror r9
     690:	48304201 	ldmdami	r0!, {r0, r9, lr}
     694:	02000000 	andeq	r0, r0, #0
     698:	4a1a6091 	bmi	6988e4 <_bss_end+0x68ca80>
     69c:	01000003 	tsteq	r0, r3
     6a0:	01d44442 	bicseq	r4, r4, r2, asr #8
     6a4:	91020000 	mrsls	r0, (UNDEF: 2)
     6a8:	65721e5c 	ldrbvs	r1, [r2, #-3676]!	; 0xfffff1a4
     6ac:	44010067 	strmi	r0, [r1], #-103	; 0xffffff99
     6b0:	0000480b 	andeq	r4, r0, fp, lsl #16
     6b4:	6c910200 	lfmvs	f0, 4, [r1], {0}
     6b8:	7469621e 	strbtvc	r6, [r9], #-542	; 0xfffffde2
     6bc:	10440100 	subne	r0, r4, r0, lsl #2
     6c0:	00000048 	andeq	r0, r0, r8, asr #32
     6c4:	1f689102 	svcne	0x00689102
     6c8:	0000053f 	andeq	r0, r0, pc, lsr r5
     6cc:	590f4801 	stmdbpl	pc, {r0, fp, lr}	; <UNPREDICTABLE>
     6d0:	02000000 	andeq	r0, r0, #0
     6d4:	721e7491 	andsvc	r7, lr, #-1862270976	; 0x91000000
     6d8:	4a010064 	bmi	40870 <_bss_end+0x34a0c>
     6dc:	0000590f 	andeq	r5, r0, pc, lsl #18
     6e0:	70910200 	addsvc	r0, r1, r0, lsl #4
     6e4:	02c12000 	sbceq	r2, r1, #0
     6e8:	37010000 	strcc	r0, [r1, -r0]
     6ec:	0005d506 	andeq	sp, r5, r6, lsl #10
     6f0:	00833800 	addeq	r3, r3, r0, lsl #16
     6f4:	00007400 	andeq	r7, r0, r0, lsl #8
     6f8:	0f9c0100 	svceq	0x009c0100
     6fc:	1c000006 	stcne	0, cr0, [r0], {6}
     700:	00000582 	andeq	r0, r0, r2, lsl #11
     704:	000003bf 			; <UNDEFINED> instruction: 0x000003bf
     708:	1d749102 	ldfnep	f1, [r4, #-8]!
     70c:	006e6970 	rsbeq	r6, lr, r0, ror r9
     710:	48313701 	ldmdami	r1!, {r0, r8, r9, sl, ip, sp}
     714:	02000000 	andeq	r0, r0, #0
     718:	721d7091 	andsvc	r7, sp, #145	; 0x91
     71c:	01006765 	tsteq	r0, r5, ror #14
     720:	03c44037 	biceq	r4, r4, #55	; 0x37
     724:	91020000 	mrsls	r0, (UNDEF: 2)
     728:	05e51a6c 	strbeq	r1, [r5, #2668]!	; 0xa6c
     72c:	37010000 	strcc	r0, [r1, -r0]
     730:	0003c44f 	andeq	ip, r3, pc, asr #8
     734:	68910200 	ldmvs	r1, {r9}
     738:	02932000 	addseq	r2, r3, #0
     73c:	2c010000 	stccs	0, cr0, [r1], {-0}
     740:	00062906 	andeq	r2, r6, r6, lsl #18
     744:	0082c400 	addeq	ip, r2, r0, lsl #8
     748:	00007400 	andeq	r7, r0, r0, lsl #8
     74c:	639c0100 	orrsvs	r0, ip, #0, 2
     750:	1c000006 	stcne	0, cr0, [r0], {6}
     754:	00000582 	andeq	r0, r0, r2, lsl #11
     758:	000003bf 			; <UNDEFINED> instruction: 0x000003bf
     75c:	1d749102 	ldfnep	f1, [r4, #-8]!
     760:	006e6970 	rsbeq	r6, lr, r0, ror r9
     764:	48312c01 	ldmdami	r1!, {r0, sl, fp, sp}
     768:	02000000 	andeq	r0, r0, #0
     76c:	721d7091 	andsvc	r7, sp, #145	; 0x91
     770:	01006765 	tsteq	r0, r5, ror #14
     774:	03c4402c 	biceq	r4, r4, #44	; 0x2c
     778:	91020000 	mrsls	r0, (UNDEF: 2)
     77c:	05e51a6c 	strbeq	r1, [r5, #2668]!	; 0xa6c
     780:	2c010000 	stccs	0, cr0, [r1], {-0}
     784:	0003c44f 	andeq	ip, r3, pc, asr #8
     788:	68910200 	ldmvs	r1, {r9}
     78c:	02652000 	rsbeq	r2, r5, #0
     790:	21010000 	mrscs	r0, (UNDEF: 1)
     794:	00067d06 	andeq	r7, r6, r6, lsl #26
     798:	00825000 	addeq	r5, r2, r0
     79c:	00007400 	andeq	r7, r0, r0, lsl #8
     7a0:	b79c0100 	ldrlt	r0, [ip, r0, lsl #2]
     7a4:	1c000006 	stcne	0, cr0, [r0], {6}
     7a8:	00000582 	andeq	r0, r0, r2, lsl #11
     7ac:	000003bf 			; <UNDEFINED> instruction: 0x000003bf
     7b0:	1d749102 	ldfnep	f1, [r4, #-8]!
     7b4:	006e6970 	rsbeq	r6, lr, r0, ror r9
     7b8:	48312101 	ldmdami	r1!, {r0, r8, sp}
     7bc:	02000000 	andeq	r0, r0, #0
     7c0:	721d7091 	andsvc	r7, sp, #145	; 0x91
     7c4:	01006765 	tsteq	r0, r5, ror #14
     7c8:	03c44021 	biceq	r4, r4, #33	; 0x21
     7cc:	91020000 	mrsls	r0, (UNDEF: 2)
     7d0:	05e51a6c 	strbeq	r1, [r5, #2668]!	; 0xa6c
     7d4:	21010000 	mrscs	r0, (UNDEF: 1)
     7d8:	0003c44f 	andeq	ip, r3, pc, asr #8
     7dc:	68910200 	ldmvs	r1, {r9}
     7e0:	02372000 	eorseq	r2, r7, #0
     7e4:	0c010000 	stceq	0, cr0, [r1], {-0}
     7e8:	0006d106 	andeq	sp, r6, r6, lsl #2
     7ec:	0081b800 	addeq	fp, r1, r0, lsl #16
     7f0:	00009800 	andeq	r9, r0, r0, lsl #16
     7f4:	0b9c0100 	bleq	fe700bfc <_bss_end+0xfe6f4d98>
     7f8:	1c000007 	stcne	0, cr0, [r0], {7}
     7fc:	00000582 	andeq	r0, r0, r2, lsl #11
     800:	000003bf 			; <UNDEFINED> instruction: 0x000003bf
     804:	1d749102 	ldfnep	f1, [r4, #-8]!
     808:	006e6970 	rsbeq	r6, lr, r0, ror r9
     80c:	48320c01 	ldmdami	r2!, {r0, sl, fp}
     810:	02000000 	andeq	r0, r0, #0
     814:	721d7091 	andsvc	r7, sp, #145	; 0x91
     818:	01006765 	tsteq	r0, r5, ror #14
     81c:	03c4410c 	biceq	r4, r4, #12, 2
     820:	91020000 	mrsls	r0, (UNDEF: 2)
     824:	05e51a6c 	strbeq	r1, [r5, #2668]!	; 0xa6c
     828:	0c010000 	stceq	0, cr0, [r1], {-0}
     82c:	0003c450 	andeq	ip, r3, r0, asr r4
     830:	68910200 	ldmvs	r1, {r9}
     834:	02ef2100 	rsceq	r2, pc, #0, 2
     838:	06010000 	streq	r0, [r1], -r0
     83c:	00071c01 	andeq	r1, r7, r1, lsl #24
     840:	07320000 	ldreq	r0, [r2, -r0]!
     844:	82220000 	eorhi	r0, r2, #0
     848:	d0000005 	andle	r0, r0, r5
     84c:	23000003 	movwcs	r0, #3
     850:	000004f3 	strdeq	r0, [r0], -r3
     854:	592b0601 	stmdbpl	fp!, {r0, r9, sl}
     858:	00000000 	andeq	r0, r0, r0
     85c:	00070b24 	andeq	r0, r7, r4, lsr #22
     860:	00044100 	andeq	r4, r4, r0, lsl #2
     864:	00074900 	andeq	r4, r7, r0, lsl #18
     868:	00818400 	addeq	r8, r1, r0, lsl #8
     86c:	00003400 	andeq	r3, r0, r0, lsl #8
     870:	259c0100 	ldrcs	r0, [ip, #256]	; 0x100
     874:	0000071c 	andeq	r0, r0, ip, lsl r7
     878:	25749102 	ldrbcs	r9, [r4, #-258]!	; 0xfffffefe
     87c:	00000725 	andeq	r0, r0, r5, lsr #14
     880:	00709102 	rsbseq	r9, r0, r2, lsl #2
     884:	00079500 	andeq	r9, r7, r0, lsl #10
     888:	1f000400 	svcne	0x00000400
     88c:	04000003 	streq	r0, [r0], #-3
     890:	00000001 	andeq	r0, r0, r1
     894:	09160400 	ldmdbeq	r6, {sl}
     898:	00b60000 	adcseq	r0, r6, r0
	...
     8a4:	03cb0000 	biceq	r0, fp, #0
     8a8:	f8020000 			; <UNDEFINED> instruction: 0xf8020000
     8ac:	18000007 	stmdane	r0, {r0, r1, r2}
     8b0:	b6070302 	strlt	r0, [r7], -r2, lsl #6
     8b4:	03000002 	movweq	r0, #2
     8b8:	00000754 	andeq	r0, r0, r4, asr r7
     8bc:	02b60407 	adcseq	r0, r6, #117440512	; 0x7000000
     8c0:	06020000 	streq	r0, [r2], -r0
     8c4:	00520110 	subseq	r0, r2, r0, lsl r1
     8c8:	48040000 	stmdami	r4, {}	; <UNPREDICTABLE>
     8cc:	10005845 	andne	r5, r0, r5, asr #16
     8d0:	43454404 	movtmi	r4, #21508	; 0x5404
     8d4:	05000a00 	streq	r0, [r0, #-2560]	; 0xfffff600
     8d8:	00000032 	andeq	r0, r0, r2, lsr r0
     8dc:	00076106 	andeq	r6, r7, r6, lsl #2
     8e0:	27020800 	strcs	r0, [r2, -r0, lsl #16]
     8e4:	00007b0c 	andeq	r7, r0, ip, lsl #22
     8e8:	00790700 	rsbseq	r0, r9, r0, lsl #14
     8ec:	b6162902 	ldrlt	r2, [r6], -r2, lsl #18
     8f0:	00000002 	andeq	r0, r0, r2
     8f4:	02007807 	andeq	r7, r0, #458752	; 0x70000
     8f8:	02b6162a 	adcseq	r1, r6, #44040192	; 0x2a00000
     8fc:	00040000 	andeq	r0, r4, r0
     900:	0008ec08 	andeq	lr, r8, r8, lsl #24
     904:	1b0c0200 	blne	30110c <_bss_end+0x2f52a8>
     908:	00000052 	andeq	r0, r0, r2, asr r0
     90c:	5f090a01 	svcpl	0x00090a01
     910:	02000008 	andeq	r0, r0, #8
     914:	02c8280d 	sbceq	r2, r8, #851968	; 0xd0000
     918:	0a010000 	beq	40920 <_bss_end+0x34abc>
     91c:	000007f8 	strdeq	r0, [r0], -r8
     920:	d90e1002 	stmdble	lr, {r1, ip}
     924:	d9000008 	stmdble	r0, {r3}
     928:	01000002 	tsteq	r0, r2
     92c:	000000af 	andeq	r0, r0, pc, lsr #1
     930:	000000c4 	andeq	r0, r0, r4, asr #1
     934:	0002d90b 	andeq	sp, r2, fp, lsl #18
     938:	02b60c00 	adcseq	r0, r6, #0, 24
     93c:	b60c0000 	strlt	r0, [ip], -r0
     940:	0c000002 	stceq	0, cr0, [r0], {2}
     944:	000002b6 			; <UNDEFINED> instruction: 0x000002b6
     948:	0b0e0d00 	bleq	383d50 <_bss_end+0x377eec>
     94c:	12020000 	andne	r0, r2, #0
     950:	0007c10a 	andeq	ip, r7, sl, lsl #2
     954:	00d90100 	sbcseq	r0, r9, r0, lsl #2
     958:	00df0000 	sbcseq	r0, pc, r0
     95c:	d90b0000 	stmdble	fp, {}	; <UNPREDICTABLE>
     960:	00000002 	andeq	r0, r0, r2
     964:	0008180e 	andeq	r1, r8, lr, lsl #16
     968:	0f140200 	svceq	0x00140200
     96c:	0000087c 	andeq	r0, r0, ip, ror r8
     970:	000002e4 	andeq	r0, r0, r4, ror #5
     974:	0000f801 	andeq	pc, r0, r1, lsl #16
     978:	00010300 	andeq	r0, r1, r0, lsl #6
     97c:	02d90b00 	sbcseq	r0, r9, #0, 22
     980:	cd0c0000 	stcgt	0, cr0, [ip, #-0]
     984:	00000002 	andeq	r0, r0, r2
     988:	0008180e 	andeq	r1, r8, lr, lsl #16
     98c:	0f150200 	svceq	0x00150200
     990:	00000823 	andeq	r0, r0, r3, lsr #16
     994:	000002e4 	andeq	r0, r0, r4, ror #5
     998:	00011c01 	andeq	r1, r1, r1, lsl #24
     99c:	00012700 	andeq	r2, r1, r0, lsl #14
     9a0:	02d90b00 	sbcseq	r0, r9, #0, 22
     9a4:	c20c0000 	andgt	r0, ip, #0
     9a8:	00000002 	andeq	r0, r0, r2
     9ac:	0008180e 	andeq	r1, r8, lr, lsl #16
     9b0:	0f160200 	svceq	0x00160200
     9b4:	000007d6 	ldrdeq	r0, [r0], -r6
     9b8:	000002e4 	andeq	r0, r0, r4, ror #5
     9bc:	00014001 	andeq	r4, r1, r1
     9c0:	00014b00 	andeq	r4, r1, r0, lsl #22
     9c4:	02d90b00 	sbcseq	r0, r9, #0, 22
     9c8:	320c0000 	andcc	r0, ip, #0
     9cc:	00000000 	andeq	r0, r0, r0
     9d0:	0008180e 	andeq	r1, r8, lr, lsl #16
     9d4:	0f170200 	svceq	0x00170200
     9d8:	000008ab 	andeq	r0, r0, fp, lsr #17
     9dc:	000002e4 	andeq	r0, r0, r4, ror #5
     9e0:	00016401 	andeq	r6, r1, r1, lsl #8
     9e4:	00016f00 	andeq	r6, r1, r0, lsl #30
     9e8:	02d90b00 	sbcseq	r0, r9, #0, 22
     9ec:	b60c0000 	strlt	r0, [ip], -r0
     9f0:	00000002 	andeq	r0, r0, r2
     9f4:	0008180e 	andeq	r1, r8, lr, lsl #16
     9f8:	0f180200 	svceq	0x00180200
     9fc:	0000086b 	andeq	r0, r0, fp, ror #16
     a00:	000002e4 	andeq	r0, r0, r4, ror #5
     a04:	00018801 	andeq	r8, r1, r1, lsl #16
     a08:	00019300 	andeq	r9, r1, r0, lsl #6
     a0c:	02d90b00 	sbcseq	r0, r9, #0, 22
     a10:	ea0c0000 	b	300a18 <_bss_end+0x2f4bb4>
     a14:	00000002 	andeq	r0, r0, r2
     a18:	00073f0f 	andeq	r3, r7, pc, lsl #30
     a1c:	111b0200 	tstne	fp, r0, lsl #4
     a20:	0000070f 	andeq	r0, r0, pc, lsl #14
     a24:	000001a7 	andeq	r0, r0, r7, lsr #3
     a28:	000001ad 	andeq	r0, r0, sp, lsr #3
     a2c:	0002d90b 	andeq	sp, r2, fp, lsl #18
     a30:	320f0000 	andcc	r0, pc, #0
     a34:	02000007 	andeq	r0, r0, #7
     a38:	08bc111c 	ldmeq	ip!, {r2, r3, r4, r8, ip}
     a3c:	01c10000 	biceq	r0, r1, r0
     a40:	01c70000 	biceq	r0, r7, r0
     a44:	d90b0000 	stmdble	fp, {}	; <UNPREDICTABLE>
     a48:	00000002 	andeq	r0, r0, r2
     a4c:	0006d00f 	andeq	sp, r6, pc
     a50:	111d0200 	tstne	sp, r0, lsl #4
     a54:	0000076b 	andeq	r0, r0, fp, ror #14
     a58:	000001db 	ldrdeq	r0, [r0], -fp
     a5c:	000001e1 	andeq	r0, r0, r1, ror #3
     a60:	0002d90b 	andeq	sp, r2, fp, lsl #18
     a64:	4d100000 	ldcmi	0, cr0, [r0, #-0]
     a68:	02000007 	andeq	r0, r0, #7
     a6c:	0801191f 	stmdaeq	r1, {r0, r1, r2, r3, r4, r8, fp, ip}
     a70:	02b60000 	adcseq	r0, r6, #0
     a74:	01f90000 	mvnseq	r0, r0
     a78:	02090000 	andeq	r0, r9, #0
     a7c:	d90b0000 	stmdble	fp, {}	; <UNPREDICTABLE>
     a80:	0c000002 	stceq	0, cr0, [r0], {2}
     a84:	000002b6 			; <UNDEFINED> instruction: 0x000002b6
     a88:	0002b60c 	andeq	fp, r2, ip, lsl #12
     a8c:	83100000 	tsthi	r0, #0
     a90:	02000009 	andeq	r0, r0, #9
     a94:	06e21920 	strbteq	r1, [r2], r0, lsr #18
     a98:	02b60000 	adcseq	r0, r6, #0
     a9c:	02210000 	eoreq	r0, r1, #0
     aa0:	02310000 	eorseq	r0, r1, #0
     aa4:	d90b0000 	stmdble	fp, {}	; <UNPREDICTABLE>
     aa8:	0c000002 	stceq	0, cr0, [r0], {2}
     aac:	000002b6 			; <UNDEFINED> instruction: 0x000002b6
     ab0:	0002b60c 	andeq	fp, r2, ip, lsl #12
     ab4:	ac0f0000 	stcge	0, cr0, [pc], {-0}
     ab8:	02000006 	andeq	r0, r0, #6
     abc:	08950a22 	ldmeq	r5, {r1, r5, r9, fp}
     ac0:	02450000 	subeq	r0, r5, #0
     ac4:	024b0000 	subeq	r0, fp, #0
     ac8:	d90b0000 	stmdble	fp, {}	; <UNPREDICTABLE>
     acc:	00000002 	andeq	r0, r0, r2
     ad0:	00072d0f 	andeq	r2, r7, pc, lsl #26
     ad4:	0a240200 	beq	9012dc <_bss_end+0x8f5478>
     ad8:	00000836 	andeq	r0, r0, r6, lsr r8
     adc:	0000025f 	andeq	r0, r0, pc, asr r2
     ae0:	00000274 	andeq	r0, r0, r4, ror r2
     ae4:	0002d90b 	andeq	sp, r2, fp, lsl #18
     ae8:	02b60c00 	adcseq	r0, r6, #0, 24
     aec:	f10c0000 	cpsid	
     af0:	0c000002 	stceq	0, cr0, [r0], {2}
     af4:	000002b6 			; <UNDEFINED> instruction: 0x000002b6
     af8:	078d1100 	streq	r1, [sp, r0, lsl #2]
     afc:	2e020000 	cdpcs	0, 0, cr0, cr2, cr0, {0}
     b00:	0002fd23 	andeq	pc, r2, r3, lsr #26
     b04:	8d110000 	ldchi	0, cr0, [r1, #-0]
     b08:	02000008 	andeq	r0, r0, #8
     b0c:	02b6122f 	adcseq	r1, r6, #-268435454	; 0xf0000002
     b10:	11040000 	mrsne	r0, (UNDEF: 4)
     b14:	0000084d 	andeq	r0, r0, sp, asr #16
     b18:	b6123002 	ldrlt	r3, [r2], -r2
     b1c:	08000002 	stmdaeq	r0, {r1}
     b20:	00085611 	andeq	r5, r8, r1, lsl r6
     b24:	0f310200 	svceq	0x00310200
     b28:	00000057 	andeq	r0, r0, r7, asr r0
     b2c:	06c2110c 	strbeq	r1, [r2], ip, lsl #2
     b30:	32020000 	andcc	r0, r2, #0
     b34:	00003212 	andeq	r3, r0, r2, lsl r2
     b38:	12001400 	andne	r1, r0, #0, 8
     b3c:	1ef90704 	cdpne	7, 15, cr0, cr9, cr4, {0}
     b40:	b6050000 	strlt	r0, [r5], -r0
     b44:	13000002 	movwne	r0, #2
     b48:	0002d404 	andeq	sp, r2, r4, lsl #8
     b4c:	02c20500 	sbceq	r0, r2, #0, 10
     b50:	01120000 	tsteq	r2, r0
     b54:	0004a008 	andeq	sl, r4, r8
     b58:	02cd0500 	sbceq	r0, sp, #0, 10
     b5c:	04130000 	ldreq	r0, [r3], #-0
     b60:	00000025 	andeq	r0, r0, r5, lsr #32
     b64:	0002d905 	andeq	sp, r2, r5, lsl #18
     b68:	25041400 	strcs	r1, [r4, #-1024]	; 0xfffffc00
     b6c:	12000000 	andne	r0, r0, #0
     b70:	03320201 	teqeq	r2, #268435456	; 0x10000000
     b74:	04130000 	ldreq	r0, [r3], #-0
     b78:	000002cd 	andeq	r0, r0, sp, asr #5
     b7c:	03090413 	movweq	r0, #37907	; 0x9413
     b80:	f7050000 			; <UNDEFINED> instruction: 0xf7050000
     b84:	12000002 	andne	r0, r0, #2
     b88:	04970801 	ldreq	r0, [r7], #2049	; 0x801
     b8c:	02150000 	andseq	r0, r5, #0
     b90:	16000003 	strne	r0, [r0], -r3
     b94:	000007a6 	andeq	r0, r0, r6, lsr #15
     b98:	25113502 	ldrcs	r3, [r1, #-1282]	; 0xfffffafe
     b9c:	17000000 	strne	r0, [r0, -r0]
     ba0:	0000030e 	andeq	r0, r0, lr, lsl #6
     ba4:	050a0301 	streq	r0, [sl, #-769]	; 0xfffffcff
     ba8:	00ae0c03 	adceq	r0, lr, r3, lsl #24
     bac:	07971800 	ldreq	r1, [r7, r0, lsl #16]
     bb0:	8cd00000 	ldclhi	0, cr0, [r0], {0}
     bb4:	001c0000 	andseq	r0, ip, r0
     bb8:	9c010000 	stcls	0, cr0, [r1], {-0}
     bbc:	00054f19 	andeq	r4, r5, r9, lsl pc
     bc0:	008c7800 	addeq	r7, ip, r0, lsl #16
     bc4:	00005800 	andeq	r5, r0, r0, lsl #16
     bc8:	699c0100 	ldmibvs	ip, {r8}
     bcc:	1a000003 	bne	be0 <CPSR_IRQ_INHIBIT+0xb60>
     bd0:	00000432 	andeq	r0, r0, r2, lsr r4
     bd4:	6901cb01 	stmdbvs	r1, {r0, r8, r9, fp, lr, pc}
     bd8:	02000003 	andeq	r0, r0, #3
     bdc:	ed1a7491 	cfldrs	mvf7, [sl, #-580]	; 0xfffffdbc
     be0:	01000005 	tsteq	r0, r5
     be4:	036901cb 	cmneq	r9, #-1073741774	; 0xc0000032
     be8:	91020000 	mrsls	r0, (UNDEF: 2)
     bec:	041b0070 	ldreq	r0, [fp], #-112	; 0xffffff90
     bf0:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
     bf4:	024b1c00 	subeq	r1, fp, #0, 24
     bf8:	b1010000 	mrslt	r0, (UNDEF: 1)
     bfc:	00038a06 	andeq	r8, r3, r6, lsl #20
     c00:	008b0c00 	addeq	r0, fp, r0, lsl #24
     c04:	00016c00 	andeq	r6, r1, r0, lsl #24
     c08:	ff9c0100 			; <UNDEFINED> instruction: 0xff9c0100
     c0c:	1d000003 	stcne	0, cr0, [r0, #-12]
     c10:	00000582 	andeq	r0, r0, r2, lsl #11
     c14:	000002df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
     c18:	1a649102 	bne	1925028 <_bss_end+0x19191c4>
     c1c:	00000907 	andeq	r0, r0, r7, lsl #18
     c20:	b622b101 	strtlt	fp, [r2], -r1, lsl #2
     c24:	02000002 	andeq	r0, r0, #2
     c28:	001a6091 	mulseq	sl, r1, r0
     c2c:	01000009 	tsteq	r0, r9
     c30:	02f12fb1 	rscseq	r2, r1, #708	; 0x2c4
     c34:	91020000 	mrsls	r0, (UNDEF: 2)
     c38:	0b971a5c 	bleq	fe5c75b0 <_bss_end+0xfe5bb74c>
     c3c:	b1010000 	mrslt	r0, (UNDEF: 1)
     c40:	0002b644 	andeq	fp, r2, r4, asr #12
     c44:	58910200 	ldmpl	r1, {r9}
     c48:	0100691e 	tsteq	r0, lr, lsl r9
     c4c:	036909b3 	cmneq	r9, #2932736	; 0x2cc000
     c50:	91020000 	mrsls	r0, (UNDEF: 2)
     c54:	8bdc1f74 	blhi	ff708a2c <_bss_end+0xff6fcbc8>
     c58:	008c0000 	addeq	r0, ip, r0
     c5c:	6a1e0000 	bvs	780c64 <_bss_end+0x774e00>
     c60:	0ec50100 	poleqs	f0, f5, f0
     c64:	00000369 	andeq	r0, r0, r9, ror #6
     c68:	1f709102 	svcne	0x00709102
     c6c:	00008bf8 	strdeq	r8, [r0], -r8	; <UNPREDICTABLE>
     c70:	00000060 	andeq	r0, r0, r0, rrx
     c74:	0100631e 	tsteq	r0, lr, lsl r3
     c78:	02cd0ec7 	sbceq	r0, sp, #3184	; 0xc70
     c7c:	91020000 	mrsls	r0, (UNDEF: 2)
     c80:	0000006f 	andeq	r0, r0, pc, rrx
     c84:	00020920 	andeq	r0, r2, r0, lsr #18
     c88:	0e9e0100 	fmleqe	f0, f6, f0
     c8c:	00000419 	andeq	r0, r0, r9, lsl r4
     c90:	00008e68 	andeq	r8, r0, r8, ror #28
     c94:	0000007c 	andeq	r0, r0, ip, ror r0
     c98:	04409c01 	strbeq	r9, [r0], #-3073	; 0xfffff3ff
     c9c:	821d0000 	andshi	r0, sp, #0
     ca0:	df000005 	svcle	0x00000005
     ca4:	02000002 	andeq	r0, r0, #2
     ca8:	61217491 			; <UNDEFINED> instruction: 0x61217491
     cac:	2f9e0100 	svccs	0x009e0100
     cb0:	000002b6 			; <UNDEFINED> instruction: 0x000002b6
     cb4:	21709102 	cmncs	r0, r2, lsl #2
     cb8:	9e010062 	cdpls	0, 0, cr0, cr1, cr2, {3}
     cbc:	0002b63f 	andeq	fp, r2, pc, lsr r6
     cc0:	6c910200 	lfmvs	f0, 4, [r1], {0}
     cc4:	01e12000 	mvneq	r2, r0
     cc8:	87010000 	strhi	r0, [r1, -r0]
     ccc:	00045a0e 	andeq	r5, r4, lr, lsl #20
     cd0:	008dd800 	addeq	sp, sp, r0, lsl #16
     cd4:	00009000 	andeq	r9, r0, r0
     cd8:	909c0100 	addsls	r0, ip, r0, lsl #2
     cdc:	1d000004 	stcne	0, cr0, [r0, #-16]
     ce0:	00000582 	andeq	r0, r0, r2, lsl #11
     ce4:	000002df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
     ce8:	216c9102 	cmncs	ip, r2, lsl #2
     cec:	87010061 	strhi	r0, [r1, -r1, rrx]
     cf0:	0002b62c 	andeq	fp, r2, ip, lsr #12
     cf4:	68910200 	ldmvs	r1, {r9}
     cf8:	01006221 	tsteq	r0, r1, lsr #4
     cfc:	02b63c87 	adcseq	r3, r6, #34560	; 0x8700
     d00:	91020000 	mrsls	r0, (UNDEF: 2)
     d04:	06b92264 	ldrteq	r2, [r9], r4, ror #4
     d08:	93010000 	movwls	r0, #4096	; 0x1000
     d0c:	0002b612 	andeq	fp, r2, r2, lsl r6
     d10:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     d14:	016f1c00 	cmneq	pc, r0, lsl #24
     d18:	77010000 	strvc	r0, [r1, -r0]
     d1c:	0004aa0b 	andeq	sl, r4, fp, lsl #20
     d20:	008aac00 	addeq	sl, sl, r0, lsl #24
     d24:	00006000 	andeq	r6, r0, r0
     d28:	c69c0100 	ldrgt	r0, [ip], r0, lsl #2
     d2c:	1d000004 	stcne	0, cr0, [r0, #-16]
     d30:	00000582 	andeq	r0, r0, r2, lsl #11
     d34:	000002df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
     d38:	1a749102 	bne	1d25148 <_bss_end+0x1d192e4>
     d3c:	000006b3 			; <UNDEFINED> instruction: 0x000006b3
     d40:	ea257701 	b	95e94c <_bss_end+0x952ae8>
     d44:	02000002 	andeq	r0, r0, #2
     d48:	1c007391 	stcne	3, cr7, [r0], {145}	; 0x91
     d4c:	0000014b 	andeq	r0, r0, fp, asr #2
     d50:	e00b6a01 	and	r6, fp, r1, lsl #20
     d54:	58000004 	stmdapl	r0, {r2}
     d58:	5400008a 	strpl	r0, [r0], #-138	; 0xffffff76
     d5c:	01000000 	mrseq	r0, (UNDEF: 0)
     d60:	0005209c 	muleq	r5, ip, r0
     d64:	05821d00 	streq	r1, [r2, #3328]	; 0xd00
     d68:	02df0000 	sbcseq	r0, pc, #0
     d6c:	91020000 	mrsls	r0, (UNDEF: 2)
     d70:	756e2174 	strbvc	r2, [lr, #-372]!	; 0xfffffe8c
     d74:	6a01006d 	bvs	40f30 <_bss_end+0x350cc>
     d78:	0002b62d 	andeq	fp, r2, sp, lsr #12
     d7c:	70910200 	addsvc	r0, r1, r0, lsl #4
     d80:	00097723 	andeq	r7, r9, r3, lsr #14
     d84:	236c0100 	cmncs	ip, #0, 2
     d88:	000002bd 			; <UNDEFINED> instruction: 0x000002bd
     d8c:	ac400305 	mcrrge	3, 0, r0, r0, cr5
     d90:	0d220000 	stceq	0, cr0, [r2, #-0]
     d94:	01000009 	tsteq	r0, r9
     d98:	0520116e 	streq	r1, [r0, #-366]!	; 0xfffffe92
     d9c:	03050000 	movweq	r0, #20480	; 0x5000
     da0:	0000ae24 	andeq	sl, r0, r4, lsr #28
     da4:	02cd2400 	sbceq	r2, sp, #0, 8
     da8:	05300000 	ldreq	r0, [r0, #-0]!
     dac:	b6250000 	strtlt	r0, [r5], -r0
     db0:	0f000002 	svceq	0x00000002
     db4:	01272000 			; <UNDEFINED> instruction: 0x01272000
     db8:	63010000 	movwvs	r0, #4096	; 0x1000
     dbc:	00054a0b 	andeq	r4, r5, fp, lsl #20
     dc0:	008a2400 	addeq	r2, sl, r0, lsl #8
     dc4:	00003400 	andeq	r3, r0, r0, lsl #8
     dc8:	669c0100 	ldrvs	r0, [ip], r0, lsl #2
     dcc:	1d000005 	stcne	0, cr0, [r0, #-20]	; 0xffffffec
     dd0:	00000582 	andeq	r0, r0, r2, lsl #11
     dd4:	000002df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
     dd8:	1a749102 	bne	1d251e8 <_bss_end+0x1d19384>
     ddc:	000006c4 	andeq	r0, r0, r4, asr #13
     de0:	32376301 	eorscc	r6, r7, #67108864	; 0x4000000
     de4:	02000000 	andeq	r0, r0, #0
     de8:	1c007091 	stcne	0, cr7, [r0], {145}	; 0x91
     dec:	00000103 	andeq	r0, r0, r3, lsl #2
     df0:	800b5701 	andhi	r5, fp, r1, lsl #14
     df4:	ac000005 	stcge	0, cr0, [r0], {5}
     df8:	78000089 	stmdavc	r0, {r0, r3, r7}
     dfc:	01000000 	mrseq	r0, (UNDEF: 0)
     e00:	0005b39c 	muleq	r5, ip, r3
     e04:	05821d00 	streq	r1, [r2, #3328]	; 0xd00
     e08:	02df0000 	sbcseq	r0, pc, #0
     e0c:	91020000 	mrsls	r0, (UNDEF: 2)
     e10:	7473216c 	ldrbtvc	r2, [r3], #-364	; 0xfffffe94
     e14:	57010072 	smlsdxpl	r1, r2, r0, r0
     e18:	0002c22c 	andeq	ip, r2, ip, lsr #4
     e1c:	68910200 	ldmvs	r1, {r9}
     e20:	0089c01f 	addeq	ip, r9, pc, lsl r0
     e24:	00004c00 	andeq	r4, r0, r0, lsl #24
     e28:	00691e00 	rsbeq	r1, r9, r0, lsl #28
     e2c:	b6175901 	ldrlt	r5, [r7], -r1, lsl #18
     e30:	02000002 	andeq	r0, r0, #2
     e34:	00007491 	muleq	r0, r1, r4
     e38:	0000df1c 	andeq	sp, r0, ip, lsl pc
     e3c:	0b450100 	bleq	1141244 <_bss_end+0x11353e0>
     e40:	000005cd 	andeq	r0, r0, sp, asr #11
     e44:	00008904 	andeq	r8, r0, r4, lsl #18
     e48:	000000a8 	andeq	r0, r0, r8, lsr #1
     e4c:	05e79c01 	strbeq	r9, [r7, #3073]!	; 0xc01
     e50:	821d0000 	andshi	r0, sp, #0
     e54:	df000005 	svcle	0x00000005
     e58:	02000002 	andeq	r0, r0, #2
     e5c:	63217491 			; <UNDEFINED> instruction: 0x63217491
     e60:	25450100 	strbcs	r0, [r5, #-256]	; 0xffffff00
     e64:	000002cd 	andeq	r0, r0, sp, asr #5
     e68:	00739102 	rsbseq	r9, r3, r2, lsl #2
     e6c:	0001c720 	andeq	ip, r1, r0, lsr #14
     e70:	06400100 	strbeq	r0, [r0], -r0, lsl #2
     e74:	00000601 	andeq	r0, r0, r1, lsl #12
     e78:	00008dac 	andeq	r8, r0, ip, lsr #27
     e7c:	0000002c 	andeq	r0, r0, ip, lsr #32
     e80:	060e9c01 	streq	r9, [lr], -r1, lsl #24
     e84:	821d0000 	andshi	r0, sp, #0
     e88:	df000005 	svcle	0x00000005
     e8c:	02000002 	andeq	r0, r0, #2
     e90:	20007491 	mulcs	r0, r1, r4
     e94:	00000231 	andeq	r0, r0, r1, lsr r2
     e98:	28063001 	stmdacs	r6, {r0, ip, sp}
     e9c:	d4000006 	strle	r0, [r0], #-6
     ea0:	30000087 	andcc	r0, r0, r7, lsl #1
     ea4:	01000001 	tsteq	r0, r1
     ea8:	00067e9c 	muleq	r6, ip, lr
     eac:	05821d00 	streq	r1, [r2, #3328]	; 0xd00
     eb0:	02df0000 	sbcseq	r0, pc, #0
     eb4:	91020000 	mrsls	r0, (UNDEF: 2)
     eb8:	87e42664 	strbhi	r2, [r4, r4, ror #12]!
     ebc:	00b00000 	adcseq	r0, r0, r0
     ec0:	06660000 	strbteq	r0, [r6], -r0
     ec4:	791e0000 	ldmdbvc	lr, {}	; <UNPREDICTABLE>
     ec8:	17320100 	ldrne	r0, [r2, -r0, lsl #2]!
     ecc:	000002b6 			; <UNDEFINED> instruction: 0x000002b6
     ed0:	1f749102 	svcne	0x00749102
     ed4:	00008800 	andeq	r8, r0, r0, lsl #16
     ed8:	00000084 	andeq	r0, r0, r4, lsl #1
     edc:	0100781e 	tsteq	r0, lr, lsl r8
     ee0:	02b61b34 	adcseq	r1, r6, #52, 22	; 0xd000
     ee4:	91020000 	mrsls	r0, (UNDEF: 2)
     ee8:	1f000070 	svcne	0x00000070
     eec:	00008894 	muleq	r0, r4, r8
     ef0:	00000060 	andeq	r0, r0, r0, rrx
     ef4:	0100781e 	tsteq	r0, lr, lsl r8
     ef8:	02b6173a 	adcseq	r1, r6, #15204352	; 0xe80000
     efc:	91020000 	mrsls	r0, (UNDEF: 2)
     f00:	1c00006c 	stcne	0, cr0, [r0], {108}	; 0x6c
     f04:	00000193 	muleq	r0, r3, r1
     f08:	98062101 	stmdals	r6, {r0, r8, sp}
     f0c:	24000006 	strcs	r0, [r0], #-6
     f10:	8800008d 	stmdahi	r0, {r0, r2, r3, r7}
     f14:	01000000 	mrseq	r0, (UNDEF: 0)
     f18:	0006a59c 	muleq	r6, ip, r5
     f1c:	05821d00 	streq	r1, [r2, #3328]	; 0xd00
     f20:	02df0000 	sbcseq	r0, pc, #0
     f24:	91020000 	mrsls	r0, (UNDEF: 2)
     f28:	c41c0074 	ldrgt	r0, [ip], #-116	; 0xffffff8c
     f2c:	01000000 	mrseq	r0, (UNDEF: 0)
     f30:	06bf0614 	ssateq	r0, #32, r4, lsl #12
     f34:	872c0000 	strhi	r0, [ip, -r0]!
     f38:	00a80000 	adceq	r0, r8, r0
     f3c:	9c010000 	stcls	0, cr0, [r1], {-0}
     f40:	000006fa 	strdeq	r0, [r0], -sl
     f44:	0005821d 	andeq	r8, r5, sp, lsl r2
     f48:	0002df00 	andeq	sp, r2, r0, lsl #30
     f4c:	6c910200 	lfmvs	f0, 4, [r1], {0}
     f50:	0087441f 	addeq	r4, r7, pc, lsl r4
     f54:	00008400 	andeq	r8, r0, r0, lsl #8
     f58:	00791e00 	rsbseq	r1, r9, r0, lsl #28
     f5c:	b6171801 	ldrlt	r1, [r7], -r1, lsl #16
     f60:	02000002 	andeq	r0, r0, #2
     f64:	601f7491 	mulsvs	pc, r1, r4	; <UNPREDICTABLE>
     f68:	58000087 	stmdapl	r0, {r0, r1, r2, r7}
     f6c:	1e000000 	cdpne	0, 0, cr0, cr0, cr0, {0}
     f70:	1a010078 	bne	41158 <_bss_end+0x352f4>
     f74:	0002b61b 	andeq	fp, r2, fp, lsl r6
     f78:	70910200 	addsvc	r0, r1, r0, lsl #4
     f7c:	20000000 	andcs	r0, r0, r0
     f80:	000001ad 	andeq	r0, r0, sp, lsr #3
     f84:	14060e01 	strne	r0, [r6], #-3585	; 0xfffff1ff
     f88:	ec000007 	stc	0, cr0, [r0], {7}
     f8c:	3800008c 	stmdacc	r0, {r2, r3, r7}
     f90:	01000000 	mrseq	r0, (UNDEF: 0)
     f94:	0007219c 	muleq	r7, ip, r1
     f98:	05821d00 	streq	r1, [r2, #3328]	; 0xd00
     f9c:	02df0000 	sbcseq	r0, pc, #0
     fa0:	91020000 	mrsls	r0, (UNDEF: 2)
     fa4:	96270074 			; <UNDEFINED> instruction: 0x96270074
     fa8:	01000000 	mrseq	r0, (UNDEF: 0)
     fac:	07320105 	ldreq	r0, [r2, -r5, lsl #2]!
     fb0:	60000000 	andvs	r0, r0, r0
     fb4:	28000007 	stmdacs	r0, {r0, r1, r2}
     fb8:	00000582 	andeq	r0, r0, r2, lsl #11
     fbc:	000002df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
     fc0:	0007af29 	andeq	sl, r7, r9, lsr #30
     fc4:	21050100 	mrscs	r0, (UNDEF: 21)
     fc8:	000002b6 			; <UNDEFINED> instruction: 0x000002b6
     fcc:	00088f29 	andeq	r8, r8, r9, lsr #30
     fd0:	41050100 	mrsmi	r0, (UNDEF: 21)
     fd4:	000002b6 			; <UNDEFINED> instruction: 0x000002b6
     fd8:	00084f29 	andeq	r4, r8, r9, lsr #30
     fdc:	55050100 	strpl	r0, [r5, #-256]	; 0xffffff00
     fe0:	000002b6 			; <UNDEFINED> instruction: 0x000002b6
     fe4:	07212a00 	streq	r2, [r1, -r0, lsl #20]!
     fe8:	06fc0000 	ldrbteq	r0, [ip], r0
     fec:	07770000 	ldrbeq	r0, [r7, -r0]!
     ff0:	86b40000 	ldrthi	r0, [r4], r0
     ff4:	00780000 	rsbseq	r0, r8, r0
     ff8:	9c010000 	stcls	0, cr0, [r1], {-0}
     ffc:	0007322b 	andeq	r3, r7, fp, lsr #4
    1000:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1004:	00073b2b 	andeq	r3, r7, fp, lsr #22
    1008:	70910200 	addsvc	r0, r1, r0, lsl #4
    100c:	0007472b 	andeq	r4, r7, fp, lsr #14
    1010:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1014:	0007532b 	andeq	r5, r7, fp, lsr #6
    1018:	68910200 	ldmvs	r1, {r9}
    101c:	054f0000 	strbeq	r0, [pc, #-0]	; 1024 <CPSR_IRQ_INHIBIT+0xfa4>
    1020:	00040000 	andeq	r0, r4, r0
    1024:	000005e0 	andeq	r0, r0, r0, ror #11
    1028:	00000104 	andeq	r0, r0, r4, lsl #2
    102c:	c6040000 	strgt	r0, [r4], -r0
    1030:	b6000009 	strlt	r0, [r0], -r9
    1034:	e4000000 	str	r0, [r0], #-0
    1038:	9000008e 	andls	r0, r0, lr, lsl #1
    103c:	28000002 	stmdacs	r0, {r1}
    1040:	02000008 	andeq	r0, r0, #8
    1044:	04a00801 	strteq	r0, [r0], #2049	; 0x801
    1048:	02020000 	andeq	r0, r2, #0
    104c:	00028005 	andeq	r8, r2, r5
    1050:	05040300 	streq	r0, [r4, #-768]	; 0xfffffd00
    1054:	00746e69 	rsbseq	r6, r4, r9, ror #28
    1058:	000a5904 	andeq	r5, sl, r4, lsl #18
    105c:	07090200 	streq	r0, [r9, -r0, lsl #4]
    1060:	00000046 	andeq	r0, r0, r6, asr #32
    1064:	97080102 	strls	r0, [r8, -r2, lsl #2]
    1068:	04000004 	streq	r0, [r0], #-4
    106c:	00000b59 	andeq	r0, r0, r9, asr fp
    1070:	59070a02 	stmdbpl	r7, {r1, r9, fp}
    1074:	02000000 	andeq	r0, r0, #0
    1078:	05020702 	streq	r0, [r2, #-1794]	; 0xfffff8fe
    107c:	29040000 	stmdbcs	r4, {}	; <UNPREDICTABLE>
    1080:	02000003 	andeq	r0, r0, #3
    1084:	0071070b 	rsbseq	r0, r1, fp, lsl #14
    1088:	60050000 	andvs	r0, r5, r0
    108c:	02000000 	andeq	r0, r0, #0
    1090:	1ef90704 	cdpne	7, 15, cr0, cr9, cr4, {0}
    1094:	71050000 	mrsvc	r0, (UNDEF: 5)
    1098:	06000000 	streq	r0, [r0], -r0
    109c:	00000071 	andeq	r0, r0, r1, ror r0
    10a0:	6c616807 	stclvs	8, cr6, [r1], #-28	; 0xffffffe4
    10a4:	0b070300 	bleq	1c1cac <_bss_end+0x1b5e48>
    10a8:	00000141 	andeq	r0, r0, r1, asr #2
    10ac:	00068008 	andeq	r8, r6, r8
    10b0:	19090300 	stmdbne	r9, {r8, r9}
    10b4:	00000078 	andeq	r0, r0, r8, ror r0
    10b8:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}
    10bc:	0003e608 	andeq	lr, r3, r8, lsl #12
    10c0:	1a0c0300 	bne	301cc8 <_bss_end+0x2f5e64>
    10c4:	0000014d 	andeq	r0, r0, sp, asr #2
    10c8:	20000000 	andcs	r0, r0, r0
    10cc:	0004c408 	andeq	ip, r4, r8, lsl #8
    10d0:	1a0f0300 	bne	3c1cd8 <_bss_end+0x3b5e74>
    10d4:	0000014d 	andeq	r0, r0, sp, asr #2
    10d8:	20200000 	eorcs	r0, r0, r0
    10dc:	00053009 	andeq	r3, r5, r9
    10e0:	15120300 	ldrne	r0, [r2, #-768]	; 0xfffffd00
    10e4:	0000006c 	andeq	r0, r0, ip, rrx
    10e8:	06270836 			; <UNDEFINED> instruction: 0x06270836
    10ec:	44030000 	strmi	r0, [r3], #-0
    10f0:	00014d1a 	andeq	r4, r1, sl, lsl sp
    10f4:	21500000 	cmpcs	r0, r0
    10f8:	02660820 	rsbeq	r0, r6, #32, 16	; 0x200000
    10fc:	73030000 	movwvc	r0, #12288	; 0x3000
    1100:	00014d1a 	andeq	r4, r1, sl, lsl sp
    1104:	00b20000 	adcseq	r0, r2, r0
    1108:	05440820 	strbeq	r0, [r4, #-2080]	; 0xfffff7e0
    110c:	a6030000 	strge	r0, [r3], -r0
    1110:	00014d1a 	andeq	r4, r1, sl, lsl sp
    1114:	00b40000 	adcseq	r0, r4, r0
    1118:	0b6e0a20 	bleq	1b839a0 <_bss_end+0x1b77b3c>
    111c:	04050000 	streq	r0, [r5], #-0
    1120:	00000033 	andeq	r0, r0, r3, lsr r0
    1124:	0b0da803 	bleq	36b138 <_bss_end+0x35f2d4>
    1128:	00000bbb 			; <UNDEFINED> instruction: 0x00000bbb
    112c:	0b410b00 	bleq	1043d34 <_bss_end+0x1037ed0>
    1130:	0b010000 	bleq	41138 <_bss_end+0x352d4>
    1134:	00000fc7 	andeq	r0, r0, r7, asr #31
    1138:	0b0a0b02 	bleq	283d48 <_bss_end+0x277ee4>
    113c:	0b030000 	bleq	c1144 <_bss_end+0xb52e0>
    1140:	00000c33 	andeq	r0, r0, r3, lsr ip
    1144:	0a480b04 	beq	1203d5c <_bss_end+0x11f7ef8>
    1148:	0b050000 	bleq	141150 <_bss_end+0x1352ec>
    114c:	00000a34 	andeq	r0, r0, r4, lsr sl
    1150:	0b620b06 	bleq	1883d70 <_bss_end+0x1877f0c>
    1154:	0b070000 	bleq	1c115c <_bss_end+0x1b52f8>
    1158:	00000c01 	andeq	r0, r0, r1, lsl #24
    115c:	0c000008 	stceq	0, cr0, [r0], {8}
    1160:	0000008e 	andeq	r0, r0, lr, lsl #1
    1164:	f4070402 	vst3.8	{d0-d2}, [r7], r2
    1168:	0500001e 	streq	r0, [r0, #-30]	; 0xffffffe2
    116c:	00000146 	andeq	r0, r0, r6, asr #2
    1170:	00009e0c 	andeq	r9, r0, ip, lsl #28
    1174:	00ae0c00 	adceq	r0, lr, r0, lsl #24
    1178:	be0c0000 	cdplt	0, 0, cr0, cr12, cr0, {0}
    117c:	0c000000 	stceq	0, cr0, [r0], {-0}
    1180:	000000cb 	andeq	r0, r0, fp, asr #1
    1184:	0000db0c 	andeq	sp, r0, ip, lsl #22
    1188:	00eb0c00 	rsceq	r0, fp, r0, lsl #24
    118c:	c20d0000 	andgt	r0, sp, #0
    1190:	0700000a 	streq	r0, [r0, -sl]
    1194:	00003a01 	andeq	r3, r0, r1, lsl #20
    1198:	0c060400 	cfstrseq	mvf0, [r6], {-0}
    119c:	00000195 	muleq	r0, r5, r1
    11a0:	000aea0b 	andeq	lr, sl, fp, lsl #20
    11a4:	140b0000 	strne	r0, [fp], #-0
    11a8:	0100000b 	tsteq	r0, fp
    11ac:	000a9a0b 	andeq	r9, sl, fp, lsl #20
    11b0:	0e000200 	cdpeq	2, 0, cr0, cr0, cr0, {0}
    11b4:	00000bc0 	andeq	r0, r0, r0, asr #23
    11b8:	070d0408 	streq	r0, [sp, -r8, lsl #8]
    11bc:	0000028d 	andeq	r0, r0, sp, lsl #5
    11c0:	000b350f 	andeq	r3, fp, pc, lsl #10
    11c4:	20150400 	andscs	r0, r5, r0, lsl #8
    11c8:	0000028d 	andeq	r0, r0, sp, lsl #5
    11cc:	0c231000 	stceq	0, cr1, [r3], #-0
    11d0:	11040000 	mrsne	r0, (UNDEF: 4)
    11d4:	0002930f 	andeq	r9, r2, pc, lsl #6
    11d8:	c70f0100 	strgt	r0, [pc, -r0, lsl #2]
    11dc:	0400000b 	streq	r0, [r0], #-11
    11e0:	01af1918 			; <UNDEFINED> instruction: 0x01af1918
    11e4:	11040000 	mrsne	r0, (UNDEF: 4)
    11e8:	00000b3c 	andeq	r0, r0, ip, lsr fp
    11ec:	d1201b04 			; <UNDEFINED> instruction: 0xd1201b04
    11f0:	9a00000b 	bls	1224 <CPSR_IRQ_INHIBIT+0x11a4>
    11f4:	02000002 	andeq	r0, r0, #2
    11f8:	000001e2 	andeq	r0, r0, r2, ror #3
    11fc:	000001ed 	andeq	r0, r0, sp, ror #3
    1200:	0002a012 	andeq	sl, r2, r2, lsl r0
    1204:	00fb1300 	rscseq	r1, fp, r0, lsl #6
    1208:	11000000 	mrsne	r0, (UNDEF: 0)
    120c:	00000bc0 	andeq	r0, r0, r0, asr #23
    1210:	f2091e04 	vceq.f32	d1, d9, d4
    1214:	a000000b 	andge	r0, r0, fp
    1218:	01000002 	tsteq	r0, r2
    121c:	00000206 	andeq	r0, r0, r6, lsl #4
    1220:	00000211 	andeq	r0, r0, r1, lsl r2
    1224:	0002a012 	andeq	sl, r2, r2, lsl r0
    1228:	01461300 	mrseq	r1, SPSR_und
    122c:	14000000 	strne	r0, [r0], #-0
    1230:	00000ed0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    1234:	a80e2104 	stmdage	lr, {r2, r8, sp}
    1238:	0100000a 	tsteq	r0, sl
    123c:	00000226 	andeq	r0, r0, r6, lsr #4
    1240:	0000023b 	andeq	r0, r0, fp, lsr r2
    1244:	0002a012 	andeq	sl, r2, r2, lsl r0
    1248:	01af1300 			; <UNDEFINED> instruction: 0x01af1300
    124c:	71130000 	tstvc	r3, r0
    1250:	13000000 	movwne	r0, #0
    1254:	00000170 	andeq	r0, r0, r0, ror r1
    1258:	0f7e1400 	svceq	0x007e1400
    125c:	23040000 	movwcs	r0, #16384	; 0x4000
    1260:	000b780e 	andeq	r7, fp, lr, lsl #16
    1264:	02500100 	subseq	r0, r0, #0, 2
    1268:	02560000 	subseq	r0, r6, #0
    126c:	a0120000 	andsge	r0, r2, r0
    1270:	00000002 	andeq	r0, r0, r2
    1274:	000a3b14 	andeq	r3, sl, r4, lsl fp
    1278:	0e260400 	cdpeq	4, 2, cr0, cr6, cr0, {0}
    127c:	00000c3b 	andeq	r0, r0, fp, lsr ip
    1280:	00026b01 	andeq	r6, r2, r1, lsl #22
    1284:	00027100 	andeq	r7, r2, r0, lsl #2
    1288:	02a01200 	adceq	r1, r0, #0, 4
    128c:	15000000 	strne	r0, [r0, #-0]
    1290:	00000c0e 	andeq	r0, r0, lr, lsl #24
    1294:	a30e2804 	movwge	r2, #59396	; 0xe804
    1298:	ab000009 	blge	12c4 <CPSR_IRQ_INHIBIT+0x1244>
    129c:	01000002 	tsteq	r0, r2
    12a0:	00000286 	andeq	r0, r0, r6, lsl #5
    12a4:	0002a012 	andeq	sl, r2, r2, lsl r0
    12a8:	16000000 	strne	r0, [r0], -r0
    12ac:	00007d04 	andeq	r7, r0, r4, lsl #26
    12b0:	99041600 	stmdbls	r4, {r9, sl, ip}
    12b4:	17000002 	strne	r0, [r0, -r2]
    12b8:	007d0418 	rsbseq	r0, sp, r8, lsl r4
    12bc:	04160000 	ldreq	r0, [r6], #-0
    12c0:	00000195 	muleq	r0, r5, r1
    12c4:	0002a005 	andeq	sl, r2, r5
    12c8:	02010200 	andeq	r0, r1, #0, 4
    12cc:	00000332 	andeq	r0, r0, r2, lsr r3
    12d0:	00099c19 	andeq	r9, r9, r9, lsl ip
    12d4:	0f2b0400 	svceq	0x002b0400
    12d8:	00000195 	muleq	r0, r5, r1
    12dc:	0002b21a 	andeq	fp, r2, sl, lsl r2
    12e0:	08040100 	stmdaeq	r4, {r8}
    12e4:	ae340305 	cdpge	3, 3, cr0, cr4, cr5, {0}
    12e8:	aa1b0000 	bge	6c12f0 <_bss_end+0x6b548c>
    12ec:	0600000b 	streq	r0, [r0], -fp
    12f0:	9a080801 	bls	2032fc <_bss_end+0x1f7498>
    12f4:	1c000003 	stcne	0, cr0, [r0], {3}
    12f8:	00000a61 	andeq	r0, r0, r1, ror #20
    12fc:	3a0d0a01 	bcc	343b08 <_bss_end+0x337ca4>
    1300:	01000000 	mrseq	r0, (UNDEF: 0)
    1304:	1c000701 	stcne	7, cr0, [r0], {1}
    1308:	00000a8e 	andeq	r0, r0, lr, lsl #21
    130c:	3a0d0b01 	bcc	343f18 <_bss_end+0x3380b4>
    1310:	01000000 	mrseq	r0, (UNDEF: 0)
    1314:	1c000601 	stcne	6, cr0, [r0], {1}
    1318:	00000ae0 	andeq	r0, r0, r0, ror #21
    131c:	3a0d0c01 	bcc	344328 <_bss_end+0x3384c4>
    1320:	01000000 	mrseq	r0, (UNDEF: 0)
    1324:	1c000402 	cfstrsne	mvf0, [r0], {2}
    1328:	00000a6a 	andeq	r0, r0, sl, ror #20
    132c:	3a0d0d01 	bcc	344738 <_bss_end+0x3388d4>
    1330:	01000000 	mrseq	r0, (UNDEF: 0)
    1334:	1c000301 	stcne	3, cr0, [r0], {1}
    1338:	00000b47 	andeq	r0, r0, r7, asr #22
    133c:	3a0d0e01 	bcc	344b48 <_bss_end+0x338ce4>
    1340:	01000000 	mrseq	r0, (UNDEF: 0)
    1344:	1c000201 	sfmne	f0, 4, [r0], {1}
    1348:	00000a73 	andeq	r0, r0, r3, ror sl
    134c:	3a0d0f01 	bcc	344f58 <_bss_end+0x3390f4>
    1350:	01000000 	mrseq	r0, (UNDEF: 0)
    1354:	1c000101 	stfnes	f0, [r0], {1}
    1358:	00000b9c 	muleq	r0, ip, fp
    135c:	3a0d1001 	bcc	345368 <_bss_end+0x339504>
    1360:	01000000 	mrseq	r0, (UNDEF: 0)
    1364:	1c000001 	stcne	0, cr0, [r0], {1}
    1368:	00000b21 	andeq	r0, r0, r1, lsr #22
    136c:	3a0d1101 	bcc	345778 <_bss_end+0x339914>
    1370:	01000000 	mrseq	r0, (UNDEF: 0)
    1374:	1c010701 	stcne	7, cr0, [r1], {1}
    1378:	00000af6 	strdeq	r0, [r0], -r6
    137c:	3a0d1201 	bcc	345b88 <_bss_end+0x339d24>
    1380:	01000000 	mrseq	r0, (UNDEF: 0)
    1384:	1d010601 	stcne	6, cr0, [r1, #-4]
    1388:	00000a7c 	andeq	r0, r0, ip, ror sl
    138c:	4d0e1301 	stcmi	3, cr1, [lr, #-4]
    1390:	02000000 	andeq	r0, r0, #0
    1394:	1d007c0a 	stcne	12, cr7, [r0, #-40]	; 0xffffffd8
    1398:	00000ad3 	ldrdeq	r0, [r0], -r3
    139c:	4d0e1401 	cfstrsmi	mvf1, [lr, #-4]
    13a0:	02000000 	andeq	r0, r0, #0
    13a4:	1c027c10 	stcne	12, cr7, [r2], {16}
    13a8:	00000a85 	andeq	r0, r0, r5, lsl #21
    13ac:	4d0e1501 	cfstr32mi	mvfx1, [lr, #-4]
    13b0:	02000000 	andeq	r0, r0, #0
    13b4:	0004020a 	andeq	r0, r4, sl, lsl #4
    13b8:	0002cc06 	andeq	ip, r2, r6, lsl #24
    13bc:	098d1e00 	stmibeq	sp, {r9, sl, fp, ip}
    13c0:	91580000 	cmpls	r8, r0
    13c4:	001c0000 	andseq	r0, ip, r0
    13c8:	9c010000 	stcls	0, cr0, [r1], {-0}
    13cc:	00054f1f 	andeq	r4, r5, pc, lsl pc
    13d0:	00910400 	addseq	r0, r1, r0, lsl #8
    13d4:	00005400 	andeq	r5, r0, r0, lsl #8
    13d8:	e09c0100 	adds	r0, ip, r0, lsl #2
    13dc:	20000003 	andcs	r0, r0, r3
    13e0:	00000432 	andeq	r0, r0, r2, lsr r4
    13e4:	33014901 	movwcc	r4, #6401	; 0x1901
    13e8:	02000000 	andeq	r0, r0, #0
    13ec:	ed207491 	cfstrs	mvf7, [r0, #-580]!	; 0xfffffdbc
    13f0:	01000005 	tsteq	r0, r5
    13f4:	00330149 	eorseq	r0, r3, r9, asr #2
    13f8:	91020000 	mrsls	r0, (UNDEF: 2)
    13fc:	71210070 			; <UNDEFINED> instruction: 0x71210070
    1400:	01000002 	tsteq	r0, r2
    1404:	03fa0646 	mvnseq	r0, #73400320	; 0x4600000
    1408:	90c40000 	sbcls	r0, r4, r0
    140c:	00400000 	subeq	r0, r0, r0
    1410:	9c010000 	stcls	0, cr0, [r1], {-0}
    1414:	00000407 	andeq	r0, r0, r7, lsl #8
    1418:	00058222 	andeq	r8, r5, r2, lsr #4
    141c:	0002a600 	andeq	sl, r2, r0, lsl #12
    1420:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1424:	02562100 	subseq	r2, r6, #0, 2
    1428:	3e010000 	cdpcc	0, 0, cr0, cr1, cr0, {0}
    142c:	00042106 	andeq	r2, r4, r6, lsl #2
    1430:	00907400 	addseq	r7, r0, r0, lsl #8
    1434:	00005000 	andeq	r5, r0, r0
    1438:	2e9c0100 	fmlcse	f0, f4, f0
    143c:	22000004 	andcs	r0, r0, #4
    1440:	00000582 	andeq	r0, r0, r2, lsl #11
    1444:	000002a6 	andeq	r0, r0, r6, lsr #5
    1448:	00749102 	rsbseq	r9, r4, r2, lsl #2
    144c:	00023b21 	andeq	r3, r2, r1, lsr #22
    1450:	06360100 	ldrteq	r0, [r6], -r0, lsl #2
    1454:	00000448 	andeq	r0, r0, r8, asr #8
    1458:	00009028 	andeq	r9, r0, r8, lsr #32
    145c:	0000004c 	andeq	r0, r0, ip, asr #32
    1460:	04649c01 	strbteq	r9, [r4], #-3073	; 0xfffff3ff
    1464:	82220000 	eorhi	r0, r2, #0
    1468:	a6000005 	strge	r0, [r0], -r5
    146c:	02000002 	andeq	r0, r0, #2
    1470:	72236c91 	eorvc	r6, r3, #37120	; 0x9100
    1474:	01006765 	tsteq	r0, r5, ror #14
    1478:	04642038 	strbteq	r2, [r4], #-56	; 0xffffffc8
    147c:	91020000 	mrsls	r0, (UNDEF: 2)
    1480:	04180074 	ldreq	r0, [r8], #-116	; 0xffffff8c
    1484:	0000039a 	muleq	r0, sl, r3
    1488:	00021121 	andeq	r1, r2, r1, lsr #2
    148c:	06250100 	strteq	r0, [r5], -r0, lsl #2
    1490:	00000484 	andeq	r0, r0, r4, lsl #9
    1494:	00008f5c 	andeq	r8, r0, ip, asr pc
    1498:	000000cc 	andeq	r0, r0, ip, asr #1
    149c:	04cd9c01 	strbeq	r9, [sp], #3073	; 0xc01
    14a0:	82220000 	eorhi	r0, r2, #0
    14a4:	a6000005 	strge	r0, [r0], -r5
    14a8:	02000002 	andeq	r0, r0, #2
    14ac:	56206491 			; <UNDEFINED> instruction: 0x56206491
    14b0:	0100000c 	tsteq	r0, ip
    14b4:	01af2525 			; <UNDEFINED> instruction: 0x01af2525
    14b8:	91020000 	mrsls	r0, (UNDEF: 2)
    14bc:	0a532060 	beq	14c9644 <_bss_end+0x14bd7e0>
    14c0:	25010000 	strcs	r0, [r1, #-0]
    14c4:	0000713c 	andeq	r7, r0, ip, lsr r1
    14c8:	5c910200 	lfmpl	f0, 4, [r1], {0}
    14cc:	000ae020 	andeq	lr, sl, r0, lsr #32
    14d0:	54250100 	strtpl	r0, [r5], #-256	; 0xffffff00
    14d4:	00000170 	andeq	r0, r0, r0, ror r1
    14d8:	235b9102 	cmpcs	fp, #-2147483648	; 0x80000000
    14dc:	00676572 	rsbeq	r6, r7, r2, ror r5
    14e0:	cc162901 			; <UNDEFINED> instruction: 0xcc162901
    14e4:	02000002 	andeq	r0, r0, #2
    14e8:	24006891 	strcs	r6, [r0], #-2193	; 0xfffff76f
    14ec:	000001c9 	andeq	r0, r0, r9, asr #3
    14f0:	e7182001 	ldr	r2, [r8, -r1]
    14f4:	24000004 	strcs	r0, [r0], #-4
    14f8:	3800008f 	stmdacc	r0, {r0, r1, r2, r3, r7}
    14fc:	01000000 	mrseq	r0, (UNDEF: 0)
    1500:	0005039c 	muleq	r5, ip, r3
    1504:	05822200 	streq	r2, [r2, #512]	; 0x200
    1508:	02a60000 	adceq	r0, r6, #0
    150c:	91020000 	mrsls	r0, (UNDEF: 2)
    1510:	65722574 	ldrbvs	r2, [r2, #-1396]!	; 0xfffffa8c
    1514:	20010067 	andcs	r0, r1, r7, rrx
    1518:	0000fb34 	andeq	pc, r0, r4, lsr fp	; <UNPREDICTABLE>
    151c:	70910200 	addsvc	r0, r1, r0, lsl #4
    1520:	01ed2600 	mvneq	r2, r0, lsl #12
    1524:	1a010000 	bne	4152c <_bss_end+0x356c8>
    1528:	00051401 	andeq	r1, r5, r1, lsl #8
    152c:	052a0000 	streq	r0, [sl, #-0]!
    1530:	82270000 	eorhi	r0, r7, #0
    1534:	a6000005 	strge	r0, [r0], -r5
    1538:	28000002 	stmdacs	r0, {r1}
    153c:	00000b8d 	andeq	r0, r0, sp, lsl #23
    1540:	461e1a01 	ldrmi	r1, [lr], -r1, lsl #20
    1544:	00000001 	andeq	r0, r0, r1
    1548:	00050329 	andeq	r0, r5, r9, lsr #6
    154c:	000a2500 	andeq	r2, sl, r0, lsl #10
    1550:	00054100 	andeq	r4, r5, r0, lsl #2
    1554:	008ee400 	addeq	lr, lr, r0, lsl #8
    1558:	00004000 	andeq	r4, r0, r0
    155c:	2a9c0100 	bcs	fe701964 <_bss_end+0xfe6f5b00>
    1560:	00000514 	andeq	r0, r0, r4, lsl r5
    1564:	2a749102 	bcs	1d25974 <_bss_end+0x1d19b10>
    1568:	0000051d 	andeq	r0, r0, sp, lsl r5
    156c:	00709102 	rsbseq	r9, r0, r2, lsl #2
    1570:	00069700 	andeq	r9, r6, r0, lsl #14
    1574:	88000400 	stmdahi	r0, {sl}
    1578:	04000008 	streq	r0, [r0], #-8
    157c:	00000001 	andeq	r0, r0, r1
    1580:	10000400 	andne	r0, r0, r0, lsl #8
    1584:	00b60000 	adcseq	r0, r6, r0
    1588:	91740000 	cmnls	r4, r0
    158c:	025c0000 	subseq	r0, ip, #0
    1590:	0a220000 	beq	881598 <_bss_end+0x875734>
    1594:	01020000 	mrseq	r0, (UNDEF: 2)
    1598:	0004a008 	andeq	sl, r4, r8
    159c:	05020200 	streq	r0, [r2, #-512]	; 0xfffffe00
    15a0:	00000280 	andeq	r0, r0, r0, lsl #5
    15a4:	69050403 	stmdbvs	r5, {r0, r1, sl}
    15a8:	0400746e 	streq	r7, [r0], #-1134	; 0xfffffb92
    15ac:	00000a59 	andeq	r0, r0, r9, asr sl
    15b0:	46070902 	strmi	r0, [r7], -r2, lsl #18
    15b4:	02000000 	andeq	r0, r0, #0
    15b8:	04970801 	ldreq	r0, [r7], #2049	; 0x801
    15bc:	02020000 	andeq	r0, r2, #0
    15c0:	00050207 	andeq	r0, r5, r7, lsl #4
    15c4:	03290400 			; <UNDEFINED> instruction: 0x03290400
    15c8:	0b020000 	bleq	815d0 <_bss_end+0x7576c>
    15cc:	00006507 	andeq	r6, r0, r7, lsl #10
    15d0:	00540500 	subseq	r0, r4, r0, lsl #10
    15d4:	04020000 	streq	r0, [r2], #-0
    15d8:	001ef907 	andseq	pc, lr, r7, lsl #18
    15dc:	00650500 	rsbeq	r0, r5, r0, lsl #10
    15e0:	65060000 	strvs	r0, [r6, #-0]
    15e4:	07000000 	streq	r0, [r0, -r0]
    15e8:	006c6168 	rsbeq	r6, ip, r8, ror #2
    15ec:	280b0703 	stmdacs	fp, {r0, r1, r8, r9, sl}
    15f0:	08000002 	stmdaeq	r0, {r1}
    15f4:	00000680 	andeq	r0, r0, r0, lsl #13
    15f8:	6c190903 			; <UNDEFINED> instruction: 0x6c190903
    15fc:	80000000 	andhi	r0, r0, r0
    1600:	080ee6b2 	stmdaeq	lr, {r1, r4, r5, r7, r9, sl, sp, lr, pc}
    1604:	000003e6 	andeq	r0, r0, r6, ror #7
    1608:	341a0c03 	ldrcc	r0, [sl], #-3075	; 0xfffff3fd
    160c:	00000002 	andeq	r0, r0, r2
    1610:	08200000 	stmdaeq	r0!, {}	; <UNPREDICTABLE>
    1614:	000004c4 	andeq	r0, r0, r4, asr #9
    1618:	341a0f03 	ldrcc	r0, [sl], #-3843	; 0xfffff0fd
    161c:	00000002 	andeq	r0, r0, r2
    1620:	09202000 	stmdbeq	r0!, {sp}
    1624:	00000530 	andeq	r0, r0, r0, lsr r5
    1628:	60151203 	andsvs	r1, r5, r3, lsl #4
    162c:	36000000 	strcc	r0, [r0], -r0
    1630:	00062708 	andeq	r2, r6, r8, lsl #14
    1634:	1a440300 	bne	110223c <_bss_end+0x10f63d8>
    1638:	00000234 	andeq	r0, r0, r4, lsr r2
    163c:	20215000 	eorcs	r5, r1, r0
    1640:	00026608 	andeq	r6, r2, r8, lsl #12
    1644:	1a730300 	bne	1cc224c <_bss_end+0x1cb63e8>
    1648:	00000234 	andeq	r0, r0, r4, lsr r2
    164c:	2000b200 	andcs	fp, r0, r0, lsl #4
    1650:	000d490a 	andeq	r4, sp, sl, lsl #18
    1654:	33040500 	movwcc	r0, #17664	; 0x4500
    1658:	03000000 	movweq	r0, #0
    165c:	012e0d75 			; <UNDEFINED> instruction: 0x012e0d75
    1660:	a40b0000 	strge	r0, [fp], #-0
    1664:	0000000e 	andeq	r0, r0, lr
    1668:	000e140b 	andeq	r1, lr, fp, lsl #8
    166c:	220b0100 	andcs	r0, fp, #0, 2
    1670:	0200000e 	andeq	r0, r0, #14
    1674:	000fc30b 	andeq	ip, pc, fp, lsl #6
    1678:	a90b0300 	stmdbge	fp, {r8, r9}
    167c:	0400000d 	streq	r0, [r0], #-13
    1680:	000db60b 	andeq	fp, sp, fp, lsl #12
    1684:	c60b0500 	strgt	r0, [fp], -r0, lsl #10
    1688:	0600000e 	streq	r0, [r0], -lr
    168c:	000d8d0b 	andeq	r8, sp, fp, lsl #26
    1690:	9b0b0700 	blls	2c3298 <_bss_end+0x2b7434>
    1694:	0800000d 	stmdaeq	r0, {r0, r2, r3}
    1698:	000f740b 	andeq	r7, pc, fp, lsl #8
    169c:	0a000900 	beq	3aa4 <CPSR_IRQ_INHIBIT+0x3a24>
    16a0:	00000e30 	andeq	r0, r0, r0, lsr lr
    16a4:	00330405 	eorseq	r0, r3, r5, lsl #8
    16a8:	83030000 	movwhi	r0, #12288	; 0x3000
    16ac:	0001710d 	andeq	r7, r1, sp, lsl #2
    16b0:	0bc10b00 	bleq	ff0442b8 <_bss_end+0xff038454>
    16b4:	0b000000 	bleq	16bc <CPSR_IRQ_INHIBIT+0x163c>
    16b8:	00000ed7 	ldrdeq	r0, [r0], -r7
    16bc:	0d620b01 	fstmdbxeq	r2!, {d16-d15}	;@ Deprecated
    16c0:	0b020000 	bleq	816c8 <_bss_end+0x75864>
    16c4:	00000d74 	andeq	r0, r0, r4, ror sp
    16c8:	10710b03 	rsbsne	r0, r1, r3, lsl #22
    16cc:	0b040000 	bleq	1016d4 <_bss_end+0xf5870>
    16d0:	00000eb6 			; <UNDEFINED> instruction: 0x00000eb6
    16d4:	0e7b0b05 	vaddeq.f64	d16, d11, d5
    16d8:	0b060000 	bleq	1816e0 <_bss_end+0x17587c>
    16dc:	00000e8c 	andeq	r0, r0, ip, lsl #29
    16e0:	3e0a0007 	cdpcc	0, 0, cr0, cr10, cr7, {0}
    16e4:	0500000d 	streq	r0, [r0, #-13]
    16e8:	00003304 	andeq	r3, r0, r4, lsl #6
    16ec:	0d8f0300 	stceq	3, cr0, [pc]	; 16f4 <CPSR_IRQ_INHIBIT+0x1674>
    16f0:	000001d2 	ldrdeq	r0, [r0], -r2
    16f4:	5855410c 	ldmdapl	r5, {r2, r3, r8, lr}^
    16f8:	a50b1d00 	strge	r1, [fp, #-3328]	; 0xfffff300
    16fc:	2b00000f 	blcs	1740 <CPSR_IRQ_INHIBIT+0x16c0>
    1700:	000e410b 	andeq	r4, lr, fp, lsl #2
    1704:	c00b2d00 	andgt	r2, fp, r0, lsl #26
    1708:	2e00000e 	cdpcs	0, 0, cr0, cr0, cr14, {0}
    170c:	494d530c 	stmdbmi	sp, {r2, r3, r8, r9, ip, lr}^
    1710:	6d0b3000 	stcvs	0, cr3, [fp, #-0]
    1714:	3100000d 	tstcc	r0, sp
    1718:	000e9d0b 	andeq	r9, lr, fp, lsl #26
    171c:	7f0b3200 	svcvc	0x000b3200
    1720:	3300000d 	movwcc	r0, #13
    1724:	000d860b 	andeq	r8, sp, fp, lsl #12
    1728:	490c3400 	stmdbmi	ip, {sl, ip, sp}
    172c:	35004332 	strcc	r4, [r0, #-818]	; 0xfffffcce
    1730:	4950530c 	ldmdbmi	r0, {r2, r3, r8, r9, ip, lr}^
    1734:	500c3600 	andpl	r3, ip, r0, lsl #12
    1738:	37004d43 	strcc	r4, [r0, -r3, asr #26]
    173c:	000e470b 	andeq	r4, lr, fp, lsl #14
    1740:	08003900 	stmdaeq	r0, {r8, fp, ip, sp}
    1744:	00000544 	andeq	r0, r0, r4, asr #10
    1748:	341aa603 	ldrcc	sl, [sl], #-1539	; 0xfffff9fd
    174c:	00000002 	andeq	r0, r0, r2
    1750:	0d2000b4 	stceq	0, cr0, [r0, #-720]!	; 0xfffffd30
    1754:	00000b6e 	andeq	r0, r0, lr, ror #22
    1758:	00330405 	eorseq	r0, r3, r5, lsl #8
    175c:	a8030000 	stmdage	r3, {}	; <UNPREDICTABLE>
    1760:	0bbb0b0d 	bleq	feec439c <_bss_end+0xfeeb8538>
    1764:	0b000000 	bleq	176c <CPSR_IRQ_INHIBIT+0x16ec>
    1768:	00000b41 	andeq	r0, r0, r1, asr #22
    176c:	0fc70b01 	svceq	0x00c70b01
    1770:	0b020000 	bleq	81778 <_bss_end+0x75914>
    1774:	00000b0a 	andeq	r0, r0, sl, lsl #22
    1778:	0c330b03 			; <UNDEFINED> instruction: 0x0c330b03
    177c:	0b040000 	bleq	101784 <_bss_end+0xf5920>
    1780:	00000a48 	andeq	r0, r0, r8, asr #20
    1784:	0a340b05 	beq	d043a0 <_bss_end+0xcf853c>
    1788:	0b060000 	bleq	181790 <_bss_end+0x17592c>
    178c:	00000b62 	andeq	r0, r0, r2, ror #22
    1790:	0c010b07 			; <UNDEFINED> instruction: 0x0c010b07
    1794:	00080000 	andeq	r0, r8, r0
    1798:	00820e00 	addeq	r0, r2, r0, lsl #28
    179c:	04020000 	streq	r0, [r2], #-0
    17a0:	001ef407 	andseq	pc, lr, r7, lsl #8
    17a4:	022d0500 	eoreq	r0, sp, #0, 10
    17a8:	920e0000 	andls	r0, lr, #0
    17ac:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    17b0:	000000a2 	andeq	r0, r0, r2, lsr #1
    17b4:	0000b20e 	andeq	fp, r0, lr, lsl #4
    17b8:	00bf0e00 	adcseq	r0, pc, r0, lsl #28
    17bc:	cf0e0000 	svcgt	0x000e0000
    17c0:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    17c4:	000001d2 	ldrdeq	r0, [r0], -r2
    17c8:	000f360f 	andeq	r3, pc, pc, lsl #12
    17cc:	05040400 	streq	r0, [r4, #-1024]	; 0xfffffc00
    17d0:	00033607 	andeq	r3, r3, r7, lsl #12
    17d4:	0e041000 	cdpeq	0, 0, cr1, cr4, cr0, {0}
    17d8:	09040000 	stmdbeq	r4, {}	; <UNPREDICTABLE>
    17dc:	00033620 	andeq	r3, r3, r0, lsr #12
    17e0:	3c110000 	ldccc	0, cr0, [r1], {-0}
    17e4:	0400000b 	streq	r0, [r0], #-11
    17e8:	0dc3200c 	stcleq	0, cr2, [r3, #48]	; 0x30
    17ec:	033c0000 	teqeq	ip, #0
    17f0:	8a020000 	bhi	817f8 <_bss_end+0x75994>
    17f4:	95000002 	strls	r0, [r0, #-2]
    17f8:	12000002 	andne	r0, r0, #2
    17fc:	00000342 	andeq	r0, r0, r2, asr #6
    1800:	0000df13 	andeq	sp, r0, r3, lsl pc
    1804:	36110000 	ldrcc	r0, [r1], -r0
    1808:	0400000f 	streq	r0, [r0], #-15
    180c:	0f86090f 	svceq	0x0086090f
    1810:	03420000 	movteq	r0, #8192	; 0x2000
    1814:	ae010000 	cdpge	0, 0, cr0, cr1, cr0, {0}
    1818:	b9000002 	stmdblt	r0, {r1}
    181c:	12000002 	andne	r0, r0, #2
    1820:	00000342 	andeq	r0, r0, r2, asr #6
    1824:	00022d13 	andeq	r2, r2, r3, lsl sp
    1828:	58140000 	ldmdapl	r4, {}	; <UNPREDICTABLE>
    182c:	0400000e 	streq	r0, [r0], #-14
    1830:	0cf80e12 	ldcleq	14, cr0, [r8], #72	; 0x48
    1834:	ce010000 	cdpgt	0, 0, cr0, cr1, cr0, {0}
    1838:	d9000002 	stmdble	r0, {r1}
    183c:	12000002 	andne	r0, r0, #2
    1840:	00000342 	andeq	r0, r0, r2, asr #6
    1844:	00012e13 	andeq	r2, r1, r3, lsl lr
    1848:	69140000 	ldmdbvs	r4, {}	; <UNPREDICTABLE>
    184c:	0400000e 	streq	r0, [r0], #-14
    1850:	0cb10e14 	ldceq	14, cr0, [r1], #80	; 0x50
    1854:	ee010000 	cdp	0, 0, cr0, cr1, cr0, {0}
    1858:	f9000002 			; <UNDEFINED> instruction: 0xf9000002
    185c:	12000002 	andne	r0, r0, #2
    1860:	00000342 	andeq	r0, r0, r2, asr #6
    1864:	00012e13 	andeq	r2, r1, r3, lsl lr
    1868:	66140000 	ldrvs	r0, [r4], -r0
    186c:	04000010 	streq	r0, [r0], #-16
    1870:	0efc0e17 	mrceq	14, 7, r0, cr12, cr7, {0}
    1874:	0e010000 	cdpeq	0, 0, cr0, cr1, cr0, {0}
    1878:	19000003 	stmdbne	r0, {r0, r1}
    187c:	12000003 	andne	r0, r0, #3
    1880:	00000342 	andeq	r0, r0, r2, asr #6
    1884:	00017113 	andeq	r7, r1, r3, lsl r1
    1888:	4c150000 	ldcmi	0, cr0, [r5], {-0}
    188c:	0400000e 	streq	r0, [r0], #-14
    1890:	0c5f0e19 	mrrceq	14, 1, r0, pc, cr9	; <UNPREDICTABLE>
    1894:	2a010000 	bcs	4189c <_bss_end+0x35a38>
    1898:	12000003 	andne	r0, r0, #3
    189c:	00000342 	andeq	r0, r0, r2, asr #6
    18a0:	00017113 	andeq	r7, r1, r3, lsl r1
    18a4:	16000000 	strne	r0, [r0], -r0
    18a8:	00007104 	andeq	r7, r0, r4, lsl #2
    18ac:	71041700 	tstvc	r4, r0, lsl #14
    18b0:	16000000 	strne	r0, [r0], -r0
    18b4:	00025704 	andeq	r5, r2, r4, lsl #14
    18b8:	03420500 	movteq	r0, #9472	; 0x2500
    18bc:	ee180000 	cdp	0, 1, cr0, cr8, cr0, {0}
    18c0:	0400000e 	streq	r0, [r0], #-14
    18c4:	02571e1c 	subseq	r1, r7, #28, 28	; 0x1c0
    18c8:	c20a0000 	andgt	r0, sl, #0
    18cc:	0700000a 	streq	r0, [r0, -sl]
    18d0:	00003a01 	andeq	r3, r0, r1, lsl #20
    18d4:	0c060500 	cfstr32eq	mvfx0, [r6], {-0}
    18d8:	0000037e 	andeq	r0, r0, lr, ror r3
    18dc:	000aea0b 	andeq	lr, sl, fp, lsl #20
    18e0:	140b0000 	strne	r0, [fp], #-0
    18e4:	0100000b 	tsteq	r0, fp
    18e8:	000a9a0b 	andeq	r9, sl, fp, lsl #20
    18ec:	0f000200 	svceq	0x00000200
    18f0:	00000bc0 	andeq	r0, r0, r0, asr #23
    18f4:	070d0508 	streq	r0, [sp, -r8, lsl #10]
    18f8:	00000476 	andeq	r0, r0, r6, ror r4
    18fc:	000b3510 	andeq	r3, fp, r0, lsl r5
    1900:	20150500 	andscs	r0, r5, r0, lsl #10
    1904:	00000336 	andeq	r0, r0, r6, lsr r3
    1908:	0c231900 			; <UNDEFINED> instruction: 0x0c231900
    190c:	11050000 	mrsne	r0, (UNDEF: 5)
    1910:	0004760f 	andeq	r7, r4, pc, lsl #12
    1914:	c7100100 	ldrgt	r0, [r0, -r0, lsl #2]
    1918:	0500000b 	streq	r0, [r0, #-11]
    191c:	03981918 	orrseq	r1, r8, #24, 18	; 0x60000
    1920:	11040000 	mrsne	r0, (UNDEF: 4)
    1924:	00000b3c 	andeq	r0, r0, ip, lsr fp
    1928:	d1201b05 			; <UNDEFINED> instruction: 0xd1201b05
    192c:	3c00000b 	stccc	0, cr0, [r0], {11}
    1930:	02000003 	andeq	r0, r0, #3
    1934:	000003cb 	andeq	r0, r0, fp, asr #7
    1938:	000003d6 	ldrdeq	r0, [r0], -r6
    193c:	00047d12 	andeq	r7, r4, r2, lsl sp
    1940:	01e21300 	mvneq	r1, r0, lsl #6
    1944:	11000000 	mrsne	r0, (UNDEF: 0)
    1948:	00000bc0 	andeq	r0, r0, r0, asr #23
    194c:	f2091e05 	vceq.f32	d1, d9, d5
    1950:	7d00000b 	stcvc	0, cr0, [r0, #-44]	; 0xffffffd4
    1954:	01000004 	tsteq	r0, r4
    1958:	000003ef 	andeq	r0, r0, pc, ror #7
    195c:	000003fa 	strdeq	r0, [r0], -sl
    1960:	00047d12 	andeq	r7, r4, r2, lsl sp
    1964:	022d1300 	eoreq	r1, sp, #0, 6
    1968:	14000000 	strne	r0, [r0], #-0
    196c:	00000ed0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    1970:	a80e2105 	stmdage	lr, {r0, r2, r8, sp}
    1974:	0100000a 	tsteq	r0, sl
    1978:	0000040f 	andeq	r0, r0, pc, lsl #8
    197c:	00000424 	andeq	r0, r0, r4, lsr #8
    1980:	00047d12 	andeq	r7, r4, r2, lsl sp
    1984:	03981300 	orrseq	r1, r8, #0, 6
    1988:	65130000 	ldrvs	r0, [r3, #-0]
    198c:	13000000 	movwne	r0, #0
    1990:	00000359 	andeq	r0, r0, r9, asr r3
    1994:	0f7e1400 	svceq	0x007e1400
    1998:	23050000 	movwcs	r0, #20480	; 0x5000
    199c:	000b780e 	andeq	r7, fp, lr, lsl #16
    19a0:	04390100 	ldrteq	r0, [r9], #-256	; 0xffffff00
    19a4:	043f0000 	ldrteq	r0, [pc], #-0	; 19ac <CPSR_IRQ_INHIBIT+0x192c>
    19a8:	7d120000 	ldcvc	0, cr0, [r2, #-0]
    19ac:	00000004 	andeq	r0, r0, r4
    19b0:	000a3b14 	andeq	r3, sl, r4, lsl fp
    19b4:	0e260500 	cfsh64eq	mvdx0, mvdx6, #0
    19b8:	00000c3b 	andeq	r0, r0, fp, lsr ip
    19bc:	00045401 	andeq	r5, r4, r1, lsl #8
    19c0:	00045a00 	andeq	r5, r4, r0, lsl #20
    19c4:	047d1200 	ldrbteq	r1, [sp], #-512	; 0xfffffe00
    19c8:	1a000000 	bne	19d0 <CPSR_IRQ_INHIBIT+0x1950>
    19cc:	00000c0e 	andeq	r0, r0, lr, lsl #24
    19d0:	a30e2805 	movwge	r2, #59397	; 0xe805
    19d4:	83000009 	movwhi	r0, #9
    19d8:	01000004 	tsteq	r0, r4
    19dc:	0000046f 	andeq	r0, r0, pc, ror #8
    19e0:	00047d12 	andeq	r7, r4, r2, lsl sp
    19e4:	16000000 	strne	r0, [r0], -r0
    19e8:	00047c04 	andeq	r7, r4, r4, lsl #24
    19ec:	04161b00 	ldreq	r1, [r6], #-2816	; 0xfffff500
    19f0:	0000037e 	andeq	r0, r0, lr, ror r3
    19f4:	32020102 	andcc	r0, r2, #-2147483648	; 0x80000000
    19f8:	18000003 	stmdane	r0, {r0, r1}
    19fc:	0000099c 	muleq	r0, ip, r9
    1a00:	7e0f2b05 	vmlavc.f64	d2, d15, d5
    1a04:	1c000003 	stcne	0, cr0, [r0], {3}
    1a08:	0000034d 	andeq	r0, r0, sp, asr #6
    1a0c:	05170701 	ldreq	r0, [r7, #-1793]	; 0xfffff8ff
    1a10:	00ae3c03 	adceq	r3, lr, r3, lsl #24
    1a14:	0edf1d00 	cdpeq	13, 13, cr1, cr15, cr0, {0}
    1a18:	93b40000 			; <UNDEFINED> instruction: 0x93b40000
    1a1c:	001c0000 	andseq	r0, ip, r0
    1a20:	9c010000 	stcls	0, cr0, [r1], {-0}
    1a24:	00054f1e 	andeq	r4, r5, lr, lsl pc
    1a28:	00936000 	addseq	r6, r3, r0
    1a2c:	00005400 	andeq	r5, r0, r0, lsl #8
    1a30:	e59c0100 	ldr	r0, [ip, #256]	; 0x100
    1a34:	1f000004 	svcne	0x00000004
    1a38:	00000432 	andeq	r0, r0, r2, lsr r4
    1a3c:	33014201 	movwcc	r4, #4609	; 0x1201
    1a40:	02000000 	andeq	r0, r0, #0
    1a44:	ed1f7491 	cfldrs	mvf7, [pc, #-580]	; 1808 <CPSR_IRQ_INHIBIT+0x1788>
    1a48:	01000005 	tsteq	r0, r5
    1a4c:	00330142 	eorseq	r0, r3, r2, asr #2
    1a50:	91020000 	mrsls	r0, (UNDEF: 2)
    1a54:	19200070 	stmdbne	r0!, {r4, r5, r6}
    1a58:	01000003 	tsteq	r0, r3
    1a5c:	04ff063d 	ldrbteq	r0, [pc], #1597	; 1a64 <CPSR_IRQ_INHIBIT+0x19e4>
    1a60:	93100000 	tstls	r0, #0
    1a64:	00500000 	subseq	r0, r0, r0
    1a68:	9c010000 	stcls	0, cr0, [r1], {-0}
    1a6c:	0000052a 	andeq	r0, r0, sl, lsr #10
    1a70:	00058221 	andeq	r8, r5, r1, lsr #4
    1a74:	00034800 	andeq	r4, r3, r0, lsl #16
    1a78:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    1a7c:	000fb81f 	andeq	fp, pc, pc, lsl r8	; <UNPREDICTABLE>
    1a80:	393d0100 	ldmdbcc	sp!, {r8}
    1a84:	00000171 	andeq	r0, r0, r1, ror r1
    1a88:	22609102 	rsbcs	r9, r0, #-2147483648	; 0x80000000
    1a8c:	00000f6b 	andeq	r0, r0, fp, ror #30
    1a90:	6c183f01 	ldcvs	15, cr3, [r8], {1}
    1a94:	02000000 	andeq	r0, r0, #0
    1a98:	20006c91 	mulcs	r0, r1, ip
    1a9c:	000002f9 	strdeq	r0, [r0], -r9
    1aa0:	44063601 	strmi	r3, [r6], #-1537	; 0xfffff9ff
    1aa4:	c0000005 	andgt	r0, r0, r5
    1aa8:	50000092 	mulpl	r0, r2, r0
    1aac:	01000000 	mrseq	r0, (UNDEF: 0)
    1ab0:	00056f9c 	muleq	r5, ip, pc	; <UNPREDICTABLE>
    1ab4:	05822100 	streq	r2, [r2, #256]	; 0x100
    1ab8:	03480000 	movteq	r0, #32768	; 0x8000
    1abc:	91020000 	mrsls	r0, (UNDEF: 2)
    1ac0:	0fb81f64 	svceq	0x00b81f64
    1ac4:	36010000 	strcc	r0, [r1], -r0
    1ac8:	00017138 	andeq	r7, r1, r8, lsr r1
    1acc:	60910200 	addsvs	r0, r1, r0, lsl #4
    1ad0:	000f6b22 	andeq	r6, pc, r2, lsr #22
    1ad4:	18380100 	ldmdane	r8!, {r8}
    1ad8:	0000006c 	andeq	r0, r0, ip, rrx
    1adc:	006c9102 	rsbeq	r9, ip, r2, lsl #2
    1ae0:	0002d920 	andeq	sp, r2, r0, lsr #18
    1ae4:	06310100 	ldrteq	r0, [r1], -r0, lsl #2
    1ae8:	00000589 	andeq	r0, r0, r9, lsl #11
    1aec:	0000927c 	andeq	r9, r0, ip, ror r2
    1af0:	00000044 	andeq	r0, r0, r4, asr #32
    1af4:	05a59c01 	streq	r9, [r5, #3073]!	; 0xc01
    1af8:	82210000 	eorhi	r0, r1, #0
    1afc:	48000005 	stmdami	r0, {r0, r2}
    1b00:	02000003 	andeq	r0, r0, #3
    1b04:	b81f6c91 	ldmdalt	pc, {r0, r4, r7, sl, fp, sp, lr}	; <UNPREDICTABLE>
    1b08:	0100000f 	tsteq	r0, pc
    1b0c:	012e4531 			; <UNDEFINED> instruction: 0x012e4531
    1b10:	91020000 	mrsls	r0, (UNDEF: 2)
    1b14:	b9200068 	stmdblt	r0!, {r3, r5, r6}
    1b18:	01000002 	tsteq	r0, r2
    1b1c:	05bf062c 	ldreq	r0, [pc, #1580]!	; 2150 <CPSR_IRQ_INHIBIT+0x20d0>
    1b20:	92380000 	eorsls	r0, r8, #0
    1b24:	00440000 	subeq	r0, r4, r0
    1b28:	9c010000 	stcls	0, cr0, [r1], {-0}
    1b2c:	000005db 	ldrdeq	r0, [r0], -fp
    1b30:	00058221 	andeq	r8, r5, r1, lsr #4
    1b34:	00034800 	andeq	r4, r3, r0, lsl #16
    1b38:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1b3c:	000fb81f 	andeq	fp, pc, pc, lsl r8	; <UNPREDICTABLE>
    1b40:	442c0100 	strtmi	r0, [ip], #-256	; 0xffffff00
    1b44:	0000012e 	andeq	r0, r0, lr, lsr #2
    1b48:	00689102 	rsbeq	r9, r8, r2, lsl #2
    1b4c:	00027123 	andeq	r7, r2, r3, lsr #2
    1b50:	18270100 	stmdane	r7!, {r8}
    1b54:	000005f5 	strdeq	r0, [r0], -r5
    1b58:	00009200 	andeq	r9, r0, r0, lsl #4
    1b5c:	00000038 	andeq	r0, r0, r8, lsr r0
    1b60:	06119c01 	ldreq	r9, [r1], -r1, lsl #24
    1b64:	82210000 	eorhi	r0, r1, #0
    1b68:	48000005 	stmdami	r0, {r0, r2}
    1b6c:	02000003 	andeq	r0, r0, #3
    1b70:	72247491 	eorvc	r7, r4, #-1862270976	; 0x91000000
    1b74:	01006765 	tsteq	r0, r5, ror #14
    1b78:	00df5227 	sbcseq	r5, pc, r7, lsr #4
    1b7c:	91020000 	mrsls	r0, (UNDEF: 2)
    1b80:	95250070 	strls	r0, [r5, #-112]!	; 0xffffff90
    1b84:	01000002 	tsteq	r0, r2
    1b88:	06220121 	strteq	r0, [r2], -r1, lsr #2
    1b8c:	38000000 	stmdacc	r0, {}	; <UNPREDICTABLE>
    1b90:	26000006 	strcs	r0, [r0], -r6
    1b94:	00000582 	andeq	r0, r0, r2, lsl #11
    1b98:	00000348 	andeq	r0, r0, r8, asr #6
    1b9c:	000b9727 	andeq	r9, fp, r7, lsr #14
    1ba0:	3c210100 	stfccs	f0, [r1], #-0
    1ba4:	0000022d 	andeq	r0, r0, sp, lsr #4
    1ba8:	06112800 	ldreq	r2, [r1], -r0, lsl #16
    1bac:	0f4c0000 	svceq	0x004c0000
    1bb0:	06530000 	ldrbeq	r0, [r3], -r0
    1bb4:	91cc0000 	bicls	r0, ip, r0
    1bb8:	00340000 	eorseq	r0, r4, r0
    1bbc:	9c010000 	stcls	0, cr0, [r1], {-0}
    1bc0:	00000664 	andeq	r0, r0, r4, ror #12
    1bc4:	00062229 	andeq	r2, r6, r9, lsr #4
    1bc8:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1bcc:	00062b29 	andeq	r2, r6, r9, lsr #22
    1bd0:	70910200 	addsvc	r0, r1, r0, lsl #4
    1bd4:	0c9a2a00 	vldmiaeq	sl, {s4-s3}
    1bd8:	1a010000 	bne	41be0 <_bss_end+0x35d7c>
    1bdc:	0091bc33 	addseq	fp, r1, r3, lsr ip
    1be0:	00001000 	andeq	r1, r0, r0
    1be4:	2b9c0100 	blcs	fe701fec <_bss_end+0xfe6f6188>
    1be8:	00000fcf 	andeq	r0, r0, pc, asr #31
    1bec:	8c111001 	ldchi	0, cr1, [r1], {1}
    1bf0:	30000091 	mulcc	r0, r1, r0
    1bf4:	01000000 	mrseq	r0, (UNDEF: 0)
    1bf8:	0fe52a9c 	svceq	0x00e52a9c
    1bfc:	0b010000 	bleq	41c04 <_bss_end+0x35da0>
    1c00:	00917433 	addseq	r7, r1, r3, lsr r4
    1c04:	00001800 	andeq	r1, r0, r0, lsl #16
    1c08:	009c0100 	addseq	r0, ip, r0, lsl #2
    1c0c:	00000dcd 	andeq	r0, r0, sp, asr #27
    1c10:	0b430004 	bleq	10c1c28 <_bss_end+0x10b5dc4>
    1c14:	01040000 	mrseq	r0, (UNDEF: 4)
    1c18:	00000000 	andeq	r0, r0, r0
    1c1c:	0013d304 	andseq	sp, r3, r4, lsl #6
    1c20:	0000b600 	andeq	fp, r0, r0, lsl #12
    1c24:	0093d000 	addseq	sp, r3, r0
    1c28:	00039800 	andeq	r9, r3, r0, lsl #16
    1c2c:	000c9500 	andeq	r9, ip, r0, lsl #10
    1c30:	08010200 	stmdaeq	r1, {r9}
    1c34:	000004a0 	andeq	r0, r0, r0, lsr #9
    1c38:	00002503 	andeq	r2, r0, r3, lsl #10
    1c3c:	05020200 	streq	r0, [r2, #-512]	; 0xfffffe00
    1c40:	00000280 	andeq	r0, r0, r0, lsl #5
    1c44:	69050404 	stmdbvs	r5, {r2, sl}
    1c48:	0500746e 	streq	r7, [r0, #-1134]	; 0xfffffb92
    1c4c:	00000038 	andeq	r0, r0, r8, lsr r0
    1c50:	000a5906 	andeq	r5, sl, r6, lsl #18
    1c54:	07090200 	streq	r0, [r9, -r0, lsl #4]
    1c58:	00000050 	andeq	r0, r0, r0, asr r0
    1c5c:	97080102 	strls	r0, [r8, -r2, lsl #2]
    1c60:	05000004 	streq	r0, [r0, #-4]
    1c64:	00000050 	andeq	r0, r0, r0, asr r0
    1c68:	02070202 	andeq	r0, r7, #536870912	; 0x20000000
    1c6c:	06000005 	streq	r0, [r0], -r5
    1c70:	00000329 	andeq	r0, r0, r9, lsr #6
    1c74:	74070b02 	strvc	r0, [r7], #-2818	; 0xfffff4fe
    1c78:	03000000 	movweq	r0, #0
    1c7c:	00000063 	andeq	r0, r0, r3, rrx
    1c80:	f9070402 			; <UNDEFINED> instruction: 0xf9070402
    1c84:	0500001e 	streq	r0, [r0, #-30]	; 0xffffffe2
    1c88:	00000074 	andeq	r0, r0, r4, ror r0
    1c8c:	00007403 	andeq	r7, r0, r3, lsl #8
    1c90:	05b00700 	ldreq	r0, [r0, #1792]!	; 0x700
    1c94:	04070000 	streq	r0, [r7], #-0
    1c98:	00000074 	andeq	r0, r0, r4, ror r0
    1c9c:	ce0c0603 	cfmadd32gt	mvax0, mvfx0, mvfx12, mvfx3
    1ca0:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    1ca4:	000004be 			; <UNDEFINED> instruction: 0x000004be
    1ca8:	064e0800 	strbeq	r0, [lr], -r0, lsl #16
    1cac:	08010000 	stmdaeq	r1, {}	; <UNPREDICTABLE>
    1cb0:	0000069f 	muleq	r0, pc, r6	; <UNPREDICTABLE>
    1cb4:	06990802 	ldreq	r0, [r9], r2, lsl #16
    1cb8:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    1cbc:	00000674 	andeq	r0, r0, r4, ror r6
    1cc0:	067a0804 	ldrbteq	r0, [sl], -r4, lsl #16
    1cc4:	08050000 	stmdaeq	r5, {}	; <UNPREDICTABLE>
    1cc8:	000005bf 			; <UNDEFINED> instruction: 0x000005bf
    1ccc:	06930806 	ldreq	r0, [r3], r6, lsl #16
    1cd0:	08070000 	stmdaeq	r7, {}	; <UNPREDICTABLE>
    1cd4:	00000337 	andeq	r0, r0, r7, lsr r3
    1cd8:	61090008 	tstvs	r9, r8
    1cdc:	04000003 	streq	r0, [r0], #-3
    1ce0:	53071a03 	movwpl	r1, #31235	; 0x7a03
    1ce4:	0a000002 	beq	1cf4 <CPSR_IRQ_INHIBIT+0x1c74>
    1ce8:	000002fe 	strdeq	r0, [r0], -lr
    1cec:	5e201e03 	cdppl	14, 2, cr1, cr0, cr3, {0}
    1cf0:	00000002 	andeq	r0, r0, r2
    1cf4:	00051c0b 	andeq	r1, r5, fp, lsl #24
    1cf8:	08220300 	stmdaeq	r2!, {r8, r9}
    1cfc:	000002ce 	andeq	r0, r0, lr, asr #5
    1d00:	00000263 	andeq	r0, r0, r3, ror #4
    1d04:	00010102 	andeq	r0, r1, r2, lsl #2
    1d08:	00011600 	andeq	r1, r1, r0, lsl #12
    1d0c:	026f0c00 	rsbeq	r0, pc, #0, 24
    1d10:	630d0000 	movwvs	r0, #53248	; 0xd000
    1d14:	0d000000 	stceq	0, cr0, [r0, #-0]
    1d18:	00000275 	andeq	r0, r0, r5, ror r2
    1d1c:	0002750d 	andeq	r7, r2, sp, lsl #10
    1d20:	300b0000 	andcc	r0, fp, r0
    1d24:	03000006 	movweq	r0, #6
    1d28:	04680824 	strbteq	r0, [r8], #-2084	; 0xfffff7dc
    1d2c:	02630000 	rsbeq	r0, r3, #0
    1d30:	2f020000 	svccs	0x00020000
    1d34:	44000001 	strmi	r0, [r0], #-1
    1d38:	0c000001 	stceq	0, cr0, [r0], {1}
    1d3c:	0000026f 	andeq	r0, r0, pc, ror #4
    1d40:	0000630d 	andeq	r6, r0, sp, lsl #6
    1d44:	02750d00 	rsbseq	r0, r5, #0, 26
    1d48:	750d0000 	strvc	r0, [sp, #-0]
    1d4c:	00000002 	andeq	r0, r0, r2
    1d50:	00036f0b 	andeq	r6, r3, fp, lsl #30
    1d54:	08260300 	stmdaeq	r6!, {r8, r9}
    1d58:	000005f8 	strdeq	r0, [r0], -r8
    1d5c:	00000263 	andeq	r0, r0, r3, ror #4
    1d60:	00015d02 	andeq	r5, r1, r2, lsl #26
    1d64:	00017200 	andeq	r7, r1, r0, lsl #4
    1d68:	026f0c00 	rsbeq	r0, pc, #0, 24
    1d6c:	630d0000 	movwvs	r0, #53248	; 0xd000
    1d70:	0d000000 	stceq	0, cr0, [r0, #-0]
    1d74:	00000275 	andeq	r0, r0, r5, ror r2
    1d78:	0002750d 	andeq	r7, r2, sp, lsl #10
    1d7c:	f60b0000 			; <UNDEFINED> instruction: 0xf60b0000
    1d80:	03000003 	movweq	r0, #3
    1d84:	01f20828 	mvnseq	r0, r8, lsr #16
    1d88:	02630000 	rsbeq	r0, r3, #0
    1d8c:	8b020000 	blhi	81d94 <_bss_end+0x75f30>
    1d90:	a0000001 	andge	r0, r0, r1
    1d94:	0c000001 	stceq	0, cr0, [r0], {1}
    1d98:	0000026f 	andeq	r0, r0, pc, ror #4
    1d9c:	0000630d 	andeq	r6, r0, sp, lsl #6
    1da0:	02750d00 	rsbseq	r0, r5, #0, 26
    1da4:	750d0000 	strvc	r0, [sp, #-0]
    1da8:	00000002 	andeq	r0, r0, r2
    1dac:	0003610b 	andeq	r6, r3, fp, lsl #2
    1db0:	032b0300 			; <UNDEFINED> instruction: 0x032b0300
    1db4:	00000304 	andeq	r0, r0, r4, lsl #6
    1db8:	0000027b 	andeq	r0, r0, fp, ror r2
    1dbc:	0001b901 	andeq	fp, r1, r1, lsl #18
    1dc0:	0001c400 	andeq	ip, r1, r0, lsl #8
    1dc4:	027b0c00 	rsbseq	r0, fp, #0, 24
    1dc8:	740d0000 	strvc	r0, [sp], #-0
    1dcc:	00000000 	andeq	r0, r0, r0
    1dd0:	0005d30e 	andeq	sp, r5, lr, lsl #6
    1dd4:	082e0300 	stmdaeq	lr!, {r8, r9}
    1dd8:	00000587 	andeq	r0, r0, r7, lsl #11
    1ddc:	0001d901 	andeq	sp, r1, r1, lsl #18
    1de0:	0001e900 	andeq	lr, r1, r0, lsl #18
    1de4:	027b0c00 	rsbseq	r0, fp, #0, 24
    1de8:	630d0000 	movwvs	r0, #53248	; 0xd000
    1dec:	0d000000 	stceq	0, cr0, [r0, #-0]
    1df0:	00000085 	andeq	r0, r0, r5, lsl #1
    1df4:	034f0b00 	movteq	r0, #64256	; 0xfb00
    1df8:	30030000 	andcc	r0, r3, r0
    1dfc:	00040912 	andeq	r0, r4, r2, lsl r9
    1e00:	00008500 	andeq	r8, r0, r0, lsl #10
    1e04:	02020100 	andeq	r0, r2, #0, 2
    1e08:	020d0000 	andeq	r0, sp, #0
    1e0c:	6f0c0000 	svcvs	0x000c0000
    1e10:	0d000002 	stceq	0, cr0, [r0, #-8]
    1e14:	00000063 	andeq	r0, r0, r3, rrx
    1e18:	064a0e00 	strbeq	r0, [sl], -r0, lsl #28
    1e1c:	33030000 	movwcc	r0, #12288	; 0x3000
    1e20:	0002ac08 	andeq	sl, r2, r8, lsl #24
    1e24:	02220100 	eoreq	r0, r2, #0, 2
    1e28:	02320000 	eorseq	r0, r2, #0
    1e2c:	7b0c0000 	blvc	301e34 <_bss_end+0x2f5fd0>
    1e30:	0d000002 	stceq	0, cr0, [r0, #-8]
    1e34:	00000063 	andeq	r0, r0, r3, rrx
    1e38:	0002630d 	andeq	r6, r2, sp, lsl #6
    1e3c:	ba0f0000 	blt	3c1e44 <_bss_end+0x3b5fe0>
    1e40:	03000004 	movweq	r0, #4
    1e44:	06550836 			; <UNDEFINED> instruction: 0x06550836
    1e48:	02630000 	rsbeq	r0, r3, #0
    1e4c:	47010000 	strmi	r0, [r1, -r0]
    1e50:	0c000002 	stceq	0, cr0, [r0], {2}
    1e54:	0000027b 	andeq	r0, r0, fp, ror r2
    1e58:	0000630d 	andeq	r6, r0, sp, lsl #6
    1e5c:	03000000 	movweq	r0, #0
    1e60:	000000ce 	andeq	r0, r0, lr, asr #1
    1e64:	007b0410 	rsbseq	r0, fp, r0, lsl r4
    1e68:	58030000 	stmdapl	r3, {}	; <UNPREDICTABLE>
    1e6c:	02000002 	andeq	r0, r0, #2
    1e70:	03320201 	teqeq	r2, #268435456	; 0x10000000
    1e74:	63050000 	movwvs	r0, #20480	; 0x5000
    1e78:	10000002 	andne	r0, r0, r2
    1e7c:	00025304 	andeq	r5, r2, r4, lsl #6
    1e80:	63041100 	movwvs	r1, #16640	; 0x4100
    1e84:	10000000 	andne	r0, r0, r0
    1e88:	0000ce04 	andeq	ip, r0, r4, lsl #28
    1e8c:	04b41200 	ldrteq	r1, [r4], #512	; 0x200
    1e90:	3a030000 	bcc	c1e98 <_bss_end+0xb6034>
    1e94:	0000ce16 	andeq	ip, r0, r6, lsl lr
    1e98:	61681300 	cmnvs	r8, r0, lsl #6
    1e9c:	0704006c 	streq	r0, [r4, -ip, rrx]
    1ea0:	00043f0b 	andeq	r3, r4, fp, lsl #30
    1ea4:	06801400 	streq	r1, [r0], r0, lsl #8
    1ea8:	09040000 	stmdbeq	r4, {}	; <UNPREDICTABLE>
    1eac:	00008019 	andeq	r8, r0, r9, lsl r0
    1eb0:	e6b28000 	ldrt	r8, [r2], r0
    1eb4:	03e6140e 	mvneq	r1, #234881024	; 0xe000000
    1eb8:	0c040000 	stceq	0, cr0, [r4], {-0}
    1ebc:	00044b1a 	andeq	r4, r4, sl, lsl fp
    1ec0:	00000000 	andeq	r0, r0, r0
    1ec4:	04c41420 	strbeq	r1, [r4], #1056	; 0x420
    1ec8:	0f040000 	svceq	0x00040000
    1ecc:	00044b1a 	andeq	r4, r4, sl, lsl fp
    1ed0:	20000000 	andcs	r0, r0, r0
    1ed4:	05301520 	ldreq	r1, [r0, #-1312]!	; 0xfffffae0
    1ed8:	12040000 	andne	r0, r4, #0
    1edc:	00006f15 	andeq	r6, r0, r5, lsl pc
    1ee0:	27143600 	ldrcs	r3, [r4, -r0, lsl #12]
    1ee4:	04000006 	streq	r0, [r0], #-6
    1ee8:	044b1a44 	strbeq	r1, [fp], #-2628	; 0xfffff5bc
    1eec:	50000000 	andpl	r0, r0, r0
    1ef0:	66142021 	ldrvs	r2, [r4], -r1, lsr #32
    1ef4:	04000002 	streq	r0, [r0], #-2
    1ef8:	044b1a73 	strbeq	r1, [fp], #-2675	; 0xfffff58d
    1efc:	b2000000 	andlt	r0, r0, #0
    1f00:	49072000 	stmdbmi	r7, {sp}
    1f04:	0500000d 	streq	r0, [r0, #-13]
    1f08:	00003804 	andeq	r3, r0, r4, lsl #16
    1f0c:	0d750400 	cfldrdeq	mvd0, [r5, #-0]
    1f10:	00000345 	andeq	r0, r0, r5, asr #6
    1f14:	000ea408 	andeq	sl, lr, r8, lsl #8
    1f18:	14080000 	strne	r0, [r8], #-0
    1f1c:	0100000e 	tsteq	r0, lr
    1f20:	000e2208 	andeq	r2, lr, r8, lsl #4
    1f24:	c3080200 	movwgt	r0, #33280	; 0x8200
    1f28:	0300000f 	movweq	r0, #15
    1f2c:	000da908 	andeq	sl, sp, r8, lsl #18
    1f30:	b6080400 	strlt	r0, [r8], -r0, lsl #8
    1f34:	0500000d 	streq	r0, [r0, #-13]
    1f38:	000ec608 	andeq	ip, lr, r8, lsl #12
    1f3c:	8d080600 	stchi	6, cr0, [r8, #-0]
    1f40:	0700000d 	streq	r0, [r0, -sp]
    1f44:	000d9b08 	andeq	r9, sp, r8, lsl #22
    1f48:	74080800 	strvc	r0, [r8], #-2048	; 0xfffff800
    1f4c:	0900000f 	stmdbeq	r0, {r0, r1, r2, r3}
    1f50:	0e300700 	cdpeq	7, 3, cr0, cr0, cr0, {0}
    1f54:	04050000 	streq	r0, [r5], #-0
    1f58:	00000038 	andeq	r0, r0, r8, lsr r0
    1f5c:	880d8304 	stmdahi	sp, {r2, r8, r9, pc}
    1f60:	08000003 	stmdaeq	r0, {r0, r1}
    1f64:	00000bc1 	andeq	r0, r0, r1, asr #23
    1f68:	0ed70800 	cdpeq	8, 13, cr0, cr7, cr0, {0}
    1f6c:	08010000 	stmdaeq	r1, {}	; <UNPREDICTABLE>
    1f70:	00000d62 	andeq	r0, r0, r2, ror #26
    1f74:	0d740802 	ldcleq	8, cr0, [r4, #-8]!
    1f78:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    1f7c:	00001071 	andeq	r1, r0, r1, ror r0
    1f80:	0eb60804 	cdpeq	8, 11, cr0, cr6, cr4, {0}
    1f84:	08050000 	stmdaeq	r5, {}	; <UNPREDICTABLE>
    1f88:	00000e7b 	andeq	r0, r0, fp, ror lr
    1f8c:	0e8c0806 	cdpeq	8, 8, cr0, cr12, cr6, {0}
    1f90:	00070000 	andeq	r0, r7, r0
    1f94:	000d3e07 	andeq	r3, sp, r7, lsl #28
    1f98:	38040500 	stmdacc	r4, {r8, sl}
    1f9c:	04000000 	streq	r0, [r0], #-0
    1fa0:	03e90d8f 	mvneq	r0, #9152	; 0x23c0
    1fa4:	41160000 	tstmi	r6, r0
    1fa8:	1d005855 	stcne	8, cr5, [r0, #-340]	; 0xfffffeac
    1fac:	000fa508 	andeq	sl, pc, r8, lsl #10
    1fb0:	41082b00 	tstmi	r8, r0, lsl #22
    1fb4:	2d00000e 	stccs	0, cr0, [r0, #-56]	; 0xffffffc8
    1fb8:	000ec008 	andeq	ip, lr, r8
    1fbc:	53162e00 	tstpl	r6, #0, 28
    1fc0:	3000494d 	andcc	r4, r0, sp, asr #18
    1fc4:	000d6d08 	andeq	r6, sp, r8, lsl #26
    1fc8:	9d083100 	stflss	f3, [r8, #-0]
    1fcc:	3200000e 	andcc	r0, r0, #14
    1fd0:	000d7f08 	andeq	r7, sp, r8, lsl #30
    1fd4:	86083300 	strhi	r3, [r8], -r0, lsl #6
    1fd8:	3400000d 	strcc	r0, [r0], #-13
    1fdc:	43324916 	teqmi	r2, #360448	; 0x58000
    1fe0:	53163500 	tstpl	r6, #0, 10
    1fe4:	36004950 			; <UNDEFINED> instruction: 0x36004950
    1fe8:	4d435016 	stclmi	0, cr5, [r3, #-88]	; 0xffffffa8
    1fec:	47083700 	strmi	r3, [r8, -r0, lsl #14]
    1ff0:	3900000e 	stmdbcc	r0, {r1, r2, r3}
    1ff4:	05441400 	strbeq	r1, [r4, #-1024]	; 0xfffffc00
    1ff8:	a6040000 	strge	r0, [r4], -r0
    1ffc:	00044b1a 	andeq	r4, r4, sl, lsl fp
    2000:	00b40000 	adcseq	r0, r4, r0
    2004:	0b6e1720 	bleq	1b87c8c <_bss_end+0x1b7be28>
    2008:	04050000 	streq	r0, [r5], #-0
    200c:	00000038 	andeq	r0, r0, r8, lsr r0
    2010:	080da804 	stmdaeq	sp, {r2, fp, sp, pc}
    2014:	00000bbb 			; <UNDEFINED> instruction: 0x00000bbb
    2018:	0b410800 	bleq	1044020 <_bss_end+0x10381bc>
    201c:	08010000 	stmdaeq	r1, {}	; <UNPREDICTABLE>
    2020:	00000fc7 	andeq	r0, r0, r7, asr #31
    2024:	0b0a0802 	bleq	284034 <_bss_end+0x2781d0>
    2028:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    202c:	00000c33 	andeq	r0, r0, r3, lsr ip
    2030:	0a480804 	beq	1204048 <_bss_end+0x11f81e4>
    2034:	08050000 	stmdaeq	r5, {}	; <UNPREDICTABLE>
    2038:	00000a34 	andeq	r0, r0, r4, lsr sl
    203c:	0b620806 	bleq	188405c <_bss_end+0x18781f8>
    2040:	08070000 	stmdaeq	r7, {}	; <UNPREDICTABLE>
    2044:	00000c01 	andeq	r0, r0, r1, lsl #24
    2048:	18000008 	stmdane	r0, {r3}
    204c:	00000299 	muleq	r0, r9, r2
    2050:	f4070402 	vst3.8	{d0-d2}, [r7], r2
    2054:	0300001e 	movweq	r0, #30
    2058:	00000444 	andeq	r0, r0, r4, asr #8
    205c:	0002a918 	andeq	sl, r2, r8, lsl r9
    2060:	02b91800 	adcseq	r1, r9, #0, 16
    2064:	c9180000 	ldmdbgt	r8, {}	; <UNPREDICTABLE>
    2068:	18000002 	stmdane	r0, {r1}
    206c:	000002d6 	ldrdeq	r0, [r0], -r6
    2070:	0002e618 	andeq	lr, r2, r8, lsl r6
    2074:	03e91800 	mvneq	r1, #0, 16
    2078:	c2070000 	andgt	r0, r7, #0
    207c:	0700000a 	streq	r0, [r0, -sl]
    2080:	00004401 	andeq	r4, r0, r1, lsl #8
    2084:	0c060500 	cfstr32eq	mvfx0, [r6], {-0}
    2088:	00000493 	muleq	r0, r3, r4
    208c:	000aea08 	andeq	lr, sl, r8, lsl #20
    2090:	14080000 	strne	r0, [r8], #-0
    2094:	0100000b 	tsteq	r0, fp
    2098:	000a9a08 	andeq	r9, sl, r8, lsl #20
    209c:	09000200 	stmdbeq	r0, {r9}
    20a0:	00000bc0 	andeq	r0, r0, r0, asr #23
    20a4:	070d0508 	streq	r0, [sp, -r8, lsl #10]
    20a8:	0000058b 	andeq	r0, r0, fp, lsl #11
    20ac:	000b350a 	andeq	r3, fp, sl, lsl #10
    20b0:	20150500 	andscs	r0, r5, r0, lsl #10
    20b4:	00000258 	andeq	r0, r0, r8, asr r2
    20b8:	0c231900 			; <UNDEFINED> instruction: 0x0c231900
    20bc:	11050000 	mrsne	r0, (UNDEF: 5)
    20c0:	00058b0f 	andeq	r8, r5, pc, lsl #22
    20c4:	c70a0100 	strgt	r0, [sl, -r0, lsl #2]
    20c8:	0500000b 	streq	r0, [r0, #-11]
    20cc:	04ad1918 	strteq	r1, [sp], #2328	; 0x918
    20d0:	0b040000 	bleq	1020d8 <_bss_end+0xf6274>
    20d4:	00000b3c 	andeq	r0, r0, ip, lsr fp
    20d8:	d1201b05 			; <UNDEFINED> instruction: 0xd1201b05
    20dc:	9200000b 	andls	r0, r0, #11
    20e0:	02000005 	andeq	r0, r0, #5
    20e4:	000004e0 	andeq	r0, r0, r0, ror #9
    20e8:	000004eb 	andeq	r0, r0, fp, ror #9
    20ec:	0005980c 	andeq	r9, r5, ip, lsl #16
    20f0:	03f90d00 	mvnseq	r0, #0, 26
    20f4:	0b000000 	bleq	20fc <CPSR_IRQ_INHIBIT+0x207c>
    20f8:	00000bc0 	andeq	r0, r0, r0, asr #23
    20fc:	f2091e05 	vceq.f32	d1, d9, d5
    2100:	9800000b 	stmdals	r0, {r0, r1, r3}
    2104:	01000005 	tsteq	r0, r5
    2108:	00000504 	andeq	r0, r0, r4, lsl #10
    210c:	0000050f 	andeq	r0, r0, pc, lsl #10
    2110:	0005980c 	andeq	r9, r5, ip, lsl #16
    2114:	04440d00 	strbeq	r0, [r4], #-3328	; 0xfffff300
    2118:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    211c:	00000ed0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    2120:	a80e2105 	stmdage	lr, {r0, r2, r8, sp}
    2124:	0100000a 	tsteq	r0, sl
    2128:	00000524 	andeq	r0, r0, r4, lsr #10
    212c:	00000539 	andeq	r0, r0, r9, lsr r5
    2130:	0005980c 	andeq	r9, r5, ip, lsl #16
    2134:	04ad0d00 	strteq	r0, [sp], #3328	; 0xd00
    2138:	740d0000 	strvc	r0, [sp], #-0
    213c:	0d000000 	stceq	0, cr0, [r0, #-0]
    2140:	0000046e 	andeq	r0, r0, lr, ror #8
    2144:	0f7e0e00 	svceq	0x007e0e00
    2148:	23050000 	movwcs	r0, #20480	; 0x5000
    214c:	000b780e 	andeq	r7, fp, lr, lsl #16
    2150:	054e0100 	strbeq	r0, [lr, #-256]	; 0xffffff00
    2154:	05540000 	ldrbeq	r0, [r4, #-0]
    2158:	980c0000 	stmdals	ip, {}	; <UNPREDICTABLE>
    215c:	00000005 	andeq	r0, r0, r5
    2160:	000a3b0e 	andeq	r3, sl, lr, lsl #22
    2164:	0e260500 	cfsh64eq	mvdx0, mvdx6, #0
    2168:	00000c3b 	andeq	r0, r0, fp, lsr ip
    216c:	00056901 	andeq	r6, r5, r1, lsl #18
    2170:	00056f00 	andeq	r6, r5, r0, lsl #30
    2174:	05980c00 	ldreq	r0, [r8, #3072]	; 0xc00
    2178:	0f000000 	svceq	0x00000000
    217c:	00000c0e 	andeq	r0, r0, lr, lsl #24
    2180:	a30e2805 	movwge	r2, #59397	; 0xe805
    2184:	63000009 	movwvs	r0, #9
    2188:	01000002 	tsteq	r0, r2
    218c:	00000584 	andeq	r0, r0, r4, lsl #11
    2190:	0005980c 	andeq	r9, r5, ip, lsl #16
    2194:	10000000 	andne	r0, r0, r0
    2198:	00059104 	andeq	r9, r5, r4, lsl #2
    219c:	04111a00 	ldreq	r1, [r1], #-2560	; 0xfffff600
    21a0:	0000007b 	andeq	r0, r0, fp, ror r0
    21a4:	04930410 	ldreq	r0, [r3], #1040	; 0x410
    21a8:	9c120000 	ldcls	0, cr0, [r2], {-0}
    21ac:	05000009 	streq	r0, [r0, #-9]
    21b0:	04930f2b 	ldreq	r0, [r3], #3883	; 0xf2b
    21b4:	36090000 	strcc	r0, [r9], -r0
    21b8:	0400000f 	streq	r0, [r0], #-15
    21bc:	89070506 	stmdbhi	r7, {r1, r2, r8, sl}
    21c0:	0a000006 	beq	21e0 <CPSR_IRQ_INHIBIT+0x2160>
    21c4:	00000e04 	andeq	r0, r0, r4, lsl #28
    21c8:	58200906 	stmdapl	r0!, {r1, r2, r8, fp}
    21cc:	00000002 	andeq	r0, r0, r2
    21d0:	000b3c0b 	andeq	r3, fp, fp, lsl #24
    21d4:	200c0600 	andcs	r0, ip, r0, lsl #12
    21d8:	00000dc3 	andeq	r0, r0, r3, asr #27
    21dc:	00000592 	muleq	r0, r2, r5
    21e0:	0005dd02 	andeq	sp, r5, r2, lsl #26
    21e4:	0005e800 	andeq	lr, r5, r0, lsl #16
    21e8:	06890c00 	streq	r0, [r9], r0, lsl #24
    21ec:	f60d0000 			; <UNDEFINED> instruction: 0xf60d0000
    21f0:	00000002 	andeq	r0, r0, r2
    21f4:	000f360b 	andeq	r3, pc, fp, lsl #12
    21f8:	090f0600 	stmdbeq	pc, {r9, sl}	; <UNPREDICTABLE>
    21fc:	00000f86 	andeq	r0, r0, r6, lsl #31
    2200:	00000689 	andeq	r0, r0, r9, lsl #13
    2204:	00060101 	andeq	r0, r6, r1, lsl #2
    2208:	00060c00 	andeq	r0, r6, r0, lsl #24
    220c:	06890c00 	streq	r0, [r9], r0, lsl #24
    2210:	440d0000 	strmi	r0, [sp], #-0
    2214:	00000004 	andeq	r0, r0, r4
    2218:	000e580e 	andeq	r5, lr, lr, lsl #16
    221c:	0e120600 	cfmsub32eq	mvax0, mvfx0, mvfx2, mvfx0
    2220:	00000cf8 	strdeq	r0, [r0], -r8
    2224:	00062101 	andeq	r2, r6, r1, lsl #2
    2228:	00062c00 	andeq	r2, r6, r0, lsl #24
    222c:	06890c00 	streq	r0, [r9], r0, lsl #24
    2230:	450d0000 	strmi	r0, [sp, #-0]
    2234:	00000003 	andeq	r0, r0, r3
    2238:	000e690e 	andeq	r6, lr, lr, lsl #18
    223c:	0e140600 	cfmsub32eq	mvax0, mvfx0, mvfx4, mvfx0
    2240:	00000cb1 			; <UNDEFINED> instruction: 0x00000cb1
    2244:	00064101 	andeq	r4, r6, r1, lsl #2
    2248:	00064c00 	andeq	r4, r6, r0, lsl #24
    224c:	06890c00 	streq	r0, [r9], r0, lsl #24
    2250:	450d0000 	strmi	r0, [sp, #-0]
    2254:	00000003 	andeq	r0, r0, r3
    2258:	0010660e 	andseq	r6, r0, lr, lsl #12
    225c:	0e170600 	cfmsub32eq	mvax0, mvfx0, mvfx7, mvfx0
    2260:	00000efc 	strdeq	r0, [r0], -ip
    2264:	00066101 	andeq	r6, r6, r1, lsl #2
    2268:	00066c00 	andeq	r6, r6, r0, lsl #24
    226c:	06890c00 	streq	r0, [r9], r0, lsl #24
    2270:	880d0000 	stmdahi	sp, {}	; <UNPREDICTABLE>
    2274:	00000003 	andeq	r0, r0, r3
    2278:	000e4c1b 	andeq	r4, lr, fp, lsl ip
    227c:	0e190600 	cfmsub32eq	mvax0, mvfx0, mvfx9, mvfx0
    2280:	00000c5f 	andeq	r0, r0, pc, asr ip
    2284:	00067d01 	andeq	r7, r6, r1, lsl #26
    2288:	06890c00 	streq	r0, [r9], r0, lsl #24
    228c:	880d0000 	stmdahi	sp, {}	; <UNPREDICTABLE>
    2290:	00000003 	andeq	r0, r0, r3
    2294:	aa041000 	bge	10629c <_bss_end+0xfa438>
    2298:	12000005 	andne	r0, r0, #5
    229c:	00000eee 	andeq	r0, r0, lr, ror #29
    22a0:	aa1e1c06 	bge	7892c0 <_bss_end+0x77d45c>
    22a4:	09000005 	stmdbeq	r0, {r0, r2}
    22a8:	000007f8 	strdeq	r0, [r0], -r8
    22ac:	07030718 	smladeq	r3, r8, r7, r0
    22b0:	0000092c 	andeq	r0, r0, ip, lsr #18
    22b4:	0007541c 	andeq	r5, r7, ip, lsl r4
    22b8:	74040700 	strvc	r0, [r4], #-1792	; 0xfffff900
    22bc:	07000000 	streq	r0, [r0, -r0]
    22c0:	c8011006 	stmdagt	r1, {r1, r2, ip}
    22c4:	16000006 	strne	r0, [r0], -r6
    22c8:	00584548 	subseq	r4, r8, r8, asr #10
    22cc:	45441610 	strbmi	r1, [r4, #-1552]	; 0xfffff9f0
    22d0:	000a0043 	andeq	r0, sl, r3, asr #32
    22d4:	0006a803 	andeq	sl, r6, r3, lsl #16
    22d8:	07611d00 	strbeq	r1, [r1, -r0, lsl #26]!
    22dc:	07080000 	streq	r0, [r8, -r0]
    22e0:	06f10c27 	ldrbteq	r0, [r1], r7, lsr #24
    22e4:	791e0000 	ldmdbvc	lr, {}	; <UNPREDICTABLE>
    22e8:	16290700 	strtne	r0, [r9], -r0, lsl #14
    22ec:	00000074 	andeq	r0, r0, r4, ror r0
    22f0:	00781e00 	rsbseq	r1, r8, r0, lsl #28
    22f4:	74162a07 	ldrvc	r2, [r6], #-2567	; 0xfffff5f9
    22f8:	04000000 	streq	r0, [r0], #-0
    22fc:	08ec1f00 	stmiaeq	ip!, {r8, r9, sl, fp, ip}^
    2300:	0c070000 	stceq	0, cr0, [r7], {-0}
    2304:	0006c81b 	andeq	ip, r6, fp, lsl r8
    2308:	200a0100 	andcs	r0, sl, r0, lsl #2
    230c:	0000085f 	andeq	r0, r0, pc, asr r8
    2310:	32280d07 	eorcc	r0, r8, #448	; 0x1c0
    2314:	01000009 	tsteq	r0, r9
    2318:	0007f821 	andeq	pc, r7, r1, lsr #16
    231c:	0e100700 	cdpeq	7, 1, cr0, cr0, cr0, {0}
    2320:	000008d9 	ldrdeq	r0, [r0], -r9
    2324:	00000937 	andeq	r0, r0, r7, lsr r9
    2328:	00072501 	andeq	r2, r7, r1, lsl #10
    232c:	00073a00 	andeq	r3, r7, r0, lsl #20
    2330:	09370c00 	ldmdbeq	r7!, {sl, fp}
    2334:	740d0000 	strvc	r0, [sp], #-0
    2338:	0d000000 	stceq	0, cr0, [r0, #-0]
    233c:	00000074 	andeq	r0, r0, r4, ror r0
    2340:	0000740d 	andeq	r7, r0, sp, lsl #8
    2344:	0e0e0000 	cdpeq	0, 0, cr0, cr14, cr0, {0}
    2348:	0700000b 	streq	r0, [r0, -fp]
    234c:	07c10a12 	bfieq	r0, r2, (invalid: 20:1)
    2350:	4f010000 	svcmi	0x00010000
    2354:	55000007 	strpl	r0, [r0, #-7]
    2358:	0c000007 	stceq	0, cr0, [r0], {7}
    235c:	00000937 	andeq	r0, r0, r7, lsr r9
    2360:	08180b00 	ldmdaeq	r8, {r8, r9, fp}
    2364:	14070000 	strne	r0, [r7], #-0
    2368:	00087c0f 	andeq	r7, r8, pc, lsl #24
    236c:	00093d00 	andeq	r3, r9, r0, lsl #26
    2370:	076e0100 	strbeq	r0, [lr, -r0, lsl #2]!
    2374:	07790000 	ldrbeq	r0, [r9, -r0]!
    2378:	370c0000 	strcc	r0, [ip, -r0]
    237c:	0d000009 	stceq	0, cr0, [r0, #-36]	; 0xffffffdc
    2380:	00000025 	andeq	r0, r0, r5, lsr #32
    2384:	08180b00 	ldmdaeq	r8, {r8, r9, fp}
    2388:	15070000 	strne	r0, [r7, #-0]
    238c:	0008230f 	andeq	r2, r8, pc, lsl #6
    2390:	00093d00 	andeq	r3, r9, r0, lsl #26
    2394:	07920100 	ldreq	r0, [r2, r0, lsl #2]
    2398:	079d0000 	ldreq	r0, [sp, r0]
    239c:	370c0000 	strcc	r0, [ip, -r0]
    23a0:	0d000009 	stceq	0, cr0, [r0, #-36]	; 0xffffffdc
    23a4:	0000092c 	andeq	r0, r0, ip, lsr #18
    23a8:	08180b00 	ldmdaeq	r8, {r8, r9, fp}
    23ac:	16070000 	strne	r0, [r7], -r0
    23b0:	0007d60f 	andeq	sp, r7, pc, lsl #12
    23b4:	00093d00 	andeq	r3, r9, r0, lsl #26
    23b8:	07b60100 	ldreq	r0, [r6, r0, lsl #2]!
    23bc:	07c10000 	strbeq	r0, [r1, r0]
    23c0:	370c0000 	strcc	r0, [ip, -r0]
    23c4:	0d000009 	stceq	0, cr0, [r0, #-36]	; 0xffffffdc
    23c8:	000006a8 	andeq	r0, r0, r8, lsr #13
    23cc:	08180b00 	ldmdaeq	r8, {r8, r9, fp}
    23d0:	17070000 	strne	r0, [r7, -r0]
    23d4:	0008ab0f 	andeq	sl, r8, pc, lsl #22
    23d8:	00093d00 	andeq	r3, r9, r0, lsl #26
    23dc:	07da0100 	ldrbeq	r0, [sl, r0, lsl #2]
    23e0:	07e50000 	strbeq	r0, [r5, r0]!
    23e4:	370c0000 	strcc	r0, [ip, -r0]
    23e8:	0d000009 	stceq	0, cr0, [r0, #-36]	; 0xffffffdc
    23ec:	00000074 	andeq	r0, r0, r4, ror r0
    23f0:	08180b00 	ldmdaeq	r8, {r8, r9, fp}
    23f4:	18070000 	stmdane	r7, {}	; <UNPREDICTABLE>
    23f8:	00086b0f 	andeq	r6, r8, pc, lsl #22
    23fc:	00093d00 	andeq	r3, r9, r0, lsl #26
    2400:	07fe0100 	ldrbeq	r0, [lr, r0, lsl #2]!
    2404:	08090000 	stmdaeq	r9, {}	; <UNPREDICTABLE>
    2408:	370c0000 	strcc	r0, [ip, -r0]
    240c:	0d000009 	stceq	0, cr0, [r0, #-36]	; 0xffffffdc
    2410:	00000263 	andeq	r0, r0, r3, ror #4
    2414:	073f2200 	ldreq	r2, [pc, -r0, lsl #4]!
    2418:	1b070000 	blne	1c2420 <_bss_end+0x1b65bc>
    241c:	00070f11 	andeq	r0, r7, r1, lsl pc
    2420:	00081d00 	andeq	r1, r8, r0, lsl #26
    2424:	00082300 	andeq	r2, r8, r0, lsl #6
    2428:	09370c00 	ldmdbeq	r7!, {sl, fp}
    242c:	22000000 	andcs	r0, r0, #0
    2430:	00000732 	andeq	r0, r0, r2, lsr r7
    2434:	bc111c07 	ldclt	12, cr1, [r1], {7}
    2438:	37000008 	strcc	r0, [r0, -r8]
    243c:	3d000008 	stccc	0, cr0, [r0, #-32]	; 0xffffffe0
    2440:	0c000008 	stceq	0, cr0, [r0], {8}
    2444:	00000937 	andeq	r0, r0, r7, lsr r9
    2448:	06d02200 	ldrbeq	r2, [r0], r0, lsl #4
    244c:	1d070000 	stcne	0, cr0, [r7, #-0]
    2450:	00076b11 	andeq	r6, r7, r1, lsl fp
    2454:	00085100 	andeq	r5, r8, r0, lsl #2
    2458:	00085700 	andeq	r5, r8, r0, lsl #14
    245c:	09370c00 	ldmdbeq	r7!, {sl, fp}
    2460:	23000000 	movwcs	r0, #0
    2464:	0000074d 	andeq	r0, r0, sp, asr #14
    2468:	01191f07 	tsteq	r9, r7, lsl #30
    246c:	74000008 	strvc	r0, [r0], #-8
    2470:	6f000000 	svcvs	0x00000000
    2474:	7f000008 	svcvc	0x00000008
    2478:	0c000008 	stceq	0, cr0, [r0], {8}
    247c:	00000937 	andeq	r0, r0, r7, lsr r9
    2480:	0000740d 	andeq	r7, r0, sp, lsl #8
    2484:	00740d00 	rsbseq	r0, r4, r0, lsl #26
    2488:	23000000 	movwcs	r0, #0
    248c:	00000983 	andeq	r0, r0, r3, lsl #19
    2490:	e2192007 	ands	r2, r9, #7
    2494:	74000006 	strvc	r0, [r0], #-6
    2498:	97000000 	strls	r0, [r0, -r0]
    249c:	a7000008 	strge	r0, [r0, -r8]
    24a0:	0c000008 	stceq	0, cr0, [r0], {8}
    24a4:	00000937 	andeq	r0, r0, r7, lsr r9
    24a8:	0000740d 	andeq	r7, r0, sp, lsl #8
    24ac:	00740d00 	rsbseq	r0, r4, r0, lsl #26
    24b0:	22000000 	andcs	r0, r0, #0
    24b4:	000006ac 	andeq	r0, r0, ip, lsr #13
    24b8:	950a2207 	strls	r2, [sl, #-519]	; 0xfffffdf9
    24bc:	bb000008 	bllt	24e4 <CPSR_IRQ_INHIBIT+0x2464>
    24c0:	c1000008 	tstgt	r0, r8
    24c4:	0c000008 	stceq	0, cr0, [r0], {8}
    24c8:	00000937 	andeq	r0, r0, r7, lsr r9
    24cc:	072d2200 	streq	r2, [sp, -r0, lsl #4]!
    24d0:	24070000 	strcs	r0, [r7], #-0
    24d4:	0008360a 	andeq	r3, r8, sl, lsl #12
    24d8:	0008d500 	andeq	sp, r8, r0, lsl #10
    24dc:	0008ea00 	andeq	lr, r8, r0, lsl #20
    24e0:	09370c00 	ldmdbeq	r7!, {sl, fp}
    24e4:	740d0000 	strvc	r0, [sp], #-0
    24e8:	0d000000 	stceq	0, cr0, [r0, #-0]
    24ec:	00000943 	andeq	r0, r0, r3, asr #18
    24f0:	0000740d 	andeq	r7, r0, sp, lsl #8
    24f4:	8d0a0000 	stchi	0, cr0, [sl, #-0]
    24f8:	07000007 	streq	r0, [r0, -r7]
    24fc:	094f232e 	stmdbeq	pc, {r1, r2, r3, r5, r8, r9, sp}^	; <UNPREDICTABLE>
    2500:	0a000000 	beq	2508 <CPSR_IRQ_INHIBIT+0x2488>
    2504:	0000088d 	andeq	r0, r0, sp, lsl #17
    2508:	74122f07 	ldrvc	r2, [r2], #-3847	; 0xfffff0f9
    250c:	04000000 	streq	r0, [r0], #-0
    2510:	00084d0a 	andeq	r4, r8, sl, lsl #26
    2514:	12300700 	eorsne	r0, r0, #0, 14
    2518:	00000074 	andeq	r0, r0, r4, ror r0
    251c:	08560a08 	ldmdaeq	r6, {r3, r9, fp}^
    2520:	31070000 	mrscc	r0, (UNDEF: 7)
    2524:	0006cd0f 	andeq	ip, r6, pc, lsl #26
    2528:	c20a0c00 	andgt	r0, sl, #0, 24
    252c:	07000006 	streq	r0, [r0, -r6]
    2530:	06a81232 			; <UNDEFINED> instruction: 0x06a81232
    2534:	00140000 	andseq	r0, r4, r0
    2538:	002c0410 	eoreq	r0, ip, r0, lsl r4
    253c:	2c030000 	stccs	0, cr0, [r3], {-0}
    2540:	10000009 	andne	r0, r0, r9
    2544:	00069b04 	andeq	r9, r6, r4, lsl #22
    2548:	9b041100 	blls	106950 <_bss_end+0xfaaec>
    254c:	10000006 	andne	r0, r0, r6
    2550:	00002504 	andeq	r2, r0, r4, lsl #10
    2554:	57041000 	strpl	r1, [r4, -r0]
    2558:	03000000 	movweq	r0, #0
    255c:	00000949 	andeq	r0, r0, r9, asr #18
    2560:	0007a612 	andeq	sl, r7, r2, lsl r6
    2564:	11350700 	teqne	r5, r0, lsl #14
    2568:	0000069b 	muleq	r0, fp, r6
    256c:	6d656d13 	stclvs	13, cr6, [r5, #-76]!	; 0xffffffb4
    2570:	0b060800 	bleq	184578 <_bss_end+0x178714>
    2574:	000009b9 			; <UNDEFINED> instruction: 0x000009b9
    2578:	0011f414 	andseq	pc, r1, r4, lsl r4	; <UNPREDICTABLE>
    257c:	180a0800 	stmdane	sl, {fp}
    2580:	0000006f 	andeq	r0, r0, pc, rrx
    2584:	00020000 	andeq	r0, r2, r0
    2588:	0010d414 	andseq	sp, r0, r4, lsl r4
    258c:	180d0800 	stmdane	sp, {fp}
    2590:	0000006f 	andeq	r0, r0, pc, rrx
    2594:	20000000 	andcs	r0, r0, r0
    2598:	00142924 	andseq	r2, r4, r4, lsr #18
    259c:	18100800 	ldmdane	r0, {fp}
    25a0:	0000006f 	andeq	r0, r0, pc, rrx
    25a4:	f7144000 			; <UNDEFINED> instruction: 0xf7144000
    25a8:	08000012 	stmdaeq	r0, {r1, r4}
    25ac:	006f1813 	rsbeq	r1, pc, r3, lsl r8	; <UNPREDICTABLE>
    25b0:	00000000 	andeq	r0, r0, r0
    25b4:	80241ffe 	strdhi	r1, [r4], -lr	; <UNPREDICTABLE>
    25b8:	08000010 	stmdaeq	r0, {r4}
    25bc:	006f1816 	rsbeq	r1, pc, r6, lsl r8	; <UNPREDICTABLE>
    25c0:	7ff80000 	svcvc	0x00f80000
    25c4:	096c1800 	stmdbeq	ip!, {fp, ip}^
    25c8:	7c180000 	ldcvc	0, cr0, [r8], {-0}
    25cc:	18000009 	stmdane	r0, {r0, r3}
    25d0:	0000098c 	andeq	r0, r0, ip, lsl #19
    25d4:	00099a18 	andeq	r9, r9, r8, lsl sl
    25d8:	09aa1800 	stmibeq	sl!, {fp, ip}
    25dc:	601d0000 	andsvs	r0, sp, r0
    25e0:	10000013 	andne	r0, r0, r3, lsl r0
    25e4:	14080809 	strne	r0, [r8], #-2057	; 0xfffff7f7
    25e8:	0a00000a 	beq	2618 <CPSR_IRQ_INHIBIT+0x2598>
    25ec:	0000107b 	andeq	r1, r0, fp, ror r0
    25f0:	14200a09 	strtne	r0, [r0], #-2569	; 0xfffff5f7
    25f4:	0000000a 	andeq	r0, r0, sl
    25f8:	0010df0a 	andseq	sp, r0, sl, lsl #30
    25fc:	200b0900 	andcs	r0, fp, r0, lsl #18
    2600:	00000a14 	andeq	r0, r0, r4, lsl sl
    2604:	11a60a04 			; <UNDEFINED> instruction: 0x11a60a04
    2608:	0c090000 	stceq	0, cr0, [r9], {-0}
    260c:	0000630e 	andeq	r6, r0, lr, lsl #6
    2610:	2c0a0800 	stccs	8, cr0, [sl], {-0}
    2614:	09000011 	stmdbeq	r0, {r0, r4}
    2618:	02630a0d 	rsbeq	r0, r3, #53248	; 0xd000
    261c:	000c0000 	andeq	r0, ip, r0
    2620:	09d20410 	ldmibeq	r2, {r4, sl}^
    2624:	7e090000 	cdpvc	0, 0, cr0, cr9, cr0, {0}
    2628:	04000012 	streq	r0, [r0], #-18	; 0xffffffee
    262c:	b2071009 	andlt	r1, r7, #9
    2630:	0a00000a 	beq	2660 <CPSR_IRQ_INHIBIT+0x25e0>
    2634:	00001323 	andeq	r1, r0, r3, lsr #6
    2638:	14241309 	strtne	r1, [r4], #-777	; 0xfffffcf7
    263c:	0000000a 	andeq	r0, r0, sl
    2640:	00139823 	andseq	r9, r3, r3, lsr #16
    2644:	24150900 	ldrcs	r0, [r5], #-2304	; 0xfffff700
    2648:	00001179 	andeq	r1, r0, r9, ror r1
    264c:	00000a14 	andeq	r0, r0, r4, lsl sl
    2650:	00000a4c 	andeq	r0, r0, ip, asr #20
    2654:	00000a52 	andeq	r0, r0, r2, asr sl
    2658:	000ab20c 	andeq	fp, sl, ip, lsl #4
    265c:	7e0b0000 	cdpvc	0, 0, cr0, cr11, cr0, {0}
    2660:	09000012 	stmdbeq	r0, {r1, r4}
    2664:	11fe0918 	mvnsne	r0, r8, lsl r9
    2668:	0ab20000 	beq	fec82670 <_bss_end+0xfec7680c>
    266c:	6b010000 	blvs	42674 <_bss_end+0x36810>
    2670:	7100000a 	tstvc	r0, sl
    2674:	0c00000a 	stceq	0, cr0, [r0], {10}
    2678:	00000ab2 			; <UNDEFINED> instruction: 0x00000ab2
    267c:	129c0b00 	addsne	r0, ip, #0, 22
    2680:	1a090000 	bne	242688 <_bss_end+0x236824>
    2684:	00125c0f 	andseq	r5, r2, pc, lsl #24
    2688:	000ab800 	andeq	fp, sl, r0, lsl #16
    268c:	0a8a0100 	beq	fe282a94 <_bss_end+0xfe276c30>
    2690:	0a950000 	beq	fe542698 <_bss_end+0xfe536834>
    2694:	b20c0000 	andlt	r0, ip, #0
    2698:	0d00000a 	stceq	0, cr0, [r0, #-40]	; 0xffffffd8
    269c:	00000063 	andeq	r0, r0, r3, rrx
    26a0:	11ab1b00 			; <UNDEFINED> instruction: 0x11ab1b00
    26a4:	1b090000 	blne	2426ac <_bss_end+0x236848>
    26a8:	0011d20e 	andseq	sp, r1, lr, lsl #4
    26ac:	0aa60100 	beq	fe982ab4 <_bss_end+0xfe976c50>
    26b0:	b20c0000 	andlt	r0, ip, #0
    26b4:	0d00000a 	stceq	0, cr0, [r0, #-40]	; 0xffffffd8
    26b8:	00000ab8 			; <UNDEFINED> instruction: 0x00000ab8
    26bc:	04100000 	ldreq	r0, [r0], #-0
    26c0:	00000a1a 	andeq	r0, r0, sl, lsl sl
    26c4:	73120425 	tstvc	r2, #620756992	; 0x25000000
    26c8:	09000014 	stmdbeq	r0, {r2, r4}
    26cc:	0a1a1d24 	beq	689b64 <_bss_end+0x67dd00>
    26d0:	b0070000 	andlt	r0, r7, r0
    26d4:	05000011 	streq	r0, [r0, #-17]	; 0xffffffef
    26d8:	00003804 	andeq	r3, r0, r4, lsl #16
    26dc:	0c040a00 			; <UNDEFINED> instruction: 0x0c040a00
    26e0:	00000af1 	strdeq	r0, [r0], -r1
    26e4:	77654e16 			; <UNDEFINED> instruction: 0x77654e16
    26e8:	93080000 	movwls	r0, #32768	; 0x8000
    26ec:	01000012 	tsteq	r0, r2, lsl r0
    26f0:	000c0608 	andeq	r0, ip, r8, lsl #12
    26f4:	26080200 	strcs	r0, [r8], -r0, lsl #4
    26f8:	03000012 	movweq	r0, #18
    26fc:	11341d00 	teqne	r4, r0, lsl #26
    2700:	0a0c0000 	beq	302708 <_bss_end+0x2f68a4>
    2704:	0b230811 	bleq	8c4750 <_bss_end+0x8b88ec>
    2708:	6c1e0000 	ldcvs	0, cr0, [lr], {-0}
    270c:	130a0072 	movwne	r0, #41074	; 0xa072
    2710:	00044413 	andeq	r4, r4, r3, lsl r4
    2714:	731e0000 	tstvc	lr, #0
    2718:	140a0070 	strne	r0, [sl], #-112	; 0xffffff90
    271c:	00044413 	andeq	r4, r4, r3, lsl r4
    2720:	701e0400 	andsvc	r0, lr, r0, lsl #8
    2724:	150a0063 	strne	r0, [sl, #-99]	; 0xffffff9d
    2728:	00044413 	andeq	r4, r4, r3, lsl r4
    272c:	1d000800 	stcne	8, cr0, [r0, #-0]
    2730:	0000130d 	andeq	r1, r0, sp, lsl #6
    2734:	081b0a1c 	ldmdaeq	fp, {r2, r3, r4, r9, fp}
    2738:	00000b72 	andeq	r0, r0, r2, ror fp
    273c:	0012eb0a 	andseq	lr, r2, sl, lsl #22
    2740:	121d0a00 	andsne	r0, sp, #0, 20
    2744:	00000af1 	strdeq	r0, [r0], -r1
    2748:	69701e00 	ldmdbvs	r0!, {r9, sl, fp, ip}^
    274c:	1e0a0064 	cdpne	0, 0, cr0, cr10, cr4, {3}
    2750:	00007412 	andeq	r7, r0, r2, lsl r4
    2754:	450a0c00 	strmi	r0, [sl, #-3072]	; 0xfffff400
    2758:	0a00001c 	beq	27d0 <CPSR_IRQ_INHIBIT+0x2750>
    275c:	0ac6111f 	beq	ff186be0 <_bss_end+0xff17ad7c>
    2760:	0a100000 	beq	402768 <_bss_end+0x3f6904>
    2764:	0000124e 	andeq	r1, r0, lr, asr #4
    2768:	7412200a 	ldrvc	r2, [r2], #-10
    276c:	14000000 	strne	r0, [r0], #-0
    2770:	0011bc0a 	andseq	fp, r1, sl, lsl #24
    2774:	12210a00 	eorne	r0, r1, #0, 20
    2778:	00000074 	andeq	r0, r0, r4, ror r0
    277c:	4d1d0018 	ldcmi	0, cr0, [sp, #-96]	; 0xffffffa0
    2780:	0c000013 	stceq	0, cr0, [r0], {19}
    2784:	a708070b 	strge	r0, [r8, -fp, lsl #14]
    2788:	0a00000b 	beq	27bc <CPSR_IRQ_INHIBIT+0x273c>
    278c:	0000107b 	andeq	r1, r0, fp, ror r0
    2790:	a719090b 	ldrge	r0, [r9, -fp, lsl #18]
    2794:	0000000b 	andeq	r0, r0, fp
    2798:	0010df0a 	andseq	sp, r0, sl, lsl #30
    279c:	190a0b00 	stmdbne	sl, {r8, r9, fp}
    27a0:	00000ba7 	andeq	r0, r0, r7, lsr #23
    27a4:	13080a04 	movwne	r0, #35332	; 0x8a04
    27a8:	0b0b0000 	bleq	2c27b0 <_bss_end+0x2b694c>
    27ac:	000bad13 	andeq	sl, fp, r3, lsl sp
    27b0:	10000800 	andne	r0, r0, r0, lsl #16
    27b4:	000b7204 	andeq	r7, fp, r4, lsl #4
    27b8:	23041000 	movwcs	r1, #16384	; 0x4000
    27bc:	0900000b 	stmdbeq	r0, {r0, r1, r3}
    27c0:	0000111b 	andeq	r1, r0, fp, lsl r1
    27c4:	070e0b0c 	streq	r0, [lr, -ip, lsl #22]
    27c8:	00000c9b 	muleq	r0, fp, ip
    27cc:	00121c0a 	andseq	r1, r2, sl, lsl #24
    27d0:	12120b00 	andsne	r0, r2, #0, 22
    27d4:	00000063 	andeq	r0, r0, r3, rrx
    27d8:	10c10a00 	sbcne	r0, r1, r0, lsl #20
    27dc:	150b0000 	strne	r0, [fp, #-0]
    27e0:	000ba71d 	andeq	sl, fp, sp, lsl r7
    27e4:	d80a0400 	stmdale	sl, {sl}
    27e8:	0b000012 	bleq	2838 <CPSR_IRQ_INHIBIT+0x27b8>
    27ec:	0ba71d18 	bleq	fe9c9c54 <_bss_end+0xfe9bddf0>
    27f0:	22080000 	andcs	r0, r8, #0
    27f4:	0000138e 	andeq	r1, r0, lr, lsl #7
    27f8:	2a0e1b0b 	bcs	38942c <_bss_end+0x37d5c8>
    27fc:	fb000013 	blx	2852 <CPSR_IRQ_INHIBIT+0x27d2>
    2800:	0600000b 	streq	r0, [r0], -fp
    2804:	0c00000c 	stceq	0, cr0, [r0], {12}
    2808:	00000ca0 	andeq	r0, r0, r0, lsr #25
    280c:	000ba70d 	andeq	sl, fp, sp, lsl #14
    2810:	1b0b0000 	blne	2c2818 <_bss_end+0x2b69b4>
    2814:	0b000011 	bleq	2860 <CPSR_IRQ_INHIBIT+0x27e0>
    2818:	114b091e 	cmpne	fp, lr, lsl r9
    281c:	0ca00000 	stceq	0, cr0, [r0]
    2820:	1f010000 	svcne	0x00010000
    2824:	2500000c 	strcs	r0, [r0, #-12]
    2828:	0c00000c 	stceq	0, cr0, [r0], {12}
    282c:	00000ca0 	andeq	r0, r0, r0, lsr #25
    2830:	137a0e00 	cmnne	sl, #0, 28
    2834:	210b0000 	mrscs	r0, (UNDEF: 11)
    2838:	00108a0e 	andseq	r8, r0, lr, lsl #20
    283c:	0c3a0100 	ldfeqs	f0, [sl], #-0
    2840:	0c400000 	mareq	acc0, r0, r0
    2844:	a00c0000 	andge	r0, ip, r0
    2848:	0000000c 	andeq	r0, r0, ip
    284c:	00110c0b 	andseq	r0, r1, fp, lsl #24
    2850:	12240b00 	eorne	r0, r4, #0, 22
    2854:	000010e4 	andeq	r1, r0, r4, ror #1
    2858:	00000063 	andeq	r0, r0, r3, rrx
    285c:	000c5901 	andeq	r5, ip, r1, lsl #18
    2860:	000c6400 	andeq	r6, ip, r0, lsl #8
    2864:	0ca00c00 	stceq	12, cr0, [r0]
    2868:	440d0000 	strmi	r0, [sp], #-0
    286c:	00000004 	andeq	r0, r0, r4
    2870:	00131a0e 	andseq	r1, r3, lr, lsl #20
    2874:	0e270b00 	vmuleq.f64	d0, d7, d0
    2878:	0000122d 	andeq	r1, r0, sp, lsr #4
    287c:	000c7901 	andeq	r7, ip, r1, lsl #18
    2880:	000c7f00 	andeq	r7, ip, r0, lsl #30
    2884:	0ca00c00 	stceq	12, cr0, [r0]
    2888:	0f000000 	svceq	0x00000000
    288c:	00001165 	andeq	r1, r0, r5, ror #2
    2890:	aa172a0b 	bge	5cd0c4 <_bss_end+0x5c1260>
    2894:	ad000012 	stcge	0, cr0, [r0, #-72]	; 0xffffffb8
    2898:	0100000b 	tsteq	r0, fp
    289c:	00000c94 	muleq	r0, r4, ip
    28a0:	000ca60c 	andeq	sl, ip, ip, lsl #12
    28a4:	03000000 	movweq	r0, #0
    28a8:	00000bb3 			; <UNDEFINED> instruction: 0x00000bb3
    28ac:	0bb30410 	bleq	fecc38f4 <_bss_end+0xfecb7a90>
    28b0:	04100000 	ldreq	r0, [r0], #-0
    28b4:	00000c9b 	muleq	r0, fp, ip
    28b8:	0016fa12 	andseq	pc, r6, r2, lsl sl	; <UNPREDICTABLE>
    28bc:	192d0b00 	pushne	{r8, r9, fp}
    28c0:	00000bb3 			; <UNDEFINED> instruction: 0x00000bb3
    28c4:	00114126 	andseq	r4, r1, r6, lsr #2
    28c8:	0f0e0100 	svceq	0x000e0100
    28cc:	0000026a 	andeq	r0, r0, sl, ror #4
    28d0:	ae400305 	cdpge	3, 4, cr0, cr0, cr5, {0}
    28d4:	a2270000 	eorge	r0, r7, #0
    28d8:	01000012 	tsteq	r0, r2, lsl r0
    28dc:	006f1411 	rsbeq	r1, pc, r1, lsl r4	; <UNPREDICTABLE>
    28e0:	03050000 	movweq	r0, #20480	; 0x5000
    28e4:	0000acd0 	ldrdeq	sl, [r0], -r0
    28e8:	0013bc28 	andseq	fp, r3, r8, lsr #24
    28ec:	10800100 	addne	r0, r0, r0, lsl #2
    28f0:	00000038 	andeq	r0, r0, r8, lsr r0
    28f4:	0000969c 	muleq	r0, ip, r6
    28f8:	000000cc 	andeq	r0, r0, ip, asr #1
    28fc:	b2299c01 	eorlt	r9, r9, #256	; 0x100
    2900:	01000013 	tsteq	r0, r3, lsl r0
    2904:	96001168 	strls	r1, [r0], -r8, ror #2
    2908:	009c0000 	addseq	r0, ip, r0
    290c:	9c010000 	stcls	0, cr0, [r1], {-0}
    2910:	00000d25 	andeq	r0, r0, r5, lsr #26
    2914:	0100692a 	tsteq	r0, sl, lsr #18
    2918:	003f0f6a 	eorseq	r0, pc, sl, ror #30
    291c:	91020000 	mrsls	r0, (UNDEF: 2)
    2920:	1c452b70 	mcrrne	11, 7, r2, r5, cr0
    2924:	6e010000 	cdpvs	0, 0, cr0, cr1, cr0, {0}
    2928:	0002630a 	andeq	r6, r2, sl, lsl #6
    292c:	77910200 	ldrvc	r0, [r1, r0, lsl #4]
    2930:	13a82900 			; <UNDEFINED> instruction: 0x13a82900
    2934:	50010000 	andpl	r0, r1, r0
    2938:	00956411 	addseq	r6, r5, r1, lsl r4
    293c:	00009c00 	andeq	r9, r0, r0, lsl #24
    2940:	589c0100 	ldmpl	ip, {r8}
    2944:	2a00000d 	bcs	2980 <CPSR_IRQ_INHIBIT+0x2900>
    2948:	52010069 	andpl	r0, r1, #105	; 0x69
    294c:	00003f0f 	andeq	r3, r0, pc, lsl #30
    2950:	70910200 	addsvc	r0, r1, r0, lsl #4
    2954:	001c452b 	andseq	r4, ip, fp, lsr #10
    2958:	0a560100 	beq	1582d60 <_bss_end+0x1576efc>
    295c:	00000263 	andeq	r0, r0, r3, ror #4
    2960:	00779102 	rsbseq	r9, r7, r2, lsl #2
    2964:	0013c929 	andseq	ip, r3, r9, lsr #18
    2968:	11380100 	teqne	r8, r0, lsl #2
    296c:	000094c8 	andeq	r9, r0, r8, asr #9
    2970:	0000009c 	muleq	r0, ip, r0
    2974:	0d8b9c01 	stceq	12, cr9, [fp, #4]
    2978:	692a0000 	stmdbvs	sl!, {}	; <UNPREDICTABLE>
    297c:	0f3a0100 	svceq	0x003a0100
    2980:	0000003f 	andeq	r0, r0, pc, lsr r0
    2984:	2b709102 	blcs	1c26d94 <_bss_end+0x1c1af30>
    2988:	00001c45 	andeq	r1, r0, r5, asr #24
    298c:	630a3e01 	movwvs	r3, #44545	; 0xae01
    2990:	02000002 	andeq	r0, r0, #2
    2994:	29007791 	stmdbcs	r0, {r0, r4, r7, r8, r9, sl, ip, sp, lr}
    2998:	000010b7 	strheq	r1, [r0], -r7
    299c:	2c111f01 	ldccs	15, cr1, [r1], {1}
    29a0:	9c000094 	stcls	0, cr0, [r0], {148}	; 0x94
    29a4:	01000000 	mrseq	r0, (UNDEF: 0)
    29a8:	000dbe9c 	muleq	sp, ip, lr
    29ac:	00692a00 	rsbeq	r2, r9, r0, lsl #20
    29b0:	3f0f2101 	svccc	0x000f2101
    29b4:	02000000 	andeq	r0, r0, #0
    29b8:	452b7091 	strmi	r7, [fp, #-145]!	; 0xffffff6f
    29bc:	0100001c 	tsteq	r0, ip, lsl r0
    29c0:	02630a25 	rsbeq	r0, r3, #151552	; 0x25000
    29c4:	91020000 	mrsls	r0, (UNDEF: 2)
    29c8:	242c0077 	strtcs	r0, [ip], #-119	; 0xffffff89
    29cc:	0100000c 	tsteq	r0, ip
    29d0:	93d01117 	bicsls	r1, r0, #-1073741819	; 0xc0000005
    29d4:	005c0000 	subseq	r0, ip, r0
    29d8:	9c010000 	stcls	0, cr0, [r1], {-0}
    29dc:	00049f00 	andeq	r9, r4, r0, lsl #30
    29e0:	41000400 	tstmi	r0, r0, lsl #8
    29e4:	0400000e 	streq	r0, [r0], #-14
    29e8:	00000001 	andeq	r0, r0, r1
    29ec:	14bd0400 	ldrtne	r0, [sp], #1024	; 0x400
    29f0:	00b60000 	adcseq	r0, r6, r0
    29f4:	97680000 	strbls	r0, [r8, -r0]!
    29f8:	036c0000 	cmneq	ip, #0
    29fc:	10660000 	rsbne	r0, r6, r0
    2a00:	01020000 	mrseq	r0, (UNDEF: 2)
    2a04:	0004a008 	andeq	sl, r4, r8
    2a08:	05020200 	streq	r0, [r2, #-512]	; 0xfffffe00
    2a0c:	00000280 	andeq	r0, r0, r0, lsl #5
    2a10:	69050403 	stmdbvs	r5, {r0, r1, sl}
    2a14:	0400746e 	streq	r7, [r0], #-1134	; 0xfffffb92
    2a18:	00000a59 	andeq	r0, r0, r9, asr sl
    2a1c:	46070902 	strmi	r0, [r7], -r2, lsl #18
    2a20:	02000000 	andeq	r0, r0, #0
    2a24:	04970801 	ldreq	r0, [r7], #2049	; 0x801
    2a28:	02020000 	andeq	r0, r2, #0
    2a2c:	00050207 	andeq	r0, r5, r7, lsl #4
    2a30:	03290400 			; <UNDEFINED> instruction: 0x03290400
    2a34:	0b020000 	bleq	82a3c <_bss_end+0x76bd8>
    2a38:	00006507 	andeq	r6, r0, r7, lsl #10
    2a3c:	00540500 	subseq	r0, r4, r0, lsl #10
    2a40:	04020000 	streq	r0, [r2], #-0
    2a44:	001ef907 	andseq	pc, lr, r7, lsl #18
    2a48:	00650500 	rsbeq	r0, r5, r0, lsl #10
    2a4c:	60060000 	andvs	r0, r6, r0
    2a50:	10000013 	andne	r0, r0, r3, lsl r0
    2a54:	b3080803 	movwlt	r0, #34819	; 0x8803
    2a58:	07000000 	streq	r0, [r0, -r0]
    2a5c:	0000107b 	andeq	r1, r0, fp, ror r0
    2a60:	b3200a03 			; <UNDEFINED> instruction: 0xb3200a03
    2a64:	00000000 	andeq	r0, r0, r0
    2a68:	0010df07 	andseq	sp, r0, r7, lsl #30
    2a6c:	200b0300 	andcs	r0, fp, r0, lsl #6
    2a70:	000000b3 	strheq	r0, [r0], -r3
    2a74:	11a60704 			; <UNDEFINED> instruction: 0x11a60704
    2a78:	0c030000 	stceq	0, cr0, [r3], {-0}
    2a7c:	0000540e 	andeq	r5, r0, lr, lsl #8
    2a80:	2c070800 	stccs	8, cr0, [r7], {-0}
    2a84:	03000011 	movweq	r0, #17
    2a88:	00b90a0d 	adcseq	r0, r9, sp, lsl #20
    2a8c:	000c0000 	andeq	r0, ip, r0
    2a90:	00710408 	rsbseq	r0, r1, r8, lsl #8
    2a94:	01020000 	mrseq	r0, (UNDEF: 2)
    2a98:	00033202 	andeq	r3, r3, r2, lsl #4
    2a9c:	127e0900 	rsbsne	r0, lr, #0, 18
    2aa0:	03040000 	movweq	r0, #16384	; 0x4000
    2aa4:	01580710 	cmpeq	r8, r0, lsl r7
    2aa8:	23070000 	movwcs	r0, #28672	; 0x7000
    2aac:	03000013 	movweq	r0, #19
    2ab0:	00b32413 	adcseq	r2, r3, r3, lsl r4
    2ab4:	0a000000 	beq	2abc <CPSR_IRQ_INHIBIT+0x2a3c>
    2ab8:	00001398 	muleq	r0, r8, r3
    2abc:	79241503 	stmdbvc	r4!, {r0, r1, r8, sl, ip}
    2ac0:	b3000011 	movwlt	r0, #17
    2ac4:	f2000000 	vhadd.s8	d0, d0, d0
    2ac8:	f8000000 			; <UNDEFINED> instruction: 0xf8000000
    2acc:	0b000000 	bleq	2ad4 <CPSR_IRQ_INHIBIT+0x2a54>
    2ad0:	00000158 	andeq	r0, r0, r8, asr r1
    2ad4:	127e0c00 	rsbsne	r0, lr, #0, 24
    2ad8:	18030000 	stmdane	r3, {}	; <UNPREDICTABLE>
    2adc:	0011fe09 	andseq	pc, r1, r9, lsl #28
    2ae0:	00015800 	andeq	r5, r1, r0, lsl #16
    2ae4:	01110100 	tsteq	r1, r0, lsl #2
    2ae8:	01170000 	tsteq	r7, r0
    2aec:	580b0000 	stmdapl	fp, {}	; <UNPREDICTABLE>
    2af0:	00000001 	andeq	r0, r0, r1
    2af4:	00129c0c 	andseq	r9, r2, ip, lsl #24
    2af8:	0f1a0300 	svceq	0x001a0300
    2afc:	0000125c 	andeq	r1, r0, ip, asr r2
    2b00:	00000163 	andeq	r0, r0, r3, ror #2
    2b04:	00013001 	andeq	r3, r1, r1
    2b08:	00013b00 	andeq	r3, r1, r0, lsl #22
    2b0c:	01580b00 	cmpeq	r8, r0, lsl #22
    2b10:	540d0000 	strpl	r0, [sp], #-0
    2b14:	00000000 	andeq	r0, r0, r0
    2b18:	0011ab0e 	andseq	sl, r1, lr, lsl #22
    2b1c:	0e1b0300 	cdpeq	3, 1, cr0, cr11, cr0, {0}
    2b20:	000011d2 	ldrdeq	r1, [r0], -r2
    2b24:	00014c01 	andeq	r4, r1, r1, lsl #24
    2b28:	01580b00 	cmpeq	r8, r0, lsl #22
    2b2c:	630d0000 	movwvs	r0, #53248	; 0xd000
    2b30:	00000001 	andeq	r0, r0, r1
    2b34:	c0040800 	andgt	r0, r4, r0, lsl #16
    2b38:	05000000 	streq	r0, [r0, #-0]
    2b3c:	00000158 	andeq	r0, r0, r8, asr r1
    2b40:	7310040f 	tstvc	r0, #251658240	; 0xf000000
    2b44:	03000014 	movweq	r0, #20
    2b48:	00c01d24 	sbceq	r1, r0, r4, lsr #26
    2b4c:	68110000 	ldmdavs	r1, {}	; <UNPREDICTABLE>
    2b50:	04006c61 	streq	r6, [r0], #-3169	; 0xfffff39f
    2b54:	01eb0b07 	mvneq	r0, r7, lsl #22
    2b58:	80120000 	andshi	r0, r2, r0
    2b5c:	04000006 	streq	r0, [r0], #-6
    2b60:	006c1909 	rsbeq	r1, ip, r9, lsl #18
    2b64:	b2800000 	addlt	r0, r0, #0
    2b68:	e6120ee6 	ldr	r0, [r2], -r6, ror #29
    2b6c:	04000003 	streq	r0, [r0], #-3
    2b70:	01f71a0c 	mvnseq	r1, ip, lsl #20
    2b74:	00000000 	andeq	r0, r0, r0
    2b78:	c4122000 	ldrgt	r2, [r2], #-0
    2b7c:	04000004 	streq	r0, [r0], #-4
    2b80:	01f71a0f 	mvnseq	r1, pc, lsl #20
    2b84:	00000000 	andeq	r0, r0, r0
    2b88:	30132020 	andscc	r2, r3, r0, lsr #32
    2b8c:	04000005 	streq	r0, [r0], #-5
    2b90:	00601512 	rsbeq	r1, r0, r2, lsl r5
    2b94:	12360000 	eorsne	r0, r6, #0
    2b98:	00000627 	andeq	r0, r0, r7, lsr #12
    2b9c:	f71a4404 			; <UNDEFINED> instruction: 0xf71a4404
    2ba0:	00000001 	andeq	r0, r0, r1
    2ba4:	12202150 	eorne	r2, r0, #80, 2
    2ba8:	00000266 	andeq	r0, r0, r6, ror #4
    2bac:	f71a7304 			; <UNDEFINED> instruction: 0xf71a7304
    2bb0:	00000001 	andeq	r0, r0, r1
    2bb4:	122000b2 	eorne	r0, r0, #178	; 0xb2
    2bb8:	00000544 	andeq	r0, r0, r4, asr #10
    2bbc:	f71aa604 			; <UNDEFINED> instruction: 0xf71aa604
    2bc0:	00000001 	andeq	r0, r0, r1
    2bc4:	002000b4 	strhteq	r0, [r0], -r4
    2bc8:	00017d14 	andeq	r7, r1, r4, lsl sp
    2bcc:	07040200 	streq	r0, [r4, -r0, lsl #4]
    2bd0:	00001ef4 	strdeq	r1, [r0], -r4
    2bd4:	0001f005 	andeq	pc, r1, r5
    2bd8:	018d1400 	orreq	r1, sp, r0, lsl #8
    2bdc:	9d140000 	ldcls	0, cr0, [r4, #-0]
    2be0:	14000001 	strne	r0, [r0], #-1
    2be4:	000001ad 	andeq	r0, r0, sp, lsr #3
    2be8:	0001ba14 	andeq	fp, r1, r4, lsl sl
    2bec:	01ca1400 	biceq	r1, sl, r0, lsl #8
    2bf0:	da140000 	ble	502bf8 <_bss_end+0x4f6d94>
    2bf4:	11000001 	tstne	r0, r1
    2bf8:	006d656d 	rsbeq	r6, sp, sp, ror #10
    2bfc:	730b0605 	movwvc	r0, #46597	; 0xb605
    2c00:	12000002 	andne	r0, r0, #2
    2c04:	000011f4 	strdeq	r1, [r0], -r4
    2c08:	60180a05 	andsvs	r0, r8, r5, lsl #20
    2c0c:	00000000 	andeq	r0, r0, r0
    2c10:	12000200 	andne	r0, r0, #0, 4
    2c14:	000010d4 	ldrdeq	r1, [r0], -r4
    2c18:	60180d05 	andsvs	r0, r8, r5, lsl #26
    2c1c:	00000000 	andeq	r0, r0, r0
    2c20:	15200000 	strne	r0, [r0, #-0]!
    2c24:	00001429 	andeq	r1, r0, r9, lsr #8
    2c28:	60181005 	andsvs	r1, r8, r5
    2c2c:	00000000 	andeq	r0, r0, r0
    2c30:	12f71240 	rscsne	r1, r7, #64, 4
    2c34:	13050000 	movwne	r0, #20480	; 0x5000
    2c38:	00006018 	andeq	r6, r0, r8, lsl r0
    2c3c:	fe000000 	cdp2	0, 0, cr0, cr0, cr0, {0}
    2c40:	1080151f 	addne	r1, r0, pc, lsl r5
    2c44:	16050000 	strne	r0, [r5], -r0
    2c48:	00006018 	andeq	r6, r0, r8, lsl r0
    2c4c:	007ff800 	rsbseq	pc, pc, r0, lsl #16
    2c50:	00022614 	andeq	r2, r2, r4, lsl r6
    2c54:	02361400 	eorseq	r1, r6, #0, 8
    2c58:	46140000 	ldrmi	r0, [r4], -r0
    2c5c:	14000002 	strne	r0, [r0], #-2
    2c60:	00000254 	andeq	r0, r0, r4, asr r2
    2c64:	00026414 	andeq	r6, r2, r4, lsl r4
    2c68:	15721600 	ldrbne	r1, [r2, #-1536]!	; 0xfffffa00
    2c6c:	0fff0000 	svceq	0x00ff0000
    2c70:	26070906 	strcs	r0, [r7], -r6, lsl #18
    2c74:	07000003 	streq	r0, [r0, -r3]
    2c78:	00001457 	andeq	r1, r0, r7, asr r4
    2c7c:	26110c06 	ldrcs	r0, [r1], -r6, lsl #24
    2c80:	00000003 	andeq	r0, r0, r3
    2c84:	00145217 	andseq	r5, r4, r7, lsl r2
    2c88:	0e0e0600 	cfmadd32eq	mvax0, mvfx0, mvfx14, mvfx0
    2c8c:	00001521 	andeq	r1, r0, r1, lsr #10
    2c90:	000002bb 			; <UNDEFINED> instruction: 0x000002bb
    2c94:	000002cb 	andeq	r0, r0, fp, asr #5
    2c98:	0003370b 	andeq	r3, r3, fp, lsl #14
    2c9c:	00540d00 	subseq	r0, r4, r0, lsl #26
    2ca0:	b90d0000 	stmdblt	sp, {}	; <UNPREDICTABLE>
    2ca4:	00000000 	andeq	r0, r0, r0
    2ca8:	0015720c 	andseq	r7, r5, ip, lsl #4
    2cac:	09110600 	ldmdbeq	r1, {r9, sl}
    2cb0:	0000153c 	andeq	r1, r0, ip, lsr r5
    2cb4:	00000337 	andeq	r0, r0, r7, lsr r3
    2cb8:	0002e401 	andeq	lr, r2, r1, lsl #8
    2cbc:	0002ea00 	andeq	lr, r2, r0, lsl #20
    2cc0:	03370b00 	teqeq	r7, #0, 22
    2cc4:	0c000000 	stceq	0, cr0, [r0], {-0}
    2cc8:	00001437 	andeq	r1, r0, r7, lsr r4
    2ccc:	7e121406 	cfmulsvc	mvf1, mvf2, mvf6
    2cd0:	54000014 	strpl	r0, [r0], #-20	; 0xffffffec
    2cd4:	01000000 	mrseq	r0, (UNDEF: 0)
    2cd8:	00000303 	andeq	r0, r0, r3, lsl #6
    2cdc:	00000309 	andeq	r0, r0, r9, lsl #6
    2ce0:	0003370b 	andeq	r3, r3, fp, lsl #14
    2ce4:	420e0000 	andmi	r0, lr, #0
    2ce8:	06000014 			; <UNDEFINED> instruction: 0x06000014
    2cec:	15530e16 	ldrbne	r0, [r3, #-3606]	; 0xfffff1ea
    2cf0:	1a010000 	bne	42cf8 <_bss_end+0x36e94>
    2cf4:	0b000003 	bleq	2d08 <CPSR_IRQ_INHIBIT+0x2c88>
    2cf8:	00000337 	andeq	r0, r0, r7, lsr r3
    2cfc:	0000540d 	andeq	r5, r0, sp, lsl #8
    2d00:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
    2d04:	0000003a 	andeq	r0, r0, sl, lsr r0
    2d08:	00000337 	andeq	r0, r0, r7, lsr r3
    2d0c:	00006519 	andeq	r6, r0, r9, lsl r5
    2d10:	000ffe00 	andeq	pc, pc, r0, lsl #28
    2d14:	028c0408 	addeq	r0, ip, #8, 8	; 0x8000000
    2d18:	5e100000 	cdppl	0, 1, cr0, cr0, cr0, {0}
    2d1c:	06000016 			; <UNDEFINED> instruction: 0x06000016
    2d20:	028c1619 	addeq	r1, ip, #26214400	; 0x1900000
    2d24:	651a0000 	ldrvs	r0, [sl, #-0]
    2d28:	01000001 	tsteq	r0, r1
    2d2c:	03051604 	movweq	r1, #22020	; 0x5604
    2d30:	0000ae44 	andeq	sl, r0, r4, asr #28
    2d34:	0014641b 	andseq	r6, r4, fp, lsl r4
    2d38:	009ab800 	addseq	fp, sl, r0, lsl #16
    2d3c:	00001c00 	andeq	r1, r0, r0, lsl #24
    2d40:	1c9c0100 	ldfnes	f0, [ip], {0}
    2d44:	0000054f 	andeq	r0, r0, pc, asr #10
    2d48:	00009a6c 	andeq	r9, r0, ip, ror #20
    2d4c:	0000004c 	andeq	r0, r0, ip, asr #32
    2d50:	03989c01 	orrseq	r9, r8, #256	; 0x100
    2d54:	321d0000 	andscc	r0, sp, #0
    2d58:	01000004 	tsteq	r0, r4
    2d5c:	00330157 	eorseq	r0, r3, r7, asr r1
    2d60:	91020000 	mrsls	r0, (UNDEF: 2)
    2d64:	05ed1d74 	strbeq	r1, [sp, #3444]!	; 0xd74
    2d68:	57010000 	strpl	r0, [r1, -r0]
    2d6c:	00003301 	andeq	r3, r0, r1, lsl #6
    2d70:	70910200 	addsvc	r0, r1, r0, lsl #4
    2d74:	013b1e00 	teqeq	fp, r0, lsl #28
    2d78:	42010000 	andmi	r0, r1, #0
    2d7c:	0003b206 	andeq	fp, r3, r6, lsl #4
    2d80:	00995000 	addseq	r5, r9, r0
    2d84:	00011c00 	andeq	r1, r1, r0, lsl #24
    2d88:	dd9c0100 	ldfles	f0, [ip]
    2d8c:	1f000003 	svcne	0x00000003
    2d90:	00000582 	andeq	r0, r0, r2, lsl #11
    2d94:	0000015e 	andeq	r0, r0, lr, asr r1
    2d98:	206c9102 	rsbcs	r9, ip, r2, lsl #2
    2d9c:	006d656d 	rsbeq	r6, sp, sp, ror #10
    2da0:	63274201 			; <UNDEFINED> instruction: 0x63274201
    2da4:	02000001 	andeq	r0, r0, #1
    2da8:	4c216891 	stcmi	8, cr6, [r1], #-580	; 0xfffffdbc
    2dac:	01000014 	tsteq	r0, r4, lsl r0
    2db0:	00b32044 	adcseq	r2, r3, r4, asr #32
    2db4:	91020000 	mrsls	r0, (UNDEF: 2)
    2db8:	171e0074 			; <UNDEFINED> instruction: 0x171e0074
    2dbc:	01000001 	tsteq	r0, r1
    2dc0:	03f70717 	mvnseq	r0, #6029312	; 0x5c0000
    2dc4:	98040000 	stmdals	r4, {}	; <UNPREDICTABLE>
    2dc8:	014c0000 	mrseq	r0, (UNDEF: 76)
    2dcc:	9c010000 	stcls	0, cr0, [r1], {-0}
    2dd0:	00000431 	andeq	r0, r0, r1, lsr r4
    2dd4:	0005821f 	andeq	r8, r5, pc, lsl r2
    2dd8:	00015e00 	andeq	r5, r1, r0, lsl #28
    2ddc:	6c910200 	lfmvs	f0, 4, [r1], {0}
    2de0:	0011a61d 	andseq	sl, r1, sp, lsl r6
    2de4:	2c170100 	ldfcss	f0, [r7], {-0}
    2de8:	00000054 	andeq	r0, r0, r4, asr r0
    2dec:	21689102 	cmncs	r8, r2, lsl #2
    2df0:	0000144c 	andeq	r1, r0, ip, asr #8
    2df4:	b3201901 			; <UNDEFINED> instruction: 0xb3201901
    2df8:	02000000 	andeq	r0, r0, #0
    2dfc:	32217491 	eorcc	r7, r1, #-1862270976	; 0x91000000
    2e00:	01000014 	tsteq	r0, r4, lsl r0
    2e04:	00b32033 	adcseq	r2, r3, r3, lsr r0
    2e08:	91020000 	mrsls	r0, (UNDEF: 2)
    2e0c:	da220070 	ble	882fd4 <_bss_end+0x877170>
    2e10:	01000000 	mrseq	r0, (UNDEF: 0)
    2e14:	044b1c0c 	strbeq	r1, [fp], #-3084	; 0xfffff3f4
    2e18:	979c0000 	ldrls	r0, [ip, r0]
    2e1c:	00680000 	rsbeq	r0, r8, r0
    2e20:	9c010000 	stcls	0, cr0, [r1], {-0}
    2e24:	00000467 	andeq	r0, r0, r7, ror #8
    2e28:	0005821f 	andeq	r8, r5, pc, lsl r2
    2e2c:	00015e00 	andeq	r5, r1, r0, lsl #28
    2e30:	6c910200 	lfmvs	f0, 4, [r1], {0}
    2e34:	00144c21 	andseq	r4, r4, r1, lsr #24
    2e38:	200e0100 	andcs	r0, lr, r0, lsl #2
    2e3c:	000000b3 	strheq	r0, [r0], -r3
    2e40:	00749102 	rsbseq	r9, r4, r2, lsl #2
    2e44:	0000f823 	andeq	pc, r0, r3, lsr #16
    2e48:	01060100 	mrseq	r0, (UNDEF: 22)
    2e4c:	00000478 	andeq	r0, r0, r8, ror r4
    2e50:	00048200 	andeq	r8, r4, r0, lsl #4
    2e54:	05822400 	streq	r2, [r2, #1024]	; 0x400
    2e58:	015e0000 	cmpeq	lr, r0
    2e5c:	25000000 	strcs	r0, [r0, #-0]
    2e60:	00000467 	andeq	r0, r0, r7, ror #8
    2e64:	0000149f 	muleq	r0, pc, r4	; <UNPREDICTABLE>
    2e68:	00000499 	muleq	r0, r9, r4
    2e6c:	00009768 	andeq	r9, r0, r8, ror #14
    2e70:	00000034 	andeq	r0, r0, r4, lsr r0
    2e74:	78269c01 	stmdavc	r6!, {r0, sl, fp, ip, pc}
    2e78:	02000004 	andeq	r0, r0, #4
    2e7c:	00007491 	muleq	r0, r1, r4
    2e80:	0000077b 	andeq	r0, r0, fp, ror r7
    2e84:	10a50004 	adcne	r0, r5, r4
    2e88:	01040000 	mrseq	r0, (UNDEF: 4)
    2e8c:	00000000 	andeq	r0, r0, r0
    2e90:	00158004 	andseq	r8, r5, r4
    2e94:	0000b600 	andeq	fp, r0, r0, lsl #12
    2e98:	009ad400 	addseq	sp, sl, r0, lsl #8
    2e9c:	00051400 	andeq	r1, r5, r0, lsl #8
    2ea0:	00131e00 	andseq	r1, r3, r0, lsl #28
    2ea4:	08010200 	stmdaeq	r1, {r9}
    2ea8:	000004a0 	andeq	r0, r0, r0, lsr #9
    2eac:	00002503 	andeq	r2, r0, r3, lsl #10
    2eb0:	05020200 	streq	r0, [r2, #-512]	; 0xfffffe00
    2eb4:	00000280 	andeq	r0, r0, r0, lsl #5
    2eb8:	69050404 	stmdbvs	r5, {r2, sl}
    2ebc:	0500746e 	streq	r7, [r0, #-1134]	; 0xfffffb92
    2ec0:	00000a59 	andeq	r0, r0, r9, asr sl
    2ec4:	4b070902 	blmi	1c52d4 <_bss_end+0x1b9470>
    2ec8:	02000000 	andeq	r0, r0, #0
    2ecc:	04970801 	ldreq	r0, [r7], #2049	; 0x801
    2ed0:	4b060000 	blmi	182ed8 <_bss_end+0x177074>
    2ed4:	02000000 	andeq	r0, r0, #0
    2ed8:	05020702 	streq	r0, [r2, #-1794]	; 0xfffff8fe
    2edc:	29050000 	stmdbcs	r5, {}	; <UNPREDICTABLE>
    2ee0:	02000003 	andeq	r0, r0, #3
    2ee4:	006f070b 	rsbeq	r0, pc, fp, lsl #14
    2ee8:	5e030000 	cdppl	0, 0, cr0, cr3, cr0, {0}
    2eec:	02000000 	andeq	r0, r0, #0
    2ef0:	1ef90704 	cdpne	7, 15, cr0, cr9, cr4, {0}
    2ef4:	6f030000 	svcvs	0x00030000
    2ef8:	07000000 	streq	r0, [r0, -r0]
    2efc:	006c6168 	rsbeq	r6, ip, r8, ror #2
    2f00:	f50b0703 			; <UNDEFINED> instruction: 0xf50b0703
    2f04:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    2f08:	00000680 	andeq	r0, r0, r0, lsl #13
    2f0c:	76190903 	ldrvc	r0, [r9], -r3, lsl #18
    2f10:	80000000 	andhi	r0, r0, r0
    2f14:	080ee6b2 	stmdaeq	lr, {r1, r4, r5, r7, r9, sl, sp, lr, pc}
    2f18:	000003e6 	andeq	r0, r0, r6, ror #7
    2f1c:	011a0c03 	tsteq	sl, r3, lsl #24
    2f20:	00000001 	andeq	r0, r0, r1
    2f24:	08200000 	stmdaeq	r0!, {}	; <UNPREDICTABLE>
    2f28:	000004c4 	andeq	r0, r0, r4, asr #9
    2f2c:	011a0f03 	tsteq	sl, r3, lsl #30
    2f30:	00000001 	andeq	r0, r0, r1
    2f34:	09202000 	stmdbeq	r0!, {sp}
    2f38:	00000530 	andeq	r0, r0, r0, lsr r5
    2f3c:	6a151203 	bvs	547750 <_bss_end+0x53b8ec>
    2f40:	36000000 	strcc	r0, [r0], -r0
    2f44:	00062708 	andeq	r2, r6, r8, lsl #14
    2f48:	1a440300 	bne	1103b50 <_bss_end+0x10f7cec>
    2f4c:	00000101 	andeq	r0, r0, r1, lsl #2
    2f50:	20215000 	eorcs	r5, r1, r0
    2f54:	00026608 	andeq	r6, r2, r8, lsl #12
    2f58:	1a730300 	bne	1cc3b60 <_bss_end+0x1cb7cfc>
    2f5c:	00000101 	andeq	r0, r0, r1, lsl #2
    2f60:	2000b200 	andcs	fp, r0, r0, lsl #4
    2f64:	00054408 	andeq	r4, r5, r8, lsl #8
    2f68:	1aa60300 	bne	fe983b70 <_bss_end+0xfe977d0c>
    2f6c:	00000101 	andeq	r0, r0, r1, lsl #2
    2f70:	2000b400 	andcs	fp, r0, r0, lsl #8
    2f74:	00870a00 	addeq	r0, r7, r0, lsl #20
    2f78:	04020000 	streq	r0, [r2], #-0
    2f7c:	001ef407 	andseq	pc, lr, r7, lsl #8
    2f80:	00fa0300 	rscseq	r0, sl, r0, lsl #6
    2f84:	970a0000 	strls	r0, [sl, -r0]
    2f88:	0a000000 	beq	2f90 <CPSR_IRQ_INHIBIT+0x2f10>
    2f8c:	000000a7 	andeq	r0, r0, r7, lsr #1
    2f90:	0000b70a 	andeq	fp, r0, sl, lsl #14
    2f94:	00c40a00 	sbceq	r0, r4, r0, lsl #20
    2f98:	d40a0000 	strle	r0, [sl], #-0
    2f9c:	0a000000 	beq	2fa4 <CPSR_IRQ_INHIBIT+0x2f24>
    2fa0:	000000e4 	andeq	r0, r0, r4, ror #1
    2fa4:	6d656d07 	stclvs	13, cr6, [r5, #-28]!	; 0xffffffe4
    2fa8:	0b060400 	bleq	183fb0 <_bss_end+0x17814c>
    2fac:	0000017d 	andeq	r0, r0, sp, ror r1
    2fb0:	0011f408 	andseq	pc, r1, r8, lsl #8
    2fb4:	180a0400 	stmdane	sl, {sl}
    2fb8:	0000006a 	andeq	r0, r0, sl, rrx
    2fbc:	00020000 	andeq	r0, r2, r0
    2fc0:	0010d408 	andseq	sp, r0, r8, lsl #8
    2fc4:	180d0400 	stmdane	sp, {sl}
    2fc8:	0000006a 	andeq	r0, r0, sl, rrx
    2fcc:	20000000 	andcs	r0, r0, r0
    2fd0:	0014290b 	andseq	r2, r4, fp, lsl #18
    2fd4:	18100400 	ldmdane	r0, {sl}
    2fd8:	0000006a 	andeq	r0, r0, sl, rrx
    2fdc:	f7084000 			; <UNDEFINED> instruction: 0xf7084000
    2fe0:	04000012 	streq	r0, [r0], #-18	; 0xffffffee
    2fe4:	006a1813 	rsbeq	r1, sl, r3, lsl r8
    2fe8:	00000000 	andeq	r0, r0, r0
    2fec:	800b1ffe 	strdhi	r1, [fp], -lr
    2ff0:	04000010 	streq	r0, [r0], #-16
    2ff4:	006a1816 	rsbeq	r1, sl, r6, lsl r8
    2ff8:	7ff80000 	svcvc	0x00f80000
    2ffc:	01300a00 	teqeq	r0, r0, lsl #20
    3000:	400a0000 	andmi	r0, sl, r0
    3004:	0a000001 	beq	3010 <CPSR_IRQ_INHIBIT+0x2f90>
    3008:	00000150 	andeq	r0, r0, r0, asr r1
    300c:	00015e0a 	andeq	r5, r1, sl, lsl #28
    3010:	016e0a00 	cmneq	lr, r0, lsl #20
    3014:	720c0000 	andvc	r0, ip, #0
    3018:	ff000015 			; <UNDEFINED> instruction: 0xff000015
    301c:	0709050f 	streq	r0, [r9, -pc, lsl #10]
    3020:	00000230 	andeq	r0, r0, r0, lsr r2
    3024:	0014570d 	andseq	r5, r4, sp, lsl #14
    3028:	110c0500 	tstne	ip, r0, lsl #10
    302c:	00000230 	andeq	r0, r0, r0, lsr r2
    3030:	14520e00 	ldrbne	r0, [r2], #-3584	; 0xfffff200
    3034:	0e050000 	cdpeq	0, 0, cr0, cr5, cr0, {0}
    3038:	0015210e 	andseq	r2, r5, lr, lsl #2
    303c:	0001c500 	andeq	ip, r1, r0, lsl #10
    3040:	0001d500 	andeq	sp, r1, r0, lsl #10
    3044:	02410f00 	subeq	r0, r1, #0, 30
    3048:	5e100000 	cdppl	0, 1, cr0, cr0, cr0, {0}
    304c:	10000000 	andne	r0, r0, r0
    3050:	0000024c 	andeq	r0, r0, ip, asr #4
    3054:	15721100 	ldrbne	r1, [r2, #-256]!	; 0xffffff00
    3058:	11050000 	mrsne	r0, (UNDEF: 5)
    305c:	00153c09 	andseq	r3, r5, r9, lsl #24
    3060:	00024100 	andeq	r4, r2, r0, lsl #2
    3064:	01ee0100 	mvneq	r0, r0, lsl #2
    3068:	01f40000 	mvnseq	r0, r0
    306c:	410f0000 	mrsmi	r0, CPSR
    3070:	00000002 	andeq	r0, r0, r2
    3074:	00143711 	andseq	r3, r4, r1, lsl r7
    3078:	12140500 	andsne	r0, r4, #0, 10
    307c:	0000147e 	andeq	r1, r0, lr, ror r4
    3080:	0000005e 	andeq	r0, r0, lr, asr r0
    3084:	00020d01 	andeq	r0, r2, r1, lsl #26
    3088:	00021300 	andeq	r1, r2, r0, lsl #6
    308c:	02410f00 	subeq	r0, r1, #0, 30
    3090:	12000000 	andne	r0, r0, #0
    3094:	00001442 	andeq	r1, r0, r2, asr #8
    3098:	530e1605 	movwpl	r1, #58885	; 0xe605
    309c:	01000015 	tsteq	r0, r5, lsl r0
    30a0:	00000224 	andeq	r0, r0, r4, lsr #4
    30a4:	0002410f 	andeq	r4, r2, pc, lsl #2
    30a8:	005e1000 	subseq	r1, lr, r0
    30ac:	00000000 	andeq	r0, r0, r0
    30b0:	00003f13 	andeq	r3, r0, r3, lsl pc
    30b4:	00024100 	andeq	r4, r2, r0, lsl #2
    30b8:	006f1400 	rsbeq	r1, pc, r0, lsl #8
    30bc:	0ffe0000 	svceq	0x00fe0000
    30c0:	96041500 	strls	r1, [r4], -r0, lsl #10
    30c4:	03000001 	movweq	r0, #1
    30c8:	00000241 	andeq	r0, r0, r1, asr #4
    30cc:	32020102 	andcc	r0, r2, #-2147483648	; 0x80000000
    30d0:	16000003 	strne	r0, [r0], -r3
    30d4:	0000165e 	andeq	r1, r0, lr, asr r6
    30d8:	96161905 	ldrls	r1, [r6], -r5, lsl #18
    30dc:	17000001 	strne	r0, [r0, -r1]
    30e0:	000007f8 	strdeq	r0, [r0], -r8
    30e4:	07030618 	smladeq	r3, r8, r6, r0
    30e8:	000004f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    30ec:	00075418 	andeq	r5, r7, r8, lsl r4
    30f0:	6f040700 	svcvs	0x00040700
    30f4:	06000000 	streq	r0, [r0], -r0
    30f8:	8c011006 	stchi	0, cr1, [r1], {6}
    30fc:	19000002 	stmdbne	r0, {r1}
    3100:	00584548 	subseq	r4, r8, r8, asr #10
    3104:	45441910 	strbmi	r1, [r4, #-2320]	; 0xfffff6f0
    3108:	000a0043 	andeq	r0, sl, r3, asr #32
    310c:	00026c03 	andeq	r6, r2, r3, lsl #24
    3110:	07611a00 	strbeq	r1, [r1, -r0, lsl #20]!
    3114:	06080000 	streq	r0, [r8], -r0
    3118:	02b50c27 	adcseq	r0, r5, #9984	; 0x2700
    311c:	791b0000 	ldmdbvc	fp, {}	; <UNPREDICTABLE>
    3120:	16290600 	strtne	r0, [r9], -r0, lsl #12
    3124:	0000006f 	andeq	r0, r0, pc, rrx
    3128:	00781b00 	rsbseq	r1, r8, r0, lsl #22
    312c:	6f162a06 	svcvs	0x00162a06
    3130:	04000000 	streq	r0, [r0], #-0
    3134:	08ec1c00 	stmiaeq	ip!, {sl, fp, ip}^
    3138:	0c060000 	stceq	0, cr0, [r6], {-0}
    313c:	00028c1b 	andeq	r8, r2, fp, lsl ip
    3140:	1d0a0100 	stfnes	f0, [sl, #-0]
    3144:	0000085f 	andeq	r0, r0, pc, asr r8
    3148:	f6280d06 			; <UNDEFINED> instruction: 0xf6280d06
    314c:	01000004 	tsteq	r0, r4
    3150:	0007f81e 	andeq	pc, r7, lr, lsl r8	; <UNPREDICTABLE>
    3154:	0e100600 	cfmsub32eq	mvax0, mvfx0, mvfx0, mvfx0
    3158:	000008d9 	ldrdeq	r0, [r0], -r9
    315c:	000004fb 	strdeq	r0, [r0], -fp
    3160:	0002e901 	andeq	lr, r2, r1, lsl #18
    3164:	0002fe00 	andeq	pc, r2, r0, lsl #28
    3168:	04fb0f00 	ldrbteq	r0, [fp], #3840	; 0xf00
    316c:	6f100000 	svcvs	0x00100000
    3170:	10000000 	andne	r0, r0, r0
    3174:	0000006f 	andeq	r0, r0, pc, rrx
    3178:	00006f10 	andeq	r6, r0, r0, lsl pc
    317c:	0e1f0000 	cdpeq	0, 1, cr0, cr15, cr0, {0}
    3180:	0600000b 	streq	r0, [r0], -fp
    3184:	07c10a12 	bfieq	r0, r2, (invalid: 20:1)
    3188:	13010000 	movwne	r0, #4096	; 0x1000
    318c:	19000003 	stmdbne	r0, {r0, r1}
    3190:	0f000003 	svceq	0x00000003
    3194:	000004fb 	strdeq	r0, [r0], -fp
    3198:	08181100 	ldmdaeq	r8, {r8, ip}
    319c:	14060000 	strne	r0, [r6], #-0
    31a0:	00087c0f 	andeq	r7, r8, pc, lsl #24
    31a4:	00050100 	andeq	r0, r5, r0, lsl #2
    31a8:	03320100 	teqeq	r2, #0, 2
    31ac:	033d0000 	teqeq	sp, #0
    31b0:	fb0f0000 	blx	3c31ba <_bss_end+0x3b7356>
    31b4:	10000004 	andne	r0, r0, r4
    31b8:	00000025 	andeq	r0, r0, r5, lsr #32
    31bc:	08181100 	ldmdaeq	r8, {r8, ip}
    31c0:	15060000 	strne	r0, [r6, #-0]
    31c4:	0008230f 	andeq	r2, r8, pc, lsl #6
    31c8:	00050100 	andeq	r0, r5, r0, lsl #2
    31cc:	03560100 	cmpeq	r6, #0, 2
    31d0:	03610000 	cmneq	r1, #0
    31d4:	fb0f0000 	blx	3c31de <_bss_end+0x3b737a>
    31d8:	10000004 	andne	r0, r0, r4
    31dc:	000004f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    31e0:	08181100 	ldmdaeq	r8, {r8, ip}
    31e4:	16060000 	strne	r0, [r6], -r0
    31e8:	0007d60f 	andeq	sp, r7, pc, lsl #12
    31ec:	00050100 	andeq	r0, r5, r0, lsl #2
    31f0:	037a0100 	cmneq	sl, #0, 2
    31f4:	03850000 	orreq	r0, r5, #0
    31f8:	fb0f0000 	blx	3c3202 <_bss_end+0x3b739e>
    31fc:	10000004 	andne	r0, r0, r4
    3200:	0000026c 	andeq	r0, r0, ip, ror #4
    3204:	08181100 	ldmdaeq	r8, {r8, ip}
    3208:	17060000 	strne	r0, [r6, -r0]
    320c:	0008ab0f 	andeq	sl, r8, pc, lsl #22
    3210:	00050100 	andeq	r0, r5, r0, lsl #2
    3214:	039e0100 	orrseq	r0, lr, #0, 2
    3218:	03a90000 			; <UNDEFINED> instruction: 0x03a90000
    321c:	fb0f0000 	blx	3c3226 <_bss_end+0x3b73c2>
    3220:	10000004 	andne	r0, r0, r4
    3224:	0000006f 	andeq	r0, r0, pc, rrx
    3228:	08181100 	ldmdaeq	r8, {r8, ip}
    322c:	18060000 	stmdane	r6, {}	; <UNPREDICTABLE>
    3230:	00086b0f 	andeq	r6, r8, pc, lsl #22
    3234:	00050100 	andeq	r0, r5, r0, lsl #2
    3238:	03c20100 	biceq	r0, r2, #0, 2
    323c:	03cd0000 	biceq	r0, sp, #0
    3240:	fb0f0000 	blx	3c324a <_bss_end+0x3b73e6>
    3244:	10000004 	andne	r0, r0, r4
    3248:	0000024c 	andeq	r0, r0, ip, asr #4
    324c:	073f0e00 	ldreq	r0, [pc, -r0, lsl #28]!
    3250:	1b060000 	blne	183258 <_bss_end+0x1773f4>
    3254:	00070f11 	andeq	r0, r7, r1, lsl pc
    3258:	0003e100 	andeq	lr, r3, r0, lsl #2
    325c:	0003e700 	andeq	lr, r3, r0, lsl #14
    3260:	04fb0f00 	ldrbteq	r0, [fp], #3840	; 0xf00
    3264:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    3268:	00000732 	andeq	r0, r0, r2, lsr r7
    326c:	bc111c06 	ldclt	12, cr1, [r1], {6}
    3270:	fb000008 	blx	329a <CPSR_IRQ_INHIBIT+0x321a>
    3274:	01000003 	tsteq	r0, r3
    3278:	0f000004 	svceq	0x00000004
    327c:	000004fb 	strdeq	r0, [r0], -fp
    3280:	06d00e00 	ldrbeq	r0, [r0], r0, lsl #28
    3284:	1d060000 	stcne	0, cr0, [r6, #-0]
    3288:	00076b11 	andeq	r6, r7, r1, lsl fp
    328c:	00041500 	andeq	r1, r4, r0, lsl #10
    3290:	00041b00 	andeq	r1, r4, r0, lsl #22
    3294:	04fb0f00 	ldrbteq	r0, [fp], #3840	; 0xf00
    3298:	20000000 	andcs	r0, r0, r0
    329c:	0000074d 	andeq	r0, r0, sp, asr #14
    32a0:	01191f06 	tsteq	r9, r6, lsl #30
    32a4:	6f000008 	svcvs	0x00000008
    32a8:	33000000 	movwcc	r0, #0
    32ac:	43000004 	movwmi	r0, #4
    32b0:	0f000004 	svceq	0x00000004
    32b4:	000004fb 	strdeq	r0, [r0], -fp
    32b8:	00006f10 	andeq	r6, r0, r0, lsl pc
    32bc:	006f1000 	rsbeq	r1, pc, r0
    32c0:	20000000 	andcs	r0, r0, r0
    32c4:	00000983 	andeq	r0, r0, r3, lsl #19
    32c8:	e2192006 	ands	r2, r9, #6
    32cc:	6f000006 	svcvs	0x00000006
    32d0:	5b000000 	blpl	32d8 <CPSR_IRQ_INHIBIT+0x3258>
    32d4:	6b000004 	blvs	32ec <CPSR_IRQ_INHIBIT+0x326c>
    32d8:	0f000004 	svceq	0x00000004
    32dc:	000004fb 	strdeq	r0, [r0], -fp
    32e0:	00006f10 	andeq	r6, r0, r0, lsl pc
    32e4:	006f1000 	rsbeq	r1, pc, r0
    32e8:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    32ec:	000006ac 	andeq	r0, r0, ip, lsr #13
    32f0:	950a2206 	strls	r2, [sl, #-518]	; 0xfffffdfa
    32f4:	7f000008 	svcvc	0x00000008
    32f8:	85000004 	strhi	r0, [r0, #-4]
    32fc:	0f000004 	svceq	0x00000004
    3300:	000004fb 	strdeq	r0, [r0], -fp
    3304:	072d0e00 	streq	r0, [sp, -r0, lsl #28]!
    3308:	24060000 	strcs	r0, [r6], #-0
    330c:	0008360a 	andeq	r3, r8, sl, lsl #12
    3310:	00049900 	andeq	r9, r4, r0, lsl #18
    3314:	0004ae00 	andeq	sl, r4, r0, lsl #28
    3318:	04fb0f00 	ldrbteq	r0, [fp], #3840	; 0xf00
    331c:	6f100000 	svcvs	0x00100000
    3320:	10000000 	andne	r0, r0, r0
    3324:	00000507 	andeq	r0, r0, r7, lsl #10
    3328:	00006f10 	andeq	r6, r0, r0, lsl pc
    332c:	8d0d0000 	stchi	0, cr0, [sp, #-0]
    3330:	06000007 	streq	r0, [r0], -r7
    3334:	0513232e 	ldreq	r2, [r3, #-814]	; 0xfffffcd2
    3338:	0d000000 	stceq	0, cr0, [r0, #-0]
    333c:	0000088d 	andeq	r0, r0, sp, lsl #17
    3340:	6f122f06 	svcvs	0x00122f06
    3344:	04000000 	streq	r0, [r0], #-0
    3348:	00084d0d 	andeq	r4, r8, sp, lsl #26
    334c:	12300600 	eorsne	r0, r0, #0, 12
    3350:	0000006f 	andeq	r0, r0, pc, rrx
    3354:	08560d08 	ldmdaeq	r6, {r3, r8, sl, fp}^
    3358:	31060000 	mrscc	r0, (UNDEF: 6)
    335c:	0002910f 	andeq	r9, r2, pc, lsl #2
    3360:	c20d0c00 	andgt	r0, sp, #0, 24
    3364:	06000006 	streq	r0, [r0], -r6
    3368:	026c1232 	rsbeq	r1, ip, #536870915	; 0x20000003
    336c:	00140000 	andseq	r0, r4, r0
    3370:	002c0415 	eoreq	r0, ip, r5, lsl r4
    3374:	f0030000 			; <UNDEFINED> instruction: 0xf0030000
    3378:	15000004 	strne	r0, [r0, #-4]
    337c:	00025f04 	andeq	r5, r2, r4, lsl #30
    3380:	5f042100 	svcpl	0x00042100
    3384:	15000002 	strne	r0, [r0, #-2]
    3388:	00002504 	andeq	r2, r0, r4, lsl #10
    338c:	52041500 	andpl	r1, r4, #0, 10
    3390:	03000000 	movweq	r0, #0
    3394:	0000050d 	andeq	r0, r0, sp, lsl #10
    3398:	0007a616 	andeq	sl, r7, r6, lsl r6
    339c:	11350600 	teqne	r5, r0, lsl #12
    33a0:	0000025f 	andeq	r0, r0, pc, asr r2
    33a4:	00025322 	andeq	r5, r2, r2, lsr #6
    33a8:	0f040100 	svceq	0x00040100
    33ac:	ae480305 	cdpge	3, 4, cr0, cr8, cr5, {0}
    33b0:	4f230000 	svcmi	0x00230000
    33b4:	cc000016 	stcgt	0, cr0, [r0], {22}
    33b8:	1c00009f 	stcne	0, cr0, [r0], {159}	; 0x9f
    33bc:	01000000 	mrseq	r0, (UNDEF: 0)
    33c0:	054f249c 	strbeq	r2, [pc, #-1180]	; 2f2c <CPSR_IRQ_INHIBIT+0x2eac>
    33c4:	9f800000 	svcls	0x00800000
    33c8:	004c0000 	subeq	r0, ip, r0
    33cc:	9c010000 	stcls	0, cr0, [r1], {-0}
    33d0:	00000573 	andeq	r0, r0, r3, ror r5
    33d4:	00043225 	andeq	r3, r4, r5, lsr #4
    33d8:	016d0100 	cmneq	sp, r0, lsl #2
    33dc:	00000038 	andeq	r0, r0, r8, lsr r0
    33e0:	25749102 	ldrbcs	r9, [r4, #-258]!	; 0xfffffefe
    33e4:	000005ed 	andeq	r0, r0, sp, ror #11
    33e8:	38016d01 	stmdacc	r1, {r0, r8, sl, fp, sp, lr}
    33ec:	02000000 	andeq	r0, r0, #0
    33f0:	26007091 			; <UNDEFINED> instruction: 0x26007091
    33f4:	00000213 	andeq	r0, r0, r3, lsl r2
    33f8:	8d066801 	stchi	8, cr6, [r6, #-4]
    33fc:	48000005 	stmdami	r0, {r0, r2}
    3400:	3800009f 	stmdacc	r0, {r0, r1, r2, r3, r4, r7}
    3404:	01000000 	mrseq	r0, (UNDEF: 0)
    3408:	0005a89c 	muleq	r5, ip, r8
    340c:	05822700 	streq	r2, [r2, #1792]	; 0x700
    3410:	02470000 	subeq	r0, r7, #0
    3414:	91020000 	mrsls	r0, (UNDEF: 2)
    3418:	61662874 	smcvs	25220	; 0x6284
    341c:	28680100 	stmdacs	r8!, {r8}^
    3420:	0000005e 	andeq	r0, r0, lr, asr r0
    3424:	00709102 	rsbseq	r9, r0, r2, lsl #2
    3428:	0001f426 	andeq	pc, r1, r6, lsr #8
    342c:	0a400100 	beq	1003834 <_bss_end+0xff79d0>
    3430:	000005c2 	andeq	r0, r0, r2, asr #11
    3434:	00009d4c 	andeq	r9, r0, ip, asr #26
    3438:	000001fc 	strdeq	r0, [r0], -ip
    343c:	062a9c01 	strteq	r9, [sl], -r1, lsl #24
    3440:	82270000 	eorhi	r0, r7, #0
    3444:	47000005 	strmi	r0, [r0, -r5]
    3448:	02000002 	andeq	r0, r0, #2
    344c:	69295c91 	stmdbvs	r9!, {r0, r4, r7, sl, fp, ip, lr}
    3450:	0e450100 	dvfeqs	f0, f5, f0
    3454:	0000005e 	andeq	r0, r0, lr, asr r0
    3458:	29749102 	ldmdbcs	r4!, {r1, r8, ip, pc}^
    345c:	4501006a 	strmi	r0, [r1, #-106]	; 0xffffff96
    3460:	00005e11 	andeq	r5, r0, r1, lsl lr
    3464:	70910200 	addsvc	r0, r1, r0, lsl #4
    3468:	009dcc2a 	addseq	ip, sp, sl, lsr #24
    346c:	00013400 	andeq	r3, r1, r0, lsl #8
    3470:	16152b00 	ldrne	r2, [r5], -r0, lsl #22
    3474:	52010000 	andpl	r0, r1, #0
    3478:	00006a20 	andeq	r6, r0, r0, lsr #20
    347c:	6c910200 	lfmvs	f0, 4, [r1], {0}
    3480:	0015fe2b 	andseq	pc, r5, fp, lsr #28
    3484:	20530100 	subscs	r0, r3, r0, lsl #2
    3488:	0000006a 	andeq	r0, r0, sl, rrx
    348c:	2a689102 	bcs	1a2789c <_bss_end+0x1a1ba38>
    3490:	00009e04 	andeq	r9, r0, r4, lsl #28
    3494:	000000fc 	strdeq	r0, [r0], -ip
    3498:	00161a2b 	andseq	r1, r6, fp, lsr #20
    349c:	24580100 	ldrbcs	r0, [r8], #-256	; 0xffffff00
    34a0:	0000006a 	andeq	r0, r0, sl, rrx
    34a4:	00649102 	rsbeq	r9, r4, r2, lsl #2
    34a8:	b1260000 			; <UNDEFINED> instruction: 0xb1260000
    34ac:	01000001 	tsteq	r0, r1
    34b0:	06440638 			; <UNDEFINED> instruction: 0x06440638
    34b4:	9c780000 	ldclls	0, cr0, [r8], #-0
    34b8:	00d40000 	sbcseq	r0, r4, r0
    34bc:	9c010000 	stcls	0, cr0, [r1], {-0}
    34c0:	0000066f 	andeq	r0, r0, pc, ror #12
    34c4:	00058227 	andeq	r8, r5, r7, lsr #4
    34c8:	00024700 	andeq	r4, r2, r0, lsl #14
    34cc:	6c910200 	lfmvs	f0, 4, [r1], {0}
    34d0:	00161a25 	andseq	r1, r6, r5, lsr #20
    34d4:	23380100 	teqcs	r8, #0, 2
    34d8:	0000005e 	andeq	r0, r0, lr, asr r0
    34dc:	25689102 	strbcs	r9, [r8, #-258]!	; 0xfffffefe
    34e0:	00001637 	andeq	r1, r0, r7, lsr r6
    34e4:	4c323801 	ldcmi	8, cr3, [r2], #-4
    34e8:	02000002 	andeq	r0, r0, #2
    34ec:	2c006791 	stccs	7, cr6, [r0], {145}	; 0x91
    34f0:	000001d5 	ldrdeq	r0, [r0], -r5
    34f4:	80012f01 	andhi	r2, r1, r1, lsl #30
    34f8:	00000006 	andeq	r0, r0, r6
    34fc:	00000696 	muleq	r0, r6, r6
    3500:	0005822d 	andeq	r8, r5, sp, lsr #4
    3504:	00024700 	andeq	r4, r2, r0, lsl #14
    3508:	692f2e00 	stmdbvs	pc!, {r9, sl, fp, sp}	; <UNPREDICTABLE>
    350c:	0e320100 	rsfeqs	f0, f2, f0
    3510:	00000038 	andeq	r0, r0, r8, lsr r0
    3514:	6f300000 	svcvs	0x00300000
    3518:	de000006 	cdple	0, 0, cr0, cr0, cr6, {0}
    351c:	b1000015 	tstlt	r0, r5, lsl r0
    3520:	14000006 	strne	r0, [r0], #-6
    3524:	6400009c 	strvs	r0, [r0], #-156	; 0xffffff64
    3528:	01000000 	mrseq	r0, (UNDEF: 0)
    352c:	0006df9c 	muleq	r6, ip, pc	; <UNPREDICTABLE>
    3530:	06803100 	streq	r3, [r0], r0, lsl #2
    3534:	91020000 	mrsls	r0, (UNDEF: 2)
    3538:	0689326c 	streq	r3, [r9], ip, ror #4
    353c:	06c80000 	strbeq	r0, [r8], r0
    3540:	8a330000 	bhi	cc3548 <_bss_end+0xcb76e4>
    3544:	00000006 	andeq	r0, r0, r6
    3548:	00068934 	andeq	r8, r6, r4, lsr r9
    354c:	009c2400 	addseq	r2, ip, r0, lsl #8
    3550:	00003c00 	andeq	r3, r0, r0, lsl #24
    3554:	068a3500 	streq	r3, [sl], r0, lsl #10
    3558:	91020000 	mrsls	r0, (UNDEF: 2)
    355c:	36000074 			; <UNDEFINED> instruction: 0x36000074
    3560:	00001608 	andeq	r1, r0, r8, lsl #12
    3564:	3c0a1c01 	stccc	12, cr1, [sl], {1}
    3568:	6f000016 	svcvs	0x00000016
    356c:	84000000 	strhi	r0, [r0], #-0
    3570:	9000009b 	mulls	r0, fp, r0
    3574:	01000000 	mrseq	r0, (UNDEF: 0)
    3578:	00072b9c 	muleq	r7, ip, fp
    357c:	15f52500 	ldrbne	r2, [r5, #1280]!	; 0x500
    3580:	1c010000 	stcne	0, cr0, [r1], {-0}
    3584:	00006f20 	andeq	r6, r0, r0, lsr #30
    3588:	6c910200 	lfmvs	f0, 4, [r1], {0}
    358c:	00162325 	andseq	r2, r6, r5, lsr #6
    3590:	331c0100 	tstcc	ip, #0, 2
    3594:	0000006f 	andeq	r0, r0, pc, rrx
    3598:	2b689102 	blcs	1a279a8 <_bss_end+0x1a1bb44>
    359c:	00001603 	andeq	r1, r0, r3, lsl #12
    35a0:	6f0e1d01 	svcvs	0x000e1d01
    35a4:	02000000 	andeq	r0, r0, #0
    35a8:	37007491 			; <UNDEFINED> instruction: 0x37007491
    35ac:	0000162b 	andeq	r1, r0, fp, lsr #12
    35b0:	6f110601 	svcvs	0x00110601
    35b4:	d4000000 	strle	r0, [r0], #-0
    35b8:	b000009a 	mullt	r0, sl, r0
    35bc:	01000000 	mrseq	r0, (UNDEF: 0)
    35c0:	15f5259c 	ldrbne	r2, [r5, #1436]!	; 0x59c
    35c4:	06010000 	streq	r0, [r1], -r0
    35c8:	00006f26 	andeq	r6, r0, r6, lsr #30
    35cc:	6c910200 	lfmvs	f0, 4, [r1], {0}
    35d0:	00162325 	andseq	r2, r6, r5, lsr #6
    35d4:	39060100 	stmdbcc	r6, {r8}
    35d8:	0000006f 	andeq	r0, r0, pc, rrx
    35dc:	2b689102 	blcs	1a279ec <_bss_end+0x1a1bb88>
    35e0:	000006b9 			; <UNDEFINED> instruction: 0x000006b9
    35e4:	6f0e0701 	svcvs	0x000e0701
    35e8:	02000000 	andeq	r0, r0, #0
    35ec:	032b7491 			; <UNDEFINED> instruction: 0x032b7491
    35f0:	01000016 	tsteq	r0, r6, lsl r0
    35f4:	006f0e08 	rsbeq	r0, pc, r8, lsl #28
    35f8:	91020000 	mrsls	r0, (UNDEF: 2)
    35fc:	8d000070 	stchi	0, cr0, [r0, #-448]	; 0xfffffe40
    3600:	0400000a 	streq	r0, [r0], #-10
    3604:	00141b00 	andseq	r1, r4, r0, lsl #22
    3608:	00010400 	andeq	r0, r1, r0, lsl #8
    360c:	04000000 	streq	r0, [r0], #-0
    3610:	00001729 	andeq	r1, r0, r9, lsr #14
    3614:	000000b6 	strheq	r0, [r0], -r6
    3618:	00000038 	andeq	r0, r0, r8, lsr r0
    361c:	00000000 	andeq	r0, r0, r0
    3620:	00001637 	andeq	r1, r0, r7, lsr r6
    3624:	a0080102 	andge	r0, r8, r2, lsl #2
    3628:	03000004 	movweq	r0, #4
    362c:	00000025 	andeq	r0, r0, r5, lsr #32
    3630:	80050202 	andhi	r0, r5, r2, lsl #4
    3634:	04000002 	streq	r0, [r0], #-2
    3638:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
    363c:	59050074 	stmdbpl	r5, {r2, r4, r5, r6}
    3640:	0300000a 	movweq	r0, #10
    3644:	004b0709 	subeq	r0, fp, r9, lsl #14
    3648:	01020000 	mrseq	r0, (UNDEF: 2)
    364c:	00049708 	andeq	r9, r4, r8, lsl #14
    3650:	004b0600 	subeq	r0, fp, r0, lsl #12
    3654:	02020000 	andeq	r0, r2, #0
    3658:	00050207 	andeq	r0, r5, r7, lsl #4
    365c:	03290500 			; <UNDEFINED> instruction: 0x03290500
    3660:	0b030000 	bleq	c3668 <_bss_end+0xb7804>
    3664:	00006f07 	andeq	r6, r0, r7, lsl #30
    3668:	005e0300 	subseq	r0, lr, r0, lsl #6
    366c:	04020000 	streq	r0, [r2], #-0
    3670:	001ef907 	andseq	pc, lr, r7, lsl #18
    3674:	006f0300 	rsbeq	r0, pc, r0, lsl #6
    3678:	b0070000 	andlt	r0, r7, r0
    367c:	05000011 	streq	r0, [r0, #-17]	; 0xffffffef
    3680:	00003804 	andeq	r3, r0, r4, lsl #16
    3684:	0c040400 	cfstrseq	mvf0, [r4], {-0}
    3688:	000000a6 	andeq	r0, r0, r6, lsr #1
    368c:	77654e08 	strbvc	r4, [r5, -r8, lsl #28]!
    3690:	93090000 	movwls	r0, #36864	; 0x9000
    3694:	01000012 	tsteq	r0, r2, lsl r0
    3698:	000c0609 	andeq	r0, ip, r9, lsl #12
    369c:	26090200 	strcs	r0, [r9], -r0, lsl #4
    36a0:	03000012 	movweq	r0, #18
    36a4:	11340a00 	teqne	r4, r0, lsl #20
    36a8:	040c0000 	streq	r0, [ip], #-0
    36ac:	00d80811 	sbcseq	r0, r8, r1, lsl r8
    36b0:	6c0b0000 	stcvs	0, cr0, [fp], {-0}
    36b4:	13040072 	movwne	r0, #16498	; 0x4072
    36b8:	0000d813 	andeq	sp, r0, r3, lsl r8
    36bc:	730b0000 	movwvc	r0, #45056	; 0xb000
    36c0:	14040070 	strne	r0, [r4], #-112	; 0xffffff90
    36c4:	0000d813 	andeq	sp, r0, r3, lsl r8
    36c8:	700b0400 	andvc	r0, fp, r0, lsl #8
    36cc:	15040063 	strne	r0, [r4, #-99]	; 0xffffff9d
    36d0:	0000d813 	andeq	sp, r0, r3, lsl r8
    36d4:	02000800 	andeq	r0, r0, #0, 16
    36d8:	1ef40704 	cdpne	7, 15, cr0, cr4, cr4, {0}
    36dc:	d8030000 	stmdale	r3, {}	; <UNPREDICTABLE>
    36e0:	0a000000 	beq	36e8 <CPSR_IRQ_INHIBIT+0x3668>
    36e4:	0000130d 	andeq	r1, r0, sp, lsl #6
    36e8:	081b041c 	ldmdaeq	fp, {r2, r3, r4, sl}
    36ec:	00000133 	andeq	r0, r0, r3, lsr r1
    36f0:	0012eb0c 	andseq	lr, r2, ip, lsl #22
    36f4:	121d0400 	andsne	r0, sp, #0, 8
    36f8:	000000a6 	andeq	r0, r0, r6, lsr #1
    36fc:	69700b00 	ldmdbvs	r0!, {r8, r9, fp}^
    3700:	1e040064 	cdpne	0, 0, cr0, cr4, cr4, {3}
    3704:	00006f12 	andeq	r6, r0, r2, lsl pc
    3708:	450c0c00 	strmi	r0, [ip, #-3072]	; 0xfffff400
    370c:	0400001c 	streq	r0, [r0], #-28	; 0xffffffe4
    3710:	007b111f 	rsbseq	r1, fp, pc, lsl r1
    3714:	0c100000 	ldceq	0, cr0, [r0], {-0}
    3718:	0000124e 	andeq	r1, r0, lr, asr #4
    371c:	6f122004 	svcvs	0x00122004
    3720:	14000000 	strne	r0, [r0], #-0
    3724:	0011bc0c 	andseq	fp, r1, ip, lsl #24
    3728:	12210400 	eorne	r0, r1, #0, 8
    372c:	0000006f 	andeq	r0, r0, pc, rrx
    3730:	4d0a0018 	stcmi	0, cr0, [sl, #-96]	; 0xffffffa0
    3734:	0c000013 	stceq	0, cr0, [r0], {19}
    3738:	68080705 	stmdavs	r8, {r0, r2, r8, r9, sl}
    373c:	0c000001 	stceq	0, cr0, [r0], {1}
    3740:	0000107b 	andeq	r1, r0, fp, ror r0
    3744:	68190905 	ldmdavs	r9, {r0, r2, r8, fp}
    3748:	00000001 	andeq	r0, r0, r1
    374c:	0010df0c 	andseq	sp, r0, ip, lsl #30
    3750:	190a0500 	stmdbne	sl, {r8, sl}
    3754:	00000168 	andeq	r0, r0, r8, ror #2
    3758:	13080c04 	movwne	r0, #35844	; 0x8c04
    375c:	0b050000 	bleq	143764 <_bss_end+0x137900>
    3760:	00016e13 	andeq	r6, r1, r3, lsl lr
    3764:	0d000800 	stceq	8, cr0, [r0, #-0]
    3768:	00013304 	andeq	r3, r1, r4, lsl #6
    376c:	e4040d00 	str	r0, [r4], #-3328	; 0xfffff300
    3770:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    3774:	0000111b 	andeq	r1, r0, fp, lsl r1
    3778:	070e050c 	streq	r0, [lr, -ip, lsl #10]
    377c:	0000025c 	andeq	r0, r0, ip, asr r2
    3780:	00121c0c 	andseq	r1, r2, ip, lsl #24
    3784:	12120500 	andsne	r0, r2, #0, 10
    3788:	0000005e 	andeq	r0, r0, lr, asr r0
    378c:	10c10c00 	sbcne	r0, r1, r0, lsl #24
    3790:	15050000 	strne	r0, [r5, #-0]
    3794:	0001681d 	andeq	r6, r1, sp, lsl r8
    3798:	d80c0400 	stmdale	ip, {sl}
    379c:	05000012 	streq	r0, [r0, #-18]	; 0xffffffee
    37a0:	01681d18 	cmneq	r8, r8, lsl sp
    37a4:	0f080000 	svceq	0x00080000
    37a8:	0000138e 	andeq	r1, r0, lr, lsl #7
    37ac:	2a0e1b05 	bcs	38a3c8 <_bss_end+0x37e564>
    37b0:	bc000013 	stclt	0, cr0, [r0], {19}
    37b4:	c7000001 	strgt	r0, [r0, -r1]
    37b8:	10000001 	andne	r0, r0, r1
    37bc:	00000261 	andeq	r0, r0, r1, ror #4
    37c0:	00016811 	andeq	r6, r1, r1, lsl r8
    37c4:	1b120000 	blne	4837cc <_bss_end+0x477968>
    37c8:	05000011 	streq	r0, [r0, #-17]	; 0xffffffef
    37cc:	114b091e 	cmpne	fp, lr, lsl r9
    37d0:	02610000 	rsbeq	r0, r1, #0
    37d4:	e0010000 	and	r0, r1, r0
    37d8:	e6000001 	str	r0, [r0], -r1
    37dc:	10000001 	andne	r0, r0, r1
    37e0:	00000261 	andeq	r0, r0, r1, ror #4
    37e4:	137a1300 	cmnne	sl, #0, 6
    37e8:	21050000 	mrscs	r0, (UNDEF: 5)
    37ec:	00108a0e 	andseq	r8, r0, lr, lsl #20
    37f0:	01fb0100 	mvnseq	r0, r0, lsl #2
    37f4:	02010000 	andeq	r0, r1, #0
    37f8:	61100000 	tstvs	r0, r0
    37fc:	00000002 	andeq	r0, r0, r2
    3800:	00110c12 	andseq	r0, r1, r2, lsl ip
    3804:	12240500 	eorne	r0, r4, #0, 10
    3808:	000010e4 	andeq	r1, r0, r4, ror #1
    380c:	0000005e 	andeq	r0, r0, lr, asr r0
    3810:	00021a01 	andeq	r1, r2, r1, lsl #20
    3814:	00022500 	andeq	r2, r2, r0, lsl #10
    3818:	02611000 	rsbeq	r1, r1, #0
    381c:	d8110000 	ldmdale	r1, {}	; <UNPREDICTABLE>
    3820:	00000000 	andeq	r0, r0, r0
    3824:	00131a13 	andseq	r1, r3, r3, lsl sl
    3828:	0e270500 	cfsh64eq	mvdx0, mvdx7, #0
    382c:	0000122d 	andeq	r1, r0, sp, lsr #4
    3830:	00023a01 	andeq	r3, r2, r1, lsl #20
    3834:	00024000 	andeq	r4, r2, r0
    3838:	02611000 	rsbeq	r1, r1, #0
    383c:	14000000 	strne	r0, [r0], #-0
    3840:	00001165 	andeq	r1, r0, r5, ror #2
    3844:	aa172a05 	bge	5ce060 <_bss_end+0x5c21fc>
    3848:	6e000012 	mcrvs	0, 0, r0, cr0, cr2, {0}
    384c:	01000001 	tsteq	r0, r1
    3850:	00000255 	andeq	r0, r0, r5, asr r2
    3854:	00026c10 	andeq	r6, r2, r0, lsl ip
    3858:	03000000 	movweq	r0, #0
    385c:	00000174 	andeq	r0, r0, r4, ror r1
    3860:	0174040d 	cmneq	r4, sp, lsl #8
    3864:	61030000 	mrsvs	r0, (UNDEF: 3)
    3868:	0d000002 	stceq	0, cr0, [r0, #-8]
    386c:	00025c04 	andeq	r5, r2, r4, lsl #24
    3870:	026c0300 	rsbeq	r0, ip, #0, 6
    3874:	fa150000 	blx	54387c <_bss_end+0x537a18>
    3878:	05000016 	streq	r0, [r0, #-22]	; 0xffffffea
    387c:	0174192d 	cmneq	r4, sp, lsr #18
    3880:	f80e0000 			; <UNDEFINED> instruction: 0xf80e0000
    3884:	18000007 	stmdane	r0, {r0, r1, r2}
    3888:	14070306 	strne	r0, [r7], #-774	; 0xfffffcfa
    388c:	16000005 	strne	r0, [r0], -r5
    3890:	00000754 	andeq	r0, r0, r4, asr r7
    3894:	006f0407 	rsbeq	r0, pc, r7, lsl #8
    3898:	06060000 	streq	r0, [r6], -r0
    389c:	02b00110 	adcseq	r0, r0, #16, 2
    38a0:	48080000 	stmdami	r8, {}	; <UNPREDICTABLE>
    38a4:	10005845 	andne	r5, r0, r5, asr #16
    38a8:	43454408 	movtmi	r4, #21512	; 0x5408
    38ac:	03000a00 	movweq	r0, #2560	; 0xa00
    38b0:	00000290 	muleq	r0, r0, r2
    38b4:	0007610a 	andeq	r6, r7, sl, lsl #2
    38b8:	27060800 	strcs	r0, [r6, -r0, lsl #16]
    38bc:	0002d90c 	andeq	sp, r2, ip, lsl #18
    38c0:	00790b00 	rsbseq	r0, r9, r0, lsl #22
    38c4:	6f162906 	svcvs	0x00162906
    38c8:	00000000 	andeq	r0, r0, r0
    38cc:	0600780b 	streq	r7, [r0], -fp, lsl #16
    38d0:	006f162a 	rsbeq	r1, pc, sl, lsr #12
    38d4:	00040000 	andeq	r0, r4, r0
    38d8:	0008ec17 	andeq	lr, r8, r7, lsl ip
    38dc:	1b0c0600 	blne	3050e4 <_bss_end+0x2f9280>
    38e0:	000002b0 			; <UNDEFINED> instruction: 0x000002b0
    38e4:	5f180a01 	svcpl	0x00180a01
    38e8:	06000008 	streq	r0, [r0], -r8
    38ec:	051a280d 	ldreq	r2, [sl, #-2061]	; 0xfffff7f3
    38f0:	19010000 	stmdbne	r1, {}	; <UNPREDICTABLE>
    38f4:	000007f8 	strdeq	r0, [r0], -r8
    38f8:	d90e1006 	stmdble	lr, {r1, r2, ip}
    38fc:	1f000008 	svcne	0x00000008
    3900:	01000005 	tsteq	r0, r5
    3904:	0000030d 	andeq	r0, r0, sp, lsl #6
    3908:	00000322 	andeq	r0, r0, r2, lsr #6
    390c:	00051f10 	andeq	r1, r5, r0, lsl pc
    3910:	006f1100 	rsbeq	r1, pc, r0, lsl #2
    3914:	6f110000 	svcvs	0x00110000
    3918:	11000000 	mrsne	r0, (UNDEF: 0)
    391c:	0000006f 	andeq	r0, r0, pc, rrx
    3920:	0b0e1300 	bleq	388528 <_bss_end+0x37c6c4>
    3924:	12060000 	andne	r0, r6, #0
    3928:	0007c10a 	andeq	ip, r7, sl, lsl #2
    392c:	03370100 	teqeq	r7, #0, 2
    3930:	033d0000 	teqeq	sp, #0
    3934:	1f100000 	svcne	0x00100000
    3938:	00000005 	andeq	r0, r0, r5
    393c:	00081812 	andeq	r1, r8, r2, lsl r8
    3940:	0f140600 	svceq	0x00140600
    3944:	0000087c 	andeq	r0, r0, ip, ror r8
    3948:	00000525 	andeq	r0, r0, r5, lsr #10
    394c:	00035601 	andeq	r5, r3, r1, lsl #12
    3950:	00036100 	andeq	r6, r3, r0, lsl #2
    3954:	051f1000 	ldreq	r1, [pc, #-0]	; 395c <CPSR_IRQ_INHIBIT+0x38dc>
    3958:	25110000 	ldrcs	r0, [r1, #-0]
    395c:	00000000 	andeq	r0, r0, r0
    3960:	00081812 	andeq	r1, r8, r2, lsl r8
    3964:	0f150600 	svceq	0x00150600
    3968:	00000823 	andeq	r0, r0, r3, lsr #16
    396c:	00000525 	andeq	r0, r0, r5, lsr #10
    3970:	00037a01 	andeq	r7, r3, r1, lsl #20
    3974:	00038500 	andeq	r8, r3, r0, lsl #10
    3978:	051f1000 	ldreq	r1, [pc, #-0]	; 3980 <CPSR_IRQ_INHIBIT+0x3900>
    397c:	14110000 	ldrne	r0, [r1], #-0
    3980:	00000005 	andeq	r0, r0, r5
    3984:	00081812 	andeq	r1, r8, r2, lsl r8
    3988:	0f160600 	svceq	0x00160600
    398c:	000007d6 	ldrdeq	r0, [r0], -r6
    3990:	00000525 	andeq	r0, r0, r5, lsr #10
    3994:	00039e01 	andeq	r9, r3, r1, lsl #28
    3998:	0003a900 	andeq	sl, r3, r0, lsl #18
    399c:	051f1000 	ldreq	r1, [pc, #-0]	; 39a4 <CPSR_IRQ_INHIBIT+0x3924>
    39a0:	90110000 	andsls	r0, r1, r0
    39a4:	00000002 	andeq	r0, r0, r2
    39a8:	00081812 	andeq	r1, r8, r2, lsl r8
    39ac:	0f170600 	svceq	0x00170600
    39b0:	000008ab 	andeq	r0, r0, fp, lsr #17
    39b4:	00000525 	andeq	r0, r0, r5, lsr #10
    39b8:	0003c201 	andeq	ip, r3, r1, lsl #4
    39bc:	0003cd00 	andeq	ip, r3, r0, lsl #26
    39c0:	051f1000 	ldreq	r1, [pc, #-0]	; 39c8 <CPSR_IRQ_INHIBIT+0x3948>
    39c4:	6f110000 	svcvs	0x00110000
    39c8:	00000000 	andeq	r0, r0, r0
    39cc:	00081812 	andeq	r1, r8, r2, lsl r8
    39d0:	0f180600 	svceq	0x00180600
    39d4:	0000086b 	andeq	r0, r0, fp, ror #16
    39d8:	00000525 	andeq	r0, r0, r5, lsr #10
    39dc:	0003e601 	andeq	lr, r3, r1, lsl #12
    39e0:	0003f100 	andeq	pc, r3, r0, lsl #2
    39e4:	051f1000 	ldreq	r1, [pc, #-0]	; 39ec <CPSR_IRQ_INHIBIT+0x396c>
    39e8:	2b110000 	blcs	4439f0 <_bss_end+0x437b8c>
    39ec:	00000005 	andeq	r0, r0, r5
    39f0:	00073f0f 	andeq	r3, r7, pc, lsl #30
    39f4:	111b0600 	tstne	fp, r0, lsl #12
    39f8:	0000070f 	andeq	r0, r0, pc, lsl #14
    39fc:	00000405 	andeq	r0, r0, r5, lsl #8
    3a00:	0000040b 	andeq	r0, r0, fp, lsl #8
    3a04:	00051f10 	andeq	r1, r5, r0, lsl pc
    3a08:	320f0000 	andcc	r0, pc, #0
    3a0c:	06000007 	streq	r0, [r0], -r7
    3a10:	08bc111c 	ldmeq	ip!, {r2, r3, r4, r8, ip}
    3a14:	041f0000 	ldreq	r0, [pc], #-0	; 3a1c <CPSR_IRQ_INHIBIT+0x399c>
    3a18:	04250000 	strteq	r0, [r5], #-0
    3a1c:	1f100000 	svcne	0x00100000
    3a20:	00000005 	andeq	r0, r0, r5
    3a24:	0006d00f 	andeq	sp, r6, pc
    3a28:	111d0600 	tstne	sp, r0, lsl #12
    3a2c:	0000076b 	andeq	r0, r0, fp, ror #14
    3a30:	00000439 	andeq	r0, r0, r9, lsr r4
    3a34:	0000043f 	andeq	r0, r0, pc, lsr r4
    3a38:	00051f10 	andeq	r1, r5, r0, lsl pc
    3a3c:	4d1a0000 	ldcmi	0, cr0, [sl, #-0]
    3a40:	06000007 	streq	r0, [r0], -r7
    3a44:	0801191f 	stmdaeq	r1, {r0, r1, r2, r3, r4, r8, fp, ip}
    3a48:	006f0000 	rsbeq	r0, pc, r0
    3a4c:	04570000 	ldrbeq	r0, [r7], #-0
    3a50:	04670000 	strbteq	r0, [r7], #-0
    3a54:	1f100000 	svcne	0x00100000
    3a58:	11000005 	tstne	r0, r5
    3a5c:	0000006f 	andeq	r0, r0, pc, rrx
    3a60:	00006f11 	andeq	r6, r0, r1, lsl pc
    3a64:	831a0000 	tsthi	sl, #0
    3a68:	06000009 	streq	r0, [r0], -r9
    3a6c:	06e21920 	strbteq	r1, [r2], r0, lsr #18
    3a70:	006f0000 	rsbeq	r0, pc, r0
    3a74:	047f0000 	ldrbteq	r0, [pc], #-0	; 3a7c <CPSR_IRQ_INHIBIT+0x39fc>
    3a78:	048f0000 	streq	r0, [pc], #0	; 3a80 <CPSR_IRQ_INHIBIT+0x3a00>
    3a7c:	1f100000 	svcne	0x00100000
    3a80:	11000005 	tstne	r0, r5
    3a84:	0000006f 	andeq	r0, r0, pc, rrx
    3a88:	00006f11 	andeq	r6, r0, r1, lsl pc
    3a8c:	ac0f0000 	stcge	0, cr0, [pc], {-0}
    3a90:	06000006 	streq	r0, [r0], -r6
    3a94:	08950a22 	ldmeq	r5, {r1, r5, r9, fp}
    3a98:	04a30000 	strteq	r0, [r3], #0
    3a9c:	04a90000 	strteq	r0, [r9], #0
    3aa0:	1f100000 	svcne	0x00100000
    3aa4:	00000005 	andeq	r0, r0, r5
    3aa8:	00072d0f 	andeq	r2, r7, pc, lsl #26
    3aac:	0a240600 	beq	9052b4 <_bss_end+0x8f9450>
    3ab0:	00000836 	andeq	r0, r0, r6, lsr r8
    3ab4:	000004bd 			; <UNDEFINED> instruction: 0x000004bd
    3ab8:	000004d2 	ldrdeq	r0, [r0], -r2
    3abc:	00051f10 	andeq	r1, r5, r0, lsl pc
    3ac0:	006f1100 	rsbeq	r1, pc, r0, lsl #2
    3ac4:	32110000 	andscc	r0, r1, #0
    3ac8:	11000005 	tstne	r0, r5
    3acc:	0000006f 	andeq	r0, r0, pc, rrx
    3ad0:	078d0c00 	streq	r0, [sp, r0, lsl #24]
    3ad4:	2e060000 	cdpcs	0, 0, cr0, cr6, cr0, {0}
    3ad8:	00053e23 	andeq	r3, r5, r3, lsr #28
    3adc:	8d0c0000 	stchi	0, cr0, [ip, #-0]
    3ae0:	06000008 	streq	r0, [r0], -r8
    3ae4:	006f122f 	rsbeq	r1, pc, pc, lsr #4
    3ae8:	0c040000 	stceq	0, cr0, [r4], {-0}
    3aec:	0000084d 	andeq	r0, r0, sp, asr #16
    3af0:	6f123006 	svcvs	0x00123006
    3af4:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    3af8:	0008560c 	andeq	r5, r8, ip, lsl #12
    3afc:	0f310600 	svceq	0x00310600
    3b00:	000002b5 			; <UNDEFINED> instruction: 0x000002b5
    3b04:	06c20c0c 	strbeq	r0, [r2], ip, lsl #24
    3b08:	32060000 	andcc	r0, r6, #0
    3b0c:	00029012 	andeq	r9, r2, r2, lsl r0
    3b10:	0d001400 	cfstrseq	mvf1, [r0, #-0]
    3b14:	00002c04 	andeq	r2, r0, r4, lsl #24
    3b18:	05140300 	ldreq	r0, [r4, #-768]	; 0xfffffd00
    3b1c:	040d0000 	streq	r0, [sp], #-0
    3b20:	00000283 	andeq	r0, r0, r3, lsl #5
    3b24:	0283041b 	addeq	r0, r3, #452984832	; 0x1b000000
    3b28:	01020000 	mrseq	r0, (UNDEF: 2)
    3b2c:	00033202 	andeq	r3, r3, r2, lsl #4
    3b30:	25040d00 	strcs	r0, [r4, #-3328]	; 0xfffff300
    3b34:	0d000000 	stceq	0, cr0, [r0, #-0]
    3b38:	00005204 	andeq	r5, r0, r4, lsl #4
    3b3c:	05380300 	ldreq	r0, [r8, #-768]!	; 0xfffffd00
    3b40:	a6150000 	ldrge	r0, [r5], -r0
    3b44:	06000007 	streq	r0, [r0], -r7
    3b48:	02831135 	addeq	r1, r3, #1073741837	; 0x4000000d
    3b4c:	600a0000 	andvs	r0, sl, r0
    3b50:	10000013 	andne	r0, r0, r3, lsl r0
    3b54:	91080802 	tstls	r8, r2, lsl #16
    3b58:	0c000005 	stceq	0, cr0, [r0], {5}
    3b5c:	0000107b 	andeq	r1, r0, fp, ror r0
    3b60:	91200a02 			; <UNDEFINED> instruction: 0x91200a02
    3b64:	00000005 	andeq	r0, r0, r5
    3b68:	0010df0c 	andseq	sp, r0, ip, lsl #30
    3b6c:	200b0200 	andcs	r0, fp, r0, lsl #4
    3b70:	00000591 	muleq	r0, r1, r5
    3b74:	11a60c04 			; <UNDEFINED> instruction: 0x11a60c04
    3b78:	0c020000 	stceq	0, cr0, [r2], {-0}
    3b7c:	00005e0e 	andeq	r5, r0, lr, lsl #28
    3b80:	2c0c0800 	stccs	8, cr0, [ip], {-0}
    3b84:	02000011 	andeq	r0, r0, #17
    3b88:	052b0a0d 	streq	r0, [fp, #-2573]!	; 0xfffff5f3
    3b8c:	000c0000 	andeq	r0, ip, r0
    3b90:	054f040d 	strbeq	r0, [pc, #-1037]	; 378b <CPSR_IRQ_INHIBIT+0x370b>
    3b94:	7e0e0000 	cdpvc	0, 0, cr0, cr14, cr0, {0}
    3b98:	04000012 	streq	r0, [r0], #-18	; 0xffffffee
    3b9c:	7b071002 	blvc	1c7bac <_bss_end+0x1bbd48>
    3ba0:	0c000006 	stceq	0, cr0, [r0], {6}
    3ba4:	00001323 	andeq	r1, r0, r3, lsr #6
    3ba8:	91241302 			; <UNDEFINED> instruction: 0x91241302
    3bac:	00000005 	andeq	r0, r0, r5
    3bb0:	0013981a 	andseq	r9, r3, sl, lsl r8
    3bb4:	24150200 	ldrcs	r0, [r5], #-512	; 0xfffffe00
    3bb8:	00001179 	andeq	r1, r0, r9, ror r1
    3bbc:	00000591 	muleq	r0, r1, r5
    3bc0:	000005c9 	andeq	r0, r0, r9, asr #11
    3bc4:	000005cf 	andeq	r0, r0, pc, asr #11
    3bc8:	00067b10 	andeq	r7, r6, r0, lsl fp
    3bcc:	7e120000 	cdpvc	0, 1, cr0, cr2, cr0, {0}
    3bd0:	02000012 	andeq	r0, r0, #18
    3bd4:	11fe0918 	mvnsne	r0, r8, lsl r9
    3bd8:	067b0000 	ldrbteq	r0, [fp], -r0
    3bdc:	e8010000 	stmda	r1, {}	; <UNPREDICTABLE>
    3be0:	ee000005 	cdp	0, 0, cr0, cr0, cr5, {0}
    3be4:	10000005 	andne	r0, r0, r5
    3be8:	0000067b 	andeq	r0, r0, fp, ror r6
    3bec:	129c1200 	addsne	r1, ip, #0, 4
    3bf0:	1a020000 	bne	83bf8 <_bss_end+0x77d94>
    3bf4:	00125c0f 	andseq	r5, r2, pc, lsl #24
    3bf8:	00068600 	andeq	r8, r6, r0, lsl #12
    3bfc:	06070100 	streq	r0, [r7], -r0, lsl #2
    3c00:	06120000 	ldreq	r0, [r2], -r0
    3c04:	7b100000 	blvc	403c0c <_bss_end+0x3f7da8>
    3c08:	11000006 	tstne	r0, r6
    3c0c:	0000005e 	andeq	r0, r0, lr, asr r0
    3c10:	11ab1300 			; <UNDEFINED> instruction: 0x11ab1300
    3c14:	1b020000 	blne	83c1c <_bss_end+0x77db8>
    3c18:	0011d20e 	andseq	sp, r1, lr, lsl #4
    3c1c:	06270100 	strteq	r0, [r7], -r0, lsl #2
    3c20:	06320000 	ldrteq	r0, [r2], -r0
    3c24:	7b100000 	blvc	403c2c <_bss_end+0x3f7dc8>
    3c28:	11000006 	tstne	r0, r6
    3c2c:	00000686 	andeq	r0, r0, r6, lsl #13
    3c30:	16821200 	strne	r1, [r2], r0, lsl #4
    3c34:	1e020000 	cdpne	0, 0, cr0, cr2, cr0, {0}
    3c38:	0017920c 	andseq	r9, r7, ip, lsl #4
    3c3c:	00016e00 	andeq	r6, r1, r0, lsl #28
    3c40:	06520100 	ldrbeq	r0, [r2], -r0, lsl #2
    3c44:	06580000 	ldrbeq	r0, [r8], -r0
    3c48:	541c0000 	ldrpl	r0, [ip], #-0
    3c4c:	0000e400 	andeq	lr, r0, r0, lsl #8
    3c50:	067b1000 	ldrbteq	r1, [fp], -r0
    3c54:	14000000 	strne	r0, [r0], #-0
    3c58:	0000170f 	andeq	r1, r0, pc, lsl #14
    3c5c:	b00c1e02 	andlt	r1, ip, r2, lsl #28
    3c60:	68000016 	stmdavs	r0, {r1, r2, r4}
    3c64:	01000001 	tsteq	r0, r1
    3c68:	00000674 	andeq	r0, r0, r4, ror r6
    3c6c:	3300541c 	movwcc	r5, #1052	; 0x41c
    3c70:	10000001 	andne	r0, r0, r1
    3c74:	0000067b 	andeq	r0, r0, fp, ror r6
    3c78:	040d0000 	streq	r0, [sp], #-0
    3c7c:	00000597 	muleq	r0, r7, r5
    3c80:	00067b03 	andeq	r7, r6, r3, lsl #22
    3c84:	15041d00 	strne	r1, [r4, #-3328]	; 0xfffff300
    3c88:	00001473 	andeq	r1, r0, r3, ror r4
    3c8c:	971d2402 	ldrls	r2, [sp, -r2, lsl #8]
    3c90:	1e000005 	cdpne	0, 0, cr0, cr0, cr5, {0}
    3c94:	006c6168 	rsbeq	r6, ip, r8, ror #2
    3c98:	0e0b0707 	cdpeq	7, 0, cr0, cr11, cr7, {0}
    3c9c:	1f000007 	svcne	0x00000007
    3ca0:	00000680 	andeq	r0, r0, r0, lsl #13
    3ca4:	76190907 	ldrvc	r0, [r9], -r7, lsl #18
    3ca8:	80000000 	andhi	r0, r0, r0
    3cac:	1f0ee6b2 	svcne	0x000ee6b2
    3cb0:	000003e6 	andeq	r0, r0, r6, ror #7
    3cb4:	df1a0c07 	svcle	0x001a0c07
    3cb8:	00000000 	andeq	r0, r0, r0
    3cbc:	1f200000 	svcne	0x00200000
    3cc0:	000004c4 	andeq	r0, r0, r4, asr #9
    3cc4:	df1a0f07 	svcle	0x001a0f07
    3cc8:	00000000 	andeq	r0, r0, r0
    3ccc:	20202000 	eorcs	r2, r0, r0
    3cd0:	00000530 	andeq	r0, r0, r0, lsr r5
    3cd4:	6a151207 	bvs	5484f8 <_bss_end+0x53c694>
    3cd8:	36000000 	strcc	r0, [r0], -r0
    3cdc:	0006271f 	andeq	r2, r6, pc, lsl r7
    3ce0:	1a440700 	bne	11058e8 <_bss_end+0x10f9a84>
    3ce4:	000000df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    3ce8:	20215000 	eorcs	r5, r1, r0
    3cec:	0002661f 	andeq	r6, r2, pc, lsl r6
    3cf0:	1a730700 	bne	1cc58f8 <_bss_end+0x1cb9a94>
    3cf4:	000000df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    3cf8:	2000b200 	andcs	fp, r0, r0, lsl #4
    3cfc:	0005441f 	andeq	r4, r5, pc, lsl r4
    3d00:	1aa60700 	bne	fe985908 <_bss_end+0xfe979aa4>
    3d04:	000000df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    3d08:	2000b400 	andcs	fp, r0, r0, lsl #8
    3d0c:	06a02100 	strteq	r2, [r0], r0, lsl #2
    3d10:	b0210000 	eorlt	r0, r1, r0
    3d14:	21000006 	tstcs	r0, r6
    3d18:	000006c0 	andeq	r0, r0, r0, asr #13
    3d1c:	0006d021 	andeq	sp, r6, r1, lsr #32
    3d20:	06dd2100 	ldrbeq	r2, [sp], r0, lsl #2
    3d24:	ed210000 	stc	0, cr0, [r1, #-0]
    3d28:	21000006 	tstcs	r0, r6
    3d2c:	000006fd 	strdeq	r0, [r0], -sp
    3d30:	6d656d1e 	stclvs	13, cr6, [r5, #-120]!	; 0xffffff88
    3d34:	0b060800 	bleq	185d3c <_bss_end+0x179ed8>
    3d38:	0000078a 	andeq	r0, r0, sl, lsl #15
    3d3c:	0011f41f 	andseq	pc, r1, pc, lsl r4	; <UNPREDICTABLE>
    3d40:	180a0800 	stmdane	sl, {fp}
    3d44:	0000006a 	andeq	r0, r0, sl, rrx
    3d48:	00020000 	andeq	r0, r2, r0
    3d4c:	0010d41f 	andseq	sp, r0, pc, lsl r4
    3d50:	180d0800 	stmdane	sp, {fp}
    3d54:	0000006a 	andeq	r0, r0, sl, rrx
    3d58:	20000000 	andcs	r0, r0, r0
    3d5c:	00142922 	andseq	r2, r4, r2, lsr #18
    3d60:	18100800 	ldmdane	r0, {fp}
    3d64:	0000006a 	andeq	r0, r0, sl, rrx
    3d68:	f71f4000 			; <UNDEFINED> instruction: 0xf71f4000
    3d6c:	08000012 	stmdaeq	r0, {r1, r4}
    3d70:	006a1813 	rsbeq	r1, sl, r3, lsl r8
    3d74:	00000000 	andeq	r0, r0, r0
    3d78:	80221ffe 	strdhi	r1, [r2], -lr	; <UNPREDICTABLE>
    3d7c:	08000010 	stmdaeq	r0, {r4}
    3d80:	006a1816 	rsbeq	r1, sl, r6, lsl r8
    3d84:	7ff80000 	svcvc	0x00f80000
    3d88:	073d2100 	ldreq	r2, [sp, -r0, lsl #2]!
    3d8c:	4d210000 	stcmi	0, cr0, [r1, #-0]
    3d90:	21000007 	tstcs	r0, r7
    3d94:	0000075d 	andeq	r0, r0, sp, asr r7
    3d98:	00076b21 	andeq	r6, r7, r1, lsr #22
    3d9c:	077b2100 	ldrbeq	r2, [fp, -r0, lsl #2]!
    3da0:	72230000 	eorvc	r0, r3, #0
    3da4:	ff000015 			; <UNDEFINED> instruction: 0xff000015
    3da8:	0709090f 	streq	r0, [r9, -pc, lsl #18]
    3dac:	0000083d 	andeq	r0, r0, sp, lsr r8
    3db0:	0014570c 	andseq	r5, r4, ip, lsl #14
    3db4:	110c0900 	tstne	ip, r0, lsl #18
    3db8:	0000083d 	andeq	r0, r0, sp, lsr r8
    3dbc:	14520f00 	ldrbne	r0, [r2], #-3840	; 0xfffff100
    3dc0:	0e090000 	cdpeq	0, 0, cr0, cr9, cr0, {0}
    3dc4:	0015210e 	andseq	r2, r5, lr, lsl #2
    3dc8:	0007d200 	andeq	sp, r7, r0, lsl #4
    3dcc:	0007e200 	andeq	lr, r7, r0, lsl #4
    3dd0:	084e1000 	stmdaeq	lr, {ip}^
    3dd4:	5e110000 	cdppl	0, 1, cr0, cr1, cr0, {0}
    3dd8:	11000000 	mrsne	r0, (UNDEF: 0)
    3ddc:	0000052b 	andeq	r0, r0, fp, lsr #10
    3de0:	15721200 	ldrbne	r1, [r2, #-512]!	; 0xfffffe00
    3de4:	11090000 	mrsne	r0, (UNDEF: 9)
    3de8:	00153c09 	andseq	r3, r5, r9, lsl #24
    3dec:	00084e00 	andeq	r4, r8, r0, lsl #28
    3df0:	07fb0100 	ldrbeq	r0, [fp, r0, lsl #2]!
    3df4:	08010000 	stmdaeq	r1, {}	; <UNPREDICTABLE>
    3df8:	4e100000 	cdpmi	0, 1, cr0, cr0, cr0, {0}
    3dfc:	00000008 	andeq	r0, r0, r8
    3e00:	00143712 	andseq	r3, r4, r2, lsl r7
    3e04:	12140900 	andsne	r0, r4, #0, 18
    3e08:	0000147e 	andeq	r1, r0, lr, ror r4
    3e0c:	0000005e 	andeq	r0, r0, lr, asr r0
    3e10:	00081a01 	andeq	r1, r8, r1, lsl #20
    3e14:	00082000 	andeq	r2, r8, r0
    3e18:	084e1000 	stmdaeq	lr, {ip}^
    3e1c:	24000000 	strcs	r0, [r0], #-0
    3e20:	00001442 	andeq	r1, r0, r2, asr #8
    3e24:	530e1609 	movwpl	r1, #58889	; 0xe609
    3e28:	01000015 	tsteq	r0, r5, lsl r0
    3e2c:	00000831 	andeq	r0, r0, r1, lsr r8
    3e30:	00084e10 	andeq	r4, r8, r0, lsl lr
    3e34:	005e1100 	subseq	r1, lr, r0, lsl #2
    3e38:	00000000 	andeq	r0, r0, r0
    3e3c:	00003f25 	andeq	r3, r0, r5, lsr #30
    3e40:	00084e00 	andeq	r4, r8, r0, lsl #28
    3e44:	006f2600 	rsbeq	r2, pc, r0, lsl #12
    3e48:	0ffe0000 	svceq	0x00fe0000
    3e4c:	a3040d00 	movwge	r0, #19712	; 0x4d00
    3e50:	15000007 	strne	r0, [r0, #-7]
    3e54:	0000165e 	andeq	r1, r0, lr, asr r6
    3e58:	a3161909 	tstge	r6, #147456	; 0x24000
    3e5c:	27000007 	strcs	r0, [r0, -r7]
    3e60:	00000277 	andeq	r0, r0, r7, ror r2
    3e64:	05121001 	ldreq	r1, [r2, #-1]
    3e68:	00be4803 	adcseq	r4, lr, r3, lsl #16
    3e6c:	16eb2800 	strbtne	r2, [fp], r0, lsl #16
    3e70:	a4dc0000 	ldrbge	r0, [ip], #0
    3e74:	001c0000 	andseq	r0, ip, r0
    3e78:	9c010000 	stcls	0, cr0, [r1], {-0}
    3e7c:	00054f29 	andeq	r4, r5, r9, lsr #30
    3e80:	00a49000 	adceq	r9, r4, r0
    3e84:	00004c00 	andeq	r4, r0, r0, lsl #24
    3e88:	af9c0100 	svcge	0x009c0100
    3e8c:	2a000008 	bcs	3eb4 <CPSR_IRQ_INHIBIT+0x3e34>
    3e90:	00000432 	andeq	r0, r0, r2, lsr r4
    3e94:	38018401 	stmdacc	r1, {r0, sl, pc}
    3e98:	02000000 	andeq	r0, r0, #0
    3e9c:	ed2a7491 	cfstrs	mvf7, [sl, #-580]!	; 0xfffffdbc
    3ea0:	01000005 	tsteq	r0, r5
    3ea4:	00380184 	eorseq	r0, r8, r4, lsl #3
    3ea8:	91020000 	mrsls	r0, (UNDEF: 2)
    3eac:	322b0070 	eorcc	r0, fp, #112	; 0x70
    3eb0:	cd000006 	stcgt	0, cr0, [r0, #-24]	; 0xffffffe8
    3eb4:	24000008 	strcs	r0, [r0], #-8
    3eb8:	2c0000a5 	stccs	0, cr0, [r0], {165}	; 0xa5
    3ebc:	01000000 	mrseq	r0, (UNDEF: 0)
    3ec0:	0008da9c 	muleq	r8, ip, sl
    3ec4:	00541c00 	subseq	r1, r4, r0, lsl #24
    3ec8:	000000e4 	andeq	r0, r0, r4, ror #1
    3ecc:	0005822c 	andeq	r8, r5, ip, lsr #4
    3ed0:	00068100 	andeq	r8, r6, r0, lsl #2
    3ed4:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    3ed8:	06582b00 	ldrbeq	r2, [r8], -r0, lsl #22
    3edc:	08f80000 	ldmeq	r8!, {}^	; <UNPREDICTABLE>
    3ee0:	a4f80000 	ldrbtge	r0, [r8], #0
    3ee4:	002c0000 	eoreq	r0, ip, r0
    3ee8:	9c010000 	stcls	0, cr0, [r1], {-0}
    3eec:	00000905 	andeq	r0, r0, r5, lsl #18
    3ef0:	3300541c 	movwcc	r5, #1052	; 0x41c
    3ef4:	2c000001 	stccs	0, cr0, [r0], {1}
    3ef8:	00000582 	andeq	r0, r0, r2, lsl #11
    3efc:	00000681 	andeq	r0, r0, r1, lsl #13
    3f00:	00749102 	rsbseq	r9, r4, r2, lsl #2
    3f04:	0001a82d 	andeq	sl, r1, sp, lsr #16
    3f08:	06660100 	strbteq	r0, [r6], -r0, lsl #2
    3f0c:	0000091f 	andeq	r0, r0, pc, lsl r9
    3f10:	0000a38c 	andeq	sl, r0, ip, lsl #7
    3f14:	00000104 	andeq	r0, r0, r4, lsl #2
    3f18:	09599c01 	ldmdbeq	r9, {r0, sl, fp, ip, pc}^
    3f1c:	822c0000 	eorhi	r0, ip, #0
    3f20:	67000005 	strvs	r0, [r0, -r5]
    3f24:	02000002 	andeq	r0, r0, #2
    3f28:	b22a6c91 	eorlt	r6, sl, #37120	; 0x9100
    3f2c:	01000024 	tsteq	r0, r4, lsr #32
    3f30:	01683666 	cmneq	r8, r6, ror #12
    3f34:	91020000 	mrsls	r0, (UNDEF: 2)
    3f38:	6c6f2e68 	stclvs	14, cr2, [pc], #-416	; 3da0 <CPSR_IRQ_INHIBIT+0x3d20>
    3f3c:	71010064 	tstvc	r1, r4, rrx
    3f40:	00095913 	andeq	r5, r9, r3, lsl r9
    3f44:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    3f48:	0016742f 	andseq	r7, r6, pc, lsr #8
    3f4c:	0a720100 	beq	1c84354 <_bss_end+0x1c784f0>
    3f50:	0000052b 	andeq	r0, r0, fp, lsr #10
    3f54:	00739102 	rsbseq	r9, r3, r2, lsl #2
    3f58:	00a6040d 	adceq	r0, r6, sp, lsl #8
    3f5c:	252d0000 	strcs	r0, [sp, #-0]!
    3f60:	01000002 	tsteq	r0, r2
    3f64:	09790654 	ldmdbeq	r9!, {r2, r4, r6, r9, sl}^
    3f68:	a2ec0000 	rscge	r0, ip, #0
    3f6c:	00a00000 	adceq	r0, r0, r0
    3f70:	9c010000 	stcls	0, cr0, [r1], {-0}
    3f74:	00000995 	muleq	r0, r5, r9
    3f78:	0005822c 	andeq	r8, r5, ip, lsr #4
    3f7c:	00026700 	andeq	r6, r2, r0, lsl #14
    3f80:	6c910200 	lfmvs	f0, 4, [r1], {0}
    3f84:	0010df2f 	andseq	sp, r0, pc, lsr #30
    3f88:	19560100 	ldmdbne	r6, {r8}^
    3f8c:	00000168 	andeq	r0, r0, r8, ror #2
    3f90:	00749102 	rsbseq	r9, r4, r2, lsl #2
    3f94:	0002012d 	andeq	r0, r2, sp, lsr #2
    3f98:	0a350100 	beq	d443a0 <_bss_end+0xd3853c>
    3f9c:	000009af 	andeq	r0, r0, pc, lsr #19
    3fa0:	0000a168 	andeq	sl, r0, r8, ror #2
    3fa4:	00000184 	andeq	r0, r0, r4, lsl #3
    3fa8:	09e99c01 	stmibeq	r9!, {r0, sl, fp, ip, pc}^
    3fac:	822c0000 	eorhi	r0, ip, #0
    3fb0:	67000005 	strvs	r0, [r0, -r5]
    3fb4:	02000002 	andeq	r0, r0, #2
    3fb8:	6c2a6c91 	stcvs	12, cr6, [sl], #-580	; 0xfffffdbc
    3fbc:	01000016 	tsteq	r0, r6, lsl r0
    3fc0:	00d83935 	sbcseq	r3, r8, r5, lsr r9
    3fc4:	91020000 	mrsls	r0, (UNDEF: 2)
    3fc8:	17062f68 	strne	r2, [r6, -r8, ror #30]
    3fcc:	37010000 	strcc	r0, [r1, -r0]
    3fd0:	00016819 	andeq	r6, r1, r9, lsl r8
    3fd4:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    3fd8:	0013082f 	andseq	r0, r3, pc, lsr #16
    3fdc:	0b440100 	bleq	11043e4 <_bss_end+0x10f8580>
    3fe0:	0000016e 	andeq	r0, r0, lr, ror #2
    3fe4:	00709102 	rsbseq	r9, r0, r2, lsl #2
    3fe8:	0001e62d 	andeq	lr, r1, sp, lsr #12
    3fec:	061d0100 	ldreq	r0, [sp], -r0, lsl #2
    3ff0:	00000a03 	andeq	r0, r0, r3, lsl #20
    3ff4:	0000a074 	andeq	sl, r0, r4, ror r0
    3ff8:	000000f4 	strdeq	r0, [r0], -r4
    3ffc:	0a2e9c01 	beq	bab008 <_bss_end+0xb9f1a4>
    4000:	822c0000 	eorhi	r0, ip, #0
    4004:	67000005 	strvs	r0, [r0, -r5]
    4008:	02000002 	andeq	r0, r0, #2
    400c:	062f6c91 			; <UNDEFINED> instruction: 0x062f6c91
    4010:	01000017 	tsteq	r0, r7, lsl r0
    4014:	0168191f 	cmneq	r8, pc, lsl r9
    4018:	91020000 	mrsls	r0, (UNDEF: 2)
    401c:	13082f74 	movwne	r2, #36724	; 0x8f74
    4020:	2b010000 	blcs	44028 <_bss_end+0x381c4>
    4024:	00016e0b 	andeq	r6, r1, fp, lsl #28
    4028:	70910200 	addsvc	r0, r1, r0, lsl #4
    402c:	02403000 	subeq	r3, r0, #0
    4030:	18010000 	stmdane	r1, {}	; <UNPREDICTABLE>
    4034:	000a480f 	andeq	r4, sl, pc, lsl #16
    4038:	00a03000 	adceq	r3, r0, r0
    403c:	00004400 	andeq	r4, r0, r0, lsl #8
    4040:	559c0100 	ldrpl	r0, [ip, #256]	; 0x100
    4044:	2c00000a 	stccs	0, cr0, [r0], {10}
    4048:	00000582 	andeq	r0, r0, r2, lsl #11
    404c:	00000272 	andeq	r0, r0, r2, ror r2
    4050:	00749102 	rsbseq	r9, r4, r2, lsl #2
    4054:	0001c731 	andeq	ip, r1, r1, lsr r7
    4058:	01120100 	tsteq	r2, r0, lsl #2
    405c:	00000a66 	andeq	r0, r0, r6, ror #20
    4060:	000a7000 	andeq	r7, sl, r0
    4064:	05823200 	streq	r3, [r2, #512]	; 0x200
    4068:	02670000 	rsbeq	r0, r7, #0
    406c:	33000000 	movwcc	r0, #0
    4070:	00000a55 	andeq	r0, r0, r5, asr sl
    4074:	00001696 	muleq	r0, r6, r6
    4078:	00000a87 	andeq	r0, r0, r7, lsl #21
    407c:	00009fe8 	andeq	r9, r0, r8, ror #31
    4080:	00000048 	andeq	r0, r0, r8, asr #32
    4084:	66349c01 	ldrtvs	r9, [r4], -r1, lsl #24
    4088:	0200000a 	andeq	r0, r0, #10
    408c:	00007491 	muleq	r0, r1, r4
    4090:	00000022 	andeq	r0, r0, r2, lsr #32
    4094:	177e0002 	ldrbne	r0, [lr, -r2]!
    4098:	01040000 	mrseq	r0, (UNDEF: 4)
    409c:	00001a81 	andeq	r1, r0, r1, lsl #21
    40a0:	0000a550 	andeq	sl, r0, r0, asr r5
    40a4:	0000a5ac 	andeq	sl, r0, ip, lsr #11
    40a8:	000017c7 	andeq	r1, r0, r7, asr #15
    40ac:	000000b6 	strheq	r0, [r0], -r6
    40b0:	00001825 	andeq	r1, r0, r5, lsr #16
    40b4:	001e8001 	andseq	r8, lr, r1
    40b8:	00020000 	andeq	r0, r2, r0
    40bc:	00001792 	muleq	r0, r2, r7
    40c0:	1b220104 	blne	8844d8 <_bss_end+0x878674>
    40c4:	00580000 	subseq	r0, r8, r0
    40c8:	18310000 	ldmdane	r1!, {}	; <UNPREDICTABLE>
    40cc:	00b60000 	adcseq	r0, r6, r0
    40d0:	18250000 	stmdane	r5!, {}	; <UNPREDICTABLE>
    40d4:	80010000 	andhi	r0, r1, r0
    40d8:	0000014b 	andeq	r0, r0, fp, asr #2
    40dc:	17a40004 	strne	r0, [r4, r4]!
    40e0:	01040000 	mrseq	r0, (UNDEF: 4)
    40e4:	00000000 	andeq	r0, r0, r0
    40e8:	0018fb04 	andseq	pc, r8, r4, lsl #22
    40ec:	0000b600 	andeq	fp, r0, r0, lsl #12
    40f0:	00a5fc00 	adceq	pc, r5, r0, lsl #24
    40f4:	00011800 	andeq	r1, r1, r0, lsl #16
    40f8:	001bee00 	andseq	lr, fp, r0, lsl #28
    40fc:	18f20200 	ldmne	r2!, {r9}^
    4100:	02010000 	andeq	r0, r1, #0
    4104:	00003107 	andeq	r3, r0, r7, lsl #2
    4108:	37040300 	strcc	r0, [r4, -r0, lsl #6]
    410c:	04000000 	streq	r0, [r0], #-0
    4110:	0018e902 	andseq	lr, r8, r2, lsl #18
    4114:	07030100 	streq	r0, [r3, -r0, lsl #2]
    4118:	00000031 	andeq	r0, r0, r1, lsr r0
    411c:	00189105 	andseq	r9, r8, r5, lsl #2
    4120:	10060100 	andne	r0, r6, r0, lsl #2
    4124:	00000050 	andeq	r0, r0, r0, asr r0
    4128:	69050406 	stmdbvs	r5, {r1, r2, sl}
    412c:	0500746e 	streq	r7, [r0, #-1134]	; 0xfffffb92
    4130:	000018d2 	ldrdeq	r1, [r0], -r2
    4134:	50100801 	andspl	r0, r0, r1, lsl #16
    4138:	07000000 	streq	r0, [r0, -r0]
    413c:	00000025 	andeq	r0, r0, r5, lsr #32
    4140:	00000076 	andeq	r0, r0, r6, ror r0
    4144:	00007608 	andeq	r7, r0, r8, lsl #12
    4148:	ffffff00 			; <UNDEFINED> instruction: 0xffffff00
    414c:	040900ff 	streq	r0, [r9], #-255	; 0xffffff01
    4150:	001ef907 	andseq	pc, lr, r7, lsl #18
    4154:	18a90500 	stmiane	r9!, {r8, sl}
    4158:	0b010000 	bleq	44160 <_bss_end+0x382fc>
    415c:	00006315 	andeq	r6, r0, r5, lsl r3
    4160:	189c0500 	ldmne	ip, {r8, sl}
    4164:	0d010000 	stceq	0, cr0, [r1, #-0]
    4168:	00006315 	andeq	r6, r0, r5, lsl r3
    416c:	00380700 	eorseq	r0, r8, r0, lsl #14
    4170:	00a80000 	adceq	r0, r8, r0
    4174:	76080000 	strvc	r0, [r8], -r0
    4178:	ff000000 			; <UNDEFINED> instruction: 0xff000000
    417c:	00ffffff 	ldrshteq	pc, [pc], #255	; <UNPREDICTABLE>
    4180:	0018db05 	andseq	sp, r8, r5, lsl #22
    4184:	15100100 	ldrne	r0, [r0, #-256]	; 0xffffff00
    4188:	00000095 	muleq	r0, r5, r0
    418c:	0018b705 	andseq	fp, r8, r5, lsl #14
    4190:	15120100 	ldrne	r0, [r2, #-256]	; 0xffffff00
    4194:	00000095 	muleq	r0, r5, r0
    4198:	0018c40a 	andseq	ip, r8, sl, lsl #8
    419c:	102b0100 	eorne	r0, fp, r0, lsl #2
    41a0:	00000050 	andeq	r0, r0, r0, asr r0
    41a4:	0000a6bc 			; <UNDEFINED> instruction: 0x0000a6bc
    41a8:	00000058 	andeq	r0, r0, r8, asr r0
    41ac:	00ea9c01 	rsceq	r9, sl, r1, lsl #24
    41b0:	610b0000 	mrsvs	r0, (UNDEF: 11)
    41b4:	01000019 	tsteq	r0, r9, lsl r0
    41b8:	00ea0c2d 	rsceq	r0, sl, sp, lsr #24
    41bc:	91020000 	mrsls	r0, (UNDEF: 2)
    41c0:	04030074 	streq	r0, [r3], #-116	; 0xffffff8c
    41c4:	00000038 	andeq	r0, r0, r8, lsr r0
    41c8:	0019540a 	andseq	r5, r9, sl, lsl #8
    41cc:	101f0100 	andsne	r0, pc, r0, lsl #2
    41d0:	00000050 	andeq	r0, r0, r0, asr r0
    41d4:	0000a664 	andeq	sl, r0, r4, ror #12
    41d8:	00000058 	andeq	r0, r0, r8, asr r0
    41dc:	011a9c01 	tsteq	sl, r1, lsl #24
    41e0:	610b0000 	mrsvs	r0, (UNDEF: 11)
    41e4:	01000019 	tsteq	r0, r9, lsl r0
    41e8:	011a0c21 	tsteq	sl, r1, lsr #24
    41ec:	91020000 	mrsls	r0, (UNDEF: 2)
    41f0:	04030074 	streq	r0, [r3], #-116	; 0xffffff8c
    41f4:	00000025 	andeq	r0, r0, r5, lsr #32
    41f8:	0018860c 	andseq	r8, r8, ip, lsl #12
    41fc:	10140100 	andsne	r0, r4, r0, lsl #2
    4200:	00000050 	andeq	r0, r0, r0, asr r0
    4204:	0000a5fc 	strdeq	sl, [r0], -ip
    4208:	00000068 	andeq	r0, r0, r8, rrx
    420c:	01489c01 	cmpeq	r8, r1, lsl #24
    4210:	690d0000 	stmdbvs	sp, {}	; <UNPREDICTABLE>
    4214:	07160100 	ldreq	r0, [r6, -r0, lsl #2]
    4218:	00000148 	andeq	r0, r0, r8, asr #2
    421c:	00749102 	rsbseq	r9, r4, r2, lsl #2
    4220:	00500403 	subseq	r0, r0, r3, lsl #8
    4224:	0b000000 	bleq	422c <CPSR_IRQ_INHIBIT+0x41ac>
    4228:	04000001 	streq	r0, [r0], #-1
    422c:	00186a00 	andseq	r6, r8, r0, lsl #20
    4230:	00010400 	andeq	r0, r1, r0, lsl #8
    4234:	04000000 	streq	r0, [r0], #-0
    4238:	00001967 	andeq	r1, r0, r7, ror #18
    423c:	000000b6 	strheq	r0, [r0], -r6
    4240:	0000a714 	andeq	sl, r0, r4, lsl r7
    4244:	00000174 	andeq	r0, r0, r4, ror r1
    4248:	00001ce2 	andeq	r1, r0, r2, ror #25
    424c:	00004902 	andeq	r4, r0, r2, lsl #18
    4250:	085f0300 	ldmdaeq	pc, {r8, r9}^	; <UNPREDICTABLE>
    4254:	05010000 	streq	r0, [r1, #-0]
    4258:	00006110 	andeq	r6, r0, r0, lsl r1
    425c:	31301100 	teqcc	r0, r0, lsl #2
    4260:	35343332 	ldrcc	r3, [r4, #-818]!	; 0xfffffcce
    4264:	39383736 	ldmdbcc	r8!, {r1, r2, r4, r5, r8, r9, sl, ip, sp}
    4268:	44434241 	strbmi	r4, [r3], #-577	; 0xfffffdbf
    426c:	00004645 	andeq	r4, r0, r5, asr #12
    4270:	01030104 	tsteq	r3, r4, lsl #2
    4274:	00000025 	andeq	r0, r0, r5, lsr #32
    4278:	00007405 	andeq	r7, r0, r5, lsl #8
    427c:	00006100 	andeq	r6, r0, r0, lsl #2
    4280:	00660600 	rsbeq	r0, r6, r0, lsl #12
    4284:	00100000 	andseq	r0, r0, r0
    4288:	00005107 	andeq	r5, r0, r7, lsl #2
    428c:	07040800 	streq	r0, [r4, -r0, lsl #16]
    4290:	00001ef9 	strdeq	r1, [r0], -r9
    4294:	a0080108 	andge	r0, r8, r8, lsl #2
    4298:	07000004 	streq	r0, [r0, -r4]
    429c:	0000006d 	andeq	r0, r0, sp, rrx
    42a0:	00002a09 	andeq	r2, r0, r9, lsl #20
    42a4:	072d0a00 	streq	r0, [sp, -r0, lsl #20]!
    42a8:	08010000 	stmdaeq	r1, {}	; <UNPREDICTABLE>
    42ac:	0019c206 	andseq	ip, r9, r6, lsl #4
    42b0:	00a71400 	adceq	r1, r7, r0, lsl #8
    42b4:	00017400 	andeq	r7, r1, r0, lsl #8
    42b8:	019c0100 	orrseq	r0, ip, r0, lsl #2
    42bc:	0b000001 	bleq	42c8 <CPSR_IRQ_INHIBIT+0x4248>
    42c0:	00000907 	andeq	r0, r0, r7, lsl #18
    42c4:	66180801 	ldrvs	r0, [r8], -r1, lsl #16
    42c8:	02000000 	andeq	r0, r0, #0
    42cc:	000b6491 	muleq	fp, r1, r4
    42d0:	01000009 	tsteq	r0, r9
    42d4:	01012508 	tsteq	r1, r8, lsl #10
    42d8:	91020000 	mrsls	r0, (UNDEF: 2)
    42dc:	0b970b60 	bleq	fe5c7064 <_bss_end+0xfe5bb200>
    42e0:	08010000 	stmdaeq	r1, {}	; <UNPREDICTABLE>
    42e4:	0000663a 	andeq	r6, r0, sl, lsr r6
    42e8:	5c910200 	lfmpl	f0, 4, [r1], {0}
    42ec:	0100690c 	tsteq	r0, ip, lsl #18
    42f0:	0107060a 	tsteq	r7, sl, lsl #12
    42f4:	91020000 	mrsls	r0, (UNDEF: 2)
    42f8:	a7e00d74 			; <UNDEFINED> instruction: 0xa7e00d74
    42fc:	00980000 	addseq	r0, r8, r0
    4300:	6a0c0000 	bvs	304308 <_bss_end+0x2f84a4>
    4304:	0b1c0100 	bleq	70470c <_bss_end+0x6f88a8>
    4308:	00000107 	andeq	r0, r0, r7, lsl #2
    430c:	0d709102 	ldfeqp	f1, [r0, #-8]!
    4310:	0000a808 	andeq	sl, r0, r8, lsl #16
    4314:	00000060 	andeq	r0, r0, r0, rrx
    4318:	0100630c 	tsteq	r0, ip, lsl #6
    431c:	006d081e 	rsbeq	r0, sp, lr, lsl r8
    4320:	91020000 	mrsls	r0, (UNDEF: 2)
    4324:	0000006f 	andeq	r0, r0, pc, rrx
    4328:	006d040e 	rsbeq	r0, sp, lr, lsl #8
    432c:	040f0000 	streq	r0, [pc], #-0	; 4334 <CPSR_IRQ_INHIBIT+0x42b4>
    4330:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
    4334:	00220000 	eoreq	r0, r2, r0
    4338:	00020000 	andeq	r0, r2, r0
    433c:	0000192b 	andeq	r1, r0, fp, lsr #18
    4340:	1e170104 	mufnes	f0, f7, f4
    4344:	a8880000 	stmge	r8, {}	; <UNPREDICTABLE>
    4348:	aa940000 	bge	fe504350 <_bss_end+0xfe4f84ec>
    434c:	19ce0000 	stmibne	lr, {}^	; <UNPREDICTABLE>
    4350:	19fe0000 	ldmibne	lr!, {}^	; <UNPREDICTABLE>
    4354:	18250000 	stmdane	r5!, {}	; <UNPREDICTABLE>
    4358:	80010000 	andhi	r0, r1, r0
    435c:	00000022 	andeq	r0, r0, r2, lsr #32
    4360:	193f0002 	ldmdbne	pc!, {r1}	; <UNPREDICTABLE>
    4364:	01040000 	mrseq	r0, (UNDEF: 4)
    4368:	00001e94 	muleq	r0, r4, lr
    436c:	0000aa94 	muleq	r0, r4, sl
    4370:	0000aa98 	muleq	r0, r8, sl
    4374:	000019ce 	andeq	r1, r0, lr, asr #19
    4378:	000019fe 	strdeq	r1, [r0], -lr
    437c:	00001825 	andeq	r1, r0, r5, lsr #16
    4380:	09328001 	ldmdbeq	r2!, {r0, pc}
    4384:	00040000 	andeq	r0, r4, r0
    4388:	00001953 	andeq	r1, r0, r3, asr r9
    438c:	1dcc0104 	stfnee	f0, [ip, #16]
    4390:	230c0000 	movwcs	r0, #49152	; 0xc000
    4394:	fe00001d 	mcr2	0, 0, r0, cr0, cr13, {0}
    4398:	f4000019 	vst4.8	{d0-d3}, [r0 :64], r9
    439c:	0200001e 	andeq	r0, r0, #30
    43a0:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
    43a4:	04030074 	streq	r0, [r3], #-116	; 0xffffff8c
    43a8:	001ef907 	andseq	pc, lr, r7, lsl #18
    43ac:	05080300 	streq	r0, [r8, #-768]	; 0xfffffd00
    43b0:	000001e4 	andeq	r0, r0, r4, ror #3
    43b4:	cb040803 	blgt	1063c8 <_bss_end+0xfa564>
    43b8:	04000025 	streq	r0, [r0], #-37	; 0xffffffdb
    43bc:	00001d7e 	andeq	r1, r0, lr, ror sp
    43c0:	24162a01 	ldrcs	r2, [r6], #-2561	; 0xfffff5ff
    43c4:	04000000 	streq	r0, [r0], #-0
    43c8:	000021ed 	andeq	r2, r0, sp, ror #3
    43cc:	51152f01 	tstpl	r5, r1, lsl #30
    43d0:	05000000 	streq	r0, [r0, #-0]
    43d4:	00005704 	andeq	r5, r0, r4, lsl #14
    43d8:	00390600 	eorseq	r0, r9, r0, lsl #12
    43dc:	00660000 	rsbeq	r0, r6, r0
    43e0:	66070000 	strvs	r0, [r7], -r0
    43e4:	00000000 	andeq	r0, r0, r0
    43e8:	006c0405 	rsbeq	r0, ip, r5, lsl #8
    43ec:	04080000 	streq	r0, [r8], #-0
    43f0:	0000291f 	andeq	r2, r0, pc, lsl r9
    43f4:	790f3601 	stmdbvc	pc, {r0, r9, sl, ip, sp}	; <UNPREDICTABLE>
    43f8:	05000000 	streq	r0, [r0, #-0]
    43fc:	00007f04 	andeq	r7, r0, r4, lsl #30
    4400:	001d0600 	andseq	r0, sp, r0, lsl #12
    4404:	00930000 	addseq	r0, r3, r0
    4408:	66070000 	strvs	r0, [r7], -r0
    440c:	07000000 	streq	r0, [r0, -r0]
    4410:	00000066 	andeq	r0, r0, r6, rrx
    4414:	08010300 	stmdaeq	r1, {r8, r9}
    4418:	00000497 	muleq	r0, r7, r4
    441c:	00242509 	eoreq	r2, r4, r9, lsl #10
    4420:	12bb0100 	adcsne	r0, fp, #0, 2
    4424:	00000045 	andeq	r0, r0, r5, asr #32
    4428:	00294d09 	eoreq	r4, r9, r9, lsl #26
    442c:	10be0100 	adcsne	r0, lr, r0, lsl #2
    4430:	0000006d 	andeq	r0, r0, sp, rrx
    4434:	99060103 	stmdbls	r6, {r0, r1, r8}
    4438:	0a000004 	beq	4450 <CPSR_IRQ_INHIBIT+0x43d0>
    443c:	0000210d 	andeq	r2, r0, sp, lsl #2
    4440:	00930107 	addseq	r0, r3, r7, lsl #2
    4444:	17020000 	strne	r0, [r2, -r0]
    4448:	0001e606 	andeq	lr, r1, r6, lsl #12
    444c:	1bdc0b00 	blne	ff707054 <_bss_end+0xff6fb1f0>
    4450:	0b000000 	bleq	4458 <CPSR_IRQ_INHIBIT+0x43d8>
    4454:	0000202a 	andeq	r2, r0, sl, lsr #32
    4458:	24f00b01 	ldrbtcs	r0, [r0], #2817	; 0xb01
    445c:	0b020000 	bleq	84464 <_bss_end+0x78600>
    4460:	00002861 	andeq	r2, r0, r1, ror #16
    4464:	24940b03 	ldrcs	r0, [r4], #2819	; 0xb03
    4468:	0b040000 	bleq	104470 <_bss_end+0xf860c>
    446c:	0000276a 	andeq	r2, r0, sl, ror #14
    4470:	26ce0b05 	strbcs	r0, [lr], r5, lsl #22
    4474:	0b060000 	bleq	18447c <_bss_end+0x178618>
    4478:	00001bfd 	strdeq	r1, [r0], -sp
    447c:	277f0b07 	ldrbcs	r0, [pc, -r7, lsl #22]!
    4480:	0b080000 	bleq	204488 <_bss_end+0x1f8624>
    4484:	0000278d 	andeq	r2, r0, sp, lsl #15
    4488:	28540b09 	ldmdacs	r4, {r0, r3, r8, r9, fp}^
    448c:	0b0a0000 	bleq	284494 <_bss_end+0x278630>
    4490:	000023eb 	andeq	r2, r0, fp, ror #7
    4494:	1dbf0b0b 			; <UNDEFINED> instruction: 0x1dbf0b0b
    4498:	0b0c0000 	bleq	3044a0 <_bss_end+0x2f863c>
    449c:	00001e9c 	muleq	r0, ip, lr
    44a0:	21510b0d 	cmpcs	r1, sp, lsl #22
    44a4:	0b0e0000 	bleq	3844ac <_bss_end+0x378648>
    44a8:	00002167 	andeq	r2, r0, r7, ror #2
    44ac:	20640b0f 	rsbcs	r0, r4, pc, lsl #22
    44b0:	0b100000 	bleq	4044b8 <_bss_end+0x3f8654>
    44b4:	00002478 	andeq	r2, r0, r8, ror r4
    44b8:	20d00b11 	sbcscs	r0, r0, r1, lsl fp
    44bc:	0b120000 	bleq	4844c4 <_bss_end+0x478660>
    44c0:	00002ae6 	andeq	r2, r0, r6, ror #21
    44c4:	1c660b13 			; <UNDEFINED> instruction: 0x1c660b13
    44c8:	0b140000 	bleq	5044d0 <_bss_end+0x4f866c>
    44cc:	000020f4 	strdeq	r2, [r0], -r4
    44d0:	1ba30b15 	blne	fe8c712c <_bss_end+0xfe8bb2c8>
    44d4:	0b160000 	bleq	5844dc <_bss_end+0x578678>
    44d8:	00002884 	andeq	r2, r0, r4, lsl #17
    44dc:	29a60b17 	stmibcs	r6!, {r0, r1, r2, r4, r8, r9, fp}
    44e0:	0b180000 	bleq	6044e8 <_bss_end+0x5f8684>
    44e4:	00002119 	andeq	r2, r0, r9, lsl r1
    44e8:	25620b19 	strbcs	r0, [r2, #-2841]!	; 0xfffff4e7
    44ec:	0b1a0000 	bleq	6844f4 <_bss_end+0x678690>
    44f0:	00002892 	muleq	r0, r2, r8
    44f4:	1ad20b1b 	bne	ff487168 <_bss_end+0xff47b304>
    44f8:	0b1c0000 	bleq	704500 <_bss_end+0x6f869c>
    44fc:	000028a0 	andeq	r2, r0, r0, lsr #17
    4500:	28ae0b1d 	stmiacs	lr!, {r0, r2, r3, r4, r8, r9, fp}
    4504:	0b1e0000 	bleq	78450c <_bss_end+0x7786a8>
    4508:	00001a80 	andeq	r1, r0, r0, lsl #21
    450c:	28d80b1f 	ldmcs	r8, {r0, r1, r2, r3, r4, r8, r9, fp}^
    4510:	0b200000 	bleq	804518 <_bss_end+0x7f86b4>
    4514:	0000260f 	andeq	r2, r0, pc, lsl #12
    4518:	244a0b21 	strbcs	r0, [sl], #-2849	; 0xfffff4df
    451c:	0b220000 	bleq	884524 <_bss_end+0x8786c0>
    4520:	00002877 	andeq	r2, r0, r7, ror r8
    4524:	234e0b23 	movtcs	r0, #60195	; 0xeb23
    4528:	0b240000 	bleq	904530 <_bss_end+0x8f86cc>
    452c:	00002250 	andeq	r2, r0, r0, asr r2
    4530:	1f6a0b25 	svcne	0x006a0b25
    4534:	0b260000 	bleq	98453c <_bss_end+0x9786d8>
    4538:	0000226e 	andeq	r2, r0, lr, ror #4
    453c:	20060b27 	andcs	r0, r6, r7, lsr #22
    4540:	0b280000 	bleq	a04548 <_bss_end+0x9f86e4>
    4544:	0000227e 	andeq	r2, r0, lr, ror r2
    4548:	228e0b29 	addcs	r0, lr, #41984	; 0xa400
    454c:	0b2a0000 	bleq	a84554 <_bss_end+0xa786f0>
    4550:	000023d1 	ldrdeq	r2, [r0], -r1
    4554:	21f70b2b 	mvnscs	r0, fp, lsr #22
    4558:	0b2c0000 	bleq	b04560 <_bss_end+0xaf86fc>
    455c:	0000261c 	andeq	r2, r0, ip, lsl r6
    4560:	1fab0b2d 	svcne	0x00ab0b2d
    4564:	002e0000 	eoreq	r0, lr, r0
    4568:	0021890a 	eoreq	r8, r1, sl, lsl #18
    456c:	93010700 	movwls	r0, #5888	; 0x1700
    4570:	03000000 	movweq	r0, #0
    4574:	03c70617 	biceq	r0, r7, #24117248	; 0x1700000
    4578:	be0b0000 	cdplt	0, 0, cr0, cr11, cr0, {0}
    457c:	0000001e 	andeq	r0, r0, lr, lsl r0
    4580:	001b100b 	andseq	r1, fp, fp
    4584:	940b0100 	strls	r0, [fp], #-256	; 0xffffff00
    4588:	0200002a 	andeq	r0, r0, #42	; 0x2a
    458c:	0029270b 	eoreq	r2, r9, fp, lsl #14
    4590:	de0b0300 	cdple	3, 0, cr0, cr11, cr0, {0}
    4594:	0400001e 	streq	r0, [r0], #-30	; 0xffffffe2
    4598:	001bc80b 	andseq	ip, fp, fp, lsl #16
    459c:	870b0500 	strhi	r0, [fp, -r0, lsl #10]
    45a0:	0600001f 			; <UNDEFINED> instruction: 0x0600001f
    45a4:	001ece0b 	andseq	ip, lr, fp, lsl #28
    45a8:	bb0b0700 	bllt	2c61b0 <_bss_end+0x2ba34c>
    45ac:	08000027 	stmdaeq	r0, {r0, r1, r2, r5}
    45b0:	00290c0b 	eoreq	r0, r9, fp, lsl #24
    45b4:	f20b0900 	vmla.i8	d0, d11, d0
    45b8:	0a000026 	beq	4658 <CPSR_IRQ_INHIBIT+0x45d8>
    45bc:	001c1b0b 	andseq	r1, ip, fp, lsl #22
    45c0:	280b0b00 	stmdacs	fp, {r8, r9, fp}
    45c4:	0c00001f 	stceq	0, cr0, [r0], {31}
    45c8:	001b910b 	andseq	r9, fp, fp, lsl #2
    45cc:	c90b0d00 	stmdbgt	fp, {r8, sl, fp}
    45d0:	0e00002a 	cdpeq	0, 0, cr0, cr0, cr10, {1}
    45d4:	0023be0b 	eoreq	fp, r3, fp, lsl #28
    45d8:	9b0b0f00 	blls	2c81e0 <_bss_end+0x2bc37c>
    45dc:	10000020 	andne	r0, r0, r0, lsr #32
    45e0:	0023fb0b 	eoreq	pc, r3, fp, lsl #22
    45e4:	e80b1100 	stmda	fp, {r8, ip}
    45e8:	12000029 	andne	r0, r0, #41	; 0x29
    45ec:	001cde0b 	andseq	sp, ip, fp, lsl #28
    45f0:	ae0b1300 	cdpge	3, 0, cr1, cr11, cr0, {0}
    45f4:	14000020 	strne	r0, [r0], #-32	; 0xffffffe0
    45f8:	0023110b 	eoreq	r1, r3, fp, lsl #2
    45fc:	a90b1500 	stmdbge	fp, {r8, sl, ip}
    4600:	1600001e 			; <UNDEFINED> instruction: 0x1600001e
    4604:	00235d0b 	eoreq	r5, r3, fp, lsl #26
    4608:	730b1700 	movwvc	r1, #46848	; 0xb700
    460c:	18000021 	stmdane	r0, {r0, r5}
    4610:	001be60b 	andseq	lr, fp, fp, lsl #12
    4614:	8f0b1900 	svchi	0x000b1900
    4618:	1a000029 	bne	46c4 <CPSR_IRQ_INHIBIT+0x4644>
    461c:	0022dd0b 	eoreq	sp, r2, fp, lsl #26
    4620:	850b1b00 	strhi	r1, [fp, #-2816]	; 0xfffff500
    4624:	1c000020 	stcne	0, cr0, [r0], {32}
    4628:	001abb0b 	andseq	fp, sl, fp, lsl #22
    462c:	280b1d00 	stmdacs	fp, {r8, sl, fp, ip}
    4630:	1e000022 	cdpne	0, 0, cr0, cr0, cr2, {1}
    4634:	0022140b 	eoreq	r1, r2, fp, lsl #8
    4638:	af0b1f00 	svcge	0x000b1f00
    463c:	20000026 	andcs	r0, r0, r6, lsr #32
    4640:	00273a0b 	eoreq	r3, r7, fp, lsl #20
    4644:	6e0b2100 	adfvse	f2, f3, f0
    4648:	22000029 	andcs	r0, r0, #41	; 0x29
    464c:	001fb80b 	andseq	fp, pc, fp, lsl #16
    4650:	120b2300 	andne	r2, fp, #0, 6
    4654:	24000025 	strcs	r0, [r0], #-37	; 0xffffffdb
    4658:	0027070b 	eoreq	r0, r7, fp, lsl #14
    465c:	2b0b2500 	blcs	2cda64 <_bss_end+0x2c1c00>
    4660:	26000026 	strcs	r0, [r0], -r6, lsr #32
    4664:	00263f0b 	eoreq	r3, r6, fp, lsl #30
    4668:	530b2700 	movwpl	r2, #46848	; 0xb700
    466c:	28000026 	stmdacs	r0, {r1, r2, r5}
    4670:	001d690b 	andseq	r6, sp, fp, lsl #18
    4674:	c90b2900 	stmdbgt	fp, {r8, fp, sp}
    4678:	2a00001c 	bcs	46f0 <CPSR_IRQ_INHIBIT+0x4670>
    467c:	001cf10b 	andseq	pc, ip, fp, lsl #2
    4680:	040b2b00 	streq	r2, [fp], #-2816	; 0xfffff500
    4684:	2c000028 	stccs	0, cr0, [r0], {40}	; 0x28
    4688:	001d460b 	andseq	r4, sp, fp, lsl #12
    468c:	180b2d00 	stmdane	fp, {r8, sl, fp, sp}
    4690:	2e000028 	cdpcs	0, 0, cr0, cr0, cr8, {1}
    4694:	00282c0b 	eoreq	r2, r8, fp, lsl #24
    4698:	400b2f00 	andmi	r2, fp, r0, lsl #30
    469c:	30000028 	andcc	r0, r0, r8, lsr #32
    46a0:	001f3a0b 	andseq	r3, pc, fp, lsl #20
    46a4:	140b3100 	strne	r3, [fp], #-256	; 0xffffff00
    46a8:	3200001f 	andcc	r0, r0, #31
    46ac:	00223c0b 	eoreq	r3, r2, fp, lsl #24
    46b0:	0e0b3300 	cdpeq	3, 0, cr3, cr11, cr0, {0}
    46b4:	34000024 	strcc	r0, [r0], #-36	; 0xffffffdc
    46b8:	002a1d0b 	eoreq	r1, sl, fp, lsl #26
    46bc:	630b3500 	movwvs	r3, #46336	; 0xb500
    46c0:	3600001a 			; <UNDEFINED> instruction: 0x3600001a
    46c4:	00203a0b 	eoreq	r3, r0, fp, lsl #20
    46c8:	4f0b3700 	svcmi	0x000b3700
    46cc:	38000020 	stmdacc	r0, {r5}
    46d0:	00229e0b 	eoreq	r9, r2, fp, lsl #28
    46d4:	c80b3900 	stmdagt	fp, {r8, fp, ip, sp}
    46d8:	3a000022 	bcc	4768 <CPSR_IRQ_INHIBIT+0x46e8>
    46dc:	002a460b 	eoreq	r4, sl, fp, lsl #12
    46e0:	fd0b3b00 	stc2	11, cr3, [fp, #-0]	; <UNPREDICTABLE>
    46e4:	3c000024 	stccc	0, cr0, [r0], {36}	; 0x24
    46e8:	001fdd0b 	andseq	sp, pc, fp, lsl #26
    46ec:	220b3d00 	andcs	r3, fp, #0, 26
    46f0:	3e00001b 	mcrcc	0, 0, r0, cr0, cr11, {0}
    46f4:	001ae00b 	andseq	lr, sl, fp
    46f8:	5a0b3f00 	bpl	2d4300 <_bss_end+0x2c849c>
    46fc:	40000024 	andmi	r0, r0, r4, lsr #32
    4700:	00257e0b 	eoreq	r7, r5, fp, lsl #28
    4704:	910b4100 	mrsls	r4, (UNDEF: 27)
    4708:	42000026 	andmi	r0, r0, #38	; 0x26
    470c:	0022b30b 	eoreq	fp, r2, fp, lsl #6
    4710:	7f0b4300 	svcvc	0x000b4300
    4714:	4400002a 	strmi	r0, [r0], #-42	; 0xffffffd6
    4718:	0025280b 	eoreq	r2, r5, fp, lsl #16
    471c:	0d0b4500 	cfstr32eq	mvfx4, [fp, #-0]
    4720:	4600001d 			; <UNDEFINED> instruction: 0x4600001d
    4724:	00238e0b 	eoreq	r8, r3, fp, lsl #28
    4728:	c10b4700 	tstgt	fp, r0, lsl #14
    472c:	48000021 	stmdami	r0, {r0, r5}
    4730:	001a9f0b 	andseq	r9, sl, fp, lsl #30
    4734:	b30b4900 	movwlt	r4, #47360	; 0xb900
    4738:	4a00001b 	bmi	47ac <CPSR_IRQ_INHIBIT+0x472c>
    473c:	001ff10b 	andseq	pc, pc, fp, lsl #2
    4740:	ef0b4b00 	svc	0x000b4b00
    4744:	4c000022 	stcmi	0, cr0, [r0], {34}	; 0x22
    4748:	07020300 	streq	r0, [r2, -r0, lsl #6]
    474c:	00000502 	andeq	r0, r0, r2, lsl #10
    4750:	0003e40c 	andeq	lr, r3, ip, lsl #8
    4754:	0003d900 	andeq	sp, r3, r0, lsl #18
    4758:	0e000d00 	cdpeq	13, 0, cr0, cr0, cr0, {0}
    475c:	000003ce 	andeq	r0, r0, lr, asr #7
    4760:	03f00405 	mvnseq	r0, #83886080	; 0x5000000
    4764:	de0e0000 	cdple	0, 0, cr0, cr14, cr0, {0}
    4768:	03000003 	movweq	r0, #3
    476c:	04a00801 	strteq	r0, [r0], #2049	; 0x801
    4770:	e90e0000 	stmdb	lr, {}	; <UNPREDICTABLE>
    4774:	0f000003 	svceq	0x00000003
    4778:	00001c57 	andeq	r1, r0, r7, asr ip
    477c:	1a014c04 	bne	57794 <_bss_end+0x4b930>
    4780:	000003d9 	ldrdeq	r0, [r0], -r9
    4784:	0020750f 	eoreq	r7, r0, pc, lsl #10
    4788:	01820400 	orreq	r0, r2, r0, lsl #8
    478c:	0003d91a 	andeq	sp, r3, sl, lsl r9
    4790:	03e90c00 	mvneq	r0, #0, 24
    4794:	041a0000 	ldreq	r0, [sl], #-0
    4798:	000d0000 	andeq	r0, sp, r0
    479c:	00226009 	eoreq	r6, r2, r9
    47a0:	0d2d0500 	cfstr32eq	mvfx0, [sp, #-0]
    47a4:	0000040f 	andeq	r0, r0, pc, lsl #8
    47a8:	0028e809 	eoreq	lr, r8, r9, lsl #16
    47ac:	1c380500 	cfldr32ne	mvfx0, [r8], #-0
    47b0:	000001e6 	andeq	r0, r0, r6, ror #3
    47b4:	001f4e0a 	andseq	r4, pc, sl, lsl #28
    47b8:	93010700 	movwls	r0, #5888	; 0x1700
    47bc:	05000000 	streq	r0, [r0, #-0]
    47c0:	04a50e3a 	strteq	r0, [r5], #3642	; 0xe3a
    47c4:	b40b0000 	strlt	r0, [fp], #-0
    47c8:	0000001a 	andeq	r0, r0, sl, lsl r0
    47cc:	0021600b 	eoreq	r6, r1, fp
    47d0:	fa0b0100 	blx	2c4bd8 <_bss_end+0x2b8d74>
    47d4:	02000029 	andeq	r0, r0, #41	; 0x29
    47d8:	0029bd0b 	eoreq	fp, r9, fp, lsl #26
    47dc:	b70b0300 	strlt	r0, [fp, -r0, lsl #6]
    47e0:	04000024 	streq	r0, [r0], #-36	; 0xffffffdc
    47e4:	0027780b 	eoreq	r7, r7, fp, lsl #16
    47e8:	9a0b0500 	bls	2c5bf0 <_bss_end+0x2b9d8c>
    47ec:	0600001c 			; <UNDEFINED> instruction: 0x0600001c
    47f0:	001c7c0b 	andseq	r7, ip, fp, lsl #24
    47f4:	950b0700 	strls	r0, [fp, #-1792]	; 0xfffff900
    47f8:	0800001e 	stmdaeq	r0, {r1, r2, r3, r4}
    47fc:	0023730b 	eoreq	r7, r3, fp, lsl #6
    4800:	a10b0900 	tstge	fp, r0, lsl #18
    4804:	0a00001c 	beq	487c <CPSR_IRQ_INHIBIT+0x47fc>
    4808:	00237a0b 	eoreq	r7, r3, fp, lsl #20
    480c:	060b0b00 	streq	r0, [fp], -r0, lsl #22
    4810:	0c00001d 	stceq	0, cr0, [r0], {29}
    4814:	001c930b 	andseq	r9, ip, fp, lsl #6
    4818:	cf0b0d00 	svcgt	0x000b0d00
    481c:	0e000027 	cdpeq	0, 0, cr0, cr0, cr7, {1}
    4820:	00259c0b 	eoreq	r9, r5, fp, lsl #24
    4824:	04000f00 	streq	r0, [r0], #-3840	; 0xfffff100
    4828:	000026c7 	andeq	r2, r0, r7, asr #13
    482c:	32013f05 	andcc	r3, r1, #5, 30
    4830:	09000004 	stmdbeq	r0, {r2}
    4834:	0000275b 	andeq	r2, r0, fp, asr r7
    4838:	a50f4105 	strge	r4, [pc, #-261]	; 473b <CPSR_IRQ_INHIBIT+0x46bb>
    483c:	09000004 	stmdbeq	r0, {r2}
    4840:	000027e3 	andeq	r2, r0, r3, ror #15
    4844:	1d0c4a05 	vstrne	s8, [ip, #-20]	; 0xffffffec
    4848:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
    484c:	00001c3b 	andeq	r1, r0, fp, lsr ip
    4850:	1d0c4b05 	vstrne	d4, [ip, #-20]	; 0xffffffec
    4854:	10000000 	andne	r0, r0, r0
    4858:	000028bc 			; <UNDEFINED> instruction: 0x000028bc
    485c:	0027f409 	eoreq	pc, r7, r9, lsl #8
    4860:	144c0500 	strbne	r0, [ip], #-1280	; 0xfffffb00
    4864:	000004e6 	andeq	r0, r0, r6, ror #9
    4868:	04d50405 	ldrbeq	r0, [r5], #1029	; 0x405
    486c:	09110000 	ldmdbeq	r1, {}	; <UNPREDICTABLE>
    4870:	0000212a 	andeq	r2, r0, sl, lsr #2
    4874:	f90f4e05 			; <UNDEFINED> instruction: 0xf90f4e05
    4878:	05000004 	streq	r0, [r0, #-4]
    487c:	0004ec04 	andeq	lr, r4, r4, lsl #24
    4880:	26dd1200 	ldrbcs	r1, [sp], r0, lsl #4
    4884:	a4090000 	strge	r0, [r9], #-0
    4888:	05000024 	streq	r0, [r0, #-36]	; 0xffffffdc
    488c:	05100d52 	ldreq	r0, [r0, #-3410]	; 0xfffff2ae
    4890:	04050000 	streq	r0, [r5], #-0
    4894:	000004ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    4898:	001db213 	andseq	fp, sp, r3, lsl r2
    489c:	67053400 	strvs	r3, [r5, -r0, lsl #8]
    48a0:	05411501 	strbeq	r1, [r1, #-1281]	; 0xfffffaff
    48a4:	69140000 	ldmdbvs	r4, {}	; <UNPREDICTABLE>
    48a8:	05000022 	streq	r0, [r0, #-34]	; 0xffffffde
    48ac:	de0f0169 	adfleez	f0, f7, #1.0
    48b0:	00000003 	andeq	r0, r0, r3
    48b4:	001d9614 	andseq	r9, sp, r4, lsl r6
    48b8:	016a0500 	cmneq	sl, r0, lsl #10
    48bc:	00054614 	andeq	r4, r5, r4, lsl r6
    48c0:	0e000400 	cfcpyseq	mvf0, mvf0
    48c4:	00000516 	andeq	r0, r0, r6, lsl r5
    48c8:	0000b90c 	andeq	fp, r0, ip, lsl #18
    48cc:	00055600 	andeq	r5, r5, r0, lsl #12
    48d0:	00241500 	eoreq	r1, r4, r0, lsl #10
    48d4:	002d0000 	eoreq	r0, sp, r0
    48d8:	0005410c 	andeq	r4, r5, ip, lsl #2
    48dc:	00056100 	andeq	r6, r5, r0, lsl #2
    48e0:	0e000d00 	cdpeq	13, 0, cr0, cr0, cr0, {0}
    48e4:	00000556 	andeq	r0, r0, r6, asr r5
    48e8:	0021980f 	eoreq	r9, r1, pc, lsl #16
    48ec:	016b0500 	cmneq	fp, r0, lsl #10
    48f0:	00056103 	andeq	r6, r5, r3, lsl #2
    48f4:	23de0f00 	bicscs	r0, lr, #0, 30
    48f8:	6e050000 	cdpvs	0, 0, cr0, cr5, cr0, {0}
    48fc:	001d0c01 	andseq	r0, sp, r1, lsl #24
    4900:	1b160000 	blne	584908 <_bss_end+0x578aa4>
    4904:	07000027 	streq	r0, [r0, -r7, lsr #32]
    4908:	00009301 	andeq	r9, r0, r1, lsl #6
    490c:	01810500 	orreq	r0, r1, r0, lsl #10
    4910:	00062a06 	andeq	r2, r6, r6, lsl #20
    4914:	1b490b00 	blne	124751c <_bss_end+0x123b6b8>
    4918:	0b000000 	bleq	4920 <CPSR_IRQ_INHIBIT+0x48a0>
    491c:	00001b55 	andeq	r1, r0, r5, asr fp
    4920:	1b610b02 	blne	1847530 <_bss_end+0x183b6cc>
    4924:	0b030000 	bleq	c492c <_bss_end+0xb8ac8>
    4928:	00001f7a 	andeq	r1, r0, sl, ror pc
    492c:	1b6d0b03 	blne	1b47540 <_bss_end+0x1b3b6dc>
    4930:	0b040000 	bleq	104938 <_bss_end+0xf8ad4>
    4934:	000020c3 	andeq	r2, r0, r3, asr #1
    4938:	21a90b04 			; <UNDEFINED> instruction: 0x21a90b04
    493c:	0b050000 	bleq	144944 <_bss_end+0x138ae0>
    4940:	000020ff 	strdeq	r2, [r0], -pc	; <UNPREDICTABLE>
    4944:	1c2c0b05 			; <UNDEFINED> instruction: 0x1c2c0b05
    4948:	0b050000 	bleq	144950 <_bss_end+0x138aec>
    494c:	00001b79 	andeq	r1, r0, r9, ror fp
    4950:	23270b06 			; <UNDEFINED> instruction: 0x23270b06
    4954:	0b060000 	bleq	18495c <_bss_end+0x178af8>
    4958:	00001d88 	andeq	r1, r0, r8, lsl #27
    495c:	23340b06 	teqcs	r4, #6144	; 0x1800
    4960:	0b060000 	bleq	184968 <_bss_end+0x178b04>
    4964:	0000279b 	muleq	r0, fp, r7
    4968:	23410b06 	movtcs	r0, #6918	; 0x1b06
    496c:	0b060000 	bleq	184974 <_bss_end+0x178b10>
    4970:	00002381 	andeq	r2, r0, r1, lsl #7
    4974:	1b850b06 	blne	fe147594 <_bss_end+0xfe13b730>
    4978:	0b070000 	bleq	1c4980 <_bss_end+0x1b8b1c>
    497c:	00002487 	andeq	r2, r0, r7, lsl #9
    4980:	24d40b07 	ldrbcs	r0, [r4], #2823	; 0xb07
    4984:	0b070000 	bleq	1c498c <_bss_end+0x1b8b28>
    4988:	000027d6 	ldrdeq	r2, [r0], -r6
    498c:	1d5b0b07 	vldrne	d16, [fp, #-28]	; 0xffffffe4
    4990:	0b070000 	bleq	1c4998 <_bss_end+0x1b8b34>
    4994:	00002555 	andeq	r2, r0, r5, asr r5
    4998:	1afe0b08 	bne	fff875c0 <_bss_end+0xfff7b75c>
    499c:	0b080000 	bleq	2049a4 <_bss_end+0x1f8b40>
    49a0:	000027a9 	andeq	r2, r0, r9, lsr #15
    49a4:	25710b08 	ldrbcs	r0, [r1, #-2824]!	; 0xfffff4f8
    49a8:	00080000 	andeq	r0, r8, r0
    49ac:	002a0f0f 	eoreq	r0, sl, pc, lsl #30
    49b0:	019f0500 	orrseq	r0, pc, r0, lsl #10
    49b4:	0005801f 	andeq	r8, r5, pc, lsl r0
    49b8:	25a30f00 	strcs	r0, [r3, #3840]!	; 0xf00
    49bc:	a2050000 	andge	r0, r5, #0
    49c0:	001d0c01 	andseq	r0, sp, r1, lsl #24
    49c4:	b60f0000 	strlt	r0, [pc], -r0
    49c8:	05000021 	streq	r0, [r0, #-33]	; 0xffffffdf
    49cc:	1d0c01a5 	stfnes	f0, [ip, #-660]	; 0xfffffd6c
    49d0:	0f000000 	svceq	0x00000000
    49d4:	00002adb 	ldrdeq	r2, [r0], -fp
    49d8:	0c01a805 	stceq	8, cr10, [r1], {5}
    49dc:	0000001d 	andeq	r0, r0, sp, lsl r0
    49e0:	001c4b0f 	andseq	r4, ip, pc, lsl #22
    49e4:	01ab0500 			; <UNDEFINED> instruction: 0x01ab0500
    49e8:	00001d0c 	andeq	r1, r0, ip, lsl #26
    49ec:	25ad0f00 	strcs	r0, [sp, #3840]!	; 0xf00
    49f0:	ae050000 	cdpge	0, 0, cr0, cr5, cr0, {0}
    49f4:	001d0c01 	andseq	r0, sp, r1, lsl #24
    49f8:	be0f0000 	cdplt	0, 0, cr0, cr15, cr0, {0}
    49fc:	05000024 	streq	r0, [r0, #-36]	; 0xffffffdc
    4a00:	1d0c01b1 	stfnes	f0, [ip, #-708]	; 0xfffffd3c
    4a04:	0f000000 	svceq	0x00000000
    4a08:	000024c9 	andeq	r2, r0, r9, asr #9
    4a0c:	0c01b405 	cfstrseq	mvf11, [r1], {5}
    4a10:	0000001d 	andeq	r0, r0, sp, lsl r0
    4a14:	0025b70f 	eoreq	fp, r5, pc, lsl #14
    4a18:	01b70500 			; <UNDEFINED> instruction: 0x01b70500
    4a1c:	00001d0c 	andeq	r1, r0, ip, lsl #26
    4a20:	23030f00 	movwcs	r0, #16128	; 0x3f00
    4a24:	ba050000 	blt	144a2c <_bss_end+0x138bc8>
    4a28:	001d0c01 	andseq	r0, sp, r1, lsl #24
    4a2c:	3a0f0000 	bcc	3c4a34 <_bss_end+0x3b8bd0>
    4a30:	0500002a 	streq	r0, [r0, #-42]	; 0xffffffd6
    4a34:	1d0c01bd 	stfnes	f0, [ip, #-756]	; 0xfffffd0c
    4a38:	0f000000 	svceq	0x00000000
    4a3c:	000025c1 	andeq	r2, r0, r1, asr #11
    4a40:	0c01c005 	stceq	0, cr12, [r1], {5}
    4a44:	0000001d 	andeq	r0, r0, sp, lsl r0
    4a48:	002afe0f 	eoreq	pc, sl, pc, lsl #28
    4a4c:	01c30500 	biceq	r0, r3, r0, lsl #10
    4a50:	00001d0c 	andeq	r1, r0, ip, lsl #26
    4a54:	29c40f00 	stmibcs	r4, {r8, r9, sl, fp}^
    4a58:	c6050000 	strgt	r0, [r5], -r0
    4a5c:	001d0c01 	andseq	r0, sp, r1, lsl #24
    4a60:	d00f0000 	andle	r0, pc, r0
    4a64:	05000029 	streq	r0, [r0, #-41]	; 0xffffffd7
    4a68:	1d0c01c9 	stfnes	f0, [ip, #-804]	; 0xfffffcdc
    4a6c:	0f000000 	svceq	0x00000000
    4a70:	000029dc 	ldrdeq	r2, [r0], -ip
    4a74:	0c01cc05 	stceq	12, cr12, [r1], {5}
    4a78:	0000001d 	andeq	r0, r0, sp, lsl r0
    4a7c:	002a010f 	eoreq	r0, sl, pc, lsl #2
    4a80:	01d00500 	bicseq	r0, r0, r0, lsl #10
    4a84:	00001d0c 	andeq	r1, r0, ip, lsl #26
    4a88:	2af10f00 	bcs	ffc48690 <_bss_end+0xffc3c82c>
    4a8c:	d3050000 	movwle	r0, #20480	; 0x5000
    4a90:	001d0c01 	andseq	r0, sp, r1, lsl #24
    4a94:	a80f0000 	stmdage	pc, {}	; <UNPREDICTABLE>
    4a98:	0500001c 	streq	r0, [r0, #-28]	; 0xffffffe4
    4a9c:	1d0c01d6 	stfnes	f0, [ip, #-856]	; 0xfffffca8
    4aa0:	0f000000 	svceq	0x00000000
    4aa4:	00001a8f 	andeq	r1, r0, pc, lsl #21
    4aa8:	0c01d905 			; <UNDEFINED> instruction: 0x0c01d905
    4aac:	0000001d 	andeq	r0, r0, sp, lsl r0
    4ab0:	001f9a0f 	andseq	r9, pc, pc, lsl #20
    4ab4:	01dc0500 	bicseq	r0, ip, r0, lsl #10
    4ab8:	00001d0c 	andeq	r1, r0, ip, lsl #26
    4abc:	1c830f00 	stcne	15, cr0, [r3], {0}
    4ac0:	df050000 	svcle	0x00050000
    4ac4:	001d0c01 	andseq	r0, sp, r1, lsl #24
    4ac8:	d70f0000 	strle	r0, [pc, -r0]
    4acc:	05000025 	streq	r0, [r0, #-37]	; 0xffffffdb
    4ad0:	1d0c01e2 	stfnes	f0, [ip, #-904]	; 0xfffffc78
    4ad4:	0f000000 	svceq	0x00000000
    4ad8:	000021df 	ldrdeq	r2, [r0], -pc	; <UNPREDICTABLE>
    4adc:	0c01e505 	cfstr32eq	mvfx14, [r1], {5}
    4ae0:	0000001d 	andeq	r0, r0, sp, lsl r0
    4ae4:	0024370f 	eoreq	r3, r4, pc, lsl #14
    4ae8:	01e80500 	mvneq	r0, r0, lsl #10
    4aec:	00001d0c 	andeq	r1, r0, ip, lsl #26
    4af0:	28f10f00 	ldmcs	r1!, {r8, r9, sl, fp}^
    4af4:	ef050000 	svc	0x00050000
    4af8:	001d0c01 	andseq	r0, sp, r1, lsl #24
    4afc:	a90f0000 	stmdbge	pc, {}	; <UNPREDICTABLE>
    4b00:	0500002a 	streq	r0, [r0, #-42]	; 0xffffffd6
    4b04:	1d0c01f2 	stfnes	f0, [ip, #-968]	; 0xfffffc38
    4b08:	0f000000 	svceq	0x00000000
    4b0c:	00002ab9 			; <UNDEFINED> instruction: 0x00002ab9
    4b10:	0c01f505 	cfstr32eq	mvfx15, [r1], {5}
    4b14:	0000001d 	andeq	r0, r0, sp, lsl r0
    4b18:	001d9f0f 	andseq	r9, sp, pc, lsl #30
    4b1c:	01f80500 	mvnseq	r0, r0, lsl #10
    4b20:	00001d0c 	andeq	r1, r0, ip, lsl #26
    4b24:	29380f00 	ldmdbcs	r8!, {r8, r9, sl, fp}
    4b28:	fb050000 	blx	144b32 <_bss_end+0x138cce>
    4b2c:	001d0c01 	andseq	r0, sp, r1, lsl #24
    4b30:	3d0f0000 	stccc	0, cr0, [pc, #-0]	; 4b38 <CPSR_IRQ_INHIBIT+0x4ab8>
    4b34:	05000025 	streq	r0, [r0, #-37]	; 0xffffffdb
    4b38:	1d0c01fe 	stfnes	f0, [ip, #-1016]	; 0xfffffc08
    4b3c:	0f000000 	svceq	0x00000000
    4b40:	00002013 	andeq	r2, r0, r3, lsl r0
    4b44:	0c020205 	sfmeq	f0, 4, [r2], {5}
    4b48:	0000001d 	andeq	r0, r0, sp, lsl r0
    4b4c:	00272d0f 	eoreq	r2, r7, pc, lsl #26
    4b50:	020a0500 	andeq	r0, sl, #0, 10
    4b54:	00001d0c 	andeq	r1, r0, ip, lsl #26
    4b58:	1f060f00 	svcne	0x00060f00
    4b5c:	0d050000 	stceq	0, cr0, [r5, #-0]
    4b60:	001d0c02 	andseq	r0, sp, r2, lsl #24
    4b64:	1d0c0000 	stcne	0, cr0, [ip, #-0]
    4b68:	ef000000 	svc	0x00000000
    4b6c:	0d000007 	stceq	0, cr0, [r0, #-28]	; 0xffffffe4
    4b70:	20df0f00 	sbcscs	r0, pc, r0, lsl #30
    4b74:	fb050000 	blx	144b7e <_bss_end+0x138d1a>
    4b78:	07e40c03 	strbeq	r0, [r4, r3, lsl #24]!
    4b7c:	e60c0000 	str	r0, [ip], -r0
    4b80:	0c000004 	stceq	0, cr0, [r0], {4}
    4b84:	15000008 	strne	r0, [r0, #-8]
    4b88:	00000024 	andeq	r0, r0, r4, lsr #32
    4b8c:	fa0f000d 	blx	3c4bc8 <_bss_end+0x3b8d64>
    4b90:	05000025 	streq	r0, [r0, #-37]	; 0xffffffdb
    4b94:	fc140584 	ldc2	5, cr0, [r4], {132}	; 0x84
    4b98:	16000007 	strne	r0, [r0], -r7
    4b9c:	000021a1 	andeq	r2, r0, r1, lsr #3
    4ba0:	00930107 	addseq	r0, r3, r7, lsl #2
    4ba4:	8b050000 	blhi	144bac <_bss_end+0x138d48>
    4ba8:	08570605 	ldmdaeq	r7, {r0, r2, r9, sl}^
    4bac:	5c0b0000 	stcpl	0, cr0, [fp], {-0}
    4bb0:	0000001f 	andeq	r0, r0, pc, lsl r0
    4bb4:	0023ac0b 	eoreq	sl, r3, fp, lsl #24
    4bb8:	340b0100 	strcc	r0, [fp], #-256	; 0xffffff00
    4bbc:	0200001b 	andeq	r0, r0, #27
    4bc0:	002a6b0b 	eoreq	r6, sl, fp, lsl #22
    4bc4:	740b0300 	strvc	r0, [fp], #-768	; 0xfffffd00
    4bc8:	04000026 	streq	r0, [r0], #-38	; 0xffffffda
    4bcc:	0026670b 	eoreq	r6, r6, fp, lsl #14
    4bd0:	0b0b0500 	bleq	2c5fd8 <_bss_end+0x2ba174>
    4bd4:	0600001c 			; <UNDEFINED> instruction: 0x0600001c
    4bd8:	2a5b0f00 	bcs	16c87e0 <_bss_end+0x16bc97c>
    4bdc:	98050000 	stmdals	r5, {}	; <UNPREDICTABLE>
    4be0:	08191505 	ldmdaeq	r9, {r0, r2, r8, sl, ip}
    4be4:	5d0f0000 	stcpl	0, cr0, [pc, #-0]	; 4bec <CPSR_IRQ_INHIBIT+0x4b6c>
    4be8:	05000029 	streq	r0, [r0, #-41]	; 0xffffffd7
    4bec:	24110799 	ldrcs	r0, [r1], #-1945	; 0xfffff867
    4bf0:	0f000000 	svceq	0x00000000
    4bf4:	000025e7 	andeq	r2, r0, r7, ror #11
    4bf8:	0c07ae05 	stceq	14, cr10, [r7], {5}
    4bfc:	0000001d 	andeq	r0, r0, sp, lsl r0
    4c00:	0028d004 	eoreq	sp, r8, r4
    4c04:	167b0600 	ldrbtne	r0, [fp], -r0, lsl #12
    4c08:	00000093 	muleq	r0, r3, r0
    4c0c:	00087e0e 	andeq	r7, r8, lr, lsl #28
    4c10:	05020300 	streq	r0, [r2, #-768]	; 0xfffffd00
    4c14:	00000280 	andeq	r0, r0, r0, lsl #5
    4c18:	ef070803 	svc	0x00070803
    4c1c:	0300001e 	movweq	r0, #30
    4c20:	1cc30404 	cfstrdne	mvd0, [r3], {4}
    4c24:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    4c28:	001cbb03 	andseq	fp, ip, r3, lsl #22
    4c2c:	04080300 	streq	r0, [r8], #-768	; 0xfffffd00
    4c30:	000025d0 	ldrdeq	r2, [r0], -r0
    4c34:	82031003 	andhi	r1, r3, #3
    4c38:	0c000026 	stceq	0, cr0, [r0], {38}	; 0x26
    4c3c:	0000088a 	andeq	r0, r0, sl, lsl #17
    4c40:	000008c9 	andeq	r0, r0, r9, asr #17
    4c44:	00002415 	andeq	r2, r0, r5, lsl r4
    4c48:	0e00ff00 	cdpeq	15, 0, cr15, cr0, cr0, {0}
    4c4c:	000008b9 			; <UNDEFINED> instruction: 0x000008b9
    4c50:	0024e10f 	eoreq	lr, r4, pc, lsl #2
    4c54:	01fc0600 	mvnseq	r0, r0, lsl #12
    4c58:	0008c916 	andeq	ip, r8, r6, lsl r9
    4c5c:	1c720f00 	ldclne	15, cr0, [r2], #-0
    4c60:	02060000 	andeq	r0, r6, #0
    4c64:	08c91602 	stmiaeq	r9, {r1, r9, sl, ip}^
    4c68:	03040000 	movweq	r0, #16384	; 0x4000
    4c6c:	07000029 	streq	r0, [r0, -r9, lsr #32]
    4c70:	04f9102a 	ldrbteq	r1, [r9], #42	; 0x2a
    4c74:	e80c0000 	stmda	ip, {}	; <UNPREDICTABLE>
    4c78:	ff000008 			; <UNDEFINED> instruction: 0xff000008
    4c7c:	0d000008 	stceq	0, cr0, [r0, #-32]	; 0xffffffe0
    4c80:	18a90900 	stmiane	r9!, {r8, fp}
    4c84:	2f070000 	svccs	0x00070000
    4c88:	0008f411 	andeq	pc, r8, r1, lsl r4	; <UNPREDICTABLE>
    4c8c:	18db0900 	ldmne	fp, {r8, fp}^
    4c90:	30070000 	andcc	r0, r7, r0
    4c94:	0008f411 	andeq	pc, r8, r1, lsl r4	; <UNPREDICTABLE>
    4c98:	08ff1700 	ldmeq	pc!, {r8, r9, sl, ip}^	; <UNPREDICTABLE>
    4c9c:	33080000 	movwcc	r0, #32768	; 0x8000
    4ca0:	03050a09 	movweq	r0, #23049	; 0x5a09
    4ca4:	0000adec 	andeq	sl, r0, ip, ror #27
    4ca8:	00090b17 	andeq	r0, r9, r7, lsl fp
    4cac:	09340800 	ldmdbeq	r4!, {fp}
    4cb0:	0803050a 	stmdaeq	r3, {r1, r3, r8, sl}
    4cb4:	000000ae 	andeq	r0, r0, lr, lsr #1

Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
       0:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
       4:	030b130e 	movweq	r1, #45838	; 0xb30e
       8:	110e1b0e 	tstne	lr, lr, lsl #22
       c:	10061201 	andne	r1, r6, r1, lsl #4
      10:	02000017 	andeq	r0, r0, #23
      14:	193f002e 	ldmdbne	pc!, {r1, r2, r3, r5}	; <UNPREDICTABLE>
      18:	0b3a0e03 	bleq	e8382c <_bss_end+0xe779c8>
      1c:	0b390b3b 	bleq	e42d10 <_bss_end+0xe36eac>
      20:	06120111 			; <UNDEFINED> instruction: 0x06120111
      24:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
      28:	03000019 	movweq	r0, #25
      2c:	0e030139 	mcreq	1, 0, r0, cr3, cr9, {1}
      30:	0b3b0b3a 	bleq	ec2d20 <_bss_end+0xeb6ebc>
      34:	00001301 	andeq	r1, r0, r1, lsl #6
      38:	3f012e04 	svccc	0x00012e04
      3c:	3a0e0319 	bcc	380ca8 <_bss_end+0x374e44>
      40:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
      44:	01193c0b 	tsteq	r9, fp, lsl #24
      48:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
      4c:	13490005 	movtne	r0, #36869	; 0x9005
      50:	16060000 	strne	r0, [r6], -r0
      54:	3a0e0300 	bcc	380c5c <_bss_end+0x374df8>
      58:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
      5c:	0013490b 	andseq	r4, r3, fp, lsl #18
      60:	012e0700 			; <UNDEFINED> instruction: 0x012e0700
      64:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
      68:	0b3b0b3a 	bleq	ec2d58 <_bss_end+0xeb6ef4>
      6c:	13490b39 	movtne	r0, #39737	; 0x9b39
      70:	0000193c 	andeq	r1, r0, ip, lsr r9
      74:	0b000f08 	bleq	3c9c <CPSR_IRQ_INHIBIT+0x3c1c>
      78:	0013490b 	andseq	r4, r3, fp, lsl #18
      7c:	00240900 	eoreq	r0, r4, r0, lsl #18
      80:	0b3e0b0b 	bleq	f82cb4 <_bss_end+0xf76e50>
      84:	00000e03 	andeq	r0, r0, r3, lsl #28
      88:	47012e0a 	strmi	r2, [r1, -sl, lsl #28]
      8c:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
      90:	97184006 	ldrls	r4, [r8, -r6]
      94:	13011942 	movwne	r1, #6466	; 0x1942
      98:	050b0000 	streq	r0, [fp, #-0]
      9c:	02134900 	andseq	r4, r3, #0, 18
      a0:	0c000018 	stceq	0, cr0, [r0], {24}
      a4:	08030005 	stmdaeq	r3, {r0, r2}
      a8:	0b3b0b3a 	bleq	ec2d98 <_bss_end+0xeb6f34>
      ac:	13490b39 	movtne	r0, #39737	; 0x9b39
      b0:	00001802 	andeq	r1, r0, r2, lsl #16
      b4:	0b00240d 	bleq	90f0 <_ZN6CTimer20Is_Timer_IRQ_PendingEv+0x2c>
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
      e4:	0b0b0024 	bleq	2c017c <_bss_end+0x2b4318>
      e8:	0e030b3e 	vmoveq.16	d3[0], r0
      ec:	24030000 	strcs	r0, [r3], #-0
      f0:	3e0b0b00 	vmlacc.f64	d0, d11, d0
      f4:	0008030b 	andeq	r0, r8, fp, lsl #6
      f8:	00160400 	andseq	r0, r6, r0, lsl #8
      fc:	0b3a0e03 	bleq	e83910 <_bss_end+0xe77aac>
     100:	0b390b3b 	bleq	e42df4 <_bss_end+0xe36f90>
     104:	00001349 	andeq	r1, r0, r9, asr #6
     108:	49002605 	stmdbmi	r0, {r0, r2, r9, sl, sp}
     10c:	06000013 			; <UNDEFINED> instruction: 0x06000013
     110:	13490035 	movtne	r0, #36917	; 0x9035
     114:	39070000 	stmdbcc	r7, {}	; <UNPREDICTABLE>
     118:	3a080301 	bcc	200d24 <_bss_end+0x1f4ec0>
     11c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     120:	0013010b 	andseq	r0, r3, fp, lsl #2
     124:	00340800 	eorseq	r0, r4, r0, lsl #16
     128:	0b3a0e03 	bleq	e8393c <_bss_end+0xe77ad8>
     12c:	0b390b3b 	bleq	e42e20 <_bss_end+0xe36fbc>
     130:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
     134:	196c061c 	stmdbne	ip!, {r2, r3, r4, r9, sl}^
     138:	34090000 	strcc	r0, [r9], #-0
     13c:	3a0e0300 	bcc	380d44 <_bss_end+0x374ee0>
     140:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     144:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
     148:	6c0b1c19 	stcvs	12, cr1, [fp], {25}
     14c:	0a000019 	beq	1b8 <CPSR_IRQ_INHIBIT+0x138>
     150:	0e030104 	adfeqs	f0, f3, f4
     154:	0b3e196d 	bleq	f86710 <_bss_end+0xf7a8ac>
     158:	13490b0b 	movtne	r0, #39691	; 0x9b0b
     15c:	0b3b0b3a 	bleq	ec2e4c <_bss_end+0xeb6fe8>
     160:	13010b39 	movwne	r0, #6969	; 0x1b39
     164:	280b0000 	stmdacs	fp, {}	; <UNPREDICTABLE>
     168:	1c0e0300 	stcne	3, cr0, [lr], {-0}
     16c:	0c00000b 	stceq	0, cr0, [r0], {11}
     170:	13470034 	movtne	r0, #28724	; 0x7034
     174:	020d0000 	andeq	r0, sp, #0
     178:	0b0e0301 	bleq	380d84 <_bss_end+0x374f20>
     17c:	3b0b3a0b 	blcc	2ce9b0 <_bss_end+0x2c2b4c>
     180:	010b390b 	tsteq	fp, fp, lsl #18
     184:	0e000013 	mcreq	0, 0, r0, cr0, cr3, {0}
     188:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
     18c:	0b3b0b3a 	bleq	ec2e7c <_bss_end+0xeb7018>
     190:	13490b39 	movtne	r0, #39737	; 0x9b39
     194:	00000b38 	andeq	r0, r0, r8, lsr fp
     198:	3f012e0f 	svccc	0x00012e0f
     19c:	3a0e0319 	bcc	380e08 <_bss_end+0x374fa4>
     1a0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     1a4:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
     1a8:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
     1ac:	01136419 	tsteq	r3, r9, lsl r4
     1b0:	10000013 	andne	r0, r0, r3, lsl r0
     1b4:	13490005 	movtne	r0, #36869	; 0x9005
     1b8:	00001934 	andeq	r1, r0, r4, lsr r9
     1bc:	49000511 	stmdbmi	r0, {r0, r4, r8, sl}
     1c0:	12000013 	andne	r0, r0, #19
     1c4:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
     1c8:	0b3a0e03 	bleq	e839dc <_bss_end+0xe77b78>
     1cc:	0b390b3b 	bleq	e42ec0 <_bss_end+0xe3705c>
     1d0:	0b320e6e 	bleq	c83b90 <_bss_end+0xc77d2c>
     1d4:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
     1d8:	00001301 	andeq	r1, r0, r1, lsl #6
     1dc:	3f012e13 	svccc	0x00012e13
     1e0:	3a0e0319 	bcc	380e4c <_bss_end+0x374fe8>
     1e4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     1e8:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
     1ec:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
     1f0:	00136419 	andseq	r6, r3, r9, lsl r4
     1f4:	000f1400 	andeq	r1, pc, r0, lsl #8
     1f8:	13490b0b 	movtne	r0, #39691	; 0x9b0b
     1fc:	10150000 	andsne	r0, r5, r0
     200:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
     204:	16000013 			; <UNDEFINED> instruction: 0x16000013
     208:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
     20c:	0b3b0b3a 	bleq	ec2efc <_bss_end+0xeb7098>
     210:	13490b39 	movtne	r0, #39737	; 0x9b39
     214:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
     218:	34170000 	ldrcc	r0, [r7], #-0
     21c:	3a134700 	bcc	4d1e24 <_bss_end+0x4c5fc0>
     220:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     224:	0018020b 	andseq	r0, r8, fp, lsl #4
     228:	002e1800 	eoreq	r1, lr, r0, lsl #16
     22c:	19340e03 	ldmdbne	r4!, {r0, r1, r9, sl, fp}
     230:	06120111 			; <UNDEFINED> instruction: 0x06120111
     234:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
     238:	19000019 	stmdbne	r0, {r0, r3, r4}
     23c:	0e03012e 	adfeqsp	f0, f3, #0.5
     240:	01111934 	tsteq	r1, r4, lsr r9
     244:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
     248:	01194296 			; <UNDEFINED> instruction: 0x01194296
     24c:	1a000013 	bne	2a0 <CPSR_IRQ_INHIBIT+0x220>
     250:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
     254:	0b3b0b3a 	bleq	ec2f44 <_bss_end+0xeb70e0>
     258:	13490b39 	movtne	r0, #39737	; 0x9b39
     25c:	00001802 	andeq	r1, r0, r2, lsl #16
     260:	47012e1b 	smladmi	r1, fp, lr, r2
     264:	3b0b3a13 	blcc	2ceab8 <_bss_end+0x2c2c54>
     268:	640b390b 	strvs	r3, [fp], #-2315	; 0xfffff6f5
     26c:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
     270:	96184006 	ldrls	r4, [r8], -r6
     274:	13011942 	movwne	r1, #6466	; 0x1942
     278:	051c0000 	ldreq	r0, [ip, #-0]
     27c:	490e0300 	stmdbmi	lr, {r8, r9}
     280:	02193413 	andseq	r3, r9, #318767104	; 0x13000000
     284:	1d000018 	stcne	0, cr0, [r0, #-96]	; 0xffffffa0
     288:	08030005 	stmdaeq	r3, {r0, r2}
     28c:	0b3b0b3a 	bleq	ec2f7c <_bss_end+0xeb7118>
     290:	13490b39 	movtne	r0, #39737	; 0x9b39
     294:	00001802 	andeq	r1, r0, r2, lsl #16
     298:	0300341e 	movweq	r3, #1054	; 0x41e
     29c:	3b0b3a08 	blcc	2ceac4 <_bss_end+0x2c2c60>
     2a0:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     2a4:	00180213 	andseq	r0, r8, r3, lsl r2
     2a8:	00341f00 	eorseq	r1, r4, r0, lsl #30
     2ac:	0b3a0e03 	bleq	e83ac0 <_bss_end+0xe77c5c>
     2b0:	0b390b3b 	bleq	e42fa4 <_bss_end+0xe37140>
     2b4:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
     2b8:	2e200000 	cdpcs	0, 2, cr0, cr0, cr0, {0}
     2bc:	3a134701 	bcc	4d1ec8 <_bss_end+0x4c6064>
     2c0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     2c4:	1113640b 	tstne	r3, fp, lsl #8
     2c8:	40061201 	andmi	r1, r6, r1, lsl #4
     2cc:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
     2d0:	00001301 	andeq	r1, r0, r1, lsl #6
     2d4:	47012e21 	strmi	r2, [r1, -r1, lsr #28]
     2d8:	3b0b3a13 	blcc	2ceb2c <_bss_end+0x2c2cc8>
     2dc:	640b390b 	strvs	r3, [fp], #-2315	; 0xfffff6f5
     2e0:	010b2013 	tsteq	fp, r3, lsl r0
     2e4:	22000013 	andcs	r0, r0, #19
     2e8:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
     2ec:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
     2f0:	05230000 	streq	r0, [r3, #-0]!
     2f4:	3a0e0300 	bcc	380efc <_bss_end+0x375098>
     2f8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     2fc:	0013490b 	andseq	r4, r3, fp, lsl #18
     300:	012e2400 			; <UNDEFINED> instruction: 0x012e2400
     304:	0e6e1331 	mcreq	3, 3, r1, cr14, cr1, {1}
     308:	01111364 	tsteq	r1, r4, ror #6
     30c:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
     310:	00194297 	mulseq	r9, r7, r2
     314:	00052500 	andeq	r2, r5, r0, lsl #10
     318:	18021331 	stmdane	r2, {r0, r4, r5, r8, r9, ip}
     31c:	01000000 	mrseq	r0, (UNDEF: 0)
     320:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
     324:	0e030b13 	vmoveq.32	d3[0], r0
     328:	17550e1b 	smmlane	r5, fp, lr, r0
     32c:	17100111 			; <UNDEFINED> instruction: 0x17100111
     330:	02020000 	andeq	r0, r2, #0
     334:	0b0e0301 	bleq	380f40 <_bss_end+0x3750dc>
     338:	3b0b3a0b 	blcc	2ceb6c <_bss_end+0x2c2d08>
     33c:	010b390b 	tsteq	fp, fp, lsl #18
     340:	03000013 	movweq	r0, #19
     344:	0e030104 	adfeqs	f0, f3, f4
     348:	0b3e196d 	bleq	f86904 <_bss_end+0xf7aaa0>
     34c:	13490b0b 	movtne	r0, #39691	; 0x9b0b
     350:	0b3b0b3a 	bleq	ec3040 <_bss_end+0xeb71dc>
     354:	0b320b39 	bleq	c83040 <_bss_end+0xc771dc>
     358:	00001301 	andeq	r1, r0, r1, lsl #6
     35c:	03002804 	movweq	r2, #2052	; 0x804
     360:	000b1c08 	andeq	r1, fp, r8, lsl #24
     364:	00260500 	eoreq	r0, r6, r0, lsl #10
     368:	00001349 	andeq	r1, r0, r9, asr #6
     36c:	03011306 	movweq	r1, #4870	; 0x1306
     370:	3a0b0b0e 	bcc	2c2fb0 <_bss_end+0x2b714c>
     374:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     378:	0013010b 	andseq	r0, r3, fp, lsl #2
     37c:	000d0700 	andeq	r0, sp, r0, lsl #14
     380:	0b3a0803 	bleq	e82394 <_bss_end+0xe76530>
     384:	0b390b3b 	bleq	e43078 <_bss_end+0xe37214>
     388:	0b381349 	bleq	e050b4 <_bss_end+0xdf9250>
     38c:	0d080000 	stceq	0, cr0, [r8, #-0]
     390:	3a0e0300 	bcc	380f98 <_bss_end+0x375134>
     394:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     398:	3f13490b 	svccc	0x0013490b
     39c:	3c0b3219 	sfmcc	f3, 4, [fp], {25}
     3a0:	6c0b1c19 	stcvs	12, cr1, [fp], {25}
     3a4:	09000019 	stmdbeq	r0, {r0, r3, r4}
     3a8:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
     3ac:	0b3b0b3a 	bleq	ec309c <_bss_end+0xeb7238>
     3b0:	13490b39 	movtne	r0, #39737	; 0x9b39
     3b4:	0b32193f 	bleq	c868b8 <_bss_end+0xc7aa54>
     3b8:	196c193c 	stmdbne	ip!, {r2, r3, r4, r5, r8, fp, ip}^
     3bc:	2e0a0000 	cdpcs	0, 0, cr0, cr10, cr0, {0}
     3c0:	03193f01 	tsteq	r9, #1, 30
     3c4:	3b0b3a0e 	blcc	2cec04 <_bss_end+0x2c2da0>
     3c8:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     3cc:	3213490e 	andscc	r4, r3, #229376	; 0x38000
     3d0:	63193c0b 	tstvs	r9, #2816	; 0xb00
     3d4:	01136419 	tsteq	r3, r9, lsl r4
     3d8:	0b000013 	bleq	42c <CPSR_IRQ_INHIBIT+0x3ac>
     3dc:	13490005 	movtne	r0, #36869	; 0x9005
     3e0:	00001934 	andeq	r1, r0, r4, lsr r9
     3e4:	4900050c 	stmdbmi	r0, {r2, r3, r8, sl}
     3e8:	0d000013 	stceq	0, cr0, [r0, #-76]	; 0xffffffb4
     3ec:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
     3f0:	0b3a0e03 	bleq	e83c04 <_bss_end+0xe77da0>
     3f4:	0b390b3b 	bleq	e430e8 <_bss_end+0xe37284>
     3f8:	0b320e6e 	bleq	c83db8 <_bss_end+0xc77f54>
     3fc:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
     400:	00001301 	andeq	r1, r0, r1, lsl #6
     404:	3f012e0e 	svccc	0x00012e0e
     408:	3a0e0319 	bcc	381074 <_bss_end+0x375210>
     40c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     410:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
     414:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
     418:	01136419 	tsteq	r3, r9, lsl r4
     41c:	0f000013 	svceq	0x00000013
     420:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
     424:	0b3a0e03 	bleq	e83c38 <_bss_end+0xe77dd4>
     428:	0b390b3b 	bleq	e4311c <_bss_end+0xe372b8>
     42c:	193c0e6e 	ldmdbne	ip!, {r1, r2, r3, r5, r6, r9, sl, fp}
     430:	13011364 	movwne	r1, #4964	; 0x1364
     434:	2e100000 	cdpcs	0, 1, cr0, cr0, cr0, {0}
     438:	03193f01 	tsteq	r9, #1, 30
     43c:	3b0b3a0e 	blcc	2cec7c <_bss_end+0x2c2e18>
     440:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     444:	3c13490e 			; <UNDEFINED> instruction: 0x3c13490e
     448:	01136419 	tsteq	r3, r9, lsl r4
     44c:	11000013 	tstne	r0, r3, lsl r0
     450:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
     454:	0b3b0b3a 	bleq	ec3144 <_bss_end+0xeb72e0>
     458:	13490b39 	movtne	r0, #39737	; 0x9b39
     45c:	00000b38 	andeq	r0, r0, r8, lsr fp
     460:	0b002412 	bleq	94b0 <Process_1+0x84>
     464:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
     468:	1300000e 	movwne	r0, #14
     46c:	0b0b000f 	bleq	2c04b0 <_bss_end+0x2b464c>
     470:	00001349 	andeq	r1, r0, r9, asr #6
     474:	0b001014 	bleq	44cc <CPSR_IRQ_INHIBIT+0x444c>
     478:	0013490b 	andseq	r4, r3, fp, lsl #18
     47c:	00351500 	eorseq	r1, r5, r0, lsl #10
     480:	00001349 	andeq	r1, r0, r9, asr #6
     484:	03003416 	movweq	r3, #1046	; 0x416
     488:	3b0b3a0e 	blcc	2cecc8 <_bss_end+0x2c2e64>
     48c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     490:	3c193f13 	ldccc	15, cr3, [r9], {19}
     494:	17000019 	smladne	r0, r9, r0, r0
     498:	13470034 	movtne	r0, #28724	; 0x7034
     49c:	0b3b0b3a 	bleq	ec318c <_bss_end+0xeb7328>
     4a0:	18020b39 	stmdane	r2, {r0, r3, r4, r5, r8, r9, fp}
     4a4:	2e180000 	cdpcs	0, 1, cr0, cr8, cr0, {0}
     4a8:	340e0300 	strcc	r0, [lr], #-768	; 0xfffffd00
     4ac:	12011119 	andne	r1, r1, #1073741830	; 0x40000006
     4b0:	96184006 	ldrls	r4, [r8], -r6
     4b4:	00001942 	andeq	r1, r0, r2, asr #18
     4b8:	03012e19 	movweq	r2, #7705	; 0x1e19
     4bc:	1119340e 	tstne	r9, lr, lsl #8
     4c0:	40061201 	andmi	r1, r6, r1, lsl #4
     4c4:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
     4c8:	00001301 	andeq	r1, r0, r1, lsl #6
     4cc:	0300051a 	movweq	r0, #1306	; 0x51a
     4d0:	3b0b3a0e 	blcc	2ced10 <_bss_end+0x2c2eac>
     4d4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     4d8:	00180213 	andseq	r0, r8, r3, lsl r2
     4dc:	00241b00 	eoreq	r1, r4, r0, lsl #22
     4e0:	0b3e0b0b 	bleq	f83114 <_bss_end+0xf772b0>
     4e4:	00000803 	andeq	r0, r0, r3, lsl #16
     4e8:	47012e1c 	smladmi	r1, ip, lr, r2
     4ec:	3b0b3a13 	blcc	2ced40 <_bss_end+0x2c2edc>
     4f0:	640b390b 	strvs	r3, [fp], #-2315	; 0xfffff6f5
     4f4:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
     4f8:	96184006 	ldrls	r4, [r8], -r6
     4fc:	13011942 	movwne	r1, #6466	; 0x1942
     500:	051d0000 	ldreq	r0, [sp, #-0]
     504:	490e0300 	stmdbmi	lr, {r8, r9}
     508:	02193413 	andseq	r3, r9, #318767104	; 0x13000000
     50c:	1e000018 	mcrne	0, 0, r0, cr0, cr8, {0}
     510:	08030034 	stmdaeq	r3, {r2, r4, r5}
     514:	0b3b0b3a 	bleq	ec3204 <_bss_end+0xeb73a0>
     518:	13490b39 	movtne	r0, #39737	; 0x9b39
     51c:	00001802 	andeq	r1, r0, r2, lsl #16
     520:	11010b1f 	tstne	r1, pc, lsl fp
     524:	00061201 	andeq	r1, r6, r1, lsl #4
     528:	012e2000 			; <UNDEFINED> instruction: 0x012e2000
     52c:	0b3a1347 	bleq	e85250 <_bss_end+0xe793ec>
     530:	0b390b3b 	bleq	e43224 <_bss_end+0xe373c0>
     534:	01111364 	tsteq	r1, r4, ror #6
     538:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
     53c:	01194297 			; <UNDEFINED> instruction: 0x01194297
     540:	21000013 	tstcs	r0, r3, lsl r0
     544:	08030005 	stmdaeq	r3, {r0, r2}
     548:	0b3b0b3a 	bleq	ec3238 <_bss_end+0xeb73d4>
     54c:	13490b39 	movtne	r0, #39737	; 0x9b39
     550:	00001802 	andeq	r1, r0, r2, lsl #16
     554:	03003422 	movweq	r3, #1058	; 0x422
     558:	3b0b3a0e 	blcc	2ced98 <_bss_end+0x2c2f34>
     55c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     560:	00180213 	andseq	r0, r8, r3, lsl r2
     564:	00342300 	eorseq	r2, r4, r0, lsl #6
     568:	0b3a0e03 	bleq	e83d7c <_bss_end+0xe77f18>
     56c:	0b390b3b 	bleq	e43260 <_bss_end+0xe373fc>
     570:	196c1349 	stmdbne	ip!, {r0, r3, r6, r8, r9, ip}^
     574:	00001802 	andeq	r1, r0, r2, lsl #16
     578:	49010124 	stmdbmi	r1, {r2, r5, r8}
     57c:	00130113 	andseq	r0, r3, r3, lsl r1
     580:	00212500 	eoreq	r2, r1, r0, lsl #10
     584:	0b2f1349 	bleq	bc52b0 <_bss_end+0xbb944c>
     588:	0b260000 	bleq	980590 <_bss_end+0x97472c>
     58c:	12011101 	andne	r1, r1, #1073741824	; 0x40000000
     590:	00130106 	andseq	r0, r3, r6, lsl #2
     594:	012e2700 			; <UNDEFINED> instruction: 0x012e2700
     598:	0b3a1347 	bleq	e852bc <_bss_end+0xe79458>
     59c:	0b390b3b 	bleq	e43290 <_bss_end+0xe3742c>
     5a0:	0b201364 	bleq	805338 <_bss_end+0x7f94d4>
     5a4:	00001301 	andeq	r1, r0, r1, lsl #6
     5a8:	03000528 	movweq	r0, #1320	; 0x528
     5ac:	3413490e 	ldrcc	r4, [r3], #-2318	; 0xfffff6f2
     5b0:	29000019 	stmdbcs	r0, {r0, r3, r4}
     5b4:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
     5b8:	0b3b0b3a 	bleq	ec32a8 <_bss_end+0xeb7444>
     5bc:	13490b39 	movtne	r0, #39737	; 0x9b39
     5c0:	2e2a0000 	cdpcs	0, 2, cr0, cr10, cr0, {0}
     5c4:	6e133101 	mufvss	f3, f3, f1
     5c8:	1113640e 	tstne	r3, lr, lsl #8
     5cc:	40061201 	andmi	r1, r6, r1, lsl #4
     5d0:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
     5d4:	052b0000 	streq	r0, [fp, #-0]!
     5d8:	02133100 	andseq	r3, r3, #0, 2
     5dc:	00000018 	andeq	r0, r0, r8, lsl r0
     5e0:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
     5e4:	030b130e 	movweq	r1, #45838	; 0xb30e
     5e8:	110e1b0e 	tstne	lr, lr, lsl #22
     5ec:	10061201 	andne	r1, r6, r1, lsl #4
     5f0:	02000017 	andeq	r0, r0, #23
     5f4:	0b0b0024 	bleq	2c068c <_bss_end+0x2b4828>
     5f8:	0e030b3e 	vmoveq.16	d3[0], r0
     5fc:	24030000 	strcs	r0, [r3], #-0
     600:	3e0b0b00 	vmlacc.f64	d0, d11, d0
     604:	0008030b 	andeq	r0, r8, fp, lsl #6
     608:	00160400 	andseq	r0, r6, r0, lsl #8
     60c:	0b3a0e03 	bleq	e83e20 <_bss_end+0xe77fbc>
     610:	0b390b3b 	bleq	e43304 <_bss_end+0xe374a0>
     614:	00001349 	andeq	r1, r0, r9, asr #6
     618:	49002605 	stmdbmi	r0, {r0, r2, r9, sl, sp}
     61c:	06000013 			; <UNDEFINED> instruction: 0x06000013
     620:	13490035 	movtne	r0, #36917	; 0x9035
     624:	39070000 	stmdbcc	r7, {}	; <UNPREDICTABLE>
     628:	3a080301 	bcc	201234 <_bss_end+0x1f53d0>
     62c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     630:	0013010b 	andseq	r0, r3, fp, lsl #2
     634:	00340800 	eorseq	r0, r4, r0, lsl #16
     638:	0b3a0e03 	bleq	e83e4c <_bss_end+0xe77fe8>
     63c:	0b390b3b 	bleq	e43330 <_bss_end+0xe374cc>
     640:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
     644:	196c061c 	stmdbne	ip!, {r2, r3, r4, r9, sl}^
     648:	34090000 	strcc	r0, [r9], #-0
     64c:	3a0e0300 	bcc	381254 <_bss_end+0x3753f0>
     650:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     654:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
     658:	6c0b1c19 	stcvs	12, cr1, [fp], {25}
     65c:	0a000019 	beq	6c8 <CPSR_IRQ_INHIBIT+0x648>
     660:	0e030104 	adfeqs	f0, f3, f4
     664:	0b3e196d 	bleq	f86c20 <_bss_end+0xf7adbc>
     668:	13490b0b 	movtne	r0, #39691	; 0x9b0b
     66c:	0b3b0b3a 	bleq	ec335c <_bss_end+0xeb74f8>
     670:	00000b39 	andeq	r0, r0, r9, lsr fp
     674:	0300280b 	movweq	r2, #2059	; 0x80b
     678:	000b1c0e 	andeq	r1, fp, lr, lsl #24
     67c:	00340c00 	eorseq	r0, r4, r0, lsl #24
     680:	00001347 	andeq	r1, r0, r7, asr #6
     684:	0301040d 	movweq	r0, #5133	; 0x140d
     688:	3e196d0e 	cdpcc	13, 1, cr6, cr9, cr14, {0}
     68c:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
     690:	3b0b3a13 	blcc	2ceee4 <_bss_end+0x2c3080>
     694:	010b390b 	tsteq	fp, fp, lsl #18
     698:	0e000013 	mcreq	0, 0, r0, cr0, cr3, {0}
     69c:	0e030102 	adfeqs	f0, f3, f2
     6a0:	0b3a0b0b 	bleq	e832d4 <_bss_end+0xe77470>
     6a4:	0b390b3b 	bleq	e43398 <_bss_end+0xe37534>
     6a8:	00001301 	andeq	r1, r0, r1, lsl #6
     6ac:	03000d0f 	movweq	r0, #3343	; 0xd0f
     6b0:	3b0b3a0e 	blcc	2ceef0 <_bss_end+0x2c308c>
     6b4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     6b8:	000b3813 	andeq	r3, fp, r3, lsl r8
     6bc:	00161000 	andseq	r1, r6, r0
     6c0:	0b3a0e03 	bleq	e83ed4 <_bss_end+0xe78070>
     6c4:	0b390b3b 	bleq	e433b8 <_bss_end+0xe37554>
     6c8:	0b321349 	bleq	c853f4 <_bss_end+0xc79590>
     6cc:	2e110000 	cdpcs	0, 1, cr0, cr1, cr0, {0}
     6d0:	03193f01 	tsteq	r9, #1, 30
     6d4:	3b0b3a0e 	blcc	2cef14 <_bss_end+0x2c30b0>
     6d8:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     6dc:	3213490e 	andscc	r4, r3, #229376	; 0x38000
     6e0:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
     6e4:	00130113 	andseq	r0, r3, r3, lsl r1
     6e8:	00051200 	andeq	r1, r5, r0, lsl #4
     6ec:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
     6f0:	05130000 	ldreq	r0, [r3, #-0]
     6f4:	00134900 	andseq	r4, r3, r0, lsl #18
     6f8:	012e1400 			; <UNDEFINED> instruction: 0x012e1400
     6fc:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     700:	0b3b0b3a 	bleq	ec33f0 <_bss_end+0xeb758c>
     704:	0e6e0b39 	vmoveq.8	d14[5], r0
     708:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
     70c:	13011364 	movwne	r1, #4964	; 0x1364
     710:	2e150000 	cdpcs	0, 1, cr0, cr5, cr0, {0}
     714:	03193f01 	tsteq	r9, #1, 30
     718:	3b0b3a0e 	blcc	2cef58 <_bss_end+0x2c30f4>
     71c:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     720:	3213490e 	andscc	r4, r3, #229376	; 0x38000
     724:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
     728:	16000013 			; <UNDEFINED> instruction: 0x16000013
     72c:	0b0b000f 	bleq	2c0770 <_bss_end+0x2b490c>
     730:	00001349 	andeq	r1, r0, r9, asr #6
     734:	00001517 	andeq	r1, r0, r7, lsl r5
     738:	00101800 	andseq	r1, r0, r0, lsl #16
     73c:	13490b0b 	movtne	r0, #39691	; 0x9b0b
     740:	34190000 	ldrcc	r0, [r9], #-0
     744:	3a0e0300 	bcc	38134c <_bss_end+0x3754e8>
     748:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     74c:	3f13490b 	svccc	0x0013490b
     750:	00193c19 	andseq	r3, r9, r9, lsl ip
     754:	00341a00 	eorseq	r1, r4, r0, lsl #20
     758:	0b3a1347 	bleq	e8547c <_bss_end+0xe79618>
     75c:	0b390b3b 	bleq	e43450 <_bss_end+0xe375ec>
     760:	00001802 	andeq	r1, r0, r2, lsl #16
     764:	0301131b 	movweq	r1, #4891	; 0x131b
     768:	3a0b0b0e 	bcc	2c33a8 <_bss_end+0x2b7544>
     76c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     770:	0013010b 	andseq	r0, r3, fp, lsl #2
     774:	000d1c00 	andeq	r1, sp, r0, lsl #24
     778:	0b3a0e03 	bleq	e83f8c <_bss_end+0xe78128>
     77c:	0b390b3b 	bleq	e43470 <_bss_end+0xe3760c>
     780:	0b0b1349 	bleq	2c54ac <_bss_end+0x2b9648>
     784:	0b0c0b0d 	bleq	3033c0 <_bss_end+0x2f755c>
     788:	00000b38 	andeq	r0, r0, r8, lsr fp
     78c:	03000d1d 	movweq	r0, #3357	; 0xd1d
     790:	3b0b3a0e 	blcc	2cefd0 <_bss_end+0x2c316c>
     794:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     798:	0d0b0b13 	vstreq	d0, [fp, #-76]	; 0xffffffb4
     79c:	380d0c0b 	stmdacc	sp, {r0, r1, r3, sl, fp}
     7a0:	1e00000b 	cdpne	0, 0, cr0, cr0, cr11, {0}
     7a4:	0e03002e 	cdpeq	0, 0, cr0, cr3, cr14, {1}
     7a8:	01111934 	tsteq	r1, r4, lsr r9
     7ac:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
     7b0:	00194296 	mulseq	r9, r6, r2
     7b4:	012e1f00 			; <UNDEFINED> instruction: 0x012e1f00
     7b8:	19340e03 	ldmdbne	r4!, {r0, r1, r9, sl, fp}
     7bc:	06120111 			; <UNDEFINED> instruction: 0x06120111
     7c0:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
     7c4:	00130119 	andseq	r0, r3, r9, lsl r1
     7c8:	00052000 	andeq	r2, r5, r0
     7cc:	0b3a0e03 	bleq	e83fe0 <_bss_end+0xe7817c>
     7d0:	0b390b3b 	bleq	e434c4 <_bss_end+0xe37660>
     7d4:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
     7d8:	2e210000 	cdpcs	0, 2, cr0, cr1, cr0, {0}
     7dc:	3a134701 	bcc	4d23e8 <_bss_end+0x4c6584>
     7e0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     7e4:	1113640b 	tstne	r3, fp, lsl #8
     7e8:	40061201 	andmi	r1, r6, r1, lsl #4
     7ec:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
     7f0:	00001301 	andeq	r1, r0, r1, lsl #6
     7f4:	03000522 	movweq	r0, #1314	; 0x522
     7f8:	3413490e 	ldrcc	r4, [r3], #-2318	; 0xfffff6f2
     7fc:	00180219 	andseq	r0, r8, r9, lsl r2
     800:	00342300 	eorseq	r2, r4, r0, lsl #6
     804:	0b3a0803 	bleq	e82818 <_bss_end+0xe769b4>
     808:	0b390b3b 	bleq	e434fc <_bss_end+0xe37698>
     80c:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
     810:	2e240000 	cdpcs	0, 2, cr0, cr4, cr0, {0}
     814:	3a134701 	bcc	4d2420 <_bss_end+0x4c65bc>
     818:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     81c:	1113640b 	tstne	r3, fp, lsl #8
     820:	40061201 	andmi	r1, r6, r1, lsl #4
     824:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
     828:	00001301 	andeq	r1, r0, r1, lsl #6
     82c:	03000525 	movweq	r0, #1317	; 0x525
     830:	3b0b3a08 	blcc	2cf058 <_bss_end+0x2c31f4>
     834:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     838:	00180213 	andseq	r0, r8, r3, lsl r2
     83c:	012e2600 			; <UNDEFINED> instruction: 0x012e2600
     840:	0b3a1347 	bleq	e85564 <_bss_end+0xe79700>
     844:	0b390b3b 	bleq	e43538 <_bss_end+0xe376d4>
     848:	0b201364 	bleq	8055e0 <_bss_end+0x7f977c>
     84c:	00001301 	andeq	r1, r0, r1, lsl #6
     850:	03000527 	movweq	r0, #1319	; 0x527
     854:	3413490e 	ldrcc	r4, [r3], #-2318	; 0xfffff6f2
     858:	28000019 	stmdacs	r0, {r0, r3, r4}
     85c:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
     860:	0b3b0b3a 	bleq	ec3550 <_bss_end+0xeb76ec>
     864:	13490b39 	movtne	r0, #39737	; 0x9b39
     868:	2e290000 	cdpcs	0, 2, cr0, cr9, cr0, {0}
     86c:	6e133101 	mufvss	f3, f3, f1
     870:	1113640e 	tstne	r3, lr, lsl #8
     874:	40061201 	andmi	r1, r6, r1, lsl #4
     878:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
     87c:	052a0000 	streq	r0, [sl, #-0]!
     880:	02133100 	andseq	r3, r3, #0, 2
     884:	00000018 	andeq	r0, r0, r8, lsl r0
     888:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
     88c:	030b130e 	movweq	r1, #45838	; 0xb30e
     890:	110e1b0e 	tstne	lr, lr, lsl #22
     894:	10061201 	andne	r1, r6, r1, lsl #4
     898:	02000017 	andeq	r0, r0, #23
     89c:	0b0b0024 	bleq	2c0934 <_bss_end+0x2b4ad0>
     8a0:	0e030b3e 	vmoveq.16	d3[0], r0
     8a4:	24030000 	strcs	r0, [r3], #-0
     8a8:	3e0b0b00 	vmlacc.f64	d0, d11, d0
     8ac:	0008030b 	andeq	r0, r8, fp, lsl #6
     8b0:	00160400 	andseq	r0, r6, r0, lsl #8
     8b4:	0b3a0e03 	bleq	e840c8 <_bss_end+0xe78264>
     8b8:	0b390b3b 	bleq	e435ac <_bss_end+0xe37748>
     8bc:	00001349 	andeq	r1, r0, r9, asr #6
     8c0:	49002605 	stmdbmi	r0, {r0, r2, r9, sl, sp}
     8c4:	06000013 			; <UNDEFINED> instruction: 0x06000013
     8c8:	13490035 	movtne	r0, #36917	; 0x9035
     8cc:	39070000 	stmdbcc	r7, {}	; <UNPREDICTABLE>
     8d0:	3a080301 	bcc	2014dc <_bss_end+0x1f5678>
     8d4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     8d8:	0013010b 	andseq	r0, r3, fp, lsl #2
     8dc:	00340800 	eorseq	r0, r4, r0, lsl #16
     8e0:	0b3a0e03 	bleq	e840f4 <_bss_end+0xe78290>
     8e4:	0b390b3b 	bleq	e435d8 <_bss_end+0xe37774>
     8e8:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
     8ec:	196c061c 	stmdbne	ip!, {r2, r3, r4, r9, sl}^
     8f0:	34090000 	strcc	r0, [r9], #-0
     8f4:	3a0e0300 	bcc	3814fc <_bss_end+0x375698>
     8f8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     8fc:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
     900:	6c0b1c19 	stcvs	12, cr1, [fp], {25}
     904:	0a000019 	beq	970 <CPSR_IRQ_INHIBIT+0x8f0>
     908:	0e030104 	adfeqs	f0, f3, f4
     90c:	0b3e196d 	bleq	f86ec8 <_bss_end+0xf7b064>
     910:	13490b0b 	movtne	r0, #39691	; 0x9b0b
     914:	0b3b0b3a 	bleq	ec3604 <_bss_end+0xeb77a0>
     918:	13010b39 	movwne	r0, #6969	; 0x1b39
     91c:	280b0000 	stmdacs	fp, {}	; <UNPREDICTABLE>
     920:	1c0e0300 	stcne	3, cr0, [lr], {-0}
     924:	0c00000b 	stceq	0, cr0, [r0], {11}
     928:	08030028 	stmdaeq	r3, {r3, r5}
     92c:	00000b1c 	andeq	r0, r0, ip, lsl fp
     930:	0301040d 	movweq	r0, #5133	; 0x140d
     934:	3e196d0e 	cdpcc	13, 1, cr6, cr9, cr14, {0}
     938:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
     93c:	3b0b3a13 	blcc	2cf190 <_bss_end+0x2c332c>
     940:	000b390b 	andeq	r3, fp, fp, lsl #18
     944:	00340e00 	eorseq	r0, r4, r0, lsl #28
     948:	00001347 	andeq	r1, r0, r7, asr #6
     94c:	0301020f 	movweq	r0, #4623	; 0x120f
     950:	3a0b0b0e 	bcc	2c3590 <_bss_end+0x2b772c>
     954:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     958:	0013010b 	andseq	r0, r3, fp, lsl #2
     95c:	000d1000 	andeq	r1, sp, r0
     960:	0b3a0e03 	bleq	e84174 <_bss_end+0xe78310>
     964:	0b390b3b 	bleq	e43658 <_bss_end+0xe377f4>
     968:	0b381349 	bleq	e05694 <_bss_end+0xdf9830>
     96c:	2e110000 	cdpcs	0, 1, cr0, cr1, cr0, {0}
     970:	03193f01 	tsteq	r9, #1, 30
     974:	3b0b3a0e 	blcc	2cf1b4 <_bss_end+0x2c3350>
     978:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     97c:	3213490e 	andscc	r4, r3, #229376	; 0x38000
     980:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
     984:	00130113 	andseq	r0, r3, r3, lsl r1
     988:	00051200 	andeq	r1, r5, r0, lsl #4
     98c:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
     990:	05130000 	ldreq	r0, [r3, #-0]
     994:	00134900 	andseq	r4, r3, r0, lsl #18
     998:	012e1400 			; <UNDEFINED> instruction: 0x012e1400
     99c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     9a0:	0b3b0b3a 	bleq	ec3690 <_bss_end+0xeb782c>
     9a4:	0e6e0b39 	vmoveq.8	d14[5], r0
     9a8:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
     9ac:	13011364 	movwne	r1, #4964	; 0x1364
     9b0:	2e150000 	cdpcs	0, 1, cr0, cr5, cr0, {0}
     9b4:	03193f01 	tsteq	r9, #1, 30
     9b8:	3b0b3a0e 	blcc	2cf1f8 <_bss_end+0x2c3394>
     9bc:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     9c0:	3c0b320e 	sfmcc	f3, 4, [fp], {14}
     9c4:	00136419 	andseq	r6, r3, r9, lsl r4
     9c8:	000f1600 	andeq	r1, pc, r0, lsl #12
     9cc:	13490b0b 	movtne	r0, #39691	; 0x9b0b
     9d0:	10170000 	andsne	r0, r7, r0
     9d4:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
     9d8:	18000013 	stmdane	r0, {r0, r1, r4}
     9dc:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
     9e0:	0b3b0b3a 	bleq	ec36d0 <_bss_end+0xeb786c>
     9e4:	13490b39 	movtne	r0, #39737	; 0x9b39
     9e8:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
     9ec:	16190000 	ldrne	r0, [r9], -r0
     9f0:	3a0e0300 	bcc	3815f8 <_bss_end+0x375794>
     9f4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     9f8:	3213490b 	andscc	r4, r3, #180224	; 0x2c000
     9fc:	1a00000b 	bne	a30 <CPSR_IRQ_INHIBIT+0x9b0>
     a00:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
     a04:	0b3a0e03 	bleq	e84218 <_bss_end+0xe783b4>
     a08:	0b390b3b 	bleq	e436fc <_bss_end+0xe37898>
     a0c:	13490e6e 	movtne	r0, #40558	; 0x9e6e
     a10:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
     a14:	00001364 	andeq	r1, r0, r4, ror #6
     a18:	0000151b 	andeq	r1, r0, fp, lsl r5
     a1c:	00341c00 	eorseq	r1, r4, r0, lsl #24
     a20:	0b3a1347 	bleq	e85744 <_bss_end+0xe798e0>
     a24:	0b390b3b 	bleq	e43718 <_bss_end+0xe378b4>
     a28:	00001802 	andeq	r1, r0, r2, lsl #16
     a2c:	03002e1d 	movweq	r2, #3613	; 0xe1d
     a30:	1119340e 	tstne	r9, lr, lsl #8
     a34:	40061201 	andmi	r1, r6, r1, lsl #4
     a38:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
     a3c:	2e1e0000 	cdpcs	0, 1, cr0, cr14, cr0, {0}
     a40:	340e0301 	strcc	r0, [lr], #-769	; 0xfffffcff
     a44:	12011119 	andne	r1, r1, #1073741830	; 0x40000006
     a48:	96184006 	ldrls	r4, [r8], -r6
     a4c:	13011942 	movwne	r1, #6466	; 0x1942
     a50:	051f0000 	ldreq	r0, [pc, #-0]	; a58 <CPSR_IRQ_INHIBIT+0x9d8>
     a54:	3a0e0300 	bcc	38165c <_bss_end+0x3757f8>
     a58:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     a5c:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
     a60:	20000018 	andcs	r0, r0, r8, lsl r0
     a64:	1347012e 	movtne	r0, #28974	; 0x712e
     a68:	0b3b0b3a 	bleq	ec3758 <_bss_end+0xeb78f4>
     a6c:	13640b39 	cmnne	r4, #58368	; 0xe400
     a70:	06120111 			; <UNDEFINED> instruction: 0x06120111
     a74:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
     a78:	00130119 	andseq	r0, r3, r9, lsl r1
     a7c:	00052100 	andeq	r2, r5, r0, lsl #2
     a80:	13490e03 	movtne	r0, #40451	; 0x9e03
     a84:	18021934 	stmdane	r2, {r2, r4, r5, r8, fp, ip}
     a88:	34220000 	strtcc	r0, [r2], #-0
     a8c:	3a0e0300 	bcc	381694 <_bss_end+0x375830>
     a90:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     a94:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
     a98:	23000018 	movwcs	r0, #24
     a9c:	1347012e 	movtne	r0, #28974	; 0x712e
     aa0:	0b3b0b3a 	bleq	ec3790 <_bss_end+0xeb792c>
     aa4:	13640b39 	cmnne	r4, #58368	; 0xe400
     aa8:	06120111 			; <UNDEFINED> instruction: 0x06120111
     aac:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
     ab0:	00130119 	andseq	r0, r3, r9, lsl r1
     ab4:	00052400 	andeq	r2, r5, r0, lsl #8
     ab8:	0b3a0803 	bleq	e82acc <_bss_end+0xe76c68>
     abc:	0b390b3b 	bleq	e437b0 <_bss_end+0xe3794c>
     ac0:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
     ac4:	2e250000 	cdpcs	0, 2, cr0, cr5, cr0, {0}
     ac8:	3a134701 	bcc	4d26d4 <_bss_end+0x4c6870>
     acc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     ad0:	2013640b 	andscs	r6, r3, fp, lsl #8
     ad4:	0013010b 	andseq	r0, r3, fp, lsl #2
     ad8:	00052600 	andeq	r2, r5, r0, lsl #12
     adc:	13490e03 	movtne	r0, #40451	; 0x9e03
     ae0:	00001934 	andeq	r1, r0, r4, lsr r9
     ae4:	03000527 	movweq	r0, #1319	; 0x527
     ae8:	3b0b3a0e 	blcc	2cf328 <_bss_end+0x2c34c4>
     aec:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     af0:	28000013 	stmdacs	r0, {r0, r1, r4}
     af4:	1331012e 	teqne	r1, #-2147483637	; 0x8000000b
     af8:	13640e6e 	cmnne	r4, #1760	; 0x6e0
     afc:	06120111 			; <UNDEFINED> instruction: 0x06120111
     b00:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
     b04:	00130119 	andseq	r0, r3, r9, lsl r1
     b08:	00052900 	andeq	r2, r5, r0, lsl #18
     b0c:	18021331 	stmdane	r2, {r0, r4, r5, r8, r9, ip}
     b10:	2e2a0000 	cdpcs	0, 2, cr0, cr10, cr0, {0}
     b14:	03193f00 	tsteq	r9, #0, 30
     b18:	3b0b3a0e 	blcc	2cf358 <_bss_end+0x2c34f4>
     b1c:	110b390b 	tstne	fp, fp, lsl #18
     b20:	40061201 	andmi	r1, r6, r1, lsl #4
     b24:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
     b28:	2e2b0000 	cdpcs	0, 2, cr0, cr11, cr0, {0}
     b2c:	03193f00 	tsteq	r9, #0, 30
     b30:	3b0b3a0e 	blcc	2cf370 <_bss_end+0x2c350c>
     b34:	110b390b 	tstne	fp, fp, lsl #18
     b38:	40061201 	andmi	r1, r6, r1, lsl #4
     b3c:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
     b40:	01000000 	mrseq	r0, (UNDEF: 0)
     b44:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
     b48:	0e030b13 	vmoveq.32	d3[0], r0
     b4c:	01110e1b 	tsteq	r1, fp, lsl lr
     b50:	17100612 			; <UNDEFINED> instruction: 0x17100612
     b54:	24020000 	strcs	r0, [r2], #-0
     b58:	3e0b0b00 	vmlacc.f64	d0, d11, d0
     b5c:	000e030b 	andeq	r0, lr, fp, lsl #6
     b60:	00260300 	eoreq	r0, r6, r0, lsl #6
     b64:	00001349 	andeq	r1, r0, r9, asr #6
     b68:	0b002404 	bleq	9b80 <_ZL11fast_dividejj+0xac>
     b6c:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
     b70:	05000008 	streq	r0, [r0, #-8]
     b74:	13490035 	movtne	r0, #36917	; 0x9035
     b78:	16060000 	strne	r0, [r6], -r0
     b7c:	3a0e0300 	bcc	381784 <_bss_end+0x375920>
     b80:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     b84:	0013490b 	andseq	r4, r3, fp, lsl #18
     b88:	01040700 	tsteq	r4, r0, lsl #14
     b8c:	196d0e03 	stmdbne	sp!, {r0, r1, r9, sl, fp}^
     b90:	0b0b0b3e 	bleq	2c3890 <_bss_end+0x2b7a2c>
     b94:	0b3a1349 	bleq	e858c0 <_bss_end+0xe79a5c>
     b98:	0b390b3b 	bleq	e4388c <_bss_end+0xe37a28>
     b9c:	00001301 	andeq	r1, r0, r1, lsl #6
     ba0:	03002808 	movweq	r2, #2056	; 0x808
     ba4:	000b1c0e 	andeq	r1, fp, lr, lsl #24
     ba8:	01020900 	tsteq	r2, r0, lsl #18
     bac:	0b0b0e03 	bleq	2c43c0 <_bss_end+0x2b855c>
     bb0:	0b3b0b3a 	bleq	ec38a0 <_bss_end+0xeb7a3c>
     bb4:	13010b39 	movwne	r0, #6969	; 0x1b39
     bb8:	0d0a0000 	stceq	0, cr0, [sl, #-0]
     bbc:	3a0e0300 	bcc	3817c4 <_bss_end+0x375960>
     bc0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     bc4:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
     bc8:	0b00000b 	bleq	bfc <CPSR_IRQ_INHIBIT+0xb7c>
     bcc:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
     bd0:	0b3a0e03 	bleq	e843e4 <_bss_end+0xe78580>
     bd4:	0b390b3b 	bleq	e438c8 <_bss_end+0xe37a64>
     bd8:	13490e6e 	movtne	r0, #40558	; 0x9e6e
     bdc:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
     be0:	13011364 	movwne	r1, #4964	; 0x1364
     be4:	050c0000 	streq	r0, [ip, #-0]
     be8:	34134900 	ldrcc	r4, [r3], #-2304	; 0xfffff700
     bec:	0d000019 	stceq	0, cr0, [r0, #-100]	; 0xffffff9c
     bf0:	13490005 	movtne	r0, #36869	; 0x9005
     bf4:	2e0e0000 	cdpcs	0, 0, cr0, cr14, cr0, {0}
     bf8:	03193f01 	tsteq	r9, #1, 30
     bfc:	3b0b3a0e 	blcc	2cf43c <_bss_end+0x2c35d8>
     c00:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     c04:	3c0b320e 	sfmcc	f3, 4, [fp], {14}
     c08:	01136419 	tsteq	r3, r9, lsl r4
     c0c:	0f000013 	svceq	0x00000013
     c10:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
     c14:	0b3a0e03 	bleq	e84428 <_bss_end+0xe785c4>
     c18:	0b390b3b 	bleq	e4390c <_bss_end+0xe37aa8>
     c1c:	13490e6e 	movtne	r0, #40558	; 0x9e6e
     c20:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
     c24:	00001364 	andeq	r1, r0, r4, ror #6
     c28:	0b000f10 	bleq	4870 <CPSR_IRQ_INHIBIT+0x47f0>
     c2c:	0013490b 	andseq	r4, r3, fp, lsl #18
     c30:	00101100 	andseq	r1, r0, r0, lsl #2
     c34:	13490b0b 	movtne	r0, #39691	; 0x9b0b
     c38:	34120000 	ldrcc	r0, [r2], #-0
     c3c:	3a0e0300 	bcc	381844 <_bss_end+0x3759e0>
     c40:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     c44:	3f13490b 	svccc	0x0013490b
     c48:	00193c19 	andseq	r3, r9, r9, lsl ip
     c4c:	01391300 	teqeq	r9, r0, lsl #6
     c50:	0b3a0803 	bleq	e82c64 <_bss_end+0xe76e00>
     c54:	0b390b3b 	bleq	e43948 <_bss_end+0xe37ae4>
     c58:	00001301 	andeq	r1, r0, r1, lsl #6
     c5c:	03003414 	movweq	r3, #1044	; 0x414
     c60:	3b0b3a0e 	blcc	2cf4a0 <_bss_end+0x2c363c>
     c64:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     c68:	1c193c13 	ldcne	12, cr3, [r9], {19}
     c6c:	00196c06 	andseq	r6, r9, r6, lsl #24
     c70:	00341500 	eorseq	r1, r4, r0, lsl #10
     c74:	0b3a0e03 	bleq	e84488 <_bss_end+0xe78624>
     c78:	0b390b3b 	bleq	e4396c <_bss_end+0xe37b08>
     c7c:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
     c80:	196c0b1c 	stmdbne	ip!, {r2, r3, r4, r8, r9, fp}^
     c84:	28160000 	ldmdacs	r6, {}	; <UNPREDICTABLE>
     c88:	1c080300 	stcne	3, cr0, [r8], {-0}
     c8c:	1700000b 	strne	r0, [r0, -fp]
     c90:	0e030104 	adfeqs	f0, f3, f4
     c94:	0b3e196d 	bleq	f87250 <_bss_end+0xf7b3ec>
     c98:	13490b0b 	movtne	r0, #39691	; 0x9b0b
     c9c:	0b3b0b3a 	bleq	ec398c <_bss_end+0xeb7b28>
     ca0:	00000b39 	andeq	r0, r0, r9, lsr fp
     ca4:	47003418 	smladmi	r0, r8, r4, r3
     ca8:	19000013 	stmdbne	r0, {r0, r1, r4}
     cac:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
     cb0:	0b3b0b3a 	bleq	ec39a0 <_bss_end+0xeb7b3c>
     cb4:	13490b39 	movtne	r0, #39737	; 0x9b39
     cb8:	00000b32 	andeq	r0, r0, r2, lsr fp
     cbc:	0000151a 	andeq	r1, r0, sl, lsl r5
     cc0:	012e1b00 			; <UNDEFINED> instruction: 0x012e1b00
     cc4:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     cc8:	0b3b0b3a 	bleq	ec39b8 <_bss_end+0xeb7b54>
     ccc:	0e6e0b39 	vmoveq.8	d14[5], r0
     cd0:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
     cd4:	00001364 	andeq	r1, r0, r4, ror #6
     cd8:	0301041c 	movweq	r0, #5148	; 0x141c
     cdc:	3e196d0e 	cdpcc	13, 1, cr6, cr9, cr14, {0}
     ce0:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
     ce4:	3b0b3a13 	blcc	2cf538 <_bss_end+0x2c36d4>
     ce8:	320b390b 	andcc	r3, fp, #180224	; 0x2c000
     cec:	0013010b 	andseq	r0, r3, fp, lsl #2
     cf0:	01131d00 	tsteq	r3, r0, lsl #26
     cf4:	0b0b0e03 	bleq	2c4508 <_bss_end+0x2b86a4>
     cf8:	0b3b0b3a 	bleq	ec39e8 <_bss_end+0xeb7b84>
     cfc:	13010b39 	movwne	r0, #6969	; 0x1b39
     d00:	0d1e0000 	ldceq	0, cr0, [lr, #-0]
     d04:	3a080300 	bcc	20190c <_bss_end+0x1f5aa8>
     d08:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     d0c:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
     d10:	1f00000b 	svcne	0x0000000b
     d14:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
     d18:	0b3b0b3a 	bleq	ec3a08 <_bss_end+0xeb7ba4>
     d1c:	13490b39 	movtne	r0, #39737	; 0x9b39
     d20:	0b32193f 	bleq	c87224 <_bss_end+0xc7b3c0>
     d24:	0b1c193c 	bleq	70721c <_bss_end+0x6fb3b8>
     d28:	0000196c 	andeq	r1, r0, ip, ror #18
     d2c:	03000d20 	movweq	r0, #3360	; 0xd20
     d30:	3b0b3a0e 	blcc	2cf570 <_bss_end+0x2c370c>
     d34:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     d38:	32193f13 	andscc	r3, r9, #19, 30	; 0x4c
     d3c:	6c193c0b 	ldcvs	12, cr3, [r9], {11}
     d40:	21000019 	tstcs	r0, r9, lsl r0
     d44:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
     d48:	0b3a0e03 	bleq	e8455c <_bss_end+0xe786f8>
     d4c:	0b390b3b 	bleq	e43a40 <_bss_end+0xe37bdc>
     d50:	13490e6e 	movtne	r0, #40558	; 0x9e6e
     d54:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
     d58:	13641963 	cmnne	r4, #1622016	; 0x18c000
     d5c:	00001301 	andeq	r1, r0, r1, lsl #6
     d60:	3f012e22 	svccc	0x00012e22
     d64:	3a0e0319 	bcc	3819d0 <_bss_end+0x375b6c>
     d68:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     d6c:	3c0e6e0b 	stccc	14, cr6, [lr], {11}
     d70:	01136419 	tsteq	r3, r9, lsl r4
     d74:	23000013 	movwcs	r0, #19
     d78:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
     d7c:	0b3a0e03 	bleq	e84590 <_bss_end+0xe7872c>
     d80:	0b390b3b 	bleq	e43a74 <_bss_end+0xe37c10>
     d84:	13490e6e 	movtne	r0, #40558	; 0x9e6e
     d88:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
     d8c:	00001301 	andeq	r1, r0, r1, lsl #6
     d90:	03003424 	movweq	r3, #1060	; 0x424
     d94:	3b0b3a0e 	blcc	2cf5d4 <_bss_end+0x2c3770>
     d98:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     d9c:	1c193c13 	ldcne	12, cr3, [r9], {19}
     da0:	00196c05 	andseq	r6, r9, r5, lsl #24
     da4:	000f2500 	andeq	r2, pc, r0, lsl #10
     da8:	00000b0b 	andeq	r0, r0, fp, lsl #22
     dac:	03003426 	movweq	r3, #1062	; 0x426
     db0:	3b0b3a0e 	blcc	2cf5f0 <_bss_end+0x2c378c>
     db4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     db8:	02193f13 	andseq	r3, r9, #19, 30	; 0x4c
     dbc:	27000018 	smladcs	r0, r8, r0, r0
     dc0:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
     dc4:	0b3b0b3a 	bleq	ec3ab4 <_bss_end+0xeb7c50>
     dc8:	13490b39 	movtne	r0, #39737	; 0x9b39
     dcc:	1802196c 	stmdane	r2, {r2, r3, r5, r6, r8, fp, ip}
     dd0:	2e280000 	cdpcs	0, 2, cr0, cr8, cr0, {0}
     dd4:	03193f00 	tsteq	r9, #0, 30
     dd8:	3b0b3a0e 	blcc	2cf618 <_bss_end+0x2c37b4>
     ddc:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     de0:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
     de4:	96184006 	ldrls	r4, [r8], -r6
     de8:	00001942 	andeq	r1, r0, r2, asr #18
     dec:	3f012e29 	svccc	0x00012e29
     df0:	3a0e0319 	bcc	381a5c <_bss_end+0x375bf8>
     df4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     df8:	1201110b 	andne	r1, r1, #-1073741822	; 0xc0000002
     dfc:	96184006 	ldrls	r4, [r8], -r6
     e00:	13011942 	movwne	r1, #6466	; 0x1942
     e04:	342a0000 	strtcc	r0, [sl], #-0
     e08:	3a080300 	bcc	201a10 <_bss_end+0x1f5bac>
     e0c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     e10:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
     e14:	2b000018 	blcs	e7c <CPSR_IRQ_INHIBIT+0xdfc>
     e18:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
     e1c:	0b3b0b3a 	bleq	ec3b0c <_bss_end+0xeb7ca8>
     e20:	13490b39 	movtne	r0, #39737	; 0x9b39
     e24:	00001802 	andeq	r1, r0, r2, lsl #16
     e28:	3f002e2c 	svccc	0x00002e2c
     e2c:	3a0e0319 	bcc	381a98 <_bss_end+0x375c34>
     e30:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     e34:	1201110b 	andne	r1, r1, #-1073741822	; 0xc0000002
     e38:	96184006 	ldrls	r4, [r8], -r6
     e3c:	00001942 	andeq	r1, r0, r2, asr #18
     e40:	01110100 	tsteq	r1, r0, lsl #2
     e44:	0b130e25 	bleq	4c46e0 <_bss_end+0x4b887c>
     e48:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
     e4c:	06120111 			; <UNDEFINED> instruction: 0x06120111
     e50:	00001710 	andeq	r1, r0, r0, lsl r7
     e54:	0b002402 	bleq	9e64 <_ZN13CPage_Manager10Alloc_PageEv+0x118>
     e58:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
     e5c:	0300000e 	movweq	r0, #14
     e60:	0b0b0024 	bleq	2c0ef8 <_bss_end+0x2b5094>
     e64:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
     e68:	16040000 	strne	r0, [r4], -r0
     e6c:	3a0e0300 	bcc	381a74 <_bss_end+0x375c10>
     e70:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     e74:	0013490b 	andseq	r4, r3, fp, lsl #18
     e78:	00260500 	eoreq	r0, r6, r0, lsl #10
     e7c:	00001349 	andeq	r1, r0, r9, asr #6
     e80:	03011306 	movweq	r1, #4870	; 0x1306
     e84:	3a0b0b0e 	bcc	2c3ac4 <_bss_end+0x2b7c60>
     e88:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     e8c:	0013010b 	andseq	r0, r3, fp, lsl #2
     e90:	000d0700 	andeq	r0, sp, r0, lsl #14
     e94:	0b3a0e03 	bleq	e846a8 <_bss_end+0xe78844>
     e98:	0b390b3b 	bleq	e43b8c <_bss_end+0xe37d28>
     e9c:	0b381349 	bleq	e05bc8 <_bss_end+0xdf9d64>
     ea0:	0f080000 	svceq	0x00080000
     ea4:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
     ea8:	09000013 	stmdbeq	r0, {r0, r1, r4}
     eac:	0e030102 	adfeqs	f0, f3, f2
     eb0:	0b3a0b0b 	bleq	e83ae4 <_bss_end+0xe77c80>
     eb4:	0b390b3b 	bleq	e43ba8 <_bss_end+0xe37d44>
     eb8:	00001301 	andeq	r1, r0, r1, lsl #6
     ebc:	3f012e0a 	svccc	0x00012e0a
     ec0:	3a0e0319 	bcc	381b2c <_bss_end+0x375cc8>
     ec4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     ec8:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
     ecc:	64193c13 	ldrvs	r3, [r9], #-3091	; 0xfffff3ed
     ed0:	00130113 	andseq	r0, r3, r3, lsl r1
     ed4:	00050b00 	andeq	r0, r5, r0, lsl #22
     ed8:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
     edc:	2e0c0000 	cdpcs	0, 0, cr0, cr12, cr0, {0}
     ee0:	03193f01 	tsteq	r9, #1, 30
     ee4:	3b0b3a0e 	blcc	2cf724 <_bss_end+0x2c38c0>
     ee8:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     eec:	3213490e 	andscc	r4, r3, #229376	; 0x38000
     ef0:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
     ef4:	00130113 	andseq	r0, r3, r3, lsl r1
     ef8:	00050d00 	andeq	r0, r5, r0, lsl #26
     efc:	00001349 	andeq	r1, r0, r9, asr #6
     f00:	3f012e0e 	svccc	0x00012e0e
     f04:	3a0e0319 	bcc	381b70 <_bss_end+0x375d0c>
     f08:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     f0c:	320e6e0b 	andcc	r6, lr, #11, 28	; 0xb0
     f10:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
     f14:	0f000013 	svceq	0x00000013
     f18:	0b0b000f 	bleq	2c0f5c <_bss_end+0x2b50f8>
     f1c:	34100000 	ldrcc	r0, [r0], #-0
     f20:	3a0e0300 	bcc	381b28 <_bss_end+0x375cc4>
     f24:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     f28:	3f13490b 	svccc	0x0013490b
     f2c:	00193c19 	andseq	r3, r9, r9, lsl ip
     f30:	01391100 	teqeq	r9, r0, lsl #2
     f34:	0b3a0803 	bleq	e82f48 <_bss_end+0xe770e4>
     f38:	0b390b3b 	bleq	e43c2c <_bss_end+0xe37dc8>
     f3c:	00001301 	andeq	r1, r0, r1, lsl #6
     f40:	03003412 	movweq	r3, #1042	; 0x412
     f44:	3b0b3a0e 	blcc	2cf784 <_bss_end+0x2c3920>
     f48:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     f4c:	1c193c13 	ldcne	12, cr3, [r9], {19}
     f50:	00196c06 	andseq	r6, r9, r6, lsl #24
     f54:	00341300 	eorseq	r1, r4, r0, lsl #6
     f58:	0b3a0e03 	bleq	e8476c <_bss_end+0xe78908>
     f5c:	0b390b3b 	bleq	e43c50 <_bss_end+0xe37dec>
     f60:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
     f64:	196c0b1c 	stmdbne	ip!, {r2, r3, r4, r8, r9, fp}^
     f68:	34140000 	ldrcc	r0, [r4], #-0
     f6c:	00134700 	andseq	r4, r3, r0, lsl #14
     f70:	00341500 	eorseq	r1, r4, r0, lsl #10
     f74:	0b3a0e03 	bleq	e84788 <_bss_end+0xe78924>
     f78:	0b390b3b 	bleq	e43c6c <_bss_end+0xe37e08>
     f7c:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
     f80:	196c051c 	stmdbne	ip!, {r2, r3, r4, r8, sl}^
     f84:	02160000 	andseq	r0, r6, #0
     f88:	0b0e0301 	bleq	381b94 <_bss_end+0x375d30>
     f8c:	3b0b3a05 	blcc	2cf7a8 <_bss_end+0x2c3944>
     f90:	010b390b 	tsteq	fp, fp, lsl #18
     f94:	17000013 	smladne	r0, r3, r0, r0
     f98:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
     f9c:	0b3a0e03 	bleq	e847b0 <_bss_end+0xe7894c>
     fa0:	0b390b3b 	bleq	e43c94 <_bss_end+0xe37e30>
     fa4:	193c0e6e 	ldmdbne	ip!, {r1, r2, r3, r5, r6, r9, sl, fp}
     fa8:	13011364 	movwne	r1, #4964	; 0x1364
     fac:	01180000 	tsteq	r8, r0
     fb0:	01134901 	tsteq	r3, r1, lsl #18
     fb4:	19000013 	stmdbne	r0, {r0, r1, r4}
     fb8:	13490021 	movtne	r0, #36897	; 0x9021
     fbc:	0000052f 	andeq	r0, r0, pc, lsr #10
     fc0:	4700341a 	smladmi	r0, sl, r4, r3
     fc4:	3b0b3a13 	blcc	2cf818 <_bss_end+0x2c39b4>
     fc8:	020b390b 	andeq	r3, fp, #180224	; 0x2c000
     fcc:	1b000018 	blne	1034 <CPSR_IRQ_INHIBIT+0xfb4>
     fd0:	0e03002e 	cdpeq	0, 0, cr0, cr3, cr14, {1}
     fd4:	01111934 	tsteq	r1, r4, lsr r9
     fd8:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
     fdc:	00194296 	mulseq	r9, r6, r2
     fe0:	012e1c00 			; <UNDEFINED> instruction: 0x012e1c00
     fe4:	19340e03 	ldmdbne	r4!, {r0, r1, r9, sl, fp}
     fe8:	06120111 			; <UNDEFINED> instruction: 0x06120111
     fec:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
     ff0:	00130119 	andseq	r0, r3, r9, lsl r1
     ff4:	00051d00 	andeq	r1, r5, r0, lsl #26
     ff8:	0b3a0e03 	bleq	e8480c <_bss_end+0xe789a8>
     ffc:	0b390b3b 	bleq	e43cf0 <_bss_end+0xe37e8c>
    1000:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
    1004:	2e1e0000 	cdpcs	0, 1, cr0, cr14, cr0, {0}
    1008:	3a134701 	bcc	4d2c14 <_bss_end+0x4c6db0>
    100c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    1010:	1113640b 	tstne	r3, fp, lsl #8
    1014:	40061201 	andmi	r1, r6, r1, lsl #4
    1018:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
    101c:	00001301 	andeq	r1, r0, r1, lsl #6
    1020:	0300051f 	movweq	r0, #1311	; 0x51f
    1024:	3413490e 	ldrcc	r4, [r3], #-2318	; 0xfffff6f2
    1028:	00180219 	andseq	r0, r8, r9, lsl r2
    102c:	00052000 	andeq	r2, r5, r0
    1030:	0b3a0803 	bleq	e83044 <_bss_end+0xe771e0>
    1034:	0b390b3b 	bleq	e43d28 <_bss_end+0xe37ec4>
    1038:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
    103c:	34210000 	strtcc	r0, [r1], #-0
    1040:	3a0e0300 	bcc	381c48 <_bss_end+0x375de4>
    1044:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    1048:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
    104c:	22000018 	andcs	r0, r0, #24
    1050:	1347012e 	movtne	r0, #28974	; 0x712e
    1054:	0b3b0b3a 	bleq	ec3d44 <_bss_end+0xeb7ee0>
    1058:	13640b39 	cmnne	r4, #58368	; 0xe400
    105c:	06120111 			; <UNDEFINED> instruction: 0x06120111
    1060:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
    1064:	00130119 	andseq	r0, r3, r9, lsl r1
    1068:	012e2300 			; <UNDEFINED> instruction: 0x012e2300
    106c:	0b3a1347 	bleq	e85d90 <_bss_end+0xe79f2c>
    1070:	0b390b3b 	bleq	e43d64 <_bss_end+0xe37f00>
    1074:	0b201364 	bleq	805e0c <_bss_end+0x7f9fa8>
    1078:	00001301 	andeq	r1, r0, r1, lsl #6
    107c:	03000524 	movweq	r0, #1316	; 0x524
    1080:	3413490e 	ldrcc	r4, [r3], #-2318	; 0xfffff6f2
    1084:	25000019 	strcs	r0, [r0, #-25]	; 0xffffffe7
    1088:	1331012e 	teqne	r1, #-2147483637	; 0x8000000b
    108c:	13640e6e 	cmnne	r4, #1760	; 0x6e0
    1090:	06120111 			; <UNDEFINED> instruction: 0x06120111
    1094:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
    1098:	26000019 			; <UNDEFINED> instruction: 0x26000019
    109c:	13310005 	teqne	r1, #5
    10a0:	00001802 	andeq	r1, r0, r2, lsl #16
    10a4:	01110100 	tsteq	r1, r0, lsl #2
    10a8:	0b130e25 	bleq	4c4944 <_bss_end+0x4b8ae0>
    10ac:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
    10b0:	06120111 			; <UNDEFINED> instruction: 0x06120111
    10b4:	00001710 	andeq	r1, r0, r0, lsl r7
    10b8:	0b002402 	bleq	a0c8 <_ZN16CProcess_Manager19Create_Main_ProcessEv+0x54>
    10bc:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
    10c0:	0300000e 	movweq	r0, #14
    10c4:	13490026 	movtne	r0, #36902	; 0x9026
    10c8:	24040000 	strcs	r0, [r4], #-0
    10cc:	3e0b0b00 	vmlacc.f64	d0, d11, d0
    10d0:	0008030b 	andeq	r0, r8, fp, lsl #6
    10d4:	00160500 	andseq	r0, r6, r0, lsl #10
    10d8:	0b3a0e03 	bleq	e848ec <_bss_end+0xe78a88>
    10dc:	0b390b3b 	bleq	e43dd0 <_bss_end+0xe37f6c>
    10e0:	00001349 	andeq	r1, r0, r9, asr #6
    10e4:	49003506 	stmdbmi	r0, {r1, r2, r8, sl, ip, sp}
    10e8:	07000013 	smladeq	r0, r3, r0, r0
    10ec:	08030139 	stmdaeq	r3, {r0, r3, r4, r5, r8}
    10f0:	0b3b0b3a 	bleq	ec3de0 <_bss_end+0xeb7f7c>
    10f4:	13010b39 	movwne	r0, #6969	; 0x1b39
    10f8:	34080000 	strcc	r0, [r8], #-0
    10fc:	3a0e0300 	bcc	381d04 <_bss_end+0x375ea0>
    1100:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    1104:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
    1108:	6c061c19 	stcvs	12, cr1, [r6], {25}
    110c:	09000019 	stmdbeq	r0, {r0, r3, r4}
    1110:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
    1114:	0b3b0b3a 	bleq	ec3e04 <_bss_end+0xeb7fa0>
    1118:	13490b39 	movtne	r0, #39737	; 0x9b39
    111c:	0b1c193c 	bleq	707614 <_bss_end+0x6fb7b0>
    1120:	0000196c 	andeq	r1, r0, ip, ror #18
    1124:	4700340a 	strmi	r3, [r0, -sl, lsl #8]
    1128:	0b000013 	bleq	117c <CPSR_IRQ_INHIBIT+0x10fc>
    112c:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
    1130:	0b3b0b3a 	bleq	ec3e20 <_bss_end+0xeb7fbc>
    1134:	13490b39 	movtne	r0, #39737	; 0x9b39
    1138:	051c193c 	ldreq	r1, [ip, #-2364]	; 0xfffff6c4
    113c:	0000196c 	andeq	r1, r0, ip, ror #18
    1140:	0301020c 	movweq	r0, #4620	; 0x120c
    1144:	3a050b0e 	bcc	143d84 <_bss_end+0x137f20>
    1148:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    114c:	0013010b 	andseq	r0, r3, fp, lsl #2
    1150:	000d0d00 	andeq	r0, sp, r0, lsl #26
    1154:	0b3a0e03 	bleq	e84968 <_bss_end+0xe78b04>
    1158:	0b390b3b 	bleq	e43e4c <_bss_end+0xe37fe8>
    115c:	0b381349 	bleq	e05e88 <_bss_end+0xdfa024>
    1160:	2e0e0000 	cdpcs	0, 0, cr0, cr14, cr0, {0}
    1164:	03193f01 	tsteq	r9, #1, 30
    1168:	3b0b3a0e 	blcc	2cf9a8 <_bss_end+0x2c3b44>
    116c:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
    1170:	64193c0e 	ldrvs	r3, [r9], #-3086	; 0xfffff3f2
    1174:	00130113 	andseq	r0, r3, r3, lsl r1
    1178:	00050f00 	andeq	r0, r5, r0, lsl #30
    117c:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
    1180:	05100000 	ldreq	r0, [r0, #-0]
    1184:	00134900 	andseq	r4, r3, r0, lsl #18
    1188:	012e1100 			; <UNDEFINED> instruction: 0x012e1100
    118c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
    1190:	0b3b0b3a 	bleq	ec3e80 <_bss_end+0xeb801c>
    1194:	0e6e0b39 	vmoveq.8	d14[5], r0
    1198:	0b321349 	bleq	c85ec4 <_bss_end+0xc7a060>
    119c:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
    11a0:	00001301 	andeq	r1, r0, r1, lsl #6
    11a4:	3f012e12 	svccc	0x00012e12
    11a8:	3a0e0319 	bcc	381e14 <_bss_end+0x375fb0>
    11ac:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    11b0:	320e6e0b 	andcc	r6, lr, #11, 28	; 0xb0
    11b4:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
    11b8:	13000013 	movwne	r0, #19
    11bc:	13490101 	movtne	r0, #37121	; 0x9101
    11c0:	00001301 	andeq	r1, r0, r1, lsl #6
    11c4:	49002114 	stmdbmi	r0, {r2, r4, r8, sp}
    11c8:	00052f13 	andeq	r2, r5, r3, lsl pc
    11cc:	000f1500 	andeq	r1, pc, r0, lsl #10
    11d0:	13490b0b 	movtne	r0, #39691	; 0x9b0b
    11d4:	34160000 	ldrcc	r0, [r6], #-0
    11d8:	3a0e0300 	bcc	381de0 <_bss_end+0x375f7c>
    11dc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    11e0:	3f13490b 	svccc	0x0013490b
    11e4:	00193c19 	andseq	r3, r9, r9, lsl ip
    11e8:	01021700 	tsteq	r2, r0, lsl #14
    11ec:	0b0b0e03 	bleq	2c4a00 <_bss_end+0x2b8b9c>
    11f0:	0b3b0b3a 	bleq	ec3ee0 <_bss_end+0xeb807c>
    11f4:	13010b39 	movwne	r0, #6969	; 0x1b39
    11f8:	04180000 	ldreq	r0, [r8], #-0
    11fc:	6d0e0301 	stcvs	3, cr0, [lr, #-4]
    1200:	0b0b3e19 	bleq	2d0a6c <_bss_end+0x2c4c08>
    1204:	3a13490b 	bcc	4d3638 <_bss_end+0x4c77d4>
    1208:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    120c:	010b320b 	tsteq	fp, fp, lsl #4
    1210:	19000013 	stmdbne	r0, {r0, r1, r4}
    1214:	08030028 	stmdaeq	r3, {r3, r5}
    1218:	00000b1c 	andeq	r0, r0, ip, lsl fp
    121c:	0301131a 	movweq	r1, #4890	; 0x131a
    1220:	3a0b0b0e 	bcc	2c3e60 <_bss_end+0x2b7ffc>
    1224:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    1228:	0013010b 	andseq	r0, r3, fp, lsl #2
    122c:	000d1b00 	andeq	r1, sp, r0, lsl #22
    1230:	0b3a0803 	bleq	e83244 <_bss_end+0xe773e0>
    1234:	0b390b3b 	bleq	e43f28 <_bss_end+0xe380c4>
    1238:	0b381349 	bleq	e05f64 <_bss_end+0xdfa100>
    123c:	0d1c0000 	ldceq	0, cr0, [ip, #-0]
    1240:	3a0e0300 	bcc	381e48 <_bss_end+0x375fe4>
    1244:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    1248:	3f13490b 	svccc	0x0013490b
    124c:	3c0b3219 	sfmcc	f3, 4, [fp], {25}
    1250:	6c0b1c19 	stcvs	12, cr1, [fp], {25}
    1254:	1d000019 	stcne	0, cr0, [r0, #-100]	; 0xffffff9c
    1258:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
    125c:	0b3b0b3a 	bleq	ec3f4c <_bss_end+0xeb80e8>
    1260:	13490b39 	movtne	r0, #39737	; 0x9b39
    1264:	0b32193f 	bleq	c87768 <_bss_end+0xc7b904>
    1268:	196c193c 	stmdbne	ip!, {r2, r3, r4, r5, r8, fp, ip}^
    126c:	2e1e0000 	cdpcs	0, 1, cr0, cr14, cr0, {0}
    1270:	03193f01 	tsteq	r9, #1, 30
    1274:	3b0b3a0e 	blcc	2cfab4 <_bss_end+0x2c3c50>
    1278:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
    127c:	3213490e 	andscc	r4, r3, #229376	; 0x38000
    1280:	63193c0b 	tstvs	r9, #2816	; 0xb00
    1284:	01136419 	tsteq	r3, r9, lsl r4
    1288:	1f000013 	svcne	0x00000013
    128c:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
    1290:	0b3a0e03 	bleq	e84aa4 <_bss_end+0xe78c40>
    1294:	0b390b3b 	bleq	e43f88 <_bss_end+0xe38124>
    1298:	0b320e6e 	bleq	c84c58 <_bss_end+0xc78df4>
    129c:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
    12a0:	00001301 	andeq	r1, r0, r1, lsl #6
    12a4:	3f012e20 	svccc	0x00012e20
    12a8:	3a0e0319 	bcc	381f14 <_bss_end+0x3760b0>
    12ac:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    12b0:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
    12b4:	64193c13 	ldrvs	r3, [r9], #-3091	; 0xfffff3ed
    12b8:	00130113 	andseq	r0, r3, r3, lsl r1
    12bc:	00102100 	andseq	r2, r0, r0, lsl #2
    12c0:	13490b0b 	movtne	r0, #39691	; 0x9b0b
    12c4:	34220000 	strtcc	r0, [r2], #-0
    12c8:	3a134700 	bcc	4d2ed0 <_bss_end+0x4c706c>
    12cc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    12d0:	0018020b 	andseq	r0, r8, fp, lsl #4
    12d4:	002e2300 	eoreq	r2, lr, r0, lsl #6
    12d8:	19340e03 	ldmdbne	r4!, {r0, r1, r9, sl, fp}
    12dc:	06120111 			; <UNDEFINED> instruction: 0x06120111
    12e0:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
    12e4:	24000019 	strcs	r0, [r0], #-25	; 0xffffffe7
    12e8:	0e03012e 	adfeqsp	f0, f3, #0.5
    12ec:	01111934 	tsteq	r1, r4, lsr r9
    12f0:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
    12f4:	01194296 			; <UNDEFINED> instruction: 0x01194296
    12f8:	25000013 	strcs	r0, [r0, #-19]	; 0xffffffed
    12fc:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
    1300:	0b3b0b3a 	bleq	ec3ff0 <_bss_end+0xeb818c>
    1304:	13490b39 	movtne	r0, #39737	; 0x9b39
    1308:	00001802 	andeq	r1, r0, r2, lsl #16
    130c:	47012e26 	strmi	r2, [r1, -r6, lsr #28]
    1310:	3b0b3a13 	blcc	2cfb64 <_bss_end+0x2c3d00>
    1314:	640b390b 	strvs	r3, [fp], #-2315	; 0xfffff6f5
    1318:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
    131c:	96184006 	ldrls	r4, [r8], -r6
    1320:	13011942 	movwne	r1, #6466	; 0x1942
    1324:	05270000 	streq	r0, [r7, #-0]!
    1328:	490e0300 	stmdbmi	lr, {r8, r9}
    132c:	02193413 	andseq	r3, r9, #318767104	; 0x13000000
    1330:	28000018 	stmdacs	r0, {r3, r4}
    1334:	08030005 	stmdaeq	r3, {r0, r2}
    1338:	0b3b0b3a 	bleq	ec4028 <_bss_end+0xeb81c4>
    133c:	13490b39 	movtne	r0, #39737	; 0x9b39
    1340:	00001802 	andeq	r1, r0, r2, lsl #16
    1344:	03003429 	movweq	r3, #1065	; 0x429
    1348:	3b0b3a08 	blcc	2cfb70 <_bss_end+0x2c3d0c>
    134c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
    1350:	00180213 	andseq	r0, r8, r3, lsl r2
    1354:	010b2a00 	tsteq	fp, r0, lsl #20
    1358:	06120111 			; <UNDEFINED> instruction: 0x06120111
    135c:	342b0000 	strtcc	r0, [fp], #-0
    1360:	3a0e0300 	bcc	381f68 <_bss_end+0x376104>
    1364:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    1368:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
    136c:	2c000018 	stccs	0, cr0, [r0], {24}
    1370:	1347012e 	movtne	r0, #28974	; 0x712e
    1374:	0b3b0b3a 	bleq	ec4064 <_bss_end+0xeb8200>
    1378:	13640b39 	cmnne	r4, #58368	; 0xe400
    137c:	13010b20 	movwne	r0, #6944	; 0x1b20
    1380:	052d0000 	streq	r0, [sp, #-0]!
    1384:	490e0300 	stmdbmi	lr, {r8, r9}
    1388:	00193413 	andseq	r3, r9, r3, lsl r4
    138c:	010b2e00 	tsteq	fp, r0, lsl #28
    1390:	342f0000 	strtcc	r0, [pc], #-0	; 1398 <CPSR_IRQ_INHIBIT+0x1318>
    1394:	3a080300 	bcc	201f9c <_bss_end+0x1f6138>
    1398:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    139c:	0013490b 	andseq	r4, r3, fp, lsl #18
    13a0:	012e3000 			; <UNDEFINED> instruction: 0x012e3000
    13a4:	0e6e1331 	mcreq	3, 3, r1, cr14, cr1, {1}
    13a8:	01111364 	tsteq	r1, r4, ror #6
    13ac:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
    13b0:	01194297 			; <UNDEFINED> instruction: 0x01194297
    13b4:	31000013 	tstcc	r0, r3, lsl r0
    13b8:	13310005 	teqne	r1, #5
    13bc:	00001802 	andeq	r1, r0, r2, lsl #16
    13c0:	31010b32 	tstcc	r1, r2, lsr fp
    13c4:	00130113 	andseq	r0, r3, r3, lsl r1
    13c8:	00343300 	eorseq	r3, r4, r0, lsl #6
    13cc:	00001331 	andeq	r1, r0, r1, lsr r3
    13d0:	31010b34 	tstcc	r1, r4, lsr fp
    13d4:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
    13d8:	35000006 	strcc	r0, [r0, #-6]
    13dc:	13310034 	teqne	r1, #52	; 0x34
    13e0:	00001802 	andeq	r1, r0, r2, lsl #16
    13e4:	3f012e36 	svccc	0x00012e36
    13e8:	3a0e0319 	bcc	382054 <_bss_end+0x3761f0>
    13ec:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    13f0:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
    13f4:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
    13f8:	97184006 	ldrls	r4, [r8, -r6]
    13fc:	13011942 	movwne	r1, #6466	; 0x1942
    1400:	2e370000 	cdpcs	0, 3, cr0, cr7, cr0, {0}
    1404:	3a0e0301 	bcc	382010 <_bss_end+0x3761ac>
    1408:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    140c:	1113490b 	tstne	r3, fp, lsl #18
    1410:	40061201 	andmi	r1, r6, r1, lsl #4
    1414:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
    1418:	01000000 	mrseq	r0, (UNDEF: 0)
    141c:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
    1420:	0e030b13 	vmoveq.32	d3[0], r0
    1424:	17550e1b 	smmlane	r5, fp, lr, r0
    1428:	17100111 			; <UNDEFINED> instruction: 0x17100111
    142c:	24020000 	strcs	r0, [r2], #-0
    1430:	3e0b0b00 	vmlacc.f64	d0, d11, d0
    1434:	000e030b 	andeq	r0, lr, fp, lsl #6
    1438:	00260300 	eoreq	r0, r6, r0, lsl #6
    143c:	00001349 	andeq	r1, r0, r9, asr #6
    1440:	0b002404 	bleq	a458 <_ZN16CProcess_Manager9Switch_ToEP18CProcess_List_Node+0xcc>
    1444:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
    1448:	05000008 	streq	r0, [r0, #-8]
    144c:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
    1450:	0b3b0b3a 	bleq	ec4140 <_bss_end+0xeb82dc>
    1454:	13490b39 	movtne	r0, #39737	; 0x9b39
    1458:	35060000 	strcc	r0, [r6, #-0]
    145c:	00134900 	andseq	r4, r3, r0, lsl #18
    1460:	01040700 	tsteq	r4, r0, lsl #14
    1464:	196d0e03 	stmdbne	sp!, {r0, r1, r9, sl, fp}^
    1468:	0b0b0b3e 	bleq	2c4168 <_bss_end+0x2b8304>
    146c:	0b3a1349 	bleq	e86198 <_bss_end+0xe7a334>
    1470:	0b390b3b 	bleq	e44164 <_bss_end+0xe38300>
    1474:	00001301 	andeq	r1, r0, r1, lsl #6
    1478:	03002808 	movweq	r2, #2056	; 0x808
    147c:	000b1c08 	andeq	r1, fp, r8, lsl #24
    1480:	00280900 	eoreq	r0, r8, r0, lsl #18
    1484:	0b1c0e03 	bleq	704c98 <_bss_end+0x6f8e34>
    1488:	130a0000 	movwne	r0, #40960	; 0xa000
    148c:	0b0e0301 	bleq	382098 <_bss_end+0x376234>
    1490:	3b0b3a0b 	blcc	2cfcc4 <_bss_end+0x2c3e60>
    1494:	010b390b 	tsteq	fp, fp, lsl #18
    1498:	0b000013 	bleq	14ec <CPSR_IRQ_INHIBIT+0x146c>
    149c:	0803000d 	stmdaeq	r3, {r0, r2, r3}
    14a0:	0b3b0b3a 	bleq	ec4190 <_bss_end+0xeb832c>
    14a4:	13490b39 	movtne	r0, #39737	; 0x9b39
    14a8:	00000b38 	andeq	r0, r0, r8, lsr fp
    14ac:	03000d0c 	movweq	r0, #3340	; 0xd0c
    14b0:	3b0b3a0e 	blcc	2cfcf0 <_bss_end+0x2c3e8c>
    14b4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
    14b8:	000b3813 	andeq	r3, fp, r3, lsl r8
    14bc:	000f0d00 	andeq	r0, pc, r0, lsl #26
    14c0:	13490b0b 	movtne	r0, #39691	; 0x9b0b
    14c4:	020e0000 	andeq	r0, lr, #0
    14c8:	0b0e0301 	bleq	3820d4 <_bss_end+0x376270>
    14cc:	3b0b3a0b 	blcc	2cfd00 <_bss_end+0x2c3e9c>
    14d0:	010b390b 	tsteq	fp, fp, lsl #18
    14d4:	0f000013 	svceq	0x00000013
    14d8:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
    14dc:	0b3a0e03 	bleq	e84cf0 <_bss_end+0xe78e8c>
    14e0:	0b390b3b 	bleq	e441d4 <_bss_end+0xe38370>
    14e4:	193c0e6e 	ldmdbne	ip!, {r1, r2, r3, r5, r6, r9, sl, fp}
    14e8:	13011364 	movwne	r1, #4964	; 0x1364
    14ec:	05100000 	ldreq	r0, [r0, #-0]
    14f0:	34134900 	ldrcc	r4, [r3], #-2304	; 0xfffff700
    14f4:	11000019 	tstne	r0, r9, lsl r0
    14f8:	13490005 	movtne	r0, #36869	; 0x9005
    14fc:	2e120000 	cdpcs	0, 1, cr0, cr2, cr0, {0}
    1500:	03193f01 	tsteq	r9, #1, 30
    1504:	3b0b3a0e 	blcc	2cfd44 <_bss_end+0x2c3ee0>
    1508:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
    150c:	3213490e 	andscc	r4, r3, #229376	; 0x38000
    1510:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
    1514:	00130113 	andseq	r0, r3, r3, lsl r1
    1518:	012e1300 			; <UNDEFINED> instruction: 0x012e1300
    151c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
    1520:	0b3b0b3a 	bleq	ec4210 <_bss_end+0xeb83ac>
    1524:	0e6e0b39 	vmoveq.8	d14[5], r0
    1528:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
    152c:	13011364 	movwne	r1, #4964	; 0x1364
    1530:	2e140000 	cdpcs	0, 1, cr0, cr4, cr0, {0}
    1534:	03193f01 	tsteq	r9, #1, 30
    1538:	3b0b3a0e 	blcc	2cfd78 <_bss_end+0x2c3f14>
    153c:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
    1540:	3213490e 	andscc	r4, r3, #229376	; 0x38000
    1544:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
    1548:	15000013 	strne	r0, [r0, #-19]	; 0xffffffed
    154c:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
    1550:	0b3b0b3a 	bleq	ec4240 <_bss_end+0xeb83dc>
    1554:	13490b39 	movtne	r0, #39737	; 0x9b39
    1558:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
    155c:	04160000 	ldreq	r0, [r6], #-0
    1560:	6d0e0301 	stcvs	3, cr0, [lr, #-4]
    1564:	0b0b3e19 	bleq	2d0dd0 <_bss_end+0x2c4f6c>
    1568:	3a13490b 	bcc	4d399c <_bss_end+0x4c7b38>
    156c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    1570:	010b320b 	tsteq	fp, fp, lsl #4
    1574:	17000013 	smladne	r0, r3, r0, r0
    1578:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
    157c:	0b3b0b3a 	bleq	ec426c <_bss_end+0xeb8408>
    1580:	13490b39 	movtne	r0, #39737	; 0x9b39
    1584:	0b32193f 	bleq	c87a88 <_bss_end+0xc7bc24>
    1588:	0b1c193c 	bleq	707a80 <_bss_end+0x6fbc1c>
    158c:	0000196c 	andeq	r1, r0, ip, ror #18
    1590:	03000d18 	movweq	r0, #3352	; 0xd18
    1594:	3b0b3a0e 	blcc	2cfdd4 <_bss_end+0x2c3f70>
    1598:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
    159c:	32193f13 	andscc	r3, r9, #19, 30	; 0x4c
    15a0:	6c193c0b 	ldcvs	12, cr3, [r9], {11}
    15a4:	19000019 	stmdbne	r0, {r0, r3, r4}
    15a8:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
    15ac:	0b3a0e03 	bleq	e84dc0 <_bss_end+0xe78f5c>
    15b0:	0b390b3b 	bleq	e442a4 <_bss_end+0xe38440>
    15b4:	13490e6e 	movtne	r0, #40558	; 0x9e6e
    15b8:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
    15bc:	13641963 	cmnne	r4, #1622016	; 0x18c000
    15c0:	00001301 	andeq	r1, r0, r1, lsl #6
    15c4:	3f012e1a 	svccc	0x00012e1a
    15c8:	3a0e0319 	bcc	382234 <_bss_end+0x3763d0>
    15cc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    15d0:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
    15d4:	64193c13 	ldrvs	r3, [r9], #-3091	; 0xfffff3ed
    15d8:	00130113 	andseq	r0, r3, r3, lsl r1
    15dc:	00101b00 	andseq	r1, r0, r0, lsl #22
    15e0:	13490b0b 	movtne	r0, #39691	; 0x9b0b
    15e4:	2f1c0000 	svccs	0x001c0000
    15e8:	49080300 	stmdbmi	r8, {r8, r9}
    15ec:	1d000013 	stcne	0, cr0, [r0, #-76]	; 0xffffffb4
    15f0:	0b0b000f 	bleq	2c1634 <_bss_end+0x2b57d0>
    15f4:	391e0000 	ldmdbcc	lr, {}	; <UNPREDICTABLE>
    15f8:	3a080301 	bcc	202204 <_bss_end+0x1f63a0>
    15fc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    1600:	0013010b 	andseq	r0, r3, fp, lsl #2
    1604:	00341f00 	eorseq	r1, r4, r0, lsl #30
    1608:	0b3a0e03 	bleq	e84e1c <_bss_end+0xe78fb8>
    160c:	0b390b3b 	bleq	e44300 <_bss_end+0xe3849c>
    1610:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
    1614:	196c061c 	stmdbne	ip!, {r2, r3, r4, r9, sl}^
    1618:	34200000 	strtcc	r0, [r0], #-0
    161c:	3a0e0300 	bcc	382224 <_bss_end+0x3763c0>
    1620:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    1624:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
    1628:	6c0b1c19 	stcvs	12, cr1, [fp], {25}
    162c:	21000019 	tstcs	r0, r9, lsl r0
    1630:	13470034 	movtne	r0, #28724	; 0x7034
    1634:	34220000 	strtcc	r0, [r2], #-0
    1638:	3a0e0300 	bcc	382240 <_bss_end+0x3763dc>
    163c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    1640:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
    1644:	6c051c19 	stcvs	12, cr1, [r5], {25}
    1648:	23000019 	movwcs	r0, #25
    164c:	0e030102 	adfeqs	f0, f3, f2
    1650:	0b3a050b 	bleq	e82a84 <_bss_end+0xe76c20>
    1654:	0b390b3b 	bleq	e44348 <_bss_end+0xe384e4>
    1658:	00001301 	andeq	r1, r0, r1, lsl #6
    165c:	3f012e24 	svccc	0x00012e24
    1660:	3a0e0319 	bcc	3822cc <_bss_end+0x376468>
    1664:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    1668:	320e6e0b 	andcc	r6, lr, #11, 28	; 0xb0
    166c:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
    1670:	25000013 	strcs	r0, [r0, #-19]	; 0xffffffed
    1674:	13490101 	movtne	r0, #37121	; 0x9101
    1678:	00001301 	andeq	r1, r0, r1, lsl #6
    167c:	49002126 	stmdbmi	r0, {r1, r2, r5, r8, sp}
    1680:	00052f13 	andeq	r2, r5, r3, lsl pc
    1684:	00342700 	eorseq	r2, r4, r0, lsl #14
    1688:	0b3a1347 	bleq	e863ac <_bss_end+0xe7a548>
    168c:	0b390b3b 	bleq	e44380 <_bss_end+0xe3851c>
    1690:	00001802 	andeq	r1, r0, r2, lsl #16
    1694:	03002e28 	movweq	r2, #3624	; 0xe28
    1698:	1119340e 	tstne	r9, lr, lsl #8
    169c:	40061201 	andmi	r1, r6, r1, lsl #4
    16a0:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
    16a4:	2e290000 	cdpcs	0, 2, cr0, cr9, cr0, {0}
    16a8:	340e0301 	strcc	r0, [lr], #-769	; 0xfffffcff
    16ac:	12011119 	andne	r1, r1, #1073741830	; 0x40000006
    16b0:	96184006 	ldrls	r4, [r8], -r6
    16b4:	13011942 	movwne	r1, #6466	; 0x1942
    16b8:	052a0000 	streq	r0, [sl, #-0]!
    16bc:	3a0e0300 	bcc	3822c4 <_bss_end+0x376460>
    16c0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    16c4:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
    16c8:	2b000018 	blcs	1730 <CPSR_IRQ_INHIBIT+0x16b0>
    16cc:	1347012e 	movtne	r0, #28974	; 0x712e
    16d0:	01111364 	tsteq	r1, r4, ror #6
    16d4:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
    16d8:	01194296 			; <UNDEFINED> instruction: 0x01194296
    16dc:	2c000013 	stccs	0, cr0, [r0], {19}
    16e0:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
    16e4:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
    16e8:	00001802 	andeq	r1, r0, r2, lsl #16
    16ec:	47012e2d 	strmi	r2, [r1, -sp, lsr #28]
    16f0:	3b0b3a13 	blcc	2cff44 <_bss_end+0x2c40e0>
    16f4:	640b390b 	strvs	r3, [fp], #-2315	; 0xfffff6f5
    16f8:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
    16fc:	96184006 	ldrls	r4, [r8], -r6
    1700:	13011942 	movwne	r1, #6466	; 0x1942
    1704:	342e0000 	strtcc	r0, [lr], #-0
    1708:	3a080300 	bcc	202310 <_bss_end+0x1f64ac>
    170c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    1710:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
    1714:	2f000018 	svccs	0x00000018
    1718:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
    171c:	0b3b0b3a 	bleq	ec440c <_bss_end+0xeb85a8>
    1720:	13490b39 	movtne	r0, #39737	; 0x9b39
    1724:	00001802 	andeq	r1, r0, r2, lsl #16
    1728:	47012e30 	smladxmi	r1, r0, lr, r2
    172c:	3b0b3a13 	blcc	2cff80 <_bss_end+0x2c411c>
    1730:	640b390b 	strvs	r3, [fp], #-2315	; 0xfffff6f5
    1734:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
    1738:	97184006 	ldrls	r4, [r8, -r6]
    173c:	13011942 	movwne	r1, #6466	; 0x1942
    1740:	2e310000 	cdpcs	0, 3, cr0, cr1, cr0, {0}
    1744:	3a134701 	bcc	4d3350 <_bss_end+0x4c74ec>
    1748:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    174c:	2013640b 	andscs	r6, r3, fp, lsl #8
    1750:	0013010b 	andseq	r0, r3, fp, lsl #2
    1754:	00053200 	andeq	r3, r5, r0, lsl #4
    1758:	13490e03 	movtne	r0, #40451	; 0x9e03
    175c:	00001934 	andeq	r1, r0, r4, lsr r9
    1760:	31012e33 	tstcc	r1, r3, lsr lr
    1764:	640e6e13 	strvs	r6, [lr], #-3603	; 0xfffff1ed
    1768:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
    176c:	97184006 	ldrls	r4, [r8, -r6]
    1770:	00001942 	andeq	r1, r0, r2, asr #18
    1774:	31000534 	tstcc	r0, r4, lsr r5
    1778:	00180213 	andseq	r0, r8, r3, lsl r2
    177c:	11010000 	mrsne	r0, (UNDEF: 1)
    1780:	11061000 	mrsne	r1, (UNDEF: 6)
    1784:	03011201 	movweq	r1, #4609	; 0x1201
    1788:	250e1b0e 	strcs	r1, [lr, #-2830]	; 0xfffff4f2
    178c:	0005130e 	andeq	r1, r5, lr, lsl #6
    1790:	11010000 	mrsne	r0, (UNDEF: 1)
    1794:	55061000 	strpl	r1, [r6, #-0]
    1798:	1b0e0306 	blne	3823b8 <_bss_end+0x376554>
    179c:	130e250e 	movwne	r2, #58638	; 0xe50e
    17a0:	00000005 	andeq	r0, r0, r5
    17a4:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
    17a8:	030b130e 	movweq	r1, #45838	; 0xb30e
    17ac:	110e1b0e 	tstne	lr, lr, lsl #22
    17b0:	10061201 	andne	r1, r6, r1, lsl #4
    17b4:	02000017 	andeq	r0, r0, #23
    17b8:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
    17bc:	0b3b0b3a 	bleq	ec44ac <_bss_end+0xeb8648>
    17c0:	13490b39 	movtne	r0, #39737	; 0x9b39
    17c4:	0f030000 	svceq	0x00030000
    17c8:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
    17cc:	04000013 	streq	r0, [r0], #-19	; 0xffffffed
    17d0:	00000015 	andeq	r0, r0, r5, lsl r0
    17d4:	03003405 	movweq	r3, #1029	; 0x405
    17d8:	3b0b3a0e 	blcc	2d0018 <_bss_end+0x2c41b4>
    17dc:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
    17e0:	3c193f13 	ldccc	15, cr3, [r9], {19}
    17e4:	06000019 			; <UNDEFINED> instruction: 0x06000019
    17e8:	0b0b0024 	bleq	2c1880 <_bss_end+0x2b5a1c>
    17ec:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
    17f0:	01070000 	mrseq	r0, (UNDEF: 7)
    17f4:	01134901 	tsteq	r3, r1, lsl #18
    17f8:	08000013 	stmdaeq	r0, {r0, r1, r4}
    17fc:	13490021 	movtne	r0, #36897	; 0x9021
    1800:	0000062f 	andeq	r0, r0, pc, lsr #12
    1804:	0b002409 	bleq	a830 <_Z4itoajPcj+0x11c>
    1808:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
    180c:	0a00000e 	beq	184c <CPSR_IRQ_INHIBIT+0x17cc>
    1810:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
    1814:	0b3a0e03 	bleq	e85028 <_bss_end+0xe791c4>
    1818:	0b390b3b 	bleq	e4450c <_bss_end+0xe386a8>
    181c:	01111349 	tsteq	r1, r9, asr #6
    1820:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
    1824:	01194296 			; <UNDEFINED> instruction: 0x01194296
    1828:	0b000013 	bleq	187c <CPSR_IRQ_INHIBIT+0x17fc>
    182c:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
    1830:	0b3b0b3a 	bleq	ec4520 <_bss_end+0xeb86bc>
    1834:	13490b39 	movtne	r0, #39737	; 0x9b39
    1838:	00001802 	andeq	r1, r0, r2, lsl #16
    183c:	3f012e0c 	svccc	0x00012e0c
    1840:	3a0e0319 	bcc	3824ac <_bss_end+0x376648>
    1844:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    1848:	1113490b 	tstne	r3, fp, lsl #18
    184c:	40061201 	andmi	r1, r6, r1, lsl #4
    1850:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
    1854:	00001301 	andeq	r1, r0, r1, lsl #6
    1858:	0300340d 	movweq	r3, #1037	; 0x40d
    185c:	3b0b3a08 	blcc	2d0084 <_bss_end+0x2c4220>
    1860:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
    1864:	00180213 	andseq	r0, r8, r3, lsl r2
    1868:	11010000 	mrsne	r0, (UNDEF: 1)
    186c:	130e2501 	movwne	r2, #58625	; 0xe501
    1870:	1b0e030b 	blne	3824a4 <_bss_end+0x376640>
    1874:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
    1878:	00171006 	andseq	r1, r7, r6
    187c:	01390200 	teqeq	r9, r0, lsl #4
    1880:	00001301 	andeq	r1, r0, r1, lsl #6
    1884:	03003403 	movweq	r3, #1027	; 0x403
    1888:	3b0b3a0e 	blcc	2d00c8 <_bss_end+0x2c4264>
    188c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
    1890:	1c193c13 	ldcne	12, cr3, [r9], {19}
    1894:	0400000a 	streq	r0, [r0], #-10
    1898:	0b3a003a 	bleq	e81988 <_bss_end+0xe75b24>
    189c:	0b390b3b 	bleq	e44590 <_bss_end+0xe3872c>
    18a0:	00001318 	andeq	r1, r0, r8, lsl r3
    18a4:	49010105 	stmdbmi	r1, {r0, r2, r8}
    18a8:	00130113 	andseq	r0, r3, r3, lsl r1
    18ac:	00210600 	eoreq	r0, r1, r0, lsl #12
    18b0:	0b2f1349 	bleq	bc65dc <_bss_end+0xbba778>
    18b4:	26070000 	strcs	r0, [r7], -r0
    18b8:	00134900 	andseq	r4, r3, r0, lsl #18
    18bc:	00240800 	eoreq	r0, r4, r0, lsl #16
    18c0:	0b3e0b0b 	bleq	f844f4 <_bss_end+0xf78690>
    18c4:	00000e03 	andeq	r0, r0, r3, lsl #28
    18c8:	47003409 	strmi	r3, [r0, -r9, lsl #8]
    18cc:	0a000013 	beq	1920 <CPSR_IRQ_INHIBIT+0x18a0>
    18d0:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
    18d4:	0b3a0e03 	bleq	e850e8 <_bss_end+0xe79284>
    18d8:	0b390b3b 	bleq	e445cc <_bss_end+0xe38768>
    18dc:	01110e6e 	tsteq	r1, lr, ror #28
    18e0:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
    18e4:	01194296 			; <UNDEFINED> instruction: 0x01194296
    18e8:	0b000013 	bleq	193c <CPSR_IRQ_INHIBIT+0x18bc>
    18ec:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
    18f0:	0b3b0b3a 	bleq	ec45e0 <_bss_end+0xeb877c>
    18f4:	13490b39 	movtne	r0, #39737	; 0x9b39
    18f8:	00001802 	andeq	r1, r0, r2, lsl #16
    18fc:	0300340c 	movweq	r3, #1036	; 0x40c
    1900:	3b0b3a08 	blcc	2d0128 <_bss_end+0x2c42c4>
    1904:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
    1908:	00180213 	andseq	r0, r8, r3, lsl r2
    190c:	010b0d00 	tsteq	fp, r0, lsl #26
    1910:	06120111 			; <UNDEFINED> instruction: 0x06120111
    1914:	0f0e0000 	svceq	0x000e0000
    1918:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
    191c:	0f000013 	svceq	0x00000013
    1920:	0b0b0024 	bleq	2c19b8 <_bss_end+0x2b5b54>
    1924:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
    1928:	01000000 	mrseq	r0, (UNDEF: 0)
    192c:	06100011 			; <UNDEFINED> instruction: 0x06100011
    1930:	01120111 	tsteq	r2, r1, lsl r1
    1934:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
    1938:	05130e25 	ldreq	r0, [r3, #-3621]	; 0xfffff1db
    193c:	01000000 	mrseq	r0, (UNDEF: 0)
    1940:	06100011 			; <UNDEFINED> instruction: 0x06100011
    1944:	01120111 	tsteq	r2, r1, lsl r1
    1948:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
    194c:	05130e25 	ldreq	r0, [r3, #-3621]	; 0xfffff1db
    1950:	01000000 	mrseq	r0, (UNDEF: 0)
    1954:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
    1958:	0e030b13 	vmoveq.32	d3[0], r0
    195c:	17100e1b 			; <UNDEFINED> instruction: 0x17100e1b
    1960:	24020000 	strcs	r0, [r2], #-0
    1964:	3e0b0b00 	vmlacc.f64	d0, d11, d0
    1968:	0008030b 	andeq	r0, r8, fp, lsl #6
    196c:	00240300 	eoreq	r0, r4, r0, lsl #6
    1970:	0b3e0b0b 	bleq	f845a4 <_bss_end+0xf78740>
    1974:	00000e03 	andeq	r0, r0, r3, lsl #28
    1978:	03001604 	movweq	r1, #1540	; 0x604
    197c:	3b0b3a0e 	blcc	2d01bc <_bss_end+0x2c4358>
    1980:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
    1984:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
    1988:	0b0b000f 	bleq	2c19cc <_bss_end+0x2b5b68>
    198c:	00001349 	andeq	r1, r0, r9, asr #6
    1990:	27011506 	strcs	r1, [r1, -r6, lsl #10]
    1994:	01134919 	tsteq	r3, r9, lsl r9
    1998:	07000013 	smladeq	r0, r3, r0, r0
    199c:	13490005 	movtne	r0, #36869	; 0x9005
    19a0:	26080000 	strcs	r0, [r8], -r0
    19a4:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
    19a8:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
    19ac:	0b3b0b3a 	bleq	ec469c <_bss_end+0xeb8838>
    19b0:	13490b39 	movtne	r0, #39737	; 0x9b39
    19b4:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
    19b8:	040a0000 	streq	r0, [sl], #-0
    19bc:	3e0e0301 	cdpcc	3, 0, cr0, cr14, cr1, {0}
    19c0:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
    19c4:	3b0b3a13 	blcc	2d0218 <_bss_end+0x2c43b4>
    19c8:	010b390b 	tsteq	fp, fp, lsl #18
    19cc:	0b000013 	bleq	1a20 <CPSR_IRQ_INHIBIT+0x19a0>
    19d0:	0e030028 	cdpeq	0, 0, cr0, cr3, cr8, {1}
    19d4:	00000b1c 	andeq	r0, r0, ip, lsl fp
    19d8:	4901010c 	stmdbmi	r1, {r2, r3, r8}
    19dc:	00130113 	andseq	r0, r3, r3, lsl r1
    19e0:	00210d00 	eoreq	r0, r1, r0, lsl #26
    19e4:	260e0000 	strcs	r0, [lr], -r0
    19e8:	00134900 	andseq	r4, r3, r0, lsl #18
    19ec:	00340f00 	eorseq	r0, r4, r0, lsl #30
    19f0:	0b3a0e03 	bleq	e85204 <_bss_end+0xe793a0>
    19f4:	0b39053b 	bleq	e42ee8 <_bss_end+0xe37084>
    19f8:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
    19fc:	0000193c 	andeq	r1, r0, ip, lsr r9
    1a00:	03001310 	movweq	r1, #784	; 0x310
    1a04:	00193c0e 	andseq	r3, r9, lr, lsl #24
    1a08:	00151100 	andseq	r1, r5, r0, lsl #2
    1a0c:	00001927 	andeq	r1, r0, r7, lsr #18
    1a10:	03001712 	movweq	r1, #1810	; 0x712
    1a14:	00193c0e 	andseq	r3, r9, lr, lsl #24
    1a18:	01131300 	tsteq	r3, r0, lsl #6
    1a1c:	0b0b0e03 	bleq	2c5230 <_bss_end+0x2b93cc>
    1a20:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
    1a24:	13010b39 	movwne	r0, #6969	; 0x1b39
    1a28:	0d140000 	ldceq	0, cr0, [r4, #-0]
    1a2c:	3a0e0300 	bcc	382634 <_bss_end+0x3767d0>
    1a30:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
    1a34:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
    1a38:	1500000b 	strne	r0, [r0, #-11]
    1a3c:	13490021 	movtne	r0, #36897	; 0x9021
    1a40:	00000b2f 	andeq	r0, r0, pc, lsr #22
    1a44:	03010416 	movweq	r0, #5142	; 0x1416
    1a48:	0b0b3e0e 	bleq	2d1288 <_bss_end+0x2c5424>
    1a4c:	3a13490b 	bcc	4d3e80 <_bss_end+0x4c801c>
    1a50:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
    1a54:	0013010b 	andseq	r0, r3, fp, lsl #2
    1a58:	00341700 	eorseq	r1, r4, r0, lsl #14
    1a5c:	0b3a1347 	bleq	e86780 <_bss_end+0xe7a91c>
    1a60:	0b39053b 	bleq	e42f54 <_bss_end+0xe370f0>
    1a64:	00001802 	andeq	r1, r0, r2, lsl #16
	...

Disassembly of section .debug_aranges:

00000000 <.debug_aranges>:
   0:	0000001c 	andeq	r0, r0, ip, lsl r0
   4:	00000002 	andeq	r0, r0, r2
   8:	00040000 	andeq	r0, r4, r0
   c:	00000000 	andeq	r0, r0, r0
  10:	000080ac 	andeq	r8, r0, ip, lsr #1
  14:	000000d8 	ldrdeq	r0, [r0], -r8
	...
  20:	0000001c 	andeq	r0, r0, ip, lsl r0
  24:	012a0002 			; <UNDEFINED> instruction: 0x012a0002
  28:	00040000 	andeq	r0, r4, r0
  2c:	00000000 	andeq	r0, r0, r0
  30:	00008184 	andeq	r8, r0, r4, lsl #3
  34:	00000530 	andeq	r0, r0, r0, lsr r5
	...
  40:	00000044 	andeq	r0, r0, r4, asr #32
  44:	08850002 	stmeq	r5, {r1}
  48:	00040000 	andeq	r0, r4, r0
  4c:	00000000 	andeq	r0, r0, r0
  50:	000086b4 			; <UNDEFINED> instruction: 0x000086b4
  54:	00000638 	andeq	r0, r0, r8, lsr r6
  58:	00008cec 	andeq	r8, r0, ip, ror #25
  5c:	00000038 	andeq	r0, r0, r8, lsr r0
  60:	00008d24 	andeq	r8, r0, r4, lsr #26
  64:	00000088 	andeq	r0, r0, r8, lsl #1
  68:	00008dac 	andeq	r8, r0, ip, lsr #27
  6c:	0000002c 	andeq	r0, r0, ip, lsr #32
  70:	00008dd8 	ldrdeq	r8, [r0], -r8	; <UNPREDICTABLE>
  74:	00000090 	muleq	r0, r0, r0
  78:	00008e68 	andeq	r8, r0, r8, ror #28
  7c:	0000007c 	andeq	r0, r0, ip, ror r0
	...
  88:	0000001c 	andeq	r0, r0, ip, lsl r0
  8c:	101e0002 	andsne	r0, lr, r2
  90:	00040000 	andeq	r0, r4, r0
  94:	00000000 	andeq	r0, r0, r0
  98:	00008ee4 	andeq	r8, r0, r4, ror #29
  9c:	00000290 	muleq	r0, r0, r2
	...
  a8:	0000001c 	andeq	r0, r0, ip, lsl r0
  ac:	15710002 	ldrbne	r0, [r1, #-2]!
  b0:	00040000 	andeq	r0, r4, r0
  b4:	00000000 	andeq	r0, r0, r0
  b8:	00009174 	andeq	r9, r0, r4, ror r1
  bc:	0000025c 	andeq	r0, r0, ip, asr r2
	...
  c8:	0000001c 	andeq	r0, r0, ip, lsl r0
  cc:	1c0c0002 	stcne	0, cr0, [ip], {2}
  d0:	00040000 	andeq	r0, r4, r0
  d4:	00000000 	andeq	r0, r0, r0
  d8:	000093d0 	ldrdeq	r9, [r0], -r0
  dc:	00000398 	muleq	r0, r8, r3
	...
  e8:	0000001c 	andeq	r0, r0, ip, lsl r0
  ec:	29dd0002 	ldmibcs	sp, {r1}^
  f0:	00040000 	andeq	r0, r4, r0
  f4:	00000000 	andeq	r0, r0, r0
  f8:	00009768 	andeq	r9, r0, r8, ror #14
  fc:	0000036c 	andeq	r0, r0, ip, ror #6
	...
 108:	0000001c 	andeq	r0, r0, ip, lsl r0
 10c:	2e800002 	cdpcs	0, 8, cr0, cr0, cr2, {0}
 110:	00040000 	andeq	r0, r4, r0
 114:	00000000 	andeq	r0, r0, r0
 118:	00009ad4 	ldrdeq	r9, [r0], -r4
 11c:	00000514 	andeq	r0, r0, r4, lsl r5
	...
 128:	0000002c 	andeq	r0, r0, ip, lsr #32
 12c:	35ff0002 	ldrbcc	r0, [pc, #2]!	; 136 <CPSR_IRQ_INHIBIT+0xb6>
 130:	00040000 	andeq	r0, r4, r0
 134:	00000000 	andeq	r0, r0, r0
 138:	00009fe8 	andeq	r9, r0, r8, ror #31
 13c:	00000510 	andeq	r0, r0, r0, lsl r5
 140:	0000a4f8 	strdeq	sl, [r0], -r8
 144:	0000002c 	andeq	r0, r0, ip, lsr #32
 148:	0000a524 	andeq	sl, r0, r4, lsr #10
 14c:	0000002c 	andeq	r0, r0, ip, lsr #32
	...
 158:	0000001c 	andeq	r0, r0, ip, lsl r0
 15c:	40900002 	addsmi	r0, r0, r2
 160:	00040000 	andeq	r0, r4, r0
 164:	00000000 	andeq	r0, r0, r0
 168:	0000a550 	andeq	sl, r0, r0, asr r5
 16c:	0000005c 	andeq	r0, r0, ip, asr r0
	...
 178:	00000024 	andeq	r0, r0, r4, lsr #32
 17c:	40b60002 	adcsmi	r0, r6, r2
 180:	00040000 	andeq	r0, r4, r0
 184:	00000000 	andeq	r0, r0, r0
 188:	00008000 	andeq	r8, r0, r0
 18c:	000000ac 	andeq	r0, r0, ip, lsr #1
 190:	0000a5ac 	andeq	sl, r0, ip, lsr #11
 194:	00000050 	andeq	r0, r0, r0, asr r0
	...
 1a0:	0000001c 	andeq	r0, r0, ip, lsl r0
 1a4:	40d80002 	sbcsmi	r0, r8, r2
 1a8:	00040000 	andeq	r0, r4, r0
 1ac:	00000000 	andeq	r0, r0, r0
 1b0:	0000a5fc 	strdeq	sl, [r0], -ip
 1b4:	00000118 	andeq	r0, r0, r8, lsl r1
	...
 1c0:	0000001c 	andeq	r0, r0, ip, lsl r0
 1c4:	42270002 	eormi	r0, r7, #2
 1c8:	00040000 	andeq	r0, r4, r0
 1cc:	00000000 	andeq	r0, r0, r0
 1d0:	0000a714 	andeq	sl, r0, r4, lsl r7
 1d4:	00000174 	andeq	r0, r0, r4, ror r1
	...
 1e0:	0000001c 	andeq	r0, r0, ip, lsl r0
 1e4:	43360002 	teqmi	r6, #2
 1e8:	00040000 	andeq	r0, r4, r0
 1ec:	00000000 	andeq	r0, r0, r0
 1f0:	0000a888 	andeq	sl, r0, r8, lsl #17
 1f4:	0000020c 	andeq	r0, r0, ip, lsl #4
	...
 200:	0000001c 	andeq	r0, r0, ip, lsl r0
 204:	435c0002 	cmpmi	ip, #2
 208:	00040000 	andeq	r0, r4, r0
 20c:	00000000 	andeq	r0, r0, r0
 210:	0000aa94 	muleq	r0, r4, sl
 214:	00000004 	andeq	r0, r0, r4
	...
 220:	00000014 	andeq	r0, r0, r4, lsl r0
 224:	43820002 	orrmi	r0, r2, #2
 228:	00040000 	andeq	r0, r4, r0
	...

Disassembly of section .debug_line:

00000000 <.debug_line>:
       0:	000000b2 	strheq	r0, [r0], -r2
       4:	00790003 	rsbseq	r0, r9, r3
       8:	01020000 	mrseq	r0, (UNDEF: 2)
       c:	000d0efb 	strdeq	r0, [sp], -fp
      10:	01010101 	tsteq	r1, r1, lsl #2
      14:	01000000 	mrseq	r0, (UNDEF: 0)
      18:	2f010000 	svccs	0x00010000
      1c:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
      20:	6c69732f 	stclvs	3, cr7, [r9], #-188	; 0xffffff44
      24:	79766168 	ldmdbvc	r6!, {r3, r5, r6, r8, sp, lr}^
      28:	63532f6a 	cmpvs	r3, #424	; 0x1a8
      2c:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; fffffe94 <_bss_end+0xffff4030>
      30:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
      34:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
      38:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
      3c:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
      40:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
      44:	6f632d33 	svcvs	0x00632d33
      48:	7865746e 	stmdavc	r5!, {r1, r2, r3, r5, r6, sl, ip, sp, lr}^
      4c:	77735f74 			; <UNDEFINED> instruction: 0x77735f74
      50:	68637469 	stmdavs	r3!, {r0, r3, r5, r6, sl, ip, sp, lr}^
      54:	6e6f6d5f 	mcrvs	13, 3, r6, cr15, cr15, {2}
      58:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
      5c:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
      60:	2f6c656e 	svccs	0x006c656e
      64:	00637273 	rsbeq	r7, r3, r3, ror r2
      68:	78786300 	ldmdavc	r8!, {r8, r9, sp, lr}^
      6c:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
      70:	00000100 	andeq	r0, r0, r0, lsl #2
      74:	6975623c 	ldmdbvs	r5!, {r2, r3, r4, r5, r9, sp, lr}^
      78:	692d746c 	pushvs	{r2, r3, r5, r6, sl, ip, sp, lr}
      7c:	00003e6e 	andeq	r3, r0, lr, ror #28
      80:	05000000 	streq	r0, [r0, #-0]
      84:	02050002 	andeq	r0, r5, #2
      88:	000080ac 	andeq	r8, r0, ip, lsr #1
      8c:	05010a03 	streq	r0, [r1, #-2563]	; 0xfffff5fd
      90:	0a05830b 	beq	160cc4 <_bss_end+0x154e60>
      94:	8302054a 	movwhi	r0, #9546	; 0x254a
      98:	830e0585 	movwhi	r0, #58757	; 0xe585
      9c:	85670205 	strbhi	r0, [r7, #-517]!	; 0xfffffdfb
      a0:	86010584 	strhi	r0, [r1], -r4, lsl #11
      a4:	854c854c 	strbhi	r8, [ip, #-1356]	; 0xfffffab4
      a8:	0205854c 	andeq	r8, r5, #76, 10	; 0x13000000
      ac:	01040200 	mrseq	r0, R12_usr
      b0:	0002024b 	andeq	r0, r2, fp, asr #4
      b4:	03110101 	tsteq	r1, #1073741824	; 0x40000000
      b8:	00030000 	andeq	r0, r3, r0
      bc:	00000154 	andeq	r0, r0, r4, asr r1
      c0:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
      c4:	0101000d 	tsteq	r1, sp
      c8:	00000101 	andeq	r0, r0, r1, lsl #2
      cc:	00000100 	andeq	r0, r0, r0, lsl #2
      d0:	6f682f01 	svcvs	0x00682f01
      d4:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
      d8:	61686c69 	cmnvs	r8, r9, ror #24
      dc:	2f6a7976 	svccs	0x006a7976
      e0:	6f686353 	svcvs	0x00686353
      e4:	5a2f6c6f 	bpl	bdb2a8 <_bss_end+0xbcf444>
      e8:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; ffffff5c <_bss_end+0xffff40f8>
      ec:	2f657461 	svccs	0x00657461
      f0:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
      f4:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
      f8:	2d33312f 	ldfcss	f3, [r3, #-188]!	; 0xffffff44
      fc:	746e6f63 	strbtvc	r6, [lr], #-3939	; 0xfffff09d
     100:	5f747865 	svcpl	0x00747865
     104:	74697773 	strbtvc	r7, [r9], #-1907	; 0xfffff88d
     108:	6d5f6863 	ldclvs	8, cr6, [pc, #-396]	; ffffff84 <_bss_end+0xffff4120>
     10c:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
     110:	6b2f726f 	blvs	bdcad4 <_bss_end+0xbd0c70>
     114:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
     118:	72732f6c 	rsbsvc	r2, r3, #108, 30	; 0x1b0
     11c:	72642f63 	rsbvc	r2, r4, #396	; 0x18c
     120:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
     124:	682f0073 	stmdavs	pc!, {r0, r1, r4, r5, r6}	; <UNPREDICTABLE>
     128:	2f656d6f 	svccs	0x00656d6f
     12c:	686c6973 	stmdavs	ip!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
     130:	6a797661 	bvs	1e5dabc <_bss_end+0x1e51c58>
     134:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
     138:	2f6c6f6f 	svccs	0x006c6f6f
     13c:	6f72655a 	svcvs	0x0072655a
     140:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
     144:	6178652f 	cmnvs	r8, pc, lsr #10
     148:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
     14c:	33312f73 	teqcc	r1, #460	; 0x1cc
     150:	6e6f632d 	cdpvs	3, 6, cr6, cr15, cr13, {1}
     154:	74786574 	ldrbtvc	r6, [r8], #-1396	; 0xfffffa8c
     158:	6977735f 	ldmdbvs	r7!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, sp, lr}^
     15c:	5f686374 	svcpl	0x00686374
     160:	696e6f6d 	stmdbvs	lr!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
     164:	2f726f74 	svccs	0x00726f74
     168:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
     16c:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
     170:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
     174:	622f6564 	eorvs	r6, pc, #100, 10	; 0x19000000
     178:	6472616f 	ldrbtvs	r6, [r2], #-367	; 0xfffffe91
     17c:	6970722f 	ldmdbvs	r0!, {r0, r1, r2, r3, r5, r9, ip, sp, lr}^
     180:	61682f30 	cmnvs	r8, r0, lsr pc
     184:	682f006c 	stmdavs	pc!, {r2, r3, r5, r6}	; <UNPREDICTABLE>
     188:	2f656d6f 	svccs	0x00656d6f
     18c:	686c6973 	stmdavs	ip!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
     190:	6a797661 	bvs	1e5db1c <_bss_end+0x1e51cb8>
     194:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
     198:	2f6c6f6f 	svccs	0x006c6f6f
     19c:	6f72655a 	svcvs	0x0072655a
     1a0:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
     1a4:	6178652f 	cmnvs	r8, pc, lsr #10
     1a8:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
     1ac:	33312f73 	teqcc	r1, #460	; 0x1cc
     1b0:	6e6f632d 	cdpvs	3, 6, cr6, cr15, cr13, {1}
     1b4:	74786574 	ldrbtvc	r6, [r8], #-1396	; 0xfffffa8c
     1b8:	6977735f 	ldmdbvs	r7!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, sp, lr}^
     1bc:	5f686374 	svcpl	0x00686374
     1c0:	696e6f6d 	stmdbvs	lr!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
     1c4:	2f726f74 	svccs	0x00726f74
     1c8:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
     1cc:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
     1d0:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
     1d4:	642f6564 	strtvs	r6, [pc], #-1380	; 1dc <CPSR_IRQ_INHIBIT+0x15c>
     1d8:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
     1dc:	00007372 	andeq	r7, r0, r2, ror r3
     1e0:	6f697067 	svcvs	0x00697067
     1e4:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
     1e8:	00000100 	andeq	r0, r0, r0, lsl #2
     1ec:	69726570 	ldmdbvs	r2!, {r4, r5, r6, r8, sl, sp, lr}^
     1f0:	72656870 	rsbvc	r6, r5, #112, 16	; 0x700000
     1f4:	2e736c61 	cdpcs	12, 7, cr6, cr3, cr1, {3}
     1f8:	00020068 	andeq	r0, r2, r8, rrx
     1fc:	69706700 	ldmdbvs	r0!, {r8, r9, sl, sp, lr}^
     200:	00682e6f 	rsbeq	r2, r8, pc, ror #28
     204:	69000003 	stmdbvs	r0, {r0, r1}
     208:	6564746e 	strbvs	r7, [r4, #-1134]!	; 0xfffffb92
     20c:	00682e66 	rsbeq	r2, r8, r6, ror #28
     210:	00000002 	andeq	r0, r0, r2
     214:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
     218:	00818402 	addeq	r8, r1, r2, lsl #8
     21c:	0a051700 	beq	145e24 <_bss_end+0x139fc0>
     220:	2e39059f 	mrccs	5, 1, r0, cr9, cr15, {4}
     224:	a14d0105 	cmpge	sp, r5, lsl #2
     228:	05d70205 	ldrbeq	r0, [r7, #517]	; 0x205
     22c:	0c05670a 	stceq	7, cr6, [r5], {10}
     230:	8206054c 	andhi	r0, r6, #76, 10	; 0x13000000
     234:	0b031105 	bleq	c4650 <_bss_end+0xb87ec>
     238:	0817054a 	ldmdaeq	r7, {r1, r3, r6, r8, sl}
     23c:	660a0520 	strvs	r0, [sl], -r0, lsr #10
     240:	054c0905 	strbeq	r0, [ip, #-2309]	; 0xfffff6fb
     244:	05a12f01 	streq	r2, [r1, #3841]!	; 0xf01
     248:	0a05d702 	beq	175e58 <_bss_end+0x169ff4>
     24c:	4c080567 	cfstr32mi	mvfx0, [r8], {103}	; 0x67
     250:	01040200 	mrseq	r0, R12_usr
     254:	02006606 	andeq	r6, r0, #6291456	; 0x600000
     258:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
     25c:	04020006 	streq	r0, [r2], #-6
     260:	052e0604 	streq	r0, [lr, #-1540]!	; 0xfffff9fc
     264:	04020010 	streq	r0, [r2], #-16
     268:	0a054b04 	beq	152e80 <_bss_end+0x14701c>
     26c:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
     270:	0009054a 	andeq	r0, r9, sl, asr #10
     274:	4c040402 	cfstrsmi	mvf0, [r4], {2}
     278:	852f0105 	strhi	r0, [pc, #-261]!	; 17b <CPSR_IRQ_INHIBIT+0xfb>
     27c:	05d70205 	ldrbeq	r0, [r7, #517]	; 0x205
     280:	0805670a 	stmdaeq	r5, {r1, r3, r8, r9, sl, sp, lr}
     284:	0402004c 	streq	r0, [r2], #-76	; 0xffffffb4
     288:	00660601 	rsbeq	r0, r6, r1, lsl #12
     28c:	4a020402 	bmi	8129c <_bss_end+0x75438>
     290:	02000605 	andeq	r0, r0, #5242880	; 0x500000
     294:	2e060404 	cdpcs	4, 0, cr0, cr6, cr4, {0}
     298:	02001005 	andeq	r1, r0, #5
     29c:	054b0404 	strbeq	r0, [fp, #-1028]	; 0xfffffbfc
     2a0:	0402000a 	streq	r0, [r2], #-10
     2a4:	09054a04 	stmdbeq	r5, {r2, r9, fp, lr}
     2a8:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
     2ac:	2f01054c 	svccs	0x0001054c
     2b0:	d7020585 	strle	r0, [r2, -r5, lsl #11]
     2b4:	05670a05 	strbeq	r0, [r7, #-2565]!	; 0xfffff5fb
     2b8:	02004c08 	andeq	r4, r0, #8, 24	; 0x800
     2bc:	66060104 	strvs	r0, [r6], -r4, lsl #2
     2c0:	02040200 	andeq	r0, r4, #0, 4
     2c4:	0006054a 	andeq	r0, r6, sl, asr #10
     2c8:	06040402 	streq	r0, [r4], -r2, lsl #8
     2cc:	0010052e 	andseq	r0, r0, lr, lsr #10
     2d0:	4b040402 	blmi	1012e0 <_bss_end+0xf547c>
     2d4:	02000a05 	andeq	r0, r0, #20480	; 0x5000
     2d8:	054a0404 	strbeq	r0, [sl, #-1028]	; 0xfffffbfc
     2dc:	04020009 	streq	r0, [r2], #-9
     2e0:	01054c04 	tsteq	r5, r4, lsl #24
     2e4:	1a05852f 	bne	1617a8 <_bss_end+0x155944>
     2e8:	ba0605bc 	blt	1819e0 <_bss_end+0x175b7c>
     2ec:	054a0205 	strbeq	r0, [sl, #-517]	; 0xfffffdfb
     2f0:	14054d0f 	strne	r4, [r5], #-3343	; 0xfffff2f1
     2f4:	4a1d054c 	bmi	74182c <_bss_end+0x7359c8>
     2f8:	059f0c05 	ldreq	r0, [pc, #3077]	; f05 <CPSR_IRQ_INHIBIT+0xe85>
     2fc:	05056608 	streq	r6, [r5, #-1544]	; 0xfffff9f8
     300:	670e054a 	strvs	r0, [lr, -sl, asr #10]
     304:	05660505 	strbeq	r0, [r6, #-1285]!	; 0xfffffafb
     308:	0b056802 	bleq	15a318 <_bss_end+0x14e4b4>
     30c:	660d054a 	strvs	r0, [sp], -sl, asr #10
     310:	78030305 	stmdavc	r3, {r0, r2, r8, r9}
     314:	03010566 	movweq	r0, #5478	; 0x1566
     318:	054d2e09 	strbeq	r2, [sp, #-3593]	; 0xfffff1f7
     31c:	0605a01a 			; <UNDEFINED> instruction: 0x0605a01a
     320:	4a0205ba 	bmi	81a10 <_bss_end+0x75bac>
     324:	054b1a05 	strbeq	r1, [fp, #-2565]	; 0xfffff5fb
     328:	2f054c26 	svccs	0x00054c26
     32c:	8231054a 	eorshi	r0, r1, #310378496	; 0x12800000
     330:	054a3c05 	strbeq	r3, [sl, #-3077]	; 0xfffff3fb
     334:	04020001 	streq	r0, [r2], #-1
     338:	05692f01 	strbeq	r2, [r9, #-3841]!	; 0xfffff0ff
     33c:	3205d808 	andcc	sp, r5, #8, 16	; 0x80000
     340:	00210566 	eoreq	r0, r1, r6, ror #10
     344:	4a020402 	bmi	81354 <_bss_end+0x754f0>
     348:	02000605 	andeq	r0, r0, #5242880	; 0x500000
     34c:	05f20204 	ldrbeq	r0, [r2, #516]!	; 0x204
     350:	04020032 	streq	r0, [r2], #-50	; 0xffffffce
     354:	51054a03 	tstpl	r5, r3, lsl #20
     358:	06040200 	streq	r0, [r4], -r0, lsl #4
     35c:	00350566 	eorseq	r0, r5, r6, ror #10
     360:	f2060402 	vshl.s8	d0, d2, d6
     364:	02003205 	andeq	r3, r0, #1342177280	; 0x50000000
     368:	004a0704 	subeq	r0, sl, r4, lsl #14
     36c:	06080402 	streq	r0, [r8], -r2, lsl #8
     370:	0002054a 	andeq	r0, r2, sl, asr #10
     374:	060a0402 	streq	r0, [sl], -r2, lsl #8
     378:	4d12052e 	cfldr32mi	mvfx0, [r2, #-184]	; 0xffffff48
     37c:	05660205 	strbeq	r0, [r6, #-517]!	; 0xfffffdfb
     380:	12054a0b 	andne	r4, r5, #45056	; 0xb000
     384:	2e0d0566 	cfsh32cs	mvfx0, mvfx13, #54
     388:	05480305 	strbeq	r0, [r8, #-773]	; 0xfffffcfb
     38c:	054d3101 	strbeq	r3, [sp, #-257]	; 0xfffffeff
     390:	0605a019 			; <UNDEFINED> instruction: 0x0605a019
     394:	4a0205ba 	bmi	81a84 <_bss_end+0x75c20>
     398:	4c4b0a05 	mcrrmi	10, 0, r0, fp, cr5
     39c:	054a1305 	strbeq	r1, [sl, #-773]	; 0xfffffcfb
     3a0:	1d058215 	sfmne	f0, 1, [r5, #-84]	; 0xffffffac
     3a4:	2e1f054a 	cfmac32cs	mvfx0, mvfx15, mvfx10
     3a8:	02000105 	andeq	r0, r0, #1073741825	; 0x40000001
     3ac:	66830104 	strvs	r0, [r3], r4, lsl #2
     3b0:	0402009e 	streq	r0, [r2], #-158	; 0xffffff62
     3b4:	05660601 	strbeq	r0, [r6, #-1537]!	; 0xfffff9ff
     3b8:	9a030623 	bls	c1c4c <_bss_end+0xb5de8>
     3bc:	0105827f 	tsteq	r5, pc, ror r2
     3c0:	6600e603 	strvs	lr, [r0], -r3, lsl #12
     3c4:	0a024aba 	beq	92eb4 <_bss_end+0x87050>
     3c8:	59010100 	stmdbpl	r1, {r8}
     3cc:	03000004 	movweq	r0, #4
     3d0:	0000dd00 	andeq	sp, r0, r0, lsl #26
     3d4:	fb010200 	blx	40bde <_bss_end+0x34d7a>
     3d8:	01000d0e 	tsteq	r0, lr, lsl #26
     3dc:	00010101 	andeq	r0, r1, r1, lsl #2
     3e0:	00010000 	andeq	r0, r1, r0
     3e4:	682f0100 	stmdavs	pc!, {r8}	; <UNPREDICTABLE>
     3e8:	2f656d6f 	svccs	0x00656d6f
     3ec:	686c6973 	stmdavs	ip!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
     3f0:	6a797661 	bvs	1e5dd7c <_bss_end+0x1e51f18>
     3f4:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
     3f8:	2f6c6f6f 	svccs	0x006c6f6f
     3fc:	6f72655a 	svcvs	0x0072655a
     400:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
     404:	6178652f 	cmnvs	r8, pc, lsr #10
     408:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
     40c:	33312f73 	teqcc	r1, #460	; 0x1cc
     410:	6e6f632d 	cdpvs	3, 6, cr6, cr15, cr13, {1}
     414:	74786574 	ldrbtvc	r6, [r8], #-1396	; 0xfffffa8c
     418:	6977735f 	ldmdbvs	r7!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, sp, lr}^
     41c:	5f686374 	svcpl	0x00686374
     420:	696e6f6d 	stmdbvs	lr!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
     424:	2f726f74 	svccs	0x00726f74
     428:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
     42c:	732f6c65 			; <UNDEFINED> instruction: 0x732f6c65
     430:	642f6372 	strtvs	r6, [pc], #-882	; 438 <CPSR_IRQ_INHIBIT+0x3b8>
     434:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
     438:	2f007372 	svccs	0x00007372
     43c:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     440:	6c69732f 	stclvs	3, cr7, [r9], #-188	; 0xffffff44
     444:	79766168 	ldmdbvc	r6!, {r3, r5, r6, r8, sp, lr}^
     448:	63532f6a 	cmpvs	r3, #424	; 0x1a8
     44c:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; 2b4 <CPSR_IRQ_INHIBIT+0x234>
     450:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
     454:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
     458:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
     45c:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
     460:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
     464:	6f632d33 	svcvs	0x00632d33
     468:	7865746e 	stmdavc	r5!, {r1, r2, r3, r5, r6, sl, ip, sp, lr}^
     46c:	77735f74 			; <UNDEFINED> instruction: 0x77735f74
     470:	68637469 	stmdavs	r3!, {r0, r3, r5, r6, sl, ip, sp, lr}^
     474:	6e6f6d5f 	mcrvs	13, 3, r6, cr15, cr15, {2}
     478:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
     47c:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
     480:	2f6c656e 	svccs	0x006c656e
     484:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
     488:	2f656475 	svccs	0x00656475
     48c:	76697264 	strbtvc	r7, [r9], -r4, ror #4
     490:	00737265 	rsbseq	r7, r3, r5, ror #4
     494:	6e6f6d00 	cdpvs	13, 6, cr6, cr15, cr0, {0}
     498:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
     49c:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
     4a0:	00000100 	andeq	r0, r0, r0, lsl #2
     4a4:	696e6f6d 	stmdbvs	lr!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
     4a8:	2e726f74 	mrccs	15, 3, r6, cr2, cr4, {3}
     4ac:	00020068 	andeq	r0, r2, r8, rrx
     4b0:	01050000 	mrseq	r0, (UNDEF: 5)
     4b4:	b4020500 	strlt	r0, [r2], #-1280	; 0xfffffb00
     4b8:	16000086 	strne	r0, [r0], -r6, lsl #1
     4bc:	05d70e05 	ldrbeq	r0, [r7, #3589]	; 0xe05
     4c0:	01053226 	tsteq	r5, r6, lsr #4
     4c4:	03142202 	tsteq	r4, #536870912	; 0x20000000
     4c8:	11059e09 	tstne	r5, r9, lsl #28
     4cc:	4c170583 	cfldr32mi	mvfx0, [r7], {131}	; 0x83
     4d0:	02002205 	andeq	r2, r0, #1342177280	; 0x50000000
     4d4:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
     4d8:	04020020 	streq	r0, [r2], #-32	; 0xffffffe0
     4dc:	1b054a01 	blne	152ce8 <_bss_end+0x146e84>
     4e0:	00260568 	eoreq	r0, r6, r8, ror #10
     4e4:	4a030402 	bmi	c14f4 <_bss_end+0xb5690>
     4e8:	02002405 	andeq	r2, r0, #83886080	; 0x5000000
     4ec:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
     4f0:	0402000d 	streq	r0, [r2], #-13
     4f4:	1c056802 	stcne	8, cr6, [r5], {2}
     4f8:	02040200 	andeq	r0, r4, #0, 4
     4fc:	001a054a 	andseq	r0, sl, sl, asr #10
     500:	4a020402 	bmi	81510 <_bss_end+0x756ac>
     504:	02002505 	andeq	r2, r0, #20971520	; 0x1400000
     508:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
     50c:	04020028 	streq	r0, [r2], #-40	; 0xffffffd8
     510:	2a054a02 	bcs	152d20 <_bss_end+0x146ebc>
     514:	02040200 	andeq	r0, r4, #0, 4
     518:	0009052e 	andeq	r0, r9, lr, lsr #10
     51c:	48020402 	stmdami	r2, {r1, sl}
     520:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
     524:	05800204 	streq	r0, [r0, #516]	; 0x204
     528:	12038901 	andne	r8, r3, #16384	; 0x4000
     52c:	83170566 	tsthi	r7, #427819008	; 0x19800000
     530:	02002205 	andeq	r2, r0, #1342177280	; 0x50000000
     534:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
     538:	04020020 	streq	r0, [r2], #-32	; 0xffffffe0
     53c:	1b054a01 	blne	152d48 <_bss_end+0x146ee4>
     540:	00260568 	eoreq	r0, r6, r8, ror #10
     544:	4a030402 	bmi	c1554 <_bss_end+0xb56f0>
     548:	02002405 	andeq	r2, r0, #83886080	; 0x5000000
     54c:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
     550:	04020032 	streq	r0, [r2], #-50	; 0xffffffce
     554:	41056802 	tstmi	r5, r2, lsl #16
     558:	02040200 	andeq	r0, r4, #0, 4
     55c:	003f054a 	eorseq	r0, pc, sl, asr #10
     560:	4a020402 	bmi	81570 <_bss_end+0x7570c>
     564:	02004a05 	andeq	r4, r0, #20480	; 0x5000
     568:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
     56c:	0402004d 	streq	r0, [r2], #-77	; 0xffffffb3
     570:	0d054a02 	vstreq	s8, [r5, #-8]
     574:	02040200 	andeq	r0, r4, #0, 4
     578:	001b052e 	andseq	r0, fp, lr, lsr #10
     57c:	4a020402 	bmi	8158c <_bss_end+0x75728>
     580:	02002205 	andeq	r2, r0, #1342177280	; 0x50000000
     584:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
     588:	04020020 	streq	r0, [r2], #-32	; 0xffffffe0
     58c:	2b054a02 	blcs	152d9c <_bss_end+0x146f38>
     590:	02040200 	andeq	r0, r4, #0, 4
     594:	002e052e 	eoreq	r0, lr, lr, lsr #10
     598:	4a020402 	bmi	815a8 <_bss_end+0x75744>
     59c:	02004d05 	andeq	r4, r0, #320	; 0x140
     5a0:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
     5a4:	04020030 	streq	r0, [r2], #-48	; 0xffffffd0
     5a8:	09054a02 	stmdbeq	r5, {r1, r9, fp, lr}
     5ac:	02040200 	andeq	r0, r4, #0, 4
     5b0:	0005052c 	andeq	r0, r5, ip, lsr #10
     5b4:	80020402 	andhi	r0, r2, r2, lsl #8
     5b8:	058a1705 	streq	r1, [sl, #1797]	; 0x705
     5bc:	04020022 	streq	r0, [r2], #-34	; 0xffffffde
     5c0:	20054a03 	andcs	r4, r5, r3, lsl #20
     5c4:	03040200 	movweq	r0, #16896	; 0x4200
     5c8:	0009054a 	andeq	r0, r9, sl, asr #10
     5cc:	68020402 	stmdavs	r2, {r1, sl}
     5d0:	02001505 	andeq	r1, r0, #20971520	; 0x1400000
     5d4:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
     5d8:	0402001e 	streq	r0, [r2], #-30	; 0xffffffe2
     5dc:	25054a02 	strcs	r4, [r5, #-2562]	; 0xfffff5fe
     5e0:	02040200 	andeq	r0, r4, #0, 4
     5e4:	0023052e 	eoreq	r0, r3, lr, lsr #10
     5e8:	4a020402 	bmi	815f8 <_bss_end+0x75794>
     5ec:	02002e05 	andeq	r2, r0, #5, 28	; 0x50
     5f0:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
     5f4:	04020031 	streq	r0, [r2], #-49	; 0xffffffcf
     5f8:	33054a02 	movwcc	r4, #23042	; 0x5a02
     5fc:	02040200 	andeq	r0, r4, #0, 4
     600:	0005052e 	andeq	r0, r5, lr, lsr #10
     604:	48020402 	stmdami	r2, {r1, sl}
     608:	8a860105 	bhi	fe180a24 <_bss_end+0xfe174bc0>
     60c:	05bb0505 	ldreq	r0, [fp, #1285]!	; 0x505
     610:	1d056809 	stcne	8, cr6, [r5, #-36]	; 0xffffffdc
     614:	4a21054a 	bmi	841b44 <_bss_end+0x835ce0>
     618:	054a1f05 	strbeq	r1, [sl, #-3845]	; 0xfffff0fb
     61c:	2a052e35 	bcs	14bef8 <_bss_end+0x140094>
     620:	2e36054a 	cdpcs	5, 3, cr0, cr6, cr10, {2}
     624:	052e3805 	streq	r3, [lr, #-2053]!	; 0xfffff7fb
     628:	09054b14 	stmdbeq	r5, {r2, r4, r8, r9, fp, lr}
     62c:	8614054a 	ldrhi	r0, [r4], -sl, asr #10
     630:	4a090567 	bmi	241bd4 <_bss_end+0x235d70>
     634:	05691205 	strbeq	r1, [r9, #-517]!	; 0xfffffdfb
     638:	01054c0d 	tsteq	r5, sp, lsl #24
     63c:	1705692f 	strne	r6, [r5, -pc, lsr #18]
     640:	0023059f 	mlaeq	r3, pc, r5, r0	; <UNPREDICTABLE>
     644:	4a030402 	bmi	c1654 <_bss_end+0xb57f0>
     648:	02002505 	andeq	r2, r0, #20971520	; 0x1400000
     64c:	05820304 	streq	r0, [r2, #772]	; 0x304
     650:	04020017 	streq	r0, [r2], #-23	; 0xffffffe9
     654:	05054c02 	streq	r4, [r5, #-3074]	; 0xfffff3fe
     658:	02040200 	andeq	r0, r4, #0, 4
     65c:	871605d4 			; <UNDEFINED> instruction: 0x871605d4
     660:	054c0d05 	strbeq	r0, [ip, #-3333]	; 0xfffff2fb
     664:	05692f01 	strbeq	r2, [r9, #-3841]!	; 0xfffff0ff
     668:	0d059f13 	stceq	15, cr9, [r5, #-76]	; 0xffffffb4
     66c:	2f010568 	svccs	0x00010568
     670:	a3330585 	teqge	r3, #557842432	; 0x21400000
     674:	054a0905 	strbeq	r0, [sl, #-2309]	; 0xfffff6fb
     678:	1605830e 	strne	r8, [r5], -lr, lsl #6
     67c:	4c0d0567 	cfstr32mi	mvfx0, [sp], {103}	; 0x67
     680:	852f0105 	strhi	r0, [pc, #-261]!	; 583 <CPSR_IRQ_INHIBIT+0x503>
     684:	05bb0505 	ldreq	r0, [fp, #1285]!	; 0x505
     688:	05866812 	streq	r6, [r6, #2066]	; 0x812
     68c:	0d056916 	vstreq.16	s12, [r5, #-44]	; 0xffffffd4	; <UNPREDICTABLE>
     690:	2f01054c 	svccs	0x0001054c
     694:	059e2d03 	ldreq	r2, [lr, #3331]	; 0xd03
     698:	1205d709 	andne	sp, r5, #2359296	; 0x240000
     69c:	682a054c 	stmdavs	sl!, {r2, r3, r6, r8, sl}
     6a0:	059e3705 	ldreq	r3, [lr, #1797]	; 0x705
     6a4:	11054a10 	tstne	r5, r0, lsl sl
     6a8:	4a37052e 	bmi	dc1b68 <_bss_end+0xdb5d04>
     6ac:	052e1305 	streq	r1, [lr, #-773]!	; 0xfffffcfb
     6b0:	0a052f17 	beq	14c314 <_bss_end+0x1404b0>
     6b4:	6205059f 	andvs	r0, r5, #666894336	; 0x27c00000
     6b8:	68100535 	ldmdavs	r0, {r0, r2, r4, r5, r8, sl}
     6bc:	052e1105 	streq	r1, [lr, #-261]!	; 0xfffffefb
     6c0:	13054a22 	movwne	r4, #23074	; 0x5a22
     6c4:	2f0a052e 	svccs	0x000a052e
     6c8:	05690c05 	strbeq	r0, [r9, #-3077]!	; 0xfffff3fb
     6cc:	0f052e0d 	svceq	0x00052e0d
     6d0:	4b06054a 	blmi	181c00 <_bss_end+0x175d9c>
     6d4:	05680e05 	strbeq	r0, [r8, #-3589]!	; 0xfffff1fb
     6d8:	0402001d 	streq	r0, [r2], #-29	; 0xffffffe3
     6dc:	17054a03 	strne	r4, [r5, -r3, lsl #20]
     6e0:	03040200 	movweq	r0, #16896	; 0x4200
     6e4:	001b054a 	andseq	r0, fp, sl, asr #10
     6e8:	68020402 	stmdavs	r2, {r1, sl}
     6ec:	02001e05 	andeq	r1, r0, #5, 28	; 0x50
     6f0:	05820204 	streq	r0, [r2, #516]	; 0x204
     6f4:	0402000e 	streq	r0, [r2], #-14
     6f8:	20054a02 	andcs	r4, r5, r2, lsl #20
     6fc:	02040200 	andeq	r0, r4, #0, 4
     700:	0021054b 	eoreq	r0, r1, fp, asr #10
     704:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
     708:	02001205 	andeq	r1, r0, #1342177280	; 0x50000000
     70c:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
     710:	04020015 	streq	r0, [r2], #-21	; 0xffffffeb
     714:	21058202 	tstcs	r5, r2, lsl #4
     718:	02040200 	andeq	r0, r4, #0, 4
     71c:	0017054a 	andseq	r0, r7, sl, asr #10
     720:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
     724:	02001005 	andeq	r1, r0, #5
     728:	052f0204 	streq	r0, [pc, #-516]!	; 52c <CPSR_IRQ_INHIBIT+0x4ac>
     72c:	04020011 	streq	r0, [r2], #-17	; 0xffffffef
     730:	13052e02 	movwne	r2, #24066	; 0x5e02
     734:	02040200 	andeq	r0, r4, #0, 4
     738:	0005054a 	andeq	r0, r5, sl, asr #10
     73c:	46020402 	strmi	r0, [r2], -r2, lsl #8
     740:	82880105 	addhi	r0, r8, #1073741825	; 0x40000001
     744:	0402009e 	streq	r0, [r2], #-158	; 0xffffff62
     748:	05660601 	strbeq	r0, [r6, #-1537]!	; 0xfffff9ff
     74c:	b8030627 	stmdalt	r3, {r0, r1, r2, r5, r9, sl}
     750:	0105827e 	tsteq	r5, lr, ror r2
     754:	9e01c803 	cdpls	8, 0, cr12, cr1, cr3, {0}
     758:	0a024a9e 	beq	931d8 <_bss_end+0x87374>
     75c:	05010100 	streq	r0, [r1, #-256]	; 0xffffff00
     760:	02050001 	andeq	r0, r5, #1
     764:	00008cec 	andeq	r8, r0, ip, ror #25
     768:	05010e03 	streq	r0, [r1, #-3587]	; 0xfffff1fd
     76c:	05678310 	strbeq	r8, [r7, #-784]!	; 0xfffffcf0
     770:	08026701 	stmdaeq	r2, {r0, r8, r9, sl, sp, lr}
     774:	05010100 	streq	r0, [r1, #-256]	; 0xffffff00
     778:	02050001 	andeq	r0, r5, #1
     77c:	00008d24 	andeq	r8, r0, r4, lsr #26
     780:	05012103 	streq	r2, [r1, #-259]	; 0xfffffefd
     784:	17058312 	smladne	r5, r2, r3, r8
     788:	4a05054a 	bmi	141cb8 <_bss_end+0x135e54>
     78c:	674c1405 	strbvs	r1, [ip, -r5, lsl #8]
     790:	054a0905 	strbeq	r0, [sl, #-2309]	; 0xfffff6fb
     794:	17056912 	smladne	r5, r2, r9, r6
     798:	4a05054a 	bmi	141cc8 <_bss_end+0x135e64>
     79c:	054c0f05 	strbeq	r0, [ip, #-3845]	; 0xfffff0fb
     7a0:	1f054b16 	svcne	0x00054b16
     7a4:	2e14054a 	cfmac32cs	mvfx0, mvfx4, mvfx10
     7a8:	024c0105 	subeq	r0, ip, #1073741825	; 0x40000001
     7ac:	01010006 	tsteq	r1, r6
     7b0:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
     7b4:	008dac02 	addeq	sl, sp, r2, lsl #24
     7b8:	00c00300 	sbceq	r0, r0, r0, lsl #6
     7bc:	83130501 	tsthi	r3, #4194304	; 0x400000
     7c0:	02670105 	rsbeq	r0, r7, #1073741825	; 0x40000001
     7c4:	01010008 	tsteq	r1, r8
     7c8:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
     7cc:	008dd802 	addeq	sp, sp, r2, lsl #16
     7d0:	01870300 	orreq	r0, r7, r0, lsl #6
     7d4:	bb050501 	bllt	141be0 <_bss_end+0x135d7c>
     7d8:	05691005 	strbeq	r1, [r9, #-5]!
     7dc:	10054c05 	andne	r4, r5, r5, lsl #24
     7e0:	4d120584 	cfldr32mi	mvfx0, [r2, #-528]	; 0xfffffdf0
     7e4:	054c0e05 	strbeq	r0, [ip, #-3589]	; 0xfffff1fb
     7e8:	1105840b 	tstne	r5, fp, lsl #8
     7ec:	63050583 	movwvs	r0, #21891	; 0x5583
     7f0:	05340c05 	ldreq	r0, [r4, #-3077]!	; 0xfffff3fb
     7f4:	08022f01 	stmdaeq	r2, {r0, r8, r9, sl, fp, sp}
     7f8:	05010100 	streq	r0, [r1, #-256]	; 0xffffff00
     7fc:	02050001 	andeq	r0, r5, #1
     800:	00008e68 	andeq	r8, r0, r8, ror #28
     804:	01019e03 	tsteq	r1, r3, lsl #28
     808:	05bb0505 	ldreq	r0, [fp, #1285]!	; 0x505
     80c:	05056910 	streq	r6, [r5, #-2320]	; 0xfffff6f0
     810:	8410054c 	ldrhi	r0, [r0], #-1356	; 0xfffffab4
     814:	054c0e05 	strbeq	r0, [ip, #-3589]	; 0xfffff1fb
     818:	0505840b 	streq	r8, [r5, #-1035]	; 0xfffffbf5
     81c:	330c0580 	movwcc	r0, #50560	; 0xc580
     820:	022f0105 	eoreq	r0, pc, #1073741825	; 0x40000001
     824:	01010008 	tsteq	r1, r8
     828:	000001f6 	strdeq	r0, [r0], -r6
     82c:	01560003 	cmpeq	r6, r3
     830:	01020000 	mrseq	r0, (UNDEF: 2)
     834:	000d0efb 	strdeq	r0, [sp], -fp
     838:	01010101 	tsteq	r1, r1, lsl #2
     83c:	01000000 	mrseq	r0, (UNDEF: 0)
     840:	2f010000 	svccs	0x00010000
     844:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     848:	6c69732f 	stclvs	3, cr7, [r9], #-188	; 0xffffff44
     84c:	79766168 	ldmdbvc	r6!, {r3, r5, r6, r8, sp, lr}^
     850:	63532f6a 	cmpvs	r3, #424	; 0x1a8
     854:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; 6bc <CPSR_IRQ_INHIBIT+0x63c>
     858:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
     85c:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
     860:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
     864:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
     868:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
     86c:	6f632d33 	svcvs	0x00632d33
     870:	7865746e 	stmdavc	r5!, {r1, r2, r3, r5, r6, sl, ip, sp, lr}^
     874:	77735f74 			; <UNDEFINED> instruction: 0x77735f74
     878:	68637469 	stmdavs	r3!, {r0, r3, r5, r6, sl, ip, sp, lr}^
     87c:	6e6f6d5f 	mcrvs	13, 3, r6, cr15, cr15, {2}
     880:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
     884:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
     888:	2f6c656e 	svccs	0x006c656e
     88c:	2f637273 	svccs	0x00637273
     890:	76697264 	strbtvc	r7, [r9], -r4, ror #4
     894:	00737265 	rsbseq	r7, r3, r5, ror #4
     898:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 7e4 <CPSR_IRQ_INHIBIT+0x764>
     89c:	69732f65 	ldmdbvs	r3!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
     8a0:	7661686c 	strbtvc	r6, [r1], -ip, ror #16
     8a4:	532f6a79 			; <UNDEFINED> instruction: 0x532f6a79
     8a8:	6f6f6863 	svcvs	0x006f6863
     8ac:	655a2f6c 	ldrbvs	r2, [sl, #-3948]	; 0xfffff094
     8b0:	614d6f72 	hvcvs	55026	; 0xd6f2
     8b4:	652f6574 	strvs	r6, [pc, #-1396]!	; 348 <CPSR_IRQ_INHIBIT+0x2c8>
     8b8:	706d6178 	rsbvc	r6, sp, r8, ror r1
     8bc:	2f73656c 	svccs	0x0073656c
     8c0:	632d3331 			; <UNDEFINED> instruction: 0x632d3331
     8c4:	65746e6f 	ldrbvs	r6, [r4, #-3695]!	; 0xfffff191
     8c8:	735f7478 	cmpvc	pc, #120, 8	; 0x78000000
     8cc:	63746977 	cmnvs	r4, #1949696	; 0x1dc000
     8d0:	6f6d5f68 	svcvs	0x006d5f68
     8d4:	6f74696e 	svcvs	0x0074696e
     8d8:	656b2f72 	strbvs	r2, [fp, #-3954]!	; 0xfffff08e
     8dc:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
     8e0:	636e692f 	cmnvs	lr, #770048	; 0xbc000
     8e4:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
     8e8:	616f622f 	cmnvs	pc, pc, lsr #4
     8ec:	722f6472 	eorvc	r6, pc, #1912602624	; 0x72000000
     8f0:	2f306970 	svccs	0x00306970
     8f4:	006c6168 	rsbeq	r6, ip, r8, ror #2
     8f8:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 844 <CPSR_IRQ_INHIBIT+0x7c4>
     8fc:	69732f65 	ldmdbvs	r3!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
     900:	7661686c 	strbtvc	r6, [r1], -ip, ror #16
     904:	532f6a79 			; <UNDEFINED> instruction: 0x532f6a79
     908:	6f6f6863 	svcvs	0x006f6863
     90c:	655a2f6c 	ldrbvs	r2, [sl, #-3948]	; 0xfffff094
     910:	614d6f72 	hvcvs	55026	; 0xd6f2
     914:	652f6574 	strvs	r6, [pc, #-1396]!	; 3a8 <CPSR_IRQ_INHIBIT+0x328>
     918:	706d6178 	rsbvc	r6, sp, r8, ror r1
     91c:	2f73656c 	svccs	0x0073656c
     920:	632d3331 			; <UNDEFINED> instruction: 0x632d3331
     924:	65746e6f 	ldrbvs	r6, [r4, #-3695]!	; 0xfffff191
     928:	735f7478 	cmpvc	pc, #120, 8	; 0x78000000
     92c:	63746977 	cmnvs	r4, #1949696	; 0x1dc000
     930:	6f6d5f68 	svcvs	0x006d5f68
     934:	6f74696e 	svcvs	0x0074696e
     938:	656b2f72 	strbvs	r2, [fp, #-3954]!	; 0xfffff08e
     93c:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
     940:	636e692f 	cmnvs	lr, #770048	; 0xbc000
     944:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
     948:	6972642f 	ldmdbvs	r2!, {r0, r1, r2, r3, r5, sl, sp, lr}^
     94c:	73726576 	cmnvc	r2, #494927872	; 0x1d800000
     950:	69740000 	ldmdbvs	r4!, {}^	; <UNPREDICTABLE>
     954:	2e72656d 	cdpcs	5, 7, cr6, cr2, cr13, {3}
     958:	00707063 	rsbseq	r7, r0, r3, rrx
     95c:	69000001 	stmdbvs	r0, {r0}
     960:	6564746e 	strbvs	r7, [r4, #-1134]!	; 0xfffffb92
     964:	00682e66 	rsbeq	r2, r8, r6, ror #28
     968:	70000002 	andvc	r0, r0, r2
     96c:	70697265 	rsbvc	r7, r9, r5, ror #4
     970:	61726568 	cmnvs	r2, r8, ror #10
     974:	682e736c 	stmdavs	lr!, {r2, r3, r5, r6, r8, r9, ip, sp, lr}
     978:	00000200 	andeq	r0, r0, r0, lsl #4
     97c:	656d6974 	strbvs	r6, [sp, #-2420]!	; 0xfffff68c
     980:	00682e72 	rsbeq	r2, r8, r2, ror lr
     984:	00000003 	andeq	r0, r0, r3
     988:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
     98c:	008ee402 	addeq	lr, lr, r2, lsl #8
     990:	01190300 	tsteq	r9, r0, lsl #6
     994:	059f1305 	ldreq	r1, [pc, #773]	; ca1 <CPSR_IRQ_INHIBIT+0xc21>
     998:	01052e56 	tsteq	r5, r6, asr lr
     99c:	0c05a1a1 	stfeqd	f2, [r5], {161}	; 0xa1
     9a0:	4a18059f 	bmi	602024 <_bss_end+0x5f61c0>
     9a4:	052e3605 	streq	r3, [lr, #-1541]!	; 0xfffff9fb
     9a8:	05854b01 	streq	r4, [r5, #2817]	; 0xb01
     9ac:	2005d71e 	andcs	sp, r5, lr, lsl r7
     9b0:	4d150582 	cfldr32mi	mvfx0, [r5, #-520]	; 0xfffffdf8
     9b4:	05671b05 	strbeq	r1, [r7, #-2821]!	; 0xfffff4fb
     9b8:	15056717 	strne	r6, [r5, #-1815]	; 0xfffff8e9
     9bc:	66130567 	ldrvs	r0, [r3], -r7, ror #10
     9c0:	05d84605 	ldrbeq	r4, [r8, #1541]	; 0x605
     9c4:	25052e21 	strcs	r2, [r5, #-3617]	; 0xfffff1df
     9c8:	2e230582 	cfsh64cs	mvdx0, mvdx3, #-62
     9cc:	82250530 	eorhi	r0, r5, #48, 10	; 0xc000000
     9d0:	054c0f05 	strbeq	r0, [ip, #-3845]	; 0xfffff0fb
     9d4:	05696701 	strbeq	r6, [r9, #-1793]!	; 0xfffff8ff
     9d8:	1b05836f 	blne	16179c <_bss_end+0x155938>
     9dc:	83170584 	tsthi	r7, #132, 10	; 0x21000000
     9e0:	69830105 	stmibvs	r3, {r0, r2, r8}
     9e4:	05832305 	streq	r2, [r3, #773]	; 0x305
     9e8:	09058225 	stmdbeq	r5, {r0, r2, r5, r9, pc}
     9ec:	4a05054c 	bmi	141f24 <_bss_end+0x1360c0>
     9f0:	054b0905 	strbeq	r0, [fp, #-2309]	; 0xfffff6fb
     9f4:	01054a12 	tsteq	r5, r2, lsl sl
     9f8:	2b05692f 	blcs	15aebc <_bss_end+0x14f058>
     9fc:	82100583 	andshi	r0, r0, #549453824	; 0x20c00000
     a00:	052e2b05 	streq	r2, [lr, #-2821]!	; 0xfffff4fb
     a04:	9e668301 	cdpls	3, 6, cr8, cr6, cr1, {0}
     a08:	01040200 	mrseq	r0, R12_usr
     a0c:	1e056606 	cfmadd32ne	mvax0, mvfx6, mvfx5, mvfx6
     a10:	7fbb0306 	svcvc	0x00bb0306
     a14:	03010582 	movweq	r0, #5506	; 0x1582
     a18:	ba6600c5 	blt	1980d34 <_bss_end+0x1974ed0>
     a1c:	000a024a 	andeq	r0, sl, sl, asr #4
     a20:	026f0101 	rsbeq	r0, pc, #1073741824	; 0x40000000
     a24:	00030000 	andeq	r0, r3, r0
     a28:	000001c8 	andeq	r0, r0, r8, asr #3
     a2c:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
     a30:	0101000d 	tsteq	r1, sp
     a34:	00000101 	andeq	r0, r0, r1, lsl #2
     a38:	00000100 	andeq	r0, r0, r0, lsl #2
     a3c:	6f682f01 	svcvs	0x00682f01
     a40:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
     a44:	61686c69 	cmnvs	r8, r9, ror #24
     a48:	2f6a7976 	svccs	0x006a7976
     a4c:	6f686353 	svcvs	0x00686353
     a50:	5a2f6c6f 	bpl	bdbc14 <_bss_end+0xbcfdb0>
     a54:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 8c8 <CPSR_IRQ_INHIBIT+0x848>
     a58:	2f657461 	svccs	0x00657461
     a5c:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
     a60:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
     a64:	2d33312f 	ldfcss	f3, [r3, #-188]!	; 0xffffff44
     a68:	746e6f63 	strbtvc	r6, [lr], #-3939	; 0xfffff09d
     a6c:	5f747865 	svcpl	0x00747865
     a70:	74697773 	strbtvc	r7, [r9], #-1907	; 0xfffff88d
     a74:	6d5f6863 	ldclvs	8, cr6, [pc, #-396]	; 8f0 <CPSR_IRQ_INHIBIT+0x870>
     a78:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
     a7c:	6b2f726f 	blvs	bdd440 <_bss_end+0xbd15dc>
     a80:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
     a84:	72732f6c 	rsbsvc	r2, r3, #108, 30	; 0x1b0
     a88:	682f0063 	stmdavs	pc!, {r0, r1, r5, r6}	; <UNPREDICTABLE>
     a8c:	2f656d6f 	svccs	0x00656d6f
     a90:	686c6973 	stmdavs	ip!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
     a94:	6a797661 	bvs	1e5e420 <_bss_end+0x1e525bc>
     a98:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
     a9c:	2f6c6f6f 	svccs	0x006c6f6f
     aa0:	6f72655a 	svcvs	0x0072655a
     aa4:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
     aa8:	6178652f 	cmnvs	r8, pc, lsr #10
     aac:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
     ab0:	33312f73 	teqcc	r1, #460	; 0x1cc
     ab4:	6e6f632d 	cdpvs	3, 6, cr6, cr15, cr13, {1}
     ab8:	74786574 	ldrbtvc	r6, [r8], #-1396	; 0xfffffa8c
     abc:	6977735f 	ldmdbvs	r7!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, sp, lr}^
     ac0:	5f686374 	svcpl	0x00686374
     ac4:	696e6f6d 	stmdbvs	lr!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
     ac8:	2f726f74 	svccs	0x00726f74
     acc:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
     ad0:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
     ad4:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
     ad8:	622f6564 	eorvs	r6, pc, #100, 10	; 0x19000000
     adc:	6472616f 	ldrbtvs	r6, [r2], #-367	; 0xfffffe91
     ae0:	6970722f 	ldmdbvs	r0!, {r0, r1, r2, r3, r5, r9, ip, sp, lr}^
     ae4:	61682f30 	cmnvs	r8, r0, lsr pc
     ae8:	682f006c 	stmdavs	pc!, {r2, r3, r5, r6}	; <UNPREDICTABLE>
     aec:	2f656d6f 	svccs	0x00656d6f
     af0:	686c6973 	stmdavs	ip!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
     af4:	6a797661 	bvs	1e5e480 <_bss_end+0x1e5261c>
     af8:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
     afc:	2f6c6f6f 	svccs	0x006c6f6f
     b00:	6f72655a 	svcvs	0x0072655a
     b04:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
     b08:	6178652f 	cmnvs	r8, pc, lsr #10
     b0c:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
     b10:	33312f73 	teqcc	r1, #460	; 0x1cc
     b14:	6e6f632d 	cdpvs	3, 6, cr6, cr15, cr13, {1}
     b18:	74786574 	ldrbtvc	r6, [r8], #-1396	; 0xfffffa8c
     b1c:	6977735f 	ldmdbvs	r7!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, sp, lr}^
     b20:	5f686374 	svcpl	0x00686374
     b24:	696e6f6d 	stmdbvs	lr!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
     b28:	2f726f74 	svccs	0x00726f74
     b2c:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
     b30:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
     b34:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
     b38:	2f006564 	svccs	0x00006564
     b3c:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     b40:	6c69732f 	stclvs	3, cr7, [r9], #-188	; 0xffffff44
     b44:	79766168 	ldmdbvc	r6!, {r3, r5, r6, r8, sp, lr}^
     b48:	63532f6a 	cmpvs	r3, #424	; 0x1a8
     b4c:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; 9b4 <CPSR_IRQ_INHIBIT+0x934>
     b50:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
     b54:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
     b58:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
     b5c:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
     b60:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
     b64:	6f632d33 	svcvs	0x00632d33
     b68:	7865746e 	stmdavc	r5!, {r1, r2, r3, r5, r6, sl, ip, sp, lr}^
     b6c:	77735f74 			; <UNDEFINED> instruction: 0x77735f74
     b70:	68637469 	stmdavs	r3!, {r0, r3, r5, r6, sl, ip, sp, lr}^
     b74:	6e6f6d5f 	mcrvs	13, 3, r6, cr15, cr15, {2}
     b78:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
     b7c:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
     b80:	2f6c656e 	svccs	0x006c656e
     b84:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
     b88:	2f656475 	svccs	0x00656475
     b8c:	76697264 	strbtvc	r7, [r9], -r4, ror #4
     b90:	00737265 	rsbseq	r7, r3, r5, ror #4
     b94:	746e6900 	strbtvc	r6, [lr], #-2304	; 0xfffff700
     b98:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
     b9c:	635f7470 	cmpvs	pc, #112, 8	; 0x70000000
     ba0:	72746e6f 	rsbsvc	r6, r4, #1776	; 0x6f0
     ba4:	656c6c6f 	strbvs	r6, [ip, #-3183]!	; 0xfffff391
     ba8:	70632e72 	rsbvc	r2, r3, r2, ror lr
     bac:	00010070 	andeq	r0, r1, r0, ror r0
     bb0:	746e6900 	strbtvc	r6, [lr], #-2304	; 0xfffff700
     bb4:	2e666564 	cdpcs	5, 6, cr6, cr6, cr4, {3}
     bb8:	00020068 	andeq	r0, r2, r8, rrx
     bbc:	72657000 	rsbvc	r7, r5, #0
     bc0:	65687069 	strbvs	r7, [r8, #-105]!	; 0xffffff97
     bc4:	736c6172 	cmnvc	ip, #-2147483620	; 0x8000001c
     bc8:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
     bcc:	6e690000 	cdpvs	0, 6, cr0, cr9, cr0, {0}
     bd0:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
     bd4:	5f747075 	svcpl	0x00747075
     bd8:	746e6f63 	strbtvc	r6, [lr], #-3939	; 0xfffff09d
     bdc:	6c6c6f72 	stclvs	15, cr6, [ip], #-456	; 0xfffffe38
     be0:	682e7265 	stmdavs	lr!, {r0, r2, r5, r6, r9, ip, sp, lr}
     be4:	00000300 	andeq	r0, r0, r0, lsl #6
     be8:	656d6974 	strbvs	r6, [sp, #-2420]!	; 0xfffff68c
     bec:	00682e72 	rsbeq	r2, r8, r2, ror lr
     bf0:	00000004 	andeq	r0, r0, r4
     bf4:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
     bf8:	00917402 	addseq	r7, r1, r2, lsl #8
     bfc:	010b0300 	mrseq	r0, (UNDEF: 59)
     c00:	2405854c 	strcs	r8, [r5], #-1356	; 0xfffffab4
     c04:	6605054f 	strvs	r0, [r5], -pc, asr #10
     c08:	054b1c05 	strbeq	r1, [fp, #-3077]	; 0xfffff3fb
     c0c:	30694b01 	rsbcc	r4, r9, r1, lsl #22
     c10:	9f17056a 	svcls	0x0017056a
     c14:	052e3c05 	streq	r3, [lr, #-3077]!	; 0xfffff3fb
     c18:	05a14d01 	streq	r4, [r1, #3329]!	; 0xd01
     c1c:	1c059f0c 	stcne	15, cr9, [r5], {12}
     c20:	2e3a054a 	cdpcs	5, 3, cr0, cr10, cr10, {2}
     c24:	854b0105 	strbhi	r0, [fp, #-261]	; 0xfffffefb
     c28:	059f4305 	ldreq	r4, [pc, #773]	; f35 <CPSR_IRQ_INHIBIT+0xeb5>
     c2c:	39052e40 	stmdbcc	r5, {r6, r9, sl, fp, sp}
     c30:	8240054a 	subhi	r0, r0, #310378496	; 0x12800000
     c34:	052e3b05 	streq	r3, [lr, #-2821]!	; 0xfffff4fb
     c38:	05692f01 	strbeq	r2, [r9, #-3841]!	; 0xfffff0ff
     c3c:	41059f44 	tstmi	r5, r4, asr #30
     c40:	4a3a052e 	bmi	e82100 <_bss_end+0xe7629c>
     c44:	05824105 	streq	r4, [r2, #261]	; 0x105
     c48:	01052e3c 	tsteq	r5, ip, lsr lr
     c4c:	1805692f 	stmdane	r5, {r0, r1, r2, r3, r5, r8, fp, sp, lr}
     c50:	0187059f 			; <UNDEFINED> instruction: 0x0187059f
     c54:	4a7a054c 	bmi	1e8218c <_bss_end+0x1e76328>
     c58:	054a7305 	strbeq	r7, [sl, #-773]	; 0xfffffcfb
     c5c:	7505827a 	strvc	r8, [r5, #-634]	; 0xfffffd86
     c60:	2f01052e 	svccs	0x0001052e
     c64:	9f180569 	svcls	0x00180569
     c68:	4c018905 			; <UNDEFINED> instruction: 0x4c018905
     c6c:	054a7c05 	strbeq	r7, [sl, #-3077]	; 0xfffff3fb
     c70:	7c054a75 			; <UNDEFINED> instruction: 0x7c054a75
     c74:	2e770582 	cdpcs	5, 7, cr0, cr7, cr2, {4}
     c78:	662f0105 	strtvs	r0, [pc], -r5, lsl #2
     c7c:	0402009e 	streq	r0, [r2], #-158	; 0xffffff62
     c80:	05660601 	strbeq	r0, [r6, #-1537]!	; 0xfffff9ff
     c84:	45030643 	strmi	r0, [r3, #-1603]	; 0xfffff9bd
     c88:	03010582 	movweq	r0, #5506	; 0x1582
     c8c:	4aba663b 	bmi	fee9a580 <_bss_end+0xfee8e71c>
     c90:	01000a02 	tsteq	r0, r2, lsl #20
     c94:	0003cd01 	andeq	ip, r3, r1, lsl #26
     c98:	bf000300 	svclt	0x00000300
     c9c:	02000002 	andeq	r0, r0, #2
     ca0:	0d0efb01 	vstreq	d15, [lr, #-4]
     ca4:	01010100 	mrseq	r0, (UNDEF: 17)
     ca8:	00000001 	andeq	r0, r0, r1
     cac:	01000001 	tsteq	r0, r1
     cb0:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; bfc <CPSR_IRQ_INHIBIT+0xb7c>
     cb4:	69732f65 	ldmdbvs	r3!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
     cb8:	7661686c 	strbtvc	r6, [r1], -ip, ror #16
     cbc:	532f6a79 			; <UNDEFINED> instruction: 0x532f6a79
     cc0:	6f6f6863 	svcvs	0x006f6863
     cc4:	655a2f6c 	ldrbvs	r2, [sl, #-3948]	; 0xfffff094
     cc8:	614d6f72 	hvcvs	55026	; 0xd6f2
     ccc:	652f6574 	strvs	r6, [pc, #-1396]!	; 760 <CPSR_IRQ_INHIBIT+0x6e0>
     cd0:	706d6178 	rsbvc	r6, sp, r8, ror r1
     cd4:	2f73656c 	svccs	0x0073656c
     cd8:	632d3331 			; <UNDEFINED> instruction: 0x632d3331
     cdc:	65746e6f 	ldrbvs	r6, [r4, #-3695]!	; 0xfffff191
     ce0:	735f7478 	cmpvc	pc, #120, 8	; 0x78000000
     ce4:	63746977 	cmnvs	r4, #1949696	; 0x1dc000
     ce8:	6f6d5f68 	svcvs	0x006d5f68
     cec:	6f74696e 	svcvs	0x0074696e
     cf0:	656b2f72 	strbvs	r2, [fp, #-3954]!	; 0xfffff08e
     cf4:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
     cf8:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
     cfc:	6f682f00 	svcvs	0x00682f00
     d00:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
     d04:	61686c69 	cmnvs	r8, r9, ror #24
     d08:	2f6a7976 	svccs	0x006a7976
     d0c:	6f686353 	svcvs	0x00686353
     d10:	5a2f6c6f 	bpl	bdbed4 <_bss_end+0xbd0070>
     d14:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; b88 <CPSR_IRQ_INHIBIT+0xb08>
     d18:	2f657461 	svccs	0x00657461
     d1c:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
     d20:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
     d24:	2d33312f 	ldfcss	f3, [r3, #-188]!	; 0xffffff44
     d28:	746e6f63 	strbtvc	r6, [lr], #-3939	; 0xfffff09d
     d2c:	5f747865 	svcpl	0x00747865
     d30:	74697773 	strbtvc	r7, [r9], #-1907	; 0xfffff88d
     d34:	6d5f6863 	ldclvs	8, cr6, [pc, #-396]	; bb0 <CPSR_IRQ_INHIBIT+0xb30>
     d38:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
     d3c:	6b2f726f 	blvs	bdd700 <_bss_end+0xbd189c>
     d40:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
     d44:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
     d48:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
     d4c:	6f622f65 	svcvs	0x00622f65
     d50:	2f647261 	svccs	0x00647261
     d54:	30697072 	rsbcc	r7, r9, r2, ror r0
     d58:	6c61682f 	stclvs	8, cr6, [r1], #-188	; 0xffffff44
     d5c:	6f682f00 	svcvs	0x00682f00
     d60:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
     d64:	61686c69 	cmnvs	r8, r9, ror #24
     d68:	2f6a7976 	svccs	0x006a7976
     d6c:	6f686353 	svcvs	0x00686353
     d70:	5a2f6c6f 	bpl	bdbf34 <_bss_end+0xbd00d0>
     d74:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; be8 <CPSR_IRQ_INHIBIT+0xb68>
     d78:	2f657461 	svccs	0x00657461
     d7c:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
     d80:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
     d84:	2d33312f 	ldfcss	f3, [r3, #-188]!	; 0xffffff44
     d88:	746e6f63 	strbtvc	r6, [lr], #-3939	; 0xfffff09d
     d8c:	5f747865 	svcpl	0x00747865
     d90:	74697773 	strbtvc	r7, [r9], #-1907	; 0xfffff88d
     d94:	6d5f6863 	ldclvs	8, cr6, [pc, #-396]	; c10 <CPSR_IRQ_INHIBIT+0xb90>
     d98:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
     d9c:	6b2f726f 	blvs	bdd760 <_bss_end+0xbd18fc>
     da0:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
     da4:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
     da8:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
     dac:	72642f65 	rsbvc	r2, r4, #404	; 0x194
     db0:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
     db4:	682f0073 	stmdavs	pc!, {r0, r1, r4, r5, r6}	; <UNPREDICTABLE>
     db8:	2f656d6f 	svccs	0x00656d6f
     dbc:	686c6973 	stmdavs	ip!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
     dc0:	6a797661 	bvs	1e5e74c <_bss_end+0x1e528e8>
     dc4:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
     dc8:	2f6c6f6f 	svccs	0x006c6f6f
     dcc:	6f72655a 	svcvs	0x0072655a
     dd0:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
     dd4:	6178652f 	cmnvs	r8, pc, lsr #10
     dd8:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
     ddc:	33312f73 	teqcc	r1, #460	; 0x1cc
     de0:	6e6f632d 	cdpvs	3, 6, cr6, cr15, cr13, {1}
     de4:	74786574 	ldrbtvc	r6, [r8], #-1396	; 0xfffffa8c
     de8:	6977735f 	ldmdbvs	r7!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, sp, lr}^
     dec:	5f686374 	svcpl	0x00686374
     df0:	696e6f6d 	stmdbvs	lr!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
     df4:	2f726f74 	svccs	0x00726f74
     df8:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
     dfc:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
     e00:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
     e04:	2f006564 	svccs	0x00006564
     e08:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     e0c:	6c69732f 	stclvs	3, cr7, [r9], #-188	; 0xffffff44
     e10:	79766168 	ldmdbvc	r6!, {r3, r5, r6, r8, sp, lr}^
     e14:	63532f6a 	cmpvs	r3, #424	; 0x1a8
     e18:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; c80 <CPSR_IRQ_INHIBIT+0xc00>
     e1c:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
     e20:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
     e24:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
     e28:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
     e2c:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
     e30:	6f632d33 	svcvs	0x00632d33
     e34:	7865746e 	stmdavc	r5!, {r1, r2, r3, r5, r6, sl, ip, sp, lr}^
     e38:	77735f74 			; <UNDEFINED> instruction: 0x77735f74
     e3c:	68637469 	stmdavs	r3!, {r0, r3, r5, r6, sl, ip, sp, lr}^
     e40:	6e6f6d5f 	mcrvs	13, 3, r6, cr15, cr15, {2}
     e44:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
     e48:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
     e4c:	2f6c656e 	svccs	0x006c656e
     e50:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
     e54:	2f656475 	svccs	0x00656475
     e58:	6f6d656d 	svcvs	0x006d656d
     e5c:	2f007972 	svccs	0x00007972
     e60:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     e64:	6c69732f 	stclvs	3, cr7, [r9], #-188	; 0xffffff44
     e68:	79766168 	ldmdbvc	r6!, {r3, r5, r6, r8, sp, lr}^
     e6c:	63532f6a 	cmpvs	r3, #424	; 0x1a8
     e70:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; cd8 <CPSR_IRQ_INHIBIT+0xc58>
     e74:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
     e78:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
     e7c:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
     e80:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
     e84:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
     e88:	6f632d33 	svcvs	0x00632d33
     e8c:	7865746e 	stmdavc	r5!, {r1, r2, r3, r5, r6, sl, ip, sp, lr}^
     e90:	77735f74 			; <UNDEFINED> instruction: 0x77735f74
     e94:	68637469 	stmdavs	r3!, {r0, r3, r5, r6, sl, ip, sp, lr}^
     e98:	6e6f6d5f 	mcrvs	13, 3, r6, cr15, cr15, {2}
     e9c:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
     ea0:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
     ea4:	2f6c656e 	svccs	0x006c656e
     ea8:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
     eac:	2f656475 	svccs	0x00656475
     eb0:	636f7270 	cmnvs	pc, #112, 4
     eb4:	00737365 	rsbseq	r7, r3, r5, ror #6
     eb8:	69616d00 	stmdbvs	r1!, {r8, sl, fp, sp, lr}^
     ebc:	70632e6e 	rsbvc	r2, r3, lr, ror #28
     ec0:	00010070 	andeq	r0, r1, r0, ror r0
     ec4:	746e6900 	strbtvc	r6, [lr], #-2304	; 0xfffff700
     ec8:	2e666564 	cdpcs	5, 6, cr6, cr6, cr4, {3}
     ecc:	00020068 	andeq	r0, r2, r8, rrx
     ed0:	69706700 	ldmdbvs	r0!, {r8, r9, sl, sp, lr}^
     ed4:	00682e6f 	rsbeq	r2, r8, pc, ror #28
     ed8:	70000003 	andvc	r0, r0, r3
     edc:	70697265 	rsbvc	r7, r9, r5, ror #4
     ee0:	61726568 	cmnvs	r2, r8, ror #10
     ee4:	682e736c 	stmdavs	lr!, {r2, r3, r5, r6, r8, r9, ip, sp, lr}
     ee8:	00000200 	andeq	r0, r0, r0, lsl #4
     eec:	656d6974 	strbvs	r6, [sp, #-2420]!	; 0xfffff68c
     ef0:	00682e72 	rsbeq	r2, r8, r2, ror lr
     ef4:	69000003 	stmdbvs	r0, {r0, r1}
     ef8:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
     efc:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
     f00:	6e6f635f 	mcrvs	3, 3, r6, cr15, cr15, {2}
     f04:	6c6f7274 	sfmvs	f7, 2, [pc], #-464	; d3c <CPSR_IRQ_INHIBIT+0xcbc>
     f08:	2e72656c 	cdpcs	5, 7, cr6, cr2, cr12, {3}
     f0c:	00040068 	andeq	r0, r4, r8, rrx
     f10:	6e6f6d00 	cdpvs	13, 6, cr6, cr15, cr0, {0}
     f14:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
     f18:	0300682e 	movweq	r6, #2094	; 0x82e
     f1c:	656d0000 	strbvs	r0, [sp, #-0]!
     f20:	70616d6d 	rsbvc	r6, r1, sp, ror #26
     f24:	0500682e 	streq	r6, [r0, #-2094]	; 0xfffff7d2
     f28:	656b0000 	strbvs	r0, [fp, #-0]!
     f2c:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
     f30:	6165685f 	cmnvs	r5, pc, asr r8
     f34:	00682e70 	rsbeq	r2, r8, r0, ror lr
     f38:	70000005 	andvc	r0, r0, r5
     f3c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     f40:	682e7373 	stmdavs	lr!, {r0, r1, r4, r5, r6, r8, r9, ip, sp, lr}
     f44:	00000600 	andeq	r0, r0, r0, lsl #12
     f48:	636f7270 	cmnvs	pc, #112, 4
     f4c:	5f737365 	svcpl	0x00737365
     f50:	616e616d 	cmnvs	lr, sp, ror #2
     f54:	2e726567 	cdpcs	5, 7, cr6, cr2, cr7, {3}
     f58:	00060068 	andeq	r0, r6, r8, rrx
     f5c:	01050000 	mrseq	r0, (UNDEF: 5)
     f60:	d0020500 	andle	r0, r2, r0, lsl #10
     f64:	03000093 	movweq	r0, #147	; 0x93
     f68:	16050117 			; <UNDEFINED> instruction: 0x16050117
     f6c:	4c12054b 	cfldr32mi	mvfx0, [r2], {75}	; 0x4b
     f70:	05d70f05 	ldrbeq	r0, [r7, #3845]	; 0xf05
     f74:	0c05660e 	stceq	6, cr6, [r5], {14}
     f78:	4b01054a 	blmi	424a8 <_bss_end+0x36644>
     f7c:	6a1c05a1 	bvs	702608 <_bss_end+0x6f67a4>
     f80:	05830a05 	streq	r0, [r3, #2565]	; 0xa05
     f84:	14054e19 	strne	r4, [r5], #-3609	; 0xfffff1e7
     f88:	2f1205a2 	svccs	0x001205a2
     f8c:	05671305 	strbeq	r1, [r7, #-773]!	; 0xfffffcfb
     f90:	1105300a 	tstne	r5, sl
     f94:	03040200 	movweq	r0, #16896	; 0x4200
     f98:	0003054a 	andeq	r0, r3, sl, asr #10
     f9c:	d6020402 	strle	r0, [r2], -r2, lsl #8
     fa0:	05850f05 	streq	r0, [r5, #3845]	; 0xf05
     fa4:	66750319 			; <UNDEFINED> instruction: 0x66750319
     fa8:	10030105 	andne	r0, r3, r5, lsl #2
     fac:	6a1c0582 	bvs	7025bc <_bss_end+0x6f6758>
     fb0:	05830a05 	streq	r0, [r3, #2565]	; 0xa05
     fb4:	14054f19 	strne	r4, [r5], #-3865	; 0xfffff0e7
     fb8:	2f0f05a0 	svccs	0x000f05a0
     fbc:	05671305 	strbeq	r1, [r7, #-773]!	; 0xfffffcfb
     fc0:	1105300a 	tstne	r5, sl
     fc4:	03040200 	movweq	r0, #16896	; 0x4200
     fc8:	0003054a 	andeq	r0, r3, sl, asr #10
     fcc:	d6020402 	strle	r0, [r2], -r2, lsl #8
     fd0:	05850f05 	streq	r0, [r5, #3845]	; 0xf05
     fd4:	66770319 			; <UNDEFINED> instruction: 0x66770319
     fd8:	0e030105 	adfeqs	f0, f3, f5
     fdc:	6a1c0582 	bvs	7025ec <_bss_end+0x6f6788>
     fe0:	05830a05 	streq	r0, [r3, #2565]	; 0xa05
     fe4:	14054f19 	strne	r4, [r5], #-3865	; 0xfffff0e7
     fe8:	2f0f05a0 	svccs	0x000f05a0
     fec:	05671305 	strbeq	r1, [r7, #-773]!	; 0xfffffcfb
     ff0:	1105300a 	tstne	r5, sl
     ff4:	03040200 	movweq	r0, #16896	; 0x4200
     ff8:	0003054a 	andeq	r0, r3, sl, asr #10
     ffc:	d6020402 	strle	r0, [r2], -r2, lsl #8
    1000:	05850f05 	streq	r0, [r5, #3845]	; 0xf05
    1004:	66770319 			; <UNDEFINED> instruction: 0x66770319
    1008:	0e030105 	adfeqs	f0, f3, f5
    100c:	6a1c0582 	bvs	70261c <_bss_end+0x6f67b8>
    1010:	05830a05 	streq	r0, [r3, #2565]	; 0xa05
    1014:	14054f19 	strne	r4, [r5], #-3865	; 0xfffff0e7
    1018:	2f0f05a0 	svccs	0x000f05a0
    101c:	05671305 	strbeq	r1, [r7, #-773]!	; 0xfffffcfb
    1020:	1105300a 	tstne	r5, sl
    1024:	03040200 	movweq	r0, #16896	; 0x4200
    1028:	0003054a 	andeq	r0, r3, sl, asr #10
    102c:	d6020402 	strle	r0, [r2], -r2, lsl #8
    1030:	05850f05 	streq	r0, [r5, #3845]	; 0xf05
    1034:	66770319 			; <UNDEFINED> instruction: 0x66770319
    1038:	0e030105 	adfeqs	f0, f3, f5
    103c:	4c190582 	cfldr32mi	mvfx0, [r9], {130}	; 0x82
    1040:	05831205 	streq	r1, [r3, #517]	; 0x205
    1044:	1c058613 	stcne	6, cr8, [r5], {19}
    1048:	1f05834c 	svcne	0x0005834c
    104c:	21058383 	smlabbcs	r5, r3, r3, r8
    1050:	690f0585 	stmdbvs	pc, {r0, r2, r7, r8, sl}	; <UNPREDICTABLE>
    1054:	05a12005 	streq	r2, [r1, #5]!
    1058:	0505680c 	streq	r6, [r5, #-2060]	; 0xfffff7f4
    105c:	01040200 	mrseq	r0, R12_usr
    1060:	00160231 	andseq	r0, r6, r1, lsr r2
    1064:	02b40101 	adcseq	r0, r4, #1073741824	; 0x40000000
    1068:	00030000 	andeq	r0, r3, r0
    106c:	00000177 	andeq	r0, r0, r7, ror r1
    1070:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
    1074:	0101000d 	tsteq	r1, sp
    1078:	00000101 	andeq	r0, r0, r1, lsl #2
    107c:	00000100 	andeq	r0, r0, r0, lsl #2
    1080:	6f682f01 	svcvs	0x00682f01
    1084:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
    1088:	61686c69 	cmnvs	r8, r9, ror #24
    108c:	2f6a7976 	svccs	0x006a7976
    1090:	6f686353 	svcvs	0x00686353
    1094:	5a2f6c6f 	bpl	bdc258 <_bss_end+0xbd03f4>
    1098:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; f0c <CPSR_IRQ_INHIBIT+0xe8c>
    109c:	2f657461 	svccs	0x00657461
    10a0:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
    10a4:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
    10a8:	2d33312f 	ldfcss	f3, [r3, #-188]!	; 0xffffff44
    10ac:	746e6f63 	strbtvc	r6, [lr], #-3939	; 0xfffff09d
    10b0:	5f747865 	svcpl	0x00747865
    10b4:	74697773 	strbtvc	r7, [r9], #-1907	; 0xfffff88d
    10b8:	6d5f6863 	ldclvs	8, cr6, [pc, #-396]	; f34 <CPSR_IRQ_INHIBIT+0xeb4>
    10bc:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
    10c0:	6b2f726f 	blvs	bdda84 <_bss_end+0xbd1c20>
    10c4:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
    10c8:	72732f6c 	rsbsvc	r2, r3, #108, 30	; 0x1b0
    10cc:	656d2f63 	strbvs	r2, [sp, #-3939]!	; 0xfffff09d
    10d0:	79726f6d 	ldmdbvc	r2!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
    10d4:	6f682f00 	svcvs	0x00682f00
    10d8:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
    10dc:	61686c69 	cmnvs	r8, r9, ror #24
    10e0:	2f6a7976 	svccs	0x006a7976
    10e4:	6f686353 	svcvs	0x00686353
    10e8:	5a2f6c6f 	bpl	bdc2ac <_bss_end+0xbd0448>
    10ec:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; f60 <CPSR_IRQ_INHIBIT+0xee0>
    10f0:	2f657461 	svccs	0x00657461
    10f4:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
    10f8:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
    10fc:	2d33312f 	ldfcss	f3, [r3, #-188]!	; 0xffffff44
    1100:	746e6f63 	strbtvc	r6, [lr], #-3939	; 0xfffff09d
    1104:	5f747865 	svcpl	0x00747865
    1108:	74697773 	strbtvc	r7, [r9], #-1907	; 0xfffff88d
    110c:	6d5f6863 	ldclvs	8, cr6, [pc, #-396]	; f88 <CPSR_IRQ_INHIBIT+0xf08>
    1110:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
    1114:	6b2f726f 	blvs	bddad8 <_bss_end+0xbd1c74>
    1118:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
    111c:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
    1120:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
    1124:	6f622f65 	svcvs	0x00622f65
    1128:	2f647261 	svccs	0x00647261
    112c:	30697072 	rsbcc	r7, r9, r2, ror r0
    1130:	6c61682f 	stclvs	8, cr6, [r1], #-188	; 0xffffff44
    1134:	6f682f00 	svcvs	0x00682f00
    1138:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
    113c:	61686c69 	cmnvs	r8, r9, ror #24
    1140:	2f6a7976 	svccs	0x006a7976
    1144:	6f686353 	svcvs	0x00686353
    1148:	5a2f6c6f 	bpl	bdc30c <_bss_end+0xbd04a8>
    114c:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; fc0 <CPSR_IRQ_INHIBIT+0xf40>
    1150:	2f657461 	svccs	0x00657461
    1154:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
    1158:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
    115c:	2d33312f 	ldfcss	f3, [r3, #-188]!	; 0xffffff44
    1160:	746e6f63 	strbtvc	r6, [lr], #-3939	; 0xfffff09d
    1164:	5f747865 	svcpl	0x00747865
    1168:	74697773 	strbtvc	r7, [r9], #-1907	; 0xfffff88d
    116c:	6d5f6863 	ldclvs	8, cr6, [pc, #-396]	; fe8 <CPSR_IRQ_INHIBIT+0xf68>
    1170:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
    1174:	6b2f726f 	blvs	bddb38 <_bss_end+0xbd1cd4>
    1178:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
    117c:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
    1180:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
    1184:	656d2f65 	strbvs	r2, [sp, #-3941]!	; 0xfffff09b
    1188:	79726f6d 	ldmdbvc	r2!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
    118c:	656b0000 	strbvs	r0, [fp, #-0]!
    1190:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
    1194:	6165685f 	cmnvs	r5, pc, asr r8
    1198:	70632e70 	rsbvc	r2, r3, r0, ror lr
    119c:	00010070 	andeq	r0, r1, r0, ror r0
    11a0:	746e6900 	strbtvc	r6, [lr], #-2304	; 0xfffff700
    11a4:	2e666564 	cdpcs	5, 6, cr6, cr6, cr4, {3}
    11a8:	00020068 	andeq	r0, r2, r8, rrx
    11ac:	72656b00 	rsbvc	r6, r5, #0, 22
    11b0:	5f6c656e 	svcpl	0x006c656e
    11b4:	70616568 	rsbvc	r6, r1, r8, ror #10
    11b8:	0300682e 	movweq	r6, #2094	; 0x82e
    11bc:	65700000 	ldrbvs	r0, [r0, #-0]!
    11c0:	68706972 	ldmdavs	r0!, {r1, r4, r5, r6, r8, fp, sp, lr}^
    11c4:	6c617265 	sfmvs	f7, 2, [r1], #-404	; 0xfffffe6c
    11c8:	00682e73 	rsbeq	r2, r8, r3, ror lr
    11cc:	6d000002 	stcvs	0, cr0, [r0, #-8]
    11d0:	616d6d65 	cmnvs	sp, r5, ror #26
    11d4:	00682e70 	rsbeq	r2, r8, r0, ror lr
    11d8:	70000003 	andvc	r0, r0, r3
    11dc:	73656761 	cmnvc	r5, #25427968	; 0x1840000
    11e0:	0300682e 	movweq	r6, #2094	; 0x82e
    11e4:	05000000 	streq	r0, [r0, #-0]
    11e8:	02050001 	andeq	r0, r5, #1
    11ec:	00009768 	andeq	r9, r0, r8, ror #14
    11f0:	851d0517 	ldrhi	r0, [sp, #-1303]	; 0xfffffae9
    11f4:	05660c05 	strbeq	r0, [r6, #-3077]!	; 0xfffff3fb
    11f8:	05854b01 	streq	r4, [r5, #2817]	; 0xb01
    11fc:	6f05836d 	svcvs	0x0005836d
    1200:	2f110566 	svccs	0x00110566
    1204:	14056767 	strne	r6, [r5], #-1895	; 0xfffff899
    1208:	680c0567 	stmdavs	ip, {r0, r1, r2, r5, r6, r8, sl}
    120c:	a12f0105 			; <UNDEFINED> instruction: 0xa12f0105
    1210:	059f2005 	ldreq	r2, [pc, #5]	; 121d <CPSR_IRQ_INHIBIT+0x119d>
    1214:	2905691d 	stmdbcs	r5, {r0, r2, r3, r4, r8, fp, sp, lr}
    1218:	01040200 	mrseq	r0, R12_usr
    121c:	001d0566 	andseq	r0, sp, r6, ror #10
    1220:	4a010402 	bmi	42230 <_bss_end+0x363cc>
    1224:	02003b05 	andeq	r3, r0, #5120	; 0x1400
    1228:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
    122c:	04020031 	streq	r0, [r2], #-49	; 0xffffffcf
    1230:	0f054a02 	svceq	0x00054a02
    1234:	64050568 	strvs	r0, [r5], #-1384	; 0xfffffa98
    1238:	6a100533 	bvs	40270c <_bss_end+0x3f68a8>
    123c:	4a05054f 	bmi	142780 <_bss_end+0x13691c>
    1240:	02002705 	andeq	r2, r0, #1310720	; 0x140000
    1244:	05660104 	strbeq	r0, [r6, #-260]!	; 0xfffffefc
    1248:	04020058 	streq	r0, [r2], #-88	; 0xffffffa8
    124c:	1d054a01 	vstrne	s8, [r5, #-4]
    1250:	01040200 	mrseq	r0, R12_usr
    1254:	4c18054a 	cfldr32mi	mvfx0, [r8], {74}	; 0x4a
    1258:	05675405 	strbeq	r5, [r7, #-1029]!	; 0xfffffbfb
    125c:	056c019a 	strbeq	r0, [ip, #-410]!	; 0xfffffe66
    1260:	19054a20 	stmdbne	r5, {r5, r9, fp, lr}
    1264:	4a1e0568 	bmi	78280c <_bss_end+0x7769a8>
    1268:	054a2505 	strbeq	r2, [sl, #-1285]	; 0xfffffafb
    126c:	054c2e10 	strbeq	r2, [ip, #-3600]	; 0xfffff1f0
    1270:	10056719 	andne	r6, r5, r9, lsl r7
    1274:	4b13054a 	blmi	4c27a4 <_bss_end+0x4b6940>
    1278:	68671105 	stmdavs	r7!, {r0, r2, r8, ip}^
    127c:	05671405 	strbeq	r1, [r7, #-1029]!	; 0xfffffbfb
    1280:	01056850 	tsteq	r5, r0, asr r8
    1284:	2005854b 	andcs	r8, r5, fp, asr #10
    1288:	6814059f 	ldmdavs	r4, {r0, r1, r2, r3, r4, r7, r8, sl}
    128c:	05691005 	strbeq	r1, [r9, #-5]!
    1290:	1f054a05 	svcne	0x00054a05
    1294:	01040200 	mrseq	r0, R12_usr
    1298:	0025054a 	eoreq	r0, r5, sl, asr #10
    129c:	4a010402 	bmi	422ac <_bss_end+0x36448>
    12a0:	02001505 	andeq	r1, r0, #20971520	; 0x1400000
    12a4:	4c2e0104 	stfmis	f0, [lr], #-16
    12a8:	054a1f05 	strbeq	r1, [sl, #-3845]	; 0xfffff0fb
    12ac:	15054a25 	strne	r4, [r5, #-2597]	; 0xfffff5db
    12b0:	831e052e 	tsthi	lr, #192937984	; 0xb800000
    12b4:	054a2405 	strbeq	r2, [sl, #-1029]	; 0xfffffbfb
    12b8:	10052e15 	andne	r2, r5, r5, lsl lr
    12bc:	4a1b054b 	bmi	6c27f0 <_bss_end+0x6b698c>
    12c0:	054e1005 	strbeq	r1, [lr, #-5]
    12c4:	1f054a05 	svcne	0x00054a05
    12c8:	01040200 	mrseq	r0, R12_usr
    12cc:	0025054a 	eoreq	r0, r5, sl, asr #10
    12d0:	4a010402 	bmi	422e0 <_bss_end+0x3647c>
    12d4:	02001505 	andeq	r1, r0, #20971520	; 0x1400000
    12d8:	052e0104 	streq	r0, [lr, #-260]!	; 0xfffffefc
    12dc:	1b054c10 	blne	154324 <_bss_end+0x1484c0>
    12e0:	2e25054a 	cfsh64cs	mvdx0, mvdx5, #42
    12e4:	054a1b05 	strbeq	r1, [sl, #-2821]	; 0xfffff4fb
    12e8:	1b052e10 	blne	14cb30 <_bss_end+0x140ccc>
    12ec:	4b10054a 	blmi	40281c <_bss_end+0x3f69b8>
    12f0:	054a2405 	strbeq	r2, [sl, #-1029]	; 0xfffffbfb
    12f4:	10054a1b 	andne	r4, r5, fp, lsl sl
    12f8:	4a24052f 	bmi	9027bc <_bss_end+0x8f6958>
    12fc:	054a1b05 	strbeq	r1, [sl, #-2821]	; 0xfffff4fb
    1300:	9e823001 	cdpls	0, 8, cr3, cr2, cr1, {0}
    1304:	01040200 	mrseq	r0, R12_usr
    1308:	16056606 	strne	r6, [r5], -r6, lsl #12
    130c:	7fad0306 	svcvc	0x00ad0306
    1310:	03010582 	movweq	r0, #5506	; 0x1582
    1314:	9e4a00d3 	mcrls	0, 2, r0, cr10, cr3, {6}
    1318:	000a024a 	andeq	r0, sl, sl, asr #4
    131c:	03150101 	tsteq	r5, #1073741824	; 0x40000000
    1320:	00030000 	andeq	r0, r3, r0
    1324:	000001c6 	andeq	r0, r0, r6, asr #3
    1328:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
    132c:	0101000d 	tsteq	r1, sp
    1330:	00000101 	andeq	r0, r0, r1, lsl #2
    1334:	00000100 	andeq	r0, r0, r0, lsl #2
    1338:	6f682f01 	svcvs	0x00682f01
    133c:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
    1340:	61686c69 	cmnvs	r8, r9, ror #24
    1344:	2f6a7976 	svccs	0x006a7976
    1348:	6f686353 	svcvs	0x00686353
    134c:	5a2f6c6f 	bpl	bdc510 <_bss_end+0xbd06ac>
    1350:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 11c4 <CPSR_IRQ_INHIBIT+0x1144>
    1354:	2f657461 	svccs	0x00657461
    1358:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
    135c:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
    1360:	2d33312f 	ldfcss	f3, [r3, #-188]!	; 0xffffff44
    1364:	746e6f63 	strbtvc	r6, [lr], #-3939	; 0xfffff09d
    1368:	5f747865 	svcpl	0x00747865
    136c:	74697773 	strbtvc	r7, [r9], #-1907	; 0xfffff88d
    1370:	6d5f6863 	ldclvs	8, cr6, [pc, #-396]	; 11ec <CPSR_IRQ_INHIBIT+0x116c>
    1374:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
    1378:	6b2f726f 	blvs	bddd3c <_bss_end+0xbd1ed8>
    137c:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
    1380:	72732f6c 	rsbsvc	r2, r3, #108, 30	; 0x1b0
    1384:	656d2f63 	strbvs	r2, [sp, #-3939]!	; 0xfffff09d
    1388:	79726f6d 	ldmdbvc	r2!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
    138c:	6f682f00 	svcvs	0x00682f00
    1390:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
    1394:	61686c69 	cmnvs	r8, r9, ror #24
    1398:	2f6a7976 	svccs	0x006a7976
    139c:	6f686353 	svcvs	0x00686353
    13a0:	5a2f6c6f 	bpl	bdc564 <_bss_end+0xbd0700>
    13a4:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 1218 <CPSR_IRQ_INHIBIT+0x1198>
    13a8:	2f657461 	svccs	0x00657461
    13ac:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
    13b0:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
    13b4:	2d33312f 	ldfcss	f3, [r3, #-188]!	; 0xffffff44
    13b8:	746e6f63 	strbtvc	r6, [lr], #-3939	; 0xfffff09d
    13bc:	5f747865 	svcpl	0x00747865
    13c0:	74697773 	strbtvc	r7, [r9], #-1907	; 0xfffff88d
    13c4:	6d5f6863 	ldclvs	8, cr6, [pc, #-396]	; 1240 <CPSR_IRQ_INHIBIT+0x11c0>
    13c8:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
    13cc:	6b2f726f 	blvs	bddd90 <_bss_end+0xbd1f2c>
    13d0:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
    13d4:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
    13d8:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
    13dc:	6f622f65 	svcvs	0x00622f65
    13e0:	2f647261 	svccs	0x00647261
    13e4:	30697072 	rsbcc	r7, r9, r2, ror r0
    13e8:	6c61682f 	stclvs	8, cr6, [r1], #-188	; 0xffffff44
    13ec:	6f682f00 	svcvs	0x00682f00
    13f0:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
    13f4:	61686c69 	cmnvs	r8, r9, ror #24
    13f8:	2f6a7976 	svccs	0x006a7976
    13fc:	6f686353 	svcvs	0x00686353
    1400:	5a2f6c6f 	bpl	bdc5c4 <_bss_end+0xbd0760>
    1404:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 1278 <CPSR_IRQ_INHIBIT+0x11f8>
    1408:	2f657461 	svccs	0x00657461
    140c:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
    1410:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
    1414:	2d33312f 	ldfcss	f3, [r3, #-188]!	; 0xffffff44
    1418:	746e6f63 	strbtvc	r6, [lr], #-3939	; 0xfffff09d
    141c:	5f747865 	svcpl	0x00747865
    1420:	74697773 	strbtvc	r7, [r9], #-1907	; 0xfffff88d
    1424:	6d5f6863 	ldclvs	8, cr6, [pc, #-396]	; 12a0 <CPSR_IRQ_INHIBIT+0x1220>
    1428:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
    142c:	6b2f726f 	blvs	bdddf0 <_bss_end+0xbd1f8c>
    1430:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
    1434:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
    1438:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
    143c:	656d2f65 	strbvs	r2, [sp, #-3941]!	; 0xfffff09b
    1440:	79726f6d 	ldmdbvc	r2!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
    1444:	6f682f00 	svcvs	0x00682f00
    1448:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
    144c:	61686c69 	cmnvs	r8, r9, ror #24
    1450:	2f6a7976 	svccs	0x006a7976
    1454:	6f686353 	svcvs	0x00686353
    1458:	5a2f6c6f 	bpl	bdc61c <_bss_end+0xbd07b8>
    145c:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 12d0 <CPSR_IRQ_INHIBIT+0x1250>
    1460:	2f657461 	svccs	0x00657461
    1464:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
    1468:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
    146c:	2d33312f 	ldfcss	f3, [r3, #-188]!	; 0xffffff44
    1470:	746e6f63 	strbtvc	r6, [lr], #-3939	; 0xfffff09d
    1474:	5f747865 	svcpl	0x00747865
    1478:	74697773 	strbtvc	r7, [r9], #-1907	; 0xfffff88d
    147c:	6d5f6863 	ldclvs	8, cr6, [pc, #-396]	; 12f8 <CPSR_IRQ_INHIBIT+0x1278>
    1480:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
    1484:	6b2f726f 	blvs	bdde48 <_bss_end+0xbd1fe4>
    1488:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
    148c:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
    1490:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
    1494:	72642f65 	rsbvc	r2, r4, #404	; 0x194
    1498:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
    149c:	70000073 	andvc	r0, r0, r3, ror r0
    14a0:	73656761 	cmnvc	r5, #25427968	; 0x1840000
    14a4:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
    14a8:	00000100 	andeq	r0, r0, r0, lsl #2
    14ac:	64746e69 	ldrbtvs	r6, [r4], #-3689	; 0xfffff197
    14b0:	682e6665 	stmdavs	lr!, {r0, r2, r5, r6, r9, sl, sp, lr}
    14b4:	00000200 	andeq	r0, r0, r0, lsl #4
    14b8:	69726570 	ldmdbvs	r2!, {r4, r5, r6, r8, sl, sp, lr}^
    14bc:	72656870 	rsbvc	r6, r5, #112, 16	; 0x700000
    14c0:	2e736c61 	cdpcs	12, 7, cr6, cr3, cr1, {3}
    14c4:	00020068 	andeq	r0, r2, r8, rrx
    14c8:	6d656d00 	stclvs	13, cr6, [r5, #-0]
    14cc:	2e70616d 	rpwcssz	f6, f0, #5.0
    14d0:	00030068 	andeq	r0, r3, r8, rrx
    14d4:	67617000 	strbvs	r7, [r1, -r0]!
    14d8:	682e7365 	stmdavs	lr!, {r0, r2, r5, r6, r8, r9, ip, sp, lr}
    14dc:	00000300 	andeq	r0, r0, r0, lsl #6
    14e0:	696e6f6d 	stmdbvs	lr!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
    14e4:	2e726f74 	mrccs	15, 3, r6, cr2, cr4, {3}
    14e8:	00040068 	andeq	r0, r4, r8, rrx
    14ec:	42050000 	andmi	r0, r5, #0
    14f0:	d4020500 	strle	r0, [r2], #-1280	; 0xfffffb00
    14f4:	1700009a 			; <UNDEFINED> instruction: 0x1700009a
    14f8:	4b9f0e05 	blmi	fe7c4d14 <_bss_end+0xfe7b8eb0>
    14fc:	054d1105 	strbeq	r1, [sp, #-261]	; 0xfffffefb
    1500:	0505830e 	streq	r8, [r5, #-782]	; 0xfffffcf2
    1504:	33140565 	tstcc	r4, #423624704	; 0x19400000
    1508:	05831205 	streq	r1, [r3, #517]	; 0x205
    150c:	16056709 	strne	r6, [r5], -r9, lsl #14
    1510:	0e058383 	cdpeq	3, 0, cr8, cr5, cr3, {4}
    1514:	03050568 	movweq	r0, #21864	; 0x5568
    1518:	0c05667a 	stceq	6, cr6, [r5], {122}	; 0x7a
    151c:	052e0903 	streq	r0, [lr, #-2307]!	; 0xfffff6fd
    1520:	3c052f01 	stccc	15, cr2, [r5], {1}
    1524:	9f0e0584 	svcls	0x000e0584
    1528:	054d1105 	strbeq	r1, [sp, #-261]	; 0xfffffefb
    152c:	0505830e 	streq	r8, [r5, #-782]	; 0xfffffcf2
    1530:	33140565 	tstcc	r4, #423624704	; 0x19400000
    1534:	05830905 	streq	r0, [r3, #2309]	; 0x905
    1538:	0e058316 	mcreq	3, 0, r8, cr5, cr6, {0}
    153c:	62050584 	andvs	r0, r5, #132, 10	; 0x21000000
    1540:	05350c05 	ldreq	r0, [r5, #-3077]!	; 0xfffff3fb
    1544:	05842f01 	streq	r2, [r4, #3841]	; 0xf01
    1548:	1505850e 	strne	r8, [r5, #-1294]	; 0xfffffaf2
    154c:	03040200 	movweq	r0, #16896	; 0x4200
    1550:	0017054a 	andseq	r0, r7, sl, asr #10
    1554:	2e030402 	cdpcs	4, 0, cr0, cr3, cr2, {0}
    1558:	02001905 	andeq	r1, r0, #81920	; 0x14000
    155c:	05670204 	strbeq	r0, [r7, #-516]!	; 0xfffffdfc
    1560:	04020005 	streq	r0, [r2], #-5
    1564:	01059d02 	tsteq	r5, r2, lsl #26
    1568:	0505bd86 	streq	fp, [r5, #-3462]	; 0xfffff27a
    156c:	674405d7 			; <UNDEFINED> instruction: 0x674405d7
    1570:	05823505 	streq	r3, [r2, #1285]	; 0x505
    1574:	30054a21 	andcc	r4, r5, r1, lsr #20
    1578:	08010582 	stmdaeq	r1, {r1, r7, r8, sl}
    157c:	2d460523 	cfstr64cs	mvdx0, [r6, #-140]	; 0xffffff74
    1580:	05823705 	streq	r3, [r2, #1797]	; 0x705
    1584:	21054a33 	tstcs	r5, r3, lsr sl
    1588:	8230052e 	eorshi	r0, r0, #192937984	; 0xb800000
    158c:	21080105 	tstcs	r8, r5, lsl #2
    1590:	88110569 	ldmdahi	r1, {r0, r3, r5, r6, r8, sl}
    1594:	05822f05 	streq	r2, [r2, #3845]	; 0xf05
    1598:	0c05823c 	sfmeq	f0, 1, [r5], {60}	; 0x3c
    159c:	00130569 	andseq	r0, r3, r9, ror #10
    15a0:	4a010402 	bmi	425b0 <_bss_end+0x3674c>
    15a4:	05851b05 	streq	r1, [r5, #2821]	; 0xb05
    15a8:	14058209 	strne	r8, [r5], #-521	; 0xfffffdf7
    15ac:	001b054d 	andseq	r0, fp, sp, asr #10
    15b0:	4a010402 	bmi	425c0 <_bss_end+0x3675c>
    15b4:	05683505 	strbeq	r3, [r8, #-1285]!	; 0xfffffafb
    15b8:	29058220 	stmdbcs	r5, {r5, r9, pc}
    15bc:	6620052f 	strtvs	r0, [r0], -pc, lsr #10
    15c0:	05301b05 	ldreq	r1, [r0, #-2821]!	; 0xfffff4fb
    15c4:	30056611 	andcc	r6, r5, r1, lsl r6
    15c8:	4a24054d 	bmi	902b04 <_bss_end+0x8f6ca0>
    15cc:	05672105 	strbeq	r2, [r7, #-261]!	; 0xfffffefb
    15d0:	3205822d 	andcc	r8, r5, #-805306366	; 0xd0000002
    15d4:	67210582 	strvs	r0, [r1, -r2, lsl #11]!
    15d8:	05665705 	strbeq	r5, [r6, #-1797]!	; 0xfffff8fb
    15dc:	4705d65c 	smlsdmi	r5, ip, r6, sp
    15e0:	82540567 	subshi	r0, r4, #432013312	; 0x19c00000
    15e4:	05ba5905 	ldreq	r5, [sl, #2309]!	; 0x905
    15e8:	47056719 	smladmi	r5, r9, r7, r6
    15ec:	82540583 	subshi	r0, r4, #549453824	; 0x20c00000
    15f0:	05ba5905 	ldreq	r5, [sl, #2309]!	; 0x905
    15f4:	3d05682b 	stccc	8, cr6, [r5, #-172]	; 0xffffff54
    15f8:	000d054a 	andeq	r0, sp, sl, asr #10
    15fc:	03020402 	movweq	r0, #9218	; 0x2402
    1600:	05054a71 	streq	r4, [r5, #-2673]	; 0xfffff58f
    1604:	02040200 	andeq	r0, r4, #0, 4
    1608:	05827a03 	streq	r7, [r2, #2563]	; 0xa03
    160c:	821b030c 	andshi	r0, fp, #12, 6	; 0x30000000
    1610:	082f0105 	stmdaeq	pc!, {r0, r2, r8}	; <UNPREDICTABLE>
    1614:	a1090523 	tstge	r9, r3, lsr #10
    1618:	66bb0105 	ldrtvs	r0, [fp], r5, lsl #2
    161c:	0402009e 	streq	r0, [r2], #-158	; 0xffffff62
    1620:	05660601 	strbeq	r0, [r6, #-1537]!	; 0xfffff9ff
    1624:	9703060f 	strls	r0, [r3, -pc, lsl #12]
    1628:	0105827f 	tsteq	r5, pc, ror r2
    162c:	4a00e903 	bmi	3ba40 <_bss_end+0x2fbdc>
    1630:	0a024a9e 	beq	940b0 <_bss_end+0x8824c>
    1634:	46010100 	strmi	r0, [r1], -r0, lsl #2
    1638:	03000004 	movweq	r0, #4
    163c:	00025d00 	andeq	r5, r2, r0, lsl #26
    1640:	fb010200 	blx	41e4a <_bss_end+0x35fe6>
    1644:	01000d0e 	tsteq	r0, lr, lsl #26
    1648:	00010101 	andeq	r0, r1, r1, lsl #2
    164c:	00010000 	andeq	r0, r1, r0
    1650:	682f0100 	stmdavs	pc!, {r8}	; <UNPREDICTABLE>
    1654:	2f656d6f 	svccs	0x00656d6f
    1658:	686c6973 	stmdavs	ip!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
    165c:	6a797661 	bvs	1e5efe8 <_bss_end+0x1e53184>
    1660:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
    1664:	2f6c6f6f 	svccs	0x006c6f6f
    1668:	6f72655a 	svcvs	0x0072655a
    166c:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
    1670:	6178652f 	cmnvs	r8, pc, lsr #10
    1674:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
    1678:	33312f73 	teqcc	r1, #460	; 0x1cc
    167c:	6e6f632d 	cdpvs	3, 6, cr6, cr15, cr13, {1}
    1680:	74786574 	ldrbtvc	r6, [r8], #-1396	; 0xfffffa8c
    1684:	6977735f 	ldmdbvs	r7!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, sp, lr}^
    1688:	5f686374 	svcpl	0x00686374
    168c:	696e6f6d 	stmdbvs	lr!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
    1690:	2f726f74 	svccs	0x00726f74
    1694:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
    1698:	732f6c65 			; <UNDEFINED> instruction: 0x732f6c65
    169c:	702f6372 	eorvc	r6, pc, r2, ror r3	; <UNPREDICTABLE>
    16a0:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    16a4:	2f007373 	svccs	0x00007373
    16a8:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
    16ac:	6c69732f 	stclvs	3, cr7, [r9], #-188	; 0xffffff44
    16b0:	79766168 	ldmdbvc	r6!, {r3, r5, r6, r8, sp, lr}^
    16b4:	63532f6a 	cmpvs	r3, #424	; 0x1a8
    16b8:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; 1520 <CPSR_IRQ_INHIBIT+0x14a0>
    16bc:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
    16c0:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
    16c4:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
    16c8:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
    16cc:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
    16d0:	6f632d33 	svcvs	0x00632d33
    16d4:	7865746e 	stmdavc	r5!, {r1, r2, r3, r5, r6, sl, ip, sp, lr}^
    16d8:	77735f74 			; <UNDEFINED> instruction: 0x77735f74
    16dc:	68637469 	stmdavs	r3!, {r0, r3, r5, r6, sl, ip, sp, lr}^
    16e0:	6e6f6d5f 	mcrvs	13, 3, r6, cr15, cr15, {2}
    16e4:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
    16e8:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
    16ec:	2f6c656e 	svccs	0x006c656e
    16f0:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
    16f4:	2f656475 	svccs	0x00656475
    16f8:	6f6d656d 	svcvs	0x006d656d
    16fc:	2f007972 	svccs	0x00007972
    1700:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
    1704:	6c69732f 	stclvs	3, cr7, [r9], #-188	; 0xffffff44
    1708:	79766168 	ldmdbvc	r6!, {r3, r5, r6, r8, sp, lr}^
    170c:	63532f6a 	cmpvs	r3, #424	; 0x1a8
    1710:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; 1578 <CPSR_IRQ_INHIBIT+0x14f8>
    1714:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
    1718:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
    171c:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
    1720:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
    1724:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
    1728:	6f632d33 	svcvs	0x00632d33
    172c:	7865746e 	stmdavc	r5!, {r1, r2, r3, r5, r6, sl, ip, sp, lr}^
    1730:	77735f74 			; <UNDEFINED> instruction: 0x77735f74
    1734:	68637469 	stmdavs	r3!, {r0, r3, r5, r6, sl, ip, sp, lr}^
    1738:	6e6f6d5f 	mcrvs	13, 3, r6, cr15, cr15, {2}
    173c:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
    1740:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
    1744:	2f6c656e 	svccs	0x006c656e
    1748:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
    174c:	2f656475 	svccs	0x00656475
    1750:	72616f62 	rsbvc	r6, r1, #392	; 0x188
    1754:	70722f64 	rsbsvc	r2, r2, r4, ror #30
    1758:	682f3069 	stmdavs	pc!, {r0, r3, r5, r6, ip, sp}	; <UNPREDICTABLE>
    175c:	2f006c61 	svccs	0x00006c61
    1760:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
    1764:	6c69732f 	stclvs	3, cr7, [r9], #-188	; 0xffffff44
    1768:	79766168 	ldmdbvc	r6!, {r3, r5, r6, r8, sp, lr}^
    176c:	63532f6a 	cmpvs	r3, #424	; 0x1a8
    1770:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; 15d8 <CPSR_IRQ_INHIBIT+0x1558>
    1774:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
    1778:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
    177c:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
    1780:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
    1784:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
    1788:	6f632d33 	svcvs	0x00632d33
    178c:	7865746e 	stmdavc	r5!, {r1, r2, r3, r5, r6, sl, ip, sp, lr}^
    1790:	77735f74 			; <UNDEFINED> instruction: 0x77735f74
    1794:	68637469 	stmdavs	r3!, {r0, r3, r5, r6, sl, ip, sp, lr}^
    1798:	6e6f6d5f 	mcrvs	13, 3, r6, cr15, cr15, {2}
    179c:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
    17a0:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
    17a4:	2f6c656e 	svccs	0x006c656e
    17a8:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
    17ac:	2f656475 	svccs	0x00656475
    17b0:	636f7270 	cmnvs	pc, #112, 4
    17b4:	00737365 	rsbseq	r7, r3, r5, ror #6
    17b8:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 1704 <CPSR_IRQ_INHIBIT+0x1684>
    17bc:	69732f65 	ldmdbvs	r3!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
    17c0:	7661686c 	strbtvc	r6, [r1], -ip, ror #16
    17c4:	532f6a79 			; <UNDEFINED> instruction: 0x532f6a79
    17c8:	6f6f6863 	svcvs	0x006f6863
    17cc:	655a2f6c 	ldrbvs	r2, [sl, #-3948]	; 0xfffff094
    17d0:	614d6f72 	hvcvs	55026	; 0xd6f2
    17d4:	652f6574 	strvs	r6, [pc, #-1396]!	; 1268 <CPSR_IRQ_INHIBIT+0x11e8>
    17d8:	706d6178 	rsbvc	r6, sp, r8, ror r1
    17dc:	2f73656c 	svccs	0x0073656c
    17e0:	632d3331 			; <UNDEFINED> instruction: 0x632d3331
    17e4:	65746e6f 	ldrbvs	r6, [r4, #-3695]!	; 0xfffff191
    17e8:	735f7478 	cmpvc	pc, #120, 8	; 0x78000000
    17ec:	63746977 	cmnvs	r4, #1949696	; 0x1dc000
    17f0:	6f6d5f68 	svcvs	0x006d5f68
    17f4:	6f74696e 	svcvs	0x0074696e
    17f8:	656b2f72 	strbvs	r2, [fp, #-3954]!	; 0xfffff08e
    17fc:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
    1800:	636e692f 	cmnvs	lr, #770048	; 0xbc000
    1804:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
    1808:	6972642f 	ldmdbvs	r2!, {r0, r1, r2, r3, r5, sl, sp, lr}^
    180c:	73726576 	cmnvc	r2, #494927872	; 0x1d800000
    1810:	72700000 	rsbsvc	r0, r0, #0
    1814:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    1818:	616d5f73 	smcvs	54771	; 0xd5f3
    181c:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
    1820:	70632e72 	rsbvc	r2, r3, r2, ror lr
    1824:	00010070 	andeq	r0, r1, r0, ror r0
    1828:	72656b00 	rsbvc	r6, r5, #0, 22
    182c:	5f6c656e 	svcpl	0x006c656e
    1830:	70616568 	rsbvc	r6, r1, r8, ror #10
    1834:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
    1838:	6e690000 	cdpvs	0, 6, cr0, cr9, cr0, {0}
    183c:	66656474 			; <UNDEFINED> instruction: 0x66656474
    1840:	0300682e 	movweq	r6, #2094	; 0x82e
    1844:	72700000 	rsbsvc	r0, r0, #0
    1848:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    184c:	00682e73 	rsbeq	r2, r8, r3, ror lr
    1850:	70000004 	andvc	r0, r0, r4
    1854:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    1858:	6d5f7373 	ldclvs	3, cr7, [pc, #-460]	; 1694 <CPSR_IRQ_INHIBIT+0x1614>
    185c:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
    1860:	682e7265 	stmdavs	lr!, {r0, r2, r5, r6, r9, ip, sp, lr}
    1864:	00000400 	andeq	r0, r0, r0, lsl #8
    1868:	696e6f6d 	stmdbvs	lr!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
    186c:	2e726f74 	mrccs	15, 3, r6, cr2, cr4, {3}
    1870:	00050068 	andeq	r0, r5, r8, rrx
    1874:	72657000 	rsbvc	r7, r5, #0
    1878:	65687069 	strbvs	r7, [r8, #-105]!	; 0xffffff97
    187c:	736c6172 	cmnvc	ip, #-2147483620	; 0x8000001c
    1880:	0300682e 	movweq	r6, #2094	; 0x82e
    1884:	656d0000 	strbvs	r0, [sp, #-0]!
    1888:	70616d6d 	rsbvc	r6, r1, sp, ror #26
    188c:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
    1890:	61700000 	cmnvs	r0, r0
    1894:	2e736567 	cdpcs	5, 7, cr6, cr3, cr7, {3}
    1898:	00020068 	andeq	r0, r2, r8, rrx
    189c:	01050000 	mrseq	r0, (UNDEF: 5)
    18a0:	e8020500 	stmda	r2, {r8, sl}
    18a4:	0300009f 	movweq	r0, #159	; 0x9f
    18a8:	4c050111 	stfmis	f0, [r5], {17}
    18ac:	08010583 	stmdaeq	r1, {r0, r1, r7, r8, sl}
    18b0:	0c05a123 	stfeqd	f2, [r5], {35}	; 0x23
    18b4:	4a1f0583 	bmi	7c2ec8 <_bss_end+0x7b7064>
    18b8:	02002105 	andeq	r2, r0, #1073741825	; 0x40000001
    18bc:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
    18c0:	0402001f 	streq	r0, [r2], #-31	; 0xffffffe1
    18c4:	3c054a01 			; <UNDEFINED> instruction: 0x3c054a01
    18c8:	01040200 	mrseq	r0, R12_usr
    18cc:	001f052e 	andseq	r0, pc, lr, lsr #10
    18d0:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
    18d4:	02000105 	andeq	r0, r0, #1073741825	; 0x40000001
    18d8:	852f0504 	strhi	r0, [pc, #-1284]!	; 13dc <CPSR_IRQ_INHIBIT+0x135c>
    18dc:	05834805 	streq	r4, [r3, #2053]	; 0x805
    18e0:	14058416 	strne	r8, [r5], #-1046	; 0xfffffbea
    18e4:	09054b4a 	stmdbeq	r5, {r1, r3, r6, r8, r9, fp, lr}
    18e8:	4a050567 	bmi	142e8c <_bss_end+0x137028>
    18ec:	054c1c05 	strbeq	r1, [ip, #-3077]	; 0xfffff3fb
    18f0:	1e056805 	cdpne	8, 0, cr6, cr5, cr5, {0}
    18f4:	4c34054a 	cfldr32mi	mvfx0, [r4], #-296	; 0xfffffed8
    18f8:	05661405 	strbeq	r1, [r6, #-1029]!	; 0xfffffbfb
    18fc:	13054c0b 	movwne	r4, #23563	; 0x5c0b
    1900:	4a110568 	bmi	442ea8 <_bss_end+0x437044>
    1904:	052e0f05 	streq	r0, [lr, #-3845]!	; 0xfffff0fb
    1908:	0f054a13 	svceq	0x00054a13
    190c:	4b21054a 	blmi	842e3c <_bss_end+0x836fd8>
    1910:	4a190567 	bmi	642eb4 <_bss_end+0x637050>
    1914:	054b1105 	strbeq	r1, [fp, #-261]	; 0xfffffefb
    1918:	1805681a 	stmdane	r5, {r1, r3, r4, fp, sp, lr}
    191c:	4b01054a 	blmi	42e4c <_bss_end+0x36fe8>
    1920:	9f480585 	svcls	0x00480585
    1924:	05841605 	streq	r1, [r4, #1541]	; 0x605
    1928:	054b4a14 	strbeq	r4, [fp, #-2580]	; 0xfffff5ec
    192c:	05056709 	streq	r6, [r5, #-1801]	; 0xfffff8f7
    1930:	4c09054a 	cfstr32mi	mvfx0, [r9], {74}	; 0x4a
    1934:	054a2205 	strbeq	r2, [sl, #-517]	; 0xfffffdfb
    1938:	1c054b1e 			; <UNDEFINED> instruction: 0x1c054b1e
    193c:	4c18054a 	cfldr32mi	mvfx0, [r8], {74}	; 0x4a
    1940:	05683405 	strbeq	r3, [r8, #-1029]!	; 0xfffffbfb
    1944:	0b056614 	bleq	15b19c <_bss_end+0x14f338>
    1948:	6813054c 	ldmdavs	r3, {r2, r3, r6, r8, sl}
    194c:	054a1105 	strbeq	r1, [sl, #-261]	; 0xfffffefb
    1950:	13052e0f 	movwne	r2, #24079	; 0x5e0f
    1954:	4a0f054a 	bmi	3c2e84 <_bss_end+0x3b7020>
    1958:	674b2105 	strbvs	r2, [fp, -r5, lsl #2]
    195c:	054a1905 	strbeq	r1, [sl, #-2309]	; 0xfffff6fb
    1960:	1a054b11 	bne	1545ac <_bss_end+0x148748>
    1964:	4f056768 	svcmi	0x00056768
    1968:	66530567 	ldrbvs	r0, [r3], -r7, ror #10
    196c:	052e1a05 	streq	r1, [lr, #-2565]!	; 0xfffff5fb
    1970:	31054c11 	tstcc	r5, r1, lsl ip
    1974:	82580582 	subshi	r0, r8, #545259520	; 0x20800000
    1978:	05ba5e05 	ldreq	r5, [sl, #3589]!	; 0xe05
    197c:	01056812 	tsteq	r5, r2, lsl r8
    1980:	2005f54b 	andcs	pc, r5, fp, asr #10
    1984:	4a3e0583 	bmi	f82f98 <_bss_end+0xf77134>
    1988:	02004005 	andeq	r4, r0, #5
    198c:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
    1990:	0402003e 	streq	r0, [r2], #-62	; 0xffffffc2
    1994:	02004a01 	andeq	r4, r0, #4096	; 0x1000
    1998:	4a060204 	bmi	1821b0 <_bss_end+0x17634c>
    199c:	02001905 	andeq	r1, r0, #81920	; 0x14000
    19a0:	4a060404 	bmi	1829b8 <_bss_end+0x176b54>
    19a4:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
    19a8:	052f0404 	streq	r0, [pc, #-1028]!	; 15ac <CPSR_IRQ_INHIBIT+0x152c>
    19ac:	1105680e 	tstne	r5, lr, lsl #16
    19b0:	4a050569 	bmi	142f5c <_bss_end+0x1370f8>
    19b4:	05683305 	strbeq	r3, [r8, #-773]!	; 0xfffffcfb
    19b8:	09054a47 	stmdbeq	r5, {r0, r1, r2, r6, r9, fp, lr}
    19bc:	4a1d052e 	bmi	742e7c <_bss_end+0x737018>
    19c0:	052e4d05 	streq	r4, [lr, #-3333]!	; 0xfffff2fb
    19c4:	09052e31 	stmdbeq	r5, {r0, r4, r5, r9, sl, fp, sp}
    19c8:	320e052f 	andcc	r0, lr, #197132288	; 0xbc00000
    19cc:	4d670105 	stfmie	f0, [r7, #-20]!	; 0xffffffec
    19d0:	05a20905 	streq	r0, [r2, #2309]!	; 0x905
    19d4:	23054a1d 	movwcs	r4, #23069	; 0x5a1d
    19d8:	2e05052e 	cfsh32cs	mvfx0, mvfx5, #30
    19dc:	054b0905 	strbeq	r0, [fp, #-2309]	; 0xfffff6fb
    19e0:	29054a1d 	stmdbcs	r5, {r0, r2, r3, r4, r9, fp, lr}
    19e4:	4d05052e 	cfstr32mi	mvfx0, [r5, #-184]	; 0xffffff48
    19e8:	054a1905 	strbeq	r1, [sl, #-2309]	; 0xfffff6fb
    19ec:	1a052e2d 	bne	14d2a8 <_bss_end+0x141444>
    19f0:	4a2e054c 	bmi	b82f28 <_bss_end+0xb770c4>
    19f4:	052e1305 	streq	r1, [lr, #-773]!	; 0xfffffcfb
    19f8:	27052f21 	strcs	r2, [r5, -r1, lsr #30]
    19fc:	2e0a054a 	cfsh32cs	mvfx0, mvfx10, #42
    1a00:	05851805 	streq	r1, [r5, #2053]	; 0x805
    1a04:	4305672f 	movwmi	r6, #22319	; 0x572f
    1a08:	2e05054a 	cfsh32cs	mvfx0, mvfx5, #42
    1a0c:	054a1905 	strbeq	r1, [sl, #-2309]	; 0xfffff6fb
    1a10:	2d052e49 	stccs	14, cr2, [r5, #-292]	; 0xfffffedc
    1a14:	2f05052e 	svccs	0x0005052e
    1a18:	054a1905 	strbeq	r1, [sl, #-2309]	; 0xfffff6fb
    1a1c:	05052e25 	streq	r2, [r5, #-3621]	; 0xfffff1db
    1a20:	6925054d 	stmdbvs	r5!, {r0, r2, r3, r6, r8, sl}
    1a24:	054a1d05 	strbeq	r1, [sl, #-3333]	; 0xfffff2fb
    1a28:	1f056d01 	svcne	0x00056d01
    1a2c:	4a17052c 	bmi	5c2ee4 <_bss_end+0x5b7080>
    1a30:	66680105 	strbtvs	r0, [r8], -r5, lsl #2
    1a34:	0402009e 	streq	r0, [r2], #-158	; 0xffffff62
    1a38:	05660601 	strbeq	r0, [r6, #-1537]!	; 0xfffff9ff
    1a3c:	8c030612 	stchi	6, cr0, [r3], {18}
    1a40:	0105827f 	tsteq	r5, pc, ror r2
    1a44:	4a00f403 	bmi	3ea58 <_bss_end+0x32bf4>
    1a48:	0a024a9e 	beq	944c8 <_bss_end+0x88664>
    1a4c:	04010100 	streq	r0, [r1], #-256	; 0xffffff00
    1a50:	000c0502 	andeq	r0, ip, r2, lsl #10
    1a54:	a4f80205 	ldrbtge	r0, [r8], #517	; 0x205
    1a58:	1d030000 	stcne	0, cr0, [r3, #-0]
    1a5c:	842e0501 	strthi	r0, [lr], #-1281	; 0xfffffaff
    1a60:	02830905 	addeq	r0, r3, #81920	; 0x14000
    1a64:	01010006 	tsteq	r1, r6
    1a68:	0c050204 	sfmeq	f0, 4, [r5], {4}
    1a6c:	24020500 	strcs	r0, [r2], #-1280	; 0xfffffb00
    1a70:	030000a5 	movweq	r0, #165	; 0xa5
    1a74:	2e05011d 	mcrcs	1, 0, r0, cr5, cr13, {0}
    1a78:	83090584 	movwhi	r0, #38276	; 0x9584
    1a7c:	01000602 	tsteq	r0, r2, lsl #12
    1a80:	00009d01 	andeq	r9, r0, r1, lsl #26
    1a84:	74000300 	strvc	r0, [r0], #-768	; 0xfffffd00
    1a88:	02000000 	andeq	r0, r0, #0
    1a8c:	0d0efb01 	vstreq	d15, [lr, #-4]
    1a90:	01010100 	mrseq	r0, (UNDEF: 17)
    1a94:	00000001 	andeq	r0, r0, r1
    1a98:	01000001 	tsteq	r0, r1
    1a9c:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 19e8 <CPSR_IRQ_INHIBIT+0x1968>
    1aa0:	69732f65 	ldmdbvs	r3!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
    1aa4:	7661686c 	strbtvc	r6, [r1], -ip, ror #16
    1aa8:	532f6a79 			; <UNDEFINED> instruction: 0x532f6a79
    1aac:	6f6f6863 	svcvs	0x006f6863
    1ab0:	655a2f6c 	ldrbvs	r2, [sl, #-3948]	; 0xfffff094
    1ab4:	614d6f72 	hvcvs	55026	; 0xd6f2
    1ab8:	652f6574 	strvs	r6, [pc, #-1396]!	; 154c <CPSR_IRQ_INHIBIT+0x14cc>
    1abc:	706d6178 	rsbvc	r6, sp, r8, ror r1
    1ac0:	2f73656c 	svccs	0x0073656c
    1ac4:	632d3331 			; <UNDEFINED> instruction: 0x632d3331
    1ac8:	65746e6f 	ldrbvs	r6, [r4, #-3695]!	; 0xfffff191
    1acc:	735f7478 	cmpvc	pc, #120, 8	; 0x78000000
    1ad0:	63746977 	cmnvs	r4, #1949696	; 0x1dc000
    1ad4:	6f6d5f68 	svcvs	0x006d5f68
    1ad8:	6f74696e 	svcvs	0x0074696e
    1adc:	656b2f72 	strbvs	r2, [fp, #-3954]!	; 0xfffff08e
    1ae0:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
    1ae4:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
    1ae8:	6f72702f 	svcvs	0x0072702f
    1aec:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    1af0:	77730000 	ldrbvc	r0, [r3, -r0]!
    1af4:	68637469 	stmdavs	r3!, {r0, r3, r5, r6, sl, ip, sp, lr}^
    1af8:	0100732e 	tsteq	r0, lr, lsr #6
    1afc:	00000000 	andeq	r0, r0, r0
    1b00:	a5500205 	ldrbge	r0, [r0, #-517]	; 0xfffffdfb
    1b04:	2f160000 	svccs	0x00160000
    1b08:	2f2f2f36 	svccs	0x002f2f36
    1b0c:	2f2f302f 	svccs	0x002f302f
    1b10:	2f2f352f 	svccs	0x002f352f
    1b14:	2f302f2f 	svccs	0x00302f2f
    1b18:	2f2f2f2f 	svccs	0x002f2f2f
    1b1c:	0002022f 	andeq	r0, r2, pc, lsr #4
    1b20:	00c80101 	sbceq	r0, r8, r1, lsl #2
    1b24:	00030000 	andeq	r0, r3, r0
    1b28:	0000006b 	andeq	r0, r0, fp, rrx
    1b2c:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
    1b30:	0101000d 	tsteq	r1, sp
    1b34:	00000101 	andeq	r0, r0, r1, lsl #2
    1b38:	00000100 	andeq	r0, r0, r0, lsl #2
    1b3c:	6f682f01 	svcvs	0x00682f01
    1b40:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
    1b44:	61686c69 	cmnvs	r8, r9, ror #24
    1b48:	2f6a7976 	svccs	0x006a7976
    1b4c:	6f686353 	svcvs	0x00686353
    1b50:	5a2f6c6f 	bpl	bdcd14 <_bss_end+0xbd0eb0>
    1b54:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 19c8 <CPSR_IRQ_INHIBIT+0x1948>
    1b58:	2f657461 	svccs	0x00657461
    1b5c:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
    1b60:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
    1b64:	2d33312f 	ldfcss	f3, [r3, #-188]!	; 0xffffff44
    1b68:	746e6f63 	strbtvc	r6, [lr], #-3939	; 0xfffff09d
    1b6c:	5f747865 	svcpl	0x00747865
    1b70:	74697773 	strbtvc	r7, [r9], #-1907	; 0xfffff88d
    1b74:	6d5f6863 	ldclvs	8, cr6, [pc, #-396]	; 19f0 <CPSR_IRQ_INHIBIT+0x1970>
    1b78:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
    1b7c:	6b2f726f 	blvs	bde540 <_bss_end+0xbd26dc>
    1b80:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
    1b84:	72732f6c 	rsbsvc	r2, r3, #108, 30	; 0x1b0
    1b88:	73000063 	movwvc	r0, #99	; 0x63
    1b8c:	74726174 	ldrbtvc	r6, [r2], #-372	; 0xfffffe8c
    1b90:	0100732e 	tsteq	r0, lr, lsr #6
    1b94:	00000000 	andeq	r0, r0, r0
    1b98:	80000205 	andhi	r0, r0, r5, lsl #4
    1b9c:	0d030000 	stceq	0, cr0, [r3, #-0]
    1ba0:	2f2f2f01 	svccs	0x002f2f01
    1ba4:	2f2f2f2f 	svccs	0x002f2f2f
    1ba8:	20081f03 	andcs	r1, r8, r3, lsl #30
    1bac:	2f2f322f 	svccs	0x002f322f
    1bb0:	2f31322f 	svccs	0x0031322f
    1bb4:	2f2f312f 	svccs	0x002f312f
    1bb8:	312f2f31 			; <UNDEFINED> instruction: 0x312f2f31
    1bbc:	2f312f2f 	svccs	0x00312f2f
    1bc0:	2f2f302f 	svccs	0x002f302f
    1bc4:	0202302f 	andeq	r3, r2, #47	; 0x2f
    1bc8:	00010100 	andeq	r0, r1, r0, lsl #2
    1bcc:	a5ac0205 	strge	r0, [ip, #517]!	; 0x205
    1bd0:	e6030000 	str	r0, [r3], -r0
    1bd4:	2f2f0100 	svccs	0x002f0100
    1bd8:	2f322f2f 	svccs	0x00322f2f
    1bdc:	2f2f3231 	svccs	0x002f3231
    1be0:	302f302f 	eorcc	r3, pc, pc, lsr #32
    1be4:	332f3030 			; <UNDEFINED> instruction: 0x332f3030
    1be8:	00020233 	andeq	r0, r2, r3, lsr r2
    1bec:	00f00101 	rscseq	r0, r0, r1, lsl #2
    1bf0:	00030000 	andeq	r0, r3, r0
    1bf4:	0000006f 	andeq	r0, r0, pc, rrx
    1bf8:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
    1bfc:	0101000d 	tsteq	r1, sp
    1c00:	00000101 	andeq	r0, r0, r1, lsl #2
    1c04:	00000100 	andeq	r0, r0, r0, lsl #2
    1c08:	6f682f01 	svcvs	0x00682f01
    1c0c:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
    1c10:	61686c69 	cmnvs	r8, r9, ror #24
    1c14:	2f6a7976 	svccs	0x006a7976
    1c18:	6f686353 	svcvs	0x00686353
    1c1c:	5a2f6c6f 	bpl	bdcde0 <_bss_end+0xbd0f7c>
    1c20:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 1a94 <CPSR_IRQ_INHIBIT+0x1a14>
    1c24:	2f657461 	svccs	0x00657461
    1c28:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
    1c2c:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
    1c30:	2d33312f 	ldfcss	f3, [r3, #-188]!	; 0xffffff44
    1c34:	746e6f63 	strbtvc	r6, [lr], #-3939	; 0xfffff09d
    1c38:	5f747865 	svcpl	0x00747865
    1c3c:	74697773 	strbtvc	r7, [r9], #-1907	; 0xfffff88d
    1c40:	6d5f6863 	ldclvs	8, cr6, [pc, #-396]	; 1abc <CPSR_IRQ_INHIBIT+0x1a3c>
    1c44:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
    1c48:	6b2f726f 	blvs	bde60c <_bss_end+0xbd27a8>
    1c4c:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
    1c50:	72732f6c 	rsbsvc	r2, r3, #108, 30	; 0x1b0
    1c54:	73000063 	movwvc	r0, #99	; 0x63
    1c58:	74726174 	ldrbtvc	r6, [r2], #-372	; 0xfffffe8c
    1c5c:	632e7075 			; <UNDEFINED> instruction: 0x632e7075
    1c60:	01007070 	tsteq	r0, r0, ror r0
    1c64:	05000000 	streq	r0, [r0, #-0]
    1c68:	02050001 	andeq	r0, r5, #1
    1c6c:	0000a5fc 	strdeq	sl, [r0], -ip
    1c70:	05011403 	streq	r1, [r1, #-1027]	; 0xfffffbfd
    1c74:	1f056a09 	svcne	0x00056a09
    1c78:	03040200 	movweq	r0, #16896	; 0x4200
    1c7c:	00060566 	andeq	r0, r6, r6, ror #10
    1c80:	bb020402 	bllt	82c90 <_bss_end+0x76e2c>
    1c84:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
    1c88:	05650204 	strbeq	r0, [r5, #-516]!	; 0xfffffdfc
    1c8c:	01058509 	tsteq	r5, r9, lsl #10
    1c90:	0d05bd2f 	stceq	13, cr11, [r5, #-188]	; 0xffffff44
    1c94:	0024056b 	eoreq	r0, r4, fp, ror #10
    1c98:	4a030402 	bmi	c2ca8 <_bss_end+0xb6e44>
    1c9c:	02000405 	andeq	r0, r0, #83886080	; 0x5000000
    1ca0:	05830204 	streq	r0, [r3, #516]	; 0x204
    1ca4:	0402000b 	streq	r0, [r2], #-11
    1ca8:	02054a02 	andeq	r4, r5, #8192	; 0x2000
    1cac:	02040200 	andeq	r0, r4, #0, 4
    1cb0:	8509052d 	strhi	r0, [r9, #-1325]	; 0xfffffad3
    1cb4:	a12f0105 			; <UNDEFINED> instruction: 0xa12f0105
    1cb8:	056a0d05 	strbeq	r0, [sl, #-3333]!	; 0xfffff2fb
    1cbc:	04020024 	streq	r0, [r2], #-36	; 0xffffffdc
    1cc0:	04054a03 	streq	r4, [r5], #-2563	; 0xfffff5fd
    1cc4:	02040200 	andeq	r0, r4, #0, 4
    1cc8:	000b0583 	andeq	r0, fp, r3, lsl #11
    1ccc:	4a020402 	bmi	82cdc <_bss_end+0x76e78>
    1cd0:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
    1cd4:	052d0204 	streq	r0, [sp, #-516]!	; 0xfffffdfc
    1cd8:	01058509 	tsteq	r5, r9, lsl #10
    1cdc:	000a022f 	andeq	r0, sl, pc, lsr #4
    1ce0:	01310101 	teqeq	r1, r1, lsl #2
    1ce4:	00030000 	andeq	r0, r3, r0
    1ce8:	00000071 	andeq	r0, r0, r1, ror r0
    1cec:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
    1cf0:	0101000d 	tsteq	r1, sp
    1cf4:	00000101 	andeq	r0, r0, r1, lsl #2
    1cf8:	00000100 	andeq	r0, r0, r0, lsl #2
    1cfc:	6f682f01 	svcvs	0x00682f01
    1d00:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
    1d04:	61686c69 	cmnvs	r8, r9, ror #24
    1d08:	2f6a7976 	svccs	0x006a7976
    1d0c:	6f686353 	svcvs	0x00686353
    1d10:	5a2f6c6f 	bpl	bdced4 <_bss_end+0xbd1070>
    1d14:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 1b88 <CPSR_IRQ_INHIBIT+0x1b08>
    1d18:	2f657461 	svccs	0x00657461
    1d1c:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
    1d20:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
    1d24:	2d33312f 	ldfcss	f3, [r3, #-188]!	; 0xffffff44
    1d28:	746e6f63 	strbtvc	r6, [lr], #-3939	; 0xfffff09d
    1d2c:	5f747865 	svcpl	0x00747865
    1d30:	74697773 	strbtvc	r7, [r9], #-1907	; 0xfffff88d
    1d34:	6d5f6863 	ldclvs	8, cr6, [pc, #-396]	; 1bb0 <CPSR_IRQ_INHIBIT+0x1b30>
    1d38:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
    1d3c:	732f726f 			; <UNDEFINED> instruction: 0x732f726f
    1d40:	696c6474 	stmdbvs	ip!, {r2, r4, r5, r6, sl, sp, lr}^
    1d44:	72732f62 	rsbsvc	r2, r3, #392	; 0x188
    1d48:	73000063 	movwvc	r0, #99	; 0x63
    1d4c:	74736474 	ldrbtvc	r6, [r3], #-1140	; 0xfffffb8c
    1d50:	676e6972 			; <UNDEFINED> instruction: 0x676e6972
    1d54:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
    1d58:	00000100 	andeq	r0, r0, r0, lsl #2
    1d5c:	00010500 	andeq	r0, r1, r0, lsl #10
    1d60:	a7140205 	ldrge	r0, [r4, -r5, lsl #4]
    1d64:	051a0000 	ldreq	r0, [sl, #-0]
    1d68:	0f05bb06 	svceq	0x0005bb06
    1d6c:	6821054c 	stmdavs	r1!, {r2, r3, r6, r8, sl}
    1d70:	05ba0a05 	ldreq	r0, [sl, #2565]!	; 0xa05
    1d74:	27052e0b 	strcs	r2, [r5, -fp, lsl #28]
    1d78:	4a0d054a 	bmi	3432a8 <_bss_end+0x337444>
    1d7c:	052f0905 	streq	r0, [pc, #-2309]!	; 147f <CPSR_IRQ_INHIBIT+0x13ff>
    1d80:	02059f04 	andeq	r9, r5, #4, 30
    1d84:	35050562 	strcc	r0, [r5, #-1378]	; 0xfffffa9e
    1d88:	05681005 	strbeq	r1, [r8, #-5]!
    1d8c:	22052e11 	andcs	r2, r5, #272	; 0x110
    1d90:	2e13054a 	cfmac32cs	mvfx0, mvfx3, mvfx10
    1d94:	052f0a05 	streq	r0, [pc, #-2565]!	; 1397 <CPSR_IRQ_INHIBIT+0x1317>
    1d98:	0a056909 	beq	15c1c4 <_bss_end+0x150360>
    1d9c:	4a0c052e 	bmi	30325c <_bss_end+0x2f73f8>
    1da0:	054b0305 	strbeq	r0, [fp, #-773]	; 0xfffffcfb
    1da4:	1805680b 	stmdane	r5, {r0, r1, r3, fp, sp, lr}
    1da8:	03040200 	movweq	r0, #16896	; 0x4200
    1dac:	0014054a 	andseq	r0, r4, sl, asr #10
    1db0:	9e030402 	cdpls	4, 0, cr0, cr3, cr2, {0}
    1db4:	02001505 	andeq	r1, r0, #20971520	; 0x1400000
    1db8:	05680204 	strbeq	r0, [r8, #-516]!	; 0xfffffdfc
    1dbc:	04020018 	streq	r0, [r2], #-24	; 0xffffffe8
    1dc0:	08058202 	stmdaeq	r5, {r1, r9, pc}
    1dc4:	02040200 	andeq	r0, r4, #0, 4
    1dc8:	001a054a 	andseq	r0, sl, sl, asr #10
    1dcc:	4b020402 	blmi	82ddc <_bss_end+0x76f78>
    1dd0:	02001b05 	andeq	r1, r0, #5120	; 0x1400
    1dd4:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
    1dd8:	0402000c 	streq	r0, [r2], #-12
    1ddc:	0f054a02 	svceq	0x00054a02
    1de0:	02040200 	andeq	r0, r4, #0, 4
    1de4:	001b0582 	andseq	r0, fp, r2, lsl #11
    1de8:	4a020402 	bmi	82df8 <_bss_end+0x76f94>
    1dec:	02001105 	andeq	r1, r0, #1073741825	; 0x40000001
    1df0:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
    1df4:	0402000a 	streq	r0, [r2], #-10
    1df8:	0b052f02 	bleq	14da08 <_bss_end+0x141ba4>
    1dfc:	02040200 	andeq	r0, r4, #0, 4
    1e00:	000d052e 	andeq	r0, sp, lr, lsr #10
    1e04:	4a020402 	bmi	82e14 <_bss_end+0x76fb0>
    1e08:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
    1e0c:	05460204 	strbeq	r0, [r6, #-516]	; 0xfffffdfc
    1e10:	08028801 	stmdaeq	r2, {r0, fp, pc}
    1e14:	79010100 	stmdbvc	r1, {r8}
    1e18:	03000000 	movweq	r0, #0
    1e1c:	00004600 	andeq	r4, r0, r0, lsl #12
    1e20:	fb010200 	blx	4262a <_bss_end+0x367c6>
    1e24:	01000d0e 	tsteq	r0, lr, lsl #26
    1e28:	00010101 	andeq	r0, r1, r1, lsl #2
    1e2c:	00010000 	andeq	r0, r1, r0
    1e30:	2e2e0100 	sufcse	f0, f6, f0
    1e34:	2f2e2e2f 	svccs	0x002e2e2f
    1e38:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1e3c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1e40:	2f2e2e2f 	svccs	0x002e2e2f
    1e44:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    1e48:	632f6363 			; <UNDEFINED> instruction: 0x632f6363
    1e4c:	69666e6f 	stmdbvs	r6!, {r0, r1, r2, r3, r5, r6, r9, sl, fp, sp, lr}^
    1e50:	72612f67 	rsbvc	r2, r1, #412	; 0x19c
    1e54:	6c00006d 	stcvs	0, cr0, [r0], {109}	; 0x6d
    1e58:	66316269 	ldrtvs	r6, [r1], -r9, ror #4
    1e5c:	73636e75 	cmnvc	r3, #1872	; 0x750
    1e60:	0100532e 	tsteq	r0, lr, lsr #6
    1e64:	00000000 	andeq	r0, r0, r0
    1e68:	a8880205 	stmge	r8, {r0, r2, r9}
    1e6c:	ca030000 	bgt	c1e74 <_bss_end+0xb6010>
    1e70:	2f300108 	svccs	0x00300108
    1e74:	2f2f2f2f 	svccs	0x002f2f2f
    1e78:	01d00230 	bicseq	r0, r0, r0, lsr r2
    1e7c:	2f312f14 	svccs	0x00312f14
    1e80:	2f4c302f 	svccs	0x004c302f
    1e84:	661f0332 			; <UNDEFINED> instruction: 0x661f0332
    1e88:	2f2f2f2f 	svccs	0x002f2f2f
    1e8c:	022f2f2f 	eoreq	r2, pc, #47, 30	; 0xbc
    1e90:	01010002 	tsteq	r1, r2
    1e94:	0000005c 	andeq	r0, r0, ip, asr r0
    1e98:	00460003 	subeq	r0, r6, r3
    1e9c:	01020000 	mrseq	r0, (UNDEF: 2)
    1ea0:	000d0efb 	strdeq	r0, [sp], -fp
    1ea4:	01010101 	tsteq	r1, r1, lsl #2
    1ea8:	01000000 	mrseq	r0, (UNDEF: 0)
    1eac:	2e010000 	cdpcs	0, 0, cr0, cr1, cr0, {0}
    1eb0:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1eb4:	2f2e2e2f 	svccs	0x002e2e2f
    1eb8:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1ebc:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1ec0:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    1ec4:	2f636367 	svccs	0x00636367
    1ec8:	666e6f63 	strbtvs	r6, [lr], -r3, ror #30
    1ecc:	612f6769 			; <UNDEFINED> instruction: 0x612f6769
    1ed0:	00006d72 	andeq	r6, r0, r2, ror sp
    1ed4:	3162696c 	cmncc	r2, ip, ror #18
    1ed8:	636e7566 	cmnvs	lr, #427819008	; 0x19800000
    1edc:	00532e73 	subseq	r2, r3, r3, ror lr
    1ee0:	00000001 	andeq	r0, r0, r1
    1ee4:	94020500 	strls	r0, [r2], #-1280	; 0xfffffb00
    1ee8:	030000aa 	movweq	r0, #170	; 0xaa
    1eec:	02010bb4 	andeq	r0, r1, #180, 22	; 0x2d000
    1ef0:	01010002 	tsteq	r1, r2
    1ef4:	00000103 	andeq	r0, r0, r3, lsl #2
    1ef8:	00fd0003 	rscseq	r0, sp, r3
    1efc:	01020000 	mrseq	r0, (UNDEF: 2)
    1f00:	000d0efb 	strdeq	r0, [sp], -fp
    1f04:	01010101 	tsteq	r1, r1, lsl #2
    1f08:	01000000 	mrseq	r0, (UNDEF: 0)
    1f0c:	2e010000 	cdpcs	0, 0, cr0, cr1, cr0, {0}
    1f10:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1f14:	2f2e2e2f 	svccs	0x002e2e2f
    1f18:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1f1c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1f20:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    1f24:	2f636367 	svccs	0x00636367
    1f28:	692f2e2e 	stmdbvs	pc!, {r1, r2, r3, r5, r9, sl, fp, sp}	; <UNPREDICTABLE>
    1f2c:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
    1f30:	2e006564 	cfsh32cs	mvfx6, mvfx0, #52
    1f34:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1f38:	2f2e2e2f 	svccs	0x002e2e2f
    1f3c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1f40:	2f2e2f2e 	svccs	0x002e2f2e
    1f44:	00636367 	rsbeq	r6, r3, r7, ror #6
    1f48:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1f4c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1f50:	2f2e2e2f 	svccs	0x002e2e2f
    1f54:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1f58:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
    1f5c:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    1f60:	2f2e2e2f 	svccs	0x002e2e2f
    1f64:	2f636367 	svccs	0x00636367
    1f68:	666e6f63 	strbtvs	r6, [lr], -r3, ror #30
    1f6c:	612f6769 			; <UNDEFINED> instruction: 0x612f6769
    1f70:	2e006d72 	mcrcs	13, 0, r6, cr0, cr2, {3}
    1f74:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1f78:	2f2e2e2f 	svccs	0x002e2e2f
    1f7c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1f80:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1f84:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    1f88:	00636367 	rsbeq	r6, r3, r7, ror #6
    1f8c:	73616800 	cmnvc	r1, #0, 16
    1f90:	62617468 	rsbvs	r7, r1, #104, 8	; 0x68000000
    1f94:	0100682e 	tsteq	r0, lr, lsr #16
    1f98:	72610000 	rsbvc	r0, r1, #0
    1f9c:	73692d6d 	cmnvc	r9, #6976	; 0x1b40
    1fa0:	00682e61 	rsbeq	r2, r8, r1, ror #28
    1fa4:	61000002 	tstvs	r0, r2
    1fa8:	632d6d72 			; <UNDEFINED> instruction: 0x632d6d72
    1fac:	682e7570 	stmdavs	lr!, {r4, r5, r6, r8, sl, ip, sp, lr}
    1fb0:	00000200 	andeq	r0, r0, r0, lsl #4
    1fb4:	6e736e69 	cdpvs	14, 7, cr6, cr3, cr9, {3}
    1fb8:	6e6f632d 	cdpvs	3, 6, cr6, cr15, cr13, {1}
    1fbc:	6e617473 	mcrvs	4, 3, r7, cr1, cr3, {3}
    1fc0:	682e7374 	stmdavs	lr!, {r2, r4, r5, r6, r8, r9, ip, sp, lr}
    1fc4:	00000200 	andeq	r0, r0, r0, lsl #4
    1fc8:	2e6d7261 	cdpcs	2, 6, cr7, cr13, cr1, {3}
    1fcc:	00030068 	andeq	r0, r3, r8, rrx
    1fd0:	62696c00 	rsbvs	r6, r9, #0, 24
    1fd4:	32636367 	rsbcc	r6, r3, #-1677721599	; 0x9c000001
    1fd8:	0400682e 	streq	r6, [r0], #-2094	; 0xfffff7d2
    1fdc:	62670000 	rsbvs	r0, r7, #0
    1fe0:	74632d6c 	strbtvc	r2, [r3], #-3436	; 0xfffff294
    1fe4:	2e73726f 	cdpcs	2, 7, cr7, cr3, cr15, {3}
    1fe8:	00040068 	andeq	r0, r4, r8, rrx
    1fec:	62696c00 	rsbvs	r6, r9, #0, 24
    1ff0:	32636367 	rsbcc	r6, r3, #-1677721599	; 0x9c000001
    1ff4:	0400632e 	streq	r6, [r0], #-814	; 0xfffffcd2
    1ff8:	Address 0x0000000000001ff8 is out of bounds.


Disassembly of section .debug_str:

00000000 <.debug_str>:
       0:	20554e47 	subscs	r4, r5, r7, asr #28
       4:	312b2b43 			; <UNDEFINED> instruction: 0x312b2b43
       8:	2e392034 	mrccs	0, 1, r2, cr9, cr4, {1}
       c:	20312e32 	eorscs	r2, r1, r2, lsr lr
      10:	39313032 	ldmdbcc	r1!, {r1, r4, r5, ip, sp}
      14:	35323031 	ldrcc	r3, [r2, #-49]!	; 0xffffffcf
      18:	65722820 	ldrbvs	r2, [r2, #-2080]!	; 0xfffff7e0
      1c:	7361656c 	cmnvc	r1, #108, 10	; 0x1b000000
      20:	5b202965 	blpl	80a5bc <_bss_end+0x7fe758>
      24:	2f4d5241 	svccs	0x004d5241
      28:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
      2c:	72622d39 	rsbvc	r2, r2, #3648	; 0xe40
      30:	68636e61 	stmdavs	r3!, {r0, r5, r6, r9, sl, fp, sp, lr}^
      34:	76657220 	strbtvc	r7, [r5], -r0, lsr #4
      38:	6f697369 	svcvs	0x00697369
      3c:	3732206e 	ldrcc	r2, [r2, -lr, rrx]!
      40:	39393537 	ldmdbcc	r9!, {r0, r1, r2, r4, r5, r8, sl, ip, sp}
      44:	6d2d205d 	stcvs	0, cr2, [sp, #-372]!	; 0xfffffe8c
      48:	616f6c66 	cmnvs	pc, r6, ror #24
      4c:	62612d74 	rsbvs	r2, r1, #116, 26	; 0x1d00
      50:	61683d69 	cmnvs	r8, r9, ror #26
      54:	2d206472 	cfstrscs	mvf6, [r0, #-456]!	; 0xfffffe38
      58:	7570666d 	ldrbvc	r6, [r0, #-1645]!	; 0xfffff993
      5c:	7066763d 	rsbvc	r7, r6, sp, lsr r6
      60:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
      64:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
      68:	6962612d 	stmdbvs	r2!, {r0, r2, r3, r5, r8, sp, lr}^
      6c:	7261683d 	rsbvc	r6, r1, #3997696	; 0x3d0000
      70:	6d2d2064 	stcvs	0, cr2, [sp, #-400]!	; 0xfffffe70
      74:	3d757066 	ldclcc	0, cr7, [r5, #-408]!	; 0xfffffe68
      78:	20706676 	rsbscs	r6, r0, r6, ror r6
      7c:	75746d2d 	ldrbvc	r6, [r4, #-3373]!	; 0xfffff2d3
      80:	613d656e 	teqvs	sp, lr, ror #10
      84:	31316d72 	teqcc	r1, r2, ror sp
      88:	7a6a3637 	bvc	1a8d96c <_bss_end+0x1a81b08>
      8c:	20732d66 	rsbscs	r2, r3, r6, ror #26
      90:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
      94:	6d2d206d 	stcvs	0, cr2, [sp, #-436]!	; 0xfffffe4c
      98:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
      9c:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
      a0:	6b7a3676 	blvs	1e8da80 <_bss_end+0x1e81c1c>
      a4:	2070662b 	rsbscs	r6, r0, fp, lsr #12
      a8:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
      ac:	4f2d2067 	svcmi	0x002d2067
      b0:	4f2d2030 	svcmi	0x002d2030
      b4:	682f0030 	stmdavs	pc!, {r4, r5}	; <UNPREDICTABLE>
      b8:	2f656d6f 	svccs	0x00656d6f
      bc:	686c6973 	stmdavs	ip!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
      c0:	6a797661 	bvs	1e5da4c <_bss_end+0x1e51be8>
      c4:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
      c8:	2f6c6f6f 	svccs	0x006c6f6f
      cc:	6f72655a 	svcvs	0x0072655a
      d0:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
      d4:	6178652f 	cmnvs	r8, pc, lsr #10
      d8:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
      dc:	33312f73 	teqcc	r1, #460	; 0x1cc
      e0:	6e6f632d 	cdpvs	3, 6, cr6, cr15, cr13, {1}
      e4:	74786574 	ldrbtvc	r6, [r8], #-1396	; 0xfffffa8c
      e8:	6977735f 	ldmdbvs	r7!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, sp, lr}^
      ec:	5f686374 	svcpl	0x00686374
      f0:	696e6f6d 	stmdbvs	lr!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
      f4:	2f726f74 	svccs	0x00726f74
      f8:	6c697562 	cfstr64vs	mvdx7, [r9], #-392	; 0xfffffe78
      fc:	5f5f0064 	svcpl	0x005f0064
     100:	5f617863 	svcpl	0x00617863
     104:	72617567 	rsbvc	r7, r1, #432013312	; 0x19c00000
     108:	65725f64 	ldrbvs	r5, [r2, #-3940]!	; 0xfffff09c
     10c:	7361656c 	cmnvc	r1, #108, 10	; 0x1b000000
     110:	5f5f0065 	svcpl	0x005f0065
     114:	5f617863 	svcpl	0x00617863
     118:	72617567 	rsbvc	r7, r1, #432013312	; 0x19c00000
     11c:	62615f64 	rsbvs	r5, r1, #100, 30	; 0x190
     120:	0074726f 	rsbseq	r7, r4, pc, ror #4
     124:	73645f5f 	cmnvc	r4, #380	; 0x17c
     128:	61685f6f 	cmnvs	r8, pc, ror #30
     12c:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     130:	635f5f00 	cmpvs	pc, #0, 30
     134:	615f6178 	cmpvs	pc, r8, ror r1	; <UNPREDICTABLE>
     138:	69786574 	ldmdbvs	r8!, {r2, r4, r5, r6, r8, sl, sp, lr}^
     13c:	5f5f0074 	svcpl	0x005f0074
     140:	72617567 	rsbvc	r7, r1, #432013312	; 0x19c00000
     144:	5f5f0064 	svcpl	0x005f0064
     148:	5f617863 	svcpl	0x00617863
     14c:	72617567 	rsbvc	r7, r1, #432013312	; 0x19c00000
     150:	63615f64 	cmnvs	r1, #100, 30	; 0x190
     154:	72697571 	rsbvc	r7, r9, #473956352	; 0x1c400000
     158:	5f5f0065 	svcpl	0x005f0065
     15c:	61787863 	cmnvs	r8, r3, ror #16
     160:	31766962 	cmncc	r6, r2, ror #18
     164:	635f5f00 	cmpvs	pc, #0, 30
     168:	705f6178 	subsvc	r6, pc, r8, ror r1	; <UNPREDICTABLE>
     16c:	5f657275 	svcpl	0x00657275
     170:	74726976 	ldrbtvc	r6, [r2], #-2422	; 0xfffff68a
     174:	006c6175 	rsbeq	r6, ip, r5, ror r1
     178:	65615f5f 	strbvs	r5, [r1, #-3935]!	; 0xfffff0a1
     17c:	5f696261 	svcpl	0x00696261
     180:	69776e75 	ldmdbvs	r7!, {r0, r2, r4, r5, r6, r9, sl, fp, sp, lr}^
     184:	635f646e 	cmpvs	pc, #1845493760	; 0x6e000000
     188:	705f7070 	subsvc	r7, pc, r0, ror r0	; <UNPREDICTABLE>
     18c:	2f003172 	svccs	0x00003172
     190:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     194:	6c69732f 	stclvs	3, cr7, [r9], #-188	; 0xffffff44
     198:	79766168 	ldmdbvc	r6!, {r3, r5, r6, r8, sp, lr}^
     19c:	63532f6a 	cmpvs	r3, #424	; 0x1a8
     1a0:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; 8 <shift+0x8>
     1a4:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
     1a8:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
     1ac:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
     1b0:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
     1b4:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
     1b8:	6f632d33 	svcvs	0x00632d33
     1bc:	7865746e 	stmdavc	r5!, {r1, r2, r3, r5, r6, sl, ip, sp, lr}^
     1c0:	77735f74 			; <UNDEFINED> instruction: 0x77735f74
     1c4:	68637469 	stmdavs	r3!, {r0, r3, r5, r6, sl, ip, sp, lr}^
     1c8:	6e6f6d5f 	mcrvs	13, 3, r6, cr15, cr15, {2}
     1cc:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
     1d0:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
     1d4:	2f6c656e 	svccs	0x006c656e
     1d8:	2f637273 	svccs	0x00637273
     1dc:	2e787863 	cdpcs	8, 7, cr7, cr8, cr3, {3}
     1e0:	00707063 	rsbseq	r7, r0, r3, rrx
     1e4:	676e6f6c 	strbvs	r6, [lr, -ip, ror #30]!
     1e8:	6e6f6c20 	cdpvs	12, 6, cr6, cr15, cr0, {1}
     1ec:	6e692067 	cdpvs	0, 6, cr2, cr9, cr7, {3}
     1f0:	5a5f0074 	bpl	17c03c8 <_bss_end+0x17b4564>
     1f4:	33314b4e 	teqcc	r1, #79872	; 0x13800
     1f8:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     1fc:	61485f4f 	cmpvs	r8, pc, asr #30
     200:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     204:	47383172 			; <UNDEFINED> instruction: 0x47383172
     208:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     20c:	56454c50 			; <UNDEFINED> instruction: 0x56454c50
     210:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     214:	6f697461 	svcvs	0x00697461
     218:	526a456e 	rsbpl	r4, sl, #461373440	; 0x1b800000
     21c:	5f30536a 	svcpl	0x0030536a
     220:	53504700 	cmppl	r0, #0, 14
     224:	00305445 	eorseq	r5, r0, r5, asr #8
     228:	45535047 	ldrbmi	r5, [r3, #-71]	; 0xffffffb9
     22c:	47003154 	smlsdmi	r0, r4, r1, r3
     230:	45534650 	ldrbmi	r4, [r3, #-1616]	; 0xfffff9b0
     234:	4700304c 	strmi	r3, [r0, -ip, asr #32]
     238:	45534650 	ldrbmi	r4, [r3, #-1616]	; 0xfffff9b0
     23c:	4700314c 	strmi	r3, [r0, -ip, asr #2]
     240:	45534650 	ldrbmi	r4, [r3, #-1616]	; 0xfffff9b0
     244:	4700324c 	strmi	r3, [r0, -ip, asr #4]
     248:	45534650 	ldrbmi	r4, [r3, #-1616]	; 0xfffff9b0
     24c:	4700334c 	strmi	r3, [r0, -ip, asr #6]
     250:	45534650 	ldrbmi	r4, [r3, #-1616]	; 0xfffff9b0
     254:	4700344c 	strmi	r3, [r0, -ip, asr #8]
     258:	45534650 	ldrbmi	r4, [r3, #-1616]	; 0xfffff9b0
     25c:	4700354c 	strmi	r3, [r0, -ip, asr #10]
     260:	4e454650 	mcrmi	6, 2, r4, cr5, cr0, {2}
     264:	6e490031 	mcrvs	0, 2, r0, cr9, cr1, {1}
     268:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
     26c:	5f747075 	svcpl	0x00747075
     270:	746e6f43 	strbtvc	r6, [lr], #-3907	; 0xfffff0bd
     274:	6c6c6f72 	stclvs	15, cr6, [ip], #-456	; 0xfffffe38
     278:	425f7265 	subsmi	r7, pc, #1342177286	; 0x50000006
     27c:	00657361 	rsbeq	r7, r5, r1, ror #6
     280:	726f6873 	rsbvc	r6, pc, #7536640	; 0x730000
     284:	6e692074 	mcrvs	0, 3, r2, cr9, cr4, {3}
     288:	50470074 	subpl	r0, r7, r4, ror r0
     28c:	43445550 	movtmi	r5, #17744	; 0x4550
     290:	00304b4c 	eorseq	r4, r0, ip, asr #22
     294:	55505047 	ldrbpl	r5, [r0, #-71]	; 0xffffffb9
     298:	4b4c4344 	blmi	1310fb0 <_bss_end+0x130514c>
     29c:	50470031 	subpl	r0, r7, r1, lsr r0
     2a0:	304e4552 	subcc	r4, lr, r2, asr r5
     2a4:	52504700 	subspl	r4, r0, #0, 14
     2a8:	00314e45 	eorseq	r4, r1, r5, asr #28
     2ac:	314e5a5f 	cmpcc	lr, pc, asr sl
     2b0:	50474333 	subpl	r4, r7, r3, lsr r3
     2b4:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     2b8:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     2bc:	30317265 	eorscc	r7, r1, r5, ror #4
     2c0:	5f746553 	svcpl	0x00746553
     2c4:	7074754f 	rsbsvc	r7, r4, pc, asr #10
     2c8:	6a457475 	bvs	115d4a4 <_bss_end+0x1151640>
     2cc:	5a5f0062 	bpl	17c045c <_bss_end+0x17b45f8>
     2d0:	33314b4e 	teqcc	r1, #79872	; 0x13800
     2d4:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     2d8:	61485f4f 	cmpvs	r8, pc, asr #30
     2dc:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     2e0:	47393172 			; <UNDEFINED> instruction: 0x47393172
     2e4:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     2e8:	45534650 	ldrbmi	r4, [r3, #-1616]	; 0xfffff9b0
     2ec:	6f4c5f4c 	svcvs	0x004c5f4c
     2f0:	69746163 	ldmdbvs	r4!, {r0, r1, r5, r6, r8, sp, lr}^
     2f4:	6a456e6f 	bvs	115bcb8 <_bss_end+0x114fe54>
     2f8:	30536a52 	subscc	r6, r3, r2, asr sl
     2fc:	476d005f 			; <UNDEFINED> instruction: 0x476d005f
     300:	004f4950 	subeq	r4, pc, r0, asr r9	; <UNPREDICTABLE>
     304:	314e5a5f 	cmpcc	lr, pc, asr sl
     308:	50474333 	subpl	r4, r7, r3, lsr r3
     30c:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     310:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     314:	34437265 	strbcc	r7, [r3], #-613	; 0xfffffd9b
     318:	47006a45 	strmi	r6, [r0, -r5, asr #20]
     31c:	53444550 	movtpl	r4, #17744	; 0x4550
     320:	50470030 	subpl	r0, r7, r0, lsr r0
     324:	31534445 	cmpcc	r3, r5, asr #8
     328:	6e697500 	cdpvs	5, 6, cr7, cr9, cr0, {0}
     32c:	5f323374 	svcpl	0x00323374
     330:	6f620074 	svcvs	0x00620074
     334:	55006c6f 	strpl	r6, [r0, #-3183]	; 0xfffff391
     338:	6570736e 	ldrbvs	r7, [r0, #-878]!	; 0xfffffc92
     33c:	69666963 	stmdbvs	r6!, {r0, r1, r5, r6, r8, fp, sp, lr}^
     340:	47006465 	strmi	r6, [r0, -r5, ror #8]
     344:	4e454c50 	mcrmi	12, 2, r4, cr5, cr0, {2}
     348:	75660030 	strbvc	r0, [r6, #-48]!	; 0xffffffd0
     34c:	4700636e 	strmi	r6, [r0, -lr, ror #6]
     350:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     354:	5f4f4950 	svcpl	0x004f4950
     358:	636e7546 	cmnvs	lr, #293601280	; 0x11800000
     35c:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     360:	50474300 	subpl	r4, r7, r0, lsl #6
     364:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     368:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     36c:	47007265 	strmi	r7, [r0, -r5, ror #4]
     370:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     374:	54455350 	strbpl	r5, [r5], #-848	; 0xfffffcb0
     378:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     37c:	6f697461 	svcvs	0x00697461
     380:	5047006e 	subpl	r0, r7, lr, rrx
     384:	00445550 	subeq	r5, r4, r0, asr r5
     388:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 2d4 <CPSR_IRQ_INHIBIT+0x254>
     38c:	69732f65 	ldmdbvs	r3!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
     390:	7661686c 	strbtvc	r6, [r1], -ip, ror #16
     394:	532f6a79 			; <UNDEFINED> instruction: 0x532f6a79
     398:	6f6f6863 	svcvs	0x006f6863
     39c:	655a2f6c 	ldrbvs	r2, [sl, #-3948]	; 0xfffff094
     3a0:	614d6f72 	hvcvs	55026	; 0xd6f2
     3a4:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffe38 <_bss_end+0xffff3fd4>
     3a8:	706d6178 	rsbvc	r6, sp, r8, ror r1
     3ac:	2f73656c 	svccs	0x0073656c
     3b0:	632d3331 			; <UNDEFINED> instruction: 0x632d3331
     3b4:	65746e6f 	ldrbvs	r6, [r4, #-3695]!	; 0xfffff191
     3b8:	735f7478 	cmpvc	pc, #120, 8	; 0x78000000
     3bc:	63746977 	cmnvs	r4, #1949696	; 0x1dc000
     3c0:	6f6d5f68 	svcvs	0x006d5f68
     3c4:	6f74696e 	svcvs	0x0074696e
     3c8:	656b2f72 	strbvs	r2, [fp, #-3954]!	; 0xfffff08e
     3cc:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
     3d0:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
     3d4:	6972642f 	ldmdbvs	r2!, {r0, r1, r2, r3, r5, sl, sp, lr}^
     3d8:	73726576 	cmnvc	r2, #494927872	; 0x1d800000
     3dc:	6970672f 	ldmdbvs	r0!, {r0, r1, r2, r3, r5, r8, r9, sl, sp, lr}^
     3e0:	70632e6f 	rsbvc	r2, r3, pc, ror #28
     3e4:	65500070 	ldrbvs	r0, [r0, #-112]	; 0xffffff90
     3e8:	68706972 	ldmdavs	r0!, {r1, r4, r5, r6, r8, fp, sp, lr}^
     3ec:	6c617265 	sfmvs	f7, 2, [r1], #-404	; 0xfffffe6c
     3f0:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
     3f4:	65470065 	strbvs	r0, [r7, #-101]	; 0xffffff9b
     3f8:	50475f74 	subpl	r5, r7, r4, ror pc
     3fc:	5f56454c 	svcpl	0x0056454c
     400:	61636f4c 	cmnvs	r3, ip, asr #30
     404:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     408:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     40c:	4333314b 	teqmi	r3, #-1073741806	; 0xc0000012
     410:	4f495047 	svcmi	0x00495047
     414:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     418:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     41c:	65473731 	strbvs	r3, [r7, #-1841]	; 0xfffff8cf
     420:	50475f74 	subpl	r5, r7, r4, ror pc
     424:	465f4f49 	ldrbmi	r4, [pc], -r9, asr #30
     428:	74636e75 	strbtvc	r6, [r3], #-3701	; 0xfffff18b
     42c:	456e6f69 	strbmi	r6, [lr, #-3945]!	; 0xfffff097
     430:	5f5f006a 	svcpl	0x005f006a
     434:	74696e69 	strbtvc	r6, [r9], #-3689	; 0xfffff197
     438:	696c6169 	stmdbvs	ip!, {r0, r3, r5, r6, r8, sp, lr}^
     43c:	705f657a 	subsvc	r6, pc, sl, ror r5	; <UNPREDICTABLE>
     440:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     444:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     448:	5f4f4950 	svcpl	0x004f4950
     44c:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     450:	4372656c 	cmnmi	r2, #108, 10	; 0x1b000000
     454:	006a4532 	rsbeq	r4, sl, r2, lsr r5
     458:	46415047 	strbmi	r5, [r1], -r7, asr #32
     45c:	00304e45 	eorseq	r4, r0, r5, asr #28
     460:	46415047 	strbmi	r5, [r1], -r7, asr #32
     464:	00314e45 	eorseq	r4, r1, r5, asr #28
     468:	4b4e5a5f 	blmi	1396dec <_bss_end+0x138af88>
     46c:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     470:	5f4f4950 	svcpl	0x004f4950
     474:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     478:	3172656c 	cmncc	r2, ip, ror #10
     47c:	74654738 	strbtvc	r4, [r5], #-1848	; 0xfffff8c8
     480:	4350475f 	cmpmi	r0, #24903680	; 0x17c0000
     484:	4c5f524c 	lfmmi	f5, 2, [pc], {76}	; 0x4c
     488:	7461636f 	strbtvc	r6, [r1], #-879	; 0xfffffc91
     48c:	456e6f69 	strbmi	r6, [lr, #-3945]!	; 0xfffff097
     490:	536a526a 	cmnpl	sl, #-1610612730	; 0xa0000006
     494:	75005f30 	strvc	r5, [r0, #-3888]	; 0xfffff0d0
     498:	6769736e 	strbvs	r7, [r9, -lr, ror #6]!
     49c:	2064656e 	rsbcs	r6, r4, lr, ror #10
     4a0:	72616863 	rsbvc	r6, r1, #6488064	; 0x630000
     4a4:	4c475f00 	mcrrmi	15, 0, r5, r7, cr0
     4a8:	4c41424f 	sfmmi	f4, 2, [r1], {79}	; 0x4f
     4ac:	75735f5f 	ldrbvc	r5, [r3, #-3935]!	; 0xfffff0a1
     4b0:	5f495f62 	svcpl	0x00495f62
     4b4:	49504773 	ldmdbmi	r0, {r0, r1, r4, r5, r6, r8, r9, sl, lr}^
     4b8:	6547004f 	strbvs	r0, [r7, #-79]	; 0xffffffb1
     4bc:	6e495f74 	mcrvs	15, 2, r5, cr9, cr4, {3}
     4c0:	00747570 	rsbseq	r7, r4, r0, ror r5
     4c4:	4f495047 	svcmi	0x00495047
     4c8:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
     4cc:	50470065 	subpl	r0, r7, r5, rrx
     4d0:	31524c43 	cmpcc	r2, r3, asr #24
     4d4:	41504700 	cmpmi	r0, r0, lsl #14
     4d8:	304e4552 	subcc	r4, lr, r2, asr r5
     4dc:	41504700 	cmpmi	r0, r0, lsl #14
     4e0:	314e4552 	cmpcc	lr, r2, asr r5
     4e4:	48504700 	ldmdami	r0, {r8, r9, sl, lr}^
     4e8:	00304e45 	eorseq	r4, r0, r5, asr #28
     4ec:	45485047 	strbmi	r5, [r8, #-71]	; 0xffffffb9
     4f0:	6700314e 	strvs	r3, [r0, -lr, asr #2]
     4f4:	5f6f6970 	svcpl	0x006f6970
     4f8:	65736162 	ldrbvs	r6, [r3, #-354]!	; 0xfffffe9e
     4fc:	6464615f 	strbtvs	r6, [r4], #-351	; 0xfffffea1
     500:	68730072 	ldmdavs	r3!, {r1, r4, r5, r6}^
     504:	2074726f 	rsbscs	r7, r4, pc, ror #4
     508:	69736e75 	ldmdbvs	r3!, {r0, r2, r4, r5, r6, r9, sl, fp, sp, lr}^
     50c:	64656e67 	strbtvs	r6, [r5], #-3687	; 0xfffff199
     510:	746e6920 	strbtvc	r6, [lr], #-2336	; 0xfffff6e0
     514:	4c504700 	mrrcmi	7, 0, r4, r0, cr0
     518:	00314e45 	eorseq	r4, r1, r5, asr #28
     51c:	5f746547 	svcpl	0x00746547
     520:	53465047 	movtpl	r5, #24647	; 0x6047
     524:	4c5f4c45 	mrrcmi	12, 4, r4, pc, cr5	; <UNPREDICTABLE>
     528:	7461636f 	strbtvc	r6, [r1], #-879	; 0xfffffc91
     52c:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     530:	4f495047 	svcmi	0x00495047
     534:	6e69505f 	mcrvs	0, 3, r5, cr9, cr15, {2}
     538:	756f435f 	strbvc	r4, [pc, #-863]!	; 1e1 <CPSR_IRQ_INHIBIT+0x161>
     53c:	6d00746e 	cfstrsvs	mvf7, [r0, #-440]	; 0xfffffe48
     540:	0065646f 	rsbeq	r6, r5, pc, ror #8
     544:	656d6954 	strbvs	r6, [sp, #-2388]!	; 0xfffff6ac
     548:	61425f72 	hvcvs	9714	; 0x25f2
     54c:	5f006573 	svcpl	0x00006573
     550:	6174735f 	cmnvs	r4, pc, asr r3
     554:	5f636974 	svcpl	0x00636974
     558:	74696e69 	strbtvc	r6, [r9], #-3689	; 0xfffff197
     55c:	696c6169 	stmdbvs	ip!, {r0, r3, r5, r6, r8, sp, lr}^
     560:	6974617a 	ldmdbvs	r4!, {r1, r3, r4, r5, r6, r8, sp, lr}^
     564:	615f6e6f 	cmpvs	pc, pc, ror #28
     568:	645f646e 	ldrbvs	r6, [pc], #-1134	; 570 <CPSR_IRQ_INHIBIT+0x4f0>
     56c:	72747365 	rsbsvc	r7, r4, #-1811939327	; 0x94000001
     570:	69746375 	ldmdbvs	r4!, {r0, r2, r4, r5, r6, r8, r9, sp, lr}^
     574:	305f6e6f 	subscc	r6, pc, pc, ror #28
     578:	49504700 	ldmdbmi	r0, {r8, r9, sl, lr}^
     57c:	65525f4f 	ldrbvs	r5, [r2, #-3919]	; 0xfffff0b1
     580:	68740067 	ldmdavs	r4!, {r0, r1, r2, r5, r6}^
     584:	5f007369 	svcpl	0x00007369
     588:	33314e5a 	teqcc	r1, #1440	; 0x5a0
     58c:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     590:	61485f4f 	cmpvs	r8, pc, asr #30
     594:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     598:	53373172 	teqpl	r7, #-2147483620	; 0x8000001c
     59c:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     5a0:	5f4f4950 	svcpl	0x004f4950
     5a4:	636e7546 	cmnvs	lr, #293601280	; 0x11800000
     5a8:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     5ac:	34316a45 	ldrtcc	r6, [r1], #-2629	; 0xfffff5bb
     5b0:	4950474e 	ldmdbmi	r0, {r1, r2, r3, r6, r8, r9, sl, lr}^
     5b4:	75465f4f 	strbvc	r5, [r6, #-3919]	; 0xfffff0b1
     5b8:	6974636e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, r9, sp, lr}^
     5bc:	41006e6f 	tstmi	r0, pc, ror #28
     5c0:	325f746c 	subscc	r7, pc, #108, 8	; 0x6c000000
     5c4:	4c504700 	mrrcmi	7, 0, r4, r0, cr0
     5c8:	00305645 	eorseq	r5, r0, r5, asr #12
     5cc:	454c5047 	strbmi	r5, [ip, #-71]	; 0xffffffb9
     5d0:	53003156 	movwpl	r3, #342	; 0x156
     5d4:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     5d8:	5f4f4950 	svcpl	0x004f4950
     5dc:	636e7546 	cmnvs	lr, #293601280	; 0x11800000
     5e0:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     5e4:	74696200 	strbtvc	r6, [r9], #-512	; 0xfffffe00
     5e8:	7864695f 	stmdavc	r4!, {r0, r1, r2, r3, r4, r6, r8, fp, sp, lr}^
     5ec:	705f5f00 	subsvc	r5, pc, r0, lsl #30
     5f0:	726f6972 	rsbvc	r6, pc, #1867776	; 0x1c8000
     5f4:	00797469 	rsbseq	r7, r9, r9, ror #8
     5f8:	4b4e5a5f 	blmi	1396f7c <_bss_end+0x138b118>
     5fc:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     600:	5f4f4950 	svcpl	0x004f4950
     604:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     608:	3172656c 	cmncc	r2, ip, ror #10
     60c:	74654738 	strbtvc	r4, [r5], #-1848	; 0xfffff8c8
     610:	5350475f 	cmppl	r0, #24903680	; 0x17c0000
     614:	4c5f5445 	cfldrdmi	mvd5, [pc], {69}	; 0x45
     618:	7461636f 	strbtvc	r6, [r1], #-879	; 0xfffffc91
     61c:	456e6f69 	strbmi	r6, [lr, #-3945]!	; 0xfffff097
     620:	536a526a 	cmnpl	sl, #-1610612730	; 0xa0000006
     624:	41005f30 	tstmi	r0, r0, lsr pc
     628:	425f5855 	subsmi	r5, pc, #5570560	; 0x550000
     62c:	00657361 	rsbeq	r7, r5, r1, ror #6
     630:	5f746547 	svcpl	0x00746547
     634:	4c435047 	mcrrmi	0, 4, r5, r3, cr7
     638:	6f4c5f52 	svcvs	0x004c5f52
     63c:	69746163 	ldmdbvs	r4!, {r0, r1, r5, r6, r8, sp, lr}^
     640:	47006e6f 	strmi	r6, [r0, -pc, ror #28]
     644:	4e454650 	mcrmi	6, 2, r4, cr5, cr0, {2}
     648:	65530030 	ldrbvs	r0, [r3, #-48]	; 0xffffffd0
     64c:	754f5f74 	strbvc	r5, [pc, #-3956]	; fffff6e0 <_bss_end+0xffff387c>
     650:	74757074 	ldrbtvc	r7, [r5], #-116	; 0xffffff8c
     654:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     658:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     65c:	5f4f4950 	svcpl	0x004f4950
     660:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     664:	3972656c 	ldmdbcc	r2!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     668:	5f746547 	svcpl	0x00746547
     66c:	75706e49 	ldrbvc	r6, [r0, #-3657]!	; 0xfffff1b7
     670:	006a4574 	rsbeq	r4, sl, r4, ror r5
     674:	5f746c41 	svcpl	0x00746c41
     678:	6c410030 	mcrrvs	0, 3, r0, r1, cr0
     67c:	00315f74 	eorseq	r5, r1, r4, ror pc
     680:	61666544 	cmnvs	r6, r4, asr #10
     684:	5f746c75 	svcpl	0x00746c75
     688:	636f6c43 	cmnvs	pc, #17152	; 0x4300
     68c:	61525f6b 	cmpvs	r2, fp, ror #30
     690:	41006574 	tstmi	r0, r4, ror r5
     694:	335f746c 	cmpcc	pc, #108, 8	; 0x6c000000
     698:	746c4100 	strbtvc	r4, [ip], #-256	; 0xffffff00
     69c:	4100345f 	tstmi	r0, pc, asr r4
     6a0:	355f746c 	ldrbcc	r7, [pc, #-1132]	; 23c <CPSR_IRQ_INHIBIT+0x1bc>
     6a4:	43504700 	cmpmi	r0, #0, 14
     6a8:	0030524c 	eorseq	r5, r0, ip, asr #4
     6ac:	6f726353 	svcvs	0x00726353
     6b0:	76006c6c 	strvc	r6, [r0], -ip, ror #24
     6b4:	65756c61 	ldrbvs	r6, [r5, #-3169]!	; 0xfffff39f
     6b8:	6f757100 	svcvs	0x00757100
     6bc:	6e656974 			; <UNDEFINED> instruction: 0x6e656974
     6c0:	5f6d0074 	svcpl	0x006d0074
     6c4:	626d756e 	rsbvs	r7, sp, #461373440	; 0x1b800000
     6c8:	625f7265 	subsvs	r7, pc, #1342177286	; 0x50000006
     6cc:	00657361 	rsbeq	r7, r5, r1, ror #6
     6d0:	65736552 	ldrbvs	r6, [r3, #-1362]!	; 0xfffffaae
     6d4:	754e5f74 	strbvc	r5, [lr, #-3956]	; 0xfffff08c
     6d8:	7265626d 	rsbvc	r6, r5, #-805306362	; 0xd0000006
     6dc:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
     6e0:	5a5f0065 	bpl	17c087c <_bss_end+0x17b4a18>
     6e4:	4d43384e 	stclmi	8, cr3, [r3, #-312]	; 0xfffffec8
     6e8:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
     6ec:	5239726f 	eorspl	r7, r9, #-268435450	; 0xf0000006
     6f0:	69616d65 	stmdbvs	r1!, {r0, r2, r5, r6, r8, sl, fp, sp, lr}^
     6f4:	7265646e 	rsbvc	r6, r5, #1845493760	; 0x6e000000
     6f8:	006a6a45 	rsbeq	r6, sl, r5, asr #20
     6fc:	384e5a5f 	stmdacc	lr, {r0, r1, r2, r3, r4, r6, r9, fp, ip, lr}^
     700:	6e6f4d43 	cdpvs	13, 6, cr4, cr15, cr3, {2}
     704:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
     708:	6a453243 	bvs	114d01c <_bss_end+0x11411b8>
     70c:	5f006a6a 	svcpl	0x00006a6a
     710:	43384e5a 	teqmi	r8, #1440	; 0x5a0
     714:	696e6f4d 	stmdbvs	lr!, {r0, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     718:	31726f74 	cmncc	r2, r4, ror pc
     71c:	6a644133 	bvs	1910bf0 <_bss_end+0x1904d8c>
     720:	5f747375 	svcpl	0x00747375
     724:	73727543 	cmnvc	r2, #281018368	; 0x10c00000
     728:	7645726f 	strbvc	r7, [r5], -pc, ror #4
     72c:	6f746900 	svcvs	0x00746900
     730:	65520061 	ldrbvs	r0, [r2, #-97]	; 0xffffff9f
     734:	5f746573 	svcpl	0x00746573
     738:	73727543 	cmnvc	r2, #281018368	; 0x10c00000
     73c:	4100726f 	tstmi	r0, pc, ror #4
     740:	73756a64 	cmnvc	r5, #100, 20	; 0x64000
     744:	75435f74 	strbvc	r5, [r3, #-3956]	; 0xfffff08c
     748:	726f7372 	rsbvc	r7, pc, #-939524095	; 0xc8000001
     74c:	76694400 	strbtvc	r4, [r9], -r0, lsl #8
     750:	00656469 	rsbeq	r6, r5, r9, ror #8
     754:	6d754e4e 	ldclvs	14, cr4, [r5, #-312]!	; 0xfffffec8
     758:	5f726562 	svcpl	0x00726562
     75c:	65736142 	ldrbvs	r6, [r3, #-322]!	; 0xfffffebe
     760:	6f505400 	svcvs	0x00505400
     764:	69746973 	ldmdbvs	r4!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
     768:	5f006e6f 	svcpl	0x00006e6f
     76c:	43384e5a 	teqmi	r8, #1440	; 0x5a0
     770:	696e6f4d 	stmdbvs	lr!, {r0, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     774:	31726f74 	cmncc	r2, r4, ror pc
     778:	73655237 	cmnvc	r5, #1879048195	; 0x70000003
     77c:	4e5f7465 	cdpmi	4, 5, cr7, cr15, cr5, {3}
     780:	65626d75 	strbvs	r6, [r2, #-3445]!	; 0xfffff28b
     784:	61425f72 	hvcvs	9714	; 0x25f2
     788:	76456573 			; <UNDEFINED> instruction: 0x76456573
     78c:	6d5f6d00 	ldclvs	13, cr6, [pc, #-0]	; 794 <CPSR_IRQ_INHIBIT+0x714>
     790:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
     794:	5f00726f 	svcpl	0x0000726f
     798:	424f4c47 	submi	r4, pc, #18176	; 0x4700
     79c:	5f5f4c41 	svcpl	0x005f4c41
     7a0:	5f627573 	svcpl	0x00627573
     7a4:	4d735f49 	ldclmi	15, cr5, [r3, #-292]!	; 0xfffffedc
     7a8:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
     7ac:	6d00726f 	sfmvs	f7, 4, [r0, #-444]	; 0xfffffe44
     7b0:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
     7b4:	625f726f 	subsvs	r7, pc, #-268435450	; 0xf0000006
     7b8:	5f657361 	svcpl	0x00657361
     7bc:	72646461 	rsbvc	r6, r4, #1627389952	; 0x61000000
     7c0:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     7c4:	6f4d4338 	svcvs	0x004d4338
     7c8:	6f74696e 	svcvs	0x0074696e
     7cc:	6c433572 	cfstr64vs	mvdx3, [r3], {114}	; 0x72
     7d0:	45726165 	ldrbmi	r6, [r2, #-357]!	; 0xfffffe9b
     7d4:	5a5f0076 	bpl	17c09b4 <_bss_end+0x17b4b50>
     7d8:	4d43384e 	stclmi	8, cr3, [r3, #-312]	; 0xfffffec8
     7dc:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
     7e0:	736c726f 	cmnvc	ip, #-268435450	; 0xf0000006
     7e4:	5f534e45 	svcpl	0x00534e45
     7e8:	4e4e3231 	mcrmi	2, 2, r3, cr14, cr1, {1}
     7ec:	65626d75 	strbvs	r6, [r2, #-3445]!	; 0xfffff28b
     7f0:	61425f72 	hvcvs	9714	; 0x25f2
     7f4:	00456573 	subeq	r6, r5, r3, ror r5
     7f8:	6e6f4d43 	cdpvs	13, 6, cr4, cr15, cr3, {2}
     7fc:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
     800:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     804:	6f4d4338 	svcvs	0x004d4338
     808:	6f74696e 	svcvs	0x0074696e
     80c:	69443672 	stmdbvs	r4, {r1, r4, r5, r6, r9, sl, ip, sp}^
     810:	65646976 	strbvs	r6, [r4, #-2422]!	; 0xfffff68a
     814:	006a6a45 	rsbeq	r6, sl, r5, asr #20
     818:	7265706f 	rsbvc	r7, r5, #111	; 0x6f
     81c:	726f7461 	rsbvc	r7, pc, #1627389952	; 0x61000000
     820:	5f003c3c 	svcpl	0x00003c3c
     824:	43384e5a 	teqmi	r8, #1440	; 0x5a0
     828:	696e6f4d 	stmdbvs	lr!, {r0, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     82c:	6c726f74 	ldclvs	15, cr6, [r2], #-464	; 0xfffffe30
     830:	4b504573 	blmi	1411e04 <_bss_end+0x1405fa0>
     834:	5a5f0063 	bpl	17c09c8 <_bss_end+0x17b4b64>
     838:	4d43384e 	stclmi	8, cr3, [r3, #-312]	; 0xfffffec8
     83c:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
     840:	6934726f 	ldmdbvs	r4!, {r0, r1, r2, r3, r5, r6, r9, ip, sp, lr}
     844:	45616f74 	strbmi	r6, [r1, #-3956]!	; 0xfffff08c
     848:	6a63506a 	bvs	18d49f8 <_bss_end+0x18c8b94>
     84c:	685f6d00 	ldmdavs	pc, {r8, sl, fp, sp, lr}^	; <UNPREDICTABLE>
     850:	68676965 	stmdavs	r7!, {r0, r2, r5, r6, r8, fp, sp, lr}^
     854:	5f6d0074 	svcpl	0x006d0074
     858:	73727563 	cmnvc	r2, #415236096	; 0x18c00000
     85c:	4300726f 	movwmi	r7, #623	; 0x26f
     860:	43726168 	cmnmi	r2, #104, 2
     864:	41766e6f 	cmnmi	r6, pc, ror #28
     868:	5f007272 	svcpl	0x00007272
     86c:	43384e5a 	teqmi	r8, #1440	; 0x5a0
     870:	696e6f4d 	stmdbvs	lr!, {r0, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     874:	6c726f74 	ldclvs	15, cr6, [r2], #-464	; 0xfffffe30
     878:	00624573 	rsbeq	r4, r2, r3, ror r5
     87c:	384e5a5f 	stmdacc	lr, {r0, r1, r2, r3, r4, r6, r9, fp, ip, lr}^
     880:	6e6f4d43 	cdpvs	13, 6, cr4, cr15, cr3, {2}
     884:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
     888:	6345736c 	movtvs	r7, #21356	; 0x536c
     88c:	775f6d00 	ldrbvc	r6, [pc, -r0, lsl #26]
     890:	68746469 	ldmdavs	r4!, {r0, r3, r5, r6, sl, sp, lr}^
     894:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     898:	6f4d4338 	svcvs	0x004d4338
     89c:	6f74696e 	svcvs	0x0074696e
     8a0:	63533672 	cmpvs	r3, #119537664	; 0x7200000
     8a4:	6c6c6f72 	stclvs	15, cr6, [ip], #-456	; 0xfffffe38
     8a8:	5f007645 	svcpl	0x00007645
     8ac:	43384e5a 	teqmi	r8, #1440	; 0x5a0
     8b0:	696e6f4d 	stmdbvs	lr!, {r0, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     8b4:	6c726f74 	ldclvs	15, cr6, [r2], #-464	; 0xfffffe30
     8b8:	006a4573 	rsbeq	r4, sl, r3, ror r5
     8bc:	384e5a5f 	stmdacc	lr, {r0, r1, r2, r3, r4, r6, r9, fp, ip, lr}^
     8c0:	6e6f4d43 	cdpvs	13, 6, cr4, cr15, cr3, {2}
     8c4:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
     8c8:	65523231 	ldrbvs	r3, [r2, #-561]	; 0xfffffdcf
     8cc:	5f746573 	svcpl	0x00746573
     8d0:	73727543 	cmnvc	r2, #281018368	; 0x10c00000
     8d4:	7645726f 	strbvc	r7, [r5], -pc, ror #4
     8d8:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     8dc:	6f4d4338 	svcvs	0x004d4338
     8e0:	6f74696e 	svcvs	0x0074696e
     8e4:	45344372 	ldrmi	r4, [r4, #-882]!	; 0xfffffc8e
     8e8:	006a6a6a 	rsbeq	r6, sl, sl, ror #20
     8ec:	41464544 	cmpmi	r6, r4, asr #10
     8f0:	5f544c55 	svcpl	0x00544c55
     8f4:	424d554e 	submi	r5, sp, #327155712	; 0x13800000
     8f8:	425f5245 	subsmi	r5, pc, #1342177284	; 0x50000004
     8fc:	00455341 	subeq	r5, r5, r1, asr #6
     900:	7074756f 	rsbsvc	r7, r4, pc, ror #10
     904:	69007475 	stmdbvs	r0, {r0, r2, r4, r5, r6, sl, ip, sp, lr}
     908:	7475706e 	ldrbtvc	r7, [r5], #-110	; 0xffffff92
     90c:	625f7300 	subsvs	r7, pc, #0, 6
     910:	65666675 	strbvs	r6, [r6, #-1653]!	; 0xfffff98b
     914:	682f0072 	stmdavs	pc!, {r1, r4, r5, r6}	; <UNPREDICTABLE>
     918:	2f656d6f 	svccs	0x00656d6f
     91c:	686c6973 	stmdavs	ip!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
     920:	6a797661 	bvs	1e5e2ac <_bss_end+0x1e52448>
     924:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
     928:	2f6c6f6f 	svccs	0x006c6f6f
     92c:	6f72655a 	svcvs	0x0072655a
     930:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
     934:	6178652f 	cmnvs	r8, pc, lsr #10
     938:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
     93c:	33312f73 	teqcc	r1, #460	; 0x1cc
     940:	6e6f632d 	cdpvs	3, 6, cr6, cr15, cr13, {1}
     944:	74786574 	ldrbtvc	r6, [r8], #-1396	; 0xfffffa8c
     948:	6977735f 	ldmdbvs	r7!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, sp, lr}^
     94c:	5f686374 	svcpl	0x00686374
     950:	696e6f6d 	stmdbvs	lr!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
     954:	2f726f74 	svccs	0x00726f74
     958:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
     95c:	732f6c65 			; <UNDEFINED> instruction: 0x732f6c65
     960:	642f6372 	strtvs	r6, [pc], #-882	; 968 <CPSR_IRQ_INHIBIT+0x8e8>
     964:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
     968:	6d2f7372 	stcvs	3, cr7, [pc, #-456]!	; 7a8 <CPSR_IRQ_INHIBIT+0x728>
     96c:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
     970:	632e726f 			; <UNDEFINED> instruction: 0x632e726f
     974:	42007070 	andmi	r7, r0, #112	; 0x70
     978:	45464655 	strbmi	r4, [r6, #-1621]	; 0xfffff9ab
     97c:	49535f52 	ldmdbmi	r3, {r1, r4, r6, r8, r9, sl, fp, ip, lr}^
     980:	5200455a 	andpl	r4, r0, #377487360	; 0x16800000
     984:	69616d65 	stmdbvs	r1!, {r0, r2, r5, r6, r8, sl, fp, sp, lr}^
     988:	7265646e 	rsbvc	r6, r5, #1845493760	; 0x6e000000
     98c:	4c475f00 	mcrrmi	15, 0, r5, r7, cr0
     990:	4c41424f 	sfmmi	f4, 2, [r1], {79}	; 0x4f
     994:	75735f5f 	ldrbvc	r5, [r3, #-3935]!	; 0xfffff0a1
     998:	5f495f62 	svcpl	0x00495f62
     99c:	6d695473 	cfstrdvs	mvd5, [r9, #-460]!	; 0xfffffe34
     9a0:	5f007265 	svcpl	0x00007265
     9a4:	43364e5a 	teqmi	r6, #1440	; 0x5a0
     9a8:	656d6954 	strbvs	r6, [sp, #-2388]!	; 0xfffff6ac
     9ac:	49303272 	ldmdbmi	r0!, {r1, r4, r5, r6, r9, ip, sp}
     9b0:	69545f73 	ldmdbvs	r4, {r0, r1, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     9b4:	5f72656d 	svcpl	0x0072656d
     9b8:	5f515249 	svcpl	0x00515249
     9bc:	646e6550 	strbtvs	r6, [lr], #-1360	; 0xfffffab0
     9c0:	45676e69 	strbmi	r6, [r7, #-3689]!	; 0xfffff197
     9c4:	682f0076 	stmdavs	pc!, {r1, r2, r4, r5, r6}	; <UNPREDICTABLE>
     9c8:	2f656d6f 	svccs	0x00656d6f
     9cc:	686c6973 	stmdavs	ip!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
     9d0:	6a797661 	bvs	1e5e35c <_bss_end+0x1e524f8>
     9d4:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
     9d8:	2f6c6f6f 	svccs	0x006c6f6f
     9dc:	6f72655a 	svcvs	0x0072655a
     9e0:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
     9e4:	6178652f 	cmnvs	r8, pc, lsr #10
     9e8:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
     9ec:	33312f73 	teqcc	r1, #460	; 0x1cc
     9f0:	6e6f632d 	cdpvs	3, 6, cr6, cr15, cr13, {1}
     9f4:	74786574 	ldrbtvc	r6, [r8], #-1396	; 0xfffffa8c
     9f8:	6977735f 	ldmdbvs	r7!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, sp, lr}^
     9fc:	5f686374 	svcpl	0x00686374
     a00:	696e6f6d 	stmdbvs	lr!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
     a04:	2f726f74 	svccs	0x00726f74
     a08:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
     a0c:	732f6c65 			; <UNDEFINED> instruction: 0x732f6c65
     a10:	642f6372 	strtvs	r6, [pc], #-882	; a18 <CPSR_IRQ_INHIBIT+0x998>
     a14:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
     a18:	742f7372 	strtvc	r7, [pc], #-882	; a20 <CPSR_IRQ_INHIBIT+0x9a0>
     a1c:	72656d69 	rsbvc	r6, r5, #6720	; 0x1a40
     a20:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
     a24:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     a28:	69544336 	ldmdbvs	r4, {r1, r2, r4, r5, r8, r9, lr}^
     a2c:	4372656d 	cmnmi	r2, #457179136	; 0x1b400000
     a30:	006d4532 	rsbeq	r4, sp, r2, lsr r5
     a34:	6f6c6552 	svcvs	0x006c6552
     a38:	49006461 	stmdbmi	r0, {r0, r5, r6, sl, sp, lr}
     a3c:	435f5152 	cmpmi	pc, #-2147483628	; 0x80000014
     a40:	626c6c61 	rsbvs	r6, ip, #24832	; 0x6100
     a44:	006b6361 	rsbeq	r6, fp, r1, ror #6
     a48:	5f515249 	svcpl	0x00515249
     a4c:	6b73614d 	blvs	1cd8f88 <_bss_end+0x1ccd124>
     a50:	64006465 	strvs	r6, [r0], #-1125	; 0xfffffb9b
     a54:	79616c65 	stmdbvc	r1!, {r0, r2, r5, r6, sl, fp, sp, lr}^
     a58:	6e697500 	cdpvs	5, 6, cr7, cr9, cr0, {0}
     a5c:	745f3874 	ldrbvc	r3, [pc], #-2164	; a64 <CPSR_IRQ_INHIBIT+0x9e4>
     a60:	756e7500 	strbvc	r7, [lr, #-1280]!	; 0xfffffb00
     a64:	5f646573 	svcpl	0x00646573
     a68:	6e750030 	mrcvs	0, 3, r0, cr5, cr0, {1}
     a6c:	64657375 	strbtvs	r7, [r5], #-885	; 0xfffffc8b
     a70:	7500315f 	strvc	r3, [r0, #-351]	; 0xfffffea1
     a74:	6573756e 	ldrbvs	r7, [r3, #-1390]!	; 0xfffffa92
     a78:	00325f64 	eorseq	r5, r2, r4, ror #30
     a7c:	73756e75 	cmnvc	r5, #1872	; 0x750
     a80:	335f6465 	cmpcc	pc, #1694498816	; 0x65000000
     a84:	756e7500 	strbvc	r7, [lr, #-1280]!	; 0xfffffb00
     a88:	5f646573 	svcpl	0x00646573
     a8c:	6f630034 	svcvs	0x00630034
     a90:	65746e75 	ldrbvs	r6, [r4, #-3701]!	; 0xfffff18b
     a94:	32335f72 	eorscc	r5, r3, #456	; 0x1c8
     a98:	72500062 	subsvc	r0, r0, #98	; 0x62
     a9c:	61637365 	cmnvs	r3, r5, ror #6
     aa0:	5f72656c 	svcpl	0x0072656c
     aa4:	00363532 	eorseq	r3, r6, r2, lsr r5
     aa8:	364e5a5f 			; <UNDEFINED> instruction: 0x364e5a5f
     aac:	6d695443 	cfstrdvs	mvd5, [r9, #-268]!	; 0xfffffef4
     ab0:	45367265 	ldrmi	r7, [r6, #-613]!	; 0xfffffd9b
     ab4:	6c62616e 	stfvse	f6, [r2], #-440	; 0xfffffe48
     ab8:	46504565 	ldrbmi	r4, [r0], -r5, ror #10
     abc:	6a457676 	bvs	115e49c <_bss_end+0x1152638>
     ac0:	544e3631 	strbpl	r3, [lr], #-1585	; 0xfffff9cf
     ac4:	72656d69 	rsbvc	r6, r5, #6720	; 0x1a40
     ac8:	6572505f 	ldrbvs	r5, [r2, #-95]!	; 0xffffffa1
     acc:	6c616373 	stclvs	3, cr6, [r1], #-460	; 0xfffffe34
     ad0:	66007265 	strvs	r7, [r0], -r5, ror #4
     ad4:	5f656572 	svcpl	0x00656572
     ad8:	6e6e7572 	mcrvs	5, 3, r7, cr14, cr2, {3}
     adc:	5f676e69 	svcpl	0x00676e69
     ae0:	73657270 	cmnvc	r5, #112, 4
     ae4:	656c6163 	strbvs	r6, [ip, #-355]!	; 0xfffffe9d
     ae8:	72500072 	subsvc	r0, r0, #114	; 0x72
     aec:	61637365 	cmnvs	r3, r5, ror #6
     af0:	5f72656c 	svcpl	0x0072656c
     af4:	72660031 	rsbvc	r0, r6, #49	; 0x31
     af8:	725f6565 	subsvc	r6, pc, #423624704	; 0x19400000
     afc:	696e6e75 	stmdbvs	lr!, {r0, r2, r4, r5, r6, r9, sl, fp, sp, lr}^
     b00:	655f676e 	ldrbvs	r6, [pc, #-1902]	; 39a <CPSR_IRQ_INHIBIT+0x31a>
     b04:	6c62616e 	stfvse	f6, [r2], #-440	; 0xfffffe48
     b08:	52490065 	subpl	r0, r9, #101	; 0x65
     b0c:	6c435f51 	mcrrvs	15, 5, r5, r3, cr1
     b10:	00726165 	rsbseq	r6, r2, r5, ror #2
     b14:	73657250 	cmnvc	r5, #80, 4
     b18:	656c6163 	strbvs	r6, [ip, #-355]!	; 0xfffffe9d
     b1c:	36315f72 	shsub16cc	r5, r1, r2
     b20:	6c616800 	stclvs	8, cr6, [r1], #-0
     b24:	6e695f74 	mcrvs	15, 3, r5, cr9, cr4, {3}
     b28:	6265645f 	rsbvs	r6, r5, #1593835520	; 0x5f000000
     b2c:	625f6775 	subsvs	r6, pc, #30670848	; 0x1d40000
     b30:	6b616572 	blvs	185a100 <_bss_end+0x184e29c>
     b34:	69546d00 	ldmdbvs	r4, {r8, sl, fp, sp, lr}^
     b38:	5f72656d 	svcpl	0x0072656d
     b3c:	73676552 	cmnvc	r7, #343932928	; 0x14800000
     b40:	6c615600 	stclvs	6, cr5, [r1], #-0
     b44:	69006575 	stmdbvs	r0, {r0, r2, r4, r5, r6, r8, sl, sp, lr}
     b48:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
     b4c:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
     b50:	616e655f 	cmnvs	lr, pc, asr r5
     b54:	64656c62 	strbtvs	r6, [r5], #-3170	; 0xfffff39e
     b58:	6e697500 	cdpvs	5, 6, cr7, cr9, cr0, {0}
     b5c:	5f363174 	svcpl	0x00363174
     b60:	72500074 	subsvc	r0, r0, #116	; 0x74
     b64:	69445f65 	stmdbvs	r4, {r0, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     b68:	65646976 	strbvs	r6, [r4, #-2422]!	; 0xfffff68a
     b6c:	69540072 	ldmdbvs	r4, {r1, r4, r5, r6}^
     b70:	5f72656d 	svcpl	0x0072656d
     b74:	00676552 	rsbeq	r6, r7, r2, asr r5
     b78:	364e5a5f 			; <UNDEFINED> instruction: 0x364e5a5f
     b7c:	6d695443 	cfstrdvs	mvd5, [r9, #-268]!	; 0xfffffef4
     b80:	44377265 	ldrtmi	r7, [r7], #-613	; 0xfffffd9b
     b84:	62617369 	rsbvs	r7, r1, #-1543503871	; 0xa4000001
     b88:	7645656c 	strbvc	r6, [r5], -ip, ror #10
     b8c:	6d697400 	cfstrdvs	mvd7, [r9, #-0]
     b90:	725f7265 	subsvc	r7, pc, #1342177286	; 0x50000006
     b94:	625f6765 	subsvs	r6, pc, #26476544	; 0x1940000
     b98:	00657361 	rsbeq	r7, r5, r1, ror #6
     b9c:	656d6974 	strbvs	r6, [sp, #-2420]!	; 0xfffff68c
     ba0:	6e655f72 	mcrvs	15, 3, r5, cr5, cr2, {3}
     ba4:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     ba8:	54540064 	ldrbpl	r0, [r4], #-100	; 0xffffff9c
     bac:	72656d69 	rsbvc	r6, r5, #6720	; 0x1a40
     bb0:	6c74435f 	ldclvs	3, cr4, [r4], #-380	; 0xfffffe84
     bb4:	616c465f 	cmnvs	ip, pc, asr r6
     bb8:	4c007367 	stcmi	3, cr7, [r0], {103}	; 0x67
     bbc:	0064616f 	rsbeq	r6, r4, pc, ror #2
     bc0:	6d695443 	cfstrdvs	mvd5, [r9, #-268]!	; 0xfffffef4
     bc4:	6d007265 	sfmvs	f7, 4, [r0, #-404]	; 0xfffffe6c
     bc8:	6c6c6143 	stfvse	f6, [ip], #-268	; 0xfffffef4
     bcc:	6b636162 	blvs	18d915c <_bss_end+0x18cd2f8>
     bd0:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     bd4:	69544336 	ldmdbvs	r4, {r1, r2, r4, r5, r8, r9, lr}^
     bd8:	3472656d 	ldrbtcc	r6, [r2], #-1389	; 0xfffffa93
     bdc:	73676552 	cmnvc	r7, #343932928	; 0x14800000
     be0:	68334e45 	ldmdavs	r3!, {r0, r2, r6, r9, sl, fp, lr}
     be4:	54396c61 	ldrtpl	r6, [r9], #-3169	; 0xfffff39f
     be8:	72656d69 	rsbvc	r6, r5, #6720	; 0x1a40
     bec:	6765525f 			; <UNDEFINED> instruction: 0x6765525f
     bf0:	5a5f0045 	bpl	17c0d0c <_bss_end+0x17b4ea8>
     bf4:	5443364e 	strbpl	r3, [r3], #-1614	; 0xfffff9b2
     bf8:	72656d69 	rsbvc	r6, r5, #6720	; 0x1a40
     bfc:	6d453443 	cfstrdvs	mvd3, [r5, #-268]	; 0xfffffef4
     c00:	65724600 	ldrbvs	r4, [r2, #-1536]!	; 0xfffffa00
     c04:	75525f65 	ldrbvc	r5, [r2, #-3941]	; 0xfffff09b
     c08:	6e696e6e 	cdpvs	14, 6, cr6, cr9, cr14, {3}
     c0c:	73490067 	movtvc	r0, #36967	; 0x9067
     c10:	6d69545f 	cfstrdvs	mvd5, [r9, #-380]!	; 0xfffffe84
     c14:	495f7265 	ldmdbmi	pc, {r0, r2, r5, r6, r9, ip, sp, lr}^	; <UNPREDICTABLE>
     c18:	505f5152 	subspl	r5, pc, r2, asr r1	; <UNPREDICTABLE>
     c1c:	69646e65 	stmdbvs	r4!, {r0, r2, r5, r6, r9, sl, fp, sp, lr}^
     c20:	5400676e 	strpl	r6, [r0], #-1902	; 0xfffff892
     c24:	656d6954 	strbvs	r6, [sp, #-2388]!	; 0xfffff6ac
     c28:	61435f72 	hvcvs	13810	; 0x35f2
     c2c:	61626c6c 	cmnvs	r2, ip, ror #24
     c30:	49006b63 	stmdbmi	r0, {r0, r1, r5, r6, r8, r9, fp, sp, lr}
     c34:	525f5152 	subspl	r5, pc, #-2147483628	; 0x80000014
     c38:	5f007761 	svcpl	0x00007761
     c3c:	43364e5a 	teqmi	r6, #1440	; 0x5a0
     c40:	656d6954 	strbvs	r6, [sp, #-2388]!	; 0xfffff6ac
     c44:	49323172 	ldmdbmi	r2!, {r1, r4, r5, r6, r8, ip, sp}
     c48:	435f5152 	cmpmi	pc, #-2147483628	; 0x80000014
     c4c:	626c6c61 	rsbvs	r6, ip, #24832	; 0x6100
     c50:	456b6361 	strbmi	r6, [fp, #-865]!	; 0xfffffc9f
     c54:	61630076 	smcvs	12294	; 0x3006
     c58:	61626c6c 	cmnvs	r2, ip, ror #24
     c5c:	5f006b63 	svcpl	0x00006b63
     c60:	31324e5a 	teqcc	r2, sl, asr lr
     c64:	746e4943 	strbtvc	r4, [lr], #-2371	; 0xfffff6bd
     c68:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
     c6c:	435f7470 	cmpmi	pc, #112, 8	; 0x70000000
     c70:	72746e6f 	rsbsvc	r6, r4, #1776	; 0x6f0
     c74:	656c6c6f 	strbvs	r6, [ip, #-3183]!	; 0xfffff391
     c78:	44313172 	ldrtmi	r3, [r1], #-370	; 0xfffffe8e
     c7c:	62617369 	rsbvs	r7, r1, #-1543503871	; 0xa4000001
     c80:	495f656c 	ldmdbmi	pc, {r2, r3, r5, r6, r8, sl, sp, lr}^	; <UNPREDICTABLE>
     c84:	4e455152 	mcrmi	1, 2, r5, cr5, cr2, {2}
     c88:	6c616833 	stclvs	8, cr6, [r1], #-204	; 0xffffff34
     c8c:	52493031 	subpl	r3, r9, #49	; 0x31
     c90:	6f535f51 	svcvs	0x00535f51
     c94:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     c98:	61660045 	cmnvs	r6, r5, asr #32
     c9c:	695f7473 	ldmdbvs	pc, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
     ca0:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
     ca4:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
     ca8:	6e61685f 	mcrvs	8, 3, r6, cr1, cr15, {2}
     cac:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     cb0:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     cb4:	49433132 	stmdbmi	r3, {r1, r4, r5, r8, ip, sp}^
     cb8:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
     cbc:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
     cc0:	6e6f435f 	mcrvs	3, 3, r4, cr15, cr15, {2}
     cc4:	6c6f7274 	sfmvs	f7, 2, [pc], #-464	; afc <CPSR_IRQ_INHIBIT+0xa7c>
     cc8:	3172656c 	cmncc	r2, ip, ror #10
     ccc:	73694437 	cmnvc	r9, #922746880	; 0x37000000
     cd0:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     cd4:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
     cd8:	495f6369 	ldmdbmi	pc, {r0, r3, r5, r6, r8, r9, sp, lr}^	; <UNPREDICTABLE>
     cdc:	4e455152 	mcrmi	1, 2, r5, cr5, cr2, {2}
     ce0:	6c616833 	stclvs	8, cr6, [r1], #-204	; 0xffffff34
     ce4:	52493631 	subpl	r3, r9, #51380224	; 0x3100000
     ce8:	61425f51 	cmpvs	r2, r1, asr pc
     cec:	5f636973 	svcpl	0x00636973
     cf0:	72756f53 	rsbsvc	r6, r5, #332	; 0x14c
     cf4:	00456563 	subeq	r6, r5, r3, ror #10
     cf8:	324e5a5f 	subcc	r5, lr, #389120	; 0x5f000
     cfc:	6e494331 	mcrvs	3, 2, r4, cr9, cr1, {1}
     d00:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
     d04:	5f747075 	svcpl	0x00747075
     d08:	746e6f43 	strbtvc	r6, [lr], #-3907	; 0xfffff0bd
     d0c:	6c6c6f72 	stclvs	15, cr6, [ip], #-456	; 0xfffffe38
     d10:	36317265 	ldrtcc	r7, [r1], -r5, ror #4
     d14:	62616e45 	rsbvs	r6, r1, #1104	; 0x450
     d18:	425f656c 	subsmi	r6, pc, #108, 10	; 0x1b000000
     d1c:	63697361 	cmnvs	r9, #-2080374783	; 0x84000001
     d20:	5152495f 	cmppl	r2, pc, asr r9
     d24:	68334e45 	ldmdavs	r3!, {r0, r2, r6, r9, sl, fp, lr}
     d28:	36316c61 	ldrtcc	r6, [r1], -r1, ror #24
     d2c:	5f515249 	svcpl	0x00515249
     d30:	69736142 	ldmdbvs	r3!, {r1, r6, r8, sp, lr}^
     d34:	6f535f63 	svcvs	0x00535f63
     d38:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     d3c:	52490045 	subpl	r0, r9, #69	; 0x45
     d40:	6f535f51 	svcvs	0x00535f51
     d44:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     d48:	746e4900 	strbtvc	r4, [lr], #-2304	; 0xfffff700
     d4c:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
     d50:	435f7470 	cmpmi	pc, #112, 8	; 0x70000000
     d54:	72746e6f 	rsbsvc	r6, r4, #1776	; 0x6f0
     d58:	656c6c6f 	strbvs	r6, [ip, #-3183]!	; 0xfffff391
     d5c:	65525f72 	ldrbvs	r5, [r2, #-3954]	; 0xfffff08e
     d60:	6f440067 	svcvs	0x00440067
     d64:	6562726f 	strbvs	r7, [r2, #-623]!	; 0xfffffd91
     d68:	305f6c6c 	subscc	r6, pc, ip, ror #24
     d6c:	49504700 	ldmdbmi	r0, {r8, r9, sl, lr}^
     d70:	00305f4f 	eorseq	r5, r0, pc, asr #30
     d74:	726f6f44 	rsbvc	r6, pc, #68, 30	; 0x110
     d78:	6c6c6562 	cfstr64vs	mvdx6, [ip], #-392	; 0xfffffe78
     d7c:	4700315f 	smlsdmi	r0, pc, r1, r3	; <UNPREDICTABLE>
     d80:	5f4f4950 	svcpl	0x004f4950
     d84:	50470032 	subpl	r0, r7, r2, lsr r0
     d88:	335f4f49 	cmpcc	pc, #292	; 0x124
     d8c:	51524900 	cmppl	r2, r0, lsl #18
     d90:	7369445f 	cmnvc	r9, #1593835520	; 0x5f000000
     d94:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     d98:	4900315f 	stmdbmi	r0, {r0, r1, r2, r3, r4, r6, r8, ip, sp}
     d9c:	445f5152 	ldrbmi	r5, [pc], #-338	; da4 <CPSR_IRQ_INHIBIT+0xd24>
     da0:	62617369 	rsbvs	r7, r1, #-1543503871	; 0xa4000001
     da4:	325f656c 	subscc	r6, pc, #108, 10	; 0x1b000000
     da8:	51524900 	cmppl	r2, r0, lsl #18
     dac:	616e455f 	cmnvs	lr, pc, asr r5
     db0:	5f656c62 	svcpl	0x00656c62
     db4:	52490031 	subpl	r0, r9, #49	; 0x31
     db8:	6e455f51 	mcrvs	15, 2, r5, cr5, cr1, {2}
     dbc:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     dc0:	5f00325f 	svcpl	0x0000325f
     dc4:	31324e5a 	teqcc	r2, sl, asr lr
     dc8:	746e4943 	strbtvc	r4, [lr], #-2371	; 0xfffff6bd
     dcc:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
     dd0:	435f7470 	cmpmi	pc, #112, 8	; 0x70000000
     dd4:	72746e6f 	rsbsvc	r6, r4, #1776	; 0x6f0
     dd8:	656c6c6f 	strbvs	r6, [ip, #-3183]!	; 0xfffff391
     ddc:	65523472 	ldrbvs	r3, [r2, #-1138]	; 0xfffffb8e
     de0:	4e457367 	cdpmi	3, 4, cr7, cr5, cr7, {3}
     de4:	6c616833 	stclvs	8, cr6, [r1], #-204	; 0xffffff34
     de8:	6e493432 	mcrvs	4, 2, r3, cr9, cr2, {1}
     dec:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
     df0:	5f747075 	svcpl	0x00747075
     df4:	746e6f43 	strbtvc	r6, [lr], #-3907	; 0xfffff0bd
     df8:	6c6c6f72 	stclvs	15, cr6, [ip], #-456	; 0xfffffe38
     dfc:	525f7265 	subspl	r7, pc, #1342177286	; 0x50000006
     e00:	00456765 	subeq	r6, r5, r5, ror #14
     e04:	746e496d 	strbtvc	r4, [lr], #-2413	; 0xfffff693
     e08:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
     e0c:	525f7470 	subspl	r7, pc, #112, 8	; 0x70000000
     e10:	00736765 	rsbseq	r6, r3, r5, ror #14
     e14:	5f515249 	svcpl	0x00515249
     e18:	646e6550 	strbtvs	r6, [lr], #-1360	; 0xfffffab0
     e1c:	5f676e69 	svcpl	0x00676e69
     e20:	52490031 	subpl	r0, r9, #49	; 0x31
     e24:	65505f51 	ldrbvs	r5, [r0, #-3921]	; 0xfffff0af
     e28:	6e69646e 	cdpvs	4, 6, cr6, cr9, cr14, {3}
     e2c:	00325f67 	eorseq	r5, r2, r7, ror #30
     e30:	5f515249 	svcpl	0x00515249
     e34:	69736142 	ldmdbvs	r3!, {r1, r6, r8, sp, lr}^
     e38:	6f535f63 	svcvs	0x00535f63
     e3c:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     e40:	41575000 	cmpmi	r7, r0
     e44:	5500305f 	strpl	r3, [r0, #-95]	; 0xffffffa1
     e48:	00545241 	subseq	r5, r4, r1, asr #4
     e4c:	61736944 	cmnvs	r3, r4, asr #18
     e50:	5f656c62 	svcpl	0x00656c62
     e54:	00515249 	subseq	r5, r1, r9, asr #4
     e58:	62616e45 	rsbvs	r6, r1, #1104	; 0x450
     e5c:	425f656c 	subsmi	r6, pc, #108, 10	; 0x1b000000
     e60:	63697361 	cmnvs	r9, #-2080374783	; 0x84000001
     e64:	5152495f 	cmppl	r2, pc, asr r9
     e68:	73694400 	cmnvc	r9, #0, 8
     e6c:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     e70:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
     e74:	495f6369 	ldmdbmi	pc, {r0, r3, r5, r6, r8, r9, sp, lr}^	; <UNPREDICTABLE>
     e78:	49005152 	stmdbmi	r0, {r1, r4, r6, r8, ip, lr}
     e7c:	67656c6c 	strbvs	r6, [r5, -ip, ror #24]!
     e80:	415f6c61 	cmpmi	pc, r1, ror #24
     e84:	73656363 	cmnvc	r5, #-1946157055	; 0x8c000001
     e88:	00315f73 	eorseq	r5, r1, r3, ror pc
     e8c:	656c6c49 	strbvs	r6, [ip, #-3145]!	; 0xfffff3b7
     e90:	5f6c6167 	svcpl	0x006c6167
     e94:	65636341 	strbvs	r6, [r3, #-833]!	; 0xfffffcbf
     e98:	325f7373 	subscc	r7, pc, #-872415231	; 0xcc000001
     e9c:	49504700 	ldmdbmi	r0, {r8, r9, sl, lr}^
     ea0:	00315f4f 	eorseq	r5, r1, pc, asr #30
     ea4:	5f515249 	svcpl	0x00515249
     ea8:	69736142 	ldmdbvs	r3!, {r1, r6, r8, sp, lr}^
     eac:	65505f63 	ldrbvs	r5, [r0, #-3939]	; 0xfffff09d
     eb0:	6e69646e 	cdpvs	4, 6, cr6, cr9, cr14, {3}
     eb4:	50470067 	subpl	r0, r7, r7, rrx
     eb8:	485f3155 	ldmdami	pc, {r0, r2, r4, r6, r8, ip, sp}^	; <UNPREDICTABLE>
     ebc:	00746c61 	rsbseq	r6, r4, r1, ror #24
     ec0:	5f415750 	svcpl	0x00415750
     ec4:	52490031 	subpl	r0, r9, #49	; 0x31
     ec8:	61425f51 	cmpvs	r2, r1, asr pc
     ecc:	5f636973 	svcpl	0x00636973
     ed0:	62616e45 	rsbvs	r6, r1, #1104	; 0x450
     ed4:	4d00656c 	cfstr32mi	mvfx6, [r0, #-432]	; 0xfffffe50
     ed8:	626c6961 	rsbvs	r6, ip, #1589248	; 0x184000
     edc:	5f00786f 	svcpl	0x0000786f
     ee0:	424f4c47 	submi	r4, pc, #18176	; 0x4700
     ee4:	5f5f4c41 	svcpl	0x005f4c41
     ee8:	5f627573 	svcpl	0x00627573
     eec:	49735f49 	ldmdbmi	r3!, {r0, r3, r6, r8, r9, sl, fp, ip, lr}^
     ef0:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
     ef4:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
     ef8:	006c7443 	rsbeq	r7, ip, r3, asr #8
     efc:	324e5a5f 	subcc	r5, lr, #389120	; 0x5f000
     f00:	6e494331 	mcrvs	3, 2, r4, cr9, cr1, {1}
     f04:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
     f08:	5f747075 	svcpl	0x00747075
     f0c:	746e6f43 	strbtvc	r6, [lr], #-3907	; 0xfffff0bd
     f10:	6c6c6f72 	stclvs	15, cr6, [ip], #-456	; 0xfffffe38
     f14:	30317265 	eorscc	r7, r1, r5, ror #4
     f18:	62616e45 	rsbvs	r6, r1, #1104	; 0x450
     f1c:	495f656c 	ldmdbmi	pc, {r2, r3, r5, r6, r8, sl, sp, lr}^	; <UNPREDICTABLE>
     f20:	4e455152 	mcrmi	1, 2, r5, cr5, cr2, {2}
     f24:	6c616833 	stclvs	8, cr6, [r1], #-204	; 0xffffff34
     f28:	52493031 	subpl	r3, r9, #49	; 0x31
     f2c:	6f535f51 	svcvs	0x00535f51
     f30:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     f34:	49430045 	stmdbmi	r3, {r0, r2, r6}^
     f38:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
     f3c:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
     f40:	6e6f435f 	mcrvs	3, 3, r4, cr15, cr15, {2}
     f44:	6c6f7274 	sfmvs	f7, 2, [pc], #-464	; d7c <CPSR_IRQ_INHIBIT+0xcfc>
     f48:	0072656c 	rsbseq	r6, r2, ip, ror #10
     f4c:	324e5a5f 	subcc	r5, lr, #389120	; 0x5f000
     f50:	6e494331 	mcrvs	3, 2, r4, cr9, cr1, {1}
     f54:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
     f58:	5f747075 	svcpl	0x00747075
     f5c:	746e6f43 	strbtvc	r6, [lr], #-3907	; 0xfffff0bd
     f60:	6c6c6f72 	stclvs	15, cr6, [ip], #-456	; 0xfffffe38
     f64:	32437265 	subcc	r7, r3, #1342177286	; 0x50000006
     f68:	69006d45 	stmdbvs	r0, {r0, r2, r6, r8, sl, fp, sp, lr}
     f6c:	625f7864 	subsvs	r7, pc, #100, 16	; 0x640000
     f70:	00657361 	rsbeq	r7, r5, r1, ror #6
     f74:	5f515249 	svcpl	0x00515249
     f78:	69736142 	ldmdbvs	r3!, {r1, r6, r8, sp, lr}^
     f7c:	69445f63 	stmdbvs	r4, {r0, r1, r5, r6, r8, r9, sl, fp, ip, lr}^
     f80:	6c626173 	stfvse	f6, [r2], #-460	; 0xfffffe34
     f84:	5a5f0065 	bpl	17c1120 <_bss_end+0x17b52bc>
     f88:	4331324e 	teqmi	r1, #-536870908	; 0xe0000004
     f8c:	65746e49 	ldrbvs	r6, [r4, #-3657]!	; 0xfffff1b7
     f90:	70757272 	rsbsvc	r7, r5, r2, ror r2
     f94:	6f435f74 	svcvs	0x00435f74
     f98:	6f72746e 	svcvs	0x0072746e
     f9c:	72656c6c 	rsbvc	r6, r5, #108, 24	; 0x6c00
     fa0:	6d453443 	cfstrdvs	mvd3, [r5, #-268]	; 0xfffffef4
     fa4:	43324900 	teqmi	r2, #0, 18
     fa8:	4950535f 	ldmdbmi	r0, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     fac:	414c535f 	cmpmi	ip, pc, asr r3
     fb0:	495f4556 	ldmdbmi	pc, {r1, r2, r4, r6, r8, sl, lr}^	; <UNPREDICTABLE>
     fb4:	0054494e 	subseq	r4, r4, lr, asr #18
     fb8:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
     fbc:	695f6563 	ldmdbvs	pc, {r0, r1, r5, r6, r8, sl, sp, lr}^	; <UNPREDICTABLE>
     fc0:	46007864 	strmi	r7, [r0], -r4, ror #16
     fc4:	435f5149 	cmpmi	pc, #1073741842	; 0x40000012
     fc8:	72746e6f 	rsbsvc	r6, r4, #1776	; 0x6f0
     fcc:	5f006c6f 	svcpl	0x00006c6f
     fd0:	65746e69 	ldrbvs	r6, [r4, #-3689]!	; 0xfffff197
     fd4:	6c616e72 	stclvs	14, cr6, [r1], #-456	; 0xfffffe38
     fd8:	7172695f 	cmnvc	r2, pc, asr r9
     fdc:	6e61685f 	mcrvs	8, 3, r6, cr1, cr15, {2}
     fe0:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     fe4:	666f7300 	strbtvs	r7, [pc], -r0, lsl #6
     fe8:	72617774 	rsbvc	r7, r1, #116, 14	; 0x1d00000
     fec:	6e695f65 	cdpvs	15, 6, cr5, cr9, cr5, {3}
     ff0:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
     ff4:	5f747075 	svcpl	0x00747075
     ff8:	646e6168 	strbtvs	r6, [lr], #-360	; 0xfffffe98
     ffc:	0072656c 	rsbseq	r6, r2, ip, ror #10
    1000:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; f4c <CPSR_IRQ_INHIBIT+0xecc>
    1004:	69732f65 	ldmdbvs	r3!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
    1008:	7661686c 	strbtvc	r6, [r1], -ip, ror #16
    100c:	532f6a79 			; <UNDEFINED> instruction: 0x532f6a79
    1010:	6f6f6863 	svcvs	0x006f6863
    1014:	655a2f6c 	ldrbvs	r2, [sl, #-3948]	; 0xfffff094
    1018:	614d6f72 	hvcvs	55026	; 0xd6f2
    101c:	652f6574 	strvs	r6, [pc, #-1396]!	; ab0 <CPSR_IRQ_INHIBIT+0xa30>
    1020:	706d6178 	rsbvc	r6, sp, r8, ror r1
    1024:	2f73656c 	svccs	0x0073656c
    1028:	632d3331 			; <UNDEFINED> instruction: 0x632d3331
    102c:	65746e6f 	ldrbvs	r6, [r4, #-3695]!	; 0xfffff191
    1030:	735f7478 	cmpvc	pc, #120, 8	; 0x78000000
    1034:	63746977 	cmnvs	r4, #1949696	; 0x1dc000
    1038:	6f6d5f68 	svcvs	0x006d5f68
    103c:	6f74696e 	svcvs	0x0074696e
    1040:	656b2f72 	strbvs	r2, [fp, #-3954]!	; 0xfffff08e
    1044:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
    1048:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
    104c:	746e692f 	strbtvc	r6, [lr], #-2351	; 0xfffff6d1
    1050:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
    1054:	635f7470 	cmpvs	pc, #112, 8	; 0x70000000
    1058:	72746e6f 	rsbsvc	r6, r4, #1776	; 0x6f0
    105c:	656c6c6f 	strbvs	r6, [ip, #-3183]!	; 0xfffff391
    1060:	70632e72 	rsbvc	r2, r3, r2, ror lr
    1064:	6e450070 	mcrvs	0, 2, r0, cr5, cr0, {3}
    1068:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
    106c:	5152495f 	cmppl	r2, pc, asr r9
    1070:	55504700 	ldrbpl	r4, [r0, #-1792]	; 0xfffff900
    1074:	61485f30 	cmpvs	r8, r0, lsr pc
    1078:	7000746c 	andvc	r7, r0, ip, ror #8
    107c:	00766572 	rsbseq	r6, r6, r2, ror r5
    1080:	65676150 	strbvs	r6, [r7, #-336]!	; 0xfffffeb0
    1084:	6e756f43 	cdpvs	15, 7, cr6, cr5, cr3, {2}
    1088:	5a5f0074 	bpl	17c1260 <_bss_end+0x17b53fc>
    108c:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
    1090:	636f7250 	cmnvs	pc, #80, 4
    1094:	5f737365 	svcpl	0x00737365
    1098:	616e614d 	cmnvs	lr, sp, asr #2
    109c:	31726567 	cmncc	r2, r7, ror #10
    10a0:	65724339 	ldrbvs	r4, [r2, #-825]!	; 0xfffffcc7
    10a4:	5f657461 	svcpl	0x00657461
    10a8:	6e69614d 	powvsem	f6, f1, #5.0
    10ac:	6f72505f 	svcvs	0x0072505f
    10b0:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    10b4:	50007645 	andpl	r7, r0, r5, asr #12
    10b8:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    10bc:	315f7373 	cmpcc	pc, r3, ror r3	; <UNPREDICTABLE>
    10c0:	72506d00 	subsvc	r6, r0, #0, 26
    10c4:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    10c8:	694c5f73 	stmdbvs	ip, {r0, r1, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    10cc:	485f7473 	ldmdami	pc, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    10d0:	00646165 	rsbeq	r6, r4, r5, ror #2
    10d4:	68676948 	stmdavs	r7!, {r3, r6, r8, fp, sp, lr}^
    10d8:	6f6d654d 	svcvs	0x006d654d
    10dc:	6e007972 			; <UNDEFINED> instruction: 0x6e007972
    10e0:	00747865 	rsbseq	r7, r4, r5, ror #16
    10e4:	314e5a5f 	cmpcc	lr, pc, asr sl
    10e8:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
    10ec:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    10f0:	614d5f73 	hvcvs	54771	; 0xd5f3
    10f4:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
    10f8:	43343172 	teqmi	r4, #-2147483620	; 0x8000001c
    10fc:	74616572 	strbtvc	r6, [r1], #-1394	; 0xfffffa8e
    1100:	72505f65 	subsvc	r5, r0, #404	; 0x194
    1104:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    1108:	006d4573 	rsbeq	r4, sp, r3, ror r5
    110c:	61657243 	cmnvs	r5, r3, asr #4
    1110:	505f6574 	subspl	r6, pc, r4, ror r5	; <UNPREDICTABLE>
    1114:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    1118:	43007373 	movwmi	r7, #883	; 0x373
    111c:	636f7250 	cmnvs	pc, #80, 4
    1120:	5f737365 	svcpl	0x00737365
    1124:	616e614d 	cmnvs	lr, sp, asr #2
    1128:	00726567 	rsbseq	r6, r2, r7, ror #10
    112c:	665f7369 	ldrbvs	r7, [pc], -r9, ror #6
    1130:	00656572 	rsbeq	r6, r5, r2, ror r5
    1134:	55504354 	ldrbpl	r4, [r0, #-852]	; 0xfffffcac
    1138:	6e6f435f 	mcrvs	3, 3, r4, cr15, cr15, {2}
    113c:	74786574 	ldrbtvc	r6, [r8], #-1396	; 0xfffffa8c
    1140:	44454c00 	strbmi	r4, [r5], #-3072	; 0xfffff400
    1144:	6174535f 	cmnvs	r4, pc, asr r3
    1148:	5f006574 	svcpl	0x00006574
    114c:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
    1150:	6f725043 	svcvs	0x00725043
    1154:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    1158:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
    115c:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
    1160:	76453443 	strbvc	r3, [r5], -r3, asr #8
    1164:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
    1168:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
    116c:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
    1170:	6f72505f 	svcvs	0x0072505f
    1174:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    1178:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
    117c:	4b433032 	blmi	10cd24c <_bss_end+0x10c13e8>
    1180:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
    1184:	65485f6c 	strbvs	r5, [r8, #-3948]	; 0xfffff094
    1188:	4d5f7061 	ldclmi	0, cr7, [pc, #-388]	; 100c <CPSR_IRQ_INHIBIT+0xf8c>
    118c:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
    1190:	35317265 	ldrcc	r7, [r1, #-613]!	; 0xfffffd9b
    1194:	6f6c6c41 	svcvs	0x006c6c41
    1198:	654e5f63 	strbvs	r5, [lr, #-3939]	; 0xfffff09d
    119c:	505f7478 	subspl	r7, pc, r8, ror r4	; <UNPREDICTABLE>
    11a0:	45656761 	strbmi	r6, [r5, #-1889]!	; 0xfffff89f
    11a4:	69730076 	ldmdbvs	r3!, {r1, r2, r4, r5, r6}^
    11a8:	4600657a 			; <UNDEFINED> instruction: 0x4600657a
    11ac:	00656572 	rsbeq	r6, r5, r2, ror r5
    11b0:	7361544e 	cmnvc	r1, #1308622848	; 0x4e000000
    11b4:	74535f6b 	ldrbvc	r5, [r3], #-3947	; 0xfffff095
    11b8:	00657461 	rsbeq	r7, r5, r1, ror #8
    11bc:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
    11c0:	74735f64 	ldrbtvc	r5, [r3], #-3940	; 0xfffff09c
    11c4:	63697461 	cmnvs	r9, #1627389952	; 0x61000000
    11c8:	6972705f 	ldmdbvs	r2!, {r0, r1, r2, r3, r4, r6, ip, sp, lr}^
    11cc:	7469726f 	strbtvc	r7, [r9], #-623	; 0xfffffd91
    11d0:	5a5f0079 	bpl	17c13bc <_bss_end+0x17b5558>
    11d4:	4330324e 	teqmi	r0, #-536870908	; 0xe0000004
    11d8:	6e72654b 	cdpvs	5, 7, cr6, cr2, cr11, {2}
    11dc:	485f6c65 	ldmdami	pc, {r0, r2, r5, r6, sl, fp, sp, lr}^	; <UNPREDICTABLE>
    11e0:	5f706165 	svcpl	0x00706165
    11e4:	616e614d 	cmnvs	lr, sp, asr #2
    11e8:	34726567 	ldrbtcc	r6, [r2], #-1383	; 0xfffffa99
    11ec:	65657246 	strbvs	r7, [r5, #-582]!	; 0xfffffdba
    11f0:	00765045 	rsbseq	r5, r6, r5, asr #32
    11f4:	4d776f4c 	ldclmi	15, cr6, [r7, #-304]!	; 0xfffffed0
    11f8:	726f6d65 	rsbvc	r6, pc, #6464	; 0x1940
    11fc:	5a5f0079 	bpl	17c13e8 <_bss_end+0x17b5584>
    1200:	4330324e 	teqmi	r0, #-536870908	; 0xe0000004
    1204:	6e72654b 	cdpvs	5, 7, cr6, cr2, cr11, {2}
    1208:	485f6c65 	ldmdami	pc, {r0, r2, r5, r6, sl, fp, sp, lr}^	; <UNPREDICTABLE>
    120c:	5f706165 	svcpl	0x00706165
    1210:	616e614d 	cmnvs	lr, sp, asr #2
    1214:	43726567 	cmnmi	r2, #432013312	; 0x19c00000
    1218:	00764534 	rsbseq	r4, r6, r4, lsr r5
    121c:	73614c6d 	cmnvc	r1, #27904	; 0x6d00
    1220:	49505f74 	ldmdbmi	r0, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    1224:	6f5a0044 	svcvs	0x005a0044
    1228:	6569626d 	strbvs	r6, [r9, #-621]!	; 0xfffffd93
    122c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
    1230:	50433631 	subpl	r3, r3, r1, lsr r6
    1234:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    1238:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 1074 <CPSR_IRQ_INHIBIT+0xff4>
    123c:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
    1240:	53387265 	teqpl	r8, #1342177286	; 0x50000006
    1244:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
    1248:	45656c75 	strbmi	r6, [r5, #-3189]!	; 0xfffff38b
    124c:	63730076 	cmnvs	r3, #118	; 0x76
    1250:	5f646568 	svcpl	0x00646568
    1254:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
    1258:	00726574 	rsbseq	r6, r2, r4, ror r5
    125c:	324e5a5f 	subcc	r5, lr, #389120	; 0x5f000
    1260:	654b4330 	strbvs	r4, [fp, #-816]	; 0xfffffcd0
    1264:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
    1268:	6165485f 	cmnvs	r5, pc, asr r8
    126c:	614d5f70 	hvcvs	54768	; 0xd5f0
    1270:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
    1274:	6c413572 	cfstr64vs	mvdx3, [r1], {114}	; 0x72
    1278:	45636f6c 	strbmi	r6, [r3, #-3948]!	; 0xfffff094
    127c:	4b43006a 	blmi	10c142c <_bss_end+0x10b55c8>
    1280:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
    1284:	65485f6c 	strbvs	r5, [r8, #-3948]	; 0xfffff094
    1288:	4d5f7061 	ldclmi	0, cr7, [pc, #-388]	; 110c <CPSR_IRQ_INHIBIT+0x108c>
    128c:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
    1290:	52007265 	andpl	r7, r0, #1342177286	; 0x50000006
    1294:	616e6e75 	smcvs	59109	; 0xe6e5
    1298:	00656c62 	rsbeq	r6, r5, r2, ror #24
    129c:	6f6c6c41 	svcvs	0x006c6c41
    12a0:	43410063 	movtmi	r0, #4195	; 0x1063
    12a4:	69505f54 	ldmdbvs	r0, {r2, r4, r6, r8, r9, sl, fp, ip, lr}^
    12a8:	5a5f006e 	bpl	17c1468 <_bss_end+0x17b5604>
    12ac:	36314b4e 	ldrtcc	r4, [r1], -lr, asr #22
    12b0:	6f725043 	svcvs	0x00725043
    12b4:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    12b8:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
    12bc:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
    12c0:	65473931 	strbvs	r3, [r7, #-2353]	; 0xfffff6cf
    12c4:	75435f74 	strbvc	r5, [r3, #-3956]	; 0xfffff08c
    12c8:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
    12cc:	72505f74 	subsvc	r5, r0, #116, 30	; 0x1d0
    12d0:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    12d4:	00764573 	rsbseq	r4, r6, r3, ror r5
    12d8:	7275436d 	rsbsvc	r4, r5, #-1275068415	; 0xb4000001
    12dc:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
    12e0:	7361545f 	cmnvc	r1, #1593835520	; 0x5f000000
    12e4:	6f4e5f6b 	svcvs	0x004e5f6b
    12e8:	63006564 	movwvs	r6, #1380	; 0x564
    12ec:	635f7570 	cmpvs	pc, #112, 10	; 0x1c000000
    12f0:	65746e6f 	ldrbvs	r6, [r4, #-3695]!	; 0xfffff191
    12f4:	50007478 	andpl	r7, r0, r8, ror r4
    12f8:	6e696761 	cdpvs	7, 6, cr6, cr9, cr1, {3}
    12fc:	6d654d67 	stclvs	13, cr4, [r5, #-412]!	; 0xfffffe64
    1300:	5379726f 	cmnpl	r9, #-268435450	; 0xf0000006
    1304:	00657a69 	rsbeq	r7, r5, r9, ror #20
    1308:	6b736174 	blvs	1cd98e0 <_bss_end+0x1ccda7c>
    130c:	61545400 	cmpvs	r4, r0, lsl #8
    1310:	535f6b73 	cmppl	pc, #117760	; 0x1cc00
    1314:	63757274 	cmnvs	r5, #116, 4	; 0x40000007
    1318:	63530074 	cmpvs	r3, #116	; 0x74
    131c:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
    1320:	6d00656c 	cfstr32vs	mvfx6, [r0, #-432]	; 0xfffffe50
    1324:	73726946 	cmnvc	r2, #1146880	; 0x118000
    1328:	5a5f0074 	bpl	17c1500 <_bss_end+0x17b569c>
    132c:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
    1330:	636f7250 	cmnvs	pc, #80, 4
    1334:	5f737365 	svcpl	0x00737365
    1338:	616e614d 	cmnvs	lr, sp, asr #2
    133c:	39726567 	ldmdbcc	r2!, {r0, r1, r2, r5, r6, r8, sl, sp, lr}^
    1340:	74697753 	strbtvc	r7, [r9], #-1875	; 0xfffff8ad
    1344:	545f6863 	ldrbpl	r6, [pc], #-2147	; 134c <CPSR_IRQ_INHIBIT+0x12cc>
    1348:	3150456f 	cmpcc	r0, pc, ror #10
    134c:	72504338 	subsvc	r4, r0, #56, 6	; 0xe0000000
    1350:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    1354:	694c5f73 	stmdbvs	ip, {r0, r1, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    1358:	4e5f7473 	mrcmi	4, 2, r7, cr15, cr3, {3}
    135c:	0065646f 	rsbeq	r6, r5, pc, ror #8
    1360:	72654b54 	rsbvc	r4, r5, #84, 22	; 0x15000
    1364:	5f6c656e 	svcpl	0x006c656e
    1368:	70616548 	rsbvc	r6, r1, r8, asr #10
    136c:	7568435f 	strbvc	r4, [r8, #-863]!	; 0xfffffca1
    1370:	485f6b6e 	ldmdami	pc, {r1, r2, r3, r5, r6, r8, r9, fp, sp, lr}^	; <UNPREDICTABLE>
    1374:	65646165 	strbvs	r6, [r4, #-357]!	; 0xfffffe9b
    1378:	72430072 	subvc	r0, r3, #114	; 0x72
    137c:	65746165 	ldrbvs	r6, [r4, #-357]!	; 0xfffffe9b
    1380:	69614d5f 	stmdbvs	r1!, {r0, r1, r2, r3, r4, r6, r8, sl, fp, lr}^
    1384:	72505f6e 	subsvc	r5, r0, #440	; 0x1b8
    1388:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    138c:	77530073 			; <UNDEFINED> instruction: 0x77530073
    1390:	68637469 	stmdavs	r3!, {r0, r3, r5, r6, sl, ip, sp, lr}^
    1394:	006f545f 	rsbeq	r5, pc, pc, asr r4	; <UNPREDICTABLE>
    1398:	6f6c6c41 	svcvs	0x006c6c41
    139c:	654e5f63 	strbvs	r5, [lr, #-3939]	; 0xfffff09d
    13a0:	505f7478 	subspl	r7, pc, r8, ror r4	; <UNPREDICTABLE>
    13a4:	00656761 	rsbeq	r6, r5, r1, ror #14
    13a8:	636f7250 	cmnvs	pc, #80, 4
    13ac:	5f737365 	svcpl	0x00737365
    13b0:	72500033 	subsvc	r0, r0, #51	; 0x33
    13b4:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    13b8:	00345f73 	eorseq	r5, r4, r3, ror pc
    13bc:	72656b5f 	rsbvc	r6, r5, #97280	; 0x17c00
    13c0:	5f6c656e 	svcpl	0x006c656e
    13c4:	6e69616d 	powvsez	f6, f1, #5.0
    13c8:	6f725000 	svcvs	0x00725000
    13cc:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    13d0:	2f00325f 	svccs	0x0000325f
    13d4:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
    13d8:	6c69732f 	stclvs	3, cr7, [r9], #-188	; 0xffffff44
    13dc:	79766168 	ldmdbvc	r6!, {r3, r5, r6, r8, sp, lr}^
    13e0:	63532f6a 	cmpvs	r3, #424	; 0x1a8
    13e4:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; 124c <CPSR_IRQ_INHIBIT+0x11cc>
    13e8:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
    13ec:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
    13f0:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
    13f4:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
    13f8:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
    13fc:	6f632d33 	svcvs	0x00632d33
    1400:	7865746e 	stmdavc	r5!, {r1, r2, r3, r5, r6, sl, ip, sp, lr}^
    1404:	77735f74 			; <UNDEFINED> instruction: 0x77735f74
    1408:	68637469 	stmdavs	r3!, {r0, r3, r5, r6, sl, ip, sp, lr}^
    140c:	6e6f6d5f 	mcrvs	13, 3, r6, cr15, cr15, {2}
    1410:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
    1414:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
    1418:	2f6c656e 	svccs	0x006c656e
    141c:	2f637273 	svccs	0x00637273
    1420:	6e69616d 	powvsez	f6, f1, #5.0
    1424:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
    1428:	67615000 	strbvs	r5, [r1, -r0]!
    142c:	7a695365 	bvc	1a561c8 <_bss_end+0x1a4a364>
    1430:	64680065 	strbtvs	r0, [r8], #-101	; 0xffffff9b
    1434:	41003272 	tstmi	r0, r2, ror r2
    1438:	636f6c6c 	cmnvs	pc, #108, 24	; 0x6c00
    143c:	6761505f 			; <UNDEFINED> instruction: 0x6761505f
    1440:	72460065 	subvc	r0, r6, #101	; 0x65
    1444:	505f6565 	subspl	r6, pc, r5, ror #10
    1448:	00656761 	rsbeq	r6, r5, r1, ror #14
    144c:	6e756863 	cdpvs	8, 7, cr6, cr5, cr3, {3}
    1450:	614d006b 	cmpvs	sp, fp, rrx
    1454:	6d006b72 	vstrvs	d6, [r0, #-456]	; 0xfffffe38
    1458:	65676150 	strbvs	r6, [r7, #-336]!	; 0xfffffeb0
    145c:	7469425f 	strbtvc	r4, [r9], #-607	; 0xfffffda1
    1460:	0070616d 	rsbseq	r6, r0, sp, ror #2
    1464:	4f4c475f 	svcmi	0x004c475f
    1468:	5f4c4142 	svcpl	0x004c4142
    146c:	6275735f 	rsbsvs	r7, r5, #2080374785	; 0x7c000001
    1470:	735f495f 	cmpvc	pc, #1556480	; 0x17c000
    1474:	6e72654b 	cdpvs	5, 7, cr6, cr2, cr11, {2}
    1478:	654d6c65 	strbvs	r6, [sp, #-3173]	; 0xfffff39b
    147c:	5a5f006d 	bpl	17c1638 <_bss_end+0x17b57d4>
    1480:	4333314e 	teqmi	r3, #-2147483629	; 0x80000013
    1484:	65676150 	strbvs	r6, [r7, #-336]!	; 0xfffffeb0
    1488:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
    148c:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
    1490:	6c413031 	mcrrvs	0, 3, r3, r1, cr1
    1494:	5f636f6c 	svcpl	0x00636f6c
    1498:	65676150 	strbvs	r6, [r7, #-336]!	; 0xfffffeb0
    149c:	5f007645 	svcpl	0x00007645
    14a0:	30324e5a 	eorscc	r4, r2, sl, asr lr
    14a4:	72654b43 	rsbvc	r4, r5, #68608	; 0x10c00
    14a8:	5f6c656e 	svcpl	0x006c656e
    14ac:	70616548 	rsbvc	r6, r1, r8, asr #10
    14b0:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
    14b4:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
    14b8:	76453243 	strbvc	r3, [r5], -r3, asr #4
    14bc:	6f682f00 	svcvs	0x00682f00
    14c0:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
    14c4:	61686c69 	cmnvs	r8, r9, ror #24
    14c8:	2f6a7976 	svccs	0x006a7976
    14cc:	6f686353 	svcvs	0x00686353
    14d0:	5a2f6c6f 	bpl	bdc694 <_bss_end+0xbd0830>
    14d4:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 1348 <CPSR_IRQ_INHIBIT+0x12c8>
    14d8:	2f657461 	svccs	0x00657461
    14dc:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
    14e0:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
    14e4:	2d33312f 	ldfcss	f3, [r3, #-188]!	; 0xffffff44
    14e8:	746e6f63 	strbtvc	r6, [lr], #-3939	; 0xfffff09d
    14ec:	5f747865 	svcpl	0x00747865
    14f0:	74697773 	strbtvc	r7, [r9], #-1907	; 0xfffff88d
    14f4:	6d5f6863 	ldclvs	8, cr6, [pc, #-396]	; 1370 <CPSR_IRQ_INHIBIT+0x12f0>
    14f8:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
    14fc:	6b2f726f 	blvs	bddec0 <_bss_end+0xbd205c>
    1500:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
    1504:	72732f6c 	rsbsvc	r2, r3, #108, 30	; 0x1b0
    1508:	656d2f63 	strbvs	r2, [sp, #-3939]!	; 0xfffff09d
    150c:	79726f6d 	ldmdbvc	r2!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
    1510:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
    1514:	5f6c656e 	svcpl	0x006c656e
    1518:	70616568 	rsbvc	r6, r1, r8, ror #10
    151c:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
    1520:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
    1524:	50433331 	subpl	r3, r3, r1, lsr r3
    1528:	5f656761 	svcpl	0x00656761
    152c:	616e614d 	cmnvs	lr, sp, asr #2
    1530:	34726567 	ldrbtcc	r6, [r2], #-1383	; 0xfffffa99
    1534:	6b72614d 	blvs	1c99a70 <_bss_end+0x1c8dc0c>
    1538:	00626a45 	rsbeq	r6, r2, r5, asr #20
    153c:	314e5a5f 	cmpcc	lr, pc, asr sl
    1540:	61504333 	cmpvs	r0, r3, lsr r3
    1544:	4d5f6567 	cfldr64mi	mvdx6, [pc, #-412]	; 13b0 <CPSR_IRQ_INHIBIT+0x1330>
    1548:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
    154c:	34437265 	strbcc	r7, [r3], #-613	; 0xfffffd9b
    1550:	5f007645 	svcpl	0x00007645
    1554:	33314e5a 	teqcc	r1, #1440	; 0x5a0
    1558:	67615043 	strbvs	r5, [r1, -r3, asr #32]!
    155c:	614d5f65 	cmpvs	sp, r5, ror #30
    1560:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
    1564:	72463972 	subvc	r3, r6, #1867776	; 0x1c8000
    1568:	505f6565 	subspl	r6, pc, r5, ror #10
    156c:	45656761 	strbmi	r6, [r5, #-1889]!	; 0xfffff89f
    1570:	5043006a 	subpl	r0, r3, sl, rrx
    1574:	5f656761 	svcpl	0x00656761
    1578:	616e614d 	cmnvs	lr, sp, asr #2
    157c:	00726567 	rsbseq	r6, r2, r7, ror #10
    1580:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 14cc <CPSR_IRQ_INHIBIT+0x144c>
    1584:	69732f65 	ldmdbvs	r3!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
    1588:	7661686c 	strbtvc	r6, [r1], -ip, ror #16
    158c:	532f6a79 			; <UNDEFINED> instruction: 0x532f6a79
    1590:	6f6f6863 	svcvs	0x006f6863
    1594:	655a2f6c 	ldrbvs	r2, [sl, #-3948]	; 0xfffff094
    1598:	614d6f72 	hvcvs	55026	; 0xd6f2
    159c:	652f6574 	strvs	r6, [pc, #-1396]!	; 1030 <CPSR_IRQ_INHIBIT+0xfb0>
    15a0:	706d6178 	rsbvc	r6, sp, r8, ror r1
    15a4:	2f73656c 	svccs	0x0073656c
    15a8:	632d3331 			; <UNDEFINED> instruction: 0x632d3331
    15ac:	65746e6f 	ldrbvs	r6, [r4, #-3695]!	; 0xfffff191
    15b0:	735f7478 	cmpvc	pc, #120, 8	; 0x78000000
    15b4:	63746977 	cmnvs	r4, #1949696	; 0x1dc000
    15b8:	6f6d5f68 	svcvs	0x006d5f68
    15bc:	6f74696e 	svcvs	0x0074696e
    15c0:	656b2f72 	strbvs	r2, [fp, #-3954]!	; 0xfffff08e
    15c4:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
    15c8:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
    15cc:	6d656d2f 	stclvs	13, cr6, [r5, #-188]!	; 0xffffff44
    15d0:	2f79726f 	svccs	0x0079726f
    15d4:	65676170 	strbvs	r6, [r7, #-368]!	; 0xfffffe90
    15d8:	70632e73 	rsbvc	r2, r3, r3, ror lr
    15dc:	5a5f0070 	bpl	17c17a4 <_bss_end+0x17b5940>
    15e0:	4333314e 	teqmi	r3, #-2147483629	; 0x80000013
    15e4:	65676150 	strbvs	r6, [r7, #-336]!	; 0xfffffeb0
    15e8:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
    15ec:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
    15f0:	76453243 	strbvc	r3, [r5], -r3, asr #4
    15f4:	76696400 	strbtvc	r6, [r9], -r0, lsl #8
    15f8:	6e656469 	cdpvs	4, 6, cr6, cr5, cr9, {3}
    15fc:	616d0064 	cmnvs	sp, r4, rrx
    1600:	74006b73 	strvc	r6, [r0], #-2931	; 0xfffff48d
    1604:	00706d65 	rsbseq	r6, r0, r5, ror #26
    1608:	74736166 	ldrbtvc	r6, [r3], #-358	; 0xfffffe9a
    160c:	646f6d5f 	strbtvs	r6, [pc], #-3423	; 1614 <CPSR_IRQ_INHIBIT+0x1594>
    1610:	73756c75 	cmnvc	r5, #29952	; 0x7500
    1614:	6f6c7300 	svcvs	0x006c7300
    1618:	61700074 	cmnvs	r0, r4, ror r0
    161c:	695f6567 	ldmdbvs	pc, {r0, r1, r2, r5, r6, r8, sl, sp, lr}^	; <UNPREDICTABLE>
    1620:	64007864 	strvs	r7, [r0], #-2148	; 0xfffff79c
    1624:	73697669 	cmnvc	r9, #110100480	; 0x6900000
    1628:	6600726f 	strvs	r7, [r0], -pc, ror #4
    162c:	5f747361 	svcpl	0x00747361
    1630:	69766964 	ldmdbvs	r6!, {r2, r5, r6, r8, fp, sp, lr}^
    1634:	75006564 	strvc	r6, [r0, #-1380]	; 0xfffffa9c
    1638:	00646573 	rsbeq	r6, r4, r3, ror r5
    163c:	32315a5f 	eorscc	r5, r1, #389120	; 0x5f000
    1640:	74736166 	ldrbtvc	r6, [r3], #-358	; 0xfffffe9a
    1644:	646f6d5f 	strbtvs	r6, [pc], #-3423	; 164c <CPSR_IRQ_INHIBIT+0x15cc>
    1648:	73756c75 	cmnvc	r5, #29952	; 0x7500
    164c:	5f006a6a 	svcpl	0x00006a6a
    1650:	424f4c47 	submi	r4, pc, #18176	; 0x4700
    1654:	5f5f4c41 	svcpl	0x005f4c41
    1658:	5f627573 	svcpl	0x00627573
    165c:	50735f49 	rsbspl	r5, r3, r9, asr #30
    1660:	5f656761 	svcpl	0x00656761
    1664:	616e614d 	cmnvs	lr, sp, asr #2
    1668:	00726567 	rsbseq	r6, r2, r7, ror #10
    166c:	636e7566 	cmnvs	lr, #427819008	; 0x19800000
    1670:	00727470 	rsbseq	r7, r2, r0, ror r4
    1674:	665f7369 	ldrbvs	r7, [pc], -r9, ror #6
    1678:	74737269 	ldrbtvc	r7, [r3], #-617	; 0xfffffd97
    167c:	6d69745f 	cfstrdvs	mvd7, [r9, #-380]!	; 0xfffffe84
    1680:	6c410065 	mcrrvs	0, 6, r0, r1, cr5
    1684:	3c636f6c 	stclcc	15, cr6, [r3], #-432	; 0xfffffe50
    1688:	73615454 	cmnvc	r1, #84, 8	; 0x54000000
    168c:	74535f6b 	ldrbvc	r5, [r3], #-3947	; 0xfffff095
    1690:	74637572 	strbtvc	r7, [r3], #-1394	; 0xfffffa8e
    1694:	5a5f003e 	bpl	17c1794 <_bss_end+0x17b5930>
    1698:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
    169c:	636f7250 	cmnvs	pc, #80, 4
    16a0:	5f737365 	svcpl	0x00737365
    16a4:	616e614d 	cmnvs	lr, sp, asr #2
    16a8:	43726567 	cmnmi	r2, #432013312	; 0x19c00000
    16ac:	00764532 	rsbseq	r4, r6, r2, lsr r5
    16b0:	324e5a5f 	subcc	r5, lr, #389120	; 0x5f000
    16b4:	654b4330 	strbvs	r4, [fp, #-816]	; 0xfffffcd0
    16b8:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
    16bc:	6165485f 	cmnvs	r5, pc, asr r8
    16c0:	614d5f70 	hvcvs	54768	; 0xd5f0
    16c4:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
    16c8:	6c413572 	cfstr64vs	mvdx3, [r1], {114}	; 0x72
    16cc:	49636f6c 	stmdbmi	r3!, {r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
    16d0:	50433831 	subpl	r3, r3, r1, lsr r8
    16d4:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    16d8:	4c5f7373 	mrrcmi	3, 7, r7, pc, cr3	; <UNPREDICTABLE>
    16dc:	5f747369 	svcpl	0x00747369
    16e0:	65646f4e 	strbvs	r6, [r4, #-3918]!	; 0xfffff0b2
    16e4:	54504545 	ldrbpl	r4, [r0], #-1349	; 0xfffffabb
    16e8:	5f00765f 	svcpl	0x0000765f
    16ec:	424f4c47 	submi	r4, pc, #18176	; 0x4700
    16f0:	5f5f4c41 	svcpl	0x005f4c41
    16f4:	5f627573 	svcpl	0x00627573
    16f8:	50735f49 	rsbspl	r5, r3, r9, asr #30
    16fc:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    1700:	674d7373 	smlsldxvs	r7, sp, r3, r3
    1704:	72700072 	rsbsvc	r0, r0, #114	; 0x72
    1708:	6f6e636f 	svcvs	0x006e636f
    170c:	41006564 	tstmi	r0, r4, ror #10
    1710:	636f6c6c 	cmnvs	pc, #108, 24	; 0x6c00
    1714:	7250433c 	subsvc	r4, r0, #60, 6	; 0xf0000000
    1718:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    171c:	694c5f73 	stmdbvs	ip, {r0, r1, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    1720:	4e5f7473 	mrcmi	4, 2, r7, cr15, cr3, {3}
    1724:	3e65646f 	cdpcc	4, 6, cr6, cr5, cr15, {3}
    1728:	6f682f00 	svcvs	0x00682f00
    172c:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
    1730:	61686c69 	cmnvs	r8, r9, ror #24
    1734:	2f6a7976 	svccs	0x006a7976
    1738:	6f686353 	svcvs	0x00686353
    173c:	5a2f6c6f 	bpl	bdc900 <_bss_end+0xbd0a9c>
    1740:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 15b4 <CPSR_IRQ_INHIBIT+0x1534>
    1744:	2f657461 	svccs	0x00657461
    1748:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
    174c:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
    1750:	2d33312f 	ldfcss	f3, [r3, #-188]!	; 0xffffff44
    1754:	746e6f63 	strbtvc	r6, [lr], #-3939	; 0xfffff09d
    1758:	5f747865 	svcpl	0x00747865
    175c:	74697773 	strbtvc	r7, [r9], #-1907	; 0xfffff88d
    1760:	6d5f6863 	ldclvs	8, cr6, [pc, #-396]	; 15dc <CPSR_IRQ_INHIBIT+0x155c>
    1764:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
    1768:	6b2f726f 	blvs	bde12c <_bss_end+0xbd22c8>
    176c:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
    1770:	72732f6c 	rsbsvc	r2, r3, #108, 30	; 0x1b0
    1774:	72702f63 	rsbsvc	r2, r0, #396	; 0x18c
    1778:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    177c:	72702f73 	rsbsvc	r2, r0, #460	; 0x1cc
    1780:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    1784:	616d5f73 	smcvs	54771	; 0xd5f3
    1788:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
    178c:	70632e72 	rsbvc	r2, r3, r2, ror lr
    1790:	5a5f0070 	bpl	17c1958 <_bss_end+0x17b5af4>
    1794:	4330324e 	teqmi	r0, #-536870908	; 0xe0000004
    1798:	6e72654b 	cdpvs	5, 7, cr6, cr2, cr11, {2}
    179c:	485f6c65 	ldmdami	pc, {r0, r2, r5, r6, sl, fp, sp, lr}^	; <UNPREDICTABLE>
    17a0:	5f706165 	svcpl	0x00706165
    17a4:	616e614d 	cmnvs	lr, sp, asr #2
    17a8:	35726567 	ldrbcc	r6, [r2, #-1383]!	; 0xfffffa99
    17ac:	6f6c6c41 	svcvs	0x006c6c41
    17b0:	32314963 	eorscc	r4, r1, #1622016	; 0x18c000
    17b4:	73615454 	cmnvc	r1, #84, 8	; 0x54000000
    17b8:	74535f6b 	ldrbvc	r5, [r3], #-3947	; 0xfffff095
    17bc:	74637572 	strbtvc	r7, [r3], #-1394	; 0xfffffa8e
    17c0:	54504545 	ldrbpl	r4, [r0], #-1349	; 0xfffffabb
    17c4:	2f00765f 	svccs	0x0000765f
    17c8:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
    17cc:	6c69732f 	stclvs	3, cr7, [r9], #-188	; 0xffffff44
    17d0:	79766168 	ldmdbvc	r6!, {r3, r5, r6, r8, sp, lr}^
    17d4:	63532f6a 	cmpvs	r3, #424	; 0x1a8
    17d8:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; 1640 <CPSR_IRQ_INHIBIT+0x15c0>
    17dc:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
    17e0:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
    17e4:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
    17e8:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
    17ec:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
    17f0:	6f632d33 	svcvs	0x00632d33
    17f4:	7865746e 	stmdavc	r5!, {r1, r2, r3, r5, r6, sl, ip, sp, lr}^
    17f8:	77735f74 			; <UNDEFINED> instruction: 0x77735f74
    17fc:	68637469 	stmdavs	r3!, {r0, r3, r5, r6, sl, ip, sp, lr}^
    1800:	6e6f6d5f 	mcrvs	13, 3, r6, cr15, cr15, {2}
    1804:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
    1808:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
    180c:	2f6c656e 	svccs	0x006c656e
    1810:	2f637273 	svccs	0x00637273
    1814:	636f7270 	cmnvs	pc, #112, 4
    1818:	2f737365 	svccs	0x00737365
    181c:	74697773 	strbtvc	r7, [r9], #-1907	; 0xfffff88d
    1820:	732e6863 			; <UNDEFINED> instruction: 0x732e6863
    1824:	554e4700 	strbpl	r4, [lr, #-1792]	; 0xfffff900
    1828:	20534120 	subscs	r4, r3, r0, lsr #2
    182c:	34332e32 	ldrtcc	r2, [r3], #-3634	; 0xfffff1ce
    1830:	6f682f00 	svcvs	0x00682f00
    1834:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
    1838:	61686c69 	cmnvs	r8, r9, ror #24
    183c:	2f6a7976 	svccs	0x006a7976
    1840:	6f686353 	svcvs	0x00686353
    1844:	5a2f6c6f 	bpl	bdca08 <_bss_end+0xbd0ba4>
    1848:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 16bc <CPSR_IRQ_INHIBIT+0x163c>
    184c:	2f657461 	svccs	0x00657461
    1850:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
    1854:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
    1858:	2d33312f 	ldfcss	f3, [r3, #-188]!	; 0xffffff44
    185c:	746e6f63 	strbtvc	r6, [lr], #-3939	; 0xfffff09d
    1860:	5f747865 	svcpl	0x00747865
    1864:	74697773 	strbtvc	r7, [r9], #-1907	; 0xfffff88d
    1868:	6d5f6863 	ldclvs	8, cr6, [pc, #-396]	; 16e4 <CPSR_IRQ_INHIBIT+0x1664>
    186c:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
    1870:	6b2f726f 	blvs	bde234 <_bss_end+0xbd23d0>
    1874:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
    1878:	72732f6c 	rsbsvc	r2, r3, #108, 30	; 0x1b0
    187c:	74732f63 	ldrbtvc	r2, [r3], #-3939	; 0xfffff09d
    1880:	2e747261 	cdpcs	2, 7, cr7, cr4, cr1, {3}
    1884:	635f0073 	cmpvs	pc, #115	; 0x73
    1888:	6174735f 	cmnvs	r4, pc, asr r3
    188c:	70757472 	rsbsvc	r7, r5, r2, ror r4
    1890:	73625f00 	cmnvc	r2, #0, 30
    1894:	74735f73 	ldrbtvc	r5, [r3], #-3955	; 0xfffff08d
    1898:	00747261 	rsbseq	r7, r4, r1, ror #4
    189c:	54435f5f 	strbpl	r5, [r3], #-3935	; 0xfffff0a1
    18a0:	455f524f 	ldrbmi	r5, [pc, #-591]	; 1659 <CPSR_IRQ_INHIBIT+0x15d9>
    18a4:	5f5f444e 	svcpl	0x005f444e
    18a8:	435f5f00 	cmpmi	pc, #0, 30
    18ac:	5f524f54 	svcpl	0x00524f54
    18b0:	5453494c 	ldrbpl	r4, [r3], #-2380	; 0xfffff6b4
    18b4:	5f005f5f 	svcpl	0x00005f5f
    18b8:	4f54445f 	svcmi	0x0054445f
    18bc:	4e455f52 	mcrmi	15, 2, r5, cr5, cr2, {2}
    18c0:	005f5f44 	subseq	r5, pc, r4, asr #30
    18c4:	7070635f 	rsbsvc	r6, r0, pc, asr r3
    18c8:	7568735f 	strbvc	r7, [r8, #-863]!	; 0xfffffca1
    18cc:	776f6474 			; <UNDEFINED> instruction: 0x776f6474
    18d0:	625f006e 	subsvs	r0, pc, #110	; 0x6e
    18d4:	655f7373 	ldrbvs	r7, [pc, #-883]	; 1569 <CPSR_IRQ_INHIBIT+0x14e9>
    18d8:	5f00646e 	svcpl	0x0000646e
    18dc:	4f54445f 	svcmi	0x0054445f
    18e0:	494c5f52 	stmdbmi	ip, {r1, r4, r6, r8, r9, sl, fp, ip, lr}^
    18e4:	5f5f5453 	svcpl	0x005f5453
    18e8:	6f746400 	svcvs	0x00746400
    18ec:	74705f72 	ldrbtvc	r5, [r0], #-3954	; 0xfffff08e
    18f0:	74630072 	strbtvc	r0, [r3], #-114	; 0xffffff8e
    18f4:	705f726f 	subsvc	r7, pc, pc, ror #4
    18f8:	2f007274 	svccs	0x00007274
    18fc:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
    1900:	6c69732f 	stclvs	3, cr7, [r9], #-188	; 0xffffff44
    1904:	79766168 	ldmdbvc	r6!, {r3, r5, r6, r8, sp, lr}^
    1908:	63532f6a 	cmpvs	r3, #424	; 0x1a8
    190c:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; 1774 <CPSR_IRQ_INHIBIT+0x16f4>
    1910:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
    1914:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
    1918:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
    191c:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
    1920:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
    1924:	6f632d33 	svcvs	0x00632d33
    1928:	7865746e 	stmdavc	r5!, {r1, r2, r3, r5, r6, sl, ip, sp, lr}^
    192c:	77735f74 			; <UNDEFINED> instruction: 0x77735f74
    1930:	68637469 	stmdavs	r3!, {r0, r3, r5, r6, sl, ip, sp, lr}^
    1934:	6e6f6d5f 	mcrvs	13, 3, r6, cr15, cr15, {2}
    1938:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
    193c:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
    1940:	2f6c656e 	svccs	0x006c656e
    1944:	2f637273 	svccs	0x00637273
    1948:	72617473 	rsbvc	r7, r1, #1929379840	; 0x73000000
    194c:	2e707574 	mrccs	5, 3, r7, cr0, cr4, {3}
    1950:	00707063 	rsbseq	r7, r0, r3, rrx
    1954:	7070635f 	rsbsvc	r6, r0, pc, asr r3
    1958:	6174735f 	cmnvs	r4, pc, asr r3
    195c:	70757472 	rsbsvc	r7, r5, r2, ror r4
    1960:	706e6600 	rsbvc	r6, lr, r0, lsl #12
    1964:	2f007274 	svccs	0x00007274
    1968:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
    196c:	6c69732f 	stclvs	3, cr7, [r9], #-188	; 0xffffff44
    1970:	79766168 	ldmdbvc	r6!, {r3, r5, r6, r8, sp, lr}^
    1974:	63532f6a 	cmpvs	r3, #424	; 0x1a8
    1978:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; 17e0 <CPSR_IRQ_INHIBIT+0x1760>
    197c:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
    1980:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
    1984:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
    1988:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
    198c:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
    1990:	6f632d33 	svcvs	0x00632d33
    1994:	7865746e 	stmdavc	r5!, {r1, r2, r3, r5, r6, sl, ip, sp, lr}^
    1998:	77735f74 			; <UNDEFINED> instruction: 0x77735f74
    199c:	68637469 	stmdavs	r3!, {r0, r3, r5, r6, sl, ip, sp, lr}^
    19a0:	6e6f6d5f 	mcrvs	13, 3, r6, cr15, cr15, {2}
    19a4:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
    19a8:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
    19ac:	2f62696c 	svccs	0x0062696c
    19b0:	2f637273 	svccs	0x00637273
    19b4:	73647473 	cmnvc	r4, #1929379840	; 0x73000000
    19b8:	6e697274 	mcrvs	2, 3, r7, cr9, cr4, {3}
    19bc:	70632e67 	rsbvc	r2, r3, r7, ror #28
    19c0:	5a5f0070 	bpl	17c1b88 <_bss_end+0x17b5d24>
    19c4:	6f746934 	svcvs	0x00746934
    19c8:	63506a61 	cmpvs	r0, #397312	; 0x61000
    19cc:	2e2e006a 	cdpcs	0, 2, cr0, cr14, cr10, {3}
    19d0:	2f2e2e2f 	svccs	0x002e2e2f
    19d4:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    19d8:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    19dc:	2f2e2e2f 	svccs	0x002e2e2f
    19e0:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    19e4:	632f6363 			; <UNDEFINED> instruction: 0x632f6363
    19e8:	69666e6f 	stmdbvs	r6!, {r0, r1, r2, r3, r5, r6, r9, sl, fp, sp, lr}^
    19ec:	72612f67 	rsbvc	r2, r1, #412	; 0x19c
    19f0:	696c2f6d 	stmdbvs	ip!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp}^
    19f4:	75663162 	strbvc	r3, [r6, #-354]!	; 0xfffffe9e
    19f8:	2e73636e 	cdpcs	3, 7, cr6, cr3, cr14, {3}
    19fc:	622f0053 	eorvs	r0, pc, #83	; 0x53
    1a00:	646c6975 	strbtvs	r6, [ip], #-2421	; 0xfffff68b
    1a04:	6363672f 	cmnvs	r3, #12320768	; 0xbc0000
    1a08:	6d72612d 	ldfvse	f6, [r2, #-180]!	; 0xffffff4c
    1a0c:	6e6f6e2d 	cdpvs	14, 6, cr6, cr15, cr13, {1}
    1a10:	61652d65 	cmnvs	r5, r5, ror #26
    1a14:	472d6962 	strmi	r6, [sp, -r2, ror #18]!
    1a18:	546b396c 	strbtpl	r3, [fp], #-2412	; 0xfffff694
    1a1c:	63672f39 	cmnvs	r7, #57, 30	; 0xe4
    1a20:	72612d63 	rsbvc	r2, r1, #6336	; 0x18c0
    1a24:	6f6e2d6d 	svcvs	0x006e2d6d
    1a28:	652d656e 	strvs	r6, [sp, #-1390]!	; 0xfffffa92
    1a2c:	2d696261 	sfmcs	f6, 2, [r9, #-388]!	; 0xfffffe7c
    1a30:	30322d39 	eorscc	r2, r2, r9, lsr sp
    1a34:	712d3931 			; <UNDEFINED> instruction: 0x712d3931
    1a38:	75622f34 	strbvc	r2, [r2, #-3892]!	; 0xfffff0cc
    1a3c:	2f646c69 	svccs	0x00646c69
    1a40:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
    1a44:	656e6f6e 	strbvs	r6, [lr, #-3950]!	; 0xfffff092
    1a48:	6261652d 	rsbvs	r6, r1, #188743680	; 0xb400000
    1a4c:	72612f69 	rsbvc	r2, r1, #420	; 0x1a4
    1a50:	35762f6d 	ldrbcc	r2, [r6, #-3949]!	; 0xfffff093
    1a54:	682f6574 	stmdavs	pc!, {r2, r4, r5, r6, r8, sl, sp, lr}	; <UNPREDICTABLE>
    1a58:	2f647261 	svccs	0x00647261
    1a5c:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    1a60:	54006363 	strpl	r6, [r0], #-867	; 0xfffffc9d
    1a64:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1a68:	50435f54 	subpl	r5, r3, r4, asr pc
    1a6c:	6f635f55 	svcvs	0x00635f55
    1a70:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1a74:	63373161 	teqvs	r7, #1073741848	; 0x40000018
    1a78:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1a7c:	00376178 	eorseq	r6, r7, r8, ror r1
    1a80:	5f617369 	svcpl	0x00617369
    1a84:	5f746962 	svcpl	0x00746962
    1a88:	645f7066 	ldrbvs	r7, [pc], #-102	; 1a90 <CPSR_IRQ_INHIBIT+0x1a10>
    1a8c:	61006c62 	tstvs	r0, r2, ror #24
    1a90:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1a94:	5f686372 	svcpl	0x00686372
    1a98:	6d6d7769 	stclvs	7, cr7, [sp, #-420]!	; 0xfffffe5c
    1a9c:	54007478 	strpl	r7, [r0], #-1144	; 0xfffffb88
    1aa0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1aa4:	50435f54 	subpl	r5, r3, r4, asr pc
    1aa8:	6f635f55 	svcvs	0x00635f55
    1aac:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1ab0:	0033326d 	eorseq	r3, r3, sp, ror #4
    1ab4:	5f4d5241 	svcpl	0x004d5241
    1ab8:	54005145 	strpl	r5, [r0], #-325	; 0xfffffebb
    1abc:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1ac0:	50435f54 	subpl	r5, r3, r4, asr pc
    1ac4:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1ac8:	3531316d 	ldrcc	r3, [r1, #-365]!	; 0xfffffe93
    1acc:	66327436 			; <UNDEFINED> instruction: 0x66327436
    1ad0:	73690073 	cmnvc	r9, #115	; 0x73
    1ad4:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1ad8:	68745f74 	ldmdavs	r4!, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    1adc:	00626d75 	rsbeq	r6, r2, r5, ror sp
    1ae0:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1ae4:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1ae8:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1aec:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1af0:	37356178 			; <UNDEFINED> instruction: 0x37356178
    1af4:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1af8:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    1afc:	41420033 	cmpmi	r2, r3, lsr r0
    1b00:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1b04:	5f484352 	svcpl	0x00484352
    1b08:	425f4d38 	subsmi	r4, pc, #56, 26	; 0xe00
    1b0c:	00455341 	subeq	r5, r5, r1, asr #6
    1b10:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1b14:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1b18:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1b1c:	31386d72 	teqcc	r8, r2, ror sp
    1b20:	41540030 	cmpmi	r4, r0, lsr r0
    1b24:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1b28:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1b2c:	6567785f 	strbvs	r7, [r7, #-2143]!	; 0xfffff7a1
    1b30:	0031656e 	eorseq	r6, r1, lr, ror #10
    1b34:	5f4d5241 	svcpl	0x004d5241
    1b38:	5f534350 	svcpl	0x00534350
    1b3c:	43504141 	cmpmi	r0, #1073741840	; 0x40000010
    1b40:	57495f53 	smlsldpl	r5, r9, r3, pc	; <UNPREDICTABLE>
    1b44:	54584d4d 	ldrbpl	r4, [r8], #-3405	; 0xfffff2b3
    1b48:	53414200 	movtpl	r4, #4608	; 0x1200
    1b4c:	52415f45 	subpl	r5, r1, #276	; 0x114
    1b50:	305f4843 	subscc	r4, pc, r3, asr #16
    1b54:	53414200 	movtpl	r4, #4608	; 0x1200
    1b58:	52415f45 	subpl	r5, r1, #276	; 0x114
    1b5c:	325f4843 	subscc	r4, pc, #4390912	; 0x430000
    1b60:	53414200 	movtpl	r4, #4608	; 0x1200
    1b64:	52415f45 	subpl	r5, r1, #276	; 0x114
    1b68:	335f4843 	cmpcc	pc, #4390912	; 0x430000
    1b6c:	53414200 	movtpl	r4, #4608	; 0x1200
    1b70:	52415f45 	subpl	r5, r1, #276	; 0x114
    1b74:	345f4843 	ldrbcc	r4, [pc], #-2115	; 1b7c <CPSR_IRQ_INHIBIT+0x1afc>
    1b78:	53414200 	movtpl	r4, #4608	; 0x1200
    1b7c:	52415f45 	subpl	r5, r1, #276	; 0x114
    1b80:	365f4843 	ldrbcc	r4, [pc], -r3, asr #16
    1b84:	53414200 	movtpl	r4, #4608	; 0x1200
    1b88:	52415f45 	subpl	r5, r1, #276	; 0x114
    1b8c:	375f4843 	ldrbcc	r4, [pc, -r3, asr #16]
    1b90:	52415400 	subpl	r5, r1, #0, 8
    1b94:	5f544547 	svcpl	0x00544547
    1b98:	5f555043 	svcpl	0x00555043
    1b9c:	61637378 	smcvs	14136	; 0x3738
    1ba0:	6900656c 	stmdbvs	r0, {r2, r3, r5, r6, r8, sl, sp, lr}
    1ba4:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1ba8:	705f7469 	subsvc	r7, pc, r9, ror #8
    1bac:	72646572 	rsbvc	r6, r4, #478150656	; 0x1c800000
    1bb0:	54007365 	strpl	r7, [r0], #-869	; 0xfffffc9b
    1bb4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1bb8:	50435f54 	subpl	r5, r3, r4, asr pc
    1bbc:	6f635f55 	svcvs	0x00635f55
    1bc0:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1bc4:	0033336d 	eorseq	r3, r3, sp, ror #6
    1bc8:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1bcc:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1bd0:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1bd4:	74376d72 	ldrtvc	r6, [r7], #-3442	; 0xfffff28e
    1bd8:	00696d64 	rsbeq	r6, r9, r4, ror #26
    1bdc:	5f617369 	svcpl	0x00617369
    1be0:	69626f6e 	stmdbvs	r2!, {r1, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
    1be4:	41540074 	cmpmi	r4, r4, ror r0
    1be8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1bec:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1bf0:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1bf4:	36373131 			; <UNDEFINED> instruction: 0x36373131
    1bf8:	73667a6a 	cmnvc	r6, #434176	; 0x6a000
    1bfc:	61736900 	cmnvs	r3, r0, lsl #18
    1c00:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1c04:	7066765f 	rsbvc	r7, r6, pc, asr r6
    1c08:	41003276 	tstmi	r0, r6, ror r2
    1c0c:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    1c10:	555f5343 	ldrbpl	r5, [pc, #-835]	; 18d5 <CPSR_IRQ_INHIBIT+0x1855>
    1c14:	4f4e4b4e 	svcmi	0x004e4b4e
    1c18:	54004e57 	strpl	r4, [r0], #-3671	; 0xfffff1a9
    1c1c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1c20:	50435f54 	subpl	r5, r3, r4, asr pc
    1c24:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1c28:	0065396d 	rsbeq	r3, r5, sp, ror #18
    1c2c:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1c30:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1c34:	54355f48 	ldrtpl	r5, [r5], #-3912	; 0xfffff0b8
    1c38:	61004a45 	tstvs	r0, r5, asr #20
    1c3c:	635f6d72 	cmpvs	pc, #7296	; 0x1c80
    1c40:	6d736663 	ldclvs	6, cr6, [r3, #-396]!	; 0xfffffe74
    1c44:	6174735f 	cmnvs	r4, pc, asr r3
    1c48:	61006574 	tstvs	r0, r4, ror r5
    1c4c:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1c50:	35686372 	strbcc	r6, [r8, #-882]!	; 0xfffffc8e
    1c54:	75006574 	strvc	r6, [r0, #-1396]	; 0xfffffa8c
    1c58:	6570736e 	ldrbvs	r7, [r0, #-878]!	; 0xfffffc92
    1c5c:	74735f63 	ldrbtvc	r5, [r3], #-3939	; 0xfffff09d
    1c60:	676e6972 			; <UNDEFINED> instruction: 0x676e6972
    1c64:	73690073 	cmnvc	r9, #115	; 0x73
    1c68:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1c6c:	65735f74 	ldrbvs	r5, [r3, #-3956]!	; 0xfffff08c
    1c70:	5f5f0063 	svcpl	0x005f0063
    1c74:	5f7a6c63 	svcpl	0x007a6c63
    1c78:	00626174 	rsbeq	r6, r2, r4, ror r1
    1c7c:	5f4d5241 	svcpl	0x004d5241
    1c80:	61004356 	tstvs	r0, r6, asr r3
    1c84:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1c88:	5f686372 	svcpl	0x00686372
    1c8c:	61637378 	smcvs	14136	; 0x3738
    1c90:	4100656c 	tstmi	r0, ip, ror #10
    1c94:	4c5f4d52 	mrrcmi	13, 5, r4, pc, cr2	; <UNPREDICTABLE>
    1c98:	52410045 	subpl	r0, r1, #69	; 0x45
    1c9c:	53565f4d 	cmppl	r6, #308	; 0x134
    1ca0:	4d524100 	ldfmie	f4, [r2, #-0]
    1ca4:	0045475f 	subeq	r4, r5, pc, asr r7
    1ca8:	5f6d7261 	svcpl	0x006d7261
    1cac:	656e7574 	strbvs	r7, [lr, #-1396]!	; 0xfffffa8c
    1cb0:	7274735f 	rsbsvc	r7, r4, #2080374785	; 0x7c000001
    1cb4:	61676e6f 	cmnvs	r7, pc, ror #28
    1cb8:	63006d72 	movwvs	r6, #3442	; 0xd72
    1cbc:	6c706d6f 	ldclvs	13, cr6, [r0], #-444	; 0xfffffe44
    1cc0:	66207865 	strtvs	r7, [r0], -r5, ror #16
    1cc4:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
    1cc8:	52415400 	subpl	r5, r1, #0, 8
    1ccc:	5f544547 	svcpl	0x00544547
    1cd0:	5f555043 	svcpl	0x00555043
    1cd4:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1cd8:	31617865 	cmncc	r1, r5, ror #16
    1cdc:	41540035 	cmpmi	r4, r5, lsr r0
    1ce0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1ce4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1ce8:	3761665f 			; <UNDEFINED> instruction: 0x3761665f
    1cec:	65743632 	ldrbvs	r3, [r4, #-1586]!	; 0xfffff9ce
    1cf0:	52415400 	subpl	r5, r1, #0, 8
    1cf4:	5f544547 	svcpl	0x00544547
    1cf8:	5f555043 	svcpl	0x00555043
    1cfc:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1d00:	31617865 	cmncc	r1, r5, ror #16
    1d04:	52410037 	subpl	r0, r1, #55	; 0x37
    1d08:	54475f4d 	strbpl	r5, [r7], #-3917	; 0xfffff0b3
    1d0c:	52415400 	subpl	r5, r1, #0, 8
    1d10:	5f544547 	svcpl	0x00544547
    1d14:	5f555043 	svcpl	0x00555043
    1d18:	766f656e 	strbtvc	r6, [pc], -lr, ror #10
    1d1c:	65737265 	ldrbvs	r7, [r3, #-613]!	; 0xfffffd9b
    1d20:	2e00316e 	adfcssz	f3, f0, #0.5
    1d24:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1d28:	2f2e2e2f 	svccs	0x002e2e2f
    1d2c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1d30:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1d34:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    1d38:	2f636367 	svccs	0x00636367
    1d3c:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    1d40:	2e326363 	cdpcs	3, 3, cr6, cr2, cr3, {3}
    1d44:	41540063 	cmpmi	r4, r3, rrx
    1d48:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1d4c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1d50:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1d54:	72786574 	rsbsvc	r6, r8, #116, 10	; 0x1d000000
    1d58:	42006634 	andmi	r6, r0, #52, 12	; 0x3400000
    1d5c:	5f455341 	svcpl	0x00455341
    1d60:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1d64:	4d45375f 	stclmi	7, cr3, [r5, #-380]	; 0xfffffe84
    1d68:	52415400 	subpl	r5, r1, #0, 8
    1d6c:	5f544547 	svcpl	0x00544547
    1d70:	5f555043 	svcpl	0x00555043
    1d74:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1d78:	31617865 	cmncc	r1, r5, ror #16
    1d7c:	61680032 	cmnvs	r8, r2, lsr r0
    1d80:	61766873 	cmnvs	r6, r3, ror r8
    1d84:	00745f6c 	rsbseq	r5, r4, ip, ror #30
    1d88:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1d8c:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1d90:	4b365f48 	blmi	d99ab8 <_bss_end+0xd8dc54>
    1d94:	7369005a 	cmnvc	r9, #90	; 0x5a
    1d98:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1d9c:	61007374 	tstvs	r0, r4, ror r3
    1da0:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1da4:	5f686372 	svcpl	0x00686372
    1da8:	5f6d7261 	svcpl	0x006d7261
    1dac:	69647768 	stmdbvs	r4!, {r3, r5, r6, r8, r9, sl, ip, sp, lr}^
    1db0:	72610076 	rsbvc	r0, r1, #118	; 0x76
    1db4:	70665f6d 	rsbvc	r5, r6, sp, ror #30
    1db8:	65645f75 	strbvs	r5, [r4, #-3957]!	; 0xfffff08b
    1dbc:	69006373 	stmdbvs	r0, {r0, r1, r4, r5, r6, r8, r9, sp, lr}
    1dc0:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1dc4:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    1dc8:	00363170 	eorseq	r3, r6, r0, ror r1
    1dcc:	20554e47 	subscs	r4, r5, r7, asr #28
    1dd0:	20373143 	eorscs	r3, r7, r3, asr #2
    1dd4:	2e322e39 	mrccs	14, 1, r2, cr2, cr9, {1}
    1dd8:	30322031 	eorscc	r2, r2, r1, lsr r0
    1ddc:	30313931 	eorscc	r3, r1, r1, lsr r9
    1de0:	28203532 	stmdacs	r0!, {r1, r4, r5, r8, sl, ip, sp}
    1de4:	656c6572 	strbvs	r6, [ip, #-1394]!	; 0xfffffa8e
    1de8:	29657361 	stmdbcs	r5!, {r0, r5, r6, r8, r9, ip, sp, lr}^
    1dec:	52415b20 	subpl	r5, r1, #32, 22	; 0x8000
    1df0:	72612f4d 	rsbvc	r2, r1, #308	; 0x134
    1df4:	2d392d6d 	ldccs	13, cr2, [r9, #-436]!	; 0xfffffe4c
    1df8:	6e617262 	cdpvs	2, 6, cr7, cr1, cr2, {3}
    1dfc:	72206863 	eorvc	r6, r0, #6488064	; 0x630000
    1e00:	73697665 	cmnvc	r9, #105906176	; 0x6500000
    1e04:	206e6f69 	rsbcs	r6, lr, r9, ror #30
    1e08:	35373732 	ldrcc	r3, [r7, #-1842]!	; 0xfffff8ce
    1e0c:	205d3939 	subscs	r3, sp, r9, lsr r9
    1e10:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
    1e14:	6d2d206d 	stcvs	0, cr2, [sp, #-436]!	; 0xfffffe4c
    1e18:	616f6c66 	cmnvs	pc, r6, ror #24
    1e1c:	62612d74 	rsbvs	r2, r1, #116, 26	; 0x1d00
    1e20:	61683d69 	cmnvs	r8, r9, ror #26
    1e24:	2d206472 	cfstrscs	mvf6, [r0, #-456]!	; 0xfffffe38
    1e28:	6372616d 	cmnvs	r2, #1073741851	; 0x4000001b
    1e2c:	72613d68 	rsbvc	r3, r1, #104, 26	; 0x1a00
    1e30:	7435766d 	ldrtvc	r7, [r5], #-1645	; 0xfffff993
    1e34:	70662b65 	rsbvc	r2, r6, r5, ror #22
    1e38:	20672d20 	rsbcs	r2, r7, r0, lsr #26
    1e3c:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
    1e40:	4f2d2067 	svcmi	0x002d2067
    1e44:	4f2d2032 	svcmi	0x002d2032
    1e48:	4f2d2032 	svcmi	0x002d2032
    1e4c:	662d2032 			; <UNDEFINED> instruction: 0x662d2032
    1e50:	6c697562 	cfstr64vs	mvdx7, [r9], #-392	; 0xfffffe78
    1e54:	676e6964 	strbvs	r6, [lr, -r4, ror #18]!
    1e58:	62696c2d 	rsbvs	r6, r9, #11520	; 0x2d00
    1e5c:	20636367 	rsbcs	r6, r3, r7, ror #6
    1e60:	6f6e662d 	svcvs	0x006e662d
    1e64:	6174732d 	cmnvs	r4, sp, lsr #6
    1e68:	702d6b63 	eorvc	r6, sp, r3, ror #22
    1e6c:	65746f72 	ldrbvs	r6, [r4, #-3954]!	; 0xfffff08e
    1e70:	726f7463 	rsbvc	r7, pc, #1660944384	; 0x63000000
    1e74:	6e662d20 	cdpvs	13, 6, cr2, cr6, cr0, {1}
    1e78:	6e692d6f 	cdpvs	13, 6, cr2, cr9, cr15, {3}
    1e7c:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
    1e80:	76662d20 	strbtvc	r2, [r6], -r0, lsr #26
    1e84:	62697369 	rsbvs	r7, r9, #-1543503871	; 0xa4000001
    1e88:	74696c69 	strbtvc	r6, [r9], #-3177	; 0xfffff397
    1e8c:	69683d79 	stmdbvs	r8!, {r0, r3, r4, r5, r6, r8, sl, fp, ip, sp}^
    1e90:	6e656464 	cdpvs	4, 6, cr6, cr5, cr4, {3}
    1e94:	4d524100 	ldfmie	f4, [r2, #-0]
    1e98:	0049485f 	subeq	r4, r9, pc, asr r8
    1e9c:	5f617369 	svcpl	0x00617369
    1ea0:	5f746962 	svcpl	0x00746962
    1ea4:	76696461 	strbtvc	r6, [r9], -r1, ror #8
    1ea8:	52415400 	subpl	r5, r1, #0, 8
    1eac:	5f544547 	svcpl	0x00544547
    1eb0:	5f555043 	svcpl	0x00555043
    1eb4:	316d7261 	cmncc	sp, r1, ror #4
    1eb8:	6a363331 	bvs	d8eb84 <_bss_end+0xd82d20>
    1ebc:	41540073 	cmpmi	r4, r3, ror r0
    1ec0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1ec4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1ec8:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1ecc:	41540038 	cmpmi	r4, r8, lsr r0
    1ed0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1ed4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1ed8:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1edc:	41540039 	cmpmi	r4, r9, lsr r0
    1ee0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1ee4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1ee8:	3661665f 			; <UNDEFINED> instruction: 0x3661665f
    1eec:	6c003632 	stcvs	6, cr3, [r0], {50}	; 0x32
    1ef0:	20676e6f 	rsbcs	r6, r7, pc, ror #28
    1ef4:	676e6f6c 	strbvs	r6, [lr, -ip, ror #30]!
    1ef8:	736e7520 	cmnvc	lr, #32, 10	; 0x8000000
    1efc:	656e6769 	strbvs	r6, [lr, #-1897]!	; 0xfffff897
    1f00:	6e692064 	cdpvs	0, 6, cr2, cr9, cr4, {3}
    1f04:	72610074 	rsbvc	r0, r1, #116	; 0x74
    1f08:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    1f0c:	635f6863 	cmpvs	pc, #6488064	; 0x630000
    1f10:	0065736d 	rsbeq	r7, r5, sp, ror #6
    1f14:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1f18:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1f1c:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1f20:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1f24:	00346d78 	eorseq	r6, r4, r8, ror sp
    1f28:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1f2c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1f30:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1f34:	30316d72 	eorscc	r6, r1, r2, ror sp
    1f38:	41540065 	cmpmi	r4, r5, rrx
    1f3c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1f40:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1f44:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1f48:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    1f4c:	72610037 	rsbvc	r0, r1, #55	; 0x37
    1f50:	6f635f6d 	svcvs	0x00635f6d
    1f54:	635f646e 	cmpvs	pc, #1845493760	; 0x6e000000
    1f58:	0065646f 	rsbeq	r6, r5, pc, ror #8
    1f5c:	5f4d5241 	svcpl	0x004d5241
    1f60:	5f534350 	svcpl	0x00534350
    1f64:	43504141 	cmpmi	r0, #1073741840	; 0x40000010
    1f68:	73690053 	cmnvc	r9, #83	; 0x53
    1f6c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1f70:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1f74:	5f38766d 	svcpl	0x0038766d
    1f78:	41420032 	cmpmi	r2, r2, lsr r0
    1f7c:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1f80:	5f484352 	svcpl	0x00484352
    1f84:	54004d33 	strpl	r4, [r0], #-3379	; 0xfffff2cd
    1f88:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1f8c:	50435f54 	subpl	r5, r3, r4, asr pc
    1f90:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1f94:	3031376d 	eorscc	r3, r1, sp, ror #14
    1f98:	72610074 	rsbvc	r0, r1, #116	; 0x74
    1f9c:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    1fa0:	695f6863 	ldmdbvs	pc, {r0, r1, r5, r6, fp, sp, lr}^	; <UNPREDICTABLE>
    1fa4:	786d6d77 	stmdavc	sp!, {r0, r1, r2, r4, r5, r6, r8, sl, fp, sp, lr}^
    1fa8:	69003274 	stmdbvs	r0, {r2, r4, r5, r6, r9, ip, sp}
    1fac:	6e5f6173 	mrcvs	1, 2, r6, cr15, cr3, {3}
    1fb0:	625f6d75 	subsvs	r6, pc, #7488	; 0x1d40
    1fb4:	00737469 	rsbseq	r7, r3, r9, ror #8
    1fb8:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1fbc:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1fc0:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1fc4:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1fc8:	70306d78 	eorsvc	r6, r0, r8, ror sp
    1fcc:	7373756c 	cmnvc	r3, #108, 10	; 0x1b000000
    1fd0:	6c6c616d 	stfvse	f6, [ip], #-436	; 0xfffffe4c
    1fd4:	746c756d 	strbtvc	r7, [ip], #-1389	; 0xfffffa93
    1fd8:	796c7069 	stmdbvc	ip!, {r0, r3, r5, r6, ip, sp, lr}^
    1fdc:	52415400 	subpl	r5, r1, #0, 8
    1fe0:	5f544547 	svcpl	0x00544547
    1fe4:	5f555043 	svcpl	0x00555043
    1fe8:	6e797865 	cdpvs	8, 7, cr7, cr9, cr5, {3}
    1fec:	316d736f 	cmncc	sp, pc, ror #6
    1ff0:	52415400 	subpl	r5, r1, #0, 8
    1ff4:	5f544547 	svcpl	0x00544547
    1ff8:	5f555043 	svcpl	0x00555043
    1ffc:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2000:	35727865 	ldrbcc	r7, [r2, #-2149]!	; 0xfffff79b
    2004:	73690032 	cmnvc	r9, #50	; 0x32
    2008:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    200c:	64745f74 	ldrbtvs	r5, [r4], #-3956	; 0xfffff08c
    2010:	70007669 	andvc	r7, r0, r9, ror #12
    2014:	65666572 	strbvs	r6, [r6, #-1394]!	; 0xfffffa8e
    2018:	656e5f72 	strbvs	r5, [lr, #-3954]!	; 0xfffff08e
    201c:	665f6e6f 	ldrbvs	r6, [pc], -pc, ror #28
    2020:	365f726f 	ldrbcc	r7, [pc], -pc, ror #4
    2024:	74696234 	strbtvc	r6, [r9], #-564	; 0xfffffdcc
    2028:	73690073 	cmnvc	r9, #115	; 0x73
    202c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2030:	70665f74 	rsbvc	r5, r6, r4, ror pc
    2034:	6d663631 	stclvs	6, cr3, [r6, #-196]!	; 0xffffff3c
    2038:	4154006c 	cmpmi	r4, ip, rrx
    203c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2040:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2044:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2048:	61786574 	cmnvs	r8, r4, ror r5
    204c:	54003233 	strpl	r3, [r0], #-563	; 0xfffffdcd
    2050:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2054:	50435f54 	subpl	r5, r3, r4, asr pc
    2058:	6f635f55 	svcvs	0x00635f55
    205c:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2060:	00353361 	eorseq	r3, r5, r1, ror #6
    2064:	5f617369 	svcpl	0x00617369
    2068:	5f746962 	svcpl	0x00746962
    206c:	36317066 	ldrtcc	r7, [r1], -r6, rrx
    2070:	766e6f63 	strbtvc	r6, [lr], -r3, ror #30
    2074:	736e7500 	cmnvc	lr, #0, 10
    2078:	76636570 			; <UNDEFINED> instruction: 0x76636570
    207c:	7274735f 	rsbsvc	r7, r4, #2080374785	; 0x7c000001
    2080:	73676e69 	cmnvc	r7, #1680	; 0x690
    2084:	52415400 	subpl	r5, r1, #0, 8
    2088:	5f544547 	svcpl	0x00544547
    208c:	5f555043 	svcpl	0x00555043
    2090:	316d7261 	cmncc	sp, r1, ror #4
    2094:	74363531 	ldrtvc	r3, [r6], #-1329	; 0xfffffacf
    2098:	54007332 	strpl	r7, [r0], #-818	; 0xfffffcce
    209c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    20a0:	50435f54 	subpl	r5, r3, r4, asr pc
    20a4:	61665f55 	cmnvs	r6, r5, asr pc
    20a8:	74363036 	ldrtvc	r3, [r6], #-54	; 0xffffffca
    20ac:	41540065 	cmpmi	r4, r5, rrx
    20b0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    20b4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    20b8:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    20bc:	65363239 	ldrvs	r3, [r6, #-569]!	; 0xfffffdc7
    20c0:	4200736a 	andmi	r7, r0, #-1476395007	; 0xa8000001
    20c4:	5f455341 	svcpl	0x00455341
    20c8:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    20cc:	0054345f 	subseq	r3, r4, pc, asr r4
    20d0:	5f617369 	svcpl	0x00617369
    20d4:	5f746962 	svcpl	0x00746962
    20d8:	70797263 	rsbsvc	r7, r9, r3, ror #4
    20dc:	61006f74 	tstvs	r0, r4, ror pc
    20e0:	725f6d72 	subsvc	r6, pc, #7296	; 0x1c80
    20e4:	5f736765 	svcpl	0x00736765
    20e8:	735f6e69 	cmpvc	pc, #1680	; 0x690
    20ec:	65757165 	ldrbvs	r7, [r5, #-357]!	; 0xfffffe9b
    20f0:	0065636e 	rsbeq	r6, r5, lr, ror #6
    20f4:	5f617369 	svcpl	0x00617369
    20f8:	5f746962 	svcpl	0x00746962
    20fc:	42006273 	andmi	r6, r0, #805306375	; 0x30000007
    2100:	5f455341 	svcpl	0x00455341
    2104:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    2108:	4554355f 	ldrbmi	r3, [r4, #-1375]	; 0xfffffaa1
    210c:	61736900 	cmnvs	r3, r0, lsl #18
    2110:	6165665f 	cmnvs	r5, pc, asr r6
    2114:	65727574 	ldrbvs	r7, [r2, #-1396]!	; 0xfffffa8c
    2118:	61736900 	cmnvs	r3, r0, lsl #18
    211c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2120:	616d735f 	cmnvs	sp, pc, asr r3
    2124:	756d6c6c 	strbvc	r6, [sp, #-3180]!	; 0xfffff394
    2128:	7261006c 	rsbvc	r0, r1, #108	; 0x6c
    212c:	616c5f6d 	cmnvs	ip, sp, ror #30
    2130:	6f5f676e 	svcvs	0x005f676e
    2134:	75707475 	ldrbvc	r7, [r0, #-1141]!	; 0xfffffb8b
    2138:	626f5f74 	rsbvs	r5, pc, #116, 30	; 0x1d0
    213c:	7463656a 	strbtvc	r6, [r3], #-1386	; 0xfffffa96
    2140:	7474615f 	ldrbtvc	r6, [r4], #-351	; 0xfffffea1
    2144:	75626972 	strbvc	r6, [r2, #-2418]!	; 0xfffff68e
    2148:	5f736574 	svcpl	0x00736574
    214c:	6b6f6f68 	blvs	1bddef4 <_bss_end+0x1bd2090>
    2150:	61736900 	cmnvs	r3, r0, lsl #18
    2154:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2158:	5f70665f 	svcpl	0x0070665f
    215c:	00323364 	eorseq	r3, r2, r4, ror #6
    2160:	5f4d5241 	svcpl	0x004d5241
    2164:	6900454e 	stmdbvs	r0, {r1, r2, r3, r6, r8, sl, lr}
    2168:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    216c:	625f7469 	subsvs	r7, pc, #1761607680	; 0x69000000
    2170:	54003865 	strpl	r3, [r0], #-2149	; 0xfffff79b
    2174:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2178:	50435f54 	subpl	r5, r3, r4, asr pc
    217c:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    2180:	3731316d 	ldrcc	r3, [r1, -sp, ror #2]!
    2184:	737a6a36 	cmnvc	sl, #221184	; 0x36000
    2188:	6f727000 	svcvs	0x00727000
    218c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    2190:	745f726f 	ldrbvc	r7, [pc], #-623	; 2198 <CPSR_IRQ_INHIBIT+0x2118>
    2194:	00657079 	rsbeq	r7, r5, r9, ror r0
    2198:	5f6c6c61 	svcpl	0x006c6c61
    219c:	73757066 	cmnvc	r5, #102	; 0x66
    21a0:	6d726100 	ldfvse	f6, [r2, #-0]
    21a4:	7363705f 	cmnvc	r3, #95	; 0x5f
    21a8:	53414200 	movtpl	r4, #4608	; 0x1200
    21ac:	52415f45 	subpl	r5, r1, #276	; 0x114
    21b0:	355f4843 	ldrbcc	r4, [pc, #-2115]	; 1975 <CPSR_IRQ_INHIBIT+0x18f5>
    21b4:	72610054 	rsbvc	r0, r1, #84	; 0x54
    21b8:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    21bc:	74346863 	ldrtvc	r6, [r4], #-2147	; 0xfffff79d
    21c0:	52415400 	subpl	r5, r1, #0, 8
    21c4:	5f544547 	svcpl	0x00544547
    21c8:	5f555043 	svcpl	0x00555043
    21cc:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    21d0:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    21d4:	726f6336 	rsbvc	r6, pc, #-671088640	; 0xd8000000
    21d8:	61786574 	cmnvs	r8, r4, ror r5
    21dc:	61003535 	tstvs	r0, r5, lsr r5
    21e0:	745f6d72 	ldrbvc	r6, [pc], #-3442	; 21e8 <CPSR_IRQ_INHIBIT+0x2168>
    21e4:	5f656e75 	svcpl	0x00656e75
    21e8:	66756277 			; <UNDEFINED> instruction: 0x66756277
    21ec:	61746800 	cmnvs	r4, r0, lsl #16
    21f0:	61685f62 	cmnvs	r8, r2, ror #30
    21f4:	69006873 	stmdbvs	r0, {r0, r1, r4, r5, r6, fp, sp, lr}
    21f8:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    21fc:	715f7469 	cmpvc	pc, r9, ror #8
    2200:	6b726975 	blvs	1c9c7dc <_bss_end+0x1c90978>
    2204:	5f6f6e5f 	svcpl	0x006f6e5f
    2208:	616c6f76 	smcvs	50934	; 0xc6f6
    220c:	656c6974 	strbvs	r6, [ip, #-2420]!	; 0xfffff68c
    2210:	0065635f 	rsbeq	r6, r5, pc, asr r3
    2214:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2218:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    221c:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2220:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2224:	00306d78 	eorseq	r6, r0, r8, ror sp
    2228:	47524154 			; <UNDEFINED> instruction: 0x47524154
    222c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2230:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2234:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2238:	00316d78 	eorseq	r6, r1, r8, ror sp
    223c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2240:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2244:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2248:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    224c:	00336d78 	eorseq	r6, r3, r8, ror sp
    2250:	5f617369 	svcpl	0x00617369
    2254:	5f746962 	svcpl	0x00746962
    2258:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    225c:	00315f38 	eorseq	r5, r1, r8, lsr pc
    2260:	5f6d7261 	svcpl	0x006d7261
    2264:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    2268:	6d616e5f 	stclvs	14, cr6, [r1, #-380]!	; 0xfffffe84
    226c:	73690065 	cmnvc	r9, #101	; 0x65
    2270:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2274:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    2278:	5f38766d 	svcpl	0x0038766d
    227c:	73690033 	cmnvc	r9, #51	; 0x33
    2280:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2284:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    2288:	5f38766d 	svcpl	0x0038766d
    228c:	73690034 	cmnvc	r9, #52	; 0x34
    2290:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2294:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    2298:	5f38766d 	svcpl	0x0038766d
    229c:	41540035 	cmpmi	r4, r5, lsr r0
    22a0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    22a4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    22a8:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    22ac:	61786574 	cmnvs	r8, r4, ror r5
    22b0:	54003335 	strpl	r3, [r0], #-821	; 0xfffffccb
    22b4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    22b8:	50435f54 	subpl	r5, r3, r4, asr pc
    22bc:	6f635f55 	svcvs	0x00635f55
    22c0:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    22c4:	00353561 	eorseq	r3, r5, r1, ror #10
    22c8:	47524154 			; <UNDEFINED> instruction: 0x47524154
    22cc:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    22d0:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    22d4:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    22d8:	37356178 			; <UNDEFINED> instruction: 0x37356178
    22dc:	52415400 	subpl	r5, r1, #0, 8
    22e0:	5f544547 	svcpl	0x00544547
    22e4:	5f555043 	svcpl	0x00555043
    22e8:	6f63706d 	svcvs	0x0063706d
    22ec:	54006572 	strpl	r6, [r0], #-1394	; 0xfffffa8e
    22f0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    22f4:	50435f54 	subpl	r5, r3, r4, asr pc
    22f8:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    22fc:	6f6e5f6d 	svcvs	0x006e5f6d
    2300:	6100656e 	tstvs	r0, lr, ror #10
    2304:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2308:	5f686372 	svcpl	0x00686372
    230c:	6d746f6e 	ldclvs	15, cr6, [r4, #-440]!	; 0xfffffe48
    2310:	52415400 	subpl	r5, r1, #0, 8
    2314:	5f544547 	svcpl	0x00544547
    2318:	5f555043 	svcpl	0x00555043
    231c:	316d7261 	cmncc	sp, r1, ror #4
    2320:	65363230 	ldrvs	r3, [r6, #-560]!	; 0xfffffdd0
    2324:	4200736a 	andmi	r7, r0, #-1476395007	; 0xa8000001
    2328:	5f455341 	svcpl	0x00455341
    232c:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    2330:	004a365f 	subeq	r3, sl, pc, asr r6
    2334:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    2338:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    233c:	4b365f48 	blmi	d9a064 <_bss_end+0xd8e200>
    2340:	53414200 	movtpl	r4, #4608	; 0x1200
    2344:	52415f45 	subpl	r5, r1, #276	; 0x114
    2348:	365f4843 	ldrbcc	r4, [pc], -r3, asr #16
    234c:	7369004d 	cmnvc	r9, #77	; 0x4d
    2350:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2354:	77695f74 			; <UNDEFINED> instruction: 0x77695f74
    2358:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
    235c:	52415400 	subpl	r5, r1, #0, 8
    2360:	5f544547 	svcpl	0x00544547
    2364:	5f555043 	svcpl	0x00555043
    2368:	316d7261 	cmncc	sp, r1, ror #4
    236c:	6a363331 	bvs	d8f038 <_bss_end+0xd831d4>
    2370:	41007366 	tstmi	r0, r6, ror #6
    2374:	4c5f4d52 	mrrcmi	13, 5, r4, pc, cr2	; <UNPREDICTABLE>
    2378:	52410053 	subpl	r0, r1, #83	; 0x53
    237c:	544c5f4d 	strbpl	r5, [ip], #-3917	; 0xfffff0b3
    2380:	53414200 	movtpl	r4, #4608	; 0x1200
    2384:	52415f45 	subpl	r5, r1, #276	; 0x114
    2388:	365f4843 	ldrbcc	r4, [pc], -r3, asr #16
    238c:	4154005a 	cmpmi	r4, sl, asr r0
    2390:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2394:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2398:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    239c:	61786574 	cmnvs	r8, r4, ror r5
    23a0:	6f633537 	svcvs	0x00633537
    23a4:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    23a8:	00353561 	eorseq	r3, r5, r1, ror #10
    23ac:	5f4d5241 	svcpl	0x004d5241
    23b0:	5f534350 	svcpl	0x00534350
    23b4:	43504141 	cmpmi	r0, #1073741840	; 0x40000010
    23b8:	46565f53 	usaxmi	r5, r6, r3
    23bc:	41540050 	cmpmi	r4, r0, asr r0
    23c0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    23c4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    23c8:	6d77695f 			; <UNDEFINED> instruction: 0x6d77695f
    23cc:	3274786d 	rsbscc	r7, r4, #7143424	; 0x6d0000
    23d0:	61736900 	cmnvs	r3, r0, lsl #18
    23d4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    23d8:	6f656e5f 	svcvs	0x00656e5f
    23dc:	7261006e 	rsbvc	r0, r1, #110	; 0x6e
    23e0:	70665f6d 	rsbvc	r5, r6, sp, ror #30
    23e4:	74615f75 	strbtvc	r5, [r1], #-3957	; 0xfffff08b
    23e8:	69007274 	stmdbvs	r0, {r2, r4, r5, r6, r9, ip, sp, lr}
    23ec:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    23f0:	615f7469 	cmpvs	pc, r9, ror #8
    23f4:	37766d72 			; <UNDEFINED> instruction: 0x37766d72
    23f8:	54006d65 	strpl	r6, [r0], #-3429	; 0xfffff29b
    23fc:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2400:	50435f54 	subpl	r5, r3, r4, asr pc
    2404:	61665f55 	cmnvs	r6, r5, asr pc
    2408:	74363236 	ldrtvc	r3, [r6], #-566	; 0xfffffdca
    240c:	41540065 	cmpmi	r4, r5, rrx
    2410:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2414:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2418:	72616d5f 	rsbvc	r6, r1, #6080	; 0x17c0
    241c:	6c6c6576 	cfstr64vs	mvdx6, [ip], #-472	; 0xfffffe28
    2420:	346a705f 	strbtcc	r7, [sl], #-95	; 0xffffffa1
    2424:	61746800 	cmnvs	r4, r0, lsl #16
    2428:	61685f62 	cmnvs	r8, r2, ror #30
    242c:	705f6873 	subsvc	r6, pc, r3, ror r8	; <UNPREDICTABLE>
    2430:	746e696f 	strbtvc	r6, [lr], #-2415	; 0xfffff691
    2434:	61007265 	tstvs	r0, r5, ror #4
    2438:	745f6d72 	ldrbvc	r6, [pc], #-3442	; 2440 <CPSR_IRQ_INHIBIT+0x23c0>
    243c:	5f656e75 	svcpl	0x00656e75
    2440:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2444:	615f7865 	cmpvs	pc, r5, ror #16
    2448:	73690039 	cmnvc	r9, #57	; 0x39
    244c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2450:	77695f74 			; <UNDEFINED> instruction: 0x77695f74
    2454:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
    2458:	41540032 	cmpmi	r4, r2, lsr r0
    245c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2460:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2464:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2468:	61786574 	cmnvs	r8, r4, ror r5
    246c:	6f633237 	svcvs	0x00633237
    2470:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2474:	00333561 	eorseq	r3, r3, r1, ror #10
    2478:	5f617369 	svcpl	0x00617369
    247c:	5f746962 	svcpl	0x00746962
    2480:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    2484:	42003262 	andmi	r3, r0, #536870918	; 0x20000006
    2488:	5f455341 	svcpl	0x00455341
    248c:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    2490:	0041375f 	subeq	r3, r1, pc, asr r7
    2494:	5f617369 	svcpl	0x00617369
    2498:	5f746962 	svcpl	0x00746962
    249c:	70746f64 	rsbsvc	r6, r4, r4, ror #30
    24a0:	00646f72 	rsbeq	r6, r4, r2, ror pc
    24a4:	5f6d7261 	svcpl	0x006d7261
    24a8:	36317066 	ldrtcc	r7, [r1], -r6, rrx
    24ac:	7079745f 	rsbsvc	r7, r9, pc, asr r4
    24b0:	6f6e5f65 	svcvs	0x006e5f65
    24b4:	41006564 	tstmi	r0, r4, ror #10
    24b8:	4d5f4d52 	ldclmi	13, cr4, [pc, #-328]	; 2378 <CPSR_IRQ_INHIBIT+0x22f8>
    24bc:	72610049 	rsbvc	r0, r1, #73	; 0x49
    24c0:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    24c4:	6b366863 	blvs	d9c658 <_bss_end+0xd907f4>
    24c8:	6d726100 	ldfvse	f6, [r2, #-0]
    24cc:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    24d0:	006d3668 	rsbeq	r3, sp, r8, ror #12
    24d4:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    24d8:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    24dc:	52375f48 	eorspl	r5, r7, #72, 30	; 0x120
    24e0:	705f5f00 	subsvc	r5, pc, r0, lsl #30
    24e4:	6f63706f 	svcvs	0x0063706f
    24e8:	5f746e75 	svcpl	0x00746e75
    24ec:	00626174 	rsbeq	r6, r2, r4, ror r1
    24f0:	5f617369 	svcpl	0x00617369
    24f4:	5f746962 	svcpl	0x00746962
    24f8:	65736d63 	ldrbvs	r6, [r3, #-3427]!	; 0xfffff29d
    24fc:	52415400 	subpl	r5, r1, #0, 8
    2500:	5f544547 	svcpl	0x00544547
    2504:	5f555043 	svcpl	0x00555043
    2508:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    250c:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    2510:	41540033 	cmpmi	r4, r3, lsr r0
    2514:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2518:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    251c:	6e65675f 	mcrvs	7, 3, r6, cr5, cr15, {2}
    2520:	63697265 	cmnvs	r9, #1342177286	; 0x50000006
    2524:	00613776 	rsbeq	r3, r1, r6, ror r7
    2528:	47524154 			; <UNDEFINED> instruction: 0x47524154
    252c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2530:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2534:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2538:	36376178 			; <UNDEFINED> instruction: 0x36376178
    253c:	6d726100 	ldfvse	f6, [r2, #-0]
    2540:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    2544:	6f6e5f68 	svcvs	0x006e5f68
    2548:	6c6f765f 	stclvs	6, cr7, [pc], #-380	; 23d4 <CPSR_IRQ_INHIBIT+0x2354>
    254c:	6c697461 	cfstrdvs	mvd7, [r9], #-388	; 0xfffffe7c
    2550:	65635f65 	strbvs	r5, [r3, #-3941]!	; 0xfffff09b
    2554:	53414200 	movtpl	r4, #4608	; 0x1200
    2558:	52415f45 	subpl	r5, r1, #276	; 0x114
    255c:	385f4843 	ldmdacc	pc, {r0, r1, r6, fp, lr}^	; <UNPREDICTABLE>
    2560:	73690041 	cmnvc	r9, #65	; 0x41
    2564:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2568:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    256c:	7435766d 	ldrtvc	r7, [r5], #-1645	; 0xfffff993
    2570:	53414200 	movtpl	r4, #4608	; 0x1200
    2574:	52415f45 	subpl	r5, r1, #276	; 0x114
    2578:	385f4843 	ldmdacc	pc, {r0, r1, r6, fp, lr}^	; <UNPREDICTABLE>
    257c:	41540052 	cmpmi	r4, r2, asr r0
    2580:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2584:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2588:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    258c:	61786574 	cmnvs	r8, r4, ror r5
    2590:	6f633337 	svcvs	0x00633337
    2594:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2598:	00353361 	eorseq	r3, r5, r1, ror #6
    259c:	5f4d5241 	svcpl	0x004d5241
    25a0:	6100564e 	tstvs	r0, lr, asr #12
    25a4:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    25a8:	34686372 	strbtcc	r6, [r8], #-882	; 0xfffffc8e
    25ac:	6d726100 	ldfvse	f6, [r2, #-0]
    25b0:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    25b4:	61003668 	tstvs	r0, r8, ror #12
    25b8:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    25bc:	37686372 			; <UNDEFINED> instruction: 0x37686372
    25c0:	6d726100 	ldfvse	f6, [r2, #-0]
    25c4:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    25c8:	6c003868 	stcvs	8, cr3, [r0], {104}	; 0x68
    25cc:	20676e6f 	rsbcs	r6, r7, pc, ror #28
    25d0:	62756f64 	rsbsvs	r6, r5, #100, 30	; 0x190
    25d4:	6100656c 	tstvs	r0, ip, ror #10
    25d8:	745f6d72 	ldrbvc	r6, [pc], #-3442	; 25e0 <CPSR_IRQ_INHIBIT+0x2560>
    25dc:	5f656e75 	svcpl	0x00656e75
    25e0:	61637378 	smcvs	14136	; 0x3738
    25e4:	6d00656c 	cfstr32vs	mvfx6, [r0, #-432]	; 0xfffffe50
    25e8:	6e696b61 	vnmulvs.f64	d22, d9, d17
    25ec:	6f635f67 	svcvs	0x00635f67
    25f0:	5f74736e 	svcpl	0x0074736e
    25f4:	6c626174 	stfvse	f6, [r2], #-464	; 0xfffffe30
    25f8:	68740065 	ldmdavs	r4!, {r0, r2, r5, r6}^
    25fc:	5f626d75 	svcpl	0x00626d75
    2600:	6c6c6163 	stfvse	f6, [ip], #-396	; 0xfffffe74
    2604:	6169765f 	cmnvs	r9, pc, asr r6
    2608:	62616c5f 	rsbvs	r6, r1, #24320	; 0x5f00
    260c:	69006c65 	stmdbvs	r0, {r0, r2, r5, r6, sl, fp, sp, lr}
    2610:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2614:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    2618:	00357670 	eorseq	r7, r5, r0, ror r6
    261c:	5f617369 	svcpl	0x00617369
    2620:	5f746962 	svcpl	0x00746962
    2624:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    2628:	54006b36 	strpl	r6, [r0], #-2870	; 0xfffff4ca
    262c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2630:	50435f54 	subpl	r5, r3, r4, asr pc
    2634:	6f635f55 	svcvs	0x00635f55
    2638:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    263c:	54003761 	strpl	r3, [r0], #-1889	; 0xfffff89f
    2640:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2644:	50435f54 	subpl	r5, r3, r4, asr pc
    2648:	6f635f55 	svcvs	0x00635f55
    264c:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2650:	54003861 	strpl	r3, [r0], #-2145	; 0xfffff79f
    2654:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2658:	50435f54 	subpl	r5, r3, r4, asr pc
    265c:	6f635f55 	svcvs	0x00635f55
    2660:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2664:	41003961 	tstmi	r0, r1, ror #18
    2668:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    266c:	415f5343 	cmpmi	pc, r3, asr #6
    2670:	00534350 	subseq	r4, r3, r0, asr r3
    2674:	5f4d5241 	svcpl	0x004d5241
    2678:	5f534350 	svcpl	0x00534350
    267c:	43505441 	cmpmi	r0, #1090519040	; 0x41000000
    2680:	6f630053 	svcvs	0x00630053
    2684:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
    2688:	6f642078 	svcvs	0x00642078
    268c:	656c6275 	strbvs	r6, [ip, #-629]!	; 0xfffffd8b
    2690:	52415400 	subpl	r5, r1, #0, 8
    2694:	5f544547 	svcpl	0x00544547
    2698:	5f555043 	svcpl	0x00555043
    269c:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    26a0:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    26a4:	726f6333 	rsbvc	r6, pc, #-872415232	; 0xcc000000
    26a8:	61786574 	cmnvs	r8, r4, ror r5
    26ac:	54003335 	strpl	r3, [r0], #-821	; 0xfffffccb
    26b0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    26b4:	50435f54 	subpl	r5, r3, r4, asr pc
    26b8:	6f635f55 	svcvs	0x00635f55
    26bc:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    26c0:	6c70306d 	ldclvs	0, cr3, [r0], #-436	; 0xfffffe4c
    26c4:	61007375 	tstvs	r0, r5, ror r3
    26c8:	635f6d72 	cmpvs	pc, #7296	; 0x1c80
    26cc:	73690063 	cmnvc	r9, #99	; 0x63
    26d0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    26d4:	73785f74 	cmnvc	r8, #116, 30	; 0x1d0
    26d8:	656c6163 	strbvs	r6, [ip, #-355]!	; 0xfffffe9d
    26dc:	6f645f00 	svcvs	0x00645f00
    26e0:	755f746e 	ldrbvc	r7, [pc, #-1134]	; 227a <CPSR_IRQ_INHIBIT+0x21fa>
    26e4:	745f6573 	ldrbvc	r6, [pc], #-1395	; 26ec <CPSR_IRQ_INHIBIT+0x266c>
    26e8:	5f656572 	svcpl	0x00656572
    26ec:	65726568 	ldrbvs	r6, [r2, #-1384]!	; 0xfffffa98
    26f0:	4154005f 	cmpmi	r4, pc, asr r0
    26f4:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    26f8:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    26fc:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2700:	64743031 	ldrbtvs	r3, [r4], #-49	; 0xffffffcf
    2704:	5400696d 	strpl	r6, [r0], #-2413	; 0xfffff693
    2708:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    270c:	50435f54 	subpl	r5, r3, r4, asr pc
    2710:	6f635f55 	svcvs	0x00635f55
    2714:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2718:	62003561 	andvs	r3, r0, #406847488	; 0x18400000
    271c:	5f657361 	svcpl	0x00657361
    2720:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    2724:	63657469 	cmnvs	r5, #1761607680	; 0x69000000
    2728:	65727574 	ldrbvs	r7, [r2, #-1396]!	; 0xfffffa8c
    272c:	6d726100 	ldfvse	f6, [r2, #-0]
    2730:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    2734:	72635f68 	rsbvc	r5, r3, #104, 30	; 0x1a0
    2738:	41540063 	cmpmi	r4, r3, rrx
    273c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2740:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2744:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2748:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    274c:	616d7331 	cmnvs	sp, r1, lsr r3
    2750:	756d6c6c 	strbvc	r6, [sp, #-3180]!	; 0xfffff394
    2754:	7069746c 	rsbvc	r7, r9, ip, ror #8
    2758:	6100796c 	tstvs	r0, ip, ror #18
    275c:	635f6d72 	cmpvs	pc, #7296	; 0x1c80
    2760:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
    2764:	635f746e 	cmpvs	pc, #1845493760	; 0x6e000000
    2768:	73690063 	cmnvc	r9, #99	; 0x63
    276c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2770:	72635f74 	rsbvc	r5, r3, #116, 30	; 0x1d0
    2774:	00323363 	eorseq	r3, r2, r3, ror #6
    2778:	5f4d5241 	svcpl	0x004d5241
    277c:	69004c50 	stmdbvs	r0, {r4, r6, sl, fp, lr}
    2780:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2784:	765f7469 	ldrbvc	r7, [pc], -r9, ror #8
    2788:	33767066 	cmncc	r6, #102	; 0x66
    278c:	61736900 	cmnvs	r3, r0, lsl #18
    2790:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2794:	7066765f 	rsbvc	r7, r6, pc, asr r6
    2798:	42003476 	andmi	r3, r0, #1979711488	; 0x76000000
    279c:	5f455341 	svcpl	0x00455341
    27a0:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    27a4:	3254365f 	subscc	r3, r4, #99614720	; 0x5f00000
    27a8:	53414200 	movtpl	r4, #4608	; 0x1200
    27ac:	52415f45 	subpl	r5, r1, #276	; 0x114
    27b0:	385f4843 	ldmdacc	pc, {r0, r1, r6, fp, lr}^	; <UNPREDICTABLE>
    27b4:	414d5f4d 	cmpmi	sp, sp, asr #30
    27b8:	54004e49 	strpl	r4, [r0], #-3657	; 0xfffff1b7
    27bc:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    27c0:	50435f54 	subpl	r5, r3, r4, asr pc
    27c4:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    27c8:	6474396d 	ldrbtvs	r3, [r4], #-2413	; 0xfffff693
    27cc:	4100696d 	tstmi	r0, sp, ror #18
    27d0:	415f4d52 	cmpmi	pc, r2, asr sp	; <UNPREDICTABLE>
    27d4:	4142004c 	cmpmi	r2, ip, asr #32
    27d8:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    27dc:	5f484352 	svcpl	0x00484352
    27e0:	61004d37 	tstvs	r0, r7, lsr sp
    27e4:	745f6d72 	ldrbvc	r6, [pc], #-3442	; 27ec <CPSR_IRQ_INHIBIT+0x276c>
    27e8:	65677261 	strbvs	r7, [r7, #-609]!	; 0xfffffd9f
    27ec:	616c5f74 	smcvs	50676	; 0xc5f4
    27f0:	006c6562 	rsbeq	r6, ip, r2, ror #10
    27f4:	5f6d7261 	svcpl	0x006d7261
    27f8:	67726174 			; <UNDEFINED> instruction: 0x67726174
    27fc:	695f7465 	ldmdbvs	pc, {r0, r2, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    2800:	006e736e 	rsbeq	r7, lr, lr, ror #6
    2804:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2808:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    280c:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2810:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2814:	00347278 	eorseq	r7, r4, r8, ror r2
    2818:	47524154 			; <UNDEFINED> instruction: 0x47524154
    281c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2820:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2824:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2828:	00357278 	eorseq	r7, r5, r8, ror r2
    282c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2830:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2834:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2838:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    283c:	00377278 	eorseq	r7, r7, r8, ror r2
    2840:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2844:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2848:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    284c:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2850:	00387278 	eorseq	r7, r8, r8, ror r2
    2854:	5f617369 	svcpl	0x00617369
    2858:	5f746962 	svcpl	0x00746962
    285c:	6561706c 	strbvs	r7, [r1, #-108]!	; 0xffffff94
    2860:	61736900 	cmnvs	r3, r0, lsl #18
    2864:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2868:	6975715f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, r8, ip, sp, lr}^
    286c:	615f6b72 	cmpvs	pc, r2, ror fp	; <UNPREDICTABLE>
    2870:	36766d72 			; <UNDEFINED> instruction: 0x36766d72
    2874:	69007a6b 	stmdbvs	r0, {r0, r1, r3, r5, r6, r9, fp, ip, sp, lr}
    2878:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    287c:	6e5f7469 	cdpvs	4, 5, cr7, cr15, cr9, {3}
    2880:	006d746f 	rsbeq	r7, sp, pc, ror #8
    2884:	5f617369 	svcpl	0x00617369
    2888:	5f746962 	svcpl	0x00746962
    288c:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    2890:	73690034 	cmnvc	r9, #52	; 0x34
    2894:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2898:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    289c:	0036766d 	eorseq	r7, r6, sp, ror #12
    28a0:	5f617369 	svcpl	0x00617369
    28a4:	5f746962 	svcpl	0x00746962
    28a8:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    28ac:	73690037 	cmnvc	r9, #55	; 0x37
    28b0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    28b4:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    28b8:	0038766d 	eorseq	r7, r8, sp, ror #12
    28bc:	6e6f645f 	mcrvs	4, 3, r6, cr15, cr15, {2}
    28c0:	73755f74 	cmnvc	r5, #116, 30	; 0x1d0
    28c4:	74725f65 	ldrbtvc	r5, [r2], #-3941	; 0xfffff09b
    28c8:	65685f78 	strbvs	r5, [r8, #-3960]!	; 0xfffff088
    28cc:	005f6572 	subseq	r6, pc, r2, ror r5	; <UNPREDICTABLE>
    28d0:	74495155 	strbvc	r5, [r9], #-341	; 0xfffffeab
    28d4:	00657079 	rsbeq	r7, r5, r9, ror r0
    28d8:	5f617369 	svcpl	0x00617369
    28dc:	5f746962 	svcpl	0x00746962
    28e0:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    28e4:	00657435 	rsbeq	r7, r5, r5, lsr r4
    28e8:	5f6d7261 	svcpl	0x006d7261
    28ec:	656e7574 	strbvs	r7, [lr, #-1396]!	; 0xfffffa8c
    28f0:	6d726100 	ldfvse	f6, [r2, #-0]
    28f4:	7070635f 	rsbsvc	r6, r0, pc, asr r3
    28f8:	746e695f 	strbtvc	r6, [lr], #-2399	; 0xfffff6a1
    28fc:	6f777265 	svcvs	0x00777265
    2900:	66006b72 			; <UNDEFINED> instruction: 0x66006b72
    2904:	5f636e75 	svcpl	0x00636e75
    2908:	00727470 	rsbseq	r7, r2, r0, ror r4
    290c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2910:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2914:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    2918:	32396d72 	eorscc	r6, r9, #7296	; 0x1c80
    291c:	68007430 	stmdavs	r0, {r4, r5, sl, ip, sp, lr}
    2920:	5f626174 	svcpl	0x00626174
    2924:	54007165 	strpl	r7, [r0], #-357	; 0xfffffe9b
    2928:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    292c:	50435f54 	subpl	r5, r3, r4, asr pc
    2930:	61665f55 	cmnvs	r6, r5, asr pc
    2934:	00363235 	eorseq	r3, r6, r5, lsr r2
    2938:	5f6d7261 	svcpl	0x006d7261
    293c:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    2940:	7568745f 	strbvc	r7, [r8, #-1119]!	; 0xfffffba1
    2944:	685f626d 	ldmdavs	pc, {r0, r2, r3, r5, r6, r9, sp, lr}^	; <UNPREDICTABLE>
    2948:	76696477 			; <UNDEFINED> instruction: 0x76696477
    294c:	61746800 	cmnvs	r4, r0, lsl #16
    2950:	71655f62 	cmnvc	r5, r2, ror #30
    2954:	696f705f 	stmdbvs	pc!, {r0, r1, r2, r3, r4, r6, ip, sp, lr}^	; <UNPREDICTABLE>
    2958:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
    295c:	6d726100 	ldfvse	f6, [r2, #-0]
    2960:	6369705f 	cmnvs	r9, #95	; 0x5f
    2964:	6765725f 			; <UNDEFINED> instruction: 0x6765725f
    2968:	65747369 	ldrbvs	r7, [r4, #-873]!	; 0xfffffc97
    296c:	41540072 	cmpmi	r4, r2, ror r0
    2970:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2974:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2978:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    297c:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    2980:	616d7330 	cmnvs	sp, r0, lsr r3
    2984:	756d6c6c 	strbvc	r6, [sp, #-3180]!	; 0xfffff394
    2988:	7069746c 	rsbvc	r7, r9, ip, ror #8
    298c:	5400796c 	strpl	r7, [r0], #-2412	; 0xfffff694
    2990:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2994:	50435f54 	subpl	r5, r3, r4, asr pc
    2998:	706d5f55 	rsbvc	r5, sp, r5, asr pc
    299c:	65726f63 	ldrbvs	r6, [r2, #-3939]!	; 0xfffff09d
    29a0:	66766f6e 	ldrbtvs	r6, [r6], -lr, ror #30
    29a4:	73690070 	cmnvc	r9, #112	; 0x70
    29a8:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    29ac:	75715f74 	ldrbvc	r5, [r1, #-3956]!	; 0xfffff08c
    29b0:	5f6b7269 	svcpl	0x006b7269
    29b4:	5f336d63 	svcpl	0x00336d63
    29b8:	6472646c 	ldrbtvs	r6, [r2], #-1132	; 0xfffffb94
    29bc:	4d524100 	ldfmie	f4, [r2, #-0]
    29c0:	0043435f 	subeq	r4, r3, pc, asr r3
    29c4:	5f6d7261 	svcpl	0x006d7261
    29c8:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    29cc:	00325f38 	eorseq	r5, r2, r8, lsr pc
    29d0:	5f6d7261 	svcpl	0x006d7261
    29d4:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    29d8:	00335f38 	eorseq	r5, r3, r8, lsr pc
    29dc:	5f6d7261 	svcpl	0x006d7261
    29e0:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    29e4:	00345f38 	eorseq	r5, r4, r8, lsr pc
    29e8:	47524154 			; <UNDEFINED> instruction: 0x47524154
    29ec:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    29f0:	665f5550 			; <UNDEFINED> instruction: 0x665f5550
    29f4:	3236706d 	eorscc	r7, r6, #109	; 0x6d
    29f8:	52410036 	subpl	r0, r1, #54	; 0x36
    29fc:	53435f4d 	movtpl	r5, #16205	; 0x3f4d
    2a00:	6d726100 	ldfvse	f6, [r2, #-0]
    2a04:	3170665f 	cmncc	r0, pc, asr r6
    2a08:	6e695f36 	mcrvs	15, 3, r5, cr9, cr6, {1}
    2a0c:	61007473 	tstvs	r0, r3, ror r4
    2a10:	625f6d72 	subsvs	r6, pc, #7296	; 0x1c80
    2a14:	5f657361 	svcpl	0x00657361
    2a18:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    2a1c:	52415400 	subpl	r5, r1, #0, 8
    2a20:	5f544547 	svcpl	0x00544547
    2a24:	5f555043 	svcpl	0x00555043
    2a28:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2a2c:	31617865 	cmncc	r1, r5, ror #16
    2a30:	726f6335 	rsbvc	r6, pc, #-738197504	; 0xd4000000
    2a34:	61786574 	cmnvs	r8, r4, ror r5
    2a38:	72610037 	rsbvc	r0, r1, #55	; 0x37
    2a3c:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    2a40:	65376863 	ldrvs	r6, [r7, #-2147]!	; 0xfffff79d
    2a44:	4154006d 	cmpmi	r4, sp, rrx
    2a48:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2a4c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2a50:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2a54:	61786574 	cmnvs	r8, r4, ror r5
    2a58:	61003237 	tstvs	r0, r7, lsr r2
    2a5c:	705f6d72 	subsvc	r6, pc, r2, ror sp	; <UNPREDICTABLE>
    2a60:	645f7363 	ldrbvs	r7, [pc], #-867	; 2a68 <CPSR_IRQ_INHIBIT+0x29e8>
    2a64:	75616665 	strbvc	r6, [r1, #-1637]!	; 0xfffff99b
    2a68:	4100746c 	tstmi	r0, ip, ror #8
    2a6c:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    2a70:	415f5343 	cmpmi	pc, r3, asr #6
    2a74:	53435041 	movtpl	r5, #12353	; 0x3041
    2a78:	434f4c5f 	movtmi	r4, #64607	; 0xfc5f
    2a7c:	54004c41 	strpl	r4, [r0], #-3137	; 0xfffff3bf
    2a80:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2a84:	50435f54 	subpl	r5, r3, r4, asr pc
    2a88:	6f635f55 	svcvs	0x00635f55
    2a8c:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2a90:	00353761 	eorseq	r3, r5, r1, ror #14
    2a94:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2a98:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2a9c:	735f5550 	cmpvc	pc, #80, 10	; 0x14000000
    2aa0:	6e6f7274 	mcrvs	2, 3, r7, cr15, cr4, {3}
    2aa4:	6d726167 	ldfvse	f6, [r2, #-412]!	; 0xfffffe64
    2aa8:	6d726100 	ldfvse	f6, [r2, #-0]
    2aac:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    2ab0:	68745f68 	ldmdavs	r4!, {r3, r5, r6, r8, r9, sl, fp, ip, lr}^
    2ab4:	31626d75 	smccc	9941	; 0x26d5
    2ab8:	6d726100 	ldfvse	f6, [r2, #-0]
    2abc:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    2ac0:	68745f68 	ldmdavs	r4!, {r3, r5, r6, r8, r9, sl, fp, ip, lr}^
    2ac4:	32626d75 	rsbcc	r6, r2, #7488	; 0x1d40
    2ac8:	52415400 	subpl	r5, r1, #0, 8
    2acc:	5f544547 	svcpl	0x00544547
    2ad0:	5f555043 	svcpl	0x00555043
    2ad4:	6d6d7769 	stclvs	7, cr7, [sp, #-420]!	; 0xfffffe5c
    2ad8:	61007478 	tstvs	r0, r8, ror r4
    2adc:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2ae0:	35686372 	strbcc	r6, [r8, #-882]!	; 0xfffffc8e
    2ae4:	73690074 	cmnvc	r9, #116	; 0x74
    2ae8:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2aec:	706d5f74 	rsbvc	r5, sp, r4, ror pc
    2af0:	6d726100 	ldfvse	f6, [r2, #-0]
    2af4:	5f646c5f 	svcpl	0x00646c5f
    2af8:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
    2afc:	72610064 	rsbvc	r0, r1, #100	; 0x64
    2b00:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    2b04:	5f386863 	svcpl	0x00386863
    2b08:	Address 0x0000000000002b08 is out of bounds.


Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347 	bcc	10d0d24 <_bss_end+0x10c4ec0>
   4:	35312820 	ldrcc	r2, [r1, #-2080]!	; 0xfffff7e0
   8:	322d393a 	eorcc	r3, sp, #950272	; 0xe8000
   c:	2d393130 	ldfcss	f3, [r9, #-192]!	; 0xffffff40
  10:	302d3471 	eorcc	r3, sp, r1, ror r4
  14:	6e756275 	mrcvs	2, 3, r6, cr5, cr5, {3}
  18:	29317574 	ldmdbcs	r1!, {r2, r4, r5, r6, r8, sl, ip, sp, lr}
  1c:	322e3920 	eorcc	r3, lr, #32, 18	; 0x80000
  20:	3220312e 	eorcc	r3, r0, #-2147483637	; 0x8000000b
  24:	31393130 	teqcc	r9, r0, lsr r1
  28:	20353230 	eorscs	r3, r5, r0, lsr r2
  2c:	6c657228 	sfmvs	f7, 2, [r5], #-160	; 0xffffff60
  30:	65736165 	ldrbvs	r6, [r3, #-357]!	; 0xfffffe9b
  34:	415b2029 	cmpmi	fp, r9, lsr #32
  38:	612f4d52 			; <UNDEFINED> instruction: 0x612f4d52
  3c:	392d6d72 	pushcc	{r1, r4, r5, r6, r8, sl, fp, sp, lr}
  40:	6172622d 	cmnvs	r2, sp, lsr #4
  44:	2068636e 	rsbcs	r6, r8, lr, ror #6
  48:	69766572 	ldmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
  4c:	6e6f6973 			; <UNDEFINED> instruction: 0x6e6f6973
  50:	37373220 	ldrcc	r3, [r7, -r0, lsr #4]!
  54:	5d393935 			; <UNDEFINED> instruction: 0x5d393935
	...

Disassembly of section .ARM.attributes:

00000000 <.ARM.attributes>:
   0:	00003041 	andeq	r3, r0, r1, asr #32
   4:	61656100 	cmnvs	r5, r0, lsl #2
   8:	01006962 	tsteq	r0, r2, ror #18
   c:	00000026 	andeq	r0, r0, r6, lsr #32
  10:	4b5a3605 	blmi	168d82c <_bss_end+0x16819c8>
  14:	08070600 	stmdaeq	r7, {r9, sl}
  18:	0a010901 	beq	42424 <_bss_end+0x365c0>
  1c:	14041202 	strne	r1, [r4], #-514	; 0xfffffdfe
  20:	17011501 	strne	r1, [r1, -r1, lsl #10]
  24:	1a011803 	bne	46038 <_bss_end+0x3a1d4>
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
  18:	000080ac 	andeq	r8, r0, ip, lsr #1
  1c:	00000038 	andeq	r0, r0, r8, lsr r0
  20:	8b040e42 	blhi	103930 <_bss_end+0xf7acc>
  24:	0b0d4201 	bleq	350830 <_bss_end+0x3449cc>
  28:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
  2c:	00000ecb 	andeq	r0, r0, fp, asr #29
  30:	0000001c 	andeq	r0, r0, ip, lsl r0
  34:	00000000 	andeq	r0, r0, r0
  38:	000080e4 	andeq	r8, r0, r4, ror #1
  3c:	0000002c 	andeq	r0, r0, ip, lsr #32
  40:	8b040e42 	blhi	103950 <_bss_end+0xf7aec>
  44:	0b0d4201 	bleq	350850 <_bss_end+0x3449ec>
  48:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
  4c:	00000ecb 	andeq	r0, r0, fp, asr #29
  50:	0000001c 	andeq	r0, r0, ip, lsl r0
  54:	00000000 	andeq	r0, r0, r0
  58:	00008110 	andeq	r8, r0, r0, lsl r1
  5c:	00000020 	andeq	r0, r0, r0, lsr #32
  60:	8b040e42 	blhi	103970 <_bss_end+0xf7b0c>
  64:	0b0d4201 	bleq	350870 <_bss_end+0x344a0c>
  68:	420d0d48 	andmi	r0, sp, #72, 26	; 0x1200
  6c:	00000ecb 	andeq	r0, r0, fp, asr #29
  70:	0000001c 	andeq	r0, r0, ip, lsl r0
  74:	00000000 	andeq	r0, r0, r0
  78:	00008130 	andeq	r8, r0, r0, lsr r1
  7c:	00000018 	andeq	r0, r0, r8, lsl r0
  80:	8b040e42 	blhi	103990 <_bss_end+0xf7b2c>
  84:	0b0d4201 	bleq	350890 <_bss_end+0x344a2c>
  88:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  8c:	00000ecb 	andeq	r0, r0, fp, asr #29
  90:	0000001c 	andeq	r0, r0, ip, lsl r0
  94:	00000000 	andeq	r0, r0, r0
  98:	00008148 	andeq	r8, r0, r8, asr #2
  9c:	00000018 	andeq	r0, r0, r8, lsl r0
  a0:	8b040e42 	blhi	1039b0 <_bss_end+0xf7b4c>
  a4:	0b0d4201 	bleq	3508b0 <_bss_end+0x344a4c>
  a8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  ac:	00000ecb 	andeq	r0, r0, fp, asr #29
  b0:	0000001c 	andeq	r0, r0, ip, lsl r0
  b4:	00000000 	andeq	r0, r0, r0
  b8:	00008160 	andeq	r8, r0, r0, ror #2
  bc:	00000018 	andeq	r0, r0, r8, lsl r0
  c0:	8b040e42 	blhi	1039d0 <_bss_end+0xf7b6c>
  c4:	0b0d4201 	bleq	3508d0 <_bss_end+0x344a6c>
  c8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  cc:	00000ecb 	andeq	r0, r0, fp, asr #29
  d0:	00000014 	andeq	r0, r0, r4, lsl r0
  d4:	00000000 	andeq	r0, r0, r0
  d8:	00008178 	andeq	r8, r0, r8, ror r1
  dc:	0000000c 	andeq	r0, r0, ip
  e0:	8b040e42 	blhi	1039f0 <_bss_end+0xf7b8c>
  e4:	0b0d4201 	bleq	3508f0 <_bss_end+0x344a8c>
  e8:	0000000c 	andeq	r0, r0, ip
  ec:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  f0:	7c020001 	stcvc	0, cr0, [r2], {1}
  f4:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  f8:	0000001c 	andeq	r0, r0, ip, lsl r0
  fc:	000000e8 	andeq	r0, r0, r8, ror #1
 100:	00008184 	andeq	r8, r0, r4, lsl #3
 104:	00000034 	andeq	r0, r0, r4, lsr r0
 108:	8b040e42 	blhi	103a18 <_bss_end+0xf7bb4>
 10c:	0b0d4201 	bleq	350918 <_bss_end+0x344ab4>
 110:	420d0d52 	andmi	r0, sp, #5248	; 0x1480
 114:	00000ecb 	andeq	r0, r0, fp, asr #29
 118:	0000001c 	andeq	r0, r0, ip, lsl r0
 11c:	000000e8 	andeq	r0, r0, r8, ror #1
 120:	000081b8 			; <UNDEFINED> instruction: 0x000081b8
 124:	00000098 	muleq	r0, r8, r0
 128:	8b040e42 	blhi	103a38 <_bss_end+0xf7bd4>
 12c:	0b0d4201 	bleq	350938 <_bss_end+0x344ad4>
 130:	0d0d4202 	sfmeq	f4, 4, [sp, #-8]
 134:	000ecb42 	andeq	ip, lr, r2, asr #22
 138:	0000001c 	andeq	r0, r0, ip, lsl r0
 13c:	000000e8 	andeq	r0, r0, r8, ror #1
 140:	00008250 	andeq	r8, r0, r0, asr r2
 144:	00000074 	andeq	r0, r0, r4, ror r0
 148:	8b040e42 	blhi	103a58 <_bss_end+0xf7bf4>
 14c:	0b0d4201 	bleq	350958 <_bss_end+0x344af4>
 150:	420d0d72 	andmi	r0, sp, #7296	; 0x1c80
 154:	00000ecb 	andeq	r0, r0, fp, asr #29
 158:	0000001c 	andeq	r0, r0, ip, lsl r0
 15c:	000000e8 	andeq	r0, r0, r8, ror #1
 160:	000082c4 	andeq	r8, r0, r4, asr #5
 164:	00000074 	andeq	r0, r0, r4, ror r0
 168:	8b040e42 	blhi	103a78 <_bss_end+0xf7c14>
 16c:	0b0d4201 	bleq	350978 <_bss_end+0x344b14>
 170:	420d0d72 	andmi	r0, sp, #7296	; 0x1c80
 174:	00000ecb 	andeq	r0, r0, fp, asr #29
 178:	0000001c 	andeq	r0, r0, ip, lsl r0
 17c:	000000e8 	andeq	r0, r0, r8, ror #1
 180:	00008338 	andeq	r8, r0, r8, lsr r3
 184:	00000074 	andeq	r0, r0, r4, ror r0
 188:	8b040e42 	blhi	103a98 <_bss_end+0xf7c34>
 18c:	0b0d4201 	bleq	350998 <_bss_end+0x344b34>
 190:	420d0d72 	andmi	r0, sp, #7296	; 0x1c80
 194:	00000ecb 	andeq	r0, r0, fp, asr #29
 198:	0000001c 	andeq	r0, r0, ip, lsl r0
 19c:	000000e8 	andeq	r0, r0, r8, ror #1
 1a0:	000083ac 	andeq	r8, r0, ip, lsr #7
 1a4:	000000c8 	andeq	r0, r0, r8, asr #1
 1a8:	8b080e42 	blhi	203ab8 <_bss_end+0x1f7c54>
 1ac:	42018e02 	andmi	r8, r1, #2, 28
 1b0:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 1b4:	080d0c5e 	stmdaeq	sp, {r1, r2, r3, r4, r6, sl, fp}
 1b8:	0000001c 	andeq	r0, r0, ip, lsl r0
 1bc:	000000e8 	andeq	r0, r0, r8, ror #1
 1c0:	00008474 	andeq	r8, r0, r4, ror r4
 1c4:	00000074 	andeq	r0, r0, r4, ror r0
 1c8:	8b080e42 	blhi	203ad8 <_bss_end+0x1f7c74>
 1cc:	42018e02 	andmi	r8, r1, #2, 28
 1d0:	74040b0c 	strvc	r0, [r4], #-2828	; 0xfffff4f4
 1d4:	00080d0c 	andeq	r0, r8, ip, lsl #26
 1d8:	0000001c 	andeq	r0, r0, ip, lsl r0
 1dc:	000000e8 	andeq	r0, r0, r8, ror #1
 1e0:	000084e8 	andeq	r8, r0, r8, ror #9
 1e4:	000000d8 	ldrdeq	r0, [r0], -r8
 1e8:	8b080e42 	blhi	203af8 <_bss_end+0x1f7c94>
 1ec:	42018e02 	andmi	r8, r1, #2, 28
 1f0:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 1f4:	080d0c66 	stmdaeq	sp, {r1, r2, r5, r6, sl, fp}
 1f8:	0000001c 	andeq	r0, r0, ip, lsl r0
 1fc:	000000e8 	andeq	r0, r0, r8, ror #1
 200:	000085c0 	andeq	r8, r0, r0, asr #11
 204:	00000084 	andeq	r0, r0, r4, lsl #1
 208:	8b080e42 	blhi	203b18 <_bss_end+0x1f7cb4>
 20c:	42018e02 	andmi	r8, r1, #2, 28
 210:	7c040b0c 			; <UNDEFINED> instruction: 0x7c040b0c
 214:	00080d0c 	andeq	r0, r8, ip, lsl #26
 218:	0000001c 	andeq	r0, r0, ip, lsl r0
 21c:	000000e8 	andeq	r0, r0, r8, ror #1
 220:	00008644 	andeq	r8, r0, r4, asr #12
 224:	00000054 	andeq	r0, r0, r4, asr r0
 228:	8b080e42 	blhi	203b38 <_bss_end+0x1f7cd4>
 22c:	42018e02 	andmi	r8, r1, #2, 28
 230:	5e040b0c 	vmlapl.f64	d0, d4, d12
 234:	00080d0c 	andeq	r0, r8, ip, lsl #26
 238:	00000018 	andeq	r0, r0, r8, lsl r0
 23c:	000000e8 	andeq	r0, r0, r8, ror #1
 240:	00008698 	muleq	r0, r8, r6
 244:	0000001c 	andeq	r0, r0, ip, lsl r0
 248:	8b080e42 	blhi	203b58 <_bss_end+0x1f7cf4>
 24c:	42018e02 	andmi	r8, r1, #2, 28
 250:	00040b0c 	andeq	r0, r4, ip, lsl #22
 254:	0000000c 	andeq	r0, r0, ip
 258:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 25c:	7c020001 	stcvc	0, cr0, [r2], {1}
 260:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 264:	0000001c 	andeq	r0, r0, ip, lsl r0
 268:	00000254 	andeq	r0, r0, r4, asr r2
 26c:	000086b4 			; <UNDEFINED> instruction: 0x000086b4
 270:	00000078 	andeq	r0, r0, r8, ror r0
 274:	8b040e42 	blhi	103b84 <_bss_end+0xf7d20>
 278:	0b0d4201 	bleq	350a84 <_bss_end+0x344c20>
 27c:	420d0d74 	andmi	r0, sp, #116, 26	; 0x1d00
 280:	00000ecb 	andeq	r0, r0, fp, asr #29
 284:	0000001c 	andeq	r0, r0, ip, lsl r0
 288:	00000254 	andeq	r0, r0, r4, asr r2
 28c:	00008cec 	andeq	r8, r0, ip, ror #25
 290:	00000038 	andeq	r0, r0, r8, lsr r0
 294:	8b040e42 	blhi	103ba4 <_bss_end+0xf7d40>
 298:	0b0d4201 	bleq	350aa4 <_bss_end+0x344c40>
 29c:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
 2a0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2a4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2a8:	00000254 	andeq	r0, r0, r4, asr r2
 2ac:	0000872c 	andeq	r8, r0, ip, lsr #14
 2b0:	000000a8 	andeq	r0, r0, r8, lsr #1
 2b4:	8b080e42 	blhi	203bc4 <_bss_end+0x1f7d60>
 2b8:	42018e02 	andmi	r8, r1, #2, 28
 2bc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 2c0:	080d0c4e 	stmdaeq	sp, {r1, r2, r3, r6, sl, fp}
 2c4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2c8:	00000254 	andeq	r0, r0, r4, asr r2
 2cc:	00008d24 	andeq	r8, r0, r4, lsr #26
 2d0:	00000088 	andeq	r0, r0, r8, lsl #1
 2d4:	8b080e42 	blhi	203be4 <_bss_end+0x1f7d80>
 2d8:	42018e02 	andmi	r8, r1, #2, 28
 2dc:	7e040b0c 	vmlavc.f64	d0, d4, d12
 2e0:	00080d0c 	andeq	r0, r8, ip, lsl #26
 2e4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2e8:	00000254 	andeq	r0, r0, r4, asr r2
 2ec:	000087d4 	ldrdeq	r8, [r0], -r4
 2f0:	00000130 	andeq	r0, r0, r0, lsr r1
 2f4:	8b040e42 	blhi	103c04 <_bss_end+0xf7da0>
 2f8:	0b0d4201 	bleq	350b04 <_bss_end+0x344ca0>
 2fc:	0d0d9002 	stceq	0, cr9, [sp, #-8]
 300:	000ecb42 	andeq	ip, lr, r2, asr #22
 304:	0000001c 	andeq	r0, r0, ip, lsl r0
 308:	00000254 	andeq	r0, r0, r4, asr r2
 30c:	00008dac 	andeq	r8, r0, ip, lsr #27
 310:	0000002c 	andeq	r0, r0, ip, lsr #32
 314:	8b040e42 	blhi	103c24 <_bss_end+0xf7dc0>
 318:	0b0d4201 	bleq	350b24 <_bss_end+0x344cc0>
 31c:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 320:	00000ecb 	andeq	r0, r0, fp, asr #29
 324:	0000001c 	andeq	r0, r0, ip, lsl r0
 328:	00000254 	andeq	r0, r0, r4, asr r2
 32c:	00008904 	andeq	r8, r0, r4, lsl #18
 330:	000000a8 	andeq	r0, r0, r8, lsr #1
 334:	8b080e42 	blhi	203c44 <_bss_end+0x1f7de0>
 338:	42018e02 	andmi	r8, r1, #2, 28
 33c:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 340:	080d0c4e 	stmdaeq	sp, {r1, r2, r3, r6, sl, fp}
 344:	0000001c 	andeq	r0, r0, ip, lsl r0
 348:	00000254 	andeq	r0, r0, r4, asr r2
 34c:	000089ac 	andeq	r8, r0, ip, lsr #19
 350:	00000078 	andeq	r0, r0, r8, ror r0
 354:	8b080e42 	blhi	203c64 <_bss_end+0x1f7e00>
 358:	42018e02 	andmi	r8, r1, #2, 28
 35c:	76040b0c 	strvc	r0, [r4], -ip, lsl #22
 360:	00080d0c 	andeq	r0, r8, ip, lsl #26
 364:	0000001c 	andeq	r0, r0, ip, lsl r0
 368:	00000254 	andeq	r0, r0, r4, asr r2
 36c:	00008a24 	andeq	r8, r0, r4, lsr #20
 370:	00000034 	andeq	r0, r0, r4, lsr r0
 374:	8b040e42 	blhi	103c84 <_bss_end+0xf7e20>
 378:	0b0d4201 	bleq	350b84 <_bss_end+0x344d20>
 37c:	420d0d52 	andmi	r0, sp, #5248	; 0x1480
 380:	00000ecb 	andeq	r0, r0, fp, asr #29
 384:	0000001c 	andeq	r0, r0, ip, lsl r0
 388:	00000254 	andeq	r0, r0, r4, asr r2
 38c:	00008a58 	andeq	r8, r0, r8, asr sl
 390:	00000054 	andeq	r0, r0, r4, asr r0
 394:	8b080e42 	blhi	203ca4 <_bss_end+0x1f7e40>
 398:	42018e02 	andmi	r8, r1, #2, 28
 39c:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 3a0:	00080d0c 	andeq	r0, r8, ip, lsl #26
 3a4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3a8:	00000254 	andeq	r0, r0, r4, asr r2
 3ac:	00008aac 	andeq	r8, r0, ip, lsr #21
 3b0:	00000060 	andeq	r0, r0, r0, rrx
 3b4:	8b080e42 	blhi	203cc4 <_bss_end+0x1f7e60>
 3b8:	42018e02 	andmi	r8, r1, #2, 28
 3bc:	66040b0c 	strvs	r0, [r4], -ip, lsl #22
 3c0:	00080d0c 	andeq	r0, r8, ip, lsl #26
 3c4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3c8:	00000254 	andeq	r0, r0, r4, asr r2
 3cc:	00008dd8 	ldrdeq	r8, [r0], -r8	; <UNPREDICTABLE>
 3d0:	00000090 	muleq	r0, r0, r0
 3d4:	8b040e42 	blhi	103ce4 <_bss_end+0xf7e80>
 3d8:	0b0d4201 	bleq	350be4 <_bss_end+0x344d80>
 3dc:	0d0d4002 	stceq	0, cr4, [sp, #-8]
 3e0:	000ecb42 	andeq	ip, lr, r2, asr #22
 3e4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3e8:	00000254 	andeq	r0, r0, r4, asr r2
 3ec:	00008e68 	andeq	r8, r0, r8, ror #28
 3f0:	0000007c 	andeq	r0, r0, ip, ror r0
 3f4:	8b040e42 	blhi	103d04 <_bss_end+0xf7ea0>
 3f8:	0b0d4201 	bleq	350c04 <_bss_end+0x344da0>
 3fc:	420d0d76 	andmi	r0, sp, #7552	; 0x1d80
 400:	00000ecb 	andeq	r0, r0, fp, asr #29
 404:	0000001c 	andeq	r0, r0, ip, lsl r0
 408:	00000254 	andeq	r0, r0, r4, asr r2
 40c:	00008b0c 	andeq	r8, r0, ip, lsl #22
 410:	0000016c 	andeq	r0, r0, ip, ror #2
 414:	8b080e42 	blhi	203d24 <_bss_end+0x1f7ec0>
 418:	42018e02 	andmi	r8, r1, #2, 28
 41c:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 420:	080d0cae 	stmdaeq	sp, {r1, r2, r3, r5, r7, sl, fp}
 424:	0000001c 	andeq	r0, r0, ip, lsl r0
 428:	00000254 	andeq	r0, r0, r4, asr r2
 42c:	00008c78 	andeq	r8, r0, r8, ror ip
 430:	00000058 	andeq	r0, r0, r8, asr r0
 434:	8b080e42 	blhi	203d44 <_bss_end+0x1f7ee0>
 438:	42018e02 	andmi	r8, r1, #2, 28
 43c:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 440:	00080d0c 	andeq	r0, r8, ip, lsl #26
 444:	00000018 	andeq	r0, r0, r8, lsl r0
 448:	00000254 	andeq	r0, r0, r4, asr r2
 44c:	00008cd0 	ldrdeq	r8, [r0], -r0
 450:	0000001c 	andeq	r0, r0, ip, lsl r0
 454:	8b080e42 	blhi	203d64 <_bss_end+0x1f7f00>
 458:	42018e02 	andmi	r8, r1, #2, 28
 45c:	00040b0c 	andeq	r0, r4, ip, lsl #22
 460:	0000000c 	andeq	r0, r0, ip
 464:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 468:	7c020001 	stcvc	0, cr0, [r2], {1}
 46c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 470:	0000001c 	andeq	r0, r0, ip, lsl r0
 474:	00000460 	andeq	r0, r0, r0, ror #8
 478:	00008ee4 	andeq	r8, r0, r4, ror #29
 47c:	00000040 	andeq	r0, r0, r0, asr #32
 480:	8b040e42 	blhi	103d90 <_bss_end+0xf7f2c>
 484:	0b0d4201 	bleq	350c90 <_bss_end+0x344e2c>
 488:	420d0d58 	andmi	r0, sp, #88, 26	; 0x1600
 48c:	00000ecb 	andeq	r0, r0, fp, asr #29
 490:	0000001c 	andeq	r0, r0, ip, lsl r0
 494:	00000460 	andeq	r0, r0, r0, ror #8
 498:	00008f24 	andeq	r8, r0, r4, lsr #30
 49c:	00000038 	andeq	r0, r0, r8, lsr r0
 4a0:	8b040e42 	blhi	103db0 <_bss_end+0xf7f4c>
 4a4:	0b0d4201 	bleq	350cb0 <_bss_end+0x344e4c>
 4a8:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
 4ac:	00000ecb 	andeq	r0, r0, fp, asr #29
 4b0:	00000020 	andeq	r0, r0, r0, lsr #32
 4b4:	00000460 	andeq	r0, r0, r0, ror #8
 4b8:	00008f5c 	andeq	r8, r0, ip, asr pc
 4bc:	000000cc 	andeq	r0, r0, ip, asr #1
 4c0:	840c0e42 	strhi	r0, [ip], #-3650	; 0xfffff1be
 4c4:	8e028b03 	vmlahi.f64	d8, d2, d3
 4c8:	0b0c4201 	bleq	310cd4 <_bss_end+0x304e70>
 4cc:	0c600204 	sfmeq	f0, 2, [r0], #-16
 4d0:	00000c0d 	andeq	r0, r0, sp, lsl #24
 4d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 4d8:	00000460 	andeq	r0, r0, r0, ror #8
 4dc:	00009028 	andeq	r9, r0, r8, lsr #32
 4e0:	0000004c 	andeq	r0, r0, ip, asr #32
 4e4:	8b080e42 	blhi	203df4 <_bss_end+0x1f7f90>
 4e8:	42018e02 	andmi	r8, r1, #2, 28
 4ec:	60040b0c 	andvs	r0, r4, ip, lsl #22
 4f0:	00080d0c 	andeq	r0, r8, ip, lsl #26
 4f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 4f8:	00000460 	andeq	r0, r0, r0, ror #8
 4fc:	00009074 	andeq	r9, r0, r4, ror r0
 500:	00000050 	andeq	r0, r0, r0, asr r0
 504:	8b080e42 	blhi	203e14 <_bss_end+0x1f7fb0>
 508:	42018e02 	andmi	r8, r1, #2, 28
 50c:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 510:	00080d0c 	andeq	r0, r8, ip, lsl #26
 514:	0000001c 	andeq	r0, r0, ip, lsl r0
 518:	00000460 	andeq	r0, r0, r0, ror #8
 51c:	000090c4 	andeq	r9, r0, r4, asr #1
 520:	00000040 	andeq	r0, r0, r0, asr #32
 524:	8b080e42 	blhi	203e34 <_bss_end+0x1f7fd0>
 528:	42018e02 	andmi	r8, r1, #2, 28
 52c:	5a040b0c 	bpl	103164 <_bss_end+0xf7300>
 530:	00080d0c 	andeq	r0, r8, ip, lsl #26
 534:	0000001c 	andeq	r0, r0, ip, lsl r0
 538:	00000460 	andeq	r0, r0, r0, ror #8
 53c:	00009104 	andeq	r9, r0, r4, lsl #2
 540:	00000054 	andeq	r0, r0, r4, asr r0
 544:	8b080e42 	blhi	203e54 <_bss_end+0x1f7ff0>
 548:	42018e02 	andmi	r8, r1, #2, 28
 54c:	5e040b0c 	vmlapl.f64	d0, d4, d12
 550:	00080d0c 	andeq	r0, r8, ip, lsl #26
 554:	00000018 	andeq	r0, r0, r8, lsl r0
 558:	00000460 	andeq	r0, r0, r0, ror #8
 55c:	00009158 	andeq	r9, r0, r8, asr r1
 560:	0000001c 	andeq	r0, r0, ip, lsl r0
 564:	8b080e42 	blhi	203e74 <_bss_end+0x1f8010>
 568:	42018e02 	andmi	r8, r1, #2, 28
 56c:	00040b0c 	andeq	r0, r4, ip, lsl #22
 570:	0000000c 	andeq	r0, r0, ip
 574:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 578:	7c020001 	stcvc	0, cr0, [r2], {1}
 57c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 580:	0000001c 	andeq	r0, r0, ip, lsl r0
 584:	00000570 	andeq	r0, r0, r0, ror r5
 588:	00009174 	andeq	r9, r0, r4, ror r1
 58c:	00000018 	andeq	r0, r0, r8, lsl r0
 590:	8b040e42 	blhi	103ea0 <_bss_end+0xf803c>
 594:	0b0d4201 	bleq	350da0 <_bss_end+0x344f3c>
 598:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
 59c:	00000ecb 	andeq	r0, r0, fp, asr #29
 5a0:	00000018 	andeq	r0, r0, r8, lsl r0
 5a4:	00000570 	andeq	r0, r0, r0, ror r5
 5a8:	0000918c 	andeq	r9, r0, ip, lsl #3
 5ac:	00000030 	andeq	r0, r0, r0, lsr r0
 5b0:	8b080e42 	blhi	203ec0 <_bss_end+0x1f805c>
 5b4:	42018e02 	andmi	r8, r1, #2, 28
 5b8:	00040b0c 	andeq	r0, r4, ip, lsl #22
 5bc:	00000014 	andeq	r0, r0, r4, lsl r0
 5c0:	00000570 	andeq	r0, r0, r0, ror r5
 5c4:	000091bc 			; <UNDEFINED> instruction: 0x000091bc
 5c8:	00000010 	andeq	r0, r0, r0, lsl r0
 5cc:	040b0c42 	streq	r0, [fp], #-3138	; 0xfffff3be
 5d0:	000d0c44 	andeq	r0, sp, r4, asr #24
 5d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 5d8:	00000570 	andeq	r0, r0, r0, ror r5
 5dc:	000091cc 	andeq	r9, r0, ip, asr #3
 5e0:	00000034 	andeq	r0, r0, r4, lsr r0
 5e4:	8b040e42 	blhi	103ef4 <_bss_end+0xf8090>
 5e8:	0b0d4201 	bleq	350df4 <_bss_end+0x344f90>
 5ec:	420d0d52 	andmi	r0, sp, #5248	; 0x1480
 5f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 5f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 5f8:	00000570 	andeq	r0, r0, r0, ror r5
 5fc:	00009200 	andeq	r9, r0, r0, lsl #4
 600:	00000038 	andeq	r0, r0, r8, lsr r0
 604:	8b040e42 	blhi	103f14 <_bss_end+0xf80b0>
 608:	0b0d4201 	bleq	350e14 <_bss_end+0x344fb0>
 60c:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
 610:	00000ecb 	andeq	r0, r0, fp, asr #29
 614:	00000020 	andeq	r0, r0, r0, lsr #32
 618:	00000570 	andeq	r0, r0, r0, ror r5
 61c:	00009238 	andeq	r9, r0, r8, lsr r2
 620:	00000044 	andeq	r0, r0, r4, asr #32
 624:	840c0e42 	strhi	r0, [ip], #-3650	; 0xfffff1be
 628:	8e028b03 	vmlahi.f64	d8, d2, d3
 62c:	0b0c4201 	bleq	310e38 <_bss_end+0x304fd4>
 630:	0d0c5c04 	stceq	12, cr5, [ip, #-16]
 634:	0000000c 	andeq	r0, r0, ip
 638:	00000020 	andeq	r0, r0, r0, lsr #32
 63c:	00000570 	andeq	r0, r0, r0, ror r5
 640:	0000927c 	andeq	r9, r0, ip, ror r2
 644:	00000044 	andeq	r0, r0, r4, asr #32
 648:	840c0e42 	strhi	r0, [ip], #-3650	; 0xfffff1be
 64c:	8e028b03 	vmlahi.f64	d8, d2, d3
 650:	0b0c4201 	bleq	310e5c <_bss_end+0x304ff8>
 654:	0d0c5c04 	stceq	12, cr5, [ip, #-16]
 658:	0000000c 	andeq	r0, r0, ip
 65c:	00000020 	andeq	r0, r0, r0, lsr #32
 660:	00000570 	andeq	r0, r0, r0, ror r5
 664:	000092c0 	andeq	r9, r0, r0, asr #5
 668:	00000050 	andeq	r0, r0, r0, asr r0
 66c:	840c0e42 	strhi	r0, [ip], #-3650	; 0xfffff1be
 670:	8e028b03 	vmlahi.f64	d8, d2, d3
 674:	0b0c4201 	bleq	310e80 <_bss_end+0x30501c>
 678:	0d0c6204 	sfmeq	f6, 4, [ip, #-16]
 67c:	0000000c 	andeq	r0, r0, ip
 680:	00000020 	andeq	r0, r0, r0, lsr #32
 684:	00000570 	andeq	r0, r0, r0, ror r5
 688:	00009310 	andeq	r9, r0, r0, lsl r3
 68c:	00000050 	andeq	r0, r0, r0, asr r0
 690:	840c0e42 	strhi	r0, [ip], #-3650	; 0xfffff1be
 694:	8e028b03 	vmlahi.f64	d8, d2, d3
 698:	0b0c4201 	bleq	310ea4 <_bss_end+0x305040>
 69c:	0d0c6204 	sfmeq	f6, 4, [ip, #-16]
 6a0:	0000000c 	andeq	r0, r0, ip
 6a4:	0000001c 	andeq	r0, r0, ip, lsl r0
 6a8:	00000570 	andeq	r0, r0, r0, ror r5
 6ac:	00009360 	andeq	r9, r0, r0, ror #6
 6b0:	00000054 	andeq	r0, r0, r4, asr r0
 6b4:	8b080e42 	blhi	203fc4 <_bss_end+0x1f8160>
 6b8:	42018e02 	andmi	r8, r1, #2, 28
 6bc:	5e040b0c 	vmlapl.f64	d0, d4, d12
 6c0:	00080d0c 	andeq	r0, r8, ip, lsl #26
 6c4:	00000018 	andeq	r0, r0, r8, lsl r0
 6c8:	00000570 	andeq	r0, r0, r0, ror r5
 6cc:	000093b4 			; <UNDEFINED> instruction: 0x000093b4
 6d0:	0000001c 	andeq	r0, r0, ip, lsl r0
 6d4:	8b080e42 	blhi	203fe4 <_bss_end+0x1f8180>
 6d8:	42018e02 	andmi	r8, r1, #2, 28
 6dc:	00040b0c 	andeq	r0, r4, ip, lsl #22
 6e0:	0000000c 	andeq	r0, r0, ip
 6e4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 6e8:	7c020001 	stcvc	0, cr0, [r2], {1}
 6ec:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 6f0:	00000018 	andeq	r0, r0, r8, lsl r0
 6f4:	000006e0 	andeq	r0, r0, r0, ror #13
 6f8:	000093d0 	ldrdeq	r9, [r0], -r0
 6fc:	0000005c 	andeq	r0, r0, ip, asr r0
 700:	8b080e42 	blhi	204010 <_bss_end+0x1f81ac>
 704:	42018e02 	andmi	r8, r1, #2, 28
 708:	00040b0c 	andeq	r0, r4, ip, lsl #22
 70c:	00000018 	andeq	r0, r0, r8, lsl r0
 710:	000006e0 	andeq	r0, r0, r0, ror #13
 714:	0000942c 	andeq	r9, r0, ip, lsr #8
 718:	0000009c 	muleq	r0, ip, r0
 71c:	8b080e42 	blhi	20402c <_bss_end+0x1f81c8>
 720:	42018e02 	andmi	r8, r1, #2, 28
 724:	00040b0c 	andeq	r0, r4, ip, lsl #22
 728:	00000018 	andeq	r0, r0, r8, lsl r0
 72c:	000006e0 	andeq	r0, r0, r0, ror #13
 730:	000094c8 	andeq	r9, r0, r8, asr #9
 734:	0000009c 	muleq	r0, ip, r0
 738:	8b080e42 	blhi	204048 <_bss_end+0x1f81e4>
 73c:	42018e02 	andmi	r8, r1, #2, 28
 740:	00040b0c 	andeq	r0, r4, ip, lsl #22
 744:	00000018 	andeq	r0, r0, r8, lsl r0
 748:	000006e0 	andeq	r0, r0, r0, ror #13
 74c:	00009564 	andeq	r9, r0, r4, ror #10
 750:	0000009c 	muleq	r0, ip, r0
 754:	8b080e42 	blhi	204064 <_bss_end+0x1f8200>
 758:	42018e02 	andmi	r8, r1, #2, 28
 75c:	00040b0c 	andeq	r0, r4, ip, lsl #22
 760:	00000018 	andeq	r0, r0, r8, lsl r0
 764:	000006e0 	andeq	r0, r0, r0, ror #13
 768:	00009600 	andeq	r9, r0, r0, lsl #12
 76c:	0000009c 	muleq	r0, ip, r0
 770:	8b080e42 	blhi	204080 <_bss_end+0x1f821c>
 774:	42018e02 	andmi	r8, r1, #2, 28
 778:	00040b0c 	andeq	r0, r4, ip, lsl #22
 77c:	00000018 	andeq	r0, r0, r8, lsl r0
 780:	000006e0 	andeq	r0, r0, r0, ror #13
 784:	0000969c 	muleq	r0, ip, r6
 788:	000000cc 	andeq	r0, r0, ip, asr #1
 78c:	8b080e42 	blhi	20409c <_bss_end+0x1f8238>
 790:	42018e02 	andmi	r8, r1, #2, 28
 794:	00040b0c 	andeq	r0, r4, ip, lsl #22
 798:	0000000c 	andeq	r0, r0, ip
 79c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 7a0:	7c020001 	stcvc	0, cr0, [r2], {1}
 7a4:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 7a8:	0000001c 	andeq	r0, r0, ip, lsl r0
 7ac:	00000798 	muleq	r0, r8, r7
 7b0:	00009768 	andeq	r9, r0, r8, ror #14
 7b4:	00000034 	andeq	r0, r0, r4, lsr r0
 7b8:	8b080e42 	blhi	2040c8 <_bss_end+0x1f8264>
 7bc:	42018e02 	andmi	r8, r1, #2, 28
 7c0:	54040b0c 	strpl	r0, [r4], #-2828	; 0xfffff4f4
 7c4:	00080d0c 	andeq	r0, r8, ip, lsl #26
 7c8:	0000001c 	andeq	r0, r0, ip, lsl r0
 7cc:	00000798 	muleq	r0, r8, r7
 7d0:	0000979c 	muleq	r0, ip, r7
 7d4:	00000068 	andeq	r0, r0, r8, rrx
 7d8:	8b080e42 	blhi	2040e8 <_bss_end+0x1f8284>
 7dc:	42018e02 	andmi	r8, r1, #2, 28
 7e0:	6a040b0c 	bvs	103418 <_bss_end+0xf75b4>
 7e4:	00080d0c 	andeq	r0, r8, ip, lsl #26
 7e8:	0000001c 	andeq	r0, r0, ip, lsl r0
 7ec:	00000798 	muleq	r0, r8, r7
 7f0:	00009804 	andeq	r9, r0, r4, lsl #16
 7f4:	0000014c 	andeq	r0, r0, ip, asr #2
 7f8:	8b040e42 	blhi	104108 <_bss_end+0xf82a4>
 7fc:	0b0d4201 	bleq	351008 <_bss_end+0x3451a4>
 800:	0d0d9e02 	stceq	14, cr9, [sp, #-8]
 804:	000ecb42 	andeq	ip, lr, r2, asr #22
 808:	0000001c 	andeq	r0, r0, ip, lsl r0
 80c:	00000798 	muleq	r0, r8, r7
 810:	00009950 	andeq	r9, r0, r0, asr r9
 814:	0000011c 	andeq	r0, r0, ip, lsl r1
 818:	8b040e42 	blhi	104128 <_bss_end+0xf82c4>
 81c:	0b0d4201 	bleq	351028 <_bss_end+0x3451c4>
 820:	0d0d8602 	stceq	6, cr8, [sp, #-8]
 824:	000ecb42 	andeq	ip, lr, r2, asr #22
 828:	0000001c 	andeq	r0, r0, ip, lsl r0
 82c:	00000798 	muleq	r0, r8, r7
 830:	00009a6c 	andeq	r9, r0, ip, ror #20
 834:	0000004c 	andeq	r0, r0, ip, asr #32
 838:	8b080e42 	blhi	204148 <_bss_end+0x1f82e4>
 83c:	42018e02 	andmi	r8, r1, #2, 28
 840:	5c040b0c 			; <UNDEFINED> instruction: 0x5c040b0c
 844:	00080d0c 	andeq	r0, r8, ip, lsl #26
 848:	00000018 	andeq	r0, r0, r8, lsl r0
 84c:	00000798 	muleq	r0, r8, r7
 850:	00009ab8 			; <UNDEFINED> instruction: 0x00009ab8
 854:	0000001c 	andeq	r0, r0, ip, lsl r0
 858:	8b080e42 	blhi	204168 <_bss_end+0x1f8304>
 85c:	42018e02 	andmi	r8, r1, #2, 28
 860:	00040b0c 	andeq	r0, r4, ip, lsl #22
 864:	0000000c 	andeq	r0, r0, ip
 868:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 86c:	7c020001 	stcvc	0, cr0, [r2], {1}
 870:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 874:	0000001c 	andeq	r0, r0, ip, lsl r0
 878:	00000864 	andeq	r0, r0, r4, ror #16
 87c:	00009ad4 	ldrdeq	r9, [r0], -r4
 880:	000000b0 	strheq	r0, [r0], -r0	; <UNPREDICTABLE>
 884:	8b040e42 	blhi	104194 <_bss_end+0xf8330>
 888:	0b0d4201 	bleq	351094 <_bss_end+0x345230>
 88c:	0d0d5002 	stceq	0, cr5, [sp, #-8]
 890:	000ecb42 	andeq	ip, lr, r2, asr #22
 894:	0000001c 	andeq	r0, r0, ip, lsl r0
 898:	00000864 	andeq	r0, r0, r4, ror #16
 89c:	00009b84 	andeq	r9, r0, r4, lsl #23
 8a0:	00000090 	muleq	r0, r0, r0
 8a4:	8b040e42 	blhi	1041b4 <_bss_end+0xf8350>
 8a8:	0b0d4201 	bleq	3510b4 <_bss_end+0x345250>
 8ac:	0d0d4002 	stceq	0, cr4, [sp, #-8]
 8b0:	000ecb42 	andeq	ip, lr, r2, asr #22
 8b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 8b8:	00000864 	andeq	r0, r0, r4, ror #16
 8bc:	00009c14 	andeq	r9, r0, r4, lsl ip
 8c0:	00000064 	andeq	r0, r0, r4, rrx
 8c4:	8b040e42 	blhi	1041d4 <_bss_end+0xf8370>
 8c8:	0b0d4201 	bleq	3510d4 <_bss_end+0x345270>
 8cc:	420d0d68 	andmi	r0, sp, #104, 26	; 0x1a00
 8d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 8d4:	00000020 	andeq	r0, r0, r0, lsr #32
 8d8:	00000864 	andeq	r0, r0, r4, ror #16
 8dc:	00009c78 	andeq	r9, r0, r8, ror ip
 8e0:	000000d4 	ldrdeq	r0, [r0], -r4
 8e4:	840c0e42 	strhi	r0, [ip], #-3650	; 0xfffff1be
 8e8:	8e028b03 	vmlahi.f64	d8, d2, d3
 8ec:	0b0c4201 	bleq	3110f8 <_bss_end+0x305294>
 8f0:	0c640204 	sfmeq	f0, 2, [r4], #-16
 8f4:	00000c0d 	andeq	r0, r0, sp, lsl #24
 8f8:	0000001c 	andeq	r0, r0, ip, lsl r0
 8fc:	00000864 	andeq	r0, r0, r4, ror #16
 900:	00009d4c 	andeq	r9, r0, ip, asr #26
 904:	000001fc 	strdeq	r0, [r0], -ip
 908:	8b080e42 	blhi	204218 <_bss_end+0x1f83b4>
 90c:	42018e02 	andmi	r8, r1, #2, 28
 910:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 914:	080d0cec 	stmdaeq	sp, {r2, r3, r5, r6, r7, sl, fp}
 918:	0000001c 	andeq	r0, r0, ip, lsl r0
 91c:	00000864 	andeq	r0, r0, r4, ror #16
 920:	00009f48 	andeq	r9, r0, r8, asr #30
 924:	00000038 	andeq	r0, r0, r8, lsr r0
 928:	8b080e42 	blhi	204238 <_bss_end+0x1f83d4>
 92c:	42018e02 	andmi	r8, r1, #2, 28
 930:	56040b0c 	strpl	r0, [r4], -ip, lsl #22
 934:	00080d0c 	andeq	r0, r8, ip, lsl #26
 938:	0000001c 	andeq	r0, r0, ip, lsl r0
 93c:	00000864 	andeq	r0, r0, r4, ror #16
 940:	00009f80 	andeq	r9, r0, r0, lsl #31
 944:	0000004c 	andeq	r0, r0, ip, asr #32
 948:	8b080e42 	blhi	204258 <_bss_end+0x1f83f4>
 94c:	42018e02 	andmi	r8, r1, #2, 28
 950:	5c040b0c 			; <UNDEFINED> instruction: 0x5c040b0c
 954:	00080d0c 	andeq	r0, r8, ip, lsl #26
 958:	00000018 	andeq	r0, r0, r8, lsl r0
 95c:	00000864 	andeq	r0, r0, r4, ror #16
 960:	00009fcc 	andeq	r9, r0, ip, asr #31
 964:	0000001c 	andeq	r0, r0, ip, lsl r0
 968:	8b080e42 	blhi	204278 <_bss_end+0x1f8414>
 96c:	42018e02 	andmi	r8, r1, #2, 28
 970:	00040b0c 	andeq	r0, r4, ip, lsl #22
 974:	0000000c 	andeq	r0, r0, ip
 978:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 97c:	7c020001 	stcvc	0, cr0, [r2], {1}
 980:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 984:	0000001c 	andeq	r0, r0, ip, lsl r0
 988:	00000974 	andeq	r0, r0, r4, ror r9
 98c:	00009fe8 	andeq	r9, r0, r8, ror #31
 990:	00000048 	andeq	r0, r0, r8, asr #32
 994:	8b040e42 	blhi	1042a4 <_bss_end+0xf8440>
 998:	0b0d4201 	bleq	3511a4 <_bss_end+0x345340>
 99c:	420d0d5c 	andmi	r0, sp, #92, 26	; 0x1700
 9a0:	00000ecb 	andeq	r0, r0, fp, asr #29
 9a4:	0000001c 	andeq	r0, r0, ip, lsl r0
 9a8:	00000974 	andeq	r0, r0, r4, ror r9
 9ac:	0000a030 	andeq	sl, r0, r0, lsr r0
 9b0:	00000044 	andeq	r0, r0, r4, asr #32
 9b4:	8b040e42 	blhi	1042c4 <_bss_end+0xf8460>
 9b8:	0b0d4201 	bleq	3511c4 <_bss_end+0x345360>
 9bc:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 9c0:	00000ecb 	andeq	r0, r0, fp, asr #29
 9c4:	0000001c 	andeq	r0, r0, ip, lsl r0
 9c8:	00000974 	andeq	r0, r0, r4, ror r9
 9cc:	0000a074 	andeq	sl, r0, r4, ror r0
 9d0:	000000f4 	strdeq	r0, [r0], -r4
 9d4:	8b080e42 	blhi	2042e4 <_bss_end+0x1f8480>
 9d8:	42018e02 	andmi	r8, r1, #2, 28
 9dc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 9e0:	080d0c72 	stmdaeq	sp, {r1, r4, r5, r6, sl, fp}
 9e4:	0000001c 	andeq	r0, r0, ip, lsl r0
 9e8:	00000974 	andeq	r0, r0, r4, ror r9
 9ec:	0000a168 	andeq	sl, r0, r8, ror #2
 9f0:	00000184 	andeq	r0, r0, r4, lsl #3
 9f4:	8b080e42 	blhi	204304 <_bss_end+0x1f84a0>
 9f8:	42018e02 	andmi	r8, r1, #2, 28
 9fc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 a00:	080d0cb2 	stmdaeq	sp, {r1, r4, r5, r7, sl, fp}
 a04:	0000001c 	andeq	r0, r0, ip, lsl r0
 a08:	00000974 	andeq	r0, r0, r4, ror r9
 a0c:	0000a2ec 	andeq	sl, r0, ip, ror #5
 a10:	000000a0 	andeq	r0, r0, r0, lsr #1
 a14:	8b080e42 	blhi	204324 <_bss_end+0x1f84c0>
 a18:	42018e02 	andmi	r8, r1, #2, 28
 a1c:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 a20:	080d0c4a 	stmdaeq	sp, {r1, r3, r6, sl, fp}
 a24:	0000001c 	andeq	r0, r0, ip, lsl r0
 a28:	00000974 	andeq	r0, r0, r4, ror r9
 a2c:	0000a38c 	andeq	sl, r0, ip, lsl #7
 a30:	00000104 	andeq	r0, r0, r4, lsl #2
 a34:	8b080e42 	blhi	204344 <_bss_end+0x1f84e0>
 a38:	42018e02 	andmi	r8, r1, #2, 28
 a3c:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 a40:	080d0c7c 	stmdaeq	sp, {r2, r3, r4, r5, r6, sl, fp}
 a44:	0000001c 	andeq	r0, r0, ip, lsl r0
 a48:	00000974 	andeq	r0, r0, r4, ror r9
 a4c:	0000a4f8 	strdeq	sl, [r0], -r8
 a50:	0000002c 	andeq	r0, r0, ip, lsr #32
 a54:	8b080e42 	blhi	204364 <_bss_end+0x1f8500>
 a58:	42018e02 	andmi	r8, r1, #2, 28
 a5c:	50040b0c 	andpl	r0, r4, ip, lsl #22
 a60:	00080d0c 	andeq	r0, r8, ip, lsl #26
 a64:	0000001c 	andeq	r0, r0, ip, lsl r0
 a68:	00000974 	andeq	r0, r0, r4, ror r9
 a6c:	0000a524 	andeq	sl, r0, r4, lsr #10
 a70:	0000002c 	andeq	r0, r0, ip, lsr #32
 a74:	8b080e42 	blhi	204384 <_bss_end+0x1f8520>
 a78:	42018e02 	andmi	r8, r1, #2, 28
 a7c:	50040b0c 	andpl	r0, r4, ip, lsl #22
 a80:	00080d0c 	andeq	r0, r8, ip, lsl #26
 a84:	0000001c 	andeq	r0, r0, ip, lsl r0
 a88:	00000974 	andeq	r0, r0, r4, ror r9
 a8c:	0000a490 	muleq	r0, r0, r4
 a90:	0000004c 	andeq	r0, r0, ip, asr #32
 a94:	8b080e42 	blhi	2043a4 <_bss_end+0x1f8540>
 a98:	42018e02 	andmi	r8, r1, #2, 28
 a9c:	5c040b0c 			; <UNDEFINED> instruction: 0x5c040b0c
 aa0:	00080d0c 	andeq	r0, r8, ip, lsl #26
 aa4:	00000018 	andeq	r0, r0, r8, lsl r0
 aa8:	00000974 	andeq	r0, r0, r4, ror r9
 aac:	0000a4dc 	ldrdeq	sl, [r0], -ip
 ab0:	0000001c 	andeq	r0, r0, ip, lsl r0
 ab4:	8b080e42 	blhi	2043c4 <_bss_end+0x1f8560>
 ab8:	42018e02 	andmi	r8, r1, #2, 28
 abc:	00040b0c 	andeq	r0, r4, ip, lsl #22
 ac0:	0000000c 	andeq	r0, r0, ip
 ac4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 ac8:	7c020001 	stcvc	0, cr0, [r2], {1}
 acc:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 ad0:	0000001c 	andeq	r0, r0, ip, lsl r0
 ad4:	00000ac0 	andeq	r0, r0, r0, asr #21
 ad8:	0000a5fc 	strdeq	sl, [r0], -ip
 adc:	00000068 	andeq	r0, r0, r8, rrx
 ae0:	8b040e42 	blhi	1043f0 <_bss_end+0xf858c>
 ae4:	0b0d4201 	bleq	3512f0 <_bss_end+0x34548c>
 ae8:	420d0d68 	andmi	r0, sp, #104, 26	; 0x1a00
 aec:	00000ecb 	andeq	r0, r0, fp, asr #29
 af0:	0000001c 	andeq	r0, r0, ip, lsl r0
 af4:	00000ac0 	andeq	r0, r0, r0, asr #21
 af8:	0000a664 	andeq	sl, r0, r4, ror #12
 afc:	00000058 	andeq	r0, r0, r8, asr r0
 b00:	8b080e42 	blhi	204410 <_bss_end+0x1f85ac>
 b04:	42018e02 	andmi	r8, r1, #2, 28
 b08:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 b0c:	00080d0c 	andeq	r0, r8, ip, lsl #26
 b10:	0000001c 	andeq	r0, r0, ip, lsl r0
 b14:	00000ac0 	andeq	r0, r0, r0, asr #21
 b18:	0000a6bc 			; <UNDEFINED> instruction: 0x0000a6bc
 b1c:	00000058 	andeq	r0, r0, r8, asr r0
 b20:	8b080e42 	blhi	204430 <_bss_end+0x1f85cc>
 b24:	42018e02 	andmi	r8, r1, #2, 28
 b28:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 b2c:	00080d0c 	andeq	r0, r8, ip, lsl #26
 b30:	0000000c 	andeq	r0, r0, ip
 b34:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 b38:	7c020001 	stcvc	0, cr0, [r2], {1}
 b3c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 b40:	0000001c 	andeq	r0, r0, ip, lsl r0
 b44:	00000b30 	andeq	r0, r0, r0, lsr fp
 b48:	0000a714 	andeq	sl, r0, r4, lsl r7
 b4c:	00000174 	andeq	r0, r0, r4, ror r1
 b50:	8b080e42 	blhi	204460 <_bss_end+0x1f85fc>
 b54:	42018e02 	andmi	r8, r1, #2, 28
 b58:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 b5c:	080d0cb2 	stmdaeq	sp, {r1, r4, r5, r7, sl, fp}
 b60:	0000000c 	andeq	r0, r0, ip
 b64:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 b68:	7c010001 	stcvc	0, cr0, [r1], {1}
 b6c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 b70:	0000000c 	andeq	r0, r0, ip
 b74:	00000b60 	andeq	r0, r0, r0, ror #22
 b78:	0000a888 	andeq	sl, r0, r8, lsl #17
 b7c:	000001ec 	andeq	r0, r0, ip, ror #3

Disassembly of section .debug_ranges:

00000000 <.debug_ranges>:
   0:	000086b4 			; <UNDEFINED> instruction: 0x000086b4
   4:	00008cec 	andeq	r8, r0, ip, ror #25
   8:	00008cec 	andeq	r8, r0, ip, ror #25
   c:	00008d24 	andeq	r8, r0, r4, lsr #26
  10:	00008d24 	andeq	r8, r0, r4, lsr #26
  14:	00008dac 	andeq	r8, r0, ip, lsr #27
  18:	00008dac 	andeq	r8, r0, ip, lsr #27
  1c:	00008dd8 	ldrdeq	r8, [r0], -r8	; <UNPREDICTABLE>
  20:	00008dd8 	ldrdeq	r8, [r0], -r8	; <UNPREDICTABLE>
  24:	00008e68 	andeq	r8, r0, r8, ror #28
  28:	00008e68 	andeq	r8, r0, r8, ror #28
  2c:	00008ee4 	andeq	r8, r0, r4, ror #29
	...
  38:	00009fe8 	andeq	r9, r0, r8, ror #31
  3c:	0000a4f8 	strdeq	sl, [r0], -r8
  40:	0000a4f8 	strdeq	sl, [r0], -r8
  44:	0000a524 	andeq	sl, r0, r4, lsr #10
  48:	0000a524 	andeq	sl, r0, r4, lsr #10
  4c:	0000a550 	andeq	sl, r0, r0, asr r5
	...
  58:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  5c:	00000000 	andeq	r0, r0, r0
  60:	00008000 	andeq	r8, r0, r0
  64:	000080ac 	andeq	r8, r0, ip, lsr #1
  68:	0000a5ac 	andeq	sl, r0, ip, lsr #11
  6c:	0000a5fc 	strdeq	sl, [r0], -ip
	...
