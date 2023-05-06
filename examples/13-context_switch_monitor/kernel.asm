
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
    8024:	0000a470 	andeq	sl, r0, r0, ror r4

00008028 <_software_interrupt_ptr>:
_software_interrupt_ptr():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:21
    8028:	00009174 	andeq	r9, r0, r4, ror r1

0000802c <_prefetch_abort_ptr>:
_prefetch_abort_ptr():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:21
    802c:	0000a49c 	muleq	r0, ip, r4

00008030 <_data_abort_ptr>:
_data_abort_ptr():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:21
    8030:	0000a4a0 	andeq	sl, r0, r0, lsr #9

00008034 <_unused_handler_ptr>:
_unused_handler_ptr():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:21
    8034:	00008040 	andeq	r8, r0, r0, asr #32

00008038 <_irq_ptr>:
_irq_ptr():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:21
    8038:	0000a474 	andeq	sl, r0, r4, ror r4

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
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:63

	;@ baze pro systemove zasobniky
	mov r4, #0x0
    8058:	e3a04000 	mov	r4, #0
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:66

	;@ nejdrive supervisor mod a jeho stack
    mov r0, #(CPSR_MODE_SVR | CPSR_IRQ_INHIBIT | CPSR_FIQ_INHIBIT)
    805c:	e3a000d3 	mov	r0, #211	; 0xd3
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:67
    msr cpsr_c, r0
    8060:	e121f000 	msr	CPSR_c, r0
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:68
	add sp, r4, #0x8000
    8064:	e284d902 	add	sp, r4, #32768	; 0x8000
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:71

	;@ na moment se prepneme do IRQ rezimu, nastavime mu stack pointer
	mov r0, #(CPSR_MODE_IRQ | CPSR_IRQ_INHIBIT | CPSR_FIQ_INHIBIT)
    8068:	e3a000d2 	mov	r0, #210	; 0xd2
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:72
    msr cpsr_c, r0
    806c:	e121f000 	msr	CPSR_c, r0
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:73
	add sp, r4, #0x7000
    8070:	e284da07 	add	sp, r4, #28672	; 0x7000
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:76

	;@ na moment se prepneme do FIQ rezimu, nastavime mu stack pointer
	mov r0, #(CPSR_MODE_FIQ | CPSR_IRQ_INHIBIT | CPSR_FIQ_INHIBIT)
    8074:	e3a000d1 	mov	r0, #209	; 0xd1
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:77
    msr cpsr_c, r0
    8078:	e121f000 	msr	CPSR_c, r0
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:78
	add sp, r4, #0x6000
    807c:	e284da06 	add	sp, r4, #24576	; 0x6000
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:81

	;@ nakonec system mod a stack
    mov r0, #(CPSR_MODE_SYS | CPSR_IRQ_INHIBIT | CPSR_FIQ_INHIBIT)
    8080:	e3a000df 	mov	r0, #223	; 0xdf
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:82
    msr cpsr_c, r0
    8084:	e121f000 	msr	CPSR_c, r0
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:83
	add sp, r4, #0x5000
    8088:	e284da05 	add	sp, r4, #20480	; 0x5000
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:86

	;@ zapneme nezarovnany pristup do pameti (nemusi byt zadouci, ale pro nase potreby je to v poradku)
	mrc p15, #0, r4, c1, c0, #0
    808c:	ee114f10 	mrc	15, 0, r4, cr1, cr0, {0}
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:87
	orr r4, #0x400000
    8090:	e3844501 	orr	r4, r4, #4194304	; 0x400000
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:88
	mcr p15, #0, r4, c1, c0, #0
    8094:	ee014f10 	mcr	15, 0, r4, cr1, cr0, {0}
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:90

	bl _c_startup			;@ C startup kod (inicializace prostredi)
    8098:	eb000901 	bl	a4a4 <_c_startup>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:91
	bl _cpp_startup			;@ C++ startup kod (volani globalnich konstruktoru, ...)
    809c:	eb00091a 	bl	a50c <_cpp_startup>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:92
	bl _kernel_main			;@ skocime do hlavniho kodu jadra (v C)
    80a0:	eb000549 	bl	95cc <_kernel_main>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:93
	bl _cpp_shutdown		;@ C++ shutdown kod (volani globalnich destruktoru, ...)
    80a4:	eb00092e 	bl	a564 <_cpp_shutdown>

000080a8 <hang>:
hang():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:95
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
    8694:	0000aca0 	andeq	sl, r0, r0, lsr #25

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
    8aa8:	0000acbc 			; <UNDEFINED> instruction: 0x0000acbc

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
    8b04:	0000aad0 	ldrdeq	sl, [r0], -r0
    8b08:	0000aad8 	ldrdeq	sl, [r0], -r8

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
    8c74:	0000aae0 	andeq	sl, r0, r0, ror #21

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
    8ccc:	0000aca4 	andeq	sl, r0, r4, lsr #25

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
    9154:	0000accc 	andeq	sl, r0, ip, asr #25

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
    91b8:	0000accc 	andeq	sl, r0, ip, asr #25

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
    93b0:	0000acd4 	ldrdeq	sl, [r0], -r4

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
    93dc:	eb00033a 	bl	a0cc <_ZN16CProcess_Manager8ScheduleEv>
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
    9420:	0000bce0 	andeq	fp, r0, r0, ror #25
    9424:	0000acd8 	ldrdeq	sl, [r0], -r8
    9428:	0000aca0 	andeq	sl, r0, r0, lsr #25

0000942c <Process_1>:
Process_1():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:32

extern "C" void Process_1()
{
    942c:	e92d4800 	push	{fp, lr}
    9430:	e28db004 	add	fp, sp, #4
    9434:	e24dd008 	sub	sp, sp, #8
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:35
	volatile int i;

	sMonitor << "Process 1\n";
    9438:	e59f104c 	ldr	r1, [pc, #76]	; 948c <Process_1+0x60>
    943c:	e59f004c 	ldr	r0, [pc, #76]	; 9490 <Process_1+0x64>
    9440:	ebfffd59 	bl	89ac <_ZN8CMonitorlsEPKc>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:39

	while (true)
	{
		disable_irq();
    9444:	eb000407 	bl	a468 <disable_irq>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:40
		sMonitor << '1';
    9448:	e3a01031 	mov	r1, #49	; 0x31
    944c:	e59f003c 	ldr	r0, [pc, #60]	; 9490 <Process_1+0x64>
    9450:	ebfffd2b 	bl	8904 <_ZN8CMonitorlsEc>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:41
		enable_irq();
    9454:	eb0003fe 	bl	a454 <enable_irq>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:43

		for (i = 0; i < 0x200; i++)
    9458:	e3a03000 	mov	r3, #0
    945c:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:43 (discriminator 3)
    9460:	e51b3008 	ldr	r3, [fp, #-8]
    9464:	e3530c02 	cmp	r3, #512	; 0x200
    9468:	b3a03001 	movlt	r3, #1
    946c:	a3a03000 	movge	r3, #0
    9470:	e6ef3073 	uxtb	r3, r3
    9474:	e3530000 	cmp	r3, #0
    9478:	0afffff1 	beq	9444 <Process_1+0x18>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:43 (discriminator 2)
    947c:	e51b3008 	ldr	r3, [fp, #-8]
    9480:	e2833001 	add	r3, r3, #1
    9484:	e50b3008 	str	r3, [fp, #-8]
    9488:	eafffff4 	b	9460 <Process_1+0x34>
    948c:	0000ab60 	andeq	sl, r0, r0, ror #22
    9490:	0000aca4 	andeq	sl, r0, r4, lsr #25

00009494 <Process_2>:
Process_2():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:49
			;
	}
}

extern "C" void Process_2()
{
    9494:	e92d4800 	push	{fp, lr}
    9498:	e28db004 	add	fp, sp, #4
    949c:	e24dd008 	sub	sp, sp, #8
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:52
	volatile int i;

	sMonitor << "Process 2\n";
    94a0:	e59f104c 	ldr	r1, [pc, #76]	; 94f4 <Process_2+0x60>
    94a4:	e59f004c 	ldr	r0, [pc, #76]	; 94f8 <Process_2+0x64>
    94a8:	ebfffd3f 	bl	89ac <_ZN8CMonitorlsEPKc>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:56

	while (true)
	{
		disable_irq();
    94ac:	eb0003ed 	bl	a468 <disable_irq>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:57
		sMonitor << '2';
    94b0:	e3a01032 	mov	r1, #50	; 0x32
    94b4:	e59f003c 	ldr	r0, [pc, #60]	; 94f8 <Process_2+0x64>
    94b8:	ebfffd11 	bl	8904 <_ZN8CMonitorlsEc>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:58
		enable_irq();
    94bc:	eb0003e4 	bl	a454 <enable_irq>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:60

		for (i = 0; i < 0x200; i++)
    94c0:	e3a03000 	mov	r3, #0
    94c4:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:60 (discriminator 3)
    94c8:	e51b3008 	ldr	r3, [fp, #-8]
    94cc:	e3530c02 	cmp	r3, #512	; 0x200
    94d0:	b3a03001 	movlt	r3, #1
    94d4:	a3a03000 	movge	r3, #0
    94d8:	e6ef3073 	uxtb	r3, r3
    94dc:	e3530000 	cmp	r3, #0
    94e0:	0afffff1 	beq	94ac <Process_2+0x18>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:60 (discriminator 2)
    94e4:	e51b3008 	ldr	r3, [fp, #-8]
    94e8:	e2833001 	add	r3, r3, #1
    94ec:	e50b3008 	str	r3, [fp, #-8]
    94f0:	eafffff4 	b	94c8 <Process_2+0x34>
    94f4:	0000ab6c 	andeq	sl, r0, ip, ror #22
    94f8:	0000aca4 	andeq	sl, r0, r4, lsr #25

000094fc <Process_3>:
Process_3():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:66
			;
	}
}

extern "C" void Process_3()
{
    94fc:	e92d4800 	push	{fp, lr}
    9500:	e28db004 	add	fp, sp, #4
    9504:	e24dd008 	sub	sp, sp, #8
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:69
	volatile int i;

	sMonitor << "Process 3\n";
    9508:	e59f104c 	ldr	r1, [pc, #76]	; 955c <Process_3+0x60>
    950c:	e59f004c 	ldr	r0, [pc, #76]	; 9560 <Process_3+0x64>
    9510:	ebfffd25 	bl	89ac <_ZN8CMonitorlsEPKc>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:73

	while (true)
	{
		disable_irq();
    9514:	eb0003d3 	bl	a468 <disable_irq>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:74
		sMonitor << '3';
    9518:	e3a01033 	mov	r1, #51	; 0x33
    951c:	e59f003c 	ldr	r0, [pc, #60]	; 9560 <Process_3+0x64>
    9520:	ebfffcf7 	bl	8904 <_ZN8CMonitorlsEc>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:75
		enable_irq();
    9524:	eb0003ca 	bl	a454 <enable_irq>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:77

		for (i = 0; i < 0x200; i++)
    9528:	e3a03000 	mov	r3, #0
    952c:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:77 (discriminator 3)
    9530:	e51b3008 	ldr	r3, [fp, #-8]
    9534:	e3530c02 	cmp	r3, #512	; 0x200
    9538:	b3a03001 	movlt	r3, #1
    953c:	a3a03000 	movge	r3, #0
    9540:	e6ef3073 	uxtb	r3, r3
    9544:	e3530000 	cmp	r3, #0
    9548:	0afffff1 	beq	9514 <Process_3+0x18>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:77 (discriminator 2)
    954c:	e51b3008 	ldr	r3, [fp, #-8]
    9550:	e2833001 	add	r3, r3, #1
    9554:	e50b3008 	str	r3, [fp, #-8]
    9558:	eafffff4 	b	9530 <Process_3+0x34>
    955c:	0000ab78 	andeq	sl, r0, r8, ror fp
    9560:	0000aca4 	andeq	sl, r0, r4, lsr #25

00009564 <Process_4>:
Process_4():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:83
			;
	}
}

extern "C" void Process_4()
{
    9564:	e92d4800 	push	{fp, lr}
    9568:	e28db004 	add	fp, sp, #4
    956c:	e24dd008 	sub	sp, sp, #8
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:86
	volatile int i;

	sMonitor << "Process 4\n";
    9570:	e59f104c 	ldr	r1, [pc, #76]	; 95c4 <Process_4+0x60>
    9574:	e59f004c 	ldr	r0, [pc, #76]	; 95c8 <Process_4+0x64>
    9578:	ebfffd0b 	bl	89ac <_ZN8CMonitorlsEPKc>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:90

	while (true)
	{
		disable_irq();
    957c:	eb0003b9 	bl	a468 <disable_irq>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:91
		sMonitor << '4';
    9580:	e3a01034 	mov	r1, #52	; 0x34
    9584:	e59f003c 	ldr	r0, [pc, #60]	; 95c8 <Process_4+0x64>
    9588:	ebfffcdd 	bl	8904 <_ZN8CMonitorlsEc>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:92
		enable_irq();
    958c:	eb0003b0 	bl	a454 <enable_irq>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:94

		for (i = 0; i < 0x200; i++)
    9590:	e3a03000 	mov	r3, #0
    9594:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:94 (discriminator 3)
    9598:	e51b3008 	ldr	r3, [fp, #-8]
    959c:	e3530c02 	cmp	r3, #512	; 0x200
    95a0:	b3a03001 	movlt	r3, #1
    95a4:	a3a03000 	movge	r3, #0
    95a8:	e6ef3073 	uxtb	r3, r3
    95ac:	e3530000 	cmp	r3, #0
    95b0:	0afffff1 	beq	957c <Process_4+0x18>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:94 (discriminator 2)
    95b4:	e51b3008 	ldr	r3, [fp, #-8]
    95b8:	e2833001 	add	r3, r3, #1
    95bc:	e50b3008 	str	r3, [fp, #-8]
    95c0:	eafffff4 	b	9598 <Process_4+0x34>
    95c4:	0000ab84 	andeq	sl, r0, r4, lsl #23
    95c8:	0000aca4 	andeq	sl, r0, r4, lsr #25

000095cc <_kernel_main>:
_kernel_main():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:100
			;
	}
}

extern "C" int _kernel_main(void)
{
    95cc:	e92d4800 	push	{fp, lr}
    95d0:	e28db004 	add	fp, sp, #4
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:102
	// nastavime ACT LED pin na vystupni
	sGPIO.Set_GPIO_Function(ACT_Pin, NGPIO_Function::Output);
    95d4:	e3a02001 	mov	r2, #1
    95d8:	e3a0102f 	mov	r1, #47	; 0x2f
    95dc:	e59f0098 	ldr	r0, [pc, #152]	; 967c <_kernel_main+0xb0>
    95e0:	ebfffb71 	bl	83ac <_ZN13CGPIO_Handler17Set_GPIO_FunctionEj14NGPIO_Function>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:103
	sGPIO.Set_Output(ACT_Pin, false);
    95e4:	e3a02000 	mov	r2, #0
    95e8:	e3a0102f 	mov	r1, #47	; 0x2f
    95ec:	e59f0088 	ldr	r0, [pc, #136]	; 967c <_kernel_main+0xb0>
    95f0:	ebfffbbc 	bl	84e8 <_ZN13CGPIO_Handler10Set_OutputEjb>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:106

	// vypiseme ladici hlasku
	sMonitor.Clear();
    95f4:	e59f0084 	ldr	r0, [pc, #132]	; 9680 <_kernel_main+0xb4>
    95f8:	ebfffc4b 	bl	872c <_ZN8CMonitor5ClearEv>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:107
	sMonitor << "Welcome to KIV/OS RPiOS kernel\n";
    95fc:	e59f1080 	ldr	r1, [pc, #128]	; 9684 <_kernel_main+0xb8>
    9600:	e59f0078 	ldr	r0, [pc, #120]	; 9680 <_kernel_main+0xb4>
    9604:	ebfffce8 	bl	89ac <_ZN8CMonitorlsEPKc>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:111

	// sProcessMgr.Create_Main_Process();

	sProcessMgr.Create_Process(reinterpret_cast<unsigned long>(&Process_1));
    9608:	e59f3078 	ldr	r3, [pc, #120]	; 9688 <_kernel_main+0xbc>
    960c:	e1a01003 	mov	r1, r3
    9610:	e59f0074 	ldr	r0, [pc, #116]	; 968c <_kernel_main+0xc0>
    9614:	eb00025f 	bl	9f98 <_ZN16CProcess_Manager14Create_ProcessEm>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:112
	sProcessMgr.Create_Process(reinterpret_cast<unsigned long>(&Process_2));
    9618:	e59f3070 	ldr	r3, [pc, #112]	; 9690 <_kernel_main+0xc4>
    961c:	e1a01003 	mov	r1, r3
    9620:	e59f0064 	ldr	r0, [pc, #100]	; 968c <_kernel_main+0xc0>
    9624:	eb00025b 	bl	9f98 <_ZN16CProcess_Manager14Create_ProcessEm>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:113
	sProcessMgr.Create_Process(reinterpret_cast<unsigned long>(&Process_3));
    9628:	e59f3064 	ldr	r3, [pc, #100]	; 9694 <_kernel_main+0xc8>
    962c:	e1a01003 	mov	r1, r3
    9630:	e59f0054 	ldr	r0, [pc, #84]	; 968c <_kernel_main+0xc0>
    9634:	eb000257 	bl	9f98 <_ZN16CProcess_Manager14Create_ProcessEm>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:114
	sProcessMgr.Create_Process(reinterpret_cast<unsigned long>(&Process_4));
    9638:	e59f3058 	ldr	r3, [pc, #88]	; 9698 <_kernel_main+0xcc>
    963c:	e1a01003 	mov	r1, r3
    9640:	e59f0044 	ldr	r0, [pc, #68]	; 968c <_kernel_main+0xc0>
    9644:	eb000253 	bl	9f98 <_ZN16CProcess_Manager14Create_ProcessEm>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:117

	// zatim zakazeme IRQ casovace
	sInterruptCtl.Disable_Basic_IRQ(hal::IRQ_Basic_Source::Timer);
    9648:	e3a01000 	mov	r1, #0
    964c:	e59f0048 	ldr	r0, [pc, #72]	; 969c <_kernel_main+0xd0>
    9650:	ebffff09 	bl	927c <_ZN21CInterrupt_Controller17Disable_Basic_IRQEN3hal16IRQ_Basic_SourceE>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:120

	// nastavime casovac - v callbacku se provadi planovani procesu
	sTimer.Enable(Timer_Callback, 0x20, NTimer_Prescaler::Prescaler_256);
    9654:	e3a03002 	mov	r3, #2
    9658:	e3a02020 	mov	r2, #32
    965c:	e59f103c 	ldr	r1, [pc, #60]	; 96a0 <_kernel_main+0xd4>
    9660:	e59f003c 	ldr	r0, [pc, #60]	; 96a4 <_kernel_main+0xd8>
    9664:	ebfffe3c 	bl	8f5c <_ZN6CTimer6EnableEPFvvEj16NTimer_Prescaler>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:123

	// povolime IRQ casovace
	sInterruptCtl.Enable_Basic_IRQ(hal::IRQ_Basic_Source::Timer);
    9668:	e3a01000 	mov	r1, #0
    966c:	e59f0028 	ldr	r0, [pc, #40]	; 969c <_kernel_main+0xd0>
    9670:	ebfffef0 	bl	9238 <_ZN21CInterrupt_Controller16Enable_Basic_IRQEN3hal16IRQ_Basic_SourceE>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:125

	enable_irq();
    9674:	eb000376 	bl	a454 <enable_irq>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:128 (discriminator 1)

	// nekonecna smycka - tadyodsud se CPU uz nedostane jinak, nez treba prerusenim
    while (1)
    9678:	eafffffe 	b	9678 <_kernel_main+0xac>
    967c:	0000aca0 	andeq	sl, r0, r0, lsr #25
    9680:	0000aca4 	andeq	sl, r0, r4, lsr #25
    9684:	0000ab90 	muleq	r0, r0, fp
    9688:	0000942c 	andeq	r9, r0, ip, lsr #8
    968c:	0000bce0 	andeq	fp, r0, r0, ror #25
    9690:	00009494 	muleq	r0, r4, r4
    9694:	000094fc 	strdeq	r9, [r0], -ip
    9698:	00009564 	andeq	r9, r0, r4, ror #10
    969c:	0000acd4 	ldrdeq	sl, [r0], -r4
    96a0:	000093d0 	ldrdeq	r9, [r0], -r0
    96a4:	0000accc 	andeq	sl, r0, ip, asr #25

000096a8 <_ZN20CKernel_Heap_ManagerC1Ev>:
_ZN20CKernel_Heap_ManagerC2Ev():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:6
#include <memory/kernel_heap.h>
#include <memory/pages.h>

CKernel_Heap_Manager sKernelMem;

CKernel_Heap_Manager::CKernel_Heap_Manager()
    96a8:	e92d4800 	push	{fp, lr}
    96ac:	e28db004 	add	fp, sp, #4
    96b0:	e24dd008 	sub	sp, sp, #8
    96b4:	e50b0008 	str	r0, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:9
{
    // na zacatku si alokujeme jednu stranku dopredu, protoze je temer jiste, ze budeme docela brzy potrebovat nejakou pamet
    mFirst = Alloc_Next_Page();
    96b8:	e51b0008 	ldr	r0, [fp, #-8]
    96bc:	eb000006 	bl	96dc <_ZN20CKernel_Heap_Manager15Alloc_Next_PageEv>
    96c0:	e1a02000 	mov	r2, r0
    96c4:	e51b3008 	ldr	r3, [fp, #-8]
    96c8:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:10
}
    96cc:	e51b3008 	ldr	r3, [fp, #-8]
    96d0:	e1a00003 	mov	r0, r3
    96d4:	e24bd004 	sub	sp, fp, #4
    96d8:	e8bd8800 	pop	{fp, pc}

000096dc <_ZN20CKernel_Heap_Manager15Alloc_Next_PageEv>:
_ZN20CKernel_Heap_Manager15Alloc_Next_PageEv():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:13

TKernel_Heap_Chunk_Header* CKernel_Heap_Manager::Alloc_Next_Page()
{
    96dc:	e92d4800 	push	{fp, lr}
    96e0:	e28db004 	add	fp, sp, #4
    96e4:	e24dd010 	sub	sp, sp, #16
    96e8:	e50b0010 	str	r0, [fp, #-16]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:14
    TKernel_Heap_Chunk_Header* chunk = reinterpret_cast<TKernel_Heap_Chunk_Header*>(sPage_Manager.Alloc_Page());
    96ec:	e59f0048 	ldr	r0, [pc, #72]	; 973c <_ZN20CKernel_Heap_Manager15Alloc_Next_PageEv+0x60>
    96f0:	eb000165 	bl	9c8c <_ZN13CPage_Manager10Alloc_PageEv>
    96f4:	e1a03000 	mov	r3, r0
    96f8:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:15
    chunk->prev = nullptr;
    96fc:	e51b3008 	ldr	r3, [fp, #-8]
    9700:	e3a02000 	mov	r2, #0
    9704:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:16
    chunk->next = nullptr;
    9708:	e51b3008 	ldr	r3, [fp, #-8]
    970c:	e3a02000 	mov	r2, #0
    9710:	e5832004 	str	r2, [r3, #4]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:17
    chunk->size = mem::PageSize - sizeof(TKernel_Heap_Chunk_Header); // z alokovane stranky musime ubrat velikost hlavicky
    9714:	e51b3008 	ldr	r3, [fp, #-8]
    9718:	e59f2020 	ldr	r2, [pc, #32]	; 9740 <_ZN20CKernel_Heap_Manager15Alloc_Next_PageEv+0x64>
    971c:	e5832008 	str	r2, [r3, #8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:18
    chunk->is_free = true;
    9720:	e51b3008 	ldr	r3, [fp, #-8]
    9724:	e3a02001 	mov	r2, #1
    9728:	e5c3200c 	strb	r2, [r3, #12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:20

    return chunk;
    972c:	e51b3008 	ldr	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:21
}
    9730:	e1a00003 	mov	r0, r3
    9734:	e24bd004 	sub	sp, fp, #4
    9738:	e8bd8800 	pop	{fp, pc}
    973c:	0000ace0 	andeq	sl, r0, r0, ror #25
    9740:	00003ff0 	strdeq	r3, [r0], -r0

00009744 <_ZN20CKernel_Heap_Manager5AllocEj>:
_ZN20CKernel_Heap_Manager5AllocEj():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:24

void* CKernel_Heap_Manager::Alloc(uint32_t size)
{
    9744:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9748:	e28db000 	add	fp, sp, #0
    974c:	e24dd014 	sub	sp, sp, #20
    9750:	e50b0010 	str	r0, [fp, #-16]
    9754:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:25
    TKernel_Heap_Chunk_Header* chunk = mFirst;
    9758:	e51b3010 	ldr	r3, [fp, #-16]
    975c:	e5933000 	ldr	r3, [r3]
    9760:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:28

    // potrebujeme najit prvni blok, ktery je volny a zaroven alespon tak velky, jak potrebujeme (pro ted pouzivame proste first-fit)
    while (chunk != nullptr && (!chunk->is_free || chunk->size < size))
    9764:	e51b3008 	ldr	r3, [fp, #-8]
    9768:	e3530000 	cmp	r3, #0
    976c:	0a00000c 	beq	97a4 <_ZN20CKernel_Heap_Manager5AllocEj+0x60>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:28 (discriminator 1)
    9770:	e51b3008 	ldr	r3, [fp, #-8]
    9774:	e5d3300c 	ldrb	r3, [r3, #12]
    9778:	e3530000 	cmp	r3, #0
    977c:	0a000004 	beq	9794 <_ZN20CKernel_Heap_Manager5AllocEj+0x50>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:28 (discriminator 2)
    9780:	e51b3008 	ldr	r3, [fp, #-8]
    9784:	e5933008 	ldr	r3, [r3, #8]
    9788:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    978c:	e1520003 	cmp	r2, r3
    9790:	9a000003 	bls	97a4 <_ZN20CKernel_Heap_Manager5AllocEj+0x60>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:30
    {
        chunk = chunk->next;
    9794:	e51b3008 	ldr	r3, [fp, #-8]
    9798:	e5933004 	ldr	r3, [r3, #4]
    979c:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:28
    while (chunk != nullptr && (!chunk->is_free || chunk->size < size))
    97a0:	eaffffef 	b	9764 <_ZN20CKernel_Heap_Manager5AllocEj+0x20>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:33
    }

    if (!chunk)
    97a4:	e51b3008 	ldr	r3, [fp, #-8]
    97a8:	e3530000 	cmp	r3, #0
    97ac:	1a000001 	bne	97b8 <_ZN20CKernel_Heap_Manager5AllocEj+0x74>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:37
    {
        // TODO: tady by se hodila alokace dalsi stranky (Alloc_Next_Page) a navazani na predchozi chunk
        // pro ted nechme byt, vic jak 4kB snad v tomto prikladu potrebovat nebudeme
        return nullptr;
    97b0:	e3a03000 	mov	r3, #0
    97b4:	ea000031 	b	9880 <_ZN20CKernel_Heap_Manager5AllocEj+0x13c>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:42
    }

    // pokud je pozadovane misto uz tak velke, jak potrebujeme, tak je to snadne - jen ho oznacime za alokovane a vratime
    // vzdy zarovname tak, aby se do dalsiho potencialniho bloku vesla alespon hlavicka dalsiho bloku a nejaky overlap (alespon jeden bajt)
    if (chunk->size >= size && chunk->size <= size + sizeof(TKernel_Heap_Chunk_Header) + 1)
    97b8:	e51b3008 	ldr	r3, [fp, #-8]
    97bc:	e5933008 	ldr	r3, [r3, #8]
    97c0:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    97c4:	e1520003 	cmp	r2, r3
    97c8:	8a00000b 	bhi	97fc <_ZN20CKernel_Heap_Manager5AllocEj+0xb8>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:42 (discriminator 1)
    97cc:	e51b3008 	ldr	r3, [fp, #-8]
    97d0:	e5932008 	ldr	r2, [r3, #8]
    97d4:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    97d8:	e2833011 	add	r3, r3, #17
    97dc:	e1520003 	cmp	r2, r3
    97e0:	8a000005 	bhi	97fc <_ZN20CKernel_Heap_Manager5AllocEj+0xb8>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:44
    {
        chunk->is_free = false;
    97e4:	e51b3008 	ldr	r3, [fp, #-8]
    97e8:	e3a02000 	mov	r2, #0
    97ec:	e5c3200c 	strb	r2, [r3, #12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:45
        return reinterpret_cast<uint8_t*>(chunk) + sizeof(TKernel_Heap_Chunk_Header); // vracime az pouzitelnou pamet, tedy to co nasleduje po hlavicce
    97f0:	e51b3008 	ldr	r3, [fp, #-8]
    97f4:	e2833010 	add	r3, r3, #16
    97f8:	ea000020 	b	9880 <_ZN20CKernel_Heap_Manager5AllocEj+0x13c>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:51
    }

    // pokud je vetsi, musime blok rozdelit
    // to, ze se tam vejde dalsi hlavicka jsme garantovali prekryvem, viz vyse

    TKernel_Heap_Chunk_Header* hdr2 = reinterpret_cast<TKernel_Heap_Chunk_Header*>(reinterpret_cast<uint8_t*>(chunk) + sizeof(TKernel_Heap_Chunk_Header) + size);
    97fc:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9800:	e2833010 	add	r3, r3, #16
    9804:	e51b2008 	ldr	r2, [fp, #-8]
    9808:	e0823003 	add	r3, r2, r3
    980c:	e50b300c 	str	r3, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:53

    hdr2->size = chunk->size - size - sizeof(TKernel_Heap_Chunk_Header);
    9810:	e51b3008 	ldr	r3, [fp, #-8]
    9814:	e5932008 	ldr	r2, [r3, #8]
    9818:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    981c:	e0423003 	sub	r3, r2, r3
    9820:	e2432010 	sub	r2, r3, #16
    9824:	e51b300c 	ldr	r3, [fp, #-12]
    9828:	e5832008 	str	r2, [r3, #8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:55

    hdr2->prev = chunk;
    982c:	e51b300c 	ldr	r3, [fp, #-12]
    9830:	e51b2008 	ldr	r2, [fp, #-8]
    9834:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:56
    hdr2->next = chunk->next;
    9838:	e51b3008 	ldr	r3, [fp, #-8]
    983c:	e5932004 	ldr	r2, [r3, #4]
    9840:	e51b300c 	ldr	r3, [fp, #-12]
    9844:	e5832004 	str	r2, [r3, #4]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:57
    hdr2->is_free = true;
    9848:	e51b300c 	ldr	r3, [fp, #-12]
    984c:	e3a02001 	mov	r2, #1
    9850:	e5c3200c 	strb	r2, [r3, #12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:58
    chunk->next = hdr2;
    9854:	e51b3008 	ldr	r3, [fp, #-8]
    9858:	e51b200c 	ldr	r2, [fp, #-12]
    985c:	e5832004 	str	r2, [r3, #4]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:60

    chunk->size = size;
    9860:	e51b3008 	ldr	r3, [fp, #-8]
    9864:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    9868:	e5832008 	str	r2, [r3, #8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:61
    chunk->is_free = false;
    986c:	e51b3008 	ldr	r3, [fp, #-8]
    9870:	e3a02000 	mov	r2, #0
    9874:	e5c3200c 	strb	r2, [r3, #12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:63

    return reinterpret_cast<uint8_t*>(chunk) + sizeof(TKernel_Heap_Chunk_Header); // vracime az pouzitelnou pamet, tedy to co nasleduje po hlavicce
    9878:	e51b3008 	ldr	r3, [fp, #-8]
    987c:	e2833010 	add	r3, r3, #16
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:64
}
    9880:	e1a00003 	mov	r0, r3
    9884:	e28bd000 	add	sp, fp, #0
    9888:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    988c:	e12fff1e 	bx	lr

00009890 <_ZN20CKernel_Heap_Manager4FreeEPv>:
_ZN20CKernel_Heap_Manager4FreeEPv():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:67

void CKernel_Heap_Manager::Free(void* mem)
{
    9890:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9894:	e28db000 	add	fp, sp, #0
    9898:	e24dd014 	sub	sp, sp, #20
    989c:	e50b0010 	str	r0, [fp, #-16]
    98a0:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:68
    TKernel_Heap_Chunk_Header* chunk = reinterpret_cast<TKernel_Heap_Chunk_Header*>(reinterpret_cast<uint8_t*>(mem) - sizeof(TKernel_Heap_Chunk_Header));
    98a4:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    98a8:	e2433010 	sub	r3, r3, #16
    98ac:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:70

    chunk->is_free = true;
    98b0:	e51b3008 	ldr	r3, [fp, #-8]
    98b4:	e3a02001 	mov	r2, #1
    98b8:	e5c3200c 	strb	r2, [r3, #12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:73

    // pokud je dalsi blok volny, spojme tento a dalsi blok do jednoho
    if (chunk->next && chunk->next->is_free)
    98bc:	e51b3008 	ldr	r3, [fp, #-8]
    98c0:	e5933004 	ldr	r3, [r3, #4]
    98c4:	e3530000 	cmp	r3, #0
    98c8:	0a000016 	beq	9928 <_ZN20CKernel_Heap_Manager4FreeEPv+0x98>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:73 (discriminator 1)
    98cc:	e51b3008 	ldr	r3, [fp, #-8]
    98d0:	e5933004 	ldr	r3, [r3, #4]
    98d4:	e5d3300c 	ldrb	r3, [r3, #12]
    98d8:	e3530000 	cmp	r3, #0
    98dc:	0a000011 	beq	9928 <_ZN20CKernel_Heap_Manager4FreeEPv+0x98>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:75
    {
        chunk->size += chunk->next->size + sizeof(TKernel_Heap_Chunk_Header);   // zvetsit soucasny
    98e0:	e51b3008 	ldr	r3, [fp, #-8]
    98e4:	e5932008 	ldr	r2, [r3, #8]
    98e8:	e51b3008 	ldr	r3, [fp, #-8]
    98ec:	e5933004 	ldr	r3, [r3, #4]
    98f0:	e5933008 	ldr	r3, [r3, #8]
    98f4:	e0823003 	add	r3, r2, r3
    98f8:	e2832010 	add	r2, r3, #16
    98fc:	e51b3008 	ldr	r3, [fp, #-8]
    9900:	e5832008 	str	r2, [r3, #8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:76
        chunk->next = chunk->next->next;                                        // navazat nasledujici nasledujiciho jako dalsi
    9904:	e51b3008 	ldr	r3, [fp, #-8]
    9908:	e5933004 	ldr	r3, [r3, #4]
    990c:	e5932004 	ldr	r2, [r3, #4]
    9910:	e51b3008 	ldr	r3, [fp, #-8]
    9914:	e5832004 	str	r2, [r3, #4]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:77
        chunk->next->prev = chunk;                                              // nasledujicimu nastavit predchozi na sebe
    9918:	e51b3008 	ldr	r3, [fp, #-8]
    991c:	e5933004 	ldr	r3, [r3, #4]
    9920:	e51b2008 	ldr	r2, [fp, #-8]
    9924:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:81
    }

    // pokud je predchozi blok volny, spojme predchozi a tento blok do jednoho
    if (chunk->prev && chunk->prev->is_free)
    9928:	e51b3008 	ldr	r3, [fp, #-8]
    992c:	e5933000 	ldr	r3, [r3]
    9930:	e3530000 	cmp	r3, #0
    9934:	0a000018 	beq	999c <_ZN20CKernel_Heap_Manager4FreeEPv+0x10c>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:81 (discriminator 1)
    9938:	e51b3008 	ldr	r3, [fp, #-8]
    993c:	e5933000 	ldr	r3, [r3]
    9940:	e5d3300c 	ldrb	r3, [r3, #12]
    9944:	e3530000 	cmp	r3, #0
    9948:	0a000013 	beq	999c <_ZN20CKernel_Heap_Manager4FreeEPv+0x10c>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:83
    {
        chunk->prev->size += chunk->size + sizeof(TKernel_Heap_Chunk_Header);
    994c:	e51b3008 	ldr	r3, [fp, #-8]
    9950:	e5933000 	ldr	r3, [r3]
    9954:	e5932008 	ldr	r2, [r3, #8]
    9958:	e51b3008 	ldr	r3, [fp, #-8]
    995c:	e5933008 	ldr	r3, [r3, #8]
    9960:	e0822003 	add	r2, r2, r3
    9964:	e51b3008 	ldr	r3, [fp, #-8]
    9968:	e5933000 	ldr	r3, [r3]
    996c:	e2822010 	add	r2, r2, #16
    9970:	e5832008 	str	r2, [r3, #8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:84
        chunk->prev->next = chunk->next;
    9974:	e51b3008 	ldr	r3, [fp, #-8]
    9978:	e5933000 	ldr	r3, [r3]
    997c:	e51b2008 	ldr	r2, [fp, #-8]
    9980:	e5922004 	ldr	r2, [r2, #4]
    9984:	e5832004 	str	r2, [r3, #4]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:85
        chunk->next->prev = chunk->prev;
    9988:	e51b3008 	ldr	r3, [fp, #-8]
    998c:	e5933004 	ldr	r3, [r3, #4]
    9990:	e51b2008 	ldr	r2, [fp, #-8]
    9994:	e5922000 	ldr	r2, [r2]
    9998:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:87
    }
    999c:	e320f000 	nop	{0}
    99a0:	e28bd000 	add	sp, fp, #0
    99a4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    99a8:	e12fff1e 	bx	lr

000099ac <_Z41__static_initialization_and_destruction_0ii>:
_Z41__static_initialization_and_destruction_0ii():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:87
    99ac:	e92d4800 	push	{fp, lr}
    99b0:	e28db004 	add	fp, sp, #4
    99b4:	e24dd008 	sub	sp, sp, #8
    99b8:	e50b0008 	str	r0, [fp, #-8]
    99bc:	e50b100c 	str	r1, [fp, #-12]
    99c0:	e51b3008 	ldr	r3, [fp, #-8]
    99c4:	e3530001 	cmp	r3, #1
    99c8:	1a000005 	bne	99e4 <_Z41__static_initialization_and_destruction_0ii+0x38>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:87 (discriminator 1)
    99cc:	e51b300c 	ldr	r3, [fp, #-12]
    99d0:	e59f2018 	ldr	r2, [pc, #24]	; 99f0 <_Z41__static_initialization_and_destruction_0ii+0x44>
    99d4:	e1530002 	cmp	r3, r2
    99d8:	1a000001 	bne	99e4 <_Z41__static_initialization_and_destruction_0ii+0x38>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:4
CKernel_Heap_Manager sKernelMem;
    99dc:	e59f0010 	ldr	r0, [pc, #16]	; 99f4 <_Z41__static_initialization_and_destruction_0ii+0x48>
    99e0:	ebffff30 	bl	96a8 <_ZN20CKernel_Heap_ManagerC1Ev>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:87
    99e4:	e320f000 	nop	{0}
    99e8:	e24bd004 	sub	sp, fp, #4
    99ec:	e8bd8800 	pop	{fp, pc}
    99f0:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>
    99f4:	0000acdc 	ldrdeq	sl, [r0], -ip

000099f8 <_GLOBAL__sub_I_sKernelMem>:
_GLOBAL__sub_I_sKernelMem():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:87
    99f8:	e92d4800 	push	{fp, lr}
    99fc:	e28db004 	add	fp, sp, #4
    9a00:	e59f1008 	ldr	r1, [pc, #8]	; 9a10 <_GLOBAL__sub_I_sKernelMem+0x18>
    9a04:	e3a00001 	mov	r0, #1
    9a08:	ebffffe7 	bl	99ac <_Z41__static_initialization_and_destruction_0ii>
    9a0c:	e8bd8800 	pop	{fp, pc}
    9a10:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>

00009a14 <_ZL11fast_dividejj>:
_ZL11fast_dividejj():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:5
#include <memory/pages.h>

CPage_Manager sPage_Manager;

static unsigned fast_divide(unsigned dividend, unsigned divisor) {
    9a14:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9a18:	e28db000 	add	fp, sp, #0
    9a1c:	e24dd014 	sub	sp, sp, #20
    9a20:	e50b0010 	str	r0, [fp, #-16]
    9a24:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:6
    unsigned quotient = 0;
    9a28:	e3a03000 	mov	r3, #0
    9a2c:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:7
    unsigned temp = divisor;
    9a30:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9a34:	e50b300c 	str	r3, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:10

    // Shift the divisor left until it's greater than or equal to the dividend
    while (temp <= dividend) {
    9a38:	e51b200c 	ldr	r2, [fp, #-12]
    9a3c:	e51b3010 	ldr	r3, [fp, #-16]
    9a40:	e1520003 	cmp	r2, r3
    9a44:	8a000003 	bhi	9a58 <_ZL11fast_dividejj+0x44>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:11
        temp <<= 1;
    9a48:	e51b300c 	ldr	r3, [fp, #-12]
    9a4c:	e1a03083 	lsl	r3, r3, #1
    9a50:	e50b300c 	str	r3, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:10
    while (temp <= dividend) {
    9a54:	eafffff7 	b	9a38 <_ZL11fast_dividejj+0x24>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:15
    }

    // Shift the result right and subtract the divisor repeatedly
    while (divisor <= temp) {
    9a58:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    9a5c:	e51b300c 	ldr	r3, [fp, #-12]
    9a60:	e1520003 	cmp	r2, r3
    9a64:	8a000011 	bhi	9ab0 <_ZL11fast_dividejj+0x9c>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:16
        quotient <<= 1;
    9a68:	e51b3008 	ldr	r3, [fp, #-8]
    9a6c:	e1a03083 	lsl	r3, r3, #1
    9a70:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:17
        if (dividend >= temp) {
    9a74:	e51b2010 	ldr	r2, [fp, #-16]
    9a78:	e51b300c 	ldr	r3, [fp, #-12]
    9a7c:	e1520003 	cmp	r2, r3
    9a80:	3a000006 	bcc	9aa0 <_ZL11fast_dividejj+0x8c>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:18
            dividend -= temp;
    9a84:	e51b2010 	ldr	r2, [fp, #-16]
    9a88:	e51b300c 	ldr	r3, [fp, #-12]
    9a8c:	e0423003 	sub	r3, r2, r3
    9a90:	e50b3010 	str	r3, [fp, #-16]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:19
            quotient |= 1;
    9a94:	e51b3008 	ldr	r3, [fp, #-8]
    9a98:	e3833001 	orr	r3, r3, #1
    9a9c:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:21
        }
        temp >>= 1;
    9aa0:	e51b300c 	ldr	r3, [fp, #-12]
    9aa4:	e1a030a3 	lsr	r3, r3, #1
    9aa8:	e50b300c 	str	r3, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:15
    while (divisor <= temp) {
    9aac:	eaffffe9 	b	9a58 <_ZL11fast_dividejj+0x44>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:24
    }

    return quotient;
    9ab0:	e51b3008 	ldr	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:25
}
    9ab4:	e1a00003 	mov	r0, r3
    9ab8:	e28bd000 	add	sp, fp, #0
    9abc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9ac0:	e12fff1e 	bx	lr

00009ac4 <_Z12fast_modulusjj>:
_Z12fast_modulusjj():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:27

unsigned fast_modulus(unsigned dividend, unsigned divisor) {
    9ac4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9ac8:	e28db000 	add	fp, sp, #0
    9acc:	e24dd014 	sub	sp, sp, #20
    9ad0:	e50b0010 	str	r0, [fp, #-16]
    9ad4:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:28
    unsigned temp = divisor;
    9ad8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9adc:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:31

    // Shift the divisor left until it's greater than or equal to the dividend
    while (temp <= dividend) {
    9ae0:	e51b2008 	ldr	r2, [fp, #-8]
    9ae4:	e51b3010 	ldr	r3, [fp, #-16]
    9ae8:	e1520003 	cmp	r2, r3
    9aec:	8a000003 	bhi	9b00 <_Z12fast_modulusjj+0x3c>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:32
        temp <<= 1;
    9af0:	e51b3008 	ldr	r3, [fp, #-8]
    9af4:	e1a03083 	lsl	r3, r3, #1
    9af8:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:31
    while (temp <= dividend) {
    9afc:	eafffff7 	b	9ae0 <_Z12fast_modulusjj+0x1c>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:36
    }

    // Subtract the divisor repeatedly and shift it right until it's less than the original divisor
    while (divisor <= temp) {
    9b00:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    9b04:	e51b3008 	ldr	r3, [fp, #-8]
    9b08:	e1520003 	cmp	r2, r3
    9b0c:	8a00000b 	bhi	9b40 <_Z12fast_modulusjj+0x7c>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:37
        if (dividend >= temp) {
    9b10:	e51b2010 	ldr	r2, [fp, #-16]
    9b14:	e51b3008 	ldr	r3, [fp, #-8]
    9b18:	e1520003 	cmp	r2, r3
    9b1c:	3a000003 	bcc	9b30 <_Z12fast_modulusjj+0x6c>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:38
            dividend -= temp;
    9b20:	e51b2010 	ldr	r2, [fp, #-16]
    9b24:	e51b3008 	ldr	r3, [fp, #-8]
    9b28:	e0423003 	sub	r3, r2, r3
    9b2c:	e50b3010 	str	r3, [fp, #-16]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:40
        }
        temp >>= 1;
    9b30:	e51b3008 	ldr	r3, [fp, #-8]
    9b34:	e1a030a3 	lsr	r3, r3, #1
    9b38:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:36
    while (divisor <= temp) {
    9b3c:	eaffffef 	b	9b00 <_Z12fast_modulusjj+0x3c>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:43
    }

    return dividend;
    9b40:	e51b3010 	ldr	r3, [fp, #-16]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:44
}
    9b44:	e1a00003 	mov	r0, r3
    9b48:	e28bd000 	add	sp, fp, #0
    9b4c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9b50:	e12fff1e 	bx	lr

00009b54 <_ZN13CPage_ManagerC1Ev>:
_ZN13CPage_ManagerC2Ev():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:46

CPage_Manager::CPage_Manager()
    9b54:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9b58:	e28db000 	add	fp, sp, #0
    9b5c:	e24dd014 	sub	sp, sp, #20
    9b60:	e50b0010 	str	r0, [fp, #-16]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:49
{
    // zadna stranka neni alokovana
    for (int i = 0; i < sizeof(mPage_Bitmap); i++)
    9b64:	e3a03000 	mov	r3, #0
    9b68:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:49 (discriminator 3)
    9b6c:	e51b3008 	ldr	r3, [fp, #-8]
    9b70:	e59f203c 	ldr	r2, [pc, #60]	; 9bb4 <_ZN13CPage_ManagerC1Ev+0x60>
    9b74:	e1530002 	cmp	r3, r2
    9b78:	8a000008 	bhi	9ba0 <_ZN13CPage_ManagerC1Ev+0x4c>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:50 (discriminator 2)
        mPage_Bitmap[i] = 0;
    9b7c:	e51b2010 	ldr	r2, [fp, #-16]
    9b80:	e51b3008 	ldr	r3, [fp, #-8]
    9b84:	e0823003 	add	r3, r2, r3
    9b88:	e3a02000 	mov	r2, #0
    9b8c:	e5c32000 	strb	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:49 (discriminator 2)
    for (int i = 0; i < sizeof(mPage_Bitmap); i++)
    9b90:	e51b3008 	ldr	r3, [fp, #-8]
    9b94:	e2833001 	add	r3, r3, #1
    9b98:	e50b3008 	str	r3, [fp, #-8]
    9b9c:	eafffff2 	b	9b6c <_ZN13CPage_ManagerC1Ev+0x18>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:53

    // nutno dodat, ze strankovatelna pamet implicitne nezahrnuje pamet, kam se nahralo jadro
}
    9ba0:	e51b3010 	ldr	r3, [fp, #-16]
    9ba4:	e1a00003 	mov	r0, r3
    9ba8:	e28bd000 	add	sp, fp, #0
    9bac:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9bb0:	e12fff1e 	bx	lr
    9bb4:	00000ffe 	strdeq	r0, [r0], -lr

00009bb8 <_ZN13CPage_Manager4MarkEjb>:
_ZN13CPage_Manager4MarkEjb():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:56

void CPage_Manager::Mark(uint32_t page_idx, bool used)
{
    9bb8:	e92d4810 	push	{r4, fp, lr}
    9bbc:	e28db008 	add	fp, sp, #8
    9bc0:	e24dd014 	sub	sp, sp, #20
    9bc4:	e50b0010 	str	r0, [fp, #-16]
    9bc8:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    9bcc:	e1a03002 	mov	r3, r2
    9bd0:	e54b3015 	strb	r3, [fp, #-21]	; 0xffffffeb
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:57
    if (used)
    9bd4:	e55b3015 	ldrb	r3, [fp, #-21]	; 0xffffffeb
    9bd8:	e3530000 	cmp	r3, #0
    9bdc:	0a000013 	beq	9c30 <_ZN13CPage_Manager4MarkEjb+0x78>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:58
        mPage_Bitmap[fast_divide(page_idx, 8)] |= 1 << fast_modulus(page_idx, 8);
    9be0:	e3a01008 	mov	r1, #8
    9be4:	e51b0014 	ldr	r0, [fp, #-20]	; 0xffffffec
    9be8:	ebffffb5 	bl	9ac4 <_Z12fast_modulusjj>
    9bec:	e1a03000 	mov	r3, r0
    9bf0:	e3a02001 	mov	r2, #1
    9bf4:	e1a04312 	lsl	r4, r2, r3
    9bf8:	e3a01008 	mov	r1, #8
    9bfc:	e51b0014 	ldr	r0, [fp, #-20]	; 0xffffffec
    9c00:	ebffff83 	bl	9a14 <_ZL11fast_dividejj>
    9c04:	e1a03000 	mov	r3, r0
    9c08:	e51b2010 	ldr	r2, [fp, #-16]
    9c0c:	e7d22003 	ldrb	r2, [r2, r3]
    9c10:	e6af1072 	sxtb	r1, r2
    9c14:	e6af2074 	sxtb	r2, r4
    9c18:	e1812002 	orr	r2, r1, r2
    9c1c:	e6af2072 	sxtb	r2, r2
    9c20:	e6ef1072 	uxtb	r1, r2
    9c24:	e51b2010 	ldr	r2, [fp, #-16]
    9c28:	e7c21003 	strb	r1, [r2, r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:61
    else
        mPage_Bitmap[fast_divide(page_idx, 8)] &= ~(1 << fast_modulus(page_idx, 8));
}
    9c2c:	ea000013 	b	9c80 <_ZN13CPage_Manager4MarkEjb+0xc8>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:60
        mPage_Bitmap[fast_divide(page_idx, 8)] &= ~(1 << fast_modulus(page_idx, 8));
    9c30:	e3a01008 	mov	r1, #8
    9c34:	e51b0014 	ldr	r0, [fp, #-20]	; 0xffffffec
    9c38:	ebffffa1 	bl	9ac4 <_Z12fast_modulusjj>
    9c3c:	e1a03000 	mov	r3, r0
    9c40:	e3a02001 	mov	r2, #1
    9c44:	e1a03312 	lsl	r3, r2, r3
    9c48:	e1e04003 	mvn	r4, r3
    9c4c:	e3a01008 	mov	r1, #8
    9c50:	e51b0014 	ldr	r0, [fp, #-20]	; 0xffffffec
    9c54:	ebffff6e 	bl	9a14 <_ZL11fast_dividejj>
    9c58:	e1a03000 	mov	r3, r0
    9c5c:	e51b2010 	ldr	r2, [fp, #-16]
    9c60:	e7d22003 	ldrb	r2, [r2, r3]
    9c64:	e6af1072 	sxtb	r1, r2
    9c68:	e6af2074 	sxtb	r2, r4
    9c6c:	e0022001 	and	r2, r2, r1
    9c70:	e6af2072 	sxtb	r2, r2
    9c74:	e6ef1072 	uxtb	r1, r2
    9c78:	e51b2010 	ldr	r2, [fp, #-16]
    9c7c:	e7c21003 	strb	r1, [r2, r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:61
}
    9c80:	e320f000 	nop	{0}
    9c84:	e24bd008 	sub	sp, fp, #8
    9c88:	e8bd8810 	pop	{r4, fp, pc}

00009c8c <_ZN13CPage_Manager10Alloc_PageEv>:
_ZN13CPage_Manager10Alloc_PageEv():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:64

uint32_t CPage_Manager::Alloc_Page()
{
    9c8c:	e92d4800 	push	{fp, lr}
    9c90:	e28db004 	add	fp, sp, #4
    9c94:	e24dd018 	sub	sp, sp, #24
    9c98:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:71
    // to je samozrejme O(n) a pro prakticke pouziti ne uplne dobre, ale k tomuto problemu az jindy

    uint32_t i, j;

    // projdeme vsechny stranky
    for (i = 0; i < mem::PageCount; i++)
    9c9c:	e3a03000 	mov	r3, #0
    9ca0:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:71 (discriminator 1)
    9ca4:	e51b3008 	ldr	r3, [fp, #-8]
    9ca8:	e59f20c0 	ldr	r2, [pc, #192]	; 9d70 <_ZN13CPage_Manager10Alloc_PageEv+0xe4>
    9cac:	e1530002 	cmp	r3, r2
    9cb0:	8a00002a 	bhi	9d60 <_ZN13CPage_Manager10Alloc_PageEv+0xd4>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:74
    {
        // je v dane osmici volna nejaka stranka? (0xFF = vse obsazeno)
        if (mPage_Bitmap[i] != 0xFF)
    9cb4:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    9cb8:	e51b3008 	ldr	r3, [fp, #-8]
    9cbc:	e0823003 	add	r3, r2, r3
    9cc0:	e5d33000 	ldrb	r3, [r3]
    9cc4:	e35300ff 	cmp	r3, #255	; 0xff
    9cc8:	0a000020 	beq	9d50 <_ZN13CPage_Manager10Alloc_PageEv+0xc4>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:77
        {
            // projdeme vsechny bity a najdeme ten co je volny
            for (j = 0; j < 8; j++)
    9ccc:	e3a03000 	mov	r3, #0
    9cd0:	e50b300c 	str	r3, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:77 (discriminator 1)
    9cd4:	e51b300c 	ldr	r3, [fp, #-12]
    9cd8:	e3530007 	cmp	r3, #7
    9cdc:	8a00001b 	bhi	9d50 <_ZN13CPage_Manager10Alloc_PageEv+0xc4>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:79
            {
                if (((uint32_t)mPage_Bitmap[i] & (1 << j)) == 0)
    9ce0:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    9ce4:	e51b3008 	ldr	r3, [fp, #-8]
    9ce8:	e0823003 	add	r3, r2, r3
    9cec:	e5d33000 	ldrb	r3, [r3]
    9cf0:	e1a01003 	mov	r1, r3
    9cf4:	e3a02001 	mov	r2, #1
    9cf8:	e51b300c 	ldr	r3, [fp, #-12]
    9cfc:	e1a03312 	lsl	r3, r2, r3
    9d00:	e0033001 	and	r3, r3, r1
    9d04:	e3530000 	cmp	r3, #0
    9d08:	1a00000c 	bne	9d40 <_ZN13CPage_Manager10Alloc_PageEv+0xb4>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:82
                {
                    // oznacime 
                    const uint32_t page_idx = i*8 + j;
    9d0c:	e51b3008 	ldr	r3, [fp, #-8]
    9d10:	e1a03183 	lsl	r3, r3, #3
    9d14:	e51b200c 	ldr	r2, [fp, #-12]
    9d18:	e0823003 	add	r3, r2, r3
    9d1c:	e50b3010 	str	r3, [fp, #-16]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:83
                    Mark(page_idx, true);
    9d20:	e3a02001 	mov	r2, #1
    9d24:	e51b1010 	ldr	r1, [fp, #-16]
    9d28:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    9d2c:	ebffffa1 	bl	9bb8 <_ZN13CPage_Manager4MarkEjb>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:84
                    return mem::LowMemory + page_idx * mem::PageSize;
    9d30:	e51b3010 	ldr	r3, [fp, #-16]
    9d34:	e2833008 	add	r3, r3, #8
    9d38:	e1a03703 	lsl	r3, r3, #14
    9d3c:	ea000008 	b	9d64 <_ZN13CPage_Manager10Alloc_PageEv+0xd8>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:77 (discriminator 2)
            for (j = 0; j < 8; j++)
    9d40:	e51b300c 	ldr	r3, [fp, #-12]
    9d44:	e2833001 	add	r3, r3, #1
    9d48:	e50b300c 	str	r3, [fp, #-12]
    9d4c:	eaffffe0 	b	9cd4 <_ZN13CPage_Manager10Alloc_PageEv+0x48>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:71 (discriminator 2)
    for (i = 0; i < mem::PageCount; i++)
    9d50:	e51b3008 	ldr	r3, [fp, #-8]
    9d54:	e2833001 	add	r3, r3, #1
    9d58:	e50b3008 	str	r3, [fp, #-8]
    9d5c:	eaffffd0 	b	9ca4 <_ZN13CPage_Manager10Alloc_PageEv+0x18>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:90
                }
            }
        }
    }

    return 0;
    9d60:	e3a03000 	mov	r3, #0
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:91
}
    9d64:	e1a00003 	mov	r0, r3
    9d68:	e24bd004 	sub	sp, fp, #4
    9d6c:	e8bd8800 	pop	{fp, pc}
    9d70:	00007ff7 	strdeq	r7, [r0], -r7	; <UNPREDICTABLE>

00009d74 <_ZN13CPage_Manager9Free_PageEj>:
_ZN13CPage_Manager9Free_PageEj():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:94

void CPage_Manager::Free_Page(uint32_t fa)
{
    9d74:	e92d4800 	push	{fp, lr}
    9d78:	e28db004 	add	fp, sp, #4
    9d7c:	e24dd008 	sub	sp, sp, #8
    9d80:	e50b0008 	str	r0, [fp, #-8]
    9d84:	e50b100c 	str	r1, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:97
    // pro vyssi bezpecnost v nejakych safe systemech lze tady data stranky premazavat napr. nulami po dealokaci

    Mark(fa / mem::PageSize, false);
    9d88:	e51b300c 	ldr	r3, [fp, #-12]
    9d8c:	e1a03723 	lsr	r3, r3, #14
    9d90:	e3a02000 	mov	r2, #0
    9d94:	e1a01003 	mov	r1, r3
    9d98:	e51b0008 	ldr	r0, [fp, #-8]
    9d9c:	ebffff85 	bl	9bb8 <_ZN13CPage_Manager4MarkEjb>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:98
}
    9da0:	e320f000 	nop	{0}
    9da4:	e24bd004 	sub	sp, fp, #4
    9da8:	e8bd8800 	pop	{fp, pc}

00009dac <_Z41__static_initialization_and_destruction_0ii>:
_Z41__static_initialization_and_destruction_0ii():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:98
    9dac:	e92d4800 	push	{fp, lr}
    9db0:	e28db004 	add	fp, sp, #4
    9db4:	e24dd008 	sub	sp, sp, #8
    9db8:	e50b0008 	str	r0, [fp, #-8]
    9dbc:	e50b100c 	str	r1, [fp, #-12]
    9dc0:	e51b3008 	ldr	r3, [fp, #-8]
    9dc4:	e3530001 	cmp	r3, #1
    9dc8:	1a000005 	bne	9de4 <_Z41__static_initialization_and_destruction_0ii+0x38>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:98 (discriminator 1)
    9dcc:	e51b300c 	ldr	r3, [fp, #-12]
    9dd0:	e59f2018 	ldr	r2, [pc, #24]	; 9df0 <_Z41__static_initialization_and_destruction_0ii+0x44>
    9dd4:	e1530002 	cmp	r3, r2
    9dd8:	1a000001 	bne	9de4 <_Z41__static_initialization_and_destruction_0ii+0x38>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:3
CPage_Manager sPage_Manager;
    9ddc:	e59f0010 	ldr	r0, [pc, #16]	; 9df4 <_Z41__static_initialization_and_destruction_0ii+0x48>
    9de0:	ebffff5b 	bl	9b54 <_ZN13CPage_ManagerC1Ev>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:98
}
    9de4:	e320f000 	nop	{0}
    9de8:	e24bd004 	sub	sp, fp, #4
    9dec:	e8bd8800 	pop	{fp, pc}
    9df0:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>
    9df4:	0000ace0 	andeq	sl, r0, r0, ror #25

00009df8 <_GLOBAL__sub_I_sPage_Manager>:
_GLOBAL__sub_I_sPage_Manager():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:98
    9df8:	e92d4800 	push	{fp, lr}
    9dfc:	e28db004 	add	fp, sp, #4
    9e00:	e59f1008 	ldr	r1, [pc, #8]	; 9e10 <_GLOBAL__sub_I_sPage_Manager+0x18>
    9e04:	e3a00001 	mov	r0, #1
    9e08:	ebffffe7 	bl	9dac <_Z41__static_initialization_and_destruction_0ii>
    9e0c:	e8bd8800 	pop	{fp, pc}
    9e10:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>

00009e14 <_ZN16CProcess_ManagerC1Ev>:
_ZN16CProcess_ManagerC2Ev():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:18
    void context_switch_first(TCPU_Context* ctx_to, TCPU_Context* ctx_from);
};

CProcess_Manager sProcessMgr;

CProcess_Manager::CProcess_Manager()
    9e14:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9e18:	e28db000 	add	fp, sp, #0
    9e1c:	e24dd00c 	sub	sp, sp, #12
    9e20:	e50b0008 	str	r0, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:19
    : mLast_PID(0), mProcess_List_Head(nullptr), mCurrent_Task_Node(nullptr)
    9e24:	e51b3008 	ldr	r3, [fp, #-8]
    9e28:	e3a02000 	mov	r2, #0
    9e2c:	e5832000 	str	r2, [r3]
    9e30:	e51b3008 	ldr	r3, [fp, #-8]
    9e34:	e3a02000 	mov	r2, #0
    9e38:	e5832004 	str	r2, [r3, #4]
    9e3c:	e51b3008 	ldr	r3, [fp, #-8]
    9e40:	e3a02000 	mov	r2, #0
    9e44:	e5832008 	str	r2, [r3, #8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:22
{
    //
}
    9e48:	e51b3008 	ldr	r3, [fp, #-8]
    9e4c:	e1a00003 	mov	r0, r3
    9e50:	e28bd000 	add	sp, fp, #0
    9e54:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9e58:	e12fff1e 	bx	lr

00009e5c <_ZNK16CProcess_Manager19Get_Current_ProcessEv>:
_ZNK16CProcess_Manager19Get_Current_ProcessEv():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:25

TTask_Struct* CProcess_Manager::Get_Current_Process() const
{
    9e5c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9e60:	e28db000 	add	fp, sp, #0
    9e64:	e24dd00c 	sub	sp, sp, #12
    9e68:	e50b0008 	str	r0, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:26
    return mCurrent_Task_Node ? mCurrent_Task_Node->task : nullptr;
    9e6c:	e51b3008 	ldr	r3, [fp, #-8]
    9e70:	e5933008 	ldr	r3, [r3, #8]
    9e74:	e3530000 	cmp	r3, #0
    9e78:	0a000003 	beq	9e8c <_ZNK16CProcess_Manager19Get_Current_ProcessEv+0x30>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:26 (discriminator 1)
    9e7c:	e51b3008 	ldr	r3, [fp, #-8]
    9e80:	e5933008 	ldr	r3, [r3, #8]
    9e84:	e5933008 	ldr	r3, [r3, #8]
    9e88:	ea000000 	b	9e90 <_ZNK16CProcess_Manager19Get_Current_ProcessEv+0x34>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:26 (discriminator 2)
    9e8c:	e3a03000 	mov	r3, #0
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:27 (discriminator 5)
}
    9e90:	e1a00003 	mov	r0, r3
    9e94:	e28bd000 	add	sp, fp, #0
    9e98:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9e9c:	e12fff1e 	bx	lr

00009ea0 <_ZN16CProcess_Manager19Create_Main_ProcessEv>:
_ZN16CProcess_Manager19Create_Main_ProcessEv():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:30

void CProcess_Manager::Create_Main_Process()
{
    9ea0:	e92d4800 	push	{fp, lr}
    9ea4:	e28db004 	add	fp, sp, #4
    9ea8:	e24dd010 	sub	sp, sp, #16
    9eac:	e50b0010 	str	r0, [fp, #-16]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:31
    CProcess_List_Node* procnode = sKernelMem.Alloc<CProcess_List_Node>();
    9eb0:	e59f00dc 	ldr	r0, [pc, #220]	; 9f94 <_ZN16CProcess_Manager19Create_Main_ProcessEv+0xf4>
    9eb4:	eb000139 	bl	a3a0 <_ZN20CKernel_Heap_Manager5AllocI18CProcess_List_NodeEEPT_v>
    9eb8:	e1a03000 	mov	r3, r0
    9ebc:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:33

    procnode->next = mProcess_List_Head;
    9ec0:	e51b3010 	ldr	r3, [fp, #-16]
    9ec4:	e5932004 	ldr	r2, [r3, #4]
    9ec8:	e51b3008 	ldr	r3, [fp, #-8]
    9ecc:	e5832004 	str	r2, [r3, #4]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:34
    procnode->prev = nullptr;
    9ed0:	e51b3008 	ldr	r3, [fp, #-8]
    9ed4:	e3a02000 	mov	r2, #0
    9ed8:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:35
    if (mProcess_List_Head != nullptr)
    9edc:	e51b3010 	ldr	r3, [fp, #-16]
    9ee0:	e5933004 	ldr	r3, [r3, #4]
    9ee4:	e3530000 	cmp	r3, #0
    9ee8:	0a000004 	beq	9f00 <_ZN16CProcess_Manager19Create_Main_ProcessEv+0x60>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:37
    {
        mProcess_List_Head->prev = procnode;
    9eec:	e51b3010 	ldr	r3, [fp, #-16]
    9ef0:	e5933004 	ldr	r3, [r3, #4]
    9ef4:	e51b2008 	ldr	r2, [fp, #-8]
    9ef8:	e5832000 	str	r2, [r3]
    9efc:	ea000002 	b	9f0c <_ZN16CProcess_Manager19Create_Main_ProcessEv+0x6c>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:41
    }
    else
    {
        mProcess_List_Head = procnode;
    9f00:	e51b3010 	ldr	r3, [fp, #-16]
    9f04:	e51b2008 	ldr	r2, [fp, #-8]
    9f08:	e5832004 	str	r2, [r3, #4]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:44
    }

    procnode->task = sKernelMem.Alloc<TTask_Struct>();
    9f0c:	e59f0080 	ldr	r0, [pc, #128]	; 9f94 <_ZN16CProcess_Manager19Create_Main_ProcessEv+0xf4>
    9f10:	eb00012d 	bl	a3cc <_ZN20CKernel_Heap_Manager5AllocI12TTask_StructEEPT_v>
    9f14:	e1a02000 	mov	r2, r0
    9f18:	e51b3008 	ldr	r3, [fp, #-8]
    9f1c:	e5832008 	str	r2, [r3, #8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:46

    auto* task = procnode->task;
    9f20:	e51b3008 	ldr	r3, [fp, #-8]
    9f24:	e5933008 	ldr	r3, [r3, #8]
    9f28:	e50b300c 	str	r3, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:48

    task->pid = ++mLast_PID;
    9f2c:	e51b3010 	ldr	r3, [fp, #-16]
    9f30:	e5933000 	ldr	r3, [r3]
    9f34:	e2832001 	add	r2, r3, #1
    9f38:	e51b3010 	ldr	r3, [fp, #-16]
    9f3c:	e5832000 	str	r2, [r3]
    9f40:	e51b3010 	ldr	r3, [fp, #-16]
    9f44:	e5932000 	ldr	r2, [r3]
    9f48:	e51b300c 	ldr	r3, [fp, #-12]
    9f4c:	e583200c 	str	r2, [r3, #12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:49
    task->sched_static_priority = 5;    // TODO: pro ted je to jen hardcoded hodnota, do budoucna urcite bude nutne dovolit specifikovat
    9f50:	e51b300c 	ldr	r3, [fp, #-12]
    9f54:	e3a02005 	mov	r2, #5
    9f58:	e5832018 	str	r2, [r3, #24]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:50
    task->sched_counter = task->sched_static_priority;
    9f5c:	e51b300c 	ldr	r3, [fp, #-12]
    9f60:	e5932018 	ldr	r2, [r3, #24]
    9f64:	e51b300c 	ldr	r3, [fp, #-12]
    9f68:	e5832014 	str	r2, [r3, #20]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:51
    task->state = NTask_State::Running;
    9f6c:	e51b300c 	ldr	r3, [fp, #-12]
    9f70:	e3a02002 	mov	r2, #2
    9f74:	e5832010 	str	r2, [r3, #16]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:53

    mCurrent_Task_Node = mProcess_List_Head;
    9f78:	e51b3010 	ldr	r3, [fp, #-16]
    9f7c:	e5932004 	ldr	r2, [r3, #4]
    9f80:	e51b3010 	ldr	r3, [fp, #-16]
    9f84:	e5832008 	str	r2, [r3, #8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:54
}
    9f88:	e320f000 	nop	{0}
    9f8c:	e24bd004 	sub	sp, fp, #4
    9f90:	e8bd8800 	pop	{fp, pc}
    9f94:	0000acdc 	ldrdeq	sl, [r0], -ip

00009f98 <_ZN16CProcess_Manager14Create_ProcessEm>:
_ZN16CProcess_Manager14Create_ProcessEm():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:57

uint32_t CProcess_Manager::Create_Process(unsigned long funcptr)
{
    9f98:	e92d4800 	push	{fp, lr}
    9f9c:	e28db004 	add	fp, sp, #4
    9fa0:	e24dd010 	sub	sp, sp, #16
    9fa4:	e50b0010 	str	r0, [fp, #-16]
    9fa8:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:58
    CProcess_List_Node* procnode = sKernelMem.Alloc<CProcess_List_Node>();
    9fac:	e59f010c 	ldr	r0, [pc, #268]	; a0c0 <_ZN16CProcess_Manager14Create_ProcessEm+0x128>
    9fb0:	eb0000fa 	bl	a3a0 <_ZN20CKernel_Heap_Manager5AllocI18CProcess_List_NodeEEPT_v>
    9fb4:	e1a03000 	mov	r3, r0
    9fb8:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:60

    procnode->next = mProcess_List_Head;
    9fbc:	e51b3010 	ldr	r3, [fp, #-16]
    9fc0:	e5932004 	ldr	r2, [r3, #4]
    9fc4:	e51b3008 	ldr	r3, [fp, #-8]
    9fc8:	e5832004 	str	r2, [r3, #4]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:61
    procnode->prev = nullptr;
    9fcc:	e51b3008 	ldr	r3, [fp, #-8]
    9fd0:	e3a02000 	mov	r2, #0
    9fd4:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:62
    mProcess_List_Head->prev = procnode;
    9fd8:	e51b3010 	ldr	r3, [fp, #-16]
    9fdc:	e5933004 	ldr	r3, [r3, #4]
    9fe0:	e51b2008 	ldr	r2, [fp, #-8]
    9fe4:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:63
    mProcess_List_Head = procnode;
    9fe8:	e51b3010 	ldr	r3, [fp, #-16]
    9fec:	e51b2008 	ldr	r2, [fp, #-8]
    9ff0:	e5832004 	str	r2, [r3, #4]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:65

    if (mCurrent_Task_Node == nullptr)
    9ff4:	e51b3010 	ldr	r3, [fp, #-16]
    9ff8:	e5933008 	ldr	r3, [r3, #8]
    9ffc:	e3530000 	cmp	r3, #0
    a000:	1a000002 	bne	a010 <_ZN16CProcess_Manager14Create_ProcessEm+0x78>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:67
    {
        mCurrent_Task_Node = procnode;
    a004:	e51b3010 	ldr	r3, [fp, #-16]
    a008:	e51b2008 	ldr	r2, [fp, #-8]
    a00c:	e5832008 	str	r2, [r3, #8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:70
    }

    procnode->task = sKernelMem.Alloc<TTask_Struct>();
    a010:	e59f00a8 	ldr	r0, [pc, #168]	; a0c0 <_ZN16CProcess_Manager14Create_ProcessEm+0x128>
    a014:	eb0000ec 	bl	a3cc <_ZN20CKernel_Heap_Manager5AllocI12TTask_StructEEPT_v>
    a018:	e1a02000 	mov	r2, r0
    a01c:	e51b3008 	ldr	r3, [fp, #-8]
    a020:	e5832008 	str	r2, [r3, #8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:72

    auto* task = procnode->task;
    a024:	e51b3008 	ldr	r3, [fp, #-8]
    a028:	e5933008 	ldr	r3, [r3, #8]
    a02c:	e50b300c 	str	r3, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:74

    task->pid = ++mLast_PID;
    a030:	e51b3010 	ldr	r3, [fp, #-16]
    a034:	e5933000 	ldr	r3, [r3]
    a038:	e2832001 	add	r2, r3, #1
    a03c:	e51b3010 	ldr	r3, [fp, #-16]
    a040:	e5832000 	str	r2, [r3]
    a044:	e51b3010 	ldr	r3, [fp, #-16]
    a048:	e5932000 	ldr	r2, [r3]
    a04c:	e51b300c 	ldr	r3, [fp, #-12]
    a050:	e583200c 	str	r2, [r3, #12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:75
    task->sched_static_priority = 5;    // TODO: pro ted je to jen hardcoded hodnota, do budoucna urcite bude nutne dovolit specifikovat
    a054:	e51b300c 	ldr	r3, [fp, #-12]
    a058:	e3a02005 	mov	r2, #5
    a05c:	e5832018 	str	r2, [r3, #24]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:76
    task->sched_counter = task->sched_static_priority;
    a060:	e51b300c 	ldr	r3, [fp, #-12]
    a064:	e5932018 	ldr	r2, [r3, #24]
    a068:	e51b300c 	ldr	r3, [fp, #-12]
    a06c:	e5832014 	str	r2, [r3, #20]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:77
    task->state = NTask_State::New;
    a070:	e51b300c 	ldr	r3, [fp, #-12]
    a074:	e3a02000 	mov	r2, #0
    a078:	e5832010 	str	r2, [r3, #16]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:79
    
    task->cpu_context.lr = funcptr;
    a07c:	e51b300c 	ldr	r3, [fp, #-12]
    a080:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    a084:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:80
    task->cpu_context.pc = reinterpret_cast<unsigned long>(&process_bootstrap);
    a088:	e59f2034 	ldr	r2, [pc, #52]	; a0c4 <_ZN16CProcess_Manager14Create_ProcessEm+0x12c>
    a08c:	e51b300c 	ldr	r3, [fp, #-12]
    a090:	e5832008 	str	r2, [r3, #8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:81
    task->cpu_context.sp = static_cast<unsigned long>(sPage_Manager.Alloc_Page()) + mem::PageSize;
    a094:	e59f002c 	ldr	r0, [pc, #44]	; a0c8 <_ZN16CProcess_Manager14Create_ProcessEm+0x130>
    a098:	ebfffefb 	bl	9c8c <_ZN13CPage_Manager10Alloc_PageEv>
    a09c:	e1a03000 	mov	r3, r0
    a0a0:	e2832901 	add	r2, r3, #16384	; 0x4000
    a0a4:	e51b300c 	ldr	r3, [fp, #-12]
    a0a8:	e5832004 	str	r2, [r3, #4]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:83

    return task->pid;
    a0ac:	e51b300c 	ldr	r3, [fp, #-12]
    a0b0:	e593300c 	ldr	r3, [r3, #12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:84
}
    a0b4:	e1a00003 	mov	r0, r3
    a0b8:	e24bd004 	sub	sp, fp, #4
    a0bc:	e8bd8800 	pop	{fp, pc}
    a0c0:	0000acdc 	ldrdeq	sl, [r0], -ip
    a0c4:	0000a3f8 	strdeq	sl, [r0], -r8
    a0c8:	0000ace0 	andeq	sl, r0, r0, ror #25

0000a0cc <_ZN16CProcess_Manager8ScheduleEv>:
_ZN16CProcess_Manager8ScheduleEv():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:87

void CProcess_Manager::Schedule()
{
    a0cc:	e92d4800 	push	{fp, lr}
    a0d0:	e28db004 	add	fp, sp, #4
    a0d4:	e24dd010 	sub	sp, sp, #16
    a0d8:	e50b0010 	str	r0, [fp, #-16]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:89
    // je nejaky proces naplanovany?
    if (mCurrent_Task_Node)
    a0dc:	e51b3010 	ldr	r3, [fp, #-16]
    a0e0:	e5933008 	ldr	r3, [r3, #8]
    a0e4:	e3530000 	cmp	r3, #0
    a0e8:	0a000011 	beq	a134 <_ZN16CProcess_Manager8ScheduleEv+0x68>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:92
    {
        // snizime citac planovace
        mCurrent_Task_Node->task->sched_counter--;
    a0ec:	e51b3010 	ldr	r3, [fp, #-16]
    a0f0:	e5933008 	ldr	r3, [r3, #8]
    a0f4:	e5933008 	ldr	r3, [r3, #8]
    a0f8:	e5932014 	ldr	r2, [r3, #20]
    a0fc:	e2422001 	sub	r2, r2, #1
    a100:	e5832014 	str	r2, [r3, #20]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:94
        // pokud je citac vetsi nez 0, zatim nebudeme preplanovavat (a zaroven je proces stale ve stavu Running - nezablokoval se nad necim)
        if (mCurrent_Task_Node->task->sched_counter > 0 && mCurrent_Task_Node->task->state == NTask_State::Running)
    a104:	e51b3010 	ldr	r3, [fp, #-16]
    a108:	e5933008 	ldr	r3, [r3, #8]
    a10c:	e5933008 	ldr	r3, [r3, #8]
    a110:	e5933014 	ldr	r3, [r3, #20]
    a114:	e3530000 	cmp	r3, #0
    a118:	0a000005 	beq	a134 <_ZN16CProcess_Manager8ScheduleEv+0x68>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:94 (discriminator 1)
    a11c:	e51b3010 	ldr	r3, [fp, #-16]
    a120:	e5933008 	ldr	r3, [r3, #8]
    a124:	e5933008 	ldr	r3, [r3, #8]
    a128:	e5933010 	ldr	r3, [r3, #16]
    a12c:	e3530002 	cmp	r3, #2
    a130:	0a00003c 	beq	a228 <_ZN16CProcess_Manager8ScheduleEv+0x15c>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:101
    }

    // najdeme dalsi proces na planovani

    // vybereme dalsi proces v rade
    CProcess_List_Node* next = mCurrent_Task_Node ? mCurrent_Task_Node->next : mProcess_List_Head;
    a134:	e51b3010 	ldr	r3, [fp, #-16]
    a138:	e5933008 	ldr	r3, [r3, #8]
    a13c:	e3530000 	cmp	r3, #0
    a140:	0a000003 	beq	a154 <_ZN16CProcess_Manager8ScheduleEv+0x88>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:101 (discriminator 1)
    a144:	e51b3010 	ldr	r3, [fp, #-16]
    a148:	e5933008 	ldr	r3, [r3, #8]
    a14c:	e5933004 	ldr	r3, [r3, #4]
    a150:	ea000001 	b	a15c <_ZN16CProcess_Manager8ScheduleEv+0x90>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:101 (discriminator 2)
    a154:	e51b3010 	ldr	r3, [fp, #-16]
    a158:	e5933004 	ldr	r3, [r3, #4]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:101 (discriminator 4)
    a15c:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:102 (discriminator 4)
    if (!next)
    a160:	e51b3008 	ldr	r3, [fp, #-8]
    a164:	e3530000 	cmp	r3, #0
    a168:	1a000002 	bne	a178 <_ZN16CProcess_Manager8ScheduleEv+0xac>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:103
        next = mProcess_List_Head;
    a16c:	e51b3010 	ldr	r3, [fp, #-16]
    a170:	e5933004 	ldr	r3, [r3, #4]
    a174:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:107

    // proces k naplanovani musi bud byt ve stavu runnable (jiz nekdy bezel a muze bezet znovu) nebo running (pak jde o stavajici proces)
    // a nebo new (novy proces, ktery jeste nebyl planovany)
    while (next->task->state != NTask_State::Runnable && next->task->state != NTask_State::Running && next->task->state != NTask_State::New)
    a178:	e51b3008 	ldr	r3, [fp, #-8]
    a17c:	e5933008 	ldr	r3, [r3, #8]
    a180:	e5933010 	ldr	r3, [r3, #16]
    a184:	e3530001 	cmp	r3, #1
    a188:	0a000014 	beq	a1e0 <_ZN16CProcess_Manager8ScheduleEv+0x114>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:107 (discriminator 1)
    a18c:	e51b3008 	ldr	r3, [fp, #-8]
    a190:	e5933008 	ldr	r3, [r3, #8]
    a194:	e5933010 	ldr	r3, [r3, #16]
    a198:	e3530002 	cmp	r3, #2
    a19c:	0a00000f 	beq	a1e0 <_ZN16CProcess_Manager8ScheduleEv+0x114>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:107 (discriminator 2)
    a1a0:	e51b3008 	ldr	r3, [fp, #-8]
    a1a4:	e5933008 	ldr	r3, [r3, #8]
    a1a8:	e5933010 	ldr	r3, [r3, #16]
    a1ac:	e3530000 	cmp	r3, #0
    a1b0:	0a00000a 	beq	a1e0 <_ZN16CProcess_Manager8ScheduleEv+0x114>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:109
    {
        if (!next)
    a1b4:	e51b3008 	ldr	r3, [fp, #-8]
    a1b8:	e3530000 	cmp	r3, #0
    a1bc:	1a000003 	bne	a1d0 <_ZN16CProcess_Manager8ScheduleEv+0x104>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:111
        {
            next = mCurrent_Task_Node;
    a1c0:	e51b3010 	ldr	r3, [fp, #-16]
    a1c4:	e5933008 	ldr	r3, [r3, #8]
    a1c8:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:112
            break;
    a1cc:	ea000003 	b	a1e0 <_ZN16CProcess_Manager8ScheduleEv+0x114>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:115
        }
        else
            next = next->next;
    a1d0:	e51b3008 	ldr	r3, [fp, #-8]
    a1d4:	e5933004 	ldr	r3, [r3, #4]
    a1d8:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:107
    while (next->task->state != NTask_State::Runnable && next->task->state != NTask_State::Running && next->task->state != NTask_State::New)
    a1dc:	eaffffe5 	b	a178 <_ZN16CProcess_Manager8ScheduleEv+0xac>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:119
    }

    // stavajici proces je jediny planovatelny - nemusime nic preplanovavat
    if (next == mCurrent_Task_Node)
    a1e0:	e51b3010 	ldr	r3, [fp, #-16]
    a1e4:	e5933008 	ldr	r3, [r3, #8]
    a1e8:	e51b2008 	ldr	r2, [fp, #-8]
    a1ec:	e1520003 	cmp	r2, r3
    a1f0:	1a000008 	bne	a218 <_ZN16CProcess_Manager8ScheduleEv+0x14c>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:122
    {
        // nastavime mu zase zpatky jeho pridel casovych kvant a vracime se
        mCurrent_Task_Node->task->sched_counter = mCurrent_Task_Node->task->sched_static_priority;
    a1f4:	e51b3010 	ldr	r3, [fp, #-16]
    a1f8:	e5933008 	ldr	r3, [r3, #8]
    a1fc:	e5932008 	ldr	r2, [r3, #8]
    a200:	e51b3010 	ldr	r3, [fp, #-16]
    a204:	e5933008 	ldr	r3, [r3, #8]
    a208:	e5933008 	ldr	r3, [r3, #8]
    a20c:	e5922018 	ldr	r2, [r2, #24]
    a210:	e5832014 	str	r2, [r3, #20]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:123
        return;
    a214:	ea000004 	b	a22c <_ZN16CProcess_Manager8ScheduleEv+0x160>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:127
    }

    // sMonitor << "Next = " << mCurrent_Task_Node->task->pid << '\n';
    Switch_To(next);
    a218:	e51b1008 	ldr	r1, [fp, #-8]
    a21c:	e51b0010 	ldr	r0, [fp, #-16]
    a220:	eb000003 	bl	a234 <_ZN16CProcess_Manager9Switch_ToEP18CProcess_List_Node>
    a224:	ea000000 	b	a22c <_ZN16CProcess_Manager8ScheduleEv+0x160>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:95
            return;
    a228:	e320f000 	nop	{0}
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:128
}
    a22c:	e24bd004 	sub	sp, fp, #4
    a230:	e8bd8800 	pop	{fp, pc}

0000a234 <_ZN16CProcess_Manager9Switch_ToEP18CProcess_List_Node>:
_ZN16CProcess_Manager9Switch_ToEP18CProcess_List_Node():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:131

void CProcess_Manager::Switch_To(CProcess_List_Node* node)
{
    a234:	e92d4800 	push	{fp, lr}
    a238:	e28db004 	add	fp, sp, #4
    a23c:	e24dd010 	sub	sp, sp, #16
    a240:	e50b0010 	str	r0, [fp, #-16]
    a244:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:134
    // pokud je stavajici proces ve stavu Running (muze teoreticky byt jeste Blocked), vratime ho do stavu Runnable
    // Blocked prehazovat nebudeme ze zjevnych duvodu
    if (mCurrent_Task_Node->task->state == NTask_State::Running)
    a248:	e51b3010 	ldr	r3, [fp, #-16]
    a24c:	e5933008 	ldr	r3, [r3, #8]
    a250:	e5933008 	ldr	r3, [r3, #8]
    a254:	e5933010 	ldr	r3, [r3, #16]
    a258:	e3530002 	cmp	r3, #2
    a25c:	1a000004 	bne	a274 <_ZN16CProcess_Manager9Switch_ToEP18CProcess_List_Node+0x40>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:135
        mCurrent_Task_Node->task->state = NTask_State::Runnable;
    a260:	e51b3010 	ldr	r3, [fp, #-16]
    a264:	e5933008 	ldr	r3, [r3, #8]
    a268:	e5933008 	ldr	r3, [r3, #8]
    a26c:	e3a02001 	mov	r2, #1
    a270:	e5832010 	str	r2, [r3, #16]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:138

    // projistotu vynulujeme prideleny pocet casovych kvant
    mCurrent_Task_Node->task->sched_counter = 0;
    a274:	e51b3010 	ldr	r3, [fp, #-16]
    a278:	e5933008 	ldr	r3, [r3, #8]
    a27c:	e5933008 	ldr	r3, [r3, #8]
    a280:	e3a02000 	mov	r2, #0
    a284:	e5832014 	str	r2, [r3, #20]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:140

    TCPU_Context* old = &mCurrent_Task_Node->task->cpu_context;
    a288:	e51b3010 	ldr	r3, [fp, #-16]
    a28c:	e5933008 	ldr	r3, [r3, #8]
    a290:	e5933008 	ldr	r3, [r3, #8]
    a294:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:141
    bool is_first_time = (node->task->state == NTask_State::New);
    a298:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    a29c:	e5933008 	ldr	r3, [r3, #8]
    a2a0:	e5933010 	ldr	r3, [r3, #16]
    a2a4:	e3530000 	cmp	r3, #0
    a2a8:	03a03001 	moveq	r3, #1
    a2ac:	13a03000 	movne	r3, #0
    a2b0:	e54b3009 	strb	r3, [fp, #-9]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:144

    // prehodime na novy proces, pridelime casova kvanta a nastavime proces do stavu Running
    mCurrent_Task_Node = node;
    a2b4:	e51b3010 	ldr	r3, [fp, #-16]
    a2b8:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    a2bc:	e5832008 	str	r2, [r3, #8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:145
    mCurrent_Task_Node->task->sched_counter = mCurrent_Task_Node->task->sched_static_priority;
    a2c0:	e51b3010 	ldr	r3, [fp, #-16]
    a2c4:	e5933008 	ldr	r3, [r3, #8]
    a2c8:	e5932008 	ldr	r2, [r3, #8]
    a2cc:	e51b3010 	ldr	r3, [fp, #-16]
    a2d0:	e5933008 	ldr	r3, [r3, #8]
    a2d4:	e5933008 	ldr	r3, [r3, #8]
    a2d8:	e5922018 	ldr	r2, [r2, #24]
    a2dc:	e5832014 	str	r2, [r3, #20]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:146
    mCurrent_Task_Node->task->state = NTask_State::Running;
    a2e0:	e51b3010 	ldr	r3, [fp, #-16]
    a2e4:	e5933008 	ldr	r3, [r3, #8]
    a2e8:	e5933008 	ldr	r3, [r3, #8]
    a2ec:	e3a02002 	mov	r2, #2
    a2f0:	e5832010 	str	r2, [r3, #16]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:149

    // pokud je to poprve, co je proces planovany, musime to vzit jeste pres malou odbocku ("bootstrap")
    if (is_first_time)
    a2f4:	e55b3009 	ldrb	r3, [fp, #-9]
    a2f8:	e3530000 	cmp	r3, #0
    a2fc:	0a000005 	beq	a318 <_ZN16CProcess_Manager9Switch_ToEP18CProcess_List_Node+0xe4>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:150
        context_switch_first(&node->task->cpu_context, old);
    a300:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    a304:	e5933008 	ldr	r3, [r3, #8]
    a308:	e51b1008 	ldr	r1, [fp, #-8]
    a30c:	e1a00003 	mov	r0, r3
    a310:	eb000043 	bl	a424 <context_switch_first>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:153
    else
        context_switch(&node->task->cpu_context, old);
}
    a314:	ea000004 	b	a32c <_ZN16CProcess_Manager9Switch_ToEP18CProcess_List_Node+0xf8>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:152
        context_switch(&node->task->cpu_context, old);
    a318:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    a31c:	e5933008 	ldr	r3, [r3, #8]
    a320:	e51b1008 	ldr	r1, [fp, #-8]
    a324:	e1a00003 	mov	r0, r3
    a328:	eb000034 	bl	a400 <context_switch>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:153
}
    a32c:	e320f000 	nop	{0}
    a330:	e24bd004 	sub	sp, fp, #4
    a334:	e8bd8800 	pop	{fp, pc}

0000a338 <_Z41__static_initialization_and_destruction_0ii>:
_Z41__static_initialization_and_destruction_0ii():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:153
    a338:	e92d4800 	push	{fp, lr}
    a33c:	e28db004 	add	fp, sp, #4
    a340:	e24dd008 	sub	sp, sp, #8
    a344:	e50b0008 	str	r0, [fp, #-8]
    a348:	e50b100c 	str	r1, [fp, #-12]
    a34c:	e51b3008 	ldr	r3, [fp, #-8]
    a350:	e3530001 	cmp	r3, #1
    a354:	1a000005 	bne	a370 <_Z41__static_initialization_and_destruction_0ii+0x38>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:153 (discriminator 1)
    a358:	e51b300c 	ldr	r3, [fp, #-12]
    a35c:	e59f2018 	ldr	r2, [pc, #24]	; a37c <_Z41__static_initialization_and_destruction_0ii+0x44>
    a360:	e1530002 	cmp	r3, r2
    a364:	1a000001 	bne	a370 <_Z41__static_initialization_and_destruction_0ii+0x38>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:16
CProcess_Manager sProcessMgr;
    a368:	e59f0010 	ldr	r0, [pc, #16]	; a380 <_Z41__static_initialization_and_destruction_0ii+0x48>
    a36c:	ebfffea8 	bl	9e14 <_ZN16CProcess_ManagerC1Ev>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:153
}
    a370:	e320f000 	nop	{0}
    a374:	e24bd004 	sub	sp, fp, #4
    a378:	e8bd8800 	pop	{fp, pc}
    a37c:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>
    a380:	0000bce0 	andeq	fp, r0, r0, ror #25

0000a384 <_GLOBAL__sub_I_sProcessMgr>:
_GLOBAL__sub_I_sProcessMgr():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:153
    a384:	e92d4800 	push	{fp, lr}
    a388:	e28db004 	add	fp, sp, #4
    a38c:	e59f1008 	ldr	r1, [pc, #8]	; a39c <_GLOBAL__sub_I_sProcessMgr+0x18>
    a390:	e3a00001 	mov	r0, #1
    a394:	ebffffe7 	bl	a338 <_Z41__static_initialization_and_destruction_0ii>
    a398:	e8bd8800 	pop	{fp, pc}
    a39c:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>

0000a3a0 <_ZN20CKernel_Heap_Manager5AllocI18CProcess_List_NodeEEPT_v>:
_ZN20CKernel_Heap_Manager5AllocI18CProcess_List_NodeEEPT_v():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/include/memory/kernel_heap.h:30

        void* Alloc(uint32_t size);
        void Free(void* mem);

        template<class T>
        T* Alloc()
    a3a0:	e92d4800 	push	{fp, lr}
    a3a4:	e28db004 	add	fp, sp, #4
    a3a8:	e24dd008 	sub	sp, sp, #8
    a3ac:	e50b0008 	str	r0, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/include/memory/kernel_heap.h:32
        {
            return reinterpret_cast<T*>(Alloc(sizeof(T)));
    a3b0:	e3a0100c 	mov	r1, #12
    a3b4:	e51b0008 	ldr	r0, [fp, #-8]
    a3b8:	ebfffce1 	bl	9744 <_ZN20CKernel_Heap_Manager5AllocEj>
    a3bc:	e1a03000 	mov	r3, r0
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/include/memory/kernel_heap.h:33
        }
    a3c0:	e1a00003 	mov	r0, r3
    a3c4:	e24bd004 	sub	sp, fp, #4
    a3c8:	e8bd8800 	pop	{fp, pc}

0000a3cc <_ZN20CKernel_Heap_Manager5AllocI12TTask_StructEEPT_v>:
_ZN20CKernel_Heap_Manager5AllocI12TTask_StructEEPT_v():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/include/memory/kernel_heap.h:30
        T* Alloc()
    a3cc:	e92d4800 	push	{fp, lr}
    a3d0:	e28db004 	add	fp, sp, #4
    a3d4:	e24dd008 	sub	sp, sp, #8
    a3d8:	e50b0008 	str	r0, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/include/memory/kernel_heap.h:32
            return reinterpret_cast<T*>(Alloc(sizeof(T)));
    a3dc:	e3a0101c 	mov	r1, #28
    a3e0:	e51b0008 	ldr	r0, [fp, #-8]
    a3e4:	ebfffcd6 	bl	9744 <_ZN20CKernel_Heap_Manager5AllocEj>
    a3e8:	e1a03000 	mov	r3, r0
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/include/memory/kernel_heap.h:33
        }
    a3ec:	e1a00003 	mov	r0, r3
    a3f0:	e24bd004 	sub	sp, fp, #4
    a3f4:	e8bd8800 	pop	{fp, pc}

0000a3f8 <process_bootstrap>:
process_bootstrap():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/switch.s:5
.global process_bootstrap
;@ Process bootstrapping - kernelovy "obal" procesu
;@ Vyzaduje na zasobniku pushnutou hodnotu vstupniho bodu procesu
process_bootstrap:
    add lr, pc, #8      ;@ ulozime do lr hodnotu PC+8, abychom se korektne vratili na instrukci po nasledujici
    a3f8:	e28fe008 	add	lr, pc, #8
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/switch.s:6
    pop {pc}            ;@ vyzvedneme si ulozenou hodnotu cile
    a3fc:	e49df004 	pop	{pc}		; (ldr pc, [sp], #4)

0000a400 <context_switch>:
context_switch():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/switch.s:14
.global context_switch
;@ Prepnuti procesu ze soucasneho na jiny, ktery jiz byl planovany
;@ r0 - novy proces
;@ r1 - stary proces
context_switch:
	mrs r12, cpsr           ;@ ulozit CPU state do r12
    a400:	e10fc000 	mrs	ip, CPSR
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/switch.s:15
	push {r14}              ;@ push LR
    a404:	e52de004 	push	{lr}		; (str lr, [sp, #-4]!)
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/switch.s:16
	push {r0}               ;@ push SP
    a408:	e52d0004 	push	{r0}		; (str r0, [sp, #-4]!)
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/switch.s:17
	push {r0-r12}           ;@ push registru
    a40c:	e92d1fff 	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, fp, ip}
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/switch.s:18
	str sp, [r1, #4]        ;@ ulozit SP stareho procesu
    a410:	e581d004 	str	sp, [r1, #4]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/switch.s:20

	ldr sp, [r0, #4]        ;@ nacist SP noveho procesu
    a414:	e590d004 	ldr	sp, [r0, #4]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/switch.s:21
	pop {r0-r12}            ;@ obnovit registry noveho procesu
    a418:	e8bd1fff 	pop	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, fp, ip}
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/switch.s:22
	msr cpsr_c, r12         ;@ obnovit CPU state
    a41c:	e121f00c 	msr	CPSR_c, ip
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/switch.s:23
	pop {lr, pc}            ;@ navrat do kontextu provadeni noveho procesu
    a420:	e8bdc000 	pop	{lr, pc}

0000a424 <context_switch_first>:
context_switch_first():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/switch.s:30
.global context_switch_first
;@ Prepnuti procesu ze soucasneho na jiny, ktery jeste nebyl planovany
;@ r0 - novy proces
;@ r1 - stary proces
context_switch_first:
	mrs r12, cpsr           ;@ ulozit CPU state do r12
    a424:	e10fc000 	mrs	ip, CPSR
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/switch.s:31
	push {r14}              ;@ push LR
    a428:	e52de004 	push	{lr}		; (str lr, [sp, #-4]!)
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/switch.s:32
	push {r13}              ;@ push SP
    a42c:	e92d2000 	stmfd	sp!, {sp}
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/switch.s:33
	push {r0-r12}           ;@ push registru
    a430:	e92d1fff 	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, fp, ip}
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/switch.s:34
	str sp, [r1, #4]        ;@ ulozit SP stareho procesu
    a434:	e581d004 	str	sp, [r1, #4]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/switch.s:36

    ldr r3, [r0, #0]        ;@ "budouci" PC do r3 (entry point procesu)
    a438:	e5903000 	ldr	r3, [r0]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/switch.s:37
    ldr r2, [r0, #8]        ;@ "vstupni" PC do r2 (bootstrap procesu v kernelu)
    a43c:	e5902008 	ldr	r2, [r0, #8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/switch.s:38
    ldr sp, [r0, #4]        ;@ nacteme stack pointer procesu
    a440:	e590d004 	ldr	sp, [r0, #4]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/switch.s:39
    push {r3}               ;@ budouci navratova adresa -> do zasobniku, bootstrap si ji tamodsud vyzvedne
    a444:	e52d3004 	push	{r3}		; (str r3, [sp, #-4]!)
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/switch.s:40
    push {r2}               ;@ pushneme si i bootstrap adresu, abychom ji mohli obnovit do PC
    a448:	e52d2004 	push	{r2}		; (str r2, [sp, #-4]!)
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/switch.s:41
    cpsie i                 ;@ povolime preruseni (v budoucich switchich uz bude flaga ulozena v cpsr/spsr)
    a44c:	f1080080 	cpsie	i
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/switch.s:42
    pop {pc}                ;@ vybereme ze zasobniku novou hodnotu PC (PC procesu)
    a450:	e49df004 	pop	{pc}		; (ldr pc, [sp], #4)

0000a454 <enable_irq>:
enable_irq():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:102
;@ tady budou ostatni symboly, ktere nevyzaduji zadne specialni misto
.section .text

.global enable_irq
enable_irq:
    mrs r0, cpsr		;@ presun ridiciho registru (CPSR) do general purpose registru (R0)
    a454:	e10f0000 	mrs	r0, CPSR
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:103
    bic r0, r0, #0x80	;@ vypne bit 7 v registru r0 ("IRQ mask bit")
    a458:	e3c00080 	bic	r0, r0, #128	; 0x80
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:104
    msr cpsr_c, r0		;@ nacteme upraveny general purpose (R0) registr do ridiciho (CPSR)
    a45c:	e121f000 	msr	CPSR_c, r0
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:105
    cpsie i				;@ povoli preruseni
    a460:	f1080080 	cpsie	i
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:106
    bx lr
    a464:	e12fff1e 	bx	lr

0000a468 <disable_irq>:
disable_irq():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:110

.global disable_irq
disable_irq:
    cpsid i
    a468:	f10c0080 	cpsid	i
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:111
    bx lr
    a46c:	e12fff1e 	bx	lr

0000a470 <undefined_instruction_handler>:
undefined_instruction_handler():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:114

undefined_instruction_handler:
	b hang
    a470:	eafff70c 	b	80a8 <hang>

0000a474 <irq_handler>:
irq_handler():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:118

.global _internal_irq_handler
irq_handler:
	sub lr, lr, #4
    a474:	e24ee004 	sub	lr, lr, #4
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:119
	srsdb #CPSR_MODE_SYS!		;@ ekvivalent k push lr a msr+push spsr
    a478:	f96d051f 	srsdb	sp!, #31
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:120
	cpsid if, #CPSR_MODE_SYS	;@ prechod do SYS modu + zakazeme preruseni
    a47c:	f10e00df 	cpsid	if,#31
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:121
	push {r0-r4, r12, lr}		;@ ulozime callee-saved registry
    a480:	e92d501f 	push	{r0, r1, r2, r3, r4, ip, lr}
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:123

	and r4, sp, #7
    a484:	e20d4007 	and	r4, sp, #7
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:124
	sub sp, sp, r4
    a488:	e04dd004 	sub	sp, sp, r4
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:126

	bl _internal_irq_handler	;@ zavolame handler IRQ
    a48c:	ebfffb3e 	bl	918c <_internal_irq_handler>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:128

	add sp, sp, r4
    a490:	e08dd004 	add	sp, sp, r4
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:130

	pop {r0-r4, r12, lr}		;@ obnovime callee-saved registry
    a494:	e8bd501f 	pop	{r0, r1, r2, r3, r4, ip, lr}
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:131
	rfeia sp!					;@ vracime se do puvodniho stavu (ktery ulozila instrukce srsdb)
    a498:	f8bd0a00 	rfeia	sp!

0000a49c <prefetch_abort_handler>:
prefetch_abort_handler():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:136

prefetch_abort_handler:
	;@ tady pak muzeme osetrit, kdyz program zasahne do mista, ktere nema mapovane ve svem virtualnim adr. prostoru
	;@ a treba vyvolat nasi obdobu segfaultu
	b hang
    a49c:	eafff701 	b	80a8 <hang>

0000a4a0 <data_abort_handler>:
data_abort_handler():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:141

data_abort_handler:
	;@ tady pak muzeme osetrit, kdyz program zasahne do mista, ktere nema mapovane ve svem virtualnim adr. prostoru
	;@ a treba vyvolat nasi obdobu segfaultu
	b hang
    a4a0:	eafff700 	b	80a8 <hang>

0000a4a4 <_c_startup>:
_c_startup():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/startup.cpp:21
extern "C" dtor_ptr __DTOR_LIST__[0];
// konec pole destruktoru
extern "C" dtor_ptr __DTOR_END__[0];

extern "C" int _c_startup(void)
{
    a4a4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    a4a8:	e28db000 	add	fp, sp, #0
    a4ac:	e24dd00c 	sub	sp, sp, #12
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/startup.cpp:25
	int* i;
	
	// vynulujeme .bss sekci
	for (i = (int*)_bss_start; i < (int*)_bss_end; i++)
    a4b0:	e59f304c 	ldr	r3, [pc, #76]	; a504 <_c_startup+0x60>
    a4b4:	e5933000 	ldr	r3, [r3]
    a4b8:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/startup.cpp:25 (discriminator 3)
    a4bc:	e59f3044 	ldr	r3, [pc, #68]	; a508 <_c_startup+0x64>
    a4c0:	e5933000 	ldr	r3, [r3]
    a4c4:	e1a02003 	mov	r2, r3
    a4c8:	e51b3008 	ldr	r3, [fp, #-8]
    a4cc:	e1530002 	cmp	r3, r2
    a4d0:	2a000006 	bcs	a4f0 <_c_startup+0x4c>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/startup.cpp:26 (discriminator 2)
		*i = 0;
    a4d4:	e51b3008 	ldr	r3, [fp, #-8]
    a4d8:	e3a02000 	mov	r2, #0
    a4dc:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/startup.cpp:25 (discriminator 2)
	for (i = (int*)_bss_start; i < (int*)_bss_end; i++)
    a4e0:	e51b3008 	ldr	r3, [fp, #-8]
    a4e4:	e2833004 	add	r3, r3, #4
    a4e8:	e50b3008 	str	r3, [fp, #-8]
    a4ec:	eafffff2 	b	a4bc <_c_startup+0x18>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/startup.cpp:28
	
	return 0;
    a4f0:	e3a03000 	mov	r3, #0
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/startup.cpp:29
}
    a4f4:	e1a00003 	mov	r0, r3
    a4f8:	e28bd000 	add	sp, fp, #0
    a4fc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    a500:	e12fff1e 	bx	lr
    a504:	0000aca0 	andeq	sl, r0, r0, lsr #25
    a508:	0000bcfc 	strdeq	fp, [r0], -ip

0000a50c <_cpp_startup>:
_cpp_startup():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/startup.cpp:32

extern "C" int _cpp_startup(void)
{
    a50c:	e92d4800 	push	{fp, lr}
    a510:	e28db004 	add	fp, sp, #4
    a514:	e24dd008 	sub	sp, sp, #8
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/startup.cpp:37
	ctor_ptr* fnptr;
	
	// zavolame konstruktory globalnich C++ trid
	// v poli __CTOR_LIST__ jsou ukazatele na vygenerovane stuby volani konstruktoru
	for (fnptr = __CTOR_LIST__; fnptr < __CTOR_END__; fnptr++)
    a518:	e59f303c 	ldr	r3, [pc, #60]	; a55c <_cpp_startup+0x50>
    a51c:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/startup.cpp:37 (discriminator 3)
    a520:	e51b3008 	ldr	r3, [fp, #-8]
    a524:	e59f2034 	ldr	r2, [pc, #52]	; a560 <_cpp_startup+0x54>
    a528:	e1530002 	cmp	r3, r2
    a52c:	2a000006 	bcs	a54c <_cpp_startup+0x40>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/startup.cpp:38 (discriminator 2)
		(*fnptr)();
    a530:	e51b3008 	ldr	r3, [fp, #-8]
    a534:	e5933000 	ldr	r3, [r3]
    a538:	e12fff33 	blx	r3
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/startup.cpp:37 (discriminator 2)
	for (fnptr = __CTOR_LIST__; fnptr < __CTOR_END__; fnptr++)
    a53c:	e51b3008 	ldr	r3, [fp, #-8]
    a540:	e2833004 	add	r3, r3, #4
    a544:	e50b3008 	str	r3, [fp, #-8]
    a548:	eafffff4 	b	a520 <_cpp_startup+0x14>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/startup.cpp:40
	
	return 0;
    a54c:	e3a03000 	mov	r3, #0
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/startup.cpp:41
}
    a550:	e1a00003 	mov	r0, r3
    a554:	e24bd004 	sub	sp, fp, #4
    a558:	e8bd8800 	pop	{fp, pc}
    a55c:	0000ac84 	andeq	sl, r0, r4, lsl #25
    a560:	0000aca0 	andeq	sl, r0, r0, lsr #25

0000a564 <_cpp_shutdown>:
_cpp_shutdown():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/startup.cpp:44

extern "C" int _cpp_shutdown(void)
{
    a564:	e92d4800 	push	{fp, lr}
    a568:	e28db004 	add	fp, sp, #4
    a56c:	e24dd008 	sub	sp, sp, #8
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/startup.cpp:48
	dtor_ptr* fnptr;
	
	// zavolame destruktory globalnich C++ trid
	for (fnptr = __DTOR_LIST__; fnptr < __DTOR_END__; fnptr++)
    a570:	e59f303c 	ldr	r3, [pc, #60]	; a5b4 <_cpp_shutdown+0x50>
    a574:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/startup.cpp:48 (discriminator 3)
    a578:	e51b3008 	ldr	r3, [fp, #-8]
    a57c:	e59f2034 	ldr	r2, [pc, #52]	; a5b8 <_cpp_shutdown+0x54>
    a580:	e1530002 	cmp	r3, r2
    a584:	2a000006 	bcs	a5a4 <_cpp_shutdown+0x40>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/startup.cpp:49 (discriminator 2)
		(*fnptr)();
    a588:	e51b3008 	ldr	r3, [fp, #-8]
    a58c:	e5933000 	ldr	r3, [r3]
    a590:	e12fff33 	blx	r3
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/startup.cpp:48 (discriminator 2)
	for (fnptr = __DTOR_LIST__; fnptr < __DTOR_END__; fnptr++)
    a594:	e51b3008 	ldr	r3, [fp, #-8]
    a598:	e2833004 	add	r3, r3, #4
    a59c:	e50b3008 	str	r3, [fp, #-8]
    a5a0:	eafffff4 	b	a578 <_cpp_shutdown+0x14>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/startup.cpp:51
	
	return 0;
    a5a4:	e3a03000 	mov	r3, #0
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/startup.cpp:52
}
    a5a8:	e1a00003 	mov	r0, r3
    a5ac:	e24bd004 	sub	sp, fp, #4
    a5b0:	e8bd8800 	pop	{fp, pc}
    a5b4:	0000aca0 	andeq	sl, r0, r0, lsr #25
    a5b8:	0000aca0 	andeq	sl, r0, r0, lsr #25

0000a5bc <_Z4itoajPcj>:
_Z4itoajPcj():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/stdlib/src/stdstring.cpp:9
{
    const char CharConvArr[] = "0123456789ABCDEF";
}

void itoa(unsigned int input, char* output, unsigned int base)
{
    a5bc:	e92d4800 	push	{fp, lr}
    a5c0:	e28db004 	add	fp, sp, #4
    a5c4:	e24dd020 	sub	sp, sp, #32
    a5c8:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    a5cc:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    a5d0:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/stdlib/src/stdstring.cpp:10
	int i = 0;
    a5d4:	e3a03000 	mov	r3, #0
    a5d8:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/stdlib/src/stdstring.cpp:12

	while (input > 0)
    a5dc:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    a5e0:	e3530000 	cmp	r3, #0
    a5e4:	0a000014 	beq	a63c <_Z4itoajPcj+0x80>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/stdlib/src/stdstring.cpp:14
	{
		output[i] = CharConvArr[input % base];
    a5e8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    a5ec:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    a5f0:	e1a00003 	mov	r0, r3
    a5f4:	eb0000c8 	bl	a91c <__aeabi_uidivmod>
    a5f8:	e1a03001 	mov	r3, r1
    a5fc:	e1a01003 	mov	r1, r3
    a600:	e51b3008 	ldr	r3, [fp, #-8]
    a604:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    a608:	e0823003 	add	r3, r2, r3
    a60c:	e59f2118 	ldr	r2, [pc, #280]	; a72c <_Z4itoajPcj+0x170>
    a610:	e7d22001 	ldrb	r2, [r2, r1]
    a614:	e5c32000 	strb	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/stdlib/src/stdstring.cpp:15
		input /= base;
    a618:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    a61c:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    a620:	eb000042 	bl	a730 <__udivsi3>
    a624:	e1a03000 	mov	r3, r0
    a628:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/stdlib/src/stdstring.cpp:16
		i++;
    a62c:	e51b3008 	ldr	r3, [fp, #-8]
    a630:	e2833001 	add	r3, r3, #1
    a634:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/stdlib/src/stdstring.cpp:12
	while (input > 0)
    a638:	eaffffe7 	b	a5dc <_Z4itoajPcj+0x20>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/stdlib/src/stdstring.cpp:19
	}

    if (i == 0)
    a63c:	e51b3008 	ldr	r3, [fp, #-8]
    a640:	e3530000 	cmp	r3, #0
    a644:	1a000007 	bne	a668 <_Z4itoajPcj+0xac>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/stdlib/src/stdstring.cpp:21
    {
        output[i] = CharConvArr[0];
    a648:	e51b3008 	ldr	r3, [fp, #-8]
    a64c:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    a650:	e0823003 	add	r3, r2, r3
    a654:	e3a02030 	mov	r2, #48	; 0x30
    a658:	e5c32000 	strb	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/stdlib/src/stdstring.cpp:22
        i++;
    a65c:	e51b3008 	ldr	r3, [fp, #-8]
    a660:	e2833001 	add	r3, r3, #1
    a664:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/stdlib/src/stdstring.cpp:25
    }

	output[i] = '\0';
    a668:	e51b3008 	ldr	r3, [fp, #-8]
    a66c:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    a670:	e0823003 	add	r3, r2, r3
    a674:	e3a02000 	mov	r2, #0
    a678:	e5c32000 	strb	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/stdlib/src/stdstring.cpp:26
	i--;
    a67c:	e51b3008 	ldr	r3, [fp, #-8]
    a680:	e2433001 	sub	r3, r3, #1
    a684:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/stdlib/src/stdstring.cpp:28

	for (int j = 0; j <= i/2; j++)
    a688:	e3a03000 	mov	r3, #0
    a68c:	e50b300c 	str	r3, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/stdlib/src/stdstring.cpp:28 (discriminator 3)
    a690:	e51b3008 	ldr	r3, [fp, #-8]
    a694:	e1a02fa3 	lsr	r2, r3, #31
    a698:	e0823003 	add	r3, r2, r3
    a69c:	e1a030c3 	asr	r3, r3, #1
    a6a0:	e1a02003 	mov	r2, r3
    a6a4:	e51b300c 	ldr	r3, [fp, #-12]
    a6a8:	e1530002 	cmp	r3, r2
    a6ac:	ca00001b 	bgt	a720 <_Z4itoajPcj+0x164>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/stdlib/src/stdstring.cpp:30 (discriminator 2)
	{
		char c = output[i - j];
    a6b0:	e51b2008 	ldr	r2, [fp, #-8]
    a6b4:	e51b300c 	ldr	r3, [fp, #-12]
    a6b8:	e0423003 	sub	r3, r2, r3
    a6bc:	e1a02003 	mov	r2, r3
    a6c0:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    a6c4:	e0833002 	add	r3, r3, r2
    a6c8:	e5d33000 	ldrb	r3, [r3]
    a6cc:	e54b300d 	strb	r3, [fp, #-13]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/stdlib/src/stdstring.cpp:31 (discriminator 2)
		output[i - j] = output[j];
    a6d0:	e51b300c 	ldr	r3, [fp, #-12]
    a6d4:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    a6d8:	e0822003 	add	r2, r2, r3
    a6dc:	e51b1008 	ldr	r1, [fp, #-8]
    a6e0:	e51b300c 	ldr	r3, [fp, #-12]
    a6e4:	e0413003 	sub	r3, r1, r3
    a6e8:	e1a01003 	mov	r1, r3
    a6ec:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    a6f0:	e0833001 	add	r3, r3, r1
    a6f4:	e5d22000 	ldrb	r2, [r2]
    a6f8:	e5c32000 	strb	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/stdlib/src/stdstring.cpp:32 (discriminator 2)
		output[j] = c;
    a6fc:	e51b300c 	ldr	r3, [fp, #-12]
    a700:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    a704:	e0823003 	add	r3, r2, r3
    a708:	e55b200d 	ldrb	r2, [fp, #-13]
    a70c:	e5c32000 	strb	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/stdlib/src/stdstring.cpp:28 (discriminator 2)
	for (int j = 0; j <= i/2; j++)
    a710:	e51b300c 	ldr	r3, [fp, #-12]
    a714:	e2833001 	add	r3, r3, #1
    a718:	e50b300c 	str	r3, [fp, #-12]
    a71c:	eaffffdb 	b	a690 <_Z4itoajPcj+0xd4>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/stdlib/src/stdstring.cpp:34
	}
}
    a720:	e320f000 	nop	{0}
    a724:	e24bd004 	sub	sp, fp, #4
    a728:	e8bd8800 	pop	{fp, pc}
    a72c:	0000ac40 	andeq	sl, r0, r0, asr #24

0000a730 <__udivsi3>:
__udivsi3():
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1099
    a730:	e2512001 	subs	r2, r1, #1
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1101
    a734:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1102
    a738:	3a000074 	bcc	a910 <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1103
    a73c:	e1500001 	cmp	r0, r1
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1104
    a740:	9a00006b 	bls	a8f4 <__udivsi3+0x1c4>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1105
    a744:	e1110002 	tst	r1, r2
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1106
    a748:	0a00006c 	beq	a900 <__udivsi3+0x1d0>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1108
    a74c:	e16f3f10 	clz	r3, r0
    a750:	e16f2f11 	clz	r2, r1
    a754:	e0423003 	sub	r3, r2, r3
    a758:	e273301f 	rsbs	r3, r3, #31
    a75c:	10833083 	addne	r3, r3, r3, lsl #1
    a760:	e3a02000 	mov	r2, #0
    a764:	108ff103 	addne	pc, pc, r3, lsl #2
    a768:	e1a00000 	nop			; (mov r0, r0)
    a76c:	e1500f81 	cmp	r0, r1, lsl #31
    a770:	e0a22002 	adc	r2, r2, r2
    a774:	20400f81 	subcs	r0, r0, r1, lsl #31
    a778:	e1500f01 	cmp	r0, r1, lsl #30
    a77c:	e0a22002 	adc	r2, r2, r2
    a780:	20400f01 	subcs	r0, r0, r1, lsl #30
    a784:	e1500e81 	cmp	r0, r1, lsl #29
    a788:	e0a22002 	adc	r2, r2, r2
    a78c:	20400e81 	subcs	r0, r0, r1, lsl #29
    a790:	e1500e01 	cmp	r0, r1, lsl #28
    a794:	e0a22002 	adc	r2, r2, r2
    a798:	20400e01 	subcs	r0, r0, r1, lsl #28
    a79c:	e1500d81 	cmp	r0, r1, lsl #27
    a7a0:	e0a22002 	adc	r2, r2, r2
    a7a4:	20400d81 	subcs	r0, r0, r1, lsl #27
    a7a8:	e1500d01 	cmp	r0, r1, lsl #26
    a7ac:	e0a22002 	adc	r2, r2, r2
    a7b0:	20400d01 	subcs	r0, r0, r1, lsl #26
    a7b4:	e1500c81 	cmp	r0, r1, lsl #25
    a7b8:	e0a22002 	adc	r2, r2, r2
    a7bc:	20400c81 	subcs	r0, r0, r1, lsl #25
    a7c0:	e1500c01 	cmp	r0, r1, lsl #24
    a7c4:	e0a22002 	adc	r2, r2, r2
    a7c8:	20400c01 	subcs	r0, r0, r1, lsl #24
    a7cc:	e1500b81 	cmp	r0, r1, lsl #23
    a7d0:	e0a22002 	adc	r2, r2, r2
    a7d4:	20400b81 	subcs	r0, r0, r1, lsl #23
    a7d8:	e1500b01 	cmp	r0, r1, lsl #22
    a7dc:	e0a22002 	adc	r2, r2, r2
    a7e0:	20400b01 	subcs	r0, r0, r1, lsl #22
    a7e4:	e1500a81 	cmp	r0, r1, lsl #21
    a7e8:	e0a22002 	adc	r2, r2, r2
    a7ec:	20400a81 	subcs	r0, r0, r1, lsl #21
    a7f0:	e1500a01 	cmp	r0, r1, lsl #20
    a7f4:	e0a22002 	adc	r2, r2, r2
    a7f8:	20400a01 	subcs	r0, r0, r1, lsl #20
    a7fc:	e1500981 	cmp	r0, r1, lsl #19
    a800:	e0a22002 	adc	r2, r2, r2
    a804:	20400981 	subcs	r0, r0, r1, lsl #19
    a808:	e1500901 	cmp	r0, r1, lsl #18
    a80c:	e0a22002 	adc	r2, r2, r2
    a810:	20400901 	subcs	r0, r0, r1, lsl #18
    a814:	e1500881 	cmp	r0, r1, lsl #17
    a818:	e0a22002 	adc	r2, r2, r2
    a81c:	20400881 	subcs	r0, r0, r1, lsl #17
    a820:	e1500801 	cmp	r0, r1, lsl #16
    a824:	e0a22002 	adc	r2, r2, r2
    a828:	20400801 	subcs	r0, r0, r1, lsl #16
    a82c:	e1500781 	cmp	r0, r1, lsl #15
    a830:	e0a22002 	adc	r2, r2, r2
    a834:	20400781 	subcs	r0, r0, r1, lsl #15
    a838:	e1500701 	cmp	r0, r1, lsl #14
    a83c:	e0a22002 	adc	r2, r2, r2
    a840:	20400701 	subcs	r0, r0, r1, lsl #14
    a844:	e1500681 	cmp	r0, r1, lsl #13
    a848:	e0a22002 	adc	r2, r2, r2
    a84c:	20400681 	subcs	r0, r0, r1, lsl #13
    a850:	e1500601 	cmp	r0, r1, lsl #12
    a854:	e0a22002 	adc	r2, r2, r2
    a858:	20400601 	subcs	r0, r0, r1, lsl #12
    a85c:	e1500581 	cmp	r0, r1, lsl #11
    a860:	e0a22002 	adc	r2, r2, r2
    a864:	20400581 	subcs	r0, r0, r1, lsl #11
    a868:	e1500501 	cmp	r0, r1, lsl #10
    a86c:	e0a22002 	adc	r2, r2, r2
    a870:	20400501 	subcs	r0, r0, r1, lsl #10
    a874:	e1500481 	cmp	r0, r1, lsl #9
    a878:	e0a22002 	adc	r2, r2, r2
    a87c:	20400481 	subcs	r0, r0, r1, lsl #9
    a880:	e1500401 	cmp	r0, r1, lsl #8
    a884:	e0a22002 	adc	r2, r2, r2
    a888:	20400401 	subcs	r0, r0, r1, lsl #8
    a88c:	e1500381 	cmp	r0, r1, lsl #7
    a890:	e0a22002 	adc	r2, r2, r2
    a894:	20400381 	subcs	r0, r0, r1, lsl #7
    a898:	e1500301 	cmp	r0, r1, lsl #6
    a89c:	e0a22002 	adc	r2, r2, r2
    a8a0:	20400301 	subcs	r0, r0, r1, lsl #6
    a8a4:	e1500281 	cmp	r0, r1, lsl #5
    a8a8:	e0a22002 	adc	r2, r2, r2
    a8ac:	20400281 	subcs	r0, r0, r1, lsl #5
    a8b0:	e1500201 	cmp	r0, r1, lsl #4
    a8b4:	e0a22002 	adc	r2, r2, r2
    a8b8:	20400201 	subcs	r0, r0, r1, lsl #4
    a8bc:	e1500181 	cmp	r0, r1, lsl #3
    a8c0:	e0a22002 	adc	r2, r2, r2
    a8c4:	20400181 	subcs	r0, r0, r1, lsl #3
    a8c8:	e1500101 	cmp	r0, r1, lsl #2
    a8cc:	e0a22002 	adc	r2, r2, r2
    a8d0:	20400101 	subcs	r0, r0, r1, lsl #2
    a8d4:	e1500081 	cmp	r0, r1, lsl #1
    a8d8:	e0a22002 	adc	r2, r2, r2
    a8dc:	20400081 	subcs	r0, r0, r1, lsl #1
    a8e0:	e1500001 	cmp	r0, r1
    a8e4:	e0a22002 	adc	r2, r2, r2
    a8e8:	20400001 	subcs	r0, r0, r1
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1110
    a8ec:	e1a00002 	mov	r0, r2
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1111
    a8f0:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1114
    a8f4:	03a00001 	moveq	r0, #1
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1115
    a8f8:	13a00000 	movne	r0, #0
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1116
    a8fc:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1118
    a900:	e16f2f11 	clz	r2, r1
    a904:	e262201f 	rsb	r2, r2, #31
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1120
    a908:	e1a00230 	lsr	r0, r0, r2
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1121
    a90c:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1125
    a910:	e3500000 	cmp	r0, #0
    a914:	13e00000 	mvnne	r0, #0
    a918:	ea000007 	b	a93c <__aeabi_idiv0>

0000a91c <__aeabi_uidivmod>:
__aeabi_uidivmod():
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1156
    a91c:	e3510000 	cmp	r1, #0
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1157
    a920:	0afffffa 	beq	a910 <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1158
    a924:	e92d4003 	push	{r0, r1, lr}
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1159
    a928:	ebffff80 	bl	a730 <__udivsi3>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1160
    a92c:	e8bd4006 	pop	{r1, r2, lr}
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1161
    a930:	e0030092 	mul	r3, r2, r0
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1162
    a934:	e0411003 	sub	r1, r1, r3
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1163
    a938:	e12fff1e 	bx	lr

0000a93c <__aeabi_idiv0>:
__aeabi_ldiv0():
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1461
    a93c:	e12fff1e 	bx	lr

Disassembly of section .ARM.extab:

0000a940 <.ARM.extab>:
    a940:	81019b40 	tsthi	r1, r0, asr #22
    a944:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    a948:	00000000 	andeq	r0, r0, r0
    a94c:	81019b40 	tsthi	r1, r0, asr #22
    a950:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    a954:	00000000 	andeq	r0, r0, r0
    a958:	81019b40 	tsthi	r1, r0, asr #22
    a95c:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    a960:	00000000 	andeq	r0, r0, r0
    a964:	81019b40 	tsthi	r1, r0, asr #22
    a968:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    a96c:	00000000 	andeq	r0, r0, r0
    a970:	81019b40 	tsthi	r1, r0, asr #22
    a974:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    a978:	00000000 	andeq	r0, r0, r0
    a97c:	81019b40 	tsthi	r1, r0, asr #22
    a980:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    a984:	00000000 	andeq	r0, r0, r0
    a988:	81019b40 	tsthi	r1, r0, asr #22
    a98c:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    a990:	00000000 	andeq	r0, r0, r0
    a994:	81019b40 	tsthi	r1, r0, asr #22
    a998:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    a99c:	00000000 	andeq	r0, r0, r0
    a9a0:	81019b40 	tsthi	r1, r0, asr #22
    a9a4:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    a9a8:	00000000 	andeq	r0, r0, r0
    a9ac:	81019b40 	tsthi	r1, r0, asr #22
    a9b0:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    a9b4:	00000000 	andeq	r0, r0, r0
    a9b8:	81019b40 	tsthi	r1, r0, asr #22
    a9bc:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    a9c0:	00000000 	andeq	r0, r0, r0
    a9c4:	81019b40 	tsthi	r1, r0, asr #22
    a9c8:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    a9cc:	00000000 	andeq	r0, r0, r0
    a9d0:	81019b40 	tsthi	r1, r0, asr #22
    a9d4:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    a9d8:	00000000 	andeq	r0, r0, r0
    a9dc:	81019b40 	tsthi	r1, r0, asr #22
    a9e0:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    a9e4:	00000000 	andeq	r0, r0, r0
    a9e8:	81019b40 	tsthi	r1, r0, asr #22
    a9ec:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    a9f0:	00000000 	andeq	r0, r0, r0
    a9f4:	81019b40 	tsthi	r1, r0, asr #22
    a9f8:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    a9fc:	00000000 	andeq	r0, r0, r0

Disassembly of section .ARM.exidx:

0000aa00 <.ARM.exidx>:
    aa00:	7fffd6ac 	svcvc	0x00ffd6ac
    aa04:	00000001 	andeq	r0, r0, r1
    aa08:	7fffe66c 	svcvc	0x00ffe66c
    aa0c:	7fffff34 	svcvc	0x00ffff34
    aa10:	7fffe6b4 	svcvc	0x00ffe6b4
    aa14:	00000001 	andeq	r0, r0, r1
    aa18:	7fffe774 	svcvc	0x00ffe774
    aa1c:	7fffff30 	svcvc	0x00ffff30
    aa20:	7fffe79c 	svcvc	0x00ffe79c
    aa24:	00000001 	andeq	r0, r0, r1
    aa28:	7fffe9a8 	svcvc	0x00ffe9a8
    aa2c:	7fffff2c 	svcvc	0x00ffff2c
    aa30:	7fffe9fc 	svcvc	0x00ffe9fc
    aa34:	7fffff30 	svcvc	0x00ffff30
    aa38:	7fffea5c 	svcvc	0x00ffea5c
    aa3c:	7fffff34 	svcvc	0x00ffff34
    aa40:	7fffeabc 	svcvc	0x00ffeabc
    aa44:	7fffff38 	svcvc	0x00ffff38
    aa48:	7fffeb1c 	svcvc	0x00ffeb1c
    aa4c:	7fffff3c 	svcvc	0x00ffff3c
    aa50:	7fffeb7c 	svcvc	0x00ffeb7c
    aa54:	7fffff40 	svcvc	0x00ffff40
    aa58:	7fffec50 	svcvc	0x00ffec50
    aa5c:	7fffff44 	svcvc	0x00ffff44
    aa60:	7fffec7c 	svcvc	0x00ffec7c
    aa64:	7fffff48 	svcvc	0x00ffff48
    aa68:	7fffecdc 	svcvc	0x00ffecdc
    aa6c:	00000001 	andeq	r0, r0, r1
    aa70:	7ffff430 	svcvc	0x00fff430
    aa74:	7fffff44 	svcvc	0x00ffff44
    aa78:	7ffff520 	svcvc	0x00fff520
    aa7c:	7fffff48 	svcvc	0x00ffff48
    aa80:	7ffff64c 	svcvc	0x00fff64c
    aa84:	7fffff4c 	svcvc	0x00ffff4c
    aa88:	7ffff7ac 	svcvc	0x00fff7ac
    aa8c:	7fffff50 	svcvc	0x00ffff50
    aa90:	7ffff8a8 	svcvc	0x00fff8a8
    aa94:	00000001 	andeq	r0, r0, r1
    aa98:	7ffffa74 	svcvc	0x00fffa74
    aa9c:	7fffff4c 	svcvc	0x00ffff4c
    aaa0:	7ffffac4 	svcvc	0x00fffac4
    aaa4:	7fffff50 	svcvc	0x00ffff50
    aaa8:	7ffffb14 	svcvc	0x00fffb14
    aaac:	00000001 	andeq	r0, r0, r1

Disassembly of section .rodata:

0000aab0 <_ZN3halL18Default_Clock_RateE>:
    aab0:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

0000aab4 <_ZN3halL15Peripheral_BaseE>:
    aab4:	20000000 	andcs	r0, r0, r0

0000aab8 <_ZN3halL9GPIO_BaseE>:
    aab8:	20200000 	eorcs	r0, r0, r0

0000aabc <_ZN3halL14GPIO_Pin_CountE>:
    aabc:	00000036 	andeq	r0, r0, r6, lsr r0

0000aac0 <_ZN3halL8AUX_BaseE>:
    aac0:	20215000 	eorcs	r5, r1, r0

0000aac4 <_ZN3halL25Interrupt_Controller_BaseE>:
    aac4:	2000b200 	andcs	fp, r0, r0, lsl #4

0000aac8 <_ZN3halL10Timer_BaseE>:
    aac8:	2000b400 	andcs	fp, r0, r0, lsl #8

0000aacc <_ZZN8CMonitorlsEjE11BUFFER_SIZE>:
    aacc:	00000010 	andeq	r0, r0, r0, lsl r0
    aad0:	65757274 	ldrbvs	r7, [r5, #-628]!	; 0xfffffd8c
    aad4:	00000000 	andeq	r0, r0, r0
    aad8:	736c6166 	cmnvc	ip, #-2147483623	; 0x80000019
    aadc:	00000065 	andeq	r0, r0, r5, rrx
    aae0:	33323130 	teqcc	r2, #48, 2
    aae4:	37363534 			; <UNDEFINED> instruction: 0x37363534
    aae8:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    aaec:	46454443 	strbmi	r4, [r5], -r3, asr #8
    aaf0:	00000000 	andeq	r0, r0, r0

0000aaf4 <_ZN3halL18Default_Clock_RateE>:
    aaf4:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

0000aaf8 <_ZN3halL15Peripheral_BaseE>:
    aaf8:	20000000 	andcs	r0, r0, r0

0000aafc <_ZN3halL9GPIO_BaseE>:
    aafc:	20200000 	eorcs	r0, r0, r0

0000ab00 <_ZN3halL14GPIO_Pin_CountE>:
    ab00:	00000036 	andeq	r0, r0, r6, lsr r0

0000ab04 <_ZN3halL8AUX_BaseE>:
    ab04:	20215000 	eorcs	r5, r1, r0

0000ab08 <_ZN3halL25Interrupt_Controller_BaseE>:
    ab08:	2000b200 	andcs	fp, r0, r0, lsl #4

0000ab0c <_ZN3halL10Timer_BaseE>:
    ab0c:	2000b400 	andcs	fp, r0, r0, lsl #8

0000ab10 <_ZN3halL18Default_Clock_RateE>:
    ab10:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

0000ab14 <_ZN3halL15Peripheral_BaseE>:
    ab14:	20000000 	andcs	r0, r0, r0

0000ab18 <_ZN3halL9GPIO_BaseE>:
    ab18:	20200000 	eorcs	r0, r0, r0

0000ab1c <_ZN3halL14GPIO_Pin_CountE>:
    ab1c:	00000036 	andeq	r0, r0, r6, lsr r0

0000ab20 <_ZN3halL8AUX_BaseE>:
    ab20:	20215000 	eorcs	r5, r1, r0

0000ab24 <_ZN3halL25Interrupt_Controller_BaseE>:
    ab24:	2000b200 	andcs	fp, r0, r0, lsl #4

0000ab28 <_ZN3halL10Timer_BaseE>:
    ab28:	2000b400 	andcs	fp, r0, r0, lsl #8

0000ab2c <_ZN3halL18Default_Clock_RateE>:
    ab2c:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

0000ab30 <_ZN3halL15Peripheral_BaseE>:
    ab30:	20000000 	andcs	r0, r0, r0

0000ab34 <_ZN3halL9GPIO_BaseE>:
    ab34:	20200000 	eorcs	r0, r0, r0

0000ab38 <_ZN3halL14GPIO_Pin_CountE>:
    ab38:	00000036 	andeq	r0, r0, r6, lsr r0

0000ab3c <_ZN3halL8AUX_BaseE>:
    ab3c:	20215000 	eorcs	r5, r1, r0

0000ab40 <_ZN3halL25Interrupt_Controller_BaseE>:
    ab40:	2000b200 	andcs	fp, r0, r0, lsl #4

0000ab44 <_ZN3halL10Timer_BaseE>:
    ab44:	2000b400 	andcs	fp, r0, r0, lsl #8

0000ab48 <_ZN3memL9LowMemoryE>:
    ab48:	00020000 	andeq	r0, r2, r0

0000ab4c <_ZN3memL10HighMemoryE>:
    ab4c:	20000000 	andcs	r0, r0, r0

0000ab50 <_ZN3memL8PageSizeE>:
    ab50:	00004000 	andeq	r4, r0, r0

0000ab54 <_ZN3memL16PagingMemorySizeE>:
    ab54:	1ffe0000 	svcne	0x00fe0000

0000ab58 <_ZN3memL9PageCountE>:
    ab58:	00007ff8 	strdeq	r7, [r0], -r8

0000ab5c <_ZL7ACT_Pin>:
    ab5c:	0000002f 	andeq	r0, r0, pc, lsr #32
    ab60:	636f7250 	cmnvs	pc, #80, 4
    ab64:	20737365 	rsbscs	r7, r3, r5, ror #6
    ab68:	00000a31 	andeq	r0, r0, r1, lsr sl
    ab6c:	636f7250 	cmnvs	pc, #80, 4
    ab70:	20737365 	rsbscs	r7, r3, r5, ror #6
    ab74:	00000a32 	andeq	r0, r0, r2, lsr sl
    ab78:	636f7250 	cmnvs	pc, #80, 4
    ab7c:	20737365 	rsbscs	r7, r3, r5, ror #6
    ab80:	00000a33 	andeq	r0, r0, r3, lsr sl
    ab84:	636f7250 	cmnvs	pc, #80, 4
    ab88:	20737365 	rsbscs	r7, r3, r5, ror #6
    ab8c:	00000a34 	andeq	r0, r0, r4, lsr sl
    ab90:	636c6557 	cmnvs	ip, #364904448	; 0x15c00000
    ab94:	20656d6f 	rsbcs	r6, r5, pc, ror #26
    ab98:	4b206f74 	blmi	826970 <_bss_end+0x81ac74>
    ab9c:	4f2f5649 	svcmi	0x002f5649
    aba0:	50522053 	subspl	r2, r2, r3, asr r0
    aba4:	20534f69 	subscs	r4, r3, r9, ror #30
    aba8:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
    abac:	000a6c65 	andeq	r6, sl, r5, ror #24

0000abb0 <_ZN3halL18Default_Clock_RateE>:
    abb0:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

0000abb4 <_ZN3halL15Peripheral_BaseE>:
    abb4:	20000000 	andcs	r0, r0, r0

0000abb8 <_ZN3halL9GPIO_BaseE>:
    abb8:	20200000 	eorcs	r0, r0, r0

0000abbc <_ZN3halL14GPIO_Pin_CountE>:
    abbc:	00000036 	andeq	r0, r0, r6, lsr r0

0000abc0 <_ZN3halL8AUX_BaseE>:
    abc0:	20215000 	eorcs	r5, r1, r0

0000abc4 <_ZN3halL25Interrupt_Controller_BaseE>:
    abc4:	2000b200 	andcs	fp, r0, r0, lsl #4

0000abc8 <_ZN3halL10Timer_BaseE>:
    abc8:	2000b400 	andcs	fp, r0, r0, lsl #8

0000abcc <_ZN3memL9LowMemoryE>:
    abcc:	00020000 	andeq	r0, r2, r0

0000abd0 <_ZN3memL10HighMemoryE>:
    abd0:	20000000 	andcs	r0, r0, r0

0000abd4 <_ZN3memL8PageSizeE>:
    abd4:	00004000 	andeq	r4, r0, r0

0000abd8 <_ZN3memL16PagingMemorySizeE>:
    abd8:	1ffe0000 	svcne	0x00fe0000

0000abdc <_ZN3memL9PageCountE>:
    abdc:	00007ff8 	strdeq	r7, [r0], -r8

0000abe0 <_ZN3halL18Default_Clock_RateE>:
    abe0:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

0000abe4 <_ZN3halL15Peripheral_BaseE>:
    abe4:	20000000 	andcs	r0, r0, r0

0000abe8 <_ZN3halL9GPIO_BaseE>:
    abe8:	20200000 	eorcs	r0, r0, r0

0000abec <_ZN3halL14GPIO_Pin_CountE>:
    abec:	00000036 	andeq	r0, r0, r6, lsr r0

0000abf0 <_ZN3halL8AUX_BaseE>:
    abf0:	20215000 	eorcs	r5, r1, r0

0000abf4 <_ZN3halL25Interrupt_Controller_BaseE>:
    abf4:	2000b200 	andcs	fp, r0, r0, lsl #4

0000abf8 <_ZN3halL10Timer_BaseE>:
    abf8:	2000b400 	andcs	fp, r0, r0, lsl #8

0000abfc <_ZN3memL9LowMemoryE>:
    abfc:	00020000 	andeq	r0, r2, r0

0000ac00 <_ZN3memL10HighMemoryE>:
    ac00:	20000000 	andcs	r0, r0, r0

0000ac04 <_ZN3memL8PageSizeE>:
    ac04:	00004000 	andeq	r4, r0, r0

0000ac08 <_ZN3memL16PagingMemorySizeE>:
    ac08:	1ffe0000 	svcne	0x00fe0000

0000ac0c <_ZN3memL9PageCountE>:
    ac0c:	00007ff8 	strdeq	r7, [r0], -r8

0000ac10 <_ZN3halL18Default_Clock_RateE>:
    ac10:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

0000ac14 <_ZN3halL15Peripheral_BaseE>:
    ac14:	20000000 	andcs	r0, r0, r0

0000ac18 <_ZN3halL9GPIO_BaseE>:
    ac18:	20200000 	eorcs	r0, r0, r0

0000ac1c <_ZN3halL14GPIO_Pin_CountE>:
    ac1c:	00000036 	andeq	r0, r0, r6, lsr r0

0000ac20 <_ZN3halL8AUX_BaseE>:
    ac20:	20215000 	eorcs	r5, r1, r0

0000ac24 <_ZN3halL25Interrupt_Controller_BaseE>:
    ac24:	2000b200 	andcs	fp, r0, r0, lsl #4

0000ac28 <_ZN3halL10Timer_BaseE>:
    ac28:	2000b400 	andcs	fp, r0, r0, lsl #8

0000ac2c <_ZN3memL9LowMemoryE>:
    ac2c:	00020000 	andeq	r0, r2, r0

0000ac30 <_ZN3memL10HighMemoryE>:
    ac30:	20000000 	andcs	r0, r0, r0

0000ac34 <_ZN3memL8PageSizeE>:
    ac34:	00004000 	andeq	r4, r0, r0

0000ac38 <_ZN3memL16PagingMemorySizeE>:
    ac38:	1ffe0000 	svcne	0x00fe0000

0000ac3c <_ZN3memL9PageCountE>:
    ac3c:	00007ff8 	strdeq	r7, [r0], -r8

0000ac40 <_ZN12_GLOBAL__N_1L11CharConvArrE>:
    ac40:	33323130 	teqcc	r2, #48, 2
    ac44:	37363534 			; <UNDEFINED> instruction: 0x37363534
    ac48:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    ac4c:	46454443 	strbmi	r4, [r5], -r3, asr #8
	...

Disassembly of section .ARM.extab.text._ZN20CKernel_Heap_Manager5AllocI18CProcess_List_NodeEEPT_v:

0000ac54 <.ARM.extab.text._ZN20CKernel_Heap_Manager5AllocI18CProcess_List_NodeEEPT_v>:
    ac54:	81019b40 	tsthi	r1, r0, asr #22
    ac58:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    ac5c:	00000000 	andeq	r0, r0, r0

Disassembly of section .ARM.exidx.text._ZN20CKernel_Heap_Manager5AllocI18CProcess_List_NodeEEPT_v:

0000ac60 <.ARM.exidx.text._ZN20CKernel_Heap_Manager5AllocI18CProcess_List_NodeEEPT_v>:
    ac60:	7ffff740 	svcvc	0x00fff740
    ac64:	7ffffff0 	svcvc	0x00fffff0

Disassembly of section .ARM.extab.text._ZN20CKernel_Heap_Manager5AllocI12TTask_StructEEPT_v:

0000ac68 <.ARM.extab.text._ZN20CKernel_Heap_Manager5AllocI12TTask_StructEEPT_v>:
    ac68:	81019b40 	tsthi	r1, r0, asr #22
    ac6c:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    ac70:	00000000 	andeq	r0, r0, r0

Disassembly of section .ARM.exidx.text._ZN20CKernel_Heap_Manager5AllocI12TTask_StructEEPT_v:

0000ac74 <.ARM.exidx.text._ZN20CKernel_Heap_Manager5AllocI12TTask_StructEEPT_v>:
    ac74:	7ffff758 	svcvc	0x00fff758
    ac78:	7ffffff0 	svcvc	0x00fffff0
    ac7c:	7ffff77c 	svcvc	0x00fff77c
    ac80:	00000001 	andeq	r0, r0, r1

Disassembly of section .data:

0000ac84 <__CTOR_LIST__>:
    ac84:	00008698 	muleq	r0, r8, r6
    ac88:	00008cd0 	ldrdeq	r8, [r0], -r0
    ac8c:	00009158 	andeq	r9, r0, r8, asr r1
    ac90:	000093b4 			; <UNDEFINED> instruction: 0x000093b4
    ac94:	000099f8 	strdeq	r9, [r0], -r8
    ac98:	00009df8 	strdeq	r9, [r0], -r8
    ac9c:	0000a384 	andeq	sl, r0, r4, lsl #7

Disassembly of section .bss:

0000aca0 <sGPIO>:
    aca0:	00000000 	andeq	r0, r0, r0

0000aca4 <sMonitor>:
	...

0000acbc <_ZZN8CMonitorlsEjE8s_buffer>:
	...

0000accc <sTimer>:
	...

0000acd4 <sInterruptCtl>:
_ZZN8CMonitorlsEjE8s_buffer():
    acd4:	00000000 	andeq	r0, r0, r0

0000acd8 <LED_State>:
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:14
volatile bool LED_State = false;
    acd8:	00000000 	andeq	r0, r0, r0

0000acdc <sKernelMem>:
    acdc:	00000000 	andeq	r0, r0, r0

0000ace0 <sPage_Manager>:
	...

0000bce0 <sProcessMgr>:
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
      a0:	bb050000 	bllt	1400a8 <_bss_end+0x1343ac>
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
     11c:	0a010067 	beq	402c0 <_bss_end+0x345c4>
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
     184:	1eef0704 	cdpne	7, 14, cr0, cr15, cr4, {0}
     188:	59050000 	stmdbpl	r5, {}	; <UNPREDICTABLE>
     18c:	06000000 	streq	r0, [r0], -r0
     190:	00000059 	andeq	r0, r0, r9, asr r0
     194:	6c616807 	stclvs	8, cr6, [r1], #-28	; 0xffffffe4
     198:	0b070200 	bleq	1c09a0 <_bss_end+0x1b4ca4>
     19c:	000001a5 	andeq	r0, r0, r5, lsr #3
     1a0:	00068008 	andeq	r8, r6, r8
     1a4:	19090200 	stmdbne	r9, {r9}
     1a8:	00000060 	andeq	r0, r0, r0, rrx
     1ac:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}
     1b0:	0003e608 	andeq	lr, r3, r8, lsl #12
     1b4:	1a0c0200 	bne	3009bc <_bss_end+0x2f4cc0>
     1b8:	000001b1 			; <UNDEFINED> instruction: 0x000001b1
     1bc:	20000000 	andcs	r0, r0, r0
     1c0:	0004c408 	andeq	ip, r4, r8, lsl #8
     1c4:	1a0f0200 	bne	3c09cc <_bss_end+0x3b4cd0>
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
     1f8:	0b010000 	bleq	40200 <_bss_end+0x34504>
     1fc:	0000023f 	andeq	r0, r0, pc, lsr r2
     200:	02470b02 	subeq	r0, r7, #2048	; 0x800
     204:	0b030000 	bleq	c020c <_bss_end+0xb4510>
     208:	0000024f 	andeq	r0, r0, pc, asr #4
     20c:	02570b04 	subseq	r0, r7, #4, 22	; 0x1000
     210:	0b050000 	bleq	140218 <_bss_end+0x13451c>
     214:	00000221 	andeq	r0, r0, r1, lsr #4
     218:	02280b07 	eoreq	r0, r8, #7168	; 0x1c00
     21c:	0b080000 	bleq	200224 <_bss_end+0x1f4528>
     220:	000006a5 	andeq	r0, r0, r5, lsr #13
     224:	04ce0b0a 	strbeq	r0, [lr], #2826	; 0xb0a
     228:	0b0b0000 	bleq	2c0230 <_bss_end+0x2b4534>
     22c:	000005c5 	andeq	r0, r0, r5, asr #11
     230:	05cc0b0d 	strbeq	r0, [ip, #2829]	; 0xb0d
     234:	0b0e0000 	bleq	38023c <_bss_end+0x374540>
     238:	0000031b 	andeq	r0, r0, fp, lsl r3
     23c:	03220b10 			; <UNDEFINED> instruction: 0x03220b10
     240:	0b110000 	bleq	440248 <_bss_end+0x43454c>
     244:	0000029e 	muleq	r0, lr, r2
     248:	02a50b13 	adceq	r0, r5, #19456	; 0x4c00
     24c:	0b140000 	bleq	500254 <_bss_end+0x4f4558>
     250:	00000643 	andeq	r0, r0, r3, asr #12
     254:	025f0b16 	subseq	r0, pc, #22528	; 0x5800
     258:	0b170000 	bleq	5c0260 <_bss_end+0x5b4564>
     25c:	000004e5 	andeq	r0, r0, r5, ror #9
     260:	04ec0b19 	strbteq	r0, [ip], #2841	; 0xb19
     264:	0b1a0000 	bleq	68026c <_bss_end+0x674570>
     268:	00000343 	andeq	r0, r0, r3, asr #6
     26c:	05150b1c 	ldreq	r0, [r5, #-2844]	; 0xfffff4e4
     270:	0b1d0000 	bleq	740278 <_bss_end+0x73457c>
     274:	000004d5 	ldrdeq	r0, [r0], -r5
     278:	04dd0b1f 	ldrbeq	r0, [sp], #2847	; 0xb1f
     27c:	0b200000 	bleq	800284 <_bss_end+0x7f4588>
     280:	00000458 	andeq	r0, r0, r8, asr r4
     284:	04600b22 	strbteq	r0, [r0], #-2850	; 0xfffff4de
     288:	0b230000 	bleq	8c0290 <_bss_end+0x8b4594>
     28c:	00000382 	andeq	r0, r0, r2, lsl #7
     290:	028a0b25 	addeq	r0, sl, #37888	; 0x9400
     294:	0b260000 	bleq	98029c <_bss_end+0x9745a0>
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
     2d4:	ea070402 	b	1c12e4 <_bss_end+0x1b55e8>
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
     32c:	7a0b0400 	bvc	2c1334 <_bss_end+0x2b5638>
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
     41c:	2b030000 	blcs	c0424 <_bss_end+0xb4728>
     420:	00030403 	andeq	r0, r3, r3, lsl #8
     424:	0003ca00 	andeq	ip, r3, r0, lsl #20
     428:	03080100 	movweq	r0, #33024	; 0x8100
     42c:	03130000 	tsteq	r3, #0
     430:	ca100000 	bgt	400438 <_bss_end+0x3f473c>
     434:	11000003 	tstne	r0, r3
     438:	00000059 	andeq	r0, r0, r9, asr r0
     43c:	05d31200 	ldrbeq	r1, [r3, #512]	; 0x200
     440:	2e030000 	cdpcs	0, 0, cr0, cr3, cr0, {0}
     444:	00058708 	andeq	r8, r5, r8, lsl #14
     448:	03280100 			; <UNDEFINED> instruction: 0x03280100
     44c:	03380000 	teqeq	r8, #0
     450:	ca100000 	bgt	400458 <_bss_end+0x3f475c>
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
     484:	4a120000 	bmi	48048c <_bss_end+0x474790>
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
     4f8:	ca050000 	bgt	140500 <_bss_end+0x134804>
     4fc:	16000003 	strne	r0, [r0], -r3
     500:	000004b4 			; <UNDEFINED> instruction: 0x000004b4
     504:	1d163a03 	vldrne	s6, [r6, #-12]
     508:	17000002 	strne	r0, [r0, -r2]
     50c:	000003d5 	ldrdeq	r0, [r0], -r5
     510:	050f0401 	streq	r0, [pc, #-1025]	; 117 <CPSR_IRQ_INHIBIT+0x97>
     514:	00aca003 	adceq	sl, ip, r3
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
     624:	3b9c0100 	blcc	fe700a2c <_bss_end+0xfe6f4d30>
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
     678:	bb9c0100 	bllt	fe700a80 <_bss_end+0xfe6f4d84>
     67c:	1c000005 	stcne	0, cr0, [r0], {5}
     680:	00000582 	andeq	r0, r0, r2, lsl #11
     684:	000003d0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     688:	1d649102 	stfnep	f1, [r4, #-8]!
     68c:	006e6970 	rsbeq	r6, lr, r0, ror r9
     690:	48304201 	ldmdami	r0!, {r0, r9, lr}
     694:	02000000 	andeq	r0, r0, #0
     698:	4a1a6091 	bmi	6988e4 <_bss_end+0x68cbe8>
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
     6d8:	4a010064 	bmi	40870 <_bss_end+0x34b74>
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
     7f4:	0b9c0100 	bleq	fe700bfc <_bss_end+0xfe6f4f00>
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
     904:	1b0c0200 	blne	30110c <_bss_end+0x2f5410>
     908:	00000052 	andeq	r0, r0, r2, asr r0
     90c:	5f090a01 	svcpl	0x00090a01
     910:	02000008 	andeq	r0, r0, #8
     914:	02c8280d 	sbceq	r2, r8, #851968	; 0xd0000
     918:	0a010000 	beq	40920 <_bss_end+0x34c24>
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
     948:	0b0e0d00 	bleq	383d50 <_bss_end+0x378054>
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
     a10:	ea0c0000 	b	300a18 <_bss_end+0x2f4d1c>
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
     ad4:	0a240200 	beq	9012dc <_bss_end+0x8f55e0>
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
     b3c:	1eef0704 	cdpne	7, 14, cr0, cr15, cr4, {0}
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
     ba8:	00aca403 	adceq	sl, ip, r3, lsl #8
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
     c18:	1a649102 	bne	1925028 <_bss_end+0x191932c>
     c1c:	00000907 	andeq	r0, r0, r7, lsl #18
     c20:	b622b101 	strtlt	fp, [r2], -r1, lsl #2
     c24:	02000002 	andeq	r0, r0, #2
     c28:	001a6091 	mulseq	sl, r1, r0
     c2c:	01000009 	tsteq	r0, r9
     c30:	02f12fb1 	rscseq	r2, r1, #708	; 0x2c4
     c34:	91020000 	mrsls	r0, (UNDEF: 2)
     c38:	0b971a5c 	bleq	fe5c75b0 <_bss_end+0xfe5bb8b4>
     c3c:	b1010000 	mrslt	r0, (UNDEF: 1)
     c40:	0002b644 	andeq	fp, r2, r4, asr #12
     c44:	58910200 	ldmpl	r1, {r9}
     c48:	0100691e 	tsteq	r0, lr, lsl r9
     c4c:	036909b3 	cmneq	r9, #2932736	; 0x2cc000
     c50:	91020000 	mrsls	r0, (UNDEF: 2)
     c54:	8bdc1f74 	blhi	ff708a2c <_bss_end+0xff6fcd30>
     c58:	008c0000 	addeq	r0, ip, r0
     c5c:	6a1e0000 	bvs	780c64 <_bss_end+0x774f68>
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
     d38:	1a749102 	bne	1d25148 <_bss_end+0x1d1944c>
     d3c:	000006b3 			; <UNDEFINED> instruction: 0x000006b3
     d40:	ea257701 	b	95e94c <_bss_end+0x952c50>
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
     d74:	6a01006d 	bvs	40f30 <_bss_end+0x35234>
     d78:	0002b62d 	andeq	fp, r2, sp, lsr #12
     d7c:	70910200 	addsvc	r0, r1, r0, lsl #4
     d80:	00097723 	andeq	r7, r9, r3, lsr #14
     d84:	236c0100 	cmncs	ip, #0, 2
     d88:	000002bd 			; <UNDEFINED> instruction: 0x000002bd
     d8c:	aacc0305 	bge	ff3019a8 <_bss_end+0xff2f5cac>
     d90:	0d220000 	stceq	0, cr0, [r2, #-0]
     d94:	01000009 	tsteq	r0, r9
     d98:	0520116e 	streq	r1, [r0, #-366]!	; 0xfffffe92
     d9c:	03050000 	movweq	r0, #20480	; 0x5000
     da0:	0000acbc 			; <UNDEFINED> instruction: 0x0000acbc
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
     dd8:	1a749102 	bne	1d251e8 <_bss_end+0x1d194ec>
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
     e3c:	0b450100 	bleq	1141244 <_bss_end+0x1135548>
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
     f70:	1a010078 	bne	41158 <_bss_end+0x3545c>
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
    1090:	1eef0704 	cdpne	7, 14, cr0, cr15, cr4, {0}
    1094:	71050000 	mrsvc	r0, (UNDEF: 5)
    1098:	06000000 	streq	r0, [r0], -r0
    109c:	00000071 	andeq	r0, r0, r1, ror r0
    10a0:	6c616807 	stclvs	8, cr6, [r1], #-28	; 0xffffffe4
    10a4:	0b070300 	bleq	1c1cac <_bss_end+0x1b5fb0>
    10a8:	00000141 	andeq	r0, r0, r1, asr #2
    10ac:	00068008 	andeq	r8, r6, r8
    10b0:	19090300 	stmdbne	r9, {r8, r9}
    10b4:	00000078 	andeq	r0, r0, r8, ror r0
    10b8:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}
    10bc:	0003e608 	andeq	lr, r3, r8, lsl #12
    10c0:	1a0c0300 	bne	301cc8 <_bss_end+0x2f5fcc>
    10c4:	0000014d 	andeq	r0, r0, sp, asr #2
    10c8:	20000000 	andcs	r0, r0, r0
    10cc:	0004c408 	andeq	ip, r4, r8, lsl #8
    10d0:	1a0f0300 	bne	3c1cd8 <_bss_end+0x3b5fdc>
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
    1118:	0b6e0a20 	bleq	1b839a0 <_bss_end+0x1b77ca4>
    111c:	04050000 	streq	r0, [r5], #-0
    1120:	00000033 	andeq	r0, r0, r3, lsr r0
    1124:	0b0da803 	bleq	36b138 <_bss_end+0x35f43c>
    1128:	00000bbb 			; <UNDEFINED> instruction: 0x00000bbb
    112c:	0b410b00 	bleq	1043d34 <_bss_end+0x1038038>
    1130:	0b010000 	bleq	41138 <_bss_end+0x3543c>
    1134:	00000fc7 	andeq	r0, r0, r7, asr #31
    1138:	0b0a0b02 	bleq	283d48 <_bss_end+0x27804c>
    113c:	0b030000 	bleq	c1144 <_bss_end+0xb5448>
    1140:	00000c33 	andeq	r0, r0, r3, lsr ip
    1144:	0a480b04 	beq	1203d5c <_bss_end+0x11f8060>
    1148:	0b050000 	bleq	141150 <_bss_end+0x135454>
    114c:	00000a34 	andeq	r0, r0, r4, lsr sl
    1150:	0b620b06 	bleq	1883d70 <_bss_end+0x1878074>
    1154:	0b070000 	bleq	1c115c <_bss_end+0x1b5460>
    1158:	00000c01 	andeq	r0, r0, r1, lsl #24
    115c:	0c000008 	stceq	0, cr0, [r0], {8}
    1160:	0000008e 	andeq	r0, r0, lr, lsl #1
    1164:	ea070402 	b	1c2174 <_bss_end+0x1b6478>
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
    12e4:	accc0305 	stclge	3, cr0, [ip], {5}
    12e8:	aa1b0000 	bge	6c12f0 <_bss_end+0x6b55f4>
    12ec:	0600000b 	streq	r0, [r0], -fp
    12f0:	9a080801 	bls	2032fc <_bss_end+0x1f7600>
    12f4:	1c000003 	stcne	0, cr0, [r0], {3}
    12f8:	00000a61 	andeq	r0, r0, r1, ror #20
    12fc:	3a0d0a01 	bcc	343b08 <_bss_end+0x337e0c>
    1300:	01000000 	mrseq	r0, (UNDEF: 0)
    1304:	1c000701 	stcne	7, cr0, [r0], {1}
    1308:	00000a8e 	andeq	r0, r0, lr, lsl #21
    130c:	3a0d0b01 	bcc	343f18 <_bss_end+0x33821c>
    1310:	01000000 	mrseq	r0, (UNDEF: 0)
    1314:	1c000601 	stcne	6, cr0, [r0], {1}
    1318:	00000ae0 	andeq	r0, r0, r0, ror #21
    131c:	3a0d0c01 	bcc	344328 <_bss_end+0x33862c>
    1320:	01000000 	mrseq	r0, (UNDEF: 0)
    1324:	1c000402 	cfstrsne	mvf0, [r0], {2}
    1328:	00000a6a 	andeq	r0, r0, sl, ror #20
    132c:	3a0d0d01 	bcc	344738 <_bss_end+0x338a3c>
    1330:	01000000 	mrseq	r0, (UNDEF: 0)
    1334:	1c000301 	stcne	3, cr0, [r0], {1}
    1338:	00000b47 	andeq	r0, r0, r7, asr #22
    133c:	3a0d0e01 	bcc	344b48 <_bss_end+0x338e4c>
    1340:	01000000 	mrseq	r0, (UNDEF: 0)
    1344:	1c000201 	sfmne	f0, 4, [r0], {1}
    1348:	00000a73 	andeq	r0, r0, r3, ror sl
    134c:	3a0d0f01 	bcc	344f58 <_bss_end+0x33925c>
    1350:	01000000 	mrseq	r0, (UNDEF: 0)
    1354:	1c000101 	stfnes	f0, [r0], {1}
    1358:	00000b9c 	muleq	r0, ip, fp
    135c:	3a0d1001 	bcc	345368 <_bss_end+0x33966c>
    1360:	01000000 	mrseq	r0, (UNDEF: 0)
    1364:	1c000001 	stcne	0, cr0, [r0], {1}
    1368:	00000b21 	andeq	r0, r0, r1, lsr #22
    136c:	3a0d1101 	bcc	345778 <_bss_end+0x339a7c>
    1370:	01000000 	mrseq	r0, (UNDEF: 0)
    1374:	1c010701 	stcne	7, cr0, [r1], {1}
    1378:	00000af6 	strdeq	r0, [r0], -r6
    137c:	3a0d1201 	bcc	345b88 <_bss_end+0x339e8c>
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
    14bc:	0a532060 	beq	14c9644 <_bss_end+0x14bd948>
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
    1524:	1a010000 	bne	4152c <_bss_end+0x35830>
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
    155c:	2a9c0100 	bcs	fe701964 <_bss_end+0xfe6f5c68>
    1560:	00000514 	andeq	r0, r0, r4, lsl r5
    1564:	2a749102 	bcs	1d25974 <_bss_end+0x1d19c78>
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
    1590:	0a220000 	beq	881598 <_bss_end+0x87589c>
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
    15c8:	0b020000 	bleq	815d0 <_bss_end+0x758d4>
    15cc:	00006507 	andeq	r6, r0, r7, lsl #10
    15d0:	00540500 	subseq	r0, r4, r0, lsl #10
    15d4:	04020000 	streq	r0, [r2], #-0
    15d8:	001eef07 	andseq	lr, lr, r7, lsl #30
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
    1634:	1a440300 	bne	110223c <_bss_end+0x10f6540>
    1638:	00000234 	andeq	r0, r0, r4, lsr r2
    163c:	20215000 	eorcs	r5, r1, r0
    1640:	00026608 	andeq	r6, r2, r8, lsl #12
    1644:	1a730300 	bne	1cc224c <_bss_end+0x1cb6550>
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
    1690:	9b0b0700 	blls	2c3298 <_bss_end+0x2b759c>
    1694:	0800000d 	stmdaeq	r0, {r0, r2, r3}
    1698:	000f740b 	andeq	r7, pc, fp, lsl #8
    169c:	0a000900 	beq	3aa4 <CPSR_IRQ_INHIBIT+0x3a24>
    16a0:	00000e30 	andeq	r0, r0, r0, lsr lr
    16a4:	00330405 	eorseq	r0, r3, r5, lsl #8
    16a8:	83030000 	movwhi	r0, #12288	; 0x3000
    16ac:	0001710d 	andeq	r7, r1, sp, lsl #2
    16b0:	0bc10b00 	bleq	ff0442b8 <_bss_end+0xff0385bc>
    16b4:	0b000000 	bleq	16bc <CPSR_IRQ_INHIBIT+0x163c>
    16b8:	00000ed7 	ldrdeq	r0, [r0], -r7
    16bc:	0d620b01 	fstmdbxeq	r2!, {d16-d15}	;@ Deprecated
    16c0:	0b020000 	bleq	816c8 <_bss_end+0x759cc>
    16c4:	00000d74 	andeq	r0, r0, r4, ror sp
    16c8:	10710b03 	rsbsne	r0, r1, r3, lsl #22
    16cc:	0b040000 	bleq	1016d4 <_bss_end+0xf59d8>
    16d0:	00000eb6 			; <UNDEFINED> instruction: 0x00000eb6
    16d4:	0e7b0b05 	vaddeq.f64	d16, d11, d5
    16d8:	0b060000 	bleq	1816e0 <_bss_end+0x1759e4>
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
    1760:	0bbb0b0d 	bleq	feec439c <_bss_end+0xfeeb86a0>
    1764:	0b000000 	bleq	176c <CPSR_IRQ_INHIBIT+0x16ec>
    1768:	00000b41 	andeq	r0, r0, r1, asr #22
    176c:	0fc70b01 	svceq	0x00c70b01
    1770:	0b020000 	bleq	81778 <_bss_end+0x75a7c>
    1774:	00000b0a 	andeq	r0, r0, sl, lsl #22
    1778:	0c330b03 			; <UNDEFINED> instruction: 0x0c330b03
    177c:	0b040000 	bleq	101784 <_bss_end+0xf5a88>
    1780:	00000a48 	andeq	r0, r0, r8, asr #20
    1784:	0a340b05 	beq	d043a0 <_bss_end+0xcf86a4>
    1788:	0b060000 	bleq	181790 <_bss_end+0x175a94>
    178c:	00000b62 	andeq	r0, r0, r2, ror #22
    1790:	0c010b07 			; <UNDEFINED> instruction: 0x0c010b07
    1794:	00080000 	andeq	r0, r8, r0
    1798:	00820e00 	addeq	r0, r2, r0, lsl #28
    179c:	04020000 	streq	r0, [r2], #-0
    17a0:	001eea07 	andseq	lr, lr, r7, lsl #20
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
    17f0:	8a020000 	bhi	817f8 <_bss_end+0x75afc>
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
    1894:	2a010000 	bcs	4189c <_bss_end+0x35ba0>
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
    1a10:	00acd403 	adceq	sp, ip, r3, lsl #8
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
    1bd8:	1a010000 	bne	41be0 <_bss_end+0x35ee4>
    1bdc:	0091bc33 	addseq	fp, r1, r3, lsr ip
    1be0:	00001000 	andeq	r1, r0, r0
    1be4:	2b9c0100 	blcs	fe701fec <_bss_end+0xfe6f62f0>
    1be8:	00000fcf 	andeq	r0, r0, pc, asr #31
    1bec:	8c111001 	ldchi	0, cr1, [r1], {1}
    1bf0:	30000091 	mulcc	r0, r1, r0
    1bf4:	01000000 	mrseq	r0, (UNDEF: 0)
    1bf8:	0fe52a9c 	svceq	0x00e52a9c
    1bfc:	0b010000 	bleq	41c04 <_bss_end+0x35f08>
    1c00:	00917433 	addseq	r7, r1, r3, lsr r4
    1c04:	00001800 	andeq	r1, r0, r0, lsl #16
    1c08:	009c0100 	addseq	r0, ip, r0, lsl #2
    1c0c:	00000d91 	muleq	r0, r1, sp
    1c10:	0b430004 	bleq	10c1c28 <_bss_end+0x10b5f2c>
    1c14:	01040000 	mrseq	r0, (UNDEF: 4)
    1c18:	00000000 	andeq	r0, r0, r0
    1c1c:	0013d304 	andseq	sp, r3, r4, lsl #6
    1c20:	0000b600 	andeq	fp, r0, r0, lsl #12
    1c24:	0093d000 	addseq	sp, r3, r0
    1c28:	0002d800 	andeq	sp, r2, r0, lsl #16
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
    1c80:	ef070402 	svc	0x00070402
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
    1d8c:	8b020000 	blhi	81d94 <_bss_end+0x76098>
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
    1e2c:	7b0c0000 	blvc	301e34 <_bss_end+0x2f6138>
    1e30:	0d000002 	stceq	0, cr0, [r0, #-8]
    1e34:	00000063 	andeq	r0, r0, r3, rrx
    1e38:	0002630d 	andeq	r6, r2, sp, lsl #6
    1e3c:	ba0f0000 	blt	3c1e44 <_bss_end+0x3b6148>
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
    1e90:	3a030000 	bcc	c1e98 <_bss_end+0xb619c>
    1e94:	0000ce16 	andeq	ip, r0, r6, lsl lr
    1e98:	07f80900 	ldrbeq	r0, [r8, r0, lsl #18]!
    1e9c:	04180000 	ldreq	r0, [r8], #-0
    1ea0:	051e0703 	ldreq	r0, [lr, #-1795]	; 0xfffff8fd
    1ea4:	54130000 	ldrpl	r0, [r3], #-0
    1ea8:	07000007 	streq	r0, [r0, -r7]
    1eac:	00007404 	andeq	r7, r0, r4, lsl #8
    1eb0:	10060400 	andne	r0, r6, r0, lsl #8
    1eb4:	0002ba01 	andeq	fp, r2, r1, lsl #20
    1eb8:	45481400 	strbmi	r1, [r8, #-1024]	; 0xfffffc00
    1ebc:	14100058 	ldrne	r0, [r0], #-88	; 0xffffffa8
    1ec0:	00434544 	subeq	r4, r3, r4, asr #10
    1ec4:	9a03000a 	bls	c1ef4 <_bss_end+0xb61f8>
    1ec8:	15000002 	strne	r0, [r0, #-2]
    1ecc:	00000761 	andeq	r0, r0, r1, ror #14
    1ed0:	0c270408 	cfstrseq	mvf0, [r7], #-32	; 0xffffffe0
    1ed4:	000002e3 	andeq	r0, r0, r3, ror #5
    1ed8:	04007916 	streq	r7, [r0], #-2326	; 0xfffff6ea
    1edc:	00741629 	rsbseq	r1, r4, r9, lsr #12
    1ee0:	16000000 	strne	r0, [r0], -r0
    1ee4:	2a040078 	bcs	1020cc <_bss_end+0xf63d0>
    1ee8:	00007416 	andeq	r7, r0, r6, lsl r4
    1eec:	17000400 	strne	r0, [r0, -r0, lsl #8]
    1ef0:	000008ec 	andeq	r0, r0, ip, ror #17
    1ef4:	ba1b0c04 	blt	6c4f0c <_bss_end+0x6b9210>
    1ef8:	01000002 	tsteq	r0, r2
    1efc:	085f180a 	ldmdaeq	pc, {r1, r3, fp, ip}^	; <UNPREDICTABLE>
    1f00:	0d040000 	stceq	0, cr0, [r4, #-0]
    1f04:	00052428 	andeq	r2, r5, r8, lsr #8
    1f08:	f8190100 			; <UNDEFINED> instruction: 0xf8190100
    1f0c:	04000007 	streq	r0, [r0], #-7
    1f10:	08d90e10 	ldmeq	r9, {r4, r9, sl, fp}^
    1f14:	05290000 	streq	r0, [r9, #-0]!
    1f18:	17010000 	strne	r0, [r1, -r0]
    1f1c:	2c000003 	stccs	0, cr0, [r0], {3}
    1f20:	0c000003 	stceq	0, cr0, [r0], {3}
    1f24:	00000529 	andeq	r0, r0, r9, lsr #10
    1f28:	0000740d 	andeq	r7, r0, sp, lsl #8
    1f2c:	00740d00 	rsbseq	r0, r4, r0, lsl #26
    1f30:	740d0000 	strvc	r0, [sp], #-0
    1f34:	00000000 	andeq	r0, r0, r0
    1f38:	000b0e0e 	andeq	r0, fp, lr, lsl #28
    1f3c:	0a120400 	beq	482f44 <_bss_end+0x477248>
    1f40:	000007c1 	andeq	r0, r0, r1, asr #15
    1f44:	00034101 	andeq	r4, r3, r1, lsl #2
    1f48:	00034700 	andeq	r4, r3, r0, lsl #14
    1f4c:	05290c00 	streq	r0, [r9, #-3072]!	; 0xfffff400
    1f50:	0b000000 	bleq	1f58 <CPSR_IRQ_INHIBIT+0x1ed8>
    1f54:	00000818 	andeq	r0, r0, r8, lsl r8
    1f58:	7c0f1404 	cfstrsvc	mvf1, [pc], {4}
    1f5c:	2f000008 	svccs	0x00000008
    1f60:	01000005 	tsteq	r0, r5
    1f64:	00000360 	andeq	r0, r0, r0, ror #6
    1f68:	0000036b 	andeq	r0, r0, fp, ror #6
    1f6c:	0005290c 	andeq	r2, r5, ip, lsl #18
    1f70:	00250d00 	eoreq	r0, r5, r0, lsl #26
    1f74:	0b000000 	bleq	1f7c <CPSR_IRQ_INHIBIT+0x1efc>
    1f78:	00000818 	andeq	r0, r0, r8, lsl r8
    1f7c:	230f1504 	movwcs	r1, #62724	; 0xf504
    1f80:	2f000008 	svccs	0x00000008
    1f84:	01000005 	tsteq	r0, r5
    1f88:	00000384 	andeq	r0, r0, r4, lsl #7
    1f8c:	0000038f 	andeq	r0, r0, pc, lsl #7
    1f90:	0005290c 	andeq	r2, r5, ip, lsl #18
    1f94:	051e0d00 	ldreq	r0, [lr, #-3328]	; 0xfffff300
    1f98:	0b000000 	bleq	1fa0 <CPSR_IRQ_INHIBIT+0x1f20>
    1f9c:	00000818 	andeq	r0, r0, r8, lsl r8
    1fa0:	d60f1604 	strle	r1, [pc], -r4, lsl #12
    1fa4:	2f000007 	svccs	0x00000007
    1fa8:	01000005 	tsteq	r0, r5
    1fac:	000003a8 	andeq	r0, r0, r8, lsr #7
    1fb0:	000003b3 			; <UNDEFINED> instruction: 0x000003b3
    1fb4:	0005290c 	andeq	r2, r5, ip, lsl #18
    1fb8:	029a0d00 	addseq	r0, sl, #0, 26
    1fbc:	0b000000 	bleq	1fc4 <CPSR_IRQ_INHIBIT+0x1f44>
    1fc0:	00000818 	andeq	r0, r0, r8, lsl r8
    1fc4:	ab0f1704 	blge	3c7bdc <_bss_end+0x3bbee0>
    1fc8:	2f000008 	svccs	0x00000008
    1fcc:	01000005 	tsteq	r0, r5
    1fd0:	000003cc 	andeq	r0, r0, ip, asr #7
    1fd4:	000003d7 	ldrdeq	r0, [r0], -r7
    1fd8:	0005290c 	andeq	r2, r5, ip, lsl #18
    1fdc:	00740d00 	rsbseq	r0, r4, r0, lsl #26
    1fe0:	0b000000 	bleq	1fe8 <CPSR_IRQ_INHIBIT+0x1f68>
    1fe4:	00000818 	andeq	r0, r0, r8, lsl r8
    1fe8:	6b0f1804 	blvs	3c8000 <_bss_end+0x3bc304>
    1fec:	2f000008 	svccs	0x00000008
    1ff0:	01000005 	tsteq	r0, r5
    1ff4:	000003f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    1ff8:	000003fb 	strdeq	r0, [r0], -fp
    1ffc:	0005290c 	andeq	r2, r5, ip, lsl #18
    2000:	02630d00 	rsbeq	r0, r3, #0, 26
    2004:	1a000000 	bne	200c <CPSR_IRQ_INHIBIT+0x1f8c>
    2008:	0000073f 	andeq	r0, r0, pc, lsr r7
    200c:	0f111b04 	svceq	0x00111b04
    2010:	0f000007 	svceq	0x00000007
    2014:	15000004 	strne	r0, [r0, #-4]
    2018:	0c000004 	stceq	0, cr0, [r0], {4}
    201c:	00000529 	andeq	r0, r0, r9, lsr #10
    2020:	07321a00 	ldreq	r1, [r2, -r0, lsl #20]!
    2024:	1c040000 	stcne	0, cr0, [r4], {-0}
    2028:	0008bc11 	andeq	fp, r8, r1, lsl ip
    202c:	00042900 	andeq	r2, r4, r0, lsl #18
    2030:	00042f00 	andeq	r2, r4, r0, lsl #30
    2034:	05290c00 	streq	r0, [r9, #-3072]!	; 0xfffff400
    2038:	1a000000 	bne	2040 <CPSR_IRQ_INHIBIT+0x1fc0>
    203c:	000006d0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    2040:	6b111d04 	blvs	449458 <_bss_end+0x43d75c>
    2044:	43000007 	movwmi	r0, #7
    2048:	49000004 	stmdbmi	r0, {r2}
    204c:	0c000004 	stceq	0, cr0, [r0], {4}
    2050:	00000529 	andeq	r0, r0, r9, lsr #10
    2054:	074d1b00 	strbeq	r1, [sp, -r0, lsl #22]
    2058:	1f040000 	svcne	0x00040000
    205c:	00080119 	andeq	r0, r8, r9, lsl r1
    2060:	00007400 	andeq	r7, r0, r0, lsl #8
    2064:	00046100 	andeq	r6, r4, r0, lsl #2
    2068:	00047100 	andeq	r7, r4, r0, lsl #2
    206c:	05290c00 	streq	r0, [r9, #-3072]!	; 0xfffff400
    2070:	740d0000 	strvc	r0, [sp], #-0
    2074:	0d000000 	stceq	0, cr0, [r0, #-0]
    2078:	00000074 	andeq	r0, r0, r4, ror r0
    207c:	09831b00 	stmibeq	r3, {r8, r9, fp, ip}
    2080:	20040000 	andcs	r0, r4, r0
    2084:	0006e219 	andeq	lr, r6, r9, lsl r2
    2088:	00007400 	andeq	r7, r0, r0, lsl #8
    208c:	00048900 	andeq	r8, r4, r0, lsl #18
    2090:	00049900 	andeq	r9, r4, r0, lsl #18
    2094:	05290c00 	streq	r0, [r9, #-3072]!	; 0xfffff400
    2098:	740d0000 	strvc	r0, [sp], #-0
    209c:	0d000000 	stceq	0, cr0, [r0, #-0]
    20a0:	00000074 	andeq	r0, r0, r4, ror r0
    20a4:	06ac1a00 	strteq	r1, [ip], r0, lsl #20
    20a8:	22040000 	andcs	r0, r4, #0
    20ac:	0008950a 	andeq	r9, r8, sl, lsl #10
    20b0:	0004ad00 	andeq	sl, r4, r0, lsl #26
    20b4:	0004b300 	andeq	fp, r4, r0, lsl #6
    20b8:	05290c00 	streq	r0, [r9, #-3072]!	; 0xfffff400
    20bc:	1a000000 	bne	20c4 <CPSR_IRQ_INHIBIT+0x2044>
    20c0:	0000072d 	andeq	r0, r0, sp, lsr #14
    20c4:	360a2404 	strcc	r2, [sl], -r4, lsl #8
    20c8:	c7000008 	strgt	r0, [r0, -r8]
    20cc:	dc000004 	stcle	0, cr0, [r0], {4}
    20d0:	0c000004 	stceq	0, cr0, [r0], {4}
    20d4:	00000529 	andeq	r0, r0, r9, lsr #10
    20d8:	0000740d 	andeq	r7, r0, sp, lsl #8
    20dc:	05350d00 	ldreq	r0, [r5, #-3328]!	; 0xfffff300
    20e0:	740d0000 	strvc	r0, [sp], #-0
    20e4:	00000000 	andeq	r0, r0, r0
    20e8:	00078d0a 	andeq	r8, r7, sl, lsl #26
    20ec:	232e0400 			; <UNDEFINED> instruction: 0x232e0400
    20f0:	00000541 	andeq	r0, r0, r1, asr #10
    20f4:	088d0a00 	stmeq	sp, {r9, fp}
    20f8:	2f040000 	svccs	0x00040000
    20fc:	00007412 	andeq	r7, r0, r2, lsl r4
    2100:	4d0a0400 	cfstrsmi	mvf0, [sl, #-0]
    2104:	04000008 	streq	r0, [r0], #-8
    2108:	00741230 	rsbseq	r1, r4, r0, lsr r2
    210c:	0a080000 	beq	202114 <_bss_end+0x1f6418>
    2110:	00000856 	andeq	r0, r0, r6, asr r8
    2114:	bf0f3104 	svclt	0x000f3104
    2118:	0c000002 	stceq	0, cr0, [r0], {2}
    211c:	0006c20a 	andeq	ip, r6, sl, lsl #4
    2120:	12320400 	eorsne	r0, r2, #0, 8
    2124:	0000029a 	muleq	r0, sl, r2
    2128:	04100014 	ldreq	r0, [r0], #-20	; 0xffffffec
    212c:	0000002c 	andeq	r0, r0, ip, lsr #32
    2130:	00051e03 	andeq	r1, r5, r3, lsl #28
    2134:	8d041000 	stchi	0, cr1, [r4, #-0]
    2138:	11000002 	tstne	r0, r2
    213c:	00028d04 	andeq	r8, r2, r4, lsl #26
    2140:	25041000 	strcs	r1, [r4, #-0]
    2144:	10000000 	andne	r0, r0, r0
    2148:	00005704 	andeq	r5, r0, r4, lsl #14
    214c:	053b0300 	ldreq	r0, [fp, #-768]!	; 0xfffffd00
    2150:	a6120000 	ldrge	r0, [r2], -r0
    2154:	04000007 	streq	r0, [r0], #-7
    2158:	028d1135 	addeq	r1, sp, #1073741837	; 0x4000000d
    215c:	681c0000 	ldmdavs	ip, {}	; <UNPREDICTABLE>
    2160:	05006c61 	streq	r6, [r0, #-3169]	; 0xfffff39f
    2164:	07040b07 	streq	r0, [r4, -r7, lsl #22]
    2168:	801d0000 	andshi	r0, sp, r0
    216c:	05000006 	streq	r0, [r0, #-6]
    2170:	00801909 	addeq	r1, r0, r9, lsl #18
    2174:	b2800000 	addlt	r0, r0, #0
    2178:	e61d0ee6 	ldr	r0, [sp], -r6, ror #29
    217c:	05000003 	streq	r0, [r0, #-3]
    2180:	07101a0c 	ldreq	r1, [r0, -ip, lsl #20]
    2184:	00000000 	andeq	r0, r0, r0
    2188:	c41d2000 	ldrgt	r2, [sp], #-0
    218c:	05000004 	streq	r0, [r0, #-4]
    2190:	07101a0f 	ldreq	r1, [r0, -pc, lsl #20]
    2194:	00000000 	andeq	r0, r0, r0
    2198:	301e2020 	andscc	r2, lr, r0, lsr #32
    219c:	05000005 	streq	r0, [r0, #-5]
    21a0:	006f1512 	rsbeq	r1, pc, r2, lsl r5	; <UNPREDICTABLE>
    21a4:	1d360000 	ldcne	0, cr0, [r6, #-0]
    21a8:	00000627 	andeq	r0, r0, r7, lsr #12
    21ac:	101a4405 	andsne	r4, sl, r5, lsl #8
    21b0:	00000007 	andeq	r0, r0, r7
    21b4:	1d202150 	stfnes	f2, [r0, #-320]!	; 0xfffffec0
    21b8:	00000266 	andeq	r0, r0, r6, ror #4
    21bc:	101a7305 	andsne	r7, sl, r5, lsl #6
    21c0:	00000007 	andeq	r0, r0, r7
    21c4:	072000b2 			; <UNDEFINED> instruction: 0x072000b2
    21c8:	00000d49 	andeq	r0, r0, r9, asr #26
    21cc:	00380405 	eorseq	r0, r8, r5, lsl #8
    21d0:	75050000 	strvc	r0, [r5, #-0]
    21d4:	00060a0d 	andeq	r0, r6, sp, lsl #20
    21d8:	0ea40800 	cdpeq	8, 10, cr0, cr4, cr0, {0}
    21dc:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    21e0:	00000e14 	andeq	r0, r0, r4, lsl lr
    21e4:	0e220801 	cdpeq	8, 2, cr0, cr2, cr1, {0}
    21e8:	08020000 	stmdaeq	r2, {}	; <UNPREDICTABLE>
    21ec:	00000fc3 	andeq	r0, r0, r3, asr #31
    21f0:	0da90803 	stceq	8, cr0, [r9, #12]!
    21f4:	08040000 	stmdaeq	r4, {}	; <UNPREDICTABLE>
    21f8:	00000db6 			; <UNDEFINED> instruction: 0x00000db6
    21fc:	0ec60805 	cdpeq	8, 12, cr0, cr6, cr5, {0}
    2200:	08060000 	stmdaeq	r6, {}	; <UNPREDICTABLE>
    2204:	00000d8d 	andeq	r0, r0, sp, lsl #27
    2208:	0d9b0807 	ldceq	8, cr0, [fp, #28]
    220c:	08080000 	stmdaeq	r8, {}	; <UNPREDICTABLE>
    2210:	00000f74 	andeq	r0, r0, r4, ror pc
    2214:	30070009 	andcc	r0, r7, r9
    2218:	0500000e 	streq	r0, [r0, #-14]
    221c:	00003804 	andeq	r3, r0, r4, lsl #16
    2220:	0d830500 	cfstr32eq	mvfx0, [r3]
    2224:	0000064d 	andeq	r0, r0, sp, asr #12
    2228:	000bc108 	andeq	ip, fp, r8, lsl #2
    222c:	d7080000 	strle	r0, [r8, -r0]
    2230:	0100000e 	tsteq	r0, lr
    2234:	000d6208 	andeq	r6, sp, r8, lsl #4
    2238:	74080200 	strvc	r0, [r8], #-512	; 0xfffffe00
    223c:	0300000d 	movweq	r0, #13
    2240:	00107108 	andseq	r7, r0, r8, lsl #2
    2244:	b6080400 	strlt	r0, [r8], -r0, lsl #8
    2248:	0500000e 	streq	r0, [r0, #-14]
    224c:	000e7b08 	andeq	r7, lr, r8, lsl #22
    2250:	8c080600 	stchi	6, cr0, [r8], {-0}
    2254:	0700000e 	streq	r0, [r0, -lr]
    2258:	0d3e0700 	ldceq	7, cr0, [lr, #-0]
    225c:	04050000 	streq	r0, [r5], #-0
    2260:	00000038 	andeq	r0, r0, r8, lsr r0
    2264:	ae0d8f05 	cdpge	15, 0, cr8, cr13, cr5, {0}
    2268:	14000006 	strne	r0, [r0], #-6
    226c:	00585541 	subseq	r5, r8, r1, asr #10
    2270:	0fa5081d 	svceq	0x00a5081d
    2274:	082b0000 	stmdaeq	fp!, {}	; <UNPREDICTABLE>
    2278:	00000e41 	andeq	r0, r0, r1, asr #28
    227c:	0ec0082d 	cdpeq	8, 12, cr0, cr0, cr13, {1}
    2280:	142e0000 	strtne	r0, [lr], #-0
    2284:	00494d53 	subeq	r4, r9, r3, asr sp
    2288:	0d6d0830 	stcleq	8, cr0, [sp, #-192]!	; 0xffffff40
    228c:	08310000 	ldmdaeq	r1!, {}	; <UNPREDICTABLE>
    2290:	00000e9d 	muleq	r0, sp, lr
    2294:	0d7f0832 	ldcleq	8, cr0, [pc, #-200]!	; 21d4 <CPSR_IRQ_INHIBIT+0x2154>
    2298:	08330000 	ldmdaeq	r3!, {}	; <UNPREDICTABLE>
    229c:	00000d86 	andeq	r0, r0, r6, lsl #27
    22a0:	32491434 	subcc	r1, r9, #52, 8	; 0x34000000
    22a4:	14350043 	ldrtne	r0, [r5], #-67	; 0xffffffbd
    22a8:	00495053 	subeq	r5, r9, r3, asr r0
    22ac:	43501436 	cmpmi	r0, #905969664	; 0x36000000
    22b0:	0837004d 	ldmdaeq	r7!, {r0, r2, r3, r6}
    22b4:	00000e47 	andeq	r0, r0, r7, asr #28
    22b8:	441d0039 	ldrmi	r0, [sp], #-57	; 0xffffffc7
    22bc:	05000005 	streq	r0, [r0, #-5]
    22c0:	07101aa6 	ldreq	r1, [r0, -r6, lsr #21]
    22c4:	b4000000 	strlt	r0, [r0], #-0
    22c8:	6e1f2000 	cdpvs	0, 1, cr2, cr15, cr0, {0}
    22cc:	0500000b 	streq	r0, [r0, #-11]
    22d0:	00003804 	andeq	r3, r0, r4, lsl #16
    22d4:	0da80500 	cfstr32eq	mvfx0, [r8]
    22d8:	000bbb08 	andeq	fp, fp, r8, lsl #22
    22dc:	41080000 	mrsmi	r0, (UNDEF: 8)
    22e0:	0100000b 	tsteq	r0, fp
    22e4:	000fc708 	andeq	ip, pc, r8, lsl #14
    22e8:	0a080200 	beq	202af0 <_bss_end+0x1f6df4>
    22ec:	0300000b 	movweq	r0, #11
    22f0:	000c3308 	andeq	r3, ip, r8, lsl #6
    22f4:	48080400 	stmdami	r8, {sl}
    22f8:	0500000a 	streq	r0, [r0, #-10]
    22fc:	000a3408 	andeq	r3, sl, r8, lsl #8
    2300:	62080600 	andvs	r0, r8, #0, 12
    2304:	0700000b 	streq	r0, [r0, -fp]
    2308:	000c0108 	andeq	r0, ip, r8, lsl #2
    230c:	00000800 	andeq	r0, r0, r0, lsl #16
    2310:	00055e20 	andeq	r5, r5, r0, lsr #28
    2314:	07040200 	streq	r0, [r4, -r0, lsl #4]
    2318:	00001eea 	andeq	r1, r0, sl, ror #29
    231c:	00070903 	andeq	r0, r7, r3, lsl #18
    2320:	056e2000 	strbeq	r2, [lr, #-0]!
    2324:	7e200000 	cdpvc	0, 2, cr0, cr0, cr0, {0}
    2328:	20000005 	andcs	r0, r0, r5
    232c:	0000058e 	andeq	r0, r0, lr, lsl #11
    2330:	00059b20 	andeq	r9, r5, r0, lsr #22
    2334:	05ab2000 	streq	r2, [fp, #0]!
    2338:	ae200000 	cdpge	0, 2, cr0, cr0, cr0, {0}
    233c:	07000006 	streq	r0, [r0, -r6]
    2340:	00000ac2 	andeq	r0, r0, r2, asr #21
    2344:	00440107 	subeq	r0, r4, r7, lsl #2
    2348:	06060000 	streq	r0, [r6], -r0
    234c:	0007580c 	andeq	r5, r7, ip, lsl #16
    2350:	0aea0800 	beq	ffa84358 <_bss_end+0xffa7865c>
    2354:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    2358:	00000b14 	andeq	r0, r0, r4, lsl fp
    235c:	0a9a0801 	beq	fe684368 <_bss_end+0xfe67866c>
    2360:	00020000 	andeq	r0, r2, r0
    2364:	000bc009 	andeq	ip, fp, r9
    2368:	0d060800 	stceq	8, cr0, [r6, #-0]
    236c:	00085007 	andeq	r5, r8, r7
    2370:	0b350a00 	bleq	d44b78 <_bss_end+0xd38e7c>
    2374:	15060000 	strne	r0, [r6, #-0]
    2378:	00025820 	andeq	r5, r2, r0, lsr #16
    237c:	23210000 			; <UNDEFINED> instruction: 0x23210000
    2380:	0600000c 	streq	r0, [r0], -ip
    2384:	08500f11 	ldmdaeq	r0, {r0, r4, r8, r9, sl, fp}^
    2388:	0a010000 	beq	42390 <_bss_end+0x36694>
    238c:	00000bc7 	andeq	r0, r0, r7, asr #23
    2390:	72191806 	andsvc	r1, r9, #393216	; 0x60000
    2394:	04000007 	streq	r0, [r0], #-7
    2398:	000b3c0b 	andeq	r3, fp, fp, lsl #24
    239c:	201b0600 	andscs	r0, fp, r0, lsl #12
    23a0:	00000bd1 	ldrdeq	r0, [r0], -r1
    23a4:	00000857 	andeq	r0, r0, r7, asr r8
    23a8:	0007a502 	andeq	sl, r7, r2, lsl #10
    23ac:	0007b000 	andeq	fp, r7, r0
    23b0:	085d0c00 	ldmdaeq	sp, {sl, fp}^
    23b4:	be0d0000 	cdplt	0, 0, cr0, cr13, cr0, {0}
    23b8:	00000006 	andeq	r0, r0, r6
    23bc:	000bc00b 	andeq	ip, fp, fp
    23c0:	091e0600 	ldmdbeq	lr, {r9, sl}
    23c4:	00000bf2 	strdeq	r0, [r0], -r2
    23c8:	0000085d 	andeq	r0, r0, sp, asr r8
    23cc:	0007c901 	andeq	ip, r7, r1, lsl #18
    23d0:	0007d400 	andeq	sp, r7, r0, lsl #8
    23d4:	085d0c00 	ldmdaeq	sp, {sl, fp}^
    23d8:	090d0000 	stmdbeq	sp, {}	; <UNPREDICTABLE>
    23dc:	00000007 	andeq	r0, r0, r7
    23e0:	000ed00e 	andeq	sp, lr, lr
    23e4:	0e210600 	cfmadda32eq	mvax0, mvax0, mvfx1, mvfx0
    23e8:	00000aa8 	andeq	r0, r0, r8, lsr #21
    23ec:	0007e901 	andeq	lr, r7, r1, lsl #18
    23f0:	0007fe00 	andeq	pc, r7, r0, lsl #28
    23f4:	085d0c00 	ldmdaeq	sp, {sl, fp}^
    23f8:	720d0000 	andvc	r0, sp, #0
    23fc:	0d000007 	stceq	0, cr0, [r0, #-28]	; 0xffffffe4
    2400:	00000074 	andeq	r0, r0, r4, ror r0
    2404:	0007330d 	andeq	r3, r7, sp, lsl #6
    2408:	7e0e0000 	cdpvc	0, 0, cr0, cr14, cr0, {0}
    240c:	0600000f 	streq	r0, [r0], -pc
    2410:	0b780e23 	bleq	1e05ca4 <_bss_end+0x1df9fa8>
    2414:	13010000 	movwne	r0, #4096	; 0x1000
    2418:	19000008 	stmdbne	r0, {r3}
    241c:	0c000008 	stceq	0, cr0, [r0], {8}
    2420:	0000085d 	andeq	r0, r0, sp, asr r8
    2424:	0a3b0e00 	beq	ec5c2c <_bss_end+0xeb9f30>
    2428:	26060000 	strcs	r0, [r6], -r0
    242c:	000c3b0e 	andeq	r3, ip, lr, lsl #22
    2430:	082e0100 	stmdaeq	lr!, {r8}
    2434:	08340000 	ldmdaeq	r4!, {}	; <UNPREDICTABLE>
    2438:	5d0c0000 	stcpl	0, cr0, [ip, #-0]
    243c:	00000008 	andeq	r0, r0, r8
    2440:	000c0e0f 	andeq	r0, ip, pc, lsl #28
    2444:	0e280600 	cfmadda32eq	mvax0, mvax0, mvfx8, mvfx0
    2448:	000009a3 	andeq	r0, r0, r3, lsr #19
    244c:	00000263 	andeq	r0, r0, r3, ror #4
    2450:	00084901 	andeq	r4, r8, r1, lsl #18
    2454:	085d0c00 	ldmdaeq	sp, {sl, fp}^
    2458:	00000000 	andeq	r0, r0, r0
    245c:	08560410 	ldmdaeq	r6, {r4, sl}^
    2460:	11220000 			; <UNDEFINED> instruction: 0x11220000
    2464:	00007b04 	andeq	r7, r0, r4, lsl #22
    2468:	58041000 	stmdapl	r4, {ip}
    246c:	12000007 	andne	r0, r0, #7
    2470:	0000099c 	muleq	r0, ip, r9
    2474:	580f2b06 	stmdapl	pc, {r1, r2, r8, r9, fp, sp}	; <UNPREDICTABLE>
    2478:	09000007 	stmdbeq	r0, {r0, r1, r2}
    247c:	00000f36 	andeq	r0, r0, r6, lsr pc
    2480:	07050704 	streq	r0, [r5, -r4, lsl #14]
    2484:	0000094e 	andeq	r0, r0, lr, asr #18
    2488:	000e040a 	andeq	r0, lr, sl, lsl #8
    248c:	20090700 	andcs	r0, r9, r0, lsl #14
    2490:	00000258 	andeq	r0, r0, r8, asr r2
    2494:	0b3c0b00 	bleq	f0509c <_bss_end+0xef93a0>
    2498:	0c070000 	stceq	0, cr0, [r7], {-0}
    249c:	000dc320 	andeq	ip, sp, r0, lsr #6
    24a0:	00085700 	andeq	r5, r8, r0, lsl #14
    24a4:	08a20200 	stmiaeq	r2!, {r9}
    24a8:	08ad0000 	stmiaeq	sp!, {}	; <UNPREDICTABLE>
    24ac:	4e0c0000 	cdpmi	0, 0, cr0, cr12, cr0, {0}
    24b0:	0d000009 	stceq	0, cr0, [r0, #-36]	; 0xffffffdc
    24b4:	000005bb 			; <UNDEFINED> instruction: 0x000005bb
    24b8:	0f360b00 	svceq	0x00360b00
    24bc:	0f070000 	svceq	0x00070000
    24c0:	000f8609 	andeq	r8, pc, r9, lsl #12
    24c4:	00094e00 	andeq	r4, r9, r0, lsl #28
    24c8:	08c60100 	stmiaeq	r6, {r8}^
    24cc:	08d10000 	ldmeq	r1, {}^	; <UNPREDICTABLE>
    24d0:	4e0c0000 	cdpmi	0, 0, cr0, cr12, cr0, {0}
    24d4:	0d000009 	stceq	0, cr0, [r0, #-36]	; 0xffffffdc
    24d8:	00000709 	andeq	r0, r0, r9, lsl #14
    24dc:	0e580e00 	cdpeq	14, 5, cr0, cr8, cr0, {0}
    24e0:	12070000 	andne	r0, r7, #0
    24e4:	000cf80e 	andeq	pc, ip, lr, lsl #16
    24e8:	08e60100 	stmiaeq	r6!, {r8}^
    24ec:	08f10000 	ldmeq	r1!, {}^	; <UNPREDICTABLE>
    24f0:	4e0c0000 	cdpmi	0, 0, cr0, cr12, cr0, {0}
    24f4:	0d000009 	stceq	0, cr0, [r0, #-36]	; 0xffffffdc
    24f8:	0000060a 	andeq	r0, r0, sl, lsl #12
    24fc:	0e690e00 	cdpeq	14, 6, cr0, cr9, cr0, {0}
    2500:	14070000 	strne	r0, [r7], #-0
    2504:	000cb10e 	andeq	fp, ip, lr, lsl #2
    2508:	09060100 	stmdbeq	r6, {r8}
    250c:	09110000 	ldmdbeq	r1, {}	; <UNPREDICTABLE>
    2510:	4e0c0000 	cdpmi	0, 0, cr0, cr12, cr0, {0}
    2514:	0d000009 	stceq	0, cr0, [r0, #-36]	; 0xffffffdc
    2518:	0000060a 	andeq	r0, r0, sl, lsl #12
    251c:	10660e00 	rsbne	r0, r6, r0, lsl #28
    2520:	17070000 	strne	r0, [r7, -r0]
    2524:	000efc0e 	andeq	pc, lr, lr, lsl #24
    2528:	09260100 	stmdbeq	r6!, {r8}
    252c:	09310000 	ldmdbeq	r1!, {}	; <UNPREDICTABLE>
    2530:	4e0c0000 	cdpmi	0, 0, cr0, cr12, cr0, {0}
    2534:	0d000009 	stceq	0, cr0, [r0, #-36]	; 0xffffffdc
    2538:	0000064d 	andeq	r0, r0, sp, asr #12
    253c:	0e4c2300 	cdpeq	3, 4, cr2, cr12, cr0, {0}
    2540:	19070000 	stmdbne	r7, {}	; <UNPREDICTABLE>
    2544:	000c5f0e 	andeq	r5, ip, lr, lsl #30
    2548:	09420100 	stmdbeq	r2, {r8}^
    254c:	4e0c0000 	cdpmi	0, 0, cr0, cr12, cr0, {0}
    2550:	0d000009 	stceq	0, cr0, [r0, #-36]	; 0xffffffdc
    2554:	0000064d 	andeq	r0, r0, sp, asr #12
    2558:	04100000 	ldreq	r0, [r0], #-0
    255c:	0000086f 	andeq	r0, r0, pc, ror #16
    2560:	000eee12 	andeq	lr, lr, r2, lsl lr
    2564:	1e1c0700 	cdpne	7, 1, cr0, cr12, cr0, {0}
    2568:	0000086f 	andeq	r0, r0, pc, ror #16
    256c:	6d656d1c 	stclvs	13, cr6, [r5, #-112]!	; 0xffffff90
    2570:	0b060800 	bleq	184578 <_bss_end+0x17887c>
    2574:	000009b9 			; <UNDEFINED> instruction: 0x000009b9
    2578:	0011d71d 	andseq	sp, r1, sp, lsl r7
    257c:	180a0800 	stmdane	sl, {fp}
    2580:	0000006f 	andeq	r0, r0, pc, rrx
    2584:	00020000 	andeq	r0, r2, r0
    2588:	0010b71d 	andseq	fp, r0, sp, lsl r7
    258c:	180d0800 	stmdane	sp, {fp}
    2590:	0000006f 	andeq	r0, r0, pc, rrx
    2594:	20000000 	andcs	r0, r0, r0
    2598:	00142924 	andseq	r2, r4, r4, lsr #18
    259c:	18100800 	ldmdane	r0, {fp}
    25a0:	0000006f 	andeq	r0, r0, pc, rrx
    25a4:	da1d4000 	ble	7525ac <_bss_end+0x7468b0>
    25a8:	08000012 	stmdaeq	r0, {r1, r4}
    25ac:	006f1813 	rsbeq	r1, pc, r3, lsl r8	; <UNPREDICTABLE>
    25b0:	00000000 	andeq	r0, r0, r0
    25b4:	80241ffe 	strdhi	r1, [r4], -lr	; <UNPREDICTABLE>
    25b8:	08000010 	stmdaeq	r0, {r4}
    25bc:	006f1816 	rsbeq	r1, pc, r6, lsl r8	; <UNPREDICTABLE>
    25c0:	7ff80000 	svcvc	0x00f80000
    25c4:	096c2000 	stmdbeq	ip!, {sp}^
    25c8:	7c200000 	stcvc	0, cr0, [r0], #-0
    25cc:	20000009 	andcs	r0, r0, r9
    25d0:	0000098c 	andeq	r0, r0, ip, lsl #19
    25d4:	00099a20 	andeq	r9, r9, r0, lsr #20
    25d8:	09aa2000 	stmibeq	sl!, {sp}
    25dc:	43150000 	tstmi	r5, #0
    25e0:	10000013 	andne	r0, r0, r3, lsl r0
    25e4:	14080809 	strne	r0, [r8], #-2057	; 0xfffff7f7
    25e8:	0a00000a 	beq	2618 <CPSR_IRQ_INHIBIT+0x2598>
    25ec:	0000107b 	andeq	r1, r0, fp, ror r0
    25f0:	14200a09 	strtne	r0, [r0], #-2569	; 0xfffff5f7
    25f4:	0000000a 	andeq	r0, r0, sl
    25f8:	0010c20a 	andseq	ip, r0, sl, lsl #4
    25fc:	200b0900 	andcs	r0, fp, r0, lsl #18
    2600:	00000a14 	andeq	r0, r0, r4, lsl sl
    2604:	11890a04 	orrne	r0, r9, r4, lsl #20
    2608:	0c090000 	stceq	0, cr0, [r9], {-0}
    260c:	0000630e 	andeq	r6, r0, lr, lsl #6
    2610:	0f0a0800 	svceq	0x000a0800
    2614:	09000011 	stmdbeq	r0, {r0, r4}
    2618:	02630a0d 	rsbeq	r0, r3, #53248	; 0xd000
    261c:	000c0000 	andeq	r0, ip, r0
    2620:	09d20410 	ldmibeq	r2, {r4, sl}^
    2624:	3f090000 	svccc	0x00090000
    2628:	04000012 	streq	r0, [r0], #-18	; 0xffffffee
    262c:	b2071009 	andlt	r1, r7, #9
    2630:	0a00000a 	beq	2660 <CPSR_IRQ_INHIBIT+0x25e0>
    2634:	00001306 	andeq	r1, r0, r6, lsl #6
    2638:	14241309 	strtne	r1, [r4], #-777	; 0xfffffcf7
    263c:	0000000a 	andeq	r0, r0, sl
    2640:	00137b1b 	andseq	r7, r3, fp, lsl fp
    2644:	24150900 	ldrcs	r0, [r5], #-2304	; 0xfffff700
    2648:	0000115c 	andeq	r1, r0, ip, asr r1
    264c:	00000a14 	andeq	r0, r0, r4, lsl sl
    2650:	00000a4c 	andeq	r0, r0, ip, asr #20
    2654:	00000a52 	andeq	r0, r0, r2, asr sl
    2658:	000ab20c 	andeq	fp, sl, ip, lsl #4
    265c:	3f0b0000 	svccc	0x000b0000
    2660:	09000012 	stmdbeq	r0, {r1, r4}
    2664:	11e10918 	mvnne	r0, r8, lsl r9
    2668:	0ab20000 	beq	fec82670 <_bss_end+0xfec76974>
    266c:	6b010000 	blvs	42674 <_bss_end+0x36978>
    2670:	7100000a 	tstvc	r0, sl
    2674:	0c00000a 	stceq	0, cr0, [r0], {10}
    2678:	00000ab2 			; <UNDEFINED> instruction: 0x00000ab2
    267c:	125d0b00 	subsne	r0, sp, #0, 22
    2680:	1a090000 	bne	242688 <_bss_end+0x23698c>
    2684:	00126b0f 	andseq	r6, r2, pc, lsl #22
    2688:	000ab800 	andeq	fp, sl, r0, lsl #16
    268c:	0a8a0100 	beq	fe282a94 <_bss_end+0xfe276d98>
    2690:	0a950000 	beq	fe542698 <_bss_end+0xfe53699c>
    2694:	b20c0000 	andlt	r0, ip, #0
    2698:	0d00000a 	stceq	0, cr0, [r0, #-40]	; 0xffffffd8
    269c:	00000063 	andeq	r0, r0, r3, rrx
    26a0:	118e2300 	orrne	r2, lr, r0, lsl #6
    26a4:	1b090000 	blne	2426ac <_bss_end+0x2369b0>
    26a8:	0011b50e 	andseq	fp, r1, lr, lsl #10
    26ac:	0aa60100 	beq	fe982ab4 <_bss_end+0xfe976db8>
    26b0:	b20c0000 	andlt	r0, ip, #0
    26b4:	0d00000a 	stceq	0, cr0, [r0, #-40]	; 0xffffffd8
    26b8:	00000ab8 			; <UNDEFINED> instruction: 0x00000ab8
    26bc:	04100000 	ldreq	r0, [r0], #-0
    26c0:	00000a1a 	andeq	r0, r0, sl, lsl sl
    26c4:	73120425 	tstvc	r2, #620756992	; 0x25000000
    26c8:	09000014 	stmdbeq	r0, {r2, r4}
    26cc:	0a1a1d24 	beq	689b64 <_bss_end+0x67de68>
    26d0:	93070000 	movwls	r0, #28672	; 0x7000
    26d4:	05000011 	streq	r0, [r0, #-17]	; 0xffffffef
    26d8:	00003804 	andeq	r3, r0, r4, lsl #16
    26dc:	0c040a00 			; <UNDEFINED> instruction: 0x0c040a00
    26e0:	00000af1 	strdeq	r0, [r0], -r1
    26e4:	77654e14 			; <UNDEFINED> instruction: 0x77654e14
    26e8:	54080000 	strpl	r0, [r8], #-0
    26ec:	01000012 	tsteq	r0, r2, lsl r0
    26f0:	000c0608 	andeq	r0, ip, r8, lsl #12
    26f4:	09080200 	stmdbeq	r8, {r9}
    26f8:	03000012 	movweq	r0, #18
    26fc:	11171500 	tstne	r7, r0, lsl #10
    2700:	0a0c0000 	beq	302708 <_bss_end+0x2f6a0c>
    2704:	0b230811 	bleq	8c4750 <_bss_end+0x8b8a54>
    2708:	6c160000 	ldcvs	0, cr0, [r6], {-0}
    270c:	130a0072 	movwne	r0, #41074	; 0xa072
    2710:	00070913 	andeq	r0, r7, r3, lsl r9
    2714:	73160000 	tstvc	r6, #0
    2718:	140a0070 	strne	r0, [sl], #-112	; 0xffffff90
    271c:	00070913 	andeq	r0, r7, r3, lsl r9
    2720:	70160400 	andsvc	r0, r6, r0, lsl #8
    2724:	150a0063 	strne	r0, [sl, #-99]	; 0xffffff9d
    2728:	00070913 	andeq	r0, r7, r3, lsl r9
    272c:	15000800 	strne	r0, [r0, #-2048]	; 0xfffff800
    2730:	000012f0 	strdeq	r1, [r0], -r0
    2734:	081b0a1c 	ldmdaeq	fp, {r2, r3, r4, r9, fp}
    2738:	00000b72 	andeq	r0, r0, r2, ror fp
    273c:	0012ce0a 	andseq	ip, r2, sl, lsl #28
    2740:	121d0a00 	andsne	r0, sp, #0, 20
    2744:	00000af1 	strdeq	r0, [r0], -r1
    2748:	69701600 	ldmdbvs	r0!, {r9, sl, ip}^
    274c:	1e0a0064 	cdpne	0, 0, cr0, cr10, cr4, {3}
    2750:	00007412 	andeq	r7, r0, r2, lsl r4
    2754:	3b0a0c00 	blcc	28575c <_bss_end+0x279a60>
    2758:	0a00001c 	beq	27d0 <CPSR_IRQ_INHIBIT+0x2750>
    275c:	0ac6111f 	beq	ff186be0 <_bss_end+0xff17aee4>
    2760:	0a100000 	beq	402768 <_bss_end+0x3f6a6c>
    2764:	00001231 	andeq	r1, r0, r1, lsr r2
    2768:	7412200a 	ldrvc	r2, [r2], #-10
    276c:	14000000 	strne	r0, [r0], #-0
    2770:	00119f0a 	andseq	r9, r1, sl, lsl #30
    2774:	12210a00 	eorne	r0, r1, #0, 20
    2778:	00000074 	andeq	r0, r0, r4, ror r0
    277c:	30150018 	andscc	r0, r5, r8, lsl r0
    2780:	0c000013 	stceq	0, cr0, [r0], {19}
    2784:	a708070b 	strge	r0, [r8, -fp, lsl #14]
    2788:	0a00000b 	beq	27bc <CPSR_IRQ_INHIBIT+0x273c>
    278c:	0000107b 	andeq	r1, r0, fp, ror r0
    2790:	a719090b 	ldrge	r0, [r9, -fp, lsl #18]
    2794:	0000000b 	andeq	r0, r0, fp
    2798:	0010c20a 	andseq	ip, r0, sl, lsl #4
    279c:	190a0b00 	stmdbne	sl, {r8, r9, fp}
    27a0:	00000ba7 	andeq	r0, r0, r7, lsr #23
    27a4:	12eb0a04 	rscne	r0, fp, #4, 20	; 0x4000
    27a8:	0b0b0000 	bleq	2c27b0 <_bss_end+0x2b6ab4>
    27ac:	000bad13 	andeq	sl, fp, r3, lsl sp
    27b0:	10000800 	andne	r0, r0, r0, lsl #16
    27b4:	000b7204 	andeq	r7, fp, r4, lsl #4
    27b8:	23041000 	movwcs	r1, #16384	; 0x4000
    27bc:	0900000b 	stmdbeq	r0, {r0, r1, r3}
    27c0:	000010fe 	strdeq	r1, [r0], -lr
    27c4:	070e0b0c 	streq	r0, [lr, -ip, lsl #22]
    27c8:	00000c9b 	muleq	r0, fp, ip
    27cc:	0011ff0a 	andseq	pc, r1, sl, lsl #30
    27d0:	12120b00 	andsne	r0, r2, #0, 22
    27d4:	00000063 	andeq	r0, r0, r3, rrx
    27d8:	13b60a00 			; <UNDEFINED> instruction: 0x13b60a00
    27dc:	150b0000 	strne	r0, [fp, #-0]
    27e0:	000ba71d 	andeq	sl, fp, sp, lsl r7
    27e4:	bb0a0400 	bllt	2837ec <_bss_end+0x277af0>
    27e8:	0b000012 	bleq	2838 <CPSR_IRQ_INHIBIT+0x27b8>
    27ec:	0ba71d18 	bleq	fe9c9c54 <_bss_end+0xfe9bdf58>
    27f0:	1a080000 	bne	2027f8 <_bss_end+0x1f6afc>
    27f4:	00001371 	andeq	r1, r0, r1, ror r3
    27f8:	0d0e1b0b 	vstreq	d1, [lr, #-44]	; 0xffffffd4
    27fc:	fb000013 	blx	2852 <CPSR_IRQ_INHIBIT+0x27d2>
    2800:	0600000b 	streq	r0, [r0], -fp
    2804:	0c00000c 	stceq	0, cr0, [r0], {12}
    2808:	00000ca0 	andeq	r0, r0, r0, lsr #25
    280c:	000ba70d 	andeq	sl, fp, sp, lsl #14
    2810:	fe0b0000 	cdp2	0, 0, cr0, cr11, cr0, {0}
    2814:	0b000010 	bleq	285c <CPSR_IRQ_INHIBIT+0x27dc>
    2818:	112e091e 			; <UNDEFINED> instruction: 0x112e091e
    281c:	0ca00000 	stceq	0, cr0, [r0]
    2820:	1f010000 	svcne	0x00010000
    2824:	2500000c 	strcs	r0, [r0, #-12]
    2828:	0c00000c 	stceq	0, cr0, [r0], {12}
    282c:	00000ca0 	andeq	r0, r0, r0, lsr #25
    2830:	135d0e00 	cmpne	sp, #0, 28
    2834:	210b0000 	mrscs	r0, (UNDEF: 11)
    2838:	00108a0e 	andseq	r8, r0, lr, lsl #20
    283c:	0c3a0100 	ldfeqs	f0, [sl], #-0
    2840:	0c400000 	mareq	acc0, r0, r0
    2844:	a00c0000 	andge	r0, ip, r0
    2848:	0000000c 	andeq	r0, r0, ip
    284c:	0010ef0b 	andseq	lr, r0, fp, lsl #30
    2850:	12240b00 	eorne	r0, r4, #0, 22
    2854:	000010c7 	andeq	r1, r0, r7, asr #1
    2858:	00000063 	andeq	r0, r0, r3, rrx
    285c:	000c5901 	andeq	r5, ip, r1, lsl #18
    2860:	000c6400 	andeq	r6, ip, r0, lsl #8
    2864:	0ca00c00 	stceq	12, cr0, [r0]
    2868:	090d0000 	stmdbeq	sp, {}	; <UNPREDICTABLE>
    286c:	00000007 	andeq	r0, r0, r7
    2870:	0012fd0e 	andseq	pc, r2, lr, lsl #26
    2874:	0e270b00 	vmuleq.f64	d0, d7, d0
    2878:	00001210 	andeq	r1, r0, r0, lsl r2
    287c:	000c7901 	andeq	r7, ip, r1, lsl #18
    2880:	000c7f00 	andeq	r7, ip, r0, lsl #30
    2884:	0ca00c00 	stceq	12, cr0, [r0]
    2888:	0f000000 	svceq	0x00000000
    288c:	00001148 	andeq	r1, r0, r8, asr #2
    2890:	8d172a0b 	vldrhi	s4, [r7, #-44]	; 0xffffffd4
    2894:	ad000012 	stcge	0, cr0, [r0, #-72]	; 0xffffffb8
    2898:	0100000b 	tsteq	r0, fp
    289c:	00000c94 	muleq	r0, r4, ip
    28a0:	000ca60c 	andeq	sl, ip, ip, lsl #12
    28a4:	03000000 	movweq	r0, #0
    28a8:	00000bb3 			; <UNDEFINED> instruction: 0x00000bb3
    28ac:	0bb30410 	bleq	fecc38f4 <_bss_end+0xfecb7bf8>
    28b0:	04100000 	ldreq	r0, [r0], #-0
    28b4:	00000c9b 	muleq	r0, fp, ip
    28b8:	0016f012 	andseq	pc, r6, r2, lsl r0	; <UNPREDICTABLE>
    28bc:	192d0b00 	pushne	{r8, r9, fp}
    28c0:	00000bb3 			; <UNDEFINED> instruction: 0x00000bb3
    28c4:	00112426 	andseq	r2, r1, r6, lsr #8
    28c8:	0f0e0100 	svceq	0x000e0100
    28cc:	0000026a 	andeq	r0, r0, sl, ror #4
    28d0:	acd80305 	ldclge	3, cr0, [r8], {5}
    28d4:	63270000 			; <UNDEFINED> instruction: 0x63270000
    28d8:	01000012 	tsteq	r0, r2, lsl r0
    28dc:	006f1411 	rsbeq	r1, pc, r1, lsl r4	; <UNPREDICTABLE>
    28e0:	03050000 	movweq	r0, #20480	; 0x5000
    28e4:	0000ab5c 	andeq	sl, r0, ip, asr fp
    28e8:	0013a928 	andseq	sl, r3, r8, lsr #18
    28ec:	10630100 	rsbne	r0, r3, r0, lsl #2
    28f0:	00000038 	andeq	r0, r0, r8, lsr r0
    28f4:	000095cc 	andeq	r9, r0, ip, asr #11
    28f8:	000000dc 	ldrdeq	r0, [r0], -ip
    28fc:	9f299c01 	svcls	0x00299c01
    2900:	01000013 	tsteq	r0, r3, lsl r0
    2904:	95641152 	strbls	r1, [r4, #-338]!	; 0xfffffeae
    2908:	00680000 	rsbeq	r0, r8, r0
    290c:	9c010000 	stcls	0, cr0, [r1], {-0}
    2910:	00000d16 	andeq	r0, r0, r6, lsl sp
    2914:	0100692a 	tsteq	r0, sl, lsr #18
    2918:	003f0f54 	eorseq	r0, pc, r4, asr pc	; <UNPREDICTABLE>
    291c:	91020000 	mrsls	r0, (UNDEF: 2)
    2920:	95290074 	strls	r0, [r9, #-116]!	; 0xffffff8c
    2924:	01000013 	tsteq	r0, r3, lsl r0
    2928:	94fc1141 	ldrbtls	r1, [ip], #321	; 0x141
    292c:	00680000 	rsbeq	r0, r8, r0
    2930:	9c010000 	stcls	0, cr0, [r1], {-0}
    2934:	00000d3a 	andeq	r0, r0, sl, lsr sp
    2938:	0100692a 	tsteq	r0, sl, lsr #18
    293c:	003f0f43 	eorseq	r0, pc, r3, asr #30
    2940:	91020000 	mrsls	r0, (UNDEF: 2)
    2944:	c9290074 	stmdbgt	r9!, {r2, r4, r5, r6}
    2948:	01000013 	tsteq	r0, r3, lsl r0
    294c:	94941130 	ldrls	r1, [r4], #304	; 0x130
    2950:	00680000 	rsbeq	r0, r8, r0
    2954:	9c010000 	stcls	0, cr0, [r1], {-0}
    2958:	00000d5e 	andeq	r0, r0, lr, asr sp
    295c:	0100692a 	tsteq	r0, sl, lsr #18
    2960:	003f0f32 	eorseq	r0, pc, r2, lsr pc	; <UNPREDICTABLE>
    2964:	91020000 	mrsls	r0, (UNDEF: 2)
    2968:	8b290074 	blhi	a42b40 <_bss_end+0xa36e44>
    296c:	01000013 	tsteq	r0, r3, lsl r0
    2970:	942c111f 	strtls	r1, [ip], #-287	; 0xfffffee1
    2974:	00680000 	rsbeq	r0, r8, r0
    2978:	9c010000 	stcls	0, cr0, [r1], {-0}
    297c:	00000d82 	andeq	r0, r0, r2, lsl #27
    2980:	0100692a 	tsteq	r0, sl, lsr #18
    2984:	003f0f21 	eorseq	r0, pc, r1, lsr #30
    2988:	91020000 	mrsls	r0, (UNDEF: 2)
    298c:	242b0074 	strtcs	r0, [fp], #-116	; 0xffffff8c
    2990:	0100000c 	tsteq	r0, ip
    2994:	93d01117 	bicsls	r1, r0, #-1073741819	; 0xc0000005
    2998:	005c0000 	subseq	r0, ip, r0
    299c:	9c010000 	stcls	0, cr0, [r1], {-0}
    29a0:	00049f00 	andeq	r9, r4, r0, lsl #30
    29a4:	30000400 	andcc	r0, r0, r0, lsl #8
    29a8:	0400000e 	streq	r0, [r0], #-14
    29ac:	00000001 	andeq	r0, r0, r1
    29b0:	14bd0400 	ldrtne	r0, [sp], #1024	; 0x400
    29b4:	00b60000 	adcseq	r0, r6, r0
    29b8:	96a80000 	strtls	r0, [r8], r0
    29bc:	036c0000 	cmneq	ip, #0
    29c0:	101f0000 	andsne	r0, pc, r0
    29c4:	01020000 	mrseq	r0, (UNDEF: 2)
    29c8:	0004a008 	andeq	sl, r4, r8
    29cc:	05020200 	streq	r0, [r2, #-512]	; 0xfffffe00
    29d0:	00000280 	andeq	r0, r0, r0, lsl #5
    29d4:	69050403 	stmdbvs	r5, {r0, r1, sl}
    29d8:	0400746e 	streq	r7, [r0], #-1134	; 0xfffffb92
    29dc:	00000a59 	andeq	r0, r0, r9, asr sl
    29e0:	46070902 	strmi	r0, [r7], -r2, lsl #18
    29e4:	02000000 	andeq	r0, r0, #0
    29e8:	04970801 	ldreq	r0, [r7], #2049	; 0x801
    29ec:	02020000 	andeq	r0, r2, #0
    29f0:	00050207 	andeq	r0, r5, r7, lsl #4
    29f4:	03290400 			; <UNDEFINED> instruction: 0x03290400
    29f8:	0b020000 	bleq	82a00 <_bss_end+0x76d04>
    29fc:	00006507 	andeq	r6, r0, r7, lsl #10
    2a00:	00540500 	subseq	r0, r4, r0, lsl #10
    2a04:	04020000 	streq	r0, [r2], #-0
    2a08:	001eef07 	andseq	lr, lr, r7, lsl #30
    2a0c:	00650500 	rsbeq	r0, r5, r0, lsl #10
    2a10:	43060000 	movwmi	r0, #24576	; 0x6000
    2a14:	10000013 	andne	r0, r0, r3, lsl r0
    2a18:	b3080803 	movwlt	r0, #34819	; 0x8803
    2a1c:	07000000 	streq	r0, [r0, -r0]
    2a20:	0000107b 	andeq	r1, r0, fp, ror r0
    2a24:	b3200a03 			; <UNDEFINED> instruction: 0xb3200a03
    2a28:	00000000 	andeq	r0, r0, r0
    2a2c:	0010c207 	andseq	ip, r0, r7, lsl #4
    2a30:	200b0300 	andcs	r0, fp, r0, lsl #6
    2a34:	000000b3 	strheq	r0, [r0], -r3
    2a38:	11890704 	orrne	r0, r9, r4, lsl #14
    2a3c:	0c030000 	stceq	0, cr0, [r3], {-0}
    2a40:	0000540e 	andeq	r5, r0, lr, lsl #8
    2a44:	0f070800 	svceq	0x00070800
    2a48:	03000011 	movweq	r0, #17
    2a4c:	00b90a0d 	adcseq	r0, r9, sp, lsl #20
    2a50:	000c0000 	andeq	r0, ip, r0
    2a54:	00710408 	rsbseq	r0, r1, r8, lsl #8
    2a58:	01020000 	mrseq	r0, (UNDEF: 2)
    2a5c:	00033202 	andeq	r3, r3, r2, lsl #4
    2a60:	123f0900 	eorsne	r0, pc, #0, 18
    2a64:	03040000 	movweq	r0, #16384	; 0x4000
    2a68:	01580710 	cmpeq	r8, r0, lsl r7
    2a6c:	06070000 	streq	r0, [r7], -r0
    2a70:	03000013 	movweq	r0, #19
    2a74:	00b32413 	adcseq	r2, r3, r3, lsl r4
    2a78:	0a000000 	beq	2a80 <CPSR_IRQ_INHIBIT+0x2a00>
    2a7c:	0000137b 	andeq	r1, r0, fp, ror r3
    2a80:	5c241503 	cfstr32pl	mvfx1, [r4], #-12
    2a84:	b3000011 	movwlt	r0, #17
    2a88:	f2000000 	vhadd.s8	d0, d0, d0
    2a8c:	f8000000 			; <UNDEFINED> instruction: 0xf8000000
    2a90:	0b000000 	bleq	2a98 <CPSR_IRQ_INHIBIT+0x2a18>
    2a94:	00000158 	andeq	r0, r0, r8, asr r1
    2a98:	123f0c00 	eorsne	r0, pc, #0, 24
    2a9c:	18030000 	stmdane	r3, {}	; <UNPREDICTABLE>
    2aa0:	0011e109 	andseq	lr, r1, r9, lsl #2
    2aa4:	00015800 	andeq	r5, r1, r0, lsl #16
    2aa8:	01110100 	tsteq	r1, r0, lsl #2
    2aac:	01170000 	tsteq	r7, r0
    2ab0:	580b0000 	stmdapl	fp, {}	; <UNPREDICTABLE>
    2ab4:	00000001 	andeq	r0, r0, r1
    2ab8:	00125d0c 	andseq	r5, r2, ip, lsl #26
    2abc:	0f1a0300 	svceq	0x001a0300
    2ac0:	0000126b 	andeq	r1, r0, fp, ror #4
    2ac4:	00000163 	andeq	r0, r0, r3, ror #2
    2ac8:	00013001 	andeq	r3, r1, r1
    2acc:	00013b00 	andeq	r3, r1, r0, lsl #22
    2ad0:	01580b00 	cmpeq	r8, r0, lsl #22
    2ad4:	540d0000 	strpl	r0, [sp], #-0
    2ad8:	00000000 	andeq	r0, r0, r0
    2adc:	00118e0e 	andseq	r8, r1, lr, lsl #28
    2ae0:	0e1b0300 	cdpeq	3, 1, cr0, cr11, cr0, {0}
    2ae4:	000011b5 			; <UNDEFINED> instruction: 0x000011b5
    2ae8:	00014c01 	andeq	r4, r1, r1, lsl #24
    2aec:	01580b00 	cmpeq	r8, r0, lsl #22
    2af0:	630d0000 	movwvs	r0, #53248	; 0xd000
    2af4:	00000001 	andeq	r0, r0, r1
    2af8:	c0040800 	andgt	r0, r4, r0, lsl #16
    2afc:	05000000 	streq	r0, [r0, #-0]
    2b00:	00000158 	andeq	r0, r0, r8, asr r1
    2b04:	7310040f 	tstvc	r0, #251658240	; 0xf000000
    2b08:	03000014 	movweq	r0, #20
    2b0c:	00c01d24 	sbceq	r1, r0, r4, lsr #26
    2b10:	68110000 	ldmdavs	r1, {}	; <UNPREDICTABLE>
    2b14:	04006c61 	streq	r6, [r0], #-3169	; 0xfffff39f
    2b18:	01eb0b07 	mvneq	r0, r7, lsl #22
    2b1c:	80120000 	andshi	r0, r2, r0
    2b20:	04000006 	streq	r0, [r0], #-6
    2b24:	006c1909 	rsbeq	r1, ip, r9, lsl #18
    2b28:	b2800000 	addlt	r0, r0, #0
    2b2c:	e6120ee6 	ldr	r0, [r2], -r6, ror #29
    2b30:	04000003 	streq	r0, [r0], #-3
    2b34:	01f71a0c 	mvnseq	r1, ip, lsl #20
    2b38:	00000000 	andeq	r0, r0, r0
    2b3c:	c4122000 	ldrgt	r2, [r2], #-0
    2b40:	04000004 	streq	r0, [r0], #-4
    2b44:	01f71a0f 	mvnseq	r1, pc, lsl #20
    2b48:	00000000 	andeq	r0, r0, r0
    2b4c:	30132020 	andscc	r2, r3, r0, lsr #32
    2b50:	04000005 	streq	r0, [r0], #-5
    2b54:	00601512 	rsbeq	r1, r0, r2, lsl r5
    2b58:	12360000 	eorsne	r0, r6, #0
    2b5c:	00000627 	andeq	r0, r0, r7, lsr #12
    2b60:	f71a4404 			; <UNDEFINED> instruction: 0xf71a4404
    2b64:	00000001 	andeq	r0, r0, r1
    2b68:	12202150 	eorne	r2, r0, #80, 2
    2b6c:	00000266 	andeq	r0, r0, r6, ror #4
    2b70:	f71a7304 			; <UNDEFINED> instruction: 0xf71a7304
    2b74:	00000001 	andeq	r0, r0, r1
    2b78:	122000b2 	eorne	r0, r0, #178	; 0xb2
    2b7c:	00000544 	andeq	r0, r0, r4, asr #10
    2b80:	f71aa604 			; <UNDEFINED> instruction: 0xf71aa604
    2b84:	00000001 	andeq	r0, r0, r1
    2b88:	002000b4 	strhteq	r0, [r0], -r4
    2b8c:	00017d14 	andeq	r7, r1, r4, lsl sp
    2b90:	07040200 	streq	r0, [r4, -r0, lsl #4]
    2b94:	00001eea 	andeq	r1, r0, sl, ror #29
    2b98:	0001f005 	andeq	pc, r1, r5
    2b9c:	018d1400 	orreq	r1, sp, r0, lsl #8
    2ba0:	9d140000 	ldcls	0, cr0, [r4, #-0]
    2ba4:	14000001 	strne	r0, [r0], #-1
    2ba8:	000001ad 	andeq	r0, r0, sp, lsr #3
    2bac:	0001ba14 	andeq	fp, r1, r4, lsl sl
    2bb0:	01ca1400 	biceq	r1, sl, r0, lsl #8
    2bb4:	da140000 	ble	502bbc <_bss_end+0x4f6ec0>
    2bb8:	11000001 	tstne	r0, r1
    2bbc:	006d656d 	rsbeq	r6, sp, sp, ror #10
    2bc0:	730b0605 	movwvc	r0, #46597	; 0xb605
    2bc4:	12000002 	andne	r0, r0, #2
    2bc8:	000011d7 	ldrdeq	r1, [r0], -r7
    2bcc:	60180a05 	andsvs	r0, r8, r5, lsl #20
    2bd0:	00000000 	andeq	r0, r0, r0
    2bd4:	12000200 	andne	r0, r0, #0, 4
    2bd8:	000010b7 	strheq	r1, [r0], -r7
    2bdc:	60180d05 	andsvs	r0, r8, r5, lsl #26
    2be0:	00000000 	andeq	r0, r0, r0
    2be4:	15200000 	strne	r0, [r0, #-0]!
    2be8:	00001429 	andeq	r1, r0, r9, lsr #8
    2bec:	60181005 	andsvs	r1, r8, r5
    2bf0:	00000000 	andeq	r0, r0, r0
    2bf4:	12da1240 	sbcsne	r1, sl, #64, 4
    2bf8:	13050000 	movwne	r0, #20480	; 0x5000
    2bfc:	00006018 	andeq	r6, r0, r8, lsl r0
    2c00:	fe000000 	cdp2	0, 0, cr0, cr0, cr0, {0}
    2c04:	1080151f 	addne	r1, r0, pc, lsl r5
    2c08:	16050000 	strne	r0, [r5], -r0
    2c0c:	00006018 	andeq	r6, r0, r8, lsl r0
    2c10:	007ff800 	rsbseq	pc, pc, r0, lsl #16
    2c14:	00022614 	andeq	r2, r2, r4, lsl r6
    2c18:	02361400 	eorseq	r1, r6, #0, 8
    2c1c:	46140000 	ldrmi	r0, [r4], -r0
    2c20:	14000002 	strne	r0, [r0], #-2
    2c24:	00000254 	andeq	r0, r0, r4, asr r2
    2c28:	00026414 	andeq	r6, r2, r4, lsl r4
    2c2c:	15721600 	ldrbne	r1, [r2, #-1536]!	; 0xfffffa00
    2c30:	0fff0000 	svceq	0x00ff0000
    2c34:	26070906 	strcs	r0, [r7], -r6, lsl #18
    2c38:	07000003 	streq	r0, [r0, -r3]
    2c3c:	00001457 	andeq	r1, r0, r7, asr r4
    2c40:	26110c06 	ldrcs	r0, [r1], -r6, lsl #24
    2c44:	00000003 	andeq	r0, r0, r3
    2c48:	00145217 	andseq	r5, r4, r7, lsl r2
    2c4c:	0e0e0600 	cfmadd32eq	mvax0, mvfx0, mvfx14, mvfx0
    2c50:	00001521 	andeq	r1, r0, r1, lsr #10
    2c54:	000002bb 			; <UNDEFINED> instruction: 0x000002bb
    2c58:	000002cb 	andeq	r0, r0, fp, asr #5
    2c5c:	0003370b 	andeq	r3, r3, fp, lsl #14
    2c60:	00540d00 	subseq	r0, r4, r0, lsl #26
    2c64:	b90d0000 	stmdblt	sp, {}	; <UNPREDICTABLE>
    2c68:	00000000 	andeq	r0, r0, r0
    2c6c:	0015720c 	andseq	r7, r5, ip, lsl #4
    2c70:	09110600 	ldmdbeq	r1, {r9, sl}
    2c74:	0000153c 	andeq	r1, r0, ip, lsr r5
    2c78:	00000337 	andeq	r0, r0, r7, lsr r3
    2c7c:	0002e401 	andeq	lr, r2, r1, lsl #8
    2c80:	0002ea00 	andeq	lr, r2, r0, lsl #20
    2c84:	03370b00 	teqeq	r7, #0, 22
    2c88:	0c000000 	stceq	0, cr0, [r0], {-0}
    2c8c:	00001437 	andeq	r1, r0, r7, lsr r4
    2c90:	7e121406 	cfmulsvc	mvf1, mvf2, mvf6
    2c94:	54000014 	strpl	r0, [r0], #-20	; 0xffffffec
    2c98:	01000000 	mrseq	r0, (UNDEF: 0)
    2c9c:	00000303 	andeq	r0, r0, r3, lsl #6
    2ca0:	00000309 	andeq	r0, r0, r9, lsl #6
    2ca4:	0003370b 	andeq	r3, r3, fp, lsl #14
    2ca8:	420e0000 	andmi	r0, lr, #0
    2cac:	06000014 			; <UNDEFINED> instruction: 0x06000014
    2cb0:	15530e16 	ldrbne	r0, [r3, #-3606]	; 0xfffff1ea
    2cb4:	1a010000 	bne	42cbc <_bss_end+0x36fc0>
    2cb8:	0b000003 	bleq	2ccc <CPSR_IRQ_INHIBIT+0x2c4c>
    2cbc:	00000337 	andeq	r0, r0, r7, lsr r3
    2cc0:	0000540d 	andeq	r5, r0, sp, lsl #8
    2cc4:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
    2cc8:	0000003a 	andeq	r0, r0, sl, lsr r0
    2ccc:	00000337 	andeq	r0, r0, r7, lsr r3
    2cd0:	00006519 	andeq	r6, r0, r9, lsl r5
    2cd4:	000ffe00 	andeq	pc, pc, r0, lsl #28
    2cd8:	028c0408 	addeq	r0, ip, #8, 8	; 0x8000000
    2cdc:	08100000 	ldmdaeq	r0, {}	; <UNPREDICTABLE>
    2ce0:	06000016 			; <UNDEFINED> instruction: 0x06000016
    2ce4:	028c1619 	addeq	r1, ip, #26214400	; 0x1900000
    2ce8:	651a0000 	ldrvs	r0, [sl, #-0]
    2cec:	01000001 	tsteq	r0, r1
    2cf0:	03051604 	movweq	r1, #22020	; 0x5604
    2cf4:	0000acdc 	ldrdeq	sl, [r0], -ip
    2cf8:	0014641b 	andseq	r6, r4, fp, lsl r4
    2cfc:	0099f800 	addseq	pc, r9, r0, lsl #16
    2d00:	00001c00 	andeq	r1, r0, r0, lsl #24
    2d04:	1c9c0100 	ldfnes	f0, [ip], {0}
    2d08:	0000054f 	andeq	r0, r0, pc, asr #10
    2d0c:	000099ac 	andeq	r9, r0, ip, lsr #19
    2d10:	0000004c 	andeq	r0, r0, ip, asr #32
    2d14:	03989c01 	orrseq	r9, r8, #256	; 0x100
    2d18:	321d0000 	andscc	r0, sp, #0
    2d1c:	01000004 	tsteq	r0, r4
    2d20:	00330157 	eorseq	r0, r3, r7, asr r1
    2d24:	91020000 	mrsls	r0, (UNDEF: 2)
    2d28:	05ed1d74 	strbeq	r1, [sp, #3444]!	; 0xd74
    2d2c:	57010000 	strpl	r0, [r1, -r0]
    2d30:	00003301 	andeq	r3, r0, r1, lsl #6
    2d34:	70910200 	addsvc	r0, r1, r0, lsl #4
    2d38:	013b1e00 	teqeq	fp, r0, lsl #28
    2d3c:	42010000 	andmi	r0, r1, #0
    2d40:	0003b206 	andeq	fp, r3, r6, lsl #4
    2d44:	00989000 	addseq	r9, r8, r0
    2d48:	00011c00 	andeq	r1, r1, r0, lsl #24
    2d4c:	dd9c0100 	ldfles	f0, [ip]
    2d50:	1f000003 	svcne	0x00000003
    2d54:	00000582 	andeq	r0, r0, r2, lsl #11
    2d58:	0000015e 	andeq	r0, r0, lr, asr r1
    2d5c:	206c9102 	rsbcs	r9, ip, r2, lsl #2
    2d60:	006d656d 	rsbeq	r6, sp, sp, ror #10
    2d64:	63274201 			; <UNDEFINED> instruction: 0x63274201
    2d68:	02000001 	andeq	r0, r0, #1
    2d6c:	4c216891 	stcmi	8, cr6, [r1], #-580	; 0xfffffdbc
    2d70:	01000014 	tsteq	r0, r4, lsl r0
    2d74:	00b32044 	adcseq	r2, r3, r4, asr #32
    2d78:	91020000 	mrsls	r0, (UNDEF: 2)
    2d7c:	171e0074 			; <UNDEFINED> instruction: 0x171e0074
    2d80:	01000001 	tsteq	r0, r1
    2d84:	03f70717 	mvnseq	r0, #6029312	; 0x5c0000
    2d88:	97440000 	strbls	r0, [r4, -r0]
    2d8c:	014c0000 	mrseq	r0, (UNDEF: 76)
    2d90:	9c010000 	stcls	0, cr0, [r1], {-0}
    2d94:	00000431 	andeq	r0, r0, r1, lsr r4
    2d98:	0005821f 	andeq	r8, r5, pc, lsl r2
    2d9c:	00015e00 	andeq	r5, r1, r0, lsl #28
    2da0:	6c910200 	lfmvs	f0, 4, [r1], {0}
    2da4:	0011891d 	andseq	r8, r1, sp, lsl r9
    2da8:	2c170100 	ldfcss	f0, [r7], {-0}
    2dac:	00000054 	andeq	r0, r0, r4, asr r0
    2db0:	21689102 	cmncs	r8, r2, lsl #2
    2db4:	0000144c 	andeq	r1, r0, ip, asr #8
    2db8:	b3201901 			; <UNDEFINED> instruction: 0xb3201901
    2dbc:	02000000 	andeq	r0, r0, #0
    2dc0:	32217491 	eorcc	r7, r1, #-1862270976	; 0x91000000
    2dc4:	01000014 	tsteq	r0, r4, lsl r0
    2dc8:	00b32033 	adcseq	r2, r3, r3, lsr r0
    2dcc:	91020000 	mrsls	r0, (UNDEF: 2)
    2dd0:	da220070 	ble	882f98 <_bss_end+0x87729c>
    2dd4:	01000000 	mrseq	r0, (UNDEF: 0)
    2dd8:	044b1c0c 	strbeq	r1, [fp], #-3084	; 0xfffff3f4
    2ddc:	96dc0000 	ldrbls	r0, [ip], r0
    2de0:	00680000 	rsbeq	r0, r8, r0
    2de4:	9c010000 	stcls	0, cr0, [r1], {-0}
    2de8:	00000467 	andeq	r0, r0, r7, ror #8
    2dec:	0005821f 	andeq	r8, r5, pc, lsl r2
    2df0:	00015e00 	andeq	r5, r1, r0, lsl #28
    2df4:	6c910200 	lfmvs	f0, 4, [r1], {0}
    2df8:	00144c21 	andseq	r4, r4, r1, lsr #24
    2dfc:	200e0100 	andcs	r0, lr, r0, lsl #2
    2e00:	000000b3 	strheq	r0, [r0], -r3
    2e04:	00749102 	rsbseq	r9, r4, r2, lsl #2
    2e08:	0000f823 	andeq	pc, r0, r3, lsr #16
    2e0c:	01060100 	mrseq	r0, (UNDEF: 22)
    2e10:	00000478 	andeq	r0, r0, r8, ror r4
    2e14:	00048200 	andeq	r8, r4, r0, lsl #4
    2e18:	05822400 	streq	r2, [r2, #1024]	; 0x400
    2e1c:	015e0000 	cmpeq	lr, r0
    2e20:	25000000 	strcs	r0, [r0, #-0]
    2e24:	00000467 	andeq	r0, r0, r7, ror #8
    2e28:	0000149f 	muleq	r0, pc, r4	; <UNPREDICTABLE>
    2e2c:	00000499 	muleq	r0, r9, r4
    2e30:	000096a8 	andeq	r9, r0, r8, lsr #13
    2e34:	00000034 	andeq	r0, r0, r4, lsr r0
    2e38:	78269c01 	stmdavc	r6!, {r0, sl, fp, ip, pc}
    2e3c:	02000004 	andeq	r0, r0, #4
    2e40:	00007491 	muleq	r0, r1, r4
    2e44:	00000484 	andeq	r0, r0, r4, lsl #9
    2e48:	10940004 	addsne	r0, r4, r4
    2e4c:	01040000 	mrseq	r0, (UNDEF: 4)
    2e50:	00000000 	andeq	r0, r0, r0
    2e54:	00159b04 	andseq	r9, r5, r4, lsl #22
    2e58:	0000b600 	andeq	fp, r0, r0, lsl #12
    2e5c:	009a1400 	addseq	r1, sl, r0, lsl #8
    2e60:	00040000 	andeq	r0, r4, r0
    2e64:	0012d700 	andseq	sp, r2, r0, lsl #14
    2e68:	08010200 	stmdaeq	r1, {r9}
    2e6c:	000004a0 	andeq	r0, r0, r0, lsr #9
    2e70:	80050202 	andhi	r0, r5, r2, lsl #4
    2e74:	03000002 	movweq	r0, #2
    2e78:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
    2e7c:	59040074 	stmdbpl	r4, {r2, r4, r5, r6}
    2e80:	0200000a 	andeq	r0, r0, #10
    2e84:	00460709 	subeq	r0, r6, r9, lsl #14
    2e88:	01020000 	mrseq	r0, (UNDEF: 2)
    2e8c:	00049708 	andeq	r9, r4, r8, lsl #14
    2e90:	07020200 	streq	r0, [r2, -r0, lsl #4]
    2e94:	00000502 	andeq	r0, r0, r2, lsl #10
    2e98:	00032904 	andeq	r2, r3, r4, lsl #18
    2e9c:	070b0200 	streq	r0, [fp, -r0, lsl #4]
    2ea0:	00000065 	andeq	r0, r0, r5, rrx
    2ea4:	00005405 	andeq	r5, r0, r5, lsl #8
    2ea8:	07040200 	streq	r0, [r4, -r0, lsl #4]
    2eac:	00001eef 	andeq	r1, r0, pc, ror #29
    2eb0:	00006505 	andeq	r6, r0, r5, lsl #10
    2eb4:	61680600 	cmnvs	r8, r0, lsl #12
    2eb8:	0703006c 	streq	r0, [r3, -ip, rrx]
    2ebc:	0000eb0b 	andeq	lr, r0, fp, lsl #22
    2ec0:	06800700 	streq	r0, [r0], r0, lsl #14
    2ec4:	09030000 	stmdbeq	r3, {}	; <UNPREDICTABLE>
    2ec8:	00006c19 	andeq	r6, r0, r9, lsl ip
    2ecc:	e6b28000 	ldrt	r8, [r2], r0
    2ed0:	03e6070e 	mvneq	r0, #3670016	; 0x380000
    2ed4:	0c030000 	stceq	0, cr0, [r3], {-0}
    2ed8:	0000f71a 	andeq	pc, r0, sl, lsl r7	; <UNPREDICTABLE>
    2edc:	00000000 	andeq	r0, r0, r0
    2ee0:	04c40720 	strbeq	r0, [r4], #1824	; 0x720
    2ee4:	0f030000 	svceq	0x00030000
    2ee8:	0000f71a 	andeq	pc, r0, sl, lsl r7	; <UNPREDICTABLE>
    2eec:	20000000 	andcs	r0, r0, r0
    2ef0:	05300820 	ldreq	r0, [r0, #-2080]!	; 0xfffff7e0
    2ef4:	12030000 	andne	r0, r3, #0
    2ef8:	00006015 	andeq	r6, r0, r5, lsl r0
    2efc:	27073600 	strcs	r3, [r7, -r0, lsl #12]
    2f00:	03000006 	movweq	r0, #6
    2f04:	00f71a44 	rscseq	r1, r7, r4, asr #20
    2f08:	50000000 	andpl	r0, r0, r0
    2f0c:	66072021 	strvs	r2, [r7], -r1, lsr #32
    2f10:	03000002 	movweq	r0, #2
    2f14:	00f71a73 	rscseq	r1, r7, r3, ror sl
    2f18:	b2000000 	andlt	r0, r0, #0
    2f1c:	44072000 	strmi	r2, [r7], #-0
    2f20:	03000005 	movweq	r0, #5
    2f24:	00f71aa6 	rscseq	r1, r7, r6, lsr #21
    2f28:	b4000000 	strlt	r0, [r0], #-0
    2f2c:	09002000 	stmdbeq	r0, {sp}
    2f30:	0000007d 	andeq	r0, r0, sp, ror r0
    2f34:	ea070402 	b	1c3f44 <_bss_end+0x1b8248>
    2f38:	0500001e 	streq	r0, [r0, #-30]	; 0xffffffe2
    2f3c:	000000f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    2f40:	00008d09 	andeq	r8, r0, r9, lsl #26
    2f44:	009d0900 	addseq	r0, sp, r0, lsl #18
    2f48:	ad090000 	stcge	0, cr0, [r9, #-0]
    2f4c:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
    2f50:	000000ba 	strheq	r0, [r0], -sl
    2f54:	0000ca09 	andeq	ip, r0, r9, lsl #20
    2f58:	00da0900 	sbcseq	r0, sl, r0, lsl #18
    2f5c:	6d060000 	stcvs	0, cr0, [r6, #-0]
    2f60:	04006d65 	streq	r6, [r0], #-3429	; 0xfffff29b
    2f64:	01730b06 	cmneq	r3, r6, lsl #22
    2f68:	d7070000 	strle	r0, [r7, -r0]
    2f6c:	04000011 	streq	r0, [r0], #-17	; 0xffffffef
    2f70:	0060180a 	rsbeq	r1, r0, sl, lsl #16
    2f74:	00000000 	andeq	r0, r0, r0
    2f78:	b7070002 	strlt	r0, [r7, -r2]
    2f7c:	04000010 	streq	r0, [r0], #-16
    2f80:	0060180d 	rsbeq	r1, r0, sp, lsl #16
    2f84:	00000000 	andeq	r0, r0, r0
    2f88:	290a2000 	stmdbcs	sl, {sp}
    2f8c:	04000014 	streq	r0, [r0], #-20	; 0xffffffec
    2f90:	00601810 	rsbeq	r1, r0, r0, lsl r8
    2f94:	40000000 	andmi	r0, r0, r0
    2f98:	0012da07 	andseq	sp, r2, r7, lsl #20
    2f9c:	18130400 	ldmdane	r3, {sl}
    2fa0:	00000060 	andeq	r0, r0, r0, rrx
    2fa4:	1ffe0000 	svcne	0x00fe0000
    2fa8:	0010800a 	andseq	r8, r0, sl
    2fac:	18160400 	ldmdane	r6, {sl}
    2fb0:	00000060 	andeq	r0, r0, r0, rrx
    2fb4:	09007ff8 	stmdbeq	r0, {r3, r4, r5, r6, r7, r8, r9, sl, fp, ip, sp, lr}
    2fb8:	00000126 	andeq	r0, r0, r6, lsr #2
    2fbc:	00013609 	andeq	r3, r1, r9, lsl #12
    2fc0:	01460900 	cmpeq	r6, r0, lsl #18
    2fc4:	54090000 	strpl	r0, [r9], #-0
    2fc8:	09000001 	stmdbeq	r0, {r0}
    2fcc:	00000164 	andeq	r0, r0, r4, ror #2
    2fd0:	0015720b 	andseq	r7, r5, fp, lsl #4
    2fd4:	050fff00 	streq	pc, [pc, #-3840]	; 20dc <CPSR_IRQ_INHIBIT+0x205c>
    2fd8:	02260709 	eoreq	r0, r6, #2359296	; 0x240000
    2fdc:	570c0000 	strpl	r0, [ip, -r0]
    2fe0:	05000014 	streq	r0, [r0, #-20]	; 0xffffffec
    2fe4:	0226110c 	eoreq	r1, r6, #12, 2
    2fe8:	0d000000 	stceq	0, cr0, [r0, #-0]
    2fec:	00001452 	andeq	r1, r0, r2, asr r4
    2ff0:	210e0e05 	tstcs	lr, r5, lsl #28
    2ff4:	bb000015 	bllt	3050 <CPSR_IRQ_INHIBIT+0x2fd0>
    2ff8:	cb000001 	blgt	3004 <CPSR_IRQ_INHIBIT+0x2f84>
    2ffc:	0e000001 	cdpeq	0, 0, cr0, cr0, cr1, {0}
    3000:	00000237 	andeq	r0, r0, r7, lsr r2
    3004:	0000540f 	andeq	r5, r0, pc, lsl #8
    3008:	02420f00 	subeq	r0, r2, #0, 30
    300c:	10000000 	andne	r0, r0, r0
    3010:	00001572 	andeq	r1, r0, r2, ror r5
    3014:	3c091105 	stfccs	f1, [r9], {5}
    3018:	37000015 	smladcc	r0, r5, r0, r0
    301c:	01000002 	tsteq	r0, r2
    3020:	000001e4 	andeq	r0, r0, r4, ror #3
    3024:	000001ea 	andeq	r0, r0, sl, ror #3
    3028:	0002370e 	andeq	r3, r2, lr, lsl #14
    302c:	37100000 	ldrcc	r0, [r0, -r0]
    3030:	05000014 	streq	r0, [r0, #-20]	; 0xffffffec
    3034:	147e1214 	ldrbtne	r1, [lr], #-532	; 0xfffffdec
    3038:	00540000 	subseq	r0, r4, r0
    303c:	03010000 	movweq	r0, #4096	; 0x1000
    3040:	09000002 	stmdbeq	r0, {r1}
    3044:	0e000002 	cdpeq	0, 0, cr0, cr0, cr2, {0}
    3048:	00000237 	andeq	r0, r0, r7, lsr r2
    304c:	14421100 	strbne	r1, [r2], #-256	; 0xffffff00
    3050:	16050000 	strne	r0, [r5], -r0
    3054:	0015530e 	andseq	r5, r5, lr, lsl #6
    3058:	021a0100 	andseq	r0, sl, #0, 2
    305c:	370e0000 	strcc	r0, [lr, -r0]
    3060:	0f000002 	svceq	0x00000002
    3064:	00000054 	andeq	r0, r0, r4, asr r0
    3068:	3a120000 	bcc	483070 <_bss_end+0x477374>
    306c:	37000000 	strcc	r0, [r0, -r0]
    3070:	13000002 	movwne	r0, #2
    3074:	00000065 	andeq	r0, r0, r5, rrx
    3078:	14000ffe 	strne	r0, [r0], #-4094	; 0xfffff002
    307c:	00018c04 	andeq	r8, r1, r4, lsl #24
    3080:	02370500 	eorseq	r0, r7, #0, 10
    3084:	01020000 	mrseq	r0, (UNDEF: 2)
    3088:	00033202 	andeq	r3, r3, r2, lsl #4
    308c:	16081500 	strne	r1, [r8], -r0, lsl #10
    3090:	19050000 	stmdbne	r5, {}	; <UNPREDICTABLE>
    3094:	00018c16 	andeq	r8, r1, r6, lsl ip
    3098:	02491600 	subeq	r1, r9, #0, 12
    309c:	03010000 	movweq	r0, #4096	; 0x1000
    30a0:	e003050f 	and	r0, r3, pc, lsl #10
    30a4:	170000ac 	strne	r0, [r0, -ip, lsr #1]
    30a8:	000015f9 	strdeq	r1, [r0], -r9
    30ac:	00009df8 	strdeq	r9, [r0], -r8
    30b0:	0000001c 	andeq	r0, r0, ip, lsl r0
    30b4:	4f189c01 	svcmi	0x00189c01
    30b8:	ac000005 	stcge	0, cr0, [r0], {5}
    30bc:	4c00009d 	stcmi	0, cr0, [r0], {157}	; 0x9d
    30c0:	01000000 	mrseq	r0, (UNDEF: 0)
    30c4:	0002a49c 	muleq	r2, ip, r4
    30c8:	04321900 	ldrteq	r1, [r2], #-2304	; 0xfffff700
    30cc:	62010000 	andvs	r0, r1, #0
    30d0:	00003301 	andeq	r3, r0, r1, lsl #6
    30d4:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    30d8:	0005ed19 	andeq	lr, r5, r9, lsl sp
    30dc:	01620100 	cmneq	r2, r0, lsl #2
    30e0:	00000033 	andeq	r0, r0, r3, lsr r0
    30e4:	00709102 	rsbseq	r9, r0, r2, lsl #2
    30e8:	0002091a 	andeq	r0, r2, sl, lsl r9
    30ec:	065d0100 	ldrbeq	r0, [sp], -r0, lsl #2
    30f0:	000002be 			; <UNDEFINED> instruction: 0x000002be
    30f4:	00009d74 	andeq	r9, r0, r4, ror sp
    30f8:	00000038 	andeq	r0, r0, r8, lsr r0
    30fc:	02d99c01 	sbcseq	r9, r9, #256	; 0x100
    3100:	821b0000 	andshi	r0, fp, #0
    3104:	3d000005 	stccc	0, cr0, [r0, #-20]	; 0xffffffec
    3108:	02000002 	andeq	r0, r0, #2
    310c:	661c7491 			; <UNDEFINED> instruction: 0x661c7491
    3110:	5d010061 	stcpl	0, cr0, [r1, #-388]	; 0xfffffe7c
    3114:	00005428 	andeq	r5, r0, r8, lsr #8
    3118:	70910200 	addsvc	r0, r1, r0, lsl #4
    311c:	01ea1a00 	mvneq	r1, r0, lsl #20
    3120:	3f010000 	svccc	0x00010000
    3124:	0002f30a 	andeq	pc, r2, sl, lsl #6
    3128:	009c8c00 	addseq	r8, ip, r0, lsl #24
    312c:	0000e800 	andeq	lr, r0, r0, lsl #16
    3130:	339c0100 	orrscc	r0, ip, #0, 2
    3134:	1b000003 	blne	3148 <CPSR_IRQ_INHIBIT+0x30c8>
    3138:	00000582 	andeq	r0, r0, r2, lsl #11
    313c:	0000023d 	andeq	r0, r0, sp, lsr r2
    3140:	1d649102 	stfnep	f1, [r4, #-8]!
    3144:	44010069 	strmi	r0, [r1], #-105	; 0xffffff97
    3148:	0000540e 	andeq	r5, r0, lr, lsl #8
    314c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    3150:	01006a1d 	tsteq	r0, sp, lsl sl
    3154:	00541144 	subseq	r1, r4, r4, asr #2
    3158:	91020000 	mrsls	r0, (UNDEF: 2)
    315c:	9d0c1e70 	stcls	14, cr1, [ip, #-448]	; 0xfffffe40
    3160:	00340000 	eorseq	r0, r4, r0
    3164:	921f0000 	andsls	r0, pc, #0
    3168:	01000015 	tsteq	r0, r5, lsl r0
    316c:	00602452 	rsbeq	r2, r0, r2, asr r4
    3170:	91020000 	mrsls	r0, (UNDEF: 2)
    3174:	1a00006c 	bne	332c <CPSR_IRQ_INHIBIT+0x32ac>
    3178:	000001a7 	andeq	r0, r0, r7, lsr #3
    317c:	4d063701 	stcmi	7, cr3, [r6, #-4]
    3180:	b8000003 	stmdalt	r0, {r0, r1}
    3184:	d400009b 	strle	r0, [r0], #-155	; 0xffffff65
    3188:	01000000 	mrseq	r0, (UNDEF: 0)
    318c:	0003789c 	muleq	r3, ip, r8
    3190:	05821b00 	streq	r1, [r2, #2816]	; 0xb00
    3194:	023d0000 	eorseq	r0, sp, #0
    3198:	91020000 	mrsls	r0, (UNDEF: 2)
    319c:	1592196c 	ldrne	r1, [r2, #2412]	; 0x96c
    31a0:	37010000 	strcc	r0, [r1, -r0]
    31a4:	00005423 	andeq	r5, r0, r3, lsr #8
    31a8:	68910200 	ldmvs	r1, {r9}
    31ac:	00163219 	andseq	r3, r6, r9, lsl r2
    31b0:	32370100 	eorscc	r0, r7, #0, 2
    31b4:	00000242 	andeq	r0, r0, r2, asr #4
    31b8:	00679102 	rsbeq	r9, r7, r2, lsl #2
    31bc:	0001cb20 	andeq	ip, r1, r0, lsr #22
    31c0:	012e0100 			; <UNDEFINED> instruction: 0x012e0100
    31c4:	00000389 	andeq	r0, r0, r9, lsl #7
    31c8:	00039f00 	andeq	r9, r3, r0, lsl #30
    31cc:	05822100 	streq	r2, [r2, #256]	; 0x100
    31d0:	023d0000 	eorseq	r0, sp, #0
    31d4:	23220000 			; <UNDEFINED> instruction: 0x23220000
    31d8:	31010069 	tstcc	r1, r9, rrx
    31dc:	0000330e 	andeq	r3, r0, lr, lsl #6
    31e0:	24000000 	strcs	r0, [r0], #-0
    31e4:	00000378 	andeq	r0, r0, r8, ror r3
    31e8:	00001637 	andeq	r1, r0, r7, lsr r6
    31ec:	000003ba 			; <UNDEFINED> instruction: 0x000003ba
    31f0:	00009b54 	andeq	r9, r0, r4, asr fp
    31f4:	00000064 	andeq	r0, r0, r4, rrx
    31f8:	03e89c01 	mvneq	r9, #256	; 0x100
    31fc:	89250000 	stmdbhi	r5!, {}	; <UNPREDICTABLE>
    3200:	02000003 	andeq	r0, r0, #3
    3204:	92266c91 	eorls	r6, r6, #37120	; 0x9100
    3208:	d1000003 	tstle	r0, r3
    320c:	27000003 	strcs	r0, [r0, -r3]
    3210:	00000393 	muleq	r0, r3, r3
    3214:	03922800 	orrseq	r2, r2, #0, 16
    3218:	9b640000 	blls	1903220 <_bss_end+0x18f7524>
    321c:	003c0000 	eorseq	r0, ip, r0
    3220:	93290000 			; <UNDEFINED> instruction: 0x93290000
    3224:	02000003 	andeq	r0, r0, #3
    3228:	00007491 	muleq	r0, r1, r4
    322c:	0015852a 	andseq	r8, r5, sl, lsr #10
    3230:	0a1b0100 	beq	6c3638 <_bss_end+0x6b793c>
    3234:	0000161f 	andeq	r1, r0, pc, lsl r6
    3238:	00000065 	andeq	r0, r0, r5, rrx
    323c:	00009ac4 	andeq	r9, r0, r4, asr #21
    3240:	00000090 	muleq	r0, r0, r0
    3244:	04349c01 	ldrteq	r9, [r4], #-3073	; 0xfffff3ff
    3248:	16190000 	ldrne	r0, [r9], -r0
    324c:	01000016 	tsteq	r0, r6, lsl r0
    3250:	0065201b 	rsbeq	r2, r5, fp, lsl r0
    3254:	91020000 	mrsls	r0, (UNDEF: 2)
    3258:	164e196c 	strbne	r1, [lr], -ip, ror #18
    325c:	1b010000 	blne	43264 <_bss_end+0x37568>
    3260:	00006533 	andeq	r6, r0, r3, lsr r5
    3264:	68910200 	ldmvs	r1, {r9}
    3268:	0015801f 	andseq	r8, r5, pc, lsl r0
    326c:	0e1c0100 	mufeqe	f0, f4, f0
    3270:	00000065 	andeq	r0, r0, r5, rrx
    3274:	00749102 	rsbseq	r9, r4, r2, lsl #2
    3278:	0016562b 	andseq	r5, r6, fp, lsr #12
    327c:	11050100 	mrsne	r0, (UNDEF: 21)
    3280:	00000065 	andeq	r0, r0, r5, rrx
    3284:	00009a14 	andeq	r9, r0, r4, lsl sl
    3288:	000000b0 	strheq	r0, [r0], -r0	; <UNPREDICTABLE>
    328c:	16199c01 	ldrne	r9, [r9], -r1, lsl #24
    3290:	01000016 	tsteq	r0, r6, lsl r0
    3294:	00652605 	rsbeq	r2, r5, r5, lsl #12
    3298:	91020000 	mrsls	r0, (UNDEF: 2)
    329c:	164e196c 	strbne	r1, [lr], -ip, ror #18
    32a0:	05010000 	streq	r0, [r1, #-0]
    32a4:	00006539 	andeq	r6, r0, r9, lsr r5
    32a8:	68910200 	ldmvs	r1, {r9}
    32ac:	0006b91f 	andeq	fp, r6, pc, lsl r9
    32b0:	0e060100 	adfeqs	f0, f6, f0
    32b4:	00000065 	andeq	r0, r0, r5, rrx
    32b8:	1f749102 	svcne	0x00749102
    32bc:	00001580 	andeq	r1, r0, r0, lsl #11
    32c0:	650e0701 	strvs	r0, [lr, #-1793]	; 0xfffff8ff
    32c4:	02000000 	andeq	r0, r0, #0
    32c8:	00007091 	muleq	r0, r1, r0
    32cc:	00000a8d 	andeq	r0, r0, sp, lsl #21
    32d0:	13260004 			; <UNDEFINED> instruction: 0x13260004
    32d4:	01040000 	mrseq	r0, (UNDEF: 4)
    32d8:	00000000 	andeq	r0, r0, r0
    32dc:	00171f04 	andseq	r1, r7, r4, lsl #30
    32e0:	0000b600 	andeq	fp, r0, r0, lsl #12
    32e4:	00003800 	andeq	r3, r0, r0, lsl #16
    32e8:	00000000 	andeq	r0, r0, r0
    32ec:	00155900 	andseq	r5, r5, r0, lsl #18
    32f0:	08010200 	stmdaeq	r1, {r9}
    32f4:	000004a0 	andeq	r0, r0, r0, lsr #9
    32f8:	00002503 	andeq	r2, r0, r3, lsl #10
    32fc:	05020200 	streq	r0, [r2, #-512]	; 0xfffffe00
    3300:	00000280 	andeq	r0, r0, r0, lsl #5
    3304:	69050404 	stmdbvs	r5, {r2, sl}
    3308:	0500746e 	streq	r7, [r0, #-1134]	; 0xfffffb92
    330c:	00000a59 	andeq	r0, r0, r9, asr sl
    3310:	4b070903 	blmi	1c5724 <_bss_end+0x1b9a28>
    3314:	02000000 	andeq	r0, r0, #0
    3318:	04970801 	ldreq	r0, [r7], #2049	; 0x801
    331c:	4b060000 	blmi	183324 <_bss_end+0x177628>
    3320:	02000000 	andeq	r0, r0, #0
    3324:	05020702 	streq	r0, [r2, #-1794]	; 0xfffff8fe
    3328:	29050000 	stmdbcs	r5, {}	; <UNPREDICTABLE>
    332c:	03000003 	movweq	r0, #3
    3330:	006f070b 	rsbeq	r0, pc, fp, lsl #14
    3334:	5e030000 	cdppl	0, 0, cr0, cr3, cr0, {0}
    3338:	02000000 	andeq	r0, r0, #0
    333c:	1eef0704 	cdpne	7, 14, cr0, cr15, cr4, {0}
    3340:	6f030000 	svcvs	0x00030000
    3344:	07000000 	streq	r0, [r0, -r0]
    3348:	00001193 	muleq	r0, r3, r1
    334c:	00380405 	eorseq	r0, r8, r5, lsl #8
    3350:	04040000 	streq	r0, [r4], #-0
    3354:	0000a60c 	andeq	sl, r0, ip, lsl #12
    3358:	654e0800 	strbvs	r0, [lr, #-2048]	; 0xfffff800
    335c:	09000077 	stmdbeq	r0, {r0, r1, r2, r4, r5, r6}
    3360:	00001254 	andeq	r1, r0, r4, asr r2
    3364:	0c060901 			; <UNDEFINED> instruction: 0x0c060901
    3368:	09020000 	stmdbeq	r2, {}	; <UNPREDICTABLE>
    336c:	00001209 	andeq	r1, r0, r9, lsl #4
    3370:	170a0003 	strne	r0, [sl, -r3]
    3374:	0c000011 	stceq	0, cr0, [r0], {17}
    3378:	d8081104 	stmdale	r8, {r2, r8, ip}
    337c:	0b000000 	bleq	3384 <CPSR_IRQ_INHIBIT+0x3304>
    3380:	0400726c 	streq	r7, [r0], #-620	; 0xfffffd94
    3384:	00d81313 	sbcseq	r1, r8, r3, lsl r3
    3388:	0b000000 	bleq	3390 <CPSR_IRQ_INHIBIT+0x3310>
    338c:	04007073 	streq	r7, [r0], #-115	; 0xffffff8d
    3390:	00d81314 	sbcseq	r1, r8, r4, lsl r3
    3394:	0b040000 	bleq	10339c <_bss_end+0xf76a0>
    3398:	04006370 	streq	r6, [r0], #-880	; 0xfffffc90
    339c:	00d81315 	sbcseq	r1, r8, r5, lsl r3
    33a0:	00080000 	andeq	r0, r8, r0
    33a4:	ea070402 	b	1c43b4 <_bss_end+0x1b86b8>
    33a8:	0300001e 	movweq	r0, #30
    33ac:	000000d8 	ldrdeq	r0, [r0], -r8
    33b0:	0012f00a 	andseq	pc, r2, sl
    33b4:	1b041c00 	blne	10a3bc <_bss_end+0xfe6c0>
    33b8:	00013308 	andeq	r3, r1, r8, lsl #6
    33bc:	12ce0c00 	sbcne	r0, lr, #0, 24
    33c0:	1d040000 	stcne	0, cr0, [r4, #-0]
    33c4:	0000a612 	andeq	sl, r0, r2, lsl r6
    33c8:	700b0000 	andvc	r0, fp, r0
    33cc:	04006469 	streq	r6, [r0], #-1129	; 0xfffffb97
    33d0:	006f121e 	rsbeq	r1, pc, lr, lsl r2	; <UNPREDICTABLE>
    33d4:	0c0c0000 	stceq	0, cr0, [ip], {-0}
    33d8:	00001c3b 	andeq	r1, r0, fp, lsr ip
    33dc:	7b111f04 	blvc	44aff4 <_bss_end+0x43f2f8>
    33e0:	10000000 	andne	r0, r0, r0
    33e4:	0012310c 	andseq	r3, r2, ip, lsl #2
    33e8:	12200400 	eorne	r0, r0, #0, 8
    33ec:	0000006f 	andeq	r0, r0, pc, rrx
    33f0:	119f0c14 	orrsne	r0, pc, r4, lsl ip	; <UNPREDICTABLE>
    33f4:	21040000 	mrscs	r0, (UNDEF: 4)
    33f8:	00006f12 	andeq	r6, r0, r2, lsl pc
    33fc:	0a001800 	beq	9404 <Timer_Callback+0x34>
    3400:	00001330 	andeq	r1, r0, r0, lsr r3
    3404:	0807050c 	stmdaeq	r7, {r2, r3, r8, sl}
    3408:	00000168 	andeq	r0, r0, r8, ror #2
    340c:	00107b0c 	andseq	r7, r0, ip, lsl #22
    3410:	19090500 	stmdbne	r9, {r8, sl}
    3414:	00000168 	andeq	r0, r0, r8, ror #2
    3418:	10c20c00 	sbcne	r0, r2, r0, lsl #24
    341c:	0a050000 	beq	143424 <_bss_end+0x137728>
    3420:	00016819 	andeq	r6, r1, r9, lsl r8
    3424:	eb0c0400 	bl	30442c <_bss_end+0x2f8730>
    3428:	05000012 	streq	r0, [r0, #-18]	; 0xffffffee
    342c:	016e130b 	cmneq	lr, fp, lsl #6
    3430:	00080000 	andeq	r0, r8, r0
    3434:	0133040d 	teqeq	r3, sp, lsl #8
    3438:	040d0000 	streq	r0, [sp], #-0
    343c:	000000e4 	andeq	r0, r0, r4, ror #1
    3440:	0010fe0e 	andseq	pc, r0, lr, lsl #28
    3444:	0e050c00 	cdpeq	12, 0, cr0, cr5, cr0, {0}
    3448:	00025c07 	andeq	r5, r2, r7, lsl #24
    344c:	11ff0c00 	mvnsne	r0, r0, lsl #24
    3450:	12050000 	andne	r0, r5, #0
    3454:	00005e12 	andeq	r5, r0, r2, lsl lr
    3458:	b60c0000 	strlt	r0, [ip], -r0
    345c:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
    3460:	01681d15 	cmneq	r8, r5, lsl sp
    3464:	0c040000 	stceq	0, cr0, [r4], {-0}
    3468:	000012bb 			; <UNDEFINED> instruction: 0x000012bb
    346c:	681d1805 	ldmdavs	sp, {r0, r2, fp, ip}
    3470:	08000001 	stmdaeq	r0, {r0}
    3474:	0013710f 	andseq	r7, r3, pc, lsl #2
    3478:	0e1b0500 	cfmul32eq	mvfx0, mvfx11, mvfx0
    347c:	0000130d 	andeq	r1, r0, sp, lsl #6
    3480:	000001bc 			; <UNDEFINED> instruction: 0x000001bc
    3484:	000001c7 	andeq	r0, r0, r7, asr #3
    3488:	00026110 	andeq	r6, r2, r0, lsl r1
    348c:	01681100 	cmneq	r8, r0, lsl #2
    3490:	12000000 	andne	r0, r0, #0
    3494:	000010fe 	strdeq	r1, [r0], -lr
    3498:	2e091e05 	cdpcs	14, 0, cr1, cr9, cr5, {0}
    349c:	61000011 	tstvs	r0, r1, lsl r0
    34a0:	01000002 	tsteq	r0, r2
    34a4:	000001e0 	andeq	r0, r0, r0, ror #3
    34a8:	000001e6 	andeq	r0, r0, r6, ror #3
    34ac:	00026110 	andeq	r6, r2, r0, lsl r1
    34b0:	5d130000 	ldcpl	0, cr0, [r3, #-0]
    34b4:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
    34b8:	108a0e21 	addne	r0, sl, r1, lsr #28
    34bc:	fb010000 	blx	434c6 <_bss_end+0x377ca>
    34c0:	01000001 	tsteq	r0, r1
    34c4:	10000002 	andne	r0, r0, r2
    34c8:	00000261 	andeq	r0, r0, r1, ror #4
    34cc:	10ef1200 	rscne	r1, pc, r0, lsl #4
    34d0:	24050000 	strcs	r0, [r5], #-0
    34d4:	0010c712 	andseq	ip, r0, r2, lsl r7
    34d8:	00005e00 	andeq	r5, r0, r0, lsl #28
    34dc:	021a0100 	andseq	r0, sl, #0, 2
    34e0:	02250000 	eoreq	r0, r5, #0
    34e4:	61100000 	tstvs	r0, r0
    34e8:	11000002 	tstne	r0, r2
    34ec:	000000d8 	ldrdeq	r0, [r0], -r8
    34f0:	12fd1300 	rscsne	r1, sp, #0, 6
    34f4:	27050000 	strcs	r0, [r5, -r0]
    34f8:	0012100e 	andseq	r1, r2, lr
    34fc:	023a0100 	eorseq	r0, sl, #0, 2
    3500:	02400000 	subeq	r0, r0, #0
    3504:	61100000 	tstvs	r0, r0
    3508:	00000002 	andeq	r0, r0, r2
    350c:	00114814 	andseq	r4, r1, r4, lsl r8
    3510:	172a0500 	strne	r0, [sl, -r0, lsl #10]!
    3514:	0000128d 	andeq	r1, r0, sp, lsl #5
    3518:	0000016e 	andeq	r0, r0, lr, ror #2
    351c:	00025501 	andeq	r5, r2, r1, lsl #10
    3520:	026c1000 	rsbeq	r1, ip, #0
    3524:	00000000 	andeq	r0, r0, r0
    3528:	00017403 	andeq	r7, r1, r3, lsl #8
    352c:	74040d00 	strvc	r0, [r4], #-3328	; 0xfffff300
    3530:	03000001 	movweq	r0, #1
    3534:	00000261 	andeq	r0, r0, r1, ror #4
    3538:	025c040d 	subseq	r0, ip, #218103808	; 0xd000000
    353c:	6c030000 	stcvs	0, cr0, [r3], {-0}
    3540:	15000002 	strne	r0, [r0, #-2]
    3544:	000016f0 	strdeq	r1, [r0], -r0
    3548:	74192d05 	ldrvc	r2, [r9], #-3333	; 0xfffff2fb
    354c:	0e000001 	cdpeq	0, 0, cr0, cr0, cr1, {0}
    3550:	000007f8 	strdeq	r0, [r0], -r8
    3554:	07030618 	smladeq	r3, r8, r6, r0
    3558:	00000514 	andeq	r0, r0, r4, lsl r5
    355c:	00075416 	andeq	r5, r7, r6, lsl r4
    3560:	6f040700 	svcvs	0x00040700
    3564:	06000000 	streq	r0, [r0], -r0
    3568:	b0011006 	andlt	r1, r1, r6
    356c:	08000002 	stmdaeq	r0, {r1}
    3570:	00584548 	subseq	r4, r8, r8, asr #10
    3574:	45440810 	strbmi	r0, [r4, #-2064]	; 0xfffff7f0
    3578:	000a0043 	andeq	r0, sl, r3, asr #32
    357c:	00029003 	andeq	r9, r2, r3
    3580:	07610a00 	strbeq	r0, [r1, -r0, lsl #20]!
    3584:	06080000 	streq	r0, [r8], -r0
    3588:	02d90c27 	sbcseq	r0, r9, #9984	; 0x2700
    358c:	790b0000 	stmdbvc	fp, {}	; <UNPREDICTABLE>
    3590:	16290600 	strtne	r0, [r9], -r0, lsl #12
    3594:	0000006f 	andeq	r0, r0, pc, rrx
    3598:	00780b00 	rsbseq	r0, r8, r0, lsl #22
    359c:	6f162a06 	svcvs	0x00162a06
    35a0:	04000000 	streq	r0, [r0], #-0
    35a4:	08ec1700 	stmiaeq	ip!, {r8, r9, sl, ip}^
    35a8:	0c060000 	stceq	0, cr0, [r6], {-0}
    35ac:	0002b01b 	andeq	fp, r2, fp, lsl r0
    35b0:	180a0100 	stmdane	sl, {r8}
    35b4:	0000085f 	andeq	r0, r0, pc, asr r8
    35b8:	1a280d06 	bne	a069d8 <_bss_end+0x9facdc>
    35bc:	01000005 	tsteq	r0, r5
    35c0:	0007f819 	andeq	pc, r7, r9, lsl r8	; <UNPREDICTABLE>
    35c4:	0e100600 	cfmsub32eq	mvax0, mvfx0, mvfx0, mvfx0
    35c8:	000008d9 	ldrdeq	r0, [r0], -r9
    35cc:	0000051f 	andeq	r0, r0, pc, lsl r5
    35d0:	00030d01 	andeq	r0, r3, r1, lsl #26
    35d4:	00032200 	andeq	r2, r3, r0, lsl #4
    35d8:	051f1000 	ldreq	r1, [pc, #-0]	; 35e0 <CPSR_IRQ_INHIBIT+0x3560>
    35dc:	6f110000 	svcvs	0x00110000
    35e0:	11000000 	mrsne	r0, (UNDEF: 0)
    35e4:	0000006f 	andeq	r0, r0, pc, rrx
    35e8:	00006f11 	andeq	r6, r0, r1, lsl pc
    35ec:	0e130000 	cdpeq	0, 1, cr0, cr3, cr0, {0}
    35f0:	0600000b 	streq	r0, [r0], -fp
    35f4:	07c10a12 	bfieq	r0, r2, (invalid: 20:1)
    35f8:	37010000 	strcc	r0, [r1, -r0]
    35fc:	3d000003 	stccc	0, cr0, [r0, #-12]
    3600:	10000003 	andne	r0, r0, r3
    3604:	0000051f 	andeq	r0, r0, pc, lsl r5
    3608:	08181200 	ldmdaeq	r8, {r9, ip}
    360c:	14060000 	strne	r0, [r6], #-0
    3610:	00087c0f 	andeq	r7, r8, pc, lsl #24
    3614:	00052500 	andeq	r2, r5, r0, lsl #10
    3618:	03560100 	cmpeq	r6, #0, 2
    361c:	03610000 	cmneq	r1, #0
    3620:	1f100000 	svcne	0x00100000
    3624:	11000005 	tstne	r0, r5
    3628:	00000025 	andeq	r0, r0, r5, lsr #32
    362c:	08181200 	ldmdaeq	r8, {r9, ip}
    3630:	15060000 	strne	r0, [r6, #-0]
    3634:	0008230f 	andeq	r2, r8, pc, lsl #6
    3638:	00052500 	andeq	r2, r5, r0, lsl #10
    363c:	037a0100 	cmneq	sl, #0, 2
    3640:	03850000 	orreq	r0, r5, #0
    3644:	1f100000 	svcne	0x00100000
    3648:	11000005 	tstne	r0, r5
    364c:	00000514 	andeq	r0, r0, r4, lsl r5
    3650:	08181200 	ldmdaeq	r8, {r9, ip}
    3654:	16060000 	strne	r0, [r6], -r0
    3658:	0007d60f 	andeq	sp, r7, pc, lsl #12
    365c:	00052500 	andeq	r2, r5, r0, lsl #10
    3660:	039e0100 	orrseq	r0, lr, #0, 2
    3664:	03a90000 			; <UNDEFINED> instruction: 0x03a90000
    3668:	1f100000 	svcne	0x00100000
    366c:	11000005 	tstne	r0, r5
    3670:	00000290 	muleq	r0, r0, r2
    3674:	08181200 	ldmdaeq	r8, {r9, ip}
    3678:	17060000 	strne	r0, [r6, -r0]
    367c:	0008ab0f 	andeq	sl, r8, pc, lsl #22
    3680:	00052500 	andeq	r2, r5, r0, lsl #10
    3684:	03c20100 	biceq	r0, r2, #0, 2
    3688:	03cd0000 	biceq	r0, sp, #0
    368c:	1f100000 	svcne	0x00100000
    3690:	11000005 	tstne	r0, r5
    3694:	0000006f 	andeq	r0, r0, pc, rrx
    3698:	08181200 	ldmdaeq	r8, {r9, ip}
    369c:	18060000 	stmdane	r6, {}	; <UNPREDICTABLE>
    36a0:	00086b0f 	andeq	r6, r8, pc, lsl #22
    36a4:	00052500 	andeq	r2, r5, r0, lsl #10
    36a8:	03e60100 	mvneq	r0, #0, 2
    36ac:	03f10000 	mvnseq	r0, #0
    36b0:	1f100000 	svcne	0x00100000
    36b4:	11000005 	tstne	r0, r5
    36b8:	0000052b 	andeq	r0, r0, fp, lsr #10
    36bc:	073f0f00 	ldreq	r0, [pc, -r0, lsl #30]!
    36c0:	1b060000 	blne	1836c8 <_bss_end+0x1779cc>
    36c4:	00070f11 	andeq	r0, r7, r1, lsl pc
    36c8:	00040500 	andeq	r0, r4, r0, lsl #10
    36cc:	00040b00 	andeq	r0, r4, r0, lsl #22
    36d0:	051f1000 	ldreq	r1, [pc, #-0]	; 36d8 <CPSR_IRQ_INHIBIT+0x3658>
    36d4:	0f000000 	svceq	0x00000000
    36d8:	00000732 	andeq	r0, r0, r2, lsr r7
    36dc:	bc111c06 	ldclt	12, cr1, [r1], {6}
    36e0:	1f000008 	svcne	0x00000008
    36e4:	25000004 	strcs	r0, [r0, #-4]
    36e8:	10000004 	andne	r0, r0, r4
    36ec:	0000051f 	andeq	r0, r0, pc, lsl r5
    36f0:	06d00f00 	ldrbeq	r0, [r0], r0, lsl #30
    36f4:	1d060000 	stcne	0, cr0, [r6, #-0]
    36f8:	00076b11 	andeq	r6, r7, r1, lsl fp
    36fc:	00043900 	andeq	r3, r4, r0, lsl #18
    3700:	00043f00 	andeq	r3, r4, r0, lsl #30
    3704:	051f1000 	ldreq	r1, [pc, #-0]	; 370c <CPSR_IRQ_INHIBIT+0x368c>
    3708:	1a000000 	bne	3710 <CPSR_IRQ_INHIBIT+0x3690>
    370c:	0000074d 	andeq	r0, r0, sp, asr #14
    3710:	01191f06 	tsteq	r9, r6, lsl #30
    3714:	6f000008 	svcvs	0x00000008
    3718:	57000000 	strpl	r0, [r0, -r0]
    371c:	67000004 	strvs	r0, [r0, -r4]
    3720:	10000004 	andne	r0, r0, r4
    3724:	0000051f 	andeq	r0, r0, pc, lsl r5
    3728:	00006f11 	andeq	r6, r0, r1, lsl pc
    372c:	006f1100 	rsbeq	r1, pc, r0, lsl #2
    3730:	1a000000 	bne	3738 <CPSR_IRQ_INHIBIT+0x36b8>
    3734:	00000983 	andeq	r0, r0, r3, lsl #19
    3738:	e2192006 	ands	r2, r9, #6
    373c:	6f000006 	svcvs	0x00000006
    3740:	7f000000 	svcvc	0x00000000
    3744:	8f000004 	svchi	0x00000004
    3748:	10000004 	andne	r0, r0, r4
    374c:	0000051f 	andeq	r0, r0, pc, lsl r5
    3750:	00006f11 	andeq	r6, r0, r1, lsl pc
    3754:	006f1100 	rsbeq	r1, pc, r0, lsl #2
    3758:	0f000000 	svceq	0x00000000
    375c:	000006ac 	andeq	r0, r0, ip, lsr #13
    3760:	950a2206 	strls	r2, [sl, #-518]	; 0xfffffdfa
    3764:	a3000008 	movwge	r0, #8
    3768:	a9000004 	stmdbge	r0, {r2}
    376c:	10000004 	andne	r0, r0, r4
    3770:	0000051f 	andeq	r0, r0, pc, lsl r5
    3774:	072d0f00 	streq	r0, [sp, -r0, lsl #30]!
    3778:	24060000 	strcs	r0, [r6], #-0
    377c:	0008360a 	andeq	r3, r8, sl, lsl #12
    3780:	0004bd00 	andeq	fp, r4, r0, lsl #26
    3784:	0004d200 	andeq	sp, r4, r0, lsl #4
    3788:	051f1000 	ldreq	r1, [pc, #-0]	; 3790 <CPSR_IRQ_INHIBIT+0x3710>
    378c:	6f110000 	svcvs	0x00110000
    3790:	11000000 	mrsne	r0, (UNDEF: 0)
    3794:	00000532 	andeq	r0, r0, r2, lsr r5
    3798:	00006f11 	andeq	r6, r0, r1, lsl pc
    379c:	8d0c0000 	stchi	0, cr0, [ip, #-0]
    37a0:	06000007 	streq	r0, [r0], -r7
    37a4:	053e232e 	ldreq	r2, [lr, #-814]!	; 0xfffffcd2
    37a8:	0c000000 	stceq	0, cr0, [r0], {-0}
    37ac:	0000088d 	andeq	r0, r0, sp, lsl #17
    37b0:	6f122f06 	svcvs	0x00122f06
    37b4:	04000000 	streq	r0, [r0], #-0
    37b8:	00084d0c 	andeq	r4, r8, ip, lsl #26
    37bc:	12300600 	eorsne	r0, r0, #0, 12
    37c0:	0000006f 	andeq	r0, r0, pc, rrx
    37c4:	08560c08 	ldmdaeq	r6, {r3, sl, fp}^
    37c8:	31060000 	mrscc	r0, (UNDEF: 6)
    37cc:	0002b50f 	andeq	fp, r2, pc, lsl #10
    37d0:	c20c0c00 	andgt	r0, ip, #0, 24
    37d4:	06000006 	streq	r0, [r0], -r6
    37d8:	02901232 	addseq	r1, r0, #536870915	; 0x20000003
    37dc:	00140000 	andseq	r0, r4, r0
    37e0:	002c040d 	eoreq	r0, ip, sp, lsl #8
    37e4:	14030000 	strne	r0, [r3], #-0
    37e8:	0d000005 	stceq	0, cr0, [r0, #-20]	; 0xffffffec
    37ec:	00028304 	andeq	r8, r2, r4, lsl #6
    37f0:	83041b00 	movwhi	r1, #19200	; 0x4b00
    37f4:	02000002 	andeq	r0, r0, #2
    37f8:	03320201 	teqeq	r2, #268435456	; 0x10000000
    37fc:	040d0000 	streq	r0, [sp], #-0
    3800:	00000025 	andeq	r0, r0, r5, lsr #32
    3804:	0052040d 	subseq	r0, r2, sp, lsl #8
    3808:	38030000 	stmdacc	r3, {}	; <UNPREDICTABLE>
    380c:	15000005 	strne	r0, [r0, #-5]
    3810:	000007a6 	andeq	r0, r0, r6, lsr #15
    3814:	83113506 	tsthi	r1, #25165824	; 0x1800000
    3818:	0a000002 	beq	3828 <CPSR_IRQ_INHIBIT+0x37a8>
    381c:	00001343 	andeq	r1, r0, r3, asr #6
    3820:	08080210 	stmdaeq	r8, {r4, r9}
    3824:	00000591 	muleq	r0, r1, r5
    3828:	00107b0c 	andseq	r7, r0, ip, lsl #22
    382c:	200a0200 	andcs	r0, sl, r0, lsl #4
    3830:	00000591 	muleq	r0, r1, r5
    3834:	10c20c00 	sbcne	r0, r2, r0, lsl #24
    3838:	0b020000 	bleq	83840 <_bss_end+0x77b44>
    383c:	00059120 	andeq	r9, r5, r0, lsr #2
    3840:	890c0400 	stmdbhi	ip, {sl}
    3844:	02000011 	andeq	r0, r0, #17
    3848:	005e0e0c 	subseq	r0, lr, ip, lsl #28
    384c:	0c080000 	stceq	0, cr0, [r8], {-0}
    3850:	0000110f 	andeq	r1, r0, pc, lsl #2
    3854:	2b0a0d02 	blcs	286c64 <_bss_end+0x27af68>
    3858:	0c000005 	stceq	0, cr0, [r0], {5}
    385c:	4f040d00 	svcmi	0x00040d00
    3860:	0e000005 	cdpeq	0, 0, cr0, cr0, cr5, {0}
    3864:	0000123f 	andeq	r1, r0, pc, lsr r2
    3868:	07100204 	ldreq	r0, [r0, -r4, lsl #4]
    386c:	0000067b 	andeq	r0, r0, fp, ror r6
    3870:	0013060c 	andseq	r0, r3, ip, lsl #12
    3874:	24130200 	ldrcs	r0, [r3], #-512	; 0xfffffe00
    3878:	00000591 	muleq	r0, r1, r5
    387c:	137b1a00 	cmnne	fp, #0, 20
    3880:	15020000 	strne	r0, [r2, #-0]
    3884:	00115c24 	andseq	r5, r1, r4, lsr #24
    3888:	00059100 	andeq	r9, r5, r0, lsl #2
    388c:	0005c900 	andeq	ip, r5, r0, lsl #18
    3890:	0005cf00 	andeq	ip, r5, r0, lsl #30
    3894:	067b1000 	ldrbteq	r1, [fp], -r0
    3898:	12000000 	andne	r0, r0, #0
    389c:	0000123f 	andeq	r1, r0, pc, lsr r2
    38a0:	e1091802 	tst	r9, r2, lsl #16
    38a4:	7b000011 	blvc	38f0 <CPSR_IRQ_INHIBIT+0x3870>
    38a8:	01000006 	tsteq	r0, r6
    38ac:	000005e8 	andeq	r0, r0, r8, ror #11
    38b0:	000005ee 	andeq	r0, r0, lr, ror #11
    38b4:	00067b10 	andeq	r7, r6, r0, lsl fp
    38b8:	5d120000 	ldcpl	0, cr0, [r2, #-0]
    38bc:	02000012 	andeq	r0, r0, #18
    38c0:	126b0f1a 	rsbne	r0, fp, #26, 30	; 0x68
    38c4:	06860000 	streq	r0, [r6], r0
    38c8:	07010000 	streq	r0, [r1, -r0]
    38cc:	12000006 	andne	r0, r0, #6
    38d0:	10000006 	andne	r0, r0, r6
    38d4:	0000067b 	andeq	r0, r0, fp, ror r6
    38d8:	00005e11 	andeq	r5, r0, r1, lsl lr
    38dc:	8e130000 	cdphi	0, 1, cr0, cr3, cr0, {0}
    38e0:	02000011 	andeq	r0, r0, #17
    38e4:	11b50e1b 			; <UNDEFINED> instruction: 0x11b50e1b
    38e8:	27010000 	strcs	r0, [r1, -r0]
    38ec:	32000006 	andcc	r0, r0, #6
    38f0:	10000006 	andne	r0, r0, r6
    38f4:	0000067b 	andeq	r0, r0, fp, ror r6
    38f8:	00068611 	andeq	r8, r6, r1, lsl r6
    38fc:	78120000 	ldmdavc	r2, {}	; <UNPREDICTABLE>
    3900:	02000016 	andeq	r0, r0, #22
    3904:	17880c1e 	usada8ne	r8, lr, ip, r0
    3908:	016e0000 	cmneq	lr, r0
    390c:	52010000 	andpl	r0, r1, #0
    3910:	58000006 	stmdapl	r0, {r1, r2}
    3914:	1c000006 	stcne	0, cr0, [r0], {6}
    3918:	00e40054 	rsceq	r0, r4, r4, asr r0
    391c:	7b100000 	blvc	403924 <_bss_end+0x3f7c28>
    3920:	00000006 	andeq	r0, r0, r6
    3924:	00170514 	andseq	r0, r7, r4, lsl r5
    3928:	0c1e0200 	lfmeq	f0, 4, [lr], {-0}
    392c:	000016a6 	andeq	r1, r0, r6, lsr #13
    3930:	00000168 	andeq	r0, r0, r8, ror #2
    3934:	00067401 	andeq	r7, r6, r1, lsl #8
    3938:	00541c00 	subseq	r1, r4, r0, lsl #24
    393c:	00000133 	andeq	r0, r0, r3, lsr r1
    3940:	00067b10 	andeq	r7, r6, r0, lsl fp
    3944:	0d000000 	stceq	0, cr0, [r0, #-0]
    3948:	00059704 	andeq	r9, r5, r4, lsl #14
    394c:	067b0300 	ldrbteq	r0, [fp], -r0, lsl #6
    3950:	041d0000 	ldreq	r0, [sp], #-0
    3954:	00147315 	andseq	r7, r4, r5, lsl r3
    3958:	1d240200 	sfmne	f0, 4, [r4, #-0]
    395c:	00000597 	muleq	r0, r7, r5
    3960:	6c61681e 	stclvs	8, cr6, [r1], #-120	; 0xffffff88
    3964:	0b070700 	bleq	1c556c <_bss_end+0x1b9870>
    3968:	0000070e 	andeq	r0, r0, lr, lsl #14
    396c:	0006801f 	andeq	r8, r6, pc, lsl r0
    3970:	19090700 	stmdbne	r9, {r8, r9, sl}
    3974:	00000076 	andeq	r0, r0, r6, ror r0
    3978:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}
    397c:	0003e61f 	andeq	lr, r3, pc, lsl r6
    3980:	1a0c0700 	bne	305588 <_bss_end+0x2f988c>
    3984:	000000df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    3988:	20000000 	andcs	r0, r0, r0
    398c:	0004c41f 	andeq	ip, r4, pc, lsl r4
    3990:	1a0f0700 	bne	3c5598 <_bss_end+0x3b989c>
    3994:	000000df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    3998:	20200000 	eorcs	r0, r0, r0
    399c:	00053020 	andeq	r3, r5, r0, lsr #32
    39a0:	15120700 	ldrne	r0, [r2, #-1792]	; 0xfffff900
    39a4:	0000006a 	andeq	r0, r0, sl, rrx
    39a8:	06271f36 	qasxeq	r1, r7, r6
    39ac:	44070000 	strmi	r0, [r7], #-0
    39b0:	0000df1a 	andeq	sp, r0, sl, lsl pc
    39b4:	21500000 	cmpcs	r0, r0
    39b8:	02661f20 	rsbeq	r1, r6, #32, 30	; 0x80
    39bc:	73070000 	movwvc	r0, #28672	; 0x7000
    39c0:	0000df1a 	andeq	sp, r0, sl, lsl pc
    39c4:	00b20000 	adcseq	r0, r2, r0
    39c8:	05441f20 	strbeq	r1, [r4, #-3872]	; 0xfffff0e0
    39cc:	a6070000 	strge	r0, [r7], -r0
    39d0:	0000df1a 	andeq	sp, r0, sl, lsl pc
    39d4:	00b40000 	adcseq	r0, r4, r0
    39d8:	a0210020 	eorge	r0, r1, r0, lsr #32
    39dc:	21000006 	tstcs	r0, r6
    39e0:	000006b0 			; <UNDEFINED> instruction: 0x000006b0
    39e4:	0006c021 	andeq	ip, r6, r1, lsr #32
    39e8:	06d02100 	ldrbeq	r2, [r0], r0, lsl #2
    39ec:	dd210000 	stcle	0, cr0, [r1, #-0]
    39f0:	21000006 	tstcs	r0, r6
    39f4:	000006ed 	andeq	r0, r0, sp, ror #13
    39f8:	0006fd21 	andeq	pc, r6, r1, lsr #26
    39fc:	656d1e00 	strbvs	r1, [sp, #-3584]!	; 0xfffff200
    3a00:	0608006d 	streq	r0, [r8], -sp, rrx
    3a04:	00078a0b 	andeq	r8, r7, fp, lsl #20
    3a08:	11d71f00 	bicsne	r1, r7, r0, lsl #30
    3a0c:	0a080000 	beq	203a14 <_bss_end+0x1f7d18>
    3a10:	00006a18 	andeq	r6, r0, r8, lsl sl
    3a14:	02000000 	andeq	r0, r0, #0
    3a18:	10b71f00 	adcsne	r1, r7, r0, lsl #30
    3a1c:	0d080000 	stceq	0, cr0, [r8, #-0]
    3a20:	00006a18 	andeq	r6, r0, r8, lsl sl
    3a24:	00000000 	andeq	r0, r0, r0
    3a28:	14292220 	strtne	r2, [r9], #-544	; 0xfffffde0
    3a2c:	10080000 	andne	r0, r8, r0
    3a30:	00006a18 	andeq	r6, r0, r8, lsl sl
    3a34:	1f400000 	svcne	0x00400000
    3a38:	000012da 	ldrdeq	r1, [r0], -sl
    3a3c:	6a181308 	bvs	608664 <_bss_end+0x5fc968>
    3a40:	00000000 	andeq	r0, r0, r0
    3a44:	221ffe00 	andscs	pc, pc, #0, 28
    3a48:	00001080 	andeq	r1, r0, r0, lsl #1
    3a4c:	6a181608 	bvs	609274 <_bss_end+0x5fd578>
    3a50:	f8000000 			; <UNDEFINED> instruction: 0xf8000000
    3a54:	3d21007f 	stccc	0, cr0, [r1, #-508]!	; 0xfffffe04
    3a58:	21000007 	tstcs	r0, r7
    3a5c:	0000074d 	andeq	r0, r0, sp, asr #14
    3a60:	00075d21 	andeq	r5, r7, r1, lsr #26
    3a64:	076b2100 	strbeq	r2, [fp, -r0, lsl #2]!
    3a68:	7b210000 	blvc	843a70 <_bss_end+0x837d74>
    3a6c:	23000007 	movwcs	r0, #7
    3a70:	00001572 	andeq	r1, r0, r2, ror r5
    3a74:	09090fff 	stmdbeq	r9, {r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, fp}
    3a78:	00083d07 	andeq	r3, r8, r7, lsl #26
    3a7c:	14570c00 	ldrbne	r0, [r7], #-3072	; 0xfffff400
    3a80:	0c090000 	stceq	0, cr0, [r9], {-0}
    3a84:	00083d11 	andeq	r3, r8, r1, lsl sp
    3a88:	520f0000 	andpl	r0, pc, #0
    3a8c:	09000014 	stmdbeq	r0, {r2, r4}
    3a90:	15210e0e 	strne	r0, [r1, #-3598]!	; 0xfffff1f2
    3a94:	07d20000 	ldrbeq	r0, [r2, r0]
    3a98:	07e20000 	strbeq	r0, [r2, r0]!
    3a9c:	4e100000 	cdpmi	0, 1, cr0, cr0, cr0, {0}
    3aa0:	11000008 	tstne	r0, r8
    3aa4:	0000005e 	andeq	r0, r0, lr, asr r0
    3aa8:	00052b11 	andeq	r2, r5, r1, lsl fp
    3aac:	72120000 	andsvc	r0, r2, #0
    3ab0:	09000015 	stmdbeq	r0, {r0, r2, r4}
    3ab4:	153c0911 	ldrne	r0, [ip, #-2321]!	; 0xfffff6ef
    3ab8:	084e0000 	stmdaeq	lr, {}^	; <UNPREDICTABLE>
    3abc:	fb010000 	blx	43ac6 <_bss_end+0x37dca>
    3ac0:	01000007 	tsteq	r0, r7
    3ac4:	10000008 	andne	r0, r0, r8
    3ac8:	0000084e 	andeq	r0, r0, lr, asr #16
    3acc:	14371200 	ldrtne	r1, [r7], #-512	; 0xfffffe00
    3ad0:	14090000 	strne	r0, [r9], #-0
    3ad4:	00147e12 	andseq	r7, r4, r2, lsl lr
    3ad8:	00005e00 	andeq	r5, r0, r0, lsl #28
    3adc:	081a0100 	ldmdaeq	sl, {r8}
    3ae0:	08200000 	stmdaeq	r0!, {}	; <UNPREDICTABLE>
    3ae4:	4e100000 	cdpmi	0, 1, cr0, cr0, cr0, {0}
    3ae8:	00000008 	andeq	r0, r0, r8
    3aec:	00144224 	andseq	r4, r4, r4, lsr #4
    3af0:	0e160900 	vnmlseq.f16	s0, s12, s0	; <UNPREDICTABLE>
    3af4:	00001553 	andeq	r1, r0, r3, asr r5
    3af8:	00083101 	andeq	r3, r8, r1, lsl #2
    3afc:	084e1000 	stmdaeq	lr, {ip}^
    3b00:	5e110000 	cdppl	0, 1, cr0, cr1, cr0, {0}
    3b04:	00000000 	andeq	r0, r0, r0
    3b08:	003f2500 	eorseq	r2, pc, r0, lsl #10
    3b0c:	084e0000 	stmdaeq	lr, {}^	; <UNPREDICTABLE>
    3b10:	6f260000 	svcvs	0x00260000
    3b14:	fe000000 	cdp2	0, 0, cr0, cr0, cr0, {0}
    3b18:	040d000f 	streq	r0, [sp], #-15
    3b1c:	000007a3 	andeq	r0, r0, r3, lsr #15
    3b20:	00160815 	andseq	r0, r6, r5, lsl r8
    3b24:	16190900 	ldrne	r0, [r9], -r0, lsl #18
    3b28:	000007a3 	andeq	r0, r0, r3, lsr #15
    3b2c:	00027727 	andeq	r7, r2, r7, lsr #14
    3b30:	12100100 	andsne	r0, r0, #0, 2
    3b34:	bce00305 	stcllt	3, cr0, [r0], #20
    3b38:	e1280000 			; <UNDEFINED> instruction: 0xe1280000
    3b3c:	84000016 	strhi	r0, [r0], #-22	; 0xffffffea
    3b40:	1c0000a3 	stcne	0, cr0, [r0], {163}	; 0xa3
    3b44:	01000000 	mrseq	r0, (UNDEF: 0)
    3b48:	054f299c 	strbeq	r2, [pc, #-2460]	; 31b4 <CPSR_IRQ_INHIBIT+0x3134>
    3b4c:	a3380000 	teqge	r8, #0
    3b50:	004c0000 	subeq	r0, ip, r0
    3b54:	9c010000 	stcls	0, cr0, [r1], {-0}
    3b58:	000008af 	andeq	r0, r0, pc, lsr #17
    3b5c:	0004322a 	andeq	r3, r4, sl, lsr #4
    3b60:	01990100 	orrseq	r0, r9, r0, lsl #2
    3b64:	00000038 	andeq	r0, r0, r8, lsr r0
    3b68:	2a749102 	bcs	1d27f78 <_bss_end+0x1d1c27c>
    3b6c:	000005ed 	andeq	r0, r0, sp, ror #11
    3b70:	38019901 	stmdacc	r1, {r0, r8, fp, ip, pc}
    3b74:	02000000 	andeq	r0, r0, #0
    3b78:	2b007091 	blcs	1fdc4 <_bss_end+0x140c8>
    3b7c:	00000632 	andeq	r0, r0, r2, lsr r6
    3b80:	000008cd 	andeq	r0, r0, sp, asr #17
    3b84:	0000a3cc 	andeq	sl, r0, ip, asr #7
    3b88:	0000002c 	andeq	r0, r0, ip, lsr #32
    3b8c:	08da9c01 	ldmeq	sl, {r0, sl, fp, ip, pc}^
    3b90:	541c0000 	ldrpl	r0, [ip], #-0
    3b94:	0000e400 	andeq	lr, r0, r0, lsl #8
    3b98:	05822c00 	streq	r2, [r2, #3072]	; 0xc00
    3b9c:	06810000 	streq	r0, [r1], r0
    3ba0:	91020000 	mrsls	r0, (UNDEF: 2)
    3ba4:	582b0074 	stmdapl	fp!, {r2, r4, r5, r6}
    3ba8:	f8000006 			; <UNDEFINED> instruction: 0xf8000006
    3bac:	a0000008 	andge	r0, r0, r8
    3bb0:	2c0000a3 	stccs	0, cr0, [r0], {163}	; 0xa3
    3bb4:	01000000 	mrseq	r0, (UNDEF: 0)
    3bb8:	0009059c 	muleq	r9, ip, r5
    3bbc:	00541c00 	subseq	r1, r4, r0, lsl #24
    3bc0:	00000133 	andeq	r0, r0, r3, lsr r1
    3bc4:	0005822c 	andeq	r8, r5, ip, lsr #4
    3bc8:	00068100 	andeq	r8, r6, r0, lsl #2
    3bcc:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    3bd0:	01a82d00 			; <UNDEFINED> instruction: 0x01a82d00
    3bd4:	82010000 	andhi	r0, r1, #0
    3bd8:	00091f06 	andeq	r1, r9, r6, lsl #30
    3bdc:	00a23400 	adceq	r3, r2, r0, lsl #8
    3be0:	00010400 	andeq	r0, r1, r0, lsl #8
    3be4:	599c0100 	ldmibpl	ip, {r8}
    3be8:	2c000009 	stccs	0, cr0, [r0], {9}
    3bec:	00000582 	andeq	r0, r0, r2, lsl #11
    3bf0:	00000267 	andeq	r0, r0, r7, ror #4
    3bf4:	2a6c9102 	bcs	1b28004 <_bss_end+0x1b1c308>
    3bf8:	000024a8 	andeq	r2, r0, r8, lsr #9
    3bfc:	68368201 	ldmdavs	r6!, {r0, r9, pc}
    3c00:	02000001 	andeq	r0, r0, #1
    3c04:	6f2e6891 	svcvs	0x002e6891
    3c08:	0100646c 	tsteq	r0, ip, ror #8
    3c0c:	0959138c 	ldmdbeq	r9, {r2, r3, r7, r8, r9, ip}^
    3c10:	91020000 	mrsls	r0, (UNDEF: 2)
    3c14:	166a2f74 	uqsub16ne	r2, sl, r4
    3c18:	8d010000 	stchi	0, cr0, [r1, #-0]
    3c1c:	00052b0a 	andeq	r2, r5, sl, lsl #22
    3c20:	73910200 	orrsvc	r0, r1, #0, 4
    3c24:	a6040d00 	strge	r0, [r4], -r0, lsl #26
    3c28:	2d000000 	stccs	0, cr0, [r0, #-0]
    3c2c:	00000225 	andeq	r0, r0, r5, lsr #4
    3c30:	79065601 	stmdbvc	r6, {r0, r9, sl, ip, lr}
    3c34:	cc000009 	stcgt	0, cr0, [r0], {9}
    3c38:	680000a0 	stmdavs	r0, {r5, r7}
    3c3c:	01000001 	tsteq	r0, r1
    3c40:	0009959c 	muleq	r9, ip, r5
    3c44:	05822c00 	streq	r2, [r2, #3072]	; 0xc00
    3c48:	02670000 	rsbeq	r0, r7, #0
    3c4c:	91020000 	mrsls	r0, (UNDEF: 2)
    3c50:	10c22f6c 	sbcne	r2, r2, ip, ror #30
    3c54:	65010000 	strvs	r0, [r1, #-0]
    3c58:	00016819 	andeq	r6, r1, r9, lsl r8
    3c5c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    3c60:	02012d00 	andeq	r2, r1, #0, 26
    3c64:	38010000 	stmdacc	r1, {}	; <UNPREDICTABLE>
    3c68:	0009af0a 	andeq	sl, r9, sl, lsl #30
    3c6c:	009f9800 	addseq	r9, pc, r0, lsl #16
    3c70:	00013400 	andeq	r3, r1, r0, lsl #8
    3c74:	e99c0100 	ldmib	ip, {r8}
    3c78:	2c000009 	stccs	0, cr0, [r0], {9}
    3c7c:	00000582 	andeq	r0, r0, r2, lsl #11
    3c80:	00000267 	andeq	r0, r0, r7, ror #4
    3c84:	2a6c9102 	bcs	1b28094 <_bss_end+0x1b1c398>
    3c88:	00001662 	andeq	r1, r0, r2, ror #12
    3c8c:	d8393801 	ldmdale	r9!, {r0, fp, ip, sp}
    3c90:	02000000 	andeq	r0, r0, #0
    3c94:	fc2f6891 	vfmal.f16	d6, s31, s2
    3c98:	01000016 	tsteq	r0, r6, lsl r0
    3c9c:	0168193a 	cmneq	r8, sl, lsr r9
    3ca0:	91020000 	mrsls	r0, (UNDEF: 2)
    3ca4:	12eb2f74 	rscne	r2, fp, #116, 30	; 0x1d0
    3ca8:	48010000 	stmdami	r1, {}	; <UNPREDICTABLE>
    3cac:	00016e0b 	andeq	r6, r1, fp, lsl #28
    3cb0:	70910200 	addsvc	r0, r1, r0, lsl #4
    3cb4:	01e62d00 	mvneq	r2, r0, lsl #26
    3cb8:	1d010000 	stcne	0, cr0, [r1, #-0]
    3cbc:	000a0306 	andeq	r0, sl, r6, lsl #6
    3cc0:	009ea000 	addseq	sl, lr, r0
    3cc4:	0000f800 	andeq	pc, r0, r0, lsl #16
    3cc8:	2e9c0100 	fmlcse	f0, f4, f0
    3ccc:	2c00000a 	stccs	0, cr0, [r0], {10}
    3cd0:	00000582 	andeq	r0, r0, r2, lsl #11
    3cd4:	00000267 	andeq	r0, r0, r7, ror #4
    3cd8:	2f6c9102 	svccs	0x006c9102
    3cdc:	000016fc 	strdeq	r1, [r0], -ip
    3ce0:	68191f01 	ldmdavs	r9, {r0, r8, r9, sl, fp, ip}
    3ce4:	02000001 	andeq	r0, r0, #1
    3ce8:	eb2f7491 	bl	be0f34 <_bss_end+0xbd5238>
    3cec:	01000012 	tsteq	r0, r2, lsl r0
    3cf0:	016e0b2e 	cmneq	lr, lr, lsr #22
    3cf4:	91020000 	mrsls	r0, (UNDEF: 2)
    3cf8:	40300070 	eorsmi	r0, r0, r0, ror r0
    3cfc:	01000002 	tsteq	r0, r2
    3d00:	0a480f18 	beq	1207968 <_bss_end+0x11fbc6c>
    3d04:	9e5c0000 	cdpls	0, 5, cr0, cr12, cr0, {0}
    3d08:	00440000 	subeq	r0, r4, r0
    3d0c:	9c010000 	stcls	0, cr0, [r1], {-0}
    3d10:	00000a55 	andeq	r0, r0, r5, asr sl
    3d14:	0005822c 	andeq	r8, r5, ip, lsr #4
    3d18:	00027200 	andeq	r7, r2, r0, lsl #4
    3d1c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    3d20:	01c73100 	biceq	r3, r7, r0, lsl #2
    3d24:	12010000 	andne	r0, r1, #0
    3d28:	000a6601 	andeq	r6, sl, r1, lsl #12
    3d2c:	0a700000 	beq	1c03d34 <_bss_end+0x1bf8038>
    3d30:	82320000 	eorshi	r0, r2, #0
    3d34:	67000005 	strvs	r0, [r0, -r5]
    3d38:	00000002 	andeq	r0, r0, r2
    3d3c:	000a5533 	andeq	r5, sl, r3, lsr r5
    3d40:	00168c00 	andseq	r8, r6, r0, lsl #24
    3d44:	000a8700 	andeq	r8, sl, r0, lsl #14
    3d48:	009e1400 	addseq	r1, lr, r0, lsl #8
    3d4c:	00004800 	andeq	r4, r0, r0, lsl #16
    3d50:	349c0100 	ldrcc	r0, [ip], #256	; 0x100
    3d54:	00000a66 	andeq	r0, r0, r6, ror #20
    3d58:	00749102 	rsbseq	r9, r4, r2, lsl #2
    3d5c:	00002200 	andeq	r2, r0, r0, lsl #4
    3d60:	89000200 	stmdbhi	r0, {r9}
    3d64:	04000016 	streq	r0, [r0], #-22	; 0xffffffea
    3d68:	001a1b01 	andseq	r1, sl, r1, lsl #22
    3d6c:	00a3f800 	adceq	pc, r3, r0, lsl #16
    3d70:	00a45400 	adceq	r5, r4, r0, lsl #8
    3d74:	0017bd00 	andseq	fp, r7, r0, lsl #26
    3d78:	0000b600 	andeq	fp, r0, r0, lsl #12
    3d7c:	00181b00 	andseq	r1, r8, r0, lsl #22
    3d80:	1e800100 	rmfnes	f0, f0, f0
    3d84:	02000000 	andeq	r0, r0, #0
    3d88:	00169d00 	andseq	r9, r6, r0, lsl #26
    3d8c:	bc010400 	cfstrslt	mvf0, [r1], {-0}
    3d90:	5800001a 	stmdapl	r0, {r1, r3, r4}
    3d94:	27000000 	strcs	r0, [r0, -r0]
    3d98:	b6000018 			; <UNDEFINED> instruction: 0xb6000018
    3d9c:	1b000000 	blne	3da4 <CPSR_IRQ_INHIBIT+0x3d24>
    3da0:	01000018 	tsteq	r0, r8, lsl r0
    3da4:	00014b80 	andeq	r4, r1, r0, lsl #23
    3da8:	af000400 	svcge	0x00000400
    3dac:	04000016 	streq	r0, [r0], #-22	; 0xffffffea
    3db0:	00000001 	andeq	r0, r0, r1
    3db4:	18f10400 	ldmne	r1!, {sl}^
    3db8:	00b60000 	adcseq	r0, r6, r0
    3dbc:	a4a40000 	strtge	r0, [r4], #0
    3dc0:	01180000 	tsteq	r8, r0
    3dc4:	1b880000 	blne	fe203dcc <_bss_end+0xfe1f80d0>
    3dc8:	e8020000 	stmda	r2, {}	; <UNPREDICTABLE>
    3dcc:	01000018 	tsteq	r0, r8, lsl r0
    3dd0:	00310702 	eorseq	r0, r1, r2, lsl #14
    3dd4:	04030000 	streq	r0, [r3], #-0
    3dd8:	00000037 	andeq	r0, r0, r7, lsr r0
    3ddc:	18df0204 	ldmne	pc, {r2, r9}^	; <UNPREDICTABLE>
    3de0:	03010000 	movweq	r0, #4096	; 0x1000
    3de4:	00003107 	andeq	r3, r0, r7, lsl #2
    3de8:	18870500 	stmne	r7, {r8, sl}
    3dec:	06010000 	streq	r0, [r1], -r0
    3df0:	00005010 	andeq	r5, r0, r0, lsl r0
    3df4:	05040600 	streq	r0, [r4, #-1536]	; 0xfffffa00
    3df8:	00746e69 	rsbseq	r6, r4, r9, ror #28
    3dfc:	0018c805 	andseq	ip, r8, r5, lsl #16
    3e00:	10080100 	andne	r0, r8, r0, lsl #2
    3e04:	00000050 	andeq	r0, r0, r0, asr r0
    3e08:	00002507 	andeq	r2, r0, r7, lsl #10
    3e0c:	00007600 	andeq	r7, r0, r0, lsl #12
    3e10:	00760800 	rsbseq	r0, r6, r0, lsl #16
    3e14:	ffff0000 			; <UNDEFINED> instruction: 0xffff0000
    3e18:	0900ffff 	stmdbeq	r0, {r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, fp, ip, sp, lr, pc}
    3e1c:	1eef0704 	cdpne	7, 14, cr0, cr15, cr4, {0}
    3e20:	9f050000 	svcls	0x00050000
    3e24:	01000018 	tsteq	r0, r8, lsl r0
    3e28:	0063150b 	rsbeq	r1, r3, fp, lsl #10
    3e2c:	92050000 	andls	r0, r5, #0
    3e30:	01000018 	tsteq	r0, r8, lsl r0
    3e34:	0063150d 	rsbeq	r1, r3, sp, lsl #10
    3e38:	38070000 	stmdacc	r7, {}	; <UNPREDICTABLE>
    3e3c:	a8000000 	stmdage	r0, {}	; <UNPREDICTABLE>
    3e40:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    3e44:	00000076 	andeq	r0, r0, r6, ror r0
    3e48:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
    3e4c:	18d10500 	ldmne	r1, {r8, sl}^
    3e50:	10010000 	andne	r0, r1, r0
    3e54:	00009515 	andeq	r9, r0, r5, lsl r5
    3e58:	18ad0500 	stmiane	sp!, {r8, sl}
    3e5c:	12010000 	andne	r0, r1, #0
    3e60:	00009515 	andeq	r9, r0, r5, lsl r5
    3e64:	18ba0a00 	ldmne	sl!, {r9, fp}
    3e68:	2b010000 	blcs	43e70 <_bss_end+0x38174>
    3e6c:	00005010 	andeq	r5, r0, r0, lsl r0
    3e70:	00a56400 	adceq	r6, r5, r0, lsl #8
    3e74:	00005800 	andeq	r5, r0, r0, lsl #16
    3e78:	ea9c0100 	b	fe704280 <_bss_end+0xfe6f8584>
    3e7c:	0b000000 	bleq	3e84 <CPSR_IRQ_INHIBIT+0x3e04>
    3e80:	00001957 	andeq	r1, r0, r7, asr r9
    3e84:	ea0c2d01 	b	30f290 <_bss_end+0x303594>
    3e88:	02000000 	andeq	r0, r0, #0
    3e8c:	03007491 	movweq	r7, #1169	; 0x491
    3e90:	00003804 	andeq	r3, r0, r4, lsl #16
    3e94:	194a0a00 	stmdbne	sl, {r9, fp}^
    3e98:	1f010000 	svcne	0x00010000
    3e9c:	00005010 	andeq	r5, r0, r0, lsl r0
    3ea0:	00a50c00 	adceq	r0, r5, r0, lsl #24
    3ea4:	00005800 	andeq	r5, r0, r0, lsl #16
    3ea8:	1a9c0100 	bne	fe7042b0 <_bss_end+0xfe6f85b4>
    3eac:	0b000001 	bleq	3eb8 <CPSR_IRQ_INHIBIT+0x3e38>
    3eb0:	00001957 	andeq	r1, r0, r7, asr r9
    3eb4:	1a0c2101 	bne	30c2c0 <_bss_end+0x3005c4>
    3eb8:	02000001 	andeq	r0, r0, #1
    3ebc:	03007491 	movweq	r7, #1169	; 0x491
    3ec0:	00002504 	andeq	r2, r0, r4, lsl #10
    3ec4:	187c0c00 	ldmdane	ip!, {sl, fp}^
    3ec8:	14010000 	strne	r0, [r1], #-0
    3ecc:	00005010 	andeq	r5, r0, r0, lsl r0
    3ed0:	00a4a400 	adceq	sl, r4, r0, lsl #8
    3ed4:	00006800 	andeq	r6, r0, r0, lsl #16
    3ed8:	489c0100 	ldmmi	ip, {r8}
    3edc:	0d000001 	stceq	0, cr0, [r0, #-4]
    3ee0:	16010069 	strne	r0, [r1], -r9, rrx
    3ee4:	00014807 	andeq	r4, r1, r7, lsl #16
    3ee8:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    3eec:	50040300 	andpl	r0, r4, r0, lsl #6
    3ef0:	00000000 	andeq	r0, r0, r0
    3ef4:	0000010b 	andeq	r0, r0, fp, lsl #2
    3ef8:	17750004 	ldrbne	r0, [r5, -r4]!
    3efc:	01040000 	mrseq	r0, (UNDEF: 4)
    3f00:	00000000 	andeq	r0, r0, r0
    3f04:	00195d04 	andseq	r5, r9, r4, lsl #26
    3f08:	0000b600 	andeq	fp, r0, r0, lsl #12
    3f0c:	00a5bc00 	adceq	fp, r5, r0, lsl #24
    3f10:	00017400 	andeq	r7, r1, r0, lsl #8
    3f14:	001c7c00 	andseq	r7, ip, r0, lsl #24
    3f18:	00490200 	subeq	r0, r9, r0, lsl #4
    3f1c:	5f030000 	svcpl	0x00030000
    3f20:	01000008 	tsteq	r0, r8
    3f24:	00611005 	rsbeq	r1, r1, r5
    3f28:	30110000 	andscc	r0, r1, r0
    3f2c:	34333231 	ldrtcc	r3, [r3], #-561	; 0xfffffdcf
    3f30:	38373635 	ldmdacc	r7!, {r0, r2, r4, r5, r9, sl, ip, sp}
    3f34:	43424139 	movtmi	r4, #8505	; 0x2139
    3f38:	00464544 	subeq	r4, r6, r4, asr #10
    3f3c:	03010400 	movweq	r0, #5120	; 0x1400
    3f40:	00002501 	andeq	r2, r0, r1, lsl #10
    3f44:	00740500 	rsbseq	r0, r4, r0, lsl #10
    3f48:	00610000 	rsbeq	r0, r1, r0
    3f4c:	66060000 	strvs	r0, [r6], -r0
    3f50:	10000000 	andne	r0, r0, r0
    3f54:	00510700 	subseq	r0, r1, r0, lsl #14
    3f58:	04080000 	streq	r0, [r8], #-0
    3f5c:	001eef07 	andseq	lr, lr, r7, lsl #30
    3f60:	08010800 	stmdaeq	r1, {fp}
    3f64:	000004a0 	andeq	r0, r0, r0, lsr #9
    3f68:	00006d07 	andeq	r6, r0, r7, lsl #26
    3f6c:	002a0900 	eoreq	r0, sl, r0, lsl #18
    3f70:	2d0a0000 	stccs	0, cr0, [sl, #-0]
    3f74:	01000007 	tsteq	r0, r7
    3f78:	19b80608 	ldmibne	r8!, {r3, r9, sl}
    3f7c:	a5bc0000 	ldrge	r0, [ip, #0]!
    3f80:	01740000 	cmneq	r4, r0
    3f84:	9c010000 	stcls	0, cr0, [r1], {-0}
    3f88:	00000101 	andeq	r0, r0, r1, lsl #2
    3f8c:	0009070b 	andeq	r0, r9, fp, lsl #14
    3f90:	18080100 	stmdane	r8, {r8}
    3f94:	00000066 	andeq	r0, r0, r6, rrx
    3f98:	0b649102 	bleq	19283a8 <_bss_end+0x191c6ac>
    3f9c:	00000900 	andeq	r0, r0, r0, lsl #18
    3fa0:	01250801 			; <UNDEFINED> instruction: 0x01250801
    3fa4:	02000001 	andeq	r0, r0, #1
    3fa8:	970b6091 			; <UNDEFINED> instruction: 0x970b6091
    3fac:	0100000b 	tsteq	r0, fp
    3fb0:	00663a08 	rsbeq	r3, r6, r8, lsl #20
    3fb4:	91020000 	mrsls	r0, (UNDEF: 2)
    3fb8:	00690c5c 	rsbeq	r0, r9, ip, asr ip
    3fbc:	07060a01 	streq	r0, [r6, -r1, lsl #20]
    3fc0:	02000001 	andeq	r0, r0, #1
    3fc4:	880d7491 	stmdahi	sp, {r0, r4, r7, sl, ip, sp, lr}
    3fc8:	980000a6 	stmdals	r0, {r1, r2, r5, r7}
    3fcc:	0c000000 	stceq	0, cr0, [r0], {-0}
    3fd0:	1c01006a 	stcne	0, cr0, [r1], {106}	; 0x6a
    3fd4:	0001070b 	andeq	r0, r1, fp, lsl #14
    3fd8:	70910200 	addsvc	r0, r1, r0, lsl #4
    3fdc:	00a6b00d 	adceq	fp, r6, sp
    3fe0:	00006000 	andeq	r6, r0, r0
    3fe4:	00630c00 	rsbeq	r0, r3, r0, lsl #24
    3fe8:	6d081e01 	stcvs	14, cr1, [r8, #-4]
    3fec:	02000000 	andeq	r0, r0, #0
    3ff0:	00006f91 	muleq	r0, r1, pc	; <UNPREDICTABLE>
    3ff4:	6d040e00 	stcvs	14, cr0, [r4, #-0]
    3ff8:	0f000000 	svceq	0x00000000
    3ffc:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
    4000:	22000074 	andcs	r0, r0, #116	; 0x74
    4004:	02000000 	andeq	r0, r0, #0
    4008:	00183600 	andseq	r3, r8, r0, lsl #12
    400c:	b1010400 	tstlt	r1, r0, lsl #8
    4010:	3000001d 	andcc	r0, r0, sp, lsl r0
    4014:	3c0000a7 	stccc	0, cr0, [r0], {167}	; 0xa7
    4018:	c40000a9 	strgt	r0, [r0], #-169	; 0xffffff57
    401c:	f4000019 	vst4.8	{d0-d3}, [r0 :64], r9
    4020:	1b000019 	blne	408c <CPSR_IRQ_INHIBIT+0x400c>
    4024:	01000018 	tsteq	r0, r8, lsl r0
    4028:	00002280 	andeq	r2, r0, r0, lsl #5
    402c:	4a000200 	bmi	4834 <CPSR_IRQ_INHIBIT+0x47b4>
    4030:	04000018 	streq	r0, [r0], #-24	; 0xffffffe8
    4034:	001e2e01 	andseq	r2, lr, r1, lsl #28
    4038:	00a93c00 	adceq	r3, r9, r0, lsl #24
    403c:	00a94000 	adceq	r4, r9, r0
    4040:	0019c400 	andseq	ip, r9, r0, lsl #8
    4044:	0019f400 	andseq	pc, r9, r0, lsl #8
    4048:	00181b00 	andseq	r1, r8, r0, lsl #22
    404c:	32800100 	addcc	r0, r0, #0, 2
    4050:	04000009 	streq	r0, [r0], #-9
    4054:	00185e00 	andseq	r5, r8, r0, lsl #28
    4058:	c2010400 	andgt	r0, r1, #0, 8
    405c:	0c00001d 	stceq	0, cr0, [r0], {29}
    4060:	00001d19 	andeq	r1, r0, r9, lsl sp
    4064:	000019f4 	strdeq	r1, [r0], -r4
    4068:	00001e8e 	andeq	r1, r0, lr, lsl #29
    406c:	69050402 	stmdbvs	r5, {r1, sl}
    4070:	0300746e 	movweq	r7, #1134	; 0x46e
    4074:	1eef0704 	cdpne	7, 14, cr0, cr15, cr4, {0}
    4078:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    407c:	0001e405 	andeq	lr, r1, r5, lsl #8
    4080:	04080300 	streq	r0, [r8], #-768	; 0xfffffd00
    4084:	000025c1 	andeq	r2, r0, r1, asr #11
    4088:	001d7404 	andseq	r7, sp, r4, lsl #8
    408c:	162a0100 	strtne	r0, [sl], -r0, lsl #2
    4090:	00000024 	andeq	r0, r0, r4, lsr #32
    4094:	0021e304 	eoreq	lr, r1, r4, lsl #6
    4098:	152f0100 	strne	r0, [pc, #-256]!	; 3fa0 <CPSR_IRQ_INHIBIT+0x3f20>
    409c:	00000051 	andeq	r0, r0, r1, asr r0
    40a0:	00570405 	subseq	r0, r7, r5, lsl #8
    40a4:	39060000 	stmdbcc	r6, {}	; <UNPREDICTABLE>
    40a8:	66000000 	strvs	r0, [r0], -r0
    40ac:	07000000 	streq	r0, [r0, -r0]
    40b0:	00000066 	andeq	r0, r0, r6, rrx
    40b4:	6c040500 	cfstr32vs	mvfx0, [r4], {-0}
    40b8:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    40bc:	00291504 	eoreq	r1, r9, r4, lsl #10
    40c0:	0f360100 	svceq	0x00360100
    40c4:	00000079 	andeq	r0, r0, r9, ror r0
    40c8:	007f0405 	rsbseq	r0, pc, r5, lsl #8
    40cc:	1d060000 	stcne	0, cr0, [r6, #-0]
    40d0:	93000000 	movwls	r0, #0
    40d4:	07000000 	streq	r0, [r0, -r0]
    40d8:	00000066 	andeq	r0, r0, r6, rrx
    40dc:	00006607 	andeq	r6, r0, r7, lsl #12
    40e0:	01030000 	mrseq	r0, (UNDEF: 3)
    40e4:	00049708 	andeq	r9, r4, r8, lsl #14
    40e8:	241b0900 	ldrcs	r0, [fp], #-2304	; 0xfffff700
    40ec:	bb010000 	bllt	440f4 <_bss_end+0x383f8>
    40f0:	00004512 	andeq	r4, r0, r2, lsl r5
    40f4:	29430900 	stmdbcs	r3, {r8, fp}^
    40f8:	be010000 	cdplt	0, 0, cr0, cr1, cr0, {0}
    40fc:	00006d10 	andeq	r6, r0, r0, lsl sp
    4100:	06010300 	streq	r0, [r1], -r0, lsl #6
    4104:	00000499 	muleq	r0, r9, r4
    4108:	0021030a 	eoreq	r0, r1, sl, lsl #6
    410c:	93010700 	movwls	r0, #5888	; 0x1700
    4110:	02000000 	andeq	r0, r0, #0
    4114:	01e60617 	mvneq	r0, r7, lsl r6
    4118:	d20b0000 	andle	r0, fp, #0
    411c:	0000001b 	andeq	r0, r0, fp, lsl r0
    4120:	0020200b 	eoreq	r2, r0, fp
    4124:	e60b0100 	str	r0, [fp], -r0, lsl #2
    4128:	02000024 	andeq	r0, r0, #36	; 0x24
    412c:	0028570b 	eoreq	r5, r8, fp, lsl #14
    4130:	8a0b0300 	bhi	2c4d38 <_bss_end+0x2b903c>
    4134:	04000024 	streq	r0, [r0], #-36	; 0xffffffdc
    4138:	0027600b 	eoreq	r6, r7, fp
    413c:	c40b0500 	strgt	r0, [fp], #-1280	; 0xfffffb00
    4140:	06000026 	streq	r0, [r0], -r6, lsr #32
    4144:	001bf30b 	andseq	pc, fp, fp, lsl #6
    4148:	750b0700 	strvc	r0, [fp, #-1792]	; 0xfffff900
    414c:	08000027 	stmdaeq	r0, {r0, r1, r2, r5}
    4150:	0027830b 	eoreq	r8, r7, fp, lsl #6
    4154:	4a0b0900 	bmi	2c655c <_bss_end+0x2ba860>
    4158:	0a000028 	beq	4200 <CPSR_IRQ_INHIBIT+0x4180>
    415c:	0023e10b 	eoreq	lr, r3, fp, lsl #2
    4160:	b50b0b00 	strlt	r0, [fp, #-2816]	; 0xfffff500
    4164:	0c00001d 	stceq	0, cr0, [r0], {29}
    4168:	001e920b 	andseq	r9, lr, fp, lsl #4
    416c:	470b0d00 	strmi	r0, [fp, -r0, lsl #26]
    4170:	0e000021 	cdpeq	0, 0, cr0, cr0, cr1, {1}
    4174:	00215d0b 	eoreq	r5, r1, fp, lsl #26
    4178:	5a0b0f00 	bpl	2c7d80 <_bss_end+0x2bc084>
    417c:	10000020 	andne	r0, r0, r0, lsr #32
    4180:	00246e0b 	eoreq	r6, r4, fp, lsl #28
    4184:	c60b1100 	strgt	r1, [fp], -r0, lsl #2
    4188:	12000020 	andne	r0, r0, #32
    418c:	002adc0b 	eoreq	sp, sl, fp, lsl #24
    4190:	5c0b1300 	stcpl	3, cr1, [fp], {-0}
    4194:	1400001c 	strne	r0, [r0], #-28	; 0xffffffe4
    4198:	0020ea0b 	eoreq	lr, r0, fp, lsl #20
    419c:	990b1500 	stmdbls	fp, {r8, sl, ip}
    41a0:	1600001b 			; <UNDEFINED> instruction: 0x1600001b
    41a4:	00287a0b 	eoreq	r7, r8, fp, lsl #20
    41a8:	9c0b1700 	stcls	7, cr1, [fp], {-0}
    41ac:	18000029 	stmdane	r0, {r0, r3, r5}
    41b0:	00210f0b 	eoreq	r0, r1, fp, lsl #30
    41b4:	580b1900 	stmdapl	fp, {r8, fp, ip}
    41b8:	1a000025 	bne	4254 <CPSR_IRQ_INHIBIT+0x41d4>
    41bc:	0028880b 	eoreq	r8, r8, fp, lsl #16
    41c0:	c80b1b00 	stmdagt	fp, {r8, r9, fp, ip}
    41c4:	1c00001a 	stcne	0, cr0, [r0], {26}
    41c8:	0028960b 	eoreq	r9, r8, fp, lsl #12
    41cc:	a40b1d00 	strge	r1, [fp], #-3328	; 0xfffff300
    41d0:	1e000028 	cdpne	0, 0, cr0, cr0, cr8, {1}
    41d4:	001a760b 	andseq	r7, sl, fp, lsl #12
    41d8:	ce0b1f00 	cdpgt	15, 0, cr1, cr11, cr0, {0}
    41dc:	20000028 	andcs	r0, r0, r8, lsr #32
    41e0:	0026050b 	eoreq	r0, r6, fp, lsl #10
    41e4:	400b2100 	andmi	r2, fp, r0, lsl #2
    41e8:	22000024 	andcs	r0, r0, #36	; 0x24
    41ec:	00286d0b 	eoreq	r6, r8, fp, lsl #26
    41f0:	440b2300 	strmi	r2, [fp], #-768	; 0xfffffd00
    41f4:	24000023 	strcs	r0, [r0], #-35	; 0xffffffdd
    41f8:	0022460b 	eoreq	r4, r2, fp, lsl #12
    41fc:	600b2500 	andvs	r2, fp, r0, lsl #10
    4200:	2600001f 			; <UNDEFINED> instruction: 0x2600001f
    4204:	0022640b 	eoreq	r6, r2, fp, lsl #8
    4208:	fc0b2700 	stc2	7, cr2, [fp], {-0}
    420c:	2800001f 	stmdacs	r0, {r0, r1, r2, r3, r4}
    4210:	0022740b 	eoreq	r7, r2, fp, lsl #8
    4214:	840b2900 	strhi	r2, [fp], #-2304	; 0xfffff700
    4218:	2a000022 	bcs	42a8 <CPSR_IRQ_INHIBIT+0x4228>
    421c:	0023c70b 	eoreq	ip, r3, fp, lsl #14
    4220:	ed0b2b00 	vstr	d2, [fp, #-0]
    4224:	2c000021 	stccs	0, cr0, [r0], {33}	; 0x21
    4228:	0026120b 	eoreq	r1, r6, fp, lsl #4
    422c:	a10b2d00 	tstge	fp, r0, lsl #26
    4230:	2e00001f 	mcrcs	0, 0, r0, cr0, cr15, {0}
    4234:	217f0a00 	cmncs	pc, r0, lsl #20
    4238:	01070000 	mrseq	r0, (UNDEF: 7)
    423c:	00000093 	muleq	r0, r3, r0
    4240:	c7061703 	strgt	r1, [r6, -r3, lsl #14]
    4244:	0b000003 	bleq	4258 <CPSR_IRQ_INHIBIT+0x41d8>
    4248:	00001eb4 			; <UNDEFINED> instruction: 0x00001eb4
    424c:	1b060b00 	blne	186e54 <_bss_end+0x17b158>
    4250:	0b010000 	bleq	44258 <_bss_end+0x3855c>
    4254:	00002a8a 	andeq	r2, r0, sl, lsl #21
    4258:	291d0b02 	ldmdbcs	sp, {r1, r8, r9, fp}
    425c:	0b030000 	bleq	c4264 <_bss_end+0xb8568>
    4260:	00001ed4 	ldrdeq	r1, [r0], -r4
    4264:	1bbe0b04 	blne	fef86e7c <_bss_end+0xfef7b180>
    4268:	0b050000 	bleq	144270 <_bss_end+0x138574>
    426c:	00001f7d 	andeq	r1, r0, sp, ror pc
    4270:	1ec40b06 	vdivne.f64	d16, d4, d6
    4274:	0b070000 	bleq	1c427c <_bss_end+0x1b8580>
    4278:	000027b1 			; <UNDEFINED> instruction: 0x000027b1
    427c:	29020b08 	stmdbcs	r2, {r3, r8, r9, fp}
    4280:	0b090000 	bleq	244288 <_bss_end+0x23858c>
    4284:	000026e8 	andeq	r2, r0, r8, ror #13
    4288:	1c110b0a 			; <UNDEFINED> instruction: 0x1c110b0a
    428c:	0b0b0000 	bleq	2c4294 <_bss_end+0x2b8598>
    4290:	00001f1e 	andeq	r1, r0, lr, lsl pc
    4294:	1b870b0c 	blne	fe1c6ecc <_bss_end+0xfe1bb1d0>
    4298:	0b0d0000 	bleq	3442a0 <_bss_end+0x3385a4>
    429c:	00002abf 			; <UNDEFINED> instruction: 0x00002abf
    42a0:	23b40b0e 			; <UNDEFINED> instruction: 0x23b40b0e
    42a4:	0b0f0000 	bleq	3c42ac <_bss_end+0x3b85b0>
    42a8:	00002091 	muleq	r0, r1, r0
    42ac:	23f10b10 	mvnscs	r0, #16, 22	; 0x4000
    42b0:	0b110000 	bleq	4442b8 <_bss_end+0x4385bc>
    42b4:	000029de 	ldrdeq	r2, [r0], -lr
    42b8:	1cd40b12 	vldmiane	r4, {d16-d24}
    42bc:	0b130000 	bleq	4c42c4 <_bss_end+0x4b85c8>
    42c0:	000020a4 	andeq	r2, r0, r4, lsr #1
    42c4:	23070b14 	movwcs	r0, #31508	; 0x7b14
    42c8:	0b150000 	bleq	5442d0 <_bss_end+0x5385d4>
    42cc:	00001e9f 	muleq	r0, pc, lr	; <UNPREDICTABLE>
    42d0:	23530b16 	cmpcs	r3, #22528	; 0x5800
    42d4:	0b170000 	bleq	5c42dc <_bss_end+0x5b85e0>
    42d8:	00002169 	andeq	r2, r0, r9, ror #2
    42dc:	1bdc0b18 	blne	ff706f44 <_bss_end+0xff6fb248>
    42e0:	0b190000 	bleq	6442e8 <_bss_end+0x6385ec>
    42e4:	00002985 	andeq	r2, r0, r5, lsl #19
    42e8:	22d30b1a 	sbcscs	r0, r3, #26624	; 0x6800
    42ec:	0b1b0000 	bleq	6c42f4 <_bss_end+0x6b85f8>
    42f0:	0000207b 	andeq	r2, r0, fp, ror r0
    42f4:	1ab10b1c 	bne	fec46f6c <_bss_end+0xfec3b270>
    42f8:	0b1d0000 	bleq	744300 <_bss_end+0x738604>
    42fc:	0000221e 	andeq	r2, r0, lr, lsl r2
    4300:	220a0b1e 	andcs	r0, sl, #30720	; 0x7800
    4304:	0b1f0000 	bleq	7c430c <_bss_end+0x7b8610>
    4308:	000026a5 	andeq	r2, r0, r5, lsr #13
    430c:	27300b20 	ldrcs	r0, [r0, -r0, lsr #22]!
    4310:	0b210000 	bleq	844318 <_bss_end+0x83861c>
    4314:	00002964 	andeq	r2, r0, r4, ror #18
    4318:	1fae0b22 	svcne	0x00ae0b22
    431c:	0b230000 	bleq	8c4324 <_bss_end+0x8b8628>
    4320:	00002508 	andeq	r2, r0, r8, lsl #10
    4324:	26fd0b24 	ldrbtcs	r0, [sp], r4, lsr #22
    4328:	0b250000 	bleq	944330 <_bss_end+0x938634>
    432c:	00002621 	andeq	r2, r0, r1, lsr #12
    4330:	26350b26 	ldrtcs	r0, [r5], -r6, lsr #22
    4334:	0b270000 	bleq	9c433c <_bss_end+0x9b8640>
    4338:	00002649 	andeq	r2, r0, r9, asr #12
    433c:	1d5f0b28 	vldrne	d16, [pc, #-160]	; 42a4 <CPSR_IRQ_INHIBIT+0x4224>
    4340:	0b290000 	bleq	a44348 <_bss_end+0xa3864c>
    4344:	00001cbf 			; <UNDEFINED> instruction: 0x00001cbf
    4348:	1ce70b2a 	vstmiane	r7!, {d16-<overflow reg d36>}
    434c:	0b2b0000 	bleq	ac4354 <_bss_end+0xab8658>
    4350:	000027fa 	strdeq	r2, [r0], -sl
    4354:	1d3c0b2c 	vldmdbne	ip!, {d0-d21}
    4358:	0b2d0000 	bleq	b44360 <_bss_end+0xb38664>
    435c:	0000280e 	andeq	r2, r0, lr, lsl #16
    4360:	28220b2e 	stmdacs	r2!, {r1, r2, r3, r5, r8, r9, fp}
    4364:	0b2f0000 	bleq	bc436c <_bss_end+0xbb8670>
    4368:	00002836 	andeq	r2, r0, r6, lsr r8
    436c:	1f300b30 	svcne	0x00300b30
    4370:	0b310000 	bleq	c44378 <_bss_end+0xc3867c>
    4374:	00001f0a 	andeq	r1, r0, sl, lsl #30
    4378:	22320b32 	eorscs	r0, r2, #51200	; 0xc800
    437c:	0b330000 	bleq	cc4384 <_bss_end+0xcb8688>
    4380:	00002404 	andeq	r2, r0, r4, lsl #8
    4384:	2a130b34 	bcs	4c705c <_bss_end+0x4bb360>
    4388:	0b350000 	bleq	d44390 <_bss_end+0xd38694>
    438c:	00001a59 	andeq	r1, r0, r9, asr sl
    4390:	20300b36 	eorscs	r0, r0, r6, lsr fp
    4394:	0b370000 	bleq	dc439c <_bss_end+0xdb86a0>
    4398:	00002045 	andeq	r2, r0, r5, asr #32
    439c:	22940b38 	addscs	r0, r4, #56, 22	; 0xe000
    43a0:	0b390000 	bleq	e443a8 <_bss_end+0xe386ac>
    43a4:	000022be 			; <UNDEFINED> instruction: 0x000022be
    43a8:	2a3c0b3a 	bcs	f07098 <_bss_end+0xefb39c>
    43ac:	0b3b0000 	bleq	ec43b4 <_bss_end+0xeb86b8>
    43b0:	000024f3 	strdeq	r2, [r0], -r3
    43b4:	1fd30b3c 	svcne	0x00d30b3c
    43b8:	0b3d0000 	bleq	f443c0 <_bss_end+0xf386c4>
    43bc:	00001b18 	andeq	r1, r0, r8, lsl fp
    43c0:	1ad60b3e 	bne	ff5870c0 <_bss_end+0xff57b3c4>
    43c4:	0b3f0000 	bleq	fc43cc <_bss_end+0xfb86d0>
    43c8:	00002450 	andeq	r2, r0, r0, asr r4
    43cc:	25740b40 	ldrbcs	r0, [r4, #-2880]!	; 0xfffff4c0
    43d0:	0b410000 	bleq	10443d8 <_bss_end+0x10386dc>
    43d4:	00002687 	andeq	r2, r0, r7, lsl #13
    43d8:	22a90b42 	adccs	r0, r9, #67584	; 0x10800
    43dc:	0b430000 	bleq	10c43e4 <_bss_end+0x10b86e8>
    43e0:	00002a75 	andeq	r2, r0, r5, ror sl
    43e4:	251e0b44 	ldrcs	r0, [lr, #-2884]	; 0xfffff4bc
    43e8:	0b450000 	bleq	11443f0 <_bss_end+0x11386f4>
    43ec:	00001d03 	andeq	r1, r0, r3, lsl #26
    43f0:	23840b46 	orrcs	r0, r4, #71680	; 0x11800
    43f4:	0b470000 	bleq	11c43fc <_bss_end+0x11b8700>
    43f8:	000021b7 			; <UNDEFINED> instruction: 0x000021b7
    43fc:	1a950b48 	bne	fe547124 <_bss_end+0xfe53b428>
    4400:	0b490000 	bleq	1244408 <_bss_end+0x123870c>
    4404:	00001ba9 	andeq	r1, r0, r9, lsr #23
    4408:	1fe70b4a 	svcne	0x00e70b4a
    440c:	0b4b0000 	bleq	12c4414 <_bss_end+0x12b8718>
    4410:	000022e5 	andeq	r2, r0, r5, ror #5
    4414:	0203004c 	andeq	r0, r3, #76	; 0x4c
    4418:	00050207 	andeq	r0, r5, r7, lsl #4
    441c:	03e40c00 	mvneq	r0, #0, 24
    4420:	03d90000 	bicseq	r0, r9, #0
    4424:	000d0000 	andeq	r0, sp, r0
    4428:	0003ce0e 	andeq	ip, r3, lr, lsl #28
    442c:	f0040500 			; <UNDEFINED> instruction: 0xf0040500
    4430:	0e000003 	cdpeq	0, 0, cr0, cr0, cr3, {0}
    4434:	000003de 	ldrdeq	r0, [r0], -lr
    4438:	a0080103 	andge	r0, r8, r3, lsl #2
    443c:	0e000004 	cdpeq	0, 0, cr0, cr0, cr4, {0}
    4440:	000003e9 	andeq	r0, r0, r9, ror #7
    4444:	001c4d0f 	andseq	r4, ip, pc, lsl #26
    4448:	014c0400 	cmpeq	ip, r0, lsl #8
    444c:	0003d91a 	andeq	sp, r3, sl, lsl r9
    4450:	206b0f00 	rsbcs	r0, fp, r0, lsl #30
    4454:	82040000 	andhi	r0, r4, #0
    4458:	03d91a01 	bicseq	r1, r9, #4096	; 0x1000
    445c:	e90c0000 	stmdb	ip, {}	; <UNPREDICTABLE>
    4460:	1a000003 	bne	4474 <CPSR_IRQ_INHIBIT+0x43f4>
    4464:	0d000004 	stceq	0, cr0, [r0, #-16]
    4468:	22560900 	subscs	r0, r6, #0, 18
    446c:	2d050000 	stccs	0, cr0, [r5, #-0]
    4470:	00040f0d 	andeq	r0, r4, sp, lsl #30
    4474:	28de0900 	ldmcs	lr, {r8, fp}^
    4478:	38050000 	stmdacc	r5, {}	; <UNPREDICTABLE>
    447c:	0001e61c 	andeq	lr, r1, ip, lsl r6
    4480:	1f440a00 	svcne	0x00440a00
    4484:	01070000 	mrseq	r0, (UNDEF: 7)
    4488:	00000093 	muleq	r0, r3, r0
    448c:	a50e3a05 	strge	r3, [lr, #-2565]	; 0xfffff5fb
    4490:	0b000004 	bleq	44a8 <CPSR_IRQ_INHIBIT+0x4428>
    4494:	00001aaa 	andeq	r1, r0, sl, lsr #21
    4498:	21560b00 	cmpcs	r6, r0, lsl #22
    449c:	0b010000 	bleq	444a4 <_bss_end+0x387a8>
    44a0:	000029f0 	strdeq	r2, [r0], -r0
    44a4:	29b30b02 	ldmibcs	r3!, {r1, r8, r9, fp}
    44a8:	0b030000 	bleq	c44b0 <_bss_end+0xb87b4>
    44ac:	000024ad 	andeq	r2, r0, sp, lsr #9
    44b0:	276e0b04 	strbcs	r0, [lr, -r4, lsl #22]!
    44b4:	0b050000 	bleq	1444bc <_bss_end+0x1387c0>
    44b8:	00001c90 	muleq	r0, r0, ip
    44bc:	1c720b06 			; <UNDEFINED> instruction: 0x1c720b06
    44c0:	0b070000 	bleq	1c44c8 <_bss_end+0x1b87cc>
    44c4:	00001e8b 	andeq	r1, r0, fp, lsl #29
    44c8:	23690b08 	cmncs	r9, #8, 22	; 0x2000
    44cc:	0b090000 	bleq	2444d4 <_bss_end+0x2387d8>
    44d0:	00001c97 	muleq	r0, r7, ip
    44d4:	23700b0a 	cmncs	r0, #10240	; 0x2800
    44d8:	0b0b0000 	bleq	2c44e0 <_bss_end+0x2b87e4>
    44dc:	00001cfc 	strdeq	r1, [r0], -ip
    44e0:	1c890b0c 	vstmiane	r9, {d0-d5}
    44e4:	0b0d0000 	bleq	3444ec <_bss_end+0x3387f0>
    44e8:	000027c5 	andeq	r2, r0, r5, asr #15
    44ec:	25920b0e 	ldrcs	r0, [r2, #2830]	; 0xb0e
    44f0:	000f0000 	andeq	r0, pc, r0
    44f4:	0026bd04 	eoreq	fp, r6, r4, lsl #26
    44f8:	013f0500 	teqeq	pc, r0, lsl #10
    44fc:	00000432 	andeq	r0, r0, r2, lsr r4
    4500:	00275109 	eoreq	r5, r7, r9, lsl #2
    4504:	0f410500 	svceq	0x00410500
    4508:	000004a5 	andeq	r0, r0, r5, lsr #9
    450c:	0027d909 	eoreq	sp, r7, r9, lsl #18
    4510:	0c4a0500 	cfstr64eq	mvdx0, [sl], {-0}
    4514:	0000001d 	andeq	r0, r0, sp, lsl r0
    4518:	001c3109 	andseq	r3, ip, r9, lsl #2
    451c:	0c4b0500 	cfstr64eq	mvdx0, [fp], {-0}
    4520:	0000001d 	andeq	r0, r0, sp, lsl r0
    4524:	0028b210 	eoreq	fp, r8, r0, lsl r2
    4528:	27ea0900 	strbcs	r0, [sl, r0, lsl #18]!
    452c:	4c050000 	stcmi	0, cr0, [r5], {-0}
    4530:	0004e614 	andeq	lr, r4, r4, lsl r6
    4534:	d5040500 	strle	r0, [r4, #-1280]	; 0xfffffb00
    4538:	11000004 	tstne	r0, r4
    453c:	00212009 	eoreq	r2, r1, r9
    4540:	0f4e0500 	svceq	0x004e0500
    4544:	000004f9 	strdeq	r0, [r0], -r9
    4548:	04ec0405 	strbteq	r0, [ip], #1029	; 0x405
    454c:	d3120000 	tstle	r2, #0
    4550:	09000026 	stmdbeq	r0, {r1, r2, r5}
    4554:	0000249a 	muleq	r0, sl, r4
    4558:	100d5205 	andne	r5, sp, r5, lsl #4
    455c:	05000005 	streq	r0, [r0, #-5]
    4560:	0004ff04 	andeq	pc, r4, r4, lsl #30
    4564:	1da81300 	stcne	3, cr1, [r8]
    4568:	05340000 	ldreq	r0, [r4, #-0]!
    456c:	41150167 	tstmi	r5, r7, ror #2
    4570:	14000005 	strne	r0, [r0], #-5
    4574:	0000225f 	andeq	r2, r0, pc, asr r2
    4578:	0f016905 	svceq	0x00016905
    457c:	000003de 	ldrdeq	r0, [r0], -lr
    4580:	1d8c1400 	cfstrsne	mvf1, [ip]
    4584:	6a050000 	bvs	14458c <_bss_end+0x138890>
    4588:	05461401 	strbeq	r1, [r6, #-1025]	; 0xfffffbff
    458c:	00040000 	andeq	r0, r4, r0
    4590:	0005160e 	andeq	r1, r5, lr, lsl #12
    4594:	00b90c00 	adcseq	r0, r9, r0, lsl #24
    4598:	05560000 	ldrbeq	r0, [r6, #-0]
    459c:	24150000 	ldrcs	r0, [r5], #-0
    45a0:	2d000000 	stccs	0, cr0, [r0, #-0]
    45a4:	05410c00 	strbeq	r0, [r1, #-3072]	; 0xfffff400
    45a8:	05610000 	strbeq	r0, [r1, #-0]!
    45ac:	000d0000 	andeq	r0, sp, r0
    45b0:	0005560e 	andeq	r5, r5, lr, lsl #12
    45b4:	218e0f00 	orrcs	r0, lr, r0, lsl #30
    45b8:	6b050000 	blvs	1445c0 <_bss_end+0x1388c4>
    45bc:	05610301 	strbeq	r0, [r1, #-769]!	; 0xfffffcff
    45c0:	d40f0000 	strle	r0, [pc], #-0	; 45c8 <CPSR_IRQ_INHIBIT+0x4548>
    45c4:	05000023 	streq	r0, [r0, #-35]	; 0xffffffdd
    45c8:	1d0c016e 	stfnes	f0, [ip, #-440]	; 0xfffffe48
    45cc:	16000000 	strne	r0, [r0], -r0
    45d0:	00002711 	andeq	r2, r0, r1, lsl r7
    45d4:	00930107 	addseq	r0, r3, r7, lsl #2
    45d8:	81050000 	mrshi	r0, (UNDEF: 5)
    45dc:	062a0601 	strteq	r0, [sl], -r1, lsl #12
    45e0:	3f0b0000 	svccc	0x000b0000
    45e4:	0000001b 	andeq	r0, r0, fp, lsl r0
    45e8:	001b4b0b 	andseq	r4, fp, fp, lsl #22
    45ec:	570b0200 	strpl	r0, [fp, -r0, lsl #4]
    45f0:	0300001b 	movweq	r0, #27
    45f4:	001f700b 	andseq	r7, pc, fp
    45f8:	630b0300 	movwvs	r0, #45824	; 0xb300
    45fc:	0400001b 	streq	r0, [r0], #-27	; 0xffffffe5
    4600:	0020b90b 	eoreq	fp, r0, fp, lsl #18
    4604:	9f0b0400 	svcls	0x000b0400
    4608:	05000021 	streq	r0, [r0, #-33]	; 0xffffffdf
    460c:	0020f50b 	eoreq	pc, r0, fp, lsl #10
    4610:	220b0500 	andcs	r0, fp, #0, 10
    4614:	0500001c 	streq	r0, [r0, #-28]	; 0xffffffe4
    4618:	001b6f0b 	andseq	r6, fp, fp, lsl #30
    461c:	1d0b0600 	stcne	6, cr0, [fp, #-0]
    4620:	06000023 	streq	r0, [r0], -r3, lsr #32
    4624:	001d7e0b 	andseq	r7, sp, fp, lsl #28
    4628:	2a0b0600 	bcs	2c5e30 <_bss_end+0x2ba134>
    462c:	06000023 	streq	r0, [r0], -r3, lsr #32
    4630:	0027910b 	eoreq	r9, r7, fp, lsl #2
    4634:	370b0600 	strcc	r0, [fp, -r0, lsl #12]
    4638:	06000023 	streq	r0, [r0], -r3, lsr #32
    463c:	0023770b 	eoreq	r7, r3, fp, lsl #14
    4640:	7b0b0600 	blvc	2c5e48 <_bss_end+0x2ba14c>
    4644:	0700001b 	smladeq	r0, fp, r0, r0
    4648:	00247d0b 	eoreq	r7, r4, fp, lsl #26
    464c:	ca0b0700 	bgt	2c6254 <_bss_end+0x2ba558>
    4650:	07000024 	streq	r0, [r0, -r4, lsr #32]
    4654:	0027cc0b 	eoreq	ip, r7, fp, lsl #24
    4658:	510b0700 	tstpl	fp, r0, lsl #14
    465c:	0700001d 	smladeq	r0, sp, r0, r0
    4660:	00254b0b 	eoreq	r4, r5, fp, lsl #22
    4664:	f40b0800 	vst2.8	{d0-d1}, [fp], r0
    4668:	0800001a 	stmdaeq	r0, {r1, r3, r4}
    466c:	00279f0b 	eoreq	r9, r7, fp, lsl #30
    4670:	670b0800 	strvs	r0, [fp, -r0, lsl #16]
    4674:	08000025 	stmdaeq	r0, {r0, r2, r5}
    4678:	2a050f00 	bcs	148280 <_bss_end+0x13c584>
    467c:	9f050000 	svcls	0x00050000
    4680:	05801f01 	streq	r1, [r0, #3841]	; 0xf01
    4684:	990f0000 	stmdbls	pc, {}	; <UNPREDICTABLE>
    4688:	05000025 	streq	r0, [r0, #-37]	; 0xffffffdb
    468c:	1d0c01a2 	stfnes	f0, [ip, #-648]	; 0xfffffd78
    4690:	0f000000 	svceq	0x00000000
    4694:	000021ac 	andeq	r2, r0, ip, lsr #3
    4698:	0c01a505 	cfstr32eq	mvfx10, [r1], {5}
    469c:	0000001d 	andeq	r0, r0, sp, lsl r0
    46a0:	002ad10f 	eoreq	sp, sl, pc, lsl #2
    46a4:	01a80500 			; <UNDEFINED> instruction: 0x01a80500
    46a8:	00001d0c 	andeq	r1, r0, ip, lsl #26
    46ac:	1c410f00 	mcrrne	15, 0, r0, r1, cr0
    46b0:	ab050000 	blge	1446b8 <_bss_end+0x1389bc>
    46b4:	001d0c01 	andseq	r0, sp, r1, lsl #24
    46b8:	a30f0000 	movwge	r0, #61440	; 0xf000
    46bc:	05000025 	streq	r0, [r0, #-37]	; 0xffffffdb
    46c0:	1d0c01ae 	stfnes	f0, [ip, #-696]	; 0xfffffd48
    46c4:	0f000000 	svceq	0x00000000
    46c8:	000024b4 			; <UNDEFINED> instruction: 0x000024b4
    46cc:	0c01b105 	stfeqd	f3, [r1], {5}
    46d0:	0000001d 	andeq	r0, r0, sp, lsl r0
    46d4:	0024bf0f 	eoreq	fp, r4, pc, lsl #30
    46d8:	01b40500 			; <UNDEFINED> instruction: 0x01b40500
    46dc:	00001d0c 	andeq	r1, r0, ip, lsl #26
    46e0:	25ad0f00 	strcs	r0, [sp, #3840]!	; 0xf00
    46e4:	b7050000 	strlt	r0, [r5, -r0]
    46e8:	001d0c01 	andseq	r0, sp, r1, lsl #24
    46ec:	f90f0000 			; <UNDEFINED> instruction: 0xf90f0000
    46f0:	05000022 	streq	r0, [r0, #-34]	; 0xffffffde
    46f4:	1d0c01ba 	stfnes	f0, [ip, #-744]	; 0xfffffd18
    46f8:	0f000000 	svceq	0x00000000
    46fc:	00002a30 	andeq	r2, r0, r0, lsr sl
    4700:	0c01bd05 	stceq	13, cr11, [r1], {5}
    4704:	0000001d 	andeq	r0, r0, sp, lsl r0
    4708:	0025b70f 	eoreq	fp, r5, pc, lsl #14
    470c:	01c00500 	biceq	r0, r0, r0, lsl #10
    4710:	00001d0c 	andeq	r1, r0, ip, lsl #26
    4714:	2af40f00 	bcs	ffd0831c <_bss_end+0xffcfc620>
    4718:	c3050000 	movwgt	r0, #20480	; 0x5000
    471c:	001d0c01 	andseq	r0, sp, r1, lsl #24
    4720:	ba0f0000 	blt	3c4728 <_bss_end+0x3b8a2c>
    4724:	05000029 	streq	r0, [r0, #-41]	; 0xffffffd7
    4728:	1d0c01c6 	stfnes	f0, [ip, #-792]	; 0xfffffce8
    472c:	0f000000 	svceq	0x00000000
    4730:	000029c6 	andeq	r2, r0, r6, asr #19
    4734:	0c01c905 			; <UNDEFINED> instruction: 0x0c01c905
    4738:	0000001d 	andeq	r0, r0, sp, lsl r0
    473c:	0029d20f 	eoreq	sp, r9, pc, lsl #4
    4740:	01cc0500 	biceq	r0, ip, r0, lsl #10
    4744:	00001d0c 	andeq	r1, r0, ip, lsl #26
    4748:	29f70f00 	ldmibcs	r7!, {r8, r9, sl, fp}^
    474c:	d0050000 	andle	r0, r5, r0
    4750:	001d0c01 	andseq	r0, sp, r1, lsl #24
    4754:	e70f0000 	str	r0, [pc, -r0]
    4758:	0500002a 	streq	r0, [r0, #-42]	; 0xffffffd6
    475c:	1d0c01d3 	stfnes	f0, [ip, #-844]	; 0xfffffcb4
    4760:	0f000000 	svceq	0x00000000
    4764:	00001c9e 	muleq	r0, lr, ip
    4768:	0c01d605 	stceq	6, cr13, [r1], {5}
    476c:	0000001d 	andeq	r0, r0, sp, lsl r0
    4770:	001a850f 	andseq	r8, sl, pc, lsl #10
    4774:	01d90500 	bicseq	r0, r9, r0, lsl #10
    4778:	00001d0c 	andeq	r1, r0, ip, lsl #26
    477c:	1f900f00 	svcne	0x00900f00
    4780:	dc050000 	stcle	0, cr0, [r5], {-0}
    4784:	001d0c01 	andseq	r0, sp, r1, lsl #24
    4788:	790f0000 	stmdbvc	pc, {}	; <UNPREDICTABLE>
    478c:	0500001c 	streq	r0, [r0, #-28]	; 0xffffffe4
    4790:	1d0c01df 	stfnes	f0, [ip, #-892]	; 0xfffffc84
    4794:	0f000000 	svceq	0x00000000
    4798:	000025cd 	andeq	r2, r0, sp, asr #11
    479c:	0c01e205 	sfmeq	f6, 1, [r1], {5}
    47a0:	0000001d 	andeq	r0, r0, sp, lsl r0
    47a4:	0021d50f 	eoreq	sp, r1, pc, lsl #10
    47a8:	01e50500 	mvneq	r0, r0, lsl #10
    47ac:	00001d0c 	andeq	r1, r0, ip, lsl #26
    47b0:	242d0f00 	strtcs	r0, [sp], #-3840	; 0xfffff100
    47b4:	e8050000 	stmda	r5, {}	; <UNPREDICTABLE>
    47b8:	001d0c01 	andseq	r0, sp, r1, lsl #24
    47bc:	e70f0000 	str	r0, [pc, -r0]
    47c0:	05000028 	streq	r0, [r0, #-40]	; 0xffffffd8
    47c4:	1d0c01ef 	stfnes	f0, [ip, #-956]	; 0xfffffc44
    47c8:	0f000000 	svceq	0x00000000
    47cc:	00002a9f 	muleq	r0, pc, sl	; <UNPREDICTABLE>
    47d0:	0c01f205 	sfmeq	f7, 1, [r1], {5}
    47d4:	0000001d 	andeq	r0, r0, sp, lsl r0
    47d8:	002aaf0f 	eoreq	sl, sl, pc, lsl #30
    47dc:	01f50500 	mvnseq	r0, r0, lsl #10
    47e0:	00001d0c 	andeq	r1, r0, ip, lsl #26
    47e4:	1d950f00 	ldcne	15, cr0, [r5]
    47e8:	f8050000 			; <UNDEFINED> instruction: 0xf8050000
    47ec:	001d0c01 	andseq	r0, sp, r1, lsl #24
    47f0:	2e0f0000 	cdpcs	0, 0, cr0, cr15, cr0, {0}
    47f4:	05000029 	streq	r0, [r0, #-41]	; 0xffffffd7
    47f8:	1d0c01fb 	stfnes	f0, [ip, #-1004]	; 0xfffffc14
    47fc:	0f000000 	svceq	0x00000000
    4800:	00002533 	andeq	r2, r0, r3, lsr r5
    4804:	0c01fe05 	stceq	14, cr15, [r1], {5}
    4808:	0000001d 	andeq	r0, r0, sp, lsl r0
    480c:	0020090f 	eoreq	r0, r0, pc, lsl #18
    4810:	02020500 	andeq	r0, r2, #0, 10
    4814:	00001d0c 	andeq	r1, r0, ip, lsl #26
    4818:	27230f00 	strcs	r0, [r3, -r0, lsl #30]!
    481c:	0a050000 	beq	144824 <_bss_end+0x138b28>
    4820:	001d0c02 	andseq	r0, sp, r2, lsl #24
    4824:	fc0f0000 	stc2	0, cr0, [pc], {-0}
    4828:	0500001e 	streq	r0, [r0, #-30]	; 0xffffffe2
    482c:	1d0c020d 	sfmne	f0, 4, [ip, #-52]	; 0xffffffcc
    4830:	0c000000 	stceq	0, cr0, [r0], {-0}
    4834:	0000001d 	andeq	r0, r0, sp, lsl r0
    4838:	000007ef 	andeq	r0, r0, pc, ror #15
    483c:	d50f000d 	strle	r0, [pc, #-13]	; 4837 <CPSR_IRQ_INHIBIT+0x47b7>
    4840:	05000020 	streq	r0, [r0, #-32]	; 0xffffffe0
    4844:	e40c03fb 	str	r0, [ip], #-1019	; 0xfffffc05
    4848:	0c000007 	stceq	0, cr0, [r0], {7}
    484c:	000004e6 	andeq	r0, r0, r6, ror #9
    4850:	0000080c 	andeq	r0, r0, ip, lsl #16
    4854:	00002415 	andeq	r2, r0, r5, lsl r4
    4858:	0f000d00 	svceq	0x00000d00
    485c:	000025f0 	strdeq	r2, [r0], -r0
    4860:	14058405 	strne	r8, [r5], #-1029	; 0xfffffbfb
    4864:	000007fc 	strdeq	r0, [r0], -ip
    4868:	00219716 	eoreq	r9, r1, r6, lsl r7
    486c:	93010700 	movwls	r0, #5888	; 0x1700
    4870:	05000000 	streq	r0, [r0, #-0]
    4874:	5706058b 	strpl	r0, [r6, -fp, lsl #11]
    4878:	0b000008 	bleq	48a0 <CPSR_IRQ_INHIBIT+0x4820>
    487c:	00001f52 	andeq	r1, r0, r2, asr pc
    4880:	23a20b00 			; <UNDEFINED> instruction: 0x23a20b00
    4884:	0b010000 	bleq	4488c <_bss_end+0x38b90>
    4888:	00001b2a 	andeq	r1, r0, sl, lsr #22
    488c:	2a610b02 	bcs	184749c <_bss_end+0x183b7a0>
    4890:	0b030000 	bleq	c4898 <_bss_end+0xb8b9c>
    4894:	0000266a 	andeq	r2, r0, sl, ror #12
    4898:	265d0b04 	ldrbcs	r0, [sp], -r4, lsl #22
    489c:	0b050000 	bleq	1448a4 <_bss_end+0x138ba8>
    48a0:	00001c01 	andeq	r1, r0, r1, lsl #24
    48a4:	510f0006 	tstpl	pc, r6
    48a8:	0500002a 	streq	r0, [r0, #-42]	; 0xffffffd6
    48ac:	19150598 	ldmdbne	r5, {r3, r4, r7, r8, sl}
    48b0:	0f000008 	svceq	0x00000008
    48b4:	00002953 	andeq	r2, r0, r3, asr r9
    48b8:	11079905 	tstne	r7, r5, lsl #18
    48bc:	00000024 	andeq	r0, r0, r4, lsr #32
    48c0:	0025dd0f 	eoreq	sp, r5, pc, lsl #26
    48c4:	07ae0500 	streq	r0, [lr, r0, lsl #10]!
    48c8:	00001d0c 	andeq	r1, r0, ip, lsl #26
    48cc:	28c60400 	stmiacs	r6, {sl}^
    48d0:	7b060000 	blvc	1848d8 <_bss_end+0x178bdc>
    48d4:	00009316 	andeq	r9, r0, r6, lsl r3
    48d8:	087e0e00 	ldmdaeq	lr!, {r9, sl, fp}^
    48dc:	02030000 	andeq	r0, r3, #0
    48e0:	00028005 	andeq	r8, r2, r5
    48e4:	07080300 	streq	r0, [r8, -r0, lsl #6]
    48e8:	00001ee5 	andeq	r1, r0, r5, ror #29
    48ec:	b9040403 	stmdblt	r4, {r0, r1, sl}
    48f0:	0300001c 	movweq	r0, #28
    48f4:	1cb10308 	ldcne	3, cr0, [r1], #32
    48f8:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    48fc:	0025c604 	eoreq	ip, r5, r4, lsl #12
    4900:	03100300 	tsteq	r0, #0, 6
    4904:	00002678 	andeq	r2, r0, r8, ror r6
    4908:	00088a0c 	andeq	r8, r8, ip, lsl #20
    490c:	0008c900 	andeq	ip, r8, r0, lsl #18
    4910:	00241500 	eoreq	r1, r4, r0, lsl #10
    4914:	00ff0000 	rscseq	r0, pc, r0
    4918:	0008b90e 	andeq	fp, r8, lr, lsl #18
    491c:	24d70f00 	ldrbcs	r0, [r7], #3840	; 0xf00
    4920:	fc060000 	stc2	0, cr0, [r6], {-0}
    4924:	08c91601 	stmiaeq	r9, {r0, r9, sl, ip}^
    4928:	680f0000 	stmdavs	pc, {}	; <UNPREDICTABLE>
    492c:	0600001c 			; <UNDEFINED> instruction: 0x0600001c
    4930:	c9160202 	ldmdbgt	r6, {r1, r9}
    4934:	04000008 	streq	r0, [r0], #-8
    4938:	000028f9 	strdeq	r2, [r0], -r9
    493c:	f9102a07 			; <UNDEFINED> instruction: 0xf9102a07
    4940:	0c000004 	stceq	0, cr0, [r0], {4}
    4944:	000008e8 	andeq	r0, r0, r8, ror #17
    4948:	000008ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    494c:	9f09000d 	svcls	0x0009000d
    4950:	07000018 	smladeq	r0, r8, r0, r0
    4954:	08f4112f 	ldmeq	r4!, {r0, r1, r2, r3, r5, r8, ip}^
    4958:	d1090000 	mrsle	r0, (UNDEF: 9)
    495c:	07000018 	smladeq	r0, r8, r0, r0
    4960:	08f41130 	ldmeq	r4!, {r4, r5, r8, ip}^
    4964:	ff170000 			; <UNDEFINED> instruction: 0xff170000
    4968:	08000008 	stmdaeq	r0, {r3}
    496c:	050a0933 	streq	r0, [sl, #-2355]	; 0xfffff6cd
    4970:	00ac8403 	adceq	r8, ip, r3, lsl #8
    4974:	090b1700 	stmdbeq	fp, {r8, r9, sl, ip}
    4978:	34080000 	strcc	r0, [r8], #-0
    497c:	03050a09 	movweq	r0, #23049	; 0x5a09
    4980:	0000aca0 	andeq	sl, r0, r0, lsr #25
	...

Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
       0:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
       4:	030b130e 	movweq	r1, #45838	; 0xb30e
       8:	110e1b0e 	tstne	lr, lr, lsl #22
       c:	10061201 	andne	r1, r6, r1, lsl #4
      10:	02000017 	andeq	r0, r0, #23
      14:	193f002e 	ldmdbne	pc!, {r1, r2, r3, r5}	; <UNPREDICTABLE>
      18:	0b3a0e03 	bleq	e8382c <_bss_end+0xe77b30>
      1c:	0b390b3b 	bleq	e42d10 <_bss_end+0xe37014>
      20:	06120111 			; <UNDEFINED> instruction: 0x06120111
      24:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
      28:	03000019 	movweq	r0, #25
      2c:	0e030139 	mcreq	1, 0, r0, cr3, cr9, {1}
      30:	0b3b0b3a 	bleq	ec2d20 <_bss_end+0xeb7024>
      34:	00001301 	andeq	r1, r0, r1, lsl #6
      38:	3f012e04 	svccc	0x00012e04
      3c:	3a0e0319 	bcc	380ca8 <_bss_end+0x374fac>
      40:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
      44:	01193c0b 	tsteq	r9, fp, lsl #24
      48:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
      4c:	13490005 	movtne	r0, #36869	; 0x9005
      50:	16060000 	strne	r0, [r6], -r0
      54:	3a0e0300 	bcc	380c5c <_bss_end+0x374f60>
      58:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
      5c:	0013490b 	andseq	r4, r3, fp, lsl #18
      60:	012e0700 			; <UNDEFINED> instruction: 0x012e0700
      64:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
      68:	0b3b0b3a 	bleq	ec2d58 <_bss_end+0xeb705c>
      6c:	13490b39 	movtne	r0, #39737	; 0x9b39
      70:	0000193c 	andeq	r1, r0, ip, lsr r9
      74:	0b000f08 	bleq	3c9c <CPSR_IRQ_INHIBIT+0x3c1c>
      78:	0013490b 	andseq	r4, r3, fp, lsl #18
      7c:	00240900 	eoreq	r0, r4, r0, lsl #18
      80:	0b3e0b0b 	bleq	f82cb4 <_bss_end+0xf76fb8>
      84:	00000e03 	andeq	r0, r0, r3, lsl #28
      88:	47012e0a 	strmi	r2, [r1, -sl, lsl #28]
      8c:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
      90:	97184006 	ldrls	r4, [r8, -r6]
      94:	13011942 	movwne	r1, #6466	; 0x1942
      98:	050b0000 	streq	r0, [fp, #-0]
      9c:	02134900 	andseq	r4, r3, #0, 18
      a0:	0c000018 	stceq	0, cr0, [r0], {24}
      a4:	08030005 	stmdaeq	r3, {r0, r2}
      a8:	0b3b0b3a 	bleq	ec2d98 <_bss_end+0xeb709c>
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
      e4:	0b0b0024 	bleq	2c017c <_bss_end+0x2b4480>
      e8:	0e030b3e 	vmoveq.16	d3[0], r0
      ec:	24030000 	strcs	r0, [r3], #-0
      f0:	3e0b0b00 	vmlacc.f64	d0, d11, d0
      f4:	0008030b 	andeq	r0, r8, fp, lsl #6
      f8:	00160400 	andseq	r0, r6, r0, lsl #8
      fc:	0b3a0e03 	bleq	e83910 <_bss_end+0xe77c14>
     100:	0b390b3b 	bleq	e42df4 <_bss_end+0xe370f8>
     104:	00001349 	andeq	r1, r0, r9, asr #6
     108:	49002605 	stmdbmi	r0, {r0, r2, r9, sl, sp}
     10c:	06000013 			; <UNDEFINED> instruction: 0x06000013
     110:	13490035 	movtne	r0, #36917	; 0x9035
     114:	39070000 	stmdbcc	r7, {}	; <UNPREDICTABLE>
     118:	3a080301 	bcc	200d24 <_bss_end+0x1f5028>
     11c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     120:	0013010b 	andseq	r0, r3, fp, lsl #2
     124:	00340800 	eorseq	r0, r4, r0, lsl #16
     128:	0b3a0e03 	bleq	e8393c <_bss_end+0xe77c40>
     12c:	0b390b3b 	bleq	e42e20 <_bss_end+0xe37124>
     130:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
     134:	196c061c 	stmdbne	ip!, {r2, r3, r4, r9, sl}^
     138:	34090000 	strcc	r0, [r9], #-0
     13c:	3a0e0300 	bcc	380d44 <_bss_end+0x375048>
     140:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     144:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
     148:	6c0b1c19 	stcvs	12, cr1, [fp], {25}
     14c:	0a000019 	beq	1b8 <CPSR_IRQ_INHIBIT+0x138>
     150:	0e030104 	adfeqs	f0, f3, f4
     154:	0b3e196d 	bleq	f86710 <_bss_end+0xf7aa14>
     158:	13490b0b 	movtne	r0, #39691	; 0x9b0b
     15c:	0b3b0b3a 	bleq	ec2e4c <_bss_end+0xeb7150>
     160:	13010b39 	movwne	r0, #6969	; 0x1b39
     164:	280b0000 	stmdacs	fp, {}	; <UNPREDICTABLE>
     168:	1c0e0300 	stcne	3, cr0, [lr], {-0}
     16c:	0c00000b 	stceq	0, cr0, [r0], {11}
     170:	13470034 	movtne	r0, #28724	; 0x7034
     174:	020d0000 	andeq	r0, sp, #0
     178:	0b0e0301 	bleq	380d84 <_bss_end+0x375088>
     17c:	3b0b3a0b 	blcc	2ce9b0 <_bss_end+0x2c2cb4>
     180:	010b390b 	tsteq	fp, fp, lsl #18
     184:	0e000013 	mcreq	0, 0, r0, cr0, cr3, {0}
     188:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
     18c:	0b3b0b3a 	bleq	ec2e7c <_bss_end+0xeb7180>
     190:	13490b39 	movtne	r0, #39737	; 0x9b39
     194:	00000b38 	andeq	r0, r0, r8, lsr fp
     198:	3f012e0f 	svccc	0x00012e0f
     19c:	3a0e0319 	bcc	380e08 <_bss_end+0x37510c>
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
     1c8:	0b3a0e03 	bleq	e839dc <_bss_end+0xe77ce0>
     1cc:	0b390b3b 	bleq	e42ec0 <_bss_end+0xe371c4>
     1d0:	0b320e6e 	bleq	c83b90 <_bss_end+0xc77e94>
     1d4:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
     1d8:	00001301 	andeq	r1, r0, r1, lsl #6
     1dc:	3f012e13 	svccc	0x00012e13
     1e0:	3a0e0319 	bcc	380e4c <_bss_end+0x375150>
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
     20c:	0b3b0b3a 	bleq	ec2efc <_bss_end+0xeb7200>
     210:	13490b39 	movtne	r0, #39737	; 0x9b39
     214:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
     218:	34170000 	ldrcc	r0, [r7], #-0
     21c:	3a134700 	bcc	4d1e24 <_bss_end+0x4c6128>
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
     254:	0b3b0b3a 	bleq	ec2f44 <_bss_end+0xeb7248>
     258:	13490b39 	movtne	r0, #39737	; 0x9b39
     25c:	00001802 	andeq	r1, r0, r2, lsl #16
     260:	47012e1b 	smladmi	r1, fp, lr, r2
     264:	3b0b3a13 	blcc	2ceab8 <_bss_end+0x2c2dbc>
     268:	640b390b 	strvs	r3, [fp], #-2315	; 0xfffff6f5
     26c:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
     270:	96184006 	ldrls	r4, [r8], -r6
     274:	13011942 	movwne	r1, #6466	; 0x1942
     278:	051c0000 	ldreq	r0, [ip, #-0]
     27c:	490e0300 	stmdbmi	lr, {r8, r9}
     280:	02193413 	andseq	r3, r9, #318767104	; 0x13000000
     284:	1d000018 	stcne	0, cr0, [r0, #-96]	; 0xffffffa0
     288:	08030005 	stmdaeq	r3, {r0, r2}
     28c:	0b3b0b3a 	bleq	ec2f7c <_bss_end+0xeb7280>
     290:	13490b39 	movtne	r0, #39737	; 0x9b39
     294:	00001802 	andeq	r1, r0, r2, lsl #16
     298:	0300341e 	movweq	r3, #1054	; 0x41e
     29c:	3b0b3a08 	blcc	2ceac4 <_bss_end+0x2c2dc8>
     2a0:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     2a4:	00180213 	andseq	r0, r8, r3, lsl r2
     2a8:	00341f00 	eorseq	r1, r4, r0, lsl #30
     2ac:	0b3a0e03 	bleq	e83ac0 <_bss_end+0xe77dc4>
     2b0:	0b390b3b 	bleq	e42fa4 <_bss_end+0xe372a8>
     2b4:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
     2b8:	2e200000 	cdpcs	0, 2, cr0, cr0, cr0, {0}
     2bc:	3a134701 	bcc	4d1ec8 <_bss_end+0x4c61cc>
     2c0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     2c4:	1113640b 	tstne	r3, fp, lsl #8
     2c8:	40061201 	andmi	r1, r6, r1, lsl #4
     2cc:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
     2d0:	00001301 	andeq	r1, r0, r1, lsl #6
     2d4:	47012e21 	strmi	r2, [r1, -r1, lsr #28]
     2d8:	3b0b3a13 	blcc	2ceb2c <_bss_end+0x2c2e30>
     2dc:	640b390b 	strvs	r3, [fp], #-2315	; 0xfffff6f5
     2e0:	010b2013 	tsteq	fp, r3, lsl r0
     2e4:	22000013 	andcs	r0, r0, #19
     2e8:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
     2ec:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
     2f0:	05230000 	streq	r0, [r3, #-0]!
     2f4:	3a0e0300 	bcc	380efc <_bss_end+0x375200>
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
     334:	0b0e0301 	bleq	380f40 <_bss_end+0x375244>
     338:	3b0b3a0b 	blcc	2ceb6c <_bss_end+0x2c2e70>
     33c:	010b390b 	tsteq	fp, fp, lsl #18
     340:	03000013 	movweq	r0, #19
     344:	0e030104 	adfeqs	f0, f3, f4
     348:	0b3e196d 	bleq	f86904 <_bss_end+0xf7ac08>
     34c:	13490b0b 	movtne	r0, #39691	; 0x9b0b
     350:	0b3b0b3a 	bleq	ec3040 <_bss_end+0xeb7344>
     354:	0b320b39 	bleq	c83040 <_bss_end+0xc77344>
     358:	00001301 	andeq	r1, r0, r1, lsl #6
     35c:	03002804 	movweq	r2, #2052	; 0x804
     360:	000b1c08 	andeq	r1, fp, r8, lsl #24
     364:	00260500 	eoreq	r0, r6, r0, lsl #10
     368:	00001349 	andeq	r1, r0, r9, asr #6
     36c:	03011306 	movweq	r1, #4870	; 0x1306
     370:	3a0b0b0e 	bcc	2c2fb0 <_bss_end+0x2b72b4>
     374:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     378:	0013010b 	andseq	r0, r3, fp, lsl #2
     37c:	000d0700 	andeq	r0, sp, r0, lsl #14
     380:	0b3a0803 	bleq	e82394 <_bss_end+0xe76698>
     384:	0b390b3b 	bleq	e43078 <_bss_end+0xe3737c>
     388:	0b381349 	bleq	e050b4 <_bss_end+0xdf93b8>
     38c:	0d080000 	stceq	0, cr0, [r8, #-0]
     390:	3a0e0300 	bcc	380f98 <_bss_end+0x37529c>
     394:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     398:	3f13490b 	svccc	0x0013490b
     39c:	3c0b3219 	sfmcc	f3, 4, [fp], {25}
     3a0:	6c0b1c19 	stcvs	12, cr1, [fp], {25}
     3a4:	09000019 	stmdbeq	r0, {r0, r3, r4}
     3a8:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
     3ac:	0b3b0b3a 	bleq	ec309c <_bss_end+0xeb73a0>
     3b0:	13490b39 	movtne	r0, #39737	; 0x9b39
     3b4:	0b32193f 	bleq	c868b8 <_bss_end+0xc7abbc>
     3b8:	196c193c 	stmdbne	ip!, {r2, r3, r4, r5, r8, fp, ip}^
     3bc:	2e0a0000 	cdpcs	0, 0, cr0, cr10, cr0, {0}
     3c0:	03193f01 	tsteq	r9, #1, 30
     3c4:	3b0b3a0e 	blcc	2cec04 <_bss_end+0x2c2f08>
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
     3f0:	0b3a0e03 	bleq	e83c04 <_bss_end+0xe77f08>
     3f4:	0b390b3b 	bleq	e430e8 <_bss_end+0xe373ec>
     3f8:	0b320e6e 	bleq	c83db8 <_bss_end+0xc780bc>
     3fc:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
     400:	00001301 	andeq	r1, r0, r1, lsl #6
     404:	3f012e0e 	svccc	0x00012e0e
     408:	3a0e0319 	bcc	381074 <_bss_end+0x375378>
     40c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     410:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
     414:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
     418:	01136419 	tsteq	r3, r9, lsl r4
     41c:	0f000013 	svceq	0x00000013
     420:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
     424:	0b3a0e03 	bleq	e83c38 <_bss_end+0xe77f3c>
     428:	0b390b3b 	bleq	e4311c <_bss_end+0xe37420>
     42c:	193c0e6e 	ldmdbne	ip!, {r1, r2, r3, r5, r6, r9, sl, fp}
     430:	13011364 	movwne	r1, #4964	; 0x1364
     434:	2e100000 	cdpcs	0, 1, cr0, cr0, cr0, {0}
     438:	03193f01 	tsteq	r9, #1, 30
     43c:	3b0b3a0e 	blcc	2cec7c <_bss_end+0x2c2f80>
     440:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     444:	3c13490e 			; <UNDEFINED> instruction: 0x3c13490e
     448:	01136419 	tsteq	r3, r9, lsl r4
     44c:	11000013 	tstne	r0, r3, lsl r0
     450:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
     454:	0b3b0b3a 	bleq	ec3144 <_bss_end+0xeb7448>
     458:	13490b39 	movtne	r0, #39737	; 0x9b39
     45c:	00000b38 	andeq	r0, r0, r8, lsr fp
     460:	0b002412 	bleq	94b0 <Process_2+0x1c>
     464:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
     468:	1300000e 	movwne	r0, #14
     46c:	0b0b000f 	bleq	2c04b0 <_bss_end+0x2b47b4>
     470:	00001349 	andeq	r1, r0, r9, asr #6
     474:	0b001014 	bleq	44cc <CPSR_IRQ_INHIBIT+0x444c>
     478:	0013490b 	andseq	r4, r3, fp, lsl #18
     47c:	00351500 	eorseq	r1, r5, r0, lsl #10
     480:	00001349 	andeq	r1, r0, r9, asr #6
     484:	03003416 	movweq	r3, #1046	; 0x416
     488:	3b0b3a0e 	blcc	2cecc8 <_bss_end+0x2c2fcc>
     48c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     490:	3c193f13 	ldccc	15, cr3, [r9], {19}
     494:	17000019 	smladne	r0, r9, r0, r0
     498:	13470034 	movtne	r0, #28724	; 0x7034
     49c:	0b3b0b3a 	bleq	ec318c <_bss_end+0xeb7490>
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
     4d0:	3b0b3a0e 	blcc	2ced10 <_bss_end+0x2c3014>
     4d4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     4d8:	00180213 	andseq	r0, r8, r3, lsl r2
     4dc:	00241b00 	eoreq	r1, r4, r0, lsl #22
     4e0:	0b3e0b0b 	bleq	f83114 <_bss_end+0xf77418>
     4e4:	00000803 	andeq	r0, r0, r3, lsl #16
     4e8:	47012e1c 	smladmi	r1, ip, lr, r2
     4ec:	3b0b3a13 	blcc	2ced40 <_bss_end+0x2c3044>
     4f0:	640b390b 	strvs	r3, [fp], #-2315	; 0xfffff6f5
     4f4:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
     4f8:	96184006 	ldrls	r4, [r8], -r6
     4fc:	13011942 	movwne	r1, #6466	; 0x1942
     500:	051d0000 	ldreq	r0, [sp, #-0]
     504:	490e0300 	stmdbmi	lr, {r8, r9}
     508:	02193413 	andseq	r3, r9, #318767104	; 0x13000000
     50c:	1e000018 	mcrne	0, 0, r0, cr0, cr8, {0}
     510:	08030034 	stmdaeq	r3, {r2, r4, r5}
     514:	0b3b0b3a 	bleq	ec3204 <_bss_end+0xeb7508>
     518:	13490b39 	movtne	r0, #39737	; 0x9b39
     51c:	00001802 	andeq	r1, r0, r2, lsl #16
     520:	11010b1f 	tstne	r1, pc, lsl fp
     524:	00061201 	andeq	r1, r6, r1, lsl #4
     528:	012e2000 			; <UNDEFINED> instruction: 0x012e2000
     52c:	0b3a1347 	bleq	e85250 <_bss_end+0xe79554>
     530:	0b390b3b 	bleq	e43224 <_bss_end+0xe37528>
     534:	01111364 	tsteq	r1, r4, ror #6
     538:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
     53c:	01194297 			; <UNDEFINED> instruction: 0x01194297
     540:	21000013 	tstcs	r0, r3, lsl r0
     544:	08030005 	stmdaeq	r3, {r0, r2}
     548:	0b3b0b3a 	bleq	ec3238 <_bss_end+0xeb753c>
     54c:	13490b39 	movtne	r0, #39737	; 0x9b39
     550:	00001802 	andeq	r1, r0, r2, lsl #16
     554:	03003422 	movweq	r3, #1058	; 0x422
     558:	3b0b3a0e 	blcc	2ced98 <_bss_end+0x2c309c>
     55c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     560:	00180213 	andseq	r0, r8, r3, lsl r2
     564:	00342300 	eorseq	r2, r4, r0, lsl #6
     568:	0b3a0e03 	bleq	e83d7c <_bss_end+0xe78080>
     56c:	0b390b3b 	bleq	e43260 <_bss_end+0xe37564>
     570:	196c1349 	stmdbne	ip!, {r0, r3, r6, r8, r9, ip}^
     574:	00001802 	andeq	r1, r0, r2, lsl #16
     578:	49010124 	stmdbmi	r1, {r2, r5, r8}
     57c:	00130113 	andseq	r0, r3, r3, lsl r1
     580:	00212500 	eoreq	r2, r1, r0, lsl #10
     584:	0b2f1349 	bleq	bc52b0 <_bss_end+0xbb95b4>
     588:	0b260000 	bleq	980590 <_bss_end+0x974894>
     58c:	12011101 	andne	r1, r1, #1073741824	; 0x40000000
     590:	00130106 	andseq	r0, r3, r6, lsl #2
     594:	012e2700 			; <UNDEFINED> instruction: 0x012e2700
     598:	0b3a1347 	bleq	e852bc <_bss_end+0xe795c0>
     59c:	0b390b3b 	bleq	e43290 <_bss_end+0xe37594>
     5a0:	0b201364 	bleq	805338 <_bss_end+0x7f963c>
     5a4:	00001301 	andeq	r1, r0, r1, lsl #6
     5a8:	03000528 	movweq	r0, #1320	; 0x528
     5ac:	3413490e 	ldrcc	r4, [r3], #-2318	; 0xfffff6f2
     5b0:	29000019 	stmdbcs	r0, {r0, r3, r4}
     5b4:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
     5b8:	0b3b0b3a 	bleq	ec32a8 <_bss_end+0xeb75ac>
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
     5f4:	0b0b0024 	bleq	2c068c <_bss_end+0x2b4990>
     5f8:	0e030b3e 	vmoveq.16	d3[0], r0
     5fc:	24030000 	strcs	r0, [r3], #-0
     600:	3e0b0b00 	vmlacc.f64	d0, d11, d0
     604:	0008030b 	andeq	r0, r8, fp, lsl #6
     608:	00160400 	andseq	r0, r6, r0, lsl #8
     60c:	0b3a0e03 	bleq	e83e20 <_bss_end+0xe78124>
     610:	0b390b3b 	bleq	e43304 <_bss_end+0xe37608>
     614:	00001349 	andeq	r1, r0, r9, asr #6
     618:	49002605 	stmdbmi	r0, {r0, r2, r9, sl, sp}
     61c:	06000013 			; <UNDEFINED> instruction: 0x06000013
     620:	13490035 	movtne	r0, #36917	; 0x9035
     624:	39070000 	stmdbcc	r7, {}	; <UNPREDICTABLE>
     628:	3a080301 	bcc	201234 <_bss_end+0x1f5538>
     62c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     630:	0013010b 	andseq	r0, r3, fp, lsl #2
     634:	00340800 	eorseq	r0, r4, r0, lsl #16
     638:	0b3a0e03 	bleq	e83e4c <_bss_end+0xe78150>
     63c:	0b390b3b 	bleq	e43330 <_bss_end+0xe37634>
     640:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
     644:	196c061c 	stmdbne	ip!, {r2, r3, r4, r9, sl}^
     648:	34090000 	strcc	r0, [r9], #-0
     64c:	3a0e0300 	bcc	381254 <_bss_end+0x375558>
     650:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     654:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
     658:	6c0b1c19 	stcvs	12, cr1, [fp], {25}
     65c:	0a000019 	beq	6c8 <CPSR_IRQ_INHIBIT+0x648>
     660:	0e030104 	adfeqs	f0, f3, f4
     664:	0b3e196d 	bleq	f86c20 <_bss_end+0xf7af24>
     668:	13490b0b 	movtne	r0, #39691	; 0x9b0b
     66c:	0b3b0b3a 	bleq	ec335c <_bss_end+0xeb7660>
     670:	00000b39 	andeq	r0, r0, r9, lsr fp
     674:	0300280b 	movweq	r2, #2059	; 0x80b
     678:	000b1c0e 	andeq	r1, fp, lr, lsl #24
     67c:	00340c00 	eorseq	r0, r4, r0, lsl #24
     680:	00001347 	andeq	r1, r0, r7, asr #6
     684:	0301040d 	movweq	r0, #5133	; 0x140d
     688:	3e196d0e 	cdpcc	13, 1, cr6, cr9, cr14, {0}
     68c:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
     690:	3b0b3a13 	blcc	2ceee4 <_bss_end+0x2c31e8>
     694:	010b390b 	tsteq	fp, fp, lsl #18
     698:	0e000013 	mcreq	0, 0, r0, cr0, cr3, {0}
     69c:	0e030102 	adfeqs	f0, f3, f2
     6a0:	0b3a0b0b 	bleq	e832d4 <_bss_end+0xe775d8>
     6a4:	0b390b3b 	bleq	e43398 <_bss_end+0xe3769c>
     6a8:	00001301 	andeq	r1, r0, r1, lsl #6
     6ac:	03000d0f 	movweq	r0, #3343	; 0xd0f
     6b0:	3b0b3a0e 	blcc	2ceef0 <_bss_end+0x2c31f4>
     6b4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     6b8:	000b3813 	andeq	r3, fp, r3, lsl r8
     6bc:	00161000 	andseq	r1, r6, r0
     6c0:	0b3a0e03 	bleq	e83ed4 <_bss_end+0xe781d8>
     6c4:	0b390b3b 	bleq	e433b8 <_bss_end+0xe376bc>
     6c8:	0b321349 	bleq	c853f4 <_bss_end+0xc796f8>
     6cc:	2e110000 	cdpcs	0, 1, cr0, cr1, cr0, {0}
     6d0:	03193f01 	tsteq	r9, #1, 30
     6d4:	3b0b3a0e 	blcc	2cef14 <_bss_end+0x2c3218>
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
     700:	0b3b0b3a 	bleq	ec33f0 <_bss_end+0xeb76f4>
     704:	0e6e0b39 	vmoveq.8	d14[5], r0
     708:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
     70c:	13011364 	movwne	r1, #4964	; 0x1364
     710:	2e150000 	cdpcs	0, 1, cr0, cr5, cr0, {0}
     714:	03193f01 	tsteq	r9, #1, 30
     718:	3b0b3a0e 	blcc	2cef58 <_bss_end+0x2c325c>
     71c:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     720:	3213490e 	andscc	r4, r3, #229376	; 0x38000
     724:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
     728:	16000013 			; <UNDEFINED> instruction: 0x16000013
     72c:	0b0b000f 	bleq	2c0770 <_bss_end+0x2b4a74>
     730:	00001349 	andeq	r1, r0, r9, asr #6
     734:	00001517 	andeq	r1, r0, r7, lsl r5
     738:	00101800 	andseq	r1, r0, r0, lsl #16
     73c:	13490b0b 	movtne	r0, #39691	; 0x9b0b
     740:	34190000 	ldrcc	r0, [r9], #-0
     744:	3a0e0300 	bcc	38134c <_bss_end+0x375650>
     748:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     74c:	3f13490b 	svccc	0x0013490b
     750:	00193c19 	andseq	r3, r9, r9, lsl ip
     754:	00341a00 	eorseq	r1, r4, r0, lsl #20
     758:	0b3a1347 	bleq	e8547c <_bss_end+0xe79780>
     75c:	0b390b3b 	bleq	e43450 <_bss_end+0xe37754>
     760:	00001802 	andeq	r1, r0, r2, lsl #16
     764:	0301131b 	movweq	r1, #4891	; 0x131b
     768:	3a0b0b0e 	bcc	2c33a8 <_bss_end+0x2b76ac>
     76c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     770:	0013010b 	andseq	r0, r3, fp, lsl #2
     774:	000d1c00 	andeq	r1, sp, r0, lsl #24
     778:	0b3a0e03 	bleq	e83f8c <_bss_end+0xe78290>
     77c:	0b390b3b 	bleq	e43470 <_bss_end+0xe37774>
     780:	0b0b1349 	bleq	2c54ac <_bss_end+0x2b97b0>
     784:	0b0c0b0d 	bleq	3033c0 <_bss_end+0x2f76c4>
     788:	00000b38 	andeq	r0, r0, r8, lsr fp
     78c:	03000d1d 	movweq	r0, #3357	; 0xd1d
     790:	3b0b3a0e 	blcc	2cefd0 <_bss_end+0x2c32d4>
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
     7cc:	0b3a0e03 	bleq	e83fe0 <_bss_end+0xe782e4>
     7d0:	0b390b3b 	bleq	e434c4 <_bss_end+0xe377c8>
     7d4:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
     7d8:	2e210000 	cdpcs	0, 2, cr0, cr1, cr0, {0}
     7dc:	3a134701 	bcc	4d23e8 <_bss_end+0x4c66ec>
     7e0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     7e4:	1113640b 	tstne	r3, fp, lsl #8
     7e8:	40061201 	andmi	r1, r6, r1, lsl #4
     7ec:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
     7f0:	00001301 	andeq	r1, r0, r1, lsl #6
     7f4:	03000522 	movweq	r0, #1314	; 0x522
     7f8:	3413490e 	ldrcc	r4, [r3], #-2318	; 0xfffff6f2
     7fc:	00180219 	andseq	r0, r8, r9, lsl r2
     800:	00342300 	eorseq	r2, r4, r0, lsl #6
     804:	0b3a0803 	bleq	e82818 <_bss_end+0xe76b1c>
     808:	0b390b3b 	bleq	e434fc <_bss_end+0xe37800>
     80c:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
     810:	2e240000 	cdpcs	0, 2, cr0, cr4, cr0, {0}
     814:	3a134701 	bcc	4d2420 <_bss_end+0x4c6724>
     818:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     81c:	1113640b 	tstne	r3, fp, lsl #8
     820:	40061201 	andmi	r1, r6, r1, lsl #4
     824:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
     828:	00001301 	andeq	r1, r0, r1, lsl #6
     82c:	03000525 	movweq	r0, #1317	; 0x525
     830:	3b0b3a08 	blcc	2cf058 <_bss_end+0x2c335c>
     834:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     838:	00180213 	andseq	r0, r8, r3, lsl r2
     83c:	012e2600 			; <UNDEFINED> instruction: 0x012e2600
     840:	0b3a1347 	bleq	e85564 <_bss_end+0xe79868>
     844:	0b390b3b 	bleq	e43538 <_bss_end+0xe3783c>
     848:	0b201364 	bleq	8055e0 <_bss_end+0x7f98e4>
     84c:	00001301 	andeq	r1, r0, r1, lsl #6
     850:	03000527 	movweq	r0, #1319	; 0x527
     854:	3413490e 	ldrcc	r4, [r3], #-2318	; 0xfffff6f2
     858:	28000019 	stmdacs	r0, {r0, r3, r4}
     85c:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
     860:	0b3b0b3a 	bleq	ec3550 <_bss_end+0xeb7854>
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
     89c:	0b0b0024 	bleq	2c0934 <_bss_end+0x2b4c38>
     8a0:	0e030b3e 	vmoveq.16	d3[0], r0
     8a4:	24030000 	strcs	r0, [r3], #-0
     8a8:	3e0b0b00 	vmlacc.f64	d0, d11, d0
     8ac:	0008030b 	andeq	r0, r8, fp, lsl #6
     8b0:	00160400 	andseq	r0, r6, r0, lsl #8
     8b4:	0b3a0e03 	bleq	e840c8 <_bss_end+0xe783cc>
     8b8:	0b390b3b 	bleq	e435ac <_bss_end+0xe378b0>
     8bc:	00001349 	andeq	r1, r0, r9, asr #6
     8c0:	49002605 	stmdbmi	r0, {r0, r2, r9, sl, sp}
     8c4:	06000013 			; <UNDEFINED> instruction: 0x06000013
     8c8:	13490035 	movtne	r0, #36917	; 0x9035
     8cc:	39070000 	stmdbcc	r7, {}	; <UNPREDICTABLE>
     8d0:	3a080301 	bcc	2014dc <_bss_end+0x1f57e0>
     8d4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     8d8:	0013010b 	andseq	r0, r3, fp, lsl #2
     8dc:	00340800 	eorseq	r0, r4, r0, lsl #16
     8e0:	0b3a0e03 	bleq	e840f4 <_bss_end+0xe783f8>
     8e4:	0b390b3b 	bleq	e435d8 <_bss_end+0xe378dc>
     8e8:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
     8ec:	196c061c 	stmdbne	ip!, {r2, r3, r4, r9, sl}^
     8f0:	34090000 	strcc	r0, [r9], #-0
     8f4:	3a0e0300 	bcc	3814fc <_bss_end+0x375800>
     8f8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     8fc:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
     900:	6c0b1c19 	stcvs	12, cr1, [fp], {25}
     904:	0a000019 	beq	970 <CPSR_IRQ_INHIBIT+0x8f0>
     908:	0e030104 	adfeqs	f0, f3, f4
     90c:	0b3e196d 	bleq	f86ec8 <_bss_end+0xf7b1cc>
     910:	13490b0b 	movtne	r0, #39691	; 0x9b0b
     914:	0b3b0b3a 	bleq	ec3604 <_bss_end+0xeb7908>
     918:	13010b39 	movwne	r0, #6969	; 0x1b39
     91c:	280b0000 	stmdacs	fp, {}	; <UNPREDICTABLE>
     920:	1c0e0300 	stcne	3, cr0, [lr], {-0}
     924:	0c00000b 	stceq	0, cr0, [r0], {11}
     928:	08030028 	stmdaeq	r3, {r3, r5}
     92c:	00000b1c 	andeq	r0, r0, ip, lsl fp
     930:	0301040d 	movweq	r0, #5133	; 0x140d
     934:	3e196d0e 	cdpcc	13, 1, cr6, cr9, cr14, {0}
     938:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
     93c:	3b0b3a13 	blcc	2cf190 <_bss_end+0x2c3494>
     940:	000b390b 	andeq	r3, fp, fp, lsl #18
     944:	00340e00 	eorseq	r0, r4, r0, lsl #28
     948:	00001347 	andeq	r1, r0, r7, asr #6
     94c:	0301020f 	movweq	r0, #4623	; 0x120f
     950:	3a0b0b0e 	bcc	2c3590 <_bss_end+0x2b7894>
     954:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     958:	0013010b 	andseq	r0, r3, fp, lsl #2
     95c:	000d1000 	andeq	r1, sp, r0
     960:	0b3a0e03 	bleq	e84174 <_bss_end+0xe78478>
     964:	0b390b3b 	bleq	e43658 <_bss_end+0xe3795c>
     968:	0b381349 	bleq	e05694 <_bss_end+0xdf9998>
     96c:	2e110000 	cdpcs	0, 1, cr0, cr1, cr0, {0}
     970:	03193f01 	tsteq	r9, #1, 30
     974:	3b0b3a0e 	blcc	2cf1b4 <_bss_end+0x2c34b8>
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
     9a0:	0b3b0b3a 	bleq	ec3690 <_bss_end+0xeb7994>
     9a4:	0e6e0b39 	vmoveq.8	d14[5], r0
     9a8:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
     9ac:	13011364 	movwne	r1, #4964	; 0x1364
     9b0:	2e150000 	cdpcs	0, 1, cr0, cr5, cr0, {0}
     9b4:	03193f01 	tsteq	r9, #1, 30
     9b8:	3b0b3a0e 	blcc	2cf1f8 <_bss_end+0x2c34fc>
     9bc:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     9c0:	3c0b320e 	sfmcc	f3, 4, [fp], {14}
     9c4:	00136419 	andseq	r6, r3, r9, lsl r4
     9c8:	000f1600 	andeq	r1, pc, r0, lsl #12
     9cc:	13490b0b 	movtne	r0, #39691	; 0x9b0b
     9d0:	10170000 	andsne	r0, r7, r0
     9d4:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
     9d8:	18000013 	stmdane	r0, {r0, r1, r4}
     9dc:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
     9e0:	0b3b0b3a 	bleq	ec36d0 <_bss_end+0xeb79d4>
     9e4:	13490b39 	movtne	r0, #39737	; 0x9b39
     9e8:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
     9ec:	16190000 	ldrne	r0, [r9], -r0
     9f0:	3a0e0300 	bcc	3815f8 <_bss_end+0x3758fc>
     9f4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     9f8:	3213490b 	andscc	r4, r3, #180224	; 0x2c000
     9fc:	1a00000b 	bne	a30 <CPSR_IRQ_INHIBIT+0x9b0>
     a00:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
     a04:	0b3a0e03 	bleq	e84218 <_bss_end+0xe7851c>
     a08:	0b390b3b 	bleq	e436fc <_bss_end+0xe37a00>
     a0c:	13490e6e 	movtne	r0, #40558	; 0x9e6e
     a10:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
     a14:	00001364 	andeq	r1, r0, r4, ror #6
     a18:	0000151b 	andeq	r1, r0, fp, lsl r5
     a1c:	00341c00 	eorseq	r1, r4, r0, lsl #24
     a20:	0b3a1347 	bleq	e85744 <_bss_end+0xe79a48>
     a24:	0b390b3b 	bleq	e43718 <_bss_end+0xe37a1c>
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
     a54:	3a0e0300 	bcc	38165c <_bss_end+0x375960>
     a58:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     a5c:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
     a60:	20000018 	andcs	r0, r0, r8, lsl r0
     a64:	1347012e 	movtne	r0, #28974	; 0x712e
     a68:	0b3b0b3a 	bleq	ec3758 <_bss_end+0xeb7a5c>
     a6c:	13640b39 	cmnne	r4, #58368	; 0xe400
     a70:	06120111 			; <UNDEFINED> instruction: 0x06120111
     a74:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
     a78:	00130119 	andseq	r0, r3, r9, lsl r1
     a7c:	00052100 	andeq	r2, r5, r0, lsl #2
     a80:	13490e03 	movtne	r0, #40451	; 0x9e03
     a84:	18021934 	stmdane	r2, {r2, r4, r5, r8, fp, ip}
     a88:	34220000 	strtcc	r0, [r2], #-0
     a8c:	3a0e0300 	bcc	381694 <_bss_end+0x375998>
     a90:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     a94:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
     a98:	23000018 	movwcs	r0, #24
     a9c:	1347012e 	movtne	r0, #28974	; 0x712e
     aa0:	0b3b0b3a 	bleq	ec3790 <_bss_end+0xeb7a94>
     aa4:	13640b39 	cmnne	r4, #58368	; 0xe400
     aa8:	06120111 			; <UNDEFINED> instruction: 0x06120111
     aac:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
     ab0:	00130119 	andseq	r0, r3, r9, lsl r1
     ab4:	00052400 	andeq	r2, r5, r0, lsl #8
     ab8:	0b3a0803 	bleq	e82acc <_bss_end+0xe76dd0>
     abc:	0b390b3b 	bleq	e437b0 <_bss_end+0xe37ab4>
     ac0:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
     ac4:	2e250000 	cdpcs	0, 2, cr0, cr5, cr0, {0}
     ac8:	3a134701 	bcc	4d26d4 <_bss_end+0x4c69d8>
     acc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     ad0:	2013640b 	andscs	r6, r3, fp, lsl #8
     ad4:	0013010b 	andseq	r0, r3, fp, lsl #2
     ad8:	00052600 	andeq	r2, r5, r0, lsl #12
     adc:	13490e03 	movtne	r0, #40451	; 0x9e03
     ae0:	00001934 	andeq	r1, r0, r4, lsr r9
     ae4:	03000527 	movweq	r0, #1319	; 0x527
     ae8:	3b0b3a0e 	blcc	2cf328 <_bss_end+0x2c362c>
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
     b18:	3b0b3a0e 	blcc	2cf358 <_bss_end+0x2c365c>
     b1c:	110b390b 	tstne	fp, fp, lsl #18
     b20:	40061201 	andmi	r1, r6, r1, lsl #4
     b24:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
     b28:	2e2b0000 	cdpcs	0, 2, cr0, cr11, cr0, {0}
     b2c:	03193f00 	tsteq	r9, #0, 30
     b30:	3b0b3a0e 	blcc	2cf370 <_bss_end+0x2c3674>
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
     b68:	0b002404 	bleq	9b80 <_ZN13CPage_ManagerC1Ev+0x2c>
     b6c:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
     b70:	05000008 	streq	r0, [r0, #-8]
     b74:	13490035 	movtne	r0, #36917	; 0x9035
     b78:	16060000 	strne	r0, [r6], -r0
     b7c:	3a0e0300 	bcc	381784 <_bss_end+0x375a88>
     b80:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     b84:	0013490b 	andseq	r4, r3, fp, lsl #18
     b88:	01040700 	tsteq	r4, r0, lsl #14
     b8c:	196d0e03 	stmdbne	sp!, {r0, r1, r9, sl, fp}^
     b90:	0b0b0b3e 	bleq	2c3890 <_bss_end+0x2b7b94>
     b94:	0b3a1349 	bleq	e858c0 <_bss_end+0xe79bc4>
     b98:	0b390b3b 	bleq	e4388c <_bss_end+0xe37b90>
     b9c:	00001301 	andeq	r1, r0, r1, lsl #6
     ba0:	03002808 	movweq	r2, #2056	; 0x808
     ba4:	000b1c0e 	andeq	r1, fp, lr, lsl #24
     ba8:	01020900 	tsteq	r2, r0, lsl #18
     bac:	0b0b0e03 	bleq	2c43c0 <_bss_end+0x2b86c4>
     bb0:	0b3b0b3a 	bleq	ec38a0 <_bss_end+0xeb7ba4>
     bb4:	13010b39 	movwne	r0, #6969	; 0x1b39
     bb8:	0d0a0000 	stceq	0, cr0, [sl, #-0]
     bbc:	3a0e0300 	bcc	3817c4 <_bss_end+0x375ac8>
     bc0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     bc4:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
     bc8:	0b00000b 	bleq	bfc <CPSR_IRQ_INHIBIT+0xb7c>
     bcc:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
     bd0:	0b3a0e03 	bleq	e843e4 <_bss_end+0xe786e8>
     bd4:	0b390b3b 	bleq	e438c8 <_bss_end+0xe37bcc>
     bd8:	13490e6e 	movtne	r0, #40558	; 0x9e6e
     bdc:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
     be0:	13011364 	movwne	r1, #4964	; 0x1364
     be4:	050c0000 	streq	r0, [ip, #-0]
     be8:	34134900 	ldrcc	r4, [r3], #-2304	; 0xfffff700
     bec:	0d000019 	stceq	0, cr0, [r0, #-100]	; 0xffffff9c
     bf0:	13490005 	movtne	r0, #36869	; 0x9005
     bf4:	2e0e0000 	cdpcs	0, 0, cr0, cr14, cr0, {0}
     bf8:	03193f01 	tsteq	r9, #1, 30
     bfc:	3b0b3a0e 	blcc	2cf43c <_bss_end+0x2c3740>
     c00:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     c04:	3c0b320e 	sfmcc	f3, 4, [fp], {14}
     c08:	01136419 	tsteq	r3, r9, lsl r4
     c0c:	0f000013 	svceq	0x00000013
     c10:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
     c14:	0b3a0e03 	bleq	e84428 <_bss_end+0xe7872c>
     c18:	0b390b3b 	bleq	e4390c <_bss_end+0xe37c10>
     c1c:	13490e6e 	movtne	r0, #40558	; 0x9e6e
     c20:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
     c24:	00001364 	andeq	r1, r0, r4, ror #6
     c28:	0b000f10 	bleq	4870 <CPSR_IRQ_INHIBIT+0x47f0>
     c2c:	0013490b 	andseq	r4, r3, fp, lsl #18
     c30:	00101100 	andseq	r1, r0, r0, lsl #2
     c34:	13490b0b 	movtne	r0, #39691	; 0x9b0b
     c38:	34120000 	ldrcc	r0, [r2], #-0
     c3c:	3a0e0300 	bcc	381844 <_bss_end+0x375b48>
     c40:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     c44:	3f13490b 	svccc	0x0013490b
     c48:	00193c19 	andseq	r3, r9, r9, lsl ip
     c4c:	01041300 	mrseq	r1, LR_abt
     c50:	196d0e03 	stmdbne	sp!, {r0, r1, r9, sl, fp}^
     c54:	0b0b0b3e 	bleq	2c3954 <_bss_end+0x2b7c58>
     c58:	0b3a1349 	bleq	e85984 <_bss_end+0xe79c88>
     c5c:	0b390b3b 	bleq	e43950 <_bss_end+0xe37c54>
     c60:	13010b32 	movwne	r0, #6962	; 0x1b32
     c64:	28140000 	ldmdacs	r4, {}	; <UNPREDICTABLE>
     c68:	1c080300 	stcne	3, cr0, [r8], {-0}
     c6c:	1500000b 	strne	r0, [r0, #-11]
     c70:	0e030113 	mcreq	1, 0, r0, cr3, cr3, {0}
     c74:	0b3a0b0b 	bleq	e838a8 <_bss_end+0xe77bac>
     c78:	0b390b3b 	bleq	e4396c <_bss_end+0xe37c70>
     c7c:	00001301 	andeq	r1, r0, r1, lsl #6
     c80:	03000d16 	movweq	r0, #3350	; 0xd16
     c84:	3b0b3a08 	blcc	2cf4ac <_bss_end+0x2c37b0>
     c88:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     c8c:	000b3813 	andeq	r3, fp, r3, lsl r8
     c90:	000d1700 	andeq	r1, sp, r0, lsl #14
     c94:	0b3a0e03 	bleq	e844a8 <_bss_end+0xe787ac>
     c98:	0b390b3b 	bleq	e4398c <_bss_end+0xe37c90>
     c9c:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
     ca0:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
     ca4:	196c0b1c 	stmdbne	ip!, {r2, r3, r4, r8, r9, fp}^
     ca8:	0d180000 	ldceq	0, cr0, [r8, #-0]
     cac:	3a0e0300 	bcc	3818b4 <_bss_end+0x375bb8>
     cb0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     cb4:	3f13490b 	svccc	0x0013490b
     cb8:	3c0b3219 	sfmcc	f3, 4, [fp], {25}
     cbc:	00196c19 	andseq	r6, r9, r9, lsl ip
     cc0:	012e1900 			; <UNDEFINED> instruction: 0x012e1900
     cc4:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     cc8:	0b3b0b3a 	bleq	ec39b8 <_bss_end+0xeb7cbc>
     ccc:	0e6e0b39 	vmoveq.8	d14[5], r0
     cd0:	0b321349 	bleq	c859fc <_bss_end+0xc79d00>
     cd4:	1963193c 	stmdbne	r3!, {r2, r3, r4, r5, r8, fp, ip}^
     cd8:	13011364 	movwne	r1, #4964	; 0x1364
     cdc:	2e1a0000 	cdpcs	0, 1, cr0, cr10, cr0, {0}
     ce0:	03193f01 	tsteq	r9, #1, 30
     ce4:	3b0b3a0e 	blcc	2cf524 <_bss_end+0x2c3828>
     ce8:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     cec:	64193c0e 	ldrvs	r3, [r9], #-3086	; 0xfffff3f2
     cf0:	00130113 	andseq	r0, r3, r3, lsl r1
     cf4:	012e1b00 			; <UNDEFINED> instruction: 0x012e1b00
     cf8:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     cfc:	0b3b0b3a 	bleq	ec39ec <_bss_end+0xeb7cf0>
     d00:	0e6e0b39 	vmoveq.8	d14[5], r0
     d04:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
     d08:	13011364 	movwne	r1, #4964	; 0x1364
     d0c:	391c0000 	ldmdbcc	ip, {}	; <UNPREDICTABLE>
     d10:	3a080301 	bcc	20191c <_bss_end+0x1f5c20>
     d14:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     d18:	0013010b 	andseq	r0, r3, fp, lsl #2
     d1c:	00341d00 	eorseq	r1, r4, r0, lsl #26
     d20:	0b3a0e03 	bleq	e84534 <_bss_end+0xe78838>
     d24:	0b390b3b 	bleq	e43a18 <_bss_end+0xe37d1c>
     d28:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
     d2c:	196c061c 	stmdbne	ip!, {r2, r3, r4, r9, sl}^
     d30:	341e0000 	ldrcc	r0, [lr], #-0
     d34:	3a0e0300 	bcc	38193c <_bss_end+0x375c40>
     d38:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     d3c:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
     d40:	6c0b1c19 	stcvs	12, cr1, [fp], {25}
     d44:	1f000019 	svcne	0x00000019
     d48:	0e030104 	adfeqs	f0, f3, f4
     d4c:	0b3e196d 	bleq	f87308 <_bss_end+0xf7b60c>
     d50:	13490b0b 	movtne	r0, #39691	; 0x9b0b
     d54:	0b3b0b3a 	bleq	ec3a44 <_bss_end+0xeb7d48>
     d58:	00000b39 	andeq	r0, r0, r9, lsr fp
     d5c:	47003420 	strmi	r3, [r0, -r0, lsr #8]
     d60:	21000013 	tstcs	r0, r3, lsl r0
     d64:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
     d68:	0b3b0b3a 	bleq	ec3a58 <_bss_end+0xeb7d5c>
     d6c:	13490b39 	movtne	r0, #39737	; 0x9b39
     d70:	00000b32 	andeq	r0, r0, r2, lsr fp
     d74:	00001522 	andeq	r1, r0, r2, lsr #10
     d78:	012e2300 			; <UNDEFINED> instruction: 0x012e2300
     d7c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     d80:	0b3b0b3a 	bleq	ec3a70 <_bss_end+0xeb7d74>
     d84:	0e6e0b39 	vmoveq.8	d14[5], r0
     d88:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
     d8c:	00001364 	andeq	r1, r0, r4, ror #6
     d90:	03003424 	movweq	r3, #1060	; 0x424
     d94:	3b0b3a0e 	blcc	2cf5d4 <_bss_end+0x2c38d8>
     d98:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     d9c:	1c193c13 	ldcne	12, cr3, [r9], {19}
     da0:	00196c05 	andseq	r6, r9, r5, lsl #24
     da4:	000f2500 	andeq	r2, pc, r0, lsl #10
     da8:	00000b0b 	andeq	r0, r0, fp, lsl #22
     dac:	03003426 	movweq	r3, #1062	; 0x426
     db0:	3b0b3a0e 	blcc	2cf5f0 <_bss_end+0x2c38f4>
     db4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     db8:	02193f13 	andseq	r3, r9, #19, 30	; 0x4c
     dbc:	27000018 	smladcs	r0, r8, r0, r0
     dc0:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
     dc4:	0b3b0b3a 	bleq	ec3ab4 <_bss_end+0xeb7db8>
     dc8:	13490b39 	movtne	r0, #39737	; 0x9b39
     dcc:	1802196c 	stmdane	r2, {r2, r3, r5, r6, r8, fp, ip}
     dd0:	2e280000 	cdpcs	0, 2, cr0, cr8, cr0, {0}
     dd4:	03193f00 	tsteq	r9, #0, 30
     dd8:	3b0b3a0e 	blcc	2cf618 <_bss_end+0x2c391c>
     ddc:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     de0:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
     de4:	96184006 	ldrls	r4, [r8], -r6
     de8:	00001942 	andeq	r1, r0, r2, asr #18
     dec:	3f012e29 	svccc	0x00012e29
     df0:	3a0e0319 	bcc	381a5c <_bss_end+0x375d60>
     df4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     df8:	1201110b 	andne	r1, r1, #-1073741822	; 0xc0000002
     dfc:	96184006 	ldrls	r4, [r8], -r6
     e00:	13011942 	movwne	r1, #6466	; 0x1942
     e04:	342a0000 	strtcc	r0, [sl], #-0
     e08:	3a080300 	bcc	201a10 <_bss_end+0x1f5d14>
     e0c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     e10:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
     e14:	2b000018 	blcs	e7c <CPSR_IRQ_INHIBIT+0xdfc>
     e18:	193f002e 	ldmdbne	pc!, {r1, r2, r3, r5}	; <UNPREDICTABLE>
     e1c:	0b3a0e03 	bleq	e84630 <_bss_end+0xe78934>
     e20:	0b390b3b 	bleq	e43b14 <_bss_end+0xe37e18>
     e24:	06120111 			; <UNDEFINED> instruction: 0x06120111
     e28:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
     e2c:	00000019 	andeq	r0, r0, r9, lsl r0
     e30:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
     e34:	030b130e 	movweq	r1, #45838	; 0xb30e
     e38:	110e1b0e 	tstne	lr, lr, lsl #22
     e3c:	10061201 	andne	r1, r6, r1, lsl #4
     e40:	02000017 	andeq	r0, r0, #23
     e44:	0b0b0024 	bleq	2c0edc <_bss_end+0x2b51e0>
     e48:	0e030b3e 	vmoveq.16	d3[0], r0
     e4c:	24030000 	strcs	r0, [r3], #-0
     e50:	3e0b0b00 	vmlacc.f64	d0, d11, d0
     e54:	0008030b 	andeq	r0, r8, fp, lsl #6
     e58:	00160400 	andseq	r0, r6, r0, lsl #8
     e5c:	0b3a0e03 	bleq	e84670 <_bss_end+0xe78974>
     e60:	0b390b3b 	bleq	e43b54 <_bss_end+0xe37e58>
     e64:	00001349 	andeq	r1, r0, r9, asr #6
     e68:	49002605 	stmdbmi	r0, {r0, r2, r9, sl, sp}
     e6c:	06000013 			; <UNDEFINED> instruction: 0x06000013
     e70:	0e030113 	mcreq	1, 0, r0, cr3, cr3, {0}
     e74:	0b3a0b0b 	bleq	e83aa8 <_bss_end+0xe77dac>
     e78:	0b390b3b 	bleq	e43b6c <_bss_end+0xe37e70>
     e7c:	00001301 	andeq	r1, r0, r1, lsl #6
     e80:	03000d07 	movweq	r0, #3335	; 0xd07
     e84:	3b0b3a0e 	blcc	2cf6c4 <_bss_end+0x2c39c8>
     e88:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     e8c:	000b3813 	andeq	r3, fp, r3, lsl r8
     e90:	000f0800 	andeq	r0, pc, r0, lsl #16
     e94:	13490b0b 	movtne	r0, #39691	; 0x9b0b
     e98:	02090000 	andeq	r0, r9, #0
     e9c:	0b0e0301 	bleq	381aa8 <_bss_end+0x375dac>
     ea0:	3b0b3a0b 	blcc	2cf6d4 <_bss_end+0x2c39d8>
     ea4:	010b390b 	tsteq	fp, fp, lsl #18
     ea8:	0a000013 	beq	efc <CPSR_IRQ_INHIBIT+0xe7c>
     eac:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
     eb0:	0b3a0e03 	bleq	e846c4 <_bss_end+0xe789c8>
     eb4:	0b390b3b 	bleq	e43ba8 <_bss_end+0xe37eac>
     eb8:	13490e6e 	movtne	r0, #40558	; 0x9e6e
     ebc:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
     ec0:	00001301 	andeq	r1, r0, r1, lsl #6
     ec4:	4900050b 	stmdbmi	r0, {r0, r1, r3, r8, sl}
     ec8:	00193413 	andseq	r3, r9, r3, lsl r4
     ecc:	012e0c00 			; <UNDEFINED> instruction: 0x012e0c00
     ed0:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     ed4:	0b3b0b3a 	bleq	ec3bc4 <_bss_end+0xeb7ec8>
     ed8:	0e6e0b39 	vmoveq.8	d14[5], r0
     edc:	0b321349 	bleq	c85c08 <_bss_end+0xc79f0c>
     ee0:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
     ee4:	00001301 	andeq	r1, r0, r1, lsl #6
     ee8:	4900050d 	stmdbmi	r0, {r0, r2, r3, r8, sl}
     eec:	0e000013 	mcreq	0, 0, r0, cr0, cr3, {0}
     ef0:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
     ef4:	0b3a0e03 	bleq	e84708 <_bss_end+0xe78a0c>
     ef8:	0b390b3b 	bleq	e43bec <_bss_end+0xe37ef0>
     efc:	0b320e6e 	bleq	c848bc <_bss_end+0xc78bc0>
     f00:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
     f04:	0f0f0000 	svceq	0x000f0000
     f08:	000b0b00 	andeq	r0, fp, r0, lsl #22
     f0c:	00341000 	eorseq	r1, r4, r0
     f10:	0b3a0e03 	bleq	e84724 <_bss_end+0xe78a28>
     f14:	0b390b3b 	bleq	e43c08 <_bss_end+0xe37f0c>
     f18:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
     f1c:	0000193c 	andeq	r1, r0, ip, lsr r9
     f20:	03013911 	movweq	r3, #6417	; 0x1911
     f24:	3b0b3a08 	blcc	2cf74c <_bss_end+0x2c3a50>
     f28:	010b390b 	tsteq	fp, fp, lsl #18
     f2c:	12000013 	andne	r0, r0, #19
     f30:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
     f34:	0b3b0b3a 	bleq	ec3c24 <_bss_end+0xeb7f28>
     f38:	13490b39 	movtne	r0, #39737	; 0x9b39
     f3c:	061c193c 			; <UNDEFINED> instruction: 0x061c193c
     f40:	0000196c 	andeq	r1, r0, ip, ror #18
     f44:	03003413 	movweq	r3, #1043	; 0x413
     f48:	3b0b3a0e 	blcc	2cf788 <_bss_end+0x2c3a8c>
     f4c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     f50:	1c193c13 	ldcne	12, cr3, [r9], {19}
     f54:	00196c0b 	andseq	r6, r9, fp, lsl #24
     f58:	00341400 	eorseq	r1, r4, r0, lsl #8
     f5c:	00001347 	andeq	r1, r0, r7, asr #6
     f60:	03003415 	movweq	r3, #1045	; 0x415
     f64:	3b0b3a0e 	blcc	2cf7a4 <_bss_end+0x2c3aa8>
     f68:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     f6c:	1c193c13 	ldcne	12, cr3, [r9], {19}
     f70:	00196c05 	andseq	r6, r9, r5, lsl #24
     f74:	01021600 	tsteq	r2, r0, lsl #12
     f78:	050b0e03 	streq	r0, [fp, #-3587]	; 0xfffff1fd
     f7c:	0b3b0b3a 	bleq	ec3c6c <_bss_end+0xeb7f70>
     f80:	13010b39 	movwne	r0, #6969	; 0x1b39
     f84:	2e170000 	cdpcs	0, 1, cr0, cr7, cr0, {0}
     f88:	03193f01 	tsteq	r9, #1, 30
     f8c:	3b0b3a0e 	blcc	2cf7cc <_bss_end+0x2c3ad0>
     f90:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     f94:	64193c0e 	ldrvs	r3, [r9], #-3086	; 0xfffff3f2
     f98:	00130113 	andseq	r0, r3, r3, lsl r1
     f9c:	01011800 	tsteq	r1, r0, lsl #16
     fa0:	13011349 	movwne	r1, #4937	; 0x1349
     fa4:	21190000 	tstcs	r9, r0
     fa8:	2f134900 	svccs	0x00134900
     fac:	1a000005 	bne	fc8 <CPSR_IRQ_INHIBIT+0xf48>
     fb0:	13470034 	movtne	r0, #28724	; 0x7034
     fb4:	0b3b0b3a 	bleq	ec3ca4 <_bss_end+0xeb7fa8>
     fb8:	18020b39 	stmdane	r2, {r0, r3, r4, r5, r8, r9, fp}
     fbc:	2e1b0000 	cdpcs	0, 1, cr0, cr11, cr0, {0}
     fc0:	340e0300 	strcc	r0, [lr], #-768	; 0xfffffd00
     fc4:	12011119 	andne	r1, r1, #1073741830	; 0x40000006
     fc8:	96184006 	ldrls	r4, [r8], -r6
     fcc:	00001942 	andeq	r1, r0, r2, asr #18
     fd0:	03012e1c 	movweq	r2, #7708	; 0x1e1c
     fd4:	1119340e 	tstne	r9, lr, lsl #8
     fd8:	40061201 	andmi	r1, r6, r1, lsl #4
     fdc:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
     fe0:	00001301 	andeq	r1, r0, r1, lsl #6
     fe4:	0300051d 	movweq	r0, #1309	; 0x51d
     fe8:	3b0b3a0e 	blcc	2cf828 <_bss_end+0x2c3b2c>
     fec:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     ff0:	00180213 	andseq	r0, r8, r3, lsl r2
     ff4:	012e1e00 			; <UNDEFINED> instruction: 0x012e1e00
     ff8:	0b3a1347 	bleq	e85d1c <_bss_end+0xe7a020>
     ffc:	0b390b3b 	bleq	e43cf0 <_bss_end+0xe37ff4>
    1000:	01111364 	tsteq	r1, r4, ror #6
    1004:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
    1008:	01194297 			; <UNDEFINED> instruction: 0x01194297
    100c:	1f000013 	svcne	0x00000013
    1010:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
    1014:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
    1018:	00001802 	andeq	r1, r0, r2, lsl #16
    101c:	03000520 	movweq	r0, #1312	; 0x520
    1020:	3b0b3a08 	blcc	2cf848 <_bss_end+0x2c3b4c>
    1024:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
    1028:	00180213 	andseq	r0, r8, r3, lsl r2
    102c:	00342100 	eorseq	r2, r4, r0, lsl #2
    1030:	0b3a0e03 	bleq	e84844 <_bss_end+0xe78b48>
    1034:	0b390b3b 	bleq	e43d28 <_bss_end+0xe3802c>
    1038:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
    103c:	2e220000 	cdpcs	0, 2, cr0, cr2, cr0, {0}
    1040:	3a134701 	bcc	4d2c4c <_bss_end+0x4c6f50>
    1044:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    1048:	1113640b 	tstne	r3, fp, lsl #8
    104c:	40061201 	andmi	r1, r6, r1, lsl #4
    1050:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
    1054:	00001301 	andeq	r1, r0, r1, lsl #6
    1058:	47012e23 	strmi	r2, [r1, -r3, lsr #28]
    105c:	3b0b3a13 	blcc	2cf8b0 <_bss_end+0x2c3bb4>
    1060:	640b390b 	strvs	r3, [fp], #-2315	; 0xfffff6f5
    1064:	010b2013 	tsteq	fp, r3, lsl r0
    1068:	24000013 	strcs	r0, [r0], #-19	; 0xffffffed
    106c:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
    1070:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
    1074:	2e250000 	cdpcs	0, 2, cr0, cr5, cr0, {0}
    1078:	6e133101 	mufvss	f3, f3, f1
    107c:	1113640e 	tstne	r3, lr, lsl #8
    1080:	40061201 	andmi	r1, r6, r1, lsl #4
    1084:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
    1088:	05260000 	streq	r0, [r6, #-0]!
    108c:	02133100 	andseq	r3, r3, #0, 2
    1090:	00000018 	andeq	r0, r0, r8, lsl r0
    1094:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
    1098:	030b130e 	movweq	r1, #45838	; 0xb30e
    109c:	110e1b0e 	tstne	lr, lr, lsl #22
    10a0:	10061201 	andne	r1, r6, r1, lsl #4
    10a4:	02000017 	andeq	r0, r0, #23
    10a8:	0b0b0024 	bleq	2c1140 <_bss_end+0x2b5444>
    10ac:	0e030b3e 	vmoveq.16	d3[0], r0
    10b0:	24030000 	strcs	r0, [r3], #-0
    10b4:	3e0b0b00 	vmlacc.f64	d0, d11, d0
    10b8:	0008030b 	andeq	r0, r8, fp, lsl #6
    10bc:	00160400 	andseq	r0, r6, r0, lsl #8
    10c0:	0b3a0e03 	bleq	e848d4 <_bss_end+0xe78bd8>
    10c4:	0b390b3b 	bleq	e43db8 <_bss_end+0xe380bc>
    10c8:	00001349 	andeq	r1, r0, r9, asr #6
    10cc:	49002605 	stmdbmi	r0, {r0, r2, r9, sl, sp}
    10d0:	06000013 			; <UNDEFINED> instruction: 0x06000013
    10d4:	08030139 	stmdaeq	r3, {r0, r3, r4, r5, r8}
    10d8:	0b3b0b3a 	bleq	ec3dc8 <_bss_end+0xeb80cc>
    10dc:	13010b39 	movwne	r0, #6969	; 0x1b39
    10e0:	34070000 	strcc	r0, [r7], #-0
    10e4:	3a0e0300 	bcc	381cec <_bss_end+0x375ff0>
    10e8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    10ec:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
    10f0:	6c061c19 	stcvs	12, cr1, [r6], {25}
    10f4:	08000019 	stmdaeq	r0, {r0, r3, r4}
    10f8:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
    10fc:	0b3b0b3a 	bleq	ec3dec <_bss_end+0xeb80f0>
    1100:	13490b39 	movtne	r0, #39737	; 0x9b39
    1104:	0b1c193c 	bleq	7075fc <_bss_end+0x6fb900>
    1108:	0000196c 	andeq	r1, r0, ip, ror #18
    110c:	47003409 	strmi	r3, [r0, -r9, lsl #8]
    1110:	0a000013 	beq	1164 <CPSR_IRQ_INHIBIT+0x10e4>
    1114:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
    1118:	0b3b0b3a 	bleq	ec3e08 <_bss_end+0xeb810c>
    111c:	13490b39 	movtne	r0, #39737	; 0x9b39
    1120:	051c193c 	ldreq	r1, [ip, #-2364]	; 0xfffff6c4
    1124:	0000196c 	andeq	r1, r0, ip, ror #18
    1128:	0301020b 	movweq	r0, #4619	; 0x120b
    112c:	3a050b0e 	bcc	143d6c <_bss_end+0x138070>
    1130:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    1134:	0013010b 	andseq	r0, r3, fp, lsl #2
    1138:	000d0c00 	andeq	r0, sp, r0, lsl #24
    113c:	0b3a0e03 	bleq	e84950 <_bss_end+0xe78c54>
    1140:	0b390b3b 	bleq	e43e34 <_bss_end+0xe38138>
    1144:	0b381349 	bleq	e05e70 <_bss_end+0xdfa174>
    1148:	2e0d0000 	cdpcs	0, 0, cr0, cr13, cr0, {0}
    114c:	03193f01 	tsteq	r9, #1, 30
    1150:	3b0b3a0e 	blcc	2cf990 <_bss_end+0x2c3c94>
    1154:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
    1158:	64193c0e 	ldrvs	r3, [r9], #-3086	; 0xfffff3f2
    115c:	00130113 	andseq	r0, r3, r3, lsl r1
    1160:	00050e00 	andeq	r0, r5, r0, lsl #28
    1164:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
    1168:	050f0000 	streq	r0, [pc, #-0]	; 1170 <CPSR_IRQ_INHIBIT+0x10f0>
    116c:	00134900 	andseq	r4, r3, r0, lsl #18
    1170:	012e1000 			; <UNDEFINED> instruction: 0x012e1000
    1174:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
    1178:	0b3b0b3a 	bleq	ec3e68 <_bss_end+0xeb816c>
    117c:	0e6e0b39 	vmoveq.8	d14[5], r0
    1180:	0b321349 	bleq	c85eac <_bss_end+0xc7a1b0>
    1184:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
    1188:	00001301 	andeq	r1, r0, r1, lsl #6
    118c:	3f012e11 	svccc	0x00012e11
    1190:	3a0e0319 	bcc	381dfc <_bss_end+0x376100>
    1194:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    1198:	320e6e0b 	andcc	r6, lr, #11, 28	; 0xb0
    119c:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
    11a0:	12000013 	andne	r0, r0, #19
    11a4:	13490101 	movtne	r0, #37121	; 0x9101
    11a8:	00001301 	andeq	r1, r0, r1, lsl #6
    11ac:	49002113 	stmdbmi	r0, {r0, r1, r4, r8, sp}
    11b0:	00052f13 	andeq	r2, r5, r3, lsl pc
    11b4:	000f1400 	andeq	r1, pc, r0, lsl #8
    11b8:	13490b0b 	movtne	r0, #39691	; 0x9b0b
    11bc:	34150000 	ldrcc	r0, [r5], #-0
    11c0:	3a0e0300 	bcc	381dc8 <_bss_end+0x3760cc>
    11c4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    11c8:	3f13490b 	svccc	0x0013490b
    11cc:	00193c19 	andseq	r3, r9, r9, lsl ip
    11d0:	00341600 	eorseq	r1, r4, r0, lsl #12
    11d4:	0b3a1347 	bleq	e85ef8 <_bss_end+0xe7a1fc>
    11d8:	0b390b3b 	bleq	e43ecc <_bss_end+0xe381d0>
    11dc:	00001802 	andeq	r1, r0, r2, lsl #16
    11e0:	03002e17 	movweq	r2, #3607	; 0xe17
    11e4:	1119340e 	tstne	r9, lr, lsl #8
    11e8:	40061201 	andmi	r1, r6, r1, lsl #4
    11ec:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
    11f0:	2e180000 	cdpcs	0, 1, cr0, cr8, cr0, {0}
    11f4:	340e0301 	strcc	r0, [lr], #-769	; 0xfffffcff
    11f8:	12011119 	andne	r1, r1, #1073741830	; 0x40000006
    11fc:	96184006 	ldrls	r4, [r8], -r6
    1200:	13011942 	movwne	r1, #6466	; 0x1942
    1204:	05190000 	ldreq	r0, [r9, #-0]
    1208:	3a0e0300 	bcc	381e10 <_bss_end+0x376114>
    120c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    1210:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
    1214:	1a000018 	bne	127c <CPSR_IRQ_INHIBIT+0x11fc>
    1218:	1347012e 	movtne	r0, #28974	; 0x712e
    121c:	0b3b0b3a 	bleq	ec3f0c <_bss_end+0xeb8210>
    1220:	13640b39 	cmnne	r4, #58368	; 0xe400
    1224:	06120111 			; <UNDEFINED> instruction: 0x06120111
    1228:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
    122c:	00130119 	andseq	r0, r3, r9, lsl r1
    1230:	00051b00 	andeq	r1, r5, r0, lsl #22
    1234:	13490e03 	movtne	r0, #40451	; 0x9e03
    1238:	18021934 	stmdane	r2, {r2, r4, r5, r8, fp, ip}
    123c:	051c0000 	ldreq	r0, [ip, #-0]
    1240:	3a080300 	bcc	201e48 <_bss_end+0x1f614c>
    1244:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    1248:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
    124c:	1d000018 	stcne	0, cr0, [r0, #-96]	; 0xffffffa0
    1250:	08030034 	stmdaeq	r3, {r2, r4, r5}
    1254:	0b3b0b3a 	bleq	ec3f44 <_bss_end+0xeb8248>
    1258:	13490b39 	movtne	r0, #39737	; 0x9b39
    125c:	00001802 	andeq	r1, r0, r2, lsl #16
    1260:	11010b1e 	tstne	r1, lr, lsl fp
    1264:	00061201 	andeq	r1, r6, r1, lsl #4
    1268:	00341f00 	eorseq	r1, r4, r0, lsl #30
    126c:	0b3a0e03 	bleq	e84a80 <_bss_end+0xe78d84>
    1270:	0b390b3b 	bleq	e43f64 <_bss_end+0xe38268>
    1274:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
    1278:	2e200000 	cdpcs	0, 2, cr0, cr0, cr0, {0}
    127c:	3a134701 	bcc	4d2e88 <_bss_end+0x4c718c>
    1280:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    1284:	2013640b 	andscs	r6, r3, fp, lsl #8
    1288:	0013010b 	andseq	r0, r3, fp, lsl #2
    128c:	00052100 	andeq	r2, r5, r0, lsl #2
    1290:	13490e03 	movtne	r0, #40451	; 0x9e03
    1294:	00001934 	andeq	r1, r0, r4, lsr r9
    1298:	00010b22 	andeq	r0, r1, r2, lsr #22
    129c:	00342300 	eorseq	r2, r4, r0, lsl #6
    12a0:	0b3a0803 	bleq	e832b4 <_bss_end+0xe775b8>
    12a4:	0b390b3b 	bleq	e43f98 <_bss_end+0xe3829c>
    12a8:	00001349 	andeq	r1, r0, r9, asr #6
    12ac:	31012e24 	tstcc	r1, r4, lsr #28
    12b0:	640e6e13 	strvs	r6, [lr], #-3603	; 0xfffff1ed
    12b4:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
    12b8:	97184006 	ldrls	r4, [r8, -r6]
    12bc:	13011942 	movwne	r1, #6466	; 0x1942
    12c0:	05250000 	streq	r0, [r5, #-0]!
    12c4:	02133100 	andseq	r3, r3, #0, 2
    12c8:	26000018 			; <UNDEFINED> instruction: 0x26000018
    12cc:	1331010b 	teqne	r1, #-1073741822	; 0xc0000002
    12d0:	00001301 	andeq	r1, r0, r1, lsl #6
    12d4:	31003427 	tstcc	r0, r7, lsr #8
    12d8:	28000013 	stmdacs	r0, {r0, r1, r4}
    12dc:	1331010b 	teqne	r1, #-1073741822	; 0xc0000002
    12e0:	06120111 			; <UNDEFINED> instruction: 0x06120111
    12e4:	34290000 	strtcc	r0, [r9], #-0
    12e8:	02133100 	andseq	r3, r3, #0, 2
    12ec:	2a000018 	bcs	1354 <CPSR_IRQ_INHIBIT+0x12d4>
    12f0:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
    12f4:	0b3a0e03 	bleq	e84b08 <_bss_end+0xe78e0c>
    12f8:	0b390b3b 	bleq	e43fec <_bss_end+0xe382f0>
    12fc:	13490e6e 	movtne	r0, #40558	; 0x9e6e
    1300:	06120111 			; <UNDEFINED> instruction: 0x06120111
    1304:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
    1308:	00130119 	andseq	r0, r3, r9, lsl r1
    130c:	012e2b00 			; <UNDEFINED> instruction: 0x012e2b00
    1310:	0b3a0e03 	bleq	e84b24 <_bss_end+0xe78e28>
    1314:	0b390b3b 	bleq	e44008 <_bss_end+0xe3830c>
    1318:	01111349 	tsteq	r1, r9, asr #6
    131c:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
    1320:	00194297 	mulseq	r9, r7, r2
    1324:	11010000 	mrsne	r0, (UNDEF: 1)
    1328:	130e2501 	movwne	r2, #58625	; 0xe501
    132c:	1b0e030b 	blne	381f60 <_bss_end+0x376264>
    1330:	1117550e 	tstne	r7, lr, lsl #10
    1334:	00171001 	andseq	r1, r7, r1
    1338:	00240200 	eoreq	r0, r4, r0, lsl #4
    133c:	0b3e0b0b 	bleq	f83f70 <_bss_end+0xf78274>
    1340:	00000e03 	andeq	r0, r0, r3, lsl #28
    1344:	49002603 	stmdbmi	r0, {r0, r1, r9, sl, sp}
    1348:	04000013 	streq	r0, [r0], #-19	; 0xffffffed
    134c:	0b0b0024 	bleq	2c13e4 <_bss_end+0x2b56e8>
    1350:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
    1354:	16050000 	strne	r0, [r5], -r0
    1358:	3a0e0300 	bcc	381f60 <_bss_end+0x376264>
    135c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    1360:	0013490b 	andseq	r4, r3, fp, lsl #18
    1364:	00350600 	eorseq	r0, r5, r0, lsl #12
    1368:	00001349 	andeq	r1, r0, r9, asr #6
    136c:	03010407 	movweq	r0, #5127	; 0x1407
    1370:	3e196d0e 	cdpcc	13, 1, cr6, cr9, cr14, {0}
    1374:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
    1378:	3b0b3a13 	blcc	2cfbcc <_bss_end+0x2c3ed0>
    137c:	010b390b 	tsteq	fp, fp, lsl #18
    1380:	08000013 	stmdaeq	r0, {r0, r1, r4}
    1384:	08030028 	stmdaeq	r3, {r3, r5}
    1388:	00000b1c 	andeq	r0, r0, ip, lsl fp
    138c:	03002809 	movweq	r2, #2057	; 0x809
    1390:	000b1c0e 	andeq	r1, fp, lr, lsl #24
    1394:	01130a00 	tsteq	r3, r0, lsl #20
    1398:	0b0b0e03 	bleq	2c4bac <_bss_end+0x2b8eb0>
    139c:	0b3b0b3a 	bleq	ec408c <_bss_end+0xeb8390>
    13a0:	13010b39 	movwne	r0, #6969	; 0x1b39
    13a4:	0d0b0000 	stceq	0, cr0, [fp, #-0]
    13a8:	3a080300 	bcc	201fb0 <_bss_end+0x1f62b4>
    13ac:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    13b0:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
    13b4:	0c00000b 	stceq	0, cr0, [r0], {11}
    13b8:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
    13bc:	0b3b0b3a 	bleq	ec40ac <_bss_end+0xeb83b0>
    13c0:	13490b39 	movtne	r0, #39737	; 0x9b39
    13c4:	00000b38 	andeq	r0, r0, r8, lsr fp
    13c8:	0b000f0d 	bleq	5004 <CPSR_IRQ_INHIBIT+0x4f84>
    13cc:	0013490b 	andseq	r4, r3, fp, lsl #18
    13d0:	01020e00 	tsteq	r2, r0, lsl #28
    13d4:	0b0b0e03 	bleq	2c4be8 <_bss_end+0x2b8eec>
    13d8:	0b3b0b3a 	bleq	ec40c8 <_bss_end+0xeb83cc>
    13dc:	13010b39 	movwne	r0, #6969	; 0x1b39
    13e0:	2e0f0000 	cdpcs	0, 0, cr0, cr15, cr0, {0}
    13e4:	03193f01 	tsteq	r9, #1, 30
    13e8:	3b0b3a0e 	blcc	2cfc28 <_bss_end+0x2c3f2c>
    13ec:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
    13f0:	64193c0e 	ldrvs	r3, [r9], #-3086	; 0xfffff3f2
    13f4:	00130113 	andseq	r0, r3, r3, lsl r1
    13f8:	00051000 	andeq	r1, r5, r0
    13fc:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
    1400:	05110000 	ldreq	r0, [r1, #-0]
    1404:	00134900 	andseq	r4, r3, r0, lsl #18
    1408:	012e1200 			; <UNDEFINED> instruction: 0x012e1200
    140c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
    1410:	0b3b0b3a 	bleq	ec4100 <_bss_end+0xeb8404>
    1414:	0e6e0b39 	vmoveq.8	d14[5], r0
    1418:	0b321349 	bleq	c86144 <_bss_end+0xc7a448>
    141c:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
    1420:	00001301 	andeq	r1, r0, r1, lsl #6
    1424:	3f012e13 	svccc	0x00012e13
    1428:	3a0e0319 	bcc	382094 <_bss_end+0x376398>
    142c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    1430:	320e6e0b 	andcc	r6, lr, #11, 28	; 0xb0
    1434:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
    1438:	00130113 	andseq	r0, r3, r3, lsl r1
    143c:	012e1400 			; <UNDEFINED> instruction: 0x012e1400
    1440:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
    1444:	0b3b0b3a 	bleq	ec4134 <_bss_end+0xeb8438>
    1448:	0e6e0b39 	vmoveq.8	d14[5], r0
    144c:	0b321349 	bleq	c86178 <_bss_end+0xc7a47c>
    1450:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
    1454:	34150000 	ldrcc	r0, [r5], #-0
    1458:	3a0e0300 	bcc	382060 <_bss_end+0x376364>
    145c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    1460:	3f13490b 	svccc	0x0013490b
    1464:	00193c19 	andseq	r3, r9, r9, lsl ip
    1468:	01041600 	tsteq	r4, r0, lsl #12
    146c:	196d0e03 	stmdbne	sp!, {r0, r1, r9, sl, fp}^
    1470:	0b0b0b3e 	bleq	2c4170 <_bss_end+0x2b8474>
    1474:	0b3a1349 	bleq	e861a0 <_bss_end+0xe7a4a4>
    1478:	0b390b3b 	bleq	e4416c <_bss_end+0xe38470>
    147c:	13010b32 	movwne	r0, #6962	; 0x1b32
    1480:	0d170000 	ldceq	0, cr0, [r7, #-0]
    1484:	3a0e0300 	bcc	38208c <_bss_end+0x376390>
    1488:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    148c:	3f13490b 	svccc	0x0013490b
    1490:	3c0b3219 	sfmcc	f3, 4, [fp], {25}
    1494:	6c0b1c19 	stcvs	12, cr1, [fp], {25}
    1498:	18000019 	stmdane	r0, {r0, r3, r4}
    149c:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
    14a0:	0b3b0b3a 	bleq	ec4190 <_bss_end+0xeb8494>
    14a4:	13490b39 	movtne	r0, #39737	; 0x9b39
    14a8:	0b32193f 	bleq	c879ac <_bss_end+0xc7bcb0>
    14ac:	196c193c 	stmdbne	ip!, {r2, r3, r4, r5, r8, fp, ip}^
    14b0:	2e190000 	cdpcs	0, 1, cr0, cr9, cr0, {0}
    14b4:	03193f01 	tsteq	r9, #1, 30
    14b8:	3b0b3a0e 	blcc	2cfcf8 <_bss_end+0x2c3ffc>
    14bc:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
    14c0:	3213490e 	andscc	r4, r3, #229376	; 0x38000
    14c4:	63193c0b 	tstvs	r9, #2816	; 0xb00
    14c8:	01136419 	tsteq	r3, r9, lsl r4
    14cc:	1a000013 	bne	1520 <CPSR_IRQ_INHIBIT+0x14a0>
    14d0:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
    14d4:	0b3a0e03 	bleq	e84ce8 <_bss_end+0xe78fec>
    14d8:	0b390b3b 	bleq	e441cc <_bss_end+0xe384d0>
    14dc:	13490e6e 	movtne	r0, #40558	; 0x9e6e
    14e0:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
    14e4:	00001301 	andeq	r1, r0, r1, lsl #6
    14e8:	0b00101b 	bleq	555c <CPSR_IRQ_INHIBIT+0x54dc>
    14ec:	0013490b 	andseq	r4, r3, fp, lsl #18
    14f0:	002f1c00 	eoreq	r1, pc, r0, lsl #24
    14f4:	13490803 	movtne	r0, #38915	; 0x9803
    14f8:	0f1d0000 	svceq	0x001d0000
    14fc:	000b0b00 	andeq	r0, fp, r0, lsl #22
    1500:	01391e00 	teqeq	r9, r0, lsl #28
    1504:	0b3a0803 	bleq	e83518 <_bss_end+0xe7781c>
    1508:	0b390b3b 	bleq	e441fc <_bss_end+0xe38500>
    150c:	00001301 	andeq	r1, r0, r1, lsl #6
    1510:	0300341f 	movweq	r3, #1055	; 0x41f
    1514:	3b0b3a0e 	blcc	2cfd54 <_bss_end+0x2c4058>
    1518:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
    151c:	1c193c13 	ldcne	12, cr3, [r9], {19}
    1520:	00196c06 	andseq	r6, r9, r6, lsl #24
    1524:	00342000 	eorseq	r2, r4, r0
    1528:	0b3a0e03 	bleq	e84d3c <_bss_end+0xe79040>
    152c:	0b390b3b 	bleq	e44220 <_bss_end+0xe38524>
    1530:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
    1534:	196c0b1c 	stmdbne	ip!, {r2, r3, r4, r8, r9, fp}^
    1538:	34210000 	strtcc	r0, [r1], #-0
    153c:	00134700 	andseq	r4, r3, r0, lsl #14
    1540:	00342200 	eorseq	r2, r4, r0, lsl #4
    1544:	0b3a0e03 	bleq	e84d58 <_bss_end+0xe7905c>
    1548:	0b390b3b 	bleq	e4423c <_bss_end+0xe38540>
    154c:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
    1550:	196c051c 	stmdbne	ip!, {r2, r3, r4, r8, sl}^
    1554:	02230000 	eoreq	r0, r3, #0
    1558:	0b0e0301 	bleq	382164 <_bss_end+0x376468>
    155c:	3b0b3a05 	blcc	2cfd78 <_bss_end+0x2c407c>
    1560:	010b390b 	tsteq	fp, fp, lsl #18
    1564:	24000013 	strcs	r0, [r0], #-19	; 0xffffffed
    1568:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
    156c:	0b3a0e03 	bleq	e84d80 <_bss_end+0xe79084>
    1570:	0b390b3b 	bleq	e44264 <_bss_end+0xe38568>
    1574:	0b320e6e 	bleq	c84f34 <_bss_end+0xc79238>
    1578:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
    157c:	01250000 			; <UNDEFINED> instruction: 0x01250000
    1580:	01134901 	tsteq	r3, r1, lsl #18
    1584:	26000013 			; <UNDEFINED> instruction: 0x26000013
    1588:	13490021 	movtne	r0, #36897	; 0x9021
    158c:	0000052f 	andeq	r0, r0, pc, lsr #10
    1590:	47003427 	strmi	r3, [r0, -r7, lsr #8]
    1594:	3b0b3a13 	blcc	2cfde8 <_bss_end+0x2c40ec>
    1598:	020b390b 	andeq	r3, fp, #180224	; 0x2c000
    159c:	28000018 	stmdacs	r0, {r3, r4}
    15a0:	0e03002e 	cdpeq	0, 0, cr0, cr3, cr14, {1}
    15a4:	01111934 	tsteq	r1, r4, lsr r9
    15a8:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
    15ac:	00194296 	mulseq	r9, r6, r2
    15b0:	012e2900 			; <UNDEFINED> instruction: 0x012e2900
    15b4:	19340e03 	ldmdbne	r4!, {r0, r1, r9, sl, fp}
    15b8:	06120111 			; <UNDEFINED> instruction: 0x06120111
    15bc:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
    15c0:	00130119 	andseq	r0, r3, r9, lsl r1
    15c4:	00052a00 	andeq	r2, r5, r0, lsl #20
    15c8:	0b3a0e03 	bleq	e84ddc <_bss_end+0xe790e0>
    15cc:	0b390b3b 	bleq	e442c0 <_bss_end+0xe385c4>
    15d0:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
    15d4:	2e2b0000 	cdpcs	0, 2, cr0, cr11, cr0, {0}
    15d8:	64134701 	ldrvs	r4, [r3], #-1793	; 0xfffff8ff
    15dc:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
    15e0:	96184006 	ldrls	r4, [r8], -r6
    15e4:	13011942 	movwne	r1, #6466	; 0x1942
    15e8:	052c0000 	streq	r0, [ip, #-0]!
    15ec:	490e0300 	stmdbmi	lr, {r8, r9}
    15f0:	02193413 	andseq	r3, r9, #318767104	; 0x13000000
    15f4:	2d000018 	stccs	0, cr0, [r0, #-96]	; 0xffffffa0
    15f8:	1347012e 	movtne	r0, #28974	; 0x712e
    15fc:	0b3b0b3a 	bleq	ec42ec <_bss_end+0xeb85f0>
    1600:	13640b39 	cmnne	r4, #58368	; 0xe400
    1604:	06120111 			; <UNDEFINED> instruction: 0x06120111
    1608:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
    160c:	00130119 	andseq	r0, r3, r9, lsl r1
    1610:	00342e00 	eorseq	r2, r4, r0, lsl #28
    1614:	0b3a0803 	bleq	e83628 <_bss_end+0xe7792c>
    1618:	0b390b3b 	bleq	e4430c <_bss_end+0xe38610>
    161c:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
    1620:	342f0000 	strtcc	r0, [pc], #-0	; 1628 <CPSR_IRQ_INHIBIT+0x15a8>
    1624:	3a0e0300 	bcc	38222c <_bss_end+0x376530>
    1628:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    162c:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
    1630:	30000018 	andcc	r0, r0, r8, lsl r0
    1634:	1347012e 	movtne	r0, #28974	; 0x712e
    1638:	0b3b0b3a 	bleq	ec4328 <_bss_end+0xeb862c>
    163c:	13640b39 	cmnne	r4, #58368	; 0xe400
    1640:	06120111 			; <UNDEFINED> instruction: 0x06120111
    1644:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
    1648:	00130119 	andseq	r0, r3, r9, lsl r1
    164c:	012e3100 			; <UNDEFINED> instruction: 0x012e3100
    1650:	0b3a1347 	bleq	e86374 <_bss_end+0xe7a678>
    1654:	0b390b3b 	bleq	e44348 <_bss_end+0xe3864c>
    1658:	0b201364 	bleq	8063f0 <_bss_end+0x7fa6f4>
    165c:	00001301 	andeq	r1, r0, r1, lsl #6
    1660:	03000532 	movweq	r0, #1330	; 0x532
    1664:	3413490e 	ldrcc	r4, [r3], #-2318	; 0xfffff6f2
    1668:	33000019 	movwcc	r0, #25
    166c:	1331012e 	teqne	r1, #-2147483637	; 0x8000000b
    1670:	13640e6e 	cmnne	r4, #1760	; 0x6e0
    1674:	06120111 			; <UNDEFINED> instruction: 0x06120111
    1678:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
    167c:	34000019 	strcc	r0, [r0], #-25	; 0xffffffe7
    1680:	13310005 	teqne	r1, #5
    1684:	00001802 	andeq	r1, r0, r2, lsl #16
    1688:	00110100 	andseq	r0, r1, r0, lsl #2
    168c:	01110610 	tsteq	r1, r0, lsl r6
    1690:	0e030112 	mcreq	1, 0, r0, cr3, cr2, {0}
    1694:	0e250e1b 	mcreq	14, 1, r0, cr5, cr11, {0}
    1698:	00000513 	andeq	r0, r0, r3, lsl r5
    169c:	00110100 	andseq	r0, r1, r0, lsl #2
    16a0:	06550610 			; <UNDEFINED> instruction: 0x06550610
    16a4:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
    16a8:	05130e25 	ldreq	r0, [r3, #-3621]	; 0xfffff1db
    16ac:	01000000 	mrseq	r0, (UNDEF: 0)
    16b0:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
    16b4:	0e030b13 	vmoveq.32	d3[0], r0
    16b8:	01110e1b 	tsteq	r1, fp, lsl lr
    16bc:	17100612 			; <UNDEFINED> instruction: 0x17100612
    16c0:	16020000 	strne	r0, [r2], -r0
    16c4:	3a0e0300 	bcc	3822cc <_bss_end+0x3765d0>
    16c8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    16cc:	0013490b 	andseq	r4, r3, fp, lsl #18
    16d0:	000f0300 	andeq	r0, pc, r0, lsl #6
    16d4:	13490b0b 	movtne	r0, #39691	; 0x9b0b
    16d8:	15040000 	strne	r0, [r4, #-0]
    16dc:	05000000 	streq	r0, [r0, #-0]
    16e0:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
    16e4:	0b3b0b3a 	bleq	ec43d4 <_bss_end+0xeb86d8>
    16e8:	13490b39 	movtne	r0, #39737	; 0x9b39
    16ec:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
    16f0:	24060000 	strcs	r0, [r6], #-0
    16f4:	3e0b0b00 	vmlacc.f64	d0, d11, d0
    16f8:	0008030b 	andeq	r0, r8, fp, lsl #6
    16fc:	01010700 	tsteq	r1, r0, lsl #14
    1700:	13011349 	movwne	r1, #4937	; 0x1349
    1704:	21080000 	mrscs	r0, (UNDEF: 8)
    1708:	2f134900 	svccs	0x00134900
    170c:	09000006 	stmdbeq	r0, {r1, r2}
    1710:	0b0b0024 	bleq	2c17a8 <_bss_end+0x2b5aac>
    1714:	0e030b3e 	vmoveq.16	d3[0], r0
    1718:	2e0a0000 	cdpcs	0, 0, cr0, cr10, cr0, {0}
    171c:	03193f01 	tsteq	r9, #1, 30
    1720:	3b0b3a0e 	blcc	2cff60 <_bss_end+0x2c4264>
    1724:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
    1728:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
    172c:	96184006 	ldrls	r4, [r8], -r6
    1730:	13011942 	movwne	r1, #6466	; 0x1942
    1734:	340b0000 	strcc	r0, [fp], #-0
    1738:	3a0e0300 	bcc	382340 <_bss_end+0x376644>
    173c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    1740:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
    1744:	0c000018 	stceq	0, cr0, [r0], {24}
    1748:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
    174c:	0b3a0e03 	bleq	e84f60 <_bss_end+0xe79264>
    1750:	0b390b3b 	bleq	e44444 <_bss_end+0xe38748>
    1754:	01111349 	tsteq	r1, r9, asr #6
    1758:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
    175c:	01194297 			; <UNDEFINED> instruction: 0x01194297
    1760:	0d000013 	stceq	0, cr0, [r0, #-76]	; 0xffffffb4
    1764:	08030034 	stmdaeq	r3, {r2, r4, r5}
    1768:	0b3b0b3a 	bleq	ec4458 <_bss_end+0xeb875c>
    176c:	13490b39 	movtne	r0, #39737	; 0x9b39
    1770:	00001802 	andeq	r1, r0, r2, lsl #16
    1774:	01110100 	tsteq	r1, r0, lsl #2
    1778:	0b130e25 	bleq	4c5014 <_bss_end+0x4b9318>
    177c:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
    1780:	06120111 			; <UNDEFINED> instruction: 0x06120111
    1784:	00001710 	andeq	r1, r0, r0, lsl r7
    1788:	01013902 	tsteq	r1, r2, lsl #18
    178c:	03000013 	movweq	r0, #19
    1790:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
    1794:	0b3b0b3a 	bleq	ec4484 <_bss_end+0xeb8788>
    1798:	13490b39 	movtne	r0, #39737	; 0x9b39
    179c:	0a1c193c 	beq	707c94 <_bss_end+0x6fbf98>
    17a0:	3a040000 	bcc	1017a8 <_bss_end+0xf5aac>
    17a4:	3b0b3a00 	blcc	2cffac <_bss_end+0x2c42b0>
    17a8:	180b390b 	stmdane	fp, {r0, r1, r3, r8, fp, ip, sp}
    17ac:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
    17b0:	13490101 	movtne	r0, #37121	; 0x9101
    17b4:	00001301 	andeq	r1, r0, r1, lsl #6
    17b8:	49002106 	stmdbmi	r0, {r1, r2, r8, sp}
    17bc:	000b2f13 	andeq	r2, fp, r3, lsl pc
    17c0:	00260700 	eoreq	r0, r6, r0, lsl #14
    17c4:	00001349 	andeq	r1, r0, r9, asr #6
    17c8:	0b002408 	bleq	a7f0 <__udivsi3+0xc0>
    17cc:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
    17d0:	0900000e 	stmdbeq	r0, {r1, r2, r3}
    17d4:	13470034 	movtne	r0, #28724	; 0x7034
    17d8:	2e0a0000 	cdpcs	0, 0, cr0, cr10, cr0, {0}
    17dc:	03193f01 	tsteq	r9, #1, 30
    17e0:	3b0b3a0e 	blcc	2d0020 <_bss_end+0x2c4324>
    17e4:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
    17e8:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
    17ec:	96184006 	ldrls	r4, [r8], -r6
    17f0:	13011942 	movwne	r1, #6466	; 0x1942
    17f4:	050b0000 	streq	r0, [fp, #-0]
    17f8:	3a0e0300 	bcc	382400 <_bss_end+0x376704>
    17fc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    1800:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
    1804:	0c000018 	stceq	0, cr0, [r0], {24}
    1808:	08030034 	stmdaeq	r3, {r2, r4, r5}
    180c:	0b3b0b3a 	bleq	ec44fc <_bss_end+0xeb8800>
    1810:	13490b39 	movtne	r0, #39737	; 0x9b39
    1814:	00001802 	andeq	r1, r0, r2, lsl #16
    1818:	11010b0d 	tstne	r1, sp, lsl #22
    181c:	00061201 	andeq	r1, r6, r1, lsl #4
    1820:	000f0e00 	andeq	r0, pc, r0, lsl #28
    1824:	13490b0b 	movtne	r0, #39691	; 0x9b0b
    1828:	240f0000 	strcs	r0, [pc], #-0	; 1830 <CPSR_IRQ_INHIBIT+0x17b0>
    182c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
    1830:	0008030b 	andeq	r0, r8, fp, lsl #6
    1834:	11010000 	mrsne	r0, (UNDEF: 1)
    1838:	11061000 	mrsne	r1, (UNDEF: 6)
    183c:	03011201 	movweq	r1, #4609	; 0x1201
    1840:	250e1b0e 	strcs	r1, [lr, #-2830]	; 0xfffff4f2
    1844:	0005130e 	andeq	r1, r5, lr, lsl #6
    1848:	11010000 	mrsne	r0, (UNDEF: 1)
    184c:	11061000 	mrsne	r1, (UNDEF: 6)
    1850:	03011201 	movweq	r1, #4609	; 0x1201
    1854:	250e1b0e 	strcs	r1, [lr, #-2830]	; 0xfffff4f2
    1858:	0005130e 	andeq	r1, r5, lr, lsl #6
    185c:	11010000 	mrsne	r0, (UNDEF: 1)
    1860:	130e2501 	movwne	r2, #58625	; 0xe501
    1864:	1b0e030b 	blne	382498 <_bss_end+0x37679c>
    1868:	0017100e 	andseq	r1, r7, lr
    186c:	00240200 	eoreq	r0, r4, r0, lsl #4
    1870:	0b3e0b0b 	bleq	f844a4 <_bss_end+0xf787a8>
    1874:	00000803 	andeq	r0, r0, r3, lsl #16
    1878:	0b002403 	bleq	a88c <__udivsi3+0x15c>
    187c:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
    1880:	0400000e 	streq	r0, [r0], #-14
    1884:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
    1888:	0b3b0b3a 	bleq	ec4578 <_bss_end+0xeb887c>
    188c:	13490b39 	movtne	r0, #39737	; 0x9b39
    1890:	0f050000 	svceq	0x00050000
    1894:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
    1898:	06000013 			; <UNDEFINED> instruction: 0x06000013
    189c:	19270115 	stmdbne	r7!, {r0, r2, r4, r8}
    18a0:	13011349 	movwne	r1, #4937	; 0x1349
    18a4:	05070000 	streq	r0, [r7, #-0]
    18a8:	00134900 	andseq	r4, r3, r0, lsl #18
    18ac:	00260800 	eoreq	r0, r6, r0, lsl #16
    18b0:	34090000 	strcc	r0, [r9], #-0
    18b4:	3a0e0300 	bcc	3824bc <_bss_end+0x3767c0>
    18b8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    18bc:	3f13490b 	svccc	0x0013490b
    18c0:	00193c19 	andseq	r3, r9, r9, lsl ip
    18c4:	01040a00 	tsteq	r4, r0, lsl #20
    18c8:	0b3e0e03 	bleq	f850dc <_bss_end+0xf793e0>
    18cc:	13490b0b 	movtne	r0, #39691	; 0x9b0b
    18d0:	0b3b0b3a 	bleq	ec45c0 <_bss_end+0xeb88c4>
    18d4:	13010b39 	movwne	r0, #6969	; 0x1b39
    18d8:	280b0000 	stmdacs	fp, {}	; <UNPREDICTABLE>
    18dc:	1c0e0300 	stcne	3, cr0, [lr], {-0}
    18e0:	0c00000b 	stceq	0, cr0, [r0], {11}
    18e4:	13490101 	movtne	r0, #37121	; 0x9101
    18e8:	00001301 	andeq	r1, r0, r1, lsl #6
    18ec:	0000210d 	andeq	r2, r0, sp, lsl #2
    18f0:	00260e00 	eoreq	r0, r6, r0, lsl #28
    18f4:	00001349 	andeq	r1, r0, r9, asr #6
    18f8:	0300340f 	movweq	r3, #1039	; 0x40f
    18fc:	3b0b3a0e 	blcc	2d013c <_bss_end+0x2c4440>
    1900:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
    1904:	3c193f13 	ldccc	15, cr3, [r9], {19}
    1908:	10000019 	andne	r0, r0, r9, lsl r0
    190c:	0e030013 	mcreq	0, 0, r0, cr3, cr3, {0}
    1910:	0000193c 	andeq	r1, r0, ip, lsr r9
    1914:	27001511 	smladcs	r0, r1, r5, r1
    1918:	12000019 	andne	r0, r0, #25
    191c:	0e030017 	mcreq	0, 0, r0, cr3, cr7, {0}
    1920:	0000193c 	andeq	r1, r0, ip, lsr r9
    1924:	03011313 	movweq	r1, #4883	; 0x1313
    1928:	3a0b0b0e 	bcc	2c4568 <_bss_end+0x2b886c>
    192c:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
    1930:	0013010b 	andseq	r0, r3, fp, lsl #2
    1934:	000d1400 	andeq	r1, sp, r0, lsl #8
    1938:	0b3a0e03 	bleq	e8514c <_bss_end+0xe79450>
    193c:	0b39053b 	bleq	e42e30 <_bss_end+0xe37134>
    1940:	0b381349 	bleq	e0666c <_bss_end+0xdfa970>
    1944:	21150000 	tstcs	r5, r0
    1948:	2f134900 	svccs	0x00134900
    194c:	1600000b 	strne	r0, [r0], -fp
    1950:	0e030104 	adfeqs	f0, f3, f4
    1954:	0b0b0b3e 	bleq	2c4654 <_bss_end+0x2b8958>
    1958:	0b3a1349 	bleq	e86684 <_bss_end+0xe7a988>
    195c:	0b39053b 	bleq	e42e50 <_bss_end+0xe37154>
    1960:	00001301 	andeq	r1, r0, r1, lsl #6
    1964:	47003417 	smladmi	r0, r7, r4, r3
    1968:	3b0b3a13 	blcc	2d01bc <_bss_end+0x2c44c0>
    196c:	020b3905 	andeq	r3, fp, #81920	; 0x14000
    1970:	00000018 	andeq	r0, r0, r8, lsl r0

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
  dc:	000002d8 	ldrdeq	r0, [r0], -r8
	...
  e8:	0000001c 	andeq	r0, r0, ip, lsl r0
  ec:	29a10002 	stmibcs	r1!, {r1}
  f0:	00040000 	andeq	r0, r4, r0
  f4:	00000000 	andeq	r0, r0, r0
  f8:	000096a8 	andeq	r9, r0, r8, lsr #13
  fc:	0000036c 	andeq	r0, r0, ip, ror #6
	...
 108:	0000001c 	andeq	r0, r0, ip, lsl r0
 10c:	2e440002 	cdpcs	0, 4, cr0, cr4, cr2, {0}
 110:	00040000 	andeq	r0, r4, r0
 114:	00000000 	andeq	r0, r0, r0
 118:	00009a14 	andeq	r9, r0, r4, lsl sl
 11c:	00000400 	andeq	r0, r0, r0, lsl #8
	...
 128:	0000002c 	andeq	r0, r0, ip, lsr #32
 12c:	32cc0002 	sbccc	r0, ip, #2
 130:	00040000 	andeq	r0, r4, r0
 134:	00000000 	andeq	r0, r0, r0
 138:	00009e14 	andeq	r9, r0, r4, lsl lr
 13c:	0000058c 	andeq	r0, r0, ip, lsl #11
 140:	0000a3a0 	andeq	sl, r0, r0, lsr #7
 144:	0000002c 	andeq	r0, r0, ip, lsr #32
 148:	0000a3cc 	andeq	sl, r0, ip, asr #7
 14c:	0000002c 	andeq	r0, r0, ip, lsr #32
	...
 158:	0000001c 	andeq	r0, r0, ip, lsl r0
 15c:	3d5d0002 	ldclcc	0, cr0, [sp, #-8]
 160:	00040000 	andeq	r0, r4, r0
 164:	00000000 	andeq	r0, r0, r0
 168:	0000a3f8 	strdeq	sl, [r0], -r8
 16c:	0000005c 	andeq	r0, r0, ip, asr r0
	...
 178:	00000024 	andeq	r0, r0, r4, lsr #32
 17c:	3d830002 	stccc	0, cr0, [r3, #8]
 180:	00040000 	andeq	r0, r4, r0
 184:	00000000 	andeq	r0, r0, r0
 188:	00008000 	andeq	r8, r0, r0
 18c:	000000ac 	andeq	r0, r0, ip, lsr #1
 190:	0000a454 	andeq	sl, r0, r4, asr r4
 194:	00000050 	andeq	r0, r0, r0, asr r0
	...
 1a0:	0000001c 	andeq	r0, r0, ip, lsl r0
 1a4:	3da50002 	stccc	0, cr0, [r5, #8]!
 1a8:	00040000 	andeq	r0, r4, r0
 1ac:	00000000 	andeq	r0, r0, r0
 1b0:	0000a4a4 	andeq	sl, r0, r4, lsr #9
 1b4:	00000118 	andeq	r0, r0, r8, lsl r1
	...
 1c0:	0000001c 	andeq	r0, r0, ip, lsl r0
 1c4:	3ef40002 	cdpcc	0, 15, cr0, cr4, cr2, {0}
 1c8:	00040000 	andeq	r0, r4, r0
 1cc:	00000000 	andeq	r0, r0, r0
 1d0:	0000a5bc 			; <UNDEFINED> instruction: 0x0000a5bc
 1d4:	00000174 	andeq	r0, r0, r4, ror r1
	...
 1e0:	0000001c 	andeq	r0, r0, ip, lsl r0
 1e4:	40030002 	andmi	r0, r3, r2
 1e8:	00040000 	andeq	r0, r4, r0
 1ec:	00000000 	andeq	r0, r0, r0
 1f0:	0000a730 	andeq	sl, r0, r0, lsr r7
 1f4:	0000020c 	andeq	r0, r0, ip, lsl #4
	...
 200:	0000001c 	andeq	r0, r0, ip, lsl r0
 204:	40290002 	eormi	r0, r9, r2
 208:	00040000 	andeq	r0, r4, r0
 20c:	00000000 	andeq	r0, r0, r0
 210:	0000a93c 	andeq	sl, r0, ip, lsr r9
 214:	00000004 	andeq	r0, r0, r4
	...
 220:	00000014 	andeq	r0, r0, r4, lsl r0
 224:	404f0002 	submi	r0, pc, r2
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
      2c:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; fffffe94 <_bss_end+0xffff4198>
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
      90:	0a05830b 	beq	160cc4 <_bss_end+0x154fc8>
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
      e4:	5a2f6c6f 	bpl	bdb2a8 <_bss_end+0xbcf5ac>
      e8:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; ffffff5c <_bss_end+0xffff4260>
      ec:	2f657461 	svccs	0x00657461
      f0:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
      f4:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
      f8:	2d33312f 	ldfcss	f3, [r3, #-188]!	; 0xffffff44
      fc:	746e6f63 	strbtvc	r6, [lr], #-3939	; 0xfffff09d
     100:	5f747865 	svcpl	0x00747865
     104:	74697773 	strbtvc	r7, [r9], #-1907	; 0xfffff88d
     108:	6d5f6863 	ldclvs	8, cr6, [pc, #-396]	; ffffff84 <_bss_end+0xffff4288>
     10c:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
     110:	6b2f726f 	blvs	bdcad4 <_bss_end+0xbd0dd8>
     114:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
     118:	72732f6c 	rsbsvc	r2, r3, #108, 30	; 0x1b0
     11c:	72642f63 	rsbvc	r2, r4, #396	; 0x18c
     120:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
     124:	682f0073 	stmdavs	pc!, {r0, r1, r4, r5, r6}	; <UNPREDICTABLE>
     128:	2f656d6f 	svccs	0x00656d6f
     12c:	686c6973 	stmdavs	ip!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
     130:	6a797661 	bvs	1e5dabc <_bss_end+0x1e51dc0>
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
     190:	6a797661 	bvs	1e5db1c <_bss_end+0x1e51e20>
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
     21c:	0a051700 	beq	145e24 <_bss_end+0x13a128>
     220:	2e39059f 	mrccs	5, 1, r0, cr9, cr15, {4}
     224:	a14d0105 	cmpge	sp, r5, lsl #2
     228:	05d70205 	ldrbeq	r0, [r7, #517]	; 0x205
     22c:	0c05670a 	stceq	7, cr6, [r5], {10}
     230:	8206054c 	andhi	r0, r6, #76, 10	; 0x13000000
     234:	0b031105 	bleq	c4650 <_bss_end+0xb8954>
     238:	0817054a 	ldmdaeq	r7, {r1, r3, r6, r8, sl}
     23c:	660a0520 	strvs	r0, [sl], -r0, lsr #10
     240:	054c0905 	strbeq	r0, [ip, #-2309]	; 0xfffff6fb
     244:	05a12f01 	streq	r2, [r1, #3841]!	; 0xf01
     248:	0a05d702 	beq	175e58 <_bss_end+0x16a15c>
     24c:	4c080567 	cfstr32mi	mvfx0, [r8], {103}	; 0x67
     250:	01040200 	mrseq	r0, R12_usr
     254:	02006606 	andeq	r6, r0, #6291456	; 0x600000
     258:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
     25c:	04020006 	streq	r0, [r2], #-6
     260:	052e0604 	streq	r0, [lr, #-1540]!	; 0xfffff9fc
     264:	04020010 	streq	r0, [r2], #-16
     268:	0a054b04 	beq	152e80 <_bss_end+0x147184>
     26c:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
     270:	0009054a 	andeq	r0, r9, sl, asr #10
     274:	4c040402 	cfstrsmi	mvf0, [r4], {2}
     278:	852f0105 	strhi	r0, [pc, #-261]!	; 17b <CPSR_IRQ_INHIBIT+0xfb>
     27c:	05d70205 	ldrbeq	r0, [r7, #517]	; 0x205
     280:	0805670a 	stmdaeq	r5, {r1, r3, r8, r9, sl, sp, lr}
     284:	0402004c 	streq	r0, [r2], #-76	; 0xffffffb4
     288:	00660601 	rsbeq	r0, r6, r1, lsl #12
     28c:	4a020402 	bmi	8129c <_bss_end+0x755a0>
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
     2d0:	4b040402 	blmi	1012e0 <_bss_end+0xf55e4>
     2d4:	02000a05 	andeq	r0, r0, #20480	; 0x5000
     2d8:	054a0404 	strbeq	r0, [sl, #-1028]	; 0xfffffbfc
     2dc:	04020009 	streq	r0, [r2], #-9
     2e0:	01054c04 	tsteq	r5, r4, lsl #24
     2e4:	1a05852f 	bne	1617a8 <_bss_end+0x155aac>
     2e8:	ba0605bc 	blt	1819e0 <_bss_end+0x175ce4>
     2ec:	054a0205 	strbeq	r0, [sl, #-517]	; 0xfffffdfb
     2f0:	14054d0f 	strne	r4, [r5], #-3343	; 0xfffff2f1
     2f4:	4a1d054c 	bmi	74182c <_bss_end+0x735b30>
     2f8:	059f0c05 	ldreq	r0, [pc, #3077]	; f05 <CPSR_IRQ_INHIBIT+0xe85>
     2fc:	05056608 	streq	r6, [r5, #-1544]	; 0xfffff9f8
     300:	670e054a 	strvs	r0, [lr, -sl, asr #10]
     304:	05660505 	strbeq	r0, [r6, #-1285]!	; 0xfffffafb
     308:	0b056802 	bleq	15a318 <_bss_end+0x14e61c>
     30c:	660d054a 	strvs	r0, [sp], -sl, asr #10
     310:	78030305 	stmdavc	r3, {r0, r2, r8, r9}
     314:	03010566 	movweq	r0, #5478	; 0x1566
     318:	054d2e09 	strbeq	r2, [sp, #-3593]	; 0xfffff1f7
     31c:	0605a01a 			; <UNDEFINED> instruction: 0x0605a01a
     320:	4a0205ba 	bmi	81a10 <_bss_end+0x75d14>
     324:	054b1a05 	strbeq	r1, [fp, #-2565]	; 0xfffff5fb
     328:	2f054c26 	svccs	0x00054c26
     32c:	8231054a 	eorshi	r0, r1, #310378496	; 0x12800000
     330:	054a3c05 	strbeq	r3, [sl, #-3077]	; 0xfffff3fb
     334:	04020001 	streq	r0, [r2], #-1
     338:	05692f01 	strbeq	r2, [r9, #-3841]!	; 0xfffff0ff
     33c:	3205d808 	andcc	sp, r5, #8, 16	; 0x80000
     340:	00210566 	eoreq	r0, r1, r6, ror #10
     344:	4a020402 	bmi	81354 <_bss_end+0x75658>
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
     394:	4a0205ba 	bmi	81a84 <_bss_end+0x75d88>
     398:	4c4b0a05 	mcrrmi	10, 0, r0, fp, cr5
     39c:	054a1305 	strbeq	r1, [sl, #-773]	; 0xfffffcfb
     3a0:	1d058215 	sfmne	f0, 1, [r5, #-84]	; 0xffffffac
     3a4:	2e1f054a 	cfmac32cs	mvfx0, mvfx15, mvfx10
     3a8:	02000105 	andeq	r0, r0, #1073741825	; 0x40000001
     3ac:	66830104 	strvs	r0, [r3], r4, lsl #2
     3b0:	0402009e 	streq	r0, [r2], #-158	; 0xffffff62
     3b4:	05660601 	strbeq	r0, [r6, #-1537]!	; 0xfffff9ff
     3b8:	9a030623 	bls	c1c4c <_bss_end+0xb5f50>
     3bc:	0105827f 	tsteq	r5, pc, ror r2
     3c0:	6600e603 	strvs	lr, [r0], -r3, lsl #12
     3c4:	0a024aba 	beq	92eb4 <_bss_end+0x871b8>
     3c8:	59010100 	stmdbpl	r1, {r8}
     3cc:	03000004 	movweq	r0, #4
     3d0:	0000dd00 	andeq	sp, r0, r0, lsl #26
     3d4:	fb010200 	blx	40bde <_bss_end+0x34ee2>
     3d8:	01000d0e 	tsteq	r0, lr, lsl #26
     3dc:	00010101 	andeq	r0, r1, r1, lsl #2
     3e0:	00010000 	andeq	r0, r1, r0
     3e4:	682f0100 	stmdavs	pc!, {r8}	; <UNPREDICTABLE>
     3e8:	2f656d6f 	svccs	0x00656d6f
     3ec:	686c6973 	stmdavs	ip!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
     3f0:	6a797661 	bvs	1e5dd7c <_bss_end+0x1e52080>
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
     4dc:	1b054a01 	blne	152ce8 <_bss_end+0x146fec>
     4e0:	00260568 	eoreq	r0, r6, r8, ror #10
     4e4:	4a030402 	bmi	c14f4 <_bss_end+0xb57f8>
     4e8:	02002405 	andeq	r2, r0, #83886080	; 0x5000000
     4ec:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
     4f0:	0402000d 	streq	r0, [r2], #-13
     4f4:	1c056802 	stcne	8, cr6, [r5], {2}
     4f8:	02040200 	andeq	r0, r4, #0, 4
     4fc:	001a054a 	andseq	r0, sl, sl, asr #10
     500:	4a020402 	bmi	81510 <_bss_end+0x75814>
     504:	02002505 	andeq	r2, r0, #20971520	; 0x1400000
     508:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
     50c:	04020028 	streq	r0, [r2], #-40	; 0xffffffd8
     510:	2a054a02 	bcs	152d20 <_bss_end+0x147024>
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
     53c:	1b054a01 	blne	152d48 <_bss_end+0x14704c>
     540:	00260568 	eoreq	r0, r6, r8, ror #10
     544:	4a030402 	bmi	c1554 <_bss_end+0xb5858>
     548:	02002405 	andeq	r2, r0, #83886080	; 0x5000000
     54c:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
     550:	04020032 	streq	r0, [r2], #-50	; 0xffffffce
     554:	41056802 	tstmi	r5, r2, lsl #16
     558:	02040200 	andeq	r0, r4, #0, 4
     55c:	003f054a 	eorseq	r0, pc, sl, asr #10
     560:	4a020402 	bmi	81570 <_bss_end+0x75874>
     564:	02004a05 	andeq	r4, r0, #20480	; 0x5000
     568:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
     56c:	0402004d 	streq	r0, [r2], #-77	; 0xffffffb3
     570:	0d054a02 	vstreq	s8, [r5, #-8]
     574:	02040200 	andeq	r0, r4, #0, 4
     578:	001b052e 	andseq	r0, fp, lr, lsr #10
     57c:	4a020402 	bmi	8158c <_bss_end+0x75890>
     580:	02002205 	andeq	r2, r0, #1342177280	; 0x50000000
     584:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
     588:	04020020 	streq	r0, [r2], #-32	; 0xffffffe0
     58c:	2b054a02 	blcs	152d9c <_bss_end+0x1470a0>
     590:	02040200 	andeq	r0, r4, #0, 4
     594:	002e052e 	eoreq	r0, lr, lr, lsr #10
     598:	4a020402 	bmi	815a8 <_bss_end+0x758ac>
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
     5e8:	4a020402 	bmi	815f8 <_bss_end+0x758fc>
     5ec:	02002e05 	andeq	r2, r0, #5, 28	; 0x50
     5f0:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
     5f4:	04020031 	streq	r0, [r2], #-49	; 0xffffffcf
     5f8:	33054a02 	movwcc	r4, #23042	; 0x5a02
     5fc:	02040200 	andeq	r0, r4, #0, 4
     600:	0005052e 	andeq	r0, r5, lr, lsr #10
     604:	48020402 	stmdami	r2, {r1, sl}
     608:	8a860105 	bhi	fe180a24 <_bss_end+0xfe174d28>
     60c:	05bb0505 	ldreq	r0, [fp, #1285]!	; 0x505
     610:	1d056809 	stcne	8, cr6, [r5, #-36]	; 0xffffffdc
     614:	4a21054a 	bmi	841b44 <_bss_end+0x835e48>
     618:	054a1f05 	strbeq	r1, [sl, #-3845]	; 0xfffff0fb
     61c:	2a052e35 	bcs	14bef8 <_bss_end+0x1401fc>
     620:	2e36054a 	cdpcs	5, 3, cr0, cr6, cr10, {2}
     624:	052e3805 	streq	r3, [lr, #-2053]!	; 0xfffff7fb
     628:	09054b14 	stmdbeq	r5, {r2, r4, r8, r9, fp, lr}
     62c:	8614054a 	ldrhi	r0, [r4], -sl, asr #10
     630:	4a090567 	bmi	241bd4 <_bss_end+0x235ed8>
     634:	05691205 	strbeq	r1, [r9, #-517]!	; 0xfffffdfb
     638:	01054c0d 	tsteq	r5, sp, lsl #24
     63c:	1705692f 	strne	r6, [r5, -pc, lsr #18]
     640:	0023059f 	mlaeq	r3, pc, r5, r0	; <UNPREDICTABLE>
     644:	4a030402 	bmi	c1654 <_bss_end+0xb5958>
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
     6a8:	4a37052e 	bmi	dc1b68 <_bss_end+0xdb5e6c>
     6ac:	052e1305 	streq	r1, [lr, #-773]!	; 0xfffffcfb
     6b0:	0a052f17 	beq	14c314 <_bss_end+0x140618>
     6b4:	6205059f 	andvs	r0, r5, #666894336	; 0x27c00000
     6b8:	68100535 	ldmdavs	r0, {r0, r2, r4, r5, r8, sl}
     6bc:	052e1105 	streq	r1, [lr, #-261]!	; 0xfffffefb
     6c0:	13054a22 	movwne	r4, #23074	; 0x5a22
     6c4:	2f0a052e 	svccs	0x000a052e
     6c8:	05690c05 	strbeq	r0, [r9, #-3077]!	; 0xfffff3fb
     6cc:	0f052e0d 	svceq	0x00052e0d
     6d0:	4b06054a 	blmi	181c00 <_bss_end+0x175f04>
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
     758:	0a024a9e 	beq	931d8 <_bss_end+0x874dc>
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
     788:	4a05054a 	bmi	141cb8 <_bss_end+0x135fbc>
     78c:	674c1405 	strbvs	r1, [ip, -r5, lsl #8]
     790:	054a0905 	strbeq	r0, [sl, #-2309]	; 0xfffff6fb
     794:	17056912 	smladne	r5, r2, r9, r6
     798:	4a05054a 	bmi	141cc8 <_bss_end+0x135fcc>
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
     7d4:	bb050501 	bllt	141be0 <_bss_end+0x135ee4>
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
     9a0:	4a18059f 	bmi	602024 <_bss_end+0x5f6328>
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
     9d8:	1b05836f 	blne	16179c <_bss_end+0x155aa0>
     9dc:	83170584 	tsthi	r7, #132, 10	; 0x21000000
     9e0:	69830105 	stmibvs	r3, {r0, r2, r8}
     9e4:	05832305 	streq	r2, [r3, #773]	; 0x305
     9e8:	09058225 	stmdbeq	r5, {r0, r2, r5, r9, pc}
     9ec:	4a05054c 	bmi	141f24 <_bss_end+0x136228>
     9f0:	054b0905 	strbeq	r0, [fp, #-2309]	; 0xfffff6fb
     9f4:	01054a12 	tsteq	r5, r2, lsl sl
     9f8:	2b05692f 	blcs	15aebc <_bss_end+0x14f1c0>
     9fc:	82100583 	andshi	r0, r0, #549453824	; 0x20c00000
     a00:	052e2b05 	streq	r2, [lr, #-2821]!	; 0xfffff4fb
     a04:	9e668301 	cdpls	3, 6, cr8, cr6, cr1, {0}
     a08:	01040200 	mrseq	r0, R12_usr
     a0c:	1e056606 	cfmadd32ne	mvax0, mvfx6, mvfx5, mvfx6
     a10:	7fbb0306 	svcvc	0x00bb0306
     a14:	03010582 	movweq	r0, #5506	; 0x1582
     a18:	ba6600c5 	blt	1980d34 <_bss_end+0x1975038>
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
     a50:	5a2f6c6f 	bpl	bdbc14 <_bss_end+0xbcff18>
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
     a7c:	6b2f726f 	blvs	bdd440 <_bss_end+0xbd1744>
     a80:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
     a84:	72732f6c 	rsbsvc	r2, r3, #108, 30	; 0x1b0
     a88:	682f0063 	stmdavs	pc!, {r0, r1, r5, r6}	; <UNPREDICTABLE>
     a8c:	2f656d6f 	svccs	0x00656d6f
     a90:	686c6973 	stmdavs	ip!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
     a94:	6a797661 	bvs	1e5e420 <_bss_end+0x1e52724>
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
     af4:	6a797661 	bvs	1e5e480 <_bss_end+0x1e52784>
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
     c40:	4a3a052e 	bmi	e82100 <_bss_end+0xe76404>
     c44:	05824105 	streq	r4, [r2, #261]	; 0x105
     c48:	01052e3c 	tsteq	r5, ip, lsr lr
     c4c:	1805692f 	stmdane	r5, {r0, r1, r2, r3, r5, r8, fp, sp, lr}
     c50:	0187059f 			; <UNDEFINED> instruction: 0x0187059f
     c54:	4a7a054c 	bmi	1e8218c <_bss_end+0x1e76490>
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
     c8c:	4aba663b 	bmi	fee9a580 <_bss_end+0xfee8e884>
     c90:	01000a02 	tsteq	r0, r2, lsl #20
     c94:	00038601 	andeq	r8, r3, r1, lsl #12
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
     d10:	5a2f6c6f 	bpl	bdbed4 <_bss_end+0xbd01d8>
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
     d3c:	6b2f726f 	blvs	bdd700 <_bss_end+0xbd1a04>
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
     d70:	5a2f6c6f 	bpl	bdbf34 <_bss_end+0xbd0238>
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
     d9c:	6b2f726f 	blvs	bdd760 <_bss_end+0xbd1a64>
     da0:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
     da4:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
     da8:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
     dac:	72642f65 	rsbvc	r2, r4, #404	; 0x194
     db0:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
     db4:	682f0073 	stmdavs	pc!, {r0, r1, r4, r5, r6}	; <UNPREDICTABLE>
     db8:	2f656d6f 	svccs	0x00656d6f
     dbc:	686c6973 	stmdavs	ip!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
     dc0:	6a797661 	bvs	1e5e74c <_bss_end+0x1e52a50>
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
     ed8:	6d000003 	stcvs	0, cr0, [r0, #-12]
     edc:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
     ee0:	682e726f 	stmdavs	lr!, {r0, r1, r2, r3, r5, r6, r9, ip, sp, lr}
     ee4:	00000300 	andeq	r0, r0, r0, lsl #6
     ee8:	69726570 	ldmdbvs	r2!, {r4, r5, r6, r8, sl, sp, lr}^
     eec:	72656870 	rsbvc	r6, r5, #112, 16	; 0x700000
     ef0:	2e736c61 	cdpcs	12, 7, cr6, cr3, cr1, {3}
     ef4:	00020068 	andeq	r0, r2, r8, rrx
     ef8:	6d697400 	cfstrdvs	mvd7, [r9, #-0]
     efc:	682e7265 	stmdavs	lr!, {r0, r2, r5, r6, r9, ip, sp, lr}
     f00:	00000300 	andeq	r0, r0, r0, lsl #6
     f04:	65746e69 	ldrbvs	r6, [r4, #-3689]!	; 0xfffff197
     f08:	70757272 	rsbsvc	r7, r5, r2, ror r2
     f0c:	6f635f74 	svcvs	0x00635f74
     f10:	6f72746e 	svcvs	0x0072746e
     f14:	72656c6c 	rsbvc	r6, r5, #108, 24	; 0x6c00
     f18:	0400682e 	streq	r6, [r0], #-2094	; 0xfffff7d2
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
     f78:	4b01054a 	blmi	424a8 <_bss_end+0x367ac>
     f7c:	690e05a1 	stmdbvs	lr, {r0, r5, r7, r8, sl}
     f80:	2f0f056a 	svccs	0x000f056a
     f84:	05670d05 	strbeq	r0, [r7, #-3333]!	; 0xfffff2fb
     f88:	1105300a 	tstne	r5, sl
     f8c:	03040200 	movweq	r0, #16896	; 0x4200
     f90:	0003054a 	andeq	r0, r3, sl, asr #10
     f94:	d6020402 	strle	r0, [r2], -r2, lsl #8
     f98:	05c00105 	strbeq	r0, [r0, #261]	; 0x105
     f9c:	056a690e 	strbeq	r6, [sl, #-2318]!	; 0xfffff6f2
     fa0:	0d052f0f 	stceq	15, cr2, [r5, #-60]	; 0xffffffc4
     fa4:	300a0567 	andcc	r0, sl, r7, ror #10
     fa8:	02001105 	andeq	r1, r0, #1073741825	; 0x40000001
     fac:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
     fb0:	04020003 	streq	r0, [r2], #-3
     fb4:	0105d602 	tsteq	r5, r2, lsl #12
     fb8:	690e05c0 	stmdbvs	lr, {r6, r7, r8, sl}
     fbc:	2f0f056a 	svccs	0x000f056a
     fc0:	05670d05 	strbeq	r0, [r7, #-3333]!	; 0xfffff2fb
     fc4:	1105300a 	tstne	r5, sl
     fc8:	03040200 	movweq	r0, #16896	; 0x4200
     fcc:	0003054a 	andeq	r0, r3, sl, asr #10
     fd0:	d6020402 	strle	r0, [r2], -r2, lsl #8
     fd4:	05c00105 	strbeq	r0, [r0, #261]	; 0x105
     fd8:	056a690e 	strbeq	r6, [sl, #-2318]!	; 0xfffff6f2
     fdc:	0d052f0f 	stceq	15, cr2, [r5, #-60]	; 0xffffffc4
     fe0:	300a0567 	andcc	r0, sl, r7, ror #10
     fe4:	02001105 	andeq	r1, r0, #1073741825	; 0x40000001
     fe8:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
     fec:	04020003 	streq	r0, [r2], #-3
     ff0:	0105d602 	tsteq	r5, r2, lsl #12
     ff4:	4c1905c0 	cfldr32mi	mvfx0, [r9], {192}	; 0xc0
     ff8:	05831205 	streq	r1, [r3, #517]	; 0x205
     ffc:	0e058510 	cfmv64lreq	mvdx5, r8
    1000:	6a1c054b 	bvs	702534 <_bss_end+0x6f6838>
    1004:	05838383 	streq	r8, [r3, #899]	; 0x383
    1008:	0f058521 	svceq	0x00058521
    100c:	a1200569 			; <UNDEFINED> instruction: 0xa1200569
    1010:	05680c05 	strbeq	r0, [r8, #-3077]!	; 0xfffff3fb
    1014:	04020005 	streq	r0, [r2], #-5
    1018:	18023101 	stmdane	r2, {r0, r8, ip, sp}
    101c:	b4010100 	strlt	r0, [r1], #-256	; 0xffffff00
    1020:	03000002 	movweq	r0, #2
    1024:	00017700 	andeq	r7, r1, r0, lsl #14
    1028:	fb010200 	blx	41832 <_bss_end+0x35b36>
    102c:	01000d0e 	tsteq	r0, lr, lsl #26
    1030:	00010101 	andeq	r0, r1, r1, lsl #2
    1034:	00010000 	andeq	r0, r1, r0
    1038:	682f0100 	stmdavs	pc!, {r8}	; <UNPREDICTABLE>
    103c:	2f656d6f 	svccs	0x00656d6f
    1040:	686c6973 	stmdavs	ip!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
    1044:	6a797661 	bvs	1e5e9d0 <_bss_end+0x1e52cd4>
    1048:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
    104c:	2f6c6f6f 	svccs	0x006c6f6f
    1050:	6f72655a 	svcvs	0x0072655a
    1054:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
    1058:	6178652f 	cmnvs	r8, pc, lsr #10
    105c:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
    1060:	33312f73 	teqcc	r1, #460	; 0x1cc
    1064:	6e6f632d 	cdpvs	3, 6, cr6, cr15, cr13, {1}
    1068:	74786574 	ldrbtvc	r6, [r8], #-1396	; 0xfffffa8c
    106c:	6977735f 	ldmdbvs	r7!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, sp, lr}^
    1070:	5f686374 	svcpl	0x00686374
    1074:	696e6f6d 	stmdbvs	lr!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
    1078:	2f726f74 	svccs	0x00726f74
    107c:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
    1080:	732f6c65 			; <UNDEFINED> instruction: 0x732f6c65
    1084:	6d2f6372 	stcvs	3, cr6, [pc, #-456]!	; ec4 <CPSR_IRQ_INHIBIT+0xe44>
    1088:	726f6d65 	rsbvc	r6, pc, #6464	; 0x1940
    108c:	682f0079 	stmdavs	pc!, {r0, r3, r4, r5, r6}	; <UNPREDICTABLE>
    1090:	2f656d6f 	svccs	0x00656d6f
    1094:	686c6973 	stmdavs	ip!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
    1098:	6a797661 	bvs	1e5ea24 <_bss_end+0x1e52d28>
    109c:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
    10a0:	2f6c6f6f 	svccs	0x006c6f6f
    10a4:	6f72655a 	svcvs	0x0072655a
    10a8:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
    10ac:	6178652f 	cmnvs	r8, pc, lsr #10
    10b0:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
    10b4:	33312f73 	teqcc	r1, #460	; 0x1cc
    10b8:	6e6f632d 	cdpvs	3, 6, cr6, cr15, cr13, {1}
    10bc:	74786574 	ldrbtvc	r6, [r8], #-1396	; 0xfffffa8c
    10c0:	6977735f 	ldmdbvs	r7!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, sp, lr}^
    10c4:	5f686374 	svcpl	0x00686374
    10c8:	696e6f6d 	stmdbvs	lr!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
    10cc:	2f726f74 	svccs	0x00726f74
    10d0:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
    10d4:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
    10d8:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
    10dc:	622f6564 	eorvs	r6, pc, #100, 10	; 0x19000000
    10e0:	6472616f 	ldrbtvs	r6, [r2], #-367	; 0xfffffe91
    10e4:	6970722f 	ldmdbvs	r0!, {r0, r1, r2, r3, r5, r9, ip, sp, lr}^
    10e8:	61682f30 	cmnvs	r8, r0, lsr pc
    10ec:	682f006c 	stmdavs	pc!, {r2, r3, r5, r6}	; <UNPREDICTABLE>
    10f0:	2f656d6f 	svccs	0x00656d6f
    10f4:	686c6973 	stmdavs	ip!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
    10f8:	6a797661 	bvs	1e5ea84 <_bss_end+0x1e52d88>
    10fc:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
    1100:	2f6c6f6f 	svccs	0x006c6f6f
    1104:	6f72655a 	svcvs	0x0072655a
    1108:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
    110c:	6178652f 	cmnvs	r8, pc, lsr #10
    1110:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
    1114:	33312f73 	teqcc	r1, #460	; 0x1cc
    1118:	6e6f632d 	cdpvs	3, 6, cr6, cr15, cr13, {1}
    111c:	74786574 	ldrbtvc	r6, [r8], #-1396	; 0xfffffa8c
    1120:	6977735f 	ldmdbvs	r7!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, sp, lr}^
    1124:	5f686374 	svcpl	0x00686374
    1128:	696e6f6d 	stmdbvs	lr!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
    112c:	2f726f74 	svccs	0x00726f74
    1130:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
    1134:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
    1138:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
    113c:	6d2f6564 	cfstr32vs	mvfx6, [pc, #-400]!	; fb4 <CPSR_IRQ_INHIBIT+0xf34>
    1140:	726f6d65 	rsbvc	r6, pc, #6464	; 0x1940
    1144:	6b000079 	blvs	1330 <CPSR_IRQ_INHIBIT+0x12b0>
    1148:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
    114c:	65685f6c 	strbvs	r5, [r8, #-3948]!	; 0xfffff094
    1150:	632e7061 			; <UNDEFINED> instruction: 0x632e7061
    1154:	01007070 	tsteq	r0, r0, ror r0
    1158:	6e690000 	cdpvs	0, 6, cr0, cr9, cr0, {0}
    115c:	66656474 			; <UNDEFINED> instruction: 0x66656474
    1160:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
    1164:	656b0000 	strbvs	r0, [fp, #-0]!
    1168:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
    116c:	6165685f 	cmnvs	r5, pc, asr r8
    1170:	00682e70 	rsbeq	r2, r8, r0, ror lr
    1174:	70000003 	andvc	r0, r0, r3
    1178:	70697265 	rsbvc	r7, r9, r5, ror #4
    117c:	61726568 	cmnvs	r2, r8, ror #10
    1180:	682e736c 	stmdavs	lr!, {r2, r3, r5, r6, r8, r9, ip, sp, lr}
    1184:	00000200 	andeq	r0, r0, r0, lsl #4
    1188:	6d6d656d 	cfstr64vs	mvdx6, [sp, #-436]!	; 0xfffffe4c
    118c:	682e7061 	stmdavs	lr!, {r0, r5, r6, ip, sp, lr}
    1190:	00000300 	andeq	r0, r0, r0, lsl #6
    1194:	65676170 	strbvs	r6, [r7, #-368]!	; 0xfffffe90
    1198:	00682e73 	rsbeq	r2, r8, r3, ror lr
    119c:	00000003 	andeq	r0, r0, r3
    11a0:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
    11a4:	0096a802 	addseq	sl, r6, r2, lsl #16
    11a8:	1d051700 	stcne	7, cr1, [r5, #-0]
    11ac:	660c0585 	strvs	r0, [ip], -r5, lsl #11
    11b0:	854b0105 	strbhi	r0, [fp, #-261]	; 0xfffffefb
    11b4:	05836d05 	streq	r6, [r3, #3333]	; 0xd05
    11b8:	1105666f 	tstne	r5, pc, ror #12
    11bc:	0567672f 	strbeq	r6, [r7, #-1839]!	; 0xfffff8d1
    11c0:	0c056714 	stceq	7, cr6, [r5], {20}
    11c4:	2f010568 	svccs	0x00010568
    11c8:	9f2005a1 	svcls	0x002005a1
    11cc:	05691d05 	strbeq	r1, [r9, #-3333]!	; 0xfffff2fb
    11d0:	04020029 	streq	r0, [r2], #-41	; 0xffffffd7
    11d4:	1d056601 	stcne	6, cr6, [r5, #-4]
    11d8:	01040200 	mrseq	r0, R12_usr
    11dc:	003b054a 	eorseq	r0, fp, sl, asr #10
    11e0:	4a020402 	bmi	821f0 <_bss_end+0x764f4>
    11e4:	02003105 	andeq	r3, r0, #1073741825	; 0x40000001
    11e8:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
    11ec:	0505680f 	streq	r6, [r5, #-2063]	; 0xfffff7f1
    11f0:	10053364 	andne	r3, r5, r4, ror #6
    11f4:	05054f6a 	streq	r4, [r5, #-3946]	; 0xfffff096
    11f8:	0027054a 	eoreq	r0, r7, sl, asr #10
    11fc:	66010402 	strvs	r0, [r1], -r2, lsl #8
    1200:	02005805 	andeq	r5, r0, #327680	; 0x50000
    1204:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
    1208:	0402001d 	streq	r0, [r2], #-29	; 0xffffffe3
    120c:	18054a01 	stmdane	r5, {r0, r9, fp, lr}
    1210:	6754054c 	ldrbvs	r0, [r4, -ip, asr #10]
    1214:	6c019a05 			; <UNDEFINED> instruction: 0x6c019a05
    1218:	054a2005 	strbeq	r2, [sl, #-5]
    121c:	1e056819 	mcrne	8, 0, r6, cr5, cr9, {0}
    1220:	4a25054a 	bmi	942750 <_bss_end+0x936a54>
    1224:	4c2e1005 	stcmi	0, cr1, [lr], #-20	; 0xffffffec
    1228:	05671905 	strbeq	r1, [r7, #-2309]!	; 0xfffff6fb
    122c:	13054a10 	movwne	r4, #23056	; 0x5a10
    1230:	6711054b 	ldrvs	r0, [r1, -fp, asr #10]
    1234:	67140568 	ldrvs	r0, [r4, -r8, ror #10]
    1238:	05685005 	strbeq	r5, [r8, #-5]!
    123c:	05854b01 	streq	r4, [r5, #2817]	; 0xb01
    1240:	14059f20 	strne	r9, [r5], #-3872	; 0xfffff0e0
    1244:	69100568 	ldmdbvs	r0, {r3, r5, r6, r8, sl}
    1248:	054a0505 	strbeq	r0, [sl, #-1285]	; 0xfffffafb
    124c:	0402001f 	streq	r0, [r2], #-31	; 0xffffffe1
    1250:	25054a01 	strcs	r4, [r5, #-2561]	; 0xfffff5ff
    1254:	01040200 	mrseq	r0, R12_usr
    1258:	0015054a 	andseq	r0, r5, sl, asr #10
    125c:	2e010402 	cdpcs	4, 0, cr0, cr1, cr2, {0}
    1260:	4a1f054c 	bmi	7c2798 <_bss_end+0x7b6a9c>
    1264:	054a2505 	strbeq	r2, [sl, #-1285]	; 0xfffffafb
    1268:	1e052e15 	mcrne	14, 0, r2, cr5, cr5, {0}
    126c:	4a240583 	bmi	902880 <_bss_end+0x8f6b84>
    1270:	052e1505 	streq	r1, [lr, #-1285]!	; 0xfffffafb
    1274:	1b054b10 	blne	153ebc <_bss_end+0x1481c0>
    1278:	4e10054a 	cfmac32mi	mvfx0, mvfx0, mvfx10
    127c:	054a0505 	strbeq	r0, [sl, #-1285]	; 0xfffffafb
    1280:	0402001f 	streq	r0, [r2], #-31	; 0xffffffe1
    1284:	25054a01 	strcs	r4, [r5, #-2561]	; 0xfffff5ff
    1288:	01040200 	mrseq	r0, R12_usr
    128c:	0015054a 	andseq	r0, r5, sl, asr #10
    1290:	2e010402 	cdpcs	4, 0, cr0, cr1, cr2, {0}
    1294:	054c1005 	strbeq	r1, [ip, #-5]
    1298:	25054a1b 	strcs	r4, [r5, #-2587]	; 0xfffff5e5
    129c:	4a1b052e 	bmi	6c275c <_bss_end+0x6b6a60>
    12a0:	052e1005 	streq	r1, [lr, #-5]!
    12a4:	10054a1b 	andne	r4, r5, fp, lsl sl
    12a8:	4a24054b 	bmi	9027dc <_bss_end+0x8f6ae0>
    12ac:	054a1b05 	strbeq	r1, [sl, #-2821]	; 0xfffff4fb
    12b0:	24052f10 	strcs	r2, [r5], #-3856	; 0xfffff0f0
    12b4:	4a1b054a 	bmi	6c27e4 <_bss_end+0x6b6ae8>
    12b8:	82300105 	eorshi	r0, r0, #1073741825	; 0x40000001
    12bc:	0402009e 	streq	r0, [r2], #-158	; 0xffffff62
    12c0:	05660601 	strbeq	r0, [r6, #-1537]!	; 0xfffff9ff
    12c4:	ad030616 	stcge	6, cr0, [r3, #-88]	; 0xffffffa8
    12c8:	0105827f 	tsteq	r5, pc, ror r2
    12cc:	4a00d303 	bmi	35ee0 <_bss_end+0x2a1e4>
    12d0:	0a024a9e 	beq	93d50 <_bss_end+0x88054>
    12d4:	7e010100 	adfvcs	f0, f1, f0
    12d8:	03000002 	movweq	r0, #2
    12dc:	00016000 	andeq	r6, r1, r0
    12e0:	fb010200 	blx	41aea <_bss_end+0x35dee>
    12e4:	01000d0e 	tsteq	r0, lr, lsl #26
    12e8:	00010101 	andeq	r0, r1, r1, lsl #2
    12ec:	00010000 	andeq	r0, r1, r0
    12f0:	682f0100 	stmdavs	pc!, {r8}	; <UNPREDICTABLE>
    12f4:	2f656d6f 	svccs	0x00656d6f
    12f8:	686c6973 	stmdavs	ip!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
    12fc:	6a797661 	bvs	1e5ec88 <_bss_end+0x1e52f8c>
    1300:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
    1304:	2f6c6f6f 	svccs	0x006c6f6f
    1308:	6f72655a 	svcvs	0x0072655a
    130c:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
    1310:	6178652f 	cmnvs	r8, pc, lsr #10
    1314:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
    1318:	33312f73 	teqcc	r1, #460	; 0x1cc
    131c:	6e6f632d 	cdpvs	3, 6, cr6, cr15, cr13, {1}
    1320:	74786574 	ldrbtvc	r6, [r8], #-1396	; 0xfffffa8c
    1324:	6977735f 	ldmdbvs	r7!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, sp, lr}^
    1328:	5f686374 	svcpl	0x00686374
    132c:	696e6f6d 	stmdbvs	lr!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
    1330:	2f726f74 	svccs	0x00726f74
    1334:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
    1338:	732f6c65 			; <UNDEFINED> instruction: 0x732f6c65
    133c:	6d2f6372 	stcvs	3, cr6, [pc, #-456]!	; 117c <CPSR_IRQ_INHIBIT+0x10fc>
    1340:	726f6d65 	rsbvc	r6, pc, #6464	; 0x1940
    1344:	682f0079 	stmdavs	pc!, {r0, r3, r4, r5, r6}	; <UNPREDICTABLE>
    1348:	2f656d6f 	svccs	0x00656d6f
    134c:	686c6973 	stmdavs	ip!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
    1350:	6a797661 	bvs	1e5ecdc <_bss_end+0x1e52fe0>
    1354:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
    1358:	2f6c6f6f 	svccs	0x006c6f6f
    135c:	6f72655a 	svcvs	0x0072655a
    1360:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
    1364:	6178652f 	cmnvs	r8, pc, lsr #10
    1368:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
    136c:	33312f73 	teqcc	r1, #460	; 0x1cc
    1370:	6e6f632d 	cdpvs	3, 6, cr6, cr15, cr13, {1}
    1374:	74786574 	ldrbtvc	r6, [r8], #-1396	; 0xfffffa8c
    1378:	6977735f 	ldmdbvs	r7!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, sp, lr}^
    137c:	5f686374 	svcpl	0x00686374
    1380:	696e6f6d 	stmdbvs	lr!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
    1384:	2f726f74 	svccs	0x00726f74
    1388:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
    138c:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
    1390:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
    1394:	622f6564 	eorvs	r6, pc, #100, 10	; 0x19000000
    1398:	6472616f 	ldrbtvs	r6, [r2], #-367	; 0xfffffe91
    139c:	6970722f 	ldmdbvs	r0!, {r0, r1, r2, r3, r5, r9, ip, sp, lr}^
    13a0:	61682f30 	cmnvs	r8, r0, lsr pc
    13a4:	682f006c 	stmdavs	pc!, {r2, r3, r5, r6}	; <UNPREDICTABLE>
    13a8:	2f656d6f 	svccs	0x00656d6f
    13ac:	686c6973 	stmdavs	ip!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
    13b0:	6a797661 	bvs	1e5ed3c <_bss_end+0x1e53040>
    13b4:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
    13b8:	2f6c6f6f 	svccs	0x006c6f6f
    13bc:	6f72655a 	svcvs	0x0072655a
    13c0:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
    13c4:	6178652f 	cmnvs	r8, pc, lsr #10
    13c8:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
    13cc:	33312f73 	teqcc	r1, #460	; 0x1cc
    13d0:	6e6f632d 	cdpvs	3, 6, cr6, cr15, cr13, {1}
    13d4:	74786574 	ldrbtvc	r6, [r8], #-1396	; 0xfffffa8c
    13d8:	6977735f 	ldmdbvs	r7!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, sp, lr}^
    13dc:	5f686374 	svcpl	0x00686374
    13e0:	696e6f6d 	stmdbvs	lr!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
    13e4:	2f726f74 	svccs	0x00726f74
    13e8:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
    13ec:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
    13f0:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
    13f4:	6d2f6564 	cfstr32vs	mvfx6, [pc, #-400]!	; 126c <CPSR_IRQ_INHIBIT+0x11ec>
    13f8:	726f6d65 	rsbvc	r6, pc, #6464	; 0x1940
    13fc:	70000079 	andvc	r0, r0, r9, ror r0
    1400:	73656761 	cmnvc	r5, #25427968	; 0x1840000
    1404:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
    1408:	00000100 	andeq	r0, r0, r0, lsl #2
    140c:	64746e69 	ldrbtvs	r6, [r4], #-3689	; 0xfffff197
    1410:	682e6665 	stmdavs	lr!, {r0, r2, r5, r6, r9, sl, sp, lr}
    1414:	00000200 	andeq	r0, r0, r0, lsl #4
    1418:	69726570 	ldmdbvs	r2!, {r4, r5, r6, r8, sl, sp, lr}^
    141c:	72656870 	rsbvc	r6, r5, #112, 16	; 0x700000
    1420:	2e736c61 	cdpcs	12, 7, cr6, cr3, cr1, {3}
    1424:	00020068 	andeq	r0, r2, r8, rrx
    1428:	6d656d00 	stclvs	13, cr6, [r5, #-0]
    142c:	2e70616d 	rpwcssz	f6, f0, #5.0
    1430:	00030068 	andeq	r0, r3, r8, rrx
    1434:	67617000 	strbvs	r7, [r1, -r0]!
    1438:	682e7365 	stmdavs	lr!, {r0, r2, r5, r6, r8, r9, ip, sp, lr}
    143c:	00000300 	andeq	r0, r0, r0, lsl #6
    1440:	00420500 	subeq	r0, r2, r0, lsl #10
    1444:	9a140205 	bls	501c60 <_bss_end+0x4f5f64>
    1448:	05160000 	ldreq	r0, [r6, #-0]
    144c:	054b9f0e 	strbeq	r9, [fp, #-3854]	; 0xfffff0f2
    1450:	0e054d11 	mcreq	13, 0, r4, cr5, cr1, {0}
    1454:	65050583 	strvs	r0, [r5, #-1411]	; 0xfffffa7d
    1458:	05331405 	ldreq	r1, [r3, #-1029]!	; 0xfffffbfb
    145c:	09058312 	stmdbeq	r5, {r1, r4, r8, r9, pc}
    1460:	83160567 	tsthi	r6, #432013312	; 0x19c00000
    1464:	680e0583 	stmdavs	lr, {r0, r1, r7, r8, sl}
    1468:	7a030505 	bvc	c2884 <_bss_end+0xb6b88>
    146c:	030c0566 	movweq	r0, #50534	; 0xc566
    1470:	01052e09 	tsteq	r5, r9, lsl #28
    1474:	843c052f 	ldrthi	r0, [ip], #-1327	; 0xfffffad1
    1478:	059f0e05 	ldreq	r0, [pc, #3589]	; 2285 <CPSR_IRQ_INHIBIT+0x2205>
    147c:	0e054d11 	mcreq	13, 0, r4, cr5, cr1, {0}
    1480:	65050583 	strvs	r0, [r5, #-1411]	; 0xfffffa7d
    1484:	05331405 	ldreq	r1, [r3, #-1029]!	; 0xfffffbfb
    1488:	16058309 	strne	r8, [r5], -r9, lsl #6
    148c:	840e0583 	strhi	r0, [lr], #-1411	; 0xfffffa7d
    1490:	05620505 	strbeq	r0, [r2, #-1285]!	; 0xfffffafb
    1494:	0105350c 	tsteq	r5, ip, lsl #10
    1498:	0e05842f 	cdpeq	4, 0, cr8, cr5, cr15, {1}
    149c:	00150585 	andseq	r0, r5, r5, lsl #11
    14a0:	4a030402 	bmi	c24b0 <_bss_end+0xb67b4>
    14a4:	02001705 	andeq	r1, r0, #1310720	; 0x140000
    14a8:	052e0304 	streq	r0, [lr, #-772]!	; 0xfffffcfc
    14ac:	04020019 	streq	r0, [r2], #-25	; 0xffffffe7
    14b0:	05056702 	streq	r6, [r5, #-1794]	; 0xfffff8fe
    14b4:	02040200 	andeq	r0, r4, #0, 4
    14b8:	8601059d 			; <UNDEFINED> instruction: 0x8601059d
    14bc:	d70505bd 			; <UNDEFINED> instruction: 0xd70505bd
    14c0:	05674405 	strbeq	r4, [r7, #-1029]!	; 0xfffffbfb
    14c4:	21058235 	tstcs	r5, r5, lsr r2
    14c8:	8230054a 	eorshi	r0, r0, #310378496	; 0x12800000
    14cc:	23080105 	movwcs	r0, #33029	; 0x8105
    14d0:	052d4605 	streq	r4, [sp, #-1541]!	; 0xfffff9fb
    14d4:	33058237 	movwcc	r8, #21047	; 0x5237
    14d8:	2e21054a 	cfsh64cs	mvdx0, mvdx1, #42
    14dc:	05823005 	streq	r3, [r2, #5]
    14e0:	69210801 	stmdbvs	r1!, {r0, fp}
    14e4:	05890c05 	streq	r0, [r9, #3077]	; 0xc05
    14e8:	04020013 	streq	r0, [r2], #-19	; 0xffffffed
    14ec:	1b054a01 	blne	153cf8 <_bss_end+0x147ffc>
    14f0:	82090585 	andhi	r0, r9, #557842432	; 0x21400000
    14f4:	054d1405 	strbeq	r1, [sp, #-1029]	; 0xfffffbfb
    14f8:	0402001b 	streq	r0, [r2], #-27	; 0xffffffe5
    14fc:	2e054a01 	vmlacs.f32	s8, s10, s2
    1500:	82160568 	andshi	r0, r6, #104, 10	; 0x1a000000
    1504:	052e3505 	streq	r3, [lr, #-1285]!	; 0xfffffafb
    1508:	11056630 	tstne	r5, r0, lsr r6
    150c:	4d30052e 	cfldr32mi	mvfx0, [r0, #-184]!	; 0xffffff48
    1510:	054a2405 	strbeq	r2, [sl, #-1029]	; 0xfffffbfb
    1514:	2b056719 	blcs	15b180 <_bss_end+0x14f484>
    1518:	4a3d0583 	bmi	f42b2c <_bss_end+0xf36e30>
    151c:	02000d05 	andeq	r0, r0, #320	; 0x140
    1520:	79030204 	stmdbvc	r3, {r2, r9}
    1524:	0005054a 	andeq	r0, r5, sl, asr #10
    1528:	03020402 	movweq	r0, #9218	; 0x2402
    152c:	0c05827a 	sfmeq	f0, 1, [r5], {122}	; 0x7a
    1530:	05821303 	streq	r1, [r2, #771]	; 0x303
    1534:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
    1538:	0105a109 	tsteq	r5, r9, lsl #2
    153c:	009e66bb 			; <UNDEFINED> instruction: 0x009e66bb
    1540:	06010402 	streq	r0, [r1], -r2, lsl #8
    1544:	060f0566 	streq	r0, [pc], -r6, ror #10
    1548:	827fa103 	rsbshi	sl, pc, #-1073741824	; 0xc0000000
    154c:	df030105 	svcle	0x00030105
    1550:	4a9e4a00 	bmi	fe793d58 <_bss_end+0xfe78805c>
    1554:	01000a02 	tsteq	r0, r2, lsl #20
    1558:	0004be01 	andeq	fp, r4, r1, lsl #28
    155c:	5d000300 	stcpl	3, cr0, [r0, #-0]
    1560:	02000002 	andeq	r0, r0, #2
    1564:	0d0efb01 	vstreq	d15, [lr, #-4]
    1568:	01010100 	mrseq	r0, (UNDEF: 17)
    156c:	00000001 	andeq	r0, r0, r1
    1570:	01000001 	tsteq	r0, r1
    1574:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 14c0 <CPSR_IRQ_INHIBIT+0x1440>
    1578:	69732f65 	ldmdbvs	r3!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
    157c:	7661686c 	strbtvc	r6, [r1], -ip, ror #16
    1580:	532f6a79 			; <UNDEFINED> instruction: 0x532f6a79
    1584:	6f6f6863 	svcvs	0x006f6863
    1588:	655a2f6c 	ldrbvs	r2, [sl, #-3948]	; 0xfffff094
    158c:	614d6f72 	hvcvs	55026	; 0xd6f2
    1590:	652f6574 	strvs	r6, [pc, #-1396]!	; 1024 <CPSR_IRQ_INHIBIT+0xfa4>
    1594:	706d6178 	rsbvc	r6, sp, r8, ror r1
    1598:	2f73656c 	svccs	0x0073656c
    159c:	632d3331 			; <UNDEFINED> instruction: 0x632d3331
    15a0:	65746e6f 	ldrbvs	r6, [r4, #-3695]!	; 0xfffff191
    15a4:	735f7478 	cmpvc	pc, #120, 8	; 0x78000000
    15a8:	63746977 	cmnvs	r4, #1949696	; 0x1dc000
    15ac:	6f6d5f68 	svcvs	0x006d5f68
    15b0:	6f74696e 	svcvs	0x0074696e
    15b4:	656b2f72 	strbvs	r2, [fp, #-3954]!	; 0xfffff08e
    15b8:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
    15bc:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
    15c0:	6f72702f 	svcvs	0x0072702f
    15c4:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    15c8:	6f682f00 	svcvs	0x00682f00
    15cc:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
    15d0:	61686c69 	cmnvs	r8, r9, ror #24
    15d4:	2f6a7976 	svccs	0x006a7976
    15d8:	6f686353 	svcvs	0x00686353
    15dc:	5a2f6c6f 	bpl	bdc7a0 <_bss_end+0xbd0aa4>
    15e0:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 1454 <CPSR_IRQ_INHIBIT+0x13d4>
    15e4:	2f657461 	svccs	0x00657461
    15e8:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
    15ec:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
    15f0:	2d33312f 	ldfcss	f3, [r3, #-188]!	; 0xffffff44
    15f4:	746e6f63 	strbtvc	r6, [lr], #-3939	; 0xfffff09d
    15f8:	5f747865 	svcpl	0x00747865
    15fc:	74697773 	strbtvc	r7, [r9], #-1907	; 0xfffff88d
    1600:	6d5f6863 	ldclvs	8, cr6, [pc, #-396]	; 147c <CPSR_IRQ_INHIBIT+0x13fc>
    1604:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
    1608:	6b2f726f 	blvs	bddfcc <_bss_end+0xbd22d0>
    160c:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
    1610:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
    1614:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
    1618:	656d2f65 	strbvs	r2, [sp, #-3941]!	; 0xfffff09b
    161c:	79726f6d 	ldmdbvc	r2!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
    1620:	6f682f00 	svcvs	0x00682f00
    1624:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
    1628:	61686c69 	cmnvs	r8, r9, ror #24
    162c:	2f6a7976 	svccs	0x006a7976
    1630:	6f686353 	svcvs	0x00686353
    1634:	5a2f6c6f 	bpl	bdc7f8 <_bss_end+0xbd0afc>
    1638:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 14ac <CPSR_IRQ_INHIBIT+0x142c>
    163c:	2f657461 	svccs	0x00657461
    1640:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
    1644:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
    1648:	2d33312f 	ldfcss	f3, [r3, #-188]!	; 0xffffff44
    164c:	746e6f63 	strbtvc	r6, [lr], #-3939	; 0xfffff09d
    1650:	5f747865 	svcpl	0x00747865
    1654:	74697773 	strbtvc	r7, [r9], #-1907	; 0xfffff88d
    1658:	6d5f6863 	ldclvs	8, cr6, [pc, #-396]	; 14d4 <CPSR_IRQ_INHIBIT+0x1454>
    165c:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
    1660:	6b2f726f 	blvs	bde024 <_bss_end+0xbd2328>
    1664:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
    1668:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
    166c:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
    1670:	6f622f65 	svcvs	0x00622f65
    1674:	2f647261 	svccs	0x00647261
    1678:	30697072 	rsbcc	r7, r9, r2, ror r0
    167c:	6c61682f 	stclvs	8, cr6, [r1], #-188	; 0xffffff44
    1680:	6f682f00 	svcvs	0x00682f00
    1684:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
    1688:	61686c69 	cmnvs	r8, r9, ror #24
    168c:	2f6a7976 	svccs	0x006a7976
    1690:	6f686353 	svcvs	0x00686353
    1694:	5a2f6c6f 	bpl	bdc858 <_bss_end+0xbd0b5c>
    1698:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 150c <CPSR_IRQ_INHIBIT+0x148c>
    169c:	2f657461 	svccs	0x00657461
    16a0:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
    16a4:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
    16a8:	2d33312f 	ldfcss	f3, [r3, #-188]!	; 0xffffff44
    16ac:	746e6f63 	strbtvc	r6, [lr], #-3939	; 0xfffff09d
    16b0:	5f747865 	svcpl	0x00747865
    16b4:	74697773 	strbtvc	r7, [r9], #-1907	; 0xfffff88d
    16b8:	6d5f6863 	ldclvs	8, cr6, [pc, #-396]	; 1534 <CPSR_IRQ_INHIBIT+0x14b4>
    16bc:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
    16c0:	6b2f726f 	blvs	bde084 <_bss_end+0xbd2388>
    16c4:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
    16c8:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
    16cc:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
    16d0:	72702f65 	rsbsvc	r2, r0, #404	; 0x194
    16d4:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    16d8:	682f0073 	stmdavs	pc!, {r0, r1, r4, r5, r6}	; <UNPREDICTABLE>
    16dc:	2f656d6f 	svccs	0x00656d6f
    16e0:	686c6973 	stmdavs	ip!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
    16e4:	6a797661 	bvs	1e5f070 <_bss_end+0x1e53374>
    16e8:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
    16ec:	2f6c6f6f 	svccs	0x006c6f6f
    16f0:	6f72655a 	svcvs	0x0072655a
    16f4:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
    16f8:	6178652f 	cmnvs	r8, pc, lsr #10
    16fc:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
    1700:	33312f73 	teqcc	r1, #460	; 0x1cc
    1704:	6e6f632d 	cdpvs	3, 6, cr6, cr15, cr13, {1}
    1708:	74786574 	ldrbtvc	r6, [r8], #-1396	; 0xfffffa8c
    170c:	6977735f 	ldmdbvs	r7!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, sp, lr}^
    1710:	5f686374 	svcpl	0x00686374
    1714:	696e6f6d 	stmdbvs	lr!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
    1718:	2f726f74 	svccs	0x00726f74
    171c:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
    1720:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
    1724:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
    1728:	642f6564 	strtvs	r6, [pc], #-1380	; 1730 <CPSR_IRQ_INHIBIT+0x16b0>
    172c:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
    1730:	00007372 	andeq	r7, r0, r2, ror r3
    1734:	636f7270 	cmnvs	pc, #112, 4
    1738:	5f737365 	svcpl	0x00737365
    173c:	616e616d 	cmnvs	lr, sp, ror #2
    1740:	2e726567 	cdpcs	5, 7, cr6, cr2, cr7, {3}
    1744:	00707063 	rsbseq	r7, r0, r3, rrx
    1748:	6b000001 	blvs	1754 <CPSR_IRQ_INHIBIT+0x16d4>
    174c:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
    1750:	65685f6c 	strbvs	r5, [r8, #-3948]!	; 0xfffff094
    1754:	682e7061 	stmdavs	lr!, {r0, r5, r6, ip, sp, lr}
    1758:	00000200 	andeq	r0, r0, r0, lsl #4
    175c:	64746e69 	ldrbtvs	r6, [r4], #-3689	; 0xfffff197
    1760:	682e6665 	stmdavs	lr!, {r0, r2, r5, r6, r9, sl, sp, lr}
    1764:	00000300 	andeq	r0, r0, r0, lsl #6
    1768:	636f7270 	cmnvs	pc, #112, 4
    176c:	2e737365 	cdpcs	3, 7, cr7, cr3, cr5, {3}
    1770:	00040068 	andeq	r0, r4, r8, rrx
    1774:	6f727000 	svcvs	0x00727000
    1778:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    177c:	6e616d5f 	mcrvs	13, 3, r6, cr1, cr15, {2}
    1780:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
    1784:	0400682e 	streq	r6, [r0], #-2094	; 0xfffff7d2
    1788:	6f6d0000 	svcvs	0x006d0000
    178c:	6f74696e 	svcvs	0x0074696e
    1790:	00682e72 	rsbeq	r2, r8, r2, ror lr
    1794:	70000005 	andvc	r0, r0, r5
    1798:	70697265 	rsbvc	r7, r9, r5, ror #4
    179c:	61726568 	cmnvs	r2, r8, ror #10
    17a0:	682e736c 	stmdavs	lr!, {r2, r3, r5, r6, r8, r9, ip, sp, lr}
    17a4:	00000300 	andeq	r0, r0, r0, lsl #6
    17a8:	6d6d656d 	cfstr64vs	mvdx6, [sp, #-436]!	; 0xfffffe4c
    17ac:	682e7061 	stmdavs	lr!, {r0, r5, r6, ip, sp, lr}
    17b0:	00000200 	andeq	r0, r0, r0, lsl #4
    17b4:	65676170 	strbvs	r6, [r7, #-368]!	; 0xfffffe90
    17b8:	00682e73 	rsbeq	r2, r8, r3, ror lr
    17bc:	00000002 	andeq	r0, r0, r2
    17c0:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
    17c4:	009e1402 	addseq	r1, lr, r2, lsl #8
    17c8:	01110300 	tsteq	r1, r0, lsl #6
    17cc:	05834c05 	streq	r4, [r3, #3077]	; 0xc05
    17d0:	a1230801 			; <UNDEFINED> instruction: 0xa1230801
    17d4:	05830c05 	streq	r0, [r3, #3077]	; 0xc05
    17d8:	21054a1f 	tstcs	r5, pc, lsl sl
    17dc:	01040200 	mrseq	r0, R12_usr
    17e0:	001f054a 	andseq	r0, pc, sl, asr #10
    17e4:	4a010402 	bmi	427f4 <_bss_end+0x36af8>
    17e8:	02003c05 	andeq	r3, r0, #1280	; 0x500
    17ec:	052e0104 	streq	r0, [lr, #-260]!	; 0xfffffefc
    17f0:	0402001f 	streq	r0, [r2], #-31	; 0xffffffe1
    17f4:	01052e02 	tsteq	r5, r2, lsl #28
    17f8:	05040200 	streq	r0, [r4, #-512]	; 0xfffffe00
    17fc:	4805852f 	stmdami	r5, {r0, r1, r2, r3, r5, r8, sl, pc}
    1800:	84160583 	ldrhi	r0, [r6], #-1411	; 0xfffffa7d
    1804:	4b4a1405 	blmi	1286820 <_bss_end+0x127ab24>
    1808:	05670905 	strbeq	r0, [r7, #-2309]!	; 0xfffff6fb
    180c:	09054a05 	stmdbeq	r5, {r0, r2, r9, fp, lr}
    1810:	4a22054c 	bmi	882d48 <_bss_end+0x87704c>
    1814:	056a1c05 	strbeq	r1, [sl, #-3077]!	; 0xfffff3fb
    1818:	14056934 	strne	r6, [r5], #-2356	; 0xfffff6cc
    181c:	4c0b0566 	cfstr32mi	mvfx0, [fp], {102}	; 0x66
    1820:	05681305 	strbeq	r1, [r8, #-773]!	; 0xfffffcfb
    1824:	0f054a11 	svceq	0x00054a11
    1828:	4a13052e 	bmi	4c2ce8 <_bss_end+0x4b6fec>
    182c:	054a0f05 	strbeq	r0, [sl, #-3845]	; 0xfffff0fb
    1830:	05674b21 	strbeq	r4, [r7, #-2849]!	; 0xfffff4df
    1834:	11054a19 	tstne	r5, r9, lsl sl
    1838:	681a054b 	ldmdavs	sl, {r0, r1, r3, r6, r8, sl}
    183c:	054a1805 	strbeq	r1, [sl, #-2053]	; 0xfffff7fb
    1840:	05854b01 	streq	r4, [r5, #2817]	; 0xb01
    1844:	16059f48 	strne	r9, [r5], -r8, asr #30
    1848:	4a140584 	bmi	502e60 <_bss_end+0x4f7164>
    184c:	6705054b 	strvs	r0, [r5, -fp, asr #10]
    1850:	054a1e05 	strbeq	r1, [sl, #-3589]	; 0xfffff1fb
    1854:	09054b18 	stmdbeq	r5, {r3, r4, r8, r9, fp, lr}
    1858:	4a050568 	bmi	142e00 <_bss_end+0x137104>
    185c:	054c1c05 	strbeq	r1, [ip, #-3077]	; 0xfffff3fb
    1860:	14056934 	strne	r6, [r5], #-2356	; 0xfffff6cc
    1864:	4c0b0566 	cfstr32mi	mvfx0, [fp], {102}	; 0x66
    1868:	05681305 	strbeq	r1, [r8, #-773]!	; 0xfffffcfb
    186c:	0f054a11 	svceq	0x00054a11
    1870:	4a13052e 	bmi	4c2d30 <_bss_end+0x4b7034>
    1874:	054a0f05 	strbeq	r0, [sl, #-3845]	; 0xfffff0fb
    1878:	05674b21 	strbeq	r4, [r7, #-2849]!	; 0xfffff4df
    187c:	11054a19 	tstne	r5, r9, lsl sl
    1880:	681a054b 	ldmdavs	sl, {r0, r1, r3, r6, r8, sl}
    1884:	674f0567 	strbvs	r0, [pc, -r7, ror #10]
    1888:	05665305 	strbeq	r5, [r6, #-773]!	; 0xfffffcfb
    188c:	12052e1a 	andne	r2, r5, #416	; 0x1a0
    1890:	4b01054c 	blmi	42dc8 <_bss_end+0x370cc>
    1894:	840905bd 	strhi	r0, [r9], #-1469	; 0xfffffa43
    1898:	054a0505 	strbeq	r0, [sl, #-1285]	; 0xfffffafb
    189c:	1d054d09 	stcne	13, cr4, [r5, #-36]	; 0xffffffdc
    18a0:	2e23054a 	cfsh64cs	mvdx0, mvdx3, #42
    18a4:	052e3005 	streq	r3, [lr, #-5]!
    18a8:	21054c0d 	tstcs	r5, sp, lsl #24
    18ac:	2e27054a 	cfsh64cs	mvdx0, mvdx7, #42
    18b0:	052e0905 	streq	r0, [lr, #-2309]!	; 0xfffff6fb
    18b4:	0402003c 	streq	r0, [r2], #-60	; 0xffffffc4
    18b8:	50054a01 	andpl	r4, r5, r1, lsl #20
    18bc:	01040200 	mrseq	r0, R12_usr
    18c0:	0056054a 	subseq	r0, r6, sl, asr #10
    18c4:	2e010402 	cdpcs	4, 0, cr0, cr1, cr2, {0}
    18c8:	02003905 	andeq	r3, r0, #81920	; 0x14000
    18cc:	052e0104 	streq	r0, [lr, #-260]!	; 0xfffffefc
    18d0:	33055120 	movwcc	r5, #20768	; 0x5120
    18d4:	0035054a 	eorseq	r0, r5, sl, asr #10
    18d8:	4a010402 	bmi	428e8 <_bss_end+0x36bec>
    18dc:	02003305 	andeq	r3, r0, #335544320	; 0x14000000
    18e0:	004a0104 	subeq	r0, sl, r4, lsl #2
    18e4:	06020402 	streq	r0, [r2], -r2, lsl #8
    18e8:	0019054a 	andseq	r0, r9, sl, asr #10
    18ec:	06040402 	streq	r0, [r4], -r2, lsl #8
    18f0:	0005054a 	andeq	r0, r5, sl, asr #10
    18f4:	2f040402 	svccs	0x00040402
    18f8:	05670e05 	strbeq	r0, [r7, #-3589]!	; 0xfffff1fb
    18fc:	18056a12 	stmdane	r5, {r1, r4, r9, fp, sp, lr}
    1900:	2e64054a 	cdpcs	5, 6, cr0, cr4, cr10, {2}
    1904:	02004005 	andeq	r4, r0, #5
    1908:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
    190c:	04020046 	streq	r0, [r2], #-70	; 0xffffffba
    1910:	37054a01 	strcc	r4, [r5, -r1, lsl #20]
    1914:	01040200 	mrseq	r0, R12_usr
    1918:	006d052e 	rsbeq	r0, sp, lr, lsr #10
    191c:	4a020402 	bmi	8292c <_bss_end+0x76c30>
    1920:	02007305 	andeq	r7, r0, #335544320	; 0x14000000
    1924:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
    1928:	04020064 	streq	r0, [r2], #-100	; 0xffffff9c
    192c:	09052e02 	stmdbeq	r5, {r1, r9, sl, fp, sp}
    1930:	6812054c 	ldmdavs	r2, {r2, r3, r6, r8, sl}
    1934:	05670d05 	strbeq	r0, [r7, #-3333]!	; 0xfffff2fb
    1938:	05053112 	streq	r3, [r5, #-274]	; 0xfffffeee
    193c:	05667803 	strbeq	r7, [r6, #-2051]!	; 0xfffff7fd
    1940:	2e0c0311 	mcrcs	3, 0, r0, cr12, cr1, {0}
    1944:	054a0505 	strbeq	r0, [sl, #-1285]	; 0xfffffafb
    1948:	47056933 	smladxmi	r5, r3, r9, r6
    194c:	2e09054a 	cfsh32cs	mvfx0, mvfx9, #42
    1950:	054a1d05 	strbeq	r1, [sl, #-3333]	; 0xfffff2fb
    1954:	31052e4d 	tstcc	r5, sp, asr #28
    1958:	2f09052e 	svccs	0x0009052e
    195c:	05320e05 	ldreq	r0, [r2, #-3589]!	; 0xfffff1fb
    1960:	8260030d 	rsbhi	r0, r0, #872415232	; 0x34000000
    1964:	21030105 	tstcs	r3, r5, lsl #2
    1968:	09054d2e 	stmdbeq	r5, {r1, r2, r3, r5, r8, sl, fp, lr}
    196c:	4a1d05a1 	bmi	742ff8 <_bss_end+0x7372fc>
    1970:	052e2305 	streq	r2, [lr, #-773]!	; 0xfffffcfb
    1974:	09052e05 	stmdbeq	r5, {r0, r2, r9, sl, fp, sp}
    1978:	4a1d054b 	bmi	742eac <_bss_end+0x7371b0>
    197c:	052e2905 	streq	r2, [lr, #-2309]!	; 0xfffff6fb
    1980:	19054d05 	stmdbne	r5, {r0, r2, r8, sl, fp, lr}
    1984:	2e2d054a 	cfsh64cs	mvdx0, mvdx13, #42
    1988:	054c1a05 	strbeq	r1, [ip, #-2565]	; 0xfffff5fb
    198c:	13054a2e 	movwne	r4, #23086	; 0x5a2e
    1990:	2f21052e 	svccs	0x0021052e
    1994:	054a2705 	strbeq	r2, [sl, #-1797]	; 0xfffff8fb
    1998:	18052e0a 	stmdane	r5, {r1, r3, r9, sl, fp, sp}
    199c:	672f0585 	strvs	r0, [pc, -r5, lsl #11]!
    19a0:	054a4305 	strbeq	r4, [sl, #-773]	; 0xfffffcfb
    19a4:	19052e05 	stmdbne	r5, {r0, r2, r9, sl, fp, sp}
    19a8:	2e49054a 	cdpcs	5, 4, cr0, cr9, cr10, {2}
    19ac:	052e2d05 	streq	r2, [lr, #-3333]!	; 0xfffff2fb
    19b0:	19052f05 	stmdbne	r5, {r0, r2, r8, r9, sl, fp, sp}
    19b4:	2e25054a 	cfsh64cs	mvdx0, mvdx5, #42
    19b8:	054d0505 	strbeq	r0, [sp, #-1285]	; 0xfffffafb
    19bc:	1d056725 	stcne	7, cr6, [r5, #-148]	; 0xffffff6c
    19c0:	6901054a 	stmdbvs	r1, {r1, r3, r6, r8, sl}
    19c4:	052d1f05 	streq	r1, [sp, #-3845]!	; 0xfffff0fb
    19c8:	01054a17 	tsteq	r5, r7, lsl sl
    19cc:	009e6667 	addseq	r6, lr, r7, ror #12
    19d0:	06010402 	streq	r0, [r1], -r2, lsl #8
    19d4:	06120566 	ldreq	r0, [r2], -r6, ror #10
    19d8:	827ef703 	rsbshi	pc, lr, #786432	; 0xc0000
    19dc:	89030105 	stmdbhi	r3, {r0, r2, r8}
    19e0:	4a9e4a01 	bmi	fe7941ec <_bss_end+0xfe7884f0>
    19e4:	01000a02 	tsteq	r0, r2, lsl #20
    19e8:	05020401 	streq	r0, [r2, #-1025]	; 0xfffffbff
    19ec:	0205000c 	andeq	r0, r5, #12
    19f0:	0000a3a0 	andeq	sl, r0, r0, lsr #7
    19f4:	05011d03 	streq	r1, [r1, #-3331]	; 0xfffff2fd
    19f8:	0905842e 	stmdbeq	r5, {r1, r2, r3, r5, sl, pc}
    19fc:	00060283 	andeq	r0, r6, r3, lsl #5
    1a00:	02040101 	andeq	r0, r4, #1073741824	; 0x40000000
    1a04:	05000c05 	streq	r0, [r0, #-3077]	; 0xfffff3fb
    1a08:	00a3cc02 	adceq	ip, r3, r2, lsl #24
    1a0c:	011d0300 	tsteq	sp, r0, lsl #6
    1a10:	05842e05 	streq	r2, [r4, #3589]	; 0xe05
    1a14:	06028309 	streq	r8, [r2], -r9, lsl #6
    1a18:	9d010100 	stflss	f0, [r1, #-0]
    1a1c:	03000000 	movweq	r0, #0
    1a20:	00007400 	andeq	r7, r0, r0, lsl #8
    1a24:	fb010200 	blx	4222e <_bss_end+0x36532>
    1a28:	01000d0e 	tsteq	r0, lr, lsl #26
    1a2c:	00010101 	andeq	r0, r1, r1, lsl #2
    1a30:	00010000 	andeq	r0, r1, r0
    1a34:	682f0100 	stmdavs	pc!, {r8}	; <UNPREDICTABLE>
    1a38:	2f656d6f 	svccs	0x00656d6f
    1a3c:	686c6973 	stmdavs	ip!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
    1a40:	6a797661 	bvs	1e5f3cc <_bss_end+0x1e536d0>
    1a44:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
    1a48:	2f6c6f6f 	svccs	0x006c6f6f
    1a4c:	6f72655a 	svcvs	0x0072655a
    1a50:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
    1a54:	6178652f 	cmnvs	r8, pc, lsr #10
    1a58:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
    1a5c:	33312f73 	teqcc	r1, #460	; 0x1cc
    1a60:	6e6f632d 	cdpvs	3, 6, cr6, cr15, cr13, {1}
    1a64:	74786574 	ldrbtvc	r6, [r8], #-1396	; 0xfffffa8c
    1a68:	6977735f 	ldmdbvs	r7!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, sp, lr}^
    1a6c:	5f686374 	svcpl	0x00686374
    1a70:	696e6f6d 	stmdbvs	lr!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
    1a74:	2f726f74 	svccs	0x00726f74
    1a78:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
    1a7c:	732f6c65 			; <UNDEFINED> instruction: 0x732f6c65
    1a80:	702f6372 	eorvc	r6, pc, r2, ror r3	; <UNPREDICTABLE>
    1a84:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    1a88:	00007373 	andeq	r7, r0, r3, ror r3
    1a8c:	74697773 	strbtvc	r7, [r9], #-1907	; 0xfffff88d
    1a90:	732e6863 			; <UNDEFINED> instruction: 0x732e6863
    1a94:	00000100 	andeq	r0, r0, r0, lsl #2
    1a98:	02050000 	andeq	r0, r5, #0
    1a9c:	0000a3f8 	strdeq	sl, [r0], -r8
    1aa0:	2f362f16 	svccs	0x00362f16
    1aa4:	302f2f2f 	eorcc	r2, pc, pc, lsr #30
    1aa8:	352f2f2f 	strcc	r2, [pc, #-3887]!	; b81 <CPSR_IRQ_INHIBIT+0xb01>
    1aac:	2f2f2f2f 	svccs	0x002f2f2f
    1ab0:	2f2f2f30 	svccs	0x002f2f30
    1ab4:	022f2f2f 	eoreq	r2, pc, #47, 30	; 0xbc
    1ab8:	01010002 	tsteq	r1, r2
    1abc:	000000c8 	andeq	r0, r0, r8, asr #1
    1ac0:	006b0003 	rsbeq	r0, fp, r3
    1ac4:	01020000 	mrseq	r0, (UNDEF: 2)
    1ac8:	000d0efb 	strdeq	r0, [sp], -fp
    1acc:	01010101 	tsteq	r1, r1, lsl #2
    1ad0:	01000000 	mrseq	r0, (UNDEF: 0)
    1ad4:	2f010000 	svccs	0x00010000
    1ad8:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
    1adc:	6c69732f 	stclvs	3, cr7, [r9], #-188	; 0xffffff44
    1ae0:	79766168 	ldmdbvc	r6!, {r3, r5, r6, r8, sp, lr}^
    1ae4:	63532f6a 	cmpvs	r3, #424	; 0x1a8
    1ae8:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; 1950 <CPSR_IRQ_INHIBIT+0x18d0>
    1aec:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
    1af0:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
    1af4:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
    1af8:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
    1afc:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
    1b00:	6f632d33 	svcvs	0x00632d33
    1b04:	7865746e 	stmdavc	r5!, {r1, r2, r3, r5, r6, sl, ip, sp, lr}^
    1b08:	77735f74 			; <UNDEFINED> instruction: 0x77735f74
    1b0c:	68637469 	stmdavs	r3!, {r0, r3, r5, r6, sl, ip, sp, lr}^
    1b10:	6e6f6d5f 	mcrvs	13, 3, r6, cr15, cr15, {2}
    1b14:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
    1b18:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
    1b1c:	2f6c656e 	svccs	0x006c656e
    1b20:	00637273 	rsbeq	r7, r3, r3, ror r2
    1b24:	61747300 	cmnvs	r4, r0, lsl #6
    1b28:	732e7472 			; <UNDEFINED> instruction: 0x732e7472
    1b2c:	00000100 	andeq	r0, r0, r0, lsl #2
    1b30:	02050000 	andeq	r0, r5, #0
    1b34:	00008000 	andeq	r8, r0, r0
    1b38:	2f010d03 	svccs	0x00010d03
    1b3c:	2f2f2f2f 	svccs	0x002f2f2f
    1b40:	1f032f2f 	svcne	0x00032f2f
    1b44:	322f2008 	eorcc	r2, pc, #8
    1b48:	312f2f2f 			; <UNDEFINED> instruction: 0x312f2f2f
    1b4c:	312f2f31 			; <UNDEFINED> instruction: 0x312f2f31
    1b50:	2f312f2f 	svccs	0x00312f2f
    1b54:	2f2f312f 	svccs	0x002f312f
    1b58:	302f2f31 	eorcc	r2, pc, r1, lsr pc	; <UNPREDICTABLE>
    1b5c:	302f2f2f 	eorcc	r2, pc, pc, lsr #30
    1b60:	01000202 	tsteq	r0, r2, lsl #4
    1b64:	02050001 	andeq	r0, r5, #1
    1b68:	0000a454 	andeq	sl, r0, r4, asr r4
    1b6c:	0100e503 	tsteq	r0, r3, lsl #10
    1b70:	2f2f2f2f 	svccs	0x002f2f2f
    1b74:	32312f32 	eorscc	r2, r1, #50, 30	; 0xc8
    1b78:	302f2f2f 	eorcc	r2, pc, pc, lsr #30
    1b7c:	3030302f 	eorscc	r3, r0, pc, lsr #32
    1b80:	0233332f 	eorseq	r3, r3, #-1140850688	; 0xbc000000
    1b84:	01010002 	tsteq	r1, r2
    1b88:	000000f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    1b8c:	006f0003 	rsbeq	r0, pc, r3
    1b90:	01020000 	mrseq	r0, (UNDEF: 2)
    1b94:	000d0efb 	strdeq	r0, [sp], -fp
    1b98:	01010101 	tsteq	r1, r1, lsl #2
    1b9c:	01000000 	mrseq	r0, (UNDEF: 0)
    1ba0:	2f010000 	svccs	0x00010000
    1ba4:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
    1ba8:	6c69732f 	stclvs	3, cr7, [r9], #-188	; 0xffffff44
    1bac:	79766168 	ldmdbvc	r6!, {r3, r5, r6, r8, sp, lr}^
    1bb0:	63532f6a 	cmpvs	r3, #424	; 0x1a8
    1bb4:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; 1a1c <CPSR_IRQ_INHIBIT+0x199c>
    1bb8:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
    1bbc:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
    1bc0:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
    1bc4:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
    1bc8:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
    1bcc:	6f632d33 	svcvs	0x00632d33
    1bd0:	7865746e 	stmdavc	r5!, {r1, r2, r3, r5, r6, sl, ip, sp, lr}^
    1bd4:	77735f74 			; <UNDEFINED> instruction: 0x77735f74
    1bd8:	68637469 	stmdavs	r3!, {r0, r3, r5, r6, sl, ip, sp, lr}^
    1bdc:	6e6f6d5f 	mcrvs	13, 3, r6, cr15, cr15, {2}
    1be0:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
    1be4:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
    1be8:	2f6c656e 	svccs	0x006c656e
    1bec:	00637273 	rsbeq	r7, r3, r3, ror r2
    1bf0:	61747300 	cmnvs	r4, r0, lsl #6
    1bf4:	70757472 	rsbsvc	r7, r5, r2, ror r4
    1bf8:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
    1bfc:	00000100 	andeq	r0, r0, r0, lsl #2
    1c00:	00010500 	andeq	r0, r1, r0, lsl #10
    1c04:	a4a40205 	strtge	r0, [r4], #517	; 0x205
    1c08:	14030000 	strne	r0, [r3], #-0
    1c0c:	6a090501 	bvs	243018 <_bss_end+0x23731c>
    1c10:	02001f05 	andeq	r1, r0, #5, 30
    1c14:	05660304 	strbeq	r0, [r6, #-772]!	; 0xfffffcfc
    1c18:	04020006 	streq	r0, [r2], #-6
    1c1c:	0205bb02 	andeq	fp, r5, #2048	; 0x800
    1c20:	02040200 	andeq	r0, r4, #0, 4
    1c24:	85090565 	strhi	r0, [r9, #-1381]	; 0xfffffa9b
    1c28:	bd2f0105 	stflts	f0, [pc, #-20]!	; 1c1c <CPSR_IRQ_INHIBIT+0x1b9c>
    1c2c:	056b0d05 	strbeq	r0, [fp, #-3333]!	; 0xfffff2fb
    1c30:	04020024 	streq	r0, [r2], #-36	; 0xffffffdc
    1c34:	04054a03 	streq	r4, [r5], #-2563	; 0xfffff5fd
    1c38:	02040200 	andeq	r0, r4, #0, 4
    1c3c:	000b0583 	andeq	r0, fp, r3, lsl #11
    1c40:	4a020402 	bmi	82c50 <_bss_end+0x76f54>
    1c44:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
    1c48:	052d0204 	streq	r0, [sp, #-516]!	; 0xfffffdfc
    1c4c:	01058509 	tsteq	r5, r9, lsl #10
    1c50:	0d05a12f 	stfeqd	f2, [r5, #-188]	; 0xffffff44
    1c54:	0024056a 	eoreq	r0, r4, sl, ror #10
    1c58:	4a030402 	bmi	c2c68 <_bss_end+0xb6f6c>
    1c5c:	02000405 	andeq	r0, r0, #83886080	; 0x5000000
    1c60:	05830204 	streq	r0, [r3, #516]	; 0x204
    1c64:	0402000b 	streq	r0, [r2], #-11
    1c68:	02054a02 	andeq	r4, r5, #8192	; 0x2000
    1c6c:	02040200 	andeq	r0, r4, #0, 4
    1c70:	8509052d 	strhi	r0, [r9, #-1325]	; 0xfffffad3
    1c74:	022f0105 	eoreq	r0, pc, #1073741825	; 0x40000001
    1c78:	0101000a 	tsteq	r1, sl
    1c7c:	00000131 	andeq	r0, r0, r1, lsr r1
    1c80:	00710003 	rsbseq	r0, r1, r3
    1c84:	01020000 	mrseq	r0, (UNDEF: 2)
    1c88:	000d0efb 	strdeq	r0, [sp], -fp
    1c8c:	01010101 	tsteq	r1, r1, lsl #2
    1c90:	01000000 	mrseq	r0, (UNDEF: 0)
    1c94:	2f010000 	svccs	0x00010000
    1c98:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
    1c9c:	6c69732f 	stclvs	3, cr7, [r9], #-188	; 0xffffff44
    1ca0:	79766168 	ldmdbvc	r6!, {r3, r5, r6, r8, sp, lr}^
    1ca4:	63532f6a 	cmpvs	r3, #424	; 0x1a8
    1ca8:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; 1b10 <CPSR_IRQ_INHIBIT+0x1a90>
    1cac:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
    1cb0:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
    1cb4:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
    1cb8:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
    1cbc:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
    1cc0:	6f632d33 	svcvs	0x00632d33
    1cc4:	7865746e 	stmdavc	r5!, {r1, r2, r3, r5, r6, sl, ip, sp, lr}^
    1cc8:	77735f74 			; <UNDEFINED> instruction: 0x77735f74
    1ccc:	68637469 	stmdavs	r3!, {r0, r3, r5, r6, sl, ip, sp, lr}^
    1cd0:	6e6f6d5f 	mcrvs	13, 3, r6, cr15, cr15, {2}
    1cd4:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
    1cd8:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
    1cdc:	2f62696c 	svccs	0x0062696c
    1ce0:	00637273 	rsbeq	r7, r3, r3, ror r2
    1ce4:	64747300 	ldrbtvs	r7, [r4], #-768	; 0xfffffd00
    1ce8:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
    1cec:	632e676e 			; <UNDEFINED> instruction: 0x632e676e
    1cf0:	01007070 	tsteq	r0, r0, ror r0
    1cf4:	05000000 	streq	r0, [r0, #-0]
    1cf8:	02050001 	andeq	r0, r5, #1
    1cfc:	0000a5bc 			; <UNDEFINED> instruction: 0x0000a5bc
    1d00:	bb06051a 	bllt	183170 <_bss_end+0x177474>
    1d04:	054c0f05 	strbeq	r0, [ip, #-3845]	; 0xfffff0fb
    1d08:	0a056821 	beq	15bd94 <_bss_end+0x150098>
    1d0c:	2e0b05ba 	mcrcs	5, 0, r0, cr11, cr10, {5}
    1d10:	054a2705 	strbeq	r2, [sl, #-1797]	; 0xfffff8fb
    1d14:	09054a0d 	stmdbeq	r5, {r0, r2, r3, r9, fp, lr}
    1d18:	9f04052f 	svcls	0x0004052f
    1d1c:	05620205 	strbeq	r0, [r2, #-517]!	; 0xfffffdfb
    1d20:	10053505 	andne	r3, r5, r5, lsl #10
    1d24:	2e110568 	cfmsc32cs	mvfx0, mvfx1, mvfx8
    1d28:	054a2205 	strbeq	r2, [sl, #-517]	; 0xfffffdfb
    1d2c:	0a052e13 	beq	14d580 <_bss_end+0x141884>
    1d30:	6909052f 	stmdbvs	r9, {r0, r1, r2, r3, r5, r8, sl}
    1d34:	052e0a05 	streq	r0, [lr, #-2565]!	; 0xfffff5fb
    1d38:	03054a0c 	movweq	r4, #23052	; 0x5a0c
    1d3c:	680b054b 	stmdavs	fp, {r0, r1, r3, r6, r8, sl}
    1d40:	02001805 	andeq	r1, r0, #327680	; 0x50000
    1d44:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
    1d48:	04020014 	streq	r0, [r2], #-20	; 0xffffffec
    1d4c:	15059e03 	strne	r9, [r5, #-3587]	; 0xfffff1fd
    1d50:	02040200 	andeq	r0, r4, #0, 4
    1d54:	00180568 	andseq	r0, r8, r8, ror #10
    1d58:	82020402 	andhi	r0, r2, #33554432	; 0x2000000
    1d5c:	02000805 	andeq	r0, r0, #327680	; 0x50000
    1d60:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
    1d64:	0402001a 	streq	r0, [r2], #-26	; 0xffffffe6
    1d68:	1b054b02 	blne	154978 <_bss_end+0x148c7c>
    1d6c:	02040200 	andeq	r0, r4, #0, 4
    1d70:	000c052e 	andeq	r0, ip, lr, lsr #10
    1d74:	4a020402 	bmi	82d84 <_bss_end+0x77088>
    1d78:	02000f05 	andeq	r0, r0, #5, 30
    1d7c:	05820204 	streq	r0, [r2, #516]	; 0x204
    1d80:	0402001b 	streq	r0, [r2], #-27	; 0xffffffe5
    1d84:	11054a02 	tstne	r5, r2, lsl #20
    1d88:	02040200 	andeq	r0, r4, #0, 4
    1d8c:	000a052e 	andeq	r0, sl, lr, lsr #10
    1d90:	2f020402 	svccs	0x00020402
    1d94:	02000b05 	andeq	r0, r0, #5120	; 0x1400
    1d98:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
    1d9c:	0402000d 	streq	r0, [r2], #-13
    1da0:	02054a02 	andeq	r4, r5, #8192	; 0x2000
    1da4:	02040200 	andeq	r0, r4, #0, 4
    1da8:	88010546 	stmdahi	r1, {r1, r2, r6, r8, sl}
    1dac:	01000802 	tsteq	r0, r2, lsl #16
    1db0:	00007901 	andeq	r7, r0, r1, lsl #18
    1db4:	46000300 	strmi	r0, [r0], -r0, lsl #6
    1db8:	02000000 	andeq	r0, r0, #0
    1dbc:	0d0efb01 	vstreq	d15, [lr, #-4]
    1dc0:	01010100 	mrseq	r0, (UNDEF: 17)
    1dc4:	00000001 	andeq	r0, r0, r1
    1dc8:	01000001 	tsteq	r0, r1
    1dcc:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1dd0:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1dd4:	2f2e2e2f 	svccs	0x002e2e2f
    1dd8:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1ddc:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
    1de0:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    1de4:	6e6f632f 	cdpvs	3, 6, cr6, cr15, cr15, {1}
    1de8:	2f676966 	svccs	0x00676966
    1dec:	006d7261 	rsbeq	r7, sp, r1, ror #4
    1df0:	62696c00 	rsbvs	r6, r9, #0, 24
    1df4:	6e756631 	mrcvs	6, 3, r6, cr5, cr1, {1}
    1df8:	532e7363 			; <UNDEFINED> instruction: 0x532e7363
    1dfc:	00000100 	andeq	r0, r0, r0, lsl #2
    1e00:	02050000 	andeq	r0, r5, #0
    1e04:	0000a730 	andeq	sl, r0, r0, lsr r7
    1e08:	0108ca03 	tsteq	r8, r3, lsl #20
    1e0c:	2f2f2f30 	svccs	0x002f2f30
    1e10:	02302f2f 	eorseq	r2, r0, #47, 30	; 0xbc
    1e14:	2f1401d0 	svccs	0x001401d0
    1e18:	302f2f31 	eorcc	r2, pc, r1, lsr pc	; <UNPREDICTABLE>
    1e1c:	03322f4c 	teqeq	r2, #76, 30	; 0x130
    1e20:	2f2f661f 	svccs	0x002f661f
    1e24:	2f2f2f2f 	svccs	0x002f2f2f
    1e28:	0002022f 	andeq	r0, r2, pc, lsr #4
    1e2c:	005c0101 	subseq	r0, ip, r1, lsl #2
    1e30:	00030000 	andeq	r0, r3, r0
    1e34:	00000046 	andeq	r0, r0, r6, asr #32
    1e38:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
    1e3c:	0101000d 	tsteq	r1, sp
    1e40:	00000101 	andeq	r0, r0, r1, lsl #2
    1e44:	00000100 	andeq	r0, r0, r0, lsl #2
    1e48:	2f2e2e01 	svccs	0x002e2e01
    1e4c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1e50:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1e54:	2f2e2e2f 	svccs	0x002e2e2f
    1e58:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 1da8 <CPSR_IRQ_INHIBIT+0x1d28>
    1e5c:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1e60:	6f632f63 	svcvs	0x00632f63
    1e64:	6769666e 	strbvs	r6, [r9, -lr, ror #12]!
    1e68:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
    1e6c:	696c0000 	stmdbvs	ip!, {}^	; <UNPREDICTABLE>
    1e70:	75663162 	strbvc	r3, [r6, #-354]!	; 0xfffffe9e
    1e74:	2e73636e 	cdpcs	3, 7, cr6, cr3, cr14, {3}
    1e78:	00010053 	andeq	r0, r1, r3, asr r0
    1e7c:	05000000 	streq	r0, [r0, #-0]
    1e80:	00a93c02 	adceq	r3, r9, r2, lsl #24
    1e84:	0bb40300 	bleq	fed02a8c <_bss_end+0xfecf6d90>
    1e88:	00020201 	andeq	r0, r2, r1, lsl #4
    1e8c:	01030101 	tsteq	r3, r1, lsl #2
    1e90:	00030000 	andeq	r0, r3, r0
    1e94:	000000fd 	strdeq	r0, [r0], -sp
    1e98:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
    1e9c:	0101000d 	tsteq	r1, sp
    1ea0:	00000101 	andeq	r0, r0, r1, lsl #2
    1ea4:	00000100 	andeq	r0, r0, r0, lsl #2
    1ea8:	2f2e2e01 	svccs	0x002e2e01
    1eac:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1eb0:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1eb4:	2f2e2e2f 	svccs	0x002e2e2f
    1eb8:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 1e08 <CPSR_IRQ_INHIBIT+0x1d88>
    1ebc:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1ec0:	2e2e2f63 	cdpcs	15, 2, cr2, cr14, cr3, {3}
    1ec4:	636e692f 	cmnvs	lr, #770048	; 0xbc000
    1ec8:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
    1ecc:	2f2e2e00 	svccs	0x002e2e00
    1ed0:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1ed4:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1ed8:	2f2e2e2f 	svccs	0x002e2e2f
    1edc:	63672f2e 	cmnvs	r7, #46, 30	; 0xb8
    1ee0:	2e2e0063 	cdpcs	0, 2, cr0, cr14, cr3, {3}
    1ee4:	2f2e2e2f 	svccs	0x002e2e2f
    1ee8:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1eec:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1ef0:	2f2e2e2f 	svccs	0x002e2e2f
    1ef4:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    1ef8:	2e2f6363 	cdpcs	3, 2, cr6, cr15, cr3, {3}
    1efc:	63672f2e 	cmnvs	r7, #46, 30	; 0xb8
    1f00:	6f632f63 	svcvs	0x00632f63
    1f04:	6769666e 	strbvs	r6, [r9, -lr, ror #12]!
    1f08:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
    1f0c:	2f2e2e00 	svccs	0x002e2e00
    1f10:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1f14:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1f18:	2f2e2e2f 	svccs	0x002e2e2f
    1f1c:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 1e6c <CPSR_IRQ_INHIBIT+0x1dec>
    1f20:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1f24:	68000063 	stmdavs	r0, {r0, r1, r5, r6}
    1f28:	74687361 	strbtvc	r7, [r8], #-865	; 0xfffffc9f
    1f2c:	682e6261 	stmdavs	lr!, {r0, r5, r6, r9, sp, lr}
    1f30:	00000100 	andeq	r0, r0, r0, lsl #2
    1f34:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
    1f38:	2e617369 	cdpcs	3, 6, cr7, cr1, cr9, {3}
    1f3c:	00020068 	andeq	r0, r2, r8, rrx
    1f40:	6d726100 	ldfvse	f6, [r2, #-0]
    1f44:	7570632d 	ldrbvc	r6, [r0, #-813]!	; 0xfffffcd3
    1f48:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
    1f4c:	6e690000 	cdpvs	0, 6, cr0, cr9, cr0, {0}
    1f50:	632d6e73 			; <UNDEFINED> instruction: 0x632d6e73
    1f54:	74736e6f 	ldrbtvc	r6, [r3], #-3695	; 0xfffff191
    1f58:	73746e61 	cmnvc	r4, #1552	; 0x610
    1f5c:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
    1f60:	72610000 	rsbvc	r0, r1, #0
    1f64:	00682e6d 	rsbeq	r2, r8, sp, ror #28
    1f68:	6c000003 	stcvs	0, cr0, [r0], {3}
    1f6c:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1f70:	682e3263 	stmdavs	lr!, {r0, r1, r5, r6, r9, ip, sp}
    1f74:	00000400 	andeq	r0, r0, r0, lsl #8
    1f78:	2d6c6267 	sfmcs	f6, 2, [ip, #-412]!	; 0xfffffe64
    1f7c:	726f7463 	rsbvc	r7, pc, #1660944384	; 0x63000000
    1f80:	00682e73 	rsbeq	r2, r8, r3, ror lr
    1f84:	6c000004 	stcvs	0, cr0, [r0], {4}
    1f88:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1f8c:	632e3263 			; <UNDEFINED> instruction: 0x632e3263
    1f90:	00000400 	andeq	r0, r0, r0, lsl #8
	...

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
      20:	5b202965 	blpl	80a5bc <_bss_end+0x7fe8c0>
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
      88:	7a6a3637 	bvc	1a8d96c <_bss_end+0x1a81c70>
      8c:	20732d66 	rsbscs	r2, r3, r6, ror #26
      90:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
      94:	6d2d206d 	stcvs	0, cr2, [sp, #-436]!	; 0xfffffe4c
      98:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
      9c:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
      a0:	6b7a3676 	blvs	1e8da80 <_bss_end+0x1e81d84>
      a4:	2070662b 	rsbscs	r6, r0, fp, lsr #12
      a8:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
      ac:	4f2d2067 	svcmi	0x002d2067
      b0:	4f2d2030 	svcmi	0x002d2030
      b4:	682f0030 	stmdavs	pc!, {r4, r5}	; <UNPREDICTABLE>
      b8:	2f656d6f 	svccs	0x00656d6f
      bc:	686c6973 	stmdavs	ip!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
      c0:	6a797661 	bvs	1e5da4c <_bss_end+0x1e51d50>
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
     1f0:	5a5f0074 	bpl	17c03c8 <_bss_end+0x17b46cc>
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
     298:	4b4c4344 	blmi	1310fb0 <_bss_end+0x13052b4>
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
     2c8:	6a457475 	bvs	115d4a4 <_bss_end+0x11517a8>
     2cc:	5a5f0062 	bpl	17c045c <_bss_end+0x17b4760>
     2d0:	33314b4e 	teqcc	r1, #79872	; 0x13800
     2d4:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     2d8:	61485f4f 	cmpvs	r8, pc, asr #30
     2dc:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     2e0:	47393172 			; <UNDEFINED> instruction: 0x47393172
     2e4:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     2e8:	45534650 	ldrbmi	r4, [r3, #-1616]	; 0xfffff9b0
     2ec:	6f4c5f4c 	svcvs	0x004c5f4c
     2f0:	69746163 	ldmdbvs	r4!, {r0, r1, r5, r6, r8, sp, lr}^
     2f4:	6a456e6f 	bvs	115bcb8 <_bss_end+0x114ffbc>
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
     3a4:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffe38 <_bss_end+0xffff413c>
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
     468:	4b4e5a5f 	blmi	1396dec <_bss_end+0x138b0f0>
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
     5f8:	4b4e5a5f 	blmi	1396f7c <_bss_end+0x138b280>
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
     64c:	754f5f74 	strbvc	r5, [pc, #-3956]	; fffff6e0 <_bss_end+0xffff39e4>
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
     6e0:	5a5f0065 	bpl	17c087c <_bss_end+0x17b4b80>
     6e4:	4d43384e 	stclmi	8, cr3, [r3, #-312]	; 0xfffffec8
     6e8:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
     6ec:	5239726f 	eorspl	r7, r9, #-268435450	; 0xf0000006
     6f0:	69616d65 	stmdbvs	r1!, {r0, r2, r5, r6, r8, sl, fp, sp, lr}^
     6f4:	7265646e 	rsbvc	r6, r5, #1845493760	; 0x6e000000
     6f8:	006a6a45 	rsbeq	r6, sl, r5, asr #20
     6fc:	384e5a5f 	stmdacc	lr, {r0, r1, r2, r3, r4, r6, r9, fp, ip, lr}^
     700:	6e6f4d43 	cdpvs	13, 6, cr4, cr15, cr3, {2}
     704:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
     708:	6a453243 	bvs	114d01c <_bss_end+0x1141320>
     70c:	5f006a6a 	svcpl	0x00006a6a
     710:	43384e5a 	teqmi	r8, #1440	; 0x5a0
     714:	696e6f4d 	stmdbvs	lr!, {r0, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     718:	31726f74 	cmncc	r2, r4, ror pc
     71c:	6a644133 	bvs	1910bf0 <_bss_end+0x1904ef4>
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
     7d4:	5a5f0076 	bpl	17c09b4 <_bss_end+0x17b4cb8>
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
     830:	4b504573 	blmi	1411e04 <_bss_end+0x1406108>
     834:	5a5f0063 	bpl	17c09c8 <_bss_end+0x17b4ccc>
     838:	4d43384e 	stclmi	8, cr3, [r3, #-312]	; 0xfffffec8
     83c:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
     840:	6934726f 	ldmdbvs	r4!, {r0, r1, r2, r3, r5, r6, r9, ip, sp, lr}
     844:	45616f74 	strbmi	r6, [r1, #-3956]!	; 0xfffff08c
     848:	6a63506a 	bvs	18d49f8 <_bss_end+0x18c8cfc>
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
     920:	6a797661 	bvs	1e5e2ac <_bss_end+0x1e525b0>
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
     9d0:	6a797661 	bvs	1e5e35c <_bss_end+0x1e52660>
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
     a4c:	6b73614d 	blvs	1cd8f88 <_bss_end+0x1ccd28c>
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
     abc:	6a457676 	bvs	115e49c <_bss_end+0x11527a0>
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
     b30:	6b616572 	blvs	185a100 <_bss_end+0x184e404>
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
     bcc:	6b636162 	blvs	18d915c <_bss_end+0x18cd460>
     bd0:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     bd4:	69544336 	ldmdbvs	r4, {r1, r2, r4, r5, r8, r9, lr}^
     bd8:	3472656d 	ldrbtcc	r6, [r2], #-1389	; 0xfffffa93
     bdc:	73676552 	cmnvc	r7, #343932928	; 0x14800000
     be0:	68334e45 	ldmdavs	r3!, {r0, r2, r6, r9, sl, fp, lr}
     be4:	54396c61 	ldrtpl	r6, [r9], #-3169	; 0xfffff39f
     be8:	72656d69 	rsbvc	r6, r5, #6720	; 0x1a40
     bec:	6765525f 			; <UNDEFINED> instruction: 0x6765525f
     bf0:	5a5f0045 	bpl	17c0d0c <_bss_end+0x17b5010>
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
     f84:	5a5f0065 	bpl	17c1120 <_bss_end+0x17b5424>
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
    1088:	5a5f0074 	bpl	17c1260 <_bss_end+0x17b5564>
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
    10b4:	48007645 	stmdami	r0, {r0, r2, r6, r9, sl, ip, sp, lr}
    10b8:	4d686769 	stclmi	7, cr6, [r8, #-420]!	; 0xfffffe5c
    10bc:	726f6d65 	rsbvc	r6, pc, #6464	; 0x1940
    10c0:	656e0079 	strbvs	r0, [lr, #-121]!	; 0xffffff87
    10c4:	5f007478 	svcpl	0x00007478
    10c8:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
    10cc:	6f725043 	svcvs	0x00725043
    10d0:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    10d4:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
    10d8:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
    10dc:	72433431 	subvc	r3, r3, #822083584	; 0x31000000
    10e0:	65746165 	ldrbvs	r6, [r4, #-357]!	; 0xfffffe9b
    10e4:	6f72505f 	svcvs	0x0072505f
    10e8:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    10ec:	43006d45 	movwmi	r6, #3397	; 0xd45
    10f0:	74616572 	strbtvc	r6, [r1], #-1394	; 0xfffffa8e
    10f4:	72505f65 	subsvc	r5, r0, #404	; 0x194
    10f8:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    10fc:	50430073 	subpl	r0, r3, r3, ror r0
    1100:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    1104:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; f40 <CPSR_IRQ_INHIBIT+0xec0>
    1108:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
    110c:	69007265 	stmdbvs	r0, {r0, r2, r5, r6, r9, ip, sp, lr}
    1110:	72665f73 	rsbvc	r5, r6, #460	; 0x1cc
    1114:	54006565 	strpl	r6, [r0], #-1381	; 0xfffffa9b
    1118:	5f555043 	svcpl	0x00555043
    111c:	746e6f43 	strbtvc	r6, [lr], #-3907	; 0xfffff0bd
    1120:	00747865 	rsbseq	r7, r4, r5, ror #16
    1124:	5f44454c 	svcpl	0x0044454c
    1128:	74617453 	strbtvc	r7, [r1], #-1107	; 0xfffffbad
    112c:	5a5f0065 	bpl	17c12c8 <_bss_end+0x17b55cc>
    1130:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
    1134:	636f7250 	cmnvs	pc, #80, 4
    1138:	5f737365 	svcpl	0x00737365
    113c:	616e614d 	cmnvs	lr, sp, asr #2
    1140:	43726567 	cmnmi	r2, #432013312	; 0x19c00000
    1144:	00764534 	rsbseq	r4, r6, r4, lsr r5
    1148:	5f746547 	svcpl	0x00746547
    114c:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
    1150:	5f746e65 	svcpl	0x00746e65
    1154:	636f7250 	cmnvs	pc, #80, 4
    1158:	00737365 	rsbseq	r7, r3, r5, ror #6
    115c:	324e5a5f 	subcc	r5, lr, #389120	; 0x5f000
    1160:	654b4330 	strbvs	r4, [fp, #-816]	; 0xfffffcd0
    1164:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
    1168:	6165485f 	cmnvs	r5, pc, asr r8
    116c:	614d5f70 	hvcvs	54768	; 0xd5f0
    1170:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
    1174:	41353172 	teqmi	r5, r2, ror r1
    1178:	636f6c6c 	cmnvs	pc, #108, 24	; 0x6c00
    117c:	78654e5f 	stmdavc	r5!, {r0, r1, r2, r3, r4, r6, r9, sl, fp, lr}^
    1180:	61505f74 	cmpvs	r0, r4, ror pc
    1184:	76456567 	strbvc	r6, [r5], -r7, ror #10
    1188:	7a697300 	bvc	1a5dd90 <_bss_end+0x1a52094>
    118c:	72460065 	subvc	r0, r6, #101	; 0x65
    1190:	4e006565 	cfsh32mi	mvfx6, mvfx0, #53
    1194:	6b736154 	blvs	1cd96ec <_bss_end+0x1ccd9f0>
    1198:	6174535f 	cmnvs	r4, pc, asr r3
    119c:	73006574 	movwvc	r6, #1396	; 0x574
    11a0:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
    11a4:	6174735f 	cmnvs	r4, pc, asr r3
    11a8:	5f636974 	svcpl	0x00636974
    11ac:	6f697270 	svcvs	0x00697270
    11b0:	79746972 	ldmdbvc	r4!, {r1, r4, r5, r6, r8, fp, sp, lr}^
    11b4:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
    11b8:	4b433032 	blmi	10cd288 <_bss_end+0x10c158c>
    11bc:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
    11c0:	65485f6c 	strbvs	r5, [r8, #-3948]	; 0xfffff094
    11c4:	4d5f7061 	ldclmi	0, cr7, [pc, #-388]	; 1048 <CPSR_IRQ_INHIBIT+0xfc8>
    11c8:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
    11cc:	46347265 	ldrtmi	r7, [r4], -r5, ror #4
    11d0:	45656572 	strbmi	r6, [r5, #-1394]!	; 0xfffffa8e
    11d4:	4c007650 	stcmi	6, cr7, [r0], {80}	; 0x50
    11d8:	654d776f 	strbvs	r7, [sp, #-1903]	; 0xfffff891
    11dc:	79726f6d 	ldmdbvc	r2!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
    11e0:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
    11e4:	4b433032 	blmi	10cd2b4 <_bss_end+0x10c15b8>
    11e8:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
    11ec:	65485f6c 	strbvs	r5, [r8, #-3948]	; 0xfffff094
    11f0:	4d5f7061 	ldclmi	0, cr7, [pc, #-388]	; 1074 <CPSR_IRQ_INHIBIT+0xff4>
    11f4:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
    11f8:	34437265 	strbcc	r7, [r3], #-613	; 0xfffffd9b
    11fc:	6d007645 	stcvs	6, cr7, [r0, #-276]	; 0xfffffeec
    1200:	7473614c 	ldrbtvc	r6, [r3], #-332	; 0xfffffeb4
    1204:	4449505f 	strbmi	r5, [r9], #-95	; 0xffffffa1
    1208:	6d6f5a00 	vstmdbvs	pc!, {s11-s10}
    120c:	00656962 	rsbeq	r6, r5, r2, ror #18
    1210:	314e5a5f 	cmpcc	lr, pc, asr sl
    1214:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
    1218:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    121c:	614d5f73 	hvcvs	54771	; 0xd5f3
    1220:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
    1224:	63533872 	cmpvs	r3, #7471104	; 0x720000
    1228:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
    122c:	7645656c 	strbvc	r6, [r5], -ip, ror #10
    1230:	68637300 	stmdavs	r3!, {r8, r9, ip, sp, lr}^
    1234:	635f6465 	cmpvs	pc, #1694498816	; 0x65000000
    1238:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
    123c:	43007265 	movwmi	r7, #613	; 0x265
    1240:	6e72654b 	cdpvs	5, 7, cr6, cr2, cr11, {2}
    1244:	485f6c65 	ldmdami	pc, {r0, r2, r5, r6, sl, fp, sp, lr}^	; <UNPREDICTABLE>
    1248:	5f706165 	svcpl	0x00706165
    124c:	616e614d 	cmnvs	lr, sp, asr #2
    1250:	00726567 	rsbseq	r6, r2, r7, ror #10
    1254:	6e6e7552 	mcrvs	5, 3, r7, cr14, cr2, {2}
    1258:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
    125c:	6c6c4100 	stfvse	f4, [ip], #-0
    1260:	4100636f 	tstmi	r0, pc, ror #6
    1264:	505f5443 	subspl	r5, pc, r3, asr #8
    1268:	5f006e69 	svcpl	0x00006e69
    126c:	30324e5a 	eorscc	r4, r2, sl, asr lr
    1270:	72654b43 	rsbvc	r4, r5, #68608	; 0x10c00
    1274:	5f6c656e 	svcpl	0x006c656e
    1278:	70616548 	rsbvc	r6, r1, r8, asr #10
    127c:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
    1280:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
    1284:	6c6c4135 	stfvse	f4, [ip], #-212	; 0xffffff2c
    1288:	6a45636f 	bvs	115a04c <_bss_end+0x114e350>
    128c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
    1290:	4336314b 	teqmi	r6, #-1073741806	; 0xc0000012
    1294:	636f7250 	cmnvs	pc, #80, 4
    1298:	5f737365 	svcpl	0x00737365
    129c:	616e614d 	cmnvs	lr, sp, asr #2
    12a0:	31726567 	cmncc	r2, r7, ror #10
    12a4:	74654739 	strbtvc	r4, [r5], #-1849	; 0xfffff8c7
    12a8:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
    12ac:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
    12b0:	6f72505f 	svcvs	0x0072505f
    12b4:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    12b8:	6d007645 	stcvs	6, cr7, [r0, #-276]	; 0xfffffeec
    12bc:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
    12c0:	5f746e65 	svcpl	0x00746e65
    12c4:	6b736154 	blvs	1cd981c <_bss_end+0x1ccdb20>
    12c8:	646f4e5f 	strbtvs	r4, [pc], #-3679	; 12d0 <CPSR_IRQ_INHIBIT+0x1250>
    12cc:	70630065 	rsbvc	r0, r3, r5, rrx
    12d0:	6f635f75 	svcvs	0x00635f75
    12d4:	7865746e 	stmdavc	r5!, {r1, r2, r3, r5, r6, sl, ip, sp, lr}^
    12d8:	61500074 	cmpvs	r0, r4, ror r0
    12dc:	676e6967 	strbvs	r6, [lr, -r7, ror #18]!
    12e0:	6f6d654d 	svcvs	0x006d654d
    12e4:	69537972 	ldmdbvs	r3, {r1, r4, r5, r6, r8, fp, ip, sp, lr}^
    12e8:	7400657a 	strvc	r6, [r0], #-1402	; 0xfffffa86
    12ec:	006b7361 	rsbeq	r7, fp, r1, ror #6
    12f0:	73615454 	cmnvc	r1, #84, 8	; 0x54000000
    12f4:	74535f6b 	ldrbvc	r5, [r3], #-3947	; 0xfffff095
    12f8:	74637572 	strbtvc	r7, [r3], #-1394	; 0xfffffa8e
    12fc:	68635300 	stmdavs	r3!, {r8, r9, ip, lr}^
    1300:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
    1304:	466d0065 	strbtmi	r0, [sp], -r5, rrx
    1308:	74737269 	ldrbtvc	r7, [r3], #-617	; 0xfffffd97
    130c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
    1310:	50433631 	subpl	r3, r3, r1, lsr r6
    1314:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    1318:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 1154 <CPSR_IRQ_INHIBIT+0x10d4>
    131c:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
    1320:	53397265 	teqpl	r9, #1342177286	; 0x50000006
    1324:	63746977 	cmnvs	r4, #1949696	; 0x1dc000
    1328:	6f545f68 	svcvs	0x00545f68
    132c:	38315045 	ldmdacc	r1!, {r0, r2, r6, ip, lr}
    1330:	6f725043 	svcvs	0x00725043
    1334:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    1338:	73694c5f 	cmnvc	r9, #24320	; 0x5f00
    133c:	6f4e5f74 	svcvs	0x004e5f74
    1340:	54006564 	strpl	r6, [r0], #-1380	; 0xfffffa9c
    1344:	6e72654b 	cdpvs	5, 7, cr6, cr2, cr11, {2}
    1348:	485f6c65 	ldmdami	pc, {r0, r2, r5, r6, sl, fp, sp, lr}^	; <UNPREDICTABLE>
    134c:	5f706165 	svcpl	0x00706165
    1350:	6e756843 	cdpvs	8, 7, cr6, cr5, cr3, {2}
    1354:	65485f6b 	strbvs	r5, [r8, #-3947]	; 0xfffff095
    1358:	72656461 	rsbvc	r6, r5, #1627389952	; 0x61000000
    135c:	65724300 	ldrbvs	r4, [r2, #-768]!	; 0xfffffd00
    1360:	5f657461 	svcpl	0x00657461
    1364:	6e69614d 	powvsem	f6, f1, #5.0
    1368:	6f72505f 	svcvs	0x0072505f
    136c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    1370:	69775300 	ldmdbvs	r7!, {r8, r9, ip, lr}^
    1374:	5f686374 	svcpl	0x00686374
    1378:	41006f54 	tstmi	r0, r4, asr pc
    137c:	636f6c6c 	cmnvs	pc, #108, 24	; 0x6c00
    1380:	78654e5f 	stmdavc	r5!, {r0, r1, r2, r3, r4, r6, r9, sl, fp, lr}^
    1384:	61505f74 	cmpvs	r0, r4, ror pc
    1388:	50006567 	andpl	r6, r0, r7, ror #10
    138c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    1390:	315f7373 	cmpcc	pc, r3, ror r3	; <UNPREDICTABLE>
    1394:	6f725000 	svcvs	0x00725000
    1398:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    139c:	5000335f 	andpl	r3, r0, pc, asr r3
    13a0:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    13a4:	345f7373 	ldrbcc	r7, [pc], #-883	; 13ac <CPSR_IRQ_INHIBIT+0x132c>
    13a8:	656b5f00 	strbvs	r5, [fp, #-3840]!	; 0xfffff100
    13ac:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
    13b0:	69616d5f 	stmdbvs	r1!, {r0, r1, r2, r3, r4, r6, r8, sl, fp, sp, lr}^
    13b4:	506d006e 	rsbpl	r0, sp, lr, rrx
    13b8:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    13bc:	4c5f7373 	mrrcmi	3, 7, r7, pc, cr3	; <UNPREDICTABLE>
    13c0:	5f747369 	svcpl	0x00747369
    13c4:	64616548 	strbtvs	r6, [r1], #-1352	; 0xfffffab8
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
    142c:	7a695365 	bvc	1a561c8 <_bss_end+0x1a4a4cc>
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
    147c:	5a5f006d 	bpl	17c1638 <_bss_end+0x17b593c>
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
    14d0:	5a2f6c6f 	bpl	bdc694 <_bss_end+0xbd0998>
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
    14fc:	6b2f726f 	blvs	bddec0 <_bss_end+0xbd21c4>
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
    1534:	6b72614d 	blvs	1c99a70 <_bss_end+0x1c8dd74>
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
    1580:	706d6574 	rsbvc	r6, sp, r4, ror r5
    1584:	73616600 	cmnvc	r1, #0, 12
    1588:	6f6d5f74 	svcvs	0x006d5f74
    158c:	756c7564 	strbvc	r7, [ip, #-1380]!	; 0xfffffa9c
    1590:	61700073 	cmnvs	r0, r3, ror r0
    1594:	695f6567 	ldmdbvs	pc, {r0, r1, r2, r5, r6, r8, sl, sp, lr}^	; <UNPREDICTABLE>
    1598:	2f007864 	svccs	0x00007864
    159c:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
    15a0:	6c69732f 	stclvs	3, cr7, [r9], #-188	; 0xffffff44
    15a4:	79766168 	ldmdbvc	r6!, {r3, r5, r6, r8, sp, lr}^
    15a8:	63532f6a 	cmpvs	r3, #424	; 0x1a8
    15ac:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; 1414 <CPSR_IRQ_INHIBIT+0x1394>
    15b0:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
    15b4:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
    15b8:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
    15bc:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
    15c0:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
    15c4:	6f632d33 	svcvs	0x00632d33
    15c8:	7865746e 	stmdavc	r5!, {r1, r2, r3, r5, r6, sl, ip, sp, lr}^
    15cc:	77735f74 			; <UNDEFINED> instruction: 0x77735f74
    15d0:	68637469 	stmdavs	r3!, {r0, r3, r5, r6, sl, ip, sp, lr}^
    15d4:	6e6f6d5f 	mcrvs	13, 3, r6, cr15, cr15, {2}
    15d8:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
    15dc:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
    15e0:	2f6c656e 	svccs	0x006c656e
    15e4:	2f637273 	svccs	0x00637273
    15e8:	6f6d656d 	svcvs	0x006d656d
    15ec:	702f7972 	eorvc	r7, pc, r2, ror r9	; <UNPREDICTABLE>
    15f0:	73656761 	cmnvc	r5, #25427968	; 0x1840000
    15f4:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
    15f8:	4c475f00 	mcrrmi	15, 0, r5, r7, cr0
    15fc:	4c41424f 	sfmmi	f4, 2, [r1], {79}	; 0x4f
    1600:	75735f5f 	ldrbvc	r5, [r3, #-3935]!	; 0xfffff0a1
    1604:	5f495f62 	svcpl	0x00495f62
    1608:	67615073 			; <UNDEFINED> instruction: 0x67615073
    160c:	614d5f65 	cmpvs	sp, r5, ror #30
    1610:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
    1614:	69640072 	stmdbvs	r4!, {r1, r4, r5, r6}^
    1618:	65646976 	strbvs	r6, [r4, #-2422]!	; 0xfffff68a
    161c:	5f00646e 	svcpl	0x0000646e
    1620:	6632315a 			; <UNDEFINED> instruction: 0x6632315a
    1624:	5f747361 	svcpl	0x00747361
    1628:	75646f6d 	strbvc	r6, [r4, #-3949]!	; 0xfffff093
    162c:	6a73756c 	bvs	1cdebe4 <_bss_end+0x1cd2ee8>
    1630:	7375006a 	cmnvc	r5, #106	; 0x6a
    1634:	5f006465 	svcpl	0x00006465
    1638:	33314e5a 	teqcc	r1, #1440	; 0x5a0
    163c:	67615043 	strbvs	r5, [r1, -r3, asr #32]!
    1640:	614d5f65 	cmpvs	sp, r5, ror #30
    1644:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
    1648:	45324372 	ldrmi	r4, [r2, #-882]!	; 0xfffffc8e
    164c:	69640076 	stmdbvs	r4!, {r1, r2, r4, r5, r6}^
    1650:	6f736976 	svcvs	0x00736976
    1654:	61660072 	smcvs	24578	; 0x6002
    1658:	645f7473 	ldrbvs	r7, [pc], #-1139	; 1660 <CPSR_IRQ_INHIBIT+0x15e0>
    165c:	64697669 	strbtvs	r7, [r9], #-1641	; 0xfffff997
    1660:	75660065 	strbvc	r0, [r6, #-101]!	; 0xffffff9b
    1664:	7470636e 	ldrbtvc	r6, [r0], #-878	; 0xfffffc92
    1668:	73690072 	cmnvc	r9, #114	; 0x72
    166c:	7269665f 	rsbvc	r6, r9, #99614720	; 0x5f00000
    1670:	745f7473 	ldrbvc	r7, [pc], #-1139	; 1678 <CPSR_IRQ_INHIBIT+0x15f8>
    1674:	00656d69 	rsbeq	r6, r5, r9, ror #26
    1678:	6f6c6c41 	svcvs	0x006c6c41
    167c:	54543c63 	ldrbpl	r3, [r4], #-3171	; 0xfffff39d
    1680:	5f6b7361 	svcpl	0x006b7361
    1684:	75727453 	ldrbvc	r7, [r2, #-1107]!	; 0xfffffbad
    1688:	003e7463 	eorseq	r7, lr, r3, ror #8
    168c:	314e5a5f 	cmpcc	lr, pc, asr sl
    1690:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
    1694:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    1698:	614d5f73 	hvcvs	54771	; 0xd5f3
    169c:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
    16a0:	45324372 	ldrmi	r4, [r2, #-882]!	; 0xfffffc8e
    16a4:	5a5f0076 	bpl	17c1884 <_bss_end+0x17b5b88>
    16a8:	4330324e 	teqmi	r0, #-536870908	; 0xe0000004
    16ac:	6e72654b 	cdpvs	5, 7, cr6, cr2, cr11, {2}
    16b0:	485f6c65 	ldmdami	pc, {r0, r2, r5, r6, sl, fp, sp, lr}^	; <UNPREDICTABLE>
    16b4:	5f706165 	svcpl	0x00706165
    16b8:	616e614d 	cmnvs	lr, sp, asr #2
    16bc:	35726567 	ldrbcc	r6, [r2, #-1383]!	; 0xfffffa99
    16c0:	6f6c6c41 	svcvs	0x006c6c41
    16c4:	38314963 	ldmdacc	r1!, {r0, r1, r5, r6, r8, fp, lr}
    16c8:	6f725043 	svcvs	0x00725043
    16cc:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    16d0:	73694c5f 	cmnvc	r9, #24320	; 0x5f00
    16d4:	6f4e5f74 	svcvs	0x004e5f74
    16d8:	45456564 	strbmi	r6, [r5, #-1380]	; 0xfffffa9c
    16dc:	765f5450 			; <UNDEFINED> instruction: 0x765f5450
    16e0:	4c475f00 	mcrrmi	15, 0, r5, r7, cr0
    16e4:	4c41424f 	sfmmi	f4, 2, [r1], {79}	; 0x4f
    16e8:	75735f5f 	ldrbvc	r5, [r3, #-3935]!	; 0xfffff0a1
    16ec:	5f495f62 	svcpl	0x00495f62
    16f0:	6f725073 	svcvs	0x00725073
    16f4:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    16f8:	0072674d 	rsbseq	r6, r2, sp, asr #14
    16fc:	636f7270 	cmnvs	pc, #112, 4
    1700:	65646f6e 	strbvs	r6, [r4, #-3950]!	; 0xfffff092
    1704:	6c6c4100 	stfvse	f4, [ip], #-0
    1708:	433c636f 	teqmi	ip, #-1140850687	; 0xbc000001
    170c:	636f7250 	cmnvs	pc, #80, 4
    1710:	5f737365 	svcpl	0x00737365
    1714:	7473694c 	ldrbtvc	r6, [r3], #-2380	; 0xfffff6b4
    1718:	646f4e5f 	strbtvs	r4, [pc], #-3679	; 1720 <CPSR_IRQ_INHIBIT+0x16a0>
    171c:	2f003e65 	svccs	0x00003e65
    1720:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
    1724:	6c69732f 	stclvs	3, cr7, [r9], #-188	; 0xffffff44
    1728:	79766168 	ldmdbvc	r6!, {r3, r5, r6, r8, sp, lr}^
    172c:	63532f6a 	cmpvs	r3, #424	; 0x1a8
    1730:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; 1598 <CPSR_IRQ_INHIBIT+0x1518>
    1734:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
    1738:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
    173c:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
    1740:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
    1744:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
    1748:	6f632d33 	svcvs	0x00632d33
    174c:	7865746e 	stmdavc	r5!, {r1, r2, r3, r5, r6, sl, ip, sp, lr}^
    1750:	77735f74 			; <UNDEFINED> instruction: 0x77735f74
    1754:	68637469 	stmdavs	r3!, {r0, r3, r5, r6, sl, ip, sp, lr}^
    1758:	6e6f6d5f 	mcrvs	13, 3, r6, cr15, cr15, {2}
    175c:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
    1760:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
    1764:	2f6c656e 	svccs	0x006c656e
    1768:	2f637273 	svccs	0x00637273
    176c:	636f7270 	cmnvs	pc, #112, 4
    1770:	2f737365 	svccs	0x00737365
    1774:	636f7270 	cmnvs	pc, #112, 4
    1778:	5f737365 	svcpl	0x00737365
    177c:	616e616d 	cmnvs	lr, sp, ror #2
    1780:	2e726567 	cdpcs	5, 7, cr6, cr2, cr7, {3}
    1784:	00707063 	rsbseq	r7, r0, r3, rrx
    1788:	324e5a5f 	subcc	r5, lr, #389120	; 0x5f000
    178c:	654b4330 	strbvs	r4, [fp, #-816]	; 0xfffffcd0
    1790:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
    1794:	6165485f 	cmnvs	r5, pc, asr r8
    1798:	614d5f70 	hvcvs	54768	; 0xd5f0
    179c:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
    17a0:	6c413572 	cfstr64vs	mvdx3, [r1], {114}	; 0x72
    17a4:	49636f6c 	stmdbmi	r3!, {r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
    17a8:	54543231 	ldrbpl	r3, [r4], #-561	; 0xfffffdcf
    17ac:	5f6b7361 	svcpl	0x006b7361
    17b0:	75727453 	ldrbvc	r7, [r2, #-1107]!	; 0xfffffbad
    17b4:	45457463 	strbmi	r7, [r5, #-1123]	; 0xfffffb9d
    17b8:	765f5450 			; <UNDEFINED> instruction: 0x765f5450
    17bc:	6f682f00 	svcvs	0x00682f00
    17c0:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
    17c4:	61686c69 	cmnvs	r8, r9, ror #24
    17c8:	2f6a7976 	svccs	0x006a7976
    17cc:	6f686353 	svcvs	0x00686353
    17d0:	5a2f6c6f 	bpl	bdc994 <_bss_end+0xbd0c98>
    17d4:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 1648 <CPSR_IRQ_INHIBIT+0x15c8>
    17d8:	2f657461 	svccs	0x00657461
    17dc:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
    17e0:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
    17e4:	2d33312f 	ldfcss	f3, [r3, #-188]!	; 0xffffff44
    17e8:	746e6f63 	strbtvc	r6, [lr], #-3939	; 0xfffff09d
    17ec:	5f747865 	svcpl	0x00747865
    17f0:	74697773 	strbtvc	r7, [r9], #-1907	; 0xfffff88d
    17f4:	6d5f6863 	ldclvs	8, cr6, [pc, #-396]	; 1670 <CPSR_IRQ_INHIBIT+0x15f0>
    17f8:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
    17fc:	6b2f726f 	blvs	bde1c0 <_bss_end+0xbd24c4>
    1800:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
    1804:	72732f6c 	rsbsvc	r2, r3, #108, 30	; 0x1b0
    1808:	72702f63 	rsbsvc	r2, r0, #396	; 0x18c
    180c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    1810:	77732f73 			; <UNDEFINED> instruction: 0x77732f73
    1814:	68637469 	stmdavs	r3!, {r0, r3, r5, r6, sl, ip, sp, lr}^
    1818:	4700732e 	strmi	r7, [r0, -lr, lsr #6]
    181c:	4120554e 			; <UNDEFINED> instruction: 0x4120554e
    1820:	2e322053 	mrccs	0, 1, r2, cr2, cr3, {2}
    1824:	2f003433 	svccs	0x00003433
    1828:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
    182c:	6c69732f 	stclvs	3, cr7, [r9], #-188	; 0xffffff44
    1830:	79766168 	ldmdbvc	r6!, {r3, r5, r6, r8, sp, lr}^
    1834:	63532f6a 	cmpvs	r3, #424	; 0x1a8
    1838:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; 16a0 <CPSR_IRQ_INHIBIT+0x1620>
    183c:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
    1840:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
    1844:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
    1848:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
    184c:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
    1850:	6f632d33 	svcvs	0x00632d33
    1854:	7865746e 	stmdavc	r5!, {r1, r2, r3, r5, r6, sl, ip, sp, lr}^
    1858:	77735f74 			; <UNDEFINED> instruction: 0x77735f74
    185c:	68637469 	stmdavs	r3!, {r0, r3, r5, r6, sl, ip, sp, lr}^
    1860:	6e6f6d5f 	mcrvs	13, 3, r6, cr15, cr15, {2}
    1864:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
    1868:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
    186c:	2f6c656e 	svccs	0x006c656e
    1870:	2f637273 	svccs	0x00637273
    1874:	72617473 	rsbvc	r7, r1, #1929379840	; 0x73000000
    1878:	00732e74 	rsbseq	r2, r3, r4, ror lr
    187c:	735f635f 	cmpvc	pc, #2080374785	; 0x7c000001
    1880:	74726174 	ldrbtvc	r6, [r2], #-372	; 0xfffffe8c
    1884:	5f007075 	svcpl	0x00007075
    1888:	5f737362 	svcpl	0x00737362
    188c:	72617473 	rsbvc	r7, r1, #1929379840	; 0x73000000
    1890:	5f5f0074 	svcpl	0x005f0074
    1894:	524f5443 	subpl	r5, pc, #1124073472	; 0x43000000
    1898:	444e455f 	strbmi	r4, [lr], #-1375	; 0xfffffaa1
    189c:	5f005f5f 	svcpl	0x00005f5f
    18a0:	4f54435f 	svcmi	0x0054435f
    18a4:	494c5f52 	stmdbmi	ip, {r1, r4, r6, r8, r9, sl, fp, ip, lr}^
    18a8:	5f5f5453 	svcpl	0x005f5453
    18ac:	445f5f00 	ldrbmi	r5, [pc], #-3840	; 18b4 <CPSR_IRQ_INHIBIT+0x1834>
    18b0:	5f524f54 	svcpl	0x00524f54
    18b4:	5f444e45 	svcpl	0x00444e45
    18b8:	635f005f 	cmpvs	pc, #95	; 0x5f
    18bc:	735f7070 	cmpvc	pc, #112	; 0x70
    18c0:	64747568 	ldrbtvs	r7, [r4], #-1384	; 0xfffffa98
    18c4:	006e776f 	rsbeq	r7, lr, pc, ror #14
    18c8:	7373625f 	cmnvc	r3, #-268435451	; 0xf0000005
    18cc:	646e655f 	strbtvs	r6, [lr], #-1375	; 0xfffffaa1
    18d0:	445f5f00 	ldrbmi	r5, [pc], #-3840	; 18d8 <CPSR_IRQ_INHIBIT+0x1858>
    18d4:	5f524f54 	svcpl	0x00524f54
    18d8:	5453494c 	ldrbpl	r4, [r3], #-2380	; 0xfffff6b4
    18dc:	64005f5f 	strvs	r5, [r0], #-3935	; 0xfffff0a1
    18e0:	5f726f74 	svcpl	0x00726f74
    18e4:	00727470 	rsbseq	r7, r2, r0, ror r4
    18e8:	726f7463 	rsbvc	r7, pc, #1660944384	; 0x63000000
    18ec:	7274705f 	rsbsvc	r7, r4, #95	; 0x5f
    18f0:	6f682f00 	svcvs	0x00682f00
    18f4:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
    18f8:	61686c69 	cmnvs	r8, r9, ror #24
    18fc:	2f6a7976 	svccs	0x006a7976
    1900:	6f686353 	svcvs	0x00686353
    1904:	5a2f6c6f 	bpl	bdcac8 <_bss_end+0xbd0dcc>
    1908:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 177c <CPSR_IRQ_INHIBIT+0x16fc>
    190c:	2f657461 	svccs	0x00657461
    1910:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
    1914:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
    1918:	2d33312f 	ldfcss	f3, [r3, #-188]!	; 0xffffff44
    191c:	746e6f63 	strbtvc	r6, [lr], #-3939	; 0xfffff09d
    1920:	5f747865 	svcpl	0x00747865
    1924:	74697773 	strbtvc	r7, [r9], #-1907	; 0xfffff88d
    1928:	6d5f6863 	ldclvs	8, cr6, [pc, #-396]	; 17a4 <CPSR_IRQ_INHIBIT+0x1724>
    192c:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
    1930:	6b2f726f 	blvs	bde2f4 <_bss_end+0xbd25f8>
    1934:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
    1938:	72732f6c 	rsbsvc	r2, r3, #108, 30	; 0x1b0
    193c:	74732f63 	ldrbtvc	r2, [r3], #-3939	; 0xfffff09d
    1940:	75747261 	ldrbvc	r7, [r4, #-609]!	; 0xfffffd9f
    1944:	70632e70 	rsbvc	r2, r3, r0, ror lr
    1948:	635f0070 	cmpvs	pc, #112	; 0x70
    194c:	735f7070 	cmpvc	pc, #112	; 0x70
    1950:	74726174 	ldrbtvc	r6, [r2], #-372	; 0xfffffe8c
    1954:	66007075 			; <UNDEFINED> instruction: 0x66007075
    1958:	7274706e 	rsbsvc	r7, r4, #110	; 0x6e
    195c:	6f682f00 	svcvs	0x00682f00
    1960:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
    1964:	61686c69 	cmnvs	r8, r9, ror #24
    1968:	2f6a7976 	svccs	0x006a7976
    196c:	6f686353 	svcvs	0x00686353
    1970:	5a2f6c6f 	bpl	bdcb34 <_bss_end+0xbd0e38>
    1974:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 17e8 <CPSR_IRQ_INHIBIT+0x1768>
    1978:	2f657461 	svccs	0x00657461
    197c:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
    1980:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
    1984:	2d33312f 	ldfcss	f3, [r3, #-188]!	; 0xffffff44
    1988:	746e6f63 	strbtvc	r6, [lr], #-3939	; 0xfffff09d
    198c:	5f747865 	svcpl	0x00747865
    1990:	74697773 	strbtvc	r7, [r9], #-1907	; 0xfffff88d
    1994:	6d5f6863 	ldclvs	8, cr6, [pc, #-396]	; 1810 <CPSR_IRQ_INHIBIT+0x1790>
    1998:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
    199c:	732f726f 			; <UNDEFINED> instruction: 0x732f726f
    19a0:	696c6474 	stmdbvs	ip!, {r2, r4, r5, r6, sl, sp, lr}^
    19a4:	72732f62 	rsbsvc	r2, r3, #392	; 0x188
    19a8:	74732f63 	ldrbtvc	r2, [r3], #-3939	; 0xfffff09d
    19ac:	72747364 	rsbsvc	r7, r4, #100, 6	; 0x90000001
    19b0:	2e676e69 	cdpcs	14, 6, cr6, cr7, cr9, {3}
    19b4:	00707063 	rsbseq	r7, r0, r3, rrx
    19b8:	69345a5f 	ldmdbvs	r4!, {r0, r1, r2, r3, r4, r6, r9, fp, ip, lr}
    19bc:	6a616f74 	bvs	185d794 <_bss_end+0x1851a98>
    19c0:	006a6350 	rsbeq	r6, sl, r0, asr r3
    19c4:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    19c8:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    19cc:	2f2e2e2f 	svccs	0x002e2e2f
    19d0:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    19d4:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
    19d8:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    19dc:	6e6f632f 	cdpvs	3, 6, cr6, cr15, cr15, {1}
    19e0:	2f676966 	svccs	0x00676966
    19e4:	2f6d7261 	svccs	0x006d7261
    19e8:	3162696c 	cmncc	r2, ip, ror #18
    19ec:	636e7566 	cmnvs	lr, #427819008	; 0x19800000
    19f0:	00532e73 	subseq	r2, r3, r3, ror lr
    19f4:	6975622f 	ldmdbvs	r5!, {r0, r1, r2, r3, r5, r9, sp, lr}^
    19f8:	672f646c 	strvs	r6, [pc, -ip, ror #8]!
    19fc:	612d6363 			; <UNDEFINED> instruction: 0x612d6363
    1a00:	6e2d6d72 	mcrvs	13, 1, r6, cr13, cr2, {3}
    1a04:	2d656e6f 	stclcs	14, cr6, [r5, #-444]!	; 0xfffffe44
    1a08:	69626165 	stmdbvs	r2!, {r0, r2, r5, r6, r8, sp, lr}^
    1a0c:	396c472d 	stmdbcc	ip!, {r0, r2, r3, r5, r8, r9, sl, lr}^
    1a10:	2f39546b 	svccs	0x0039546b
    1a14:	2d636367 	stclcs	3, cr6, [r3, #-412]!	; 0xfffffe64
    1a18:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
    1a1c:	656e6f6e 	strbvs	r6, [lr, #-3950]!	; 0xfffff092
    1a20:	6261652d 	rsbvs	r6, r1, #188743680	; 0xb400000
    1a24:	2d392d69 	ldccs	13, cr2, [r9, #-420]!	; 0xfffffe5c
    1a28:	39313032 	ldmdbcc	r1!, {r1, r4, r5, ip, sp}
    1a2c:	2f34712d 	svccs	0x0034712d
    1a30:	6c697562 	cfstr64vs	mvdx7, [r9], #-392	; 0xfffffe78
    1a34:	72612f64 	rsbvc	r2, r1, #100, 30	; 0x190
    1a38:	6f6e2d6d 	svcvs	0x006e2d6d
    1a3c:	652d656e 	strvs	r6, [sp, #-1390]!	; 0xfffffa92
    1a40:	2f696261 	svccs	0x00696261
    1a44:	2f6d7261 	svccs	0x006d7261
    1a48:	65743576 	ldrbvs	r3, [r4, #-1398]!	; 0xfffffa8a
    1a4c:	7261682f 	rsbvc	r6, r1, #3080192	; 0x2f0000
    1a50:	696c2f64 	stmdbvs	ip!, {r2, r5, r6, r8, r9, sl, fp, sp}^
    1a54:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    1a58:	52415400 	subpl	r5, r1, #0, 8
    1a5c:	5f544547 	svcpl	0x00544547
    1a60:	5f555043 	svcpl	0x00555043
    1a64:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1a68:	31617865 	cmncc	r1, r5, ror #16
    1a6c:	726f6337 	rsbvc	r6, pc, #-603979776	; 0xdc000000
    1a70:	61786574 	cmnvs	r8, r4, ror r5
    1a74:	73690037 	cmnvc	r9, #55	; 0x37
    1a78:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1a7c:	70665f74 	rsbvc	r5, r6, r4, ror pc
    1a80:	6c62645f 	cfstrdvs	mvd6, [r2], #-380	; 0xfffffe84
    1a84:	6d726100 	ldfvse	f6, [r2, #-0]
    1a88:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1a8c:	77695f68 	strbvc	r5, [r9, -r8, ror #30]!
    1a90:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
    1a94:	52415400 	subpl	r5, r1, #0, 8
    1a98:	5f544547 	svcpl	0x00544547
    1a9c:	5f555043 	svcpl	0x00555043
    1aa0:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1aa4:	326d7865 	rsbcc	r7, sp, #6619136	; 0x650000
    1aa8:	52410033 	subpl	r0, r1, #51	; 0x33
    1aac:	51455f4d 	cmppl	r5, sp, asr #30
    1ab0:	52415400 	subpl	r5, r1, #0, 8
    1ab4:	5f544547 	svcpl	0x00544547
    1ab8:	5f555043 	svcpl	0x00555043
    1abc:	316d7261 	cmncc	sp, r1, ror #4
    1ac0:	74363531 	ldrtvc	r3, [r6], #-1329	; 0xfffffacf
    1ac4:	00736632 	rsbseq	r6, r3, r2, lsr r6
    1ac8:	5f617369 	svcpl	0x00617369
    1acc:	5f746962 	svcpl	0x00746962
    1ad0:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    1ad4:	41540062 	cmpmi	r4, r2, rrx
    1ad8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1adc:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1ae0:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1ae4:	61786574 	cmnvs	r8, r4, ror r5
    1ae8:	6f633735 	svcvs	0x00633735
    1aec:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1af0:	00333561 	eorseq	r3, r3, r1, ror #10
    1af4:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1af8:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1afc:	4d385f48 	ldcmi	15, cr5, [r8, #-288]!	; 0xfffffee0
    1b00:	5341425f 	movtpl	r4, #4703	; 0x125f
    1b04:	41540045 	cmpmi	r4, r5, asr #32
    1b08:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1b0c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1b10:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1b14:	00303138 	eorseq	r3, r0, r8, lsr r1
    1b18:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1b1c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1b20:	785f5550 	ldmdavc	pc, {r4, r6, r8, sl, ip, lr}^	; <UNPREDICTABLE>
    1b24:	656e6567 	strbvs	r6, [lr, #-1383]!	; 0xfffffa99
    1b28:	52410031 	subpl	r0, r1, #49	; 0x31
    1b2c:	43505f4d 	cmpmi	r0, #308	; 0x134
    1b30:	41415f53 	cmpmi	r1, r3, asr pc
    1b34:	5f534350 	svcpl	0x00534350
    1b38:	4d4d5749 	stclmi	7, cr5, [sp, #-292]	; 0xfffffedc
    1b3c:	42005458 	andmi	r5, r0, #88, 8	; 0x58000000
    1b40:	5f455341 	svcpl	0x00455341
    1b44:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1b48:	4200305f 	andmi	r3, r0, #95	; 0x5f
    1b4c:	5f455341 	svcpl	0x00455341
    1b50:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1b54:	4200325f 	andmi	r3, r0, #-268435451	; 0xf0000005
    1b58:	5f455341 	svcpl	0x00455341
    1b5c:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1b60:	4200335f 	andmi	r3, r0, #2080374785	; 0x7c000001
    1b64:	5f455341 	svcpl	0x00455341
    1b68:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1b6c:	4200345f 	andmi	r3, r0, #1593835520	; 0x5f000000
    1b70:	5f455341 	svcpl	0x00455341
    1b74:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1b78:	4200365f 	andmi	r3, r0, #99614720	; 0x5f00000
    1b7c:	5f455341 	svcpl	0x00455341
    1b80:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1b84:	5400375f 	strpl	r3, [r0], #-1887	; 0xfffff8a1
    1b88:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1b8c:	50435f54 	subpl	r5, r3, r4, asr pc
    1b90:	73785f55 	cmnvc	r8, #340	; 0x154
    1b94:	656c6163 	strbvs	r6, [ip, #-355]!	; 0xfffffe9d
    1b98:	61736900 	cmnvs	r3, r0, lsl #18
    1b9c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1ba0:	6572705f 	ldrbvs	r7, [r2, #-95]!	; 0xffffffa1
    1ba4:	73657264 	cmnvc	r5, #100, 4	; 0x40000006
    1ba8:	52415400 	subpl	r5, r1, #0, 8
    1bac:	5f544547 	svcpl	0x00544547
    1bb0:	5f555043 	svcpl	0x00555043
    1bb4:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1bb8:	336d7865 	cmncc	sp, #6619136	; 0x650000
    1bbc:	41540033 	cmpmi	r4, r3, lsr r0
    1bc0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1bc4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1bc8:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1bcc:	6d647437 	cfstrdvs	mvd7, [r4, #-220]!	; 0xffffff24
    1bd0:	73690069 	cmnvc	r9, #105	; 0x69
    1bd4:	6f6e5f61 	svcvs	0x006e5f61
    1bd8:	00746962 	rsbseq	r6, r4, r2, ror #18
    1bdc:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1be0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1be4:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1be8:	31316d72 	teqcc	r1, r2, ror sp
    1bec:	7a6a3637 	bvc	1a8f4d0 <_bss_end+0x1a837d4>
    1bf0:	69007366 	stmdbvs	r0, {r1, r2, r5, r6, r8, r9, ip, sp, lr}
    1bf4:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1bf8:	765f7469 	ldrbvc	r7, [pc], -r9, ror #8
    1bfc:	32767066 	rsbscc	r7, r6, #102	; 0x66
    1c00:	4d524100 	ldfmie	f4, [r2, #-0]
    1c04:	5343505f 	movtpl	r5, #12383	; 0x305f
    1c08:	4b4e555f 	blmi	139718c <_bss_end+0x138b490>
    1c0c:	4e574f4e 	cdpmi	15, 5, cr4, cr7, cr14, {2}
    1c10:	52415400 	subpl	r5, r1, #0, 8
    1c14:	5f544547 	svcpl	0x00544547
    1c18:	5f555043 	svcpl	0x00555043
    1c1c:	396d7261 	stmdbcc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    1c20:	41420065 	cmpmi	r2, r5, rrx
    1c24:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1c28:	5f484352 	svcpl	0x00484352
    1c2c:	4a455435 	bmi	1156d08 <_bss_end+0x114b00c>
    1c30:	6d726100 	ldfvse	f6, [r2, #-0]
    1c34:	6663635f 			; <UNDEFINED> instruction: 0x6663635f
    1c38:	735f6d73 	cmpvc	pc, #7360	; 0x1cc0
    1c3c:	65746174 	ldrbvs	r6, [r4, #-372]!	; 0xfffffe8c
    1c40:	6d726100 	ldfvse	f6, [r2, #-0]
    1c44:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1c48:	65743568 	ldrbvs	r3, [r4, #-1384]!	; 0xfffffa98
    1c4c:	736e7500 	cmnvc	lr, #0, 10
    1c50:	5f636570 	svcpl	0x00636570
    1c54:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
    1c58:	0073676e 	rsbseq	r6, r3, lr, ror #14
    1c5c:	5f617369 	svcpl	0x00617369
    1c60:	5f746962 	svcpl	0x00746962
    1c64:	00636573 	rsbeq	r6, r3, r3, ror r5
    1c68:	6c635f5f 	stclvs	15, cr5, [r3], #-380	; 0xfffffe84
    1c6c:	61745f7a 	cmnvs	r4, sl, ror pc
    1c70:	52410062 	subpl	r0, r1, #98	; 0x62
    1c74:	43565f4d 	cmpmi	r6, #308	; 0x134
    1c78:	6d726100 	ldfvse	f6, [r2, #-0]
    1c7c:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1c80:	73785f68 	cmnvc	r8, #104, 30	; 0x1a0
    1c84:	656c6163 	strbvs	r6, [ip, #-355]!	; 0xfffffe9d
    1c88:	4d524100 	ldfmie	f4, [r2, #-0]
    1c8c:	00454c5f 	subeq	r4, r5, pc, asr ip
    1c90:	5f4d5241 	svcpl	0x004d5241
    1c94:	41005356 	tstmi	r0, r6, asr r3
    1c98:	475f4d52 			; <UNDEFINED> instruction: 0x475f4d52
    1c9c:	72610045 	rsbvc	r0, r1, #69	; 0x45
    1ca0:	75745f6d 	ldrbvc	r5, [r4, #-3949]!	; 0xfffff093
    1ca4:	735f656e 	cmpvc	pc, #461373440	; 0x1b800000
    1ca8:	6e6f7274 	mcrvs	2, 3, r7, cr15, cr4, {3}
    1cac:	6d726167 	ldfvse	f6, [r2, #-412]!	; 0xfffffe64
    1cb0:	6d6f6300 	stclvs	3, cr6, [pc, #-0]	; 1cb8 <CPSR_IRQ_INHIBIT+0x1c38>
    1cb4:	78656c70 	stmdavc	r5!, {r4, r5, r6, sl, fp, sp, lr}^
    1cb8:	6f6c6620 	svcvs	0x006c6620
    1cbc:	54007461 	strpl	r7, [r0], #-1121	; 0xfffffb9f
    1cc0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1cc4:	50435f54 	subpl	r5, r3, r4, asr pc
    1cc8:	6f635f55 	svcvs	0x00635f55
    1ccc:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1cd0:	00353161 	eorseq	r3, r5, r1, ror #2
    1cd4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1cd8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1cdc:	665f5550 			; <UNDEFINED> instruction: 0x665f5550
    1ce0:	36323761 	ldrtcc	r3, [r2], -r1, ror #14
    1ce4:	54006574 	strpl	r6, [r0], #-1396	; 0xfffffa8c
    1ce8:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1cec:	50435f54 	subpl	r5, r3, r4, asr pc
    1cf0:	6f635f55 	svcvs	0x00635f55
    1cf4:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1cf8:	00373161 	eorseq	r3, r7, r1, ror #2
    1cfc:	5f4d5241 	svcpl	0x004d5241
    1d00:	54005447 	strpl	r5, [r0], #-1095	; 0xfffffbb9
    1d04:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1d08:	50435f54 	subpl	r5, r3, r4, asr pc
    1d0c:	656e5f55 	strbvs	r5, [lr, #-3925]!	; 0xfffff0ab
    1d10:	7265766f 	rsbvc	r7, r5, #116391936	; 0x6f00000
    1d14:	316e6573 	smccc	58963	; 0xe653
    1d18:	2f2e2e00 	svccs	0x002e2e00
    1d1c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1d20:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1d24:	2f2e2e2f 	svccs	0x002e2e2f
    1d28:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 1c78 <CPSR_IRQ_INHIBIT+0x1bf8>
    1d2c:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1d30:	696c2f63 	stmdbvs	ip!, {r0, r1, r5, r6, r8, r9, sl, fp, sp}^
    1d34:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    1d38:	00632e32 	rsbeq	r2, r3, r2, lsr lr
    1d3c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1d40:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1d44:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1d48:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1d4c:	66347278 			; <UNDEFINED> instruction: 0x66347278
    1d50:	53414200 	movtpl	r4, #4608	; 0x1200
    1d54:	52415f45 	subpl	r5, r1, #276	; 0x114
    1d58:	375f4843 	ldrbcc	r4, [pc, -r3, asr #16]
    1d5c:	54004d45 	strpl	r4, [r0], #-3397	; 0xfffff2bb
    1d60:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1d64:	50435f54 	subpl	r5, r3, r4, asr pc
    1d68:	6f635f55 	svcvs	0x00635f55
    1d6c:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1d70:	00323161 	eorseq	r3, r2, r1, ror #2
    1d74:	68736168 	ldmdavs	r3!, {r3, r5, r6, r8, sp, lr}^
    1d78:	5f6c6176 	svcpl	0x006c6176
    1d7c:	41420074 	hvcmi	8196	; 0x2004
    1d80:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1d84:	5f484352 	svcpl	0x00484352
    1d88:	005a4b36 	subseq	r4, sl, r6, lsr fp
    1d8c:	5f617369 	svcpl	0x00617369
    1d90:	73746962 	cmnvc	r4, #1605632	; 0x188000
    1d94:	6d726100 	ldfvse	f6, [r2, #-0]
    1d98:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1d9c:	72615f68 	rsbvc	r5, r1, #104, 30	; 0x1a0
    1da0:	77685f6d 	strbvc	r5, [r8, -sp, ror #30]!
    1da4:	00766964 	rsbseq	r6, r6, r4, ror #18
    1da8:	5f6d7261 	svcpl	0x006d7261
    1dac:	5f757066 	svcpl	0x00757066
    1db0:	63736564 	cmnvs	r3, #100, 10	; 0x19000000
    1db4:	61736900 	cmnvs	r3, r0, lsl #18
    1db8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1dbc:	3170665f 	cmncc	r0, pc, asr r6
    1dc0:	4e470036 	mcrmi	0, 2, r0, cr7, cr6, {1}
    1dc4:	31432055 	qdaddcc	r2, r5, r3
    1dc8:	2e392037 	mrccs	0, 1, r2, cr9, cr7, {1}
    1dcc:	20312e32 	eorscs	r2, r1, r2, lsr lr
    1dd0:	39313032 	ldmdbcc	r1!, {r1, r4, r5, ip, sp}
    1dd4:	35323031 	ldrcc	r3, [r2, #-49]!	; 0xffffffcf
    1dd8:	65722820 	ldrbvs	r2, [r2, #-2080]!	; 0xfffff7e0
    1ddc:	7361656c 	cmnvc	r1, #108, 10	; 0x1b000000
    1de0:	5b202965 	blpl	80c37c <_bss_end+0x800680>
    1de4:	2f4d5241 	svccs	0x004d5241
    1de8:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
    1dec:	72622d39 	rsbvc	r2, r2, #3648	; 0xe40
    1df0:	68636e61 	stmdavs	r3!, {r0, r5, r6, r9, sl, fp, sp, lr}^
    1df4:	76657220 	strbtvc	r7, [r5], -r0, lsr #4
    1df8:	6f697369 	svcvs	0x00697369
    1dfc:	3732206e 	ldrcc	r2, [r2, -lr, rrx]!
    1e00:	39393537 	ldmdbcc	r9!, {r0, r1, r2, r4, r5, r8, sl, ip, sp}
    1e04:	6d2d205d 	stcvs	0, cr2, [sp, #-372]!	; 0xfffffe8c
    1e08:	206d7261 	rsbcs	r7, sp, r1, ror #4
    1e0c:	6c666d2d 	stclvs	13, cr6, [r6], #-180	; 0xffffff4c
    1e10:	2d74616f 	ldfcse	f6, [r4, #-444]!	; 0xfffffe44
    1e14:	3d696261 	sfmcc	f6, 2, [r9, #-388]!	; 0xfffffe7c
    1e18:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
    1e1c:	616d2d20 	cmnvs	sp, r0, lsr #26
    1e20:	3d686372 	stclcc	3, cr6, [r8, #-456]!	; 0xfffffe38
    1e24:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1e28:	2b657435 	blcs	195ef04 <_bss_end+0x1953208>
    1e2c:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
    1e30:	672d2067 	strvs	r2, [sp, -r7, rrx]!
    1e34:	20672d20 	rsbcs	r2, r7, r0, lsr #26
    1e38:	20324f2d 	eorscs	r4, r2, sp, lsr #30
    1e3c:	20324f2d 	eorscs	r4, r2, sp, lsr #30
    1e40:	20324f2d 	eorscs	r4, r2, sp, lsr #30
    1e44:	7562662d 	strbvc	r6, [r2, #-1581]!	; 0xfffff9d3
    1e48:	69646c69 	stmdbvs	r4!, {r0, r3, r5, r6, sl, fp, sp, lr}^
    1e4c:	6c2d676e 	stcvs	7, cr6, [sp], #-440	; 0xfffffe48
    1e50:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1e54:	662d2063 	strtvs	r2, [sp], -r3, rrx
    1e58:	732d6f6e 			; <UNDEFINED> instruction: 0x732d6f6e
    1e5c:	6b636174 	blvs	18da434 <_bss_end+0x18ce738>
    1e60:	6f72702d 	svcvs	0x0072702d
    1e64:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
    1e68:	2d20726f 	sfmcs	f7, 4, [r0, #-444]!	; 0xfffffe44
    1e6c:	2d6f6e66 	stclcs	14, cr6, [pc, #-408]!	; 1cdc <CPSR_IRQ_INHIBIT+0x1c5c>
    1e70:	696c6e69 	stmdbvs	ip!, {r0, r3, r5, r6, r9, sl, fp, sp, lr}^
    1e74:	2d20656e 	cfstr32cs	mvfx6, [r0, #-440]!	; 0xfffffe48
    1e78:	73697666 	cmnvc	r9, #106954752	; 0x6600000
    1e7c:	6c696269 	sfmvs	f6, 2, [r9], #-420	; 0xfffffe5c
    1e80:	3d797469 	cfldrdcc	mvd7, [r9, #-420]!	; 0xfffffe5c
    1e84:	64646968 	strbtvs	r6, [r4], #-2408	; 0xfffff698
    1e88:	41006e65 	tstmi	r0, r5, ror #28
    1e8c:	485f4d52 	ldmdami	pc, {r1, r4, r6, r8, sl, fp, lr}^	; <UNPREDICTABLE>
    1e90:	73690049 	cmnvc	r9, #73	; 0x49
    1e94:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1e98:	64615f74 	strbtvs	r5, [r1], #-3956	; 0xfffff08c
    1e9c:	54007669 	strpl	r7, [r0], #-1641	; 0xfffff997
    1ea0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1ea4:	50435f54 	subpl	r5, r3, r4, asr pc
    1ea8:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1eac:	3331316d 	teqcc	r1, #1073741851	; 0x4000001b
    1eb0:	00736a36 	rsbseq	r6, r3, r6, lsr sl
    1eb4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1eb8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1ebc:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1ec0:	00386d72 	eorseq	r6, r8, r2, ror sp
    1ec4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1ec8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1ecc:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1ed0:	00396d72 	eorseq	r6, r9, r2, ror sp
    1ed4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1ed8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1edc:	665f5550 			; <UNDEFINED> instruction: 0x665f5550
    1ee0:	36323661 	ldrtcc	r3, [r2], -r1, ror #12
    1ee4:	6e6f6c00 	cdpvs	12, 6, cr6, cr15, cr0, {0}
    1ee8:	6f6c2067 	svcvs	0x006c2067
    1eec:	7520676e 	strvc	r6, [r0, #-1902]!	; 0xfffff892
    1ef0:	6769736e 	strbvs	r7, [r9, -lr, ror #6]!
    1ef4:	2064656e 	rsbcs	r6, r4, lr, ror #10
    1ef8:	00746e69 	rsbseq	r6, r4, r9, ror #28
    1efc:	5f6d7261 	svcpl	0x006d7261
    1f00:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1f04:	736d635f 	cmnvc	sp, #2080374785	; 0x7c000001
    1f08:	41540065 	cmpmi	r4, r5, rrx
    1f0c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1f10:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1f14:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1f18:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    1f1c:	41540034 	cmpmi	r4, r4, lsr r0
    1f20:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1f24:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1f28:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1f2c:	00653031 	rsbeq	r3, r5, r1, lsr r0
    1f30:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1f34:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1f38:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1f3c:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1f40:	00376d78 	eorseq	r6, r7, r8, ror sp
    1f44:	5f6d7261 	svcpl	0x006d7261
    1f48:	646e6f63 	strbtvs	r6, [lr], #-3939	; 0xfffff09d
    1f4c:	646f635f 	strbtvs	r6, [pc], #-863	; 1f54 <CPSR_IRQ_INHIBIT+0x1ed4>
    1f50:	52410065 	subpl	r0, r1, #101	; 0x65
    1f54:	43505f4d 	cmpmi	r0, #308	; 0x134
    1f58:	41415f53 	cmpmi	r1, r3, asr pc
    1f5c:	00534350 	subseq	r4, r3, r0, asr r3
    1f60:	5f617369 	svcpl	0x00617369
    1f64:	5f746962 	svcpl	0x00746962
    1f68:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1f6c:	00325f38 	eorseq	r5, r2, r8, lsr pc
    1f70:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1f74:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1f78:	4d335f48 	ldcmi	15, cr5, [r3, #-288]!	; 0xfffffee0
    1f7c:	52415400 	subpl	r5, r1, #0, 8
    1f80:	5f544547 	svcpl	0x00544547
    1f84:	5f555043 	svcpl	0x00555043
    1f88:	376d7261 	strbcc	r7, [sp, -r1, ror #4]!
    1f8c:	00743031 	rsbseq	r3, r4, r1, lsr r0
    1f90:	5f6d7261 	svcpl	0x006d7261
    1f94:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1f98:	6d77695f 			; <UNDEFINED> instruction: 0x6d77695f
    1f9c:	3274786d 	rsbscc	r7, r4, #7143424	; 0x6d0000
    1fa0:	61736900 	cmnvs	r3, r0, lsl #18
    1fa4:	6d756e5f 	ldclvs	14, cr6, [r5, #-380]!	; 0xfffffe84
    1fa8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1fac:	41540073 	cmpmi	r4, r3, ror r0
    1fb0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1fb4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1fb8:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1fbc:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    1fc0:	756c7030 	strbvc	r7, [ip, #-48]!	; 0xffffffd0
    1fc4:	616d7373 	smcvs	55091	; 0xd733
    1fc8:	756d6c6c 	strbvc	r6, [sp, #-3180]!	; 0xfffff394
    1fcc:	7069746c 	rsbvc	r7, r9, ip, ror #8
    1fd0:	5400796c 	strpl	r7, [r0], #-2412	; 0xfffff694
    1fd4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1fd8:	50435f54 	subpl	r5, r3, r4, asr pc
    1fdc:	78655f55 	stmdavc	r5!, {r0, r2, r4, r6, r8, r9, sl, fp, ip, lr}^
    1fe0:	736f6e79 	cmnvc	pc, #1936	; 0x790
    1fe4:	5400316d 	strpl	r3, [r0], #-365	; 0xfffffe93
    1fe8:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1fec:	50435f54 	subpl	r5, r3, r4, asr pc
    1ff0:	6f635f55 	svcvs	0x00635f55
    1ff4:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1ff8:	00323572 	eorseq	r3, r2, r2, ror r5
    1ffc:	5f617369 	svcpl	0x00617369
    2000:	5f746962 	svcpl	0x00746962
    2004:	76696474 			; <UNDEFINED> instruction: 0x76696474
    2008:	65727000 	ldrbvs	r7, [r2, #-0]!
    200c:	5f726566 	svcpl	0x00726566
    2010:	6e6f656e 	cdpvs	5, 6, cr6, cr15, cr14, {3}
    2014:	726f665f 	rsbvc	r6, pc, #99614720	; 0x5f00000
    2018:	6234365f 	eorsvs	r3, r4, #99614720	; 0x5f00000
    201c:	00737469 	rsbseq	r7, r3, r9, ror #8
    2020:	5f617369 	svcpl	0x00617369
    2024:	5f746962 	svcpl	0x00746962
    2028:	36317066 	ldrtcc	r7, [r1], -r6, rrx
    202c:	006c6d66 	rsbeq	r6, ip, r6, ror #26
    2030:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2034:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2038:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    203c:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2040:	32336178 	eorscc	r6, r3, #120, 2
    2044:	52415400 	subpl	r5, r1, #0, 8
    2048:	5f544547 	svcpl	0x00544547
    204c:	5f555043 	svcpl	0x00555043
    2050:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2054:	33617865 	cmncc	r1, #6619136	; 0x650000
    2058:	73690035 	cmnvc	r9, #53	; 0x35
    205c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2060:	70665f74 	rsbvc	r5, r6, r4, ror pc
    2064:	6f633631 	svcvs	0x00633631
    2068:	7500766e 	strvc	r7, [r0, #-1646]	; 0xfffff992
    206c:	6570736e 	ldrbvs	r7, [r0, #-878]!	; 0xfffffc92
    2070:	735f7663 	cmpvc	pc, #103809024	; 0x6300000
    2074:	6e697274 	mcrvs	2, 3, r7, cr9, cr4, {3}
    2078:	54007367 	strpl	r7, [r0], #-871	; 0xfffffc99
    207c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2080:	50435f54 	subpl	r5, r3, r4, asr pc
    2084:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    2088:	3531316d 	ldrcc	r3, [r1, #-365]!	; 0xfffffe93
    208c:	73327436 	teqvc	r2, #905969664	; 0x36000000
    2090:	52415400 	subpl	r5, r1, #0, 8
    2094:	5f544547 	svcpl	0x00544547
    2098:	5f555043 	svcpl	0x00555043
    209c:	30366166 	eorscc	r6, r6, r6, ror #2
    20a0:	00657436 	rsbeq	r7, r5, r6, lsr r4
    20a4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    20a8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    20ac:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    20b0:	32396d72 	eorscc	r6, r9, #7296	; 0x1c80
    20b4:	736a6536 	cmnvc	sl, #226492416	; 0xd800000
    20b8:	53414200 	movtpl	r4, #4608	; 0x1200
    20bc:	52415f45 	subpl	r5, r1, #276	; 0x114
    20c0:	345f4843 	ldrbcc	r4, [pc], #-2115	; 20c8 <CPSR_IRQ_INHIBIT+0x2048>
    20c4:	73690054 	cmnvc	r9, #84	; 0x54
    20c8:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    20cc:	72635f74 	rsbvc	r5, r3, #116, 30	; 0x1d0
    20d0:	6f747079 	svcvs	0x00747079
    20d4:	6d726100 	ldfvse	f6, [r2, #-0]
    20d8:	6765725f 			; <UNDEFINED> instruction: 0x6765725f
    20dc:	6e695f73 	mcrvs	15, 3, r5, cr9, cr3, {3}
    20e0:	7165735f 	cmnvc	r5, pc, asr r3
    20e4:	636e6575 	cmnvs	lr, #490733568	; 0x1d400000
    20e8:	73690065 	cmnvc	r9, #101	; 0x65
    20ec:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    20f0:	62735f74 	rsbsvs	r5, r3, #116, 30	; 0x1d0
    20f4:	53414200 	movtpl	r4, #4608	; 0x1200
    20f8:	52415f45 	subpl	r5, r1, #276	; 0x114
    20fc:	355f4843 	ldrbcc	r4, [pc, #-2115]	; 18c1 <CPSR_IRQ_INHIBIT+0x1841>
    2100:	69004554 	stmdbvs	r0, {r2, r4, r6, r8, sl, lr}
    2104:	665f6173 			; <UNDEFINED> instruction: 0x665f6173
    2108:	75746165 	ldrbvc	r6, [r4, #-357]!	; 0xfffffe9b
    210c:	69006572 	stmdbvs	r0, {r1, r4, r5, r6, r8, sl, sp, lr}
    2110:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2114:	735f7469 	cmpvc	pc, #1761607680	; 0x69000000
    2118:	6c6c616d 	stfvse	f6, [ip], #-436	; 0xfffffe4c
    211c:	006c756d 	rsbeq	r7, ip, sp, ror #10
    2120:	5f6d7261 	svcpl	0x006d7261
    2124:	676e616c 	strbvs	r6, [lr, -ip, ror #2]!
    2128:	74756f5f 	ldrbtvc	r6, [r5], #-3935	; 0xfffff0a1
    212c:	5f747570 	svcpl	0x00747570
    2130:	656a626f 	strbvs	r6, [sl, #-623]!	; 0xfffffd91
    2134:	615f7463 	cmpvs	pc, r3, ror #8
    2138:	69727474 	ldmdbvs	r2!, {r2, r4, r5, r6, sl, ip, sp, lr}^
    213c:	65747562 	ldrbvs	r7, [r4, #-1378]!	; 0xfffffa9e
    2140:	6f685f73 	svcvs	0x00685f73
    2144:	69006b6f 	stmdbvs	r0, {r0, r1, r2, r3, r5, r6, r8, r9, fp, sp, lr}
    2148:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    214c:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    2150:	33645f70 	cmncc	r4, #112, 30	; 0x1c0
    2154:	52410032 	subpl	r0, r1, #50	; 0x32
    2158:	454e5f4d 	strbmi	r5, [lr, #-3917]	; 0xfffff0b3
    215c:	61736900 	cmnvs	r3, r0, lsl #18
    2160:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2164:	3865625f 	stmdacc	r5!, {r0, r1, r2, r3, r4, r6, r9, sp, lr}^
    2168:	52415400 	subpl	r5, r1, #0, 8
    216c:	5f544547 	svcpl	0x00544547
    2170:	5f555043 	svcpl	0x00555043
    2174:	316d7261 	cmncc	sp, r1, ror #4
    2178:	6a363731 	bvs	d8fe44 <_bss_end+0xd84148>
    217c:	7000737a 	andvc	r7, r0, sl, ror r3
    2180:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    2184:	726f7373 	rsbvc	r7, pc, #-872415231	; 0xcc000001
    2188:	7079745f 	rsbsvc	r7, r9, pc, asr r4
    218c:	6c610065 	stclvs	0, cr0, [r1], #-404	; 0xfffffe6c
    2190:	70665f6c 	rsbvc	r5, r6, ip, ror #30
    2194:	61007375 	tstvs	r0, r5, ror r3
    2198:	705f6d72 	subsvc	r6, pc, r2, ror sp	; <UNPREDICTABLE>
    219c:	42007363 	andmi	r7, r0, #-1946157055	; 0x8c000001
    21a0:	5f455341 	svcpl	0x00455341
    21a4:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    21a8:	0054355f 	subseq	r3, r4, pc, asr r5
    21ac:	5f6d7261 	svcpl	0x006d7261
    21b0:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    21b4:	54007434 	strpl	r7, [r0], #-1076	; 0xfffffbcc
    21b8:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    21bc:	50435f54 	subpl	r5, r3, r4, asr pc
    21c0:	6f635f55 	svcvs	0x00635f55
    21c4:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    21c8:	63363761 	teqvs	r6, #25427968	; 0x1840000
    21cc:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    21d0:	35356178 	ldrcc	r6, [r5, #-376]!	; 0xfffffe88
    21d4:	6d726100 	ldfvse	f6, [r2, #-0]
    21d8:	6e75745f 	mrcvs	4, 3, r7, cr5, cr15, {2}
    21dc:	62775f65 	rsbsvs	r5, r7, #404	; 0x194
    21e0:	68006675 	stmdavs	r0, {r0, r2, r4, r5, r6, r9, sl, sp, lr}
    21e4:	5f626174 	svcpl	0x00626174
    21e8:	68736168 	ldmdavs	r3!, {r3, r5, r6, r8, sp, lr}^
    21ec:	61736900 	cmnvs	r3, r0, lsl #18
    21f0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    21f4:	6975715f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, r8, ip, sp, lr}^
    21f8:	6e5f6b72 	vmovvs.s8	r6, d15[3]
    21fc:	6f765f6f 	svcvs	0x00765f6f
    2200:	6974616c 	ldmdbvs	r4!, {r2, r3, r5, r6, r8, sp, lr}^
    2204:	635f656c 	cmpvs	pc, #108, 10	; 0x1b000000
    2208:	41540065 	cmpmi	r4, r5, rrx
    220c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2210:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2214:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2218:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    221c:	41540030 	cmpmi	r4, r0, lsr r0
    2220:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2224:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2228:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    222c:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    2230:	41540031 	cmpmi	r4, r1, lsr r0
    2234:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2238:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    223c:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2240:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    2244:	73690033 	cmnvc	r9, #51	; 0x33
    2248:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    224c:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    2250:	5f38766d 	svcpl	0x0038766d
    2254:	72610031 	rsbvc	r0, r1, #49	; 0x31
    2258:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    225c:	6e5f6863 	cdpvs	8, 5, cr6, cr15, cr3, {3}
    2260:	00656d61 	rsbeq	r6, r5, r1, ror #26
    2264:	5f617369 	svcpl	0x00617369
    2268:	5f746962 	svcpl	0x00746962
    226c:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    2270:	00335f38 	eorseq	r5, r3, r8, lsr pc
    2274:	5f617369 	svcpl	0x00617369
    2278:	5f746962 	svcpl	0x00746962
    227c:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    2280:	00345f38 	eorseq	r5, r4, r8, lsr pc
    2284:	5f617369 	svcpl	0x00617369
    2288:	5f746962 	svcpl	0x00746962
    228c:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    2290:	00355f38 	eorseq	r5, r5, r8, lsr pc
    2294:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2298:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    229c:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    22a0:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    22a4:	33356178 	teqcc	r5, #120, 2
    22a8:	52415400 	subpl	r5, r1, #0, 8
    22ac:	5f544547 	svcpl	0x00544547
    22b0:	5f555043 	svcpl	0x00555043
    22b4:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    22b8:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    22bc:	41540035 	cmpmi	r4, r5, lsr r0
    22c0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    22c4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    22c8:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    22cc:	61786574 	cmnvs	r8, r4, ror r5
    22d0:	54003735 	strpl	r3, [r0], #-1845	; 0xfffff8cb
    22d4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    22d8:	50435f54 	subpl	r5, r3, r4, asr pc
    22dc:	706d5f55 	rsbvc	r5, sp, r5, asr pc
    22e0:	65726f63 	ldrbvs	r6, [r2, #-3939]!	; 0xfffff09d
    22e4:	52415400 	subpl	r5, r1, #0, 8
    22e8:	5f544547 	svcpl	0x00544547
    22ec:	5f555043 	svcpl	0x00555043
    22f0:	5f6d7261 	svcpl	0x006d7261
    22f4:	656e6f6e 	strbvs	r6, [lr, #-3950]!	; 0xfffff092
    22f8:	6d726100 	ldfvse	f6, [r2, #-0]
    22fc:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    2300:	6f6e5f68 	svcvs	0x006e5f68
    2304:	54006d74 	strpl	r6, [r0], #-3444	; 0xfffff28c
    2308:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    230c:	50435f54 	subpl	r5, r3, r4, asr pc
    2310:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    2314:	3230316d 	eorscc	r3, r0, #1073741851	; 0x4000001b
    2318:	736a6536 	cmnvc	sl, #226492416	; 0xd800000
    231c:	53414200 	movtpl	r4, #4608	; 0x1200
    2320:	52415f45 	subpl	r5, r1, #276	; 0x114
    2324:	365f4843 	ldrbcc	r4, [pc], -r3, asr #16
    2328:	4142004a 	cmpmi	r2, sl, asr #32
    232c:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    2330:	5f484352 	svcpl	0x00484352
    2334:	42004b36 	andmi	r4, r0, #55296	; 0xd800
    2338:	5f455341 	svcpl	0x00455341
    233c:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    2340:	004d365f 	subeq	r3, sp, pc, asr r6
    2344:	5f617369 	svcpl	0x00617369
    2348:	5f746962 	svcpl	0x00746962
    234c:	6d6d7769 	stclvs	7, cr7, [sp, #-420]!	; 0xfffffe5c
    2350:	54007478 	strpl	r7, [r0], #-1144	; 0xfffffb88
    2354:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2358:	50435f54 	subpl	r5, r3, r4, asr pc
    235c:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    2360:	3331316d 	teqcc	r1, #1073741851	; 0x4000001b
    2364:	73666a36 	cmnvc	r6, #221184	; 0x36000
    2368:	4d524100 	ldfmie	f4, [r2, #-0]
    236c:	00534c5f 	subseq	r4, r3, pc, asr ip
    2370:	5f4d5241 	svcpl	0x004d5241
    2374:	4200544c 	andmi	r5, r0, #76, 8	; 0x4c000000
    2378:	5f455341 	svcpl	0x00455341
    237c:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    2380:	005a365f 	subseq	r3, sl, pc, asr r6
    2384:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2388:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    238c:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2390:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2394:	35376178 	ldrcc	r6, [r7, #-376]!	; 0xfffffe88
    2398:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    239c:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    23a0:	52410035 	subpl	r0, r1, #53	; 0x35
    23a4:	43505f4d 	cmpmi	r0, #308	; 0x134
    23a8:	41415f53 	cmpmi	r1, r3, asr pc
    23ac:	5f534350 	svcpl	0x00534350
    23b0:	00504656 	subseq	r4, r0, r6, asr r6
    23b4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    23b8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    23bc:	695f5550 	ldmdbvs	pc, {r4, r6, r8, sl, ip, lr}^	; <UNPREDICTABLE>
    23c0:	786d6d77 	stmdavc	sp!, {r0, r1, r2, r4, r5, r6, r8, sl, fp, sp, lr}^
    23c4:	69003274 	stmdbvs	r0, {r2, r4, r5, r6, r9, ip, sp}
    23c8:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    23cc:	6e5f7469 	cdpvs	4, 5, cr7, cr15, cr9, {3}
    23d0:	006e6f65 	rsbeq	r6, lr, r5, ror #30
    23d4:	5f6d7261 	svcpl	0x006d7261
    23d8:	5f757066 	svcpl	0x00757066
    23dc:	72747461 	rsbsvc	r7, r4, #1627389952	; 0x61000000
    23e0:	61736900 	cmnvs	r3, r0, lsl #18
    23e4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    23e8:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    23ec:	6d653776 	stclvs	7, cr3, [r5, #-472]!	; 0xfffffe28
    23f0:	52415400 	subpl	r5, r1, #0, 8
    23f4:	5f544547 	svcpl	0x00544547
    23f8:	5f555043 	svcpl	0x00555043
    23fc:	32366166 	eorscc	r6, r6, #-2147483623	; 0x80000019
    2400:	00657436 	rsbeq	r7, r5, r6, lsr r4
    2404:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2408:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    240c:	6d5f5550 	cfldr64vs	mvdx5, [pc, #-320]	; 22d4 <CPSR_IRQ_INHIBIT+0x2254>
    2410:	65767261 	ldrbvs	r7, [r6, #-609]!	; 0xfffffd9f
    2414:	705f6c6c 	subsvc	r6, pc, ip, ror #24
    2418:	6800346a 	stmdavs	r0, {r1, r3, r5, r6, sl, ip, sp}
    241c:	5f626174 	svcpl	0x00626174
    2420:	68736168 	ldmdavs	r3!, {r3, r5, r6, r8, sp, lr}^
    2424:	696f705f 	stmdbvs	pc!, {r0, r1, r2, r3, r4, r6, ip, sp, lr}^	; <UNPREDICTABLE>
    2428:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
    242c:	6d726100 	ldfvse	f6, [r2, #-0]
    2430:	6e75745f 	mrcvs	4, 3, r7, cr5, cr15, {2}
    2434:	6f635f65 	svcvs	0x00635f65
    2438:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    243c:	0039615f 	eorseq	r6, r9, pc, asr r1
    2440:	5f617369 	svcpl	0x00617369
    2444:	5f746962 	svcpl	0x00746962
    2448:	6d6d7769 	stclvs	7, cr7, [sp, #-420]!	; 0xfffffe5c
    244c:	00327478 	eorseq	r7, r2, r8, ror r4
    2450:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2454:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2458:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    245c:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2460:	32376178 	eorscc	r6, r7, #120, 2
    2464:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2468:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    246c:	73690033 	cmnvc	r9, #51	; 0x33
    2470:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2474:	68745f74 	ldmdavs	r4!, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    2478:	32626d75 	rsbcc	r6, r2, #7488	; 0x1d40
    247c:	53414200 	movtpl	r4, #4608	; 0x1200
    2480:	52415f45 	subpl	r5, r1, #276	; 0x114
    2484:	375f4843 	ldrbcc	r4, [pc, -r3, asr #16]
    2488:	73690041 	cmnvc	r9, #65	; 0x41
    248c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2490:	6f645f74 	svcvs	0x00645f74
    2494:	6f727074 	svcvs	0x00727074
    2498:	72610064 	rsbvc	r0, r1, #100	; 0x64
    249c:	70665f6d 	rsbvc	r5, r6, sp, ror #30
    24a0:	745f3631 	ldrbvc	r3, [pc], #-1585	; 24a8 <CPSR_IRQ_INHIBIT+0x2428>
    24a4:	5f657079 	svcpl	0x00657079
    24a8:	65646f6e 	strbvs	r6, [r4, #-3950]!	; 0xfffff092
    24ac:	4d524100 	ldfmie	f4, [r2, #-0]
    24b0:	00494d5f 	subeq	r4, r9, pc, asr sp
    24b4:	5f6d7261 	svcpl	0x006d7261
    24b8:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    24bc:	61006b36 	tstvs	r0, r6, lsr fp
    24c0:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    24c4:	36686372 			; <UNDEFINED> instruction: 0x36686372
    24c8:	4142006d 	cmpmi	r2, sp, rrx
    24cc:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    24d0:	5f484352 	svcpl	0x00484352
    24d4:	5f005237 	svcpl	0x00005237
    24d8:	706f705f 	rsbvc	r7, pc, pc, asr r0	; <UNPREDICTABLE>
    24dc:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
    24e0:	61745f74 	cmnvs	r4, r4, ror pc
    24e4:	73690062 	cmnvc	r9, #98	; 0x62
    24e8:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    24ec:	6d635f74 	stclvs	15, cr5, [r3, #-464]!	; 0xfffffe30
    24f0:	54006573 	strpl	r6, [r0], #-1395	; 0xfffffa8d
    24f4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    24f8:	50435f54 	subpl	r5, r3, r4, asr pc
    24fc:	6f635f55 	svcvs	0x00635f55
    2500:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2504:	00333761 	eorseq	r3, r3, r1, ror #14
    2508:	47524154 			; <UNDEFINED> instruction: 0x47524154
    250c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2510:	675f5550 			; <UNDEFINED> instruction: 0x675f5550
    2514:	72656e65 	rsbvc	r6, r5, #1616	; 0x650
    2518:	37766369 	ldrbcc	r6, [r6, -r9, ror #6]!
    251c:	41540061 	cmpmi	r4, r1, rrx
    2520:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2524:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2528:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    252c:	61786574 	cmnvs	r8, r4, ror r5
    2530:	61003637 	tstvs	r0, r7, lsr r6
    2534:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2538:	5f686372 	svcpl	0x00686372
    253c:	765f6f6e 	ldrbvc	r6, [pc], -lr, ror #30
    2540:	74616c6f 	strbtvc	r6, [r1], #-3183	; 0xfffff391
    2544:	5f656c69 	svcpl	0x00656c69
    2548:	42006563 	andmi	r6, r0, #415236096	; 0x18c00000
    254c:	5f455341 	svcpl	0x00455341
    2550:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    2554:	0041385f 	subeq	r3, r1, pc, asr r8
    2558:	5f617369 	svcpl	0x00617369
    255c:	5f746962 	svcpl	0x00746962
    2560:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    2564:	42007435 	andmi	r7, r0, #889192448	; 0x35000000
    2568:	5f455341 	svcpl	0x00455341
    256c:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    2570:	0052385f 	subseq	r3, r2, pc, asr r8
    2574:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2578:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    257c:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2580:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2584:	33376178 	teqcc	r7, #120, 2
    2588:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    258c:	33617865 	cmncc	r1, #6619136	; 0x650000
    2590:	52410035 	subpl	r0, r1, #53	; 0x35
    2594:	564e5f4d 	strbpl	r5, [lr], -sp, asr #30
    2598:	6d726100 	ldfvse	f6, [r2, #-0]
    259c:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    25a0:	61003468 	tstvs	r0, r8, ror #8
    25a4:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    25a8:	36686372 			; <UNDEFINED> instruction: 0x36686372
    25ac:	6d726100 	ldfvse	f6, [r2, #-0]
    25b0:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    25b4:	61003768 	tstvs	r0, r8, ror #14
    25b8:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    25bc:	38686372 	stmdacc	r8!, {r1, r4, r5, r6, r8, r9, sp, lr}^
    25c0:	6e6f6c00 	cdpvs	12, 6, cr6, cr15, cr0, {0}
    25c4:	6f642067 	svcvs	0x00642067
    25c8:	656c6275 	strbvs	r6, [ip, #-629]!	; 0xfffffd8b
    25cc:	6d726100 	ldfvse	f6, [r2, #-0]
    25d0:	6e75745f 	mrcvs	4, 3, r7, cr5, cr15, {2}
    25d4:	73785f65 	cmnvc	r8, #404	; 0x194
    25d8:	656c6163 	strbvs	r6, [ip, #-355]!	; 0xfffffe9d
    25dc:	6b616d00 	blvs	185d9e4 <_bss_end+0x1851ce8>
    25e0:	5f676e69 	svcpl	0x00676e69
    25e4:	736e6f63 	cmnvc	lr, #396	; 0x18c
    25e8:	61745f74 	cmnvs	r4, r4, ror pc
    25ec:	00656c62 	rsbeq	r6, r5, r2, ror #24
    25f0:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    25f4:	61635f62 	cmnvs	r3, r2, ror #30
    25f8:	765f6c6c 	ldrbvc	r6, [pc], -ip, ror #24
    25fc:	6c5f6169 	ldfvse	f6, [pc], {105}	; 0x69
    2600:	6c656261 	sfmvs	f6, 2, [r5], #-388	; 0xfffffe7c
    2604:	61736900 	cmnvs	r3, r0, lsl #18
    2608:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    260c:	7670665f 			; <UNDEFINED> instruction: 0x7670665f
    2610:	73690035 	cmnvc	r9, #53	; 0x35
    2614:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2618:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    261c:	6b36766d 	blvs	d9ffd8 <_bss_end+0xd942dc>
    2620:	52415400 	subpl	r5, r1, #0, 8
    2624:	5f544547 	svcpl	0x00544547
    2628:	5f555043 	svcpl	0x00555043
    262c:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2630:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    2634:	52415400 	subpl	r5, r1, #0, 8
    2638:	5f544547 	svcpl	0x00544547
    263c:	5f555043 	svcpl	0x00555043
    2640:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2644:	38617865 	stmdacc	r1!, {r0, r2, r5, r6, fp, ip, sp, lr}^
    2648:	52415400 	subpl	r5, r1, #0, 8
    264c:	5f544547 	svcpl	0x00544547
    2650:	5f555043 	svcpl	0x00555043
    2654:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2658:	39617865 	stmdbcc	r1!, {r0, r2, r5, r6, fp, ip, sp, lr}^
    265c:	4d524100 	ldfmie	f4, [r2, #-0]
    2660:	5343505f 	movtpl	r5, #12383	; 0x305f
    2664:	4350415f 	cmpmi	r0, #-1073741801	; 0xc0000017
    2668:	52410053 	subpl	r0, r1, #83	; 0x53
    266c:	43505f4d 	cmpmi	r0, #308	; 0x134
    2670:	54415f53 	strbpl	r5, [r1], #-3923	; 0xfffff0ad
    2674:	00534350 	subseq	r4, r3, r0, asr r3
    2678:	706d6f63 	rsbvc	r6, sp, r3, ror #30
    267c:	2078656c 	rsbscs	r6, r8, ip, ror #10
    2680:	62756f64 	rsbsvs	r6, r5, #100, 30	; 0x190
    2684:	5400656c 	strpl	r6, [r0], #-1388	; 0xfffffa94
    2688:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    268c:	50435f54 	subpl	r5, r3, r4, asr pc
    2690:	6f635f55 	svcvs	0x00635f55
    2694:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2698:	63333761 	teqvs	r3, #25427968	; 0x1840000
    269c:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    26a0:	33356178 	teqcc	r5, #120, 2
    26a4:	52415400 	subpl	r5, r1, #0, 8
    26a8:	5f544547 	svcpl	0x00544547
    26ac:	5f555043 	svcpl	0x00555043
    26b0:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    26b4:	306d7865 	rsbcc	r7, sp, r5, ror #16
    26b8:	73756c70 	cmnvc	r5, #112, 24	; 0x7000
    26bc:	6d726100 	ldfvse	f6, [r2, #-0]
    26c0:	0063635f 	rsbeq	r6, r3, pc, asr r3
    26c4:	5f617369 	svcpl	0x00617369
    26c8:	5f746962 	svcpl	0x00746962
    26cc:	61637378 	smcvs	14136	; 0x3738
    26d0:	5f00656c 	svcpl	0x0000656c
    26d4:	746e6f64 	strbtvc	r6, [lr], #-3940	; 0xfffff09c
    26d8:	6573755f 	ldrbvs	r7, [r3, #-1375]!	; 0xfffffaa1
    26dc:	6572745f 	ldrbvs	r7, [r2, #-1119]!	; 0xfffffba1
    26e0:	65685f65 	strbvs	r5, [r8, #-3941]!	; 0xfffff09b
    26e4:	005f6572 	subseq	r6, pc, r2, ror r5	; <UNPREDICTABLE>
    26e8:	47524154 			; <UNDEFINED> instruction: 0x47524154
    26ec:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    26f0:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    26f4:	30316d72 	eorscc	r6, r1, r2, ror sp
    26f8:	696d6474 	stmdbvs	sp!, {r2, r4, r5, r6, sl, sp, lr}^
    26fc:	52415400 	subpl	r5, r1, #0, 8
    2700:	5f544547 	svcpl	0x00544547
    2704:	5f555043 	svcpl	0x00555043
    2708:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    270c:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    2710:	73616200 	cmnvc	r1, #0, 4
    2714:	72615f65 	rsbvc	r5, r1, #404	; 0x194
    2718:	74696863 	strbtvc	r6, [r9], #-2147	; 0xfffff79d
    271c:	75746365 	ldrbvc	r6, [r4, #-869]!	; 0xfffffc9b
    2720:	61006572 	tstvs	r0, r2, ror r5
    2724:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2728:	5f686372 	svcpl	0x00686372
    272c:	00637263 	rsbeq	r7, r3, r3, ror #4
    2730:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2734:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2738:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    273c:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2740:	73316d78 	teqvc	r1, #120, 26	; 0x1e00
    2744:	6c6c616d 	stfvse	f6, [ip], #-436	; 0xfffffe4c
    2748:	746c756d 	strbtvc	r7, [ip], #-1389	; 0xfffffa93
    274c:	796c7069 	stmdbvc	ip!, {r0, r3, r5, r6, ip, sp, lr}^
    2750:	6d726100 	ldfvse	f6, [r2, #-0]
    2754:	7275635f 	rsbsvc	r6, r5, #2080374785	; 0x7c000001
    2758:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
    275c:	0063635f 	rsbeq	r6, r3, pc, asr r3
    2760:	5f617369 	svcpl	0x00617369
    2764:	5f746962 	svcpl	0x00746962
    2768:	33637263 	cmncc	r3, #805306374	; 0x30000006
    276c:	52410032 	subpl	r0, r1, #50	; 0x32
    2770:	4c505f4d 	mrrcmi	15, 4, r5, r0, cr13
    2774:	61736900 	cmnvs	r3, r0, lsl #18
    2778:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    277c:	7066765f 	rsbvc	r7, r6, pc, asr r6
    2780:	69003376 	stmdbvs	r0, {r1, r2, r4, r5, r6, r8, r9, ip, sp}
    2784:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2788:	765f7469 	ldrbvc	r7, [pc], -r9, ror #8
    278c:	34767066 	ldrbtcc	r7, [r6], #-102	; 0xffffff9a
    2790:	53414200 	movtpl	r4, #4608	; 0x1200
    2794:	52415f45 	subpl	r5, r1, #276	; 0x114
    2798:	365f4843 	ldrbcc	r4, [pc], -r3, asr #16
    279c:	42003254 	andmi	r3, r0, #84, 4	; 0x40000005
    27a0:	5f455341 	svcpl	0x00455341
    27a4:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    27a8:	5f4d385f 	svcpl	0x004d385f
    27ac:	4e49414d 	dvfmiem	f4, f1, #5.0
    27b0:	52415400 	subpl	r5, r1, #0, 8
    27b4:	5f544547 	svcpl	0x00544547
    27b8:	5f555043 	svcpl	0x00555043
    27bc:	396d7261 	stmdbcc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    27c0:	696d6474 	stmdbvs	sp!, {r2, r4, r5, r6, sl, sp, lr}^
    27c4:	4d524100 	ldfmie	f4, [r2, #-0]
    27c8:	004c415f 	subeq	r4, ip, pc, asr r1
    27cc:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    27d0:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    27d4:	4d375f48 	ldcmi	15, cr5, [r7, #-288]!	; 0xfffffee0
    27d8:	6d726100 	ldfvse	f6, [r2, #-0]
    27dc:	7261745f 	rsbvc	r7, r1, #1593835520	; 0x5f000000
    27e0:	5f746567 	svcpl	0x00746567
    27e4:	6562616c 	strbvs	r6, [r2, #-364]!	; 0xfffffe94
    27e8:	7261006c 	rsbvc	r0, r1, #108	; 0x6c
    27ec:	61745f6d 	cmnvs	r4, sp, ror #30
    27f0:	74656772 	strbtvc	r6, [r5], #-1906	; 0xfffff88e
    27f4:	736e695f 	cmnvc	lr, #1556480	; 0x17c000
    27f8:	4154006e 	cmpmi	r4, lr, rrx
    27fc:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2800:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2804:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2808:	72786574 	rsbsvc	r6, r8, #116, 10	; 0x1d000000
    280c:	41540034 	cmpmi	r4, r4, lsr r0
    2810:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2814:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2818:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    281c:	72786574 	rsbsvc	r6, r8, #116, 10	; 0x1d000000
    2820:	41540035 	cmpmi	r4, r5, lsr r0
    2824:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2828:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    282c:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2830:	72786574 	rsbsvc	r6, r8, #116, 10	; 0x1d000000
    2834:	41540037 	cmpmi	r4, r7, lsr r0
    2838:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    283c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2840:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2844:	72786574 	rsbsvc	r6, r8, #116, 10	; 0x1d000000
    2848:	73690038 	cmnvc	r9, #56	; 0x38
    284c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2850:	706c5f74 	rsbvc	r5, ip, r4, ror pc
    2854:	69006561 	stmdbvs	r0, {r0, r5, r6, r8, sl, sp, lr}
    2858:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    285c:	715f7469 	cmpvc	pc, r9, ror #8
    2860:	6b726975 	blvs	1c9ce3c <_bss_end+0x1c91140>
    2864:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2868:	7a6b3676 	bvc	1ad0248 <_bss_end+0x1ac454c>
    286c:	61736900 	cmnvs	r3, r0, lsl #18
    2870:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2874:	746f6e5f 	strbtvc	r6, [pc], #-3679	; 287c <CPSR_IRQ_INHIBIT+0x27fc>
    2878:	7369006d 	cmnvc	r9, #109	; 0x6d
    287c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2880:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    2884:	0034766d 	eorseq	r7, r4, sp, ror #12
    2888:	5f617369 	svcpl	0x00617369
    288c:	5f746962 	svcpl	0x00746962
    2890:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    2894:	73690036 	cmnvc	r9, #54	; 0x36
    2898:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    289c:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    28a0:	0037766d 	eorseq	r7, r7, sp, ror #12
    28a4:	5f617369 	svcpl	0x00617369
    28a8:	5f746962 	svcpl	0x00746962
    28ac:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    28b0:	645f0038 	ldrbvs	r0, [pc], #-56	; 28b8 <CPSR_IRQ_INHIBIT+0x2838>
    28b4:	5f746e6f 	svcpl	0x00746e6f
    28b8:	5f657375 	svcpl	0x00657375
    28bc:	5f787472 	svcpl	0x00787472
    28c0:	65726568 	ldrbvs	r6, [r2, #-1384]!	; 0xfffffa98
    28c4:	5155005f 	cmppl	r5, pc, asr r0
    28c8:	70797449 	rsbsvc	r7, r9, r9, asr #8
    28cc:	73690065 	cmnvc	r9, #101	; 0x65
    28d0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    28d4:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    28d8:	7435766d 	ldrtvc	r7, [r5], #-1645	; 0xfffff993
    28dc:	72610065 	rsbvc	r0, r1, #101	; 0x65
    28e0:	75745f6d 	ldrbvc	r5, [r4, #-3949]!	; 0xfffff093
    28e4:	6100656e 	tstvs	r0, lr, ror #10
    28e8:	635f6d72 	cmpvs	pc, #7296	; 0x1c80
    28ec:	695f7070 	ldmdbvs	pc, {r4, r5, r6, ip, sp, lr}^	; <UNPREDICTABLE>
    28f0:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
    28f4:	6b726f77 	blvs	1c9e6d8 <_bss_end+0x1c929dc>
    28f8:	6e756600 	cdpvs	6, 7, cr6, cr5, cr0, {0}
    28fc:	74705f63 	ldrbtvc	r5, [r0], #-3939	; 0xfffff09d
    2900:	41540072 	cmpmi	r4, r2, ror r0
    2904:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2908:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    290c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2910:	74303239 	ldrtvc	r3, [r0], #-569	; 0xfffffdc7
    2914:	61746800 	cmnvs	r4, r0, lsl #16
    2918:	71655f62 	cmnvc	r5, r2, ror #30
    291c:	52415400 	subpl	r5, r1, #0, 8
    2920:	5f544547 	svcpl	0x00544547
    2924:	5f555043 	svcpl	0x00555043
    2928:	32356166 	eorscc	r6, r5, #-2147483623	; 0x80000019
    292c:	72610036 	rsbvc	r0, r1, #54	; 0x36
    2930:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    2934:	745f6863 	ldrbvc	r6, [pc], #-2147	; 293c <CPSR_IRQ_INHIBIT+0x28bc>
    2938:	626d7568 	rsbvs	r7, sp, #104, 10	; 0x1a000000
    293c:	6477685f 	ldrbtvs	r6, [r7], #-2143	; 0xfffff7a1
    2940:	68007669 	stmdavs	r0, {r0, r3, r5, r6, r9, sl, ip, sp, lr}
    2944:	5f626174 	svcpl	0x00626174
    2948:	705f7165 	subsvc	r7, pc, r5, ror #2
    294c:	746e696f 	strbtvc	r6, [lr], #-2415	; 0xfffff691
    2950:	61007265 	tstvs	r0, r5, ror #4
    2954:	705f6d72 	subsvc	r6, pc, r2, ror sp	; <UNPREDICTABLE>
    2958:	725f6369 	subsvc	r6, pc, #-1543503871	; 0xa4000001
    295c:	73696765 	cmnvc	r9, #26476544	; 0x1940000
    2960:	00726574 	rsbseq	r6, r2, r4, ror r5
    2964:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2968:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    296c:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2970:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2974:	73306d78 	teqvc	r0, #120, 26	; 0x1e00
    2978:	6c6c616d 	stfvse	f6, [ip], #-436	; 0xfffffe4c
    297c:	746c756d 	strbtvc	r7, [ip], #-1389	; 0xfffffa93
    2980:	796c7069 	stmdbvc	ip!, {r0, r3, r5, r6, ip, sp, lr}^
    2984:	52415400 	subpl	r5, r1, #0, 8
    2988:	5f544547 	svcpl	0x00544547
    298c:	5f555043 	svcpl	0x00555043
    2990:	6f63706d 	svcvs	0x0063706d
    2994:	6f6e6572 	svcvs	0x006e6572
    2998:	00706676 	rsbseq	r6, r0, r6, ror r6
    299c:	5f617369 	svcpl	0x00617369
    29a0:	5f746962 	svcpl	0x00746962
    29a4:	72697571 	rsbvc	r7, r9, #473956352	; 0x1c400000
    29a8:	6d635f6b 	stclvs	15, cr5, [r3, #-428]!	; 0xfffffe54
    29ac:	646c5f33 	strbtvs	r5, [ip], #-3891	; 0xfffff0cd
    29b0:	41006472 	tstmi	r0, r2, ror r4
    29b4:	435f4d52 	cmpmi	pc, #5248	; 0x1480
    29b8:	72610043 	rsbvc	r0, r1, #67	; 0x43
    29bc:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    29c0:	5f386863 	svcpl	0x00386863
    29c4:	72610032 	rsbvc	r0, r1, #50	; 0x32
    29c8:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    29cc:	5f386863 	svcpl	0x00386863
    29d0:	72610033 	rsbvc	r0, r1, #51	; 0x33
    29d4:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    29d8:	5f386863 	svcpl	0x00386863
    29dc:	41540034 	cmpmi	r4, r4, lsr r0
    29e0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    29e4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    29e8:	706d665f 	rsbvc	r6, sp, pc, asr r6
    29ec:	00363236 	eorseq	r3, r6, r6, lsr r2
    29f0:	5f4d5241 	svcpl	0x004d5241
    29f4:	61005343 	tstvs	r0, r3, asr #6
    29f8:	665f6d72 			; <UNDEFINED> instruction: 0x665f6d72
    29fc:	5f363170 	svcpl	0x00363170
    2a00:	74736e69 	ldrbtvc	r6, [r3], #-3689	; 0xfffff197
    2a04:	6d726100 	ldfvse	f6, [r2, #-0]
    2a08:	7361625f 	cmnvc	r1, #-268435451	; 0xf0000005
    2a0c:	72615f65 	rsbvc	r5, r1, #404	; 0x194
    2a10:	54006863 	strpl	r6, [r0], #-2147	; 0xfffff79d
    2a14:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2a18:	50435f54 	subpl	r5, r3, r4, asr pc
    2a1c:	6f635f55 	svcvs	0x00635f55
    2a20:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2a24:	63353161 	teqvs	r5, #1073741848	; 0x40000018
    2a28:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2a2c:	00376178 	eorseq	r6, r7, r8, ror r1
    2a30:	5f6d7261 	svcpl	0x006d7261
    2a34:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    2a38:	006d6537 	rsbeq	r6, sp, r7, lsr r5
    2a3c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2a40:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2a44:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2a48:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2a4c:	32376178 	eorscc	r6, r7, #120, 2
    2a50:	6d726100 	ldfvse	f6, [r2, #-0]
    2a54:	7363705f 	cmnvc	r3, #95	; 0x5f
    2a58:	6665645f 			; <UNDEFINED> instruction: 0x6665645f
    2a5c:	746c7561 	strbtvc	r7, [ip], #-1377	; 0xfffffa9f
    2a60:	4d524100 	ldfmie	f4, [r2, #-0]
    2a64:	5343505f 	movtpl	r5, #12383	; 0x305f
    2a68:	5041415f 	subpl	r4, r1, pc, asr r1
    2a6c:	4c5f5343 	mrrcmi	3, 4, r5, pc, cr3	; <UNPREDICTABLE>
    2a70:	4c41434f 	mcrrmi	3, 4, r4, r1, cr15
    2a74:	52415400 	subpl	r5, r1, #0, 8
    2a78:	5f544547 	svcpl	0x00544547
    2a7c:	5f555043 	svcpl	0x00555043
    2a80:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2a84:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    2a88:	41540035 	cmpmi	r4, r5, lsr r0
    2a8c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2a90:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2a94:	7274735f 	rsbsvc	r7, r4, #2080374785	; 0x7c000001
    2a98:	61676e6f 	cmnvs	r7, pc, ror #28
    2a9c:	61006d72 	tstvs	r0, r2, ror sp
    2aa0:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2aa4:	5f686372 	svcpl	0x00686372
    2aa8:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    2aac:	61003162 	tstvs	r0, r2, ror #2
    2ab0:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2ab4:	5f686372 	svcpl	0x00686372
    2ab8:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    2abc:	54003262 	strpl	r3, [r0], #-610	; 0xfffffd9e
    2ac0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2ac4:	50435f54 	subpl	r5, r3, r4, asr pc
    2ac8:	77695f55 			; <UNDEFINED> instruction: 0x77695f55
    2acc:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
    2ad0:	6d726100 	ldfvse	f6, [r2, #-0]
    2ad4:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    2ad8:	00743568 	rsbseq	r3, r4, r8, ror #10
    2adc:	5f617369 	svcpl	0x00617369
    2ae0:	5f746962 	svcpl	0x00746962
    2ae4:	6100706d 	tstvs	r0, sp, rrx
    2ae8:	6c5f6d72 	mrrcvs	13, 7, r6, pc, cr2	; <UNPREDICTABLE>
    2aec:	63735f64 	cmnvs	r3, #100, 30	; 0x190
    2af0:	00646568 	rsbeq	r6, r4, r8, ror #10
    2af4:	5f6d7261 	svcpl	0x006d7261
    2af8:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    2afc:	00315f38 	eorseq	r5, r1, r8, lsr pc

Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347 	bcc	10d0d24 <_bss_end+0x10c5028>
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
  10:	4b5a3605 	blmi	168d82c <_bss_end+0x1681b30>
  14:	08070600 	stmdaeq	r7, {r9, sl}
  18:	0a010901 	beq	42424 <_bss_end+0x36728>
  1c:	14041202 	strne	r1, [r4], #-514	; 0xfffffdfe
  20:	17011501 	strne	r1, [r1, -r1, lsl #10]
  24:	1a011803 	bne	46038 <_bss_end+0x3a33c>
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
  20:	8b040e42 	blhi	103930 <_bss_end+0xf7c34>
  24:	0b0d4201 	bleq	350830 <_bss_end+0x344b34>
  28:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
  2c:	00000ecb 	andeq	r0, r0, fp, asr #29
  30:	0000001c 	andeq	r0, r0, ip, lsl r0
  34:	00000000 	andeq	r0, r0, r0
  38:	000080e4 	andeq	r8, r0, r4, ror #1
  3c:	0000002c 	andeq	r0, r0, ip, lsr #32
  40:	8b040e42 	blhi	103950 <_bss_end+0xf7c54>
  44:	0b0d4201 	bleq	350850 <_bss_end+0x344b54>
  48:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
  4c:	00000ecb 	andeq	r0, r0, fp, asr #29
  50:	0000001c 	andeq	r0, r0, ip, lsl r0
  54:	00000000 	andeq	r0, r0, r0
  58:	00008110 	andeq	r8, r0, r0, lsl r1
  5c:	00000020 	andeq	r0, r0, r0, lsr #32
  60:	8b040e42 	blhi	103970 <_bss_end+0xf7c74>
  64:	0b0d4201 	bleq	350870 <_bss_end+0x344b74>
  68:	420d0d48 	andmi	r0, sp, #72, 26	; 0x1200
  6c:	00000ecb 	andeq	r0, r0, fp, asr #29
  70:	0000001c 	andeq	r0, r0, ip, lsl r0
  74:	00000000 	andeq	r0, r0, r0
  78:	00008130 	andeq	r8, r0, r0, lsr r1
  7c:	00000018 	andeq	r0, r0, r8, lsl r0
  80:	8b040e42 	blhi	103990 <_bss_end+0xf7c94>
  84:	0b0d4201 	bleq	350890 <_bss_end+0x344b94>
  88:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  8c:	00000ecb 	andeq	r0, r0, fp, asr #29
  90:	0000001c 	andeq	r0, r0, ip, lsl r0
  94:	00000000 	andeq	r0, r0, r0
  98:	00008148 	andeq	r8, r0, r8, asr #2
  9c:	00000018 	andeq	r0, r0, r8, lsl r0
  a0:	8b040e42 	blhi	1039b0 <_bss_end+0xf7cb4>
  a4:	0b0d4201 	bleq	3508b0 <_bss_end+0x344bb4>
  a8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  ac:	00000ecb 	andeq	r0, r0, fp, asr #29
  b0:	0000001c 	andeq	r0, r0, ip, lsl r0
  b4:	00000000 	andeq	r0, r0, r0
  b8:	00008160 	andeq	r8, r0, r0, ror #2
  bc:	00000018 	andeq	r0, r0, r8, lsl r0
  c0:	8b040e42 	blhi	1039d0 <_bss_end+0xf7cd4>
  c4:	0b0d4201 	bleq	3508d0 <_bss_end+0x344bd4>
  c8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  cc:	00000ecb 	andeq	r0, r0, fp, asr #29
  d0:	00000014 	andeq	r0, r0, r4, lsl r0
  d4:	00000000 	andeq	r0, r0, r0
  d8:	00008178 	andeq	r8, r0, r8, ror r1
  dc:	0000000c 	andeq	r0, r0, ip
  e0:	8b040e42 	blhi	1039f0 <_bss_end+0xf7cf4>
  e4:	0b0d4201 	bleq	3508f0 <_bss_end+0x344bf4>
  e8:	0000000c 	andeq	r0, r0, ip
  ec:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  f0:	7c020001 	stcvc	0, cr0, [r2], {1}
  f4:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  f8:	0000001c 	andeq	r0, r0, ip, lsl r0
  fc:	000000e8 	andeq	r0, r0, r8, ror #1
 100:	00008184 	andeq	r8, r0, r4, lsl #3
 104:	00000034 	andeq	r0, r0, r4, lsr r0
 108:	8b040e42 	blhi	103a18 <_bss_end+0xf7d1c>
 10c:	0b0d4201 	bleq	350918 <_bss_end+0x344c1c>
 110:	420d0d52 	andmi	r0, sp, #5248	; 0x1480
 114:	00000ecb 	andeq	r0, r0, fp, asr #29
 118:	0000001c 	andeq	r0, r0, ip, lsl r0
 11c:	000000e8 	andeq	r0, r0, r8, ror #1
 120:	000081b8 			; <UNDEFINED> instruction: 0x000081b8
 124:	00000098 	muleq	r0, r8, r0
 128:	8b040e42 	blhi	103a38 <_bss_end+0xf7d3c>
 12c:	0b0d4201 	bleq	350938 <_bss_end+0x344c3c>
 130:	0d0d4202 	sfmeq	f4, 4, [sp, #-8]
 134:	000ecb42 	andeq	ip, lr, r2, asr #22
 138:	0000001c 	andeq	r0, r0, ip, lsl r0
 13c:	000000e8 	andeq	r0, r0, r8, ror #1
 140:	00008250 	andeq	r8, r0, r0, asr r2
 144:	00000074 	andeq	r0, r0, r4, ror r0
 148:	8b040e42 	blhi	103a58 <_bss_end+0xf7d5c>
 14c:	0b0d4201 	bleq	350958 <_bss_end+0x344c5c>
 150:	420d0d72 	andmi	r0, sp, #7296	; 0x1c80
 154:	00000ecb 	andeq	r0, r0, fp, asr #29
 158:	0000001c 	andeq	r0, r0, ip, lsl r0
 15c:	000000e8 	andeq	r0, r0, r8, ror #1
 160:	000082c4 	andeq	r8, r0, r4, asr #5
 164:	00000074 	andeq	r0, r0, r4, ror r0
 168:	8b040e42 	blhi	103a78 <_bss_end+0xf7d7c>
 16c:	0b0d4201 	bleq	350978 <_bss_end+0x344c7c>
 170:	420d0d72 	andmi	r0, sp, #7296	; 0x1c80
 174:	00000ecb 	andeq	r0, r0, fp, asr #29
 178:	0000001c 	andeq	r0, r0, ip, lsl r0
 17c:	000000e8 	andeq	r0, r0, r8, ror #1
 180:	00008338 	andeq	r8, r0, r8, lsr r3
 184:	00000074 	andeq	r0, r0, r4, ror r0
 188:	8b040e42 	blhi	103a98 <_bss_end+0xf7d9c>
 18c:	0b0d4201 	bleq	350998 <_bss_end+0x344c9c>
 190:	420d0d72 	andmi	r0, sp, #7296	; 0x1c80
 194:	00000ecb 	andeq	r0, r0, fp, asr #29
 198:	0000001c 	andeq	r0, r0, ip, lsl r0
 19c:	000000e8 	andeq	r0, r0, r8, ror #1
 1a0:	000083ac 	andeq	r8, r0, ip, lsr #7
 1a4:	000000c8 	andeq	r0, r0, r8, asr #1
 1a8:	8b080e42 	blhi	203ab8 <_bss_end+0x1f7dbc>
 1ac:	42018e02 	andmi	r8, r1, #2, 28
 1b0:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 1b4:	080d0c5e 	stmdaeq	sp, {r1, r2, r3, r4, r6, sl, fp}
 1b8:	0000001c 	andeq	r0, r0, ip, lsl r0
 1bc:	000000e8 	andeq	r0, r0, r8, ror #1
 1c0:	00008474 	andeq	r8, r0, r4, ror r4
 1c4:	00000074 	andeq	r0, r0, r4, ror r0
 1c8:	8b080e42 	blhi	203ad8 <_bss_end+0x1f7ddc>
 1cc:	42018e02 	andmi	r8, r1, #2, 28
 1d0:	74040b0c 	strvc	r0, [r4], #-2828	; 0xfffff4f4
 1d4:	00080d0c 	andeq	r0, r8, ip, lsl #26
 1d8:	0000001c 	andeq	r0, r0, ip, lsl r0
 1dc:	000000e8 	andeq	r0, r0, r8, ror #1
 1e0:	000084e8 	andeq	r8, r0, r8, ror #9
 1e4:	000000d8 	ldrdeq	r0, [r0], -r8
 1e8:	8b080e42 	blhi	203af8 <_bss_end+0x1f7dfc>
 1ec:	42018e02 	andmi	r8, r1, #2, 28
 1f0:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 1f4:	080d0c66 	stmdaeq	sp, {r1, r2, r5, r6, sl, fp}
 1f8:	0000001c 	andeq	r0, r0, ip, lsl r0
 1fc:	000000e8 	andeq	r0, r0, r8, ror #1
 200:	000085c0 	andeq	r8, r0, r0, asr #11
 204:	00000084 	andeq	r0, r0, r4, lsl #1
 208:	8b080e42 	blhi	203b18 <_bss_end+0x1f7e1c>
 20c:	42018e02 	andmi	r8, r1, #2, 28
 210:	7c040b0c 			; <UNDEFINED> instruction: 0x7c040b0c
 214:	00080d0c 	andeq	r0, r8, ip, lsl #26
 218:	0000001c 	andeq	r0, r0, ip, lsl r0
 21c:	000000e8 	andeq	r0, r0, r8, ror #1
 220:	00008644 	andeq	r8, r0, r4, asr #12
 224:	00000054 	andeq	r0, r0, r4, asr r0
 228:	8b080e42 	blhi	203b38 <_bss_end+0x1f7e3c>
 22c:	42018e02 	andmi	r8, r1, #2, 28
 230:	5e040b0c 	vmlapl.f64	d0, d4, d12
 234:	00080d0c 	andeq	r0, r8, ip, lsl #26
 238:	00000018 	andeq	r0, r0, r8, lsl r0
 23c:	000000e8 	andeq	r0, r0, r8, ror #1
 240:	00008698 	muleq	r0, r8, r6
 244:	0000001c 	andeq	r0, r0, ip, lsl r0
 248:	8b080e42 	blhi	203b58 <_bss_end+0x1f7e5c>
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
 274:	8b040e42 	blhi	103b84 <_bss_end+0xf7e88>
 278:	0b0d4201 	bleq	350a84 <_bss_end+0x344d88>
 27c:	420d0d74 	andmi	r0, sp, #116, 26	; 0x1d00
 280:	00000ecb 	andeq	r0, r0, fp, asr #29
 284:	0000001c 	andeq	r0, r0, ip, lsl r0
 288:	00000254 	andeq	r0, r0, r4, asr r2
 28c:	00008cec 	andeq	r8, r0, ip, ror #25
 290:	00000038 	andeq	r0, r0, r8, lsr r0
 294:	8b040e42 	blhi	103ba4 <_bss_end+0xf7ea8>
 298:	0b0d4201 	bleq	350aa4 <_bss_end+0x344da8>
 29c:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
 2a0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2a4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2a8:	00000254 	andeq	r0, r0, r4, asr r2
 2ac:	0000872c 	andeq	r8, r0, ip, lsr #14
 2b0:	000000a8 	andeq	r0, r0, r8, lsr #1
 2b4:	8b080e42 	blhi	203bc4 <_bss_end+0x1f7ec8>
 2b8:	42018e02 	andmi	r8, r1, #2, 28
 2bc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 2c0:	080d0c4e 	stmdaeq	sp, {r1, r2, r3, r6, sl, fp}
 2c4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2c8:	00000254 	andeq	r0, r0, r4, asr r2
 2cc:	00008d24 	andeq	r8, r0, r4, lsr #26
 2d0:	00000088 	andeq	r0, r0, r8, lsl #1
 2d4:	8b080e42 	blhi	203be4 <_bss_end+0x1f7ee8>
 2d8:	42018e02 	andmi	r8, r1, #2, 28
 2dc:	7e040b0c 	vmlavc.f64	d0, d4, d12
 2e0:	00080d0c 	andeq	r0, r8, ip, lsl #26
 2e4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2e8:	00000254 	andeq	r0, r0, r4, asr r2
 2ec:	000087d4 	ldrdeq	r8, [r0], -r4
 2f0:	00000130 	andeq	r0, r0, r0, lsr r1
 2f4:	8b040e42 	blhi	103c04 <_bss_end+0xf7f08>
 2f8:	0b0d4201 	bleq	350b04 <_bss_end+0x344e08>
 2fc:	0d0d9002 	stceq	0, cr9, [sp, #-8]
 300:	000ecb42 	andeq	ip, lr, r2, asr #22
 304:	0000001c 	andeq	r0, r0, ip, lsl r0
 308:	00000254 	andeq	r0, r0, r4, asr r2
 30c:	00008dac 	andeq	r8, r0, ip, lsr #27
 310:	0000002c 	andeq	r0, r0, ip, lsr #32
 314:	8b040e42 	blhi	103c24 <_bss_end+0xf7f28>
 318:	0b0d4201 	bleq	350b24 <_bss_end+0x344e28>
 31c:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 320:	00000ecb 	andeq	r0, r0, fp, asr #29
 324:	0000001c 	andeq	r0, r0, ip, lsl r0
 328:	00000254 	andeq	r0, r0, r4, asr r2
 32c:	00008904 	andeq	r8, r0, r4, lsl #18
 330:	000000a8 	andeq	r0, r0, r8, lsr #1
 334:	8b080e42 	blhi	203c44 <_bss_end+0x1f7f48>
 338:	42018e02 	andmi	r8, r1, #2, 28
 33c:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 340:	080d0c4e 	stmdaeq	sp, {r1, r2, r3, r6, sl, fp}
 344:	0000001c 	andeq	r0, r0, ip, lsl r0
 348:	00000254 	andeq	r0, r0, r4, asr r2
 34c:	000089ac 	andeq	r8, r0, ip, lsr #19
 350:	00000078 	andeq	r0, r0, r8, ror r0
 354:	8b080e42 	blhi	203c64 <_bss_end+0x1f7f68>
 358:	42018e02 	andmi	r8, r1, #2, 28
 35c:	76040b0c 	strvc	r0, [r4], -ip, lsl #22
 360:	00080d0c 	andeq	r0, r8, ip, lsl #26
 364:	0000001c 	andeq	r0, r0, ip, lsl r0
 368:	00000254 	andeq	r0, r0, r4, asr r2
 36c:	00008a24 	andeq	r8, r0, r4, lsr #20
 370:	00000034 	andeq	r0, r0, r4, lsr r0
 374:	8b040e42 	blhi	103c84 <_bss_end+0xf7f88>
 378:	0b0d4201 	bleq	350b84 <_bss_end+0x344e88>
 37c:	420d0d52 	andmi	r0, sp, #5248	; 0x1480
 380:	00000ecb 	andeq	r0, r0, fp, asr #29
 384:	0000001c 	andeq	r0, r0, ip, lsl r0
 388:	00000254 	andeq	r0, r0, r4, asr r2
 38c:	00008a58 	andeq	r8, r0, r8, asr sl
 390:	00000054 	andeq	r0, r0, r4, asr r0
 394:	8b080e42 	blhi	203ca4 <_bss_end+0x1f7fa8>
 398:	42018e02 	andmi	r8, r1, #2, 28
 39c:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 3a0:	00080d0c 	andeq	r0, r8, ip, lsl #26
 3a4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3a8:	00000254 	andeq	r0, r0, r4, asr r2
 3ac:	00008aac 	andeq	r8, r0, ip, lsr #21
 3b0:	00000060 	andeq	r0, r0, r0, rrx
 3b4:	8b080e42 	blhi	203cc4 <_bss_end+0x1f7fc8>
 3b8:	42018e02 	andmi	r8, r1, #2, 28
 3bc:	66040b0c 	strvs	r0, [r4], -ip, lsl #22
 3c0:	00080d0c 	andeq	r0, r8, ip, lsl #26
 3c4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3c8:	00000254 	andeq	r0, r0, r4, asr r2
 3cc:	00008dd8 	ldrdeq	r8, [r0], -r8	; <UNPREDICTABLE>
 3d0:	00000090 	muleq	r0, r0, r0
 3d4:	8b040e42 	blhi	103ce4 <_bss_end+0xf7fe8>
 3d8:	0b0d4201 	bleq	350be4 <_bss_end+0x344ee8>
 3dc:	0d0d4002 	stceq	0, cr4, [sp, #-8]
 3e0:	000ecb42 	andeq	ip, lr, r2, asr #22
 3e4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3e8:	00000254 	andeq	r0, r0, r4, asr r2
 3ec:	00008e68 	andeq	r8, r0, r8, ror #28
 3f0:	0000007c 	andeq	r0, r0, ip, ror r0
 3f4:	8b040e42 	blhi	103d04 <_bss_end+0xf8008>
 3f8:	0b0d4201 	bleq	350c04 <_bss_end+0x344f08>
 3fc:	420d0d76 	andmi	r0, sp, #7552	; 0x1d80
 400:	00000ecb 	andeq	r0, r0, fp, asr #29
 404:	0000001c 	andeq	r0, r0, ip, lsl r0
 408:	00000254 	andeq	r0, r0, r4, asr r2
 40c:	00008b0c 	andeq	r8, r0, ip, lsl #22
 410:	0000016c 	andeq	r0, r0, ip, ror #2
 414:	8b080e42 	blhi	203d24 <_bss_end+0x1f8028>
 418:	42018e02 	andmi	r8, r1, #2, 28
 41c:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 420:	080d0cae 	stmdaeq	sp, {r1, r2, r3, r5, r7, sl, fp}
 424:	0000001c 	andeq	r0, r0, ip, lsl r0
 428:	00000254 	andeq	r0, r0, r4, asr r2
 42c:	00008c78 	andeq	r8, r0, r8, ror ip
 430:	00000058 	andeq	r0, r0, r8, asr r0
 434:	8b080e42 	blhi	203d44 <_bss_end+0x1f8048>
 438:	42018e02 	andmi	r8, r1, #2, 28
 43c:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 440:	00080d0c 	andeq	r0, r8, ip, lsl #26
 444:	00000018 	andeq	r0, r0, r8, lsl r0
 448:	00000254 	andeq	r0, r0, r4, asr r2
 44c:	00008cd0 	ldrdeq	r8, [r0], -r0
 450:	0000001c 	andeq	r0, r0, ip, lsl r0
 454:	8b080e42 	blhi	203d64 <_bss_end+0x1f8068>
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
 480:	8b040e42 	blhi	103d90 <_bss_end+0xf8094>
 484:	0b0d4201 	bleq	350c90 <_bss_end+0x344f94>
 488:	420d0d58 	andmi	r0, sp, #88, 26	; 0x1600
 48c:	00000ecb 	andeq	r0, r0, fp, asr #29
 490:	0000001c 	andeq	r0, r0, ip, lsl r0
 494:	00000460 	andeq	r0, r0, r0, ror #8
 498:	00008f24 	andeq	r8, r0, r4, lsr #30
 49c:	00000038 	andeq	r0, r0, r8, lsr r0
 4a0:	8b040e42 	blhi	103db0 <_bss_end+0xf80b4>
 4a4:	0b0d4201 	bleq	350cb0 <_bss_end+0x344fb4>
 4a8:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
 4ac:	00000ecb 	andeq	r0, r0, fp, asr #29
 4b0:	00000020 	andeq	r0, r0, r0, lsr #32
 4b4:	00000460 	andeq	r0, r0, r0, ror #8
 4b8:	00008f5c 	andeq	r8, r0, ip, asr pc
 4bc:	000000cc 	andeq	r0, r0, ip, asr #1
 4c0:	840c0e42 	strhi	r0, [ip], #-3650	; 0xfffff1be
 4c4:	8e028b03 	vmlahi.f64	d8, d2, d3
 4c8:	0b0c4201 	bleq	310cd4 <_bss_end+0x304fd8>
 4cc:	0c600204 	sfmeq	f0, 2, [r0], #-16
 4d0:	00000c0d 	andeq	r0, r0, sp, lsl #24
 4d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 4d8:	00000460 	andeq	r0, r0, r0, ror #8
 4dc:	00009028 	andeq	r9, r0, r8, lsr #32
 4e0:	0000004c 	andeq	r0, r0, ip, asr #32
 4e4:	8b080e42 	blhi	203df4 <_bss_end+0x1f80f8>
 4e8:	42018e02 	andmi	r8, r1, #2, 28
 4ec:	60040b0c 	andvs	r0, r4, ip, lsl #22
 4f0:	00080d0c 	andeq	r0, r8, ip, lsl #26
 4f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 4f8:	00000460 	andeq	r0, r0, r0, ror #8
 4fc:	00009074 	andeq	r9, r0, r4, ror r0
 500:	00000050 	andeq	r0, r0, r0, asr r0
 504:	8b080e42 	blhi	203e14 <_bss_end+0x1f8118>
 508:	42018e02 	andmi	r8, r1, #2, 28
 50c:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 510:	00080d0c 	andeq	r0, r8, ip, lsl #26
 514:	0000001c 	andeq	r0, r0, ip, lsl r0
 518:	00000460 	andeq	r0, r0, r0, ror #8
 51c:	000090c4 	andeq	r9, r0, r4, asr #1
 520:	00000040 	andeq	r0, r0, r0, asr #32
 524:	8b080e42 	blhi	203e34 <_bss_end+0x1f8138>
 528:	42018e02 	andmi	r8, r1, #2, 28
 52c:	5a040b0c 	bpl	103164 <_bss_end+0xf7468>
 530:	00080d0c 	andeq	r0, r8, ip, lsl #26
 534:	0000001c 	andeq	r0, r0, ip, lsl r0
 538:	00000460 	andeq	r0, r0, r0, ror #8
 53c:	00009104 	andeq	r9, r0, r4, lsl #2
 540:	00000054 	andeq	r0, r0, r4, asr r0
 544:	8b080e42 	blhi	203e54 <_bss_end+0x1f8158>
 548:	42018e02 	andmi	r8, r1, #2, 28
 54c:	5e040b0c 	vmlapl.f64	d0, d4, d12
 550:	00080d0c 	andeq	r0, r8, ip, lsl #26
 554:	00000018 	andeq	r0, r0, r8, lsl r0
 558:	00000460 	andeq	r0, r0, r0, ror #8
 55c:	00009158 	andeq	r9, r0, r8, asr r1
 560:	0000001c 	andeq	r0, r0, ip, lsl r0
 564:	8b080e42 	blhi	203e74 <_bss_end+0x1f8178>
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
 590:	8b040e42 	blhi	103ea0 <_bss_end+0xf81a4>
 594:	0b0d4201 	bleq	350da0 <_bss_end+0x3450a4>
 598:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
 59c:	00000ecb 	andeq	r0, r0, fp, asr #29
 5a0:	00000018 	andeq	r0, r0, r8, lsl r0
 5a4:	00000570 	andeq	r0, r0, r0, ror r5
 5a8:	0000918c 	andeq	r9, r0, ip, lsl #3
 5ac:	00000030 	andeq	r0, r0, r0, lsr r0
 5b0:	8b080e42 	blhi	203ec0 <_bss_end+0x1f81c4>
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
 5e4:	8b040e42 	blhi	103ef4 <_bss_end+0xf81f8>
 5e8:	0b0d4201 	bleq	350df4 <_bss_end+0x3450f8>
 5ec:	420d0d52 	andmi	r0, sp, #5248	; 0x1480
 5f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 5f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 5f8:	00000570 	andeq	r0, r0, r0, ror r5
 5fc:	00009200 	andeq	r9, r0, r0, lsl #4
 600:	00000038 	andeq	r0, r0, r8, lsr r0
 604:	8b040e42 	blhi	103f14 <_bss_end+0xf8218>
 608:	0b0d4201 	bleq	350e14 <_bss_end+0x345118>
 60c:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
 610:	00000ecb 	andeq	r0, r0, fp, asr #29
 614:	00000020 	andeq	r0, r0, r0, lsr #32
 618:	00000570 	andeq	r0, r0, r0, ror r5
 61c:	00009238 	andeq	r9, r0, r8, lsr r2
 620:	00000044 	andeq	r0, r0, r4, asr #32
 624:	840c0e42 	strhi	r0, [ip], #-3650	; 0xfffff1be
 628:	8e028b03 	vmlahi.f64	d8, d2, d3
 62c:	0b0c4201 	bleq	310e38 <_bss_end+0x30513c>
 630:	0d0c5c04 	stceq	12, cr5, [ip, #-16]
 634:	0000000c 	andeq	r0, r0, ip
 638:	00000020 	andeq	r0, r0, r0, lsr #32
 63c:	00000570 	andeq	r0, r0, r0, ror r5
 640:	0000927c 	andeq	r9, r0, ip, ror r2
 644:	00000044 	andeq	r0, r0, r4, asr #32
 648:	840c0e42 	strhi	r0, [ip], #-3650	; 0xfffff1be
 64c:	8e028b03 	vmlahi.f64	d8, d2, d3
 650:	0b0c4201 	bleq	310e5c <_bss_end+0x305160>
 654:	0d0c5c04 	stceq	12, cr5, [ip, #-16]
 658:	0000000c 	andeq	r0, r0, ip
 65c:	00000020 	andeq	r0, r0, r0, lsr #32
 660:	00000570 	andeq	r0, r0, r0, ror r5
 664:	000092c0 	andeq	r9, r0, r0, asr #5
 668:	00000050 	andeq	r0, r0, r0, asr r0
 66c:	840c0e42 	strhi	r0, [ip], #-3650	; 0xfffff1be
 670:	8e028b03 	vmlahi.f64	d8, d2, d3
 674:	0b0c4201 	bleq	310e80 <_bss_end+0x305184>
 678:	0d0c6204 	sfmeq	f6, 4, [ip, #-16]
 67c:	0000000c 	andeq	r0, r0, ip
 680:	00000020 	andeq	r0, r0, r0, lsr #32
 684:	00000570 	andeq	r0, r0, r0, ror r5
 688:	00009310 	andeq	r9, r0, r0, lsl r3
 68c:	00000050 	andeq	r0, r0, r0, asr r0
 690:	840c0e42 	strhi	r0, [ip], #-3650	; 0xfffff1be
 694:	8e028b03 	vmlahi.f64	d8, d2, d3
 698:	0b0c4201 	bleq	310ea4 <_bss_end+0x3051a8>
 69c:	0d0c6204 	sfmeq	f6, 4, [ip, #-16]
 6a0:	0000000c 	andeq	r0, r0, ip
 6a4:	0000001c 	andeq	r0, r0, ip, lsl r0
 6a8:	00000570 	andeq	r0, r0, r0, ror r5
 6ac:	00009360 	andeq	r9, r0, r0, ror #6
 6b0:	00000054 	andeq	r0, r0, r4, asr r0
 6b4:	8b080e42 	blhi	203fc4 <_bss_end+0x1f82c8>
 6b8:	42018e02 	andmi	r8, r1, #2, 28
 6bc:	5e040b0c 	vmlapl.f64	d0, d4, d12
 6c0:	00080d0c 	andeq	r0, r8, ip, lsl #26
 6c4:	00000018 	andeq	r0, r0, r8, lsl r0
 6c8:	00000570 	andeq	r0, r0, r0, ror r5
 6cc:	000093b4 			; <UNDEFINED> instruction: 0x000093b4
 6d0:	0000001c 	andeq	r0, r0, ip, lsl r0
 6d4:	8b080e42 	blhi	203fe4 <_bss_end+0x1f82e8>
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
 700:	8b080e42 	blhi	204010 <_bss_end+0x1f8314>
 704:	42018e02 	andmi	r8, r1, #2, 28
 708:	00040b0c 	andeq	r0, r4, ip, lsl #22
 70c:	00000018 	andeq	r0, r0, r8, lsl r0
 710:	000006e0 	andeq	r0, r0, r0, ror #13
 714:	0000942c 	andeq	r9, r0, ip, lsr #8
 718:	00000068 	andeq	r0, r0, r8, rrx
 71c:	8b080e42 	blhi	20402c <_bss_end+0x1f8330>
 720:	42018e02 	andmi	r8, r1, #2, 28
 724:	00040b0c 	andeq	r0, r4, ip, lsl #22
 728:	00000018 	andeq	r0, r0, r8, lsl r0
 72c:	000006e0 	andeq	r0, r0, r0, ror #13
 730:	00009494 	muleq	r0, r4, r4
 734:	00000068 	andeq	r0, r0, r8, rrx
 738:	8b080e42 	blhi	204048 <_bss_end+0x1f834c>
 73c:	42018e02 	andmi	r8, r1, #2, 28
 740:	00040b0c 	andeq	r0, r4, ip, lsl #22
 744:	00000018 	andeq	r0, r0, r8, lsl r0
 748:	000006e0 	andeq	r0, r0, r0, ror #13
 74c:	000094fc 	strdeq	r9, [r0], -ip
 750:	00000068 	andeq	r0, r0, r8, rrx
 754:	8b080e42 	blhi	204064 <_bss_end+0x1f8368>
 758:	42018e02 	andmi	r8, r1, #2, 28
 75c:	00040b0c 	andeq	r0, r4, ip, lsl #22
 760:	00000018 	andeq	r0, r0, r8, lsl r0
 764:	000006e0 	andeq	r0, r0, r0, ror #13
 768:	00009564 	andeq	r9, r0, r4, ror #10
 76c:	00000068 	andeq	r0, r0, r8, rrx
 770:	8b080e42 	blhi	204080 <_bss_end+0x1f8384>
 774:	42018e02 	andmi	r8, r1, #2, 28
 778:	00040b0c 	andeq	r0, r4, ip, lsl #22
 77c:	00000018 	andeq	r0, r0, r8, lsl r0
 780:	000006e0 	andeq	r0, r0, r0, ror #13
 784:	000095cc 	andeq	r9, r0, ip, asr #11
 788:	000000dc 	ldrdeq	r0, [r0], -ip
 78c:	8b080e42 	blhi	20409c <_bss_end+0x1f83a0>
 790:	42018e02 	andmi	r8, r1, #2, 28
 794:	00040b0c 	andeq	r0, r4, ip, lsl #22
 798:	0000000c 	andeq	r0, r0, ip
 79c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 7a0:	7c020001 	stcvc	0, cr0, [r2], {1}
 7a4:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 7a8:	0000001c 	andeq	r0, r0, ip, lsl r0
 7ac:	00000798 	muleq	r0, r8, r7
 7b0:	000096a8 	andeq	r9, r0, r8, lsr #13
 7b4:	00000034 	andeq	r0, r0, r4, lsr r0
 7b8:	8b080e42 	blhi	2040c8 <_bss_end+0x1f83cc>
 7bc:	42018e02 	andmi	r8, r1, #2, 28
 7c0:	54040b0c 	strpl	r0, [r4], #-2828	; 0xfffff4f4
 7c4:	00080d0c 	andeq	r0, r8, ip, lsl #26
 7c8:	0000001c 	andeq	r0, r0, ip, lsl r0
 7cc:	00000798 	muleq	r0, r8, r7
 7d0:	000096dc 	ldrdeq	r9, [r0], -ip
 7d4:	00000068 	andeq	r0, r0, r8, rrx
 7d8:	8b080e42 	blhi	2040e8 <_bss_end+0x1f83ec>
 7dc:	42018e02 	andmi	r8, r1, #2, 28
 7e0:	6a040b0c 	bvs	103418 <_bss_end+0xf771c>
 7e4:	00080d0c 	andeq	r0, r8, ip, lsl #26
 7e8:	0000001c 	andeq	r0, r0, ip, lsl r0
 7ec:	00000798 	muleq	r0, r8, r7
 7f0:	00009744 	andeq	r9, r0, r4, asr #14
 7f4:	0000014c 	andeq	r0, r0, ip, asr #2
 7f8:	8b040e42 	blhi	104108 <_bss_end+0xf840c>
 7fc:	0b0d4201 	bleq	351008 <_bss_end+0x34530c>
 800:	0d0d9e02 	stceq	14, cr9, [sp, #-8]
 804:	000ecb42 	andeq	ip, lr, r2, asr #22
 808:	0000001c 	andeq	r0, r0, ip, lsl r0
 80c:	00000798 	muleq	r0, r8, r7
 810:	00009890 	muleq	r0, r0, r8
 814:	0000011c 	andeq	r0, r0, ip, lsl r1
 818:	8b040e42 	blhi	104128 <_bss_end+0xf842c>
 81c:	0b0d4201 	bleq	351028 <_bss_end+0x34532c>
 820:	0d0d8602 	stceq	6, cr8, [sp, #-8]
 824:	000ecb42 	andeq	ip, lr, r2, asr #22
 828:	0000001c 	andeq	r0, r0, ip, lsl r0
 82c:	00000798 	muleq	r0, r8, r7
 830:	000099ac 	andeq	r9, r0, ip, lsr #19
 834:	0000004c 	andeq	r0, r0, ip, asr #32
 838:	8b080e42 	blhi	204148 <_bss_end+0x1f844c>
 83c:	42018e02 	andmi	r8, r1, #2, 28
 840:	5c040b0c 			; <UNDEFINED> instruction: 0x5c040b0c
 844:	00080d0c 	andeq	r0, r8, ip, lsl #26
 848:	00000018 	andeq	r0, r0, r8, lsl r0
 84c:	00000798 	muleq	r0, r8, r7
 850:	000099f8 	strdeq	r9, [r0], -r8
 854:	0000001c 	andeq	r0, r0, ip, lsl r0
 858:	8b080e42 	blhi	204168 <_bss_end+0x1f846c>
 85c:	42018e02 	andmi	r8, r1, #2, 28
 860:	00040b0c 	andeq	r0, r4, ip, lsl #22
 864:	0000000c 	andeq	r0, r0, ip
 868:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 86c:	7c020001 	stcvc	0, cr0, [r2], {1}
 870:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 874:	0000001c 	andeq	r0, r0, ip, lsl r0
 878:	00000864 	andeq	r0, r0, r4, ror #16
 87c:	00009a14 	andeq	r9, r0, r4, lsl sl
 880:	000000b0 	strheq	r0, [r0], -r0	; <UNPREDICTABLE>
 884:	8b040e42 	blhi	104194 <_bss_end+0xf8498>
 888:	0b0d4201 	bleq	351094 <_bss_end+0x345398>
 88c:	0d0d5002 	stceq	0, cr5, [sp, #-8]
 890:	000ecb42 	andeq	ip, lr, r2, asr #22
 894:	0000001c 	andeq	r0, r0, ip, lsl r0
 898:	00000864 	andeq	r0, r0, r4, ror #16
 89c:	00009ac4 	andeq	r9, r0, r4, asr #21
 8a0:	00000090 	muleq	r0, r0, r0
 8a4:	8b040e42 	blhi	1041b4 <_bss_end+0xf84b8>
 8a8:	0b0d4201 	bleq	3510b4 <_bss_end+0x3453b8>
 8ac:	0d0d4002 	stceq	0, cr4, [sp, #-8]
 8b0:	000ecb42 	andeq	ip, lr, r2, asr #22
 8b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 8b8:	00000864 	andeq	r0, r0, r4, ror #16
 8bc:	00009b54 	andeq	r9, r0, r4, asr fp
 8c0:	00000064 	andeq	r0, r0, r4, rrx
 8c4:	8b040e42 	blhi	1041d4 <_bss_end+0xf84d8>
 8c8:	0b0d4201 	bleq	3510d4 <_bss_end+0x3453d8>
 8cc:	420d0d68 	andmi	r0, sp, #104, 26	; 0x1a00
 8d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 8d4:	00000020 	andeq	r0, r0, r0, lsr #32
 8d8:	00000864 	andeq	r0, r0, r4, ror #16
 8dc:	00009bb8 			; <UNDEFINED> instruction: 0x00009bb8
 8e0:	000000d4 	ldrdeq	r0, [r0], -r4
 8e4:	840c0e42 	strhi	r0, [ip], #-3650	; 0xfffff1be
 8e8:	8e028b03 	vmlahi.f64	d8, d2, d3
 8ec:	0b0c4201 	bleq	3110f8 <_bss_end+0x3053fc>
 8f0:	0c640204 	sfmeq	f0, 2, [r4], #-16
 8f4:	00000c0d 	andeq	r0, r0, sp, lsl #24
 8f8:	0000001c 	andeq	r0, r0, ip, lsl r0
 8fc:	00000864 	andeq	r0, r0, r4, ror #16
 900:	00009c8c 	andeq	r9, r0, ip, lsl #25
 904:	000000e8 	andeq	r0, r0, r8, ror #1
 908:	8b080e42 	blhi	204218 <_bss_end+0x1f851c>
 90c:	42018e02 	andmi	r8, r1, #2, 28
 910:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 914:	080d0c6c 	stmdaeq	sp, {r2, r3, r5, r6, sl, fp}
 918:	0000001c 	andeq	r0, r0, ip, lsl r0
 91c:	00000864 	andeq	r0, r0, r4, ror #16
 920:	00009d74 	andeq	r9, r0, r4, ror sp
 924:	00000038 	andeq	r0, r0, r8, lsr r0
 928:	8b080e42 	blhi	204238 <_bss_end+0x1f853c>
 92c:	42018e02 	andmi	r8, r1, #2, 28
 930:	56040b0c 	strpl	r0, [r4], -ip, lsl #22
 934:	00080d0c 	andeq	r0, r8, ip, lsl #26
 938:	0000001c 	andeq	r0, r0, ip, lsl r0
 93c:	00000864 	andeq	r0, r0, r4, ror #16
 940:	00009dac 	andeq	r9, r0, ip, lsr #27
 944:	0000004c 	andeq	r0, r0, ip, asr #32
 948:	8b080e42 	blhi	204258 <_bss_end+0x1f855c>
 94c:	42018e02 	andmi	r8, r1, #2, 28
 950:	5c040b0c 			; <UNDEFINED> instruction: 0x5c040b0c
 954:	00080d0c 	andeq	r0, r8, ip, lsl #26
 958:	00000018 	andeq	r0, r0, r8, lsl r0
 95c:	00000864 	andeq	r0, r0, r4, ror #16
 960:	00009df8 	strdeq	r9, [r0], -r8
 964:	0000001c 	andeq	r0, r0, ip, lsl r0
 968:	8b080e42 	blhi	204278 <_bss_end+0x1f857c>
 96c:	42018e02 	andmi	r8, r1, #2, 28
 970:	00040b0c 	andeq	r0, r4, ip, lsl #22
 974:	0000000c 	andeq	r0, r0, ip
 978:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 97c:	7c020001 	stcvc	0, cr0, [r2], {1}
 980:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 984:	0000001c 	andeq	r0, r0, ip, lsl r0
 988:	00000974 	andeq	r0, r0, r4, ror r9
 98c:	00009e14 	andeq	r9, r0, r4, lsl lr
 990:	00000048 	andeq	r0, r0, r8, asr #32
 994:	8b040e42 	blhi	1042a4 <_bss_end+0xf85a8>
 998:	0b0d4201 	bleq	3511a4 <_bss_end+0x3454a8>
 99c:	420d0d5c 	andmi	r0, sp, #92, 26	; 0x1700
 9a0:	00000ecb 	andeq	r0, r0, fp, asr #29
 9a4:	0000001c 	andeq	r0, r0, ip, lsl r0
 9a8:	00000974 	andeq	r0, r0, r4, ror r9
 9ac:	00009e5c 	andeq	r9, r0, ip, asr lr
 9b0:	00000044 	andeq	r0, r0, r4, asr #32
 9b4:	8b040e42 	blhi	1042c4 <_bss_end+0xf85c8>
 9b8:	0b0d4201 	bleq	3511c4 <_bss_end+0x3454c8>
 9bc:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 9c0:	00000ecb 	andeq	r0, r0, fp, asr #29
 9c4:	0000001c 	andeq	r0, r0, ip, lsl r0
 9c8:	00000974 	andeq	r0, r0, r4, ror r9
 9cc:	00009ea0 	andeq	r9, r0, r0, lsr #29
 9d0:	000000f8 	strdeq	r0, [r0], -r8
 9d4:	8b080e42 	blhi	2042e4 <_bss_end+0x1f85e8>
 9d8:	42018e02 	andmi	r8, r1, #2, 28
 9dc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 9e0:	080d0c74 	stmdaeq	sp, {r2, r4, r5, r6, sl, fp}
 9e4:	0000001c 	andeq	r0, r0, ip, lsl r0
 9e8:	00000974 	andeq	r0, r0, r4, ror r9
 9ec:	00009f98 	muleq	r0, r8, pc	; <UNPREDICTABLE>
 9f0:	00000134 	andeq	r0, r0, r4, lsr r1
 9f4:	8b080e42 	blhi	204304 <_bss_end+0x1f8608>
 9f8:	42018e02 	andmi	r8, r1, #2, 28
 9fc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 a00:	080d0c8e 	stmdaeq	sp, {r1, r2, r3, r7, sl, fp}
 a04:	0000001c 	andeq	r0, r0, ip, lsl r0
 a08:	00000974 	andeq	r0, r0, r4, ror r9
 a0c:	0000a0cc 	andeq	sl, r0, ip, asr #1
 a10:	00000168 	andeq	r0, r0, r8, ror #2
 a14:	8b080e42 	blhi	204324 <_bss_end+0x1f8628>
 a18:	42018e02 	andmi	r8, r1, #2, 28
 a1c:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 a20:	080d0cae 	stmdaeq	sp, {r1, r2, r3, r5, r7, sl, fp}
 a24:	0000001c 	andeq	r0, r0, ip, lsl r0
 a28:	00000974 	andeq	r0, r0, r4, ror r9
 a2c:	0000a234 	andeq	sl, r0, r4, lsr r2
 a30:	00000104 	andeq	r0, r0, r4, lsl #2
 a34:	8b080e42 	blhi	204344 <_bss_end+0x1f8648>
 a38:	42018e02 	andmi	r8, r1, #2, 28
 a3c:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 a40:	080d0c7c 	stmdaeq	sp, {r2, r3, r4, r5, r6, sl, fp}
 a44:	0000001c 	andeq	r0, r0, ip, lsl r0
 a48:	00000974 	andeq	r0, r0, r4, ror r9
 a4c:	0000a3a0 	andeq	sl, r0, r0, lsr #7
 a50:	0000002c 	andeq	r0, r0, ip, lsr #32
 a54:	8b080e42 	blhi	204364 <_bss_end+0x1f8668>
 a58:	42018e02 	andmi	r8, r1, #2, 28
 a5c:	50040b0c 	andpl	r0, r4, ip, lsl #22
 a60:	00080d0c 	andeq	r0, r8, ip, lsl #26
 a64:	0000001c 	andeq	r0, r0, ip, lsl r0
 a68:	00000974 	andeq	r0, r0, r4, ror r9
 a6c:	0000a3cc 	andeq	sl, r0, ip, asr #7
 a70:	0000002c 	andeq	r0, r0, ip, lsr #32
 a74:	8b080e42 	blhi	204384 <_bss_end+0x1f8688>
 a78:	42018e02 	andmi	r8, r1, #2, 28
 a7c:	50040b0c 	andpl	r0, r4, ip, lsl #22
 a80:	00080d0c 	andeq	r0, r8, ip, lsl #26
 a84:	0000001c 	andeq	r0, r0, ip, lsl r0
 a88:	00000974 	andeq	r0, r0, r4, ror r9
 a8c:	0000a338 	andeq	sl, r0, r8, lsr r3
 a90:	0000004c 	andeq	r0, r0, ip, asr #32
 a94:	8b080e42 	blhi	2043a4 <_bss_end+0x1f86a8>
 a98:	42018e02 	andmi	r8, r1, #2, 28
 a9c:	5c040b0c 			; <UNDEFINED> instruction: 0x5c040b0c
 aa0:	00080d0c 	andeq	r0, r8, ip, lsl #26
 aa4:	00000018 	andeq	r0, r0, r8, lsl r0
 aa8:	00000974 	andeq	r0, r0, r4, ror r9
 aac:	0000a384 	andeq	sl, r0, r4, lsl #7
 ab0:	0000001c 	andeq	r0, r0, ip, lsl r0
 ab4:	8b080e42 	blhi	2043c4 <_bss_end+0x1f86c8>
 ab8:	42018e02 	andmi	r8, r1, #2, 28
 abc:	00040b0c 	andeq	r0, r4, ip, lsl #22
 ac0:	0000000c 	andeq	r0, r0, ip
 ac4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 ac8:	7c020001 	stcvc	0, cr0, [r2], {1}
 acc:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 ad0:	0000001c 	andeq	r0, r0, ip, lsl r0
 ad4:	00000ac0 	andeq	r0, r0, r0, asr #21
 ad8:	0000a4a4 	andeq	sl, r0, r4, lsr #9
 adc:	00000068 	andeq	r0, r0, r8, rrx
 ae0:	8b040e42 	blhi	1043f0 <_bss_end+0xf86f4>
 ae4:	0b0d4201 	bleq	3512f0 <_bss_end+0x3455f4>
 ae8:	420d0d68 	andmi	r0, sp, #104, 26	; 0x1a00
 aec:	00000ecb 	andeq	r0, r0, fp, asr #29
 af0:	0000001c 	andeq	r0, r0, ip, lsl r0
 af4:	00000ac0 	andeq	r0, r0, r0, asr #21
 af8:	0000a50c 	andeq	sl, r0, ip, lsl #10
 afc:	00000058 	andeq	r0, r0, r8, asr r0
 b00:	8b080e42 	blhi	204410 <_bss_end+0x1f8714>
 b04:	42018e02 	andmi	r8, r1, #2, 28
 b08:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 b0c:	00080d0c 	andeq	r0, r8, ip, lsl #26
 b10:	0000001c 	andeq	r0, r0, ip, lsl r0
 b14:	00000ac0 	andeq	r0, r0, r0, asr #21
 b18:	0000a564 	andeq	sl, r0, r4, ror #10
 b1c:	00000058 	andeq	r0, r0, r8, asr r0
 b20:	8b080e42 	blhi	204430 <_bss_end+0x1f8734>
 b24:	42018e02 	andmi	r8, r1, #2, 28
 b28:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 b2c:	00080d0c 	andeq	r0, r8, ip, lsl #26
 b30:	0000000c 	andeq	r0, r0, ip
 b34:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 b38:	7c020001 	stcvc	0, cr0, [r2], {1}
 b3c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 b40:	0000001c 	andeq	r0, r0, ip, lsl r0
 b44:	00000b30 	andeq	r0, r0, r0, lsr fp
 b48:	0000a5bc 			; <UNDEFINED> instruction: 0x0000a5bc
 b4c:	00000174 	andeq	r0, r0, r4, ror r1
 b50:	8b080e42 	blhi	204460 <_bss_end+0x1f8764>
 b54:	42018e02 	andmi	r8, r1, #2, 28
 b58:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 b5c:	080d0cb2 	stmdaeq	sp, {r1, r4, r5, r7, sl, fp}
 b60:	0000000c 	andeq	r0, r0, ip
 b64:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 b68:	7c010001 	stcvc	0, cr0, [r1], {1}
 b6c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 b70:	0000000c 	andeq	r0, r0, ip
 b74:	00000b60 	andeq	r0, r0, r0, ror #22
 b78:	0000a730 	andeq	sl, r0, r0, lsr r7
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
  38:	00009e14 	andeq	r9, r0, r4, lsl lr
  3c:	0000a3a0 	andeq	sl, r0, r0, lsr #7
  40:	0000a3a0 	andeq	sl, r0, r0, lsr #7
  44:	0000a3cc 	andeq	sl, r0, ip, asr #7
  48:	0000a3cc 	andeq	sl, r0, ip, asr #7
  4c:	0000a3f8 	strdeq	sl, [r0], -r8
	...
  58:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  5c:	00000000 	andeq	r0, r0, r0
  60:	00008000 	andeq	r8, r0, r0
  64:	000080ac 	andeq	r8, r0, ip, lsr #1
  68:	0000a454 	andeq	sl, r0, r4, asr r4
  6c:	0000a4a4 	andeq	sl, r0, r4, lsr #9
	...
