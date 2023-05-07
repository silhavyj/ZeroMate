
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
    8024:	0000a2b8 			; <UNDEFINED> instruction: 0x0000a2b8

00008028 <_software_interrupt_ptr>:
_software_interrupt_ptr():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:21
    8028:	00009078 	andeq	r9, r0, r8, ror r0

0000802c <_prefetch_abort_ptr>:
_prefetch_abort_ptr():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:21
    802c:	0000a2e4 	andeq	sl, r0, r4, ror #5

00008030 <_data_abort_ptr>:
_data_abort_ptr():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:21
    8030:	0000a2e8 	andeq	sl, r0, r8, ror #5

00008034 <_unused_handler_ptr>:
_unused_handler_ptr():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:21
    8034:	00008040 	andeq	r8, r0, r0, asr #32

00008038 <_irq_ptr>:
_irq_ptr():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:21
    8038:	0000a2bc 			; <UNDEFINED> instruction: 0x0000a2bc

0000803c <_fast_interrupt_ptr>:
_fast_interrupt_ptr():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:21
    803c:	000090c0 	andeq	r9, r0, r0, asr #1

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
    8098:	eb000893 	bl	a2ec <_c_startup>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:91
	bl _cpp_startup			;@ C++ startup kod (volani globalnich konstruktoru, ...)
    809c:	eb0008ac 	bl	a354 <_cpp_startup>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:92
	bl _kernel_main			;@ skocime do hlavniho kodu jadra (v C)
    80a0:	eb00050e 	bl	94e0 <_kernel_main>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:93
	bl _cpp_shutdown		;@ C++ shutdown kod (volani globalnich destruktoru, ...)
    80a4:	eb0008c0 	bl	a3ac <_cpp_shutdown>

000080a8 <hang>:
hang():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:95
hang:
	b hang
    80a8:	eafffffe 	b	80a8 <hang>

000080ac <__cxa_guard_acquire>:
__cxa_guard_acquire():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/cxx.cpp:11
    extern "C" int __cxa_guard_acquire(__guard*);
    extern "C" void __cxa_guard_release(__guard*);
    extern "C" void __cxa_guard_abort(__guard*);

    extern "C" int __cxa_guard_acquire(__guard* g)
    {
    80ac:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    80b0:	e28db000 	add	fp, sp, #0
    80b4:	e24dd00c 	sub	sp, sp, #12
    80b8:	e50b0008 	str	r0, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/cxx.cpp:12
        return !*(char*)(g);
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

    extern "C" void __cxa_guard_release(__guard* g)
    {
    80e4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    80e8:	e28db000 	add	fp, sp, #0
    80ec:	e24dd00c 	sub	sp, sp, #12
    80f0:	e50b0008 	str	r0, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/cxx.cpp:17
        *(char*)g = 1;
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

    extern "C" void __cxa_guard_abort(__guard*)
    {
    8110:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8114:	e28db000 	add	fp, sp, #0
    8118:	e24dd00c 	sub	sp, sp, #12
    811c:	e50b0008 	str	r0, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/cxx.cpp:22
    }
    8120:	e320f000 	nop	{0}
    8124:	e28bd000 	add	sp, fp, #0
    8128:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    812c:	e12fff1e 	bx	lr

00008130 <__dso_handle>:
__dso_handle():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/cxx.cpp:26
}

extern "C" void __dso_handle()
{
    8130:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8134:	e28db000 	add	fp, sp, #0
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/cxx.cpp:28
    // ignore dtors for now
}
    8138:	e320f000 	nop	{0}
    813c:	e28bd000 	add	sp, fp, #0
    8140:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8144:	e12fff1e 	bx	lr

00008148 <__cxa_atexit>:
__cxa_atexit():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/cxx.cpp:31

extern "C" void __cxa_atexit()
{
    8148:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    814c:	e28db000 	add	fp, sp, #0
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/cxx.cpp:33
    // ignore dtors for now
}
    8150:	e320f000 	nop	{0}
    8154:	e28bd000 	add	sp, fp, #0
    8158:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    815c:	e12fff1e 	bx	lr

00008160 <__cxa_pure_virtual>:
__cxa_pure_virtual():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/cxx.cpp:36

extern "C" void __cxa_pure_virtual()
{
    8160:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8164:	e28db000 	add	fp, sp, #0
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/cxx.cpp:38
    // pure virtual method called
}
    8168:	e320f000 	nop	{0}
    816c:	e28bd000 	add	sp, fp, #0
    8170:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8174:	e12fff1e 	bx	lr

00008178 <__aeabi_unwind_cpp_pr1>:
__aeabi_unwind_cpp_pr1():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/cxx.cpp:41

extern "C" void __aeabi_unwind_cpp_pr1()
{
    8178:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    817c:	e28db000 	add	fp, sp, #0
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/cxx.cpp:42 (discriminator 1)
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
    8694:	0000ab14 	andeq	sl, r0, r4, lsl fp

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
    8740:	eb00016d 	bl	8cfc <_ZN8CMonitor12Reset_CursorEv>
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
    8998:	eb0000e5 	bl	8d34 <_ZN8CMonitor13Adjust_CursorEv>
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
    8a10:	eb0000e9 	bl	8dbc <_ZN8CMonitor17Reset_Number_BaseEv>
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
    8a94:	eb0000c8 	bl	8dbc <_ZN8CMonitor17Reset_Number_BaseEv>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:116

    return *this;
    8a98:	e51b3008 	ldr	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:117
}
    8a9c:	e1a00003 	mov	r0, r3
    8aa0:	e24bd004 	sub	sp, fp, #4
    8aa4:	e8bd8800 	pop	{fp, pc}
    8aa8:	0000ab30 	andeq	sl, r0, r0, lsr fp

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
    8af0:	eb0000b1 	bl	8dbc <_ZN8CMonitor17Reset_Number_BaseEv>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:132

    return *this;
    8af4:	e51b3008 	ldr	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:133
}
    8af8:	e1a00003 	mov	r0, r3
    8afc:	e24bd004 	sub	sp, fp, #4
    8b00:	e8bd8800 	pop	{fp, pc}
    8b04:	0000a918 	andeq	sl, r0, r8, lsl r9
    8b08:	0000a920 	andeq	sl, r0, r0, lsr #18

00008b0c <_ZN8CMonitor4itoaEjPcj>:
_ZN8CMonitor4itoaEjPcj():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:136

void CMonitor::itoa(unsigned int input, char* output, unsigned int base)
{
    8b0c:	e92d4800 	push	{fp, lr}
    8b10:	e28db004 	add	fp, sp, #4
    8b14:	e24dd020 	sub	sp, sp, #32
    8b18:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8b1c:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    8b20:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    8b24:	e50b3024 	str	r3, [fp, #-36]	; 0xffffffdc
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:137
    int i = 0;
    8b28:	e3a03000 	mov	r3, #0
    8b2c:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:139

    while (input > 0)
    8b30:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8b34:	e3530000 	cmp	r3, #0
    8b38:	0a000015 	beq	8b94 <_ZN8CMonitor4itoaEjPcj+0x88>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:141
    {
        output[i] = CharConvArr[input % base];
    8b3c:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8b40:	e51b1024 	ldr	r1, [fp, #-36]	; 0xffffffdc
    8b44:	e1a00003 	mov	r0, r3
    8b48:	eb000705 	bl	a764 <__aeabi_uidivmod>
    8b4c:	e1a03001 	mov	r3, r1
    8b50:	e1a02003 	mov	r2, r3
    8b54:	e59f3128 	ldr	r3, [pc, #296]	; 8c84 <_ZN8CMonitor4itoaEjPcj+0x178>
    8b58:	e0822003 	add	r2, r2, r3
    8b5c:	e51b3008 	ldr	r3, [fp, #-8]
    8b60:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    8b64:	e0813003 	add	r3, r1, r3
    8b68:	e5d22000 	ldrb	r2, [r2]
    8b6c:	e5c32000 	strb	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:142
        input /= base;
    8b70:	e51b1024 	ldr	r1, [fp, #-36]	; 0xffffffdc
    8b74:	e51b001c 	ldr	r0, [fp, #-28]	; 0xffffffe4
    8b78:	eb00067e 	bl	a578 <__udivsi3>
    8b7c:	e1a03000 	mov	r3, r0
    8b80:	e50b301c 	str	r3, [fp, #-28]	; 0xffffffe4
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:144

        i++;
    8b84:	e51b3008 	ldr	r3, [fp, #-8]
    8b88:	e2833001 	add	r3, r3, #1
    8b8c:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:139
    while (input > 0)
    8b90:	eaffffe6 	b	8b30 <_ZN8CMonitor4itoaEjPcj+0x24>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:147
    }

    if (i == 0)
    8b94:	e51b3008 	ldr	r3, [fp, #-8]
    8b98:	e3530000 	cmp	r3, #0
    8b9c:	1a000007 	bne	8bc0 <_ZN8CMonitor4itoaEjPcj+0xb4>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:149
    {
        output[i] = CharConvArr[0];
    8ba0:	e51b3008 	ldr	r3, [fp, #-8]
    8ba4:	e51b2020 	ldr	r2, [fp, #-32]	; 0xffffffe0
    8ba8:	e0823003 	add	r3, r2, r3
    8bac:	e3a02030 	mov	r2, #48	; 0x30
    8bb0:	e5c32000 	strb	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:150
        i++;
    8bb4:	e51b3008 	ldr	r3, [fp, #-8]
    8bb8:	e2833001 	add	r3, r3, #1
    8bbc:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:153
    }

    output[i] = '\0';
    8bc0:	e51b3008 	ldr	r3, [fp, #-8]
    8bc4:	e51b2020 	ldr	r2, [fp, #-32]	; 0xffffffe0
    8bc8:	e0823003 	add	r3, r2, r3
    8bcc:	e3a02000 	mov	r2, #0
    8bd0:	e5c32000 	strb	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:154
    i--;
    8bd4:	e51b3008 	ldr	r3, [fp, #-8]
    8bd8:	e2433001 	sub	r3, r3, #1
    8bdc:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:156

    for (int j = 0; j <= (i / 2); j++)
    8be0:	e3a03000 	mov	r3, #0
    8be4:	e50b300c 	str	r3, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:156 (discriminator 3)
    8be8:	e51b3008 	ldr	r3, [fp, #-8]
    8bec:	e1a02fa3 	lsr	r2, r3, #31
    8bf0:	e0823003 	add	r3, r2, r3
    8bf4:	e1a030c3 	asr	r3, r3, #1
    8bf8:	e1a02003 	mov	r2, r3
    8bfc:	e51b300c 	ldr	r3, [fp, #-12]
    8c00:	e1530002 	cmp	r3, r2
    8c04:	ca00001b 	bgt	8c78 <_ZN8CMonitor4itoaEjPcj+0x16c>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:158 (discriminator 2)
    {
        char c = output[i - j];
    8c08:	e51b2008 	ldr	r2, [fp, #-8]
    8c0c:	e51b300c 	ldr	r3, [fp, #-12]
    8c10:	e0423003 	sub	r3, r2, r3
    8c14:	e1a02003 	mov	r2, r3
    8c18:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8c1c:	e0833002 	add	r3, r3, r2
    8c20:	e5d33000 	ldrb	r3, [r3]
    8c24:	e54b300d 	strb	r3, [fp, #-13]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:159 (discriminator 2)
        output[i - j] = output[j];
    8c28:	e51b300c 	ldr	r3, [fp, #-12]
    8c2c:	e51b2020 	ldr	r2, [fp, #-32]	; 0xffffffe0
    8c30:	e0822003 	add	r2, r2, r3
    8c34:	e51b1008 	ldr	r1, [fp, #-8]
    8c38:	e51b300c 	ldr	r3, [fp, #-12]
    8c3c:	e0413003 	sub	r3, r1, r3
    8c40:	e1a01003 	mov	r1, r3
    8c44:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8c48:	e0833001 	add	r3, r3, r1
    8c4c:	e5d22000 	ldrb	r2, [r2]
    8c50:	e5c32000 	strb	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:160 (discriminator 2)
        output[j] = c;
    8c54:	e51b300c 	ldr	r3, [fp, #-12]
    8c58:	e51b2020 	ldr	r2, [fp, #-32]	; 0xffffffe0
    8c5c:	e0823003 	add	r3, r2, r3
    8c60:	e55b200d 	ldrb	r2, [fp, #-13]
    8c64:	e5c32000 	strb	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:156 (discriminator 2)
    for (int j = 0; j <= (i / 2); j++)
    8c68:	e51b300c 	ldr	r3, [fp, #-12]
    8c6c:	e2833001 	add	r3, r3, #1
    8c70:	e50b300c 	str	r3, [fp, #-12]
    8c74:	eaffffdb 	b	8be8 <_ZN8CMonitor4itoaEjPcj+0xdc>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:162
    }
}
    8c78:	e320f000 	nop	{0}
    8c7c:	e24bd004 	sub	sp, fp, #4
    8c80:	e8bd8800 	pop	{fp, pc}
    8c84:	0000a928 	andeq	sl, r0, r8, lsr #18

00008c88 <_Z41__static_initialization_and_destruction_0ii>:
_Z41__static_initialization_and_destruction_0ii():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:162
    8c88:	e92d4800 	push	{fp, lr}
    8c8c:	e28db004 	add	fp, sp, #4
    8c90:	e24dd008 	sub	sp, sp, #8
    8c94:	e50b0008 	str	r0, [fp, #-8]
    8c98:	e50b100c 	str	r1, [fp, #-12]
    8c9c:	e51b3008 	ldr	r3, [fp, #-8]
    8ca0:	e3530001 	cmp	r3, #1
    8ca4:	1a000008 	bne	8ccc <_Z41__static_initialization_and_destruction_0ii+0x44>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:162 (discriminator 1)
    8ca8:	e51b300c 	ldr	r3, [fp, #-12]
    8cac:	e59f2024 	ldr	r2, [pc, #36]	; 8cd8 <_Z41__static_initialization_and_destruction_0ii+0x50>
    8cb0:	e1530002 	cmp	r3, r2
    8cb4:	1a000004 	bne	8ccc <_Z41__static_initialization_and_destruction_0ii+0x44>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:3
CMonitor sMonitor{ 0x30000000, 80, 25 };
    8cb8:	e3a03019 	mov	r3, #25
    8cbc:	e3a02050 	mov	r2, #80	; 0x50
    8cc0:	e3a01203 	mov	r1, #805306368	; 0x30000000
    8cc4:	e59f0010 	ldr	r0, [pc, #16]	; 8cdc <_Z41__static_initialization_and_destruction_0ii+0x54>
    8cc8:	ebfffe79 	bl	86b4 <_ZN8CMonitorC1Ejjj>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:162
}
    8ccc:	e320f000 	nop	{0}
    8cd0:	e24bd004 	sub	sp, fp, #4
    8cd4:	e8bd8800 	pop	{fp, pc}
    8cd8:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>
    8cdc:	0000ab18 	andeq	sl, r0, r8, lsl fp

00008ce0 <_GLOBAL__sub_I_sMonitor>:
_GLOBAL__sub_I_sMonitor():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:162
    8ce0:	e92d4800 	push	{fp, lr}
    8ce4:	e28db004 	add	fp, sp, #4
    8ce8:	e59f1008 	ldr	r1, [pc, #8]	; 8cf8 <_GLOBAL__sub_I_sMonitor+0x18>
    8cec:	e3a00001 	mov	r0, #1
    8cf0:	ebffffe4 	bl	8c88 <_Z41__static_initialization_and_destruction_0ii>
    8cf4:	e8bd8800 	pop	{fp, pc}
    8cf8:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>

00008cfc <_ZN8CMonitor12Reset_CursorEv>:
_ZN8CMonitor12Reset_CursorEv():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:15
{
    8cfc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8d00:	e28db000 	add	fp, sp, #0
    8d04:	e24dd00c 	sub	sp, sp, #12
    8d08:	e50b0008 	str	r0, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:16
    m_cursor.y = 0;
    8d0c:	e51b3008 	ldr	r3, [fp, #-8]
    8d10:	e3a02000 	mov	r2, #0
    8d14:	e583200c 	str	r2, [r3, #12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:17
    m_cursor.y = 0;
    8d18:	e51b3008 	ldr	r3, [fp, #-8]
    8d1c:	e3a02000 	mov	r2, #0
    8d20:	e583200c 	str	r2, [r3, #12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:18
}
    8d24:	e320f000 	nop	{0}
    8d28:	e28bd000 	add	sp, fp, #0
    8d2c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8d30:	e12fff1e 	bx	lr

00008d34 <_ZN8CMonitor13Adjust_CursorEv>:
_ZN8CMonitor13Adjust_CursorEv():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:34
{
    8d34:	e92d4800 	push	{fp, lr}
    8d38:	e28db004 	add	fp, sp, #4
    8d3c:	e24dd008 	sub	sp, sp, #8
    8d40:	e50b0008 	str	r0, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:35
    if (m_cursor.x >= m_width)
    8d44:	e51b3008 	ldr	r3, [fp, #-8]
    8d48:	e5932010 	ldr	r2, [r3, #16]
    8d4c:	e51b3008 	ldr	r3, [fp, #-8]
    8d50:	e5933004 	ldr	r3, [r3, #4]
    8d54:	e1520003 	cmp	r2, r3
    8d58:	3a000007 	bcc	8d7c <_ZN8CMonitor13Adjust_CursorEv+0x48>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:37
        m_cursor.x = 0;
    8d5c:	e51b3008 	ldr	r3, [fp, #-8]
    8d60:	e3a02000 	mov	r2, #0
    8d64:	e5832010 	str	r2, [r3, #16]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:38
        ++m_cursor.y;
    8d68:	e51b3008 	ldr	r3, [fp, #-8]
    8d6c:	e593300c 	ldr	r3, [r3, #12]
    8d70:	e2832001 	add	r2, r3, #1
    8d74:	e51b3008 	ldr	r3, [fp, #-8]
    8d78:	e583200c 	str	r2, [r3, #12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:41
    if (m_cursor.y >= m_height)
    8d7c:	e51b3008 	ldr	r3, [fp, #-8]
    8d80:	e593200c 	ldr	r2, [r3, #12]
    8d84:	e51b3008 	ldr	r3, [fp, #-8]
    8d88:	e5933008 	ldr	r3, [r3, #8]
    8d8c:	e1520003 	cmp	r2, r3
    8d90:	3a000006 	bcc	8db0 <_ZN8CMonitor13Adjust_CursorEv+0x7c>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:43
        Scroll();
    8d94:	e51b0008 	ldr	r0, [fp, #-8]
    8d98:	ebfffe8d 	bl	87d4 <_ZN8CMonitor6ScrollEv>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:44
        m_cursor.y = m_height - 1;
    8d9c:	e51b3008 	ldr	r3, [fp, #-8]
    8da0:	e5933008 	ldr	r3, [r3, #8]
    8da4:	e2432001 	sub	r2, r3, #1
    8da8:	e51b3008 	ldr	r3, [fp, #-8]
    8dac:	e583200c 	str	r2, [r3, #12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:46
}
    8db0:	e320f000 	nop	{0}
    8db4:	e24bd004 	sub	sp, fp, #4
    8db8:	e8bd8800 	pop	{fp, pc}

00008dbc <_ZN8CMonitor17Reset_Number_BaseEv>:
_ZN8CMonitor17Reset_Number_BaseEv():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:65
{
    8dbc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8dc0:	e28db000 	add	fp, sp, #0
    8dc4:	e24dd00c 	sub	sp, sp, #12
    8dc8:	e50b0008 	str	r0, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:66
    m_number_base = DEFAULT_NUMBER_BASE;
    8dcc:	e51b3008 	ldr	r3, [fp, #-8]
    8dd0:	e3a0200a 	mov	r2, #10
    8dd4:	e5832014 	str	r2, [r3, #20]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/monitor.cpp:67
}
    8dd8:	e320f000 	nop	{0}
    8ddc:	e28bd000 	add	sp, fp, #0
    8de0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8de4:	e12fff1e 	bx	lr

00008de8 <_ZN6CTimerC1Em>:
_ZN6CTimerC2Em():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/timer.cpp:26
    uint16_t unused_4 : 10;
};

#pragma pack(pop)

CTimer::CTimer(unsigned long timer_reg_base)
    8de8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8dec:	e28db000 	add	fp, sp, #0
    8df0:	e24dd00c 	sub	sp, sp, #12
    8df4:	e50b0008 	str	r0, [fp, #-8]
    8df8:	e50b100c 	str	r1, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/timer.cpp:27
: mTimer_Regs(reinterpret_cast<unsigned int*>(timer_reg_base))
    8dfc:	e51b200c 	ldr	r2, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/timer.cpp:28
, mCallback(nullptr)
    8e00:	e51b3008 	ldr	r3, [fp, #-8]
    8e04:	e5832000 	str	r2, [r3]
    8e08:	e51b3008 	ldr	r3, [fp, #-8]
    8e0c:	e3a02000 	mov	r2, #0
    8e10:	e5832004 	str	r2, [r3, #4]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/timer.cpp:31
{
    //
}
    8e14:	e51b3008 	ldr	r3, [fp, #-8]
    8e18:	e1a00003 	mov	r0, r3
    8e1c:	e28bd000 	add	sp, fp, #0
    8e20:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8e24:	e12fff1e 	bx	lr

00008e28 <_ZN6CTimer4RegsEN3hal9Timer_RegE>:
_ZN6CTimer4RegsEN3hal9Timer_RegE():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/timer.cpp:34

volatile unsigned int& CTimer::Regs(hal::Timer_Reg reg)
{
    8e28:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8e2c:	e28db000 	add	fp, sp, #0
    8e30:	e24dd00c 	sub	sp, sp, #12
    8e34:	e50b0008 	str	r0, [fp, #-8]
    8e38:	e50b100c 	str	r1, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/timer.cpp:35
    return mTimer_Regs[static_cast<unsigned int>(reg)];
    8e3c:	e51b3008 	ldr	r3, [fp, #-8]
    8e40:	e5932000 	ldr	r2, [r3]
    8e44:	e51b300c 	ldr	r3, [fp, #-12]
    8e48:	e1a03103 	lsl	r3, r3, #2
    8e4c:	e0823003 	add	r3, r2, r3
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/timer.cpp:36
}
    8e50:	e1a00003 	mov	r0, r3
    8e54:	e28bd000 	add	sp, fp, #0
    8e58:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8e5c:	e12fff1e 	bx	lr

00008e60 <_ZN6CTimer6EnableEPFvvEj16NTimer_Prescaler>:
_ZN6CTimer6EnableEPFvvEj16NTimer_Prescaler():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/timer.cpp:39

void CTimer::Enable(TTimer_Callback callback, unsigned int delay, NTimer_Prescaler prescaler)
{
    8e60:	e92d4810 	push	{r4, fp, lr}
    8e64:	e28db008 	add	fp, sp, #8
    8e68:	e24dd01c 	sub	sp, sp, #28
    8e6c:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8e70:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    8e74:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    8e78:	e54b3021 	strb	r3, [fp, #-33]	; 0xffffffdf
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/timer.cpp:40
    Regs(hal::Timer_Reg::Load) = delay;
    8e7c:	e3a01000 	mov	r1, #0
    8e80:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    8e84:	ebffffe7 	bl	8e28 <_ZN6CTimer4RegsEN3hal9Timer_RegE>
    8e88:	e1a02000 	mov	r2, r0
    8e8c:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8e90:	e5823000 	str	r3, [r2]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/timer.cpp:43

    TTimer_Ctl_Flags reg;
    reg.counter_32b = 1;
    8e94:	e55b3014 	ldrb	r3, [fp, #-20]	; 0xffffffec
    8e98:	e3833002 	orr	r3, r3, #2
    8e9c:	e54b3014 	strb	r3, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/timer.cpp:44
    reg.interrupt_enabled = 1;
    8ea0:	e55b3014 	ldrb	r3, [fp, #-20]	; 0xffffffec
    8ea4:	e3833020 	orr	r3, r3, #32
    8ea8:	e54b3014 	strb	r3, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/timer.cpp:45
    reg.timer_enabled = 1;
    8eac:	e55b3014 	ldrb	r3, [fp, #-20]	; 0xffffffec
    8eb0:	e3833080 	orr	r3, r3, #128	; 0x80
    8eb4:	e54b3014 	strb	r3, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/timer.cpp:46
    reg.prescaler = static_cast<uint8_t>(prescaler);
    8eb8:	e55b3021 	ldrb	r3, [fp, #-33]	; 0xffffffdf
    8ebc:	e2033003 	and	r3, r3, #3
    8ec0:	e6ef3073 	uxtb	r3, r3
    8ec4:	e55b2014 	ldrb	r2, [fp, #-20]	; 0xffffffec
    8ec8:	e2033003 	and	r3, r3, #3
    8ecc:	e3c2200c 	bic	r2, r2, #12
    8ed0:	e1a03103 	lsl	r3, r3, #2
    8ed4:	e1833002 	orr	r3, r3, r2
    8ed8:	e1a02003 	mov	r2, r3
    8edc:	e54b2014 	strb	r2, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/timer.cpp:48

    Regs(hal::Timer_Reg::Control) = *reinterpret_cast<unsigned int*>(&reg);
    8ee0:	e24b4014 	sub	r4, fp, #20
    8ee4:	e3a01002 	mov	r1, #2
    8ee8:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    8eec:	ebffffcd 	bl	8e28 <_ZN6CTimer4RegsEN3hal9Timer_RegE>
    8ef0:	e1a02000 	mov	r2, r0
    8ef4:	e5943000 	ldr	r3, [r4]
    8ef8:	e5823000 	str	r3, [r2]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/timer.cpp:50

    Regs(hal::Timer_Reg::IRQ_Clear) = 1;
    8efc:	e3a01003 	mov	r1, #3
    8f00:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    8f04:	ebffffc7 	bl	8e28 <_ZN6CTimer4RegsEN3hal9Timer_RegE>
    8f08:	e1a03000 	mov	r3, r0
    8f0c:	e3a02001 	mov	r2, #1
    8f10:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/timer.cpp:52

    mCallback = callback;
    8f14:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8f18:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8f1c:	e5832004 	str	r2, [r3, #4]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/timer.cpp:53
}
    8f20:	e320f000 	nop	{0}
    8f24:	e24bd008 	sub	sp, fp, #8
    8f28:	e8bd8810 	pop	{r4, fp, pc}

00008f2c <_ZN6CTimer7DisableEv>:
_ZN6CTimer7DisableEv():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/timer.cpp:56

void CTimer::Disable()
{
    8f2c:	e92d4800 	push	{fp, lr}
    8f30:	e28db004 	add	fp, sp, #4
    8f34:	e24dd010 	sub	sp, sp, #16
    8f38:	e50b0010 	str	r0, [fp, #-16]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/timer.cpp:57
    volatile TTimer_Ctl_Flags& reg = reinterpret_cast<volatile TTimer_Ctl_Flags&>(Regs(hal::Timer_Reg::Control));
    8f3c:	e3a01002 	mov	r1, #2
    8f40:	e51b0010 	ldr	r0, [fp, #-16]
    8f44:	ebffffb7 	bl	8e28 <_ZN6CTimer4RegsEN3hal9Timer_RegE>
    8f48:	e50b0008 	str	r0, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/timer.cpp:59

    reg.interrupt_enabled = 0;
    8f4c:	e51b2008 	ldr	r2, [fp, #-8]
    8f50:	e5d23000 	ldrb	r3, [r2]
    8f54:	e3c33020 	bic	r3, r3, #32
    8f58:	e5c23000 	strb	r3, [r2]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/timer.cpp:60
    reg.timer_enabled = 0;
    8f5c:	e51b2008 	ldr	r2, [fp, #-8]
    8f60:	e5d23000 	ldrb	r3, [r2]
    8f64:	e3c33080 	bic	r3, r3, #128	; 0x80
    8f68:	e5c23000 	strb	r3, [r2]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/timer.cpp:61
}
    8f6c:	e320f000 	nop	{0}
    8f70:	e24bd004 	sub	sp, fp, #4
    8f74:	e8bd8800 	pop	{fp, pc}

00008f78 <_ZN6CTimer12IRQ_CallbackEv>:
_ZN6CTimer12IRQ_CallbackEv():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/timer.cpp:64

void CTimer::IRQ_Callback()
{
    8f78:	e92d4800 	push	{fp, lr}
    8f7c:	e28db004 	add	fp, sp, #4
    8f80:	e24dd008 	sub	sp, sp, #8
    8f84:	e50b0008 	str	r0, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/timer.cpp:65
    Regs(hal::Timer_Reg::IRQ_Clear) = 1;
    8f88:	e3a01003 	mov	r1, #3
    8f8c:	e51b0008 	ldr	r0, [fp, #-8]
    8f90:	ebffffa4 	bl	8e28 <_ZN6CTimer4RegsEN3hal9Timer_RegE>
    8f94:	e1a03000 	mov	r3, r0
    8f98:	e3a02001 	mov	r2, #1
    8f9c:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/timer.cpp:67

    if (mCallback)
    8fa0:	e51b3008 	ldr	r3, [fp, #-8]
    8fa4:	e5933004 	ldr	r3, [r3, #4]
    8fa8:	e3530000 	cmp	r3, #0
    8fac:	0a000002 	beq	8fbc <_ZN6CTimer12IRQ_CallbackEv+0x44>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/timer.cpp:68
        mCallback();
    8fb0:	e51b3008 	ldr	r3, [fp, #-8]
    8fb4:	e5933004 	ldr	r3, [r3, #4]
    8fb8:	e12fff33 	blx	r3
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/timer.cpp:69
}
    8fbc:	e320f000 	nop	{0}
    8fc0:	e24bd004 	sub	sp, fp, #4
    8fc4:	e8bd8800 	pop	{fp, pc}

00008fc8 <_ZN6CTimer20Is_Timer_IRQ_PendingEv>:
_ZN6CTimer20Is_Timer_IRQ_PendingEv():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/timer.cpp:72

bool CTimer::Is_Timer_IRQ_Pending()
{
    8fc8:	e92d4800 	push	{fp, lr}
    8fcc:	e28db004 	add	fp, sp, #4
    8fd0:	e24dd008 	sub	sp, sp, #8
    8fd4:	e50b0008 	str	r0, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/timer.cpp:73
    return Regs(hal::Timer_Reg::IRQ_Masked);
    8fd8:	e3a01005 	mov	r1, #5
    8fdc:	e51b0008 	ldr	r0, [fp, #-8]
    8fe0:	ebffff90 	bl	8e28 <_ZN6CTimer4RegsEN3hal9Timer_RegE>
    8fe4:	e1a03000 	mov	r3, r0
    8fe8:	e5933000 	ldr	r3, [r3]
    8fec:	e3530000 	cmp	r3, #0
    8ff0:	13a03001 	movne	r3, #1
    8ff4:	03a03000 	moveq	r3, #0
    8ff8:	e6ef3073 	uxtb	r3, r3
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/timer.cpp:74
}
    8ffc:	e1a00003 	mov	r0, r3
    9000:	e24bd004 	sub	sp, fp, #4
    9004:	e8bd8800 	pop	{fp, pc}

00009008 <_Z41__static_initialization_and_destruction_0ii>:
_Z41__static_initialization_and_destruction_0ii():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/timer.cpp:74
    9008:	e92d4800 	push	{fp, lr}
    900c:	e28db004 	add	fp, sp, #4
    9010:	e24dd008 	sub	sp, sp, #8
    9014:	e50b0008 	str	r0, [fp, #-8]
    9018:	e50b100c 	str	r1, [fp, #-12]
    901c:	e51b3008 	ldr	r3, [fp, #-8]
    9020:	e3530001 	cmp	r3, #1
    9024:	1a000006 	bne	9044 <_Z41__static_initialization_and_destruction_0ii+0x3c>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/timer.cpp:74 (discriminator 1)
    9028:	e51b300c 	ldr	r3, [fp, #-12]
    902c:	e59f201c 	ldr	r2, [pc, #28]	; 9050 <_Z41__static_initialization_and_destruction_0ii+0x48>
    9030:	e1530002 	cmp	r3, r2
    9034:	1a000002 	bne	9044 <_Z41__static_initialization_and_destruction_0ii+0x3c>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/timer.cpp:4
CTimer sTimer(hal::Timer_Base);
    9038:	e59f1014 	ldr	r1, [pc, #20]	; 9054 <_Z41__static_initialization_and_destruction_0ii+0x4c>
    903c:	e59f0014 	ldr	r0, [pc, #20]	; 9058 <_Z41__static_initialization_and_destruction_0ii+0x50>
    9040:	ebffff68 	bl	8de8 <_ZN6CTimerC1Em>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/timer.cpp:74
}
    9044:	e320f000 	nop	{0}
    9048:	e24bd004 	sub	sp, fp, #4
    904c:	e8bd8800 	pop	{fp, pc}
    9050:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>
    9054:	2000b400 	andcs	fp, r0, r0, lsl #8
    9058:	0000ab40 	andeq	sl, r0, r0, asr #22

0000905c <_GLOBAL__sub_I_sTimer>:
_GLOBAL__sub_I_sTimer():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/drivers/timer.cpp:74
    905c:	e92d4800 	push	{fp, lr}
    9060:	e28db004 	add	fp, sp, #4
    9064:	e59f1008 	ldr	r1, [pc, #8]	; 9074 <_GLOBAL__sub_I_sTimer+0x18>
    9068:	e3a00001 	mov	r0, #1
    906c:	ebffffe5 	bl	9008 <_Z41__static_initialization_and_destruction_0ii>
    9070:	e8bd8800 	pop	{fp, pc}
    9074:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>

00009078 <software_interrupt_handler>:
software_interrupt_handler():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/interrupt_controller.cpp:12
CInterrupt_Controller sInterruptCtl(hal::Interrupt_Controller_Base);

// handlery jednotlivych zdroju preruseni

extern "C" void __attribute__((interrupt("SWI"))) software_interrupt_handler()
{
    9078:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    907c:	e28db000 	add	fp, sp, #0
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/interrupt_controller.cpp:14
    // tady nekdy v budoucnu definujeme obsluhu volani sluzeb jadra z uzivatelskeho procesu
}
    9080:	e320f000 	nop	{0}
    9084:	e28bd000 	add	sp, fp, #0
    9088:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    908c:	e1b0f00e 	movs	pc, lr

00009090 <_internal_irq_handler>:
_internal_irq_handler():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/interrupt_controller.cpp:17

extern "C" void _internal_irq_handler()
{
    9090:	e92d4800 	push	{fp, lr}
    9094:	e28db004 	add	fp, sp, #4
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/interrupt_controller.cpp:22
    // jelikoz ARM nerozlisuje zdroje IRQ implicitne, ani nezarucuje, ze se navzajen nemaskuji, musime
    // projit vsechny mozne zdroje a podivat se (poll), zda nebylo vyvolano preruseni

    // casovac
    if (sTimer.Is_Timer_IRQ_Pending())
    9098:	e59f001c 	ldr	r0, [pc, #28]	; 90bc <_internal_irq_handler+0x2c>
    909c:	ebffffc9 	bl	8fc8 <_ZN6CTimer20Is_Timer_IRQ_PendingEv>
    90a0:	e1a03000 	mov	r3, r0
    90a4:	e3530000 	cmp	r3, #0
    90a8:	0a000001 	beq	90b4 <_internal_irq_handler+0x24>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/interrupt_controller.cpp:23
        sTimer.IRQ_Callback();
    90ac:	e59f0008 	ldr	r0, [pc, #8]	; 90bc <_internal_irq_handler+0x2c>
    90b0:	ebffffb0 	bl	8f78 <_ZN6CTimer12IRQ_CallbackEv>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/interrupt_controller.cpp:24
}
    90b4:	e320f000 	nop	{0}
    90b8:	e8bd8800 	pop	{fp, pc}
    90bc:	0000ab40 	andeq	sl, r0, r0, asr #22

000090c0 <fast_interrupt_handler>:
fast_interrupt_handler():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/interrupt_controller.cpp:27

extern "C" void __attribute__((interrupt("FIQ"))) fast_interrupt_handler()
{
    90c0:	e24db004 	sub	fp, sp, #4
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/interrupt_controller.cpp:29
    // zatim nepouzivame
}
    90c4:	e320f000 	nop	{0}
    90c8:	e28bd004 	add	sp, fp, #4
    90cc:	e25ef004 	subs	pc, lr, #4

000090d0 <_ZN21CInterrupt_ControllerC1Em>:
_ZN21CInterrupt_ControllerC2Em():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/interrupt_controller.cpp:33

// implementace controlleru

CInterrupt_Controller::CInterrupt_Controller(unsigned long base)
    90d0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    90d4:	e28db000 	add	fp, sp, #0
    90d8:	e24dd00c 	sub	sp, sp, #12
    90dc:	e50b0008 	str	r0, [fp, #-8]
    90e0:	e50b100c 	str	r1, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/interrupt_controller.cpp:34
: mInterrupt_Regs(reinterpret_cast<unsigned int*>(base))
    90e4:	e51b200c 	ldr	r2, [fp, #-12]
    90e8:	e51b3008 	ldr	r3, [fp, #-8]
    90ec:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/interrupt_controller.cpp:37
{
    //
}
    90f0:	e51b3008 	ldr	r3, [fp, #-8]
    90f4:	e1a00003 	mov	r0, r3
    90f8:	e28bd000 	add	sp, fp, #0
    90fc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9100:	e12fff1e 	bx	lr

00009104 <_ZN21CInterrupt_Controller4RegsEN3hal24Interrupt_Controller_RegE>:
_ZN21CInterrupt_Controller4RegsEN3hal24Interrupt_Controller_RegE():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/interrupt_controller.cpp:40

volatile unsigned int& CInterrupt_Controller::Regs(hal::Interrupt_Controller_Reg reg)
{
    9104:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9108:	e28db000 	add	fp, sp, #0
    910c:	e24dd00c 	sub	sp, sp, #12
    9110:	e50b0008 	str	r0, [fp, #-8]
    9114:	e50b100c 	str	r1, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/interrupt_controller.cpp:41
    return mInterrupt_Regs[static_cast<unsigned int>(reg)];
    9118:	e51b3008 	ldr	r3, [fp, #-8]
    911c:	e5932000 	ldr	r2, [r3]
    9120:	e51b300c 	ldr	r3, [fp, #-12]
    9124:	e1a03103 	lsl	r3, r3, #2
    9128:	e0823003 	add	r3, r2, r3
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/interrupt_controller.cpp:42
}
    912c:	e1a00003 	mov	r0, r3
    9130:	e28bd000 	add	sp, fp, #0
    9134:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9138:	e12fff1e 	bx	lr

0000913c <_ZN21CInterrupt_Controller16Enable_Basic_IRQEN3hal16IRQ_Basic_SourceE>:
_ZN21CInterrupt_Controller16Enable_Basic_IRQEN3hal16IRQ_Basic_SourceE():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/interrupt_controller.cpp:45

void CInterrupt_Controller::Enable_Basic_IRQ(hal::IRQ_Basic_Source source_idx)
{
    913c:	e92d4810 	push	{r4, fp, lr}
    9140:	e28db008 	add	fp, sp, #8
    9144:	e24dd00c 	sub	sp, sp, #12
    9148:	e50b0010 	str	r0, [fp, #-16]
    914c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/interrupt_controller.cpp:46
    Regs(hal::Interrupt_Controller_Reg::IRQ_Basic_Enable) = (1 << static_cast<unsigned int>(source_idx));
    9150:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9154:	e3a02001 	mov	r2, #1
    9158:	e1a04312 	lsl	r4, r2, r3
    915c:	e3a01006 	mov	r1, #6
    9160:	e51b0010 	ldr	r0, [fp, #-16]
    9164:	ebffffe6 	bl	9104 <_ZN21CInterrupt_Controller4RegsEN3hal24Interrupt_Controller_RegE>
    9168:	e1a03000 	mov	r3, r0
    916c:	e1a02004 	mov	r2, r4
    9170:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/interrupt_controller.cpp:47
}
    9174:	e320f000 	nop	{0}
    9178:	e24bd008 	sub	sp, fp, #8
    917c:	e8bd8810 	pop	{r4, fp, pc}

00009180 <_ZN21CInterrupt_Controller17Disable_Basic_IRQEN3hal16IRQ_Basic_SourceE>:
_ZN21CInterrupt_Controller17Disable_Basic_IRQEN3hal16IRQ_Basic_SourceE():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/interrupt_controller.cpp:50

void CInterrupt_Controller::Disable_Basic_IRQ(hal::IRQ_Basic_Source source_idx)
{
    9180:	e92d4810 	push	{r4, fp, lr}
    9184:	e28db008 	add	fp, sp, #8
    9188:	e24dd00c 	sub	sp, sp, #12
    918c:	e50b0010 	str	r0, [fp, #-16]
    9190:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/interrupt_controller.cpp:51
    Regs(hal::Interrupt_Controller_Reg::IRQ_Basic_Disable) = (1 << static_cast<unsigned int>(source_idx));
    9194:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9198:	e3a02001 	mov	r2, #1
    919c:	e1a04312 	lsl	r4, r2, r3
    91a0:	e3a01009 	mov	r1, #9
    91a4:	e51b0010 	ldr	r0, [fp, #-16]
    91a8:	ebffffd5 	bl	9104 <_ZN21CInterrupt_Controller4RegsEN3hal24Interrupt_Controller_RegE>
    91ac:	e1a03000 	mov	r3, r0
    91b0:	e1a02004 	mov	r2, r4
    91b4:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/interrupt_controller.cpp:52
}
    91b8:	e320f000 	nop	{0}
    91bc:	e24bd008 	sub	sp, fp, #8
    91c0:	e8bd8810 	pop	{r4, fp, pc}

000091c4 <_ZN21CInterrupt_Controller10Enable_IRQEN3hal10IRQ_SourceE>:
_ZN21CInterrupt_Controller10Enable_IRQEN3hal10IRQ_SourceE():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/interrupt_controller.cpp:55

void CInterrupt_Controller::Enable_IRQ(hal::IRQ_Source source_idx)
{
    91c4:	e92d4810 	push	{r4, fp, lr}
    91c8:	e28db008 	add	fp, sp, #8
    91cc:	e24dd014 	sub	sp, sp, #20
    91d0:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    91d4:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/interrupt_controller.cpp:56
    const unsigned int idx_base = static_cast<unsigned int>(source_idx);
    91d8:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    91dc:	e50b3010 	str	r3, [fp, #-16]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/interrupt_controller.cpp:58

    Regs(idx_base < 32 ? hal::Interrupt_Controller_Reg::IRQ_Enable_1 : hal::Interrupt_Controller_Reg::IRQ_Enable_1) = (1 << (idx_base % 32));
    91e0:	e51b3010 	ldr	r3, [fp, #-16]
    91e4:	e203301f 	and	r3, r3, #31
    91e8:	e3a02001 	mov	r2, #1
    91ec:	e1a04312 	lsl	r4, r2, r3
    91f0:	e3a01004 	mov	r1, #4
    91f4:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    91f8:	ebffffc1 	bl	9104 <_ZN21CInterrupt_Controller4RegsEN3hal24Interrupt_Controller_RegE>
    91fc:	e1a03000 	mov	r3, r0
    9200:	e1a02004 	mov	r2, r4
    9204:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/interrupt_controller.cpp:59
}
    9208:	e320f000 	nop	{0}
    920c:	e24bd008 	sub	sp, fp, #8
    9210:	e8bd8810 	pop	{r4, fp, pc}

00009214 <_ZN21CInterrupt_Controller11Disable_IRQEN3hal10IRQ_SourceE>:
_ZN21CInterrupt_Controller11Disable_IRQEN3hal10IRQ_SourceE():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/interrupt_controller.cpp:62

void CInterrupt_Controller::Disable_IRQ(hal::IRQ_Source source_idx)
{
    9214:	e92d4810 	push	{r4, fp, lr}
    9218:	e28db008 	add	fp, sp, #8
    921c:	e24dd014 	sub	sp, sp, #20
    9220:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    9224:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/interrupt_controller.cpp:63
    const unsigned int idx_base = static_cast<unsigned int>(source_idx);
    9228:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    922c:	e50b3010 	str	r3, [fp, #-16]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/interrupt_controller.cpp:65

    Regs(idx_base < 32 ? hal::Interrupt_Controller_Reg::IRQ_Disable_1 : hal::Interrupt_Controller_Reg::IRQ_Disable_1) = (1 << (idx_base % 32));
    9230:	e51b3010 	ldr	r3, [fp, #-16]
    9234:	e203301f 	and	r3, r3, #31
    9238:	e3a02001 	mov	r2, #1
    923c:	e1a04312 	lsl	r4, r2, r3
    9240:	e3a01007 	mov	r1, #7
    9244:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    9248:	ebffffad 	bl	9104 <_ZN21CInterrupt_Controller4RegsEN3hal24Interrupt_Controller_RegE>
    924c:	e1a03000 	mov	r3, r0
    9250:	e1a02004 	mov	r2, r4
    9254:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/interrupt_controller.cpp:66
}
    9258:	e320f000 	nop	{0}
    925c:	e24bd008 	sub	sp, fp, #8
    9260:	e8bd8810 	pop	{r4, fp, pc}

00009264 <_Z41__static_initialization_and_destruction_0ii>:
_Z41__static_initialization_and_destruction_0ii():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/interrupt_controller.cpp:66
    9264:	e92d4800 	push	{fp, lr}
    9268:	e28db004 	add	fp, sp, #4
    926c:	e24dd008 	sub	sp, sp, #8
    9270:	e50b0008 	str	r0, [fp, #-8]
    9274:	e50b100c 	str	r1, [fp, #-12]
    9278:	e51b3008 	ldr	r3, [fp, #-8]
    927c:	e3530001 	cmp	r3, #1
    9280:	1a000006 	bne	92a0 <_Z41__static_initialization_and_destruction_0ii+0x3c>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/interrupt_controller.cpp:66 (discriminator 1)
    9284:	e51b300c 	ldr	r3, [fp, #-12]
    9288:	e59f201c 	ldr	r2, [pc, #28]	; 92ac <_Z41__static_initialization_and_destruction_0ii+0x48>
    928c:	e1530002 	cmp	r3, r2
    9290:	1a000002 	bne	92a0 <_Z41__static_initialization_and_destruction_0ii+0x3c>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/interrupt_controller.cpp:7
CInterrupt_Controller sInterruptCtl(hal::Interrupt_Controller_Base);
    9294:	e59f1014 	ldr	r1, [pc, #20]	; 92b0 <_Z41__static_initialization_and_destruction_0ii+0x4c>
    9298:	e59f0014 	ldr	r0, [pc, #20]	; 92b4 <_Z41__static_initialization_and_destruction_0ii+0x50>
    929c:	ebffff8b 	bl	90d0 <_ZN21CInterrupt_ControllerC1Em>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/interrupt_controller.cpp:66
}
    92a0:	e320f000 	nop	{0}
    92a4:	e24bd004 	sub	sp, fp, #4
    92a8:	e8bd8800 	pop	{fp, pc}
    92ac:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>
    92b0:	2000b200 	andcs	fp, r0, r0, lsl #4
    92b4:	0000ab48 	andeq	sl, r0, r8, asr #22

000092b8 <_GLOBAL__sub_I_sInterruptCtl>:
_GLOBAL__sub_I_sInterruptCtl():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/interrupt_controller.cpp:66
    92b8:	e92d4800 	push	{fp, lr}
    92bc:	e28db004 	add	fp, sp, #4
    92c0:	e59f1008 	ldr	r1, [pc, #8]	; 92d0 <_GLOBAL__sub_I_sInterruptCtl+0x18>
    92c4:	e3a00001 	mov	r0, #1
    92c8:	ebffffe5 	bl	9264 <_Z41__static_initialization_and_destruction_0ii>
    92cc:	e8bd8800 	pop	{fp, pc}
    92d0:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>

000092d4 <Timer_Callback>:
Timer_Callback():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:24
// externi funkce pro povoleni IRQ
extern "C" void enable_irq();
extern "C" void disable_irq();

extern "C" void Timer_Callback()
{
    92d4:	e92d4800 	push	{fp, lr}
    92d8:	e28db004 	add	fp, sp, #4
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:25
    sProcessMgr.Schedule();
    92dc:	e59f0040 	ldr	r0, [pc, #64]	; 9324 <Timer_Callback+0x50>
    92e0:	eb00030b 	bl	9f14 <_ZN16CProcess_Manager8ScheduleEv>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:27

    sGPIO.Set_Output(ACT_Pin, LED_State);
    92e4:	e59f303c 	ldr	r3, [pc, #60]	; 9328 <Timer_Callback+0x54>
    92e8:	e5d33000 	ldrb	r3, [r3]
    92ec:	e6ef3073 	uxtb	r3, r3
    92f0:	e1a02003 	mov	r2, r3
    92f4:	e3a0102f 	mov	r1, #47	; 0x2f
    92f8:	e59f002c 	ldr	r0, [pc, #44]	; 932c <Timer_Callback+0x58>
    92fc:	ebfffc79 	bl	84e8 <_ZN13CGPIO_Handler10Set_OutputEjb>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:28
    LED_State = !LED_State;
    9300:	e59f3020 	ldr	r3, [pc, #32]	; 9328 <Timer_Callback+0x54>
    9304:	e5d33000 	ldrb	r3, [r3]
    9308:	e6ef3073 	uxtb	r3, r3
    930c:	e2233001 	eor	r3, r3, #1
    9310:	e6ef2073 	uxtb	r2, r3
    9314:	e59f300c 	ldr	r3, [pc, #12]	; 9328 <Timer_Callback+0x54>
    9318:	e5c32000 	strb	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:29
}
    931c:	e320f000 	nop	{0}
    9320:	e8bd8800 	pop	{fp, pc}
    9324:	0000bb54 	andeq	fp, r0, r4, asr fp
    9328:	0000ab4c 	andeq	sl, r0, ip, asr #22
    932c:	0000ab14 	andeq	sl, r0, r4, lsl fp

00009330 <Process_1>:
Process_1():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:32

extern "C" void Process_1()
{
    9330:	e92d4800 	push	{fp, lr}
    9334:	e28db004 	add	fp, sp, #4
    9338:	e24dd008 	sub	sp, sp, #8
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:35
    volatile int i;

    sMonitor << "Process 1\n";
    933c:	e59f1050 	ldr	r1, [pc, #80]	; 9394 <Process_1+0x64>
    9340:	e59f0050 	ldr	r0, [pc, #80]	; 9398 <Process_1+0x68>
    9344:	ebfffd98 	bl	89ac <_ZN8CMonitorlsEPKc>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:39

    while (true)
    {
        for (i = 0; i < 0x200; i++)
    9348:	e3a03000 	mov	r3, #0
    934c:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:39 (discriminator 3)
    9350:	e51b3008 	ldr	r3, [fp, #-8]
    9354:	e3530c02 	cmp	r3, #512	; 0x200
    9358:	b3a03001 	movlt	r3, #1
    935c:	a3a03000 	movge	r3, #0
    9360:	e6ef3073 	uxtb	r3, r3
    9364:	e3530000 	cmp	r3, #0
    9368:	0a000003 	beq	937c <Process_1+0x4c>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:39 (discriminator 2)
    936c:	e51b3008 	ldr	r3, [fp, #-8]
    9370:	e2833001 	add	r3, r3, #1
    9374:	e50b3008 	str	r3, [fp, #-8]
    9378:	eafffff4 	b	9350 <Process_1+0x20>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:42
            ;
        
        disable_irq();
    937c:	eb0003cb 	bl	a2b0 <disable_irq>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:43
        sMonitor << '1';
    9380:	e3a01031 	mov	r1, #49	; 0x31
    9384:	e59f000c 	ldr	r0, [pc, #12]	; 9398 <Process_1+0x68>
    9388:	ebfffd5d 	bl	8904 <_ZN8CMonitorlsEc>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:44
        enable_irq();
    938c:	eb0003c2 	bl	a29c <enable_irq>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:39
        for (i = 0; i < 0x200; i++)
    9390:	eaffffec 	b	9348 <Process_1+0x18>
    9394:	0000a9a8 	andeq	sl, r0, r8, lsr #19
    9398:	0000ab18 	andeq	sl, r0, r8, lsl fp

0000939c <Process_2>:
Process_2():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:49
    }
}

extern "C" void Process_2()
{
    939c:	e92d4800 	push	{fp, lr}
    93a0:	e28db004 	add	fp, sp, #4
    93a4:	e24dd008 	sub	sp, sp, #8
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:52
    volatile int i;

    sMonitor << "Process 2\n";
    93a8:	e59f1050 	ldr	r1, [pc, #80]	; 9400 <Process_2+0x64>
    93ac:	e59f0050 	ldr	r0, [pc, #80]	; 9404 <Process_2+0x68>
    93b0:	ebfffd7d 	bl	89ac <_ZN8CMonitorlsEPKc>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:56

    while (true)
    {
        for (i = 0; i < 0x200; i++)
    93b4:	e3a03000 	mov	r3, #0
    93b8:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:56 (discriminator 3)
    93bc:	e51b3008 	ldr	r3, [fp, #-8]
    93c0:	e3530c02 	cmp	r3, #512	; 0x200
    93c4:	b3a03001 	movlt	r3, #1
    93c8:	a3a03000 	movge	r3, #0
    93cc:	e6ef3073 	uxtb	r3, r3
    93d0:	e3530000 	cmp	r3, #0
    93d4:	0a000003 	beq	93e8 <Process_2+0x4c>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:56 (discriminator 2)
    93d8:	e51b3008 	ldr	r3, [fp, #-8]
    93dc:	e2833001 	add	r3, r3, #1
    93e0:	e50b3008 	str	r3, [fp, #-8]
    93e4:	eafffff4 	b	93bc <Process_2+0x20>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:59
            ;
        
        disable_irq();
    93e8:	eb0003b0 	bl	a2b0 <disable_irq>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:60
        sMonitor << '2';
    93ec:	e3a01032 	mov	r1, #50	; 0x32
    93f0:	e59f000c 	ldr	r0, [pc, #12]	; 9404 <Process_2+0x68>
    93f4:	ebfffd42 	bl	8904 <_ZN8CMonitorlsEc>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:61
        enable_irq();
    93f8:	eb0003a7 	bl	a29c <enable_irq>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:56
        for (i = 0; i < 0x200; i++)
    93fc:	eaffffec 	b	93b4 <Process_2+0x18>
    9400:	0000a9b4 			; <UNDEFINED> instruction: 0x0000a9b4
    9404:	0000ab18 	andeq	sl, r0, r8, lsl fp

00009408 <Process_3>:
Process_3():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:66
    }
}

extern "C" void Process_3()
{
    9408:	e92d4800 	push	{fp, lr}
    940c:	e28db004 	add	fp, sp, #4
    9410:	e24dd008 	sub	sp, sp, #8
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:69
    volatile int i;

    sMonitor << "Process 3\n";
    9414:	e59f1050 	ldr	r1, [pc, #80]	; 946c <Process_3+0x64>
    9418:	e59f0050 	ldr	r0, [pc, #80]	; 9470 <Process_3+0x68>
    941c:	ebfffd62 	bl	89ac <_ZN8CMonitorlsEPKc>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:73

    while (true)
    {
        for (i = 0; i < 0x200; i++)
    9420:	e3a03000 	mov	r3, #0
    9424:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:73 (discriminator 3)
    9428:	e51b3008 	ldr	r3, [fp, #-8]
    942c:	e3530c02 	cmp	r3, #512	; 0x200
    9430:	b3a03001 	movlt	r3, #1
    9434:	a3a03000 	movge	r3, #0
    9438:	e6ef3073 	uxtb	r3, r3
    943c:	e3530000 	cmp	r3, #0
    9440:	0a000003 	beq	9454 <Process_3+0x4c>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:73 (discriminator 2)
    9444:	e51b3008 	ldr	r3, [fp, #-8]
    9448:	e2833001 	add	r3, r3, #1
    944c:	e50b3008 	str	r3, [fp, #-8]
    9450:	eafffff4 	b	9428 <Process_3+0x20>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:76
            ;
        
        disable_irq();
    9454:	eb000395 	bl	a2b0 <disable_irq>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:77
        sMonitor << '3';
    9458:	e3a01033 	mov	r1, #51	; 0x33
    945c:	e59f000c 	ldr	r0, [pc, #12]	; 9470 <Process_3+0x68>
    9460:	ebfffd27 	bl	8904 <_ZN8CMonitorlsEc>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:78
        enable_irq();
    9464:	eb00038c 	bl	a29c <enable_irq>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:73
        for (i = 0; i < 0x200; i++)
    9468:	eaffffec 	b	9420 <Process_3+0x18>
    946c:	0000a9c0 	andeq	sl, r0, r0, asr #19
    9470:	0000ab18 	andeq	sl, r0, r8, lsl fp

00009474 <Process_4>:
Process_4():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:83
    }
}

extern "C" void Process_4()
{
    9474:	e92d4800 	push	{fp, lr}
    9478:	e28db004 	add	fp, sp, #4
    947c:	e24dd008 	sub	sp, sp, #8
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:86
    volatile int i;

    sMonitor << "Process 4\n";
    9480:	e59f1050 	ldr	r1, [pc, #80]	; 94d8 <Process_4+0x64>
    9484:	e59f0050 	ldr	r0, [pc, #80]	; 94dc <Process_4+0x68>
    9488:	ebfffd47 	bl	89ac <_ZN8CMonitorlsEPKc>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:90

    while (true)
    {
        for (i = 0; i < 0x200; i++)
    948c:	e3a03000 	mov	r3, #0
    9490:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:90 (discriminator 3)
    9494:	e51b3008 	ldr	r3, [fp, #-8]
    9498:	e3530c02 	cmp	r3, #512	; 0x200
    949c:	b3a03001 	movlt	r3, #1
    94a0:	a3a03000 	movge	r3, #0
    94a4:	e6ef3073 	uxtb	r3, r3
    94a8:	e3530000 	cmp	r3, #0
    94ac:	0a000003 	beq	94c0 <Process_4+0x4c>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:90 (discriminator 2)
    94b0:	e51b3008 	ldr	r3, [fp, #-8]
    94b4:	e2833001 	add	r3, r3, #1
    94b8:	e50b3008 	str	r3, [fp, #-8]
    94bc:	eafffff4 	b	9494 <Process_4+0x20>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:93
            ;
        
        disable_irq();
    94c0:	eb00037a 	bl	a2b0 <disable_irq>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:94
        sMonitor << '4';
    94c4:	e3a01034 	mov	r1, #52	; 0x34
    94c8:	e59f000c 	ldr	r0, [pc, #12]	; 94dc <Process_4+0x68>
    94cc:	ebfffd0c 	bl	8904 <_ZN8CMonitorlsEc>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:95
        enable_irq();
    94d0:	eb000371 	bl	a29c <enable_irq>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:90
        for (i = 0; i < 0x200; i++)
    94d4:	eaffffec 	b	948c <Process_4+0x18>
    94d8:	0000a9cc 	andeq	sl, r0, ip, asr #19
    94dc:	0000ab18 	andeq	sl, r0, r8, lsl fp

000094e0 <_kernel_main>:
_kernel_main():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:100
    }
}

extern "C" int _kernel_main(void)
{
    94e0:	e92d4800 	push	{fp, lr}
    94e4:	e28db004 	add	fp, sp, #4
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:102
    // nastavime ACT LED pin na vystupni
    sGPIO.Set_GPIO_Function(ACT_Pin, NGPIO_Function::Output);
    94e8:	e3a02001 	mov	r2, #1
    94ec:	e3a0102f 	mov	r1, #47	; 0x2f
    94f0:	e59f0098 	ldr	r0, [pc, #152]	; 9590 <_kernel_main+0xb0>
    94f4:	ebfffbac 	bl	83ac <_ZN13CGPIO_Handler17Set_GPIO_FunctionEj14NGPIO_Function>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:103
    sGPIO.Set_Output(ACT_Pin, false);
    94f8:	e3a02000 	mov	r2, #0
    94fc:	e3a0102f 	mov	r1, #47	; 0x2f
    9500:	e59f0088 	ldr	r0, [pc, #136]	; 9590 <_kernel_main+0xb0>
    9504:	ebfffbf7 	bl	84e8 <_ZN13CGPIO_Handler10Set_OutputEjb>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:106

    // vypiseme ladici hlasku
    sMonitor.Clear();
    9508:	e59f0084 	ldr	r0, [pc, #132]	; 9594 <_kernel_main+0xb4>
    950c:	ebfffc86 	bl	872c <_ZN8CMonitor5ClearEv>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:107
    sMonitor << "Welcome to KIV/OS RPiOS kernel\n";
    9510:	e59f1080 	ldr	r1, [pc, #128]	; 9598 <_kernel_main+0xb8>
    9514:	e59f0078 	ldr	r0, [pc, #120]	; 9594 <_kernel_main+0xb4>
    9518:	ebfffd23 	bl	89ac <_ZN8CMonitorlsEPKc>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:111

    // sProcessMgr.Create_Main_Process();

    sProcessMgr.Create_Process(reinterpret_cast<unsigned long>(&Process_1));
    951c:	e59f3078 	ldr	r3, [pc, #120]	; 959c <_kernel_main+0xbc>
    9520:	e1a01003 	mov	r1, r3
    9524:	e59f0074 	ldr	r0, [pc, #116]	; 95a0 <_kernel_main+0xc0>
    9528:	eb000208 	bl	9d50 <_ZN16CProcess_Manager14Create_ProcessEm>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:112
    sProcessMgr.Create_Process(reinterpret_cast<unsigned long>(&Process_2));
    952c:	e59f3070 	ldr	r3, [pc, #112]	; 95a4 <_kernel_main+0xc4>
    9530:	e1a01003 	mov	r1, r3
    9534:	e59f0064 	ldr	r0, [pc, #100]	; 95a0 <_kernel_main+0xc0>
    9538:	eb000204 	bl	9d50 <_ZN16CProcess_Manager14Create_ProcessEm>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:113
    sProcessMgr.Create_Process(reinterpret_cast<unsigned long>(&Process_3));
    953c:	e59f3064 	ldr	r3, [pc, #100]	; 95a8 <_kernel_main+0xc8>
    9540:	e1a01003 	mov	r1, r3
    9544:	e59f0054 	ldr	r0, [pc, #84]	; 95a0 <_kernel_main+0xc0>
    9548:	eb000200 	bl	9d50 <_ZN16CProcess_Manager14Create_ProcessEm>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:114
    sProcessMgr.Create_Process(reinterpret_cast<unsigned long>(&Process_4));
    954c:	e59f3058 	ldr	r3, [pc, #88]	; 95ac <_kernel_main+0xcc>
    9550:	e1a01003 	mov	r1, r3
    9554:	e59f0044 	ldr	r0, [pc, #68]	; 95a0 <_kernel_main+0xc0>
    9558:	eb0001fc 	bl	9d50 <_ZN16CProcess_Manager14Create_ProcessEm>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:117

    // zatim zakazeme IRQ casovace
    sInterruptCtl.Disable_Basic_IRQ(hal::IRQ_Basic_Source::Timer);
    955c:	e3a01000 	mov	r1, #0
    9560:	e59f0048 	ldr	r0, [pc, #72]	; 95b0 <_kernel_main+0xd0>
    9564:	ebffff05 	bl	9180 <_ZN21CInterrupt_Controller17Disable_Basic_IRQEN3hal16IRQ_Basic_SourceE>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:120

    // nastavime casovac - v callbacku se provadi planovani procesu
    sTimer.Enable(Timer_Callback, 0x20, NTimer_Prescaler::Prescaler_256);
    9568:	e3a03002 	mov	r3, #2
    956c:	e3a02020 	mov	r2, #32
    9570:	e59f103c 	ldr	r1, [pc, #60]	; 95b4 <_kernel_main+0xd4>
    9574:	e59f003c 	ldr	r0, [pc, #60]	; 95b8 <_kernel_main+0xd8>
    9578:	ebfffe38 	bl	8e60 <_ZN6CTimer6EnableEPFvvEj16NTimer_Prescaler>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:123

    // povolime IRQ casovace
    sInterruptCtl.Enable_Basic_IRQ(hal::IRQ_Basic_Source::Timer);
    957c:	e3a01000 	mov	r1, #0
    9580:	e59f0028 	ldr	r0, [pc, #40]	; 95b0 <_kernel_main+0xd0>
    9584:	ebfffeec 	bl	913c <_ZN21CInterrupt_Controller16Enable_Basic_IRQEN3hal16IRQ_Basic_SourceE>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:125

    enable_irq();
    9588:	eb000343 	bl	a29c <enable_irq>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:128 (discriminator 1)

    // nekonecna smycka - tadyodsud se CPU uz nedostane jinak, nez treba prerusenim
    while (1)
    958c:	eafffffe 	b	958c <_kernel_main+0xac>
    9590:	0000ab14 	andeq	sl, r0, r4, lsl fp
    9594:	0000ab18 	andeq	sl, r0, r8, lsl fp
    9598:	0000a9d8 	ldrdeq	sl, [r0], -r8
    959c:	00009330 	andeq	r9, r0, r0, lsr r3
    95a0:	0000bb54 	andeq	fp, r0, r4, asr fp
    95a4:	0000939c 	muleq	r0, ip, r3
    95a8:	00009408 	andeq	r9, r0, r8, lsl #8
    95ac:	00009474 	andeq	r9, r0, r4, ror r4
    95b0:	0000ab48 	andeq	sl, r0, r8, asr #22
    95b4:	000092d4 	ldrdeq	r9, [r0], -r4
    95b8:	0000ab40 	andeq	sl, r0, r0, asr #22

000095bc <_ZN20CKernel_Heap_ManagerC1Ev>:
_ZN20CKernel_Heap_ManagerC2Ev():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:6
#include <memory/kernel_heap.h>
#include <memory/pages.h>

CKernel_Heap_Manager sKernelMem;

CKernel_Heap_Manager::CKernel_Heap_Manager()
    95bc:	e92d4800 	push	{fp, lr}
    95c0:	e28db004 	add	fp, sp, #4
    95c4:	e24dd008 	sub	sp, sp, #8
    95c8:	e50b0008 	str	r0, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:9
{
    // na zacatku si alokujeme jednu stranku dopredu, protoze je temer jiste, ze budeme docela brzy potrebovat nejakou pamet
    mFirst = Alloc_Next_Page();
    95cc:	e51b0008 	ldr	r0, [fp, #-8]
    95d0:	eb000006 	bl	95f0 <_ZN20CKernel_Heap_Manager15Alloc_Next_PageEv>
    95d4:	e1a02000 	mov	r2, r0
    95d8:	e51b3008 	ldr	r3, [fp, #-8]
    95dc:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:10
}
    95e0:	e51b3008 	ldr	r3, [fp, #-8]
    95e4:	e1a00003 	mov	r0, r3
    95e8:	e24bd004 	sub	sp, fp, #4
    95ec:	e8bd8800 	pop	{fp, pc}

000095f0 <_ZN20CKernel_Heap_Manager15Alloc_Next_PageEv>:
_ZN20CKernel_Heap_Manager15Alloc_Next_PageEv():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:13

TKernel_Heap_Chunk_Header* CKernel_Heap_Manager::Alloc_Next_Page()
{
    95f0:	e92d4800 	push	{fp, lr}
    95f4:	e28db004 	add	fp, sp, #4
    95f8:	e24dd010 	sub	sp, sp, #16
    95fc:	e50b0010 	str	r0, [fp, #-16]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:14
    TKernel_Heap_Chunk_Header* chunk = reinterpret_cast<TKernel_Heap_Chunk_Header*>(sPage_Manager.Alloc_Page());
    9600:	e59f0048 	ldr	r0, [pc, #72]	; 9650 <_ZN20CKernel_Heap_Manager15Alloc_Next_PageEv+0x60>
    9604:	eb00010f 	bl	9a48 <_ZN13CPage_Manager10Alloc_PageEv>
    9608:	e1a03000 	mov	r3, r0
    960c:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:15
    chunk->prev = nullptr;
    9610:	e51b3008 	ldr	r3, [fp, #-8]
    9614:	e3a02000 	mov	r2, #0
    9618:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:16
    chunk->next = nullptr;
    961c:	e51b3008 	ldr	r3, [fp, #-8]
    9620:	e3a02000 	mov	r2, #0
    9624:	e5832004 	str	r2, [r3, #4]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:17
    chunk->size = mem::PageSize - sizeof(TKernel_Heap_Chunk_Header); // z alokovane stranky musime ubrat velikost hlavicky
    9628:	e51b3008 	ldr	r3, [fp, #-8]
    962c:	e59f2020 	ldr	r2, [pc, #32]	; 9654 <_ZN20CKernel_Heap_Manager15Alloc_Next_PageEv+0x64>
    9630:	e5832008 	str	r2, [r3, #8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:18
    chunk->is_free = true;
    9634:	e51b3008 	ldr	r3, [fp, #-8]
    9638:	e3a02001 	mov	r2, #1
    963c:	e5c3200c 	strb	r2, [r3, #12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:20

    return chunk;
    9640:	e51b3008 	ldr	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:21
}
    9644:	e1a00003 	mov	r0, r3
    9648:	e24bd004 	sub	sp, fp, #4
    964c:	e8bd8800 	pop	{fp, pc}
    9650:	0000ab54 	andeq	sl, r0, r4, asr fp
    9654:	00003ff0 	strdeq	r3, [r0], -r0

00009658 <_ZN20CKernel_Heap_Manager5AllocEj>:
_ZN20CKernel_Heap_Manager5AllocEj():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:24

void* CKernel_Heap_Manager::Alloc(uint32_t size)
{
    9658:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    965c:	e28db000 	add	fp, sp, #0
    9660:	e24dd014 	sub	sp, sp, #20
    9664:	e50b0010 	str	r0, [fp, #-16]
    9668:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:25
    TKernel_Heap_Chunk_Header* chunk = mFirst;
    966c:	e51b3010 	ldr	r3, [fp, #-16]
    9670:	e5933000 	ldr	r3, [r3]
    9674:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:28

    // potrebujeme najit prvni blok, ktery je volny a zaroven alespon tak velky, jak potrebujeme (pro ted pouzivame proste first-fit)
    while (chunk != nullptr && (!chunk->is_free || chunk->size < size))
    9678:	e51b3008 	ldr	r3, [fp, #-8]
    967c:	e3530000 	cmp	r3, #0
    9680:	0a00000c 	beq	96b8 <_ZN20CKernel_Heap_Manager5AllocEj+0x60>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:28 (discriminator 1)
    9684:	e51b3008 	ldr	r3, [fp, #-8]
    9688:	e5d3300c 	ldrb	r3, [r3, #12]
    968c:	e3530000 	cmp	r3, #0
    9690:	0a000004 	beq	96a8 <_ZN20CKernel_Heap_Manager5AllocEj+0x50>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:28 (discriminator 2)
    9694:	e51b3008 	ldr	r3, [fp, #-8]
    9698:	e5933008 	ldr	r3, [r3, #8]
    969c:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    96a0:	e1520003 	cmp	r2, r3
    96a4:	9a000003 	bls	96b8 <_ZN20CKernel_Heap_Manager5AllocEj+0x60>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:30
    {
        chunk = chunk->next;
    96a8:	e51b3008 	ldr	r3, [fp, #-8]
    96ac:	e5933004 	ldr	r3, [r3, #4]
    96b0:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:28
    while (chunk != nullptr && (!chunk->is_free || chunk->size < size))
    96b4:	eaffffef 	b	9678 <_ZN20CKernel_Heap_Manager5AllocEj+0x20>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:33
    }

    if (!chunk)
    96b8:	e51b3008 	ldr	r3, [fp, #-8]
    96bc:	e3530000 	cmp	r3, #0
    96c0:	1a000001 	bne	96cc <_ZN20CKernel_Heap_Manager5AllocEj+0x74>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:37
    {
        // TODO: tady by se hodila alokace dalsi stranky (Alloc_Next_Page) a navazani na predchozi chunk
        // pro ted nechme byt, vic jak 4kB snad v tomto prikladu potrebovat nebudeme
        return nullptr;
    96c4:	e3a03000 	mov	r3, #0
    96c8:	ea000031 	b	9794 <_ZN20CKernel_Heap_Manager5AllocEj+0x13c>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:42
    }

    // pokud je pozadovane misto uz tak velke, jak potrebujeme, tak je to snadne - jen ho oznacime za alokovane a vratime
    // vzdy zarovname tak, aby se do dalsiho potencialniho bloku vesla alespon hlavicka dalsiho bloku a nejaky overlap (alespon jeden bajt)
    if (chunk->size >= size && chunk->size <= size + sizeof(TKernel_Heap_Chunk_Header) + 1)
    96cc:	e51b3008 	ldr	r3, [fp, #-8]
    96d0:	e5933008 	ldr	r3, [r3, #8]
    96d4:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    96d8:	e1520003 	cmp	r2, r3
    96dc:	8a00000b 	bhi	9710 <_ZN20CKernel_Heap_Manager5AllocEj+0xb8>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:42 (discriminator 1)
    96e0:	e51b3008 	ldr	r3, [fp, #-8]
    96e4:	e5932008 	ldr	r2, [r3, #8]
    96e8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    96ec:	e2833011 	add	r3, r3, #17
    96f0:	e1520003 	cmp	r2, r3
    96f4:	8a000005 	bhi	9710 <_ZN20CKernel_Heap_Manager5AllocEj+0xb8>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:44
    {
        chunk->is_free = false;
    96f8:	e51b3008 	ldr	r3, [fp, #-8]
    96fc:	e3a02000 	mov	r2, #0
    9700:	e5c3200c 	strb	r2, [r3, #12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:45
        return reinterpret_cast<uint8_t*>(chunk) + sizeof(TKernel_Heap_Chunk_Header); // vracime az pouzitelnou pamet, tedy to co nasleduje po hlavicce
    9704:	e51b3008 	ldr	r3, [fp, #-8]
    9708:	e2833010 	add	r3, r3, #16
    970c:	ea000020 	b	9794 <_ZN20CKernel_Heap_Manager5AllocEj+0x13c>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:51
    }

    // pokud je vetsi, musime blok rozdelit
    // to, ze se tam vejde dalsi hlavicka jsme garantovali prekryvem, viz vyse

    TKernel_Heap_Chunk_Header* hdr2 = reinterpret_cast<TKernel_Heap_Chunk_Header*>(reinterpret_cast<uint8_t*>(chunk) + sizeof(TKernel_Heap_Chunk_Header) + size);
    9710:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9714:	e2833010 	add	r3, r3, #16
    9718:	e51b2008 	ldr	r2, [fp, #-8]
    971c:	e0823003 	add	r3, r2, r3
    9720:	e50b300c 	str	r3, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:53

    hdr2->size = chunk->size - size - sizeof(TKernel_Heap_Chunk_Header);
    9724:	e51b3008 	ldr	r3, [fp, #-8]
    9728:	e5932008 	ldr	r2, [r3, #8]
    972c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9730:	e0423003 	sub	r3, r2, r3
    9734:	e2432010 	sub	r2, r3, #16
    9738:	e51b300c 	ldr	r3, [fp, #-12]
    973c:	e5832008 	str	r2, [r3, #8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:55

    hdr2->prev = chunk;
    9740:	e51b300c 	ldr	r3, [fp, #-12]
    9744:	e51b2008 	ldr	r2, [fp, #-8]
    9748:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:56
    hdr2->next = chunk->next;
    974c:	e51b3008 	ldr	r3, [fp, #-8]
    9750:	e5932004 	ldr	r2, [r3, #4]
    9754:	e51b300c 	ldr	r3, [fp, #-12]
    9758:	e5832004 	str	r2, [r3, #4]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:57
    hdr2->is_free = true;
    975c:	e51b300c 	ldr	r3, [fp, #-12]
    9760:	e3a02001 	mov	r2, #1
    9764:	e5c3200c 	strb	r2, [r3, #12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:58
    chunk->next = hdr2;
    9768:	e51b3008 	ldr	r3, [fp, #-8]
    976c:	e51b200c 	ldr	r2, [fp, #-12]
    9770:	e5832004 	str	r2, [r3, #4]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:60

    chunk->size = size;
    9774:	e51b3008 	ldr	r3, [fp, #-8]
    9778:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    977c:	e5832008 	str	r2, [r3, #8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:61
    chunk->is_free = false;
    9780:	e51b3008 	ldr	r3, [fp, #-8]
    9784:	e3a02000 	mov	r2, #0
    9788:	e5c3200c 	strb	r2, [r3, #12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:63

    return reinterpret_cast<uint8_t*>(chunk) + sizeof(TKernel_Heap_Chunk_Header); // vracime az pouzitelnou pamet, tedy to co nasleduje po hlavicce
    978c:	e51b3008 	ldr	r3, [fp, #-8]
    9790:	e2833010 	add	r3, r3, #16
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:64
}
    9794:	e1a00003 	mov	r0, r3
    9798:	e28bd000 	add	sp, fp, #0
    979c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    97a0:	e12fff1e 	bx	lr

000097a4 <_ZN20CKernel_Heap_Manager4FreeEPv>:
_ZN20CKernel_Heap_Manager4FreeEPv():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:67

void CKernel_Heap_Manager::Free(void* mem)
{
    97a4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    97a8:	e28db000 	add	fp, sp, #0
    97ac:	e24dd014 	sub	sp, sp, #20
    97b0:	e50b0010 	str	r0, [fp, #-16]
    97b4:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:68
    TKernel_Heap_Chunk_Header* chunk = reinterpret_cast<TKernel_Heap_Chunk_Header*>(reinterpret_cast<uint8_t*>(mem) - sizeof(TKernel_Heap_Chunk_Header));
    97b8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    97bc:	e2433010 	sub	r3, r3, #16
    97c0:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:70

    chunk->is_free = true;
    97c4:	e51b3008 	ldr	r3, [fp, #-8]
    97c8:	e3a02001 	mov	r2, #1
    97cc:	e5c3200c 	strb	r2, [r3, #12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:73

    // pokud je dalsi blok volny, spojme tento a dalsi blok do jednoho
    if (chunk->next && chunk->next->is_free)
    97d0:	e51b3008 	ldr	r3, [fp, #-8]
    97d4:	e5933004 	ldr	r3, [r3, #4]
    97d8:	e3530000 	cmp	r3, #0
    97dc:	0a000016 	beq	983c <_ZN20CKernel_Heap_Manager4FreeEPv+0x98>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:73 (discriminator 1)
    97e0:	e51b3008 	ldr	r3, [fp, #-8]
    97e4:	e5933004 	ldr	r3, [r3, #4]
    97e8:	e5d3300c 	ldrb	r3, [r3, #12]
    97ec:	e3530000 	cmp	r3, #0
    97f0:	0a000011 	beq	983c <_ZN20CKernel_Heap_Manager4FreeEPv+0x98>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:75
    {
        chunk->size += chunk->next->size + sizeof(TKernel_Heap_Chunk_Header); // zvetsit soucasny
    97f4:	e51b3008 	ldr	r3, [fp, #-8]
    97f8:	e5932008 	ldr	r2, [r3, #8]
    97fc:	e51b3008 	ldr	r3, [fp, #-8]
    9800:	e5933004 	ldr	r3, [r3, #4]
    9804:	e5933008 	ldr	r3, [r3, #8]
    9808:	e0823003 	add	r3, r2, r3
    980c:	e2832010 	add	r2, r3, #16
    9810:	e51b3008 	ldr	r3, [fp, #-8]
    9814:	e5832008 	str	r2, [r3, #8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:76
        chunk->next = chunk->next->next;                                      // navazat nasledujici nasledujiciho jako dalsi
    9818:	e51b3008 	ldr	r3, [fp, #-8]
    981c:	e5933004 	ldr	r3, [r3, #4]
    9820:	e5932004 	ldr	r2, [r3, #4]
    9824:	e51b3008 	ldr	r3, [fp, #-8]
    9828:	e5832004 	str	r2, [r3, #4]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:77
        chunk->next->prev = chunk;                                            // nasledujicimu nastavit predchozi na sebe
    982c:	e51b3008 	ldr	r3, [fp, #-8]
    9830:	e5933004 	ldr	r3, [r3, #4]
    9834:	e51b2008 	ldr	r2, [fp, #-8]
    9838:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:81
    }

    // pokud je predchozi blok volny, spojme predchozi a tento blok do jednoho
    if (chunk->prev && chunk->prev->is_free)
    983c:	e51b3008 	ldr	r3, [fp, #-8]
    9840:	e5933000 	ldr	r3, [r3]
    9844:	e3530000 	cmp	r3, #0
    9848:	0a000018 	beq	98b0 <_ZN20CKernel_Heap_Manager4FreeEPv+0x10c>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:81 (discriminator 1)
    984c:	e51b3008 	ldr	r3, [fp, #-8]
    9850:	e5933000 	ldr	r3, [r3]
    9854:	e5d3300c 	ldrb	r3, [r3, #12]
    9858:	e3530000 	cmp	r3, #0
    985c:	0a000013 	beq	98b0 <_ZN20CKernel_Heap_Manager4FreeEPv+0x10c>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:83
    {
        chunk->prev->size += chunk->size + sizeof(TKernel_Heap_Chunk_Header);
    9860:	e51b3008 	ldr	r3, [fp, #-8]
    9864:	e5933000 	ldr	r3, [r3]
    9868:	e5932008 	ldr	r2, [r3, #8]
    986c:	e51b3008 	ldr	r3, [fp, #-8]
    9870:	e5933008 	ldr	r3, [r3, #8]
    9874:	e0822003 	add	r2, r2, r3
    9878:	e51b3008 	ldr	r3, [fp, #-8]
    987c:	e5933000 	ldr	r3, [r3]
    9880:	e2822010 	add	r2, r2, #16
    9884:	e5832008 	str	r2, [r3, #8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:84
        chunk->prev->next = chunk->next;
    9888:	e51b3008 	ldr	r3, [fp, #-8]
    988c:	e5933000 	ldr	r3, [r3]
    9890:	e51b2008 	ldr	r2, [fp, #-8]
    9894:	e5922004 	ldr	r2, [r2, #4]
    9898:	e5832004 	str	r2, [r3, #4]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:85
        chunk->next->prev = chunk->prev;
    989c:	e51b3008 	ldr	r3, [fp, #-8]
    98a0:	e5933004 	ldr	r3, [r3, #4]
    98a4:	e51b2008 	ldr	r2, [fp, #-8]
    98a8:	e5922000 	ldr	r2, [r2]
    98ac:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:87
    }
    98b0:	e320f000 	nop	{0}
    98b4:	e28bd000 	add	sp, fp, #0
    98b8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    98bc:	e12fff1e 	bx	lr

000098c0 <_Z41__static_initialization_and_destruction_0ii>:
_Z41__static_initialization_and_destruction_0ii():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:87
    98c0:	e92d4800 	push	{fp, lr}
    98c4:	e28db004 	add	fp, sp, #4
    98c8:	e24dd008 	sub	sp, sp, #8
    98cc:	e50b0008 	str	r0, [fp, #-8]
    98d0:	e50b100c 	str	r1, [fp, #-12]
    98d4:	e51b3008 	ldr	r3, [fp, #-8]
    98d8:	e3530001 	cmp	r3, #1
    98dc:	1a000005 	bne	98f8 <_Z41__static_initialization_and_destruction_0ii+0x38>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:87 (discriminator 1)
    98e0:	e51b300c 	ldr	r3, [fp, #-12]
    98e4:	e59f2018 	ldr	r2, [pc, #24]	; 9904 <_Z41__static_initialization_and_destruction_0ii+0x44>
    98e8:	e1530002 	cmp	r3, r2
    98ec:	1a000001 	bne	98f8 <_Z41__static_initialization_and_destruction_0ii+0x38>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:4
CKernel_Heap_Manager sKernelMem;
    98f0:	e59f0010 	ldr	r0, [pc, #16]	; 9908 <_Z41__static_initialization_and_destruction_0ii+0x48>
    98f4:	ebffff30 	bl	95bc <_ZN20CKernel_Heap_ManagerC1Ev>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:87
    98f8:	e320f000 	nop	{0}
    98fc:	e24bd004 	sub	sp, fp, #4
    9900:	e8bd8800 	pop	{fp, pc}
    9904:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>
    9908:	0000ab50 	andeq	sl, r0, r0, asr fp

0000990c <_GLOBAL__sub_I_sKernelMem>:
_GLOBAL__sub_I_sKernelMem():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/kernel_heap.cpp:87
    990c:	e92d4800 	push	{fp, lr}
    9910:	e28db004 	add	fp, sp, #4
    9914:	e59f1008 	ldr	r1, [pc, #8]	; 9924 <_GLOBAL__sub_I_sKernelMem+0x18>
    9918:	e3a00001 	mov	r0, #1
    991c:	ebffffe7 	bl	98c0 <_Z41__static_initialization_and_destruction_0ii>
    9920:	e8bd8800 	pop	{fp, pc}
    9924:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>

00009928 <_ZN13CPage_ManagerC1Ev>:
_ZN13CPage_ManagerC2Ev():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:5
#include <memory/pages.h>

CPage_Manager sPage_Manager;

CPage_Manager::CPage_Manager()
    9928:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    992c:	e28db000 	add	fp, sp, #0
    9930:	e24dd014 	sub	sp, sp, #20
    9934:	e50b0010 	str	r0, [fp, #-16]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:8
{
    // zadna stranka neni alokovana
    for (int i = 0; i < sizeof(mPage_Bitmap); i++)
    9938:	e3a03000 	mov	r3, #0
    993c:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:8 (discriminator 3)
    9940:	e51b3008 	ldr	r3, [fp, #-8]
    9944:	e59f203c 	ldr	r2, [pc, #60]	; 9988 <_ZN13CPage_ManagerC1Ev+0x60>
    9948:	e1530002 	cmp	r3, r2
    994c:	8a000008 	bhi	9974 <_ZN13CPage_ManagerC1Ev+0x4c>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:9 (discriminator 2)
        mPage_Bitmap[i] = 0;
    9950:	e51b2010 	ldr	r2, [fp, #-16]
    9954:	e51b3008 	ldr	r3, [fp, #-8]
    9958:	e0823003 	add	r3, r2, r3
    995c:	e3a02000 	mov	r2, #0
    9960:	e5c32000 	strb	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:8 (discriminator 2)
    for (int i = 0; i < sizeof(mPage_Bitmap); i++)
    9964:	e51b3008 	ldr	r3, [fp, #-8]
    9968:	e2833001 	add	r3, r3, #1
    996c:	e50b3008 	str	r3, [fp, #-8]
    9970:	eafffff2 	b	9940 <_ZN13CPage_ManagerC1Ev+0x18>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:12

    // nutno dodat, ze strankovatelna pamet implicitne nezahrnuje pamet, kam se nahralo jadro
}
    9974:	e51b3010 	ldr	r3, [fp, #-16]
    9978:	e1a00003 	mov	r0, r3
    997c:	e28bd000 	add	sp, fp, #0
    9980:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9984:	e12fff1e 	bx	lr
    9988:	00000ffe 	strdeq	r0, [r0], -lr

0000998c <_ZN13CPage_Manager4MarkEjb>:
_ZN13CPage_Manager4MarkEjb():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:15

void CPage_Manager::Mark(uint32_t page_idx, bool used)
{
    998c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9990:	e28db000 	add	fp, sp, #0
    9994:	e24dd014 	sub	sp, sp, #20
    9998:	e50b0008 	str	r0, [fp, #-8]
    999c:	e50b100c 	str	r1, [fp, #-12]
    99a0:	e1a03002 	mov	r3, r2
    99a4:	e54b300d 	strb	r3, [fp, #-13]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:16
    if (used)
    99a8:	e55b300d 	ldrb	r3, [fp, #-13]
    99ac:	e3530000 	cmp	r3, #0
    99b0:	0a00000f 	beq	99f4 <_ZN13CPage_Manager4MarkEjb+0x68>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:17
        mPage_Bitmap[page_idx / 8] |= 1 << (page_idx % 8);
    99b4:	e51b300c 	ldr	r3, [fp, #-12]
    99b8:	e1a031a3 	lsr	r3, r3, #3
    99bc:	e51b2008 	ldr	r2, [fp, #-8]
    99c0:	e7d22003 	ldrb	r2, [r2, r3]
    99c4:	e6af1072 	sxtb	r1, r2
    99c8:	e51b200c 	ldr	r2, [fp, #-12]
    99cc:	e2022007 	and	r2, r2, #7
    99d0:	e3a00001 	mov	r0, #1
    99d4:	e1a02210 	lsl	r2, r0, r2
    99d8:	e6af2072 	sxtb	r2, r2
    99dc:	e1812002 	orr	r2, r1, r2
    99e0:	e6af2072 	sxtb	r2, r2
    99e4:	e6ef1072 	uxtb	r1, r2
    99e8:	e51b2008 	ldr	r2, [fp, #-8]
    99ec:	e7c21003 	strb	r1, [r2, r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:20
    else
        mPage_Bitmap[page_idx / 8] &= ~(1 << (page_idx % 8));
}
    99f0:	ea000010 	b	9a38 <_ZN13CPage_Manager4MarkEjb+0xac>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:19
        mPage_Bitmap[page_idx / 8] &= ~(1 << (page_idx % 8));
    99f4:	e51b300c 	ldr	r3, [fp, #-12]
    99f8:	e1a031a3 	lsr	r3, r3, #3
    99fc:	e51b2008 	ldr	r2, [fp, #-8]
    9a00:	e7d22003 	ldrb	r2, [r2, r3]
    9a04:	e6af1072 	sxtb	r1, r2
    9a08:	e51b200c 	ldr	r2, [fp, #-12]
    9a0c:	e2022007 	and	r2, r2, #7
    9a10:	e3a00001 	mov	r0, #1
    9a14:	e1a02210 	lsl	r2, r0, r2
    9a18:	e6af2072 	sxtb	r2, r2
    9a1c:	e1e02002 	mvn	r2, r2
    9a20:	e6af2072 	sxtb	r2, r2
    9a24:	e0022001 	and	r2, r2, r1
    9a28:	e6af2072 	sxtb	r2, r2
    9a2c:	e6ef1072 	uxtb	r1, r2
    9a30:	e51b2008 	ldr	r2, [fp, #-8]
    9a34:	e7c21003 	strb	r1, [r2, r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:20
}
    9a38:	e320f000 	nop	{0}
    9a3c:	e28bd000 	add	sp, fp, #0
    9a40:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9a44:	e12fff1e 	bx	lr

00009a48 <_ZN13CPage_Manager10Alloc_PageEv>:
_ZN13CPage_Manager10Alloc_PageEv():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:23

uint32_t CPage_Manager::Alloc_Page()
{
    9a48:	e92d4800 	push	{fp, lr}
    9a4c:	e28db004 	add	fp, sp, #4
    9a50:	e24dd018 	sub	sp, sp, #24
    9a54:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:30
    // to je samozrejme O(n) a pro prakticke pouziti ne uplne dobre, ale k tomuto problemu az jindy

    uint32_t i, j;

    // projdeme vsechny stranky
    for (i = 0; i < mem::PageCount; i++)
    9a58:	e3a03000 	mov	r3, #0
    9a5c:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:30 (discriminator 1)
    9a60:	e51b3008 	ldr	r3, [fp, #-8]
    9a64:	e59f20bc 	ldr	r2, [pc, #188]	; 9b28 <_ZN13CPage_Manager10Alloc_PageEv+0xe0>
    9a68:	e1530002 	cmp	r3, r2
    9a6c:	8a000029 	bhi	9b18 <_ZN13CPage_Manager10Alloc_PageEv+0xd0>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:33
    {
        // je v dane osmici volna nejaka stranka? (0xFF = vse obsazeno)
        if (mPage_Bitmap[i] != 0xFF)
    9a70:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    9a74:	e51b3008 	ldr	r3, [fp, #-8]
    9a78:	e0823003 	add	r3, r2, r3
    9a7c:	e5d33000 	ldrb	r3, [r3]
    9a80:	e35300ff 	cmp	r3, #255	; 0xff
    9a84:	0a00001f 	beq	9b08 <_ZN13CPage_Manager10Alloc_PageEv+0xc0>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:36
        {
            // projdeme vsechny bity a najdeme ten co je volny
            for (j = 0; j < 8; j++)
    9a88:	e3a03000 	mov	r3, #0
    9a8c:	e50b300c 	str	r3, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:36 (discriminator 1)
    9a90:	e51b300c 	ldr	r3, [fp, #-12]
    9a94:	e3530007 	cmp	r3, #7
    9a98:	8a00001a 	bhi	9b08 <_ZN13CPage_Manager10Alloc_PageEv+0xc0>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:38
            {
                if ((mPage_Bitmap[i] & (1 << j)) == 0)
    9a9c:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    9aa0:	e51b3008 	ldr	r3, [fp, #-8]
    9aa4:	e0823003 	add	r3, r2, r3
    9aa8:	e5d33000 	ldrb	r3, [r3]
    9aac:	e1a02003 	mov	r2, r3
    9ab0:	e51b300c 	ldr	r3, [fp, #-12]
    9ab4:	e1a03352 	asr	r3, r2, r3
    9ab8:	e2033001 	and	r3, r3, #1
    9abc:	e3530000 	cmp	r3, #0
    9ac0:	1a00000c 	bne	9af8 <_ZN13CPage_Manager10Alloc_PageEv+0xb0>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:41
                {
                    // oznacime
                    const uint32_t page_idx = i * 8 + j;
    9ac4:	e51b3008 	ldr	r3, [fp, #-8]
    9ac8:	e1a03183 	lsl	r3, r3, #3
    9acc:	e51b200c 	ldr	r2, [fp, #-12]
    9ad0:	e0823003 	add	r3, r2, r3
    9ad4:	e50b3010 	str	r3, [fp, #-16]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:42
                    Mark(page_idx, true);
    9ad8:	e3a02001 	mov	r2, #1
    9adc:	e51b1010 	ldr	r1, [fp, #-16]
    9ae0:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    9ae4:	ebffffa8 	bl	998c <_ZN13CPage_Manager4MarkEjb>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:43
                    return mem::LowMemory + page_idx * mem::PageSize;
    9ae8:	e51b3010 	ldr	r3, [fp, #-16]
    9aec:	e2833008 	add	r3, r3, #8
    9af0:	e1a03703 	lsl	r3, r3, #14
    9af4:	ea000008 	b	9b1c <_ZN13CPage_Manager10Alloc_PageEv+0xd4>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:36 (discriminator 2)
            for (j = 0; j < 8; j++)
    9af8:	e51b300c 	ldr	r3, [fp, #-12]
    9afc:	e2833001 	add	r3, r3, #1
    9b00:	e50b300c 	str	r3, [fp, #-12]
    9b04:	eaffffe1 	b	9a90 <_ZN13CPage_Manager10Alloc_PageEv+0x48>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:30 (discriminator 2)
    for (i = 0; i < mem::PageCount; i++)
    9b08:	e51b3008 	ldr	r3, [fp, #-8]
    9b0c:	e2833001 	add	r3, r3, #1
    9b10:	e50b3008 	str	r3, [fp, #-8]
    9b14:	eaffffd1 	b	9a60 <_ZN13CPage_Manager10Alloc_PageEv+0x18>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:49
                }
            }
        }
    }

    return 0;
    9b18:	e3a03000 	mov	r3, #0
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:50
}
    9b1c:	e1a00003 	mov	r0, r3
    9b20:	e24bd004 	sub	sp, fp, #4
    9b24:	e8bd8800 	pop	{fp, pc}
    9b28:	00007ff7 	strdeq	r7, [r0], -r7	; <UNPREDICTABLE>

00009b2c <_ZN13CPage_Manager9Free_PageEj>:
_ZN13CPage_Manager9Free_PageEj():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:53

void CPage_Manager::Free_Page(uint32_t fa)
{
    9b2c:	e92d4800 	push	{fp, lr}
    9b30:	e28db004 	add	fp, sp, #4
    9b34:	e24dd008 	sub	sp, sp, #8
    9b38:	e50b0008 	str	r0, [fp, #-8]
    9b3c:	e50b100c 	str	r1, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:56
    // pro vyssi bezpecnost v nejakych safe systemech lze tady data stranky premazavat napr. nulami po dealokaci

    Mark(fa / mem::PageSize, false);
    9b40:	e51b300c 	ldr	r3, [fp, #-12]
    9b44:	e1a03723 	lsr	r3, r3, #14
    9b48:	e3a02000 	mov	r2, #0
    9b4c:	e1a01003 	mov	r1, r3
    9b50:	e51b0008 	ldr	r0, [fp, #-8]
    9b54:	ebffff8c 	bl	998c <_ZN13CPage_Manager4MarkEjb>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:57
}
    9b58:	e320f000 	nop	{0}
    9b5c:	e24bd004 	sub	sp, fp, #4
    9b60:	e8bd8800 	pop	{fp, pc}

00009b64 <_Z41__static_initialization_and_destruction_0ii>:
_Z41__static_initialization_and_destruction_0ii():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:57
    9b64:	e92d4800 	push	{fp, lr}
    9b68:	e28db004 	add	fp, sp, #4
    9b6c:	e24dd008 	sub	sp, sp, #8
    9b70:	e50b0008 	str	r0, [fp, #-8]
    9b74:	e50b100c 	str	r1, [fp, #-12]
    9b78:	e51b3008 	ldr	r3, [fp, #-8]
    9b7c:	e3530001 	cmp	r3, #1
    9b80:	1a000005 	bne	9b9c <_Z41__static_initialization_and_destruction_0ii+0x38>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:57 (discriminator 1)
    9b84:	e51b300c 	ldr	r3, [fp, #-12]
    9b88:	e59f2018 	ldr	r2, [pc, #24]	; 9ba8 <_Z41__static_initialization_and_destruction_0ii+0x44>
    9b8c:	e1530002 	cmp	r3, r2
    9b90:	1a000001 	bne	9b9c <_Z41__static_initialization_and_destruction_0ii+0x38>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:3
CPage_Manager sPage_Manager;
    9b94:	e59f0010 	ldr	r0, [pc, #16]	; 9bac <_Z41__static_initialization_and_destruction_0ii+0x48>
    9b98:	ebffff62 	bl	9928 <_ZN13CPage_ManagerC1Ev>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:57
}
    9b9c:	e320f000 	nop	{0}
    9ba0:	e24bd004 	sub	sp, fp, #4
    9ba4:	e8bd8800 	pop	{fp, pc}
    9ba8:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>
    9bac:	0000ab54 	andeq	sl, r0, r4, asr fp

00009bb0 <_GLOBAL__sub_I_sPage_Manager>:
_GLOBAL__sub_I_sPage_Manager():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/memory/pages.cpp:57
    9bb0:	e92d4800 	push	{fp, lr}
    9bb4:	e28db004 	add	fp, sp, #4
    9bb8:	e59f1008 	ldr	r1, [pc, #8]	; 9bc8 <_GLOBAL__sub_I_sPage_Manager+0x18>
    9bbc:	e3a00001 	mov	r0, #1
    9bc0:	ebffffe7 	bl	9b64 <_Z41__static_initialization_and_destruction_0ii>
    9bc4:	e8bd8800 	pop	{fp, pc}
    9bc8:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>

00009bcc <_ZN16CProcess_ManagerC1Ev>:
_ZN16CProcess_ManagerC2Ev():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:17
void context_switch_first(TCPU_Context* ctx_to, TCPU_Context* ctx_from);
};

CProcess_Manager sProcessMgr;

CProcess_Manager::CProcess_Manager()
    9bcc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9bd0:	e28db000 	add	fp, sp, #0
    9bd4:	e24dd00c 	sub	sp, sp, #12
    9bd8:	e50b0008 	str	r0, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:20
: mLast_PID(0)
, mProcess_List_Head(nullptr)
, mCurrent_Task_Node(nullptr)
    9bdc:	e51b3008 	ldr	r3, [fp, #-8]
    9be0:	e3a02000 	mov	r2, #0
    9be4:	e5832000 	str	r2, [r3]
    9be8:	e51b3008 	ldr	r3, [fp, #-8]
    9bec:	e3a02000 	mov	r2, #0
    9bf0:	e5832004 	str	r2, [r3, #4]
    9bf4:	e51b3008 	ldr	r3, [fp, #-8]
    9bf8:	e3a02000 	mov	r2, #0
    9bfc:	e5832008 	str	r2, [r3, #8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:23
{
    //
}
    9c00:	e51b3008 	ldr	r3, [fp, #-8]
    9c04:	e1a00003 	mov	r0, r3
    9c08:	e28bd000 	add	sp, fp, #0
    9c0c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9c10:	e12fff1e 	bx	lr

00009c14 <_ZNK16CProcess_Manager19Get_Current_ProcessEv>:
_ZNK16CProcess_Manager19Get_Current_ProcessEv():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:26

TTask_Struct* CProcess_Manager::Get_Current_Process() const
{
    9c14:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9c18:	e28db000 	add	fp, sp, #0
    9c1c:	e24dd00c 	sub	sp, sp, #12
    9c20:	e50b0008 	str	r0, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:27
    return mCurrent_Task_Node ? mCurrent_Task_Node->task : nullptr;
    9c24:	e51b3008 	ldr	r3, [fp, #-8]
    9c28:	e5933008 	ldr	r3, [r3, #8]
    9c2c:	e3530000 	cmp	r3, #0
    9c30:	0a000003 	beq	9c44 <_ZNK16CProcess_Manager19Get_Current_ProcessEv+0x30>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:27 (discriminator 1)
    9c34:	e51b3008 	ldr	r3, [fp, #-8]
    9c38:	e5933008 	ldr	r3, [r3, #8]
    9c3c:	e5933008 	ldr	r3, [r3, #8]
    9c40:	ea000000 	b	9c48 <_ZNK16CProcess_Manager19Get_Current_ProcessEv+0x34>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:27 (discriminator 2)
    9c44:	e3a03000 	mov	r3, #0
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:28 (discriminator 5)
}
    9c48:	e1a00003 	mov	r0, r3
    9c4c:	e28bd000 	add	sp, fp, #0
    9c50:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9c54:	e12fff1e 	bx	lr

00009c58 <_ZN16CProcess_Manager19Create_Main_ProcessEv>:
_ZN16CProcess_Manager19Create_Main_ProcessEv():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:31

void CProcess_Manager::Create_Main_Process()
{
    9c58:	e92d4800 	push	{fp, lr}
    9c5c:	e28db004 	add	fp, sp, #4
    9c60:	e24dd010 	sub	sp, sp, #16
    9c64:	e50b0010 	str	r0, [fp, #-16]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:32
    CProcess_List_Node* procnode = sKernelMem.Alloc<CProcess_List_Node>();
    9c68:	e59f00dc 	ldr	r0, [pc, #220]	; 9d4c <_ZN16CProcess_Manager19Create_Main_ProcessEv+0xf4>
    9c6c:	eb00015d 	bl	a1e8 <_ZN20CKernel_Heap_Manager5AllocI18CProcess_List_NodeEEPT_v>
    9c70:	e1a03000 	mov	r3, r0
    9c74:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:34

    procnode->next = mProcess_List_Head;
    9c78:	e51b3010 	ldr	r3, [fp, #-16]
    9c7c:	e5932004 	ldr	r2, [r3, #4]
    9c80:	e51b3008 	ldr	r3, [fp, #-8]
    9c84:	e5832004 	str	r2, [r3, #4]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:35
    procnode->prev = nullptr;
    9c88:	e51b3008 	ldr	r3, [fp, #-8]
    9c8c:	e3a02000 	mov	r2, #0
    9c90:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:36
    if (mProcess_List_Head != nullptr)
    9c94:	e51b3010 	ldr	r3, [fp, #-16]
    9c98:	e5933004 	ldr	r3, [r3, #4]
    9c9c:	e3530000 	cmp	r3, #0
    9ca0:	0a000004 	beq	9cb8 <_ZN16CProcess_Manager19Create_Main_ProcessEv+0x60>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:38
    {
        mProcess_List_Head->prev = procnode;
    9ca4:	e51b3010 	ldr	r3, [fp, #-16]
    9ca8:	e5933004 	ldr	r3, [r3, #4]
    9cac:	e51b2008 	ldr	r2, [fp, #-8]
    9cb0:	e5832000 	str	r2, [r3]
    9cb4:	ea000002 	b	9cc4 <_ZN16CProcess_Manager19Create_Main_ProcessEv+0x6c>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:42
    }
    else
    {
        mProcess_List_Head = procnode;
    9cb8:	e51b3010 	ldr	r3, [fp, #-16]
    9cbc:	e51b2008 	ldr	r2, [fp, #-8]
    9cc0:	e5832004 	str	r2, [r3, #4]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:45
    }

    procnode->task = sKernelMem.Alloc<TTask_Struct>();
    9cc4:	e59f0080 	ldr	r0, [pc, #128]	; 9d4c <_ZN16CProcess_Manager19Create_Main_ProcessEv+0xf4>
    9cc8:	eb000151 	bl	a214 <_ZN20CKernel_Heap_Manager5AllocI12TTask_StructEEPT_v>
    9ccc:	e1a02000 	mov	r2, r0
    9cd0:	e51b3008 	ldr	r3, [fp, #-8]
    9cd4:	e5832008 	str	r2, [r3, #8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:47

    auto* task = procnode->task;
    9cd8:	e51b3008 	ldr	r3, [fp, #-8]
    9cdc:	e5933008 	ldr	r3, [r3, #8]
    9ce0:	e50b300c 	str	r3, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:49

    task->pid = ++mLast_PID;
    9ce4:	e51b3010 	ldr	r3, [fp, #-16]
    9ce8:	e5933000 	ldr	r3, [r3]
    9cec:	e2832001 	add	r2, r3, #1
    9cf0:	e51b3010 	ldr	r3, [fp, #-16]
    9cf4:	e5832000 	str	r2, [r3]
    9cf8:	e51b3010 	ldr	r3, [fp, #-16]
    9cfc:	e5932000 	ldr	r2, [r3]
    9d00:	e51b300c 	ldr	r3, [fp, #-12]
    9d04:	e583200c 	str	r2, [r3, #12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:50
    task->sched_static_priority = 5; // TODO: pro ted je to jen hardcoded hodnota, do budoucna urcite bude nutne dovolit specifikovat
    9d08:	e51b300c 	ldr	r3, [fp, #-12]
    9d0c:	e3a02005 	mov	r2, #5
    9d10:	e5832018 	str	r2, [r3, #24]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:51
    task->sched_counter = task->sched_static_priority;
    9d14:	e51b300c 	ldr	r3, [fp, #-12]
    9d18:	e5932018 	ldr	r2, [r3, #24]
    9d1c:	e51b300c 	ldr	r3, [fp, #-12]
    9d20:	e5832014 	str	r2, [r3, #20]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:52
    task->state = NTask_State::Running;
    9d24:	e51b300c 	ldr	r3, [fp, #-12]
    9d28:	e3a02002 	mov	r2, #2
    9d2c:	e5832010 	str	r2, [r3, #16]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:54

    mCurrent_Task_Node = mProcess_List_Head;
    9d30:	e51b3010 	ldr	r3, [fp, #-16]
    9d34:	e5932004 	ldr	r2, [r3, #4]
    9d38:	e51b3010 	ldr	r3, [fp, #-16]
    9d3c:	e5832008 	str	r2, [r3, #8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:55
}
    9d40:	e320f000 	nop	{0}
    9d44:	e24bd004 	sub	sp, fp, #4
    9d48:	e8bd8800 	pop	{fp, pc}
    9d4c:	0000ab50 	andeq	sl, r0, r0, asr fp

00009d50 <_ZN16CProcess_Manager14Create_ProcessEm>:
_ZN16CProcess_Manager14Create_ProcessEm():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:58

uint32_t CProcess_Manager::Create_Process(unsigned long funcptr)
{
    9d50:	e92d4800 	push	{fp, lr}
    9d54:	e28db004 	add	fp, sp, #4
    9d58:	e24dd010 	sub	sp, sp, #16
    9d5c:	e50b0010 	str	r0, [fp, #-16]
    9d60:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:59
    CProcess_List_Node* procnode = sKernelMem.Alloc<CProcess_List_Node>();
    9d64:	e59f0188 	ldr	r0, [pc, #392]	; 9ef4 <_ZN16CProcess_Manager14Create_ProcessEm+0x1a4>
    9d68:	eb00011e 	bl	a1e8 <_ZN20CKernel_Heap_Manager5AllocI18CProcess_List_NodeEEPT_v>
    9d6c:	e1a03000 	mov	r3, r0
    9d70:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:61

    procnode->next = mProcess_List_Head;
    9d74:	e51b3010 	ldr	r3, [fp, #-16]
    9d78:	e5932004 	ldr	r2, [r3, #4]
    9d7c:	e51b3008 	ldr	r3, [fp, #-8]
    9d80:	e5832004 	str	r2, [r3, #4]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:62
    procnode->prev = nullptr;
    9d84:	e51b3008 	ldr	r3, [fp, #-8]
    9d88:	e3a02000 	mov	r2, #0
    9d8c:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:63
    mProcess_List_Head->prev = procnode;
    9d90:	e51b3010 	ldr	r3, [fp, #-16]
    9d94:	e5933004 	ldr	r3, [r3, #4]
    9d98:	e51b2008 	ldr	r2, [fp, #-8]
    9d9c:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:64
    mProcess_List_Head = procnode;
    9da0:	e51b3010 	ldr	r3, [fp, #-16]
    9da4:	e51b2008 	ldr	r2, [fp, #-8]
    9da8:	e5832004 	str	r2, [r3, #4]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:66

    if (mCurrent_Task_Node == nullptr)
    9dac:	e51b3010 	ldr	r3, [fp, #-16]
    9db0:	e5933008 	ldr	r3, [r3, #8]
    9db4:	e3530000 	cmp	r3, #0
    9db8:	1a000002 	bne	9dc8 <_ZN16CProcess_Manager14Create_ProcessEm+0x78>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:68
    {
        mCurrent_Task_Node = procnode;
    9dbc:	e51b3010 	ldr	r3, [fp, #-16]
    9dc0:	e51b2008 	ldr	r2, [fp, #-8]
    9dc4:	e5832008 	str	r2, [r3, #8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:71
    }

    procnode->task = sKernelMem.Alloc<TTask_Struct>();
    9dc8:	e59f0124 	ldr	r0, [pc, #292]	; 9ef4 <_ZN16CProcess_Manager14Create_ProcessEm+0x1a4>
    9dcc:	eb000110 	bl	a214 <_ZN20CKernel_Heap_Manager5AllocI12TTask_StructEEPT_v>
    9dd0:	e1a02000 	mov	r2, r0
    9dd4:	e51b3008 	ldr	r3, [fp, #-8]
    9dd8:	e5832008 	str	r2, [r3, #8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:73

    auto* task = procnode->task;
    9ddc:	e51b3008 	ldr	r3, [fp, #-8]
    9de0:	e5933008 	ldr	r3, [r3, #8]
    9de4:	e50b300c 	str	r3, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:75

    task->pid = ++mLast_PID;
    9de8:	e51b3010 	ldr	r3, [fp, #-16]
    9dec:	e5933000 	ldr	r3, [r3]
    9df0:	e2832001 	add	r2, r3, #1
    9df4:	e51b3010 	ldr	r3, [fp, #-16]
    9df8:	e5832000 	str	r2, [r3]
    9dfc:	e51b3010 	ldr	r3, [fp, #-16]
    9e00:	e5932000 	ldr	r2, [r3]
    9e04:	e51b300c 	ldr	r3, [fp, #-12]
    9e08:	e583200c 	str	r2, [r3, #12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:76
    task->sched_static_priority = 5; // TODO: pro ted je to jen hardcoded hodnota, do budoucna urcite bude nutne dovolit specifikovat
    9e0c:	e51b300c 	ldr	r3, [fp, #-12]
    9e10:	e3a02005 	mov	r2, #5
    9e14:	e5832018 	str	r2, [r3, #24]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:77
    task->sched_counter = task->sched_static_priority;
    9e18:	e51b300c 	ldr	r3, [fp, #-12]
    9e1c:	e5932018 	ldr	r2, [r3, #24]
    9e20:	e51b300c 	ldr	r3, [fp, #-12]
    9e24:	e5832014 	str	r2, [r3, #20]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:78
    task->state = NTask_State::New;
    9e28:	e51b300c 	ldr	r3, [fp, #-12]
    9e2c:	e3a02000 	mov	r2, #0
    9e30:	e5832010 	str	r2, [r3, #16]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:80

    task->cpu_context.lr = funcptr;
    9e34:	e51b300c 	ldr	r3, [fp, #-12]
    9e38:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    9e3c:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:81
    task->cpu_context.pc = reinterpret_cast<unsigned long>(&process_bootstrap);
    9e40:	e59f20b0 	ldr	r2, [pc, #176]	; 9ef8 <_ZN16CProcess_Manager14Create_ProcessEm+0x1a8>
    9e44:	e51b300c 	ldr	r3, [fp, #-12]
    9e48:	e5832008 	str	r2, [r3, #8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:82
    task->cpu_context.sp = static_cast<unsigned long>(sPage_Manager.Alloc_Page()) + mem::PageSize;
    9e4c:	e59f00a8 	ldr	r0, [pc, #168]	; 9efc <_ZN16CProcess_Manager14Create_ProcessEm+0x1ac>
    9e50:	ebfffefc 	bl	9a48 <_ZN13CPage_Manager10Alloc_PageEv>
    9e54:	e1a03000 	mov	r3, r0
    9e58:	e2832901 	add	r2, r3, #16384	; 0x4000
    9e5c:	e51b300c 	ldr	r3, [fp, #-12]
    9e60:	e5832004 	str	r2, [r3, #4]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:84

    sMonitor << "Created process with pid " << (unsigned int)task->pid << " ("
    9e64:	e59f1094 	ldr	r1, [pc, #148]	; 9f00 <_ZN16CProcess_Manager14Create_ProcessEm+0x1b0>
    9e68:	e59f0094 	ldr	r0, [pc, #148]	; 9f04 <_ZN16CProcess_Manager14Create_ProcessEm+0x1b4>
    9e6c:	ebffface 	bl	89ac <_ZN8CMonitorlsEPKc>
    9e70:	e1a02000 	mov	r2, r0
    9e74:	e51b300c 	ldr	r3, [fp, #-12]
    9e78:	e593300c 	ldr	r3, [r3, #12]
    9e7c:	e1a01003 	mov	r1, r3
    9e80:	e1a00002 	mov	r0, r2
    9e84:	ebfffaf3 	bl	8a58 <_ZN8CMonitorlsEj>
    9e88:	e1a03000 	mov	r3, r0
    9e8c:	e59f1074 	ldr	r1, [pc, #116]	; 9f08 <_ZN16CProcess_Manager14Create_ProcessEm+0x1b8>
    9e90:	e1a00003 	mov	r0, r3
    9e94:	ebfffac4 	bl	89ac <_ZN8CMonitorlsEPKc>
    9e98:	e1a03000 	mov	r3, r0
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:85
             << "SP = 0x" << CMonitor::NNumber_Base::HEX << (unsigned int)task->cpu_context.sp << ")\n";
    9e9c:	e59f1068 	ldr	r1, [pc, #104]	; 9f0c <_ZN16CProcess_Manager14Create_ProcessEm+0x1bc>
    9ea0:	e1a00003 	mov	r0, r3
    9ea4:	ebfffac0 	bl	89ac <_ZN8CMonitorlsEPKc>
    9ea8:	e1a03000 	mov	r3, r0
    9eac:	e3a01010 	mov	r1, #16
    9eb0:	e1a00003 	mov	r0, r3
    9eb4:	ebfffada 	bl	8a24 <_ZN8CMonitorlsENS_12NNumber_BaseE>
    9eb8:	e1a02000 	mov	r2, r0
    9ebc:	e51b300c 	ldr	r3, [fp, #-12]
    9ec0:	e5933004 	ldr	r3, [r3, #4]
    9ec4:	e1a01003 	mov	r1, r3
    9ec8:	e1a00002 	mov	r0, r2
    9ecc:	ebfffae1 	bl	8a58 <_ZN8CMonitorlsEj>
    9ed0:	e1a03000 	mov	r3, r0
    9ed4:	e59f1034 	ldr	r1, [pc, #52]	; 9f10 <_ZN16CProcess_Manager14Create_ProcessEm+0x1c0>
    9ed8:	e1a00003 	mov	r0, r3
    9edc:	ebfffab2 	bl	89ac <_ZN8CMonitorlsEPKc>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:87

    return task->pid;
    9ee0:	e51b300c 	ldr	r3, [fp, #-12]
    9ee4:	e593300c 	ldr	r3, [r3, #12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:88
}
    9ee8:	e1a00003 	mov	r0, r3
    9eec:	e24bd004 	sub	sp, fp, #4
    9ef0:	e8bd8800 	pop	{fp, pc}
    9ef4:	0000ab50 	andeq	sl, r0, r0, asr fp
    9ef8:	0000a240 	andeq	sl, r0, r0, asr #4
    9efc:	0000ab54 	andeq	sl, r0, r4, asr fp
    9f00:	0000aa88 	andeq	sl, r0, r8, lsl #21
    9f04:	0000ab18 	andeq	sl, r0, r8, lsl fp
    9f08:	0000aaa4 	andeq	sl, r0, r4, lsr #21
    9f0c:	0000aaa8 	andeq	sl, r0, r8, lsr #21
    9f10:	0000aab0 			; <UNDEFINED> instruction: 0x0000aab0

00009f14 <_ZN16CProcess_Manager8ScheduleEv>:
_ZN16CProcess_Manager8ScheduleEv():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:91

void CProcess_Manager::Schedule()
{
    9f14:	e92d4800 	push	{fp, lr}
    9f18:	e28db004 	add	fp, sp, #4
    9f1c:	e24dd010 	sub	sp, sp, #16
    9f20:	e50b0010 	str	r0, [fp, #-16]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:93
    // je nejaky proces naplanovany?
    if (mCurrent_Task_Node)
    9f24:	e51b3010 	ldr	r3, [fp, #-16]
    9f28:	e5933008 	ldr	r3, [r3, #8]
    9f2c:	e3530000 	cmp	r3, #0
    9f30:	0a000011 	beq	9f7c <_ZN16CProcess_Manager8ScheduleEv+0x68>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:96
    {
        // snizime citac planovace
        mCurrent_Task_Node->task->sched_counter--;
    9f34:	e51b3010 	ldr	r3, [fp, #-16]
    9f38:	e5933008 	ldr	r3, [r3, #8]
    9f3c:	e5933008 	ldr	r3, [r3, #8]
    9f40:	e5932014 	ldr	r2, [r3, #20]
    9f44:	e2422001 	sub	r2, r2, #1
    9f48:	e5832014 	str	r2, [r3, #20]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:98
        // pokud je citac vetsi nez 0, zatim nebudeme preplanovavat (a zaroven je proces stale ve stavu Running - nezablokoval se nad necim)
        if (mCurrent_Task_Node->task->sched_counter > 0 && mCurrent_Task_Node->task->state == NTask_State::Running)
    9f4c:	e51b3010 	ldr	r3, [fp, #-16]
    9f50:	e5933008 	ldr	r3, [r3, #8]
    9f54:	e5933008 	ldr	r3, [r3, #8]
    9f58:	e5933014 	ldr	r3, [r3, #20]
    9f5c:	e3530000 	cmp	r3, #0
    9f60:	0a000005 	beq	9f7c <_ZN16CProcess_Manager8ScheduleEv+0x68>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:98 (discriminator 1)
    9f64:	e51b3010 	ldr	r3, [fp, #-16]
    9f68:	e5933008 	ldr	r3, [r3, #8]
    9f6c:	e5933008 	ldr	r3, [r3, #8]
    9f70:	e5933010 	ldr	r3, [r3, #16]
    9f74:	e3530002 	cmp	r3, #2
    9f78:	0a00003c 	beq	a070 <_ZN16CProcess_Manager8ScheduleEv+0x15c>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:105
    }

    // najdeme dalsi proces na planovani

    // vybereme dalsi proces v rade
    CProcess_List_Node* next = mCurrent_Task_Node ? mCurrent_Task_Node->next : mProcess_List_Head;
    9f7c:	e51b3010 	ldr	r3, [fp, #-16]
    9f80:	e5933008 	ldr	r3, [r3, #8]
    9f84:	e3530000 	cmp	r3, #0
    9f88:	0a000003 	beq	9f9c <_ZN16CProcess_Manager8ScheduleEv+0x88>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:105 (discriminator 1)
    9f8c:	e51b3010 	ldr	r3, [fp, #-16]
    9f90:	e5933008 	ldr	r3, [r3, #8]
    9f94:	e5933004 	ldr	r3, [r3, #4]
    9f98:	ea000001 	b	9fa4 <_ZN16CProcess_Manager8ScheduleEv+0x90>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:105 (discriminator 2)
    9f9c:	e51b3010 	ldr	r3, [fp, #-16]
    9fa0:	e5933004 	ldr	r3, [r3, #4]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:105 (discriminator 4)
    9fa4:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:106 (discriminator 4)
    if (!next)
    9fa8:	e51b3008 	ldr	r3, [fp, #-8]
    9fac:	e3530000 	cmp	r3, #0
    9fb0:	1a000002 	bne	9fc0 <_ZN16CProcess_Manager8ScheduleEv+0xac>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:107
        next = mProcess_List_Head;
    9fb4:	e51b3010 	ldr	r3, [fp, #-16]
    9fb8:	e5933004 	ldr	r3, [r3, #4]
    9fbc:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:111

    // proces k naplanovani musi bud byt ve stavu runnable (jiz nekdy bezel a muze bezet znovu) nebo running (pak jde o stavajici proces)
    // a nebo new (novy proces, ktery jeste nebyl planovany)
    while (next->task->state != NTask_State::Runnable && next->task->state != NTask_State::Running && next->task->state != NTask_State::New)
    9fc0:	e51b3008 	ldr	r3, [fp, #-8]
    9fc4:	e5933008 	ldr	r3, [r3, #8]
    9fc8:	e5933010 	ldr	r3, [r3, #16]
    9fcc:	e3530001 	cmp	r3, #1
    9fd0:	0a000014 	beq	a028 <_ZN16CProcess_Manager8ScheduleEv+0x114>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:111 (discriminator 1)
    9fd4:	e51b3008 	ldr	r3, [fp, #-8]
    9fd8:	e5933008 	ldr	r3, [r3, #8]
    9fdc:	e5933010 	ldr	r3, [r3, #16]
    9fe0:	e3530002 	cmp	r3, #2
    9fe4:	0a00000f 	beq	a028 <_ZN16CProcess_Manager8ScheduleEv+0x114>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:111 (discriminator 2)
    9fe8:	e51b3008 	ldr	r3, [fp, #-8]
    9fec:	e5933008 	ldr	r3, [r3, #8]
    9ff0:	e5933010 	ldr	r3, [r3, #16]
    9ff4:	e3530000 	cmp	r3, #0
    9ff8:	0a00000a 	beq	a028 <_ZN16CProcess_Manager8ScheduleEv+0x114>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:113
    {
        if (!next)
    9ffc:	e51b3008 	ldr	r3, [fp, #-8]
    a000:	e3530000 	cmp	r3, #0
    a004:	1a000003 	bne	a018 <_ZN16CProcess_Manager8ScheduleEv+0x104>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:115
        {
            next = mCurrent_Task_Node;
    a008:	e51b3010 	ldr	r3, [fp, #-16]
    a00c:	e5933008 	ldr	r3, [r3, #8]
    a010:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:116
            break;
    a014:	ea000003 	b	a028 <_ZN16CProcess_Manager8ScheduleEv+0x114>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:119
        }
        else
            next = next->next;
    a018:	e51b3008 	ldr	r3, [fp, #-8]
    a01c:	e5933004 	ldr	r3, [r3, #4]
    a020:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:111
    while (next->task->state != NTask_State::Runnable && next->task->state != NTask_State::Running && next->task->state != NTask_State::New)
    a024:	eaffffe5 	b	9fc0 <_ZN16CProcess_Manager8ScheduleEv+0xac>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:123
    }

    // stavajici proces je jediny planovatelny - nemusime nic preplanovavat
    if (next == mCurrent_Task_Node)
    a028:	e51b3010 	ldr	r3, [fp, #-16]
    a02c:	e5933008 	ldr	r3, [r3, #8]
    a030:	e51b2008 	ldr	r2, [fp, #-8]
    a034:	e1520003 	cmp	r2, r3
    a038:	1a000008 	bne	a060 <_ZN16CProcess_Manager8ScheduleEv+0x14c>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:126
    {
        // nastavime mu zase zpatky jeho pridel casovych kvant a vracime se
        mCurrent_Task_Node->task->sched_counter = mCurrent_Task_Node->task->sched_static_priority;
    a03c:	e51b3010 	ldr	r3, [fp, #-16]
    a040:	e5933008 	ldr	r3, [r3, #8]
    a044:	e5932008 	ldr	r2, [r3, #8]
    a048:	e51b3010 	ldr	r3, [fp, #-16]
    a04c:	e5933008 	ldr	r3, [r3, #8]
    a050:	e5933008 	ldr	r3, [r3, #8]
    a054:	e5922018 	ldr	r2, [r2, #24]
    a058:	e5832014 	str	r2, [r3, #20]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:127
        return;
    a05c:	ea000004 	b	a074 <_ZN16CProcess_Manager8ScheduleEv+0x160>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:131
    }

    // sMonitor << "Next = " << mCurrent_Task_Node->task->pid << '\n';
    Switch_To(next);
    a060:	e51b1008 	ldr	r1, [fp, #-8]
    a064:	e51b0010 	ldr	r0, [fp, #-16]
    a068:	eb000003 	bl	a07c <_ZN16CProcess_Manager9Switch_ToEP18CProcess_List_Node>
    a06c:	ea000000 	b	a074 <_ZN16CProcess_Manager8ScheduleEv+0x160>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:99
            return;
    a070:	e320f000 	nop	{0}
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:132
}
    a074:	e24bd004 	sub	sp, fp, #4
    a078:	e8bd8800 	pop	{fp, pc}

0000a07c <_ZN16CProcess_Manager9Switch_ToEP18CProcess_List_Node>:
_ZN16CProcess_Manager9Switch_ToEP18CProcess_List_Node():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:135

void CProcess_Manager::Switch_To(CProcess_List_Node* node)
{
    a07c:	e92d4800 	push	{fp, lr}
    a080:	e28db004 	add	fp, sp, #4
    a084:	e24dd010 	sub	sp, sp, #16
    a088:	e50b0010 	str	r0, [fp, #-16]
    a08c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:138
    // pokud je stavajici proces ve stavu Running (muze teoreticky byt jeste Blocked), vratime ho do stavu Runnable
    // Blocked prehazovat nebudeme ze zjevnych duvodu
    if (mCurrent_Task_Node->task->state == NTask_State::Running)
    a090:	e51b3010 	ldr	r3, [fp, #-16]
    a094:	e5933008 	ldr	r3, [r3, #8]
    a098:	e5933008 	ldr	r3, [r3, #8]
    a09c:	e5933010 	ldr	r3, [r3, #16]
    a0a0:	e3530002 	cmp	r3, #2
    a0a4:	1a000004 	bne	a0bc <_ZN16CProcess_Manager9Switch_ToEP18CProcess_List_Node+0x40>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:139
        mCurrent_Task_Node->task->state = NTask_State::Runnable;
    a0a8:	e51b3010 	ldr	r3, [fp, #-16]
    a0ac:	e5933008 	ldr	r3, [r3, #8]
    a0b0:	e5933008 	ldr	r3, [r3, #8]
    a0b4:	e3a02001 	mov	r2, #1
    a0b8:	e5832010 	str	r2, [r3, #16]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:142

    // projistotu vynulujeme prideleny pocet casovych kvant
    mCurrent_Task_Node->task->sched_counter = 0;
    a0bc:	e51b3010 	ldr	r3, [fp, #-16]
    a0c0:	e5933008 	ldr	r3, [r3, #8]
    a0c4:	e5933008 	ldr	r3, [r3, #8]
    a0c8:	e3a02000 	mov	r2, #0
    a0cc:	e5832014 	str	r2, [r3, #20]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:144

    TCPU_Context* old = &mCurrent_Task_Node->task->cpu_context;
    a0d0:	e51b3010 	ldr	r3, [fp, #-16]
    a0d4:	e5933008 	ldr	r3, [r3, #8]
    a0d8:	e5933008 	ldr	r3, [r3, #8]
    a0dc:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:145
    bool is_first_time = (node->task->state == NTask_State::New);
    a0e0:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    a0e4:	e5933008 	ldr	r3, [r3, #8]
    a0e8:	e5933010 	ldr	r3, [r3, #16]
    a0ec:	e3530000 	cmp	r3, #0
    a0f0:	03a03001 	moveq	r3, #1
    a0f4:	13a03000 	movne	r3, #0
    a0f8:	e54b3009 	strb	r3, [fp, #-9]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:148

    // prehodime na novy proces, pridelime casova kvanta a nastavime proces do stavu Running
    mCurrent_Task_Node = node;
    a0fc:	e51b3010 	ldr	r3, [fp, #-16]
    a100:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    a104:	e5832008 	str	r2, [r3, #8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:149
    mCurrent_Task_Node->task->sched_counter = mCurrent_Task_Node->task->sched_static_priority;
    a108:	e51b3010 	ldr	r3, [fp, #-16]
    a10c:	e5933008 	ldr	r3, [r3, #8]
    a110:	e5932008 	ldr	r2, [r3, #8]
    a114:	e51b3010 	ldr	r3, [fp, #-16]
    a118:	e5933008 	ldr	r3, [r3, #8]
    a11c:	e5933008 	ldr	r3, [r3, #8]
    a120:	e5922018 	ldr	r2, [r2, #24]
    a124:	e5832014 	str	r2, [r3, #20]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:150
    mCurrent_Task_Node->task->state = NTask_State::Running;
    a128:	e51b3010 	ldr	r3, [fp, #-16]
    a12c:	e5933008 	ldr	r3, [r3, #8]
    a130:	e5933008 	ldr	r3, [r3, #8]
    a134:	e3a02002 	mov	r2, #2
    a138:	e5832010 	str	r2, [r3, #16]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:153

    // pokud je to poprve, co je proces planovany, musime to vzit jeste pres malou odbocku ("bootstrap")
    if (is_first_time)
    a13c:	e55b3009 	ldrb	r3, [fp, #-9]
    a140:	e3530000 	cmp	r3, #0
    a144:	0a000005 	beq	a160 <_ZN16CProcess_Manager9Switch_ToEP18CProcess_List_Node+0xe4>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:154
        context_switch_first(&node->task->cpu_context, old);
    a148:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    a14c:	e5933008 	ldr	r3, [r3, #8]
    a150:	e51b1008 	ldr	r1, [fp, #-8]
    a154:	e1a00003 	mov	r0, r3
    a158:	eb000043 	bl	a26c <context_switch_first>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:157
    else
        context_switch(&node->task->cpu_context, old);
}
    a15c:	ea000004 	b	a174 <_ZN16CProcess_Manager9Switch_ToEP18CProcess_List_Node+0xf8>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:156
        context_switch(&node->task->cpu_context, old);
    a160:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    a164:	e5933008 	ldr	r3, [r3, #8]
    a168:	e51b1008 	ldr	r1, [fp, #-8]
    a16c:	e1a00003 	mov	r0, r3
    a170:	eb000034 	bl	a248 <context_switch>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:157
}
    a174:	e320f000 	nop	{0}
    a178:	e24bd004 	sub	sp, fp, #4
    a17c:	e8bd8800 	pop	{fp, pc}

0000a180 <_Z41__static_initialization_and_destruction_0ii>:
_Z41__static_initialization_and_destruction_0ii():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:157
    a180:	e92d4800 	push	{fp, lr}
    a184:	e28db004 	add	fp, sp, #4
    a188:	e24dd008 	sub	sp, sp, #8
    a18c:	e50b0008 	str	r0, [fp, #-8]
    a190:	e50b100c 	str	r1, [fp, #-12]
    a194:	e51b3008 	ldr	r3, [fp, #-8]
    a198:	e3530001 	cmp	r3, #1
    a19c:	1a000005 	bne	a1b8 <_Z41__static_initialization_and_destruction_0ii+0x38>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:157 (discriminator 1)
    a1a0:	e51b300c 	ldr	r3, [fp, #-12]
    a1a4:	e59f2018 	ldr	r2, [pc, #24]	; a1c4 <_Z41__static_initialization_and_destruction_0ii+0x44>
    a1a8:	e1530002 	cmp	r3, r2
    a1ac:	1a000001 	bne	a1b8 <_Z41__static_initialization_and_destruction_0ii+0x38>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:15
CProcess_Manager sProcessMgr;
    a1b0:	e59f0010 	ldr	r0, [pc, #16]	; a1c8 <_Z41__static_initialization_and_destruction_0ii+0x48>
    a1b4:	ebfffe84 	bl	9bcc <_ZN16CProcess_ManagerC1Ev>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:157
}
    a1b8:	e320f000 	nop	{0}
    a1bc:	e24bd004 	sub	sp, fp, #4
    a1c0:	e8bd8800 	pop	{fp, pc}
    a1c4:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>
    a1c8:	0000bb54 	andeq	fp, r0, r4, asr fp

0000a1cc <_GLOBAL__sub_I_sProcessMgr>:
_GLOBAL__sub_I_sProcessMgr():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/process_manager.cpp:157
    a1cc:	e92d4800 	push	{fp, lr}
    a1d0:	e28db004 	add	fp, sp, #4
    a1d4:	e59f1008 	ldr	r1, [pc, #8]	; a1e4 <_GLOBAL__sub_I_sProcessMgr+0x18>
    a1d8:	e3a00001 	mov	r0, #1
    a1dc:	ebffffe7 	bl	a180 <_Z41__static_initialization_and_destruction_0ii>
    a1e0:	e8bd8800 	pop	{fp, pc}
    a1e4:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>

0000a1e8 <_ZN20CKernel_Heap_Manager5AllocI18CProcess_List_NodeEEPT_v>:
_ZN20CKernel_Heap_Manager5AllocI18CProcess_List_NodeEEPT_v():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/include/memory/kernel_heap.h:30

    void* Alloc(uint32_t size);
    void Free(void* mem);

    template<class T>
    T* Alloc()
    a1e8:	e92d4800 	push	{fp, lr}
    a1ec:	e28db004 	add	fp, sp, #4
    a1f0:	e24dd008 	sub	sp, sp, #8
    a1f4:	e50b0008 	str	r0, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/include/memory/kernel_heap.h:32
    {
        return reinterpret_cast<T*>(Alloc(sizeof(T)));
    a1f8:	e3a0100c 	mov	r1, #12
    a1fc:	e51b0008 	ldr	r0, [fp, #-8]
    a200:	ebfffd14 	bl	9658 <_ZN20CKernel_Heap_Manager5AllocEj>
    a204:	e1a03000 	mov	r3, r0
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/include/memory/kernel_heap.h:33
    }
    a208:	e1a00003 	mov	r0, r3
    a20c:	e24bd004 	sub	sp, fp, #4
    a210:	e8bd8800 	pop	{fp, pc}

0000a214 <_ZN20CKernel_Heap_Manager5AllocI12TTask_StructEEPT_v>:
_ZN20CKernel_Heap_Manager5AllocI12TTask_StructEEPT_v():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/include/memory/kernel_heap.h:30
    T* Alloc()
    a214:	e92d4800 	push	{fp, lr}
    a218:	e28db004 	add	fp, sp, #4
    a21c:	e24dd008 	sub	sp, sp, #8
    a220:	e50b0008 	str	r0, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/include/memory/kernel_heap.h:32
        return reinterpret_cast<T*>(Alloc(sizeof(T)));
    a224:	e3a0101c 	mov	r1, #28
    a228:	e51b0008 	ldr	r0, [fp, #-8]
    a22c:	ebfffd09 	bl	9658 <_ZN20CKernel_Heap_Manager5AllocEj>
    a230:	e1a03000 	mov	r3, r0
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/include/memory/kernel_heap.h:33
    }
    a234:	e1a00003 	mov	r0, r3
    a238:	e24bd004 	sub	sp, fp, #4
    a23c:	e8bd8800 	pop	{fp, pc}

0000a240 <process_bootstrap>:
process_bootstrap():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/switch.s:5
.global process_bootstrap
;@ Process bootstrapping - kernelovy "obal" procesu
;@ Vyzaduje na zasobniku pushnutou hodnotu vstupniho bodu procesu
process_bootstrap:
    add lr, pc, #8      ;@ ulozime do lr hodnotu PC+8, abychom se korektne vratili na instrukci po nasledujici
    a240:	e28fe008 	add	lr, pc, #8
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/switch.s:6
    pop {pc}            ;@ vyzvedneme si ulozenou hodnotu cile
    a244:	e49df004 	pop	{pc}		; (ldr pc, [sp], #4)

0000a248 <context_switch>:
context_switch():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/switch.s:14
.global context_switch
;@ Prepnuti procesu ze soucasneho na jiny, ktery jiz byl planovany
;@ r0 - novy proces
;@ r1 - stary proces
context_switch:
	mrs r12, cpsr           ;@ ulozit CPU state do r12
    a248:	e10fc000 	mrs	ip, CPSR
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/switch.s:15
	push {r14}              ;@ push LR
    a24c:	e52de004 	push	{lr}		; (str lr, [sp, #-4]!)
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/switch.s:16
	push {r0}               ;@ push SP
    a250:	e52d0004 	push	{r0}		; (str r0, [sp, #-4]!)
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/switch.s:17
	push {r0-r12}           ;@ push registru
    a254:	e92d1fff 	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, fp, ip}
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/switch.s:18
	str sp, [r1, #4]        ;@ ulozit SP stareho procesu
    a258:	e581d004 	str	sp, [r1, #4]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/switch.s:20

	ldr sp, [r0, #4]        ;@ nacist SP noveho procesu
    a25c:	e590d004 	ldr	sp, [r0, #4]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/switch.s:21
	pop {r0-r12}            ;@ obnovit registry noveho procesu
    a260:	e8bd1fff 	pop	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, fp, ip}
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/switch.s:22
	msr cpsr_c, r12         ;@ obnovit CPU state
    a264:	e121f00c 	msr	CPSR_c, ip
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/switch.s:23
	pop {lr, pc}            ;@ navrat do kontextu provadeni noveho procesu
    a268:	e8bdc000 	pop	{lr, pc}

0000a26c <context_switch_first>:
context_switch_first():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/switch.s:30
.global context_switch_first
;@ Prepnuti procesu ze soucasneho na jiny, ktery jeste nebyl planovany
;@ r0 - novy proces
;@ r1 - stary proces
context_switch_first:
	mrs r12, cpsr           ;@ ulozit CPU state do r12
    a26c:	e10fc000 	mrs	ip, CPSR
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/switch.s:31
	push {r14}              ;@ push LR
    a270:	e52de004 	push	{lr}		; (str lr, [sp, #-4]!)
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/switch.s:32
	push {r13}              ;@ push SP
    a274:	e92d2000 	stmfd	sp!, {sp}
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/switch.s:33
	push {r0-r12}           ;@ push registru
    a278:	e92d1fff 	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, fp, ip}
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/switch.s:34
	str sp, [r1, #4]        ;@ ulozit SP stareho procesu
    a27c:	e581d004 	str	sp, [r1, #4]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/switch.s:36

    ldr r3, [r0, #0]        ;@ "budouci" PC do r3 (entry point procesu)
    a280:	e5903000 	ldr	r3, [r0]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/switch.s:37
    ldr r2, [r0, #8]        ;@ "vstupni" PC do r2 (bootstrap procesu v kernelu)
    a284:	e5902008 	ldr	r2, [r0, #8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/switch.s:38
    ldr sp, [r0, #4]        ;@ nacteme stack pointer procesu
    a288:	e590d004 	ldr	sp, [r0, #4]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/switch.s:39
    push {r3}               ;@ budouci navratova adresa -> do zasobniku, bootstrap si ji tamodsud vyzvedne
    a28c:	e52d3004 	push	{r3}		; (str r3, [sp, #-4]!)
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/switch.s:40
    push {r2}               ;@ pushneme si i bootstrap adresu, abychom ji mohli obnovit do PC
    a290:	e52d2004 	push	{r2}		; (str r2, [sp, #-4]!)
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/switch.s:41
    cpsie i                 ;@ povolime preruseni (v budoucich switchich uz bude flaga ulozena v cpsr/spsr)
    a294:	f1080080 	cpsie	i
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/process/switch.s:42
    pop {pc}                ;@ vybereme ze zasobniku novou hodnotu PC (PC procesu)
    a298:	e49df004 	pop	{pc}		; (ldr pc, [sp], #4)

0000a29c <enable_irq>:
enable_irq():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:102
;@ tady budou ostatni symboly, ktere nevyzaduji zadne specialni misto
.section .text

.global enable_irq
enable_irq:
    mrs r0, cpsr		;@ presun ridiciho registru (CPSR) do general purpose registru (R0)
    a29c:	e10f0000 	mrs	r0, CPSR
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:103
    bic r0, r0, #0x80	;@ vypne bit 7 v registru r0 ("IRQ mask bit")
    a2a0:	e3c00080 	bic	r0, r0, #128	; 0x80
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:104
    msr cpsr_c, r0		;@ nacteme upraveny general purpose (R0) registr do ridiciho (CPSR)
    a2a4:	e121f000 	msr	CPSR_c, r0
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:105
    cpsie i				;@ povoli preruseni
    a2a8:	f1080080 	cpsie	i
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:106
    bx lr
    a2ac:	e12fff1e 	bx	lr

0000a2b0 <disable_irq>:
disable_irq():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:110

.global disable_irq
disable_irq:
    cpsid i
    a2b0:	f10c0080 	cpsid	i
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:111
    bx lr
    a2b4:	e12fff1e 	bx	lr

0000a2b8 <undefined_instruction_handler>:
undefined_instruction_handler():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:114

undefined_instruction_handler:
	b hang
    a2b8:	eafff77a 	b	80a8 <hang>

0000a2bc <irq_handler>:
irq_handler():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:118

.global _internal_irq_handler
irq_handler:
	sub lr, lr, #4
    a2bc:	e24ee004 	sub	lr, lr, #4
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:119
	srsdb #CPSR_MODE_SYS!		;@ ekvivalent k push lr a msr+push spsr
    a2c0:	f96d051f 	srsdb	sp!, #31
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:120
	cpsid if, #CPSR_MODE_SYS	;@ prechod do SYS modu + zakazeme preruseni
    a2c4:	f10e00df 	cpsid	if,#31
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:121
	push {r0-r4, r12, lr}		;@ ulozime callee-saved registry
    a2c8:	e92d501f 	push	{r0, r1, r2, r3, r4, ip, lr}
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:123

	and r4, sp, #7
    a2cc:	e20d4007 	and	r4, sp, #7
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:124
	sub sp, sp, r4
    a2d0:	e04dd004 	sub	sp, sp, r4
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:126

	bl _internal_irq_handler	;@ zavolame handler IRQ
    a2d4:	ebfffb6d 	bl	9090 <_internal_irq_handler>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:128

	add sp, sp, r4
    a2d8:	e08dd004 	add	sp, sp, r4
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:130

	pop {r0-r4, r12, lr}		;@ obnovime callee-saved registry
    a2dc:	e8bd501f 	pop	{r0, r1, r2, r3, r4, ip, lr}
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:131
	rfeia sp!					;@ vracime se do puvodniho stavu (ktery ulozila instrukce srsdb)
    a2e0:	f8bd0a00 	rfeia	sp!

0000a2e4 <prefetch_abort_handler>:
prefetch_abort_handler():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:136

prefetch_abort_handler:
	;@ tady pak muzeme osetrit, kdyz program zasahne do mista, ktere nema mapovane ve svem virtualnim adr. prostoru
	;@ a treba vyvolat nasi obdobu segfaultu
	b hang
    a2e4:	eafff76f 	b	80a8 <hang>

0000a2e8 <data_abort_handler>:
data_abort_handler():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/start.s:141

data_abort_handler:
	;@ tady pak muzeme osetrit, kdyz program zasahne do mista, ktere nema mapovane ve svem virtualnim adr. prostoru
	;@ a treba vyvolat nasi obdobu segfaultu
	b hang
    a2e8:	eafff76e 	b	80a8 <hang>

0000a2ec <_c_startup>:
_c_startup():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/startup.cpp:21
extern "C" dtor_ptr __DTOR_LIST__[0];
// konec pole destruktoru
extern "C" dtor_ptr __DTOR_END__[0];

extern "C" int _c_startup(void)
{
    a2ec:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    a2f0:	e28db000 	add	fp, sp, #0
    a2f4:	e24dd00c 	sub	sp, sp, #12
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/startup.cpp:25
    int* i;

    // vynulujeme .bss sekci
    for (i = (int*)_bss_start; i < (int*)_bss_end; i++)
    a2f8:	e59f304c 	ldr	r3, [pc, #76]	; a34c <_c_startup+0x60>
    a2fc:	e5933000 	ldr	r3, [r3]
    a300:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/startup.cpp:25 (discriminator 3)
    a304:	e59f3044 	ldr	r3, [pc, #68]	; a350 <_c_startup+0x64>
    a308:	e5933000 	ldr	r3, [r3]
    a30c:	e1a02003 	mov	r2, r3
    a310:	e51b3008 	ldr	r3, [fp, #-8]
    a314:	e1530002 	cmp	r3, r2
    a318:	2a000006 	bcs	a338 <_c_startup+0x4c>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/startup.cpp:26 (discriminator 2)
        *i = 0;
    a31c:	e51b3008 	ldr	r3, [fp, #-8]
    a320:	e3a02000 	mov	r2, #0
    a324:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/startup.cpp:25 (discriminator 2)
    for (i = (int*)_bss_start; i < (int*)_bss_end; i++)
    a328:	e51b3008 	ldr	r3, [fp, #-8]
    a32c:	e2833004 	add	r3, r3, #4
    a330:	e50b3008 	str	r3, [fp, #-8]
    a334:	eafffff2 	b	a304 <_c_startup+0x18>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/startup.cpp:28

    return 0;
    a338:	e3a03000 	mov	r3, #0
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/startup.cpp:29
}
    a33c:	e1a00003 	mov	r0, r3
    a340:	e28bd000 	add	sp, fp, #0
    a344:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    a348:	e12fff1e 	bx	lr
    a34c:	0000ab14 	andeq	sl, r0, r4, lsl fp
    a350:	0000bb70 	andeq	fp, r0, r0, ror fp

0000a354 <_cpp_startup>:
_cpp_startup():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/startup.cpp:32

extern "C" int _cpp_startup(void)
{
    a354:	e92d4800 	push	{fp, lr}
    a358:	e28db004 	add	fp, sp, #4
    a35c:	e24dd008 	sub	sp, sp, #8
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/startup.cpp:37
    ctor_ptr* fnptr;

    // zavolame konstruktory globalnich C++ trid
    // v poli __CTOR_LIST__ jsou ukazatele na vygenerovane stuby volani konstruktoru
    for (fnptr = __CTOR_LIST__; fnptr < __CTOR_END__; fnptr++)
    a360:	e59f303c 	ldr	r3, [pc, #60]	; a3a4 <_cpp_startup+0x50>
    a364:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/startup.cpp:37 (discriminator 3)
    a368:	e51b3008 	ldr	r3, [fp, #-8]
    a36c:	e59f2034 	ldr	r2, [pc, #52]	; a3a8 <_cpp_startup+0x54>
    a370:	e1530002 	cmp	r3, r2
    a374:	2a000006 	bcs	a394 <_cpp_startup+0x40>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/startup.cpp:38 (discriminator 2)
        (*fnptr)();
    a378:	e51b3008 	ldr	r3, [fp, #-8]
    a37c:	e5933000 	ldr	r3, [r3]
    a380:	e12fff33 	blx	r3
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/startup.cpp:37 (discriminator 2)
    for (fnptr = __CTOR_LIST__; fnptr < __CTOR_END__; fnptr++)
    a384:	e51b3008 	ldr	r3, [fp, #-8]
    a388:	e2833004 	add	r3, r3, #4
    a38c:	e50b3008 	str	r3, [fp, #-8]
    a390:	eafffff4 	b	a368 <_cpp_startup+0x14>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/startup.cpp:40

    return 0;
    a394:	e3a03000 	mov	r3, #0
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/startup.cpp:41
}
    a398:	e1a00003 	mov	r0, r3
    a39c:	e24bd004 	sub	sp, fp, #4
    a3a0:	e8bd8800 	pop	{fp, pc}
    a3a4:	0000aaf8 	strdeq	sl, [r0], -r8
    a3a8:	0000ab14 	andeq	sl, r0, r4, lsl fp

0000a3ac <_cpp_shutdown>:
_cpp_shutdown():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/startup.cpp:44

extern "C" int _cpp_shutdown(void)
{
    a3ac:	e92d4800 	push	{fp, lr}
    a3b0:	e28db004 	add	fp, sp, #4
    a3b4:	e24dd008 	sub	sp, sp, #8
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/startup.cpp:48
    dtor_ptr* fnptr;

    // zavolame destruktory globalnich C++ trid
    for (fnptr = __DTOR_LIST__; fnptr < __DTOR_END__; fnptr++)
    a3b8:	e59f303c 	ldr	r3, [pc, #60]	; a3fc <_cpp_shutdown+0x50>
    a3bc:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/startup.cpp:48 (discriminator 3)
    a3c0:	e51b3008 	ldr	r3, [fp, #-8]
    a3c4:	e59f2034 	ldr	r2, [pc, #52]	; a400 <_cpp_shutdown+0x54>
    a3c8:	e1530002 	cmp	r3, r2
    a3cc:	2a000006 	bcs	a3ec <_cpp_shutdown+0x40>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/startup.cpp:49 (discriminator 2)
        (*fnptr)();
    a3d0:	e51b3008 	ldr	r3, [fp, #-8]
    a3d4:	e5933000 	ldr	r3, [r3]
    a3d8:	e12fff33 	blx	r3
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/startup.cpp:48 (discriminator 2)
    for (fnptr = __DTOR_LIST__; fnptr < __DTOR_END__; fnptr++)
    a3dc:	e51b3008 	ldr	r3, [fp, #-8]
    a3e0:	e2833004 	add	r3, r3, #4
    a3e4:	e50b3008 	str	r3, [fp, #-8]
    a3e8:	eafffff4 	b	a3c0 <_cpp_shutdown+0x14>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/startup.cpp:51

    return 0;
    a3ec:	e3a03000 	mov	r3, #0
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/startup.cpp:52
}
    a3f0:	e1a00003 	mov	r0, r3
    a3f4:	e24bd004 	sub	sp, fp, #4
    a3f8:	e8bd8800 	pop	{fp, pc}
    a3fc:	0000ab14 	andeq	sl, r0, r4, lsl fp
    a400:	0000ab14 	andeq	sl, r0, r4, lsl fp

0000a404 <_Z4itoajPcj>:
_Z4itoajPcj():
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/stdlib/src/stdstring.cpp:9
{
    const char CharConvArr[] = "0123456789ABCDEF";
}

void itoa(unsigned int input, char* output, unsigned int base)
{
    a404:	e92d4800 	push	{fp, lr}
    a408:	e28db004 	add	fp, sp, #4
    a40c:	e24dd020 	sub	sp, sp, #32
    a410:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    a414:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    a418:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/stdlib/src/stdstring.cpp:10
    int i = 0;
    a41c:	e3a03000 	mov	r3, #0
    a420:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/stdlib/src/stdstring.cpp:12

    while (input > 0)
    a424:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    a428:	e3530000 	cmp	r3, #0
    a42c:	0a000014 	beq	a484 <_Z4itoajPcj+0x80>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/stdlib/src/stdstring.cpp:14
    {
        output[i] = CharConvArr[input % base];
    a430:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    a434:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    a438:	e1a00003 	mov	r0, r3
    a43c:	eb0000c8 	bl	a764 <__aeabi_uidivmod>
    a440:	e1a03001 	mov	r3, r1
    a444:	e1a01003 	mov	r1, r3
    a448:	e51b3008 	ldr	r3, [fp, #-8]
    a44c:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    a450:	e0823003 	add	r3, r2, r3
    a454:	e59f2118 	ldr	r2, [pc, #280]	; a574 <_Z4itoajPcj+0x170>
    a458:	e7d22001 	ldrb	r2, [r2, r1]
    a45c:	e5c32000 	strb	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/stdlib/src/stdstring.cpp:15
        input /= base;
    a460:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    a464:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    a468:	eb000042 	bl	a578 <__udivsi3>
    a46c:	e1a03000 	mov	r3, r0
    a470:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/stdlib/src/stdstring.cpp:16
        i++;
    a474:	e51b3008 	ldr	r3, [fp, #-8]
    a478:	e2833001 	add	r3, r3, #1
    a47c:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/stdlib/src/stdstring.cpp:12
    while (input > 0)
    a480:	eaffffe7 	b	a424 <_Z4itoajPcj+0x20>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/stdlib/src/stdstring.cpp:19
    }

    if (i == 0)
    a484:	e51b3008 	ldr	r3, [fp, #-8]
    a488:	e3530000 	cmp	r3, #0
    a48c:	1a000007 	bne	a4b0 <_Z4itoajPcj+0xac>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/stdlib/src/stdstring.cpp:21
    {
        output[i] = CharConvArr[0];
    a490:	e51b3008 	ldr	r3, [fp, #-8]
    a494:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    a498:	e0823003 	add	r3, r2, r3
    a49c:	e3a02030 	mov	r2, #48	; 0x30
    a4a0:	e5c32000 	strb	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/stdlib/src/stdstring.cpp:22
        i++;
    a4a4:	e51b3008 	ldr	r3, [fp, #-8]
    a4a8:	e2833001 	add	r3, r3, #1
    a4ac:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/stdlib/src/stdstring.cpp:25
    }

    output[i] = '\0';
    a4b0:	e51b3008 	ldr	r3, [fp, #-8]
    a4b4:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    a4b8:	e0823003 	add	r3, r2, r3
    a4bc:	e3a02000 	mov	r2, #0
    a4c0:	e5c32000 	strb	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/stdlib/src/stdstring.cpp:26
    i--;
    a4c4:	e51b3008 	ldr	r3, [fp, #-8]
    a4c8:	e2433001 	sub	r3, r3, #1
    a4cc:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/stdlib/src/stdstring.cpp:28

    for (int j = 0; j <= i / 2; j++)
    a4d0:	e3a03000 	mov	r3, #0
    a4d4:	e50b300c 	str	r3, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/stdlib/src/stdstring.cpp:28 (discriminator 3)
    a4d8:	e51b3008 	ldr	r3, [fp, #-8]
    a4dc:	e1a02fa3 	lsr	r2, r3, #31
    a4e0:	e0823003 	add	r3, r2, r3
    a4e4:	e1a030c3 	asr	r3, r3, #1
    a4e8:	e1a02003 	mov	r2, r3
    a4ec:	e51b300c 	ldr	r3, [fp, #-12]
    a4f0:	e1530002 	cmp	r3, r2
    a4f4:	ca00001b 	bgt	a568 <_Z4itoajPcj+0x164>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/stdlib/src/stdstring.cpp:30 (discriminator 2)
    {
        char c = output[i - j];
    a4f8:	e51b2008 	ldr	r2, [fp, #-8]
    a4fc:	e51b300c 	ldr	r3, [fp, #-12]
    a500:	e0423003 	sub	r3, r2, r3
    a504:	e1a02003 	mov	r2, r3
    a508:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    a50c:	e0833002 	add	r3, r3, r2
    a510:	e5d33000 	ldrb	r3, [r3]
    a514:	e54b300d 	strb	r3, [fp, #-13]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/stdlib/src/stdstring.cpp:31 (discriminator 2)
        output[i - j] = output[j];
    a518:	e51b300c 	ldr	r3, [fp, #-12]
    a51c:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    a520:	e0822003 	add	r2, r2, r3
    a524:	e51b1008 	ldr	r1, [fp, #-8]
    a528:	e51b300c 	ldr	r3, [fp, #-12]
    a52c:	e0413003 	sub	r3, r1, r3
    a530:	e1a01003 	mov	r1, r3
    a534:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    a538:	e0833001 	add	r3, r3, r1
    a53c:	e5d22000 	ldrb	r2, [r2]
    a540:	e5c32000 	strb	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/stdlib/src/stdstring.cpp:32 (discriminator 2)
        output[j] = c;
    a544:	e51b300c 	ldr	r3, [fp, #-12]
    a548:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    a54c:	e0823003 	add	r3, r2, r3
    a550:	e55b200d 	ldrb	r2, [fp, #-13]
    a554:	e5c32000 	strb	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/stdlib/src/stdstring.cpp:28 (discriminator 2)
    for (int j = 0; j <= i / 2; j++)
    a558:	e51b300c 	ldr	r3, [fp, #-12]
    a55c:	e2833001 	add	r3, r3, #1
    a560:	e50b300c 	str	r3, [fp, #-12]
    a564:	eaffffdb 	b	a4d8 <_Z4itoajPcj+0xd4>
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/stdlib/src/stdstring.cpp:34
    }
}
    a568:	e320f000 	nop	{0}
    a56c:	e24bd004 	sub	sp, fp, #4
    a570:	e8bd8800 	pop	{fp, pc}
    a574:	0000aab4 			; <UNDEFINED> instruction: 0x0000aab4

0000a578 <__udivsi3>:
__udivsi3():
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1099
    a578:	e2512001 	subs	r2, r1, #1
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1101
    a57c:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1102
    a580:	3a000074 	bcc	a758 <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1103
    a584:	e1500001 	cmp	r0, r1
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1104
    a588:	9a00006b 	bls	a73c <__udivsi3+0x1c4>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1105
    a58c:	e1110002 	tst	r1, r2
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1106
    a590:	0a00006c 	beq	a748 <__udivsi3+0x1d0>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1108
    a594:	e16f3f10 	clz	r3, r0
    a598:	e16f2f11 	clz	r2, r1
    a59c:	e0423003 	sub	r3, r2, r3
    a5a0:	e273301f 	rsbs	r3, r3, #31
    a5a4:	10833083 	addne	r3, r3, r3, lsl #1
    a5a8:	e3a02000 	mov	r2, #0
    a5ac:	108ff103 	addne	pc, pc, r3, lsl #2
    a5b0:	e1a00000 	nop			; (mov r0, r0)
    a5b4:	e1500f81 	cmp	r0, r1, lsl #31
    a5b8:	e0a22002 	adc	r2, r2, r2
    a5bc:	20400f81 	subcs	r0, r0, r1, lsl #31
    a5c0:	e1500f01 	cmp	r0, r1, lsl #30
    a5c4:	e0a22002 	adc	r2, r2, r2
    a5c8:	20400f01 	subcs	r0, r0, r1, lsl #30
    a5cc:	e1500e81 	cmp	r0, r1, lsl #29
    a5d0:	e0a22002 	adc	r2, r2, r2
    a5d4:	20400e81 	subcs	r0, r0, r1, lsl #29
    a5d8:	e1500e01 	cmp	r0, r1, lsl #28
    a5dc:	e0a22002 	adc	r2, r2, r2
    a5e0:	20400e01 	subcs	r0, r0, r1, lsl #28
    a5e4:	e1500d81 	cmp	r0, r1, lsl #27
    a5e8:	e0a22002 	adc	r2, r2, r2
    a5ec:	20400d81 	subcs	r0, r0, r1, lsl #27
    a5f0:	e1500d01 	cmp	r0, r1, lsl #26
    a5f4:	e0a22002 	adc	r2, r2, r2
    a5f8:	20400d01 	subcs	r0, r0, r1, lsl #26
    a5fc:	e1500c81 	cmp	r0, r1, lsl #25
    a600:	e0a22002 	adc	r2, r2, r2
    a604:	20400c81 	subcs	r0, r0, r1, lsl #25
    a608:	e1500c01 	cmp	r0, r1, lsl #24
    a60c:	e0a22002 	adc	r2, r2, r2
    a610:	20400c01 	subcs	r0, r0, r1, lsl #24
    a614:	e1500b81 	cmp	r0, r1, lsl #23
    a618:	e0a22002 	adc	r2, r2, r2
    a61c:	20400b81 	subcs	r0, r0, r1, lsl #23
    a620:	e1500b01 	cmp	r0, r1, lsl #22
    a624:	e0a22002 	adc	r2, r2, r2
    a628:	20400b01 	subcs	r0, r0, r1, lsl #22
    a62c:	e1500a81 	cmp	r0, r1, lsl #21
    a630:	e0a22002 	adc	r2, r2, r2
    a634:	20400a81 	subcs	r0, r0, r1, lsl #21
    a638:	e1500a01 	cmp	r0, r1, lsl #20
    a63c:	e0a22002 	adc	r2, r2, r2
    a640:	20400a01 	subcs	r0, r0, r1, lsl #20
    a644:	e1500981 	cmp	r0, r1, lsl #19
    a648:	e0a22002 	adc	r2, r2, r2
    a64c:	20400981 	subcs	r0, r0, r1, lsl #19
    a650:	e1500901 	cmp	r0, r1, lsl #18
    a654:	e0a22002 	adc	r2, r2, r2
    a658:	20400901 	subcs	r0, r0, r1, lsl #18
    a65c:	e1500881 	cmp	r0, r1, lsl #17
    a660:	e0a22002 	adc	r2, r2, r2
    a664:	20400881 	subcs	r0, r0, r1, lsl #17
    a668:	e1500801 	cmp	r0, r1, lsl #16
    a66c:	e0a22002 	adc	r2, r2, r2
    a670:	20400801 	subcs	r0, r0, r1, lsl #16
    a674:	e1500781 	cmp	r0, r1, lsl #15
    a678:	e0a22002 	adc	r2, r2, r2
    a67c:	20400781 	subcs	r0, r0, r1, lsl #15
    a680:	e1500701 	cmp	r0, r1, lsl #14
    a684:	e0a22002 	adc	r2, r2, r2
    a688:	20400701 	subcs	r0, r0, r1, lsl #14
    a68c:	e1500681 	cmp	r0, r1, lsl #13
    a690:	e0a22002 	adc	r2, r2, r2
    a694:	20400681 	subcs	r0, r0, r1, lsl #13
    a698:	e1500601 	cmp	r0, r1, lsl #12
    a69c:	e0a22002 	adc	r2, r2, r2
    a6a0:	20400601 	subcs	r0, r0, r1, lsl #12
    a6a4:	e1500581 	cmp	r0, r1, lsl #11
    a6a8:	e0a22002 	adc	r2, r2, r2
    a6ac:	20400581 	subcs	r0, r0, r1, lsl #11
    a6b0:	e1500501 	cmp	r0, r1, lsl #10
    a6b4:	e0a22002 	adc	r2, r2, r2
    a6b8:	20400501 	subcs	r0, r0, r1, lsl #10
    a6bc:	e1500481 	cmp	r0, r1, lsl #9
    a6c0:	e0a22002 	adc	r2, r2, r2
    a6c4:	20400481 	subcs	r0, r0, r1, lsl #9
    a6c8:	e1500401 	cmp	r0, r1, lsl #8
    a6cc:	e0a22002 	adc	r2, r2, r2
    a6d0:	20400401 	subcs	r0, r0, r1, lsl #8
    a6d4:	e1500381 	cmp	r0, r1, lsl #7
    a6d8:	e0a22002 	adc	r2, r2, r2
    a6dc:	20400381 	subcs	r0, r0, r1, lsl #7
    a6e0:	e1500301 	cmp	r0, r1, lsl #6
    a6e4:	e0a22002 	adc	r2, r2, r2
    a6e8:	20400301 	subcs	r0, r0, r1, lsl #6
    a6ec:	e1500281 	cmp	r0, r1, lsl #5
    a6f0:	e0a22002 	adc	r2, r2, r2
    a6f4:	20400281 	subcs	r0, r0, r1, lsl #5
    a6f8:	e1500201 	cmp	r0, r1, lsl #4
    a6fc:	e0a22002 	adc	r2, r2, r2
    a700:	20400201 	subcs	r0, r0, r1, lsl #4
    a704:	e1500181 	cmp	r0, r1, lsl #3
    a708:	e0a22002 	adc	r2, r2, r2
    a70c:	20400181 	subcs	r0, r0, r1, lsl #3
    a710:	e1500101 	cmp	r0, r1, lsl #2
    a714:	e0a22002 	adc	r2, r2, r2
    a718:	20400101 	subcs	r0, r0, r1, lsl #2
    a71c:	e1500081 	cmp	r0, r1, lsl #1
    a720:	e0a22002 	adc	r2, r2, r2
    a724:	20400081 	subcs	r0, r0, r1, lsl #1
    a728:	e1500001 	cmp	r0, r1
    a72c:	e0a22002 	adc	r2, r2, r2
    a730:	20400001 	subcs	r0, r0, r1
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1110
    a734:	e1a00002 	mov	r0, r2
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1111
    a738:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1114
    a73c:	03a00001 	moveq	r0, #1
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1115
    a740:	13a00000 	movne	r0, #0
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1116
    a744:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1118
    a748:	e16f2f11 	clz	r2, r1
    a74c:	e262201f 	rsb	r2, r2, #31
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1120
    a750:	e1a00230 	lsr	r0, r0, r2
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1121
    a754:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1125
    a758:	e3500000 	cmp	r0, #0
    a75c:	13e00000 	mvnne	r0, #0
    a760:	ea000007 	b	a784 <__aeabi_idiv0>

0000a764 <__aeabi_uidivmod>:
__aeabi_uidivmod():
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1156
    a764:	e3510000 	cmp	r1, #0
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1157
    a768:	0afffffa 	beq	a758 <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1158
    a76c:	e92d4003 	push	{r0, r1, lr}
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1159
    a770:	ebffff80 	bl	a578 <__udivsi3>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1160
    a774:	e8bd4006 	pop	{r1, r2, lr}
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1161
    a778:	e0030092 	mul	r3, r2, r0
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1162
    a77c:	e0411003 	sub	r1, r1, r3
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1163
    a780:	e12fff1e 	bx	lr

0000a784 <__aeabi_idiv0>:
__aeabi_ldiv0():
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1461
    a784:	e12fff1e 	bx	lr

Disassembly of section .ARM.extab:

0000a788 <.ARM.extab>:
    a788:	81019b40 	tsthi	r1, r0, asr #22
    a78c:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    a790:	00000000 	andeq	r0, r0, r0
    a794:	81019b40 	tsthi	r1, r0, asr #22
    a798:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    a79c:	00000000 	andeq	r0, r0, r0
    a7a0:	81019b40 	tsthi	r1, r0, asr #22
    a7a4:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    a7a8:	00000000 	andeq	r0, r0, r0
    a7ac:	81019b40 	tsthi	r1, r0, asr #22
    a7b0:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    a7b4:	00000000 	andeq	r0, r0, r0
    a7b8:	81019b40 	tsthi	r1, r0, asr #22
    a7bc:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    a7c0:	00000000 	andeq	r0, r0, r0
    a7c4:	81019b40 	tsthi	r1, r0, asr #22
    a7c8:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    a7cc:	00000000 	andeq	r0, r0, r0
    a7d0:	81019b40 	tsthi	r1, r0, asr #22
    a7d4:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    a7d8:	00000000 	andeq	r0, r0, r0
    a7dc:	81019b40 	tsthi	r1, r0, asr #22
    a7e0:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    a7e4:	00000000 	andeq	r0, r0, r0
    a7e8:	81019b40 	tsthi	r1, r0, asr #22
    a7ec:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    a7f0:	00000000 	andeq	r0, r0, r0
    a7f4:	81019b40 	tsthi	r1, r0, asr #22
    a7f8:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    a7fc:	00000000 	andeq	r0, r0, r0
    a800:	81019b40 	tsthi	r1, r0, asr #22
    a804:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    a808:	00000000 	andeq	r0, r0, r0
    a80c:	81019b40 	tsthi	r1, r0, asr #22
    a810:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    a814:	00000000 	andeq	r0, r0, r0
    a818:	81019b40 	tsthi	r1, r0, asr #22
    a81c:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    a820:	00000000 	andeq	r0, r0, r0
    a824:	81019b40 	tsthi	r1, r0, asr #22
    a828:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    a82c:	00000000 	andeq	r0, r0, r0
    a830:	81019b40 	tsthi	r1, r0, asr #22
    a834:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    a838:	00000000 	andeq	r0, r0, r0
    a83c:	81019b40 	tsthi	r1, r0, asr #22
    a840:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    a844:	00000000 	andeq	r0, r0, r0

Disassembly of section .ARM.exidx:

0000a848 <.ARM.exidx>:
    a848:	7fffd864 	svcvc	0x00ffd864
    a84c:	00000001 	andeq	r0, r0, r1
    a850:	7fffe728 	svcvc	0x00ffe728
    a854:	7fffff34 	svcvc	0x00ffff34
    a858:	7fffe770 	svcvc	0x00ffe770
    a85c:	00000001 	andeq	r0, r0, r1
    a860:	7fffe830 	svcvc	0x00ffe830
    a864:	7fffff30 	svcvc	0x00ffff30
    a868:	7fffe858 	svcvc	0x00ffe858
    a86c:	00000001 	andeq	r0, r0, r1
    a870:	7fffea64 	svcvc	0x00ffea64
    a874:	7fffff2c 	svcvc	0x00ffff2c
    a878:	7fffeab8 	svcvc	0x00ffeab8
    a87c:	7fffff30 	svcvc	0x00ffff30
    a880:	7fffeb1c 	svcvc	0x00ffeb1c
    a884:	7fffff34 	svcvc	0x00ffff34
    a888:	7fffeb80 	svcvc	0x00ffeb80
    a88c:	7fffff38 	svcvc	0x00ffff38
    a890:	7fffebe4 	svcvc	0x00ffebe4
    a894:	7fffff3c 	svcvc	0x00ffff3c
    a898:	7fffec48 	svcvc	0x00ffec48
    a89c:	7fffff40 	svcvc	0x00ffff40
    a8a0:	7fffed1c 	svcvc	0x00ffed1c
    a8a4:	7fffff44 	svcvc	0x00ffff44
    a8a8:	7fffed48 	svcvc	0x00ffed48
    a8ac:	7fffff48 	svcvc	0x00ffff48
    a8b0:	7fffeda8 	svcvc	0x00ffeda8
    a8b4:	00000001 	andeq	r0, r0, r1
    a8b8:	7ffff3a0 	svcvc	0x00fff3a0
    a8bc:	7fffff44 	svcvc	0x00ffff44
    a8c0:	7ffff490 	svcvc	0x00fff490
    a8c4:	7fffff48 	svcvc	0x00ffff48
    a8c8:	7ffff64c 	svcvc	0x00fff64c
    a8cc:	7fffff4c 	svcvc	0x00ffff4c
    a8d0:	7ffff7ac 	svcvc	0x00fff7ac
    a8d4:	7fffff50 	svcvc	0x00ffff50
    a8d8:	7ffff8a8 	svcvc	0x00fff8a8
    a8dc:	00000001 	andeq	r0, r0, r1
    a8e0:	7ffffa74 	svcvc	0x00fffa74
    a8e4:	7fffff4c 	svcvc	0x00ffff4c
    a8e8:	7ffffac4 	svcvc	0x00fffac4
    a8ec:	7fffff50 	svcvc	0x00ffff50
    a8f0:	7ffffb14 	svcvc	0x00fffb14
    a8f4:	00000001 	andeq	r0, r0, r1

Disassembly of section .rodata:

0000a8f8 <_ZN3halL18Default_Clock_RateE>:
    a8f8:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

0000a8fc <_ZN3halL15Peripheral_BaseE>:
    a8fc:	20000000 	andcs	r0, r0, r0

0000a900 <_ZN3halL9GPIO_BaseE>:
    a900:	20200000 	eorcs	r0, r0, r0

0000a904 <_ZN3halL14GPIO_Pin_CountE>:
    a904:	00000036 	andeq	r0, r0, r6, lsr r0

0000a908 <_ZN3halL8AUX_BaseE>:
    a908:	20215000 	eorcs	r5, r1, r0

0000a90c <_ZN3halL25Interrupt_Controller_BaseE>:
    a90c:	2000b200 	andcs	fp, r0, r0, lsl #4

0000a910 <_ZN3halL10Timer_BaseE>:
    a910:	2000b400 	andcs	fp, r0, r0, lsl #8

0000a914 <_ZZN8CMonitorlsEjE11BUFFER_SIZE>:
    a914:	00000010 	andeq	r0, r0, r0, lsl r0
    a918:	65757274 	ldrbvs	r7, [r5, #-628]!	; 0xfffffd8c
    a91c:	00000000 	andeq	r0, r0, r0
    a920:	736c6166 	cmnvc	ip, #-2147483623	; 0x80000019
    a924:	00000065 	andeq	r0, r0, r5, rrx
    a928:	33323130 	teqcc	r2, #48, 2
    a92c:	37363534 			; <UNDEFINED> instruction: 0x37363534
    a930:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    a934:	46454443 	strbmi	r4, [r5], -r3, asr #8
    a938:	00000000 	andeq	r0, r0, r0

0000a93c <_ZN3halL18Default_Clock_RateE>:
    a93c:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

0000a940 <_ZN3halL15Peripheral_BaseE>:
    a940:	20000000 	andcs	r0, r0, r0

0000a944 <_ZN3halL9GPIO_BaseE>:
    a944:	20200000 	eorcs	r0, r0, r0

0000a948 <_ZN3halL14GPIO_Pin_CountE>:
    a948:	00000036 	andeq	r0, r0, r6, lsr r0

0000a94c <_ZN3halL8AUX_BaseE>:
    a94c:	20215000 	eorcs	r5, r1, r0

0000a950 <_ZN3halL25Interrupt_Controller_BaseE>:
    a950:	2000b200 	andcs	fp, r0, r0, lsl #4

0000a954 <_ZN3halL10Timer_BaseE>:
    a954:	2000b400 	andcs	fp, r0, r0, lsl #8

0000a958 <_ZN3halL18Default_Clock_RateE>:
    a958:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

0000a95c <_ZN3halL15Peripheral_BaseE>:
    a95c:	20000000 	andcs	r0, r0, r0

0000a960 <_ZN3halL9GPIO_BaseE>:
    a960:	20200000 	eorcs	r0, r0, r0

0000a964 <_ZN3halL14GPIO_Pin_CountE>:
    a964:	00000036 	andeq	r0, r0, r6, lsr r0

0000a968 <_ZN3halL8AUX_BaseE>:
    a968:	20215000 	eorcs	r5, r1, r0

0000a96c <_ZN3halL25Interrupt_Controller_BaseE>:
    a96c:	2000b200 	andcs	fp, r0, r0, lsl #4

0000a970 <_ZN3halL10Timer_BaseE>:
    a970:	2000b400 	andcs	fp, r0, r0, lsl #8

0000a974 <_ZN3halL18Default_Clock_RateE>:
    a974:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

0000a978 <_ZN3halL15Peripheral_BaseE>:
    a978:	20000000 	andcs	r0, r0, r0

0000a97c <_ZN3halL9GPIO_BaseE>:
    a97c:	20200000 	eorcs	r0, r0, r0

0000a980 <_ZN3halL14GPIO_Pin_CountE>:
    a980:	00000036 	andeq	r0, r0, r6, lsr r0

0000a984 <_ZN3halL8AUX_BaseE>:
    a984:	20215000 	eorcs	r5, r1, r0

0000a988 <_ZN3halL25Interrupt_Controller_BaseE>:
    a988:	2000b200 	andcs	fp, r0, r0, lsl #4

0000a98c <_ZN3halL10Timer_BaseE>:
    a98c:	2000b400 	andcs	fp, r0, r0, lsl #8

0000a990 <_ZN3memL9LowMemoryE>:
    a990:	00020000 	andeq	r0, r2, r0

0000a994 <_ZN3memL10HighMemoryE>:
    a994:	20000000 	andcs	r0, r0, r0

0000a998 <_ZN3memL8PageSizeE>:
    a998:	00004000 	andeq	r4, r0, r0

0000a99c <_ZN3memL16PagingMemorySizeE>:
    a99c:	1ffe0000 	svcne	0x00fe0000

0000a9a0 <_ZN3memL9PageCountE>:
    a9a0:	00007ff8 	strdeq	r7, [r0], -r8

0000a9a4 <_ZL7ACT_Pin>:
    a9a4:	0000002f 	andeq	r0, r0, pc, lsr #32
    a9a8:	636f7250 	cmnvs	pc, #80, 4
    a9ac:	20737365 	rsbscs	r7, r3, r5, ror #6
    a9b0:	00000a31 	andeq	r0, r0, r1, lsr sl
    a9b4:	636f7250 	cmnvs	pc, #80, 4
    a9b8:	20737365 	rsbscs	r7, r3, r5, ror #6
    a9bc:	00000a32 	andeq	r0, r0, r2, lsr sl
    a9c0:	636f7250 	cmnvs	pc, #80, 4
    a9c4:	20737365 	rsbscs	r7, r3, r5, ror #6
    a9c8:	00000a33 	andeq	r0, r0, r3, lsr sl
    a9cc:	636f7250 	cmnvs	pc, #80, 4
    a9d0:	20737365 	rsbscs	r7, r3, r5, ror #6
    a9d4:	00000a34 	andeq	r0, r0, r4, lsr sl
    a9d8:	636c6557 	cmnvs	ip, #364904448	; 0x15c00000
    a9dc:	20656d6f 	rsbcs	r6, r5, pc, ror #26
    a9e0:	4b206f74 	blmi	8267b8 <_bss_end+0x81ac48>
    a9e4:	4f2f5649 	svcmi	0x002f5649
    a9e8:	50522053 	subspl	r2, r2, r3, asr r0
    a9ec:	20534f69 	subscs	r4, r3, r9, ror #30
    a9f0:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
    a9f4:	000a6c65 	andeq	r6, sl, r5, ror #24

0000a9f8 <_ZN3halL18Default_Clock_RateE>:
    a9f8:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

0000a9fc <_ZN3halL15Peripheral_BaseE>:
    a9fc:	20000000 	andcs	r0, r0, r0

0000aa00 <_ZN3halL9GPIO_BaseE>:
    aa00:	20200000 	eorcs	r0, r0, r0

0000aa04 <_ZN3halL14GPIO_Pin_CountE>:
    aa04:	00000036 	andeq	r0, r0, r6, lsr r0

0000aa08 <_ZN3halL8AUX_BaseE>:
    aa08:	20215000 	eorcs	r5, r1, r0

0000aa0c <_ZN3halL25Interrupt_Controller_BaseE>:
    aa0c:	2000b200 	andcs	fp, r0, r0, lsl #4

0000aa10 <_ZN3halL10Timer_BaseE>:
    aa10:	2000b400 	andcs	fp, r0, r0, lsl #8

0000aa14 <_ZN3memL9LowMemoryE>:
    aa14:	00020000 	andeq	r0, r2, r0

0000aa18 <_ZN3memL10HighMemoryE>:
    aa18:	20000000 	andcs	r0, r0, r0

0000aa1c <_ZN3memL8PageSizeE>:
    aa1c:	00004000 	andeq	r4, r0, r0

0000aa20 <_ZN3memL16PagingMemorySizeE>:
    aa20:	1ffe0000 	svcne	0x00fe0000

0000aa24 <_ZN3memL9PageCountE>:
    aa24:	00007ff8 	strdeq	r7, [r0], -r8

0000aa28 <_ZN3halL18Default_Clock_RateE>:
    aa28:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

0000aa2c <_ZN3halL15Peripheral_BaseE>:
    aa2c:	20000000 	andcs	r0, r0, r0

0000aa30 <_ZN3halL9GPIO_BaseE>:
    aa30:	20200000 	eorcs	r0, r0, r0

0000aa34 <_ZN3halL14GPIO_Pin_CountE>:
    aa34:	00000036 	andeq	r0, r0, r6, lsr r0

0000aa38 <_ZN3halL8AUX_BaseE>:
    aa38:	20215000 	eorcs	r5, r1, r0

0000aa3c <_ZN3halL25Interrupt_Controller_BaseE>:
    aa3c:	2000b200 	andcs	fp, r0, r0, lsl #4

0000aa40 <_ZN3halL10Timer_BaseE>:
    aa40:	2000b400 	andcs	fp, r0, r0, lsl #8

0000aa44 <_ZN3memL9LowMemoryE>:
    aa44:	00020000 	andeq	r0, r2, r0

0000aa48 <_ZN3memL10HighMemoryE>:
    aa48:	20000000 	andcs	r0, r0, r0

0000aa4c <_ZN3memL8PageSizeE>:
    aa4c:	00004000 	andeq	r4, r0, r0

0000aa50 <_ZN3memL16PagingMemorySizeE>:
    aa50:	1ffe0000 	svcne	0x00fe0000

0000aa54 <_ZN3memL9PageCountE>:
    aa54:	00007ff8 	strdeq	r7, [r0], -r8

0000aa58 <_ZN3halL18Default_Clock_RateE>:
    aa58:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

0000aa5c <_ZN3halL15Peripheral_BaseE>:
    aa5c:	20000000 	andcs	r0, r0, r0

0000aa60 <_ZN3halL9GPIO_BaseE>:
    aa60:	20200000 	eorcs	r0, r0, r0

0000aa64 <_ZN3halL14GPIO_Pin_CountE>:
    aa64:	00000036 	andeq	r0, r0, r6, lsr r0

0000aa68 <_ZN3halL8AUX_BaseE>:
    aa68:	20215000 	eorcs	r5, r1, r0

0000aa6c <_ZN3halL25Interrupt_Controller_BaseE>:
    aa6c:	2000b200 	andcs	fp, r0, r0, lsl #4

0000aa70 <_ZN3halL10Timer_BaseE>:
    aa70:	2000b400 	andcs	fp, r0, r0, lsl #8

0000aa74 <_ZN3memL9LowMemoryE>:
    aa74:	00020000 	andeq	r0, r2, r0

0000aa78 <_ZN3memL10HighMemoryE>:
    aa78:	20000000 	andcs	r0, r0, r0

0000aa7c <_ZN3memL8PageSizeE>:
    aa7c:	00004000 	andeq	r4, r0, r0

0000aa80 <_ZN3memL16PagingMemorySizeE>:
    aa80:	1ffe0000 	svcne	0x00fe0000

0000aa84 <_ZN3memL9PageCountE>:
    aa84:	00007ff8 	strdeq	r7, [r0], -r8
    aa88:	61657243 	cmnvs	r5, r3, asr #4
    aa8c:	20646574 	rsbcs	r6, r4, r4, ror r5
    aa90:	636f7270 	cmnvs	pc, #112, 4
    aa94:	20737365 	rsbscs	r7, r3, r5, ror #6
    aa98:	68746977 	ldmdavs	r4!, {r0, r1, r2, r4, r5, r6, r8, fp, sp, lr}^
    aa9c:	64697020 	strbtvs	r7, [r9], #-32	; 0xffffffe0
    aaa0:	00000020 	andeq	r0, r0, r0, lsr #32
    aaa4:	00002820 	andeq	r2, r0, r0, lsr #16
    aaa8:	3d205053 	stccc	0, cr5, [r0, #-332]!	; 0xfffffeb4
    aaac:	00783020 	rsbseq	r3, r8, r0, lsr #32
    aab0:	00000a29 	andeq	r0, r0, r9, lsr #20

0000aab4 <_ZN12_GLOBAL__N_1L11CharConvArrE>:
    aab4:	33323130 	teqcc	r2, #48, 2
    aab8:	37363534 			; <UNDEFINED> instruction: 0x37363534
    aabc:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    aac0:	46454443 	strbmi	r4, [r5], -r3, asr #8
	...

Disassembly of section .ARM.extab.text._ZN20CKernel_Heap_Manager5AllocI18CProcess_List_NodeEEPT_v:

0000aac8 <.ARM.extab.text._ZN20CKernel_Heap_Manager5AllocI18CProcess_List_NodeEEPT_v>:
    aac8:	81019b40 	tsthi	r1, r0, asr #22
    aacc:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    aad0:	00000000 	andeq	r0, r0, r0

Disassembly of section .ARM.exidx.text._ZN20CKernel_Heap_Manager5AllocI18CProcess_List_NodeEEPT_v:

0000aad4 <.ARM.exidx.text._ZN20CKernel_Heap_Manager5AllocI18CProcess_List_NodeEEPT_v>:
    aad4:	7ffff714 	svcvc	0x00fff714
    aad8:	7ffffff0 	svcvc	0x00fffff0

Disassembly of section .ARM.extab.text._ZN20CKernel_Heap_Manager5AllocI12TTask_StructEEPT_v:

0000aadc <.ARM.extab.text._ZN20CKernel_Heap_Manager5AllocI12TTask_StructEEPT_v>:
    aadc:	81019b40 	tsthi	r1, r0, asr #22
    aae0:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    aae4:	00000000 	andeq	r0, r0, r0

Disassembly of section .ARM.exidx.text._ZN20CKernel_Heap_Manager5AllocI12TTask_StructEEPT_v:

0000aae8 <.ARM.exidx.text._ZN20CKernel_Heap_Manager5AllocI12TTask_StructEEPT_v>:
    aae8:	7ffff72c 	svcvc	0x00fff72c
    aaec:	7ffffff0 	svcvc	0x00fffff0
    aaf0:	7ffff750 	svcvc	0x00fff750
    aaf4:	00000001 	andeq	r0, r0, r1

Disassembly of section .data:

0000aaf8 <__CTOR_LIST__>:
    aaf8:	00008698 	muleq	r0, r8, r6
    aafc:	00008ce0 	andeq	r8, r0, r0, ror #25
    ab00:	0000905c 	andeq	r9, r0, ip, asr r0
    ab04:	000092b8 			; <UNDEFINED> instruction: 0x000092b8
    ab08:	0000990c 	andeq	r9, r0, ip, lsl #18
    ab0c:	00009bb0 			; <UNDEFINED> instruction: 0x00009bb0
    ab10:	0000a1cc 	andeq	sl, r0, ip, asr #3

Disassembly of section .bss:

0000ab14 <sGPIO>:
    ab14:	00000000 	andeq	r0, r0, r0

0000ab18 <sMonitor>:
	...

0000ab30 <_ZZN8CMonitorlsEjE8s_buffer>:
	...

0000ab40 <sTimer>:
	...

0000ab48 <sInterruptCtl>:
_ZZN8CMonitorlsEjE8s_buffer():
    ab48:	00000000 	andeq	r0, r0, r0

0000ab4c <LED_State>:
/home/silhavyj/School/ZeroMate/examples/13-context_switch_monitor/kernel/src/main.cpp:14
volatile bool LED_State = false;
    ab4c:	00000000 	andeq	r0, r0, r0

0000ab50 <sKernelMem>:
    ab50:	00000000 	andeq	r0, r0, r0

0000ab54 <sPage_Manager>:
	...

0000bb54 <sProcessMgr>:
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
      28:	28010000 	stmdacs	r1, {}	; <UNPREDICTABLE>
      2c:	00817811 	addeq	r7, r1, r1, lsl r8
      30:	00000c00 	andeq	r0, r0, r0, lsl #24
      34:	029c0100 	addseq	r0, ip, #0, 2
      38:	00000165 	andeq	r0, r0, r5, ror #2
      3c:	60112301 	andsvs	r2, r1, r1, lsl #6
      40:	18000081 	stmdane	r0, {r0, r7}
      44:	01000000 	mrseq	r0, (UNDEF: 0)
      48:	0131029c 	teqeq	r1, ip	; <illegal shifter operand>
      4c:	1e010000 	cdpne	0, 0, cr0, cr1, cr0, {0}
      50:	00814811 	addeq	r4, r1, r1, lsl r8
      54:	00001800 	andeq	r1, r0, r0, lsl #16
      58:	029c0100 	addseq	r0, ip, #0, 2
      5c:	00000124 	andeq	r0, r0, r4, lsr #2
      60:	30111901 	andscc	r1, r1, r1, lsl #18
      64:	18000081 	stmdane	r0, {r0, r7}
      68:	01000000 	mrseq	r0, (UNDEF: 0)
      6c:	015a039c 			; <UNDEFINED> instruction: 0x015a039c
      70:	00020000 	andeq	r0, r2, r0
      74:	000000bb 	strheq	r0, [r0], -fp
      78:	00011204 	andeq	r1, r1, r4, lsl #4
      7c:	15140100 	ldrne	r0, [r4, #-256]	; 0xffffff00
      80:	0000008a 	andeq	r0, r0, sl, lsl #1
      84:	0000bb05 	andeq	fp, r0, r5, lsl #22
      88:	3e060000 	cdpcc	0, 0, cr0, cr6, cr0, {0}
      8c:	01000001 	tsteq	r0, r1
      90:	00c11f04 	sbceq	r1, r1, r4, lsl #30
      94:	fe040000 	cdp2	0, 0, cr0, cr4, cr0, {0}
      98:	01000000 	mrseq	r0, (UNDEF: 0)
      9c:	00a8150f 	adceq	r1, r8, pc, lsl #10
      a0:	bb050000 	bllt	1400a8 <_bss_end+0x134538>
      a4:	00000000 	andeq	r0, r0, r0
      a8:	00014607 	andeq	r4, r1, r7, lsl #12
      ac:	140a0100 	strne	r0, [sl], #-256	; 0xffffff00
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
      fc:	0000bb32 	andeq	fp, r0, r2, lsr fp
     100:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     104:	05040d00 	streq	r0, [r4, #-3328]	; 0xfffff300
     108:	00746e69 	rsbseq	r6, r4, r9, ror #28
     10c:	0000a80e 	andeq	sl, r0, lr, lsl #16
     110:	0080ac00 	addeq	sl, r0, r0, lsl #24
     114:	00003800 	andeq	r3, r0, r0, lsl #16
     118:	0c9c0100 	ldfeqs	f0, [ip], {0}
     11c:	0a010067 	beq	402c0 <_bss_end+0x34750>
     120:	0000bb31 	andeq	fp, r0, r1, lsr fp
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
     184:	1e620704 	cdpne	7, 6, cr0, cr2, cr4, {0}
     188:	59050000 	stmdbpl	r5, {}	; <UNPREDICTABLE>
     18c:	06000000 	streq	r0, [r0], -r0
     190:	00000059 	andeq	r0, r0, r9, asr r0
     194:	6c616807 	stclvs	8, cr6, [r1], #-28	; 0xffffffe4
     198:	0b070200 	bleq	1c09a0 <_bss_end+0x1b4e30>
     19c:	000001a5 	andeq	r0, r0, r5, lsr #3
     1a0:	00068008 	andeq	r8, r6, r8
     1a4:	1c090200 	sfmne	f0, 4, [r9], {-0}
     1a8:	00000060 	andeq	r0, r0, r0, rrx
     1ac:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}
     1b0:	0003e608 	andeq	lr, r3, r8, lsl #12
     1b4:	1d0c0200 	sfmne	f0, 4, [ip, #-0]
     1b8:	000001b1 			; <UNDEFINED> instruction: 0x000001b1
     1bc:	20000000 	andcs	r0, r0, r0
     1c0:	0004c408 	andeq	ip, r4, r8, lsl #8
     1c4:	1d0f0200 	sfmne	f0, 4, [pc, #-0]	; 1cc <CPSR_IRQ_INHIBIT+0x14c>
     1c8:	000001b1 			; <UNDEFINED> instruction: 0x000001b1
     1cc:	20200000 	eorcs	r0, r0, r0
     1d0:	00053009 	andeq	r3, r5, r9
     1d4:	18120200 	ldmdane	r2, {r9}
     1d8:	00000054 	andeq	r0, r0, r4, asr r0
     1dc:	05790a36 	ldrbeq	r0, [r9, #-2614]!	; 0xfffff5ca
     1e0:	04050000 	streq	r0, [r5], #-0
     1e4:	00000033 	andeq	r0, r0, r3, lsr r0
     1e8:	74101502 	ldrvc	r1, [r0], #-1282	; 0xfffffafe
     1ec:	0b000001 	bleq	1f8 <CPSR_IRQ_INHIBIT+0x178>
     1f0:	0000022f 	andeq	r0, r0, pc, lsr #4
     1f4:	02370b00 	eorseq	r0, r7, #0, 22
     1f8:	0b010000 	bleq	40200 <_bss_end+0x34690>
     1fc:	0000023f 	andeq	r0, r0, pc, lsr r2
     200:	02470b02 	subeq	r0, r7, #2048	; 0x800
     204:	0b030000 	bleq	c020c <_bss_end+0xb469c>
     208:	0000024f 	andeq	r0, r0, pc, asr #4
     20c:	02570b04 	subseq	r0, r7, #4, 22	; 0x1000
     210:	0b050000 	bleq	140218 <_bss_end+0x1346a8>
     214:	00000221 	andeq	r0, r0, r1, lsr #4
     218:	02280b07 	eoreq	r0, r8, #7168	; 0x1c00
     21c:	0b080000 	bleq	200224 <_bss_end+0x1f46b4>
     220:	000006a5 	andeq	r0, r0, r5, lsr #13
     224:	04ce0b0a 	strbeq	r0, [lr], #2826	; 0xb0a
     228:	0b0b0000 	bleq	2c0230 <_bss_end+0x2b46c0>
     22c:	000005c5 	andeq	r0, r0, r5, asr #11
     230:	05cc0b0d 	strbeq	r0, [ip, #2829]	; 0xb0d
     234:	0b0e0000 	bleq	38023c <_bss_end+0x3746cc>
     238:	0000031b 	andeq	r0, r0, fp, lsl r3
     23c:	03220b10 			; <UNDEFINED> instruction: 0x03220b10
     240:	0b110000 	bleq	440248 <_bss_end+0x4346d8>
     244:	0000029e 	muleq	r0, lr, r2
     248:	02a50b13 	adceq	r0, r5, #19456	; 0x4c00
     24c:	0b140000 	bleq	500254 <_bss_end+0x4f46e4>
     250:	00000643 	andeq	r0, r0, r3, asr #12
     254:	025f0b16 	subseq	r0, pc, #22528	; 0x5800
     258:	0b170000 	bleq	5c0260 <_bss_end+0x5b46f0>
     25c:	000004e5 	andeq	r0, r0, r5, ror #9
     260:	04ec0b19 	strbteq	r0, [ip], #2841	; 0xb19
     264:	0b1a0000 	bleq	68026c <_bss_end+0x6746fc>
     268:	00000343 	andeq	r0, r0, r3, asr #6
     26c:	05150b1c 	ldreq	r0, [r5, #-2844]	; 0xfffff4e4
     270:	0b1d0000 	bleq	740278 <_bss_end+0x734708>
     274:	000004d5 	ldrdeq	r0, [r0], -r5
     278:	04dd0b1f 	ldrbeq	r0, [sp], #2847	; 0xb1f
     27c:	0b200000 	bleq	800284 <_bss_end+0x7f4714>
     280:	00000458 	andeq	r0, r0, r8, asr r4
     284:	04600b22 	strbteq	r0, [r0], #-2850	; 0xfffff4de
     288:	0b230000 	bleq	8c0290 <_bss_end+0x8b4720>
     28c:	00000382 	andeq	r0, r0, r2, lsl #7
     290:	028a0b25 	addeq	r0, sl, #37888	; 0x9400
     294:	0b260000 	bleq	98029c <_bss_end+0x97472c>
     298:	00000294 	muleq	r0, r4, r2
     29c:	27080027 	strcs	r0, [r8, -r7, lsr #32]
     2a0:	02000006 	andeq	r0, r0, #6
     2a4:	01b11d44 			; <UNDEFINED> instruction: 0x01b11d44
     2a8:	50000000 	andpl	r0, r0, r0
     2ac:	66082021 	strvs	r2, [r8], -r1, lsr #32
     2b0:	02000002 	andeq	r0, r0, #2
     2b4:	01b11d73 			; <UNDEFINED> instruction: 0x01b11d73
     2b8:	b2000000 	andlt	r0, r0, #0
     2bc:	44082000 	strmi	r2, [r8], #-0
     2c0:	02000005 	andeq	r0, r0, #5
     2c4:	01b11da6 			; <UNDEFINED> instruction: 0x01b11da6
     2c8:	b4000000 	strlt	r0, [r0], #-0
     2cc:	0c002000 	stceq	0, cr2, [r0], {-0}
     2d0:	00000076 	andeq	r0, r0, r6, ror r0
     2d4:	5d070402 	cfstrspl	mvf0, [r7, #-8]
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
     32c:	7a0b0400 	bvc	2c1334 <_bss_end+0x2b57c4>
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
     358:	221e0300 	andscs	r0, lr, #0, 6
     35c:	000003ad 	andeq	r0, r0, sp, lsr #7
     360:	051c0f00 	ldreq	r0, [ip, #-3840]	; 0xfffff100
     364:	22030000 	andcs	r0, r3, #0
     368:	0002ce0a 	andeq	ip, r2, sl, lsl #28
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
     394:	680a2403 	stmdavs	sl, {r0, r1, sl, sp}
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
     3c4:	0005f80a 	andeq	pc, r5, sl, lsl #16
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
     3f0:	f20a2803 	vadd.i8	d2, d10, d3
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
     41c:	2b030000 	blcs	c0424 <_bss_end+0xb48b4>
     420:	00030405 	andeq	r0, r3, r5, lsl #8
     424:	0003ca00 	andeq	ip, r3, r0, lsl #20
     428:	03080100 	movweq	r0, #33024	; 0x8100
     42c:	03130000 	tsteq	r3, #0
     430:	ca100000 	bgt	400438 <_bss_end+0x3f48c8>
     434:	11000003 	tstne	r0, r3
     438:	00000059 	andeq	r0, r0, r9, asr r0
     43c:	05d31200 	ldrbeq	r1, [r3, #512]	; 0x200
     440:	2e030000 	cdpcs	0, 0, cr0, cr3, cr0, {0}
     444:	0005870a 	andeq	r8, r5, sl, lsl #14
     448:	03280100 			; <UNDEFINED> instruction: 0x03280100
     44c:	03380000 	teqeq	r8, #0
     450:	ca100000 	bgt	400458 <_bss_end+0x3f48e8>
     454:	11000003 	tstne	r0, r3
     458:	00000048 	andeq	r0, r0, r8, asr #32
     45c:	0001d411 	andeq	sp, r1, r1, lsl r4
     460:	4f0f0000 	svcmi	0x000f0000
     464:	03000003 	movweq	r0, #3
     468:	04091430 	streq	r1, [r9], #-1072	; 0xfffffbd0
     46c:	01d40000 	bicseq	r0, r4, r0
     470:	51010000 	mrspl	r0, (UNDEF: 1)
     474:	5c000003 	stcpl	0, cr0, [r0], {3}
     478:	10000003 	andne	r0, r0, r3
     47c:	000003b9 			; <UNDEFINED> instruction: 0x000003b9
     480:	00004811 	andeq	r4, r0, r1, lsl r8
     484:	4a120000 	bmi	48048c <_bss_end+0x47491c>
     488:	03000006 	movweq	r0, #6
     48c:	02ac0a33 	adceq	r0, ip, #208896	; 0x33000
     490:	71010000 	mrsvc	r0, (UNDEF: 1)
     494:	81000003 	tsthi	r0, r3
     498:	10000003 	andne	r0, r0, r3
     49c:	000003ca 	andeq	r0, r0, sl, asr #7
     4a0:	00004811 	andeq	r4, r0, r1, lsl r8
     4a4:	03b21100 			; <UNDEFINED> instruction: 0x03b21100
     4a8:	13000000 	movwne	r0, #0
     4ac:	000004ba 			; <UNDEFINED> instruction: 0x000004ba
     4b0:	550a3603 	strpl	r3, [sl, #-1539]	; 0xfffff9fd
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
     4f8:	ca050000 	bgt	140500 <_bss_end+0x134990>
     4fc:	16000003 	strne	r0, [r0], -r3
     500:	000004b4 			; <UNDEFINED> instruction: 0x000004b4
     504:	1d163a03 	vldrne	s6, [r6, #-12]
     508:	17000002 	strne	r0, [r0, -r2]
     50c:	000003d5 	ldrdeq	r0, [r0], -r5
     510:	050f0401 	streq	r0, [pc, #-1025]	; 117 <CPSR_IRQ_INHIBIT+0x97>
     514:	00ab1403 	adceq	r1, fp, r3, lsl #8
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
     594:	480e6501 	stmdami	lr, {r0, r8, sl, sp, lr}
     598:	02000000 	andeq	r0, r0, #0
     59c:	621e7491 	andsvs	r7, lr, #-1862270976	; 0x91000000
     5a0:	01007469 	tsteq	r0, r9, ror #8
     5a4:	00481365 	subeq	r1, r8, r5, ror #6
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
     5f8:	00480e5c 	subeq	r0, r8, ip, asr lr
     5fc:	91020000 	mrsls	r0, (UNDEF: 2)
     600:	69621e74 	stmdbvs	r2!, {r2, r4, r5, r6, r9, sl, fp, ip}^
     604:	5c010074 	stcpl	0, cr0, [r1], {116}	; 0x74
     608:	00004813 	andeq	r4, r0, r3, lsl r8
     60c:	70910200 	addsvc	r0, r1, r0, lsl #4
     610:	03381b00 	teqeq	r8, #0, 22
     614:	51010000 	mrspl	r0, (UNDEF: 1)
     618:	00050110 	andeq	r0, r5, r0, lsl r1
     61c:	00847400 	addeq	r7, r4, r0, lsl #8
     620:	00007400 	andeq	r7, r0, r0, lsl #8
     624:	3b9c0100 	blcc	fe700a2c <_bss_end+0xfe6f4ebc>
     628:	1c000005 	stcne	0, cr0, [r0], {5}
     62c:	00000582 	andeq	r0, r0, r2, lsl #11
     630:	000003bf 			; <UNDEFINED> instruction: 0x000003bf
     634:	1d6c9102 	stfnep	f1, [ip, #-8]!
     638:	006e6970 	rsbeq	r6, lr, r0, ror r9
     63c:	483a5101 	ldmdami	sl!, {r0, r8, ip, lr}
     640:	02000000 	andeq	r0, r0, #0
     644:	721e6891 	andsvc	r6, lr, #9502720	; 0x910000
     648:	01006765 	tsteq	r0, r5, ror #14
     64c:	00480e53 	subeq	r0, r8, r3, asr lr
     650:	91020000 	mrsls	r0, (UNDEF: 2)
     654:	69621e74 	stmdbvs	r2!, {r2, r4, r5, r6, r9, sl, fp, ip}^
     658:	53010074 	movwpl	r0, #4212	; 0x1074
     65c:	00004813 	andeq	r4, r0, r3, lsl r8
     660:	70910200 	addsvc	r0, r1, r0, lsl #4
     664:	03131b00 	tsteq	r3, #0, 22
     668:	42010000 	andmi	r0, r1, #0
     66c:	00055506 	andeq	r5, r5, r6, lsl #10
     670:	0083ac00 	addeq	sl, r3, r0, lsl #24
     674:	0000c800 	andeq	ip, r0, r0, lsl #16
     678:	bb9c0100 	bllt	fe700a80 <_bss_end+0xfe6f4f10>
     67c:	1c000005 	stcne	0, cr0, [r0], {5}
     680:	00000582 	andeq	r0, r0, r2, lsl #11
     684:	000003d0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     688:	1d649102 	stfnep	f1, [r4, #-8]!
     68c:	006e6970 	rsbeq	r6, lr, r0, ror r9
     690:	48304201 	ldmdami	r0!, {r0, r9, lr}
     694:	02000000 	andeq	r0, r0, #0
     698:	4a1a6091 	bmi	6988e4 <_bss_end+0x68cd74>
     69c:	01000003 	tsteq	r0, r3
     6a0:	01d44442 	bicseq	r4, r4, r2, asr #8
     6a4:	91020000 	mrsls	r0, (UNDEF: 2)
     6a8:	65721e5c 	ldrbvs	r1, [r2, #-3676]!	; 0xfffff1a4
     6ac:	44010067 	strmi	r0, [r1], #-103	; 0xffffff99
     6b0:	0000480e 	andeq	r4, r0, lr, lsl #16
     6b4:	6c910200 	lfmvs	f0, 4, [r1], {0}
     6b8:	7469621e 	strbtvc	r6, [r9], #-542	; 0xfffffde2
     6bc:	13440100 	movtne	r0, #16640	; 0x4100
     6c0:	00000048 	andeq	r0, r0, r8, asr #32
     6c4:	1f689102 	svcne	0x00689102
     6c8:	0000053f 	andeq	r0, r0, pc, lsr r5
     6cc:	59124801 	ldmdbpl	r2, {r0, fp, lr}
     6d0:	02000000 	andeq	r0, r0, #0
     6d4:	721e7491 	andsvc	r7, lr, #-1862270976	; 0x91000000
     6d8:	4a010064 	bmi	40870 <_bss_end+0x34d00>
     6dc:	00005912 	andeq	r5, r0, r2, lsl r9
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
     7f4:	0b9c0100 	bleq	fe700bfc <_bss_end+0xfe6f508c>
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
     884:	0006b400 	andeq	fp, r6, r0, lsl #8
     888:	1f000400 	svcne	0x00000400
     88c:	04000003 	streq	r0, [r0], #-3
     890:	00000001 	andeq	r0, r0, r1
     894:	08d50400 	ldmeq	r5, {sl}^
     898:	00b60000 	adcseq	r0, r6, r0
	...
     8a4:	03cd0000 	biceq	r0, sp, #0
     8a8:	ce020000 	cdpgt	0, 0, cr0, cr2, cr0, {0}
     8ac:	18000007 	stmdane	r0, {r0, r1, r2}
     8b0:	66070302 	strvs	r0, [r7], -r2, lsl #6
     8b4:	03000002 	movweq	r0, #2
     8b8:	0000072a 	andeq	r0, r0, sl, lsr #14
     8bc:	02660407 	rsbeq	r0, r6, #117440512	; 0x7000000
     8c0:	06020000 	streq	r0, [r2], -r0
     8c4:	00520110 	subseq	r0, r2, r0, lsl r1
     8c8:	48040000 	stmdami	r4, {}	; <UNPREDICTABLE>
     8cc:	10005845 	andne	r5, r0, r5, asr #16
     8d0:	43454404 	movtmi	r4, #21508	; 0x5404
     8d4:	05000a00 	streq	r0, [r0, #-2560]	; 0xfffff600
     8d8:	00000032 	andeq	r0, r0, r2, lsr r0
     8dc:	00073706 	andeq	r3, r7, r6, lsl #14
     8e0:	24020800 	strcs	r0, [r2], #-2048	; 0xfffff800
     8e4:	00007b0c 	andeq	r7, r0, ip, lsl #22
     8e8:	00790700 	rsbseq	r0, r9, r0, lsl #14
     8ec:	66162602 	ldrvs	r2, [r6], -r2, lsl #12
     8f0:	00000002 	andeq	r0, r0, r2
     8f4:	02007807 	andeq	r7, r0, #458752	; 0x70000
     8f8:	02661627 	rsbeq	r1, r6, #40894464	; 0x2700000
     8fc:	00040000 	andeq	r0, r4, r0
     900:	0008ab08 	andeq	sl, r8, r8, lsl #22
     904:	1b0c0200 	blne	30110c <_bss_end+0x2f559c>
     908:	00000052 	andeq	r0, r0, r2, asr r0
     90c:	1e090a01 	vmlane.f32	s0, s18, s2
     910:	02000008 	andeq	r0, r0, #8
     914:	0278280d 	rsbseq	r2, r8, #851968	; 0xd0000
     918:	0a010000 	beq	40920 <_bss_end+0x34db0>
     91c:	000007ce 	andeq	r0, r0, lr, asr #15
     920:	980e1002 	stmdals	lr, {r1, ip}
     924:	89000008 	stmdbhi	r0, {r3}
     928:	01000002 	tsteq	r0, r2
     92c:	000000af 	andeq	r0, r0, pc, lsr #1
     930:	000000c4 	andeq	r0, r0, r4, asr #1
     934:	0002890b 	andeq	r8, r2, fp, lsl #18
     938:	02660c00 	rsbeq	r0, r6, #0, 24
     93c:	660c0000 	strvs	r0, [ip], -r0
     940:	0c000002 	stceq	0, cr0, [r0], {2}
     944:	00000266 	andeq	r0, r0, r6, ror #4
     948:	0ac30d00 	beq	ff0c3d50 <_bss_end+0xff0b81e0>
     94c:	12020000 	andne	r0, r2, #0
     950:	0007970a 	andeq	r9, r7, sl, lsl #14
     954:	00d90100 	sbcseq	r0, r9, r0, lsl #2
     958:	00df0000 	sbcseq	r0, pc, r0
     95c:	890b0000 	stmdbhi	fp, {}	; <UNPREDICTABLE>
     960:	00000002 	andeq	r0, r0, r2
     964:	0007d70e 	andeq	sp, r7, lr, lsl #14
     968:	0f140200 	svceq	0x00140200
     96c:	0000083b 	andeq	r0, r0, fp, lsr r8
     970:	00000294 	muleq	r0, r4, r2
     974:	0000f801 	andeq	pc, r0, r1, lsl #16
     978:	00010300 	andeq	r0, r1, r0, lsl #6
     97c:	02890b00 	addeq	r0, r9, #0, 22
     980:	7d0c0000 	stcvc	0, cr0, [ip, #-0]
     984:	00000002 	andeq	r0, r0, r2
     988:	0007d70e 	andeq	sp, r7, lr, lsl #14
     98c:	0f150200 	svceq	0x00150200
     990:	000007e2 	andeq	r0, r0, r2, ror #15
     994:	00000294 	muleq	r0, r4, r2
     998:	00011c01 	andeq	r1, r1, r1, lsl #24
     99c:	00012700 	andeq	r2, r1, r0, lsl #14
     9a0:	02890b00 	addeq	r0, r9, #0, 22
     9a4:	720c0000 	andvc	r0, ip, #0
     9a8:	00000002 	andeq	r0, r0, r2
     9ac:	0007d70e 	andeq	sp, r7, lr, lsl #14
     9b0:	0f160200 	svceq	0x00160200
     9b4:	000007ac 	andeq	r0, r0, ip, lsr #15
     9b8:	00000294 	muleq	r0, r4, r2
     9bc:	00014001 	andeq	r4, r1, r1
     9c0:	00014b00 	andeq	r4, r1, r0, lsl #22
     9c4:	02890b00 	addeq	r0, r9, #0, 22
     9c8:	320c0000 	andcc	r0, ip, #0
     9cc:	00000000 	andeq	r0, r0, r0
     9d0:	0007d70e 	andeq	sp, r7, lr, lsl #14
     9d4:	0f170200 	svceq	0x00170200
     9d8:	0000086a 	andeq	r0, r0, sl, ror #16
     9dc:	00000294 	muleq	r0, r4, r2
     9e0:	00016401 	andeq	r6, r1, r1, lsl #8
     9e4:	00016f00 	andeq	r6, r1, r0, lsl #30
     9e8:	02890b00 	addeq	r0, r9, #0, 22
     9ec:	660c0000 	strvs	r0, [ip], -r0
     9f0:	00000002 	andeq	r0, r0, r2
     9f4:	0007d70e 	andeq	sp, r7, lr, lsl #14
     9f8:	0f180200 	svceq	0x00180200
     9fc:	0000082a 	andeq	r0, r0, sl, lsr #16
     a00:	00000294 	muleq	r0, r4, r2
     a04:	00018801 	andeq	r8, r1, r1, lsl #16
     a08:	00019300 	andeq	r9, r1, r0, lsl #6
     a0c:	02890b00 	addeq	r0, r9, #0, 22
     a10:	9a0c0000 	bls	300a18 <_bss_end+0x2f4ea8>
     a14:	00000002 	andeq	r0, r0, r2
     a18:	00071c0f 	andeq	r1, r7, pc, lsl #24
     a1c:	111b0200 	tstne	fp, r0, lsl #4
     a20:	000006ec 	andeq	r0, r0, ip, ror #13
     a24:	000001a7 	andeq	r0, r0, r7, lsr #3
     a28:	000001ad 	andeq	r0, r0, sp, lsr #3
     a2c:	0002890b 	andeq	r8, r2, fp, lsl #18
     a30:	0f0f0000 	svceq	0x000f0000
     a34:	02000007 	andeq	r0, r0, #7
     a38:	087b111c 	ldmdaeq	fp!, {r2, r3, r4, r8, ip}^
     a3c:	01c10000 	biceq	r0, r1, r0
     a40:	01c70000 	biceq	r0, r7, r0
     a44:	890b0000 	stmdbhi	fp, {}	; <UNPREDICTABLE>
     a48:	00000002 	andeq	r0, r0, r2
     a4c:	0006c70f 	andeq	ip, r6, pc, lsl #14
     a50:	111d0200 	tstne	sp, r0, lsl #4
     a54:	00000741 	andeq	r0, r0, r1, asr #14
     a58:	000001db 	ldrdeq	r0, [r0], -fp
     a5c:	000001e1 	andeq	r0, r0, r1, ror #3
     a60:	0002890b 	andeq	r8, r2, fp, lsl #18
     a64:	ac0f0000 	stcge	0, cr0, [pc], {-0}
     a68:	02000006 	andeq	r0, r0, #6
     a6c:	08540a1f 	ldmdaeq	r4, {r0, r1, r2, r3, r4, r9, fp}^
     a70:	01f50000 	mvnseq	r0, r0
     a74:	01fb0000 	mvnseq	r0, r0
     a78:	890b0000 	stmdbhi	fp, {}	; <UNPREDICTABLE>
     a7c:	00000002 	andeq	r0, r0, r2
     a80:	00070a0f 	andeq	r0, r7, pc, lsl #20
     a84:	0a210200 	beq	84128c <_bss_end+0x83571c>
     a88:	000007f5 	strdeq	r0, [r0], -r5
     a8c:	0000020f 	andeq	r0, r0, pc, lsl #4
     a90:	00000224 	andeq	r0, r0, r4, lsr #4
     a94:	0002890b 	andeq	r8, r2, fp, lsl #18
     a98:	02660c00 	rsbeq	r0, r6, #0, 24
     a9c:	a10c0000 	mrsge	r0, (UNDEF: 12)
     aa0:	0c000002 	stceq	0, cr0, [r0], {2}
     aa4:	00000266 	andeq	r0, r0, r6, ror #4
     aa8:	07631000 	strbeq	r1, [r3, -r0]!
     aac:	2b020000 	blcs	80ab4 <_bss_end+0x74f44>
     ab0:	0002ad23 	andeq	sl, r2, r3, lsr #26
     ab4:	4c100000 	ldcmi	0, cr0, [r0], {-0}
     ab8:	02000008 	andeq	r0, r0, #8
     abc:	0266122c 	rsbeq	r1, r6, #44, 4	; 0xc0000002
     ac0:	10040000 	andne	r0, r4, r0
     ac4:	0000080c 	andeq	r0, r0, ip, lsl #16
     ac8:	66122d02 	ldrvs	r2, [r2], -r2, lsl #26
     acc:	08000002 	stmdaeq	r0, {r1}
     ad0:	00081510 	andeq	r1, r8, r0, lsl r5
     ad4:	0f2e0200 	svceq	0x002e0200
     ad8:	00000057 	andeq	r0, r0, r7, asr r0
     adc:	06b9100c 	ldrteq	r1, [r9], ip
     ae0:	2f020000 	svccs	0x00020000
     ae4:	00003212 	andeq	r3, r0, r2, lsl r2
     ae8:	11001400 	tstne	r0, r0, lsl #8
     aec:	1e620704 	cdpne	7, 6, cr0, cr2, cr4, {0}
     af0:	66050000 	strvs	r0, [r5], -r0
     af4:	12000002 	andne	r0, r0, #2
     af8:	00028404 	andeq	r8, r2, r4, lsl #8
     afc:	02720500 	rsbseq	r0, r2, #0, 10
     b00:	01110000 	tsteq	r1, r0
     b04:	0004a008 	andeq	sl, r4, r8
     b08:	027d0500 	rsbseq	r0, sp, #0, 10
     b0c:	04120000 	ldreq	r0, [r2], #-0
     b10:	00000025 	andeq	r0, r0, r5, lsr #32
     b14:	00028905 	andeq	r8, r2, r5, lsl #18
     b18:	25041300 	strcs	r1, [r4, #-768]	; 0xfffffd00
     b1c:	11000000 	mrsne	r0, (UNDEF: 0)
     b20:	03320201 	teqeq	r2, #268435456	; 0x10000000
     b24:	04120000 	ldreq	r0, [r2], #-0
     b28:	0000027d 	andeq	r0, r0, sp, ror r2
     b2c:	02b90412 	adcseq	r0, r9, #301989888	; 0x12000000
     b30:	a7050000 	strge	r0, [r5, -r0]
     b34:	11000002 	tstne	r0, r2
     b38:	04970801 	ldreq	r0, [r7], #2049	; 0x801
     b3c:	b2140000 	andslt	r0, r4, #0
     b40:	15000002 	strne	r0, [r0, #-2]
     b44:	0000077c 	andeq	r0, r0, ip, ror r7
     b48:	25113202 	ldrcs	r3, [r1, #-514]	; 0xfffffdfe
     b4c:	16000000 	strne	r0, [r0], -r0
     b50:	000002be 			; <UNDEFINED> instruction: 0x000002be
     b54:	050a0301 	streq	r0, [sl, #-769]	; 0xfffffcff
     b58:	00ab1803 	adceq	r1, fp, r3, lsl #16
     b5c:	076d1700 	strbeq	r1, [sp, -r0, lsl #14]!
     b60:	8ce00000 	stclhi	0, cr0, [r0]
     b64:	001c0000 	andseq	r0, ip, r0
     b68:	9c010000 	stcls	0, cr0, [r1], {-0}
     b6c:	00054f18 	andeq	r4, r5, r8, lsl pc
     b70:	008c8800 	addeq	r8, ip, r0, lsl #16
     b74:	00005800 	andeq	r5, r0, r0, lsl #16
     b78:	199c0100 	ldmibne	ip, {r8}
     b7c:	19000003 	stmdbne	r0, {r0, r1}
     b80:	00000432 	andeq	r0, r0, r2, lsr r4
     b84:	1901a201 	stmdbne	r1, {r0, r9, sp, pc}
     b88:	02000003 	andeq	r0, r0, #3
     b8c:	ed197491 	cfldrs	mvf7, [r9, #-580]	; 0xfffffdbc
     b90:	01000005 	tsteq	r0, r5
     b94:	031901a2 	tsteq	r9, #-2147483608	; 0x80000028
     b98:	91020000 	mrsls	r0, (UNDEF: 2)
     b9c:	041a0070 	ldreq	r0, [sl], #-112	; 0xffffff90
     ba0:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
     ba4:	01fb1b00 	mvnseq	r1, r0, lsl #22
     ba8:	87010000 	strhi	r0, [r1, -r0]
     bac:	00033a06 	andeq	r3, r3, r6, lsl #20
     bb0:	008b0c00 	addeq	r0, fp, r0, lsl #24
     bb4:	00017c00 	andeq	r7, r1, r0, lsl #24
     bb8:	af9c0100 	svcge	0x009c0100
     bbc:	1c000003 	stcne	0, cr0, [r0], {3}
     bc0:	00000582 	andeq	r0, r0, r2, lsl #11
     bc4:	0000028f 	andeq	r0, r0, pc, lsl #5
     bc8:	19649102 	stmdbne	r4!, {r1, r8, ip, pc}^
     bcc:	000008c6 	andeq	r0, r0, r6, asr #17
     bd0:	66228701 	strtvs	r8, [r2], -r1, lsl #14
     bd4:	02000002 	andeq	r0, r0, #2
     bd8:	bf196091 	svclt	0x00196091
     bdc:	01000008 	tsteq	r0, r8
     be0:	02a12f87 	adceq	r2, r1, #540	; 0x21c
     be4:	91020000 	mrsls	r0, (UNDEF: 2)
     be8:	0b4c195c 	bleq	1307160 <_bss_end+0x12fb5f0>
     bec:	87010000 	strhi	r0, [r1, -r0]
     bf0:	00026644 	andeq	r6, r2, r4, asr #12
     bf4:	58910200 	ldmpl	r1, {r9}
     bf8:	0100691d 	tsteq	r0, sp, lsl r9
     bfc:	03190989 	tsteq	r9, #2244608	; 0x224000
     c00:	91020000 	mrsls	r0, (UNDEF: 2)
     c04:	8be01e74 	blhi	ff8085dc <_bss_end+0xff7fca6c>
     c08:	00980000 	addseq	r0, r8, r0
     c0c:	6a1d0000 	bvs	740c14 <_bss_end+0x7350a4>
     c10:	0e9c0100 	fmleqe	f0, f4, f0
     c14:	00000319 	andeq	r0, r0, r9, lsl r3
     c18:	1e709102 	expnes	f1, f2
     c1c:	00008c08 	andeq	r8, r0, r8, lsl #24
     c20:	00000060 	andeq	r0, r0, r0, rrx
     c24:	0100631d 	tsteq	r0, sp, lsl r3
     c28:	027d0e9e 	rsbseq	r0, sp, #2528	; 0x9e0
     c2c:	91020000 	mrsls	r0, (UNDEF: 2)
     c30:	0000006f 	andeq	r0, r0, pc, rrx
     c34:	00016f1b 	andeq	r6, r1, fp, lsl pc
     c38:	0b770100 	bleq	1dc1040 <_bss_end+0x1db54d0>
     c3c:	000003c9 	andeq	r0, r0, r9, asr #7
     c40:	00008aac 	andeq	r8, r0, ip, lsr #21
     c44:	00000060 	andeq	r0, r0, r0, rrx
     c48:	03e59c01 	mvneq	r9, #256	; 0x100
     c4c:	821c0000 	andshi	r0, ip, #0
     c50:	8f000005 	svchi	0x00000005
     c54:	02000002 	andeq	r0, r0, #2
     c58:	b3197491 	tstlt	r9, #-1862270976	; 0x91000000
     c5c:	01000006 	tsteq	r0, r6
     c60:	029a2577 	addseq	r2, sl, #499122176	; 0x1dc00000
     c64:	91020000 	mrsls	r0, (UNDEF: 2)
     c68:	4b1b0073 	blmi	6c0e3c <_bss_end+0x6b52cc>
     c6c:	01000001 	tsteq	r0, r1
     c70:	03ff0b6a 	mvnseq	r0, #108544	; 0x1a800
     c74:	8a580000 	bhi	1600c7c <_bss_end+0x15f510c>
     c78:	00540000 	subseq	r0, r4, r0
     c7c:	9c010000 	stcls	0, cr0, [r1], {-0}
     c80:	0000043f 	andeq	r0, r0, pc, lsr r4
     c84:	0005821c 	andeq	r8, r5, ip, lsl r2
     c88:	00028f00 	andeq	r8, r2, r0, lsl #30
     c8c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     c90:	6d756e1f 	ldclvs	14, cr6, [r5, #-124]!	; 0xffffff84
     c94:	2d6a0100 	stfcse	f0, [sl, #-0]
     c98:	00000266 	andeq	r0, r0, r6, ror #4
     c9c:	20709102 	rsbscs	r9, r0, r2, lsl #2
     ca0:	00000936 	andeq	r0, r0, r6, lsr r9
     ca4:	6d236c01 	stcvs	12, cr6, [r3, #-4]!
     ca8:	05000002 	streq	r0, [r0, #-2]
     cac:	00a91403 	adceq	r1, r9, r3, lsl #8
     cb0:	08cc2100 	stmiaeq	ip, {r8, sp}^
     cb4:	6e010000 	cdpvs	0, 0, cr0, cr1, cr0, {0}
     cb8:	00043f11 	andeq	r3, r4, r1, lsl pc
     cbc:	30030500 	andcc	r0, r3, r0, lsl #10
     cc0:	000000ab 	andeq	r0, r0, fp, lsr #1
     cc4:	00027d22 	andeq	r7, r2, r2, lsr #26
     cc8:	00044f00 	andeq	r4, r4, r0, lsl #30
     ccc:	02662300 	rsbeq	r2, r6, #0, 6
     cd0:	000f0000 	andeq	r0, pc, r0
     cd4:	00012724 	andeq	r2, r1, r4, lsr #14
     cd8:	0b630100 	bleq	18c10e0 <_bss_end+0x18b5570>
     cdc:	00000469 	andeq	r0, r0, r9, ror #8
     ce0:	00008a24 	andeq	r8, r0, r4, lsr #20
     ce4:	00000034 	andeq	r0, r0, r4, lsr r0
     ce8:	04859c01 	streq	r9, [r5], #3073	; 0xc01
     cec:	821c0000 	andshi	r0, ip, #0
     cf0:	8f000005 	svchi	0x00000005
     cf4:	02000002 	andeq	r0, r0, #2
     cf8:	bb197491 	bllt	65df44 <_bss_end+0x6523d4>
     cfc:	01000006 	tsteq	r0, r6
     d00:	00323763 	eorseq	r3, r2, r3, ror #14
     d04:	91020000 	mrsls	r0, (UNDEF: 2)
     d08:	031b0070 	tsteq	fp, #112	; 0x70
     d0c:	01000001 	tsteq	r0, r1
     d10:	049f0b57 	ldreq	r0, [pc], #2903	; d18 <CPSR_IRQ_INHIBIT+0xc98>
     d14:	89ac0000 	stmibhi	ip!, {}	; <UNPREDICTABLE>
     d18:	00780000 	rsbseq	r0, r8, r0
     d1c:	9c010000 	stcls	0, cr0, [r1], {-0}
     d20:	000004d2 	ldrdeq	r0, [r0], -r2
     d24:	0005821c 	andeq	r8, r5, ip, lsl r2
     d28:	00028f00 	andeq	r8, r2, r0, lsl #30
     d2c:	6c910200 	lfmvs	f0, 4, [r1], {0}
     d30:	7274731f 	rsbsvc	r7, r4, #2080374784	; 0x7c000000
     d34:	2c570100 	ldfcse	f0, [r7], {-0}
     d38:	00000272 	andeq	r0, r0, r2, ror r2
     d3c:	1e689102 	lgnnee	f1, f2
     d40:	000089c0 	andeq	r8, r0, r0, asr #19
     d44:	0000004c 	andeq	r0, r0, ip, asr #32
     d48:	0100691d 	tsteq	r0, sp, lsl r9
     d4c:	02661759 	rsbeq	r1, r6, #23330816	; 0x1640000
     d50:	91020000 	mrsls	r0, (UNDEF: 2)
     d54:	1b000074 	blne	f2c <CPSR_IRQ_INHIBIT+0xeac>
     d58:	000000df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
     d5c:	ec0b4501 	cfstr32	mvfx4, [fp], {1}
     d60:	04000004 	streq	r0, [r0], #-4
     d64:	a8000089 	stmdage	r0, {r0, r3, r7}
     d68:	01000000 	mrseq	r0, (UNDEF: 0)
     d6c:	0005069c 	muleq	r5, ip, r6
     d70:	05821c00 	streq	r1, [r2, #3072]	; 0xc00
     d74:	028f0000 	addeq	r0, pc, #0
     d78:	91020000 	mrsls	r0, (UNDEF: 2)
     d7c:	00631f74 	rsbeq	r1, r3, r4, ror pc
     d80:	7d254501 	cfstr32vc	mvfx4, [r5, #-4]!
     d84:	02000002 	andeq	r0, r0, #2
     d88:	24007391 	strcs	r7, [r0], #-913	; 0xfffffc6f
     d8c:	000001c7 	andeq	r0, r0, r7, asr #3
     d90:	20064001 	andcs	r4, r6, r1
     d94:	bc000005 	stclt	0, cr0, [r0], {5}
     d98:	2c00008d 	stccs	0, cr0, [r0], {141}	; 0x8d
     d9c:	01000000 	mrseq	r0, (UNDEF: 0)
     da0:	00052d9c 	muleq	r5, ip, sp
     da4:	05821c00 	streq	r1, [r2, #3072]	; 0xc00
     da8:	028f0000 	addeq	r0, pc, #0
     dac:	91020000 	mrsls	r0, (UNDEF: 2)
     db0:	e1240074 	bkpt	0x4004
     db4:	01000001 	tsteq	r0, r1
     db8:	05470630 	strbeq	r0, [r7, #-1584]	; 0xfffff9d0
     dbc:	87d40000 	ldrbhi	r0, [r4, r0]
     dc0:	01300000 	teqeq	r0, r0
     dc4:	9c010000 	stcls	0, cr0, [r1], {-0}
     dc8:	0000059d 	muleq	r0, sp, r5
     dcc:	0005821c 	andeq	r8, r5, ip, lsl r2
     dd0:	00028f00 	andeq	r8, r2, r0, lsl #30
     dd4:	64910200 	ldrvs	r0, [r1], #512	; 0x200
     dd8:	0087e425 	addeq	lr, r7, r5, lsr #8
     ddc:	0000b000 	andeq	fp, r0, r0
     de0:	00058500 	andeq	r8, r5, r0, lsl #10
     de4:	00791d00 	rsbseq	r1, r9, r0, lsl #26
     de8:	66173201 	ldrvs	r3, [r7], -r1, lsl #4
     dec:	02000002 	andeq	r0, r0, #2
     df0:	001e7491 	mulseq	lr, r1, r4
     df4:	84000088 	strhi	r0, [r0], #-136	; 0xffffff78
     df8:	1d000000 	stcne	0, cr0, [r0, #-0]
     dfc:	34010078 	strcc	r0, [r1], #-120	; 0xffffff88
     e00:	0002661b 	andeq	r6, r2, fp, lsl r6
     e04:	70910200 	addsvc	r0, r1, r0, lsl #4
     e08:	941e0000 	ldrls	r0, [lr], #-0
     e0c:	60000088 	andvs	r0, r0, r8, lsl #1
     e10:	1d000000 	stcne	0, cr0, [r0, #-0]
     e14:	3a010078 	bcc	40ffc <_bss_end+0x3548c>
     e18:	00026617 	andeq	r6, r2, r7, lsl r6
     e1c:	6c910200 	lfmvs	f0, 4, [r1], {0}
     e20:	931b0000 	tstls	fp, #0
     e24:	01000001 	tsteq	r0, r1
     e28:	05b70621 	ldreq	r0, [r7, #1569]!	; 0x621
     e2c:	8d340000 	ldchi	0, cr0, [r4, #-0]
     e30:	00880000 	addeq	r0, r8, r0
     e34:	9c010000 	stcls	0, cr0, [r1], {-0}
     e38:	000005c4 	andeq	r0, r0, r4, asr #11
     e3c:	0005821c 	andeq	r8, r5, ip, lsl r2
     e40:	00028f00 	andeq	r8, r2, r0, lsl #30
     e44:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     e48:	00c41b00 	sbceq	r1, r4, r0, lsl #22
     e4c:	14010000 	strne	r0, [r1], #-0
     e50:	0005de06 	andeq	sp, r5, r6, lsl #28
     e54:	00872c00 	addeq	r2, r7, r0, lsl #24
     e58:	0000a800 	andeq	sl, r0, r0, lsl #16
     e5c:	199c0100 	ldmibne	ip, {r8}
     e60:	1c000006 	stcne	0, cr0, [r0], {6}
     e64:	00000582 	andeq	r0, r0, r2, lsl #11
     e68:	0000028f 	andeq	r0, r0, pc, lsl #5
     e6c:	1e6c9102 	lgnnee	f1, f2
     e70:	00008744 	andeq	r8, r0, r4, asr #14
     e74:	00000084 	andeq	r0, r0, r4, lsl #1
     e78:	0100791d 	tsteq	r0, sp, lsl r9
     e7c:	02661718 	rsbeq	r1, r6, #24, 14	; 0x600000
     e80:	91020000 	mrsls	r0, (UNDEF: 2)
     e84:	87601e74 			; <UNDEFINED> instruction: 0x87601e74
     e88:	00580000 	subseq	r0, r8, r0
     e8c:	781d0000 	ldmdavc	sp, {}	; <UNPREDICTABLE>
     e90:	1b1a0100 	blne	681298 <_bss_end+0x675728>
     e94:	00000266 	andeq	r0, r0, r6, ror #4
     e98:	00709102 	rsbseq	r9, r0, r2, lsl #2
     e9c:	ad240000 	stcge	0, cr0, [r4, #-0]
     ea0:	01000001 	tsteq	r0, r1
     ea4:	0633060e 	ldrteq	r0, [r3], -lr, lsl #12
     ea8:	8cfc0000 	ldclhi	0, cr0, [ip]
     eac:	00380000 	eorseq	r0, r8, r0
     eb0:	9c010000 	stcls	0, cr0, [r1], {-0}
     eb4:	00000640 	andeq	r0, r0, r0, asr #12
     eb8:	0005821c 	andeq	r8, r5, ip, lsl r2
     ebc:	00028f00 	andeq	r8, r2, r0, lsl #30
     ec0:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     ec4:	00962600 	addseq	r2, r6, r0, lsl #12
     ec8:	05010000 	streq	r0, [r1, #-0]
     ecc:	00065101 	andeq	r5, r6, r1, lsl #2
     ed0:	067f0000 	ldrbteq	r0, [pc], -r0
     ed4:	82270000 	eorhi	r0, r7, #0
     ed8:	8f000005 	svchi	0x00000005
     edc:	28000002 	stmdacs	r0, {r1}
     ee0:	00000785 	andeq	r0, r0, r5, lsl #15
     ee4:	66210501 	strtvs	r0, [r1], -r1, lsl #10
     ee8:	28000002 	stmdacs	r0, {r1}
     eec:	0000084e 	andeq	r0, r0, lr, asr #16
     ef0:	66410501 	strbvs	r0, [r1], -r1, lsl #10
     ef4:	28000002 	stmdacs	r0, {r1}
     ef8:	0000080e 	andeq	r0, r0, lr, lsl #16
     efc:	66550501 	ldrbvs	r0, [r5], -r1, lsl #10
     f00:	00000002 	andeq	r0, r0, r2
     f04:	00064029 	andeq	r4, r6, r9, lsr #32
     f08:	0006d900 	andeq	sp, r6, r0, lsl #18
     f0c:	00069600 	andeq	r9, r6, r0, lsl #12
     f10:	0086b400 	addeq	fp, r6, r0, lsl #8
     f14:	00007800 	andeq	r7, r0, r0, lsl #16
     f18:	2a9c0100 	bcs	fe701320 <_bss_end+0xfe6f57b0>
     f1c:	00000651 	andeq	r0, r0, r1, asr r6
     f20:	2a749102 	bcs	1d25330 <_bss_end+0x1d197c0>
     f24:	0000065a 	andeq	r0, r0, sl, asr r6
     f28:	2a709102 	bcs	1c25338 <_bss_end+0x1c197c8>
     f2c:	00000666 	andeq	r0, r0, r6, ror #12
     f30:	2a6c9102 	bcs	1b25340 <_bss_end+0x1b197d0>
     f34:	00000672 	andeq	r0, r0, r2, ror r6
     f38:	00689102 	rsbeq	r9, r8, r2, lsl #2
     f3c:	00054f00 	andeq	r4, r5, r0, lsl #30
     f40:	c7000400 	strgt	r0, [r0, -r0, lsl #8]
     f44:	04000005 	streq	r0, [r0], #-5
     f48:	00000001 	andeq	r0, r0, r1
     f4c:	097b0400 	ldmdbeq	fp!, {sl}^
     f50:	00b60000 	adcseq	r0, r6, r0
     f54:	8de80000 	stclhi	0, cr0, [r8]
     f58:	02900000 	addseq	r0, r0, #0
     f5c:	07c80000 	strbeq	r0, [r8, r0]
     f60:	01020000 	mrseq	r0, (UNDEF: 2)
     f64:	0004a008 	andeq	sl, r4, r8
     f68:	05020200 	streq	r0, [r2, #-512]	; 0xfffffe00
     f6c:	00000280 	andeq	r0, r0, r0, lsl #5
     f70:	69050403 	stmdbvs	r5, {r0, r1, sl}
     f74:	0400746e 	streq	r7, [r0], #-1134	; 0xfffffb92
     f78:	00000a0e 	andeq	r0, r0, lr, lsl #20
     f7c:	46070902 	strmi	r0, [r7], -r2, lsl #18
     f80:	02000000 	andeq	r0, r0, #0
     f84:	04970801 	ldreq	r0, [r7], #2049	; 0x801
     f88:	0e040000 	cdpeq	0, 0, cr0, cr4, cr0, {0}
     f8c:	0200000b 	andeq	r0, r0, #11
     f90:	0059070a 	subseq	r0, r9, sl, lsl #14
     f94:	02020000 	andeq	r0, r2, #0
     f98:	00050207 	andeq	r0, r5, r7, lsl #4
     f9c:	03290400 			; <UNDEFINED> instruction: 0x03290400
     fa0:	0b020000 	bleq	80fa8 <_bss_end+0x75438>
     fa4:	00007107 	andeq	r7, r0, r7, lsl #2
     fa8:	00600500 	rsbeq	r0, r0, r0, lsl #10
     fac:	04020000 	streq	r0, [r2], #-0
     fb0:	001e6207 	andseq	r6, lr, r7, lsl #4
     fb4:	00710500 	rsbseq	r0, r1, r0, lsl #10
     fb8:	71060000 	mrsvc	r0, (UNDEF: 6)
     fbc:	07000000 	streq	r0, [r0, -r0]
     fc0:	006c6168 	rsbeq	r6, ip, r8, ror #2
     fc4:	410b0703 	tstmi	fp, r3, lsl #14
     fc8:	08000001 	stmdaeq	r0, {r0}
     fcc:	00000680 	andeq	r0, r0, r0, lsl #13
     fd0:	781c0903 	ldmdavc	ip, {r0, r1, r8, fp}
     fd4:	80000000 	andhi	r0, r0, r0
     fd8:	080ee6b2 	stmdaeq	lr, {r1, r4, r5, r7, r9, sl, sp, lr, pc}
     fdc:	000003e6 	andeq	r0, r0, r6, ror #7
     fe0:	4d1d0c03 	ldcmi	12, cr0, [sp, #-12]
     fe4:	00000001 	andeq	r0, r0, r1
     fe8:	08200000 	stmdaeq	r0!, {}	; <UNPREDICTABLE>
     fec:	000004c4 	andeq	r0, r0, r4, asr #9
     ff0:	4d1d0f03 	ldcmi	15, cr0, [sp, #-12]
     ff4:	00000001 	andeq	r0, r0, r1
     ff8:	09202000 	stmdbeq	r0!, {sp}
     ffc:	00000530 	andeq	r0, r0, r0, lsr r5
    1000:	6c181203 	lfmvs	f1, 4, [r8], {3}
    1004:	36000000 	strcc	r0, [r0], -r0
    1008:	00062708 	andeq	r2, r6, r8, lsl #14
    100c:	1d440300 	stclne	3, cr0, [r4, #-0]
    1010:	0000014d 	andeq	r0, r0, sp, asr #2
    1014:	20215000 	eorcs	r5, r1, r0
    1018:	00026608 	andeq	r6, r2, r8, lsl #12
    101c:	1d730300 	ldclne	3, cr0, [r3, #-0]
    1020:	0000014d 	andeq	r0, r0, sp, asr #2
    1024:	2000b200 	andcs	fp, r0, r0, lsl #4
    1028:	00054408 	andeq	r4, r5, r8, lsl #8
    102c:	1da60300 	stcne	3, cr0, [r6]
    1030:	0000014d 	andeq	r0, r0, sp, asr #2
    1034:	2000b400 	andcs	fp, r0, r0, lsl #8
    1038:	000b230a 	andeq	r2, fp, sl, lsl #6
    103c:	33040500 	movwcc	r0, #17664	; 0x4500
    1040:	03000000 	movweq	r0, #0
    1044:	700b10a8 	andvc	r1, fp, r8, lsr #1
    1048:	0000000b 	andeq	r0, r0, fp
    104c:	000af60b 	andeq	pc, sl, fp, lsl #12
    1050:	7c0b0100 	stfvcs	f0, [fp], {-0}
    1054:	0200000f 	andeq	r0, r0, #15
    1058:	000abf0b 	andeq	fp, sl, fp, lsl #30
    105c:	e80b0300 	stmda	fp, {r8, r9}
    1060:	0400000b 	streq	r0, [r0], #-11
    1064:	0009fd0b 	andeq	pc, r9, fp, lsl #26
    1068:	e90b0500 	stmdb	fp, {r8, sl}
    106c:	06000009 	streq	r0, [r0], -r9
    1070:	000b170b 	andeq	r1, fp, fp, lsl #14
    1074:	b60b0700 	strlt	r0, [fp], -r0, lsl #14
    1078:	0800000b 	stmdaeq	r0, {r0, r1, r3}
    107c:	8e0c0000 	cdphi	0, 0, cr0, cr12, cr0, {0}
    1080:	02000000 	andeq	r0, r0, #0
    1084:	1e5d0704 	cdpne	7, 5, cr0, cr13, cr4, {0}
    1088:	46050000 	strmi	r0, [r5], -r0
    108c:	0c000001 	stceq	0, cr0, [r0], {1}
    1090:	0000009e 	muleq	r0, lr, r0
    1094:	0000ae0c 	andeq	sl, r0, ip, lsl #28
    1098:	00be0c00 	adcseq	r0, lr, r0, lsl #24
    109c:	cb0c0000 	blgt	3010a4 <_bss_end+0x2f5534>
    10a0:	0c000000 	stceq	0, cr0, [r0], {-0}
    10a4:	000000db 	ldrdeq	r0, [r0], -fp
    10a8:	0000eb0c 	andeq	lr, r0, ip, lsl #22
    10ac:	0a770d00 	beq	1dc44b4 <_bss_end+0x1db8944>
    10b0:	01070000 	mrseq	r0, (UNDEF: 7)
    10b4:	0000003a 	andeq	r0, r0, sl, lsr r0
    10b8:	950c0604 	strls	r0, [ip, #-1540]	; 0xfffff9fc
    10bc:	0b000001 	bleq	10c8 <CPSR_IRQ_INHIBIT+0x1048>
    10c0:	00000a9f 	muleq	r0, pc, sl	; <UNPREDICTABLE>
    10c4:	0ac90b00 	beq	ff243ccc <_bss_end+0xff23815c>
    10c8:	0b010000 	bleq	410d0 <_bss_end+0x35560>
    10cc:	00000a4f 	andeq	r0, r0, pc, asr #20
    10d0:	750e0002 	strvc	r0, [lr, #-2]
    10d4:	0800000b 	stmdaeq	r0, {r0, r1, r3}
    10d8:	8d070d04 	stchi	13, cr0, [r7, #-16]
    10dc:	0f000002 	svceq	0x00000002
    10e0:	00000aea 	andeq	r0, r0, sl, ror #21
    10e4:	8d1c1504 	cfldr32hi	mvfx1, [ip, #-16]
    10e8:	00000002 	andeq	r0, r0, r2
    10ec:	000bd810 	andeq	sp, fp, r0, lsl r8
    10f0:	0b110400 	bleq	4420f8 <_bss_end+0x436588>
    10f4:	00000293 	muleq	r0, r3, r2
    10f8:	0b7c0f01 	bleq	1f04d04 <_bss_end+0x1ef9194>
    10fc:	18040000 	stmdane	r4, {}	; <UNPREDICTABLE>
    1100:	0001af15 	andeq	sl, r1, r5, lsl pc
    1104:	f1110400 			; <UNDEFINED> instruction: 0xf1110400
    1108:	0400000a 	streq	r0, [r0], #-10
    110c:	0b861c1b 	bleq	fe188180 <_bss_end+0xfe17c610>
    1110:	029a0000 	addseq	r0, sl, #0
    1114:	e2020000 	and	r0, r2, #0
    1118:	ed000001 	stc	0, cr0, [r0, #-4]
    111c:	12000001 	andne	r0, r0, #1
    1120:	000002a0 	andeq	r0, r0, r0, lsr #5
    1124:	0000fb13 	andeq	pc, r0, r3, lsl fp	; <UNPREDICTABLE>
    1128:	75110000 	ldrvc	r0, [r1, #-0]
    112c:	0400000b 	streq	r0, [r0], #-11
    1130:	0ba7051e 	bleq	fe9c25b0 <_bss_end+0xfe9b6a40>
    1134:	02a00000 	adceq	r0, r0, #0
    1138:	06010000 	streq	r0, [r1], -r0
    113c:	11000002 	tstne	r0, r2
    1140:	12000002 	andne	r0, r0, #2
    1144:	000002a0 	andeq	r0, r0, r0, lsr #5
    1148:	00014613 	andeq	r4, r1, r3, lsl r6
    114c:	85140000 	ldrhi	r0, [r4, #-0]
    1150:	0400000e 	streq	r0, [r0], #-14
    1154:	0a5d0a21 	beq	17439e0 <_bss_end+0x1737e70>
    1158:	26010000 	strcs	r0, [r1], -r0
    115c:	3b000002 	blcc	116c <CPSR_IRQ_INHIBIT+0x10ec>
    1160:	12000002 	andne	r0, r0, #2
    1164:	000002a0 	andeq	r0, r0, r0, lsr #5
    1168:	0001af13 	andeq	sl, r1, r3, lsl pc
    116c:	00711300 	rsbseq	r1, r1, r0, lsl #6
    1170:	70130000 	andsvc	r0, r3, r0
    1174:	00000001 	andeq	r0, r0, r1
    1178:	000f3314 	andeq	r3, pc, r4, lsl r3	; <UNPREDICTABLE>
    117c:	0a230400 	beq	8c2184 <_bss_end+0x8b6614>
    1180:	00000b2d 	andeq	r0, r0, sp, lsr #22
    1184:	00025001 	andeq	r5, r2, r1
    1188:	00025600 	andeq	r5, r2, r0, lsl #12
    118c:	02a01200 	adceq	r1, r0, #0, 4
    1190:	14000000 	strne	r0, [r0], #-0
    1194:	000009f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    1198:	f00a2604 			; <UNDEFINED> instruction: 0xf00a2604
    119c:	0100000b 	tsteq	r0, fp
    11a0:	0000026b 	andeq	r0, r0, fp, ror #4
    11a4:	00000271 	andeq	r0, r0, r1, ror r2
    11a8:	0002a012 	andeq	sl, r2, r2, lsl r0
    11ac:	c3150000 	tstgt	r5, #0
    11b0:	0400000b 	streq	r0, [r0], #-11
    11b4:	09580a28 	ldmdbeq	r8, {r3, r5, r9, fp}^
    11b8:	02ab0000 	adceq	r0, fp, #0
    11bc:	86010000 	strhi	r0, [r1], -r0
    11c0:	12000002 	andne	r0, r0, #2
    11c4:	000002a0 	andeq	r0, r0, r0, lsr #5
    11c8:	04160000 	ldreq	r0, [r6], #-0
    11cc:	0000007d 	andeq	r0, r0, sp, ror r0
    11d0:	02990416 	addseq	r0, r9, #369098752	; 0x16000000
    11d4:	18170000 	ldmdane	r7, {}	; <UNPREDICTABLE>
    11d8:	00007d04 	andeq	r7, r0, r4, lsl #26
    11dc:	95041600 	strls	r1, [r4, #-1536]	; 0xfffffa00
    11e0:	05000001 	streq	r0, [r0, #-1]
    11e4:	000002a0 	andeq	r0, r0, r0, lsr #5
    11e8:	32020102 	andcc	r0, r2, #-2147483648	; 0x80000000
    11ec:	19000003 	stmdbne	r0, {r0, r1}
    11f0:	00000951 	andeq	r0, r0, r1, asr r9
    11f4:	950f2b04 	strls	r2, [pc, #-2820]	; 6f8 <CPSR_IRQ_INHIBIT+0x678>
    11f8:	1a000001 	bne	1204 <CPSR_IRQ_INHIBIT+0x1184>
    11fc:	000002b2 			; <UNDEFINED> instruction: 0x000002b2
    1200:	05080401 	streq	r0, [r8, #-1025]	; 0xfffffbff
    1204:	00ab4003 	adceq	r4, fp, r3
    1208:	0b5f1b00 	bleq	17c7e10 <_bss_end+0x17bc2a0>
    120c:	01060000 	mrseq	r0, (UNDEF: 6)
    1210:	039a0808 	orrseq	r0, sl, #8, 16	; 0x80000
    1214:	161c0000 	ldrne	r0, [ip], -r0
    1218:	0100000a 	tsteq	r0, sl
    121c:	003a0d0a 	eorseq	r0, sl, sl, lsl #26
    1220:	01010000 	mrseq	r0, (UNDEF: 1)
    1224:	431c0007 	tstmi	ip, #7
    1228:	0100000a 	tsteq	r0, sl
    122c:	003a0d0b 	eorseq	r0, sl, fp, lsl #26
    1230:	01010000 	mrseq	r0, (UNDEF: 1)
    1234:	951c0006 	ldrls	r0, [ip, #-6]
    1238:	0100000a 	tsteq	r0, sl
    123c:	003a0d0c 	eorseq	r0, sl, ip, lsl #26
    1240:	02010000 	andeq	r0, r1, #0
    1244:	1f1c0004 	svcne	0x001c0004
    1248:	0100000a 	tsteq	r0, sl
    124c:	003a0d0d 	eorseq	r0, sl, sp, lsl #26
    1250:	01010000 	mrseq	r0, (UNDEF: 1)
    1254:	fc1c0003 	ldc2	0, cr0, [ip], {3}
    1258:	0100000a 	tsteq	r0, sl
    125c:	003a0d0e 	eorseq	r0, sl, lr, lsl #26
    1260:	01010000 	mrseq	r0, (UNDEF: 1)
    1264:	281c0002 	ldmdacs	ip, {r1}
    1268:	0100000a 	tsteq	r0, sl
    126c:	003a0d0f 	eorseq	r0, sl, pc, lsl #26
    1270:	01010000 	mrseq	r0, (UNDEF: 1)
    1274:	511c0001 	tstpl	ip, r1
    1278:	0100000b 	tsteq	r0, fp
    127c:	003a0d10 	eorseq	r0, sl, r0, lsl sp
    1280:	01010000 	mrseq	r0, (UNDEF: 1)
    1284:	d61c0000 	ldrle	r0, [ip], -r0
    1288:	0100000a 	tsteq	r0, sl
    128c:	003a0d11 	eorseq	r0, sl, r1, lsl sp
    1290:	01010000 	mrseq	r0, (UNDEF: 1)
    1294:	ab1c0107 	blge	7016b8 <_bss_end+0x6f5b48>
    1298:	0100000a 	tsteq	r0, sl
    129c:	003a0d12 	eorseq	r0, sl, r2, lsl sp
    12a0:	01010000 	mrseq	r0, (UNDEF: 1)
    12a4:	311d0106 	tstcc	sp, r6, lsl #2
    12a8:	0100000a 	tsteq	r0, sl
    12ac:	004d0e13 	subeq	r0, sp, r3, lsl lr
    12b0:	0a020000 	beq	812b8 <_bss_end+0x75748>
    12b4:	881d007c 	ldmdahi	sp, {r2, r3, r4, r5, r6}
    12b8:	0100000a 	tsteq	r0, sl
    12bc:	004d0e14 	subeq	r0, sp, r4, lsl lr
    12c0:	10020000 	andne	r0, r2, r0
    12c4:	3a1c027c 	bcc	701cbc <_bss_end+0x6f614c>
    12c8:	0100000a 	tsteq	r0, sl
    12cc:	004d0e15 	subeq	r0, sp, r5, lsl lr
    12d0:	0a020000 	beq	812d8 <_bss_end+0x75768>
    12d4:	06000402 	streq	r0, [r0], -r2, lsl #8
    12d8:	000002cc 	andeq	r0, r0, ip, asr #5
    12dc:	0009421e 	andeq	r4, r9, lr, lsl r2
    12e0:	00905c00 	addseq	r5, r0, r0, lsl #24
    12e4:	00001c00 	andeq	r1, r0, r0, lsl #24
    12e8:	1f9c0100 	svcne	0x009c0100
    12ec:	0000054f 	andeq	r0, r0, pc, asr #10
    12f0:	00009008 	andeq	r9, r0, r8
    12f4:	00000054 	andeq	r0, r0, r4, asr r0
    12f8:	03e09c01 	mvneq	r9, #256	; 0x100
    12fc:	32200000 	eorcc	r0, r0, #0
    1300:	01000004 	tsteq	r0, r4
    1304:	0033014a 	eorseq	r0, r3, sl, asr #2
    1308:	91020000 	mrsls	r0, (UNDEF: 2)
    130c:	05ed2074 	strbeq	r2, [sp, #116]!	; 0x74
    1310:	4a010000 	bmi	41318 <_bss_end+0x357a8>
    1314:	00003301 	andeq	r3, r0, r1, lsl #6
    1318:	70910200 	addsvc	r0, r1, r0, lsl #4
    131c:	02712100 	rsbseq	r2, r1, #0, 2
    1320:	47010000 	strmi	r0, [r1, -r0]
    1324:	0003fa06 	andeq	pc, r3, r6, lsl #20
    1328:	008fc800 	addeq	ip, pc, r0, lsl #16
    132c:	00004000 	andeq	r4, r0, r0
    1330:	079c0100 	ldreq	r0, [ip, r0, lsl #2]
    1334:	22000004 	andcs	r0, r0, #4
    1338:	00000582 	andeq	r0, r0, r2, lsl #11
    133c:	000002a6 	andeq	r0, r0, r6, lsr #5
    1340:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1344:	00025621 	andeq	r5, r2, r1, lsr #12
    1348:	063f0100 	ldrteq	r0, [pc], -r0, lsl #2
    134c:	00000421 	andeq	r0, r0, r1, lsr #8
    1350:	00008f78 	andeq	r8, r0, r8, ror pc
    1354:	00000050 	andeq	r0, r0, r0, asr r0
    1358:	042e9c01 	strteq	r9, [lr], #-3073	; 0xfffff3ff
    135c:	82220000 	eorhi	r0, r2, #0
    1360:	a6000005 	strge	r0, [r0], -r5
    1364:	02000002 	andeq	r0, r0, #2
    1368:	21007491 			; <UNDEFINED> instruction: 0x21007491
    136c:	0000023b 	andeq	r0, r0, fp, lsr r2
    1370:	48063701 	stmdami	r6, {r0, r8, r9, sl, ip, sp}
    1374:	2c000004 	stccs	0, cr0, [r0], {4}
    1378:	4c00008f 	stcmi	0, cr0, [r0], {143}	; 0x8f
    137c:	01000000 	mrseq	r0, (UNDEF: 0)
    1380:	0004649c 	muleq	r4, ip, r4
    1384:	05822200 	streq	r2, [r2, #512]	; 0x200
    1388:	02a60000 	adceq	r0, r6, #0
    138c:	91020000 	mrsls	r0, (UNDEF: 2)
    1390:	6572236c 	ldrbvs	r2, [r2, #-876]!	; 0xfffffc94
    1394:	39010067 	stmdbcc	r1, {r0, r1, r2, r5, r6}
    1398:	00046420 	andeq	r6, r4, r0, lsr #8
    139c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    13a0:	9a041800 	bls	1073a8 <_bss_end+0xfb838>
    13a4:	21000003 	tstcs	r0, r3
    13a8:	00000211 	andeq	r0, r0, r1, lsl r2
    13ac:	84062601 	strhi	r2, [r6], #-1537	; 0xfffff9ff
    13b0:	60000004 	andvs	r0, r0, r4
    13b4:	cc00008e 	stcgt	0, cr0, [r0], {142}	; 0x8e
    13b8:	01000000 	mrseq	r0, (UNDEF: 0)
    13bc:	0004cd9c 	muleq	r4, ip, sp
    13c0:	05822200 	streq	r2, [r2, #512]	; 0x200
    13c4:	02a60000 	adceq	r0, r6, #0
    13c8:	91020000 	mrsls	r0, (UNDEF: 2)
    13cc:	0c0b2064 	stceq	0, cr2, [fp], {100}	; 0x64
    13d0:	26010000 	strcs	r0, [r1], -r0
    13d4:	0001af25 	andeq	sl, r1, r5, lsr #30
    13d8:	60910200 	addsvs	r0, r1, r0, lsl #4
    13dc:	000a0820 	andeq	r0, sl, r0, lsr #16
    13e0:	3c260100 	stfccs	f0, [r6], #-0
    13e4:	00000071 	andeq	r0, r0, r1, ror r0
    13e8:	205c9102 	subscs	r9, ip, r2, lsl #2
    13ec:	00000a95 	muleq	r0, r5, sl
    13f0:	70542601 	subsvc	r2, r4, r1, lsl #12
    13f4:	02000001 	andeq	r0, r0, #1
    13f8:	72235b91 	eorvc	r5, r3, #148480	; 0x24400
    13fc:	01006765 	tsteq	r0, r5, ror #14
    1400:	02cc162a 	sbceq	r1, ip, #44040192	; 0x2a00000
    1404:	91020000 	mrsls	r0, (UNDEF: 2)
    1408:	c9240068 	stmdbgt	r4!, {r3, r5, r6}
    140c:	01000001 	tsteq	r0, r1
    1410:	04e71821 	strbteq	r1, [r7], #2081	; 0x821
    1414:	8e280000 	cdphi	0, 2, cr0, cr8, cr0, {0}
    1418:	00380000 	eorseq	r0, r8, r0
    141c:	9c010000 	stcls	0, cr0, [r1], {-0}
    1420:	00000503 	andeq	r0, r0, r3, lsl #10
    1424:	00058222 	andeq	r8, r5, r2, lsr #4
    1428:	0002a600 	andeq	sl, r2, r0, lsl #12
    142c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1430:	67657225 	strbvs	r7, [r5, -r5, lsr #4]!
    1434:	34210100 	strtcc	r0, [r1], #-256	; 0xffffff00
    1438:	000000fb 	strdeq	r0, [r0], -fp
    143c:	00709102 	rsbseq	r9, r0, r2, lsl #2
    1440:	0001ed26 	andeq	lr, r1, r6, lsr #26
    1444:	011a0100 	tsteq	sl, r0, lsl #2
    1448:	00000514 	andeq	r0, r0, r4, lsl r5
    144c:	00052a00 	andeq	r2, r5, r0, lsl #20
    1450:	05822700 	streq	r2, [r2, #1792]	; 0x700
    1454:	02a60000 	adceq	r0, r6, #0
    1458:	42280000 	eormi	r0, r8, #0
    145c:	0100000b 	tsteq	r0, fp
    1460:	01461e1a 	cmpeq	r6, sl, lsl lr
    1464:	29000000 	stmdbcs	r0, {}	; <UNPREDICTABLE>
    1468:	00000503 	andeq	r0, r0, r3, lsl #10
    146c:	000009da 	ldrdeq	r0, [r0], -sl
    1470:	00000541 	andeq	r0, r0, r1, asr #10
    1474:	00008de8 	andeq	r8, r0, r8, ror #27
    1478:	00000040 	andeq	r0, r0, r0, asr #32
    147c:	142a9c01 	strtne	r9, [sl], #-3073	; 0xfffff3ff
    1480:	02000005 	andeq	r0, r0, #5
    1484:	1d2a7491 	cfstrsne	mvf7, [sl, #-580]!	; 0xfffffdbc
    1488:	02000005 	andeq	r0, r0, #5
    148c:	00007091 	muleq	r0, r1, r0
    1490:	00000697 	muleq	r0, r7, r6
    1494:	086f0004 	stmdaeq	pc!, {r2}^	; <UNPREDICTABLE>
    1498:	01040000 	mrseq	r0, (UNDEF: 4)
    149c:	00000000 	andeq	r0, r0, r0
    14a0:	000fb504 	andeq	fp, pc, r4, lsl #10
    14a4:	0000b600 	andeq	fp, r0, r0, lsl #12
    14a8:	00907800 	addseq	r7, r0, r0, lsl #16
    14ac:	00025c00 	andeq	r5, r2, r0, lsl #24
    14b0:	0009c200 	andeq	ip, r9, r0, lsl #4
    14b4:	08010200 	stmdaeq	r1, {r9}
    14b8:	000004a0 	andeq	r0, r0, r0, lsr #9
    14bc:	80050202 	andhi	r0, r5, r2, lsl #4
    14c0:	03000002 	movweq	r0, #2
    14c4:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
    14c8:	0e040074 	mcreq	0, 0, r0, cr4, cr4, {3}
    14cc:	0200000a 	andeq	r0, r0, #10
    14d0:	00460709 	subeq	r0, r6, r9, lsl #14
    14d4:	01020000 	mrseq	r0, (UNDEF: 2)
    14d8:	00049708 	andeq	r9, r4, r8, lsl #14
    14dc:	07020200 	streq	r0, [r2, -r0, lsl #4]
    14e0:	00000502 	andeq	r0, r0, r2, lsl #10
    14e4:	00032904 	andeq	r2, r3, r4, lsl #18
    14e8:	070b0200 	streq	r0, [fp, -r0, lsl #4]
    14ec:	00000065 	andeq	r0, r0, r5, rrx
    14f0:	00005405 	andeq	r5, r0, r5, lsl #8
    14f4:	07040200 	streq	r0, [r4, -r0, lsl #4]
    14f8:	00001e62 	andeq	r1, r0, r2, ror #28
    14fc:	00006505 	andeq	r6, r0, r5, lsl #10
    1500:	00650600 	rsbeq	r0, r5, r0, lsl #12
    1504:	68070000 	stmdavs	r7, {}	; <UNPREDICTABLE>
    1508:	03006c61 	movweq	r6, #3169	; 0xc61
    150c:	02280b07 	eoreq	r0, r8, #7168	; 0x1c00
    1510:	80080000 	andhi	r0, r8, r0
    1514:	03000006 	movweq	r0, #6
    1518:	006c1c09 	rsbeq	r1, ip, r9, lsl #24
    151c:	b2800000 	addlt	r0, r0, #0
    1520:	e6080ee6 	str	r0, [r8], -r6, ror #29
    1524:	03000003 	movweq	r0, #3
    1528:	02341d0c 	eorseq	r1, r4, #12, 26	; 0x300
    152c:	00000000 	andeq	r0, r0, r0
    1530:	c4082000 	strgt	r2, [r8], #-0
    1534:	03000004 	movweq	r0, #4
    1538:	02341d0f 	eorseq	r1, r4, #960	; 0x3c0
    153c:	00000000 	andeq	r0, r0, r0
    1540:	30092020 	andcc	r2, r9, r0, lsr #32
    1544:	03000005 	movweq	r0, #5
    1548:	00601812 	rsbeq	r1, r0, r2, lsl r8
    154c:	08360000 	ldmdaeq	r6!, {}	; <UNPREDICTABLE>
    1550:	00000627 	andeq	r0, r0, r7, lsr #12
    1554:	341d4403 	ldrcc	r4, [sp], #-1027	; 0xfffffbfd
    1558:	00000002 	andeq	r0, r0, r2
    155c:	08202150 	stmdaeq	r0!, {r4, r6, r8, sp}
    1560:	00000266 	andeq	r0, r0, r6, ror #4
    1564:	341d7303 	ldrcc	r7, [sp], #-771	; 0xfffffcfd
    1568:	00000002 	andeq	r0, r0, r2
    156c:	0a2000b2 	beq	80183c <_bss_end+0x7f5ccc>
    1570:	00000cfe 	strdeq	r0, [r0], -lr
    1574:	00330405 	eorseq	r0, r3, r5, lsl #8
    1578:	75030000 	strvc	r0, [r3, #-0]
    157c:	00012e10 	andeq	r2, r1, r0, lsl lr
    1580:	0e590b00 	vnmlseq.f64	d16, d9, d0
    1584:	0b000000 	bleq	158c <CPSR_IRQ_INHIBIT+0x150c>
    1588:	00000dc9 	andeq	r0, r0, r9, asr #27
    158c:	0dd70b01 	vldreq	d16, [r7, #4]
    1590:	0b020000 	bleq	81598 <_bss_end+0x75a28>
    1594:	00000f78 	andeq	r0, r0, r8, ror pc
    1598:	0d5e0b03 	vldreq	d16, [lr, #-12]
    159c:	0b040000 	bleq	1015a4 <_bss_end+0xf5a34>
    15a0:	00000d6b 	andeq	r0, r0, fp, ror #26
    15a4:	0e7b0b05 	vaddeq.f64	d16, d11, d5
    15a8:	0b060000 	bleq	1815b0 <_bss_end+0x175a40>
    15ac:	00000d42 	andeq	r0, r0, r2, asr #26
    15b0:	0d500b07 	vldreq	d16, [r0, #-28]	; 0xffffffe4
    15b4:	0b080000 	bleq	2015bc <_bss_end+0x1f5a4c>
    15b8:	00000f29 	andeq	r0, r0, r9, lsr #30
    15bc:	e50a0009 	str	r0, [sl, #-9]
    15c0:	0500000d 	streq	r0, [r0, #-13]
    15c4:	00003304 	andeq	r3, r0, r4, lsl #6
    15c8:	10830300 	addne	r0, r3, r0, lsl #6
    15cc:	00000171 	andeq	r0, r0, r1, ror r1
    15d0:	000b760b 	andeq	r7, fp, fp, lsl #12
    15d4:	8c0b0000 	stchi	0, cr0, [fp], {-0}
    15d8:	0100000e 	tsteq	r0, lr
    15dc:	000d170b 	andeq	r1, sp, fp, lsl #14
    15e0:	290b0200 	stmdbcs	fp, {r9}
    15e4:	0300000d 	movweq	r0, #13
    15e8:	0010260b 	andseq	r2, r0, fp, lsl #12
    15ec:	6b0b0400 	blvs	2c25f4 <_bss_end+0x2b6a84>
    15f0:	0500000e 	streq	r0, [r0, #-14]
    15f4:	000e300b 	andeq	r3, lr, fp
    15f8:	410b0600 	tstmi	fp, r0, lsl #12
    15fc:	0700000e 	streq	r0, [r0, -lr]
    1600:	0cf30a00 	vldmiaeq	r3!, {s1-s0}
    1604:	04050000 	streq	r0, [r5], #-0
    1608:	00000033 	andeq	r0, r0, r3, lsr r0
    160c:	d2108f03 	andsle	r8, r0, #3, 30
    1610:	0c000001 	stceq	0, cr0, [r0], {1}
    1614:	00585541 	subseq	r5, r8, r1, asr #10
    1618:	0f5a0b1d 	svceq	0x005a0b1d
    161c:	0b2b0000 	bleq	ac1624 <_bss_end+0xab5ab4>
    1620:	00000df6 	strdeq	r0, [r0], -r6
    1624:	0e750b2d 	vaddeq.f64	d16, d5, d29
    1628:	0c2e0000 	stceq	0, cr0, [lr], #-0
    162c:	00494d53 	subeq	r4, r9, r3, asr sp
    1630:	0d220b30 	vstmdbeq	r2!, {d0-d23}
    1634:	0b310000 	bleq	c4163c <_bss_end+0xc35acc>
    1638:	00000e52 	andeq	r0, r0, r2, asr lr
    163c:	0d340b32 	vldmdbeq	r4!, {d0-d24}
    1640:	0b330000 	bleq	cc1648 <_bss_end+0xcb5ad8>
    1644:	00000d3b 	andeq	r0, r0, fp, lsr sp
    1648:	32490c34 	subcc	r0, r9, #52, 24	; 0x3400
    164c:	0c350043 	ldceq	0, cr0, [r5], #-268	; 0xfffffef4
    1650:	00495053 	subeq	r5, r9, r3, asr r0
    1654:	43500c36 	cmpmi	r0, #13824	; 0x3600
    1658:	0b37004d 	bleq	dc1794 <_bss_end+0xdb5c24>
    165c:	00000dfc 	strdeq	r0, [r0], -ip
    1660:	44080039 	strmi	r0, [r8], #-57	; 0xffffffc7
    1664:	03000005 	movweq	r0, #5
    1668:	02341da6 	eorseq	r1, r4, #10624	; 0x2980
    166c:	b4000000 	strlt	r0, [r0], #-0
    1670:	230d2000 	movwcs	r2, #53248	; 0xd000
    1674:	0500000b 	streq	r0, [r0, #-11]
    1678:	00003304 	andeq	r3, r0, r4, lsl #6
    167c:	10a80300 	adcne	r0, r8, r0, lsl #6
    1680:	000b700b 	andeq	r7, fp, fp
    1684:	f60b0000 			; <UNDEFINED> instruction: 0xf60b0000
    1688:	0100000a 	tsteq	r0, sl
    168c:	000f7c0b 	andeq	r7, pc, fp, lsl #24
    1690:	bf0b0200 	svclt	0x000b0200
    1694:	0300000a 	movweq	r0, #10
    1698:	000be80b 	andeq	lr, fp, fp, lsl #16
    169c:	fd0b0400 	stc2	4, cr0, [fp, #-0]
    16a0:	05000009 	streq	r0, [r0, #-9]
    16a4:	0009e90b 	andeq	lr, r9, fp, lsl #18
    16a8:	170b0600 	strne	r0, [fp, -r0, lsl #12]
    16ac:	0700000b 	streq	r0, [r0, -fp]
    16b0:	000bb60b 	andeq	fp, fp, fp, lsl #12
    16b4:	00000800 	andeq	r0, r0, r0, lsl #16
    16b8:	0000820e 	andeq	r8, r0, lr, lsl #4
    16bc:	07040200 	streq	r0, [r4, -r0, lsl #4]
    16c0:	00001e5d 	andeq	r1, r0, sp, asr lr
    16c4:	00022d05 	andeq	r2, r2, r5, lsl #26
    16c8:	00920e00 	addseq	r0, r2, r0, lsl #28
    16cc:	a20e0000 	andge	r0, lr, #0
    16d0:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    16d4:	000000b2 	strheq	r0, [r0], -r2
    16d8:	0000bf0e 	andeq	fp, r0, lr, lsl #30
    16dc:	00cf0e00 	sbceq	r0, pc, r0, lsl #28
    16e0:	d20e0000 	andle	r0, lr, #0
    16e4:	0f000001 	svceq	0x00000001
    16e8:	00000eeb 	andeq	r0, r0, fp, ror #29
    16ec:	07050404 	streq	r0, [r5, -r4, lsl #8]
    16f0:	00000336 	andeq	r0, r0, r6, lsr r3
    16f4:	000db910 	andeq	fp, sp, r0, lsl r9
    16f8:	1c090400 	cfstrsne	mvf0, [r9], {-0}
    16fc:	00000336 	andeq	r0, r0, r6, lsr r3
    1700:	0af11100 	beq	ffc45b08 <_bss_end+0xffc39f98>
    1704:	0c040000 	stceq	0, cr0, [r4], {-0}
    1708:	000d781c 	andeq	r7, sp, ip, lsl r8
    170c:	00033c00 	andeq	r3, r3, r0, lsl #24
    1710:	028a0200 	addeq	r0, sl, #0, 4
    1714:	02950000 	addseq	r0, r5, #0
    1718:	42120000 	andsmi	r0, r2, #0
    171c:	13000003 	movwne	r0, #3
    1720:	000000df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    1724:	0eeb1100 	cdpeq	1, 14, cr1, cr11, cr0, {0}
    1728:	0f040000 	svceq	0x00040000
    172c:	000f3b05 	andeq	r3, pc, r5, lsl #22
    1730:	00034200 	andeq	r4, r3, r0, lsl #4
    1734:	02ae0100 	adceq	r0, lr, #0, 2
    1738:	02b90000 	adcseq	r0, r9, #0
    173c:	42120000 	andsmi	r0, r2, #0
    1740:	13000003 	movwne	r0, #3
    1744:	0000022d 	andeq	r0, r0, sp, lsr #4
    1748:	0e0d1400 	cfcpyseq	mvf1, mvf13
    174c:	12040000 	andne	r0, r4, #0
    1750:	000cad0a 	andeq	sl, ip, sl, lsl #26
    1754:	02ce0100 	sbceq	r0, lr, #0, 2
    1758:	02d90000 	sbcseq	r0, r9, #0
    175c:	42120000 	andsmi	r0, r2, #0
    1760:	13000003 	movwne	r0, #3
    1764:	0000012e 	andeq	r0, r0, lr, lsr #2
    1768:	0e1e1400 	cfmulseq	mvf1, mvf14, mvf0
    176c:	14040000 	strne	r0, [r4], #-0
    1770:	000c660a 	andeq	r6, ip, sl, lsl #12
    1774:	02ee0100 	rsceq	r0, lr, #0, 2
    1778:	02f90000 	rscseq	r0, r9, #0
    177c:	42120000 	andsmi	r0, r2, #0
    1780:	13000003 	movwne	r0, #3
    1784:	0000012e 	andeq	r0, r0, lr, lsr #2
    1788:	101b1400 	andsne	r1, fp, r0, lsl #8
    178c:	17040000 	strne	r0, [r4, -r0]
    1790:	000eb10a 	andeq	fp, lr, sl, lsl #2
    1794:	030e0100 	movweq	r0, #57600	; 0xe100
    1798:	03190000 	tsteq	r9, #0
    179c:	42120000 	andsmi	r0, r2, #0
    17a0:	13000003 	movwne	r0, #3
    17a4:	00000171 	andeq	r0, r0, r1, ror r1
    17a8:	0e011500 	cfsh32eq	mvfx1, mvfx1, #0
    17ac:	19040000 	stmdbne	r4, {}	; <UNPREDICTABLE>
    17b0:	000c140a 	andeq	r1, ip, sl, lsl #8
    17b4:	032a0100 			; <UNDEFINED> instruction: 0x032a0100
    17b8:	42120000 	andsmi	r0, r2, #0
    17bc:	13000003 	movwne	r0, #3
    17c0:	00000171 	andeq	r0, r0, r1, ror r1
    17c4:	04160000 	ldreq	r0, [r6], #-0
    17c8:	00000071 	andeq	r0, r0, r1, ror r0
    17cc:	00710417 	rsbseq	r0, r1, r7, lsl r4
    17d0:	04160000 	ldreq	r0, [r6], #-0
    17d4:	00000257 	andeq	r0, r0, r7, asr r2
    17d8:	00034205 	andeq	r4, r3, r5, lsl #4
    17dc:	0ea31800 	cdpeq	8, 10, cr1, cr3, cr0, {0}
    17e0:	1c040000 	stcne	0, cr0, [r4], {-0}
    17e4:	0002571e 	andeq	r5, r2, lr, lsl r7
    17e8:	0a770a00 	beq	1dc3ff0 <_bss_end+0x1db8480>
    17ec:	01070000 	mrseq	r0, (UNDEF: 7)
    17f0:	0000003a 	andeq	r0, r0, sl, lsr r0
    17f4:	7e0c0605 	cfmadd32vc	mvax0, mvfx0, mvfx12, mvfx5
    17f8:	0b000003 	bleq	180c <CPSR_IRQ_INHIBIT+0x178c>
    17fc:	00000a9f 	muleq	r0, pc, sl	; <UNPREDICTABLE>
    1800:	0ac90b00 	beq	ff244408 <_bss_end+0xff238898>
    1804:	0b010000 	bleq	4180c <_bss_end+0x35c9c>
    1808:	00000a4f 	andeq	r0, r0, pc, asr #20
    180c:	750f0002 	strvc	r0, [pc, #-2]	; 1812 <CPSR_IRQ_INHIBIT+0x1792>
    1810:	0800000b 	stmdaeq	r0, {r0, r1, r3}
    1814:	76070d05 	strvc	r0, [r7], -r5, lsl #26
    1818:	10000004 	andne	r0, r0, r4
    181c:	00000aea 	andeq	r0, r0, sl, ror #21
    1820:	361c1505 	ldrcc	r1, [ip], -r5, lsl #10
    1824:	00000003 	andeq	r0, r0, r3
    1828:	000bd819 	andeq	sp, fp, r9, lsl r8
    182c:	0b110500 	bleq	442c34 <_bss_end+0x4370c4>
    1830:	00000476 	andeq	r0, r0, r6, ror r4
    1834:	0b7c1001 	bleq	1f05840 <_bss_end+0x1ef9cd0>
    1838:	18050000 	stmdane	r5, {}	; <UNPREDICTABLE>
    183c:	00039815 	andeq	r9, r3, r5, lsl r8
    1840:	f1110400 			; <UNDEFINED> instruction: 0xf1110400
    1844:	0500000a 	streq	r0, [r0, #-10]
    1848:	0b861c1b 	bleq	fe1888bc <_bss_end+0xfe17cd4c>
    184c:	033c0000 	teqeq	ip, #0
    1850:	cb020000 	blgt	81858 <_bss_end+0x75ce8>
    1854:	d6000003 	strle	r0, [r0], -r3
    1858:	12000003 	andne	r0, r0, #3
    185c:	0000047d 	andeq	r0, r0, sp, ror r4
    1860:	0001e213 	andeq	lr, r1, r3, lsl r2
    1864:	75110000 	ldrvc	r0, [r1, #-0]
    1868:	0500000b 	streq	r0, [r0, #-11]
    186c:	0ba7051e 	bleq	fe9c2cec <_bss_end+0xfe9b717c>
    1870:	047d0000 	ldrbteq	r0, [sp], #-0
    1874:	ef010000 	svc	0x00010000
    1878:	fa000003 	blx	188c <CPSR_IRQ_INHIBIT+0x180c>
    187c:	12000003 	andne	r0, r0, #3
    1880:	0000047d 	andeq	r0, r0, sp, ror r4
    1884:	00022d13 	andeq	r2, r2, r3, lsl sp
    1888:	85140000 	ldrhi	r0, [r4, #-0]
    188c:	0500000e 	streq	r0, [r0, #-14]
    1890:	0a5d0a21 	beq	174411c <_bss_end+0x17385ac>
    1894:	0f010000 	svceq	0x00010000
    1898:	24000004 	strcs	r0, [r0], #-4
    189c:	12000004 	andne	r0, r0, #4
    18a0:	0000047d 	andeq	r0, r0, sp, ror r4
    18a4:	00039813 	andeq	r9, r3, r3, lsl r8
    18a8:	00651300 	rsbeq	r1, r5, r0, lsl #6
    18ac:	59130000 	ldmdbpl	r3, {}	; <UNPREDICTABLE>
    18b0:	00000003 	andeq	r0, r0, r3
    18b4:	000f3314 	andeq	r3, pc, r4, lsl r3	; <UNPREDICTABLE>
    18b8:	0a230500 	beq	8c2cc0 <_bss_end+0x8b7150>
    18bc:	00000b2d 	andeq	r0, r0, sp, lsr #22
    18c0:	00043901 	andeq	r3, r4, r1, lsl #18
    18c4:	00043f00 	andeq	r3, r4, r0, lsl #30
    18c8:	047d1200 	ldrbteq	r1, [sp], #-512	; 0xfffffe00
    18cc:	14000000 	strne	r0, [r0], #-0
    18d0:	000009f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    18d4:	f00a2605 			; <UNDEFINED> instruction: 0xf00a2605
    18d8:	0100000b 	tsteq	r0, fp
    18dc:	00000454 	andeq	r0, r0, r4, asr r4
    18e0:	0000045a 	andeq	r0, r0, sl, asr r4
    18e4:	00047d12 	andeq	r7, r4, r2, lsl sp
    18e8:	c31a0000 	tstgt	sl, #0
    18ec:	0500000b 	streq	r0, [r0, #-11]
    18f0:	09580a28 	ldmdbeq	r8, {r3, r5, r9, fp}^
    18f4:	04830000 	streq	r0, [r3], #0
    18f8:	6f010000 	svcvs	0x00010000
    18fc:	12000004 	andne	r0, r0, #4
    1900:	0000047d 	andeq	r0, r0, sp, ror r4
    1904:	04160000 	ldreq	r0, [r6], #-0
    1908:	0000047c 	andeq	r0, r0, ip, ror r4
    190c:	7e04161b 	mcrvc	6, 0, r1, cr4, cr11, {0}
    1910:	02000003 	andeq	r0, r0, #3
    1914:	03320201 	teqeq	r2, #268435456	; 0x10000000
    1918:	51180000 	tstpl	r8, r0
    191c:	05000009 	streq	r0, [r0, #-9]
    1920:	037e0f2b 	cmneq	lr, #43, 30	; 0xac
    1924:	4d1c0000 	ldcmi	0, cr0, [ip, #-0]
    1928:	01000003 	tsteq	r0, r3
    192c:	03051707 	movweq	r1, #22279	; 0x5707
    1930:	0000ab48 	andeq	sl, r0, r8, asr #22
    1934:	000e941d 	andeq	r9, lr, sp, lsl r4
    1938:	0092b800 	addseq	fp, r2, r0, lsl #16
    193c:	00001c00 	andeq	r1, r0, r0, lsl #24
    1940:	1e9c0100 	fmlnee	f0, f4, f0
    1944:	0000054f 	andeq	r0, r0, pc, asr #10
    1948:	00009264 	andeq	r9, r0, r4, ror #4
    194c:	00000054 	andeq	r0, r0, r4, asr r0
    1950:	04e59c01 	strbteq	r9, [r5], #3073	; 0xc01
    1954:	321f0000 	andscc	r0, pc, #0
    1958:	01000004 	tsteq	r0, r4
    195c:	00330142 	eorseq	r0, r3, r2, asr #2
    1960:	91020000 	mrsls	r0, (UNDEF: 2)
    1964:	05ed1f74 	strbeq	r1, [sp, #3956]!	; 0xf74
    1968:	42010000 	andmi	r0, r1, #0
    196c:	00003301 	andeq	r3, r0, r1, lsl #6
    1970:	70910200 	addsvc	r0, r1, r0, lsl #4
    1974:	03192000 	tsteq	r9, #0
    1978:	3d010000 	stccc	0, cr0, [r1, #-0]
    197c:	0004ff06 	andeq	pc, r4, r6, lsl #30
    1980:	00921400 	addseq	r1, r2, r0, lsl #8
    1984:	00005000 	andeq	r5, r0, r0
    1988:	2a9c0100 	bcs	fe701d90 <_bss_end+0xfe6f6220>
    198c:	21000005 	tstcs	r0, r5
    1990:	00000582 	andeq	r0, r0, r2, lsl #11
    1994:	00000348 	andeq	r0, r0, r8, asr #6
    1998:	1f649102 	svcne	0x00649102
    199c:	00000f6d 	andeq	r0, r0, sp, ror #30
    19a0:	71393d01 	teqvc	r9, r1, lsl #26
    19a4:	02000001 	andeq	r0, r0, #1
    19a8:	20226091 	mlacs	r2, r1, r0, r6
    19ac:	0100000f 	tsteq	r0, pc
    19b0:	006c183f 	rsbeq	r1, ip, pc, lsr r8
    19b4:	91020000 	mrsls	r0, (UNDEF: 2)
    19b8:	f920006c 			; <UNDEFINED> instruction: 0xf920006c
    19bc:	01000002 	tsteq	r0, r2
    19c0:	05440636 	strbeq	r0, [r4, #-1590]	; 0xfffff9ca
    19c4:	91c40000 	bicls	r0, r4, r0
    19c8:	00500000 	subseq	r0, r0, r0
    19cc:	9c010000 	stcls	0, cr0, [r1], {-0}
    19d0:	0000056f 	andeq	r0, r0, pc, ror #10
    19d4:	00058221 	andeq	r8, r5, r1, lsr #4
    19d8:	00034800 	andeq	r4, r3, r0, lsl #16
    19dc:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    19e0:	000f6d1f 	andeq	r6, pc, pc, lsl sp	; <UNPREDICTABLE>
    19e4:	38360100 	ldmdacc	r6!, {r8}
    19e8:	00000171 	andeq	r0, r0, r1, ror r1
    19ec:	22609102 	rsbcs	r9, r0, #-2147483648	; 0x80000000
    19f0:	00000f20 	andeq	r0, r0, r0, lsr #30
    19f4:	6c183801 	ldcvs	8, cr3, [r8], {1}
    19f8:	02000000 	andeq	r0, r0, #0
    19fc:	20006c91 	mulcs	r0, r1, ip
    1a00:	000002d9 	ldrdeq	r0, [r0], -r9
    1a04:	89063101 	stmdbhi	r6, {r0, r8, ip, sp}
    1a08:	80000005 	andhi	r0, r0, r5
    1a0c:	44000091 	strmi	r0, [r0], #-145	; 0xffffff6f
    1a10:	01000000 	mrseq	r0, (UNDEF: 0)
    1a14:	0005a59c 	muleq	r5, ip, r5
    1a18:	05822100 	streq	r2, [r2, #256]	; 0x100
    1a1c:	03480000 	movteq	r0, #32768	; 0x8000
    1a20:	91020000 	mrsls	r0, (UNDEF: 2)
    1a24:	0f6d1f6c 	svceq	0x006d1f6c
    1a28:	31010000 	mrscc	r0, (UNDEF: 1)
    1a2c:	00012e45 	andeq	r2, r1, r5, asr #28
    1a30:	68910200 	ldmvs	r1, {r9}
    1a34:	02b92000 	adcseq	r2, r9, #0
    1a38:	2c010000 	stccs	0, cr0, [r1], {-0}
    1a3c:	0005bf06 	andeq	fp, r5, r6, lsl #30
    1a40:	00913c00 	addseq	r3, r1, r0, lsl #24
    1a44:	00004400 	andeq	r4, r0, r0, lsl #8
    1a48:	db9c0100 	blle	fe701e50 <_bss_end+0xfe6f62e0>
    1a4c:	21000005 	tstcs	r0, r5
    1a50:	00000582 	andeq	r0, r0, r2, lsl #11
    1a54:	00000348 	andeq	r0, r0, r8, asr #6
    1a58:	1f6c9102 	svcne	0x006c9102
    1a5c:	00000f6d 	andeq	r0, r0, sp, ror #30
    1a60:	2e442c01 	cdpcs	12, 4, cr2, cr4, cr1, {0}
    1a64:	02000001 	andeq	r0, r0, #1
    1a68:	23006891 	movwcs	r6, #2193	; 0x891
    1a6c:	00000271 	andeq	r0, r0, r1, ror r2
    1a70:	f5182701 			; <UNDEFINED> instruction: 0xf5182701
    1a74:	04000005 	streq	r0, [r0], #-5
    1a78:	38000091 	stmdacc	r0, {r0, r4, r7}
    1a7c:	01000000 	mrseq	r0, (UNDEF: 0)
    1a80:	0006119c 	muleq	r6, ip, r1
    1a84:	05822100 	streq	r2, [r2, #256]	; 0x100
    1a88:	03480000 	movteq	r0, #32768	; 0x8000
    1a8c:	91020000 	mrsls	r0, (UNDEF: 2)
    1a90:	65722474 	ldrbvs	r2, [r2, #-1140]!	; 0xfffffb8c
    1a94:	27010067 	strcs	r0, [r1, -r7, rrx]
    1a98:	0000df52 	andeq	sp, r0, r2, asr pc
    1a9c:	70910200 	addsvc	r0, r1, r0, lsl #4
    1aa0:	02952500 	addseq	r2, r5, #0, 10
    1aa4:	21010000 	mrscs	r0, (UNDEF: 1)
    1aa8:	00062201 	andeq	r2, r6, r1, lsl #4
    1aac:	06380000 	ldrteq	r0, [r8], -r0
    1ab0:	82260000 	eorhi	r0, r6, #0
    1ab4:	48000005 	stmdami	r0, {r0, r2}
    1ab8:	27000003 	strcs	r0, [r0, -r3]
    1abc:	00000b4c 	andeq	r0, r0, ip, asr #22
    1ac0:	2d3c2101 	ldfcss	f2, [ip, #-4]!
    1ac4:	00000002 	andeq	r0, r0, r2
    1ac8:	00061128 	andeq	r1, r6, r8, lsr #2
    1acc:	000f0100 	andeq	r0, pc, r0, lsl #2
    1ad0:	00065300 	andeq	r5, r6, r0, lsl #6
    1ad4:	0090d000 	addseq	sp, r0, r0
    1ad8:	00003400 	andeq	r3, r0, r0, lsl #8
    1adc:	649c0100 	ldrvs	r0, [ip], #256	; 0x100
    1ae0:	29000006 	stmdbcs	r0, {r1, r2}
    1ae4:	00000622 	andeq	r0, r0, r2, lsr #12
    1ae8:	29749102 	ldmdbcs	r4!, {r1, r8, ip, pc}^
    1aec:	0000062b 	andeq	r0, r0, fp, lsr #12
    1af0:	00709102 	rsbseq	r9, r0, r2, lsl #2
    1af4:	000c4f2a 	andeq	r4, ip, sl, lsr #30
    1af8:	331a0100 	tstcc	sl, #0, 2
    1afc:	000090c0 	andeq	r9, r0, r0, asr #1
    1b00:	00000010 	andeq	r0, r0, r0, lsl r0
    1b04:	842b9c01 	strthi	r9, [fp], #-3073	; 0xfffff3ff
    1b08:	0100000f 	tsteq	r0, pc
    1b0c:	90901110 	addsls	r1, r0, r0, lsl r1
    1b10:	00300000 	eorseq	r0, r0, r0
    1b14:	9c010000 	stcls	0, cr0, [r1], {-0}
    1b18:	000f9a2a 	andeq	r9, pc, sl, lsr #20
    1b1c:	330b0100 	movwcc	r0, #45312	; 0xb100
    1b20:	00009078 	andeq	r9, r0, r8, ror r0
    1b24:	00000018 	andeq	r0, r0, r8, lsl r0
    1b28:	41009c01 	tstmi	r0, r1, lsl #24
    1b2c:	0400000d 	streq	r0, [r0], #-13
    1b30:	000b2a00 	andeq	r2, fp, r0, lsl #20
    1b34:	00010400 	andeq	r0, r1, r0, lsl #8
    1b38:	04000000 	streq	r0, [r0], #-0
    1b3c:	00001388 	andeq	r1, r0, r8, lsl #7
    1b40:	000000b6 	strheq	r0, [r0], -r6
    1b44:	000092d4 	ldrdeq	r9, [r0], -r4
    1b48:	000002e8 	andeq	r0, r0, r8, ror #5
    1b4c:	00000c35 	andeq	r0, r0, r5, lsr ip
    1b50:	a0080102 	andge	r0, r8, r2, lsl #2
    1b54:	03000004 	movweq	r0, #4
    1b58:	00000025 	andeq	r0, r0, r5, lsr #32
    1b5c:	80050202 	andhi	r0, r5, r2, lsl #4
    1b60:	04000002 	streq	r0, [r0], #-2
    1b64:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
    1b68:	38050074 	stmdacc	r5, {r2, r4, r5, r6}
    1b6c:	06000000 	streq	r0, [r0], -r0
    1b70:	00000a0e 	andeq	r0, r0, lr, lsl #20
    1b74:	50070902 	andpl	r0, r7, r2, lsl #18
    1b78:	02000000 	andeq	r0, r0, #0
    1b7c:	04970801 	ldreq	r0, [r7], #2049	; 0x801
    1b80:	50050000 	andpl	r0, r5, r0
    1b84:	02000000 	andeq	r0, r0, #0
    1b88:	05020702 	streq	r0, [r2, #-1794]	; 0xfffff8fe
    1b8c:	29060000 	stmdbcs	r6, {}	; <UNPREDICTABLE>
    1b90:	02000003 	andeq	r0, r0, #3
    1b94:	0074070b 	rsbseq	r0, r4, fp, lsl #14
    1b98:	63030000 	movwvs	r0, #12288	; 0x3000
    1b9c:	02000000 	andeq	r0, r0, #0
    1ba0:	1e620704 	cdpne	7, 6, cr0, cr2, cr4, {0}
    1ba4:	74050000 	strvc	r0, [r5], #-0
    1ba8:	03000000 	movweq	r0, #0
    1bac:	00000074 	andeq	r0, r0, r4, ror r0
    1bb0:	0005b007 	andeq	fp, r5, r7
    1bb4:	74040700 	strvc	r0, [r4], #-1792	; 0xfffff900
    1bb8:	03000000 	movweq	r0, #0
    1bbc:	00ce0c06 	sbceq	r0, lr, r6, lsl #24
    1bc0:	be080000 	cdplt	0, 0, cr0, cr8, cr0, {0}
    1bc4:	00000004 	andeq	r0, r0, r4
    1bc8:	00064e08 	andeq	r4, r6, r8, lsl #28
    1bcc:	9f080100 	svcls	0x00080100
    1bd0:	02000006 	andeq	r0, r0, #6
    1bd4:	00069908 	andeq	r9, r6, r8, lsl #18
    1bd8:	74080300 	strvc	r0, [r8], #-768	; 0xfffffd00
    1bdc:	04000006 	streq	r0, [r0], #-6
    1be0:	00067a08 	andeq	r7, r6, r8, lsl #20
    1be4:	bf080500 	svclt	0x00080500
    1be8:	06000005 	streq	r0, [r0], -r5
    1bec:	00069308 	andeq	r9, r6, r8, lsl #6
    1bf0:	37080700 	strcc	r0, [r8, -r0, lsl #14]
    1bf4:	08000003 	stmdaeq	r0, {r0, r1}
    1bf8:	03610900 	cmneq	r1, #0, 18
    1bfc:	03040000 	movweq	r0, #16384	; 0x4000
    1c00:	0253071a 	subseq	r0, r3, #6815744	; 0x680000
    1c04:	fe0a0000 	cdp2	0, 0, cr0, cr10, cr0, {0}
    1c08:	03000002 	movweq	r0, #2
    1c0c:	025e221e 	subseq	r2, lr, #-536870911	; 0xe0000001
    1c10:	0b000000 	bleq	1c18 <CPSR_IRQ_INHIBIT+0x1b98>
    1c14:	0000051c 	andeq	r0, r0, ip, lsl r5
    1c18:	ce0a2203 	cdpgt	2, 0, cr2, cr10, cr3, {0}
    1c1c:	63000002 	movwvs	r0, #2
    1c20:	02000002 	andeq	r0, r0, #2
    1c24:	00000101 	andeq	r0, r0, r1, lsl #2
    1c28:	00000116 	andeq	r0, r0, r6, lsl r1
    1c2c:	00026f0c 	andeq	r6, r2, ip, lsl #30
    1c30:	00630d00 	rsbeq	r0, r3, r0, lsl #26
    1c34:	750d0000 	strvc	r0, [sp, #-0]
    1c38:	0d000002 	stceq	0, cr0, [r0, #-8]
    1c3c:	00000275 	andeq	r0, r0, r5, ror r2
    1c40:	06300b00 	ldrteq	r0, [r0], -r0, lsl #22
    1c44:	24030000 	strcs	r0, [r3], #-0
    1c48:	0004680a 	andeq	r6, r4, sl, lsl #16
    1c4c:	00026300 	andeq	r6, r2, r0, lsl #6
    1c50:	012f0200 			; <UNDEFINED> instruction: 0x012f0200
    1c54:	01440000 	mrseq	r0, (UNDEF: 68)
    1c58:	6f0c0000 	svcvs	0x000c0000
    1c5c:	0d000002 	stceq	0, cr0, [r0, #-8]
    1c60:	00000063 	andeq	r0, r0, r3, rrx
    1c64:	0002750d 	andeq	r7, r2, sp, lsl #10
    1c68:	02750d00 	rsbseq	r0, r5, #0, 26
    1c6c:	0b000000 	bleq	1c74 <CPSR_IRQ_INHIBIT+0x1bf4>
    1c70:	0000036f 	andeq	r0, r0, pc, ror #6
    1c74:	f80a2603 			; <UNDEFINED> instruction: 0xf80a2603
    1c78:	63000005 	movwvs	r0, #5
    1c7c:	02000002 	andeq	r0, r0, #2
    1c80:	0000015d 	andeq	r0, r0, sp, asr r1
    1c84:	00000172 	andeq	r0, r0, r2, ror r1
    1c88:	00026f0c 	andeq	r6, r2, ip, lsl #30
    1c8c:	00630d00 	rsbeq	r0, r3, r0, lsl #26
    1c90:	750d0000 	strvc	r0, [sp, #-0]
    1c94:	0d000002 	stceq	0, cr0, [r0, #-8]
    1c98:	00000275 	andeq	r0, r0, r5, ror r2
    1c9c:	03f60b00 	mvnseq	r0, #0, 22
    1ca0:	28030000 	stmdacs	r3, {}	; <UNPREDICTABLE>
    1ca4:	0001f20a 	andeq	pc, r1, sl, lsl #4
    1ca8:	00026300 	andeq	r6, r2, r0, lsl #6
    1cac:	018b0200 	orreq	r0, fp, r0, lsl #4
    1cb0:	01a00000 	moveq	r0, r0
    1cb4:	6f0c0000 	svcvs	0x000c0000
    1cb8:	0d000002 	stceq	0, cr0, [r0, #-8]
    1cbc:	00000063 	andeq	r0, r0, r3, rrx
    1cc0:	0002750d 	andeq	r7, r2, sp, lsl #10
    1cc4:	02750d00 	rsbseq	r0, r5, #0, 26
    1cc8:	0b000000 	bleq	1cd0 <CPSR_IRQ_INHIBIT+0x1c50>
    1ccc:	00000361 	andeq	r0, r0, r1, ror #6
    1cd0:	04052b03 	streq	r2, [r5], #-2819	; 0xfffff4fd
    1cd4:	7b000003 	blvc	1ce8 <CPSR_IRQ_INHIBIT+0x1c68>
    1cd8:	01000002 	tsteq	r0, r2
    1cdc:	000001b9 			; <UNDEFINED> instruction: 0x000001b9
    1ce0:	000001c4 	andeq	r0, r0, r4, asr #3
    1ce4:	00027b0c 	andeq	r7, r2, ip, lsl #22
    1ce8:	00740d00 	rsbseq	r0, r4, r0, lsl #26
    1cec:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    1cf0:	000005d3 	ldrdeq	r0, [r0], -r3
    1cf4:	870a2e03 	strhi	r2, [sl, -r3, lsl #28]
    1cf8:	01000005 	tsteq	r0, r5
    1cfc:	000001d9 	ldrdeq	r0, [r0], -r9
    1d00:	000001e9 	andeq	r0, r0, r9, ror #3
    1d04:	00027b0c 	andeq	r7, r2, ip, lsl #22
    1d08:	00630d00 	rsbeq	r0, r3, r0, lsl #26
    1d0c:	850d0000 	strhi	r0, [sp, #-0]
    1d10:	00000000 	andeq	r0, r0, r0
    1d14:	00034f0b 	andeq	r4, r3, fp, lsl #30
    1d18:	14300300 	ldrtne	r0, [r0], #-768	; 0xfffffd00
    1d1c:	00000409 	andeq	r0, r0, r9, lsl #8
    1d20:	00000085 	andeq	r0, r0, r5, lsl #1
    1d24:	00020201 	andeq	r0, r2, r1, lsl #4
    1d28:	00020d00 	andeq	r0, r2, r0, lsl #26
    1d2c:	026f0c00 	rsbeq	r0, pc, #0, 24
    1d30:	630d0000 	movwvs	r0, #53248	; 0xd000
    1d34:	00000000 	andeq	r0, r0, r0
    1d38:	00064a0e 	andeq	r4, r6, lr, lsl #20
    1d3c:	0a330300 	beq	cc2944 <_bss_end+0xcb6dd4>
    1d40:	000002ac 	andeq	r0, r0, ip, lsr #5
    1d44:	00022201 	andeq	r2, r2, r1, lsl #4
    1d48:	00023200 	andeq	r3, r2, r0, lsl #4
    1d4c:	027b0c00 	rsbseq	r0, fp, #0, 24
    1d50:	630d0000 	movwvs	r0, #53248	; 0xd000
    1d54:	0d000000 	stceq	0, cr0, [r0, #-0]
    1d58:	00000263 	andeq	r0, r0, r3, ror #4
    1d5c:	04ba0f00 	ldrteq	r0, [sl], #3840	; 0xf00
    1d60:	36030000 	strcc	r0, [r3], -r0
    1d64:	0006550a 	andeq	r5, r6, sl, lsl #10
    1d68:	00026300 	andeq	r6, r2, r0, lsl #6
    1d6c:	02470100 	subeq	r0, r7, #0, 2
    1d70:	7b0c0000 	blvc	301d78 <_bss_end+0x2f6208>
    1d74:	0d000002 	stceq	0, cr0, [r0, #-8]
    1d78:	00000063 	andeq	r0, r0, r3, rrx
    1d7c:	ce030000 	cdpgt	0, 0, cr0, cr3, cr0, {0}
    1d80:	10000000 	andne	r0, r0, r0
    1d84:	00007b04 	andeq	r7, r0, r4, lsl #22
    1d88:	02580300 	subseq	r0, r8, #0, 6
    1d8c:	01020000 	mrseq	r0, (UNDEF: 2)
    1d90:	00033202 	andeq	r3, r3, r2, lsl #4
    1d94:	02630500 	rsbeq	r0, r3, #0, 10
    1d98:	04100000 	ldreq	r0, [r0], #-0
    1d9c:	00000253 	andeq	r0, r0, r3, asr r2
    1da0:	00630411 	rsbeq	r0, r3, r1, lsl r4
    1da4:	04100000 	ldreq	r0, [r0], #-0
    1da8:	000000ce 	andeq	r0, r0, lr, asr #1
    1dac:	0004b412 	andeq	fp, r4, r2, lsl r4
    1db0:	163a0300 	ldrtne	r0, [sl], -r0, lsl #6
    1db4:	000000ce 	andeq	r0, r0, lr, asr #1
    1db8:	0007ce09 	andeq	ip, r7, r9, lsl #28
    1dbc:	03041800 	movweq	r1, #18432	; 0x4800
    1dc0:	0004ce07 	andeq	ip, r4, r7, lsl #28
    1dc4:	072a1300 	streq	r1, [sl, -r0, lsl #6]!
    1dc8:	04070000 	streq	r0, [r7], #-0
    1dcc:	00000074 	andeq	r0, r0, r4, ror r0
    1dd0:	01100604 	tsteq	r0, r4, lsl #12
    1dd4:	000002ba 			; <UNDEFINED> instruction: 0x000002ba
    1dd8:	58454814 	stmdapl	r5, {r2, r4, fp, lr}^
    1ddc:	44141000 	ldrmi	r1, [r4], #-0
    1de0:	0a004345 	beq	12afc <_bss_end+0x6f8c>
    1de4:	029a0300 	addseq	r0, sl, #0, 6
    1de8:	37150000 	ldrcc	r0, [r5, -r0]
    1dec:	08000007 	stmdaeq	r0, {r0, r1, r2}
    1df0:	e30c2404 	movw	r2, #50180	; 0xc404
    1df4:	16000002 	strne	r0, [r0], -r2
    1df8:	26040079 			; <UNDEFINED> instruction: 0x26040079
    1dfc:	00007416 	andeq	r7, r0, r6, lsl r4
    1e00:	78160000 	ldmdavc	r6, {}	; <UNPREDICTABLE>
    1e04:	16270400 	strtne	r0, [r7], -r0, lsl #8
    1e08:	00000074 	andeq	r0, r0, r4, ror r0
    1e0c:	ab170004 	blge	5c1e24 <_bss_end+0x5b62b4>
    1e10:	04000008 	streq	r0, [r0], #-8
    1e14:	02ba1b0c 	adcseq	r1, sl, #12, 22	; 0x3000
    1e18:	0a010000 	beq	41e20 <_bss_end+0x362b0>
    1e1c:	00081e18 	andeq	r1, r8, r8, lsl lr
    1e20:	280d0400 	stmdacs	sp, {sl}
    1e24:	000004d4 	ldrdeq	r0, [r0], -r4
    1e28:	07ce1901 	strbeq	r1, [lr, r1, lsl #18]
    1e2c:	10040000 	andne	r0, r4, r0
    1e30:	0008980e 	andeq	r9, r8, lr, lsl #16
    1e34:	0004d900 	andeq	sp, r4, r0, lsl #18
    1e38:	03170100 	tsteq	r7, #0, 2
    1e3c:	032c0000 			; <UNDEFINED> instruction: 0x032c0000
    1e40:	d90c0000 	stmdble	ip, {}	; <UNPREDICTABLE>
    1e44:	0d000004 	stceq	0, cr0, [r0, #-16]
    1e48:	00000074 	andeq	r0, r0, r4, ror r0
    1e4c:	0000740d 	andeq	r7, r0, sp, lsl #8
    1e50:	00740d00 	rsbseq	r0, r4, r0, lsl #26
    1e54:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    1e58:	00000ac3 	andeq	r0, r0, r3, asr #21
    1e5c:	970a1204 	strls	r1, [sl, -r4, lsl #4]
    1e60:	01000007 	tsteq	r0, r7
    1e64:	00000341 	andeq	r0, r0, r1, asr #6
    1e68:	00000347 	andeq	r0, r0, r7, asr #6
    1e6c:	0004d90c 	andeq	sp, r4, ip, lsl #18
    1e70:	d70b0000 	strle	r0, [fp, -r0]
    1e74:	04000007 	streq	r0, [r0], #-7
    1e78:	083b0f14 	ldmdaeq	fp!, {r2, r4, r8, r9, sl, fp}
    1e7c:	04df0000 	ldrbeq	r0, [pc], #0	; 1e84 <CPSR_IRQ_INHIBIT+0x1e04>
    1e80:	60010000 	andvs	r0, r1, r0
    1e84:	6b000003 	blvs	1e98 <CPSR_IRQ_INHIBIT+0x1e18>
    1e88:	0c000003 	stceq	0, cr0, [r0], {3}
    1e8c:	000004d9 	ldrdeq	r0, [r0], -r9
    1e90:	0000250d 	andeq	r2, r0, sp, lsl #10
    1e94:	d70b0000 	strle	r0, [fp, -r0]
    1e98:	04000007 	streq	r0, [r0], #-7
    1e9c:	07e20f15 			; <UNDEFINED> instruction: 0x07e20f15
    1ea0:	04df0000 	ldrbeq	r0, [pc], #0	; 1ea8 <CPSR_IRQ_INHIBIT+0x1e28>
    1ea4:	84010000 	strhi	r0, [r1], #-0
    1ea8:	8f000003 	svchi	0x00000003
    1eac:	0c000003 	stceq	0, cr0, [r0], {3}
    1eb0:	000004d9 	ldrdeq	r0, [r0], -r9
    1eb4:	0004ce0d 	andeq	ip, r4, sp, lsl #28
    1eb8:	d70b0000 	strle	r0, [fp, -r0]
    1ebc:	04000007 	streq	r0, [r0], #-7
    1ec0:	07ac0f16 			; <UNDEFINED> instruction: 0x07ac0f16
    1ec4:	04df0000 	ldrbeq	r0, [pc], #0	; 1ecc <CPSR_IRQ_INHIBIT+0x1e4c>
    1ec8:	a8010000 	stmdage	r1, {}	; <UNPREDICTABLE>
    1ecc:	b3000003 	movwlt	r0, #3
    1ed0:	0c000003 	stceq	0, cr0, [r0], {3}
    1ed4:	000004d9 	ldrdeq	r0, [r0], -r9
    1ed8:	00029a0d 	andeq	r9, r2, sp, lsl #20
    1edc:	d70b0000 	strle	r0, [fp, -r0]
    1ee0:	04000007 	streq	r0, [r0], #-7
    1ee4:	086a0f17 	stmdaeq	sl!, {r0, r1, r2, r4, r8, r9, sl, fp}^
    1ee8:	04df0000 	ldrbeq	r0, [pc], #0	; 1ef0 <CPSR_IRQ_INHIBIT+0x1e70>
    1eec:	cc010000 	stcgt	0, cr0, [r1], {-0}
    1ef0:	d7000003 	strle	r0, [r0, -r3]
    1ef4:	0c000003 	stceq	0, cr0, [r0], {3}
    1ef8:	000004d9 	ldrdeq	r0, [r0], -r9
    1efc:	0000740d 	andeq	r7, r0, sp, lsl #8
    1f00:	d70b0000 	strle	r0, [fp, -r0]
    1f04:	04000007 	streq	r0, [r0], #-7
    1f08:	082a0f18 	stmdaeq	sl!, {r3, r4, r8, r9, sl, fp}
    1f0c:	04df0000 	ldrbeq	r0, [pc], #0	; 1f14 <CPSR_IRQ_INHIBIT+0x1e94>
    1f10:	f0010000 			; <UNDEFINED> instruction: 0xf0010000
    1f14:	fb000003 	blx	1f2a <CPSR_IRQ_INHIBIT+0x1eaa>
    1f18:	0c000003 	stceq	0, cr0, [r0], {3}
    1f1c:	000004d9 	ldrdeq	r0, [r0], -r9
    1f20:	0002630d 	andeq	r6, r2, sp, lsl #6
    1f24:	1c1a0000 	ldcne	0, cr0, [sl], {-0}
    1f28:	04000007 	streq	r0, [r0], #-7
    1f2c:	06ec111b 	usateq	r1, #12, fp, lsl #2
    1f30:	040f0000 	streq	r0, [pc], #-0	; 1f38 <CPSR_IRQ_INHIBIT+0x1eb8>
    1f34:	04150000 	ldreq	r0, [r5], #-0
    1f38:	d90c0000 	stmdble	ip, {}	; <UNPREDICTABLE>
    1f3c:	00000004 	andeq	r0, r0, r4
    1f40:	00070f1a 	andeq	r0, r7, sl, lsl pc
    1f44:	111c0400 	tstne	ip, r0, lsl #8
    1f48:	0000087b 	andeq	r0, r0, fp, ror r8
    1f4c:	00000429 	andeq	r0, r0, r9, lsr #8
    1f50:	0000042f 	andeq	r0, r0, pc, lsr #8
    1f54:	0004d90c 	andeq	sp, r4, ip, lsl #18
    1f58:	c71a0000 	ldrgt	r0, [sl, -r0]
    1f5c:	04000006 	streq	r0, [r0], #-6
    1f60:	0741111d 	smlaldeq	r1, r1, sp, r1	; <UNPREDICTABLE>
    1f64:	04430000 	strbeq	r0, [r3], #-0
    1f68:	04490000 	strbeq	r0, [r9], #-0
    1f6c:	d90c0000 	stmdble	ip, {}	; <UNPREDICTABLE>
    1f70:	00000004 	andeq	r0, r0, r4
    1f74:	0006ac1a 	andeq	sl, r6, sl, lsl ip
    1f78:	0a1f0400 	beq	7c2f80 <_bss_end+0x7b7410>
    1f7c:	00000854 	andeq	r0, r0, r4, asr r8
    1f80:	0000045d 	andeq	r0, r0, sp, asr r4
    1f84:	00000463 	andeq	r0, r0, r3, ror #8
    1f88:	0004d90c 	andeq	sp, r4, ip, lsl #18
    1f8c:	0a1a0000 	beq	681f94 <_bss_end+0x676424>
    1f90:	04000007 	streq	r0, [r0], #-7
    1f94:	07f50a21 	ldrbeq	r0, [r5, r1, lsr #20]!
    1f98:	04770000 	ldrbteq	r0, [r7], #-0
    1f9c:	048c0000 	streq	r0, [ip], #0
    1fa0:	d90c0000 	stmdble	ip, {}	; <UNPREDICTABLE>
    1fa4:	0d000004 	stceq	0, cr0, [r0, #-16]
    1fa8:	00000074 	andeq	r0, r0, r4, ror r0
    1fac:	0004e50d 	andeq	lr, r4, sp, lsl #10
    1fb0:	00740d00 	rsbseq	r0, r4, r0, lsl #26
    1fb4:	0a000000 	beq	1fbc <CPSR_IRQ_INHIBIT+0x1f3c>
    1fb8:	00000763 	andeq	r0, r0, r3, ror #14
    1fbc:	f1232b04 			; <UNDEFINED> instruction: 0xf1232b04
    1fc0:	00000004 	andeq	r0, r0, r4
    1fc4:	00084c0a 	andeq	r4, r8, sl, lsl #24
    1fc8:	122c0400 	eorne	r0, ip, #0, 8
    1fcc:	00000074 	andeq	r0, r0, r4, ror r0
    1fd0:	080c0a04 	stmdaeq	ip, {r2, r9, fp}
    1fd4:	2d040000 	stccs	0, cr0, [r4, #-0]
    1fd8:	00007412 	andeq	r7, r0, r2, lsl r4
    1fdc:	150a0800 	strne	r0, [sl, #-2048]	; 0xfffff800
    1fe0:	04000008 	streq	r0, [r0], #-8
    1fe4:	02bf0f2e 	adcseq	r0, pc, #46, 30	; 0xb8
    1fe8:	0a0c0000 	beq	301ff0 <_bss_end+0x2f6480>
    1fec:	000006b9 			; <UNDEFINED> instruction: 0x000006b9
    1ff0:	9a122f04 	bls	48dc08 <_bss_end+0x482098>
    1ff4:	14000002 	strne	r0, [r0], #-2
    1ff8:	2c041000 	stccs	0, cr1, [r4], {-0}
    1ffc:	03000000 	movweq	r0, #0
    2000:	000004ce 	andeq	r0, r0, lr, asr #9
    2004:	028d0410 	addeq	r0, sp, #16, 8	; 0x10000000
    2008:	04110000 	ldreq	r0, [r1], #-0
    200c:	0000028d 	andeq	r0, r0, sp, lsl #5
    2010:	00250410 	eoreq	r0, r5, r0, lsl r4
    2014:	04100000 	ldreq	r0, [r0], #-0
    2018:	00000057 	andeq	r0, r0, r7, asr r0
    201c:	0004eb03 	andeq	lr, r4, r3, lsl #22
    2020:	077c1200 	ldrbeq	r1, [ip, -r0, lsl #4]!
    2024:	32040000 	andcc	r0, r4, #0
    2028:	00028d11 	andeq	r8, r2, r1, lsl sp
    202c:	61681b00 	cmnvs	r8, r0, lsl #22
    2030:	0705006c 	streq	r0, [r5, -ip, rrx]
    2034:	0006b40b 	andeq	fp, r6, fp, lsl #8
    2038:	06801c00 	streq	r1, [r0], r0, lsl #24
    203c:	09050000 	stmdbeq	r5, {}	; <UNPREDICTABLE>
    2040:	0000801c 	andeq	r8, r0, ip, lsl r0
    2044:	e6b28000 	ldrt	r8, [r2], r0
    2048:	03e61c0e 	mvneq	r1, #3584	; 0xe00
    204c:	0c050000 	stceq	0, cr0, [r5], {-0}
    2050:	0006c01d 	andeq	ip, r6, sp, lsl r0
    2054:	00000000 	andeq	r0, r0, r0
    2058:	04c41c20 	strbeq	r1, [r4], #3104	; 0xc20
    205c:	0f050000 	svceq	0x00050000
    2060:	0006c01d 	andeq	ip, r6, sp, lsl r0
    2064:	20000000 	andcs	r0, r0, r0
    2068:	05301d20 	ldreq	r1, [r0, #-3360]!	; 0xfffff2e0
    206c:	12050000 	andne	r0, r5, #0
    2070:	00006f18 	andeq	r6, r0, r8, lsl pc
    2074:	271c3600 	ldrcs	r3, [ip, -r0, lsl #12]
    2078:	05000006 	streq	r0, [r0, #-6]
    207c:	06c01d44 	strbeq	r1, [r0], r4, asr #26
    2080:	50000000 	andpl	r0, r0, r0
    2084:	661c2021 	ldrvs	r2, [ip], -r1, lsr #32
    2088:	05000002 	streq	r0, [r0, #-2]
    208c:	06c01d73 			; <UNDEFINED> instruction: 0x06c01d73
    2090:	b2000000 	andlt	r0, r0, #0
    2094:	fe072000 	cdp2	0, 0, cr2, cr7, cr0, {0}
    2098:	0500000c 	streq	r0, [r0, #-12]
    209c:	00003804 	andeq	r3, r0, r4, lsl #16
    20a0:	10750500 	rsbsne	r0, r5, r0, lsl #10
    20a4:	000005ba 			; <UNDEFINED> instruction: 0x000005ba
    20a8:	000e5908 	andeq	r5, lr, r8, lsl #18
    20ac:	c9080000 	stmdbgt	r8, {}	; <UNPREDICTABLE>
    20b0:	0100000d 	tsteq	r0, sp
    20b4:	000dd708 	andeq	sp, sp, r8, lsl #14
    20b8:	78080200 	stmdavc	r8, {r9}
    20bc:	0300000f 	movweq	r0, #15
    20c0:	000d5e08 	andeq	r5, sp, r8, lsl #28
    20c4:	6b080400 	blvs	2030cc <_bss_end+0x1f755c>
    20c8:	0500000d 	streq	r0, [r0, #-13]
    20cc:	000e7b08 	andeq	r7, lr, r8, lsl #22
    20d0:	42080600 	andmi	r0, r8, #0, 12
    20d4:	0700000d 	streq	r0, [r0, -sp]
    20d8:	000d5008 	andeq	r5, sp, r8
    20dc:	29080800 	stmdbcs	r8, {fp}
    20e0:	0900000f 	stmdbeq	r0, {r0, r1, r2, r3}
    20e4:	0de50700 	stcleq	7, cr0, [r5]
    20e8:	04050000 	streq	r0, [r5], #-0
    20ec:	00000038 	andeq	r0, r0, r8, lsr r0
    20f0:	fd108305 	ldc2	3, cr8, [r0, #-20]	; 0xffffffec
    20f4:	08000005 	stmdaeq	r0, {r0, r2}
    20f8:	00000b76 	andeq	r0, r0, r6, ror fp
    20fc:	0e8c0800 	cdpeq	8, 8, cr0, cr12, cr0, {0}
    2100:	08010000 	stmdaeq	r1, {}	; <UNPREDICTABLE>
    2104:	00000d17 	andeq	r0, r0, r7, lsl sp
    2108:	0d290802 	stceq	8, cr0, [r9, #-8]!
    210c:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    2110:	00001026 	andeq	r1, r0, r6, lsr #32
    2114:	0e6b0804 	cdpeq	8, 6, cr0, cr11, cr4, {0}
    2118:	08050000 	stmdaeq	r5, {}	; <UNPREDICTABLE>
    211c:	00000e30 	andeq	r0, r0, r0, lsr lr
    2120:	0e410806 	cdpeq	8, 4, cr0, cr1, cr6, {0}
    2124:	00070000 	andeq	r0, r7, r0
    2128:	000cf307 	andeq	pc, ip, r7, lsl #6
    212c:	38040500 	stmdacc	r4, {r8, sl}
    2130:	05000000 	streq	r0, [r0, #-0]
    2134:	065e108f 	ldrbeq	r1, [lr], -pc, lsl #1
    2138:	41140000 	tstmi	r4, r0
    213c:	1d005855 	stcne	8, cr5, [r0, #-340]	; 0xfffffeac
    2140:	000f5a08 	andeq	r5, pc, r8, lsl #20
    2144:	f6082b00 			; <UNDEFINED> instruction: 0xf6082b00
    2148:	2d00000d 	stccs	0, cr0, [r0, #-52]	; 0xffffffcc
    214c:	000e7508 	andeq	r7, lr, r8, lsl #10
    2150:	53142e00 	tstpl	r4, #0, 28
    2154:	3000494d 	andcc	r4, r0, sp, asr #18
    2158:	000d2208 	andeq	r2, sp, r8, lsl #4
    215c:	52083100 	andpl	r3, r8, #0, 2
    2160:	3200000e 	andcc	r0, r0, #14
    2164:	000d3408 	andeq	r3, sp, r8, lsl #8
    2168:	3b083300 	blcc	20ed70 <_bss_end+0x203200>
    216c:	3400000d 	strcc	r0, [r0], #-13
    2170:	43324914 	teqmi	r2, #20, 18	; 0x50000
    2174:	53143500 	tstpl	r4, #0, 10
    2178:	36004950 			; <UNDEFINED> instruction: 0x36004950
    217c:	4d435014 	stclmi	0, cr5, [r3, #-80]	; 0xffffffb0
    2180:	fc083700 	stc2	7, cr3, [r8], {-0}
    2184:	3900000d 	stmdbcc	r0, {r0, r2, r3}
    2188:	05441c00 	strbeq	r1, [r4, #-3072]	; 0xfffff400
    218c:	a6050000 	strge	r0, [r5], -r0
    2190:	0006c01d 	andeq	ip, r6, sp, lsl r0
    2194:	00b40000 	adcseq	r0, r4, r0
    2198:	0b231e20 	bleq	8c9a20 <_bss_end+0x8bdeb0>
    219c:	04050000 	streq	r0, [r5], #-0
    21a0:	00000038 	andeq	r0, r0, r8, lsr r0
    21a4:	0810a805 	ldmdaeq	r0, {r0, r2, fp, sp, pc}
    21a8:	00000b70 	andeq	r0, r0, r0, ror fp
    21ac:	0af60800 	beq	ffd841b4 <_bss_end+0xffd78644>
    21b0:	08010000 	stmdaeq	r1, {}	; <UNPREDICTABLE>
    21b4:	00000f7c 	andeq	r0, r0, ip, ror pc
    21b8:	0abf0802 	beq	fefc41c8 <_bss_end+0xfefb8658>
    21bc:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    21c0:	00000be8 	andeq	r0, r0, r8, ror #23
    21c4:	09fd0804 	ldmibeq	sp!, {r2, fp}^
    21c8:	08050000 	stmdaeq	r5, {}	; <UNPREDICTABLE>
    21cc:	000009e9 	andeq	r0, r0, r9, ror #19
    21d0:	0b170806 	bleq	5c41f0 <_bss_end+0x5b8680>
    21d4:	08070000 	stmdaeq	r7, {}	; <UNPREDICTABLE>
    21d8:	00000bb6 			; <UNDEFINED> instruction: 0x00000bb6
    21dc:	1f000008 	svcne	0x00000008
    21e0:	0000050e 	andeq	r0, r0, lr, lsl #10
    21e4:	5d070402 	cfstrspl	mvf0, [r7, #-8]
    21e8:	0300001e 	movweq	r0, #30
    21ec:	000006b9 			; <UNDEFINED> instruction: 0x000006b9
    21f0:	00051e1f 	andeq	r1, r5, pc, lsl lr
    21f4:	052e1f00 	streq	r1, [lr, #-3840]!	; 0xfffff100
    21f8:	3e1f0000 	cdpcc	0, 1, cr0, cr15, cr0, {0}
    21fc:	1f000005 	svcne	0x00000005
    2200:	0000054b 	andeq	r0, r0, fp, asr #10
    2204:	00055b1f 	andeq	r5, r5, pc, lsl fp
    2208:	065e1f00 	ldrbeq	r1, [lr], -r0, lsl #30
    220c:	77070000 	strvc	r0, [r7, -r0]
    2210:	0700000a 	streq	r0, [r0, -sl]
    2214:	00004401 	andeq	r4, r0, r1, lsl #8
    2218:	0c060600 	stceq	6, cr0, [r6], {-0}
    221c:	00000708 	andeq	r0, r0, r8, lsl #14
    2220:	000a9f08 	andeq	r9, sl, r8, lsl #30
    2224:	c9080000 	stmdbgt	r8, {}	; <UNPREDICTABLE>
    2228:	0100000a 	tsteq	r0, sl
    222c:	000a4f08 	andeq	r4, sl, r8, lsl #30
    2230:	09000200 	stmdbeq	r0, {r9}
    2234:	00000b75 	andeq	r0, r0, r5, ror fp
    2238:	070d0608 	streq	r0, [sp, -r8, lsl #12]
    223c:	00000800 	andeq	r0, r0, r0, lsl #16
    2240:	000aea0a 	andeq	lr, sl, sl, lsl #20
    2244:	1c150600 	ldcne	6, cr0, [r5], {-0}
    2248:	00000258 	andeq	r0, r0, r8, asr r2
    224c:	0bd82000 	bleq	ff60a254 <_bss_end+0xff5fe6e4>
    2250:	11060000 	mrsne	r0, (UNDEF: 6)
    2254:	0008000b 	andeq	r0, r8, fp
    2258:	7c0a0100 	stfvcs	f0, [sl], {-0}
    225c:	0600000b 	streq	r0, [r0], -fp
    2260:	07221518 			; <UNDEFINED> instruction: 0x07221518
    2264:	0b040000 	bleq	10226c <_bss_end+0xf66fc>
    2268:	00000af1 	strdeq	r0, [r0], -r1
    226c:	861c1b06 	ldrhi	r1, [ip], -r6, lsl #22
    2270:	0700000b 	streq	r0, [r0, -fp]
    2274:	02000008 	andeq	r0, r0, #8
    2278:	00000755 	andeq	r0, r0, r5, asr r7
    227c:	00000760 	andeq	r0, r0, r0, ror #14
    2280:	00080d0c 	andeq	r0, r8, ip, lsl #26
    2284:	066e0d00 	strbteq	r0, [lr], -r0, lsl #26
    2288:	0b000000 	bleq	2290 <CPSR_IRQ_INHIBIT+0x2210>
    228c:	00000b75 	andeq	r0, r0, r5, ror fp
    2290:	a7051e06 	strge	r1, [r5, -r6, lsl #28]
    2294:	0d00000b 	stceq	0, cr0, [r0, #-44]	; 0xffffffd4
    2298:	01000008 	tsteq	r0, r8
    229c:	00000779 	andeq	r0, r0, r9, ror r7
    22a0:	00000784 	andeq	r0, r0, r4, lsl #15
    22a4:	00080d0c 	andeq	r0, r8, ip, lsl #26
    22a8:	06b90d00 	ldrteq	r0, [r9], r0, lsl #26
    22ac:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    22b0:	00000e85 	andeq	r0, r0, r5, lsl #29
    22b4:	5d0a2106 	stfpls	f2, [sl, #-24]	; 0xffffffe8
    22b8:	0100000a 	tsteq	r0, sl
    22bc:	00000799 	muleq	r0, r9, r7
    22c0:	000007ae 	andeq	r0, r0, lr, lsr #15
    22c4:	00080d0c 	andeq	r0, r8, ip, lsl #26
    22c8:	07220d00 	streq	r0, [r2, -r0, lsl #26]!
    22cc:	740d0000 	strvc	r0, [sp], #-0
    22d0:	0d000000 	stceq	0, cr0, [r0, #-0]
    22d4:	000006e3 	andeq	r0, r0, r3, ror #13
    22d8:	0f330e00 	svceq	0x00330e00
    22dc:	23060000 	movwcs	r0, #24576	; 0x6000
    22e0:	000b2d0a 	andeq	r2, fp, sl, lsl #26
    22e4:	07c30100 	strbeq	r0, [r3, r0, lsl #2]
    22e8:	07c90000 	strbeq	r0, [r9, r0]
    22ec:	0d0c0000 	stceq	0, cr0, [ip, #-0]
    22f0:	00000008 	andeq	r0, r0, r8
    22f4:	0009f00e 	andeq	pc, r9, lr
    22f8:	0a260600 	beq	983b00 <_bss_end+0x977f90>
    22fc:	00000bf0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    2300:	0007de01 	andeq	sp, r7, r1, lsl #28
    2304:	0007e400 	andeq	lr, r7, r0, lsl #8
    2308:	080d0c00 	stmdaeq	sp, {sl, fp}
    230c:	0f000000 	svceq	0x00000000
    2310:	00000bc3 	andeq	r0, r0, r3, asr #23
    2314:	580a2806 	stmdapl	sl, {r1, r2, fp, sp}
    2318:	63000009 	movwvs	r0, #9
    231c:	01000002 	tsteq	r0, r2
    2320:	000007f9 	strdeq	r0, [r0], -r9
    2324:	00080d0c 	andeq	r0, r8, ip, lsl #26
    2328:	10000000 	andne	r0, r0, r0
    232c:	00080604 	andeq	r0, r8, r4, lsl #12
    2330:	04112100 	ldreq	r2, [r1], #-256	; 0xffffff00
    2334:	0000007b 	andeq	r0, r0, fp, ror r0
    2338:	07080410 	smladeq	r8, r0, r4, r0
    233c:	51120000 	tstpl	r2, r0
    2340:	06000009 	streq	r0, [r0], -r9
    2344:	07080f2b 	streq	r0, [r8, -fp, lsr #30]
    2348:	eb090000 	bl	242350 <_bss_end+0x2367e0>
    234c:	0400000e 	streq	r0, [r0], #-14
    2350:	fe070507 	cdp2	5, 0, cr0, cr7, cr7, {0}
    2354:	0a000008 	beq	237c <CPSR_IRQ_INHIBIT+0x22fc>
    2358:	00000db9 			; <UNDEFINED> instruction: 0x00000db9
    235c:	581c0907 	ldmdapl	ip, {r0, r1, r2, r8, fp}
    2360:	00000002 	andeq	r0, r0, r2
    2364:	000af10b 	andeq	pc, sl, fp, lsl #2
    2368:	1c0c0700 	stcne	7, cr0, [ip], {-0}
    236c:	00000d78 	andeq	r0, r0, r8, ror sp
    2370:	00000807 	andeq	r0, r0, r7, lsl #16
    2374:	00085202 	andeq	r5, r8, r2, lsl #4
    2378:	00085d00 	andeq	r5, r8, r0, lsl #26
    237c:	08fe0c00 	ldmeq	lr!, {sl, fp}^
    2380:	6b0d0000 	blvs	342388 <_bss_end+0x336818>
    2384:	00000005 	andeq	r0, r0, r5
    2388:	000eeb0b 	andeq	lr, lr, fp, lsl #22
    238c:	050f0700 	streq	r0, [pc, #-1792]	; 1c94 <CPSR_IRQ_INHIBIT+0x1c14>
    2390:	00000f3b 	andeq	r0, r0, fp, lsr pc
    2394:	000008fe 	strdeq	r0, [r0], -lr
    2398:	00087601 	andeq	r7, r8, r1, lsl #12
    239c:	00088100 	andeq	r8, r8, r0, lsl #2
    23a0:	08fe0c00 	ldmeq	lr!, {sl, fp}^
    23a4:	b90d0000 	stmdblt	sp, {}	; <UNPREDICTABLE>
    23a8:	00000006 	andeq	r0, r0, r6
    23ac:	000e0d0e 	andeq	r0, lr, lr, lsl #26
    23b0:	0a120700 	beq	483fb8 <_bss_end+0x478448>
    23b4:	00000cad 	andeq	r0, r0, sp, lsr #25
    23b8:	00089601 	andeq	r9, r8, r1, lsl #12
    23bc:	0008a100 	andeq	sl, r8, r0, lsl #2
    23c0:	08fe0c00 	ldmeq	lr!, {sl, fp}^
    23c4:	ba0d0000 	blt	3423cc <_bss_end+0x33685c>
    23c8:	00000005 	andeq	r0, r0, r5
    23cc:	000e1e0e 	andeq	r1, lr, lr, lsl #28
    23d0:	0a140700 	beq	503fd8 <_bss_end+0x4f8468>
    23d4:	00000c66 	andeq	r0, r0, r6, ror #24
    23d8:	0008b601 	andeq	fp, r8, r1, lsl #12
    23dc:	0008c100 	andeq	ip, r8, r0, lsl #2
    23e0:	08fe0c00 	ldmeq	lr!, {sl, fp}^
    23e4:	ba0d0000 	blt	3423ec <_bss_end+0x33687c>
    23e8:	00000005 	andeq	r0, r0, r5
    23ec:	00101b0e 	andseq	r1, r0, lr, lsl #22
    23f0:	0a170700 	beq	5c3ff8 <_bss_end+0x5b8488>
    23f4:	00000eb1 			; <UNDEFINED> instruction: 0x00000eb1
    23f8:	0008d601 	andeq	sp, r8, r1, lsl #12
    23fc:	0008e100 	andeq	lr, r8, r0, lsl #2
    2400:	08fe0c00 	ldmeq	lr!, {sl, fp}^
    2404:	fd0d0000 	stc2	0, cr0, [sp, #-0]
    2408:	00000005 	andeq	r0, r0, r5
    240c:	000e0122 	andeq	r0, lr, r2, lsr #2
    2410:	0a190700 	beq	644018 <_bss_end+0x6384a8>
    2414:	00000c14 	andeq	r0, r0, r4, lsl ip
    2418:	0008f201 	andeq	pc, r8, r1, lsl #4
    241c:	08fe0c00 	ldmeq	lr!, {sl, fp}^
    2420:	fd0d0000 	stc2	0, cr0, [sp, #-0]
    2424:	00000005 	andeq	r0, r0, r5
    2428:	1f041000 	svcne	0x00041000
    242c:	12000008 	andne	r0, r0, #8
    2430:	00000ea3 	andeq	r0, r0, r3, lsr #29
    2434:	1f1e1c07 	svcne	0x001e1c07
    2438:	1b000008 	blne	2460 <CPSR_IRQ_INHIBIT+0x23e0>
    243c:	006d656d 	rsbeq	r6, sp, sp, ror #10
    2440:	690b0608 	stmdbvs	fp, {r3, r9, sl}
    2444:	1c000009 	stcne	0, cr0, [r0], {9}
    2448:	0000118c 	andeq	r1, r0, ip, lsl #3
    244c:	6f180a08 	svcvs	0x00180a08
    2450:	00000000 	andeq	r0, r0, r0
    2454:	1c000200 	sfmne	f0, 4, [r0], {-0}
    2458:	0000106c 	andeq	r1, r0, ip, rrx
    245c:	6f180d08 	svcvs	0x00180d08
    2460:	00000000 	andeq	r0, r0, r0
    2464:	23200000 	nopcs	{0}	; <UNPREDICTABLE>
    2468:	000013de 	ldrdeq	r1, [r0], -lr
    246c:	6f181008 	svcvs	0x00181008
    2470:	00000000 	andeq	r0, r0, r0
    2474:	12711c40 	rsbsne	r1, r1, #64, 24	; 0x4000
    2478:	13080000 	movwne	r0, #32768	; 0x8000
    247c:	00006f18 	andeq	r6, r0, r8, lsl pc
    2480:	fe000000 	cdp2	0, 0, cr0, cr0, cr0, {0}
    2484:	1035231f 	eorsne	r2, r5, pc, lsl r3
    2488:	16080000 	strne	r0, [r8], -r0
    248c:	00006f18 	andeq	r6, r0, r8, lsl pc
    2490:	007ff800 	rsbseq	pc, pc, r0, lsl #16
    2494:	00091c1f 	andeq	r1, r9, pc, lsl ip
    2498:	092c1f00 	stmdbeq	ip!, {r8, r9, sl, fp, ip}
    249c:	3c1f0000 	ldccc	0, cr0, [pc], {-0}
    24a0:	1f000009 	svcne	0x00000009
    24a4:	0000094a 	andeq	r0, r0, sl, asr #18
    24a8:	00095a1f 	andeq	r5, r9, pc, lsl sl
    24ac:	12f81500 	rscsne	r1, r8, #0, 10
    24b0:	09100000 	ldmdbeq	r0, {}	; <UNPREDICTABLE>
    24b4:	09c40808 	stmibeq	r4, {r3, fp}^
    24b8:	300a0000 	andcc	r0, sl, r0
    24bc:	09000010 	stmdbeq	r0, {r4}
    24c0:	09c4200a 	stmibeq	r4, {r1, r3, sp}^
    24c4:	0a000000 	beq	24cc <CPSR_IRQ_INHIBIT+0x244c>
    24c8:	00001077 	andeq	r1, r0, r7, ror r0
    24cc:	c4200b09 	strtgt	r0, [r0], #-2825	; 0xfffff4f7
    24d0:	04000009 	streq	r0, [r0], #-9
    24d4:	00113e0a 	andseq	r3, r1, sl, lsl #28
    24d8:	0e0c0900 	vmlaeq.f16	s0, s24, s0	; <UNPREDICTABLE>
    24dc:	00000063 	andeq	r0, r0, r3, rrx
    24e0:	10c40a08 	sbcne	r0, r4, r8, lsl #20
    24e4:	0d090000 	stceq	0, cr0, [r9, #-0]
    24e8:	0002630a 	andeq	r6, r2, sl, lsl #6
    24ec:	10000c00 	andne	r0, r0, r0, lsl #24
    24f0:	00098204 	andeq	r8, r9, r4, lsl #4
    24f4:	11d60900 	bicsne	r0, r6, r0, lsl #18
    24f8:	09040000 	stmdbeq	r4, {}	; <UNPREDICTABLE>
    24fc:	0a620710 	beq	1884144 <_bss_end+0x18785d4>
    2500:	bb0a0000 	bllt	282508 <_bss_end+0x276998>
    2504:	09000012 	stmdbeq	r0, {r1, r4}
    2508:	09c42013 	stmibeq	r4, {r0, r1, r4, sp}^
    250c:	24000000 	strcs	r0, [r0], #-0
    2510:	00001330 	andeq	r1, r0, r0, lsr r3
    2514:	11201509 			; <UNDEFINED> instruction: 0x11201509
    2518:	c4000011 	strgt	r0, [r0], #-17	; 0xffffffef
    251c:	fc000009 	stc2	0, cr0, [r0], {9}
    2520:	02000009 	andeq	r0, r0, #9
    2524:	0c00000a 	stceq	0, cr0, [r0], {10}
    2528:	00000a62 	andeq	r0, r0, r2, ror #20
    252c:	11d60b00 	bicsne	r0, r6, r0, lsl #22
    2530:	18090000 	stmdane	r9, {}	; <UNPREDICTABLE>
    2534:	00129d05 	andseq	r9, r2, r5, lsl #26
    2538:	000a6200 	andeq	r6, sl, r0, lsl #4
    253c:	0a1b0100 	beq	6c2944 <_bss_end+0x6b6dd4>
    2540:	0a210000 	beq	842548 <_bss_end+0x8369d8>
    2544:	620c0000 	andvs	r0, ip, #0
    2548:	0000000a 	andeq	r0, r0, sl
    254c:	0011f40b 	andseq	pc, r1, fp, lsl #8
    2550:	0b1a0900 	bleq	684958 <_bss_end+0x678de8>
    2554:	00001202 	andeq	r1, r0, r2, lsl #4
    2558:	00000a68 	andeq	r0, r0, r8, ror #20
    255c:	000a3a01 	andeq	r3, sl, r1, lsl #20
    2560:	000a4500 	andeq	r4, sl, r0, lsl #10
    2564:	0a620c00 	beq	188556c <_bss_end+0x18799fc>
    2568:	630d0000 	movwvs	r0, #53248	; 0xd000
    256c:	00000000 	andeq	r0, r0, r0
    2570:	00114322 	andseq	r4, r1, r2, lsr #6
    2574:	0a1b0900 	beq	6c497c <_bss_end+0x6b8e0c>
    2578:	0000116a 	andeq	r1, r0, sl, ror #2
    257c:	000a5601 	andeq	r5, sl, r1, lsl #12
    2580:	0a620c00 	beq	1885588 <_bss_end+0x1879a18>
    2584:	680d0000 	stmdavs	sp, {}	; <UNPREDICTABLE>
    2588:	0000000a 	andeq	r0, r0, sl
    258c:	ca041000 	bgt	106594 <_bss_end+0xfaa24>
    2590:	25000009 	strcs	r0, [r0, #-9]
    2594:	14281204 	strtne	r1, [r8], #-516	; 0xfffffdfc
    2598:	24090000 	strcs	r0, [r9], #-0
    259c:	0009ca1d 	andeq	ip, r9, sp, lsl sl
    25a0:	11480700 	cmpne	r8, r0, lsl #14
    25a4:	04050000 	streq	r0, [r5], #-0
    25a8:	00000038 	andeq	r0, r0, r8, lsr r0
    25ac:	a10c040a 	tstge	ip, sl, lsl #8
    25b0:	1400000a 	strne	r0, [r0], #-10
    25b4:	0077654e 	rsbseq	r6, r7, lr, asr #10
    25b8:	11eb0800 	mvnne	r0, r0, lsl #16
    25bc:	08010000 	stmdaeq	r1, {}	; <UNPREDICTABLE>
    25c0:	00000bbb 			; <UNDEFINED> instruction: 0x00000bbb
    25c4:	11a00802 	lslne	r0, r2, #16
    25c8:	00030000 	andeq	r0, r3, r0
    25cc:	0010cc15 	andseq	ip, r0, r5, lsl ip
    25d0:	110a0c00 	tstne	sl, r0, lsl #24
    25d4:	000ad308 	andeq	sp, sl, r8, lsl #6
    25d8:	726c1600 	rsbvc	r1, ip, #0, 12
    25dc:	13130a00 	tstne	r3, #0, 20
    25e0:	000006b9 			; <UNDEFINED> instruction: 0x000006b9
    25e4:	70731600 	rsbsvc	r1, r3, r0, lsl #12
    25e8:	13140a00 	tstne	r4, #0, 20
    25ec:	000006b9 			; <UNDEFINED> instruction: 0x000006b9
    25f0:	63701604 	cmnvs	r0, #4, 12	; 0x400000
    25f4:	13150a00 	tstne	r5, #0, 20
    25f8:	000006b9 			; <UNDEFINED> instruction: 0x000006b9
    25fc:	87150008 	ldrhi	r0, [r5, -r8]
    2600:	1c000012 	stcne	0, cr0, [r0], {18}
    2604:	22081b0a 	andcs	r1, r8, #10240	; 0x2800
    2608:	0a00000b 	beq	263c <CPSR_IRQ_INHIBIT+0x25bc>
    260c:	00001265 	andeq	r1, r0, r5, ror #4
    2610:	a1121d0a 	tstge	r2, sl, lsl #26
    2614:	0000000a 	andeq	r0, r0, sl
    2618:	64697016 	strbtvs	r7, [r9], #-22	; 0xffffffea
    261c:	121e0a00 	andsne	r0, lr, #0, 20
    2620:	00000074 	andeq	r0, r0, r4, ror r0
    2624:	1bae0a0c 	blne	feb84e5c <_bss_end+0xfeb792ec>
    2628:	1f0a0000 	svcne	0x000a0000
    262c:	000a7611 	andeq	r7, sl, r1, lsl r6
    2630:	c80a1000 	stmdagt	sl, {ip}
    2634:	0a000011 	beq	2680 <CPSR_IRQ_INHIBIT+0x2600>
    2638:	00741220 	rsbseq	r1, r4, r0, lsr #4
    263c:	0a140000 	beq	502644 <_bss_end+0x4f6ad4>
    2640:	00001154 	andeq	r1, r0, r4, asr r1
    2644:	7412210a 	ldrvc	r2, [r2], #-266	; 0xfffffef6
    2648:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
    264c:	12e51500 	rscne	r1, r5, #0, 10
    2650:	0b0c0000 	bleq	302658 <_bss_end+0x2f6ae8>
    2654:	0b570807 	bleq	15c4678 <_bss_end+0x15b8b08>
    2658:	300a0000 	andcc	r0, sl, r0
    265c:	0b000010 	bleq	26a4 <CPSR_IRQ_INHIBIT+0x2624>
    2660:	0b571909 	bleq	15c8a8c <_bss_end+0x15bcf1c>
    2664:	0a000000 	beq	266c <CPSR_IRQ_INHIBIT+0x25ec>
    2668:	00001077 	andeq	r1, r0, r7, ror r0
    266c:	57190a0b 	ldrpl	r0, [r9, -fp, lsl #20]
    2670:	0400000b 	streq	r0, [r0], #-11
    2674:	0012820a 	andseq	r8, r2, sl, lsl #4
    2678:	130b0b00 	movwne	r0, #47872	; 0xbb00
    267c:	00000b5d 	andeq	r0, r0, sp, asr fp
    2680:	04100008 	ldreq	r0, [r0], #-8
    2684:	00000b22 	andeq	r0, r0, r2, lsr #22
    2688:	0ad30410 	beq	ff4c36d0 <_bss_end+0xff4b7b60>
    268c:	b3090000 	movwlt	r0, #36864	; 0x9000
    2690:	0c000010 	stceq	0, cr0, [r0], {16}
    2694:	4b070e0b 	blmi	1c5ec8 <_bss_end+0x1ba358>
    2698:	0a00000c 	beq	26d0 <CPSR_IRQ_INHIBIT+0x2650>
    269c:	00001196 	muleq	r0, r6, r1
    26a0:	630e120b 	movwvs	r1, #57867	; 0xe20b
    26a4:	00000000 	andeq	r0, r0, r0
    26a8:	00136b0a 	andseq	r6, r3, sl, lsl #22
    26ac:	19150b00 	ldmdbne	r5, {r8, r9, fp}
    26b0:	00000b57 	andeq	r0, r0, r7, asr fp
    26b4:	12520a04 	subsne	r0, r2, #4, 20	; 0x4000
    26b8:	180b0000 	stmdane	fp, {}	; <UNPREDICTABLE>
    26bc:	000b5719 	andeq	r5, fp, r9, lsl r7
    26c0:	261a0800 	ldrcs	r0, [sl], -r0, lsl #16
    26c4:	0b000013 	bleq	2718 <CPSR_IRQ_INHIBIT+0x2698>
    26c8:	12c20a1b 	sbcne	r0, r2, #110592	; 0x1b000
    26cc:	0bab0000 	bleq	feac26d4 <_bss_end+0xfeab6b64>
    26d0:	0bb60000 	bleq	fed826d8 <_bss_end+0xfed76b68>
    26d4:	500c0000 	andpl	r0, ip, r0
    26d8:	0d00000c 	stceq	0, cr0, [r0, #-48]	; 0xffffffd0
    26dc:	00000b57 	andeq	r0, r0, r7, asr fp
    26e0:	10b30b00 	adcsne	r0, r3, r0, lsl #22
    26e4:	1e0b0000 	cdpne	0, 0, cr0, cr11, cr0, {0}
    26e8:	0010e305 	andseq	lr, r0, r5, lsl #6
    26ec:	000c5000 	andeq	r5, ip, r0
    26f0:	0bcf0100 	bleq	ff3c2af8 <_bss_end+0xff3b6f88>
    26f4:	0bd50000 	bleq	ff5426fc <_bss_end+0xff536b8c>
    26f8:	500c0000 	andpl	r0, ip, r0
    26fc:	0000000c 	andeq	r0, r0, ip
    2700:	0013120e 	andseq	r1, r3, lr, lsl #4
    2704:	0a210b00 	beq	84530c <_bss_end+0x83979c>
    2708:	0000103f 	andeq	r1, r0, pc, lsr r0
    270c:	000bea01 	andeq	lr, fp, r1, lsl #20
    2710:	000bf000 	andeq	pc, fp, r0
    2714:	0c500c00 	mrrceq	12, 0, r0, r0, cr0	; <UNPREDICTABLE>
    2718:	0b000000 	bleq	2720 <CPSR_IRQ_INHIBIT+0x26a0>
    271c:	000010a4 	andeq	r1, r0, r4, lsr #1
    2720:	7c0e240b 	cfstrsvc	mvf2, [lr], {11}
    2724:	63000010 	movwvs	r0, #16
    2728:	01000000 	mrseq	r0, (UNDEF: 0)
    272c:	00000c09 	andeq	r0, r0, r9, lsl #24
    2730:	00000c14 	andeq	r0, r0, r4, lsl ip
    2734:	000c500c 	andeq	r5, ip, ip
    2738:	06b90d00 	ldrteq	r0, [r9], r0, lsl #26
    273c:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    2740:	00001294 	muleq	r0, r4, r2
    2744:	a70a270b 	strge	r2, [sl, -fp, lsl #14]
    2748:	01000011 	tsteq	r0, r1, lsl r0
    274c:	00000c29 	andeq	r0, r0, r9, lsr #24
    2750:	00000c2f 	andeq	r0, r0, pc, lsr #24
    2754:	000c500c 	andeq	r5, ip, ip
    2758:	fd0f0000 	stc2	0, cr0, [pc, #-0]	; 2760 <CPSR_IRQ_INHIBIT+0x26e0>
    275c:	0b000010 	bleq	27a4 <CPSR_IRQ_INHIBIT+0x2724>
    2760:	1224132a 	eorne	r1, r4, #-1476395008	; 0xa8000000
    2764:	0b5d0000 	bleq	174276c <_bss_end+0x1736bfc>
    2768:	44010000 	strmi	r0, [r1], #-0
    276c:	0c00000c 	stceq	0, cr0, [r0], {12}
    2770:	00000c56 	andeq	r0, r0, r6, asr ip
    2774:	63030000 	movwvs	r0, #12288	; 0x3000
    2778:	1000000b 	andne	r0, r0, fp
    277c:	000b6304 	andeq	r6, fp, r4, lsl #6
    2780:	4b041000 	blmi	106788 <_bss_end+0xfac18>
    2784:	1200000c 	andne	r0, r0, #12
    2788:	00001663 	andeq	r1, r0, r3, ror #12
    278c:	63192d0b 	tstvs	r9, #704	; 0x2c0
    2790:	2600000b 	strcs	r0, [r0], -fp
    2794:	000010d9 	ldrdeq	r1, [r0], -r9
    2798:	6a0f0e01 	bvs	3c5fa4 <_bss_end+0x3ba434>
    279c:	05000002 	streq	r0, [r0, #-2]
    27a0:	00ab4c03 	adceq	r4, fp, r3, lsl #24
    27a4:	11fa2700 	mvnsne	r2, r0, lsl #14
    27a8:	11010000 	mrsne	r0, (UNDEF: 1)
    27ac:	00006f14 	andeq	r6, r0, r4, lsl pc
    27b0:	a4030500 	strge	r0, [r3], #-1280	; 0xfffffb00
    27b4:	280000a9 	stmdacs	r0, {r0, r3, r5, r7}
    27b8:	0000135e 	andeq	r1, r0, lr, asr r3
    27bc:	38106301 	ldmdacc	r0, {r0, r8, r9, sp, lr}
    27c0:	e0000000 	and	r0, r0, r0
    27c4:	dc000094 	stcle	0, cr0, [r0], {148}	; 0x94
    27c8:	01000000 	mrseq	r0, (UNDEF: 0)
    27cc:	1354299c 	cmpne	r4, #156, 18	; 0x270000
    27d0:	52010000 	andpl	r0, r1, #0
    27d4:	00947411 	addseq	r7, r4, r1, lsl r4
    27d8:	00006c00 	andeq	r6, r0, r0, lsl #24
    27dc:	c69c0100 	ldrgt	r0, [ip], r0, lsl #2
    27e0:	2a00000c 	bcs	2818 <CPSR_IRQ_INHIBIT+0x2798>
    27e4:	54010069 	strpl	r0, [r1], #-105	; 0xffffff97
    27e8:	00003f12 	andeq	r3, r0, r2, lsl pc
    27ec:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    27f0:	134a2900 	movtne	r2, #43264	; 0xa900
    27f4:	41010000 	mrsmi	r0, (UNDEF: 1)
    27f8:	00940811 	addseq	r0, r4, r1, lsl r8
    27fc:	00006c00 	andeq	r6, r0, r0, lsl #24
    2800:	ea9c0100 	b	fe702c08 <_bss_end+0xfe6f7098>
    2804:	2a00000c 	bcs	283c <CPSR_IRQ_INHIBIT+0x27bc>
    2808:	43010069 	movwmi	r0, #4201	; 0x1069
    280c:	00003f12 	andeq	r3, r0, r2, lsl pc
    2810:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    2814:	137e2900 	cmnne	lr, #0, 18
    2818:	30010000 	andcc	r0, r1, r0
    281c:	00939c11 	addseq	r9, r3, r1, lsl ip
    2820:	00006c00 	andeq	r6, r0, r0, lsl #24
    2824:	0e9c0100 	fmleqe	f0, f4, f0
    2828:	2a00000d 	bcs	2864 <CPSR_IRQ_INHIBIT+0x27e4>
    282c:	32010069 	andcc	r0, r1, #105	; 0x69
    2830:	00003f12 	andeq	r3, r0, r2, lsl pc
    2834:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    2838:	13402900 	movtne	r2, #2304	; 0x900
    283c:	1f010000 	svcne	0x00010000
    2840:	00933011 	addseq	r3, r3, r1, lsl r0
    2844:	00006c00 	andeq	r6, r0, r0, lsl #24
    2848:	329c0100 	addscc	r0, ip, #0, 2
    284c:	2a00000d 	bcs	2888 <CPSR_IRQ_INHIBIT+0x2808>
    2850:	21010069 	tstcs	r1, r9, rrx
    2854:	00003f12 	andeq	r3, r0, r2, lsl pc
    2858:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    285c:	0bd92b00 	bleq	ff64d464 <_bss_end+0xff6418f4>
    2860:	17010000 	strne	r0, [r1, -r0]
    2864:	0092d411 	addseq	sp, r2, r1, lsl r4
    2868:	00005c00 	andeq	r5, r0, r0, lsl #24
    286c:	009c0100 	addseq	r0, ip, r0, lsl #2
    2870:	0000049f 	muleq	r0, pc, r4	; <UNPREDICTABLE>
    2874:	0e170004 	cdpeq	0, 1, cr0, cr7, cr4, {0}
    2878:	01040000 	mrseq	r0, (UNDEF: 4)
    287c:	00000000 	andeq	r0, r0, r0
    2880:	00147204 	andseq	r7, r4, r4, lsl #4
    2884:	0000b600 	andeq	fp, r0, r0, lsl #12
    2888:	0095bc00 	addseq	fp, r5, r0, lsl #24
    288c:	00036c00 	andeq	r6, r3, r0, lsl #24
    2890:	000fdb00 	andeq	sp, pc, r0, lsl #22
    2894:	08010200 	stmdaeq	r1, {r9}
    2898:	000004a0 	andeq	r0, r0, r0, lsr #9
    289c:	80050202 	andhi	r0, r5, r2, lsl #4
    28a0:	03000002 	movweq	r0, #2
    28a4:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
    28a8:	0e040074 	mcreq	0, 0, r0, cr4, cr4, {3}
    28ac:	0200000a 	andeq	r0, r0, #10
    28b0:	00460709 	subeq	r0, r6, r9, lsl #14
    28b4:	01020000 	mrseq	r0, (UNDEF: 2)
    28b8:	00049708 	andeq	r9, r4, r8, lsl #14
    28bc:	07020200 	streq	r0, [r2, -r0, lsl #4]
    28c0:	00000502 	andeq	r0, r0, r2, lsl #10
    28c4:	00032904 	andeq	r2, r3, r4, lsl #18
    28c8:	070b0200 	streq	r0, [fp, -r0, lsl #4]
    28cc:	00000065 	andeq	r0, r0, r5, rrx
    28d0:	00005405 	andeq	r5, r0, r5, lsl #8
    28d4:	07040200 	streq	r0, [r4, -r0, lsl #4]
    28d8:	00001e62 	andeq	r1, r0, r2, ror #28
    28dc:	00006505 	andeq	r6, r0, r5, lsl #10
    28e0:	12f80600 	rscsne	r0, r8, #0, 12
    28e4:	03100000 	tsteq	r0, #0
    28e8:	00b30808 	adcseq	r0, r3, r8, lsl #16
    28ec:	30070000 	andcc	r0, r7, r0
    28f0:	03000010 	movweq	r0, #16
    28f4:	00b3200a 	adcseq	r2, r3, sl
    28f8:	07000000 	streq	r0, [r0, -r0]
    28fc:	00001077 	andeq	r1, r0, r7, ror r0
    2900:	b3200b03 			; <UNDEFINED> instruction: 0xb3200b03
    2904:	04000000 	streq	r0, [r0], #-0
    2908:	00113e07 	andseq	r3, r1, r7, lsl #28
    290c:	0e0c0300 	cdpeq	3, 0, cr0, cr12, cr0, {0}
    2910:	00000054 	andeq	r0, r0, r4, asr r0
    2914:	10c40708 	sbcne	r0, r4, r8, lsl #14
    2918:	0d030000 	stceq	0, cr0, [r3, #-0]
    291c:	0000b90a 	andeq	fp, r0, sl, lsl #18
    2920:	08000c00 	stmdaeq	r0, {sl, fp}
    2924:	00007104 	andeq	r7, r0, r4, lsl #2
    2928:	02010200 	andeq	r0, r1, #0, 4
    292c:	00000332 	andeq	r0, r0, r2, lsr r3
    2930:	0011d609 	andseq	sp, r1, r9, lsl #12
    2934:	10030400 	andne	r0, r3, r0, lsl #8
    2938:	00015807 	andeq	r5, r1, r7, lsl #16
    293c:	12bb0700 	adcsne	r0, fp, #0, 14
    2940:	13030000 	movwne	r0, #12288	; 0x3000
    2944:	0000b320 	andeq	fp, r0, r0, lsr #6
    2948:	300a0000 	andcc	r0, sl, r0
    294c:	03000013 	movweq	r0, #19
    2950:	11112015 	tstne	r1, r5, lsl r0
    2954:	00b30000 	adcseq	r0, r3, r0
    2958:	00f20000 	rscseq	r0, r2, r0
    295c:	00f80000 	rscseq	r0, r8, r0
    2960:	580b0000 	stmdapl	fp, {}	; <UNPREDICTABLE>
    2964:	00000001 	andeq	r0, r0, r1
    2968:	0011d60c 	andseq	sp, r1, ip, lsl #12
    296c:	05180300 	ldreq	r0, [r8, #-768]	; 0xfffffd00
    2970:	0000129d 	muleq	r0, sp, r2
    2974:	00000158 	andeq	r0, r0, r8, asr r1
    2978:	00011101 	andeq	r1, r1, r1, lsl #2
    297c:	00011700 	andeq	r1, r1, r0, lsl #14
    2980:	01580b00 	cmpeq	r8, r0, lsl #22
    2984:	0c000000 	stceq	0, cr0, [r0], {-0}
    2988:	000011f4 	strdeq	r1, [r0], -r4
    298c:	020b1a03 	andeq	r1, fp, #12288	; 0x3000
    2990:	63000012 	movwvs	r0, #18
    2994:	01000001 	tsteq	r0, r1
    2998:	00000130 	andeq	r0, r0, r0, lsr r1
    299c:	0000013b 	andeq	r0, r0, fp, lsr r1
    29a0:	0001580b 	andeq	r5, r1, fp, lsl #16
    29a4:	00540d00 	subseq	r0, r4, r0, lsl #26
    29a8:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    29ac:	00001143 	andeq	r1, r0, r3, asr #2
    29b0:	6a0a1b03 	bvs	2895c4 <_bss_end+0x27da54>
    29b4:	01000011 	tsteq	r0, r1, lsl r0
    29b8:	0000014c 	andeq	r0, r0, ip, asr #2
    29bc:	0001580b 	andeq	r5, r1, fp, lsl #16
    29c0:	01630d00 	cmneq	r3, r0, lsl #26
    29c4:	00000000 	andeq	r0, r0, r0
    29c8:	00c00408 	sbceq	r0, r0, r8, lsl #8
    29cc:	58050000 	stmdapl	r5, {}	; <UNPREDICTABLE>
    29d0:	0f000001 	svceq	0x00000001
    29d4:	14281004 	strtne	r1, [r8], #-4
    29d8:	24030000 	strcs	r0, [r3], #-0
    29dc:	0000c01d 	andeq	ip, r0, sp, lsl r0
    29e0:	61681100 	cmnvs	r8, r0, lsl #2
    29e4:	0704006c 	streq	r0, [r4, -ip, rrx]
    29e8:	0001eb0b 	andeq	lr, r1, fp, lsl #22
    29ec:	06801200 	streq	r1, [r0], r0, lsl #4
    29f0:	09040000 	stmdbeq	r4, {}	; <UNPREDICTABLE>
    29f4:	00006c1c 	andeq	r6, r0, ip, lsl ip
    29f8:	e6b28000 	ldrt	r8, [r2], r0
    29fc:	03e6120e 	mvneq	r1, #-536870912	; 0xe0000000
    2a00:	0c040000 	stceq	0, cr0, [r4], {-0}
    2a04:	0001f71d 	andeq	pc, r1, sp, lsl r7	; <UNPREDICTABLE>
    2a08:	00000000 	andeq	r0, r0, r0
    2a0c:	04c41220 	strbeq	r1, [r4], #544	; 0x220
    2a10:	0f040000 	svceq	0x00040000
    2a14:	0001f71d 	andeq	pc, r1, sp, lsl r7	; <UNPREDICTABLE>
    2a18:	20000000 	andcs	r0, r0, r0
    2a1c:	05301320 	ldreq	r1, [r0, #-800]!	; 0xfffffce0
    2a20:	12040000 	andne	r0, r4, #0
    2a24:	00006018 	andeq	r6, r0, r8, lsl r0
    2a28:	27123600 	ldrcs	r3, [r2, -r0, lsl #12]
    2a2c:	04000006 	streq	r0, [r0], #-6
    2a30:	01f71d44 	mvnseq	r1, r4, asr #26
    2a34:	50000000 	andpl	r0, r0, r0
    2a38:	66122021 	ldrvs	r2, [r2], -r1, lsr #32
    2a3c:	04000002 	streq	r0, [r0], #-2
    2a40:	01f71d73 	mvnseq	r1, r3, ror sp
    2a44:	b2000000 	andlt	r0, r0, #0
    2a48:	44122000 	ldrmi	r2, [r2], #-0
    2a4c:	04000005 	streq	r0, [r0], #-5
    2a50:	01f71da6 	mvnseq	r1, r6, lsr #27
    2a54:	b4000000 	strlt	r0, [r0], #-0
    2a58:	14002000 	strne	r2, [r0], #-0
    2a5c:	0000017d 	andeq	r0, r0, sp, ror r1
    2a60:	5d070402 	cfstrspl	mvf0, [r7, #-8]
    2a64:	0500001e 	streq	r0, [r0, #-30]	; 0xffffffe2
    2a68:	000001f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    2a6c:	00018d14 	andeq	r8, r1, r4, lsl sp
    2a70:	019d1400 	orrseq	r1, sp, r0, lsl #8
    2a74:	ad140000 	ldcge	0, cr0, [r4, #-0]
    2a78:	14000001 	strne	r0, [r0], #-1
    2a7c:	000001ba 			; <UNDEFINED> instruction: 0x000001ba
    2a80:	0001ca14 	andeq	ip, r1, r4, lsl sl
    2a84:	01da1400 	bicseq	r1, sl, r0, lsl #8
    2a88:	6d110000 	ldcvs	0, cr0, [r1, #-0]
    2a8c:	05006d65 	streq	r6, [r0, #-3429]	; 0xfffff29b
    2a90:	02730b06 	rsbseq	r0, r3, #6144	; 0x1800
    2a94:	8c120000 	ldchi	0, cr0, [r2], {-0}
    2a98:	05000011 	streq	r0, [r0, #-17]	; 0xffffffef
    2a9c:	0060180a 	rsbeq	r1, r0, sl, lsl #16
    2aa0:	00000000 	andeq	r0, r0, r0
    2aa4:	6c120002 	ldcvs	0, cr0, [r2], {2}
    2aa8:	05000010 	streq	r0, [r0, #-16]
    2aac:	0060180d 	rsbeq	r1, r0, sp, lsl #16
    2ab0:	00000000 	andeq	r0, r0, r0
    2ab4:	de152000 	cdple	0, 1, cr2, cr5, cr0, {0}
    2ab8:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
    2abc:	00601810 	rsbeq	r1, r0, r0, lsl r8
    2ac0:	40000000 	andmi	r0, r0, r0
    2ac4:	00127112 	andseq	r7, r2, r2, lsl r1
    2ac8:	18130500 	ldmdane	r3, {r8, sl}
    2acc:	00000060 	andeq	r0, r0, r0, rrx
    2ad0:	1ffe0000 	svcne	0x00fe0000
    2ad4:	00103515 	andseq	r3, r0, r5, lsl r5
    2ad8:	18160500 	ldmdane	r6, {r8, sl}
    2adc:	00000060 	andeq	r0, r0, r0, rrx
    2ae0:	14007ff8 	strne	r7, [r0], #-4088	; 0xfffff008
    2ae4:	00000226 	andeq	r0, r0, r6, lsr #4
    2ae8:	00023614 	andeq	r3, r2, r4, lsl r6
    2aec:	02461400 	subeq	r1, r6, #0, 8
    2af0:	54140000 	ldrpl	r0, [r4], #-0
    2af4:	14000002 	strne	r0, [r0], #-2
    2af8:	00000264 	andeq	r0, r0, r4, ror #4
    2afc:	00152716 	andseq	r2, r5, r6, lsl r7
    2b00:	060fff00 	streq	pc, [pc], -r0, lsl #30
    2b04:	03260709 			; <UNDEFINED> instruction: 0x03260709
    2b08:	0c070000 	stceq	0, cr0, [r7], {-0}
    2b0c:	06000014 			; <UNDEFINED> instruction: 0x06000014
    2b10:	03260d0c 			; <UNDEFINED> instruction: 0x03260d0c
    2b14:	17000000 	strne	r0, [r0, -r0]
    2b18:	00001407 	andeq	r1, r0, r7, lsl #8
    2b1c:	d60a0e06 	strle	r0, [sl], -r6, lsl #28
    2b20:	bb000014 	bllt	2b78 <CPSR_IRQ_INHIBIT+0x2af8>
    2b24:	cb000002 	blgt	2b34 <CPSR_IRQ_INHIBIT+0x2ab4>
    2b28:	0b000002 	bleq	2b38 <CPSR_IRQ_INHIBIT+0x2ab8>
    2b2c:	00000337 	andeq	r0, r0, r7, lsr r3
    2b30:	0000540d 	andeq	r5, r0, sp, lsl #8
    2b34:	00b90d00 	adcseq	r0, r9, r0, lsl #26
    2b38:	0c000000 	stceq	0, cr0, [r0], {-0}
    2b3c:	00001527 	andeq	r1, r0, r7, lsr #10
    2b40:	f1051106 			; <UNDEFINED> instruction: 0xf1051106
    2b44:	37000014 	smladcc	r0, r4, r0, r0
    2b48:	01000003 	tsteq	r0, r3
    2b4c:	000002e4 	andeq	r0, r0, r4, ror #5
    2b50:	000002ea 	andeq	r0, r0, sl, ror #5
    2b54:	0003370b 	andeq	r3, r3, fp, lsl #14
    2b58:	ec0c0000 	stc	0, cr0, [ip], {-0}
    2b5c:	06000013 			; <UNDEFINED> instruction: 0x06000013
    2b60:	14330e14 	ldrtne	r0, [r3], #-3604	; 0xfffff1ec
    2b64:	00540000 	subseq	r0, r4, r0
    2b68:	03010000 	movweq	r0, #4096	; 0x1000
    2b6c:	09000003 	stmdbeq	r0, {r0, r1}
    2b70:	0b000003 	bleq	2b84 <CPSR_IRQ_INHIBIT+0x2b04>
    2b74:	00000337 	andeq	r0, r0, r7, lsr r3
    2b78:	13f70e00 	mvnsne	r0, #0, 28
    2b7c:	16060000 	strne	r0, [r6], -r0
    2b80:	0015080a 	andseq	r0, r5, sl, lsl #16
    2b84:	031a0100 	tsteq	sl, #0, 2
    2b88:	370b0000 	strcc	r0, [fp, -r0]
    2b8c:	0d000003 	stceq	0, cr0, [r0, #-12]
    2b90:	00000054 	andeq	r0, r0, r4, asr r0
    2b94:	3a180000 	bcc	602b9c <_bss_end+0x5f702c>
    2b98:	37000000 	strcc	r0, [r0, -r0]
    2b9c:	19000003 	stmdbne	r0, {r0, r1}
    2ba0:	00000065 	andeq	r0, r0, r5, rrx
    2ba4:	08000ffe 	stmdaeq	r0, {r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, fp}
    2ba8:	00028c04 	andeq	r8, r2, r4, lsl #24
    2bac:	15ab1000 	strne	r1, [fp, #0]!
    2bb0:	19060000 	stmdbne	r6, {}	; <UNPREDICTABLE>
    2bb4:	00028c16 	andeq	r8, r2, r6, lsl ip
    2bb8:	01651a00 	cmneq	r5, r0, lsl #20
    2bbc:	04010000 	streq	r0, [r1], #-0
    2bc0:	50030516 	andpl	r0, r3, r6, lsl r5
    2bc4:	1b0000ab 	blne	2e78 <CPSR_IRQ_INHIBIT+0x2df8>
    2bc8:	00001419 	andeq	r1, r0, r9, lsl r4
    2bcc:	0000990c 	andeq	r9, r0, ip, lsl #18
    2bd0:	0000001c 	andeq	r0, r0, ip, lsl r0
    2bd4:	4f1c9c01 	svcmi	0x001c9c01
    2bd8:	c0000005 	andgt	r0, r0, r5
    2bdc:	4c000098 	stcmi	0, cr0, [r0], {152}	; 0x98
    2be0:	01000000 	mrseq	r0, (UNDEF: 0)
    2be4:	0003989c 	muleq	r3, ip, r8
    2be8:	04321d00 	ldrteq	r1, [r2], #-3328	; 0xfffff300
    2bec:	57010000 	strpl	r0, [r1, -r0]
    2bf0:	00003301 	andeq	r3, r0, r1, lsl #6
    2bf4:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    2bf8:	0005ed1d 	andeq	lr, r5, sp, lsl sp
    2bfc:	01570100 	cmpeq	r7, r0, lsl #2
    2c00:	00000033 	andeq	r0, r0, r3, lsr r0
    2c04:	00709102 	rsbseq	r9, r0, r2, lsl #2
    2c08:	00013b1e 	andeq	r3, r1, lr, lsl fp
    2c0c:	06420100 	strbeq	r0, [r2], -r0, lsl #2
    2c10:	000003b2 			; <UNDEFINED> instruction: 0x000003b2
    2c14:	000097a4 	andeq	r9, r0, r4, lsr #15
    2c18:	0000011c 	andeq	r0, r0, ip, lsl r1
    2c1c:	03dd9c01 	bicseq	r9, sp, #256	; 0x100
    2c20:	821f0000 	andshi	r0, pc, #0
    2c24:	5e000005 	cdppl	0, 0, cr0, cr0, cr5, {0}
    2c28:	02000001 	andeq	r0, r0, #1
    2c2c:	6d206c91 	stcvs	12, cr6, [r0, #-580]!	; 0xfffffdbc
    2c30:	01006d65 	tsteq	r0, r5, ror #26
    2c34:	01632742 	cmneq	r3, r2, asr #14
    2c38:	91020000 	mrsls	r0, (UNDEF: 2)
    2c3c:	14012168 	strne	r2, [r1], #-360	; 0xfffffe98
    2c40:	44010000 	strmi	r0, [r1], #-0
    2c44:	0000b320 	andeq	fp, r0, r0, lsr #6
    2c48:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    2c4c:	01171e00 	tsteq	r7, r0, lsl #28
    2c50:	17010000 	strne	r0, [r1, -r0]
    2c54:	0003f707 	andeq	pc, r3, r7, lsl #14
    2c58:	00965800 	addseq	r5, r6, r0, lsl #16
    2c5c:	00014c00 	andeq	r4, r1, r0, lsl #24
    2c60:	319c0100 	orrscc	r0, ip, r0, lsl #2
    2c64:	1f000004 	svcne	0x00000004
    2c68:	00000582 	andeq	r0, r0, r2, lsl #11
    2c6c:	0000015e 	andeq	r0, r0, lr, asr r1
    2c70:	1d6c9102 	stfnep	f1, [ip, #-8]!
    2c74:	0000113e 	andeq	r1, r0, lr, lsr r1
    2c78:	542c1701 	strtpl	r1, [ip], #-1793	; 0xfffff8ff
    2c7c:	02000000 	andeq	r0, r0, #0
    2c80:	01216891 			; <UNDEFINED> instruction: 0x01216891
    2c84:	01000014 	tsteq	r0, r4, lsl r0
    2c88:	00b32019 	adcseq	r2, r3, r9, lsl r0
    2c8c:	91020000 	mrsls	r0, (UNDEF: 2)
    2c90:	13e72174 	mvnne	r2, #116, 2
    2c94:	33010000 	movwcc	r0, #4096	; 0x1000
    2c98:	0000b320 	andeq	fp, r0, r0, lsr #6
    2c9c:	70910200 	addsvc	r0, r1, r0, lsl #4
    2ca0:	00da2200 	sbcseq	r2, sl, r0, lsl #4
    2ca4:	0c010000 	stceq	0, cr0, [r1], {-0}
    2ca8:	00044b1c 	andeq	r4, r4, ip, lsl fp
    2cac:	0095f000 	addseq	pc, r5, r0
    2cb0:	00006800 	andeq	r6, r0, r0, lsl #16
    2cb4:	679c0100 	ldrvs	r0, [ip, r0, lsl #2]
    2cb8:	1f000004 	svcne	0x00000004
    2cbc:	00000582 	andeq	r0, r0, r2, lsl #11
    2cc0:	0000015e 	andeq	r0, r0, lr, asr r1
    2cc4:	216c9102 	cmncs	ip, r2, lsl #2
    2cc8:	00001401 	andeq	r1, r0, r1, lsl #8
    2ccc:	b3200e01 			; <UNDEFINED> instruction: 0xb3200e01
    2cd0:	02000000 	andeq	r0, r0, #0
    2cd4:	23007491 	movwcs	r7, #1169	; 0x491
    2cd8:	000000f8 	strdeq	r0, [r0], -r8
    2cdc:	78010601 	stmdavc	r1, {r0, r9, sl}
    2ce0:	00000004 	andeq	r0, r0, r4
    2ce4:	00000482 	andeq	r0, r0, r2, lsl #9
    2ce8:	00058224 	andeq	r8, r5, r4, lsr #4
    2cec:	00015e00 	andeq	r5, r1, r0, lsl #28
    2cf0:	67250000 	strvs	r0, [r5, -r0]!
    2cf4:	54000004 	strpl	r0, [r0], #-4
    2cf8:	99000014 	stmdbls	r0, {r2, r4}
    2cfc:	bc000004 	stclt	0, cr0, [r0], {4}
    2d00:	34000095 	strcc	r0, [r0], #-149	; 0xffffff6b
    2d04:	01000000 	mrseq	r0, (UNDEF: 0)
    2d08:	0478269c 	ldrbteq	r2, [r8], #-1692	; 0xfffff964
    2d0c:	91020000 	mrsls	r0, (UNDEF: 2)
    2d10:	e0000074 	and	r0, r0, r4, ror r0
    2d14:	04000003 	streq	r0, [r0], #-3
    2d18:	00107b00 	andseq	r7, r0, r0, lsl #22
    2d1c:	00010400 	andeq	r0, r1, r0, lsl #8
    2d20:	04000000 	streq	r0, [r0], #-0
    2d24:	0000153e 	andeq	r1, r0, lr, lsr r5
    2d28:	000000b6 	strheq	r0, [r0], -r6
    2d2c:	00009928 	andeq	r9, r0, r8, lsr #18
    2d30:	000002a4 	andeq	r0, r0, r4, lsr #5
    2d34:	00001293 	muleq	r0, r3, r2
    2d38:	a0080102 	andge	r0, r8, r2, lsl #2
    2d3c:	02000004 	andeq	r0, r0, #4
    2d40:	02800502 	addeq	r0, r0, #8388608	; 0x800000
    2d44:	04030000 	streq	r0, [r3], #-0
    2d48:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
    2d4c:	0a0e0400 	beq	383d54 <_bss_end+0x3781e4>
    2d50:	09020000 	stmdbeq	r2, {}	; <UNPREDICTABLE>
    2d54:	00004607 	andeq	r4, r0, r7, lsl #12
    2d58:	08010200 	stmdaeq	r1, {r9}
    2d5c:	00000497 	muleq	r0, r7, r4
    2d60:	02070202 	andeq	r0, r7, #536870912	; 0x20000000
    2d64:	04000005 	streq	r0, [r0], #-5
    2d68:	00000329 	andeq	r0, r0, r9, lsr #6
    2d6c:	65070b02 	strvs	r0, [r7, #-2818]	; 0xfffff4fe
    2d70:	05000000 	streq	r0, [r0, #-0]
    2d74:	00000054 	andeq	r0, r0, r4, asr r0
    2d78:	62070402 	andvs	r0, r7, #33554432	; 0x2000000
    2d7c:	0500001e 	streq	r0, [r0, #-30]	; 0xffffffe2
    2d80:	00000065 	andeq	r0, r0, r5, rrx
    2d84:	6c616806 	stclvs	8, cr6, [r1], #-24	; 0xffffffe8
    2d88:	0b070300 	bleq	1c3990 <_bss_end+0x1b7e20>
    2d8c:	000000eb 	andeq	r0, r0, fp, ror #1
    2d90:	00068007 	andeq	r8, r6, r7
    2d94:	1c090300 	stcne	3, cr0, [r9], {-0}
    2d98:	0000006c 	andeq	r0, r0, ip, rrx
    2d9c:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}
    2da0:	0003e607 	andeq	lr, r3, r7, lsl #12
    2da4:	1d0c0300 	stcne	3, cr0, [ip, #-0]
    2da8:	000000f7 	strdeq	r0, [r0], -r7
    2dac:	20000000 	andcs	r0, r0, r0
    2db0:	0004c407 	andeq	ip, r4, r7, lsl #8
    2db4:	1d0f0300 	stcne	3, cr0, [pc, #-0]	; 2dbc <CPSR_IRQ_INHIBIT+0x2d3c>
    2db8:	000000f7 	strdeq	r0, [r0], -r7
    2dbc:	20200000 	eorcs	r0, r0, r0
    2dc0:	00053008 	andeq	r3, r5, r8
    2dc4:	18120300 	ldmdane	r2, {r8, r9}
    2dc8:	00000060 	andeq	r0, r0, r0, rrx
    2dcc:	06270736 			; <UNDEFINED> instruction: 0x06270736
    2dd0:	44030000 	strmi	r0, [r3], #-0
    2dd4:	0000f71d 	andeq	pc, r0, sp, lsl r7	; <UNPREDICTABLE>
    2dd8:	21500000 	cmpcs	r0, r0
    2ddc:	02660720 	rsbeq	r0, r6, #32, 14	; 0x800000
    2de0:	73030000 	movwvc	r0, #12288	; 0x3000
    2de4:	0000f71d 	andeq	pc, r0, sp, lsl r7	; <UNPREDICTABLE>
    2de8:	00b20000 	adcseq	r0, r2, r0
    2dec:	05440720 	strbeq	r0, [r4, #-1824]	; 0xfffff8e0
    2df0:	a6030000 	strge	r0, [r3], -r0
    2df4:	0000f71d 	andeq	pc, r0, sp, lsl r7	; <UNPREDICTABLE>
    2df8:	00b40000 	adcseq	r0, r4, r0
    2dfc:	7d090020 	stcvc	0, cr0, [r9, #-128]	; 0xffffff80
    2e00:	02000000 	andeq	r0, r0, #0
    2e04:	1e5d0704 	cdpne	7, 5, cr0, cr13, cr4, {0}
    2e08:	f0050000 			; <UNDEFINED> instruction: 0xf0050000
    2e0c:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
    2e10:	0000008d 	andeq	r0, r0, sp, lsl #1
    2e14:	00009d09 	andeq	r9, r0, r9, lsl #26
    2e18:	00ad0900 	adceq	r0, sp, r0, lsl #18
    2e1c:	ba090000 	blt	242e24 <_bss_end+0x2372b4>
    2e20:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
    2e24:	000000ca 	andeq	r0, r0, sl, asr #1
    2e28:	0000da09 	andeq	sp, r0, r9, lsl #20
    2e2c:	656d0600 	strbvs	r0, [sp, #-1536]!	; 0xfffffa00
    2e30:	0604006d 	streq	r0, [r4], -sp, rrx
    2e34:	0001730b 	andeq	r7, r1, fp, lsl #6
    2e38:	118c0700 	orrne	r0, ip, r0, lsl #14
    2e3c:	0a040000 	beq	102e44 <_bss_end+0xf72d4>
    2e40:	00006018 	andeq	r6, r0, r8, lsl r0
    2e44:	02000000 	andeq	r0, r0, #0
    2e48:	106c0700 	rsbne	r0, ip, r0, lsl #14
    2e4c:	0d040000 	stceq	0, cr0, [r4, #-0]
    2e50:	00006018 	andeq	r6, r0, r8, lsl r0
    2e54:	00000000 	andeq	r0, r0, r0
    2e58:	13de0a20 	bicsne	r0, lr, #32, 20	; 0x20000
    2e5c:	10040000 	andne	r0, r4, r0
    2e60:	00006018 	andeq	r6, r0, r8, lsl r0
    2e64:	07400000 	strbeq	r0, [r0, -r0]
    2e68:	00001271 	andeq	r1, r0, r1, ror r2
    2e6c:	60181304 	andsvs	r1, r8, r4, lsl #6
    2e70:	00000000 	andeq	r0, r0, r0
    2e74:	0a1ffe00 	beq	80267c <_bss_end+0x7f6b0c>
    2e78:	00001035 	andeq	r1, r0, r5, lsr r0
    2e7c:	60181604 	andsvs	r1, r8, r4, lsl #12
    2e80:	f8000000 			; <UNDEFINED> instruction: 0xf8000000
    2e84:	2609007f 			; <UNDEFINED> instruction: 0x2609007f
    2e88:	09000001 	stmdbeq	r0, {r0}
    2e8c:	00000136 	andeq	r0, r0, r6, lsr r1
    2e90:	00014609 	andeq	r4, r1, r9, lsl #12
    2e94:	01540900 	cmpeq	r4, r0, lsl #18
    2e98:	64090000 	strvs	r0, [r9], #-0
    2e9c:	0b000001 	bleq	2ea8 <CPSR_IRQ_INHIBIT+0x2e28>
    2ea0:	00001527 	andeq	r1, r0, r7, lsr #10
    2ea4:	09050fff 	stmdbeq	r5, {r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, fp}
    2ea8:	00022607 	andeq	r2, r2, r7, lsl #12
    2eac:	140c0c00 	strne	r0, [ip], #-3072	; 0xfffff400
    2eb0:	0c050000 	stceq	0, cr0, [r5], {-0}
    2eb4:	0002260d 	andeq	r2, r2, sp, lsl #12
    2eb8:	070d0000 	streq	r0, [sp, -r0]
    2ebc:	05000014 	streq	r0, [r0, #-20]	; 0xffffffec
    2ec0:	14d60a0e 	ldrbne	r0, [r6], #2574	; 0xa0e
    2ec4:	01bb0000 			; <UNDEFINED> instruction: 0x01bb0000
    2ec8:	01cb0000 	biceq	r0, fp, r0
    2ecc:	370e0000 	strcc	r0, [lr, -r0]
    2ed0:	0f000002 	svceq	0x00000002
    2ed4:	00000054 	andeq	r0, r0, r4, asr r0
    2ed8:	0002420f 	andeq	r4, r2, pc, lsl #4
    2edc:	27100000 	ldrcs	r0, [r0, -r0]
    2ee0:	05000015 	streq	r0, [r0, #-21]	; 0xffffffeb
    2ee4:	14f10511 	ldrbtne	r0, [r1], #1297	; 0x511
    2ee8:	02370000 	eorseq	r0, r7, #0
    2eec:	e4010000 	str	r0, [r1], #-0
    2ef0:	ea000001 	b	2efc <CPSR_IRQ_INHIBIT+0x2e7c>
    2ef4:	0e000001 	cdpeq	0, 0, cr0, cr0, cr1, {0}
    2ef8:	00000237 	andeq	r0, r0, r7, lsr r2
    2efc:	13ec1000 	mvnne	r1, #0
    2f00:	14050000 	strne	r0, [r5], #-0
    2f04:	0014330e 	andseq	r3, r4, lr, lsl #6
    2f08:	00005400 	andeq	r5, r0, r0, lsl #8
    2f0c:	02030100 	andeq	r0, r3, #0, 2
    2f10:	02090000 	andeq	r0, r9, #0
    2f14:	370e0000 	strcc	r0, [lr, -r0]
    2f18:	00000002 	andeq	r0, r0, r2
    2f1c:	0013f711 	andseq	pc, r3, r1, lsl r7	; <UNPREDICTABLE>
    2f20:	0a160500 	beq	584328 <_bss_end+0x5787b8>
    2f24:	00001508 	andeq	r1, r0, r8, lsl #10
    2f28:	00021a01 	andeq	r1, r2, r1, lsl #20
    2f2c:	02370e00 	eorseq	r0, r7, #0, 28
    2f30:	540f0000 	strpl	r0, [pc], #-0	; 2f38 <CPSR_IRQ_INHIBIT+0x2eb8>
    2f34:	00000000 	andeq	r0, r0, r0
    2f38:	003a1200 	eorseq	r1, sl, r0, lsl #4
    2f3c:	02370000 	eorseq	r0, r7, #0
    2f40:	65130000 	ldrvs	r0, [r3, #-0]
    2f44:	fe000000 	cdp2	0, 0, cr0, cr0, cr0, {0}
    2f48:	0414000f 	ldreq	r0, [r4], #-15
    2f4c:	0000018c 	andeq	r0, r0, ip, lsl #3
    2f50:	00023705 	andeq	r3, r2, r5, lsl #14
    2f54:	02010200 	andeq	r0, r1, #0, 4
    2f58:	00000332 	andeq	r0, r0, r2, lsr r3
    2f5c:	0015ab15 	andseq	sl, r5, r5, lsl fp
    2f60:	16190500 	ldrne	r0, [r9], -r0, lsl #10
    2f64:	0000018c 	andeq	r0, r0, ip, lsl #3
    2f68:	00024916 	andeq	r4, r2, r6, lsl r9
    2f6c:	0f030100 	svceq	0x00030100
    2f70:	ab540305 	blge	1503b8c <_bss_end+0x14f801c>
    2f74:	9c170000 	ldcls	0, cr0, [r7], {-0}
    2f78:	b0000015 	andlt	r0, r0, r5, lsl r0
    2f7c:	1c00009b 	stcne	0, cr0, [r0], {155}	; 0x9b
    2f80:	01000000 	mrseq	r0, (UNDEF: 0)
    2f84:	054f189c 	strbeq	r1, [pc, #-2204]	; 26f0 <CPSR_IRQ_INHIBIT+0x2670>
    2f88:	9b640000 	blls	1902f90 <_bss_end+0x18f7420>
    2f8c:	004c0000 	subeq	r0, ip, r0
    2f90:	9c010000 	stcls	0, cr0, [r1], {-0}
    2f94:	000002a4 	andeq	r0, r0, r4, lsr #5
    2f98:	00043219 	andeq	r3, r4, r9, lsl r2
    2f9c:	01390100 	teqeq	r9, r0, lsl #2
    2fa0:	00000033 	andeq	r0, r0, r3, lsr r0
    2fa4:	19749102 	ldmdbne	r4!, {r1, r8, ip, pc}^
    2fa8:	000005ed 	andeq	r0, r0, sp, ror #11
    2fac:	33013901 	movwcc	r3, #6401	; 0x1901
    2fb0:	02000000 	andeq	r0, r0, #0
    2fb4:	1a007091 	bne	1f200 <_bss_end+0x13690>
    2fb8:	00000209 	andeq	r0, r0, r9, lsl #4
    2fbc:	be063401 	cdplt	4, 0, cr3, cr6, cr1, {0}
    2fc0:	2c000002 	stccs	0, cr0, [r0], {2}
    2fc4:	3800009b 	stmdacc	r0, {r0, r1, r3, r4, r7}
    2fc8:	01000000 	mrseq	r0, (UNDEF: 0)
    2fcc:	0002d99c 	muleq	r2, ip, r9
    2fd0:	05821b00 	streq	r1, [r2, #2816]	; 0xb00
    2fd4:	023d0000 	eorseq	r0, sp, #0
    2fd8:	91020000 	mrsls	r0, (UNDEF: 2)
    2fdc:	61661c74 	smcvs	25028	; 0x61c4
    2fe0:	28340100 	ldmdacs	r4!, {r8}
    2fe4:	00000054 	andeq	r0, r0, r4, asr r0
    2fe8:	00709102 	rsbseq	r9, r0, r2, lsl #2
    2fec:	0001ea1a 	andeq	lr, r1, sl, lsl sl
    2ff0:	0a160100 	beq	5833f8 <_bss_end+0x577888>
    2ff4:	000002f3 	strdeq	r0, [r0], -r3
    2ff8:	00009a48 	andeq	r9, r0, r8, asr #20
    2ffc:	000000e4 	andeq	r0, r0, r4, ror #1
    3000:	03339c01 	teqeq	r3, #256	; 0x100
    3004:	821b0000 	andshi	r0, fp, #0
    3008:	3d000005 	stccc	0, cr0, [r0, #-20]	; 0xffffffec
    300c:	02000002 	andeq	r0, r0, #2
    3010:	691d6491 	ldmdbvs	sp, {r0, r4, r7, sl, sp, lr}
    3014:	0e1b0100 	mufeqe	f0, f3, f0
    3018:	00000054 	andeq	r0, r0, r4, asr r0
    301c:	1d749102 	ldfnep	f1, [r4, #-8]!
    3020:	1b01006a 	blne	431d0 <_bss_end+0x37660>
    3024:	00005411 	andeq	r5, r0, r1, lsl r4
    3028:	70910200 	addsvc	r0, r1, r0, lsl #4
    302c:	009ac41e 	addseq	ip, sl, lr, lsl r4
    3030:	00003400 	andeq	r3, r0, r0, lsl #8
    3034:	15351f00 	ldrne	r1, [r5, #-3840]!	; 0xfffff100
    3038:	29010000 	stmdbcs	r1, {}	; <UNPREDICTABLE>
    303c:	00006024 	andeq	r6, r0, r4, lsr #32
    3040:	6c910200 	lfmvs	f0, 4, [r1], {0}
    3044:	a7200000 	strge	r0, [r0, -r0]!
    3048:	01000001 	tsteq	r0, r1
    304c:	00034c06 	andeq	r4, r3, r6, lsl #24
    3050:	00998c00 	addseq	r8, r9, r0, lsl #24
    3054:	0000bc00 	andeq	fp, r0, r0, lsl #24
    3058:	779c0100 	ldrvc	r0, [ip, r0, lsl #2]
    305c:	1b000003 	blne	3070 <CPSR_IRQ_INHIBIT+0x2ff0>
    3060:	00000582 	andeq	r0, r0, r2, lsl #11
    3064:	0000023d 	andeq	r0, r0, sp, lsr r2
    3068:	19749102 	ldmdbne	r4!, {r1, r8, ip, pc}^
    306c:	00001535 	andeq	r1, r0, r5, lsr r5
    3070:	54230e01 	strtpl	r0, [r3], #-3585	; 0xfffff1ff
    3074:	02000000 	andeq	r0, r0, #0
    3078:	b9197091 	ldmdblt	r9, {r0, r4, r7, ip, sp, lr}
    307c:	01000015 	tsteq	r0, r5, lsl r0
    3080:	0242320e 	subeq	r3, r2, #-536870912	; 0xe0000000
    3084:	91020000 	mrsls	r0, (UNDEF: 2)
    3088:	cb21006f 	blgt	84324c <_bss_end+0x8376dc>
    308c:	01000001 	tsteq	r0, r1
    3090:	03880105 	orreq	r0, r8, #1073741825	; 0x40000001
    3094:	9e000000 	cdpls	0, 0, cr0, cr0, cr0, {0}
    3098:	22000003 	andcs	r0, r0, #3
    309c:	00000582 	andeq	r0, r0, r2, lsl #11
    30a0:	0000023d 	andeq	r0, r0, sp, lsr r2
    30a4:	00692423 	rsbeq	r2, r9, r3, lsr #8
    30a8:	330e0801 	movwcc	r0, #59393	; 0xe801
    30ac:	00000000 	andeq	r0, r0, r0
    30b0:	03772500 	cmneq	r7, #0, 10
    30b4:	15be0000 	ldrne	r0, [lr, #0]!
    30b8:	03b50000 			; <UNDEFINED> instruction: 0x03b50000
    30bc:	99280000 	stmdbls	r8!, {}	; <UNPREDICTABLE>
    30c0:	00640000 	rsbeq	r0, r4, r0
    30c4:	9c010000 	stcls	0, cr0, [r1], {-0}
    30c8:	00038826 	andeq	r8, r3, r6, lsr #16
    30cc:	6c910200 	lfmvs	f0, 4, [r1], {0}
    30d0:	00039127 	andeq	r9, r3, r7, lsr #2
    30d4:	0003cc00 	andeq	ip, r3, r0, lsl #24
    30d8:	03922800 	orrseq	r2, r2, #0, 16
    30dc:	29000000 	stmdbcs	r0, {}	; <UNPREDICTABLE>
    30e0:	00000391 	muleq	r0, r1, r3
    30e4:	00009938 	andeq	r9, r0, r8, lsr r9
    30e8:	0000003c 	andeq	r0, r0, ip, lsr r0
    30ec:	0003922a 	andeq	r9, r3, sl, lsr #4
    30f0:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    30f4:	3d000000 	stccc	0, cr0, [r0, #-0]
    30f8:	0400000a 	streq	r0, [r0], #-10
    30fc:	0012ed00 	andseq	lr, r2, r0, lsl #26
    3100:	00010400 	andeq	r0, r1, r0, lsl #8
    3104:	04000000 	streq	r0, [r0], #-0
    3108:	00001692 	muleq	r0, r2, r6
    310c:	000000b6 	strheq	r0, [r0], -r6
    3110:	00000028 	andeq	r0, r0, r8, lsr #32
    3114:	00000000 	andeq	r0, r0, r0
    3118:	000014bf 			; <UNDEFINED> instruction: 0x000014bf
    311c:	a0080102 	andge	r0, r8, r2, lsl #2
    3120:	03000004 	movweq	r0, #4
    3124:	00000025 	andeq	r0, r0, r5, lsr #32
    3128:	80050202 	andhi	r0, r5, r2, lsl #4
    312c:	04000002 	streq	r0, [r0], #-2
    3130:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
    3134:	0e050074 	mcreq	0, 0, r0, cr5, cr4, {3}
    3138:	0300000a 	movweq	r0, #10
    313c:	004b0709 	subeq	r0, fp, r9, lsl #14
    3140:	01020000 	mrseq	r0, (UNDEF: 2)
    3144:	00049708 	andeq	r9, r4, r8, lsl #14
    3148:	004b0600 	subeq	r0, fp, r0, lsl #12
    314c:	02020000 	andeq	r0, r2, #0
    3150:	00050207 	andeq	r0, r5, r7, lsl #4
    3154:	03290500 			; <UNDEFINED> instruction: 0x03290500
    3158:	0b030000 	bleq	c3160 <_bss_end+0xb75f0>
    315c:	00006f07 	andeq	r6, r0, r7, lsl #30
    3160:	005e0300 	subseq	r0, lr, r0, lsl #6
    3164:	04020000 	streq	r0, [r2], #-0
    3168:	001e6207 	andseq	r6, lr, r7, lsl #4
    316c:	006f0300 	rsbeq	r0, pc, r0, lsl #6
    3170:	48070000 	stmdami	r7, {}	; <UNPREDICTABLE>
    3174:	05000011 	streq	r0, [r0, #-17]	; 0xffffffef
    3178:	00003804 	andeq	r3, r0, r4, lsl #16
    317c:	0c040400 	cfstrseq	mvf0, [r4], {-0}
    3180:	000000a6 	andeq	r0, r0, r6, lsr #1
    3184:	77654e08 	strbvc	r4, [r5, -r8, lsl #28]!
    3188:	eb090000 	bl	243190 <_bss_end+0x237620>
    318c:	01000011 	tsteq	r0, r1, lsl r0
    3190:	000bbb09 	andeq	fp, fp, r9, lsl #22
    3194:	a0090200 	andge	r0, r9, r0, lsl #4
    3198:	03000011 	movweq	r0, #17
    319c:	10cc0a00 	sbcne	r0, ip, r0, lsl #20
    31a0:	040c0000 	streq	r0, [ip], #-0
    31a4:	00d80811 	sbcseq	r0, r8, r1, lsl r8
    31a8:	6c0b0000 	stcvs	0, cr0, [fp], {-0}
    31ac:	13040072 	movwne	r0, #16498	; 0x4072
    31b0:	0000d813 	andeq	sp, r0, r3, lsl r8
    31b4:	730b0000 	movwvc	r0, #45056	; 0xb000
    31b8:	14040070 	strne	r0, [r4], #-112	; 0xffffff90
    31bc:	0000d813 	andeq	sp, r0, r3, lsl r8
    31c0:	700b0400 	andvc	r0, fp, r0, lsl #8
    31c4:	15040063 	strne	r0, [r4, #-99]	; 0xffffff9d
    31c8:	0000d813 	andeq	sp, r0, r3, lsl r8
    31cc:	02000800 	andeq	r0, r0, #0, 16
    31d0:	1e5d0704 	cdpne	7, 5, cr0, cr13, cr4, {0}
    31d4:	d8030000 	stmdale	r3, {}	; <UNPREDICTABLE>
    31d8:	0a000000 	beq	31e0 <CPSR_IRQ_INHIBIT+0x3160>
    31dc:	00001287 	andeq	r1, r0, r7, lsl #5
    31e0:	081b041c 	ldmdaeq	fp, {r2, r3, r4, sl}
    31e4:	00000133 	andeq	r0, r0, r3, lsr r1
    31e8:	0012650c 	andseq	r6, r2, ip, lsl #10
    31ec:	121d0400 	andsne	r0, sp, #0, 8
    31f0:	000000a6 	andeq	r0, r0, r6, lsr #1
    31f4:	69700b00 	ldmdbvs	r0!, {r8, r9, fp}^
    31f8:	1e040064 	cdpne	0, 0, cr0, cr4, cr4, {3}
    31fc:	00006f12 	andeq	r6, r0, r2, lsl pc
    3200:	ae0c0c00 	cdpge	12, 0, cr0, cr12, cr0, {0}
    3204:	0400001b 	streq	r0, [r0], #-27	; 0xffffffe5
    3208:	007b111f 	rsbseq	r1, fp, pc, lsl r1
    320c:	0c100000 	ldceq	0, cr0, [r0], {-0}
    3210:	000011c8 	andeq	r1, r0, r8, asr #3
    3214:	6f122004 	svcvs	0x00122004
    3218:	14000000 	strne	r0, [r0], #-0
    321c:	0011540c 	andseq	r5, r1, ip, lsl #8
    3220:	12210400 	eorne	r0, r1, #0, 8
    3224:	0000006f 	andeq	r0, r0, pc, rrx
    3228:	e50a0018 	str	r0, [sl, #-24]	; 0xffffffe8
    322c:	0c000012 	stceq	0, cr0, [r0], {18}
    3230:	68080705 	stmdavs	r8, {r0, r2, r8, r9, sl}
    3234:	0c000001 	stceq	0, cr0, [r0], {1}
    3238:	00001030 	andeq	r1, r0, r0, lsr r0
    323c:	68190905 	ldmdavs	r9, {r0, r2, r8, fp}
    3240:	00000001 	andeq	r0, r0, r1
    3244:	0010770c 	andseq	r7, r0, ip, lsl #14
    3248:	190a0500 	stmdbne	sl, {r8, sl}
    324c:	00000168 	andeq	r0, r0, r8, ror #2
    3250:	12820c04 	addne	r0, r2, #4, 24	; 0x400
    3254:	0b050000 	bleq	14325c <_bss_end+0x1376ec>
    3258:	00016e13 	andeq	r6, r1, r3, lsl lr
    325c:	0d000800 	stceq	8, cr0, [r0, #-0]
    3260:	00013304 	andeq	r3, r1, r4, lsl #6
    3264:	e4040d00 	str	r0, [r4], #-3328	; 0xfffff300
    3268:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    326c:	000010b3 	strheq	r1, [r0], -r3
    3270:	070e050c 	streq	r0, [lr, -ip, lsl #10]
    3274:	0000025c 	andeq	r0, r0, ip, asr r2
    3278:	0011960c 	andseq	r9, r1, ip, lsl #12
    327c:	0e120500 	cfmul32eq	mvfx0, mvfx2, mvfx0
    3280:	0000005e 	andeq	r0, r0, lr, asr r0
    3284:	136b0c00 	cmnne	fp, #0, 24
    3288:	15050000 	strne	r0, [r5, #-0]
    328c:	00016819 	andeq	r6, r1, r9, lsl r8
    3290:	520c0400 	andpl	r0, ip, #0, 8
    3294:	05000012 	streq	r0, [r0, #-18]	; 0xffffffee
    3298:	01681918 	cmneq	r8, r8, lsl r9
    329c:	0f080000 	svceq	0x00080000
    32a0:	00001326 	andeq	r1, r0, r6, lsr #6
    32a4:	c20a1b05 	andgt	r1, sl, #5120	; 0x1400
    32a8:	bc000012 	stclt	0, cr0, [r0], {18}
    32ac:	c7000001 	strgt	r0, [r0, -r1]
    32b0:	10000001 	andne	r0, r0, r1
    32b4:	00000261 	andeq	r0, r0, r1, ror #4
    32b8:	00016811 	andeq	r6, r1, r1, lsl r8
    32bc:	b3120000 	tstlt	r2, #0
    32c0:	05000010 	streq	r0, [r0, #-16]
    32c4:	10e3051e 	rscne	r0, r3, lr, lsl r5
    32c8:	02610000 	rsbeq	r0, r1, #0
    32cc:	e0010000 	and	r0, r1, r0
    32d0:	e6000001 	str	r0, [r0], -r1
    32d4:	10000001 	andne	r0, r0, r1
    32d8:	00000261 	andeq	r0, r0, r1, ror #4
    32dc:	13121300 	tstne	r2, #0, 6
    32e0:	21050000 	mrscs	r0, (UNDEF: 5)
    32e4:	00103f0a 	andseq	r3, r0, sl, lsl #30
    32e8:	01fb0100 	mvnseq	r0, r0, lsl #2
    32ec:	02010000 	andeq	r0, r1, #0
    32f0:	61100000 	tstvs	r0, r0
    32f4:	00000002 	andeq	r0, r0, r2
    32f8:	0010a412 	andseq	sl, r0, r2, lsl r4
    32fc:	0e240500 	cfsh64eq	mvdx0, mvdx4, #0
    3300:	0000107c 	andeq	r1, r0, ip, ror r0
    3304:	0000005e 	andeq	r0, r0, lr, asr r0
    3308:	00021a01 	andeq	r1, r2, r1, lsl #20
    330c:	00022500 	andeq	r2, r2, r0, lsl #10
    3310:	02611000 	rsbeq	r1, r1, #0
    3314:	d8110000 	ldmdale	r1, {}	; <UNPREDICTABLE>
    3318:	00000000 	andeq	r0, r0, r0
    331c:	00129413 	andseq	r9, r2, r3, lsl r4
    3320:	0a270500 	beq	9c4728 <_bss_end+0x9b8bb8>
    3324:	000011a7 	andeq	r1, r0, r7, lsr #3
    3328:	00023a01 	andeq	r3, r2, r1, lsl #20
    332c:	00024000 	andeq	r4, r2, r0
    3330:	02611000 	rsbeq	r1, r1, #0
    3334:	14000000 	strne	r0, [r0], #-0
    3338:	000010fd 	strdeq	r1, [r0], -sp
    333c:	24132a05 	ldrcs	r2, [r3], #-2565	; 0xfffff5fb
    3340:	6e000012 	mcrvs	0, 0, r0, cr0, cr2, {0}
    3344:	01000001 	tsteq	r0, r1
    3348:	00000255 	andeq	r0, r0, r5, asr r2
    334c:	00026c10 	andeq	r6, r2, r0, lsl ip
    3350:	03000000 	movweq	r0, #0
    3354:	00000174 	andeq	r0, r0, r4, ror r1
    3358:	0174040d 	cmneq	r4, sp, lsl #8
    335c:	61030000 	mrsvs	r0, (UNDEF: 3)
    3360:	0d000002 	stceq	0, cr0, [r0, #-8]
    3364:	00025c04 	andeq	r5, r2, r4, lsl #24
    3368:	026c0300 	rsbeq	r0, ip, #0, 6
    336c:	63150000 	tstvs	r5, #0
    3370:	05000016 	streq	r0, [r0, #-22]	; 0xffffffea
    3374:	0174192d 	cmneq	r4, sp, lsr #18
    3378:	ce0e0000 	cdpgt	0, 0, cr0, cr14, cr0, {0}
    337c:	18000007 	stmdane	r0, {r0, r1, r2}
    3380:	c4070306 	strgt	r0, [r7], #-774	; 0xfffffcfa
    3384:	16000004 	strne	r0, [r0], -r4
    3388:	0000072a 	andeq	r0, r0, sl, lsr #14
    338c:	006f0407 	rsbeq	r0, pc, r7, lsl #8
    3390:	06060000 	streq	r0, [r6], -r0
    3394:	02b00110 	adcseq	r0, r0, #16, 2
    3398:	48080000 	stmdami	r8, {}	; <UNPREDICTABLE>
    339c:	10005845 	andne	r5, r0, r5, asr #16
    33a0:	43454408 	movtmi	r4, #21512	; 0x5408
    33a4:	03000a00 	movweq	r0, #2560	; 0xa00
    33a8:	00000290 	muleq	r0, r0, r2
    33ac:	0007370a 	andeq	r3, r7, sl, lsl #14
    33b0:	24060800 	strcs	r0, [r6], #-2048	; 0xfffff800
    33b4:	0002d90c 	andeq	sp, r2, ip, lsl #18
    33b8:	00790b00 	rsbseq	r0, r9, r0, lsl #22
    33bc:	6f162606 	svcvs	0x00162606
    33c0:	00000000 	andeq	r0, r0, r0
    33c4:	0600780b 	streq	r7, [r0], -fp, lsl #16
    33c8:	006f1627 	rsbeq	r1, pc, r7, lsr #12
    33cc:	00040000 	andeq	r0, r4, r0
    33d0:	0008ab17 	andeq	sl, r8, r7, lsl fp
    33d4:	1b0c0600 	blne	304bdc <_bss_end+0x2f906c>
    33d8:	000002b0 			; <UNDEFINED> instruction: 0x000002b0
    33dc:	1e180a01 	vnmlsne.f32	s0, s16, s2
    33e0:	06000008 	streq	r0, [r0], -r8
    33e4:	04ca280d 	strbeq	r2, [sl], #2061	; 0x80d
    33e8:	19010000 	stmdbne	r1, {}	; <UNPREDICTABLE>
    33ec:	000007ce 	andeq	r0, r0, lr, asr #15
    33f0:	980e1006 	stmdals	lr, {r1, r2, ip}
    33f4:	cf000008 	svcgt	0x00000008
    33f8:	01000004 	tsteq	r0, r4
    33fc:	0000030d 	andeq	r0, r0, sp, lsl #6
    3400:	00000322 	andeq	r0, r0, r2, lsr #6
    3404:	0004cf10 	andeq	ip, r4, r0, lsl pc
    3408:	006f1100 	rsbeq	r1, pc, r0, lsl #2
    340c:	6f110000 	svcvs	0x00110000
    3410:	11000000 	mrsne	r0, (UNDEF: 0)
    3414:	0000006f 	andeq	r0, r0, pc, rrx
    3418:	0ac31300 	beq	ff0c8020 <_bss_end+0xff0bc4b0>
    341c:	12060000 	andne	r0, r6, #0
    3420:	0007970a 	andeq	r9, r7, sl, lsl #14
    3424:	03370100 	teqeq	r7, #0, 2
    3428:	033d0000 	teqeq	sp, #0
    342c:	cf100000 	svcgt	0x00100000
    3430:	00000004 	andeq	r0, r0, r4
    3434:	0007d712 	andeq	sp, r7, r2, lsl r7
    3438:	0f140600 	svceq	0x00140600
    343c:	0000083b 	andeq	r0, r0, fp, lsr r8
    3440:	000004d5 	ldrdeq	r0, [r0], -r5
    3444:	00035601 	andeq	r5, r3, r1, lsl #12
    3448:	00036100 	andeq	r6, r3, r0, lsl #2
    344c:	04cf1000 	strbeq	r1, [pc], #0	; 3454 <CPSR_IRQ_INHIBIT+0x33d4>
    3450:	25110000 	ldrcs	r0, [r1, #-0]
    3454:	00000000 	andeq	r0, r0, r0
    3458:	0007d712 	andeq	sp, r7, r2, lsl r7
    345c:	0f150600 	svceq	0x00150600
    3460:	000007e2 	andeq	r0, r0, r2, ror #15
    3464:	000004d5 	ldrdeq	r0, [r0], -r5
    3468:	00037a01 	andeq	r7, r3, r1, lsl #20
    346c:	00038500 	andeq	r8, r3, r0, lsl #10
    3470:	04cf1000 	strbeq	r1, [pc], #0	; 3478 <CPSR_IRQ_INHIBIT+0x33f8>
    3474:	c4110000 	ldrgt	r0, [r1], #-0
    3478:	00000004 	andeq	r0, r0, r4
    347c:	0007d712 	andeq	sp, r7, r2, lsl r7
    3480:	0f160600 	svceq	0x00160600
    3484:	000007ac 	andeq	r0, r0, ip, lsr #15
    3488:	000004d5 	ldrdeq	r0, [r0], -r5
    348c:	00039e01 	andeq	r9, r3, r1, lsl #28
    3490:	0003a900 	andeq	sl, r3, r0, lsl #18
    3494:	04cf1000 	strbeq	r1, [pc], #0	; 349c <CPSR_IRQ_INHIBIT+0x341c>
    3498:	90110000 	andsls	r0, r1, r0
    349c:	00000002 	andeq	r0, r0, r2
    34a0:	0007d712 	andeq	sp, r7, r2, lsl r7
    34a4:	0f170600 	svceq	0x00170600
    34a8:	0000086a 	andeq	r0, r0, sl, ror #16
    34ac:	000004d5 	ldrdeq	r0, [r0], -r5
    34b0:	0003c201 	andeq	ip, r3, r1, lsl #4
    34b4:	0003cd00 	andeq	ip, r3, r0, lsl #26
    34b8:	04cf1000 	strbeq	r1, [pc], #0	; 34c0 <CPSR_IRQ_INHIBIT+0x3440>
    34bc:	6f110000 	svcvs	0x00110000
    34c0:	00000000 	andeq	r0, r0, r0
    34c4:	0007d712 	andeq	sp, r7, r2, lsl r7
    34c8:	0f180600 	svceq	0x00180600
    34cc:	0000082a 	andeq	r0, r0, sl, lsr #16
    34d0:	000004d5 	ldrdeq	r0, [r0], -r5
    34d4:	0003e601 	andeq	lr, r3, r1, lsl #12
    34d8:	0003f100 	andeq	pc, r3, r0, lsl #2
    34dc:	04cf1000 	strbeq	r1, [pc], #0	; 34e4 <CPSR_IRQ_INHIBIT+0x3464>
    34e0:	db110000 	blle	4434e8 <_bss_end+0x437978>
    34e4:	00000004 	andeq	r0, r0, r4
    34e8:	00071c0f 	andeq	r1, r7, pc, lsl #24
    34ec:	111b0600 	tstne	fp, r0, lsl #12
    34f0:	000006ec 	andeq	r0, r0, ip, ror #13
    34f4:	00000405 	andeq	r0, r0, r5, lsl #8
    34f8:	0000040b 	andeq	r0, r0, fp, lsl #8
    34fc:	0004cf10 	andeq	ip, r4, r0, lsl pc
    3500:	0f0f0000 	svceq	0x000f0000
    3504:	06000007 	streq	r0, [r0], -r7
    3508:	087b111c 	ldmdaeq	fp!, {r2, r3, r4, r8, ip}^
    350c:	041f0000 	ldreq	r0, [pc], #-0	; 3514 <CPSR_IRQ_INHIBIT+0x3494>
    3510:	04250000 	strteq	r0, [r5], #-0
    3514:	cf100000 	svcgt	0x00100000
    3518:	00000004 	andeq	r0, r0, r4
    351c:	0006c70f 	andeq	ip, r6, pc, lsl #14
    3520:	111d0600 	tstne	sp, r0, lsl #12
    3524:	00000741 	andeq	r0, r0, r1, asr #14
    3528:	00000439 	andeq	r0, r0, r9, lsr r4
    352c:	0000043f 	andeq	r0, r0, pc, lsr r4
    3530:	0004cf10 	andeq	ip, r4, r0, lsl pc
    3534:	ac0f0000 	stcge	0, cr0, [pc], {-0}
    3538:	06000006 	streq	r0, [r0], -r6
    353c:	08540a1f 	ldmdaeq	r4, {r0, r1, r2, r3, r4, r9, fp}^
    3540:	04530000 	ldrbeq	r0, [r3], #-0
    3544:	04590000 	ldrbeq	r0, [r9], #-0
    3548:	cf100000 	svcgt	0x00100000
    354c:	00000004 	andeq	r0, r0, r4
    3550:	00070a0f 	andeq	r0, r7, pc, lsl #20
    3554:	0a210600 	beq	844d5c <_bss_end+0x8391ec>
    3558:	000007f5 	strdeq	r0, [r0], -r5
    355c:	0000046d 	andeq	r0, r0, sp, ror #8
    3560:	00000482 	andeq	r0, r0, r2, lsl #9
    3564:	0004cf10 	andeq	ip, r4, r0, lsl pc
    3568:	006f1100 	rsbeq	r1, pc, r0, lsl #2
    356c:	e2110000 	ands	r0, r1, #0
    3570:	11000004 	tstne	r0, r4
    3574:	0000006f 	andeq	r0, r0, pc, rrx
    3578:	07630c00 	strbeq	r0, [r3, -r0, lsl #24]!
    357c:	2b060000 	blcs	183584 <_bss_end+0x177a14>
    3580:	0004ee23 	andeq	lr, r4, r3, lsr #28
    3584:	4c0c0000 	stcmi	0, cr0, [ip], {-0}
    3588:	06000008 	streq	r0, [r0], -r8
    358c:	006f122c 	rsbeq	r1, pc, ip, lsr #4
    3590:	0c040000 	stceq	0, cr0, [r4], {-0}
    3594:	0000080c 	andeq	r0, r0, ip, lsl #16
    3598:	6f122d06 	svcvs	0x00122d06
    359c:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    35a0:	0008150c 	andeq	r1, r8, ip, lsl #10
    35a4:	0f2e0600 	svceq	0x002e0600
    35a8:	000002b5 			; <UNDEFINED> instruction: 0x000002b5
    35ac:	06b90c0c 	ldrteq	r0, [r9], ip, lsl #24
    35b0:	2f060000 	svccs	0x00060000
    35b4:	00029012 	andeq	r9, r2, r2, lsl r0
    35b8:	0d001400 	cfstrseq	mvf1, [r0, #-0]
    35bc:	00002c04 	andeq	r2, r0, r4, lsl #24
    35c0:	04c40300 	strbeq	r0, [r4], #768	; 0x300
    35c4:	040d0000 	streq	r0, [sp], #-0
    35c8:	00000283 	andeq	r0, r0, r3, lsl #5
    35cc:	0283041a 	addeq	r0, r3, #436207616	; 0x1a000000
    35d0:	01020000 	mrseq	r0, (UNDEF: 2)
    35d4:	00033202 	andeq	r3, r3, r2, lsl #4
    35d8:	25040d00 	strcs	r0, [r4, #-3328]	; 0xfffff300
    35dc:	0d000000 	stceq	0, cr0, [r0, #-0]
    35e0:	00005204 	andeq	r5, r0, r4, lsl #4
    35e4:	04e80300 	strbteq	r0, [r8], #768	; 0x300
    35e8:	7c150000 	ldcvc	0, cr0, [r5], {-0}
    35ec:	06000007 	streq	r0, [r0], -r7
    35f0:	02831132 	addeq	r1, r3, #-2147483636	; 0x8000000c
    35f4:	f80a0000 			; <UNDEFINED> instruction: 0xf80a0000
    35f8:	10000012 	andne	r0, r0, r2, lsl r0
    35fc:	41080802 	tstmi	r8, r2, lsl #16
    3600:	0c000005 	stceq	0, cr0, [r0], {5}
    3604:	00001030 	andeq	r1, r0, r0, lsr r0
    3608:	41200a02 			; <UNDEFINED> instruction: 0x41200a02
    360c:	00000005 	andeq	r0, r0, r5
    3610:	0010770c 	andseq	r7, r0, ip, lsl #14
    3614:	200b0200 	andcs	r0, fp, r0, lsl #4
    3618:	00000541 	andeq	r0, r0, r1, asr #10
    361c:	113e0c04 	teqne	lr, r4, lsl #24
    3620:	0c020000 	stceq	0, cr0, [r2], {-0}
    3624:	00005e0e 	andeq	r5, r0, lr, lsl #28
    3628:	c40c0800 	strgt	r0, [ip], #-2048	; 0xfffff800
    362c:	02000010 	andeq	r0, r0, #16
    3630:	04db0a0d 	ldrbeq	r0, [fp], #2573	; 0xa0d
    3634:	000c0000 	andeq	r0, ip, r0
    3638:	04ff040d 	ldrbteq	r0, [pc], #1037	; 3640 <CPSR_IRQ_INHIBIT+0x35c0>
    363c:	d60e0000 	strle	r0, [lr], -r0
    3640:	04000011 	streq	r0, [r0], #-17	; 0xffffffef
    3644:	2b071002 	blcs	1c7654 <_bss_end+0x1bbae4>
    3648:	0c000006 	stceq	0, cr0, [r0], {6}
    364c:	000012bb 			; <UNDEFINED> instruction: 0x000012bb
    3650:	41201302 			; <UNDEFINED> instruction: 0x41201302
    3654:	00000005 	andeq	r0, r0, r5
    3658:	0013301b 	andseq	r3, r3, fp, lsl r0
    365c:	20150200 	andscs	r0, r5, r0, lsl #4
    3660:	00001111 	andeq	r1, r0, r1, lsl r1
    3664:	00000541 	andeq	r0, r0, r1, asr #10
    3668:	00000579 	andeq	r0, r0, r9, ror r5
    366c:	0000057f 	andeq	r0, r0, pc, ror r5
    3670:	00062b10 	andeq	r2, r6, r0, lsl fp
    3674:	d6120000 	ldrle	r0, [r2], -r0
    3678:	02000011 	andeq	r0, r0, #17
    367c:	129d0518 	addsne	r0, sp, #24, 10	; 0x6000000
    3680:	062b0000 	strteq	r0, [fp], -r0
    3684:	98010000 	stmdals	r1, {}	; <UNPREDICTABLE>
    3688:	9e000005 	cdpls	0, 0, cr0, cr0, cr5, {0}
    368c:	10000005 	andne	r0, r0, r5
    3690:	0000062b 	andeq	r0, r0, fp, lsr #12
    3694:	11f41200 	mvnsne	r1, r0, lsl #4
    3698:	1a020000 	bne	836a0 <_bss_end+0x77b30>
    369c:	0012020b 	andseq	r0, r2, fp, lsl #4
    36a0:	00063600 	andeq	r3, r6, r0, lsl #12
    36a4:	05b70100 	ldreq	r0, [r7, #256]!	; 0x100
    36a8:	05c20000 	strbeq	r0, [r2]
    36ac:	2b100000 	blcs	4036b4 <_bss_end+0x3f7b44>
    36b0:	11000006 	tstne	r0, r6
    36b4:	0000005e 	andeq	r0, r0, lr, asr r0
    36b8:	11431300 	mrsne	r1, (UNDEF: 115)
    36bc:	1b020000 	blne	836c4 <_bss_end+0x77b54>
    36c0:	00116a0a 	andseq	r6, r1, sl, lsl #20
    36c4:	05d70100 	ldrbeq	r0, [r7, #256]	; 0x100
    36c8:	05e20000 	strbeq	r0, [r2, #0]!
    36cc:	2b100000 	blcs	4036d4 <_bss_end+0x3f7b64>
    36d0:	11000006 	tstne	r0, r6
    36d4:	00000636 	andeq	r0, r0, r6, lsr r6
    36d8:	15eb1200 	strbne	r1, [fp, #512]!	; 0x200
    36dc:	1e020000 	cdpne	0, 0, cr0, cr2, cr0, {0}
    36e0:	0016fb08 	andseq	pc, r6, r8, lsl #22
    36e4:	00016e00 	andeq	r6, r1, r0, lsl #28
    36e8:	06020100 	streq	r0, [r2], -r0, lsl #2
    36ec:	06080000 	streq	r0, [r8], -r0
    36f0:	541c0000 	ldrpl	r0, [ip], #-0
    36f4:	0000e400 	andeq	lr, r0, r0, lsl #8
    36f8:	062b1000 	strteq	r1, [fp], -r0
    36fc:	14000000 	strne	r0, [r0], #-0
    3700:	00001678 	andeq	r1, r0, r8, ror r6
    3704:	19081e02 	stmdbne	r8, {r1, r9, sl, fp, ip}
    3708:	68000016 	stmdavs	r0, {r1, r2, r4}
    370c:	01000001 	tsteq	r0, r1
    3710:	00000624 	andeq	r0, r0, r4, lsr #12
    3714:	3300541c 	movwcc	r5, #1052	; 0x41c
    3718:	10000001 	andne	r0, r0, r1
    371c:	0000062b 	andeq	r0, r0, fp, lsr #12
    3720:	040d0000 	streq	r0, [sp], #-0
    3724:	00000547 	andeq	r0, r0, r7, asr #10
    3728:	00062b03 	andeq	r2, r6, r3, lsl #22
    372c:	15041d00 	strne	r1, [r4, #-3328]	; 0xfffff300
    3730:	00001428 	andeq	r1, r0, r8, lsr #8
    3734:	471d2402 	ldrmi	r2, [sp, -r2, lsl #8]
    3738:	1e000005 	cdpne	0, 0, cr0, cr0, cr5, {0}
    373c:	006c6168 	rsbeq	r6, ip, r8, ror #2
    3740:	be0b0707 	cdplt	7, 0, cr0, cr11, cr7, {0}
    3744:	1f000006 	svcne	0x00000006
    3748:	00000680 	andeq	r0, r0, r0, lsl #13
    374c:	761c0907 	ldrvc	r0, [ip], -r7, lsl #18
    3750:	80000000 	andhi	r0, r0, r0
    3754:	1f0ee6b2 	svcne	0x000ee6b2
    3758:	000003e6 	andeq	r0, r0, r6, ror #7
    375c:	df1d0c07 	svcle	0x001d0c07
    3760:	00000000 	andeq	r0, r0, r0
    3764:	1f200000 	svcne	0x00200000
    3768:	000004c4 	andeq	r0, r0, r4, asr #9
    376c:	df1d0f07 	svcle	0x001d0f07
    3770:	00000000 	andeq	r0, r0, r0
    3774:	20202000 	eorcs	r2, r0, r0
    3778:	00000530 	andeq	r0, r0, r0, lsr r5
    377c:	6a181207 	bvs	607fa0 <_bss_end+0x5fc430>
    3780:	36000000 	strcc	r0, [r0], -r0
    3784:	0006271f 	andeq	r2, r6, pc, lsl r7
    3788:	1d440700 	stclne	7, cr0, [r4, #-0]
    378c:	000000df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    3790:	20215000 	eorcs	r5, r1, r0
    3794:	0002661f 	andeq	r6, r2, pc, lsl r6
    3798:	1d730700 	ldclne	7, cr0, [r3, #-0]
    379c:	000000df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    37a0:	2000b200 	andcs	fp, r0, r0, lsl #4
    37a4:	0005441f 	andeq	r4, r5, pc, lsl r4
    37a8:	1da60700 	stcne	7, cr0, [r6]
    37ac:	000000df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    37b0:	2000b400 	andcs	fp, r0, r0, lsl #8
    37b4:	06502100 	ldrbeq	r2, [r0], -r0, lsl #2
    37b8:	60210000 	eorvs	r0, r1, r0
    37bc:	21000006 	tstcs	r0, r6
    37c0:	00000670 	andeq	r0, r0, r0, ror r6
    37c4:	00068021 	andeq	r8, r6, r1, lsr #32
    37c8:	068d2100 	streq	r2, [sp], r0, lsl #2
    37cc:	9d210000 	stcls	0, cr0, [r1, #-0]
    37d0:	21000006 	tstcs	r0, r6
    37d4:	000006ad 	andeq	r0, r0, sp, lsr #13
    37d8:	6d656d1e 	stclvs	13, cr6, [r5, #-120]!	; 0xffffff88
    37dc:	0b060800 	bleq	1857e4 <_bss_end+0x179c74>
    37e0:	0000073a 	andeq	r0, r0, sl, lsr r7
    37e4:	00118c1f 	andseq	r8, r1, pc, lsl ip
    37e8:	180a0800 	stmdane	sl, {fp}
    37ec:	0000006a 	andeq	r0, r0, sl, rrx
    37f0:	00020000 	andeq	r0, r2, r0
    37f4:	00106c1f 	andseq	r6, r0, pc, lsl ip
    37f8:	180d0800 	stmdane	sp, {fp}
    37fc:	0000006a 	andeq	r0, r0, sl, rrx
    3800:	20000000 	andcs	r0, r0, r0
    3804:	0013de22 	andseq	sp, r3, r2, lsr #28
    3808:	18100800 	ldmdane	r0, {fp}
    380c:	0000006a 	andeq	r0, r0, sl, rrx
    3810:	711f4000 	tstvc	pc, r0
    3814:	08000012 	stmdaeq	r0, {r1, r4}
    3818:	006a1813 	rsbeq	r1, sl, r3, lsl r8
    381c:	00000000 	andeq	r0, r0, r0
    3820:	35221ffe 	strcc	r1, [r2, #-4094]!	; 0xfffff002
    3824:	08000010 	stmdaeq	r0, {r4}
    3828:	006a1816 	rsbeq	r1, sl, r6, lsl r8
    382c:	7ff80000 	svcvc	0x00f80000
    3830:	06ed2100 	strbteq	r2, [sp], r0, lsl #2
    3834:	fd210000 	stc2	0, cr0, [r1, #-0]
    3838:	21000006 	tstcs	r0, r6
    383c:	0000070d 	andeq	r0, r0, sp, lsl #14
    3840:	00071b21 	andeq	r1, r7, r1, lsr #22
    3844:	072b2100 	streq	r2, [fp, -r0, lsl #2]!
    3848:	27230000 	strcs	r0, [r3, -r0]!
    384c:	ff000015 			; <UNDEFINED> instruction: 0xff000015
    3850:	0709090f 	streq	r0, [r9, -pc, lsl #18]
    3854:	000007ed 	andeq	r0, r0, sp, ror #15
    3858:	00140c0c 	andseq	r0, r4, ip, lsl #24
    385c:	0d0c0900 	vstreq.16	s0, [ip, #-0]	; <UNPREDICTABLE>
    3860:	000007ed 	andeq	r0, r0, sp, ror #15
    3864:	14070f00 	strne	r0, [r7], #-3840	; 0xfffff100
    3868:	0e090000 	cdpeq	0, 0, cr0, cr9, cr0, {0}
    386c:	0014d60a 	andseq	sp, r4, sl, lsl #12
    3870:	00078200 	andeq	r8, r7, r0, lsl #4
    3874:	00079200 	andeq	r9, r7, r0, lsl #4
    3878:	07fe1000 	ldrbeq	r1, [lr, r0]!
    387c:	5e110000 	cdppl	0, 1, cr0, cr1, cr0, {0}
    3880:	11000000 	mrsne	r0, (UNDEF: 0)
    3884:	000004db 	ldrdeq	r0, [r0], -fp
    3888:	15271200 	strne	r1, [r7, #-512]!	; 0xfffffe00
    388c:	11090000 	mrsne	r0, (UNDEF: 9)
    3890:	0014f105 	andseq	pc, r4, r5, lsl #2
    3894:	0007fe00 	andeq	pc, r7, r0, lsl #28
    3898:	07ab0100 	streq	r0, [fp, r0, lsl #2]!
    389c:	07b10000 	ldreq	r0, [r1, r0]!
    38a0:	fe100000 	cdp2	0, 1, cr0, cr0, cr0, {0}
    38a4:	00000007 	andeq	r0, r0, r7
    38a8:	0013ec12 	andseq	lr, r3, r2, lsl ip
    38ac:	0e140900 	vnmlseq.f16	s0, s8, s0	; <UNPREDICTABLE>
    38b0:	00001433 	andeq	r1, r0, r3, lsr r4
    38b4:	0000005e 	andeq	r0, r0, lr, asr r0
    38b8:	0007ca01 	andeq	ip, r7, r1, lsl #20
    38bc:	0007d000 	andeq	sp, r7, r0
    38c0:	07fe1000 	ldrbeq	r1, [lr, r0]!
    38c4:	24000000 	strcs	r0, [r0], #-0
    38c8:	000013f7 	strdeq	r1, [r0], -r7
    38cc:	080a1609 	stmdaeq	sl, {r0, r3, r9, sl, ip}
    38d0:	01000015 	tsteq	r0, r5, lsl r0
    38d4:	000007e1 	andeq	r0, r0, r1, ror #15
    38d8:	0007fe10 	andeq	pc, r7, r0, lsl lr	; <UNPREDICTABLE>
    38dc:	005e1100 	subseq	r1, lr, r0, lsl #2
    38e0:	00000000 	andeq	r0, r0, r0
    38e4:	00003f25 	andeq	r3, r0, r5, lsr #30
    38e8:	0007fe00 	andeq	pc, r7, r0, lsl #28
    38ec:	006f2600 	rsbeq	r2, pc, r0, lsl #12
    38f0:	0ffe0000 	svceq	0x00fe0000
    38f4:	53040d00 	movwpl	r0, #19712	; 0x4d00
    38f8:	15000007 	strne	r0, [r0, #-7]
    38fc:	000015ab 	andeq	r1, r0, fp, lsr #11
    3900:	53161909 	tstpl	r6, #147456	; 0x24000
    3904:	27000007 	strcs	r0, [r0, -r7]
    3908:	00000277 	andeq	r0, r0, r7, ror r2
    390c:	05120f01 	ldreq	r0, [r2, #-3841]	; 0xfffff0ff
    3910:	00bb5403 	adcseq	r5, fp, r3, lsl #8
    3914:	16542800 	ldrbne	r2, [r4], -r0, lsl #16
    3918:	a1cc0000 	bicge	r0, ip, r0
    391c:	001c0000 	andseq	r0, ip, r0
    3920:	9c010000 	stcls	0, cr0, [r1], {-0}
    3924:	00054f29 	andeq	r4, r5, r9, lsr #30
    3928:	00a18000 	adceq	r8, r1, r0
    392c:	00004c00 	andeq	r4, r0, r0, lsl #24
    3930:	5f9c0100 	svcpl	0x009c0100
    3934:	2a000008 	bcs	395c <CPSR_IRQ_INHIBIT+0x38dc>
    3938:	00000432 	andeq	r0, r0, r2, lsr r4
    393c:	38019d01 	stmdacc	r1, {r0, r8, sl, fp, ip, pc}
    3940:	02000000 	andeq	r0, r0, #0
    3944:	ed2a7491 	cfstrs	mvf7, [sl, #-580]!	; 0xfffffdbc
    3948:	01000005 	tsteq	r0, r5
    394c:	0038019d 	mlaseq	r8, sp, r1, r0
    3950:	91020000 	mrsls	r0, (UNDEF: 2)
    3954:	e22b0070 	eor	r0, fp, #112	; 0x70
    3958:	7d000005 	stcvc	0, cr0, [r0, #-20]	; 0xffffffec
    395c:	14000008 	strne	r0, [r0], #-8
    3960:	2c0000a2 	stccs	0, cr0, [r0], {162}	; 0xa2
    3964:	01000000 	mrseq	r0, (UNDEF: 0)
    3968:	00088a9c 	muleq	r8, ip, sl
    396c:	00541c00 	subseq	r1, r4, r0, lsl #24
    3970:	000000e4 	andeq	r0, r0, r4, ror #1
    3974:	0005822c 	andeq	r8, r5, ip, lsr #4
    3978:	00063100 	andeq	r3, r6, r0, lsl #2
    397c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    3980:	06082b00 	streq	r2, [r8], -r0, lsl #22
    3984:	08a80000 	stmiaeq	r8!, {}	; <UNPREDICTABLE>
    3988:	a1e80000 	mvnge	r0, r0
    398c:	002c0000 	eoreq	r0, ip, r0
    3990:	9c010000 	stcls	0, cr0, [r1], {-0}
    3994:	000008b5 			; <UNDEFINED> instruction: 0x000008b5
    3998:	3300541c 	movwcc	r5, #1052	; 0x41c
    399c:	2c000001 	stccs	0, cr0, [r0], {1}
    39a0:	00000582 	andeq	r0, r0, r2, lsl #11
    39a4:	00000631 	andeq	r0, r0, r1, lsr r6
    39a8:	00749102 	rsbseq	r9, r4, r2, lsl #2
    39ac:	0001a82d 	andeq	sl, r1, sp, lsr #16
    39b0:	06860100 	streq	r0, [r6], r0, lsl #2
    39b4:	000008cf 	andeq	r0, r0, pc, asr #17
    39b8:	0000a07c 	andeq	sl, r0, ip, ror r0
    39bc:	00000104 	andeq	r0, r0, r4, lsl #2
    39c0:	09099c01 	stmdbeq	r9, {r0, sl, fp, ip, pc}
    39c4:	822c0000 	eorhi	r0, ip, #0
    39c8:	67000005 	strvs	r0, [r0, -r5]
    39cc:	02000002 	andeq	r0, r0, #2
    39d0:	1b2a6c91 	blne	a9ec1c <_bss_end+0xa930ac>
    39d4:	01000024 	tsteq	r0, r4, lsr #32
    39d8:	01683686 	cmneq	r8, r6, lsl #13
    39dc:	91020000 	mrsls	r0, (UNDEF: 2)
    39e0:	6c6f2e68 	stclvs	14, cr2, [pc], #-416	; 3848 <CPSR_IRQ_INHIBIT+0x37c8>
    39e4:	90010064 	andls	r0, r1, r4, rrx
    39e8:	00090913 	andeq	r0, r9, r3, lsl r9
    39ec:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    39f0:	0015dd2f 	andseq	sp, r5, pc, lsr #26
    39f4:	0a910100 	beq	fe443dfc <_bss_end+0xfe43828c>
    39f8:	000004db 	ldrdeq	r0, [r0], -fp
    39fc:	00739102 	rsbseq	r9, r3, r2, lsl #2
    3a00:	00a6040d 	adceq	r0, r6, sp, lsl #8
    3a04:	252d0000 	strcs	r0, [sp, #-0]!
    3a08:	01000002 	tsteq	r0, r2
    3a0c:	0929065a 	stmdbeq	r9!, {r1, r3, r4, r6, r9, sl}
    3a10:	9f140000 	svcls	0x00140000
    3a14:	01680000 	cmneq	r8, r0
    3a18:	9c010000 	stcls	0, cr0, [r1], {-0}
    3a1c:	00000945 	andeq	r0, r0, r5, asr #18
    3a20:	0005822c 	andeq	r8, r5, ip, lsr #4
    3a24:	00026700 	andeq	r6, r2, r0, lsl #14
    3a28:	6c910200 	lfmvs	f0, 4, [r1], {0}
    3a2c:	0010772f 	andseq	r7, r0, pc, lsr #14
    3a30:	19690100 	stmdbne	r9!, {r8}^
    3a34:	00000168 	andeq	r0, r0, r8, ror #2
    3a38:	00749102 	rsbseq	r9, r4, r2, lsl #2
    3a3c:	0002012d 	andeq	r0, r2, sp, lsr #2
    3a40:	0a390100 	beq	e43e48 <_bss_end+0xe382d8>
    3a44:	0000095f 	andeq	r0, r0, pc, asr r9
    3a48:	00009d50 	andeq	r9, r0, r0, asr sp
    3a4c:	000001c4 	andeq	r0, r0, r4, asr #3
    3a50:	09999c01 	ldmibeq	r9, {r0, sl, fp, ip, pc}
    3a54:	822c0000 	eorhi	r0, ip, #0
    3a58:	67000005 	strvs	r0, [r0, -r5]
    3a5c:	02000002 	andeq	r0, r0, #2
    3a60:	d52a6c91 	strle	r6, [sl, #-3217]!	; 0xfffff36f
    3a64:	01000015 	tsteq	r0, r5, lsl r0
    3a68:	00d83939 	sbcseq	r3, r8, r9, lsr r9
    3a6c:	91020000 	mrsls	r0, (UNDEF: 2)
    3a70:	166f2f68 	strbtne	r2, [pc], -r8, ror #30
    3a74:	3b010000 	blcc	43a7c <_bss_end+0x37f0c>
    3a78:	00016819 	andeq	r6, r1, r9, lsl r8
    3a7c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    3a80:	0012822f 	andseq	r8, r2, pc, lsr #4
    3a84:	0b490100 	bleq	1243e8c <_bss_end+0x123831c>
    3a88:	0000016e 	andeq	r0, r0, lr, ror #2
    3a8c:	00709102 	rsbseq	r9, r0, r2, lsl #2
    3a90:	0001e62d 	andeq	lr, r1, sp, lsr #12
    3a94:	061e0100 	ldreq	r0, [lr], -r0, lsl #2
    3a98:	000009b3 			; <UNDEFINED> instruction: 0x000009b3
    3a9c:	00009c58 	andeq	r9, r0, r8, asr ip
    3aa0:	000000f8 	strdeq	r0, [r0], -r8
    3aa4:	09de9c01 	ldmibeq	lr, {r0, sl, fp, ip, pc}^
    3aa8:	822c0000 	eorhi	r0, ip, #0
    3aac:	67000005 	strvs	r0, [r0, -r5]
    3ab0:	02000002 	andeq	r0, r0, #2
    3ab4:	6f2f6c91 	svcvs	0x002f6c91
    3ab8:	01000016 	tsteq	r0, r6, lsl r0
    3abc:	01681920 	cmneq	r8, r0, lsr #18
    3ac0:	91020000 	mrsls	r0, (UNDEF: 2)
    3ac4:	12822f74 	addne	r2, r2, #116, 30	; 0x1d0
    3ac8:	2f010000 	svccs	0x00010000
    3acc:	00016e0b 	andeq	r6, r1, fp, lsl #28
    3ad0:	70910200 	addsvc	r0, r1, r0, lsl #4
    3ad4:	02403000 	subeq	r3, r0, #0
    3ad8:	19010000 	stmdbne	r1, {}	; <UNPREDICTABLE>
    3adc:	0009f80f 	andeq	pc, r9, pc, lsl #16
    3ae0:	009c1400 	addseq	r1, ip, r0, lsl #8
    3ae4:	00004400 	andeq	r4, r0, r0, lsl #8
    3ae8:	059c0100 	ldreq	r0, [ip, #256]	; 0x100
    3aec:	2c00000a 	stccs	0, cr0, [r0], {10}
    3af0:	00000582 	andeq	r0, r0, r2, lsl #11
    3af4:	00000272 	andeq	r0, r0, r2, ror r2
    3af8:	00749102 	rsbseq	r9, r4, r2, lsl #2
    3afc:	0001c731 	andeq	ip, r1, r1, lsr r7
    3b00:	01110100 	tsteq	r1, r0, lsl #2
    3b04:	00000a16 	andeq	r0, r0, r6, lsl sl
    3b08:	000a2000 	andeq	r2, sl, r0
    3b0c:	05823200 	streq	r3, [r2, #512]	; 0x200
    3b10:	02670000 	rsbeq	r0, r7, #0
    3b14:	33000000 	movwcc	r0, #0
    3b18:	00000a05 	andeq	r0, r0, r5, lsl #20
    3b1c:	000015ff 	strdeq	r1, [r0], -pc	; <UNPREDICTABLE>
    3b20:	00000a37 	andeq	r0, r0, r7, lsr sl
    3b24:	00009bcc 	andeq	r9, r0, ip, asr #23
    3b28:	00000048 	andeq	r0, r0, r8, asr #32
    3b2c:	16349c01 	ldrtne	r9, [r4], -r1, lsl #24
    3b30:	0200000a 	andeq	r0, r0, #10
    3b34:	00007491 	muleq	r0, r1, r4
    3b38:	00000022 	andeq	r0, r0, r2, lsr #32
    3b3c:	16500002 	ldrbne	r0, [r0], -r2
    3b40:	01040000 	mrseq	r0, (UNDEF: 4)
    3b44:	00001997 	muleq	r0, r7, r9
    3b48:	0000a240 	andeq	sl, r0, r0, asr #4
    3b4c:	0000a29c 	muleq	r0, ip, r2
    3b50:	00001730 	andeq	r1, r0, r0, lsr r7
    3b54:	000000b6 	strheq	r0, [r0], -r6
    3b58:	0000178e 	andeq	r1, r0, lr, lsl #15
    3b5c:	001e8001 	andseq	r8, lr, r1
    3b60:	00020000 	andeq	r0, r2, r0
    3b64:	00001664 	andeq	r1, r0, r4, ror #12
    3b68:	1a380104 	bne	e03f80 <_bss_end+0xdf8410>
    3b6c:	00480000 	subeq	r0, r8, r0
    3b70:	179a0000 	ldrne	r0, [sl, r0]
    3b74:	00b60000 	adcseq	r0, r6, r0
    3b78:	178e0000 	strne	r0, [lr, r0]
    3b7c:	80010000 	andhi	r0, r1, r0
    3b80:	0000014b 	andeq	r0, r0, fp, asr #2
    3b84:	16760004 	ldrbtne	r0, [r6], -r4
    3b88:	01040000 	mrseq	r0, (UNDEF: 4)
    3b8c:	00000000 	andeq	r0, r0, r0
    3b90:	00186404 	andseq	r6, r8, r4, lsl #8
    3b94:	0000b600 	andeq	fp, r0, r0, lsl #12
    3b98:	00a2ec00 	adceq	lr, r2, r0, lsl #24
    3b9c:	00011800 	andeq	r1, r1, r0, lsl #16
    3ba0:	001b0400 	andseq	r0, fp, r0, lsl #8
    3ba4:	185b0200 	ldmdane	fp, {r9}^
    3ba8:	02010000 	andeq	r0, r1, #0
    3bac:	00003107 	andeq	r3, r0, r7, lsl #2
    3bb0:	37040300 	strcc	r0, [r4, -r0, lsl #6]
    3bb4:	04000000 	streq	r0, [r0], #-0
    3bb8:	00185202 	andseq	r5, r8, r2, lsl #4
    3bbc:	07030100 	streq	r0, [r3, -r0, lsl #2]
    3bc0:	00000031 	andeq	r0, r0, r1, lsr r0
    3bc4:	0017fa05 	andseq	pc, r7, r5, lsl #20
    3bc8:	10060100 	andne	r0, r6, r0, lsl #2
    3bcc:	00000050 	andeq	r0, r0, r0, asr r0
    3bd0:	69050406 	stmdbvs	r5, {r1, r2, sl}
    3bd4:	0500746e 	streq	r7, [r0, #-1134]	; 0xfffffb92
    3bd8:	0000183b 	andeq	r1, r0, fp, lsr r8
    3bdc:	50100801 	andspl	r0, r0, r1, lsl #16
    3be0:	07000000 	streq	r0, [r0, -r0]
    3be4:	00000025 	andeq	r0, r0, r5, lsr #32
    3be8:	00000076 	andeq	r0, r0, r6, ror r0
    3bec:	00007608 	andeq	r7, r0, r8, lsl #12
    3bf0:	ffffff00 			; <UNDEFINED> instruction: 0xffffff00
    3bf4:	040900ff 	streq	r0, [r9], #-255	; 0xffffff01
    3bf8:	001e6207 	andseq	r6, lr, r7, lsl #4
    3bfc:	18120500 	ldmdane	r2, {r8, sl}
    3c00:	0b010000 	bleq	43c08 <_bss_end+0x38098>
    3c04:	00006315 	andeq	r6, r0, r5, lsl r3
    3c08:	18050500 	stmdane	r5, {r8, sl}
    3c0c:	0d010000 	stceq	0, cr0, [r1, #-0]
    3c10:	00006315 	andeq	r6, r0, r5, lsl r3
    3c14:	00380700 	eorseq	r0, r8, r0, lsl #14
    3c18:	00a80000 	adceq	r0, r8, r0
    3c1c:	76080000 	strvc	r0, [r8], -r0
    3c20:	ff000000 			; <UNDEFINED> instruction: 0xff000000
    3c24:	00ffffff 	ldrshteq	pc, [pc], #255	; <UNPREDICTABLE>
    3c28:	00184405 	andseq	r4, r8, r5, lsl #8
    3c2c:	15100100 	ldrne	r0, [r0, #-256]	; 0xffffff00
    3c30:	00000095 	muleq	r0, r5, r0
    3c34:	00182005 	andseq	r2, r8, r5
    3c38:	15120100 	ldrne	r0, [r2, #-256]	; 0xffffff00
    3c3c:	00000095 	muleq	r0, r5, r0
    3c40:	00182d0a 	andseq	r2, r8, sl, lsl #26
    3c44:	102b0100 	eorne	r0, fp, r0, lsl #2
    3c48:	00000050 	andeq	r0, r0, r0, asr r0
    3c4c:	0000a3ac 	andeq	sl, r0, ip, lsr #7
    3c50:	00000058 	andeq	r0, r0, r8, asr r0
    3c54:	00ea9c01 	rsceq	r9, sl, r1, lsl #24
    3c58:	ca0b0000 	bgt	2c3c60 <_bss_end+0x2b80f0>
    3c5c:	01000018 	tsteq	r0, r8, lsl r0
    3c60:	00ea0f2d 	rsceq	r0, sl, sp, lsr #30
    3c64:	91020000 	mrsls	r0, (UNDEF: 2)
    3c68:	04030074 	streq	r0, [r3], #-116	; 0xffffff8c
    3c6c:	00000038 	andeq	r0, r0, r8, lsr r0
    3c70:	0018bd0a 	andseq	fp, r8, sl, lsl #26
    3c74:	101f0100 	andsne	r0, pc, r0, lsl #2
    3c78:	00000050 	andeq	r0, r0, r0, asr r0
    3c7c:	0000a354 	andeq	sl, r0, r4, asr r3
    3c80:	00000058 	andeq	r0, r0, r8, asr r0
    3c84:	011a9c01 	tsteq	sl, r1, lsl #24
    3c88:	ca0b0000 	bgt	2c3c90 <_bss_end+0x2b8120>
    3c8c:	01000018 	tsteq	r0, r8, lsl r0
    3c90:	011a0f21 	tsteq	sl, r1, lsr #30
    3c94:	91020000 	mrsls	r0, (UNDEF: 2)
    3c98:	04030074 	streq	r0, [r3], #-116	; 0xffffff8c
    3c9c:	00000025 	andeq	r0, r0, r5, lsr #32
    3ca0:	0017ef0c 	andseq	lr, r7, ip, lsl #30
    3ca4:	10140100 	andsne	r0, r4, r0, lsl #2
    3ca8:	00000050 	andeq	r0, r0, r0, asr r0
    3cac:	0000a2ec 	andeq	sl, r0, ip, ror #5
    3cb0:	00000068 	andeq	r0, r0, r8, rrx
    3cb4:	01489c01 	cmpeq	r8, r1, lsl #24
    3cb8:	690d0000 	stmdbvs	sp, {}	; <UNPREDICTABLE>
    3cbc:	0a160100 	beq	5840c4 <_bss_end+0x578554>
    3cc0:	00000148 	andeq	r0, r0, r8, asr #2
    3cc4:	00749102 	rsbseq	r9, r4, r2, lsl #2
    3cc8:	00500403 	subseq	r0, r0, r3, lsl #8
    3ccc:	0b000000 	bleq	3cd4 <CPSR_IRQ_INHIBIT+0x3c54>
    3cd0:	04000001 	streq	r0, [r0], #-1
    3cd4:	00173c00 	andseq	r3, r7, r0, lsl #24
    3cd8:	00010400 	andeq	r0, r1, r0, lsl #8
    3cdc:	04000000 	streq	r0, [r0], #-0
    3ce0:	000018d0 	ldrdeq	r1, [r0], -r0
    3ce4:	000000b6 	strheq	r0, [r0], -r6
    3ce8:	0000a404 	andeq	sl, r0, r4, lsl #8
    3cec:	00000174 	andeq	r0, r0, r4, ror r1
    3cf0:	00001bf8 	strdeq	r1, [r0], -r8
    3cf4:	00004902 	andeq	r4, r0, r2, lsl #18
    3cf8:	081e0300 	ldmdaeq	lr, {r8, r9}
    3cfc:	05010000 	streq	r0, [r1, #-0]
    3d00:	00006110 	andeq	r6, r0, r0, lsl r1
    3d04:	31301100 	teqcc	r0, r0, lsl #2
    3d08:	35343332 	ldrcc	r3, [r4, #-818]!	; 0xfffffcce
    3d0c:	39383736 	ldmdbcc	r8!, {r1, r2, r4, r5, r8, r9, sl, ip, sp}
    3d10:	44434241 	strbmi	r4, [r3], #-577	; 0xfffffdbf
    3d14:	00004645 	andeq	r4, r0, r5, asr #12
    3d18:	01030104 	tsteq	r3, r4, lsl #2
    3d1c:	00000025 	andeq	r0, r0, r5, lsr #32
    3d20:	00007405 	andeq	r7, r0, r5, lsl #8
    3d24:	00006100 	andeq	r6, r0, r0, lsl #2
    3d28:	00660600 	rsbeq	r0, r6, r0, lsl #12
    3d2c:	00100000 	andseq	r0, r0, r0
    3d30:	00005107 	andeq	r5, r0, r7, lsl #2
    3d34:	07040800 	streq	r0, [r4, -r0, lsl #16]
    3d38:	00001e62 	andeq	r1, r0, r2, ror #28
    3d3c:	a0080108 	andge	r0, r8, r8, lsl #2
    3d40:	07000004 	streq	r0, [r0, -r4]
    3d44:	0000006d 	andeq	r0, r0, sp, rrx
    3d48:	00002a09 	andeq	r2, r0, r9, lsl #20
    3d4c:	070a0a00 	streq	r0, [sl, -r0, lsl #20]
    3d50:	08010000 	stmdaeq	r1, {}	; <UNPREDICTABLE>
    3d54:	00192b06 	andseq	r2, r9, r6, lsl #22
    3d58:	00a40400 	adceq	r0, r4, r0, lsl #8
    3d5c:	00017400 	andeq	r7, r1, r0, lsl #8
    3d60:	019c0100 	orrseq	r0, ip, r0, lsl #2
    3d64:	0b000001 	bleq	3d70 <CPSR_IRQ_INHIBIT+0x3cf0>
    3d68:	000008c6 	andeq	r0, r0, r6, asr #17
    3d6c:	66180801 	ldrvs	r0, [r8], -r1, lsl #16
    3d70:	02000000 	andeq	r0, r0, #0
    3d74:	bf0b6491 	svclt	0x000b6491
    3d78:	01000008 	tsteq	r0, r8
    3d7c:	01012508 	tsteq	r1, r8, lsl #10
    3d80:	91020000 	mrsls	r0, (UNDEF: 2)
    3d84:	0b4c0b60 	bleq	1306b0c <_bss_end+0x12faf9c>
    3d88:	08010000 	stmdaeq	r1, {}	; <UNPREDICTABLE>
    3d8c:	0000663a 	andeq	r6, r0, sl, lsr r6
    3d90:	5c910200 	lfmpl	f0, 4, [r1], {0}
    3d94:	0100690c 	tsteq	r0, ip, lsl #18
    3d98:	0107090a 	tsteq	r7, sl, lsl #18
    3d9c:	91020000 	mrsls	r0, (UNDEF: 2)
    3da0:	a4d00d74 	ldrbge	r0, [r0], #3444	; 0xd74
    3da4:	00980000 	addseq	r0, r8, r0
    3da8:	6a0c0000 	bvs	303db0 <_bss_end+0x2f8240>
    3dac:	0e1c0100 	mufeqe	f0, f4, f0
    3db0:	00000107 	andeq	r0, r0, r7, lsl #2
    3db4:	0d709102 	ldfeqp	f1, [r0, #-8]!
    3db8:	0000a4f8 	strdeq	sl, [r0], -r8
    3dbc:	00000060 	andeq	r0, r0, r0, rrx
    3dc0:	0100630c 	tsteq	r0, ip, lsl #6
    3dc4:	006d0e1e 	rsbeq	r0, sp, lr, lsl lr
    3dc8:	91020000 	mrsls	r0, (UNDEF: 2)
    3dcc:	0000006f 	andeq	r0, r0, pc, rrx
    3dd0:	006d040e 	rsbeq	r0, sp, lr, lsl #8
    3dd4:	040f0000 	streq	r0, [pc], #-0	; 3ddc <CPSR_IRQ_INHIBIT+0x3d5c>
    3dd8:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
    3ddc:	00220000 	eoreq	r0, r2, r0
    3de0:	00020000 	andeq	r0, r2, r0
    3de4:	000017fd 	strdeq	r1, [r0], -sp
    3de8:	1d2b0104 	stfnes	f0, [fp, #-16]!
    3dec:	a5780000 	ldrbge	r0, [r8, #-0]!
    3df0:	a7840000 	strge	r0, [r4, r0]
    3df4:	19370000 	ldmdbne	r7!, {}	; <UNPREDICTABLE>
    3df8:	19670000 	stmdbne	r7!, {}^	; <UNPREDICTABLE>
    3dfc:	178e0000 	strne	r0, [lr, r0]
    3e00:	80010000 	andhi	r0, r1, r0
    3e04:	00000022 	andeq	r0, r0, r2, lsr #32
    3e08:	18110002 	ldmdane	r1, {r1}
    3e0c:	01040000 	mrseq	r0, (UNDEF: 4)
    3e10:	00001da8 	andeq	r1, r0, r8, lsr #27
    3e14:	0000a784 	andeq	sl, r0, r4, lsl #15
    3e18:	0000a788 	andeq	sl, r0, r8, lsl #15
    3e1c:	00001937 	andeq	r1, r0, r7, lsr r9
    3e20:	00001967 	andeq	r1, r0, r7, ror #18
    3e24:	0000178e 	andeq	r1, r0, lr, lsl #15
    3e28:	09328001 	ldmdbeq	r2!, {r0, pc}
    3e2c:	00040000 	andeq	r0, r4, r0
    3e30:	00001825 	andeq	r1, r0, r5, lsr #16
    3e34:	1d350104 	ldfnes	f0, [r5, #-16]!
    3e38:	8c0c0000 	stchi	0, cr0, [ip], {-0}
    3e3c:	6700001c 	smladvs	r0, ip, r0, r0
    3e40:	08000019 	stmdaeq	r0, {r0, r3, r4}
    3e44:	0200001e 	andeq	r0, r0, #30
    3e48:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
    3e4c:	04030074 	streq	r0, [r3], #-116	; 0xffffff8c
    3e50:	001e6207 	andseq	r6, lr, r7, lsl #4
    3e54:	05080300 	streq	r0, [r8, #-768]	; 0xfffffd00
    3e58:	000001e4 	andeq	r0, r0, r4, ror #3
    3e5c:	34040803 	strcc	r0, [r4], #-2051	; 0xfffff7fd
    3e60:	04000025 	streq	r0, [r0], #-37	; 0xffffffdb
    3e64:	00001ce7 	andeq	r1, r0, r7, ror #25
    3e68:	24162a01 	ldrcs	r2, [r6], #-2561	; 0xfffff5ff
    3e6c:	04000000 	streq	r0, [r0], #-0
    3e70:	00002156 	andeq	r2, r0, r6, asr r1
    3e74:	51152f01 	tstpl	r5, r1, lsl #30
    3e78:	05000000 	streq	r0, [r0, #-0]
    3e7c:	00005704 	andeq	r5, r0, r4, lsl #14
    3e80:	00390600 	eorseq	r0, r9, r0, lsl #12
    3e84:	00660000 	rsbeq	r0, r6, r0
    3e88:	66070000 	strvs	r0, [r7], -r0
    3e8c:	00000000 	andeq	r0, r0, r0
    3e90:	006c0405 	rsbeq	r0, ip, r5, lsl #8
    3e94:	04080000 	streq	r0, [r8], #-0
    3e98:	00002888 	andeq	r2, r0, r8, lsl #17
    3e9c:	790f3601 	stmdbvc	pc, {r0, r9, sl, ip, sp}	; <UNPREDICTABLE>
    3ea0:	05000000 	streq	r0, [r0, #-0]
    3ea4:	00007f04 	andeq	r7, r0, r4, lsl #30
    3ea8:	001d0600 	andseq	r0, sp, r0, lsl #12
    3eac:	00930000 	addseq	r0, r3, r0
    3eb0:	66070000 	strvs	r0, [r7], -r0
    3eb4:	07000000 	streq	r0, [r0, -r0]
    3eb8:	00000066 	andeq	r0, r0, r6, rrx
    3ebc:	08010300 	stmdaeq	r1, {r8, r9}
    3ec0:	00000497 	muleq	r0, r7, r4
    3ec4:	00238e09 	eoreq	r8, r3, r9, lsl #28
    3ec8:	12bb0100 	adcsne	r0, fp, #0, 2
    3ecc:	00000045 	andeq	r0, r0, r5, asr #32
    3ed0:	0028b609 	eoreq	fp, r8, r9, lsl #12
    3ed4:	10be0100 	adcsne	r0, lr, r0, lsl #2
    3ed8:	0000006d 	andeq	r0, r0, sp, rrx
    3edc:	99060103 	stmdbls	r6, {r0, r1, r8}
    3ee0:	0a000004 	beq	3ef8 <CPSR_IRQ_INHIBIT+0x3e78>
    3ee4:	00002076 	andeq	r2, r0, r6, ror r0
    3ee8:	00930107 	addseq	r0, r3, r7, lsl #2
    3eec:	17020000 	strne	r0, [r2, -r0]
    3ef0:	0001e606 	andeq	lr, r1, r6, lsl #12
    3ef4:	1b450b00 	blne	1146afc <_bss_end+0x113af8c>
    3ef8:	0b000000 	bleq	3f00 <CPSR_IRQ_INHIBIT+0x3e80>
    3efc:	00001f93 	muleq	r0, r3, pc	; <UNPREDICTABLE>
    3f00:	24590b01 	ldrbcs	r0, [r9], #-2817	; 0xfffff4ff
    3f04:	0b020000 	bleq	83f0c <_bss_end+0x7839c>
    3f08:	000027ca 	andeq	r2, r0, sl, asr #15
    3f0c:	23fd0b03 	mvnscs	r0, #3072	; 0xc00
    3f10:	0b040000 	bleq	103f18 <_bss_end+0xf83a8>
    3f14:	000026d3 	ldrdeq	r2, [r0], -r3
    3f18:	26370b05 	ldrtcs	r0, [r7], -r5, lsl #22
    3f1c:	0b060000 	bleq	183f24 <_bss_end+0x1783b4>
    3f20:	00001b66 	andeq	r1, r0, r6, ror #22
    3f24:	26e80b07 	strbtcs	r0, [r8], r7, lsl #22
    3f28:	0b080000 	bleq	203f30 <_bss_end+0x1f83c0>
    3f2c:	000026f6 	strdeq	r2, [r0], -r6
    3f30:	27bd0b09 	ldrcs	r0, [sp, r9, lsl #22]!
    3f34:	0b0a0000 	bleq	283f3c <_bss_end+0x2783cc>
    3f38:	00002354 	andeq	r2, r0, r4, asr r3
    3f3c:	1d280b0b 	fstmdbxne	r8!, {d0-d4}	;@ Deprecated
    3f40:	0b0c0000 	bleq	303f48 <_bss_end+0x2f83d8>
    3f44:	00001e05 	andeq	r1, r0, r5, lsl #28
    3f48:	20ba0b0d 	adcscs	r0, sl, sp, lsl #22
    3f4c:	0b0e0000 	bleq	383f54 <_bss_end+0x3783e4>
    3f50:	000020d0 	ldrdeq	r2, [r0], -r0
    3f54:	1fcd0b0f 	svcne	0x00cd0b0f
    3f58:	0b100000 	bleq	403f60 <_bss_end+0x3f83f0>
    3f5c:	000023e1 	andeq	r2, r0, r1, ror #7
    3f60:	20390b11 	eorscs	r0, r9, r1, lsl fp
    3f64:	0b120000 	bleq	483f6c <_bss_end+0x4783fc>
    3f68:	00002a4f 	andeq	r2, r0, pc, asr #20
    3f6c:	1bcf0b13 	blne	ff3c6bc0 <_bss_end+0xff3bb050>
    3f70:	0b140000 	bleq	503f78 <_bss_end+0x4f8408>
    3f74:	0000205d 	andeq	r2, r0, sp, asr r0
    3f78:	1b0c0b15 	blne	306bd4 <_bss_end+0x2fb064>
    3f7c:	0b160000 	bleq	583f84 <_bss_end+0x578414>
    3f80:	000027ed 	andeq	r2, r0, sp, ror #15
    3f84:	290f0b17 	stmdbcs	pc, {r0, r1, r2, r4, r8, r9, fp}	; <UNPREDICTABLE>
    3f88:	0b180000 	bleq	603f90 <_bss_end+0x5f8420>
    3f8c:	00002082 	andeq	r2, r0, r2, lsl #1
    3f90:	24cb0b19 	strbcs	r0, [fp], #2841	; 0xb19
    3f94:	0b1a0000 	bleq	683f9c <_bss_end+0x67842c>
    3f98:	000027fb 	strdeq	r2, [r0], -fp
    3f9c:	1a3b0b1b 	bne	ec6c10 <_bss_end+0xebb0a0>
    3fa0:	0b1c0000 	bleq	703fa8 <_bss_end+0x6f8438>
    3fa4:	00002809 	andeq	r2, r0, r9, lsl #16
    3fa8:	28170b1d 	ldmdacs	r7, {r0, r2, r3, r4, r8, r9, fp}
    3fac:	0b1e0000 	bleq	783fb4 <_bss_end+0x778444>
    3fb0:	000019e9 	andeq	r1, r0, r9, ror #19
    3fb4:	28410b1f 	stmdacs	r1, {r0, r1, r2, r3, r4, r8, r9, fp}^
    3fb8:	0b200000 	bleq	803fc0 <_bss_end+0x7f8450>
    3fbc:	00002578 	andeq	r2, r0, r8, ror r5
    3fc0:	23b30b21 			; <UNDEFINED> instruction: 0x23b30b21
    3fc4:	0b220000 	bleq	883fcc <_bss_end+0x87845c>
    3fc8:	000027e0 	andeq	r2, r0, r0, ror #15
    3fcc:	22b70b23 	adcscs	r0, r7, #35840	; 0x8c00
    3fd0:	0b240000 	bleq	903fd8 <_bss_end+0x8f8468>
    3fd4:	000021b9 			; <UNDEFINED> instruction: 0x000021b9
    3fd8:	1ed30b25 	vfnmsne.f64	d16, d3, d21
    3fdc:	0b260000 	bleq	983fe4 <_bss_end+0x978474>
    3fe0:	000021d7 	ldrdeq	r2, [r0], -r7
    3fe4:	1f6f0b27 	svcne	0x006f0b27
    3fe8:	0b280000 	bleq	a03ff0 <_bss_end+0x9f8480>
    3fec:	000021e7 	andeq	r2, r0, r7, ror #3
    3ff0:	21f70b29 	mvnscs	r0, r9, lsr #22
    3ff4:	0b2a0000 	bleq	a83ffc <_bss_end+0xa7848c>
    3ff8:	0000233a 	andeq	r2, r0, sl, lsr r3
    3ffc:	21600b2b 	cmncs	r0, fp, lsr #22
    4000:	0b2c0000 	bleq	b04008 <_bss_end+0xaf8498>
    4004:	00002585 	andeq	r2, r0, r5, lsl #11
    4008:	1f140b2d 	svcne	0x00140b2d
    400c:	002e0000 	eoreq	r0, lr, r0
    4010:	0020f20a 	eoreq	pc, r0, sl, lsl #4
    4014:	93010700 	movwls	r0, #5888	; 0x1700
    4018:	03000000 	movweq	r0, #0
    401c:	03c70617 	biceq	r0, r7, #24117248	; 0x1700000
    4020:	270b0000 	strcs	r0, [fp, -r0]
    4024:	0000001e 	andeq	r0, r0, lr, lsl r0
    4028:	001a790b 	andseq	r7, sl, fp, lsl #18
    402c:	fd0b0100 	stc2	1, cr0, [fp, #-0]
    4030:	02000029 	andeq	r0, r0, #41	; 0x29
    4034:	0028900b 	eoreq	r9, r8, fp
    4038:	470b0300 	strmi	r0, [fp, -r0, lsl #6]
    403c:	0400001e 	streq	r0, [r0], #-30	; 0xffffffe2
    4040:	001b310b 	andseq	r3, fp, fp, lsl #2
    4044:	f00b0500 			; <UNDEFINED> instruction: 0xf00b0500
    4048:	0600001e 			; <UNDEFINED> instruction: 0x0600001e
    404c:	001e370b 	andseq	r3, lr, fp, lsl #14
    4050:	240b0700 	strcs	r0, [fp], #-1792	; 0xfffff900
    4054:	08000027 	stmdaeq	r0, {r0, r1, r2, r5}
    4058:	0028750b 	eoreq	r7, r8, fp, lsl #10
    405c:	5b0b0900 	blpl	2c6464 <_bss_end+0x2ba8f4>
    4060:	0a000026 	beq	4100 <CPSR_IRQ_INHIBIT+0x4080>
    4064:	001b840b 	andseq	r8, fp, fp, lsl #8
    4068:	910b0b00 	tstls	fp, r0, lsl #22
    406c:	0c00001e 	stceq	0, cr0, [r0], {30}
    4070:	001afa0b 	andseq	pc, sl, fp, lsl #20
    4074:	320b0d00 	andcc	r0, fp, #0, 26
    4078:	0e00002a 	cdpeq	0, 0, cr0, cr0, cr10, {1}
    407c:	0023270b 	eoreq	r2, r3, fp, lsl #14
    4080:	040b0f00 	streq	r0, [fp], #-3840	; 0xfffff100
    4084:	10000020 	andne	r0, r0, r0, lsr #32
    4088:	0023640b 	eoreq	r6, r3, fp, lsl #8
    408c:	510b1100 	mrspl	r1, (UNDEF: 27)
    4090:	12000029 	andne	r0, r0, #41	; 0x29
    4094:	001c470b 	andseq	r4, ip, fp, lsl #14
    4098:	170b1300 	strne	r1, [fp, -r0, lsl #6]
    409c:	14000020 	strne	r0, [r0], #-32	; 0xffffffe0
    40a0:	00227a0b 	eoreq	r7, r2, fp, lsl #20
    40a4:	120b1500 	andne	r1, fp, #0, 10
    40a8:	1600001e 			; <UNDEFINED> instruction: 0x1600001e
    40ac:	0022c60b 	eoreq	ip, r2, fp, lsl #12
    40b0:	dc0b1700 	stcle	7, cr1, [fp], {-0}
    40b4:	18000020 	stmdane	r0, {r5}
    40b8:	001b4f0b 	andseq	r4, fp, fp, lsl #30
    40bc:	f80b1900 			; <UNDEFINED> instruction: 0xf80b1900
    40c0:	1a000028 	bne	4168 <CPSR_IRQ_INHIBIT+0x40e8>
    40c4:	0022460b 	eoreq	r4, r2, fp, lsl #12
    40c8:	ee0b1b00 	vmla.f64	d1, d11, d0
    40cc:	1c00001f 	stcne	0, cr0, [r0], {31}
    40d0:	001a240b 	andseq	r2, sl, fp, lsl #8
    40d4:	910b1d00 	tstls	fp, r0, lsl #26
    40d8:	1e000021 	cdpne	0, 0, cr0, cr0, cr1, {1}
    40dc:	00217d0b 	eoreq	r7, r1, fp, lsl #26
    40e0:	180b1f00 	stmdane	fp, {r8, r9, sl, fp, ip}
    40e4:	20000026 	andcs	r0, r0, r6, lsr #32
    40e8:	0026a30b 	eoreq	sl, r6, fp, lsl #6
    40ec:	d70b2100 	strle	r2, [fp, -r0, lsl #2]
    40f0:	22000028 	andcs	r0, r0, #40	; 0x28
    40f4:	001f210b 	andseq	r2, pc, fp, lsl #2
    40f8:	7b0b2300 	blvc	2ccd00 <_bss_end+0x2c1190>
    40fc:	24000024 	strcs	r0, [r0], #-36	; 0xffffffdc
    4100:	0026700b 	eoreq	r7, r6, fp
    4104:	940b2500 	strls	r2, [fp], #-1280	; 0xfffffb00
    4108:	26000025 	strcs	r0, [r0], -r5, lsr #32
    410c:	0025a80b 	eoreq	sl, r5, fp, lsl #16
    4110:	bc0b2700 	stclt	7, cr2, [fp], {-0}
    4114:	28000025 	stmdacs	r0, {r0, r2, r5}
    4118:	001cd20b 	andseq	sp, ip, fp, lsl #4
    411c:	320b2900 	andcc	r2, fp, #0, 18
    4120:	2a00001c 	bcs	4198 <CPSR_IRQ_INHIBIT+0x4118>
    4124:	001c5a0b 	andseq	r5, ip, fp, lsl #20
    4128:	6d0b2b00 	vstrvs	d2, [fp, #-0]
    412c:	2c000027 	stccs	0, cr0, [r0], {39}	; 0x27
    4130:	001caf0b 	andseq	sl, ip, fp, lsl #30
    4134:	810b2d00 	tsthi	fp, r0, lsl #26
    4138:	2e000027 	cdpcs	0, 0, cr0, cr0, cr7, {1}
    413c:	0027950b 	eoreq	r9, r7, fp, lsl #10
    4140:	a90b2f00 	stmdbge	fp, {r8, r9, sl, fp, sp}
    4144:	30000027 	andcc	r0, r0, r7, lsr #32
    4148:	001ea30b 	andseq	sl, lr, fp, lsl #6
    414c:	7d0b3100 	stfvcs	f3, [fp, #-0]
    4150:	3200001e 	andcc	r0, r0, #30
    4154:	0021a50b 	eoreq	sl, r1, fp, lsl #10
    4158:	770b3300 	strvc	r3, [fp, -r0, lsl #6]
    415c:	34000023 	strcc	r0, [r0], #-35	; 0xffffffdd
    4160:	0029860b 	eoreq	r8, r9, fp, lsl #12
    4164:	cc0b3500 	cfstr32gt	mvfx3, [fp], {-0}
    4168:	36000019 			; <UNDEFINED> instruction: 0x36000019
    416c:	001fa30b 	andseq	sl, pc, fp, lsl #6
    4170:	b80b3700 	stmdalt	fp, {r8, r9, sl, ip, sp}
    4174:	3800001f 	stmdacc	r0, {r0, r1, r2, r3, r4}
    4178:	0022070b 	eoreq	r0, r2, fp, lsl #14
    417c:	310b3900 	tstcc	fp, r0, lsl #18
    4180:	3a000022 	bcc	4210 <CPSR_IRQ_INHIBIT+0x4190>
    4184:	0029af0b 	eoreq	sl, r9, fp, lsl #30
    4188:	660b3b00 	strvs	r3, [fp], -r0, lsl #22
    418c:	3c000024 	stccc	0, cr0, [r0], {36}	; 0x24
    4190:	001f460b 	andseq	r4, pc, fp, lsl #12
    4194:	8b0b3d00 	blhi	2d359c <_bss_end+0x2c7a2c>
    4198:	3e00001a 	mcrcc	0, 0, r0, cr0, cr10, {0}
    419c:	001a490b 	andseq	r4, sl, fp, lsl #18
    41a0:	c30b3f00 	movwgt	r3, #48896	; 0xbf00
    41a4:	40000023 	andmi	r0, r0, r3, lsr #32
    41a8:	0024e70b 	eoreq	lr, r4, fp, lsl #14
    41ac:	fa0b4100 	blx	2d45b4 <_bss_end+0x2c8a44>
    41b0:	42000025 	andmi	r0, r0, #37	; 0x25
    41b4:	00221c0b 	eoreq	r1, r2, fp, lsl #24
    41b8:	e80b4300 	stmda	fp, {r8, r9, lr}
    41bc:	44000029 	strmi	r0, [r0], #-41	; 0xffffffd7
    41c0:	0024910b 	eoreq	r9, r4, fp, lsl #2
    41c4:	760b4500 	strvc	r4, [fp], -r0, lsl #10
    41c8:	4600001c 			; <UNDEFINED> instruction: 0x4600001c
    41cc:	0022f70b 	eoreq	pc, r2, fp, lsl #14
    41d0:	2a0b4700 	bcs	2d5dd8 <_bss_end+0x2ca268>
    41d4:	48000021 	stmdami	r0, {r0, r5}
    41d8:	001a080b 	andseq	r0, sl, fp, lsl #16
    41dc:	1c0b4900 			; <UNDEFINED> instruction: 0x1c0b4900
    41e0:	4a00001b 	bmi	4254 <CPSR_IRQ_INHIBIT+0x41d4>
    41e4:	001f5a0b 	andseq	r5, pc, fp, lsl #20
    41e8:	580b4b00 	stmdapl	fp, {r8, r9, fp, lr}
    41ec:	4c000022 	stcmi	0, cr0, [r0], {34}	; 0x22
    41f0:	07020300 	streq	r0, [r2, -r0, lsl #6]
    41f4:	00000502 	andeq	r0, r0, r2, lsl #10
    41f8:	0003e40c 	andeq	lr, r3, ip, lsl #8
    41fc:	0003d900 	andeq	sp, r3, r0, lsl #18
    4200:	0e000d00 	cdpeq	13, 0, cr0, cr0, cr0, {0}
    4204:	000003ce 	andeq	r0, r0, lr, asr #7
    4208:	03f00405 	mvnseq	r0, #83886080	; 0x5000000
    420c:	de0e0000 	cdple	0, 0, cr0, cr14, cr0, {0}
    4210:	03000003 	movweq	r0, #3
    4214:	04a00801 	strteq	r0, [r0], #2049	; 0x801
    4218:	e90e0000 	stmdb	lr, {}	; <UNPREDICTABLE>
    421c:	0f000003 	svceq	0x00000003
    4220:	00001bc0 	andeq	r1, r0, r0, asr #23
    4224:	1a014c04 	bne	5723c <_bss_end+0x4b6cc>
    4228:	000003d9 	ldrdeq	r0, [r0], -r9
    422c:	001fde0f 	andseq	sp, pc, pc, lsl #28
    4230:	01820400 	orreq	r0, r2, r0, lsl #8
    4234:	0003d91a 	andeq	sp, r3, sl, lsl r9
    4238:	03e90c00 	mvneq	r0, #0, 24
    423c:	041a0000 	ldreq	r0, [sl], #-0
    4240:	000d0000 	andeq	r0, sp, r0
    4244:	0021c909 	eoreq	ip, r1, r9, lsl #18
    4248:	0d2d0500 	cfstr32eq	mvfx0, [sp, #-0]
    424c:	0000040f 	andeq	r0, r0, pc, lsl #8
    4250:	00285109 	eoreq	r5, r8, r9, lsl #2
    4254:	1c380500 	cfldr32ne	mvfx0, [r8], #-0
    4258:	000001e6 	andeq	r0, r0, r6, ror #3
    425c:	001eb70a 	andseq	fp, lr, sl, lsl #14
    4260:	93010700 	movwls	r0, #5888	; 0x1700
    4264:	05000000 	streq	r0, [r0, #-0]
    4268:	04a50e3a 	strteq	r0, [r5], #3642	; 0xe3a
    426c:	1d0b0000 	stcne	0, cr0, [fp, #-0]
    4270:	0000001a 	andeq	r0, r0, sl, lsl r0
    4274:	0020c90b 	eoreq	ip, r0, fp, lsl #18
    4278:	630b0100 	movwvs	r0, #45312	; 0xb100
    427c:	02000029 	andeq	r0, r0, #41	; 0x29
    4280:	0029260b 	eoreq	r2, r9, fp, lsl #12
    4284:	200b0300 	andcs	r0, fp, r0, lsl #6
    4288:	04000024 	streq	r0, [r0], #-36	; 0xffffffdc
    428c:	0026e10b 	eoreq	lr, r6, fp, lsl #2
    4290:	030b0500 	movweq	r0, #46336	; 0xb500
    4294:	0600001c 			; <UNDEFINED> instruction: 0x0600001c
    4298:	001be50b 	andseq	lr, fp, fp, lsl #10
    429c:	fe0b0700 	cdp2	7, 0, cr0, cr11, cr0, {0}
    42a0:	0800001d 	stmdaeq	r0, {r0, r2, r3, r4}
    42a4:	0022dc0b 	eoreq	sp, r2, fp, lsl #24
    42a8:	0a0b0900 	beq	2c66b0 <_bss_end+0x2bab40>
    42ac:	0a00001c 	beq	4324 <CPSR_IRQ_INHIBIT+0x42a4>
    42b0:	0022e30b 	eoreq	lr, r2, fp, lsl #6
    42b4:	6f0b0b00 	svcvs	0x000b0b00
    42b8:	0c00001c 	stceq	0, cr0, [r0], {28}
    42bc:	001bfc0b 	andseq	pc, fp, fp, lsl #24
    42c0:	380b0d00 	stmdacc	fp, {r8, sl, fp}
    42c4:	0e000027 	cdpeq	0, 0, cr0, cr0, cr7, {1}
    42c8:	0025050b 	eoreq	r0, r5, fp, lsl #10
    42cc:	04000f00 	streq	r0, [r0], #-3840	; 0xfffff100
    42d0:	00002630 	andeq	r2, r0, r0, lsr r6
    42d4:	32013f05 	andcc	r3, r1, #5, 30
    42d8:	09000004 	stmdbeq	r0, {r2}
    42dc:	000026c4 	andeq	r2, r0, r4, asr #13
    42e0:	a50f4105 	strge	r4, [pc, #-261]	; 41e3 <CPSR_IRQ_INHIBIT+0x4163>
    42e4:	09000004 	stmdbeq	r0, {r2}
    42e8:	0000274c 	andeq	r2, r0, ip, asr #14
    42ec:	1d0c4a05 	vstrne	s8, [ip, #-20]	; 0xffffffec
    42f0:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
    42f4:	00001ba4 	andeq	r1, r0, r4, lsr #23
    42f8:	1d0c4b05 	vstrne	d4, [ip, #-20]	; 0xffffffec
    42fc:	10000000 	andne	r0, r0, r0
    4300:	00002825 	andeq	r2, r0, r5, lsr #16
    4304:	00275d09 	eoreq	r5, r7, r9, lsl #26
    4308:	144c0500 	strbne	r0, [ip], #-1280	; 0xfffffb00
    430c:	000004e6 	andeq	r0, r0, r6, ror #9
    4310:	04d50405 	ldrbeq	r0, [r5], #1029	; 0x405
    4314:	09110000 	ldmdbeq	r1, {}	; <UNPREDICTABLE>
    4318:	00002093 	muleq	r0, r3, r0
    431c:	f90f4e05 			; <UNDEFINED> instruction: 0xf90f4e05
    4320:	05000004 	streq	r0, [r0, #-4]
    4324:	0004ec04 	andeq	lr, r4, r4, lsl #24
    4328:	26461200 	strbcs	r1, [r6], -r0, lsl #4
    432c:	0d090000 	stceq	0, cr0, [r9, #-0]
    4330:	05000024 	streq	r0, [r0, #-36]	; 0xffffffdc
    4334:	05100d52 	ldreq	r0, [r0, #-3410]	; 0xfffff2ae
    4338:	04050000 	streq	r0, [r5], #-0
    433c:	000004ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    4340:	001d1b13 	andseq	r1, sp, r3, lsl fp
    4344:	67053400 	strvs	r3, [r5, -r0, lsl #8]
    4348:	05411501 	strbeq	r1, [r1, #-1281]	; 0xfffffaff
    434c:	d2140000 	andsle	r0, r4, #0
    4350:	05000021 	streq	r0, [r0, #-33]	; 0xffffffdf
    4354:	de0f0169 	adfleez	f0, f7, #1.0
    4358:	00000003 	andeq	r0, r0, r3
    435c:	001cff14 	andseq	pc, ip, r4, lsl pc	; <UNPREDICTABLE>
    4360:	016a0500 	cmneq	sl, r0, lsl #10
    4364:	00054614 	andeq	r4, r5, r4, lsl r6
    4368:	0e000400 	cfcpyseq	mvf0, mvf0
    436c:	00000516 	andeq	r0, r0, r6, lsl r5
    4370:	0000b90c 	andeq	fp, r0, ip, lsl #18
    4374:	00055600 	andeq	r5, r5, r0, lsl #12
    4378:	00241500 	eoreq	r1, r4, r0, lsl #10
    437c:	002d0000 	eoreq	r0, sp, r0
    4380:	0005410c 	andeq	r4, r5, ip, lsl #2
    4384:	00056100 	andeq	r6, r5, r0, lsl #2
    4388:	0e000d00 	cdpeq	13, 0, cr0, cr0, cr0, {0}
    438c:	00000556 	andeq	r0, r0, r6, asr r5
    4390:	0021010f 	eoreq	r0, r1, pc, lsl #2
    4394:	016b0500 	cmneq	fp, r0, lsl #10
    4398:	00056103 	andeq	r6, r5, r3, lsl #2
    439c:	23470f00 	movtcs	r0, #32512	; 0x7f00
    43a0:	6e050000 	cdpvs	0, 0, cr0, cr5, cr0, {0}
    43a4:	001d0c01 	andseq	r0, sp, r1, lsl #24
    43a8:	84160000 	ldrhi	r0, [r6], #-0
    43ac:	07000026 	streq	r0, [r0, -r6, lsr #32]
    43b0:	00009301 	andeq	r9, r0, r1, lsl #6
    43b4:	01810500 	orreq	r0, r1, r0, lsl #10
    43b8:	00062a06 	andeq	r2, r6, r6, lsl #20
    43bc:	1ab20b00 	bne	fec86fc4 <_bss_end+0xfec7b454>
    43c0:	0b000000 	bleq	43c8 <CPSR_IRQ_INHIBIT+0x4348>
    43c4:	00001abe 			; <UNDEFINED> instruction: 0x00001abe
    43c8:	1aca0b02 	bne	ff286fd8 <_bss_end+0xff27b468>
    43cc:	0b030000 	bleq	c43d4 <_bss_end+0xb8864>
    43d0:	00001ee3 	andeq	r1, r0, r3, ror #29
    43d4:	1ad60b03 	bne	ff586fe8 <_bss_end+0xff57b478>
    43d8:	0b040000 	bleq	1043e0 <_bss_end+0xf8870>
    43dc:	0000202c 	andeq	r2, r0, ip, lsr #32
    43e0:	21120b04 	tstcs	r2, r4, lsl #22
    43e4:	0b050000 	bleq	1443ec <_bss_end+0x13887c>
    43e8:	00002068 	andeq	r2, r0, r8, rrx
    43ec:	1b950b05 	blne	fe547008 <_bss_end+0xfe53b498>
    43f0:	0b050000 	bleq	1443f8 <_bss_end+0x138888>
    43f4:	00001ae2 	andeq	r1, r0, r2, ror #21
    43f8:	22900b06 	addscs	r0, r0, #6144	; 0x1800
    43fc:	0b060000 	bleq	184404 <_bss_end+0x178894>
    4400:	00001cf1 	strdeq	r1, [r0], -r1	; <UNPREDICTABLE>
    4404:	229d0b06 	addscs	r0, sp, #6144	; 0x1800
    4408:	0b060000 	bleq	184410 <_bss_end+0x1788a0>
    440c:	00002704 	andeq	r2, r0, r4, lsl #14
    4410:	22aa0b06 	adccs	r0, sl, #6144	; 0x1800
    4414:	0b060000 	bleq	18441c <_bss_end+0x1788ac>
    4418:	000022ea 	andeq	r2, r0, sl, ror #5
    441c:	1aee0b06 	bne	ffb8703c <_bss_end+0xffb7b4cc>
    4420:	0b070000 	bleq	1c4428 <_bss_end+0x1b88b8>
    4424:	000023f0 	strdeq	r2, [r0], -r0
    4428:	243d0b07 	ldrtcs	r0, [sp], #-2823	; 0xfffff4f9
    442c:	0b070000 	bleq	1c4434 <_bss_end+0x1b88c4>
    4430:	0000273f 	andeq	r2, r0, pc, lsr r7
    4434:	1cc40b07 	fstmiaxne	r4, {d16-d18}	;@ Deprecated
    4438:	0b070000 	bleq	1c4440 <_bss_end+0x1b88d0>
    443c:	000024be 			; <UNDEFINED> instruction: 0x000024be
    4440:	1a670b08 	bne	19c7068 <_bss_end+0x19bb4f8>
    4444:	0b080000 	bleq	20444c <_bss_end+0x1f88dc>
    4448:	00002712 	andeq	r2, r0, r2, lsl r7
    444c:	24da0b08 	ldrbcs	r0, [sl], #2824	; 0xb08
    4450:	00080000 	andeq	r0, r8, r0
    4454:	0029780f 	eoreq	r7, r9, pc, lsl #16
    4458:	019f0500 	orrseq	r0, pc, r0, lsl #10
    445c:	0005801f 	andeq	r8, r5, pc, lsl r0
    4460:	250c0f00 	strcs	r0, [ip, #-3840]	; 0xfffff100
    4464:	a2050000 	andge	r0, r5, #0
    4468:	001d0c01 	andseq	r0, sp, r1, lsl #24
    446c:	1f0f0000 	svcne	0x000f0000
    4470:	05000021 	streq	r0, [r0, #-33]	; 0xffffffdf
    4474:	1d0c01a5 	stfnes	f0, [ip, #-660]	; 0xfffffd6c
    4478:	0f000000 	svceq	0x00000000
    447c:	00002a44 	andeq	r2, r0, r4, asr #20
    4480:	0c01a805 	stceq	8, cr10, [r1], {5}
    4484:	0000001d 	andeq	r0, r0, sp, lsl r0
    4488:	001bb40f 	andseq	fp, fp, pc, lsl #8
    448c:	01ab0500 			; <UNDEFINED> instruction: 0x01ab0500
    4490:	00001d0c 	andeq	r1, r0, ip, lsl #26
    4494:	25160f00 	ldrcs	r0, [r6, #-3840]	; 0xfffff100
    4498:	ae050000 	cdpge	0, 0, cr0, cr5, cr0, {0}
    449c:	001d0c01 	andseq	r0, sp, r1, lsl #24
    44a0:	270f0000 	strcs	r0, [pc, -r0]
    44a4:	05000024 	streq	r0, [r0, #-36]	; 0xffffffdc
    44a8:	1d0c01b1 	stfnes	f0, [ip, #-708]	; 0xfffffd3c
    44ac:	0f000000 	svceq	0x00000000
    44b0:	00002432 	andeq	r2, r0, r2, lsr r4
    44b4:	0c01b405 	cfstrseq	mvf11, [r1], {5}
    44b8:	0000001d 	andeq	r0, r0, sp, lsl r0
    44bc:	0025200f 	eoreq	r2, r5, pc
    44c0:	01b70500 			; <UNDEFINED> instruction: 0x01b70500
    44c4:	00001d0c 	andeq	r1, r0, ip, lsl #26
    44c8:	226c0f00 	rsbcs	r0, ip, #0, 30
    44cc:	ba050000 	blt	1444d4 <_bss_end+0x138964>
    44d0:	001d0c01 	andseq	r0, sp, r1, lsl #24
    44d4:	a30f0000 	movwge	r0, #61440	; 0xf000
    44d8:	05000029 	streq	r0, [r0, #-41]	; 0xffffffd7
    44dc:	1d0c01bd 	stfnes	f0, [ip, #-756]	; 0xfffffd0c
    44e0:	0f000000 	svceq	0x00000000
    44e4:	0000252a 	andeq	r2, r0, sl, lsr #10
    44e8:	0c01c005 	stceq	0, cr12, [r1], {5}
    44ec:	0000001d 	andeq	r0, r0, sp, lsl r0
    44f0:	002a670f 	eoreq	r6, sl, pc, lsl #14
    44f4:	01c30500 	biceq	r0, r3, r0, lsl #10
    44f8:	00001d0c 	andeq	r1, r0, ip, lsl #26
    44fc:	292d0f00 	pushcs	{r8, r9, sl, fp}
    4500:	c6050000 	strgt	r0, [r5], -r0
    4504:	001d0c01 	andseq	r0, sp, r1, lsl #24
    4508:	390f0000 	stmdbcc	pc, {}	; <UNPREDICTABLE>
    450c:	05000029 	streq	r0, [r0, #-41]	; 0xffffffd7
    4510:	1d0c01c9 	stfnes	f0, [ip, #-804]	; 0xfffffcdc
    4514:	0f000000 	svceq	0x00000000
    4518:	00002945 	andeq	r2, r0, r5, asr #18
    451c:	0c01cc05 	stceq	12, cr12, [r1], {5}
    4520:	0000001d 	andeq	r0, r0, sp, lsl r0
    4524:	00296a0f 	eoreq	r6, r9, pc, lsl #20
    4528:	01d00500 	bicseq	r0, r0, r0, lsl #10
    452c:	00001d0c 	andeq	r1, r0, ip, lsl #26
    4530:	2a5a0f00 	bcs	1688138 <_bss_end+0x167c5c8>
    4534:	d3050000 	movwle	r0, #20480	; 0x5000
    4538:	001d0c01 	andseq	r0, sp, r1, lsl #24
    453c:	110f0000 	mrsne	r0, CPSR
    4540:	0500001c 	streq	r0, [r0, #-28]	; 0xffffffe4
    4544:	1d0c01d6 	stfnes	f0, [ip, #-856]	; 0xfffffca8
    4548:	0f000000 	svceq	0x00000000
    454c:	000019f8 	strdeq	r1, [r0], -r8
    4550:	0c01d905 			; <UNDEFINED> instruction: 0x0c01d905
    4554:	0000001d 	andeq	r0, r0, sp, lsl r0
    4558:	001f030f 	andseq	r0, pc, pc, lsl #6
    455c:	01dc0500 	bicseq	r0, ip, r0, lsl #10
    4560:	00001d0c 	andeq	r1, r0, ip, lsl #26
    4564:	1bec0f00 	blne	ffb0816c <_bss_end+0xffafc5fc>
    4568:	df050000 	svcle	0x00050000
    456c:	001d0c01 	andseq	r0, sp, r1, lsl #24
    4570:	400f0000 	andmi	r0, pc, r0
    4574:	05000025 	streq	r0, [r0, #-37]	; 0xffffffdb
    4578:	1d0c01e2 	stfnes	f0, [ip, #-904]	; 0xfffffc78
    457c:	0f000000 	svceq	0x00000000
    4580:	00002148 	andeq	r2, r0, r8, asr #2
    4584:	0c01e505 	cfstr32eq	mvfx14, [r1], {5}
    4588:	0000001d 	andeq	r0, r0, sp, lsl r0
    458c:	0023a00f 	eoreq	sl, r3, pc
    4590:	01e80500 	mvneq	r0, r0, lsl #10
    4594:	00001d0c 	andeq	r1, r0, ip, lsl #26
    4598:	285a0f00 	ldmdacs	sl, {r8, r9, sl, fp}^
    459c:	ef050000 	svc	0x00050000
    45a0:	001d0c01 	andseq	r0, sp, r1, lsl #24
    45a4:	120f0000 	andne	r0, pc, #0
    45a8:	0500002a 	streq	r0, [r0, #-42]	; 0xffffffd6
    45ac:	1d0c01f2 	stfnes	f0, [ip, #-968]	; 0xfffffc38
    45b0:	0f000000 	svceq	0x00000000
    45b4:	00002a22 	andeq	r2, r0, r2, lsr #20
    45b8:	0c01f505 	cfstr32eq	mvfx15, [r1], {5}
    45bc:	0000001d 	andeq	r0, r0, sp, lsl r0
    45c0:	001d080f 	andseq	r0, sp, pc, lsl #16
    45c4:	01f80500 	mvnseq	r0, r0, lsl #10
    45c8:	00001d0c 	andeq	r1, r0, ip, lsl #26
    45cc:	28a10f00 	stmiacs	r1!, {r8, r9, sl, fp}
    45d0:	fb050000 	blx	1445da <_bss_end+0x138a6a>
    45d4:	001d0c01 	andseq	r0, sp, r1, lsl #24
    45d8:	a60f0000 	strge	r0, [pc], -r0
    45dc:	05000024 	streq	r0, [r0, #-36]	; 0xffffffdc
    45e0:	1d0c01fe 	stfnes	f0, [ip, #-1016]	; 0xfffffc08
    45e4:	0f000000 	svceq	0x00000000
    45e8:	00001f7c 	andeq	r1, r0, ip, ror pc
    45ec:	0c020205 	sfmeq	f0, 4, [r2], {5}
    45f0:	0000001d 	andeq	r0, r0, sp, lsl r0
    45f4:	0026960f 	eoreq	r9, r6, pc, lsl #12
    45f8:	020a0500 	andeq	r0, sl, #0, 10
    45fc:	00001d0c 	andeq	r1, r0, ip, lsl #26
    4600:	1e6f0f00 	cdpne	15, 6, cr0, cr15, cr0, {0}
    4604:	0d050000 	stceq	0, cr0, [r5, #-0]
    4608:	001d0c02 	andseq	r0, sp, r2, lsl #24
    460c:	1d0c0000 	stcne	0, cr0, [ip, #-0]
    4610:	ef000000 	svc	0x00000000
    4614:	0d000007 	stceq	0, cr0, [r0, #-28]	; 0xffffffe4
    4618:	20480f00 	subcs	r0, r8, r0, lsl #30
    461c:	fb050000 	blx	144626 <_bss_end+0x138ab6>
    4620:	07e40c03 	strbeq	r0, [r4, r3, lsl #24]!
    4624:	e60c0000 	str	r0, [ip], -r0
    4628:	0c000004 	stceq	0, cr0, [r0], {4}
    462c:	15000008 	strne	r0, [r0, #-8]
    4630:	00000024 	andeq	r0, r0, r4, lsr #32
    4634:	630f000d 	movwvs	r0, #61453	; 0xf00d
    4638:	05000025 	streq	r0, [r0, #-37]	; 0xffffffdb
    463c:	fc140584 	ldc2	5, cr0, [r4], {132}	; 0x84
    4640:	16000007 	strne	r0, [r0], -r7
    4644:	0000210a 	andeq	r2, r0, sl, lsl #2
    4648:	00930107 	addseq	r0, r3, r7, lsl #2
    464c:	8b050000 	blhi	144654 <_bss_end+0x138ae4>
    4650:	08570605 	ldmdaeq	r7, {r0, r2, r9, sl}^
    4654:	c50b0000 	strgt	r0, [fp, #-0]
    4658:	0000001e 	andeq	r0, r0, lr, lsl r0
    465c:	0023150b 	eoreq	r1, r3, fp, lsl #10
    4660:	9d0b0100 	stflss	f0, [fp, #-0]
    4664:	0200001a 	andeq	r0, r0, #26
    4668:	0029d40b 	eoreq	sp, r9, fp, lsl #8
    466c:	dd0b0300 	stcle	3, cr0, [fp, #-0]
    4670:	04000025 	streq	r0, [r0], #-37	; 0xffffffdb
    4674:	0025d00b 	eoreq	sp, r5, fp
    4678:	740b0500 	strvc	r0, [fp], #-1280	; 0xfffffb00
    467c:	0600001b 			; <UNDEFINED> instruction: 0x0600001b
    4680:	29c40f00 	stmibcs	r4, {r8, r9, sl, fp}^
    4684:	98050000 	stmdals	r5, {}	; <UNPREDICTABLE>
    4688:	08191505 	ldmdaeq	r9, {r0, r2, r8, sl, ip}
    468c:	c60f0000 	strgt	r0, [pc], -r0
    4690:	05000028 	streq	r0, [r0, #-40]	; 0xffffffd8
    4694:	24110799 	ldrcs	r0, [r1], #-1945	; 0xfffff867
    4698:	0f000000 	svceq	0x00000000
    469c:	00002550 	andeq	r2, r0, r0, asr r5
    46a0:	0c07ae05 	stceq	14, cr10, [r7], {5}
    46a4:	0000001d 	andeq	r0, r0, sp, lsl r0
    46a8:	00283904 	eoreq	r3, r8, r4, lsl #18
    46ac:	167b0600 	ldrbtne	r0, [fp], -r0, lsl #12
    46b0:	00000093 	muleq	r0, r3, r0
    46b4:	00087e0e 	andeq	r7, r8, lr, lsl #28
    46b8:	05020300 	streq	r0, [r2, #-768]	; 0xfffffd00
    46bc:	00000280 	andeq	r0, r0, r0, lsl #5
    46c0:	58070803 	stmdapl	r7, {r0, r1, fp}
    46c4:	0300001e 	movweq	r0, #30
    46c8:	1c2c0404 	cfstrsne	mvf0, [ip], #-16
    46cc:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    46d0:	001c2403 	andseq	r2, ip, r3, lsl #8
    46d4:	04080300 	streq	r0, [r8], #-768	; 0xfffffd00
    46d8:	00002539 	andeq	r2, r0, r9, lsr r5
    46dc:	eb031003 	bl	c86f0 <_bss_end+0xbcb80>
    46e0:	0c000025 	stceq	0, cr0, [r0], {37}	; 0x25
    46e4:	0000088a 	andeq	r0, r0, sl, lsl #17
    46e8:	000008c9 	andeq	r0, r0, r9, asr #17
    46ec:	00002415 	andeq	r2, r0, r5, lsl r4
    46f0:	0e00ff00 	cdpeq	15, 0, cr15, cr0, cr0, {0}
    46f4:	000008b9 			; <UNDEFINED> instruction: 0x000008b9
    46f8:	00244a0f 	eoreq	r4, r4, pc, lsl #20
    46fc:	01fc0600 	mvnseq	r0, r0, lsl #12
    4700:	0008c916 	andeq	ip, r8, r6, lsl r9
    4704:	1bdb0f00 	blne	ff6c830c <_bss_end+0xff6bc79c>
    4708:	02060000 	andeq	r0, r6, #0
    470c:	08c91602 	stmiaeq	r9, {r1, r9, sl, ip}^
    4710:	6c040000 	stcvs	0, cr0, [r4], {-0}
    4714:	07000028 	streq	r0, [r0, -r8, lsr #32]
    4718:	04f9102a 	ldrbteq	r1, [r9], #42	; 0x2a
    471c:	e80c0000 	stmda	ip, {}	; <UNPREDICTABLE>
    4720:	ff000008 			; <UNDEFINED> instruction: 0xff000008
    4724:	0d000008 	stceq	0, cr0, [r0, #-32]	; 0xffffffe0
    4728:	18120900 	ldmdane	r2, {r8, fp}
    472c:	2f070000 	svccs	0x00070000
    4730:	0008f411 	andeq	pc, r8, r1, lsl r4	; <UNPREDICTABLE>
    4734:	18440900 	stmdane	r4, {r8, fp}^
    4738:	30070000 	andcc	r0, r7, r0
    473c:	0008f411 	andeq	pc, r8, r1, lsl r4	; <UNPREDICTABLE>
    4740:	08ff1700 	ldmeq	pc!, {r8, r9, sl, ip}^	; <UNPREDICTABLE>
    4744:	33080000 	movwcc	r0, #32768	; 0x8000
    4748:	03050a09 	movweq	r0, #23049	; 0x5a09
    474c:	0000aaf8 	strdeq	sl, [r0], -r8
    4750:	00090b17 	andeq	r0, r9, r7, lsl fp
    4754:	09340800 	ldmdbeq	r4!, {fp}
    4758:	1403050a 	strne	r0, [r3], #-1290	; 0xfffffaf6
    475c:	000000ab 	andeq	r0, r0, fp, lsr #1

Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
       0:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
       4:	030b130e 	movweq	r1, #45838	; 0xb30e
       8:	110e1b0e 	tstne	lr, lr, lsl #22
       c:	10061201 	andne	r1, r6, r1, lsl #4
      10:	02000017 	andeq	r0, r0, #23
      14:	193f002e 	ldmdbne	pc!, {r1, r2, r3, r5}	; <UNPREDICTABLE>
      18:	0b3a0e03 	bleq	e8382c <_bss_end+0xe77cbc>
      1c:	0b390b3b 	bleq	e42d10 <_bss_end+0xe371a0>
      20:	06120111 			; <UNDEFINED> instruction: 0x06120111
      24:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
      28:	03000019 	movweq	r0, #25
      2c:	0e030139 	mcreq	1, 0, r0, cr3, cr9, {1}
      30:	0b3b0b3a 	bleq	ec2d20 <_bss_end+0xeb71b0>
      34:	00001301 	andeq	r1, r0, r1, lsl #6
      38:	3f012e04 	svccc	0x00012e04
      3c:	3a0e0319 	bcc	380ca8 <_bss_end+0x375138>
      40:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
      44:	01193c0b 	tsteq	r9, fp, lsl #24
      48:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
      4c:	13490005 	movtne	r0, #36869	; 0x9005
      50:	16060000 	strne	r0, [r6], -r0
      54:	3a0e0300 	bcc	380c5c <_bss_end+0x3750ec>
      58:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
      5c:	0013490b 	andseq	r4, r3, fp, lsl #18
      60:	012e0700 			; <UNDEFINED> instruction: 0x012e0700
      64:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
      68:	0b3b0b3a 	bleq	ec2d58 <_bss_end+0xeb71e8>
      6c:	13490b39 	movtne	r0, #39737	; 0x9b39
      70:	0000193c 	andeq	r1, r0, ip, lsr r9
      74:	0b000f08 	bleq	3c9c <CPSR_IRQ_INHIBIT+0x3c1c>
      78:	0013490b 	andseq	r4, r3, fp, lsl #18
      7c:	00240900 	eoreq	r0, r4, r0, lsl #18
      80:	0b3e0b0b 	bleq	f82cb4 <_bss_end+0xf77144>
      84:	00000e03 	andeq	r0, r0, r3, lsl #28
      88:	47012e0a 	strmi	r2, [r1, -sl, lsl #28]
      8c:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
      90:	97184006 	ldrls	r4, [r8, -r6]
      94:	13011942 	movwne	r1, #6466	; 0x1942
      98:	050b0000 	streq	r0, [fp, #-0]
      9c:	02134900 	andseq	r4, r3, #0, 18
      a0:	0c000018 	stceq	0, cr0, [r0], {24}
      a4:	08030005 	stmdaeq	r3, {r0, r2}
      a8:	0b3b0b3a 	bleq	ec2d98 <_bss_end+0xeb7228>
      ac:	13490b39 	movtne	r0, #39737	; 0x9b39
      b0:	00001802 	andeq	r1, r0, r2, lsl #16
      b4:	0b00240d 	bleq	90f0 <_ZN21CInterrupt_ControllerC1Em+0x20>
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
      e4:	0b0b0024 	bleq	2c017c <_bss_end+0x2b460c>
      e8:	0e030b3e 	vmoveq.16	d3[0], r0
      ec:	24030000 	strcs	r0, [r3], #-0
      f0:	3e0b0b00 	vmlacc.f64	d0, d11, d0
      f4:	0008030b 	andeq	r0, r8, fp, lsl #6
      f8:	00160400 	andseq	r0, r6, r0, lsl #8
      fc:	0b3a0e03 	bleq	e83910 <_bss_end+0xe77da0>
     100:	0b390b3b 	bleq	e42df4 <_bss_end+0xe37284>
     104:	00001349 	andeq	r1, r0, r9, asr #6
     108:	49002605 	stmdbmi	r0, {r0, r2, r9, sl, sp}
     10c:	06000013 			; <UNDEFINED> instruction: 0x06000013
     110:	13490035 	movtne	r0, #36917	; 0x9035
     114:	39070000 	stmdbcc	r7, {}	; <UNPREDICTABLE>
     118:	3a080301 	bcc	200d24 <_bss_end+0x1f51b4>
     11c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     120:	0013010b 	andseq	r0, r3, fp, lsl #2
     124:	00340800 	eorseq	r0, r4, r0, lsl #16
     128:	0b3a0e03 	bleq	e8393c <_bss_end+0xe77dcc>
     12c:	0b390b3b 	bleq	e42e20 <_bss_end+0xe372b0>
     130:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
     134:	196c061c 	stmdbne	ip!, {r2, r3, r4, r9, sl}^
     138:	34090000 	strcc	r0, [r9], #-0
     13c:	3a0e0300 	bcc	380d44 <_bss_end+0x3751d4>
     140:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     144:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
     148:	6c0b1c19 	stcvs	12, cr1, [fp], {25}
     14c:	0a000019 	beq	1b8 <CPSR_IRQ_INHIBIT+0x138>
     150:	0e030104 	adfeqs	f0, f3, f4
     154:	0b3e196d 	bleq	f86710 <_bss_end+0xf7aba0>
     158:	13490b0b 	movtne	r0, #39691	; 0x9b0b
     15c:	0b3b0b3a 	bleq	ec2e4c <_bss_end+0xeb72dc>
     160:	13010b39 	movwne	r0, #6969	; 0x1b39
     164:	280b0000 	stmdacs	fp, {}	; <UNPREDICTABLE>
     168:	1c0e0300 	stcne	3, cr0, [lr], {-0}
     16c:	0c00000b 	stceq	0, cr0, [r0], {11}
     170:	13470034 	movtne	r0, #28724	; 0x7034
     174:	020d0000 	andeq	r0, sp, #0
     178:	0b0e0301 	bleq	380d84 <_bss_end+0x375214>
     17c:	3b0b3a0b 	blcc	2ce9b0 <_bss_end+0x2c2e40>
     180:	010b390b 	tsteq	fp, fp, lsl #18
     184:	0e000013 	mcreq	0, 0, r0, cr0, cr3, {0}
     188:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
     18c:	0b3b0b3a 	bleq	ec2e7c <_bss_end+0xeb730c>
     190:	13490b39 	movtne	r0, #39737	; 0x9b39
     194:	00000b38 	andeq	r0, r0, r8, lsr fp
     198:	3f012e0f 	svccc	0x00012e0f
     19c:	3a0e0319 	bcc	380e08 <_bss_end+0x375298>
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
     1c8:	0b3a0e03 	bleq	e839dc <_bss_end+0xe77e6c>
     1cc:	0b390b3b 	bleq	e42ec0 <_bss_end+0xe37350>
     1d0:	0b320e6e 	bleq	c83b90 <_bss_end+0xc78020>
     1d4:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
     1d8:	00001301 	andeq	r1, r0, r1, lsl #6
     1dc:	3f012e13 	svccc	0x00012e13
     1e0:	3a0e0319 	bcc	380e4c <_bss_end+0x3752dc>
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
     20c:	0b3b0b3a 	bleq	ec2efc <_bss_end+0xeb738c>
     210:	13490b39 	movtne	r0, #39737	; 0x9b39
     214:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
     218:	34170000 	ldrcc	r0, [r7], #-0
     21c:	3a134700 	bcc	4d1e24 <_bss_end+0x4c62b4>
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
     254:	0b3b0b3a 	bleq	ec2f44 <_bss_end+0xeb73d4>
     258:	13490b39 	movtne	r0, #39737	; 0x9b39
     25c:	00001802 	andeq	r1, r0, r2, lsl #16
     260:	47012e1b 	smladmi	r1, fp, lr, r2
     264:	3b0b3a13 	blcc	2ceab8 <_bss_end+0x2c2f48>
     268:	640b390b 	strvs	r3, [fp], #-2315	; 0xfffff6f5
     26c:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
     270:	96184006 	ldrls	r4, [r8], -r6
     274:	13011942 	movwne	r1, #6466	; 0x1942
     278:	051c0000 	ldreq	r0, [ip, #-0]
     27c:	490e0300 	stmdbmi	lr, {r8, r9}
     280:	02193413 	andseq	r3, r9, #318767104	; 0x13000000
     284:	1d000018 	stcne	0, cr0, [r0, #-96]	; 0xffffffa0
     288:	08030005 	stmdaeq	r3, {r0, r2}
     28c:	0b3b0b3a 	bleq	ec2f7c <_bss_end+0xeb740c>
     290:	13490b39 	movtne	r0, #39737	; 0x9b39
     294:	00001802 	andeq	r1, r0, r2, lsl #16
     298:	0300341e 	movweq	r3, #1054	; 0x41e
     29c:	3b0b3a08 	blcc	2ceac4 <_bss_end+0x2c2f54>
     2a0:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     2a4:	00180213 	andseq	r0, r8, r3, lsl r2
     2a8:	00341f00 	eorseq	r1, r4, r0, lsl #30
     2ac:	0b3a0e03 	bleq	e83ac0 <_bss_end+0xe77f50>
     2b0:	0b390b3b 	bleq	e42fa4 <_bss_end+0xe37434>
     2b4:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
     2b8:	2e200000 	cdpcs	0, 2, cr0, cr0, cr0, {0}
     2bc:	3a134701 	bcc	4d1ec8 <_bss_end+0x4c6358>
     2c0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     2c4:	1113640b 	tstne	r3, fp, lsl #8
     2c8:	40061201 	andmi	r1, r6, r1, lsl #4
     2cc:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
     2d0:	00001301 	andeq	r1, r0, r1, lsl #6
     2d4:	47012e21 	strmi	r2, [r1, -r1, lsr #28]
     2d8:	3b0b3a13 	blcc	2ceb2c <_bss_end+0x2c2fbc>
     2dc:	640b390b 	strvs	r3, [fp], #-2315	; 0xfffff6f5
     2e0:	010b2013 	tsteq	fp, r3, lsl r0
     2e4:	22000013 	andcs	r0, r0, #19
     2e8:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
     2ec:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
     2f0:	05230000 	streq	r0, [r3, #-0]!
     2f4:	3a0e0300 	bcc	380efc <_bss_end+0x37538c>
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
     334:	0b0e0301 	bleq	380f40 <_bss_end+0x3753d0>
     338:	3b0b3a0b 	blcc	2ceb6c <_bss_end+0x2c2ffc>
     33c:	010b390b 	tsteq	fp, fp, lsl #18
     340:	03000013 	movweq	r0, #19
     344:	0e030104 	adfeqs	f0, f3, f4
     348:	0b3e196d 	bleq	f86904 <_bss_end+0xf7ad94>
     34c:	13490b0b 	movtne	r0, #39691	; 0x9b0b
     350:	0b3b0b3a 	bleq	ec3040 <_bss_end+0xeb74d0>
     354:	0b320b39 	bleq	c83040 <_bss_end+0xc774d0>
     358:	00001301 	andeq	r1, r0, r1, lsl #6
     35c:	03002804 	movweq	r2, #2052	; 0x804
     360:	000b1c08 	andeq	r1, fp, r8, lsl #24
     364:	00260500 	eoreq	r0, r6, r0, lsl #10
     368:	00001349 	andeq	r1, r0, r9, asr #6
     36c:	03011306 	movweq	r1, #4870	; 0x1306
     370:	3a0b0b0e 	bcc	2c2fb0 <_bss_end+0x2b7440>
     374:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     378:	0013010b 	andseq	r0, r3, fp, lsl #2
     37c:	000d0700 	andeq	r0, sp, r0, lsl #14
     380:	0b3a0803 	bleq	e82394 <_bss_end+0xe76824>
     384:	0b390b3b 	bleq	e43078 <_bss_end+0xe37508>
     388:	0b381349 	bleq	e050b4 <_bss_end+0xdf9544>
     38c:	0d080000 	stceq	0, cr0, [r8, #-0]
     390:	3a0e0300 	bcc	380f98 <_bss_end+0x375428>
     394:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     398:	3f13490b 	svccc	0x0013490b
     39c:	3c0b3219 	sfmcc	f3, 4, [fp], {25}
     3a0:	6c0b1c19 	stcvs	12, cr1, [fp], {25}
     3a4:	09000019 	stmdbeq	r0, {r0, r3, r4}
     3a8:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
     3ac:	0b3b0b3a 	bleq	ec309c <_bss_end+0xeb752c>
     3b0:	13490b39 	movtne	r0, #39737	; 0x9b39
     3b4:	0b32193f 	bleq	c868b8 <_bss_end+0xc7ad48>
     3b8:	196c193c 	stmdbne	ip!, {r2, r3, r4, r5, r8, fp, ip}^
     3bc:	2e0a0000 	cdpcs	0, 0, cr0, cr10, cr0, {0}
     3c0:	03193f01 	tsteq	r9, #1, 30
     3c4:	3b0b3a0e 	blcc	2cec04 <_bss_end+0x2c3094>
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
     3f0:	0b3a0e03 	bleq	e83c04 <_bss_end+0xe78094>
     3f4:	0b390b3b 	bleq	e430e8 <_bss_end+0xe37578>
     3f8:	0b320e6e 	bleq	c83db8 <_bss_end+0xc78248>
     3fc:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
     400:	00001301 	andeq	r1, r0, r1, lsl #6
     404:	3f012e0e 	svccc	0x00012e0e
     408:	3a0e0319 	bcc	381074 <_bss_end+0x375504>
     40c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     410:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
     414:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
     418:	01136419 	tsteq	r3, r9, lsl r4
     41c:	0f000013 	svceq	0x00000013
     420:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
     424:	0b3a0e03 	bleq	e83c38 <_bss_end+0xe780c8>
     428:	0b390b3b 	bleq	e4311c <_bss_end+0xe375ac>
     42c:	193c0e6e 	ldmdbne	ip!, {r1, r2, r3, r5, r6, r9, sl, fp}
     430:	13011364 	movwne	r1, #4964	; 0x1364
     434:	0d100000 	ldceq	0, cr0, [r0, #-0]
     438:	3a0e0300 	bcc	381040 <_bss_end+0x3754d0>
     43c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     440:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
     444:	1100000b 	tstne	r0, fp
     448:	0b0b0024 	bleq	2c04e0 <_bss_end+0x2b4970>
     44c:	0e030b3e 	vmoveq.16	d3[0], r0
     450:	0f120000 	svceq	0x00120000
     454:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
     458:	13000013 	movwne	r0, #19
     45c:	0b0b0010 	bleq	2c04a4 <_bss_end+0x2b4934>
     460:	00001349 	andeq	r1, r0, r9, asr #6
     464:	49003514 	stmdbmi	r0, {r2, r4, r8, sl, ip, sp}
     468:	15000013 	strne	r0, [r0, #-19]	; 0xffffffed
     46c:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
     470:	0b3b0b3a 	bleq	ec3160 <_bss_end+0xeb75f0>
     474:	13490b39 	movtne	r0, #39737	; 0x9b39
     478:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
     47c:	34160000 	ldrcc	r0, [r6], #-0
     480:	3a134700 	bcc	4d2088 <_bss_end+0x4c6518>
     484:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     488:	0018020b 	andseq	r0, r8, fp, lsl #4
     48c:	002e1700 	eoreq	r1, lr, r0, lsl #14
     490:	19340e03 	ldmdbne	r4!, {r0, r1, r9, sl, fp}
     494:	06120111 			; <UNDEFINED> instruction: 0x06120111
     498:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
     49c:	18000019 	stmdane	r0, {r0, r3, r4}
     4a0:	0e03012e 	adfeqsp	f0, f3, #0.5
     4a4:	01111934 	tsteq	r1, r4, lsr r9
     4a8:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
     4ac:	01194296 			; <UNDEFINED> instruction: 0x01194296
     4b0:	19000013 	stmdbne	r0, {r0, r1, r4}
     4b4:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
     4b8:	0b3b0b3a 	bleq	ec31a8 <_bss_end+0xeb7638>
     4bc:	13490b39 	movtne	r0, #39737	; 0x9b39
     4c0:	00001802 	andeq	r1, r0, r2, lsl #16
     4c4:	0b00241a 	bleq	9534 <_kernel_main+0x54>
     4c8:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
     4cc:	1b000008 	blne	4f4 <CPSR_IRQ_INHIBIT+0x474>
     4d0:	1347012e 	movtne	r0, #28974	; 0x712e
     4d4:	0b3b0b3a 	bleq	ec31c4 <_bss_end+0xeb7654>
     4d8:	13640b39 	cmnne	r4, #58368	; 0xe400
     4dc:	06120111 			; <UNDEFINED> instruction: 0x06120111
     4e0:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
     4e4:	00130119 	andseq	r0, r3, r9, lsl r1
     4e8:	00051c00 	andeq	r1, r5, r0, lsl #24
     4ec:	13490e03 	movtne	r0, #40451	; 0x9e03
     4f0:	18021934 	stmdane	r2, {r2, r4, r5, r8, fp, ip}
     4f4:	341d0000 	ldrcc	r0, [sp], #-0
     4f8:	3a080300 	bcc	201100 <_bss_end+0x1f5590>
     4fc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     500:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
     504:	1e000018 	mcrne	0, 0, r0, cr0, cr8, {0}
     508:	0111010b 	tsteq	r1, fp, lsl #2
     50c:	00000612 	andeq	r0, r0, r2, lsl r6
     510:	0300051f 	movweq	r0, #1311	; 0x51f
     514:	3b0b3a08 	blcc	2ced3c <_bss_end+0x2c31cc>
     518:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     51c:	00180213 	andseq	r0, r8, r3, lsl r2
     520:	00342000 	eorseq	r2, r4, r0
     524:	0b3a0e03 	bleq	e83d38 <_bss_end+0xe781c8>
     528:	0b390b3b 	bleq	e4321c <_bss_end+0xe376ac>
     52c:	196c1349 	stmdbne	ip!, {r0, r3, r6, r8, r9, ip}^
     530:	00001802 	andeq	r1, r0, r2, lsl #16
     534:	03003421 	movweq	r3, #1057	; 0x421
     538:	3b0b3a0e 	blcc	2ced78 <_bss_end+0x2c3208>
     53c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     540:	00180213 	andseq	r0, r8, r3, lsl r2
     544:	01012200 	mrseq	r2, R9_usr
     548:	13011349 	movwne	r1, #4937	; 0x1349
     54c:	21230000 			; <UNDEFINED> instruction: 0x21230000
     550:	2f134900 	svccs	0x00134900
     554:	2400000b 	strcs	r0, [r0], #-11
     558:	1347012e 	movtne	r0, #28974	; 0x712e
     55c:	0b3b0b3a 	bleq	ec324c <_bss_end+0xeb76dc>
     560:	13640b39 	cmnne	r4, #58368	; 0xe400
     564:	06120111 			; <UNDEFINED> instruction: 0x06120111
     568:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
     56c:	00130119 	andseq	r0, r3, r9, lsl r1
     570:	010b2500 	tsteq	fp, r0, lsl #10
     574:	06120111 			; <UNDEFINED> instruction: 0x06120111
     578:	00001301 	andeq	r1, r0, r1, lsl #6
     57c:	47012e26 	strmi	r2, [r1, -r6, lsr #28]
     580:	3b0b3a13 	blcc	2cedd4 <_bss_end+0x2c3264>
     584:	640b390b 	strvs	r3, [fp], #-2315	; 0xfffff6f5
     588:	010b2013 	tsteq	fp, r3, lsl r0
     58c:	27000013 	smladcs	r0, r3, r0, r0
     590:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
     594:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
     598:	05280000 	streq	r0, [r8, #-0]!
     59c:	3a0e0300 	bcc	3811a4 <_bss_end+0x375634>
     5a0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     5a4:	0013490b 	andseq	r4, r3, fp, lsl #18
     5a8:	012e2900 			; <UNDEFINED> instruction: 0x012e2900
     5ac:	0e6e1331 	mcreq	3, 3, r1, cr14, cr1, {1}
     5b0:	01111364 	tsteq	r1, r4, ror #6
     5b4:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
     5b8:	00194297 	mulseq	r9, r7, r2
     5bc:	00052a00 	andeq	r2, r5, r0, lsl #20
     5c0:	18021331 	stmdane	r2, {r0, r4, r5, r8, r9, ip}
     5c4:	01000000 	mrseq	r0, (UNDEF: 0)
     5c8:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
     5cc:	0e030b13 	vmoveq.32	d3[0], r0
     5d0:	01110e1b 	tsteq	r1, fp, lsl lr
     5d4:	17100612 			; <UNDEFINED> instruction: 0x17100612
     5d8:	24020000 	strcs	r0, [r2], #-0
     5dc:	3e0b0b00 	vmlacc.f64	d0, d11, d0
     5e0:	000e030b 	andeq	r0, lr, fp, lsl #6
     5e4:	00240300 	eoreq	r0, r4, r0, lsl #6
     5e8:	0b3e0b0b 	bleq	f8321c <_bss_end+0xf776ac>
     5ec:	00000803 	andeq	r0, r0, r3, lsl #16
     5f0:	03001604 	movweq	r1, #1540	; 0x604
     5f4:	3b0b3a0e 	blcc	2cee34 <_bss_end+0x2c32c4>
     5f8:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     5fc:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
     600:	13490026 	movtne	r0, #36902	; 0x9026
     604:	35060000 	strcc	r0, [r6, #-0]
     608:	00134900 	andseq	r4, r3, r0, lsl #18
     60c:	01390700 	teqeq	r9, r0, lsl #14
     610:	0b3a0803 	bleq	e82624 <_bss_end+0xe76ab4>
     614:	0b390b3b 	bleq	e43308 <_bss_end+0xe37798>
     618:	00001301 	andeq	r1, r0, r1, lsl #6
     61c:	03003408 	movweq	r3, #1032	; 0x408
     620:	3b0b3a0e 	blcc	2cee60 <_bss_end+0x2c32f0>
     624:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     628:	1c193c13 	ldcne	12, cr3, [r9], {19}
     62c:	00196c06 	andseq	r6, r9, r6, lsl #24
     630:	00340900 	eorseq	r0, r4, r0, lsl #18
     634:	0b3a0e03 	bleq	e83e48 <_bss_end+0xe782d8>
     638:	0b390b3b 	bleq	e4332c <_bss_end+0xe377bc>
     63c:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
     640:	196c0b1c 	stmdbne	ip!, {r2, r3, r4, r8, r9, fp}^
     644:	040a0000 	streq	r0, [sl], #-0
     648:	6d0e0301 	stcvs	3, cr0, [lr, #-4]
     64c:	0b0b3e19 	bleq	2cfeb8 <_bss_end+0x2c4348>
     650:	3a13490b 	bcc	4d2a84 <_bss_end+0x4c6f14>
     654:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     658:	0b00000b 	bleq	68c <CPSR_IRQ_INHIBIT+0x60c>
     65c:	0e030028 	cdpeq	0, 0, cr0, cr3, cr8, {1}
     660:	00000b1c 	andeq	r0, r0, ip, lsl fp
     664:	4700340c 	strmi	r3, [r0, -ip, lsl #8]
     668:	0d000013 	stceq	0, cr0, [r0, #-76]	; 0xffffffb4
     66c:	0e030104 	adfeqs	f0, f3, f4
     670:	0b3e196d 	bleq	f86c2c <_bss_end+0xf7b0bc>
     674:	13490b0b 	movtne	r0, #39691	; 0x9b0b
     678:	0b3b0b3a 	bleq	ec3368 <_bss_end+0xeb77f8>
     67c:	13010b39 	movwne	r0, #6969	; 0x1b39
     680:	020e0000 	andeq	r0, lr, #0
     684:	0b0e0301 	bleq	381290 <_bss_end+0x375720>
     688:	3b0b3a0b 	blcc	2ceebc <_bss_end+0x2c334c>
     68c:	010b390b 	tsteq	fp, fp, lsl #18
     690:	0f000013 	svceq	0x00000013
     694:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
     698:	0b3b0b3a 	bleq	ec3388 <_bss_end+0xeb7818>
     69c:	13490b39 	movtne	r0, #39737	; 0x9b39
     6a0:	00000b38 	andeq	r0, r0, r8, lsr fp
     6a4:	03001610 	movweq	r1, #1552	; 0x610
     6a8:	3b0b3a0e 	blcc	2ceee8 <_bss_end+0x2c3378>
     6ac:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     6b0:	000b3213 	andeq	r3, fp, r3, lsl r2
     6b4:	012e1100 			; <UNDEFINED> instruction: 0x012e1100
     6b8:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     6bc:	0b3b0b3a 	bleq	ec33ac <_bss_end+0xeb783c>
     6c0:	0e6e0b39 	vmoveq.8	d14[5], r0
     6c4:	0b321349 	bleq	c853f0 <_bss_end+0xc79880>
     6c8:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
     6cc:	00001301 	andeq	r1, r0, r1, lsl #6
     6d0:	49000512 	stmdbmi	r0, {r1, r4, r8, sl}
     6d4:	00193413 	andseq	r3, r9, r3, lsl r4
     6d8:	00051300 	andeq	r1, r5, r0, lsl #6
     6dc:	00001349 	andeq	r1, r0, r9, asr #6
     6e0:	3f012e14 	svccc	0x00012e14
     6e4:	3a0e0319 	bcc	381350 <_bss_end+0x3757e0>
     6e8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     6ec:	320e6e0b 	andcc	r6, lr, #11, 28	; 0xb0
     6f0:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
     6f4:	00130113 	andseq	r0, r3, r3, lsl r1
     6f8:	012e1500 			; <UNDEFINED> instruction: 0x012e1500
     6fc:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     700:	0b3b0b3a 	bleq	ec33f0 <_bss_end+0xeb7880>
     704:	0e6e0b39 	vmoveq.8	d14[5], r0
     708:	0b321349 	bleq	c85434 <_bss_end+0xc798c4>
     70c:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
     710:	0f160000 	svceq	0x00160000
     714:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
     718:	17000013 	smladne	r0, r3, r0, r0
     71c:	00000015 	andeq	r0, r0, r5, lsl r0
     720:	0b001018 	bleq	4788 <CPSR_IRQ_INHIBIT+0x4708>
     724:	0013490b 	andseq	r4, r3, fp, lsl #18
     728:	00341900 	eorseq	r1, r4, r0, lsl #18
     72c:	0b3a0e03 	bleq	e83f40 <_bss_end+0xe783d0>
     730:	0b390b3b 	bleq	e43424 <_bss_end+0xe378b4>
     734:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
     738:	0000193c 	andeq	r1, r0, ip, lsr r9
     73c:	4700341a 	smladmi	r0, sl, r4, r3
     740:	3b0b3a13 	blcc	2cef94 <_bss_end+0x2c3424>
     744:	020b390b 	andeq	r3, fp, #180224	; 0x2c000
     748:	1b000018 	blne	7b0 <CPSR_IRQ_INHIBIT+0x730>
     74c:	0e030113 	mcreq	1, 0, r0, cr3, cr3, {0}
     750:	0b3a0b0b 	bleq	e83384 <_bss_end+0xe77814>
     754:	0b390b3b 	bleq	e43448 <_bss_end+0xe378d8>
     758:	00001301 	andeq	r1, r0, r1, lsl #6
     75c:	03000d1c 	movweq	r0, #3356	; 0xd1c
     760:	3b0b3a0e 	blcc	2cefa0 <_bss_end+0x2c3430>
     764:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     768:	0d0b0b13 	vstreq	d0, [fp, #-76]	; 0xffffffb4
     76c:	380b0c0b 	stmdacc	fp, {r0, r1, r3, sl, fp}
     770:	1d00000b 	stcne	0, cr0, [r0, #-44]	; 0xffffffd4
     774:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
     778:	0b3b0b3a 	bleq	ec3468 <_bss_end+0xeb78f8>
     77c:	13490b39 	movtne	r0, #39737	; 0x9b39
     780:	0b0d0b0b 	bleq	3433b4 <_bss_end+0x337844>
     784:	0b380d0c 	bleq	e03bbc <_bss_end+0xdf804c>
     788:	2e1e0000 	cdpcs	0, 1, cr0, cr14, cr0, {0}
     78c:	340e0300 	strcc	r0, [lr], #-768	; 0xfffffd00
     790:	12011119 	andne	r1, r1, #1073741830	; 0x40000006
     794:	96184006 	ldrls	r4, [r8], -r6
     798:	00001942 	andeq	r1, r0, r2, asr #18
     79c:	03012e1f 	movweq	r2, #7711	; 0x1e1f
     7a0:	1119340e 	tstne	r9, lr, lsl #8
     7a4:	40061201 	andmi	r1, r6, r1, lsl #4
     7a8:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
     7ac:	00001301 	andeq	r1, r0, r1, lsl #6
     7b0:	03000520 	movweq	r0, #1312	; 0x520
     7b4:	3b0b3a0e 	blcc	2ceff4 <_bss_end+0x2c3484>
     7b8:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     7bc:	00180213 	andseq	r0, r8, r3, lsl r2
     7c0:	012e2100 			; <UNDEFINED> instruction: 0x012e2100
     7c4:	0b3a1347 	bleq	e854e8 <_bss_end+0xe79978>
     7c8:	0b390b3b 	bleq	e434bc <_bss_end+0xe3794c>
     7cc:	01111364 	tsteq	r1, r4, ror #6
     7d0:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
     7d4:	01194296 			; <UNDEFINED> instruction: 0x01194296
     7d8:	22000013 	andcs	r0, r0, #19
     7dc:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
     7e0:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
     7e4:	00001802 	andeq	r1, r0, r2, lsl #16
     7e8:	03003423 	movweq	r3, #1059	; 0x423
     7ec:	3b0b3a08 	blcc	2cf014 <_bss_end+0x2c34a4>
     7f0:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     7f4:	00180213 	andseq	r0, r8, r3, lsl r2
     7f8:	012e2400 			; <UNDEFINED> instruction: 0x012e2400
     7fc:	0b3a1347 	bleq	e85520 <_bss_end+0xe799b0>
     800:	0b390b3b 	bleq	e434f4 <_bss_end+0xe37984>
     804:	01111364 	tsteq	r1, r4, ror #6
     808:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
     80c:	01194297 			; <UNDEFINED> instruction: 0x01194297
     810:	25000013 	strcs	r0, [r0, #-19]	; 0xffffffed
     814:	08030005 	stmdaeq	r3, {r0, r2}
     818:	0b3b0b3a 	bleq	ec3508 <_bss_end+0xeb7998>
     81c:	13490b39 	movtne	r0, #39737	; 0x9b39
     820:	00001802 	andeq	r1, r0, r2, lsl #16
     824:	47012e26 	strmi	r2, [r1, -r6, lsr #28]
     828:	3b0b3a13 	blcc	2cf07c <_bss_end+0x2c350c>
     82c:	640b390b 	strvs	r3, [fp], #-2315	; 0xfffff6f5
     830:	010b2013 	tsteq	fp, r3, lsl r0
     834:	27000013 	smladcs	r0, r3, r0, r0
     838:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
     83c:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
     840:	05280000 	streq	r0, [r8, #-0]!
     844:	3a0e0300 	bcc	38144c <_bss_end+0x3758dc>
     848:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     84c:	0013490b 	andseq	r4, r3, fp, lsl #18
     850:	012e2900 			; <UNDEFINED> instruction: 0x012e2900
     854:	0e6e1331 	mcreq	3, 3, r1, cr14, cr1, {1}
     858:	01111364 	tsteq	r1, r4, ror #6
     85c:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
     860:	00194297 	mulseq	r9, r7, r2
     864:	00052a00 	andeq	r2, r5, r0, lsl #20
     868:	18021331 	stmdane	r2, {r0, r4, r5, r8, r9, ip}
     86c:	01000000 	mrseq	r0, (UNDEF: 0)
     870:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
     874:	0e030b13 	vmoveq.32	d3[0], r0
     878:	01110e1b 	tsteq	r1, fp, lsl lr
     87c:	17100612 			; <UNDEFINED> instruction: 0x17100612
     880:	24020000 	strcs	r0, [r2], #-0
     884:	3e0b0b00 	vmlacc.f64	d0, d11, d0
     888:	000e030b 	andeq	r0, lr, fp, lsl #6
     88c:	00240300 	eoreq	r0, r4, r0, lsl #6
     890:	0b3e0b0b 	bleq	f834c4 <_bss_end+0xf77954>
     894:	00000803 	andeq	r0, r0, r3, lsl #16
     898:	03001604 	movweq	r1, #1540	; 0x604
     89c:	3b0b3a0e 	blcc	2cf0dc <_bss_end+0x2c356c>
     8a0:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     8a4:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
     8a8:	13490026 	movtne	r0, #36902	; 0x9026
     8ac:	35060000 	strcc	r0, [r6, #-0]
     8b0:	00134900 	andseq	r4, r3, r0, lsl #18
     8b4:	01390700 	teqeq	r9, r0, lsl #14
     8b8:	0b3a0803 	bleq	e828cc <_bss_end+0xe76d5c>
     8bc:	0b390b3b 	bleq	e435b0 <_bss_end+0xe37a40>
     8c0:	00001301 	andeq	r1, r0, r1, lsl #6
     8c4:	03003408 	movweq	r3, #1032	; 0x408
     8c8:	3b0b3a0e 	blcc	2cf108 <_bss_end+0x2c3598>
     8cc:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     8d0:	1c193c13 	ldcne	12, cr3, [r9], {19}
     8d4:	00196c06 	andseq	r6, r9, r6, lsl #24
     8d8:	00340900 	eorseq	r0, r4, r0, lsl #18
     8dc:	0b3a0e03 	bleq	e840f0 <_bss_end+0xe78580>
     8e0:	0b390b3b 	bleq	e435d4 <_bss_end+0xe37a64>
     8e4:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
     8e8:	196c0b1c 	stmdbne	ip!, {r2, r3, r4, r8, r9, fp}^
     8ec:	040a0000 	streq	r0, [sl], #-0
     8f0:	6d0e0301 	stcvs	3, cr0, [lr, #-4]
     8f4:	0b0b3e19 	bleq	2d0160 <_bss_end+0x2c45f0>
     8f8:	3a13490b 	bcc	4d2d2c <_bss_end+0x4c71bc>
     8fc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     900:	0013010b 	andseq	r0, r3, fp, lsl #2
     904:	00280b00 	eoreq	r0, r8, r0, lsl #22
     908:	0b1c0e03 	bleq	70411c <_bss_end+0x6f85ac>
     90c:	280c0000 	stmdacs	ip, {}	; <UNPREDICTABLE>
     910:	1c080300 	stcne	3, cr0, [r8], {-0}
     914:	0d00000b 	stceq	0, cr0, [r0, #-44]	; 0xffffffd4
     918:	0e030104 	adfeqs	f0, f3, f4
     91c:	0b3e196d 	bleq	f86ed8 <_bss_end+0xf7b368>
     920:	13490b0b 	movtne	r0, #39691	; 0x9b0b
     924:	0b3b0b3a 	bleq	ec3614 <_bss_end+0xeb7aa4>
     928:	00000b39 	andeq	r0, r0, r9, lsr fp
     92c:	4700340e 	strmi	r3, [r0, -lr, lsl #8]
     930:	0f000013 	svceq	0x00000013
     934:	0e030102 	adfeqs	f0, f3, f2
     938:	0b3a0b0b 	bleq	e8356c <_bss_end+0xe779fc>
     93c:	0b390b3b 	bleq	e43630 <_bss_end+0xe37ac0>
     940:	00001301 	andeq	r1, r0, r1, lsl #6
     944:	03000d10 	movweq	r0, #3344	; 0xd10
     948:	3b0b3a0e 	blcc	2cf188 <_bss_end+0x2c3618>
     94c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     950:	000b3813 	andeq	r3, fp, r3, lsl r8
     954:	012e1100 			; <UNDEFINED> instruction: 0x012e1100
     958:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     95c:	0b3b0b3a 	bleq	ec364c <_bss_end+0xeb7adc>
     960:	0e6e0b39 	vmoveq.8	d14[5], r0
     964:	0b321349 	bleq	c85690 <_bss_end+0xc79b20>
     968:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
     96c:	00001301 	andeq	r1, r0, r1, lsl #6
     970:	49000512 	stmdbmi	r0, {r1, r4, r8, sl}
     974:	00193413 	andseq	r3, r9, r3, lsl r4
     978:	00051300 	andeq	r1, r5, r0, lsl #6
     97c:	00001349 	andeq	r1, r0, r9, asr #6
     980:	3f012e14 	svccc	0x00012e14
     984:	3a0e0319 	bcc	3815f0 <_bss_end+0x375a80>
     988:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     98c:	320e6e0b 	andcc	r6, lr, #11, 28	; 0xb0
     990:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
     994:	00130113 	andseq	r0, r3, r3, lsl r1
     998:	012e1500 			; <UNDEFINED> instruction: 0x012e1500
     99c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     9a0:	0b3b0b3a 	bleq	ec3690 <_bss_end+0xeb7b20>
     9a4:	0e6e0b39 	vmoveq.8	d14[5], r0
     9a8:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
     9ac:	00001364 	andeq	r1, r0, r4, ror #6
     9b0:	0b000f16 	bleq	4610 <CPSR_IRQ_INHIBIT+0x4590>
     9b4:	0013490b 	andseq	r4, r3, fp, lsl #18
     9b8:	00101700 	andseq	r1, r0, r0, lsl #14
     9bc:	13490b0b 	movtne	r0, #39691	; 0x9b0b
     9c0:	34180000 	ldrcc	r0, [r8], #-0
     9c4:	3a0e0300 	bcc	3815cc <_bss_end+0x375a5c>
     9c8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     9cc:	3f13490b 	svccc	0x0013490b
     9d0:	00193c19 	andseq	r3, r9, r9, lsl ip
     9d4:	00161900 	andseq	r1, r6, r0, lsl #18
     9d8:	0b3a0e03 	bleq	e841ec <_bss_end+0xe7867c>
     9dc:	0b390b3b 	bleq	e436d0 <_bss_end+0xe37b60>
     9e0:	0b321349 	bleq	c8570c <_bss_end+0xc79b9c>
     9e4:	2e1a0000 	cdpcs	0, 1, cr0, cr10, cr0, {0}
     9e8:	03193f01 	tsteq	r9, #1, 30
     9ec:	3b0b3a0e 	blcc	2cf22c <_bss_end+0x2c36bc>
     9f0:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     9f4:	3213490e 	andscc	r4, r3, #229376	; 0x38000
     9f8:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
     9fc:	1b000013 	blne	a50 <CPSR_IRQ_INHIBIT+0x9d0>
     a00:	00000015 	andeq	r0, r0, r5, lsl r0
     a04:	4700341c 	smladmi	r0, ip, r4, r3
     a08:	3b0b3a13 	blcc	2cf25c <_bss_end+0x2c36ec>
     a0c:	020b390b 	andeq	r3, fp, #180224	; 0x2c000
     a10:	1d000018 	stcne	0, cr0, [r0, #-96]	; 0xffffffa0
     a14:	0e03002e 	cdpeq	0, 0, cr0, cr3, cr14, {1}
     a18:	01111934 	tsteq	r1, r4, lsr r9
     a1c:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
     a20:	00194296 	mulseq	r9, r6, r2
     a24:	012e1e00 			; <UNDEFINED> instruction: 0x012e1e00
     a28:	19340e03 	ldmdbne	r4!, {r0, r1, r9, sl, fp}
     a2c:	06120111 			; <UNDEFINED> instruction: 0x06120111
     a30:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
     a34:	00130119 	andseq	r0, r3, r9, lsl r1
     a38:	00051f00 	andeq	r1, r5, r0, lsl #30
     a3c:	0b3a0e03 	bleq	e84250 <_bss_end+0xe786e0>
     a40:	0b390b3b 	bleq	e43734 <_bss_end+0xe37bc4>
     a44:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
     a48:	2e200000 	cdpcs	0, 2, cr0, cr0, cr0, {0}
     a4c:	3a134701 	bcc	4d2658 <_bss_end+0x4c6ae8>
     a50:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     a54:	1113640b 	tstne	r3, fp, lsl #8
     a58:	40061201 	andmi	r1, r6, r1, lsl #4
     a5c:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
     a60:	00001301 	andeq	r1, r0, r1, lsl #6
     a64:	03000521 	movweq	r0, #1313	; 0x521
     a68:	3413490e 	ldrcc	r4, [r3], #-2318	; 0xfffff6f2
     a6c:	00180219 	andseq	r0, r8, r9, lsl r2
     a70:	00342200 	eorseq	r2, r4, r0, lsl #4
     a74:	0b3a0e03 	bleq	e84288 <_bss_end+0xe78718>
     a78:	0b390b3b 	bleq	e4376c <_bss_end+0xe37bfc>
     a7c:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
     a80:	2e230000 	cdpcs	0, 2, cr0, cr3, cr0, {0}
     a84:	3a134701 	bcc	4d2690 <_bss_end+0x4c6b20>
     a88:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     a8c:	1113640b 	tstne	r3, fp, lsl #8
     a90:	40061201 	andmi	r1, r6, r1, lsl #4
     a94:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
     a98:	00001301 	andeq	r1, r0, r1, lsl #6
     a9c:	03000524 	movweq	r0, #1316	; 0x524
     aa0:	3b0b3a08 	blcc	2cf2c8 <_bss_end+0x2c3758>
     aa4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     aa8:	00180213 	andseq	r0, r8, r3, lsl r2
     aac:	012e2500 			; <UNDEFINED> instruction: 0x012e2500
     ab0:	0b3a1347 	bleq	e857d4 <_bss_end+0xe79c64>
     ab4:	0b390b3b 	bleq	e437a8 <_bss_end+0xe37c38>
     ab8:	0b201364 	bleq	805850 <_bss_end+0x7f9ce0>
     abc:	00001301 	andeq	r1, r0, r1, lsl #6
     ac0:	03000526 	movweq	r0, #1318	; 0x526
     ac4:	3413490e 	ldrcc	r4, [r3], #-2318	; 0xfffff6f2
     ac8:	27000019 	smladcs	r0, r9, r0, r0
     acc:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
     ad0:	0b3b0b3a 	bleq	ec37c0 <_bss_end+0xeb7c50>
     ad4:	13490b39 	movtne	r0, #39737	; 0x9b39
     ad8:	2e280000 	cdpcs	0, 2, cr0, cr8, cr0, {0}
     adc:	6e133101 	mufvss	f3, f3, f1
     ae0:	1113640e 	tstne	r3, lr, lsl #8
     ae4:	40061201 	andmi	r1, r6, r1, lsl #4
     ae8:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
     aec:	00001301 	andeq	r1, r0, r1, lsl #6
     af0:	31000529 	tstcc	r0, r9, lsr #10
     af4:	00180213 	andseq	r0, r8, r3, lsl r2
     af8:	002e2a00 	eoreq	r2, lr, r0, lsl #20
     afc:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     b00:	0b3b0b3a 	bleq	ec37f0 <_bss_end+0xeb7c80>
     b04:	01110b39 	tsteq	r1, r9, lsr fp
     b08:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
     b0c:	00194297 	mulseq	r9, r7, r2
     b10:	002e2b00 	eoreq	r2, lr, r0, lsl #22
     b14:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     b18:	0b3b0b3a 	bleq	ec3808 <_bss_end+0xeb7c98>
     b1c:	01110b39 	tsteq	r1, r9, lsr fp
     b20:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
     b24:	00194296 	mulseq	r9, r6, r2
     b28:	11010000 	mrsne	r0, (UNDEF: 1)
     b2c:	130e2501 	movwne	r2, #58625	; 0xe501
     b30:	1b0e030b 	blne	381764 <_bss_end+0x375bf4>
     b34:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
     b38:	00171006 	andseq	r1, r7, r6
     b3c:	00240200 	eoreq	r0, r4, r0, lsl #4
     b40:	0b3e0b0b 	bleq	f83774 <_bss_end+0xf77c04>
     b44:	00000e03 	andeq	r0, r0, r3, lsl #28
     b48:	49002603 	stmdbmi	r0, {r0, r1, r9, sl, sp}
     b4c:	04000013 	streq	r0, [r0], #-19	; 0xffffffed
     b50:	0b0b0024 	bleq	2c0be8 <_bss_end+0x2b5078>
     b54:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
     b58:	35050000 	strcc	r0, [r5, #-0]
     b5c:	00134900 	andseq	r4, r3, r0, lsl #18
     b60:	00160600 	andseq	r0, r6, r0, lsl #12
     b64:	0b3a0e03 	bleq	e84378 <_bss_end+0xe78808>
     b68:	0b390b3b 	bleq	e4385c <_bss_end+0xe37cec>
     b6c:	00001349 	andeq	r1, r0, r9, asr #6
     b70:	03010407 	movweq	r0, #5127	; 0x1407
     b74:	3e196d0e 	cdpcc	13, 1, cr6, cr9, cr14, {0}
     b78:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
     b7c:	3b0b3a13 	blcc	2cf3d0 <_bss_end+0x2c3860>
     b80:	010b390b 	tsteq	fp, fp, lsl #18
     b84:	08000013 	stmdaeq	r0, {r0, r1, r4}
     b88:	0e030028 	cdpeq	0, 0, cr0, cr3, cr8, {1}
     b8c:	00000b1c 	andeq	r0, r0, ip, lsl fp
     b90:	03010209 	movweq	r0, #4617	; 0x1209
     b94:	3a0b0b0e 	bcc	2c37d4 <_bss_end+0x2b7c64>
     b98:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     b9c:	0013010b 	andseq	r0, r3, fp, lsl #2
     ba0:	000d0a00 	andeq	r0, sp, r0, lsl #20
     ba4:	0b3a0e03 	bleq	e843b8 <_bss_end+0xe78848>
     ba8:	0b390b3b 	bleq	e4389c <_bss_end+0xe37d2c>
     bac:	0b381349 	bleq	e058d8 <_bss_end+0xdf9d68>
     bb0:	2e0b0000 	cdpcs	0, 0, cr0, cr11, cr0, {0}
     bb4:	03193f01 	tsteq	r9, #1, 30
     bb8:	3b0b3a0e 	blcc	2cf3f8 <_bss_end+0x2c3888>
     bbc:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     bc0:	3213490e 	andscc	r4, r3, #229376	; 0x38000
     bc4:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
     bc8:	00130113 	andseq	r0, r3, r3, lsl r1
     bcc:	00050c00 	andeq	r0, r5, r0, lsl #24
     bd0:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
     bd4:	050d0000 	streq	r0, [sp, #-0]
     bd8:	00134900 	andseq	r4, r3, r0, lsl #18
     bdc:	012e0e00 			; <UNDEFINED> instruction: 0x012e0e00
     be0:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     be4:	0b3b0b3a 	bleq	ec38d4 <_bss_end+0xeb7d64>
     be8:	0e6e0b39 	vmoveq.8	d14[5], r0
     bec:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
     bf0:	13011364 	movwne	r1, #4964	; 0x1364
     bf4:	2e0f0000 	cdpcs	0, 0, cr0, cr15, cr0, {0}
     bf8:	03193f01 	tsteq	r9, #1, 30
     bfc:	3b0b3a0e 	blcc	2cf43c <_bss_end+0x2c38cc>
     c00:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     c04:	3213490e 	andscc	r4, r3, #229376	; 0x38000
     c08:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
     c0c:	10000013 	andne	r0, r0, r3, lsl r0
     c10:	0b0b000f 	bleq	2c0c54 <_bss_end+0x2b50e4>
     c14:	00001349 	andeq	r1, r0, r9, asr #6
     c18:	0b001011 	bleq	4c64 <CPSR_IRQ_INHIBIT+0x4be4>
     c1c:	0013490b 	andseq	r4, r3, fp, lsl #18
     c20:	00341200 	eorseq	r1, r4, r0, lsl #4
     c24:	0b3a0e03 	bleq	e84438 <_bss_end+0xe788c8>
     c28:	0b390b3b 	bleq	e4391c <_bss_end+0xe37dac>
     c2c:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
     c30:	0000193c 	andeq	r1, r0, ip, lsr r9
     c34:	03010413 	movweq	r0, #5139	; 0x1413
     c38:	3e196d0e 	cdpcc	13, 1, cr6, cr9, cr14, {0}
     c3c:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
     c40:	3b0b3a13 	blcc	2cf494 <_bss_end+0x2c3924>
     c44:	320b390b 	andcc	r3, fp, #180224	; 0x2c000
     c48:	0013010b 	andseq	r0, r3, fp, lsl #2
     c4c:	00281400 	eoreq	r1, r8, r0, lsl #8
     c50:	0b1c0803 	bleq	702c64 <_bss_end+0x6f70f4>
     c54:	13150000 	tstne	r5, #0
     c58:	0b0e0301 	bleq	381864 <_bss_end+0x375cf4>
     c5c:	3b0b3a0b 	blcc	2cf490 <_bss_end+0x2c3920>
     c60:	010b390b 	tsteq	fp, fp, lsl #18
     c64:	16000013 			; <UNDEFINED> instruction: 0x16000013
     c68:	0803000d 	stmdaeq	r3, {r0, r2, r3}
     c6c:	0b3b0b3a 	bleq	ec395c <_bss_end+0xeb7dec>
     c70:	13490b39 	movtne	r0, #39737	; 0x9b39
     c74:	00000b38 	andeq	r0, r0, r8, lsr fp
     c78:	03000d17 	movweq	r0, #3351	; 0xd17
     c7c:	3b0b3a0e 	blcc	2cf4bc <_bss_end+0x2c394c>
     c80:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     c84:	32193f13 	andscc	r3, r9, #19, 30	; 0x4c
     c88:	1c193c0b 	ldcne	12, cr3, [r9], {11}
     c8c:	00196c0b 	andseq	r6, r9, fp, lsl #24
     c90:	000d1800 	andeq	r1, sp, r0, lsl #16
     c94:	0b3a0e03 	bleq	e844a8 <_bss_end+0xe78938>
     c98:	0b390b3b 	bleq	e4398c <_bss_end+0xe37e1c>
     c9c:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
     ca0:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
     ca4:	0000196c 	andeq	r1, r0, ip, ror #18
     ca8:	3f012e19 	svccc	0x00012e19
     cac:	3a0e0319 	bcc	381918 <_bss_end+0x375da8>
     cb0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     cb4:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
     cb8:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
     cbc:	64196319 	ldrvs	r6, [r9], #-793	; 0xfffffce7
     cc0:	00130113 	andseq	r0, r3, r3, lsl r1
     cc4:	012e1a00 			; <UNDEFINED> instruction: 0x012e1a00
     cc8:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     ccc:	0b3b0b3a 	bleq	ec39bc <_bss_end+0xeb7e4c>
     cd0:	0e6e0b39 	vmoveq.8	d14[5], r0
     cd4:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
     cd8:	00001301 	andeq	r1, r0, r1, lsl #6
     cdc:	0301391b 	movweq	r3, #6427	; 0x191b
     ce0:	3b0b3a08 	blcc	2cf508 <_bss_end+0x2c3998>
     ce4:	010b390b 	tsteq	fp, fp, lsl #18
     ce8:	1c000013 	stcne	0, cr0, [r0], {19}
     cec:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
     cf0:	0b3b0b3a 	bleq	ec39e0 <_bss_end+0xeb7e70>
     cf4:	13490b39 	movtne	r0, #39737	; 0x9b39
     cf8:	061c193c 			; <UNDEFINED> instruction: 0x061c193c
     cfc:	0000196c 	andeq	r1, r0, ip, ror #18
     d00:	0300341d 	movweq	r3, #1053	; 0x41d
     d04:	3b0b3a0e 	blcc	2cf544 <_bss_end+0x2c39d4>
     d08:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     d0c:	1c193c13 	ldcne	12, cr3, [r9], {19}
     d10:	00196c0b 	andseq	r6, r9, fp, lsl #24
     d14:	01041e00 	tsteq	r4, r0, lsl #28
     d18:	196d0e03 	stmdbne	sp!, {r0, r1, r9, sl, fp}^
     d1c:	0b0b0b3e 	bleq	2c3a1c <_bss_end+0x2b7eac>
     d20:	0b3a1349 	bleq	e85a4c <_bss_end+0xe79edc>
     d24:	0b390b3b 	bleq	e43a18 <_bss_end+0xe37ea8>
     d28:	341f0000 	ldrcc	r0, [pc], #-0	; d30 <CPSR_IRQ_INHIBIT+0xcb0>
     d2c:	00134700 	andseq	r4, r3, r0, lsl #14
     d30:	00162000 	andseq	r2, r6, r0
     d34:	0b3a0e03 	bleq	e84548 <_bss_end+0xe789d8>
     d38:	0b390b3b 	bleq	e43a2c <_bss_end+0xe37ebc>
     d3c:	0b321349 	bleq	c85a68 <_bss_end+0xc79ef8>
     d40:	15210000 	strne	r0, [r1, #-0]!
     d44:	22000000 	andcs	r0, r0, #0
     d48:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
     d4c:	0b3a0e03 	bleq	e84560 <_bss_end+0xe789f0>
     d50:	0b390b3b 	bleq	e43a44 <_bss_end+0xe37ed4>
     d54:	0b320e6e 	bleq	c84714 <_bss_end+0xc78ba4>
     d58:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
     d5c:	34230000 	strtcc	r0, [r3], #-0
     d60:	3a0e0300 	bcc	381968 <_bss_end+0x375df8>
     d64:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     d68:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
     d6c:	6c051c19 	stcvs	12, cr1, [r5], {25}
     d70:	24000019 	strcs	r0, [r0], #-25	; 0xffffffe7
     d74:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
     d78:	0b3a0e03 	bleq	e8458c <_bss_end+0xe78a1c>
     d7c:	0b390b3b 	bleq	e43a70 <_bss_end+0xe37f00>
     d80:	13490e6e 	movtne	r0, #40558	; 0x9e6e
     d84:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
     d88:	00001301 	andeq	r1, r0, r1, lsl #6
     d8c:	0b000f25 	bleq	4a28 <CPSR_IRQ_INHIBIT+0x49a8>
     d90:	2600000b 	strcs	r0, [r0], -fp
     d94:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
     d98:	0b3b0b3a 	bleq	ec3a88 <_bss_end+0xeb7f18>
     d9c:	13490b39 	movtne	r0, #39737	; 0x9b39
     da0:	1802193f 	stmdane	r2, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
     da4:	34270000 	strtcc	r0, [r7], #-0
     da8:	3a0e0300 	bcc	3819b0 <_bss_end+0x375e40>
     dac:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     db0:	6c13490b 			; <UNDEFINED> instruction: 0x6c13490b
     db4:	00180219 	andseq	r0, r8, r9, lsl r2
     db8:	002e2800 	eoreq	r2, lr, r0, lsl #16
     dbc:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     dc0:	0b3b0b3a 	bleq	ec3ab0 <_bss_end+0xeb7f40>
     dc4:	13490b39 	movtne	r0, #39737	; 0x9b39
     dc8:	06120111 			; <UNDEFINED> instruction: 0x06120111
     dcc:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
     dd0:	29000019 	stmdbcs	r0, {r0, r3, r4}
     dd4:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
     dd8:	0b3a0e03 	bleq	e845ec <_bss_end+0xe78a7c>
     ddc:	0b390b3b 	bleq	e43ad0 <_bss_end+0xe37f60>
     de0:	06120111 			; <UNDEFINED> instruction: 0x06120111
     de4:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
     de8:	00130119 	andseq	r0, r3, r9, lsl r1
     dec:	00342a00 	eorseq	r2, r4, r0, lsl #20
     df0:	0b3a0803 	bleq	e82e04 <_bss_end+0xe77294>
     df4:	0b390b3b 	bleq	e43ae8 <_bss_end+0xe37f78>
     df8:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
     dfc:	2e2b0000 	cdpcs	0, 2, cr0, cr11, cr0, {0}
     e00:	03193f00 	tsteq	r9, #0, 30
     e04:	3b0b3a0e 	blcc	2cf644 <_bss_end+0x2c3ad4>
     e08:	110b390b 	tstne	fp, fp, lsl #18
     e0c:	40061201 	andmi	r1, r6, r1, lsl #4
     e10:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
     e14:	01000000 	mrseq	r0, (UNDEF: 0)
     e18:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
     e1c:	0e030b13 	vmoveq.32	d3[0], r0
     e20:	01110e1b 	tsteq	r1, fp, lsl lr
     e24:	17100612 			; <UNDEFINED> instruction: 0x17100612
     e28:	24020000 	strcs	r0, [r2], #-0
     e2c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
     e30:	000e030b 	andeq	r0, lr, fp, lsl #6
     e34:	00240300 	eoreq	r0, r4, r0, lsl #6
     e38:	0b3e0b0b 	bleq	f83a6c <_bss_end+0xf77efc>
     e3c:	00000803 	andeq	r0, r0, r3, lsl #16
     e40:	03001604 	movweq	r1, #1540	; 0x604
     e44:	3b0b3a0e 	blcc	2cf684 <_bss_end+0x2c3b14>
     e48:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     e4c:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
     e50:	13490026 	movtne	r0, #36902	; 0x9026
     e54:	13060000 	movwne	r0, #24576	; 0x6000
     e58:	0b0e0301 	bleq	381a64 <_bss_end+0x375ef4>
     e5c:	3b0b3a0b 	blcc	2cf690 <_bss_end+0x2c3b20>
     e60:	010b390b 	tsteq	fp, fp, lsl #18
     e64:	07000013 	smladeq	r0, r3, r0, r0
     e68:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
     e6c:	0b3b0b3a 	bleq	ec3b5c <_bss_end+0xeb7fec>
     e70:	13490b39 	movtne	r0, #39737	; 0x9b39
     e74:	00000b38 	andeq	r0, r0, r8, lsr fp
     e78:	0b000f08 	bleq	4aa0 <CPSR_IRQ_INHIBIT+0x4a20>
     e7c:	0013490b 	andseq	r4, r3, fp, lsl #18
     e80:	01020900 	tsteq	r2, r0, lsl #18
     e84:	0b0b0e03 	bleq	2c4698 <_bss_end+0x2b8b28>
     e88:	0b3b0b3a 	bleq	ec3b78 <_bss_end+0xeb8008>
     e8c:	13010b39 	movwne	r0, #6969	; 0x1b39
     e90:	2e0a0000 	cdpcs	0, 0, cr0, cr10, cr0, {0}
     e94:	03193f01 	tsteq	r9, #1, 30
     e98:	3b0b3a0e 	blcc	2cf6d8 <_bss_end+0x2c3b68>
     e9c:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     ea0:	3c13490e 			; <UNDEFINED> instruction: 0x3c13490e
     ea4:	01136419 	tsteq	r3, r9, lsl r4
     ea8:	0b000013 	bleq	efc <CPSR_IRQ_INHIBIT+0xe7c>
     eac:	13490005 	movtne	r0, #36869	; 0x9005
     eb0:	00001934 	andeq	r1, r0, r4, lsr r9
     eb4:	3f012e0c 	svccc	0x00012e0c
     eb8:	3a0e0319 	bcc	381b24 <_bss_end+0x375fb4>
     ebc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     ec0:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
     ec4:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
     ec8:	01136419 	tsteq	r3, r9, lsl r4
     ecc:	0d000013 	stceq	0, cr0, [r0, #-76]	; 0xffffffb4
     ed0:	13490005 	movtne	r0, #36869	; 0x9005
     ed4:	2e0e0000 	cdpcs	0, 0, cr0, cr14, cr0, {0}
     ed8:	03193f01 	tsteq	r9, #1, 30
     edc:	3b0b3a0e 	blcc	2cf71c <_bss_end+0x2c3bac>
     ee0:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     ee4:	3c0b320e 	sfmcc	f3, 4, [fp], {14}
     ee8:	00136419 	andseq	r6, r3, r9, lsl r4
     eec:	000f0f00 	andeq	r0, pc, r0, lsl #30
     ef0:	00000b0b 	andeq	r0, r0, fp, lsl #22
     ef4:	03003410 	movweq	r3, #1040	; 0x410
     ef8:	3b0b3a0e 	blcc	2cf738 <_bss_end+0x2c3bc8>
     efc:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     f00:	3c193f13 	ldccc	15, cr3, [r9], {19}
     f04:	11000019 	tstne	r0, r9, lsl r0
     f08:	08030139 	stmdaeq	r3, {r0, r3, r4, r5, r8}
     f0c:	0b3b0b3a 	bleq	ec3bfc <_bss_end+0xeb808c>
     f10:	13010b39 	movwne	r0, #6969	; 0x1b39
     f14:	34120000 	ldrcc	r0, [r2], #-0
     f18:	3a0e0300 	bcc	381b20 <_bss_end+0x375fb0>
     f1c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     f20:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
     f24:	6c061c19 	stcvs	12, cr1, [r6], {25}
     f28:	13000019 	movwne	r0, #25
     f2c:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
     f30:	0b3b0b3a 	bleq	ec3c20 <_bss_end+0xeb80b0>
     f34:	13490b39 	movtne	r0, #39737	; 0x9b39
     f38:	0b1c193c 	bleq	707430 <_bss_end+0x6fb8c0>
     f3c:	0000196c 	andeq	r1, r0, ip, ror #18
     f40:	47003414 	smladmi	r0, r4, r4, r3
     f44:	15000013 	strne	r0, [r0, #-19]	; 0xffffffed
     f48:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
     f4c:	0b3b0b3a 	bleq	ec3c3c <_bss_end+0xeb80cc>
     f50:	13490b39 	movtne	r0, #39737	; 0x9b39
     f54:	051c193c 	ldreq	r1, [ip, #-2364]	; 0xfffff6c4
     f58:	0000196c 	andeq	r1, r0, ip, ror #18
     f5c:	03010216 	movweq	r0, #4630	; 0x1216
     f60:	3a050b0e 	bcc	143ba0 <_bss_end+0x138030>
     f64:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     f68:	0013010b 	andseq	r0, r3, fp, lsl #2
     f6c:	012e1700 			; <UNDEFINED> instruction: 0x012e1700
     f70:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     f74:	0b3b0b3a 	bleq	ec3c64 <_bss_end+0xeb80f4>
     f78:	0e6e0b39 	vmoveq.8	d14[5], r0
     f7c:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
     f80:	00001301 	andeq	r1, r0, r1, lsl #6
     f84:	49010118 	stmdbmi	r1, {r3, r4, r8}
     f88:	00130113 	andseq	r0, r3, r3, lsl r1
     f8c:	00211900 	eoreq	r1, r1, r0, lsl #18
     f90:	052f1349 	streq	r1, [pc, #-841]!	; c4f <CPSR_IRQ_INHIBIT+0xbcf>
     f94:	341a0000 	ldrcc	r0, [sl], #-0
     f98:	3a134700 	bcc	4d2ba0 <_bss_end+0x4c7030>
     f9c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     fa0:	0018020b 	andseq	r0, r8, fp, lsl #4
     fa4:	002e1b00 	eoreq	r1, lr, r0, lsl #22
     fa8:	19340e03 	ldmdbne	r4!, {r0, r1, r9, sl, fp}
     fac:	06120111 			; <UNDEFINED> instruction: 0x06120111
     fb0:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
     fb4:	1c000019 	stcne	0, cr0, [r0], {25}
     fb8:	0e03012e 	adfeqsp	f0, f3, #0.5
     fbc:	01111934 	tsteq	r1, r4, lsr r9
     fc0:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
     fc4:	01194296 			; <UNDEFINED> instruction: 0x01194296
     fc8:	1d000013 	stcne	0, cr0, [r0, #-76]	; 0xffffffb4
     fcc:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
     fd0:	0b3b0b3a 	bleq	ec3cc0 <_bss_end+0xeb8150>
     fd4:	13490b39 	movtne	r0, #39737	; 0x9b39
     fd8:	00001802 	andeq	r1, r0, r2, lsl #16
     fdc:	47012e1e 	smladmi	r1, lr, lr, r2
     fe0:	3b0b3a13 	blcc	2cf834 <_bss_end+0x2c3cc4>
     fe4:	640b390b 	strvs	r3, [fp], #-2315	; 0xfffff6f5
     fe8:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
     fec:	97184006 	ldrls	r4, [r8, -r6]
     ff0:	13011942 	movwne	r1, #6466	; 0x1942
     ff4:	051f0000 	ldreq	r0, [pc, #-0]	; ffc <CPSR_IRQ_INHIBIT+0xf7c>
     ff8:	490e0300 	stmdbmi	lr, {r8, r9}
     ffc:	02193413 	andseq	r3, r9, #318767104	; 0x13000000
    1000:	20000018 	andcs	r0, r0, r8, lsl r0
    1004:	08030005 	stmdaeq	r3, {r0, r2}
    1008:	0b3b0b3a 	bleq	ec3cf8 <_bss_end+0xeb8188>
    100c:	13490b39 	movtne	r0, #39737	; 0x9b39
    1010:	00001802 	andeq	r1, r0, r2, lsl #16
    1014:	03003421 	movweq	r3, #1057	; 0x421
    1018:	3b0b3a0e 	blcc	2cf858 <_bss_end+0x2c3ce8>
    101c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
    1020:	00180213 	andseq	r0, r8, r3, lsl r2
    1024:	012e2200 			; <UNDEFINED> instruction: 0x012e2200
    1028:	0b3a1347 	bleq	e85d4c <_bss_end+0xe7a1dc>
    102c:	0b390b3b 	bleq	e43d20 <_bss_end+0xe381b0>
    1030:	01111364 	tsteq	r1, r4, ror #6
    1034:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
    1038:	01194296 			; <UNDEFINED> instruction: 0x01194296
    103c:	23000013 	movwcs	r0, #19
    1040:	1347012e 	movtne	r0, #28974	; 0x712e
    1044:	0b3b0b3a 	bleq	ec3d34 <_bss_end+0xeb81c4>
    1048:	13640b39 	cmnne	r4, #58368	; 0xe400
    104c:	13010b20 	movwne	r0, #6944	; 0x1b20
    1050:	05240000 	streq	r0, [r4, #-0]!
    1054:	490e0300 	stmdbmi	lr, {r8, r9}
    1058:	00193413 	andseq	r3, r9, r3, lsl r4
    105c:	012e2500 			; <UNDEFINED> instruction: 0x012e2500
    1060:	0e6e1331 	mcreq	3, 3, r1, cr14, cr1, {1}
    1064:	01111364 	tsteq	r1, r4, ror #6
    1068:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
    106c:	00194296 	mulseq	r9, r6, r2
    1070:	00052600 	andeq	r2, r5, r0, lsl #12
    1074:	18021331 	stmdane	r2, {r0, r4, r5, r8, r9, ip}
    1078:	01000000 	mrseq	r0, (UNDEF: 0)
    107c:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
    1080:	0e030b13 	vmoveq.32	d3[0], r0
    1084:	01110e1b 	tsteq	r1, fp, lsl lr
    1088:	17100612 			; <UNDEFINED> instruction: 0x17100612
    108c:	24020000 	strcs	r0, [r2], #-0
    1090:	3e0b0b00 	vmlacc.f64	d0, d11, d0
    1094:	000e030b 	andeq	r0, lr, fp, lsl #6
    1098:	00240300 	eoreq	r0, r4, r0, lsl #6
    109c:	0b3e0b0b 	bleq	f83cd0 <_bss_end+0xf78160>
    10a0:	00000803 	andeq	r0, r0, r3, lsl #16
    10a4:	03001604 	movweq	r1, #1540	; 0x604
    10a8:	3b0b3a0e 	blcc	2cf8e8 <_bss_end+0x2c3d78>
    10ac:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
    10b0:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
    10b4:	13490026 	movtne	r0, #36902	; 0x9026
    10b8:	39060000 	stmdbcc	r6, {}	; <UNPREDICTABLE>
    10bc:	3a080301 	bcc	201cc8 <_bss_end+0x1f6158>
    10c0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    10c4:	0013010b 	andseq	r0, r3, fp, lsl #2
    10c8:	00340700 	eorseq	r0, r4, r0, lsl #14
    10cc:	0b3a0e03 	bleq	e848e0 <_bss_end+0xe78d70>
    10d0:	0b390b3b 	bleq	e43dc4 <_bss_end+0xe38254>
    10d4:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
    10d8:	196c061c 	stmdbne	ip!, {r2, r3, r4, r9, sl}^
    10dc:	34080000 	strcc	r0, [r8], #-0
    10e0:	3a0e0300 	bcc	381ce8 <_bss_end+0x376178>
    10e4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    10e8:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
    10ec:	6c0b1c19 	stcvs	12, cr1, [fp], {25}
    10f0:	09000019 	stmdbeq	r0, {r0, r3, r4}
    10f4:	13470034 	movtne	r0, #28724	; 0x7034
    10f8:	340a0000 	strcc	r0, [sl], #-0
    10fc:	3a0e0300 	bcc	381d04 <_bss_end+0x376194>
    1100:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    1104:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
    1108:	6c051c19 	stcvs	12, cr1, [r5], {25}
    110c:	0b000019 	bleq	1178 <CPSR_IRQ_INHIBIT+0x10f8>
    1110:	0e030102 	adfeqs	f0, f3, f2
    1114:	0b3a050b 	bleq	e82548 <_bss_end+0xe769d8>
    1118:	0b390b3b 	bleq	e43e0c <_bss_end+0xe3829c>
    111c:	00001301 	andeq	r1, r0, r1, lsl #6
    1120:	03000d0c 	movweq	r0, #3340	; 0xd0c
    1124:	3b0b3a0e 	blcc	2cf964 <_bss_end+0x2c3df4>
    1128:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
    112c:	000b3813 	andeq	r3, fp, r3, lsl r8
    1130:	012e0d00 			; <UNDEFINED> instruction: 0x012e0d00
    1134:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
    1138:	0b3b0b3a 	bleq	ec3e28 <_bss_end+0xeb82b8>
    113c:	0e6e0b39 	vmoveq.8	d14[5], r0
    1140:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
    1144:	00001301 	andeq	r1, r0, r1, lsl #6
    1148:	4900050e 	stmdbmi	r0, {r1, r2, r3, r8, sl}
    114c:	00193413 	andseq	r3, r9, r3, lsl r4
    1150:	00050f00 	andeq	r0, r5, r0, lsl #30
    1154:	00001349 	andeq	r1, r0, r9, asr #6
    1158:	3f012e10 	svccc	0x00012e10
    115c:	3a0e0319 	bcc	381dc8 <_bss_end+0x376258>
    1160:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    1164:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
    1168:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
    116c:	01136419 	tsteq	r3, r9, lsl r4
    1170:	11000013 	tstne	r0, r3, lsl r0
    1174:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
    1178:	0b3a0e03 	bleq	e8498c <_bss_end+0xe78e1c>
    117c:	0b390b3b 	bleq	e43e70 <_bss_end+0xe38300>
    1180:	0b320e6e 	bleq	c84b40 <_bss_end+0xc78fd0>
    1184:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
    1188:	01120000 	tsteq	r2, r0
    118c:	01134901 	tsteq	r3, r1, lsl #18
    1190:	13000013 	movwne	r0, #19
    1194:	13490021 	movtne	r0, #36897	; 0x9021
    1198:	0000052f 	andeq	r0, r0, pc, lsr #10
    119c:	0b000f14 	bleq	4df4 <CPSR_IRQ_INHIBIT+0x4d74>
    11a0:	0013490b 	andseq	r4, r3, fp, lsl #18
    11a4:	00341500 	eorseq	r1, r4, r0, lsl #10
    11a8:	0b3a0e03 	bleq	e849bc <_bss_end+0xe78e4c>
    11ac:	0b390b3b 	bleq	e43ea0 <_bss_end+0xe38330>
    11b0:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
    11b4:	0000193c 	andeq	r1, r0, ip, lsr r9
    11b8:	47003416 	smladmi	r0, r6, r4, r3
    11bc:	3b0b3a13 	blcc	2cfa10 <_bss_end+0x2c3ea0>
    11c0:	020b390b 	andeq	r3, fp, #180224	; 0x2c000
    11c4:	17000018 	smladne	r0, r8, r0, r0
    11c8:	0e03002e 	cdpeq	0, 0, cr0, cr3, cr14, {1}
    11cc:	01111934 	tsteq	r1, r4, lsr r9
    11d0:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
    11d4:	00194296 	mulseq	r9, r6, r2
    11d8:	012e1800 			; <UNDEFINED> instruction: 0x012e1800
    11dc:	19340e03 	ldmdbne	r4!, {r0, r1, r9, sl, fp}
    11e0:	06120111 			; <UNDEFINED> instruction: 0x06120111
    11e4:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
    11e8:	00130119 	andseq	r0, r3, r9, lsl r1
    11ec:	00051900 	andeq	r1, r5, r0, lsl #18
    11f0:	0b3a0e03 	bleq	e84a04 <_bss_end+0xe78e94>
    11f4:	0b390b3b 	bleq	e43ee8 <_bss_end+0xe38378>
    11f8:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
    11fc:	2e1a0000 	cdpcs	0, 1, cr0, cr10, cr0, {0}
    1200:	3a134701 	bcc	4d2e0c <_bss_end+0x4c729c>
    1204:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    1208:	1113640b 	tstne	r3, fp, lsl #8
    120c:	40061201 	andmi	r1, r6, r1, lsl #4
    1210:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
    1214:	00001301 	andeq	r1, r0, r1, lsl #6
    1218:	0300051b 	movweq	r0, #1307	; 0x51b
    121c:	3413490e 	ldrcc	r4, [r3], #-2318	; 0xfffff6f2
    1220:	00180219 	andseq	r0, r8, r9, lsl r2
    1224:	00051c00 	andeq	r1, r5, r0, lsl #24
    1228:	0b3a0803 	bleq	e8323c <_bss_end+0xe776cc>
    122c:	0b390b3b 	bleq	e43f20 <_bss_end+0xe383b0>
    1230:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
    1234:	341d0000 	ldrcc	r0, [sp], #-0
    1238:	3a080300 	bcc	201e40 <_bss_end+0x1f62d0>
    123c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    1240:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
    1244:	1e000018 	mcrne	0, 0, r0, cr0, cr8, {0}
    1248:	0111010b 	tsteq	r1, fp, lsl #2
    124c:	00000612 	andeq	r0, r0, r2, lsl r6
    1250:	0300341f 	movweq	r3, #1055	; 0x41f
    1254:	3b0b3a0e 	blcc	2cfa94 <_bss_end+0x2c3f24>
    1258:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
    125c:	00180213 	andseq	r0, r8, r3, lsl r2
    1260:	012e2000 			; <UNDEFINED> instruction: 0x012e2000
    1264:	0b3a1347 	bleq	e85f88 <_bss_end+0xe7a418>
    1268:	13640b39 	cmnne	r4, #58368	; 0xe400
    126c:	06120111 			; <UNDEFINED> instruction: 0x06120111
    1270:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
    1274:	00130119 	andseq	r0, r3, r9, lsl r1
    1278:	012e2100 			; <UNDEFINED> instruction: 0x012e2100
    127c:	0b3a1347 	bleq	e85fa0 <_bss_end+0xe7a430>
    1280:	0b390b3b 	bleq	e43f74 <_bss_end+0xe38404>
    1284:	0b201364 	bleq	80601c <_bss_end+0x7fa4ac>
    1288:	00001301 	andeq	r1, r0, r1, lsl #6
    128c:	03000522 	movweq	r0, #1314	; 0x522
    1290:	3413490e 	ldrcc	r4, [r3], #-2318	; 0xfffff6f2
    1294:	23000019 	movwcs	r0, #25
    1298:	0000010b 	andeq	r0, r0, fp, lsl #2
    129c:	03003424 	movweq	r3, #1060	; 0x424
    12a0:	3b0b3a08 	blcc	2cfac8 <_bss_end+0x2c3f58>
    12a4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
    12a8:	25000013 	strcs	r0, [r0, #-19]	; 0xffffffed
    12ac:	1331012e 	teqne	r1, #-2147483637	; 0x8000000b
    12b0:	13640e6e 	cmnne	r4, #1760	; 0x6e0
    12b4:	06120111 			; <UNDEFINED> instruction: 0x06120111
    12b8:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
    12bc:	26000019 			; <UNDEFINED> instruction: 0x26000019
    12c0:	13310005 	teqne	r1, #5
    12c4:	00001802 	andeq	r1, r0, r2, lsl #16
    12c8:	31010b27 	tstcc	r1, r7, lsr #22
    12cc:	00130113 	andseq	r0, r3, r3, lsl r1
    12d0:	00342800 	eorseq	r2, r4, r0, lsl #16
    12d4:	00001331 	andeq	r1, r0, r1, lsr r3
    12d8:	31010b29 	tstcc	r1, r9, lsr #22
    12dc:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
    12e0:	2a000006 	bcs	1300 <CPSR_IRQ_INHIBIT+0x1280>
    12e4:	13310034 	teqne	r1, #52	; 0x34
    12e8:	00001802 	andeq	r1, r0, r2, lsl #16
    12ec:	01110100 	tsteq	r1, r0, lsl #2
    12f0:	0b130e25 	bleq	4c4b8c <_bss_end+0x4b901c>
    12f4:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
    12f8:	01111755 	tsteq	r1, r5, asr r7
    12fc:	00001710 	andeq	r1, r0, r0, lsl r7
    1300:	0b002402 	bleq	a310 <_c_startup+0x24>
    1304:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
    1308:	0300000e 	movweq	r0, #14
    130c:	13490026 	movtne	r0, #36902	; 0x9026
    1310:	24040000 	strcs	r0, [r4], #-0
    1314:	3e0b0b00 	vmlacc.f64	d0, d11, d0
    1318:	0008030b 	andeq	r0, r8, fp, lsl #6
    131c:	00160500 	andseq	r0, r6, r0, lsl #10
    1320:	0b3a0e03 	bleq	e84b34 <_bss_end+0xe78fc4>
    1324:	0b390b3b 	bleq	e44018 <_bss_end+0xe384a8>
    1328:	00001349 	andeq	r1, r0, r9, asr #6
    132c:	49003506 	stmdbmi	r0, {r1, r2, r8, sl, ip, sp}
    1330:	07000013 	smladeq	r0, r3, r0, r0
    1334:	0e030104 	adfeqs	f0, f3, f4
    1338:	0b3e196d 	bleq	f878f4 <_bss_end+0xf7bd84>
    133c:	13490b0b 	movtne	r0, #39691	; 0x9b0b
    1340:	0b3b0b3a 	bleq	ec4030 <_bss_end+0xeb84c0>
    1344:	13010b39 	movwne	r0, #6969	; 0x1b39
    1348:	28080000 	stmdacs	r8, {}	; <UNPREDICTABLE>
    134c:	1c080300 	stcne	3, cr0, [r8], {-0}
    1350:	0900000b 	stmdbeq	r0, {r0, r1, r3}
    1354:	0e030028 	cdpeq	0, 0, cr0, cr3, cr8, {1}
    1358:	00000b1c 	andeq	r0, r0, ip, lsl fp
    135c:	0301130a 	movweq	r1, #4874	; 0x130a
    1360:	3a0b0b0e 	bcc	2c3fa0 <_bss_end+0x2b8430>
    1364:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    1368:	0013010b 	andseq	r0, r3, fp, lsl #2
    136c:	000d0b00 	andeq	r0, sp, r0, lsl #22
    1370:	0b3a0803 	bleq	e83384 <_bss_end+0xe77814>
    1374:	0b390b3b 	bleq	e44068 <_bss_end+0xe384f8>
    1378:	0b381349 	bleq	e060a4 <_bss_end+0xdfa534>
    137c:	0d0c0000 	stceq	0, cr0, [ip, #-0]
    1380:	3a0e0300 	bcc	381f88 <_bss_end+0x376418>
    1384:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    1388:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
    138c:	0d00000b 	stceq	0, cr0, [r0, #-44]	; 0xffffffd4
    1390:	0b0b000f 	bleq	2c13d4 <_bss_end+0x2b5864>
    1394:	00001349 	andeq	r1, r0, r9, asr #6
    1398:	0301020e 	movweq	r0, #4622	; 0x120e
    139c:	3a0b0b0e 	bcc	2c3fdc <_bss_end+0x2b846c>
    13a0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    13a4:	0013010b 	andseq	r0, r3, fp, lsl #2
    13a8:	012e0f00 			; <UNDEFINED> instruction: 0x012e0f00
    13ac:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
    13b0:	0b3b0b3a 	bleq	ec40a0 <_bss_end+0xeb8530>
    13b4:	0e6e0b39 	vmoveq.8	d14[5], r0
    13b8:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
    13bc:	00001301 	andeq	r1, r0, r1, lsl #6
    13c0:	49000510 	stmdbmi	r0, {r4, r8, sl}
    13c4:	00193413 	andseq	r3, r9, r3, lsl r4
    13c8:	00051100 	andeq	r1, r5, r0, lsl #2
    13cc:	00001349 	andeq	r1, r0, r9, asr #6
    13d0:	3f012e12 	svccc	0x00012e12
    13d4:	3a0e0319 	bcc	382040 <_bss_end+0x3764d0>
    13d8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    13dc:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
    13e0:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
    13e4:	01136419 	tsteq	r3, r9, lsl r4
    13e8:	13000013 	movwne	r0, #19
    13ec:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
    13f0:	0b3a0e03 	bleq	e84c04 <_bss_end+0xe79094>
    13f4:	0b390b3b 	bleq	e440e8 <_bss_end+0xe38578>
    13f8:	0b320e6e 	bleq	c84db8 <_bss_end+0xc79248>
    13fc:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
    1400:	00001301 	andeq	r1, r0, r1, lsl #6
    1404:	3f012e14 	svccc	0x00012e14
    1408:	3a0e0319 	bcc	382074 <_bss_end+0x376504>
    140c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    1410:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
    1414:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
    1418:	00136419 	andseq	r6, r3, r9, lsl r4
    141c:	00341500 	eorseq	r1, r4, r0, lsl #10
    1420:	0b3a0e03 	bleq	e84c34 <_bss_end+0xe790c4>
    1424:	0b390b3b 	bleq	e44118 <_bss_end+0xe385a8>
    1428:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
    142c:	0000193c 	andeq	r1, r0, ip, lsr r9
    1430:	03010416 	movweq	r0, #5142	; 0x1416
    1434:	3e196d0e 	cdpcc	13, 1, cr6, cr9, cr14, {0}
    1438:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
    143c:	3b0b3a13 	blcc	2cfc90 <_bss_end+0x2c4120>
    1440:	320b390b 	andcc	r3, fp, #180224	; 0x2c000
    1444:	0013010b 	andseq	r0, r3, fp, lsl #2
    1448:	000d1700 	andeq	r1, sp, r0, lsl #14
    144c:	0b3a0e03 	bleq	e84c60 <_bss_end+0xe790f0>
    1450:	0b390b3b 	bleq	e44144 <_bss_end+0xe385d4>
    1454:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
    1458:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
    145c:	196c0b1c 	stmdbne	ip!, {r2, r3, r4, r8, r9, fp}^
    1460:	0d180000 	ldceq	0, cr0, [r8, #-0]
    1464:	3a0e0300 	bcc	38206c <_bss_end+0x3764fc>
    1468:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    146c:	3f13490b 	svccc	0x0013490b
    1470:	3c0b3219 	sfmcc	f3, 4, [fp], {25}
    1474:	00196c19 	andseq	r6, r9, r9, lsl ip
    1478:	012e1900 			; <UNDEFINED> instruction: 0x012e1900
    147c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
    1480:	0b3b0b3a 	bleq	ec4170 <_bss_end+0xeb8600>
    1484:	0e6e0b39 	vmoveq.8	d14[5], r0
    1488:	0b321349 	bleq	c861b4 <_bss_end+0xc7a644>
    148c:	1963193c 	stmdbne	r3!, {r2, r3, r4, r5, r8, fp, ip}^
    1490:	13011364 	movwne	r1, #4964	; 0x1364
    1494:	101a0000 	andsne	r0, sl, r0
    1498:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
    149c:	1b000013 	blne	14f0 <CPSR_IRQ_INHIBIT+0x1470>
    14a0:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
    14a4:	0b3a0e03 	bleq	e84cb8 <_bss_end+0xe79148>
    14a8:	0b390b3b 	bleq	e4419c <_bss_end+0xe3862c>
    14ac:	13490e6e 	movtne	r0, #40558	; 0x9e6e
    14b0:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
    14b4:	00001301 	andeq	r1, r0, r1, lsl #6
    14b8:	03002f1c 	movweq	r2, #3868	; 0xf1c
    14bc:	00134908 	andseq	r4, r3, r8, lsl #18
    14c0:	000f1d00 	andeq	r1, pc, r0, lsl #26
    14c4:	00000b0b 	andeq	r0, r0, fp, lsl #22
    14c8:	0301391e 	movweq	r3, #6430	; 0x191e
    14cc:	3b0b3a08 	blcc	2cfcf4 <_bss_end+0x2c4184>
    14d0:	010b390b 	tsteq	fp, fp, lsl #18
    14d4:	1f000013 	svcne	0x00000013
    14d8:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
    14dc:	0b3b0b3a 	bleq	ec41cc <_bss_end+0xeb865c>
    14e0:	13490b39 	movtne	r0, #39737	; 0x9b39
    14e4:	061c193c 			; <UNDEFINED> instruction: 0x061c193c
    14e8:	0000196c 	andeq	r1, r0, ip, ror #18
    14ec:	03003420 	movweq	r3, #1056	; 0x420
    14f0:	3b0b3a0e 	blcc	2cfd30 <_bss_end+0x2c41c0>
    14f4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
    14f8:	1c193c13 	ldcne	12, cr3, [r9], {19}
    14fc:	00196c0b 	andseq	r6, r9, fp, lsl #24
    1500:	00342100 	eorseq	r2, r4, r0, lsl #2
    1504:	00001347 	andeq	r1, r0, r7, asr #6
    1508:	03003422 	movweq	r3, #1058	; 0x422
    150c:	3b0b3a0e 	blcc	2cfd4c <_bss_end+0x2c41dc>
    1510:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
    1514:	1c193c13 	ldcne	12, cr3, [r9], {19}
    1518:	00196c05 	andseq	r6, r9, r5, lsl #24
    151c:	01022300 	mrseq	r2, LR_svc
    1520:	050b0e03 	streq	r0, [fp, #-3587]	; 0xfffff1fd
    1524:	0b3b0b3a 	bleq	ec4214 <_bss_end+0xeb86a4>
    1528:	13010b39 	movwne	r0, #6969	; 0x1b39
    152c:	2e240000 	cdpcs	0, 2, cr0, cr4, cr0, {0}
    1530:	03193f01 	tsteq	r9, #1, 30
    1534:	3b0b3a0e 	blcc	2cfd74 <_bss_end+0x2c4204>
    1538:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
    153c:	3c0b320e 	sfmcc	f3, 4, [fp], {14}
    1540:	00136419 	andseq	r6, r3, r9, lsl r4
    1544:	01012500 	tsteq	r1, r0, lsl #10
    1548:	13011349 	movwne	r1, #4937	; 0x1349
    154c:	21260000 			; <UNDEFINED> instruction: 0x21260000
    1550:	2f134900 	svccs	0x00134900
    1554:	27000005 	strcs	r0, [r0, -r5]
    1558:	13470034 	movtne	r0, #28724	; 0x7034
    155c:	0b3b0b3a 	bleq	ec424c <_bss_end+0xeb86dc>
    1560:	18020b39 	stmdane	r2, {r0, r3, r4, r5, r8, r9, fp}
    1564:	2e280000 	cdpcs	0, 2, cr0, cr8, cr0, {0}
    1568:	340e0300 	strcc	r0, [lr], #-768	; 0xfffffd00
    156c:	12011119 	andne	r1, r1, #1073741830	; 0x40000006
    1570:	96184006 	ldrls	r4, [r8], -r6
    1574:	00001942 	andeq	r1, r0, r2, asr #18
    1578:	03012e29 	movweq	r2, #7721	; 0x1e29
    157c:	1119340e 	tstne	r9, lr, lsl #8
    1580:	40061201 	andmi	r1, r6, r1, lsl #4
    1584:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
    1588:	00001301 	andeq	r1, r0, r1, lsl #6
    158c:	0300052a 	movweq	r0, #1322	; 0x52a
    1590:	3b0b3a0e 	blcc	2cfdd0 <_bss_end+0x2c4260>
    1594:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
    1598:	00180213 	andseq	r0, r8, r3, lsl r2
    159c:	012e2b00 			; <UNDEFINED> instruction: 0x012e2b00
    15a0:	13641347 	cmnne	r4, #469762049	; 0x1c000001
    15a4:	06120111 			; <UNDEFINED> instruction: 0x06120111
    15a8:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
    15ac:	00130119 	andseq	r0, r3, r9, lsl r1
    15b0:	00052c00 	andeq	r2, r5, r0, lsl #24
    15b4:	13490e03 	movtne	r0, #40451	; 0x9e03
    15b8:	18021934 	stmdane	r2, {r2, r4, r5, r8, fp, ip}
    15bc:	2e2d0000 	cdpcs	0, 2, cr0, cr13, cr0, {0}
    15c0:	3a134701 	bcc	4d31cc <_bss_end+0x4c765c>
    15c4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    15c8:	1113640b 	tstne	r3, fp, lsl #8
    15cc:	40061201 	andmi	r1, r6, r1, lsl #4
    15d0:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
    15d4:	00001301 	andeq	r1, r0, r1, lsl #6
    15d8:	0300342e 	movweq	r3, #1070	; 0x42e
    15dc:	3b0b3a08 	blcc	2cfe04 <_bss_end+0x2c4294>
    15e0:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
    15e4:	00180213 	andseq	r0, r8, r3, lsl r2
    15e8:	00342f00 	eorseq	r2, r4, r0, lsl #30
    15ec:	0b3a0e03 	bleq	e84e00 <_bss_end+0xe79290>
    15f0:	0b390b3b 	bleq	e442e4 <_bss_end+0xe38774>
    15f4:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
    15f8:	2e300000 	cdpcs	0, 3, cr0, cr0, cr0, {0}
    15fc:	3a134701 	bcc	4d3208 <_bss_end+0x4c7698>
    1600:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    1604:	1113640b 	tstne	r3, fp, lsl #8
    1608:	40061201 	andmi	r1, r6, r1, lsl #4
    160c:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
    1610:	00001301 	andeq	r1, r0, r1, lsl #6
    1614:	47012e31 	smladxmi	r1, r1, lr, r2
    1618:	3b0b3a13 	blcc	2cfe6c <_bss_end+0x2c42fc>
    161c:	640b390b 	strvs	r3, [fp], #-2315	; 0xfffff6f5
    1620:	010b2013 	tsteq	fp, r3, lsl r0
    1624:	32000013 	andcc	r0, r0, #19
    1628:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
    162c:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
    1630:	2e330000 	cdpcs	0, 3, cr0, cr3, cr0, {0}
    1634:	6e133101 	mufvss	f3, f3, f1
    1638:	1113640e 	tstne	r3, lr, lsl #8
    163c:	40061201 	andmi	r1, r6, r1, lsl #4
    1640:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
    1644:	05340000 	ldreq	r0, [r4, #-0]!
    1648:	02133100 	andseq	r3, r3, #0, 2
    164c:	00000018 	andeq	r0, r0, r8, lsl r0
    1650:	10001101 	andne	r1, r0, r1, lsl #2
    1654:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
    1658:	1b0e0301 	blne	382264 <_bss_end+0x3766f4>
    165c:	130e250e 	movwne	r2, #58638	; 0xe50e
    1660:	00000005 	andeq	r0, r0, r5
    1664:	10001101 	andne	r1, r0, r1, lsl #2
    1668:	03065506 	movweq	r5, #25862	; 0x6506
    166c:	250e1b0e 	strcs	r1, [lr, #-2830]	; 0xfffff4f2
    1670:	0005130e 	andeq	r1, r5, lr, lsl #6
    1674:	11010000 	mrsne	r0, (UNDEF: 1)
    1678:	130e2501 	movwne	r2, #58625	; 0xe501
    167c:	1b0e030b 	blne	3822b0 <_bss_end+0x376740>
    1680:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
    1684:	00171006 	andseq	r1, r7, r6
    1688:	00160200 	andseq	r0, r6, r0, lsl #4
    168c:	0b3a0e03 	bleq	e84ea0 <_bss_end+0xe79330>
    1690:	0b390b3b 	bleq	e44384 <_bss_end+0xe38814>
    1694:	00001349 	andeq	r1, r0, r9, asr #6
    1698:	0b000f03 	bleq	52ac <CPSR_IRQ_INHIBIT+0x522c>
    169c:	0013490b 	andseq	r4, r3, fp, lsl #18
    16a0:	00150400 	andseq	r0, r5, r0, lsl #8
    16a4:	34050000 	strcc	r0, [r5], #-0
    16a8:	3a0e0300 	bcc	3822b0 <_bss_end+0x376740>
    16ac:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    16b0:	3f13490b 	svccc	0x0013490b
    16b4:	00193c19 	andseq	r3, r9, r9, lsl ip
    16b8:	00240600 	eoreq	r0, r4, r0, lsl #12
    16bc:	0b3e0b0b 	bleq	f842f0 <_bss_end+0xf78780>
    16c0:	00000803 	andeq	r0, r0, r3, lsl #16
    16c4:	49010107 	stmdbmi	r1, {r0, r1, r2, r8}
    16c8:	00130113 	andseq	r0, r3, r3, lsl r1
    16cc:	00210800 	eoreq	r0, r1, r0, lsl #16
    16d0:	062f1349 	strteq	r1, [pc], -r9, asr #6
    16d4:	24090000 	strcs	r0, [r9], #-0
    16d8:	3e0b0b00 	vmlacc.f64	d0, d11, d0
    16dc:	000e030b 	andeq	r0, lr, fp, lsl #6
    16e0:	012e0a00 			; <UNDEFINED> instruction: 0x012e0a00
    16e4:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
    16e8:	0b3b0b3a 	bleq	ec43d8 <_bss_end+0xeb8868>
    16ec:	13490b39 	movtne	r0, #39737	; 0x9b39
    16f0:	06120111 			; <UNDEFINED> instruction: 0x06120111
    16f4:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
    16f8:	00130119 	andseq	r0, r3, r9, lsl r1
    16fc:	00340b00 	eorseq	r0, r4, r0, lsl #22
    1700:	0b3a0e03 	bleq	e84f14 <_bss_end+0xe793a4>
    1704:	0b390b3b 	bleq	e443f8 <_bss_end+0xe38888>
    1708:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
    170c:	2e0c0000 	cdpcs	0, 0, cr0, cr12, cr0, {0}
    1710:	03193f01 	tsteq	r9, #1, 30
    1714:	3b0b3a0e 	blcc	2cff54 <_bss_end+0x2c43e4>
    1718:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
    171c:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
    1720:	97184006 	ldrls	r4, [r8, -r6]
    1724:	13011942 	movwne	r1, #6466	; 0x1942
    1728:	340d0000 	strcc	r0, [sp], #-0
    172c:	3a080300 	bcc	202334 <_bss_end+0x1f67c4>
    1730:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    1734:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
    1738:	00000018 	andeq	r0, r0, r8, lsl r0
    173c:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
    1740:	030b130e 	movweq	r1, #45838	; 0xb30e
    1744:	110e1b0e 	tstne	lr, lr, lsl #22
    1748:	10061201 	andne	r1, r6, r1, lsl #4
    174c:	02000017 	andeq	r0, r0, #23
    1750:	13010139 	movwne	r0, #4409	; 0x1139
    1754:	34030000 	strcc	r0, [r3], #-0
    1758:	3a0e0300 	bcc	382360 <_bss_end+0x3767f0>
    175c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    1760:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
    1764:	000a1c19 	andeq	r1, sl, r9, lsl ip
    1768:	003a0400 	eorseq	r0, sl, r0, lsl #8
    176c:	0b3b0b3a 	bleq	ec445c <_bss_end+0xeb88ec>
    1770:	13180b39 	tstne	r8, #58368	; 0xe400
    1774:	01050000 	mrseq	r0, (UNDEF: 5)
    1778:	01134901 	tsteq	r3, r1, lsl #18
    177c:	06000013 			; <UNDEFINED> instruction: 0x06000013
    1780:	13490021 	movtne	r0, #36897	; 0x9021
    1784:	00000b2f 	andeq	r0, r0, pc, lsr #22
    1788:	49002607 	stmdbmi	r0, {r0, r1, r2, r9, sl, sp}
    178c:	08000013 	stmdaeq	r0, {r0, r1, r4}
    1790:	0b0b0024 	bleq	2c1828 <_bss_end+0x2b5cb8>
    1794:	0e030b3e 	vmoveq.16	d3[0], r0
    1798:	34090000 	strcc	r0, [r9], #-0
    179c:	00134700 	andseq	r4, r3, r0, lsl #14
    17a0:	012e0a00 			; <UNDEFINED> instruction: 0x012e0a00
    17a4:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
    17a8:	0b3b0b3a 	bleq	ec4498 <_bss_end+0xeb8928>
    17ac:	0e6e0b39 	vmoveq.8	d14[5], r0
    17b0:	06120111 			; <UNDEFINED> instruction: 0x06120111
    17b4:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
    17b8:	00130119 	andseq	r0, r3, r9, lsl r1
    17bc:	00050b00 	andeq	r0, r5, r0, lsl #22
    17c0:	0b3a0e03 	bleq	e84fd4 <_bss_end+0xe79464>
    17c4:	0b390b3b 	bleq	e444b8 <_bss_end+0xe38948>
    17c8:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
    17cc:	340c0000 	strcc	r0, [ip], #-0
    17d0:	3a080300 	bcc	2023d8 <_bss_end+0x1f6868>
    17d4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    17d8:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
    17dc:	0d000018 	stceq	0, cr0, [r0, #-96]	; 0xffffffa0
    17e0:	0111010b 	tsteq	r1, fp, lsl #2
    17e4:	00000612 	andeq	r0, r0, r2, lsl r6
    17e8:	0b000f0e 	bleq	5428 <CPSR_IRQ_INHIBIT+0x53a8>
    17ec:	0013490b 	andseq	r4, r3, fp, lsl #18
    17f0:	00240f00 	eoreq	r0, r4, r0, lsl #30
    17f4:	0b3e0b0b 	bleq	f84428 <_bss_end+0xf788b8>
    17f8:	00000803 	andeq	r0, r0, r3, lsl #16
    17fc:	00110100 	andseq	r0, r1, r0, lsl #2
    1800:	01110610 	tsteq	r1, r0, lsl r6
    1804:	0e030112 	mcreq	1, 0, r0, cr3, cr2, {0}
    1808:	0e250e1b 	mcreq	14, 1, r0, cr5, cr11, {0}
    180c:	00000513 	andeq	r0, r0, r3, lsl r5
    1810:	00110100 	andseq	r0, r1, r0, lsl #2
    1814:	01110610 	tsteq	r1, r0, lsl r6
    1818:	0e030112 	mcreq	1, 0, r0, cr3, cr2, {0}
    181c:	0e250e1b 	mcreq	14, 1, r0, cr5, cr11, {0}
    1820:	00000513 	andeq	r0, r0, r3, lsl r5
    1824:	01110100 	tsteq	r1, r0, lsl #2
    1828:	0b130e25 	bleq	4c50c4 <_bss_end+0x4b9554>
    182c:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
    1830:	00001710 	andeq	r1, r0, r0, lsl r7
    1834:	0b002402 	bleq	a844 <__aeabi_idiv0+0xc0>
    1838:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
    183c:	03000008 	movweq	r0, #8
    1840:	0b0b0024 	bleq	2c18d8 <_bss_end+0x2b5d68>
    1844:	0e030b3e 	vmoveq.16	d3[0], r0
    1848:	16040000 	strne	r0, [r4], -r0
    184c:	3a0e0300 	bcc	382454 <_bss_end+0x3768e4>
    1850:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    1854:	0013490b 	andseq	r4, r3, fp, lsl #18
    1858:	000f0500 	andeq	r0, pc, r0, lsl #10
    185c:	13490b0b 	movtne	r0, #39691	; 0x9b0b
    1860:	15060000 	strne	r0, [r6, #-0]
    1864:	49192701 	ldmdbmi	r9, {r0, r8, r9, sl, sp}
    1868:	00130113 	andseq	r0, r3, r3, lsl r1
    186c:	00050700 	andeq	r0, r5, r0, lsl #14
    1870:	00001349 	andeq	r1, r0, r9, asr #6
    1874:	00002608 	andeq	r2, r0, r8, lsl #12
    1878:	00340900 	eorseq	r0, r4, r0, lsl #18
    187c:	0b3a0e03 	bleq	e85090 <_bss_end+0xe79520>
    1880:	0b390b3b 	bleq	e44574 <_bss_end+0xe38a04>
    1884:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
    1888:	0000193c 	andeq	r1, r0, ip, lsr r9
    188c:	0301040a 	movweq	r0, #5130	; 0x140a
    1890:	0b0b3e0e 	bleq	2d10d0 <_bss_end+0x2c5560>
    1894:	3a13490b 	bcc	4d3cc8 <_bss_end+0x4c8158>
    1898:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    189c:	0013010b 	andseq	r0, r3, fp, lsl #2
    18a0:	00280b00 	eoreq	r0, r8, r0, lsl #22
    18a4:	0b1c0e03 	bleq	7050b8 <_bss_end+0x6f9548>
    18a8:	010c0000 	mrseq	r0, (UNDEF: 12)
    18ac:	01134901 	tsteq	r3, r1, lsl #18
    18b0:	0d000013 	stceq	0, cr0, [r0, #-76]	; 0xffffffb4
    18b4:	00000021 	andeq	r0, r0, r1, lsr #32
    18b8:	4900260e 	stmdbmi	r0, {r1, r2, r3, r9, sl, sp}
    18bc:	0f000013 	svceq	0x00000013
    18c0:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
    18c4:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
    18c8:	13490b39 	movtne	r0, #39737	; 0x9b39
    18cc:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
    18d0:	13100000 	tstne	r0, #0
    18d4:	3c0e0300 	stccc	3, cr0, [lr], {-0}
    18d8:	11000019 	tstne	r0, r9, lsl r0
    18dc:	19270015 	stmdbne	r7!, {r0, r2, r4}
    18e0:	17120000 	ldrne	r0, [r2, -r0]
    18e4:	3c0e0300 	stccc	3, cr0, [lr], {-0}
    18e8:	13000019 	movwne	r0, #25
    18ec:	0e030113 	mcreq	1, 0, r0, cr3, cr3, {0}
    18f0:	0b3a0b0b 	bleq	e84524 <_bss_end+0xe789b4>
    18f4:	0b39053b 	bleq	e42de8 <_bss_end+0xe37278>
    18f8:	00001301 	andeq	r1, r0, r1, lsl #6
    18fc:	03000d14 	movweq	r0, #3348	; 0xd14
    1900:	3b0b3a0e 	blcc	2d0140 <_bss_end+0x2c45d0>
    1904:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
    1908:	000b3813 	andeq	r3, fp, r3, lsl r8
    190c:	00211500 	eoreq	r1, r1, r0, lsl #10
    1910:	0b2f1349 	bleq	bc663c <_bss_end+0xbbaacc>
    1914:	04160000 	ldreq	r0, [r6], #-0
    1918:	3e0e0301 	cdpcc	3, 0, cr0, cr14, cr1, {0}
    191c:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
    1920:	3b0b3a13 	blcc	2d0174 <_bss_end+0x2c4604>
    1924:	010b3905 	tsteq	fp, r5, lsl #18
    1928:	17000013 	smladne	r0, r3, r0, r0
    192c:	13470034 	movtne	r0, #28724	; 0x7034
    1930:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
    1934:	18020b39 	stmdane	r2, {r0, r3, r4, r5, r8, r9, fp}
    1938:	Address 0x0000000000001938 is out of bounds.


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
  40:	00000034 	andeq	r0, r0, r4, lsr r0
  44:	08850002 	stmeq	r5, {r1}
  48:	00040000 	andeq	r0, r4, r0
  4c:	00000000 	andeq	r0, r0, r0
  50:	000086b4 			; <UNDEFINED> instruction: 0x000086b4
  54:	00000648 	andeq	r0, r0, r8, asr #12
  58:	00008cfc 	strdeq	r8, [r0], -ip
  5c:	00000038 	andeq	r0, r0, r8, lsr r0
  60:	00008d34 	andeq	r8, r0, r4, lsr sp
  64:	00000088 	andeq	r0, r0, r8, lsl #1
  68:	00008dbc 			; <UNDEFINED> instruction: 0x00008dbc
  6c:	0000002c 	andeq	r0, r0, ip, lsr #32
	...
  78:	0000001c 	andeq	r0, r0, ip, lsl r0
  7c:	0f3d0002 	svceq	0x003d0002
  80:	00040000 	andeq	r0, r4, r0
  84:	00000000 	andeq	r0, r0, r0
  88:	00008de8 	andeq	r8, r0, r8, ror #27
  8c:	00000290 	muleq	r0, r0, r2
	...
  98:	0000001c 	andeq	r0, r0, ip, lsl r0
  9c:	14900002 	ldrne	r0, [r0], #2
  a0:	00040000 	andeq	r0, r4, r0
  a4:	00000000 	andeq	r0, r0, r0
  a8:	00009078 	andeq	r9, r0, r8, ror r0
  ac:	0000025c 	andeq	r0, r0, ip, asr r2
	...
  b8:	0000001c 	andeq	r0, r0, ip, lsl r0
  bc:	1b2b0002 	blne	ac00cc <_bss_end+0xab455c>
  c0:	00040000 	andeq	r0, r4, r0
  c4:	00000000 	andeq	r0, r0, r0
  c8:	000092d4 	ldrdeq	r9, [r0], -r4
  cc:	000002e8 	andeq	r0, r0, r8, ror #5
	...
  d8:	0000001c 	andeq	r0, r0, ip, lsl r0
  dc:	28700002 	ldmdacs	r0!, {r1}^
  e0:	00040000 	andeq	r0, r4, r0
  e4:	00000000 	andeq	r0, r0, r0
  e8:	000095bc 			; <UNDEFINED> instruction: 0x000095bc
  ec:	0000036c 	andeq	r0, r0, ip, ror #6
	...
  f8:	0000001c 	andeq	r0, r0, ip, lsl r0
  fc:	2d130002 	ldccs	0, cr0, [r3, #-8]
 100:	00040000 	andeq	r0, r4, r0
 104:	00000000 	andeq	r0, r0, r0
 108:	00009928 	andeq	r9, r0, r8, lsr #18
 10c:	000002a4 	andeq	r0, r0, r4, lsr #5
	...
 118:	0000002c 	andeq	r0, r0, ip, lsr #32
 11c:	30f70002 	rscscc	r0, r7, r2
 120:	00040000 	andeq	r0, r4, r0
 124:	00000000 	andeq	r0, r0, r0
 128:	00009bcc 	andeq	r9, r0, ip, asr #23
 12c:	0000061c 	andeq	r0, r0, ip, lsl r6
 130:	0000a1e8 	andeq	sl, r0, r8, ror #3
 134:	0000002c 	andeq	r0, r0, ip, lsr #32
 138:	0000a214 	andeq	sl, r0, r4, lsl r2
 13c:	0000002c 	andeq	r0, r0, ip, lsr #32
	...
 148:	0000001c 	andeq	r0, r0, ip, lsl r0
 14c:	3b380002 	blcc	e0015c <_bss_end+0xdf45ec>
 150:	00040000 	andeq	r0, r4, r0
 154:	00000000 	andeq	r0, r0, r0
 158:	0000a240 	andeq	sl, r0, r0, asr #4
 15c:	0000005c 	andeq	r0, r0, ip, asr r0
	...
 168:	00000024 	andeq	r0, r0, r4, lsr #32
 16c:	3b5e0002 	blcc	178017c <_bss_end+0x177460c>
 170:	00040000 	andeq	r0, r4, r0
 174:	00000000 	andeq	r0, r0, r0
 178:	00008000 	andeq	r8, r0, r0
 17c:	000000ac 	andeq	r0, r0, ip, lsr #1
 180:	0000a29c 	muleq	r0, ip, r2
 184:	00000050 	andeq	r0, r0, r0, asr r0
	...
 190:	0000001c 	andeq	r0, r0, ip, lsl r0
 194:	3b800002 	blcc	fe0001a4 <_bss_end+0xfdff4634>
 198:	00040000 	andeq	r0, r4, r0
 19c:	00000000 	andeq	r0, r0, r0
 1a0:	0000a2ec 	andeq	sl, r0, ip, ror #5
 1a4:	00000118 	andeq	r0, r0, r8, lsl r1
	...
 1b0:	0000001c 	andeq	r0, r0, ip, lsl r0
 1b4:	3ccf0002 	stclcc	0, cr0, [pc], {2}
 1b8:	00040000 	andeq	r0, r4, r0
 1bc:	00000000 	andeq	r0, r0, r0
 1c0:	0000a404 	andeq	sl, r0, r4, lsl #8
 1c4:	00000174 	andeq	r0, r0, r4, ror r1
	...
 1d0:	0000001c 	andeq	r0, r0, ip, lsl r0
 1d4:	3dde0002 	ldclcc	0, cr0, [lr, #8]
 1d8:	00040000 	andeq	r0, r4, r0
 1dc:	00000000 	andeq	r0, r0, r0
 1e0:	0000a578 	andeq	sl, r0, r8, ror r5
 1e4:	0000020c 	andeq	r0, r0, ip, lsl #4
	...
 1f0:	0000001c 	andeq	r0, r0, ip, lsl r0
 1f4:	3e040002 	cdpcc	0, 0, cr0, cr4, cr2, {0}
 1f8:	00040000 	andeq	r0, r4, r0
 1fc:	00000000 	andeq	r0, r0, r0
 200:	0000a784 	andeq	sl, r0, r4, lsl #15
 204:	00000004 	andeq	r0, r0, r4
	...
 210:	00000014 	andeq	r0, r0, r4, lsl r0
 214:	3e2a0002 	cdpcc	0, 2, cr0, cr10, cr2, {0}
 218:	00040000 	andeq	r0, r4, r0
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
      2c:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; fffffe94 <_bss_end+0xffff4324>
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
      84:	02050005 	andeq	r0, r5, #5
      88:	000080ac 	andeq	r8, r0, ip, lsr #1
      8c:	05010a03 	streq	r0, [r1, #-2563]	; 0xfffff5fd
      90:	10058311 	andne	r8, r5, r1, lsl r3
      94:	8305054a 	movwhi	r0, #21834	; 0x554a
      98:	83130585 	tsthi	r3, #557842432	; 0x21400000
      9c:	85670505 	strbhi	r0, [r7, #-1285]!	; 0xfffffafb
      a0:	86010583 	strhi	r0, [r1], -r3, lsl #11
      a4:	854c854c 	strbhi	r8, [ip, #-1356]	; 0xfffffab4
      a8:	0505854c 	streq	r8, [r5, #-1356]	; 0xfffffab4
      ac:	01040200 	mrseq	r0, R12_usr
      b0:	0002024b 	andeq	r0, r2, fp, asr #4
      b4:	03130101 	tsteq	r3, #1073741824	; 0x40000000
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
      e4:	5a2f6c6f 	bpl	bdb2a8 <_bss_end+0xbcf738>
      e8:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; ffffff5c <_bss_end+0xffff43ec>
      ec:	2f657461 	svccs	0x00657461
      f0:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
      f4:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
      f8:	2d33312f 	ldfcss	f3, [r3, #-188]!	; 0xffffff44
      fc:	746e6f63 	strbtvc	r6, [lr], #-3939	; 0xfffff09d
     100:	5f747865 	svcpl	0x00747865
     104:	74697773 	strbtvc	r7, [r9], #-1907	; 0xfffff88d
     108:	6d5f6863 	ldclvs	8, cr6, [pc, #-396]	; ffffff84 <_bss_end+0xffff4414>
     10c:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
     110:	6b2f726f 	blvs	bdcad4 <_bss_end+0xbd0f64>
     114:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
     118:	72732f6c 	rsbsvc	r2, r3, #108, 30	; 0x1b0
     11c:	72642f63 	rsbvc	r2, r4, #396	; 0x18c
     120:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
     124:	682f0073 	stmdavs	pc!, {r0, r1, r4, r5, r6}	; <UNPREDICTABLE>
     128:	2f656d6f 	svccs	0x00656d6f
     12c:	686c6973 	stmdavs	ip!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
     130:	6a797661 	bvs	1e5dabc <_bss_end+0x1e51f4c>
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
     190:	6a797661 	bvs	1e5db1c <_bss_end+0x1e51fac>
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
     21c:	09051700 	stmdbeq	r5, {r8, r9, sl, ip}
     220:	2e38059f 	mrccs	5, 1, r0, cr8, cr15, {4}
     224:	a14d0105 	cmpge	sp, r5, lsl #2
     228:	05d70505 	ldrbeq	r0, [r7, #1285]	; 0x505
     22c:	0f056710 	svceq	0x00056710
     230:	8209054c 	andhi	r0, r9, #76, 10	; 0x13000000
     234:	0b031405 	bleq	c5250 <_bss_end+0xb96e0>
     238:	081a054a 	ldmdaeq	sl, {r1, r3, r6, r8, sl}
     23c:	660d0520 	strvs	r0, [sp], -r0, lsr #10
     240:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
     244:	05a12f01 	streq	r2, [r1, #3841]!	; 0xf01
     248:	1005d705 	andne	sp, r5, r5, lsl #14
     24c:	4c0b0567 	cfstr32mi	mvfx0, [fp], {103}	; 0x67
     250:	01040200 	mrseq	r0, R12_usr
     254:	02006606 	andeq	r6, r0, #6291456	; 0x600000
     258:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
     25c:	04020009 	streq	r0, [r2], #-9
     260:	052e0604 	streq	r0, [lr, #-1540]!	; 0xfffff9fc
     264:	04020013 	streq	r0, [r2], #-19	; 0xffffffed
     268:	0d054b04 	vstreq	d4, [r5, #-16]
     26c:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
     270:	000c054a 	andeq	r0, ip, sl, asr #10
     274:	4c040402 	cfstrsmi	mvf0, [r4], {2}
     278:	852f0105 	strhi	r0, [pc, #-261]!	; 17b <CPSR_IRQ_INHIBIT+0xfb>
     27c:	05d70505 	ldrbeq	r0, [r7, #1285]	; 0x505
     280:	0b056710 	bleq	159ec8 <_bss_end+0x14e358>
     284:	0402004c 	streq	r0, [r2], #-76	; 0xffffffb4
     288:	00660601 	rsbeq	r0, r6, r1, lsl #12
     28c:	4a020402 	bmi	8129c <_bss_end+0x7572c>
     290:	02000905 	andeq	r0, r0, #81920	; 0x14000
     294:	2e060404 	cdpcs	4, 0, cr0, cr6, cr4, {0}
     298:	02001305 	andeq	r1, r0, #335544320	; 0x14000000
     29c:	054b0404 	strbeq	r0, [fp, #-1028]	; 0xfffffbfc
     2a0:	0402000d 	streq	r0, [r2], #-13
     2a4:	0c054a04 			; <UNDEFINED> instruction: 0x0c054a04
     2a8:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
     2ac:	2f01054c 	svccs	0x0001054c
     2b0:	d7050585 	strle	r0, [r5, -r5, lsl #11]
     2b4:	05671005 	strbeq	r1, [r7, #-5]!
     2b8:	02004c0b 	andeq	r4, r0, #2816	; 0xb00
     2bc:	66060104 	strvs	r0, [r6], -r4, lsl #2
     2c0:	02040200 	andeq	r0, r4, #0, 4
     2c4:	0009054a 	andeq	r0, r9, sl, asr #10
     2c8:	06040402 	streq	r0, [r4], -r2, lsl #8
     2cc:	0013052e 	andseq	r0, r3, lr, lsr #10
     2d0:	4b040402 	blmi	1012e0 <_bss_end+0xf5770>
     2d4:	02000d05 	andeq	r0, r0, #320	; 0x140
     2d8:	054a0404 	strbeq	r0, [sl, #-1028]	; 0xfffffbfc
     2dc:	0402000c 	streq	r0, [r2], #-12
     2e0:	01054c04 	tsteq	r5, r4, lsl #24
     2e4:	1d05852f 	cfstr32ne	mvfx8, [r5, #-188]	; 0xffffff44
     2e8:	ba0905bc 	blt	2419e0 <_bss_end+0x235e70>
     2ec:	054a0505 	strbeq	r0, [sl, #-1285]	; 0xfffffafb
     2f0:	17054d12 	smladne	r5, r2, sp, r4
     2f4:	4a20054c 	bmi	80182c <_bss_end+0x7f5cbc>
     2f8:	059f0f05 	ldreq	r0, [pc, #3845]	; 1205 <CPSR_IRQ_INHIBIT+0x1185>
     2fc:	0805660b 	stmdaeq	r5, {r0, r1, r3, r9, sl, sp, lr}
     300:	6711054a 	ldrvs	r0, [r1, -sl, asr #10]
     304:	05660805 	strbeq	r0, [r6, #-2053]!	; 0xfffff7fb
     308:	0e056805 	cdpeq	8, 0, cr6, cr5, cr5, {0}
     30c:	6610054a 	ldrvs	r0, [r0], -sl, asr #10
     310:	78030905 	stmdavc	r3, {r0, r2, r8, fp}
     314:	03010566 	movweq	r0, #5478	; 0x1566
     318:	054d2e09 	strbeq	r2, [sp, #-3593]	; 0xfffff1f7
     31c:	0905a01d 	stmdbeq	r5, {r0, r2, r3, r4, sp, pc}
     320:	4a0505ba 	bmi	141a10 <_bss_end+0x135ea0>
     324:	054b2005 	strbeq	r2, [fp, #-5]
     328:	32054c29 	andcc	r4, r5, #10496	; 0x2900
     32c:	8234054a 	eorshi	r0, r4, #310378496	; 0x12800000
     330:	054a3f05 	strbeq	r3, [sl, #-3845]	; 0xfffff0fb
     334:	04020001 	streq	r0, [r2], #-1
     338:	05692f01 	strbeq	r2, [r9, #-3841]!	; 0xfffff0ff
     33c:	3505d80b 	strcc	sp, [r5, #-2059]	; 0xfffff7f5
     340:	00240566 	eoreq	r0, r4, r6, ror #10
     344:	4a020402 	bmi	81354 <_bss_end+0x757e4>
     348:	02000905 	andeq	r0, r0, #81920	; 0x14000
     34c:	05f20204 	ldrbeq	r0, [r2, #516]!	; 0x204
     350:	04020035 	streq	r0, [r2], #-53	; 0xffffffcb
     354:	54054a03 	strpl	r4, [r5], #-2563	; 0xfffff5fd
     358:	06040200 	streq	r0, [r4], -r0, lsl #4
     35c:	00380566 	eorseq	r0, r8, r6, ror #10
     360:	f2060402 	vshl.s8	d0, d2, d6
     364:	02003505 	andeq	r3, r0, #20971520	; 0x1400000
     368:	004a0704 	subeq	r0, sl, r4, lsl #14
     36c:	06080402 	streq	r0, [r8], -r2, lsl #8
     370:	0005054a 	andeq	r0, r5, sl, asr #10
     374:	060a0402 	streq	r0, [sl], -r2, lsl #8
     378:	4d15052e 	cfldr32mi	mvfx0, [r5, #-184]	; 0xffffff48
     37c:	05660505 	strbeq	r0, [r6, #-1285]!	; 0xfffffafb
     380:	15054a0e 	strne	r4, [r5, #-2574]	; 0xfffff5f2
     384:	2e100566 	cfmsc32cs	mvfx0, mvfx0, mvfx6
     388:	05480905 	strbeq	r0, [r8, #-2309]	; 0xfffff6fb
     38c:	054d3101 	strbeq	r3, [sp, #-257]	; 0xfffffeff
     390:	0905a01c 	stmdbeq	r5, {r2, r3, r4, sp, pc}
     394:	4a0505ba 	bmi	141a84 <_bss_end+0x135f14>
     398:	054b1005 	strbeq	r1, [fp, #-5]
     39c:	16054c0d 	strne	r4, [r5], -sp, lsl #24
     3a0:	8218054a 	andshi	r0, r8, #310378496	; 0x12800000
     3a4:	054a2005 	strbeq	r2, [sl, #-5]
     3a8:	01052e22 	tsteq	r5, r2, lsr #28
     3ac:	01040200 	mrseq	r0, R12_usr
     3b0:	009e6683 	addseq	r6, lr, r3, lsl #13
     3b4:	06010402 	streq	r0, [r1], -r2, lsl #8
     3b8:	06230566 	strteq	r0, [r3], -r6, ror #10
     3bc:	827f9a03 	rsbshi	r9, pc, #12288	; 0x3000
     3c0:	e6030105 	str	r0, [r3], -r5, lsl #2
     3c4:	4aba6600 	bmi	fee99bcc <_bss_end+0xfee8e05c>
     3c8:	01000a02 	tsteq	r0, r2, lsl #20
     3cc:	0003f701 	andeq	pc, r3, r1, lsl #14
     3d0:	dd000300 	stcle	3, cr0, [r0, #-0]
     3d4:	02000000 	andeq	r0, r0, #0
     3d8:	0d0efb01 	vstreq	d15, [lr, #-4]
     3dc:	01010100 	mrseq	r0, (UNDEF: 17)
     3e0:	00000001 	andeq	r0, r0, r1
     3e4:	01000001 	tsteq	r0, r1
     3e8:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 334 <CPSR_IRQ_INHIBIT+0x2b4>
     3ec:	69732f65 	ldmdbvs	r3!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
     3f0:	7661686c 	strbtvc	r6, [r1], -ip, ror #16
     3f4:	532f6a79 			; <UNDEFINED> instruction: 0x532f6a79
     3f8:	6f6f6863 	svcvs	0x006f6863
     3fc:	655a2f6c 	ldrbvs	r2, [sl, #-3948]	; 0xfffff094
     400:	614d6f72 	hvcvs	55026	; 0xd6f2
     404:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffe98 <_bss_end+0xffff4328>
     408:	706d6178 	rsbvc	r6, sp, r8, ror r1
     40c:	2f73656c 	svccs	0x0073656c
     410:	632d3331 			; <UNDEFINED> instruction: 0x632d3331
     414:	65746e6f 	ldrbvs	r6, [r4, #-3695]!	; 0xfffff191
     418:	735f7478 	cmpvc	pc, #120, 8	; 0x78000000
     41c:	63746977 	cmnvs	r4, #1949696	; 0x1dc000
     420:	6f6d5f68 	svcvs	0x006d5f68
     424:	6f74696e 	svcvs	0x0074696e
     428:	656b2f72 	strbvs	r2, [fp, #-3954]!	; 0xfffff08e
     42c:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
     430:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
     434:	6972642f 	ldmdbvs	r2!, {r0, r1, r2, r3, r5, sl, sp, lr}^
     438:	73726576 	cmnvc	r2, #494927872	; 0x1d800000
     43c:	6f682f00 	svcvs	0x00682f00
     440:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
     444:	61686c69 	cmnvs	r8, r9, ror #24
     448:	2f6a7976 	svccs	0x006a7976
     44c:	6f686353 	svcvs	0x00686353
     450:	5a2f6c6f 	bpl	bdb614 <_bss_end+0xbcfaa4>
     454:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 2c8 <CPSR_IRQ_INHIBIT+0x248>
     458:	2f657461 	svccs	0x00657461
     45c:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
     460:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
     464:	2d33312f 	ldfcss	f3, [r3, #-188]!	; 0xffffff44
     468:	746e6f63 	strbtvc	r6, [lr], #-3939	; 0xfffff09d
     46c:	5f747865 	svcpl	0x00747865
     470:	74697773 	strbtvc	r7, [r9], #-1907	; 0xfffff88d
     474:	6d5f6863 	ldclvs	8, cr6, [pc, #-396]	; 2f0 <CPSR_IRQ_INHIBIT+0x270>
     478:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
     47c:	6b2f726f 	blvs	bdce40 <_bss_end+0xbd12d0>
     480:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
     484:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
     488:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
     48c:	72642f65 	rsbvc	r2, r4, #404	; 0x194
     490:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
     494:	6d000073 	stcvs	0, cr0, [r0, #-460]	; 0xfffffe34
     498:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
     49c:	632e726f 			; <UNDEFINED> instruction: 0x632e726f
     4a0:	01007070 	tsteq	r0, r0, ror r0
     4a4:	6f6d0000 	svcvs	0x006d0000
     4a8:	6f74696e 	svcvs	0x0074696e
     4ac:	00682e72 	rsbeq	r2, r8, r2, ror lr
     4b0:	00000002 	andeq	r0, r0, r2
     4b4:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
     4b8:	0086b402 	addeq	fp, r6, r2, lsl #8
     4bc:	0e051600 	cfmadd32eq	mvax0, mvfx1, mvfx5, mvfx0
     4c0:	322605d7 	eorcc	r0, r6, #901775360	; 0x35c00000
     4c4:	22020105 	andcs	r0, r2, #1073741825	; 0x40000001
     4c8:	9e090314 	mcrls	3, 0, r0, cr9, cr4, {0}
     4cc:	05831105 	streq	r1, [r3, #261]	; 0x105
     4d0:	22054c17 	andcs	r4, r5, #5888	; 0x1700
     4d4:	01040200 	mrseq	r0, R12_usr
     4d8:	0020054a 	eoreq	r0, r0, sl, asr #10
     4dc:	4a010402 	bmi	414ec <_bss_end+0x3597c>
     4e0:	05681b05 	strbeq	r1, [r8, #-2821]!	; 0xfffff4fb
     4e4:	04020026 	streq	r0, [r2], #-38	; 0xffffffda
     4e8:	24054a03 	strcs	r4, [r5], #-2563	; 0xfffff5fd
     4ec:	03040200 	movweq	r0, #16896	; 0x4200
     4f0:	000d054a 	andeq	r0, sp, sl, asr #10
     4f4:	68020402 	stmdavs	r2, {r1, sl}
     4f8:	02001c05 	andeq	r1, r0, #1280	; 0x500
     4fc:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
     500:	0402001a 	streq	r0, [r2], #-26	; 0xffffffe6
     504:	25054a02 	strcs	r4, [r5, #-2562]	; 0xfffff5fe
     508:	02040200 	andeq	r0, r4, #0, 4
     50c:	0028054a 	eoreq	r0, r8, sl, asr #10
     510:	4a020402 	bmi	81520 <_bss_end+0x759b0>
     514:	02002a05 	andeq	r2, r0, #20480	; 0x5000
     518:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
     51c:	04020009 	streq	r0, [r2], #-9
     520:	05054802 	streq	r4, [r5, #-2050]	; 0xfffff7fe
     524:	02040200 	andeq	r0, r4, #0, 4
     528:	89010580 	stmdbhi	r1, {r7, r8, sl}
     52c:	05661203 	strbeq	r1, [r6, #-515]!	; 0xfffffdfd
     530:	22058317 	andcs	r8, r5, #1543503872	; 0x5c000000
     534:	01040200 	mrseq	r0, R12_usr
     538:	0020054a 	eoreq	r0, r0, sl, asr #10
     53c:	4a010402 	bmi	4154c <_bss_end+0x359dc>
     540:	05681b05 	strbeq	r1, [r8, #-2821]!	; 0xfffff4fb
     544:	04020026 	streq	r0, [r2], #-38	; 0xffffffda
     548:	24054a03 	strcs	r4, [r5], #-2563	; 0xfffff5fd
     54c:	03040200 	movweq	r0, #16896	; 0x4200
     550:	0032054a 	eorseq	r0, r2, sl, asr #10
     554:	68020402 	stmdavs	r2, {r1, sl}
     558:	02004105 	andeq	r4, r0, #1073741825	; 0x40000001
     55c:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
     560:	0402003f 	streq	r0, [r2], #-63	; 0xffffffc1
     564:	4a054a02 	bmi	152d74 <_bss_end+0x147204>
     568:	02040200 	andeq	r0, r4, #0, 4
     56c:	004d054a 	subeq	r0, sp, sl, asr #10
     570:	4a020402 	bmi	81580 <_bss_end+0x75a10>
     574:	02000d05 	andeq	r0, r0, #320	; 0x140
     578:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
     57c:	0402001b 	streq	r0, [r2], #-27	; 0xffffffe5
     580:	22054a02 	andcs	r4, r5, #8192	; 0x2000
     584:	02040200 	andeq	r0, r4, #0, 4
     588:	0020054a 	eoreq	r0, r0, sl, asr #10
     58c:	4a020402 	bmi	8159c <_bss_end+0x75a2c>
     590:	02002b05 	andeq	r2, r0, #5120	; 0x1400
     594:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
     598:	0402002e 	streq	r0, [r2], #-46	; 0xffffffd2
     59c:	4d054a02 	vstrmi	s8, [r5, #-8]
     5a0:	02040200 	andeq	r0, r4, #0, 4
     5a4:	0030052e 	eorseq	r0, r0, lr, lsr #10
     5a8:	4a020402 	bmi	815b8 <_bss_end+0x75a48>
     5ac:	02000905 	andeq	r0, r0, #81920	; 0x14000
     5b0:	052c0204 	streq	r0, [ip, #-516]!	; 0xfffffdfc
     5b4:	04020005 	streq	r0, [r2], #-5
     5b8:	17058002 	strne	r8, [r5, -r2]
     5bc:	0022058a 	eoreq	r0, r2, sl, lsl #11
     5c0:	4a030402 	bmi	c15d0 <_bss_end+0xb5a60>
     5c4:	02002005 	andeq	r2, r0, #5
     5c8:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
     5cc:	04020009 	streq	r0, [r2], #-9
     5d0:	15056802 	strne	r6, [r5, #-2050]	; 0xfffff7fe
     5d4:	02040200 	andeq	r0, r4, #0, 4
     5d8:	001e054a 	andseq	r0, lr, sl, asr #10
     5dc:	4a020402 	bmi	815ec <_bss_end+0x75a7c>
     5e0:	02002505 	andeq	r2, r0, #20971520	; 0x1400000
     5e4:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
     5e8:	04020023 	streq	r0, [r2], #-35	; 0xffffffdd
     5ec:	2e054a02 	vmlacs.f32	s8, s10, s4
     5f0:	02040200 	andeq	r0, r4, #0, 4
     5f4:	0031052e 	eorseq	r0, r1, lr, lsr #10
     5f8:	4a020402 	bmi	81608 <_bss_end+0x75a98>
     5fc:	02003305 	andeq	r3, r0, #335544320	; 0x14000000
     600:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
     604:	04020005 	streq	r0, [r2], #-5
     608:	01054802 	tsteq	r5, r2, lsl #16
     60c:	05058a86 	streq	r8, [r5, #-2694]	; 0xfffff57a
     610:	680905bb 	stmdavs	r9, {r0, r1, r3, r4, r5, r7, r8, sl}
     614:	054a1d05 	strbeq	r1, [sl, #-3333]	; 0xfffff2fb
     618:	1f054a21 	svcne	0x00054a21
     61c:	2e35054a 	cdpcs	5, 3, cr0, cr5, cr10, {2}
     620:	054a2a05 	strbeq	r2, [sl, #-2565]	; 0xfffff5fb
     624:	38052e36 	stmdacc	r5, {r1, r2, r4, r5, r9, sl, fp, sp}
     628:	4b14052e 	blmi	501ae8 <_bss_end+0x4f5f78>
     62c:	054a0905 	strbeq	r0, [sl, #-2309]	; 0xfffff6fb
     630:	05678614 	strbeq	r8, [r7, #-1556]!	; 0xfffff9ec
     634:	12054a09 	andne	r4, r5, #36864	; 0x9000
     638:	4c0d0569 	cfstr32mi	mvfx0, [sp], {105}	; 0x69
     63c:	692f0105 	stmdbvs	pc!, {r0, r2, r8}	; <UNPREDICTABLE>
     640:	059f1705 	ldreq	r1, [pc, #1797]	; d4d <CPSR_IRQ_INHIBIT+0xccd>
     644:	04020023 	streq	r0, [r2], #-35	; 0xffffffdd
     648:	25054a03 	strcs	r4, [r5, #-2563]	; 0xfffff5fd
     64c:	03040200 	movweq	r0, #16896	; 0x4200
     650:	00170582 	andseq	r0, r7, r2, lsl #11
     654:	4c020402 	cfstrsmi	mvf0, [r2], {2}
     658:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
     65c:	05d40204 	ldrbeq	r0, [r4, #516]	; 0x204
     660:	0d058716 	stceq	7, cr8, [r5, #-88]	; 0xffffffa8
     664:	2f01054c 	svccs	0x0001054c
     668:	9f130569 	svcls	0x00130569
     66c:	05680d05 	strbeq	r0, [r8, #-3333]!	; 0xfffff2fb
     670:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
     674:	0905a333 	stmdbeq	r5, {r0, r1, r4, r5, r8, r9, sp, pc}
     678:	830e054a 	movwhi	r0, #58698	; 0xe54a
     67c:	05671605 	strbeq	r1, [r7, #-1541]!	; 0xfffff9fb
     680:	01054c0d 	tsteq	r5, sp, lsl #24
     684:	0505852f 	streq	r8, [r5, #-1327]	; 0xfffffad1
     688:	681205bb 	ldmdavs	r2, {r0, r1, r3, r4, r5, r7, r8, sl}
     68c:	69160586 	ldmdbvs	r6, {r1, r2, r7, r8, sl}
     690:	054c0d05 	strbeq	r0, [ip, #-3333]	; 0xfffff2fb
     694:	05a12f01 	streq	r2, [r1, #3841]!	; 0xf01
     698:	1205d709 	andne	sp, r5, #2359296	; 0x240000
     69c:	6827054c 	stmdavs	r7!, {r2, r3, r6, r8, sl}
     6a0:	05ba2d05 	ldreq	r2, [sl, #3333]!	; 0xd05
     6a4:	11054a10 	tstne	r5, r0, lsl sl
     6a8:	4a2d052e 	bmi	b41b68 <_bss_end+0xb35ff8>
     6ac:	052e1305 	streq	r1, [lr, #-773]!	; 0xfffffcfb
     6b0:	0a052f0f 	beq	14c2f4 <_bss_end+0x140784>
     6b4:	610505a0 	smlatbvs	r5, r0, r5, r0
     6b8:	68100536 	ldmdavs	r0, {r1, r2, r4, r5, r8, sl}
     6bc:	052e1105 	streq	r1, [lr, #-261]!	; 0xfffffefb
     6c0:	13054a22 	movwne	r4, #23074	; 0x5a22
     6c4:	2f0a052e 	svccs	0x000a052e
     6c8:	05690c05 	strbeq	r0, [r9, #-3077]!	; 0xfffff3fb
     6cc:	0f052e0d 	svceq	0x00052e0d
     6d0:	4b06054a 	blmi	181c00 <_bss_end+0x176090>
     6d4:	05680e05 	strbeq	r0, [r8, #-3589]!	; 0xfffff1fb
     6d8:	0402001d 	streq	r0, [r2], #-29	; 0xffffffe3
     6dc:	17054a03 	strne	r4, [r5, -r3, lsl #20]
     6e0:	03040200 	movweq	r0, #16896	; 0x4200
     6e4:	001b059e 	mulseq	fp, lr, r5
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
     74c:	e1030627 	tst	r3, r7, lsr #12
     750:	0105827e 	tsteq	r5, lr, ror r2
     754:	9e019f03 	cdpls	15, 0, cr9, cr1, cr3, {0}
     758:	0a024a9e 	beq	931d8 <_bss_end+0x87668>
     75c:	05010100 	streq	r0, [r1, #-256]	; 0xffffff00
     760:	02050001 	andeq	r0, r5, #1
     764:	00008cfc 	strdeq	r8, [r0], -ip
     768:	05010e03 	streq	r0, [r1, #-3587]	; 0xfffff1fd
     76c:	05678310 	strbeq	r8, [r7, #-784]!	; 0xfffffcf0
     770:	08026701 	stmdaeq	r2, {r0, r8, r9, sl, sp, lr}
     774:	05010100 	streq	r0, [r1, #-256]	; 0xffffff00
     778:	02050001 	andeq	r0, r5, #1
     77c:	00008d34 	andeq	r8, r0, r4, lsr sp
     780:	05012103 	streq	r2, [r1, #-259]	; 0xfffffefd
     784:	17058312 	smladne	r5, r2, r3, r8
     788:	4a05054a 	bmi	141cb8 <_bss_end+0x136148>
     78c:	674c1405 	strbvs	r1, [ip, -r5, lsl #8]
     790:	054a0905 	strbeq	r0, [sl, #-2309]	; 0xfffff6fb
     794:	17056912 	smladne	r5, r2, r9, r6
     798:	4a05054a 	bmi	141cc8 <_bss_end+0x136158>
     79c:	054c0f05 	strbeq	r0, [ip, #-3845]	; 0xfffff0fb
     7a0:	1f054b16 	svcne	0x00054b16
     7a4:	2e14054a 	cfmac32cs	mvfx0, mvfx4, mvfx10
     7a8:	024c0105 	subeq	r0, ip, #1073741825	; 0x40000001
     7ac:	01010006 	tsteq	r1, r6
     7b0:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
     7b4:	008dbc02 	addeq	fp, sp, r2, lsl #24
     7b8:	00c00300 	sbceq	r0, r0, r0, lsl #6
     7bc:	83130501 	tsthi	r3, #4194304	; 0x400000
     7c0:	02670105 	rsbeq	r0, r7, #1073741825	; 0x40000001
     7c4:	01010008 	tsteq	r1, r8
     7c8:	000001f6 	strdeq	r0, [r0], -r6
     7cc:	01560003 	cmpeq	r6, r3
     7d0:	01020000 	mrseq	r0, (UNDEF: 2)
     7d4:	000d0efb 	strdeq	r0, [sp], -fp
     7d8:	01010101 	tsteq	r1, r1, lsl #2
     7dc:	01000000 	mrseq	r0, (UNDEF: 0)
     7e0:	2f010000 	svccs	0x00010000
     7e4:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     7e8:	6c69732f 	stclvs	3, cr7, [r9], #-188	; 0xffffff44
     7ec:	79766168 	ldmdbvc	r6!, {r3, r5, r6, r8, sp, lr}^
     7f0:	63532f6a 	cmpvs	r3, #424	; 0x1a8
     7f4:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; 65c <CPSR_IRQ_INHIBIT+0x5dc>
     7f8:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
     7fc:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
     800:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
     804:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
     808:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
     80c:	6f632d33 	svcvs	0x00632d33
     810:	7865746e 	stmdavc	r5!, {r1, r2, r3, r5, r6, sl, ip, sp, lr}^
     814:	77735f74 			; <UNDEFINED> instruction: 0x77735f74
     818:	68637469 	stmdavs	r3!, {r0, r3, r5, r6, sl, ip, sp, lr}^
     81c:	6e6f6d5f 	mcrvs	13, 3, r6, cr15, cr15, {2}
     820:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
     824:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
     828:	2f6c656e 	svccs	0x006c656e
     82c:	2f637273 	svccs	0x00637273
     830:	76697264 	strbtvc	r7, [r9], -r4, ror #4
     834:	00737265 	rsbseq	r7, r3, r5, ror #4
     838:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 784 <CPSR_IRQ_INHIBIT+0x704>
     83c:	69732f65 	ldmdbvs	r3!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
     840:	7661686c 	strbtvc	r6, [r1], -ip, ror #16
     844:	532f6a79 			; <UNDEFINED> instruction: 0x532f6a79
     848:	6f6f6863 	svcvs	0x006f6863
     84c:	655a2f6c 	ldrbvs	r2, [sl, #-3948]	; 0xfffff094
     850:	614d6f72 	hvcvs	55026	; 0xd6f2
     854:	652f6574 	strvs	r6, [pc, #-1396]!	; 2e8 <CPSR_IRQ_INHIBIT+0x268>
     858:	706d6178 	rsbvc	r6, sp, r8, ror r1
     85c:	2f73656c 	svccs	0x0073656c
     860:	632d3331 			; <UNDEFINED> instruction: 0x632d3331
     864:	65746e6f 	ldrbvs	r6, [r4, #-3695]!	; 0xfffff191
     868:	735f7478 	cmpvc	pc, #120, 8	; 0x78000000
     86c:	63746977 	cmnvs	r4, #1949696	; 0x1dc000
     870:	6f6d5f68 	svcvs	0x006d5f68
     874:	6f74696e 	svcvs	0x0074696e
     878:	656b2f72 	strbvs	r2, [fp, #-3954]!	; 0xfffff08e
     87c:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
     880:	636e692f 	cmnvs	lr, #770048	; 0xbc000
     884:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
     888:	616f622f 	cmnvs	pc, pc, lsr #4
     88c:	722f6472 	eorvc	r6, pc, #1912602624	; 0x72000000
     890:	2f306970 	svccs	0x00306970
     894:	006c6168 	rsbeq	r6, ip, r8, ror #2
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
     8e8:	6972642f 	ldmdbvs	r2!, {r0, r1, r2, r3, r5, sl, sp, lr}^
     8ec:	73726576 	cmnvc	r2, #494927872	; 0x1d800000
     8f0:	69740000 	ldmdbvs	r4!, {}^	; <UNPREDICTABLE>
     8f4:	2e72656d 	cdpcs	5, 7, cr6, cr2, cr13, {3}
     8f8:	00707063 	rsbseq	r7, r0, r3, rrx
     8fc:	69000001 	stmdbvs	r0, {r0}
     900:	6564746e 	strbvs	r7, [r4, #-1134]!	; 0xfffffb92
     904:	00682e66 	rsbeq	r2, r8, r6, ror #28
     908:	70000002 	andvc	r0, r0, r2
     90c:	70697265 	rsbvc	r7, r9, r5, ror #4
     910:	61726568 	cmnvs	r2, r8, ror #10
     914:	682e736c 	stmdavs	lr!, {r2, r3, r5, r6, r8, r9, ip, sp, lr}
     918:	00000200 	andeq	r0, r0, r0, lsl #4
     91c:	656d6974 	strbvs	r6, [sp, #-2420]!	; 0xfffff68c
     920:	00682e72 	rsbeq	r2, r8, r2, ror lr
     924:	00000003 	andeq	r0, r0, r3
     928:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
     92c:	008de802 	addeq	lr, sp, r2, lsl #16
     930:	01190300 	tsteq	r9, r0, lsl #6
     934:	059f0f05 	ldreq	r0, [pc, #3845]	; 1841 <CPSR_IRQ_INHIBIT+0x17c1>
     938:	01052f14 	tsteq	r5, r4, lsl pc
     93c:	0c05a1a1 	stfeqd	f2, [r5], {161}	; 0xa1
     940:	4a18059f 	bmi	601fc4 <_bss_end+0x5f6454>
     944:	052e3605 	streq	r3, [lr, #-1541]!	; 0xfffff9fb
     948:	05854b01 	streq	r4, [r5, #2817]	; 0xb01
     94c:	2005d71e 	andcs	sp, r5, lr, lsl r7
     950:	4d150582 	cfldr32mi	mvfx0, [r5, #-520]	; 0xfffffdf8
     954:	05671b05 	strbeq	r1, [r7, #-2821]!	; 0xfffff4fb
     958:	15056717 	strne	r6, [r5, #-1815]	; 0xfffff8e9
     95c:	66130567 	ldrvs	r0, [r3], -r7, ror #10
     960:	05d84605 	ldrbeq	r4, [r8, #1541]	; 0x605
     964:	25052e21 	strcs	r2, [r5, #-3617]	; 0xfffff1df
     968:	2e230582 	cfsh64cs	mvdx0, mvdx3, #-62
     96c:	82250530 	eorhi	r0, r5, #48, 10	; 0xc000000
     970:	054c0f05 	strbeq	r0, [ip, #-3845]	; 0xfffff0fb
     974:	05696701 	strbeq	r6, [r9, #-1793]!	; 0xfffff8ff
     978:	1b05836f 	blne	16173c <_bss_end+0x155bcc>
     97c:	83170584 	tsthi	r7, #132, 10	; 0x21000000
     980:	69830105 	stmibvs	r3, {r0, r2, r8}
     984:	05832305 	streq	r2, [r3, #773]	; 0x305
     988:	09058225 	stmdbeq	r5, {r0, r2, r5, r9, pc}
     98c:	4a05054c 	bmi	141ec4 <_bss_end+0x136354>
     990:	054b0905 	strbeq	r0, [fp, #-2309]	; 0xfffff6fb
     994:	01054a12 	tsteq	r5, r2, lsl sl
     998:	2b05692f 	blcs	15ae5c <_bss_end+0x14f2ec>
     99c:	82100583 	andshi	r0, r0, #549453824	; 0x20c00000
     9a0:	052e2b05 	streq	r2, [lr, #-2821]!	; 0xfffff4fb
     9a4:	9e668301 	cdpls	3, 6, cr8, cr6, cr1, {0}
     9a8:	01040200 	mrseq	r0, R12_usr
     9ac:	1e056606 	cfmadd32ne	mvax0, mvfx6, mvfx5, mvfx6
     9b0:	7fba0306 	svcvc	0x00ba0306
     9b4:	03010582 	movweq	r0, #5506	; 0x1582
     9b8:	ba6600c6 	blt	1980cd8 <_bss_end+0x1975168>
     9bc:	000a024a 	andeq	r0, sl, sl, asr #4
     9c0:	026f0101 	rsbeq	r0, pc, #1073741824	; 0x40000000
     9c4:	00030000 	andeq	r0, r3, r0
     9c8:	000001c8 	andeq	r0, r0, r8, asr #3
     9cc:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
     9d0:	0101000d 	tsteq	r1, sp
     9d4:	00000101 	andeq	r0, r0, r1, lsl #2
     9d8:	00000100 	andeq	r0, r0, r0, lsl #2
     9dc:	6f682f01 	svcvs	0x00682f01
     9e0:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
     9e4:	61686c69 	cmnvs	r8, r9, ror #24
     9e8:	2f6a7976 	svccs	0x006a7976
     9ec:	6f686353 	svcvs	0x00686353
     9f0:	5a2f6c6f 	bpl	bdbbb4 <_bss_end+0xbd0044>
     9f4:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 868 <CPSR_IRQ_INHIBIT+0x7e8>
     9f8:	2f657461 	svccs	0x00657461
     9fc:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
     a00:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
     a04:	2d33312f 	ldfcss	f3, [r3, #-188]!	; 0xffffff44
     a08:	746e6f63 	strbtvc	r6, [lr], #-3939	; 0xfffff09d
     a0c:	5f747865 	svcpl	0x00747865
     a10:	74697773 	strbtvc	r7, [r9], #-1907	; 0xfffff88d
     a14:	6d5f6863 	ldclvs	8, cr6, [pc, #-396]	; 890 <CPSR_IRQ_INHIBIT+0x810>
     a18:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
     a1c:	6b2f726f 	blvs	bdd3e0 <_bss_end+0xbd1870>
     a20:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
     a24:	72732f6c 	rsbsvc	r2, r3, #108, 30	; 0x1b0
     a28:	682f0063 	stmdavs	pc!, {r0, r1, r5, r6}	; <UNPREDICTABLE>
     a2c:	2f656d6f 	svccs	0x00656d6f
     a30:	686c6973 	stmdavs	ip!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
     a34:	6a797661 	bvs	1e5e3c0 <_bss_end+0x1e52850>
     a38:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
     a3c:	2f6c6f6f 	svccs	0x006c6f6f
     a40:	6f72655a 	svcvs	0x0072655a
     a44:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
     a48:	6178652f 	cmnvs	r8, pc, lsr #10
     a4c:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
     a50:	33312f73 	teqcc	r1, #460	; 0x1cc
     a54:	6e6f632d 	cdpvs	3, 6, cr6, cr15, cr13, {1}
     a58:	74786574 	ldrbtvc	r6, [r8], #-1396	; 0xfffffa8c
     a5c:	6977735f 	ldmdbvs	r7!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, sp, lr}^
     a60:	5f686374 	svcpl	0x00686374
     a64:	696e6f6d 	stmdbvs	lr!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
     a68:	2f726f74 	svccs	0x00726f74
     a6c:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
     a70:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
     a74:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
     a78:	622f6564 	eorvs	r6, pc, #100, 10	; 0x19000000
     a7c:	6472616f 	ldrbtvs	r6, [r2], #-367	; 0xfffffe91
     a80:	6970722f 	ldmdbvs	r0!, {r0, r1, r2, r3, r5, r9, ip, sp, lr}^
     a84:	61682f30 	cmnvs	r8, r0, lsr pc
     a88:	682f006c 	stmdavs	pc!, {r2, r3, r5, r6}	; <UNPREDICTABLE>
     a8c:	2f656d6f 	svccs	0x00656d6f
     a90:	686c6973 	stmdavs	ip!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
     a94:	6a797661 	bvs	1e5e420 <_bss_end+0x1e528b0>
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
     ad8:	2f006564 	svccs	0x00006564
     adc:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     ae0:	6c69732f 	stclvs	3, cr7, [r9], #-188	; 0xffffff44
     ae4:	79766168 	ldmdbvc	r6!, {r3, r5, r6, r8, sp, lr}^
     ae8:	63532f6a 	cmpvs	r3, #424	; 0x1a8
     aec:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; 954 <CPSR_IRQ_INHIBIT+0x8d4>
     af0:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
     af4:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
     af8:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
     afc:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
     b00:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
     b04:	6f632d33 	svcvs	0x00632d33
     b08:	7865746e 	stmdavc	r5!, {r1, r2, r3, r5, r6, sl, ip, sp, lr}^
     b0c:	77735f74 			; <UNDEFINED> instruction: 0x77735f74
     b10:	68637469 	stmdavs	r3!, {r0, r3, r5, r6, sl, ip, sp, lr}^
     b14:	6e6f6d5f 	mcrvs	13, 3, r6, cr15, cr15, {2}
     b18:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
     b1c:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
     b20:	2f6c656e 	svccs	0x006c656e
     b24:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
     b28:	2f656475 	svccs	0x00656475
     b2c:	76697264 	strbtvc	r7, [r9], -r4, ror #4
     b30:	00737265 	rsbseq	r7, r3, r5, ror #4
     b34:	746e6900 	strbtvc	r6, [lr], #-2304	; 0xfffff700
     b38:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
     b3c:	635f7470 	cmpvs	pc, #112, 8	; 0x70000000
     b40:	72746e6f 	rsbsvc	r6, r4, #1776	; 0x6f0
     b44:	656c6c6f 	strbvs	r6, [ip, #-3183]!	; 0xfffff391
     b48:	70632e72 	rsbvc	r2, r3, r2, ror lr
     b4c:	00010070 	andeq	r0, r1, r0, ror r0
     b50:	746e6900 	strbtvc	r6, [lr], #-2304	; 0xfffff700
     b54:	2e666564 	cdpcs	5, 6, cr6, cr6, cr4, {3}
     b58:	00020068 	andeq	r0, r2, r8, rrx
     b5c:	72657000 	rsbvc	r7, r5, #0
     b60:	65687069 	strbvs	r7, [r8, #-105]!	; 0xffffff97
     b64:	736c6172 	cmnvc	ip, #-2147483620	; 0x8000001c
     b68:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
     b6c:	6e690000 	cdpvs	0, 6, cr0, cr9, cr0, {0}
     b70:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
     b74:	5f747075 	svcpl	0x00747075
     b78:	746e6f63 	strbtvc	r6, [lr], #-3939	; 0xfffff09d
     b7c:	6c6c6f72 	stclvs	15, cr6, [ip], #-456	; 0xfffffe38
     b80:	682e7265 	stmdavs	lr!, {r0, r2, r5, r6, r9, ip, sp, lr}
     b84:	00000300 	andeq	r0, r0, r0, lsl #6
     b88:	656d6974 	strbvs	r6, [sp, #-2420]!	; 0xfffff68c
     b8c:	00682e72 	rsbeq	r2, r8, r2, ror lr
     b90:	00000004 	andeq	r0, r0, r4
     b94:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
     b98:	00907802 	addseq	r7, r0, r2, lsl #16
     b9c:	010b0300 	mrseq	r0, (UNDEF: 59)
     ba0:	2405854c 	strcs	r8, [r5], #-1356	; 0xfffffab4
     ba4:	6605054f 	strvs	r0, [r5], -pc, asr #10
     ba8:	054b1c05 	strbeq	r1, [fp, #-3077]	; 0xfffff3fb
     bac:	30694b01 	rsbcc	r4, r9, r1, lsl #22
     bb0:	9f13056a 	svcls	0x0013056a
     bb4:	052e3805 	streq	r3, [lr, #-2053]!	; 0xfffff7fb
     bb8:	05a14d01 	streq	r4, [r1, #3329]!	; 0xd01
     bbc:	1c059f0c 	stcne	15, cr9, [r5], {12}
     bc0:	2e3a054a 	cdpcs	5, 3, cr0, cr10, cr10, {2}
     bc4:	854b0105 	strbhi	r0, [fp, #-261]	; 0xfffffefb
     bc8:	059f4305 	ldreq	r4, [pc, #773]	; ed5 <CPSR_IRQ_INHIBIT+0xe55>
     bcc:	39052e40 	stmdbcc	r5, {r6, r9, sl, fp, sp}
     bd0:	8240054a 	subhi	r0, r0, #310378496	; 0x12800000
     bd4:	052e3b05 	streq	r3, [lr, #-2821]!	; 0xfffff4fb
     bd8:	05692f01 	strbeq	r2, [r9, #-3841]!	; 0xfffff0ff
     bdc:	41059f44 	tstmi	r5, r4, asr #30
     be0:	4a3a052e 	bmi	e820a0 <_bss_end+0xe76530>
     be4:	05824105 	streq	r4, [r2, #261]	; 0x105
     be8:	01052e3c 	tsteq	r5, ip, lsr lr
     bec:	1805692f 	stmdane	r5, {r0, r1, r2, r3, r5, r8, fp, sp, lr}
     bf0:	0187059f 			; <UNDEFINED> instruction: 0x0187059f
     bf4:	4a7a054c 	bmi	1e8212c <_bss_end+0x1e765bc>
     bf8:	054a7305 	strbeq	r7, [sl, #-773]	; 0xfffffcfb
     bfc:	7505827a 	strvc	r8, [r5, #-634]	; 0xfffffd86
     c00:	2f01052e 	svccs	0x0001052e
     c04:	9f180569 	svcls	0x00180569
     c08:	4c018905 			; <UNDEFINED> instruction: 0x4c018905
     c0c:	054a7c05 	strbeq	r7, [sl, #-3077]	; 0xfffff3fb
     c10:	7c054a75 			; <UNDEFINED> instruction: 0x7c054a75
     c14:	2e770582 	cdpcs	5, 7, cr0, cr7, cr2, {4}
     c18:	662f0105 	strtvs	r0, [pc], -r5, lsl #2
     c1c:	0402009e 	streq	r0, [r2], #-158	; 0xffffff62
     c20:	05660601 	strbeq	r0, [r6, #-1537]!	; 0xfffff9ff
     c24:	45030643 	strmi	r0, [r3, #-1603]	; 0xfffff9bd
     c28:	03010582 	movweq	r0, #5506	; 0x1582
     c2c:	4aba663b 	bmi	fee9a520 <_bss_end+0xfee8e9b0>
     c30:	01000a02 	tsteq	r0, r2, lsl #20
     c34:	0003a201 	andeq	sl, r3, r1, lsl #4
     c38:	bf000300 	svclt	0x00000300
     c3c:	02000002 	andeq	r0, r0, #2
     c40:	0d0efb01 	vstreq	d15, [lr, #-4]
     c44:	01010100 	mrseq	r0, (UNDEF: 17)
     c48:	00000001 	andeq	r0, r0, r1
     c4c:	01000001 	tsteq	r0, r1
     c50:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; b9c <CPSR_IRQ_INHIBIT+0xb1c>
     c54:	69732f65 	ldmdbvs	r3!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
     c58:	7661686c 	strbtvc	r6, [r1], -ip, ror #16
     c5c:	532f6a79 			; <UNDEFINED> instruction: 0x532f6a79
     c60:	6f6f6863 	svcvs	0x006f6863
     c64:	655a2f6c 	ldrbvs	r2, [sl, #-3948]	; 0xfffff094
     c68:	614d6f72 	hvcvs	55026	; 0xd6f2
     c6c:	652f6574 	strvs	r6, [pc, #-1396]!	; 700 <CPSR_IRQ_INHIBIT+0x680>
     c70:	706d6178 	rsbvc	r6, sp, r8, ror r1
     c74:	2f73656c 	svccs	0x0073656c
     c78:	632d3331 			; <UNDEFINED> instruction: 0x632d3331
     c7c:	65746e6f 	ldrbvs	r6, [r4, #-3695]!	; 0xfffff191
     c80:	735f7478 	cmpvc	pc, #120, 8	; 0x78000000
     c84:	63746977 	cmnvs	r4, #1949696	; 0x1dc000
     c88:	6f6d5f68 	svcvs	0x006d5f68
     c8c:	6f74696e 	svcvs	0x0074696e
     c90:	656b2f72 	strbvs	r2, [fp, #-3954]!	; 0xfffff08e
     c94:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
     c98:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
     c9c:	6f682f00 	svcvs	0x00682f00
     ca0:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
     ca4:	61686c69 	cmnvs	r8, r9, ror #24
     ca8:	2f6a7976 	svccs	0x006a7976
     cac:	6f686353 	svcvs	0x00686353
     cb0:	5a2f6c6f 	bpl	bdbe74 <_bss_end+0xbd0304>
     cb4:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; b28 <CPSR_IRQ_INHIBIT+0xaa8>
     cb8:	2f657461 	svccs	0x00657461
     cbc:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
     cc0:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
     cc4:	2d33312f 	ldfcss	f3, [r3, #-188]!	; 0xffffff44
     cc8:	746e6f63 	strbtvc	r6, [lr], #-3939	; 0xfffff09d
     ccc:	5f747865 	svcpl	0x00747865
     cd0:	74697773 	strbtvc	r7, [r9], #-1907	; 0xfffff88d
     cd4:	6d5f6863 	ldclvs	8, cr6, [pc, #-396]	; b50 <CPSR_IRQ_INHIBIT+0xad0>
     cd8:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
     cdc:	6b2f726f 	blvs	bdd6a0 <_bss_end+0xbd1b30>
     ce0:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
     ce4:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
     ce8:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
     cec:	6f622f65 	svcvs	0x00622f65
     cf0:	2f647261 	svccs	0x00647261
     cf4:	30697072 	rsbcc	r7, r9, r2, ror r0
     cf8:	6c61682f 	stclvs	8, cr6, [r1], #-188	; 0xffffff44
     cfc:	6f682f00 	svcvs	0x00682f00
     d00:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
     d04:	61686c69 	cmnvs	r8, r9, ror #24
     d08:	2f6a7976 	svccs	0x006a7976
     d0c:	6f686353 	svcvs	0x00686353
     d10:	5a2f6c6f 	bpl	bdbed4 <_bss_end+0xbd0364>
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
     d3c:	6b2f726f 	blvs	bdd700 <_bss_end+0xbd1b90>
     d40:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
     d44:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
     d48:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
     d4c:	72642f65 	rsbvc	r2, r4, #404	; 0x194
     d50:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
     d54:	682f0073 	stmdavs	pc!, {r0, r1, r4, r5, r6}	; <UNPREDICTABLE>
     d58:	2f656d6f 	svccs	0x00656d6f
     d5c:	686c6973 	stmdavs	ip!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
     d60:	6a797661 	bvs	1e5e6ec <_bss_end+0x1e52b7c>
     d64:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
     d68:	2f6c6f6f 	svccs	0x006c6f6f
     d6c:	6f72655a 	svcvs	0x0072655a
     d70:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
     d74:	6178652f 	cmnvs	r8, pc, lsr #10
     d78:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
     d7c:	33312f73 	teqcc	r1, #460	; 0x1cc
     d80:	6e6f632d 	cdpvs	3, 6, cr6, cr15, cr13, {1}
     d84:	74786574 	ldrbtvc	r6, [r8], #-1396	; 0xfffffa8c
     d88:	6977735f 	ldmdbvs	r7!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, sp, lr}^
     d8c:	5f686374 	svcpl	0x00686374
     d90:	696e6f6d 	stmdbvs	lr!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
     d94:	2f726f74 	svccs	0x00726f74
     d98:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
     d9c:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
     da0:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
     da4:	2f006564 	svccs	0x00006564
     da8:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     dac:	6c69732f 	stclvs	3, cr7, [r9], #-188	; 0xffffff44
     db0:	79766168 	ldmdbvc	r6!, {r3, r5, r6, r8, sp, lr}^
     db4:	63532f6a 	cmpvs	r3, #424	; 0x1a8
     db8:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; c20 <CPSR_IRQ_INHIBIT+0xba0>
     dbc:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
     dc0:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
     dc4:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
     dc8:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
     dcc:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
     dd0:	6f632d33 	svcvs	0x00632d33
     dd4:	7865746e 	stmdavc	r5!, {r1, r2, r3, r5, r6, sl, ip, sp, lr}^
     dd8:	77735f74 			; <UNDEFINED> instruction: 0x77735f74
     ddc:	68637469 	stmdavs	r3!, {r0, r3, r5, r6, sl, ip, sp, lr}^
     de0:	6e6f6d5f 	mcrvs	13, 3, r6, cr15, cr15, {2}
     de4:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
     de8:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
     dec:	2f6c656e 	svccs	0x006c656e
     df0:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
     df4:	2f656475 	svccs	0x00656475
     df8:	6f6d656d 	svcvs	0x006d656d
     dfc:	2f007972 	svccs	0x00007972
     e00:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     e04:	6c69732f 	stclvs	3, cr7, [r9], #-188	; 0xffffff44
     e08:	79766168 	ldmdbvc	r6!, {r3, r5, r6, r8, sp, lr}^
     e0c:	63532f6a 	cmpvs	r3, #424	; 0x1a8
     e10:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; c78 <CPSR_IRQ_INHIBIT+0xbf8>
     e14:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
     e18:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
     e1c:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
     e20:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
     e24:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
     e28:	6f632d33 	svcvs	0x00632d33
     e2c:	7865746e 	stmdavc	r5!, {r1, r2, r3, r5, r6, sl, ip, sp, lr}^
     e30:	77735f74 			; <UNDEFINED> instruction: 0x77735f74
     e34:	68637469 	stmdavs	r3!, {r0, r3, r5, r6, sl, ip, sp, lr}^
     e38:	6e6f6d5f 	mcrvs	13, 3, r6, cr15, cr15, {2}
     e3c:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
     e40:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
     e44:	2f6c656e 	svccs	0x006c656e
     e48:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
     e4c:	2f656475 	svccs	0x00656475
     e50:	636f7270 	cmnvs	pc, #112, 4
     e54:	00737365 	rsbseq	r7, r3, r5, ror #6
     e58:	69616d00 	stmdbvs	r1!, {r8, sl, fp, sp, lr}^
     e5c:	70632e6e 	rsbvc	r2, r3, lr, ror #28
     e60:	00010070 	andeq	r0, r1, r0, ror r0
     e64:	746e6900 	strbtvc	r6, [lr], #-2304	; 0xfffff700
     e68:	2e666564 	cdpcs	5, 6, cr6, cr6, cr4, {3}
     e6c:	00020068 	andeq	r0, r2, r8, rrx
     e70:	69706700 	ldmdbvs	r0!, {r8, r9, sl, sp, lr}^
     e74:	00682e6f 	rsbeq	r2, r8, pc, ror #28
     e78:	6d000003 	stcvs	0, cr0, [r0, #-12]
     e7c:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
     e80:	682e726f 	stmdavs	lr!, {r0, r1, r2, r3, r5, r6, r9, ip, sp, lr}
     e84:	00000300 	andeq	r0, r0, r0, lsl #6
     e88:	69726570 	ldmdbvs	r2!, {r4, r5, r6, r8, sl, sp, lr}^
     e8c:	72656870 	rsbvc	r6, r5, #112, 16	; 0x700000
     e90:	2e736c61 	cdpcs	12, 7, cr6, cr3, cr1, {3}
     e94:	00020068 	andeq	r0, r2, r8, rrx
     e98:	6d697400 	cfstrdvs	mvd7, [r9, #-0]
     e9c:	682e7265 	stmdavs	lr!, {r0, r2, r5, r6, r9, ip, sp, lr}
     ea0:	00000300 	andeq	r0, r0, r0, lsl #6
     ea4:	65746e69 	ldrbvs	r6, [r4, #-3689]!	; 0xfffff197
     ea8:	70757272 	rsbsvc	r7, r5, r2, ror r2
     eac:	6f635f74 	svcvs	0x00635f74
     eb0:	6f72746e 	svcvs	0x0072746e
     eb4:	72656c6c 	rsbvc	r6, r5, #108, 24	; 0x6c00
     eb8:	0400682e 	streq	r6, [r0], #-2094	; 0xfffff7d2
     ebc:	656d0000 	strbvs	r0, [sp, #-0]!
     ec0:	70616d6d 	rsbvc	r6, r1, sp, ror #26
     ec4:	0500682e 	streq	r6, [r0, #-2094]	; 0xfffff7d2
     ec8:	656b0000 	strbvs	r0, [fp, #-0]!
     ecc:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
     ed0:	6165685f 	cmnvs	r5, pc, asr r8
     ed4:	00682e70 	rsbeq	r2, r8, r0, ror lr
     ed8:	70000005 	andvc	r0, r0, r5
     edc:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     ee0:	682e7373 	stmdavs	lr!, {r0, r1, r4, r5, r6, r8, r9, ip, sp, lr}
     ee4:	00000600 	andeq	r0, r0, r0, lsl #12
     ee8:	636f7270 	cmnvs	pc, #112, 4
     eec:	5f737365 	svcpl	0x00737365
     ef0:	616e616d 	cmnvs	lr, sp, ror #2
     ef4:	2e726567 	cdpcs	5, 7, cr6, cr2, cr7, {3}
     ef8:	00060068 	andeq	r0, r6, r8, rrx
     efc:	01050000 	mrseq	r0, (UNDEF: 5)
     f00:	d4020500 	strle	r0, [r2], #-1280	; 0xfffffb00
     f04:	03000092 	movweq	r0, #146	; 0x92
     f08:	19050117 	stmdbne	r5, {r0, r1, r2, r4, r8}
     f0c:	4c15054b 	cfldr32mi	mvfx0, [r5], {75}	; 0x4b
     f10:	05d71205 	ldrbeq	r1, [r7, #517]	; 0x205
     f14:	0f056611 	svceq	0x00056611
     f18:	4b01054a 	blmi	42448 <_bss_end+0x368d8>
     f1c:	691105a1 	ldmdbvs	r1, {r0, r5, r7, r8, sl}
     f20:	056a1005 	strbeq	r1, [sl, #-5]!
     f24:	04020017 	streq	r0, [r2], #-23	; 0xffffffe9
     f28:	09054a03 	stmdbeq	r5, {r0, r1, r9, fp, lr}
     f2c:	02040200 	andeq	r0, r4, #0, 4
     f30:	851405d6 	ldrhi	r0, [r4, #-1494]	; 0xfffffa2a
     f34:	052f1505 	streq	r1, [pc, #-1285]!	; a37 <CPSR_IRQ_INHIBIT+0x9b7>
     f38:	10056713 	andne	r6, r5, r3, lsl r7
     f3c:	03010529 	movweq	r0, #5417	; 0x1529
     f40:	1105660a 	tstne	r5, sl, lsl #12
     f44:	6a100569 	bvs	4024f0 <_bss_end+0x3f6980>
     f48:	02001705 	andeq	r1, r0, #1310720	; 0x140000
     f4c:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
     f50:	04020009 	streq	r0, [r2], #-9
     f54:	1405d602 	strne	sp, [r5], #-1538	; 0xfffff9fe
     f58:	2f150585 	svccs	0x00150585
     f5c:	05671305 	strbeq	r1, [r7, #-773]!	; 0xfffffcfb
     f60:	01052910 	tsteq	r5, r0, lsl r9
     f64:	05660a03 	strbeq	r0, [r6, #-2563]!	; 0xfffff5fd
     f68:	10056911 	andne	r6, r5, r1, lsl r9
     f6c:	0017056a 	andseq	r0, r7, sl, ror #10
     f70:	4a030402 	bmi	c1f80 <_bss_end+0xb6410>
     f74:	02000905 	andeq	r0, r0, #81920	; 0x14000
     f78:	05d60204 	ldrbeq	r0, [r6, #516]	; 0x204
     f7c:	15058514 	strne	r8, [r5, #-1300]	; 0xfffffaec
     f80:	6713052f 	ldrvs	r0, [r3, -pc, lsr #10]
     f84:	05291005 	streq	r1, [r9, #-5]!
     f88:	660a0301 	strvs	r0, [sl], -r1, lsl #6
     f8c:	05691105 	strbeq	r1, [r9, #-261]!	; 0xfffffefb
     f90:	17056a10 	smladne	r5, r0, sl, r6
     f94:	03040200 	movweq	r0, #16896	; 0x4200
     f98:	0009054a 	andeq	r0, r9, sl, asr #10
     f9c:	d6020402 	strle	r0, [r2], -r2, lsl #8
     fa0:	05851405 	streq	r1, [r5, #1029]	; 0x405
     fa4:	13052f15 	movwne	r2, #24341	; 0x5f15
     fa8:	29100567 	ldmdbcs	r0, {r0, r1, r2, r5, r6, r8, sl}
     fac:	0a030105 	beq	c13c8 <_bss_end+0xb5858>
     fb0:	4c1c0566 	cfldr32mi	mvfx0, [ip], {102}	; 0x66
     fb4:	05831505 	streq	r1, [r3, #1285]	; 0x505
     fb8:	11058513 	tstne	r5, r3, lsl r5
     fbc:	6a1f054b 	bvs	7c24f0 <_bss_end+0x7b6980>
     fc0:	05838383 	streq	r8, [r3, #899]	; 0x383
     fc4:	12058524 	andne	r8, r5, #36, 10	; 0x9000000
     fc8:	a1230569 			; <UNDEFINED> instruction: 0xa1230569
     fcc:	05680f05 	strbeq	r0, [r8, #-3845]!	; 0xfffff0fb
     fd0:	04020005 	streq	r0, [r2], #-5
     fd4:	18023101 	stmdane	r2, {r0, r8, ip, sp}
     fd8:	b4010100 	strlt	r0, [r1], #-256	; 0xffffff00
     fdc:	03000002 	movweq	r0, #2
     fe0:	00017700 	andeq	r7, r1, r0, lsl #14
     fe4:	fb010200 	blx	417ee <_bss_end+0x35c7e>
     fe8:	01000d0e 	tsteq	r0, lr, lsl #26
     fec:	00010101 	andeq	r0, r1, r1, lsl #2
     ff0:	00010000 	andeq	r0, r1, r0
     ff4:	682f0100 	stmdavs	pc!, {r8}	; <UNPREDICTABLE>
     ff8:	2f656d6f 	svccs	0x00656d6f
     ffc:	686c6973 	stmdavs	ip!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
    1000:	6a797661 	bvs	1e5e98c <_bss_end+0x1e52e1c>
    1004:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
    1008:	2f6c6f6f 	svccs	0x006c6f6f
    100c:	6f72655a 	svcvs	0x0072655a
    1010:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
    1014:	6178652f 	cmnvs	r8, pc, lsr #10
    1018:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
    101c:	33312f73 	teqcc	r1, #460	; 0x1cc
    1020:	6e6f632d 	cdpvs	3, 6, cr6, cr15, cr13, {1}
    1024:	74786574 	ldrbtvc	r6, [r8], #-1396	; 0xfffffa8c
    1028:	6977735f 	ldmdbvs	r7!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, sp, lr}^
    102c:	5f686374 	svcpl	0x00686374
    1030:	696e6f6d 	stmdbvs	lr!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
    1034:	2f726f74 	svccs	0x00726f74
    1038:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
    103c:	732f6c65 			; <UNDEFINED> instruction: 0x732f6c65
    1040:	6d2f6372 	stcvs	3, cr6, [pc, #-456]!	; e80 <CPSR_IRQ_INHIBIT+0xe00>
    1044:	726f6d65 	rsbvc	r6, pc, #6464	; 0x1940
    1048:	682f0079 	stmdavs	pc!, {r0, r3, r4, r5, r6}	; <UNPREDICTABLE>
    104c:	2f656d6f 	svccs	0x00656d6f
    1050:	686c6973 	stmdavs	ip!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
    1054:	6a797661 	bvs	1e5e9e0 <_bss_end+0x1e52e70>
    1058:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
    105c:	2f6c6f6f 	svccs	0x006c6f6f
    1060:	6f72655a 	svcvs	0x0072655a
    1064:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
    1068:	6178652f 	cmnvs	r8, pc, lsr #10
    106c:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
    1070:	33312f73 	teqcc	r1, #460	; 0x1cc
    1074:	6e6f632d 	cdpvs	3, 6, cr6, cr15, cr13, {1}
    1078:	74786574 	ldrbtvc	r6, [r8], #-1396	; 0xfffffa8c
    107c:	6977735f 	ldmdbvs	r7!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, sp, lr}^
    1080:	5f686374 	svcpl	0x00686374
    1084:	696e6f6d 	stmdbvs	lr!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
    1088:	2f726f74 	svccs	0x00726f74
    108c:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
    1090:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
    1094:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
    1098:	622f6564 	eorvs	r6, pc, #100, 10	; 0x19000000
    109c:	6472616f 	ldrbtvs	r6, [r2], #-367	; 0xfffffe91
    10a0:	6970722f 	ldmdbvs	r0!, {r0, r1, r2, r3, r5, r9, ip, sp, lr}^
    10a4:	61682f30 	cmnvs	r8, r0, lsr pc
    10a8:	682f006c 	stmdavs	pc!, {r2, r3, r5, r6}	; <UNPREDICTABLE>
    10ac:	2f656d6f 	svccs	0x00656d6f
    10b0:	686c6973 	stmdavs	ip!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
    10b4:	6a797661 	bvs	1e5ea40 <_bss_end+0x1e52ed0>
    10b8:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
    10bc:	2f6c6f6f 	svccs	0x006c6f6f
    10c0:	6f72655a 	svcvs	0x0072655a
    10c4:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
    10c8:	6178652f 	cmnvs	r8, pc, lsr #10
    10cc:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
    10d0:	33312f73 	teqcc	r1, #460	; 0x1cc
    10d4:	6e6f632d 	cdpvs	3, 6, cr6, cr15, cr13, {1}
    10d8:	74786574 	ldrbtvc	r6, [r8], #-1396	; 0xfffffa8c
    10dc:	6977735f 	ldmdbvs	r7!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, sp, lr}^
    10e0:	5f686374 	svcpl	0x00686374
    10e4:	696e6f6d 	stmdbvs	lr!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
    10e8:	2f726f74 	svccs	0x00726f74
    10ec:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
    10f0:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
    10f4:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
    10f8:	6d2f6564 	cfstr32vs	mvfx6, [pc, #-400]!	; f70 <CPSR_IRQ_INHIBIT+0xef0>
    10fc:	726f6d65 	rsbvc	r6, pc, #6464	; 0x1940
    1100:	6b000079 	blvs	12ec <CPSR_IRQ_INHIBIT+0x126c>
    1104:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
    1108:	65685f6c 	strbvs	r5, [r8, #-3948]!	; 0xfffff094
    110c:	632e7061 			; <UNDEFINED> instruction: 0x632e7061
    1110:	01007070 	tsteq	r0, r0, ror r0
    1114:	6e690000 	cdpvs	0, 6, cr0, cr9, cr0, {0}
    1118:	66656474 			; <UNDEFINED> instruction: 0x66656474
    111c:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
    1120:	656b0000 	strbvs	r0, [fp, #-0]!
    1124:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
    1128:	6165685f 	cmnvs	r5, pc, asr r8
    112c:	00682e70 	rsbeq	r2, r8, r0, ror lr
    1130:	70000003 	andvc	r0, r0, r3
    1134:	70697265 	rsbvc	r7, r9, r5, ror #4
    1138:	61726568 	cmnvs	r2, r8, ror #10
    113c:	682e736c 	stmdavs	lr!, {r2, r3, r5, r6, r8, r9, ip, sp, lr}
    1140:	00000200 	andeq	r0, r0, r0, lsl #4
    1144:	6d6d656d 	cfstr64vs	mvdx6, [sp, #-436]!	; 0xfffffe4c
    1148:	682e7061 	stmdavs	lr!, {r0, r5, r6, ip, sp, lr}
    114c:	00000300 	andeq	r0, r0, r0, lsl #6
    1150:	65676170 	strbvs	r6, [r7, #-368]!	; 0xfffffe90
    1154:	00682e73 	rsbeq	r2, r8, r3, ror lr
    1158:	00000003 	andeq	r0, r0, r3
    115c:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
    1160:	0095bc02 	addseq	fp, r5, r2, lsl #24
    1164:	1d051700 	stcne	7, cr1, [r5, #-0]
    1168:	660c0585 	strvs	r0, [ip], -r5, lsl #11
    116c:	854b0105 	strbhi	r0, [fp, #-261]	; 0xfffffefb
    1170:	05836d05 	streq	r6, [r3, #3333]	; 0xd05
    1174:	1105666f 	tstne	r5, pc, ror #12
    1178:	0567672f 	strbeq	r6, [r7, #-1839]!	; 0xfffff8d1
    117c:	0c056714 	stceq	7, cr6, [r5], {20}
    1180:	2f010568 	svccs	0x00010568
    1184:	9f2005a1 	svcls	0x002005a1
    1188:	05691d05 	strbeq	r1, [r9, #-3333]!	; 0xfffff2fb
    118c:	04020029 	streq	r0, [r2], #-41	; 0xffffffd7
    1190:	1d056601 	stcne	6, cr6, [r5, #-4]
    1194:	01040200 	mrseq	r0, R12_usr
    1198:	003b054a 	eorseq	r0, fp, sl, asr #10
    119c:	4a020402 	bmi	821ac <_bss_end+0x7663c>
    11a0:	02003105 	andeq	r3, r0, #1073741825	; 0x40000001
    11a4:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
    11a8:	0505680f 	streq	r6, [r5, #-2063]	; 0xfffff7f1
    11ac:	10053364 	andne	r3, r5, r4, ror #6
    11b0:	05054f6a 	streq	r4, [r5, #-3946]	; 0xfffff096
    11b4:	0027054a 	eoreq	r0, r7, sl, asr #10
    11b8:	66010402 	strvs	r0, [r1], -r2, lsl #8
    11bc:	02005805 	andeq	r5, r0, #327680	; 0x50000
    11c0:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
    11c4:	0402001d 	streq	r0, [r2], #-29	; 0xffffffe3
    11c8:	18054a01 	stmdane	r5, {r0, r9, fp, lr}
    11cc:	6754054c 	ldrbvs	r0, [r4, -ip, asr #10]
    11d0:	6c019a05 			; <UNDEFINED> instruction: 0x6c019a05
    11d4:	054a2005 	strbeq	r2, [sl, #-5]
    11d8:	1e056819 	mcrne	8, 0, r6, cr5, cr9, {0}
    11dc:	4a25054a 	bmi	94270c <_bss_end+0x936b9c>
    11e0:	4c2e1005 	stcmi	0, cr1, [lr], #-20	; 0xffffffec
    11e4:	05671905 	strbeq	r1, [r7, #-2309]!	; 0xfffff6fb
    11e8:	13054a10 	movwne	r4, #23056	; 0x5a10
    11ec:	6711054b 	ldrvs	r0, [r1, -fp, asr #10]
    11f0:	67140568 	ldrvs	r0, [r4, -r8, ror #10]
    11f4:	05685005 	strbeq	r5, [r8, #-5]!
    11f8:	05854b01 	streq	r4, [r5, #2817]	; 0xb01
    11fc:	14059f20 	strne	r9, [r5], #-3872	; 0xfffff0e0
    1200:	69100568 	ldmdbvs	r0, {r3, r5, r6, r8, sl}
    1204:	054a0505 	strbeq	r0, [sl, #-1285]	; 0xfffffafb
    1208:	0402001f 	streq	r0, [r2], #-31	; 0xffffffe1
    120c:	25054a01 	strcs	r4, [r5, #-2561]	; 0xfffff5ff
    1210:	01040200 	mrseq	r0, R12_usr
    1214:	0015054a 	andseq	r0, r5, sl, asr #10
    1218:	2e010402 	cdpcs	4, 0, cr0, cr1, cr2, {0}
    121c:	4a1f054c 	bmi	7c2754 <_bss_end+0x7b6be4>
    1220:	054a2505 	strbeq	r2, [sl, #-1285]	; 0xfffffafb
    1224:	1e052e15 	mcrne	14, 0, r2, cr5, cr5, {0}
    1228:	4a240583 	bmi	90283c <_bss_end+0x8f6ccc>
    122c:	052e1505 	streq	r1, [lr, #-1285]!	; 0xfffffafb
    1230:	1b054b10 	blne	153e78 <_bss_end+0x148308>
    1234:	4e10054a 	cfmac32mi	mvfx0, mvfx0, mvfx10
    1238:	054a0505 	strbeq	r0, [sl, #-1285]	; 0xfffffafb
    123c:	0402001f 	streq	r0, [r2], #-31	; 0xffffffe1
    1240:	25054a01 	strcs	r4, [r5, #-2561]	; 0xfffff5ff
    1244:	01040200 	mrseq	r0, R12_usr
    1248:	0015054a 	andseq	r0, r5, sl, asr #10
    124c:	2e010402 	cdpcs	4, 0, cr0, cr1, cr2, {0}
    1250:	054c1005 	strbeq	r1, [ip, #-5]
    1254:	25054a1b 	strcs	r4, [r5, #-2587]	; 0xfffff5e5
    1258:	4a1b052e 	bmi	6c2718 <_bss_end+0x6b6ba8>
    125c:	052e1005 	streq	r1, [lr, #-5]!
    1260:	10054a1b 	andne	r4, r5, fp, lsl sl
    1264:	4a24054b 	bmi	902798 <_bss_end+0x8f6c28>
    1268:	054a1b05 	strbeq	r1, [sl, #-2821]	; 0xfffff4fb
    126c:	24052f10 	strcs	r2, [r5], #-3856	; 0xfffff0f0
    1270:	4a1b054a 	bmi	6c27a0 <_bss_end+0x6b6c30>
    1274:	82300105 	eorshi	r0, r0, #1073741825	; 0x40000001
    1278:	0402009e 	streq	r0, [r2], #-158	; 0xffffff62
    127c:	05660601 	strbeq	r0, [r6, #-1537]!	; 0xfffff9ff
    1280:	ad030616 	stcge	6, cr0, [r3, #-88]	; 0xffffffa8
    1284:	0105827f 	tsteq	r5, pc, ror r2
    1288:	4a00d303 	bmi	35e9c <_bss_end+0x2a32c>
    128c:	0a024a9e 	beq	93d0c <_bss_end+0x8819c>
    1290:	28010100 	stmdacs	r1, {r8}
    1294:	03000002 	movweq	r0, #2
    1298:	00016000 	andeq	r6, r1, r0
    129c:	fb010200 	blx	41aa6 <_bss_end+0x35f36>
    12a0:	01000d0e 	tsteq	r0, lr, lsl #26
    12a4:	00010101 	andeq	r0, r1, r1, lsl #2
    12a8:	00010000 	andeq	r0, r1, r0
    12ac:	682f0100 	stmdavs	pc!, {r8}	; <UNPREDICTABLE>
    12b0:	2f656d6f 	svccs	0x00656d6f
    12b4:	686c6973 	stmdavs	ip!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
    12b8:	6a797661 	bvs	1e5ec44 <_bss_end+0x1e530d4>
    12bc:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
    12c0:	2f6c6f6f 	svccs	0x006c6f6f
    12c4:	6f72655a 	svcvs	0x0072655a
    12c8:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
    12cc:	6178652f 	cmnvs	r8, pc, lsr #10
    12d0:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
    12d4:	33312f73 	teqcc	r1, #460	; 0x1cc
    12d8:	6e6f632d 	cdpvs	3, 6, cr6, cr15, cr13, {1}
    12dc:	74786574 	ldrbtvc	r6, [r8], #-1396	; 0xfffffa8c
    12e0:	6977735f 	ldmdbvs	r7!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, sp, lr}^
    12e4:	5f686374 	svcpl	0x00686374
    12e8:	696e6f6d 	stmdbvs	lr!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
    12ec:	2f726f74 	svccs	0x00726f74
    12f0:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
    12f4:	732f6c65 			; <UNDEFINED> instruction: 0x732f6c65
    12f8:	6d2f6372 	stcvs	3, cr6, [pc, #-456]!	; 1138 <CPSR_IRQ_INHIBIT+0x10b8>
    12fc:	726f6d65 	rsbvc	r6, pc, #6464	; 0x1940
    1300:	682f0079 	stmdavs	pc!, {r0, r3, r4, r5, r6}	; <UNPREDICTABLE>
    1304:	2f656d6f 	svccs	0x00656d6f
    1308:	686c6973 	stmdavs	ip!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
    130c:	6a797661 	bvs	1e5ec98 <_bss_end+0x1e53128>
    1310:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
    1314:	2f6c6f6f 	svccs	0x006c6f6f
    1318:	6f72655a 	svcvs	0x0072655a
    131c:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
    1320:	6178652f 	cmnvs	r8, pc, lsr #10
    1324:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
    1328:	33312f73 	teqcc	r1, #460	; 0x1cc
    132c:	6e6f632d 	cdpvs	3, 6, cr6, cr15, cr13, {1}
    1330:	74786574 	ldrbtvc	r6, [r8], #-1396	; 0xfffffa8c
    1334:	6977735f 	ldmdbvs	r7!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, sp, lr}^
    1338:	5f686374 	svcpl	0x00686374
    133c:	696e6f6d 	stmdbvs	lr!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
    1340:	2f726f74 	svccs	0x00726f74
    1344:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
    1348:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
    134c:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
    1350:	622f6564 	eorvs	r6, pc, #100, 10	; 0x19000000
    1354:	6472616f 	ldrbtvs	r6, [r2], #-367	; 0xfffffe91
    1358:	6970722f 	ldmdbvs	r0!, {r0, r1, r2, r3, r5, r9, ip, sp, lr}^
    135c:	61682f30 	cmnvs	r8, r0, lsr pc
    1360:	682f006c 	stmdavs	pc!, {r2, r3, r5, r6}	; <UNPREDICTABLE>
    1364:	2f656d6f 	svccs	0x00656d6f
    1368:	686c6973 	stmdavs	ip!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
    136c:	6a797661 	bvs	1e5ecf8 <_bss_end+0x1e53188>
    1370:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
    1374:	2f6c6f6f 	svccs	0x006c6f6f
    1378:	6f72655a 	svcvs	0x0072655a
    137c:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
    1380:	6178652f 	cmnvs	r8, pc, lsr #10
    1384:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
    1388:	33312f73 	teqcc	r1, #460	; 0x1cc
    138c:	6e6f632d 	cdpvs	3, 6, cr6, cr15, cr13, {1}
    1390:	74786574 	ldrbtvc	r6, [r8], #-1396	; 0xfffffa8c
    1394:	6977735f 	ldmdbvs	r7!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, sp, lr}^
    1398:	5f686374 	svcpl	0x00686374
    139c:	696e6f6d 	stmdbvs	lr!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
    13a0:	2f726f74 	svccs	0x00726f74
    13a4:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
    13a8:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
    13ac:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
    13b0:	6d2f6564 	cfstr32vs	mvfx6, [pc, #-400]!	; 1228 <CPSR_IRQ_INHIBIT+0x11a8>
    13b4:	726f6d65 	rsbvc	r6, pc, #6464	; 0x1940
    13b8:	70000079 	andvc	r0, r0, r9, ror r0
    13bc:	73656761 	cmnvc	r5, #25427968	; 0x1840000
    13c0:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
    13c4:	00000100 	andeq	r0, r0, r0, lsl #2
    13c8:	64746e69 	ldrbtvs	r6, [r4], #-3689	; 0xfffff197
    13cc:	682e6665 	stmdavs	lr!, {r0, r2, r5, r6, r9, sl, sp, lr}
    13d0:	00000200 	andeq	r0, r0, r0, lsl #4
    13d4:	69726570 	ldmdbvs	r2!, {r4, r5, r6, r8, sl, sp, lr}^
    13d8:	72656870 	rsbvc	r6, r5, #112, 16	; 0x700000
    13dc:	2e736c61 	cdpcs	12, 7, cr6, cr3, cr1, {3}
    13e0:	00020068 	andeq	r0, r2, r8, rrx
    13e4:	6d656d00 	stclvs	13, cr6, [r5, #-0]
    13e8:	2e70616d 	rpwcssz	f6, f0, #5.0
    13ec:	00030068 	andeq	r0, r3, r8, rrx
    13f0:	67617000 	strbvs	r7, [r1, -r0]!
    13f4:	682e7365 	stmdavs	lr!, {r0, r2, r5, r6, r8, r9, ip, sp, lr}
    13f8:	00000300 	andeq	r0, r0, r0, lsl #6
    13fc:	00010500 	andeq	r0, r1, r0, lsl #10
    1400:	99280205 	stmdbls	r8!, {r0, r2, r9}
    1404:	05160000 	ldreq	r0, [r6, #-0]
    1408:	1505850e 	strne	r8, [r5, #-1294]	; 0xfffffaf2
    140c:	03040200 	movweq	r0, #16896	; 0x4200
    1410:	0017054a 	andseq	r0, r7, sl, asr #10
    1414:	2e030402 	cdpcs	4, 0, cr0, cr3, cr2, {0}
    1418:	02001905 	andeq	r1, r0, #81920	; 0x14000
    141c:	05670204 	strbeq	r0, [r7, #-516]!	; 0xfffffdfc
    1420:	04020005 	streq	r0, [r2], #-5
    1424:	01059d02 	tsteq	r5, r2, lsl #26
    1428:	0505bd86 	streq	fp, [r5, #-3462]	; 0xfffff27a
    142c:	671f05d7 			; <UNDEFINED> instruction: 0x671f05d7
    1430:	054a2405 	strbeq	r2, [sl, #-1029]	; 0xfffffbfb
    1434:	29056636 	stmdbcs	r5, {r1, r2, r4, r5, r9, sl, sp, lr}
    1438:	4a24054a 	bmi	902968 <_bss_end+0x8f6df8>
    143c:	05bd0105 	ldreq	r0, [sp, #261]!	; 0x105
    1440:	24052d1f 	strcs	r2, [r5], #-3359	; 0xfffff2e1
    1444:	6638054a 	ldrtvs	r0, [r8], -sl, asr #10
    1448:	054a2b05 	strbeq	r2, [sl, #-2821]	; 0xfffff4fb
    144c:	01054a24 	tsteq	r5, r4, lsr #20
    1450:	0c0585f3 	cfstr32eq	mvfx8, [r5], {243}	; 0xf3
    1454:	00130589 	andseq	r0, r3, r9, lsl #11
    1458:	4a010402 	bmi	42468 <_bss_end+0x368f8>
    145c:	05851b05 	streq	r1, [r5, #2821]	; 0xb05
    1460:	14058209 	strne	r8, [r5], #-521	; 0xfffffdf7
    1464:	001b054d 	andseq	r0, fp, sp, asr #10
    1468:	4a010402 	bmi	42478 <_bss_end+0x36908>
    146c:	05682405 	strbeq	r2, [r8, #-1029]!	; 0xfffffbfb
    1470:	11059e32 	tstne	r5, r2, lsr lr
    1474:	4d310566 	cfldr32mi	mvfx0, [r1, #-408]!	; 0xfffffe68
    1478:	054a2405 	strbeq	r2, [sl, #-1029]	; 0xfffffbfb
    147c:	2b056719 	blcs	15b0e8 <_bss_end+0x14f578>
    1480:	4a3d0583 	bmi	f42a94 <_bss_end+0xf36f24>
    1484:	02000d05 	andeq	r0, r0, #320	; 0x140
    1488:	79030204 	stmdbvc	r3, {r2, r9}
    148c:	0005054a 	andeq	r0, r5, sl, asr #10
    1490:	03020402 	movweq	r0, #9218	; 0x2402
    1494:	0c05827a 	sfmeq	f0, 1, [r5], {122}	; 0x7a
    1498:	05821303 	streq	r1, [r2, #771]	; 0x303
    149c:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
    14a0:	0105a109 	tsteq	r5, r9, lsl #2
    14a4:	009e66bb 			; <UNDEFINED> instruction: 0x009e66bb
    14a8:	06010402 	streq	r0, [r1], -r2, lsl #8
    14ac:	060f0566 	streq	r0, [pc], -r6, ror #10
    14b0:	05824a03 	streq	r4, [r2, #2563]	; 0xa03
    14b4:	4a360301 	bmi	d820c0 <_bss_end+0xd76550>
    14b8:	0a024a9e 	beq	93f38 <_bss_end+0x883c8>
    14bc:	d4010100 	strle	r0, [r1], #-256	; 0xffffff00
    14c0:	03000004 	movweq	r0, #4
    14c4:	00025d00 	andeq	r5, r2, r0, lsl #26
    14c8:	fb010200 	blx	41cd2 <_bss_end+0x36162>
    14cc:	01000d0e 	tsteq	r0, lr, lsl #26
    14d0:	00010101 	andeq	r0, r1, r1, lsl #2
    14d4:	00010000 	andeq	r0, r1, r0
    14d8:	682f0100 	stmdavs	pc!, {r8}	; <UNPREDICTABLE>
    14dc:	2f656d6f 	svccs	0x00656d6f
    14e0:	686c6973 	stmdavs	ip!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
    14e4:	6a797661 	bvs	1e5ee70 <_bss_end+0x1e53300>
    14e8:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
    14ec:	2f6c6f6f 	svccs	0x006c6f6f
    14f0:	6f72655a 	svcvs	0x0072655a
    14f4:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
    14f8:	6178652f 	cmnvs	r8, pc, lsr #10
    14fc:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
    1500:	33312f73 	teqcc	r1, #460	; 0x1cc
    1504:	6e6f632d 	cdpvs	3, 6, cr6, cr15, cr13, {1}
    1508:	74786574 	ldrbtvc	r6, [r8], #-1396	; 0xfffffa8c
    150c:	6977735f 	ldmdbvs	r7!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, sp, lr}^
    1510:	5f686374 	svcpl	0x00686374
    1514:	696e6f6d 	stmdbvs	lr!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
    1518:	2f726f74 	svccs	0x00726f74
    151c:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
    1520:	732f6c65 			; <UNDEFINED> instruction: 0x732f6c65
    1524:	702f6372 	eorvc	r6, pc, r2, ror r3	; <UNPREDICTABLE>
    1528:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    152c:	2f007373 	svccs	0x00007373
    1530:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
    1534:	6c69732f 	stclvs	3, cr7, [r9], #-188	; 0xffffff44
    1538:	79766168 	ldmdbvc	r6!, {r3, r5, r6, r8, sp, lr}^
    153c:	63532f6a 	cmpvs	r3, #424	; 0x1a8
    1540:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; 13a8 <CPSR_IRQ_INHIBIT+0x1328>
    1544:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
    1548:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
    154c:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
    1550:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
    1554:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
    1558:	6f632d33 	svcvs	0x00632d33
    155c:	7865746e 	stmdavc	r5!, {r1, r2, r3, r5, r6, sl, ip, sp, lr}^
    1560:	77735f74 			; <UNDEFINED> instruction: 0x77735f74
    1564:	68637469 	stmdavs	r3!, {r0, r3, r5, r6, sl, ip, sp, lr}^
    1568:	6e6f6d5f 	mcrvs	13, 3, r6, cr15, cr15, {2}
    156c:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
    1570:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
    1574:	2f6c656e 	svccs	0x006c656e
    1578:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
    157c:	2f656475 	svccs	0x00656475
    1580:	6f6d656d 	svcvs	0x006d656d
    1584:	2f007972 	svccs	0x00007972
    1588:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
    158c:	6c69732f 	stclvs	3, cr7, [r9], #-188	; 0xffffff44
    1590:	79766168 	ldmdbvc	r6!, {r3, r5, r6, r8, sp, lr}^
    1594:	63532f6a 	cmpvs	r3, #424	; 0x1a8
    1598:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; 1400 <CPSR_IRQ_INHIBIT+0x1380>
    159c:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
    15a0:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
    15a4:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
    15a8:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
    15ac:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
    15b0:	6f632d33 	svcvs	0x00632d33
    15b4:	7865746e 	stmdavc	r5!, {r1, r2, r3, r5, r6, sl, ip, sp, lr}^
    15b8:	77735f74 			; <UNDEFINED> instruction: 0x77735f74
    15bc:	68637469 	stmdavs	r3!, {r0, r3, r5, r6, sl, ip, sp, lr}^
    15c0:	6e6f6d5f 	mcrvs	13, 3, r6, cr15, cr15, {2}
    15c4:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
    15c8:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
    15cc:	2f6c656e 	svccs	0x006c656e
    15d0:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
    15d4:	2f656475 	svccs	0x00656475
    15d8:	72616f62 	rsbvc	r6, r1, #392	; 0x188
    15dc:	70722f64 	rsbsvc	r2, r2, r4, ror #30
    15e0:	682f3069 	stmdavs	pc!, {r0, r3, r5, r6, ip, sp}	; <UNPREDICTABLE>
    15e4:	2f006c61 	svccs	0x00006c61
    15e8:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
    15ec:	6c69732f 	stclvs	3, cr7, [r9], #-188	; 0xffffff44
    15f0:	79766168 	ldmdbvc	r6!, {r3, r5, r6, r8, sp, lr}^
    15f4:	63532f6a 	cmpvs	r3, #424	; 0x1a8
    15f8:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; 1460 <CPSR_IRQ_INHIBIT+0x13e0>
    15fc:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
    1600:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
    1604:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
    1608:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
    160c:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
    1610:	6f632d33 	svcvs	0x00632d33
    1614:	7865746e 	stmdavc	r5!, {r1, r2, r3, r5, r6, sl, ip, sp, lr}^
    1618:	77735f74 			; <UNDEFINED> instruction: 0x77735f74
    161c:	68637469 	stmdavs	r3!, {r0, r3, r5, r6, sl, ip, sp, lr}^
    1620:	6e6f6d5f 	mcrvs	13, 3, r6, cr15, cr15, {2}
    1624:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
    1628:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
    162c:	2f6c656e 	svccs	0x006c656e
    1630:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
    1634:	2f656475 	svccs	0x00656475
    1638:	636f7270 	cmnvs	pc, #112, 4
    163c:	00737365 	rsbseq	r7, r3, r5, ror #6
    1640:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 158c <CPSR_IRQ_INHIBIT+0x150c>
    1644:	69732f65 	ldmdbvs	r3!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
    1648:	7661686c 	strbtvc	r6, [r1], -ip, ror #16
    164c:	532f6a79 			; <UNDEFINED> instruction: 0x532f6a79
    1650:	6f6f6863 	svcvs	0x006f6863
    1654:	655a2f6c 	ldrbvs	r2, [sl, #-3948]	; 0xfffff094
    1658:	614d6f72 	hvcvs	55026	; 0xd6f2
    165c:	652f6574 	strvs	r6, [pc, #-1396]!	; 10f0 <CPSR_IRQ_INHIBIT+0x1070>
    1660:	706d6178 	rsbvc	r6, sp, r8, ror r1
    1664:	2f73656c 	svccs	0x0073656c
    1668:	632d3331 			; <UNDEFINED> instruction: 0x632d3331
    166c:	65746e6f 	ldrbvs	r6, [r4, #-3695]!	; 0xfffff191
    1670:	735f7478 	cmpvc	pc, #120, 8	; 0x78000000
    1674:	63746977 	cmnvs	r4, #1949696	; 0x1dc000
    1678:	6f6d5f68 	svcvs	0x006d5f68
    167c:	6f74696e 	svcvs	0x0074696e
    1680:	656b2f72 	strbvs	r2, [fp, #-3954]!	; 0xfffff08e
    1684:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
    1688:	636e692f 	cmnvs	lr, #770048	; 0xbc000
    168c:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
    1690:	6972642f 	ldmdbvs	r2!, {r0, r1, r2, r3, r5, sl, sp, lr}^
    1694:	73726576 	cmnvc	r2, #494927872	; 0x1d800000
    1698:	72700000 	rsbsvc	r0, r0, #0
    169c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    16a0:	616d5f73 	smcvs	54771	; 0xd5f3
    16a4:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
    16a8:	70632e72 	rsbvc	r2, r3, r2, ror lr
    16ac:	00010070 	andeq	r0, r1, r0, ror r0
    16b0:	72656b00 	rsbvc	r6, r5, #0, 22
    16b4:	5f6c656e 	svcpl	0x006c656e
    16b8:	70616568 	rsbvc	r6, r1, r8, ror #10
    16bc:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
    16c0:	6e690000 	cdpvs	0, 6, cr0, cr9, cr0, {0}
    16c4:	66656474 			; <UNDEFINED> instruction: 0x66656474
    16c8:	0300682e 	movweq	r6, #2094	; 0x82e
    16cc:	72700000 	rsbsvc	r0, r0, #0
    16d0:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    16d4:	00682e73 	rsbeq	r2, r8, r3, ror lr
    16d8:	70000004 	andvc	r0, r0, r4
    16dc:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    16e0:	6d5f7373 	ldclvs	3, cr7, [pc, #-460]	; 151c <CPSR_IRQ_INHIBIT+0x149c>
    16e4:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
    16e8:	682e7265 	stmdavs	lr!, {r0, r2, r5, r6, r9, ip, sp, lr}
    16ec:	00000400 	andeq	r0, r0, r0, lsl #8
    16f0:	696e6f6d 	stmdbvs	lr!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
    16f4:	2e726f74 	mrccs	15, 3, r6, cr2, cr4, {3}
    16f8:	00050068 	andeq	r0, r5, r8, rrx
    16fc:	72657000 	rsbvc	r7, r5, #0
    1700:	65687069 	strbvs	r7, [r8, #-105]!	; 0xffffff97
    1704:	736c6172 	cmnvc	ip, #-2147483620	; 0x8000001c
    1708:	0300682e 	movweq	r6, #2094	; 0x82e
    170c:	656d0000 	strbvs	r0, [sp, #-0]!
    1710:	70616d6d 	rsbvc	r6, r1, sp, ror #26
    1714:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
    1718:	61700000 	cmnvs	r0, r0
    171c:	2e736567 	cdpcs	5, 7, cr6, cr3, cr7, {3}
    1720:	00020068 	andeq	r0, r2, r8, rrx
    1724:	01050000 	mrseq	r0, (UNDEF: 5)
    1728:	cc020500 	cfstr32gt	mvfx0, [r2], {-0}
    172c:	0300009b 	movweq	r0, #155	; 0x9b
    1730:	1d050110 	stfnes	f0, [r5, #-64]	; 0xffffffc0
    1734:	08010585 	stmdaeq	r1, {r0, r2, r7, r8, sl}
    1738:	0c05a123 	stfeqd	f2, [r5], {35}	; 0x23
    173c:	4a1f0583 	bmi	7c2d50 <_bss_end+0x7b71e0>
    1740:	02002105 	andeq	r2, r0, #1073741825	; 0x40000001
    1744:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
    1748:	0402001f 	streq	r0, [r2], #-31	; 0xffffffe1
    174c:	3c054a01 			; <UNDEFINED> instruction: 0x3c054a01
    1750:	01040200 	mrseq	r0, R12_usr
    1754:	001f052e 	andseq	r0, pc, lr, lsr #10
    1758:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
    175c:	02000105 	andeq	r0, r0, #1073741825	; 0x40000001
    1760:	852f0504 	strhi	r0, [pc, #-1284]!	; 1264 <CPSR_IRQ_INHIBIT+0x11e4>
    1764:	05834805 	streq	r4, [r3, #2053]	; 0x805
    1768:	14058416 	strne	r8, [r5], #-1046	; 0xfffffbea
    176c:	09054b4a 	stmdbeq	r5, {r1, r3, r6, r8, r9, fp, lr}
    1770:	4a050567 	bmi	142d14 <_bss_end+0x1371a4>
    1774:	054c0905 	strbeq	r0, [ip, #-2309]	; 0xfffff6fb
    1778:	1c054a22 			; <UNDEFINED> instruction: 0x1c054a22
    177c:	6934056a 	ldmdbvs	r4!, {r1, r3, r5, r6, r8, sl}
    1780:	05661405 	strbeq	r1, [r6, #-1029]!	; 0xfffffbfb
    1784:	13054c0b 	movwne	r4, #23563	; 0x5c0b
    1788:	4a110568 	bmi	442d30 <_bss_end+0x4371c0>
    178c:	052e0f05 	streq	r0, [lr, #-3845]!	; 0xfffff0fb
    1790:	0f054a13 	svceq	0x00054a13
    1794:	4b21054a 	blmi	842cc4 <_bss_end+0x837154>
    1798:	4a190567 	bmi	642d3c <_bss_end+0x6371cc>
    179c:	054b1105 	strbeq	r1, [fp, #-261]	; 0xfffffefb
    17a0:	1805681a 	stmdane	r5, {r1, r3, r4, fp, sp, lr}
    17a4:	4b01054a 	blmi	42cd4 <_bss_end+0x37164>
    17a8:	9f480585 	svcls	0x00480585
    17ac:	05841605 	streq	r1, [r4, #1541]	; 0x605
    17b0:	054b4a14 	strbeq	r4, [fp, #-2580]	; 0xfffff5ec
    17b4:	1e056705 	cdpne	7, 0, cr6, cr5, cr5, {0}
    17b8:	4b18054a 	blmi	602ce8 <_bss_end+0x5f7178>
    17bc:	05680905 	strbeq	r0, [r8, #-2309]!	; 0xfffff6fb
    17c0:	1c054a05 			; <UNDEFINED> instruction: 0x1c054a05
    17c4:	6934054c 	ldmdbvs	r4!, {r2, r3, r6, r8, sl}
    17c8:	05661405 	strbeq	r1, [r6, #-1029]!	; 0xfffffbfb
    17cc:	13054c0b 	movwne	r4, #23563	; 0x5c0b
    17d0:	4a110568 	bmi	442d78 <_bss_end+0x437208>
    17d4:	052e0f05 	streq	r0, [lr, #-3845]!	; 0xfffff0fb
    17d8:	0f054a13 	svceq	0x00054a13
    17dc:	4b21054a 	blmi	842d0c <_bss_end+0x83719c>
    17e0:	4a190567 	bmi	642d84 <_bss_end+0x637214>
    17e4:	054b1105 	strbeq	r1, [fp, #-261]	; 0xfffffefb
    17e8:	0567681a 	strbeq	r6, [r7, #-2074]!	; 0xfffff7e6
    17ec:	5305674f 	movwpl	r6, #22351	; 0x574f
    17f0:	2e1a0566 	cfmsc32cs	mvfx0, mvfx10, mvfx6
    17f4:	054c1105 	strbeq	r1, [ip, #-261]	; 0xfffffefb
    17f8:	4b058244 	blmi	162110 <_bss_end+0x1565a0>
    17fc:	831105ba 	tsthi	r1, #780140544	; 0x2e800000
    1800:	05823605 	streq	r3, [r2, #1541]	; 0x605
    1804:	6305825d 	movwvs	r8, #21085	; 0x525d
    1808:	681205ba 	ldmdavs	r2, {r1, r3, r4, r5, r7, r8, sl}
    180c:	084b0105 	stmdaeq	fp, {r0, r2, r8}^
    1810:	8409055b 	strhi	r0, [r9], #-1371	; 0xfffffaa5
    1814:	054a0505 	strbeq	r0, [sl, #-1285]	; 0xfffffafb
    1818:	1d054d09 	stcne	13, cr4, [r5, #-36]	; 0xffffffdc
    181c:	2e23054a 	cfsh64cs	mvdx0, mvdx3, #42
    1820:	052e3005 	streq	r3, [lr, #-5]!
    1824:	21054c0d 	tstcs	r5, sp, lsl #24
    1828:	2e27054a 	cfsh64cs	mvdx0, mvdx7, #42
    182c:	052e0905 	streq	r0, [lr, #-2309]!	; 0xfffff6fb
    1830:	0402003c 	streq	r0, [r2], #-60	; 0xffffffc4
    1834:	50054a01 	andpl	r4, r5, r1, lsl #20
    1838:	01040200 	mrseq	r0, R12_usr
    183c:	0056054a 	subseq	r0, r6, sl, asr #10
    1840:	2e010402 	cdpcs	4, 0, cr0, cr1, cr2, {0}
    1844:	02003905 	andeq	r3, r0, #81920	; 0x14000
    1848:	052e0104 	streq	r0, [lr, #-260]!	; 0xfffffefc
    184c:	33055120 	movwcc	r5, #20768	; 0x5120
    1850:	0035054a 	eorseq	r0, r5, sl, asr #10
    1854:	4a010402 	bmi	42864 <_bss_end+0x36cf4>
    1858:	02003305 	andeq	r3, r0, #335544320	; 0x14000000
    185c:	004a0104 	subeq	r0, sl, r4, lsl #2
    1860:	06020402 	streq	r0, [r2], -r2, lsl #8
    1864:	0019054a 	andseq	r0, r9, sl, asr #10
    1868:	06040402 	streq	r0, [r4], -r2, lsl #8
    186c:	0005054a 	andeq	r0, r5, sl, asr #10
    1870:	2f040402 	svccs	0x00040402
    1874:	05670e05 	strbeq	r0, [r7, #-3589]!	; 0xfffff1fb
    1878:	18056a12 	stmdane	r5, {r1, r4, r9, fp, sp, lr}
    187c:	2e64054a 	cdpcs	5, 6, cr0, cr4, cr10, {2}
    1880:	02004005 	andeq	r4, r0, #5
    1884:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
    1888:	04020046 	streq	r0, [r2], #-70	; 0xffffffba
    188c:	37054a01 	strcc	r4, [r5, -r1, lsl #20]
    1890:	01040200 	mrseq	r0, R12_usr
    1894:	006d052e 	rsbeq	r0, sp, lr, lsr #10
    1898:	4a020402 	bmi	828a8 <_bss_end+0x76d38>
    189c:	02007305 	andeq	r7, r0, #335544320	; 0x14000000
    18a0:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
    18a4:	04020064 	streq	r0, [r2], #-100	; 0xffffff9c
    18a8:	09052e02 	stmdbeq	r5, {r1, r9, sl, fp, sp}
    18ac:	6812054c 	ldmdavs	r2, {r2, r3, r6, r8, sl}
    18b0:	05670d05 	strbeq	r0, [r7, #-3333]!	; 0xfffff2fb
    18b4:	05053112 	streq	r3, [r5, #-274]	; 0xfffffeee
    18b8:	05667803 	strbeq	r7, [r6, #-2051]!	; 0xfffff7fd
    18bc:	2e0c0311 	mcrcs	3, 0, r0, cr12, cr1, {0}
    18c0:	054a0505 	strbeq	r0, [sl, #-1285]	; 0xfffffafb
    18c4:	47056933 	smladxmi	r5, r3, r9, r6
    18c8:	2e09054a 	cfsh32cs	mvfx0, mvfx9, #42
    18cc:	054a1d05 	strbeq	r1, [sl, #-3333]	; 0xfffff2fb
    18d0:	31052e4d 	tstcc	r5, sp, asr #28
    18d4:	2f09052e 	svccs	0x0009052e
    18d8:	05320e05 	ldreq	r0, [r2, #-3589]!	; 0xfffff1fb
    18dc:	8260030d 	rsbhi	r0, r0, #872415232	; 0x34000000
    18e0:	21030105 	tstcs	r3, r5, lsl #2
    18e4:	09054d2e 	stmdbeq	r5, {r1, r2, r3, r5, r8, sl, fp, lr}
    18e8:	4a1d05a1 	bmi	742f74 <_bss_end+0x737404>
    18ec:	052e2305 	streq	r2, [lr, #-773]!	; 0xfffffcfb
    18f0:	09052e05 	stmdbeq	r5, {r0, r2, r9, sl, fp, sp}
    18f4:	4a1d054b 	bmi	742e28 <_bss_end+0x7372b8>
    18f8:	052e2905 	streq	r2, [lr, #-2309]!	; 0xfffff6fb
    18fc:	19054d05 	stmdbne	r5, {r0, r2, r8, sl, fp, lr}
    1900:	2e2d054a 	cfsh64cs	mvdx0, mvdx13, #42
    1904:	054c1a05 	strbeq	r1, [ip, #-2565]	; 0xfffff5fb
    1908:	13054a2e 	movwne	r4, #23086	; 0x5a2e
    190c:	2f21052e 	svccs	0x0021052e
    1910:	054a2705 	strbeq	r2, [sl, #-1797]	; 0xfffff8fb
    1914:	18052e0a 	stmdane	r5, {r1, r3, r9, sl, fp, sp}
    1918:	672f0585 	strvs	r0, [pc, -r5, lsl #11]!
    191c:	054a4305 	strbeq	r4, [sl, #-773]	; 0xfffffcfb
    1920:	19052e05 	stmdbne	r5, {r0, r2, r9, sl, fp, sp}
    1924:	2e49054a 	cdpcs	5, 4, cr0, cr9, cr10, {2}
    1928:	052e2d05 	streq	r2, [lr, #-3333]!	; 0xfffff2fb
    192c:	19052f05 	stmdbne	r5, {r0, r2, r8, r9, sl, fp, sp}
    1930:	2e25054a 	cfsh64cs	mvdx0, mvdx5, #42
    1934:	054d0505 	strbeq	r0, [sp, #-1285]	; 0xfffffafb
    1938:	1d056725 	stcne	7, cr6, [r5, #-148]	; 0xffffff6c
    193c:	6901054a 	stmdbvs	r1, {r1, r3, r6, r8, sl}
    1940:	052d1f05 	streq	r1, [sp, #-3845]!	; 0xfffff0fb
    1944:	01054a17 	tsteq	r5, r7, lsl sl
    1948:	009e6667 	addseq	r6, lr, r7, ror #12
    194c:	06010402 	streq	r0, [r1], -r2, lsl #8
    1950:	06120566 	ldreq	r0, [r2], -r6, ror #10
    1954:	827ef203 	rsbshi	pc, lr, #805306368	; 0x30000000
    1958:	8e030105 	adfhis	f0, f3, f5
    195c:	4a9e4a01 	bmi	fe794168 <_bss_end+0xfe7885f8>
    1960:	01000a02 	tsteq	r0, r2, lsl #20
    1964:	05020401 	streq	r0, [r2, #-1025]	; 0xfffffbff
    1968:	02050008 	andeq	r0, r5, #8
    196c:	0000a1e8 	andeq	sl, r0, r8, ror #3
    1970:	05011d03 	streq	r1, [r1, #-3331]	; 0xfffff2fd
    1974:	0505842a 	streq	r8, [r5, #-1066]	; 0xfffffbd6
    1978:	00060283 	andeq	r0, r6, r3, lsl #5
    197c:	02040101 	andeq	r0, r4, #1073741824	; 0x40000000
    1980:	05000805 	streq	r0, [r0, #-2053]	; 0xfffff7fb
    1984:	00a21402 	adceq	r1, r2, r2, lsl #8
    1988:	011d0300 	tsteq	sp, r0, lsl #6
    198c:	05842a05 	streq	r2, [r4, #2565]	; 0xa05
    1990:	06028305 	streq	r8, [r2], -r5, lsl #6
    1994:	9d010100 	stflss	f0, [r1, #-0]
    1998:	03000000 	movweq	r0, #0
    199c:	00007400 	andeq	r7, r0, r0, lsl #8
    19a0:	fb010200 	blx	421aa <_bss_end+0x3663a>
    19a4:	01000d0e 	tsteq	r0, lr, lsl #26
    19a8:	00010101 	andeq	r0, r1, r1, lsl #2
    19ac:	00010000 	andeq	r0, r1, r0
    19b0:	682f0100 	stmdavs	pc!, {r8}	; <UNPREDICTABLE>
    19b4:	2f656d6f 	svccs	0x00656d6f
    19b8:	686c6973 	stmdavs	ip!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
    19bc:	6a797661 	bvs	1e5f348 <_bss_end+0x1e537d8>
    19c0:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
    19c4:	2f6c6f6f 	svccs	0x006c6f6f
    19c8:	6f72655a 	svcvs	0x0072655a
    19cc:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
    19d0:	6178652f 	cmnvs	r8, pc, lsr #10
    19d4:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
    19d8:	33312f73 	teqcc	r1, #460	; 0x1cc
    19dc:	6e6f632d 	cdpvs	3, 6, cr6, cr15, cr13, {1}
    19e0:	74786574 	ldrbtvc	r6, [r8], #-1396	; 0xfffffa8c
    19e4:	6977735f 	ldmdbvs	r7!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, sp, lr}^
    19e8:	5f686374 	svcpl	0x00686374
    19ec:	696e6f6d 	stmdbvs	lr!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
    19f0:	2f726f74 	svccs	0x00726f74
    19f4:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
    19f8:	732f6c65 			; <UNDEFINED> instruction: 0x732f6c65
    19fc:	702f6372 	eorvc	r6, pc, r2, ror r3	; <UNPREDICTABLE>
    1a00:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    1a04:	00007373 	andeq	r7, r0, r3, ror r3
    1a08:	74697773 	strbtvc	r7, [r9], #-1907	; 0xfffff88d
    1a0c:	732e6863 			; <UNDEFINED> instruction: 0x732e6863
    1a10:	00000100 	andeq	r0, r0, r0, lsl #2
    1a14:	02050000 	andeq	r0, r5, #0
    1a18:	0000a240 	andeq	sl, r0, r0, asr #4
    1a1c:	2f362f16 	svccs	0x00362f16
    1a20:	302f2f2f 	eorcc	r2, pc, pc, lsr #30
    1a24:	352f2f2f 	strcc	r2, [pc, #-3887]!	; afd <CPSR_IRQ_INHIBIT+0xa7d>
    1a28:	2f2f2f2f 	svccs	0x002f2f2f
    1a2c:	2f2f2f30 	svccs	0x002f2f30
    1a30:	022f2f2f 	eoreq	r2, pc, #47, 30	; 0xbc
    1a34:	01010002 	tsteq	r1, r2
    1a38:	000000c8 	andeq	r0, r0, r8, asr #1
    1a3c:	006b0003 	rsbeq	r0, fp, r3
    1a40:	01020000 	mrseq	r0, (UNDEF: 2)
    1a44:	000d0efb 	strdeq	r0, [sp], -fp
    1a48:	01010101 	tsteq	r1, r1, lsl #2
    1a4c:	01000000 	mrseq	r0, (UNDEF: 0)
    1a50:	2f010000 	svccs	0x00010000
    1a54:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
    1a58:	6c69732f 	stclvs	3, cr7, [r9], #-188	; 0xffffff44
    1a5c:	79766168 	ldmdbvc	r6!, {r3, r5, r6, r8, sp, lr}^
    1a60:	63532f6a 	cmpvs	r3, #424	; 0x1a8
    1a64:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; 18cc <CPSR_IRQ_INHIBIT+0x184c>
    1a68:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
    1a6c:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
    1a70:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
    1a74:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
    1a78:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
    1a7c:	6f632d33 	svcvs	0x00632d33
    1a80:	7865746e 	stmdavc	r5!, {r1, r2, r3, r5, r6, sl, ip, sp, lr}^
    1a84:	77735f74 			; <UNDEFINED> instruction: 0x77735f74
    1a88:	68637469 	stmdavs	r3!, {r0, r3, r5, r6, sl, ip, sp, lr}^
    1a8c:	6e6f6d5f 	mcrvs	13, 3, r6, cr15, cr15, {2}
    1a90:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
    1a94:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
    1a98:	2f6c656e 	svccs	0x006c656e
    1a9c:	00637273 	rsbeq	r7, r3, r3, ror r2
    1aa0:	61747300 	cmnvs	r4, r0, lsl #6
    1aa4:	732e7472 			; <UNDEFINED> instruction: 0x732e7472
    1aa8:	00000100 	andeq	r0, r0, r0, lsl #2
    1aac:	02050000 	andeq	r0, r5, #0
    1ab0:	00008000 	andeq	r8, r0, r0
    1ab4:	2f010d03 	svccs	0x00010d03
    1ab8:	2f2f2f2f 	svccs	0x002f2f2f
    1abc:	1f032f2f 	svcne	0x00032f2f
    1ac0:	322f2008 	eorcc	r2, pc, #8
    1ac4:	312f2f2f 			; <UNDEFINED> instruction: 0x312f2f2f
    1ac8:	312f2f31 			; <UNDEFINED> instruction: 0x312f2f31
    1acc:	2f312f2f 	svccs	0x00312f2f
    1ad0:	2f2f312f 	svccs	0x002f312f
    1ad4:	302f2f31 	eorcc	r2, pc, r1, lsr pc	; <UNPREDICTABLE>
    1ad8:	302f2f2f 	eorcc	r2, pc, pc, lsr #30
    1adc:	01000202 	tsteq	r0, r2, lsl #4
    1ae0:	02050001 	andeq	r0, r5, #1
    1ae4:	0000a29c 	muleq	r0, ip, r2
    1ae8:	0100e503 	tsteq	r0, r3, lsl #10
    1aec:	2f2f2f2f 	svccs	0x002f2f2f
    1af0:	32312f32 	eorscc	r2, r1, #50, 30	; 0xc8
    1af4:	302f2f2f 	eorcc	r2, pc, pc, lsr #30
    1af8:	3030302f 	eorscc	r3, r0, pc, lsr #32
    1afc:	0233332f 	eorseq	r3, r3, #-1140850688	; 0xbc000000
    1b00:	01010002 	tsteq	r1, r2
    1b04:	000000f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    1b08:	006f0003 	rsbeq	r0, pc, r3
    1b0c:	01020000 	mrseq	r0, (UNDEF: 2)
    1b10:	000d0efb 	strdeq	r0, [sp], -fp
    1b14:	01010101 	tsteq	r1, r1, lsl #2
    1b18:	01000000 	mrseq	r0, (UNDEF: 0)
    1b1c:	2f010000 	svccs	0x00010000
    1b20:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
    1b24:	6c69732f 	stclvs	3, cr7, [r9], #-188	; 0xffffff44
    1b28:	79766168 	ldmdbvc	r6!, {r3, r5, r6, r8, sp, lr}^
    1b2c:	63532f6a 	cmpvs	r3, #424	; 0x1a8
    1b30:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; 1998 <CPSR_IRQ_INHIBIT+0x1918>
    1b34:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
    1b38:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
    1b3c:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
    1b40:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
    1b44:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
    1b48:	6f632d33 	svcvs	0x00632d33
    1b4c:	7865746e 	stmdavc	r5!, {r1, r2, r3, r5, r6, sl, ip, sp, lr}^
    1b50:	77735f74 			; <UNDEFINED> instruction: 0x77735f74
    1b54:	68637469 	stmdavs	r3!, {r0, r3, r5, r6, sl, ip, sp, lr}^
    1b58:	6e6f6d5f 	mcrvs	13, 3, r6, cr15, cr15, {2}
    1b5c:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
    1b60:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
    1b64:	2f6c656e 	svccs	0x006c656e
    1b68:	00637273 	rsbeq	r7, r3, r3, ror r2
    1b6c:	61747300 	cmnvs	r4, r0, lsl #6
    1b70:	70757472 	rsbsvc	r7, r5, r2, ror r4
    1b74:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
    1b78:	00000100 	andeq	r0, r0, r0, lsl #2
    1b7c:	00010500 	andeq	r0, r1, r0, lsl #10
    1b80:	a2ec0205 	rscge	r0, ip, #1342177280	; 0x50000000
    1b84:	14030000 	strne	r0, [r3], #-0
    1b88:	6a0c0501 	bvs	302f94 <_bss_end+0x2f7424>
    1b8c:	02002205 	andeq	r2, r0, #1342177280	; 0x50000000
    1b90:	05660304 	strbeq	r0, [r6, #-772]!	; 0xfffffcfc
    1b94:	0402000c 	streq	r0, [r2], #-12
    1b98:	0505bb02 	streq	fp, [r5, #-2818]	; 0xfffff4fe
    1b9c:	02040200 	andeq	r0, r4, #0, 4
    1ba0:	850c0565 	strhi	r0, [ip, #-1381]	; 0xfffffa9b
    1ba4:	bd2f0105 	stflts	f0, [pc, #-20]!	; 1b98 <CPSR_IRQ_INHIBIT+0x1b18>
    1ba8:	056b1005 	strbeq	r1, [fp, #-5]!
    1bac:	04020027 	streq	r0, [r2], #-39	; 0xffffffd9
    1bb0:	0a054a03 	beq	1543c4 <_bss_end+0x148854>
    1bb4:	02040200 	andeq	r0, r4, #0, 4
    1bb8:	00110583 	andseq	r0, r1, r3, lsl #11
    1bbc:	4a020402 	bmi	82bcc <_bss_end+0x7705c>
    1bc0:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
    1bc4:	052d0204 	streq	r0, [sp, #-516]!	; 0xfffffdfc
    1bc8:	0105850c 	tsteq	r5, ip, lsl #10
    1bcc:	1005a12f 	andne	sl, r5, pc, lsr #2
    1bd0:	0027056a 	eoreq	r0, r7, sl, ror #10
    1bd4:	4a030402 	bmi	c2be4 <_bss_end+0xb7074>
    1bd8:	02000a05 	andeq	r0, r0, #20480	; 0x5000
    1bdc:	05830204 	streq	r0, [r3, #516]	; 0x204
    1be0:	04020011 	streq	r0, [r2], #-17	; 0xffffffef
    1be4:	05054a02 	streq	r4, [r5, #-2562]	; 0xfffff5fe
    1be8:	02040200 	andeq	r0, r4, #0, 4
    1bec:	850c052d 	strhi	r0, [ip, #-1325]	; 0xfffffad3
    1bf0:	022f0105 	eoreq	r0, pc, #1073741825	; 0x40000001
    1bf4:	0101000a 	tsteq	r1, sl
    1bf8:	0000012f 	andeq	r0, r0, pc, lsr #2
    1bfc:	00710003 	rsbseq	r0, r1, r3
    1c00:	01020000 	mrseq	r0, (UNDEF: 2)
    1c04:	000d0efb 	strdeq	r0, [sp], -fp
    1c08:	01010101 	tsteq	r1, r1, lsl #2
    1c0c:	01000000 	mrseq	r0, (UNDEF: 0)
    1c10:	2f010000 	svccs	0x00010000
    1c14:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
    1c18:	6c69732f 	stclvs	3, cr7, [r9], #-188	; 0xffffff44
    1c1c:	79766168 	ldmdbvc	r6!, {r3, r5, r6, r8, sp, lr}^
    1c20:	63532f6a 	cmpvs	r3, #424	; 0x1a8
    1c24:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; 1a8c <CPSR_IRQ_INHIBIT+0x1a0c>
    1c28:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
    1c2c:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
    1c30:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
    1c34:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
    1c38:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
    1c3c:	6f632d33 	svcvs	0x00632d33
    1c40:	7865746e 	stmdavc	r5!, {r1, r2, r3, r5, r6, sl, ip, sp, lr}^
    1c44:	77735f74 			; <UNDEFINED> instruction: 0x77735f74
    1c48:	68637469 	stmdavs	r3!, {r0, r3, r5, r6, sl, ip, sp, lr}^
    1c4c:	6e6f6d5f 	mcrvs	13, 3, r6, cr15, cr15, {2}
    1c50:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
    1c54:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
    1c58:	2f62696c 	svccs	0x0062696c
    1c5c:	00637273 	rsbeq	r7, r3, r3, ror r2
    1c60:	64747300 	ldrbtvs	r7, [r4], #-768	; 0xfffffd00
    1c64:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
    1c68:	632e676e 			; <UNDEFINED> instruction: 0x632e676e
    1c6c:	01007070 	tsteq	r0, r0, ror r0
    1c70:	05000000 	streq	r0, [r0, #-0]
    1c74:	02050001 	andeq	r0, r5, #1
    1c78:	0000a404 	andeq	sl, r0, r4, lsl #8
    1c7c:	bb09051a 	bllt	2430ec <_bss_end+0x23757c>
    1c80:	054c1205 	strbeq	r1, [ip, #-517]	; 0xfffffdfb
    1c84:	10056827 	andne	r6, r5, r7, lsr #16
    1c88:	2e1105ba 	cfcmp64cs	r0, mvdx1, mvdx10
    1c8c:	054a2d05 	strbeq	r2, [sl, #-3333]	; 0xfffff2fb
    1c90:	0f054a13 	svceq	0x00054a13
    1c94:	9f0a052f 	svcls	0x000a052f
    1c98:	35620505 	strbcc	r0, [r2, #-1285]!	; 0xfffffafb
    1c9c:	05681005 	strbeq	r1, [r8, #-5]!
    1ca0:	22052e11 	andcs	r2, r5, #272	; 0x110
    1ca4:	2e13054a 	cfmac32cs	mvfx0, mvfx3, mvfx10
    1ca8:	052f0a05 	streq	r0, [pc, #-2565]!	; 12ab <CPSR_IRQ_INHIBIT+0x122b>
    1cac:	0d05690c 	vstreq.16	s12, [r5, #-24]	; 0xffffffe8	; <UNPREDICTABLE>
    1cb0:	4a0f052e 	bmi	3c3170 <_bss_end+0x3b7600>
    1cb4:	054b0605 	strbeq	r0, [fp, #-1541]	; 0xfffff9fb
    1cb8:	1c05680e 	stcne	8, cr6, [r5], {14}
    1cbc:	03040200 	movweq	r0, #16896	; 0x4200
    1cc0:	0017054a 	andseq	r0, r7, sl, asr #10
    1cc4:	9e030402 	cdpls	4, 0, cr0, cr3, cr2, {0}
    1cc8:	02001b05 	andeq	r1, r0, #5120	; 0x1400
    1ccc:	05680204 	strbeq	r0, [r8, #-516]!	; 0xfffffdfc
    1cd0:	0402001e 	streq	r0, [r2], #-30	; 0xffffffe2
    1cd4:	0e058202 	cdpeq	2, 0, cr8, cr5, cr2, {0}
    1cd8:	02040200 	andeq	r0, r4, #0, 4
    1cdc:	0020054a 	eoreq	r0, r0, sl, asr #10
    1ce0:	4b020402 	blmi	82cf0 <_bss_end+0x77180>
    1ce4:	02002105 	andeq	r2, r0, #1073741825	; 0x40000001
    1ce8:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
    1cec:	04020012 	streq	r0, [r2], #-18	; 0xffffffee
    1cf0:	15054a02 	strne	r4, [r5, #-2562]	; 0xfffff5fe
    1cf4:	02040200 	andeq	r0, r4, #0, 4
    1cf8:	00210582 	eoreq	r0, r1, r2, lsl #11
    1cfc:	4a020402 	bmi	82d0c <_bss_end+0x7719c>
    1d00:	02001705 	andeq	r1, r0, #1310720	; 0x140000
    1d04:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
    1d08:	04020010 	streq	r0, [r2], #-16
    1d0c:	11052f02 	tstne	r5, r2, lsl #30
    1d10:	02040200 	andeq	r0, r4, #0, 4
    1d14:	0013052e 	andseq	r0, r3, lr, lsr #10
    1d18:	4a020402 	bmi	82d28 <_bss_end+0x771b8>
    1d1c:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
    1d20:	05460204 	strbeq	r0, [r6, #-516]	; 0xfffffdfc
    1d24:	08028801 	stmdaeq	r2, {r0, fp, pc}
    1d28:	79010100 	stmdbvc	r1, {r8}
    1d2c:	03000000 	movweq	r0, #0
    1d30:	00004600 	andeq	r4, r0, r0, lsl #12
    1d34:	fb010200 	blx	4253e <_bss_end+0x369ce>
    1d38:	01000d0e 	tsteq	r0, lr, lsl #26
    1d3c:	00010101 	andeq	r0, r1, r1, lsl #2
    1d40:	00010000 	andeq	r0, r1, r0
    1d44:	2e2e0100 	sufcse	f0, f6, f0
    1d48:	2f2e2e2f 	svccs	0x002e2e2f
    1d4c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1d50:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1d54:	2f2e2e2f 	svccs	0x002e2e2f
    1d58:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    1d5c:	632f6363 			; <UNDEFINED> instruction: 0x632f6363
    1d60:	69666e6f 	stmdbvs	r6!, {r0, r1, r2, r3, r5, r6, r9, sl, fp, sp, lr}^
    1d64:	72612f67 	rsbvc	r2, r1, #412	; 0x19c
    1d68:	6c00006d 	stcvs	0, cr0, [r0], {109}	; 0x6d
    1d6c:	66316269 	ldrtvs	r6, [r1], -r9, ror #4
    1d70:	73636e75 	cmnvc	r3, #1872	; 0x750
    1d74:	0100532e 	tsteq	r0, lr, lsr #6
    1d78:	00000000 	andeq	r0, r0, r0
    1d7c:	a5780205 	ldrbge	r0, [r8, #-517]!	; 0xfffffdfb
    1d80:	ca030000 	bgt	c1d88 <_bss_end+0xb6218>
    1d84:	2f300108 	svccs	0x00300108
    1d88:	2f2f2f2f 	svccs	0x002f2f2f
    1d8c:	01d00230 	bicseq	r0, r0, r0, lsr r2
    1d90:	2f312f14 	svccs	0x00312f14
    1d94:	2f4c302f 	svccs	0x004c302f
    1d98:	661f0332 			; <UNDEFINED> instruction: 0x661f0332
    1d9c:	2f2f2f2f 	svccs	0x002f2f2f
    1da0:	022f2f2f 	eoreq	r2, pc, #47, 30	; 0xbc
    1da4:	01010002 	tsteq	r1, r2
    1da8:	0000005c 	andeq	r0, r0, ip, asr r0
    1dac:	00460003 	subeq	r0, r6, r3
    1db0:	01020000 	mrseq	r0, (UNDEF: 2)
    1db4:	000d0efb 	strdeq	r0, [sp], -fp
    1db8:	01010101 	tsteq	r1, r1, lsl #2
    1dbc:	01000000 	mrseq	r0, (UNDEF: 0)
    1dc0:	2e010000 	cdpcs	0, 0, cr0, cr1, cr0, {0}
    1dc4:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1dc8:	2f2e2e2f 	svccs	0x002e2e2f
    1dcc:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1dd0:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1dd4:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    1dd8:	2f636367 	svccs	0x00636367
    1ddc:	666e6f63 	strbtvs	r6, [lr], -r3, ror #30
    1de0:	612f6769 			; <UNDEFINED> instruction: 0x612f6769
    1de4:	00006d72 	andeq	r6, r0, r2, ror sp
    1de8:	3162696c 	cmncc	r2, ip, ror #18
    1dec:	636e7566 	cmnvs	lr, #427819008	; 0x19800000
    1df0:	00532e73 	subseq	r2, r3, r3, ror lr
    1df4:	00000001 	andeq	r0, r0, r1
    1df8:	84020500 	strhi	r0, [r2], #-1280	; 0xfffffb00
    1dfc:	030000a7 	movweq	r0, #167	; 0xa7
    1e00:	02010bb4 	andeq	r0, r1, #180, 22	; 0x2d000
    1e04:	01010002 	tsteq	r1, r2
    1e08:	00000103 	andeq	r0, r0, r3, lsl #2
    1e0c:	00fd0003 	rscseq	r0, sp, r3
    1e10:	01020000 	mrseq	r0, (UNDEF: 2)
    1e14:	000d0efb 	strdeq	r0, [sp], -fp
    1e18:	01010101 	tsteq	r1, r1, lsl #2
    1e1c:	01000000 	mrseq	r0, (UNDEF: 0)
    1e20:	2e010000 	cdpcs	0, 0, cr0, cr1, cr0, {0}
    1e24:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1e28:	2f2e2e2f 	svccs	0x002e2e2f
    1e2c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1e30:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1e34:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    1e38:	2f636367 	svccs	0x00636367
    1e3c:	692f2e2e 	stmdbvs	pc!, {r1, r2, r3, r5, r9, sl, fp, sp}	; <UNPREDICTABLE>
    1e40:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
    1e44:	2e006564 	cfsh32cs	mvfx6, mvfx0, #52
    1e48:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1e4c:	2f2e2e2f 	svccs	0x002e2e2f
    1e50:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1e54:	2f2e2f2e 	svccs	0x002e2f2e
    1e58:	00636367 	rsbeq	r6, r3, r7, ror #6
    1e5c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1e60:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1e64:	2f2e2e2f 	svccs	0x002e2e2f
    1e68:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1e6c:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
    1e70:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    1e74:	2f2e2e2f 	svccs	0x002e2e2f
    1e78:	2f636367 	svccs	0x00636367
    1e7c:	666e6f63 	strbtvs	r6, [lr], -r3, ror #30
    1e80:	612f6769 			; <UNDEFINED> instruction: 0x612f6769
    1e84:	2e006d72 	mcrcs	13, 0, r6, cr0, cr2, {3}
    1e88:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1e8c:	2f2e2e2f 	svccs	0x002e2e2f
    1e90:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1e94:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1e98:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    1e9c:	00636367 	rsbeq	r6, r3, r7, ror #6
    1ea0:	73616800 	cmnvc	r1, #0, 16
    1ea4:	62617468 	rsbvs	r7, r1, #104, 8	; 0x68000000
    1ea8:	0100682e 	tsteq	r0, lr, lsr #16
    1eac:	72610000 	rsbvc	r0, r1, #0
    1eb0:	73692d6d 	cmnvc	r9, #6976	; 0x1b40
    1eb4:	00682e61 	rsbeq	r2, r8, r1, ror #28
    1eb8:	61000002 	tstvs	r0, r2
    1ebc:	632d6d72 			; <UNDEFINED> instruction: 0x632d6d72
    1ec0:	682e7570 	stmdavs	lr!, {r4, r5, r6, r8, sl, ip, sp, lr}
    1ec4:	00000200 	andeq	r0, r0, r0, lsl #4
    1ec8:	6e736e69 	cdpvs	14, 7, cr6, cr3, cr9, {3}
    1ecc:	6e6f632d 	cdpvs	3, 6, cr6, cr15, cr13, {1}
    1ed0:	6e617473 	mcrvs	4, 3, r7, cr1, cr3, {3}
    1ed4:	682e7374 	stmdavs	lr!, {r2, r4, r5, r6, r8, r9, ip, sp, lr}
    1ed8:	00000200 	andeq	r0, r0, r0, lsl #4
    1edc:	2e6d7261 	cdpcs	2, 6, cr7, cr13, cr1, {3}
    1ee0:	00030068 	andeq	r0, r3, r8, rrx
    1ee4:	62696c00 	rsbvs	r6, r9, #0, 24
    1ee8:	32636367 	rsbcc	r6, r3, #-1677721599	; 0x9c000001
    1eec:	0400682e 	streq	r6, [r0], #-2094	; 0xfffff7d2
    1ef0:	62670000 	rsbvs	r0, r7, #0
    1ef4:	74632d6c 	strbtvc	r2, [r3], #-3436	; 0xfffff294
    1ef8:	2e73726f 	cdpcs	2, 7, cr7, cr3, cr15, {3}
    1efc:	00040068 	andeq	r0, r4, r8, rrx
    1f00:	62696c00 	rsbvs	r6, r9, #0, 24
    1f04:	32636367 	rsbcc	r6, r3, #-1677721599	; 0x9c000001
    1f08:	0400632e 	streq	r6, [r0], #-814	; 0xfffffcd2
    1f0c:	Address 0x0000000000001f0c is out of bounds.


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
      20:	5b202965 	blpl	80a5bc <_bss_end+0x7fea4c>
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
      88:	7a6a3637 	bvc	1a8d96c <_bss_end+0x1a81dfc>
      8c:	20732d66 	rsbscs	r2, r3, r6, ror #26
      90:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
      94:	6d2d206d 	stcvs	0, cr2, [sp, #-436]!	; 0xfffffe4c
      98:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
      9c:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
      a0:	6b7a3676 	blvs	1e8da80 <_bss_end+0x1e81f10>
      a4:	2070662b 	rsbscs	r6, r0, fp, lsr #12
      a8:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
      ac:	4f2d2067 	svcmi	0x002d2067
      b0:	4f2d2030 	svcmi	0x002d2030
      b4:	682f0030 	stmdavs	pc!, {r4, r5}	; <UNPREDICTABLE>
      b8:	2f656d6f 	svccs	0x00656d6f
      bc:	686c6973 	stmdavs	ip!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
      c0:	6a797661 	bvs	1e5da4c <_bss_end+0x1e51edc>
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
     1f0:	5a5f0074 	bpl	17c03c8 <_bss_end+0x17b4858>
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
     298:	4b4c4344 	blmi	1310fb0 <_bss_end+0x1305440>
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
     2c8:	6a457475 	bvs	115d4a4 <_bss_end+0x1151934>
     2cc:	5a5f0062 	bpl	17c045c <_bss_end+0x17b48ec>
     2d0:	33314b4e 	teqcc	r1, #79872	; 0x13800
     2d4:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     2d8:	61485f4f 	cmpvs	r8, pc, asr #30
     2dc:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     2e0:	47393172 			; <UNDEFINED> instruction: 0x47393172
     2e4:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     2e8:	45534650 	ldrbmi	r4, [r3, #-1616]	; 0xfffff9b0
     2ec:	6f4c5f4c 	svcvs	0x004c5f4c
     2f0:	69746163 	ldmdbvs	r4!, {r0, r1, r5, r6, r8, sp, lr}^
     2f4:	6a456e6f 	bvs	115bcb8 <_bss_end+0x1150148>
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
     3a4:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffe38 <_bss_end+0xffff42c8>
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
     468:	4b4e5a5f 	blmi	1396dec <_bss_end+0x138b27c>
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
     5f8:	4b4e5a5f 	blmi	1396f7c <_bss_end+0x138b40c>
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
     64c:	754f5f74 	strbvc	r5, [pc, #-3956]	; fffff6e0 <_bss_end+0xffff3b70>
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
     6b8:	6e5f6d00 	cdpvs	13, 5, cr6, cr15, cr0, {0}
     6bc:	65626d75 	strbvs	r6, [r2, #-3445]!	; 0xfffff28b
     6c0:	61625f72 	smcvs	9714	; 0x25f2
     6c4:	52006573 	andpl	r6, r0, #482344960	; 0x1cc00000
     6c8:	74657365 	strbtvc	r7, [r5], #-869	; 0xfffffc9b
     6cc:	6d754e5f 	ldclvs	14, cr4, [r5, #-380]!	; 0xfffffe84
     6d0:	5f726562 	svcpl	0x00726562
     6d4:	65736142 	ldrbvs	r6, [r3, #-322]!	; 0xfffffebe
     6d8:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     6dc:	6f4d4338 	svcvs	0x004d4338
     6e0:	6f74696e 	svcvs	0x0074696e
     6e4:	45324372 	ldrmi	r4, [r2, #-882]!	; 0xfffffc8e
     6e8:	006a6a6a 	rsbeq	r6, sl, sl, ror #20
     6ec:	384e5a5f 	stmdacc	lr, {r0, r1, r2, r3, r4, r6, r9, fp, ip, lr}^
     6f0:	6e6f4d43 	cdpvs	13, 6, cr4, cr15, cr3, {2}
     6f4:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
     6f8:	64413331 	strbvs	r3, [r1], #-817	; 0xfffffccf
     6fc:	7473756a 	ldrbtvc	r7, [r3], #-1386	; 0xfffffa96
     700:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     704:	45726f73 	ldrbmi	r6, [r2, #-3955]!	; 0xfffff08d
     708:	74690076 	strbtvc	r0, [r9], #-118	; 0xffffff8a
     70c:	5200616f 	andpl	r6, r0, #-1073741797	; 0xc000001b
     710:	74657365 	strbtvc	r7, [r5], #-869	; 0xfffffc9b
     714:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     718:	00726f73 	rsbseq	r6, r2, r3, ror pc
     71c:	756a6441 	strbvc	r6, [sl, #-1089]!	; 0xfffffbbf
     720:	435f7473 	cmpmi	pc, #1929379840	; 0x73000000
     724:	6f737275 	svcvs	0x00737275
     728:	4e4e0072 	mcrmi	0, 2, r0, cr14, cr2, {3}
     72c:	65626d75 	strbvs	r6, [r2, #-3445]!	; 0xfffff28b
     730:	61425f72 	hvcvs	9714	; 0x25f2
     734:	54006573 	strpl	r6, [r0], #-1395	; 0xfffffa8d
     738:	69736f50 	ldmdbvs	r3!, {r4, r6, r8, r9, sl, fp, sp, lr}^
     73c:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     740:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     744:	6f4d4338 	svcvs	0x004d4338
     748:	6f74696e 	svcvs	0x0074696e
     74c:	52373172 	eorspl	r3, r7, #-2147483620	; 0x8000001c
     750:	74657365 	strbtvc	r7, [r5], #-869	; 0xfffffc9b
     754:	6d754e5f 	ldclvs	14, cr4, [r5, #-380]!	; 0xfffffe84
     758:	5f726562 	svcpl	0x00726562
     75c:	65736142 	ldrbvs	r6, [r3, #-322]!	; 0xfffffebe
     760:	6d007645 	stcvs	6, cr7, [r0, #-276]	; 0xfffffeec
     764:	6e6f6d5f 	mcrvs	13, 3, r6, cr15, cr15, {2}
     768:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
     76c:	4c475f00 	mcrrmi	15, 0, r5, r7, cr0
     770:	4c41424f 	sfmmi	f4, 2, [r1], {79}	; 0x4f
     774:	75735f5f 	ldrbvc	r5, [r3, #-3935]!	; 0xfffff0a1
     778:	5f495f62 	svcpl	0x00495f62
     77c:	6e6f4d73 	mcrvs	13, 3, r4, cr15, cr3, {3}
     780:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
     784:	6e6f6d00 	cdpvs	13, 6, cr6, cr15, cr0, {0}
     788:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
     78c:	7361625f 	cmnvc	r1, #-268435451	; 0xf0000005
     790:	64615f65 	strbtvs	r5, [r1], #-3941	; 0xfffff09b
     794:	5f007264 	svcpl	0x00007264
     798:	43384e5a 	teqmi	r8, #1440	; 0x5a0
     79c:	696e6f4d 	stmdbvs	lr!, {r0, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     7a0:	35726f74 	ldrbcc	r6, [r2, #-3956]!	; 0xfffff08c
     7a4:	61656c43 	cmnvs	r5, r3, asr #24
     7a8:	00764572 	rsbseq	r4, r6, r2, ror r5
     7ac:	384e5a5f 	stmdacc	lr, {r0, r1, r2, r3, r4, r6, r9, fp, ip, lr}^
     7b0:	6e6f4d43 	cdpvs	13, 6, cr4, cr15, cr3, {2}
     7b4:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
     7b8:	4e45736c 	cdpmi	3, 4, cr7, cr5, cr12, {3}
     7bc:	32315f53 	eorscc	r5, r1, #332	; 0x14c
     7c0:	6d754e4e 	ldclvs	14, cr4, [r5, #-312]!	; 0xfffffec8
     7c4:	5f726562 	svcpl	0x00726562
     7c8:	65736142 	ldrbvs	r6, [r3, #-322]!	; 0xfffffebe
     7cc:	4d430045 	stclmi	0, cr0, [r3, #-276]	; 0xfffffeec
     7d0:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
     7d4:	6f00726f 	svcvs	0x0000726f
     7d8:	61726570 	cmnvs	r2, r0, ror r5
     7dc:	3c726f74 	ldclcc	15, cr6, [r2], #-464	; 0xfffffe30
     7e0:	5a5f003c 	bpl	17c08d8 <_bss_end+0x17b4d68>
     7e4:	4d43384e 	stclmi	8, cr3, [r3, #-312]	; 0xfffffec8
     7e8:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
     7ec:	736c726f 	cmnvc	ip, #-268435450	; 0xf0000006
     7f0:	634b5045 	movtvs	r5, #45125	; 0xb045
     7f4:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     7f8:	6f4d4338 	svcvs	0x004d4338
     7fc:	6f74696e 	svcvs	0x0074696e
     800:	74693472 	strbtvc	r3, [r9], #-1138	; 0xfffffb8e
     804:	6a45616f 	bvs	1158dc8 <_bss_end+0x114d258>
     808:	006a6350 	rsbeq	r6, sl, r0, asr r3
     80c:	65685f6d 	strbvs	r5, [r8, #-3949]!	; 0xfffff093
     810:	74686769 	strbtvc	r6, [r8], #-1897	; 0xfffff897
     814:	635f6d00 	cmpvs	pc, #0, 26
     818:	6f737275 	svcvs	0x00737275
     81c:	68430072 	stmdavs	r3, {r1, r4, r5, r6}^
     820:	6f437261 	svcvs	0x00437261
     824:	7241766e 	subvc	r7, r1, #115343360	; 0x6e00000
     828:	5a5f0072 	bpl	17c09f8 <_bss_end+0x17b4e88>
     82c:	4d43384e 	stclmi	8, cr3, [r3, #-312]	; 0xfffffec8
     830:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
     834:	736c726f 	cmnvc	ip, #-268435450	; 0xf0000006
     838:	5f006245 	svcpl	0x00006245
     83c:	43384e5a 	teqmi	r8, #1440	; 0x5a0
     840:	696e6f4d 	stmdbvs	lr!, {r0, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     844:	6c726f74 	ldclvs	15, cr6, [r2], #-464	; 0xfffffe30
     848:	00634573 	rsbeq	r4, r3, r3, ror r5
     84c:	69775f6d 	ldmdbvs	r7!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
     850:	00687464 	rsbeq	r7, r8, r4, ror #8
     854:	384e5a5f 	stmdacc	lr, {r0, r1, r2, r3, r4, r6, r9, fp, ip, lr}^
     858:	6e6f4d43 	cdpvs	13, 6, cr4, cr15, cr3, {2}
     85c:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
     860:	72635336 	rsbvc	r5, r3, #-671088640	; 0xd8000000
     864:	456c6c6f 	strbmi	r6, [ip, #-3183]!	; 0xfffff391
     868:	5a5f0076 	bpl	17c0a48 <_bss_end+0x17b4ed8>
     86c:	4d43384e 	stclmi	8, cr3, [r3, #-312]	; 0xfffffec8
     870:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
     874:	736c726f 	cmnvc	ip, #-268435450	; 0xf0000006
     878:	5f006a45 	svcpl	0x00006a45
     87c:	43384e5a 	teqmi	r8, #1440	; 0x5a0
     880:	696e6f4d 	stmdbvs	lr!, {r0, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     884:	31726f74 	cmncc	r2, r4, ror pc
     888:	73655232 	cmnvc	r5, #536870915	; 0x20000003
     88c:	435f7465 	cmpmi	pc, #1694498816	; 0x65000000
     890:	6f737275 	svcvs	0x00737275
     894:	00764572 	rsbseq	r4, r6, r2, ror r5
     898:	384e5a5f 	stmdacc	lr, {r0, r1, r2, r3, r4, r6, r9, fp, ip, lr}^
     89c:	6e6f4d43 	cdpvs	13, 6, cr4, cr15, cr3, {2}
     8a0:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
     8a4:	6a453443 	bvs	114d9b8 <_bss_end+0x1141e48>
     8a8:	44006a6a 	strmi	r6, [r0], #-2666	; 0xfffff596
     8ac:	55414645 	strbpl	r4, [r1, #-1605]	; 0xfffff9bb
     8b0:	4e5f544c 	cdpmi	4, 5, cr5, cr15, cr12, {2}
     8b4:	45424d55 	strbmi	r4, [r2, #-3413]	; 0xfffff2ab
     8b8:	41425f52 	cmpmi	r2, r2, asr pc
     8bc:	6f004553 	svcvs	0x00004553
     8c0:	75707475 	ldrbvc	r7, [r0, #-1141]!	; 0xfffffb8b
     8c4:	6e690074 	mcrvs	0, 3, r0, cr9, cr4, {3}
     8c8:	00747570 	rsbseq	r7, r4, r0, ror r5
     8cc:	75625f73 	strbvc	r5, [r2, #-3955]!	; 0xfffff08d
     8d0:	72656666 	rsbvc	r6, r5, #106954752	; 0x6600000
     8d4:	6f682f00 	svcvs	0x00682f00
     8d8:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
     8dc:	61686c69 	cmnvs	r8, r9, ror #24
     8e0:	2f6a7976 	svccs	0x006a7976
     8e4:	6f686353 	svcvs	0x00686353
     8e8:	5a2f6c6f 	bpl	bdbaac <_bss_end+0xbcff3c>
     8ec:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 760 <CPSR_IRQ_INHIBIT+0x6e0>
     8f0:	2f657461 	svccs	0x00657461
     8f4:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
     8f8:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
     8fc:	2d33312f 	ldfcss	f3, [r3, #-188]!	; 0xffffff44
     900:	746e6f63 	strbtvc	r6, [lr], #-3939	; 0xfffff09d
     904:	5f747865 	svcpl	0x00747865
     908:	74697773 	strbtvc	r7, [r9], #-1907	; 0xfffff88d
     90c:	6d5f6863 	ldclvs	8, cr6, [pc, #-396]	; 788 <CPSR_IRQ_INHIBIT+0x708>
     910:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
     914:	6b2f726f 	blvs	bdd2d8 <_bss_end+0xbd1768>
     918:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
     91c:	72732f6c 	rsbsvc	r2, r3, #108, 30	; 0x1b0
     920:	72642f63 	rsbvc	r2, r4, #396	; 0x18c
     924:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
     928:	6f6d2f73 	svcvs	0x006d2f73
     92c:	6f74696e 	svcvs	0x0074696e
     930:	70632e72 	rsbvc	r2, r3, r2, ror lr
     934:	55420070 	strbpl	r0, [r2, #-112]	; 0xffffff90
     938:	52454646 	subpl	r4, r5, #73400320	; 0x4600000
     93c:	5a49535f 	bpl	12556c0 <_bss_end+0x1249b50>
     940:	475f0045 	ldrbmi	r0, [pc, -r5, asr #32]
     944:	41424f4c 	cmpmi	r2, ip, asr #30
     948:	735f5f4c 	cmpvc	pc, #76, 30	; 0x130
     94c:	495f6275 	ldmdbmi	pc, {r0, r2, r4, r5, r6, r9, sp, lr}^	; <UNPREDICTABLE>
     950:	6954735f 	ldmdbvs	r4, {r0, r1, r2, r3, r4, r6, r8, r9, ip, sp, lr}^
     954:	0072656d 	rsbseq	r6, r2, sp, ror #10
     958:	364e5a5f 			; <UNDEFINED> instruction: 0x364e5a5f
     95c:	6d695443 	cfstrdvs	mvd5, [r9, #-268]!	; 0xfffffef4
     960:	30327265 	eorscc	r7, r2, r5, ror #4
     964:	545f7349 	ldrbpl	r7, [pc], #-841	; 96c <CPSR_IRQ_INHIBIT+0x8ec>
     968:	72656d69 	rsbvc	r6, r5, #6720	; 0x1a40
     96c:	5152495f 	cmppl	r2, pc, asr r9
     970:	6e65505f 	mcrvs	0, 3, r5, cr5, cr15, {2}
     974:	676e6964 	strbvs	r6, [lr, -r4, ror #18]!
     978:	2f007645 	svccs	0x00007645
     97c:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     980:	6c69732f 	stclvs	3, cr7, [r9], #-188	; 0xffffff44
     984:	79766168 	ldmdbvc	r6!, {r3, r5, r6, r8, sp, lr}^
     988:	63532f6a 	cmpvs	r3, #424	; 0x1a8
     98c:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; 7f4 <CPSR_IRQ_INHIBIT+0x774>
     990:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
     994:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
     998:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
     99c:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
     9a0:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
     9a4:	6f632d33 	svcvs	0x00632d33
     9a8:	7865746e 	stmdavc	r5!, {r1, r2, r3, r5, r6, sl, ip, sp, lr}^
     9ac:	77735f74 			; <UNDEFINED> instruction: 0x77735f74
     9b0:	68637469 	stmdavs	r3!, {r0, r3, r5, r6, sl, ip, sp, lr}^
     9b4:	6e6f6d5f 	mcrvs	13, 3, r6, cr15, cr15, {2}
     9b8:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
     9bc:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
     9c0:	2f6c656e 	svccs	0x006c656e
     9c4:	2f637273 	svccs	0x00637273
     9c8:	76697264 	strbtvc	r7, [r9], -r4, ror #4
     9cc:	2f737265 	svccs	0x00737265
     9d0:	656d6974 	strbvs	r6, [sp, #-2420]!	; 0xfffff68c
     9d4:	70632e72 	rsbvc	r2, r3, r2, ror lr
     9d8:	5a5f0070 	bpl	17c0ba0 <_bss_end+0x17b5030>
     9dc:	5443364e 	strbpl	r3, [r3], #-1614	; 0xfffff9b2
     9e0:	72656d69 	rsbvc	r6, r5, #6720	; 0x1a40
     9e4:	6d453243 	sfmvs	f3, 2, [r5, #-268]	; 0xfffffef4
     9e8:	6c655200 	sfmvs	f5, 2, [r5], #-0
     9ec:	0064616f 	rsbeq	r6, r4, pc, ror #2
     9f0:	5f515249 	svcpl	0x00515249
     9f4:	6c6c6143 	stfvse	f6, [ip], #-268	; 0xfffffef4
     9f8:	6b636162 	blvs	18d8f88 <_bss_end+0x18cd418>
     9fc:	51524900 	cmppl	r2, r0, lsl #18
     a00:	73614d5f 	cmnvc	r1, #6080	; 0x17c0
     a04:	0064656b 	rsbeq	r6, r4, fp, ror #10
     a08:	616c6564 	cmnvs	ip, r4, ror #10
     a0c:	69750079 	ldmdbvs	r5!, {r0, r3, r4, r5, r6}^
     a10:	5f38746e 	svcpl	0x0038746e
     a14:	6e750074 	mrcvs	0, 3, r0, cr5, cr4, {3}
     a18:	64657375 	strbtvs	r7, [r5], #-885	; 0xfffffc8b
     a1c:	7500305f 	strvc	r3, [r0, #-95]	; 0xffffffa1
     a20:	6573756e 	ldrbvs	r7, [r3, #-1390]!	; 0xfffffa92
     a24:	00315f64 	eorseq	r5, r1, r4, ror #30
     a28:	73756e75 	cmnvc	r5, #1872	; 0x750
     a2c:	325f6465 	subscc	r6, pc, #1694498816	; 0x65000000
     a30:	756e7500 	strbvc	r7, [lr, #-1280]!	; 0xfffffb00
     a34:	5f646573 	svcpl	0x00646573
     a38:	6e750033 	mrcvs	0, 3, r0, cr5, cr3, {1}
     a3c:	64657375 	strbtvs	r7, [r5], #-885	; 0xfffffc8b
     a40:	6300345f 	movwvs	r3, #1119	; 0x45f
     a44:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
     a48:	335f7265 	cmpcc	pc, #1342177286	; 0x50000006
     a4c:	50006232 	andpl	r6, r0, r2, lsr r2
     a50:	63736572 	cmnvs	r3, #478150656	; 0x1c800000
     a54:	72656c61 	rsbvc	r6, r5, #24832	; 0x6100
     a58:	3635325f 			; <UNDEFINED> instruction: 0x3635325f
     a5c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     a60:	69544336 	ldmdbvs	r4, {r1, r2, r4, r5, r8, r9, lr}^
     a64:	3672656d 	ldrbtcc	r6, [r2], -sp, ror #10
     a68:	62616e45 	rsbvs	r6, r1, #1104	; 0x450
     a6c:	5045656c 	subpl	r6, r5, ip, ror #10
     a70:	45767646 	ldrbmi	r7, [r6, #-1606]!	; 0xfffff9ba
     a74:	4e36316a 	rsfmisz	f3, f6, #2.0
     a78:	656d6954 	strbvs	r6, [sp, #-2388]!	; 0xfffff6ac
     a7c:	72505f72 	subsvc	r5, r0, #456	; 0x1c8
     a80:	61637365 	cmnvs	r3, r5, ror #6
     a84:	0072656c 	rsbseq	r6, r2, ip, ror #10
     a88:	65657266 	strbvs	r7, [r5, #-614]!	; 0xfffffd9a
     a8c:	6e75725f 	mrcvs	2, 3, r7, cr5, cr15, {2}
     a90:	676e696e 	strbvs	r6, [lr, -lr, ror #18]!
     a94:	6572705f 	ldrbvs	r7, [r2, #-95]!	; 0xffffffa1
     a98:	6c616373 	stclvs	3, cr6, [r1], #-460	; 0xfffffe34
     a9c:	50007265 	andpl	r7, r0, r5, ror #4
     aa0:	63736572 	cmnvs	r3, #478150656	; 0x1c800000
     aa4:	72656c61 	rsbvc	r6, r5, #24832	; 0x6100
     aa8:	6600315f 			; <UNDEFINED> instruction: 0x6600315f
     aac:	5f656572 	svcpl	0x00656572
     ab0:	6e6e7572 	mcrvs	5, 3, r7, cr14, cr2, {3}
     ab4:	5f676e69 	svcpl	0x00676e69
     ab8:	62616e65 	rsbvs	r6, r1, #1616	; 0x650
     abc:	4900656c 	stmdbmi	r0, {r2, r3, r5, r6, r8, sl, sp, lr}
     ac0:	435f5152 	cmpmi	pc, #-2147483628	; 0x80000014
     ac4:	7261656c 	rsbvc	r6, r1, #108, 10	; 0x1b000000
     ac8:	65725000 	ldrbvs	r5, [r2, #-0]!
     acc:	6c616373 	stclvs	3, cr6, [r1], #-460	; 0xfffffe34
     ad0:	315f7265 	cmpcc	pc, r5, ror #4
     ad4:	61680036 	cmnvs	r8, r6, lsr r0
     ad8:	695f746c 	ldmdbvs	pc, {r2, r3, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
     adc:	65645f6e 	strbvs	r5, [r4, #-3950]!	; 0xfffff092
     ae0:	5f677562 	svcpl	0x00677562
     ae4:	61657262 	cmnvs	r5, r2, ror #4
     ae8:	546d006b 	strbtpl	r0, [sp], #-107	; 0xffffff95
     aec:	72656d69 	rsbvc	r6, r5, #6720	; 0x1a40
     af0:	6765525f 			; <UNDEFINED> instruction: 0x6765525f
     af4:	61560073 	cmpvs	r6, r3, ror r0
     af8:	0065756c 	rsbeq	r7, r5, ip, ror #10
     afc:	65746e69 	ldrbvs	r6, [r4, #-3689]!	; 0xfffff197
     b00:	70757272 	rsbsvc	r7, r5, r2, ror r2
     b04:	6e655f74 	mcrvs	15, 3, r5, cr5, cr4, {3}
     b08:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     b0c:	69750064 	ldmdbvs	r5!, {r2, r5, r6}^
     b10:	3631746e 	ldrtcc	r7, [r1], -lr, ror #8
     b14:	5000745f 	andpl	r7, r0, pc, asr r4
     b18:	445f6572 	ldrbmi	r6, [pc], #-1394	; b20 <CPSR_IRQ_INHIBIT+0xaa0>
     b1c:	64697669 	strbtvs	r7, [r9], #-1641	; 0xfffff997
     b20:	54007265 	strpl	r7, [r0], #-613	; 0xfffffd9b
     b24:	72656d69 	rsbvc	r6, r5, #6720	; 0x1a40
     b28:	6765525f 			; <UNDEFINED> instruction: 0x6765525f
     b2c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     b30:	69544336 	ldmdbvs	r4, {r1, r2, r4, r5, r8, r9, lr}^
     b34:	3772656d 	ldrbcc	r6, [r2, -sp, ror #10]!
     b38:	61736944 	cmnvs	r3, r4, asr #18
     b3c:	45656c62 	strbmi	r6, [r5, #-3170]!	; 0xfffff39e
     b40:	69740076 	ldmdbvs	r4!, {r1, r2, r4, r5, r6}^
     b44:	5f72656d 	svcpl	0x0072656d
     b48:	5f676572 	svcpl	0x00676572
     b4c:	65736162 	ldrbvs	r6, [r3, #-354]!	; 0xfffffe9e
     b50:	6d697400 	cfstrdvs	mvd7, [r9, #-0]
     b54:	655f7265 	ldrbvs	r7, [pc, #-613]	; 8f7 <CPSR_IRQ_INHIBIT+0x877>
     b58:	6c62616e 	stfvse	f6, [r2], #-440	; 0xfffffe48
     b5c:	54006465 	strpl	r6, [r0], #-1125	; 0xfffffb9b
     b60:	656d6954 	strbvs	r6, [sp, #-2388]!	; 0xfffff6ac
     b64:	74435f72 	strbvc	r5, [r3], #-3954	; 0xfffff08e
     b68:	6c465f6c 	mcrrvs	15, 6, r5, r6, cr12
     b6c:	00736761 	rsbseq	r6, r3, r1, ror #14
     b70:	64616f4c 	strbtvs	r6, [r1], #-3916	; 0xfffff0b4
     b74:	69544300 	ldmdbvs	r4, {r8, r9, lr}^
     b78:	0072656d 	rsbseq	r6, r2, sp, ror #10
     b7c:	6c61436d 	stclvs	3, cr4, [r1], #-436	; 0xfffffe4c
     b80:	6361626c 	cmnvs	r1, #108, 4	; 0xc0000006
     b84:	5a5f006b 	bpl	17c0d38 <_bss_end+0x17b51c8>
     b88:	5443364e 	strbpl	r3, [r3], #-1614	; 0xfffff9b2
     b8c:	72656d69 	rsbvc	r6, r5, #6720	; 0x1a40
     b90:	67655234 			; <UNDEFINED> instruction: 0x67655234
     b94:	334e4573 	movtcc	r4, #58739	; 0xe573
     b98:	396c6168 	stmdbcc	ip!, {r3, r5, r6, r8, sp, lr}^
     b9c:	656d6954 	strbvs	r6, [sp, #-2388]!	; 0xfffff6ac
     ba0:	65525f72 	ldrbvs	r5, [r2, #-3954]	; 0xfffff08e
     ba4:	5f004567 	svcpl	0x00004567
     ba8:	43364e5a 	teqmi	r6, #1440	; 0x5a0
     bac:	656d6954 	strbvs	r6, [sp, #-2388]!	; 0xfffff6ac
     bb0:	45344372 	ldrmi	r4, [r4, #-882]!	; 0xfffffc8e
     bb4:	7246006d 	subvc	r0, r6, #109	; 0x6d
     bb8:	525f6565 	subspl	r6, pc, #423624704	; 0x19400000
     bbc:	696e6e75 	stmdbvs	lr!, {r0, r2, r4, r5, r6, r9, sl, fp, sp, lr}^
     bc0:	4900676e 	stmdbmi	r0, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}
     bc4:	69545f73 	ldmdbvs	r4, {r0, r1, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     bc8:	5f72656d 	svcpl	0x0072656d
     bcc:	5f515249 	svcpl	0x00515249
     bd0:	646e6550 	strbtvs	r6, [lr], #-1360	; 0xfffffab0
     bd4:	00676e69 	rsbeq	r6, r7, r9, ror #28
     bd8:	6d695454 	cfstrdvs	mvd5, [r9, #-336]!	; 0xfffffeb0
     bdc:	435f7265 	cmpmi	pc, #1342177286	; 0x50000006
     be0:	626c6c61 	rsbvs	r6, ip, #24832	; 0x6100
     be4:	006b6361 	rsbeq	r6, fp, r1, ror #6
     be8:	5f515249 	svcpl	0x00515249
     bec:	00776152 	rsbseq	r6, r7, r2, asr r1
     bf0:	364e5a5f 			; <UNDEFINED> instruction: 0x364e5a5f
     bf4:	6d695443 	cfstrdvs	mvd5, [r9, #-268]!	; 0xfffffef4
     bf8:	32317265 	eorscc	r7, r1, #1342177286	; 0x50000006
     bfc:	5f515249 	svcpl	0x00515249
     c00:	6c6c6143 	stfvse	f6, [ip], #-268	; 0xfffffef4
     c04:	6b636162 	blvs	18d9194 <_bss_end+0x18cd624>
     c08:	63007645 	movwvs	r7, #1605	; 0x645
     c0c:	626c6c61 	rsbvs	r6, ip, #24832	; 0x6100
     c10:	006b6361 	rsbeq	r6, fp, r1, ror #6
     c14:	324e5a5f 	subcc	r5, lr, #389120	; 0x5f000
     c18:	6e494331 	mcrvs	3, 2, r4, cr9, cr1, {1}
     c1c:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
     c20:	5f747075 	svcpl	0x00747075
     c24:	746e6f43 	strbtvc	r6, [lr], #-3907	; 0xfffff0bd
     c28:	6c6c6f72 	stclvs	15, cr6, [ip], #-456	; 0xfffffe38
     c2c:	31317265 	teqcc	r1, r5, ror #4
     c30:	61736944 	cmnvs	r3, r4, asr #18
     c34:	5f656c62 	svcpl	0x00656c62
     c38:	45515249 	ldrbmi	r5, [r1, #-585]	; 0xfffffdb7
     c3c:	6168334e 	cmnvs	r8, lr, asr #6
     c40:	4930316c 	ldmdbmi	r0!, {r2, r3, r5, r6, r8, ip, sp}
     c44:	535f5152 	cmppl	pc, #-2147483628	; 0x80000014
     c48:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     c4c:	66004565 	strvs	r4, [r0], -r5, ror #10
     c50:	5f747361 	svcpl	0x00747361
     c54:	65746e69 	ldrbvs	r6, [r4, #-3689]!	; 0xfffff197
     c58:	70757272 	rsbsvc	r7, r5, r2, ror r2
     c5c:	61685f74 	smcvs	34292	; 0x85f4
     c60:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     c64:	5a5f0072 	bpl	17c0e34 <_bss_end+0x17b52c4>
     c68:	4331324e 	teqmi	r1, #-536870908	; 0xe0000004
     c6c:	65746e49 	ldrbvs	r6, [r4, #-3657]!	; 0xfffff1b7
     c70:	70757272 	rsbsvc	r7, r5, r2, ror r2
     c74:	6f435f74 	svcvs	0x00435f74
     c78:	6f72746e 	svcvs	0x0072746e
     c7c:	72656c6c 	rsbvc	r6, r5, #108, 24	; 0x6c00
     c80:	69443731 	stmdbvs	r4, {r0, r4, r5, r8, r9, sl, ip, sp}^
     c84:	6c626173 	stfvse	f6, [r2], #-460	; 0xfffffe34
     c88:	61425f65 	cmpvs	r2, r5, ror #30
     c8c:	5f636973 	svcpl	0x00636973
     c90:	45515249 	ldrbmi	r5, [r1, #-585]	; 0xfffffdb7
     c94:	6168334e 	cmnvs	r8, lr, asr #6
     c98:	4936316c 	ldmdbmi	r6!, {r2, r3, r5, r6, r8, ip, sp}
     c9c:	425f5152 	subsmi	r5, pc, #-2147483628	; 0x80000014
     ca0:	63697361 	cmnvs	r9, #-2080374783	; 0x84000001
     ca4:	756f535f 	strbvc	r5, [pc, #-863]!	; 94d <CPSR_IRQ_INHIBIT+0x8cd>
     ca8:	45656372 	strbmi	r6, [r5, #-882]!	; 0xfffffc8e
     cac:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     cb0:	49433132 	stmdbmi	r3, {r1, r4, r5, r8, ip, sp}^
     cb4:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
     cb8:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
     cbc:	6e6f435f 	mcrvs	3, 3, r4, cr15, cr15, {2}
     cc0:	6c6f7274 	sfmvs	f7, 2, [pc], #-464	; af8 <CPSR_IRQ_INHIBIT+0xa78>
     cc4:	3172656c 	cmncc	r2, ip, ror #10
     cc8:	616e4536 	cmnvs	lr, r6, lsr r5
     ccc:	5f656c62 	svcpl	0x00656c62
     cd0:	69736142 	ldmdbvs	r3!, {r1, r6, r8, sp, lr}^
     cd4:	52495f63 	subpl	r5, r9, #396	; 0x18c
     cd8:	334e4551 	movtcc	r4, #58705	; 0xe551
     cdc:	316c6168 	cmncc	ip, r8, ror #2
     ce0:	51524936 	cmppl	r2, r6, lsr r9
     ce4:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
     ce8:	535f6369 	cmppl	pc, #-1543503871	; 0xa4000001
     cec:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     cf0:	49004565 	stmdbmi	r0, {r0, r2, r5, r6, r8, sl, lr}
     cf4:	535f5152 	cmppl	pc, #-2147483628	; 0x80000014
     cf8:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     cfc:	6e490065 	cdpvs	0, 4, cr0, cr9, cr5, {3}
     d00:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
     d04:	5f747075 	svcpl	0x00747075
     d08:	746e6f43 	strbtvc	r6, [lr], #-3907	; 0xfffff0bd
     d0c:	6c6c6f72 	stclvs	15, cr6, [ip], #-456	; 0xfffffe38
     d10:	525f7265 	subspl	r7, pc, #1342177286	; 0x50000006
     d14:	44006765 	strmi	r6, [r0], #-1893	; 0xfffff89b
     d18:	62726f6f 	rsbsvs	r6, r2, #444	; 0x1bc
     d1c:	5f6c6c65 	svcpl	0x006c6c65
     d20:	50470030 	subpl	r0, r7, r0, lsr r0
     d24:	305f4f49 	subscc	r4, pc, r9, asr #30
     d28:	6f6f4400 	svcvs	0x006f4400
     d2c:	6c656272 	sfmvs	f6, 2, [r5], #-456	; 0xfffffe38
     d30:	00315f6c 	eorseq	r5, r1, ip, ror #30
     d34:	4f495047 	svcmi	0x00495047
     d38:	4700325f 	smlsdmi	r0, pc, r2, r3	; <UNPREDICTABLE>
     d3c:	5f4f4950 	svcpl	0x004f4950
     d40:	52490033 	subpl	r0, r9, #51	; 0x33
     d44:	69445f51 	stmdbvs	r4, {r0, r4, r6, r8, r9, sl, fp, ip, lr}^
     d48:	6c626173 	stfvse	f6, [r2], #-460	; 0xfffffe34
     d4c:	00315f65 	eorseq	r5, r1, r5, ror #30
     d50:	5f515249 	svcpl	0x00515249
     d54:	61736944 	cmnvs	r3, r4, asr #18
     d58:	5f656c62 	svcpl	0x00656c62
     d5c:	52490032 	subpl	r0, r9, #50	; 0x32
     d60:	6e455f51 	mcrvs	15, 2, r5, cr5, cr1, {2}
     d64:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     d68:	4900315f 	stmdbmi	r0, {r0, r1, r2, r3, r4, r6, r8, ip, sp}
     d6c:	455f5152 	ldrbmi	r5, [pc, #-338]	; c22 <CPSR_IRQ_INHIBIT+0xba2>
     d70:	6c62616e 	stfvse	f6, [r2], #-440	; 0xfffffe48
     d74:	00325f65 	eorseq	r5, r2, r5, ror #30
     d78:	324e5a5f 	subcc	r5, lr, #389120	; 0x5f000
     d7c:	6e494331 	mcrvs	3, 2, r4, cr9, cr1, {1}
     d80:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
     d84:	5f747075 	svcpl	0x00747075
     d88:	746e6f43 	strbtvc	r6, [lr], #-3907	; 0xfffff0bd
     d8c:	6c6c6f72 	stclvs	15, cr6, [ip], #-456	; 0xfffffe38
     d90:	52347265 	eorspl	r7, r4, #1342177286	; 0x50000006
     d94:	45736765 	ldrbmi	r6, [r3, #-1893]!	; 0xfffff89b
     d98:	6168334e 	cmnvs	r8, lr, asr #6
     d9c:	4934326c 	ldmdbmi	r4!, {r2, r3, r5, r6, r9, ip, sp}
     da0:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
     da4:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
     da8:	6e6f435f 	mcrvs	3, 3, r4, cr15, cr15, {2}
     dac:	6c6f7274 	sfmvs	f7, 2, [pc], #-464	; be4 <CPSR_IRQ_INHIBIT+0xb64>
     db0:	5f72656c 	svcpl	0x0072656c
     db4:	45676552 	strbmi	r6, [r7, #-1362]!	; 0xfffffaae
     db8:	6e496d00 	cdpvs	13, 4, cr6, cr9, cr0, {0}
     dbc:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
     dc0:	5f747075 	svcpl	0x00747075
     dc4:	73676552 	cmnvc	r7, #343932928	; 0x14800000
     dc8:	51524900 	cmppl	r2, r0, lsl #18
     dcc:	6e65505f 	mcrvs	0, 3, r5, cr5, cr15, {2}
     dd0:	676e6964 	strbvs	r6, [lr, -r4, ror #18]!
     dd4:	4900315f 	stmdbmi	r0, {r0, r1, r2, r3, r4, r6, r8, ip, sp}
     dd8:	505f5152 	subspl	r5, pc, r2, asr r1	; <UNPREDICTABLE>
     ddc:	69646e65 	stmdbvs	r4!, {r0, r2, r5, r6, r9, sl, fp, sp, lr}^
     de0:	325f676e 	subscc	r6, pc, #28835840	; 0x1b80000
     de4:	51524900 	cmppl	r2, r0, lsl #18
     de8:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
     dec:	535f6369 	cmppl	pc, #-1543503871	; 0xa4000001
     df0:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     df4:	57500065 	ldrbpl	r0, [r0, -r5, rrx]
     df8:	00305f41 	eorseq	r5, r0, r1, asr #30
     dfc:	54524155 	ldrbpl	r4, [r2], #-341	; 0xfffffeab
     e00:	73694400 	cmnvc	r9, #0, 8
     e04:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     e08:	5152495f 	cmppl	r2, pc, asr r9
     e0c:	616e4500 	cmnvs	lr, r0, lsl #10
     e10:	5f656c62 	svcpl	0x00656c62
     e14:	69736142 	ldmdbvs	r3!, {r1, r6, r8, sp, lr}^
     e18:	52495f63 	subpl	r5, r9, #396	; 0x18c
     e1c:	69440051 	stmdbvs	r4, {r0, r4, r6}^
     e20:	6c626173 	stfvse	f6, [r2], #-460	; 0xfffffe34
     e24:	61425f65 	cmpvs	r2, r5, ror #30
     e28:	5f636973 	svcpl	0x00636973
     e2c:	00515249 	subseq	r5, r1, r9, asr #4
     e30:	656c6c49 	strbvs	r6, [ip, #-3145]!	; 0xfffff3b7
     e34:	5f6c6167 	svcpl	0x006c6167
     e38:	65636341 	strbvs	r6, [r3, #-833]!	; 0xfffffcbf
     e3c:	315f7373 	cmpcc	pc, r3, ror r3	; <UNPREDICTABLE>
     e40:	6c6c4900 			; <UNDEFINED> instruction: 0x6c6c4900
     e44:	6c616765 	stclvs	7, cr6, [r1], #-404	; 0xfffffe6c
     e48:	6363415f 	cmnvs	r3, #-1073741801	; 0xc0000017
     e4c:	5f737365 	svcpl	0x00737365
     e50:	50470032 	subpl	r0, r7, r2, lsr r0
     e54:	315f4f49 	cmpcc	pc, r9, asr #30
     e58:	51524900 	cmppl	r2, r0, lsl #18
     e5c:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
     e60:	505f6369 	subspl	r6, pc, r9, ror #6
     e64:	69646e65 	stmdbvs	r4!, {r0, r2, r5, r6, r9, sl, fp, sp, lr}^
     e68:	4700676e 	strmi	r6, [r0, -lr, ror #14]
     e6c:	5f315550 	svcpl	0x00315550
     e70:	746c6148 	strbtvc	r6, [ip], #-328	; 0xfffffeb8
     e74:	41575000 	cmpmi	r7, r0
     e78:	4900315f 	stmdbmi	r0, {r0, r1, r2, r3, r4, r6, r8, ip, sp}
     e7c:	425f5152 	subsmi	r5, pc, #-2147483628	; 0x80000014
     e80:	63697361 	cmnvs	r9, #-2080374783	; 0x84000001
     e84:	616e455f 	cmnvs	lr, pc, asr r5
     e88:	00656c62 	rsbeq	r6, r5, r2, ror #24
     e8c:	6c69614d 	stfvse	f6, [r9], #-308	; 0xfffffecc
     e90:	00786f62 	rsbseq	r6, r8, r2, ror #30
     e94:	4f4c475f 	svcmi	0x004c475f
     e98:	5f4c4142 	svcpl	0x004c4142
     e9c:	6275735f 	rsbsvs	r7, r5, #2080374785	; 0x7c000001
     ea0:	735f495f 	cmpvc	pc, #1556480	; 0x17c000
     ea4:	65746e49 	ldrbvs	r6, [r4, #-3657]!	; 0xfffff1b7
     ea8:	70757272 	rsbsvc	r7, r5, r2, ror r2
     eac:	6c744374 	ldclvs	3, cr4, [r4], #-464	; 0xfffffe30
     eb0:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     eb4:	49433132 	stmdbmi	r3, {r1, r4, r5, r8, ip, sp}^
     eb8:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
     ebc:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
     ec0:	6e6f435f 	mcrvs	3, 3, r4, cr15, cr15, {2}
     ec4:	6c6f7274 	sfmvs	f7, 2, [pc], #-464	; cfc <CPSR_IRQ_INHIBIT+0xc7c>
     ec8:	3172656c 	cmncc	r2, ip, ror #10
     ecc:	616e4530 	cmnvs	lr, r0, lsr r5
     ed0:	5f656c62 	svcpl	0x00656c62
     ed4:	45515249 	ldrbmi	r5, [r1, #-585]	; 0xfffffdb7
     ed8:	6168334e 	cmnvs	r8, lr, asr #6
     edc:	4930316c 	ldmdbmi	r0!, {r2, r3, r5, r6, r8, ip, sp}
     ee0:	535f5152 	cmppl	pc, #-2147483628	; 0x80000014
     ee4:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     ee8:	43004565 	movwmi	r4, #1381	; 0x565
     eec:	65746e49 	ldrbvs	r6, [r4, #-3657]!	; 0xfffff1b7
     ef0:	70757272 	rsbsvc	r7, r5, r2, ror r2
     ef4:	6f435f74 	svcvs	0x00435f74
     ef8:	6f72746e 	svcvs	0x0072746e
     efc:	72656c6c 	rsbvc	r6, r5, #108, 24	; 0x6c00
     f00:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     f04:	49433132 	stmdbmi	r3, {r1, r4, r5, r8, ip, sp}^
     f08:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
     f0c:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
     f10:	6e6f435f 	mcrvs	3, 3, r4, cr15, cr15, {2}
     f14:	6c6f7274 	sfmvs	f7, 2, [pc], #-464	; d4c <CPSR_IRQ_INHIBIT+0xccc>
     f18:	4372656c 	cmnmi	r2, #108, 10	; 0x1b000000
     f1c:	006d4532 	rsbeq	r4, sp, r2, lsr r5
     f20:	5f786469 	svcpl	0x00786469
     f24:	65736162 	ldrbvs	r6, [r3, #-354]!	; 0xfffffe9e
     f28:	51524900 	cmppl	r2, r0, lsl #18
     f2c:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
     f30:	445f6369 	ldrbmi	r6, [pc], #-873	; f38 <CPSR_IRQ_INHIBIT+0xeb8>
     f34:	62617369 	rsbvs	r7, r1, #-1543503871	; 0xa4000001
     f38:	5f00656c 	svcpl	0x0000656c
     f3c:	31324e5a 	teqcc	r2, sl, asr lr
     f40:	746e4943 	strbtvc	r4, [lr], #-2371	; 0xfffff6bd
     f44:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
     f48:	435f7470 	cmpmi	pc, #112, 8	; 0x70000000
     f4c:	72746e6f 	rsbsvc	r6, r4, #1776	; 0x6f0
     f50:	656c6c6f 	strbvs	r6, [ip, #-3183]!	; 0xfffff391
     f54:	45344372 	ldrmi	r4, [r4, #-882]!	; 0xfffffc8e
     f58:	3249006d 	subcc	r0, r9, #109	; 0x6d
     f5c:	50535f43 	subspl	r5, r3, r3, asr #30
     f60:	4c535f49 	mrrcmi	15, 4, r5, r3, cr9
     f64:	5f455641 	svcpl	0x00455641
     f68:	54494e49 	strbpl	r4, [r9], #-3657	; 0xfffff1b7
     f6c:	756f7300 	strbvc	r7, [pc, #-768]!	; c74 <CPSR_IRQ_INHIBIT+0xbf4>
     f70:	5f656372 	svcpl	0x00656372
     f74:	00786469 	rsbseq	r6, r8, r9, ror #8
     f78:	5f514946 	svcpl	0x00514946
     f7c:	746e6f43 	strbtvc	r6, [lr], #-3907	; 0xfffff0bd
     f80:	006c6f72 	rsbeq	r6, ip, r2, ror pc
     f84:	746e695f 	strbtvc	r6, [lr], #-2399	; 0xfffff6a1
     f88:	616e7265 	cmnvs	lr, r5, ror #4
     f8c:	72695f6c 	rsbvc	r5, r9, #108, 30	; 0x1b0
     f90:	61685f71 	smcvs	34289	; 0x85f1
     f94:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     f98:	6f730072 	svcvs	0x00730072
     f9c:	61777466 	cmnvs	r7, r6, ror #8
     fa0:	695f6572 	ldmdbvs	pc, {r1, r4, r5, r6, r8, sl, sp, lr}^	; <UNPREDICTABLE>
     fa4:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
     fa8:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
     fac:	6e61685f 	mcrvs	8, 3, r6, cr1, cr15, {2}
     fb0:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     fb4:	6f682f00 	svcvs	0x00682f00
     fb8:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
     fbc:	61686c69 	cmnvs	r8, r9, ror #24
     fc0:	2f6a7976 	svccs	0x006a7976
     fc4:	6f686353 	svcvs	0x00686353
     fc8:	5a2f6c6f 	bpl	bdc18c <_bss_end+0xbd061c>
     fcc:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; e40 <CPSR_IRQ_INHIBIT+0xdc0>
     fd0:	2f657461 	svccs	0x00657461
     fd4:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
     fd8:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
     fdc:	2d33312f 	ldfcss	f3, [r3, #-188]!	; 0xffffff44
     fe0:	746e6f63 	strbtvc	r6, [lr], #-3939	; 0xfffff09d
     fe4:	5f747865 	svcpl	0x00747865
     fe8:	74697773 	strbtvc	r7, [r9], #-1907	; 0xfffff88d
     fec:	6d5f6863 	ldclvs	8, cr6, [pc, #-396]	; e68 <CPSR_IRQ_INHIBIT+0xde8>
     ff0:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
     ff4:	6b2f726f 	blvs	bdd9b8 <_bss_end+0xbd1e48>
     ff8:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
     ffc:	72732f6c 	rsbsvc	r2, r3, #108, 30	; 0x1b0
    1000:	6e692f63 	cdpvs	15, 6, cr2, cr9, cr3, {3}
    1004:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
    1008:	5f747075 	svcpl	0x00747075
    100c:	746e6f63 	strbtvc	r6, [lr], #-3939	; 0xfffff09d
    1010:	6c6c6f72 	stclvs	15, cr6, [ip], #-456	; 0xfffffe38
    1014:	632e7265 			; <UNDEFINED> instruction: 0x632e7265
    1018:	45007070 	strmi	r7, [r0, #-112]	; 0xffffff90
    101c:	6c62616e 	stfvse	f6, [r2], #-440	; 0xfffffe48
    1020:	52495f65 	subpl	r5, r9, #404	; 0x194
    1024:	50470051 	subpl	r0, r7, r1, asr r0
    1028:	485f3055 	ldmdami	pc, {r0, r2, r4, r6, ip, sp}^	; <UNPREDICTABLE>
    102c:	00746c61 	rsbseq	r6, r4, r1, ror #24
    1030:	76657270 			; <UNDEFINED> instruction: 0x76657270
    1034:	67615000 	strbvs	r5, [r1, -r0]!
    1038:	756f4365 	strbvc	r4, [pc, #-869]!	; cdb <CPSR_IRQ_INHIBIT+0xc5b>
    103c:	5f00746e 	svcpl	0x0000746e
    1040:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
    1044:	6f725043 	svcvs	0x00725043
    1048:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    104c:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
    1050:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
    1054:	72433931 	subvc	r3, r3, #802816	; 0xc4000
    1058:	65746165 	ldrbvs	r6, [r4, #-357]!	; 0xfffffe9b
    105c:	69614d5f 	stmdbvs	r1!, {r0, r1, r2, r3, r4, r6, r8, sl, fp, lr}^
    1060:	72505f6e 	subsvc	r5, r0, #440	; 0x1b8
    1064:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    1068:	00764573 	rsbseq	r4, r6, r3, ror r5
    106c:	68676948 	stmdavs	r7!, {r3, r6, r8, fp, sp, lr}^
    1070:	6f6d654d 	svcvs	0x006d654d
    1074:	6e007972 			; <UNDEFINED> instruction: 0x6e007972
    1078:	00747865 	rsbseq	r7, r4, r5, ror #16
    107c:	314e5a5f 	cmpcc	lr, pc, asr sl
    1080:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
    1084:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    1088:	614d5f73 	hvcvs	54771	; 0xd5f3
    108c:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
    1090:	43343172 	teqmi	r4, #-2147483620	; 0x8000001c
    1094:	74616572 	strbtvc	r6, [r1], #-1394	; 0xfffffa8e
    1098:	72505f65 	subsvc	r5, r0, #404	; 0x194
    109c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    10a0:	006d4573 	rsbeq	r4, sp, r3, ror r5
    10a4:	61657243 	cmnvs	r5, r3, asr #4
    10a8:	505f6574 	subspl	r6, pc, r4, ror r5	; <UNPREDICTABLE>
    10ac:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    10b0:	43007373 	movwmi	r7, #883	; 0x373
    10b4:	636f7250 	cmnvs	pc, #80, 4
    10b8:	5f737365 	svcpl	0x00737365
    10bc:	616e614d 	cmnvs	lr, sp, asr #2
    10c0:	00726567 	rsbseq	r6, r2, r7, ror #10
    10c4:	665f7369 	ldrbvs	r7, [pc], -r9, ror #6
    10c8:	00656572 	rsbeq	r6, r5, r2, ror r5
    10cc:	55504354 	ldrbpl	r4, [r0, #-852]	; 0xfffffcac
    10d0:	6e6f435f 	mcrvs	3, 3, r4, cr15, cr15, {2}
    10d4:	74786574 	ldrbtvc	r6, [r8], #-1396	; 0xfffffa8c
    10d8:	44454c00 	strbmi	r4, [r5], #-3072	; 0xfffff400
    10dc:	6174535f 	cmnvs	r4, pc, asr r3
    10e0:	5f006574 	svcpl	0x00006574
    10e4:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
    10e8:	6f725043 	svcvs	0x00725043
    10ec:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    10f0:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
    10f4:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
    10f8:	76453443 	strbvc	r3, [r5], -r3, asr #8
    10fc:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
    1100:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
    1104:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
    1108:	6f72505f 	svcvs	0x0072505f
    110c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    1110:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
    1114:	4b433032 	blmi	10cd1e4 <_bss_end+0x10c1674>
    1118:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
    111c:	65485f6c 	strbvs	r5, [r8, #-3948]	; 0xfffff094
    1120:	4d5f7061 	ldclmi	0, cr7, [pc, #-388]	; fa4 <CPSR_IRQ_INHIBIT+0xf24>
    1124:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
    1128:	35317265 	ldrcc	r7, [r1, #-613]!	; 0xfffffd9b
    112c:	6f6c6c41 	svcvs	0x006c6c41
    1130:	654e5f63 	strbvs	r5, [lr, #-3939]	; 0xfffff09d
    1134:	505f7478 	subspl	r7, pc, r8, ror r4	; <UNPREDICTABLE>
    1138:	45656761 	strbmi	r6, [r5, #-1889]!	; 0xfffff89f
    113c:	69730076 	ldmdbvs	r3!, {r1, r2, r4, r5, r6}^
    1140:	4600657a 			; <UNDEFINED> instruction: 0x4600657a
    1144:	00656572 	rsbeq	r6, r5, r2, ror r5
    1148:	7361544e 	cmnvc	r1, #1308622848	; 0x4e000000
    114c:	74535f6b 	ldrbvc	r5, [r3], #-3947	; 0xfffff095
    1150:	00657461 	rsbeq	r7, r5, r1, ror #8
    1154:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
    1158:	74735f64 	ldrbtvc	r5, [r3], #-3940	; 0xfffff09c
    115c:	63697461 	cmnvs	r9, #1627389952	; 0x61000000
    1160:	6972705f 	ldmdbvs	r2!, {r0, r1, r2, r3, r4, r6, ip, sp, lr}^
    1164:	7469726f 	strbtvc	r7, [r9], #-623	; 0xfffffd91
    1168:	5a5f0079 	bpl	17c1354 <_bss_end+0x17b57e4>
    116c:	4330324e 	teqmi	r0, #-536870908	; 0xe0000004
    1170:	6e72654b 	cdpvs	5, 7, cr6, cr2, cr11, {2}
    1174:	485f6c65 	ldmdami	pc, {r0, r2, r5, r6, sl, fp, sp, lr}^	; <UNPREDICTABLE>
    1178:	5f706165 	svcpl	0x00706165
    117c:	616e614d 	cmnvs	lr, sp, asr #2
    1180:	34726567 	ldrbtcc	r6, [r2], #-1383	; 0xfffffa99
    1184:	65657246 	strbvs	r7, [r5, #-582]!	; 0xfffffdba
    1188:	00765045 	rsbseq	r5, r6, r5, asr #32
    118c:	4d776f4c 	ldclmi	15, cr6, [r7, #-304]!	; 0xfffffed0
    1190:	726f6d65 	rsbvc	r6, pc, #6464	; 0x1940
    1194:	4c6d0079 	stclmi	0, cr0, [sp], #-484	; 0xfffffe1c
    1198:	5f747361 	svcpl	0x00747361
    119c:	00444950 	subeq	r4, r4, r0, asr r9
    11a0:	626d6f5a 	rsbvs	r6, sp, #360	; 0x168
    11a4:	5f006569 	svcpl	0x00006569
    11a8:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
    11ac:	6f725043 	svcvs	0x00725043
    11b0:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    11b4:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
    11b8:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
    11bc:	68635338 	stmdavs	r3!, {r3, r4, r5, r8, r9, ip, lr}^
    11c0:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
    11c4:	00764565 	rsbseq	r4, r6, r5, ror #10
    11c8:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
    11cc:	6f635f64 	svcvs	0x00635f64
    11d0:	65746e75 	ldrbvs	r6, [r4, #-3701]!	; 0xfffff18b
    11d4:	4b430072 	blmi	10c13a4 <_bss_end+0x10b5834>
    11d8:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
    11dc:	65485f6c 	strbvs	r5, [r8, #-3948]	; 0xfffff094
    11e0:	4d5f7061 	ldclmi	0, cr7, [pc, #-388]	; 1064 <CPSR_IRQ_INHIBIT+0xfe4>
    11e4:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
    11e8:	52007265 	andpl	r7, r0, #1342177286	; 0x50000006
    11ec:	616e6e75 	smcvs	59109	; 0xe6e5
    11f0:	00656c62 	rsbeq	r6, r5, r2, ror #24
    11f4:	6f6c6c41 	svcvs	0x006c6c41
    11f8:	43410063 	movtmi	r0, #4195	; 0x1063
    11fc:	69505f54 	ldmdbvs	r0, {r2, r4, r6, r8, r9, sl, fp, ip, lr}^
    1200:	5a5f006e 	bpl	17c13c0 <_bss_end+0x17b5850>
    1204:	4330324e 	teqmi	r0, #-536870908	; 0xe0000004
    1208:	6e72654b 	cdpvs	5, 7, cr6, cr2, cr11, {2}
    120c:	485f6c65 	ldmdami	pc, {r0, r2, r5, r6, sl, fp, sp, lr}^	; <UNPREDICTABLE>
    1210:	5f706165 	svcpl	0x00706165
    1214:	616e614d 	cmnvs	lr, sp, asr #2
    1218:	35726567 	ldrbcc	r6, [r2, #-1383]!	; 0xfffffa99
    121c:	6f6c6c41 	svcvs	0x006c6c41
    1220:	006a4563 	rsbeq	r4, sl, r3, ror #10
    1224:	4b4e5a5f 	blmi	1397ba8 <_bss_end+0x138c038>
    1228:	50433631 	subpl	r3, r3, r1, lsr r6
    122c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    1230:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 106c <CPSR_IRQ_INHIBIT+0xfec>
    1234:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
    1238:	39317265 	ldmdbcc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
    123c:	5f746547 	svcpl	0x00746547
    1240:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
    1244:	5f746e65 	svcpl	0x00746e65
    1248:	636f7250 	cmnvs	pc, #80, 4
    124c:	45737365 	ldrbmi	r7, [r3, #-869]!	; 0xfffffc9b
    1250:	436d0076 	cmnmi	sp, #118	; 0x76
    1254:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
    1258:	545f746e 	ldrbpl	r7, [pc], #-1134	; 1260 <CPSR_IRQ_INHIBIT+0x11e0>
    125c:	5f6b7361 	svcpl	0x006b7361
    1260:	65646f4e 	strbvs	r6, [r4, #-3918]!	; 0xfffff0b2
    1264:	75706300 	ldrbvc	r6, [r0, #-768]!	; 0xfffffd00
    1268:	6e6f635f 	mcrvs	3, 3, r6, cr15, cr15, {2}
    126c:	74786574 	ldrbtvc	r6, [r8], #-1396	; 0xfffffa8c
    1270:	67615000 	strbvs	r5, [r1, -r0]!
    1274:	4d676e69 	stclmi	14, cr6, [r7, #-420]!	; 0xfffffe5c
    1278:	726f6d65 	rsbvc	r6, pc, #6464	; 0x1940
    127c:	7a695379 	bvc	1a56068 <_bss_end+0x1a4a4f8>
    1280:	61740065 	cmnvs	r4, r5, rrx
    1284:	54006b73 	strpl	r6, [r0], #-2931	; 0xfffff48d
    1288:	6b736154 	blvs	1cd97e0 <_bss_end+0x1ccdc70>
    128c:	7274535f 	rsbsvc	r5, r4, #2080374785	; 0x7c000001
    1290:	00746375 	rsbseq	r6, r4, r5, ror r3
    1294:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
    1298:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
    129c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
    12a0:	4b433032 	blmi	10cd370 <_bss_end+0x10c1800>
    12a4:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
    12a8:	65485f6c 	strbvs	r5, [r8, #-3948]	; 0xfffff094
    12ac:	4d5f7061 	ldclmi	0, cr7, [pc, #-388]	; 1130 <CPSR_IRQ_INHIBIT+0x10b0>
    12b0:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
    12b4:	34437265 	strbcc	r7, [r3], #-613	; 0xfffffd9b
    12b8:	6d007645 	stcvs	6, cr7, [r0, #-276]	; 0xfffffeec
    12bc:	73726946 	cmnvc	r2, #1146880	; 0x118000
    12c0:	5a5f0074 	bpl	17c1498 <_bss_end+0x17b5928>
    12c4:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
    12c8:	636f7250 	cmnvs	pc, #80, 4
    12cc:	5f737365 	svcpl	0x00737365
    12d0:	616e614d 	cmnvs	lr, sp, asr #2
    12d4:	39726567 	ldmdbcc	r2!, {r0, r1, r2, r5, r6, r8, sl, sp, lr}^
    12d8:	74697753 	strbtvc	r7, [r9], #-1875	; 0xfffff8ad
    12dc:	545f6863 	ldrbpl	r6, [pc], #-2147	; 12e4 <CPSR_IRQ_INHIBIT+0x1264>
    12e0:	3150456f 	cmpcc	r0, pc, ror #10
    12e4:	72504338 	subsvc	r4, r0, #56, 6	; 0xe0000000
    12e8:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    12ec:	694c5f73 	stmdbvs	ip, {r0, r1, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    12f0:	4e5f7473 	mrcmi	4, 2, r7, cr15, cr3, {3}
    12f4:	0065646f 	rsbeq	r6, r5, pc, ror #8
    12f8:	72654b54 	rsbvc	r4, r5, #84, 22	; 0x15000
    12fc:	5f6c656e 	svcpl	0x006c656e
    1300:	70616548 	rsbvc	r6, r1, r8, asr #10
    1304:	7568435f 	strbvc	r4, [r8, #-863]!	; 0xfffffca1
    1308:	485f6b6e 	ldmdami	pc, {r1, r2, r3, r5, r6, r8, r9, fp, sp, lr}^	; <UNPREDICTABLE>
    130c:	65646165 	strbvs	r6, [r4, #-357]!	; 0xfffffe9b
    1310:	72430072 	subvc	r0, r3, #114	; 0x72
    1314:	65746165 	ldrbvs	r6, [r4, #-357]!	; 0xfffffe9b
    1318:	69614d5f 	stmdbvs	r1!, {r0, r1, r2, r3, r4, r6, r8, sl, fp, lr}^
    131c:	72505f6e 	subsvc	r5, r0, #440	; 0x1b8
    1320:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    1324:	77530073 			; <UNDEFINED> instruction: 0x77530073
    1328:	68637469 	stmdavs	r3!, {r0, r3, r5, r6, sl, ip, sp, lr}^
    132c:	006f545f 	rsbeq	r5, pc, pc, asr r4	; <UNPREDICTABLE>
    1330:	6f6c6c41 	svcvs	0x006c6c41
    1334:	654e5f63 	strbvs	r5, [lr, #-3939]	; 0xfffff09d
    1338:	505f7478 	subspl	r7, pc, r8, ror r4	; <UNPREDICTABLE>
    133c:	00656761 	rsbeq	r6, r5, r1, ror #14
    1340:	636f7250 	cmnvs	pc, #80, 4
    1344:	5f737365 	svcpl	0x00737365
    1348:	72500031 	subsvc	r0, r0, #49	; 0x31
    134c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    1350:	00335f73 	eorseq	r5, r3, r3, ror pc
    1354:	636f7250 	cmnvs	pc, #80, 4
    1358:	5f737365 	svcpl	0x00737365
    135c:	6b5f0034 	blvs	17c1434 <_bss_end+0x17b58c4>
    1360:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
    1364:	616d5f6c 	cmnvs	sp, ip, ror #30
    1368:	6d006e69 	stcvs	14, cr6, [r0, #-420]	; 0xfffffe5c
    136c:	636f7250 	cmnvs	pc, #80, 4
    1370:	5f737365 	svcpl	0x00737365
    1374:	7473694c 	ldrbtvc	r6, [r3], #-2380	; 0xfffff6b4
    1378:	6165485f 	cmnvs	r5, pc, asr r8
    137c:	72500064 	subsvc	r0, r0, #100	; 0x64
    1380:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    1384:	00325f73 	eorseq	r5, r2, r3, ror pc
    1388:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 12d4 <CPSR_IRQ_INHIBIT+0x1254>
    138c:	69732f65 	ldmdbvs	r3!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
    1390:	7661686c 	strbtvc	r6, [r1], -ip, ror #16
    1394:	532f6a79 			; <UNDEFINED> instruction: 0x532f6a79
    1398:	6f6f6863 	svcvs	0x006f6863
    139c:	655a2f6c 	ldrbvs	r2, [sl, #-3948]	; 0xfffff094
    13a0:	614d6f72 	hvcvs	55026	; 0xd6f2
    13a4:	652f6574 	strvs	r6, [pc, #-1396]!	; e38 <CPSR_IRQ_INHIBIT+0xdb8>
    13a8:	706d6178 	rsbvc	r6, sp, r8, ror r1
    13ac:	2f73656c 	svccs	0x0073656c
    13b0:	632d3331 			; <UNDEFINED> instruction: 0x632d3331
    13b4:	65746e6f 	ldrbvs	r6, [r4, #-3695]!	; 0xfffff191
    13b8:	735f7478 	cmpvc	pc, #120, 8	; 0x78000000
    13bc:	63746977 	cmnvs	r4, #1949696	; 0x1dc000
    13c0:	6f6d5f68 	svcvs	0x006d5f68
    13c4:	6f74696e 	svcvs	0x0074696e
    13c8:	656b2f72 	strbvs	r2, [fp, #-3954]!	; 0xfffff08e
    13cc:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
    13d0:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
    13d4:	69616d2f 	stmdbvs	r1!, {r0, r1, r2, r3, r5, r8, sl, fp, sp, lr}^
    13d8:	70632e6e 	rsbvc	r2, r3, lr, ror #28
    13dc:	61500070 	cmpvs	r0, r0, ror r0
    13e0:	69536567 	ldmdbvs	r3, {r0, r1, r2, r5, r6, r8, sl, sp, lr}^
    13e4:	6800657a 	stmdavs	r0, {r1, r3, r4, r5, r6, r8, sl, sp, lr}
    13e8:	00327264 	eorseq	r7, r2, r4, ror #4
    13ec:	6f6c6c41 	svcvs	0x006c6c41
    13f0:	61505f63 	cmpvs	r0, r3, ror #30
    13f4:	46006567 	strmi	r6, [r0], -r7, ror #10
    13f8:	5f656572 	svcpl	0x00656572
    13fc:	65676150 	strbvs	r6, [r7, #-336]!	; 0xfffffeb0
    1400:	75686300 	strbvc	r6, [r8, #-768]!	; 0xfffffd00
    1404:	4d006b6e 	vstrmi	d6, [r0, #-440]	; 0xfffffe48
    1408:	006b7261 	rsbeq	r7, fp, r1, ror #4
    140c:	6761506d 	strbvs	r5, [r1, -sp, rrx]!
    1410:	69425f65 	stmdbvs	r2, {r0, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
    1414:	70616d74 	rsbvc	r6, r1, r4, ror sp
    1418:	4c475f00 	mcrrmi	15, 0, r5, r7, cr0
    141c:	4c41424f 	sfmmi	f4, 2, [r1], {79}	; 0x4f
    1420:	75735f5f 	ldrbvc	r5, [r3, #-3935]!	; 0xfffff0a1
    1424:	5f495f62 	svcpl	0x00495f62
    1428:	72654b73 	rsbvc	r4, r5, #117760	; 0x1cc00
    142c:	4d6c656e 	cfstr64mi	mvdx6, [ip, #-440]!	; 0xfffffe48
    1430:	5f006d65 	svcpl	0x00006d65
    1434:	33314e5a 	teqcc	r1, #1440	; 0x5a0
    1438:	67615043 	strbvs	r5, [r1, -r3, asr #32]!
    143c:	614d5f65 	cmpvs	sp, r5, ror #30
    1440:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
    1444:	41303172 	teqmi	r0, r2, ror r1
    1448:	636f6c6c 	cmnvs	pc, #108, 24	; 0x6c00
    144c:	6761505f 			; <UNDEFINED> instruction: 0x6761505f
    1450:	00764565 	rsbseq	r4, r6, r5, ror #10
    1454:	324e5a5f 	subcc	r5, lr, #389120	; 0x5f000
    1458:	654b4330 	strbvs	r4, [fp, #-816]	; 0xfffffcd0
    145c:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
    1460:	6165485f 	cmnvs	r5, pc, asr r8
    1464:	614d5f70 	hvcvs	54768	; 0xd5f0
    1468:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
    146c:	45324372 	ldrmi	r4, [r2, #-882]!	; 0xfffffc8e
    1470:	682f0076 	stmdavs	pc!, {r1, r2, r4, r5, r6}	; <UNPREDICTABLE>
    1474:	2f656d6f 	svccs	0x00656d6f
    1478:	686c6973 	stmdavs	ip!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
    147c:	6a797661 	bvs	1e5ee08 <_bss_end+0x1e53298>
    1480:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
    1484:	2f6c6f6f 	svccs	0x006c6f6f
    1488:	6f72655a 	svcvs	0x0072655a
    148c:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
    1490:	6178652f 	cmnvs	r8, pc, lsr #10
    1494:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
    1498:	33312f73 	teqcc	r1, #460	; 0x1cc
    149c:	6e6f632d 	cdpvs	3, 6, cr6, cr15, cr13, {1}
    14a0:	74786574 	ldrbtvc	r6, [r8], #-1396	; 0xfffffa8c
    14a4:	6977735f 	ldmdbvs	r7!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, sp, lr}^
    14a8:	5f686374 	svcpl	0x00686374
    14ac:	696e6f6d 	stmdbvs	lr!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
    14b0:	2f726f74 	svccs	0x00726f74
    14b4:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
    14b8:	732f6c65 			; <UNDEFINED> instruction: 0x732f6c65
    14bc:	6d2f6372 	stcvs	3, cr6, [pc, #-456]!	; 12fc <CPSR_IRQ_INHIBIT+0x127c>
    14c0:	726f6d65 	rsbvc	r6, pc, #6464	; 0x1940
    14c4:	656b2f79 	strbvs	r2, [fp, #-3961]!	; 0xfffff087
    14c8:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
    14cc:	6165685f 	cmnvs	r5, pc, asr r8
    14d0:	70632e70 	rsbvc	r2, r3, r0, ror lr
    14d4:	5a5f0070 	bpl	17c169c <_bss_end+0x17b5b2c>
    14d8:	4333314e 	teqmi	r3, #-2147483629	; 0x80000013
    14dc:	65676150 	strbvs	r6, [r7, #-336]!	; 0xfffffeb0
    14e0:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
    14e4:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
    14e8:	72614d34 	rsbvc	r4, r1, #52, 26	; 0xd00
    14ec:	626a456b 	rsbvs	r4, sl, #448790528	; 0x1ac00000
    14f0:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
    14f4:	50433331 	subpl	r3, r3, r1, lsr r3
    14f8:	5f656761 	svcpl	0x00656761
    14fc:	616e614d 	cmnvs	lr, sp, asr #2
    1500:	43726567 	cmnmi	r2, #432013312	; 0x19c00000
    1504:	00764534 	rsbseq	r4, r6, r4, lsr r5
    1508:	314e5a5f 	cmpcc	lr, pc, asr sl
    150c:	61504333 	cmpvs	r0, r3, lsr r3
    1510:	4d5f6567 	cfldr64mi	mvdx6, [pc, #-412]	; 137c <CPSR_IRQ_INHIBIT+0x12fc>
    1514:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
    1518:	46397265 	ldrtmi	r7, [r9], -r5, ror #4
    151c:	5f656572 	svcpl	0x00656572
    1520:	65676150 	strbvs	r6, [r7, #-336]!	; 0xfffffeb0
    1524:	43006a45 	movwmi	r6, #2629	; 0xa45
    1528:	65676150 	strbvs	r6, [r7, #-336]!	; 0xfffffeb0
    152c:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
    1530:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
    1534:	67617000 	strbvs	r7, [r1, -r0]!
    1538:	64695f65 	strbtvs	r5, [r9], #-3941	; 0xfffff09b
    153c:	682f0078 	stmdavs	pc!, {r3, r4, r5, r6}	; <UNPREDICTABLE>
    1540:	2f656d6f 	svccs	0x00656d6f
    1544:	686c6973 	stmdavs	ip!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
    1548:	6a797661 	bvs	1e5eed4 <_bss_end+0x1e53364>
    154c:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
    1550:	2f6c6f6f 	svccs	0x006c6f6f
    1554:	6f72655a 	svcvs	0x0072655a
    1558:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
    155c:	6178652f 	cmnvs	r8, pc, lsr #10
    1560:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
    1564:	33312f73 	teqcc	r1, #460	; 0x1cc
    1568:	6e6f632d 	cdpvs	3, 6, cr6, cr15, cr13, {1}
    156c:	74786574 	ldrbtvc	r6, [r8], #-1396	; 0xfffffa8c
    1570:	6977735f 	ldmdbvs	r7!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, sp, lr}^
    1574:	5f686374 	svcpl	0x00686374
    1578:	696e6f6d 	stmdbvs	lr!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
    157c:	2f726f74 	svccs	0x00726f74
    1580:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
    1584:	732f6c65 			; <UNDEFINED> instruction: 0x732f6c65
    1588:	6d2f6372 	stcvs	3, cr6, [pc, #-456]!	; 13c8 <CPSR_IRQ_INHIBIT+0x1348>
    158c:	726f6d65 	rsbvc	r6, pc, #6464	; 0x1940
    1590:	61702f79 	cmnvs	r0, r9, ror pc
    1594:	2e736567 	cdpcs	5, 7, cr6, cr3, cr7, {3}
    1598:	00707063 	rsbseq	r7, r0, r3, rrx
    159c:	4f4c475f 	svcmi	0x004c475f
    15a0:	5f4c4142 	svcpl	0x004c4142
    15a4:	6275735f 	rsbsvs	r7, r5, #2080374785	; 0x7c000001
    15a8:	735f495f 	cmpvc	pc, #1556480	; 0x17c000
    15ac:	65676150 	strbvs	r6, [r7, #-336]!	; 0xfffffeb0
    15b0:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
    15b4:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
    15b8:	65737500 	ldrbvs	r7, [r3, #-1280]!	; 0xfffffb00
    15bc:	5a5f0064 	bpl	17c1754 <_bss_end+0x17b5be4>
    15c0:	4333314e 	teqmi	r3, #-2147483629	; 0x80000013
    15c4:	65676150 	strbvs	r6, [r7, #-336]!	; 0xfffffeb0
    15c8:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
    15cc:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
    15d0:	76453243 	strbvc	r3, [r5], -r3, asr #4
    15d4:	6e756600 	cdpvs	6, 7, cr6, cr5, cr0, {0}
    15d8:	72747063 	rsbsvc	r7, r4, #99	; 0x63
    15dc:	5f736900 	svcpl	0x00736900
    15e0:	73726966 	cmnvc	r2, #1671168	; 0x198000
    15e4:	69745f74 	ldmdbvs	r4!, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    15e8:	4100656d 	tstmi	r0, sp, ror #10
    15ec:	636f6c6c 	cmnvs	pc, #108, 24	; 0x6c00
    15f0:	6154543c 	cmpvs	r4, ip, lsr r4
    15f4:	535f6b73 	cmppl	pc, #117760	; 0x1cc00
    15f8:	63757274 	cmnvs	r5, #116, 4	; 0x40000007
    15fc:	5f003e74 	svcpl	0x00003e74
    1600:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
    1604:	6f725043 	svcvs	0x00725043
    1608:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    160c:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
    1610:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
    1614:	76453243 	strbvc	r3, [r5], -r3, asr #4
    1618:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
    161c:	4b433032 	blmi	10cd6ec <_bss_end+0x10c1b7c>
    1620:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
    1624:	65485f6c 	strbvs	r5, [r8, #-3948]	; 0xfffff094
    1628:	4d5f7061 	ldclmi	0, cr7, [pc, #-388]	; 14ac <CPSR_IRQ_INHIBIT+0x142c>
    162c:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
    1630:	41357265 	teqmi	r5, r5, ror #4
    1634:	636f6c6c 	cmnvs	pc, #108, 24	; 0x6c00
    1638:	43383149 	teqmi	r8, #1073741842	; 0x40000012
    163c:	636f7250 	cmnvs	pc, #80, 4
    1640:	5f737365 	svcpl	0x00737365
    1644:	7473694c 	ldrbtvc	r6, [r3], #-2380	; 0xfffff6b4
    1648:	646f4e5f 	strbtvs	r4, [pc], #-3679	; 1650 <CPSR_IRQ_INHIBIT+0x15d0>
    164c:	50454565 	subpl	r4, r5, r5, ror #10
    1650:	00765f54 	rsbseq	r5, r6, r4, asr pc
    1654:	4f4c475f 	svcmi	0x004c475f
    1658:	5f4c4142 	svcpl	0x004c4142
    165c:	6275735f 	rsbsvs	r7, r5, #2080374785	; 0x7c000001
    1660:	735f495f 	cmpvc	pc, #1556480	; 0x17c000
    1664:	636f7250 	cmnvs	pc, #80, 4
    1668:	4d737365 	ldclmi	3, cr7, [r3, #-404]!	; 0xfffffe6c
    166c:	70007267 	andvc	r7, r0, r7, ror #4
    1670:	6e636f72 	mcrvs	15, 3, r6, cr3, cr2, {3}
    1674:	0065646f 	rsbeq	r6, r5, pc, ror #8
    1678:	6f6c6c41 	svcvs	0x006c6c41
    167c:	50433c63 	subpl	r3, r3, r3, ror #24
    1680:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    1684:	4c5f7373 	mrrcmi	3, 7, r7, pc, cr3	; <UNPREDICTABLE>
    1688:	5f747369 	svcpl	0x00747369
    168c:	65646f4e 	strbvs	r6, [r4, #-3918]!	; 0xfffff0b2
    1690:	682f003e 	stmdavs	pc!, {r1, r2, r3, r4, r5}	; <UNPREDICTABLE>
    1694:	2f656d6f 	svccs	0x00656d6f
    1698:	686c6973 	stmdavs	ip!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
    169c:	6a797661 	bvs	1e5f028 <_bss_end+0x1e534b8>
    16a0:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
    16a4:	2f6c6f6f 	svccs	0x006c6f6f
    16a8:	6f72655a 	svcvs	0x0072655a
    16ac:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
    16b0:	6178652f 	cmnvs	r8, pc, lsr #10
    16b4:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
    16b8:	33312f73 	teqcc	r1, #460	; 0x1cc
    16bc:	6e6f632d 	cdpvs	3, 6, cr6, cr15, cr13, {1}
    16c0:	74786574 	ldrbtvc	r6, [r8], #-1396	; 0xfffffa8c
    16c4:	6977735f 	ldmdbvs	r7!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, sp, lr}^
    16c8:	5f686374 	svcpl	0x00686374
    16cc:	696e6f6d 	stmdbvs	lr!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
    16d0:	2f726f74 	svccs	0x00726f74
    16d4:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
    16d8:	732f6c65 			; <UNDEFINED> instruction: 0x732f6c65
    16dc:	702f6372 	eorvc	r6, pc, r2, ror r3	; <UNPREDICTABLE>
    16e0:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    16e4:	702f7373 	eorvc	r7, pc, r3, ror r3	; <UNPREDICTABLE>
    16e8:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    16ec:	6d5f7373 	ldclvs	3, cr7, [pc, #-460]	; 1528 <CPSR_IRQ_INHIBIT+0x14a8>
    16f0:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
    16f4:	632e7265 			; <UNDEFINED> instruction: 0x632e7265
    16f8:	5f007070 	svcpl	0x00007070
    16fc:	30324e5a 	eorscc	r4, r2, sl, asr lr
    1700:	72654b43 	rsbvc	r4, r5, #68608	; 0x10c00
    1704:	5f6c656e 	svcpl	0x006c656e
    1708:	70616548 	rsbvc	r6, r1, r8, asr #10
    170c:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
    1710:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
    1714:	6c6c4135 	stfvse	f4, [ip], #-212	; 0xffffff2c
    1718:	3149636f 	cmpcc	r9, pc, ror #6
    171c:	61545432 	cmpvs	r4, r2, lsr r4
    1720:	535f6b73 	cmppl	pc, #117760	; 0x1cc00
    1724:	63757274 	cmnvs	r5, #116, 4	; 0x40000007
    1728:	50454574 	subpl	r4, r5, r4, ror r5
    172c:	00765f54 	rsbseq	r5, r6, r4, asr pc
    1730:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 167c <CPSR_IRQ_INHIBIT+0x15fc>
    1734:	69732f65 	ldmdbvs	r3!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
    1738:	7661686c 	strbtvc	r6, [r1], -ip, ror #16
    173c:	532f6a79 			; <UNDEFINED> instruction: 0x532f6a79
    1740:	6f6f6863 	svcvs	0x006f6863
    1744:	655a2f6c 	ldrbvs	r2, [sl, #-3948]	; 0xfffff094
    1748:	614d6f72 	hvcvs	55026	; 0xd6f2
    174c:	652f6574 	strvs	r6, [pc, #-1396]!	; 11e0 <CPSR_IRQ_INHIBIT+0x1160>
    1750:	706d6178 	rsbvc	r6, sp, r8, ror r1
    1754:	2f73656c 	svccs	0x0073656c
    1758:	632d3331 			; <UNDEFINED> instruction: 0x632d3331
    175c:	65746e6f 	ldrbvs	r6, [r4, #-3695]!	; 0xfffff191
    1760:	735f7478 	cmpvc	pc, #120, 8	; 0x78000000
    1764:	63746977 	cmnvs	r4, #1949696	; 0x1dc000
    1768:	6f6d5f68 	svcvs	0x006d5f68
    176c:	6f74696e 	svcvs	0x0074696e
    1770:	656b2f72 	strbvs	r2, [fp, #-3954]!	; 0xfffff08e
    1774:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
    1778:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
    177c:	6f72702f 	svcvs	0x0072702f
    1780:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    1784:	6977732f 	ldmdbvs	r7!, {r0, r1, r2, r3, r5, r8, r9, ip, sp, lr}^
    1788:	2e686374 	mcrcs	3, 3, r6, cr8, cr4, {3}
    178c:	4e470073 	mcrmi	0, 2, r0, cr7, cr3, {3}
    1790:	53412055 	movtpl	r2, #4181	; 0x1055
    1794:	332e3220 			; <UNDEFINED> instruction: 0x332e3220
    1798:	682f0034 	stmdavs	pc!, {r2, r4, r5}	; <UNPREDICTABLE>
    179c:	2f656d6f 	svccs	0x00656d6f
    17a0:	686c6973 	stmdavs	ip!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
    17a4:	6a797661 	bvs	1e5f130 <_bss_end+0x1e535c0>
    17a8:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
    17ac:	2f6c6f6f 	svccs	0x006c6f6f
    17b0:	6f72655a 	svcvs	0x0072655a
    17b4:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
    17b8:	6178652f 	cmnvs	r8, pc, lsr #10
    17bc:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
    17c0:	33312f73 	teqcc	r1, #460	; 0x1cc
    17c4:	6e6f632d 	cdpvs	3, 6, cr6, cr15, cr13, {1}
    17c8:	74786574 	ldrbtvc	r6, [r8], #-1396	; 0xfffffa8c
    17cc:	6977735f 	ldmdbvs	r7!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, sp, lr}^
    17d0:	5f686374 	svcpl	0x00686374
    17d4:	696e6f6d 	stmdbvs	lr!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
    17d8:	2f726f74 	svccs	0x00726f74
    17dc:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
    17e0:	732f6c65 			; <UNDEFINED> instruction: 0x732f6c65
    17e4:	732f6372 			; <UNDEFINED> instruction: 0x732f6372
    17e8:	74726174 	ldrbtvc	r6, [r2], #-372	; 0xfffffe8c
    17ec:	5f00732e 	svcpl	0x0000732e
    17f0:	74735f63 	ldrbtvc	r5, [r3], #-3939	; 0xfffff09d
    17f4:	75747261 	ldrbvc	r7, [r4, #-609]!	; 0xfffffd9f
    17f8:	625f0070 	subsvs	r0, pc, #112	; 0x70
    17fc:	735f7373 	cmpvc	pc, #-872415231	; 0xcc000001
    1800:	74726174 	ldrbtvc	r6, [r2], #-372	; 0xfffffe8c
    1804:	435f5f00 	cmpmi	pc, #0, 30
    1808:	5f524f54 	svcpl	0x00524f54
    180c:	5f444e45 	svcpl	0x00444e45
    1810:	5f5f005f 	svcpl	0x005f005f
    1814:	524f5443 	subpl	r5, pc, #1124073472	; 0x43000000
    1818:	53494c5f 	movtpl	r4, #40031	; 0x9c5f
    181c:	005f5f54 	subseq	r5, pc, r4, asr pc	; <UNPREDICTABLE>
    1820:	54445f5f 	strbpl	r5, [r4], #-3935	; 0xfffff0a1
    1824:	455f524f 	ldrbmi	r5, [pc, #-591]	; 15dd <CPSR_IRQ_INHIBIT+0x155d>
    1828:	5f5f444e 	svcpl	0x005f444e
    182c:	70635f00 	rsbvc	r5, r3, r0, lsl #30
    1830:	68735f70 	ldmdavs	r3!, {r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    1834:	6f647475 	svcvs	0x00647475
    1838:	5f006e77 	svcpl	0x00006e77
    183c:	5f737362 	svcpl	0x00737362
    1840:	00646e65 	rsbeq	r6, r4, r5, ror #28
    1844:	54445f5f 	strbpl	r5, [r4], #-3935	; 0xfffff0a1
    1848:	4c5f524f 	lfmmi	f5, 2, [pc], {79}	; 0x4f
    184c:	5f545349 	svcpl	0x00545349
    1850:	7464005f 	strbtvc	r0, [r4], #-95	; 0xffffffa1
    1854:	705f726f 	subsvc	r7, pc, pc, ror #4
    1858:	63007274 	movwvs	r7, #628	; 0x274
    185c:	5f726f74 	svcpl	0x00726f74
    1860:	00727470 	rsbseq	r7, r2, r0, ror r4
    1864:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 17b0 <CPSR_IRQ_INHIBIT+0x1730>
    1868:	69732f65 	ldmdbvs	r3!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
    186c:	7661686c 	strbtvc	r6, [r1], -ip, ror #16
    1870:	532f6a79 			; <UNDEFINED> instruction: 0x532f6a79
    1874:	6f6f6863 	svcvs	0x006f6863
    1878:	655a2f6c 	ldrbvs	r2, [sl, #-3948]	; 0xfffff094
    187c:	614d6f72 	hvcvs	55026	; 0xd6f2
    1880:	652f6574 	strvs	r6, [pc, #-1396]!	; 1314 <CPSR_IRQ_INHIBIT+0x1294>
    1884:	706d6178 	rsbvc	r6, sp, r8, ror r1
    1888:	2f73656c 	svccs	0x0073656c
    188c:	632d3331 			; <UNDEFINED> instruction: 0x632d3331
    1890:	65746e6f 	ldrbvs	r6, [r4, #-3695]!	; 0xfffff191
    1894:	735f7478 	cmpvc	pc, #120, 8	; 0x78000000
    1898:	63746977 	cmnvs	r4, #1949696	; 0x1dc000
    189c:	6f6d5f68 	svcvs	0x006d5f68
    18a0:	6f74696e 	svcvs	0x0074696e
    18a4:	656b2f72 	strbvs	r2, [fp, #-3954]!	; 0xfffff08e
    18a8:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
    18ac:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
    18b0:	6174732f 	cmnvs	r4, pc, lsr #6
    18b4:	70757472 	rsbsvc	r7, r5, r2, ror r4
    18b8:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
    18bc:	70635f00 	rsbvc	r5, r3, r0, lsl #30
    18c0:	74735f70 	ldrbtvc	r5, [r3], #-3952	; 0xfffff090
    18c4:	75747261 	ldrbvc	r7, [r4, #-609]!	; 0xfffffd9f
    18c8:	6e660070 	mcrvs	0, 3, r0, cr6, cr0, {3}
    18cc:	00727470 	rsbseq	r7, r2, r0, ror r4
    18d0:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 181c <CPSR_IRQ_INHIBIT+0x179c>
    18d4:	69732f65 	ldmdbvs	r3!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
    18d8:	7661686c 	strbtvc	r6, [r1], -ip, ror #16
    18dc:	532f6a79 			; <UNDEFINED> instruction: 0x532f6a79
    18e0:	6f6f6863 	svcvs	0x006f6863
    18e4:	655a2f6c 	ldrbvs	r2, [sl, #-3948]	; 0xfffff094
    18e8:	614d6f72 	hvcvs	55026	; 0xd6f2
    18ec:	652f6574 	strvs	r6, [pc, #-1396]!	; 1380 <CPSR_IRQ_INHIBIT+0x1300>
    18f0:	706d6178 	rsbvc	r6, sp, r8, ror r1
    18f4:	2f73656c 	svccs	0x0073656c
    18f8:	632d3331 			; <UNDEFINED> instruction: 0x632d3331
    18fc:	65746e6f 	ldrbvs	r6, [r4, #-3695]!	; 0xfffff191
    1900:	735f7478 	cmpvc	pc, #120, 8	; 0x78000000
    1904:	63746977 	cmnvs	r4, #1949696	; 0x1dc000
    1908:	6f6d5f68 	svcvs	0x006d5f68
    190c:	6f74696e 	svcvs	0x0074696e
    1910:	74732f72 	ldrbtvc	r2, [r3], #-3954	; 0xfffff08e
    1914:	62696c64 	rsbvs	r6, r9, #100, 24	; 0x6400
    1918:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
    191c:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
    1920:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
    1924:	632e676e 			; <UNDEFINED> instruction: 0x632e676e
    1928:	5f007070 	svcpl	0x00007070
    192c:	7469345a 	strbtvc	r3, [r9], #-1114	; 0xfffffba6
    1930:	506a616f 	rsbpl	r6, sl, pc, ror #2
    1934:	2e006a63 	vmlscs.f32	s12, s0, s7
    1938:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    193c:	2f2e2e2f 	svccs	0x002e2e2f
    1940:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1944:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1948:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    194c:	2f636367 	svccs	0x00636367
    1950:	666e6f63 	strbtvs	r6, [lr], -r3, ror #30
    1954:	612f6769 			; <UNDEFINED> instruction: 0x612f6769
    1958:	6c2f6d72 	stcvs	13, cr6, [pc], #-456	; 1798 <CPSR_IRQ_INHIBIT+0x1718>
    195c:	66316269 	ldrtvs	r6, [r1], -r9, ror #4
    1960:	73636e75 	cmnvc	r3, #1872	; 0x750
    1964:	2f00532e 	svccs	0x0000532e
    1968:	6c697562 	cfstr64vs	mvdx7, [r9], #-392	; 0xfffffe78
    196c:	63672f64 	cmnvs	r7, #100, 30	; 0x190
    1970:	72612d63 	rsbvc	r2, r1, #6336	; 0x18c0
    1974:	6f6e2d6d 	svcvs	0x006e2d6d
    1978:	652d656e 	strvs	r6, [sp, #-1390]!	; 0xfffffa92
    197c:	2d696261 	sfmcs	f6, 2, [r9, #-388]!	; 0xfffffe7c
    1980:	6b396c47 	blvs	e5caa4 <_bss_end+0xe50f34>
    1984:	672f3954 			; <UNDEFINED> instruction: 0x672f3954
    1988:	612d6363 			; <UNDEFINED> instruction: 0x612d6363
    198c:	6e2d6d72 	mcrvs	13, 1, r6, cr13, cr2, {3}
    1990:	2d656e6f 	stclcs	14, cr6, [r5, #-444]!	; 0xfffffe44
    1994:	69626165 	stmdbvs	r2!, {r0, r2, r5, r6, r8, sp, lr}^
    1998:	322d392d 	eorcc	r3, sp, #737280	; 0xb4000
    199c:	2d393130 	ldfcss	f3, [r9, #-192]!	; 0xffffff40
    19a0:	622f3471 	eorvs	r3, pc, #1895825408	; 0x71000000
    19a4:	646c6975 	strbtvs	r6, [ip], #-2421	; 0xfffff68b
    19a8:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
    19ac:	6e6f6e2d 	cdpvs	14, 6, cr6, cr15, cr13, {1}
    19b0:	61652d65 	cmnvs	r5, r5, ror #26
    19b4:	612f6962 			; <UNDEFINED> instruction: 0x612f6962
    19b8:	762f6d72 			; <UNDEFINED> instruction: 0x762f6d72
    19bc:	2f657435 	svccs	0x00657435
    19c0:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
    19c4:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    19c8:	00636367 	rsbeq	r6, r3, r7, ror #6
    19cc:	47524154 			; <UNDEFINED> instruction: 0x47524154
    19d0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    19d4:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    19d8:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    19dc:	37316178 			; <UNDEFINED> instruction: 0x37316178
    19e0:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    19e4:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    19e8:	61736900 	cmnvs	r3, r0, lsl #18
    19ec:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    19f0:	5f70665f 	svcpl	0x0070665f
    19f4:	006c6264 	rsbeq	r6, ip, r4, ror #4
    19f8:	5f6d7261 	svcpl	0x006d7261
    19fc:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1a00:	6d77695f 			; <UNDEFINED> instruction: 0x6d77695f
    1a04:	0074786d 	rsbseq	r7, r4, sp, ror #16
    1a08:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1a0c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1a10:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1a14:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1a18:	33326d78 	teqcc	r2, #120, 26	; 0x1e00
    1a1c:	4d524100 	ldfmie	f4, [r2, #-0]
    1a20:	0051455f 	subseq	r4, r1, pc, asr r5
    1a24:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1a28:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1a2c:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1a30:	31316d72 	teqcc	r1, r2, ror sp
    1a34:	32743635 	rsbscc	r3, r4, #55574528	; 0x3500000
    1a38:	69007366 	stmdbvs	r0, {r1, r2, r5, r6, r8, r9, ip, sp, lr}
    1a3c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1a40:	745f7469 	ldrbvc	r7, [pc], #-1129	; 1a48 <CPSR_IRQ_INHIBIT+0x19c8>
    1a44:	626d7568 	rsbvs	r7, sp, #104, 10	; 0x1a000000
    1a48:	52415400 	subpl	r5, r1, #0, 8
    1a4c:	5f544547 	svcpl	0x00544547
    1a50:	5f555043 	svcpl	0x00555043
    1a54:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1a58:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    1a5c:	726f6337 	rsbvc	r6, pc, #-603979776	; 0xdc000000
    1a60:	61786574 	cmnvs	r8, r4, ror r5
    1a64:	42003335 	andmi	r3, r0, #-738197504	; 0xd4000000
    1a68:	5f455341 	svcpl	0x00455341
    1a6c:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1a70:	5f4d385f 	svcpl	0x004d385f
    1a74:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1a78:	52415400 	subpl	r5, r1, #0, 8
    1a7c:	5f544547 	svcpl	0x00544547
    1a80:	5f555043 	svcpl	0x00555043
    1a84:	386d7261 	stmdacc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    1a88:	54003031 	strpl	r3, [r0], #-49	; 0xffffffcf
    1a8c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1a90:	50435f54 	subpl	r5, r3, r4, asr pc
    1a94:	67785f55 			; <UNDEFINED> instruction: 0x67785f55
    1a98:	31656e65 	cmncc	r5, r5, ror #28
    1a9c:	4d524100 	ldfmie	f4, [r2, #-0]
    1aa0:	5343505f 	movtpl	r5, #12383	; 0x305f
    1aa4:	5041415f 	subpl	r4, r1, pc, asr r1
    1aa8:	495f5343 	ldmdbmi	pc, {r0, r1, r6, r8, r9, ip, lr}^	; <UNPREDICTABLE>
    1aac:	584d4d57 	stmdapl	sp, {r0, r1, r2, r4, r6, r8, sl, fp, lr}^
    1ab0:	41420054 	qdaddmi	r0, r4, r2
    1ab4:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1ab8:	5f484352 	svcpl	0x00484352
    1abc:	41420030 	cmpmi	r2, r0, lsr r0
    1ac0:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1ac4:	5f484352 	svcpl	0x00484352
    1ac8:	41420032 	cmpmi	r2, r2, lsr r0
    1acc:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1ad0:	5f484352 	svcpl	0x00484352
    1ad4:	41420033 	cmpmi	r2, r3, lsr r0
    1ad8:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1adc:	5f484352 	svcpl	0x00484352
    1ae0:	41420034 	cmpmi	r2, r4, lsr r0
    1ae4:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1ae8:	5f484352 	svcpl	0x00484352
    1aec:	41420036 	cmpmi	r2, r6, lsr r0
    1af0:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1af4:	5f484352 	svcpl	0x00484352
    1af8:	41540037 	cmpmi	r4, r7, lsr r0
    1afc:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1b00:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1b04:	6373785f 	cmnvs	r3, #6225920	; 0x5f0000
    1b08:	00656c61 	rsbeq	r6, r5, r1, ror #24
    1b0c:	5f617369 	svcpl	0x00617369
    1b10:	5f746962 	svcpl	0x00746962
    1b14:	64657270 	strbtvs	r7, [r5], #-624	; 0xfffffd90
    1b18:	00736572 	rsbseq	r6, r3, r2, ror r5
    1b1c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1b20:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1b24:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1b28:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1b2c:	33336d78 	teqcc	r3, #120, 26	; 0x1e00
    1b30:	52415400 	subpl	r5, r1, #0, 8
    1b34:	5f544547 	svcpl	0x00544547
    1b38:	5f555043 	svcpl	0x00555043
    1b3c:	376d7261 	strbcc	r7, [sp, -r1, ror #4]!
    1b40:	696d6474 	stmdbvs	sp!, {r2, r4, r5, r6, sl, sp, lr}^
    1b44:	61736900 	cmnvs	r3, r0, lsl #18
    1b48:	626f6e5f 	rsbvs	r6, pc, #1520	; 0x5f0
    1b4c:	54007469 	strpl	r7, [r0], #-1129	; 0xfffffb97
    1b50:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1b54:	50435f54 	subpl	r5, r3, r4, asr pc
    1b58:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1b5c:	3731316d 	ldrcc	r3, [r1, -sp, ror #2]!
    1b60:	667a6a36 			; <UNDEFINED> instruction: 0x667a6a36
    1b64:	73690073 	cmnvc	r9, #115	; 0x73
    1b68:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1b6c:	66765f74 	uhsub16vs	r5, r6, r4
    1b70:	00327670 	eorseq	r7, r2, r0, ror r6
    1b74:	5f4d5241 	svcpl	0x004d5241
    1b78:	5f534350 	svcpl	0x00534350
    1b7c:	4e4b4e55 	mcrmi	14, 2, r4, cr11, cr5, {2}
    1b80:	004e574f 	subeq	r5, lr, pc, asr #14
    1b84:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1b88:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1b8c:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1b90:	65396d72 	ldrvs	r6, [r9, #-3442]!	; 0xfffff28e
    1b94:	53414200 	movtpl	r4, #4608	; 0x1200
    1b98:	52415f45 	subpl	r5, r1, #276	; 0x114
    1b9c:	355f4843 	ldrbcc	r4, [pc, #-2115]	; 1361 <CPSR_IRQ_INHIBIT+0x12e1>
    1ba0:	004a4554 	subeq	r4, sl, r4, asr r5
    1ba4:	5f6d7261 	svcpl	0x006d7261
    1ba8:	73666363 	cmnvc	r6, #-1946157055	; 0x8c000001
    1bac:	74735f6d 	ldrbtvc	r5, [r3], #-3949	; 0xfffff093
    1bb0:	00657461 	rsbeq	r7, r5, r1, ror #8
    1bb4:	5f6d7261 	svcpl	0x006d7261
    1bb8:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1bbc:	00657435 	rsbeq	r7, r5, r5, lsr r4
    1bc0:	70736e75 	rsbsvc	r6, r3, r5, ror lr
    1bc4:	735f6365 	cmpvc	pc, #-1811939327	; 0x94000001
    1bc8:	6e697274 	mcrvs	2, 3, r7, cr9, cr4, {3}
    1bcc:	69007367 	stmdbvs	r0, {r0, r1, r2, r5, r6, r8, r9, ip, sp, lr}
    1bd0:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1bd4:	735f7469 	cmpvc	pc, #1761607680	; 0x69000000
    1bd8:	5f006365 	svcpl	0x00006365
    1bdc:	7a6c635f 	bvc	1b1a960 <_bss_end+0x1b0edf0>
    1be0:	6261745f 	rsbvs	r7, r1, #1593835520	; 0x5f000000
    1be4:	4d524100 	ldfmie	f4, [r2, #-0]
    1be8:	0043565f 	subeq	r5, r3, pc, asr r6
    1bec:	5f6d7261 	svcpl	0x006d7261
    1bf0:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1bf4:	6373785f 	cmnvs	r3, #6225920	; 0x5f0000
    1bf8:	00656c61 	rsbeq	r6, r5, r1, ror #24
    1bfc:	5f4d5241 	svcpl	0x004d5241
    1c00:	4100454c 	tstmi	r0, ip, asr #10
    1c04:	565f4d52 			; <UNDEFINED> instruction: 0x565f4d52
    1c08:	52410053 	subpl	r0, r1, #83	; 0x53
    1c0c:	45475f4d 	strbmi	r5, [r7, #-3917]	; 0xfffff0b3
    1c10:	6d726100 	ldfvse	f6, [r2, #-0]
    1c14:	6e75745f 	mrcvs	4, 3, r7, cr5, cr15, {2}
    1c18:	74735f65 	ldrbtvc	r5, [r3], #-3941	; 0xfffff09b
    1c1c:	676e6f72 			; <UNDEFINED> instruction: 0x676e6f72
    1c20:	006d7261 	rsbeq	r7, sp, r1, ror #4
    1c24:	706d6f63 	rsbvc	r6, sp, r3, ror #30
    1c28:	2078656c 	rsbscs	r6, r8, ip, ror #10
    1c2c:	616f6c66 	cmnvs	pc, r6, ror #24
    1c30:	41540074 	cmpmi	r4, r4, ror r0
    1c34:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1c38:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1c3c:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1c40:	61786574 	cmnvs	r8, r4, ror r5
    1c44:	54003531 	strpl	r3, [r0], #-1329	; 0xfffffacf
    1c48:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1c4c:	50435f54 	subpl	r5, r3, r4, asr pc
    1c50:	61665f55 	cmnvs	r6, r5, asr pc
    1c54:	74363237 	ldrtvc	r3, [r6], #-567	; 0xfffffdc9
    1c58:	41540065 	cmpmi	r4, r5, rrx
    1c5c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1c60:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1c64:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1c68:	61786574 	cmnvs	r8, r4, ror r5
    1c6c:	41003731 	tstmi	r0, r1, lsr r7
    1c70:	475f4d52 			; <UNDEFINED> instruction: 0x475f4d52
    1c74:	41540054 	cmpmi	r4, r4, asr r0
    1c78:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1c7c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1c80:	6f656e5f 	svcvs	0x00656e5f
    1c84:	73726576 	cmnvc	r2, #494927872	; 0x1d800000
    1c88:	00316e65 	eorseq	r6, r1, r5, ror #28
    1c8c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1c90:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1c94:	2f2e2e2f 	svccs	0x002e2e2f
    1c98:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1c9c:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
    1ca0:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    1ca4:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    1ca8:	32636367 	rsbcc	r6, r3, #-1677721599	; 0x9c000001
    1cac:	5400632e 	strpl	r6, [r0], #-814	; 0xfffffcd2
    1cb0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1cb4:	50435f54 	subpl	r5, r3, r4, asr pc
    1cb8:	6f635f55 	svcvs	0x00635f55
    1cbc:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1cc0:	00663472 	rsbeq	r3, r6, r2, ror r4
    1cc4:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1cc8:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1ccc:	45375f48 	ldrmi	r5, [r7, #-3912]!	; 0xfffff0b8
    1cd0:	4154004d 	cmpmi	r4, sp, asr #32
    1cd4:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1cd8:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1cdc:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1ce0:	61786574 	cmnvs	r8, r4, ror r5
    1ce4:	68003231 	stmdavs	r0, {r0, r4, r5, r9, ip, sp}
    1ce8:	76687361 	strbtvc	r7, [r8], -r1, ror #6
    1cec:	745f6c61 	ldrbvc	r6, [pc], #-3169	; 1cf4 <CPSR_IRQ_INHIBIT+0x1c74>
    1cf0:	53414200 	movtpl	r4, #4608	; 0x1200
    1cf4:	52415f45 	subpl	r5, r1, #276	; 0x114
    1cf8:	365f4843 	ldrbcc	r4, [pc], -r3, asr #16
    1cfc:	69005a4b 	stmdbvs	r0, {r0, r1, r3, r6, r9, fp, ip, lr}
    1d00:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1d04:	00737469 	rsbseq	r7, r3, r9, ror #8
    1d08:	5f6d7261 	svcpl	0x006d7261
    1d0c:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1d10:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1d14:	6477685f 	ldrbtvs	r6, [r7], #-2143	; 0xfffff7a1
    1d18:	61007669 	tstvs	r0, r9, ror #12
    1d1c:	665f6d72 			; <UNDEFINED> instruction: 0x665f6d72
    1d20:	645f7570 	ldrbvs	r7, [pc], #-1392	; 1d28 <CPSR_IRQ_INHIBIT+0x1ca8>
    1d24:	00637365 	rsbeq	r7, r3, r5, ror #6
    1d28:	5f617369 	svcpl	0x00617369
    1d2c:	5f746962 	svcpl	0x00746962
    1d30:	36317066 	ldrtcc	r7, [r1], -r6, rrx
    1d34:	554e4700 	strbpl	r4, [lr, #-1792]	; 0xfffff900
    1d38:	37314320 	ldrcc	r4, [r1, -r0, lsr #6]!
    1d3c:	322e3920 	eorcc	r3, lr, #32, 18	; 0x80000
    1d40:	3220312e 	eorcc	r3, r0, #-2147483637	; 0x8000000b
    1d44:	31393130 	teqcc	r9, r0, lsr r1
    1d48:	20353230 	eorscs	r3, r5, r0, lsr r2
    1d4c:	6c657228 	sfmvs	f7, 2, [r5], #-160	; 0xffffff60
    1d50:	65736165 	ldrbvs	r6, [r3, #-357]!	; 0xfffffe9b
    1d54:	415b2029 	cmpmi	fp, r9, lsr #32
    1d58:	612f4d52 			; <UNDEFINED> instruction: 0x612f4d52
    1d5c:	392d6d72 	pushcc	{r1, r4, r5, r6, r8, sl, fp, sp, lr}
    1d60:	6172622d 	cmnvs	r2, sp, lsr #4
    1d64:	2068636e 	rsbcs	r6, r8, lr, ror #6
    1d68:	69766572 	ldmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
    1d6c:	6e6f6973 			; <UNDEFINED> instruction: 0x6e6f6973
    1d70:	37373220 	ldrcc	r3, [r7, -r0, lsr #4]!
    1d74:	5d393935 			; <UNDEFINED> instruction: 0x5d393935
    1d78:	616d2d20 	cmnvs	sp, r0, lsr #26
    1d7c:	2d206d72 	stccs	13, cr6, [r0, #-456]!	; 0xfffffe38
    1d80:	6f6c666d 	svcvs	0x006c666d
    1d84:	612d7461 			; <UNDEFINED> instruction: 0x612d7461
    1d88:	683d6962 	ldmdavs	sp!, {r1, r5, r6, r8, fp, sp, lr}
    1d8c:	20647261 	rsbcs	r7, r4, r1, ror #4
    1d90:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
    1d94:	613d6863 	teqvs	sp, r3, ror #16
    1d98:	35766d72 	ldrbcc	r6, [r6, #-3442]!	; 0xfffff28e
    1d9c:	662b6574 			; <UNDEFINED> instruction: 0x662b6574
    1da0:	672d2070 			; <UNDEFINED> instruction: 0x672d2070
    1da4:	20672d20 	rsbcs	r2, r7, r0, lsr #26
    1da8:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
    1dac:	2d20324f 	sfmcs	f3, 4, [r0, #-316]!	; 0xfffffec4
    1db0:	2d20324f 	sfmcs	f3, 4, [r0, #-316]!	; 0xfffffec4
    1db4:	2d20324f 	sfmcs	f3, 4, [r0, #-316]!	; 0xfffffec4
    1db8:	69756266 	ldmdbvs	r5!, {r1, r2, r5, r6, r9, sp, lr}^
    1dbc:	6e69646c 	cdpvs	4, 6, cr6, cr9, cr12, {3}
    1dc0:	696c2d67 	stmdbvs	ip!, {r0, r1, r2, r5, r6, r8, sl, fp, sp}^
    1dc4:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    1dc8:	6e662d20 	cdpvs	13, 6, cr2, cr6, cr0, {1}
    1dcc:	74732d6f 	ldrbtvc	r2, [r3], #-3439	; 0xfffff291
    1dd0:	2d6b6361 	stclcs	3, cr6, [fp, #-388]!	; 0xfffffe7c
    1dd4:	746f7270 	strbtvc	r7, [pc], #-624	; 1ddc <CPSR_IRQ_INHIBIT+0x1d5c>
    1dd8:	6f746365 	svcvs	0x00746365
    1ddc:	662d2072 			; <UNDEFINED> instruction: 0x662d2072
    1de0:	692d6f6e 	pushvs	{r1, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}
    1de4:	6e696c6e 	cdpvs	12, 6, cr6, cr9, cr14, {3}
    1de8:	662d2065 	strtvs	r2, [sp], -r5, rrx
    1dec:	69736976 	ldmdbvs	r3!, {r1, r2, r4, r5, r6, r8, fp, sp, lr}^
    1df0:	696c6962 	stmdbvs	ip!, {r1, r5, r6, r8, fp, sp, lr}^
    1df4:	683d7974 	ldmdavs	sp!, {r2, r4, r5, r6, r8, fp, ip, sp, lr}
    1df8:	65646469 	strbvs	r6, [r4, #-1129]!	; 0xfffffb97
    1dfc:	5241006e 	subpl	r0, r1, #110	; 0x6e
    1e00:	49485f4d 	stmdbmi	r8, {r0, r2, r3, r6, r8, r9, sl, fp, ip, lr}^
    1e04:	61736900 	cmnvs	r3, r0, lsl #18
    1e08:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1e0c:	6964615f 	stmdbvs	r4!, {r0, r1, r2, r3, r4, r6, r8, sp, lr}^
    1e10:	41540076 	cmpmi	r4, r6, ror r0
    1e14:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1e18:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1e1c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1e20:	36333131 			; <UNDEFINED> instruction: 0x36333131
    1e24:	5400736a 	strpl	r7, [r0], #-874	; 0xfffffc96
    1e28:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1e2c:	50435f54 	subpl	r5, r3, r4, asr pc
    1e30:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1e34:	5400386d 	strpl	r3, [r0], #-2157	; 0xfffff793
    1e38:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1e3c:	50435f54 	subpl	r5, r3, r4, asr pc
    1e40:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1e44:	5400396d 	strpl	r3, [r0], #-2413	; 0xfffff693
    1e48:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1e4c:	50435f54 	subpl	r5, r3, r4, asr pc
    1e50:	61665f55 	cmnvs	r6, r5, asr pc
    1e54:	00363236 	eorseq	r3, r6, r6, lsr r2
    1e58:	676e6f6c 	strbvs	r6, [lr, -ip, ror #30]!
    1e5c:	6e6f6c20 	cdpvs	12, 6, cr6, cr15, cr0, {1}
    1e60:	6e752067 	cdpvs	0, 7, cr2, cr5, cr7, {3}
    1e64:	6e676973 			; <UNDEFINED> instruction: 0x6e676973
    1e68:	69206465 	stmdbvs	r0!, {r0, r2, r5, r6, sl, sp, lr}
    1e6c:	6100746e 	tstvs	r0, lr, ror #8
    1e70:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1e74:	5f686372 	svcpl	0x00686372
    1e78:	65736d63 	ldrbvs	r6, [r3, #-3427]!	; 0xfffff29d
    1e7c:	52415400 	subpl	r5, r1, #0, 8
    1e80:	5f544547 	svcpl	0x00544547
    1e84:	5f555043 	svcpl	0x00555043
    1e88:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1e8c:	346d7865 	strbtcc	r7, [sp], #-2149	; 0xfffff79b
    1e90:	52415400 	subpl	r5, r1, #0, 8
    1e94:	5f544547 	svcpl	0x00544547
    1e98:	5f555043 	svcpl	0x00555043
    1e9c:	316d7261 	cmncc	sp, r1, ror #4
    1ea0:	54006530 	strpl	r6, [r0], #-1328	; 0xfffffad0
    1ea4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1ea8:	50435f54 	subpl	r5, r3, r4, asr pc
    1eac:	6f635f55 	svcvs	0x00635f55
    1eb0:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1eb4:	6100376d 	tstvs	r0, sp, ror #14
    1eb8:	635f6d72 	cmpvs	pc, #7296	; 0x1c80
    1ebc:	5f646e6f 	svcpl	0x00646e6f
    1ec0:	65646f63 	strbvs	r6, [r4, #-3939]!	; 0xfffff09d
    1ec4:	4d524100 	ldfmie	f4, [r2, #-0]
    1ec8:	5343505f 	movtpl	r5, #12383	; 0x305f
    1ecc:	5041415f 	subpl	r4, r1, pc, asr r1
    1ed0:	69005343 	stmdbvs	r0, {r0, r1, r6, r8, r9, ip, lr}
    1ed4:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1ed8:	615f7469 	cmpvs	pc, r9, ror #8
    1edc:	38766d72 	ldmdacc	r6!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^
    1ee0:	4200325f 	andmi	r3, r0, #-268435451	; 0xf0000005
    1ee4:	5f455341 	svcpl	0x00455341
    1ee8:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1eec:	004d335f 	subeq	r3, sp, pc, asr r3
    1ef0:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1ef4:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1ef8:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1efc:	31376d72 	teqcc	r7, r2, ror sp
    1f00:	61007430 	tstvs	r0, r0, lsr r4
    1f04:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1f08:	5f686372 	svcpl	0x00686372
    1f0c:	6d6d7769 	stclvs	7, cr7, [sp, #-420]!	; 0xfffffe5c
    1f10:	00327478 	eorseq	r7, r2, r8, ror r4
    1f14:	5f617369 	svcpl	0x00617369
    1f18:	5f6d756e 	svcpl	0x006d756e
    1f1c:	73746962 	cmnvc	r4, #1605632	; 0x188000
    1f20:	52415400 	subpl	r5, r1, #0, 8
    1f24:	5f544547 	svcpl	0x00544547
    1f28:	5f555043 	svcpl	0x00555043
    1f2c:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1f30:	306d7865 	rsbcc	r7, sp, r5, ror #16
    1f34:	73756c70 	cmnvc	r5, #112, 24	; 0x7000
    1f38:	6c616d73 	stclvs	13, cr6, [r1], #-460	; 0xfffffe34
    1f3c:	6c756d6c 	ldclvs	13, cr6, [r5], #-432	; 0xfffffe50
    1f40:	6c706974 			; <UNDEFINED> instruction: 0x6c706974
    1f44:	41540079 	cmpmi	r4, r9, ror r0
    1f48:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1f4c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1f50:	7978655f 	ldmdbvc	r8!, {r0, r1, r2, r3, r4, r6, r8, sl, sp, lr}^
    1f54:	6d736f6e 	ldclvs	15, cr6, [r3, #-440]!	; 0xfffffe48
    1f58:	41540031 	cmpmi	r4, r1, lsr r0
    1f5c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1f60:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1f64:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1f68:	72786574 	rsbsvc	r6, r8, #116, 10	; 0x1d000000
    1f6c:	69003235 	stmdbvs	r0, {r0, r2, r4, r5, r9, ip, sp}
    1f70:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1f74:	745f7469 	ldrbvc	r7, [pc], #-1129	; 1f7c <CPSR_IRQ_INHIBIT+0x1efc>
    1f78:	00766964 	rsbseq	r6, r6, r4, ror #18
    1f7c:	66657270 			; <UNDEFINED> instruction: 0x66657270
    1f80:	6e5f7265 	cdpvs	2, 5, cr7, cr15, cr5, {3}
    1f84:	5f6e6f65 	svcpl	0x006e6f65
    1f88:	5f726f66 	svcpl	0x00726f66
    1f8c:	69623436 	stmdbvs	r2!, {r1, r2, r4, r5, sl, ip, sp}^
    1f90:	69007374 	stmdbvs	r0, {r2, r4, r5, r6, r8, r9, ip, sp, lr}
    1f94:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1f98:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    1f9c:	66363170 			; <UNDEFINED> instruction: 0x66363170
    1fa0:	54006c6d 	strpl	r6, [r0], #-3181	; 0xfffff393
    1fa4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1fa8:	50435f54 	subpl	r5, r3, r4, asr pc
    1fac:	6f635f55 	svcvs	0x00635f55
    1fb0:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1fb4:	00323361 	eorseq	r3, r2, r1, ror #6
    1fb8:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1fbc:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1fc0:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1fc4:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1fc8:	35336178 	ldrcc	r6, [r3, #-376]!	; 0xfffffe88
    1fcc:	61736900 	cmnvs	r3, r0, lsl #18
    1fd0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1fd4:	3170665f 	cmncc	r0, pc, asr r6
    1fd8:	6e6f6336 	mcrvs	3, 3, r6, cr15, cr6, {1}
    1fdc:	6e750076 	mrcvs	0, 3, r0, cr5, cr6, {3}
    1fe0:	63657073 	cmnvs	r5, #115	; 0x73
    1fe4:	74735f76 	ldrbtvc	r5, [r3], #-3958	; 0xfffff08a
    1fe8:	676e6972 			; <UNDEFINED> instruction: 0x676e6972
    1fec:	41540073 	cmpmi	r4, r3, ror r0
    1ff0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1ff4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1ff8:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1ffc:	36353131 			; <UNDEFINED> instruction: 0x36353131
    2000:	00733274 	rsbseq	r3, r3, r4, ror r2
    2004:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2008:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    200c:	665f5550 			; <UNDEFINED> instruction: 0x665f5550
    2010:	36303661 	ldrtcc	r3, [r0], -r1, ror #12
    2014:	54006574 	strpl	r6, [r0], #-1396	; 0xfffffa8c
    2018:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    201c:	50435f54 	subpl	r5, r3, r4, asr pc
    2020:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    2024:	3632396d 	ldrtcc	r3, [r2], -sp, ror #18
    2028:	00736a65 	rsbseq	r6, r3, r5, ror #20
    202c:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    2030:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    2034:	54345f48 	ldrtpl	r5, [r4], #-3912	; 0xfffff0b8
    2038:	61736900 	cmnvs	r3, r0, lsl #18
    203c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2040:	7972635f 	ldmdbvc	r2!, {r0, r1, r2, r3, r4, r6, r8, r9, sp, lr}^
    2044:	006f7470 	rsbeq	r7, pc, r0, ror r4	; <UNPREDICTABLE>
    2048:	5f6d7261 	svcpl	0x006d7261
    204c:	73676572 	cmnvc	r7, #478150656	; 0x1c800000
    2050:	5f6e695f 	svcpl	0x006e695f
    2054:	75716573 	ldrbvc	r6, [r1, #-1395]!	; 0xfffffa8d
    2058:	65636e65 	strbvs	r6, [r3, #-3685]!	; 0xfffff19b
    205c:	61736900 	cmnvs	r3, r0, lsl #18
    2060:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2064:	0062735f 	rsbeq	r7, r2, pc, asr r3
    2068:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    206c:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    2070:	54355f48 	ldrtpl	r5, [r5], #-3912	; 0xfffff0b8
    2074:	73690045 	cmnvc	r9, #69	; 0x45
    2078:	65665f61 	strbvs	r5, [r6, #-3937]!	; 0xfffff09f
    207c:	72757461 	rsbsvc	r7, r5, #1627389952	; 0x61000000
    2080:	73690065 	cmnvc	r9, #101	; 0x65
    2084:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2088:	6d735f74 	ldclvs	15, cr5, [r3, #-464]!	; 0xfffffe30
    208c:	6d6c6c61 	stclvs	12, cr6, [ip, #-388]!	; 0xfffffe7c
    2090:	61006c75 	tstvs	r0, r5, ror ip
    2094:	6c5f6d72 	mrrcvs	13, 7, r6, pc, cr2	; <UNPREDICTABLE>
    2098:	5f676e61 	svcpl	0x00676e61
    209c:	7074756f 	rsbsvc	r7, r4, pc, ror #10
    20a0:	6f5f7475 	svcvs	0x005f7475
    20a4:	63656a62 	cmnvs	r5, #401408	; 0x62000
    20a8:	74615f74 	strbtvc	r5, [r1], #-3956	; 0xfffff08c
    20ac:	62697274 	rsbvs	r7, r9, #116, 4	; 0x40000007
    20b0:	73657475 	cmnvc	r5, #1962934272	; 0x75000000
    20b4:	6f6f685f 	svcvs	0x006f685f
    20b8:	7369006b 	cmnvc	r9, #107	; 0x6b
    20bc:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    20c0:	70665f74 	rsbvc	r5, r6, r4, ror pc
    20c4:	3233645f 	eorscc	r6, r3, #1593835520	; 0x5f000000
    20c8:	4d524100 	ldfmie	f4, [r2, #-0]
    20cc:	00454e5f 	subeq	r4, r5, pc, asr lr
    20d0:	5f617369 	svcpl	0x00617369
    20d4:	5f746962 	svcpl	0x00746962
    20d8:	00386562 	eorseq	r6, r8, r2, ror #10
    20dc:	47524154 			; <UNDEFINED> instruction: 0x47524154
    20e0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    20e4:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    20e8:	31316d72 	teqcc	r1, r2, ror sp
    20ec:	7a6a3637 	bvc	1a8f9d0 <_bss_end+0x1a83e60>
    20f0:	72700073 	rsbsvc	r0, r0, #115	; 0x73
    20f4:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    20f8:	5f726f73 	svcpl	0x00726f73
    20fc:	65707974 	ldrbvs	r7, [r0, #-2420]!	; 0xfffff68c
    2100:	6c6c6100 	stfvse	f6, [ip], #-0
    2104:	7570665f 	ldrbvc	r6, [r0, #-1631]!	; 0xfffff9a1
    2108:	72610073 	rsbvc	r0, r1, #115	; 0x73
    210c:	63705f6d 	cmnvs	r0, #436	; 0x1b4
    2110:	41420073 	hvcmi	8195	; 0x2003
    2114:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    2118:	5f484352 	svcpl	0x00484352
    211c:	61005435 	tstvs	r0, r5, lsr r4
    2120:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2124:	34686372 	strbtcc	r6, [r8], #-882	; 0xfffffc8e
    2128:	41540074 	cmpmi	r4, r4, ror r0
    212c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2130:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2134:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2138:	61786574 	cmnvs	r8, r4, ror r5
    213c:	6f633637 	svcvs	0x00633637
    2140:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2144:	00353561 	eorseq	r3, r5, r1, ror #10
    2148:	5f6d7261 	svcpl	0x006d7261
    214c:	656e7574 	strbvs	r7, [lr, #-1396]!	; 0xfffffa8c
    2150:	7562775f 	strbvc	r7, [r2, #-1887]!	; 0xfffff8a1
    2154:	74680066 	strbtvc	r0, [r8], #-102	; 0xffffff9a
    2158:	685f6261 	ldmdavs	pc, {r0, r5, r6, r9, sp, lr}^	; <UNPREDICTABLE>
    215c:	00687361 	rsbeq	r7, r8, r1, ror #6
    2160:	5f617369 	svcpl	0x00617369
    2164:	5f746962 	svcpl	0x00746962
    2168:	72697571 	rsbvc	r7, r9, #473956352	; 0x1c400000
    216c:	6f6e5f6b 	svcvs	0x006e5f6b
    2170:	6c6f765f 	stclvs	6, cr7, [pc], #-380	; 1ffc <CPSR_IRQ_INHIBIT+0x1f7c>
    2174:	6c697461 	cfstrdvs	mvd7, [r9], #-388	; 0xfffffe7c
    2178:	65635f65 	strbvs	r5, [r3, #-3941]!	; 0xfffff09b
    217c:	52415400 	subpl	r5, r1, #0, 8
    2180:	5f544547 	svcpl	0x00544547
    2184:	5f555043 	svcpl	0x00555043
    2188:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    218c:	306d7865 	rsbcc	r7, sp, r5, ror #16
    2190:	52415400 	subpl	r5, r1, #0, 8
    2194:	5f544547 	svcpl	0x00544547
    2198:	5f555043 	svcpl	0x00555043
    219c:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    21a0:	316d7865 	cmncc	sp, r5, ror #16
    21a4:	52415400 	subpl	r5, r1, #0, 8
    21a8:	5f544547 	svcpl	0x00544547
    21ac:	5f555043 	svcpl	0x00555043
    21b0:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    21b4:	336d7865 	cmncc	sp, #6619136	; 0x650000
    21b8:	61736900 	cmnvs	r3, r0, lsl #18
    21bc:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    21c0:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    21c4:	315f3876 	cmpcc	pc, r6, ror r8	; <UNPREDICTABLE>
    21c8:	6d726100 	ldfvse	f6, [r2, #-0]
    21cc:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    21d0:	616e5f68 	cmnvs	lr, r8, ror #30
    21d4:	6900656d 	stmdbvs	r0, {r0, r2, r3, r5, r6, r8, sl, sp, lr}
    21d8:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    21dc:	615f7469 	cmpvs	pc, r9, ror #8
    21e0:	38766d72 	ldmdacc	r6!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^
    21e4:	6900335f 	stmdbvs	r0, {r0, r1, r2, r3, r4, r6, r8, r9, ip, sp}
    21e8:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    21ec:	615f7469 	cmpvs	pc, r9, ror #8
    21f0:	38766d72 	ldmdacc	r6!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^
    21f4:	6900345f 	stmdbvs	r0, {r0, r1, r2, r3, r4, r6, sl, ip, sp}
    21f8:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    21fc:	615f7469 	cmpvs	pc, r9, ror #8
    2200:	38766d72 	ldmdacc	r6!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^
    2204:	5400355f 	strpl	r3, [r0], #-1375	; 0xfffffaa1
    2208:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    220c:	50435f54 	subpl	r5, r3, r4, asr pc
    2210:	6f635f55 	svcvs	0x00635f55
    2214:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2218:	00333561 	eorseq	r3, r3, r1, ror #10
    221c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2220:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2224:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2228:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    222c:	35356178 	ldrcc	r6, [r5, #-376]!	; 0xfffffe88
    2230:	52415400 	subpl	r5, r1, #0, 8
    2234:	5f544547 	svcpl	0x00544547
    2238:	5f555043 	svcpl	0x00555043
    223c:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2240:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    2244:	41540037 	cmpmi	r4, r7, lsr r0
    2248:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    224c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2250:	63706d5f 	cmnvs	r0, #6080	; 0x17c0
    2254:	0065726f 	rsbeq	r7, r5, pc, ror #4
    2258:	47524154 			; <UNDEFINED> instruction: 0x47524154
    225c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2260:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    2264:	6e5f6d72 	mrcvs	13, 2, r6, cr15, cr2, {3}
    2268:	00656e6f 	rsbeq	r6, r5, pc, ror #28
    226c:	5f6d7261 	svcpl	0x006d7261
    2270:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    2274:	746f6e5f 	strbtvc	r6, [pc], #-3679	; 227c <CPSR_IRQ_INHIBIT+0x21fc>
    2278:	4154006d 	cmpmi	r4, sp, rrx
    227c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2280:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2284:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2288:	36323031 			; <UNDEFINED> instruction: 0x36323031
    228c:	00736a65 	rsbseq	r6, r3, r5, ror #20
    2290:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    2294:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    2298:	4a365f48 	bmi	d99fc0 <_bss_end+0xd8e450>
    229c:	53414200 	movtpl	r4, #4608	; 0x1200
    22a0:	52415f45 	subpl	r5, r1, #276	; 0x114
    22a4:	365f4843 	ldrbcc	r4, [pc], -r3, asr #16
    22a8:	4142004b 	cmpmi	r2, fp, asr #32
    22ac:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    22b0:	5f484352 	svcpl	0x00484352
    22b4:	69004d36 	stmdbvs	r0, {r1, r2, r4, r5, r8, sl, fp, lr}
    22b8:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    22bc:	695f7469 	ldmdbvs	pc, {r0, r3, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    22c0:	786d6d77 	stmdavc	sp!, {r0, r1, r2, r4, r5, r6, r8, sl, fp, sp, lr}^
    22c4:	41540074 	cmpmi	r4, r4, ror r0
    22c8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    22cc:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    22d0:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    22d4:	36333131 			; <UNDEFINED> instruction: 0x36333131
    22d8:	0073666a 	rsbseq	r6, r3, sl, ror #12
    22dc:	5f4d5241 	svcpl	0x004d5241
    22e0:	4100534c 	tstmi	r0, ip, asr #6
    22e4:	4c5f4d52 	mrrcmi	13, 5, r4, pc, cr2	; <UNPREDICTABLE>
    22e8:	41420054 	qdaddmi	r0, r4, r2
    22ec:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    22f0:	5f484352 	svcpl	0x00484352
    22f4:	54005a36 	strpl	r5, [r0], #-2614	; 0xfffff5ca
    22f8:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    22fc:	50435f54 	subpl	r5, r3, r4, asr pc
    2300:	6f635f55 	svcvs	0x00635f55
    2304:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2308:	63353761 	teqvs	r5, #25427968	; 0x1840000
    230c:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2310:	35356178 	ldrcc	r6, [r5, #-376]!	; 0xfffffe88
    2314:	4d524100 	ldfmie	f4, [r2, #-0]
    2318:	5343505f 	movtpl	r5, #12383	; 0x305f
    231c:	5041415f 	subpl	r4, r1, pc, asr r1
    2320:	565f5343 	ldrbpl	r5, [pc], -r3, asr #6
    2324:	54005046 	strpl	r5, [r0], #-70	; 0xffffffba
    2328:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    232c:	50435f54 	subpl	r5, r3, r4, asr pc
    2330:	77695f55 			; <UNDEFINED> instruction: 0x77695f55
    2334:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
    2338:	73690032 	cmnvc	r9, #50	; 0x32
    233c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2340:	656e5f74 	strbvs	r5, [lr, #-3956]!	; 0xfffff08c
    2344:	61006e6f 	tstvs	r0, pc, ror #28
    2348:	665f6d72 			; <UNDEFINED> instruction: 0x665f6d72
    234c:	615f7570 	cmpvs	pc, r0, ror r5	; <UNPREDICTABLE>
    2350:	00727474 	rsbseq	r7, r2, r4, ror r4
    2354:	5f617369 	svcpl	0x00617369
    2358:	5f746962 	svcpl	0x00746962
    235c:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    2360:	006d6537 	rsbeq	r6, sp, r7, lsr r5
    2364:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2368:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    236c:	665f5550 			; <UNDEFINED> instruction: 0x665f5550
    2370:	36323661 	ldrtcc	r3, [r2], -r1, ror #12
    2374:	54006574 	strpl	r6, [r0], #-1396	; 0xfffffa8c
    2378:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    237c:	50435f54 	subpl	r5, r3, r4, asr pc
    2380:	616d5f55 	cmnvs	sp, r5, asr pc
    2384:	6c657672 	stclvs	6, cr7, [r5], #-456	; 0xfffffe38
    2388:	6a705f6c 	bvs	1c1a140 <_bss_end+0x1c0e5d0>
    238c:	74680034 	strbtvc	r0, [r8], #-52	; 0xffffffcc
    2390:	685f6261 	ldmdavs	pc, {r0, r5, r6, r9, sp, lr}^	; <UNPREDICTABLE>
    2394:	5f687361 	svcpl	0x00687361
    2398:	6e696f70 	mcrvs	15, 3, r6, cr9, cr0, {3}
    239c:	00726574 	rsbseq	r6, r2, r4, ror r5
    23a0:	5f6d7261 	svcpl	0x006d7261
    23a4:	656e7574 	strbvs	r7, [lr, #-1396]!	; 0xfffffa8c
    23a8:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    23ac:	5f786574 	svcpl	0x00786574
    23b0:	69003961 	stmdbvs	r0, {r0, r5, r6, r8, fp, ip, sp}
    23b4:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    23b8:	695f7469 	ldmdbvs	pc, {r0, r3, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    23bc:	786d6d77 	stmdavc	sp!, {r0, r1, r2, r4, r5, r6, r8, sl, fp, sp, lr}^
    23c0:	54003274 	strpl	r3, [r0], #-628	; 0xfffffd8c
    23c4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    23c8:	50435f54 	subpl	r5, r3, r4, asr pc
    23cc:	6f635f55 	svcvs	0x00635f55
    23d0:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    23d4:	63323761 	teqvs	r2, #25427968	; 0x1840000
    23d8:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    23dc:	33356178 	teqcc	r5, #120, 2
    23e0:	61736900 	cmnvs	r3, r0, lsl #18
    23e4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    23e8:	7568745f 	strbvc	r7, [r8, #-1119]!	; 0xfffffba1
    23ec:	0032626d 	eorseq	r6, r2, sp, ror #4
    23f0:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    23f4:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    23f8:	41375f48 	teqmi	r7, r8, asr #30
    23fc:	61736900 	cmnvs	r3, r0, lsl #18
    2400:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2404:	746f645f 	strbtvc	r6, [pc], #-1119	; 240c <CPSR_IRQ_INHIBIT+0x238c>
    2408:	646f7270 	strbtvs	r7, [pc], #-624	; 2410 <CPSR_IRQ_INHIBIT+0x2390>
    240c:	6d726100 	ldfvse	f6, [r2, #-0]
    2410:	3170665f 	cmncc	r0, pc, asr r6
    2414:	79745f36 	ldmdbvc	r4!, {r1, r2, r4, r5, r8, r9, sl, fp, ip, lr}^
    2418:	6e5f6570 	mrcvs	5, 2, r6, cr15, cr0, {3}
    241c:	0065646f 	rsbeq	r6, r5, pc, ror #8
    2420:	5f4d5241 	svcpl	0x004d5241
    2424:	6100494d 	tstvs	r0, sp, asr #18
    2428:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    242c:	36686372 			; <UNDEFINED> instruction: 0x36686372
    2430:	7261006b 	rsbvc	r0, r1, #107	; 0x6b
    2434:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    2438:	6d366863 	ldcvs	8, cr6, [r6, #-396]!	; 0xfffffe74
    243c:	53414200 	movtpl	r4, #4608	; 0x1200
    2440:	52415f45 	subpl	r5, r1, #276	; 0x114
    2444:	375f4843 	ldrbcc	r4, [pc, -r3, asr #16]
    2448:	5f5f0052 	svcpl	0x005f0052
    244c:	63706f70 	cmnvs	r0, #112, 30	; 0x1c0
    2450:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
    2454:	6261745f 	rsbvs	r7, r1, #1593835520	; 0x5f000000
    2458:	61736900 	cmnvs	r3, r0, lsl #18
    245c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2460:	736d635f 	cmnvc	sp, #2080374785	; 0x7c000001
    2464:	41540065 	cmpmi	r4, r5, rrx
    2468:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    246c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2470:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2474:	61786574 	cmnvs	r8, r4, ror r5
    2478:	54003337 	strpl	r3, [r0], #-823	; 0xfffffcc9
    247c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2480:	50435f54 	subpl	r5, r3, r4, asr pc
    2484:	65675f55 	strbvs	r5, [r7, #-3925]!	; 0xfffff0ab
    2488:	6972656e 	ldmdbvs	r2!, {r1, r2, r3, r5, r6, r8, sl, sp, lr}^
    248c:	61377663 	teqvs	r7, r3, ror #12
    2490:	52415400 	subpl	r5, r1, #0, 8
    2494:	5f544547 	svcpl	0x00544547
    2498:	5f555043 	svcpl	0x00555043
    249c:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    24a0:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    24a4:	72610036 	rsbvc	r0, r1, #54	; 0x36
    24a8:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    24ac:	6e5f6863 	cdpvs	8, 5, cr6, cr15, cr3, {3}
    24b0:	6f765f6f 	svcvs	0x00765f6f
    24b4:	6974616c 	ldmdbvs	r4!, {r2, r3, r5, r6, r8, sp, lr}^
    24b8:	635f656c 	cmpvs	pc, #108, 10	; 0x1b000000
    24bc:	41420065 	cmpmi	r2, r5, rrx
    24c0:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    24c4:	5f484352 	svcpl	0x00484352
    24c8:	69004138 	stmdbvs	r0, {r3, r4, r5, r8, lr}
    24cc:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    24d0:	615f7469 	cmpvs	pc, r9, ror #8
    24d4:	35766d72 	ldrbcc	r6, [r6, #-3442]!	; 0xfffff28e
    24d8:	41420074 	hvcmi	8196	; 0x2004
    24dc:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    24e0:	5f484352 	svcpl	0x00484352
    24e4:	54005238 	strpl	r5, [r0], #-568	; 0xfffffdc8
    24e8:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    24ec:	50435f54 	subpl	r5, r3, r4, asr pc
    24f0:	6f635f55 	svcvs	0x00635f55
    24f4:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    24f8:	63333761 	teqvs	r3, #25427968	; 0x1840000
    24fc:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2500:	35336178 	ldrcc	r6, [r3, #-376]!	; 0xfffffe88
    2504:	4d524100 	ldfmie	f4, [r2, #-0]
    2508:	00564e5f 	subseq	r4, r6, pc, asr lr
    250c:	5f6d7261 	svcpl	0x006d7261
    2510:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    2514:	72610034 	rsbvc	r0, r1, #52	; 0x34
    2518:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    251c:	00366863 	eorseq	r6, r6, r3, ror #16
    2520:	5f6d7261 	svcpl	0x006d7261
    2524:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    2528:	72610037 	rsbvc	r0, r1, #55	; 0x37
    252c:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    2530:	00386863 	eorseq	r6, r8, r3, ror #16
    2534:	676e6f6c 	strbvs	r6, [lr, -ip, ror #30]!
    2538:	756f6420 	strbvc	r6, [pc, #-1056]!	; 2120 <CPSR_IRQ_INHIBIT+0x20a0>
    253c:	00656c62 	rsbeq	r6, r5, r2, ror #24
    2540:	5f6d7261 	svcpl	0x006d7261
    2544:	656e7574 	strbvs	r7, [lr, #-1396]!	; 0xfffffa8c
    2548:	6373785f 	cmnvs	r3, #6225920	; 0x5f0000
    254c:	00656c61 	rsbeq	r6, r5, r1, ror #24
    2550:	696b616d 	stmdbvs	fp!, {r0, r2, r3, r5, r6, r8, sp, lr}^
    2554:	635f676e 	cmpvs	pc, #28835840	; 0x1b80000
    2558:	74736e6f 	ldrbtvc	r6, [r3], #-3695	; 0xfffff191
    255c:	6261745f 	rsbvs	r7, r1, #1593835520	; 0x5f000000
    2560:	7400656c 	strvc	r6, [r0], #-1388	; 0xfffffa94
    2564:	626d7568 	rsbvs	r7, sp, #104, 10	; 0x1a000000
    2568:	6c61635f 	stclvs	3, cr6, [r1], #-380	; 0xfffffe84
    256c:	69765f6c 	ldmdbvs	r6!, {r2, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
    2570:	616c5f61 	cmnvs	ip, r1, ror #30
    2574:	006c6562 	rsbeq	r6, ip, r2, ror #10
    2578:	5f617369 	svcpl	0x00617369
    257c:	5f746962 	svcpl	0x00746962
    2580:	35767066 	ldrbcc	r7, [r6, #-102]!	; 0xffffff9a
    2584:	61736900 	cmnvs	r3, r0, lsl #18
    2588:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    258c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2590:	006b3676 	rsbeq	r3, fp, r6, ror r6
    2594:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2598:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    259c:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    25a0:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    25a4:	00376178 	eorseq	r6, r7, r8, ror r1
    25a8:	47524154 			; <UNDEFINED> instruction: 0x47524154
    25ac:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    25b0:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    25b4:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    25b8:	00386178 	eorseq	r6, r8, r8, ror r1
    25bc:	47524154 			; <UNDEFINED> instruction: 0x47524154
    25c0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    25c4:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    25c8:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    25cc:	00396178 	eorseq	r6, r9, r8, ror r1
    25d0:	5f4d5241 	svcpl	0x004d5241
    25d4:	5f534350 	svcpl	0x00534350
    25d8:	53435041 	movtpl	r5, #12353	; 0x3041
    25dc:	4d524100 	ldfmie	f4, [r2, #-0]
    25e0:	5343505f 	movtpl	r5, #12383	; 0x305f
    25e4:	5054415f 	subspl	r4, r4, pc, asr r1
    25e8:	63005343 	movwvs	r5, #835	; 0x343
    25ec:	6c706d6f 	ldclvs	13, cr6, [r0], #-444	; 0xfffffe44
    25f0:	64207865 	strtvs	r7, [r0], #-2149	; 0xfffff79b
    25f4:	6c62756f 	cfstr64vs	mvdx7, [r2], #-444	; 0xfffffe44
    25f8:	41540065 	cmpmi	r4, r5, rrx
    25fc:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2600:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2604:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2608:	61786574 	cmnvs	r8, r4, ror r5
    260c:	6f633337 	svcvs	0x00633337
    2610:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2614:	00333561 	eorseq	r3, r3, r1, ror #10
    2618:	47524154 			; <UNDEFINED> instruction: 0x47524154
    261c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2620:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2624:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2628:	70306d78 	eorsvc	r6, r0, r8, ror sp
    262c:	0073756c 	rsbseq	r7, r3, ip, ror #10
    2630:	5f6d7261 	svcpl	0x006d7261
    2634:	69006363 	stmdbvs	r0, {r0, r1, r5, r6, r8, r9, sp, lr}
    2638:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    263c:	785f7469 	ldmdavc	pc, {r0, r3, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    2640:	6c616373 	stclvs	3, cr6, [r1], #-460	; 0xfffffe34
    2644:	645f0065 	ldrbvs	r0, [pc], #-101	; 264c <CPSR_IRQ_INHIBIT+0x25cc>
    2648:	5f746e6f 	svcpl	0x00746e6f
    264c:	5f657375 	svcpl	0x00657375
    2650:	65657274 	strbvs	r7, [r5, #-628]!	; 0xfffffd8c
    2654:	7265685f 	rsbvc	r6, r5, #6225920	; 0x5f0000
    2658:	54005f65 	strpl	r5, [r0], #-3941	; 0xfffff09b
    265c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2660:	50435f54 	subpl	r5, r3, r4, asr pc
    2664:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    2668:	7430316d 	ldrtvc	r3, [r0], #-365	; 0xfffffe93
    266c:	00696d64 	rsbeq	r6, r9, r4, ror #26
    2670:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2674:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2678:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    267c:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2680:	00356178 	eorseq	r6, r5, r8, ror r1
    2684:	65736162 	ldrbvs	r6, [r3, #-354]!	; 0xfffffe9e
    2688:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    268c:	65746968 	ldrbvs	r6, [r4, #-2408]!	; 0xfffff698
    2690:	72757463 	rsbsvc	r7, r5, #1660944384	; 0x63000000
    2694:	72610065 	rsbvc	r0, r1, #101	; 0x65
    2698:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    269c:	635f6863 	cmpvs	pc, #6488064	; 0x630000
    26a0:	54006372 	strpl	r6, [r0], #-882	; 0xfffffc8e
    26a4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    26a8:	50435f54 	subpl	r5, r3, r4, asr pc
    26ac:	6f635f55 	svcvs	0x00635f55
    26b0:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    26b4:	6d73316d 	ldfvse	f3, [r3, #-436]!	; 0xfffffe4c
    26b8:	6d6c6c61 	stclvs	12, cr6, [ip, #-388]!	; 0xfffffe7c
    26bc:	69746c75 	ldmdbvs	r4!, {r0, r2, r4, r5, r6, sl, fp, sp, lr}^
    26c0:	00796c70 	rsbseq	r6, r9, r0, ror ip
    26c4:	5f6d7261 	svcpl	0x006d7261
    26c8:	72727563 	rsbsvc	r7, r2, #415236096	; 0x18c00000
    26cc:	5f746e65 	svcpl	0x00746e65
    26d0:	69006363 	stmdbvs	r0, {r0, r1, r5, r6, r8, r9, sp, lr}
    26d4:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    26d8:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    26dc:	32336372 	eorscc	r6, r3, #-939524095	; 0xc8000001
    26e0:	4d524100 	ldfmie	f4, [r2, #-0]
    26e4:	004c505f 	subeq	r5, ip, pc, asr r0
    26e8:	5f617369 	svcpl	0x00617369
    26ec:	5f746962 	svcpl	0x00746962
    26f0:	76706676 			; <UNDEFINED> instruction: 0x76706676
    26f4:	73690033 	cmnvc	r9, #51	; 0x33
    26f8:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    26fc:	66765f74 	uhsub16vs	r5, r6, r4
    2700:	00347670 	eorseq	r7, r4, r0, ror r6
    2704:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    2708:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    270c:	54365f48 	ldrtpl	r5, [r6], #-3912	; 0xfffff0b8
    2710:	41420032 	cmpmi	r2, r2, lsr r0
    2714:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    2718:	5f484352 	svcpl	0x00484352
    271c:	4d5f4d38 	ldclmi	13, cr4, [pc, #-224]	; 2644 <CPSR_IRQ_INHIBIT+0x25c4>
    2720:	004e4941 	subeq	r4, lr, r1, asr #18
    2724:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2728:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    272c:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    2730:	74396d72 	ldrtvc	r6, [r9], #-3442	; 0xfffff28e
    2734:	00696d64 	rsbeq	r6, r9, r4, ror #26
    2738:	5f4d5241 	svcpl	0x004d5241
    273c:	42004c41 	andmi	r4, r0, #16640	; 0x4100
    2740:	5f455341 	svcpl	0x00455341
    2744:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    2748:	004d375f 	subeq	r3, sp, pc, asr r7
    274c:	5f6d7261 	svcpl	0x006d7261
    2750:	67726174 			; <UNDEFINED> instruction: 0x67726174
    2754:	6c5f7465 	cfldrdvs	mvd7, [pc], {101}	; 0x65
    2758:	6c656261 	sfmvs	f6, 2, [r5], #-388	; 0xfffffe7c
    275c:	6d726100 	ldfvse	f6, [r2, #-0]
    2760:	7261745f 	rsbvc	r7, r1, #1593835520	; 0x5f000000
    2764:	5f746567 	svcpl	0x00746567
    2768:	6e736e69 	cdpvs	14, 7, cr6, cr3, cr9, {3}
    276c:	52415400 	subpl	r5, r1, #0, 8
    2770:	5f544547 	svcpl	0x00544547
    2774:	5f555043 	svcpl	0x00555043
    2778:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    277c:	34727865 	ldrbtcc	r7, [r2], #-2149	; 0xfffff79b
    2780:	52415400 	subpl	r5, r1, #0, 8
    2784:	5f544547 	svcpl	0x00544547
    2788:	5f555043 	svcpl	0x00555043
    278c:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2790:	35727865 	ldrbcc	r7, [r2, #-2149]!	; 0xfffff79b
    2794:	52415400 	subpl	r5, r1, #0, 8
    2798:	5f544547 	svcpl	0x00544547
    279c:	5f555043 	svcpl	0x00555043
    27a0:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    27a4:	37727865 	ldrbcc	r7, [r2, -r5, ror #16]!
    27a8:	52415400 	subpl	r5, r1, #0, 8
    27ac:	5f544547 	svcpl	0x00544547
    27b0:	5f555043 	svcpl	0x00555043
    27b4:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    27b8:	38727865 	ldmdacc	r2!, {r0, r2, r5, r6, fp, ip, sp, lr}^
    27bc:	61736900 	cmnvs	r3, r0, lsl #18
    27c0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    27c4:	61706c5f 	cmnvs	r0, pc, asr ip
    27c8:	73690065 	cmnvc	r9, #101	; 0x65
    27cc:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    27d0:	75715f74 	ldrbvc	r5, [r1, #-3956]!	; 0xfffff08c
    27d4:	5f6b7269 	svcpl	0x006b7269
    27d8:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    27dc:	007a6b36 	rsbseq	r6, sl, r6, lsr fp
    27e0:	5f617369 	svcpl	0x00617369
    27e4:	5f746962 	svcpl	0x00746962
    27e8:	6d746f6e 	ldclvs	15, cr6, [r4, #-440]!	; 0xfffffe48
    27ec:	61736900 	cmnvs	r3, r0, lsl #18
    27f0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    27f4:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    27f8:	69003476 	stmdbvs	r0, {r1, r2, r4, r5, r6, sl, ip, sp}
    27fc:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2800:	615f7469 	cmpvs	pc, r9, ror #8
    2804:	36766d72 			; <UNDEFINED> instruction: 0x36766d72
    2808:	61736900 	cmnvs	r3, r0, lsl #18
    280c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2810:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2814:	69003776 	stmdbvs	r0, {r1, r2, r4, r5, r6, r8, r9, sl, ip, sp}
    2818:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    281c:	615f7469 	cmpvs	pc, r9, ror #8
    2820:	38766d72 	ldmdacc	r6!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^
    2824:	6f645f00 	svcvs	0x00645f00
    2828:	755f746e 	ldrbvc	r7, [pc, #-1134]	; 23c2 <CPSR_IRQ_INHIBIT+0x2342>
    282c:	725f6573 	subsvc	r6, pc, #482344960	; 0x1cc00000
    2830:	685f7874 	ldmdavs	pc, {r2, r4, r5, r6, fp, ip, sp, lr}^	; <UNPREDICTABLE>
    2834:	5f657265 	svcpl	0x00657265
    2838:	49515500 	ldmdbmi	r1, {r8, sl, ip, lr}^
    283c:	65707974 	ldrbvs	r7, [r0, #-2420]!	; 0xfffff68c
    2840:	61736900 	cmnvs	r3, r0, lsl #18
    2844:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2848:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    284c:	65743576 	ldrbvs	r3, [r4, #-1398]!	; 0xfffffa8a
    2850:	6d726100 	ldfvse	f6, [r2, #-0]
    2854:	6e75745f 	mrcvs	4, 3, r7, cr5, cr15, {2}
    2858:	72610065 	rsbvc	r0, r1, #101	; 0x65
    285c:	70635f6d 	rsbvc	r5, r3, sp, ror #30
    2860:	6e695f70 	mcrvs	15, 3, r5, cr9, cr0, {3}
    2864:	77726574 			; <UNDEFINED> instruction: 0x77726574
    2868:	006b726f 	rsbeq	r7, fp, pc, ror #4
    286c:	636e7566 	cmnvs	lr, #427819008	; 0x19800000
    2870:	7274705f 	rsbsvc	r7, r4, #95	; 0x5f
    2874:	52415400 	subpl	r5, r1, #0, 8
    2878:	5f544547 	svcpl	0x00544547
    287c:	5f555043 	svcpl	0x00555043
    2880:	396d7261 	stmdbcc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    2884:	00743032 	rsbseq	r3, r4, r2, lsr r0
    2888:	62617468 	rsbvs	r7, r1, #104, 8	; 0x68000000
    288c:	0071655f 	rsbseq	r6, r1, pc, asr r5
    2890:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2894:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2898:	665f5550 			; <UNDEFINED> instruction: 0x665f5550
    289c:	36323561 	ldrtcc	r3, [r2], -r1, ror #10
    28a0:	6d726100 	ldfvse	f6, [r2, #-0]
    28a4:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    28a8:	68745f68 	ldmdavs	r4!, {r3, r5, r6, r8, r9, sl, fp, ip, lr}^
    28ac:	5f626d75 	svcpl	0x00626d75
    28b0:	69647768 	stmdbvs	r4!, {r3, r5, r6, r8, r9, sl, ip, sp, lr}^
    28b4:	74680076 	strbtvc	r0, [r8], #-118	; 0xffffff8a
    28b8:	655f6261 	ldrbvs	r6, [pc, #-609]	; 265f <CPSR_IRQ_INHIBIT+0x25df>
    28bc:	6f705f71 	svcvs	0x00705f71
    28c0:	65746e69 	ldrbvs	r6, [r4, #-3689]!	; 0xfffff197
    28c4:	72610072 	rsbvc	r0, r1, #114	; 0x72
    28c8:	69705f6d 	ldmdbvs	r0!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
    28cc:	65725f63 	ldrbvs	r5, [r2, #-3939]!	; 0xfffff09d
    28d0:	74736967 	ldrbtvc	r6, [r3], #-2407	; 0xfffff699
    28d4:	54007265 	strpl	r7, [r0], #-613	; 0xfffffd9b
    28d8:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    28dc:	50435f54 	subpl	r5, r3, r4, asr pc
    28e0:	6f635f55 	svcvs	0x00635f55
    28e4:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    28e8:	6d73306d 	ldclvs	0, cr3, [r3, #-436]!	; 0xfffffe4c
    28ec:	6d6c6c61 	stclvs	12, cr6, [ip, #-388]!	; 0xfffffe7c
    28f0:	69746c75 	ldmdbvs	r4!, {r0, r2, r4, r5, r6, sl, fp, sp, lr}^
    28f4:	00796c70 	rsbseq	r6, r9, r0, ror ip
    28f8:	47524154 			; <UNDEFINED> instruction: 0x47524154
    28fc:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2900:	6d5f5550 	cfldr64vs	mvdx5, [pc, #-320]	; 27c8 <CPSR_IRQ_INHIBIT+0x2748>
    2904:	726f6370 	rsbvc	r6, pc, #112, 6	; 0xc0000001
    2908:	766f6e65 	strbtvc	r6, [pc], -r5, ror #28
    290c:	69007066 	stmdbvs	r0, {r1, r2, r5, r6, ip, sp, lr}
    2910:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2914:	715f7469 	cmpvc	pc, r9, ror #8
    2918:	6b726975 	blvs	1c9cef4 <_bss_end+0x1c91384>
    291c:	336d635f 	cmncc	sp, #2080374785	; 0x7c000001
    2920:	72646c5f 	rsbvc	r6, r4, #24320	; 0x5f00
    2924:	52410064 	subpl	r0, r1, #100	; 0x64
    2928:	43435f4d 	movtmi	r5, #16205	; 0x3f4d
    292c:	6d726100 	ldfvse	f6, [r2, #-0]
    2930:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    2934:	325f3868 	subscc	r3, pc, #104, 16	; 0x680000
    2938:	6d726100 	ldfvse	f6, [r2, #-0]
    293c:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    2940:	335f3868 	cmpcc	pc, #104, 16	; 0x680000
    2944:	6d726100 	ldfvse	f6, [r2, #-0]
    2948:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    294c:	345f3868 	ldrbcc	r3, [pc], #-2152	; 2954 <CPSR_IRQ_INHIBIT+0x28d4>
    2950:	52415400 	subpl	r5, r1, #0, 8
    2954:	5f544547 	svcpl	0x00544547
    2958:	5f555043 	svcpl	0x00555043
    295c:	36706d66 	ldrbtcc	r6, [r0], -r6, ror #26
    2960:	41003632 	tstmi	r0, r2, lsr r6
    2964:	435f4d52 	cmpmi	pc, #5248	; 0x1480
    2968:	72610053 	rsbvc	r0, r1, #83	; 0x53
    296c:	70665f6d 	rsbvc	r5, r6, sp, ror #30
    2970:	695f3631 	ldmdbvs	pc, {r0, r4, r5, r9, sl, ip, sp}^	; <UNPREDICTABLE>
    2974:	0074736e 	rsbseq	r7, r4, lr, ror #6
    2978:	5f6d7261 	svcpl	0x006d7261
    297c:	65736162 	ldrbvs	r6, [r3, #-354]!	; 0xfffffe9e
    2980:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    2984:	41540068 	cmpmi	r4, r8, rrx
    2988:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    298c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2990:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2994:	61786574 	cmnvs	r8, r4, ror r5
    2998:	6f633531 	svcvs	0x00633531
    299c:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    29a0:	61003761 	tstvs	r0, r1, ror #14
    29a4:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    29a8:	37686372 			; <UNDEFINED> instruction: 0x37686372
    29ac:	54006d65 	strpl	r6, [r0], #-3429	; 0xfffff29b
    29b0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    29b4:	50435f54 	subpl	r5, r3, r4, asr pc
    29b8:	6f635f55 	svcvs	0x00635f55
    29bc:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    29c0:	00323761 	eorseq	r3, r2, r1, ror #14
    29c4:	5f6d7261 	svcpl	0x006d7261
    29c8:	5f736370 	svcpl	0x00736370
    29cc:	61666564 	cmnvs	r6, r4, ror #10
    29d0:	00746c75 	rsbseq	r6, r4, r5, ror ip
    29d4:	5f4d5241 	svcpl	0x004d5241
    29d8:	5f534350 	svcpl	0x00534350
    29dc:	43504141 	cmpmi	r0, #1073741840	; 0x40000010
    29e0:	4f4c5f53 	svcmi	0x004c5f53
    29e4:	004c4143 	subeq	r4, ip, r3, asr #2
    29e8:	47524154 			; <UNDEFINED> instruction: 0x47524154
    29ec:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    29f0:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    29f4:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    29f8:	35376178 	ldrcc	r6, [r7, #-376]!	; 0xfffffe88
    29fc:	52415400 	subpl	r5, r1, #0, 8
    2a00:	5f544547 	svcpl	0x00544547
    2a04:	5f555043 	svcpl	0x00555043
    2a08:	6f727473 	svcvs	0x00727473
    2a0c:	7261676e 	rsbvc	r6, r1, #28835840	; 0x1b80000
    2a10:	7261006d 	rsbvc	r0, r1, #109	; 0x6d
    2a14:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    2a18:	745f6863 	ldrbvc	r6, [pc], #-2147	; 2a20 <CPSR_IRQ_INHIBIT+0x29a0>
    2a1c:	626d7568 	rsbvs	r7, sp, #104, 10	; 0x1a000000
    2a20:	72610031 	rsbvc	r0, r1, #49	; 0x31
    2a24:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    2a28:	745f6863 	ldrbvc	r6, [pc], #-2147	; 2a30 <CPSR_IRQ_INHIBIT+0x29b0>
    2a2c:	626d7568 	rsbvs	r7, sp, #104, 10	; 0x1a000000
    2a30:	41540032 	cmpmi	r4, r2, lsr r0
    2a34:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2a38:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2a3c:	6d77695f 			; <UNDEFINED> instruction: 0x6d77695f
    2a40:	0074786d 	rsbseq	r7, r4, sp, ror #16
    2a44:	5f6d7261 	svcpl	0x006d7261
    2a48:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    2a4c:	69007435 	stmdbvs	r0, {r0, r2, r4, r5, sl, ip, sp, lr}
    2a50:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2a54:	6d5f7469 	cfldrdvs	mvd7, [pc, #-420]	; 28b8 <CPSR_IRQ_INHIBIT+0x2838>
    2a58:	72610070 	rsbvc	r0, r1, #112	; 0x70
    2a5c:	646c5f6d 	strbtvs	r5, [ip], #-3949	; 0xfffff093
    2a60:	6863735f 	stmdavs	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, sp, lr}^
    2a64:	61006465 	tstvs	r0, r5, ror #8
    2a68:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2a6c:	38686372 	stmdacc	r8!, {r1, r4, r5, r6, r8, r9, sp, lr}^
    2a70:	Address 0x0000000000002a70 is out of bounds.


Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347 	bcc	10d0d24 <_bss_end+0x10c51b4>
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
  10:	4b5a3605 	blmi	168d82c <_bss_end+0x1681cbc>
  14:	08070600 	stmdaeq	r7, {r9, sl}
  18:	0a010901 	beq	42424 <_bss_end+0x368b4>
  1c:	14041202 	strne	r1, [r4], #-514	; 0xfffffdfe
  20:	17011501 	strne	r1, [r1, -r1, lsl #10]
  24:	1a011803 	bne	46038 <_bss_end+0x3a4c8>
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
  20:	8b040e42 	blhi	103930 <_bss_end+0xf7dc0>
  24:	0b0d4201 	bleq	350830 <_bss_end+0x344cc0>
  28:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
  2c:	00000ecb 	andeq	r0, r0, fp, asr #29
  30:	0000001c 	andeq	r0, r0, ip, lsl r0
  34:	00000000 	andeq	r0, r0, r0
  38:	000080e4 	andeq	r8, r0, r4, ror #1
  3c:	0000002c 	andeq	r0, r0, ip, lsr #32
  40:	8b040e42 	blhi	103950 <_bss_end+0xf7de0>
  44:	0b0d4201 	bleq	350850 <_bss_end+0x344ce0>
  48:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
  4c:	00000ecb 	andeq	r0, r0, fp, asr #29
  50:	0000001c 	andeq	r0, r0, ip, lsl r0
  54:	00000000 	andeq	r0, r0, r0
  58:	00008110 	andeq	r8, r0, r0, lsl r1
  5c:	00000020 	andeq	r0, r0, r0, lsr #32
  60:	8b040e42 	blhi	103970 <_bss_end+0xf7e00>
  64:	0b0d4201 	bleq	350870 <_bss_end+0x344d00>
  68:	420d0d48 	andmi	r0, sp, #72, 26	; 0x1200
  6c:	00000ecb 	andeq	r0, r0, fp, asr #29
  70:	0000001c 	andeq	r0, r0, ip, lsl r0
  74:	00000000 	andeq	r0, r0, r0
  78:	00008130 	andeq	r8, r0, r0, lsr r1
  7c:	00000018 	andeq	r0, r0, r8, lsl r0
  80:	8b040e42 	blhi	103990 <_bss_end+0xf7e20>
  84:	0b0d4201 	bleq	350890 <_bss_end+0x344d20>
  88:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  8c:	00000ecb 	andeq	r0, r0, fp, asr #29
  90:	0000001c 	andeq	r0, r0, ip, lsl r0
  94:	00000000 	andeq	r0, r0, r0
  98:	00008148 	andeq	r8, r0, r8, asr #2
  9c:	00000018 	andeq	r0, r0, r8, lsl r0
  a0:	8b040e42 	blhi	1039b0 <_bss_end+0xf7e40>
  a4:	0b0d4201 	bleq	3508b0 <_bss_end+0x344d40>
  a8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  ac:	00000ecb 	andeq	r0, r0, fp, asr #29
  b0:	0000001c 	andeq	r0, r0, ip, lsl r0
  b4:	00000000 	andeq	r0, r0, r0
  b8:	00008160 	andeq	r8, r0, r0, ror #2
  bc:	00000018 	andeq	r0, r0, r8, lsl r0
  c0:	8b040e42 	blhi	1039d0 <_bss_end+0xf7e60>
  c4:	0b0d4201 	bleq	3508d0 <_bss_end+0x344d60>
  c8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  cc:	00000ecb 	andeq	r0, r0, fp, asr #29
  d0:	00000014 	andeq	r0, r0, r4, lsl r0
  d4:	00000000 	andeq	r0, r0, r0
  d8:	00008178 	andeq	r8, r0, r8, ror r1
  dc:	0000000c 	andeq	r0, r0, ip
  e0:	8b040e42 	blhi	1039f0 <_bss_end+0xf7e80>
  e4:	0b0d4201 	bleq	3508f0 <_bss_end+0x344d80>
  e8:	0000000c 	andeq	r0, r0, ip
  ec:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  f0:	7c020001 	stcvc	0, cr0, [r2], {1}
  f4:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  f8:	0000001c 	andeq	r0, r0, ip, lsl r0
  fc:	000000e8 	andeq	r0, r0, r8, ror #1
 100:	00008184 	andeq	r8, r0, r4, lsl #3
 104:	00000034 	andeq	r0, r0, r4, lsr r0
 108:	8b040e42 	blhi	103a18 <_bss_end+0xf7ea8>
 10c:	0b0d4201 	bleq	350918 <_bss_end+0x344da8>
 110:	420d0d52 	andmi	r0, sp, #5248	; 0x1480
 114:	00000ecb 	andeq	r0, r0, fp, asr #29
 118:	0000001c 	andeq	r0, r0, ip, lsl r0
 11c:	000000e8 	andeq	r0, r0, r8, ror #1
 120:	000081b8 			; <UNDEFINED> instruction: 0x000081b8
 124:	00000098 	muleq	r0, r8, r0
 128:	8b040e42 	blhi	103a38 <_bss_end+0xf7ec8>
 12c:	0b0d4201 	bleq	350938 <_bss_end+0x344dc8>
 130:	0d0d4202 	sfmeq	f4, 4, [sp, #-8]
 134:	000ecb42 	andeq	ip, lr, r2, asr #22
 138:	0000001c 	andeq	r0, r0, ip, lsl r0
 13c:	000000e8 	andeq	r0, r0, r8, ror #1
 140:	00008250 	andeq	r8, r0, r0, asr r2
 144:	00000074 	andeq	r0, r0, r4, ror r0
 148:	8b040e42 	blhi	103a58 <_bss_end+0xf7ee8>
 14c:	0b0d4201 	bleq	350958 <_bss_end+0x344de8>
 150:	420d0d72 	andmi	r0, sp, #7296	; 0x1c80
 154:	00000ecb 	andeq	r0, r0, fp, asr #29
 158:	0000001c 	andeq	r0, r0, ip, lsl r0
 15c:	000000e8 	andeq	r0, r0, r8, ror #1
 160:	000082c4 	andeq	r8, r0, r4, asr #5
 164:	00000074 	andeq	r0, r0, r4, ror r0
 168:	8b040e42 	blhi	103a78 <_bss_end+0xf7f08>
 16c:	0b0d4201 	bleq	350978 <_bss_end+0x344e08>
 170:	420d0d72 	andmi	r0, sp, #7296	; 0x1c80
 174:	00000ecb 	andeq	r0, r0, fp, asr #29
 178:	0000001c 	andeq	r0, r0, ip, lsl r0
 17c:	000000e8 	andeq	r0, r0, r8, ror #1
 180:	00008338 	andeq	r8, r0, r8, lsr r3
 184:	00000074 	andeq	r0, r0, r4, ror r0
 188:	8b040e42 	blhi	103a98 <_bss_end+0xf7f28>
 18c:	0b0d4201 	bleq	350998 <_bss_end+0x344e28>
 190:	420d0d72 	andmi	r0, sp, #7296	; 0x1c80
 194:	00000ecb 	andeq	r0, r0, fp, asr #29
 198:	0000001c 	andeq	r0, r0, ip, lsl r0
 19c:	000000e8 	andeq	r0, r0, r8, ror #1
 1a0:	000083ac 	andeq	r8, r0, ip, lsr #7
 1a4:	000000c8 	andeq	r0, r0, r8, asr #1
 1a8:	8b080e42 	blhi	203ab8 <_bss_end+0x1f7f48>
 1ac:	42018e02 	andmi	r8, r1, #2, 28
 1b0:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 1b4:	080d0c5e 	stmdaeq	sp, {r1, r2, r3, r4, r6, sl, fp}
 1b8:	0000001c 	andeq	r0, r0, ip, lsl r0
 1bc:	000000e8 	andeq	r0, r0, r8, ror #1
 1c0:	00008474 	andeq	r8, r0, r4, ror r4
 1c4:	00000074 	andeq	r0, r0, r4, ror r0
 1c8:	8b080e42 	blhi	203ad8 <_bss_end+0x1f7f68>
 1cc:	42018e02 	andmi	r8, r1, #2, 28
 1d0:	74040b0c 	strvc	r0, [r4], #-2828	; 0xfffff4f4
 1d4:	00080d0c 	andeq	r0, r8, ip, lsl #26
 1d8:	0000001c 	andeq	r0, r0, ip, lsl r0
 1dc:	000000e8 	andeq	r0, r0, r8, ror #1
 1e0:	000084e8 	andeq	r8, r0, r8, ror #9
 1e4:	000000d8 	ldrdeq	r0, [r0], -r8
 1e8:	8b080e42 	blhi	203af8 <_bss_end+0x1f7f88>
 1ec:	42018e02 	andmi	r8, r1, #2, 28
 1f0:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 1f4:	080d0c66 	stmdaeq	sp, {r1, r2, r5, r6, sl, fp}
 1f8:	0000001c 	andeq	r0, r0, ip, lsl r0
 1fc:	000000e8 	andeq	r0, r0, r8, ror #1
 200:	000085c0 	andeq	r8, r0, r0, asr #11
 204:	00000084 	andeq	r0, r0, r4, lsl #1
 208:	8b080e42 	blhi	203b18 <_bss_end+0x1f7fa8>
 20c:	42018e02 	andmi	r8, r1, #2, 28
 210:	7c040b0c 			; <UNDEFINED> instruction: 0x7c040b0c
 214:	00080d0c 	andeq	r0, r8, ip, lsl #26
 218:	0000001c 	andeq	r0, r0, ip, lsl r0
 21c:	000000e8 	andeq	r0, r0, r8, ror #1
 220:	00008644 	andeq	r8, r0, r4, asr #12
 224:	00000054 	andeq	r0, r0, r4, asr r0
 228:	8b080e42 	blhi	203b38 <_bss_end+0x1f7fc8>
 22c:	42018e02 	andmi	r8, r1, #2, 28
 230:	5e040b0c 	vmlapl.f64	d0, d4, d12
 234:	00080d0c 	andeq	r0, r8, ip, lsl #26
 238:	00000018 	andeq	r0, r0, r8, lsl r0
 23c:	000000e8 	andeq	r0, r0, r8, ror #1
 240:	00008698 	muleq	r0, r8, r6
 244:	0000001c 	andeq	r0, r0, ip, lsl r0
 248:	8b080e42 	blhi	203b58 <_bss_end+0x1f7fe8>
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
 274:	8b040e42 	blhi	103b84 <_bss_end+0xf8014>
 278:	0b0d4201 	bleq	350a84 <_bss_end+0x344f14>
 27c:	420d0d74 	andmi	r0, sp, #116, 26	; 0x1d00
 280:	00000ecb 	andeq	r0, r0, fp, asr #29
 284:	0000001c 	andeq	r0, r0, ip, lsl r0
 288:	00000254 	andeq	r0, r0, r4, asr r2
 28c:	00008cfc 	strdeq	r8, [r0], -ip
 290:	00000038 	andeq	r0, r0, r8, lsr r0
 294:	8b040e42 	blhi	103ba4 <_bss_end+0xf8034>
 298:	0b0d4201 	bleq	350aa4 <_bss_end+0x344f34>
 29c:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
 2a0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2a4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2a8:	00000254 	andeq	r0, r0, r4, asr r2
 2ac:	0000872c 	andeq	r8, r0, ip, lsr #14
 2b0:	000000a8 	andeq	r0, r0, r8, lsr #1
 2b4:	8b080e42 	blhi	203bc4 <_bss_end+0x1f8054>
 2b8:	42018e02 	andmi	r8, r1, #2, 28
 2bc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 2c0:	080d0c4e 	stmdaeq	sp, {r1, r2, r3, r6, sl, fp}
 2c4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2c8:	00000254 	andeq	r0, r0, r4, asr r2
 2cc:	00008d34 	andeq	r8, r0, r4, lsr sp
 2d0:	00000088 	andeq	r0, r0, r8, lsl #1
 2d4:	8b080e42 	blhi	203be4 <_bss_end+0x1f8074>
 2d8:	42018e02 	andmi	r8, r1, #2, 28
 2dc:	7e040b0c 	vmlavc.f64	d0, d4, d12
 2e0:	00080d0c 	andeq	r0, r8, ip, lsl #26
 2e4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2e8:	00000254 	andeq	r0, r0, r4, asr r2
 2ec:	000087d4 	ldrdeq	r8, [r0], -r4
 2f0:	00000130 	andeq	r0, r0, r0, lsr r1
 2f4:	8b040e42 	blhi	103c04 <_bss_end+0xf8094>
 2f8:	0b0d4201 	bleq	350b04 <_bss_end+0x344f94>
 2fc:	0d0d9002 	stceq	0, cr9, [sp, #-8]
 300:	000ecb42 	andeq	ip, lr, r2, asr #22
 304:	0000001c 	andeq	r0, r0, ip, lsl r0
 308:	00000254 	andeq	r0, r0, r4, asr r2
 30c:	00008dbc 			; <UNDEFINED> instruction: 0x00008dbc
 310:	0000002c 	andeq	r0, r0, ip, lsr #32
 314:	8b040e42 	blhi	103c24 <_bss_end+0xf80b4>
 318:	0b0d4201 	bleq	350b24 <_bss_end+0x344fb4>
 31c:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 320:	00000ecb 	andeq	r0, r0, fp, asr #29
 324:	0000001c 	andeq	r0, r0, ip, lsl r0
 328:	00000254 	andeq	r0, r0, r4, asr r2
 32c:	00008904 	andeq	r8, r0, r4, lsl #18
 330:	000000a8 	andeq	r0, r0, r8, lsr #1
 334:	8b080e42 	blhi	203c44 <_bss_end+0x1f80d4>
 338:	42018e02 	andmi	r8, r1, #2, 28
 33c:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 340:	080d0c4e 	stmdaeq	sp, {r1, r2, r3, r6, sl, fp}
 344:	0000001c 	andeq	r0, r0, ip, lsl r0
 348:	00000254 	andeq	r0, r0, r4, asr r2
 34c:	000089ac 	andeq	r8, r0, ip, lsr #19
 350:	00000078 	andeq	r0, r0, r8, ror r0
 354:	8b080e42 	blhi	203c64 <_bss_end+0x1f80f4>
 358:	42018e02 	andmi	r8, r1, #2, 28
 35c:	76040b0c 	strvc	r0, [r4], -ip, lsl #22
 360:	00080d0c 	andeq	r0, r8, ip, lsl #26
 364:	0000001c 	andeq	r0, r0, ip, lsl r0
 368:	00000254 	andeq	r0, r0, r4, asr r2
 36c:	00008a24 	andeq	r8, r0, r4, lsr #20
 370:	00000034 	andeq	r0, r0, r4, lsr r0
 374:	8b040e42 	blhi	103c84 <_bss_end+0xf8114>
 378:	0b0d4201 	bleq	350b84 <_bss_end+0x345014>
 37c:	420d0d52 	andmi	r0, sp, #5248	; 0x1480
 380:	00000ecb 	andeq	r0, r0, fp, asr #29
 384:	0000001c 	andeq	r0, r0, ip, lsl r0
 388:	00000254 	andeq	r0, r0, r4, asr r2
 38c:	00008a58 	andeq	r8, r0, r8, asr sl
 390:	00000054 	andeq	r0, r0, r4, asr r0
 394:	8b080e42 	blhi	203ca4 <_bss_end+0x1f8134>
 398:	42018e02 	andmi	r8, r1, #2, 28
 39c:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 3a0:	00080d0c 	andeq	r0, r8, ip, lsl #26
 3a4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3a8:	00000254 	andeq	r0, r0, r4, asr r2
 3ac:	00008aac 	andeq	r8, r0, ip, lsr #21
 3b0:	00000060 	andeq	r0, r0, r0, rrx
 3b4:	8b080e42 	blhi	203cc4 <_bss_end+0x1f8154>
 3b8:	42018e02 	andmi	r8, r1, #2, 28
 3bc:	66040b0c 	strvs	r0, [r4], -ip, lsl #22
 3c0:	00080d0c 	andeq	r0, r8, ip, lsl #26
 3c4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3c8:	00000254 	andeq	r0, r0, r4, asr r2
 3cc:	00008b0c 	andeq	r8, r0, ip, lsl #22
 3d0:	0000017c 	andeq	r0, r0, ip, ror r1
 3d4:	8b080e42 	blhi	203ce4 <_bss_end+0x1f8174>
 3d8:	42018e02 	andmi	r8, r1, #2, 28
 3dc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 3e0:	080d0cb6 	stmdaeq	sp, {r1, r2, r4, r5, r7, sl, fp}
 3e4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3e8:	00000254 	andeq	r0, r0, r4, asr r2
 3ec:	00008c88 	andeq	r8, r0, r8, lsl #25
 3f0:	00000058 	andeq	r0, r0, r8, asr r0
 3f4:	8b080e42 	blhi	203d04 <_bss_end+0x1f8194>
 3f8:	42018e02 	andmi	r8, r1, #2, 28
 3fc:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 400:	00080d0c 	andeq	r0, r8, ip, lsl #26
 404:	00000018 	andeq	r0, r0, r8, lsl r0
 408:	00000254 	andeq	r0, r0, r4, asr r2
 40c:	00008ce0 	andeq	r8, r0, r0, ror #25
 410:	0000001c 	andeq	r0, r0, ip, lsl r0
 414:	8b080e42 	blhi	203d24 <_bss_end+0x1f81b4>
 418:	42018e02 	andmi	r8, r1, #2, 28
 41c:	00040b0c 	andeq	r0, r4, ip, lsl #22
 420:	0000000c 	andeq	r0, r0, ip
 424:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 428:	7c020001 	stcvc	0, cr0, [r2], {1}
 42c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 430:	0000001c 	andeq	r0, r0, ip, lsl r0
 434:	00000420 	andeq	r0, r0, r0, lsr #8
 438:	00008de8 	andeq	r8, r0, r8, ror #27
 43c:	00000040 	andeq	r0, r0, r0, asr #32
 440:	8b040e42 	blhi	103d50 <_bss_end+0xf81e0>
 444:	0b0d4201 	bleq	350c50 <_bss_end+0x3450e0>
 448:	420d0d58 	andmi	r0, sp, #88, 26	; 0x1600
 44c:	00000ecb 	andeq	r0, r0, fp, asr #29
 450:	0000001c 	andeq	r0, r0, ip, lsl r0
 454:	00000420 	andeq	r0, r0, r0, lsr #8
 458:	00008e28 	andeq	r8, r0, r8, lsr #28
 45c:	00000038 	andeq	r0, r0, r8, lsr r0
 460:	8b040e42 	blhi	103d70 <_bss_end+0xf8200>
 464:	0b0d4201 	bleq	350c70 <_bss_end+0x345100>
 468:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
 46c:	00000ecb 	andeq	r0, r0, fp, asr #29
 470:	00000020 	andeq	r0, r0, r0, lsr #32
 474:	00000420 	andeq	r0, r0, r0, lsr #8
 478:	00008e60 	andeq	r8, r0, r0, ror #28
 47c:	000000cc 	andeq	r0, r0, ip, asr #1
 480:	840c0e42 	strhi	r0, [ip], #-3650	; 0xfffff1be
 484:	8e028b03 	vmlahi.f64	d8, d2, d3
 488:	0b0c4201 	bleq	310c94 <_bss_end+0x305124>
 48c:	0c600204 	sfmeq	f0, 2, [r0], #-16
 490:	00000c0d 	andeq	r0, r0, sp, lsl #24
 494:	0000001c 	andeq	r0, r0, ip, lsl r0
 498:	00000420 	andeq	r0, r0, r0, lsr #8
 49c:	00008f2c 	andeq	r8, r0, ip, lsr #30
 4a0:	0000004c 	andeq	r0, r0, ip, asr #32
 4a4:	8b080e42 	blhi	203db4 <_bss_end+0x1f8244>
 4a8:	42018e02 	andmi	r8, r1, #2, 28
 4ac:	60040b0c 	andvs	r0, r4, ip, lsl #22
 4b0:	00080d0c 	andeq	r0, r8, ip, lsl #26
 4b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 4b8:	00000420 	andeq	r0, r0, r0, lsr #8
 4bc:	00008f78 	andeq	r8, r0, r8, ror pc
 4c0:	00000050 	andeq	r0, r0, r0, asr r0
 4c4:	8b080e42 	blhi	203dd4 <_bss_end+0x1f8264>
 4c8:	42018e02 	andmi	r8, r1, #2, 28
 4cc:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 4d0:	00080d0c 	andeq	r0, r8, ip, lsl #26
 4d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 4d8:	00000420 	andeq	r0, r0, r0, lsr #8
 4dc:	00008fc8 	andeq	r8, r0, r8, asr #31
 4e0:	00000040 	andeq	r0, r0, r0, asr #32
 4e4:	8b080e42 	blhi	203df4 <_bss_end+0x1f8284>
 4e8:	42018e02 	andmi	r8, r1, #2, 28
 4ec:	5a040b0c 	bpl	103124 <_bss_end+0xf75b4>
 4f0:	00080d0c 	andeq	r0, r8, ip, lsl #26
 4f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 4f8:	00000420 	andeq	r0, r0, r0, lsr #8
 4fc:	00009008 	andeq	r9, r0, r8
 500:	00000054 	andeq	r0, r0, r4, asr r0
 504:	8b080e42 	blhi	203e14 <_bss_end+0x1f82a4>
 508:	42018e02 	andmi	r8, r1, #2, 28
 50c:	5e040b0c 	vmlapl.f64	d0, d4, d12
 510:	00080d0c 	andeq	r0, r8, ip, lsl #26
 514:	00000018 	andeq	r0, r0, r8, lsl r0
 518:	00000420 	andeq	r0, r0, r0, lsr #8
 51c:	0000905c 	andeq	r9, r0, ip, asr r0
 520:	0000001c 	andeq	r0, r0, ip, lsl r0
 524:	8b080e42 	blhi	203e34 <_bss_end+0x1f82c4>
 528:	42018e02 	andmi	r8, r1, #2, 28
 52c:	00040b0c 	andeq	r0, r4, ip, lsl #22
 530:	0000000c 	andeq	r0, r0, ip
 534:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 538:	7c020001 	stcvc	0, cr0, [r2], {1}
 53c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 540:	0000001c 	andeq	r0, r0, ip, lsl r0
 544:	00000530 	andeq	r0, r0, r0, lsr r5
 548:	00009078 	andeq	r9, r0, r8, ror r0
 54c:	00000018 	andeq	r0, r0, r8, lsl r0
 550:	8b040e42 	blhi	103e60 <_bss_end+0xf82f0>
 554:	0b0d4201 	bleq	350d60 <_bss_end+0x3451f0>
 558:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
 55c:	00000ecb 	andeq	r0, r0, fp, asr #29
 560:	00000018 	andeq	r0, r0, r8, lsl r0
 564:	00000530 	andeq	r0, r0, r0, lsr r5
 568:	00009090 	muleq	r0, r0, r0
 56c:	00000030 	andeq	r0, r0, r0, lsr r0
 570:	8b080e42 	blhi	203e80 <_bss_end+0x1f8310>
 574:	42018e02 	andmi	r8, r1, #2, 28
 578:	00040b0c 	andeq	r0, r4, ip, lsl #22
 57c:	00000014 	andeq	r0, r0, r4, lsl r0
 580:	00000530 	andeq	r0, r0, r0, lsr r5
 584:	000090c0 	andeq	r9, r0, r0, asr #1
 588:	00000010 	andeq	r0, r0, r0, lsl r0
 58c:	040b0c42 	streq	r0, [fp], #-3138	; 0xfffff3be
 590:	000d0c44 	andeq	r0, sp, r4, asr #24
 594:	0000001c 	andeq	r0, r0, ip, lsl r0
 598:	00000530 	andeq	r0, r0, r0, lsr r5
 59c:	000090d0 	ldrdeq	r9, [r0], -r0
 5a0:	00000034 	andeq	r0, r0, r4, lsr r0
 5a4:	8b040e42 	blhi	103eb4 <_bss_end+0xf8344>
 5a8:	0b0d4201 	bleq	350db4 <_bss_end+0x345244>
 5ac:	420d0d52 	andmi	r0, sp, #5248	; 0x1480
 5b0:	00000ecb 	andeq	r0, r0, fp, asr #29
 5b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 5b8:	00000530 	andeq	r0, r0, r0, lsr r5
 5bc:	00009104 	andeq	r9, r0, r4, lsl #2
 5c0:	00000038 	andeq	r0, r0, r8, lsr r0
 5c4:	8b040e42 	blhi	103ed4 <_bss_end+0xf8364>
 5c8:	0b0d4201 	bleq	350dd4 <_bss_end+0x345264>
 5cc:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
 5d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 5d4:	00000020 	andeq	r0, r0, r0, lsr #32
 5d8:	00000530 	andeq	r0, r0, r0, lsr r5
 5dc:	0000913c 	andeq	r9, r0, ip, lsr r1
 5e0:	00000044 	andeq	r0, r0, r4, asr #32
 5e4:	840c0e42 	strhi	r0, [ip], #-3650	; 0xfffff1be
 5e8:	8e028b03 	vmlahi.f64	d8, d2, d3
 5ec:	0b0c4201 	bleq	310df8 <_bss_end+0x305288>
 5f0:	0d0c5c04 	stceq	12, cr5, [ip, #-16]
 5f4:	0000000c 	andeq	r0, r0, ip
 5f8:	00000020 	andeq	r0, r0, r0, lsr #32
 5fc:	00000530 	andeq	r0, r0, r0, lsr r5
 600:	00009180 	andeq	r9, r0, r0, lsl #3
 604:	00000044 	andeq	r0, r0, r4, asr #32
 608:	840c0e42 	strhi	r0, [ip], #-3650	; 0xfffff1be
 60c:	8e028b03 	vmlahi.f64	d8, d2, d3
 610:	0b0c4201 	bleq	310e1c <_bss_end+0x3052ac>
 614:	0d0c5c04 	stceq	12, cr5, [ip, #-16]
 618:	0000000c 	andeq	r0, r0, ip
 61c:	00000020 	andeq	r0, r0, r0, lsr #32
 620:	00000530 	andeq	r0, r0, r0, lsr r5
 624:	000091c4 	andeq	r9, r0, r4, asr #3
 628:	00000050 	andeq	r0, r0, r0, asr r0
 62c:	840c0e42 	strhi	r0, [ip], #-3650	; 0xfffff1be
 630:	8e028b03 	vmlahi.f64	d8, d2, d3
 634:	0b0c4201 	bleq	310e40 <_bss_end+0x3052d0>
 638:	0d0c6204 	sfmeq	f6, 4, [ip, #-16]
 63c:	0000000c 	andeq	r0, r0, ip
 640:	00000020 	andeq	r0, r0, r0, lsr #32
 644:	00000530 	andeq	r0, r0, r0, lsr r5
 648:	00009214 	andeq	r9, r0, r4, lsl r2
 64c:	00000050 	andeq	r0, r0, r0, asr r0
 650:	840c0e42 	strhi	r0, [ip], #-3650	; 0xfffff1be
 654:	8e028b03 	vmlahi.f64	d8, d2, d3
 658:	0b0c4201 	bleq	310e64 <_bss_end+0x3052f4>
 65c:	0d0c6204 	sfmeq	f6, 4, [ip, #-16]
 660:	0000000c 	andeq	r0, r0, ip
 664:	0000001c 	andeq	r0, r0, ip, lsl r0
 668:	00000530 	andeq	r0, r0, r0, lsr r5
 66c:	00009264 	andeq	r9, r0, r4, ror #4
 670:	00000054 	andeq	r0, r0, r4, asr r0
 674:	8b080e42 	blhi	203f84 <_bss_end+0x1f8414>
 678:	42018e02 	andmi	r8, r1, #2, 28
 67c:	5e040b0c 	vmlapl.f64	d0, d4, d12
 680:	00080d0c 	andeq	r0, r8, ip, lsl #26
 684:	00000018 	andeq	r0, r0, r8, lsl r0
 688:	00000530 	andeq	r0, r0, r0, lsr r5
 68c:	000092b8 			; <UNDEFINED> instruction: 0x000092b8
 690:	0000001c 	andeq	r0, r0, ip, lsl r0
 694:	8b080e42 	blhi	203fa4 <_bss_end+0x1f8434>
 698:	42018e02 	andmi	r8, r1, #2, 28
 69c:	00040b0c 	andeq	r0, r4, ip, lsl #22
 6a0:	0000000c 	andeq	r0, r0, ip
 6a4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 6a8:	7c020001 	stcvc	0, cr0, [r2], {1}
 6ac:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 6b0:	00000018 	andeq	r0, r0, r8, lsl r0
 6b4:	000006a0 	andeq	r0, r0, r0, lsr #13
 6b8:	000092d4 	ldrdeq	r9, [r0], -r4
 6bc:	0000005c 	andeq	r0, r0, ip, asr r0
 6c0:	8b080e42 	blhi	203fd0 <_bss_end+0x1f8460>
 6c4:	42018e02 	andmi	r8, r1, #2, 28
 6c8:	00040b0c 	andeq	r0, r4, ip, lsl #22
 6cc:	00000018 	andeq	r0, r0, r8, lsl r0
 6d0:	000006a0 	andeq	r0, r0, r0, lsr #13
 6d4:	00009330 	andeq	r9, r0, r0, lsr r3
 6d8:	0000006c 	andeq	r0, r0, ip, rrx
 6dc:	8b080e42 	blhi	203fec <_bss_end+0x1f847c>
 6e0:	42018e02 	andmi	r8, r1, #2, 28
 6e4:	00040b0c 	andeq	r0, r4, ip, lsl #22
 6e8:	00000018 	andeq	r0, r0, r8, lsl r0
 6ec:	000006a0 	andeq	r0, r0, r0, lsr #13
 6f0:	0000939c 	muleq	r0, ip, r3
 6f4:	0000006c 	andeq	r0, r0, ip, rrx
 6f8:	8b080e42 	blhi	204008 <_bss_end+0x1f8498>
 6fc:	42018e02 	andmi	r8, r1, #2, 28
 700:	00040b0c 	andeq	r0, r4, ip, lsl #22
 704:	00000018 	andeq	r0, r0, r8, lsl r0
 708:	000006a0 	andeq	r0, r0, r0, lsr #13
 70c:	00009408 	andeq	r9, r0, r8, lsl #8
 710:	0000006c 	andeq	r0, r0, ip, rrx
 714:	8b080e42 	blhi	204024 <_bss_end+0x1f84b4>
 718:	42018e02 	andmi	r8, r1, #2, 28
 71c:	00040b0c 	andeq	r0, r4, ip, lsl #22
 720:	00000018 	andeq	r0, r0, r8, lsl r0
 724:	000006a0 	andeq	r0, r0, r0, lsr #13
 728:	00009474 	andeq	r9, r0, r4, ror r4
 72c:	0000006c 	andeq	r0, r0, ip, rrx
 730:	8b080e42 	blhi	204040 <_bss_end+0x1f84d0>
 734:	42018e02 	andmi	r8, r1, #2, 28
 738:	00040b0c 	andeq	r0, r4, ip, lsl #22
 73c:	00000018 	andeq	r0, r0, r8, lsl r0
 740:	000006a0 	andeq	r0, r0, r0, lsr #13
 744:	000094e0 	andeq	r9, r0, r0, ror #9
 748:	000000dc 	ldrdeq	r0, [r0], -ip
 74c:	8b080e42 	blhi	20405c <_bss_end+0x1f84ec>
 750:	42018e02 	andmi	r8, r1, #2, 28
 754:	00040b0c 	andeq	r0, r4, ip, lsl #22
 758:	0000000c 	andeq	r0, r0, ip
 75c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 760:	7c020001 	stcvc	0, cr0, [r2], {1}
 764:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 768:	0000001c 	andeq	r0, r0, ip, lsl r0
 76c:	00000758 	andeq	r0, r0, r8, asr r7
 770:	000095bc 			; <UNDEFINED> instruction: 0x000095bc
 774:	00000034 	andeq	r0, r0, r4, lsr r0
 778:	8b080e42 	blhi	204088 <_bss_end+0x1f8518>
 77c:	42018e02 	andmi	r8, r1, #2, 28
 780:	54040b0c 	strpl	r0, [r4], #-2828	; 0xfffff4f4
 784:	00080d0c 	andeq	r0, r8, ip, lsl #26
 788:	0000001c 	andeq	r0, r0, ip, lsl r0
 78c:	00000758 	andeq	r0, r0, r8, asr r7
 790:	000095f0 	strdeq	r9, [r0], -r0
 794:	00000068 	andeq	r0, r0, r8, rrx
 798:	8b080e42 	blhi	2040a8 <_bss_end+0x1f8538>
 79c:	42018e02 	andmi	r8, r1, #2, 28
 7a0:	6a040b0c 	bvs	1033d8 <_bss_end+0xf7868>
 7a4:	00080d0c 	andeq	r0, r8, ip, lsl #26
 7a8:	0000001c 	andeq	r0, r0, ip, lsl r0
 7ac:	00000758 	andeq	r0, r0, r8, asr r7
 7b0:	00009658 	andeq	r9, r0, r8, asr r6
 7b4:	0000014c 	andeq	r0, r0, ip, asr #2
 7b8:	8b040e42 	blhi	1040c8 <_bss_end+0xf8558>
 7bc:	0b0d4201 	bleq	350fc8 <_bss_end+0x345458>
 7c0:	0d0d9e02 	stceq	14, cr9, [sp, #-8]
 7c4:	000ecb42 	andeq	ip, lr, r2, asr #22
 7c8:	0000001c 	andeq	r0, r0, ip, lsl r0
 7cc:	00000758 	andeq	r0, r0, r8, asr r7
 7d0:	000097a4 	andeq	r9, r0, r4, lsr #15
 7d4:	0000011c 	andeq	r0, r0, ip, lsl r1
 7d8:	8b040e42 	blhi	1040e8 <_bss_end+0xf8578>
 7dc:	0b0d4201 	bleq	350fe8 <_bss_end+0x345478>
 7e0:	0d0d8602 	stceq	6, cr8, [sp, #-8]
 7e4:	000ecb42 	andeq	ip, lr, r2, asr #22
 7e8:	0000001c 	andeq	r0, r0, ip, lsl r0
 7ec:	00000758 	andeq	r0, r0, r8, asr r7
 7f0:	000098c0 	andeq	r9, r0, r0, asr #17
 7f4:	0000004c 	andeq	r0, r0, ip, asr #32
 7f8:	8b080e42 	blhi	204108 <_bss_end+0x1f8598>
 7fc:	42018e02 	andmi	r8, r1, #2, 28
 800:	5c040b0c 			; <UNDEFINED> instruction: 0x5c040b0c
 804:	00080d0c 	andeq	r0, r8, ip, lsl #26
 808:	00000018 	andeq	r0, r0, r8, lsl r0
 80c:	00000758 	andeq	r0, r0, r8, asr r7
 810:	0000990c 	andeq	r9, r0, ip, lsl #18
 814:	0000001c 	andeq	r0, r0, ip, lsl r0
 818:	8b080e42 	blhi	204128 <_bss_end+0x1f85b8>
 81c:	42018e02 	andmi	r8, r1, #2, 28
 820:	00040b0c 	andeq	r0, r4, ip, lsl #22
 824:	0000000c 	andeq	r0, r0, ip
 828:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 82c:	7c020001 	stcvc	0, cr0, [r2], {1}
 830:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 834:	0000001c 	andeq	r0, r0, ip, lsl r0
 838:	00000824 	andeq	r0, r0, r4, lsr #16
 83c:	00009928 	andeq	r9, r0, r8, lsr #18
 840:	00000064 	andeq	r0, r0, r4, rrx
 844:	8b040e42 	blhi	104154 <_bss_end+0xf85e4>
 848:	0b0d4201 	bleq	351054 <_bss_end+0x3454e4>
 84c:	420d0d68 	andmi	r0, sp, #104, 26	; 0x1a00
 850:	00000ecb 	andeq	r0, r0, fp, asr #29
 854:	0000001c 	andeq	r0, r0, ip, lsl r0
 858:	00000824 	andeq	r0, r0, r4, lsr #16
 85c:	0000998c 	andeq	r9, r0, ip, lsl #19
 860:	000000bc 	strheq	r0, [r0], -ip
 864:	8b040e42 	blhi	104174 <_bss_end+0xf8604>
 868:	0b0d4201 	bleq	351074 <_bss_end+0x345504>
 86c:	0d0d5602 	stceq	6, cr5, [sp, #-8]
 870:	000ecb42 	andeq	ip, lr, r2, asr #22
 874:	0000001c 	andeq	r0, r0, ip, lsl r0
 878:	00000824 	andeq	r0, r0, r4, lsr #16
 87c:	00009a48 	andeq	r9, r0, r8, asr #20
 880:	000000e4 	andeq	r0, r0, r4, ror #1
 884:	8b080e42 	blhi	204194 <_bss_end+0x1f8624>
 888:	42018e02 	andmi	r8, r1, #2, 28
 88c:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 890:	080d0c6a 	stmdaeq	sp, {r1, r3, r5, r6, sl, fp}
 894:	0000001c 	andeq	r0, r0, ip, lsl r0
 898:	00000824 	andeq	r0, r0, r4, lsr #16
 89c:	00009b2c 	andeq	r9, r0, ip, lsr #22
 8a0:	00000038 	andeq	r0, r0, r8, lsr r0
 8a4:	8b080e42 	blhi	2041b4 <_bss_end+0x1f8644>
 8a8:	42018e02 	andmi	r8, r1, #2, 28
 8ac:	56040b0c 	strpl	r0, [r4], -ip, lsl #22
 8b0:	00080d0c 	andeq	r0, r8, ip, lsl #26
 8b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 8b8:	00000824 	andeq	r0, r0, r4, lsr #16
 8bc:	00009b64 	andeq	r9, r0, r4, ror #22
 8c0:	0000004c 	andeq	r0, r0, ip, asr #32
 8c4:	8b080e42 	blhi	2041d4 <_bss_end+0x1f8664>
 8c8:	42018e02 	andmi	r8, r1, #2, 28
 8cc:	5c040b0c 			; <UNDEFINED> instruction: 0x5c040b0c
 8d0:	00080d0c 	andeq	r0, r8, ip, lsl #26
 8d4:	00000018 	andeq	r0, r0, r8, lsl r0
 8d8:	00000824 	andeq	r0, r0, r4, lsr #16
 8dc:	00009bb0 			; <UNDEFINED> instruction: 0x00009bb0
 8e0:	0000001c 	andeq	r0, r0, ip, lsl r0
 8e4:	8b080e42 	blhi	2041f4 <_bss_end+0x1f8684>
 8e8:	42018e02 	andmi	r8, r1, #2, 28
 8ec:	00040b0c 	andeq	r0, r4, ip, lsl #22
 8f0:	0000000c 	andeq	r0, r0, ip
 8f4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 8f8:	7c020001 	stcvc	0, cr0, [r2], {1}
 8fc:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 900:	0000001c 	andeq	r0, r0, ip, lsl r0
 904:	000008f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
 908:	00009bcc 	andeq	r9, r0, ip, asr #23
 90c:	00000048 	andeq	r0, r0, r8, asr #32
 910:	8b040e42 	blhi	104220 <_bss_end+0xf86b0>
 914:	0b0d4201 	bleq	351120 <_bss_end+0x3455b0>
 918:	420d0d5c 	andmi	r0, sp, #92, 26	; 0x1700
 91c:	00000ecb 	andeq	r0, r0, fp, asr #29
 920:	0000001c 	andeq	r0, r0, ip, lsl r0
 924:	000008f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
 928:	00009c14 	andeq	r9, r0, r4, lsl ip
 92c:	00000044 	andeq	r0, r0, r4, asr #32
 930:	8b040e42 	blhi	104240 <_bss_end+0xf86d0>
 934:	0b0d4201 	bleq	351140 <_bss_end+0x3455d0>
 938:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 93c:	00000ecb 	andeq	r0, r0, fp, asr #29
 940:	0000001c 	andeq	r0, r0, ip, lsl r0
 944:	000008f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
 948:	00009c58 	andeq	r9, r0, r8, asr ip
 94c:	000000f8 	strdeq	r0, [r0], -r8
 950:	8b080e42 	blhi	204260 <_bss_end+0x1f86f0>
 954:	42018e02 	andmi	r8, r1, #2, 28
 958:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 95c:	080d0c74 	stmdaeq	sp, {r2, r4, r5, r6, sl, fp}
 960:	0000001c 	andeq	r0, r0, ip, lsl r0
 964:	000008f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
 968:	00009d50 	andeq	r9, r0, r0, asr sp
 96c:	000001c4 	andeq	r0, r0, r4, asr #3
 970:	8b080e42 	blhi	204280 <_bss_end+0x1f8710>
 974:	42018e02 	andmi	r8, r1, #2, 28
 978:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 97c:	080d0ccc 	stmdaeq	sp, {r2, r3, r6, r7, sl, fp}
 980:	0000001c 	andeq	r0, r0, ip, lsl r0
 984:	000008f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
 988:	00009f14 	andeq	r9, r0, r4, lsl pc
 98c:	00000168 	andeq	r0, r0, r8, ror #2
 990:	8b080e42 	blhi	2042a0 <_bss_end+0x1f8730>
 994:	42018e02 	andmi	r8, r1, #2, 28
 998:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 99c:	080d0cae 	stmdaeq	sp, {r1, r2, r3, r5, r7, sl, fp}
 9a0:	0000001c 	andeq	r0, r0, ip, lsl r0
 9a4:	000008f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
 9a8:	0000a07c 	andeq	sl, r0, ip, ror r0
 9ac:	00000104 	andeq	r0, r0, r4, lsl #2
 9b0:	8b080e42 	blhi	2042c0 <_bss_end+0x1f8750>
 9b4:	42018e02 	andmi	r8, r1, #2, 28
 9b8:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 9bc:	080d0c7c 	stmdaeq	sp, {r2, r3, r4, r5, r6, sl, fp}
 9c0:	0000001c 	andeq	r0, r0, ip, lsl r0
 9c4:	000008f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
 9c8:	0000a1e8 	andeq	sl, r0, r8, ror #3
 9cc:	0000002c 	andeq	r0, r0, ip, lsr #32
 9d0:	8b080e42 	blhi	2042e0 <_bss_end+0x1f8770>
 9d4:	42018e02 	andmi	r8, r1, #2, 28
 9d8:	50040b0c 	andpl	r0, r4, ip, lsl #22
 9dc:	00080d0c 	andeq	r0, r8, ip, lsl #26
 9e0:	0000001c 	andeq	r0, r0, ip, lsl r0
 9e4:	000008f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
 9e8:	0000a214 	andeq	sl, r0, r4, lsl r2
 9ec:	0000002c 	andeq	r0, r0, ip, lsr #32
 9f0:	8b080e42 	blhi	204300 <_bss_end+0x1f8790>
 9f4:	42018e02 	andmi	r8, r1, #2, 28
 9f8:	50040b0c 	andpl	r0, r4, ip, lsl #22
 9fc:	00080d0c 	andeq	r0, r8, ip, lsl #26
 a00:	0000001c 	andeq	r0, r0, ip, lsl r0
 a04:	000008f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
 a08:	0000a180 	andeq	sl, r0, r0, lsl #3
 a0c:	0000004c 	andeq	r0, r0, ip, asr #32
 a10:	8b080e42 	blhi	204320 <_bss_end+0x1f87b0>
 a14:	42018e02 	andmi	r8, r1, #2, 28
 a18:	5c040b0c 			; <UNDEFINED> instruction: 0x5c040b0c
 a1c:	00080d0c 	andeq	r0, r8, ip, lsl #26
 a20:	00000018 	andeq	r0, r0, r8, lsl r0
 a24:	000008f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
 a28:	0000a1cc 	andeq	sl, r0, ip, asr #3
 a2c:	0000001c 	andeq	r0, r0, ip, lsl r0
 a30:	8b080e42 	blhi	204340 <_bss_end+0x1f87d0>
 a34:	42018e02 	andmi	r8, r1, #2, 28
 a38:	00040b0c 	andeq	r0, r4, ip, lsl #22
 a3c:	0000000c 	andeq	r0, r0, ip
 a40:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 a44:	7c020001 	stcvc	0, cr0, [r2], {1}
 a48:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 a4c:	0000001c 	andeq	r0, r0, ip, lsl r0
 a50:	00000a3c 	andeq	r0, r0, ip, lsr sl
 a54:	0000a2ec 	andeq	sl, r0, ip, ror #5
 a58:	00000068 	andeq	r0, r0, r8, rrx
 a5c:	8b040e42 	blhi	10436c <_bss_end+0xf87fc>
 a60:	0b0d4201 	bleq	35126c <_bss_end+0x3456fc>
 a64:	420d0d68 	andmi	r0, sp, #104, 26	; 0x1a00
 a68:	00000ecb 	andeq	r0, r0, fp, asr #29
 a6c:	0000001c 	andeq	r0, r0, ip, lsl r0
 a70:	00000a3c 	andeq	r0, r0, ip, lsr sl
 a74:	0000a354 	andeq	sl, r0, r4, asr r3
 a78:	00000058 	andeq	r0, r0, r8, asr r0
 a7c:	8b080e42 	blhi	20438c <_bss_end+0x1f881c>
 a80:	42018e02 	andmi	r8, r1, #2, 28
 a84:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 a88:	00080d0c 	andeq	r0, r8, ip, lsl #26
 a8c:	0000001c 	andeq	r0, r0, ip, lsl r0
 a90:	00000a3c 	andeq	r0, r0, ip, lsr sl
 a94:	0000a3ac 	andeq	sl, r0, ip, lsr #7
 a98:	00000058 	andeq	r0, r0, r8, asr r0
 a9c:	8b080e42 	blhi	2043ac <_bss_end+0x1f883c>
 aa0:	42018e02 	andmi	r8, r1, #2, 28
 aa4:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 aa8:	00080d0c 	andeq	r0, r8, ip, lsl #26
 aac:	0000000c 	andeq	r0, r0, ip
 ab0:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 ab4:	7c020001 	stcvc	0, cr0, [r2], {1}
 ab8:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 abc:	0000001c 	andeq	r0, r0, ip, lsl r0
 ac0:	00000aac 	andeq	r0, r0, ip, lsr #21
 ac4:	0000a404 	andeq	sl, r0, r4, lsl #8
 ac8:	00000174 	andeq	r0, r0, r4, ror r1
 acc:	8b080e42 	blhi	2043dc <_bss_end+0x1f886c>
 ad0:	42018e02 	andmi	r8, r1, #2, 28
 ad4:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 ad8:	080d0cb2 	stmdaeq	sp, {r1, r4, r5, r7, sl, fp}
 adc:	0000000c 	andeq	r0, r0, ip
 ae0:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 ae4:	7c010001 	stcvc	0, cr0, [r1], {1}
 ae8:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 aec:	0000000c 	andeq	r0, r0, ip
 af0:	00000adc 	ldrdeq	r0, [r0], -ip
 af4:	0000a578 	andeq	sl, r0, r8, ror r5
 af8:	000001ec 	andeq	r0, r0, ip, ror #3

Disassembly of section .debug_ranges:

00000000 <.debug_ranges>:
   0:	000086b4 			; <UNDEFINED> instruction: 0x000086b4
   4:	00008cfc 	strdeq	r8, [r0], -ip
   8:	00008cfc 	strdeq	r8, [r0], -ip
   c:	00008d34 	andeq	r8, r0, r4, lsr sp
  10:	00008d34 	andeq	r8, r0, r4, lsr sp
  14:	00008dbc 			; <UNDEFINED> instruction: 0x00008dbc
  18:	00008dbc 			; <UNDEFINED> instruction: 0x00008dbc
  1c:	00008de8 	andeq	r8, r0, r8, ror #27
	...
  28:	00009bcc 	andeq	r9, r0, ip, asr #23
  2c:	0000a1e8 	andeq	sl, r0, r8, ror #3
  30:	0000a1e8 	andeq	sl, r0, r8, ror #3
  34:	0000a214 	andeq	sl, r0, r4, lsl r2
  38:	0000a214 	andeq	sl, r0, r4, lsl r2
  3c:	0000a240 	andeq	sl, r0, r0, asr #4
	...
  48:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  4c:	00000000 	andeq	r0, r0, r0
  50:	00008000 	andeq	r8, r0, r0
  54:	000080ac 	andeq	r8, r0, ip, lsr #1
  58:	0000a29c 	muleq	r0, ip, r2
  5c:	0000a2ec 	andeq	sl, r0, ip, ror #5
	...
