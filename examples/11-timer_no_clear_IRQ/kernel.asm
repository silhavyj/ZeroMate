
./kernel:     file format elf32-littlearm


Disassembly of section .text:

00008000 <_start>:
_start():
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/start.s:14
	;@	- sem skoci bootloader, prvni na co narazi je "ldr pc, _reset_ptr" -> tedy se chova jako kdyby slo o reset a skoci na zacatek provadeni
	;@	- v cele svoji krase (vsechny "ldr" instrukce) slouzi jako predloha skutecne tabulce vektoru preruseni
	;@ na dany offset procesor skoci, kdyz je vyvolano libovolne preruseni
	;@ ARM nastavuje rovnou registr PC na tuto adresu, tzn. na teto adrese musi byt kodovana 4B instrukce skoku nekam jinam
	;@ oproti tomu napr. x86 (x86_64) obsahuje v tabulce rovnou adresu a procesor nastavuje PC (CS:IP) na adresu kterou najde v tabulce
	ldr pc, _reset_ptr						;@ 0x00 - reset - vyvolano pri resetu procesoru
    8000:	e59ff018 	ldr	pc, [pc, #24]	; 8020 <_reset_ptr>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/start.s:15
	ldr pc, _undefined_instruction_ptr		;@ 0x04 - undefined instruction - vyjimka, vyvolana pri dekodovani nezname instrukce
    8004:	e59ff018 	ldr	pc, [pc, #24]	; 8024 <_undefined_instruction_ptr>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/start.s:16
	ldr pc, _software_interrupt_ptr			;@ 0x08 - software interrupt - vyvolano, kdyz procesor provede instrukci swi
    8008:	e59ff018 	ldr	pc, [pc, #24]	; 8028 <_software_interrupt_ptr>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/start.s:17
	ldr pc, _prefetch_abort_ptr				;@ 0x0C - prefetch abort - vyvolano, kdyz se procesor snazi napr. nacist instrukci z mista, odkud nacist nejde
    800c:	e59ff018 	ldr	pc, [pc, #24]	; 802c <_prefetch_abort_ptr>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/start.s:18
	ldr pc, _data_abort_ptr					;@ 0x10 - data abort - vyvolano, kdyz se procesor snazi napr. nacist data z mista, odkud nacist nejdou
    8010:	e59ff018 	ldr	pc, [pc, #24]	; 8030 <_data_abort_ptr>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/start.s:19
	ldr pc, _unused_handler_ptr				;@ 0x14 - unused - ve specifikaci ARM neni uvedeno zadne vyuziti
    8014:	e59ff018 	ldr	pc, [pc, #24]	; 8034 <_unused_handler_ptr>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/start.s:20
	ldr pc, _irq_ptr						;@ 0x18 - IRQ - hardwarove preruseni (general purpose)
    8018:	e59ff018 	ldr	pc, [pc, #24]	; 8038 <_irq_ptr>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/start.s:21
	ldr pc, _fast_interrupt_ptr				;@ 0x1C - fast interrupt request - prioritni IRQ pro vysokorychlostni zalezitosti
    801c:	e59ff018 	ldr	pc, [pc, #24]	; 803c <_fast_interrupt_ptr>

00008020 <_reset_ptr>:
_reset_ptr():
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/start.s:21
    8020:	00008040 	andeq	r8, r0, r0, asr #32

00008024 <_undefined_instruction_ptr>:
_undefined_instruction_ptr():
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/start.s:21
    8024:	00008fe4 	andeq	r8, r0, r4, ror #31

00008028 <_software_interrupt_ptr>:
_software_interrupt_ptr():
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/start.s:21
    8028:	00008c20 	andeq	r8, r0, r0, lsr #24

0000802c <_prefetch_abort_ptr>:
_prefetch_abort_ptr():
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/start.s:21
    802c:	00008fe8 	andeq	r8, r0, r8, ror #31

00008030 <_data_abort_ptr>:
_data_abort_ptr():
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/start.s:21
    8030:	00008fec 	andeq	r8, r0, ip, ror #31

00008034 <_unused_handler_ptr>:
_unused_handler_ptr():
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/start.s:21
    8034:	00008040 	andeq	r8, r0, r0, asr #32

00008038 <_irq_ptr>:
_irq_ptr():
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/start.s:21
    8038:	00008c38 	andeq	r8, r0, r8, lsr ip

0000803c <_fast_interrupt_ptr>:
_fast_interrupt_ptr():
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/start.s:21
    803c:	00008c70 	andeq	r8, r0, r0, ror ip

00008040 <_reset>:
_reset():
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/start.s:50
.equ    CPSR_FIQ_INHIBIT,       0x40


;@ kernel reset vektor - tento kod se vykona pri kazdem resetu zarizeni (i prvnim spusteni)
_reset:
	mov sp, #0x8000			;@ nastavime stack pointer na spodek zasobniku
    8040:	e3a0d902 	mov	sp, #32768	; 0x8000
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/start.s:53

	;@ nacteni tabulky vektoru preruseni do pameti
	mov r0, #0x8000			;@ adresa 0x8000 (_start) do r0
    8044:	e3a00902 	mov	r0, #32768	; 0x8000
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/start.s:54
    mov r1, #0x0000			;@ adresa 0x0000 (pocatek RAM) do r1 - tam budeme vkladat tabulku vektoru preruseni
    8048:	e3a01000 	mov	r1, #0
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/start.s:58

	;@ Thumb instrukce - nacteni 4B slov z pameti ulozene v r0 (0x8000) do registru r2, 3, ... 9
	;@                 - ulozeni obsahu registru r2, 3, ... 9 do pameti ulozene v registru r1 (0x0000)
    ldmia r0!,{r2, r3, r4, r5, r6, r7, r8, r9}
    804c:	e8b003fc 	ldm	r0!, {r2, r3, r4, r5, r6, r7, r8, r9}
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/start.s:59
    stmia r1!,{r2, r3, r4, r5, r6, r7, r8, r9}
    8050:	e8a103fc 	stmia	r1!, {r2, r3, r4, r5, r6, r7, r8, r9}
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/start.s:60
    ldmia r0!,{r2, r3, r4, r5, r6, r7, r8, r9}
    8054:	e8b003fc 	ldm	r0!, {r2, r3, r4, r5, r6, r7, r8, r9}
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/start.s:61
    stmia r1!,{r2, r3, r4, r5, r6, r7, r8, r9}
    8058:	e8a103fc 	stmia	r1!, {r2, r3, r4, r5, r6, r7, r8, r9}
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/start.s:64

	;@ na moment se prepneme do IRQ rezimu, nastavime mu stack pointer
	mov r0, #(CPSR_MODE_IRQ | CPSR_IRQ_INHIBIT | CPSR_FIQ_INHIBIT)
    805c:	e3a000d2 	mov	r0, #210	; 0xd2
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/start.s:65
    msr cpsr_c, r0
    8060:	e121f000 	msr	CPSR_c, r0
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/start.s:66
    mov sp, #0x7000
    8064:	e3a0da07 	mov	sp, #28672	; 0x7000
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/start.s:69

	;@ na moment se prepneme do FIQ rezimu, nastavime mu stack pointer
	mov r0, #(CPSR_MODE_FIQ | CPSR_IRQ_INHIBIT | CPSR_FIQ_INHIBIT)
    8068:	e3a000d1 	mov	r0, #209	; 0xd1
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/start.s:70
    msr cpsr_c, r0
    806c:	e121f000 	msr	CPSR_c, r0
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/start.s:71
    mov sp, #0x6000
    8070:	e3a0da06 	mov	sp, #24576	; 0x6000
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/start.s:74

	;@ a vracime se zpet do supervisor modu, SP si nastavime zpet na nasi hodnotu
    mov r0, #(CPSR_MODE_SVR | CPSR_IRQ_INHIBIT | CPSR_FIQ_INHIBIT)
    8074:	e3a000d3 	mov	r0, #211	; 0xd3
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/start.s:75
    msr cpsr_c, r0
    8078:	e121f000 	msr	CPSR_c, r0
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/start.s:76
    mov sp, #0x8000
    807c:	e3a0d902 	mov	sp, #32768	; 0x8000
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/start.s:78

	bl _c_startup			;@ C startup kod (inicializace prostredi)
    8080:	eb0003da 	bl	8ff0 <_c_startup>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/start.s:79
	bl _cpp_startup			;@ C++ startup kod (volani globalnich konstruktoru, ...)
    8084:	eb0003f3 	bl	9058 <_cpp_startup>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/start.s:80
	bl _kernel_main			;@ skocime do hlavniho kodu jadra (v C)
    8088:	eb0003a6 	bl	8f28 <_kernel_main>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/start.s:81
	bl _cpp_shutdown		;@ C++ shutdown kod (volani globalnich destruktoru, ...)
    808c:	eb000407 	bl	90b0 <_cpp_shutdown>

00008090 <hang>:
hang():
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/start.s:83
hang:
	b hang
    8090:	eafffffe 	b	8090 <hang>

00008094 <__cxa_guard_acquire>:
__cxa_guard_acquire():
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/cxx.cpp:11
    extern "C" int __cxa_guard_acquire(__guard*);
    extern "C" void __cxa_guard_release(__guard*);
    extern "C" void __cxa_guard_abort(__guard*);

    extern "C" int __cxa_guard_acquire(__guard* g)
    {
    8094:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8098:	e28db000 	add	fp, sp, #0
    809c:	e24dd00c 	sub	sp, sp, #12
    80a0:	e50b0008 	str	r0, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/cxx.cpp:12
        return !*(char*)(g);
    80a4:	e51b3008 	ldr	r3, [fp, #-8]
    80a8:	e5d33000 	ldrb	r3, [r3]
    80ac:	e3530000 	cmp	r3, #0
    80b0:	03a03001 	moveq	r3, #1
    80b4:	13a03000 	movne	r3, #0
    80b8:	e6ef3073 	uxtb	r3, r3
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/cxx.cpp:13
    }
    80bc:	e1a00003 	mov	r0, r3
    80c0:	e28bd000 	add	sp, fp, #0
    80c4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    80c8:	e12fff1e 	bx	lr

000080cc <__cxa_guard_release>:
__cxa_guard_release():
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/cxx.cpp:16

    extern "C" void __cxa_guard_release(__guard* g)
    {
    80cc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    80d0:	e28db000 	add	fp, sp, #0
    80d4:	e24dd00c 	sub	sp, sp, #12
    80d8:	e50b0008 	str	r0, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/cxx.cpp:17
        *(char*)g = 1;
    80dc:	e51b3008 	ldr	r3, [fp, #-8]
    80e0:	e3a02001 	mov	r2, #1
    80e4:	e5c32000 	strb	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/cxx.cpp:18
    }
    80e8:	e320f000 	nop	{0}
    80ec:	e28bd000 	add	sp, fp, #0
    80f0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    80f4:	e12fff1e 	bx	lr

000080f8 <__cxa_guard_abort>:
__cxa_guard_abort():
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/cxx.cpp:21

    extern "C" void __cxa_guard_abort(__guard*)
    {
    80f8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    80fc:	e28db000 	add	fp, sp, #0
    8100:	e24dd00c 	sub	sp, sp, #12
    8104:	e50b0008 	str	r0, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/cxx.cpp:22
    }
    8108:	e320f000 	nop	{0}
    810c:	e28bd000 	add	sp, fp, #0
    8110:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8114:	e12fff1e 	bx	lr

00008118 <__dso_handle>:
__dso_handle():
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/cxx.cpp:26
}

extern "C" void __dso_handle()
{
    8118:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    811c:	e28db000 	add	fp, sp, #0
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/cxx.cpp:28
    // ignore dtors for now
}
    8120:	e320f000 	nop	{0}
    8124:	e28bd000 	add	sp, fp, #0
    8128:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    812c:	e12fff1e 	bx	lr

00008130 <__cxa_atexit>:
__cxa_atexit():
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/cxx.cpp:31

extern "C" void __cxa_atexit()
{
    8130:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8134:	e28db000 	add	fp, sp, #0
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/cxx.cpp:33
    // ignore dtors for now
}
    8138:	e320f000 	nop	{0}
    813c:	e28bd000 	add	sp, fp, #0
    8140:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8144:	e12fff1e 	bx	lr

00008148 <__cxa_pure_virtual>:
__cxa_pure_virtual():
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/cxx.cpp:36

extern "C" void __cxa_pure_virtual()
{
    8148:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    814c:	e28db000 	add	fp, sp, #0
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/cxx.cpp:38
    // pure virtual method called
}
    8150:	e320f000 	nop	{0}
    8154:	e28bd000 	add	sp, fp, #0
    8158:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    815c:	e12fff1e 	bx	lr

00008160 <__aeabi_unwind_cpp_pr1>:
__aeabi_unwind_cpp_pr1():
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/cxx.cpp:41

extern "C" void __aeabi_unwind_cpp_pr1()
{
    8160:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8164:	e28db000 	add	fp, sp, #0
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/cxx.cpp:42 (discriminator 1)
    while (true)
    8168:	eafffffe 	b	8168 <__aeabi_unwind_cpp_pr1+0x8>

0000816c <_ZN13CGPIO_HandlerC1Ej>:
_ZN13CGPIO_HandlerC2Ej():
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:6
#include <hal/peripherals.h>
#include <drivers/gpio.h>

CGPIO_Handler sGPIO(hal::GPIO_Base);

CGPIO_Handler::CGPIO_Handler(unsigned int gpio_base_addr)
    816c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8170:	e28db000 	add	fp, sp, #0
    8174:	e24dd00c 	sub	sp, sp, #12
    8178:	e50b0008 	str	r0, [fp, #-8]
    817c:	e50b100c 	str	r1, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:7
: mGPIO(reinterpret_cast<unsigned int*>(gpio_base_addr))
    8180:	e51b200c 	ldr	r2, [fp, #-12]
    8184:	e51b3008 	ldr	r3, [fp, #-8]
    8188:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:10
{
    //
}
    818c:	e51b3008 	ldr	r3, [fp, #-8]
    8190:	e1a00003 	mov	r0, r3
    8194:	e28bd000 	add	sp, fp, #0
    8198:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    819c:	e12fff1e 	bx	lr

000081a0 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_>:
_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_():
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:13

bool CGPIO_Handler::Get_GPFSEL_Location(uint32_t pin, uint32_t& reg, uint32_t& bit_idx) const
{
    81a0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    81a4:	e28db000 	add	fp, sp, #0
    81a8:	e24dd014 	sub	sp, sp, #20
    81ac:	e50b0008 	str	r0, [fp, #-8]
    81b0:	e50b100c 	str	r1, [fp, #-12]
    81b4:	e50b2010 	str	r2, [fp, #-16]
    81b8:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:14
    if (pin > hal::GPIO_Pin_Count)
    81bc:	e51b300c 	ldr	r3, [fp, #-12]
    81c0:	e3530036 	cmp	r3, #54	; 0x36
    81c4:	9a000001 	bls	81d0 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0x30>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:15
        return false;
    81c8:	e3a03000 	mov	r3, #0
    81cc:	ea000033 	b	82a0 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0x100>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:17

    switch (pin / 10)
    81d0:	e51b300c 	ldr	r3, [fp, #-12]
    81d4:	e59f20d4 	ldr	r2, [pc, #212]	; 82b0 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0x110>
    81d8:	e0832392 	umull	r2, r3, r2, r3
    81dc:	e1a031a3 	lsr	r3, r3, #3
    81e0:	e3530005 	cmp	r3, #5
    81e4:	979ff103 	ldrls	pc, [pc, r3, lsl #2]
    81e8:	ea00001d 	b	8264 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0xc4>
    81ec:	00008204 	andeq	r8, r0, r4, lsl #4
    81f0:	00008214 	andeq	r8, r0, r4, lsl r2
    81f4:	00008224 	andeq	r8, r0, r4, lsr #4
    81f8:	00008234 	andeq	r8, r0, r4, lsr r2
    81fc:	00008244 	andeq	r8, r0, r4, asr #4
    8200:	00008254 	andeq	r8, r0, r4, asr r2
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:20
    {
        case 0:
            reg = static_cast<uint32_t>(hal::GPIO_Reg::GPFSEL0);
    8204:	e51b3010 	ldr	r3, [fp, #-16]
    8208:	e3a02000 	mov	r2, #0
    820c:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:21
            break;
    8210:	ea000013 	b	8264 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0xc4>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:23
        case 1:
            reg = static_cast<uint32_t>(hal::GPIO_Reg::GPFSEL1);
    8214:	e51b3010 	ldr	r3, [fp, #-16]
    8218:	e3a02001 	mov	r2, #1
    821c:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:24
            break;
    8220:	ea00000f 	b	8264 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0xc4>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:26
        case 2:
            reg = static_cast<uint32_t>(hal::GPIO_Reg::GPFSEL2);
    8224:	e51b3010 	ldr	r3, [fp, #-16]
    8228:	e3a02002 	mov	r2, #2
    822c:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:27
            break;
    8230:	ea00000b 	b	8264 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0xc4>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:29
        case 3:
            reg = static_cast<uint32_t>(hal::GPIO_Reg::GPFSEL3);
    8234:	e51b3010 	ldr	r3, [fp, #-16]
    8238:	e3a02003 	mov	r2, #3
    823c:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:30
            break;
    8240:	ea000007 	b	8264 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0xc4>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:32
        case 4:
            reg = static_cast<uint32_t>(hal::GPIO_Reg::GPFSEL4);
    8244:	e51b3010 	ldr	r3, [fp, #-16]
    8248:	e3a02004 	mov	r2, #4
    824c:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:33
            break;
    8250:	ea000003 	b	8264 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0xc4>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:35
        case 5:
            reg = static_cast<uint32_t>(hal::GPIO_Reg::GPFSEL5);
    8254:	e51b3010 	ldr	r3, [fp, #-16]
    8258:	e3a02005 	mov	r2, #5
    825c:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:36
            break;
    8260:	e320f000 	nop	{0}
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:39
    }

    bit_idx = (pin % 10) * 3;
    8264:	e51b100c 	ldr	r1, [fp, #-12]
    8268:	e59f3040 	ldr	r3, [pc, #64]	; 82b0 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0x110>
    826c:	e0832193 	umull	r2, r3, r3, r1
    8270:	e1a021a3 	lsr	r2, r3, #3
    8274:	e1a03002 	mov	r3, r2
    8278:	e1a03103 	lsl	r3, r3, #2
    827c:	e0833002 	add	r3, r3, r2
    8280:	e1a03083 	lsl	r3, r3, #1
    8284:	e0412003 	sub	r2, r1, r3
    8288:	e1a03002 	mov	r3, r2
    828c:	e1a03083 	lsl	r3, r3, #1
    8290:	e0832002 	add	r2, r3, r2
    8294:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8298:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:41

    return true;
    829c:	e3a03001 	mov	r3, #1
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:42
}
    82a0:	e1a00003 	mov	r0, r3
    82a4:	e28bd000 	add	sp, fp, #0
    82a8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    82ac:	e12fff1e 	bx	lr
    82b0:	cccccccd 	stclgt	12, cr12, [ip], {205}	; 0xcd

000082b4 <_ZNK13CGPIO_Handler18Get_GPCLR_LocationEjRjS0_>:
_ZNK13CGPIO_Handler18Get_GPCLR_LocationEjRjS0_():
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:45

bool CGPIO_Handler::Get_GPCLR_Location(uint32_t pin, uint32_t& reg, uint32_t& bit_idx) const
{
    82b4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    82b8:	e28db000 	add	fp, sp, #0
    82bc:	e24dd014 	sub	sp, sp, #20
    82c0:	e50b0008 	str	r0, [fp, #-8]
    82c4:	e50b100c 	str	r1, [fp, #-12]
    82c8:	e50b2010 	str	r2, [fp, #-16]
    82cc:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:46
    if (pin > hal::GPIO_Pin_Count)
    82d0:	e51b300c 	ldr	r3, [fp, #-12]
    82d4:	e3530036 	cmp	r3, #54	; 0x36
    82d8:	9a000001 	bls	82e4 <_ZNK13CGPIO_Handler18Get_GPCLR_LocationEjRjS0_+0x30>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:47
        return false;
    82dc:	e3a03000 	mov	r3, #0
    82e0:	ea00000c 	b	8318 <_ZNK13CGPIO_Handler18Get_GPCLR_LocationEjRjS0_+0x64>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:49

    reg = static_cast<uint32_t>((pin < 32) ? hal::GPIO_Reg::GPCLR0 : hal::GPIO_Reg::GPCLR1);
    82e4:	e51b300c 	ldr	r3, [fp, #-12]
    82e8:	e353001f 	cmp	r3, #31
    82ec:	8a000001 	bhi	82f8 <_ZNK13CGPIO_Handler18Get_GPCLR_LocationEjRjS0_+0x44>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:49 (discriminator 1)
    82f0:	e3a0200a 	mov	r2, #10
    82f4:	ea000000 	b	82fc <_ZNK13CGPIO_Handler18Get_GPCLR_LocationEjRjS0_+0x48>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:49 (discriminator 2)
    82f8:	e3a0200b 	mov	r2, #11
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:49 (discriminator 4)
    82fc:	e51b3010 	ldr	r3, [fp, #-16]
    8300:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:50 (discriminator 4)
    bit_idx = pin % 32;
    8304:	e51b300c 	ldr	r3, [fp, #-12]
    8308:	e203201f 	and	r2, r3, #31
    830c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8310:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:52 (discriminator 4)

    return true;
    8314:	e3a03001 	mov	r3, #1
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:53
}
    8318:	e1a00003 	mov	r0, r3
    831c:	e28bd000 	add	sp, fp, #0
    8320:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8324:	e12fff1e 	bx	lr

00008328 <_ZNK13CGPIO_Handler18Get_GPSET_LocationEjRjS0_>:
_ZNK13CGPIO_Handler18Get_GPSET_LocationEjRjS0_():
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:56

bool CGPIO_Handler::Get_GPSET_Location(uint32_t pin, uint32_t& reg, uint32_t& bit_idx) const
{
    8328:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    832c:	e28db000 	add	fp, sp, #0
    8330:	e24dd014 	sub	sp, sp, #20
    8334:	e50b0008 	str	r0, [fp, #-8]
    8338:	e50b100c 	str	r1, [fp, #-12]
    833c:	e50b2010 	str	r2, [fp, #-16]
    8340:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:57
    if (pin > hal::GPIO_Pin_Count)
    8344:	e51b300c 	ldr	r3, [fp, #-12]
    8348:	e3530036 	cmp	r3, #54	; 0x36
    834c:	9a000001 	bls	8358 <_ZNK13CGPIO_Handler18Get_GPSET_LocationEjRjS0_+0x30>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:58
        return false;
    8350:	e3a03000 	mov	r3, #0
    8354:	ea00000c 	b	838c <_ZNK13CGPIO_Handler18Get_GPSET_LocationEjRjS0_+0x64>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:60

    reg = static_cast<uint32_t>((pin < 32) ? hal::GPIO_Reg::GPSET0 : hal::GPIO_Reg::GPSET1);
    8358:	e51b300c 	ldr	r3, [fp, #-12]
    835c:	e353001f 	cmp	r3, #31
    8360:	8a000001 	bhi	836c <_ZNK13CGPIO_Handler18Get_GPSET_LocationEjRjS0_+0x44>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:60 (discriminator 1)
    8364:	e3a02007 	mov	r2, #7
    8368:	ea000000 	b	8370 <_ZNK13CGPIO_Handler18Get_GPSET_LocationEjRjS0_+0x48>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:60 (discriminator 2)
    836c:	e3a02008 	mov	r2, #8
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:60 (discriminator 4)
    8370:	e51b3010 	ldr	r3, [fp, #-16]
    8374:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:61 (discriminator 4)
    bit_idx = pin % 32;
    8378:	e51b300c 	ldr	r3, [fp, #-12]
    837c:	e203201f 	and	r2, r3, #31
    8380:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8384:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:63 (discriminator 4)

    return true;
    8388:	e3a03001 	mov	r3, #1
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:64
}
    838c:	e1a00003 	mov	r0, r3
    8390:	e28bd000 	add	sp, fp, #0
    8394:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8398:	e12fff1e 	bx	lr

0000839c <_ZNK13CGPIO_Handler18Get_GPLEV_LocationEjRjS0_>:
_ZNK13CGPIO_Handler18Get_GPLEV_LocationEjRjS0_():
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:67

bool CGPIO_Handler::Get_GPLEV_Location(uint32_t pin, uint32_t& reg, uint32_t& bit_idx) const
{
    839c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    83a0:	e28db000 	add	fp, sp, #0
    83a4:	e24dd014 	sub	sp, sp, #20
    83a8:	e50b0008 	str	r0, [fp, #-8]
    83ac:	e50b100c 	str	r1, [fp, #-12]
    83b0:	e50b2010 	str	r2, [fp, #-16]
    83b4:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:68
    if (pin > hal::GPIO_Pin_Count)
    83b8:	e51b300c 	ldr	r3, [fp, #-12]
    83bc:	e3530036 	cmp	r3, #54	; 0x36
    83c0:	9a000001 	bls	83cc <_ZNK13CGPIO_Handler18Get_GPLEV_LocationEjRjS0_+0x30>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:69
        return false;
    83c4:	e3a03000 	mov	r3, #0
    83c8:	ea00000c 	b	8400 <_ZNK13CGPIO_Handler18Get_GPLEV_LocationEjRjS0_+0x64>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:71

    reg = static_cast<uint32_t>((pin < 32) ? hal::GPIO_Reg::GPLEV0 : hal::GPIO_Reg::GPLEV1);
    83cc:	e51b300c 	ldr	r3, [fp, #-12]
    83d0:	e353001f 	cmp	r3, #31
    83d4:	8a000001 	bhi	83e0 <_ZNK13CGPIO_Handler18Get_GPLEV_LocationEjRjS0_+0x44>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:71 (discriminator 1)
    83d8:	e3a0200d 	mov	r2, #13
    83dc:	ea000000 	b	83e4 <_ZNK13CGPIO_Handler18Get_GPLEV_LocationEjRjS0_+0x48>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:71 (discriminator 2)
    83e0:	e3a0200e 	mov	r2, #14
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:71 (discriminator 4)
    83e4:	e51b3010 	ldr	r3, [fp, #-16]
    83e8:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:72 (discriminator 4)
    bit_idx = pin % 32;
    83ec:	e51b300c 	ldr	r3, [fp, #-12]
    83f0:	e203201f 	and	r2, r3, #31
    83f4:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    83f8:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:74 (discriminator 4)

    return true;
    83fc:	e3a03001 	mov	r3, #1
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:75
}
    8400:	e1a00003 	mov	r0, r3
    8404:	e28bd000 	add	sp, fp, #0
    8408:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    840c:	e12fff1e 	bx	lr

00008410 <_ZN13CGPIO_Handler17Set_GPIO_FunctionEj14NGPIO_Function>:
_ZN13CGPIO_Handler17Set_GPIO_FunctionEj14NGPIO_Function():
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:78

void CGPIO_Handler::Set_GPIO_Function(uint32_t pin, NGPIO_Function func)
{
    8410:	e92d4800 	push	{fp, lr}
    8414:	e28db004 	add	fp, sp, #4
    8418:	e24dd018 	sub	sp, sp, #24
    841c:	e50b0010 	str	r0, [fp, #-16]
    8420:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8424:	e1a03002 	mov	r3, r2
    8428:	e54b3015 	strb	r3, [fp, #-21]	; 0xffffffeb
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:80
    uint32_t reg, bit;
    if (!Get_GPFSEL_Location(pin, reg, bit))
    842c:	e24b300c 	sub	r3, fp, #12
    8430:	e24b2008 	sub	r2, fp, #8
    8434:	e51b1014 	ldr	r1, [fp, #-20]	; 0xffffffec
    8438:	e51b0010 	ldr	r0, [fp, #-16]
    843c:	ebffff57 	bl	81a0 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_>
    8440:	e1a03000 	mov	r3, r0
    8444:	e2233001 	eor	r3, r3, #1
    8448:	e6ef3073 	uxtb	r3, r3
    844c:	e3530000 	cmp	r3, #0
    8450:	1a000015 	bne	84ac <_ZN13CGPIO_Handler17Set_GPIO_FunctionEj14NGPIO_Function+0x9c>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:83
        return;

    mGPIO[reg] = (mGPIO[reg] & (~static_cast<unsigned int>(7 << bit))) | (static_cast<unsigned int>(func) << bit);
    8454:	e51b3010 	ldr	r3, [fp, #-16]
    8458:	e5932000 	ldr	r2, [r3]
    845c:	e51b3008 	ldr	r3, [fp, #-8]
    8460:	e1a03103 	lsl	r3, r3, #2
    8464:	e0823003 	add	r3, r2, r3
    8468:	e5932000 	ldr	r2, [r3]
    846c:	e51b300c 	ldr	r3, [fp, #-12]
    8470:	e3a01007 	mov	r1, #7
    8474:	e1a03311 	lsl	r3, r1, r3
    8478:	e1e03003 	mvn	r3, r3
    847c:	e0021003 	and	r1, r2, r3
    8480:	e55b2015 	ldrb	r2, [fp, #-21]	; 0xffffffeb
    8484:	e51b300c 	ldr	r3, [fp, #-12]
    8488:	e1a02312 	lsl	r2, r2, r3
    848c:	e51b3010 	ldr	r3, [fp, #-16]
    8490:	e5930000 	ldr	r0, [r3]
    8494:	e51b3008 	ldr	r3, [fp, #-8]
    8498:	e1a03103 	lsl	r3, r3, #2
    849c:	e0803003 	add	r3, r0, r3
    84a0:	e1812002 	orr	r2, r1, r2
    84a4:	e5832000 	str	r2, [r3]
    84a8:	ea000000 	b	84b0 <_ZN13CGPIO_Handler17Set_GPIO_FunctionEj14NGPIO_Function+0xa0>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:81
        return;
    84ac:	e320f000 	nop	{0}
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:84
}
    84b0:	e24bd004 	sub	sp, fp, #4
    84b4:	e8bd8800 	pop	{fp, pc}

000084b8 <_ZNK13CGPIO_Handler17Get_GPIO_FunctionEj>:
_ZNK13CGPIO_Handler17Get_GPIO_FunctionEj():
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:87

NGPIO_Function CGPIO_Handler::Get_GPIO_Function(uint32_t pin) const
{
    84b8:	e92d4800 	push	{fp, lr}
    84bc:	e28db004 	add	fp, sp, #4
    84c0:	e24dd010 	sub	sp, sp, #16
    84c4:	e50b0010 	str	r0, [fp, #-16]
    84c8:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:89
    uint32_t reg, bit;
    if (!Get_GPFSEL_Location(pin, reg, bit))
    84cc:	e24b300c 	sub	r3, fp, #12
    84d0:	e24b2008 	sub	r2, fp, #8
    84d4:	e51b1014 	ldr	r1, [fp, #-20]	; 0xffffffec
    84d8:	e51b0010 	ldr	r0, [fp, #-16]
    84dc:	ebffff2f 	bl	81a0 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_>
    84e0:	e1a03000 	mov	r3, r0
    84e4:	e2233001 	eor	r3, r3, #1
    84e8:	e6ef3073 	uxtb	r3, r3
    84ec:	e3530000 	cmp	r3, #0
    84f0:	0a000001 	beq	84fc <_ZNK13CGPIO_Handler17Get_GPIO_FunctionEj+0x44>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:90
        return NGPIO_Function::Unspecified;
    84f4:	e3a03008 	mov	r3, #8
    84f8:	ea00000a 	b	8528 <_ZNK13CGPIO_Handler17Get_GPIO_FunctionEj+0x70>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:92

    return static_cast<NGPIO_Function>((mGPIO[reg] >> bit) & 7);
    84fc:	e51b3010 	ldr	r3, [fp, #-16]
    8500:	e5932000 	ldr	r2, [r3]
    8504:	e51b3008 	ldr	r3, [fp, #-8]
    8508:	e1a03103 	lsl	r3, r3, #2
    850c:	e0823003 	add	r3, r2, r3
    8510:	e5932000 	ldr	r2, [r3]
    8514:	e51b300c 	ldr	r3, [fp, #-12]
    8518:	e1a03332 	lsr	r3, r2, r3
    851c:	e6ef3073 	uxtb	r3, r3
    8520:	e2033007 	and	r3, r3, #7
    8524:	e6ef3073 	uxtb	r3, r3
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:93 (discriminator 1)
}
    8528:	e1a00003 	mov	r0, r3
    852c:	e24bd004 	sub	sp, fp, #4
    8530:	e8bd8800 	pop	{fp, pc}

00008534 <_ZN13CGPIO_Handler19Enable_Event_DetectEj20NGPIO_Interrupt_Type>:
_ZN13CGPIO_Handler19Enable_Event_DetectEj20NGPIO_Interrupt_Type():
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:96

void CGPIO_Handler::Enable_Event_Detect(uint32_t pin, NGPIO_Interrupt_Type type)
{
    8534:	e92d4800 	push	{fp, lr}
    8538:	e28db004 	add	fp, sp, #4
    853c:	e24dd020 	sub	sp, sp, #32
    8540:	e50b0010 	str	r0, [fp, #-16]
    8544:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8548:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:98
    uint32_t reg, bit;
    if (!Get_GP_IRQ_Detect_Location(pin, type, reg, bit))
    854c:	e24b2008 	sub	r2, fp, #8
    8550:	e24b300c 	sub	r3, fp, #12
    8554:	e58d3000 	str	r3, [sp]
    8558:	e1a03002 	mov	r3, r2
    855c:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    8560:	e51b1014 	ldr	r1, [fp, #-20]	; 0xffffffec
    8564:	e51b0010 	ldr	r0, [fp, #-16]
    8568:	eb000012 	bl	85b8 <_ZNK13CGPIO_Handler26Get_GP_IRQ_Detect_LocationEj20NGPIO_Interrupt_TypeRjS1_>
    856c:	e1a03000 	mov	r3, r0
    8570:	e2233001 	eor	r3, r3, #1
    8574:	e6ef3073 	uxtb	r3, r3
    8578:	e3530000 	cmp	r3, #0
    857c:	1a00000a 	bne	85ac <_ZN13CGPIO_Handler19Enable_Event_DetectEj20NGPIO_Interrupt_Type+0x78>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:101
        return;

    mGPIO[reg] = (1 << bit);
    8580:	e51b300c 	ldr	r3, [fp, #-12]
    8584:	e3a02001 	mov	r2, #1
    8588:	e1a01312 	lsl	r1, r2, r3
    858c:	e51b3010 	ldr	r3, [fp, #-16]
    8590:	e5932000 	ldr	r2, [r3]
    8594:	e51b3008 	ldr	r3, [fp, #-8]
    8598:	e1a03103 	lsl	r3, r3, #2
    859c:	e0823003 	add	r3, r2, r3
    85a0:	e1a02001 	mov	r2, r1
    85a4:	e5832000 	str	r2, [r3]
    85a8:	ea000000 	b	85b0 <_ZN13CGPIO_Handler19Enable_Event_DetectEj20NGPIO_Interrupt_Type+0x7c>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:99
        return;
    85ac:	e320f000 	nop	{0}
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:108
    // TODO: vyresit tohle trochu lepe
    // sInterruptCtl.Enable_IRQ(hal::IRQ_Source::GPIO_0);
    // sInterruptCtl.Enable_IRQ(hal::IRQ_Source::GPIO_1);
    // sInterruptCtl.Enable_IRQ(hal::IRQ_Source::GPIO_2);
    // sInterruptCtl.Enable_IRQ(hal::IRQ_Source::GPIO_3);
}
    85b0:	e24bd004 	sub	sp, fp, #4
    85b4:	e8bd8800 	pop	{fp, pc}

000085b8 <_ZNK13CGPIO_Handler26Get_GP_IRQ_Detect_LocationEj20NGPIO_Interrupt_TypeRjS1_>:
_ZNK13CGPIO_Handler26Get_GP_IRQ_Detect_LocationEj20NGPIO_Interrupt_TypeRjS1_():
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:111

bool CGPIO_Handler::Get_GP_IRQ_Detect_Location(uint32_t pin, NGPIO_Interrupt_Type type, uint32_t& reg, uint32_t& bit_idx) const
{
    85b8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    85bc:	e28db000 	add	fp, sp, #0
    85c0:	e24dd014 	sub	sp, sp, #20
    85c4:	e50b0008 	str	r0, [fp, #-8]
    85c8:	e50b100c 	str	r1, [fp, #-12]
    85cc:	e50b2010 	str	r2, [fp, #-16]
    85d0:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:112
    if (pin > hal::GPIO_Pin_Count)
    85d4:	e51b300c 	ldr	r3, [fp, #-12]
    85d8:	e3530036 	cmp	r3, #54	; 0x36
    85dc:	9a000001 	bls	85e8 <_ZNK13CGPIO_Handler26Get_GP_IRQ_Detect_LocationEj20NGPIO_Interrupt_TypeRjS1_+0x30>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:113
        return false;
    85e0:	e3a03000 	mov	r3, #0
    85e4:	ea000032 	b	86b4 <_ZNK13CGPIO_Handler26Get_GP_IRQ_Detect_LocationEj20NGPIO_Interrupt_TypeRjS1_+0xfc>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:115

    bit_idx = pin % 32;
    85e8:	e51b300c 	ldr	r3, [fp, #-12]
    85ec:	e203201f 	and	r2, r3, #31
    85f0:	e59b3004 	ldr	r3, [fp, #4]
    85f4:	e5832000 	str	r2, [r3]
    85f8:	e51b3010 	ldr	r3, [fp, #-16]
    85fc:	e3530003 	cmp	r3, #3
    8600:	979ff103 	ldrls	pc, [pc, r3, lsl #2]
    8604:	ea000027 	b	86a8 <_ZNK13CGPIO_Handler26Get_GP_IRQ_Detect_LocationEj20NGPIO_Interrupt_TypeRjS1_+0xf0>
    8608:	00008618 	andeq	r8, r0, r8, lsl r6
    860c:	0000863c 	andeq	r8, r0, ip, lsr r6
    8610:	00008660 	andeq	r8, r0, r0, ror #12
    8614:	00008684 	andeq	r8, r0, r4, lsl #13
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:120

    switch (type)
    {
        case NGPIO_Interrupt_Type::Rising_Edge:
            reg = static_cast<uint32_t>((pin < 32) ? hal::GPIO_Reg::GPREN0 : hal::GPIO_Reg::GPREN1);
    8618:	e51b300c 	ldr	r3, [fp, #-12]
    861c:	e353001f 	cmp	r3, #31
    8620:	8a000001 	bhi	862c <_ZNK13CGPIO_Handler26Get_GP_IRQ_Detect_LocationEj20NGPIO_Interrupt_TypeRjS1_+0x74>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:120 (discriminator 1)
    8624:	e3a02013 	mov	r2, #19
    8628:	ea000000 	b	8630 <_ZNK13CGPIO_Handler26Get_GP_IRQ_Detect_LocationEj20NGPIO_Interrupt_TypeRjS1_+0x78>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:120 (discriminator 2)
    862c:	e3a02014 	mov	r2, #20
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:120 (discriminator 4)
    8630:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8634:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:121 (discriminator 4)
            break;
    8638:	ea00001c 	b	86b0 <_ZNK13CGPIO_Handler26Get_GP_IRQ_Detect_LocationEj20NGPIO_Interrupt_TypeRjS1_+0xf8>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:123
        case NGPIO_Interrupt_Type::Falling_Edge:
            reg = static_cast<uint32_t>((pin < 32) ? hal::GPIO_Reg::GPFEN0 : hal::GPIO_Reg::GPFEN1);
    863c:	e51b300c 	ldr	r3, [fp, #-12]
    8640:	e353001f 	cmp	r3, #31
    8644:	8a000001 	bhi	8650 <_ZNK13CGPIO_Handler26Get_GP_IRQ_Detect_LocationEj20NGPIO_Interrupt_TypeRjS1_+0x98>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:123 (discriminator 1)
    8648:	e3a02016 	mov	r2, #22
    864c:	ea000000 	b	8654 <_ZNK13CGPIO_Handler26Get_GP_IRQ_Detect_LocationEj20NGPIO_Interrupt_TypeRjS1_+0x9c>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:123 (discriminator 2)
    8650:	e3a02017 	mov	r2, #23
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:123 (discriminator 4)
    8654:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8658:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:124 (discriminator 4)
            break;
    865c:	ea000013 	b	86b0 <_ZNK13CGPIO_Handler26Get_GP_IRQ_Detect_LocationEj20NGPIO_Interrupt_TypeRjS1_+0xf8>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:126
        case NGPIO_Interrupt_Type::High:
            reg = static_cast<uint32_t>((pin < 32) ? hal::GPIO_Reg::GPHEN0 : hal::GPIO_Reg::GPHEN1);
    8660:	e51b300c 	ldr	r3, [fp, #-12]
    8664:	e353001f 	cmp	r3, #31
    8668:	8a000001 	bhi	8674 <_ZNK13CGPIO_Handler26Get_GP_IRQ_Detect_LocationEj20NGPIO_Interrupt_TypeRjS1_+0xbc>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:126 (discriminator 1)
    866c:	e3a02019 	mov	r2, #25
    8670:	ea000000 	b	8678 <_ZNK13CGPIO_Handler26Get_GP_IRQ_Detect_LocationEj20NGPIO_Interrupt_TypeRjS1_+0xc0>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:126 (discriminator 2)
    8674:	e3a0201a 	mov	r2, #26
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:126 (discriminator 4)
    8678:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    867c:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:127 (discriminator 4)
            break;
    8680:	ea00000a 	b	86b0 <_ZNK13CGPIO_Handler26Get_GP_IRQ_Detect_LocationEj20NGPIO_Interrupt_TypeRjS1_+0xf8>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:129
        case NGPIO_Interrupt_Type::Low:
            reg = static_cast<uint32_t>((pin < 32) ? hal::GPIO_Reg::GPLEN0 : hal::GPIO_Reg::GPLEN1);
    8684:	e51b300c 	ldr	r3, [fp, #-12]
    8688:	e353001f 	cmp	r3, #31
    868c:	8a000001 	bhi	8698 <_ZNK13CGPIO_Handler26Get_GP_IRQ_Detect_LocationEj20NGPIO_Interrupt_TypeRjS1_+0xe0>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:129 (discriminator 1)
    8690:	e3a0201c 	mov	r2, #28
    8694:	ea000000 	b	869c <_ZNK13CGPIO_Handler26Get_GP_IRQ_Detect_LocationEj20NGPIO_Interrupt_TypeRjS1_+0xe4>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:129 (discriminator 2)
    8698:	e3a0201d 	mov	r2, #29
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:129 (discriminator 4)
    869c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    86a0:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:130 (discriminator 4)
            break;
    86a4:	ea000001 	b	86b0 <_ZNK13CGPIO_Handler26Get_GP_IRQ_Detect_LocationEj20NGPIO_Interrupt_TypeRjS1_+0xf8>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:132
        default:
            return false;
    86a8:	e3a03000 	mov	r3, #0
    86ac:	ea000000 	b	86b4 <_ZNK13CGPIO_Handler26Get_GP_IRQ_Detect_LocationEj20NGPIO_Interrupt_TypeRjS1_+0xfc>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:135
    }

    return true;
    86b0:	e3a03001 	mov	r3, #1
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:136
}
    86b4:	e1a00003 	mov	r0, r3
    86b8:	e28bd000 	add	sp, fp, #0
    86bc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    86c0:	e12fff1e 	bx	lr

000086c4 <_ZN13CGPIO_Handler20Disable_Event_DetectEj20NGPIO_Interrupt_Type>:
_ZN13CGPIO_Handler20Disable_Event_DetectEj20NGPIO_Interrupt_Type():
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:139

void CGPIO_Handler::Disable_Event_Detect(uint32_t pin, NGPIO_Interrupt_Type type)
{
    86c4:	e92d4800 	push	{fp, lr}
    86c8:	e28db004 	add	fp, sp, #4
    86cc:	e24dd028 	sub	sp, sp, #40	; 0x28
    86d0:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    86d4:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    86d8:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:141
    uint32_t reg, bit;
    if (!Get_GP_IRQ_Detect_Location(pin, type, reg, bit))
    86dc:	e24b200c 	sub	r2, fp, #12
    86e0:	e24b3010 	sub	r3, fp, #16
    86e4:	e58d3000 	str	r3, [sp]
    86e8:	e1a03002 	mov	r3, r2
    86ec:	e51b2020 	ldr	r2, [fp, #-32]	; 0xffffffe0
    86f0:	e51b101c 	ldr	r1, [fp, #-28]	; 0xffffffe4
    86f4:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    86f8:	ebffffae 	bl	85b8 <_ZNK13CGPIO_Handler26Get_GP_IRQ_Detect_LocationEj20NGPIO_Interrupt_TypeRjS1_>
    86fc:	e1a03000 	mov	r3, r0
    8700:	e2233001 	eor	r3, r3, #1
    8704:	e6ef3073 	uxtb	r3, r3
    8708:	e3530000 	cmp	r3, #0
    870c:	1a000016 	bne	876c <_ZN13CGPIO_Handler20Disable_Event_DetectEj20NGPIO_Interrupt_Type+0xa8>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:144
        return;

    uint32_t val = mGPIO[reg];
    8710:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8714:	e5932000 	ldr	r2, [r3]
    8718:	e51b300c 	ldr	r3, [fp, #-12]
    871c:	e1a03103 	lsl	r3, r3, #2
    8720:	e0823003 	add	r3, r2, r3
    8724:	e5933000 	ldr	r3, [r3]
    8728:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:145
    val &= ~(1 << bit);
    872c:	e51b3010 	ldr	r3, [fp, #-16]
    8730:	e3a02001 	mov	r2, #1
    8734:	e1a03312 	lsl	r3, r2, r3
    8738:	e1e03003 	mvn	r3, r3
    873c:	e1a02003 	mov	r2, r3
    8740:	e51b3008 	ldr	r3, [fp, #-8]
    8744:	e0033002 	and	r3, r3, r2
    8748:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:146
    mGPIO[reg] = val;
    874c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8750:	e5932000 	ldr	r2, [r3]
    8754:	e51b300c 	ldr	r3, [fp, #-12]
    8758:	e1a03103 	lsl	r3, r3, #2
    875c:	e0823003 	add	r3, r2, r3
    8760:	e51b2008 	ldr	r2, [fp, #-8]
    8764:	e5832000 	str	r2, [r3]
    8768:	ea000000 	b	8770 <_ZN13CGPIO_Handler20Disable_Event_DetectEj20NGPIO_Interrupt_Type+0xac>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:142
        return;
    876c:	e320f000 	nop	{0}
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:147
}
    8770:	e24bd004 	sub	sp, fp, #4
    8774:	e8bd8800 	pop	{fp, pc}

00008778 <_ZN13CGPIO_Handler10Set_OutputEjb>:
_ZN13CGPIO_Handler10Set_OutputEjb():
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:150

void CGPIO_Handler::Set_Output(uint32_t pin, bool set)
{
    8778:	e92d4800 	push	{fp, lr}
    877c:	e28db004 	add	fp, sp, #4
    8780:	e24dd018 	sub	sp, sp, #24
    8784:	e50b0010 	str	r0, [fp, #-16]
    8788:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    878c:	e1a03002 	mov	r3, r2
    8790:	e54b3015 	strb	r3, [fp, #-21]	; 0xffffffeb
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:152
    uint32_t reg, bit;
    if (!(set && Get_GPSET_Location(pin, reg, bit)) && !(!set && Get_GPCLR_Location(pin, reg, bit)))
    8794:	e55b3015 	ldrb	r3, [fp, #-21]	; 0xffffffeb
    8798:	e2233001 	eor	r3, r3, #1
    879c:	e6ef3073 	uxtb	r3, r3
    87a0:	e3530000 	cmp	r3, #0
    87a4:	1a000009 	bne	87d0 <_ZN13CGPIO_Handler10Set_OutputEjb+0x58>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:152 (discriminator 2)
    87a8:	e24b300c 	sub	r3, fp, #12
    87ac:	e24b2008 	sub	r2, fp, #8
    87b0:	e51b1014 	ldr	r1, [fp, #-20]	; 0xffffffec
    87b4:	e51b0010 	ldr	r0, [fp, #-16]
    87b8:	ebfffeda 	bl	8328 <_ZNK13CGPIO_Handler18Get_GPSET_LocationEjRjS0_>
    87bc:	e1a03000 	mov	r3, r0
    87c0:	e2233001 	eor	r3, r3, #1
    87c4:	e6ef3073 	uxtb	r3, r3
    87c8:	e3530000 	cmp	r3, #0
    87cc:	0a00000e 	beq	880c <_ZN13CGPIO_Handler10Set_OutputEjb+0x94>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:152 (discriminator 3)
    87d0:	e55b3015 	ldrb	r3, [fp, #-21]	; 0xffffffeb
    87d4:	e3530000 	cmp	r3, #0
    87d8:	1a000009 	bne	8804 <_ZN13CGPIO_Handler10Set_OutputEjb+0x8c>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:152 (discriminator 6)
    87dc:	e24b300c 	sub	r3, fp, #12
    87e0:	e24b2008 	sub	r2, fp, #8
    87e4:	e51b1014 	ldr	r1, [fp, #-20]	; 0xffffffec
    87e8:	e51b0010 	ldr	r0, [fp, #-16]
    87ec:	ebfffeb0 	bl	82b4 <_ZNK13CGPIO_Handler18Get_GPCLR_LocationEjRjS0_>
    87f0:	e1a03000 	mov	r3, r0
    87f4:	e2233001 	eor	r3, r3, #1
    87f8:	e6ef3073 	uxtb	r3, r3
    87fc:	e3530000 	cmp	r3, #0
    8800:	0a000001 	beq	880c <_ZN13CGPIO_Handler10Set_OutputEjb+0x94>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:152 (discriminator 7)
    8804:	e3a03001 	mov	r3, #1
    8808:	ea000000 	b	8810 <_ZN13CGPIO_Handler10Set_OutputEjb+0x98>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:152 (discriminator 8)
    880c:	e3a03000 	mov	r3, #0
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:152 (discriminator 10)
    8810:	e3530000 	cmp	r3, #0
    8814:	1a00000a 	bne	8844 <_ZN13CGPIO_Handler10Set_OutputEjb+0xcc>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:155
        return;

    mGPIO[reg] = (1 << bit);
    8818:	e51b300c 	ldr	r3, [fp, #-12]
    881c:	e3a02001 	mov	r2, #1
    8820:	e1a01312 	lsl	r1, r2, r3
    8824:	e51b3010 	ldr	r3, [fp, #-16]
    8828:	e5932000 	ldr	r2, [r3]
    882c:	e51b3008 	ldr	r3, [fp, #-8]
    8830:	e1a03103 	lsl	r3, r3, #2
    8834:	e0823003 	add	r3, r2, r3
    8838:	e1a02001 	mov	r2, r1
    883c:	e5832000 	str	r2, [r3]
    8840:	ea000000 	b	8848 <_ZN13CGPIO_Handler10Set_OutputEjb+0xd0>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:153
        return;
    8844:	e320f000 	nop	{0}
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:156
}
    8848:	e24bd004 	sub	sp, fp, #4
    884c:	e8bd8800 	pop	{fp, pc}

00008850 <_ZNK13CGPIO_Handler18Get_GPEDS_LocationEjRjS0_>:
_ZNK13CGPIO_Handler18Get_GPEDS_LocationEjRjS0_():
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:159

bool CGPIO_Handler::Get_GPEDS_Location(uint32_t pin, uint32_t& reg, uint32_t& bit_idx) const
{
    8850:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8854:	e28db000 	add	fp, sp, #0
    8858:	e24dd014 	sub	sp, sp, #20
    885c:	e50b0008 	str	r0, [fp, #-8]
    8860:	e50b100c 	str	r1, [fp, #-12]
    8864:	e50b2010 	str	r2, [fp, #-16]
    8868:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:160
    if (pin > hal::GPIO_Pin_Count)
    886c:	e51b300c 	ldr	r3, [fp, #-12]
    8870:	e3530036 	cmp	r3, #54	; 0x36
    8874:	9a000001 	bls	8880 <_ZNK13CGPIO_Handler18Get_GPEDS_LocationEjRjS0_+0x30>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:161
        return false;
    8878:	e3a03000 	mov	r3, #0
    887c:	ea00000c 	b	88b4 <_ZNK13CGPIO_Handler18Get_GPEDS_LocationEjRjS0_+0x64>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:163

    reg = static_cast<uint32_t>((pin < 32) ? hal::GPIO_Reg::GPEDS0 : hal::GPIO_Reg::GPEDS1);
    8880:	e51b300c 	ldr	r3, [fp, #-12]
    8884:	e353001f 	cmp	r3, #31
    8888:	8a000001 	bhi	8894 <_ZNK13CGPIO_Handler18Get_GPEDS_LocationEjRjS0_+0x44>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:163 (discriminator 1)
    888c:	e3a02010 	mov	r2, #16
    8890:	ea000000 	b	8898 <_ZNK13CGPIO_Handler18Get_GPEDS_LocationEjRjS0_+0x48>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:163 (discriminator 2)
    8894:	e3a02011 	mov	r2, #17
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:163 (discriminator 4)
    8898:	e51b3010 	ldr	r3, [fp, #-16]
    889c:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:164 (discriminator 4)
    bit_idx = pin % 32;
    88a0:	e51b300c 	ldr	r3, [fp, #-12]
    88a4:	e203201f 	and	r2, r3, #31
    88a8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    88ac:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:166 (discriminator 4)

    return true;
    88b0:	e3a03001 	mov	r3, #1
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:167
}
    88b4:	e1a00003 	mov	r0, r3
    88b8:	e28bd000 	add	sp, fp, #0
    88bc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    88c0:	e12fff1e 	bx	lr

000088c4 <_ZN13CGPIO_Handler20Clear_Detected_EventEj>:
_ZN13CGPIO_Handler20Clear_Detected_EventEj():
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:170

void CGPIO_Handler::Clear_Detected_Event(uint32_t pin)
{
    88c4:	e92d4800 	push	{fp, lr}
    88c8:	e28db004 	add	fp, sp, #4
    88cc:	e24dd010 	sub	sp, sp, #16
    88d0:	e50b0010 	str	r0, [fp, #-16]
    88d4:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:172
    uint32_t reg, bit;
    if (!Get_GPEDS_Location(pin, reg, bit))
    88d8:	e24b300c 	sub	r3, fp, #12
    88dc:	e24b2008 	sub	r2, fp, #8
    88e0:	e51b1014 	ldr	r1, [fp, #-20]	; 0xffffffec
    88e4:	e51b0010 	ldr	r0, [fp, #-16]
    88e8:	ebffffd8 	bl	8850 <_ZNK13CGPIO_Handler18Get_GPEDS_LocationEjRjS0_>
    88ec:	e1a03000 	mov	r3, r0
    88f0:	e2233001 	eor	r3, r3, #1
    88f4:	e6ef3073 	uxtb	r3, r3
    88f8:	e3530000 	cmp	r3, #0
    88fc:	1a00000a 	bne	892c <_ZN13CGPIO_Handler20Clear_Detected_EventEj+0x68>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:176
        return;

    // BCM2835 manual: "The bit is cleared by writing a '1' to the relevant bit."
    mGPIO[reg] = 1 << bit;
    8900:	e51b300c 	ldr	r3, [fp, #-12]
    8904:	e3a02001 	mov	r2, #1
    8908:	e1a01312 	lsl	r1, r2, r3
    890c:	e51b3010 	ldr	r3, [fp, #-16]
    8910:	e5932000 	ldr	r2, [r3]
    8914:	e51b3008 	ldr	r3, [fp, #-8]
    8918:	e1a03103 	lsl	r3, r3, #2
    891c:	e0823003 	add	r3, r2, r3
    8920:	e1a02001 	mov	r2, r1
    8924:	e5832000 	str	r2, [r3]
    8928:	ea000000 	b	8930 <_ZN13CGPIO_Handler20Clear_Detected_EventEj+0x6c>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:173
        return;
    892c:	e320f000 	nop	{0}
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:177
    8930:	e24bd004 	sub	sp, fp, #4
    8934:	e8bd8800 	pop	{fp, pc}

00008938 <_Z41__static_initialization_and_destruction_0ii>:
_Z41__static_initialization_and_destruction_0ii():
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:177
    8938:	e92d4800 	push	{fp, lr}
    893c:	e28db004 	add	fp, sp, #4
    8940:	e24dd008 	sub	sp, sp, #8
    8944:	e50b0008 	str	r0, [fp, #-8]
    8948:	e50b100c 	str	r1, [fp, #-12]
    894c:	e51b3008 	ldr	r3, [fp, #-8]
    8950:	e3530001 	cmp	r3, #1
    8954:	1a000006 	bne	8974 <_Z41__static_initialization_and_destruction_0ii+0x3c>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:177 (discriminator 1)
    8958:	e51b300c 	ldr	r3, [fp, #-12]
    895c:	e59f201c 	ldr	r2, [pc, #28]	; 8980 <_Z41__static_initialization_and_destruction_0ii+0x48>
    8960:	e1530002 	cmp	r3, r2
    8964:	1a000002 	bne	8974 <_Z41__static_initialization_and_destruction_0ii+0x3c>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:4
CGPIO_Handler sGPIO(hal::GPIO_Base);
    8968:	e59f1014 	ldr	r1, [pc, #20]	; 8984 <_Z41__static_initialization_and_destruction_0ii+0x4c>
    896c:	e59f0014 	ldr	r0, [pc, #20]	; 8988 <_Z41__static_initialization_and_destruction_0ii+0x50>
    8970:	ebfffdfd 	bl	816c <_ZN13CGPIO_HandlerC1Ej>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:177
    8974:	e320f000 	nop	{0}
    8978:	e24bd004 	sub	sp, fp, #4
    897c:	e8bd8800 	pop	{fp, pc}
    8980:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>
    8984:	20200000 	eorcs	r0, r0, r0
    8988:	00009224 	andeq	r9, r0, r4, lsr #4

0000898c <_GLOBAL__sub_I_sGPIO>:
_GLOBAL__sub_I_sGPIO():
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/gpio.cpp:177
    898c:	e92d4800 	push	{fp, lr}
    8990:	e28db004 	add	fp, sp, #4
    8994:	e59f1008 	ldr	r1, [pc, #8]	; 89a4 <_GLOBAL__sub_I_sGPIO+0x18>
    8998:	e3a00001 	mov	r0, #1
    899c:	ebffffe5 	bl	8938 <_Z41__static_initialization_and_destruction_0ii>
    89a0:	e8bd8800 	pop	{fp, pc}
    89a4:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>

000089a8 <_ZN6CTimerC1Em>:
_ZN6CTimerC2Em():
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/timer.cpp:26
    uint16_t unused_4 : 10;
};

#pragma pack(pop)

CTimer::CTimer(unsigned long timer_reg_base)
    89a8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    89ac:	e28db000 	add	fp, sp, #0
    89b0:	e24dd00c 	sub	sp, sp, #12
    89b4:	e50b0008 	str	r0, [fp, #-8]
    89b8:	e50b100c 	str	r1, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/timer.cpp:27
: mTimer_Regs(reinterpret_cast<unsigned int*>(timer_reg_base))
    89bc:	e51b200c 	ldr	r2, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/timer.cpp:28
, mCallback(nullptr)
    89c0:	e51b3008 	ldr	r3, [fp, #-8]
    89c4:	e5832000 	str	r2, [r3]
    89c8:	e51b3008 	ldr	r3, [fp, #-8]
    89cc:	e3a02000 	mov	r2, #0
    89d0:	e5832004 	str	r2, [r3, #4]
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/timer.cpp:31
{
    //
}
    89d4:	e51b3008 	ldr	r3, [fp, #-8]
    89d8:	e1a00003 	mov	r0, r3
    89dc:	e28bd000 	add	sp, fp, #0
    89e0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    89e4:	e12fff1e 	bx	lr

000089e8 <_ZN6CTimer4RegsEN3hal9Timer_RegE>:
_ZN6CTimer4RegsEN3hal9Timer_RegE():
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/timer.cpp:34

volatile unsigned int& CTimer::Regs(hal::Timer_Reg reg)
{
    89e8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    89ec:	e28db000 	add	fp, sp, #0
    89f0:	e24dd00c 	sub	sp, sp, #12
    89f4:	e50b0008 	str	r0, [fp, #-8]
    89f8:	e50b100c 	str	r1, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/timer.cpp:35
    return mTimer_Regs[static_cast<unsigned int>(reg)];
    89fc:	e51b3008 	ldr	r3, [fp, #-8]
    8a00:	e5932000 	ldr	r2, [r3]
    8a04:	e51b300c 	ldr	r3, [fp, #-12]
    8a08:	e1a03103 	lsl	r3, r3, #2
    8a0c:	e0823003 	add	r3, r2, r3
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/timer.cpp:36
}
    8a10:	e1a00003 	mov	r0, r3
    8a14:	e28bd000 	add	sp, fp, #0
    8a18:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8a1c:	e12fff1e 	bx	lr

00008a20 <_ZN6CTimer6EnableEPFvvEj16NTimer_Prescaler>:
_ZN6CTimer6EnableEPFvvEj16NTimer_Prescaler():
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/timer.cpp:39

void CTimer::Enable(TTimer_Callback callback, unsigned int delay, NTimer_Prescaler prescaler)
{
    8a20:	e92d4810 	push	{r4, fp, lr}
    8a24:	e28db008 	add	fp, sp, #8
    8a28:	e24dd01c 	sub	sp, sp, #28
    8a2c:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8a30:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    8a34:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    8a38:	e54b3021 	strb	r3, [fp, #-33]	; 0xffffffdf
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/timer.cpp:40
    Regs(hal::Timer_Reg::Load) = delay;
    8a3c:	e3a01000 	mov	r1, #0
    8a40:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    8a44:	ebffffe7 	bl	89e8 <_ZN6CTimer4RegsEN3hal9Timer_RegE>
    8a48:	e1a02000 	mov	r2, r0
    8a4c:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8a50:	e5823000 	str	r3, [r2]
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/timer.cpp:43

    TTimer_Ctl_Flags reg;
    reg.counter_32b = 1;
    8a54:	e55b3014 	ldrb	r3, [fp, #-20]	; 0xffffffec
    8a58:	e3833002 	orr	r3, r3, #2
    8a5c:	e54b3014 	strb	r3, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/timer.cpp:44
    reg.interrupt_enabled = 1;
    8a60:	e55b3014 	ldrb	r3, [fp, #-20]	; 0xffffffec
    8a64:	e3833020 	orr	r3, r3, #32
    8a68:	e54b3014 	strb	r3, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/timer.cpp:45
    reg.timer_enabled = 1;
    8a6c:	e55b3014 	ldrb	r3, [fp, #-20]	; 0xffffffec
    8a70:	e3833080 	orr	r3, r3, #128	; 0x80
    8a74:	e54b3014 	strb	r3, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/timer.cpp:46
    reg.prescaler = static_cast<uint8_t>(prescaler);
    8a78:	e55b3021 	ldrb	r3, [fp, #-33]	; 0xffffffdf
    8a7c:	e2033003 	and	r3, r3, #3
    8a80:	e6ef3073 	uxtb	r3, r3
    8a84:	e55b2014 	ldrb	r2, [fp, #-20]	; 0xffffffec
    8a88:	e2033003 	and	r3, r3, #3
    8a8c:	e3c2200c 	bic	r2, r2, #12
    8a90:	e1a03103 	lsl	r3, r3, #2
    8a94:	e1833002 	orr	r3, r3, r2
    8a98:	e1a02003 	mov	r2, r3
    8a9c:	e54b2014 	strb	r2, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/timer.cpp:48

    Regs(hal::Timer_Reg::Control) = *reinterpret_cast<unsigned int*>(&reg);
    8aa0:	e24b4014 	sub	r4, fp, #20
    8aa4:	e3a01002 	mov	r1, #2
    8aa8:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    8aac:	ebffffcd 	bl	89e8 <_ZN6CTimer4RegsEN3hal9Timer_RegE>
    8ab0:	e1a02000 	mov	r2, r0
    8ab4:	e5943000 	ldr	r3, [r4]
    8ab8:	e5823000 	str	r3, [r2]
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/timer.cpp:50

    Regs(hal::Timer_Reg::IRQ_Clear) = 1;
    8abc:	e3a01003 	mov	r1, #3
    8ac0:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    8ac4:	ebffffc7 	bl	89e8 <_ZN6CTimer4RegsEN3hal9Timer_RegE>
    8ac8:	e1a03000 	mov	r3, r0
    8acc:	e3a02001 	mov	r2, #1
    8ad0:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/timer.cpp:52

    mCallback = callback;
    8ad4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8ad8:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8adc:	e5832004 	str	r2, [r3, #4]
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/timer.cpp:53
}
    8ae0:	e320f000 	nop	{0}
    8ae4:	e24bd008 	sub	sp, fp, #8
    8ae8:	e8bd8810 	pop	{r4, fp, pc}

00008aec <_ZN6CTimer7DisableEv>:
_ZN6CTimer7DisableEv():
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/timer.cpp:56

void CTimer::Disable()
{
    8aec:	e92d4800 	push	{fp, lr}
    8af0:	e28db004 	add	fp, sp, #4
    8af4:	e24dd010 	sub	sp, sp, #16
    8af8:	e50b0010 	str	r0, [fp, #-16]
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/timer.cpp:57
    volatile TTimer_Ctl_Flags& reg = reinterpret_cast<volatile TTimer_Ctl_Flags&>(Regs(hal::Timer_Reg::Control));
    8afc:	e3a01002 	mov	r1, #2
    8b00:	e51b0010 	ldr	r0, [fp, #-16]
    8b04:	ebffffb7 	bl	89e8 <_ZN6CTimer4RegsEN3hal9Timer_RegE>
    8b08:	e50b0008 	str	r0, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/timer.cpp:59

    reg.interrupt_enabled = 0;
    8b0c:	e51b2008 	ldr	r2, [fp, #-8]
    8b10:	e5d23000 	ldrb	r3, [r2]
    8b14:	e3c33020 	bic	r3, r3, #32
    8b18:	e5c23000 	strb	r3, [r2]
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/timer.cpp:60
    reg.timer_enabled = 0;
    8b1c:	e51b2008 	ldr	r2, [fp, #-8]
    8b20:	e5d23000 	ldrb	r3, [r2]
    8b24:	e3c33080 	bic	r3, r3, #128	; 0x80
    8b28:	e5c23000 	strb	r3, [r2]
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/timer.cpp:61
}
    8b2c:	e320f000 	nop	{0}
    8b30:	e24bd004 	sub	sp, fp, #4
    8b34:	e8bd8800 	pop	{fp, pc}

00008b38 <_ZN6CTimer12IRQ_CallbackEv>:
_ZN6CTimer12IRQ_CallbackEv():
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/timer.cpp:64

void CTimer::IRQ_Callback()
{
    8b38:	e92d4800 	push	{fp, lr}
    8b3c:	e28db004 	add	fp, sp, #4
    8b40:	e24dd008 	sub	sp, sp, #8
    8b44:	e50b0008 	str	r0, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/timer.cpp:67
    // Regs(hal::Timer_Reg::IRQ_Clear) = 1;

    if (mCallback)
    8b48:	e51b3008 	ldr	r3, [fp, #-8]
    8b4c:	e5933004 	ldr	r3, [r3, #4]
    8b50:	e3530000 	cmp	r3, #0
    8b54:	0a000002 	beq	8b64 <_ZN6CTimer12IRQ_CallbackEv+0x2c>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/timer.cpp:68
        mCallback();
    8b58:	e51b3008 	ldr	r3, [fp, #-8]
    8b5c:	e5933004 	ldr	r3, [r3, #4]
    8b60:	e12fff33 	blx	r3
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/timer.cpp:69
}
    8b64:	e320f000 	nop	{0}
    8b68:	e24bd004 	sub	sp, fp, #4
    8b6c:	e8bd8800 	pop	{fp, pc}

00008b70 <_ZN6CTimer20Is_Timer_IRQ_PendingEv>:
_ZN6CTimer20Is_Timer_IRQ_PendingEv():
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/timer.cpp:72

bool CTimer::Is_Timer_IRQ_Pending()
{
    8b70:	e92d4800 	push	{fp, lr}
    8b74:	e28db004 	add	fp, sp, #4
    8b78:	e24dd008 	sub	sp, sp, #8
    8b7c:	e50b0008 	str	r0, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/timer.cpp:73
    return Regs(hal::Timer_Reg::IRQ_Masked);
    8b80:	e3a01005 	mov	r1, #5
    8b84:	e51b0008 	ldr	r0, [fp, #-8]
    8b88:	ebffff96 	bl	89e8 <_ZN6CTimer4RegsEN3hal9Timer_RegE>
    8b8c:	e1a03000 	mov	r3, r0
    8b90:	e5933000 	ldr	r3, [r3]
    8b94:	e3530000 	cmp	r3, #0
    8b98:	13a03001 	movne	r3, #1
    8b9c:	03a03000 	moveq	r3, #0
    8ba0:	e6ef3073 	uxtb	r3, r3
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/timer.cpp:74
}
    8ba4:	e1a00003 	mov	r0, r3
    8ba8:	e24bd004 	sub	sp, fp, #4
    8bac:	e8bd8800 	pop	{fp, pc}

00008bb0 <_Z41__static_initialization_and_destruction_0ii>:
_Z41__static_initialization_and_destruction_0ii():
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/timer.cpp:74
    8bb0:	e92d4800 	push	{fp, lr}
    8bb4:	e28db004 	add	fp, sp, #4
    8bb8:	e24dd008 	sub	sp, sp, #8
    8bbc:	e50b0008 	str	r0, [fp, #-8]
    8bc0:	e50b100c 	str	r1, [fp, #-12]
    8bc4:	e51b3008 	ldr	r3, [fp, #-8]
    8bc8:	e3530001 	cmp	r3, #1
    8bcc:	1a000006 	bne	8bec <_Z41__static_initialization_and_destruction_0ii+0x3c>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/timer.cpp:74 (discriminator 1)
    8bd0:	e51b300c 	ldr	r3, [fp, #-12]
    8bd4:	e59f201c 	ldr	r2, [pc, #28]	; 8bf8 <_Z41__static_initialization_and_destruction_0ii+0x48>
    8bd8:	e1530002 	cmp	r3, r2
    8bdc:	1a000002 	bne	8bec <_Z41__static_initialization_and_destruction_0ii+0x3c>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/timer.cpp:4
CTimer sTimer(hal::Timer_Base);
    8be0:	e59f1014 	ldr	r1, [pc, #20]	; 8bfc <_Z41__static_initialization_and_destruction_0ii+0x4c>
    8be4:	e59f0014 	ldr	r0, [pc, #20]	; 8c00 <_Z41__static_initialization_and_destruction_0ii+0x50>
    8be8:	ebffff6e 	bl	89a8 <_ZN6CTimerC1Em>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/timer.cpp:74
}
    8bec:	e320f000 	nop	{0}
    8bf0:	e24bd004 	sub	sp, fp, #4
    8bf4:	e8bd8800 	pop	{fp, pc}
    8bf8:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>
    8bfc:	2000b400 	andcs	fp, r0, r0, lsl #8
    8c00:	00009228 	andeq	r9, r0, r8, lsr #4

00008c04 <_GLOBAL__sub_I_sTimer>:
_GLOBAL__sub_I_sTimer():
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/drivers/timer.cpp:74
    8c04:	e92d4800 	push	{fp, lr}
    8c08:	e28db004 	add	fp, sp, #4
    8c0c:	e59f1008 	ldr	r1, [pc, #8]	; 8c1c <_GLOBAL__sub_I_sTimer+0x18>
    8c10:	e3a00001 	mov	r0, #1
    8c14:	ebffffe5 	bl	8bb0 <_Z41__static_initialization_and_destruction_0ii>
    8c18:	e8bd8800 	pop	{fp, pc}
    8c1c:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>

00008c20 <software_interrupt_handler>:
software_interrupt_handler():
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/interrupt_controller.cpp:8
#include <drivers/gpio.h>
#include <interrupt_controller.h>
#include <drivers/timer.h>

extern "C" void __attribute__((interrupt("SWI"))) software_interrupt_handler()
{
    8c20:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8c24:	e28db000 	add	fp, sp, #0
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/interrupt_controller.cpp:9
}
    8c28:	e320f000 	nop	{0}
    8c2c:	e28bd000 	add	sp, fp, #0
    8c30:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8c34:	e1b0f00e 	movs	pc, lr

00008c38 <irq_handler>:
irq_handler():
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/interrupt_controller.cpp:12

extern "C" void __attribute__((interrupt("IRQ"))) irq_handler()
{
    8c38:	e24ee004 	sub	lr, lr, #4
    8c3c:	e92d581f 	push	{r0, r1, r2, r3, r4, fp, ip, lr}
    8c40:	e28db01c 	add	fp, sp, #28
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/interrupt_controller.cpp:13
    if (sTimer.Is_Timer_IRQ_Pending())
    8c44:	e59f0020 	ldr	r0, [pc, #32]	; 8c6c <irq_handler+0x34>
    8c48:	ebffffc8 	bl	8b70 <_ZN6CTimer20Is_Timer_IRQ_PendingEv>
    8c4c:	e1a03000 	mov	r3, r0
    8c50:	e3530000 	cmp	r3, #0
    8c54:	0a000001 	beq	8c60 <irq_handler+0x28>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/interrupt_controller.cpp:14
        sTimer.IRQ_Callback();
    8c58:	e59f000c 	ldr	r0, [pc, #12]	; 8c6c <irq_handler+0x34>
    8c5c:	ebffffb5 	bl	8b38 <_ZN6CTimer12IRQ_CallbackEv>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/interrupt_controller.cpp:15
}
    8c60:	e320f000 	nop	{0}
    8c64:	e24bd01c 	sub	sp, fp, #28
    8c68:	e8fd981f 	ldm	sp!, {r0, r1, r2, r3, r4, fp, ip, pc}^
    8c6c:	00009228 	andeq	r9, r0, r8, lsr #4

00008c70 <fast_interrupt_handler>:
fast_interrupt_handler():
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/interrupt_controller.cpp:18

extern "C" void __attribute__((interrupt("FIQ"))) fast_interrupt_handler()
{
    8c70:	e24db004 	sub	fp, sp, #4
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/interrupt_controller.cpp:19
}
    8c74:	e320f000 	nop	{0}
    8c78:	e28bd004 	add	sp, fp, #4
    8c7c:	e25ef004 	subs	pc, lr, #4

00008c80 <_ZN21CInterrupt_ControllerC1Em>:
_ZN21CInterrupt_ControllerC2Em():
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/interrupt_controller.cpp:23

CInterrupt_Controller sInterruptCtl(hal::Interrupt_Controller_Base);

CInterrupt_Controller::CInterrupt_Controller(unsigned long base)
    8c80:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8c84:	e28db000 	add	fp, sp, #0
    8c88:	e24dd00c 	sub	sp, sp, #12
    8c8c:	e50b0008 	str	r0, [fp, #-8]
    8c90:	e50b100c 	str	r1, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/interrupt_controller.cpp:24
: mInterrupt_Regs(reinterpret_cast<unsigned int*>(base))
    8c94:	e51b200c 	ldr	r2, [fp, #-12]
    8c98:	e51b3008 	ldr	r3, [fp, #-8]
    8c9c:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/interrupt_controller.cpp:26
{
}
    8ca0:	e51b3008 	ldr	r3, [fp, #-8]
    8ca4:	e1a00003 	mov	r0, r3
    8ca8:	e28bd000 	add	sp, fp, #0
    8cac:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8cb0:	e12fff1e 	bx	lr

00008cb4 <_ZN21CInterrupt_Controller4RegsEN3hal24Interrupt_Controller_RegE>:
_ZN21CInterrupt_Controller4RegsEN3hal24Interrupt_Controller_RegE():
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/interrupt_controller.cpp:29

volatile unsigned int& CInterrupt_Controller::Regs(hal::Interrupt_Controller_Reg reg)
{
    8cb4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8cb8:	e28db000 	add	fp, sp, #0
    8cbc:	e24dd00c 	sub	sp, sp, #12
    8cc0:	e50b0008 	str	r0, [fp, #-8]
    8cc4:	e50b100c 	str	r1, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/interrupt_controller.cpp:30
    return mInterrupt_Regs[static_cast<unsigned int>(reg)];
    8cc8:	e51b3008 	ldr	r3, [fp, #-8]
    8ccc:	e5932000 	ldr	r2, [r3]
    8cd0:	e51b300c 	ldr	r3, [fp, #-12]
    8cd4:	e1a03103 	lsl	r3, r3, #2
    8cd8:	e0823003 	add	r3, r2, r3
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/interrupt_controller.cpp:31
}
    8cdc:	e1a00003 	mov	r0, r3
    8ce0:	e28bd000 	add	sp, fp, #0
    8ce4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8ce8:	e12fff1e 	bx	lr

00008cec <_ZN21CInterrupt_Controller16Enable_Basic_IRQEN3hal16IRQ_Basic_SourceE>:
_ZN21CInterrupt_Controller16Enable_Basic_IRQEN3hal16IRQ_Basic_SourceE():
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/interrupt_controller.cpp:34

void CInterrupt_Controller::Enable_Basic_IRQ(hal::IRQ_Basic_Source source_idx)
{
    8cec:	e92d4810 	push	{r4, fp, lr}
    8cf0:	e28db008 	add	fp, sp, #8
    8cf4:	e24dd00c 	sub	sp, sp, #12
    8cf8:	e50b0010 	str	r0, [fp, #-16]
    8cfc:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/interrupt_controller.cpp:35
    Regs(hal::Interrupt_Controller_Reg::IRQ_Basic_Enable) = (1 << static_cast<unsigned int>(source_idx));
    8d00:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8d04:	e3a02001 	mov	r2, #1
    8d08:	e1a04312 	lsl	r4, r2, r3
    8d0c:	e3a01006 	mov	r1, #6
    8d10:	e51b0010 	ldr	r0, [fp, #-16]
    8d14:	ebffffe6 	bl	8cb4 <_ZN21CInterrupt_Controller4RegsEN3hal24Interrupt_Controller_RegE>
    8d18:	e1a03000 	mov	r3, r0
    8d1c:	e1a02004 	mov	r2, r4
    8d20:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/interrupt_controller.cpp:36
}
    8d24:	e320f000 	nop	{0}
    8d28:	e24bd008 	sub	sp, fp, #8
    8d2c:	e8bd8810 	pop	{r4, fp, pc}

00008d30 <_ZN21CInterrupt_Controller17Disable_Basic_IRQEN3hal16IRQ_Basic_SourceE>:
_ZN21CInterrupt_Controller17Disable_Basic_IRQEN3hal16IRQ_Basic_SourceE():
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/interrupt_controller.cpp:39

void CInterrupt_Controller::Disable_Basic_IRQ(hal::IRQ_Basic_Source source_idx)
{
    8d30:	e92d4810 	push	{r4, fp, lr}
    8d34:	e28db008 	add	fp, sp, #8
    8d38:	e24dd00c 	sub	sp, sp, #12
    8d3c:	e50b0010 	str	r0, [fp, #-16]
    8d40:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/interrupt_controller.cpp:40
    Regs(hal::Interrupt_Controller_Reg::IRQ_Basic_Disable) = (1 << static_cast<unsigned int>(source_idx));
    8d44:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8d48:	e3a02001 	mov	r2, #1
    8d4c:	e1a04312 	lsl	r4, r2, r3
    8d50:	e3a01009 	mov	r1, #9
    8d54:	e51b0010 	ldr	r0, [fp, #-16]
    8d58:	ebffffd5 	bl	8cb4 <_ZN21CInterrupt_Controller4RegsEN3hal24Interrupt_Controller_RegE>
    8d5c:	e1a03000 	mov	r3, r0
    8d60:	e1a02004 	mov	r2, r4
    8d64:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/interrupt_controller.cpp:41
}
    8d68:	e320f000 	nop	{0}
    8d6c:	e24bd008 	sub	sp, fp, #8
    8d70:	e8bd8810 	pop	{r4, fp, pc}

00008d74 <_ZN21CInterrupt_Controller10Enable_IRQEN3hal10IRQ_SourceE>:
_ZN21CInterrupt_Controller10Enable_IRQEN3hal10IRQ_SourceE():
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/interrupt_controller.cpp:44

void CInterrupt_Controller::Enable_IRQ(hal::IRQ_Source source_idx)
{
    8d74:	e92d4810 	push	{r4, fp, lr}
    8d78:	e28db008 	add	fp, sp, #8
    8d7c:	e24dd014 	sub	sp, sp, #20
    8d80:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8d84:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/interrupt_controller.cpp:45
    const unsigned int idx_base = static_cast<unsigned int>(source_idx);
    8d88:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8d8c:	e50b3010 	str	r3, [fp, #-16]
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/interrupt_controller.cpp:47

    Regs(idx_base < 32 ? hal::Interrupt_Controller_Reg::IRQ_Enable_1 : hal::Interrupt_Controller_Reg::IRQ_Enable_2) = (1 << (idx_base % 32));
    8d90:	e51b3010 	ldr	r3, [fp, #-16]
    8d94:	e203301f 	and	r3, r3, #31
    8d98:	e3a02001 	mov	r2, #1
    8d9c:	e1a04312 	lsl	r4, r2, r3
    8da0:	e51b3010 	ldr	r3, [fp, #-16]
    8da4:	e353001f 	cmp	r3, #31
    8da8:	8a000001 	bhi	8db4 <_ZN21CInterrupt_Controller10Enable_IRQEN3hal10IRQ_SourceE+0x40>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/interrupt_controller.cpp:47 (discriminator 1)
    8dac:	e3a03004 	mov	r3, #4
    8db0:	ea000000 	b	8db8 <_ZN21CInterrupt_Controller10Enable_IRQEN3hal10IRQ_SourceE+0x44>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/interrupt_controller.cpp:47 (discriminator 2)
    8db4:	e3a03005 	mov	r3, #5
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/interrupt_controller.cpp:47 (discriminator 4)
    8db8:	e1a01003 	mov	r1, r3
    8dbc:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    8dc0:	ebffffbb 	bl	8cb4 <_ZN21CInterrupt_Controller4RegsEN3hal24Interrupt_Controller_RegE>
    8dc4:	e1a03000 	mov	r3, r0
    8dc8:	e1a02004 	mov	r2, r4
    8dcc:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/interrupt_controller.cpp:48 (discriminator 4)
}
    8dd0:	e320f000 	nop	{0}
    8dd4:	e24bd008 	sub	sp, fp, #8
    8dd8:	e8bd8810 	pop	{r4, fp, pc}

00008ddc <_ZN21CInterrupt_Controller11Disable_IRQEN3hal10IRQ_SourceE>:
_ZN21CInterrupt_Controller11Disable_IRQEN3hal10IRQ_SourceE():
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/interrupt_controller.cpp:51

void CInterrupt_Controller::Disable_IRQ(hal::IRQ_Source source_idx)
{
    8ddc:	e92d4810 	push	{r4, fp, lr}
    8de0:	e28db008 	add	fp, sp, #8
    8de4:	e24dd014 	sub	sp, sp, #20
    8de8:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8dec:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/interrupt_controller.cpp:52
    const unsigned int idx_base = static_cast<unsigned int>(source_idx);
    8df0:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8df4:	e50b3010 	str	r3, [fp, #-16]
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/interrupt_controller.cpp:54

    Regs(idx_base < 32 ? hal::Interrupt_Controller_Reg::IRQ_Disable_1 : hal::Interrupt_Controller_Reg::IRQ_Disable_2) = (1 << (idx_base % 32));
    8df8:	e51b3010 	ldr	r3, [fp, #-16]
    8dfc:	e203301f 	and	r3, r3, #31
    8e00:	e3a02001 	mov	r2, #1
    8e04:	e1a04312 	lsl	r4, r2, r3
    8e08:	e51b3010 	ldr	r3, [fp, #-16]
    8e0c:	e353001f 	cmp	r3, #31
    8e10:	8a000001 	bhi	8e1c <_ZN21CInterrupt_Controller11Disable_IRQEN3hal10IRQ_SourceE+0x40>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/interrupt_controller.cpp:54 (discriminator 1)
    8e14:	e3a03007 	mov	r3, #7
    8e18:	ea000000 	b	8e20 <_ZN21CInterrupt_Controller11Disable_IRQEN3hal10IRQ_SourceE+0x44>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/interrupt_controller.cpp:54 (discriminator 2)
    8e1c:	e3a03008 	mov	r3, #8
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/interrupt_controller.cpp:54 (discriminator 4)
    8e20:	e1a01003 	mov	r1, r3
    8e24:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    8e28:	ebffffa1 	bl	8cb4 <_ZN21CInterrupt_Controller4RegsEN3hal24Interrupt_Controller_RegE>
    8e2c:	e1a03000 	mov	r3, r0
    8e30:	e1a02004 	mov	r2, r4
    8e34:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/interrupt_controller.cpp:55 (discriminator 4)
}
    8e38:	e320f000 	nop	{0}
    8e3c:	e24bd008 	sub	sp, fp, #8
    8e40:	e8bd8810 	pop	{r4, fp, pc}

00008e44 <_Z41__static_initialization_and_destruction_0ii>:
_Z41__static_initialization_and_destruction_0ii():
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/interrupt_controller.cpp:55
    8e44:	e92d4800 	push	{fp, lr}
    8e48:	e28db004 	add	fp, sp, #4
    8e4c:	e24dd008 	sub	sp, sp, #8
    8e50:	e50b0008 	str	r0, [fp, #-8]
    8e54:	e50b100c 	str	r1, [fp, #-12]
    8e58:	e51b3008 	ldr	r3, [fp, #-8]
    8e5c:	e3530001 	cmp	r3, #1
    8e60:	1a000006 	bne	8e80 <_Z41__static_initialization_and_destruction_0ii+0x3c>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/interrupt_controller.cpp:55 (discriminator 1)
    8e64:	e51b300c 	ldr	r3, [fp, #-12]
    8e68:	e59f201c 	ldr	r2, [pc, #28]	; 8e8c <_Z41__static_initialization_and_destruction_0ii+0x48>
    8e6c:	e1530002 	cmp	r3, r2
    8e70:	1a000002 	bne	8e80 <_Z41__static_initialization_and_destruction_0ii+0x3c>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/interrupt_controller.cpp:21
CInterrupt_Controller sInterruptCtl(hal::Interrupt_Controller_Base);
    8e74:	e59f1014 	ldr	r1, [pc, #20]	; 8e90 <_Z41__static_initialization_and_destruction_0ii+0x4c>
    8e78:	e59f0014 	ldr	r0, [pc, #20]	; 8e94 <_Z41__static_initialization_and_destruction_0ii+0x50>
    8e7c:	ebffff7f 	bl	8c80 <_ZN21CInterrupt_ControllerC1Em>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/interrupt_controller.cpp:55
}
    8e80:	e320f000 	nop	{0}
    8e84:	e24bd004 	sub	sp, fp, #4
    8e88:	e8bd8800 	pop	{fp, pc}
    8e8c:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>
    8e90:	2000b200 	andcs	fp, r0, r0, lsl #4
    8e94:	00009230 	andeq	r9, r0, r0, lsr r2

00008e98 <_GLOBAL__sub_I_software_interrupt_handler>:
_GLOBAL__sub_I_software_interrupt_handler():
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/interrupt_controller.cpp:55
    8e98:	e92d4800 	push	{fp, lr}
    8e9c:	e28db004 	add	fp, sp, #4
    8ea0:	e59f1008 	ldr	r1, [pc, #8]	; 8eb0 <_GLOBAL__sub_I_software_interrupt_handler+0x18>
    8ea4:	e3a00001 	mov	r0, #1
    8ea8:	ebffffe5 	bl	8e44 <_Z41__static_initialization_and_destruction_0ii>
    8eac:	e8bd8800 	pop	{fp, pc}
    8eb0:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>

00008eb4 <ACT_LED_Blinker>:
ACT_LED_Blinker():
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/main.cpp:8
#include <drivers/timer.h>

volatile int LED_State = 0;

extern "C" void ACT_LED_Blinker()
{
    8eb4:	e92d4800 	push	{fp, lr}
    8eb8:	e28db004 	add	fp, sp, #4
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/main.cpp:11
    // prepinani LED pri kazdem vytikani casovace

    if (LED_State)
    8ebc:	e59f305c 	ldr	r3, [pc, #92]	; 8f20 <ACT_LED_Blinker+0x6c>
    8ec0:	e5933000 	ldr	r3, [r3]
    8ec4:	e3530000 	cmp	r3, #0
    8ec8:	13a03001 	movne	r3, #1
    8ecc:	03a03000 	moveq	r3, #0
    8ed0:	e6ef3073 	uxtb	r3, r3
    8ed4:	e3530000 	cmp	r3, #0
    8ed8:	0a000007 	beq	8efc <ACT_LED_Blinker+0x48>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/main.cpp:13
    {
        LED_State = 0;
    8edc:	e59f303c 	ldr	r3, [pc, #60]	; 8f20 <ACT_LED_Blinker+0x6c>
    8ee0:	e3a02000 	mov	r2, #0
    8ee4:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/main.cpp:14
        sGPIO.Set_Output(47, true);
    8ee8:	e3a02001 	mov	r2, #1
    8eec:	e3a0102f 	mov	r1, #47	; 0x2f
    8ef0:	e59f002c 	ldr	r0, [pc, #44]	; 8f24 <ACT_LED_Blinker+0x70>
    8ef4:	ebfffe1f 	bl	8778 <_ZN13CGPIO_Handler10Set_OutputEjb>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/main.cpp:21
    else
    {
        LED_State = 1;
        sGPIO.Set_Output(47, false);
    }
}
    8ef8:	ea000006 	b	8f18 <ACT_LED_Blinker+0x64>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/main.cpp:18
        LED_State = 1;
    8efc:	e59f301c 	ldr	r3, [pc, #28]	; 8f20 <ACT_LED_Blinker+0x6c>
    8f00:	e3a02001 	mov	r2, #1
    8f04:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/main.cpp:19
        sGPIO.Set_Output(47, false);
    8f08:	e3a02000 	mov	r2, #0
    8f0c:	e3a0102f 	mov	r1, #47	; 0x2f
    8f10:	e59f000c 	ldr	r0, [pc, #12]	; 8f24 <ACT_LED_Blinker+0x70>
    8f14:	ebfffe17 	bl	8778 <_ZN13CGPIO_Handler10Set_OutputEjb>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/main.cpp:21
}
    8f18:	e320f000 	nop	{0}
    8f1c:	e8bd8800 	pop	{fp, pc}
    8f20:	00009234 	andeq	r9, r0, r4, lsr r2
    8f24:	00009224 	andeq	r9, r0, r4, lsr #4

00008f28 <_kernel_main>:
_kernel_main():
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/main.cpp:24

extern "C" int _kernel_main(void)
{
    8f28:	e92d4800 	push	{fp, lr}
    8f2c:	e28db004 	add	fp, sp, #4
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/main.cpp:25
    sGPIO.Set_GPIO_Function(47, NGPIO_Function::Output);
    8f30:	e3a02001 	mov	r2, #1
    8f34:	e3a0102f 	mov	r1, #47	; 0x2f
    8f38:	e59f0080 	ldr	r0, [pc, #128]	; 8fc0 <_kernel_main+0x98>
    8f3c:	ebfffd33 	bl	8410 <_ZN13CGPIO_Handler17Set_GPIO_FunctionEj14NGPIO_Function>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/main.cpp:26
    sGPIO.Set_GPIO_Function(48, NGPIO_Function::Output);
    8f40:	e3a02001 	mov	r2, #1
    8f44:	e3a01030 	mov	r1, #48	; 0x30
    8f48:	e59f0070 	ldr	r0, [pc, #112]	; 8fc0 <_kernel_main+0x98>
    8f4c:	ebfffd2f 	bl	8410 <_ZN13CGPIO_Handler17Set_GPIO_FunctionEj14NGPIO_Function>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/main.cpp:28

    sGPIO.Set_GPIO_Function(46, NGPIO_Function::Input);
    8f50:	e3a02000 	mov	r2, #0
    8f54:	e3a0102e 	mov	r1, #46	; 0x2e
    8f58:	e59f0060 	ldr	r0, [pc, #96]	; 8fc0 <_kernel_main+0x98>
    8f5c:	ebfffd2b 	bl	8410 <_ZN13CGPIO_Handler17Set_GPIO_FunctionEj14NGPIO_Function>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/main.cpp:29
    sGPIO.Enable_Event_Detect(46, NGPIO_Interrupt_Type::Rising_Edge);
    8f60:	e3a02000 	mov	r2, #0
    8f64:	e3a0102e 	mov	r1, #46	; 0x2e
    8f68:	e59f0050 	ldr	r0, [pc, #80]	; 8fc0 <_kernel_main+0x98>
    8f6c:	ebfffd70 	bl	8534 <_ZN13CGPIO_Handler19Enable_Event_DetectEj20NGPIO_Interrupt_Type>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/main.cpp:30
    sGPIO.Enable_Event_Detect(46, NGPIO_Interrupt_Type::Falling_Edge);
    8f70:	e3a02001 	mov	r2, #1
    8f74:	e3a0102e 	mov	r1, #46	; 0x2e
    8f78:	e59f0040 	ldr	r0, [pc, #64]	; 8fc0 <_kernel_main+0x98>
    8f7c:	ebfffd6c 	bl	8534 <_ZN13CGPIO_Handler19Enable_Event_DetectEj20NGPIO_Interrupt_Type>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/main.cpp:32

    sInterruptCtl.Enable_IRQ(hal::IRQ_Source::GPIO_2);
    8f80:	e3a01033 	mov	r1, #51	; 0x33
    8f84:	e59f0038 	ldr	r0, [pc, #56]	; 8fc4 <_kernel_main+0x9c>
    8f88:	ebffff79 	bl	8d74 <_ZN21CInterrupt_Controller10Enable_IRQEN3hal10IRQ_SourceE>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/main.cpp:34

    sInterruptCtl.Disable_Basic_IRQ(hal::IRQ_Basic_Source::Timer);
    8f8c:	e3a01000 	mov	r1, #0
    8f90:	e59f002c 	ldr	r0, [pc, #44]	; 8fc4 <_kernel_main+0x9c>
    8f94:	ebffff65 	bl	8d30 <_ZN21CInterrupt_Controller17Disable_Basic_IRQEN3hal16IRQ_Basic_SourceE>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/main.cpp:37

    // nastavime casovac - budeme pro ted blikat LEDkou, v budoucnu muzeme treba spoustet planovac procesu
    sTimer.Enable(ACT_LED_Blinker, 0x100, NTimer_Prescaler::Prescaler_256);
    8f98:	e3a03002 	mov	r3, #2
    8f9c:	e3a02c01 	mov	r2, #256	; 0x100
    8fa0:	e59f1020 	ldr	r1, [pc, #32]	; 8fc8 <_kernel_main+0xa0>
    8fa4:	e59f0020 	ldr	r0, [pc, #32]	; 8fcc <_kernel_main+0xa4>
    8fa8:	ebfffe9c 	bl	8a20 <_ZN6CTimer6EnableEPFvvEj16NTimer_Prescaler>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/main.cpp:40

    // povolime IRQ casovace
    sInterruptCtl.Enable_Basic_IRQ(hal::IRQ_Basic_Source::Timer);
    8fac:	e3a01000 	mov	r1, #0
    8fb0:	e59f000c 	ldr	r0, [pc, #12]	; 8fc4 <_kernel_main+0x9c>
    8fb4:	ebffff4c 	bl	8cec <_ZN21CInterrupt_Controller16Enable_Basic_IRQEN3hal16IRQ_Basic_SourceE>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/main.cpp:42

    enable_irq();
    8fb8:	eb000004 	bl	8fd0 <enable_irq>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/main.cpp:44 (discriminator 1)

    while (1)
    8fbc:	eafffffe 	b	8fbc <_kernel_main+0x94>
    8fc0:	00009224 	andeq	r9, r0, r4, lsr #4
    8fc4:	00009230 	andeq	r9, r0, r0, lsr r2
    8fc8:	00008eb4 			; <UNDEFINED> instruction: 0x00008eb4
    8fcc:	00009228 	andeq	r9, r0, r8, lsr #4

00008fd0 <enable_irq>:
enable_irq():
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/start.s:90
;@ tady budou ostatni symboly, ktere nevyzaduji zadne specialni misto
.section .text

.global enable_irq
enable_irq:
    mrs r0, cpsr		;@ presun ridiciho registru (CPSR) do general purpose registru (R0)
    8fd0:	e10f0000 	mrs	r0, CPSR
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/start.s:91
    bic r0, r0, #0x80	;@ vypne bit 7 v registru r0 ("IRQ mask bit")
    8fd4:	e3c00080 	bic	r0, r0, #128	; 0x80
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/start.s:92
    msr cpsr_c, r0		;@ nacteme upraveny general purpose (R0) registr do ridiciho (CPSR)
    8fd8:	e121f000 	msr	CPSR_c, r0
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/start.s:93
    cpsie i				;@ povoli preruseni
    8fdc:	f1080080 	cpsie	i
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/start.s:94
    bx lr
    8fe0:	e12fff1e 	bx	lr

00008fe4 <undefined_instruction_handler>:
undefined_instruction_handler():
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/start.s:97

undefined_instruction_handler:
	b hang
    8fe4:	eafffc29 	b	8090 <hang>

00008fe8 <prefetch_abort_handler>:
prefetch_abort_handler():
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/start.s:102

prefetch_abort_handler:
	;@ tady pak muzeme osetrit, kdyz program zasahne do mista, ktere nema mapovane ve svem virtualnim adr. prostoru
	;@ a treba vyvolat nasi obdobu segfaultu
	b hang
    8fe8:	eafffc28 	b	8090 <hang>

00008fec <data_abort_handler>:
data_abort_handler():
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/start.s:107

data_abort_handler:
	;@ tady pak muzeme osetrit, kdyz program zasahne do mista, ktere nema mapovane ve svem virtualnim adr. prostoru
	;@ a treba vyvolat nasi obdobu segfaultu
	b hang
    8fec:	eafffc27 	b	8090 <hang>

00008ff0 <_c_startup>:
_c_startup():
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/startup.cpp:21
extern "C" dtor_ptr __DTOR_LIST__[0];
// konec pole destruktoru
extern "C" dtor_ptr __DTOR_END__[0];

extern "C" int _c_startup(void)
{
    8ff0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8ff4:	e28db000 	add	fp, sp, #0
    8ff8:	e24dd00c 	sub	sp, sp, #12
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/startup.cpp:25
    int* i;

    // vynulujeme .bss sekci
    for (i = (int*)_bss_start; i < (int*)_bss_end; i++)
    8ffc:	e59f304c 	ldr	r3, [pc, #76]	; 9050 <_c_startup+0x60>
    9000:	e5933000 	ldr	r3, [r3]
    9004:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/startup.cpp:25 (discriminator 3)
    9008:	e59f3044 	ldr	r3, [pc, #68]	; 9054 <_c_startup+0x64>
    900c:	e5933000 	ldr	r3, [r3]
    9010:	e1a02003 	mov	r2, r3
    9014:	e51b3008 	ldr	r3, [fp, #-8]
    9018:	e1530002 	cmp	r3, r2
    901c:	2a000006 	bcs	903c <_c_startup+0x4c>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/startup.cpp:26 (discriminator 2)
        *i = 0;
    9020:	e51b3008 	ldr	r3, [fp, #-8]
    9024:	e3a02000 	mov	r2, #0
    9028:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/startup.cpp:25 (discriminator 2)
    for (i = (int*)_bss_start; i < (int*)_bss_end; i++)
    902c:	e51b3008 	ldr	r3, [fp, #-8]
    9030:	e2833004 	add	r3, r3, #4
    9034:	e50b3008 	str	r3, [fp, #-8]
    9038:	eafffff2 	b	9008 <_c_startup+0x18>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/startup.cpp:28

    return 0;
    903c:	e3a03000 	mov	r3, #0
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/startup.cpp:29
}
    9040:	e1a00003 	mov	r0, r3
    9044:	e28bd000 	add	sp, fp, #0
    9048:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    904c:	e12fff1e 	bx	lr
    9050:	00009224 	andeq	r9, r0, r4, lsr #4
    9054:	00009248 	andeq	r9, r0, r8, asr #4

00009058 <_cpp_startup>:
_cpp_startup():
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/startup.cpp:32

extern "C" int _cpp_startup(void)
{
    9058:	e92d4800 	push	{fp, lr}
    905c:	e28db004 	add	fp, sp, #4
    9060:	e24dd008 	sub	sp, sp, #8
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/startup.cpp:37
    ctor_ptr* fnptr;

    // zavolame konstruktory globalnich C++ trid
    // v poli __CTOR_LIST__ jsou ukazatele na vygenerovane stuby volani konstruktoru
    for (fnptr = __CTOR_LIST__; fnptr < __CTOR_END__; fnptr++)
    9064:	e59f303c 	ldr	r3, [pc, #60]	; 90a8 <_cpp_startup+0x50>
    9068:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/startup.cpp:37 (discriminator 3)
    906c:	e51b3008 	ldr	r3, [fp, #-8]
    9070:	e59f2034 	ldr	r2, [pc, #52]	; 90ac <_cpp_startup+0x54>
    9074:	e1530002 	cmp	r3, r2
    9078:	2a000006 	bcs	9098 <_cpp_startup+0x40>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/startup.cpp:38 (discriminator 2)
        (*fnptr)();
    907c:	e51b3008 	ldr	r3, [fp, #-8]
    9080:	e5933000 	ldr	r3, [r3]
    9084:	e12fff33 	blx	r3
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/startup.cpp:37 (discriminator 2)
    for (fnptr = __CTOR_LIST__; fnptr < __CTOR_END__; fnptr++)
    9088:	e51b3008 	ldr	r3, [fp, #-8]
    908c:	e2833004 	add	r3, r3, #4
    9090:	e50b3008 	str	r3, [fp, #-8]
    9094:	eafffff4 	b	906c <_cpp_startup+0x14>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/startup.cpp:40

    return 0;
    9098:	e3a03000 	mov	r3, #0
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/startup.cpp:41
}
    909c:	e1a00003 	mov	r0, r3
    90a0:	e24bd004 	sub	sp, fp, #4
    90a4:	e8bd8800 	pop	{fp, pc}
    90a8:	00009218 	andeq	r9, r0, r8, lsl r2
    90ac:	00009224 	andeq	r9, r0, r4, lsr #4

000090b0 <_cpp_shutdown>:
_cpp_shutdown():
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/startup.cpp:44

extern "C" int _cpp_shutdown(void)
{
    90b0:	e92d4800 	push	{fp, lr}
    90b4:	e28db004 	add	fp, sp, #4
    90b8:	e24dd008 	sub	sp, sp, #8
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/startup.cpp:48
    dtor_ptr* fnptr;

    // zavolame destruktory globalnich C++ trid
    for (fnptr = __DTOR_LIST__; fnptr < __DTOR_END__; fnptr++)
    90bc:	e59f303c 	ldr	r3, [pc, #60]	; 9100 <_cpp_shutdown+0x50>
    90c0:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/startup.cpp:48 (discriminator 3)
    90c4:	e51b3008 	ldr	r3, [fp, #-8]
    90c8:	e59f2034 	ldr	r2, [pc, #52]	; 9104 <_cpp_shutdown+0x54>
    90cc:	e1530002 	cmp	r3, r2
    90d0:	2a000006 	bcs	90f0 <_cpp_shutdown+0x40>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/startup.cpp:49 (discriminator 2)
        (*fnptr)();
    90d4:	e51b3008 	ldr	r3, [fp, #-8]
    90d8:	e5933000 	ldr	r3, [r3]
    90dc:	e12fff33 	blx	r3
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/startup.cpp:48 (discriminator 2)
    for (fnptr = __DTOR_LIST__; fnptr < __DTOR_END__; fnptr++)
    90e0:	e51b3008 	ldr	r3, [fp, #-8]
    90e4:	e2833004 	add	r3, r3, #4
    90e8:	e50b3008 	str	r3, [fp, #-8]
    90ec:	eafffff4 	b	90c4 <_cpp_shutdown+0x14>
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/startup.cpp:51

    return 0;
    90f0:	e3a03000 	mov	r3, #0
/home/silhavyj/School/ZeroMate/examples/11-timer_no_clear_IRQ/kernel/src/startup.cpp:52
}
    90f4:	e1a00003 	mov	r0, r3
    90f8:	e24bd004 	sub	sp, fp, #4
    90fc:	e8bd8800 	pop	{fp, pc}
    9100:	00009224 	andeq	r9, r0, r4, lsr #4
    9104:	00009224 	andeq	r9, r0, r4, lsr #4

Disassembly of section .ARM.extab:

00009108 <.ARM.extab>:
    9108:	81019b40 	tsthi	r1, r0, asr #22
    910c:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    9110:	00000000 	andeq	r0, r0, r0
    9114:	81019b46 	tsthi	r1, r6, asr #22
    9118:	b10f8581 	smlabblt	pc, r1, r5, r8	; <UNPREDICTABLE>
    911c:	00000000 	andeq	r0, r0, r0
    9120:	81019b40 	tsthi	r1, r0, asr #22
    9124:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    9128:	00000000 	andeq	r0, r0, r0
    912c:	81019b40 	tsthi	r1, r0, asr #22
    9130:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    9134:	00000000 	andeq	r0, r0, r0
    9138:	81019b40 	tsthi	r1, r0, asr #22
    913c:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    9140:	00000000 	andeq	r0, r0, r0
    9144:	81019b40 	tsthi	r1, r0, asr #22
    9148:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    914c:	00000000 	andeq	r0, r0, r0

Disassembly of section .ARM.exidx:

00009150 <.ARM.exidx>:
    9150:	7fffef44 	svcvc	0x00ffef44
    9154:	00000001 	andeq	r0, r0, r1
    9158:	7ffff9e0 	svcvc	0x00fff9e0
    915c:	7fffffac 	svcvc	0x00ffffac
    9160:	7ffffa10 	svcvc	0x00fffa10
    9164:	00000001 	andeq	r0, r0, r1
    9168:	7ffffad0 	svcvc	0x00fffad0
    916c:	7fffffa8 	svcvc	0x00ffffa8
    9170:	7ffffb00 	svcvc	0x00fffb00
    9174:	00000001 	andeq	r0, r0, r1
    9178:	7ffffd3c 	svcvc	0x00fffd3c
    917c:	7fffffa4 	svcvc	0x00ffffa4
    9180:	7ffffda8 	svcvc	0x00fffda8
    9184:	7fffffa8 	svcvc	0x00ffffa8
    9188:	7ffffe48 	svcvc	0x00fffe48
    918c:	00000001 	andeq	r0, r0, r1
    9190:	7ffffec8 	svcvc	0x00fffec8
    9194:	7fffffa4 	svcvc	0x00ffffa4
    9198:	7fffff18 	svcvc	0x00ffff18
    919c:	7fffffa8 	svcvc	0x00ffffa8
    91a0:	7fffff68 	svcvc	0x00ffff68
    91a4:	00000001 	andeq	r0, r0, r1

Disassembly of section .rodata:

000091a8 <_ZN3halL18Default_Clock_RateE>:
    91a8:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

000091ac <_ZN3halL15Peripheral_BaseE>:
    91ac:	20000000 	andcs	r0, r0, r0

000091b0 <_ZN3halL9GPIO_BaseE>:
    91b0:	20200000 	eorcs	r0, r0, r0

000091b4 <_ZN3halL14GPIO_Pin_CountE>:
    91b4:	00000036 	andeq	r0, r0, r6, lsr r0

000091b8 <_ZN3halL8AUX_BaseE>:
    91b8:	20215000 	eorcs	r5, r1, r0

000091bc <_ZN3halL25Interrupt_Controller_BaseE>:
    91bc:	2000b200 	andcs	fp, r0, r0, lsl #4

000091c0 <_ZN3halL10Timer_BaseE>:
    91c0:	2000b400 	andcs	fp, r0, r0, lsl #8

000091c4 <_ZN3halL18Default_Clock_RateE>:
    91c4:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

000091c8 <_ZN3halL15Peripheral_BaseE>:
    91c8:	20000000 	andcs	r0, r0, r0

000091cc <_ZN3halL9GPIO_BaseE>:
    91cc:	20200000 	eorcs	r0, r0, r0

000091d0 <_ZN3halL14GPIO_Pin_CountE>:
    91d0:	00000036 	andeq	r0, r0, r6, lsr r0

000091d4 <_ZN3halL8AUX_BaseE>:
    91d4:	20215000 	eorcs	r5, r1, r0

000091d8 <_ZN3halL25Interrupt_Controller_BaseE>:
    91d8:	2000b200 	andcs	fp, r0, r0, lsl #4

000091dc <_ZN3halL10Timer_BaseE>:
    91dc:	2000b400 	andcs	fp, r0, r0, lsl #8

000091e0 <_ZN3halL18Default_Clock_RateE>:
    91e0:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

000091e4 <_ZN3halL15Peripheral_BaseE>:
    91e4:	20000000 	andcs	r0, r0, r0

000091e8 <_ZN3halL9GPIO_BaseE>:
    91e8:	20200000 	eorcs	r0, r0, r0

000091ec <_ZN3halL14GPIO_Pin_CountE>:
    91ec:	00000036 	andeq	r0, r0, r6, lsr r0

000091f0 <_ZN3halL8AUX_BaseE>:
    91f0:	20215000 	eorcs	r5, r1, r0

000091f4 <_ZN3halL25Interrupt_Controller_BaseE>:
    91f4:	2000b200 	andcs	fp, r0, r0, lsl #4

000091f8 <_ZN3halL10Timer_BaseE>:
    91f8:	2000b400 	andcs	fp, r0, r0, lsl #8

000091fc <_ZN3halL18Default_Clock_RateE>:
    91fc:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

00009200 <_ZN3halL15Peripheral_BaseE>:
    9200:	20000000 	andcs	r0, r0, r0

00009204 <_ZN3halL9GPIO_BaseE>:
    9204:	20200000 	eorcs	r0, r0, r0

00009208 <_ZN3halL14GPIO_Pin_CountE>:
    9208:	00000036 	andeq	r0, r0, r6, lsr r0

0000920c <_ZN3halL8AUX_BaseE>:
    920c:	20215000 	eorcs	r5, r1, r0

00009210 <_ZN3halL25Interrupt_Controller_BaseE>:
    9210:	2000b200 	andcs	fp, r0, r0, lsl #4

00009214 <_ZN3halL10Timer_BaseE>:
    9214:	2000b400 	andcs	fp, r0, r0, lsl #8

Disassembly of section .data:

00009218 <__CTOR_LIST__>:
    9218:	0000898c 	andeq	r8, r0, ip, lsl #19
    921c:	00008c04 	andeq	r8, r0, r4, lsl #24
    9220:	00008e98 	muleq	r0, r8, lr

Disassembly of section .bss:

00009224 <sGPIO>:
    9224:	00000000 	andeq	r0, r0, r0

00009228 <sTimer>:
	...

00009230 <sInterruptCtl>:
    9230:	00000000 	andeq	r0, r0, r0

00009234 <LED_State>:
	...

Disassembly of section .debug_info:

00000000 <.debug_info>:
       0:	00000126 	andeq	r0, r0, r6, lsr #2
       4:	00000004 	andeq	r0, r0, r4
       8:	01040000 	mrseq	r0, (UNDEF: 4)
       c:	00000000 	andeq	r0, r0, r0
      10:	0000ca04 	andeq	ip, r0, r4, lsl #20
      14:	00011b00 	andeq	r1, r1, r0, lsl #22
      18:	00809400 	addeq	r9, r0, r0, lsl #8
      1c:	0000d800 	andeq	sp, r0, r0, lsl #16
      20:	00000000 	andeq	r0, r0, r0
      24:	01bd0200 			; <UNDEFINED> instruction: 0x01bd0200
      28:	28010000 	stmdacs	r1, {}	; <UNPREDICTABLE>
      2c:	00816011 	addeq	r6, r1, r1, lsl r0
      30:	00000c00 	andeq	r0, r0, r0, lsl #24
      34:	029c0100 	addseq	r0, ip, #0, 2
      38:	000001aa 	andeq	r0, r0, sl, lsr #3
      3c:	48112301 	ldmdami	r1, {r0, r8, r9, sp}
      40:	18000081 	stmdane	r0, {r0, r7}
      44:	01000000 	mrseq	r0, (UNDEF: 0)
      48:	017e029c 			; <UNDEFINED> instruction: 0x017e029c
      4c:	1e010000 	cdpne	0, 0, cr0, cr1, cr0, {0}
      50:	00813011 	addeq	r3, r1, r1, lsl r0
      54:	00001800 	andeq	r1, r0, r0, lsl #16
      58:	029c0100 	addseq	r0, ip, #0, 2
      5c:	00000171 	andeq	r0, r0, r1, ror r1
      60:	18111901 	ldmdane	r1, {r0, r8, fp, ip}
      64:	18000081 	stmdane	r0, {r0, r7}
      68:	01000000 	mrseq	r0, (UNDEF: 0)
      6c:	019f039c 			; <UNDEFINED> instruction: 0x019f039c
      70:	00020000 	andeq	r0, r2, r0
      74:	000000bb 	strheq	r0, [r0], -fp
      78:	00015f04 	andeq	r5, r1, r4, lsl #30
      7c:	15140100 	ldrne	r0, [r4, #-256]	; 0xffffff00
      80:	0000008a 	andeq	r0, r0, sl, lsl #1
      84:	0000bb05 	andeq	fp, r0, r5, lsl #22
      88:	d4060000 	strle	r0, [r6], #-0
      8c:	01000001 	tsteq	r0, r1
      90:	00c11f04 	sbceq	r1, r1, r4, lsl #30
      94:	b6040000 	strlt	r0, [r4], -r0
      98:	01000000 	mrseq	r0, (UNDEF: 0)
      9c:	00a8150f 	adceq	r1, r8, pc, lsl #10
      a0:	bb050000 	bllt	1400a8 <_bss_end+0x136e60>
      a4:	00000000 	andeq	r0, r0, r0
      a8:	00018b07 	andeq	r8, r1, r7, lsl #22
      ac:	140a0100 	strne	r0, [sl], #-256	; 0xffffff00
      b0:	00000105 	andeq	r0, r0, r5, lsl #2
      b4:	0000bb05 	andeq	fp, r0, r5, lsl #22
      b8:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
      bc:	00008a04 	andeq	r8, r0, r4, lsl #20
      c0:	05080900 	streq	r0, [r8, #-2304]	; 0xfffff700
      c4:	000001dc 	ldrdeq	r0, [r0], -ip
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
     11c:	0a010067 	beq	402c0 <_bss_end+0x37078>
     120:	0000bb31 	andeq	fp, r0, r1, lsr fp
     124:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     128:	099f0000 	ldmibeq	pc, {}	; <UNPREDICTABLE>
     12c:	00040000 	andeq	r0, r4, r0
     130:	000000d0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     134:	00000104 	andeq	r0, r0, r4, lsl #2
     138:	69040000 	stmdbvs	r4, {}	; <UNPREDICTABLE>
     13c:	1b000007 	blne	160 <CPSR_IRQ_INHIBIT+0xe0>
     140:	6c000001 	stcvs	0, cr0, [r0], {1}
     144:	3c000081 	stccc	0, cr0, [r0], {129}	; 0x81
     148:	b2000008 	andlt	r0, r0, #8
     14c:	02000000 	andeq	r0, r0, #0
     150:	053d0801 	ldreq	r0, [sp, #-2049]!	; 0xfffff7ff
     154:	02020000 	andeq	r0, r2, #0
     158:	0002ab05 	andeq	sl, r2, r5, lsl #22
     15c:	05040300 	streq	r0, [r4, #-768]	; 0xfffffd00
     160:	00746e69 	rsbseq	r6, r4, r9, ror #28
     164:	00038604 	andeq	r8, r3, r4, lsl #12
     168:	07090200 	streq	r0, [r9, -r0, lsl #4]
     16c:	00000046 	andeq	r0, r0, r6, asr #32
     170:	34080102 	strcc	r0, [r8], #-258	; 0xfffffefe
     174:	02000005 	andeq	r0, r0, #5
     178:	05800702 	streq	r0, [r0, #1794]	; 0x702
     17c:	9c040000 	stcls	0, cr0, [r4], {-0}
     180:	02000003 	andeq	r0, r0, #3
     184:	0065070b 	rsbeq	r0, r5, fp, lsl #14
     188:	54050000 	strpl	r0, [r5], #-0
     18c:	02000000 	andeq	r0, r0, #0
     190:	154f0704 	strbne	r0, [pc, #-1796]	; fffffa94 <_bss_end+0xffff684c>
     194:	65050000 	strvs	r0, [r5, #-0]
     198:	06000000 	streq	r0, [r0], -r0
     19c:	006c6168 	rsbeq	r6, ip, r8, ror #2
     1a0:	ac0b0703 	stcge	7, cr0, [fp], {3}
     1a4:	07000001 	streq	r0, [r0, -r1]
     1a8:	00000806 	andeq	r0, r0, r6, lsl #16
     1ac:	6c1c0903 			; <UNDEFINED> instruction: 0x6c1c0903
     1b0:	80000000 	andhi	r0, r0, r0
     1b4:	070ee6b2 			; <UNDEFINED> instruction: 0x070ee6b2
     1b8:	00000483 	andeq	r0, r0, r3, lsl #9
     1bc:	b81d0c03 	ldmdalt	sp, {r0, r1, sl, fp}
     1c0:	00000001 	andeq	r0, r0, r1
     1c4:	07200000 	streq	r0, [r0, -r0]!
     1c8:	00000542 	andeq	r0, r0, r2, asr #10
     1cc:	b81d0f03 	ldmdalt	sp, {r0, r1, r8, r9, sl, fp}
     1d0:	00000001 	andeq	r0, r0, r1
     1d4:	08202000 	stmdaeq	r0!, {sp}
     1d8:	000005f1 	strdeq	r0, [r0], -r1
     1dc:	60181203 	andsvs	r1, r8, r3, lsl #4
     1e0:	36000000 	strcc	r0, [r0], -r0
     1e4:	00063a09 	andeq	r3, r6, r9, lsl #20
     1e8:	33040500 	movwcc	r0, #17664	; 0x4500
     1ec:	03000000 	movweq	r0, #0
     1f0:	017b1015 	cmneq	fp, r5, lsl r0
     1f4:	270a0000 	strcs	r0, [sl, -r0]
     1f8:	00000002 	andeq	r0, r0, r2
     1fc:	00022f0a 	andeq	r2, r2, sl, lsl #30
     200:	370a0100 	strcc	r0, [sl, -r0, lsl #2]
     204:	02000002 	andeq	r0, r0, #2
     208:	00023f0a 	andeq	r3, r2, sl, lsl #30
     20c:	470a0300 	strmi	r0, [sl, -r0, lsl #6]
     210:	04000002 	streq	r0, [r0], #-2
     214:	00024f0a 	andeq	r4, r2, sl, lsl #30
     218:	190a0500 	stmdbne	sl, {r8, sl}
     21c:	07000002 	streq	r0, [r0, -r2]
     220:	0002200a 	andeq	r2, r2, sl
     224:	2b0a0800 	blcs	28222c <_bss_end+0x278fe4>
     228:	0a000008 	beq	250 <CPSR_IRQ_INHIBIT+0x1d0>
     22c:	00054c0a 	andeq	r4, r5, sl, lsl #24
     230:	d30a0b00 	movwle	r0, #43776	; 0xab00
     234:	0d000006 	stceq	0, cr0, [r0, #-24]	; 0xffffffe8
     238:	0006da0a 	andeq	sp, r6, sl, lsl #20
     23c:	8e0a0e00 	cdphi	14, 0, cr0, cr10, cr0, {0}
     240:	10000003 	andne	r0, r0, r3
     244:	0003950a 	andeq	r9, r3, sl, lsl #10
     248:	090a1100 	stmdbeq	sl, {r8, ip}
     24c:	13000003 	movwne	r0, #3
     250:	0003100a 	andeq	r1, r3, sl
     254:	570a1400 	strpl	r1, [sl, -r0, lsl #8]
     258:	16000007 	strne	r0, [r0], -r7
     25c:	0002570a 	andeq	r5, r2, sl, lsl #14
     260:	630a1700 	movwvs	r1, #42752	; 0xa700
     264:	19000005 	stmdbne	r0, {r0, r2}
     268:	00056a0a 	andeq	r6, r5, sl, lsl #20
     26c:	cb0a1a00 	blgt	286a74 <_bss_end+0x27d82c>
     270:	1c000003 	stcne	0, cr0, [r0], {3}
     274:	0005930a 	andeq	r9, r5, sl, lsl #6
     278:	530a1d00 	movwpl	r1, #44288	; 0xad00
     27c:	1f000005 	svcne	0x00000005
     280:	00055b0a 	andeq	r5, r5, sl, lsl #22
     284:	f50a2000 			; <UNDEFINED> instruction: 0xf50a2000
     288:	22000004 	andcs	r0, r0, #4
     28c:	0004fd0a 	andeq	pc, r4, sl, lsl #26
     290:	520a2300 	andpl	r2, sl, #0, 6
     294:	25000004 	strcs	r0, [r0, #-4]
     298:	0002b50a 	andeq	fp, r2, sl, lsl #10
     29c:	bf0a2600 	svclt	0x000a2600
     2a0:	27000002 	strcs	r0, [r0, -r2]
     2a4:	07350700 	ldreq	r0, [r5, -r0, lsl #14]!
     2a8:	44030000 	strmi	r0, [r3], #-0
     2ac:	0001b81d 	andeq	fp, r1, sp, lsl r8
     2b0:	21500000 	cmpcs	r0, r0
     2b4:	025e0720 	subseq	r0, lr, #32, 14	; 0x800000
     2b8:	73030000 	movwvc	r0, #12288	; 0x3000
     2bc:	0001b81d 	andeq	fp, r1, sp, lsl r8
     2c0:	00b20000 	adcseq	r0, r2, r0
     2c4:	06050720 	streq	r0, [r5], -r0, lsr #14
     2c8:	a6030000 	strge	r0, [r3], -r0
     2cc:	0001b81d 	andeq	fp, r1, sp, lsl r8
     2d0:	00b40000 	adcseq	r0, r4, r0
     2d4:	7d0b0020 	stcvc	0, cr0, [fp, #-128]	; 0xffffff80
     2d8:	02000000 	andeq	r0, r0, #0
     2dc:	154a0704 	strbne	r0, [sl, #-1796]	; 0xfffff8fc
     2e0:	b1050000 	mrslt	r0, (UNDEF: 5)
     2e4:	0b000001 	bleq	2f0 <CPSR_IRQ_INHIBIT+0x270>
     2e8:	0000008d 	andeq	r0, r0, sp, lsl #1
     2ec:	00009d0b 	andeq	r9, r0, fp, lsl #26
     2f0:	00ad0b00 	adceq	r0, sp, r0, lsl #22
     2f4:	7b0b0000 	blvc	2c02fc <_bss_end+0x2b70b4>
     2f8:	0b000001 	bleq	304 <CPSR_IRQ_INHIBIT+0x284>
     2fc:	0000018b 	andeq	r0, r0, fp, lsl #3
     300:	00019b0b 	andeq	r9, r1, fp, lsl #22
     304:	06b20900 	ldrteq	r0, [r2], r0, lsl #18
     308:	01070000 	mrseq	r0, (UNDEF: 7)
     30c:	0000003a 	andeq	r0, r0, sl, lsr r0
     310:	240c0604 	strcs	r0, [ip], #-1540	; 0xfffff9fc
     314:	0a000002 	beq	324 <CPSR_IRQ_INHIBIT+0x2a4>
     318:	00000751 	andeq	r0, r0, r1, asr r7
     31c:	07620a00 	strbeq	r0, [r2, -r0, lsl #20]!
     320:	0a010000 	beq	40328 <_bss_end+0x370e0>
     324:	00000825 	andeq	r0, r0, r5, lsr #16
     328:	081f0a02 	ldmdaeq	pc, {r1, r9, fp}	; <UNPREDICTABLE>
     32c:	0a030000 	beq	c0334 <_bss_end+0xb70ec>
     330:	000007fa 	strdeq	r0, [r0], -sl
     334:	08000a04 	stmdaeq	r0, {r2, r9, fp}
     338:	0a050000 	beq	140340 <_bss_end+0x1370f8>
     33c:	000006cd 	andeq	r0, r0, sp, asr #13
     340:	08190a06 	ldmdaeq	r9, {r1, r2, r9, fp}
     344:	0a070000 	beq	1c034c <_bss_end+0x1b7104>
     348:	000003aa 	andeq	r0, r0, sl, lsr #7
     34c:	f4090008 	vst4.8	{d0-d3}, [r9], r8
     350:	05000002 	streq	r0, [r0, #-2]
     354:	00003304 	andeq	r3, r0, r4, lsl #6
     358:	0c180400 	cfldrseq	mvf0, [r8], {-0}
     35c:	0000024f 	andeq	r0, r0, pc, asr #4
     360:	0006c10a 	andeq	ip, r6, sl, lsl #2
     364:	ed0a0000 	stc	0, cr0, [sl, #-0]
     368:	01000007 	tsteq	r0, r7
     36c:	0002a60a 	andeq	sl, r2, sl, lsl #12
     370:	4c0c0200 	sfmmi	f0, 4, [ip], {-0}
     374:	0300776f 	movweq	r7, #1903	; 0x76f
     378:	04310d00 	ldrteq	r0, [r1], #-3328	; 0xfffff300
     37c:	04040000 	streq	r0, [r4], #-0
     380:	047b0723 	ldrbteq	r0, [fp], #-1827	; 0xfffff8dd
     384:	690e0000 	stmdbvs	lr, {}	; <UNPREDICTABLE>
     388:	04000003 	streq	r0, [r0], #-3
     38c:	04861927 	streq	r1, [r6], #2343	; 0x927
     390:	0f000000 	svceq	0x00000000
     394:	000005dd 	ldrdeq	r0, [r0], -sp
     398:	390a2b04 	stmdbcc	sl, {r2, r8, r9, fp, sp}
     39c:	8b000003 	blhi	3b0 <CPSR_IRQ_INHIBIT+0x330>
     3a0:	02000004 	andeq	r0, r0, #4
     3a4:	00000282 	andeq	r0, r0, r2, lsl #5
     3a8:	00000297 	muleq	r0, r7, r2
     3ac:	00049210 	andeq	r9, r4, r0, lsl r2
     3b0:	00541100 	subseq	r1, r4, r0, lsl #2
     3b4:	9d110000 	ldcls	0, cr0, [r1, #-0]
     3b8:	11000004 	tstne	r0, r4
     3bc:	0000049d 	muleq	r0, sp, r4
     3c0:	073e0f00 	ldreq	r0, [lr, -r0, lsl #30]!
     3c4:	2d040000 	stccs	0, cr0, [r4, #-0]
     3c8:	0005050a 	andeq	r0, r5, sl, lsl #10
     3cc:	00048b00 	andeq	r8, r4, r0, lsl #22
     3d0:	02b00200 	adcseq	r0, r0, #0, 4
     3d4:	02c50000 	sbceq	r0, r5, #0
     3d8:	92100000 	andsls	r0, r0, #0
     3dc:	11000004 	tstne	r0, r4
     3e0:	00000054 	andeq	r0, r0, r4, asr r0
     3e4:	00049d11 	andeq	r9, r4, r1, lsl sp
     3e8:	049d1100 	ldreq	r1, [sp], #256	; 0x100
     3ec:	0f000000 	svceq	0x00000000
     3f0:	0000043f 	andeq	r0, r0, pc, lsr r4
     3f4:	060a2f04 	streq	r2, [sl], -r4, lsl #30
     3f8:	8b000007 	blhi	41c <CPSR_IRQ_INHIBIT+0x39c>
     3fc:	02000004 	andeq	r0, r0, #4
     400:	000002de 	ldrdeq	r0, [r0], -lr
     404:	000002f3 	strdeq	r0, [r0], -r3
     408:	00049210 	andeq	r9, r4, r0, lsl r2
     40c:	00541100 	subseq	r1, r4, r0, lsl #2
     410:	9d110000 	ldcls	0, cr0, [r1, #-0]
     414:	11000004 	tstne	r0, r4
     418:	0000049d 	muleq	r0, sp, r4
     41c:	04930f00 	ldreq	r0, [r3], #3840	; 0xf00
     420:	31040000 	mrscc	r0, (UNDEF: 4)
     424:	0001ea0a 	andeq	lr, r1, sl, lsl #20
     428:	00048b00 	andeq	r8, r4, r0, lsl #22
     42c:	030c0200 	movweq	r0, #49664	; 0xc200
     430:	03210000 			; <UNDEFINED> instruction: 0x03210000
     434:	92100000 	andsls	r0, r0, #0
     438:	11000004 	tstne	r0, r4
     43c:	00000054 	andeq	r0, r0, r4, asr r0
     440:	00049d11 	andeq	r9, r4, r1, lsl sp
     444:	049d1100 	ldreq	r1, [sp], #256	; 0x100
     448:	0f000000 	svceq	0x00000000
     44c:	00000293 	muleq	r0, r3, r2
     450:	ae0a3204 	cdpge	2, 0, cr3, cr10, cr4, {0}
     454:	8b000005 	blhi	470 <CPSR_IRQ_INHIBIT+0x3f0>
     458:	02000004 	andeq	r0, r0, #4
     45c:	0000033a 	andeq	r0, r0, sl, lsr r3
     460:	0000034f 	andeq	r0, r0, pc, asr #6
     464:	00049210 	andeq	r9, r4, r0, lsl r2
     468:	00541100 	subseq	r1, r4, r0, lsl #2
     46c:	9d110000 	ldcls	0, cr0, [r1, #-0]
     470:	11000004 	tstne	r0, r4
     474:	0000049d 	muleq	r0, sp, r4
     478:	04310f00 	ldrteq	r0, [r1], #-3840	; 0xfffff100
     47c:	35040000 	strcc	r0, [r4, #-0]
     480:	00036f05 	andeq	r6, r3, r5, lsl #30
     484:	0004a300 	andeq	sl, r4, r0, lsl #6
     488:	03680100 	cmneq	r8, #0, 2
     48c:	03730000 	cmneq	r3, #0
     490:	a3100000 	tstge	r0, #0
     494:	11000004 	tstne	r0, r4
     498:	00000065 	andeq	r0, r0, r5, rrx
     49c:	06e11200 	strbteq	r1, [r1], r0, lsl #4
     4a0:	38040000 	stmdacc	r4, {}	; <UNPREDICTABLE>
     4a4:	0006890a 	andeq	r8, r6, sl, lsl #18
     4a8:	03880100 	orreq	r0, r8, #0, 2
     4ac:	03980000 	orrseq	r0, r8, #0
     4b0:	a3100000 	tstge	r0, #0
     4b4:	11000004 	tstne	r0, r4
     4b8:	00000054 	andeq	r0, r0, r4, asr r0
     4bc:	0001db11 	andeq	sp, r1, r1, lsl fp
     4c0:	1f0f0000 	svcne	0x000f0000
     4c4:	04000004 	streq	r0, [r0], #-4
     4c8:	04a6143a 	strteq	r1, [r6], #1082	; 0x43a
     4cc:	01db0000 	bicseq	r0, fp, r0
     4d0:	b1010000 	mrslt	r0, (UNDEF: 1)
     4d4:	bc000003 	stclt	0, cr0, [r0], {3}
     4d8:	10000003 	andne	r0, r0, r3
     4dc:	00000492 	muleq	r0, r2, r4
     4e0:	00005411 	andeq	r5, r0, r1, lsl r4
     4e4:	5e120000 	cdppl	0, 1, cr0, cr2, cr0, {0}
     4e8:	04000007 	streq	r0, [r0], #-7
     4ec:	03170a3d 	tsteq	r7, #249856	; 0x3d000
     4f0:	d1010000 	mrsle	r0, (UNDEF: 1)
     4f4:	e1000003 	tst	r0, r3
     4f8:	10000003 	andne	r0, r0, r3
     4fc:	000004a3 	andeq	r0, r0, r3, lsr #9
     500:	00005411 	andeq	r5, r0, r1, lsl r4
     504:	048b1100 	streq	r1, [fp], #256	; 0x100
     508:	12000000 	andne	r0, r0, #0
     50c:	000003b6 			; <UNDEFINED> instruction: 0x000003b6
     510:	580a3f04 	stmdapl	sl, {r2, r8, r9, sl, fp, ip, sp}
     514:	01000004 	tsteq	r0, r4
     518:	000003f6 	strdeq	r0, [r0], -r6
     51c:	00000401 	andeq	r0, r0, r1, lsl #8
     520:	0004a310 	andeq	sl, r4, r0, lsl r3
     524:	00541100 	subseq	r1, r4, r0, lsl #2
     528:	12000000 	andne	r0, r0, #0
     52c:	0000059a 	muleq	r0, sl, r5
     530:	c90a4104 	stmdbgt	sl, {r2, r8, lr}
     534:	01000002 	tsteq	r0, r2
     538:	00000416 	andeq	r0, r0, r6, lsl r4
     53c:	00000426 	andeq	r0, r0, r6, lsr #8
     540:	0004a310 	andeq	sl, r4, r0, lsl r3
     544:	00541100 	subseq	r1, r4, r0, lsl #2
     548:	24110000 	ldrcs	r0, [r1], #-0
     54c:	00000002 	andeq	r0, r0, r2
     550:	0007d812 	andeq	sp, r7, r2, lsl r8
     554:	0a420400 	beq	108155c <_bss_end+0x1078314>
     558:	00000648 	andeq	r0, r0, r8, asr #12
     55c:	00043b01 	andeq	r3, r4, r1, lsl #22
     560:	00044b00 	andeq	r4, r4, r0, lsl #22
     564:	04a31000 	strteq	r1, [r3], #0
     568:	54110000 	ldrpl	r0, [r1], #-0
     56c:	11000000 	mrsne	r0, (UNDEF: 0)
     570:	00000224 	andeq	r0, r0, r4, lsr #4
     574:	02781300 	rsbseq	r1, r8, #0, 6
     578:	43040000 	movwmi	r0, #16384	; 0x4000
     57c:	0003d20a 	andeq	sp, r3, sl, lsl #4
     580:	00048b00 	andeq	r8, r4, r0, lsl #22
     584:	04600100 	strbteq	r0, [r0], #-256	; 0xffffff00
     588:	92100000 	andsls	r0, r0, #0
     58c:	11000004 	tstne	r0, r4
     590:	00000054 	andeq	r0, r0, r4, asr r0
     594:	00022411 	andeq	r2, r2, r1, lsl r4
     598:	049d1100 	ldreq	r1, [sp], #256	; 0x100
     59c:	9d110000 	ldcls	0, cr0, [r1, #-0]
     5a0:	00000004 	andeq	r0, r0, r4
     5a4:	024f0500 	subeq	r0, pc, #0, 10
     5a8:	04140000 	ldreq	r0, [r4], #-0
     5ac:	00000065 	andeq	r0, r0, r5, rrx
     5b0:	00048005 	andeq	r8, r4, r5
     5b4:	02010200 	andeq	r0, r1, #0, 4
     5b8:	000003a5 	andeq	r0, r0, r5, lsr #7
     5bc:	047b0414 	ldrbteq	r0, [fp], #-1044	; 0xfffffbec
     5c0:	92050000 	andls	r0, r5, #0
     5c4:	15000004 	strne	r0, [r0, #-4]
     5c8:	00005404 	andeq	r5, r0, r4, lsl #8
     5cc:	4f041400 	svcmi	0x00041400
     5d0:	05000002 	streq	r0, [r0, #-2]
     5d4:	000004a3 	andeq	r0, r0, r3, lsr #9
     5d8:	0007d216 	andeq	sp, r7, r6, lsl r2
     5dc:	16470400 	strbne	r0, [r7], -r0, lsl #8
     5e0:	0000024f 	andeq	r0, r0, pc, asr #4
     5e4:	0004ae17 	andeq	sl, r4, r7, lsl lr
     5e8:	0f040100 	svceq	0x00040100
     5ec:	92240305 	eorls	r0, r4, #335544320	; 0x14000000
     5f0:	c3180000 	tstgt	r8, #0
     5f4:	8c000007 	stchi	0, cr0, [r0], {7}
     5f8:	1c000089 	stcne	0, cr0, [r0], {137}	; 0x89
     5fc:	01000000 	mrseq	r0, (UNDEF: 0)
     600:	0610199c 			; <UNDEFINED> instruction: 0x0610199c
     604:	89380000 	ldmdbhi	r8!, {}	; <UNPREDICTABLE>
     608:	00540000 	subseq	r0, r4, r0
     60c:	9c010000 	stcls	0, cr0, [r1], {-0}
     610:	00000509 	andeq	r0, r0, r9, lsl #10
     614:	0004cf1a 	andeq	ip, r4, sl, lsl pc
     618:	01b10100 			; <UNDEFINED> instruction: 0x01b10100
     61c:	00000033 	andeq	r0, r0, r3, lsr r0
     620:	1a749102 	bne	1d24a30 <_bss_end+0x1d1b7e8>
     624:	000006fb 	strdeq	r0, [r0], -fp
     628:	3301b101 	movwcc	fp, #4353	; 0x1101
     62c:	02000000 	andeq	r0, r0, #0
     630:	1b007091 	blne	1c87c <_bss_end+0x13634>
     634:	000003e1 	andeq	r0, r0, r1, ror #7
     638:	2306a901 	movwcs	sl, #26881	; 0x6901
     63c:	c4000005 	strgt	r0, [r0], #-5
     640:	74000088 	strvc	r0, [r0], #-136	; 0xffffff78
     644:	01000000 	mrseq	r0, (UNDEF: 0)
     648:	00055d9c 	muleq	r5, ip, sp
     64c:	06431c00 	strbeq	r1, [r3], -r0, lsl #24
     650:	04a90000 	strteq	r0, [r9], #0
     654:	91020000 	mrsls	r0, (UNDEF: 2)
     658:	69701d6c 	ldmdbvs	r0!, {r2, r3, r5, r6, r8, sl, fp, ip}^
     65c:	a901006e 	stmdbge	r1, {r1, r2, r3, r5, r6}
     660:	00005433 	andeq	r5, r0, r3, lsr r4
     664:	68910200 	ldmvs	r1, {r9}
     668:	6765721e 			; <UNDEFINED> instruction: 0x6765721e
     66c:	0eab0100 	fdveqe	f0, f3, f0
     670:	00000054 	andeq	r0, r0, r4, asr r0
     674:	1e749102 	expnes	f1, f2
     678:	00746962 	rsbseq	r6, r4, r2, ror #18
     67c:	5413ab01 	ldrpl	sl, [r3], #-2817	; 0xfffff4ff
     680:	02000000 	andeq	r0, r0, #0
     684:	1f007091 	svcne	0x00007091
     688:	00000321 	andeq	r0, r0, r1, lsr #6
     68c:	77069e01 	strvc	r9, [r6, -r1, lsl #28]
     690:	50000005 	andpl	r0, r0, r5
     694:	74000088 	strvc	r0, [r0], #-136	; 0xffffff78
     698:	01000000 	mrseq	r0, (UNDEF: 0)
     69c:	0005b19c 	muleq	r5, ip, r1
     6a0:	06431c00 	strbeq	r1, [r3], -r0, lsl #24
     6a4:	04980000 	ldreq	r0, [r8], #0
     6a8:	91020000 	mrsls	r0, (UNDEF: 2)
     6ac:	69701d74 	ldmdbvs	r0!, {r2, r4, r5, r6, r8, sl, fp, ip}^
     6b0:	9e01006e 	cdpls	0, 0, cr0, cr1, cr14, {3}
     6b4:	00005431 	andeq	r5, r0, r1, lsr r4
     6b8:	70910200 	addsvc	r0, r1, r0, lsl #4
     6bc:	6765721d 			; <UNDEFINED> instruction: 0x6765721d
     6c0:	409e0100 	addsmi	r0, lr, r0, lsl #2
     6c4:	0000049d 	muleq	r0, sp, r4
     6c8:	1a6c9102 	bne	1b24ad8 <_bss_end+0x1b1b890>
     6cc:	000006f3 	strdeq	r0, [r0], -r3
     6d0:	9d4f9e01 	stclls	14, cr9, [pc, #-4]	; 6d4 <CPSR_IRQ_INHIBIT+0x654>
     6d4:	02000004 	andeq	r0, r0, #4
     6d8:	1b006891 	blne	1a924 <_bss_end+0x116dc>
     6dc:	000003bc 			; <UNDEFINED> instruction: 0x000003bc
     6e0:	cb069501 	blgt	1a5aec <_bss_end+0x19c8a4>
     6e4:	78000005 	stmdavc	r0, {r0, r2}
     6e8:	d8000087 	stmdale	r0, {r0, r1, r2, r7}
     6ec:	01000000 	mrseq	r0, (UNDEF: 0)
     6f0:	0006149c 	muleq	r6, ip, r4
     6f4:	06431c00 	strbeq	r1, [r3], -r0, lsl #24
     6f8:	04a90000 	strteq	r0, [r9], #0
     6fc:	91020000 	mrsls	r0, (UNDEF: 2)
     700:	69701d6c 	ldmdbvs	r0!, {r2, r3, r5, r6, r8, sl, fp, ip}^
     704:	9501006e 	strls	r0, [r1, #-110]	; 0xffffff92
     708:	00005429 	andeq	r5, r0, r9, lsr #8
     70c:	68910200 	ldmvs	r1, {r9}
     710:	7465731d 	strbtvc	r7, [r5], #-797	; 0xfffffce3
     714:	33950100 	orrscc	r0, r5, #0, 2
     718:	0000048b 	andeq	r0, r0, fp, lsl #9
     71c:	1e679102 	lgnnes	f1, f2
     720:	00676572 	rsbeq	r6, r7, r2, ror r5
     724:	540e9701 	strpl	r9, [lr], #-1793	; 0xfffff8ff
     728:	02000000 	andeq	r0, r0, #0
     72c:	621e7491 	andsvs	r7, lr, #-1862270976	; 0x91000000
     730:	01007469 	tsteq	r0, r9, ror #8
     734:	00541397 			; <UNDEFINED> instruction: 0x00541397
     738:	91020000 	mrsls	r0, (UNDEF: 2)
     73c:	261b0070 			; <UNDEFINED> instruction: 0x261b0070
     740:	01000004 	tsteq	r0, r4
     744:	062e068a 	strteq	r0, [lr], -sl, lsl #13
     748:	86c40000 	strbhi	r0, [r4], r0
     74c:	00b40000 	adcseq	r0, r4, r0
     750:	9c010000 	stcls	0, cr0, [r1], {-0}
     754:	00000686 	andeq	r0, r0, r6, lsl #13
     758:	0006431c 	andeq	r4, r6, ip, lsl r3
     75c:	0004a900 	andeq	sl, r4, r0, lsl #18
     760:	64910200 	ldrvs	r0, [r1], #512	; 0x200
     764:	6e69701d 	mcrvs	0, 3, r7, cr9, cr13, {0}
     768:	338a0100 	orrcc	r0, sl, #0, 2
     76c:	00000054 	andeq	r0, r0, r4, asr r0
     770:	1a609102 	bne	1824b80 <_bss_end+0x181b938>
     774:	00001f8e 	andeq	r1, r0, lr, lsl #31
     778:	244d8a01 	strbcs	r8, [sp], #-2561	; 0xfffff5ff
     77c:	02000002 	andeq	r0, r0, #2
     780:	721e5c91 	andsvc	r5, lr, #37120	; 0x9100
     784:	01006765 	tsteq	r0, r5, ror #14
     788:	00540e8c 	subseq	r0, r4, ip, lsl #29
     78c:	91020000 	mrsls	r0, (UNDEF: 2)
     790:	69621e70 	stmdbvs	r2!, {r4, r5, r6, r9, sl, fp, ip}^
     794:	8c010074 	stchi	0, cr0, [r1], {116}	; 0x74
     798:	00005413 	andeq	r5, r0, r3, lsl r4
     79c:	6c910200 	lfmvs	f0, 4, [r1], {0}
     7a0:	6c61761e 	stclvs	6, cr7, [r1], #-120	; 0xffffff88
     7a4:	0e900100 	fmleqs	f0, f0, f0
     7a8:	00000054 	andeq	r0, r0, r4, asr r0
     7ac:	00749102 	rsbseq	r9, r4, r2, lsl #2
     7b0:	00044b1f 	andeq	r4, r4, pc, lsl fp
     7b4:	066e0100 	strbteq	r0, [lr], -r0, lsl #2
     7b8:	000006a0 	andeq	r0, r0, r0, lsr #13
     7bc:	000085b8 			; <UNDEFINED> instruction: 0x000085b8
     7c0:	0000010c 	andeq	r0, r0, ip, lsl #2
     7c4:	06e99c01 	strbteq	r9, [r9], r1, lsl #24
     7c8:	431c0000 	tstmi	ip, #0
     7cc:	98000006 	stmdals	r0, {r1, r2}
     7d0:	02000004 	andeq	r0, r0, #4
     7d4:	701d7491 	mulsvc	sp, r1, r4
     7d8:	01006e69 	tsteq	r0, r9, ror #28
     7dc:	0054396e 	subseq	r3, r4, lr, ror #18
     7e0:	91020000 	mrsls	r0, (UNDEF: 2)
     7e4:	1f8e1a70 	svcne	0x008e1a70
     7e8:	6e010000 	cdpvs	0, 0, cr0, cr1, cr0, {0}
     7ec:	00022453 	andeq	r2, r2, r3, asr r4
     7f0:	6c910200 	lfmvs	f0, 4, [r1], {0}
     7f4:	6765721d 			; <UNDEFINED> instruction: 0x6765721d
     7f8:	636e0100 	cmnvs	lr, #0, 2
     7fc:	0000049d 	muleq	r0, sp, r4
     800:	1a689102 	bne	1a24c10 <_bss_end+0x1a1b9c8>
     804:	000006f3 	strdeq	r0, [r0], -r3
     808:	9d726e01 	ldclls	14, cr6, [r2, #-4]!
     80c:	02000004 	andeq	r0, r0, #4
     810:	1b000091 	blne	a5c <CPSR_IRQ_INHIBIT+0x9dc>
     814:	00000401 	andeq	r0, r0, r1, lsl #8
     818:	03065f01 	movweq	r5, #28417	; 0x6f01
     81c:	34000007 	strcc	r0, [r0], #-7
     820:	84000085 	strhi	r0, [r0], #-133	; 0xffffff7b
     824:	01000000 	mrseq	r0, (UNDEF: 0)
     828:	00074c9c 	muleq	r7, ip, ip
     82c:	06431c00 	strbeq	r1, [r3], -r0, lsl #24
     830:	04a90000 	strteq	r0, [r9], #0
     834:	91020000 	mrsls	r0, (UNDEF: 2)
     838:	69701d6c 	ldmdbvs	r0!, {r2, r3, r5, r6, r8, sl, fp, ip}^
     83c:	5f01006e 	svcpl	0x0001006e
     840:	00005432 	andeq	r5, r0, r2, lsr r4
     844:	68910200 	ldmvs	r1, {r9}
     848:	001f8e1a 	andseq	r8, pc, sl, lsl lr	; <UNPREDICTABLE>
     84c:	4c5f0100 	ldfmie	f0, [pc], {-0}
     850:	00000224 	andeq	r0, r0, r4, lsr #4
     854:	1e649102 	lgnnes	f1, f2
     858:	00676572 	rsbeq	r6, r7, r2, ror r5
     85c:	540e6101 	strpl	r6, [lr], #-257	; 0xfffffeff
     860:	02000000 	andeq	r0, r0, #0
     864:	621e7491 	andsvs	r7, lr, #-1862270976	; 0x91000000
     868:	01007469 	tsteq	r0, r9, ror #8
     86c:	00541361 	subseq	r1, r4, r1, ror #6
     870:	91020000 	mrsls	r0, (UNDEF: 2)
     874:	981b0070 	ldmdals	fp, {r4, r5, r6}
     878:	01000003 	tsteq	r0, r3
     87c:	07661056 			; <UNDEFINED> instruction: 0x07661056
     880:	84b80000 	ldrthi	r0, [r8], #0
     884:	007c0000 	rsbseq	r0, ip, r0
     888:	9c010000 	stcls	0, cr0, [r1], {-0}
     88c:	000007a0 	andeq	r0, r0, r0, lsr #15
     890:	0006431c 	andeq	r4, r6, ip, lsl r3
     894:	00049800 	andeq	r9, r4, r0, lsl #16
     898:	6c910200 	lfmvs	f0, 4, [r1], {0}
     89c:	6e69701d 	mcrvs	0, 3, r7, cr9, cr13, {0}
     8a0:	3a560100 	bcc	1580ca8 <_bss_end+0x1577a60>
     8a4:	00000054 	andeq	r0, r0, r4, asr r0
     8a8:	1e689102 	lgnnee	f1, f2
     8ac:	00676572 	rsbeq	r6, r7, r2, ror r5
     8b0:	540e5801 	strpl	r5, [lr], #-2049	; 0xfffff7ff
     8b4:	02000000 	andeq	r0, r0, #0
     8b8:	621e7491 	andsvs	r7, lr, #-1862270976	; 0x91000000
     8bc:	01007469 	tsteq	r0, r9, ror #8
     8c0:	00541358 	subseq	r1, r4, r8, asr r3
     8c4:	91020000 	mrsls	r0, (UNDEF: 2)
     8c8:	731b0070 	tstvc	fp, #112	; 0x70
     8cc:	01000003 	tsteq	r0, r3
     8d0:	07ba064d 	ldreq	r0, [sl, sp, asr #12]!
     8d4:	84100000 	ldrhi	r0, [r0], #-0
     8d8:	00a80000 	adceq	r0, r8, r0
     8dc:	9c010000 	stcls	0, cr0, [r1], {-0}
     8e0:	00000803 	andeq	r0, r0, r3, lsl #16
     8e4:	0006431c 	andeq	r4, r6, ip, lsl r3
     8e8:	0004a900 	andeq	sl, r4, r0, lsl #18
     8ec:	6c910200 	lfmvs	f0, 4, [r1], {0}
     8f0:	6e69701d 	mcrvs	0, 3, r7, cr9, cr13, {0}
     8f4:	304d0100 	subcc	r0, sp, r0, lsl #2
     8f8:	00000054 	andeq	r0, r0, r4, asr r0
     8fc:	1a689102 	bne	1a24d0c <_bss_end+0x1a1bac4>
     900:	00000600 	andeq	r0, r0, r0, lsl #12
     904:	db444d01 	blle	1113d10 <_bss_end+0x110aac8>
     908:	02000001 	andeq	r0, r0, #1
     90c:	721e6791 	andsvc	r6, lr, #38010880	; 0x2440000
     910:	01006765 	tsteq	r0, r5, ror #14
     914:	00540e4f 	subseq	r0, r4, pc, asr #28
     918:	91020000 	mrsls	r0, (UNDEF: 2)
     91c:	69621e74 	stmdbvs	r2!, {r2, r4, r5, r6, r9, sl, fp, ip}^
     920:	4f010074 	svcmi	0x00010074
     924:	00005413 	andeq	r5, r0, r3, lsl r4
     928:	70910200 	addsvc	r0, r1, r0, lsl #4
     92c:	02f31f00 	rscseq	r1, r3, #0, 30
     930:	42010000 	andmi	r0, r1, #0
     934:	00081d06 	andeq	r1, r8, r6, lsl #26
     938:	00839c00 	addeq	r9, r3, r0, lsl #24
     93c:	00007400 	andeq	r7, r0, r0, lsl #8
     940:	579c0100 	ldrpl	r0, [ip, r0, lsl #2]
     944:	1c000008 	stcne	0, cr0, [r0], {8}
     948:	00000643 	andeq	r0, r0, r3, asr #12
     94c:	00000498 	muleq	r0, r8, r4
     950:	1d749102 	ldfnep	f1, [r4, #-8]!
     954:	006e6970 	rsbeq	r6, lr, r0, ror r9
     958:	54314201 	ldrtpl	r4, [r1], #-513	; 0xfffffdff
     95c:	02000000 	andeq	r0, r0, #0
     960:	721d7091 	andsvc	r7, sp, #145	; 0x91
     964:	01006765 	tsteq	r0, r5, ror #14
     968:	049d4042 	ldreq	r4, [sp], #66	; 0x42
     96c:	91020000 	mrsls	r0, (UNDEF: 2)
     970:	06f31a6c 	ldrbteq	r1, [r3], ip, ror #20
     974:	42010000 	andmi	r0, r1, #0
     978:	00049d4f 	andeq	r9, r4, pc, asr #26
     97c:	68910200 	ldmvs	r1, {r9}
     980:	02c51f00 	sbceq	r1, r5, #0, 30
     984:	37010000 	strcc	r0, [r1, -r0]
     988:	00087106 	andeq	r7, r8, r6, lsl #2
     98c:	00832800 	addeq	r2, r3, r0, lsl #16
     990:	00007400 	andeq	r7, r0, r0, lsl #8
     994:	ab9c0100 	blge	fe700d9c <_bss_end+0xfe6f7b54>
     998:	1c000008 	stcne	0, cr0, [r0], {8}
     99c:	00000643 	andeq	r0, r0, r3, asr #12
     9a0:	00000498 	muleq	r0, r8, r4
     9a4:	1d749102 	ldfnep	f1, [r4, #-8]!
     9a8:	006e6970 	rsbeq	r6, lr, r0, ror r9
     9ac:	54313701 	ldrtpl	r3, [r1], #-1793	; 0xfffff8ff
     9b0:	02000000 	andeq	r0, r0, #0
     9b4:	721d7091 	andsvc	r7, sp, #145	; 0x91
     9b8:	01006765 	tsteq	r0, r5, ror #14
     9bc:	049d4037 	ldreq	r4, [sp], #55	; 0x37
     9c0:	91020000 	mrsls	r0, (UNDEF: 2)
     9c4:	06f31a6c 	ldrbteq	r1, [r3], ip, ror #20
     9c8:	37010000 	strcc	r0, [r1, -r0]
     9cc:	00049d4f 	andeq	r9, r4, pc, asr #26
     9d0:	68910200 	ldmvs	r1, {r9}
     9d4:	02971f00 	addseq	r1, r7, #0, 30
     9d8:	2c010000 	stccs	0, cr0, [r1], {-0}
     9dc:	0008c506 	andeq	ip, r8, r6, lsl #10
     9e0:	0082b400 	addeq	fp, r2, r0, lsl #8
     9e4:	00007400 	andeq	r7, r0, r0, lsl #8
     9e8:	ff9c0100 			; <UNDEFINED> instruction: 0xff9c0100
     9ec:	1c000008 	stcne	0, cr0, [r0], {8}
     9f0:	00000643 	andeq	r0, r0, r3, asr #12
     9f4:	00000498 	muleq	r0, r8, r4
     9f8:	1d749102 	ldfnep	f1, [r4, #-8]!
     9fc:	006e6970 	rsbeq	r6, lr, r0, ror r9
     a00:	54312c01 	ldrtpl	r2, [r1], #-3073	; 0xfffff3ff
     a04:	02000000 	andeq	r0, r0, #0
     a08:	721d7091 	andsvc	r7, sp, #145	; 0x91
     a0c:	01006765 	tsteq	r0, r5, ror #14
     a10:	049d402c 	ldreq	r4, [sp], #44	; 0x2c
     a14:	91020000 	mrsls	r0, (UNDEF: 2)
     a18:	06f31a6c 	ldrbteq	r1, [r3], ip, ror #20
     a1c:	2c010000 	stccs	0, cr0, [r1], {-0}
     a20:	00049d4f 	andeq	r9, r4, pc, asr #26
     a24:	68910200 	ldmvs	r1, {r9}
     a28:	02691f00 	rsbeq	r1, r9, #0, 30
     a2c:	0c010000 	stceq	0, cr0, [r1], {-0}
     a30:	00091906 	andeq	r1, r9, r6, lsl #18
     a34:	0081a000 	addeq	sl, r1, r0
     a38:	00011400 	andeq	r1, r1, r0, lsl #8
     a3c:	539c0100 	orrspl	r0, ip, #0, 2
     a40:	1c000009 	stcne	0, cr0, [r0], {9}
     a44:	00000643 	andeq	r0, r0, r3, asr #12
     a48:	00000498 	muleq	r0, r8, r4
     a4c:	1d749102 	ldfnep	f1, [r4, #-8]!
     a50:	006e6970 	rsbeq	r6, lr, r0, ror r9
     a54:	54320c01 	ldrtpl	r0, [r2], #-3073	; 0xfffff3ff
     a58:	02000000 	andeq	r0, r0, #0
     a5c:	721d7091 	andsvc	r7, sp, #145	; 0x91
     a60:	01006765 	tsteq	r0, r5, ror #14
     a64:	049d410c 	ldreq	r4, [sp], #268	; 0x10c
     a68:	91020000 	mrsls	r0, (UNDEF: 2)
     a6c:	06f31a6c 	ldrbteq	r1, [r3], ip, ror #20
     a70:	0c010000 	stceq	0, cr0, [r1], {-0}
     a74:	00049d50 	andeq	r9, r4, r0, asr sp
     a78:	68910200 	ldmvs	r1, {r9}
     a7c:	034f2000 	movteq	r2, #61440	; 0xf000
     a80:	06010000 	streq	r0, [r1], -r0
     a84:	00096401 	andeq	r6, r9, r1, lsl #8
     a88:	097a0000 	ldmdbeq	sl!, {}^	; <UNPREDICTABLE>
     a8c:	43210000 			; <UNDEFINED> instruction: 0x43210000
     a90:	a9000006 	stmdbge	r0, {r1, r2}
     a94:	22000004 	andcs	r0, r0, #4
     a98:	00000571 	andeq	r0, r0, r1, ror r5
     a9c:	652b0601 	strvs	r0, [fp, #-1537]!	; 0xfffff9ff
     aa0:	00000000 	andeq	r0, r0, r0
     aa4:	00095323 	andeq	r5, r9, r3, lsr #6
     aa8:	0004de00 	andeq	sp, r4, r0, lsl #28
     aac:	00099100 	andeq	r9, r9, r0, lsl #2
     ab0:	00816c00 	addeq	r6, r1, r0, lsl #24
     ab4:	00003400 	andeq	r3, r0, r0, lsl #8
     ab8:	249c0100 	ldrcs	r0, [ip], #256	; 0x100
     abc:	00000964 	andeq	r0, r0, r4, ror #18
     ac0:	24749102 	ldrbtcs	r9, [r4], #-258	; 0xfffffefe
     ac4:	0000096d 	andeq	r0, r0, sp, ror #18
     ac8:	00709102 	rsbseq	r9, r0, r2, lsl #2
     acc:	00054f00 	andeq	r4, r5, r0, lsl #30
     ad0:	10000400 	andne	r0, r0, r0, lsl #8
     ad4:	04000003 	streq	r0, [r0], #-3
     ad8:	00000001 	andeq	r0, r0, r1
     adc:	09a00400 	stmibeq	r0!, {sl}
     ae0:	011b0000 	tsteq	fp, r0
     ae4:	89a80000 	stmibhi	r8!, {}	; <UNPREDICTABLE>
     ae8:	02780000 	rsbseq	r0, r8, #0
     aec:	04e10000 	strbteq	r0, [r1], #0
     af0:	01020000 	mrseq	r0, (UNDEF: 2)
     af4:	00053d08 	andeq	r3, r5, r8, lsl #26
     af8:	05020200 	streq	r0, [r2, #-512]	; 0xfffffe00
     afc:	000002ab 	andeq	r0, r0, fp, lsr #5
     b00:	69050403 	stmdbvs	r5, {r0, r1, sl}
     b04:	0400746e 	streq	r7, [r0], #-1134	; 0xfffffb92
     b08:	00000386 	andeq	r0, r0, r6, lsl #7
     b0c:	46070902 	strmi	r0, [r7], -r2, lsl #18
     b10:	02000000 	andeq	r0, r0, #0
     b14:	05340801 	ldreq	r0, [r4, #-2049]!	; 0xfffff7ff
     b18:	97040000 	strls	r0, [r4, -r0]
     b1c:	02000009 	andeq	r0, r0, #9
     b20:	0059070a 	subseq	r0, r9, sl, lsl #14
     b24:	02020000 	andeq	r0, r2, #0
     b28:	00058007 	andeq	r8, r5, r7
     b2c:	039c0400 	orrseq	r0, ip, #0, 8
     b30:	0b020000 	bleq	80b38 <_bss_end+0x778f0>
     b34:	00007107 	andeq	r7, r0, r7, lsl #2
     b38:	00600500 	rsbeq	r0, r0, r0, lsl #10
     b3c:	04020000 	streq	r0, [r2], #-0
     b40:	00154f07 	andseq	r4, r5, r7, lsl #30
     b44:	00710500 	rsbseq	r0, r1, r0, lsl #10
     b48:	71060000 	mrsvc	r0, (UNDEF: 6)
     b4c:	07000000 	streq	r0, [r0, -r0]
     b50:	006c6168 	rsbeq	r6, ip, r8, ror #2
     b54:	410b0703 	tstmi	fp, r3, lsl #14
     b58:	08000001 	stmdaeq	r0, {r0}
     b5c:	00000806 	andeq	r0, r0, r6, lsl #16
     b60:	781c0903 	ldmdavc	ip, {r0, r1, r8, fp}
     b64:	80000000 	andhi	r0, r0, r0
     b68:	080ee6b2 	stmdaeq	lr, {r1, r4, r5, r7, r9, sl, sp, lr, pc}
     b6c:	00000483 	andeq	r0, r0, r3, lsl #9
     b70:	4d1d0c03 	ldcmi	12, cr0, [sp, #-12]
     b74:	00000001 	andeq	r0, r0, r1
     b78:	08200000 	stmdaeq	r0!, {}	; <UNPREDICTABLE>
     b7c:	00000542 	andeq	r0, r0, r2, asr #10
     b80:	4d1d0f03 	ldcmi	15, cr0, [sp, #-12]
     b84:	00000001 	andeq	r0, r0, r1
     b88:	09202000 	stmdbeq	r0!, {sp}
     b8c:	000005f1 	strdeq	r0, [r0], -r1
     b90:	6c181203 	lfmvs	f1, 4, [r8], {3}
     b94:	36000000 	strcc	r0, [r0], -r0
     b98:	00073508 	andeq	r3, r7, r8, lsl #10
     b9c:	1d440300 	stclne	3, cr0, [r4, #-0]
     ba0:	0000014d 	andeq	r0, r0, sp, asr #2
     ba4:	20215000 	eorcs	r5, r1, r0
     ba8:	00025e08 	andeq	r5, r2, r8, lsl #28
     bac:	1d730300 	ldclne	3, cr0, [r3, #-0]
     bb0:	0000014d 	andeq	r0, r0, sp, asr #2
     bb4:	2000b200 	andcs	fp, r0, r0, lsl #4
     bb8:	00060508 	andeq	r0, r6, r8, lsl #10
     bbc:	1da60300 	stcne	3, cr0, [r6]
     bc0:	0000014d 	andeq	r0, r0, sp, asr #2
     bc4:	2000b400 	andcs	fp, r0, r0, lsl #8
     bc8:	000a070a 	andeq	r0, sl, sl, lsl #14
     bcc:	33040500 	movwcc	r0, #17664	; 0x4500
     bd0:	03000000 	movweq	r0, #0
     bd4:	540b10a8 	strpl	r1, [fp], #-168	; 0xffffff58
     bd8:	0000000a 	andeq	r0, r0, sl
     bdc:	00097f0b 	andeq	r7, r9, fp, lsl #30
     be0:	210b0100 	mrscs	r0, (UNDEF: 27)
     be4:	0200000e 	andeq	r0, r0, #14
     be8:	00095c0b 	andeq	r5, r9, fp, lsl #24
     bec:	cc0b0300 	stcgt	3, cr0, [fp], {-0}
     bf0:	0400000a 	streq	r0, [r0], #-10
     bf4:	0008a20b 	andeq	sl, r8, fp, lsl #4
     bf8:	8e0b0500 	cfsh32hi	mvfx0, mvfx11, #0
     bfc:	06000008 	streq	r0, [r0], -r8
     c00:	0009fb0b 	andeq	pc, r9, fp, lsl #22
     c04:	9a0b0700 	bls	2c280c <_bss_end+0x2b95c4>
     c08:	0800000a 	stmdaeq	r0, {r1, r3}
     c0c:	8e0c0000 	cdphi	0, 0, cr0, cr12, cr0, {0}
     c10:	02000000 	andeq	r0, r0, #0
     c14:	154a0704 	strbne	r0, [sl, #-1796]	; 0xfffff8fc
     c18:	46050000 	strmi	r0, [r5], -r0
     c1c:	0c000001 	stceq	0, cr0, [r0], {1}
     c20:	0000009e 	muleq	r0, lr, r0
     c24:	0000ae0c 	andeq	sl, r0, ip, lsl #28
     c28:	00be0c00 	adcseq	r0, lr, r0, lsl #24
     c2c:	cb0c0000 	blgt	300c34 <_bss_end+0x2f79ec>
     c30:	0c000000 	stceq	0, cr0, [r0], {-0}
     c34:	000000db 	ldrdeq	r0, [r0], -fp
     c38:	0000eb0c 	andeq	lr, r0, ip, lsl #22
     c3c:	09140d00 	ldmdbeq	r4, {r8, sl, fp}
     c40:	01070000 	mrseq	r0, (UNDEF: 7)
     c44:	0000003a 	andeq	r0, r0, sl, lsr r0
     c48:	950c0604 	strls	r0, [ip, #-1540]	; 0xfffff9fc
     c4c:	0b000001 	bleq	c58 <CPSR_IRQ_INHIBIT+0xbd8>
     c50:	0000093c 	andeq	r0, r0, ip, lsr r9
     c54:	09660b00 	stmdbeq	r6!, {r8, r9, fp}^
     c58:	0b010000 	bleq	40c60 <_bss_end+0x37a18>
     c5c:	000008ec 	andeq	r0, r0, ip, ror #17
     c60:	590e0002 	stmdbpl	lr, {r1}
     c64:	0800000a 	stmdaeq	r0, {r1, r3}
     c68:	8d070d04 	stchi	13, cr0, [r7, #-16]
     c6c:	0f000002 	svceq	0x00000002
     c70:	00000973 	andeq	r0, r0, r3, ror r9
     c74:	8d1c1504 	cfldr32hi	mvfx1, [ip, #-16]
     c78:	00000002 	andeq	r0, r0, r2
     c7c:	000abc10 	andeq	fp, sl, r0, lsl ip
     c80:	0b110400 	bleq	441c88 <_bss_end+0x438a40>
     c84:	00000293 	muleq	r0, r3, r2
     c88:	0a600f01 	beq	1804894 <_bss_end+0x17fb64c>
     c8c:	18040000 	stmdane	r4, {}	; <UNPREDICTABLE>
     c90:	0001af15 	andeq	sl, r1, r5, lsl pc
     c94:	7a110400 	bvc	441c9c <_bss_end+0x438a54>
     c98:	04000009 	streq	r0, [r0], #-9
     c9c:	0a6a1c1b 	beq	1a87d10 <_bss_end+0x1a7eac8>
     ca0:	029a0000 	addseq	r0, sl, #0
     ca4:	e2020000 	and	r0, r2, #0
     ca8:	ed000001 	stc	0, cr0, [r0, #-4]
     cac:	12000001 	andne	r0, r0, #1
     cb0:	000002a0 	andeq	r0, r0, r0, lsr #5
     cb4:	0000fb13 	andeq	pc, r0, r3, lsl fp	; <UNPREDICTABLE>
     cb8:	59110000 	ldmdbpl	r1, {}	; <UNPREDICTABLE>
     cbc:	0400000a 	streq	r0, [r0], #-10
     cc0:	0a8b051e 	beq	fe2c2140 <_bss_end+0xfe2b8ef8>
     cc4:	02a00000 	adceq	r0, r0, #0
     cc8:	06010000 	streq	r0, [r1], -r0
     ccc:	11000002 	tstne	r0, r2
     cd0:	12000002 	andne	r0, r0, #2
     cd4:	000002a0 	andeq	r0, r0, r0, lsr #5
     cd8:	00014613 	andeq	r4, r1, r3, lsl r6
     cdc:	69140000 	ldmdbvs	r4, {}	; <UNPREDICTABLE>
     ce0:	0400000e 	streq	r0, [r0], #-14
     ce4:	08fa0a21 	ldmeq	sl!, {r0, r5, r9, fp}^
     ce8:	26010000 	strcs	r0, [r1], -r0
     cec:	3b000002 	blcc	cfc <CPSR_IRQ_INHIBIT+0xc7c>
     cf0:	12000002 	andne	r0, r0, #2
     cf4:	000002a0 	andeq	r0, r0, r0, lsr #5
     cf8:	0001af13 	andeq	sl, r1, r3, lsl pc
     cfc:	00711300 	rsbseq	r1, r1, r0, lsl #6
     d00:	70130000 	andsvc	r0, r3, r0
     d04:	00000001 	andeq	r0, r0, r1
     d08:	000c8914 	andeq	r8, ip, r4, lsl r9
     d0c:	0a230400 	beq	8c1d14 <_bss_end+0x8b8acc>
     d10:	00000a11 	andeq	r0, r0, r1, lsl sl
     d14:	00025001 	andeq	r5, r2, r1
     d18:	00025600 	andeq	r5, r2, r0, lsl #12
     d1c:	02a01200 	adceq	r1, r0, #0, 4
     d20:	14000000 	strne	r0, [r0], #-0
     d24:	00000895 	muleq	r0, r5, r8
     d28:	d40a2604 	strle	r2, [sl], #-1540	; 0xfffff9fc
     d2c:	0100000a 	tsteq	r0, sl
     d30:	0000026b 	andeq	r0, r0, fp, ror #4
     d34:	00000271 	andeq	r0, r0, r1, ror r2
     d38:	0002a012 	andeq	sl, r2, r2, lsl r0
     d3c:	a7150000 	ldrge	r0, [r5, -r0]
     d40:	0400000a 	streq	r0, [r0], #-10
     d44:	08480a28 	stmdaeq	r8, {r3, r5, r9, fp}^
     d48:	02ab0000 	adceq	r0, fp, #0
     d4c:	86010000 	strhi	r0, [r1], -r0
     d50:	12000002 	andne	r0, r0, #2
     d54:	000002a0 	andeq	r0, r0, r0, lsr #5
     d58:	04160000 	ldreq	r0, [r6], #-0
     d5c:	0000007d 	andeq	r0, r0, sp, ror r0
     d60:	02990416 	addseq	r0, r9, #369098752	; 0x16000000
     d64:	18170000 	ldmdane	r7, {}	; <UNPREDICTABLE>
     d68:	00007d04 	andeq	r7, r0, r4, lsl #26
     d6c:	95041600 	strls	r1, [r4, #-1536]	; 0xfffffa00
     d70:	05000001 	streq	r0, [r0, #-1]
     d74:	000002a0 	andeq	r0, r0, r0, lsr #5
     d78:	a5020102 	strge	r0, [r2, #-258]	; 0xfffffefe
     d7c:	19000003 	stmdbne	r0, {r0, r1}
     d80:	00000841 	andeq	r0, r0, r1, asr #16
     d84:	950f2b04 	strls	r2, [pc, #-2820]	; 288 <CPSR_IRQ_INHIBIT+0x208>
     d88:	1a000001 	bne	d94 <CPSR_IRQ_INHIBIT+0xd14>
     d8c:	000002b2 			; <UNDEFINED> instruction: 0x000002b2
     d90:	05080401 	streq	r0, [r8, #-1025]	; 0xfffffbff
     d94:	00922803 	addseq	r2, r2, r3, lsl #16
     d98:	0a431b00 	beq	10c79a0 <_bss_end+0x10be758>
     d9c:	01060000 	mrseq	r0, (UNDEF: 6)
     da0:	039a0808 	orrseq	r0, sl, #8, 16	; 0x80000
     da4:	b31c0000 	tstlt	ip, #0
     da8:	01000008 	tsteq	r0, r8
     dac:	003a0d0a 	eorseq	r0, sl, sl, lsl #26
     db0:	01010000 	mrseq	r0, (UNDEF: 1)
     db4:	e01c0007 	ands	r0, ip, r7
     db8:	01000008 	tsteq	r0, r8
     dbc:	003a0d0b 	eorseq	r0, sl, fp, lsl #26
     dc0:	01010000 	mrseq	r0, (UNDEF: 1)
     dc4:	321c0006 	andscc	r0, ip, #6
     dc8:	01000009 	tsteq	r0, r9
     dcc:	003a0d0c 	eorseq	r0, sl, ip, lsl #26
     dd0:	02010000 	andeq	r0, r1, #0
     dd4:	bc1c0004 	ldclt	0, cr0, [ip], {4}
     dd8:	01000008 	tsteq	r0, r8
     ddc:	003a0d0d 	eorseq	r0, sl, sp, lsl #26
     de0:	01010000 	mrseq	r0, (UNDEF: 1)
     de4:	851c0003 	ldrhi	r0, [ip, #-3]
     de8:	01000009 	tsteq	r0, r9
     dec:	003a0d0e 	eorseq	r0, sl, lr, lsl #26
     df0:	01010000 	mrseq	r0, (UNDEF: 1)
     df4:	c51c0002 	ldrgt	r0, [ip, #-2]
     df8:	01000008 	tsteq	r0, r8
     dfc:	003a0d0f 	eorseq	r0, sl, pc, lsl #26
     e00:	01010000 	mrseq	r0, (UNDEF: 1)
     e04:	351c0001 	ldrcc	r0, [ip, #-1]
     e08:	0100000a 	tsteq	r0, sl
     e0c:	003a0d10 	eorseq	r0, sl, r0, lsl sp
     e10:	01010000 	mrseq	r0, (UNDEF: 1)
     e14:	6b1c0000 	blvs	700e1c <_bss_end+0x6f7bd4>
     e18:	01000008 	tsteq	r0, r8
     e1c:	003a0d11 	eorseq	r0, sl, r1, lsl sp
     e20:	01010000 	mrseq	r0, (UNDEF: 1)
     e24:	481c0107 	ldmdami	ip, {r0, r1, r2, r8}
     e28:	01000009 	tsteq	r0, r9
     e2c:	003a0d12 	eorseq	r0, sl, r2, lsl sp
     e30:	01010000 	mrseq	r0, (UNDEF: 1)
     e34:	ce1d0106 	mufgte	f0, f5, f6
     e38:	01000008 	tsteq	r0, r8
     e3c:	004d0e13 	subeq	r0, sp, r3, lsl lr
     e40:	0a020000 	beq	80e48 <_bss_end+0x77c00>
     e44:	251d007c 	ldrcs	r0, [sp, #-124]	; 0xffffff84
     e48:	01000009 	tsteq	r0, r9
     e4c:	004d0e14 	subeq	r0, sp, r4, lsl lr
     e50:	10020000 	andne	r0, r2, r0
     e54:	d71c027c 			; <UNDEFINED> instruction: 0xd71c027c
     e58:	01000008 	tsteq	r0, r8
     e5c:	004d0e15 	subeq	r0, sp, r5, lsl lr
     e60:	0a020000 	beq	80e68 <_bss_end+0x77c20>
     e64:	06000402 	streq	r0, [r0], -r2, lsl #8
     e68:	000002cc 	andeq	r0, r0, ip, asr #5
     e6c:	0008321e 	andeq	r3, r8, lr, lsl r2
     e70:	008c0400 	addeq	r0, ip, r0, lsl #8
     e74:	00001c00 	andeq	r1, r0, r0, lsl #24
     e78:	1f9c0100 	svcne	0x009c0100
     e7c:	00000610 	andeq	r0, r0, r0, lsl r6
     e80:	00008bb0 			; <UNDEFINED> instruction: 0x00008bb0
     e84:	00000054 	andeq	r0, r0, r4, asr r0
     e88:	03e09c01 	mvneq	r9, #256	; 0x100
     e8c:	cf200000 	svcgt	0x00200000
     e90:	01000004 	tsteq	r0, r4
     e94:	0033014a 	eorseq	r0, r3, sl, asr #2
     e98:	91020000 	mrsls	r0, (UNDEF: 2)
     e9c:	06fb2074 	uxtaheq	r2, fp, r4
     ea0:	4a010000 	bmi	40ea8 <_bss_end+0x37c60>
     ea4:	00003301 	andeq	r3, r0, r1, lsl #6
     ea8:	70910200 	addsvc	r0, r1, r0, lsl #4
     eac:	02712100 	rsbseq	r2, r1, #0, 2
     eb0:	47010000 	strmi	r0, [r1, -r0]
     eb4:	0003fa06 	andeq	pc, r3, r6, lsl #20
     eb8:	008b7000 	addeq	r7, fp, r0
     ebc:	00004000 	andeq	r4, r0, r0
     ec0:	079c0100 	ldreq	r0, [ip, r0, lsl #2]
     ec4:	22000004 	andcs	r0, r0, #4
     ec8:	00000643 	andeq	r0, r0, r3, asr #12
     ecc:	000002a6 	andeq	r0, r0, r6, lsr #5
     ed0:	00749102 	rsbseq	r9, r4, r2, lsl #2
     ed4:	00025621 	andeq	r5, r2, r1, lsr #12
     ed8:	063f0100 	ldrteq	r0, [pc], -r0, lsl #2
     edc:	00000421 	andeq	r0, r0, r1, lsr #8
     ee0:	00008b38 	andeq	r8, r0, r8, lsr fp
     ee4:	00000038 	andeq	r0, r0, r8, lsr r0
     ee8:	042e9c01 	strteq	r9, [lr], #-3073	; 0xfffff3ff
     eec:	43220000 			; <UNDEFINED> instruction: 0x43220000
     ef0:	a6000006 	strge	r0, [r0], -r6
     ef4:	02000002 	andeq	r0, r0, #2
     ef8:	21007491 			; <UNDEFINED> instruction: 0x21007491
     efc:	0000023b 	andeq	r0, r0, fp, lsr r2
     f00:	48063701 	stmdami	r6, {r0, r8, r9, sl, ip, sp}
     f04:	ec000004 	stc	0, cr0, [r0], {4}
     f08:	4c00008a 	stcmi	0, cr0, [r0], {138}	; 0x8a
     f0c:	01000000 	mrseq	r0, (UNDEF: 0)
     f10:	0004649c 	muleq	r4, ip, r4
     f14:	06432200 	strbeq	r2, [r3], -r0, lsl #4
     f18:	02a60000 	adceq	r0, r6, #0
     f1c:	91020000 	mrsls	r0, (UNDEF: 2)
     f20:	6572236c 	ldrbvs	r2, [r2, #-876]!	; 0xfffffc94
     f24:	39010067 	stmdbcc	r1, {r0, r1, r2, r5, r6}
     f28:	00046420 	andeq	r6, r4, r0, lsr #8
     f2c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     f30:	9a041800 	bls	106f38 <_bss_end+0xfdcf0>
     f34:	21000003 	tstcs	r0, r3
     f38:	00000211 	andeq	r0, r0, r1, lsl r2
     f3c:	84062601 	strhi	r2, [r6], #-1537	; 0xfffff9ff
     f40:	20000004 	andcs	r0, r0, r4
     f44:	cc00008a 	stcgt	0, cr0, [r0], {138}	; 0x8a
     f48:	01000000 	mrseq	r0, (UNDEF: 0)
     f4c:	0004cd9c 	muleq	r4, ip, sp
     f50:	06432200 	strbeq	r2, [r3], -r0, lsl #4
     f54:	02a60000 	adceq	r0, r6, #0
     f58:	91020000 	mrsls	r0, (UNDEF: 2)
     f5c:	0aef2064 	beq	ffbc90f4 <_bss_end+0xffbbfeac>
     f60:	26010000 	strcs	r0, [r1], -r0
     f64:	0001af25 	andeq	sl, r1, r5, lsr #30
     f68:	60910200 	addsvs	r0, r1, r0, lsl #4
     f6c:	0008ad20 	andeq	sl, r8, r0, lsr #26
     f70:	3c260100 	stfccs	f0, [r6], #-0
     f74:	00000071 	andeq	r0, r0, r1, ror r0
     f78:	205c9102 	subscs	r9, ip, r2, lsl #2
     f7c:	00000932 	andeq	r0, r0, r2, lsr r9
     f80:	70542601 	subsvc	r2, r4, r1, lsl #12
     f84:	02000001 	andeq	r0, r0, #1
     f88:	72235b91 	eorvc	r5, r3, #148480	; 0x24400
     f8c:	01006765 	tsteq	r0, r5, ror #14
     f90:	02cc162a 	sbceq	r1, ip, #44040192	; 0x2a00000
     f94:	91020000 	mrsls	r0, (UNDEF: 2)
     f98:	c9240068 	stmdbgt	r4!, {r3, r5, r6}
     f9c:	01000001 	tsteq	r0, r1
     fa0:	04e71821 	strbteq	r1, [r7], #2081	; 0x821
     fa4:	89e80000 	stmibhi	r8!, {}^	; <UNPREDICTABLE>
     fa8:	00380000 	eorseq	r0, r8, r0
     fac:	9c010000 	stcls	0, cr0, [r1], {-0}
     fb0:	00000503 	andeq	r0, r0, r3, lsl #10
     fb4:	00064322 	andeq	r4, r6, r2, lsr #6
     fb8:	0002a600 	andeq	sl, r2, r0, lsl #12
     fbc:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     fc0:	67657225 	strbvs	r7, [r5, -r5, lsr #4]!
     fc4:	34210100 	strtcc	r0, [r1], #-256	; 0xffffff00
     fc8:	000000fb 	strdeq	r0, [r0], -fp
     fcc:	00709102 	rsbseq	r9, r0, r2, lsl #2
     fd0:	0001ed26 	andeq	lr, r1, r6, lsr #26
     fd4:	011a0100 	tsteq	sl, r0, lsl #2
     fd8:	00000514 	andeq	r0, r0, r4, lsl r5
     fdc:	00052a00 	andeq	r2, r5, r0, lsl #20
     fe0:	06432700 	strbeq	r2, [r3], -r0, lsl #14
     fe4:	02a60000 	adceq	r0, r6, #0
     fe8:	26280000 	strtcs	r0, [r8], -r0
     fec:	0100000a 	tsteq	r0, sl
     ff0:	01461e1a 	cmpeq	r6, sl, lsl lr
     ff4:	29000000 	stmdbcs	r0, {}	; <UNPREDICTABLE>
     ff8:	00000503 	andeq	r0, r0, r3, lsl #10
     ffc:	0000087f 	andeq	r0, r0, pc, ror r8
    1000:	00000541 	andeq	r0, r0, r1, asr #10
    1004:	000089a8 	andeq	r8, r0, r8, lsr #19
    1008:	00000040 	andeq	r0, r0, r0, asr #32
    100c:	142a9c01 	strtne	r9, [sl], #-3073	; 0xfffff3ff
    1010:	02000005 	andeq	r0, r0, #5
    1014:	1d2a7491 	cfstrsne	mvf7, [sl, #-580]!	; 0xfffffdbc
    1018:	02000005 	andeq	r0, r0, #5
    101c:	00007091 	muleq	r0, r1, r0
    1020:	00000965 	andeq	r0, r0, r5, ror #18
    1024:	05b80004 	ldreq	r0, [r8, #4]!
    1028:	01040000 	mrseq	r0, (UNDEF: 4)
    102c:	00000000 	andeq	r0, r0, r0
    1030:	000d8904 	andeq	r8, sp, r4, lsl #18
    1034:	00011b00 	andeq	r1, r1, r0, lsl #22
    1038:	008c2000 	addeq	r2, ip, r0
    103c:	00029400 	andeq	r9, r2, r0, lsl #8
    1040:	0006c900 	andeq	ip, r6, r0, lsl #18
    1044:	08010200 	stmdaeq	r1, {r9}
    1048:	0000053d 	andeq	r0, r0, sp, lsr r5
    104c:	ab050202 	blge	14185c <_bss_end+0x138614>
    1050:	03000002 	movweq	r0, #2
    1054:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
    1058:	86040074 			; <UNDEFINED> instruction: 0x86040074
    105c:	02000003 	andeq	r0, r0, #3
    1060:	00460709 	subeq	r0, r6, r9, lsl #14
    1064:	01020000 	mrseq	r0, (UNDEF: 2)
    1068:	00053408 	andeq	r3, r5, r8, lsl #8
    106c:	07020200 	streq	r0, [r2, -r0, lsl #4]
    1070:	00000580 	andeq	r0, r0, r0, lsl #11
    1074:	00039c04 	andeq	r9, r3, r4, lsl #24
    1078:	070b0200 	streq	r0, [fp, -r0, lsl #4]
    107c:	00000065 	andeq	r0, r0, r5, rrx
    1080:	00005405 	andeq	r5, r0, r5, lsl #8
    1084:	07040200 	streq	r0, [r4, -r0, lsl #4]
    1088:	0000154f 	andeq	r1, r0, pc, asr #10
    108c:	00006505 	andeq	r6, r0, r5, lsl #10
    1090:	00650600 	rsbeq	r0, r5, r0, lsl #12
    1094:	68070000 	stmdavs	r7, {}	; <UNPREDICTABLE>
    1098:	03006c61 	movweq	r6, #3169	; 0xc61
    109c:	02280b07 	eoreq	r0, r8, #7168	; 0x1c00
    10a0:	06080000 	streq	r0, [r8], -r0
    10a4:	03000008 	movweq	r0, #8
    10a8:	006c1c09 	rsbeq	r1, ip, r9, lsl #24
    10ac:	b2800000 	addlt	r0, r0, #0
    10b0:	83080ee6 	movwhi	r0, #36582	; 0x8ee6
    10b4:	03000004 	movweq	r0, #4
    10b8:	02341d0c 	eorseq	r1, r4, #12, 26	; 0x300
    10bc:	00000000 	andeq	r0, r0, r0
    10c0:	42082000 	andmi	r2, r8, #0
    10c4:	03000005 	movweq	r0, #5
    10c8:	02341d0f 	eorseq	r1, r4, #960	; 0x3c0
    10cc:	00000000 	andeq	r0, r0, r0
    10d0:	f1092020 			; <UNDEFINED> instruction: 0xf1092020
    10d4:	03000005 	movweq	r0, #5
    10d8:	00601812 	rsbeq	r1, r0, r2, lsl r8
    10dc:	08360000 	ldmdaeq	r6!, {}	; <UNPREDICTABLE>
    10e0:	00000735 	andeq	r0, r0, r5, lsr r7
    10e4:	341d4403 	ldrcc	r4, [sp], #-1027	; 0xfffffbfd
    10e8:	00000002 	andeq	r0, r0, r2
    10ec:	08202150 	stmdaeq	r0!, {r4, r6, r8, sp}
    10f0:	0000025e 	andeq	r0, r0, lr, asr r2
    10f4:	341d7303 	ldrcc	r7, [sp], #-771	; 0xfffffcfd
    10f8:	00000002 	andeq	r0, r0, r2
    10fc:	0a2000b2 	beq	8013cc <_bss_end+0x7f8184>
    1100:	00000b9d 	muleq	r0, sp, fp
    1104:	00330405 	eorseq	r0, r3, r5, lsl #8
    1108:	75030000 	strvc	r0, [r3, #-0]
    110c:	00012e10 	andeq	r2, r1, r0, lsl lr
    1110:	0c4b0b00 	mcrreq	11, 0, r0, fp, cr0
    1114:	0b000000 	bleq	111c <CPSR_IRQ_INHIBIT+0x109c>
    1118:	00000e70 	andeq	r0, r0, r0, ror lr
    111c:	0e970b01 	vfnmseq.f64	d0, d7, d1
    1120:	0b020000 	bleq	81128 <_bss_end+0x77ee0>
    1124:	00000e1d 	andeq	r0, r0, sp, lsl lr
    1128:	0b7e0b03 	bleq	1f83d3c <_bss_end+0x1f7aaf4>
    112c:	0b040000 	bleq	101134 <_bss_end+0xf7eec>
    1130:	00000b8b 	andeq	r0, r0, fp, lsl #23
    1134:	0e5f0b05 	vnmlseq.f64	d16, d15, d5
    1138:	0b060000 	bleq	181140 <_bss_end+0x177ef8>
    113c:	00000ede 	ldrdeq	r0, [r0], -lr
    1140:	0eec0b07 	vfmaeq.f64	d16, d12, d7
    1144:	0b080000 	bleq	20114c <_bss_end+0x1f7f04>
    1148:	00000c7f 	andeq	r0, r0, pc, ror ip
    114c:	d80a0009 	stmdale	sl, {r0, r3}
    1150:	0500000b 	streq	r0, [r0, #-11]
    1154:	00003304 	andeq	r3, r0, r4, lsl #6
    1158:	10830300 	addne	r0, r3, r0, lsl #6
    115c:	00000171 	andeq	r0, r0, r1, ror r1
    1160:	000a5a0b 	andeq	r5, sl, fp, lsl #20
    1164:	4c0b0000 	stcmi	0, cr0, [fp], {-0}
    1168:	0100000b 	tsteq	r0, fp
    116c:	000ce90b 	andeq	lr, ip, fp, lsl #18
    1170:	f40b0200 	vst1.8	{d0-d3}, [fp], r0
    1174:	0300000c 	movweq	r0, #12
    1178:	000cff0b 	andeq	pc, ip, fp, lsl #30
    117c:	420b0400 	andmi	r0, fp, #0, 8
    1180:	0500000b 	streq	r0, [r0, #-11]
    1184:	000bb60b 	andeq	fp, fp, fp, lsl #12
    1188:	c70b0600 	strgt	r0, [fp, -r0, lsl #12]
    118c:	0700000b 	streq	r0, [r0, -fp]
    1190:	0e7e0a00 	vaddeq.f32	s1, s28, s0
    1194:	04050000 	streq	r0, [r5], #-0
    1198:	00000033 	andeq	r0, r0, r3, lsr r0
    119c:	d2108f03 	andsle	r8, r0, #3, 30
    11a0:	0c000001 	stceq	0, cr0, [r0], {1}
    11a4:	00585541 	subseq	r5, r8, r1, asr #10
    11a8:	0e0a0b1d 	vmoveq.32	d10[0], r0
    11ac:	0b2b0000 	bleq	ac11b4 <_bss_end+0xab7f6c>
    11b0:	00000efa 	strdeq	r0, [r0], -sl
    11b4:	0f000b2d 	svceq	0x00000b2d
    11b8:	0c2e0000 	stceq	0, cr0, [lr], #-0
    11bc:	00494d53 	subeq	r4, r9, r3, asr sp
    11c0:	0ea50b30 	vdup.16	<illegal reg q2.5>, r0
    11c4:	0b310000 	bleq	c411cc <_bss_end+0xc37f84>
    11c8:	00000eac 	andeq	r0, r0, ip, lsr #29
    11cc:	0eb30b32 	vmoveq.u16	r0, d3[2]
    11d0:	0b330000 	bleq	cc11d8 <_bss_end+0xcb7f90>
    11d4:	00000eba 			; <UNDEFINED> instruction: 0x00000eba
    11d8:	32490c34 	subcc	r0, r9, #52, 24	; 0x3400
    11dc:	0c350043 	ldceq	0, cr0, [r5], #-268	; 0xfffffef4
    11e0:	00495053 	subeq	r5, r9, r3, asr r0
    11e4:	43500c36 	cmpmi	r0, #13824	; 0x3600
    11e8:	0b37004d 	bleq	dc1324 <_bss_end+0xdb80dc>
    11ec:	00000b98 	muleq	r0, r8, fp
    11f0:	05080039 	streq	r0, [r8, #-57]	; 0xffffffc7
    11f4:	03000006 	movweq	r0, #6
    11f8:	02341da6 	eorseq	r1, r4, #10624	; 0x2980
    11fc:	b4000000 	strlt	r0, [r0], #-0
    1200:	070d2000 	streq	r2, [sp, -r0]
    1204:	0500000a 	streq	r0, [r0, #-10]
    1208:	00003304 	andeq	r3, r0, r4, lsl #6
    120c:	10a80300 	adcne	r0, r8, r0, lsl #6
    1210:	000a540b 	andeq	r5, sl, fp, lsl #8
    1214:	7f0b0000 	svcvc	0x000b0000
    1218:	01000009 	tsteq	r0, r9
    121c:	000e210b 	andeq	r2, lr, fp, lsl #2
    1220:	5c0b0200 	sfmpl	f0, 4, [fp], {-0}
    1224:	03000009 	movweq	r0, #9
    1228:	000acc0b 	andeq	ip, sl, fp, lsl #24
    122c:	a20b0400 	andge	r0, fp, #0, 8
    1230:	05000008 	streq	r0, [r0, #-8]
    1234:	00088e0b 	andeq	r8, r8, fp, lsl #28
    1238:	fb0b0600 	blx	2c2a42 <_bss_end+0x2b97fa>
    123c:	07000009 	streq	r0, [r0, -r9]
    1240:	000a9a0b 	andeq	r9, sl, fp, lsl #20
    1244:	00000800 	andeq	r0, r0, r0, lsl #16
    1248:	0000820e 	andeq	r8, r0, lr, lsl #4
    124c:	07040200 	streq	r0, [r4, -r0, lsl #4]
    1250:	0000154a 	andeq	r1, r0, sl, asr #10
    1254:	00022d05 	andeq	r2, r2, r5, lsl #26
    1258:	00920e00 	addseq	r0, r2, r0, lsl #28
    125c:	a20e0000 	andge	r0, lr, #0
    1260:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    1264:	000000b2 	strheq	r0, [r0], -r2
    1268:	0000bf0e 	andeq	fp, r0, lr, lsl #30
    126c:	00cf0e00 	sbceq	r0, pc, r0, lsl #28
    1270:	d20e0000 	andle	r0, lr, #0
    1274:	0a000001 	beq	1280 <CPSR_IRQ_INHIBIT+0x1200>
    1278:	000006b2 			; <UNDEFINED> instruction: 0x000006b2
    127c:	003a0107 	eorseq	r0, sl, r7, lsl #2
    1280:	06040000 	streq	r0, [r4], -r0
    1284:	0002a00c 	andeq	sl, r2, ip
    1288:	07510b00 	ldrbeq	r0, [r1, -r0, lsl #22]
    128c:	0b000000 	bleq	1294 <CPSR_IRQ_INHIBIT+0x1214>
    1290:	00000762 	andeq	r0, r0, r2, ror #14
    1294:	08250b01 	stmdaeq	r5!, {r0, r8, r9, fp}
    1298:	0b020000 	bleq	812a0 <_bss_end+0x78058>
    129c:	0000081f 	andeq	r0, r0, pc, lsl r8
    12a0:	07fa0b03 	ldrbeq	r0, [sl, r3, lsl #22]!
    12a4:	0b040000 	bleq	1012ac <_bss_end+0xf8064>
    12a8:	00000800 	andeq	r0, r0, r0, lsl #16
    12ac:	06cd0b05 	strbeq	r0, [sp], r5, lsl #22
    12b0:	0b060000 	bleq	1812b8 <_bss_end+0x178070>
    12b4:	00000819 	andeq	r0, r0, r9, lsl r8
    12b8:	03aa0b07 			; <UNDEFINED> instruction: 0x03aa0b07
    12bc:	00080000 	andeq	r0, r8, r0
    12c0:	0002f40a 	andeq	pc, r2, sl, lsl #8
    12c4:	33040500 	movwcc	r0, #17664	; 0x4500
    12c8:	04000000 	streq	r0, [r0], #-0
    12cc:	02cb0c18 	sbceq	r0, fp, #24, 24	; 0x1800
    12d0:	c10b0000 	mrsgt	r0, (UNDEF: 11)
    12d4:	00000006 	andeq	r0, r0, r6
    12d8:	0007ed0b 	andeq	lr, r7, fp, lsl #26
    12dc:	a60b0100 	strge	r0, [fp], -r0, lsl #2
    12e0:	02000002 	andeq	r0, r0, #2
    12e4:	776f4c0c 	strbvc	r4, [pc, -ip, lsl #24]!
    12e8:	0f000300 	svceq	0x00000300
    12ec:	00000431 	andeq	r0, r0, r1, lsr r4
    12f0:	07230404 	streq	r0, [r3, -r4, lsl #8]!
    12f4:	000004f7 	strdeq	r0, [r0], -r7
    12f8:	00036910 	andeq	r6, r3, r0, lsl r9
    12fc:	19270400 	stmdbne	r7!, {sl}
    1300:	00000502 	andeq	r0, r0, r2, lsl #10
    1304:	05dd1100 	ldrbeq	r1, [sp, #256]	; 0x100
    1308:	2b040000 	blcs	101310 <_bss_end+0xf80c8>
    130c:	0003390a 	andeq	r3, r3, sl, lsl #18
    1310:	00050700 	andeq	r0, r5, r0, lsl #14
    1314:	02fe0200 	rscseq	r0, lr, #0, 4
    1318:	03130000 	tsteq	r3, #0
    131c:	0e120000 	cdpeq	0, 1, cr0, cr2, cr0, {0}
    1320:	13000005 	movwne	r0, #5
    1324:	00000054 	andeq	r0, r0, r4, asr r0
    1328:	00051413 	andeq	r1, r5, r3, lsl r4
    132c:	05141300 	ldreq	r1, [r4, #-768]	; 0xfffffd00
    1330:	11000000 	mrsne	r0, (UNDEF: 0)
    1334:	0000073e 	andeq	r0, r0, lr, lsr r7
    1338:	050a2d04 	streq	r2, [sl, #-3332]	; 0xfffff2fc
    133c:	07000005 	streq	r0, [r0, -r5]
    1340:	02000005 	andeq	r0, r0, #5
    1344:	0000032c 	andeq	r0, r0, ip, lsr #6
    1348:	00000341 	andeq	r0, r0, r1, asr #6
    134c:	00050e12 	andeq	r0, r5, r2, lsl lr
    1350:	00541300 	subseq	r1, r4, r0, lsl #6
    1354:	14130000 	ldrne	r0, [r3], #-0
    1358:	13000005 	movwne	r0, #5
    135c:	00000514 	andeq	r0, r0, r4, lsl r5
    1360:	043f1100 	ldrteq	r1, [pc], #-256	; 1368 <CPSR_IRQ_INHIBIT+0x12e8>
    1364:	2f040000 	svccs	0x00040000
    1368:	0007060a 	andeq	r0, r7, sl, lsl #12
    136c:	00050700 	andeq	r0, r5, r0, lsl #14
    1370:	035a0200 	cmpeq	sl, #0, 4
    1374:	036f0000 	cmneq	pc, #0
    1378:	0e120000 	cdpeq	0, 1, cr0, cr2, cr0, {0}
    137c:	13000005 	movwne	r0, #5
    1380:	00000054 	andeq	r0, r0, r4, asr r0
    1384:	00051413 	andeq	r1, r5, r3, lsl r4
    1388:	05141300 	ldreq	r1, [r4, #-768]	; 0xfffffd00
    138c:	11000000 	mrsne	r0, (UNDEF: 0)
    1390:	00000493 	muleq	r0, r3, r4
    1394:	ea0a3104 	b	28d7ac <_bss_end+0x284564>
    1398:	07000001 	streq	r0, [r0, -r1]
    139c:	02000005 	andeq	r0, r0, #5
    13a0:	00000388 	andeq	r0, r0, r8, lsl #7
    13a4:	0000039d 	muleq	r0, sp, r3
    13a8:	00050e12 	andeq	r0, r5, r2, lsl lr
    13ac:	00541300 	subseq	r1, r4, r0, lsl #6
    13b0:	14130000 	ldrne	r0, [r3], #-0
    13b4:	13000005 	movwne	r0, #5
    13b8:	00000514 	andeq	r0, r0, r4, lsl r5
    13bc:	02931100 	addseq	r1, r3, #0, 2
    13c0:	32040000 	andcc	r0, r4, #0
    13c4:	0005ae0a 	andeq	sl, r5, sl, lsl #28
    13c8:	00050700 	andeq	r0, r5, r0, lsl #14
    13cc:	03b60200 			; <UNDEFINED> instruction: 0x03b60200
    13d0:	03cb0000 	biceq	r0, fp, #0
    13d4:	0e120000 	cdpeq	0, 1, cr0, cr2, cr0, {0}
    13d8:	13000005 	movwne	r0, #5
    13dc:	00000054 	andeq	r0, r0, r4, asr r0
    13e0:	00051413 	andeq	r1, r5, r3, lsl r4
    13e4:	05141300 	ldreq	r1, [r4, #-768]	; 0xfffffd00
    13e8:	11000000 	mrsne	r0, (UNDEF: 0)
    13ec:	00000431 	andeq	r0, r0, r1, lsr r4
    13f0:	6f053504 	svcvs	0x00053504
    13f4:	1a000003 	bne	1408 <CPSR_IRQ_INHIBIT+0x1388>
    13f8:	01000005 	tsteq	r0, r5
    13fc:	000003e4 	andeq	r0, r0, r4, ror #7
    1400:	000003ef 	andeq	r0, r0, pc, ror #7
    1404:	00051a12 	andeq	r1, r5, r2, lsl sl
    1408:	00651300 	rsbeq	r1, r5, r0, lsl #6
    140c:	14000000 	strne	r0, [r0], #-0
    1410:	000006e1 	andeq	r0, r0, r1, ror #13
    1414:	890a3804 	stmdbhi	sl, {r2, fp, ip, sp}
    1418:	01000006 	tsteq	r0, r6
    141c:	00000404 	andeq	r0, r0, r4, lsl #8
    1420:	00000414 	andeq	r0, r0, r4, lsl r4
    1424:	00051a12 	andeq	r1, r5, r2, lsl sl
    1428:	00541300 	subseq	r1, r4, r0, lsl #6
    142c:	57130000 	ldrpl	r0, [r3, -r0]
    1430:	00000002 	andeq	r0, r0, r2
    1434:	00041f11 	andeq	r1, r4, r1, lsl pc
    1438:	143a0400 	ldrtne	r0, [sl], #-1024	; 0xfffffc00
    143c:	000004a6 	andeq	r0, r0, r6, lsr #9
    1440:	00000257 	andeq	r0, r0, r7, asr r2
    1444:	00042d01 	andeq	r2, r4, r1, lsl #26
    1448:	00043800 	andeq	r3, r4, r0, lsl #16
    144c:	050e1200 	streq	r1, [lr, #-512]	; 0xfffffe00
    1450:	54130000 	ldrpl	r0, [r3], #-0
    1454:	00000000 	andeq	r0, r0, r0
    1458:	00075e14 	andeq	r5, r7, r4, lsl lr
    145c:	0a3d0400 	beq	f42464 <_bss_end+0xf3921c>
    1460:	00000317 	andeq	r0, r0, r7, lsl r3
    1464:	00044d01 	andeq	r4, r4, r1, lsl #26
    1468:	00045d00 	andeq	r5, r4, r0, lsl #26
    146c:	051a1200 	ldreq	r1, [sl, #-512]	; 0xfffffe00
    1470:	54130000 	ldrpl	r0, [r3], #-0
    1474:	13000000 	movwne	r0, #0
    1478:	00000507 	andeq	r0, r0, r7, lsl #10
    147c:	03b61400 			; <UNDEFINED> instruction: 0x03b61400
    1480:	3f040000 	svccc	0x00040000
    1484:	0004580a 	andeq	r5, r4, sl, lsl #16
    1488:	04720100 	ldrbteq	r0, [r2], #-256	; 0xffffff00
    148c:	047d0000 	ldrbteq	r0, [sp], #-0
    1490:	1a120000 	bne	481498 <_bss_end+0x478250>
    1494:	13000005 	movwne	r0, #5
    1498:	00000054 	andeq	r0, r0, r4, asr r0
    149c:	059a1400 	ldreq	r1, [sl, #1024]	; 0x400
    14a0:	41040000 	mrsmi	r0, (UNDEF: 4)
    14a4:	0002c90a 	andeq	ip, r2, sl, lsl #18
    14a8:	04920100 	ldreq	r0, [r2], #256	; 0x100
    14ac:	04a20000 	strteq	r0, [r2], #0
    14b0:	1a120000 	bne	4814b8 <_bss_end+0x478270>
    14b4:	13000005 	movwne	r0, #5
    14b8:	00000054 	andeq	r0, r0, r4, asr r0
    14bc:	0002a013 	andeq	sl, r2, r3, lsl r0
    14c0:	d8140000 	ldmdale	r4, {}	; <UNPREDICTABLE>
    14c4:	04000007 	streq	r0, [r0], #-7
    14c8:	06480a42 	strbeq	r0, [r8], -r2, asr #20
    14cc:	b7010000 	strlt	r0, [r1, -r0]
    14d0:	c7000004 	strgt	r0, [r0, -r4]
    14d4:	12000004 	andne	r0, r0, #4
    14d8:	0000051a 	andeq	r0, r0, sl, lsl r5
    14dc:	00005413 	andeq	r5, r0, r3, lsl r4
    14e0:	02a01300 	adceq	r1, r0, #0, 6
    14e4:	15000000 	strne	r0, [r0, #-0]
    14e8:	00000278 	andeq	r0, r0, r8, ror r2
    14ec:	d20a4304 	andle	r4, sl, #4, 6	; 0x10000000
    14f0:	07000003 	streq	r0, [r0, -r3]
    14f4:	01000005 	tsteq	r0, r5
    14f8:	000004dc 	ldrdeq	r0, [r0], -ip
    14fc:	00050e12 	andeq	r0, r5, r2, lsl lr
    1500:	00541300 	subseq	r1, r4, r0, lsl #6
    1504:	a0130000 	andsge	r0, r3, r0
    1508:	13000002 	movwne	r0, #2
    150c:	00000514 	andeq	r0, r0, r4, lsl r5
    1510:	00051413 	andeq	r1, r5, r3, lsl r4
    1514:	05000000 	streq	r0, [r0, #-0]
    1518:	000002cb 	andeq	r0, r0, fp, asr #5
    151c:	00650416 	rsbeq	r0, r5, r6, lsl r4
    1520:	fc050000 	stc2	0, cr0, [r5], {-0}
    1524:	02000004 	andeq	r0, r0, #4
    1528:	03a50201 			; <UNDEFINED> instruction: 0x03a50201
    152c:	04160000 	ldreq	r0, [r6], #-0
    1530:	000004f7 	strdeq	r0, [r0], -r7
    1534:	00540417 	subseq	r0, r4, r7, lsl r4
    1538:	04160000 	ldreq	r0, [r6], #-0
    153c:	000002cb 	andeq	r0, r0, fp, asr #5
    1540:	0007d218 	andeq	sp, r7, r8, lsl r2
    1544:	16470400 	strbne	r0, [r7], -r0, lsl #8
    1548:	000002cb 	andeq	r0, r0, fp, asr #5
    154c:	000c690f 	andeq	r6, ip, pc, lsl #18
    1550:	09050400 	stmdbeq	r5, {sl}
    1554:	00060b07 	andeq	r0, r6, r7, lsl #22
    1558:	0be91000 	bleq	ffa45560 <_bss_end+0xffa3c318>
    155c:	0d050000 	stceq	0, cr0, [r5, #-0]
    1560:	00060b1c 	andeq	r0, r6, ip, lsl fp
    1564:	7a110000 	bvc	44156c <_bss_end+0x438324>
    1568:	05000009 	streq	r0, [r0, #-9]
    156c:	0b011c10 	bleq	485b4 <_bss_end+0x3f36c>
    1570:	06110000 	ldreq	r0, [r1], -r0
    1574:	5f020000 	svcpl	0x00020000
    1578:	6a000005 	bvs	1594 <CPSR_IRQ_INHIBIT+0x1514>
    157c:	12000005 	andne	r0, r0, #5
    1580:	00000617 	andeq	r0, r0, r7, lsl r6
    1584:	0000df13 	andeq	sp, r0, r3, lsl pc
    1588:	69110000 	ldmdbvs	r1, {}	; <UNPREDICTABLE>
    158c:	0500000c 	streq	r0, [r0, #-12]
    1590:	0deb0513 	cfstr64eq	mvdx0, [fp, #76]!	; 0x4c
    1594:	06170000 	ldreq	r0, [r7], -r0
    1598:	83010000 	movwhi	r0, #4096	; 0x1000
    159c:	8e000005 	cdphi	0, 0, cr0, cr0, cr5, {0}
    15a0:	12000005 	andne	r0, r0, #5
    15a4:	00000617 	andeq	r0, r0, r7, lsl r6
    15a8:	00022d13 	andeq	r2, r2, r3, lsl sp
    15ac:	91140000 	tstls	r4, r0
    15b0:	0500000c 	streq	r0, [r0, #-12]
    15b4:	0d430a16 	vstreq	s1, [r3, #-88]	; 0xffffffa8
    15b8:	a3010000 	movwge	r0, #4096	; 0x1000
    15bc:	ae000005 	cdpge	0, 0, cr0, cr0, cr5, {0}
    15c0:	12000005 	andne	r0, r0, #5
    15c4:	00000617 	andeq	r0, r0, r7, lsl r6
    15c8:	00012e13 	andeq	r2, r1, r3, lsl lr
    15cc:	c1140000 	tstgt	r4, r0
    15d0:	0500000e 	streq	r0, [r0, #-14]
    15d4:	0ca20a18 	vstmiaeq	r2!, {s0-s23}
    15d8:	c3010000 	movwgt	r0, #4096	; 0x1000
    15dc:	ce000005 	cdpgt	0, 0, cr0, cr0, cr5, {0}
    15e0:	12000005 	andne	r0, r0, #5
    15e4:	00000617 	andeq	r0, r0, r7, lsl r6
    15e8:	00012e13 	andeq	r2, r1, r3, lsl lr
    15ec:	54140000 	ldrpl	r0, [r4], #-0
    15f0:	0500000b 	streq	r0, [r0, #-11]
    15f4:	0d090a1b 	vstreq	s0, [r9, #-108]	; 0xffffff94
    15f8:	e3010000 	movw	r0, #4096	; 0x1000
    15fc:	ee000005 	cdp	0, 0, cr0, cr0, cr5, {0}
    1600:	12000005 	andne	r0, r0, #5
    1604:	00000617 	andeq	r0, r0, r7, lsl r6
    1608:	00017113 	andeq	r7, r1, r3, lsl r1
    160c:	5d190000 	ldcpl	0, cr0, [r9, #-0]
    1610:	0500000c 	streq	r0, [r0, #-12]
    1614:	0bf90a1d 	bleq	ffe43e90 <_bss_end+0xffe3ac48>
    1618:	ff010000 			; <UNDEFINED> instruction: 0xff010000
    161c:	12000005 	andne	r0, r0, #5
    1620:	00000617 	andeq	r0, r0, r7, lsl r6
    1624:	00017113 	andeq	r7, r1, r3, lsl r1
    1628:	16000000 	strne	r0, [r0], -r0
    162c:	00007104 	andeq	r7, r0, r4, lsl #2
    1630:	71041700 	tstvc	r4, r0, lsl #14
    1634:	16000000 	strne	r0, [r0], -r0
    1638:	00052c04 	andeq	r2, r5, r4, lsl #24
    163c:	06170500 	ldreq	r0, [r7], -r0, lsl #10
    1640:	89180000 	ldmdbhi	r8, {}	; <UNPREDICTABLE>
    1644:	0500000e 	streq	r0, [r0, #-14]
    1648:	052c1e20 	streq	r1, [ip, #-3616]!	; 0xfffff1e0
    164c:	140a0000 	strne	r0, [sl], #-0
    1650:	07000009 	streq	r0, [r0, -r9]
    1654:	00003a01 	andeq	r3, r0, r1, lsl #20
    1658:	0c060600 	stceq	6, cr0, [r6], {-0}
    165c:	00000653 	andeq	r0, r0, r3, asr r6
    1660:	00093c0b 	andeq	r3, r9, fp, lsl #24
    1664:	660b0000 	strvs	r0, [fp], -r0
    1668:	01000009 	tsteq	r0, r9
    166c:	0008ec0b 	andeq	lr, r8, fp, lsl #24
    1670:	0f000200 	svceq	0x00000200
    1674:	00000a59 	andeq	r0, r0, r9, asr sl
    1678:	070d0608 	streq	r0, [sp, -r8, lsl #12]
    167c:	0000074b 	andeq	r0, r0, fp, asr #14
    1680:	00097310 	andeq	r7, r9, r0, lsl r3
    1684:	1c150600 	ldcne	6, cr0, [r5], {-0}
    1688:	0000060b 	andeq	r0, r0, fp, lsl #12
    168c:	0abc1a00 	beq	fef07e94 <_bss_end+0xfeefec4c>
    1690:	11060000 	mrsne	r0, (UNDEF: 6)
    1694:	00074b0b 	andeq	r4, r7, fp, lsl #22
    1698:	60100100 	andsvs	r0, r0, r0, lsl #2
    169c:	0600000a 	streq	r0, [r0], -sl
    16a0:	066d1518 			; <UNDEFINED> instruction: 0x066d1518
    16a4:	11040000 	mrsne	r0, (UNDEF: 4)
    16a8:	0000097a 	andeq	r0, r0, sl, ror r9
    16ac:	6a1c1b06 	bvs	7082cc <_bss_end+0x6ff084>
    16b0:	1100000a 	tstne	r0, sl
    16b4:	02000006 	andeq	r0, r0, #6
    16b8:	000006a0 	andeq	r0, r0, r0, lsr #13
    16bc:	000006ab 	andeq	r0, r0, fp, lsr #13
    16c0:	00075212 	andeq	r5, r7, r2, lsl r2
    16c4:	01e21300 	mvneq	r1, r0, lsl #6
    16c8:	11000000 	mrsne	r0, (UNDEF: 0)
    16cc:	00000a59 	andeq	r0, r0, r9, asr sl
    16d0:	8b051e06 	blhi	148ef0 <_bss_end+0x13fca8>
    16d4:	5200000a 	andpl	r0, r0, #10
    16d8:	01000007 	tsteq	r0, r7
    16dc:	000006c4 	andeq	r0, r0, r4, asr #13
    16e0:	000006cf 	andeq	r0, r0, pc, asr #13
    16e4:	00075212 	andeq	r5, r7, r2, lsl r2
    16e8:	022d1300 	eoreq	r1, sp, #0, 6
    16ec:	14000000 	strne	r0, [r0], #-0
    16f0:	00000e69 	andeq	r0, r0, r9, ror #28
    16f4:	fa0a2106 	blx	289b14 <_bss_end+0x2808cc>
    16f8:	01000008 	tsteq	r0, r8
    16fc:	000006e4 	andeq	r0, r0, r4, ror #13
    1700:	000006f9 	strdeq	r0, [r0], -r9
    1704:	00075212 	andeq	r5, r7, r2, lsl r2
    1708:	066d1300 	strbteq	r1, [sp], -r0, lsl #6
    170c:	65130000 	ldrvs	r0, [r3, #-0]
    1710:	13000000 	movwne	r0, #0
    1714:	0000062e 	andeq	r0, r0, lr, lsr #12
    1718:	0c891400 	cfstrseq	mvf1, [r9], {0}
    171c:	23060000 	movwcs	r0, #24576	; 0x6000
    1720:	000a110a 	andeq	r1, sl, sl, lsl #2
    1724:	070e0100 	streq	r0, [lr, -r0, lsl #2]
    1728:	07140000 	ldreq	r0, [r4, -r0]
    172c:	52120000 	andspl	r0, r2, #0
    1730:	00000007 	andeq	r0, r0, r7
    1734:	00089514 	andeq	r9, r8, r4, lsl r5
    1738:	0a260600 	beq	982f40 <_bss_end+0x979cf8>
    173c:	00000ad4 	ldrdeq	r0, [r0], -r4
    1740:	00072901 	andeq	r2, r7, r1, lsl #18
    1744:	00072f00 	andeq	r2, r7, r0, lsl #30
    1748:	07521200 	ldrbeq	r1, [r2, -r0, lsl #4]
    174c:	15000000 	strne	r0, [r0, #-0]
    1750:	00000aa7 	andeq	r0, r0, r7, lsr #21
    1754:	480a2806 	stmdami	sl, {r1, r2, fp, sp}
    1758:	07000008 	streq	r0, [r0, -r8]
    175c:	01000005 	tsteq	r0, r5
    1760:	00000744 	andeq	r0, r0, r4, asr #14
    1764:	00075212 	andeq	r5, r7, r2, lsl r2
    1768:	16000000 	strne	r0, [r0], -r0
    176c:	00075104 	andeq	r5, r7, r4, lsl #2
    1770:	04161b00 	ldreq	r1, [r6], #-2816	; 0xfffff500
    1774:	00000653 	andeq	r0, r0, r3, asr r6
    1778:	00084118 	andeq	r4, r8, r8, lsl r1
    177c:	0f2b0600 	svceq	0x002b0600
    1780:	00000653 	andeq	r0, r0, r3, asr r6
    1784:	0006221c 	andeq	r2, r6, ip, lsl r2
    1788:	17150100 	ldrne	r0, [r5, -r0, lsl #2]
    178c:	92300305 	eorsls	r0, r0, #335544320	; 0x14000000
    1790:	351d0000 	ldrcc	r0, [sp, #-0]
    1794:	9800000e 	stmdals	r0, {r1, r2, r3}
    1798:	1c00008e 	stcne	0, cr0, [r0], {142}	; 0x8e
    179c:	01000000 	mrseq	r0, (UNDEF: 0)
    17a0:	06101e9c 			; <UNDEFINED> instruction: 0x06101e9c
    17a4:	8e440000 	cdphi	0, 4, cr0, cr4, cr0, {0}
    17a8:	00540000 	subseq	r0, r4, r0
    17ac:	9c010000 	stcls	0, cr0, [r1], {-0}
    17b0:	000007b3 			; <UNDEFINED> instruction: 0x000007b3
    17b4:	0004cf1f 	andeq	ip, r4, pc, lsl pc
    17b8:	01370100 	teqeq	r7, r0, lsl #2
    17bc:	00000033 	andeq	r0, r0, r3, lsr r0
    17c0:	1f749102 	svcne	0x00749102
    17c4:	000006fb 	strdeq	r0, [r0], -fp
    17c8:	33013701 	movwcc	r3, #5889	; 0x1701
    17cc:	02000000 	andeq	r0, r0, #0
    17d0:	20007091 	mulcs	r0, r1, r0
    17d4:	000005ee 	andeq	r0, r0, lr, ror #11
    17d8:	cd063201 	sfmgt	f3, 4, [r6, #-4]
    17dc:	dc000007 	stcle	0, cr0, [r0], {7}
    17e0:	6800008d 	stmdavs	r0, {r0, r2, r3, r7}
    17e4:	01000000 	mrseq	r0, (UNDEF: 0)
    17e8:	0007f89c 	muleq	r7, ip, r8
    17ec:	06432100 	strbeq	r2, [r3], -r0, lsl #2
    17f0:	061d0000 	ldreq	r0, [sp], -r0
    17f4:	91020000 	mrsls	r0, (UNDEF: 2)
    17f8:	0ed31f64 	cdpeq	15, 13, cr1, cr3, cr4, {3}
    17fc:	32010000 	andcc	r0, r1, #0
    1800:	00017139 	andeq	r7, r1, r9, lsr r1
    1804:	60910200 	addsvs	r0, r1, r0, lsl #4
    1808:	000af822 	andeq	pc, sl, r2, lsr #16
    180c:	18340100 	ldmdane	r4!, {r8}
    1810:	0000006c 	andeq	r0, r0, ip, rrx
    1814:	006c9102 	rsbeq	r9, ip, r2, lsl #2
    1818:	0005ce20 	andeq	ip, r5, r0, lsr #28
    181c:	062b0100 	strteq	r0, [fp], -r0, lsl #2
    1820:	00000812 	andeq	r0, r0, r2, lsl r8
    1824:	00008d74 	andeq	r8, r0, r4, ror sp
    1828:	00000068 	andeq	r0, r0, r8, rrx
    182c:	083d9c01 	ldmdaeq	sp!, {r0, sl, fp, ip, pc}
    1830:	43210000 			; <UNDEFINED> instruction: 0x43210000
    1834:	1d000006 	stcne	0, cr0, [r0, #-24]	; 0xffffffe8
    1838:	02000006 	andeq	r0, r0, #6
    183c:	d31f6491 	tstle	pc, #-1862270976	; 0x91000000
    1840:	0100000e 	tsteq	r0, lr
    1844:	0171382b 	cmneq	r1, fp, lsr #16
    1848:	91020000 	mrsls	r0, (UNDEF: 2)
    184c:	0af82260 	beq	ffe0a1d4 <_bss_end+0xffe00f8c>
    1850:	2d010000 	stccs	0, cr0, [r1, #-0]
    1854:	00006c18 	andeq	r6, r0, r8, lsl ip
    1858:	6c910200 	lfmvs	f0, 4, [r1], {0}
    185c:	05ae2000 	streq	r2, [lr, #0]!
    1860:	26010000 	strcs	r0, [r1], -r0
    1864:	00085706 	andeq	r5, r8, r6, lsl #14
    1868:	008d3000 	addeq	r3, sp, r0
    186c:	00004400 	andeq	r4, r0, r0, lsl #8
    1870:	739c0100 	orrsvc	r0, ip, #0, 2
    1874:	21000008 	tstcs	r0, r8
    1878:	00000643 	andeq	r0, r0, r3, asr #12
    187c:	0000061d 	andeq	r0, r0, sp, lsl r6
    1880:	1f6c9102 	svcne	0x006c9102
    1884:	00000ed3 	ldrdeq	r0, [r0], -r3
    1888:	2e452601 	cdpcs	6, 4, cr2, cr5, cr1, {0}
    188c:	02000001 	andeq	r0, r0, #1
    1890:	20006891 	mulcs	r0, r1, r8
    1894:	0000058e 	andeq	r0, r0, lr, lsl #11
    1898:	8d062101 	stfhis	f2, [r6, #-4]
    189c:	ec000008 	stc	0, cr0, [r0], {8}
    18a0:	4400008c 	strmi	r0, [r0], #-140	; 0xffffff74
    18a4:	01000000 	mrseq	r0, (UNDEF: 0)
    18a8:	0008a99c 	muleq	r8, ip, r9
    18ac:	06432100 	strbeq	r2, [r3], -r0, lsl #2
    18b0:	061d0000 	ldreq	r0, [sp], -r0
    18b4:	91020000 	mrsls	r0, (UNDEF: 2)
    18b8:	0ed31f6c 	cdpeq	15, 13, cr1, cr3, cr12, {3}
    18bc:	21010000 	mrscs	r0, (UNDEF: 1)
    18c0:	00012e44 	andeq	r2, r1, r4, asr #28
    18c4:	68910200 	ldmvs	r1, {r9}
    18c8:	05462300 	strbeq	r2, [r6, #-768]	; 0xfffffd00
    18cc:	1c010000 	stcne	0, cr0, [r1], {-0}
    18d0:	0008c318 	andeq	ip, r8, r8, lsl r3
    18d4:	008cb400 	addeq	fp, ip, r0, lsl #8
    18d8:	00003800 	andeq	r3, r0, r0, lsl #16
    18dc:	df9c0100 	svcle	0x009c0100
    18e0:	21000008 	tstcs	r0, r8
    18e4:	00000643 	andeq	r0, r0, r3, asr #12
    18e8:	0000061d 	andeq	r0, r0, sp, lsl r6
    18ec:	24749102 	ldrbtcs	r9, [r4], #-258	; 0xfffffefe
    18f0:	00676572 	rsbeq	r6, r7, r2, ror r5
    18f4:	df521c01 	svcle	0x00521c01
    18f8:	02000000 	andeq	r0, r0, #0
    18fc:	25007091 	strcs	r7, [r0, #-145]	; 0xffffff6f
    1900:	0000056a 	andeq	r0, r0, sl, ror #10
    1904:	f0011701 			; <UNDEFINED> instruction: 0xf0011701
    1908:	00000008 	andeq	r0, r0, r8
    190c:	00000906 	andeq	r0, r0, r6, lsl #18
    1910:	00064326 	andeq	r4, r6, r6, lsr #6
    1914:	00061d00 	andeq	r1, r6, r0, lsl #26
    1918:	0a302700 	beq	c0b520 <_bss_end+0xc022d8>
    191c:	17010000 	strne	r0, [r1, -r0]
    1920:	00022d3c 	andeq	r2, r2, ip, lsr sp
    1924:	df280000 	svcle	0x00280000
    1928:	5f000008 	svcpl	0x00000008
    192c:	2100000b 	tstcs	r0, fp
    1930:	80000009 	andhi	r0, r0, r9
    1934:	3400008c 	strcc	r0, [r0], #-140	; 0xffffff74
    1938:	01000000 	mrseq	r0, (UNDEF: 0)
    193c:	0009329c 	muleq	r9, ip, r2
    1940:	08f02900 	ldmeq	r0!, {r8, fp, sp}^
    1944:	91020000 	mrsls	r0, (UNDEF: 2)
    1948:	08f92974 	ldmeq	r9!, {r2, r4, r5, r6, r8, fp, sp}^
    194c:	91020000 	mrsls	r0, (UNDEF: 2)
    1950:	342a0070 	strtcc	r0, [sl], #-112	; 0xffffff90
    1954:	0100000c 	tsteq	r0, ip
    1958:	8c703311 	ldclhi	3, cr3, [r0], #-68	; 0xffffffbc
    195c:	00100000 	andseq	r0, r0, r0
    1960:	9c010000 	stcls	0, cr0, [r1], {-0}
    1964:	000e292b 	andeq	r2, lr, fp, lsr #18
    1968:	330b0100 	movwcc	r0, #45312	; 0xb100
    196c:	00008c38 	andeq	r8, r0, r8, lsr ip
    1970:	00000038 	andeq	r0, r0, r8, lsr r0
    1974:	442a9c01 	strtmi	r9, [sl], #-3073	; 0xfffff3ff
    1978:	0100000e 	tsteq	r0, lr
    197c:	8c203307 	stchi	3, cr3, [r0], #-28	; 0xffffffe4
    1980:	00180000 	andseq	r0, r8, r0
    1984:	9c010000 	stcls	0, cr0, [r1], {-0}
    1988:	00079b00 	andeq	r9, r7, r0, lsl #22
    198c:	73000400 	movwvc	r0, #1024	; 0x400
    1990:	04000008 	streq	r0, [r0], #-8
    1994:	00000001 	andeq	r0, r0, r1
    1998:	0f200400 	svceq	0x00200400
    199c:	011b0000 	tsteq	fp, r0
    19a0:	8eb40000 	cdphi	0, 11, cr0, cr4, cr0, {0}
    19a4:	011c0000 	tsteq	ip, r0
    19a8:	096e0000 	stmdbeq	lr!, {}^	; <UNPREDICTABLE>
    19ac:	01020000 	mrseq	r0, (UNDEF: 2)
    19b0:	00053d08 	andeq	r3, r5, r8, lsl #26
    19b4:	05020200 	streq	r0, [r2, #-512]	; 0xfffffe00
    19b8:	000002ab 	andeq	r0, r0, fp, lsr #5
    19bc:	69050403 	stmdbvs	r5, {r0, r1, sl}
    19c0:	0400746e 	streq	r7, [r0], #-1134	; 0xfffffb92
    19c4:	00000033 	andeq	r0, r0, r3, lsr r0
    19c8:	00038605 	andeq	r8, r3, r5, lsl #12
    19cc:	07090200 	streq	r0, [r9, -r0, lsl #4]
    19d0:	0000004b 	andeq	r0, r0, fp, asr #32
    19d4:	34080102 	strcc	r0, [r8], #-258	; 0xfffffefe
    19d8:	02000005 	andeq	r0, r0, #5
    19dc:	05800702 	streq	r0, [r0, #1794]	; 0x702
    19e0:	9c050000 	stcls	0, cr0, [r5], {-0}
    19e4:	02000003 	andeq	r0, r0, #3
    19e8:	006a070b 	rsbeq	r0, sl, fp, lsl #14
    19ec:	59060000 	stmdbpl	r6, {}	; <UNPREDICTABLE>
    19f0:	02000000 	andeq	r0, r0, #0
    19f4:	154f0704 	strbne	r0, [pc, #-1796]	; 12f8 <CPSR_IRQ_INHIBIT+0x1278>
    19f8:	6a060000 	bvs	181a00 <_bss_end+0x1787b8>
    19fc:	04000000 	streq	r0, [r0], #-0
    1a00:	0000006a 	andeq	r0, r0, sl, rrx
    1a04:	0006b207 	andeq	fp, r6, r7, lsl #4
    1a08:	3f010700 	svccc	0x00010700
    1a0c:	03000000 	movweq	r0, #0
    1a10:	00c40c06 	sbceq	r0, r4, r6, lsl #24
    1a14:	51080000 	mrspl	r0, (UNDEF: 8)
    1a18:	00000007 	andeq	r0, r0, r7
    1a1c:	00076208 	andeq	r6, r7, r8, lsl #4
    1a20:	25080100 	strcs	r0, [r8, #-256]	; 0xffffff00
    1a24:	02000008 	andeq	r0, r0, #8
    1a28:	00081f08 	andeq	r1, r8, r8, lsl #30
    1a2c:	fa080300 	blx	202634 <_bss_end+0x1f93ec>
    1a30:	04000007 	streq	r0, [r0], #-7
    1a34:	00080008 	andeq	r0, r8, r8
    1a38:	cd080500 	cfstr32gt	mvfx0, [r8, #-0]
    1a3c:	06000006 	streq	r0, [r0], -r6
    1a40:	00081908 	andeq	r1, r8, r8, lsl #18
    1a44:	aa080700 	bge	20364c <_bss_end+0x1fa404>
    1a48:	08000003 	stmdaeq	r0, {r0, r1}
    1a4c:	02f40700 	rscseq	r0, r4, #0, 14
    1a50:	04050000 	streq	r0, [r5], #-0
    1a54:	00000033 	andeq	r0, r0, r3, lsr r0
    1a58:	ef0c1803 	svc	0x000c1803
    1a5c:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    1a60:	000006c1 	andeq	r0, r0, r1, asr #13
    1a64:	07ed0800 	strbeq	r0, [sp, r0, lsl #16]!
    1a68:	08010000 	stmdaeq	r1, {}	; <UNPREDICTABLE>
    1a6c:	000002a6 	andeq	r0, r0, r6, lsr #5
    1a70:	6f4c0902 	svcvs	0x004c0902
    1a74:	00030077 	andeq	r0, r3, r7, ror r0
    1a78:	0004310a 	andeq	r3, r4, sl, lsl #2
    1a7c:	23030400 	movwcs	r0, #13312	; 0x3400
    1a80:	00031b07 	andeq	r1, r3, r7, lsl #22
    1a84:	03690b00 	cmneq	r9, #0, 22
    1a88:	27030000 	strcs	r0, [r3, -r0]
    1a8c:	00032619 	andeq	r2, r3, r9, lsl r6
    1a90:	dd0c0000 	stcle	0, cr0, [ip, #-0]
    1a94:	03000005 	movweq	r0, #5
    1a98:	03390a2b 	teqeq	r9, #176128	; 0x2b000
    1a9c:	032b0000 			; <UNDEFINED> instruction: 0x032b0000
    1aa0:	22020000 	andcs	r0, r2, #0
    1aa4:	37000001 	strcc	r0, [r0, -r1]
    1aa8:	0d000001 	stceq	0, cr0, [r0, #-4]
    1aac:	00000332 	andeq	r0, r0, r2, lsr r3
    1ab0:	0000590e 	andeq	r5, r0, lr, lsl #18
    1ab4:	03380e00 	teqeq	r8, #0, 28
    1ab8:	380e0000 	stmdacc	lr, {}	; <UNPREDICTABLE>
    1abc:	00000003 	andeq	r0, r0, r3
    1ac0:	00073e0c 	andeq	r3, r7, ip, lsl #28
    1ac4:	0a2d0300 	beq	b426cc <_bss_end+0xb39484>
    1ac8:	00000505 	andeq	r0, r0, r5, lsl #10
    1acc:	0000032b 	andeq	r0, r0, fp, lsr #6
    1ad0:	00015002 	andeq	r5, r1, r2
    1ad4:	00016500 	andeq	r6, r1, r0, lsl #10
    1ad8:	03320d00 	teqeq	r2, #0, 26
    1adc:	590e0000 	stmdbpl	lr, {}	; <UNPREDICTABLE>
    1ae0:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    1ae4:	00000338 	andeq	r0, r0, r8, lsr r3
    1ae8:	0003380e 	andeq	r3, r3, lr, lsl #16
    1aec:	3f0c0000 	svccc	0x000c0000
    1af0:	03000004 	movweq	r0, #4
    1af4:	07060a2f 	streq	r0, [r6, -pc, lsr #20]
    1af8:	032b0000 			; <UNDEFINED> instruction: 0x032b0000
    1afc:	7e020000 	cdpvc	0, 0, cr0, cr2, cr0, {0}
    1b00:	93000001 	movwls	r0, #1
    1b04:	0d000001 	stceq	0, cr0, [r0, #-4]
    1b08:	00000332 	andeq	r0, r0, r2, lsr r3
    1b0c:	0000590e 	andeq	r5, r0, lr, lsl #18
    1b10:	03380e00 	teqeq	r8, #0, 28
    1b14:	380e0000 	stmdacc	lr, {}	; <UNPREDICTABLE>
    1b18:	00000003 	andeq	r0, r0, r3
    1b1c:	0004930c 	andeq	r9, r4, ip, lsl #6
    1b20:	0a310300 	beq	c42728 <_bss_end+0xc394e0>
    1b24:	000001ea 	andeq	r0, r0, sl, ror #3
    1b28:	0000032b 	andeq	r0, r0, fp, lsr #6
    1b2c:	0001ac02 	andeq	sl, r1, r2, lsl #24
    1b30:	0001c100 	andeq	ip, r1, r0, lsl #2
    1b34:	03320d00 	teqeq	r2, #0, 26
    1b38:	590e0000 	stmdbpl	lr, {}	; <UNPREDICTABLE>
    1b3c:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    1b40:	00000338 	andeq	r0, r0, r8, lsr r3
    1b44:	0003380e 	andeq	r3, r3, lr, lsl #16
    1b48:	930c0000 	movwls	r0, #49152	; 0xc000
    1b4c:	03000002 	movweq	r0, #2
    1b50:	05ae0a32 	streq	r0, [lr, #2610]!	; 0xa32
    1b54:	032b0000 			; <UNDEFINED> instruction: 0x032b0000
    1b58:	da020000 	ble	81b60 <_bss_end+0x78918>
    1b5c:	ef000001 	svc	0x00000001
    1b60:	0d000001 	stceq	0, cr0, [r0, #-4]
    1b64:	00000332 	andeq	r0, r0, r2, lsr r3
    1b68:	0000590e 	andeq	r5, r0, lr, lsl #18
    1b6c:	03380e00 	teqeq	r8, #0, 28
    1b70:	380e0000 	stmdacc	lr, {}	; <UNPREDICTABLE>
    1b74:	00000003 	andeq	r0, r0, r3
    1b78:	0004310c 	andeq	r3, r4, ip, lsl #2
    1b7c:	05350300 	ldreq	r0, [r5, #-768]!	; 0xfffffd00
    1b80:	0000036f 	andeq	r0, r0, pc, ror #6
    1b84:	0000033e 	andeq	r0, r0, lr, lsr r3
    1b88:	00020801 	andeq	r0, r2, r1, lsl #16
    1b8c:	00021300 	andeq	r1, r2, r0, lsl #6
    1b90:	033e0d00 	teqeq	lr, #0, 26
    1b94:	6a0e0000 	bvs	381b9c <_bss_end+0x378954>
    1b98:	00000000 	andeq	r0, r0, r0
    1b9c:	0006e10f 	andeq	lr, r6, pc, lsl #2
    1ba0:	0a380300 	beq	e027a8 <_bss_end+0xdf9560>
    1ba4:	00000689 	andeq	r0, r0, r9, lsl #13
    1ba8:	00022801 	andeq	r2, r2, r1, lsl #16
    1bac:	00023800 	andeq	r3, r2, r0, lsl #16
    1bb0:	033e0d00 	teqeq	lr, #0, 26
    1bb4:	590e0000 	stmdbpl	lr, {}	; <UNPREDICTABLE>
    1bb8:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    1bbc:	0000007b 	andeq	r0, r0, fp, ror r0
    1bc0:	041f0c00 	ldreq	r0, [pc], #-3072	; 1bc8 <CPSR_IRQ_INHIBIT+0x1b48>
    1bc4:	3a030000 	bcc	c1bcc <_bss_end+0xb8984>
    1bc8:	0004a614 	andeq	sl, r4, r4, lsl r6
    1bcc:	00007b00 	andeq	r7, r0, r0, lsl #22
    1bd0:	02510100 	subseq	r0, r1, #0, 2
    1bd4:	025c0000 	subseq	r0, ip, #0
    1bd8:	320d0000 	andcc	r0, sp, #0
    1bdc:	0e000003 	cdpeq	0, 0, cr0, cr0, cr3, {0}
    1be0:	00000059 	andeq	r0, r0, r9, asr r0
    1be4:	075e0f00 	ldrbeq	r0, [lr, -r0, lsl #30]
    1be8:	3d030000 	stccc	0, cr0, [r3, #-0]
    1bec:	0003170a 	andeq	r1, r3, sl, lsl #14
    1bf0:	02710100 	rsbseq	r0, r1, #0, 2
    1bf4:	02810000 	addeq	r0, r1, #0
    1bf8:	3e0d0000 	cdpcc	0, 0, cr0, cr13, cr0, {0}
    1bfc:	0e000003 	cdpeq	0, 0, cr0, cr0, cr3, {0}
    1c00:	00000059 	andeq	r0, r0, r9, asr r0
    1c04:	00032b0e 	andeq	r2, r3, lr, lsl #22
    1c08:	b60f0000 	strlt	r0, [pc], -r0
    1c0c:	03000003 	movweq	r0, #3
    1c10:	04580a3f 	ldrbeq	r0, [r8], #-2623	; 0xfffff5c1
    1c14:	96010000 	strls	r0, [r1], -r0
    1c18:	a1000002 	tstge	r0, r2
    1c1c:	0d000002 	stceq	0, cr0, [r0, #-8]
    1c20:	0000033e 	andeq	r0, r0, lr, lsr r3
    1c24:	0000590e 	andeq	r5, r0, lr, lsl #18
    1c28:	9a0f0000 	bls	3c1c30 <_bss_end+0x3b89e8>
    1c2c:	03000005 	movweq	r0, #5
    1c30:	02c90a41 	sbceq	r0, r9, #266240	; 0x41000
    1c34:	b6010000 	strlt	r0, [r1], -r0
    1c38:	c6000002 	strgt	r0, [r0], -r2
    1c3c:	0d000002 	stceq	0, cr0, [r0, #-8]
    1c40:	0000033e 	andeq	r0, r0, lr, lsr r3
    1c44:	0000590e 	andeq	r5, r0, lr, lsl #18
    1c48:	00c40e00 	sbceq	r0, r4, r0, lsl #28
    1c4c:	0f000000 	svceq	0x00000000
    1c50:	000007d8 	ldrdeq	r0, [r0], -r8
    1c54:	480a4203 	stmdami	sl, {r0, r1, r9, lr}
    1c58:	01000006 	tsteq	r0, r6
    1c5c:	000002db 	ldrdeq	r0, [r0], -fp
    1c60:	000002eb 	andeq	r0, r0, fp, ror #5
    1c64:	00033e0d 	andeq	r3, r3, sp, lsl #28
    1c68:	00590e00 	subseq	r0, r9, r0, lsl #28
    1c6c:	c40e0000 	strgt	r0, [lr], #-0
    1c70:	00000000 	andeq	r0, r0, r0
    1c74:	00027810 	andeq	r7, r2, r0, lsl r8
    1c78:	0a430300 	beq	10c2880 <_bss_end+0x10b9638>
    1c7c:	000003d2 	ldrdeq	r0, [r0], -r2
    1c80:	0000032b 	andeq	r0, r0, fp, lsr #6
    1c84:	00030001 	andeq	r0, r3, r1
    1c88:	03320d00 	teqeq	r2, #0, 26
    1c8c:	590e0000 	stmdbpl	lr, {}	; <UNPREDICTABLE>
    1c90:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    1c94:	000000c4 	andeq	r0, r0, r4, asr #1
    1c98:	0003380e 	andeq	r3, r3, lr, lsl #16
    1c9c:	03380e00 	teqeq	r8, #0, 28
    1ca0:	00000000 	andeq	r0, r0, r0
    1ca4:	0000ef06 	andeq	lr, r0, r6, lsl #30
    1ca8:	6a041100 	bvs	1060b0 <_bss_end+0xfce68>
    1cac:	06000000 	streq	r0, [r0], -r0
    1cb0:	00000320 	andeq	r0, r0, r0, lsr #6
    1cb4:	a5020102 	strge	r0, [r2, #-258]	; 0xfffffefe
    1cb8:	11000003 	tstne	r0, r3
    1cbc:	00031b04 	andeq	r1, r3, r4, lsl #22
    1cc0:	59041200 	stmdbpl	r4, {r9, ip}
    1cc4:	11000000 	mrsne	r0, (UNDEF: 0)
    1cc8:	0000ef04 	andeq	lr, r0, r4, lsl #30
    1ccc:	07d21300 	ldrbeq	r1, [r2, r0, lsl #6]
    1cd0:	47030000 	strmi	r0, [r3, -r0]
    1cd4:	0000ef16 	andeq	lr, r0, r6, lsl pc
    1cd8:	61681400 	cmnvs	r8, r0, lsl #8
    1cdc:	0704006c 	streq	r0, [r4, -ip, rrx]
    1ce0:	0005020b 	andeq	r0, r5, fp, lsl #4
    1ce4:	08061500 	stmdaeq	r6, {r8, sl, ip}
    1ce8:	09040000 	stmdbeq	r4, {}	; <UNPREDICTABLE>
    1cec:	0000711c 	andeq	r7, r0, ip, lsl r1
    1cf0:	e6b28000 	ldrt	r8, [r2], r0
    1cf4:	0483150e 	streq	r1, [r3], #1294	; 0x50e
    1cf8:	0c040000 	stceq	0, cr0, [r4], {-0}
    1cfc:	00050e1d 	andeq	r0, r5, sp, lsl lr
    1d00:	00000000 	andeq	r0, r0, r0
    1d04:	05421520 	strbeq	r1, [r2, #-1312]	; 0xfffffae0
    1d08:	0f040000 	svceq	0x00040000
    1d0c:	00050e1d 	andeq	r0, r5, sp, lsl lr
    1d10:	20000000 	andcs	r0, r0, r0
    1d14:	05f11620 	ldrbeq	r1, [r1, #1568]!	; 0x620
    1d18:	12040000 	andne	r0, r4, #0
    1d1c:	00006518 	andeq	r6, r0, r8, lsl r5
    1d20:	35153600 	ldrcc	r3, [r5, #-1536]	; 0xfffffa00
    1d24:	04000007 	streq	r0, [r0], #-7
    1d28:	050e1d44 	streq	r1, [lr, #-3396]	; 0xfffff2bc
    1d2c:	50000000 	andpl	r0, r0, r0
    1d30:	5e152021 	cdppl	0, 1, cr2, cr5, cr1, {1}
    1d34:	04000002 	streq	r0, [r0], #-2
    1d38:	050e1d73 	streq	r1, [lr, #-3443]	; 0xfffff28d
    1d3c:	b2000000 	andlt	r0, r0, #0
    1d40:	9d072000 	stcls	0, cr2, [r7, #-0]
    1d44:	0500000b 	streq	r0, [r0, #-11]
    1d48:	00003304 	andeq	r3, r0, r4, lsl #6
    1d4c:	10750400 	rsbsne	r0, r5, r0, lsl #8
    1d50:	00000408 	andeq	r0, r0, r8, lsl #8
    1d54:	000c4b08 	andeq	r4, ip, r8, lsl #22
    1d58:	70080000 	andvc	r0, r8, r0
    1d5c:	0100000e 	tsteq	r0, lr
    1d60:	000e9708 	andeq	r9, lr, r8, lsl #14
    1d64:	1d080200 	sfmne	f0, 4, [r8, #-0]
    1d68:	0300000e 	movweq	r0, #14
    1d6c:	000b7e08 	andeq	r7, fp, r8, lsl #28
    1d70:	8b080400 	blhi	202d78 <_bss_end+0x1f9b30>
    1d74:	0500000b 	streq	r0, [r0, #-11]
    1d78:	000e5f08 	andeq	r5, lr, r8, lsl #30
    1d7c:	de080600 	cfmadd32le	mvax0, mvfx0, mvfx8, mvfx0
    1d80:	0700000e 	streq	r0, [r0, -lr]
    1d84:	000eec08 	andeq	lr, lr, r8, lsl #24
    1d88:	7f080800 	svcvc	0x00080800
    1d8c:	0900000c 	stmdbeq	r0, {r2, r3}
    1d90:	0bd80700 	bleq	ff603998 <_bss_end+0xff5fa750>
    1d94:	04050000 	streq	r0, [r5], #-0
    1d98:	00000033 	andeq	r0, r0, r3, lsr r0
    1d9c:	4b108304 	blmi	4229b4 <_bss_end+0x41976c>
    1da0:	08000004 	stmdaeq	r0, {r2}
    1da4:	00000a5a 	andeq	r0, r0, sl, asr sl
    1da8:	0b4c0800 	bleq	1303db0 <_bss_end+0x12fab68>
    1dac:	08010000 	stmdaeq	r1, {}	; <UNPREDICTABLE>
    1db0:	00000ce9 	andeq	r0, r0, r9, ror #25
    1db4:	0cf40802 	ldcleq	8, cr0, [r4], #8
    1db8:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    1dbc:	00000cff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    1dc0:	0b420804 	bleq	1083dd8 <_bss_end+0x107ab90>
    1dc4:	08050000 	stmdaeq	r5, {}	; <UNPREDICTABLE>
    1dc8:	00000bb6 			; <UNDEFINED> instruction: 0x00000bb6
    1dcc:	0bc70806 	bleq	ff1c3dec <_bss_end+0xff1baba4>
    1dd0:	00070000 	andeq	r0, r7, r0
    1dd4:	000e7e07 	andeq	r7, lr, r7, lsl #28
    1dd8:	33040500 	movwcc	r0, #17664	; 0x4500
    1ddc:	04000000 	streq	r0, [r0], #-0
    1de0:	04ac108f 	strteq	r1, [ip], #143	; 0x8f
    1de4:	41090000 	mrsmi	r0, (UNDEF: 9)
    1de8:	1d005855 	stcne	8, cr5, [r0, #-340]	; 0xfffffeac
    1dec:	000e0a08 	andeq	r0, lr, r8, lsl #20
    1df0:	fa082b00 	blx	20c9f8 <_bss_end+0x2037b0>
    1df4:	2d00000e 	stccs	0, cr0, [r0, #-56]	; 0xffffffc8
    1df8:	000f0008 	andeq	r0, pc, r8
    1dfc:	53092e00 	movwpl	r2, #40448	; 0x9e00
    1e00:	3000494d 	andcc	r4, r0, sp, asr #18
    1e04:	000ea508 	andeq	sl, lr, r8, lsl #10
    1e08:	ac083100 	stfges	f3, [r8], {-0}
    1e0c:	3200000e 	andcc	r0, r0, #14
    1e10:	000eb308 	andeq	fp, lr, r8, lsl #6
    1e14:	ba083300 	blt	20ea1c <_bss_end+0x2057d4>
    1e18:	3400000e 	strcc	r0, [r0], #-14
    1e1c:	43324909 	teqmi	r2, #147456	; 0x24000
    1e20:	53093500 	movwpl	r3, #38144	; 0x9500
    1e24:	36004950 			; <UNDEFINED> instruction: 0x36004950
    1e28:	4d435009 	stclmi	0, cr5, [r3, #-36]	; 0xffffffdc
    1e2c:	98083700 	stmdals	r8, {r8, r9, sl, ip, sp}
    1e30:	3900000b 	stmdbcc	r0, {r0, r1, r3}
    1e34:	06051500 	streq	r1, [r5], -r0, lsl #10
    1e38:	a6040000 	strge	r0, [r4], -r0
    1e3c:	00050e1d 	andeq	r0, r5, sp, lsl lr
    1e40:	00b40000 	adcseq	r0, r4, r0
    1e44:	0a071720 	beq	1c7acc <_bss_end+0x1be884>
    1e48:	04050000 	streq	r0, [r5], #-0
    1e4c:	00000033 	andeq	r0, r0, r3, lsr r0
    1e50:	0810a804 	ldmdaeq	r0, {r2, fp, sp, pc}
    1e54:	00000a54 	andeq	r0, r0, r4, asr sl
    1e58:	097f0800 	ldmdbeq	pc!, {fp}^	; <UNPREDICTABLE>
    1e5c:	08010000 	stmdaeq	r1, {}	; <UNPREDICTABLE>
    1e60:	00000e21 	andeq	r0, r0, r1, lsr #28
    1e64:	095c0802 	ldmdbeq	ip, {r1, fp}^
    1e68:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    1e6c:	00000acc 	andeq	r0, r0, ip, asr #21
    1e70:	08a20804 	stmiaeq	r2!, {r2, fp}
    1e74:	08050000 	stmdaeq	r5, {}	; <UNPREDICTABLE>
    1e78:	0000088e 	andeq	r0, r0, lr, lsl #17
    1e7c:	09fb0806 	ldmibeq	fp!, {r1, r2, fp}^
    1e80:	08070000 	stmdaeq	r7, {}	; <UNPREDICTABLE>
    1e84:	00000a9a 	muleq	r0, sl, sl
    1e88:	18000008 	stmdane	r0, {r3}
    1e8c:	0000035c 	andeq	r0, r0, ip, asr r3
    1e90:	4a070402 	bmi	1c2ea0 <_bss_end+0x1b9c58>
    1e94:	06000015 			; <UNDEFINED> instruction: 0x06000015
    1e98:	00000507 	andeq	r0, r0, r7, lsl #10
    1e9c:	00036c18 	andeq	r6, r3, r8, lsl ip
    1ea0:	037c1800 	cmneq	ip, #0, 16
    1ea4:	8c180000 	ldchi	0, cr0, [r8], {-0}
    1ea8:	18000003 	stmdane	r0, {r0, r1}
    1eac:	00000399 	muleq	r0, r9, r3
    1eb0:	0003a918 	andeq	sl, r3, r8, lsl r9
    1eb4:	04ac1800 	strteq	r1, [ip], #2048	; 0x800
    1eb8:	690a0000 	stmdbvs	sl, {}	; <UNPREDICTABLE>
    1ebc:	0400000c 	streq	r0, [r0], #-12
    1ec0:	10070905 	andne	r0, r7, r5, lsl #18
    1ec4:	0b000006 	bleq	1ee4 <CPSR_IRQ_INHIBIT+0x1e64>
    1ec8:	00000be9 	andeq	r0, r0, r9, ror #23
    1ecc:	101c0d05 	andsne	r0, ip, r5, lsl #26
    1ed0:	00000006 	andeq	r0, r0, r6
    1ed4:	00097a0c 	andeq	r7, r9, ip, lsl #20
    1ed8:	1c100500 	cfldr32ne	mvfx0, [r0], {-0}
    1edc:	00000b01 	andeq	r0, r0, r1, lsl #22
    1ee0:	00000616 	andeq	r0, r0, r6, lsl r6
    1ee4:	00056402 	andeq	r6, r5, r2, lsl #8
    1ee8:	00056f00 	andeq	r6, r5, r0, lsl #30
    1eec:	061c0d00 	ldreq	r0, [ip], -r0, lsl #26
    1ef0:	b90e0000 	stmdblt	lr, {}	; <UNPREDICTABLE>
    1ef4:	00000003 	andeq	r0, r0, r3
    1ef8:	000c690c 	andeq	r6, ip, ip, lsl #18
    1efc:	05130500 	ldreq	r0, [r3, #-1280]	; 0xfffffb00
    1f00:	00000deb 	andeq	r0, r0, fp, ror #27
    1f04:	0000061c 	andeq	r0, r0, ip, lsl r6
    1f08:	00058801 	andeq	r8, r5, r1, lsl #16
    1f0c:	00059300 	andeq	r9, r5, r0, lsl #6
    1f10:	061c0d00 	ldreq	r0, [ip], -r0, lsl #26
    1f14:	070e0000 	streq	r0, [lr, -r0]
    1f18:	00000005 	andeq	r0, r0, r5
    1f1c:	000c910f 	andeq	r9, ip, pc, lsl #2
    1f20:	0a160500 	beq	583328 <_bss_end+0x57a0e0>
    1f24:	00000d43 	andeq	r0, r0, r3, asr #26
    1f28:	0005a801 	andeq	sl, r5, r1, lsl #16
    1f2c:	0005b300 	andeq	fp, r5, r0, lsl #6
    1f30:	061c0d00 	ldreq	r0, [ip], -r0, lsl #26
    1f34:	080e0000 	stmdaeq	lr, {}	; <UNPREDICTABLE>
    1f38:	00000004 	andeq	r0, r0, r4
    1f3c:	000ec10f 	andeq	ip, lr, pc, lsl #2
    1f40:	0a180500 	beq	603348 <_bss_end+0x5fa100>
    1f44:	00000ca2 	andeq	r0, r0, r2, lsr #25
    1f48:	0005c801 	andeq	ip, r5, r1, lsl #16
    1f4c:	0005d300 	andeq	sp, r5, r0, lsl #6
    1f50:	061c0d00 	ldreq	r0, [ip], -r0, lsl #26
    1f54:	080e0000 	stmdaeq	lr, {}	; <UNPREDICTABLE>
    1f58:	00000004 	andeq	r0, r0, r4
    1f5c:	000b540f 	andeq	r5, fp, pc, lsl #8
    1f60:	0a1b0500 	beq	6c3368 <_bss_end+0x6ba120>
    1f64:	00000d09 	andeq	r0, r0, r9, lsl #26
    1f68:	0005e801 	andeq	lr, r5, r1, lsl #16
    1f6c:	0005f300 	andeq	pc, r5, r0, lsl #6
    1f70:	061c0d00 	ldreq	r0, [ip], -r0, lsl #26
    1f74:	4b0e0000 	blmi	381f7c <_bss_end+0x378d34>
    1f78:	00000004 	andeq	r0, r0, r4
    1f7c:	000c5d19 	andeq	r5, ip, r9, lsl sp
    1f80:	0a1d0500 	beq	743388 <_bss_end+0x73a140>
    1f84:	00000bf9 	strdeq	r0, [r0], -r9
    1f88:	00060401 	andeq	r0, r6, r1, lsl #8
    1f8c:	061c0d00 	ldreq	r0, [ip], -r0, lsl #26
    1f90:	4b0e0000 	blmi	381f98 <_bss_end+0x378d50>
    1f94:	00000004 	andeq	r0, r0, r4
    1f98:	76041100 	strvc	r1, [r4], -r0, lsl #2
    1f9c:	12000000 	andne	r0, r0, #0
    1fa0:	00007604 	andeq	r7, r0, r4, lsl #12
    1fa4:	31041100 	mrscc	r1, (UNDEF: 20)
    1fa8:	13000005 	movwne	r0, #5
    1fac:	00000e89 	andeq	r0, r0, r9, lsl #29
    1fb0:	311e2005 	tstcc	lr, r5
    1fb4:	07000005 	streq	r0, [r0, -r5]
    1fb8:	00000914 	andeq	r0, r0, r4, lsl r9
    1fbc:	003f0107 	eorseq	r0, pc, r7, lsl #2
    1fc0:	06060000 	streq	r0, [r6], -r0
    1fc4:	0006530c 	andeq	r5, r6, ip, lsl #6
    1fc8:	093c0800 	ldmdbeq	ip!, {fp}
    1fcc:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    1fd0:	00000966 	andeq	r0, r0, r6, ror #18
    1fd4:	08ec0801 	stmiaeq	ip!, {r0, fp}^
    1fd8:	00020000 	andeq	r0, r2, r0
    1fdc:	000a590a 	andeq	r5, sl, sl, lsl #18
    1fe0:	0d060800 	stceq	8, cr0, [r6, #-0]
    1fe4:	00074b07 	andeq	r4, r7, r7, lsl #22
    1fe8:	09730b00 	ldmdbeq	r3!, {r8, r9, fp}^
    1fec:	15060000 	strne	r0, [r6, #-0]
    1ff0:	0006101c 	andeq	r1, r6, ip, lsl r0
    1ff4:	bc1a0000 	ldclt	0, cr0, [sl], {-0}
    1ff8:	0600000a 	streq	r0, [r0], -sl
    1ffc:	074b0b11 	smlaldeq	r0, fp, r1, fp
    2000:	0b010000 	bleq	42008 <_bss_end+0x38dc0>
    2004:	00000a60 	andeq	r0, r0, r0, ror #20
    2008:	6d151806 	ldcvs	8, cr1, [r5, #-24]	; 0xffffffe8
    200c:	04000006 	streq	r0, [r0], #-6
    2010:	00097a0c 	andeq	r7, r9, ip, lsl #20
    2014:	1c1b0600 	ldcne	6, cr0, [fp], {-0}
    2018:	00000a6a 	andeq	r0, r0, sl, ror #20
    201c:	00000616 	andeq	r0, r0, r6, lsl r6
    2020:	0006a002 	andeq	sl, r6, r2
    2024:	0006ab00 	andeq	sl, r6, r0, lsl #22
    2028:	07520d00 	ldrbeq	r0, [r2, -r0, lsl #26]
    202c:	bc0e0000 	stclt	0, cr0, [lr], {-0}
    2030:	00000004 	andeq	r0, r0, r4
    2034:	000a590c 	andeq	r5, sl, ip, lsl #18
    2038:	051e0600 	ldreq	r0, [lr, #-1536]	; 0xfffffa00
    203c:	00000a8b 	andeq	r0, r0, fp, lsl #21
    2040:	00000752 	andeq	r0, r0, r2, asr r7
    2044:	0006c401 	andeq	ip, r6, r1, lsl #8
    2048:	0006cf00 	andeq	ip, r6, r0, lsl #30
    204c:	07520d00 	ldrbeq	r0, [r2, -r0, lsl #26]
    2050:	070e0000 	streq	r0, [lr, -r0]
    2054:	00000005 	andeq	r0, r0, r5
    2058:	000e690f 	andeq	r6, lr, pc, lsl #18
    205c:	0a210600 	beq	843864 <_bss_end+0x83a61c>
    2060:	000008fa 	strdeq	r0, [r0], -sl
    2064:	0006e401 	andeq	lr, r6, r1, lsl #8
    2068:	0006f900 	andeq	pc, r6, r0, lsl #18
    206c:	07520d00 	ldrbeq	r0, [r2, -r0, lsl #26]
    2070:	6d0e0000 	stcvs	0, cr0, [lr, #-0]
    2074:	0e000006 	cdpeq	0, 0, cr0, cr0, cr6, {0}
    2078:	0000006a 	andeq	r0, r0, sl, rrx
    207c:	00062e0e 	andeq	r2, r6, lr, lsl #28
    2080:	890f0000 	stmdbhi	pc, {}	; <UNPREDICTABLE>
    2084:	0600000c 	streq	r0, [r0], -ip
    2088:	0a110a23 	beq	44491c <_bss_end+0x43b6d4>
    208c:	0e010000 	cdpeq	0, 0, cr0, cr1, cr0, {0}
    2090:	14000007 	strne	r0, [r0], #-7
    2094:	0d000007 	stceq	0, cr0, [r0, #-28]	; 0xffffffe4
    2098:	00000752 	andeq	r0, r0, r2, asr r7
    209c:	08950f00 	ldmeq	r5, {r8, r9, sl, fp}
    20a0:	26060000 	strcs	r0, [r6], -r0
    20a4:	000ad40a 	andeq	sp, sl, sl, lsl #8
    20a8:	07290100 	streq	r0, [r9, -r0, lsl #2]!
    20ac:	072f0000 	streq	r0, [pc, -r0]!
    20b0:	520d0000 	andpl	r0, sp, #0
    20b4:	00000007 	andeq	r0, r0, r7
    20b8:	000aa710 	andeq	sl, sl, r0, lsl r7
    20bc:	0a280600 	beq	a038c4 <_bss_end+0x9fa67c>
    20c0:	00000848 	andeq	r0, r0, r8, asr #16
    20c4:	0000032b 	andeq	r0, r0, fp, lsr #6
    20c8:	00074401 	andeq	r4, r7, r1, lsl #8
    20cc:	07520d00 	ldrbeq	r0, [r2, -r0, lsl #26]
    20d0:	00000000 	andeq	r0, r0, r0
    20d4:	07510411 	smmlaeq	r1, r1, r4, r0
    20d8:	111b0000 	tstne	fp, r0
    20dc:	00065304 	andeq	r5, r6, r4, lsl #6
    20e0:	08411300 	stmdaeq	r1, {r8, r9, ip}^
    20e4:	2b060000 	blcs	1820ec <_bss_end+0x178ea4>
    20e8:	0006530f 	andeq	r5, r6, pc, lsl #6
    20ec:	0f061c00 	svceq	0x00061c00
    20f0:	05010000 	streq	r0, [r1, #-0]
    20f4:	00003a0e 	andeq	r3, r0, lr, lsl #20
    20f8:	34030500 	strcc	r0, [r3], #-1280	; 0xfffffb00
    20fc:	1d000092 	stcne	0, cr0, [r0, #-584]	; 0xfffffdb8
    2100:	00000f72 	andeq	r0, r0, r2, ror pc
    2104:	33101701 	tstcc	r0, #262144	; 0x40000
    2108:	28000000 	stmdacs	r0, {}	; <UNPREDICTABLE>
    210c:	a800008f 	stmdage	r0, {r0, r1, r2, r3, r7}
    2110:	01000000 	mrseq	r0, (UNDEF: 0)
    2114:	0f101e9c 	svceq	0x00101e9c
    2118:	07010000 	streq	r0, [r1, -r0]
    211c:	008eb411 	addeq	fp, lr, r1, lsl r4
    2120:	00007400 	andeq	r7, r0, r0, lsl #8
    2124:	009c0100 	addseq	r0, ip, r0, lsl #2
    2128:	0000001e 	andeq	r0, r0, lr, lsl r0
    212c:	0a4e0002 	beq	138213c <_bss_end+0x1378ef4>
    2130:	01040000 	mrseq	r0, (UNDEF: 4)
    2134:	00000b71 	andeq	r0, r0, r1, ror fp
    2138:	00000000 	andeq	r0, r0, r0
    213c:	00000f7f 	andeq	r0, r0, pc, ror pc
    2140:	0000011b 	andeq	r0, r0, fp, lsl r1
    2144:	00000fd0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    2148:	014b8001 	cmpeq	fp, r1
    214c:	00040000 	andeq	r0, r4, r0
    2150:	00000a60 	andeq	r0, r0, r0, ror #20
    2154:	00000104 	andeq	r0, r0, r4, lsl #2
    2158:	64040000 	strvs	r0, [r4], #-0
    215c:	1b000010 	blne	21a4 <CPSR_IRQ_INHIBIT+0x2124>
    2160:	f0000001 			; <UNDEFINED> instruction: 0xf0000001
    2164:	1800008f 	stmdane	r0, {r0, r1, r2, r3, r7}
    2168:	27000001 	strcs	r0, [r0, -r1]
    216c:	0200000c 	andeq	r0, r0, #12
    2170:	00001035 	andeq	r1, r0, r5, lsr r0
    2174:	31070201 	tstcc	r7, r1, lsl #4
    2178:	03000000 	movweq	r0, #0
    217c:	00003704 	andeq	r3, r0, r4, lsl #14
    2180:	2c020400 	cfstrscs	mvf0, [r2], {-0}
    2184:	01000010 	tsteq	r0, r0, lsl r0
    2188:	00310703 	eorseq	r0, r1, r3, lsl #14
    218c:	dc050000 	stcle	0, cr0, [r5], {-0}
    2190:	0100000f 	tsteq	r0, pc
    2194:	00501006 	subseq	r1, r0, r6
    2198:	04060000 	streq	r0, [r6], #-0
    219c:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
    21a0:	10150500 	andsne	r0, r5, r0, lsl #10
    21a4:	08010000 	stmdaeq	r1, {}	; <UNPREDICTABLE>
    21a8:	00005010 	andeq	r5, r0, r0, lsl r0
    21ac:	00250700 	eoreq	r0, r5, r0, lsl #14
    21b0:	00760000 	rsbseq	r0, r6, r0
    21b4:	76080000 	strvc	r0, [r8], -r0
    21b8:	ff000000 			; <UNDEFINED> instruction: 0xff000000
    21bc:	00ffffff 	ldrshteq	pc, [pc], #255	; <UNPREDICTABLE>
    21c0:	4f070409 	svcmi	0x00070409
    21c4:	05000015 	streq	r0, [r0, #-21]	; 0xffffffeb
    21c8:	0000103e 	andeq	r1, r0, lr, lsr r0
    21cc:	63150b01 	tstvs	r5, #1024	; 0x400
    21d0:	05000000 	streq	r0, [r0, #-0]
    21d4:	00000fed 	andeq	r0, r0, sp, ror #31
    21d8:	63150d01 	tstvs	r5, #1, 26	; 0x40
    21dc:	07000000 	streq	r0, [r0, -r0]
    21e0:	00000038 	andeq	r0, r0, r8, lsr r0
    21e4:	000000a8 	andeq	r0, r0, r8, lsr #1
    21e8:	00007608 	andeq	r7, r0, r8, lsl #12
    21ec:	ffffff00 			; <UNDEFINED> instruction: 0xffffff00
    21f0:	1e0500ff 	mcrne	0, 0, r0, cr5, cr15, {7}
    21f4:	01000010 	tsteq	r0, r0, lsl r0
    21f8:	00951510 	addseq	r1, r5, r0, lsl r5
    21fc:	fa050000 	blx	142204 <_bss_end+0x138fbc>
    2200:	0100000f 	tsteq	r0, pc
    2204:	00951512 	addseq	r1, r5, r2, lsl r5
    2208:	070a0000 	streq	r0, [sl, -r0]
    220c:	01000010 	tsteq	r0, r0, lsl r0
    2210:	0050102b 	subseq	r1, r0, fp, lsr #32
    2214:	90b00000 	adcsls	r0, r0, r0
    2218:	00580000 	subseq	r0, r8, r0
    221c:	9c010000 	stcls	0, cr0, [r1], {-0}
    2220:	000000ea 	andeq	r0, r0, sl, ror #1
    2224:	000fe70b 	andeq	lr, pc, fp, lsl #14
    2228:	0f2d0100 	svceq	0x002d0100
    222c:	000000ea 	andeq	r0, r0, sl, ror #1
    2230:	00749102 	rsbseq	r9, r4, r2, lsl #2
    2234:	00380403 	eorseq	r0, r8, r3, lsl #8
    2238:	570a0000 	strpl	r0, [sl, -r0]
    223c:	01000010 	tsteq	r0, r0, lsl r0
    2240:	0050101f 	subseq	r1, r0, pc, lsl r0
    2244:	90580000 	subsls	r0, r8, r0
    2248:	00580000 	subseq	r0, r8, r0
    224c:	9c010000 	stcls	0, cr0, [r1], {-0}
    2250:	0000011a 	andeq	r0, r0, sl, lsl r1
    2254:	000fe70b 	andeq	lr, pc, fp, lsl #14
    2258:	0f210100 	svceq	0x00210100
    225c:	0000011a 	andeq	r0, r0, sl, lsl r1
    2260:	00749102 	rsbseq	r9, r4, r2, lsl #2
    2264:	00250403 	eoreq	r0, r5, r3, lsl #8
    2268:	4c0c0000 	stcmi	0, cr0, [ip], {-0}
    226c:	01000010 	tsteq	r0, r0, lsl r0
    2270:	00501014 	subseq	r1, r0, r4, lsl r0
    2274:	8ff00000 	svchi	0x00f00000	; IMB
    2278:	00680000 	rsbeq	r0, r8, r0
    227c:	9c010000 	stcls	0, cr0, [r1], {-0}
    2280:	00000148 	andeq	r0, r0, r8, asr #2
    2284:	0100690d 	tsteq	r0, sp, lsl #18
    2288:	01480a16 	cmpeq	r8, r6, lsl sl
    228c:	91020000 	mrsls	r0, (UNDEF: 2)
    2290:	04030074 	streq	r0, [r3], #-116	; 0xffffff8c
    2294:	00000050 	andeq	r0, r0, r0, asr r0
    2298:	00093200 	andeq	r3, r9, r0, lsl #4
    229c:	26000400 	strcs	r0, [r0], -r0, lsl #8
    22a0:	0400000b 	streq	r0, [r0], #-11
    22a4:	00142201 	andseq	r2, r4, r1, lsl #4
    22a8:	13790c00 	cmnne	r9, #0, 24
    22ac:	1b460000 	blne	11822b4 <_bss_end+0x117906c>
    22b0:	0d170000 	ldceq	0, cr0, [r7, #-0]
    22b4:	04020000 	streq	r0, [r2], #-0
    22b8:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
    22bc:	07040300 	streq	r0, [r4, -r0, lsl #6]
    22c0:	0000154f 	andeq	r1, r0, pc, asr #10
    22c4:	dc050803 	stcle	8, cr0, [r5], {3}
    22c8:	03000001 	movweq	r0, #1
    22cc:	1c860408 	cfstrsne	mvf0, [r6], {8}
    22d0:	d4040000 	strle	r0, [r4], #-0
    22d4:	01000013 	tsteq	r0, r3, lsl r0
    22d8:	0024162a 	eoreq	r1, r4, sl, lsr #12
    22dc:	43040000 	movwmi	r0, #16384	; 0x4000
    22e0:	01000018 	tsteq	r0, r8, lsl r0
    22e4:	0051152f 	subseq	r1, r1, pc, lsr #10
    22e8:	04050000 	streq	r0, [r5], #-0
    22ec:	00000057 	andeq	r0, r0, r7, asr r0
    22f0:	00003906 	andeq	r3, r0, r6, lsl #18
    22f4:	00006600 	andeq	r6, r0, r0, lsl #12
    22f8:	00660700 	rsbeq	r0, r6, r0, lsl #14
    22fc:	05000000 	streq	r0, [r0, #-0]
    2300:	00006c04 	andeq	r6, r0, r4, lsl #24
    2304:	da040800 	ble	10430c <_bss_end+0xfb0c4>
    2308:	0100001f 	tsteq	r0, pc, lsl r0
    230c:	00790f36 	rsbseq	r0, r9, r6, lsr pc
    2310:	04050000 	streq	r0, [r5], #-0
    2314:	0000007f 	andeq	r0, r0, pc, ror r0
    2318:	00001d06 	andeq	r1, r0, r6, lsl #26
    231c:	00009300 	andeq	r9, r0, r0, lsl #6
    2320:	00660700 	rsbeq	r0, r6, r0, lsl #14
    2324:	66070000 	strvs	r0, [r7], -r0
    2328:	00000000 	andeq	r0, r0, r0
    232c:	34080103 	strcc	r0, [r8], #-259	; 0xfffffefd
    2330:	09000005 	stmdbeq	r0, {r0, r2}
    2334:	00001a7b 	andeq	r1, r0, fp, ror sl
    2338:	4512bb01 	ldrmi	fp, [r2, #-2817]	; 0xfffff4ff
    233c:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
    2340:	00002008 	andeq	r2, r0, r8
    2344:	6d10be01 	ldcvs	14, cr11, [r0, #-4]
    2348:	03000000 	movweq	r0, #0
    234c:	05360601 	ldreq	r0, [r6, #-1537]!	; 0xfffff9ff
    2350:	630a0000 	movwvs	r0, #40960	; 0xa000
    2354:	07000017 	smladeq	r0, r7, r0, r0
    2358:	00009301 	andeq	r9, r0, r1, lsl #6
    235c:	06170200 	ldreq	r0, [r7], -r0, lsl #4
    2360:	000001e6 	andeq	r0, r0, r6, ror #3
    2364:	0012320b 	andseq	r3, r2, fp, lsl #4
    2368:	800b0000 	andhi	r0, fp, r0
    236c:	01000016 	tsteq	r0, r6, lsl r0
    2370:	001bab0b 	andseq	sl, fp, fp, lsl #22
    2374:	1c0b0200 	sfmne	f0, 4, [fp], {-0}
    2378:	0300001f 	movweq	r0, #31
    237c:	001aea0b 	andseq	lr, sl, fp, lsl #20
    2380:	250b0400 	strcs	r0, [fp, #-1024]	; 0xfffffc00
    2384:	0500001e 	streq	r0, [r0, #-30]	; 0xffffffe2
    2388:	001d890b 	andseq	r8, sp, fp, lsl #18
    238c:	530b0600 	movwpl	r0, #46592	; 0xb600
    2390:	07000012 	smladeq	r0, r2, r0, r0
    2394:	001e3a0b 	andseq	r3, lr, fp, lsl #20
    2398:	480b0800 	stmdami	fp, {fp}
    239c:	0900001e 	stmdbeq	r0, {r1, r2, r3, r4}
    23a0:	001f0f0b 	andseq	r0, pc, fp, lsl #30
    23a4:	410b0a00 	tstmi	fp, r0, lsl #20
    23a8:	0b00001a 	bleq	2418 <CPSR_IRQ_INHIBIT+0x2398>
    23ac:	0014150b 	andseq	r1, r4, fp, lsl #10
    23b0:	f20b0c00 			; <UNDEFINED> instruction: 0xf20b0c00
    23b4:	0d000014 	stceq	0, cr0, [r0, #-80]	; 0xffffffb0
    23b8:	0017a70b 	andseq	sl, r7, fp, lsl #14
    23bc:	bd0b0e00 	stclt	14, cr0, [fp, #-0]
    23c0:	0f000017 	svceq	0x00000017
    23c4:	0016ba0b 	andseq	fp, r6, fp, lsl #20
    23c8:	ce0b1000 	cdpgt	0, 0, cr1, cr11, cr0, {0}
    23cc:	1100001a 	tstne	r0, sl, lsl r0
    23d0:	0017260b 	andseq	r2, r7, fp, lsl #12
    23d4:	a10b1200 	mrsge	r1, R11_fiq
    23d8:	13000021 	movwne	r0, #33	; 0x21
    23dc:	0012bc0b 	andseq	fp, r2, fp, lsl #24
    23e0:	4a0b1400 	bmi	2c73e8 <_bss_end+0x2be1a0>
    23e4:	15000017 	strne	r0, [r0, #-23]	; 0xffffffe9
    23e8:	0011f90b 	andseq	pc, r1, fp, lsl #18
    23ec:	3f0b1600 	svccc	0x000b1600
    23f0:	1700001f 	smladne	r0, pc, r0, r0	; <UNPREDICTABLE>
    23f4:	0020610b 	eoreq	r6, r0, fp, lsl #2
    23f8:	6f0b1800 	svcvs	0x000b1800
    23fc:	19000017 	stmdbne	r0, {r0, r1, r2, r4}
    2400:	001c1d0b 	andseq	r1, ip, fp, lsl #26
    2404:	4d0b1a00 	vstrmi	s2, [fp, #-0]
    2408:	1b00001f 	blne	248c <CPSR_IRQ_INHIBIT+0x240c>
    240c:	0011280b 	andseq	r2, r1, fp, lsl #16
    2410:	5b0b1c00 	blpl	2c9418 <_bss_end+0x2c01d0>
    2414:	1d00001f 	stcne	0, cr0, [r0, #-124]	; 0xffffff84
    2418:	001f690b 	andseq	r6, pc, fp, lsl #18
    241c:	d60b1e00 	strle	r1, [fp], -r0, lsl #28
    2420:	1f000010 	svcne	0x00000010
    2424:	001f930b 	andseq	r9, pc, fp, lsl #6
    2428:	ca0b2000 	bgt	2ca430 <_bss_end+0x2c11e8>
    242c:	2100001c 	tstcs	r0, ip, lsl r0
    2430:	001aa00b 	andseq	sl, sl, fp
    2434:	320b2200 	andcc	r2, fp, #0, 4
    2438:	2300001f 	movwcs	r0, #31
    243c:	0019a40b 	andseq	sl, r9, fp, lsl #8
    2440:	a60b2400 	strge	r2, [fp], -r0, lsl #8
    2444:	25000018 	strcs	r0, [r0, #-24]	; 0xffffffe8
    2448:	0015c00b 	andseq	ip, r5, fp
    244c:	c40b2600 	strgt	r2, [fp], #-1536	; 0xfffffa00
    2450:	27000018 	smladcs	r0, r8, r0, r0
    2454:	00165c0b 	andseq	r5, r6, fp, lsl #24
    2458:	d40b2800 	strle	r2, [fp], #-2048	; 0xfffff800
    245c:	29000018 	stmdbcs	r0, {r3, r4}
    2460:	0018e40b 	andseq	lr, r8, fp, lsl #8
    2464:	270b2a00 	strcs	r2, [fp, -r0, lsl #20]
    2468:	2b00001a 	blcs	24d8 <CPSR_IRQ_INHIBIT+0x2458>
    246c:	00184d0b 	andseq	r4, r8, fp, lsl #26
    2470:	d70b2c00 	strle	r2, [fp, -r0, lsl #24]
    2474:	2d00001c 	stccs	0, cr0, [r0, #-112]	; 0xffffff90
    2478:	0016010b 	andseq	r0, r6, fp, lsl #2
    247c:	0a002e00 	beq	dc84 <_bss_end+0x4a3c>
    2480:	000017df 	ldrdeq	r1, [r0], -pc	; <UNPREDICTABLE>
    2484:	00930107 	addseq	r0, r3, r7, lsl #2
    2488:	17030000 	strne	r0, [r3, -r0]
    248c:	0003c706 	andeq	ip, r3, r6, lsl #14
    2490:	15140b00 	ldrne	r0, [r4, #-2816]	; 0xfffff500
    2494:	0b000000 	bleq	249c <CPSR_IRQ_INHIBIT+0x241c>
    2498:	00001166 	andeq	r1, r0, r6, ror #2
    249c:	214f0b01 	cmpcs	pc, r1, lsl #22
    24a0:	0b020000 	bleq	824a8 <_bss_end+0x79260>
    24a4:	00001fe2 	andeq	r1, r0, r2, ror #31
    24a8:	15340b03 	ldrne	r0, [r4, #-2819]!	; 0xfffff4fd
    24ac:	0b040000 	bleq	1024b4 <_bss_end+0xf926c>
    24b0:	0000121e 	andeq	r1, r0, lr, lsl r2
    24b4:	15dd0b05 	ldrbne	r0, [sp, #2821]	; 0xb05
    24b8:	0b060000 	bleq	1824c0 <_bss_end+0x179278>
    24bc:	00001524 	andeq	r1, r0, r4, lsr #10
    24c0:	1e760b07 	vaddne.f64	d16, d6, d7
    24c4:	0b080000 	bleq	2024cc <_bss_end+0x1f9284>
    24c8:	00001fc7 	andeq	r1, r0, r7, asr #31
    24cc:	1dad0b09 			; <UNDEFINED> instruction: 0x1dad0b09
    24d0:	0b0a0000 	bleq	2824d8 <_bss_end+0x279290>
    24d4:	00001271 	andeq	r1, r0, r1, ror r2
    24d8:	157e0b0b 	ldrbne	r0, [lr, #-2827]!	; 0xfffff4f5
    24dc:	0b0c0000 	bleq	3024e4 <_bss_end+0x2f929c>
    24e0:	000011e7 	andeq	r1, r0, r7, ror #3
    24e4:	21840b0d 	orrcs	r0, r4, sp, lsl #22
    24e8:	0b0e0000 	bleq	3824f0 <_bss_end+0x3792a8>
    24ec:	00001a14 	andeq	r1, r0, r4, lsl sl
    24f0:	16f10b0f 	ldrbtne	r0, [r1], pc, lsl #22
    24f4:	0b100000 	bleq	4024fc <_bss_end+0x3f92b4>
    24f8:	00001a51 	andeq	r1, r0, r1, asr sl
    24fc:	20a30b11 	adccs	r0, r3, r1, lsl fp
    2500:	0b120000 	bleq	482508 <_bss_end+0x4792c0>
    2504:	00001334 	andeq	r1, r0, r4, lsr r3
    2508:	17040b13 	smladne	r4, r3, fp, r0
    250c:	0b140000 	bleq	502514 <_bss_end+0x4f92cc>
    2510:	00001967 	andeq	r1, r0, r7, ror #18
    2514:	14ff0b15 	ldrbtne	r0, [pc], #2837	; 251c <CPSR_IRQ_INHIBIT+0x249c>
    2518:	0b160000 	bleq	582520 <_bss_end+0x5792d8>
    251c:	000019b3 			; <UNDEFINED> instruction: 0x000019b3
    2520:	17c90b17 	bfine	r0, r7, (invalid: 22:9)
    2524:	0b180000 	bleq	60252c <_bss_end+0x5f92e4>
    2528:	0000123c 	andeq	r1, r0, ip, lsr r2
    252c:	204a0b19 	subcs	r0, sl, r9, lsl fp
    2530:	0b1a0000 	bleq	682538 <_bss_end+0x6792f0>
    2534:	00001933 	andeq	r1, r0, r3, lsr r9
    2538:	16db0b1b 			; <UNDEFINED> instruction: 0x16db0b1b
    253c:	0b1c0000 	bleq	702544 <_bss_end+0x6f92fc>
    2540:	00001111 	andeq	r1, r0, r1, lsl r1
    2544:	187e0b1d 	ldmdane	lr!, {r0, r2, r3, r4, r8, r9, fp}^
    2548:	0b1e0000 	bleq	782550 <_bss_end+0x779308>
    254c:	0000186a 	andeq	r1, r0, sl, ror #16
    2550:	1d6a0b1f 	fstmdbxne	sl!, {d16-d30}	;@ Deprecated
    2554:	0b200000 	bleq	80255c <_bss_end+0x7f9314>
    2558:	00001df5 	strdeq	r1, [r0], -r5
    255c:	20290b21 	eorcs	r0, r9, r1, lsr #22
    2560:	0b220000 	bleq	882568 <_bss_end+0x879320>
    2564:	0000160e 	andeq	r1, r0, lr, lsl #12
    2568:	1bcd0b23 	blne	ff3451fc <_bss_end+0xff33bfb4>
    256c:	0b240000 	bleq	902574 <_bss_end+0x8f932c>
    2570:	00001dc2 	andeq	r1, r0, r2, asr #27
    2574:	1ce60b25 	fstmiaxne	r6!, {d16-d33}	;@ Deprecated
    2578:	0b260000 	bleq	982580 <_bss_end+0x979338>
    257c:	00001cfa 	strdeq	r1, [r0], -sl
    2580:	1d0e0b27 	vstrne	d0, [lr, #-156]	; 0xffffff64
    2584:	0b280000 	bleq	a0258c <_bss_end+0x9f9344>
    2588:	000013bf 			; <UNDEFINED> instruction: 0x000013bf
    258c:	131f0b29 	tstne	pc, #41984	; 0xa400
    2590:	0b2a0000 	bleq	a82598 <_bss_end+0xa79350>
    2594:	00001347 	andeq	r1, r0, r7, asr #6
    2598:	1ebf0b2b 			; <UNDEFINED> instruction: 0x1ebf0b2b
    259c:	0b2c0000 	bleq	b025a4 <_bss_end+0xaf935c>
    25a0:	0000139c 	muleq	r0, ip, r3
    25a4:	1ed30b2d 	vfnmsne.f64	d16, d3, d29
    25a8:	0b2e0000 	bleq	b825b0 <_bss_end+0xb79368>
    25ac:	00001ee7 	andeq	r1, r0, r7, ror #29
    25b0:	1efb0b2f 			; <UNDEFINED> instruction: 0x1efb0b2f
    25b4:	0b300000 	bleq	c025bc <_bss_end+0xbf9374>
    25b8:	00001590 	muleq	r0, r0, r5
    25bc:	156a0b31 	strbne	r0, [sl, #-2865]!	; 0xfffff4cf
    25c0:	0b320000 	bleq	c825c8 <_bss_end+0xc79380>
    25c4:	00001892 	muleq	r0, r2, r8
    25c8:	1a640b33 	bne	190529c <_bss_end+0x18fc054>
    25cc:	0b340000 	bleq	d025d4 <_bss_end+0xcf938c>
    25d0:	000020d8 	ldrdeq	r2, [r0], -r8
    25d4:	10b90b35 	adcsne	r0, r9, r5, lsr fp
    25d8:	0b360000 	bleq	d825e0 <_bss_end+0xd79398>
    25dc:	00001690 	muleq	r0, r0, r6
    25e0:	16a50b37 			; <UNDEFINED> instruction: 0x16a50b37
    25e4:	0b380000 	bleq	e025ec <_bss_end+0xdf93a4>
    25e8:	000018f4 	strdeq	r1, [r0], -r4
    25ec:	191e0b39 	ldmdbne	lr, {r0, r3, r4, r5, r8, r9, fp}
    25f0:	0b3a0000 	bleq	e825f8 <_bss_end+0xe793b0>
    25f4:	00002101 	andeq	r2, r0, r1, lsl #2
    25f8:	1bb80b3b 	blne	fee052ec <_bss_end+0xfedfc0a4>
    25fc:	0b3c0000 	bleq	f02604 <_bss_end+0xef93bc>
    2600:	00001633 	andeq	r1, r0, r3, lsr r6
    2604:	11780b3d 	cmnne	r8, sp, lsr fp
    2608:	0b3e0000 	bleq	f82610 <_bss_end+0xf793c8>
    260c:	00001136 	andeq	r1, r0, r6, lsr r1
    2610:	1ab00b3f 	bne	fec05314 <_bss_end+0xfebfc0cc>
    2614:	0b400000 	bleq	100261c <_bss_end+0xff93d4>
    2618:	00001c39 	andeq	r1, r0, r9, lsr ip
    261c:	1d4c0b41 	vstrne	d16, [ip, #-260]	; 0xfffffefc
    2620:	0b420000 	bleq	1082628 <_bss_end+0x10793e0>
    2624:	00001909 	andeq	r1, r0, r9, lsl #18
    2628:	213a0b43 	teqcs	sl, r3, asr #22
    262c:	0b440000 	bleq	1102634 <_bss_end+0x10f93ec>
    2630:	00001be3 	andeq	r1, r0, r3, ror #23
    2634:	13630b45 	cmnne	r3, #70656	; 0x11400
    2638:	0b460000 	bleq	1182640 <_bss_end+0x11793f8>
    263c:	000019e4 	andeq	r1, r0, r4, ror #19
    2640:	18170b47 	ldmdane	r7, {r0, r1, r2, r6, r8, r9, fp}
    2644:	0b480000 	bleq	120264c <_bss_end+0x11f9404>
    2648:	000010f5 	strdeq	r1, [r0], -r5
    264c:	12090b49 	andne	r0, r9, #74752	; 0x12400
    2650:	0b4a0000 	bleq	1282658 <_bss_end+0x1279410>
    2654:	00001647 	andeq	r1, r0, r7, asr #12
    2658:	19450b4b 	stmdbne	r5, {r0, r1, r3, r6, r8, r9, fp}^
    265c:	004c0000 	subeq	r0, ip, r0
    2660:	80070203 	andhi	r0, r7, r3, lsl #4
    2664:	0c000005 	stceq	0, cr0, [r0], {5}
    2668:	000003e4 	andeq	r0, r0, r4, ror #7
    266c:	000003d9 	ldrdeq	r0, [r0], -r9
    2670:	ce0e000d 	cdpgt	0, 0, cr0, cr14, cr13, {0}
    2674:	05000003 	streq	r0, [r0, #-3]
    2678:	0003f004 	andeq	pc, r3, r4
    267c:	03de0e00 	bicseq	r0, lr, #0, 28
    2680:	01030000 	mrseq	r0, (UNDEF: 3)
    2684:	00053d08 	andeq	r3, r5, r8, lsl #26
    2688:	03e90e00 	mvneq	r0, #0, 28
    268c:	ad0f0000 	stcge	0, cr0, [pc, #-0]	; 2694 <CPSR_IRQ_INHIBIT+0x2614>
    2690:	04000012 	streq	r0, [r0], #-18	; 0xffffffee
    2694:	d91a014c 	ldmdble	sl, {r2, r3, r6, r8}
    2698:	0f000003 	svceq	0x00000003
    269c:	000016cb 	andeq	r1, r0, fp, asr #13
    26a0:	1a018204 	bne	62eb8 <_bss_end+0x59c70>
    26a4:	000003d9 	ldrdeq	r0, [r0], -r9
    26a8:	0003e90c 	andeq	lr, r3, ip, lsl #18
    26ac:	00041a00 	andeq	r1, r4, r0, lsl #20
    26b0:	09000d00 	stmdbeq	r0, {r8, sl, fp}
    26b4:	000018b6 			; <UNDEFINED> instruction: 0x000018b6
    26b8:	0f0d2d05 	svceq	0x000d2d05
    26bc:	09000004 	stmdbeq	r0, {r2}
    26c0:	00001fa3 	andeq	r1, r0, r3, lsr #31
    26c4:	e61c3805 	ldr	r3, [ip], -r5, lsl #16
    26c8:	0a000001 	beq	26d4 <CPSR_IRQ_INHIBIT+0x2654>
    26cc:	000015a4 	andeq	r1, r0, r4, lsr #11
    26d0:	00930107 	addseq	r0, r3, r7, lsl #2
    26d4:	3a050000 	bcc	1426dc <_bss_end+0x139494>
    26d8:	0004a50e 	andeq	sl, r4, lr, lsl #10
    26dc:	110a0b00 	tstne	sl, r0, lsl #22
    26e0:	0b000000 	bleq	26e8 <CPSR_IRQ_INHIBIT+0x2668>
    26e4:	000017b6 			; <UNDEFINED> instruction: 0x000017b6
    26e8:	20b50b01 	adcscs	r0, r5, r1, lsl #22
    26ec:	0b020000 	bleq	826f4 <_bss_end+0x794ac>
    26f0:	00002078 	andeq	r2, r0, r8, ror r0
    26f4:	1b0d0b03 	blne	345308 <_bss_end+0x33c0c0>
    26f8:	0b040000 	bleq	102700 <_bss_end+0xf94b8>
    26fc:	00001e33 	andeq	r1, r0, r3, lsr lr
    2700:	12f00b05 	rscsne	r0, r0, #5120	; 0x1400
    2704:	0b060000 	bleq	18270c <_bss_end+0x1794c4>
    2708:	000012d2 	ldrdeq	r1, [r0], -r2
    270c:	14eb0b07 	strbtne	r0, [fp], #2823	; 0xb07
    2710:	0b080000 	bleq	202718 <_bss_end+0x1f94d0>
    2714:	000019c9 	andeq	r1, r0, r9, asr #19
    2718:	12f70b09 	rscsne	r0, r7, #9216	; 0x2400
    271c:	0b0a0000 	bleq	282724 <_bss_end+0x2794dc>
    2720:	000019d0 	ldrdeq	r1, [r0], -r0
    2724:	135c0b0b 	cmpne	ip, #11264	; 0x2c00
    2728:	0b0c0000 	bleq	302730 <_bss_end+0x2f94e8>
    272c:	000012e9 	andeq	r1, r0, r9, ror #5
    2730:	1e8a0b0d 	vdivne.f64	d0, d10, d13
    2734:	0b0e0000 	bleq	38273c <_bss_end+0x3794f4>
    2738:	00001c57 	andeq	r1, r0, r7, asr ip
    273c:	8204000f 	andhi	r0, r4, #15
    2740:	0500001d 	streq	r0, [r0, #-29]	; 0xffffffe3
    2744:	0432013f 	ldrteq	r0, [r2], #-319	; 0xfffffec1
    2748:	16090000 	strne	r0, [r9], -r0
    274c:	0500001e 	streq	r0, [r0, #-30]	; 0xffffffe2
    2750:	04a50f41 	strteq	r0, [r5], #3905	; 0xf41
    2754:	9e090000 	cdpls	0, 0, cr0, cr9, cr0, {0}
    2758:	0500001e 	streq	r0, [r0, #-30]	; 0xffffffe2
    275c:	001d0c4a 	andseq	r0, sp, sl, asr #24
    2760:	91090000 	mrsls	r0, (UNDEF: 9)
    2764:	05000012 	streq	r0, [r0, #-18]	; 0xffffffee
    2768:	001d0c4b 	andseq	r0, sp, fp, asr #24
    276c:	77100000 	ldrvc	r0, [r0, -r0]
    2770:	0900001f 	stmdbeq	r0, {r0, r1, r2, r3, r4}
    2774:	00001eaf 	andeq	r1, r0, pc, lsr #29
    2778:	e6144c05 	ldr	r4, [r4], -r5, lsl #24
    277c:	05000004 	streq	r0, [r0, #-4]
    2780:	0004d504 	andeq	sp, r4, r4, lsl #10
    2784:	80091100 	andhi	r1, r9, r0, lsl #2
    2788:	05000017 	streq	r0, [r0, #-23]	; 0xffffffe9
    278c:	04f90f4e 	ldrbteq	r0, [r9], #3918	; 0xf4e
    2790:	04050000 	streq	r0, [r5], #-0
    2794:	000004ec 	andeq	r0, r0, ip, ror #9
    2798:	001d9812 	andseq	r9, sp, r2, lsl r8
    279c:	1afa0900 	bne	ffe84ba4 <_bss_end+0xffe7b95c>
    27a0:	52050000 	andpl	r0, r5, #0
    27a4:	0005100d 	andeq	r1, r5, sp
    27a8:	ff040500 			; <UNDEFINED> instruction: 0xff040500
    27ac:	13000004 	movwne	r0, #4
    27b0:	00001408 	andeq	r1, r0, r8, lsl #8
    27b4:	01670534 	cmneq	r7, r4, lsr r5
    27b8:	00054115 	andeq	r4, r5, r5, lsl r1
    27bc:	18bf1400 	ldmne	pc!, {sl, ip}	; <UNPREDICTABLE>
    27c0:	69050000 	stmdbvs	r5, {}	; <UNPREDICTABLE>
    27c4:	03de0f01 	bicseq	r0, lr, #1, 30
    27c8:	14000000 	strne	r0, [r0], #-0
    27cc:	000013ec 	andeq	r1, r0, ip, ror #7
    27d0:	14016a05 	strne	r6, [r1], #-2565	; 0xfffff5fb
    27d4:	00000546 	andeq	r0, r0, r6, asr #10
    27d8:	160e0004 	strne	r0, [lr], -r4
    27dc:	0c000005 	stceq	0, cr0, [r0], {5}
    27e0:	000000b9 	strheq	r0, [r0], -r9
    27e4:	00000556 	andeq	r0, r0, r6, asr r5
    27e8:	00002415 	andeq	r2, r0, r5, lsl r4
    27ec:	0c002d00 	stceq	13, cr2, [r0], {-0}
    27f0:	00000541 	andeq	r0, r0, r1, asr #10
    27f4:	00000561 	andeq	r0, r0, r1, ror #10
    27f8:	560e000d 	strpl	r0, [lr], -sp
    27fc:	0f000005 	svceq	0x00000005
    2800:	000017ee 	andeq	r1, r0, lr, ror #15
    2804:	03016b05 	movweq	r6, #6917	; 0x1b05
    2808:	00000561 	andeq	r0, r0, r1, ror #10
    280c:	001a340f 	andseq	r3, sl, pc, lsl #8
    2810:	016e0500 	cmneq	lr, r0, lsl #10
    2814:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2818:	1dd61600 	ldclne	6, cr1, [r6]
    281c:	01070000 	mrseq	r0, (UNDEF: 7)
    2820:	00000093 	muleq	r0, r3, r0
    2824:	06018105 	streq	r8, [r1], -r5, lsl #2
    2828:	0000062a 	andeq	r0, r0, sl, lsr #12
    282c:	00119f0b 	andseq	r9, r1, fp, lsl #30
    2830:	ab0b0000 	blge	2c2838 <_bss_end+0x2b95f0>
    2834:	02000011 	andeq	r0, r0, #17
    2838:	0011b70b 	andseq	fp, r1, fp, lsl #14
    283c:	d00b0300 	andle	r0, fp, r0, lsl #6
    2840:	03000015 	movweq	r0, #21
    2844:	0011c30b 	andseq	ip, r1, fp, lsl #6
    2848:	190b0400 	stmdbne	fp, {sl}
    284c:	04000017 	streq	r0, [r0], #-23	; 0xffffffe9
    2850:	0017ff0b 	andseq	pc, r7, fp, lsl #30
    2854:	550b0500 	strpl	r0, [fp, #-1280]	; 0xfffffb00
    2858:	05000017 	streq	r0, [r0, #-23]	; 0xffffffe9
    285c:	0012820b 	andseq	r8, r2, fp, lsl #4
    2860:	cf0b0500 	svcgt	0x000b0500
    2864:	06000011 			; <UNDEFINED> instruction: 0x06000011
    2868:	00197d0b 	andseq	r7, r9, fp, lsl #26
    286c:	de0b0600 	cfmadd32le	mvax0, mvfx0, mvfx11, mvfx0
    2870:	06000013 			; <UNDEFINED> instruction: 0x06000013
    2874:	00198a0b 	andseq	r8, r9, fp, lsl #20
    2878:	560b0600 	strpl	r0, [fp], -r0, lsl #12
    287c:	0600001e 			; <UNDEFINED> instruction: 0x0600001e
    2880:	0019970b 	andseq	r9, r9, fp, lsl #14
    2884:	d70b0600 	strle	r0, [fp, -r0, lsl #12]
    2888:	06000019 			; <UNDEFINED> instruction: 0x06000019
    288c:	0011db0b 	andseq	sp, r1, fp, lsl #22
    2890:	dd0b0700 	stcle	7, cr0, [fp, #-0]
    2894:	0700001a 	smladeq	r0, sl, r0, r0
    2898:	001b2a0b 	andseq	r2, fp, fp, lsl #20
    289c:	910b0700 	tstls	fp, r0, lsl #14
    28a0:	0700001e 	smladeq	r0, lr, r0, r0
    28a4:	0013b10b 	andseq	fp, r3, fp, lsl #2
    28a8:	100b0700 	andne	r0, fp, r0, lsl #14
    28ac:	0800001c 	stmdaeq	r0, {r2, r3, r4}
    28b0:	0011540b 	andseq	r5, r1, fp, lsl #8
    28b4:	640b0800 	strvs	r0, [fp], #-2048	; 0xfffff800
    28b8:	0800001e 	stmdaeq	r0, {r1, r2, r3, r4}
    28bc:	001c2c0b 	andseq	r2, ip, fp, lsl #24
    28c0:	0f000800 	svceq	0x00000800
    28c4:	000020ca 	andeq	r2, r0, sl, asr #1
    28c8:	1f019f05 	svcne	0x00019f05
    28cc:	00000580 	andeq	r0, r0, r0, lsl #11
    28d0:	001c5e0f 	andseq	r5, ip, pc, lsl #28
    28d4:	01a20500 			; <UNDEFINED> instruction: 0x01a20500
    28d8:	00001d0c 	andeq	r1, r0, ip, lsl #26
    28dc:	180c0f00 	stmdane	ip, {r8, r9, sl, fp}
    28e0:	a5050000 	strge	r0, [r5, #-0]
    28e4:	001d0c01 	andseq	r0, sp, r1, lsl #24
    28e8:	960f0000 	strls	r0, [pc], -r0
    28ec:	05000021 	streq	r0, [r0, #-33]	; 0xffffffdf
    28f0:	1d0c01a8 	stfnes	f0, [ip, #-672]	; 0xfffffd60
    28f4:	0f000000 	svceq	0x00000000
    28f8:	000012a1 	andeq	r1, r0, r1, lsr #5
    28fc:	0c01ab05 			; <UNDEFINED> instruction: 0x0c01ab05
    2900:	0000001d 	andeq	r0, r0, sp, lsl r0
    2904:	001c680f 	andseq	r6, ip, pc, lsl #16
    2908:	01ae0500 			; <UNDEFINED> instruction: 0x01ae0500
    290c:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2910:	1b140f00 	blne	506518 <_bss_end+0x4fd2d0>
    2914:	b1050000 	mrslt	r0, (UNDEF: 5)
    2918:	001d0c01 	andseq	r0, sp, r1, lsl #24
    291c:	1f0f0000 	svcne	0x000f0000
    2920:	0500001b 	streq	r0, [r0, #-27]	; 0xffffffe5
    2924:	1d0c01b4 	stfnes	f0, [ip, #-720]	; 0xfffffd30
    2928:	0f000000 	svceq	0x00000000
    292c:	00001c72 	andeq	r1, r0, r2, ror ip
    2930:	0c01b705 	stceq	7, cr11, [r1], {5}
    2934:	0000001d 	andeq	r0, r0, sp, lsl r0
    2938:	0019590f 	andseq	r5, r9, pc, lsl #18
    293c:	01ba0500 			; <UNDEFINED> instruction: 0x01ba0500
    2940:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2944:	20f50f00 	rscscs	r0, r5, r0, lsl #30
    2948:	bd050000 	stclt	0, cr0, [r5, #-0]
    294c:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2950:	7c0f0000 	stcvc	0, cr0, [pc], {-0}
    2954:	0500001c 	streq	r0, [r0, #-28]	; 0xffffffe4
    2958:	1d0c01c0 	stfnes	f0, [ip, #-768]	; 0xfffffd00
    295c:	0f000000 	svceq	0x00000000
    2960:	000021b9 			; <UNDEFINED> instruction: 0x000021b9
    2964:	0c01c305 	stceq	3, cr12, [r1], {5}
    2968:	0000001d 	andeq	r0, r0, sp, lsl r0
    296c:	00207f0f 	eoreq	r7, r0, pc, lsl #30
    2970:	01c60500 	biceq	r0, r6, r0, lsl #10
    2974:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2978:	208b0f00 	addcs	r0, fp, r0, lsl #30
    297c:	c9050000 	stmdbgt	r5, {}	; <UNPREDICTABLE>
    2980:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2984:	970f0000 	strls	r0, [pc, -r0]
    2988:	05000020 	streq	r0, [r0, #-32]	; 0xffffffe0
    298c:	1d0c01cc 	stfnes	f0, [ip, #-816]	; 0xfffffcd0
    2990:	0f000000 	svceq	0x00000000
    2994:	000020bc 	strheq	r2, [r0], -ip
    2998:	0c01d005 	stceq	0, cr13, [r1], {5}
    299c:	0000001d 	andeq	r0, r0, sp, lsl r0
    29a0:	0021ac0f 	eoreq	sl, r1, pc, lsl #24
    29a4:	01d30500 	bicseq	r0, r3, r0, lsl #10
    29a8:	00001d0c 	andeq	r1, r0, ip, lsl #26
    29ac:	12fe0f00 	rscsne	r0, lr, #0, 30
    29b0:	d6050000 	strle	r0, [r5], -r0
    29b4:	001d0c01 	andseq	r0, sp, r1, lsl #24
    29b8:	e50f0000 	str	r0, [pc, #-0]	; 29c0 <CPSR_IRQ_INHIBIT+0x2940>
    29bc:	05000010 	streq	r0, [r0, #-16]
    29c0:	1d0c01d9 	stfnes	f0, [ip, #-868]	; 0xfffffc9c
    29c4:	0f000000 	svceq	0x00000000
    29c8:	000015f0 	strdeq	r1, [r0], -r0
    29cc:	0c01dc05 	stceq	12, cr13, [r1], {5}
    29d0:	0000001d 	andeq	r0, r0, sp, lsl r0
    29d4:	0012d90f 	andseq	sp, r2, pc, lsl #18
    29d8:	01df0500 	bicseq	r0, pc, r0, lsl #10
    29dc:	00001d0c 	andeq	r1, r0, ip, lsl #26
    29e0:	1c920f00 	ldcne	15, cr0, [r2], {0}
    29e4:	e2050000 	and	r0, r5, #0
    29e8:	001d0c01 	andseq	r0, sp, r1, lsl #24
    29ec:	350f0000 	strcc	r0, [pc, #-0]	; 29f4 <CPSR_IRQ_INHIBIT+0x2974>
    29f0:	05000018 	streq	r0, [r0, #-24]	; 0xffffffe8
    29f4:	1d0c01e5 	stfnes	f0, [ip, #-916]	; 0xfffffc6c
    29f8:	0f000000 	svceq	0x00000000
    29fc:	00001a8d 	andeq	r1, r0, sp, lsl #21
    2a00:	0c01e805 	stceq	8, cr14, [r1], {5}
    2a04:	0000001d 	andeq	r0, r0, sp, lsl r0
    2a08:	001fac0f 	andseq	sl, pc, pc, lsl #24
    2a0c:	01ef0500 	mvneq	r0, r0, lsl #10
    2a10:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2a14:	21640f00 	cmncs	r4, r0, lsl #30
    2a18:	f2050000 	vhadd.s8	d0, d5, d0
    2a1c:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2a20:	740f0000 	strvc	r0, [pc], #-0	; 2a28 <CPSR_IRQ_INHIBIT+0x29a8>
    2a24:	05000021 	streq	r0, [r0, #-33]	; 0xffffffdf
    2a28:	1d0c01f5 	stfnes	f0, [ip, #-980]	; 0xfffffc2c
    2a2c:	0f000000 	svceq	0x00000000
    2a30:	000013f5 	strdeq	r1, [r0], -r5
    2a34:	0c01f805 	stceq	8, cr15, [r1], {5}
    2a38:	0000001d 	andeq	r0, r0, sp, lsl r0
    2a3c:	001ff30f 	andseq	pc, pc, pc, lsl #6
    2a40:	01fb0500 	mvnseq	r0, r0, lsl #10
    2a44:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2a48:	1bf80f00 	blne	ffe06650 <_bss_end+0xffdfd408>
    2a4c:	fe050000 	cdp2	0, 0, cr0, cr5, cr0, {0}
    2a50:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2a54:	690f0000 	stmdbvs	pc, {}	; <UNPREDICTABLE>
    2a58:	05000016 	streq	r0, [r0, #-22]	; 0xffffffea
    2a5c:	1d0c0202 	sfmne	f0, 4, [ip, #-8]
    2a60:	0f000000 	svceq	0x00000000
    2a64:	00001de8 	andeq	r1, r0, r8, ror #27
    2a68:	0c020a05 			; <UNDEFINED> instruction: 0x0c020a05
    2a6c:	0000001d 	andeq	r0, r0, sp, lsl r0
    2a70:	00155c0f 	andseq	r5, r5, pc, lsl #24
    2a74:	020d0500 	andeq	r0, sp, #0, 10
    2a78:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2a7c:	001d0c00 	andseq	r0, sp, r0, lsl #24
    2a80:	07ef0000 	strbeq	r0, [pc, r0]!
    2a84:	000d0000 	andeq	r0, sp, r0
    2a88:	0017350f 	andseq	r3, r7, pc, lsl #10
    2a8c:	03fb0500 	mvnseq	r0, #0, 10
    2a90:	0007e40c 	andeq	lr, r7, ip, lsl #8
    2a94:	04e60c00 	strbteq	r0, [r6], #3072	; 0xc00
    2a98:	080c0000 	stmdaeq	ip, {}	; <UNPREDICTABLE>
    2a9c:	24150000 	ldrcs	r0, [r5], #-0
    2aa0:	0d000000 	stceq	0, cr0, [r0, #-0]
    2aa4:	1cb50f00 	ldcne	15, cr0, [r5]
    2aa8:	84050000 	strhi	r0, [r5], #-0
    2aac:	07fc1405 	ldrbeq	r1, [ip, r5, lsl #8]!
    2ab0:	f7160000 			; <UNDEFINED> instruction: 0xf7160000
    2ab4:	07000017 	smladeq	r0, r7, r0, r0
    2ab8:	00009301 	andeq	r9, r0, r1, lsl #6
    2abc:	058b0500 	streq	r0, [fp, #1280]	; 0x500
    2ac0:	00085706 	andeq	r5, r8, r6, lsl #14
    2ac4:	15b20b00 	ldrne	r0, [r2, #2816]!	; 0xb00
    2ac8:	0b000000 	bleq	2ad0 <CPSR_IRQ_INHIBIT+0x2a50>
    2acc:	00001a02 	andeq	r1, r0, r2, lsl #20
    2ad0:	118a0b01 	orrne	r0, sl, r1, lsl #22
    2ad4:	0b020000 	bleq	82adc <_bss_end+0x79894>
    2ad8:	00002126 	andeq	r2, r0, r6, lsr #2
    2adc:	1d2f0b03 	fstmdbxne	pc!, {d0}	;@ Deprecated
    2ae0:	0b040000 	bleq	102ae8 <_bss_end+0xf98a0>
    2ae4:	00001d22 	andeq	r1, r0, r2, lsr #26
    2ae8:	12610b05 	rsbne	r0, r1, #5120	; 0x1400
    2aec:	00060000 	andeq	r0, r6, r0
    2af0:	0021160f 	eoreq	r1, r1, pc, lsl #12
    2af4:	05980500 	ldreq	r0, [r8, #1280]	; 0x500
    2af8:	00081915 	andeq	r1, r8, r5, lsl r9
    2afc:	20180f00 	andscs	r0, r8, r0, lsl #30
    2b00:	99050000 	stmdbls	r5, {}	; <UNPREDICTABLE>
    2b04:	00241107 	eoreq	r1, r4, r7, lsl #2
    2b08:	a20f0000 	andge	r0, pc, #0
    2b0c:	0500001c 	streq	r0, [r0, #-28]	; 0xffffffe4
    2b10:	1d0c07ae 	stcne	7, cr0, [ip, #-696]	; 0xfffffd48
    2b14:	04000000 	streq	r0, [r0], #-0
    2b18:	00001f8b 	andeq	r1, r0, fp, lsl #31
    2b1c:	93167b06 	tstls	r6, #6144	; 0x1800
    2b20:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    2b24:	0000087e 	andeq	r0, r0, lr, ror r8
    2b28:	ab050203 	blge	14333c <_bss_end+0x13a0f4>
    2b2c:	03000002 	movweq	r0, #2
    2b30:	15450708 	strbne	r0, [r5, #-1800]	; 0xfffff8f8
    2b34:	04030000 	streq	r0, [r3], #-0
    2b38:	00131904 	andseq	r1, r3, r4, lsl #18
    2b3c:	03080300 	movweq	r0, #33536	; 0x8300
    2b40:	00001311 	andeq	r1, r0, r1, lsl r3
    2b44:	8b040803 	blhi	104b58 <_bss_end+0xfb910>
    2b48:	0300001c 	movweq	r0, #28
    2b4c:	1d3d0310 	ldcne	3, cr0, [sp, #-64]!	; 0xffffffc0
    2b50:	8a0c0000 	bhi	302b58 <_bss_end+0x2f9910>
    2b54:	c9000008 	stmdbgt	r0, {r3}
    2b58:	15000008 	strne	r0, [r0, #-8]
    2b5c:	00000024 	andeq	r0, r0, r4, lsr #32
    2b60:	b90e00ff 	stmdblt	lr, {r0, r1, r2, r3, r4, r5, r6, r7}
    2b64:	0f000008 	svceq	0x00000008
    2b68:	00001b37 	andeq	r1, r0, r7, lsr fp
    2b6c:	1601fc06 	strne	pc, [r1], -r6, lsl #24
    2b70:	000008c9 	andeq	r0, r0, r9, asr #17
    2b74:	0012c80f 	andseq	ip, r2, pc, lsl #16
    2b78:	02020600 	andeq	r0, r2, #0, 12
    2b7c:	0008c916 	andeq	ip, r8, r6, lsl r9
    2b80:	1fbe0400 	svcne	0x00be0400
    2b84:	2a070000 	bcs	1c2b8c <_bss_end+0x1b9944>
    2b88:	0004f910 	andeq	pc, r4, r0, lsl r9	; <UNPREDICTABLE>
    2b8c:	08e80c00 	stmiaeq	r8!, {sl, fp}^
    2b90:	08ff0000 	ldmeq	pc!, {}^	; <UNPREDICTABLE>
    2b94:	000d0000 	andeq	r0, sp, r0
    2b98:	00103e09 	andseq	r3, r0, r9, lsl #28
    2b9c:	112f0700 			; <UNDEFINED> instruction: 0x112f0700
    2ba0:	000008f4 	strdeq	r0, [r0], -r4
    2ba4:	00101e09 	andseq	r1, r0, r9, lsl #28
    2ba8:	11300700 	teqne	r0, r0, lsl #14
    2bac:	000008f4 	strdeq	r0, [r0], -r4
    2bb0:	0008ff17 	andeq	pc, r8, r7, lsl pc	; <UNPREDICTABLE>
    2bb4:	09330800 	ldmdbeq	r3!, {fp}
    2bb8:	1803050a 	stmdane	r3, {r1, r3, r8, sl}
    2bbc:	17000092 			; <UNDEFINED> instruction: 0x17000092
    2bc0:	0000090b 	andeq	r0, r0, fp, lsl #18
    2bc4:	0a093408 	beq	24fbec <_bss_end+0x2469a4>
    2bc8:	92240305 	eorls	r0, r4, #335544320	; 0x14000000
    2bcc:	Address 0x0000000000002bcc is out of bounds.


Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
   0:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
   4:	030b130e 	movweq	r1, #45838	; 0xb30e
   8:	110e1b0e 	tstne	lr, lr, lsl #22
   c:	10061201 	andne	r1, r6, r1, lsl #4
  10:	02000017 	andeq	r0, r0, #23
  14:	193f002e 	ldmdbne	pc!, {r1, r2, r3, r5}	; <UNPREDICTABLE>
  18:	0b3a0e03 	bleq	e8382c <_bss_end+0xe7a5e4>
  1c:	0b390b3b 	bleq	e42d10 <_bss_end+0xe39ac8>
  20:	06120111 			; <UNDEFINED> instruction: 0x06120111
  24:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
  28:	03000019 	movweq	r0, #25
  2c:	0e030139 	mcreq	1, 0, r0, cr3, cr9, {1}
  30:	0b3b0b3a 	bleq	ec2d20 <_bss_end+0xeb9ad8>
  34:	00001301 	andeq	r1, r0, r1, lsl #6
  38:	3f012e04 	svccc	0x00012e04
  3c:	3a0e0319 	bcc	380ca8 <_bss_end+0x377a60>
  40:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
  44:	01193c0b 	tsteq	r9, fp, lsl #24
  48:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
  4c:	13490005 	movtne	r0, #36869	; 0x9005
  50:	16060000 	strne	r0, [r6], -r0
  54:	3a0e0300 	bcc	380c5c <_bss_end+0x377a14>
  58:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
  5c:	0013490b 	andseq	r4, r3, fp, lsl #18
  60:	012e0700 			; <UNDEFINED> instruction: 0x012e0700
  64:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
  68:	0b3b0b3a 	bleq	ec2d58 <_bss_end+0xeb9b10>
  6c:	13490b39 	movtne	r0, #39737	; 0x9b39
  70:	0000193c 	andeq	r1, r0, ip, lsr r9
  74:	0b000f08 	bleq	3c9c <CPSR_IRQ_INHIBIT+0x3c1c>
  78:	0013490b 	andseq	r4, r3, fp, lsl #18
  7c:	00240900 	eoreq	r0, r4, r0, lsl #18
  80:	0b3e0b0b 	bleq	f82cb4 <_bss_end+0xf79a6c>
  84:	00000e03 	andeq	r0, r0, r3, lsl #28
  88:	47012e0a 	strmi	r2, [r1, -sl, lsl #28]
  8c:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
  90:	97184006 	ldrls	r4, [r8, -r6]
  94:	13011942 	movwne	r1, #6466	; 0x1942
  98:	050b0000 	streq	r0, [fp, #-0]
  9c:	02134900 	andseq	r4, r3, #0, 18
  a0:	0c000018 	stceq	0, cr0, [r0], {24}
  a4:	08030005 	stmdaeq	r3, {r0, r2}
  a8:	0b3b0b3a 	bleq	ec2d98 <_bss_end+0xeb9b50>
  ac:	13490b39 	movtne	r0, #39737	; 0x9b39
  b0:	00001802 	andeq	r1, r0, r2, lsl #16
  b4:	0b00240d 	bleq	90f0 <_cpp_shutdown+0x40>
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
  e4:	0b0b0024 	bleq	2c017c <_bss_end+0x2b6f34>
  e8:	0e030b3e 	vmoveq.16	d3[0], r0
  ec:	24030000 	strcs	r0, [r3], #-0
  f0:	3e0b0b00 	vmlacc.f64	d0, d11, d0
  f4:	0008030b 	andeq	r0, r8, fp, lsl #6
  f8:	00160400 	andseq	r0, r6, r0, lsl #8
  fc:	0b3a0e03 	bleq	e83910 <_bss_end+0xe7a6c8>
 100:	0b390b3b 	bleq	e42df4 <_bss_end+0xe39bac>
 104:	00001349 	andeq	r1, r0, r9, asr #6
 108:	49002605 	stmdbmi	r0, {r0, r2, r9, sl, sp}
 10c:	06000013 			; <UNDEFINED> instruction: 0x06000013
 110:	08030139 	stmdaeq	r3, {r0, r3, r4, r5, r8}
 114:	0b3b0b3a 	bleq	ec2e04 <_bss_end+0xeb9bbc>
 118:	13010b39 	movwne	r0, #6969	; 0x1b39
 11c:	34070000 	strcc	r0, [r7], #-0
 120:	3a0e0300 	bcc	380d28 <_bss_end+0x377ae0>
 124:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 128:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
 12c:	6c061c19 	stcvs	12, cr1, [r6], {25}
 130:	08000019 	stmdaeq	r0, {r0, r3, r4}
 134:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 138:	0b3b0b3a 	bleq	ec2e28 <_bss_end+0xeb9be0>
 13c:	13490b39 	movtne	r0, #39737	; 0x9b39
 140:	0b1c193c 	bleq	706638 <_bss_end+0x6fd3f0>
 144:	0000196c 	andeq	r1, r0, ip, ror #18
 148:	03010409 	movweq	r0, #5129	; 0x1409
 14c:	3e196d0e 	cdpcc	13, 1, cr6, cr9, cr14, {0}
 150:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
 154:	3b0b3a13 	blcc	2ce9a8 <_bss_end+0x2c5760>
 158:	010b390b 	tsteq	fp, fp, lsl #18
 15c:	0a000013 	beq	1b0 <CPSR_IRQ_INHIBIT+0x130>
 160:	0e030028 	cdpeq	0, 0, cr0, cr3, cr8, {1}
 164:	00000b1c 	andeq	r0, r0, ip, lsl fp
 168:	4700340b 	strmi	r3, [r0, -fp, lsl #8]
 16c:	0c000013 	stceq	0, cr0, [r0], {19}
 170:	08030028 	stmdaeq	r3, {r3, r5}
 174:	00000b1c 	andeq	r0, r0, ip, lsl fp
 178:	0301020d 	movweq	r0, #4621	; 0x120d
 17c:	3a0b0b0e 	bcc	2c2dbc <_bss_end+0x2b9b74>
 180:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 184:	0013010b 	andseq	r0, r3, fp, lsl #2
 188:	000d0e00 	andeq	r0, sp, r0, lsl #28
 18c:	0b3a0e03 	bleq	e839a0 <_bss_end+0xe7a758>
 190:	0b390b3b 	bleq	e42e84 <_bss_end+0xe39c3c>
 194:	0b381349 	bleq	e04ec0 <_bss_end+0xdfbc78>
 198:	2e0f0000 	cdpcs	0, 0, cr0, cr15, cr0, {0}
 19c:	03193f01 	tsteq	r9, #1, 30
 1a0:	3b0b3a0e 	blcc	2ce9e0 <_bss_end+0x2c5798>
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
 1cc:	0b3b0b3a 	bleq	ec2ebc <_bss_end+0xeb9c74>
 1d0:	0e6e0b39 	vmoveq.8	d14[5], r0
 1d4:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 1d8:	13011364 	movwne	r1, #4964	; 0x1364
 1dc:	2e130000 	cdpcs	0, 1, cr0, cr3, cr0, {0}
 1e0:	03193f01 	tsteq	r9, #1, 30
 1e4:	3b0b3a0e 	blcc	2cea24 <_bss_end+0x2c57dc>
 1e8:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 1ec:	3213490e 	andscc	r4, r3, #229376	; 0x38000
 1f0:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 1f4:	14000013 	strne	r0, [r0], #-19	; 0xffffffed
 1f8:	0b0b000f 	bleq	2c023c <_bss_end+0x2b6ff4>
 1fc:	00001349 	andeq	r1, r0, r9, asr #6
 200:	0b001015 	bleq	425c <CPSR_IRQ_INHIBIT+0x41dc>
 204:	0013490b 	andseq	r4, r3, fp, lsl #18
 208:	00341600 	eorseq	r1, r4, r0, lsl #12
 20c:	0b3a0e03 	bleq	e83a20 <_bss_end+0xe7a7d8>
 210:	0b390b3b 	bleq	e42f04 <_bss_end+0xe39cbc>
 214:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
 218:	0000193c 	andeq	r1, r0, ip, lsr r9
 21c:	47003417 	smladmi	r0, r7, r4, r3
 220:	3b0b3a13 	blcc	2cea74 <_bss_end+0x2c582c>
 224:	020b390b 	andeq	r3, fp, #180224	; 0x2c000
 228:	18000018 	stmdane	r0, {r3, r4}
 22c:	0e03002e 	cdpeq	0, 0, cr0, cr3, cr14, {1}
 230:	01111934 	tsteq	r1, r4, lsr r9
 234:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 238:	00194296 	mulseq	r9, r6, r2
 23c:	012e1900 			; <UNDEFINED> instruction: 0x012e1900
 240:	19340e03 	ldmdbne	r4!, {r0, r1, r9, sl, fp}
 244:	06120111 			; <UNDEFINED> instruction: 0x06120111
 248:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 24c:	00130119 	andseq	r0, r3, r9, lsl r1
 250:	00051a00 	andeq	r1, r5, r0, lsl #20
 254:	0b3a0e03 	bleq	e83a68 <_bss_end+0xe7a820>
 258:	0b390b3b 	bleq	e42f4c <_bss_end+0xe39d04>
 25c:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 260:	2e1b0000 	cdpcs	0, 1, cr0, cr11, cr0, {0}
 264:	3a134701 	bcc	4d1e70 <_bss_end+0x4c8c28>
 268:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 26c:	1113640b 	tstne	r3, fp, lsl #8
 270:	40061201 	andmi	r1, r6, r1, lsl #4
 274:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
 278:	00001301 	andeq	r1, r0, r1, lsl #6
 27c:	0300051c 	movweq	r0, #1308	; 0x51c
 280:	3413490e 	ldrcc	r4, [r3], #-2318	; 0xfffff6f2
 284:	00180219 	andseq	r0, r8, r9, lsl r2
 288:	00051d00 	andeq	r1, r5, r0, lsl #26
 28c:	0b3a0803 	bleq	e822a0 <_bss_end+0xe79058>
 290:	0b390b3b 	bleq	e42f84 <_bss_end+0xe39d3c>
 294:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 298:	341e0000 	ldrcc	r0, [lr], #-0
 29c:	3a080300 	bcc	200ea4 <_bss_end+0x1f7c5c>
 2a0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 2a4:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 2a8:	1f000018 	svcne	0x00000018
 2ac:	1347012e 	movtne	r0, #28974	; 0x712e
 2b0:	0b3b0b3a 	bleq	ec2fa0 <_bss_end+0xeb9d58>
 2b4:	13640b39 	cmnne	r4, #58368	; 0xe400
 2b8:	06120111 			; <UNDEFINED> instruction: 0x06120111
 2bc:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 2c0:	00130119 	andseq	r0, r3, r9, lsl r1
 2c4:	012e2000 			; <UNDEFINED> instruction: 0x012e2000
 2c8:	0b3a1347 	bleq	e84fec <_bss_end+0xe7bda4>
 2cc:	0b390b3b 	bleq	e42fc0 <_bss_end+0xe39d78>
 2d0:	0b201364 	bleq	805068 <_bss_end+0x7fbe20>
 2d4:	00001301 	andeq	r1, r0, r1, lsl #6
 2d8:	03000521 	movweq	r0, #1313	; 0x521
 2dc:	3413490e 	ldrcc	r4, [r3], #-2318	; 0xfffff6f2
 2e0:	22000019 	andcs	r0, r0, #25
 2e4:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
 2e8:	0b3b0b3a 	bleq	ec2fd8 <_bss_end+0xeb9d90>
 2ec:	13490b39 	movtne	r0, #39737	; 0x9b39
 2f0:	2e230000 	cdpcs	0, 2, cr0, cr3, cr0, {0}
 2f4:	6e133101 	mufvss	f3, f3, f1
 2f8:	1113640e 	tstne	r3, lr, lsl #8
 2fc:	40061201 	andmi	r1, r6, r1, lsl #4
 300:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 304:	05240000 	streq	r0, [r4, #-0]!
 308:	02133100 	andseq	r3, r3, #0, 2
 30c:	00000018 	andeq	r0, r0, r8, lsl r0
 310:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
 314:	030b130e 	movweq	r1, #45838	; 0xb30e
 318:	110e1b0e 	tstne	lr, lr, lsl #22
 31c:	10061201 	andne	r1, r6, r1, lsl #4
 320:	02000017 	andeq	r0, r0, #23
 324:	0b0b0024 	bleq	2c03bc <_bss_end+0x2b7174>
 328:	0e030b3e 	vmoveq.16	d3[0], r0
 32c:	24030000 	strcs	r0, [r3], #-0
 330:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 334:	0008030b 	andeq	r0, r8, fp, lsl #6
 338:	00160400 	andseq	r0, r6, r0, lsl #8
 33c:	0b3a0e03 	bleq	e83b50 <_bss_end+0xe7a908>
 340:	0b390b3b 	bleq	e43034 <_bss_end+0xe39dec>
 344:	00001349 	andeq	r1, r0, r9, asr #6
 348:	49002605 	stmdbmi	r0, {r0, r2, r9, sl, sp}
 34c:	06000013 			; <UNDEFINED> instruction: 0x06000013
 350:	13490035 	movtne	r0, #36917	; 0x9035
 354:	39070000 	stmdbcc	r7, {}	; <UNPREDICTABLE>
 358:	3a080301 	bcc	200f64 <_bss_end+0x1f7d1c>
 35c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 360:	0013010b 	andseq	r0, r3, fp, lsl #2
 364:	00340800 	eorseq	r0, r4, r0, lsl #16
 368:	0b3a0e03 	bleq	e83b7c <_bss_end+0xe7a934>
 36c:	0b390b3b 	bleq	e43060 <_bss_end+0xe39e18>
 370:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 374:	196c061c 	stmdbne	ip!, {r2, r3, r4, r9, sl}^
 378:	34090000 	strcc	r0, [r9], #-0
 37c:	3a0e0300 	bcc	380f84 <_bss_end+0x377d3c>
 380:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 384:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
 388:	6c0b1c19 	stcvs	12, cr1, [fp], {25}
 38c:	0a000019 	beq	3f8 <CPSR_IRQ_INHIBIT+0x378>
 390:	0e030104 	adfeqs	f0, f3, f4
 394:	0b3e196d 	bleq	f86950 <_bss_end+0xf7d708>
 398:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 39c:	0b3b0b3a 	bleq	ec308c <_bss_end+0xeb9e44>
 3a0:	00000b39 	andeq	r0, r0, r9, lsr fp
 3a4:	0300280b 	movweq	r2, #2059	; 0x80b
 3a8:	000b1c0e 	andeq	r1, fp, lr, lsl #24
 3ac:	00340c00 	eorseq	r0, r4, r0, lsl #24
 3b0:	00001347 	andeq	r1, r0, r7, asr #6
 3b4:	0301040d 	movweq	r0, #5133	; 0x140d
 3b8:	3e196d0e 	cdpcc	13, 1, cr6, cr9, cr14, {0}
 3bc:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
 3c0:	3b0b3a13 	blcc	2cec14 <_bss_end+0x2c59cc>
 3c4:	010b390b 	tsteq	fp, fp, lsl #18
 3c8:	0e000013 	mcreq	0, 0, r0, cr0, cr3, {0}
 3cc:	0e030102 	adfeqs	f0, f3, f2
 3d0:	0b3a0b0b 	bleq	e83004 <_bss_end+0xe79dbc>
 3d4:	0b390b3b 	bleq	e430c8 <_bss_end+0xe39e80>
 3d8:	00001301 	andeq	r1, r0, r1, lsl #6
 3dc:	03000d0f 	movweq	r0, #3343	; 0xd0f
 3e0:	3b0b3a0e 	blcc	2cec20 <_bss_end+0x2c59d8>
 3e4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 3e8:	000b3813 	andeq	r3, fp, r3, lsl r8
 3ec:	00161000 	andseq	r1, r6, r0
 3f0:	0b3a0e03 	bleq	e83c04 <_bss_end+0xe7a9bc>
 3f4:	0b390b3b 	bleq	e430e8 <_bss_end+0xe39ea0>
 3f8:	0b321349 	bleq	c85124 <_bss_end+0xc7bedc>
 3fc:	2e110000 	cdpcs	0, 1, cr0, cr1, cr0, {0}
 400:	03193f01 	tsteq	r9, #1, 30
 404:	3b0b3a0e 	blcc	2cec44 <_bss_end+0x2c59fc>
 408:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 40c:	3213490e 	andscc	r4, r3, #229376	; 0x38000
 410:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 414:	00130113 	andseq	r0, r3, r3, lsl r1
 418:	00051200 	andeq	r1, r5, r0, lsl #4
 41c:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
 420:	05130000 	ldreq	r0, [r3, #-0]
 424:	00134900 	andseq	r4, r3, r0, lsl #18
 428:	012e1400 			; <UNDEFINED> instruction: 0x012e1400
 42c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 430:	0b3b0b3a 	bleq	ec3120 <_bss_end+0xeb9ed8>
 434:	0e6e0b39 	vmoveq.8	d14[5], r0
 438:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 43c:	13011364 	movwne	r1, #4964	; 0x1364
 440:	2e150000 	cdpcs	0, 1, cr0, cr5, cr0, {0}
 444:	03193f01 	tsteq	r9, #1, 30
 448:	3b0b3a0e 	blcc	2cec88 <_bss_end+0x2c5a40>
 44c:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 450:	3213490e 	andscc	r4, r3, #229376	; 0x38000
 454:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 458:	16000013 			; <UNDEFINED> instruction: 0x16000013
 45c:	0b0b000f 	bleq	2c04a0 <_bss_end+0x2b7258>
 460:	00001349 	andeq	r1, r0, r9, asr #6
 464:	00001517 	andeq	r1, r0, r7, lsl r5
 468:	00101800 	andseq	r1, r0, r0, lsl #16
 46c:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 470:	34190000 	ldrcc	r0, [r9], #-0
 474:	3a0e0300 	bcc	38107c <_bss_end+0x377e34>
 478:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 47c:	3f13490b 	svccc	0x0013490b
 480:	00193c19 	andseq	r3, r9, r9, lsl ip
 484:	00341a00 	eorseq	r1, r4, r0, lsl #20
 488:	0b3a1347 	bleq	e851ac <_bss_end+0xe7bf64>
 48c:	0b390b3b 	bleq	e43180 <_bss_end+0xe39f38>
 490:	00001802 	andeq	r1, r0, r2, lsl #16
 494:	0301131b 	movweq	r1, #4891	; 0x131b
 498:	3a0b0b0e 	bcc	2c30d8 <_bss_end+0x2b9e90>
 49c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 4a0:	0013010b 	andseq	r0, r3, fp, lsl #2
 4a4:	000d1c00 	andeq	r1, sp, r0, lsl #24
 4a8:	0b3a0e03 	bleq	e83cbc <_bss_end+0xe7aa74>
 4ac:	0b390b3b 	bleq	e431a0 <_bss_end+0xe39f58>
 4b0:	0b0b1349 	bleq	2c51dc <_bss_end+0x2bbf94>
 4b4:	0b0c0b0d 	bleq	3030f0 <_bss_end+0x2f9ea8>
 4b8:	00000b38 	andeq	r0, r0, r8, lsr fp
 4bc:	03000d1d 	movweq	r0, #3357	; 0xd1d
 4c0:	3b0b3a0e 	blcc	2ced00 <_bss_end+0x2c5ab8>
 4c4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 4c8:	0d0b0b13 	vstreq	d0, [fp, #-76]	; 0xffffffb4
 4cc:	380d0c0b 	stmdacc	sp, {r0, r1, r3, sl, fp}
 4d0:	1e00000b 	cdpne	0, 0, cr0, cr0, cr11, {0}
 4d4:	0e03002e 	cdpeq	0, 0, cr0, cr3, cr14, {1}
 4d8:	01111934 	tsteq	r1, r4, lsr r9
 4dc:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 4e0:	00194296 	mulseq	r9, r6, r2
 4e4:	012e1f00 			; <UNDEFINED> instruction: 0x012e1f00
 4e8:	19340e03 	ldmdbne	r4!, {r0, r1, r9, sl, fp}
 4ec:	06120111 			; <UNDEFINED> instruction: 0x06120111
 4f0:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 4f4:	00130119 	andseq	r0, r3, r9, lsl r1
 4f8:	00052000 	andeq	r2, r5, r0
 4fc:	0b3a0e03 	bleq	e83d10 <_bss_end+0xe7aac8>
 500:	0b390b3b 	bleq	e431f4 <_bss_end+0xe39fac>
 504:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 508:	2e210000 	cdpcs	0, 2, cr0, cr1, cr0, {0}
 50c:	3a134701 	bcc	4d2118 <_bss_end+0x4c8ed0>
 510:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 514:	1113640b 	tstne	r3, fp, lsl #8
 518:	40061201 	andmi	r1, r6, r1, lsl #4
 51c:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
 520:	00001301 	andeq	r1, r0, r1, lsl #6
 524:	03000522 	movweq	r0, #1314	; 0x522
 528:	3413490e 	ldrcc	r4, [r3], #-2318	; 0xfffff6f2
 52c:	00180219 	andseq	r0, r8, r9, lsl r2
 530:	00342300 	eorseq	r2, r4, r0, lsl #6
 534:	0b3a0803 	bleq	e82548 <_bss_end+0xe79300>
 538:	0b390b3b 	bleq	e4322c <_bss_end+0xe39fe4>
 53c:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 540:	2e240000 	cdpcs	0, 2, cr0, cr4, cr0, {0}
 544:	3a134701 	bcc	4d2150 <_bss_end+0x4c8f08>
 548:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 54c:	1113640b 	tstne	r3, fp, lsl #8
 550:	40061201 	andmi	r1, r6, r1, lsl #4
 554:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 558:	00001301 	andeq	r1, r0, r1, lsl #6
 55c:	03000525 	movweq	r0, #1317	; 0x525
 560:	3b0b3a08 	blcc	2ced88 <_bss_end+0x2c5b40>
 564:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 568:	00180213 	andseq	r0, r8, r3, lsl r2
 56c:	012e2600 			; <UNDEFINED> instruction: 0x012e2600
 570:	0b3a1347 	bleq	e85294 <_bss_end+0xe7c04c>
 574:	0b390b3b 	bleq	e43268 <_bss_end+0xe3a020>
 578:	0b201364 	bleq	805310 <_bss_end+0x7fc0c8>
 57c:	00001301 	andeq	r1, r0, r1, lsl #6
 580:	03000527 	movweq	r0, #1319	; 0x527
 584:	3413490e 	ldrcc	r4, [r3], #-2318	; 0xfffff6f2
 588:	28000019 	stmdacs	r0, {r0, r3, r4}
 58c:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
 590:	0b3b0b3a 	bleq	ec3280 <_bss_end+0xeba038>
 594:	13490b39 	movtne	r0, #39737	; 0x9b39
 598:	2e290000 	cdpcs	0, 2, cr0, cr9, cr0, {0}
 59c:	6e133101 	mufvss	f3, f3, f1
 5a0:	1113640e 	tstne	r3, lr, lsl #8
 5a4:	40061201 	andmi	r1, r6, r1, lsl #4
 5a8:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 5ac:	052a0000 	streq	r0, [sl, #-0]!
 5b0:	02133100 	andseq	r3, r3, #0, 2
 5b4:	00000018 	andeq	r0, r0, r8, lsl r0
 5b8:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
 5bc:	030b130e 	movweq	r1, #45838	; 0xb30e
 5c0:	110e1b0e 	tstne	lr, lr, lsl #22
 5c4:	10061201 	andne	r1, r6, r1, lsl #4
 5c8:	02000017 	andeq	r0, r0, #23
 5cc:	0b0b0024 	bleq	2c0664 <_bss_end+0x2b741c>
 5d0:	0e030b3e 	vmoveq.16	d3[0], r0
 5d4:	24030000 	strcs	r0, [r3], #-0
 5d8:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 5dc:	0008030b 	andeq	r0, r8, fp, lsl #6
 5e0:	00160400 	andseq	r0, r6, r0, lsl #8
 5e4:	0b3a0e03 	bleq	e83df8 <_bss_end+0xe7abb0>
 5e8:	0b390b3b 	bleq	e432dc <_bss_end+0xe3a094>
 5ec:	00001349 	andeq	r1, r0, r9, asr #6
 5f0:	49002605 	stmdbmi	r0, {r0, r2, r9, sl, sp}
 5f4:	06000013 			; <UNDEFINED> instruction: 0x06000013
 5f8:	13490035 	movtne	r0, #36917	; 0x9035
 5fc:	39070000 	stmdbcc	r7, {}	; <UNPREDICTABLE>
 600:	3a080301 	bcc	20120c <_bss_end+0x1f7fc4>
 604:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 608:	0013010b 	andseq	r0, r3, fp, lsl #2
 60c:	00340800 	eorseq	r0, r4, r0, lsl #16
 610:	0b3a0e03 	bleq	e83e24 <_bss_end+0xe7abdc>
 614:	0b390b3b 	bleq	e43308 <_bss_end+0xe3a0c0>
 618:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 61c:	196c061c 	stmdbne	ip!, {r2, r3, r4, r9, sl}^
 620:	34090000 	strcc	r0, [r9], #-0
 624:	3a0e0300 	bcc	38122c <_bss_end+0x377fe4>
 628:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 62c:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
 630:	6c0b1c19 	stcvs	12, cr1, [fp], {25}
 634:	0a000019 	beq	6a0 <CPSR_IRQ_INHIBIT+0x620>
 638:	0e030104 	adfeqs	f0, f3, f4
 63c:	0b3e196d 	bleq	f86bf8 <_bss_end+0xf7d9b0>
 640:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 644:	0b3b0b3a 	bleq	ec3334 <_bss_end+0xeba0ec>
 648:	13010b39 	movwne	r0, #6969	; 0x1b39
 64c:	280b0000 	stmdacs	fp, {}	; <UNPREDICTABLE>
 650:	1c0e0300 	stcne	3, cr0, [lr], {-0}
 654:	0c00000b 	stceq	0, cr0, [r0], {11}
 658:	08030028 	stmdaeq	r3, {r3, r5}
 65c:	00000b1c 	andeq	r0, r0, ip, lsl fp
 660:	0301040d 	movweq	r0, #5133	; 0x140d
 664:	3e196d0e 	cdpcc	13, 1, cr6, cr9, cr14, {0}
 668:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
 66c:	3b0b3a13 	blcc	2ceec0 <_bss_end+0x2c5c78>
 670:	000b390b 	andeq	r3, fp, fp, lsl #18
 674:	00340e00 	eorseq	r0, r4, r0, lsl #28
 678:	00001347 	andeq	r1, r0, r7, asr #6
 67c:	0301020f 	movweq	r0, #4623	; 0x120f
 680:	3a0b0b0e 	bcc	2c32c0 <_bss_end+0x2ba078>
 684:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 688:	0013010b 	andseq	r0, r3, fp, lsl #2
 68c:	000d1000 	andeq	r1, sp, r0
 690:	0b3a0e03 	bleq	e83ea4 <_bss_end+0xe7ac5c>
 694:	0b390b3b 	bleq	e43388 <_bss_end+0xe3a140>
 698:	0b381349 	bleq	e053c4 <_bss_end+0xdfc17c>
 69c:	2e110000 	cdpcs	0, 1, cr0, cr1, cr0, {0}
 6a0:	03193f01 	tsteq	r9, #1, 30
 6a4:	3b0b3a0e 	blcc	2ceee4 <_bss_end+0x2c5c9c>
 6a8:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 6ac:	3213490e 	andscc	r4, r3, #229376	; 0x38000
 6b0:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 6b4:	00130113 	andseq	r0, r3, r3, lsl r1
 6b8:	00051200 	andeq	r1, r5, r0, lsl #4
 6bc:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
 6c0:	05130000 	ldreq	r0, [r3, #-0]
 6c4:	00134900 	andseq	r4, r3, r0, lsl #18
 6c8:	012e1400 			; <UNDEFINED> instruction: 0x012e1400
 6cc:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 6d0:	0b3b0b3a 	bleq	ec33c0 <_bss_end+0xeba178>
 6d4:	0e6e0b39 	vmoveq.8	d14[5], r0
 6d8:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 6dc:	13011364 	movwne	r1, #4964	; 0x1364
 6e0:	2e150000 	cdpcs	0, 1, cr0, cr5, cr0, {0}
 6e4:	03193f01 	tsteq	r9, #1, 30
 6e8:	3b0b3a0e 	blcc	2cef28 <_bss_end+0x2c5ce0>
 6ec:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 6f0:	3213490e 	andscc	r4, r3, #229376	; 0x38000
 6f4:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 6f8:	16000013 			; <UNDEFINED> instruction: 0x16000013
 6fc:	0b0b000f 	bleq	2c0740 <_bss_end+0x2b74f8>
 700:	00001349 	andeq	r1, r0, r9, asr #6
 704:	0b001017 	bleq	4768 <CPSR_IRQ_INHIBIT+0x46e8>
 708:	0013490b 	andseq	r4, r3, fp, lsl #18
 70c:	00341800 	eorseq	r1, r4, r0, lsl #16
 710:	0b3a0e03 	bleq	e83f24 <_bss_end+0xe7acdc>
 714:	0b390b3b 	bleq	e43408 <_bss_end+0xe3a1c0>
 718:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
 71c:	0000193c 	andeq	r1, r0, ip, lsr r9
 720:	3f012e19 	svccc	0x00012e19
 724:	3a0e0319 	bcc	381390 <_bss_end+0x378148>
 728:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 72c:	320e6e0b 	andcc	r6, lr, #11, 28	; 0xb0
 730:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 734:	1a000013 	bne	788 <CPSR_IRQ_INHIBIT+0x708>
 738:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
 73c:	0b3b0b3a 	bleq	ec342c <_bss_end+0xeba1e4>
 740:	13490b39 	movtne	r0, #39737	; 0x9b39
 744:	00000b32 	andeq	r0, r0, r2, lsr fp
 748:	0000151b 	andeq	r1, r0, fp, lsl r5
 74c:	00341c00 	eorseq	r1, r4, r0, lsl #24
 750:	0b3a1347 	bleq	e85474 <_bss_end+0xe7c22c>
 754:	0b390b3b 	bleq	e43448 <_bss_end+0xe3a200>
 758:	00001802 	andeq	r1, r0, r2, lsl #16
 75c:	03002e1d 	movweq	r2, #3613	; 0xe1d
 760:	1119340e 	tstne	r9, lr, lsl #8
 764:	40061201 	andmi	r1, r6, r1, lsl #4
 768:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
 76c:	2e1e0000 	cdpcs	0, 1, cr0, cr14, cr0, {0}
 770:	340e0301 	strcc	r0, [lr], #-769	; 0xfffffcff
 774:	12011119 	andne	r1, r1, #1073741830	; 0x40000006
 778:	96184006 	ldrls	r4, [r8], -r6
 77c:	13011942 	movwne	r1, #6466	; 0x1942
 780:	051f0000 	ldreq	r0, [pc, #-0]	; 788 <CPSR_IRQ_INHIBIT+0x708>
 784:	3a0e0300 	bcc	38138c <_bss_end+0x378144>
 788:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 78c:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 790:	20000018 	andcs	r0, r0, r8, lsl r0
 794:	1347012e 	movtne	r0, #28974	; 0x712e
 798:	0b3b0b3a 	bleq	ec3488 <_bss_end+0xeba240>
 79c:	13640b39 	cmnne	r4, #58368	; 0xe400
 7a0:	06120111 			; <UNDEFINED> instruction: 0x06120111
 7a4:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 7a8:	00130119 	andseq	r0, r3, r9, lsl r1
 7ac:	00052100 	andeq	r2, r5, r0, lsl #2
 7b0:	13490e03 	movtne	r0, #40451	; 0x9e03
 7b4:	18021934 	stmdane	r2, {r2, r4, r5, r8, fp, ip}
 7b8:	34220000 	strtcc	r0, [r2], #-0
 7bc:	3a0e0300 	bcc	3813c4 <_bss_end+0x37817c>
 7c0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 7c4:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 7c8:	23000018 	movwcs	r0, #24
 7cc:	1347012e 	movtne	r0, #28974	; 0x712e
 7d0:	0b3b0b3a 	bleq	ec34c0 <_bss_end+0xeba278>
 7d4:	13640b39 	cmnne	r4, #58368	; 0xe400
 7d8:	06120111 			; <UNDEFINED> instruction: 0x06120111
 7dc:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 7e0:	00130119 	andseq	r0, r3, r9, lsl r1
 7e4:	00052400 	andeq	r2, r5, r0, lsl #8
 7e8:	0b3a0803 	bleq	e827fc <_bss_end+0xe795b4>
 7ec:	0b390b3b 	bleq	e434e0 <_bss_end+0xe3a298>
 7f0:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 7f4:	2e250000 	cdpcs	0, 2, cr0, cr5, cr0, {0}
 7f8:	3a134701 	bcc	4d2404 <_bss_end+0x4c91bc>
 7fc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 800:	2013640b 	andscs	r6, r3, fp, lsl #8
 804:	0013010b 	andseq	r0, r3, fp, lsl #2
 808:	00052600 	andeq	r2, r5, r0, lsl #12
 80c:	13490e03 	movtne	r0, #40451	; 0x9e03
 810:	00001934 	andeq	r1, r0, r4, lsr r9
 814:	03000527 	movweq	r0, #1319	; 0x527
 818:	3b0b3a0e 	blcc	2cf058 <_bss_end+0x2c5e10>
 81c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 820:	28000013 	stmdacs	r0, {r0, r1, r4}
 824:	1331012e 	teqne	r1, #-2147483637	; 0x8000000b
 828:	13640e6e 	cmnne	r4, #1760	; 0x6e0
 82c:	06120111 			; <UNDEFINED> instruction: 0x06120111
 830:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 834:	00130119 	andseq	r0, r3, r9, lsl r1
 838:	00052900 	andeq	r2, r5, r0, lsl #18
 83c:	18021331 	stmdane	r2, {r0, r4, r5, r8, r9, ip}
 840:	2e2a0000 	cdpcs	0, 2, cr0, cr10, cr0, {0}
 844:	03193f00 	tsteq	r9, #0, 30
 848:	3b0b3a0e 	blcc	2cf088 <_bss_end+0x2c5e40>
 84c:	110b390b 	tstne	fp, fp, lsl #18
 850:	40061201 	andmi	r1, r6, r1, lsl #4
 854:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 858:	2e2b0000 	cdpcs	0, 2, cr0, cr11, cr0, {0}
 85c:	03193f00 	tsteq	r9, #0, 30
 860:	3b0b3a0e 	blcc	2cf0a0 <_bss_end+0x2c5e58>
 864:	110b390b 	tstne	fp, fp, lsl #18
 868:	40061201 	andmi	r1, r6, r1, lsl #4
 86c:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
 870:	01000000 	mrseq	r0, (UNDEF: 0)
 874:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
 878:	0e030b13 	vmoveq.32	d3[0], r0
 87c:	01110e1b 	tsteq	r1, fp, lsl lr
 880:	17100612 			; <UNDEFINED> instruction: 0x17100612
 884:	24020000 	strcs	r0, [r2], #-0
 888:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 88c:	000e030b 	andeq	r0, lr, fp, lsl #6
 890:	00240300 	eoreq	r0, r4, r0, lsl #6
 894:	0b3e0b0b 	bleq	f834c8 <_bss_end+0xf7a280>
 898:	00000803 	andeq	r0, r0, r3, lsl #16
 89c:	49003504 	stmdbmi	r0, {r2, r8, sl, ip, sp}
 8a0:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
 8a4:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
 8a8:	0b3b0b3a 	bleq	ec3598 <_bss_end+0xeba350>
 8ac:	13490b39 	movtne	r0, #39737	; 0x9b39
 8b0:	26060000 	strcs	r0, [r6], -r0
 8b4:	00134900 	andseq	r4, r3, r0, lsl #18
 8b8:	01040700 	tsteq	r4, r0, lsl #14
 8bc:	196d0e03 	stmdbne	sp!, {r0, r1, r9, sl, fp}^
 8c0:	0b0b0b3e 	bleq	2c35c0 <_bss_end+0x2ba378>
 8c4:	0b3a1349 	bleq	e855f0 <_bss_end+0xe7c3a8>
 8c8:	0b390b3b 	bleq	e435bc <_bss_end+0xe3a374>
 8cc:	00001301 	andeq	r1, r0, r1, lsl #6
 8d0:	03002808 	movweq	r2, #2056	; 0x808
 8d4:	000b1c0e 	andeq	r1, fp, lr, lsl #24
 8d8:	00280900 	eoreq	r0, r8, r0, lsl #18
 8dc:	0b1c0803 	bleq	7028f0 <_bss_end+0x6f96a8>
 8e0:	020a0000 	andeq	r0, sl, #0
 8e4:	0b0e0301 	bleq	3814f0 <_bss_end+0x3782a8>
 8e8:	3b0b3a0b 	blcc	2cf11c <_bss_end+0x2c5ed4>
 8ec:	010b390b 	tsteq	fp, fp, lsl #18
 8f0:	0b000013 	bleq	944 <CPSR_IRQ_INHIBIT+0x8c4>
 8f4:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 8f8:	0b3b0b3a 	bleq	ec35e8 <_bss_end+0xeba3a0>
 8fc:	13490b39 	movtne	r0, #39737	; 0x9b39
 900:	00000b38 	andeq	r0, r0, r8, lsr fp
 904:	3f012e0c 	svccc	0x00012e0c
 908:	3a0e0319 	bcc	381574 <_bss_end+0x37832c>
 90c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 910:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 914:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
 918:	01136419 	tsteq	r3, r9, lsl r4
 91c:	0d000013 	stceq	0, cr0, [r0, #-76]	; 0xffffffb4
 920:	13490005 	movtne	r0, #36869	; 0x9005
 924:	00001934 	andeq	r1, r0, r4, lsr r9
 928:	4900050e 	stmdbmi	r0, {r1, r2, r3, r8, sl}
 92c:	0f000013 	svceq	0x00000013
 930:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 934:	0b3a0e03 	bleq	e84148 <_bss_end+0xe7af00>
 938:	0b390b3b 	bleq	e4362c <_bss_end+0xe3a3e4>
 93c:	0b320e6e 	bleq	c842fc <_bss_end+0xc7b0b4>
 940:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 944:	00001301 	andeq	r1, r0, r1, lsl #6
 948:	3f012e10 	svccc	0x00012e10
 94c:	3a0e0319 	bcc	3815b8 <_bss_end+0x378370>
 950:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 954:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 958:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
 95c:	00136419 	andseq	r6, r3, r9, lsl r4
 960:	000f1100 	andeq	r1, pc, r0, lsl #2
 964:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 968:	10120000 	andsne	r0, r2, r0
 96c:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 970:	13000013 	movwne	r0, #19
 974:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 978:	0b3b0b3a 	bleq	ec3668 <_bss_end+0xeba420>
 97c:	13490b39 	movtne	r0, #39737	; 0x9b39
 980:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
 984:	39140000 	ldmdbcc	r4, {}	; <UNPREDICTABLE>
 988:	3a080301 	bcc	201594 <_bss_end+0x1f834c>
 98c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 990:	0013010b 	andseq	r0, r3, fp, lsl #2
 994:	00341500 	eorseq	r1, r4, r0, lsl #10
 998:	0b3a0e03 	bleq	e841ac <_bss_end+0xe7af64>
 99c:	0b390b3b 	bleq	e43690 <_bss_end+0xe3a448>
 9a0:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 9a4:	196c061c 	stmdbne	ip!, {r2, r3, r4, r9, sl}^
 9a8:	34160000 	ldrcc	r0, [r6], #-0
 9ac:	3a0e0300 	bcc	3815b4 <_bss_end+0x37836c>
 9b0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 9b4:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
 9b8:	6c0b1c19 	stcvs	12, cr1, [fp], {25}
 9bc:	17000019 	smladne	r0, r9, r0, r0
 9c0:	0e030104 	adfeqs	f0, f3, f4
 9c4:	0b3e196d 	bleq	f86f80 <_bss_end+0xf7dd38>
 9c8:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 9cc:	0b3b0b3a 	bleq	ec36bc <_bss_end+0xeba474>
 9d0:	00000b39 	andeq	r0, r0, r9, lsr fp
 9d4:	47003418 	smladmi	r0, r8, r4, r3
 9d8:	19000013 	stmdbne	r0, {r0, r1, r4}
 9dc:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 9e0:	0b3a0e03 	bleq	e841f4 <_bss_end+0xe7afac>
 9e4:	0b390b3b 	bleq	e436d8 <_bss_end+0xe3a490>
 9e8:	0b320e6e 	bleq	c843a8 <_bss_end+0xc7b160>
 9ec:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 9f0:	161a0000 	ldrne	r0, [sl], -r0
 9f4:	3a0e0300 	bcc	3815fc <_bss_end+0x3783b4>
 9f8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 9fc:	3213490b 	andscc	r4, r3, #180224	; 0x2c000
 a00:	1b00000b 	blne	a34 <CPSR_IRQ_INHIBIT+0x9b4>
 a04:	00000015 	andeq	r0, r0, r5, lsl r0
 a08:	0300341c 	movweq	r3, #1052	; 0x41c
 a0c:	3b0b3a0e 	blcc	2cf24c <_bss_end+0x2c6004>
 a10:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 a14:	02193f13 	andseq	r3, r9, #19, 30	; 0x4c
 a18:	1d000018 	stcne	0, cr0, [r0, #-96]	; 0xffffffa0
 a1c:	193f002e 	ldmdbne	pc!, {r1, r2, r3, r5}	; <UNPREDICTABLE>
 a20:	0b3a0e03 	bleq	e84234 <_bss_end+0xe7afec>
 a24:	0b390b3b 	bleq	e43718 <_bss_end+0xe3a4d0>
 a28:	01111349 	tsteq	r1, r9, asr #6
 a2c:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 a30:	00194296 	mulseq	r9, r6, r2
 a34:	002e1e00 	eoreq	r1, lr, r0, lsl #28
 a38:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 a3c:	0b3b0b3a 	bleq	ec372c <_bss_end+0xeba4e4>
 a40:	01110b39 	tsteq	r1, r9, lsr fp
 a44:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 a48:	00194296 	mulseq	r9, r6, r2
 a4c:	11010000 	mrsne	r0, (UNDEF: 1)
 a50:	55061000 	strpl	r1, [r6, #-0]
 a54:	1b0e0306 	blne	381674 <_bss_end+0x37842c>
 a58:	130e250e 	movwne	r2, #58638	; 0xe50e
 a5c:	00000005 	andeq	r0, r0, r5
 a60:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
 a64:	030b130e 	movweq	r1, #45838	; 0xb30e
 a68:	110e1b0e 	tstne	lr, lr, lsl #22
 a6c:	10061201 	andne	r1, r6, r1, lsl #4
 a70:	02000017 	andeq	r0, r0, #23
 a74:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
 a78:	0b3b0b3a 	bleq	ec3768 <_bss_end+0xeba520>
 a7c:	13490b39 	movtne	r0, #39737	; 0x9b39
 a80:	0f030000 	svceq	0x00030000
 a84:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 a88:	04000013 	streq	r0, [r0], #-19	; 0xffffffed
 a8c:	00000015 	andeq	r0, r0, r5, lsl r0
 a90:	03003405 	movweq	r3, #1029	; 0x405
 a94:	3b0b3a0e 	blcc	2cf2d4 <_bss_end+0x2c608c>
 a98:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 a9c:	3c193f13 	ldccc	15, cr3, [r9], {19}
 aa0:	06000019 			; <UNDEFINED> instruction: 0x06000019
 aa4:	0b0b0024 	bleq	2c0b3c <_bss_end+0x2b78f4>
 aa8:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
 aac:	01070000 	mrseq	r0, (UNDEF: 7)
 ab0:	01134901 	tsteq	r3, r1, lsl #18
 ab4:	08000013 	stmdaeq	r0, {r0, r1, r4}
 ab8:	13490021 	movtne	r0, #36897	; 0x9021
 abc:	0000062f 	andeq	r0, r0, pc, lsr #12
 ac0:	0b002409 	bleq	9aec <_bss_end+0x8a4>
 ac4:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 ac8:	0a00000e 	beq	b08 <CPSR_IRQ_INHIBIT+0xa88>
 acc:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 ad0:	0b3a0e03 	bleq	e842e4 <_bss_end+0xe7b09c>
 ad4:	0b390b3b 	bleq	e437c8 <_bss_end+0xe3a580>
 ad8:	01111349 	tsteq	r1, r9, asr #6
 adc:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 ae0:	01194296 			; <UNDEFINED> instruction: 0x01194296
 ae4:	0b000013 	bleq	b38 <CPSR_IRQ_INHIBIT+0xab8>
 ae8:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 aec:	0b3b0b3a 	bleq	ec37dc <_bss_end+0xeba594>
 af0:	13490b39 	movtne	r0, #39737	; 0x9b39
 af4:	00001802 	andeq	r1, r0, r2, lsl #16
 af8:	3f012e0c 	svccc	0x00012e0c
 afc:	3a0e0319 	bcc	381768 <_bss_end+0x378520>
 b00:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 b04:	1113490b 	tstne	r3, fp, lsl #18
 b08:	40061201 	andmi	r1, r6, r1, lsl #4
 b0c:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 b10:	00001301 	andeq	r1, r0, r1, lsl #6
 b14:	0300340d 	movweq	r3, #1037	; 0x40d
 b18:	3b0b3a08 	blcc	2cf340 <_bss_end+0x2c60f8>
 b1c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 b20:	00180213 	andseq	r0, r8, r3, lsl r2
 b24:	11010000 	mrsne	r0, (UNDEF: 1)
 b28:	130e2501 	movwne	r2, #58625	; 0xe501
 b2c:	1b0e030b 	blne	381760 <_bss_end+0x378518>
 b30:	0017100e 	andseq	r1, r7, lr
 b34:	00240200 	eoreq	r0, r4, r0, lsl #4
 b38:	0b3e0b0b 	bleq	f8376c <_bss_end+0xf7a524>
 b3c:	00000803 	andeq	r0, r0, r3, lsl #16
 b40:	0b002403 	bleq	9b54 <_bss_end+0x90c>
 b44:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 b48:	0400000e 	streq	r0, [r0], #-14
 b4c:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
 b50:	0b3b0b3a 	bleq	ec3840 <_bss_end+0xeba5f8>
 b54:	13490b39 	movtne	r0, #39737	; 0x9b39
 b58:	0f050000 	svceq	0x00050000
 b5c:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 b60:	06000013 			; <UNDEFINED> instruction: 0x06000013
 b64:	19270115 	stmdbne	r7!, {r0, r2, r4, r8}
 b68:	13011349 	movwne	r1, #4937	; 0x1349
 b6c:	05070000 	streq	r0, [r7, #-0]
 b70:	00134900 	andseq	r4, r3, r0, lsl #18
 b74:	00260800 	eoreq	r0, r6, r0, lsl #16
 b78:	34090000 	strcc	r0, [r9], #-0
 b7c:	3a0e0300 	bcc	381784 <_bss_end+0x37853c>
 b80:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 b84:	3f13490b 	svccc	0x0013490b
 b88:	00193c19 	andseq	r3, r9, r9, lsl ip
 b8c:	01040a00 	tsteq	r4, r0, lsl #20
 b90:	0b3e0e03 	bleq	f843a4 <_bss_end+0xf7b15c>
 b94:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 b98:	0b3b0b3a 	bleq	ec3888 <_bss_end+0xeba640>
 b9c:	13010b39 	movwne	r0, #6969	; 0x1b39
 ba0:	280b0000 	stmdacs	fp, {}	; <UNPREDICTABLE>
 ba4:	1c0e0300 	stcne	3, cr0, [lr], {-0}
 ba8:	0c00000b 	stceq	0, cr0, [r0], {11}
 bac:	13490101 	movtne	r0, #37121	; 0x9101
 bb0:	00001301 	andeq	r1, r0, r1, lsl #6
 bb4:	0000210d 	andeq	r2, r0, sp, lsl #2
 bb8:	00260e00 	eoreq	r0, r6, r0, lsl #28
 bbc:	00001349 	andeq	r1, r0, r9, asr #6
 bc0:	0300340f 	movweq	r3, #1039	; 0x40f
 bc4:	3b0b3a0e 	blcc	2cf404 <_bss_end+0x2c61bc>
 bc8:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
 bcc:	3c193f13 	ldccc	15, cr3, [r9], {19}
 bd0:	10000019 	andne	r0, r0, r9, lsl r0
 bd4:	0e030013 	mcreq	0, 0, r0, cr3, cr3, {0}
 bd8:	0000193c 	andeq	r1, r0, ip, lsr r9
 bdc:	27001511 	smladcs	r0, r1, r5, r1
 be0:	12000019 	andne	r0, r0, #25
 be4:	0e030017 	mcreq	0, 0, r0, cr3, cr7, {0}
 be8:	0000193c 	andeq	r1, r0, ip, lsr r9
 bec:	03011313 	movweq	r1, #4883	; 0x1313
 bf0:	3a0b0b0e 	bcc	2c3830 <_bss_end+0x2ba5e8>
 bf4:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 bf8:	0013010b 	andseq	r0, r3, fp, lsl #2
 bfc:	000d1400 	andeq	r1, sp, r0, lsl #8
 c00:	0b3a0e03 	bleq	e84414 <_bss_end+0xe7b1cc>
 c04:	0b39053b 	bleq	e420f8 <_bss_end+0xe38eb0>
 c08:	0b381349 	bleq	e05934 <_bss_end+0xdfc6ec>
 c0c:	21150000 	tstcs	r5, r0
 c10:	2f134900 	svccs	0x00134900
 c14:	1600000b 	strne	r0, [r0], -fp
 c18:	0e030104 	adfeqs	f0, f3, f4
 c1c:	0b0b0b3e 	bleq	2c391c <_bss_end+0x2ba6d4>
 c20:	0b3a1349 	bleq	e8594c <_bss_end+0xe7c704>
 c24:	0b39053b 	bleq	e42118 <_bss_end+0xe38ed0>
 c28:	00001301 	andeq	r1, r0, r1, lsl #6
 c2c:	47003417 	smladmi	r0, r7, r4, r3
 c30:	3b0b3a13 	blcc	2cf484 <_bss_end+0x2c623c>
 c34:	020b3905 	andeq	r3, fp, #81920	; 0x14000
 c38:	00000018 	andeq	r0, r0, r8, lsl r0

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
  34:	0000083c 	andeq	r0, r0, ip, lsr r8
	...
  40:	0000001c 	andeq	r0, r0, ip, lsl r0
  44:	0acd0002 	beq	ff340054 <_bss_end+0xff336e0c>
  48:	00040000 	andeq	r0, r4, r0
  4c:	00000000 	andeq	r0, r0, r0
  50:	000089a8 	andeq	r8, r0, r8, lsr #19
  54:	00000278 	andeq	r0, r0, r8, ror r2
	...
  60:	0000001c 	andeq	r0, r0, ip, lsl r0
  64:	10200002 	eorne	r0, r0, r2
  68:	00040000 	andeq	r0, r4, r0
  6c:	00000000 	andeq	r0, r0, r0
  70:	00008c20 	andeq	r8, r0, r0, lsr #24
  74:	00000294 	muleq	r0, r4, r2
	...
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	19890002 	stmibne	r9, {r1}
  88:	00040000 	andeq	r0, r4, r0
  8c:	00000000 	andeq	r0, r0, r0
  90:	00008eb4 			; <UNDEFINED> instruction: 0x00008eb4
  94:	0000011c 	andeq	r0, r0, ip, lsl r1
	...
  a0:	00000024 	andeq	r0, r0, r4, lsr #32
  a4:	21280002 			; <UNDEFINED> instruction: 0x21280002
  a8:	00040000 	andeq	r0, r4, r0
  ac:	00000000 	andeq	r0, r0, r0
  b0:	00008000 	andeq	r8, r0, r0
  b4:	00000094 	muleq	r0, r4, r0
  b8:	00008fd0 	ldrdeq	r8, [r0], -r0
  bc:	00000020 	andeq	r0, r0, r0, lsr #32
	...
  c8:	0000001c 	andeq	r0, r0, ip, lsl r0
  cc:	214a0002 	cmpcs	sl, r2
  d0:	00040000 	andeq	r0, r4, r0
  d4:	00000000 	andeq	r0, r0, r0
  d8:	00008ff0 	strdeq	r8, [r0], -r0
  dc:	00000118 	andeq	r0, r0, r8, lsl r1
	...
  e8:	00000014 	andeq	r0, r0, r4, lsl r0
  ec:	22990002 	addscs	r0, r9, #2
  f0:	00040000 	andeq	r0, r4, r0
	...

Disassembly of section .debug_line:

00000000 <.debug_line>:
   0:	000000ae 	andeq	r0, r0, lr, lsr #1
   4:	00750003 	rsbseq	r0, r5, r3
   8:	01020000 	mrseq	r0, (UNDEF: 2)
   c:	000d0efb 	strdeq	r0, [sp], -fp
  10:	01010101 	tsteq	r1, r1, lsl #2
  14:	01000000 	mrseq	r0, (UNDEF: 0)
  18:	2f010000 	svccs	0x00010000
  1c:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
  20:	6c69732f 	stclvs	3, cr7, [r9], #-188	; 0xffffff44
  24:	79766168 	ldmdbvc	r6!, {r3, r5, r6, r8, sp, lr}^
  28:	63532f6a 	cmpvs	r3, #424	; 0x1a8
  2c:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; fffffe94 <_bss_end+0xffff6c4c>
  30:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
  34:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
  38:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
  3c:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
  40:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
  44:	69742d31 	ldmdbvs	r4!, {r0, r4, r5, r8, sl, fp, sp}^
  48:	5f72656d 	svcpl	0x0072656d
  4c:	635f6f6e 	cmpvs	pc, #440	; 0x1b8
  50:	7261656c 	rsbvc	r6, r1, #108, 10	; 0x1b000000
  54:	5152495f 	cmppl	r2, pc, asr r9
  58:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
  5c:	2f6c656e 	svccs	0x006c656e
  60:	00637273 	rsbeq	r7, r3, r3, ror r2
  64:	78786300 	ldmdavc	r8!, {r8, r9, sp, lr}^
  68:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
  6c:	00000100 	andeq	r0, r0, r0, lsl #2
  70:	6975623c 	ldmdbvs	r5!, {r2, r3, r4, r5, r9, sp, lr}^
  74:	692d746c 	pushvs	{r2, r3, r5, r6, sl, ip, sp, lr}
  78:	00003e6e 	andeq	r3, r0, lr, ror #28
  7c:	05000000 	streq	r0, [r0, #-0]
  80:	02050005 	andeq	r0, r5, #5
  84:	00008094 	muleq	r0, r4, r0
  88:	05010a03 	streq	r0, [r1, #-2563]	; 0xfffff5fd
  8c:	10058311 	andne	r8, r5, r1, lsl r3
  90:	8305054a 	movwhi	r0, #21834	; 0x554a
  94:	83130585 	tsthi	r3, #557842432	; 0x21400000
  98:	85670505 	strbhi	r0, [r7, #-1285]!	; 0xfffffafb
  9c:	86010583 	strhi	r0, [r1], -r3, lsl #11
  a0:	854c854c 	strbhi	r8, [ip, #-1356]	; 0xfffffab4
  a4:	0505854c 	streq	r8, [r5, #-1356]	; 0xfffffab4
  a8:	01040200 	mrseq	r0, R12_usr
  ac:	0002024b 	andeq	r0, r2, fp, asr #4
  b0:	042b0101 	strteq	r0, [fp], #-257	; 0xfffffeff
  b4:	00030000 	andeq	r0, r3, r0
  b8:	00000148 	andeq	r0, r0, r8, asr #2
  bc:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
  c0:	0101000d 	tsteq	r1, sp
  c4:	00000101 	andeq	r0, r0, r1, lsl #2
  c8:	00000100 	andeq	r0, r0, r0, lsl #2
  cc:	6f682f01 	svcvs	0x00682f01
  d0:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
  d4:	61686c69 	cmnvs	r8, r9, ror #24
  d8:	2f6a7976 	svccs	0x006a7976
  dc:	6f686353 	svcvs	0x00686353
  e0:	5a2f6c6f 	bpl	bdb2a4 <_bss_end+0xbd205c>
  e4:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; ffffff58 <_bss_end+0xffff6d10>
  e8:	2f657461 	svccs	0x00657461
  ec:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
  f0:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
  f4:	2d31312f 	ldfcss	f3, [r1, #-188]!	; 0xffffff44
  f8:	656d6974 	strbvs	r6, [sp, #-2420]!	; 0xfffff68c
  fc:	6f6e5f72 	svcvs	0x006e5f72
 100:	656c635f 	strbvs	r6, [ip, #-863]!	; 0xfffffca1
 104:	495f7261 	ldmdbmi	pc, {r0, r5, r6, r9, ip, sp, lr}^	; <UNPREDICTABLE>
 108:	6b2f5152 	blvs	bd4658 <_bss_end+0xbcb410>
 10c:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 110:	72732f6c 	rsbsvc	r2, r3, #108, 30	; 0x1b0
 114:	72642f63 	rsbvc	r2, r4, #396	; 0x18c
 118:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
 11c:	682f0073 	stmdavs	pc!, {r0, r1, r4, r5, r6}	; <UNPREDICTABLE>
 120:	2f656d6f 	svccs	0x00656d6f
 124:	686c6973 	stmdavs	ip!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
 128:	6a797661 	bvs	1e5dab4 <_bss_end+0x1e5486c>
 12c:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
 130:	2f6c6f6f 	svccs	0x006c6f6f
 134:	6f72655a 	svcvs	0x0072655a
 138:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
 13c:	6178652f 	cmnvs	r8, pc, lsr #10
 140:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
 144:	31312f73 	teqcc	r1, r3, ror pc
 148:	6d69742d 	cfstrdvs	mvd7, [r9, #-180]!	; 0xffffff4c
 14c:	6e5f7265 	cdpvs	2, 5, cr7, cr15, cr5, {3}
 150:	6c635f6f 	stclvs	15, cr5, [r3], #-444	; 0xfffffe44
 154:	5f726165 	svcpl	0x00726165
 158:	2f515249 	svccs	0x00515249
 15c:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 160:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 164:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 168:	622f6564 	eorvs	r6, pc, #100, 10	; 0x19000000
 16c:	6472616f 	ldrbtvs	r6, [r2], #-367	; 0xfffffe91
 170:	6970722f 	ldmdbvs	r0!, {r0, r1, r2, r3, r5, r9, ip, sp, lr}^
 174:	61682f30 	cmnvs	r8, r0, lsr pc
 178:	682f006c 	stmdavs	pc!, {r2, r3, r5, r6}	; <UNPREDICTABLE>
 17c:	2f656d6f 	svccs	0x00656d6f
 180:	686c6973 	stmdavs	ip!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
 184:	6a797661 	bvs	1e5db10 <_bss_end+0x1e548c8>
 188:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
 18c:	2f6c6f6f 	svccs	0x006c6f6f
 190:	6f72655a 	svcvs	0x0072655a
 194:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
 198:	6178652f 	cmnvs	r8, pc, lsr #10
 19c:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
 1a0:	31312f73 	teqcc	r1, r3, ror pc
 1a4:	6d69742d 	cfstrdvs	mvd7, [r9, #-180]!	; 0xffffff4c
 1a8:	6e5f7265 	cdpvs	2, 5, cr7, cr15, cr5, {3}
 1ac:	6c635f6f 	stclvs	15, cr5, [r3], #-444	; 0xfffffe44
 1b0:	5f726165 	svcpl	0x00726165
 1b4:	2f515249 	svccs	0x00515249
 1b8:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 1bc:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 1c0:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 1c4:	642f6564 	strtvs	r6, [pc], #-1380	; 1cc <CPSR_IRQ_INHIBIT+0x14c>
 1c8:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
 1cc:	00007372 	andeq	r7, r0, r2, ror r3
 1d0:	6f697067 	svcvs	0x00697067
 1d4:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
 1d8:	00000100 	andeq	r0, r0, r0, lsl #2
 1dc:	64746e69 	ldrbtvs	r6, [r4], #-3689	; 0xfffff197
 1e0:	682e6665 	stmdavs	lr!, {r0, r2, r5, r6, r9, sl, sp, lr}
 1e4:	00000200 	andeq	r0, r0, r0, lsl #4
 1e8:	69726570 	ldmdbvs	r2!, {r4, r5, r6, r8, sl, sp, lr}^
 1ec:	72656870 	rsbvc	r6, r5, #112, 16	; 0x700000
 1f0:	2e736c61 	cdpcs	12, 7, cr6, cr3, cr1, {3}
 1f4:	00020068 	andeq	r0, r2, r8, rrx
 1f8:	69706700 	ldmdbvs	r0!, {r8, r9, sl, sp, lr}^
 1fc:	00682e6f 	rsbeq	r2, r8, pc, ror #28
 200:	00000003 	andeq	r0, r0, r3
 204:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
 208:	00816c02 	addeq	r6, r1, r2, lsl #24
 20c:	38051700 	stmdacc	r5, {r8, r9, sl, ip}
 210:	6901059f 	stmdbvs	r1, {r0, r1, r2, r3, r4, r7, r8, sl}
 214:	d70505a1 	strle	r0, [r5, -r1, lsr #11]
 218:	05671005 	strbeq	r1, [r7, #-5]!
 21c:	93084c11 	movwls	r4, #35857	; 0x8c11
 220:	05670d05 	strbeq	r0, [r7, #-3333]!	; 0xfffff2fb
 224:	0d053011 	stceq	0, cr3, [r5, #-68]	; 0xffffffbc
 228:	30110567 	andscc	r0, r1, r7, ror #10
 22c:	05670d05 	strbeq	r0, [r7, #-3333]!	; 0xfffff2fb
 230:	0d053011 	stceq	0, cr3, [r5, #-68]	; 0xffffffbc
 234:	30110567 	andscc	r0, r1, r7, ror #10
 238:	05670d05 	strbeq	r0, [r7, #-3333]!	; 0xfffff2fb
 23c:	0d053011 	stceq	0, cr3, [r5, #-68]	; 0xffffffbc
 240:	31140567 	tstcc	r4, r7, ror #10
 244:	20081a05 	andcs	r1, r8, r5, lsl #20
 248:	05660d05 	strbeq	r0, [r6, #-3333]!	; 0xfffff2fb
 24c:	01054c0c 	tsteq	r5, ip, lsl #24
 250:	0505a12f 	streq	sl, [r5, #-303]	; 0xfffffed1
 254:	671005d7 			; <UNDEFINED> instruction: 0x671005d7
 258:	004c0b05 	subeq	r0, ip, r5, lsl #22
 25c:	06010402 	streq	r0, [r1], -r2, lsl #8
 260:	04020066 	streq	r0, [r2], #-102	; 0xffffff9a
 264:	09054a02 	stmdbeq	r5, {r1, r9, fp, lr}
 268:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
 26c:	13052e06 	movwne	r2, #24070	; 0x5e06
 270:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
 274:	000d054b 	andeq	r0, sp, fp, asr #10
 278:	4a040402 	bmi	101288 <_bss_end+0xf8040>
 27c:	02000c05 	andeq	r0, r0, #1280	; 0x500
 280:	054c0404 	strbeq	r0, [ip, #-1028]	; 0xfffffbfc
 284:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 288:	1005d705 	andne	sp, r5, r5, lsl #14
 28c:	4c0b0567 	cfstr32mi	mvfx0, [fp], {103}	; 0x67
 290:	01040200 	mrseq	r0, R12_usr
 294:	02006606 	andeq	r6, r0, #6291456	; 0x600000
 298:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 29c:	04020009 	streq	r0, [r2], #-9
 2a0:	052e0604 	streq	r0, [lr, #-1540]!	; 0xfffff9fc
 2a4:	04020013 	streq	r0, [r2], #-19	; 0xffffffed
 2a8:	0d054b04 	vstreq	d4, [r5, #-16]
 2ac:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
 2b0:	000c054a 	andeq	r0, ip, sl, asr #10
 2b4:	4c040402 	cfstrsmi	mvf0, [r4], {2}
 2b8:	852f0105 	strhi	r0, [pc, #-261]!	; 1bb <CPSR_IRQ_INHIBIT+0x13b>
 2bc:	05d70505 	ldrbeq	r0, [r7, #1285]	; 0x505
 2c0:	0b056710 	bleq	159f08 <_bss_end+0x150cc0>
 2c4:	0402004c 	streq	r0, [r2], #-76	; 0xffffffb4
 2c8:	00660601 	rsbeq	r0, r6, r1, lsl #12
 2cc:	4a020402 	bmi	812dc <_bss_end+0x78094>
 2d0:	02000905 	andeq	r0, r0, #81920	; 0x14000
 2d4:	2e060404 	cdpcs	4, 0, cr0, cr6, cr4, {0}
 2d8:	02001305 	andeq	r1, r0, #335544320	; 0x14000000
 2dc:	054b0404 	strbeq	r0, [fp, #-1028]	; 0xfffffbfc
 2e0:	0402000d 	streq	r0, [r2], #-13
 2e4:	0c054a04 			; <UNDEFINED> instruction: 0x0c054a04
 2e8:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
 2ec:	2f01054c 	svccs	0x0001054c
 2f0:	d81d0585 	ldmdale	sp, {r0, r2, r7, r8, sl}
 2f4:	05ba0905 	ldreq	r0, [sl, #2309]!	; 0x905
 2f8:	13054a05 	movwne	r4, #23045	; 0x5a05
 2fc:	4a1c054d 	bmi	701838 <_bss_end+0x6f85f0>
 300:	05823e05 	streq	r3, [r2, #3589]	; 0xe05
 304:	1e056621 	cfmadd32ne	mvax1, mvfx6, mvfx5, mvfx1
 308:	2e4b052e 	cdpcs	5, 4, cr0, cr11, cr14, {1}
 30c:	052e6b05 	streq	r6, [lr, #-2821]!	; 0xfffff4fb
 310:	0e054a05 	vmlaeq.f32	s8, s10, s10
 314:	6648054a 	strbvs	r0, [r8], -sl, asr #10
 318:	052e1005 	streq	r1, [lr, #-5]!
 31c:	01054809 	tsteq	r5, r9, lsl #16
 320:	1d054d31 	stcne	13, cr4, [r5, #-196]	; 0xffffff3c
 324:	ba0905a0 	blt	2419ac <_bss_end+0x238764>
 328:	054a0505 	strbeq	r0, [sl, #-1285]	; 0xfffffafb
 32c:	29054b20 	stmdbcs	r5, {r5, r8, r9, fp, lr}
 330:	4a32054c 	bmi	c81868 <_bss_end+0xc78620>
 334:	05823405 	streq	r3, [r2, #1029]	; 0x405
 338:	3f054a0c 	svccc	0x00054a0c
 33c:	0001052e 	andeq	r0, r1, lr, lsr #10
 340:	4b010402 	blmi	41350 <_bss_end+0x38108>
 344:	bc240569 	cfstr32lt	mvfx0, [r4], #-420	; 0xfffffe5c
 348:	20080905 	andcs	r0, r8, r5, lsl #18
 34c:	054a0505 	strbeq	r0, [sl, #-1285]	; 0xfffffafb
 350:	05054d15 	streq	r4, [r5, #-3349]	; 0xfffff2eb
 354:	4a0e0566 	bmi	3818f4 <_bss_end+0x3786ac>
 358:	05661505 	strbeq	r1, [r6, #-1285]!	; 0xfffffafb
 35c:	09052e10 	stmdbeq	r5, {r4, r9, sl, fp, sp}
 360:	03010548 	movweq	r0, #5448	; 0x1548
 364:	054d2e09 	strbeq	r2, [sp, #-3593]	; 0xfffff1f7
 368:	1005d705 	andne	sp, r5, r5, lsl #14
 36c:	4c130567 	cfldr32mi	mvfx0, [r3], {103}	; 0x67
 370:	054a0d05 	strbeq	r0, [sl, #-3333]	; 0xfffff2fb
 374:	00410813 	subeq	r0, r1, r3, lsl r8
 378:	06010402 	streq	r0, [r1], -r2, lsl #8
 37c:	04020066 	streq	r0, [r2], #-102	; 0xffffff9a
 380:	11054a02 	tstne	r5, r2, lsl #20
 384:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
 388:	0d052e06 	stceq	14, cr2, [r5, #-24]	; 0xffffffe8
 38c:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
 390:	3013054b 	andscc	r0, r3, fp, asr #10
 394:	01040200 	mrseq	r0, R12_usr
 398:	02006606 	andeq	r6, r0, #6291456	; 0x600000
 39c:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 3a0:	04020011 	streq	r0, [r2], #-17	; 0xffffffef
 3a4:	052e0604 	streq	r0, [lr, #-1540]!	; 0xfffff9fc
 3a8:	0402000d 	streq	r0, [r2], #-13
 3ac:	13054b04 	movwne	r4, #23300	; 0x5b04
 3b0:	04020030 	streq	r0, [r2], #-48	; 0xffffffd0
 3b4:	00660601 	rsbeq	r0, r6, r1, lsl #12
 3b8:	4a020402 	bmi	813c8 <_bss_end+0x78180>
 3bc:	02001105 	andeq	r1, r0, #1073741825	; 0x40000001
 3c0:	2e060404 	cdpcs	4, 0, cr0, cr6, cr4, {0}
 3c4:	02000d05 	andeq	r0, r0, #320	; 0x140
 3c8:	054b0404 	strbeq	r0, [fp, #-1028]	; 0xfffffbfc
 3cc:	02003013 	andeq	r3, r0, #19
 3d0:	66060104 	strvs	r0, [r6], -r4, lsl #2
 3d4:	02040200 	andeq	r0, r4, #0, 4
 3d8:	0011054a 	andseq	r0, r1, sl, asr #10
 3dc:	06040402 	streq	r0, [r4], -r2, lsl #8
 3e0:	000d052e 	andeq	r0, sp, lr, lsr #10
 3e4:	4b040402 	blmi	1013f4 <_bss_end+0xf81ac>
 3e8:	05301405 	ldreq	r1, [r0, #-1029]!	; 0xfffffbfb
 3ec:	01054d0c 	tsteq	r5, ip, lsl #26
 3f0:	2405852f 	strcs	r8, [r5], #-1327	; 0xfffffad1
 3f4:	080905bc 	stmdaeq	r9, {r2, r3, r4, r5, r7, r8, sl}
 3f8:	4a050520 	bmi	141880 <_bss_end+0x138638>
 3fc:	054d1405 	strbeq	r1, [sp, #-1029]	; 0xfffffbfb
 400:	0e054a1d 			; <UNDEFINED> instruction: 0x0e054a1d
 404:	4b100566 	blmi	4019a4 <_bss_end+0x3f875c>
 408:	05660c05 	strbeq	r0, [r6, #-3077]!	; 0xfffff3fb
 40c:	05054a09 	streq	r4, [r5, #-2569]	; 0xfffff5f7
 410:	4a0e0567 	bmi	3819b4 <_bss_end+0x37876c>
 414:	05661005 	strbeq	r1, [r6, #-5]!
 418:	01056209 	tsteq	r5, r9, lsl #4
 41c:	0b054d33 	bleq	1538f0 <_bss_end+0x14a6a8>
 420:	663505d8 			; <UNDEFINED> instruction: 0x663505d8
 424:	02002405 	andeq	r2, r0, #83886080	; 0x5000000
 428:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 42c:	04020009 	streq	r0, [r2], #-9
 430:	3505f202 	strcc	pc, [r5, #-514]	; 0xfffffdfe
 434:	03040200 	movweq	r0, #16896	; 0x4200
 438:	0054054a 	subseq	r0, r4, sl, asr #10
 43c:	66060402 	strvs	r0, [r6], -r2, lsl #8
 440:	02003805 	andeq	r3, r0, #327680	; 0x50000
 444:	05f20604 	ldrbeq	r0, [r2, #1540]!	; 0x604
 448:	04020035 	streq	r0, [r2], #-53	; 0xffffffcb
 44c:	02004a07 	andeq	r4, r0, #28672	; 0x7000
 450:	4a060804 	bmi	182468 <_bss_end+0x179220>
 454:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
 458:	2e060a04 	vmlacs.f32	s0, s12, s8
 45c:	054d1505 	strbeq	r1, [sp, #-1285]	; 0xfffffafb
 460:	0e056605 	cfmadd32eq	mvax0, mvfx6, mvfx5, mvfx5
 464:	6615054a 	ldrvs	r0, [r5], -sl, asr #10
 468:	052e1005 	streq	r1, [lr, #-5]!
 46c:	01054809 	tsteq	r5, r9, lsl #16
 470:	05054d31 	streq	r4, [r5, #-3377]	; 0xfffff2cf
 474:	671005d7 			; <UNDEFINED> instruction: 0x671005d7
 478:	004c0b05 	subeq	r0, ip, r5, lsl #22
 47c:	06010402 	streq	r0, [r1], -r2, lsl #8
 480:	04020066 	streq	r0, [r2], #-102	; 0xffffff9a
 484:	09054a02 	stmdbeq	r5, {r1, r9, fp, lr}
 488:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
 48c:	13052e06 	movwne	r2, #24070	; 0x5e06
 490:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
 494:	000d054b 	andeq	r0, sp, fp, asr #10
 498:	4a040402 	bmi	1014a8 <_bss_end+0xf8260>
 49c:	02000c05 	andeq	r0, r0, #1280	; 0x500
 4a0:	054c0404 	strbeq	r0, [ip, #-1028]	; 0xfffffbfc
 4a4:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 4a8:	0905a01c 	stmdbeq	r5, {r2, r3, r4, sp, pc}
 4ac:	4a0505ba 	bmi	141b9c <_bss_end+0x138954>
 4b0:	054e1405 	strbeq	r1, [lr, #-1029]	; 0xfffffbfb
 4b4:	0e056605 	cfmadd32eq	mvax0, mvfx6, mvfx5, mvfx5
 4b8:	6614054a 	ldrvs	r0, [r4], -sl, asr #10
 4bc:	052e1005 	streq	r1, [lr, #-5]!
 4c0:	01054709 	tsteq	r5, r9, lsl #14
 4c4:	009e4a32 	addseq	r4, lr, r2, lsr sl
 4c8:	06010402 	streq	r0, [r1], -r2, lsl #8
 4cc:	06230566 	strteq	r0, [r3], -r6, ror #10
 4d0:	827ed303 	rsbshi	sp, lr, #201326592	; 0xc000000
 4d4:	ad030105 	stfges	f0, [r3, #-20]	; 0xffffffec
 4d8:	4aba6601 	bmi	fee99ce4 <_bss_end+0xfee90a9c>
 4dc:	01000a02 	tsteq	r0, r2, lsl #20
 4e0:	0001e401 	andeq	lr, r1, r1, lsl #8
 4e4:	4a000300 	bmi	10ec <CPSR_IRQ_INHIBIT+0x106c>
 4e8:	02000001 	andeq	r0, r0, #1
 4ec:	0d0efb01 	vstreq	d15, [lr, #-4]
 4f0:	01010100 	mrseq	r0, (UNDEF: 17)
 4f4:	00000001 	andeq	r0, r0, r1
 4f8:	01000001 	tsteq	r0, r1
 4fc:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 448 <CPSR_IRQ_INHIBIT+0x3c8>
 500:	69732f65 	ldmdbvs	r3!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 504:	7661686c 	strbtvc	r6, [r1], -ip, ror #16
 508:	532f6a79 			; <UNDEFINED> instruction: 0x532f6a79
 50c:	6f6f6863 	svcvs	0x006f6863
 510:	655a2f6c 	ldrbvs	r2, [sl, #-3948]	; 0xfffff094
 514:	614d6f72 	hvcvs	55026	; 0xd6f2
 518:	652f6574 	strvs	r6, [pc, #-1396]!	; ffffffac <_bss_end+0xffff6d64>
 51c:	706d6178 	rsbvc	r6, sp, r8, ror r1
 520:	2f73656c 	svccs	0x0073656c
 524:	742d3131 	strtvc	r3, [sp], #-305	; 0xfffffecf
 528:	72656d69 	rsbvc	r6, r5, #6720	; 0x1a40
 52c:	5f6f6e5f 	svcpl	0x006f6e5f
 530:	61656c63 	cmnvs	r5, r3, ror #24
 534:	52495f72 	subpl	r5, r9, #456	; 0x1c8
 538:	656b2f51 	strbvs	r2, [fp, #-3921]!	; 0xfffff0af
 53c:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
 540:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
 544:	6972642f 	ldmdbvs	r2!, {r0, r1, r2, r3, r5, sl, sp, lr}^
 548:	73726576 	cmnvc	r2, #494927872	; 0x1d800000
 54c:	6f682f00 	svcvs	0x00682f00
 550:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
 554:	61686c69 	cmnvs	r8, r9, ror #24
 558:	2f6a7976 	svccs	0x006a7976
 55c:	6f686353 	svcvs	0x00686353
 560:	5a2f6c6f 	bpl	bdb724 <_bss_end+0xbd24dc>
 564:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 3d8 <CPSR_IRQ_INHIBIT+0x358>
 568:	2f657461 	svccs	0x00657461
 56c:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
 570:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
 574:	2d31312f 	ldfcss	f3, [r1, #-188]!	; 0xffffff44
 578:	656d6974 	strbvs	r6, [sp, #-2420]!	; 0xfffff68c
 57c:	6f6e5f72 	svcvs	0x006e5f72
 580:	656c635f 	strbvs	r6, [ip, #-863]!	; 0xfffffca1
 584:	495f7261 	ldmdbmi	pc, {r0, r5, r6, r9, ip, sp, lr}^	; <UNPREDICTABLE>
 588:	6b2f5152 	blvs	bd4ad8 <_bss_end+0xbcb890>
 58c:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 590:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
 594:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 598:	6f622f65 	svcvs	0x00622f65
 59c:	2f647261 	svccs	0x00647261
 5a0:	30697072 	rsbcc	r7, r9, r2, ror r0
 5a4:	6c61682f 	stclvs	8, cr6, [r1], #-188	; 0xffffff44
 5a8:	6f682f00 	svcvs	0x00682f00
 5ac:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
 5b0:	61686c69 	cmnvs	r8, r9, ror #24
 5b4:	2f6a7976 	svccs	0x006a7976
 5b8:	6f686353 	svcvs	0x00686353
 5bc:	5a2f6c6f 	bpl	bdb780 <_bss_end+0xbd2538>
 5c0:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 434 <CPSR_IRQ_INHIBIT+0x3b4>
 5c4:	2f657461 	svccs	0x00657461
 5c8:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
 5cc:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
 5d0:	2d31312f 	ldfcss	f3, [r1, #-188]!	; 0xffffff44
 5d4:	656d6974 	strbvs	r6, [sp, #-2420]!	; 0xfffff68c
 5d8:	6f6e5f72 	svcvs	0x006e5f72
 5dc:	656c635f 	strbvs	r6, [ip, #-863]!	; 0xfffffca1
 5e0:	495f7261 	ldmdbmi	pc, {r0, r5, r6, r9, ip, sp, lr}^	; <UNPREDICTABLE>
 5e4:	6b2f5152 	blvs	bd4b34 <_bss_end+0xbcb8ec>
 5e8:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 5ec:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
 5f0:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 5f4:	72642f65 	rsbvc	r2, r4, #404	; 0x194
 5f8:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
 5fc:	74000073 	strvc	r0, [r0], #-115	; 0xffffff8d
 600:	72656d69 	rsbvc	r6, r5, #6720	; 0x1a40
 604:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
 608:	00000100 	andeq	r0, r0, r0, lsl #2
 60c:	64746e69 	ldrbtvs	r6, [r4], #-3689	; 0xfffff197
 610:	682e6665 	stmdavs	lr!, {r0, r2, r5, r6, r9, sl, sp, lr}
 614:	00000200 	andeq	r0, r0, r0, lsl #4
 618:	69726570 	ldmdbvs	r2!, {r4, r5, r6, r8, sl, sp, lr}^
 61c:	72656870 	rsbvc	r6, r5, #112, 16	; 0x700000
 620:	2e736c61 	cdpcs	12, 7, cr6, cr3, cr1, {3}
 624:	00020068 	andeq	r0, r2, r8, rrx
 628:	6d697400 	cfstrdvs	mvd7, [r9, #-0]
 62c:	682e7265 	stmdavs	lr!, {r0, r2, r5, r6, r9, ip, sp, lr}
 630:	00000300 	andeq	r0, r0, r0, lsl #6
 634:	00010500 	andeq	r0, r1, r0, lsl #10
 638:	89a80205 	stmibhi	r8!, {r0, r2, r9}
 63c:	19030000 	stmdbne	r3, {}	; <UNPREDICTABLE>
 640:	9f0f0501 	svcls	0x000f0501
 644:	052f1405 	streq	r1, [pc, #-1029]!	; 247 <CPSR_IRQ_INHIBIT+0x1c7>
 648:	05a1a101 	streq	sl, [r1, #257]!	; 0x101
 64c:	18059f0c 	stmdane	r5, {r2, r3, r8, r9, sl, fp, ip, pc}
 650:	2e36054a 	cdpcs	5, 3, cr0, cr6, cr10, {2}
 654:	854b0105 	strbhi	r0, [fp, #-261]	; 0xfffffefb
 658:	05d71e05 	ldrbeq	r1, [r7, #3589]	; 0xe05
 65c:	15058220 	strne	r8, [r5, #-544]	; 0xfffffde0
 660:	671b054d 	ldrvs	r0, [fp, -sp, asr #10]
 664:	05671705 	strbeq	r1, [r7, #-1797]!	; 0xfffff8fb
 668:	13056715 	movwne	r6, #22293	; 0x5715
 66c:	d8460566 	stmdale	r6, {r1, r2, r5, r6, r8, sl}^
 670:	052e2105 	streq	r2, [lr, #-261]!	; 0xfffffefb
 674:	23058225 	movwcs	r8, #21029	; 0x5225
 678:	2505302e 	strcs	r3, [r5, #-46]	; 0xffffffd2
 67c:	4c0f0582 	cfstr32mi	mvfx0, [pc], {130}	; 0x82
 680:	69670105 	stmdbvs	r7!, {r0, r2, r8}^
 684:	05836f05 	streq	r6, [r3, #3845]	; 0xf05
 688:	1705841b 	smladne	r5, fp, r4, r8
 68c:	83010583 	movwhi	r0, #5507	; 0x1583
 690:	85090569 	strhi	r0, [r9, #-1385]	; 0xfffffa97
 694:	054a0505 	strbeq	r0, [sl, #-1285]	; 0xfffffafb
 698:	12054b09 	andne	r4, r5, #9216	; 0x2400
 69c:	2f01054a 	svccs	0x0001054a
 6a0:	832b0569 			; <UNDEFINED> instruction: 0x832b0569
 6a4:	05821005 	streq	r1, [r2, #5]
 6a8:	01052e2b 	tsteq	r5, fp, lsr #28
 6ac:	009e6683 	addseq	r6, lr, r3, lsl #13
 6b0:	06010402 	streq	r0, [r1], -r2, lsl #8
 6b4:	061e0566 	ldreq	r0, [lr], -r6, ror #10
 6b8:	827fba03 	rsbshi	fp, pc, #12288	; 0x3000
 6bc:	c6030105 	strgt	r0, [r3], -r5, lsl #2
 6c0:	4aba6600 	bmi	fee99ec8 <_bss_end+0xfee90c80>
 6c4:	01000a02 	tsteq	r0, r2, lsl #20
 6c8:	0002a101 	andeq	sl, r2, r1, lsl #2
 6cc:	c2000300 	andgt	r0, r0, #0, 6
 6d0:	02000001 	andeq	r0, r0, #1
 6d4:	0d0efb01 	vstreq	d15, [lr, #-4]
 6d8:	01010100 	mrseq	r0, (UNDEF: 17)
 6dc:	00000001 	andeq	r0, r0, r1
 6e0:	01000001 	tsteq	r0, r1
 6e4:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 630 <CPSR_IRQ_INHIBIT+0x5b0>
 6e8:	69732f65 	ldmdbvs	r3!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 6ec:	7661686c 	strbtvc	r6, [r1], -ip, ror #16
 6f0:	532f6a79 			; <UNDEFINED> instruction: 0x532f6a79
 6f4:	6f6f6863 	svcvs	0x006f6863
 6f8:	655a2f6c 	ldrbvs	r2, [sl, #-3948]	; 0xfffff094
 6fc:	614d6f72 	hvcvs	55026	; 0xd6f2
 700:	652f6574 	strvs	r6, [pc, #-1396]!	; 194 <CPSR_IRQ_INHIBIT+0x114>
 704:	706d6178 	rsbvc	r6, sp, r8, ror r1
 708:	2f73656c 	svccs	0x0073656c
 70c:	742d3131 	strtvc	r3, [sp], #-305	; 0xfffffecf
 710:	72656d69 	rsbvc	r6, r5, #6720	; 0x1a40
 714:	5f6f6e5f 	svcpl	0x006f6e5f
 718:	61656c63 	cmnvs	r5, r3, ror #24
 71c:	52495f72 	subpl	r5, r9, #456	; 0x1c8
 720:	656b2f51 	strbvs	r2, [fp, #-3921]!	; 0xfffff0af
 724:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
 728:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
 72c:	6f682f00 	svcvs	0x00682f00
 730:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
 734:	61686c69 	cmnvs	r8, r9, ror #24
 738:	2f6a7976 	svccs	0x006a7976
 73c:	6f686353 	svcvs	0x00686353
 740:	5a2f6c6f 	bpl	bdb904 <_bss_end+0xbd26bc>
 744:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 5b8 <CPSR_IRQ_INHIBIT+0x538>
 748:	2f657461 	svccs	0x00657461
 74c:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
 750:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
 754:	2d31312f 	ldfcss	f3, [r1, #-188]!	; 0xffffff44
 758:	656d6974 	strbvs	r6, [sp, #-2420]!	; 0xfffff68c
 75c:	6f6e5f72 	svcvs	0x006e5f72
 760:	656c635f 	strbvs	r6, [ip, #-863]!	; 0xfffffca1
 764:	495f7261 	ldmdbmi	pc, {r0, r5, r6, r9, ip, sp, lr}^	; <UNPREDICTABLE>
 768:	6b2f5152 	blvs	bd4cb8 <_bss_end+0xbcba70>
 76c:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 770:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
 774:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 778:	6f622f65 	svcvs	0x00622f65
 77c:	2f647261 	svccs	0x00647261
 780:	30697072 	rsbcc	r7, r9, r2, ror r0
 784:	6c61682f 	stclvs	8, cr6, [r1], #-188	; 0xffffff44
 788:	6f682f00 	svcvs	0x00682f00
 78c:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
 790:	61686c69 	cmnvs	r8, r9, ror #24
 794:	2f6a7976 	svccs	0x006a7976
 798:	6f686353 	svcvs	0x00686353
 79c:	5a2f6c6f 	bpl	bdb960 <_bss_end+0xbd2718>
 7a0:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 614 <CPSR_IRQ_INHIBIT+0x594>
 7a4:	2f657461 	svccs	0x00657461
 7a8:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
 7ac:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
 7b0:	2d31312f 	ldfcss	f3, [r1, #-188]!	; 0xffffff44
 7b4:	656d6974 	strbvs	r6, [sp, #-2420]!	; 0xfffff68c
 7b8:	6f6e5f72 	svcvs	0x006e5f72
 7bc:	656c635f 	strbvs	r6, [ip, #-863]!	; 0xfffffca1
 7c0:	495f7261 	ldmdbmi	pc, {r0, r5, r6, r9, ip, sp, lr}^	; <UNPREDICTABLE>
 7c4:	6b2f5152 	blvs	bd4d14 <_bss_end+0xbcbacc>
 7c8:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 7cc:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
 7d0:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 7d4:	72642f65 	rsbvc	r2, r4, #404	; 0x194
 7d8:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
 7dc:	682f0073 	stmdavs	pc!, {r0, r1, r4, r5, r6}	; <UNPREDICTABLE>
 7e0:	2f656d6f 	svccs	0x00656d6f
 7e4:	686c6973 	stmdavs	ip!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
 7e8:	6a797661 	bvs	1e5e174 <_bss_end+0x1e54f2c>
 7ec:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
 7f0:	2f6c6f6f 	svccs	0x006c6f6f
 7f4:	6f72655a 	svcvs	0x0072655a
 7f8:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
 7fc:	6178652f 	cmnvs	r8, pc, lsr #10
 800:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
 804:	31312f73 	teqcc	r1, r3, ror pc
 808:	6d69742d 	cfstrdvs	mvd7, [r9, #-180]!	; 0xffffff4c
 80c:	6e5f7265 	cdpvs	2, 5, cr7, cr15, cr5, {3}
 810:	6c635f6f 	stclvs	15, cr5, [r3], #-444	; 0xfffffe44
 814:	5f726165 	svcpl	0x00726165
 818:	2f515249 	svccs	0x00515249
 81c:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 820:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 824:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 828:	00006564 	andeq	r6, r0, r4, ror #10
 82c:	65746e69 	ldrbvs	r6, [r4, #-3689]!	; 0xfffff197
 830:	70757272 	rsbsvc	r7, r5, r2, ror r2
 834:	6f635f74 	svcvs	0x00635f74
 838:	6f72746e 	svcvs	0x0072746e
 83c:	72656c6c 	rsbvc	r6, r5, #108, 24	; 0x6c00
 840:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
 844:	00000100 	andeq	r0, r0, r0, lsl #2
 848:	64746e69 	ldrbtvs	r6, [r4], #-3689	; 0xfffff197
 84c:	682e6665 	stmdavs	lr!, {r0, r2, r5, r6, r9, sl, sp, lr}
 850:	00000200 	andeq	r0, r0, r0, lsl #4
 854:	69726570 	ldmdbvs	r2!, {r4, r5, r6, r8, sl, sp, lr}^
 858:	72656870 	rsbvc	r6, r5, #112, 16	; 0x700000
 85c:	2e736c61 	cdpcs	12, 7, cr6, cr3, cr1, {3}
 860:	00020068 	andeq	r0, r2, r8, rrx
 864:	69706700 	ldmdbvs	r0!, {r8, r9, sl, sp, lr}^
 868:	00682e6f 	rsbeq	r2, r8, pc, ror #28
 86c:	69000003 	stmdbvs	r0, {r0, r1}
 870:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
 874:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
 878:	6e6f635f 	mcrvs	3, 3, r6, cr15, cr15, {2}
 87c:	6c6f7274 	sfmvs	f7, 2, [pc], #-464	; 6b4 <CPSR_IRQ_INHIBIT+0x634>
 880:	2e72656c 	cdpcs	5, 7, cr6, cr2, cr12, {3}
 884:	00040068 	andeq	r0, r4, r8, rrx
 888:	6d697400 	cfstrdvs	mvd7, [r9, #-0]
 88c:	682e7265 	stmdavs	lr!, {r0, r2, r5, r6, r9, ip, sp, lr}
 890:	00000300 	andeq	r0, r0, r0, lsl #6
 894:	00010500 	andeq	r0, r1, r0, lsl #10
 898:	8c200205 	sfmhi	f0, 4, [r0], #-20	; 0xffffffec
 89c:	4b190000 	blmi	6408a4 <_bss_end+0x63765c>
 8a0:	67240585 	strvs	r0, [r4, -r5, lsl #11]!
 8a4:	05660505 	strbeq	r0, [r6, #-1285]!	; 0xfffffafb
 8a8:	01054b1c 	tsteq	r5, ip, lsl fp
 8ac:	6a2f854b 	bvs	be1de0 <_bss_end+0xbd8b98>
 8b0:	059f1305 	ldreq	r1, [pc, #773]	; bbd <CPSR_IRQ_INHIBIT+0xb3d>
 8b4:	01052e38 	tsteq	r5, r8, lsr lr
 8b8:	0c05a14c 	stfeqd	f2, [r5], {76}	; 0x4c
 8bc:	4a1c059f 	bmi	701f40 <_bss_end+0x6f8cf8>
 8c0:	052e3a05 	streq	r3, [lr, #-2565]!	; 0xfffff5fb
 8c4:	05854b01 	streq	r4, [r5, #2817]	; 0xb01
 8c8:	40059f43 	andmi	r9, r5, r3, asr #30
 8cc:	4a39052e 	bmi	e41d8c <_bss_end+0xe38b44>
 8d0:	05824005 	streq	r4, [r2, #5]
 8d4:	01052e3b 	tsteq	r5, fp, lsr lr
 8d8:	4405692f 	strmi	r6, [r5], #-2351	; 0xfffff6d1
 8dc:	2e41059f 	mcrcs	5, 2, r0, cr1, cr15, {4}
 8e0:	054a3a05 	strbeq	r3, [sl, #-2565]	; 0xfffff5fb
 8e4:	3c058241 	sfmcc	f0, 1, [r5], {65}	; 0x41
 8e8:	2f01052e 	svccs	0x0001052e
 8ec:	9f180569 	svcls	0x00180569
 8f0:	4c018705 	stcmi	7, cr8, [r1], {5}
 8f4:	054a7a05 	strbeq	r7, [sl, #-2565]	; 0xfffff5fb
 8f8:	02004a73 	andeq	r4, r0, #471040	; 0x73000
 8fc:	66060104 	strvs	r0, [r6], -r4, lsl #2
 900:	02040200 	andeq	r0, r4, #0, 4
 904:	0402004a 	streq	r0, [r2], #-74	; 0xffffffb6
 908:	7a052e04 	bvc	14c120 <_bss_end+0x142ed8>
 90c:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
 910:	75058206 	strvc	r8, [r5, #-518]	; 0xfffffdfa
 914:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
 918:	0001052e 	andeq	r0, r1, lr, lsr #10
 91c:	2f040402 	svccs	0x00040402
 920:	9f180569 	svcls	0x00180569
 924:	4c018905 			; <UNDEFINED> instruction: 0x4c018905
 928:	054a7c05 	strbeq	r7, [sl, #-3077]	; 0xfffff3fb
 92c:	02004a75 	andeq	r4, r0, #479232	; 0x75000
 930:	66060104 	strvs	r0, [r6], -r4, lsl #2
 934:	02040200 	andeq	r0, r4, #0, 4
 938:	0402004a 	streq	r0, [r2], #-74	; 0xffffffb6
 93c:	7c052e04 	stcvc	14, cr2, [r5], {4}
 940:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
 944:	77058206 	strvc	r8, [r5, -r6, lsl #4]
 948:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
 94c:	0001052e 	andeq	r0, r1, lr, lsr #10
 950:	2f040402 	svccs	0x00040402
 954:	02009e66 	andeq	r9, r0, #1632	; 0x660
 958:	66060104 	strvs	r0, [r6], -r4, lsl #2
 95c:	03064305 	movweq	r4, #25349	; 0x6305
 960:	0105825e 	tsteq	r5, lr, asr r2
 964:	ba662203 	blt	1989178 <_bss_end+0x197ff30>
 968:	000a024a 	andeq	r0, sl, sl, asr #4
 96c:	01ff0101 	mvnseq	r0, r1, lsl #2
 970:	00030000 	andeq	r0, r3, r0
 974:	000001b2 			; <UNDEFINED> instruction: 0x000001b2
 978:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
 97c:	0101000d 	tsteq	r1, sp
 980:	00000101 	andeq	r0, r0, r1, lsl #2
 984:	00000100 	andeq	r0, r0, r0, lsl #2
 988:	6f682f01 	svcvs	0x00682f01
 98c:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
 990:	61686c69 	cmnvs	r8, r9, ror #24
 994:	2f6a7976 	svccs	0x006a7976
 998:	6f686353 	svcvs	0x00686353
 99c:	5a2f6c6f 	bpl	bdbb60 <_bss_end+0xbd2918>
 9a0:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 814 <CPSR_IRQ_INHIBIT+0x794>
 9a4:	2f657461 	svccs	0x00657461
 9a8:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
 9ac:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
 9b0:	2d31312f 	ldfcss	f3, [r1, #-188]!	; 0xffffff44
 9b4:	656d6974 	strbvs	r6, [sp, #-2420]!	; 0xfffff68c
 9b8:	6f6e5f72 	svcvs	0x006e5f72
 9bc:	656c635f 	strbvs	r6, [ip, #-863]!	; 0xfffffca1
 9c0:	495f7261 	ldmdbmi	pc, {r0, r5, r6, r9, ip, sp, lr}^	; <UNPREDICTABLE>
 9c4:	6b2f5152 	blvs	bd4f14 <_bss_end+0xbcbccc>
 9c8:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 9cc:	72732f6c 	rsbsvc	r2, r3, #108, 30	; 0x1b0
 9d0:	682f0063 	stmdavs	pc!, {r0, r1, r5, r6}	; <UNPREDICTABLE>
 9d4:	2f656d6f 	svccs	0x00656d6f
 9d8:	686c6973 	stmdavs	ip!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
 9dc:	6a797661 	bvs	1e5e368 <_bss_end+0x1e55120>
 9e0:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
 9e4:	2f6c6f6f 	svccs	0x006c6f6f
 9e8:	6f72655a 	svcvs	0x0072655a
 9ec:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
 9f0:	6178652f 	cmnvs	r8, pc, lsr #10
 9f4:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
 9f8:	31312f73 	teqcc	r1, r3, ror pc
 9fc:	6d69742d 	cfstrdvs	mvd7, [r9, #-180]!	; 0xffffff4c
 a00:	6e5f7265 	cdpvs	2, 5, cr7, cr15, cr5, {3}
 a04:	6c635f6f 	stclvs	15, cr5, [r3], #-444	; 0xfffffe44
 a08:	5f726165 	svcpl	0x00726165
 a0c:	2f515249 	svccs	0x00515249
 a10:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 a14:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 a18:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 a1c:	622f6564 	eorvs	r6, pc, #100, 10	; 0x19000000
 a20:	6472616f 	ldrbtvs	r6, [r2], #-367	; 0xfffffe91
 a24:	6970722f 	ldmdbvs	r0!, {r0, r1, r2, r3, r5, r9, ip, sp, lr}^
 a28:	61682f30 	cmnvs	r8, r0, lsr pc
 a2c:	682f006c 	stmdavs	pc!, {r2, r3, r5, r6}	; <UNPREDICTABLE>
 a30:	2f656d6f 	svccs	0x00656d6f
 a34:	686c6973 	stmdavs	ip!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
 a38:	6a797661 	bvs	1e5e3c4 <_bss_end+0x1e5517c>
 a3c:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
 a40:	2f6c6f6f 	svccs	0x006c6f6f
 a44:	6f72655a 	svcvs	0x0072655a
 a48:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
 a4c:	6178652f 	cmnvs	r8, pc, lsr #10
 a50:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
 a54:	31312f73 	teqcc	r1, r3, ror pc
 a58:	6d69742d 	cfstrdvs	mvd7, [r9, #-180]!	; 0xffffff4c
 a5c:	6e5f7265 	cdpvs	2, 5, cr7, cr15, cr5, {3}
 a60:	6c635f6f 	stclvs	15, cr5, [r3], #-444	; 0xfffffe44
 a64:	5f726165 	svcpl	0x00726165
 a68:	2f515249 	svccs	0x00515249
 a6c:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 a70:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 a74:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 a78:	642f6564 	strtvs	r6, [pc], #-1380	; a80 <CPSR_IRQ_INHIBIT+0xa00>
 a7c:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
 a80:	2f007372 	svccs	0x00007372
 a84:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
 a88:	6c69732f 	stclvs	3, cr7, [r9], #-188	; 0xffffff44
 a8c:	79766168 	ldmdbvc	r6!, {r3, r5, r6, r8, sp, lr}^
 a90:	63532f6a 	cmpvs	r3, #424	; 0x1a8
 a94:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; 8fc <CPSR_IRQ_INHIBIT+0x87c>
 a98:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
 a9c:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
 aa0:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 aa4:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
 aa8:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
 aac:	69742d31 	ldmdbvs	r4!, {r0, r4, r5, r8, sl, fp, sp}^
 ab0:	5f72656d 	svcpl	0x0072656d
 ab4:	635f6f6e 	cmpvs	pc, #440	; 0x1b8
 ab8:	7261656c 	rsbvc	r6, r1, #108, 10	; 0x1b000000
 abc:	5152495f 	cmppl	r2, pc, asr r9
 ac0:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 ac4:	2f6c656e 	svccs	0x006c656e
 ac8:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 acc:	00656475 	rsbeq	r6, r5, r5, ror r4
 ad0:	69616d00 	stmdbvs	r1!, {r8, sl, fp, sp, lr}^
 ad4:	70632e6e 	rsbvc	r2, r3, lr, ror #28
 ad8:	00010070 	andeq	r0, r1, r0, ror r0
 adc:	746e6900 	strbtvc	r6, [lr], #-2304	; 0xfffff700
 ae0:	2e666564 	cdpcs	5, 6, cr6, cr6, cr4, {3}
 ae4:	00020068 	andeq	r0, r2, r8, rrx
 ae8:	69706700 	ldmdbvs	r0!, {r8, r9, sl, sp, lr}^
 aec:	00682e6f 	rsbeq	r2, r8, pc, ror #28
 af0:	70000003 	andvc	r0, r0, r3
 af4:	70697265 	rsbvc	r7, r9, r5, ror #4
 af8:	61726568 	cmnvs	r2, r8, ror #10
 afc:	682e736c 	stmdavs	lr!, {r2, r3, r5, r6, r8, r9, ip, sp, lr}
 b00:	00000200 	andeq	r0, r0, r0, lsl #4
 b04:	65746e69 	ldrbvs	r6, [r4, #-3689]!	; 0xfffff197
 b08:	70757272 	rsbsvc	r7, r5, r2, ror r2
 b0c:	6f635f74 	svcvs	0x00635f74
 b10:	6f72746e 	svcvs	0x0072746e
 b14:	72656c6c 	rsbvc	r6, r5, #108, 24	; 0x6c00
 b18:	0400682e 	streq	r6, [r0], #-2094	; 0xfffff7d2
 b1c:	69740000 	ldmdbvs	r4!, {}^	; <UNPREDICTABLE>
 b20:	2e72656d 	cdpcs	5, 7, cr6, cr2, cr13, {3}
 b24:	00030068 	andeq	r0, r3, r8, rrx
 b28:	01050000 	mrseq	r0, (UNDEF: 5)
 b2c:	b4020500 	strlt	r0, [r2], #-1280	; 0xfffffb00
 b30:	1900008e 	stmdbne	r0, {r1, r2, r3, r7}
 b34:	054d1205 	strbeq	r1, [sp, #-517]	; 0xfffffdfb
 b38:	1305ba05 	movwne	fp, #23045	; 0x5a05
 b3c:	6719054c 	ldrvs	r0, [r9, -ip, asr #10]
 b40:	05890105 	streq	r0, [r9, #261]	; 0x105
 b44:	19052b13 	stmdbne	r5, {r0, r1, r4, r8, r9, fp, sp}
 b48:	84010567 	strhi	r0, [r1], #-1383	; 0xfffffa99
 b4c:	4b1c0585 	blmi	702168 <_bss_end+0x6f8f20>
 b50:	1e058483 	cdpne	4, 0, cr8, cr5, cr3, {4}
 b54:	1d058383 	stcne	3, cr8, [r5, #-524]	; 0xfffffdf4
 b58:	68240584 	stmdavs	r4!, {r2, r7, r8, sl}
 b5c:	05691205 	strbeq	r1, [r9, #-517]!	; 0xfffffdfb
 b60:	0f05a123 	svceq	0x0005a123
 b64:	00050568 	andeq	r0, r5, r8, ror #10
 b68:	30010402 	andcc	r0, r1, r2, lsl #8
 b6c:	01000a02 	tsteq	r0, r2, lsl #20
 b70:	0000b201 	andeq	fp, r0, r1, lsl #4
 b74:	67000300 	strvs	r0, [r0, -r0, lsl #6]
 b78:	02000000 	andeq	r0, r0, #0
 b7c:	0d0efb01 	vstreq	d15, [lr, #-4]
 b80:	01010100 	mrseq	r0, (UNDEF: 17)
 b84:	00000001 	andeq	r0, r0, r1
 b88:	01000001 	tsteq	r0, r1
 b8c:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; ad8 <CPSR_IRQ_INHIBIT+0xa58>
 b90:	69732f65 	ldmdbvs	r3!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 b94:	7661686c 	strbtvc	r6, [r1], -ip, ror #16
 b98:	532f6a79 			; <UNDEFINED> instruction: 0x532f6a79
 b9c:	6f6f6863 	svcvs	0x006f6863
 ba0:	655a2f6c 	ldrbvs	r2, [sl, #-3948]	; 0xfffff094
 ba4:	614d6f72 	hvcvs	55026	; 0xd6f2
 ba8:	652f6574 	strvs	r6, [pc, #-1396]!	; 63c <CPSR_IRQ_INHIBIT+0x5bc>
 bac:	706d6178 	rsbvc	r6, sp, r8, ror r1
 bb0:	2f73656c 	svccs	0x0073656c
 bb4:	742d3131 	strtvc	r3, [sp], #-305	; 0xfffffecf
 bb8:	72656d69 	rsbvc	r6, r5, #6720	; 0x1a40
 bbc:	5f6f6e5f 	svcpl	0x006f6e5f
 bc0:	61656c63 	cmnvs	r5, r3, ror #24
 bc4:	52495f72 	subpl	r5, r9, #456	; 0x1c8
 bc8:	656b2f51 	strbvs	r2, [fp, #-3921]!	; 0xfffff0af
 bcc:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
 bd0:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
 bd4:	74730000 	ldrbtvc	r0, [r3], #-0
 bd8:	2e747261 	cdpcs	2, 7, cr7, cr4, cr1, {3}
 bdc:	00010073 	andeq	r0, r1, r3, ror r0
 be0:	05000000 	streq	r0, [r0, #-0]
 be4:	00800002 	addeq	r0, r0, r2
 be8:	010d0300 	mrseq	r0, SP_mon
 bec:	2f2f2f2f 	svccs	0x002f2f2f
 bf0:	032f2f2f 			; <UNDEFINED> instruction: 0x032f2f2f
 bf4:	3120081d 			; <UNDEFINED> instruction: 0x3120081d
 bf8:	2f2f322f 	svccs	0x002f322f
 bfc:	2f2f312f 	svccs	0x002f312f
 c00:	312f2f31 			; <UNDEFINED> instruction: 0x312f2f31
 c04:	2f302f2f 	svccs	0x00302f2f
 c08:	02302f2f 	eorseq	r2, r0, #47, 30	; 0xbc
 c0c:	01010002 	tsteq	r1, r2
 c10:	d0020500 	andle	r0, r2, r0, lsl #10
 c14:	0300008f 	movweq	r0, #143	; 0x8f
 c18:	2f0100d9 	svccs	0x000100d9
 c1c:	312f2f2f 			; <UNDEFINED> instruction: 0x312f2f2f
 c20:	02023333 	andeq	r3, r2, #-872415232	; 0xcc000000
 c24:	ec010100 	stfs	f0, [r1], {-0}
 c28:	03000000 	movweq	r0, #0
 c2c:	00006b00 	andeq	r6, r0, r0, lsl #22
 c30:	fb010200 	blx	4143a <_bss_end+0x381f2>
 c34:	01000d0e 	tsteq	r0, lr, lsl #26
 c38:	00010101 	andeq	r0, r1, r1, lsl #2
 c3c:	00010000 	andeq	r0, r1, r0
 c40:	682f0100 	stmdavs	pc!, {r8}	; <UNPREDICTABLE>
 c44:	2f656d6f 	svccs	0x00656d6f
 c48:	686c6973 	stmdavs	ip!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
 c4c:	6a797661 	bvs	1e5e5d8 <_bss_end+0x1e55390>
 c50:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
 c54:	2f6c6f6f 	svccs	0x006c6f6f
 c58:	6f72655a 	svcvs	0x0072655a
 c5c:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
 c60:	6178652f 	cmnvs	r8, pc, lsr #10
 c64:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
 c68:	31312f73 	teqcc	r1, r3, ror pc
 c6c:	6d69742d 	cfstrdvs	mvd7, [r9, #-180]!	; 0xffffff4c
 c70:	6e5f7265 	cdpvs	2, 5, cr7, cr15, cr5, {3}
 c74:	6c635f6f 	stclvs	15, cr5, [r3], #-444	; 0xfffffe44
 c78:	5f726165 	svcpl	0x00726165
 c7c:	2f515249 	svccs	0x00515249
 c80:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 c84:	732f6c65 			; <UNDEFINED> instruction: 0x732f6c65
 c88:	00006372 	andeq	r6, r0, r2, ror r3
 c8c:	72617473 	rsbvc	r7, r1, #1929379840	; 0x73000000
 c90:	2e707574 	mrccs	5, 3, r7, cr0, cr4, {3}
 c94:	00707063 	rsbseq	r7, r0, r3, rrx
 c98:	00000001 	andeq	r0, r0, r1
 c9c:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
 ca0:	008ff002 	addeq	pc, pc, r2
 ca4:	01140300 	tsteq	r4, r0, lsl #6
 ca8:	056a0c05 	strbeq	r0, [sl, #-3077]!	; 0xfffff3fb
 cac:	04020022 	streq	r0, [r2], #-34	; 0xffffffde
 cb0:	0c056603 	stceq	6, cr6, [r5], {3}
 cb4:	02040200 	andeq	r0, r4, #0, 4
 cb8:	000505bb 			; <UNDEFINED> instruction: 0x000505bb
 cbc:	65020402 	strvs	r0, [r2, #-1026]	; 0xfffffbfe
 cc0:	05850c05 	streq	r0, [r5, #3077]	; 0xc05
 cc4:	05bd2f01 	ldreq	r2, [sp, #3841]!	; 0xf01
 cc8:	27056b10 	smladcs	r5, r0, fp, r6
 ccc:	03040200 	movweq	r0, #16896	; 0x4200
 cd0:	000a054a 	andeq	r0, sl, sl, asr #10
 cd4:	83020402 	movwhi	r0, #9218	; 0x2402
 cd8:	02001105 	andeq	r1, r0, #1073741825	; 0x40000001
 cdc:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 ce0:	04020005 	streq	r0, [r2], #-5
 ce4:	0c052d02 	stceq	13, cr2, [r5], {2}
 ce8:	2f010585 	svccs	0x00010585
 cec:	6a1005a1 	bvs	402378 <_bss_end+0x3f9130>
 cf0:	02002705 	andeq	r2, r0, #1310720	; 0x140000
 cf4:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
 cf8:	0402000a 	streq	r0, [r2], #-10
 cfc:	11058302 	tstne	r5, r2, lsl #6
 d00:	02040200 	andeq	r0, r4, #0, 4
 d04:	0005054a 	andeq	r0, r5, sl, asr #10
 d08:	2d020402 	cfstrscs	mvf0, [r2, #-8]
 d0c:	05850c05 	streq	r0, [r5, #3077]	; 0xc05
 d10:	0a022f01 	beq	8c91c <_bss_end+0x836d4>
 d14:	03010100 	movweq	r0, #4352	; 0x1100
 d18:	03000001 	movweq	r0, #1
 d1c:	0000fd00 	andeq	pc, r0, r0, lsl #26
 d20:	fb010200 	blx	4152a <_bss_end+0x382e2>
 d24:	01000d0e 	tsteq	r0, lr, lsl #26
 d28:	00010101 	andeq	r0, r1, r1, lsl #2
 d2c:	00010000 	andeq	r0, r1, r0
 d30:	2e2e0100 	sufcse	f0, f6, f0
 d34:	2f2e2e2f 	svccs	0x002e2e2f
 d38:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 d3c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 d40:	2f2e2e2f 	svccs	0x002e2e2f
 d44:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
 d48:	2e2f6363 	cdpcs	3, 2, cr6, cr15, cr3, {3}
 d4c:	6e692f2e 	cdpvs	15, 6, cr2, cr9, cr14, {1}
 d50:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 d54:	2e2e0065 	cdpcs	0, 2, cr0, cr14, cr5, {3}
 d58:	2f2e2e2f 	svccs	0x002e2e2f
 d5c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 d60:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 d64:	672f2e2f 	strvs	r2, [pc, -pc, lsr #28]!
 d68:	2e006363 	cdpcs	3, 0, cr6, cr0, cr3, {3}
 d6c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 d70:	2f2e2e2f 	svccs	0x002e2e2f
 d74:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 d78:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 d7c:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
 d80:	2f636367 	svccs	0x00636367
 d84:	672f2e2e 	strvs	r2, [pc, -lr, lsr #28]!
 d88:	632f6363 			; <UNDEFINED> instruction: 0x632f6363
 d8c:	69666e6f 	stmdbvs	r6!, {r0, r1, r2, r3, r5, r6, r9, sl, fp, sp, lr}^
 d90:	72612f67 	rsbvc	r2, r1, #412	; 0x19c
 d94:	2e2e006d 	cdpcs	0, 2, cr0, cr14, cr13, {3}
 d98:	2f2e2e2f 	svccs	0x002e2e2f
 d9c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 da0:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 da4:	2f2e2e2f 	svccs	0x002e2e2f
 da8:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
 dac:	00006363 	andeq	r6, r0, r3, ror #6
 db0:	68736168 	ldmdavs	r3!, {r3, r5, r6, r8, sp, lr}^
 db4:	2e626174 	mcrcs	1, 3, r6, cr2, cr4, {3}
 db8:	00010068 	andeq	r0, r1, r8, rrx
 dbc:	6d726100 	ldfvse	f6, [r2, #-0]
 dc0:	6173692d 	cmnvs	r3, sp, lsr #18
 dc4:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 dc8:	72610000 	rsbvc	r0, r1, #0
 dcc:	70632d6d 	rsbvc	r2, r3, sp, ror #26
 dd0:	00682e75 	rsbeq	r2, r8, r5, ror lr
 dd4:	69000002 	stmdbvs	r0, {r1}
 dd8:	2d6e736e 	stclcs	3, cr7, [lr, #-440]!	; 0xfffffe48
 ddc:	736e6f63 	cmnvc	lr, #396	; 0x18c
 de0:	746e6174 	strbtvc	r6, [lr], #-372	; 0xfffffe8c
 de4:	00682e73 	rsbeq	r2, r8, r3, ror lr
 de8:	61000002 	tstvs	r0, r2
 dec:	682e6d72 	stmdavs	lr!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}
 df0:	00000300 	andeq	r0, r0, r0, lsl #6
 df4:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
 df8:	2e326363 	cdpcs	3, 3, cr6, cr2, cr3, {3}
 dfc:	00040068 	andeq	r0, r4, r8, rrx
 e00:	6c626700 	stclvs	7, cr6, [r2], #-0
 e04:	6f74632d 	svcvs	0x0074632d
 e08:	682e7372 	stmdavs	lr!, {r1, r4, r5, r6, r8, r9, ip, sp, lr}
 e0c:	00000400 	andeq	r0, r0, r0, lsl #8
 e10:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
 e14:	2e326363 	cdpcs	3, 3, cr6, cr2, cr3, {3}
 e18:	00040063 	andeq	r0, r4, r3, rrx
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
      20:	5b202965 	blpl	80a5bc <_bss_end+0x801374>
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
      88:	7a6a3637 	bvc	1a8d96c <_bss_end+0x1a84724>
      8c:	20732d66 	rsbscs	r2, r3, r6, ror #26
      90:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
      94:	6d2d206d 	stcvs	0, cr2, [sp, #-436]!	; 0xfffffe4c
      98:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
      9c:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
      a0:	6b7a3676 	blvs	1e8da80 <_bss_end+0x1e84838>
      a4:	2070662b 	rsbscs	r6, r0, fp, lsr #12
      a8:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
      ac:	4f2d2067 	svcmi	0x002d2067
      b0:	4f2d2030 	svcmi	0x002d2030
      b4:	5f5f0030 	svcpl	0x005f0030
      b8:	5f617863 	svcpl	0x00617863
      bc:	72617567 	rsbvc	r7, r1, #432013312	; 0x19c00000
      c0:	65725f64 	ldrbvs	r5, [r2, #-3940]!	; 0xfffff09c
      c4:	7361656c 	cmnvc	r1, #108, 10	; 0x1b000000
      c8:	682f0065 	stmdavs	pc!, {r0, r2, r5, r6}	; <UNPREDICTABLE>
      cc:	2f656d6f 	svccs	0x00656d6f
      d0:	686c6973 	stmdavs	ip!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
      d4:	6a797661 	bvs	1e5da60 <_bss_end+0x1e54818>
      d8:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
      dc:	2f6c6f6f 	svccs	0x006c6f6f
      e0:	6f72655a 	svcvs	0x0072655a
      e4:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
      e8:	6178652f 	cmnvs	r8, pc, lsr #10
      ec:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
      f0:	31312f73 	teqcc	r1, r3, ror pc
      f4:	6d69742d 	cfstrdvs	mvd7, [r9, #-180]!	; 0xffffff4c
      f8:	6e5f7265 	cdpvs	2, 5, cr7, cr15, cr5, {3}
      fc:	6c635f6f 	stclvs	15, cr5, [r3], #-444	; 0xfffffe44
     100:	5f726165 	svcpl	0x00726165
     104:	2f515249 	svccs	0x00515249
     108:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
     10c:	732f6c65 			; <UNDEFINED> instruction: 0x732f6c65
     110:	632f6372 			; <UNDEFINED> instruction: 0x632f6372
     114:	632e7878 			; <UNDEFINED> instruction: 0x632e7878
     118:	2f007070 	svccs	0x00007070
     11c:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     120:	6c69732f 	stclvs	3, cr7, [r9], #-188	; 0xffffff44
     124:	79766168 	ldmdbvc	r6!, {r3, r5, r6, r8, sp, lr}^
     128:	63532f6a 	cmpvs	r3, #424	; 0x1a8
     12c:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; ffffff94 <_bss_end+0xffff6d4c>
     130:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
     134:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
     138:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
     13c:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
     140:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
     144:	69742d31 	ldmdbvs	r4!, {r0, r4, r5, r8, sl, fp, sp}^
     148:	5f72656d 	svcpl	0x0072656d
     14c:	635f6f6e 	cmpvs	pc, #440	; 0x1b8
     150:	7261656c 	rsbvc	r6, r1, #108, 10	; 0x1b000000
     154:	5152495f 	cmppl	r2, pc, asr r9
     158:	6975622f 	ldmdbvs	r5!, {r0, r1, r2, r3, r5, r9, sp, lr}^
     15c:	5f00646c 	svcpl	0x0000646c
     160:	6178635f 	cmnvs	r8, pc, asr r3
     164:	6175675f 	cmnvs	r5, pc, asr r7
     168:	615f6472 	cmpvs	pc, r2, ror r4	; <UNPREDICTABLE>
     16c:	74726f62 	ldrbtvc	r6, [r2], #-3938	; 0xfffff09e
     170:	645f5f00 	ldrbvs	r5, [pc], #-3840	; 178 <CPSR_IRQ_INHIBIT+0xf8>
     174:	685f6f73 	ldmdavs	pc, {r0, r1, r4, r5, r6, r8, r9, sl, fp, sp, lr}^	; <UNPREDICTABLE>
     178:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     17c:	5f5f0065 	svcpl	0x005f0065
     180:	5f617863 	svcpl	0x00617863
     184:	78657461 	stmdavc	r5!, {r0, r5, r6, sl, ip, sp, lr}^
     188:	5f007469 	svcpl	0x00007469
     18c:	6178635f 	cmnvs	r8, pc, asr r3
     190:	6175675f 	cmnvs	r5, pc, asr r7
     194:	615f6472 	cmpvs	pc, r2, ror r4	; <UNPREDICTABLE>
     198:	69757163 	ldmdbvs	r5!, {r0, r1, r5, r6, r8, ip, sp, lr}^
     19c:	5f006572 	svcpl	0x00006572
     1a0:	7878635f 	ldmdavc	r8!, {r0, r1, r2, r3, r4, r6, r8, r9, sp, lr}^
     1a4:	76696261 	strbtvc	r6, [r9], -r1, ror #4
     1a8:	5f5f0031 	svcpl	0x005f0031
     1ac:	5f617863 	svcpl	0x00617863
     1b0:	65727570 	ldrbvs	r7, [r2, #-1392]!	; 0xfffffa90
     1b4:	7269765f 	rsbvc	r7, r9, #99614720	; 0x5f00000
     1b8:	6c617574 	cfstr64vs	mvdx7, [r1], #-464	; 0xfffffe30
     1bc:	615f5f00 	cmpvs	pc, r0, lsl #30
     1c0:	69626165 	stmdbvs	r2!, {r0, r2, r5, r6, r8, sp, lr}^
     1c4:	776e755f 			; <UNDEFINED> instruction: 0x776e755f
     1c8:	5f646e69 	svcpl	0x00646e69
     1cc:	5f707063 	svcpl	0x00707063
     1d0:	00317270 	eorseq	r7, r1, r0, ror r2
     1d4:	75675f5f 	strbvc	r5, [r7, #-3935]!	; 0xfffff0a1
     1d8:	00647261 	rsbeq	r7, r4, r1, ror #4
     1dc:	676e6f6c 	strbvs	r6, [lr, -ip, ror #30]!
     1e0:	6e6f6c20 	cdpvs	12, 6, cr6, cr15, cr0, {1}
     1e4:	6e692067 	cdpvs	0, 6, cr2, cr9, cr7, {3}
     1e8:	5a5f0074 	bpl	17c03c0 <_bss_end+0x17b7178>
     1ec:	33314b4e 	teqcc	r1, #79872	; 0x13800
     1f0:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     1f4:	61485f4f 	cmpvs	r8, pc, asr #30
     1f8:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     1fc:	47383172 			; <UNDEFINED> instruction: 0x47383172
     200:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     204:	56454c50 			; <UNDEFINED> instruction: 0x56454c50
     208:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     20c:	6f697461 	svcvs	0x00697461
     210:	526a456e 	rsbpl	r4, sl, #461373440	; 0x1b800000
     214:	5f30536a 	svcpl	0x0030536a
     218:	53504700 	cmppl	r0, #0, 14
     21c:	00305445 	eorseq	r5, r0, r5, asr #8
     220:	45535047 	ldrbmi	r5, [r3, #-71]	; 0xffffffb9
     224:	47003154 	smlsdmi	r0, r4, r1, r3
     228:	45534650 	ldrbmi	r4, [r3, #-1616]	; 0xfffff9b0
     22c:	4700304c 	strmi	r3, [r0, -ip, asr #32]
     230:	45534650 	ldrbmi	r4, [r3, #-1616]	; 0xfffff9b0
     234:	4700314c 	strmi	r3, [r0, -ip, asr #2]
     238:	45534650 	ldrbmi	r4, [r3, #-1616]	; 0xfffff9b0
     23c:	4700324c 	strmi	r3, [r0, -ip, asr #4]
     240:	45534650 	ldrbmi	r4, [r3, #-1616]	; 0xfffff9b0
     244:	4700334c 	strmi	r3, [r0, -ip, asr #6]
     248:	45534650 	ldrbmi	r4, [r3, #-1616]	; 0xfffff9b0
     24c:	4700344c 	strmi	r3, [r0, -ip, asr #8]
     250:	45534650 	ldrbmi	r4, [r3, #-1616]	; 0xfffff9b0
     254:	4700354c 	strmi	r3, [r0, -ip, asr #10]
     258:	4e454650 	mcrmi	6, 2, r4, cr5, cr0, {2}
     25c:	6e490031 	mcrvs	0, 2, r0, cr9, cr1, {1}
     260:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
     264:	5f747075 	svcpl	0x00747075
     268:	746e6f43 	strbtvc	r6, [lr], #-3907	; 0xfffff0bd
     26c:	6c6c6f72 	stclvs	15, cr6, [ip], #-456	; 0xfffffe38
     270:	425f7265 	subsmi	r7, pc, #1342177286	; 0x50000006
     274:	00657361 	rsbeq	r7, r5, r1, ror #6
     278:	5f746547 	svcpl	0x00746547
     27c:	495f5047 	ldmdbmi	pc, {r0, r1, r2, r6, ip, lr}^	; <UNPREDICTABLE>
     280:	445f5152 	ldrbmi	r5, [pc], #-338	; 288 <CPSR_IRQ_INHIBIT+0x208>
     284:	63657465 	cmnvs	r5, #1694498816	; 0x65000000
     288:	6f4c5f74 	svcvs	0x004c5f74
     28c:	69746163 	ldmdbvs	r4!, {r0, r1, r5, r6, r8, sp, lr}^
     290:	47006e6f 	strmi	r6, [r0, -pc, ror #28]
     294:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     298:	53444550 	movtpl	r4, #17744	; 0x4550
     29c:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     2a0:	6f697461 	svcvs	0x00697461
     2a4:	6948006e 	stmdbvs	r8, {r1, r2, r3, r5, r6}^
     2a8:	73006867 	movwvc	r6, #2151	; 0x867
     2ac:	74726f68 	ldrbtvc	r6, [r2], #-3944	; 0xfffff098
     2b0:	746e6920 	strbtvc	r6, [lr], #-2336	; 0xfffff6e0
     2b4:	50504700 	subspl	r4, r0, r0, lsl #14
     2b8:	4c434455 	cfstrdmi	mvd4, [r3], {85}	; 0x55
     2bc:	4700304b 	strmi	r3, [r0, -fp, asr #32]
     2c0:	44555050 	ldrbmi	r5, [r5], #-80	; 0xffffffb0
     2c4:	314b4c43 	cmpcc	fp, r3, asr #24
     2c8:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     2cc:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     2d0:	5f4f4950 	svcpl	0x004f4950
     2d4:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     2d8:	3172656c 	cmncc	r2, ip, ror #10
     2dc:	616e4539 	cmnvs	lr, r9, lsr r5
     2e0:	5f656c62 	svcpl	0x00656c62
     2e4:	6e657645 	cdpvs	6, 6, cr7, cr5, cr5, {2}
     2e8:	65445f74 	strbvs	r5, [r4, #-3956]	; 0xfffff08c
     2ec:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
     2f0:	30326a45 	eorscc	r6, r2, r5, asr #20
     2f4:	4950474e 	ldmdbmi	r0, {r1, r2, r3, r6, r8, r9, sl, lr}^
     2f8:	6e495f4f 	cdpvs	15, 4, cr5, cr9, cr15, {2}
     2fc:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
     300:	5f747075 	svcpl	0x00747075
     304:	65707954 	ldrbvs	r7, [r0, #-2388]!	; 0xfffff6ac
     308:	52504700 	subspl	r4, r0, #0, 14
     30c:	00304e45 	eorseq	r4, r0, r5, asr #28
     310:	45525047 	ldrbmi	r5, [r2, #-71]	; 0xffffffb9
     314:	5f00314e 	svcpl	0x0000314e
     318:	33314e5a 	teqcc	r1, #1440	; 0x5a0
     31c:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     320:	61485f4f 	cmpvs	r8, pc, asr #30
     324:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     328:	53303172 	teqpl	r0, #-2147483620	; 0x8000001c
     32c:	4f5f7465 	svcmi	0x005f7465
     330:	75707475 	ldrbvc	r7, [r0, #-1141]!	; 0xfffffb8b
     334:	626a4574 	rsbvs	r4, sl, #116, 10	; 0x1d000000
     338:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     33c:	4333314b 	teqmi	r3, #-1073741806	; 0xc0000012
     340:	4f495047 	svcmi	0x00495047
     344:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     348:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     34c:	65473931 	strbvs	r3, [r7, #-2353]	; 0xfffff6cf
     350:	50475f74 	subpl	r5, r7, r4, ror pc
     354:	4c455346 	mcrrmi	3, 4, r5, r5, cr6
     358:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     35c:	6f697461 	svcvs	0x00697461
     360:	526a456e 	rsbpl	r4, sl, #461373440	; 0x1b800000
     364:	5f30536a 	svcpl	0x0030536a
     368:	50476d00 	subpl	r6, r7, r0, lsl #26
     36c:	5f004f49 	svcpl	0x00004f49
     370:	33314e5a 	teqcc	r1, #1440	; 0x5a0
     374:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     378:	61485f4f 	cmpvs	r8, pc, asr #30
     37c:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     380:	45344372 	ldrmi	r4, [r4, #-882]!	; 0xfffffc8e
     384:	6975006a 	ldmdbvs	r5!, {r1, r3, r5, r6}^
     388:	5f38746e 	svcpl	0x0038746e
     38c:	50470074 	subpl	r0, r7, r4, ror r0
     390:	30534445 	subscc	r4, r3, r5, asr #8
     394:	45504700 	ldrbmi	r4, [r0, #-1792]	; 0xfffff900
     398:	00315344 	eorseq	r5, r1, r4, asr #6
     39c:	746e6975 	strbtvc	r6, [lr], #-2421	; 0xfffff68b
     3a0:	745f3233 	ldrbvc	r3, [pc], #-563	; 3a8 <CPSR_IRQ_INHIBIT+0x328>
     3a4:	6f6f6200 	svcvs	0x006f6200
     3a8:	6e55006c 	cdpvs	0, 5, cr0, cr5, cr12, {3}
     3ac:	63657073 	cmnvs	r5, #115	; 0x73
     3b0:	65696669 	strbvs	r6, [r9, #-1641]!	; 0xfffff997
     3b4:	6c430064 	mcrrvs	0, 6, r0, r3, cr4
     3b8:	5f726165 	svcpl	0x00726165
     3bc:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
     3c0:	64657463 	strbtvs	r7, [r5], #-1123	; 0xfffffb9d
     3c4:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
     3c8:	4700746e 	strmi	r7, [r0, -lr, ror #8]
     3cc:	4e454c50 	mcrmi	12, 2, r4, cr5, cr0, {2}
     3d0:	5a5f0030 	bpl	17c0498 <_bss_end+0x17b7250>
     3d4:	33314b4e 	teqcc	r1, #79872	; 0x13800
     3d8:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     3dc:	61485f4f 	cmpvs	r8, pc, asr #30
     3e0:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     3e4:	47363272 			; <UNDEFINED> instruction: 0x47363272
     3e8:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     3ec:	52495f50 	subpl	r5, r9, #80, 30	; 0x140
     3f0:	65445f51 	strbvs	r5, [r4, #-3921]	; 0xfffff0af
     3f4:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
     3f8:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     3fc:	6f697461 	svcvs	0x00697461
     400:	326a456e 	rsbcc	r4, sl, #461373440	; 0x1b800000
     404:	50474e30 	subpl	r4, r7, r0, lsr lr
     408:	495f4f49 	ldmdbmi	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     40c:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
     410:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
     414:	7079545f 	rsbsvc	r5, r9, pc, asr r4
     418:	536a5265 	cmnpl	sl, #1342177286	; 0x50000006
     41c:	47005f31 	smladxmi	r0, r1, pc, r5	; <UNPREDICTABLE>
     420:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     424:	5f4f4950 	svcpl	0x004f4950
     428:	636e7546 	cmnvs	lr, #293601280	; 0x11800000
     42c:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     430:	50474300 	subpl	r4, r7, r0, lsl #6
     434:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     438:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     43c:	47007265 	strmi	r7, [r0, -r5, ror #4]
     440:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     444:	54455350 	strbpl	r5, [r5], #-848	; 0xfffffcb0
     448:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     44c:	6f697461 	svcvs	0x00697461
     450:	5047006e 	subpl	r0, r7, lr, rrx
     454:	00445550 	subeq	r5, r4, r0, asr r5
     458:	314e5a5f 	cmpcc	lr, pc, asr sl
     45c:	50474333 	subpl	r4, r7, r3, lsr r3
     460:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     464:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     468:	30327265 	eorscc	r7, r2, r5, ror #4
     46c:	61656c43 	cmnvs	r5, r3, asr #24
     470:	65445f72 	strbvs	r5, [r4, #-3954]	; 0xfffff08e
     474:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
     478:	455f6465 	ldrbmi	r6, [pc, #-1125]	; 1b <CPSR_MODE_SVR+0x8>
     47c:	746e6576 	strbtvc	r6, [lr], #-1398	; 0xfffffa8a
     480:	50006a45 	andpl	r6, r0, r5, asr #20
     484:	70697265 	rsbvc	r7, r9, r5, ror #4
     488:	61726568 	cmnvs	r2, r8, ror #10
     48c:	61425f6c 	cmpvs	r2, ip, ror #30
     490:	47006573 	smlsdxmi	r0, r3, r5, r6
     494:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     498:	56454c50 			; <UNDEFINED> instruction: 0x56454c50
     49c:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     4a0:	6f697461 	svcvs	0x00697461
     4a4:	5a5f006e 	bpl	17c0664 <_bss_end+0x17b741c>
     4a8:	33314b4e 	teqcc	r1, #79872	; 0x13800
     4ac:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     4b0:	61485f4f 	cmpvs	r8, pc, asr #30
     4b4:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     4b8:	47373172 			; <UNDEFINED> instruction: 0x47373172
     4bc:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     4c0:	5f4f4950 	svcpl	0x004f4950
     4c4:	636e7546 	cmnvs	lr, #293601280	; 0x11800000
     4c8:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     4cc:	5f006a45 	svcpl	0x00006a45
     4d0:	696e695f 	stmdbvs	lr!, {r0, r1, r2, r3, r4, r6, r8, fp, sp, lr}^
     4d4:	6c616974 			; <UNDEFINED> instruction: 0x6c616974
     4d8:	5f657a69 	svcpl	0x00657a69
     4dc:	5a5f0070 	bpl	17c06a4 <_bss_end+0x17b745c>
     4e0:	4333314e 	teqmi	r3, #-2147483629	; 0x80000013
     4e4:	4f495047 	svcmi	0x00495047
     4e8:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     4ec:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     4f0:	6a453243 	bvs	114ce04 <_bss_end+0x1143bbc>
     4f4:	41504700 	cmpmi	r0, r0, lsl #14
     4f8:	304e4546 	subcc	r4, lr, r6, asr #10
     4fc:	41504700 	cmpmi	r0, r0, lsl #14
     500:	314e4546 	cmpcc	lr, r6, asr #10
     504:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     508:	4333314b 	teqmi	r3, #-1073741806	; 0xc0000012
     50c:	4f495047 	svcmi	0x00495047
     510:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     514:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     518:	65473831 	strbvs	r3, [r7, #-2097]	; 0xfffff7cf
     51c:	50475f74 	subpl	r5, r7, r4, ror pc
     520:	5f524c43 	svcpl	0x00524c43
     524:	61636f4c 	cmnvs	r3, ip, asr #30
     528:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     52c:	6a526a45 	bvs	149ae48 <_bss_end+0x1491c00>
     530:	005f3053 	subseq	r3, pc, r3, asr r0	; <UNPREDICTABLE>
     534:	69736e75 	ldmdbvs	r3!, {r0, r2, r4, r5, r6, r9, sl, fp, sp, lr}^
     538:	64656e67 	strbtvs	r6, [r5], #-3687	; 0xfffff199
     53c:	61686320 	cmnvs	r8, r0, lsr #6
     540:	50470072 	subpl	r0, r7, r2, ror r0
     544:	425f4f49 	subsmi	r4, pc, #292	; 0x124
     548:	00657361 	rsbeq	r7, r5, r1, ror #6
     54c:	4c435047 	mcrrmi	0, 4, r5, r3, cr7
     550:	47003152 	smlsdmi	r0, r2, r1, r3
     554:	45524150 	ldrbmi	r4, [r2, #-336]	; 0xfffffeb0
     558:	4700304e 	strmi	r3, [r0, -lr, asr #32]
     55c:	45524150 	ldrbmi	r4, [r2, #-336]	; 0xfffffeb0
     560:	4700314e 	strmi	r3, [r0, -lr, asr #2]
     564:	4e454850 	mcrmi	8, 2, r4, cr5, cr0, {2}
     568:	50470030 	subpl	r0, r7, r0, lsr r0
     56c:	314e4548 	cmpcc	lr, r8, asr #10
     570:	69706700 	ldmdbvs	r0!, {r8, r9, sl, sp, lr}^
     574:	61625f6f 	cmnvs	r2, pc, ror #30
     578:	615f6573 	cmpvs	pc, r3, ror r5	; <UNPREDICTABLE>
     57c:	00726464 	rsbseq	r6, r2, r4, ror #8
     580:	726f6873 	rsbvc	r6, pc, #7536640	; 0x730000
     584:	6e752074 	mrcvs	0, 3, r2, cr5, cr4, {3}
     588:	6e676973 			; <UNDEFINED> instruction: 0x6e676973
     58c:	69206465 	stmdbvs	r0!, {r0, r2, r5, r6, sl, sp, lr}
     590:	4700746e 	strmi	r7, [r0, -lr, ror #8]
     594:	4e454c50 	mcrmi	12, 2, r4, cr5, cr0, {2}
     598:	6e450031 	mcrvs	0, 2, r0, cr5, cr1, {1}
     59c:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     5a0:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
     5a4:	445f746e 	ldrbmi	r7, [pc], #-1134	; 5ac <CPSR_IRQ_INHIBIT+0x52c>
     5a8:	63657465 	cmnvs	r5, #1694498816	; 0x65000000
     5ac:	5a5f0074 	bpl	17c0784 <_bss_end+0x17b753c>
     5b0:	33314b4e 	teqcc	r1, #79872	; 0x13800
     5b4:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     5b8:	61485f4f 	cmpvs	r8, pc, asr #30
     5bc:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     5c0:	47383172 			; <UNDEFINED> instruction: 0x47383172
     5c4:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     5c8:	53444550 	movtpl	r4, #17744	; 0x4550
     5cc:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     5d0:	6f697461 	svcvs	0x00697461
     5d4:	526a456e 	rsbpl	r4, sl, #461373440	; 0x1b800000
     5d8:	5f30536a 	svcpl	0x0030536a
     5dc:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     5e0:	4650475f 			; <UNDEFINED> instruction: 0x4650475f
     5e4:	5f4c4553 	svcpl	0x004c4553
     5e8:	61636f4c 	cmnvs	r3, ip, asr #30
     5ec:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     5f0:	49504700 	ldmdbmi	r0, {r8, r9, sl, lr}^
     5f4:	69505f4f 	ldmdbvs	r0, {r0, r1, r2, r3, r6, r8, r9, sl, fp, ip, lr}^
     5f8:	6f435f6e 	svcvs	0x00435f6e
     5fc:	00746e75 	rsbseq	r6, r4, r5, ror lr
     600:	636e7566 	cmnvs	lr, #427819008	; 0x19800000
     604:	6d695400 	cfstrdvs	mvd5, [r9, #-0]
     608:	425f7265 	subsmi	r7, pc, #1342177286	; 0x50000006
     60c:	00657361 	rsbeq	r7, r5, r1, ror #6
     610:	74735f5f 	ldrbtvc	r5, [r3], #-3935	; 0xfffff0a1
     614:	63697461 	cmnvs	r9, #1627389952	; 0x61000000
     618:	696e695f 	stmdbvs	lr!, {r0, r1, r2, r3, r4, r6, r8, fp, sp, lr}^
     61c:	6c616974 			; <UNDEFINED> instruction: 0x6c616974
     620:	74617a69 	strbtvc	r7, [r1], #-2665	; 0xfffff597
     624:	5f6e6f69 	svcpl	0x006e6f69
     628:	5f646e61 	svcpl	0x00646e61
     62c:	74736564 	ldrbtvc	r6, [r3], #-1380	; 0xfffffa9c
     630:	74637572 	strbtvc	r7, [r3], #-1394	; 0xfffffa8e
     634:	5f6e6f69 	svcpl	0x006e6f69
     638:	50470030 	subpl	r0, r7, r0, lsr r0
     63c:	525f4f49 	subspl	r4, pc, #292	; 0x124
     640:	74006765 	strvc	r6, [r0], #-1893	; 0xfffff89b
     644:	00736968 	rsbseq	r6, r3, r8, ror #18
     648:	314e5a5f 	cmpcc	lr, pc, asr sl
     64c:	50474333 	subpl	r4, r7, r3, lsr r3
     650:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     654:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     658:	30327265 	eorscc	r7, r2, r5, ror #4
     65c:	61736944 	cmnvs	r3, r4, asr #18
     660:	5f656c62 	svcpl	0x00656c62
     664:	6e657645 	cdpvs	6, 6, cr7, cr5, cr5, {2}
     668:	65445f74 	strbvs	r5, [r4, #-3956]	; 0xfffff08c
     66c:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
     670:	30326a45 	eorscc	r6, r2, r5, asr #20
     674:	4950474e 	ldmdbmi	r0, {r1, r2, r3, r6, r8, r9, sl, lr}^
     678:	6e495f4f 	cdpvs	15, 4, cr5, cr9, cr15, {2}
     67c:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
     680:	5f747075 	svcpl	0x00747075
     684:	65707954 	ldrbvs	r7, [r0, #-2388]!	; 0xfffff6ac
     688:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     68c:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     690:	5f4f4950 	svcpl	0x004f4950
     694:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     698:	3172656c 	cmncc	r2, ip, ror #10
     69c:	74655337 	strbtvc	r5, [r5], #-823	; 0xfffffcc9
     6a0:	4950475f 	ldmdbmi	r0, {r0, r1, r2, r3, r4, r6, r8, r9, sl, lr}^
     6a4:	75465f4f 	strbvc	r5, [r6, #-3919]	; 0xfffff0b1
     6a8:	6974636e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, r9, sp, lr}^
     6ac:	6a456e6f 	bvs	115c070 <_bss_end+0x1152e28>
     6b0:	474e3431 	smlaldxmi	r3, lr, r1, r4
     6b4:	5f4f4950 	svcpl	0x004f4950
     6b8:	636e7546 	cmnvs	lr, #293601280	; 0x11800000
     6bc:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     6c0:	73695200 	cmnvc	r9, #0, 4
     6c4:	5f676e69 	svcpl	0x00676e69
     6c8:	65676445 	strbvs	r6, [r7, #-1093]!	; 0xfffffbbb
     6cc:	746c4100 	strbtvc	r4, [ip], #-256	; 0xffffff00
     6d0:	4700325f 	smlsdmi	r0, pc, r2, r3	; <UNPREDICTABLE>
     6d4:	56454c50 			; <UNDEFINED> instruction: 0x56454c50
     6d8:	50470030 	subpl	r0, r7, r0, lsr r0
     6dc:	3156454c 	cmpcc	r6, ip, asr #10
     6e0:	74655300 	strbtvc	r5, [r5], #-768	; 0xfffffd00
     6e4:	4950475f 	ldmdbmi	r0, {r0, r1, r2, r3, r4, r6, r8, r9, sl, lr}^
     6e8:	75465f4f 	strbvc	r5, [r6, #-3919]	; 0xfffff0b1
     6ec:	6974636e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, r9, sp, lr}^
     6f0:	62006e6f 	andvs	r6, r0, #1776	; 0x6f0
     6f4:	695f7469 	ldmdbvs	pc, {r0, r3, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
     6f8:	5f007864 	svcpl	0x00007864
     6fc:	6972705f 	ldmdbvs	r2!, {r0, r1, r2, r3, r4, r6, ip, sp, lr}^
     700:	7469726f 	strbtvc	r7, [r9], #-623	; 0xfffffd91
     704:	5a5f0079 	bpl	17c08f0 <_bss_end+0x17b76a8>
     708:	33314b4e 	teqcc	r1, #79872	; 0x13800
     70c:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     710:	61485f4f 	cmpvs	r8, pc, asr #30
     714:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     718:	47383172 			; <UNDEFINED> instruction: 0x47383172
     71c:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     720:	54455350 	strbpl	r5, [r5], #-848	; 0xfffffcb0
     724:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     728:	6f697461 	svcvs	0x00697461
     72c:	526a456e 	rsbpl	r4, sl, #461373440	; 0x1b800000
     730:	5f30536a 	svcpl	0x0030536a
     734:	58554100 	ldmdapl	r5, {r8, lr}^
     738:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
     73c:	65470065 	strbvs	r0, [r7, #-101]	; 0xffffff9b
     740:	50475f74 	subpl	r5, r7, r4, ror pc
     744:	5f524c43 	svcpl	0x00524c43
     748:	61636f4c 	cmnvs	r3, ip, asr #30
     74c:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     750:	706e4900 	rsbvc	r4, lr, r0, lsl #18
     754:	47007475 	smlsdxmi	r0, r5, r4, r7
     758:	4e454650 	mcrmi	6, 2, r4, cr5, cr0, {2}
     75c:	65530030 	ldrbvs	r0, [r3, #-48]	; 0xffffffd0
     760:	754f5f74 	strbvc	r5, [pc, #-3956]	; fffff7f4 <_bss_end+0xffff65ac>
     764:	74757074 	ldrbtvc	r7, [r5], #-116	; 0xffffff8c
     768:	6f682f00 	svcvs	0x00682f00
     76c:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
     770:	61686c69 	cmnvs	r8, r9, ror #24
     774:	2f6a7976 	svccs	0x006a7976
     778:	6f686353 	svcvs	0x00686353
     77c:	5a2f6c6f 	bpl	bdb940 <_bss_end+0xbd26f8>
     780:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 5f4 <CPSR_IRQ_INHIBIT+0x574>
     784:	2f657461 	svccs	0x00657461
     788:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
     78c:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
     790:	2d31312f 	ldfcss	f3, [r1, #-188]!	; 0xffffff44
     794:	656d6974 	strbvs	r6, [sp, #-2420]!	; 0xfffff68c
     798:	6f6e5f72 	svcvs	0x006e5f72
     79c:	656c635f 	strbvs	r6, [ip, #-863]!	; 0xfffffca1
     7a0:	495f7261 	ldmdbmi	pc, {r0, r5, r6, r9, ip, sp, lr}^	; <UNPREDICTABLE>
     7a4:	6b2f5152 	blvs	bd4cf4 <_bss_end+0xbcbaac>
     7a8:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
     7ac:	72732f6c 	rsbsvc	r2, r3, #108, 30	; 0x1b0
     7b0:	72642f63 	rsbvc	r2, r4, #396	; 0x18c
     7b4:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
     7b8:	70672f73 	rsbvc	r2, r7, r3, ror pc
     7bc:	632e6f69 			; <UNDEFINED> instruction: 0x632e6f69
     7c0:	5f007070 	svcpl	0x00007070
     7c4:	424f4c47 	submi	r4, pc, #18176	; 0x4700
     7c8:	5f5f4c41 	svcpl	0x005f4c41
     7cc:	5f627573 	svcpl	0x00627573
     7d0:	47735f49 	ldrbmi	r5, [r3, -r9, asr #30]!
     7d4:	004f4950 	subeq	r4, pc, r0, asr r9	; <UNPREDICTABLE>
     7d8:	61736944 	cmnvs	r3, r4, asr #18
     7dc:	5f656c62 	svcpl	0x00656c62
     7e0:	6e657645 	cdpvs	6, 6, cr7, cr5, cr5, {2}
     7e4:	65445f74 	strbvs	r5, [r4, #-3956]	; 0xfffff08c
     7e8:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
     7ec:	6c614600 	stclvs	6, cr4, [r1], #-0
     7f0:	676e696c 	strbvs	r6, [lr, -ip, ror #18]!
     7f4:	6764455f 			; <UNDEFINED> instruction: 0x6764455f
     7f8:	6c410065 	mcrrvs	0, 6, r0, r1, cr5
     7fc:	00305f74 	eorseq	r5, r0, r4, ror pc
     800:	5f746c41 	svcpl	0x00746c41
     804:	65440031 	strbvs	r0, [r4, #-49]	; 0xffffffcf
     808:	6c756166 	ldfvse	f6, [r5], #-408	; 0xfffffe68
     80c:	6c435f74 	mcrrvs	15, 7, r5, r3, cr4
     810:	5f6b636f 	svcpl	0x006b636f
     814:	65746152 	ldrbvs	r6, [r4, #-338]!	; 0xfffffeae
     818:	746c4100 	strbtvc	r4, [ip], #-256	; 0xffffff00
     81c:	4100335f 	tstmi	r0, pc, asr r3
     820:	345f746c 	ldrbcc	r7, [pc], #-1132	; 828 <CPSR_IRQ_INHIBIT+0x7a8>
     824:	746c4100 	strbtvc	r4, [ip], #-256	; 0xffffff00
     828:	4700355f 	smlsdmi	r0, pc, r5, r3	; <UNPREDICTABLE>
     82c:	524c4350 	subpl	r4, ip, #80, 6	; 0x40000001
     830:	475f0030 	smmlarmi	pc, r0, r0, r0	; <UNPREDICTABLE>
     834:	41424f4c 	cmpmi	r2, ip, asr #30
     838:	735f5f4c 	cmpvc	pc, #76, 30	; 0x130
     83c:	495f6275 	ldmdbmi	pc, {r0, r2, r4, r5, r6, r9, sp, lr}^	; <UNPREDICTABLE>
     840:	6954735f 	ldmdbvs	r4, {r0, r1, r2, r3, r4, r6, r8, r9, ip, sp, lr}^
     844:	0072656d 	rsbseq	r6, r2, sp, ror #10
     848:	364e5a5f 			; <UNDEFINED> instruction: 0x364e5a5f
     84c:	6d695443 	cfstrdvs	mvd5, [r9, #-268]!	; 0xfffffef4
     850:	30327265 	eorscc	r7, r2, r5, ror #4
     854:	545f7349 	ldrbpl	r7, [pc], #-841	; 85c <CPSR_IRQ_INHIBIT+0x7dc>
     858:	72656d69 	rsbvc	r6, r5, #6720	; 0x1a40
     85c:	5152495f 	cmppl	r2, pc, asr r9
     860:	6e65505f 	mcrvs	0, 3, r5, cr5, cr15, {2}
     864:	676e6964 	strbvs	r6, [lr, -r4, ror #18]!
     868:	68007645 	stmdavs	r0, {r0, r2, r6, r9, sl, ip, sp, lr}
     86c:	5f746c61 	svcpl	0x00746c61
     870:	645f6e69 	ldrbvs	r6, [pc], #-3689	; 878 <CPSR_IRQ_INHIBIT+0x7f8>
     874:	67756265 	ldrbvs	r6, [r5, -r5, ror #4]!
     878:	6572625f 	ldrbvs	r6, [r2, #-607]!	; 0xfffffda1
     87c:	5f006b61 	svcpl	0x00006b61
     880:	43364e5a 	teqmi	r6, #1440	; 0x5a0
     884:	656d6954 	strbvs	r6, [sp, #-2388]!	; 0xfffff6ac
     888:	45324372 	ldrmi	r4, [r2, #-882]!	; 0xfffffc8e
     88c:	6552006d 	ldrbvs	r0, [r2, #-109]	; 0xffffff93
     890:	64616f6c 	strbtvs	r6, [r1], #-3948	; 0xfffff094
     894:	51524900 	cmppl	r2, r0, lsl #18
     898:	6c61435f 	stclvs	3, cr4, [r1], #-380	; 0xfffffe84
     89c:	6361626c 	cmnvs	r1, #108, 4	; 0xc0000006
     8a0:	5249006b 	subpl	r0, r9, #107	; 0x6b
     8a4:	614d5f51 	cmpvs	sp, r1, asr pc
     8a8:	64656b73 	strbtvs	r6, [r5], #-2931	; 0xfffff48d
     8ac:	6c656400 	cfstrdvs	mvd6, [r5], #-0
     8b0:	75007961 	strvc	r7, [r0, #-2401]	; 0xfffff69f
     8b4:	6573756e 	ldrbvs	r7, [r3, #-1390]!	; 0xfffffa92
     8b8:	00305f64 	eorseq	r5, r0, r4, ror #30
     8bc:	73756e75 	cmnvc	r5, #1872	; 0x750
     8c0:	315f6465 	cmpcc	pc, r5, ror #8
     8c4:	756e7500 	strbvc	r7, [lr, #-1280]!	; 0xfffffb00
     8c8:	5f646573 	svcpl	0x00646573
     8cc:	6e750032 	mrcvs	0, 3, r0, cr5, cr2, {1}
     8d0:	64657375 	strbtvs	r7, [r5], #-885	; 0xfffffc8b
     8d4:	7500335f 	strvc	r3, [r0, #-863]	; 0xfffffca1
     8d8:	6573756e 	ldrbvs	r7, [r3, #-1390]!	; 0xfffffa92
     8dc:	00345f64 	eorseq	r5, r4, r4, ror #30
     8e0:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
     8e4:	5f726574 	svcpl	0x00726574
     8e8:	00623233 	rsbeq	r3, r2, r3, lsr r2
     8ec:	73657250 	cmnvc	r5, #80, 4
     8f0:	656c6163 	strbvs	r6, [ip, #-355]!	; 0xfffffe9d
     8f4:	35325f72 	ldrcc	r5, [r2, #-3954]!	; 0xfffff08e
     8f8:	5a5f0036 	bpl	17c09d8 <_bss_end+0x17b7790>
     8fc:	5443364e 	strbpl	r3, [r3], #-1614	; 0xfffff9b2
     900:	72656d69 	rsbvc	r6, r5, #6720	; 0x1a40
     904:	616e4536 	cmnvs	lr, r6, lsr r5
     908:	45656c62 	strbmi	r6, [r5, #-3170]!	; 0xfffff39e
     90c:	76764650 			; <UNDEFINED> instruction: 0x76764650
     910:	36316a45 	ldrtcc	r6, [r1], -r5, asr #20
     914:	6d69544e 	cfstrdvs	mvd5, [r9, #-312]!	; 0xfffffec8
     918:	505f7265 	subspl	r7, pc, r5, ror #4
     91c:	63736572 	cmnvs	r3, #478150656	; 0x1c800000
     920:	72656c61 	rsbvc	r6, r5, #24832	; 0x6100
     924:	65726600 	ldrbvs	r6, [r2, #-1536]!	; 0xfffffa00
     928:	75725f65 	ldrbvc	r5, [r2, #-3941]!	; 0xfffff09b
     92c:	6e696e6e 	cdpvs	14, 6, cr6, cr9, cr14, {3}
     930:	72705f67 	rsbsvc	r5, r0, #412	; 0x19c
     934:	61637365 	cmnvs	r3, r5, ror #6
     938:	0072656c 	rsbseq	r6, r2, ip, ror #10
     93c:	73657250 	cmnvc	r5, #80, 4
     940:	656c6163 	strbvs	r6, [ip, #-355]!	; 0xfffffe9d
     944:	00315f72 	eorseq	r5, r1, r2, ror pc
     948:	65657266 	strbvs	r7, [r5, #-614]!	; 0xfffffd9a
     94c:	6e75725f 	mrcvs	2, 3, r7, cr5, cr15, {2}
     950:	676e696e 	strbvs	r6, [lr, -lr, ror #18]!
     954:	616e655f 	cmnvs	lr, pc, asr r5
     958:	00656c62 	rsbeq	r6, r5, r2, ror #24
     95c:	5f515249 	svcpl	0x00515249
     960:	61656c43 	cmnvs	r5, r3, asr #24
     964:	72500072 	subsvc	r0, r0, #114	; 0x72
     968:	61637365 	cmnvs	r3, r5, ror #6
     96c:	5f72656c 	svcpl	0x0072656c
     970:	6d003631 	stcvs	6, cr3, [r0, #-196]	; 0xffffff3c
     974:	656d6954 	strbvs	r6, [sp, #-2388]!	; 0xfffff6ac
     978:	65525f72 	ldrbvs	r5, [r2, #-3954]	; 0xfffff08e
     97c:	56007367 	strpl	r7, [r0], -r7, ror #6
     980:	65756c61 	ldrbvs	r6, [r5, #-3169]!	; 0xfffff39f
     984:	746e6900 	strbtvc	r6, [lr], #-2304	; 0xfffff700
     988:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
     98c:	655f7470 	ldrbvs	r7, [pc, #-1136]	; 524 <CPSR_IRQ_INHIBIT+0x4a4>
     990:	6c62616e 	stfvse	f6, [r2], #-440	; 0xfffffe48
     994:	75006465 	strvc	r6, [r0, #-1125]	; 0xfffffb9b
     998:	31746e69 	cmncc	r4, r9, ror #28
     99c:	00745f36 	rsbseq	r5, r4, r6, lsr pc
     9a0:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 8ec <CPSR_IRQ_INHIBIT+0x86c>
     9a4:	69732f65 	ldmdbvs	r3!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
     9a8:	7661686c 	strbtvc	r6, [r1], -ip, ror #16
     9ac:	532f6a79 			; <UNDEFINED> instruction: 0x532f6a79
     9b0:	6f6f6863 	svcvs	0x006f6863
     9b4:	655a2f6c 	ldrbvs	r2, [sl, #-3948]	; 0xfffff094
     9b8:	614d6f72 	hvcvs	55026	; 0xd6f2
     9bc:	652f6574 	strvs	r6, [pc, #-1396]!	; 450 <CPSR_IRQ_INHIBIT+0x3d0>
     9c0:	706d6178 	rsbvc	r6, sp, r8, ror r1
     9c4:	2f73656c 	svccs	0x0073656c
     9c8:	742d3131 	strtvc	r3, [sp], #-305	; 0xfffffecf
     9cc:	72656d69 	rsbvc	r6, r5, #6720	; 0x1a40
     9d0:	5f6f6e5f 	svcpl	0x006f6e5f
     9d4:	61656c63 	cmnvs	r5, r3, ror #24
     9d8:	52495f72 	subpl	r5, r9, #456	; 0x1c8
     9dc:	656b2f51 	strbvs	r2, [fp, #-3921]!	; 0xfffff0af
     9e0:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
     9e4:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
     9e8:	6972642f 	ldmdbvs	r2!, {r0, r1, r2, r3, r5, sl, sp, lr}^
     9ec:	73726576 	cmnvc	r2, #494927872	; 0x1d800000
     9f0:	6d69742f 	cfstrdvs	mvd7, [r9, #-188]!	; 0xffffff44
     9f4:	632e7265 			; <UNDEFINED> instruction: 0x632e7265
     9f8:	50007070 	andpl	r7, r0, r0, ror r0
     9fc:	445f6572 	ldrbmi	r6, [pc], #-1394	; a04 <CPSR_IRQ_INHIBIT+0x984>
     a00:	64697669 	strbtvs	r7, [r9], #-1641	; 0xfffff997
     a04:	54007265 	strpl	r7, [r0], #-613	; 0xfffffd9b
     a08:	72656d69 	rsbvc	r6, r5, #6720	; 0x1a40
     a0c:	6765525f 			; <UNDEFINED> instruction: 0x6765525f
     a10:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     a14:	69544336 	ldmdbvs	r4, {r1, r2, r4, r5, r8, r9, lr}^
     a18:	3772656d 	ldrbcc	r6, [r2, -sp, ror #10]!
     a1c:	61736944 	cmnvs	r3, r4, asr #18
     a20:	45656c62 	strbmi	r6, [r5, #-3170]!	; 0xfffff39e
     a24:	69740076 	ldmdbvs	r4!, {r1, r2, r4, r5, r6}^
     a28:	5f72656d 	svcpl	0x0072656d
     a2c:	5f676572 	svcpl	0x00676572
     a30:	65736162 	ldrbvs	r6, [r3, #-354]!	; 0xfffffe9e
     a34:	6d697400 	cfstrdvs	mvd7, [r9, #-0]
     a38:	655f7265 	ldrbvs	r7, [pc, #-613]	; 7db <CPSR_IRQ_INHIBIT+0x75b>
     a3c:	6c62616e 	stfvse	f6, [r2], #-440	; 0xfffffe48
     a40:	54006465 	strpl	r6, [r0], #-1125	; 0xfffffb9b
     a44:	656d6954 	strbvs	r6, [sp, #-2388]!	; 0xfffff6ac
     a48:	74435f72 	strbvc	r5, [r3], #-3954	; 0xfffff08e
     a4c:	6c465f6c 	mcrrvs	15, 6, r5, r6, cr12
     a50:	00736761 	rsbseq	r6, r3, r1, ror #14
     a54:	64616f4c 	strbtvs	r6, [r1], #-3916	; 0xfffff0b4
     a58:	69544300 	ldmdbvs	r4, {r8, r9, lr}^
     a5c:	0072656d 	rsbseq	r6, r2, sp, ror #10
     a60:	6c61436d 	stclvs	3, cr4, [r1], #-436	; 0xfffffe4c
     a64:	6361626c 	cmnvs	r1, #108, 4	; 0xc0000006
     a68:	5a5f006b 	bpl	17c0c1c <_bss_end+0x17b79d4>
     a6c:	5443364e 	strbpl	r3, [r3], #-1614	; 0xfffff9b2
     a70:	72656d69 	rsbvc	r6, r5, #6720	; 0x1a40
     a74:	67655234 			; <UNDEFINED> instruction: 0x67655234
     a78:	334e4573 	movtcc	r4, #58739	; 0xe573
     a7c:	396c6168 	stmdbcc	ip!, {r3, r5, r6, r8, sp, lr}^
     a80:	656d6954 	strbvs	r6, [sp, #-2388]!	; 0xfffff6ac
     a84:	65525f72 	ldrbvs	r5, [r2, #-3954]	; 0xfffff08e
     a88:	5f004567 	svcpl	0x00004567
     a8c:	43364e5a 	teqmi	r6, #1440	; 0x5a0
     a90:	656d6954 	strbvs	r6, [sp, #-2388]!	; 0xfffff6ac
     a94:	45344372 	ldrmi	r4, [r4, #-882]!	; 0xfffffc8e
     a98:	7246006d 	subvc	r0, r6, #109	; 0x6d
     a9c:	525f6565 	subspl	r6, pc, #423624704	; 0x19400000
     aa0:	696e6e75 	stmdbvs	lr!, {r0, r2, r4, r5, r6, r9, sl, fp, sp, lr}^
     aa4:	4900676e 	stmdbmi	r0, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}
     aa8:	69545f73 	ldmdbvs	r4, {r0, r1, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     aac:	5f72656d 	svcpl	0x0072656d
     ab0:	5f515249 	svcpl	0x00515249
     ab4:	646e6550 	strbtvs	r6, [lr], #-1360	; 0xfffffab0
     ab8:	00676e69 	rsbeq	r6, r7, r9, ror #28
     abc:	6d695454 	cfstrdvs	mvd5, [r9, #-336]!	; 0xfffffeb0
     ac0:	435f7265 	cmpmi	pc, #1342177286	; 0x50000006
     ac4:	626c6c61 	rsbvs	r6, ip, #24832	; 0x6100
     ac8:	006b6361 	rsbeq	r6, fp, r1, ror #6
     acc:	5f515249 	svcpl	0x00515249
     ad0:	00776152 	rsbseq	r6, r7, r2, asr r1
     ad4:	364e5a5f 			; <UNDEFINED> instruction: 0x364e5a5f
     ad8:	6d695443 	cfstrdvs	mvd5, [r9, #-268]!	; 0xfffffef4
     adc:	32317265 	eorscc	r7, r1, #1342177286	; 0x50000006
     ae0:	5f515249 	svcpl	0x00515249
     ae4:	6c6c6143 	stfvse	f6, [ip], #-268	; 0xfffffef4
     ae8:	6b636162 	blvs	18d9078 <_bss_end+0x18cfe30>
     aec:	63007645 	movwvs	r7, #1605	; 0x645
     af0:	626c6c61 	rsbvs	r6, ip, #24832	; 0x6100
     af4:	006b6361 	rsbeq	r6, fp, r1, ror #6
     af8:	5f786469 	svcpl	0x00786469
     afc:	65736162 	ldrbvs	r6, [r3, #-354]!	; 0xfffffe9e
     b00:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     b04:	49433132 	stmdbmi	r3, {r1, r4, r5, r8, ip, sp}^
     b08:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
     b0c:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
     b10:	6e6f435f 	mcrvs	3, 3, r4, cr15, cr15, {2}
     b14:	6c6f7274 	sfmvs	f7, 2, [pc], #-464	; 94c <CPSR_IRQ_INHIBIT+0x8cc>
     b18:	3472656c 	ldrbtcc	r6, [r2], #-1388	; 0xfffffa94
     b1c:	73676552 	cmnvc	r7, #343932928	; 0x14800000
     b20:	68334e45 	ldmdavs	r3!, {r0, r2, r6, r9, sl, fp, lr}
     b24:	34326c61 	ldrtcc	r6, [r2], #-3169	; 0xfffff39f
     b28:	65746e49 	ldrbvs	r6, [r4, #-3657]!	; 0xfffff1b7
     b2c:	70757272 	rsbsvc	r7, r5, r2, ror r2
     b30:	6f435f74 	svcvs	0x00435f74
     b34:	6f72746e 	svcvs	0x0072746e
     b38:	72656c6c 	rsbvc	r6, r5, #108, 24	; 0x6c00
     b3c:	6765525f 			; <UNDEFINED> instruction: 0x6765525f
     b40:	50470045 	subpl	r0, r7, r5, asr #32
     b44:	485f3155 	ldmdami	pc, {r0, r2, r4, r6, r8, ip, sp}^	; <UNPREDICTABLE>
     b48:	00746c61 	rsbseq	r6, r4, r1, ror #24
     b4c:	6c69614d 	stfvse	f6, [r9], #-308	; 0xfffffecc
     b50:	00786f62 	rsbseq	r6, r8, r2, ror #30
     b54:	62616e45 	rsbvs	r6, r1, #1104	; 0x450
     b58:	495f656c 	ldmdbmi	pc, {r2, r3, r5, r6, r8, sl, sp, lr}^	; <UNPREDICTABLE>
     b5c:	5f005152 	svcpl	0x00005152
     b60:	31324e5a 	teqcc	r2, sl, asr lr
     b64:	746e4943 	strbtvc	r4, [lr], #-2371	; 0xfffff6bd
     b68:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
     b6c:	435f7470 	cmpmi	pc, #112, 8	; 0x70000000
     b70:	72746e6f 	rsbsvc	r6, r4, #1776	; 0x6f0
     b74:	656c6c6f 	strbvs	r6, [ip, #-3183]!	; 0xfffff391
     b78:	45324372 	ldrmi	r4, [r2, #-882]!	; 0xfffffc8e
     b7c:	5249006d 	subpl	r0, r9, #109	; 0x6d
     b80:	6e455f51 	mcrvs	15, 2, r5, cr5, cr1, {2}
     b84:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     b88:	4900315f 	stmdbmi	r0, {r0, r1, r2, r3, r4, r6, r8, ip, sp}
     b8c:	455f5152 	ldrbmi	r5, [pc, #-338]	; a42 <CPSR_IRQ_INHIBIT+0x9c2>
     b90:	6c62616e 	stfvse	f6, [r2], #-440	; 0xfffffe48
     b94:	00325f65 	eorseq	r5, r2, r5, ror #30
     b98:	54524155 	ldrbpl	r4, [r2], #-341	; 0xfffffeab
     b9c:	746e4900 	strbtvc	r4, [lr], #-2304	; 0xfffff700
     ba0:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
     ba4:	435f7470 	cmpmi	pc, #112, 8	; 0x70000000
     ba8:	72746e6f 	rsbsvc	r6, r4, #1776	; 0x6f0
     bac:	656c6c6f 	strbvs	r6, [ip, #-3183]!	; 0xfffff391
     bb0:	65525f72 	ldrbvs	r5, [r2, #-3954]	; 0xfffff08e
     bb4:	6c490067 	mcrrvs	0, 6, r0, r9, cr7
     bb8:	6167656c 	cmnvs	r7, ip, ror #10
     bbc:	63415f6c 	movtvs	r5, #8044	; 0x1f6c
     bc0:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     bc4:	4900315f 	stmdbmi	r0, {r0, r1, r2, r3, r4, r6, r8, ip, sp}
     bc8:	67656c6c 	strbvs	r6, [r5, -ip, ror #24]!
     bcc:	415f6c61 	cmpmi	pc, r1, ror #24
     bd0:	73656363 	cmnvc	r5, #-1946157055	; 0x8c000001
     bd4:	00325f73 	eorseq	r5, r2, r3, ror pc
     bd8:	5f515249 	svcpl	0x00515249
     bdc:	69736142 	ldmdbvs	r3!, {r1, r6, r8, sp, lr}^
     be0:	6f535f63 	svcvs	0x00535f63
     be4:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     be8:	6e496d00 	cdpvs	13, 4, cr6, cr9, cr0, {0}
     bec:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
     bf0:	5f747075 	svcpl	0x00747075
     bf4:	73676552 	cmnvc	r7, #343932928	; 0x14800000
     bf8:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     bfc:	49433132 	stmdbmi	r3, {r1, r4, r5, r8, ip, sp}^
     c00:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
     c04:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
     c08:	6e6f435f 	mcrvs	3, 3, r4, cr15, cr15, {2}
     c0c:	6c6f7274 	sfmvs	f7, 2, [pc], #-464	; a44 <CPSR_IRQ_INHIBIT+0x9c4>
     c10:	3172656c 	cmncc	r2, ip, ror #10
     c14:	73694431 	cmnvc	r9, #822083584	; 0x31000000
     c18:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     c1c:	5152495f 	cmppl	r2, pc, asr r9
     c20:	68334e45 	ldmdavs	r3!, {r0, r2, r6, r9, sl, fp, lr}
     c24:	30316c61 	eorscc	r6, r1, r1, ror #24
     c28:	5f515249 	svcpl	0x00515249
     c2c:	72756f53 	rsbsvc	r6, r5, #332	; 0x14c
     c30:	00456563 	subeq	r6, r5, r3, ror #10
     c34:	74736166 	ldrbtvc	r6, [r3], #-358	; 0xfffffe9a
     c38:	746e695f 	strbtvc	r6, [lr], #-2399	; 0xfffff6a1
     c3c:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
     c40:	685f7470 	ldmdavs	pc, {r4, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
     c44:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     c48:	49007265 	stmdbmi	r0, {r0, r2, r5, r6, r9, ip, sp, lr}
     c4c:	425f5152 	subsmi	r5, pc, #-2147483628	; 0x80000014
     c50:	63697361 	cmnvs	r9, #-2080374783	; 0x84000001
     c54:	6e65505f 	mcrvs	0, 3, r5, cr5, cr15, {2}
     c58:	676e6964 	strbvs	r6, [lr, -r4, ror #18]!
     c5c:	73694400 	cmnvc	r9, #0, 8
     c60:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     c64:	5152495f 	cmppl	r2, pc, asr r9
     c68:	6e494300 	cdpvs	3, 4, cr4, cr9, cr0, {0}
     c6c:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
     c70:	5f747075 	svcpl	0x00747075
     c74:	746e6f43 	strbtvc	r6, [lr], #-3907	; 0xfffff0bd
     c78:	6c6c6f72 	stclvs	15, cr6, [ip], #-456	; 0xfffffe38
     c7c:	49007265 	stmdbmi	r0, {r0, r2, r5, r6, r9, ip, sp, lr}
     c80:	425f5152 	subsmi	r5, pc, #-2147483628	; 0x80000014
     c84:	63697361 	cmnvs	r9, #-2080374783	; 0x84000001
     c88:	7369445f 	cmnvc	r9, #1593835520	; 0x5f000000
     c8c:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     c90:	616e4500 	cmnvs	lr, r0, lsl #10
     c94:	5f656c62 	svcpl	0x00656c62
     c98:	69736142 	ldmdbvs	r3!, {r1, r6, r8, sp, lr}^
     c9c:	52495f63 	subpl	r5, r9, #396	; 0x18c
     ca0:	5a5f0051 	bpl	17c0dec <_bss_end+0x17b7ba4>
     ca4:	4331324e 	teqmi	r1, #-536870908	; 0xe0000004
     ca8:	65746e49 	ldrbvs	r6, [r4, #-3657]!	; 0xfffff1b7
     cac:	70757272 	rsbsvc	r7, r5, r2, ror r2
     cb0:	6f435f74 	svcvs	0x00435f74
     cb4:	6f72746e 	svcvs	0x0072746e
     cb8:	72656c6c 	rsbvc	r6, r5, #108, 24	; 0x6c00
     cbc:	69443731 	stmdbvs	r4, {r0, r4, r5, r8, r9, sl, ip, sp}^
     cc0:	6c626173 	stfvse	f6, [r2], #-460	; 0xfffffe34
     cc4:	61425f65 	cmpvs	r2, r5, ror #30
     cc8:	5f636973 	svcpl	0x00636973
     ccc:	45515249 	ldrbmi	r5, [r1, #-585]	; 0xfffffdb7
     cd0:	6168334e 	cmnvs	r8, lr, asr #6
     cd4:	4936316c 	ldmdbmi	r6!, {r2, r3, r5, r6, r8, ip, sp}
     cd8:	425f5152 	subsmi	r5, pc, #-2147483628	; 0x80000014
     cdc:	63697361 	cmnvs	r9, #-2080374783	; 0x84000001
     ce0:	756f535f 	strbvc	r5, [pc, #-863]!	; 989 <CPSR_IRQ_INHIBIT+0x909>
     ce4:	45656372 	strbmi	r6, [r5, #-882]!	; 0xfffffc8e
     ce8:	6f6f4400 	svcvs	0x006f4400
     cec:	6c656272 	sfmvs	f6, 2, [r5], #-456	; 0xfffffe38
     cf0:	00305f6c 	eorseq	r5, r0, ip, ror #30
     cf4:	726f6f44 	rsbvc	r6, pc, #68, 30	; 0x110
     cf8:	6c6c6562 	cfstr64vs	mvdx6, [ip], #-392	; 0xfffffe78
     cfc:	4700315f 	smlsdmi	r0, pc, r1, r3	; <UNPREDICTABLE>
     d00:	5f305550 	svcpl	0x00305550
     d04:	746c6148 	strbtvc	r6, [ip], #-328	; 0xfffffeb8
     d08:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     d0c:	49433132 	stmdbmi	r3, {r1, r4, r5, r8, ip, sp}^
     d10:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
     d14:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
     d18:	6e6f435f 	mcrvs	3, 3, r4, cr15, cr15, {2}
     d1c:	6c6f7274 	sfmvs	f7, 2, [pc], #-464	; b54 <CPSR_IRQ_INHIBIT+0xad4>
     d20:	3172656c 	cmncc	r2, ip, ror #10
     d24:	616e4530 	cmnvs	lr, r0, lsr r5
     d28:	5f656c62 	svcpl	0x00656c62
     d2c:	45515249 	ldrbmi	r5, [r1, #-585]	; 0xfffffdb7
     d30:	6168334e 	cmnvs	r8, lr, asr #6
     d34:	4930316c 	ldmdbmi	r0!, {r2, r3, r5, r6, r8, ip, sp}
     d38:	535f5152 	cmppl	pc, #-2147483628	; 0x80000014
     d3c:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     d40:	5f004565 	svcpl	0x00004565
     d44:	31324e5a 	teqcc	r2, sl, asr lr
     d48:	746e4943 	strbtvc	r4, [lr], #-2371	; 0xfffff6bd
     d4c:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
     d50:	435f7470 	cmpmi	pc, #112, 8	; 0x70000000
     d54:	72746e6f 	rsbsvc	r6, r4, #1776	; 0x6f0
     d58:	656c6c6f 	strbvs	r6, [ip, #-3183]!	; 0xfffff391
     d5c:	45363172 	ldrmi	r3, [r6, #-370]!	; 0xfffffe8e
     d60:	6c62616e 	stfvse	f6, [r2], #-440	; 0xfffffe48
     d64:	61425f65 	cmpvs	r2, r5, ror #30
     d68:	5f636973 	svcpl	0x00636973
     d6c:	45515249 	ldrbmi	r5, [r1, #-585]	; 0xfffffdb7
     d70:	6168334e 	cmnvs	r8, lr, asr #6
     d74:	4936316c 	ldmdbmi	r6!, {r2, r3, r5, r6, r8, ip, sp}
     d78:	425f5152 	subsmi	r5, pc, #-2147483628	; 0x80000014
     d7c:	63697361 	cmnvs	r9, #-2080374783	; 0x84000001
     d80:	756f535f 	strbvc	r5, [pc, #-863]!	; a29 <CPSR_IRQ_INHIBIT+0x9a9>
     d84:	45656372 	strbmi	r6, [r5, #-882]!	; 0xfffffc8e
     d88:	6f682f00 	svcvs	0x00682f00
     d8c:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
     d90:	61686c69 	cmnvs	r8, r9, ror #24
     d94:	2f6a7976 	svccs	0x006a7976
     d98:	6f686353 	svcvs	0x00686353
     d9c:	5a2f6c6f 	bpl	bdbf60 <_bss_end+0xbd2d18>
     da0:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; c14 <CPSR_IRQ_INHIBIT+0xb94>
     da4:	2f657461 	svccs	0x00657461
     da8:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
     dac:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
     db0:	2d31312f 	ldfcss	f3, [r1, #-188]!	; 0xffffff44
     db4:	656d6974 	strbvs	r6, [sp, #-2420]!	; 0xfffff68c
     db8:	6f6e5f72 	svcvs	0x006e5f72
     dbc:	656c635f 	strbvs	r6, [ip, #-863]!	; 0xfffffca1
     dc0:	495f7261 	ldmdbmi	pc, {r0, r5, r6, r9, ip, sp, lr}^	; <UNPREDICTABLE>
     dc4:	6b2f5152 	blvs	bd5314 <_bss_end+0xbcc0cc>
     dc8:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
     dcc:	72732f6c 	rsbsvc	r2, r3, #108, 30	; 0x1b0
     dd0:	6e692f63 	cdpvs	15, 6, cr2, cr9, cr3, {3}
     dd4:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
     dd8:	5f747075 	svcpl	0x00747075
     ddc:	746e6f63 	strbtvc	r6, [lr], #-3939	; 0xfffff09d
     de0:	6c6c6f72 	stclvs	15, cr6, [ip], #-456	; 0xfffffe38
     de4:	632e7265 			; <UNDEFINED> instruction: 0x632e7265
     de8:	5f007070 	svcpl	0x00007070
     dec:	31324e5a 	teqcc	r2, sl, asr lr
     df0:	746e4943 	strbtvc	r4, [lr], #-2371	; 0xfffff6bd
     df4:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
     df8:	435f7470 	cmpmi	pc, #112, 8	; 0x70000000
     dfc:	72746e6f 	rsbsvc	r6, r4, #1776	; 0x6f0
     e00:	656c6c6f 	strbvs	r6, [ip, #-3183]!	; 0xfffff391
     e04:	45344372 	ldrmi	r4, [r4, #-882]!	; 0xfffffc8e
     e08:	3249006d 	subcc	r0, r9, #109	; 0x6d
     e0c:	50535f43 	subspl	r5, r3, r3, asr #30
     e10:	4c535f49 	mrrcmi	15, 4, r5, r3, cr9
     e14:	5f455641 	svcpl	0x00455641
     e18:	54494e49 	strbpl	r4, [r9], #-3657	; 0xfffff1b7
     e1c:	51494600 	cmppl	r9, r0, lsl #12
     e20:	6e6f435f 	mcrvs	3, 3, r4, cr15, cr15, {2}
     e24:	6c6f7274 	sfmvs	f7, 2, [pc], #-464	; c5c <CPSR_IRQ_INHIBIT+0xbdc>
     e28:	71726900 	cmnvc	r2, r0, lsl #18
     e2c:	6e61685f 	mcrvs	8, 3, r6, cr1, cr15, {2}
     e30:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     e34:	4c475f00 	mcrrmi	15, 0, r5, r7, cr0
     e38:	4c41424f 	sfmmi	f4, 2, [r1], {79}	; 0x4f
     e3c:	75735f5f 	ldrbvc	r5, [r3, #-3935]!	; 0xfffff0a1
     e40:	5f495f62 	svcpl	0x00495f62
     e44:	74666f73 	strbtvc	r6, [r6], #-3955	; 0xfffff08d
     e48:	65726177 	ldrbvs	r6, [r2, #-375]!	; 0xfffffe89
     e4c:	746e695f 	strbtvc	r6, [lr], #-2399	; 0xfffff6a1
     e50:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
     e54:	685f7470 	ldmdavs	pc, {r4, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
     e58:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     e5c:	49007265 	stmdbmi	r0, {r0, r2, r5, r6, r9, ip, sp, lr}
     e60:	425f5152 	subsmi	r5, pc, #-2147483628	; 0x80000014
     e64:	63697361 	cmnvs	r9, #-2080374783	; 0x84000001
     e68:	616e455f 	cmnvs	lr, pc, asr r5
     e6c:	00656c62 	rsbeq	r6, r5, r2, ror #24
     e70:	5f515249 	svcpl	0x00515249
     e74:	646e6550 	strbtvs	r6, [lr], #-1360	; 0xfffffab0
     e78:	5f676e69 	svcpl	0x00676e69
     e7c:	52490031 	subpl	r0, r9, #49	; 0x31
     e80:	6f535f51 	svcvs	0x00535f51
     e84:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     e88:	6e497300 	cdpvs	3, 4, cr7, cr9, cr0, {0}
     e8c:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
     e90:	43747075 	cmnmi	r4, #117	; 0x75
     e94:	49006c74 	stmdbmi	r0, {r2, r4, r5, r6, sl, fp, sp, lr}
     e98:	505f5152 	subspl	r5, pc, r2, asr r1	; <UNPREDICTABLE>
     e9c:	69646e65 	stmdbvs	r4!, {r0, r2, r5, r6, r9, sl, fp, sp, lr}^
     ea0:	325f676e 	subscc	r6, pc, #28835840	; 0x1b80000
     ea4:	49504700 	ldmdbmi	r0, {r8, r9, sl, lr}^
     ea8:	00305f4f 	eorseq	r5, r0, pc, asr #30
     eac:	4f495047 	svcmi	0x00495047
     eb0:	4700315f 	smlsdmi	r0, pc, r1, r3	; <UNPREDICTABLE>
     eb4:	5f4f4950 	svcpl	0x004f4950
     eb8:	50470032 	subpl	r0, r7, r2, lsr r0
     ebc:	335f4f49 	cmpcc	pc, #292	; 0x124
     ec0:	73694400 	cmnvc	r9, #0, 8
     ec4:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     ec8:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
     ecc:	495f6369 	ldmdbmi	pc, {r0, r3, r5, r6, r8, r9, sp, lr}^	; <UNPREDICTABLE>
     ed0:	73005152 	movwvc	r5, #338	; 0x152
     ed4:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     ed8:	64695f65 	strbtvs	r5, [r9], #-3941	; 0xfffff09b
     edc:	52490078 	subpl	r0, r9, #120	; 0x78
     ee0:	69445f51 	stmdbvs	r4, {r0, r4, r6, r8, r9, sl, fp, ip, lr}^
     ee4:	6c626173 	stfvse	f6, [r2], #-460	; 0xfffffe34
     ee8:	00315f65 	eorseq	r5, r1, r5, ror #30
     eec:	5f515249 	svcpl	0x00515249
     ef0:	61736944 	cmnvs	r3, r4, asr #18
     ef4:	5f656c62 	svcpl	0x00656c62
     ef8:	57500032 	smmlarpl	r0, r2, r0, r0
     efc:	00305f41 	eorseq	r5, r0, r1, asr #30
     f00:	5f415750 	svcpl	0x00415750
     f04:	454c0031 	strbmi	r0, [ip, #-49]	; 0xffffffcf
     f08:	74535f44 	ldrbvc	r5, [r3], #-3908	; 0xfffff0bc
     f0c:	00657461 	rsbeq	r7, r5, r1, ror #8
     f10:	5f544341 	svcpl	0x00544341
     f14:	5f44454c 	svcpl	0x0044454c
     f18:	6e696c42 	cdpvs	12, 6, cr6, cr9, cr2, {2}
     f1c:	0072656b 	rsbseq	r6, r2, fp, ror #10
     f20:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; e6c <CPSR_IRQ_INHIBIT+0xdec>
     f24:	69732f65 	ldmdbvs	r3!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
     f28:	7661686c 	strbtvc	r6, [r1], -ip, ror #16
     f2c:	532f6a79 			; <UNDEFINED> instruction: 0x532f6a79
     f30:	6f6f6863 	svcvs	0x006f6863
     f34:	655a2f6c 	ldrbvs	r2, [sl, #-3948]	; 0xfffff094
     f38:	614d6f72 	hvcvs	55026	; 0xd6f2
     f3c:	652f6574 	strvs	r6, [pc, #-1396]!	; 9d0 <CPSR_IRQ_INHIBIT+0x950>
     f40:	706d6178 	rsbvc	r6, sp, r8, ror r1
     f44:	2f73656c 	svccs	0x0073656c
     f48:	742d3131 	strtvc	r3, [sp], #-305	; 0xfffffecf
     f4c:	72656d69 	rsbvc	r6, r5, #6720	; 0x1a40
     f50:	5f6f6e5f 	svcpl	0x006f6e5f
     f54:	61656c63 	cmnvs	r5, r3, ror #24
     f58:	52495f72 	subpl	r5, r9, #456	; 0x1c8
     f5c:	656b2f51 	strbvs	r2, [fp, #-3921]!	; 0xfffff0af
     f60:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
     f64:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
     f68:	69616d2f 	stmdbvs	r1!, {r0, r1, r2, r3, r5, r8, sl, fp, sp, lr}^
     f6c:	70632e6e 	rsbvc	r2, r3, lr, ror #28
     f70:	6b5f0070 	blvs	17c1138 <_bss_end+0x17b7ef0>
     f74:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
     f78:	616d5f6c 	cmnvs	sp, ip, ror #30
     f7c:	2f006e69 	svccs	0x00006e69
     f80:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     f84:	6c69732f 	stclvs	3, cr7, [r9], #-188	; 0xffffff44
     f88:	79766168 	ldmdbvc	r6!, {r3, r5, r6, r8, sp, lr}^
     f8c:	63532f6a 	cmpvs	r3, #424	; 0x1a8
     f90:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; df8 <CPSR_IRQ_INHIBIT+0xd78>
     f94:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
     f98:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
     f9c:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
     fa0:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
     fa4:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
     fa8:	69742d31 	ldmdbvs	r4!, {r0, r4, r5, r8, sl, fp, sp}^
     fac:	5f72656d 	svcpl	0x0072656d
     fb0:	635f6f6e 	cmpvs	pc, #440	; 0x1b8
     fb4:	7261656c 	rsbvc	r6, r1, #108, 10	; 0x1b000000
     fb8:	5152495f 	cmppl	r2, pc, asr r9
     fbc:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
     fc0:	2f6c656e 	svccs	0x006c656e
     fc4:	2f637273 	svccs	0x00637273
     fc8:	72617473 	rsbvc	r7, r1, #1929379840	; 0x73000000
     fcc:	00732e74 	rsbseq	r2, r3, r4, ror lr
     fd0:	20554e47 	subscs	r4, r5, r7, asr #28
     fd4:	32205341 	eorcc	r5, r0, #67108865	; 0x4000001
     fd8:	0034332e 	eorseq	r3, r4, lr, lsr #6
     fdc:	7373625f 	cmnvc	r3, #-268435451	; 0xf0000005
     fe0:	6174735f 	cmnvs	r4, pc, asr r3
     fe4:	66007472 			; <UNDEFINED> instruction: 0x66007472
     fe8:	7274706e 	rsbsvc	r7, r4, #110	; 0x6e
     fec:	435f5f00 	cmpmi	pc, #0, 30
     ff0:	5f524f54 	svcpl	0x00524f54
     ff4:	5f444e45 	svcpl	0x00444e45
     ff8:	5f5f005f 	svcpl	0x005f005f
     ffc:	524f5444 	subpl	r5, pc, #68, 8	; 0x44000000
    1000:	444e455f 	strbmi	r4, [lr], #-1375	; 0xfffffaa1
    1004:	5f005f5f 	svcpl	0x00005f5f
    1008:	5f707063 	svcpl	0x00707063
    100c:	74756873 	ldrbtvc	r6, [r5], #-2163	; 0xfffff78d
    1010:	6e776f64 	cdpvs	15, 7, cr6, cr7, cr4, {3}
    1014:	73625f00 	cmnvc	r2, #0, 30
    1018:	6e655f73 	mcrvs	15, 3, r5, cr5, cr3, {3}
    101c:	5f5f0064 	svcpl	0x005f0064
    1020:	524f5444 	subpl	r5, pc, #68, 8	; 0x44000000
    1024:	53494c5f 	movtpl	r4, #40031	; 0x9c5f
    1028:	005f5f54 	subseq	r5, pc, r4, asr pc	; <UNPREDICTABLE>
    102c:	726f7464 	rsbvc	r7, pc, #100, 8	; 0x64000000
    1030:	7274705f 	rsbsvc	r7, r4, #95	; 0x5f
    1034:	6f746300 	svcvs	0x00746300
    1038:	74705f72 	ldrbtvc	r5, [r0], #-3954	; 0xfffff08e
    103c:	5f5f0072 	svcpl	0x005f0072
    1040:	524f5443 	subpl	r5, pc, #1124073472	; 0x43000000
    1044:	53494c5f 	movtpl	r4, #40031	; 0x9c5f
    1048:	005f5f54 	subseq	r5, pc, r4, asr pc	; <UNPREDICTABLE>
    104c:	735f635f 	cmpvc	pc, #2080374785	; 0x7c000001
    1050:	74726174 	ldrbtvc	r6, [r2], #-372	; 0xfffffe8c
    1054:	5f007075 	svcpl	0x00007075
    1058:	5f707063 	svcpl	0x00707063
    105c:	72617473 	rsbvc	r7, r1, #1929379840	; 0x73000000
    1060:	00707574 	rsbseq	r7, r0, r4, ror r5
    1064:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; fb0 <CPSR_IRQ_INHIBIT+0xf30>
    1068:	69732f65 	ldmdbvs	r3!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
    106c:	7661686c 	strbtvc	r6, [r1], -ip, ror #16
    1070:	532f6a79 			; <UNDEFINED> instruction: 0x532f6a79
    1074:	6f6f6863 	svcvs	0x006f6863
    1078:	655a2f6c 	ldrbvs	r2, [sl, #-3948]	; 0xfffff094
    107c:	614d6f72 	hvcvs	55026	; 0xd6f2
    1080:	652f6574 	strvs	r6, [pc, #-1396]!	; b14 <CPSR_IRQ_INHIBIT+0xa94>
    1084:	706d6178 	rsbvc	r6, sp, r8, ror r1
    1088:	2f73656c 	svccs	0x0073656c
    108c:	742d3131 	strtvc	r3, [sp], #-305	; 0xfffffecf
    1090:	72656d69 	rsbvc	r6, r5, #6720	; 0x1a40
    1094:	5f6f6e5f 	svcpl	0x006f6e5f
    1098:	61656c63 	cmnvs	r5, r3, ror #24
    109c:	52495f72 	subpl	r5, r9, #456	; 0x1c8
    10a0:	656b2f51 	strbvs	r2, [fp, #-3921]!	; 0xfffff0af
    10a4:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
    10a8:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
    10ac:	6174732f 	cmnvs	r4, pc, lsr #6
    10b0:	70757472 	rsbsvc	r7, r5, r2, ror r4
    10b4:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
    10b8:	52415400 	subpl	r5, r1, #0, 8
    10bc:	5f544547 	svcpl	0x00544547
    10c0:	5f555043 	svcpl	0x00555043
    10c4:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    10c8:	31617865 	cmncc	r1, r5, ror #16
    10cc:	726f6337 	rsbvc	r6, pc, #-603979776	; 0xdc000000
    10d0:	61786574 	cmnvs	r8, r4, ror r5
    10d4:	73690037 	cmnvc	r9, #55	; 0x37
    10d8:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    10dc:	70665f74 	rsbvc	r5, r6, r4, ror pc
    10e0:	6c62645f 	cfstrdvs	mvd6, [r2], #-380	; 0xfffffe84
    10e4:	6d726100 	ldfvse	f6, [r2, #-0]
    10e8:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    10ec:	77695f68 	strbvc	r5, [r9, -r8, ror #30]!
    10f0:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
    10f4:	52415400 	subpl	r5, r1, #0, 8
    10f8:	5f544547 	svcpl	0x00544547
    10fc:	5f555043 	svcpl	0x00555043
    1100:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1104:	326d7865 	rsbcc	r7, sp, #6619136	; 0x650000
    1108:	52410033 	subpl	r0, r1, #51	; 0x33
    110c:	51455f4d 	cmppl	r5, sp, asr #30
    1110:	52415400 	subpl	r5, r1, #0, 8
    1114:	5f544547 	svcpl	0x00544547
    1118:	5f555043 	svcpl	0x00555043
    111c:	316d7261 	cmncc	sp, r1, ror #4
    1120:	74363531 	ldrtvc	r3, [r6], #-1329	; 0xfffffacf
    1124:	00736632 	rsbseq	r6, r3, r2, lsr r6
    1128:	5f617369 	svcpl	0x00617369
    112c:	5f746962 	svcpl	0x00746962
    1130:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    1134:	41540062 	cmpmi	r4, r2, rrx
    1138:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    113c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1140:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1144:	61786574 	cmnvs	r8, r4, ror r5
    1148:	6f633735 	svcvs	0x00633735
    114c:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1150:	00333561 	eorseq	r3, r3, r1, ror #10
    1154:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1158:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    115c:	4d385f48 	ldcmi	15, cr5, [r8, #-288]!	; 0xfffffee0
    1160:	5341425f 	movtpl	r4, #4703	; 0x125f
    1164:	41540045 	cmpmi	r4, r5, asr #32
    1168:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    116c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1170:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1174:	00303138 	eorseq	r3, r0, r8, lsr r1
    1178:	47524154 			; <UNDEFINED> instruction: 0x47524154
    117c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1180:	785f5550 	ldmdavc	pc, {r4, r6, r8, sl, ip, lr}^	; <UNPREDICTABLE>
    1184:	656e6567 	strbvs	r6, [lr, #-1383]!	; 0xfffffa99
    1188:	52410031 	subpl	r0, r1, #49	; 0x31
    118c:	43505f4d 	cmpmi	r0, #308	; 0x134
    1190:	41415f53 	cmpmi	r1, r3, asr pc
    1194:	5f534350 	svcpl	0x00534350
    1198:	4d4d5749 	stclmi	7, cr5, [sp, #-292]	; 0xfffffedc
    119c:	42005458 	andmi	r5, r0, #88, 8	; 0x58000000
    11a0:	5f455341 	svcpl	0x00455341
    11a4:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    11a8:	4200305f 	andmi	r3, r0, #95	; 0x5f
    11ac:	5f455341 	svcpl	0x00455341
    11b0:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    11b4:	4200325f 	andmi	r3, r0, #-268435451	; 0xf0000005
    11b8:	5f455341 	svcpl	0x00455341
    11bc:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    11c0:	4200335f 	andmi	r3, r0, #2080374785	; 0x7c000001
    11c4:	5f455341 	svcpl	0x00455341
    11c8:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    11cc:	4200345f 	andmi	r3, r0, #1593835520	; 0x5f000000
    11d0:	5f455341 	svcpl	0x00455341
    11d4:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    11d8:	4200365f 	andmi	r3, r0, #99614720	; 0x5f00000
    11dc:	5f455341 	svcpl	0x00455341
    11e0:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    11e4:	5400375f 	strpl	r3, [r0], #-1887	; 0xfffff8a1
    11e8:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    11ec:	50435f54 	subpl	r5, r3, r4, asr pc
    11f0:	73785f55 	cmnvc	r8, #340	; 0x154
    11f4:	656c6163 	strbvs	r6, [ip, #-355]!	; 0xfffffe9d
    11f8:	61736900 	cmnvs	r3, r0, lsl #18
    11fc:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1200:	6572705f 	ldrbvs	r7, [r2, #-95]!	; 0xffffffa1
    1204:	73657264 	cmnvc	r5, #100, 4	; 0x40000006
    1208:	52415400 	subpl	r5, r1, #0, 8
    120c:	5f544547 	svcpl	0x00544547
    1210:	5f555043 	svcpl	0x00555043
    1214:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1218:	336d7865 	cmncc	sp, #6619136	; 0x650000
    121c:	41540033 	cmpmi	r4, r3, lsr r0
    1220:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1224:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1228:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    122c:	6d647437 	cfstrdvs	mvd7, [r4, #-220]!	; 0xffffff24
    1230:	73690069 	cmnvc	r9, #105	; 0x69
    1234:	6f6e5f61 	svcvs	0x006e5f61
    1238:	00746962 	rsbseq	r6, r4, r2, ror #18
    123c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1240:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1244:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1248:	31316d72 	teqcc	r1, r2, ror sp
    124c:	7a6a3637 	bvc	1a8eb30 <_bss_end+0x1a858e8>
    1250:	69007366 	stmdbvs	r0, {r1, r2, r5, r6, r8, r9, ip, sp, lr}
    1254:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1258:	765f7469 	ldrbvc	r7, [pc], -r9, ror #8
    125c:	32767066 	rsbscc	r7, r6, #102	; 0x66
    1260:	4d524100 	ldfmie	f4, [r2, #-0]
    1264:	5343505f 	movtpl	r5, #12383	; 0x305f
    1268:	4b4e555f 	blmi	13967ec <_bss_end+0x138d5a4>
    126c:	4e574f4e 	cdpmi	15, 5, cr4, cr7, cr14, {2}
    1270:	52415400 	subpl	r5, r1, #0, 8
    1274:	5f544547 	svcpl	0x00544547
    1278:	5f555043 	svcpl	0x00555043
    127c:	396d7261 	stmdbcc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    1280:	41420065 	cmpmi	r2, r5, rrx
    1284:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1288:	5f484352 	svcpl	0x00484352
    128c:	4a455435 	bmi	1156368 <_bss_end+0x114d120>
    1290:	6d726100 	ldfvse	f6, [r2, #-0]
    1294:	6663635f 			; <UNDEFINED> instruction: 0x6663635f
    1298:	735f6d73 	cmpvc	pc, #7360	; 0x1cc0
    129c:	65746174 	ldrbvs	r6, [r4, #-372]!	; 0xfffffe8c
    12a0:	6d726100 	ldfvse	f6, [r2, #-0]
    12a4:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    12a8:	65743568 	ldrbvs	r3, [r4, #-1384]!	; 0xfffffa98
    12ac:	736e7500 	cmnvc	lr, #0, 10
    12b0:	5f636570 	svcpl	0x00636570
    12b4:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
    12b8:	0073676e 	rsbseq	r6, r3, lr, ror #14
    12bc:	5f617369 	svcpl	0x00617369
    12c0:	5f746962 	svcpl	0x00746962
    12c4:	00636573 	rsbeq	r6, r3, r3, ror r5
    12c8:	6c635f5f 	stclvs	15, cr5, [r3], #-380	; 0xfffffe84
    12cc:	61745f7a 	cmnvs	r4, sl, ror pc
    12d0:	52410062 	subpl	r0, r1, #98	; 0x62
    12d4:	43565f4d 	cmpmi	r6, #308	; 0x134
    12d8:	6d726100 	ldfvse	f6, [r2, #-0]
    12dc:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    12e0:	73785f68 	cmnvc	r8, #104, 30	; 0x1a0
    12e4:	656c6163 	strbvs	r6, [ip, #-355]!	; 0xfffffe9d
    12e8:	4d524100 	ldfmie	f4, [r2, #-0]
    12ec:	00454c5f 	subeq	r4, r5, pc, asr ip
    12f0:	5f4d5241 	svcpl	0x004d5241
    12f4:	41005356 	tstmi	r0, r6, asr r3
    12f8:	475f4d52 			; <UNDEFINED> instruction: 0x475f4d52
    12fc:	72610045 	rsbvc	r0, r1, #69	; 0x45
    1300:	75745f6d 	ldrbvc	r5, [r4, #-3949]!	; 0xfffff093
    1304:	735f656e 	cmpvc	pc, #461373440	; 0x1b800000
    1308:	6e6f7274 	mcrvs	2, 3, r7, cr15, cr4, {3}
    130c:	6d726167 	ldfvse	f6, [r2, #-412]!	; 0xfffffe64
    1310:	6d6f6300 	stclvs	3, cr6, [pc, #-0]	; 1318 <CPSR_IRQ_INHIBIT+0x1298>
    1314:	78656c70 	stmdavc	r5!, {r4, r5, r6, sl, fp, sp, lr}^
    1318:	6f6c6620 	svcvs	0x006c6620
    131c:	54007461 	strpl	r7, [r0], #-1121	; 0xfffffb9f
    1320:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1324:	50435f54 	subpl	r5, r3, r4, asr pc
    1328:	6f635f55 	svcvs	0x00635f55
    132c:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1330:	00353161 	eorseq	r3, r5, r1, ror #2
    1334:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1338:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    133c:	665f5550 			; <UNDEFINED> instruction: 0x665f5550
    1340:	36323761 	ldrtcc	r3, [r2], -r1, ror #14
    1344:	54006574 	strpl	r6, [r0], #-1396	; 0xfffffa8c
    1348:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    134c:	50435f54 	subpl	r5, r3, r4, asr pc
    1350:	6f635f55 	svcvs	0x00635f55
    1354:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1358:	00373161 	eorseq	r3, r7, r1, ror #2
    135c:	5f4d5241 	svcpl	0x004d5241
    1360:	54005447 	strpl	r5, [r0], #-1095	; 0xfffffbb9
    1364:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1368:	50435f54 	subpl	r5, r3, r4, asr pc
    136c:	656e5f55 	strbvs	r5, [lr, #-3925]!	; 0xfffff0ab
    1370:	7265766f 	rsbvc	r7, r5, #116391936	; 0x6f00000
    1374:	316e6573 	smccc	58963	; 0xe653
    1378:	2f2e2e00 	svccs	0x002e2e00
    137c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1380:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1384:	2f2e2e2f 	svccs	0x002e2e2f
    1388:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 12d8 <CPSR_IRQ_INHIBIT+0x1258>
    138c:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1390:	696c2f63 	stmdbvs	ip!, {r0, r1, r5, r6, r8, r9, sl, fp, sp}^
    1394:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    1398:	00632e32 	rsbeq	r2, r3, r2, lsr lr
    139c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    13a0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    13a4:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    13a8:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    13ac:	66347278 			; <UNDEFINED> instruction: 0x66347278
    13b0:	53414200 	movtpl	r4, #4608	; 0x1200
    13b4:	52415f45 	subpl	r5, r1, #276	; 0x114
    13b8:	375f4843 	ldrbcc	r4, [pc, -r3, asr #16]
    13bc:	54004d45 	strpl	r4, [r0], #-3397	; 0xfffff2bb
    13c0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    13c4:	50435f54 	subpl	r5, r3, r4, asr pc
    13c8:	6f635f55 	svcvs	0x00635f55
    13cc:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    13d0:	00323161 	eorseq	r3, r2, r1, ror #2
    13d4:	68736168 	ldmdavs	r3!, {r3, r5, r6, r8, sp, lr}^
    13d8:	5f6c6176 	svcpl	0x006c6176
    13dc:	41420074 	hvcmi	8196	; 0x2004
    13e0:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    13e4:	5f484352 	svcpl	0x00484352
    13e8:	005a4b36 	subseq	r4, sl, r6, lsr fp
    13ec:	5f617369 	svcpl	0x00617369
    13f0:	73746962 	cmnvc	r4, #1605632	; 0x188000
    13f4:	6d726100 	ldfvse	f6, [r2, #-0]
    13f8:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    13fc:	72615f68 	rsbvc	r5, r1, #104, 30	; 0x1a0
    1400:	77685f6d 	strbvc	r5, [r8, -sp, ror #30]!
    1404:	00766964 	rsbseq	r6, r6, r4, ror #18
    1408:	5f6d7261 	svcpl	0x006d7261
    140c:	5f757066 	svcpl	0x00757066
    1410:	63736564 	cmnvs	r3, #100, 10	; 0x19000000
    1414:	61736900 	cmnvs	r3, r0, lsl #18
    1418:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    141c:	3170665f 	cmncc	r0, pc, asr r6
    1420:	4e470036 	mcrmi	0, 2, r0, cr7, cr6, {1}
    1424:	31432055 	qdaddcc	r2, r5, r3
    1428:	2e392037 	mrccs	0, 1, r2, cr9, cr7, {1}
    142c:	20312e32 	eorscs	r2, r1, r2, lsr lr
    1430:	39313032 	ldmdbcc	r1!, {r1, r4, r5, ip, sp}
    1434:	35323031 	ldrcc	r3, [r2, #-49]!	; 0xffffffcf
    1438:	65722820 	ldrbvs	r2, [r2, #-2080]!	; 0xfffff7e0
    143c:	7361656c 	cmnvc	r1, #108, 10	; 0x1b000000
    1440:	5b202965 	blpl	80b9dc <_bss_end+0x802794>
    1444:	2f4d5241 	svccs	0x004d5241
    1448:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
    144c:	72622d39 	rsbvc	r2, r2, #3648	; 0xe40
    1450:	68636e61 	stmdavs	r3!, {r0, r5, r6, r9, sl, fp, sp, lr}^
    1454:	76657220 	strbtvc	r7, [r5], -r0, lsr #4
    1458:	6f697369 	svcvs	0x00697369
    145c:	3732206e 	ldrcc	r2, [r2, -lr, rrx]!
    1460:	39393537 	ldmdbcc	r9!, {r0, r1, r2, r4, r5, r8, sl, ip, sp}
    1464:	6d2d205d 	stcvs	0, cr2, [sp, #-372]!	; 0xfffffe8c
    1468:	206d7261 	rsbcs	r7, sp, r1, ror #4
    146c:	6c666d2d 	stclvs	13, cr6, [r6], #-180	; 0xffffff4c
    1470:	2d74616f 	ldfcse	f6, [r4, #-444]!	; 0xfffffe44
    1474:	3d696261 	sfmcc	f6, 2, [r9, #-388]!	; 0xfffffe7c
    1478:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
    147c:	616d2d20 	cmnvs	sp, r0, lsr #26
    1480:	3d686372 	stclcc	3, cr6, [r8, #-456]!	; 0xfffffe38
    1484:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1488:	2b657435 	blcs	195e564 <_bss_end+0x195531c>
    148c:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
    1490:	672d2067 	strvs	r2, [sp, -r7, rrx]!
    1494:	20672d20 	rsbcs	r2, r7, r0, lsr #26
    1498:	20324f2d 	eorscs	r4, r2, sp, lsr #30
    149c:	20324f2d 	eorscs	r4, r2, sp, lsr #30
    14a0:	20324f2d 	eorscs	r4, r2, sp, lsr #30
    14a4:	7562662d 	strbvc	r6, [r2, #-1581]!	; 0xfffff9d3
    14a8:	69646c69 	stmdbvs	r4!, {r0, r3, r5, r6, sl, fp, sp, lr}^
    14ac:	6c2d676e 	stcvs	7, cr6, [sp], #-440	; 0xfffffe48
    14b0:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    14b4:	662d2063 	strtvs	r2, [sp], -r3, rrx
    14b8:	732d6f6e 			; <UNDEFINED> instruction: 0x732d6f6e
    14bc:	6b636174 	blvs	18d9a94 <_bss_end+0x18d084c>
    14c0:	6f72702d 	svcvs	0x0072702d
    14c4:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
    14c8:	2d20726f 	sfmcs	f7, 4, [r0, #-444]!	; 0xfffffe44
    14cc:	2d6f6e66 	stclcs	14, cr6, [pc, #-408]!	; 133c <CPSR_IRQ_INHIBIT+0x12bc>
    14d0:	696c6e69 	stmdbvs	ip!, {r0, r3, r5, r6, r9, sl, fp, sp, lr}^
    14d4:	2d20656e 	cfstr32cs	mvfx6, [r0, #-440]!	; 0xfffffe48
    14d8:	73697666 	cmnvc	r9, #106954752	; 0x6600000
    14dc:	6c696269 	sfmvs	f6, 2, [r9], #-420	; 0xfffffe5c
    14e0:	3d797469 	cfldrdcc	mvd7, [r9, #-420]!	; 0xfffffe5c
    14e4:	64646968 	strbtvs	r6, [r4], #-2408	; 0xfffff698
    14e8:	41006e65 	tstmi	r0, r5, ror #28
    14ec:	485f4d52 	ldmdami	pc, {r1, r4, r6, r8, sl, fp, lr}^	; <UNPREDICTABLE>
    14f0:	73690049 	cmnvc	r9, #73	; 0x49
    14f4:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    14f8:	64615f74 	strbtvs	r5, [r1], #-3956	; 0xfffff08c
    14fc:	54007669 	strpl	r7, [r0], #-1641	; 0xfffff997
    1500:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1504:	50435f54 	subpl	r5, r3, r4, asr pc
    1508:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    150c:	3331316d 	teqcc	r1, #1073741851	; 0x4000001b
    1510:	00736a36 	rsbseq	r6, r3, r6, lsr sl
    1514:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1518:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    151c:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1520:	00386d72 	eorseq	r6, r8, r2, ror sp
    1524:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1528:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    152c:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1530:	00396d72 	eorseq	r6, r9, r2, ror sp
    1534:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1538:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    153c:	665f5550 			; <UNDEFINED> instruction: 0x665f5550
    1540:	36323661 	ldrtcc	r3, [r2], -r1, ror #12
    1544:	6e6f6c00 	cdpvs	12, 6, cr6, cr15, cr0, {0}
    1548:	6f6c2067 	svcvs	0x006c2067
    154c:	7520676e 	strvc	r6, [r0, #-1902]!	; 0xfffff892
    1550:	6769736e 	strbvs	r7, [r9, -lr, ror #6]!
    1554:	2064656e 	rsbcs	r6, r4, lr, ror #10
    1558:	00746e69 	rsbseq	r6, r4, r9, ror #28
    155c:	5f6d7261 	svcpl	0x006d7261
    1560:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1564:	736d635f 	cmnvc	sp, #2080374785	; 0x7c000001
    1568:	41540065 	cmpmi	r4, r5, rrx
    156c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1570:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1574:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1578:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    157c:	41540034 	cmpmi	r4, r4, lsr r0
    1580:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1584:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1588:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    158c:	00653031 	rsbeq	r3, r5, r1, lsr r0
    1590:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1594:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1598:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    159c:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    15a0:	00376d78 	eorseq	r6, r7, r8, ror sp
    15a4:	5f6d7261 	svcpl	0x006d7261
    15a8:	646e6f63 	strbtvs	r6, [lr], #-3939	; 0xfffff09d
    15ac:	646f635f 	strbtvs	r6, [pc], #-863	; 15b4 <CPSR_IRQ_INHIBIT+0x1534>
    15b0:	52410065 	subpl	r0, r1, #101	; 0x65
    15b4:	43505f4d 	cmpmi	r0, #308	; 0x134
    15b8:	41415f53 	cmpmi	r1, r3, asr pc
    15bc:	00534350 	subseq	r4, r3, r0, asr r3
    15c0:	5f617369 	svcpl	0x00617369
    15c4:	5f746962 	svcpl	0x00746962
    15c8:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    15cc:	00325f38 	eorseq	r5, r2, r8, lsr pc
    15d0:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    15d4:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    15d8:	4d335f48 	ldcmi	15, cr5, [r3, #-288]!	; 0xfffffee0
    15dc:	52415400 	subpl	r5, r1, #0, 8
    15e0:	5f544547 	svcpl	0x00544547
    15e4:	5f555043 	svcpl	0x00555043
    15e8:	376d7261 	strbcc	r7, [sp, -r1, ror #4]!
    15ec:	00743031 	rsbseq	r3, r4, r1, lsr r0
    15f0:	5f6d7261 	svcpl	0x006d7261
    15f4:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    15f8:	6d77695f 			; <UNDEFINED> instruction: 0x6d77695f
    15fc:	3274786d 	rsbscc	r7, r4, #7143424	; 0x6d0000
    1600:	61736900 	cmnvs	r3, r0, lsl #18
    1604:	6d756e5f 	ldclvs	14, cr6, [r5, #-380]!	; 0xfffffe84
    1608:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    160c:	41540073 	cmpmi	r4, r3, ror r0
    1610:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1614:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1618:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    161c:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    1620:	756c7030 	strbvc	r7, [ip, #-48]!	; 0xffffffd0
    1624:	616d7373 	smcvs	55091	; 0xd733
    1628:	756d6c6c 	strbvc	r6, [sp, #-3180]!	; 0xfffff394
    162c:	7069746c 	rsbvc	r7, r9, ip, ror #8
    1630:	5400796c 	strpl	r7, [r0], #-2412	; 0xfffff694
    1634:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1638:	50435f54 	subpl	r5, r3, r4, asr pc
    163c:	78655f55 	stmdavc	r5!, {r0, r2, r4, r6, r8, r9, sl, fp, ip, lr}^
    1640:	736f6e79 	cmnvc	pc, #1936	; 0x790
    1644:	5400316d 	strpl	r3, [r0], #-365	; 0xfffffe93
    1648:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    164c:	50435f54 	subpl	r5, r3, r4, asr pc
    1650:	6f635f55 	svcvs	0x00635f55
    1654:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1658:	00323572 	eorseq	r3, r2, r2, ror r5
    165c:	5f617369 	svcpl	0x00617369
    1660:	5f746962 	svcpl	0x00746962
    1664:	76696474 			; <UNDEFINED> instruction: 0x76696474
    1668:	65727000 	ldrbvs	r7, [r2, #-0]!
    166c:	5f726566 	svcpl	0x00726566
    1670:	6e6f656e 	cdpvs	5, 6, cr6, cr15, cr14, {3}
    1674:	726f665f 	rsbvc	r6, pc, #99614720	; 0x5f00000
    1678:	6234365f 	eorsvs	r3, r4, #99614720	; 0x5f00000
    167c:	00737469 	rsbseq	r7, r3, r9, ror #8
    1680:	5f617369 	svcpl	0x00617369
    1684:	5f746962 	svcpl	0x00746962
    1688:	36317066 	ldrtcc	r7, [r1], -r6, rrx
    168c:	006c6d66 	rsbeq	r6, ip, r6, ror #26
    1690:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1694:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1698:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    169c:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    16a0:	32336178 	eorscc	r6, r3, #120, 2
    16a4:	52415400 	subpl	r5, r1, #0, 8
    16a8:	5f544547 	svcpl	0x00544547
    16ac:	5f555043 	svcpl	0x00555043
    16b0:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    16b4:	33617865 	cmncc	r1, #6619136	; 0x650000
    16b8:	73690035 	cmnvc	r9, #53	; 0x35
    16bc:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    16c0:	70665f74 	rsbvc	r5, r6, r4, ror pc
    16c4:	6f633631 	svcvs	0x00633631
    16c8:	7500766e 	strvc	r7, [r0, #-1646]	; 0xfffff992
    16cc:	6570736e 	ldrbvs	r7, [r0, #-878]!	; 0xfffffc92
    16d0:	735f7663 	cmpvc	pc, #103809024	; 0x6300000
    16d4:	6e697274 	mcrvs	2, 3, r7, cr9, cr4, {3}
    16d8:	54007367 	strpl	r7, [r0], #-871	; 0xfffffc99
    16dc:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    16e0:	50435f54 	subpl	r5, r3, r4, asr pc
    16e4:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    16e8:	3531316d 	ldrcc	r3, [r1, #-365]!	; 0xfffffe93
    16ec:	73327436 	teqvc	r2, #905969664	; 0x36000000
    16f0:	52415400 	subpl	r5, r1, #0, 8
    16f4:	5f544547 	svcpl	0x00544547
    16f8:	5f555043 	svcpl	0x00555043
    16fc:	30366166 	eorscc	r6, r6, r6, ror #2
    1700:	00657436 	rsbeq	r7, r5, r6, lsr r4
    1704:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1708:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    170c:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1710:	32396d72 	eorscc	r6, r9, #7296	; 0x1c80
    1714:	736a6536 	cmnvc	sl, #226492416	; 0xd800000
    1718:	53414200 	movtpl	r4, #4608	; 0x1200
    171c:	52415f45 	subpl	r5, r1, #276	; 0x114
    1720:	345f4843 	ldrbcc	r4, [pc], #-2115	; 1728 <CPSR_IRQ_INHIBIT+0x16a8>
    1724:	73690054 	cmnvc	r9, #84	; 0x54
    1728:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    172c:	72635f74 	rsbvc	r5, r3, #116, 30	; 0x1d0
    1730:	6f747079 	svcvs	0x00747079
    1734:	6d726100 	ldfvse	f6, [r2, #-0]
    1738:	6765725f 			; <UNDEFINED> instruction: 0x6765725f
    173c:	6e695f73 	mcrvs	15, 3, r5, cr9, cr3, {3}
    1740:	7165735f 	cmnvc	r5, pc, asr r3
    1744:	636e6575 	cmnvs	lr, #490733568	; 0x1d400000
    1748:	73690065 	cmnvc	r9, #101	; 0x65
    174c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1750:	62735f74 	rsbsvs	r5, r3, #116, 30	; 0x1d0
    1754:	53414200 	movtpl	r4, #4608	; 0x1200
    1758:	52415f45 	subpl	r5, r1, #276	; 0x114
    175c:	355f4843 	ldrbcc	r4, [pc, #-2115]	; f21 <CPSR_IRQ_INHIBIT+0xea1>
    1760:	69004554 	stmdbvs	r0, {r2, r4, r6, r8, sl, lr}
    1764:	665f6173 			; <UNDEFINED> instruction: 0x665f6173
    1768:	75746165 	ldrbvc	r6, [r4, #-357]!	; 0xfffffe9b
    176c:	69006572 	stmdbvs	r0, {r1, r4, r5, r6, r8, sl, sp, lr}
    1770:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1774:	735f7469 	cmpvc	pc, #1761607680	; 0x69000000
    1778:	6c6c616d 	stfvse	f6, [ip], #-436	; 0xfffffe4c
    177c:	006c756d 	rsbeq	r7, ip, sp, ror #10
    1780:	5f6d7261 	svcpl	0x006d7261
    1784:	676e616c 	strbvs	r6, [lr, -ip, ror #2]!
    1788:	74756f5f 	ldrbtvc	r6, [r5], #-3935	; 0xfffff0a1
    178c:	5f747570 	svcpl	0x00747570
    1790:	656a626f 	strbvs	r6, [sl, #-623]!	; 0xfffffd91
    1794:	615f7463 	cmpvs	pc, r3, ror #8
    1798:	69727474 	ldmdbvs	r2!, {r2, r4, r5, r6, sl, ip, sp, lr}^
    179c:	65747562 	ldrbvs	r7, [r4, #-1378]!	; 0xfffffa9e
    17a0:	6f685f73 	svcvs	0x00685f73
    17a4:	69006b6f 	stmdbvs	r0, {r0, r1, r2, r3, r5, r6, r8, r9, fp, sp, lr}
    17a8:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    17ac:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    17b0:	33645f70 	cmncc	r4, #112, 30	; 0x1c0
    17b4:	52410032 	subpl	r0, r1, #50	; 0x32
    17b8:	454e5f4d 	strbmi	r5, [lr, #-3917]	; 0xfffff0b3
    17bc:	61736900 	cmnvs	r3, r0, lsl #18
    17c0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    17c4:	3865625f 	stmdacc	r5!, {r0, r1, r2, r3, r4, r6, r9, sp, lr}^
    17c8:	52415400 	subpl	r5, r1, #0, 8
    17cc:	5f544547 	svcpl	0x00544547
    17d0:	5f555043 	svcpl	0x00555043
    17d4:	316d7261 	cmncc	sp, r1, ror #4
    17d8:	6a363731 	bvs	d8f4a4 <_bss_end+0xd8625c>
    17dc:	7000737a 	andvc	r7, r0, sl, ror r3
    17e0:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    17e4:	726f7373 	rsbvc	r7, pc, #-872415231	; 0xcc000001
    17e8:	7079745f 	rsbsvc	r7, r9, pc, asr r4
    17ec:	6c610065 	stclvs	0, cr0, [r1], #-404	; 0xfffffe6c
    17f0:	70665f6c 	rsbvc	r5, r6, ip, ror #30
    17f4:	61007375 	tstvs	r0, r5, ror r3
    17f8:	705f6d72 	subsvc	r6, pc, r2, ror sp	; <UNPREDICTABLE>
    17fc:	42007363 	andmi	r7, r0, #-1946157055	; 0x8c000001
    1800:	5f455341 	svcpl	0x00455341
    1804:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1808:	0054355f 	subseq	r3, r4, pc, asr r5
    180c:	5f6d7261 	svcpl	0x006d7261
    1810:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1814:	54007434 	strpl	r7, [r0], #-1076	; 0xfffffbcc
    1818:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    181c:	50435f54 	subpl	r5, r3, r4, asr pc
    1820:	6f635f55 	svcvs	0x00635f55
    1824:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1828:	63363761 	teqvs	r6, #25427968	; 0x1840000
    182c:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1830:	35356178 	ldrcc	r6, [r5, #-376]!	; 0xfffffe88
    1834:	6d726100 	ldfvse	f6, [r2, #-0]
    1838:	6e75745f 	mrcvs	4, 3, r7, cr5, cr15, {2}
    183c:	62775f65 	rsbsvs	r5, r7, #404	; 0x194
    1840:	68006675 	stmdavs	r0, {r0, r2, r4, r5, r6, r9, sl, sp, lr}
    1844:	5f626174 	svcpl	0x00626174
    1848:	68736168 	ldmdavs	r3!, {r3, r5, r6, r8, sp, lr}^
    184c:	61736900 	cmnvs	r3, r0, lsl #18
    1850:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1854:	6975715f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, r8, ip, sp, lr}^
    1858:	6e5f6b72 	vmovvs.s8	r6, d15[3]
    185c:	6f765f6f 	svcvs	0x00765f6f
    1860:	6974616c 	ldmdbvs	r4!, {r2, r3, r5, r6, r8, sp, lr}^
    1864:	635f656c 	cmpvs	pc, #108, 10	; 0x1b000000
    1868:	41540065 	cmpmi	r4, r5, rrx
    186c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1870:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1874:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1878:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    187c:	41540030 	cmpmi	r4, r0, lsr r0
    1880:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1884:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1888:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    188c:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    1890:	41540031 	cmpmi	r4, r1, lsr r0
    1894:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1898:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    189c:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    18a0:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    18a4:	73690033 	cmnvc	r9, #51	; 0x33
    18a8:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    18ac:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    18b0:	5f38766d 	svcpl	0x0038766d
    18b4:	72610031 	rsbvc	r0, r1, #49	; 0x31
    18b8:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    18bc:	6e5f6863 	cdpvs	8, 5, cr6, cr15, cr3, {3}
    18c0:	00656d61 	rsbeq	r6, r5, r1, ror #26
    18c4:	5f617369 	svcpl	0x00617369
    18c8:	5f746962 	svcpl	0x00746962
    18cc:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    18d0:	00335f38 	eorseq	r5, r3, r8, lsr pc
    18d4:	5f617369 	svcpl	0x00617369
    18d8:	5f746962 	svcpl	0x00746962
    18dc:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    18e0:	00345f38 	eorseq	r5, r4, r8, lsr pc
    18e4:	5f617369 	svcpl	0x00617369
    18e8:	5f746962 	svcpl	0x00746962
    18ec:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    18f0:	00355f38 	eorseq	r5, r5, r8, lsr pc
    18f4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    18f8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    18fc:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1900:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1904:	33356178 	teqcc	r5, #120, 2
    1908:	52415400 	subpl	r5, r1, #0, 8
    190c:	5f544547 	svcpl	0x00544547
    1910:	5f555043 	svcpl	0x00555043
    1914:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1918:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    191c:	41540035 	cmpmi	r4, r5, lsr r0
    1920:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1924:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1928:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    192c:	61786574 	cmnvs	r8, r4, ror r5
    1930:	54003735 	strpl	r3, [r0], #-1845	; 0xfffff8cb
    1934:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1938:	50435f54 	subpl	r5, r3, r4, asr pc
    193c:	706d5f55 	rsbvc	r5, sp, r5, asr pc
    1940:	65726f63 	ldrbvs	r6, [r2, #-3939]!	; 0xfffff09d
    1944:	52415400 	subpl	r5, r1, #0, 8
    1948:	5f544547 	svcpl	0x00544547
    194c:	5f555043 	svcpl	0x00555043
    1950:	5f6d7261 	svcpl	0x006d7261
    1954:	656e6f6e 	strbvs	r6, [lr, #-3950]!	; 0xfffff092
    1958:	6d726100 	ldfvse	f6, [r2, #-0]
    195c:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1960:	6f6e5f68 	svcvs	0x006e5f68
    1964:	54006d74 	strpl	r6, [r0], #-3444	; 0xfffff28c
    1968:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    196c:	50435f54 	subpl	r5, r3, r4, asr pc
    1970:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1974:	3230316d 	eorscc	r3, r0, #1073741851	; 0x4000001b
    1978:	736a6536 	cmnvc	sl, #226492416	; 0xd800000
    197c:	53414200 	movtpl	r4, #4608	; 0x1200
    1980:	52415f45 	subpl	r5, r1, #276	; 0x114
    1984:	365f4843 	ldrbcc	r4, [pc], -r3, asr #16
    1988:	4142004a 	cmpmi	r2, sl, asr #32
    198c:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1990:	5f484352 	svcpl	0x00484352
    1994:	42004b36 	andmi	r4, r0, #55296	; 0xd800
    1998:	5f455341 	svcpl	0x00455341
    199c:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    19a0:	004d365f 	subeq	r3, sp, pc, asr r6
    19a4:	5f617369 	svcpl	0x00617369
    19a8:	5f746962 	svcpl	0x00746962
    19ac:	6d6d7769 	stclvs	7, cr7, [sp, #-420]!	; 0xfffffe5c
    19b0:	54007478 	strpl	r7, [r0], #-1144	; 0xfffffb88
    19b4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    19b8:	50435f54 	subpl	r5, r3, r4, asr pc
    19bc:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    19c0:	3331316d 	teqcc	r1, #1073741851	; 0x4000001b
    19c4:	73666a36 	cmnvc	r6, #221184	; 0x36000
    19c8:	4d524100 	ldfmie	f4, [r2, #-0]
    19cc:	00534c5f 	subseq	r4, r3, pc, asr ip
    19d0:	5f4d5241 	svcpl	0x004d5241
    19d4:	4200544c 	andmi	r5, r0, #76, 8	; 0x4c000000
    19d8:	5f455341 	svcpl	0x00455341
    19dc:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    19e0:	005a365f 	subseq	r3, sl, pc, asr r6
    19e4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    19e8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    19ec:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    19f0:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    19f4:	35376178 	ldrcc	r6, [r7, #-376]!	; 0xfffffe88
    19f8:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    19fc:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    1a00:	52410035 	subpl	r0, r1, #53	; 0x35
    1a04:	43505f4d 	cmpmi	r0, #308	; 0x134
    1a08:	41415f53 	cmpmi	r1, r3, asr pc
    1a0c:	5f534350 	svcpl	0x00534350
    1a10:	00504656 	subseq	r4, r0, r6, asr r6
    1a14:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1a18:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1a1c:	695f5550 	ldmdbvs	pc, {r4, r6, r8, sl, ip, lr}^	; <UNPREDICTABLE>
    1a20:	786d6d77 	stmdavc	sp!, {r0, r1, r2, r4, r5, r6, r8, sl, fp, sp, lr}^
    1a24:	69003274 	stmdbvs	r0, {r2, r4, r5, r6, r9, ip, sp}
    1a28:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1a2c:	6e5f7469 	cdpvs	4, 5, cr7, cr15, cr9, {3}
    1a30:	006e6f65 	rsbeq	r6, lr, r5, ror #30
    1a34:	5f6d7261 	svcpl	0x006d7261
    1a38:	5f757066 	svcpl	0x00757066
    1a3c:	72747461 	rsbsvc	r7, r4, #1627389952	; 0x61000000
    1a40:	61736900 	cmnvs	r3, r0, lsl #18
    1a44:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1a48:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1a4c:	6d653776 	stclvs	7, cr3, [r5, #-472]!	; 0xfffffe28
    1a50:	52415400 	subpl	r5, r1, #0, 8
    1a54:	5f544547 	svcpl	0x00544547
    1a58:	5f555043 	svcpl	0x00555043
    1a5c:	32366166 	eorscc	r6, r6, #-2147483623	; 0x80000019
    1a60:	00657436 	rsbeq	r7, r5, r6, lsr r4
    1a64:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1a68:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1a6c:	6d5f5550 	cfldr64vs	mvdx5, [pc, #-320]	; 1934 <CPSR_IRQ_INHIBIT+0x18b4>
    1a70:	65767261 	ldrbvs	r7, [r6, #-609]!	; 0xfffffd9f
    1a74:	705f6c6c 	subsvc	r6, pc, ip, ror #24
    1a78:	6800346a 	stmdavs	r0, {r1, r3, r5, r6, sl, ip, sp}
    1a7c:	5f626174 	svcpl	0x00626174
    1a80:	68736168 	ldmdavs	r3!, {r3, r5, r6, r8, sp, lr}^
    1a84:	696f705f 	stmdbvs	pc!, {r0, r1, r2, r3, r4, r6, ip, sp, lr}^	; <UNPREDICTABLE>
    1a88:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
    1a8c:	6d726100 	ldfvse	f6, [r2, #-0]
    1a90:	6e75745f 	mrcvs	4, 3, r7, cr5, cr15, {2}
    1a94:	6f635f65 	svcvs	0x00635f65
    1a98:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1a9c:	0039615f 	eorseq	r6, r9, pc, asr r1
    1aa0:	5f617369 	svcpl	0x00617369
    1aa4:	5f746962 	svcpl	0x00746962
    1aa8:	6d6d7769 	stclvs	7, cr7, [sp, #-420]!	; 0xfffffe5c
    1aac:	00327478 	eorseq	r7, r2, r8, ror r4
    1ab0:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1ab4:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1ab8:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1abc:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1ac0:	32376178 	eorscc	r6, r7, #120, 2
    1ac4:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1ac8:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    1acc:	73690033 	cmnvc	r9, #51	; 0x33
    1ad0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1ad4:	68745f74 	ldmdavs	r4!, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    1ad8:	32626d75 	rsbcc	r6, r2, #7488	; 0x1d40
    1adc:	53414200 	movtpl	r4, #4608	; 0x1200
    1ae0:	52415f45 	subpl	r5, r1, #276	; 0x114
    1ae4:	375f4843 	ldrbcc	r4, [pc, -r3, asr #16]
    1ae8:	73690041 	cmnvc	r9, #65	; 0x41
    1aec:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1af0:	6f645f74 	svcvs	0x00645f74
    1af4:	6f727074 	svcvs	0x00727074
    1af8:	72610064 	rsbvc	r0, r1, #100	; 0x64
    1afc:	70665f6d 	rsbvc	r5, r6, sp, ror #30
    1b00:	745f3631 	ldrbvc	r3, [pc], #-1585	; 1b08 <CPSR_IRQ_INHIBIT+0x1a88>
    1b04:	5f657079 	svcpl	0x00657079
    1b08:	65646f6e 	strbvs	r6, [r4, #-3950]!	; 0xfffff092
    1b0c:	4d524100 	ldfmie	f4, [r2, #-0]
    1b10:	00494d5f 	subeq	r4, r9, pc, asr sp
    1b14:	5f6d7261 	svcpl	0x006d7261
    1b18:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1b1c:	61006b36 	tstvs	r0, r6, lsr fp
    1b20:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1b24:	36686372 			; <UNDEFINED> instruction: 0x36686372
    1b28:	4142006d 	cmpmi	r2, sp, rrx
    1b2c:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1b30:	5f484352 	svcpl	0x00484352
    1b34:	5f005237 	svcpl	0x00005237
    1b38:	706f705f 	rsbvc	r7, pc, pc, asr r0	; <UNPREDICTABLE>
    1b3c:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
    1b40:	61745f74 	cmnvs	r4, r4, ror pc
    1b44:	622f0062 	eorvs	r0, pc, #98	; 0x62
    1b48:	646c6975 	strbtvs	r6, [ip], #-2421	; 0xfffff68b
    1b4c:	6363672f 	cmnvs	r3, #12320768	; 0xbc0000
    1b50:	6d72612d 	ldfvse	f6, [r2, #-180]!	; 0xffffff4c
    1b54:	6e6f6e2d 	cdpvs	14, 6, cr6, cr15, cr13, {1}
    1b58:	61652d65 	cmnvs	r5, r5, ror #26
    1b5c:	472d6962 	strmi	r6, [sp, -r2, ror #18]!
    1b60:	546b396c 	strbtpl	r3, [fp], #-2412	; 0xfffff694
    1b64:	63672f39 	cmnvs	r7, #57, 30	; 0xe4
    1b68:	72612d63 	rsbvc	r2, r1, #6336	; 0x18c0
    1b6c:	6f6e2d6d 	svcvs	0x006e2d6d
    1b70:	652d656e 	strvs	r6, [sp, #-1390]!	; 0xfffffa92
    1b74:	2d696261 	sfmcs	f6, 2, [r9, #-388]!	; 0xfffffe7c
    1b78:	30322d39 	eorscc	r2, r2, r9, lsr sp
    1b7c:	712d3931 			; <UNDEFINED> instruction: 0x712d3931
    1b80:	75622f34 	strbvc	r2, [r2, #-3892]!	; 0xfffff0cc
    1b84:	2f646c69 	svccs	0x00646c69
    1b88:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
    1b8c:	656e6f6e 	strbvs	r6, [lr, #-3950]!	; 0xfffff092
    1b90:	6261652d 	rsbvs	r6, r1, #188743680	; 0xb400000
    1b94:	72612f69 	rsbvc	r2, r1, #420	; 0x1a4
    1b98:	35762f6d 	ldrbcc	r2, [r6, #-3949]!	; 0xfffff093
    1b9c:	682f6574 	stmdavs	pc!, {r2, r4, r5, r6, r8, sl, sp, lr}	; <UNPREDICTABLE>
    1ba0:	2f647261 	svccs	0x00647261
    1ba4:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    1ba8:	69006363 	stmdbvs	r0, {r0, r1, r5, r6, r8, r9, sp, lr}
    1bac:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1bb0:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    1bb4:	0065736d 	rsbeq	r7, r5, sp, ror #6
    1bb8:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1bbc:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1bc0:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1bc4:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1bc8:	33376178 	teqcc	r7, #120, 2
    1bcc:	52415400 	subpl	r5, r1, #0, 8
    1bd0:	5f544547 	svcpl	0x00544547
    1bd4:	5f555043 	svcpl	0x00555043
    1bd8:	656e6567 	strbvs	r6, [lr, #-1383]!	; 0xfffffa99
    1bdc:	76636972 			; <UNDEFINED> instruction: 0x76636972
    1be0:	54006137 	strpl	r6, [r0], #-311	; 0xfffffec9
    1be4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1be8:	50435f54 	subpl	r5, r3, r4, asr pc
    1bec:	6f635f55 	svcvs	0x00635f55
    1bf0:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1bf4:	00363761 	eorseq	r3, r6, r1, ror #14
    1bf8:	5f6d7261 	svcpl	0x006d7261
    1bfc:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1c00:	5f6f6e5f 	svcpl	0x006f6e5f
    1c04:	616c6f76 	smcvs	50934	; 0xc6f6
    1c08:	656c6974 	strbvs	r6, [ip, #-2420]!	; 0xfffff68c
    1c0c:	0065635f 	rsbeq	r6, r5, pc, asr r3
    1c10:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1c14:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1c18:	41385f48 	teqmi	r8, r8, asr #30
    1c1c:	61736900 	cmnvs	r3, r0, lsl #18
    1c20:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1c24:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1c28:	00743576 	rsbseq	r3, r4, r6, ror r5
    1c2c:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1c30:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1c34:	52385f48 	eorspl	r5, r8, #72, 30	; 0x120
    1c38:	52415400 	subpl	r5, r1, #0, 8
    1c3c:	5f544547 	svcpl	0x00544547
    1c40:	5f555043 	svcpl	0x00555043
    1c44:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1c48:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    1c4c:	726f6333 	rsbvc	r6, pc, #-872415232	; 0xcc000000
    1c50:	61786574 	cmnvs	r8, r4, ror r5
    1c54:	41003533 	tstmi	r0, r3, lsr r5
    1c58:	4e5f4d52 	mrcmi	13, 2, r4, cr15, cr2, {2}
    1c5c:	72610056 	rsbvc	r0, r1, #86	; 0x56
    1c60:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    1c64:	00346863 	eorseq	r6, r4, r3, ror #16
    1c68:	5f6d7261 	svcpl	0x006d7261
    1c6c:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1c70:	72610036 	rsbvc	r0, r1, #54	; 0x36
    1c74:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    1c78:	00376863 	eorseq	r6, r7, r3, ror #16
    1c7c:	5f6d7261 	svcpl	0x006d7261
    1c80:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1c84:	6f6c0038 	svcvs	0x006c0038
    1c88:	6420676e 	strtvs	r6, [r0], #-1902	; 0xfffff892
    1c8c:	6c62756f 	cfstr64vs	mvdx7, [r2], #-444	; 0xfffffe44
    1c90:	72610065 	rsbvc	r0, r1, #101	; 0x65
    1c94:	75745f6d 	ldrbvc	r5, [r4, #-3949]!	; 0xfffff093
    1c98:	785f656e 	ldmdavc	pc, {r1, r2, r3, r5, r6, r8, sl, sp, lr}^	; <UNPREDICTABLE>
    1c9c:	6c616373 	stclvs	3, cr6, [r1], #-460	; 0xfffffe34
    1ca0:	616d0065 	cmnvs	sp, r5, rrx
    1ca4:	676e696b 	strbvs	r6, [lr, -fp, ror #18]!
    1ca8:	6e6f635f 	mcrvs	3, 3, r6, cr15, cr15, {2}
    1cac:	745f7473 	ldrbvc	r7, [pc], #-1139	; 1cb4 <CPSR_IRQ_INHIBIT+0x1c34>
    1cb0:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
    1cb4:	75687400 	strbvc	r7, [r8, #-1024]!	; 0xfffffc00
    1cb8:	635f626d 	cmpvs	pc, #-805306362	; 0xd0000006
    1cbc:	5f6c6c61 	svcpl	0x006c6c61
    1cc0:	5f616976 	svcpl	0x00616976
    1cc4:	6562616c 	strbvs	r6, [r2, #-364]!	; 0xfffffe94
    1cc8:	7369006c 	cmnvc	r9, #108	; 0x6c
    1ccc:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1cd0:	70665f74 	rsbvc	r5, r6, r4, ror pc
    1cd4:	69003576 	stmdbvs	r0, {r1, r2, r4, r5, r6, r8, sl, ip, sp}
    1cd8:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1cdc:	615f7469 	cmpvs	pc, r9, ror #8
    1ce0:	36766d72 			; <UNDEFINED> instruction: 0x36766d72
    1ce4:	4154006b 	cmpmi	r4, fp, rrx
    1ce8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1cec:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1cf0:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1cf4:	61786574 	cmnvs	r8, r4, ror r5
    1cf8:	41540037 	cmpmi	r4, r7, lsr r0
    1cfc:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1d00:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1d04:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1d08:	61786574 	cmnvs	r8, r4, ror r5
    1d0c:	41540038 	cmpmi	r4, r8, lsr r0
    1d10:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1d14:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1d18:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1d1c:	61786574 	cmnvs	r8, r4, ror r5
    1d20:	52410039 	subpl	r0, r1, #57	; 0x39
    1d24:	43505f4d 	cmpmi	r0, #308	; 0x134
    1d28:	50415f53 	subpl	r5, r1, r3, asr pc
    1d2c:	41005343 	tstmi	r0, r3, asr #6
    1d30:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    1d34:	415f5343 	cmpmi	pc, r3, asr #6
    1d38:	53435054 	movtpl	r5, #12372	; 0x3054
    1d3c:	6d6f6300 	stclvs	3, cr6, [pc, #-0]	; 1d44 <CPSR_IRQ_INHIBIT+0x1cc4>
    1d40:	78656c70 	stmdavc	r5!, {r4, r5, r6, sl, fp, sp, lr}^
    1d44:	756f6420 	strbvc	r6, [pc, #-1056]!	; 192c <CPSR_IRQ_INHIBIT+0x18ac>
    1d48:	00656c62 	rsbeq	r6, r5, r2, ror #24
    1d4c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1d50:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1d54:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1d58:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1d5c:	33376178 	teqcc	r7, #120, 2
    1d60:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1d64:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    1d68:	41540033 	cmpmi	r4, r3, lsr r0
    1d6c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1d70:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1d74:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1d78:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    1d7c:	756c7030 	strbvc	r7, [ip, #-48]!	; 0xffffffd0
    1d80:	72610073 	rsbvc	r0, r1, #115	; 0x73
    1d84:	63635f6d 	cmnvs	r3, #436	; 0x1b4
    1d88:	61736900 	cmnvs	r3, r0, lsl #18
    1d8c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1d90:	6373785f 	cmnvs	r3, #6225920	; 0x5f0000
    1d94:	00656c61 	rsbeq	r6, r5, r1, ror #24
    1d98:	6e6f645f 	mcrvs	4, 3, r6, cr15, cr15, {2}
    1d9c:	73755f74 	cmnvc	r5, #116, 30	; 0x1d0
    1da0:	72745f65 	rsbsvc	r5, r4, #404	; 0x194
    1da4:	685f6565 	ldmdavs	pc, {r0, r2, r5, r6, r8, sl, sp, lr}^	; <UNPREDICTABLE>
    1da8:	5f657265 	svcpl	0x00657265
    1dac:	52415400 	subpl	r5, r1, #0, 8
    1db0:	5f544547 	svcpl	0x00544547
    1db4:	5f555043 	svcpl	0x00555043
    1db8:	316d7261 	cmncc	sp, r1, ror #4
    1dbc:	6d647430 	cfstrdvs	mvd7, [r4, #-192]!	; 0xffffff40
    1dc0:	41540069 	cmpmi	r4, r9, rrx
    1dc4:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1dc8:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1dcc:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1dd0:	61786574 	cmnvs	r8, r4, ror r5
    1dd4:	61620035 	cmnvs	r2, r5, lsr r0
    1dd8:	615f6573 	cmpvs	pc, r3, ror r5	; <UNPREDICTABLE>
    1ddc:	69686372 	stmdbvs	r8!, {r1, r4, r5, r6, r8, r9, sp, lr}^
    1de0:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
    1de4:	00657275 	rsbeq	r7, r5, r5, ror r2
    1de8:	5f6d7261 	svcpl	0x006d7261
    1dec:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1df0:	6372635f 	cmnvs	r2, #2080374785	; 0x7c000001
    1df4:	52415400 	subpl	r5, r1, #0, 8
    1df8:	5f544547 	svcpl	0x00544547
    1dfc:	5f555043 	svcpl	0x00555043
    1e00:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1e04:	316d7865 	cmncc	sp, r5, ror #16
    1e08:	6c616d73 	stclvs	13, cr6, [r1], #-460	; 0xfffffe34
    1e0c:	6c756d6c 	ldclvs	13, cr6, [r5], #-432	; 0xfffffe50
    1e10:	6c706974 			; <UNDEFINED> instruction: 0x6c706974
    1e14:	72610079 	rsbvc	r0, r1, #121	; 0x79
    1e18:	75635f6d 	strbvc	r5, [r3, #-3949]!	; 0xfffff093
    1e1c:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
    1e20:	63635f74 	cmnvs	r3, #116, 30	; 0x1d0
    1e24:	61736900 	cmnvs	r3, r0, lsl #18
    1e28:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1e2c:	6372635f 	cmnvs	r2, #2080374785	; 0x7c000001
    1e30:	41003233 	tstmi	r0, r3, lsr r2
    1e34:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    1e38:	7369004c 	cmnvc	r9, #76	; 0x4c
    1e3c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1e40:	66765f74 	uhsub16vs	r5, r6, r4
    1e44:	00337670 	eorseq	r7, r3, r0, ror r6
    1e48:	5f617369 	svcpl	0x00617369
    1e4c:	5f746962 	svcpl	0x00746962
    1e50:	76706676 			; <UNDEFINED> instruction: 0x76706676
    1e54:	41420034 	cmpmi	r2, r4, lsr r0
    1e58:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1e5c:	5f484352 	svcpl	0x00484352
    1e60:	00325436 	eorseq	r5, r2, r6, lsr r4
    1e64:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1e68:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1e6c:	4d385f48 	ldcmi	15, cr5, [r8, #-288]!	; 0xfffffee0
    1e70:	49414d5f 	stmdbmi	r1, {r0, r1, r2, r3, r4, r6, r8, sl, fp, lr}^
    1e74:	4154004e 	cmpmi	r4, lr, asr #32
    1e78:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1e7c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1e80:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1e84:	6d647439 	cfstrdvs	mvd7, [r4, #-228]!	; 0xffffff1c
    1e88:	52410069 	subpl	r0, r1, #105	; 0x69
    1e8c:	4c415f4d 	mcrrmi	15, 4, r5, r1, cr13
    1e90:	53414200 	movtpl	r4, #4608	; 0x1200
    1e94:	52415f45 	subpl	r5, r1, #276	; 0x114
    1e98:	375f4843 	ldrbcc	r4, [pc, -r3, asr #16]
    1e9c:	7261004d 	rsbvc	r0, r1, #77	; 0x4d
    1ea0:	61745f6d 	cmnvs	r4, sp, ror #30
    1ea4:	74656772 	strbtvc	r6, [r5], #-1906	; 0xfffff88e
    1ea8:	62616c5f 	rsbvs	r6, r1, #24320	; 0x5f00
    1eac:	61006c65 	tstvs	r0, r5, ror #24
    1eb0:	745f6d72 	ldrbvc	r6, [pc], #-3442	; 1eb8 <CPSR_IRQ_INHIBIT+0x1e38>
    1eb4:	65677261 	strbvs	r7, [r7, #-609]!	; 0xfffffd9f
    1eb8:	6e695f74 	mcrvs	15, 3, r5, cr9, cr4, {3}
    1ebc:	54006e73 	strpl	r6, [r0], #-3699	; 0xfffff18d
    1ec0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1ec4:	50435f54 	subpl	r5, r3, r4, asr pc
    1ec8:	6f635f55 	svcvs	0x00635f55
    1ecc:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1ed0:	54003472 	strpl	r3, [r0], #-1138	; 0xfffffb8e
    1ed4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1ed8:	50435f54 	subpl	r5, r3, r4, asr pc
    1edc:	6f635f55 	svcvs	0x00635f55
    1ee0:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1ee4:	54003572 	strpl	r3, [r0], #-1394	; 0xfffffa8e
    1ee8:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1eec:	50435f54 	subpl	r5, r3, r4, asr pc
    1ef0:	6f635f55 	svcvs	0x00635f55
    1ef4:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1ef8:	54003772 	strpl	r3, [r0], #-1906	; 0xfffff88e
    1efc:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1f00:	50435f54 	subpl	r5, r3, r4, asr pc
    1f04:	6f635f55 	svcvs	0x00635f55
    1f08:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1f0c:	69003872 	stmdbvs	r0, {r1, r4, r5, r6, fp, ip, sp}
    1f10:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1f14:	6c5f7469 	cfldrdvs	mvd7, [pc], {105}	; 0x69
    1f18:	00656170 	rsbeq	r6, r5, r0, ror r1
    1f1c:	5f617369 	svcpl	0x00617369
    1f20:	5f746962 	svcpl	0x00746962
    1f24:	72697571 	rsbvc	r7, r9, #473956352	; 0x1c400000
    1f28:	72615f6b 	rsbvc	r5, r1, #428	; 0x1ac
    1f2c:	6b36766d 	blvs	d9f8e8 <_bss_end+0xd966a0>
    1f30:	7369007a 	cmnvc	r9, #122	; 0x7a
    1f34:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1f38:	6f6e5f74 	svcvs	0x006e5f74
    1f3c:	69006d74 	stmdbvs	r0, {r2, r4, r5, r6, r8, sl, fp, sp, lr}
    1f40:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1f44:	615f7469 	cmpvs	pc, r9, ror #8
    1f48:	34766d72 	ldrbtcc	r6, [r6], #-3442	; 0xfffff28e
    1f4c:	61736900 	cmnvs	r3, r0, lsl #18
    1f50:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1f54:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1f58:	69003676 	stmdbvs	r0, {r1, r2, r4, r5, r6, r9, sl, ip, sp}
    1f5c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1f60:	615f7469 	cmpvs	pc, r9, ror #8
    1f64:	37766d72 			; <UNDEFINED> instruction: 0x37766d72
    1f68:	61736900 	cmnvs	r3, r0, lsl #18
    1f6c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1f70:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1f74:	5f003876 	svcpl	0x00003876
    1f78:	746e6f64 	strbtvc	r6, [lr], #-3940	; 0xfffff09c
    1f7c:	6573755f 	ldrbvs	r7, [r3, #-1375]!	; 0xfffffaa1
    1f80:	7874725f 	ldmdavc	r4!, {r0, r1, r2, r3, r4, r6, r9, ip, sp, lr}^
    1f84:	7265685f 	rsbvc	r6, r5, #6225920	; 0x5f0000
    1f88:	55005f65 	strpl	r5, [r0, #-3941]	; 0xfffff09b
    1f8c:	79744951 	ldmdbvc	r4!, {r0, r4, r6, r8, fp, lr}^
    1f90:	69006570 	stmdbvs	r0, {r4, r5, r6, r8, sl, sp, lr}
    1f94:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1f98:	615f7469 	cmpvs	pc, r9, ror #8
    1f9c:	35766d72 	ldrbcc	r6, [r6, #-3442]!	; 0xfffff28e
    1fa0:	61006574 	tstvs	r0, r4, ror r5
    1fa4:	745f6d72 	ldrbvc	r6, [pc], #-3442	; 1fac <CPSR_IRQ_INHIBIT+0x1f2c>
    1fa8:	00656e75 	rsbeq	r6, r5, r5, ror lr
    1fac:	5f6d7261 	svcpl	0x006d7261
    1fb0:	5f707063 	svcpl	0x00707063
    1fb4:	65746e69 	ldrbvs	r6, [r4, #-3689]!	; 0xfffff197
    1fb8:	726f7772 	rsbvc	r7, pc, #29884416	; 0x1c80000
    1fbc:	7566006b 	strbvc	r0, [r6, #-107]!	; 0xffffff95
    1fc0:	705f636e 	subsvc	r6, pc, lr, ror #6
    1fc4:	54007274 	strpl	r7, [r0], #-628	; 0xfffffd8c
    1fc8:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1fcc:	50435f54 	subpl	r5, r3, r4, asr pc
    1fd0:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1fd4:	3032396d 	eorscc	r3, r2, sp, ror #18
    1fd8:	74680074 	strbtvc	r0, [r8], #-116	; 0xffffff8c
    1fdc:	655f6261 	ldrbvs	r6, [pc, #-609]	; 1d83 <CPSR_IRQ_INHIBIT+0x1d03>
    1fe0:	41540071 	cmpmi	r4, r1, ror r0
    1fe4:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1fe8:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1fec:	3561665f 	strbcc	r6, [r1, #-1631]!	; 0xfffff9a1
    1ff0:	61003632 	tstvs	r0, r2, lsr r6
    1ff4:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1ff8:	5f686372 	svcpl	0x00686372
    1ffc:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    2000:	77685f62 	strbvc	r5, [r8, -r2, ror #30]!
    2004:	00766964 	rsbseq	r6, r6, r4, ror #18
    2008:	62617468 	rsbvs	r7, r1, #104, 8	; 0x68000000
    200c:	5f71655f 	svcpl	0x0071655f
    2010:	6e696f70 	mcrvs	15, 3, r6, cr9, cr0, {3}
    2014:	00726574 	rsbseq	r6, r2, r4, ror r5
    2018:	5f6d7261 	svcpl	0x006d7261
    201c:	5f636970 	svcpl	0x00636970
    2020:	69676572 	stmdbvs	r7!, {r1, r4, r5, r6, r8, sl, sp, lr}^
    2024:	72657473 	rsbvc	r7, r5, #1929379840	; 0x73000000
    2028:	52415400 	subpl	r5, r1, #0, 8
    202c:	5f544547 	svcpl	0x00544547
    2030:	5f555043 	svcpl	0x00555043
    2034:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2038:	306d7865 	rsbcc	r7, sp, r5, ror #16
    203c:	6c616d73 	stclvs	13, cr6, [r1], #-460	; 0xfffffe34
    2040:	6c756d6c 	ldclvs	13, cr6, [r5], #-432	; 0xfffffe50
    2044:	6c706974 			; <UNDEFINED> instruction: 0x6c706974
    2048:	41540079 	cmpmi	r4, r9, ror r0
    204c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2050:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2054:	63706d5f 	cmnvs	r0, #6080	; 0x17c0
    2058:	6e65726f 	cdpvs	2, 6, cr7, cr5, cr15, {3}
    205c:	7066766f 	rsbvc	r7, r6, pc, ror #12
    2060:	61736900 	cmnvs	r3, r0, lsl #18
    2064:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2068:	6975715f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, r8, ip, sp, lr}^
    206c:	635f6b72 	cmpvs	pc, #116736	; 0x1c800
    2070:	6c5f336d 	mrrcvs	3, 6, r3, pc, cr13	; <UNPREDICTABLE>
    2074:	00647264 	rsbeq	r7, r4, r4, ror #4
    2078:	5f4d5241 	svcpl	0x004d5241
    207c:	61004343 	tstvs	r0, r3, asr #6
    2080:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2084:	38686372 	stmdacc	r8!, {r1, r4, r5, r6, r8, r9, sp, lr}^
    2088:	6100325f 	tstvs	r0, pc, asr r2
    208c:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2090:	38686372 	stmdacc	r8!, {r1, r4, r5, r6, r8, r9, sp, lr}^
    2094:	6100335f 	tstvs	r0, pc, asr r3
    2098:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    209c:	38686372 	stmdacc	r8!, {r1, r4, r5, r6, r8, r9, sp, lr}^
    20a0:	5400345f 	strpl	r3, [r0], #-1119	; 0xfffffba1
    20a4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    20a8:	50435f54 	subpl	r5, r3, r4, asr pc
    20ac:	6d665f55 	stclvs	15, cr5, [r6, #-340]!	; 0xfffffeac
    20b0:	36323670 			; <UNDEFINED> instruction: 0x36323670
    20b4:	4d524100 	ldfmie	f4, [r2, #-0]
    20b8:	0053435f 	subseq	r4, r3, pc, asr r3
    20bc:	5f6d7261 	svcpl	0x006d7261
    20c0:	36317066 	ldrtcc	r7, [r1], -r6, rrx
    20c4:	736e695f 	cmnvc	lr, #1556480	; 0x17c000
    20c8:	72610074 	rsbvc	r0, r1, #116	; 0x74
    20cc:	61625f6d 	cmnvs	r2, sp, ror #30
    20d0:	615f6573 	cmpvs	pc, r3, ror r5	; <UNPREDICTABLE>
    20d4:	00686372 	rsbeq	r6, r8, r2, ror r3
    20d8:	47524154 			; <UNDEFINED> instruction: 0x47524154
    20dc:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    20e0:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    20e4:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    20e8:	35316178 	ldrcc	r6, [r1, #-376]!	; 0xfffffe88
    20ec:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    20f0:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    20f4:	6d726100 	ldfvse	f6, [r2, #-0]
    20f8:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    20fc:	6d653768 	stclvs	7, cr3, [r5, #-416]!	; 0xfffffe60
    2100:	52415400 	subpl	r5, r1, #0, 8
    2104:	5f544547 	svcpl	0x00544547
    2108:	5f555043 	svcpl	0x00555043
    210c:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2110:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    2114:	72610032 	rsbvc	r0, r1, #50	; 0x32
    2118:	63705f6d 	cmnvs	r0, #436	; 0x1b4
    211c:	65645f73 	strbvs	r5, [r4, #-3955]!	; 0xfffff08d
    2120:	6c756166 	ldfvse	f6, [r5], #-408	; 0xfffffe68
    2124:	52410074 	subpl	r0, r1, #116	; 0x74
    2128:	43505f4d 	cmpmi	r0, #308	; 0x134
    212c:	41415f53 	cmpmi	r1, r3, asr pc
    2130:	5f534350 	svcpl	0x00534350
    2134:	41434f4c 	cmpmi	r3, ip, asr #30
    2138:	4154004c 	cmpmi	r4, ip, asr #32
    213c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2140:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2144:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2148:	61786574 	cmnvs	r8, r4, ror r5
    214c:	54003537 	strpl	r3, [r0], #-1335	; 0xfffffac9
    2150:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2154:	50435f54 	subpl	r5, r3, r4, asr pc
    2158:	74735f55 	ldrbtvc	r5, [r3], #-3925	; 0xfffff0ab
    215c:	676e6f72 			; <UNDEFINED> instruction: 0x676e6f72
    2160:	006d7261 	rsbeq	r7, sp, r1, ror #4
    2164:	5f6d7261 	svcpl	0x006d7261
    2168:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    216c:	7568745f 	strbvc	r7, [r8, #-1119]!	; 0xfffffba1
    2170:	0031626d 	eorseq	r6, r1, sp, ror #4
    2174:	5f6d7261 	svcpl	0x006d7261
    2178:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    217c:	7568745f 	strbvc	r7, [r8, #-1119]!	; 0xfffffba1
    2180:	0032626d 	eorseq	r6, r2, sp, ror #4
    2184:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2188:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    218c:	695f5550 	ldmdbvs	pc, {r4, r6, r8, sl, ip, lr}^	; <UNPREDICTABLE>
    2190:	786d6d77 	stmdavc	sp!, {r0, r1, r2, r4, r5, r6, r8, sl, fp, sp, lr}^
    2194:	72610074 	rsbvc	r0, r1, #116	; 0x74
    2198:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    219c:	74356863 	ldrtvc	r6, [r5], #-2147	; 0xfffff79d
    21a0:	61736900 	cmnvs	r3, r0, lsl #18
    21a4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    21a8:	00706d5f 	rsbseq	r6, r0, pc, asr sp
    21ac:	5f6d7261 	svcpl	0x006d7261
    21b0:	735f646c 	cmpvc	pc, #108, 8	; 0x6c000000
    21b4:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
    21b8:	6d726100 	ldfvse	f6, [r2, #-0]
    21bc:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    21c0:	315f3868 	cmpcc	pc, r8, ror #16
	...

Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347 	bcc	10d0d24 <_bss_end+0x10c7adc>
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
  10:	4b5a3605 	blmi	168d82c <_bss_end+0x16845e4>
  14:	08070600 	stmdaeq	r7, {r9, sl}
  18:	0a010901 	beq	42424 <_bss_end+0x391dc>
  1c:	14041202 	strne	r1, [r4], #-514	; 0xfffffdfe
  20:	17011501 	strne	r1, [r1, -r1, lsl #10]
  24:	1a011803 	bne	46038 <_bss_end+0x3cdf0>
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
  20:	8b040e42 	blhi	103930 <_bss_end+0xfa6e8>
  24:	0b0d4201 	bleq	350830 <_bss_end+0x3475e8>
  28:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
  2c:	00000ecb 	andeq	r0, r0, fp, asr #29
  30:	0000001c 	andeq	r0, r0, ip, lsl r0
  34:	00000000 	andeq	r0, r0, r0
  38:	000080cc 	andeq	r8, r0, ip, asr #1
  3c:	0000002c 	andeq	r0, r0, ip, lsr #32
  40:	8b040e42 	blhi	103950 <_bss_end+0xfa708>
  44:	0b0d4201 	bleq	350850 <_bss_end+0x347608>
  48:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
  4c:	00000ecb 	andeq	r0, r0, fp, asr #29
  50:	0000001c 	andeq	r0, r0, ip, lsl r0
  54:	00000000 	andeq	r0, r0, r0
  58:	000080f8 	strdeq	r8, [r0], -r8	; <UNPREDICTABLE>
  5c:	00000020 	andeq	r0, r0, r0, lsr #32
  60:	8b040e42 	blhi	103970 <_bss_end+0xfa728>
  64:	0b0d4201 	bleq	350870 <_bss_end+0x347628>
  68:	420d0d48 	andmi	r0, sp, #72, 26	; 0x1200
  6c:	00000ecb 	andeq	r0, r0, fp, asr #29
  70:	0000001c 	andeq	r0, r0, ip, lsl r0
  74:	00000000 	andeq	r0, r0, r0
  78:	00008118 	andeq	r8, r0, r8, lsl r1
  7c:	00000018 	andeq	r0, r0, r8, lsl r0
  80:	8b040e42 	blhi	103990 <_bss_end+0xfa748>
  84:	0b0d4201 	bleq	350890 <_bss_end+0x347648>
  88:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  8c:	00000ecb 	andeq	r0, r0, fp, asr #29
  90:	0000001c 	andeq	r0, r0, ip, lsl r0
  94:	00000000 	andeq	r0, r0, r0
  98:	00008130 	andeq	r8, r0, r0, lsr r1
  9c:	00000018 	andeq	r0, r0, r8, lsl r0
  a0:	8b040e42 	blhi	1039b0 <_bss_end+0xfa768>
  a4:	0b0d4201 	bleq	3508b0 <_bss_end+0x347668>
  a8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  ac:	00000ecb 	andeq	r0, r0, fp, asr #29
  b0:	0000001c 	andeq	r0, r0, ip, lsl r0
  b4:	00000000 	andeq	r0, r0, r0
  b8:	00008148 	andeq	r8, r0, r8, asr #2
  bc:	00000018 	andeq	r0, r0, r8, lsl r0
  c0:	8b040e42 	blhi	1039d0 <_bss_end+0xfa788>
  c4:	0b0d4201 	bleq	3508d0 <_bss_end+0x347688>
  c8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  cc:	00000ecb 	andeq	r0, r0, fp, asr #29
  d0:	00000014 	andeq	r0, r0, r4, lsl r0
  d4:	00000000 	andeq	r0, r0, r0
  d8:	00008160 	andeq	r8, r0, r0, ror #2
  dc:	0000000c 	andeq	r0, r0, ip
  e0:	8b040e42 	blhi	1039f0 <_bss_end+0xfa7a8>
  e4:	0b0d4201 	bleq	3508f0 <_bss_end+0x3476a8>
  e8:	0000000c 	andeq	r0, r0, ip
  ec:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  f0:	7c020001 	stcvc	0, cr0, [r2], {1}
  f4:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  f8:	0000001c 	andeq	r0, r0, ip, lsl r0
  fc:	000000e8 	andeq	r0, r0, r8, ror #1
 100:	0000816c 	andeq	r8, r0, ip, ror #2
 104:	00000034 	andeq	r0, r0, r4, lsr r0
 108:	8b040e42 	blhi	103a18 <_bss_end+0xfa7d0>
 10c:	0b0d4201 	bleq	350918 <_bss_end+0x3476d0>
 110:	420d0d52 	andmi	r0, sp, #5248	; 0x1480
 114:	00000ecb 	andeq	r0, r0, fp, asr #29
 118:	0000001c 	andeq	r0, r0, ip, lsl r0
 11c:	000000e8 	andeq	r0, r0, r8, ror #1
 120:	000081a0 	andeq	r8, r0, r0, lsr #3
 124:	00000114 	andeq	r0, r0, r4, lsl r1
 128:	8b040e42 	blhi	103a38 <_bss_end+0xfa7f0>
 12c:	0b0d4201 	bleq	350938 <_bss_end+0x3476f0>
 130:	0d0d8002 	stceq	0, cr8, [sp, #-8]
 134:	000ecb42 	andeq	ip, lr, r2, asr #22
 138:	0000001c 	andeq	r0, r0, ip, lsl r0
 13c:	000000e8 	andeq	r0, r0, r8, ror #1
 140:	000082b4 			; <UNDEFINED> instruction: 0x000082b4
 144:	00000074 	andeq	r0, r0, r4, ror r0
 148:	8b040e42 	blhi	103a58 <_bss_end+0xfa810>
 14c:	0b0d4201 	bleq	350958 <_bss_end+0x347710>
 150:	420d0d72 	andmi	r0, sp, #7296	; 0x1c80
 154:	00000ecb 	andeq	r0, r0, fp, asr #29
 158:	0000001c 	andeq	r0, r0, ip, lsl r0
 15c:	000000e8 	andeq	r0, r0, r8, ror #1
 160:	00008328 	andeq	r8, r0, r8, lsr #6
 164:	00000074 	andeq	r0, r0, r4, ror r0
 168:	8b040e42 	blhi	103a78 <_bss_end+0xfa830>
 16c:	0b0d4201 	bleq	350978 <_bss_end+0x347730>
 170:	420d0d72 	andmi	r0, sp, #7296	; 0x1c80
 174:	00000ecb 	andeq	r0, r0, fp, asr #29
 178:	0000001c 	andeq	r0, r0, ip, lsl r0
 17c:	000000e8 	andeq	r0, r0, r8, ror #1
 180:	0000839c 	muleq	r0, ip, r3
 184:	00000074 	andeq	r0, r0, r4, ror r0
 188:	8b040e42 	blhi	103a98 <_bss_end+0xfa850>
 18c:	0b0d4201 	bleq	350998 <_bss_end+0x347750>
 190:	420d0d72 	andmi	r0, sp, #7296	; 0x1c80
 194:	00000ecb 	andeq	r0, r0, fp, asr #29
 198:	0000001c 	andeq	r0, r0, ip, lsl r0
 19c:	000000e8 	andeq	r0, r0, r8, ror #1
 1a0:	00008410 	andeq	r8, r0, r0, lsl r4
 1a4:	000000a8 	andeq	r0, r0, r8, lsr #1
 1a8:	8b080e42 	blhi	203ab8 <_bss_end+0x1fa870>
 1ac:	42018e02 	andmi	r8, r1, #2, 28
 1b0:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 1b4:	080d0c4e 	stmdaeq	sp, {r1, r2, r3, r6, sl, fp}
 1b8:	0000001c 	andeq	r0, r0, ip, lsl r0
 1bc:	000000e8 	andeq	r0, r0, r8, ror #1
 1c0:	000084b8 			; <UNDEFINED> instruction: 0x000084b8
 1c4:	0000007c 	andeq	r0, r0, ip, ror r0
 1c8:	8b080e42 	blhi	203ad8 <_bss_end+0x1fa890>
 1cc:	42018e02 	andmi	r8, r1, #2, 28
 1d0:	78040b0c 	stmdavc	r4, {r2, r3, r8, r9, fp}
 1d4:	00080d0c 	andeq	r0, r8, ip, lsl #26
 1d8:	0000001c 	andeq	r0, r0, ip, lsl r0
 1dc:	000000e8 	andeq	r0, r0, r8, ror #1
 1e0:	00008534 	andeq	r8, r0, r4, lsr r5
 1e4:	00000084 	andeq	r0, r0, r4, lsl #1
 1e8:	8b080e42 	blhi	203af8 <_bss_end+0x1fa8b0>
 1ec:	42018e02 	andmi	r8, r1, #2, 28
 1f0:	7c040b0c 			; <UNDEFINED> instruction: 0x7c040b0c
 1f4:	00080d0c 	andeq	r0, r8, ip, lsl #26
 1f8:	0000001c 	andeq	r0, r0, ip, lsl r0
 1fc:	000000e8 	andeq	r0, r0, r8, ror #1
 200:	000085b8 			; <UNDEFINED> instruction: 0x000085b8
 204:	0000010c 	andeq	r0, r0, ip, lsl #2
 208:	8b040e42 	blhi	103b18 <_bss_end+0xfa8d0>
 20c:	0b0d4201 	bleq	350a18 <_bss_end+0x3477d0>
 210:	0d0d7e02 	stceq	14, cr7, [sp, #-8]
 214:	000ecb42 	andeq	ip, lr, r2, asr #22
 218:	0000001c 	andeq	r0, r0, ip, lsl r0
 21c:	000000e8 	andeq	r0, r0, r8, ror #1
 220:	000086c4 	andeq	r8, r0, r4, asr #13
 224:	000000b4 	strheq	r0, [r0], -r4
 228:	8b080e42 	blhi	203b38 <_bss_end+0x1fa8f0>
 22c:	42018e02 	andmi	r8, r1, #2, 28
 230:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 234:	080d0c54 	stmdaeq	sp, {r2, r4, r6, sl, fp}
 238:	0000001c 	andeq	r0, r0, ip, lsl r0
 23c:	000000e8 	andeq	r0, r0, r8, ror #1
 240:	00008778 	andeq	r8, r0, r8, ror r7
 244:	000000d8 	ldrdeq	r0, [r0], -r8
 248:	8b080e42 	blhi	203b58 <_bss_end+0x1fa910>
 24c:	42018e02 	andmi	r8, r1, #2, 28
 250:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 254:	080d0c66 	stmdaeq	sp, {r1, r2, r5, r6, sl, fp}
 258:	0000001c 	andeq	r0, r0, ip, lsl r0
 25c:	000000e8 	andeq	r0, r0, r8, ror #1
 260:	00008850 	andeq	r8, r0, r0, asr r8
 264:	00000074 	andeq	r0, r0, r4, ror r0
 268:	8b040e42 	blhi	103b78 <_bss_end+0xfa930>
 26c:	0b0d4201 	bleq	350a78 <_bss_end+0x347830>
 270:	420d0d72 	andmi	r0, sp, #7296	; 0x1c80
 274:	00000ecb 	andeq	r0, r0, fp, asr #29
 278:	0000001c 	andeq	r0, r0, ip, lsl r0
 27c:	000000e8 	andeq	r0, r0, r8, ror #1
 280:	000088c4 	andeq	r8, r0, r4, asr #17
 284:	00000074 	andeq	r0, r0, r4, ror r0
 288:	8b080e42 	blhi	203b98 <_bss_end+0x1fa950>
 28c:	42018e02 	andmi	r8, r1, #2, 28
 290:	74040b0c 	strvc	r0, [r4], #-2828	; 0xfffff4f4
 294:	00080d0c 	andeq	r0, r8, ip, lsl #26
 298:	0000001c 	andeq	r0, r0, ip, lsl r0
 29c:	000000e8 	andeq	r0, r0, r8, ror #1
 2a0:	00008938 	andeq	r8, r0, r8, lsr r9
 2a4:	00000054 	andeq	r0, r0, r4, asr r0
 2a8:	8b080e42 	blhi	203bb8 <_bss_end+0x1fa970>
 2ac:	42018e02 	andmi	r8, r1, #2, 28
 2b0:	5e040b0c 	vmlapl.f64	d0, d4, d12
 2b4:	00080d0c 	andeq	r0, r8, ip, lsl #26
 2b8:	00000018 	andeq	r0, r0, r8, lsl r0
 2bc:	000000e8 	andeq	r0, r0, r8, ror #1
 2c0:	0000898c 	andeq	r8, r0, ip, lsl #19
 2c4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2c8:	8b080e42 	blhi	203bd8 <_bss_end+0x1fa990>
 2cc:	42018e02 	andmi	r8, r1, #2, 28
 2d0:	00040b0c 	andeq	r0, r4, ip, lsl #22
 2d4:	0000000c 	andeq	r0, r0, ip
 2d8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 2dc:	7c020001 	stcvc	0, cr0, [r2], {1}
 2e0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 2e4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2e8:	000002d4 	ldrdeq	r0, [r0], -r4
 2ec:	000089a8 	andeq	r8, r0, r8, lsr #19
 2f0:	00000040 	andeq	r0, r0, r0, asr #32
 2f4:	8b040e42 	blhi	103c04 <_bss_end+0xfa9bc>
 2f8:	0b0d4201 	bleq	350b04 <_bss_end+0x3478bc>
 2fc:	420d0d58 	andmi	r0, sp, #88, 26	; 0x1600
 300:	00000ecb 	andeq	r0, r0, fp, asr #29
 304:	0000001c 	andeq	r0, r0, ip, lsl r0
 308:	000002d4 	ldrdeq	r0, [r0], -r4
 30c:	000089e8 	andeq	r8, r0, r8, ror #19
 310:	00000038 	andeq	r0, r0, r8, lsr r0
 314:	8b040e42 	blhi	103c24 <_bss_end+0xfa9dc>
 318:	0b0d4201 	bleq	350b24 <_bss_end+0x3478dc>
 31c:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
 320:	00000ecb 	andeq	r0, r0, fp, asr #29
 324:	00000020 	andeq	r0, r0, r0, lsr #32
 328:	000002d4 	ldrdeq	r0, [r0], -r4
 32c:	00008a20 	andeq	r8, r0, r0, lsr #20
 330:	000000cc 	andeq	r0, r0, ip, asr #1
 334:	840c0e42 	strhi	r0, [ip], #-3650	; 0xfffff1be
 338:	8e028b03 	vmlahi.f64	d8, d2, d3
 33c:	0b0c4201 	bleq	310b48 <_bss_end+0x307900>
 340:	0c600204 	sfmeq	f0, 2, [r0], #-16
 344:	00000c0d 	andeq	r0, r0, sp, lsl #24
 348:	0000001c 	andeq	r0, r0, ip, lsl r0
 34c:	000002d4 	ldrdeq	r0, [r0], -r4
 350:	00008aec 	andeq	r8, r0, ip, ror #21
 354:	0000004c 	andeq	r0, r0, ip, asr #32
 358:	8b080e42 	blhi	203c68 <_bss_end+0x1faa20>
 35c:	42018e02 	andmi	r8, r1, #2, 28
 360:	60040b0c 	andvs	r0, r4, ip, lsl #22
 364:	00080d0c 	andeq	r0, r8, ip, lsl #26
 368:	0000001c 	andeq	r0, r0, ip, lsl r0
 36c:	000002d4 	ldrdeq	r0, [r0], -r4
 370:	00008b38 	andeq	r8, r0, r8, lsr fp
 374:	00000038 	andeq	r0, r0, r8, lsr r0
 378:	8b080e42 	blhi	203c88 <_bss_end+0x1faa40>
 37c:	42018e02 	andmi	r8, r1, #2, 28
 380:	56040b0c 	strpl	r0, [r4], -ip, lsl #22
 384:	00080d0c 	andeq	r0, r8, ip, lsl #26
 388:	0000001c 	andeq	r0, r0, ip, lsl r0
 38c:	000002d4 	ldrdeq	r0, [r0], -r4
 390:	00008b70 	andeq	r8, r0, r0, ror fp
 394:	00000040 	andeq	r0, r0, r0, asr #32
 398:	8b080e42 	blhi	203ca8 <_bss_end+0x1faa60>
 39c:	42018e02 	andmi	r8, r1, #2, 28
 3a0:	5a040b0c 	bpl	102fd8 <_bss_end+0xf9d90>
 3a4:	00080d0c 	andeq	r0, r8, ip, lsl #26
 3a8:	0000001c 	andeq	r0, r0, ip, lsl r0
 3ac:	000002d4 	ldrdeq	r0, [r0], -r4
 3b0:	00008bb0 			; <UNDEFINED> instruction: 0x00008bb0
 3b4:	00000054 	andeq	r0, r0, r4, asr r0
 3b8:	8b080e42 	blhi	203cc8 <_bss_end+0x1faa80>
 3bc:	42018e02 	andmi	r8, r1, #2, 28
 3c0:	5e040b0c 	vmlapl.f64	d0, d4, d12
 3c4:	00080d0c 	andeq	r0, r8, ip, lsl #26
 3c8:	00000018 	andeq	r0, r0, r8, lsl r0
 3cc:	000002d4 	ldrdeq	r0, [r0], -r4
 3d0:	00008c04 	andeq	r8, r0, r4, lsl #24
 3d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3d8:	8b080e42 	blhi	203ce8 <_bss_end+0x1faaa0>
 3dc:	42018e02 	andmi	r8, r1, #2, 28
 3e0:	00040b0c 	andeq	r0, r4, ip, lsl #22
 3e4:	0000000c 	andeq	r0, r0, ip
 3e8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 3ec:	7c020001 	stcvc	0, cr0, [r2], {1}
 3f0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 3f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3f8:	000003e4 	andeq	r0, r0, r4, ror #7
 3fc:	00008c20 	andeq	r8, r0, r0, lsr #24
 400:	00000018 	andeq	r0, r0, r8, lsl r0
 404:	8b040e42 	blhi	103d14 <_bss_end+0xfaacc>
 408:	0b0d4201 	bleq	350c14 <_bss_end+0x3479cc>
 40c:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
 410:	00000ecb 	andeq	r0, r0, fp, asr #29
 414:	00000028 	andeq	r0, r0, r8, lsr #32
 418:	000003e4 	andeq	r0, r0, r4, ror #7
 41c:	00008c38 	andeq	r8, r0, r8, lsr ip
 420:	00000038 	andeq	r0, r0, r8, lsr r0
 424:	80200e44 	eorhi	r0, r0, r4, asr #28
 428:	82078108 	andhi	r8, r7, #8, 2
 42c:	84058306 	strhi	r8, [r5], #-774	; 0xfffffcfa
 430:	8c038b04 			; <UNDEFINED> instruction: 0x8c038b04
 434:	42018e02 	andmi	r8, r1, #2, 28
 438:	52040b0c 	andpl	r0, r4, #12, 22	; 0x3000
 43c:	00200d0c 	eoreq	r0, r0, ip, lsl #26
 440:	00000014 	andeq	r0, r0, r4, lsl r0
 444:	000003e4 	andeq	r0, r0, r4, ror #7
 448:	00008c70 	andeq	r8, r0, r0, ror ip
 44c:	00000010 	andeq	r0, r0, r0, lsl r0
 450:	040b0c42 	streq	r0, [fp], #-3138	; 0xfffff3be
 454:	000d0c44 	andeq	r0, sp, r4, asr #24
 458:	0000001c 	andeq	r0, r0, ip, lsl r0
 45c:	000003e4 	andeq	r0, r0, r4, ror #7
 460:	00008c80 	andeq	r8, r0, r0, lsl #25
 464:	00000034 	andeq	r0, r0, r4, lsr r0
 468:	8b040e42 	blhi	103d78 <_bss_end+0xfab30>
 46c:	0b0d4201 	bleq	350c78 <_bss_end+0x347a30>
 470:	420d0d52 	andmi	r0, sp, #5248	; 0x1480
 474:	00000ecb 	andeq	r0, r0, fp, asr #29
 478:	0000001c 	andeq	r0, r0, ip, lsl r0
 47c:	000003e4 	andeq	r0, r0, r4, ror #7
 480:	00008cb4 			; <UNDEFINED> instruction: 0x00008cb4
 484:	00000038 	andeq	r0, r0, r8, lsr r0
 488:	8b040e42 	blhi	103d98 <_bss_end+0xfab50>
 48c:	0b0d4201 	bleq	350c98 <_bss_end+0x347a50>
 490:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
 494:	00000ecb 	andeq	r0, r0, fp, asr #29
 498:	00000020 	andeq	r0, r0, r0, lsr #32
 49c:	000003e4 	andeq	r0, r0, r4, ror #7
 4a0:	00008cec 	andeq	r8, r0, ip, ror #25
 4a4:	00000044 	andeq	r0, r0, r4, asr #32
 4a8:	840c0e42 	strhi	r0, [ip], #-3650	; 0xfffff1be
 4ac:	8e028b03 	vmlahi.f64	d8, d2, d3
 4b0:	0b0c4201 	bleq	310cbc <_bss_end+0x307a74>
 4b4:	0d0c5c04 	stceq	12, cr5, [ip, #-16]
 4b8:	0000000c 	andeq	r0, r0, ip
 4bc:	00000020 	andeq	r0, r0, r0, lsr #32
 4c0:	000003e4 	andeq	r0, r0, r4, ror #7
 4c4:	00008d30 	andeq	r8, r0, r0, lsr sp
 4c8:	00000044 	andeq	r0, r0, r4, asr #32
 4cc:	840c0e42 	strhi	r0, [ip], #-3650	; 0xfffff1be
 4d0:	8e028b03 	vmlahi.f64	d8, d2, d3
 4d4:	0b0c4201 	bleq	310ce0 <_bss_end+0x307a98>
 4d8:	0d0c5c04 	stceq	12, cr5, [ip, #-16]
 4dc:	0000000c 	andeq	r0, r0, ip
 4e0:	00000020 	andeq	r0, r0, r0, lsr #32
 4e4:	000003e4 	andeq	r0, r0, r4, ror #7
 4e8:	00008d74 	andeq	r8, r0, r4, ror sp
 4ec:	00000068 	andeq	r0, r0, r8, rrx
 4f0:	840c0e42 	strhi	r0, [ip], #-3650	; 0xfffff1be
 4f4:	8e028b03 	vmlahi.f64	d8, d2, d3
 4f8:	0b0c4201 	bleq	310d04 <_bss_end+0x307abc>
 4fc:	0d0c6e04 	stceq	14, cr6, [ip, #-16]
 500:	0000000c 	andeq	r0, r0, ip
 504:	00000020 	andeq	r0, r0, r0, lsr #32
 508:	000003e4 	andeq	r0, r0, r4, ror #7
 50c:	00008ddc 	ldrdeq	r8, [r0], -ip
 510:	00000068 	andeq	r0, r0, r8, rrx
 514:	840c0e42 	strhi	r0, [ip], #-3650	; 0xfffff1be
 518:	8e028b03 	vmlahi.f64	d8, d2, d3
 51c:	0b0c4201 	bleq	310d28 <_bss_end+0x307ae0>
 520:	0d0c6e04 	stceq	14, cr6, [ip, #-16]
 524:	0000000c 	andeq	r0, r0, ip
 528:	0000001c 	andeq	r0, r0, ip, lsl r0
 52c:	000003e4 	andeq	r0, r0, r4, ror #7
 530:	00008e44 	andeq	r8, r0, r4, asr #28
 534:	00000054 	andeq	r0, r0, r4, asr r0
 538:	8b080e42 	blhi	203e48 <_bss_end+0x1fac00>
 53c:	42018e02 	andmi	r8, r1, #2, 28
 540:	5e040b0c 	vmlapl.f64	d0, d4, d12
 544:	00080d0c 	andeq	r0, r8, ip, lsl #26
 548:	00000018 	andeq	r0, r0, r8, lsl r0
 54c:	000003e4 	andeq	r0, r0, r4, ror #7
 550:	00008e98 	muleq	r0, r8, lr
 554:	0000001c 	andeq	r0, r0, ip, lsl r0
 558:	8b080e42 	blhi	203e68 <_bss_end+0x1fac20>
 55c:	42018e02 	andmi	r8, r1, #2, 28
 560:	00040b0c 	andeq	r0, r4, ip, lsl #22
 564:	0000000c 	andeq	r0, r0, ip
 568:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 56c:	7c020001 	stcvc	0, cr0, [r2], {1}
 570:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 574:	00000018 	andeq	r0, r0, r8, lsl r0
 578:	00000564 	andeq	r0, r0, r4, ror #10
 57c:	00008eb4 			; <UNDEFINED> instruction: 0x00008eb4
 580:	00000074 	andeq	r0, r0, r4, ror r0
 584:	8b080e42 	blhi	203e94 <_bss_end+0x1fac4c>
 588:	42018e02 	andmi	r8, r1, #2, 28
 58c:	00040b0c 	andeq	r0, r4, ip, lsl #22
 590:	00000018 	andeq	r0, r0, r8, lsl r0
 594:	00000564 	andeq	r0, r0, r4, ror #10
 598:	00008f28 	andeq	r8, r0, r8, lsr #30
 59c:	000000a8 	andeq	r0, r0, r8, lsr #1
 5a0:	8b080e42 	blhi	203eb0 <_bss_end+0x1fac68>
 5a4:	42018e02 	andmi	r8, r1, #2, 28
 5a8:	00040b0c 	andeq	r0, r4, ip, lsl #22
 5ac:	0000000c 	andeq	r0, r0, ip
 5b0:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 5b4:	7c020001 	stcvc	0, cr0, [r2], {1}
 5b8:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 5bc:	0000001c 	andeq	r0, r0, ip, lsl r0
 5c0:	000005ac 	andeq	r0, r0, ip, lsr #11
 5c4:	00008ff0 	strdeq	r8, [r0], -r0
 5c8:	00000068 	andeq	r0, r0, r8, rrx
 5cc:	8b040e42 	blhi	103edc <_bss_end+0xfac94>
 5d0:	0b0d4201 	bleq	350ddc <_bss_end+0x347b94>
 5d4:	420d0d68 	andmi	r0, sp, #104, 26	; 0x1a00
 5d8:	00000ecb 	andeq	r0, r0, fp, asr #29
 5dc:	0000001c 	andeq	r0, r0, ip, lsl r0
 5e0:	000005ac 	andeq	r0, r0, ip, lsr #11
 5e4:	00009058 	andeq	r9, r0, r8, asr r0
 5e8:	00000058 	andeq	r0, r0, r8, asr r0
 5ec:	8b080e42 	blhi	203efc <_bss_end+0x1facb4>
 5f0:	42018e02 	andmi	r8, r1, #2, 28
 5f4:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 5f8:	00080d0c 	andeq	r0, r8, ip, lsl #26
 5fc:	0000001c 	andeq	r0, r0, ip, lsl r0
 600:	000005ac 	andeq	r0, r0, ip, lsr #11
 604:	000090b0 	strheq	r9, [r0], -r0
 608:	00000058 	andeq	r0, r0, r8, asr r0
 60c:	8b080e42 	blhi	203f1c <_bss_end+0x1facd4>
 610:	42018e02 	andmi	r8, r1, #2, 28
 614:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 618:	00080d0c 	andeq	r0, r8, ip, lsl #26

Disassembly of section .debug_ranges:

00000000 <.debug_ranges>:
   0:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
   4:	00000000 	andeq	r0, r0, r0
   8:	00008000 	andeq	r8, r0, r0
   c:	00008094 	muleq	r0, r4, r0
  10:	00008fd0 	ldrdeq	r8, [r0], -r0
  14:	00008ff0 	strdeq	r8, [r0], -r0
	...
