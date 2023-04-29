
./kernel:     file format elf32-littlearm


Disassembly of section .text:

00008000 <_start>:
_start():
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/start.s:14
	;@	- sem skoci bootloader, prvni na co narazi je "ldr pc, _reset_ptr" -> tedy se chova jako kdyby slo o reset a skoci na zacatek provadeni
	;@	- v cele svoji krase (vsechny "ldr" instrukce) slouzi jako predloha skutecne tabulce vektoru preruseni
	;@ na dany offset procesor skoci, kdyz je vyvolano libovolne preruseni
	;@ ARM nastavuje rovnou registr PC na tuto adresu, tzn. na teto adrese musi byt kodovana 4B instrukce skoku nekam jinam
	;@ oproti tomu napr. x86 (x86_64) obsahuje v tabulce rovnou adresu a procesor nastavuje PC (CS:IP) na adresu kterou najde v tabulce
	ldr pc, _reset_ptr						;@ 0x00 - reset - vyvolano pri resetu procesoru
    8000:	e59ff018 	ldr	pc, [pc, #24]	; 8020 <_reset_ptr>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/start.s:15
	ldr pc, _undefined_instruction_ptr		;@ 0x04 - undefined instruction - vyjimka, vyvolana pri dekodovani nezname instrukce
    8004:	e59ff018 	ldr	pc, [pc, #24]	; 8024 <_undefined_instruction_ptr>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/start.s:16
	ldr pc, _software_interrupt_ptr			;@ 0x08 - software interrupt - vyvolano, kdyz procesor provede instrukci swi
    8008:	e59ff018 	ldr	pc, [pc, #24]	; 8028 <_software_interrupt_ptr>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/start.s:17
	ldr pc, _prefetch_abort_ptr				;@ 0x0C - prefetch abort - vyvolano, kdyz se procesor snazi napr. nacist instrukci z mista, odkud nacist nejde
    800c:	e59ff018 	ldr	pc, [pc, #24]	; 802c <_prefetch_abort_ptr>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/start.s:18
	ldr pc, _data_abort_ptr					;@ 0x10 - data abort - vyvolano, kdyz se procesor snazi napr. nacist data z mista, odkud nacist nejdou
    8010:	e59ff018 	ldr	pc, [pc, #24]	; 8030 <_data_abort_ptr>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/start.s:19
	ldr pc, _unused_handler_ptr				;@ 0x14 - unused - ve specifikaci ARM neni uvedeno zadne vyuziti
    8014:	e59ff018 	ldr	pc, [pc, #24]	; 8034 <_unused_handler_ptr>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/start.s:20
	ldr pc, _irq_ptr						;@ 0x18 - IRQ - hardwarove preruseni (general purpose)
    8018:	e59ff018 	ldr	pc, [pc, #24]	; 8038 <_irq_ptr>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/start.s:21
	ldr pc, _fast_interrupt_ptr				;@ 0x1C - fast interrupt request - prioritni IRQ pro vysokorychlostni zalezitosti
    801c:	e59ff018 	ldr	pc, [pc, #24]	; 803c <_fast_interrupt_ptr>

00008020 <_reset_ptr>:
_reset_ptr():
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/start.s:21
    8020:	00008040 	andeq	r8, r0, r0, asr #32

00008024 <_undefined_instruction_ptr>:
_undefined_instruction_ptr():
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/start.s:21
    8024:	00009044 	andeq	r9, r0, r4, asr #32

00008028 <_software_interrupt_ptr>:
_software_interrupt_ptr():
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/start.s:21
    8028:	00008c38 	andeq	r8, r0, r8, lsr ip

0000802c <_prefetch_abort_ptr>:
_prefetch_abort_ptr():
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/start.s:21
    802c:	00009048 	andeq	r9, r0, r8, asr #32

00008030 <_data_abort_ptr>:
_data_abort_ptr():
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/start.s:21
    8030:	0000904c 	andeq	r9, r0, ip, asr #32

00008034 <_unused_handler_ptr>:
_unused_handler_ptr():
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/start.s:21
    8034:	00008040 	andeq	r8, r0, r0, asr #32

00008038 <_irq_ptr>:
_irq_ptr():
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/start.s:21
    8038:	00008c50 	andeq	r8, r0, r0, asr ip

0000803c <_fast_interrupt_ptr>:
_fast_interrupt_ptr():
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/start.s:21
    803c:	00008cd0 	ldrdeq	r8, [r0], -r0

00008040 <_reset>:
_reset():
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/start.s:50
.equ    CPSR_FIQ_INHIBIT,       0x40


;@ kernel reset vektor - tento kod se vykona pri kazdem resetu zarizeni (i prvnim spusteni)
_reset:
	mov sp, #0x8000			;@ nastavime stack pointer na spodek zasobniku
    8040:	e3a0d902 	mov	sp, #32768	; 0x8000
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/start.s:53

	;@ nacteni tabulky vektoru preruseni do pameti
	mov r0, #0x8000			;@ adresa 0x8000 (_start) do r0
    8044:	e3a00902 	mov	r0, #32768	; 0x8000
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/start.s:54
    mov r1, #0x0000			;@ adresa 0x0000 (pocatek RAM) do r1 - tam budeme vkladat tabulku vektoru preruseni
    8048:	e3a01000 	mov	r1, #0
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/start.s:58

	;@ Thumb instrukce - nacteni 4B slov z pameti ulozene v r0 (0x8000) do registru r2, 3, ... 9
	;@                 - ulozeni obsahu registru r2, 3, ... 9 do pameti ulozene v registru r1 (0x0000)
    ldmia r0!,{r2, r3, r4, r5, r6, r7, r8, r9}
    804c:	e8b003fc 	ldm	r0!, {r2, r3, r4, r5, r6, r7, r8, r9}
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/start.s:59
    stmia r1!,{r2, r3, r4, r5, r6, r7, r8, r9}
    8050:	e8a103fc 	stmia	r1!, {r2, r3, r4, r5, r6, r7, r8, r9}
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/start.s:60
    ldmia r0!,{r2, r3, r4, r5, r6, r7, r8, r9}
    8054:	e8b003fc 	ldm	r0!, {r2, r3, r4, r5, r6, r7, r8, r9}
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/start.s:61
    stmia r1!,{r2, r3, r4, r5, r6, r7, r8, r9}
    8058:	e8a103fc 	stmia	r1!, {r2, r3, r4, r5, r6, r7, r8, r9}
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/start.s:64

	;@ na moment se prepneme do IRQ rezimu, nastavime mu stack pointer
	mov r0, #(CPSR_MODE_IRQ | CPSR_IRQ_INHIBIT | CPSR_FIQ_INHIBIT)
    805c:	e3a000d2 	mov	r0, #210	; 0xd2
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/start.s:65
    msr cpsr_c, r0
    8060:	e121f000 	msr	CPSR_c, r0
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/start.s:66
    mov sp, #0x7000
    8064:	e3a0da07 	mov	sp, #28672	; 0x7000
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/start.s:69

	;@ na moment se prepneme do FIQ rezimu, nastavime mu stack pointer
	mov r0, #(CPSR_MODE_FIQ | CPSR_IRQ_INHIBIT | CPSR_FIQ_INHIBIT)
    8068:	e3a000d1 	mov	r0, #209	; 0xd1
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/start.s:70
    msr cpsr_c, r0
    806c:	e121f000 	msr	CPSR_c, r0
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/start.s:71
    mov sp, #0x6000
    8070:	e3a0da06 	mov	sp, #24576	; 0x6000
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/start.s:74

	;@ a vracime se zpet do supervisor modu, SP si nastavime zpet na nasi hodnotu
    mov r0, #(CPSR_MODE_SVR | CPSR_IRQ_INHIBIT | CPSR_FIQ_INHIBIT)
    8074:	e3a000d3 	mov	r0, #211	; 0xd3
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/start.s:75
    msr cpsr_c, r0
    8078:	e121f000 	msr	CPSR_c, r0
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/start.s:76
    mov sp, #0x8000
    807c:	e3a0d902 	mov	sp, #32768	; 0x8000
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/start.s:78

	bl _c_startup			;@ C startup kod (inicializace prostredi)
    8080:	eb0003f2 	bl	9050 <_c_startup>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/start.s:79
	bl _cpp_startup			;@ C++ startup kod (volani globalnich konstruktoru, ...)
    8084:	eb00040b 	bl	90b8 <_cpp_startup>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/start.s:80
	bl _kernel_main			;@ skocime do hlavniho kodu jadra (v C)
    8088:	eb0003be 	bl	8f88 <_kernel_main>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/start.s:81
	bl _cpp_shutdown		;@ C++ shutdown kod (volani globalnich destruktoru, ...)
    808c:	eb00041f 	bl	9110 <_cpp_shutdown>

00008090 <hang>:
hang():
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/start.s:83
hang:
	b hang
    8090:	eafffffe 	b	8090 <hang>

00008094 <__cxa_guard_acquire>:
__cxa_guard_acquire():
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/cxx.cpp:11
    extern "C" int __cxa_guard_acquire(__guard*);
    extern "C" void __cxa_guard_release(__guard*);
    extern "C" void __cxa_guard_abort(__guard*);

    extern "C" int __cxa_guard_acquire(__guard* g)
    {
    8094:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8098:	e28db000 	add	fp, sp, #0
    809c:	e24dd00c 	sub	sp, sp, #12
    80a0:	e50b0008 	str	r0, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/cxx.cpp:12
        return !*(char*)(g);
    80a4:	e51b3008 	ldr	r3, [fp, #-8]
    80a8:	e5d33000 	ldrb	r3, [r3]
    80ac:	e3530000 	cmp	r3, #0
    80b0:	03a03001 	moveq	r3, #1
    80b4:	13a03000 	movne	r3, #0
    80b8:	e6ef3073 	uxtb	r3, r3
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/cxx.cpp:13
    }
    80bc:	e1a00003 	mov	r0, r3
    80c0:	e28bd000 	add	sp, fp, #0
    80c4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    80c8:	e12fff1e 	bx	lr

000080cc <__cxa_guard_release>:
__cxa_guard_release():
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/cxx.cpp:16

    extern "C" void __cxa_guard_release(__guard* g)
    {
    80cc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    80d0:	e28db000 	add	fp, sp, #0
    80d4:	e24dd00c 	sub	sp, sp, #12
    80d8:	e50b0008 	str	r0, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/cxx.cpp:17
        *(char*)g = 1;
    80dc:	e51b3008 	ldr	r3, [fp, #-8]
    80e0:	e3a02001 	mov	r2, #1
    80e4:	e5c32000 	strb	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/cxx.cpp:18
    }
    80e8:	e320f000 	nop	{0}
    80ec:	e28bd000 	add	sp, fp, #0
    80f0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    80f4:	e12fff1e 	bx	lr

000080f8 <__cxa_guard_abort>:
__cxa_guard_abort():
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/cxx.cpp:21

    extern "C" void __cxa_guard_abort(__guard*)
    {
    80f8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    80fc:	e28db000 	add	fp, sp, #0
    8100:	e24dd00c 	sub	sp, sp, #12
    8104:	e50b0008 	str	r0, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/cxx.cpp:22
    }
    8108:	e320f000 	nop	{0}
    810c:	e28bd000 	add	sp, fp, #0
    8110:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8114:	e12fff1e 	bx	lr

00008118 <__dso_handle>:
__dso_handle():
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/cxx.cpp:26
}

extern "C" void __dso_handle()
{
    8118:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    811c:	e28db000 	add	fp, sp, #0
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/cxx.cpp:28
    // ignore dtors for now
}
    8120:	e320f000 	nop	{0}
    8124:	e28bd000 	add	sp, fp, #0
    8128:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    812c:	e12fff1e 	bx	lr

00008130 <__cxa_atexit>:
__cxa_atexit():
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/cxx.cpp:31

extern "C" void __cxa_atexit()
{
    8130:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8134:	e28db000 	add	fp, sp, #0
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/cxx.cpp:33
    // ignore dtors for now
}
    8138:	e320f000 	nop	{0}
    813c:	e28bd000 	add	sp, fp, #0
    8140:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8144:	e12fff1e 	bx	lr

00008148 <__cxa_pure_virtual>:
__cxa_pure_virtual():
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/cxx.cpp:36

extern "C" void __cxa_pure_virtual()
{
    8148:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    814c:	e28db000 	add	fp, sp, #0
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/cxx.cpp:38
    // pure virtual method called
}
    8150:	e320f000 	nop	{0}
    8154:	e28bd000 	add	sp, fp, #0
    8158:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    815c:	e12fff1e 	bx	lr

00008160 <__aeabi_unwind_cpp_pr1>:
__aeabi_unwind_cpp_pr1():
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/cxx.cpp:41

extern "C" void __aeabi_unwind_cpp_pr1()
{
    8160:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8164:	e28db000 	add	fp, sp, #0
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/cxx.cpp:42 (discriminator 1)
    while (true)
    8168:	eafffffe 	b	8168 <__aeabi_unwind_cpp_pr1+0x8>

0000816c <_ZN13CGPIO_HandlerC1Ej>:
_ZN13CGPIO_HandlerC2Ej():
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:6
#include <hal/peripherals.h>
#include <drivers/gpio.h>

CGPIO_Handler sGPIO(hal::GPIO_Base);

CGPIO_Handler::CGPIO_Handler(unsigned int gpio_base_addr)
    816c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8170:	e28db000 	add	fp, sp, #0
    8174:	e24dd00c 	sub	sp, sp, #12
    8178:	e50b0008 	str	r0, [fp, #-8]
    817c:	e50b100c 	str	r1, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:7
: mGPIO(reinterpret_cast<unsigned int*>(gpio_base_addr))
    8180:	e51b200c 	ldr	r2, [fp, #-12]
    8184:	e51b3008 	ldr	r3, [fp, #-8]
    8188:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:10
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
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:13

bool CGPIO_Handler::Get_GPFSEL_Location(uint32_t pin, uint32_t& reg, uint32_t& bit_idx) const
{
    81a0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    81a4:	e28db000 	add	fp, sp, #0
    81a8:	e24dd014 	sub	sp, sp, #20
    81ac:	e50b0008 	str	r0, [fp, #-8]
    81b0:	e50b100c 	str	r1, [fp, #-12]
    81b4:	e50b2010 	str	r2, [fp, #-16]
    81b8:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:14
    if (pin > hal::GPIO_Pin_Count)
    81bc:	e51b300c 	ldr	r3, [fp, #-12]
    81c0:	e3530036 	cmp	r3, #54	; 0x36
    81c4:	9a000001 	bls	81d0 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0x30>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:15
        return false;
    81c8:	e3a03000 	mov	r3, #0
    81cc:	ea000033 	b	82a0 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0x100>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:17

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
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:20
    {
        case 0:
            reg = static_cast<uint32_t>(hal::GPIO_Reg::GPFSEL0);
    8204:	e51b3010 	ldr	r3, [fp, #-16]
    8208:	e3a02000 	mov	r2, #0
    820c:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:21
            break;
    8210:	ea000013 	b	8264 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0xc4>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:23
        case 1:
            reg = static_cast<uint32_t>(hal::GPIO_Reg::GPFSEL1);
    8214:	e51b3010 	ldr	r3, [fp, #-16]
    8218:	e3a02001 	mov	r2, #1
    821c:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:24
            break;
    8220:	ea00000f 	b	8264 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0xc4>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:26
        case 2:
            reg = static_cast<uint32_t>(hal::GPIO_Reg::GPFSEL2);
    8224:	e51b3010 	ldr	r3, [fp, #-16]
    8228:	e3a02002 	mov	r2, #2
    822c:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:27
            break;
    8230:	ea00000b 	b	8264 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0xc4>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:29
        case 3:
            reg = static_cast<uint32_t>(hal::GPIO_Reg::GPFSEL3);
    8234:	e51b3010 	ldr	r3, [fp, #-16]
    8238:	e3a02003 	mov	r2, #3
    823c:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:30
            break;
    8240:	ea000007 	b	8264 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0xc4>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:32
        case 4:
            reg = static_cast<uint32_t>(hal::GPIO_Reg::GPFSEL4);
    8244:	e51b3010 	ldr	r3, [fp, #-16]
    8248:	e3a02004 	mov	r2, #4
    824c:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:33
            break;
    8250:	ea000003 	b	8264 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0xc4>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:35
        case 5:
            reg = static_cast<uint32_t>(hal::GPIO_Reg::GPFSEL5);
    8254:	e51b3010 	ldr	r3, [fp, #-16]
    8258:	e3a02005 	mov	r2, #5
    825c:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:36
            break;
    8260:	e320f000 	nop	{0}
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:39
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
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:41

    return true;
    829c:	e3a03001 	mov	r3, #1
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:42
}
    82a0:	e1a00003 	mov	r0, r3
    82a4:	e28bd000 	add	sp, fp, #0
    82a8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    82ac:	e12fff1e 	bx	lr
    82b0:	cccccccd 	stclgt	12, cr12, [ip], {205}	; 0xcd

000082b4 <_ZNK13CGPIO_Handler18Get_GPCLR_LocationEjRjS0_>:
_ZNK13CGPIO_Handler18Get_GPCLR_LocationEjRjS0_():
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:45

bool CGPIO_Handler::Get_GPCLR_Location(uint32_t pin, uint32_t& reg, uint32_t& bit_idx) const
{
    82b4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    82b8:	e28db000 	add	fp, sp, #0
    82bc:	e24dd014 	sub	sp, sp, #20
    82c0:	e50b0008 	str	r0, [fp, #-8]
    82c4:	e50b100c 	str	r1, [fp, #-12]
    82c8:	e50b2010 	str	r2, [fp, #-16]
    82cc:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:46
    if (pin > hal::GPIO_Pin_Count)
    82d0:	e51b300c 	ldr	r3, [fp, #-12]
    82d4:	e3530036 	cmp	r3, #54	; 0x36
    82d8:	9a000001 	bls	82e4 <_ZNK13CGPIO_Handler18Get_GPCLR_LocationEjRjS0_+0x30>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:47
        return false;
    82dc:	e3a03000 	mov	r3, #0
    82e0:	ea00000c 	b	8318 <_ZNK13CGPIO_Handler18Get_GPCLR_LocationEjRjS0_+0x64>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:49

    reg = static_cast<uint32_t>((pin < 32) ? hal::GPIO_Reg::GPCLR0 : hal::GPIO_Reg::GPCLR1);
    82e4:	e51b300c 	ldr	r3, [fp, #-12]
    82e8:	e353001f 	cmp	r3, #31
    82ec:	8a000001 	bhi	82f8 <_ZNK13CGPIO_Handler18Get_GPCLR_LocationEjRjS0_+0x44>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:49 (discriminator 1)
    82f0:	e3a0200a 	mov	r2, #10
    82f4:	ea000000 	b	82fc <_ZNK13CGPIO_Handler18Get_GPCLR_LocationEjRjS0_+0x48>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:49 (discriminator 2)
    82f8:	e3a0200b 	mov	r2, #11
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:49 (discriminator 4)
    82fc:	e51b3010 	ldr	r3, [fp, #-16]
    8300:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:50 (discriminator 4)
    bit_idx = pin % 32;
    8304:	e51b300c 	ldr	r3, [fp, #-12]
    8308:	e203201f 	and	r2, r3, #31
    830c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8310:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:52 (discriminator 4)

    return true;
    8314:	e3a03001 	mov	r3, #1
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:53
}
    8318:	e1a00003 	mov	r0, r3
    831c:	e28bd000 	add	sp, fp, #0
    8320:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8324:	e12fff1e 	bx	lr

00008328 <_ZNK13CGPIO_Handler18Get_GPSET_LocationEjRjS0_>:
_ZNK13CGPIO_Handler18Get_GPSET_LocationEjRjS0_():
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:56

bool CGPIO_Handler::Get_GPSET_Location(uint32_t pin, uint32_t& reg, uint32_t& bit_idx) const
{
    8328:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    832c:	e28db000 	add	fp, sp, #0
    8330:	e24dd014 	sub	sp, sp, #20
    8334:	e50b0008 	str	r0, [fp, #-8]
    8338:	e50b100c 	str	r1, [fp, #-12]
    833c:	e50b2010 	str	r2, [fp, #-16]
    8340:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:57
    if (pin > hal::GPIO_Pin_Count)
    8344:	e51b300c 	ldr	r3, [fp, #-12]
    8348:	e3530036 	cmp	r3, #54	; 0x36
    834c:	9a000001 	bls	8358 <_ZNK13CGPIO_Handler18Get_GPSET_LocationEjRjS0_+0x30>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:58
        return false;
    8350:	e3a03000 	mov	r3, #0
    8354:	ea00000c 	b	838c <_ZNK13CGPIO_Handler18Get_GPSET_LocationEjRjS0_+0x64>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:60

    reg = static_cast<uint32_t>((pin < 32) ? hal::GPIO_Reg::GPSET0 : hal::GPIO_Reg::GPSET1);
    8358:	e51b300c 	ldr	r3, [fp, #-12]
    835c:	e353001f 	cmp	r3, #31
    8360:	8a000001 	bhi	836c <_ZNK13CGPIO_Handler18Get_GPSET_LocationEjRjS0_+0x44>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:60 (discriminator 1)
    8364:	e3a02007 	mov	r2, #7
    8368:	ea000000 	b	8370 <_ZNK13CGPIO_Handler18Get_GPSET_LocationEjRjS0_+0x48>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:60 (discriminator 2)
    836c:	e3a02008 	mov	r2, #8
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:60 (discriminator 4)
    8370:	e51b3010 	ldr	r3, [fp, #-16]
    8374:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:61 (discriminator 4)
    bit_idx = pin % 32;
    8378:	e51b300c 	ldr	r3, [fp, #-12]
    837c:	e203201f 	and	r2, r3, #31
    8380:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8384:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:63 (discriminator 4)

    return true;
    8388:	e3a03001 	mov	r3, #1
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:64
}
    838c:	e1a00003 	mov	r0, r3
    8390:	e28bd000 	add	sp, fp, #0
    8394:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8398:	e12fff1e 	bx	lr

0000839c <_ZNK13CGPIO_Handler18Get_GPLEV_LocationEjRjS0_>:
_ZNK13CGPIO_Handler18Get_GPLEV_LocationEjRjS0_():
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:67

bool CGPIO_Handler::Get_GPLEV_Location(uint32_t pin, uint32_t& reg, uint32_t& bit_idx) const
{
    839c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    83a0:	e28db000 	add	fp, sp, #0
    83a4:	e24dd014 	sub	sp, sp, #20
    83a8:	e50b0008 	str	r0, [fp, #-8]
    83ac:	e50b100c 	str	r1, [fp, #-12]
    83b0:	e50b2010 	str	r2, [fp, #-16]
    83b4:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:68
    if (pin > hal::GPIO_Pin_Count)
    83b8:	e51b300c 	ldr	r3, [fp, #-12]
    83bc:	e3530036 	cmp	r3, #54	; 0x36
    83c0:	9a000001 	bls	83cc <_ZNK13CGPIO_Handler18Get_GPLEV_LocationEjRjS0_+0x30>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:69
        return false;
    83c4:	e3a03000 	mov	r3, #0
    83c8:	ea00000c 	b	8400 <_ZNK13CGPIO_Handler18Get_GPLEV_LocationEjRjS0_+0x64>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:71

    reg = static_cast<uint32_t>((pin < 32) ? hal::GPIO_Reg::GPLEV0 : hal::GPIO_Reg::GPLEV1);
    83cc:	e51b300c 	ldr	r3, [fp, #-12]
    83d0:	e353001f 	cmp	r3, #31
    83d4:	8a000001 	bhi	83e0 <_ZNK13CGPIO_Handler18Get_GPLEV_LocationEjRjS0_+0x44>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:71 (discriminator 1)
    83d8:	e3a0200d 	mov	r2, #13
    83dc:	ea000000 	b	83e4 <_ZNK13CGPIO_Handler18Get_GPLEV_LocationEjRjS0_+0x48>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:71 (discriminator 2)
    83e0:	e3a0200e 	mov	r2, #14
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:71 (discriminator 4)
    83e4:	e51b3010 	ldr	r3, [fp, #-16]
    83e8:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:72 (discriminator 4)
    bit_idx = pin % 32;
    83ec:	e51b300c 	ldr	r3, [fp, #-12]
    83f0:	e203201f 	and	r2, r3, #31
    83f4:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    83f8:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:74 (discriminator 4)

    return true;
    83fc:	e3a03001 	mov	r3, #1
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:75
}
    8400:	e1a00003 	mov	r0, r3
    8404:	e28bd000 	add	sp, fp, #0
    8408:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    840c:	e12fff1e 	bx	lr

00008410 <_ZN13CGPIO_Handler17Set_GPIO_FunctionEj14NGPIO_Function>:
_ZN13CGPIO_Handler17Set_GPIO_FunctionEj14NGPIO_Function():
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:78

void CGPIO_Handler::Set_GPIO_Function(uint32_t pin, NGPIO_Function func)
{
    8410:	e92d4800 	push	{fp, lr}
    8414:	e28db004 	add	fp, sp, #4
    8418:	e24dd018 	sub	sp, sp, #24
    841c:	e50b0010 	str	r0, [fp, #-16]
    8420:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8424:	e1a03002 	mov	r3, r2
    8428:	e54b3015 	strb	r3, [fp, #-21]	; 0xffffffeb
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:80
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
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:83
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
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:81
        return;
    84ac:	e320f000 	nop	{0}
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:84
}
    84b0:	e24bd004 	sub	sp, fp, #4
    84b4:	e8bd8800 	pop	{fp, pc}

000084b8 <_ZNK13CGPIO_Handler17Get_GPIO_FunctionEj>:
_ZNK13CGPIO_Handler17Get_GPIO_FunctionEj():
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:87

NGPIO_Function CGPIO_Handler::Get_GPIO_Function(uint32_t pin) const
{
    84b8:	e92d4800 	push	{fp, lr}
    84bc:	e28db004 	add	fp, sp, #4
    84c0:	e24dd010 	sub	sp, sp, #16
    84c4:	e50b0010 	str	r0, [fp, #-16]
    84c8:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:89
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
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:90
        return NGPIO_Function::Unspecified;
    84f4:	e3a03008 	mov	r3, #8
    84f8:	ea00000a 	b	8528 <_ZNK13CGPIO_Handler17Get_GPIO_FunctionEj+0x70>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:92

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
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:93 (discriminator 1)
}
    8528:	e1a00003 	mov	r0, r3
    852c:	e24bd004 	sub	sp, fp, #4
    8530:	e8bd8800 	pop	{fp, pc}

00008534 <_ZN13CGPIO_Handler19Enable_Event_DetectEj20NGPIO_Interrupt_Type>:
_ZN13CGPIO_Handler19Enable_Event_DetectEj20NGPIO_Interrupt_Type():
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:96

void CGPIO_Handler::Enable_Event_Detect(uint32_t pin, NGPIO_Interrupt_Type type)
{
    8534:	e92d4800 	push	{fp, lr}
    8538:	e28db004 	add	fp, sp, #4
    853c:	e24dd020 	sub	sp, sp, #32
    8540:	e50b0010 	str	r0, [fp, #-16]
    8544:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8548:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:98
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
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:101
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
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:99
        return;
    85ac:	e320f000 	nop	{0}
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:108
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
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:111

bool CGPIO_Handler::Get_GP_IRQ_Detect_Location(uint32_t pin, NGPIO_Interrupt_Type type, uint32_t& reg, uint32_t& bit_idx) const
{
    85b8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    85bc:	e28db000 	add	fp, sp, #0
    85c0:	e24dd014 	sub	sp, sp, #20
    85c4:	e50b0008 	str	r0, [fp, #-8]
    85c8:	e50b100c 	str	r1, [fp, #-12]
    85cc:	e50b2010 	str	r2, [fp, #-16]
    85d0:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:112
    if (pin > hal::GPIO_Pin_Count)
    85d4:	e51b300c 	ldr	r3, [fp, #-12]
    85d8:	e3530036 	cmp	r3, #54	; 0x36
    85dc:	9a000001 	bls	85e8 <_ZNK13CGPIO_Handler26Get_GP_IRQ_Detect_LocationEj20NGPIO_Interrupt_TypeRjS1_+0x30>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:113
        return false;
    85e0:	e3a03000 	mov	r3, #0
    85e4:	ea000032 	b	86b4 <_ZNK13CGPIO_Handler26Get_GP_IRQ_Detect_LocationEj20NGPIO_Interrupt_TypeRjS1_+0xfc>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:115

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
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:120

    switch (type)
    {
        case NGPIO_Interrupt_Type::Rising_Edge:
            reg = static_cast<uint32_t>((pin < 32) ? hal::GPIO_Reg::GPREN0 : hal::GPIO_Reg::GPREN1);
    8618:	e51b300c 	ldr	r3, [fp, #-12]
    861c:	e353001f 	cmp	r3, #31
    8620:	8a000001 	bhi	862c <_ZNK13CGPIO_Handler26Get_GP_IRQ_Detect_LocationEj20NGPIO_Interrupt_TypeRjS1_+0x74>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:120 (discriminator 1)
    8624:	e3a02013 	mov	r2, #19
    8628:	ea000000 	b	8630 <_ZNK13CGPIO_Handler26Get_GP_IRQ_Detect_LocationEj20NGPIO_Interrupt_TypeRjS1_+0x78>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:120 (discriminator 2)
    862c:	e3a02014 	mov	r2, #20
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:120 (discriminator 4)
    8630:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8634:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:121 (discriminator 4)
            break;
    8638:	ea00001c 	b	86b0 <_ZNK13CGPIO_Handler26Get_GP_IRQ_Detect_LocationEj20NGPIO_Interrupt_TypeRjS1_+0xf8>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:123
        case NGPIO_Interrupt_Type::Falling_Edge:
            reg = static_cast<uint32_t>((pin < 32) ? hal::GPIO_Reg::GPFEN0 : hal::GPIO_Reg::GPFEN1);
    863c:	e51b300c 	ldr	r3, [fp, #-12]
    8640:	e353001f 	cmp	r3, #31
    8644:	8a000001 	bhi	8650 <_ZNK13CGPIO_Handler26Get_GP_IRQ_Detect_LocationEj20NGPIO_Interrupt_TypeRjS1_+0x98>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:123 (discriminator 1)
    8648:	e3a02016 	mov	r2, #22
    864c:	ea000000 	b	8654 <_ZNK13CGPIO_Handler26Get_GP_IRQ_Detect_LocationEj20NGPIO_Interrupt_TypeRjS1_+0x9c>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:123 (discriminator 2)
    8650:	e3a02017 	mov	r2, #23
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:123 (discriminator 4)
    8654:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8658:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:124 (discriminator 4)
            break;
    865c:	ea000013 	b	86b0 <_ZNK13CGPIO_Handler26Get_GP_IRQ_Detect_LocationEj20NGPIO_Interrupt_TypeRjS1_+0xf8>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:126
        case NGPIO_Interrupt_Type::High:
            reg = static_cast<uint32_t>((pin < 32) ? hal::GPIO_Reg::GPHEN0 : hal::GPIO_Reg::GPHEN1);
    8660:	e51b300c 	ldr	r3, [fp, #-12]
    8664:	e353001f 	cmp	r3, #31
    8668:	8a000001 	bhi	8674 <_ZNK13CGPIO_Handler26Get_GP_IRQ_Detect_LocationEj20NGPIO_Interrupt_TypeRjS1_+0xbc>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:126 (discriminator 1)
    866c:	e3a02019 	mov	r2, #25
    8670:	ea000000 	b	8678 <_ZNK13CGPIO_Handler26Get_GP_IRQ_Detect_LocationEj20NGPIO_Interrupt_TypeRjS1_+0xc0>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:126 (discriminator 2)
    8674:	e3a0201a 	mov	r2, #26
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:126 (discriminator 4)
    8678:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    867c:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:127 (discriminator 4)
            break;
    8680:	ea00000a 	b	86b0 <_ZNK13CGPIO_Handler26Get_GP_IRQ_Detect_LocationEj20NGPIO_Interrupt_TypeRjS1_+0xf8>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:129
        case NGPIO_Interrupt_Type::Low:
            reg = static_cast<uint32_t>((pin < 32) ? hal::GPIO_Reg::GPLEN0 : hal::GPIO_Reg::GPLEN1);
    8684:	e51b300c 	ldr	r3, [fp, #-12]
    8688:	e353001f 	cmp	r3, #31
    868c:	8a000001 	bhi	8698 <_ZNK13CGPIO_Handler26Get_GP_IRQ_Detect_LocationEj20NGPIO_Interrupt_TypeRjS1_+0xe0>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:129 (discriminator 1)
    8690:	e3a0201c 	mov	r2, #28
    8694:	ea000000 	b	869c <_ZNK13CGPIO_Handler26Get_GP_IRQ_Detect_LocationEj20NGPIO_Interrupt_TypeRjS1_+0xe4>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:129 (discriminator 2)
    8698:	e3a0201d 	mov	r2, #29
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:129 (discriminator 4)
    869c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    86a0:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:130 (discriminator 4)
            break;
    86a4:	ea000001 	b	86b0 <_ZNK13CGPIO_Handler26Get_GP_IRQ_Detect_LocationEj20NGPIO_Interrupt_TypeRjS1_+0xf8>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:132
        default:
            return false;
    86a8:	e3a03000 	mov	r3, #0
    86ac:	ea000000 	b	86b4 <_ZNK13CGPIO_Handler26Get_GP_IRQ_Detect_LocationEj20NGPIO_Interrupt_TypeRjS1_+0xfc>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:135
    }

    return true;
    86b0:	e3a03001 	mov	r3, #1
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:136
}
    86b4:	e1a00003 	mov	r0, r3
    86b8:	e28bd000 	add	sp, fp, #0
    86bc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    86c0:	e12fff1e 	bx	lr

000086c4 <_ZN13CGPIO_Handler20Disable_Event_DetectEj20NGPIO_Interrupt_Type>:
_ZN13CGPIO_Handler20Disable_Event_DetectEj20NGPIO_Interrupt_Type():
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:139

void CGPIO_Handler::Disable_Event_Detect(uint32_t pin, NGPIO_Interrupt_Type type)
{
    86c4:	e92d4800 	push	{fp, lr}
    86c8:	e28db004 	add	fp, sp, #4
    86cc:	e24dd028 	sub	sp, sp, #40	; 0x28
    86d0:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    86d4:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    86d8:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:141
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
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:144
        return;

    uint32_t val = mGPIO[reg];
    8710:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8714:	e5932000 	ldr	r2, [r3]
    8718:	e51b300c 	ldr	r3, [fp, #-12]
    871c:	e1a03103 	lsl	r3, r3, #2
    8720:	e0823003 	add	r3, r2, r3
    8724:	e5933000 	ldr	r3, [r3]
    8728:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:145
    val &= ~(1 << bit);
    872c:	e51b3010 	ldr	r3, [fp, #-16]
    8730:	e3a02001 	mov	r2, #1
    8734:	e1a03312 	lsl	r3, r2, r3
    8738:	e1e03003 	mvn	r3, r3
    873c:	e1a02003 	mov	r2, r3
    8740:	e51b3008 	ldr	r3, [fp, #-8]
    8744:	e0033002 	and	r3, r3, r2
    8748:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:146
    mGPIO[reg] = val;
    874c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8750:	e5932000 	ldr	r2, [r3]
    8754:	e51b300c 	ldr	r3, [fp, #-12]
    8758:	e1a03103 	lsl	r3, r3, #2
    875c:	e0823003 	add	r3, r2, r3
    8760:	e51b2008 	ldr	r2, [fp, #-8]
    8764:	e5832000 	str	r2, [r3]
    8768:	ea000000 	b	8770 <_ZN13CGPIO_Handler20Disable_Event_DetectEj20NGPIO_Interrupt_Type+0xac>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:142
        return;
    876c:	e320f000 	nop	{0}
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:147
}
    8770:	e24bd004 	sub	sp, fp, #4
    8774:	e8bd8800 	pop	{fp, pc}

00008778 <_ZN13CGPIO_Handler10Set_OutputEjb>:
_ZN13CGPIO_Handler10Set_OutputEjb():
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:150

void CGPIO_Handler::Set_Output(uint32_t pin, bool set)
{
    8778:	e92d4800 	push	{fp, lr}
    877c:	e28db004 	add	fp, sp, #4
    8780:	e24dd018 	sub	sp, sp, #24
    8784:	e50b0010 	str	r0, [fp, #-16]
    8788:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    878c:	e1a03002 	mov	r3, r2
    8790:	e54b3015 	strb	r3, [fp, #-21]	; 0xffffffeb
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:152
    uint32_t reg, bit;
    if (!(set && Get_GPSET_Location(pin, reg, bit)) && !(!set && Get_GPCLR_Location(pin, reg, bit)))
    8794:	e55b3015 	ldrb	r3, [fp, #-21]	; 0xffffffeb
    8798:	e2233001 	eor	r3, r3, #1
    879c:	e6ef3073 	uxtb	r3, r3
    87a0:	e3530000 	cmp	r3, #0
    87a4:	1a000009 	bne	87d0 <_ZN13CGPIO_Handler10Set_OutputEjb+0x58>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:152 (discriminator 2)
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
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:152 (discriminator 3)
    87d0:	e55b3015 	ldrb	r3, [fp, #-21]	; 0xffffffeb
    87d4:	e3530000 	cmp	r3, #0
    87d8:	1a000009 	bne	8804 <_ZN13CGPIO_Handler10Set_OutputEjb+0x8c>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:152 (discriminator 6)
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
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:152 (discriminator 7)
    8804:	e3a03001 	mov	r3, #1
    8808:	ea000000 	b	8810 <_ZN13CGPIO_Handler10Set_OutputEjb+0x98>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:152 (discriminator 8)
    880c:	e3a03000 	mov	r3, #0
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:152 (discriminator 10)
    8810:	e3530000 	cmp	r3, #0
    8814:	1a00000a 	bne	8844 <_ZN13CGPIO_Handler10Set_OutputEjb+0xcc>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:155
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
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:153
        return;
    8844:	e320f000 	nop	{0}
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:156
}
    8848:	e24bd004 	sub	sp, fp, #4
    884c:	e8bd8800 	pop	{fp, pc}

00008850 <_ZNK13CGPIO_Handler18Get_GPEDS_LocationEjRjS0_>:
_ZNK13CGPIO_Handler18Get_GPEDS_LocationEjRjS0_():
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:159

bool CGPIO_Handler::Get_GPEDS_Location(uint32_t pin, uint32_t& reg, uint32_t& bit_idx) const
{
    8850:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8854:	e28db000 	add	fp, sp, #0
    8858:	e24dd014 	sub	sp, sp, #20
    885c:	e50b0008 	str	r0, [fp, #-8]
    8860:	e50b100c 	str	r1, [fp, #-12]
    8864:	e50b2010 	str	r2, [fp, #-16]
    8868:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:160
    if (pin > hal::GPIO_Pin_Count)
    886c:	e51b300c 	ldr	r3, [fp, #-12]
    8870:	e3530036 	cmp	r3, #54	; 0x36
    8874:	9a000001 	bls	8880 <_ZNK13CGPIO_Handler18Get_GPEDS_LocationEjRjS0_+0x30>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:161
        return false;
    8878:	e3a03000 	mov	r3, #0
    887c:	ea00000c 	b	88b4 <_ZNK13CGPIO_Handler18Get_GPEDS_LocationEjRjS0_+0x64>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:163

    reg = static_cast<uint32_t>((pin < 32) ? hal::GPIO_Reg::GPEDS0 : hal::GPIO_Reg::GPEDS1);
    8880:	e51b300c 	ldr	r3, [fp, #-12]
    8884:	e353001f 	cmp	r3, #31
    8888:	8a000001 	bhi	8894 <_ZNK13CGPIO_Handler18Get_GPEDS_LocationEjRjS0_+0x44>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:163 (discriminator 1)
    888c:	e3a02010 	mov	r2, #16
    8890:	ea000000 	b	8898 <_ZNK13CGPIO_Handler18Get_GPEDS_LocationEjRjS0_+0x48>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:163 (discriminator 2)
    8894:	e3a02011 	mov	r2, #17
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:163 (discriminator 4)
    8898:	e51b3010 	ldr	r3, [fp, #-16]
    889c:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:164 (discriminator 4)
    bit_idx = pin % 32;
    88a0:	e51b300c 	ldr	r3, [fp, #-12]
    88a4:	e203201f 	and	r2, r3, #31
    88a8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    88ac:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:166 (discriminator 4)

    return true;
    88b0:	e3a03001 	mov	r3, #1
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:167
}
    88b4:	e1a00003 	mov	r0, r3
    88b8:	e28bd000 	add	sp, fp, #0
    88bc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    88c0:	e12fff1e 	bx	lr

000088c4 <_ZN13CGPIO_Handler20Clear_Detected_EventEj>:
_ZN13CGPIO_Handler20Clear_Detected_EventEj():
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:170

void CGPIO_Handler::Clear_Detected_Event(uint32_t pin)
{
    88c4:	e92d4800 	push	{fp, lr}
    88c8:	e28db004 	add	fp, sp, #4
    88cc:	e24dd010 	sub	sp, sp, #16
    88d0:	e50b0010 	str	r0, [fp, #-16]
    88d4:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:172
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
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:176
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
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:173
        return;
    892c:	e320f000 	nop	{0}
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:177
    8930:	e24bd004 	sub	sp, fp, #4
    8934:	e8bd8800 	pop	{fp, pc}

00008938 <_Z41__static_initialization_and_destruction_0ii>:
_Z41__static_initialization_and_destruction_0ii():
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:177
    8938:	e92d4800 	push	{fp, lr}
    893c:	e28db004 	add	fp, sp, #4
    8940:	e24dd008 	sub	sp, sp, #8
    8944:	e50b0008 	str	r0, [fp, #-8]
    8948:	e50b100c 	str	r1, [fp, #-12]
    894c:	e51b3008 	ldr	r3, [fp, #-8]
    8950:	e3530001 	cmp	r3, #1
    8954:	1a000006 	bne	8974 <_Z41__static_initialization_and_destruction_0ii+0x3c>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:177 (discriminator 1)
    8958:	e51b300c 	ldr	r3, [fp, #-12]
    895c:	e59f201c 	ldr	r2, [pc, #28]	; 8980 <_Z41__static_initialization_and_destruction_0ii+0x48>
    8960:	e1530002 	cmp	r3, r2
    8964:	1a000002 	bne	8974 <_Z41__static_initialization_and_destruction_0ii+0x3c>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:4
CGPIO_Handler sGPIO(hal::GPIO_Base);
    8968:	e59f1014 	ldr	r1, [pc, #20]	; 8984 <_Z41__static_initialization_and_destruction_0ii+0x4c>
    896c:	e59f0014 	ldr	r0, [pc, #20]	; 8988 <_Z41__static_initialization_and_destruction_0ii+0x50>
    8970:	ebfffdfd 	bl	816c <_ZN13CGPIO_HandlerC1Ej>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:177
    8974:	e320f000 	nop	{0}
    8978:	e24bd004 	sub	sp, fp, #4
    897c:	e8bd8800 	pop	{fp, pc}
    8980:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>
    8984:	20200000 	eorcs	r0, r0, r0
    8988:	00009288 	andeq	r9, r0, r8, lsl #5

0000898c <_GLOBAL__sub_I_sGPIO>:
_GLOBAL__sub_I_sGPIO():
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/gpio.cpp:177
    898c:	e92d4800 	push	{fp, lr}
    8990:	e28db004 	add	fp, sp, #4
    8994:	e59f1008 	ldr	r1, [pc, #8]	; 89a4 <_GLOBAL__sub_I_sGPIO+0x18>
    8998:	e3a00001 	mov	r0, #1
    899c:	ebffffe5 	bl	8938 <_Z41__static_initialization_and_destruction_0ii>
    89a0:	e8bd8800 	pop	{fp, pc}
    89a4:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>

000089a8 <_ZN6CTimerC1Em>:
_ZN6CTimerC2Em():
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/timer.cpp:26
    uint16_t unused_4 : 10;
};

#pragma pack(pop)

CTimer::CTimer(unsigned long timer_reg_base)
    89a8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    89ac:	e28db000 	add	fp, sp, #0
    89b0:	e24dd00c 	sub	sp, sp, #12
    89b4:	e50b0008 	str	r0, [fp, #-8]
    89b8:	e50b100c 	str	r1, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/timer.cpp:27
: mTimer_Regs(reinterpret_cast<unsigned int*>(timer_reg_base))
    89bc:	e51b200c 	ldr	r2, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/timer.cpp:28
, mCallback(nullptr)
    89c0:	e51b3008 	ldr	r3, [fp, #-8]
    89c4:	e5832000 	str	r2, [r3]
    89c8:	e51b3008 	ldr	r3, [fp, #-8]
    89cc:	e3a02000 	mov	r2, #0
    89d0:	e5832004 	str	r2, [r3, #4]
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/timer.cpp:31
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
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/timer.cpp:34

volatile unsigned int& CTimer::Regs(hal::Timer_Reg reg)
{
    89e8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    89ec:	e28db000 	add	fp, sp, #0
    89f0:	e24dd00c 	sub	sp, sp, #12
    89f4:	e50b0008 	str	r0, [fp, #-8]
    89f8:	e50b100c 	str	r1, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/timer.cpp:35
    return mTimer_Regs[static_cast<unsigned int>(reg)];
    89fc:	e51b3008 	ldr	r3, [fp, #-8]
    8a00:	e5932000 	ldr	r2, [r3]
    8a04:	e51b300c 	ldr	r3, [fp, #-12]
    8a08:	e1a03103 	lsl	r3, r3, #2
    8a0c:	e0823003 	add	r3, r2, r3
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/timer.cpp:36
}
    8a10:	e1a00003 	mov	r0, r3
    8a14:	e28bd000 	add	sp, fp, #0
    8a18:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8a1c:	e12fff1e 	bx	lr

00008a20 <_ZN6CTimer6EnableEPFvvEj16NTimer_Prescaler>:
_ZN6CTimer6EnableEPFvvEj16NTimer_Prescaler():
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/timer.cpp:39

void CTimer::Enable(TTimer_Callback callback, unsigned int delay, NTimer_Prescaler prescaler)
{
    8a20:	e92d4810 	push	{r4, fp, lr}
    8a24:	e28db008 	add	fp, sp, #8
    8a28:	e24dd01c 	sub	sp, sp, #28
    8a2c:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8a30:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    8a34:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    8a38:	e54b3021 	strb	r3, [fp, #-33]	; 0xffffffdf
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/timer.cpp:40
    Regs(hal::Timer_Reg::Load) = delay;
    8a3c:	e3a01000 	mov	r1, #0
    8a40:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    8a44:	ebffffe7 	bl	89e8 <_ZN6CTimer4RegsEN3hal9Timer_RegE>
    8a48:	e1a02000 	mov	r2, r0
    8a4c:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8a50:	e5823000 	str	r3, [r2]
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/timer.cpp:43

    TTimer_Ctl_Flags reg;
    reg.counter_32b = 1;
    8a54:	e55b3014 	ldrb	r3, [fp, #-20]	; 0xffffffec
    8a58:	e3833002 	orr	r3, r3, #2
    8a5c:	e54b3014 	strb	r3, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/timer.cpp:44
    reg.interrupt_enabled = 1;
    8a60:	e55b3014 	ldrb	r3, [fp, #-20]	; 0xffffffec
    8a64:	e3833020 	orr	r3, r3, #32
    8a68:	e54b3014 	strb	r3, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/timer.cpp:45
    reg.timer_enabled = 1;
    8a6c:	e55b3014 	ldrb	r3, [fp, #-20]	; 0xffffffec
    8a70:	e3833080 	orr	r3, r3, #128	; 0x80
    8a74:	e54b3014 	strb	r3, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/timer.cpp:46
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
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/timer.cpp:48

    Regs(hal::Timer_Reg::Control) = *reinterpret_cast<unsigned int*>(&reg);
    8aa0:	e24b4014 	sub	r4, fp, #20
    8aa4:	e3a01002 	mov	r1, #2
    8aa8:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    8aac:	ebffffcd 	bl	89e8 <_ZN6CTimer4RegsEN3hal9Timer_RegE>
    8ab0:	e1a02000 	mov	r2, r0
    8ab4:	e5943000 	ldr	r3, [r4]
    8ab8:	e5823000 	str	r3, [r2]
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/timer.cpp:50

    Regs(hal::Timer_Reg::IRQ_Clear) = 1;
    8abc:	e3a01003 	mov	r1, #3
    8ac0:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    8ac4:	ebffffc7 	bl	89e8 <_ZN6CTimer4RegsEN3hal9Timer_RegE>
    8ac8:	e1a03000 	mov	r3, r0
    8acc:	e3a02001 	mov	r2, #1
    8ad0:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/timer.cpp:52

    mCallback = callback;
    8ad4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8ad8:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8adc:	e5832004 	str	r2, [r3, #4]
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/timer.cpp:53
}
    8ae0:	e320f000 	nop	{0}
    8ae4:	e24bd008 	sub	sp, fp, #8
    8ae8:	e8bd8810 	pop	{r4, fp, pc}

00008aec <_ZN6CTimer7DisableEv>:
_ZN6CTimer7DisableEv():
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/timer.cpp:56

void CTimer::Disable()
{
    8aec:	e92d4800 	push	{fp, lr}
    8af0:	e28db004 	add	fp, sp, #4
    8af4:	e24dd010 	sub	sp, sp, #16
    8af8:	e50b0010 	str	r0, [fp, #-16]
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/timer.cpp:57
    volatile TTimer_Ctl_Flags& reg = reinterpret_cast<volatile TTimer_Ctl_Flags&>(Regs(hal::Timer_Reg::Control));
    8afc:	e3a01002 	mov	r1, #2
    8b00:	e51b0010 	ldr	r0, [fp, #-16]
    8b04:	ebffffb7 	bl	89e8 <_ZN6CTimer4RegsEN3hal9Timer_RegE>
    8b08:	e50b0008 	str	r0, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/timer.cpp:59

    reg.interrupt_enabled = 0;
    8b0c:	e51b2008 	ldr	r2, [fp, #-8]
    8b10:	e5d23000 	ldrb	r3, [r2]
    8b14:	e3c33020 	bic	r3, r3, #32
    8b18:	e5c23000 	strb	r3, [r2]
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/timer.cpp:60
    reg.timer_enabled = 0;
    8b1c:	e51b2008 	ldr	r2, [fp, #-8]
    8b20:	e5d23000 	ldrb	r3, [r2]
    8b24:	e3c33080 	bic	r3, r3, #128	; 0x80
    8b28:	e5c23000 	strb	r3, [r2]
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/timer.cpp:61
}
    8b2c:	e320f000 	nop	{0}
    8b30:	e24bd004 	sub	sp, fp, #4
    8b34:	e8bd8800 	pop	{fp, pc}

00008b38 <_ZN6CTimer12IRQ_CallbackEv>:
_ZN6CTimer12IRQ_CallbackEv():
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/timer.cpp:64

void CTimer::IRQ_Callback()
{
    8b38:	e92d4800 	push	{fp, lr}
    8b3c:	e28db004 	add	fp, sp, #4
    8b40:	e24dd008 	sub	sp, sp, #8
    8b44:	e50b0008 	str	r0, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/timer.cpp:65
    Regs(hal::Timer_Reg::IRQ_Clear) = 1;
    8b48:	e3a01003 	mov	r1, #3
    8b4c:	e51b0008 	ldr	r0, [fp, #-8]
    8b50:	ebffffa4 	bl	89e8 <_ZN6CTimer4RegsEN3hal9Timer_RegE>
    8b54:	e1a03000 	mov	r3, r0
    8b58:	e3a02001 	mov	r2, #1
    8b5c:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/timer.cpp:67

    if (mCallback)
    8b60:	e51b3008 	ldr	r3, [fp, #-8]
    8b64:	e5933004 	ldr	r3, [r3, #4]
    8b68:	e3530000 	cmp	r3, #0
    8b6c:	0a000002 	beq	8b7c <_ZN6CTimer12IRQ_CallbackEv+0x44>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/timer.cpp:68
        mCallback();
    8b70:	e51b3008 	ldr	r3, [fp, #-8]
    8b74:	e5933004 	ldr	r3, [r3, #4]
    8b78:	e12fff33 	blx	r3
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/timer.cpp:69
}
    8b7c:	e320f000 	nop	{0}
    8b80:	e24bd004 	sub	sp, fp, #4
    8b84:	e8bd8800 	pop	{fp, pc}

00008b88 <_ZN6CTimer20Is_Timer_IRQ_PendingEv>:
_ZN6CTimer20Is_Timer_IRQ_PendingEv():
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/timer.cpp:72

bool CTimer::Is_Timer_IRQ_Pending()
{
    8b88:	e92d4800 	push	{fp, lr}
    8b8c:	e28db004 	add	fp, sp, #4
    8b90:	e24dd008 	sub	sp, sp, #8
    8b94:	e50b0008 	str	r0, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/timer.cpp:73
    return Regs(hal::Timer_Reg::IRQ_Masked);
    8b98:	e3a01005 	mov	r1, #5
    8b9c:	e51b0008 	ldr	r0, [fp, #-8]
    8ba0:	ebffff90 	bl	89e8 <_ZN6CTimer4RegsEN3hal9Timer_RegE>
    8ba4:	e1a03000 	mov	r3, r0
    8ba8:	e5933000 	ldr	r3, [r3]
    8bac:	e3530000 	cmp	r3, #0
    8bb0:	13a03001 	movne	r3, #1
    8bb4:	03a03000 	moveq	r3, #0
    8bb8:	e6ef3073 	uxtb	r3, r3
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/timer.cpp:74
}
    8bbc:	e1a00003 	mov	r0, r3
    8bc0:	e24bd004 	sub	sp, fp, #4
    8bc4:	e8bd8800 	pop	{fp, pc}

00008bc8 <_Z41__static_initialization_and_destruction_0ii>:
_Z41__static_initialization_and_destruction_0ii():
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/timer.cpp:74
    8bc8:	e92d4800 	push	{fp, lr}
    8bcc:	e28db004 	add	fp, sp, #4
    8bd0:	e24dd008 	sub	sp, sp, #8
    8bd4:	e50b0008 	str	r0, [fp, #-8]
    8bd8:	e50b100c 	str	r1, [fp, #-12]
    8bdc:	e51b3008 	ldr	r3, [fp, #-8]
    8be0:	e3530001 	cmp	r3, #1
    8be4:	1a000006 	bne	8c04 <_Z41__static_initialization_and_destruction_0ii+0x3c>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/timer.cpp:74 (discriminator 1)
    8be8:	e51b300c 	ldr	r3, [fp, #-12]
    8bec:	e59f201c 	ldr	r2, [pc, #28]	; 8c10 <_Z41__static_initialization_and_destruction_0ii+0x48>
    8bf0:	e1530002 	cmp	r3, r2
    8bf4:	1a000002 	bne	8c04 <_Z41__static_initialization_and_destruction_0ii+0x3c>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/timer.cpp:4
CTimer sTimer(hal::Timer_Base);
    8bf8:	e59f1014 	ldr	r1, [pc, #20]	; 8c14 <_Z41__static_initialization_and_destruction_0ii+0x4c>
    8bfc:	e59f0014 	ldr	r0, [pc, #20]	; 8c18 <_Z41__static_initialization_and_destruction_0ii+0x50>
    8c00:	ebffff68 	bl	89a8 <_ZN6CTimerC1Em>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/timer.cpp:74
}
    8c04:	e320f000 	nop	{0}
    8c08:	e24bd004 	sub	sp, fp, #4
    8c0c:	e8bd8800 	pop	{fp, pc}
    8c10:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>
    8c14:	2000b400 	andcs	fp, r0, r0, lsl #8
    8c18:	0000928c 	andeq	r9, r0, ip, lsl #5

00008c1c <_GLOBAL__sub_I_sTimer>:
_GLOBAL__sub_I_sTimer():
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/drivers/timer.cpp:74
    8c1c:	e92d4800 	push	{fp, lr}
    8c20:	e28db004 	add	fp, sp, #4
    8c24:	e59f1008 	ldr	r1, [pc, #8]	; 8c34 <_GLOBAL__sub_I_sTimer+0x18>
    8c28:	e3a00001 	mov	r0, #1
    8c2c:	ebffffe5 	bl	8bc8 <_Z41__static_initialization_and_destruction_0ii>
    8c30:	e8bd8800 	pop	{fp, pc}
    8c34:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>

00008c38 <software_interrupt_handler>:
software_interrupt_handler():
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/interrupt_controller.cpp:8
#include <drivers/gpio.h>
#include <interrupt_controller.h>
#include <drivers/timer.h>

extern "C" void __attribute__((interrupt("SWI"))) software_interrupt_handler()
{
    8c38:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8c3c:	e28db000 	add	fp, sp, #0
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/interrupt_controller.cpp:9
}
    8c40:	e320f000 	nop	{0}
    8c44:	e28bd000 	add	sp, fp, #0
    8c48:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8c4c:	e1b0f00e 	movs	pc, lr

00008c50 <irq_handler>:
irq_handler():
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/interrupt_controller.cpp:12

extern "C" void __attribute__((interrupt("IRQ"))) irq_handler()
{
    8c50:	e24ee004 	sub	lr, lr, #4
    8c54:	e92d581f 	push	{r0, r1, r2, r3, r4, fp, ip, lr}
    8c58:	e28db01c 	add	fp, sp, #28
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/interrupt_controller.cpp:15
    static bool pin_48_state{ true };

    if (sTimer.Is_Timer_IRQ_Pending())
    8c5c:	e59f0060 	ldr	r0, [pc, #96]	; 8cc4 <irq_handler+0x74>
    8c60:	ebffffc8 	bl	8b88 <_ZN6CTimer20Is_Timer_IRQ_PendingEv>
    8c64:	e1a03000 	mov	r3, r0
    8c68:	e3530000 	cmp	r3, #0
    8c6c:	0a000002 	beq	8c7c <irq_handler+0x2c>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/interrupt_controller.cpp:16
        sTimer.IRQ_Callback();
    8c70:	e59f004c 	ldr	r0, [pc, #76]	; 8cc4 <irq_handler+0x74>
    8c74:	ebffffaf 	bl	8b38 <_ZN6CTimer12IRQ_CallbackEv>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/interrupt_controller.cpp:23
    {
        sGPIO.Set_Output(48, pin_48_state);
        sGPIO.Clear_Detected_Event(46);
        pin_48_state = !pin_48_state;
    }
}
    8c78:	ea00000e 	b	8cb8 <irq_handler+0x68>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/interrupt_controller.cpp:19
        sGPIO.Set_Output(48, pin_48_state);
    8c7c:	e59f3044 	ldr	r3, [pc, #68]	; 8cc8 <irq_handler+0x78>
    8c80:	e5d33000 	ldrb	r3, [r3]
    8c84:	e1a02003 	mov	r2, r3
    8c88:	e3a01030 	mov	r1, #48	; 0x30
    8c8c:	e59f0038 	ldr	r0, [pc, #56]	; 8ccc <irq_handler+0x7c>
    8c90:	ebfffeb8 	bl	8778 <_ZN13CGPIO_Handler10Set_OutputEjb>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/interrupt_controller.cpp:20
        sGPIO.Clear_Detected_Event(46);
    8c94:	e3a0102e 	mov	r1, #46	; 0x2e
    8c98:	e59f002c 	ldr	r0, [pc, #44]	; 8ccc <irq_handler+0x7c>
    8c9c:	ebffff08 	bl	88c4 <_ZN13CGPIO_Handler20Clear_Detected_EventEj>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/interrupt_controller.cpp:21
        pin_48_state = !pin_48_state;
    8ca0:	e59f3020 	ldr	r3, [pc, #32]	; 8cc8 <irq_handler+0x78>
    8ca4:	e5d33000 	ldrb	r3, [r3]
    8ca8:	e2233001 	eor	r3, r3, #1
    8cac:	e6ef2073 	uxtb	r2, r3
    8cb0:	e59f3010 	ldr	r3, [pc, #16]	; 8cc8 <irq_handler+0x78>
    8cb4:	e5c32000 	strb	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/interrupt_controller.cpp:23
}
    8cb8:	e320f000 	nop	{0}
    8cbc:	e24bd01c 	sub	sp, fp, #28
    8cc0:	e8fd981f 	ldm	sp!, {r0, r1, r2, r3, r4, fp, ip, pc}^
    8cc4:	0000928c 	andeq	r9, r0, ip, lsl #5
    8cc8:	00009284 	andeq	r9, r0, r4, lsl #5
    8ccc:	00009288 	andeq	r9, r0, r8, lsl #5

00008cd0 <fast_interrupt_handler>:
fast_interrupt_handler():
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/interrupt_controller.cpp:26

extern "C" void __attribute__((interrupt("FIQ"))) fast_interrupt_handler()
{
    8cd0:	e24db004 	sub	fp, sp, #4
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/interrupt_controller.cpp:27
}
    8cd4:	e320f000 	nop	{0}
    8cd8:	e28bd004 	add	sp, fp, #4
    8cdc:	e25ef004 	subs	pc, lr, #4

00008ce0 <_ZN21CInterrupt_ControllerC1Em>:
_ZN21CInterrupt_ControllerC2Em():
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/interrupt_controller.cpp:31

CInterrupt_Controller sInterruptCtl(hal::Interrupt_Controller_Base);

CInterrupt_Controller::CInterrupt_Controller(unsigned long base)
    8ce0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8ce4:	e28db000 	add	fp, sp, #0
    8ce8:	e24dd00c 	sub	sp, sp, #12
    8cec:	e50b0008 	str	r0, [fp, #-8]
    8cf0:	e50b100c 	str	r1, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/interrupt_controller.cpp:32
: mInterrupt_Regs(reinterpret_cast<unsigned int*>(base))
    8cf4:	e51b200c 	ldr	r2, [fp, #-12]
    8cf8:	e51b3008 	ldr	r3, [fp, #-8]
    8cfc:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/interrupt_controller.cpp:34
{
}
    8d00:	e51b3008 	ldr	r3, [fp, #-8]
    8d04:	e1a00003 	mov	r0, r3
    8d08:	e28bd000 	add	sp, fp, #0
    8d0c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8d10:	e12fff1e 	bx	lr

00008d14 <_ZN21CInterrupt_Controller4RegsEN3hal24Interrupt_Controller_RegE>:
_ZN21CInterrupt_Controller4RegsEN3hal24Interrupt_Controller_RegE():
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/interrupt_controller.cpp:37

volatile unsigned int& CInterrupt_Controller::Regs(hal::Interrupt_Controller_Reg reg)
{
    8d14:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8d18:	e28db000 	add	fp, sp, #0
    8d1c:	e24dd00c 	sub	sp, sp, #12
    8d20:	e50b0008 	str	r0, [fp, #-8]
    8d24:	e50b100c 	str	r1, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/interrupt_controller.cpp:38
    return mInterrupt_Regs[static_cast<unsigned int>(reg)];
    8d28:	e51b3008 	ldr	r3, [fp, #-8]
    8d2c:	e5932000 	ldr	r2, [r3]
    8d30:	e51b300c 	ldr	r3, [fp, #-12]
    8d34:	e1a03103 	lsl	r3, r3, #2
    8d38:	e0823003 	add	r3, r2, r3
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/interrupt_controller.cpp:39
}
    8d3c:	e1a00003 	mov	r0, r3
    8d40:	e28bd000 	add	sp, fp, #0
    8d44:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8d48:	e12fff1e 	bx	lr

00008d4c <_ZN21CInterrupt_Controller16Enable_Basic_IRQEN3hal16IRQ_Basic_SourceE>:
_ZN21CInterrupt_Controller16Enable_Basic_IRQEN3hal16IRQ_Basic_SourceE():
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/interrupt_controller.cpp:42

void CInterrupt_Controller::Enable_Basic_IRQ(hal::IRQ_Basic_Source source_idx)
{
    8d4c:	e92d4810 	push	{r4, fp, lr}
    8d50:	e28db008 	add	fp, sp, #8
    8d54:	e24dd00c 	sub	sp, sp, #12
    8d58:	e50b0010 	str	r0, [fp, #-16]
    8d5c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/interrupt_controller.cpp:43
    Regs(hal::Interrupt_Controller_Reg::IRQ_Basic_Enable) = (1 << static_cast<unsigned int>(source_idx));
    8d60:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8d64:	e3a02001 	mov	r2, #1
    8d68:	e1a04312 	lsl	r4, r2, r3
    8d6c:	e3a01006 	mov	r1, #6
    8d70:	e51b0010 	ldr	r0, [fp, #-16]
    8d74:	ebffffe6 	bl	8d14 <_ZN21CInterrupt_Controller4RegsEN3hal24Interrupt_Controller_RegE>
    8d78:	e1a03000 	mov	r3, r0
    8d7c:	e1a02004 	mov	r2, r4
    8d80:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/interrupt_controller.cpp:44
}
    8d84:	e320f000 	nop	{0}
    8d88:	e24bd008 	sub	sp, fp, #8
    8d8c:	e8bd8810 	pop	{r4, fp, pc}

00008d90 <_ZN21CInterrupt_Controller17Disable_Basic_IRQEN3hal16IRQ_Basic_SourceE>:
_ZN21CInterrupt_Controller17Disable_Basic_IRQEN3hal16IRQ_Basic_SourceE():
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/interrupt_controller.cpp:47

void CInterrupt_Controller::Disable_Basic_IRQ(hal::IRQ_Basic_Source source_idx)
{
    8d90:	e92d4810 	push	{r4, fp, lr}
    8d94:	e28db008 	add	fp, sp, #8
    8d98:	e24dd00c 	sub	sp, sp, #12
    8d9c:	e50b0010 	str	r0, [fp, #-16]
    8da0:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/interrupt_controller.cpp:48
    Regs(hal::Interrupt_Controller_Reg::IRQ_Basic_Disable) = (1 << static_cast<unsigned int>(source_idx));
    8da4:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8da8:	e3a02001 	mov	r2, #1
    8dac:	e1a04312 	lsl	r4, r2, r3
    8db0:	e3a01009 	mov	r1, #9
    8db4:	e51b0010 	ldr	r0, [fp, #-16]
    8db8:	ebffffd5 	bl	8d14 <_ZN21CInterrupt_Controller4RegsEN3hal24Interrupt_Controller_RegE>
    8dbc:	e1a03000 	mov	r3, r0
    8dc0:	e1a02004 	mov	r2, r4
    8dc4:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/interrupt_controller.cpp:49
}
    8dc8:	e320f000 	nop	{0}
    8dcc:	e24bd008 	sub	sp, fp, #8
    8dd0:	e8bd8810 	pop	{r4, fp, pc}

00008dd4 <_ZN21CInterrupt_Controller10Enable_IRQEN3hal10IRQ_SourceE>:
_ZN21CInterrupt_Controller10Enable_IRQEN3hal10IRQ_SourceE():
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/interrupt_controller.cpp:52

void CInterrupt_Controller::Enable_IRQ(hal::IRQ_Source source_idx)
{
    8dd4:	e92d4810 	push	{r4, fp, lr}
    8dd8:	e28db008 	add	fp, sp, #8
    8ddc:	e24dd014 	sub	sp, sp, #20
    8de0:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8de4:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/interrupt_controller.cpp:53
    const unsigned int idx_base = static_cast<unsigned int>(source_idx);
    8de8:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8dec:	e50b3010 	str	r3, [fp, #-16]
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/interrupt_controller.cpp:55

    Regs(idx_base < 32 ? hal::Interrupt_Controller_Reg::IRQ_Enable_1 : hal::Interrupt_Controller_Reg::IRQ_Enable_2) = (1 << (idx_base % 32));
    8df0:	e51b3010 	ldr	r3, [fp, #-16]
    8df4:	e203301f 	and	r3, r3, #31
    8df8:	e3a02001 	mov	r2, #1
    8dfc:	e1a04312 	lsl	r4, r2, r3
    8e00:	e51b3010 	ldr	r3, [fp, #-16]
    8e04:	e353001f 	cmp	r3, #31
    8e08:	8a000001 	bhi	8e14 <_ZN21CInterrupt_Controller10Enable_IRQEN3hal10IRQ_SourceE+0x40>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/interrupt_controller.cpp:55 (discriminator 1)
    8e0c:	e3a03004 	mov	r3, #4
    8e10:	ea000000 	b	8e18 <_ZN21CInterrupt_Controller10Enable_IRQEN3hal10IRQ_SourceE+0x44>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/interrupt_controller.cpp:55 (discriminator 2)
    8e14:	e3a03005 	mov	r3, #5
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/interrupt_controller.cpp:55 (discriminator 4)
    8e18:	e1a01003 	mov	r1, r3
    8e1c:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    8e20:	ebffffbb 	bl	8d14 <_ZN21CInterrupt_Controller4RegsEN3hal24Interrupt_Controller_RegE>
    8e24:	e1a03000 	mov	r3, r0
    8e28:	e1a02004 	mov	r2, r4
    8e2c:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/interrupt_controller.cpp:56 (discriminator 4)
}
    8e30:	e320f000 	nop	{0}
    8e34:	e24bd008 	sub	sp, fp, #8
    8e38:	e8bd8810 	pop	{r4, fp, pc}

00008e3c <_ZN21CInterrupt_Controller11Disable_IRQEN3hal10IRQ_SourceE>:
_ZN21CInterrupt_Controller11Disable_IRQEN3hal10IRQ_SourceE():
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/interrupt_controller.cpp:59

void CInterrupt_Controller::Disable_IRQ(hal::IRQ_Source source_idx)
{
    8e3c:	e92d4810 	push	{r4, fp, lr}
    8e40:	e28db008 	add	fp, sp, #8
    8e44:	e24dd014 	sub	sp, sp, #20
    8e48:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8e4c:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/interrupt_controller.cpp:60
    const unsigned int idx_base = static_cast<unsigned int>(source_idx);
    8e50:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8e54:	e50b3010 	str	r3, [fp, #-16]
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/interrupt_controller.cpp:62

    Regs(idx_base < 32 ? hal::Interrupt_Controller_Reg::IRQ_Disable_1 : hal::Interrupt_Controller_Reg::IRQ_Disable_2) = (1 << (idx_base % 32));
    8e58:	e51b3010 	ldr	r3, [fp, #-16]
    8e5c:	e203301f 	and	r3, r3, #31
    8e60:	e3a02001 	mov	r2, #1
    8e64:	e1a04312 	lsl	r4, r2, r3
    8e68:	e51b3010 	ldr	r3, [fp, #-16]
    8e6c:	e353001f 	cmp	r3, #31
    8e70:	8a000001 	bhi	8e7c <_ZN21CInterrupt_Controller11Disable_IRQEN3hal10IRQ_SourceE+0x40>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/interrupt_controller.cpp:62 (discriminator 1)
    8e74:	e3a03007 	mov	r3, #7
    8e78:	ea000000 	b	8e80 <_ZN21CInterrupt_Controller11Disable_IRQEN3hal10IRQ_SourceE+0x44>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/interrupt_controller.cpp:62 (discriminator 2)
    8e7c:	e3a03008 	mov	r3, #8
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/interrupt_controller.cpp:62 (discriminator 4)
    8e80:	e1a01003 	mov	r1, r3
    8e84:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    8e88:	ebffffa1 	bl	8d14 <_ZN21CInterrupt_Controller4RegsEN3hal24Interrupt_Controller_RegE>
    8e8c:	e1a03000 	mov	r3, r0
    8e90:	e1a02004 	mov	r2, r4
    8e94:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/interrupt_controller.cpp:63 (discriminator 4)
}
    8e98:	e320f000 	nop	{0}
    8e9c:	e24bd008 	sub	sp, fp, #8
    8ea0:	e8bd8810 	pop	{r4, fp, pc}

00008ea4 <_Z41__static_initialization_and_destruction_0ii>:
_Z41__static_initialization_and_destruction_0ii():
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/interrupt_controller.cpp:63
    8ea4:	e92d4800 	push	{fp, lr}
    8ea8:	e28db004 	add	fp, sp, #4
    8eac:	e24dd008 	sub	sp, sp, #8
    8eb0:	e50b0008 	str	r0, [fp, #-8]
    8eb4:	e50b100c 	str	r1, [fp, #-12]
    8eb8:	e51b3008 	ldr	r3, [fp, #-8]
    8ebc:	e3530001 	cmp	r3, #1
    8ec0:	1a000006 	bne	8ee0 <_Z41__static_initialization_and_destruction_0ii+0x3c>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/interrupt_controller.cpp:63 (discriminator 1)
    8ec4:	e51b300c 	ldr	r3, [fp, #-12]
    8ec8:	e59f201c 	ldr	r2, [pc, #28]	; 8eec <_Z41__static_initialization_and_destruction_0ii+0x48>
    8ecc:	e1530002 	cmp	r3, r2
    8ed0:	1a000002 	bne	8ee0 <_Z41__static_initialization_and_destruction_0ii+0x3c>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/interrupt_controller.cpp:29
CInterrupt_Controller sInterruptCtl(hal::Interrupt_Controller_Base);
    8ed4:	e59f1014 	ldr	r1, [pc, #20]	; 8ef0 <_Z41__static_initialization_and_destruction_0ii+0x4c>
    8ed8:	e59f0014 	ldr	r0, [pc, #20]	; 8ef4 <_Z41__static_initialization_and_destruction_0ii+0x50>
    8edc:	ebffff7f 	bl	8ce0 <_ZN21CInterrupt_ControllerC1Em>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/interrupt_controller.cpp:63
}
    8ee0:	e320f000 	nop	{0}
    8ee4:	e24bd004 	sub	sp, fp, #4
    8ee8:	e8bd8800 	pop	{fp, pc}
    8eec:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>
    8ef0:	2000b200 	andcs	fp, r0, r0, lsl #4
    8ef4:	00009294 	muleq	r0, r4, r2

00008ef8 <_GLOBAL__sub_I_software_interrupt_handler>:
_GLOBAL__sub_I_software_interrupt_handler():
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/interrupt_controller.cpp:63
    8ef8:	e92d4800 	push	{fp, lr}
    8efc:	e28db004 	add	fp, sp, #4
    8f00:	e59f1008 	ldr	r1, [pc, #8]	; 8f10 <_GLOBAL__sub_I_software_interrupt_handler+0x18>
    8f04:	e3a00001 	mov	r0, #1
    8f08:	ebffffe5 	bl	8ea4 <_Z41__static_initialization_and_destruction_0ii>
    8f0c:	e8bd8800 	pop	{fp, pc}
    8f10:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>

00008f14 <ACT_LED_Blinker>:
ACT_LED_Blinker():
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/main.cpp:8
#include <drivers/timer.h>

volatile int LED_State = 0;

extern "C" void ACT_LED_Blinker()
{
    8f14:	e92d4800 	push	{fp, lr}
    8f18:	e28db004 	add	fp, sp, #4
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/main.cpp:11
    // prepinani LED pri kazdem vytikani casovace

    if (LED_State)
    8f1c:	e59f305c 	ldr	r3, [pc, #92]	; 8f80 <ACT_LED_Blinker+0x6c>
    8f20:	e5933000 	ldr	r3, [r3]
    8f24:	e3530000 	cmp	r3, #0
    8f28:	13a03001 	movne	r3, #1
    8f2c:	03a03000 	moveq	r3, #0
    8f30:	e6ef3073 	uxtb	r3, r3
    8f34:	e3530000 	cmp	r3, #0
    8f38:	0a000007 	beq	8f5c <ACT_LED_Blinker+0x48>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/main.cpp:13
    {
        LED_State = 0;
    8f3c:	e59f303c 	ldr	r3, [pc, #60]	; 8f80 <ACT_LED_Blinker+0x6c>
    8f40:	e3a02000 	mov	r2, #0
    8f44:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/main.cpp:14
        sGPIO.Set_Output(47, true);
    8f48:	e3a02001 	mov	r2, #1
    8f4c:	e3a0102f 	mov	r1, #47	; 0x2f
    8f50:	e59f002c 	ldr	r0, [pc, #44]	; 8f84 <ACT_LED_Blinker+0x70>
    8f54:	ebfffe07 	bl	8778 <_ZN13CGPIO_Handler10Set_OutputEjb>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/main.cpp:21
    else
    {
        LED_State = 1;
        sGPIO.Set_Output(47, false);
    }
}
    8f58:	ea000006 	b	8f78 <ACT_LED_Blinker+0x64>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/main.cpp:18
        LED_State = 1;
    8f5c:	e59f301c 	ldr	r3, [pc, #28]	; 8f80 <ACT_LED_Blinker+0x6c>
    8f60:	e3a02001 	mov	r2, #1
    8f64:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/main.cpp:19
        sGPIO.Set_Output(47, false);
    8f68:	e3a02000 	mov	r2, #0
    8f6c:	e3a0102f 	mov	r1, #47	; 0x2f
    8f70:	e59f000c 	ldr	r0, [pc, #12]	; 8f84 <ACT_LED_Blinker+0x70>
    8f74:	ebfffdff 	bl	8778 <_ZN13CGPIO_Handler10Set_OutputEjb>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/main.cpp:21
}
    8f78:	e320f000 	nop	{0}
    8f7c:	e8bd8800 	pop	{fp, pc}
    8f80:	00009298 	muleq	r0, r8, r2
    8f84:	00009288 	andeq	r9, r0, r8, lsl #5

00008f88 <_kernel_main>:
_kernel_main():
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/main.cpp:24

extern "C" int _kernel_main(void)
{
    8f88:	e92d4800 	push	{fp, lr}
    8f8c:	e28db004 	add	fp, sp, #4
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/main.cpp:25
    sGPIO.Set_GPIO_Function(47, NGPIO_Function::Output);
    8f90:	e3a02001 	mov	r2, #1
    8f94:	e3a0102f 	mov	r1, #47	; 0x2f
    8f98:	e59f0080 	ldr	r0, [pc, #128]	; 9020 <_kernel_main+0x98>
    8f9c:	ebfffd1b 	bl	8410 <_ZN13CGPIO_Handler17Set_GPIO_FunctionEj14NGPIO_Function>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/main.cpp:26
    sGPIO.Set_GPIO_Function(48, NGPIO_Function::Output);
    8fa0:	e3a02001 	mov	r2, #1
    8fa4:	e3a01030 	mov	r1, #48	; 0x30
    8fa8:	e59f0070 	ldr	r0, [pc, #112]	; 9020 <_kernel_main+0x98>
    8fac:	ebfffd17 	bl	8410 <_ZN13CGPIO_Handler17Set_GPIO_FunctionEj14NGPIO_Function>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/main.cpp:28

    sGPIO.Set_GPIO_Function(46, NGPIO_Function::Input);
    8fb0:	e3a02000 	mov	r2, #0
    8fb4:	e3a0102e 	mov	r1, #46	; 0x2e
    8fb8:	e59f0060 	ldr	r0, [pc, #96]	; 9020 <_kernel_main+0x98>
    8fbc:	ebfffd13 	bl	8410 <_ZN13CGPIO_Handler17Set_GPIO_FunctionEj14NGPIO_Function>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/main.cpp:29
    sGPIO.Enable_Event_Detect(46, NGPIO_Interrupt_Type::Rising_Edge);
    8fc0:	e3a02000 	mov	r2, #0
    8fc4:	e3a0102e 	mov	r1, #46	; 0x2e
    8fc8:	e59f0050 	ldr	r0, [pc, #80]	; 9020 <_kernel_main+0x98>
    8fcc:	ebfffd58 	bl	8534 <_ZN13CGPIO_Handler19Enable_Event_DetectEj20NGPIO_Interrupt_Type>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/main.cpp:30
    sGPIO.Enable_Event_Detect(46, NGPIO_Interrupt_Type::Falling_Edge);
    8fd0:	e3a02001 	mov	r2, #1
    8fd4:	e3a0102e 	mov	r1, #46	; 0x2e
    8fd8:	e59f0040 	ldr	r0, [pc, #64]	; 9020 <_kernel_main+0x98>
    8fdc:	ebfffd54 	bl	8534 <_ZN13CGPIO_Handler19Enable_Event_DetectEj20NGPIO_Interrupt_Type>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/main.cpp:32

    sInterruptCtl.Enable_IRQ(hal::IRQ_Source::GPIO_2);
    8fe0:	e3a01033 	mov	r1, #51	; 0x33
    8fe4:	e59f0038 	ldr	r0, [pc, #56]	; 9024 <_kernel_main+0x9c>
    8fe8:	ebffff79 	bl	8dd4 <_ZN21CInterrupt_Controller10Enable_IRQEN3hal10IRQ_SourceE>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/main.cpp:34

    sInterruptCtl.Disable_Basic_IRQ(hal::IRQ_Basic_Source::Timer);
    8fec:	e3a01000 	mov	r1, #0
    8ff0:	e59f002c 	ldr	r0, [pc, #44]	; 9024 <_kernel_main+0x9c>
    8ff4:	ebffff65 	bl	8d90 <_ZN21CInterrupt_Controller17Disable_Basic_IRQEN3hal16IRQ_Basic_SourceE>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/main.cpp:37

    // nastavime casovac - budeme pro ted blikat LEDkou, v budoucnu muzeme treba spoustet planovac procesu
    sTimer.Enable(ACT_LED_Blinker, 0x100, NTimer_Prescaler::Prescaler_16);
    8ff8:	e3a03001 	mov	r3, #1
    8ffc:	e3a02c01 	mov	r2, #256	; 0x100
    9000:	e59f1020 	ldr	r1, [pc, #32]	; 9028 <_kernel_main+0xa0>
    9004:	e59f0020 	ldr	r0, [pc, #32]	; 902c <_kernel_main+0xa4>
    9008:	ebfffe84 	bl	8a20 <_ZN6CTimer6EnableEPFvvEj16NTimer_Prescaler>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/main.cpp:40

    // povolime IRQ casovace
    sInterruptCtl.Enable_Basic_IRQ(hal::IRQ_Basic_Source::Timer);
    900c:	e3a01000 	mov	r1, #0
    9010:	e59f000c 	ldr	r0, [pc, #12]	; 9024 <_kernel_main+0x9c>
    9014:	ebffff4c 	bl	8d4c <_ZN21CInterrupt_Controller16Enable_Basic_IRQEN3hal16IRQ_Basic_SourceE>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/main.cpp:42

    enable_irq();
    9018:	eb000004 	bl	9030 <enable_irq>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/main.cpp:44 (discriminator 1)

    while (1)
    901c:	eafffffe 	b	901c <_kernel_main+0x94>
    9020:	00009288 	andeq	r9, r0, r8, lsl #5
    9024:	00009294 	muleq	r0, r4, r2
    9028:	00008f14 	andeq	r8, r0, r4, lsl pc
    902c:	0000928c 	andeq	r9, r0, ip, lsl #5

00009030 <enable_irq>:
enable_irq():
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/start.s:90
;@ tady budou ostatni symboly, ktere nevyzaduji zadne specialni misto
.section .text

.global enable_irq
enable_irq:
    mrs r0, cpsr		;@ presun ridiciho registru (CPSR) do general purpose registru (R0)
    9030:	e10f0000 	mrs	r0, CPSR
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/start.s:91
    bic r0, r0, #0x80	;@ vypne bit 7 v registru r0 ("IRQ mask bit")
    9034:	e3c00080 	bic	r0, r0, #128	; 0x80
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/start.s:92
    msr cpsr_c, r0		;@ nacteme upraveny general purpose (R0) registr do ridiciho (CPSR)
    9038:	e121f000 	msr	CPSR_c, r0
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/start.s:93
    cpsie i				;@ povoli preruseni
    903c:	f1080080 	cpsie	i
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/start.s:94
    bx lr
    9040:	e12fff1e 	bx	lr

00009044 <undefined_instruction_handler>:
undefined_instruction_handler():
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/start.s:97

undefined_instruction_handler:
	b hang
    9044:	eafffc11 	b	8090 <hang>

00009048 <prefetch_abort_handler>:
prefetch_abort_handler():
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/start.s:102

prefetch_abort_handler:
	;@ tady pak muzeme osetrit, kdyz program zasahne do mista, ktere nema mapovane ve svem virtualnim adr. prostoru
	;@ a treba vyvolat nasi obdobu segfaultu
	b hang
    9048:	eafffc10 	b	8090 <hang>

0000904c <data_abort_handler>:
data_abort_handler():
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/start.s:107

data_abort_handler:
	;@ tady pak muzeme osetrit, kdyz program zasahne do mista, ktere nema mapovane ve svem virtualnim adr. prostoru
	;@ a treba vyvolat nasi obdobu segfaultu
	b hang
    904c:	eafffc0f 	b	8090 <hang>

00009050 <_c_startup>:
_c_startup():
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/startup.cpp:21
extern "C" dtor_ptr __DTOR_LIST__[0];
// konec pole destruktoru
extern "C" dtor_ptr __DTOR_END__[0];

extern "C" int _c_startup(void)
{
    9050:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9054:	e28db000 	add	fp, sp, #0
    9058:	e24dd00c 	sub	sp, sp, #12
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/startup.cpp:25
    int* i;

    // vynulujeme .bss sekci
    for (i = (int*)_bss_start; i < (int*)_bss_end; i++)
    905c:	e59f304c 	ldr	r3, [pc, #76]	; 90b0 <_c_startup+0x60>
    9060:	e5933000 	ldr	r3, [r3]
    9064:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/startup.cpp:25 (discriminator 3)
    9068:	e59f3044 	ldr	r3, [pc, #68]	; 90b4 <_c_startup+0x64>
    906c:	e5933000 	ldr	r3, [r3]
    9070:	e1a02003 	mov	r2, r3
    9074:	e51b3008 	ldr	r3, [fp, #-8]
    9078:	e1530002 	cmp	r3, r2
    907c:	2a000006 	bcs	909c <_c_startup+0x4c>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/startup.cpp:26 (discriminator 2)
        *i = 0;
    9080:	e51b3008 	ldr	r3, [fp, #-8]
    9084:	e3a02000 	mov	r2, #0
    9088:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/startup.cpp:25 (discriminator 2)
    for (i = (int*)_bss_start; i < (int*)_bss_end; i++)
    908c:	e51b3008 	ldr	r3, [fp, #-8]
    9090:	e2833004 	add	r3, r3, #4
    9094:	e50b3008 	str	r3, [fp, #-8]
    9098:	eafffff2 	b	9068 <_c_startup+0x18>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/startup.cpp:28

    return 0;
    909c:	e3a03000 	mov	r3, #0
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/startup.cpp:29
}
    90a0:	e1a00003 	mov	r0, r3
    90a4:	e28bd000 	add	sp, fp, #0
    90a8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    90ac:	e12fff1e 	bx	lr
    90b0:	00009285 	andeq	r9, r0, r5, lsl #5
    90b4:	000092ac 	andeq	r9, r0, ip, lsr #5

000090b8 <_cpp_startup>:
_cpp_startup():
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/startup.cpp:32

extern "C" int _cpp_startup(void)
{
    90b8:	e92d4800 	push	{fp, lr}
    90bc:	e28db004 	add	fp, sp, #4
    90c0:	e24dd008 	sub	sp, sp, #8
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/startup.cpp:37
    ctor_ptr* fnptr;

    // zavolame konstruktory globalnich C++ trid
    // v poli __CTOR_LIST__ jsou ukazatele na vygenerovane stuby volani konstruktoru
    for (fnptr = __CTOR_LIST__; fnptr < __CTOR_END__; fnptr++)
    90c4:	e59f303c 	ldr	r3, [pc, #60]	; 9108 <_cpp_startup+0x50>
    90c8:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/startup.cpp:37 (discriminator 3)
    90cc:	e51b3008 	ldr	r3, [fp, #-8]
    90d0:	e59f2034 	ldr	r2, [pc, #52]	; 910c <_cpp_startup+0x54>
    90d4:	e1530002 	cmp	r3, r2
    90d8:	2a000006 	bcs	90f8 <_cpp_startup+0x40>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/startup.cpp:38 (discriminator 2)
        (*fnptr)();
    90dc:	e51b3008 	ldr	r3, [fp, #-8]
    90e0:	e5933000 	ldr	r3, [r3]
    90e4:	e12fff33 	blx	r3
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/startup.cpp:37 (discriminator 2)
    for (fnptr = __CTOR_LIST__; fnptr < __CTOR_END__; fnptr++)
    90e8:	e51b3008 	ldr	r3, [fp, #-8]
    90ec:	e2833004 	add	r3, r3, #4
    90f0:	e50b3008 	str	r3, [fp, #-8]
    90f4:	eafffff4 	b	90cc <_cpp_startup+0x14>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/startup.cpp:40

    return 0;
    90f8:	e3a03000 	mov	r3, #0
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/startup.cpp:41
}
    90fc:	e1a00003 	mov	r0, r3
    9100:	e24bd004 	sub	sp, fp, #4
    9104:	e8bd8800 	pop	{fp, pc}
    9108:	00009278 	andeq	r9, r0, r8, ror r2
    910c:	00009284 	andeq	r9, r0, r4, lsl #5

00009110 <_cpp_shutdown>:
_cpp_shutdown():
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/startup.cpp:44

extern "C" int _cpp_shutdown(void)
{
    9110:	e92d4800 	push	{fp, lr}
    9114:	e28db004 	add	fp, sp, #4
    9118:	e24dd008 	sub	sp, sp, #8
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/startup.cpp:48
    dtor_ptr* fnptr;

    // zavolame destruktory globalnich C++ trid
    for (fnptr = __DTOR_LIST__; fnptr < __DTOR_END__; fnptr++)
    911c:	e59f303c 	ldr	r3, [pc, #60]	; 9160 <_cpp_shutdown+0x50>
    9120:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/startup.cpp:48 (discriminator 3)
    9124:	e51b3008 	ldr	r3, [fp, #-8]
    9128:	e59f2034 	ldr	r2, [pc, #52]	; 9164 <_cpp_shutdown+0x54>
    912c:	e1530002 	cmp	r3, r2
    9130:	2a000006 	bcs	9150 <_cpp_shutdown+0x40>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/startup.cpp:49 (discriminator 2)
        (*fnptr)();
    9134:	e51b3008 	ldr	r3, [fp, #-8]
    9138:	e5933000 	ldr	r3, [r3]
    913c:	e12fff33 	blx	r3
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/startup.cpp:48 (discriminator 2)
    for (fnptr = __DTOR_LIST__; fnptr < __DTOR_END__; fnptr++)
    9140:	e51b3008 	ldr	r3, [fp, #-8]
    9144:	e2833004 	add	r3, r3, #4
    9148:	e50b3008 	str	r3, [fp, #-8]
    914c:	eafffff4 	b	9124 <_cpp_shutdown+0x14>
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/startup.cpp:51

    return 0;
    9150:	e3a03000 	mov	r3, #0
/home/silhavyj/School/ZeroMate/examples/10-timer_and_GPIO_interrupt/kernel/src/startup.cpp:52
}
    9154:	e1a00003 	mov	r0, r3
    9158:	e24bd004 	sub	sp, fp, #4
    915c:	e8bd8800 	pop	{fp, pc}
    9160:	00009284 	andeq	r9, r0, r4, lsl #5
    9164:	00009284 	andeq	r9, r0, r4, lsl #5

Disassembly of section .ARM.extab:

00009168 <.ARM.extab>:
    9168:	81019b40 	tsthi	r1, r0, asr #22
    916c:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    9170:	00000000 	andeq	r0, r0, r0
    9174:	81019b46 	tsthi	r1, r6, asr #22
    9178:	b10f8581 	smlabblt	pc, r1, r5, r8	; <UNPREDICTABLE>
    917c:	00000000 	andeq	r0, r0, r0
    9180:	81019b40 	tsthi	r1, r0, asr #22
    9184:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    9188:	00000000 	andeq	r0, r0, r0
    918c:	81019b40 	tsthi	r1, r0, asr #22
    9190:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    9194:	00000000 	andeq	r0, r0, r0
    9198:	81019b40 	tsthi	r1, r0, asr #22
    919c:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    91a0:	00000000 	andeq	r0, r0, r0
    91a4:	81019b40 	tsthi	r1, r0, asr #22
    91a8:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    91ac:	00000000 	andeq	r0, r0, r0

Disassembly of section .ARM.exidx:

000091b0 <.ARM.exidx>:
    91b0:	7fffeee4 	svcvc	0x00ffeee4
    91b4:	00000001 	andeq	r0, r0, r1
    91b8:	7ffff980 	svcvc	0x00fff980
    91bc:	7fffffac 	svcvc	0x00ffffac
    91c0:	7ffff9c8 	svcvc	0x00fff9c8
    91c4:	00000001 	andeq	r0, r0, r1
    91c8:	7ffffa88 	svcvc	0x00fffa88
    91cc:	7fffffa8 	svcvc	0x00ffffa8
    91d0:	7ffffb00 	svcvc	0x00fffb00
    91d4:	00000001 	andeq	r0, r0, r1
    91d8:	7ffffd3c 	svcvc	0x00fffd3c
    91dc:	7fffffa4 	svcvc	0x00ffffa4
    91e0:	7ffffda8 	svcvc	0x00fffda8
    91e4:	7fffffa8 	svcvc	0x00ffffa8
    91e8:	7ffffe48 	svcvc	0x00fffe48
    91ec:	00000001 	andeq	r0, r0, r1
    91f0:	7ffffec8 	svcvc	0x00fffec8
    91f4:	7fffffa4 	svcvc	0x00ffffa4
    91f8:	7fffff18 	svcvc	0x00ffff18
    91fc:	7fffffa8 	svcvc	0x00ffffa8
    9200:	7fffff68 	svcvc	0x00ffff68
    9204:	00000001 	andeq	r0, r0, r1

Disassembly of section .rodata:

00009208 <_ZN3halL18Default_Clock_RateE>:
    9208:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

0000920c <_ZN3halL15Peripheral_BaseE>:
    920c:	20000000 	andcs	r0, r0, r0

00009210 <_ZN3halL9GPIO_BaseE>:
    9210:	20200000 	eorcs	r0, r0, r0

00009214 <_ZN3halL14GPIO_Pin_CountE>:
    9214:	00000036 	andeq	r0, r0, r6, lsr r0

00009218 <_ZN3halL8AUX_BaseE>:
    9218:	20215000 	eorcs	r5, r1, r0

0000921c <_ZN3halL25Interrupt_Controller_BaseE>:
    921c:	2000b200 	andcs	fp, r0, r0, lsl #4

00009220 <_ZN3halL10Timer_BaseE>:
    9220:	2000b400 	andcs	fp, r0, r0, lsl #8

00009224 <_ZN3halL18Default_Clock_RateE>:
    9224:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

00009228 <_ZN3halL15Peripheral_BaseE>:
    9228:	20000000 	andcs	r0, r0, r0

0000922c <_ZN3halL9GPIO_BaseE>:
    922c:	20200000 	eorcs	r0, r0, r0

00009230 <_ZN3halL14GPIO_Pin_CountE>:
    9230:	00000036 	andeq	r0, r0, r6, lsr r0

00009234 <_ZN3halL8AUX_BaseE>:
    9234:	20215000 	eorcs	r5, r1, r0

00009238 <_ZN3halL25Interrupt_Controller_BaseE>:
    9238:	2000b200 	andcs	fp, r0, r0, lsl #4

0000923c <_ZN3halL10Timer_BaseE>:
    923c:	2000b400 	andcs	fp, r0, r0, lsl #8

00009240 <_ZN3halL18Default_Clock_RateE>:
    9240:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

00009244 <_ZN3halL15Peripheral_BaseE>:
    9244:	20000000 	andcs	r0, r0, r0

00009248 <_ZN3halL9GPIO_BaseE>:
    9248:	20200000 	eorcs	r0, r0, r0

0000924c <_ZN3halL14GPIO_Pin_CountE>:
    924c:	00000036 	andeq	r0, r0, r6, lsr r0

00009250 <_ZN3halL8AUX_BaseE>:
    9250:	20215000 	eorcs	r5, r1, r0

00009254 <_ZN3halL25Interrupt_Controller_BaseE>:
    9254:	2000b200 	andcs	fp, r0, r0, lsl #4

00009258 <_ZN3halL10Timer_BaseE>:
    9258:	2000b400 	andcs	fp, r0, r0, lsl #8

0000925c <_ZN3halL18Default_Clock_RateE>:
    925c:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

00009260 <_ZN3halL15Peripheral_BaseE>:
    9260:	20000000 	andcs	r0, r0, r0

00009264 <_ZN3halL9GPIO_BaseE>:
    9264:	20200000 	eorcs	r0, r0, r0

00009268 <_ZN3halL14GPIO_Pin_CountE>:
    9268:	00000036 	andeq	r0, r0, r6, lsr r0

0000926c <_ZN3halL8AUX_BaseE>:
    926c:	20215000 	eorcs	r5, r1, r0

00009270 <_ZN3halL25Interrupt_Controller_BaseE>:
    9270:	2000b200 	andcs	fp, r0, r0, lsl #4

00009274 <_ZN3halL10Timer_BaseE>:
    9274:	2000b400 	andcs	fp, r0, r0, lsl #8

Disassembly of section .data:

00009278 <__CTOR_LIST__>:
    9278:	0000898c 	andeq	r8, r0, ip, lsl #19
    927c:	00008c1c 	andeq	r8, r0, ip, lsl ip
    9280:	00008ef8 	strdeq	r8, [r0], -r8	; <UNPREDICTABLE>

00009284 <__DTOR_LIST__>:
__DTOR_END__():
    9284:	Address 0x0000000000009284 is out of bounds.


Disassembly of section .bss:

00009288 <sGPIO>:
    9288:	00000000 	andeq	r0, r0, r0

0000928c <sTimer>:
	...

00009294 <sInterruptCtl>:
    9294:	00000000 	andeq	r0, r0, r0

00009298 <LED_State>:
	...

Disassembly of section .debug_info:

00000000 <.debug_info>:
       0:	00000126 	andeq	r0, r0, r6, lsr #2
       4:	00000004 	andeq	r0, r0, r4
       8:	01040000 	mrseq	r0, (UNDEF: 4)
       c:	00000000 	andeq	r0, r0, r0
      10:	00014004 	andeq	r4, r1, r4
      14:	0000f600 	andeq	pc, r0, r0, lsl #12
      18:	00809400 	addeq	r9, r0, r0, lsl #8
      1c:	0000d800 	andeq	sp, r0, r0, lsl #16
      20:	00000000 	andeq	r0, r0, r0
      24:	01c90200 	biceq	r0, r9, r0, lsl #4
      28:	28010000 	stmdacs	r1, {}	; <UNPREDICTABLE>
      2c:	00816011 	addeq	r6, r1, r1, lsl r0
      30:	00000c00 	andeq	r0, r0, r0, lsl #24
      34:	029c0100 	addseq	r0, ip, #0, 2
      38:	000001b6 			; <UNDEFINED> instruction: 0x000001b6
      3c:	48112301 	ldmdami	r1, {r0, r8, r9, sp}
      40:	18000081 	stmdane	r0, {r0, r7}
      44:	01000000 	mrseq	r0, (UNDEF: 0)
      48:	00e9029c 	smlaleq	r0, r9, ip, r2
      4c:	1e010000 	cdpne	0, 0, cr0, cr1, cr0, {0}
      50:	00813011 	addeq	r3, r1, r1, lsl r0
      54:	00001800 	andeq	r1, r0, r0, lsl #16
      58:	029c0100 	addseq	r0, ip, #0, 2
      5c:	000000dc 	ldrdeq	r0, [r0], -ip
      60:	18111901 	ldmdane	r1, {r0, r8, fp, ip}
      64:	18000081 	stmdane	r0, {r0, r7}
      68:	01000000 	mrseq	r0, (UNDEF: 0)
      6c:	01ab039c 			; <UNDEFINED> instruction: 0x01ab039c
      70:	00020000 	andeq	r0, r2, r0
      74:	000000bb 	strheq	r0, [r0], -fp
      78:	0000ca04 	andeq	ip, r0, r4, lsl #20
      7c:	15140100 	ldrne	r0, [r4, #-256]	; 0xffffff00
      80:	0000008a 	andeq	r0, r0, sl, lsl #1
      84:	0000bb05 	andeq	fp, r0, r5, lsl #22
      88:	e0060000 	and	r0, r6, r0
      8c:	01000001 	tsteq	r0, r1
      90:	00c11f04 	sbceq	r1, r1, r4, lsl #30
      94:	b6040000 	strlt	r0, [r4], -r0
      98:	01000000 	mrseq	r0, (UNDEF: 0)
      9c:	00a8150f 	adceq	r1, r8, pc, lsl #10
      a0:	bb050000 	bllt	1400a8 <_bss_end+0x136dfc>
      a4:	00000000 	andeq	r0, r0, r0
      a8:	00019707 	andeq	r9, r1, r7, lsl #14
      ac:	140a0100 	strne	r0, [sl], #-256	; 0xffffff00
      b0:	00000105 	andeq	r0, r0, r5, lsl #2
      b4:	0000bb05 	andeq	fp, r0, r5, lsl #22
      b8:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
      bc:	00008a04 	andeq	r8, r0, r4, lsl #20
      c0:	05080900 	streq	r0, [r8, #-2304]	; 0xfffff700
      c4:	000001e8 	andeq	r0, r0, r8, ror #3
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
     11c:	0a010067 	beq	402c0 <_bss_end+0x37014>
     120:	0000bb31 	andeq	fp, r0, r1, lsr fp
     124:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     128:	099f0000 	ldmibeq	pc, {}	; <UNPREDICTABLE>
     12c:	00040000 	andeq	r0, r4, r0
     130:	000000d0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     134:	00000104 	andeq	r0, r0, r4, lsl #2
     138:	8a040000 	bhi	100140 <_bss_end+0xf6e94>
     13c:	f6000007 			; <UNDEFINED> instruction: 0xf6000007
     140:	6c000000 	stcvs	0, cr0, [r0], {-0}
     144:	3c000081 	stccc	0, cr0, [r0], {129}	; 0x81
     148:	b8000008 	stmdalt	r0, {r3}
     14c:	02000000 	andeq	r0, r0, #0
     150:	05490801 	strbeq	r0, [r9, #-2049]	; 0xfffff7ff
     154:	02020000 	andeq	r0, r2, #0
     158:	0002b705 	andeq	fp, r2, r5, lsl #14
     15c:	05040300 	streq	r0, [r4, #-768]	; 0xfffffd00
     160:	00746e69 	rsbseq	r6, r4, r9, ror #28
     164:	00039204 	andeq	r9, r3, r4, lsl #4
     168:	07090200 	streq	r0, [r9, -r0, lsl #4]
     16c:	00000046 	andeq	r0, r0, r6, asr #32
     170:	40080102 	andmi	r0, r8, r2, lsl #2
     174:	02000005 	andeq	r0, r0, #5
     178:	05a10702 	streq	r0, [r1, #1794]!	; 0x702
     17c:	a8040000 	stmdage	r4, {}	; <UNPREDICTABLE>
     180:	02000003 	andeq	r0, r0, #3
     184:	0065070b 	rsbeq	r0, r5, fp, lsl #14
     188:	54050000 	strpl	r0, [r5], #-0
     18c:	02000000 	andeq	r0, r0, #0
     190:	158c0704 	strne	r0, [ip, #1796]	; 0x704
     194:	65050000 	strvs	r0, [r5, #-0]
     198:	06000000 	streq	r0, [r0], -r0
     19c:	006c6168 	rsbeq	r6, ip, r8, ror #2
     1a0:	ac0b0703 	stcge	7, cr0, [fp], {3}
     1a4:	07000001 	streq	r0, [r0, -r1]
     1a8:	00000818 	andeq	r0, r0, r8, lsl r8
     1ac:	6c1c0903 			; <UNDEFINED> instruction: 0x6c1c0903
     1b0:	80000000 	andhi	r0, r0, r0
     1b4:	070ee6b2 			; <UNDEFINED> instruction: 0x070ee6b2
     1b8:	0000048f 	andeq	r0, r0, pc, lsl #9
     1bc:	b81d0c03 	ldmdalt	sp, {r0, r1, sl, fp}
     1c0:	00000001 	andeq	r0, r0, r1
     1c4:	07200000 	streq	r0, [r0, -r0]!
     1c8:	00000563 	andeq	r0, r0, r3, ror #10
     1cc:	b81d0f03 	ldmdalt	sp, {r0, r1, r8, r9, sl, fp}
     1d0:	00000001 	andeq	r0, r0, r1
     1d4:	08202000 	stmdaeq	r0!, {sp}
     1d8:	00000612 	andeq	r0, r0, r2, lsl r6
     1dc:	60181203 	andsvs	r1, r8, r3, lsl #4
     1e0:	36000000 	strcc	r0, [r0], -r0
     1e4:	00065b09 	andeq	r5, r6, r9, lsl #22
     1e8:	33040500 	movwcc	r0, #17664	; 0x4500
     1ec:	03000000 	movweq	r0, #0
     1f0:	017b1015 	cmneq	fp, r5, lsl r0
     1f4:	330a0000 	movwcc	r0, #40960	; 0xa000
     1f8:	00000002 	andeq	r0, r0, r2
     1fc:	00023b0a 	andeq	r3, r2, sl, lsl #22
     200:	430a0100 	movwmi	r0, #41216	; 0xa100
     204:	02000002 	andeq	r0, r0, #2
     208:	00024b0a 	andeq	r4, r2, sl, lsl #22
     20c:	530a0300 	movwpl	r0, #41728	; 0xa300
     210:	04000002 	streq	r0, [r0], #-2
     214:	00025b0a 	andeq	r5, r2, sl, lsl #22
     218:	250a0500 	strcs	r0, [sl, #-1280]	; 0xfffffb00
     21c:	07000002 	streq	r0, [r0, -r2]
     220:	00022c0a 	andeq	r2, r2, sl, lsl #24
     224:	3d0a0800 	stccc	8, cr0, [sl, #-0]
     228:	0a000008 	beq	250 <CPSR_IRQ_INHIBIT+0x1d0>
     22c:	00056d0a 	andeq	r6, r5, sl, lsl #26
     230:	f40a0b00 			; <UNDEFINED> instruction: 0xf40a0b00
     234:	0d000006 	stceq	0, cr0, [r0, #-24]	; 0xffffffe8
     238:	0006fb0a 	andeq	pc, r6, sl, lsl #22
     23c:	9a0a0e00 	bls	283a44 <_bss_end+0x27a798>
     240:	10000003 	andne	r0, r0, r3
     244:	0003a10a 	andeq	sl, r3, sl, lsl #2
     248:	150a1100 	strne	r1, [sl, #-256]	; 0xffffff00
     24c:	13000003 	movwne	r0, #3
     250:	00031c0a 	andeq	r1, r3, sl, lsl #24
     254:	780a1400 	stmdavc	sl, {sl, ip}
     258:	16000007 	strne	r0, [r0], -r7
     25c:	0002630a 	andeq	r6, r2, sl, lsl #6
     260:	840a1700 	strhi	r1, [sl], #-1792	; 0xfffff900
     264:	19000005 	stmdbne	r0, {r0, r2}
     268:	00058b0a 	andeq	r8, r5, sl, lsl #22
     26c:	d70a1a00 	strle	r1, [sl, -r0, lsl #20]
     270:	1c000003 	stcne	0, cr0, [r0], {3}
     274:	0005b40a 	andeq	fp, r5, sl, lsl #8
     278:	740a1d00 	strvc	r1, [sl], #-3328	; 0xfffff300
     27c:	1f000005 	svcne	0x00000005
     280:	00057c0a 	andeq	r7, r5, sl, lsl #24
     284:	010a2000 	mrseq	r2, (UNDEF: 10)
     288:	22000005 	andcs	r0, r0, #5
     28c:	0005090a 	andeq	r0, r5, sl, lsl #18
     290:	5e0a2300 	cdppl	3, 0, cr2, cr10, cr0, {0}
     294:	25000004 	strcs	r0, [r0, #-4]
     298:	0002c10a 	andeq	ip, r2, sl, lsl #2
     29c:	cb0a2600 	blgt	289aa4 <_bss_end+0x2807f8>
     2a0:	27000002 	strcs	r0, [r0, -r2]
     2a4:	07560700 	ldrbeq	r0, [r6, -r0, lsl #14]
     2a8:	44030000 	strmi	r0, [r3], #-0
     2ac:	0001b81d 	andeq	fp, r1, sp, lsl r8
     2b0:	21500000 	cmpcs	r0, r0
     2b4:	026a0720 	rsbeq	r0, sl, #32, 14	; 0x800000
     2b8:	73030000 	movwvc	r0, #12288	; 0x3000
     2bc:	0001b81d 	andeq	fp, r1, sp, lsl r8
     2c0:	00b20000 	adcseq	r0, r2, r0
     2c4:	06260720 	strteq	r0, [r6], -r0, lsr #14
     2c8:	a6030000 	strge	r0, [r3], -r0
     2cc:	0001b81d 	andeq	fp, r1, sp, lsl r8
     2d0:	00b40000 	adcseq	r0, r4, r0
     2d4:	7d0b0020 	stcvc	0, cr0, [fp, #-128]	; 0xffffff80
     2d8:	02000000 	andeq	r0, r0, #0
     2dc:	15870704 	strne	r0, [r7, #1796]	; 0x704
     2e0:	b1050000 	mrslt	r0, (UNDEF: 5)
     2e4:	0b000001 	bleq	2f0 <CPSR_IRQ_INHIBIT+0x270>
     2e8:	0000008d 	andeq	r0, r0, sp, lsl #1
     2ec:	00009d0b 	andeq	r9, r0, fp, lsl #26
     2f0:	00ad0b00 	adceq	r0, sp, r0, lsl #22
     2f4:	7b0b0000 	blvc	2c02fc <_bss_end+0x2b7050>
     2f8:	0b000001 	bleq	304 <CPSR_IRQ_INHIBIT+0x284>
     2fc:	0000018b 	andeq	r0, r0, fp, lsl #3
     300:	00019b0b 	andeq	r9, r1, fp, lsl #22
     304:	06d30900 	ldrbeq	r0, [r3], r0, lsl #18
     308:	01070000 	mrseq	r0, (UNDEF: 7)
     30c:	0000003a 	andeq	r0, r0, sl, lsr r0
     310:	240c0604 	strcs	r0, [ip], #-1540	; 0xfffff9fc
     314:	0a000002 	beq	324 <CPSR_IRQ_INHIBIT+0x2a4>
     318:	00000772 	andeq	r0, r0, r2, ror r7
     31c:	07830a00 	streq	r0, [r3, r0, lsl #20]
     320:	0a010000 	beq	40328 <_bss_end+0x3707c>
     324:	00000837 	andeq	r0, r0, r7, lsr r8
     328:	08310a02 	ldmdaeq	r1!, {r1, r9, fp}
     32c:	0a030000 	beq	c0334 <_bss_end+0xb7088>
     330:	0000080c 	andeq	r0, r0, ip, lsl #16
     334:	08120a04 	ldmdaeq	r2, {r2, r9, fp}
     338:	0a050000 	beq	140340 <_bss_end+0x137094>
     33c:	000006ee 	andeq	r0, r0, lr, ror #13
     340:	082b0a06 	stmdaeq	fp!, {r1, r2, r9, fp}
     344:	0a070000 	beq	1c034c <_bss_end+0x1b70a0>
     348:	000003b6 			; <UNDEFINED> instruction: 0x000003b6
     34c:	00090008 	andeq	r0, r9, r8
     350:	05000003 	streq	r0, [r0, #-3]
     354:	00003304 	andeq	r3, r0, r4, lsl #6
     358:	0c180400 	cfldrseq	mvf0, [r8], {-0}
     35c:	0000024f 	andeq	r0, r0, pc, asr #4
     360:	0006e20a 	andeq	lr, r6, sl, lsl #4
     364:	ff0a0000 			; <UNDEFINED> instruction: 0xff0a0000
     368:	01000007 	tsteq	r0, r7
     36c:	0002b20a 	andeq	fp, r2, sl, lsl #4
     370:	4c0c0200 	sfmmi	f0, 4, [ip], {-0}
     374:	0300776f 	movweq	r7, #1903	; 0x76f
     378:	043d0d00 	ldrteq	r0, [sp], #-3328	; 0xfffff300
     37c:	04040000 	streq	r0, [r4], #-0
     380:	047b0723 	ldrbteq	r0, [fp], #-1827	; 0xfffff8dd
     384:	750e0000 	strvc	r0, [lr, #-0]
     388:	04000003 	streq	r0, [r0], #-3
     38c:	04861927 	streq	r1, [r6], #2343	; 0x927
     390:	0f000000 	svceq	0x00000000
     394:	000005fe 	strdeq	r0, [r0], -lr
     398:	450a2b04 	strmi	r2, [sl, #-2820]	; 0xfffff4fc
     39c:	8b000003 	blhi	3b0 <CPSR_IRQ_INHIBIT+0x330>
     3a0:	02000004 	andeq	r0, r0, #4
     3a4:	00000282 	andeq	r0, r0, r2, lsl #5
     3a8:	00000297 	muleq	r0, r7, r2
     3ac:	00049210 	andeq	r9, r4, r0, lsl r2
     3b0:	00541100 	subseq	r1, r4, r0, lsl #2
     3b4:	9d110000 	ldcls	0, cr0, [r1, #-0]
     3b8:	11000004 	tstne	r0, r4
     3bc:	0000049d 	muleq	r0, sp, r4
     3c0:	075f0f00 	ldrbeq	r0, [pc, -r0, lsl #30]
     3c4:	2d040000 	stccs	0, cr0, [r4, #-0]
     3c8:	0005110a 	andeq	r1, r5, sl, lsl #2
     3cc:	00048b00 	andeq	r8, r4, r0, lsl #22
     3d0:	02b00200 	adcseq	r0, r0, #0, 4
     3d4:	02c50000 	sbceq	r0, r5, #0
     3d8:	92100000 	andsls	r0, r0, #0
     3dc:	11000004 	tstne	r0, r4
     3e0:	00000054 	andeq	r0, r0, r4, asr r0
     3e4:	00049d11 	andeq	r9, r4, r1, lsl sp
     3e8:	049d1100 	ldreq	r1, [sp], #256	; 0x100
     3ec:	0f000000 	svceq	0x00000000
     3f0:	0000044b 	andeq	r0, r0, fp, asr #8
     3f4:	270a2f04 	strcs	r2, [sl, -r4, lsl #30]
     3f8:	8b000007 	blhi	41c <CPSR_IRQ_INHIBIT+0x39c>
     3fc:	02000004 	andeq	r0, r0, #4
     400:	000002de 	ldrdeq	r0, [r0], -lr
     404:	000002f3 	strdeq	r0, [r0], -r3
     408:	00049210 	andeq	r9, r4, r0, lsl r2
     40c:	00541100 	subseq	r1, r4, r0, lsl #2
     410:	9d110000 	ldcls	0, cr0, [r1, #-0]
     414:	11000004 	tstne	r0, r4
     418:	0000049d 	muleq	r0, sp, r4
     41c:	049f0f00 	ldreq	r0, [pc], #3840	; 424 <CPSR_IRQ_INHIBIT+0x3a4>
     420:	31040000 	mrscc	r0, (UNDEF: 4)
     424:	0001f60a 	andeq	pc, r1, sl, lsl #12
     428:	00048b00 	andeq	r8, r4, r0, lsl #22
     42c:	030c0200 	movweq	r0, #49664	; 0xc200
     430:	03210000 			; <UNDEFINED> instruction: 0x03210000
     434:	92100000 	andsls	r0, r0, #0
     438:	11000004 	tstne	r0, r4
     43c:	00000054 	andeq	r0, r0, r4, asr r0
     440:	00049d11 	andeq	r9, r4, r1, lsl sp
     444:	049d1100 	ldreq	r1, [sp], #256	; 0x100
     448:	0f000000 	svceq	0x00000000
     44c:	0000029f 	muleq	r0, pc, r2	; <UNPREDICTABLE>
     450:	cf0a3204 	svcgt	0x000a3204
     454:	8b000005 	blhi	470 <CPSR_IRQ_INHIBIT+0x3f0>
     458:	02000004 	andeq	r0, r0, #4
     45c:	0000033a 	andeq	r0, r0, sl, lsr r3
     460:	0000034f 	andeq	r0, r0, pc, asr #6
     464:	00049210 	andeq	r9, r4, r0, lsl r2
     468:	00541100 	subseq	r1, r4, r0, lsl #2
     46c:	9d110000 	ldcls	0, cr0, [r1, #-0]
     470:	11000004 	tstne	r0, r4
     474:	0000049d 	muleq	r0, sp, r4
     478:	043d0f00 	ldrteq	r0, [sp], #-3840	; 0xfffff100
     47c:	35040000 	strcc	r0, [r4, #-0]
     480:	00037b05 	andeq	r7, r3, r5, lsl #22
     484:	0004a300 	andeq	sl, r4, r0, lsl #6
     488:	03680100 	cmneq	r8, #0, 2
     48c:	03730000 	cmneq	r3, #0
     490:	a3100000 	tstge	r0, #0
     494:	11000004 	tstne	r0, r4
     498:	00000065 	andeq	r0, r0, r5, rrx
     49c:	07021200 	streq	r1, [r2, -r0, lsl #4]
     4a0:	38040000 	stmdacc	r4, {}	; <UNPREDICTABLE>
     4a4:	0006aa0a 	andeq	sl, r6, sl, lsl #20
     4a8:	03880100 	orreq	r0, r8, #0, 2
     4ac:	03980000 	orrseq	r0, r8, #0
     4b0:	a3100000 	tstge	r0, #0
     4b4:	11000004 	tstne	r0, r4
     4b8:	00000054 	andeq	r0, r0, r4, asr r0
     4bc:	0001db11 	andeq	sp, r1, r1, lsl fp
     4c0:	2b0f0000 	blcs	3c04c8 <_bss_end+0x3b721c>
     4c4:	04000004 	streq	r0, [r0], #-4
     4c8:	04b2143a 	ldrteq	r1, [r2], #1082	; 0x43a
     4cc:	01db0000 	bicseq	r0, fp, r0
     4d0:	b1010000 	mrslt	r0, (UNDEF: 1)
     4d4:	bc000003 	stclt	0, cr0, [r0], {3}
     4d8:	10000003 	andne	r0, r0, r3
     4dc:	00000492 	muleq	r0, r2, r4
     4e0:	00005411 	andeq	r5, r0, r1, lsl r4
     4e4:	7f120000 	svcvc	0x00120000
     4e8:	04000007 	streq	r0, [r0], #-7
     4ec:	03230a3d 			; <UNDEFINED> instruction: 0x03230a3d
     4f0:	d1010000 	mrsle	r0, (UNDEF: 1)
     4f4:	e1000003 	tst	r0, r3
     4f8:	10000003 	andne	r0, r0, r3
     4fc:	000004a3 	andeq	r0, r0, r3, lsr #9
     500:	00005411 	andeq	r5, r0, r1, lsl r4
     504:	048b1100 	streq	r1, [fp], #256	; 0x100
     508:	12000000 	andne	r0, r0, #0
     50c:	000003c2 	andeq	r0, r0, r2, asr #7
     510:	640a3f04 	strvs	r3, [sl], #-3844	; 0xfffff0fc
     514:	01000004 	tsteq	r0, r4
     518:	000003f6 	strdeq	r0, [r0], -r6
     51c:	00000401 	andeq	r0, r0, r1, lsl #8
     520:	0004a310 	andeq	sl, r4, r0, lsl r3
     524:	00541100 	subseq	r1, r4, r0, lsl #2
     528:	12000000 	andne	r0, r0, #0
     52c:	000005bb 			; <UNDEFINED> instruction: 0x000005bb
     530:	d50a4104 	strle	r4, [sl, #-260]	; 0xfffffefc
     534:	01000002 	tsteq	r0, r2
     538:	00000416 	andeq	r0, r0, r6, lsl r4
     53c:	00000426 	andeq	r0, r0, r6, lsr #8
     540:	0004a310 	andeq	sl, r4, r0, lsl r3
     544:	00541100 	subseq	r1, r4, r0, lsl #2
     548:	24110000 	ldrcs	r0, [r1], #-0
     54c:	00000002 	andeq	r0, r0, r2
     550:	0007ea12 	andeq	lr, r7, r2, lsl sl
     554:	0a420400 	beq	108155c <_bss_end+0x10782b0>
     558:	00000669 	andeq	r0, r0, r9, ror #12
     55c:	00043b01 	andeq	r3, r4, r1, lsl #22
     560:	00044b00 	andeq	r4, r4, r0, lsl #22
     564:	04a31000 	strteq	r1, [r3], #0
     568:	54110000 	ldrpl	r0, [r1], #-0
     56c:	11000000 	mrsne	r0, (UNDEF: 0)
     570:	00000224 	andeq	r0, r0, r4, lsr #4
     574:	02841300 	addeq	r1, r4, #0, 6
     578:	43040000 	movwmi	r0, #16384	; 0x4000
     57c:	0003de0a 	andeq	sp, r3, sl, lsl #28
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
     5b8:	000003b1 			; <UNDEFINED> instruction: 0x000003b1
     5bc:	047b0414 	ldrbteq	r0, [fp], #-1044	; 0xfffffbec
     5c0:	92050000 	andls	r0, r5, #0
     5c4:	15000004 	strne	r0, [r0, #-4]
     5c8:	00005404 	andeq	r5, r0, r4, lsl #8
     5cc:	4f041400 	svcmi	0x00041400
     5d0:	05000002 	streq	r0, [r0, #-2]
     5d4:	000004a3 	andeq	r0, r0, r3, lsr #9
     5d8:	00055d16 	andeq	r5, r5, r6, lsl sp
     5dc:	16470400 	strbne	r0, [r7], -r0, lsl #8
     5e0:	0000024f 	andeq	r0, r0, pc, asr #4
     5e4:	0004ae17 	andeq	sl, r4, r7, lsl lr
     5e8:	0f040100 	svceq	0x00040100
     5ec:	92880305 	addls	r0, r8, #335544320	; 0x14000000
     5f0:	4e180000 	cdpmi	0, 1, cr0, cr8, cr0, {0}
     5f4:	8c000005 	stchi	0, cr0, [r0], {5}
     5f8:	1c000089 	stcne	0, cr0, [r0], {137}	; 0x89
     5fc:	01000000 	mrseq	r0, (UNDEF: 0)
     600:	0631199c 			; <UNDEFINED> instruction: 0x0631199c
     604:	89380000 	ldmdbhi	r8!, {}	; <UNPREDICTABLE>
     608:	00540000 	subseq	r0, r4, r0
     60c:	9c010000 	stcls	0, cr0, [r1], {-0}
     610:	00000509 	andeq	r0, r0, r9, lsl #10
     614:	0004db1a 	andeq	sp, r4, sl, lsl fp
     618:	01b10100 			; <UNDEFINED> instruction: 0x01b10100
     61c:	00000033 	andeq	r0, r0, r3, lsr r0
     620:	1a749102 	bne	1d24a30 <_bss_end+0x1d1b784>
     624:	0000071c 	andeq	r0, r0, ip, lsl r7
     628:	3301b101 	movwcc	fp, #4353	; 0x1101
     62c:	02000000 	andeq	r0, r0, #0
     630:	1b007091 	blne	1c87c <_bss_end+0x135d0>
     634:	000003e1 	andeq	r0, r0, r1, ror #7
     638:	2306a901 	movwcs	sl, #26881	; 0x6901
     63c:	c4000005 	strgt	r0, [r0], #-5
     640:	74000088 	strvc	r0, [r0], #-136	; 0xffffff78
     644:	01000000 	mrseq	r0, (UNDEF: 0)
     648:	00055d9c 	muleq	r5, ip, sp
     64c:	06641c00 	strbteq	r1, [r4], -r0, lsl #24
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
     6a0:	06641c00 	strbteq	r1, [r4], -r0, lsl #24
     6a4:	04980000 	ldreq	r0, [r8], #0
     6a8:	91020000 	mrsls	r0, (UNDEF: 2)
     6ac:	69701d74 	ldmdbvs	r0!, {r2, r4, r5, r6, r8, sl, fp, ip}^
     6b0:	9e01006e 	cdpls	0, 0, cr0, cr1, cr14, {3}
     6b4:	00005431 	andeq	r5, r0, r1, lsr r4
     6b8:	70910200 	addsvc	r0, r1, r0, lsl #4
     6bc:	6765721d 			; <UNDEFINED> instruction: 0x6765721d
     6c0:	409e0100 	addsmi	r0, lr, r0, lsl #2
     6c4:	0000049d 	muleq	r0, sp, r4
     6c8:	1a6c9102 	bne	1b24ad8 <_bss_end+0x1b1b82c>
     6cc:	00000714 	andeq	r0, r0, r4, lsl r7
     6d0:	9d4f9e01 	stclls	14, cr9, [pc, #-4]	; 6d4 <CPSR_IRQ_INHIBIT+0x654>
     6d4:	02000004 	andeq	r0, r0, #4
     6d8:	1b006891 	blne	1a924 <_bss_end+0x11678>
     6dc:	000003bc 			; <UNDEFINED> instruction: 0x000003bc
     6e0:	cb069501 	blgt	1a5aec <_bss_end+0x19c840>
     6e4:	78000005 	stmdavc	r0, {r0, r2}
     6e8:	d8000087 	stmdale	r0, {r0, r1, r2, r7}
     6ec:	01000000 	mrseq	r0, (UNDEF: 0)
     6f0:	0006149c 	muleq	r6, ip, r4
     6f4:	06641c00 	strbteq	r1, [r4], -r0, lsl #24
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
     758:	0006641c 	andeq	r6, r6, ip, lsl r4
     75c:	0004a900 	andeq	sl, r4, r0, lsl #18
     760:	64910200 	ldrvs	r0, [r1], #512	; 0x200
     764:	6e69701d 	mcrvs	0, 3, r7, cr9, cr13, {0}
     768:	338a0100 	orrcc	r0, sl, #0, 2
     76c:	00000054 	andeq	r0, r0, r4, asr r0
     770:	1a609102 	bne	1824b80 <_bss_end+0x181b8d4>
     774:	00001fcb 	andeq	r1, r0, fp, asr #31
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
     7c8:	641c0000 	ldrvs	r0, [ip], #-0
     7cc:	98000006 	stmdals	r0, {r1, r2}
     7d0:	02000004 	andeq	r0, r0, #4
     7d4:	701d7491 	mulsvc	sp, r1, r4
     7d8:	01006e69 	tsteq	r0, r9, ror #28
     7dc:	0054396e 	subseq	r3, r4, lr, ror #18
     7e0:	91020000 	mrsls	r0, (UNDEF: 2)
     7e4:	1fcb1a70 	svcne	0x00cb1a70
     7e8:	6e010000 	cdpvs	0, 0, cr0, cr1, cr0, {0}
     7ec:	00022453 	andeq	r2, r2, r3, asr r4
     7f0:	6c910200 	lfmvs	f0, 4, [r1], {0}
     7f4:	6765721d 			; <UNDEFINED> instruction: 0x6765721d
     7f8:	636e0100 	cmnvs	lr, #0, 2
     7fc:	0000049d 	muleq	r0, sp, r4
     800:	1a689102 	bne	1a24c10 <_bss_end+0x1a1b964>
     804:	00000714 	andeq	r0, r0, r4, lsl r7
     808:	9d726e01 	ldclls	14, cr6, [r2, #-4]!
     80c:	02000004 	andeq	r0, r0, #4
     810:	1b000091 	blne	a5c <CPSR_IRQ_INHIBIT+0x9dc>
     814:	00000401 	andeq	r0, r0, r1, lsl #8
     818:	03065f01 	movweq	r5, #28417	; 0x6f01
     81c:	34000007 	strcc	r0, [r0], #-7
     820:	84000085 	strhi	r0, [r0], #-133	; 0xffffff7b
     824:	01000000 	mrseq	r0, (UNDEF: 0)
     828:	00074c9c 	muleq	r7, ip, ip
     82c:	06641c00 	strbteq	r1, [r4], -r0, lsl #24
     830:	04a90000 	strteq	r0, [r9], #0
     834:	91020000 	mrsls	r0, (UNDEF: 2)
     838:	69701d6c 	ldmdbvs	r0!, {r2, r3, r5, r6, r8, sl, fp, ip}^
     83c:	5f01006e 	svcpl	0x0001006e
     840:	00005432 	andeq	r5, r0, r2, lsr r4
     844:	68910200 	ldmvs	r1, {r9}
     848:	001fcb1a 	andseq	ip, pc, sl, lsl fp	; <UNPREDICTABLE>
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
     890:	0006641c 	andeq	r6, r6, ip, lsl r4
     894:	00049800 	andeq	r9, r4, r0, lsl #16
     898:	6c910200 	lfmvs	f0, 4, [r1], {0}
     89c:	6e69701d 	mcrvs	0, 3, r7, cr9, cr13, {0}
     8a0:	3a560100 	bcc	1580ca8 <_bss_end+0x15779fc>
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
     8e4:	0006641c 	andeq	r6, r6, ip, lsl r4
     8e8:	0004a900 	andeq	sl, r4, r0, lsl #18
     8ec:	6c910200 	lfmvs	f0, 4, [r1], {0}
     8f0:	6e69701d 	mcrvs	0, 3, r7, cr9, cr13, {0}
     8f4:	304d0100 	subcc	r0, sp, r0, lsl #2
     8f8:	00000054 	andeq	r0, r0, r4, asr r0
     8fc:	1a689102 	bne	1a24d0c <_bss_end+0x1a1ba60>
     900:	00000621 	andeq	r0, r0, r1, lsr #12
     904:	db444d01 	blle	1113d10 <_bss_end+0x110aa64>
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
     948:	00000664 	andeq	r0, r0, r4, ror #12
     94c:	00000498 	muleq	r0, r8, r4
     950:	1d749102 	ldfnep	f1, [r4, #-8]!
     954:	006e6970 	rsbeq	r6, lr, r0, ror r9
     958:	54314201 	ldrtpl	r4, [r1], #-513	; 0xfffffdff
     95c:	02000000 	andeq	r0, r0, #0
     960:	721d7091 	andsvc	r7, sp, #145	; 0x91
     964:	01006765 	tsteq	r0, r5, ror #14
     968:	049d4042 	ldreq	r4, [sp], #66	; 0x42
     96c:	91020000 	mrsls	r0, (UNDEF: 2)
     970:	07141a6c 	ldreq	r1, [r4, -ip, ror #20]
     974:	42010000 	andmi	r0, r1, #0
     978:	00049d4f 	andeq	r9, r4, pc, asr #26
     97c:	68910200 	ldmvs	r1, {r9}
     980:	02c51f00 	sbceq	r1, r5, #0, 30
     984:	37010000 	strcc	r0, [r1, -r0]
     988:	00087106 	andeq	r7, r8, r6, lsl #2
     98c:	00832800 	addeq	r2, r3, r0, lsl #16
     990:	00007400 	andeq	r7, r0, r0, lsl #8
     994:	ab9c0100 	blge	fe700d9c <_bss_end+0xfe6f7af0>
     998:	1c000008 	stcne	0, cr0, [r0], {8}
     99c:	00000664 	andeq	r0, r0, r4, ror #12
     9a0:	00000498 	muleq	r0, r8, r4
     9a4:	1d749102 	ldfnep	f1, [r4, #-8]!
     9a8:	006e6970 	rsbeq	r6, lr, r0, ror r9
     9ac:	54313701 	ldrtpl	r3, [r1], #-1793	; 0xfffff8ff
     9b0:	02000000 	andeq	r0, r0, #0
     9b4:	721d7091 	andsvc	r7, sp, #145	; 0x91
     9b8:	01006765 	tsteq	r0, r5, ror #14
     9bc:	049d4037 	ldreq	r4, [sp], #55	; 0x37
     9c0:	91020000 	mrsls	r0, (UNDEF: 2)
     9c4:	07141a6c 	ldreq	r1, [r4, -ip, ror #20]
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
     9f0:	00000664 	andeq	r0, r0, r4, ror #12
     9f4:	00000498 	muleq	r0, r8, r4
     9f8:	1d749102 	ldfnep	f1, [r4, #-8]!
     9fc:	006e6970 	rsbeq	r6, lr, r0, ror r9
     a00:	54312c01 	ldrtpl	r2, [r1], #-3073	; 0xfffff3ff
     a04:	02000000 	andeq	r0, r0, #0
     a08:	721d7091 	andsvc	r7, sp, #145	; 0x91
     a0c:	01006765 	tsteq	r0, r5, ror #14
     a10:	049d402c 	ldreq	r4, [sp], #44	; 0x2c
     a14:	91020000 	mrsls	r0, (UNDEF: 2)
     a18:	07141a6c 	ldreq	r1, [r4, -ip, ror #20]
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
     a44:	00000664 	andeq	r0, r0, r4, ror #12
     a48:	00000498 	muleq	r0, r8, r4
     a4c:	1d749102 	ldfnep	f1, [r4, #-8]!
     a50:	006e6970 	rsbeq	r6, lr, r0, ror r9
     a54:	54320c01 	ldrtpl	r0, [r2], #-3073	; 0xfffff3ff
     a58:	02000000 	andeq	r0, r0, #0
     a5c:	721d7091 	andsvc	r7, sp, #145	; 0x91
     a60:	01006765 	tsteq	r0, r5, ror #14
     a64:	049d410c 	ldreq	r4, [sp], #268	; 0x10c
     a68:	91020000 	mrsls	r0, (UNDEF: 2)
     a6c:	07141a6c 	ldreq	r1, [r4, -ip, ror #20]
     a70:	0c010000 	stceq	0, cr0, [r1], {-0}
     a74:	00049d50 	andeq	r9, r4, r0, asr sp
     a78:	68910200 	ldmvs	r1, {r9}
     a7c:	034f2000 	movteq	r2, #61440	; 0xf000
     a80:	06010000 	streq	r0, [r1], -r0
     a84:	00096401 	andeq	r6, r9, r1, lsl #8
     a88:	097a0000 	ldmdbeq	sl!, {}^	; <UNPREDICTABLE>
     a8c:	64210000 	strtvs	r0, [r1], #-0
     a90:	a9000006 	stmdbge	r0, {r1, r2}
     a94:	22000004 	andcs	r0, r0, #4
     a98:	00000592 	muleq	r0, r2, r5
     a9c:	652b0601 	strvs	r0, [fp, #-1537]!	; 0xfffff9ff
     aa0:	00000000 	andeq	r0, r0, r0
     aa4:	00095323 	andeq	r5, r9, r3, lsr #6
     aa8:	0004ea00 	andeq	lr, r4, r0, lsl #20
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
     adc:	09970400 	ldmibeq	r7, {sl}
     ae0:	00f60000 	rscseq	r0, r6, r0
     ae4:	89a80000 	stmibhi	r8!, {}	; <UNPREDICTABLE>
     ae8:	02900000 	addseq	r0, r0, #0
     aec:	04f90000 	ldrbteq	r0, [r9], #0
     af0:	01020000 	mrseq	r0, (UNDEF: 2)
     af4:	00054908 	andeq	r4, r5, r8, lsl #18
     af8:	05020200 	streq	r0, [r2, #-512]	; 0xfffffe00
     afc:	000002b7 			; <UNDEFINED> instruction: 0x000002b7
     b00:	69050403 	stmdbvs	r5, {r0, r1, sl}
     b04:	0400746e 	streq	r7, [r0], #-1134	; 0xfffffb92
     b08:	00000392 	muleq	r0, r2, r3
     b0c:	46070902 	strmi	r0, [r7], -r2, lsl #18
     b10:	02000000 	andeq	r0, r0, #0
     b14:	05400801 	strbeq	r0, [r0, #-2049]	; 0xfffff7ff
     b18:	0a040000 	beq	100b20 <_bss_end+0xf7874>
     b1c:	0200000a 	andeq	r0, r0, #10
     b20:	0059070a 	subseq	r0, r9, sl, lsl #14
     b24:	02020000 	andeq	r0, r2, #0
     b28:	0005a107 	andeq	sl, r5, r7, lsl #2
     b2c:	03a80400 			; <UNDEFINED> instruction: 0x03a80400
     b30:	0b020000 	bleq	80b38 <_bss_end+0x7788c>
     b34:	00007107 	andeq	r7, r0, r7, lsl #2
     b38:	00600500 	rsbeq	r0, r0, r0, lsl #10
     b3c:	04020000 	streq	r0, [r2], #-0
     b40:	00158c07 	andseq	r8, r5, r7, lsl #24
     b44:	00710500 	rsbseq	r0, r1, r0, lsl #10
     b48:	71060000 	mrsvc	r0, (UNDEF: 6)
     b4c:	07000000 	streq	r0, [r0, -r0]
     b50:	006c6168 	rsbeq	r6, ip, r8, ror #2
     b54:	410b0703 	tstmi	fp, r3, lsl #14
     b58:	08000001 	stmdaeq	r0, {r0}
     b5c:	00000818 	andeq	r0, r0, r8, lsl r8
     b60:	781c0903 	ldmdavc	ip, {r0, r1, r8, fp}
     b64:	80000000 	andhi	r0, r0, r0
     b68:	080ee6b2 	stmdaeq	lr, {r1, r4, r5, r7, r9, sl, sp, lr, pc}
     b6c:	0000048f 	andeq	r0, r0, pc, lsl #9
     b70:	4d1d0c03 	ldcmi	12, cr0, [sp, #-12]
     b74:	00000001 	andeq	r0, r0, r1
     b78:	08200000 	stmdaeq	r0!, {}	; <UNPREDICTABLE>
     b7c:	00000563 	andeq	r0, r0, r3, ror #10
     b80:	4d1d0f03 	ldcmi	15, cr0, [sp, #-12]
     b84:	00000001 	andeq	r0, r0, r1
     b88:	09202000 	stmdbeq	r0!, {sp}
     b8c:	00000612 	andeq	r0, r0, r2, lsl r6
     b90:	6c181203 	lfmvs	f1, 4, [r8], {3}
     b94:	36000000 	strcc	r0, [r0], -r0
     b98:	00075608 	andeq	r5, r7, r8, lsl #12
     b9c:	1d440300 	stclne	3, cr0, [r4, #-0]
     ba0:	0000014d 	andeq	r0, r0, sp, asr #2
     ba4:	20215000 	eorcs	r5, r1, r0
     ba8:	00026a08 	andeq	r6, r2, r8, lsl #20
     bac:	1d730300 	ldclne	3, cr0, [r3, #-0]
     bb0:	0000014d 	andeq	r0, r0, sp, asr #2
     bb4:	2000b200 	andcs	fp, r0, r0, lsl #4
     bb8:	00062608 	andeq	r2, r6, r8, lsl #12
     bbc:	1da60300 	stcne	3, cr0, [r6]
     bc0:	0000014d 	andeq	r0, r0, sp, asr #2
     bc4:	2000b400 	andcs	fp, r0, r0, lsl #8
     bc8:	000a1f0a 	andeq	r1, sl, sl, lsl #30
     bcc:	33040500 	movwcc	r0, #17664	; 0x4500
     bd0:	03000000 	movweq	r0, #0
     bd4:	6c0b10a8 	stcvs	0, cr1, [fp], {168}	; 0xa8
     bd8:	0000000a 	andeq	r0, r0, sl
     bdc:	0009910b 	andeq	r9, r9, fp, lsl #2
     be0:	4c0b0100 	stfmis	f0, [fp], {-0}
     be4:	0200000e 	andeq	r0, r0, #14
     be8:	00096e0b 	andeq	r6, r9, fp, lsl #28
     bec:	e40b0300 	str	r0, [fp], #-768	; 0xfffffd00
     bf0:	0400000a 	streq	r0, [r0], #-10
     bf4:	0008b40b 	andeq	fp, r8, fp, lsl #8
     bf8:	a00b0500 	andge	r0, fp, r0, lsl #10
     bfc:	06000008 	streq	r0, [r0], -r8
     c00:	000a130b 	andeq	r1, sl, fp, lsl #6
     c04:	b20b0700 	andlt	r0, fp, #0, 14
     c08:	0800000a 	stmdaeq	r0, {r1, r3}
     c0c:	8e0c0000 	cdphi	0, 0, cr0, cr12, cr0, {0}
     c10:	02000000 	andeq	r0, r0, #0
     c14:	15870704 	strne	r0, [r7, #1796]	; 0x704
     c18:	46050000 	strmi	r0, [r5], -r0
     c1c:	0c000001 	stceq	0, cr0, [r0], {1}
     c20:	0000009e 	muleq	r0, lr, r0
     c24:	0000ae0c 	andeq	sl, r0, ip, lsl #28
     c28:	00be0c00 	adcseq	r0, lr, r0, lsl #24
     c2c:	cb0c0000 	blgt	300c34 <_bss_end+0x2f7988>
     c30:	0c000000 	stceq	0, cr0, [r0], {-0}
     c34:	000000db 	ldrdeq	r0, [r0], -fp
     c38:	0000eb0c 	andeq	lr, r0, ip, lsl #22
     c3c:	09260d00 	stmdbeq	r6!, {r8, sl, fp}
     c40:	01070000 	mrseq	r0, (UNDEF: 7)
     c44:	0000003a 	andeq	r0, r0, sl, lsr r0
     c48:	950c0604 	strls	r0, [ip, #-1540]	; 0xfffff9fc
     c4c:	0b000001 	bleq	c58 <CPSR_IRQ_INHIBIT+0xbd8>
     c50:	0000094e 	andeq	r0, r0, lr, asr #18
     c54:	09780b00 	ldmdbeq	r8!, {r8, r9, fp}^
     c58:	0b010000 	bleq	40c60 <_bss_end+0x379b4>
     c5c:	000008fe 	strdeq	r0, [r0], -lr
     c60:	710e0002 	tstvc	lr, r2
     c64:	0800000a 	stmdaeq	r0, {r1, r3}
     c68:	8d070d04 	stchi	13, cr0, [r7, #-16]
     c6c:	0f000002 	svceq	0x00000002
     c70:	00000985 	andeq	r0, r0, r5, lsl #19
     c74:	8d1c1504 	cfldr32hi	mvfx1, [ip, #-16]
     c78:	00000002 	andeq	r0, r0, r2
     c7c:	000ad410 	andeq	sp, sl, r0, lsl r4
     c80:	0b110400 	bleq	441c88 <_bss_end+0x4389dc>
     c84:	00000293 	muleq	r0, r3, r2
     c88:	0a780f01 	beq	1e04894 <_bss_end+0x1dfb5e8>
     c8c:	18040000 	stmdane	r4, {}	; <UNPREDICTABLE>
     c90:	0001af15 	andeq	sl, r1, r5, lsl pc
     c94:	8c110400 	cfldrshi	mvf0, [r1], {-0}
     c98:	04000009 	streq	r0, [r0], #-9
     c9c:	0a821c1b 	beq	fe087d10 <_bss_end+0xfe07ea64>
     ca0:	029a0000 	addseq	r0, sl, #0
     ca4:	e2020000 	and	r0, r2, #0
     ca8:	ed000001 	stc	0, cr0, [r0, #-4]
     cac:	12000001 	andne	r0, r0, #1
     cb0:	000002a0 	andeq	r0, r0, r0, lsr #5
     cb4:	0000fb13 	andeq	pc, r0, r3, lsl fp	; <UNPREDICTABLE>
     cb8:	71110000 	tstvc	r1, r0
     cbc:	0400000a 	streq	r0, [r0], #-10
     cc0:	0aa3051e 	beq	fe8c2140 <_bss_end+0xfe8b8e94>
     cc4:	02a00000 	adceq	r0, r0, #0
     cc8:	06010000 	streq	r0, [r1], -r0
     ccc:	11000002 	tstne	r0, r2
     cd0:	12000002 	andne	r0, r0, #2
     cd4:	000002a0 	andeq	r0, r0, r0, lsr #5
     cd8:	00014613 	andeq	r4, r1, r3, lsl r6
     cdc:	94140000 	ldrls	r0, [r4], #-0
     ce0:	0400000e 	streq	r0, [r0], #-14
     ce4:	090c0a21 	stmdbeq	ip, {r0, r5, r9, fp}
     ce8:	26010000 	strcs	r0, [r1], -r0
     cec:	3b000002 	blcc	cfc <CPSR_IRQ_INHIBIT+0xc7c>
     cf0:	12000002 	andne	r0, r0, #2
     cf4:	000002a0 	andeq	r0, r0, r0, lsr #5
     cf8:	0001af13 	andeq	sl, r1, r3, lsl pc
     cfc:	00711300 	rsbseq	r1, r1, r0, lsl #6
     d00:	70130000 	andsvc	r0, r3, r0
     d04:	00000001 	andeq	r0, r0, r1
     d08:	000d0914 	andeq	r0, sp, r4, lsl r9
     d0c:	0a230400 	beq	8c1d14 <_bss_end+0x8b8a68>
     d10:	00000a29 	andeq	r0, r0, r9, lsr #20
     d14:	00025001 	andeq	r5, r2, r1
     d18:	00025600 	andeq	r5, r2, r0, lsl #12
     d1c:	02a01200 	adceq	r1, r0, #0, 4
     d20:	14000000 	strne	r0, [r0], #-0
     d24:	000008a7 	andeq	r0, r0, r7, lsr #17
     d28:	ec0a2604 	stc	6, cr2, [sl], {4}
     d2c:	0100000a 	tsteq	r0, sl
     d30:	0000026b 	andeq	r0, r0, fp, ror #4
     d34:	00000271 	andeq	r0, r0, r1, ror r2
     d38:	0002a012 	andeq	sl, r2, r2, lsl r0
     d3c:	bf150000 	svclt	0x00150000
     d40:	0400000a 	streq	r0, [r0], #-10
     d44:	085a0a28 	ldmdaeq	sl, {r3, r5, r9, fp}^
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
     d78:	b1020102 	tstlt	r2, r2, lsl #2
     d7c:	19000003 	stmdbne	r0, {r0, r1}
     d80:	00000853 	andeq	r0, r0, r3, asr r8
     d84:	950f2b04 	strls	r2, [pc, #-2820]	; 288 <CPSR_IRQ_INHIBIT+0x208>
     d88:	1a000001 	bne	d94 <CPSR_IRQ_INHIBIT+0xd14>
     d8c:	000002b2 			; <UNDEFINED> instruction: 0x000002b2
     d90:	05080401 	streq	r0, [r8, #-1025]	; 0xfffffbff
     d94:	00928c03 	addseq	r8, r2, r3, lsl #24
     d98:	0a5b1b00 	beq	16c79a0 <_bss_end+0x16be6f4>
     d9c:	01060000 	mrseq	r0, (UNDEF: 6)
     da0:	039a0808 	orrseq	r0, sl, #8, 16	; 0x80000
     da4:	c51c0000 	ldrgt	r0, [ip, #-0]
     da8:	01000008 	tsteq	r0, r8
     dac:	003a0d0a 	eorseq	r0, sl, sl, lsl #26
     db0:	01010000 	mrseq	r0, (UNDEF: 1)
     db4:	f21c0007 	vhadd.s16	d0, d12, d7
     db8:	01000008 	tsteq	r0, r8
     dbc:	003a0d0b 	eorseq	r0, sl, fp, lsl #26
     dc0:	01010000 	mrseq	r0, (UNDEF: 1)
     dc4:	441c0006 	ldrmi	r0, [ip], #-6
     dc8:	01000009 	tsteq	r0, r9
     dcc:	003a0d0c 	eorseq	r0, sl, ip, lsl #26
     dd0:	02010000 	andeq	r0, r1, #0
     dd4:	ce1c0004 	cdpgt	0, 1, cr0, cr12, cr4, {0}
     dd8:	01000008 	tsteq	r0, r8
     ddc:	003a0d0d 	eorseq	r0, sl, sp, lsl #26
     de0:	01010000 	mrseq	r0, (UNDEF: 1)
     de4:	f81c0003 			; <UNDEFINED> instruction: 0xf81c0003
     de8:	01000009 	tsteq	r0, r9
     dec:	003a0d0e 	eorseq	r0, sl, lr, lsl #26
     df0:	01010000 	mrseq	r0, (UNDEF: 1)
     df4:	d71c0002 	ldrle	r0, [ip, -r2]
     df8:	01000008 	tsteq	r0, r8
     dfc:	003a0d0f 	eorseq	r0, sl, pc, lsl #26
     e00:	01010000 	mrseq	r0, (UNDEF: 1)
     e04:	4d1c0001 	ldcmi	0, cr0, [ip, #-4]
     e08:	0100000a 	tsteq	r0, sl
     e0c:	003a0d10 	eorseq	r0, sl, r0, lsl sp
     e10:	01010000 	mrseq	r0, (UNDEF: 1)
     e14:	7d1c0000 	ldcvc	0, cr0, [ip, #-0]
     e18:	01000008 	tsteq	r0, r8
     e1c:	003a0d11 	eorseq	r0, sl, r1, lsl sp
     e20:	01010000 	mrseq	r0, (UNDEF: 1)
     e24:	5a1c0107 	bpl	701248 <_bss_end+0x6f7f9c>
     e28:	01000009 	tsteq	r0, r9
     e2c:	003a0d12 	eorseq	r0, sl, r2, lsl sp
     e30:	01010000 	mrseq	r0, (UNDEF: 1)
     e34:	e01d0106 	ands	r0, sp, r6, lsl #2
     e38:	01000008 	tsteq	r0, r8
     e3c:	004d0e13 	subeq	r0, sp, r3, lsl lr
     e40:	0a020000 	beq	80e48 <_bss_end+0x77b9c>
     e44:	371d007c 			; <UNDEFINED> instruction: 0x371d007c
     e48:	01000009 	tsteq	r0, r9
     e4c:	004d0e14 	subeq	r0, sp, r4, lsl lr
     e50:	10020000 	andne	r0, r2, r0
     e54:	e91c027c 	ldmdb	ip, {r2, r3, r4, r5, r6, r9}
     e58:	01000008 	tsteq	r0, r8
     e5c:	004d0e15 	subeq	r0, sp, r5, lsl lr
     e60:	0a020000 	beq	80e68 <_bss_end+0x77bbc>
     e64:	06000402 	streq	r0, [r0], -r2, lsl #8
     e68:	000002cc 	andeq	r0, r0, ip, asr #5
     e6c:	0008441e 	andeq	r4, r8, lr, lsl r4
     e70:	008c1c00 	addeq	r1, ip, r0, lsl #24
     e74:	00001c00 	andeq	r1, r0, r0, lsl #24
     e78:	1f9c0100 	svcne	0x009c0100
     e7c:	00000631 	andeq	r0, r0, r1, lsr r6
     e80:	00008bc8 	andeq	r8, r0, r8, asr #23
     e84:	00000054 	andeq	r0, r0, r4, asr r0
     e88:	03e09c01 	mvneq	r9, #256	; 0x100
     e8c:	db200000 	blle	800e94 <_bss_end+0x7f7be8>
     e90:	01000004 	tsteq	r0, r4
     e94:	0033014a 	eorseq	r0, r3, sl, asr #2
     e98:	91020000 	mrsls	r0, (UNDEF: 2)
     e9c:	071c2074 			; <UNDEFINED> instruction: 0x071c2074
     ea0:	4a010000 	bmi	40ea8 <_bss_end+0x37bfc>
     ea4:	00003301 	andeq	r3, r0, r1, lsl #6
     ea8:	70910200 	addsvc	r0, r1, r0, lsl #4
     eac:	02712100 	rsbseq	r2, r1, #0, 2
     eb0:	47010000 	strmi	r0, [r1, -r0]
     eb4:	0003fa06 	andeq	pc, r3, r6, lsl #20
     eb8:	008b8800 	addeq	r8, fp, r0, lsl #16
     ebc:	00004000 	andeq	r4, r0, r0
     ec0:	079c0100 	ldreq	r0, [ip, r0, lsl #2]
     ec4:	22000004 	andcs	r0, r0, #4
     ec8:	00000664 	andeq	r0, r0, r4, ror #12
     ecc:	000002a6 	andeq	r0, r0, r6, lsr #5
     ed0:	00749102 	rsbseq	r9, r4, r2, lsl #2
     ed4:	00025621 	andeq	r5, r2, r1, lsr #12
     ed8:	063f0100 	ldrteq	r0, [pc], -r0, lsl #2
     edc:	00000421 	andeq	r0, r0, r1, lsr #8
     ee0:	00008b38 	andeq	r8, r0, r8, lsr fp
     ee4:	00000050 	andeq	r0, r0, r0, asr r0
     ee8:	042e9c01 	strteq	r9, [lr], #-3073	; 0xfffff3ff
     eec:	64220000 	strtvs	r0, [r2], #-0
     ef0:	a6000006 	strge	r0, [r0], -r6
     ef4:	02000002 	andeq	r0, r0, #2
     ef8:	21007491 			; <UNDEFINED> instruction: 0x21007491
     efc:	0000023b 	andeq	r0, r0, fp, lsr r2
     f00:	48063701 	stmdami	r6, {r0, r8, r9, sl, ip, sp}
     f04:	ec000004 	stc	0, cr0, [r0], {4}
     f08:	4c00008a 	stcmi	0, cr0, [r0], {138}	; 0x8a
     f0c:	01000000 	mrseq	r0, (UNDEF: 0)
     f10:	0004649c 	muleq	r4, ip, r4
     f14:	06642200 	strbteq	r2, [r4], -r0, lsl #4
     f18:	02a60000 	adceq	r0, r6, #0
     f1c:	91020000 	mrsls	r0, (UNDEF: 2)
     f20:	6572236c 	ldrbvs	r2, [r2, #-876]!	; 0xfffffc94
     f24:	39010067 	stmdbcc	r1, {r0, r1, r2, r5, r6}
     f28:	00046420 	andeq	r6, r4, r0, lsr #8
     f2c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     f30:	9a041800 	bls	106f38 <_bss_end+0xfdc8c>
     f34:	21000003 	tstcs	r0, r3
     f38:	00000211 	andeq	r0, r0, r1, lsl r2
     f3c:	84062601 	strhi	r2, [r6], #-1537	; 0xfffff9ff
     f40:	20000004 	andcs	r0, r0, r4
     f44:	cc00008a 	stcgt	0, cr0, [r0], {138}	; 0x8a
     f48:	01000000 	mrseq	r0, (UNDEF: 0)
     f4c:	0004cd9c 	muleq	r4, ip, sp
     f50:	06642200 	strbteq	r2, [r4], -r0, lsl #4
     f54:	02a60000 	adceq	r0, r6, #0
     f58:	91020000 	mrsls	r0, (UNDEF: 2)
     f5c:	0b072064 	bleq	1c90f4 <_bss_end+0x1bfe48>
     f60:	26010000 	strcs	r0, [r1], -r0
     f64:	0001af25 	andeq	sl, r1, r5, lsr #30
     f68:	60910200 	addsvs	r0, r1, r0, lsl #4
     f6c:	0008bf20 	andeq	fp, r8, r0, lsr #30
     f70:	3c260100 	stfccs	f0, [r6], #-0
     f74:	00000071 	andeq	r0, r0, r1, ror r0
     f78:	205c9102 	subscs	r9, ip, r2, lsl #2
     f7c:	00000944 	andeq	r0, r0, r4, asr #18
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
     fb4:	00066422 	andeq	r6, r6, r2, lsr #8
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
     fe0:	06642700 	strbteq	r2, [r4], -r0, lsl #14
     fe4:	02a60000 	adceq	r0, r6, #0
     fe8:	3e280000 	cdpcc	0, 2, cr0, cr8, cr0, {0}
     fec:	0100000a 	tsteq	r0, sl
     ff0:	01461e1a 	cmpeq	r6, sl, lsl lr
     ff4:	29000000 	stmdbcs	r0, {}	; <UNPREDICTABLE>
     ff8:	00000503 	andeq	r0, r0, r3, lsl #10
     ffc:	00000891 	muleq	r0, r1, r8
    1000:	00000541 	andeq	r0, r0, r1, asr #10
    1004:	000089a8 	andeq	r8, r0, r8, lsr #19
    1008:	00000040 	andeq	r0, r0, r0, asr #32
    100c:	142a9c01 	strtne	r9, [sl], #-3073	; 0xfffff3ff
    1010:	02000005 	andeq	r0, r0, #5
    1014:	1d2a7491 	cfstrsne	mvf7, [sl, #-580]!	; 0xfffffdbc
    1018:	02000005 	andeq	r0, r0, #5
    101c:	00007091 	muleq	r0, r1, r0
    1020:	0000097c 	andeq	r0, r0, ip, ror r9
    1024:	05b80004 	ldreq	r0, [r8, #4]!
    1028:	01040000 	mrseq	r0, (UNDEF: 4)
    102c:	00000000 	andeq	r0, r0, r0
    1030:	000c0104 	andeq	r0, ip, r4, lsl #2
    1034:	0000f600 	andeq	pc, r0, r0, lsl #12
    1038:	008c3800 	addeq	r3, ip, r0, lsl #16
    103c:	0002dc00 	andeq	sp, r2, r0, lsl #24
    1040:	0006f900 	andeq	pc, r6, r0, lsl #18
    1044:	08010200 	stmdaeq	r1, {r9}
    1048:	00000549 	andeq	r0, r0, r9, asr #10
    104c:	b7050202 	strlt	r0, [r5, -r2, lsl #4]
    1050:	03000002 	movweq	r0, #2
    1054:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
    1058:	92040074 	andls	r0, r4, #116	; 0x74
    105c:	02000003 	andeq	r0, r0, #3
    1060:	00460709 	subeq	r0, r6, r9, lsl #14
    1064:	01020000 	mrseq	r0, (UNDEF: 2)
    1068:	00054008 	andeq	r4, r5, r8
    106c:	07020200 	streq	r0, [r2, -r0, lsl #4]
    1070:	000005a1 	andeq	r0, r0, r1, lsr #11
    1074:	0003a804 	andeq	sl, r3, r4, lsl #16
    1078:	070b0200 	streq	r0, [fp, -r0, lsl #4]
    107c:	00000065 	andeq	r0, r0, r5, rrx
    1080:	00005405 	andeq	r5, r0, r5, lsl #8
    1084:	07040200 	streq	r0, [r4, -r0, lsl #4]
    1088:	0000158c 	andeq	r1, r0, ip, lsl #11
    108c:	00006505 	andeq	r6, r0, r5, lsl #10
    1090:	00650600 	rsbeq	r0, r5, r0, lsl #12
    1094:	68070000 	stmdavs	r7, {}	; <UNPREDICTABLE>
    1098:	03006c61 	movweq	r6, #3169	; 0xc61
    109c:	02280b07 	eoreq	r0, r8, #7168	; 0x1c00
    10a0:	18080000 	stmdane	r8, {}	; <UNPREDICTABLE>
    10a4:	03000008 	movweq	r0, #8
    10a8:	006c1c09 	rsbeq	r1, ip, r9, lsl #24
    10ac:	b2800000 	addlt	r0, r0, #0
    10b0:	8f080ee6 	svchi	0x00080ee6
    10b4:	03000004 	movweq	r0, #4
    10b8:	02341d0c 	eorseq	r1, r4, #12, 26	; 0x300
    10bc:	00000000 	andeq	r0, r0, r0
    10c0:	63082000 	movwvs	r2, #32768	; 0x8000
    10c4:	03000005 	movweq	r0, #5
    10c8:	02341d0f 	eorseq	r1, r4, #960	; 0x3c0
    10cc:	00000000 	andeq	r0, r0, r0
    10d0:	12092020 	andne	r2, r9, #32
    10d4:	03000006 	movweq	r0, #6
    10d8:	00601812 	rsbeq	r1, r0, r2, lsl r8
    10dc:	08360000 	ldmdaeq	r6!, {}	; <UNPREDICTABLE>
    10e0:	00000756 	andeq	r0, r0, r6, asr r7
    10e4:	341d4403 	ldrcc	r4, [sp], #-1027	; 0xfffffbfd
    10e8:	00000002 	andeq	r0, r0, r2
    10ec:	08202150 	stmdaeq	r0!, {r4, r6, r8, sp}
    10f0:	0000026a 	andeq	r0, r0, sl, ror #4
    10f4:	341d7303 	ldrcc	r7, [sp], #-771	; 0xfffffcfd
    10f8:	00000002 	andeq	r0, r0, r2
    10fc:	0a2000b2 	beq	8013cc <_bss_end+0x7f8120>
    1100:	00000bb5 			; <UNDEFINED> instruction: 0x00000bb5
    1104:	00330405 	eorseq	r0, r3, r5, lsl #8
    1108:	75030000 	strvc	r0, [r3, #-0]
    110c:	00012e10 	andeq	r2, r1, r0, lsl lr
    1110:	0ccb0b00 	vstmiaeq	fp, {d16-d15}
    1114:	0b000000 	bleq	111c <CPSR_IRQ_INHIBIT+0x109c>
    1118:	00000e9b 	muleq	r0, fp, lr
    111c:	0ec20b01 	vdiveq.f64	d16, d2, d1
    1120:	0b020000 	bleq	81128 <_bss_end+0x77e7c>
    1124:	00000e48 	andeq	r0, r0, r8, asr #28
    1128:	0b960b03 	bleq	fe583d3c <_bss_end+0xfe57aa90>
    112c:	0b040000 	bleq	101134 <_bss_end+0xf7e88>
    1130:	00000ba3 	andeq	r0, r0, r3, lsr #23
    1134:	0e8a0b05 	vdiveq.f64	d0, d10, d5
    1138:	0b060000 	bleq	181140 <_bss_end+0x177e94>
    113c:	00000f09 	andeq	r0, r0, r9, lsl #30
    1140:	0f170b07 	svceq	0x00170b07
    1144:	0b080000 	bleq	20114c <_bss_end+0x1f7ea0>
    1148:	00000cff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    114c:	f00a0009 			; <UNDEFINED> instruction: 0xf00a0009
    1150:	0500000b 	streq	r0, [r0, #-11]
    1154:	00003304 	andeq	r3, r0, r4, lsl #6
    1158:	10830300 	addne	r0, r3, r0, lsl #6
    115c:	00000171 	andeq	r0, r0, r1, ror r1
    1160:	000a720b 	andeq	r7, sl, fp, lsl #4
    1164:	640b0000 	strvs	r0, [fp], #-0
    1168:	0100000b 	tsteq	r0, fp
    116c:	000d690b 	andeq	r6, sp, fp, lsl #18
    1170:	740b0200 	strvc	r0, [fp], #-512	; 0xfffffe00
    1174:	0300000d 	movweq	r0, #13
    1178:	000d7f0b 	andeq	r7, sp, fp, lsl #30
    117c:	5a0b0400 	bpl	2c2184 <_bss_end+0x2b8ed8>
    1180:	0500000b 	streq	r0, [r0, #-11]
    1184:	000bce0b 	andeq	ip, fp, fp, lsl #28
    1188:	df0b0600 	svcle	0x000b0600
    118c:	0700000b 	streq	r0, [r0, -fp]
    1190:	0ea90a00 	vfmaeq.f32	s0, s18, s0
    1194:	04050000 	streq	r0, [r5], #-0
    1198:	00000033 	andeq	r0, r0, r3, lsr r0
    119c:	d2108f03 	andsle	r8, r0, #3, 30
    11a0:	0c000001 	stceq	0, cr0, [r0], {1}
    11a4:	00585541 	subseq	r5, r8, r1, asr #10
    11a8:	0e350b1d 	vmoveq.32	r0, d5[1]
    11ac:	0b2b0000 	bleq	ac11b4 <_bss_end+0xab7f08>
    11b0:	00000f25 	andeq	r0, r0, r5, lsr #30
    11b4:	0f2b0b2d 	svceq	0x002b0b2d
    11b8:	0c2e0000 	stceq	0, cr0, [lr], #-0
    11bc:	00494d53 	subeq	r4, r9, r3, asr sp
    11c0:	0ed00b30 	vmoveq.u8	r0, d0[1]
    11c4:	0b310000 	bleq	c411cc <_bss_end+0xc37f20>
    11c8:	00000ed7 	ldrdeq	r0, [r0], -r7
    11cc:	0ede0b32 	vmoveq.u8	r0, d14[1]
    11d0:	0b330000 	bleq	cc11d8 <_bss_end+0xcb7f2c>
    11d4:	00000ee5 	andeq	r0, r0, r5, ror #29
    11d8:	32490c34 	subcc	r0, r9, #52, 24	; 0x3400
    11dc:	0c350043 	ldceq	0, cr0, [r5], #-268	; 0xfffffef4
    11e0:	00495053 	subeq	r5, r9, r3, asr r0
    11e4:	43500c36 	cmpmi	r0, #13824	; 0x3600
    11e8:	0b37004d 	bleq	dc1324 <_bss_end+0xdb8078>
    11ec:	00000bb0 			; <UNDEFINED> instruction: 0x00000bb0
    11f0:	26080039 			; <UNDEFINED> instruction: 0x26080039
    11f4:	03000006 	movweq	r0, #6
    11f8:	02341da6 	eorseq	r1, r4, #10624	; 0x2980
    11fc:	b4000000 	strlt	r0, [r0], #-0
    1200:	1f0d2000 	svcne	0x000d2000
    1204:	0500000a 	streq	r0, [r0, #-10]
    1208:	00003304 	andeq	r3, r0, r4, lsl #6
    120c:	10a80300 	adcne	r0, r8, r0, lsl #6
    1210:	000a6c0b 	andeq	r6, sl, fp, lsl #24
    1214:	910b0000 	mrsls	r0, (UNDEF: 11)
    1218:	01000009 	tsteq	r0, r9
    121c:	000e4c0b 	andeq	r4, lr, fp, lsl #24
    1220:	6e0b0200 	cdpvs	2, 0, cr0, cr11, cr0, {0}
    1224:	03000009 	movweq	r0, #9
    1228:	000ae40b 	andeq	lr, sl, fp, lsl #8
    122c:	b40b0400 	strlt	r0, [fp], #-1024	; 0xfffffc00
    1230:	05000008 	streq	r0, [r0, #-8]
    1234:	0008a00b 	andeq	sl, r8, fp
    1238:	130b0600 	movwne	r0, #46592	; 0xb600
    123c:	0700000a 	streq	r0, [r0, -sl]
    1240:	000ab20b 	andeq	fp, sl, fp, lsl #4
    1244:	00000800 	andeq	r0, r0, r0, lsl #16
    1248:	0000820e 	andeq	r8, r0, lr, lsl #4
    124c:	07040200 	streq	r0, [r4, -r0, lsl #4]
    1250:	00001587 	andeq	r1, r0, r7, lsl #11
    1254:	00022d05 	andeq	r2, r2, r5, lsl #26
    1258:	00920e00 	addseq	r0, r2, r0, lsl #28
    125c:	a20e0000 	andge	r0, lr, #0
    1260:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    1264:	000000b2 	strheq	r0, [r0], -r2
    1268:	0000bf0e 	andeq	fp, r0, lr, lsl #30
    126c:	00cf0e00 	sbceq	r0, pc, r0, lsl #28
    1270:	d20e0000 	andle	r0, lr, #0
    1274:	0a000001 	beq	1280 <CPSR_IRQ_INHIBIT+0x1200>
    1278:	000006d3 	ldrdeq	r0, [r0], -r3
    127c:	003a0107 	eorseq	r0, sl, r7, lsl #2
    1280:	06040000 	streq	r0, [r4], -r0
    1284:	0002a00c 	andeq	sl, r2, ip
    1288:	07720b00 	ldrbeq	r0, [r2, -r0, lsl #22]!
    128c:	0b000000 	bleq	1294 <CPSR_IRQ_INHIBIT+0x1214>
    1290:	00000783 	andeq	r0, r0, r3, lsl #15
    1294:	08370b01 	ldmdaeq	r7!, {r0, r8, r9, fp}
    1298:	0b020000 	bleq	812a0 <_bss_end+0x77ff4>
    129c:	00000831 	andeq	r0, r0, r1, lsr r8
    12a0:	080c0b03 	stmdaeq	ip, {r0, r1, r8, r9, fp}
    12a4:	0b040000 	bleq	1012ac <_bss_end+0xf8000>
    12a8:	00000812 	andeq	r0, r0, r2, lsl r8
    12ac:	06ee0b05 	strbteq	r0, [lr], r5, lsl #22
    12b0:	0b060000 	bleq	1812b8 <_bss_end+0x17800c>
    12b4:	0000082b 	andeq	r0, r0, fp, lsr #16
    12b8:	03b60b07 			; <UNDEFINED> instruction: 0x03b60b07
    12bc:	00080000 	andeq	r0, r8, r0
    12c0:	0003000a 	andeq	r0, r3, sl
    12c4:	33040500 	movwcc	r0, #17664	; 0x4500
    12c8:	04000000 	streq	r0, [r0], #-0
    12cc:	02cb0c18 	sbceq	r0, fp, #24, 24	; 0x1800
    12d0:	e20b0000 	and	r0, fp, #0
    12d4:	00000006 	andeq	r0, r0, r6
    12d8:	0007ff0b 	andeq	pc, r7, fp, lsl #30
    12dc:	b20b0100 	andlt	r0, fp, #0, 2
    12e0:	02000002 	andeq	r0, r0, #2
    12e4:	776f4c0c 	strbvc	r4, [pc, -ip, lsl #24]!
    12e8:	0f000300 	svceq	0x00000300
    12ec:	0000043d 	andeq	r0, r0, sp, lsr r4
    12f0:	07230404 	streq	r0, [r3, -r4, lsl #8]!
    12f4:	000004f7 	strdeq	r0, [r0], -r7
    12f8:	00037510 	andeq	r7, r3, r0, lsl r5
    12fc:	19270400 	stmdbne	r7!, {sl}
    1300:	00000502 	andeq	r0, r0, r2, lsl #10
    1304:	05fe1100 	ldrbeq	r1, [lr, #256]!	; 0x100
    1308:	2b040000 	blcs	101310 <_bss_end+0xf8064>
    130c:	0003450a 	andeq	r4, r3, sl, lsl #10
    1310:	00050700 	andeq	r0, r5, r0, lsl #14
    1314:	02fe0200 	rscseq	r0, lr, #0, 4
    1318:	03130000 	tsteq	r3, #0
    131c:	0e120000 	cdpeq	0, 1, cr0, cr2, cr0, {0}
    1320:	13000005 	movwne	r0, #5
    1324:	00000054 	andeq	r0, r0, r4, asr r0
    1328:	00051413 	andeq	r1, r5, r3, lsl r4
    132c:	05141300 	ldreq	r1, [r4, #-768]	; 0xfffffd00
    1330:	11000000 	mrsne	r0, (UNDEF: 0)
    1334:	0000075f 	andeq	r0, r0, pc, asr r7
    1338:	110a2d04 	tstne	sl, r4, lsl #26
    133c:	07000005 	streq	r0, [r0, -r5]
    1340:	02000005 	andeq	r0, r0, #5
    1344:	0000032c 	andeq	r0, r0, ip, lsr #6
    1348:	00000341 	andeq	r0, r0, r1, asr #6
    134c:	00050e12 	andeq	r0, r5, r2, lsl lr
    1350:	00541300 	subseq	r1, r4, r0, lsl #6
    1354:	14130000 	ldrne	r0, [r3], #-0
    1358:	13000005 	movwne	r0, #5
    135c:	00000514 	andeq	r0, r0, r4, lsl r5
    1360:	044b1100 	strbeq	r1, [fp], #-256	; 0xffffff00
    1364:	2f040000 	svccs	0x00040000
    1368:	0007270a 	andeq	r2, r7, sl, lsl #14
    136c:	00050700 	andeq	r0, r5, r0, lsl #14
    1370:	035a0200 	cmpeq	sl, #0, 4
    1374:	036f0000 	cmneq	pc, #0
    1378:	0e120000 	cdpeq	0, 1, cr0, cr2, cr0, {0}
    137c:	13000005 	movwne	r0, #5
    1380:	00000054 	andeq	r0, r0, r4, asr r0
    1384:	00051413 	andeq	r1, r5, r3, lsl r4
    1388:	05141300 	ldreq	r1, [r4, #-768]	; 0xfffffd00
    138c:	11000000 	mrsne	r0, (UNDEF: 0)
    1390:	0000049f 	muleq	r0, pc, r4	; <UNPREDICTABLE>
    1394:	f60a3104 			; <UNDEFINED> instruction: 0xf60a3104
    1398:	07000001 	streq	r0, [r0, -r1]
    139c:	02000005 	andeq	r0, r0, #5
    13a0:	00000388 	andeq	r0, r0, r8, lsl #7
    13a4:	0000039d 	muleq	r0, sp, r3
    13a8:	00050e12 	andeq	r0, r5, r2, lsl lr
    13ac:	00541300 	subseq	r1, r4, r0, lsl #6
    13b0:	14130000 	ldrne	r0, [r3], #-0
    13b4:	13000005 	movwne	r0, #5
    13b8:	00000514 	andeq	r0, r0, r4, lsl r5
    13bc:	029f1100 	addseq	r1, pc, #0, 2
    13c0:	32040000 	andcc	r0, r4, #0
    13c4:	0005cf0a 	andeq	ip, r5, sl, lsl #30
    13c8:	00050700 	andeq	r0, r5, r0, lsl #14
    13cc:	03b60200 			; <UNDEFINED> instruction: 0x03b60200
    13d0:	03cb0000 	biceq	r0, fp, #0
    13d4:	0e120000 	cdpeq	0, 1, cr0, cr2, cr0, {0}
    13d8:	13000005 	movwne	r0, #5
    13dc:	00000054 	andeq	r0, r0, r4, asr r0
    13e0:	00051413 	andeq	r1, r5, r3, lsl r4
    13e4:	05141300 	ldreq	r1, [r4, #-768]	; 0xfffffd00
    13e8:	11000000 	mrsne	r0, (UNDEF: 0)
    13ec:	0000043d 	andeq	r0, r0, sp, lsr r4
    13f0:	7b053504 	blvc	14e808 <_bss_end+0x14555c>
    13f4:	1a000003 	bne	1408 <CPSR_IRQ_INHIBIT+0x1388>
    13f8:	01000005 	tsteq	r0, r5
    13fc:	000003e4 	andeq	r0, r0, r4, ror #7
    1400:	000003ef 	andeq	r0, r0, pc, ror #7
    1404:	00051a12 	andeq	r1, r5, r2, lsl sl
    1408:	00651300 	rsbeq	r1, r5, r0, lsl #6
    140c:	14000000 	strne	r0, [r0], #-0
    1410:	00000702 	andeq	r0, r0, r2, lsl #14
    1414:	aa0a3804 	bge	28f42c <_bss_end+0x286180>
    1418:	01000006 	tsteq	r0, r6
    141c:	00000404 	andeq	r0, r0, r4, lsl #8
    1420:	00000414 	andeq	r0, r0, r4, lsl r4
    1424:	00051a12 	andeq	r1, r5, r2, lsl sl
    1428:	00541300 	subseq	r1, r4, r0, lsl #6
    142c:	57130000 	ldrpl	r0, [r3, -r0]
    1430:	00000002 	andeq	r0, r0, r2
    1434:	00042b11 	andeq	r2, r4, r1, lsl fp
    1438:	143a0400 	ldrtne	r0, [sl], #-1024	; 0xfffffc00
    143c:	000004b2 			; <UNDEFINED> instruction: 0x000004b2
    1440:	00000257 	andeq	r0, r0, r7, asr r2
    1444:	00042d01 	andeq	r2, r4, r1, lsl #26
    1448:	00043800 	andeq	r3, r4, r0, lsl #16
    144c:	050e1200 	streq	r1, [lr, #-512]	; 0xfffffe00
    1450:	54130000 	ldrpl	r0, [r3], #-0
    1454:	00000000 	andeq	r0, r0, r0
    1458:	00077f14 	andeq	r7, r7, r4, lsl pc
    145c:	0a3d0400 	beq	f42464 <_bss_end+0xf391b8>
    1460:	00000323 	andeq	r0, r0, r3, lsr #6
    1464:	00044d01 	andeq	r4, r4, r1, lsl #26
    1468:	00045d00 	andeq	r5, r4, r0, lsl #26
    146c:	051a1200 	ldreq	r1, [sl, #-512]	; 0xfffffe00
    1470:	54130000 	ldrpl	r0, [r3], #-0
    1474:	13000000 	movwne	r0, #0
    1478:	00000507 	andeq	r0, r0, r7, lsl #10
    147c:	03c21400 	biceq	r1, r2, #0, 8
    1480:	3f040000 	svccc	0x00040000
    1484:	0004640a 	andeq	r6, r4, sl, lsl #8
    1488:	04720100 	ldrbteq	r0, [r2], #-256	; 0xffffff00
    148c:	047d0000 	ldrbteq	r0, [sp], #-0
    1490:	1a120000 	bne	481498 <_bss_end+0x4781ec>
    1494:	13000005 	movwne	r0, #5
    1498:	00000054 	andeq	r0, r0, r4, asr r0
    149c:	05bb1400 	ldreq	r1, [fp, #1024]!	; 0x400
    14a0:	41040000 	mrsmi	r0, (UNDEF: 4)
    14a4:	0002d50a 	andeq	sp, r2, sl, lsl #10
    14a8:	04920100 	ldreq	r0, [r2], #256	; 0x100
    14ac:	04a20000 	strteq	r0, [r2], #0
    14b0:	1a120000 	bne	4814b8 <_bss_end+0x47820c>
    14b4:	13000005 	movwne	r0, #5
    14b8:	00000054 	andeq	r0, r0, r4, asr r0
    14bc:	0002a013 	andeq	sl, r2, r3, lsl r0
    14c0:	ea140000 	b	5014c8 <_bss_end+0x4f821c>
    14c4:	04000007 	streq	r0, [r0], #-7
    14c8:	06690a42 	strbteq	r0, [r9], -r2, asr #20
    14cc:	b7010000 	strlt	r0, [r1, -r0]
    14d0:	c7000004 	strgt	r0, [r0, -r4]
    14d4:	12000004 	andne	r0, r0, #4
    14d8:	0000051a 	andeq	r0, r0, sl, lsl r5
    14dc:	00005413 	andeq	r5, r0, r3, lsl r4
    14e0:	02a01300 	adceq	r1, r0, #0, 6
    14e4:	15000000 	strne	r0, [r0, #-0]
    14e8:	00000284 	andeq	r0, r0, r4, lsl #5
    14ec:	de0a4304 	cdple	3, 0, cr4, cr10, cr4, {0}
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
    1528:	03b10201 			; <UNDEFINED> instruction: 0x03b10201
    152c:	04160000 	ldreq	r0, [r6], #-0
    1530:	000004f7 	strdeq	r0, [r0], -r7
    1534:	00540417 	subseq	r0, r4, r7, lsl r4
    1538:	04160000 	ldreq	r0, [r6], #-0
    153c:	000002cb 	andeq	r0, r0, fp, asr #5
    1540:	00055d18 	andeq	r5, r5, r8, lsl sp
    1544:	16470400 	strbne	r0, [r7], -r0, lsl #8
    1548:	000002cb 	andeq	r0, r0, fp, asr #5
    154c:	000ce90f 	andeq	lr, ip, pc, lsl #18
    1550:	09050400 	stmdbeq	r5, {sl}
    1554:	00060b07 	andeq	r0, r6, r7, lsl #22
    1558:	0c691000 	stcleq	0, cr1, [r9], #-0
    155c:	0d050000 	stceq	0, cr0, [r5, #-0]
    1560:	00060b1c 	andeq	r0, r6, ip, lsl fp
    1564:	8c110000 	ldchi	0, cr0, [r1], {-0}
    1568:	05000009 	streq	r0, [r0, #-9]
    156c:	0b191c10 	bleq	6485b4 <_bss_end+0x63f308>
    1570:	06110000 	ldreq	r0, [r1], -r0
    1574:	5f020000 	svcpl	0x00020000
    1578:	6a000005 	bvs	1594 <CPSR_IRQ_INHIBIT+0x1514>
    157c:	12000005 	andne	r0, r0, #5
    1580:	00000617 	andeq	r0, r0, r7, lsl r6
    1584:	0000df13 	andeq	sp, r0, r3, lsl pc
    1588:	e9110000 	ldmdb	r1, {}	; <UNPREDICTABLE>
    158c:	0500000c 	streq	r0, [r0, #-12]
    1590:	0e160513 	mrceq	5, 0, r0, cr6, cr3, {0}
    1594:	06170000 	ldreq	r0, [r7], -r0
    1598:	83010000 	movwhi	r0, #4096	; 0x1000
    159c:	8e000005 	cdphi	0, 0, cr0, cr0, cr5, {0}
    15a0:	12000005 	andne	r0, r0, #5
    15a4:	00000617 	andeq	r0, r0, r7, lsl r6
    15a8:	00022d13 	andeq	r2, r2, r3, lsl sp
    15ac:	11140000 	tstne	r4, r0
    15b0:	0500000d 	streq	r0, [r0, #-13]
    15b4:	0dd00a16 	vldreq	s1, [r0, #88]	; 0x58
    15b8:	a3010000 	movwge	r0, #4096	; 0x1000
    15bc:	ae000005 	cdpge	0, 0, cr0, cr0, cr5, {0}
    15c0:	12000005 	andne	r0, r0, #5
    15c4:	00000617 	andeq	r0, r0, r7, lsl r6
    15c8:	00012e13 	andeq	r2, r1, r3, lsl lr
    15cc:	ec140000 	ldc	0, cr0, [r4], {-0}
    15d0:	0500000e 	streq	r0, [r0, #-14]
    15d4:	0d220a18 	vstmdbeq	r2!, {s0-s23}
    15d8:	c3010000 	movwgt	r0, #4096	; 0x1000
    15dc:	ce000005 	cdpgt	0, 0, cr0, cr0, cr5, {0}
    15e0:	12000005 	andne	r0, r0, #5
    15e4:	00000617 	andeq	r0, r0, r7, lsl r6
    15e8:	00012e13 	andeq	r2, r1, r3, lsl lr
    15ec:	6c140000 	ldcvs	0, cr0, [r4], {-0}
    15f0:	0500000b 	streq	r0, [r0, #-11]
    15f4:	0d890a1b 	vstreq	s0, [r9, #108]	; 0x6c
    15f8:	e3010000 	movw	r0, #4096	; 0x1000
    15fc:	ee000005 	cdp	0, 0, cr0, cr0, cr5, {0}
    1600:	12000005 	andne	r0, r0, #5
    1604:	00000617 	andeq	r0, r0, r7, lsl r6
    1608:	00017113 	andeq	r7, r1, r3, lsl r1
    160c:	dd190000 	ldcle	0, cr0, [r9, #-0]
    1610:	0500000c 	streq	r0, [r0, #-12]
    1614:	0c790a1d 			; <UNDEFINED> instruction: 0x0c790a1d
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
    1640:	b4180000 	ldrlt	r0, [r8], #-0
    1644:	0500000e 	streq	r0, [r0, #-14]
    1648:	052c1e20 	streq	r1, [ip, #-3616]!	; 0xfffff1e0
    164c:	260a0000 	strcs	r0, [sl], -r0
    1650:	07000009 	streq	r0, [r0, -r9]
    1654:	00003a01 	andeq	r3, r0, r1, lsl #20
    1658:	0c060600 	stceq	6, cr0, [r6], {-0}
    165c:	00000653 	andeq	r0, r0, r3, asr r6
    1660:	00094e0b 	andeq	r4, r9, fp, lsl #28
    1664:	780b0000 	stmdavc	fp, {}	; <UNPREDICTABLE>
    1668:	01000009 	tsteq	r0, r9
    166c:	0008fe0b 	andeq	pc, r8, fp, lsl #28
    1670:	0f000200 	svceq	0x00000200
    1674:	00000a71 	andeq	r0, r0, r1, ror sl
    1678:	070d0608 	streq	r0, [sp, -r8, lsl #12]
    167c:	0000074b 	andeq	r0, r0, fp, asr #14
    1680:	00098510 	andeq	r8, r9, r0, lsl r5
    1684:	1c150600 	ldcne	6, cr0, [r5], {-0}
    1688:	0000060b 	andeq	r0, r0, fp, lsl #12
    168c:	0ad41a00 	beq	ff507e94 <_bss_end+0xff4febe8>
    1690:	11060000 	mrsne	r0, (UNDEF: 6)
    1694:	00074b0b 	andeq	r4, r7, fp, lsl #22
    1698:	78100100 	ldmdavc	r0, {r8}
    169c:	0600000a 	streq	r0, [r0], -sl
    16a0:	066d1518 			; <UNDEFINED> instruction: 0x066d1518
    16a4:	11040000 	mrsne	r0, (UNDEF: 4)
    16a8:	0000098c 	andeq	r0, r0, ip, lsl #19
    16ac:	821c1b06 	andshi	r1, ip, #6144	; 0x1800
    16b0:	1100000a 	tstne	r0, sl
    16b4:	02000006 	andeq	r0, r0, #6
    16b8:	000006a0 	andeq	r0, r0, r0, lsr #13
    16bc:	000006ab 	andeq	r0, r0, fp, lsr #13
    16c0:	00075212 	andeq	r5, r7, r2, lsl r2
    16c4:	01e21300 	mvneq	r1, r0, lsl #6
    16c8:	11000000 	mrsne	r0, (UNDEF: 0)
    16cc:	00000a71 	andeq	r0, r0, r1, ror sl
    16d0:	a3051e06 	movwge	r1, #24070	; 0x5e06
    16d4:	5200000a 	andpl	r0, r0, #10
    16d8:	01000007 	tsteq	r0, r7
    16dc:	000006c4 	andeq	r0, r0, r4, asr #13
    16e0:	000006cf 	andeq	r0, r0, pc, asr #13
    16e4:	00075212 	andeq	r5, r7, r2, lsl r2
    16e8:	022d1300 	eoreq	r1, sp, #0, 6
    16ec:	14000000 	strne	r0, [r0], #-0
    16f0:	00000e94 	muleq	r0, r4, lr
    16f4:	0c0a2106 	stfeqs	f2, [sl], {6}
    16f8:	01000009 	tsteq	r0, r9
    16fc:	000006e4 	andeq	r0, r0, r4, ror #13
    1700:	000006f9 	strdeq	r0, [r0], -r9
    1704:	00075212 	andeq	r5, r7, r2, lsl r2
    1708:	066d1300 	strbteq	r1, [sp], -r0, lsl #6
    170c:	65130000 	ldrvs	r0, [r3, #-0]
    1710:	13000000 	movwne	r0, #0
    1714:	0000062e 	andeq	r0, r0, lr, lsr #12
    1718:	0d091400 	cfstrseq	mvf1, [r9, #-0]
    171c:	23060000 	movwcs	r0, #24576	; 0x6000
    1720:	000a290a 	andeq	r2, sl, sl, lsl #18
    1724:	070e0100 	streq	r0, [lr, -r0, lsl #2]
    1728:	07140000 	ldreq	r0, [r4, -r0]
    172c:	52120000 	andspl	r0, r2, #0
    1730:	00000007 	andeq	r0, r0, r7
    1734:	0008a714 	andeq	sl, r8, r4, lsl r7
    1738:	0a260600 	beq	982f40 <_bss_end+0x979c94>
    173c:	00000aec 	andeq	r0, r0, ip, ror #21
    1740:	00072901 	andeq	r2, r7, r1, lsl #18
    1744:	00072f00 	andeq	r2, r7, r0, lsl #30
    1748:	07521200 	ldrbeq	r1, [r2, -r0, lsl #4]
    174c:	15000000 	strne	r0, [r0, #-0]
    1750:	00000abf 			; <UNDEFINED> instruction: 0x00000abf
    1754:	5a0a2806 	bpl	28b774 <_bss_end+0x2824c8>
    1758:	07000008 	streq	r0, [r0, -r8]
    175c:	01000005 	tsteq	r0, r5
    1760:	00000744 	andeq	r0, r0, r4, asr #14
    1764:	00075212 	andeq	r5, r7, r2, lsl r2
    1768:	16000000 	strne	r0, [r0], -r0
    176c:	00075104 	andeq	r5, r7, r4, lsl #2
    1770:	04161b00 	ldreq	r1, [r6], #-2816	; 0xfffff500
    1774:	00000653 	andeq	r0, r0, r3, asr r6
    1778:	00085318 	andeq	r5, r8, r8, lsl r3
    177c:	0f2b0600 	svceq	0x002b0600
    1780:	00000653 	andeq	r0, r0, r3, asr r6
    1784:	0006221c 	andeq	r2, r6, ip, lsl r2
    1788:	171d0100 	ldrne	r0, [sp, -r0, lsl #2]
    178c:	92940305 	addsls	r0, r4, #335544320	; 0x14000000
    1790:	601d0000 	andsvs	r0, sp, r0
    1794:	f800000e 			; <UNDEFINED> instruction: 0xf800000e
    1798:	1c00008e 	stcne	0, cr0, [r0], {142}	; 0x8e
    179c:	01000000 	mrseq	r0, (UNDEF: 0)
    17a0:	06311e9c 			; <UNDEFINED> instruction: 0x06311e9c
    17a4:	8ea40000 	cdphi	0, 10, cr0, cr4, cr0, {0}
    17a8:	00540000 	subseq	r0, r4, r0
    17ac:	9c010000 	stcls	0, cr0, [r1], {-0}
    17b0:	000007b3 			; <UNDEFINED> instruction: 0x000007b3
    17b4:	0004db1f 	andeq	sp, r4, pc, lsl fp
    17b8:	013f0100 	teqeq	pc, r0, lsl #2
    17bc:	00000033 	andeq	r0, r0, r3, lsr r0
    17c0:	1f749102 	svcne	0x00749102
    17c4:	0000071c 	andeq	r0, r0, ip, lsl r7
    17c8:	33013f01 	movwcc	r3, #7937	; 0x1f01
    17cc:	02000000 	andeq	r0, r0, #0
    17d0:	20007091 	mulcs	r0, r1, r0
    17d4:	000005ee 	andeq	r0, r0, lr, ror #11
    17d8:	cd063a01 	vstrgt	s6, [r6, #-4]
    17dc:	3c000007 	stccc	0, cr0, [r0], {7}
    17e0:	6800008e 	stmdavs	r0, {r1, r2, r3, r7}
    17e4:	01000000 	mrseq	r0, (UNDEF: 0)
    17e8:	0007f89c 	muleq	r7, ip, r8
    17ec:	06642100 	strbteq	r2, [r4], -r0, lsl #2
    17f0:	061d0000 	ldreq	r0, [sp], -r0
    17f4:	91020000 	mrsls	r0, (UNDEF: 2)
    17f8:	0efe1f64 	cdpeq	15, 15, cr1, cr14, cr4, {3}
    17fc:	3a010000 	bcc	41804 <_bss_end+0x38558>
    1800:	00017139 	andeq	r7, r1, r9, lsr r1
    1804:	60910200 	addsvs	r0, r1, r0, lsl #4
    1808:	000b1022 	andeq	r1, fp, r2, lsr #32
    180c:	183c0100 	ldmdane	ip!, {r8}
    1810:	0000006c 	andeq	r0, r0, ip, rrx
    1814:	006c9102 	rsbeq	r9, ip, r2, lsl #2
    1818:	0005ce20 	andeq	ip, r5, r0, lsr #28
    181c:	06330100 	ldrteq	r0, [r3], -r0, lsl #2
    1820:	00000812 	andeq	r0, r0, r2, lsl r8
    1824:	00008dd4 	ldrdeq	r8, [r0], -r4
    1828:	00000068 	andeq	r0, r0, r8, rrx
    182c:	083d9c01 	ldmdaeq	sp!, {r0, sl, fp, ip, pc}
    1830:	64210000 	strtvs	r0, [r1], #-0
    1834:	1d000006 	stcne	0, cr0, [r0, #-24]	; 0xffffffe8
    1838:	02000006 	andeq	r0, r0, #6
    183c:	fe1f6491 	mrc2	4, 0, r6, cr15, cr1, {4}
    1840:	0100000e 	tsteq	r0, lr
    1844:	01713833 	cmneq	r1, r3, lsr r8
    1848:	91020000 	mrsls	r0, (UNDEF: 2)
    184c:	0b102260 	bleq	40a1d4 <_bss_end+0x400f28>
    1850:	35010000 	strcc	r0, [r1, #-0]
    1854:	00006c18 	andeq	r6, r0, r8, lsl ip
    1858:	6c910200 	lfmvs	f0, 4, [r1], {0}
    185c:	05ae2000 	streq	r2, [lr, #0]!
    1860:	2e010000 	cdpcs	0, 0, cr0, cr1, cr0, {0}
    1864:	00085706 	andeq	r5, r8, r6, lsl #14
    1868:	008d9000 	addeq	r9, sp, r0
    186c:	00004400 	andeq	r4, r0, r0, lsl #8
    1870:	739c0100 	orrsvc	r0, ip, #0, 2
    1874:	21000008 	tstcs	r0, r8
    1878:	00000664 	andeq	r0, r0, r4, ror #12
    187c:	0000061d 	andeq	r0, r0, sp, lsl r6
    1880:	1f6c9102 	svcne	0x006c9102
    1884:	00000efe 	strdeq	r0, [r0], -lr
    1888:	2e452e01 	cdpcs	14, 4, cr2, cr5, cr1, {0}
    188c:	02000001 	andeq	r0, r0, #1
    1890:	20006891 	mulcs	r0, r1, r8
    1894:	0000058e 	andeq	r0, r0, lr, lsl #11
    1898:	8d062901 	vstrhi.16	s4, [r6, #-2]	; <UNPREDICTABLE>
    189c:	4c000008 	stcmi	0, cr0, [r0], {8}
    18a0:	4400008d 	strmi	r0, [r0], #-141	; 0xffffff73
    18a4:	01000000 	mrseq	r0, (UNDEF: 0)
    18a8:	0008a99c 	muleq	r8, ip, r9
    18ac:	06642100 	strbteq	r2, [r4], -r0, lsl #2
    18b0:	061d0000 	ldreq	r0, [sp], -r0
    18b4:	91020000 	mrsls	r0, (UNDEF: 2)
    18b8:	0efe1f6c 	cdpeq	15, 15, cr1, cr14, cr12, {3}
    18bc:	29010000 	stmdbcs	r1, {}	; <UNPREDICTABLE>
    18c0:	00012e44 	andeq	r2, r1, r4, asr #28
    18c4:	68910200 	ldmvs	r1, {r9}
    18c8:	05462300 	strbeq	r2, [r6, #-768]	; 0xfffffd00
    18cc:	24010000 	strcs	r0, [r1], #-0
    18d0:	0008c318 	andeq	ip, r8, r8, lsl r3
    18d4:	008d1400 	addeq	r1, sp, r0, lsl #8
    18d8:	00003800 	andeq	r3, r0, r0, lsl #16
    18dc:	df9c0100 	svcle	0x009c0100
    18e0:	21000008 	tstcs	r0, r8
    18e4:	00000664 	andeq	r0, r0, r4, ror #12
    18e8:	0000061d 	andeq	r0, r0, sp, lsl r6
    18ec:	24749102 	ldrbtcs	r9, [r4], #-258	; 0xfffffefe
    18f0:	00676572 	rsbeq	r6, r7, r2, ror r5
    18f4:	df522401 	svcle	0x00522401
    18f8:	02000000 	andeq	r0, r0, #0
    18fc:	25007091 	strcs	r7, [r0, #-145]	; 0xffffff6f
    1900:	0000056a 	andeq	r0, r0, sl, ror #10
    1904:	f0011f01 			; <UNDEFINED> instruction: 0xf0011f01
    1908:	00000008 	andeq	r0, r0, r8
    190c:	00000906 	andeq	r0, r0, r6, lsl #18
    1910:	00066426 	andeq	r6, r6, r6, lsr #8
    1914:	00061d00 	andeq	r1, r6, r0, lsl #26
    1918:	0a482700 	beq	120b520 <_bss_end+0x1202274>
    191c:	1f010000 	svcne	0x00010000
    1920:	00022d3c 	andeq	r2, r2, ip, lsr sp
    1924:	df280000 	svcle	0x00280000
    1928:	77000008 	strvc	r0, [r0, -r8]
    192c:	2100000b 	tstcs	r0, fp
    1930:	e0000009 	and	r0, r0, r9
    1934:	3400008c 	strcc	r0, [r0], #-140	; 0xffffff74
    1938:	01000000 	mrseq	r0, (UNDEF: 0)
    193c:	0009329c 	muleq	r9, ip, r2
    1940:	08f02900 	ldmeq	r0!, {r8, fp, sp}^
    1944:	91020000 	mrsls	r0, (UNDEF: 2)
    1948:	08f92974 	ldmeq	r9!, {r2, r4, r5, r6, r8, fp, sp}^
    194c:	91020000 	mrsls	r0, (UNDEF: 2)
    1950:	b42a0070 	strtlt	r0, [sl], #-112	; 0xffffff90
    1954:	0100000c 	tsteq	r0, ip
    1958:	8cd03319 	ldclhi	3, cr3, [r0], {25}
    195c:	00100000 	andseq	r0, r0, r0
    1960:	9c010000 	stcls	0, cr0, [r1], {-0}
    1964:	000e542b 	andeq	r5, lr, fp, lsr #8
    1968:	330b0100 	movwcc	r0, #45312	; 0xb100
    196c:	00008c50 	andeq	r8, r0, r0, asr ip
    1970:	00000080 	andeq	r0, r0, r0, lsl #1
    1974:	096d9c01 	stmdbeq	sp!, {r0, sl, fp, ip, pc}^
    1978:	c3220000 			; <UNDEFINED> instruction: 0xc3220000
    197c:	0100000d 	tsteq	r0, sp
    1980:	0507110d 	streq	r1, [r7, #-269]	; 0xfffffef3
    1984:	03050000 	movweq	r0, #20480	; 0x5000
    1988:	00009284 	andeq	r9, r0, r4, lsl #5
    198c:	0e6f2a00 	vmuleq.f32	s5, s30, s0
    1990:	07010000 	streq	r0, [r1, -r0]
    1994:	008c3833 	addeq	r3, ip, r3, lsr r8
    1998:	00001800 	andeq	r1, r0, r0, lsl #16
    199c:	009c0100 	addseq	r0, ip, r0, lsl #2
    19a0:	0000079b 	muleq	r0, fp, r7
    19a4:	08750004 	ldmdaeq	r5!, {r2}^
    19a8:	01040000 	mrseq	r0, (UNDEF: 4)
    19ac:	00000000 	andeq	r0, r0, r0
    19b0:	000f4b04 	andeq	r4, pc, r4, lsl #22
    19b4:	0000f600 	andeq	pc, r0, r0, lsl #12
    19b8:	008f1400 	addeq	r1, pc, r0, lsl #8
    19bc:	00011c00 	andeq	r1, r1, r0, lsl #24
    19c0:	0009c500 	andeq	ip, r9, r0, lsl #10
    19c4:	08010200 	stmdaeq	r1, {r9}
    19c8:	00000549 	andeq	r0, r0, r9, asr #10
    19cc:	b7050202 	strlt	r0, [r5, -r2, lsl #4]
    19d0:	03000002 	movweq	r0, #2
    19d4:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
    19d8:	33040074 	movwcc	r0, #16500	; 0x4074
    19dc:	05000000 	streq	r0, [r0, #-0]
    19e0:	00000392 	muleq	r0, r2, r3
    19e4:	4b070902 	blmi	1c3df4 <_bss_end+0x1bab48>
    19e8:	02000000 	andeq	r0, r0, #0
    19ec:	05400801 	strbeq	r0, [r0, #-2049]	; 0xfffff7ff
    19f0:	02020000 	andeq	r0, r2, #0
    19f4:	0005a107 	andeq	sl, r5, r7, lsl #2
    19f8:	03a80500 			; <UNDEFINED> instruction: 0x03a80500
    19fc:	0b020000 	bleq	81a04 <_bss_end+0x78758>
    1a00:	00006a07 	andeq	r6, r0, r7, lsl #20
    1a04:	00590600 	subseq	r0, r9, r0, lsl #12
    1a08:	04020000 	streq	r0, [r2], #-0
    1a0c:	00158c07 	andseq	r8, r5, r7, lsl #24
    1a10:	006a0600 	rsbeq	r0, sl, r0, lsl #12
    1a14:	6a040000 	bvs	101a1c <_bss_end+0xf8770>
    1a18:	07000000 	streq	r0, [r0, -r0]
    1a1c:	000006d3 	ldrdeq	r0, [r0], -r3
    1a20:	003f0107 	eorseq	r0, pc, r7, lsl #2
    1a24:	06030000 	streq	r0, [r3], -r0
    1a28:	0000c40c 	andeq	ip, r0, ip, lsl #8
    1a2c:	07720800 	ldrbeq	r0, [r2, -r0, lsl #16]!
    1a30:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    1a34:	00000783 	andeq	r0, r0, r3, lsl #15
    1a38:	08370801 	ldmdaeq	r7!, {r0, fp}
    1a3c:	08020000 	stmdaeq	r2, {}	; <UNPREDICTABLE>
    1a40:	00000831 	andeq	r0, r0, r1, lsr r8
    1a44:	080c0803 	stmdaeq	ip, {r0, r1, fp}
    1a48:	08040000 	stmdaeq	r4, {}	; <UNPREDICTABLE>
    1a4c:	00000812 	andeq	r0, r0, r2, lsl r8
    1a50:	06ee0805 	strbteq	r0, [lr], r5, lsl #16
    1a54:	08060000 	stmdaeq	r6, {}	; <UNPREDICTABLE>
    1a58:	0000082b 	andeq	r0, r0, fp, lsr #16
    1a5c:	03b60807 			; <UNDEFINED> instruction: 0x03b60807
    1a60:	00080000 	andeq	r0, r8, r0
    1a64:	00030007 	andeq	r0, r3, r7
    1a68:	33040500 	movwcc	r0, #17664	; 0x4500
    1a6c:	03000000 	movweq	r0, #0
    1a70:	00ef0c18 	rsceq	r0, pc, r8, lsl ip	; <UNPREDICTABLE>
    1a74:	e2080000 	and	r0, r8, #0
    1a78:	00000006 	andeq	r0, r0, r6
    1a7c:	0007ff08 	andeq	pc, r7, r8, lsl #30
    1a80:	b2080100 	andlt	r0, r8, #0, 2
    1a84:	02000002 	andeq	r0, r0, #2
    1a88:	776f4c09 	strbvc	r4, [pc, -r9, lsl #24]!
    1a8c:	0a000300 	beq	2694 <CPSR_IRQ_INHIBIT+0x2614>
    1a90:	0000043d 	andeq	r0, r0, sp, lsr r4
    1a94:	07230304 	streq	r0, [r3, -r4, lsl #6]!
    1a98:	0000031b 	andeq	r0, r0, fp, lsl r3
    1a9c:	0003750b 	andeq	r7, r3, fp, lsl #10
    1aa0:	19270300 	stmdbne	r7!, {r8, r9}
    1aa4:	00000326 	andeq	r0, r0, r6, lsr #6
    1aa8:	05fe0c00 	ldrbeq	r0, [lr, #3072]!	; 0xc00
    1aac:	2b030000 	blcs	c1ab4 <_bss_end+0xb8808>
    1ab0:	0003450a 	andeq	r4, r3, sl, lsl #10
    1ab4:	00032b00 	andeq	r2, r3, r0, lsl #22
    1ab8:	01220200 			; <UNDEFINED> instruction: 0x01220200
    1abc:	01370000 	teqeq	r7, r0
    1ac0:	320d0000 	andcc	r0, sp, #0
    1ac4:	0e000003 	cdpeq	0, 0, cr0, cr0, cr3, {0}
    1ac8:	00000059 	andeq	r0, r0, r9, asr r0
    1acc:	0003380e 	andeq	r3, r3, lr, lsl #16
    1ad0:	03380e00 	teqeq	r8, #0, 28
    1ad4:	0c000000 	stceq	0, cr0, [r0], {-0}
    1ad8:	0000075f 	andeq	r0, r0, pc, asr r7
    1adc:	110a2d03 	tstne	sl, r3, lsl #26
    1ae0:	2b000005 	blcs	1afc <CPSR_IRQ_INHIBIT+0x1a7c>
    1ae4:	02000003 	andeq	r0, r0, #3
    1ae8:	00000150 	andeq	r0, r0, r0, asr r1
    1aec:	00000165 	andeq	r0, r0, r5, ror #2
    1af0:	0003320d 	andeq	r3, r3, sp, lsl #4
    1af4:	00590e00 	subseq	r0, r9, r0, lsl #28
    1af8:	380e0000 	stmdacc	lr, {}	; <UNPREDICTABLE>
    1afc:	0e000003 	cdpeq	0, 0, cr0, cr0, cr3, {0}
    1b00:	00000338 	andeq	r0, r0, r8, lsr r3
    1b04:	044b0c00 	strbeq	r0, [fp], #-3072	; 0xfffff400
    1b08:	2f030000 	svccs	0x00030000
    1b0c:	0007270a 	andeq	r2, r7, sl, lsl #14
    1b10:	00032b00 	andeq	r2, r3, r0, lsl #22
    1b14:	017e0200 	cmneq	lr, r0, lsl #4
    1b18:	01930000 	orrseq	r0, r3, r0
    1b1c:	320d0000 	andcc	r0, sp, #0
    1b20:	0e000003 	cdpeq	0, 0, cr0, cr0, cr3, {0}
    1b24:	00000059 	andeq	r0, r0, r9, asr r0
    1b28:	0003380e 	andeq	r3, r3, lr, lsl #16
    1b2c:	03380e00 	teqeq	r8, #0, 28
    1b30:	0c000000 	stceq	0, cr0, [r0], {-0}
    1b34:	0000049f 	muleq	r0, pc, r4	; <UNPREDICTABLE>
    1b38:	f60a3103 			; <UNDEFINED> instruction: 0xf60a3103
    1b3c:	2b000001 	blcs	1b48 <CPSR_IRQ_INHIBIT+0x1ac8>
    1b40:	02000003 	andeq	r0, r0, #3
    1b44:	000001ac 	andeq	r0, r0, ip, lsr #3
    1b48:	000001c1 	andeq	r0, r0, r1, asr #3
    1b4c:	0003320d 	andeq	r3, r3, sp, lsl #4
    1b50:	00590e00 	subseq	r0, r9, r0, lsl #28
    1b54:	380e0000 	stmdacc	lr, {}	; <UNPREDICTABLE>
    1b58:	0e000003 	cdpeq	0, 0, cr0, cr0, cr3, {0}
    1b5c:	00000338 	andeq	r0, r0, r8, lsr r3
    1b60:	029f0c00 	addseq	r0, pc, #0, 24
    1b64:	32030000 	andcc	r0, r3, #0
    1b68:	0005cf0a 	andeq	ip, r5, sl, lsl #30
    1b6c:	00032b00 	andeq	r2, r3, r0, lsl #22
    1b70:	01da0200 	bicseq	r0, sl, r0, lsl #4
    1b74:	01ef0000 	mvneq	r0, r0
    1b78:	320d0000 	andcc	r0, sp, #0
    1b7c:	0e000003 	cdpeq	0, 0, cr0, cr0, cr3, {0}
    1b80:	00000059 	andeq	r0, r0, r9, asr r0
    1b84:	0003380e 	andeq	r3, r3, lr, lsl #16
    1b88:	03380e00 	teqeq	r8, #0, 28
    1b8c:	0c000000 	stceq	0, cr0, [r0], {-0}
    1b90:	0000043d 	andeq	r0, r0, sp, lsr r4
    1b94:	7b053503 	blvc	14efa8 <_bss_end+0x145cfc>
    1b98:	3e000003 	cdpcc	0, 0, cr0, cr0, cr3, {0}
    1b9c:	01000003 	tsteq	r0, r3
    1ba0:	00000208 	andeq	r0, r0, r8, lsl #4
    1ba4:	00000213 	andeq	r0, r0, r3, lsl r2
    1ba8:	00033e0d 	andeq	r3, r3, sp, lsl #28
    1bac:	006a0e00 	rsbeq	r0, sl, r0, lsl #28
    1bb0:	0f000000 	svceq	0x00000000
    1bb4:	00000702 	andeq	r0, r0, r2, lsl #14
    1bb8:	aa0a3803 	bge	28fbcc <_bss_end+0x286920>
    1bbc:	01000006 	tsteq	r0, r6
    1bc0:	00000228 	andeq	r0, r0, r8, lsr #4
    1bc4:	00000238 	andeq	r0, r0, r8, lsr r2
    1bc8:	00033e0d 	andeq	r3, r3, sp, lsl #28
    1bcc:	00590e00 	subseq	r0, r9, r0, lsl #28
    1bd0:	7b0e0000 	blvc	381bd8 <_bss_end+0x37892c>
    1bd4:	00000000 	andeq	r0, r0, r0
    1bd8:	00042b0c 	andeq	r2, r4, ip, lsl #22
    1bdc:	143a0300 	ldrtne	r0, [sl], #-768	; 0xfffffd00
    1be0:	000004b2 			; <UNDEFINED> instruction: 0x000004b2
    1be4:	0000007b 	andeq	r0, r0, fp, ror r0
    1be8:	00025101 	andeq	r5, r2, r1, lsl #2
    1bec:	00025c00 	andeq	r5, r2, r0, lsl #24
    1bf0:	03320d00 	teqeq	r2, #0, 26
    1bf4:	590e0000 	stmdbpl	lr, {}	; <UNPREDICTABLE>
    1bf8:	00000000 	andeq	r0, r0, r0
    1bfc:	00077f0f 	andeq	r7, r7, pc, lsl #30
    1c00:	0a3d0300 	beq	f42808 <_bss_end+0xf3955c>
    1c04:	00000323 	andeq	r0, r0, r3, lsr #6
    1c08:	00027101 	andeq	r7, r2, r1, lsl #2
    1c0c:	00028100 	andeq	r8, r2, r0, lsl #2
    1c10:	033e0d00 	teqeq	lr, #0, 26
    1c14:	590e0000 	stmdbpl	lr, {}	; <UNPREDICTABLE>
    1c18:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    1c1c:	0000032b 	andeq	r0, r0, fp, lsr #6
    1c20:	03c20f00 	biceq	r0, r2, #0, 30
    1c24:	3f030000 	svccc	0x00030000
    1c28:	0004640a 	andeq	r6, r4, sl, lsl #8
    1c2c:	02960100 	addseq	r0, r6, #0, 2
    1c30:	02a10000 	adceq	r0, r1, #0
    1c34:	3e0d0000 	cdpcc	0, 0, cr0, cr13, cr0, {0}
    1c38:	0e000003 	cdpeq	0, 0, cr0, cr0, cr3, {0}
    1c3c:	00000059 	andeq	r0, r0, r9, asr r0
    1c40:	05bb0f00 	ldreq	r0, [fp, #3840]!	; 0xf00
    1c44:	41030000 	mrsmi	r0, (UNDEF: 3)
    1c48:	0002d50a 	andeq	sp, r2, sl, lsl #10
    1c4c:	02b60100 	adcseq	r0, r6, #0, 2
    1c50:	02c60000 	sbceq	r0, r6, #0
    1c54:	3e0d0000 	cdpcc	0, 0, cr0, cr13, cr0, {0}
    1c58:	0e000003 	cdpeq	0, 0, cr0, cr0, cr3, {0}
    1c5c:	00000059 	andeq	r0, r0, r9, asr r0
    1c60:	0000c40e 	andeq	ip, r0, lr, lsl #8
    1c64:	ea0f0000 	b	3c1c6c <_bss_end+0x3b89c0>
    1c68:	03000007 	movweq	r0, #7
    1c6c:	06690a42 	strbteq	r0, [r9], -r2, asr #20
    1c70:	db010000 	blle	41c78 <_bss_end+0x389cc>
    1c74:	eb000002 	bl	1c84 <CPSR_IRQ_INHIBIT+0x1c04>
    1c78:	0d000002 	stceq	0, cr0, [r0, #-8]
    1c7c:	0000033e 	andeq	r0, r0, lr, lsr r3
    1c80:	0000590e 	andeq	r5, r0, lr, lsl #18
    1c84:	00c40e00 	sbceq	r0, r4, r0, lsl #28
    1c88:	10000000 	andne	r0, r0, r0
    1c8c:	00000284 	andeq	r0, r0, r4, lsl #5
    1c90:	de0a4303 	cdple	3, 0, cr4, cr10, cr3, {0}
    1c94:	2b000003 	blcs	1ca8 <CPSR_IRQ_INHIBIT+0x1c28>
    1c98:	01000003 	tsteq	r0, r3
    1c9c:	00000300 	andeq	r0, r0, r0, lsl #6
    1ca0:	0003320d 	andeq	r3, r3, sp, lsl #4
    1ca4:	00590e00 	subseq	r0, r9, r0, lsl #28
    1ca8:	c40e0000 	strgt	r0, [lr], #-0
    1cac:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    1cb0:	00000338 	andeq	r0, r0, r8, lsr r3
    1cb4:	0003380e 	andeq	r3, r3, lr, lsl #16
    1cb8:	06000000 	streq	r0, [r0], -r0
    1cbc:	000000ef 	andeq	r0, r0, pc, ror #1
    1cc0:	006a0411 	rsbeq	r0, sl, r1, lsl r4
    1cc4:	20060000 	andcs	r0, r6, r0
    1cc8:	02000003 	andeq	r0, r0, #3
    1ccc:	03b10201 			; <UNDEFINED> instruction: 0x03b10201
    1cd0:	04110000 	ldreq	r0, [r1], #-0
    1cd4:	0000031b 	andeq	r0, r0, fp, lsl r3
    1cd8:	00590412 	subseq	r0, r9, r2, lsl r4
    1cdc:	04110000 	ldreq	r0, [r1], #-0
    1ce0:	000000ef 	andeq	r0, r0, pc, ror #1
    1ce4:	00055d13 	andeq	r5, r5, r3, lsl sp
    1ce8:	16470300 	strbne	r0, [r7], -r0, lsl #6
    1cec:	000000ef 	andeq	r0, r0, pc, ror #1
    1cf0:	6c616814 	stclvs	8, cr6, [r1], #-80	; 0xffffffb0
    1cf4:	0b070400 	bleq	1c2cfc <_bss_end+0x1b9a50>
    1cf8:	00000502 	andeq	r0, r0, r2, lsl #10
    1cfc:	00081815 	andeq	r1, r8, r5, lsl r8
    1d00:	1c090400 	cfstrsne	mvf0, [r9], {-0}
    1d04:	00000071 	andeq	r0, r0, r1, ror r0
    1d08:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}
    1d0c:	00048f15 	andeq	r8, r4, r5, lsl pc
    1d10:	1d0c0400 	cfstrsne	mvf0, [ip, #-0]
    1d14:	0000050e 	andeq	r0, r0, lr, lsl #10
    1d18:	20000000 	andcs	r0, r0, r0
    1d1c:	00056315 	andeq	r6, r5, r5, lsl r3
    1d20:	1d0f0400 	cfstrsne	mvf0, [pc, #-0]	; 1d28 <CPSR_IRQ_INHIBIT+0x1ca8>
    1d24:	0000050e 	andeq	r0, r0, lr, lsl #10
    1d28:	20200000 	eorcs	r0, r0, r0
    1d2c:	00061216 	andeq	r1, r6, r6, lsl r2
    1d30:	18120400 	ldmdane	r2, {sl}
    1d34:	00000065 	andeq	r0, r0, r5, rrx
    1d38:	07561536 	smmlareq	r6, r6, r5, r1
    1d3c:	44040000 	strmi	r0, [r4], #-0
    1d40:	00050e1d 	andeq	r0, r5, sp, lsl lr
    1d44:	21500000 	cmpcs	r0, r0
    1d48:	026a1520 	rsbeq	r1, sl, #32, 10	; 0x8000000
    1d4c:	73040000 	movwvc	r0, #16384	; 0x4000
    1d50:	00050e1d 	andeq	r0, r5, sp, lsl lr
    1d54:	00b20000 	adcseq	r0, r2, r0
    1d58:	0bb50720 	bleq	fed439e0 <_bss_end+0xfed3a734>
    1d5c:	04050000 	streq	r0, [r5], #-0
    1d60:	00000033 	andeq	r0, r0, r3, lsr r0
    1d64:	08107504 	ldmdaeq	r0, {r2, r8, sl, ip, sp, lr}
    1d68:	08000004 	stmdaeq	r0, {r2}
    1d6c:	00000ccb 	andeq	r0, r0, fp, asr #25
    1d70:	0e9b0800 	cdpeq	8, 9, cr0, cr11, cr0, {0}
    1d74:	08010000 	stmdaeq	r1, {}	; <UNPREDICTABLE>
    1d78:	00000ec2 	andeq	r0, r0, r2, asr #29
    1d7c:	0e480802 	cdpeq	8, 4, cr0, cr8, cr2, {0}
    1d80:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    1d84:	00000b96 	muleq	r0, r6, fp
    1d88:	0ba30804 	bleq	fe8c3da0 <_bss_end+0xfe8baaf4>
    1d8c:	08050000 	stmdaeq	r5, {}	; <UNPREDICTABLE>
    1d90:	00000e8a 	andeq	r0, r0, sl, lsl #29
    1d94:	0f090806 	svceq	0x00090806
    1d98:	08070000 	stmdaeq	r7, {}	; <UNPREDICTABLE>
    1d9c:	00000f17 	andeq	r0, r0, r7, lsl pc
    1da0:	0cff0808 	ldcleq	8, cr0, [pc], #32	; 1dc8 <CPSR_IRQ_INHIBIT+0x1d48>
    1da4:	00090000 	andeq	r0, r9, r0
    1da8:	000bf007 	andeq	pc, fp, r7
    1dac:	33040500 	movwcc	r0, #17664	; 0x4500
    1db0:	04000000 	streq	r0, [r0], #-0
    1db4:	044b1083 	strbeq	r1, [fp], #-131	; 0xffffff7d
    1db8:	72080000 	andvc	r0, r8, #0
    1dbc:	0000000a 	andeq	r0, r0, sl
    1dc0:	000b6408 	andeq	r6, fp, r8, lsl #8
    1dc4:	69080100 	stmdbvs	r8, {r8}
    1dc8:	0200000d 	andeq	r0, r0, #13
    1dcc:	000d7408 	andeq	r7, sp, r8, lsl #8
    1dd0:	7f080300 	svcvc	0x00080300
    1dd4:	0400000d 	streq	r0, [r0], #-13
    1dd8:	000b5a08 	andeq	r5, fp, r8, lsl #20
    1ddc:	ce080500 	cfsh32gt	mvfx0, mvfx8, #0
    1de0:	0600000b 	streq	r0, [r0], -fp
    1de4:	000bdf08 	andeq	sp, fp, r8, lsl #30
    1de8:	07000700 	streq	r0, [r0, -r0, lsl #14]
    1dec:	00000ea9 	andeq	r0, r0, r9, lsr #29
    1df0:	00330405 	eorseq	r0, r3, r5, lsl #8
    1df4:	8f040000 	svchi	0x00040000
    1df8:	0004ac10 	andeq	sl, r4, r0, lsl ip
    1dfc:	55410900 	strbpl	r0, [r1, #-2304]	; 0xfffff700
    1e00:	081d0058 	ldmdaeq	sp, {r3, r4, r6}
    1e04:	00000e35 	andeq	r0, r0, r5, lsr lr
    1e08:	0f25082b 	svceq	0x0025082b
    1e0c:	082d0000 	stmdaeq	sp!, {}	; <UNPREDICTABLE>
    1e10:	00000f2b 	andeq	r0, r0, fp, lsr #30
    1e14:	4d53092e 	vldrmi.16	s1, [r3, #-92]	; 0xffffffa4	; <UNPREDICTABLE>
    1e18:	08300049 	ldmdaeq	r0!, {r0, r3, r6}
    1e1c:	00000ed0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    1e20:	0ed70831 	mrceq	8, 6, r0, cr7, cr1, {1}
    1e24:	08320000 	ldmdaeq	r2!, {}	; <UNPREDICTABLE>
    1e28:	00000ede 	ldrdeq	r0, [r0], -lr
    1e2c:	0ee50833 	mcreq	8, 7, r0, cr5, cr3, {1}
    1e30:	09340000 	ldmdbeq	r4!, {}	; <UNPREDICTABLE>
    1e34:	00433249 	subeq	r3, r3, r9, asr #4
    1e38:	50530935 	subspl	r0, r3, r5, lsr r9
    1e3c:	09360049 	ldmdbeq	r6!, {r0, r3, r6}
    1e40:	004d4350 	subeq	r4, sp, r0, asr r3
    1e44:	0bb00837 	bleq	fec03f28 <_bss_end+0xfebfac7c>
    1e48:	00390000 	eorseq	r0, r9, r0
    1e4c:	00062615 	andeq	r2, r6, r5, lsl r6
    1e50:	1da60400 	cfstrsne	mvf0, [r6]
    1e54:	0000050e 	andeq	r0, r0, lr, lsl #10
    1e58:	2000b400 	andcs	fp, r0, r0, lsl #8
    1e5c:	000a1f17 	andeq	r1, sl, r7, lsl pc
    1e60:	33040500 	movwcc	r0, #17664	; 0x4500
    1e64:	04000000 	streq	r0, [r0], #-0
    1e68:	6c0810a8 	stcvs	0, cr1, [r8], {168}	; 0xa8
    1e6c:	0000000a 	andeq	r0, r0, sl
    1e70:	00099108 	andeq	r9, r9, r8, lsl #2
    1e74:	4c080100 	stfmis	f0, [r8], {-0}
    1e78:	0200000e 	andeq	r0, r0, #14
    1e7c:	00096e08 	andeq	r6, r9, r8, lsl #28
    1e80:	e4080300 	str	r0, [r8], #-768	; 0xfffffd00
    1e84:	0400000a 	streq	r0, [r0], #-10
    1e88:	0008b408 	andeq	fp, r8, r8, lsl #8
    1e8c:	a0080500 	andge	r0, r8, r0, lsl #10
    1e90:	06000008 	streq	r0, [r0], -r8
    1e94:	000a1308 	andeq	r1, sl, r8, lsl #6
    1e98:	b2080700 	andlt	r0, r8, #0, 14
    1e9c:	0800000a 	stmdaeq	r0, {r1, r3}
    1ea0:	5c180000 	ldcpl	0, cr0, [r8], {-0}
    1ea4:	02000003 	andeq	r0, r0, #3
    1ea8:	15870704 	strne	r0, [r7, #1796]	; 0x704
    1eac:	07060000 	streq	r0, [r6, -r0]
    1eb0:	18000005 	stmdane	r0, {r0, r2}
    1eb4:	0000036c 	andeq	r0, r0, ip, ror #6
    1eb8:	00037c18 	andeq	r7, r3, r8, lsl ip
    1ebc:	038c1800 	orreq	r1, ip, #0, 16
    1ec0:	99180000 	ldmdbls	r8, {}	; <UNPREDICTABLE>
    1ec4:	18000003 	stmdane	r0, {r0, r1}
    1ec8:	000003a9 	andeq	r0, r0, r9, lsr #7
    1ecc:	0004ac18 	andeq	sl, r4, r8, lsl ip
    1ed0:	0ce90a00 	vstmiaeq	r9!, {s1-s0}
    1ed4:	05040000 	streq	r0, [r4, #-0]
    1ed8:	06100709 	ldreq	r0, [r0], -r9, lsl #14
    1edc:	690b0000 	stmdbvs	fp, {}	; <UNPREDICTABLE>
    1ee0:	0500000c 	streq	r0, [r0, #-12]
    1ee4:	06101c0d 	ldreq	r1, [r0], -sp, lsl #24
    1ee8:	0c000000 	stceq	0, cr0, [r0], {-0}
    1eec:	0000098c 	andeq	r0, r0, ip, lsl #19
    1ef0:	191c1005 	ldmdbne	ip, {r0, r2, ip}
    1ef4:	1600000b 	strne	r0, [r0], -fp
    1ef8:	02000006 	andeq	r0, r0, #6
    1efc:	00000564 	andeq	r0, r0, r4, ror #10
    1f00:	0000056f 	andeq	r0, r0, pc, ror #10
    1f04:	00061c0d 	andeq	r1, r6, sp, lsl #24
    1f08:	03b90e00 			; <UNDEFINED> instruction: 0x03b90e00
    1f0c:	0c000000 	stceq	0, cr0, [r0], {-0}
    1f10:	00000ce9 	andeq	r0, r0, r9, ror #25
    1f14:	16051305 	strne	r1, [r5], -r5, lsl #6
    1f18:	1c00000e 	stcne	0, cr0, [r0], {14}
    1f1c:	01000006 	tsteq	r0, r6
    1f20:	00000588 	andeq	r0, r0, r8, lsl #11
    1f24:	00000593 	muleq	r0, r3, r5
    1f28:	00061c0d 	andeq	r1, r6, sp, lsl #24
    1f2c:	05070e00 	streq	r0, [r7, #-3584]	; 0xfffff200
    1f30:	0f000000 	svceq	0x00000000
    1f34:	00000d11 	andeq	r0, r0, r1, lsl sp
    1f38:	d00a1605 	andle	r1, sl, r5, lsl #12
    1f3c:	0100000d 	tsteq	r0, sp
    1f40:	000005a8 	andeq	r0, r0, r8, lsr #11
    1f44:	000005b3 			; <UNDEFINED> instruction: 0x000005b3
    1f48:	00061c0d 	andeq	r1, r6, sp, lsl #24
    1f4c:	04080e00 	streq	r0, [r8], #-3584	; 0xfffff200
    1f50:	0f000000 	svceq	0x00000000
    1f54:	00000eec 	andeq	r0, r0, ip, ror #29
    1f58:	220a1805 	andcs	r1, sl, #327680	; 0x50000
    1f5c:	0100000d 	tsteq	r0, sp
    1f60:	000005c8 	andeq	r0, r0, r8, asr #11
    1f64:	000005d3 	ldrdeq	r0, [r0], -r3
    1f68:	00061c0d 	andeq	r1, r6, sp, lsl #24
    1f6c:	04080e00 	streq	r0, [r8], #-3584	; 0xfffff200
    1f70:	0f000000 	svceq	0x00000000
    1f74:	00000b6c 	andeq	r0, r0, ip, ror #22
    1f78:	890a1b05 	stmdbhi	sl, {r0, r2, r8, r9, fp, ip}
    1f7c:	0100000d 	tsteq	r0, sp
    1f80:	000005e8 	andeq	r0, r0, r8, ror #11
    1f84:	000005f3 	strdeq	r0, [r0], -r3
    1f88:	00061c0d 	andeq	r1, r6, sp, lsl #24
    1f8c:	044b0e00 	strbeq	r0, [fp], #-3584	; 0xfffff200
    1f90:	19000000 	stmdbne	r0, {}	; <UNPREDICTABLE>
    1f94:	00000cdd 	ldrdeq	r0, [r0], -sp
    1f98:	790a1d05 	stmdbvc	sl, {r0, r2, r8, sl, fp, ip}
    1f9c:	0100000c 	tsteq	r0, ip
    1fa0:	00000604 	andeq	r0, r0, r4, lsl #12
    1fa4:	00061c0d 	andeq	r1, r6, sp, lsl #24
    1fa8:	044b0e00 	strbeq	r0, [fp], #-3584	; 0xfffff200
    1fac:	00000000 	andeq	r0, r0, r0
    1fb0:	00760411 	rsbseq	r0, r6, r1, lsl r4
    1fb4:	04120000 	ldreq	r0, [r2], #-0
    1fb8:	00000076 	andeq	r0, r0, r6, ror r0
    1fbc:	05310411 	ldreq	r0, [r1, #-1041]!	; 0xfffffbef
    1fc0:	b4130000 	ldrlt	r0, [r3], #-0
    1fc4:	0500000e 	streq	r0, [r0, #-14]
    1fc8:	05311e20 	ldreq	r1, [r1, #-3616]!	; 0xfffff1e0
    1fcc:	26070000 	strcs	r0, [r7], -r0
    1fd0:	07000009 	streq	r0, [r0, -r9]
    1fd4:	00003f01 	andeq	r3, r0, r1, lsl #30
    1fd8:	0c060600 	stceq	6, cr0, [r6], {-0}
    1fdc:	00000653 	andeq	r0, r0, r3, asr r6
    1fe0:	00094e08 	andeq	r4, r9, r8, lsl #28
    1fe4:	78080000 	stmdavc	r8, {}	; <UNPREDICTABLE>
    1fe8:	01000009 	tsteq	r0, r9
    1fec:	0008fe08 	andeq	pc, r8, r8, lsl #28
    1ff0:	0a000200 	beq	27f8 <CPSR_IRQ_INHIBIT+0x2778>
    1ff4:	00000a71 	andeq	r0, r0, r1, ror sl
    1ff8:	070d0608 	streq	r0, [sp, -r8, lsl #12]
    1ffc:	0000074b 	andeq	r0, r0, fp, asr #14
    2000:	0009850b 	andeq	r8, r9, fp, lsl #10
    2004:	1c150600 	ldcne	6, cr0, [r5], {-0}
    2008:	00000610 	andeq	r0, r0, r0, lsl r6
    200c:	0ad41a00 	beq	ff508814 <_bss_end+0xff4ff568>
    2010:	11060000 	mrsne	r0, (UNDEF: 6)
    2014:	00074b0b 	andeq	r4, r7, fp, lsl #22
    2018:	780b0100 	stmdavc	fp, {r8}
    201c:	0600000a 	streq	r0, [r0], -sl
    2020:	066d1518 			; <UNDEFINED> instruction: 0x066d1518
    2024:	0c040000 	stceq	0, cr0, [r4], {-0}
    2028:	0000098c 	andeq	r0, r0, ip, lsl #19
    202c:	821c1b06 	andshi	r1, ip, #6144	; 0x1800
    2030:	1600000a 	strne	r0, [r0], -sl
    2034:	02000006 	andeq	r0, r0, #6
    2038:	000006a0 	andeq	r0, r0, r0, lsr #13
    203c:	000006ab 	andeq	r0, r0, fp, lsr #13
    2040:	0007520d 	andeq	r5, r7, sp, lsl #4
    2044:	04bc0e00 	ldrteq	r0, [ip], #3584	; 0xe00
    2048:	0c000000 	stceq	0, cr0, [r0], {-0}
    204c:	00000a71 	andeq	r0, r0, r1, ror sl
    2050:	a3051e06 	movwge	r1, #24070	; 0x5e06
    2054:	5200000a 	andpl	r0, r0, #10
    2058:	01000007 	tsteq	r0, r7
    205c:	000006c4 	andeq	r0, r0, r4, asr #13
    2060:	000006cf 	andeq	r0, r0, pc, asr #13
    2064:	0007520d 	andeq	r5, r7, sp, lsl #4
    2068:	05070e00 	streq	r0, [r7, #-3584]	; 0xfffff200
    206c:	0f000000 	svceq	0x00000000
    2070:	00000e94 	muleq	r0, r4, lr
    2074:	0c0a2106 	stfeqs	f2, [sl], {6}
    2078:	01000009 	tsteq	r0, r9
    207c:	000006e4 	andeq	r0, r0, r4, ror #13
    2080:	000006f9 	strdeq	r0, [r0], -r9
    2084:	0007520d 	andeq	r5, r7, sp, lsl #4
    2088:	066d0e00 	strbteq	r0, [sp], -r0, lsl #28
    208c:	6a0e0000 	bvs	382094 <_bss_end+0x378de8>
    2090:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    2094:	0000062e 	andeq	r0, r0, lr, lsr #12
    2098:	0d090f00 	stceq	15, cr0, [r9, #-0]
    209c:	23060000 	movwcs	r0, #24576	; 0x6000
    20a0:	000a290a 	andeq	r2, sl, sl, lsl #18
    20a4:	070e0100 	streq	r0, [lr, -r0, lsl #2]
    20a8:	07140000 	ldreq	r0, [r4, -r0]
    20ac:	520d0000 	andpl	r0, sp, #0
    20b0:	00000007 	andeq	r0, r0, r7
    20b4:	0008a70f 	andeq	sl, r8, pc, lsl #14
    20b8:	0a260600 	beq	9838c0 <_bss_end+0x97a614>
    20bc:	00000aec 	andeq	r0, r0, ip, ror #21
    20c0:	00072901 	andeq	r2, r7, r1, lsl #18
    20c4:	00072f00 	andeq	r2, r7, r0, lsl #30
    20c8:	07520d00 	ldrbeq	r0, [r2, -r0, lsl #26]
    20cc:	10000000 	andne	r0, r0, r0
    20d0:	00000abf 			; <UNDEFINED> instruction: 0x00000abf
    20d4:	5a0a2806 	bpl	28c0f4 <_bss_end+0x282e48>
    20d8:	2b000008 	blcs	2100 <CPSR_IRQ_INHIBIT+0x2080>
    20dc:	01000003 	tsteq	r0, r3
    20e0:	00000744 	andeq	r0, r0, r4, asr #14
    20e4:	0007520d 	andeq	r5, r7, sp, lsl #4
    20e8:	11000000 	mrsne	r0, (UNDEF: 0)
    20ec:	00075104 	andeq	r5, r7, r4, lsl #2
    20f0:	04111b00 	ldreq	r1, [r1], #-2816	; 0xfffff500
    20f4:	00000653 	andeq	r0, r0, r3, asr r6
    20f8:	00085313 	andeq	r5, r8, r3, lsl r3
    20fc:	0f2b0600 	svceq	0x002b0600
    2100:	00000653 	andeq	r0, r0, r3, asr r6
    2104:	000f311c 	andeq	r3, pc, ip, lsl r1	; <UNPREDICTABLE>
    2108:	0e050100 	adfeqs	f0, f5, f0
    210c:	0000003a 	andeq	r0, r0, sl, lsr r0
    2110:	92980305 	addsls	r0, r8, #335544320	; 0x14000000
    2114:	a31d0000 	tstge	sp, #0
    2118:	0100000f 	tsteq	r0, pc
    211c:	00331017 	eorseq	r1, r3, r7, lsl r0
    2120:	8f880000 	svchi	0x00880000
    2124:	00a80000 	adceq	r0, r8, r0
    2128:	9c010000 	stcls	0, cr0, [r1], {-0}
    212c:	000f3b1e 	andeq	r3, pc, lr, lsl fp	; <UNPREDICTABLE>
    2130:	11070100 	mrsne	r0, (UNDEF: 23)
    2134:	00008f14 	andeq	r8, r0, r4, lsl pc
    2138:	00000074 	andeq	r0, r0, r4, ror r0
    213c:	1e009c01 	cdpne	12, 0, cr9, cr0, cr1, {0}
    2140:	02000000 	andeq	r0, r0, #0
    2144:	000a5000 	andeq	r5, sl, r0
    2148:	e0010400 	and	r0, r1, r0, lsl #8
    214c:	0000000b 	andeq	r0, r0, fp
    2150:	b0000000 	andlt	r0, r0, r0
    2154:	f600000f 			; <UNDEFINED> instruction: 0xf600000f
    2158:	07000000 	streq	r0, [r0, -r0]
    215c:	01000010 	tsteq	r0, r0, lsl r0
    2160:	00014b80 	andeq	r4, r1, r0, lsl #23
    2164:	62000400 	andvs	r0, r0, #0, 8
    2168:	0400000a 	streq	r0, [r0], #-10
    216c:	00000001 	andeq	r0, r0, r1
    2170:	10540400 	subsne	r0, r4, r0, lsl #8
    2174:	00f60000 	rscseq	r0, r6, r0
    2178:	90500000 	subsls	r0, r0, r0
    217c:	01180000 	tsteq	r8, r0
    2180:	0c9c0000 	ldceq	0, cr0, [ip], {0}
    2184:	cf020000 	svcgt	0x00020000
    2188:	01000010 	tsteq	r0, r0, lsl r0
    218c:	00310702 	eorseq	r0, r1, r2, lsl #14
    2190:	04030000 	streq	r0, [r3], #-0
    2194:	00000037 	andeq	r0, r0, r7, lsr r0
    2198:	10c60204 	sbcne	r0, r6, r4, lsl #4
    219c:	03010000 	movweq	r0, #4096	; 0x1000
    21a0:	00003107 	andeq	r3, r0, r7, lsl #2
    21a4:	10210500 	eorne	r0, r1, r0, lsl #10
    21a8:	06010000 	streq	r0, [r1], -r0
    21ac:	00005010 	andeq	r5, r0, r0, lsl r0
    21b0:	05040600 	streq	r0, [r4, #-1536]	; 0xfffffa00
    21b4:	00746e69 	rsbseq	r6, r4, r9, ror #28
    21b8:	0010bd05 	andseq	fp, r0, r5, lsl #26
    21bc:	10080100 	andne	r0, r8, r0, lsl #2
    21c0:	00000050 	andeq	r0, r0, r0, asr r0
    21c4:	00002507 	andeq	r2, r0, r7, lsl #10
    21c8:	00007600 	andeq	r7, r0, r0, lsl #12
    21cc:	00760800 	rsbseq	r0, r6, r0, lsl #16
    21d0:	ffff0000 			; <UNDEFINED> instruction: 0xffff0000
    21d4:	0900ffff 	stmdbeq	r0, {r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, fp, ip, sp, lr, pc}
    21d8:	158c0704 	strne	r0, [ip, #1796]	; 0x704
    21dc:	39050000 	stmdbcc	r5, {}	; <UNPREDICTABLE>
    21e0:	01000010 	tsteq	r0, r0, lsl r0
    21e4:	0063150b 	rsbeq	r1, r3, fp, lsl #10
    21e8:	2c050000 	stccs	0, cr0, [r5], {-0}
    21ec:	01000010 	tsteq	r0, r0, lsl r0
    21f0:	0063150d 	rsbeq	r1, r3, sp, lsl #10
    21f4:	38070000 	stmdacc	r7, {}	; <UNPREDICTABLE>
    21f8:	a8000000 	stmdage	r0, {}	; <UNPREDICTABLE>
    21fc:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    2200:	00000076 	andeq	r0, r0, r6, ror r0
    2204:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
    2208:	10130500 	andsne	r0, r3, r0, lsl #10
    220c:	10010000 	andne	r0, r1, r0
    2210:	00009515 	andeq	r9, r0, r5, lsl r5
    2214:	10470500 	subne	r0, r7, r0, lsl #10
    2218:	12010000 	andne	r0, r1, #0
    221c:	00009515 	andeq	r9, r0, r5, lsl r5
    2220:	10af0a00 	adcne	r0, pc, r0, lsl #20
    2224:	2b010000 	blcs	4222c <_bss_end+0x38f80>
    2228:	00005010 	andeq	r5, r0, r0, lsl r0
    222c:	00911000 	addseq	r1, r1, r0
    2230:	00005800 	andeq	r5, r0, r0, lsl #16
    2234:	ea9c0100 	b	fe70263c <_bss_end+0xfe6f9390>
    2238:	0b000000 	bleq	2240 <CPSR_IRQ_INHIBIT+0x21c0>
    223c:	000010f0 	strdeq	r1, [r0], -r0
    2240:	ea0f2d01 	b	3cd64c <_bss_end+0x3c43a0>
    2244:	02000000 	andeq	r0, r0, #0
    2248:	03007491 	movweq	r7, #1169	; 0x491
    224c:	00003804 	andeq	r3, r0, r4, lsl #16
    2250:	10e30a00 	rscne	r0, r3, r0, lsl #20
    2254:	1f010000 	svcne	0x00010000
    2258:	00005010 	andeq	r5, r0, r0, lsl r0
    225c:	0090b800 	addseq	fp, r0, r0, lsl #16
    2260:	00005800 	andeq	r5, r0, r0, lsl #16
    2264:	1a9c0100 	bne	fe70266c <_bss_end+0xfe6f93c0>
    2268:	0b000001 	bleq	2274 <CPSR_IRQ_INHIBIT+0x21f4>
    226c:	000010f0 	strdeq	r1, [r0], -r0
    2270:	1a0f2101 	bne	3ca67c <_bss_end+0x3c13d0>
    2274:	02000001 	andeq	r0, r0, #1
    2278:	03007491 	movweq	r7, #1169	; 0x491
    227c:	00002504 	andeq	r2, r0, r4, lsl #10
    2280:	10d80c00 	sbcsne	r0, r8, r0, lsl #24
    2284:	14010000 	strne	r0, [r1], #-0
    2288:	00005010 	andeq	r5, r0, r0, lsl r0
    228c:	00905000 	addseq	r5, r0, r0
    2290:	00006800 	andeq	r6, r0, r0, lsl #16
    2294:	489c0100 	ldmmi	ip, {r8}
    2298:	0d000001 	stceq	0, cr0, [r0, #-4]
    229c:	16010069 	strne	r0, [r1], -r9, rrx
    22a0:	0001480a 	andeq	r4, r1, sl, lsl #16
    22a4:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    22a8:	50040300 	andpl	r0, r4, r0, lsl #6
    22ac:	00000000 	andeq	r0, r0, r0
    22b0:	00000932 	andeq	r0, r0, r2, lsr r9
    22b4:	0b280004 	bleq	a022cc <_bss_end+0x9f9020>
    22b8:	01040000 	mrseq	r0, (UNDEF: 4)
    22bc:	0000145f 	andeq	r1, r0, pc, asr r4
    22c0:	0013b60c 	andseq	fp, r3, ip, lsl #12
    22c4:	001b8300 	andseq	r8, fp, r0, lsl #6
    22c8:	000d9200 	andeq	r9, sp, r0, lsl #4
    22cc:	05040200 	streq	r0, [r4, #-512]	; 0xfffffe00
    22d0:	00746e69 	rsbseq	r6, r4, r9, ror #28
    22d4:	8c070403 	cfstrshi	mvf0, [r7], {3}
    22d8:	03000015 	movweq	r0, #21
    22dc:	01e80508 	mvneq	r0, r8, lsl #10
    22e0:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    22e4:	001cc304 	andseq	ip, ip, r4, lsl #6
    22e8:	14110400 	ldrne	r0, [r1], #-1024	; 0xfffffc00
    22ec:	2a010000 	bcs	422f4 <_bss_end+0x39048>
    22f0:	00002416 	andeq	r2, r0, r6, lsl r4
    22f4:	18800400 	stmne	r0, {sl}
    22f8:	2f010000 	svccs	0x00010000
    22fc:	00005115 	andeq	r5, r0, r5, lsl r1
    2300:	57040500 	strpl	r0, [r4, -r0, lsl #10]
    2304:	06000000 	streq	r0, [r0], -r0
    2308:	00000039 	andeq	r0, r0, r9, lsr r0
    230c:	00000066 	andeq	r0, r0, r6, rrx
    2310:	00006607 	andeq	r6, r0, r7, lsl #12
    2314:	04050000 	streq	r0, [r5], #-0
    2318:	0000006c 	andeq	r0, r0, ip, rrx
    231c:	20170408 	andscs	r0, r7, r8, lsl #8
    2320:	36010000 	strcc	r0, [r1], -r0
    2324:	0000790f 	andeq	r7, r0, pc, lsl #18
    2328:	7f040500 	svcvc	0x00040500
    232c:	06000000 	streq	r0, [r0], -r0
    2330:	0000001d 	andeq	r0, r0, sp, lsl r0
    2334:	00000093 	muleq	r0, r3, r0
    2338:	00006607 	andeq	r6, r0, r7, lsl #12
    233c:	00660700 	rsbeq	r0, r6, r0, lsl #14
    2340:	03000000 	movweq	r0, #0
    2344:	05400801 	strbeq	r0, [r0, #-2049]	; 0xfffff7ff
    2348:	b8090000 	stmdalt	r9, {}	; <UNPREDICTABLE>
    234c:	0100001a 	tsteq	r0, sl, lsl r0
    2350:	004512bb 	strheq	r1, [r5], #-43	; 0xffffffd5
    2354:	45090000 	strmi	r0, [r9, #-0]
    2358:	01000020 	tsteq	r0, r0, lsr #32
    235c:	006d10be 	strhteq	r1, [sp], #-14
    2360:	01030000 	mrseq	r0, (UNDEF: 3)
    2364:	00054206 	andeq	r4, r5, r6, lsl #4
    2368:	17a00a00 	strne	r0, [r0, r0, lsl #20]!
    236c:	01070000 	mrseq	r0, (UNDEF: 7)
    2370:	00000093 	muleq	r0, r3, r0
    2374:	e6061702 	str	r1, [r6], -r2, lsl #14
    2378:	0b000001 	bleq	2384 <CPSR_IRQ_INHIBIT+0x2304>
    237c:	0000126f 	andeq	r1, r0, pc, ror #4
    2380:	16bd0b00 	ldrtne	r0, [sp], r0, lsl #22
    2384:	0b010000 	bleq	4238c <_bss_end+0x390e0>
    2388:	00001be8 	andeq	r1, r0, r8, ror #23
    238c:	1f590b02 	svcne	0x00590b02
    2390:	0b030000 	bleq	c2398 <_bss_end+0xb90ec>
    2394:	00001b27 	andeq	r1, r0, r7, lsr #22
    2398:	1e620b04 	vmulne.f64	d16, d2, d4
    239c:	0b050000 	bleq	1423a4 <_bss_end+0x1390f8>
    23a0:	00001dc6 	andeq	r1, r0, r6, asr #27
    23a4:	12900b06 	addsne	r0, r0, #6144	; 0x1800
    23a8:	0b070000 	bleq	1c23b0 <_bss_end+0x1b9104>
    23ac:	00001e77 	andeq	r1, r0, r7, ror lr
    23b0:	1e850b08 	vdivne.f64	d0, d5, d8
    23b4:	0b090000 	bleq	2423bc <_bss_end+0x239110>
    23b8:	00001f4c 	andeq	r1, r0, ip, asr #30
    23bc:	1a7e0b0a 	bne	1f84fec <_bss_end+0x1f7bd40>
    23c0:	0b0b0000 	bleq	2c23c8 <_bss_end+0x2b911c>
    23c4:	00001452 	andeq	r1, r0, r2, asr r4
    23c8:	152f0b0c 	strne	r0, [pc, #-2828]!	; 18c4 <CPSR_IRQ_INHIBIT+0x1844>
    23cc:	0b0d0000 	bleq	3423d4 <_bss_end+0x339128>
    23d0:	000017e4 	andeq	r1, r0, r4, ror #15
    23d4:	17fa0b0e 	ldrbne	r0, [sl, lr, lsl #22]!
    23d8:	0b0f0000 	bleq	3c23e0 <_bss_end+0x3b9134>
    23dc:	000016f7 	strdeq	r1, [r0], -r7
    23e0:	1b0b0b10 	blne	2c5028 <_bss_end+0x2bbd7c>
    23e4:	0b110000 	bleq	4423ec <_bss_end+0x439140>
    23e8:	00001763 	andeq	r1, r0, r3, ror #14
    23ec:	21de0b12 	bicscs	r0, lr, r2, lsl fp
    23f0:	0b130000 	bleq	4c23f8 <_bss_end+0x4b914c>
    23f4:	000012f9 	strdeq	r1, [r0], -r9
    23f8:	17870b14 	usada8ne	r7, r4, fp, r0
    23fc:	0b150000 	bleq	542404 <_bss_end+0x539158>
    2400:	00001236 	andeq	r1, r0, r6, lsr r2
    2404:	1f7c0b16 	svcne	0x007c0b16
    2408:	0b170000 	bleq	5c2410 <_bss_end+0x5b9164>
    240c:	0000209e 	muleq	r0, lr, r0
    2410:	17ac0b18 			; <UNDEFINED> instruction: 0x17ac0b18
    2414:	0b190000 	bleq	64241c <_bss_end+0x639170>
    2418:	00001c5a 	andeq	r1, r0, sl, asr ip
    241c:	1f8a0b1a 	svcne	0x008a0b1a
    2420:	0b1b0000 	bleq	6c2428 <_bss_end+0x6b917c>
    2424:	00001165 	andeq	r1, r0, r5, ror #2
    2428:	1f980b1c 	svcne	0x00980b1c
    242c:	0b1d0000 	bleq	742434 <_bss_end+0x739188>
    2430:	00001fa6 	andeq	r1, r0, r6, lsr #31
    2434:	11130b1e 	tstne	r3, lr, lsl fp
    2438:	0b1f0000 	bleq	7c2440 <_bss_end+0x7b9194>
    243c:	00001fd0 	ldrdeq	r1, [r0], -r0
    2440:	1d070b20 	vstrne	d0, [r7, #-128]	; 0xffffff80
    2444:	0b210000 	bleq	84244c <_bss_end+0x8391a0>
    2448:	00001add 	ldrdeq	r1, [r0], -sp
    244c:	1f6f0b22 	svcne	0x006f0b22
    2450:	0b230000 	bleq	8c2458 <_bss_end+0x8b91ac>
    2454:	000019e1 	andeq	r1, r0, r1, ror #19
    2458:	18e30b24 	stmiane	r3!, {r2, r5, r8, r9, fp}^
    245c:	0b250000 	bleq	942464 <_bss_end+0x9391b8>
    2460:	000015fd 	strdeq	r1, [r0], -sp
    2464:	19010b26 	stmdbne	r1, {r1, r2, r5, r8, r9, fp}
    2468:	0b270000 	bleq	9c2470 <_bss_end+0x9b91c4>
    246c:	00001699 	muleq	r0, r9, r6
    2470:	19110b28 	ldmdbne	r1, {r3, r5, r8, r9, fp}
    2474:	0b290000 	bleq	a4247c <_bss_end+0xa391d0>
    2478:	00001921 	andeq	r1, r0, r1, lsr #18
    247c:	1a640b2a 	bne	190512c <_bss_end+0x18fbe80>
    2480:	0b2b0000 	bleq	ac2488 <_bss_end+0xab91dc>
    2484:	0000188a 	andeq	r1, r0, sl, lsl #17
    2488:	1d140b2c 	vldrne	d0, [r4, #-176]	; 0xffffff50
    248c:	0b2d0000 	bleq	b42494 <_bss_end+0xb391e8>
    2490:	0000163e 	andeq	r1, r0, lr, lsr r6
    2494:	1c0a002e 	stcne	0, cr0, [sl], {46}	; 0x2e
    2498:	07000018 	smladeq	r0, r8, r0, r0
    249c:	00009301 	andeq	r9, r0, r1, lsl #6
    24a0:	06170300 	ldreq	r0, [r7], -r0, lsl #6
    24a4:	000003c7 	andeq	r0, r0, r7, asr #7
    24a8:	0015510b 	andseq	r5, r5, fp, lsl #2
    24ac:	a30b0000 	movwge	r0, #45056	; 0xb000
    24b0:	01000011 	tsteq	r0, r1, lsl r0
    24b4:	00218c0b 	eoreq	r8, r1, fp, lsl #24
    24b8:	1f0b0200 	svcne	0x000b0200
    24bc:	03000020 	movweq	r0, #32
    24c0:	0015710b 	andseq	r7, r5, fp, lsl #2
    24c4:	5b0b0400 	blpl	2c34cc <_bss_end+0x2ba220>
    24c8:	05000012 	streq	r0, [r0, #-18]	; 0xffffffee
    24cc:	00161a0b 	andseq	r1, r6, fp, lsl #20
    24d0:	610b0600 	tstvs	fp, r0, lsl #12
    24d4:	07000015 	smladeq	r0, r5, r0, r0
    24d8:	001eb30b 	andseq	fp, lr, fp, lsl #6
    24dc:	040b0800 	streq	r0, [fp], #-2048	; 0xfffff800
    24e0:	09000020 	stmdbeq	r0, {r5}
    24e4:	001dea0b 	andseq	lr, sp, fp, lsl #20
    24e8:	ae0b0a00 	vmlage.f32	s0, s22, s0
    24ec:	0b000012 	bleq	253c <CPSR_IRQ_INHIBIT+0x24bc>
    24f0:	0015bb0b 	andseq	fp, r5, fp, lsl #22
    24f4:	240b0c00 	strcs	r0, [fp], #-3072	; 0xfffff400
    24f8:	0d000012 	stceq	0, cr0, [r0, #-72]	; 0xffffffb8
    24fc:	0021c10b 	eoreq	ip, r1, fp, lsl #2
    2500:	510b0e00 	tstpl	fp, r0, lsl #28
    2504:	0f00001a 	svceq	0x0000001a
    2508:	00172e0b 	andseq	r2, r7, fp, lsl #28
    250c:	8e0b1000 	cdphi	0, 0, cr1, cr11, cr0, {0}
    2510:	1100001a 	tstne	r0, sl, lsl r0
    2514:	0020e00b 	eoreq	lr, r0, fp
    2518:	710b1200 	mrsvc	r1, R11_fiq
    251c:	13000013 	movwne	r0, #19
    2520:	0017410b 	andseq	r4, r7, fp, lsl #2
    2524:	a40b1400 	strge	r1, [fp], #-1024	; 0xfffffc00
    2528:	15000019 	strne	r0, [r0, #-25]	; 0xffffffe7
    252c:	00153c0b 	andseq	r3, r5, fp, lsl #24
    2530:	f00b1600 			; <UNDEFINED> instruction: 0xf00b1600
    2534:	17000019 	smladne	r0, r9, r0, r0
    2538:	0018060b 	andseq	r0, r8, fp, lsl #12
    253c:	790b1800 	stmdbvc	fp, {fp, ip}
    2540:	19000012 	stmdbne	r0, {r1, r4}
    2544:	0020870b 	eoreq	r8, r0, fp, lsl #14
    2548:	700b1a00 	andvc	r1, fp, r0, lsl #20
    254c:	1b000019 	blne	25b8 <CPSR_IRQ_INHIBIT+0x2538>
    2550:	0017180b 	andseq	r1, r7, fp, lsl #16
    2554:	4e0b1c00 	cdpmi	12, 0, cr1, cr11, cr0, {0}
    2558:	1d000011 	stcne	0, cr0, [r0, #-68]	; 0xffffffbc
    255c:	0018bb0b 	andseq	fp, r8, fp, lsl #22
    2560:	a70b1e00 	strge	r1, [fp, -r0, lsl #28]
    2564:	1f000018 	svcne	0x00000018
    2568:	001da70b 	andseq	sl, sp, fp, lsl #14
    256c:	320b2000 	andcc	r2, fp, #0
    2570:	2100001e 	tstcs	r0, lr, lsl r0
    2574:	0020660b 	eoreq	r6, r0, fp, lsl #12
    2578:	4b0b2200 	blmi	2cad80 <_bss_end+0x2c1ad4>
    257c:	23000016 	movwcs	r0, #22
    2580:	001c0a0b 	andseq	r0, ip, fp, lsl #20
    2584:	ff0b2400 			; <UNDEFINED> instruction: 0xff0b2400
    2588:	2500001d 	strcs	r0, [r0, #-29]	; 0xffffffe3
    258c:	001d230b 	andseq	r2, sp, fp, lsl #6
    2590:	370b2600 	strcc	r2, [fp, -r0, lsl #12]
    2594:	2700001d 	smladcs	r0, sp, r0, r0
    2598:	001d4b0b 	andseq	r4, sp, fp, lsl #22
    259c:	fc0b2800 	stc2	8, cr2, [fp], {-0}
    25a0:	29000013 	stmdbcs	r0, {r0, r1, r4}
    25a4:	00135c0b 	andseq	r5, r3, fp, lsl #24
    25a8:	840b2a00 	strhi	r2, [fp], #-2560	; 0xfffff600
    25ac:	2b000013 	blcs	2600 <CPSR_IRQ_INHIBIT+0x2580>
    25b0:	001efc0b 	andseq	pc, lr, fp, lsl #24
    25b4:	d90b2c00 	stmdble	fp, {sl, fp, sp}
    25b8:	2d000013 	stccs	0, cr0, [r0, #-76]	; 0xffffffb4
    25bc:	001f100b 	andseq	r1, pc, fp
    25c0:	240b2e00 	strcs	r2, [fp], #-3584	; 0xfffff200
    25c4:	2f00001f 	svccs	0x0000001f
    25c8:	001f380b 	andseq	r3, pc, fp, lsl #16
    25cc:	cd0b3000 	stcgt	0, cr3, [fp, #-0]
    25d0:	31000015 	tstcc	r0, r5, lsl r0
    25d4:	0015a70b 	andseq	sl, r5, fp, lsl #14
    25d8:	cf0b3200 	svcgt	0x000b3200
    25dc:	33000018 	movwcc	r0, #24
    25e0:	001aa10b 	andseq	sl, sl, fp, lsl #2
    25e4:	150b3400 	strne	r3, [fp, #-1024]	; 0xfffffc00
    25e8:	35000021 	strcc	r0, [r0, #-33]	; 0xffffffdf
    25ec:	0010f60b 	andseq	pc, r0, fp, lsl #12
    25f0:	cd0b3600 	stcgt	6, cr3, [fp, #-0]
    25f4:	37000016 	smladcc	r0, r6, r0, r0
    25f8:	0016e20b 	andseq	lr, r6, fp, lsl #4
    25fc:	310b3800 	tstcc	fp, r0, lsl #16
    2600:	39000019 	stmdbcc	r0, {r0, r3, r4}
    2604:	00195b0b 	andseq	r5, r9, fp, lsl #22
    2608:	3e0b3a00 	vmlacc.f32	s6, s22, s0
    260c:	3b000021 	blcc	2698 <CPSR_IRQ_INHIBIT+0x2618>
    2610:	001bf50b 	andseq	pc, fp, fp, lsl #10
    2614:	700b3c00 	andvc	r3, fp, r0, lsl #24
    2618:	3d000016 	stccc	0, cr0, [r0, #-88]	; 0xffffffa8
    261c:	0011b50b 	andseq	fp, r1, fp, lsl #10
    2620:	730b3e00 	movwvc	r3, #48640	; 0xbe00
    2624:	3f000011 	svccc	0x00000011
    2628:	001aed0b 	andseq	lr, sl, fp, lsl #26
    262c:	760b4000 	strvc	r4, [fp], -r0
    2630:	4100001c 	tstmi	r0, ip, lsl r0
    2634:	001d890b 	andseq	r8, sp, fp, lsl #18
    2638:	460b4200 	strmi	r4, [fp], -r0, lsl #4
    263c:	43000019 	movwmi	r0, #25
    2640:	0021770b 	eoreq	r7, r1, fp, lsl #14
    2644:	200b4400 	andcs	r4, fp, r0, lsl #8
    2648:	4500001c 	strmi	r0, [r0, #-28]	; 0xffffffe4
    264c:	0013a00b 	andseq	sl, r3, fp
    2650:	210b4600 	tstcs	fp, r0, lsl #12
    2654:	4700001a 	smladmi	r0, sl, r0, r0
    2658:	0018540b 	andseq	r5, r8, fp, lsl #8
    265c:	320b4800 	andcc	r4, fp, #0, 16
    2660:	49000011 	stmdbmi	r0, {r0, r4}
    2664:	0012460b 	andseq	r4, r2, fp, lsl #12
    2668:	840b4a00 	strhi	r4, [fp], #-2560	; 0xfffff600
    266c:	4b000016 	blmi	26cc <CPSR_IRQ_INHIBIT+0x264c>
    2670:	0019820b 	andseq	r8, r9, fp, lsl #4
    2674:	03004c00 	movweq	r4, #3072	; 0xc00
    2678:	05a10702 	streq	r0, [r1, #1794]!	; 0x702
    267c:	e40c0000 	str	r0, [ip], #-0
    2680:	d9000003 	stmdble	r0, {r0, r1}
    2684:	0d000003 	stceq	0, cr0, [r0, #-12]
    2688:	03ce0e00 	biceq	r0, lr, #0, 28
    268c:	04050000 	streq	r0, [r5], #-0
    2690:	000003f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    2694:	0003de0e 	andeq	sp, r3, lr, lsl #28
    2698:	08010300 	stmdaeq	r1, {r8, r9}
    269c:	00000549 	andeq	r0, r0, r9, asr #10
    26a0:	0003e90e 	andeq	lr, r3, lr, lsl #18
    26a4:	12ea0f00 	rscne	r0, sl, #0, 30
    26a8:	4c040000 	stcmi	0, cr0, [r4], {-0}
    26ac:	03d91a01 	bicseq	r1, r9, #4096	; 0x1000
    26b0:	080f0000 	stmdaeq	pc, {}	; <UNPREDICTABLE>
    26b4:	04000017 	streq	r0, [r0], #-23	; 0xffffffe9
    26b8:	d91a0182 	ldmdble	sl, {r1, r7, r8}
    26bc:	0c000003 	stceq	0, cr0, [r0], {3}
    26c0:	000003e9 	andeq	r0, r0, r9, ror #7
    26c4:	0000041a 	andeq	r0, r0, sl, lsl r4
    26c8:	f309000d 	vhadd.u8	d0, d9, d13
    26cc:	05000018 	streq	r0, [r0, #-24]	; 0xffffffe8
    26d0:	040f0d2d 	streq	r0, [pc], #-3373	; 26d8 <CPSR_IRQ_INHIBIT+0x2658>
    26d4:	e0090000 	and	r0, r9, r0
    26d8:	0500001f 	streq	r0, [r0, #-31]	; 0xffffffe1
    26dc:	01e61c38 	mvneq	r1, r8, lsr ip
    26e0:	e10a0000 	mrs	r0, (UNDEF: 10)
    26e4:	07000015 	smladeq	r0, r5, r0, r0
    26e8:	00009301 	andeq	r9, r0, r1, lsl #6
    26ec:	0e3a0500 	cfabs32eq	mvfx0, mvfx10
    26f0:	000004a5 	andeq	r0, r0, r5, lsr #9
    26f4:	0011470b 	andseq	r4, r1, fp, lsl #14
    26f8:	f30b0000 	vhadd.u8	d0, d11, d0
    26fc:	01000017 	tsteq	r0, r7, lsl r0
    2700:	0020f20b 	eoreq	pc, r0, fp, lsl #4
    2704:	b50b0200 	strlt	r0, [fp, #-512]	; 0xfffffe00
    2708:	03000020 	movweq	r0, #32
    270c:	001b4a0b 	andseq	r4, fp, fp, lsl #20
    2710:	700b0400 	andvc	r0, fp, r0, lsl #8
    2714:	0500001e 	streq	r0, [r0, #-30]	; 0xffffffe2
    2718:	00132d0b 	andseq	r2, r3, fp, lsl #26
    271c:	0f0b0600 	svceq	0x000b0600
    2720:	07000013 	smladeq	r0, r3, r0, r0
    2724:	0015280b 	andseq	r2, r5, fp, lsl #16
    2728:	060b0800 	streq	r0, [fp], -r0, lsl #16
    272c:	0900001a 	stmdbeq	r0, {r1, r3, r4}
    2730:	0013340b 	andseq	r3, r3, fp, lsl #8
    2734:	0d0b0a00 	vstreq	s0, [fp, #-0]
    2738:	0b00001a 	bleq	27a8 <CPSR_IRQ_INHIBIT+0x2728>
    273c:	0013990b 	andseq	r9, r3, fp, lsl #18
    2740:	260b0c00 	strcs	r0, [fp], -r0, lsl #24
    2744:	0d000013 	stceq	0, cr0, [r0, #-76]	; 0xffffffb4
    2748:	001ec70b 	andseq	ip, lr, fp, lsl #14
    274c:	940b0e00 	strls	r0, [fp], #-3584	; 0xfffff200
    2750:	0f00001c 	svceq	0x0000001c
    2754:	1dbf0400 	cfldrsne	mvf0, [pc]	; 275c <CPSR_IRQ_INHIBIT+0x26dc>
    2758:	3f050000 	svccc	0x00050000
    275c:	00043201 	andeq	r3, r4, r1, lsl #4
    2760:	1e530900 	vnmlsne.f16	s1, s6, s0	; <UNPREDICTABLE>
    2764:	41050000 	mrsmi	r0, (UNDEF: 5)
    2768:	0004a50f 	andeq	sl, r4, pc, lsl #10
    276c:	1edb0900 	vfnmsne.f16	s1, s22, s0	; <UNPREDICTABLE>
    2770:	4a050000 	bmi	142778 <_bss_end+0x1394cc>
    2774:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2778:	12ce0900 	sbcne	r0, lr, #0, 18
    277c:	4b050000 	blmi	142784 <_bss_end+0x1394d8>
    2780:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2784:	1fb41000 	svcne	0x00b41000
    2788:	ec090000 	stc	0, cr0, [r9], {-0}
    278c:	0500001e 	streq	r0, [r0, #-30]	; 0xffffffe2
    2790:	04e6144c 	strbteq	r1, [r6], #1100	; 0x44c
    2794:	04050000 	streq	r0, [r5], #-0
    2798:	000004d5 	ldrdeq	r0, [r0], -r5
    279c:	17bd0911 			; <UNDEFINED> instruction: 0x17bd0911
    27a0:	4e050000 	cdpmi	0, 0, cr0, cr5, cr0, {0}
    27a4:	0004f90f 	andeq	pc, r4, pc, lsl #18
    27a8:	ec040500 	cfstr32	mvfx0, [r4], {-0}
    27ac:	12000004 	andne	r0, r0, #4
    27b0:	00001dd5 	ldrdeq	r1, [r0], -r5
    27b4:	001b3709 	andseq	r3, fp, r9, lsl #14
    27b8:	0d520500 	cfldr64eq	mvdx0, [r2, #-0]
    27bc:	00000510 	andeq	r0, r0, r0, lsl r5
    27c0:	04ff0405 	ldrbteq	r0, [pc], #1029	; 27c8 <CPSR_IRQ_INHIBIT+0x2748>
    27c4:	45130000 	ldrmi	r0, [r3, #-0]
    27c8:	34000014 	strcc	r0, [r0], #-20	; 0xffffffec
    27cc:	15016705 	strne	r6, [r1, #-1797]	; 0xfffff8fb
    27d0:	00000541 	andeq	r0, r0, r1, asr #10
    27d4:	0018fc14 	andseq	pc, r8, r4, lsl ip	; <UNPREDICTABLE>
    27d8:	01690500 	cmneq	r9, r0, lsl #10
    27dc:	0003de0f 	andeq	sp, r3, pc, lsl #28
    27e0:	29140000 	ldmdbcs	r4, {}	; <UNPREDICTABLE>
    27e4:	05000014 	streq	r0, [r0, #-20]	; 0xffffffec
    27e8:	4614016a 	ldrmi	r0, [r4], -sl, ror #2
    27ec:	04000005 	streq	r0, [r0], #-5
    27f0:	05160e00 	ldreq	r0, [r6, #-3584]	; 0xfffff200
    27f4:	b90c0000 	stmdblt	ip, {}	; <UNPREDICTABLE>
    27f8:	56000000 	strpl	r0, [r0], -r0
    27fc:	15000005 	strne	r0, [r0, #-5]
    2800:	00000024 	andeq	r0, r0, r4, lsr #32
    2804:	410c002d 	tstmi	ip, sp, lsr #32
    2808:	61000005 	tstvs	r0, r5
    280c:	0d000005 	stceq	0, cr0, [r0, #-20]	; 0xffffffec
    2810:	05560e00 	ldrbeq	r0, [r6, #-3584]	; 0xfffff200
    2814:	2b0f0000 	blcs	3c281c <_bss_end+0x3b9570>
    2818:	05000018 	streq	r0, [r0, #-24]	; 0xffffffe8
    281c:	6103016b 	tstvs	r3, fp, ror #2
    2820:	0f000005 	svceq	0x00000005
    2824:	00001a71 	andeq	r1, r0, r1, ror sl
    2828:	0c016e05 	stceq	14, cr6, [r1], {5}
    282c:	0000001d 	andeq	r0, r0, sp, lsl r0
    2830:	001e1316 	andseq	r1, lr, r6, lsl r3
    2834:	93010700 	movwls	r0, #5888	; 0x1700
    2838:	05000000 	streq	r0, [r0, #-0]
    283c:	2a060181 	bcs	182e48 <_bss_end+0x179b9c>
    2840:	0b000006 	bleq	2860 <CPSR_IRQ_INHIBIT+0x27e0>
    2844:	000011dc 	ldrdeq	r1, [r0], -ip
    2848:	11e80b00 	mvnne	r0, r0, lsl #22
    284c:	0b020000 	bleq	82854 <_bss_end+0x795a8>
    2850:	000011f4 	strdeq	r1, [r0], -r4
    2854:	160d0b03 	strne	r0, [sp], -r3, lsl #22
    2858:	0b030000 	bleq	c2860 <_bss_end+0xb95b4>
    285c:	00001200 	andeq	r1, r0, r0, lsl #4
    2860:	17560b04 	ldrbne	r0, [r6, -r4, lsl #22]
    2864:	0b040000 	bleq	10286c <_bss_end+0xf95c0>
    2868:	0000183c 	andeq	r1, r0, ip, lsr r8
    286c:	17920b05 	ldrne	r0, [r2, r5, lsl #22]
    2870:	0b050000 	bleq	142878 <_bss_end+0x1395cc>
    2874:	000012bf 			; <UNDEFINED> instruction: 0x000012bf
    2878:	120c0b05 	andne	r0, ip, #5120	; 0x1400
    287c:	0b060000 	bleq	182884 <_bss_end+0x1795d8>
    2880:	000019ba 			; <UNDEFINED> instruction: 0x000019ba
    2884:	141b0b06 	ldrne	r0, [fp], #-2822	; 0xfffff4fa
    2888:	0b060000 	bleq	182890 <_bss_end+0x1795e4>
    288c:	000019c7 	andeq	r1, r0, r7, asr #19
    2890:	1e930b06 	vfnmsne.f64	d0, d3, d6
    2894:	0b060000 	bleq	18289c <_bss_end+0x1795f0>
    2898:	000019d4 	ldrdeq	r1, [r0], -r4
    289c:	1a140b06 	bne	5054bc <_bss_end+0x4fc210>
    28a0:	0b060000 	bleq	1828a8 <_bss_end+0x1795fc>
    28a4:	00001218 	andeq	r1, r0, r8, lsl r2
    28a8:	1b1a0b07 	blne	6854cc <_bss_end+0x67c220>
    28ac:	0b070000 	bleq	1c28b4 <_bss_end+0x1b9608>
    28b0:	00001b67 	andeq	r1, r0, r7, ror #22
    28b4:	1ece0b07 	vdivne.f64	d16, d14, d7
    28b8:	0b070000 	bleq	1c28c0 <_bss_end+0x1b9614>
    28bc:	000013ee 	andeq	r1, r0, lr, ror #7
    28c0:	1c4d0b07 	mcrrne	11, 0, r0, sp, cr7
    28c4:	0b080000 	bleq	2028cc <_bss_end+0x1f9620>
    28c8:	00001191 	muleq	r0, r1, r1
    28cc:	1ea10b08 	vfmane.f64	d0, d1, d8
    28d0:	0b080000 	bleq	2028d8 <_bss_end+0x1f962c>
    28d4:	00001c69 	andeq	r1, r0, r9, ror #24
    28d8:	070f0008 	streq	r0, [pc, -r8]
    28dc:	05000021 	streq	r0, [r0, #-33]	; 0xffffffdf
    28e0:	801f019f 	mulshi	pc, pc, r1	; <UNPREDICTABLE>
    28e4:	0f000005 	svceq	0x00000005
    28e8:	00001c9b 	muleq	r0, fp, ip
    28ec:	0c01a205 	sfmeq	f2, 1, [r1], {5}
    28f0:	0000001d 	andeq	r0, r0, sp, lsl r0
    28f4:	0018490f 	andseq	r4, r8, pc, lsl #18
    28f8:	01a50500 			; <UNDEFINED> instruction: 0x01a50500
    28fc:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2900:	21d30f00 	bicscs	r0, r3, r0, lsl #30
    2904:	a8050000 	stmdage	r5, {}	; <UNPREDICTABLE>
    2908:	001d0c01 	andseq	r0, sp, r1, lsl #24
    290c:	de0f0000 	cdple	0, 0, cr0, cr15, cr0, {0}
    2910:	05000012 	streq	r0, [r0, #-18]	; 0xffffffee
    2914:	1d0c01ab 	stfnes	f0, [ip, #-684]	; 0xfffffd54
    2918:	0f000000 	svceq	0x00000000
    291c:	00001ca5 	andeq	r1, r0, r5, lsr #25
    2920:	0c01ae05 	stceq	14, cr10, [r1], {5}
    2924:	0000001d 	andeq	r0, r0, sp, lsl r0
    2928:	001b510f 	andseq	r5, fp, pc, lsl #2
    292c:	01b10500 			; <UNDEFINED> instruction: 0x01b10500
    2930:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2934:	1b5c0f00 	blne	170653c <_bss_end+0x16fd290>
    2938:	b4050000 	strlt	r0, [r5], #-0
    293c:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2940:	af0f0000 	svcge	0x000f0000
    2944:	0500001c 	streq	r0, [r0, #-28]	; 0xffffffe4
    2948:	1d0c01b7 	stfnes	f0, [ip, #-732]	; 0xfffffd24
    294c:	0f000000 	svceq	0x00000000
    2950:	00001996 	muleq	r0, r6, r9
    2954:	0c01ba05 			; <UNDEFINED> instruction: 0x0c01ba05
    2958:	0000001d 	andeq	r0, r0, sp, lsl r0
    295c:	0021320f 	eoreq	r3, r1, pc, lsl #4
    2960:	01bd0500 			; <UNDEFINED> instruction: 0x01bd0500
    2964:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2968:	1cb90f00 	ldcne	15, cr0, [r9]
    296c:	c0050000 	andgt	r0, r5, r0
    2970:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2974:	f60f0000 			; <UNDEFINED> instruction: 0xf60f0000
    2978:	05000021 	streq	r0, [r0, #-33]	; 0xffffffdf
    297c:	1d0c01c3 	stfnes	f0, [ip, #-780]	; 0xfffffcf4
    2980:	0f000000 	svceq	0x00000000
    2984:	000020bc 	strheq	r2, [r0], -ip
    2988:	0c01c605 	stceq	6, cr12, [r1], {5}
    298c:	0000001d 	andeq	r0, r0, sp, lsl r0
    2990:	0020c80f 	eoreq	ip, r0, pc, lsl #16
    2994:	01c90500 	biceq	r0, r9, r0, lsl #10
    2998:	00001d0c 	andeq	r1, r0, ip, lsl #26
    299c:	20d40f00 	sbcscs	r0, r4, r0, lsl #30
    29a0:	cc050000 	stcgt	0, cr0, [r5], {-0}
    29a4:	001d0c01 	andseq	r0, sp, r1, lsl #24
    29a8:	f90f0000 			; <UNDEFINED> instruction: 0xf90f0000
    29ac:	05000020 	streq	r0, [r0, #-32]	; 0xffffffe0
    29b0:	1d0c01d0 	stfnes	f0, [ip, #-832]	; 0xfffffcc0
    29b4:	0f000000 	svceq	0x00000000
    29b8:	000021e9 	andeq	r2, r0, r9, ror #3
    29bc:	0c01d305 	stceq	3, cr13, [r1], {5}
    29c0:	0000001d 	andeq	r0, r0, sp, lsl r0
    29c4:	00133b0f 	andseq	r3, r3, pc, lsl #22
    29c8:	01d60500 	bicseq	r0, r6, r0, lsl #10
    29cc:	00001d0c 	andeq	r1, r0, ip, lsl #26
    29d0:	11220f00 			; <UNDEFINED> instruction: 0x11220f00
    29d4:	d9050000 	stmdble	r5, {}	; <UNPREDICTABLE>
    29d8:	001d0c01 	andseq	r0, sp, r1, lsl #24
    29dc:	2d0f0000 	stccs	0, cr0, [pc, #-0]	; 29e4 <CPSR_IRQ_INHIBIT+0x2964>
    29e0:	05000016 	streq	r0, [r0, #-22]	; 0xffffffea
    29e4:	1d0c01dc 	stfnes	f0, [ip, #-880]	; 0xfffffc90
    29e8:	0f000000 	svceq	0x00000000
    29ec:	00001316 	andeq	r1, r0, r6, lsl r3
    29f0:	0c01df05 	stceq	15, cr13, [r1], {5}
    29f4:	0000001d 	andeq	r0, r0, sp, lsl r0
    29f8:	001ccf0f 	andseq	ip, ip, pc, lsl #30
    29fc:	01e20500 	mvneq	r0, r0, lsl #10
    2a00:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2a04:	18720f00 	ldmdane	r2!, {r8, r9, sl, fp}^
    2a08:	e5050000 	str	r0, [r5, #-0]
    2a0c:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2a10:	ca0f0000 	bgt	3c2a18 <_bss_end+0x3b976c>
    2a14:	0500001a 	streq	r0, [r0, #-26]	; 0xffffffe6
    2a18:	1d0c01e8 	stfnes	f0, [ip, #-928]	; 0xfffffc60
    2a1c:	0f000000 	svceq	0x00000000
    2a20:	00001fe9 	andeq	r1, r0, r9, ror #31
    2a24:	0c01ef05 	stceq	15, cr14, [r1], {5}
    2a28:	0000001d 	andeq	r0, r0, sp, lsl r0
    2a2c:	0021a10f 	eoreq	sl, r1, pc, lsl #2
    2a30:	01f20500 	mvnseq	r0, r0, lsl #10
    2a34:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2a38:	21b10f00 			; <UNDEFINED> instruction: 0x21b10f00
    2a3c:	f5050000 			; <UNDEFINED> instruction: 0xf5050000
    2a40:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2a44:	320f0000 	andcc	r0, pc, #0
    2a48:	05000014 	streq	r0, [r0, #-20]	; 0xffffffec
    2a4c:	1d0c01f8 	stfnes	f0, [ip, #-992]	; 0xfffffc20
    2a50:	0f000000 	svceq	0x00000000
    2a54:	00002030 	andeq	r2, r0, r0, lsr r0
    2a58:	0c01fb05 			; <UNDEFINED> instruction: 0x0c01fb05
    2a5c:	0000001d 	andeq	r0, r0, sp, lsl r0
    2a60:	001c350f 	andseq	r3, ip, pc, lsl #10
    2a64:	01fe0500 	mvnseq	r0, r0, lsl #10
    2a68:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2a6c:	16a60f00 	strtne	r0, [r6], r0, lsl #30
    2a70:	02050000 	andeq	r0, r5, #0
    2a74:	001d0c02 	andseq	r0, sp, r2, lsl #24
    2a78:	250f0000 	strcs	r0, [pc, #-0]	; 2a80 <CPSR_IRQ_INHIBIT+0x2a00>
    2a7c:	0500001e 	streq	r0, [r0, #-30]	; 0xffffffe2
    2a80:	1d0c020a 	sfmne	f0, 4, [ip, #-40]	; 0xffffffd8
    2a84:	0f000000 	svceq	0x00000000
    2a88:	00001599 	muleq	r0, r9, r5
    2a8c:	0c020d05 	stceq	13, cr0, [r2], {5}
    2a90:	0000001d 	andeq	r0, r0, sp, lsl r0
    2a94:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2a98:	0007ef00 	andeq	lr, r7, r0, lsl #30
    2a9c:	0f000d00 	svceq	0x00000d00
    2aa0:	00001772 	andeq	r1, r0, r2, ror r7
    2aa4:	0c03fb05 			; <UNDEFINED> instruction: 0x0c03fb05
    2aa8:	000007e4 	andeq	r0, r0, r4, ror #15
    2aac:	0004e60c 	andeq	lr, r4, ip, lsl #12
    2ab0:	00080c00 	andeq	r0, r8, r0, lsl #24
    2ab4:	00241500 	eoreq	r1, r4, r0, lsl #10
    2ab8:	000d0000 	andeq	r0, sp, r0
    2abc:	001cf20f 	andseq	pc, ip, pc, lsl #4
    2ac0:	05840500 	streq	r0, [r4, #1280]	; 0x500
    2ac4:	0007fc14 	andeq	pc, r7, r4, lsl ip	; <UNPREDICTABLE>
    2ac8:	18341600 	ldmdane	r4!, {r9, sl, ip}
    2acc:	01070000 	mrseq	r0, (UNDEF: 7)
    2ad0:	00000093 	muleq	r0, r3, r0
    2ad4:	06058b05 	streq	r8, [r5], -r5, lsl #22
    2ad8:	00000857 	andeq	r0, r0, r7, asr r8
    2adc:	0015ef0b 	andseq	lr, r5, fp, lsl #30
    2ae0:	3f0b0000 	svccc	0x000b0000
    2ae4:	0100001a 	tsteq	r0, sl, lsl r0
    2ae8:	0011c70b 	andseq	ip, r1, fp, lsl #14
    2aec:	630b0200 	movwvs	r0, #45568	; 0xb200
    2af0:	03000021 	movweq	r0, #33	; 0x21
    2af4:	001d6c0b 	andseq	r6, sp, fp, lsl #24
    2af8:	5f0b0400 	svcpl	0x000b0400
    2afc:	0500001d 	streq	r0, [r0, #-29]	; 0xffffffe3
    2b00:	00129e0b 	andseq	r9, r2, fp, lsl #28
    2b04:	0f000600 	svceq	0x00000600
    2b08:	00002153 	andeq	r2, r0, r3, asr r1
    2b0c:	15059805 	strne	r9, [r5, #-2053]	; 0xfffff7fb
    2b10:	00000819 	andeq	r0, r0, r9, lsl r8
    2b14:	0020550f 	eoreq	r5, r0, pc, lsl #10
    2b18:	07990500 	ldreq	r0, [r9, r0, lsl #10]
    2b1c:	00002411 	andeq	r2, r0, r1, lsl r4
    2b20:	1cdf0f00 	ldclne	15, cr0, [pc], {0}
    2b24:	ae050000 	cdpge	0, 0, cr0, cr5, cr0, {0}
    2b28:	001d0c07 	andseq	r0, sp, r7, lsl #24
    2b2c:	c8040000 	stmdagt	r4, {}	; <UNPREDICTABLE>
    2b30:	0600001f 			; <UNDEFINED> instruction: 0x0600001f
    2b34:	0093167b 	addseq	r1, r3, fp, ror r6
    2b38:	7e0e0000 	cdpvc	0, 0, cr0, cr14, cr0, {0}
    2b3c:	03000008 	movweq	r0, #8
    2b40:	02b70502 	adcseq	r0, r7, #8388608	; 0x800000
    2b44:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    2b48:	00158207 	andseq	r8, r5, r7, lsl #4
    2b4c:	04040300 	streq	r0, [r4], #-768	; 0xfffffd00
    2b50:	00001356 	andeq	r1, r0, r6, asr r3
    2b54:	4e030803 	cdpmi	8, 0, cr0, cr3, cr3, {0}
    2b58:	03000013 	movweq	r0, #19
    2b5c:	1cc80408 	cfstrdne	mvd0, [r8], {8}
    2b60:	10030000 	andne	r0, r3, r0
    2b64:	001d7a03 	andseq	r7, sp, r3, lsl #20
    2b68:	088a0c00 	stmeq	sl, {sl, fp}
    2b6c:	08c90000 	stmiaeq	r9, {}^	; <UNPREDICTABLE>
    2b70:	24150000 	ldrcs	r0, [r5], #-0
    2b74:	ff000000 			; <UNDEFINED> instruction: 0xff000000
    2b78:	08b90e00 	ldmeq	r9!, {r9, sl, fp}
    2b7c:	740f0000 	strvc	r0, [pc], #-0	; 2b84 <CPSR_IRQ_INHIBIT+0x2b04>
    2b80:	0600001b 			; <UNDEFINED> instruction: 0x0600001b
    2b84:	c91601fc 	ldmdbgt	r6, {r2, r3, r4, r5, r6, r7, r8}
    2b88:	0f000008 	svceq	0x00000008
    2b8c:	00001305 	andeq	r1, r0, r5, lsl #6
    2b90:	16020206 	strne	r0, [r2], -r6, lsl #4
    2b94:	000008c9 	andeq	r0, r0, r9, asr #17
    2b98:	001ffb04 	andseq	pc, pc, r4, lsl #22
    2b9c:	102a0700 	eorne	r0, sl, r0, lsl #14
    2ba0:	000004f9 	strdeq	r0, [r0], -r9
    2ba4:	0008e80c 	andeq	lr, r8, ip, lsl #16
    2ba8:	0008ff00 	andeq	pc, r8, r0, lsl #30
    2bac:	09000d00 	stmdbeq	r0, {r8, sl, fp}
    2bb0:	00001039 	andeq	r1, r0, r9, lsr r0
    2bb4:	f4112f07 			; <UNDEFINED> instruction: 0xf4112f07
    2bb8:	09000008 	stmdbeq	r0, {r3}
    2bbc:	00001013 	andeq	r1, r0, r3, lsl r0
    2bc0:	f4113007 			; <UNDEFINED> instruction: 0xf4113007
    2bc4:	17000008 	strne	r0, [r0, -r8]
    2bc8:	000008ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    2bcc:	0a093308 	beq	24f7f4 <_bss_end+0x246548>
    2bd0:	92780305 	rsbsls	r0, r8, #335544320	; 0x14000000
    2bd4:	0b170000 	bleq	5c2bdc <_bss_end+0x5b9930>
    2bd8:	08000009 	stmdaeq	r0, {r0, r3}
    2bdc:	050a0934 	streq	r0, [sl, #-2356]	; 0xfffff6cc
    2be0:	00928403 	addseq	r8, r2, r3, lsl #8
	...

Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
   0:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
   4:	030b130e 	movweq	r1, #45838	; 0xb30e
   8:	110e1b0e 	tstne	lr, lr, lsl #22
   c:	10061201 	andne	r1, r6, r1, lsl #4
  10:	02000017 	andeq	r0, r0, #23
  14:	193f002e 	ldmdbne	pc!, {r1, r2, r3, r5}	; <UNPREDICTABLE>
  18:	0b3a0e03 	bleq	e8382c <_bss_end+0xe7a580>
  1c:	0b390b3b 	bleq	e42d10 <_bss_end+0xe39a64>
  20:	06120111 			; <UNDEFINED> instruction: 0x06120111
  24:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
  28:	03000019 	movweq	r0, #25
  2c:	0e030139 	mcreq	1, 0, r0, cr3, cr9, {1}
  30:	0b3b0b3a 	bleq	ec2d20 <_bss_end+0xeb9a74>
  34:	00001301 	andeq	r1, r0, r1, lsl #6
  38:	3f012e04 	svccc	0x00012e04
  3c:	3a0e0319 	bcc	380ca8 <_bss_end+0x3779fc>
  40:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
  44:	01193c0b 	tsteq	r9, fp, lsl #24
  48:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
  4c:	13490005 	movtne	r0, #36869	; 0x9005
  50:	16060000 	strne	r0, [r6], -r0
  54:	3a0e0300 	bcc	380c5c <_bss_end+0x3779b0>
  58:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
  5c:	0013490b 	andseq	r4, r3, fp, lsl #18
  60:	012e0700 			; <UNDEFINED> instruction: 0x012e0700
  64:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
  68:	0b3b0b3a 	bleq	ec2d58 <_bss_end+0xeb9aac>
  6c:	13490b39 	movtne	r0, #39737	; 0x9b39
  70:	0000193c 	andeq	r1, r0, ip, lsr r9
  74:	0b000f08 	bleq	3c9c <CPSR_IRQ_INHIBIT+0x3c1c>
  78:	0013490b 	andseq	r4, r3, fp, lsl #18
  7c:	00240900 	eoreq	r0, r4, r0, lsl #18
  80:	0b3e0b0b 	bleq	f82cb4 <_bss_end+0xf79a08>
  84:	00000e03 	andeq	r0, r0, r3, lsl #28
  88:	47012e0a 	strmi	r2, [r1, -sl, lsl #28]
  8c:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
  90:	97184006 	ldrls	r4, [r8, -r6]
  94:	13011942 	movwne	r1, #6466	; 0x1942
  98:	050b0000 	streq	r0, [fp, #-0]
  9c:	02134900 	andseq	r4, r3, #0, 18
  a0:	0c000018 	stceq	0, cr0, [r0], {24}
  a4:	08030005 	stmdaeq	r3, {r0, r2}
  a8:	0b3b0b3a 	bleq	ec2d98 <_bss_end+0xeb9aec>
  ac:	13490b39 	movtne	r0, #39737	; 0x9b39
  b0:	00001802 	andeq	r1, r0, r2, lsl #16
  b4:	0b00240d 	bleq	90f0 <_cpp_startup+0x38>
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
  e4:	0b0b0024 	bleq	2c017c <_bss_end+0x2b6ed0>
  e8:	0e030b3e 	vmoveq.16	d3[0], r0
  ec:	24030000 	strcs	r0, [r3], #-0
  f0:	3e0b0b00 	vmlacc.f64	d0, d11, d0
  f4:	0008030b 	andeq	r0, r8, fp, lsl #6
  f8:	00160400 	andseq	r0, r6, r0, lsl #8
  fc:	0b3a0e03 	bleq	e83910 <_bss_end+0xe7a664>
 100:	0b390b3b 	bleq	e42df4 <_bss_end+0xe39b48>
 104:	00001349 	andeq	r1, r0, r9, asr #6
 108:	49002605 	stmdbmi	r0, {r0, r2, r9, sl, sp}
 10c:	06000013 			; <UNDEFINED> instruction: 0x06000013
 110:	08030139 	stmdaeq	r3, {r0, r3, r4, r5, r8}
 114:	0b3b0b3a 	bleq	ec2e04 <_bss_end+0xeb9b58>
 118:	13010b39 	movwne	r0, #6969	; 0x1b39
 11c:	34070000 	strcc	r0, [r7], #-0
 120:	3a0e0300 	bcc	380d28 <_bss_end+0x377a7c>
 124:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 128:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
 12c:	6c061c19 	stcvs	12, cr1, [r6], {25}
 130:	08000019 	stmdaeq	r0, {r0, r3, r4}
 134:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 138:	0b3b0b3a 	bleq	ec2e28 <_bss_end+0xeb9b7c>
 13c:	13490b39 	movtne	r0, #39737	; 0x9b39
 140:	0b1c193c 	bleq	706638 <_bss_end+0x6fd38c>
 144:	0000196c 	andeq	r1, r0, ip, ror #18
 148:	03010409 	movweq	r0, #5129	; 0x1409
 14c:	3e196d0e 	cdpcc	13, 1, cr6, cr9, cr14, {0}
 150:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
 154:	3b0b3a13 	blcc	2ce9a8 <_bss_end+0x2c56fc>
 158:	010b390b 	tsteq	fp, fp, lsl #18
 15c:	0a000013 	beq	1b0 <CPSR_IRQ_INHIBIT+0x130>
 160:	0e030028 	cdpeq	0, 0, cr0, cr3, cr8, {1}
 164:	00000b1c 	andeq	r0, r0, ip, lsl fp
 168:	4700340b 	strmi	r3, [r0, -fp, lsl #8]
 16c:	0c000013 	stceq	0, cr0, [r0], {19}
 170:	08030028 	stmdaeq	r3, {r3, r5}
 174:	00000b1c 	andeq	r0, r0, ip, lsl fp
 178:	0301020d 	movweq	r0, #4621	; 0x120d
 17c:	3a0b0b0e 	bcc	2c2dbc <_bss_end+0x2b9b10>
 180:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 184:	0013010b 	andseq	r0, r3, fp, lsl #2
 188:	000d0e00 	andeq	r0, sp, r0, lsl #28
 18c:	0b3a0e03 	bleq	e839a0 <_bss_end+0xe7a6f4>
 190:	0b390b3b 	bleq	e42e84 <_bss_end+0xe39bd8>
 194:	0b381349 	bleq	e04ec0 <_bss_end+0xdfbc14>
 198:	2e0f0000 	cdpcs	0, 0, cr0, cr15, cr0, {0}
 19c:	03193f01 	tsteq	r9, #1, 30
 1a0:	3b0b3a0e 	blcc	2ce9e0 <_bss_end+0x2c5734>
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
 1cc:	0b3b0b3a 	bleq	ec2ebc <_bss_end+0xeb9c10>
 1d0:	0e6e0b39 	vmoveq.8	d14[5], r0
 1d4:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 1d8:	13011364 	movwne	r1, #4964	; 0x1364
 1dc:	2e130000 	cdpcs	0, 1, cr0, cr3, cr0, {0}
 1e0:	03193f01 	tsteq	r9, #1, 30
 1e4:	3b0b3a0e 	blcc	2cea24 <_bss_end+0x2c5778>
 1e8:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 1ec:	3213490e 	andscc	r4, r3, #229376	; 0x38000
 1f0:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 1f4:	14000013 	strne	r0, [r0], #-19	; 0xffffffed
 1f8:	0b0b000f 	bleq	2c023c <_bss_end+0x2b6f90>
 1fc:	00001349 	andeq	r1, r0, r9, asr #6
 200:	0b001015 	bleq	425c <CPSR_IRQ_INHIBIT+0x41dc>
 204:	0013490b 	andseq	r4, r3, fp, lsl #18
 208:	00341600 	eorseq	r1, r4, r0, lsl #12
 20c:	0b3a0e03 	bleq	e83a20 <_bss_end+0xe7a774>
 210:	0b390b3b 	bleq	e42f04 <_bss_end+0xe39c58>
 214:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
 218:	0000193c 	andeq	r1, r0, ip, lsr r9
 21c:	47003417 	smladmi	r0, r7, r4, r3
 220:	3b0b3a13 	blcc	2cea74 <_bss_end+0x2c57c8>
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
 254:	0b3a0e03 	bleq	e83a68 <_bss_end+0xe7a7bc>
 258:	0b390b3b 	bleq	e42f4c <_bss_end+0xe39ca0>
 25c:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 260:	2e1b0000 	cdpcs	0, 1, cr0, cr11, cr0, {0}
 264:	3a134701 	bcc	4d1e70 <_bss_end+0x4c8bc4>
 268:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 26c:	1113640b 	tstne	r3, fp, lsl #8
 270:	40061201 	andmi	r1, r6, r1, lsl #4
 274:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
 278:	00001301 	andeq	r1, r0, r1, lsl #6
 27c:	0300051c 	movweq	r0, #1308	; 0x51c
 280:	3413490e 	ldrcc	r4, [r3], #-2318	; 0xfffff6f2
 284:	00180219 	andseq	r0, r8, r9, lsl r2
 288:	00051d00 	andeq	r1, r5, r0, lsl #26
 28c:	0b3a0803 	bleq	e822a0 <_bss_end+0xe78ff4>
 290:	0b390b3b 	bleq	e42f84 <_bss_end+0xe39cd8>
 294:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 298:	341e0000 	ldrcc	r0, [lr], #-0
 29c:	3a080300 	bcc	200ea4 <_bss_end+0x1f7bf8>
 2a0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 2a4:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 2a8:	1f000018 	svcne	0x00000018
 2ac:	1347012e 	movtne	r0, #28974	; 0x712e
 2b0:	0b3b0b3a 	bleq	ec2fa0 <_bss_end+0xeb9cf4>
 2b4:	13640b39 	cmnne	r4, #58368	; 0xe400
 2b8:	06120111 			; <UNDEFINED> instruction: 0x06120111
 2bc:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 2c0:	00130119 	andseq	r0, r3, r9, lsl r1
 2c4:	012e2000 			; <UNDEFINED> instruction: 0x012e2000
 2c8:	0b3a1347 	bleq	e84fec <_bss_end+0xe7bd40>
 2cc:	0b390b3b 	bleq	e42fc0 <_bss_end+0xe39d14>
 2d0:	0b201364 	bleq	805068 <_bss_end+0x7fbdbc>
 2d4:	00001301 	andeq	r1, r0, r1, lsl #6
 2d8:	03000521 	movweq	r0, #1313	; 0x521
 2dc:	3413490e 	ldrcc	r4, [r3], #-2318	; 0xfffff6f2
 2e0:	22000019 	andcs	r0, r0, #25
 2e4:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
 2e8:	0b3b0b3a 	bleq	ec2fd8 <_bss_end+0xeb9d2c>
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
 324:	0b0b0024 	bleq	2c03bc <_bss_end+0x2b7110>
 328:	0e030b3e 	vmoveq.16	d3[0], r0
 32c:	24030000 	strcs	r0, [r3], #-0
 330:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 334:	0008030b 	andeq	r0, r8, fp, lsl #6
 338:	00160400 	andseq	r0, r6, r0, lsl #8
 33c:	0b3a0e03 	bleq	e83b50 <_bss_end+0xe7a8a4>
 340:	0b390b3b 	bleq	e43034 <_bss_end+0xe39d88>
 344:	00001349 	andeq	r1, r0, r9, asr #6
 348:	49002605 	stmdbmi	r0, {r0, r2, r9, sl, sp}
 34c:	06000013 			; <UNDEFINED> instruction: 0x06000013
 350:	13490035 	movtne	r0, #36917	; 0x9035
 354:	39070000 	stmdbcc	r7, {}	; <UNPREDICTABLE>
 358:	3a080301 	bcc	200f64 <_bss_end+0x1f7cb8>
 35c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 360:	0013010b 	andseq	r0, r3, fp, lsl #2
 364:	00340800 	eorseq	r0, r4, r0, lsl #16
 368:	0b3a0e03 	bleq	e83b7c <_bss_end+0xe7a8d0>
 36c:	0b390b3b 	bleq	e43060 <_bss_end+0xe39db4>
 370:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 374:	196c061c 	stmdbne	ip!, {r2, r3, r4, r9, sl}^
 378:	34090000 	strcc	r0, [r9], #-0
 37c:	3a0e0300 	bcc	380f84 <_bss_end+0x377cd8>
 380:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 384:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
 388:	6c0b1c19 	stcvs	12, cr1, [fp], {25}
 38c:	0a000019 	beq	3f8 <CPSR_IRQ_INHIBIT+0x378>
 390:	0e030104 	adfeqs	f0, f3, f4
 394:	0b3e196d 	bleq	f86950 <_bss_end+0xf7d6a4>
 398:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 39c:	0b3b0b3a 	bleq	ec308c <_bss_end+0xeb9de0>
 3a0:	00000b39 	andeq	r0, r0, r9, lsr fp
 3a4:	0300280b 	movweq	r2, #2059	; 0x80b
 3a8:	000b1c0e 	andeq	r1, fp, lr, lsl #24
 3ac:	00340c00 	eorseq	r0, r4, r0, lsl #24
 3b0:	00001347 	andeq	r1, r0, r7, asr #6
 3b4:	0301040d 	movweq	r0, #5133	; 0x140d
 3b8:	3e196d0e 	cdpcc	13, 1, cr6, cr9, cr14, {0}
 3bc:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
 3c0:	3b0b3a13 	blcc	2cec14 <_bss_end+0x2c5968>
 3c4:	010b390b 	tsteq	fp, fp, lsl #18
 3c8:	0e000013 	mcreq	0, 0, r0, cr0, cr3, {0}
 3cc:	0e030102 	adfeqs	f0, f3, f2
 3d0:	0b3a0b0b 	bleq	e83004 <_bss_end+0xe79d58>
 3d4:	0b390b3b 	bleq	e430c8 <_bss_end+0xe39e1c>
 3d8:	00001301 	andeq	r1, r0, r1, lsl #6
 3dc:	03000d0f 	movweq	r0, #3343	; 0xd0f
 3e0:	3b0b3a0e 	blcc	2cec20 <_bss_end+0x2c5974>
 3e4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 3e8:	000b3813 	andeq	r3, fp, r3, lsl r8
 3ec:	00161000 	andseq	r1, r6, r0
 3f0:	0b3a0e03 	bleq	e83c04 <_bss_end+0xe7a958>
 3f4:	0b390b3b 	bleq	e430e8 <_bss_end+0xe39e3c>
 3f8:	0b321349 	bleq	c85124 <_bss_end+0xc7be78>
 3fc:	2e110000 	cdpcs	0, 1, cr0, cr1, cr0, {0}
 400:	03193f01 	tsteq	r9, #1, 30
 404:	3b0b3a0e 	blcc	2cec44 <_bss_end+0x2c5998>
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
 430:	0b3b0b3a 	bleq	ec3120 <_bss_end+0xeb9e74>
 434:	0e6e0b39 	vmoveq.8	d14[5], r0
 438:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 43c:	13011364 	movwne	r1, #4964	; 0x1364
 440:	2e150000 	cdpcs	0, 1, cr0, cr5, cr0, {0}
 444:	03193f01 	tsteq	r9, #1, 30
 448:	3b0b3a0e 	blcc	2cec88 <_bss_end+0x2c59dc>
 44c:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 450:	3213490e 	andscc	r4, r3, #229376	; 0x38000
 454:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 458:	16000013 			; <UNDEFINED> instruction: 0x16000013
 45c:	0b0b000f 	bleq	2c04a0 <_bss_end+0x2b71f4>
 460:	00001349 	andeq	r1, r0, r9, asr #6
 464:	00001517 	andeq	r1, r0, r7, lsl r5
 468:	00101800 	andseq	r1, r0, r0, lsl #16
 46c:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 470:	34190000 	ldrcc	r0, [r9], #-0
 474:	3a0e0300 	bcc	38107c <_bss_end+0x377dd0>
 478:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 47c:	3f13490b 	svccc	0x0013490b
 480:	00193c19 	andseq	r3, r9, r9, lsl ip
 484:	00341a00 	eorseq	r1, r4, r0, lsl #20
 488:	0b3a1347 	bleq	e851ac <_bss_end+0xe7bf00>
 48c:	0b390b3b 	bleq	e43180 <_bss_end+0xe39ed4>
 490:	00001802 	andeq	r1, r0, r2, lsl #16
 494:	0301131b 	movweq	r1, #4891	; 0x131b
 498:	3a0b0b0e 	bcc	2c30d8 <_bss_end+0x2b9e2c>
 49c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 4a0:	0013010b 	andseq	r0, r3, fp, lsl #2
 4a4:	000d1c00 	andeq	r1, sp, r0, lsl #24
 4a8:	0b3a0e03 	bleq	e83cbc <_bss_end+0xe7aa10>
 4ac:	0b390b3b 	bleq	e431a0 <_bss_end+0xe39ef4>
 4b0:	0b0b1349 	bleq	2c51dc <_bss_end+0x2bbf30>
 4b4:	0b0c0b0d 	bleq	3030f0 <_bss_end+0x2f9e44>
 4b8:	00000b38 	andeq	r0, r0, r8, lsr fp
 4bc:	03000d1d 	movweq	r0, #3357	; 0xd1d
 4c0:	3b0b3a0e 	blcc	2ced00 <_bss_end+0x2c5a54>
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
 4fc:	0b3a0e03 	bleq	e83d10 <_bss_end+0xe7aa64>
 500:	0b390b3b 	bleq	e431f4 <_bss_end+0xe39f48>
 504:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 508:	2e210000 	cdpcs	0, 2, cr0, cr1, cr0, {0}
 50c:	3a134701 	bcc	4d2118 <_bss_end+0x4c8e6c>
 510:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 514:	1113640b 	tstne	r3, fp, lsl #8
 518:	40061201 	andmi	r1, r6, r1, lsl #4
 51c:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
 520:	00001301 	andeq	r1, r0, r1, lsl #6
 524:	03000522 	movweq	r0, #1314	; 0x522
 528:	3413490e 	ldrcc	r4, [r3], #-2318	; 0xfffff6f2
 52c:	00180219 	andseq	r0, r8, r9, lsl r2
 530:	00342300 	eorseq	r2, r4, r0, lsl #6
 534:	0b3a0803 	bleq	e82548 <_bss_end+0xe7929c>
 538:	0b390b3b 	bleq	e4322c <_bss_end+0xe39f80>
 53c:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 540:	2e240000 	cdpcs	0, 2, cr0, cr4, cr0, {0}
 544:	3a134701 	bcc	4d2150 <_bss_end+0x4c8ea4>
 548:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 54c:	1113640b 	tstne	r3, fp, lsl #8
 550:	40061201 	andmi	r1, r6, r1, lsl #4
 554:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 558:	00001301 	andeq	r1, r0, r1, lsl #6
 55c:	03000525 	movweq	r0, #1317	; 0x525
 560:	3b0b3a08 	blcc	2ced88 <_bss_end+0x2c5adc>
 564:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 568:	00180213 	andseq	r0, r8, r3, lsl r2
 56c:	012e2600 			; <UNDEFINED> instruction: 0x012e2600
 570:	0b3a1347 	bleq	e85294 <_bss_end+0xe7bfe8>
 574:	0b390b3b 	bleq	e43268 <_bss_end+0xe39fbc>
 578:	0b201364 	bleq	805310 <_bss_end+0x7fc064>
 57c:	00001301 	andeq	r1, r0, r1, lsl #6
 580:	03000527 	movweq	r0, #1319	; 0x527
 584:	3413490e 	ldrcc	r4, [r3], #-2318	; 0xfffff6f2
 588:	28000019 	stmdacs	r0, {r0, r3, r4}
 58c:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
 590:	0b3b0b3a 	bleq	ec3280 <_bss_end+0xeb9fd4>
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
 5cc:	0b0b0024 	bleq	2c0664 <_bss_end+0x2b73b8>
 5d0:	0e030b3e 	vmoveq.16	d3[0], r0
 5d4:	24030000 	strcs	r0, [r3], #-0
 5d8:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 5dc:	0008030b 	andeq	r0, r8, fp, lsl #6
 5e0:	00160400 	andseq	r0, r6, r0, lsl #8
 5e4:	0b3a0e03 	bleq	e83df8 <_bss_end+0xe7ab4c>
 5e8:	0b390b3b 	bleq	e432dc <_bss_end+0xe3a030>
 5ec:	00001349 	andeq	r1, r0, r9, asr #6
 5f0:	49002605 	stmdbmi	r0, {r0, r2, r9, sl, sp}
 5f4:	06000013 			; <UNDEFINED> instruction: 0x06000013
 5f8:	13490035 	movtne	r0, #36917	; 0x9035
 5fc:	39070000 	stmdbcc	r7, {}	; <UNPREDICTABLE>
 600:	3a080301 	bcc	20120c <_bss_end+0x1f7f60>
 604:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 608:	0013010b 	andseq	r0, r3, fp, lsl #2
 60c:	00340800 	eorseq	r0, r4, r0, lsl #16
 610:	0b3a0e03 	bleq	e83e24 <_bss_end+0xe7ab78>
 614:	0b390b3b 	bleq	e43308 <_bss_end+0xe3a05c>
 618:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 61c:	196c061c 	stmdbne	ip!, {r2, r3, r4, r9, sl}^
 620:	34090000 	strcc	r0, [r9], #-0
 624:	3a0e0300 	bcc	38122c <_bss_end+0x377f80>
 628:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 62c:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
 630:	6c0b1c19 	stcvs	12, cr1, [fp], {25}
 634:	0a000019 	beq	6a0 <CPSR_IRQ_INHIBIT+0x620>
 638:	0e030104 	adfeqs	f0, f3, f4
 63c:	0b3e196d 	bleq	f86bf8 <_bss_end+0xf7d94c>
 640:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 644:	0b3b0b3a 	bleq	ec3334 <_bss_end+0xeba088>
 648:	13010b39 	movwne	r0, #6969	; 0x1b39
 64c:	280b0000 	stmdacs	fp, {}	; <UNPREDICTABLE>
 650:	1c0e0300 	stcne	3, cr0, [lr], {-0}
 654:	0c00000b 	stceq	0, cr0, [r0], {11}
 658:	08030028 	stmdaeq	r3, {r3, r5}
 65c:	00000b1c 	andeq	r0, r0, ip, lsl fp
 660:	0301040d 	movweq	r0, #5133	; 0x140d
 664:	3e196d0e 	cdpcc	13, 1, cr6, cr9, cr14, {0}
 668:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
 66c:	3b0b3a13 	blcc	2ceec0 <_bss_end+0x2c5c14>
 670:	000b390b 	andeq	r3, fp, fp, lsl #18
 674:	00340e00 	eorseq	r0, r4, r0, lsl #28
 678:	00001347 	andeq	r1, r0, r7, asr #6
 67c:	0301020f 	movweq	r0, #4623	; 0x120f
 680:	3a0b0b0e 	bcc	2c32c0 <_bss_end+0x2ba014>
 684:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 688:	0013010b 	andseq	r0, r3, fp, lsl #2
 68c:	000d1000 	andeq	r1, sp, r0
 690:	0b3a0e03 	bleq	e83ea4 <_bss_end+0xe7abf8>
 694:	0b390b3b 	bleq	e43388 <_bss_end+0xe3a0dc>
 698:	0b381349 	bleq	e053c4 <_bss_end+0xdfc118>
 69c:	2e110000 	cdpcs	0, 1, cr0, cr1, cr0, {0}
 6a0:	03193f01 	tsteq	r9, #1, 30
 6a4:	3b0b3a0e 	blcc	2ceee4 <_bss_end+0x2c5c38>
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
 6d0:	0b3b0b3a 	bleq	ec33c0 <_bss_end+0xeba114>
 6d4:	0e6e0b39 	vmoveq.8	d14[5], r0
 6d8:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 6dc:	13011364 	movwne	r1, #4964	; 0x1364
 6e0:	2e150000 	cdpcs	0, 1, cr0, cr5, cr0, {0}
 6e4:	03193f01 	tsteq	r9, #1, 30
 6e8:	3b0b3a0e 	blcc	2cef28 <_bss_end+0x2c5c7c>
 6ec:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 6f0:	3213490e 	andscc	r4, r3, #229376	; 0x38000
 6f4:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 6f8:	16000013 			; <UNDEFINED> instruction: 0x16000013
 6fc:	0b0b000f 	bleq	2c0740 <_bss_end+0x2b7494>
 700:	00001349 	andeq	r1, r0, r9, asr #6
 704:	0b001017 	bleq	4768 <CPSR_IRQ_INHIBIT+0x46e8>
 708:	0013490b 	andseq	r4, r3, fp, lsl #18
 70c:	00341800 	eorseq	r1, r4, r0, lsl #16
 710:	0b3a0e03 	bleq	e83f24 <_bss_end+0xe7ac78>
 714:	0b390b3b 	bleq	e43408 <_bss_end+0xe3a15c>
 718:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
 71c:	0000193c 	andeq	r1, r0, ip, lsr r9
 720:	3f012e19 	svccc	0x00012e19
 724:	3a0e0319 	bcc	381390 <_bss_end+0x3780e4>
 728:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 72c:	320e6e0b 	andcc	r6, lr, #11, 28	; 0xb0
 730:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 734:	1a000013 	bne	788 <CPSR_IRQ_INHIBIT+0x708>
 738:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
 73c:	0b3b0b3a 	bleq	ec342c <_bss_end+0xeba180>
 740:	13490b39 	movtne	r0, #39737	; 0x9b39
 744:	00000b32 	andeq	r0, r0, r2, lsr fp
 748:	0000151b 	andeq	r1, r0, fp, lsl r5
 74c:	00341c00 	eorseq	r1, r4, r0, lsl #24
 750:	0b3a1347 	bleq	e85474 <_bss_end+0xe7c1c8>
 754:	0b390b3b 	bleq	e43448 <_bss_end+0xe3a19c>
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
 784:	3a0e0300 	bcc	38138c <_bss_end+0x3780e0>
 788:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 78c:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 790:	20000018 	andcs	r0, r0, r8, lsl r0
 794:	1347012e 	movtne	r0, #28974	; 0x712e
 798:	0b3b0b3a 	bleq	ec3488 <_bss_end+0xeba1dc>
 79c:	13640b39 	cmnne	r4, #58368	; 0xe400
 7a0:	06120111 			; <UNDEFINED> instruction: 0x06120111
 7a4:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 7a8:	00130119 	andseq	r0, r3, r9, lsl r1
 7ac:	00052100 	andeq	r2, r5, r0, lsl #2
 7b0:	13490e03 	movtne	r0, #40451	; 0x9e03
 7b4:	18021934 	stmdane	r2, {r2, r4, r5, r8, fp, ip}
 7b8:	34220000 	strtcc	r0, [r2], #-0
 7bc:	3a0e0300 	bcc	3813c4 <_bss_end+0x378118>
 7c0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 7c4:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 7c8:	23000018 	movwcs	r0, #24
 7cc:	1347012e 	movtne	r0, #28974	; 0x712e
 7d0:	0b3b0b3a 	bleq	ec34c0 <_bss_end+0xeba214>
 7d4:	13640b39 	cmnne	r4, #58368	; 0xe400
 7d8:	06120111 			; <UNDEFINED> instruction: 0x06120111
 7dc:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 7e0:	00130119 	andseq	r0, r3, r9, lsl r1
 7e4:	00052400 	andeq	r2, r5, r0, lsl #8
 7e8:	0b3a0803 	bleq	e827fc <_bss_end+0xe79550>
 7ec:	0b390b3b 	bleq	e434e0 <_bss_end+0xe3a234>
 7f0:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 7f4:	2e250000 	cdpcs	0, 2, cr0, cr5, cr0, {0}
 7f8:	3a134701 	bcc	4d2404 <_bss_end+0x4c9158>
 7fc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 800:	2013640b 	andscs	r6, r3, fp, lsl #8
 804:	0013010b 	andseq	r0, r3, fp, lsl #2
 808:	00052600 	andeq	r2, r5, r0, lsl #12
 80c:	13490e03 	movtne	r0, #40451	; 0x9e03
 810:	00001934 	andeq	r1, r0, r4, lsr r9
 814:	03000527 	movweq	r0, #1319	; 0x527
 818:	3b0b3a0e 	blcc	2cf058 <_bss_end+0x2c5dac>
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
 848:	3b0b3a0e 	blcc	2cf088 <_bss_end+0x2c5ddc>
 84c:	110b390b 	tstne	fp, fp, lsl #18
 850:	40061201 	andmi	r1, r6, r1, lsl #4
 854:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 858:	2e2b0000 	cdpcs	0, 2, cr0, cr11, cr0, {0}
 85c:	03193f01 	tsteq	r9, #1, 30
 860:	3b0b3a0e 	blcc	2cf0a0 <_bss_end+0x2c5df4>
 864:	110b390b 	tstne	fp, fp, lsl #18
 868:	40061201 	andmi	r1, r6, r1, lsl #4
 86c:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
 870:	00001301 	andeq	r1, r0, r1, lsl #6
 874:	01110100 	tsteq	r1, r0, lsl #2
 878:	0b130e25 	bleq	4c4114 <_bss_end+0x4bae68>
 87c:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
 880:	06120111 			; <UNDEFINED> instruction: 0x06120111
 884:	00001710 	andeq	r1, r0, r0, lsl r7
 888:	0b002402 	bleq	9898 <_bss_end+0x5ec>
 88c:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 890:	0300000e 	movweq	r0, #14
 894:	0b0b0024 	bleq	2c092c <_bss_end+0x2b7680>
 898:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
 89c:	35040000 	strcc	r0, [r4, #-0]
 8a0:	00134900 	andseq	r4, r3, r0, lsl #18
 8a4:	00160500 	andseq	r0, r6, r0, lsl #10
 8a8:	0b3a0e03 	bleq	e840bc <_bss_end+0xe7ae10>
 8ac:	0b390b3b 	bleq	e435a0 <_bss_end+0xe3a2f4>
 8b0:	00001349 	andeq	r1, r0, r9, asr #6
 8b4:	49002606 	stmdbmi	r0, {r1, r2, r9, sl, sp}
 8b8:	07000013 	smladeq	r0, r3, r0, r0
 8bc:	0e030104 	adfeqs	f0, f3, f4
 8c0:	0b3e196d 	bleq	f86e7c <_bss_end+0xf7dbd0>
 8c4:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 8c8:	0b3b0b3a 	bleq	ec35b8 <_bss_end+0xeba30c>
 8cc:	13010b39 	movwne	r0, #6969	; 0x1b39
 8d0:	28080000 	stmdacs	r8, {}	; <UNPREDICTABLE>
 8d4:	1c0e0300 	stcne	3, cr0, [lr], {-0}
 8d8:	0900000b 	stmdbeq	r0, {r0, r1, r3}
 8dc:	08030028 	stmdaeq	r3, {r3, r5}
 8e0:	00000b1c 	andeq	r0, r0, ip, lsl fp
 8e4:	0301020a 	movweq	r0, #4618	; 0x120a
 8e8:	3a0b0b0e 	bcc	2c3528 <_bss_end+0x2ba27c>
 8ec:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 8f0:	0013010b 	andseq	r0, r3, fp, lsl #2
 8f4:	000d0b00 	andeq	r0, sp, r0, lsl #22
 8f8:	0b3a0e03 	bleq	e8410c <_bss_end+0xe7ae60>
 8fc:	0b390b3b 	bleq	e435f0 <_bss_end+0xe3a344>
 900:	0b381349 	bleq	e0562c <_bss_end+0xdfc380>
 904:	2e0c0000 	cdpcs	0, 0, cr0, cr12, cr0, {0}
 908:	03193f01 	tsteq	r9, #1, 30
 90c:	3b0b3a0e 	blcc	2cf14c <_bss_end+0x2c5ea0>
 910:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 914:	3213490e 	andscc	r4, r3, #229376	; 0x38000
 918:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 91c:	00130113 	andseq	r0, r3, r3, lsl r1
 920:	00050d00 	andeq	r0, r5, r0, lsl #26
 924:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
 928:	050e0000 	streq	r0, [lr, #-0]
 92c:	00134900 	andseq	r4, r3, r0, lsl #18
 930:	012e0f00 			; <UNDEFINED> instruction: 0x012e0f00
 934:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 938:	0b3b0b3a 	bleq	ec3628 <_bss_end+0xeba37c>
 93c:	0e6e0b39 	vmoveq.8	d14[5], r0
 940:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 944:	13011364 	movwne	r1, #4964	; 0x1364
 948:	2e100000 	cdpcs	0, 1, cr0, cr0, cr0, {0}
 94c:	03193f01 	tsteq	r9, #1, 30
 950:	3b0b3a0e 	blcc	2cf190 <_bss_end+0x2c5ee4>
 954:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 958:	3213490e 	andscc	r4, r3, #229376	; 0x38000
 95c:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 960:	11000013 	tstne	r0, r3, lsl r0
 964:	0b0b000f 	bleq	2c09a8 <_bss_end+0x2b76fc>
 968:	00001349 	andeq	r1, r0, r9, asr #6
 96c:	0b001012 	bleq	49bc <CPSR_IRQ_INHIBIT+0x493c>
 970:	0013490b 	andseq	r4, r3, fp, lsl #18
 974:	00341300 	eorseq	r1, r4, r0, lsl #6
 978:	0b3a0e03 	bleq	e8418c <_bss_end+0xe7aee0>
 97c:	0b390b3b 	bleq	e43670 <_bss_end+0xe3a3c4>
 980:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
 984:	0000193c 	andeq	r1, r0, ip, lsr r9
 988:	03013914 	movweq	r3, #6420	; 0x1914
 98c:	3b0b3a08 	blcc	2cf1b4 <_bss_end+0x2c5f08>
 990:	010b390b 	tsteq	fp, fp, lsl #18
 994:	15000013 	strne	r0, [r0, #-19]	; 0xffffffed
 998:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 99c:	0b3b0b3a 	bleq	ec368c <_bss_end+0xeba3e0>
 9a0:	13490b39 	movtne	r0, #39737	; 0x9b39
 9a4:	061c193c 			; <UNDEFINED> instruction: 0x061c193c
 9a8:	0000196c 	andeq	r1, r0, ip, ror #18
 9ac:	03003416 	movweq	r3, #1046	; 0x416
 9b0:	3b0b3a0e 	blcc	2cf1f0 <_bss_end+0x2c5f44>
 9b4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 9b8:	1c193c13 	ldcne	12, cr3, [r9], {19}
 9bc:	00196c0b 	andseq	r6, r9, fp, lsl #24
 9c0:	01041700 	tsteq	r4, r0, lsl #14
 9c4:	196d0e03 	stmdbne	sp!, {r0, r1, r9, sl, fp}^
 9c8:	0b0b0b3e 	bleq	2c36c8 <_bss_end+0x2ba41c>
 9cc:	0b3a1349 	bleq	e856f8 <_bss_end+0xe7c44c>
 9d0:	0b390b3b 	bleq	e436c4 <_bss_end+0xe3a418>
 9d4:	34180000 	ldrcc	r0, [r8], #-0
 9d8:	00134700 	andseq	r4, r3, r0, lsl #14
 9dc:	012e1900 			; <UNDEFINED> instruction: 0x012e1900
 9e0:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 9e4:	0b3b0b3a 	bleq	ec36d4 <_bss_end+0xeba428>
 9e8:	0e6e0b39 	vmoveq.8	d14[5], r0
 9ec:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 9f0:	00001364 	andeq	r1, r0, r4, ror #6
 9f4:	0300161a 	movweq	r1, #1562	; 0x61a
 9f8:	3b0b3a0e 	blcc	2cf238 <_bss_end+0x2c5f8c>
 9fc:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 a00:	000b3213 	andeq	r3, fp, r3, lsl r2
 a04:	00151b00 	andseq	r1, r5, r0, lsl #22
 a08:	341c0000 	ldrcc	r0, [ip], #-0
 a0c:	3a0e0300 	bcc	381614 <_bss_end+0x378368>
 a10:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 a14:	3f13490b 	svccc	0x0013490b
 a18:	00180219 	andseq	r0, r8, r9, lsl r2
 a1c:	002e1d00 	eoreq	r1, lr, r0, lsl #26
 a20:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 a24:	0b3b0b3a 	bleq	ec3714 <_bss_end+0xeba468>
 a28:	13490b39 	movtne	r0, #39737	; 0x9b39
 a2c:	06120111 			; <UNDEFINED> instruction: 0x06120111
 a30:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 a34:	1e000019 	mcrne	0, 0, r0, cr0, cr9, {0}
 a38:	193f002e 	ldmdbne	pc!, {r1, r2, r3, r5}	; <UNPREDICTABLE>
 a3c:	0b3a0e03 	bleq	e84250 <_bss_end+0xe7afa4>
 a40:	0b390b3b 	bleq	e43734 <_bss_end+0xe3a488>
 a44:	06120111 			; <UNDEFINED> instruction: 0x06120111
 a48:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 a4c:	00000019 	andeq	r0, r0, r9, lsl r0
 a50:	10001101 	andne	r1, r0, r1, lsl #2
 a54:	03065506 	movweq	r5, #25862	; 0x6506
 a58:	250e1b0e 	strcs	r1, [lr, #-2830]	; 0xfffff4f2
 a5c:	0005130e 	andeq	r1, r5, lr, lsl #6
 a60:	11010000 	mrsne	r0, (UNDEF: 1)
 a64:	130e2501 	movwne	r2, #58625	; 0xe501
 a68:	1b0e030b 	blne	38169c <_bss_end+0x3783f0>
 a6c:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 a70:	00171006 	andseq	r1, r7, r6
 a74:	00160200 	andseq	r0, r6, r0, lsl #4
 a78:	0b3a0e03 	bleq	e8428c <_bss_end+0xe7afe0>
 a7c:	0b390b3b 	bleq	e43770 <_bss_end+0xe3a4c4>
 a80:	00001349 	andeq	r1, r0, r9, asr #6
 a84:	0b000f03 	bleq	4698 <CPSR_IRQ_INHIBIT+0x4618>
 a88:	0013490b 	andseq	r4, r3, fp, lsl #18
 a8c:	00150400 	andseq	r0, r5, r0, lsl #8
 a90:	34050000 	strcc	r0, [r5], #-0
 a94:	3a0e0300 	bcc	38169c <_bss_end+0x3783f0>
 a98:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 a9c:	3f13490b 	svccc	0x0013490b
 aa0:	00193c19 	andseq	r3, r9, r9, lsl ip
 aa4:	00240600 	eoreq	r0, r4, r0, lsl #12
 aa8:	0b3e0b0b 	bleq	f836dc <_bss_end+0xf7a430>
 aac:	00000803 	andeq	r0, r0, r3, lsl #16
 ab0:	49010107 	stmdbmi	r1, {r0, r1, r2, r8}
 ab4:	00130113 	andseq	r0, r3, r3, lsl r1
 ab8:	00210800 	eoreq	r0, r1, r0, lsl #16
 abc:	062f1349 	strteq	r1, [pc], -r9, asr #6
 ac0:	24090000 	strcs	r0, [r9], #-0
 ac4:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 ac8:	000e030b 	andeq	r0, lr, fp, lsl #6
 acc:	012e0a00 			; <UNDEFINED> instruction: 0x012e0a00
 ad0:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 ad4:	0b3b0b3a 	bleq	ec37c4 <_bss_end+0xeba518>
 ad8:	13490b39 	movtne	r0, #39737	; 0x9b39
 adc:	06120111 			; <UNDEFINED> instruction: 0x06120111
 ae0:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 ae4:	00130119 	andseq	r0, r3, r9, lsl r1
 ae8:	00340b00 	eorseq	r0, r4, r0, lsl #22
 aec:	0b3a0e03 	bleq	e84300 <_bss_end+0xe7b054>
 af0:	0b390b3b 	bleq	e437e4 <_bss_end+0xe3a538>
 af4:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 af8:	2e0c0000 	cdpcs	0, 0, cr0, cr12, cr0, {0}
 afc:	03193f01 	tsteq	r9, #1, 30
 b00:	3b0b3a0e 	blcc	2cf340 <_bss_end+0x2c6094>
 b04:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 b08:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 b0c:	97184006 	ldrls	r4, [r8, -r6]
 b10:	13011942 	movwne	r1, #6466	; 0x1942
 b14:	340d0000 	strcc	r0, [sp], #-0
 b18:	3a080300 	bcc	201720 <_bss_end+0x1f8474>
 b1c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 b20:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 b24:	00000018 	andeq	r0, r0, r8, lsl r0
 b28:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
 b2c:	030b130e 	movweq	r1, #45838	; 0xb30e
 b30:	100e1b0e 	andne	r1, lr, lr, lsl #22
 b34:	02000017 	andeq	r0, r0, #23
 b38:	0b0b0024 	bleq	2c0bd0 <_bss_end+0x2b7924>
 b3c:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
 b40:	24030000 	strcs	r0, [r3], #-0
 b44:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 b48:	000e030b 	andeq	r0, lr, fp, lsl #6
 b4c:	00160400 	andseq	r0, r6, r0, lsl #8
 b50:	0b3a0e03 	bleq	e84364 <_bss_end+0xe7b0b8>
 b54:	0b390b3b 	bleq	e43848 <_bss_end+0xe3a59c>
 b58:	00001349 	andeq	r1, r0, r9, asr #6
 b5c:	0b000f05 	bleq	4778 <CPSR_IRQ_INHIBIT+0x46f8>
 b60:	0013490b 	andseq	r4, r3, fp, lsl #18
 b64:	01150600 	tsteq	r5, r0, lsl #12
 b68:	13491927 	movtne	r1, #39207	; 0x9927
 b6c:	00001301 	andeq	r1, r0, r1, lsl #6
 b70:	49000507 	stmdbmi	r0, {r0, r1, r2, r8, sl}
 b74:	08000013 	stmdaeq	r0, {r0, r1, r4}
 b78:	00000026 	andeq	r0, r0, r6, lsr #32
 b7c:	03003409 	movweq	r3, #1033	; 0x409
 b80:	3b0b3a0e 	blcc	2cf3c0 <_bss_end+0x2c6114>
 b84:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 b88:	3c193f13 	ldccc	15, cr3, [r9], {19}
 b8c:	0a000019 	beq	bf8 <CPSR_IRQ_INHIBIT+0xb78>
 b90:	0e030104 	adfeqs	f0, f3, f4
 b94:	0b0b0b3e 	bleq	2c3894 <_bss_end+0x2ba5e8>
 b98:	0b3a1349 	bleq	e858c4 <_bss_end+0xe7c618>
 b9c:	0b390b3b 	bleq	e43890 <_bss_end+0xe3a5e4>
 ba0:	00001301 	andeq	r1, r0, r1, lsl #6
 ba4:	0300280b 	movweq	r2, #2059	; 0x80b
 ba8:	000b1c0e 	andeq	r1, fp, lr, lsl #24
 bac:	01010c00 	tsteq	r1, r0, lsl #24
 bb0:	13011349 	movwne	r1, #4937	; 0x1349
 bb4:	210d0000 	mrscs	r0, (UNDEF: 13)
 bb8:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
 bbc:	13490026 	movtne	r0, #36902	; 0x9026
 bc0:	340f0000 	strcc	r0, [pc], #-0	; bc8 <CPSR_IRQ_INHIBIT+0xb48>
 bc4:	3a0e0300 	bcc	3817cc <_bss_end+0x378520>
 bc8:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 bcc:	3f13490b 	svccc	0x0013490b
 bd0:	00193c19 	andseq	r3, r9, r9, lsl ip
 bd4:	00131000 	andseq	r1, r3, r0
 bd8:	193c0e03 	ldmdbne	ip!, {r0, r1, r9, sl, fp}
 bdc:	15110000 	ldrne	r0, [r1, #-0]
 be0:	00192700 	andseq	r2, r9, r0, lsl #14
 be4:	00171200 	andseq	r1, r7, r0, lsl #4
 be8:	193c0e03 	ldmdbne	ip!, {r0, r1, r9, sl, fp}
 bec:	13130000 	tstne	r3, #0
 bf0:	0b0e0301 	bleq	3817fc <_bss_end+0x378550>
 bf4:	3b0b3a0b 	blcc	2cf428 <_bss_end+0x2c617c>
 bf8:	010b3905 	tsteq	fp, r5, lsl #18
 bfc:	14000013 	strne	r0, [r0], #-19	; 0xffffffed
 c00:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 c04:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 c08:	13490b39 	movtne	r0, #39737	; 0x9b39
 c0c:	00000b38 	andeq	r0, r0, r8, lsr fp
 c10:	49002115 	stmdbmi	r0, {r0, r2, r4, r8, sp}
 c14:	000b2f13 	andeq	r2, fp, r3, lsl pc
 c18:	01041600 	tsteq	r4, r0, lsl #12
 c1c:	0b3e0e03 	bleq	f84430 <_bss_end+0xf7b184>
 c20:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 c24:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 c28:	13010b39 	movwne	r0, #6969	; 0x1b39
 c2c:	34170000 	ldrcc	r0, [r7], #-0
 c30:	3a134700 	bcc	4d2838 <_bss_end+0x4c958c>
 c34:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 c38:	0018020b 	andseq	r0, r8, fp, lsl #4
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
  34:	0000083c 	andeq	r0, r0, ip, lsr r8
	...
  40:	0000001c 	andeq	r0, r0, ip, lsl r0
  44:	0acd0002 	beq	ff340054 <_bss_end+0xff336da8>
  48:	00040000 	andeq	r0, r4, r0
  4c:	00000000 	andeq	r0, r0, r0
  50:	000089a8 	andeq	r8, r0, r8, lsr #19
  54:	00000290 	muleq	r0, r0, r2
	...
  60:	0000001c 	andeq	r0, r0, ip, lsl r0
  64:	10200002 	eorne	r0, r0, r2
  68:	00040000 	andeq	r0, r4, r0
  6c:	00000000 	andeq	r0, r0, r0
  70:	00008c38 	andeq	r8, r0, r8, lsr ip
  74:	000002dc 	ldrdeq	r0, [r0], -ip
	...
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	19a00002 	stmibne	r0!, {r1}
  88:	00040000 	andeq	r0, r4, r0
  8c:	00000000 	andeq	r0, r0, r0
  90:	00008f14 	andeq	r8, r0, r4, lsl pc
  94:	0000011c 	andeq	r0, r0, ip, lsl r1
	...
  a0:	00000024 	andeq	r0, r0, r4, lsr #32
  a4:	213f0002 	teqcs	pc, r2
  a8:	00040000 	andeq	r0, r4, r0
  ac:	00000000 	andeq	r0, r0, r0
  b0:	00008000 	andeq	r8, r0, r0
  b4:	00000094 	muleq	r0, r4, r0
  b8:	00009030 	andeq	r9, r0, r0, lsr r0
  bc:	00000020 	andeq	r0, r0, r0, lsr #32
	...
  c8:	0000001c 	andeq	r0, r0, ip, lsl r0
  cc:	21610002 	cmncs	r1, r2
  d0:	00040000 	andeq	r0, r4, r0
  d4:	00000000 	andeq	r0, r0, r0
  d8:	00009050 	andeq	r9, r0, r0, asr r0
  dc:	00000118 	andeq	r0, r0, r8, lsl r1
	...
  e8:	00000014 	andeq	r0, r0, r4, lsl r0
  ec:	22b00002 	adcscs	r0, r0, #2
  f0:	00040000 	andeq	r0, r4, r0
	...

Disassembly of section .debug_line:

00000000 <.debug_line>:
   0:	000000b4 	strheq	r0, [r0], -r4
   4:	007b0003 	rsbseq	r0, fp, r3
   8:	01020000 	mrseq	r0, (UNDEF: 2)
   c:	000d0efb 	strdeq	r0, [sp], -fp
  10:	01010101 	tsteq	r1, r1, lsl #2
  14:	01000000 	mrseq	r0, (UNDEF: 0)
  18:	2f010000 	svccs	0x00010000
  1c:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
  20:	6c69732f 	stclvs	3, cr7, [r9], #-188	; 0xffffff44
  24:	79766168 	ldmdbvc	r6!, {r3, r5, r6, r8, sp, lr}^
  28:	63532f6a 	cmpvs	r3, #424	; 0x1a8
  2c:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; fffffe94 <_bss_end+0xffff6be8>
  30:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
  34:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
  38:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
  3c:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
  40:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
  44:	69742d30 	ldmdbvs	r4!, {r4, r5, r8, sl, fp, sp}^
  48:	5f72656d 	svcpl	0x0072656d
  4c:	5f646e61 	svcpl	0x00646e61
  50:	4f495047 	svcmi	0x00495047
  54:	746e695f 	strbtvc	r6, [lr], #-2399	; 0xfffff6a1
  58:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
  5c:	6b2f7470 	blvs	bdd224 <_bss_end+0xbd3f78>
  60:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
  64:	72732f6c 	rsbsvc	r2, r3, #108, 30	; 0x1b0
  68:	63000063 	movwvs	r0, #99	; 0x63
  6c:	632e7878 			; <UNDEFINED> instruction: 0x632e7878
  70:	01007070 	tsteq	r0, r0, ror r0
  74:	623c0000 	eorsvs	r0, ip, #0
  78:	746c6975 	strbtvc	r6, [ip], #-2421	; 0xfffff68b
  7c:	3e6e692d 	vmulcc.f16	s13, s28, s27	; <UNPREDICTABLE>
  80:	00000000 	andeq	r0, r0, r0
  84:	00050500 	andeq	r0, r5, r0, lsl #10
  88:	80940205 	addshi	r0, r4, r5, lsl #4
  8c:	0a030000 	beq	c0094 <_bss_end+0xb6de8>
  90:	83110501 	tsthi	r1, #4194304	; 0x400000
  94:	054a1005 	strbeq	r1, [sl, #-5]
  98:	05858305 	streq	r8, [r5, #773]	; 0x305
  9c:	05058313 	streq	r8, [r5, #-787]	; 0xfffffced
  a0:	05838567 	streq	r8, [r3, #1383]	; 0x567
  a4:	854c8601 	strbhi	r8, [ip, #-1537]	; 0xfffff9ff
  a8:	854c854c 	strbhi	r8, [ip, #-1356]	; 0xfffffab4
  ac:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
  b0:	024b0104 	subeq	r0, fp, #4, 2
  b4:	01010002 	tsteq	r1, r2
  b8:	0000043d 	andeq	r0, r0, sp, lsr r4
  bc:	015a0003 	cmpeq	sl, r3
  c0:	01020000 	mrseq	r0, (UNDEF: 2)
  c4:	000d0efb 	strdeq	r0, [sp], -fp
  c8:	01010101 	tsteq	r1, r1, lsl #2
  cc:	01000000 	mrseq	r0, (UNDEF: 0)
  d0:	2f010000 	svccs	0x00010000
  d4:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
  d8:	6c69732f 	stclvs	3, cr7, [r9], #-188	; 0xffffff44
  dc:	79766168 	ldmdbvc	r6!, {r3, r5, r6, r8, sp, lr}^
  e0:	63532f6a 	cmpvs	r3, #424	; 0x1a8
  e4:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; ffffff4c <_bss_end+0xffff6ca0>
  e8:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
  ec:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
  f0:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
  f4:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
  f8:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
  fc:	69742d30 	ldmdbvs	r4!, {r4, r5, r8, sl, fp, sp}^
 100:	5f72656d 	svcpl	0x0072656d
 104:	5f646e61 	svcpl	0x00646e61
 108:	4f495047 	svcmi	0x00495047
 10c:	746e695f 	strbtvc	r6, [lr], #-2399	; 0xfffff6a1
 110:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
 114:	6b2f7470 	blvs	bdd2dc <_bss_end+0xbd4030>
 118:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 11c:	72732f6c 	rsbsvc	r2, r3, #108, 30	; 0x1b0
 120:	72642f63 	rsbvc	r2, r4, #396	; 0x18c
 124:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
 128:	682f0073 	stmdavs	pc!, {r0, r1, r4, r5, r6}	; <UNPREDICTABLE>
 12c:	2f656d6f 	svccs	0x00656d6f
 130:	686c6973 	stmdavs	ip!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
 134:	6a797661 	bvs	1e5dac0 <_bss_end+0x1e54814>
 138:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
 13c:	2f6c6f6f 	svccs	0x006c6f6f
 140:	6f72655a 	svcvs	0x0072655a
 144:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
 148:	6178652f 	cmnvs	r8, pc, lsr #10
 14c:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
 150:	30312f73 	eorscc	r2, r1, r3, ror pc
 154:	6d69742d 	cfstrdvs	mvd7, [r9, #-180]!	; 0xffffff4c
 158:	615f7265 	cmpvs	pc, r5, ror #4
 15c:	475f646e 	ldrbmi	r6, [pc, -lr, ror #8]
 160:	5f4f4950 	svcpl	0x004f4950
 164:	65746e69 	ldrbvs	r6, [r4, #-3689]!	; 0xfffff197
 168:	70757272 	rsbsvc	r7, r5, r2, ror r2
 16c:	656b2f74 	strbvs	r2, [fp, #-3956]!	; 0xfffff08c
 170:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
 174:	636e692f 	cmnvs	lr, #770048	; 0xbc000
 178:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
 17c:	616f622f 	cmnvs	pc, pc, lsr #4
 180:	722f6472 	eorvc	r6, pc, #1912602624	; 0x72000000
 184:	2f306970 	svccs	0x00306970
 188:	006c6168 	rsbeq	r6, ip, r8, ror #2
 18c:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; d8 <CPSR_IRQ_INHIBIT+0x58>
 190:	69732f65 	ldmdbvs	r3!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 194:	7661686c 	strbtvc	r6, [r1], -ip, ror #16
 198:	532f6a79 			; <UNDEFINED> instruction: 0x532f6a79
 19c:	6f6f6863 	svcvs	0x006f6863
 1a0:	655a2f6c 	ldrbvs	r2, [sl, #-3948]	; 0xfffff094
 1a4:	614d6f72 	hvcvs	55026	; 0xd6f2
 1a8:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffc3c <_bss_end+0xffff6990>
 1ac:	706d6178 	rsbvc	r6, sp, r8, ror r1
 1b0:	2f73656c 	svccs	0x0073656c
 1b4:	742d3031 	strtvc	r3, [sp], #-49	; 0xffffffcf
 1b8:	72656d69 	rsbvc	r6, r5, #6720	; 0x1a40
 1bc:	646e615f 	strbtvs	r6, [lr], #-351	; 0xfffffea1
 1c0:	4950475f 	ldmdbmi	r0, {r0, r1, r2, r3, r4, r6, r8, r9, sl, lr}^
 1c4:	6e695f4f 	cdpvs	15, 6, cr5, cr9, cr15, {2}
 1c8:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
 1cc:	2f747075 	svccs	0x00747075
 1d0:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 1d4:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 1d8:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 1dc:	642f6564 	strtvs	r6, [pc], #-1380	; 1e4 <CPSR_IRQ_INHIBIT+0x164>
 1e0:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
 1e4:	00007372 	andeq	r7, r0, r2, ror r3
 1e8:	6f697067 	svcvs	0x00697067
 1ec:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
 1f0:	00000100 	andeq	r0, r0, r0, lsl #2
 1f4:	64746e69 	ldrbtvs	r6, [r4], #-3689	; 0xfffff197
 1f8:	682e6665 	stmdavs	lr!, {r0, r2, r5, r6, r9, sl, sp, lr}
 1fc:	00000200 	andeq	r0, r0, r0, lsl #4
 200:	69726570 	ldmdbvs	r2!, {r4, r5, r6, r8, sl, sp, lr}^
 204:	72656870 	rsbvc	r6, r5, #112, 16	; 0x700000
 208:	2e736c61 	cdpcs	12, 7, cr6, cr3, cr1, {3}
 20c:	00020068 	andeq	r0, r2, r8, rrx
 210:	69706700 	ldmdbvs	r0!, {r8, r9, sl, sp, lr}^
 214:	00682e6f 	rsbeq	r2, r8, pc, ror #28
 218:	00000003 	andeq	r0, r0, r3
 21c:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
 220:	00816c02 	addeq	r6, r1, r2, lsl #24
 224:	38051700 	stmdacc	r5, {r8, r9, sl, ip}
 228:	6901059f 	stmdbvs	r1, {r0, r1, r2, r3, r4, r7, r8, sl}
 22c:	d70505a1 	strle	r0, [r5, -r1, lsr #11]
 230:	05671005 	strbeq	r1, [r7, #-5]!
 234:	93084c11 	movwls	r4, #35857	; 0x8c11
 238:	05670d05 	strbeq	r0, [r7, #-3333]!	; 0xfffff2fb
 23c:	0d053011 	stceq	0, cr3, [r5, #-68]	; 0xffffffbc
 240:	30110567 	andscc	r0, r1, r7, ror #10
 244:	05670d05 	strbeq	r0, [r7, #-3333]!	; 0xfffff2fb
 248:	0d053011 	stceq	0, cr3, [r5, #-68]	; 0xffffffbc
 24c:	30110567 	andscc	r0, r1, r7, ror #10
 250:	05670d05 	strbeq	r0, [r7, #-3333]!	; 0xfffff2fb
 254:	0d053011 	stceq	0, cr3, [r5, #-68]	; 0xffffffbc
 258:	31140567 	tstcc	r4, r7, ror #10
 25c:	20081a05 	andcs	r1, r8, r5, lsl #20
 260:	05660d05 	strbeq	r0, [r6, #-3333]!	; 0xfffff2fb
 264:	01054c0c 	tsteq	r5, ip, lsl #24
 268:	0505a12f 	streq	sl, [r5, #-303]	; 0xfffffed1
 26c:	671005d7 			; <UNDEFINED> instruction: 0x671005d7
 270:	004c0b05 	subeq	r0, ip, r5, lsl #22
 274:	06010402 	streq	r0, [r1], -r2, lsl #8
 278:	04020066 	streq	r0, [r2], #-102	; 0xffffff9a
 27c:	09054a02 	stmdbeq	r5, {r1, r9, fp, lr}
 280:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
 284:	13052e06 	movwne	r2, #24070	; 0x5e06
 288:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
 28c:	000d054b 	andeq	r0, sp, fp, asr #10
 290:	4a040402 	bmi	1012a0 <_bss_end+0xf7ff4>
 294:	02000c05 	andeq	r0, r0, #1280	; 0x500
 298:	054c0404 	strbeq	r0, [ip, #-1028]	; 0xfffffbfc
 29c:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 2a0:	1005d705 	andne	sp, r5, r5, lsl #14
 2a4:	4c0b0567 	cfstr32mi	mvfx0, [fp], {103}	; 0x67
 2a8:	01040200 	mrseq	r0, R12_usr
 2ac:	02006606 	andeq	r6, r0, #6291456	; 0x600000
 2b0:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 2b4:	04020009 	streq	r0, [r2], #-9
 2b8:	052e0604 	streq	r0, [lr, #-1540]!	; 0xfffff9fc
 2bc:	04020013 	streq	r0, [r2], #-19	; 0xffffffed
 2c0:	0d054b04 	vstreq	d4, [r5, #-16]
 2c4:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
 2c8:	000c054a 	andeq	r0, ip, sl, asr #10
 2cc:	4c040402 	cfstrsmi	mvf0, [r4], {2}
 2d0:	852f0105 	strhi	r0, [pc, #-261]!	; 1d3 <CPSR_IRQ_INHIBIT+0x153>
 2d4:	05d70505 	ldrbeq	r0, [r7, #1285]	; 0x505
 2d8:	0b056710 	bleq	159f20 <_bss_end+0x150c74>
 2dc:	0402004c 	streq	r0, [r2], #-76	; 0xffffffb4
 2e0:	00660601 	rsbeq	r0, r6, r1, lsl #12
 2e4:	4a020402 	bmi	812f4 <_bss_end+0x78048>
 2e8:	02000905 	andeq	r0, r0, #81920	; 0x14000
 2ec:	2e060404 	cdpcs	4, 0, cr0, cr6, cr4, {0}
 2f0:	02001305 	andeq	r1, r0, #335544320	; 0x14000000
 2f4:	054b0404 	strbeq	r0, [fp, #-1028]	; 0xfffffbfc
 2f8:	0402000d 	streq	r0, [r2], #-13
 2fc:	0c054a04 			; <UNDEFINED> instruction: 0x0c054a04
 300:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
 304:	2f01054c 	svccs	0x0001054c
 308:	d81d0585 	ldmdale	sp, {r0, r2, r7, r8, sl}
 30c:	05ba0905 	ldreq	r0, [sl, #2309]!	; 0x905
 310:	13054a05 	movwne	r4, #23045	; 0x5a05
 314:	4a1c054d 	bmi	701850 <_bss_end+0x6f85a4>
 318:	05823e05 	streq	r3, [r2, #3589]	; 0xe05
 31c:	1e056621 	cfmadd32ne	mvax1, mvfx6, mvfx5, mvfx1
 320:	2e4b052e 	cdpcs	5, 4, cr0, cr11, cr14, {1}
 324:	052e6b05 	streq	r6, [lr, #-2821]!	; 0xfffff4fb
 328:	0e054a05 	vmlaeq.f32	s8, s10, s10
 32c:	6648054a 	strbvs	r0, [r8], -sl, asr #10
 330:	052e1005 	streq	r1, [lr, #-5]!
 334:	01054809 	tsteq	r5, r9, lsl #16
 338:	1d054d31 	stcne	13, cr4, [r5, #-196]	; 0xffffff3c
 33c:	ba0905a0 	blt	2419c4 <_bss_end+0x238718>
 340:	054a0505 	strbeq	r0, [sl, #-1285]	; 0xfffffafb
 344:	29054b20 	stmdbcs	r5, {r5, r8, r9, fp, lr}
 348:	4a32054c 	bmi	c81880 <_bss_end+0xc785d4>
 34c:	05823405 	streq	r3, [r2, #1029]	; 0x405
 350:	3f054a0c 	svccc	0x00054a0c
 354:	0001052e 	andeq	r0, r1, lr, lsr #10
 358:	4b010402 	blmi	41368 <_bss_end+0x380bc>
 35c:	bc240569 	cfstr32lt	mvfx0, [r4], #-420	; 0xfffffe5c
 360:	20080905 	andcs	r0, r8, r5, lsl #18
 364:	054a0505 	strbeq	r0, [sl, #-1285]	; 0xfffffafb
 368:	05054d15 	streq	r4, [r5, #-3349]	; 0xfffff2eb
 36c:	4a0e0566 	bmi	38190c <_bss_end+0x378660>
 370:	05661505 	strbeq	r1, [r6, #-1285]!	; 0xfffffafb
 374:	09052e10 	stmdbeq	r5, {r4, r9, sl, fp, sp}
 378:	03010548 	movweq	r0, #5448	; 0x1548
 37c:	054d2e09 	strbeq	r2, [sp, #-3593]	; 0xfffff1f7
 380:	1005d705 	andne	sp, r5, r5, lsl #14
 384:	4c130567 	cfldr32mi	mvfx0, [r3], {103}	; 0x67
 388:	054a0d05 	strbeq	r0, [sl, #-3333]	; 0xfffff2fb
 38c:	00410813 	subeq	r0, r1, r3, lsl r8
 390:	06010402 	streq	r0, [r1], -r2, lsl #8
 394:	04020066 	streq	r0, [r2], #-102	; 0xffffff9a
 398:	11054a02 	tstne	r5, r2, lsl #20
 39c:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
 3a0:	0d052e06 	stceq	14, cr2, [r5, #-24]	; 0xffffffe8
 3a4:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
 3a8:	3013054b 	andscc	r0, r3, fp, asr #10
 3ac:	01040200 	mrseq	r0, R12_usr
 3b0:	02006606 	andeq	r6, r0, #6291456	; 0x600000
 3b4:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 3b8:	04020011 	streq	r0, [r2], #-17	; 0xffffffef
 3bc:	052e0604 	streq	r0, [lr, #-1540]!	; 0xfffff9fc
 3c0:	0402000d 	streq	r0, [r2], #-13
 3c4:	13054b04 	movwne	r4, #23300	; 0x5b04
 3c8:	04020030 	streq	r0, [r2], #-48	; 0xffffffd0
 3cc:	00660601 	rsbeq	r0, r6, r1, lsl #12
 3d0:	4a020402 	bmi	813e0 <_bss_end+0x78134>
 3d4:	02001105 	andeq	r1, r0, #1073741825	; 0x40000001
 3d8:	2e060404 	cdpcs	4, 0, cr0, cr6, cr4, {0}
 3dc:	02000d05 	andeq	r0, r0, #320	; 0x140
 3e0:	054b0404 	strbeq	r0, [fp, #-1028]	; 0xfffffbfc
 3e4:	02003013 	andeq	r3, r0, #19
 3e8:	66060104 	strvs	r0, [r6], -r4, lsl #2
 3ec:	02040200 	andeq	r0, r4, #0, 4
 3f0:	0011054a 	andseq	r0, r1, sl, asr #10
 3f4:	06040402 	streq	r0, [r4], -r2, lsl #8
 3f8:	000d052e 	andeq	r0, sp, lr, lsr #10
 3fc:	4b040402 	blmi	10140c <_bss_end+0xf8160>
 400:	05301405 	ldreq	r1, [r0, #-1029]!	; 0xfffffbfb
 404:	01054d0c 	tsteq	r5, ip, lsl #26
 408:	2405852f 	strcs	r8, [r5], #-1327	; 0xfffffad1
 40c:	080905bc 	stmdaeq	r9, {r2, r3, r4, r5, r7, r8, sl}
 410:	4a050520 	bmi	141898 <_bss_end+0x1385ec>
 414:	054d1405 	strbeq	r1, [sp, #-1029]	; 0xfffffbfb
 418:	0e054a1d 			; <UNDEFINED> instruction: 0x0e054a1d
 41c:	4b100566 	blmi	4019bc <_bss_end+0x3f8710>
 420:	05660c05 	strbeq	r0, [r6, #-3077]!	; 0xfffff3fb
 424:	05054a09 	streq	r4, [r5, #-2569]	; 0xfffff5f7
 428:	4a0e0567 	bmi	3819cc <_bss_end+0x378720>
 42c:	05661005 	strbeq	r1, [r6, #-5]!
 430:	01056209 	tsteq	r5, r9, lsl #4
 434:	0b054d33 	bleq	153908 <_bss_end+0x14a65c>
 438:	663505d8 			; <UNDEFINED> instruction: 0x663505d8
 43c:	02002405 	andeq	r2, r0, #83886080	; 0x5000000
 440:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 444:	04020009 	streq	r0, [r2], #-9
 448:	3505f202 	strcc	pc, [r5, #-514]	; 0xfffffdfe
 44c:	03040200 	movweq	r0, #16896	; 0x4200
 450:	0054054a 	subseq	r0, r4, sl, asr #10
 454:	66060402 	strvs	r0, [r6], -r2, lsl #8
 458:	02003805 	andeq	r3, r0, #327680	; 0x50000
 45c:	05f20604 	ldrbeq	r0, [r2, #1540]!	; 0x604
 460:	04020035 	streq	r0, [r2], #-53	; 0xffffffcb
 464:	02004a07 	andeq	r4, r0, #28672	; 0x7000
 468:	4a060804 	bmi	182480 <_bss_end+0x1791d4>
 46c:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
 470:	2e060a04 	vmlacs.f32	s0, s12, s8
 474:	054d1505 	strbeq	r1, [sp, #-1285]	; 0xfffffafb
 478:	0e056605 	cfmadd32eq	mvax0, mvfx6, mvfx5, mvfx5
 47c:	6615054a 	ldrvs	r0, [r5], -sl, asr #10
 480:	052e1005 	streq	r1, [lr, #-5]!
 484:	01054809 	tsteq	r5, r9, lsl #16
 488:	05054d31 	streq	r4, [r5, #-3377]	; 0xfffff2cf
 48c:	671005d7 			; <UNDEFINED> instruction: 0x671005d7
 490:	004c0b05 	subeq	r0, ip, r5, lsl #22
 494:	06010402 	streq	r0, [r1], -r2, lsl #8
 498:	04020066 	streq	r0, [r2], #-102	; 0xffffff9a
 49c:	09054a02 	stmdbeq	r5, {r1, r9, fp, lr}
 4a0:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
 4a4:	13052e06 	movwne	r2, #24070	; 0x5e06
 4a8:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
 4ac:	000d054b 	andeq	r0, sp, fp, asr #10
 4b0:	4a040402 	bmi	1014c0 <_bss_end+0xf8214>
 4b4:	02000c05 	andeq	r0, r0, #1280	; 0x500
 4b8:	054c0404 	strbeq	r0, [ip, #-1028]	; 0xfffffbfc
 4bc:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 4c0:	0905a01c 	stmdbeq	r5, {r2, r3, r4, sp, pc}
 4c4:	4a0505ba 	bmi	141bb4 <_bss_end+0x138908>
 4c8:	054e1405 	strbeq	r1, [lr, #-1029]	; 0xfffffbfb
 4cc:	0e056605 	cfmadd32eq	mvax0, mvfx6, mvfx5, mvfx5
 4d0:	6614054a 	ldrvs	r0, [r4], -sl, asr #10
 4d4:	052e1005 	streq	r1, [lr, #-5]!
 4d8:	01054709 	tsteq	r5, r9, lsl #14
 4dc:	009e4a32 	addseq	r4, lr, r2, lsr sl
 4e0:	06010402 	streq	r0, [r1], -r2, lsl #8
 4e4:	06230566 	strteq	r0, [r3], -r6, ror #10
 4e8:	827ed303 	rsbshi	sp, lr, #201326592	; 0xc000000
 4ec:	ad030105 	stfges	f0, [r3, #-20]	; 0xffffffec
 4f0:	4aba6601 	bmi	fee99cfc <_bss_end+0xfee90a50>
 4f4:	01000a02 	tsteq	r0, r2, lsl #20
 4f8:	0001fc01 	andeq	pc, r1, r1, lsl #24
 4fc:	5c000300 	stcpl	3, cr0, [r0], {-0}
 500:	02000001 	andeq	r0, r0, #1
 504:	0d0efb01 	vstreq	d15, [lr, #-4]
 508:	01010100 	mrseq	r0, (UNDEF: 17)
 50c:	00000001 	andeq	r0, r0, r1
 510:	01000001 	tsteq	r0, r1
 514:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 460 <CPSR_IRQ_INHIBIT+0x3e0>
 518:	69732f65 	ldmdbvs	r3!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 51c:	7661686c 	strbtvc	r6, [r1], -ip, ror #16
 520:	532f6a79 			; <UNDEFINED> instruction: 0x532f6a79
 524:	6f6f6863 	svcvs	0x006f6863
 528:	655a2f6c 	ldrbvs	r2, [sl, #-3948]	; 0xfffff094
 52c:	614d6f72 	hvcvs	55026	; 0xd6f2
 530:	652f6574 	strvs	r6, [pc, #-1396]!	; ffffffc4 <_bss_end+0xffff6d18>
 534:	706d6178 	rsbvc	r6, sp, r8, ror r1
 538:	2f73656c 	svccs	0x0073656c
 53c:	742d3031 	strtvc	r3, [sp], #-49	; 0xffffffcf
 540:	72656d69 	rsbvc	r6, r5, #6720	; 0x1a40
 544:	646e615f 	strbtvs	r6, [lr], #-351	; 0xfffffea1
 548:	4950475f 	ldmdbmi	r0, {r0, r1, r2, r3, r4, r6, r8, r9, sl, lr}^
 54c:	6e695f4f 	cdpvs	15, 6, cr5, cr9, cr15, {2}
 550:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
 554:	2f747075 	svccs	0x00747075
 558:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 55c:	732f6c65 			; <UNDEFINED> instruction: 0x732f6c65
 560:	642f6372 	strtvs	r6, [pc], #-882	; 568 <CPSR_IRQ_INHIBIT+0x4e8>
 564:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
 568:	2f007372 	svccs	0x00007372
 56c:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
 570:	6c69732f 	stclvs	3, cr7, [r9], #-188	; 0xffffff44
 574:	79766168 	ldmdbvc	r6!, {r3, r5, r6, r8, sp, lr}^
 578:	63532f6a 	cmpvs	r3, #424	; 0x1a8
 57c:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; 3e4 <CPSR_IRQ_INHIBIT+0x364>
 580:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
 584:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
 588:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 58c:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
 590:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
 594:	69742d30 	ldmdbvs	r4!, {r4, r5, r8, sl, fp, sp}^
 598:	5f72656d 	svcpl	0x0072656d
 59c:	5f646e61 	svcpl	0x00646e61
 5a0:	4f495047 	svcmi	0x00495047
 5a4:	746e695f 	strbtvc	r6, [lr], #-2399	; 0xfffff6a1
 5a8:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
 5ac:	6b2f7470 	blvs	bdd774 <_bss_end+0xbd44c8>
 5b0:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 5b4:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
 5b8:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 5bc:	6f622f65 	svcvs	0x00622f65
 5c0:	2f647261 	svccs	0x00647261
 5c4:	30697072 	rsbcc	r7, r9, r2, ror r0
 5c8:	6c61682f 	stclvs	8, cr6, [r1], #-188	; 0xffffff44
 5cc:	6f682f00 	svcvs	0x00682f00
 5d0:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
 5d4:	61686c69 	cmnvs	r8, r9, ror #24
 5d8:	2f6a7976 	svccs	0x006a7976
 5dc:	6f686353 	svcvs	0x00686353
 5e0:	5a2f6c6f 	bpl	bdb7a4 <_bss_end+0xbd24f8>
 5e4:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 458 <CPSR_IRQ_INHIBIT+0x3d8>
 5e8:	2f657461 	svccs	0x00657461
 5ec:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
 5f0:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
 5f4:	2d30312f 	ldfcss	f3, [r0, #-188]!	; 0xffffff44
 5f8:	656d6974 	strbvs	r6, [sp, #-2420]!	; 0xfffff68c
 5fc:	6e615f72 	mcrvs	15, 3, r5, cr1, cr2, {3}
 600:	50475f64 	subpl	r5, r7, r4, ror #30
 604:	695f4f49 	ldmdbvs	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
 608:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
 60c:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
 610:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 614:	2f6c656e 	svccs	0x006c656e
 618:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 61c:	2f656475 	svccs	0x00656475
 620:	76697264 	strbtvc	r7, [r9], -r4, ror #4
 624:	00737265 	rsbseq	r7, r3, r5, ror #4
 628:	6d697400 	cfstrdvs	mvd7, [r9, #-0]
 62c:	632e7265 			; <UNDEFINED> instruction: 0x632e7265
 630:	01007070 	tsteq	r0, r0, ror r0
 634:	6e690000 	cdpvs	0, 6, cr0, cr9, cr0, {0}
 638:	66656474 			; <UNDEFINED> instruction: 0x66656474
 63c:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 640:	65700000 	ldrbvs	r0, [r0, #-0]!
 644:	68706972 	ldmdavs	r0!, {r1, r4, r5, r6, r8, fp, sp, lr}^
 648:	6c617265 	sfmvs	f7, 2, [r1], #-404	; 0xfffffe6c
 64c:	00682e73 	rsbeq	r2, r8, r3, ror lr
 650:	74000002 	strvc	r0, [r0], #-2
 654:	72656d69 	rsbvc	r6, r5, #6720	; 0x1a40
 658:	0300682e 	movweq	r6, #2094	; 0x82e
 65c:	05000000 	streq	r0, [r0, #-0]
 660:	02050001 	andeq	r0, r5, #1
 664:	000089a8 	andeq	r8, r0, r8, lsr #19
 668:	05011903 	streq	r1, [r1, #-2307]	; 0xfffff6fd
 66c:	14059f0f 	strne	r9, [r5], #-3855	; 0xfffff0f1
 670:	a101052f 	tstge	r1, pc, lsr #10
 674:	9f0c05a1 	svcls	0x000c05a1
 678:	054a1805 	strbeq	r1, [sl, #-2053]	; 0xfffff7fb
 67c:	01052e36 	tsteq	r5, r6, lsr lr
 680:	1e05854b 	cfsh32ne	mvfx8, mvfx5, #43
 684:	822005d7 	eorhi	r0, r0, #901775360	; 0x35c00000
 688:	054d1505 	strbeq	r1, [sp, #-1285]	; 0xfffffafb
 68c:	1705671b 	smladne	r5, fp, r7, r6
 690:	67150567 	ldrvs	r0, [r5, -r7, ror #10]
 694:	05661305 	strbeq	r1, [r6, #-773]!	; 0xfffffcfb
 698:	2105d846 	tstcs	r5, r6, asr #16
 69c:	8225052e 	eorhi	r0, r5, #192937984	; 0xb800000
 6a0:	302e2305 	eorcc	r2, lr, r5, lsl #6
 6a4:	05822505 	streq	r2, [r2, #1285]	; 0x505
 6a8:	01054c0f 	tsteq	r5, pc, lsl #24
 6ac:	6f056967 	svcvs	0x00056967
 6b0:	841b0583 	ldrhi	r0, [fp], #-1411	; 0xfffffa7d
 6b4:	05831705 	streq	r1, [r3, #1797]	; 0x705
 6b8:	05698301 	strbeq	r8, [r9, #-769]!	; 0xfffffcff
 6bc:	25058323 	strcs	r8, [r5, #-803]	; 0xfffffcdd
 6c0:	4c090582 	cfstr32mi	mvfx0, [r9], {130}	; 0x82
 6c4:	054a0505 	strbeq	r0, [sl, #-1285]	; 0xfffffafb
 6c8:	12054b09 	andne	r4, r5, #9216	; 0x2400
 6cc:	2f01054a 	svccs	0x0001054a
 6d0:	832b0569 			; <UNDEFINED> instruction: 0x832b0569
 6d4:	05821005 	streq	r1, [r2, #5]
 6d8:	01052e2b 	tsteq	r5, fp, lsr #28
 6dc:	009e6683 	addseq	r6, lr, r3, lsl #13
 6e0:	06010402 	streq	r0, [r1], -r2, lsl #8
 6e4:	061e0566 	ldreq	r0, [lr], -r6, ror #10
 6e8:	827fba03 	rsbshi	fp, pc, #12288	; 0x3000
 6ec:	c6030105 	strgt	r0, [r3], -r5, lsl #2
 6f0:	4aba6600 	bmi	fee99ef8 <_bss_end+0xfee90c4c>
 6f4:	01000a02 	tsteq	r0, r2, lsl #20
 6f8:	0002c801 	andeq	ip, r2, r1, lsl #16
 6fc:	da000300 	ble	1304 <CPSR_IRQ_INHIBIT+0x1284>
 700:	02000001 	andeq	r0, r0, #1
 704:	0d0efb01 	vstreq	d15, [lr, #-4]
 708:	01010100 	mrseq	r0, (UNDEF: 17)
 70c:	00000001 	andeq	r0, r0, r1
 710:	01000001 	tsteq	r0, r1
 714:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 660 <CPSR_IRQ_INHIBIT+0x5e0>
 718:	69732f65 	ldmdbvs	r3!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 71c:	7661686c 	strbtvc	r6, [r1], -ip, ror #16
 720:	532f6a79 			; <UNDEFINED> instruction: 0x532f6a79
 724:	6f6f6863 	svcvs	0x006f6863
 728:	655a2f6c 	ldrbvs	r2, [sl, #-3948]	; 0xfffff094
 72c:	614d6f72 	hvcvs	55026	; 0xd6f2
 730:	652f6574 	strvs	r6, [pc, #-1396]!	; 1c4 <CPSR_IRQ_INHIBIT+0x144>
 734:	706d6178 	rsbvc	r6, sp, r8, ror r1
 738:	2f73656c 	svccs	0x0073656c
 73c:	742d3031 	strtvc	r3, [sp], #-49	; 0xffffffcf
 740:	72656d69 	rsbvc	r6, r5, #6720	; 0x1a40
 744:	646e615f 	strbtvs	r6, [lr], #-351	; 0xfffffea1
 748:	4950475f 	ldmdbmi	r0, {r0, r1, r2, r3, r4, r6, r8, r9, sl, lr}^
 74c:	6e695f4f 	cdpvs	15, 6, cr5, cr9, cr15, {2}
 750:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
 754:	2f747075 	svccs	0x00747075
 758:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 75c:	732f6c65 			; <UNDEFINED> instruction: 0x732f6c65
 760:	2f006372 	svccs	0x00006372
 764:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
 768:	6c69732f 	stclvs	3, cr7, [r9], #-188	; 0xffffff44
 76c:	79766168 	ldmdbvc	r6!, {r3, r5, r6, r8, sp, lr}^
 770:	63532f6a 	cmpvs	r3, #424	; 0x1a8
 774:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; 5dc <CPSR_IRQ_INHIBIT+0x55c>
 778:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
 77c:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
 780:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 784:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
 788:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
 78c:	69742d30 	ldmdbvs	r4!, {r4, r5, r8, sl, fp, sp}^
 790:	5f72656d 	svcpl	0x0072656d
 794:	5f646e61 	svcpl	0x00646e61
 798:	4f495047 	svcmi	0x00495047
 79c:	746e695f 	strbtvc	r6, [lr], #-2399	; 0xfffff6a1
 7a0:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
 7a4:	6b2f7470 	blvs	bdd96c <_bss_end+0xbd46c0>
 7a8:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 7ac:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
 7b0:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 7b4:	6f622f65 	svcvs	0x00622f65
 7b8:	2f647261 	svccs	0x00647261
 7bc:	30697072 	rsbcc	r7, r9, r2, ror r0
 7c0:	6c61682f 	stclvs	8, cr6, [r1], #-188	; 0xffffff44
 7c4:	6f682f00 	svcvs	0x00682f00
 7c8:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
 7cc:	61686c69 	cmnvs	r8, r9, ror #24
 7d0:	2f6a7976 	svccs	0x006a7976
 7d4:	6f686353 	svcvs	0x00686353
 7d8:	5a2f6c6f 	bpl	bdb99c <_bss_end+0xbd26f0>
 7dc:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 650 <CPSR_IRQ_INHIBIT+0x5d0>
 7e0:	2f657461 	svccs	0x00657461
 7e4:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
 7e8:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
 7ec:	2d30312f 	ldfcss	f3, [r0, #-188]!	; 0xffffff44
 7f0:	656d6974 	strbvs	r6, [sp, #-2420]!	; 0xfffff68c
 7f4:	6e615f72 	mcrvs	15, 3, r5, cr1, cr2, {3}
 7f8:	50475f64 	subpl	r5, r7, r4, ror #30
 7fc:	695f4f49 	ldmdbvs	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
 800:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
 804:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
 808:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 80c:	2f6c656e 	svccs	0x006c656e
 810:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 814:	2f656475 	svccs	0x00656475
 818:	76697264 	strbtvc	r7, [r9], -r4, ror #4
 81c:	00737265 	rsbseq	r7, r3, r5, ror #4
 820:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 76c <CPSR_IRQ_INHIBIT+0x6ec>
 824:	69732f65 	ldmdbvs	r3!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 828:	7661686c 	strbtvc	r6, [r1], -ip, ror #16
 82c:	532f6a79 			; <UNDEFINED> instruction: 0x532f6a79
 830:	6f6f6863 	svcvs	0x006f6863
 834:	655a2f6c 	ldrbvs	r2, [sl, #-3948]	; 0xfffff094
 838:	614d6f72 	hvcvs	55026	; 0xd6f2
 83c:	652f6574 	strvs	r6, [pc, #-1396]!	; 2d0 <CPSR_IRQ_INHIBIT+0x250>
 840:	706d6178 	rsbvc	r6, sp, r8, ror r1
 844:	2f73656c 	svccs	0x0073656c
 848:	742d3031 	strtvc	r3, [sp], #-49	; 0xffffffcf
 84c:	72656d69 	rsbvc	r6, r5, #6720	; 0x1a40
 850:	646e615f 	strbtvs	r6, [lr], #-351	; 0xfffffea1
 854:	4950475f 	ldmdbmi	r0, {r0, r1, r2, r3, r4, r6, r8, r9, sl, lr}^
 858:	6e695f4f 	cdpvs	15, 6, cr5, cr9, cr15, {2}
 85c:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
 860:	2f747075 	svccs	0x00747075
 864:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 868:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 86c:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 870:	00006564 	andeq	r6, r0, r4, ror #10
 874:	65746e69 	ldrbvs	r6, [r4, #-3689]!	; 0xfffff197
 878:	70757272 	rsbsvc	r7, r5, r2, ror r2
 87c:	6f635f74 	svcvs	0x00635f74
 880:	6f72746e 	svcvs	0x0072746e
 884:	72656c6c 	rsbvc	r6, r5, #108, 24	; 0x6c00
 888:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
 88c:	00000100 	andeq	r0, r0, r0, lsl #2
 890:	64746e69 	ldrbtvs	r6, [r4], #-3689	; 0xfffff197
 894:	682e6665 	stmdavs	lr!, {r0, r2, r5, r6, r9, sl, sp, lr}
 898:	00000200 	andeq	r0, r0, r0, lsl #4
 89c:	69726570 	ldmdbvs	r2!, {r4, r5, r6, r8, sl, sp, lr}^
 8a0:	72656870 	rsbvc	r6, r5, #112, 16	; 0x700000
 8a4:	2e736c61 	cdpcs	12, 7, cr6, cr3, cr1, {3}
 8a8:	00020068 	andeq	r0, r2, r8, rrx
 8ac:	69706700 	ldmdbvs	r0!, {r8, r9, sl, sp, lr}^
 8b0:	00682e6f 	rsbeq	r2, r8, pc, ror #28
 8b4:	69000003 	stmdbvs	r0, {r0, r1}
 8b8:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
 8bc:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
 8c0:	6e6f635f 	mcrvs	3, 3, r6, cr15, cr15, {2}
 8c4:	6c6f7274 	sfmvs	f7, 2, [pc], #-464	; 6fc <CPSR_IRQ_INHIBIT+0x67c>
 8c8:	2e72656c 	cdpcs	5, 7, cr6, cr2, cr12, {3}
 8cc:	00040068 	andeq	r0, r4, r8, rrx
 8d0:	6d697400 	cfstrdvs	mvd7, [r9, #-0]
 8d4:	682e7265 	stmdavs	lr!, {r0, r2, r5, r6, r9, ip, sp, lr}
 8d8:	00000300 	andeq	r0, r0, r0, lsl #6
 8dc:	00010500 	andeq	r0, r1, r0, lsl #10
 8e0:	8c380205 	lfmhi	f0, 4, [r8], #-20	; 0xffffffec
 8e4:	4b190000 	blmi	6408ec <_bss_end+0x637640>
 8e8:	69240585 	stmdbvs	r4!, {r0, r2, r7, r8, sl}
 8ec:	05660505 	strbeq	r0, [r6, #-1285]!	; 0xfffffafb
 8f0:	01054b1c 	tsteq	r5, ip, lsl fp
 8f4:	2a190551 	bcs	641e40 <_bss_end+0x638b94>
 8f8:	05bb2305 	ldreq	r2, [fp, #773]!	; 0x305
 8fc:	16056718 			; <UNDEFINED> instruction: 0x16056718
 900:	4c010582 	cfstr32mi	mvfx0, [r1], {130}	; 0x82
 904:	056a2fbd 	strbeq	r2, [sl, #-4029]!	; 0xfffff043
 908:	38059f13 	stmdacc	r5, {r0, r1, r4, r8, r9, sl, fp, ip, pc}
 90c:	4c01052e 	cfstr32mi	mvfx0, [r1], {46}	; 0x2e
 910:	9f0c05a1 	svcls	0x000c05a1
 914:	054a1c05 	strbeq	r1, [sl, #-3077]	; 0xfffff3fb
 918:	01052e3a 	tsteq	r5, sl, lsr lr
 91c:	4305854b 	movwmi	r8, #21835	; 0x554b
 920:	2e40059f 	mcrcs	5, 2, r0, cr0, cr15, {4}
 924:	054a3905 	strbeq	r3, [sl, #-2309]	; 0xfffff6fb
 928:	3b058240 	blcc	161230 <_bss_end+0x157f84>
 92c:	2f01052e 	svccs	0x0001052e
 930:	9f440569 	svcls	0x00440569
 934:	052e4105 	streq	r4, [lr, #-261]!	; 0xfffffefb
 938:	41054a3a 	tstmi	r5, sl, lsr sl
 93c:	2e3c0582 	cfadd32cs	mvfx0, mvfx12, mvfx2
 940:	692f0105 	stmdbvs	pc!, {r0, r2, r8}	; <UNPREDICTABLE>
 944:	059f1805 	ldreq	r1, [pc, #2053]	; 1151 <CPSR_IRQ_INHIBIT+0x10d1>
 948:	054c0187 	strbeq	r0, [ip, #-391]	; 0xfffffe79
 94c:	73054a7a 	movwvc	r4, #23162	; 0x5a7a
 950:	0402004a 	streq	r0, [r2], #-74	; 0xffffffb6
 954:	00660601 	rsbeq	r0, r6, r1, lsl #12
 958:	4a020402 	bmi	81968 <_bss_end+0x786bc>
 95c:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
 960:	007a052e 	rsbseq	r0, sl, lr, lsr #10
 964:	06040402 	streq	r0, [r4], -r2, lsl #8
 968:	00750582 	rsbseq	r0, r5, r2, lsl #11
 96c:	2e040402 	cdpcs	4, 0, cr0, cr4, cr2, {0}
 970:	02000105 	andeq	r0, r0, #1073741825	; 0x40000001
 974:	692f0404 	stmdbvs	pc!, {r2, sl}	; <UNPREDICTABLE>
 978:	059f1805 	ldreq	r1, [pc, #2053]	; 1185 <CPSR_IRQ_INHIBIT+0x1105>
 97c:	054c0189 	strbeq	r0, [ip, #-393]	; 0xfffffe77
 980:	75054a7c 	strvc	r4, [r5, #-2684]	; 0xfffff584
 984:	0402004a 	streq	r0, [r2], #-74	; 0xffffffb6
 988:	00660601 	rsbeq	r0, r6, r1, lsl #12
 98c:	4a020402 	bmi	8199c <_bss_end+0x786f0>
 990:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
 994:	007c052e 	rsbseq	r0, ip, lr, lsr #10
 998:	06040402 	streq	r0, [r4], -r2, lsl #8
 99c:	00770582 	rsbseq	r0, r7, r2, lsl #11
 9a0:	2e040402 	cdpcs	4, 0, cr0, cr4, cr2, {0}
 9a4:	02000105 	andeq	r0, r0, #1073741825	; 0x40000001
 9a8:	662f0404 	strtvs	r0, [pc], -r4, lsl #8
 9ac:	0402009e 	streq	r0, [r2], #-158	; 0xffffff62
 9b0:	05660601 	strbeq	r0, [r6, #-1537]!	; 0xfffff9ff
 9b4:	5e030643 	cfmadd32pl	mvax2, mvfx0, mvfx3, mvfx3
 9b8:	03010582 	movweq	r0, #5506	; 0x1582
 9bc:	4aba6622 	bmi	fee9a24c <_bss_end+0xfee90fa0>
 9c0:	01000a02 	tsteq	r0, r2, lsl #20
 9c4:	00021701 	andeq	r1, r2, r1, lsl #14
 9c8:	ca000300 	bgt	15d0 <CPSR_IRQ_INHIBIT+0x1550>
 9cc:	02000001 	andeq	r0, r0, #1
 9d0:	0d0efb01 	vstreq	d15, [lr, #-4]
 9d4:	01010100 	mrseq	r0, (UNDEF: 17)
 9d8:	00000001 	andeq	r0, r0, r1
 9dc:	01000001 	tsteq	r0, r1
 9e0:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 92c <CPSR_IRQ_INHIBIT+0x8ac>
 9e4:	69732f65 	ldmdbvs	r3!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 9e8:	7661686c 	strbtvc	r6, [r1], -ip, ror #16
 9ec:	532f6a79 			; <UNDEFINED> instruction: 0x532f6a79
 9f0:	6f6f6863 	svcvs	0x006f6863
 9f4:	655a2f6c 	ldrbvs	r2, [sl, #-3948]	; 0xfffff094
 9f8:	614d6f72 	hvcvs	55026	; 0xd6f2
 9fc:	652f6574 	strvs	r6, [pc, #-1396]!	; 490 <CPSR_IRQ_INHIBIT+0x410>
 a00:	706d6178 	rsbvc	r6, sp, r8, ror r1
 a04:	2f73656c 	svccs	0x0073656c
 a08:	742d3031 	strtvc	r3, [sp], #-49	; 0xffffffcf
 a0c:	72656d69 	rsbvc	r6, r5, #6720	; 0x1a40
 a10:	646e615f 	strbtvs	r6, [lr], #-351	; 0xfffffea1
 a14:	4950475f 	ldmdbmi	r0, {r0, r1, r2, r3, r4, r6, r8, r9, sl, lr}^
 a18:	6e695f4f 	cdpvs	15, 6, cr5, cr9, cr15, {2}
 a1c:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
 a20:	2f747075 	svccs	0x00747075
 a24:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 a28:	732f6c65 			; <UNDEFINED> instruction: 0x732f6c65
 a2c:	2f006372 	svccs	0x00006372
 a30:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
 a34:	6c69732f 	stclvs	3, cr7, [r9], #-188	; 0xffffff44
 a38:	79766168 	ldmdbvc	r6!, {r3, r5, r6, r8, sp, lr}^
 a3c:	63532f6a 	cmpvs	r3, #424	; 0x1a8
 a40:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; 8a8 <CPSR_IRQ_INHIBIT+0x828>
 a44:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
 a48:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
 a4c:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 a50:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
 a54:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
 a58:	69742d30 	ldmdbvs	r4!, {r4, r5, r8, sl, fp, sp}^
 a5c:	5f72656d 	svcpl	0x0072656d
 a60:	5f646e61 	svcpl	0x00646e61
 a64:	4f495047 	svcmi	0x00495047
 a68:	746e695f 	strbtvc	r6, [lr], #-2399	; 0xfffff6a1
 a6c:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
 a70:	6b2f7470 	blvs	bddc38 <_bss_end+0xbd498c>
 a74:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 a78:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
 a7c:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 a80:	6f622f65 	svcvs	0x00622f65
 a84:	2f647261 	svccs	0x00647261
 a88:	30697072 	rsbcc	r7, r9, r2, ror r0
 a8c:	6c61682f 	stclvs	8, cr6, [r1], #-188	; 0xffffff44
 a90:	6f682f00 	svcvs	0x00682f00
 a94:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
 a98:	61686c69 	cmnvs	r8, r9, ror #24
 a9c:	2f6a7976 	svccs	0x006a7976
 aa0:	6f686353 	svcvs	0x00686353
 aa4:	5a2f6c6f 	bpl	bdbc68 <_bss_end+0xbd29bc>
 aa8:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 91c <CPSR_IRQ_INHIBIT+0x89c>
 aac:	2f657461 	svccs	0x00657461
 ab0:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
 ab4:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
 ab8:	2d30312f 	ldfcss	f3, [r0, #-188]!	; 0xffffff44
 abc:	656d6974 	strbvs	r6, [sp, #-2420]!	; 0xfffff68c
 ac0:	6e615f72 	mcrvs	15, 3, r5, cr1, cr2, {3}
 ac4:	50475f64 	subpl	r5, r7, r4, ror #30
 ac8:	695f4f49 	ldmdbvs	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
 acc:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
 ad0:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
 ad4:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 ad8:	2f6c656e 	svccs	0x006c656e
 adc:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 ae0:	2f656475 	svccs	0x00656475
 ae4:	76697264 	strbtvc	r7, [r9], -r4, ror #4
 ae8:	00737265 	rsbseq	r7, r3, r5, ror #4
 aec:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; a38 <CPSR_IRQ_INHIBIT+0x9b8>
 af0:	69732f65 	ldmdbvs	r3!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 af4:	7661686c 	strbtvc	r6, [r1], -ip, ror #16
 af8:	532f6a79 			; <UNDEFINED> instruction: 0x532f6a79
 afc:	6f6f6863 	svcvs	0x006f6863
 b00:	655a2f6c 	ldrbvs	r2, [sl, #-3948]	; 0xfffff094
 b04:	614d6f72 	hvcvs	55026	; 0xd6f2
 b08:	652f6574 	strvs	r6, [pc, #-1396]!	; 59c <CPSR_IRQ_INHIBIT+0x51c>
 b0c:	706d6178 	rsbvc	r6, sp, r8, ror r1
 b10:	2f73656c 	svccs	0x0073656c
 b14:	742d3031 	strtvc	r3, [sp], #-49	; 0xffffffcf
 b18:	72656d69 	rsbvc	r6, r5, #6720	; 0x1a40
 b1c:	646e615f 	strbtvs	r6, [lr], #-351	; 0xfffffea1
 b20:	4950475f 	ldmdbmi	r0, {r0, r1, r2, r3, r4, r6, r8, r9, sl, lr}^
 b24:	6e695f4f 	cdpvs	15, 6, cr5, cr9, cr15, {2}
 b28:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
 b2c:	2f747075 	svccs	0x00747075
 b30:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 b34:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 b38:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 b3c:	00006564 	andeq	r6, r0, r4, ror #10
 b40:	6e69616d 	powvsez	f6, f1, #5.0
 b44:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
 b48:	00000100 	andeq	r0, r0, r0, lsl #2
 b4c:	64746e69 	ldrbtvs	r6, [r4], #-3689	; 0xfffff197
 b50:	682e6665 	stmdavs	lr!, {r0, r2, r5, r6, r9, sl, sp, lr}
 b54:	00000200 	andeq	r0, r0, r0, lsl #4
 b58:	6f697067 	svcvs	0x00697067
 b5c:	0300682e 	movweq	r6, #2094	; 0x82e
 b60:	65700000 	ldrbvs	r0, [r0, #-0]!
 b64:	68706972 	ldmdavs	r0!, {r1, r4, r5, r6, r8, fp, sp, lr}^
 b68:	6c617265 	sfmvs	f7, 2, [r1], #-404	; 0xfffffe6c
 b6c:	00682e73 	rsbeq	r2, r8, r3, ror lr
 b70:	69000002 	stmdbvs	r0, {r1}
 b74:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
 b78:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
 b7c:	6e6f635f 	mcrvs	3, 3, r6, cr15, cr15, {2}
 b80:	6c6f7274 	sfmvs	f7, 2, [pc], #-464	; 9b8 <CPSR_IRQ_INHIBIT+0x938>
 b84:	2e72656c 	cdpcs	5, 7, cr6, cr2, cr12, {3}
 b88:	00040068 	andeq	r0, r4, r8, rrx
 b8c:	6d697400 	cfstrdvs	mvd7, [r9, #-0]
 b90:	682e7265 	stmdavs	lr!, {r0, r2, r5, r6, r9, ip, sp, lr}
 b94:	00000300 	andeq	r0, r0, r0, lsl #6
 b98:	00010500 	andeq	r0, r1, r0, lsl #10
 b9c:	8f140205 	svchi	0x00140205
 ba0:	05190000 	ldreq	r0, [r9, #-0]
 ba4:	05054d12 	streq	r4, [r5, #-3346]	; 0xfffff2ee
 ba8:	4c1305ba 	cfldr32mi	mvfx0, [r3], {186}	; 0xba
 bac:	05671905 	strbeq	r1, [r7, #-2309]!	; 0xfffff6fb
 bb0:	13058901 	movwne	r8, #22785	; 0x5901
 bb4:	6719052b 	ldrvs	r0, [r9, -fp, lsr #10]
 bb8:	85840105 	strhi	r0, [r4, #261]	; 0x105
 bbc:	834b1c05 	movthi	r1, #48133	; 0xbc05
 bc0:	831e0584 	tsthi	lr, #132, 10	; 0x21000000
 bc4:	841d0583 	ldrhi	r0, [sp], #-1411	; 0xfffffa7d
 bc8:	05682405 	strbeq	r2, [r8, #-1029]!	; 0xfffffbfb
 bcc:	23056912 	movwcs	r6, #22802	; 0x5912
 bd0:	680f05a1 	stmdavs	pc, {r0, r5, r7, r8, sl}	; <UNPREDICTABLE>
 bd4:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
 bd8:	02300104 	eorseq	r0, r0, #4, 2
 bdc:	0101000a 	tsteq	r1, sl
 be0:	000000b8 	strheq	r0, [r0], -r8
 be4:	006d0003 	rsbeq	r0, sp, r3
 be8:	01020000 	mrseq	r0, (UNDEF: 2)
 bec:	000d0efb 	strdeq	r0, [sp], -fp
 bf0:	01010101 	tsteq	r1, r1, lsl #2
 bf4:	01000000 	mrseq	r0, (UNDEF: 0)
 bf8:	2f010000 	svccs	0x00010000
 bfc:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
 c00:	6c69732f 	stclvs	3, cr7, [r9], #-188	; 0xffffff44
 c04:	79766168 	ldmdbvc	r6!, {r3, r5, r6, r8, sp, lr}^
 c08:	63532f6a 	cmpvs	r3, #424	; 0x1a8
 c0c:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; a74 <CPSR_IRQ_INHIBIT+0x9f4>
 c10:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
 c14:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
 c18:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 c1c:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
 c20:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
 c24:	69742d30 	ldmdbvs	r4!, {r4, r5, r8, sl, fp, sp}^
 c28:	5f72656d 	svcpl	0x0072656d
 c2c:	5f646e61 	svcpl	0x00646e61
 c30:	4f495047 	svcmi	0x00495047
 c34:	746e695f 	strbtvc	r6, [lr], #-2399	; 0xfffff6a1
 c38:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
 c3c:	6b2f7470 	blvs	bdde04 <_bss_end+0xbd4b58>
 c40:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 c44:	72732f6c 	rsbsvc	r2, r3, #108, 30	; 0x1b0
 c48:	73000063 	movwvc	r0, #99	; 0x63
 c4c:	74726174 	ldrbtvc	r6, [r2], #-372	; 0xfffffe8c
 c50:	0100732e 	tsteq	r0, lr, lsr #6
 c54:	00000000 	andeq	r0, r0, r0
 c58:	80000205 	andhi	r0, r0, r5, lsl #4
 c5c:	0d030000 	stceq	0, cr0, [r3, #-0]
 c60:	2f2f2f01 	svccs	0x002f2f01
 c64:	2f2f2f2f 	svccs	0x002f2f2f
 c68:	20081d03 	andcs	r1, r8, r3, lsl #26
 c6c:	2f322f31 	svccs	0x00322f31
 c70:	2f312f2f 	svccs	0x00312f2f
 c74:	2f2f312f 	svccs	0x002f312f
 c78:	302f2f31 	eorcc	r2, pc, r1, lsr pc	; <UNPREDICTABLE>
 c7c:	302f2f2f 	eorcc	r2, pc, pc, lsr #30
 c80:	01000202 	tsteq	r0, r2, lsl #4
 c84:	02050001 	andeq	r0, r5, #1
 c88:	00009030 	andeq	r9, r0, r0, lsr r0
 c8c:	0100d903 	tsteq	r0, r3, lsl #18
 c90:	2f2f2f2f 	svccs	0x002f2f2f
 c94:	02333331 	eorseq	r3, r3, #-1006632960	; 0xc4000000
 c98:	01010002 	tsteq	r1, r2
 c9c:	000000f2 	strdeq	r0, [r0], -r2
 ca0:	00710003 	rsbseq	r0, r1, r3
 ca4:	01020000 	mrseq	r0, (UNDEF: 2)
 ca8:	000d0efb 	strdeq	r0, [sp], -fp
 cac:	01010101 	tsteq	r1, r1, lsl #2
 cb0:	01000000 	mrseq	r0, (UNDEF: 0)
 cb4:	2f010000 	svccs	0x00010000
 cb8:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
 cbc:	6c69732f 	stclvs	3, cr7, [r9], #-188	; 0xffffff44
 cc0:	79766168 	ldmdbvc	r6!, {r3, r5, r6, r8, sp, lr}^
 cc4:	63532f6a 	cmpvs	r3, #424	; 0x1a8
 cc8:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; b30 <CPSR_IRQ_INHIBIT+0xab0>
 ccc:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
 cd0:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
 cd4:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 cd8:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
 cdc:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
 ce0:	69742d30 	ldmdbvs	r4!, {r4, r5, r8, sl, fp, sp}^
 ce4:	5f72656d 	svcpl	0x0072656d
 ce8:	5f646e61 	svcpl	0x00646e61
 cec:	4f495047 	svcmi	0x00495047
 cf0:	746e695f 	strbtvc	r6, [lr], #-2399	; 0xfffff6a1
 cf4:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
 cf8:	6b2f7470 	blvs	bddec0 <_bss_end+0xbd4c14>
 cfc:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 d00:	72732f6c 	rsbsvc	r2, r3, #108, 30	; 0x1b0
 d04:	73000063 	movwvc	r0, #99	; 0x63
 d08:	74726174 	ldrbtvc	r6, [r2], #-372	; 0xfffffe8c
 d0c:	632e7075 			; <UNDEFINED> instruction: 0x632e7075
 d10:	01007070 	tsteq	r0, r0, ror r0
 d14:	05000000 	streq	r0, [r0, #-0]
 d18:	02050001 	andeq	r0, r5, #1
 d1c:	00009050 	andeq	r9, r0, r0, asr r0
 d20:	05011403 	streq	r1, [r1, #-1027]	; 0xfffffbfd
 d24:	22056a0c 	andcs	r6, r5, #12, 20	; 0xc000
 d28:	03040200 	movweq	r0, #16896	; 0x4200
 d2c:	000c0566 	andeq	r0, ip, r6, ror #10
 d30:	bb020402 	bllt	81d40 <_bss_end+0x78a94>
 d34:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
 d38:	05650204 	strbeq	r0, [r5, #-516]!	; 0xfffffdfc
 d3c:	0105850c 	tsteq	r5, ip, lsl #10
 d40:	1005bd2f 	andne	fp, r5, pc, lsr #26
 d44:	0027056b 	eoreq	r0, r7, fp, ror #10
 d48:	4a030402 	bmi	c1d58 <_bss_end+0xb8aac>
 d4c:	02000a05 	andeq	r0, r0, #20480	; 0x5000
 d50:	05830204 	streq	r0, [r3, #516]	; 0x204
 d54:	04020011 	streq	r0, [r2], #-17	; 0xffffffef
 d58:	05054a02 	streq	r4, [r5, #-2562]	; 0xfffff5fe
 d5c:	02040200 	andeq	r0, r4, #0, 4
 d60:	850c052d 	strhi	r0, [ip, #-1325]	; 0xfffffad3
 d64:	a12f0105 			; <UNDEFINED> instruction: 0xa12f0105
 d68:	056a1005 	strbeq	r1, [sl, #-5]!
 d6c:	04020027 	streq	r0, [r2], #-39	; 0xffffffd9
 d70:	0a054a03 	beq	153584 <_bss_end+0x14a2d8>
 d74:	02040200 	andeq	r0, r4, #0, 4
 d78:	00110583 	andseq	r0, r1, r3, lsl #11
 d7c:	4a020402 	bmi	81d8c <_bss_end+0x78ae0>
 d80:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
 d84:	052d0204 	streq	r0, [sp, #-516]!	; 0xfffffdfc
 d88:	0105850c 	tsteq	r5, ip, lsl #10
 d8c:	000a022f 	andeq	r0, sl, pc, lsr #4
 d90:	01030101 	tsteq	r3, r1, lsl #2
 d94:	00030000 	andeq	r0, r3, r0
 d98:	000000fd 	strdeq	r0, [r0], -sp
 d9c:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
 da0:	0101000d 	tsteq	r1, sp
 da4:	00000101 	andeq	r0, r0, r1, lsl #2
 da8:	00000100 	andeq	r0, r0, r0, lsl #2
 dac:	2f2e2e01 	svccs	0x002e2e01
 db0:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 db4:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 db8:	2f2e2e2f 	svccs	0x002e2e2f
 dbc:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; d0c <CPSR_IRQ_INHIBIT+0xc8c>
 dc0:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
 dc4:	2e2e2f63 	cdpcs	15, 2, cr2, cr14, cr3, {3}
 dc8:	636e692f 	cmnvs	lr, #770048	; 0xbc000
 dcc:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
 dd0:	2f2e2e00 	svccs	0x002e2e00
 dd4:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 dd8:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 ddc:	2f2e2e2f 	svccs	0x002e2e2f
 de0:	63672f2e 	cmnvs	r7, #46, 30	; 0xb8
 de4:	2e2e0063 	cdpcs	0, 2, cr0, cr14, cr3, {3}
 de8:	2f2e2e2f 	svccs	0x002e2e2f
 dec:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 df0:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 df4:	2f2e2e2f 	svccs	0x002e2e2f
 df8:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
 dfc:	2e2f6363 	cdpcs	3, 2, cr6, cr15, cr3, {3}
 e00:	63672f2e 	cmnvs	r7, #46, 30	; 0xb8
 e04:	6f632f63 	svcvs	0x00632f63
 e08:	6769666e 	strbvs	r6, [r9, -lr, ror #12]!
 e0c:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
 e10:	2f2e2e00 	svccs	0x002e2e00
 e14:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 e18:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 e1c:	2f2e2e2f 	svccs	0x002e2e2f
 e20:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; d70 <CPSR_IRQ_INHIBIT+0xcf0>
 e24:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
 e28:	68000063 	stmdavs	r0, {r0, r1, r5, r6}
 e2c:	74687361 	strbtvc	r7, [r8], #-865	; 0xfffffc9f
 e30:	682e6261 	stmdavs	lr!, {r0, r5, r6, r9, sp, lr}
 e34:	00000100 	andeq	r0, r0, r0, lsl #2
 e38:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
 e3c:	2e617369 	cdpcs	3, 6, cr7, cr1, cr9, {3}
 e40:	00020068 	andeq	r0, r2, r8, rrx
 e44:	6d726100 	ldfvse	f6, [r2, #-0]
 e48:	7570632d 	ldrbvc	r6, [r0, #-813]!	; 0xfffffcd3
 e4c:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 e50:	6e690000 	cdpvs	0, 6, cr0, cr9, cr0, {0}
 e54:	632d6e73 			; <UNDEFINED> instruction: 0x632d6e73
 e58:	74736e6f 	ldrbtvc	r6, [r3], #-3695	; 0xfffff191
 e5c:	73746e61 	cmnvc	r4, #1552	; 0x610
 e60:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 e64:	72610000 	rsbvc	r0, r1, #0
 e68:	00682e6d 	rsbeq	r2, r8, sp, ror #28
 e6c:	6c000003 	stcvs	0, cr0, [r0], {3}
 e70:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
 e74:	682e3263 	stmdavs	lr!, {r0, r1, r5, r6, r9, ip, sp}
 e78:	00000400 	andeq	r0, r0, r0, lsl #8
 e7c:	2d6c6267 	sfmcs	f6, 2, [ip, #-412]!	; 0xfffffe64
 e80:	726f7463 	rsbvc	r7, pc, #1660944384	; 0x63000000
 e84:	00682e73 	rsbeq	r2, r8, r3, ror lr
 e88:	6c000004 	stcvs	0, cr0, [r0], {4}
 e8c:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
 e90:	632e3263 			; <UNDEFINED> instruction: 0x632e3263
 e94:	00000400 	andeq	r0, r0, r0, lsl #8
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
      20:	5b202965 	blpl	80a5bc <_bss_end+0x801310>
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
      88:	7a6a3637 	bvc	1a8d96c <_bss_end+0x1a846c0>
      8c:	20732d66 	rsbscs	r2, r3, r6, ror #26
      90:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
      94:	6d2d206d 	stcvs	0, cr2, [sp, #-436]!	; 0xfffffe4c
      98:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
      9c:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
      a0:	6b7a3676 	blvs	1e8da80 <_bss_end+0x1e847d4>
      a4:	2070662b 	rsbscs	r6, r0, fp, lsr #12
      a8:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
      ac:	4f2d2067 	svcmi	0x002d2067
      b0:	4f2d2030 	svcmi	0x002d2030
      b4:	5f5f0030 	svcpl	0x005f0030
      b8:	5f617863 	svcpl	0x00617863
      bc:	72617567 	rsbvc	r7, r1, #432013312	; 0x19c00000
      c0:	65725f64 	ldrbvs	r5, [r2, #-3940]!	; 0xfffff09c
      c4:	7361656c 	cmnvc	r1, #108, 10	; 0x1b000000
      c8:	5f5f0065 	svcpl	0x005f0065
      cc:	5f617863 	svcpl	0x00617863
      d0:	72617567 	rsbvc	r7, r1, #432013312	; 0x19c00000
      d4:	62615f64 	rsbvs	r5, r1, #100, 30	; 0x190
      d8:	0074726f 	rsbseq	r7, r4, pc, ror #4
      dc:	73645f5f 	cmnvc	r4, #380	; 0x17c
      e0:	61685f6f 	cmnvs	r8, pc, ror #30
      e4:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
      e8:	635f5f00 	cmpvs	pc, #0, 30
      ec:	615f6178 	cmpvs	pc, r8, ror r1	; <UNPREDICTABLE>
      f0:	69786574 	ldmdbvs	r8!, {r2, r4, r5, r6, r8, sl, sp, lr}^
      f4:	682f0074 	stmdavs	pc!, {r2, r4, r5, r6}	; <UNPREDICTABLE>
      f8:	2f656d6f 	svccs	0x00656d6f
      fc:	686c6973 	stmdavs	ip!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
     100:	6a797661 	bvs	1e5da8c <_bss_end+0x1e547e0>
     104:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
     108:	2f6c6f6f 	svccs	0x006c6f6f
     10c:	6f72655a 	svcvs	0x0072655a
     110:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
     114:	6178652f 	cmnvs	r8, pc, lsr #10
     118:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
     11c:	30312f73 	eorscc	r2, r1, r3, ror pc
     120:	6d69742d 	cfstrdvs	mvd7, [r9, #-180]!	; 0xffffff4c
     124:	615f7265 	cmpvs	pc, r5, ror #4
     128:	475f646e 	ldrbmi	r6, [pc, -lr, ror #8]
     12c:	5f4f4950 	svcpl	0x004f4950
     130:	65746e69 	ldrbvs	r6, [r4, #-3689]!	; 0xfffff197
     134:	70757272 	rsbsvc	r7, r5, r2, ror r2
     138:	75622f74 	strbvc	r2, [r2, #-3956]!	; 0xfffff08c
     13c:	00646c69 	rsbeq	r6, r4, r9, ror #24
     140:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 8c <CPSR_IRQ_INHIBIT+0xc>
     144:	69732f65 	ldmdbvs	r3!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
     148:	7661686c 	strbtvc	r6, [r1], -ip, ror #16
     14c:	532f6a79 			; <UNDEFINED> instruction: 0x532f6a79
     150:	6f6f6863 	svcvs	0x006f6863
     154:	655a2f6c 	ldrbvs	r2, [sl, #-3948]	; 0xfffff094
     158:	614d6f72 	hvcvs	55026	; 0xd6f2
     15c:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffbf0 <_bss_end+0xffff6944>
     160:	706d6178 	rsbvc	r6, sp, r8, ror r1
     164:	2f73656c 	svccs	0x0073656c
     168:	742d3031 	strtvc	r3, [sp], #-49	; 0xffffffcf
     16c:	72656d69 	rsbvc	r6, r5, #6720	; 0x1a40
     170:	646e615f 	strbtvs	r6, [lr], #-351	; 0xfffffea1
     174:	4950475f 	ldmdbmi	r0, {r0, r1, r2, r3, r4, r6, r8, r9, sl, lr}^
     178:	6e695f4f 	cdpvs	15, 6, cr5, cr9, cr15, {2}
     17c:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
     180:	2f747075 	svccs	0x00747075
     184:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
     188:	732f6c65 			; <UNDEFINED> instruction: 0x732f6c65
     18c:	632f6372 			; <UNDEFINED> instruction: 0x632f6372
     190:	632e7878 			; <UNDEFINED> instruction: 0x632e7878
     194:	5f007070 	svcpl	0x00007070
     198:	6178635f 	cmnvs	r8, pc, asr r3
     19c:	6175675f 	cmnvs	r5, pc, asr r7
     1a0:	615f6472 	cmpvs	pc, r2, ror r4	; <UNPREDICTABLE>
     1a4:	69757163 	ldmdbvs	r5!, {r0, r1, r5, r6, r8, ip, sp, lr}^
     1a8:	5f006572 	svcpl	0x00006572
     1ac:	7878635f 	ldmdavc	r8!, {r0, r1, r2, r3, r4, r6, r8, r9, sp, lr}^
     1b0:	76696261 	strbtvc	r6, [r9], -r1, ror #4
     1b4:	5f5f0031 	svcpl	0x005f0031
     1b8:	5f617863 	svcpl	0x00617863
     1bc:	65727570 	ldrbvs	r7, [r2, #-1392]!	; 0xfffffa90
     1c0:	7269765f 	rsbvc	r7, r9, #99614720	; 0x5f00000
     1c4:	6c617574 	cfstr64vs	mvdx7, [r1], #-464	; 0xfffffe30
     1c8:	615f5f00 	cmpvs	pc, r0, lsl #30
     1cc:	69626165 	stmdbvs	r2!, {r0, r2, r5, r6, r8, sp, lr}^
     1d0:	776e755f 			; <UNDEFINED> instruction: 0x776e755f
     1d4:	5f646e69 	svcpl	0x00646e69
     1d8:	5f707063 	svcpl	0x00707063
     1dc:	00317270 	eorseq	r7, r1, r0, ror r2
     1e0:	75675f5f 	strbvc	r5, [r7, #-3935]!	; 0xfffff0a1
     1e4:	00647261 	rsbeq	r7, r4, r1, ror #4
     1e8:	676e6f6c 	strbvs	r6, [lr, -ip, ror #30]!
     1ec:	6e6f6c20 	cdpvs	12, 6, cr6, cr15, cr0, {1}
     1f0:	6e692067 	cdpvs	0, 6, cr2, cr9, cr7, {3}
     1f4:	5a5f0074 	bpl	17c03cc <_bss_end+0x17b7120>
     1f8:	33314b4e 	teqcc	r1, #79872	; 0x13800
     1fc:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     200:	61485f4f 	cmpvs	r8, pc, asr #30
     204:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     208:	47383172 			; <UNDEFINED> instruction: 0x47383172
     20c:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     210:	56454c50 			; <UNDEFINED> instruction: 0x56454c50
     214:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     218:	6f697461 	svcvs	0x00697461
     21c:	526a456e 	rsbpl	r4, sl, #461373440	; 0x1b800000
     220:	5f30536a 	svcpl	0x0030536a
     224:	53504700 	cmppl	r0, #0, 14
     228:	00305445 	eorseq	r5, r0, r5, asr #8
     22c:	45535047 	ldrbmi	r5, [r3, #-71]	; 0xffffffb9
     230:	47003154 	smlsdmi	r0, r4, r1, r3
     234:	45534650 	ldrbmi	r4, [r3, #-1616]	; 0xfffff9b0
     238:	4700304c 	strmi	r3, [r0, -ip, asr #32]
     23c:	45534650 	ldrbmi	r4, [r3, #-1616]	; 0xfffff9b0
     240:	4700314c 	strmi	r3, [r0, -ip, asr #2]
     244:	45534650 	ldrbmi	r4, [r3, #-1616]	; 0xfffff9b0
     248:	4700324c 	strmi	r3, [r0, -ip, asr #4]
     24c:	45534650 	ldrbmi	r4, [r3, #-1616]	; 0xfffff9b0
     250:	4700334c 	strmi	r3, [r0, -ip, asr #6]
     254:	45534650 	ldrbmi	r4, [r3, #-1616]	; 0xfffff9b0
     258:	4700344c 	strmi	r3, [r0, -ip, asr #8]
     25c:	45534650 	ldrbmi	r4, [r3, #-1616]	; 0xfffff9b0
     260:	4700354c 	strmi	r3, [r0, -ip, asr #10]
     264:	4e454650 	mcrmi	6, 2, r4, cr5, cr0, {2}
     268:	6e490031 	mcrvs	0, 2, r0, cr9, cr1, {1}
     26c:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
     270:	5f747075 	svcpl	0x00747075
     274:	746e6f43 	strbtvc	r6, [lr], #-3907	; 0xfffff0bd
     278:	6c6c6f72 	stclvs	15, cr6, [ip], #-456	; 0xfffffe38
     27c:	425f7265 	subsmi	r7, pc, #1342177286	; 0x50000006
     280:	00657361 	rsbeq	r7, r5, r1, ror #6
     284:	5f746547 	svcpl	0x00746547
     288:	495f5047 	ldmdbmi	pc, {r0, r1, r2, r6, ip, lr}^	; <UNPREDICTABLE>
     28c:	445f5152 	ldrbmi	r5, [pc], #-338	; 294 <CPSR_IRQ_INHIBIT+0x214>
     290:	63657465 	cmnvs	r5, #1694498816	; 0x65000000
     294:	6f4c5f74 	svcvs	0x004c5f74
     298:	69746163 	ldmdbvs	r4!, {r0, r1, r5, r6, r8, sp, lr}^
     29c:	47006e6f 	strmi	r6, [r0, -pc, ror #28]
     2a0:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     2a4:	53444550 	movtpl	r4, #17744	; 0x4550
     2a8:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     2ac:	6f697461 	svcvs	0x00697461
     2b0:	6948006e 	stmdbvs	r8, {r1, r2, r3, r5, r6}^
     2b4:	73006867 	movwvc	r6, #2151	; 0x867
     2b8:	74726f68 	ldrbtvc	r6, [r2], #-3944	; 0xfffff098
     2bc:	746e6920 	strbtvc	r6, [lr], #-2336	; 0xfffff6e0
     2c0:	50504700 	subspl	r4, r0, r0, lsl #14
     2c4:	4c434455 	cfstrdmi	mvd4, [r3], {85}	; 0x55
     2c8:	4700304b 	strmi	r3, [r0, -fp, asr #32]
     2cc:	44555050 	ldrbmi	r5, [r5], #-80	; 0xffffffb0
     2d0:	314b4c43 	cmpcc	fp, r3, asr #24
     2d4:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     2d8:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     2dc:	5f4f4950 	svcpl	0x004f4950
     2e0:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     2e4:	3172656c 	cmncc	r2, ip, ror #10
     2e8:	616e4539 	cmnvs	lr, r9, lsr r5
     2ec:	5f656c62 	svcpl	0x00656c62
     2f0:	6e657645 	cdpvs	6, 6, cr7, cr5, cr5, {2}
     2f4:	65445f74 	strbvs	r5, [r4, #-3956]	; 0xfffff08c
     2f8:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
     2fc:	30326a45 	eorscc	r6, r2, r5, asr #20
     300:	4950474e 	ldmdbmi	r0, {r1, r2, r3, r6, r8, r9, sl, lr}^
     304:	6e495f4f 	cdpvs	15, 4, cr5, cr9, cr15, {2}
     308:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
     30c:	5f747075 	svcpl	0x00747075
     310:	65707954 	ldrbvs	r7, [r0, #-2388]!	; 0xfffff6ac
     314:	52504700 	subspl	r4, r0, #0, 14
     318:	00304e45 	eorseq	r4, r0, r5, asr #28
     31c:	45525047 	ldrbmi	r5, [r2, #-71]	; 0xffffffb9
     320:	5f00314e 	svcpl	0x0000314e
     324:	33314e5a 	teqcc	r1, #1440	; 0x5a0
     328:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     32c:	61485f4f 	cmpvs	r8, pc, asr #30
     330:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     334:	53303172 	teqpl	r0, #-2147483620	; 0x8000001c
     338:	4f5f7465 	svcmi	0x005f7465
     33c:	75707475 	ldrbvc	r7, [r0, #-1141]!	; 0xfffffb8b
     340:	626a4574 	rsbvs	r4, sl, #116, 10	; 0x1d000000
     344:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     348:	4333314b 	teqmi	r3, #-1073741806	; 0xc0000012
     34c:	4f495047 	svcmi	0x00495047
     350:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     354:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     358:	65473931 	strbvs	r3, [r7, #-2353]	; 0xfffff6cf
     35c:	50475f74 	subpl	r5, r7, r4, ror pc
     360:	4c455346 	mcrrmi	3, 4, r5, r5, cr6
     364:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     368:	6f697461 	svcvs	0x00697461
     36c:	526a456e 	rsbpl	r4, sl, #461373440	; 0x1b800000
     370:	5f30536a 	svcpl	0x0030536a
     374:	50476d00 	subpl	r6, r7, r0, lsl #26
     378:	5f004f49 	svcpl	0x00004f49
     37c:	33314e5a 	teqcc	r1, #1440	; 0x5a0
     380:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     384:	61485f4f 	cmpvs	r8, pc, asr #30
     388:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     38c:	45344372 	ldrmi	r4, [r4, #-882]!	; 0xfffffc8e
     390:	6975006a 	ldmdbvs	r5!, {r1, r3, r5, r6}^
     394:	5f38746e 	svcpl	0x0038746e
     398:	50470074 	subpl	r0, r7, r4, ror r0
     39c:	30534445 	subscc	r4, r3, r5, asr #8
     3a0:	45504700 	ldrbmi	r4, [r0, #-1792]	; 0xfffff900
     3a4:	00315344 	eorseq	r5, r1, r4, asr #6
     3a8:	746e6975 	strbtvc	r6, [lr], #-2421	; 0xfffff68b
     3ac:	745f3233 	ldrbvc	r3, [pc], #-563	; 3b4 <CPSR_IRQ_INHIBIT+0x334>
     3b0:	6f6f6200 	svcvs	0x006f6200
     3b4:	6e55006c 	cdpvs	0, 5, cr0, cr5, cr12, {3}
     3b8:	63657073 	cmnvs	r5, #115	; 0x73
     3bc:	65696669 	strbvs	r6, [r9, #-1641]!	; 0xfffff997
     3c0:	6c430064 	mcrrvs	0, 6, r0, r3, cr4
     3c4:	5f726165 	svcpl	0x00726165
     3c8:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
     3cc:	64657463 	strbtvs	r7, [r5], #-1123	; 0xfffffb9d
     3d0:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
     3d4:	4700746e 	strmi	r7, [r0, -lr, ror #8]
     3d8:	4e454c50 	mcrmi	12, 2, r4, cr5, cr0, {2}
     3dc:	5a5f0030 	bpl	17c04a4 <_bss_end+0x17b71f8>
     3e0:	33314b4e 	teqcc	r1, #79872	; 0x13800
     3e4:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     3e8:	61485f4f 	cmpvs	r8, pc, asr #30
     3ec:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     3f0:	47363272 			; <UNDEFINED> instruction: 0x47363272
     3f4:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     3f8:	52495f50 	subpl	r5, r9, #80, 30	; 0x140
     3fc:	65445f51 	strbvs	r5, [r4, #-3921]	; 0xfffff0af
     400:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
     404:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     408:	6f697461 	svcvs	0x00697461
     40c:	326a456e 	rsbcc	r4, sl, #461373440	; 0x1b800000
     410:	50474e30 	subpl	r4, r7, r0, lsr lr
     414:	495f4f49 	ldmdbmi	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     418:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
     41c:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
     420:	7079545f 	rsbsvc	r5, r9, pc, asr r4
     424:	536a5265 	cmnpl	sl, #1342177286	; 0x50000006
     428:	47005f31 	smladxmi	r0, r1, pc, r5	; <UNPREDICTABLE>
     42c:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     430:	5f4f4950 	svcpl	0x004f4950
     434:	636e7546 	cmnvs	lr, #293601280	; 0x11800000
     438:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     43c:	50474300 	subpl	r4, r7, r0, lsl #6
     440:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     444:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     448:	47007265 	strmi	r7, [r0, -r5, ror #4]
     44c:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     450:	54455350 	strbpl	r5, [r5], #-848	; 0xfffffcb0
     454:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     458:	6f697461 	svcvs	0x00697461
     45c:	5047006e 	subpl	r0, r7, lr, rrx
     460:	00445550 	subeq	r5, r4, r0, asr r5
     464:	314e5a5f 	cmpcc	lr, pc, asr sl
     468:	50474333 	subpl	r4, r7, r3, lsr r3
     46c:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     470:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     474:	30327265 	eorscc	r7, r2, r5, ror #4
     478:	61656c43 	cmnvs	r5, r3, asr #24
     47c:	65445f72 	strbvs	r5, [r4, #-3954]	; 0xfffff08e
     480:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
     484:	455f6465 	ldrbmi	r6, [pc, #-1125]	; 27 <CPSR_MODE_SVR+0x14>
     488:	746e6576 	strbtvc	r6, [lr], #-1398	; 0xfffffa8a
     48c:	50006a45 	andpl	r6, r0, r5, asr #20
     490:	70697265 	rsbvc	r7, r9, r5, ror #4
     494:	61726568 	cmnvs	r2, r8, ror #10
     498:	61425f6c 	cmpvs	r2, ip, ror #30
     49c:	47006573 	smlsdxmi	r0, r3, r5, r6
     4a0:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     4a4:	56454c50 			; <UNDEFINED> instruction: 0x56454c50
     4a8:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     4ac:	6f697461 	svcvs	0x00697461
     4b0:	5a5f006e 	bpl	17c0670 <_bss_end+0x17b73c4>
     4b4:	33314b4e 	teqcc	r1, #79872	; 0x13800
     4b8:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     4bc:	61485f4f 	cmpvs	r8, pc, asr #30
     4c0:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     4c4:	47373172 			; <UNDEFINED> instruction: 0x47373172
     4c8:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     4cc:	5f4f4950 	svcpl	0x004f4950
     4d0:	636e7546 	cmnvs	lr, #293601280	; 0x11800000
     4d4:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     4d8:	5f006a45 	svcpl	0x00006a45
     4dc:	696e695f 	stmdbvs	lr!, {r0, r1, r2, r3, r4, r6, r8, fp, sp, lr}^
     4e0:	6c616974 			; <UNDEFINED> instruction: 0x6c616974
     4e4:	5f657a69 	svcpl	0x00657a69
     4e8:	5a5f0070 	bpl	17c06b0 <_bss_end+0x17b7404>
     4ec:	4333314e 	teqmi	r3, #-2147483629	; 0x80000013
     4f0:	4f495047 	svcmi	0x00495047
     4f4:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     4f8:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     4fc:	6a453243 	bvs	114ce10 <_bss_end+0x1143b64>
     500:	41504700 	cmpmi	r0, r0, lsl #14
     504:	304e4546 	subcc	r4, lr, r6, asr #10
     508:	41504700 	cmpmi	r0, r0, lsl #14
     50c:	314e4546 	cmpcc	lr, r6, asr #10
     510:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     514:	4333314b 	teqmi	r3, #-1073741806	; 0xc0000012
     518:	4f495047 	svcmi	0x00495047
     51c:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     520:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     524:	65473831 	strbvs	r3, [r7, #-2097]	; 0xfffff7cf
     528:	50475f74 	subpl	r5, r7, r4, ror pc
     52c:	5f524c43 	svcpl	0x00524c43
     530:	61636f4c 	cmnvs	r3, ip, asr #30
     534:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     538:	6a526a45 	bvs	149ae54 <_bss_end+0x1491ba8>
     53c:	005f3053 	subseq	r3, pc, r3, asr r0	; <UNPREDICTABLE>
     540:	69736e75 	ldmdbvs	r3!, {r0, r2, r4, r5, r6, r9, sl, fp, sp, lr}^
     544:	64656e67 	strbtvs	r6, [r5], #-3687	; 0xfffff199
     548:	61686320 	cmnvs	r8, r0, lsr #6
     54c:	475f0072 			; <UNDEFINED> instruction: 0x475f0072
     550:	41424f4c 	cmpmi	r2, ip, asr #30
     554:	735f5f4c 	cmpvc	pc, #76, 30	; 0x130
     558:	495f6275 	ldmdbmi	pc, {r0, r2, r4, r5, r6, r9, sp, lr}^	; <UNPREDICTABLE>
     55c:	5047735f 	subpl	r7, r7, pc, asr r3
     560:	47004f49 	strmi	r4, [r0, -r9, asr #30]
     564:	5f4f4950 	svcpl	0x004f4950
     568:	65736142 	ldrbvs	r6, [r3, #-322]!	; 0xfffffebe
     56c:	43504700 	cmpmi	r0, #0, 14
     570:	0031524c 	eorseq	r5, r1, ip, asr #4
     574:	52415047 	subpl	r5, r1, #71	; 0x47
     578:	00304e45 	eorseq	r4, r0, r5, asr #28
     57c:	52415047 	subpl	r5, r1, #71	; 0x47
     580:	00314e45 	eorseq	r4, r1, r5, asr #28
     584:	45485047 	strbmi	r5, [r8, #-71]	; 0xffffffb9
     588:	4700304e 	strmi	r3, [r0, -lr, asr #32]
     58c:	4e454850 	mcrmi	8, 2, r4, cr5, cr0, {2}
     590:	70670031 	rsbvc	r0, r7, r1, lsr r0
     594:	625f6f69 	subsvs	r6, pc, #420	; 0x1a4
     598:	5f657361 	svcpl	0x00657361
     59c:	72646461 	rsbvc	r6, r4, #1627389952	; 0x61000000
     5a0:	6f687300 	svcvs	0x00687300
     5a4:	75207472 	strvc	r7, [r0, #-1138]!	; 0xfffffb8e
     5a8:	6769736e 	strbvs	r7, [r9, -lr, ror #6]!
     5ac:	2064656e 	rsbcs	r6, r4, lr, ror #10
     5b0:	00746e69 	rsbseq	r6, r4, r9, ror #28
     5b4:	454c5047 	strbmi	r5, [ip, #-71]	; 0xffffffb9
     5b8:	4500314e 	strmi	r3, [r0, #-334]	; 0xfffffeb2
     5bc:	6c62616e 	stfvse	f6, [r2], #-440	; 0xfffffe48
     5c0:	76455f65 	strbvc	r5, [r5], -r5, ror #30
     5c4:	5f746e65 	svcpl	0x00746e65
     5c8:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
     5cc:	5f007463 	svcpl	0x00007463
     5d0:	314b4e5a 	cmpcc	fp, sl, asr lr
     5d4:	50474333 	subpl	r4, r7, r3, lsr r3
     5d8:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     5dc:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     5e0:	38317265 	ldmdacc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     5e4:	5f746547 	svcpl	0x00746547
     5e8:	44455047 	strbmi	r5, [r5], #-71	; 0xffffffb9
     5ec:	6f4c5f53 	svcvs	0x004c5f53
     5f0:	69746163 	ldmdbvs	r4!, {r0, r1, r5, r6, r8, sp, lr}^
     5f4:	6a456e6f 	bvs	115bfb8 <_bss_end+0x1152d0c>
     5f8:	30536a52 	subscc	r6, r3, r2, asr sl
     5fc:	6547005f 	strbvs	r0, [r7, #-95]	; 0xffffffa1
     600:	50475f74 	subpl	r5, r7, r4, ror pc
     604:	4c455346 	mcrrmi	3, 4, r5, r5, cr6
     608:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     60c:	6f697461 	svcvs	0x00697461
     610:	5047006e 	subpl	r0, r7, lr, rrx
     614:	505f4f49 	subspl	r4, pc, r9, asr #30
     618:	435f6e69 	cmpmi	pc, #1680	; 0x690
     61c:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
     620:	6e756600 	cdpvs	6, 7, cr6, cr5, cr0, {0}
     624:	69540063 	ldmdbvs	r4, {r0, r1, r5, r6}^
     628:	5f72656d 	svcpl	0x0072656d
     62c:	65736142 	ldrbvs	r6, [r3, #-322]!	; 0xfffffebe
     630:	735f5f00 	cmpvc	pc, #0, 30
     634:	69746174 	ldmdbvs	r4!, {r2, r4, r5, r6, r8, sp, lr}^
     638:	6e695f63 	cdpvs	15, 6, cr5, cr9, cr3, {3}
     63c:	61697469 	cmnvs	r9, r9, ror #8
     640:	617a696c 	cmnvs	sl, ip, ror #18
     644:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     648:	646e615f 	strbtvs	r6, [lr], #-351	; 0xfffffea1
     64c:	7365645f 	cmnvc	r5, #1593835520	; 0x5f000000
     650:	63757274 	cmnvs	r5, #116, 4	; 0x40000007
     654:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     658:	4700305f 	smlsdmi	r0, pc, r0, r3	; <UNPREDICTABLE>
     65c:	5f4f4950 	svcpl	0x004f4950
     660:	00676552 	rsbeq	r6, r7, r2, asr r5
     664:	73696874 	cmnvc	r9, #116, 16	; 0x740000
     668:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     66c:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     670:	5f4f4950 	svcpl	0x004f4950
     674:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     678:	3272656c 	rsbscc	r6, r2, #108, 10	; 0x1b000000
     67c:	73694430 	cmnvc	r9, #48, 8	; 0x30000000
     680:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     684:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
     688:	445f746e 	ldrbmi	r7, [pc], #-1134	; 690 <CPSR_IRQ_INHIBIT+0x610>
     68c:	63657465 	cmnvs	r5, #1694498816	; 0x65000000
     690:	326a4574 	rsbcc	r4, sl, #116, 10	; 0x1d000000
     694:	50474e30 	subpl	r4, r7, r0, lsr lr
     698:	495f4f49 	ldmdbmi	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     69c:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
     6a0:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
     6a4:	7079545f 	rsbsvc	r5, r9, pc, asr r4
     6a8:	5a5f0065 	bpl	17c0844 <_bss_end+0x17b7598>
     6ac:	4333314e 	teqmi	r3, #-2147483629	; 0x80000013
     6b0:	4f495047 	svcmi	0x00495047
     6b4:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     6b8:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     6bc:	65533731 	ldrbvs	r3, [r3, #-1841]	; 0xfffff8cf
     6c0:	50475f74 	subpl	r5, r7, r4, ror pc
     6c4:	465f4f49 	ldrbmi	r4, [pc], -r9, asr #30
     6c8:	74636e75 	strbtvc	r6, [r3], #-3701	; 0xfffff18b
     6cc:	456e6f69 	strbmi	r6, [lr, #-3945]!	; 0xfffff097
     6d0:	4e34316a 	rsfmisz	f3, f4, #2.0
     6d4:	4f495047 	svcmi	0x00495047
     6d8:	6e75465f 	mrcvs	6, 3, r4, cr5, cr15, {2}
     6dc:	6f697463 	svcvs	0x00697463
     6e0:	6952006e 	ldmdbvs	r2, {r1, r2, r3, r5, r6}^
     6e4:	676e6973 			; <UNDEFINED> instruction: 0x676e6973
     6e8:	6764455f 			; <UNDEFINED> instruction: 0x6764455f
     6ec:	6c410065 	mcrrvs	0, 6, r0, r1, cr5
     6f0:	00325f74 	eorseq	r5, r2, r4, ror pc
     6f4:	454c5047 	strbmi	r5, [ip, #-71]	; 0xffffffb9
     6f8:	47003056 	smlsdmi	r0, r6, r0, r3
     6fc:	56454c50 			; <UNDEFINED> instruction: 0x56454c50
     700:	65530031 	ldrbvs	r0, [r3, #-49]	; 0xffffffcf
     704:	50475f74 	subpl	r5, r7, r4, ror pc
     708:	465f4f49 	ldrbmi	r4, [pc], -r9, asr #30
     70c:	74636e75 	strbtvc	r6, [r3], #-3701	; 0xfffff18b
     710:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     714:	5f746962 	svcpl	0x00746962
     718:	00786469 	rsbseq	r6, r8, r9, ror #8
     71c:	72705f5f 	rsbsvc	r5, r0, #380	; 0x17c
     720:	69726f69 	ldmdbvs	r2!, {r0, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
     724:	5f007974 	svcpl	0x00007974
     728:	314b4e5a 	cmpcc	fp, sl, asr lr
     72c:	50474333 	subpl	r4, r7, r3, lsr r3
     730:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     734:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     738:	38317265 	ldmdacc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     73c:	5f746547 	svcpl	0x00746547
     740:	45535047 	ldrbmi	r5, [r3, #-71]	; 0xffffffb9
     744:	6f4c5f54 	svcvs	0x004c5f54
     748:	69746163 	ldmdbvs	r4!, {r0, r1, r5, r6, r8, sp, lr}^
     74c:	6a456e6f 	bvs	115c110 <_bss_end+0x1152e64>
     750:	30536a52 	subscc	r6, r3, r2, asr sl
     754:	5541005f 	strbpl	r0, [r1, #-95]	; 0xffffffa1
     758:	61425f58 	cmpvs	r2, r8, asr pc
     75c:	47006573 	smlsdxmi	r0, r3, r5, r6
     760:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     764:	524c4350 	subpl	r4, ip, #80, 6	; 0x40000001
     768:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     76c:	6f697461 	svcvs	0x00697461
     770:	6e49006e 	cdpvs	0, 4, cr0, cr9, cr14, {3}
     774:	00747570 	rsbseq	r7, r4, r0, ror r5
     778:	45465047 	strbmi	r5, [r6, #-71]	; 0xffffffb9
     77c:	5300304e 	movwpl	r3, #78	; 0x4e
     780:	4f5f7465 	svcmi	0x005f7465
     784:	75707475 	ldrbvc	r7, [r0, #-1141]!	; 0xfffffb8b
     788:	682f0074 	stmdavs	pc!, {r2, r4, r5, r6}	; <UNPREDICTABLE>
     78c:	2f656d6f 	svccs	0x00656d6f
     790:	686c6973 	stmdavs	ip!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
     794:	6a797661 	bvs	1e5e120 <_bss_end+0x1e54e74>
     798:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
     79c:	2f6c6f6f 	svccs	0x006c6f6f
     7a0:	6f72655a 	svcvs	0x0072655a
     7a4:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
     7a8:	6178652f 	cmnvs	r8, pc, lsr #10
     7ac:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
     7b0:	30312f73 	eorscc	r2, r1, r3, ror pc
     7b4:	6d69742d 	cfstrdvs	mvd7, [r9, #-180]!	; 0xffffff4c
     7b8:	615f7265 	cmpvs	pc, r5, ror #4
     7bc:	475f646e 	ldrbmi	r6, [pc, -lr, ror #8]
     7c0:	5f4f4950 	svcpl	0x004f4950
     7c4:	65746e69 	ldrbvs	r6, [r4, #-3689]!	; 0xfffff197
     7c8:	70757272 	rsbsvc	r7, r5, r2, ror r2
     7cc:	656b2f74 	strbvs	r2, [fp, #-3956]!	; 0xfffff08c
     7d0:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
     7d4:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
     7d8:	6972642f 	ldmdbvs	r2!, {r0, r1, r2, r3, r5, sl, sp, lr}^
     7dc:	73726576 	cmnvc	r2, #494927872	; 0x1d800000
     7e0:	6970672f 	ldmdbvs	r0!, {r0, r1, r2, r3, r5, r8, r9, sl, sp, lr}^
     7e4:	70632e6f 	rsbvc	r2, r3, pc, ror #28
     7e8:	69440070 	stmdbvs	r4, {r4, r5, r6}^
     7ec:	6c626173 	stfvse	f6, [r2], #-460	; 0xfffffe34
     7f0:	76455f65 	strbvc	r5, [r5], -r5, ror #30
     7f4:	5f746e65 	svcpl	0x00746e65
     7f8:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
     7fc:	46007463 	strmi	r7, [r0], -r3, ror #8
     800:	696c6c61 	stmdbvs	ip!, {r0, r5, r6, sl, fp, sp, lr}^
     804:	455f676e 	ldrbmi	r6, [pc, #-1902]	; 9e <CPSR_IRQ_INHIBIT+0x1e>
     808:	00656764 	rsbeq	r6, r5, r4, ror #14
     80c:	5f746c41 	svcpl	0x00746c41
     810:	6c410030 	mcrrvs	0, 3, r0, r1, cr0
     814:	00315f74 	eorseq	r5, r1, r4, ror pc
     818:	61666544 	cmnvs	r6, r4, asr #10
     81c:	5f746c75 	svcpl	0x00746c75
     820:	636f6c43 	cmnvs	pc, #17152	; 0x4300
     824:	61525f6b 	cmpvs	r2, fp, ror #30
     828:	41006574 	tstmi	r0, r4, ror r5
     82c:	335f746c 	cmpcc	pc, #108, 8	; 0x6c000000
     830:	746c4100 	strbtvc	r4, [ip], #-256	; 0xffffff00
     834:	4100345f 	tstmi	r0, pc, asr r4
     838:	355f746c 	ldrbcc	r7, [pc, #-1132]	; 3d4 <CPSR_IRQ_INHIBIT+0x354>
     83c:	43504700 	cmpmi	r0, #0, 14
     840:	0030524c 	eorseq	r5, r0, ip, asr #4
     844:	4f4c475f 	svcmi	0x004c475f
     848:	5f4c4142 	svcpl	0x004c4142
     84c:	6275735f 	rsbsvs	r7, r5, #2080374785	; 0x7c000001
     850:	735f495f 	cmpvc	pc, #1556480	; 0x17c000
     854:	656d6954 	strbvs	r6, [sp, #-2388]!	; 0xfffff6ac
     858:	5a5f0072 	bpl	17c0a28 <_bss_end+0x17b777c>
     85c:	5443364e 	strbpl	r3, [r3], #-1614	; 0xfffff9b2
     860:	72656d69 	rsbvc	r6, r5, #6720	; 0x1a40
     864:	73493032 	movtvc	r3, #36914	; 0x9032
     868:	6d69545f 	cfstrdvs	mvd5, [r9, #-380]!	; 0xfffffe84
     86c:	495f7265 	ldmdbmi	pc, {r0, r2, r5, r6, r9, ip, sp, lr}^	; <UNPREDICTABLE>
     870:	505f5152 	subspl	r5, pc, r2, asr r1	; <UNPREDICTABLE>
     874:	69646e65 	stmdbvs	r4!, {r0, r2, r5, r6, r9, sl, fp, sp, lr}^
     878:	7645676e 	strbvc	r6, [r5], -lr, ror #14
     87c:	6c616800 	stclvs	8, cr6, [r1], #-0
     880:	6e695f74 	mcrvs	15, 3, r5, cr9, cr4, {3}
     884:	6265645f 	rsbvs	r6, r5, #1593835520	; 0x5f000000
     888:	625f6775 	subsvs	r6, pc, #30670848	; 0x1d40000
     88c:	6b616572 	blvs	1859e5c <_bss_end+0x1850bb0>
     890:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     894:	69544336 	ldmdbvs	r4, {r1, r2, r4, r5, r8, r9, lr}^
     898:	4372656d 	cmnmi	r2, #457179136	; 0x1b400000
     89c:	006d4532 	rsbeq	r4, sp, r2, lsr r5
     8a0:	6f6c6552 	svcvs	0x006c6552
     8a4:	49006461 	stmdbmi	r0, {r0, r5, r6, sl, sp, lr}
     8a8:	435f5152 	cmpmi	pc, #-2147483628	; 0x80000014
     8ac:	626c6c61 	rsbvs	r6, ip, #24832	; 0x6100
     8b0:	006b6361 	rsbeq	r6, fp, r1, ror #6
     8b4:	5f515249 	svcpl	0x00515249
     8b8:	6b73614d 	blvs	1cd8df4 <_bss_end+0x1ccfb48>
     8bc:	64006465 	strvs	r6, [r0], #-1125	; 0xfffffb9b
     8c0:	79616c65 	stmdbvc	r1!, {r0, r2, r5, r6, sl, fp, sp, lr}^
     8c4:	756e7500 	strbvc	r7, [lr, #-1280]!	; 0xfffffb00
     8c8:	5f646573 	svcpl	0x00646573
     8cc:	6e750030 	mrcvs	0, 3, r0, cr5, cr0, {1}
     8d0:	64657375 	strbtvs	r7, [r5], #-885	; 0xfffffc8b
     8d4:	7500315f 	strvc	r3, [r0, #-351]	; 0xfffffea1
     8d8:	6573756e 	ldrbvs	r7, [r3, #-1390]!	; 0xfffffa92
     8dc:	00325f64 	eorseq	r5, r2, r4, ror #30
     8e0:	73756e75 	cmnvc	r5, #1872	; 0x750
     8e4:	335f6465 	cmpcc	pc, #1694498816	; 0x65000000
     8e8:	756e7500 	strbvc	r7, [lr, #-1280]!	; 0xfffffb00
     8ec:	5f646573 	svcpl	0x00646573
     8f0:	6f630034 	svcvs	0x00630034
     8f4:	65746e75 	ldrbvs	r6, [r4, #-3701]!	; 0xfffff18b
     8f8:	32335f72 	eorscc	r5, r3, #456	; 0x1c8
     8fc:	72500062 	subsvc	r0, r0, #98	; 0x62
     900:	61637365 	cmnvs	r3, r5, ror #6
     904:	5f72656c 	svcpl	0x0072656c
     908:	00363532 	eorseq	r3, r6, r2, lsr r5
     90c:	364e5a5f 			; <UNDEFINED> instruction: 0x364e5a5f
     910:	6d695443 	cfstrdvs	mvd5, [r9, #-268]!	; 0xfffffef4
     914:	45367265 	ldrmi	r7, [r6, #-613]!	; 0xfffffd9b
     918:	6c62616e 	stfvse	f6, [r2], #-440	; 0xfffffe48
     91c:	46504565 	ldrbmi	r4, [r0], -r5, ror #10
     920:	6a457676 	bvs	115e300 <_bss_end+0x1155054>
     924:	544e3631 	strbpl	r3, [lr], #-1585	; 0xfffff9cf
     928:	72656d69 	rsbvc	r6, r5, #6720	; 0x1a40
     92c:	6572505f 	ldrbvs	r5, [r2, #-95]!	; 0xffffffa1
     930:	6c616373 	stclvs	3, cr6, [r1], #-460	; 0xfffffe34
     934:	66007265 	strvs	r7, [r0], -r5, ror #4
     938:	5f656572 	svcpl	0x00656572
     93c:	6e6e7572 	mcrvs	5, 3, r7, cr14, cr2, {3}
     940:	5f676e69 	svcpl	0x00676e69
     944:	73657270 	cmnvc	r5, #112, 4
     948:	656c6163 	strbvs	r6, [ip, #-355]!	; 0xfffffe9d
     94c:	72500072 	subsvc	r0, r0, #114	; 0x72
     950:	61637365 	cmnvs	r3, r5, ror #6
     954:	5f72656c 	svcpl	0x0072656c
     958:	72660031 	rsbvc	r0, r6, #49	; 0x31
     95c:	725f6565 	subsvc	r6, pc, #423624704	; 0x19400000
     960:	696e6e75 	stmdbvs	lr!, {r0, r2, r4, r5, r6, r9, sl, fp, sp, lr}^
     964:	655f676e 	ldrbvs	r6, [pc, #-1902]	; 1fe <CPSR_IRQ_INHIBIT+0x17e>
     968:	6c62616e 	stfvse	f6, [r2], #-440	; 0xfffffe48
     96c:	52490065 	subpl	r0, r9, #101	; 0x65
     970:	6c435f51 	mcrrvs	15, 5, r5, r3, cr1
     974:	00726165 	rsbseq	r6, r2, r5, ror #2
     978:	73657250 	cmnvc	r5, #80, 4
     97c:	656c6163 	strbvs	r6, [ip, #-355]!	; 0xfffffe9d
     980:	36315f72 	shsub16cc	r5, r1, r2
     984:	69546d00 	ldmdbvs	r4, {r8, sl, fp, sp, lr}^
     988:	5f72656d 	svcpl	0x0072656d
     98c:	73676552 	cmnvc	r7, #343932928	; 0x14800000
     990:	6c615600 	stclvs	6, cr5, [r1], #-0
     994:	2f006575 	svccs	0x00006575
     998:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     99c:	6c69732f 	stclvs	3, cr7, [r9], #-188	; 0xffffff44
     9a0:	79766168 	ldmdbvc	r6!, {r3, r5, r6, r8, sp, lr}^
     9a4:	63532f6a 	cmpvs	r3, #424	; 0x1a8
     9a8:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; 810 <CPSR_IRQ_INHIBIT+0x790>
     9ac:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
     9b0:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
     9b4:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
     9b8:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
     9bc:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
     9c0:	69742d30 	ldmdbvs	r4!, {r4, r5, r8, sl, fp, sp}^
     9c4:	5f72656d 	svcpl	0x0072656d
     9c8:	5f646e61 	svcpl	0x00646e61
     9cc:	4f495047 	svcmi	0x00495047
     9d0:	746e695f 	strbtvc	r6, [lr], #-2399	; 0xfffff6a1
     9d4:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
     9d8:	6b2f7470 	blvs	bddba0 <_bss_end+0xbd48f4>
     9dc:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
     9e0:	72732f6c 	rsbsvc	r2, r3, #108, 30	; 0x1b0
     9e4:	72642f63 	rsbvc	r2, r4, #396	; 0x18c
     9e8:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
     9ec:	69742f73 	ldmdbvs	r4!, {r0, r1, r4, r5, r6, r8, r9, sl, fp, sp}^
     9f0:	2e72656d 	cdpcs	5, 7, cr6, cr2, cr13, {3}
     9f4:	00707063 	rsbseq	r7, r0, r3, rrx
     9f8:	65746e69 	ldrbvs	r6, [r4, #-3689]!	; 0xfffff197
     9fc:	70757272 	rsbsvc	r7, r5, r2, ror r2
     a00:	6e655f74 	mcrvs	15, 3, r5, cr5, cr4, {3}
     a04:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     a08:	69750064 	ldmdbvs	r5!, {r2, r5, r6}^
     a0c:	3631746e 	ldrtcc	r7, [r1], -lr, ror #8
     a10:	5000745f 	andpl	r7, r0, pc, asr r4
     a14:	445f6572 	ldrbmi	r6, [pc], #-1394	; a1c <CPSR_IRQ_INHIBIT+0x99c>
     a18:	64697669 	strbtvs	r7, [r9], #-1641	; 0xfffff997
     a1c:	54007265 	strpl	r7, [r0], #-613	; 0xfffffd9b
     a20:	72656d69 	rsbvc	r6, r5, #6720	; 0x1a40
     a24:	6765525f 			; <UNDEFINED> instruction: 0x6765525f
     a28:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     a2c:	69544336 	ldmdbvs	r4, {r1, r2, r4, r5, r8, r9, lr}^
     a30:	3772656d 	ldrbcc	r6, [r2, -sp, ror #10]!
     a34:	61736944 	cmnvs	r3, r4, asr #18
     a38:	45656c62 	strbmi	r6, [r5, #-3170]!	; 0xfffff39e
     a3c:	69740076 	ldmdbvs	r4!, {r1, r2, r4, r5, r6}^
     a40:	5f72656d 	svcpl	0x0072656d
     a44:	5f676572 	svcpl	0x00676572
     a48:	65736162 	ldrbvs	r6, [r3, #-354]!	; 0xfffffe9e
     a4c:	6d697400 	cfstrdvs	mvd7, [r9, #-0]
     a50:	655f7265 	ldrbvs	r7, [pc, #-613]	; 7f3 <CPSR_IRQ_INHIBIT+0x773>
     a54:	6c62616e 	stfvse	f6, [r2], #-440	; 0xfffffe48
     a58:	54006465 	strpl	r6, [r0], #-1125	; 0xfffffb9b
     a5c:	656d6954 	strbvs	r6, [sp, #-2388]!	; 0xfffff6ac
     a60:	74435f72 	strbvc	r5, [r3], #-3954	; 0xfffff08e
     a64:	6c465f6c 	mcrrvs	15, 6, r5, r6, cr12
     a68:	00736761 	rsbseq	r6, r3, r1, ror #14
     a6c:	64616f4c 	strbtvs	r6, [r1], #-3916	; 0xfffff0b4
     a70:	69544300 	ldmdbvs	r4, {r8, r9, lr}^
     a74:	0072656d 	rsbseq	r6, r2, sp, ror #10
     a78:	6c61436d 	stclvs	3, cr4, [r1], #-436	; 0xfffffe4c
     a7c:	6361626c 	cmnvs	r1, #108, 4	; 0xc0000006
     a80:	5a5f006b 	bpl	17c0c34 <_bss_end+0x17b7988>
     a84:	5443364e 	strbpl	r3, [r3], #-1614	; 0xfffff9b2
     a88:	72656d69 	rsbvc	r6, r5, #6720	; 0x1a40
     a8c:	67655234 			; <UNDEFINED> instruction: 0x67655234
     a90:	334e4573 	movtcc	r4, #58739	; 0xe573
     a94:	396c6168 	stmdbcc	ip!, {r3, r5, r6, r8, sp, lr}^
     a98:	656d6954 	strbvs	r6, [sp, #-2388]!	; 0xfffff6ac
     a9c:	65525f72 	ldrbvs	r5, [r2, #-3954]	; 0xfffff08e
     aa0:	5f004567 	svcpl	0x00004567
     aa4:	43364e5a 	teqmi	r6, #1440	; 0x5a0
     aa8:	656d6954 	strbvs	r6, [sp, #-2388]!	; 0xfffff6ac
     aac:	45344372 	ldrmi	r4, [r4, #-882]!	; 0xfffffc8e
     ab0:	7246006d 	subvc	r0, r6, #109	; 0x6d
     ab4:	525f6565 	subspl	r6, pc, #423624704	; 0x19400000
     ab8:	696e6e75 	stmdbvs	lr!, {r0, r2, r4, r5, r6, r9, sl, fp, sp, lr}^
     abc:	4900676e 	stmdbmi	r0, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}
     ac0:	69545f73 	ldmdbvs	r4, {r0, r1, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     ac4:	5f72656d 	svcpl	0x0072656d
     ac8:	5f515249 	svcpl	0x00515249
     acc:	646e6550 	strbtvs	r6, [lr], #-1360	; 0xfffffab0
     ad0:	00676e69 	rsbeq	r6, r7, r9, ror #28
     ad4:	6d695454 	cfstrdvs	mvd5, [r9, #-336]!	; 0xfffffeb0
     ad8:	435f7265 	cmpmi	pc, #1342177286	; 0x50000006
     adc:	626c6c61 	rsbvs	r6, ip, #24832	; 0x6100
     ae0:	006b6361 	rsbeq	r6, fp, r1, ror #6
     ae4:	5f515249 	svcpl	0x00515249
     ae8:	00776152 	rsbseq	r6, r7, r2, asr r1
     aec:	364e5a5f 			; <UNDEFINED> instruction: 0x364e5a5f
     af0:	6d695443 	cfstrdvs	mvd5, [r9, #-268]!	; 0xfffffef4
     af4:	32317265 	eorscc	r7, r1, #1342177286	; 0x50000006
     af8:	5f515249 	svcpl	0x00515249
     afc:	6c6c6143 	stfvse	f6, [ip], #-268	; 0xfffffef4
     b00:	6b636162 	blvs	18d9090 <_bss_end+0x18cfde4>
     b04:	63007645 	movwvs	r7, #1605	; 0x645
     b08:	626c6c61 	rsbvs	r6, ip, #24832	; 0x6100
     b0c:	006b6361 	rsbeq	r6, fp, r1, ror #6
     b10:	5f786469 	svcpl	0x00786469
     b14:	65736162 	ldrbvs	r6, [r3, #-354]!	; 0xfffffe9e
     b18:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     b1c:	49433132 	stmdbmi	r3, {r1, r4, r5, r8, ip, sp}^
     b20:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
     b24:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
     b28:	6e6f435f 	mcrvs	3, 3, r4, cr15, cr15, {2}
     b2c:	6c6f7274 	sfmvs	f7, 2, [pc], #-464	; 964 <CPSR_IRQ_INHIBIT+0x8e4>
     b30:	3472656c 	ldrbtcc	r6, [r2], #-1388	; 0xfffffa94
     b34:	73676552 	cmnvc	r7, #343932928	; 0x14800000
     b38:	68334e45 	ldmdavs	r3!, {r0, r2, r6, r9, sl, fp, lr}
     b3c:	34326c61 	ldrtcc	r6, [r2], #-3169	; 0xfffff39f
     b40:	65746e49 	ldrbvs	r6, [r4, #-3657]!	; 0xfffff1b7
     b44:	70757272 	rsbsvc	r7, r5, r2, ror r2
     b48:	6f435f74 	svcvs	0x00435f74
     b4c:	6f72746e 	svcvs	0x0072746e
     b50:	72656c6c 	rsbvc	r6, r5, #108, 24	; 0x6c00
     b54:	6765525f 			; <UNDEFINED> instruction: 0x6765525f
     b58:	50470045 	subpl	r0, r7, r5, asr #32
     b5c:	485f3155 	ldmdami	pc, {r0, r2, r4, r6, r8, ip, sp}^	; <UNPREDICTABLE>
     b60:	00746c61 	rsbseq	r6, r4, r1, ror #24
     b64:	6c69614d 	stfvse	f6, [r9], #-308	; 0xfffffecc
     b68:	00786f62 	rsbseq	r6, r8, r2, ror #30
     b6c:	62616e45 	rsbvs	r6, r1, #1104	; 0x450
     b70:	495f656c 	ldmdbmi	pc, {r2, r3, r5, r6, r8, sl, sp, lr}^	; <UNPREDICTABLE>
     b74:	5f005152 	svcpl	0x00005152
     b78:	31324e5a 	teqcc	r2, sl, asr lr
     b7c:	746e4943 	strbtvc	r4, [lr], #-2371	; 0xfffff6bd
     b80:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
     b84:	435f7470 	cmpmi	pc, #112, 8	; 0x70000000
     b88:	72746e6f 	rsbsvc	r6, r4, #1776	; 0x6f0
     b8c:	656c6c6f 	strbvs	r6, [ip, #-3183]!	; 0xfffff391
     b90:	45324372 	ldrmi	r4, [r2, #-882]!	; 0xfffffc8e
     b94:	5249006d 	subpl	r0, r9, #109	; 0x6d
     b98:	6e455f51 	mcrvs	15, 2, r5, cr5, cr1, {2}
     b9c:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     ba0:	4900315f 	stmdbmi	r0, {r0, r1, r2, r3, r4, r6, r8, ip, sp}
     ba4:	455f5152 	ldrbmi	r5, [pc, #-338]	; a5a <CPSR_IRQ_INHIBIT+0x9da>
     ba8:	6c62616e 	stfvse	f6, [r2], #-440	; 0xfffffe48
     bac:	00325f65 	eorseq	r5, r2, r5, ror #30
     bb0:	54524155 	ldrbpl	r4, [r2], #-341	; 0xfffffeab
     bb4:	746e4900 	strbtvc	r4, [lr], #-2304	; 0xfffff700
     bb8:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
     bbc:	435f7470 	cmpmi	pc, #112, 8	; 0x70000000
     bc0:	72746e6f 	rsbsvc	r6, r4, #1776	; 0x6f0
     bc4:	656c6c6f 	strbvs	r6, [ip, #-3183]!	; 0xfffff391
     bc8:	65525f72 	ldrbvs	r5, [r2, #-3954]	; 0xfffff08e
     bcc:	6c490067 	mcrrvs	0, 6, r0, r9, cr7
     bd0:	6167656c 	cmnvs	r7, ip, ror #10
     bd4:	63415f6c 	movtvs	r5, #8044	; 0x1f6c
     bd8:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     bdc:	4900315f 	stmdbmi	r0, {r0, r1, r2, r3, r4, r6, r8, ip, sp}
     be0:	67656c6c 	strbvs	r6, [r5, -ip, ror #24]!
     be4:	415f6c61 	cmpmi	pc, r1, ror #24
     be8:	73656363 	cmnvc	r5, #-1946157055	; 0x8c000001
     bec:	00325f73 	eorseq	r5, r2, r3, ror pc
     bf0:	5f515249 	svcpl	0x00515249
     bf4:	69736142 	ldmdbvs	r3!, {r1, r6, r8, sp, lr}^
     bf8:	6f535f63 	svcvs	0x00535f63
     bfc:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     c00:	6f682f00 	svcvs	0x00682f00
     c04:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
     c08:	61686c69 	cmnvs	r8, r9, ror #24
     c0c:	2f6a7976 	svccs	0x006a7976
     c10:	6f686353 	svcvs	0x00686353
     c14:	5a2f6c6f 	bpl	bdbdd8 <_bss_end+0xbd2b2c>
     c18:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; a8c <CPSR_IRQ_INHIBIT+0xa0c>
     c1c:	2f657461 	svccs	0x00657461
     c20:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
     c24:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
     c28:	2d30312f 	ldfcss	f3, [r0, #-188]!	; 0xffffff44
     c2c:	656d6974 	strbvs	r6, [sp, #-2420]!	; 0xfffff68c
     c30:	6e615f72 	mcrvs	15, 3, r5, cr1, cr2, {3}
     c34:	50475f64 	subpl	r5, r7, r4, ror #30
     c38:	695f4f49 	ldmdbvs	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     c3c:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
     c40:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
     c44:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
     c48:	2f6c656e 	svccs	0x006c656e
     c4c:	2f637273 	svccs	0x00637273
     c50:	65746e69 	ldrbvs	r6, [r4, #-3689]!	; 0xfffff197
     c54:	70757272 	rsbsvc	r7, r5, r2, ror r2
     c58:	6f635f74 	svcvs	0x00635f74
     c5c:	6f72746e 	svcvs	0x0072746e
     c60:	72656c6c 	rsbvc	r6, r5, #108, 24	; 0x6c00
     c64:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
     c68:	6e496d00 	cdpvs	13, 4, cr6, cr9, cr0, {0}
     c6c:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
     c70:	5f747075 	svcpl	0x00747075
     c74:	73676552 	cmnvc	r7, #343932928	; 0x14800000
     c78:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     c7c:	49433132 	stmdbmi	r3, {r1, r4, r5, r8, ip, sp}^
     c80:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
     c84:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
     c88:	6e6f435f 	mcrvs	3, 3, r4, cr15, cr15, {2}
     c8c:	6c6f7274 	sfmvs	f7, 2, [pc], #-464	; ac4 <CPSR_IRQ_INHIBIT+0xa44>
     c90:	3172656c 	cmncc	r2, ip, ror #10
     c94:	73694431 	cmnvc	r9, #822083584	; 0x31000000
     c98:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     c9c:	5152495f 	cmppl	r2, pc, asr r9
     ca0:	68334e45 	ldmdavs	r3!, {r0, r2, r6, r9, sl, fp, lr}
     ca4:	30316c61 	eorscc	r6, r1, r1, ror #24
     ca8:	5f515249 	svcpl	0x00515249
     cac:	72756f53 	rsbsvc	r6, r5, #332	; 0x14c
     cb0:	00456563 	subeq	r6, r5, r3, ror #10
     cb4:	74736166 	ldrbtvc	r6, [r3], #-358	; 0xfffffe9a
     cb8:	746e695f 	strbtvc	r6, [lr], #-2399	; 0xfffff6a1
     cbc:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
     cc0:	685f7470 	ldmdavs	pc, {r4, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
     cc4:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     cc8:	49007265 	stmdbmi	r0, {r0, r2, r5, r6, r9, ip, sp, lr}
     ccc:	425f5152 	subsmi	r5, pc, #-2147483628	; 0x80000014
     cd0:	63697361 	cmnvs	r9, #-2080374783	; 0x84000001
     cd4:	6e65505f 	mcrvs	0, 3, r5, cr5, cr15, {2}
     cd8:	676e6964 	strbvs	r6, [lr, -r4, ror #18]!
     cdc:	73694400 	cmnvc	r9, #0, 8
     ce0:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     ce4:	5152495f 	cmppl	r2, pc, asr r9
     ce8:	6e494300 	cdpvs	3, 4, cr4, cr9, cr0, {0}
     cec:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
     cf0:	5f747075 	svcpl	0x00747075
     cf4:	746e6f43 	strbtvc	r6, [lr], #-3907	; 0xfffff0bd
     cf8:	6c6c6f72 	stclvs	15, cr6, [ip], #-456	; 0xfffffe38
     cfc:	49007265 	stmdbmi	r0, {r0, r2, r5, r6, r9, ip, sp, lr}
     d00:	425f5152 	subsmi	r5, pc, #-2147483628	; 0x80000014
     d04:	63697361 	cmnvs	r9, #-2080374783	; 0x84000001
     d08:	7369445f 	cmnvc	r9, #1593835520	; 0x5f000000
     d0c:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     d10:	616e4500 	cmnvs	lr, r0, lsl #10
     d14:	5f656c62 	svcpl	0x00656c62
     d18:	69736142 	ldmdbvs	r3!, {r1, r6, r8, sp, lr}^
     d1c:	52495f63 	subpl	r5, r9, #396	; 0x18c
     d20:	5a5f0051 	bpl	17c0e6c <_bss_end+0x17b7bc0>
     d24:	4331324e 	teqmi	r1, #-536870908	; 0xe0000004
     d28:	65746e49 	ldrbvs	r6, [r4, #-3657]!	; 0xfffff1b7
     d2c:	70757272 	rsbsvc	r7, r5, r2, ror r2
     d30:	6f435f74 	svcvs	0x00435f74
     d34:	6f72746e 	svcvs	0x0072746e
     d38:	72656c6c 	rsbvc	r6, r5, #108, 24	; 0x6c00
     d3c:	69443731 	stmdbvs	r4, {r0, r4, r5, r8, r9, sl, ip, sp}^
     d40:	6c626173 	stfvse	f6, [r2], #-460	; 0xfffffe34
     d44:	61425f65 	cmpvs	r2, r5, ror #30
     d48:	5f636973 	svcpl	0x00636973
     d4c:	45515249 	ldrbmi	r5, [r1, #-585]	; 0xfffffdb7
     d50:	6168334e 	cmnvs	r8, lr, asr #6
     d54:	4936316c 	ldmdbmi	r6!, {r2, r3, r5, r6, r8, ip, sp}
     d58:	425f5152 	subsmi	r5, pc, #-2147483628	; 0x80000014
     d5c:	63697361 	cmnvs	r9, #-2080374783	; 0x84000001
     d60:	756f535f 	strbvc	r5, [pc, #-863]!	; a09 <CPSR_IRQ_INHIBIT+0x989>
     d64:	45656372 	strbmi	r6, [r5, #-882]!	; 0xfffffc8e
     d68:	6f6f4400 	svcvs	0x006f4400
     d6c:	6c656272 	sfmvs	f6, 2, [r5], #-456	; 0xfffffe38
     d70:	00305f6c 	eorseq	r5, r0, ip, ror #30
     d74:	726f6f44 	rsbvc	r6, pc, #68, 30	; 0x110
     d78:	6c6c6562 	cfstr64vs	mvdx6, [ip], #-392	; 0xfffffe78
     d7c:	4700315f 	smlsdmi	r0, pc, r1, r3	; <UNPREDICTABLE>
     d80:	5f305550 	svcpl	0x00305550
     d84:	746c6148 	strbtvc	r6, [ip], #-328	; 0xfffffeb8
     d88:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     d8c:	49433132 	stmdbmi	r3, {r1, r4, r5, r8, ip, sp}^
     d90:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
     d94:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
     d98:	6e6f435f 	mcrvs	3, 3, r4, cr15, cr15, {2}
     d9c:	6c6f7274 	sfmvs	f7, 2, [pc], #-464	; bd4 <CPSR_IRQ_INHIBIT+0xb54>
     da0:	3172656c 	cmncc	r2, ip, ror #10
     da4:	616e4530 	cmnvs	lr, r0, lsr r5
     da8:	5f656c62 	svcpl	0x00656c62
     dac:	45515249 	ldrbmi	r5, [r1, #-585]	; 0xfffffdb7
     db0:	6168334e 	cmnvs	r8, lr, asr #6
     db4:	4930316c 	ldmdbmi	r0!, {r2, r3, r5, r6, r8, ip, sp}
     db8:	535f5152 	cmppl	pc, #-2147483628	; 0x80000014
     dbc:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     dc0:	70004565 	andvc	r4, r0, r5, ror #10
     dc4:	345f6e69 	ldrbcc	r6, [pc], #-3689	; dcc <CPSR_IRQ_INHIBIT+0xd4c>
     dc8:	74735f38 	ldrbtvc	r5, [r3], #-3896	; 0xfffff0c8
     dcc:	00657461 	rsbeq	r7, r5, r1, ror #8
     dd0:	324e5a5f 	subcc	r5, lr, #389120	; 0x5f000
     dd4:	6e494331 	mcrvs	3, 2, r4, cr9, cr1, {1}
     dd8:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
     ddc:	5f747075 	svcpl	0x00747075
     de0:	746e6f43 	strbtvc	r6, [lr], #-3907	; 0xfffff0bd
     de4:	6c6c6f72 	stclvs	15, cr6, [ip], #-456	; 0xfffffe38
     de8:	36317265 	ldrtcc	r7, [r1], -r5, ror #4
     dec:	62616e45 	rsbvs	r6, r1, #1104	; 0x450
     df0:	425f656c 	subsmi	r6, pc, #108, 10	; 0x1b000000
     df4:	63697361 	cmnvs	r9, #-2080374783	; 0x84000001
     df8:	5152495f 	cmppl	r2, pc, asr r9
     dfc:	68334e45 	ldmdavs	r3!, {r0, r2, r6, r9, sl, fp, lr}
     e00:	36316c61 	ldrtcc	r6, [r1], -r1, ror #24
     e04:	5f515249 	svcpl	0x00515249
     e08:	69736142 	ldmdbvs	r3!, {r1, r6, r8, sp, lr}^
     e0c:	6f535f63 	svcvs	0x00535f63
     e10:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     e14:	5a5f0045 	bpl	17c0f30 <_bss_end+0x17b7c84>
     e18:	4331324e 	teqmi	r1, #-536870908	; 0xe0000004
     e1c:	65746e49 	ldrbvs	r6, [r4, #-3657]!	; 0xfffff1b7
     e20:	70757272 	rsbsvc	r7, r5, r2, ror r2
     e24:	6f435f74 	svcvs	0x00435f74
     e28:	6f72746e 	svcvs	0x0072746e
     e2c:	72656c6c 	rsbvc	r6, r5, #108, 24	; 0x6c00
     e30:	6d453443 	cfstrdvs	mvd3, [r5, #-268]	; 0xfffffef4
     e34:	43324900 	teqmi	r2, #0, 18
     e38:	4950535f 	ldmdbmi	r0, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     e3c:	414c535f 	cmpmi	ip, pc, asr r3
     e40:	495f4556 	ldmdbmi	pc, {r1, r2, r4, r6, r8, sl, lr}^	; <UNPREDICTABLE>
     e44:	0054494e 	subseq	r4, r4, lr, asr #18
     e48:	5f514946 	svcpl	0x00514946
     e4c:	746e6f43 	strbtvc	r6, [lr], #-3907	; 0xfffff0bd
     e50:	006c6f72 	rsbeq	r6, ip, r2, ror pc
     e54:	5f717269 	svcpl	0x00717269
     e58:	646e6168 	strbtvs	r6, [lr], #-360	; 0xfffffe98
     e5c:	0072656c 	rsbseq	r6, r2, ip, ror #10
     e60:	4f4c475f 	svcmi	0x004c475f
     e64:	5f4c4142 	svcpl	0x004c4142
     e68:	6275735f 	rsbsvs	r7, r5, #2080374785	; 0x7c000001
     e6c:	735f495f 	cmpvc	pc, #1556480	; 0x17c000
     e70:	7774666f 	ldrbvc	r6, [r4, -pc, ror #12]!
     e74:	5f657261 	svcpl	0x00657261
     e78:	65746e69 	ldrbvs	r6, [r4, #-3689]!	; 0xfffff197
     e7c:	70757272 	rsbsvc	r7, r5, r2, ror r2
     e80:	61685f74 	smcvs	34292	; 0x85f4
     e84:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     e88:	52490072 	subpl	r0, r9, #114	; 0x72
     e8c:	61425f51 	cmpvs	r2, r1, asr pc
     e90:	5f636973 	svcpl	0x00636973
     e94:	62616e45 	rsbvs	r6, r1, #1104	; 0x450
     e98:	4900656c 	stmdbmi	r0, {r2, r3, r5, r6, r8, sl, sp, lr}
     e9c:	505f5152 	subspl	r5, pc, r2, asr r1	; <UNPREDICTABLE>
     ea0:	69646e65 	stmdbvs	r4!, {r0, r2, r5, r6, r9, sl, fp, sp, lr}^
     ea4:	315f676e 	cmpcc	pc, lr, ror #14
     ea8:	51524900 	cmppl	r2, r0, lsl #18
     eac:	756f535f 	strbvc	r5, [pc, #-863]!	; b55 <CPSR_IRQ_INHIBIT+0xad5>
     eb0:	00656372 	rsbeq	r6, r5, r2, ror r3
     eb4:	746e4973 	strbtvc	r4, [lr], #-2419	; 0xfffff68d
     eb8:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
     ebc:	74437470 	strbvc	r7, [r3], #-1136	; 0xfffffb90
     ec0:	5249006c 	subpl	r0, r9, #108	; 0x6c
     ec4:	65505f51 	ldrbvs	r5, [r0, #-3921]	; 0xfffff0af
     ec8:	6e69646e 	cdpvs	4, 6, cr6, cr9, cr14, {3}
     ecc:	00325f67 	eorseq	r5, r2, r7, ror #30
     ed0:	4f495047 	svcmi	0x00495047
     ed4:	4700305f 	smlsdmi	r0, pc, r0, r3	; <UNPREDICTABLE>
     ed8:	5f4f4950 	svcpl	0x004f4950
     edc:	50470031 	subpl	r0, r7, r1, lsr r0
     ee0:	325f4f49 	subscc	r4, pc, #292	; 0x124
     ee4:	49504700 	ldmdbmi	r0, {r8, r9, sl, lr}^
     ee8:	00335f4f 	eorseq	r5, r3, pc, asr #30
     eec:	61736944 	cmnvs	r3, r4, asr #18
     ef0:	5f656c62 	svcpl	0x00656c62
     ef4:	69736142 	ldmdbvs	r3!, {r1, r6, r8, sp, lr}^
     ef8:	52495f63 	subpl	r5, r9, #396	; 0x18c
     efc:	6f730051 	svcvs	0x00730051
     f00:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     f04:	7864695f 	stmdavc	r4!, {r0, r1, r2, r3, r4, r6, r8, fp, sp, lr}^
     f08:	51524900 	cmppl	r2, r0, lsl #18
     f0c:	7369445f 	cmnvc	r9, #1593835520	; 0x5f000000
     f10:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     f14:	4900315f 	stmdbmi	r0, {r0, r1, r2, r3, r4, r6, r8, ip, sp}
     f18:	445f5152 	ldrbmi	r5, [pc], #-338	; f20 <CPSR_IRQ_INHIBIT+0xea0>
     f1c:	62617369 	rsbvs	r7, r1, #-1543503871	; 0xa4000001
     f20:	325f656c 	subscc	r6, pc, #108, 10	; 0x1b000000
     f24:	41575000 	cmpmi	r7, r0
     f28:	5000305f 	andpl	r3, r0, pc, asr r0
     f2c:	315f4157 	cmpcc	pc, r7, asr r1	; <UNPREDICTABLE>
     f30:	44454c00 	strbmi	r4, [r5], #-3072	; 0xfffff400
     f34:	6174535f 	cmnvs	r4, pc, asr r3
     f38:	41006574 	tstmi	r0, r4, ror r5
     f3c:	4c5f5443 	cfldrdmi	mvd5, [pc], {67}	; 0x43
     f40:	425f4445 	subsmi	r4, pc, #1157627904	; 0x45000000
     f44:	6b6e696c 	blvs	1b9b4fc <_bss_end+0x1b92250>
     f48:	2f007265 	svccs	0x00007265
     f4c:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     f50:	6c69732f 	stclvs	3, cr7, [r9], #-188	; 0xffffff44
     f54:	79766168 	ldmdbvc	r6!, {r3, r5, r6, r8, sp, lr}^
     f58:	63532f6a 	cmpvs	r3, #424	; 0x1a8
     f5c:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; dc4 <CPSR_IRQ_INHIBIT+0xd44>
     f60:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
     f64:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
     f68:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
     f6c:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
     f70:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
     f74:	69742d30 	ldmdbvs	r4!, {r4, r5, r8, sl, fp, sp}^
     f78:	5f72656d 	svcpl	0x0072656d
     f7c:	5f646e61 	svcpl	0x00646e61
     f80:	4f495047 	svcmi	0x00495047
     f84:	746e695f 	strbtvc	r6, [lr], #-2399	; 0xfffff6a1
     f88:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
     f8c:	6b2f7470 	blvs	bde154 <_bss_end+0xbd4ea8>
     f90:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
     f94:	72732f6c 	rsbsvc	r2, r3, #108, 30	; 0x1b0
     f98:	616d2f63 	cmnvs	sp, r3, ror #30
     f9c:	632e6e69 			; <UNDEFINED> instruction: 0x632e6e69
     fa0:	5f007070 	svcpl	0x00007070
     fa4:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
     fa8:	6d5f6c65 	ldclvs	12, cr6, [pc, #-404]	; e1c <CPSR_IRQ_INHIBIT+0xd9c>
     fac:	006e6961 	rsbeq	r6, lr, r1, ror #18
     fb0:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; efc <CPSR_IRQ_INHIBIT+0xe7c>
     fb4:	69732f65 	ldmdbvs	r3!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
     fb8:	7661686c 	strbtvc	r6, [r1], -ip, ror #16
     fbc:	532f6a79 			; <UNDEFINED> instruction: 0x532f6a79
     fc0:	6f6f6863 	svcvs	0x006f6863
     fc4:	655a2f6c 	ldrbvs	r2, [sl, #-3948]	; 0xfffff094
     fc8:	614d6f72 	hvcvs	55026	; 0xd6f2
     fcc:	652f6574 	strvs	r6, [pc, #-1396]!	; a60 <CPSR_IRQ_INHIBIT+0x9e0>
     fd0:	706d6178 	rsbvc	r6, sp, r8, ror r1
     fd4:	2f73656c 	svccs	0x0073656c
     fd8:	742d3031 	strtvc	r3, [sp], #-49	; 0xffffffcf
     fdc:	72656d69 	rsbvc	r6, r5, #6720	; 0x1a40
     fe0:	646e615f 	strbtvs	r6, [lr], #-351	; 0xfffffea1
     fe4:	4950475f 	ldmdbmi	r0, {r0, r1, r2, r3, r4, r6, r8, r9, sl, lr}^
     fe8:	6e695f4f 	cdpvs	15, 6, cr5, cr9, cr15, {2}
     fec:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
     ff0:	2f747075 	svccs	0x00747075
     ff4:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
     ff8:	732f6c65 			; <UNDEFINED> instruction: 0x732f6c65
     ffc:	732f6372 			; <UNDEFINED> instruction: 0x732f6372
    1000:	74726174 	ldrbtvc	r6, [r2], #-372	; 0xfffffe8c
    1004:	4700732e 	strmi	r7, [r0, -lr, lsr #6]
    1008:	4120554e 			; <UNDEFINED> instruction: 0x4120554e
    100c:	2e322053 	mrccs	0, 1, r2, cr2, cr3, {2}
    1010:	5f003433 	svcpl	0x00003433
    1014:	4f54445f 	svcmi	0x0054445f
    1018:	494c5f52 	stmdbmi	ip, {r1, r4, r6, r8, r9, sl, fp, ip, lr}^
    101c:	5f5f5453 	svcpl	0x005f5453
    1020:	73625f00 	cmnvc	r2, #0, 30
    1024:	74735f73 	ldrbtvc	r5, [r3], #-3955	; 0xfffff08d
    1028:	00747261 	rsbseq	r7, r4, r1, ror #4
    102c:	54435f5f 	strbpl	r5, [r3], #-3935	; 0xfffff0a1
    1030:	455f524f 	ldrbmi	r5, [pc, #-591]	; de9 <CPSR_IRQ_INHIBIT+0xd69>
    1034:	5f5f444e 	svcpl	0x005f444e
    1038:	435f5f00 	cmpmi	pc, #0, 30
    103c:	5f524f54 	svcpl	0x00524f54
    1040:	5453494c 	ldrbpl	r4, [r3], #-2380	; 0xfffff6b4
    1044:	5f005f5f 	svcpl	0x00005f5f
    1048:	4f54445f 	svcmi	0x0054445f
    104c:	4e455f52 	mcrmi	15, 2, r5, cr5, cr2, {2}
    1050:	005f5f44 	subseq	r5, pc, r4, asr #30
    1054:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; fa0 <CPSR_IRQ_INHIBIT+0xf20>
    1058:	69732f65 	ldmdbvs	r3!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
    105c:	7661686c 	strbtvc	r6, [r1], -ip, ror #16
    1060:	532f6a79 			; <UNDEFINED> instruction: 0x532f6a79
    1064:	6f6f6863 	svcvs	0x006f6863
    1068:	655a2f6c 	ldrbvs	r2, [sl, #-3948]	; 0xfffff094
    106c:	614d6f72 	hvcvs	55026	; 0xd6f2
    1070:	652f6574 	strvs	r6, [pc, #-1396]!	; b04 <CPSR_IRQ_INHIBIT+0xa84>
    1074:	706d6178 	rsbvc	r6, sp, r8, ror r1
    1078:	2f73656c 	svccs	0x0073656c
    107c:	742d3031 	strtvc	r3, [sp], #-49	; 0xffffffcf
    1080:	72656d69 	rsbvc	r6, r5, #6720	; 0x1a40
    1084:	646e615f 	strbtvs	r6, [lr], #-351	; 0xfffffea1
    1088:	4950475f 	ldmdbmi	r0, {r0, r1, r2, r3, r4, r6, r8, r9, sl, lr}^
    108c:	6e695f4f 	cdpvs	15, 6, cr5, cr9, cr15, {2}
    1090:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
    1094:	2f747075 	svccs	0x00747075
    1098:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
    109c:	732f6c65 			; <UNDEFINED> instruction: 0x732f6c65
    10a0:	732f6372 			; <UNDEFINED> instruction: 0x732f6372
    10a4:	74726174 	ldrbtvc	r6, [r2], #-372	; 0xfffffe8c
    10a8:	632e7075 			; <UNDEFINED> instruction: 0x632e7075
    10ac:	5f007070 	svcpl	0x00007070
    10b0:	5f707063 	svcpl	0x00707063
    10b4:	74756873 	ldrbtvc	r6, [r5], #-2163	; 0xfffff78d
    10b8:	6e776f64 	cdpvs	15, 7, cr6, cr7, cr4, {3}
    10bc:	73625f00 	cmnvc	r2, #0, 30
    10c0:	6e655f73 	mcrvs	15, 3, r5, cr5, cr3, {3}
    10c4:	74640064 	strbtvc	r0, [r4], #-100	; 0xffffff9c
    10c8:	705f726f 	subsvc	r7, pc, pc, ror #4
    10cc:	63007274 	movwvs	r7, #628	; 0x274
    10d0:	5f726f74 	svcpl	0x00726f74
    10d4:	00727470 	rsbseq	r7, r2, r0, ror r4
    10d8:	735f635f 	cmpvc	pc, #2080374785	; 0x7c000001
    10dc:	74726174 	ldrbtvc	r6, [r2], #-372	; 0xfffffe8c
    10e0:	5f007075 	svcpl	0x00007075
    10e4:	5f707063 	svcpl	0x00707063
    10e8:	72617473 	rsbvc	r7, r1, #1929379840	; 0x73000000
    10ec:	00707574 	rsbseq	r7, r0, r4, ror r5
    10f0:	74706e66 	ldrbtvc	r6, [r0], #-3686	; 0xfffff19a
    10f4:	41540072 	cmpmi	r4, r2, ror r0
    10f8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    10fc:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1100:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1104:	61786574 	cmnvs	r8, r4, ror r5
    1108:	6f633731 	svcvs	0x00633731
    110c:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1110:	69003761 	stmdbvs	r0, {r0, r5, r6, r8, r9, sl, ip, sp}
    1114:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1118:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    111c:	62645f70 	rsbvs	r5, r4, #112, 30	; 0x1c0
    1120:	7261006c 	rsbvc	r0, r1, #108	; 0x6c
    1124:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    1128:	695f6863 	ldmdbvs	pc, {r0, r1, r5, r6, fp, sp, lr}^	; <UNPREDICTABLE>
    112c:	786d6d77 	stmdavc	sp!, {r0, r1, r2, r4, r5, r6, r8, sl, fp, sp, lr}^
    1130:	41540074 	cmpmi	r4, r4, ror r0
    1134:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1138:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    113c:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1140:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    1144:	41003332 	tstmi	r0, r2, lsr r3
    1148:	455f4d52 	ldrbmi	r4, [pc, #-3410]	; 3fe <CPSR_IRQ_INHIBIT+0x37e>
    114c:	41540051 	cmpmi	r4, r1, asr r0
    1150:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1154:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1158:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    115c:	36353131 			; <UNDEFINED> instruction: 0x36353131
    1160:	73663274 	cmnvc	r6, #116, 4	; 0x40000007
    1164:	61736900 	cmnvs	r3, r0, lsl #18
    1168:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    116c:	7568745f 	strbvc	r7, [r8, #-1119]!	; 0xfffffba1
    1170:	5400626d 	strpl	r6, [r0], #-621	; 0xfffffd93
    1174:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1178:	50435f54 	subpl	r5, r3, r4, asr pc
    117c:	6f635f55 	svcvs	0x00635f55
    1180:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1184:	63373561 	teqvs	r7, #406847488	; 0x18400000
    1188:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    118c:	33356178 	teqcc	r5, #120, 2
    1190:	53414200 	movtpl	r4, #4608	; 0x1200
    1194:	52415f45 	subpl	r5, r1, #276	; 0x114
    1198:	385f4843 	ldmdacc	pc, {r0, r1, r6, fp, lr}^	; <UNPREDICTABLE>
    119c:	41425f4d 	cmpmi	r2, sp, asr #30
    11a0:	54004553 	strpl	r4, [r0], #-1363	; 0xfffffaad
    11a4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    11a8:	50435f54 	subpl	r5, r3, r4, asr pc
    11ac:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    11b0:	3031386d 	eorscc	r3, r1, sp, ror #16
    11b4:	52415400 	subpl	r5, r1, #0, 8
    11b8:	5f544547 	svcpl	0x00544547
    11bc:	5f555043 	svcpl	0x00555043
    11c0:	6e656778 	mcrvs	7, 3, r6, cr5, cr8, {3}
    11c4:	41003165 	tstmi	r0, r5, ror #2
    11c8:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    11cc:	415f5343 	cmpmi	pc, r3, asr #6
    11d0:	53435041 	movtpl	r5, #12353	; 0x3041
    11d4:	4d57495f 	vldrmi.16	s9, [r7, #-190]	; 0xffffff42	; <UNPREDICTABLE>
    11d8:	0054584d 	subseq	r5, r4, sp, asr #16
    11dc:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    11e0:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    11e4:	00305f48 	eorseq	r5, r0, r8, asr #30
    11e8:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    11ec:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    11f0:	00325f48 	eorseq	r5, r2, r8, asr #30
    11f4:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    11f8:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    11fc:	00335f48 	eorseq	r5, r3, r8, asr #30
    1200:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1204:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1208:	00345f48 	eorseq	r5, r4, r8, asr #30
    120c:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1210:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1214:	00365f48 	eorseq	r5, r6, r8, asr #30
    1218:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    121c:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1220:	00375f48 	eorseq	r5, r7, r8, asr #30
    1224:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1228:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    122c:	785f5550 	ldmdavc	pc, {r4, r6, r8, sl, ip, lr}^	; <UNPREDICTABLE>
    1230:	6c616373 	stclvs	3, cr6, [r1], #-460	; 0xfffffe34
    1234:	73690065 	cmnvc	r9, #101	; 0x65
    1238:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    123c:	72705f74 	rsbsvc	r5, r0, #116, 30	; 0x1d0
    1240:	65726465 	ldrbvs	r6, [r2, #-1125]!	; 0xfffffb9b
    1244:	41540073 	cmpmi	r4, r3, ror r0
    1248:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    124c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1250:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1254:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    1258:	54003333 	strpl	r3, [r0], #-819	; 0xfffffccd
    125c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1260:	50435f54 	subpl	r5, r3, r4, asr pc
    1264:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1268:	6474376d 	ldrbtvs	r3, [r4], #-1901	; 0xfffff893
    126c:	6900696d 	stmdbvs	r0, {r0, r2, r3, r5, r6, r8, fp, sp, lr}
    1270:	6e5f6173 	mrcvs	1, 2, r6, cr15, cr3, {3}
    1274:	7469626f 	strbtvc	r6, [r9], #-623	; 0xfffffd91
    1278:	52415400 	subpl	r5, r1, #0, 8
    127c:	5f544547 	svcpl	0x00544547
    1280:	5f555043 	svcpl	0x00555043
    1284:	316d7261 	cmncc	sp, r1, ror #4
    1288:	6a363731 	bvs	d8ef54 <_bss_end+0xd85ca8>
    128c:	0073667a 	rsbseq	r6, r3, sl, ror r6
    1290:	5f617369 	svcpl	0x00617369
    1294:	5f746962 	svcpl	0x00746962
    1298:	76706676 			; <UNDEFINED> instruction: 0x76706676
    129c:	52410032 	subpl	r0, r1, #50	; 0x32
    12a0:	43505f4d 	cmpmi	r0, #308	; 0x134
    12a4:	4e555f53 	mrcmi	15, 2, r5, cr5, cr3, {2}
    12a8:	574f4e4b 	strbpl	r4, [pc, -fp, asr #28]
    12ac:	4154004e 	cmpmi	r4, lr, asr #32
    12b0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    12b4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    12b8:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    12bc:	42006539 	andmi	r6, r0, #239075328	; 0xe400000
    12c0:	5f455341 	svcpl	0x00455341
    12c4:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    12c8:	4554355f 	ldrbmi	r3, [r4, #-1375]	; 0xfffffaa1
    12cc:	7261004a 	rsbvc	r0, r1, #74	; 0x4a
    12d0:	63635f6d 	cmnvs	r3, #436	; 0x1b4
    12d4:	5f6d7366 	svcpl	0x006d7366
    12d8:	74617473 	strbtvc	r7, [r1], #-1139	; 0xfffffb8d
    12dc:	72610065 	rsbvc	r0, r1, #101	; 0x65
    12e0:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    12e4:	74356863 	ldrtvc	r6, [r5], #-2147	; 0xfffff79d
    12e8:	6e750065 	cdpvs	0, 7, cr0, cr5, cr5, {3}
    12ec:	63657073 	cmnvs	r5, #115	; 0x73
    12f0:	7274735f 	rsbsvc	r7, r4, #2080374785	; 0x7c000001
    12f4:	73676e69 	cmnvc	r7, #1680	; 0x690
    12f8:	61736900 	cmnvs	r3, r0, lsl #18
    12fc:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1300:	6365735f 	cmnvs	r5, #2080374785	; 0x7c000001
    1304:	635f5f00 	cmpvs	pc, #0, 30
    1308:	745f7a6c 	ldrbvc	r7, [pc], #-2668	; 1310 <CPSR_IRQ_INHIBIT+0x1290>
    130c:	41006261 	tstmi	r0, r1, ror #4
    1310:	565f4d52 			; <UNDEFINED> instruction: 0x565f4d52
    1314:	72610043 	rsbvc	r0, r1, #67	; 0x43
    1318:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    131c:	785f6863 	ldmdavc	pc, {r0, r1, r5, r6, fp, sp, lr}^	; <UNPREDICTABLE>
    1320:	6c616373 	stclvs	3, cr6, [r1], #-460	; 0xfffffe34
    1324:	52410065 	subpl	r0, r1, #101	; 0x65
    1328:	454c5f4d 	strbmi	r5, [ip, #-3917]	; 0xfffff0b3
    132c:	4d524100 	ldfmie	f4, [r2, #-0]
    1330:	0053565f 	subseq	r5, r3, pc, asr r6
    1334:	5f4d5241 	svcpl	0x004d5241
    1338:	61004547 	tstvs	r0, r7, asr #10
    133c:	745f6d72 	ldrbvc	r6, [pc], #-3442	; 1344 <CPSR_IRQ_INHIBIT+0x12c4>
    1340:	5f656e75 	svcpl	0x00656e75
    1344:	6f727473 	svcvs	0x00727473
    1348:	7261676e 	rsbvc	r6, r1, #28835840	; 0x1b80000
    134c:	6f63006d 	svcvs	0x0063006d
    1350:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
    1354:	6c662078 	stclvs	0, cr2, [r6], #-480	; 0xfffffe20
    1358:	0074616f 	rsbseq	r6, r4, pc, ror #2
    135c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1360:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1364:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1368:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    136c:	35316178 	ldrcc	r6, [r1, #-376]!	; 0xfffffe88
    1370:	52415400 	subpl	r5, r1, #0, 8
    1374:	5f544547 	svcpl	0x00544547
    1378:	5f555043 	svcpl	0x00555043
    137c:	32376166 	eorscc	r6, r7, #-2147483623	; 0x80000019
    1380:	00657436 	rsbeq	r7, r5, r6, lsr r4
    1384:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1388:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    138c:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1390:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1394:	37316178 			; <UNDEFINED> instruction: 0x37316178
    1398:	4d524100 	ldfmie	f4, [r2, #-0]
    139c:	0054475f 	subseq	r4, r4, pc, asr r7
    13a0:	47524154 			; <UNDEFINED> instruction: 0x47524154
    13a4:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    13a8:	6e5f5550 	mrcvs	5, 2, r5, cr15, cr0, {2}
    13ac:	65766f65 	ldrbvs	r6, [r6, #-3941]!	; 0xfffff09b
    13b0:	6e657372 	mcrvs	3, 3, r7, cr5, cr2, {3}
    13b4:	2e2e0031 	mcrcs	0, 1, r0, cr14, cr1, {1}
    13b8:	2f2e2e2f 	svccs	0x002e2e2f
    13bc:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    13c0:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    13c4:	2f2e2e2f 	svccs	0x002e2e2f
    13c8:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    13cc:	6c2f6363 	stcvs	3, cr6, [pc], #-396	; 1248 <CPSR_IRQ_INHIBIT+0x11c8>
    13d0:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    13d4:	632e3263 			; <UNDEFINED> instruction: 0x632e3263
    13d8:	52415400 	subpl	r5, r1, #0, 8
    13dc:	5f544547 	svcpl	0x00544547
    13e0:	5f555043 	svcpl	0x00555043
    13e4:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    13e8:	34727865 	ldrbtcc	r7, [r2], #-2149	; 0xfffff79b
    13ec:	41420066 	cmpmi	r2, r6, rrx
    13f0:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    13f4:	5f484352 	svcpl	0x00484352
    13f8:	004d4537 	subeq	r4, sp, r7, lsr r5
    13fc:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1400:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1404:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1408:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    140c:	32316178 	eorscc	r6, r1, #120, 2
    1410:	73616800 	cmnvc	r1, #0, 16
    1414:	6c617668 	stclvs	6, cr7, [r1], #-416	; 0xfffffe60
    1418:	4200745f 	andmi	r7, r0, #1593835520	; 0x5f000000
    141c:	5f455341 	svcpl	0x00455341
    1420:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1424:	5a4b365f 	bpl	12ceda8 <_bss_end+0x12c5afc>
    1428:	61736900 	cmnvs	r3, r0, lsl #18
    142c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1430:	72610073 	rsbvc	r0, r1, #115	; 0x73
    1434:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    1438:	615f6863 	cmpvs	pc, r3, ror #16
    143c:	685f6d72 	ldmdavs	pc, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^	; <UNPREDICTABLE>
    1440:	76696477 			; <UNDEFINED> instruction: 0x76696477
    1444:	6d726100 	ldfvse	f6, [r2, #-0]
    1448:	7570665f 	ldrbvc	r6, [r0, #-1631]!	; 0xfffff9a1
    144c:	7365645f 	cmnvc	r5, #1593835520	; 0x5f000000
    1450:	73690063 	cmnvc	r9, #99	; 0x63
    1454:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1458:	70665f74 	rsbvc	r5, r6, r4, ror pc
    145c:	47003631 	smladxmi	r0, r1, r6, r3
    1460:	4320554e 			; <UNDEFINED> instruction: 0x4320554e
    1464:	39203731 	stmdbcc	r0!, {r0, r4, r5, r8, r9, sl, ip, sp}
    1468:	312e322e 			; <UNDEFINED> instruction: 0x312e322e
    146c:	31303220 	teqcc	r0, r0, lsr #4
    1470:	32303139 	eorscc	r3, r0, #1073741838	; 0x4000000e
    1474:	72282035 	eorvc	r2, r8, #53	; 0x35
    1478:	61656c65 	cmnvs	r5, r5, ror #24
    147c:	20296573 	eorcs	r6, r9, r3, ror r5
    1480:	4d52415b 	ldfmie	f4, [r2, #-364]	; 0xfffffe94
    1484:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
    1488:	622d392d 	eorvs	r3, sp, #737280	; 0xb4000
    148c:	636e6172 	cmnvs	lr, #-2147483620	; 0x8000001c
    1490:	65722068 	ldrbvs	r2, [r2, #-104]!	; 0xffffff98
    1494:	69736976 	ldmdbvs	r3!, {r1, r2, r4, r5, r6, r8, fp, sp, lr}^
    1498:	32206e6f 	eorcc	r6, r0, #1776	; 0x6f0
    149c:	39353737 	ldmdbcc	r5!, {r0, r1, r2, r4, r5, r8, r9, sl, ip, sp}
    14a0:	2d205d39 	stccs	13, cr5, [r0, #-228]!	; 0xffffff1c
    14a4:	6d72616d 	ldfvse	f6, [r2, #-436]!	; 0xfffffe4c
    14a8:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
    14ac:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
    14b0:	6962612d 	stmdbvs	r2!, {r0, r2, r3, r5, r8, sp, lr}^
    14b4:	7261683d 	rsbvc	r6, r1, #3997696	; 0x3d0000
    14b8:	6d2d2064 	stcvs	0, cr2, [sp, #-400]!	; 0xfffffe70
    14bc:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    14c0:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
    14c4:	65743576 	ldrbvs	r3, [r4, #-1398]!	; 0xfffffa8a
    14c8:	2070662b 	rsbscs	r6, r0, fp, lsr #12
    14cc:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
    14d0:	672d2067 	strvs	r2, [sp, -r7, rrx]!
    14d4:	324f2d20 	subcc	r2, pc, #32, 26	; 0x800
    14d8:	324f2d20 	subcc	r2, pc, #32, 26	; 0x800
    14dc:	324f2d20 	subcc	r2, pc, #32, 26	; 0x800
    14e0:	62662d20 	rsbvs	r2, r6, #32, 26	; 0x800
    14e4:	646c6975 	strbtvs	r6, [ip], #-2421	; 0xfffff68b
    14e8:	2d676e69 	stclcs	14, cr6, [r7, #-420]!	; 0xfffffe5c
    14ec:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    14f0:	2d206363 	stccs	3, cr6, [r0, #-396]!	; 0xfffffe74
    14f4:	2d6f6e66 	stclcs	14, cr6, [pc, #-408]!	; 1364 <CPSR_IRQ_INHIBIT+0x12e4>
    14f8:	63617473 	cmnvs	r1, #1929379840	; 0x73000000
    14fc:	72702d6b 	rsbsvc	r2, r0, #6848	; 0x1ac0
    1500:	6365746f 	cmnvs	r5, #1862270976	; 0x6f000000
    1504:	20726f74 	rsbscs	r6, r2, r4, ror pc
    1508:	6f6e662d 	svcvs	0x006e662d
    150c:	6c6e692d 			; <UNDEFINED> instruction: 0x6c6e692d
    1510:	20656e69 	rsbcs	r6, r5, r9, ror #28
    1514:	6976662d 	ldmdbvs	r6!, {r0, r2, r3, r5, r9, sl, sp, lr}^
    1518:	69626973 	stmdbvs	r2!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
    151c:	7974696c 	ldmdbvc	r4!, {r2, r3, r5, r6, r8, fp, sp, lr}^
    1520:	6469683d 	strbtvs	r6, [r9], #-2109	; 0xfffff7c3
    1524:	006e6564 	rsbeq	r6, lr, r4, ror #10
    1528:	5f4d5241 	svcpl	0x004d5241
    152c:	69004948 	stmdbvs	r0, {r3, r6, r8, fp, lr}
    1530:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1534:	615f7469 	cmpvs	pc, r9, ror #8
    1538:	00766964 	rsbseq	r6, r6, r4, ror #18
    153c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1540:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1544:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1548:	31316d72 	teqcc	r1, r2, ror sp
    154c:	736a3633 	cmnvc	sl, #53477376	; 0x3300000
    1550:	52415400 	subpl	r5, r1, #0, 8
    1554:	5f544547 	svcpl	0x00544547
    1558:	5f555043 	svcpl	0x00555043
    155c:	386d7261 	stmdacc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    1560:	52415400 	subpl	r5, r1, #0, 8
    1564:	5f544547 	svcpl	0x00544547
    1568:	5f555043 	svcpl	0x00555043
    156c:	396d7261 	stmdbcc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    1570:	52415400 	subpl	r5, r1, #0, 8
    1574:	5f544547 	svcpl	0x00544547
    1578:	5f555043 	svcpl	0x00555043
    157c:	32366166 	eorscc	r6, r6, #-2147483623	; 0x80000019
    1580:	6f6c0036 	svcvs	0x006c0036
    1584:	6c20676e 	stcvs	7, cr6, [r0], #-440	; 0xfffffe48
    1588:	20676e6f 	rsbcs	r6, r7, pc, ror #28
    158c:	69736e75 	ldmdbvs	r3!, {r0, r2, r4, r5, r6, r9, sl, fp, sp, lr}^
    1590:	64656e67 	strbtvs	r6, [r5], #-3687	; 0xfffff199
    1594:	746e6920 	strbtvc	r6, [lr], #-2336	; 0xfffff6e0
    1598:	6d726100 	ldfvse	f6, [r2, #-0]
    159c:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    15a0:	6d635f68 	stclvs	15, cr5, [r3, #-416]!	; 0xfffffe60
    15a4:	54006573 	strpl	r6, [r0], #-1395	; 0xfffffa8d
    15a8:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    15ac:	50435f54 	subpl	r5, r3, r4, asr pc
    15b0:	6f635f55 	svcvs	0x00635f55
    15b4:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    15b8:	5400346d 	strpl	r3, [r0], #-1133	; 0xfffffb93
    15bc:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    15c0:	50435f54 	subpl	r5, r3, r4, asr pc
    15c4:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    15c8:	6530316d 	ldrvs	r3, [r0, #-365]!	; 0xfffffe93
    15cc:	52415400 	subpl	r5, r1, #0, 8
    15d0:	5f544547 	svcpl	0x00544547
    15d4:	5f555043 	svcpl	0x00555043
    15d8:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    15dc:	376d7865 	strbcc	r7, [sp, -r5, ror #16]!
    15e0:	6d726100 	ldfvse	f6, [r2, #-0]
    15e4:	6e6f635f 	mcrvs	3, 3, r6, cr15, cr15, {2}
    15e8:	6f635f64 	svcvs	0x00635f64
    15ec:	41006564 	tstmi	r0, r4, ror #10
    15f0:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    15f4:	415f5343 	cmpmi	pc, r3, asr #6
    15f8:	53435041 	movtpl	r5, #12353	; 0x3041
    15fc:	61736900 	cmnvs	r3, r0, lsl #18
    1600:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1604:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1608:	325f3876 	subscc	r3, pc, #7733248	; 0x760000
    160c:	53414200 	movtpl	r4, #4608	; 0x1200
    1610:	52415f45 	subpl	r5, r1, #276	; 0x114
    1614:	335f4843 	cmpcc	pc, #4390912	; 0x430000
    1618:	4154004d 	cmpmi	r4, sp, asr #32
    161c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1620:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1624:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1628:	74303137 	ldrtvc	r3, [r0], #-311	; 0xfffffec9
    162c:	6d726100 	ldfvse	f6, [r2, #-0]
    1630:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1634:	77695f68 	strbvc	r5, [r9, -r8, ror #30]!
    1638:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
    163c:	73690032 	cmnvc	r9, #50	; 0x32
    1640:	756e5f61 	strbvc	r5, [lr, #-3937]!	; 0xfffff09f
    1644:	69625f6d 	stmdbvs	r2!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
    1648:	54007374 	strpl	r7, [r0], #-884	; 0xfffffc8c
    164c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1650:	50435f54 	subpl	r5, r3, r4, asr pc
    1654:	6f635f55 	svcvs	0x00635f55
    1658:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    165c:	6c70306d 	ldclvs	0, cr3, [r0], #-436	; 0xfffffe4c
    1660:	6d737375 	ldclvs	3, cr7, [r3, #-468]!	; 0xfffffe2c
    1664:	6d6c6c61 	stclvs	12, cr6, [ip, #-388]!	; 0xfffffe7c
    1668:	69746c75 	ldmdbvs	r4!, {r0, r2, r4, r5, r6, sl, fp, sp, lr}^
    166c:	00796c70 	rsbseq	r6, r9, r0, ror ip
    1670:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1674:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1678:	655f5550 	ldrbvs	r5, [pc, #-1360]	; 1130 <CPSR_IRQ_INHIBIT+0x10b0>
    167c:	6f6e7978 	svcvs	0x006e7978
    1680:	00316d73 	eorseq	r6, r1, r3, ror sp
    1684:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1688:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    168c:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1690:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1694:	32357278 	eorscc	r7, r5, #120, 4	; 0x80000007
    1698:	61736900 	cmnvs	r3, r0, lsl #18
    169c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    16a0:	6964745f 	stmdbvs	r4!, {r0, r1, r2, r3, r4, r6, sl, ip, sp, lr}^
    16a4:	72700076 	rsbsvc	r0, r0, #118	; 0x76
    16a8:	72656665 	rsbvc	r6, r5, #105906176	; 0x6500000
    16ac:	6f656e5f 	svcvs	0x00656e5f
    16b0:	6f665f6e 	svcvs	0x00665f6e
    16b4:	34365f72 	ldrtcc	r5, [r6], #-3954	; 0xfffff08e
    16b8:	73746962 	cmnvc	r4, #1605632	; 0x188000
    16bc:	61736900 	cmnvs	r3, r0, lsl #18
    16c0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    16c4:	3170665f 	cmncc	r0, pc, asr r6
    16c8:	6c6d6636 	stclvs	6, cr6, [sp], #-216	; 0xffffff28
    16cc:	52415400 	subpl	r5, r1, #0, 8
    16d0:	5f544547 	svcpl	0x00544547
    16d4:	5f555043 	svcpl	0x00555043
    16d8:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    16dc:	33617865 	cmncc	r1, #6619136	; 0x650000
    16e0:	41540032 	cmpmi	r4, r2, lsr r0
    16e4:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    16e8:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    16ec:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    16f0:	61786574 	cmnvs	r8, r4, ror r5
    16f4:	69003533 	stmdbvs	r0, {r0, r1, r4, r5, r8, sl, ip, sp}
    16f8:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    16fc:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    1700:	63363170 	teqvs	r6, #112, 2
    1704:	00766e6f 	rsbseq	r6, r6, pc, ror #28
    1708:	70736e75 	rsbsvc	r6, r3, r5, ror lr
    170c:	5f766365 	svcpl	0x00766365
    1710:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
    1714:	0073676e 	rsbseq	r6, r3, lr, ror #14
    1718:	47524154 			; <UNDEFINED> instruction: 0x47524154
    171c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1720:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1724:	31316d72 	teqcc	r1, r2, ror sp
    1728:	32743635 	rsbscc	r3, r4, #55574528	; 0x3500000
    172c:	41540073 	cmpmi	r4, r3, ror r0
    1730:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1734:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1738:	3661665f 			; <UNDEFINED> instruction: 0x3661665f
    173c:	65743630 	ldrbvs	r3, [r4, #-1584]!	; 0xfffff9d0
    1740:	52415400 	subpl	r5, r1, #0, 8
    1744:	5f544547 	svcpl	0x00544547
    1748:	5f555043 	svcpl	0x00555043
    174c:	396d7261 	stmdbcc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    1750:	6a653632 	bvs	194f020 <_bss_end+0x1945d74>
    1754:	41420073 	hvcmi	8195	; 0x2003
    1758:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    175c:	5f484352 	svcpl	0x00484352
    1760:	69005434 	stmdbvs	r0, {r2, r4, r5, sl, ip, lr}
    1764:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1768:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    176c:	74707972 	ldrbtvc	r7, [r0], #-2418	; 0xfffff68e
    1770:	7261006f 	rsbvc	r0, r1, #111	; 0x6f
    1774:	65725f6d 	ldrbvs	r5, [r2, #-3949]!	; 0xfffff093
    1778:	695f7367 	ldmdbvs	pc, {r0, r1, r2, r5, r6, r8, r9, ip, sp, lr}^	; <UNPREDICTABLE>
    177c:	65735f6e 	ldrbvs	r5, [r3, #-3950]!	; 0xfffff092
    1780:	6e657571 	mcrvs	5, 3, r7, cr5, cr1, {3}
    1784:	69006563 	stmdbvs	r0, {r0, r1, r5, r6, r8, sl, sp, lr}
    1788:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    178c:	735f7469 	cmpvc	pc, #1761607680	; 0x69000000
    1790:	41420062 	cmpmi	r2, r2, rrx
    1794:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1798:	5f484352 	svcpl	0x00484352
    179c:	00455435 	subeq	r5, r5, r5, lsr r4
    17a0:	5f617369 	svcpl	0x00617369
    17a4:	74616566 	strbtvc	r6, [r1], #-1382	; 0xfffffa9a
    17a8:	00657275 	rsbeq	r7, r5, r5, ror r2
    17ac:	5f617369 	svcpl	0x00617369
    17b0:	5f746962 	svcpl	0x00746962
    17b4:	6c616d73 	stclvs	13, cr6, [r1], #-460	; 0xfffffe34
    17b8:	6c756d6c 	ldclvs	13, cr6, [r5], #-432	; 0xfffffe50
    17bc:	6d726100 	ldfvse	f6, [r2, #-0]
    17c0:	6e616c5f 	mcrvs	12, 3, r6, cr1, cr15, {2}
    17c4:	756f5f67 	strbvc	r5, [pc, #-3943]!	; 865 <CPSR_IRQ_INHIBIT+0x7e5>
    17c8:	74757074 	ldrbtvc	r7, [r5], #-116	; 0xffffff8c
    17cc:	6a626f5f 	bvs	189d550 <_bss_end+0x18942a4>
    17d0:	5f746365 	svcpl	0x00746365
    17d4:	72747461 	rsbsvc	r7, r4, #1627389952	; 0x61000000
    17d8:	74756269 	ldrbtvc	r6, [r5], #-617	; 0xfffffd97
    17dc:	685f7365 	ldmdavs	pc, {r0, r2, r5, r6, r8, r9, ip, sp, lr}^	; <UNPREDICTABLE>
    17e0:	006b6f6f 	rsbeq	r6, fp, pc, ror #30
    17e4:	5f617369 	svcpl	0x00617369
    17e8:	5f746962 	svcpl	0x00746962
    17ec:	645f7066 	ldrbvs	r7, [pc], #-102	; 17f4 <CPSR_IRQ_INHIBIT+0x1774>
    17f0:	41003233 	tstmi	r0, r3, lsr r2
    17f4:	4e5f4d52 	mrcmi	13, 2, r4, cr15, cr2, {2}
    17f8:	73690045 	cmnvc	r9, #69	; 0x45
    17fc:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1800:	65625f74 	strbvs	r5, [r2, #-3956]!	; 0xfffff08c
    1804:	41540038 	cmpmi	r4, r8, lsr r0
    1808:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    180c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1810:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1814:	36373131 			; <UNDEFINED> instruction: 0x36373131
    1818:	00737a6a 	rsbseq	r7, r3, sl, ror #20
    181c:	636f7270 	cmnvs	pc, #112, 4
    1820:	6f737365 	svcvs	0x00737365
    1824:	79745f72 	ldmdbvc	r4!, {r1, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    1828:	61006570 	tstvs	r0, r0, ror r5
    182c:	665f6c6c 	ldrbvs	r6, [pc], -ip, ror #24
    1830:	00737570 	rsbseq	r7, r3, r0, ror r5
    1834:	5f6d7261 	svcpl	0x006d7261
    1838:	00736370 	rsbseq	r6, r3, r0, ror r3
    183c:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1840:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1844:	54355f48 	ldrtpl	r5, [r5], #-3912	; 0xfffff0b8
    1848:	6d726100 	ldfvse	f6, [r2, #-0]
    184c:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1850:	00743468 	rsbseq	r3, r4, r8, ror #8
    1854:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1858:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    185c:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1860:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1864:	36376178 			; <UNDEFINED> instruction: 0x36376178
    1868:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    186c:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    1870:	72610035 	rsbvc	r0, r1, #53	; 0x35
    1874:	75745f6d 	ldrbvc	r5, [r4, #-3949]!	; 0xfffff093
    1878:	775f656e 	ldrbvc	r6, [pc, -lr, ror #10]
    187c:	00667562 	rsbeq	r7, r6, r2, ror #10
    1880:	62617468 	rsbvs	r7, r1, #104, 8	; 0x68000000
    1884:	7361685f 	cmnvc	r1, #6225920	; 0x5f0000
    1888:	73690068 	cmnvc	r9, #104	; 0x68
    188c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1890:	75715f74 	ldrbvc	r5, [r1, #-3956]!	; 0xfffff08c
    1894:	5f6b7269 	svcpl	0x006b7269
    1898:	765f6f6e 	ldrbvc	r6, [pc], -lr, ror #30
    189c:	74616c6f 	strbtvc	r6, [r1], #-3183	; 0xfffff391
    18a0:	5f656c69 	svcpl	0x00656c69
    18a4:	54006563 	strpl	r6, [r0], #-1379	; 0xfffffa9d
    18a8:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    18ac:	50435f54 	subpl	r5, r3, r4, asr pc
    18b0:	6f635f55 	svcvs	0x00635f55
    18b4:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    18b8:	5400306d 	strpl	r3, [r0], #-109	; 0xffffff93
    18bc:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    18c0:	50435f54 	subpl	r5, r3, r4, asr pc
    18c4:	6f635f55 	svcvs	0x00635f55
    18c8:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    18cc:	5400316d 	strpl	r3, [r0], #-365	; 0xfffffe93
    18d0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    18d4:	50435f54 	subpl	r5, r3, r4, asr pc
    18d8:	6f635f55 	svcvs	0x00635f55
    18dc:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    18e0:	6900336d 	stmdbvs	r0, {r0, r2, r3, r5, r6, r8, r9, ip, sp}
    18e4:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    18e8:	615f7469 	cmpvs	pc, r9, ror #8
    18ec:	38766d72 	ldmdacc	r6!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^
    18f0:	6100315f 	tstvs	r0, pc, asr r1
    18f4:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    18f8:	5f686372 	svcpl	0x00686372
    18fc:	656d616e 	strbvs	r6, [sp, #-366]!	; 0xfffffe92
    1900:	61736900 	cmnvs	r3, r0, lsl #18
    1904:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1908:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    190c:	335f3876 	cmpcc	pc, #7733248	; 0x760000
    1910:	61736900 	cmnvs	r3, r0, lsl #18
    1914:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1918:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    191c:	345f3876 	ldrbcc	r3, [pc], #-2166	; 1924 <CPSR_IRQ_INHIBIT+0x18a4>
    1920:	61736900 	cmnvs	r3, r0, lsl #18
    1924:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1928:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    192c:	355f3876 	ldrbcc	r3, [pc, #-2166]	; 10be <CPSR_IRQ_INHIBIT+0x103e>
    1930:	52415400 	subpl	r5, r1, #0, 8
    1934:	5f544547 	svcpl	0x00544547
    1938:	5f555043 	svcpl	0x00555043
    193c:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1940:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    1944:	41540033 	cmpmi	r4, r3, lsr r0
    1948:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    194c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1950:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1954:	61786574 	cmnvs	r8, r4, ror r5
    1958:	54003535 	strpl	r3, [r0], #-1333	; 0xfffffacb
    195c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1960:	50435f54 	subpl	r5, r3, r4, asr pc
    1964:	6f635f55 	svcvs	0x00635f55
    1968:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    196c:	00373561 	eorseq	r3, r7, r1, ror #10
    1970:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1974:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1978:	6d5f5550 	cfldr64vs	mvdx5, [pc, #-320]	; 1840 <CPSR_IRQ_INHIBIT+0x17c0>
    197c:	726f6370 	rsbvc	r6, pc, #112, 6	; 0xc0000001
    1980:	41540065 	cmpmi	r4, r5, rrx
    1984:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1988:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    198c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1990:	6e6f6e5f 	mcrvs	14, 3, r6, cr15, cr15, {2}
    1994:	72610065 	rsbvc	r0, r1, #101	; 0x65
    1998:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    199c:	6e5f6863 	cdpvs	8, 5, cr6, cr15, cr3, {3}
    19a0:	006d746f 	rsbeq	r7, sp, pc, ror #8
    19a4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    19a8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    19ac:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    19b0:	30316d72 	eorscc	r6, r1, r2, ror sp
    19b4:	6a653632 	bvs	194f284 <_bss_end+0x1945fd8>
    19b8:	41420073 	hvcmi	8195	; 0x2003
    19bc:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    19c0:	5f484352 	svcpl	0x00484352
    19c4:	42004a36 	andmi	r4, r0, #221184	; 0x36000
    19c8:	5f455341 	svcpl	0x00455341
    19cc:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    19d0:	004b365f 	subeq	r3, fp, pc, asr r6
    19d4:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    19d8:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    19dc:	4d365f48 	ldcmi	15, cr5, [r6, #-288]!	; 0xfffffee0
    19e0:	61736900 	cmnvs	r3, r0, lsl #18
    19e4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    19e8:	6d77695f 			; <UNDEFINED> instruction: 0x6d77695f
    19ec:	0074786d 	rsbseq	r7, r4, sp, ror #16
    19f0:	47524154 			; <UNDEFINED> instruction: 0x47524154
    19f4:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    19f8:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    19fc:	31316d72 	teqcc	r1, r2, ror sp
    1a00:	666a3633 			; <UNDEFINED> instruction: 0x666a3633
    1a04:	52410073 	subpl	r0, r1, #115	; 0x73
    1a08:	534c5f4d 	movtpl	r5, #53069	; 0xcf4d
    1a0c:	4d524100 	ldfmie	f4, [r2, #-0]
    1a10:	00544c5f 	subseq	r4, r4, pc, asr ip
    1a14:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1a18:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1a1c:	5a365f48 	bpl	d99744 <_bss_end+0xd90498>
    1a20:	52415400 	subpl	r5, r1, #0, 8
    1a24:	5f544547 	svcpl	0x00544547
    1a28:	5f555043 	svcpl	0x00555043
    1a2c:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1a30:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    1a34:	726f6335 	rsbvc	r6, pc, #-738197504	; 0xd4000000
    1a38:	61786574 	cmnvs	r8, r4, ror r5
    1a3c:	41003535 	tstmi	r0, r5, lsr r5
    1a40:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    1a44:	415f5343 	cmpmi	pc, r3, asr #6
    1a48:	53435041 	movtpl	r5, #12353	; 0x3041
    1a4c:	5046565f 	subpl	r5, r6, pc, asr r6
    1a50:	52415400 	subpl	r5, r1, #0, 8
    1a54:	5f544547 	svcpl	0x00544547
    1a58:	5f555043 	svcpl	0x00555043
    1a5c:	6d6d7769 	stclvs	7, cr7, [sp, #-420]!	; 0xfffffe5c
    1a60:	00327478 	eorseq	r7, r2, r8, ror r4
    1a64:	5f617369 	svcpl	0x00617369
    1a68:	5f746962 	svcpl	0x00746962
    1a6c:	6e6f656e 	cdpvs	5, 6, cr6, cr15, cr14, {3}
    1a70:	6d726100 	ldfvse	f6, [r2, #-0]
    1a74:	7570665f 	ldrbvc	r6, [r0, #-1631]!	; 0xfffff9a1
    1a78:	7474615f 	ldrbtvc	r6, [r4], #-351	; 0xfffffea1
    1a7c:	73690072 	cmnvc	r9, #114	; 0x72
    1a80:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1a84:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1a88:	6537766d 	ldrvs	r7, [r7, #-1645]!	; 0xfffff993
    1a8c:	4154006d 	cmpmi	r4, sp, rrx
    1a90:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1a94:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1a98:	3661665f 			; <UNDEFINED> instruction: 0x3661665f
    1a9c:	65743632 	ldrbvs	r3, [r4, #-1586]!	; 0xfffff9ce
    1aa0:	52415400 	subpl	r5, r1, #0, 8
    1aa4:	5f544547 	svcpl	0x00544547
    1aa8:	5f555043 	svcpl	0x00555043
    1aac:	7672616d 	ldrbtvc	r6, [r2], -sp, ror #2
    1ab0:	5f6c6c65 	svcpl	0x006c6c65
    1ab4:	00346a70 	eorseq	r6, r4, r0, ror sl
    1ab8:	62617468 	rsbvs	r7, r1, #104, 8	; 0x68000000
    1abc:	7361685f 	cmnvc	r1, #6225920	; 0x5f0000
    1ac0:	6f705f68 	svcvs	0x00705f68
    1ac4:	65746e69 	ldrbvs	r6, [r4, #-3689]!	; 0xfffff197
    1ac8:	72610072 	rsbvc	r0, r1, #114	; 0x72
    1acc:	75745f6d 	ldrbvc	r5, [r4, #-3949]!	; 0xfffff093
    1ad0:	635f656e 	cmpvs	pc, #461373440	; 0x1b800000
    1ad4:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1ad8:	39615f78 	stmdbcc	r1!, {r3, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    1adc:	61736900 	cmnvs	r3, r0, lsl #18
    1ae0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1ae4:	6d77695f 			; <UNDEFINED> instruction: 0x6d77695f
    1ae8:	3274786d 	rsbscc	r7, r4, #7143424	; 0x6d0000
    1aec:	52415400 	subpl	r5, r1, #0, 8
    1af0:	5f544547 	svcpl	0x00544547
    1af4:	5f555043 	svcpl	0x00555043
    1af8:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1afc:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    1b00:	726f6332 	rsbvc	r6, pc, #-939524096	; 0xc8000000
    1b04:	61786574 	cmnvs	r8, r4, ror r5
    1b08:	69003335 	stmdbvs	r0, {r0, r2, r4, r5, r8, r9, ip, sp}
    1b0c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1b10:	745f7469 	ldrbvc	r7, [pc], #-1129	; 1b18 <CPSR_IRQ_INHIBIT+0x1a98>
    1b14:	626d7568 	rsbvs	r7, sp, #104, 10	; 0x1a000000
    1b18:	41420032 	cmpmi	r2, r2, lsr r0
    1b1c:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1b20:	5f484352 	svcpl	0x00484352
    1b24:	69004137 	stmdbvs	r0, {r0, r1, r2, r4, r5, r8, lr}
    1b28:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1b2c:	645f7469 	ldrbvs	r7, [pc], #-1129	; 1b34 <CPSR_IRQ_INHIBIT+0x1ab4>
    1b30:	7270746f 	rsbsvc	r7, r0, #1862270976	; 0x6f000000
    1b34:	6100646f 	tstvs	r0, pc, ror #8
    1b38:	665f6d72 			; <UNDEFINED> instruction: 0x665f6d72
    1b3c:	5f363170 	svcpl	0x00363170
    1b40:	65707974 	ldrbvs	r7, [r0, #-2420]!	; 0xfffff68c
    1b44:	646f6e5f 	strbtvs	r6, [pc], #-3679	; 1b4c <CPSR_IRQ_INHIBIT+0x1acc>
    1b48:	52410065 	subpl	r0, r1, #101	; 0x65
    1b4c:	494d5f4d 	stmdbmi	sp, {r0, r2, r3, r6, r8, r9, sl, fp, ip, lr}^
    1b50:	6d726100 	ldfvse	f6, [r2, #-0]
    1b54:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1b58:	006b3668 	rsbeq	r3, fp, r8, ror #12
    1b5c:	5f6d7261 	svcpl	0x006d7261
    1b60:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1b64:	42006d36 	andmi	r6, r0, #3456	; 0xd80
    1b68:	5f455341 	svcpl	0x00455341
    1b6c:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1b70:	0052375f 	subseq	r3, r2, pc, asr r7
    1b74:	6f705f5f 	svcvs	0x00705f5f
    1b78:	756f6370 	strbvc	r6, [pc, #-880]!	; 1810 <CPSR_IRQ_INHIBIT+0x1790>
    1b7c:	745f746e 	ldrbvc	r7, [pc], #-1134	; 1b84 <CPSR_IRQ_INHIBIT+0x1b04>
    1b80:	2f006261 	svccs	0x00006261
    1b84:	6c697562 	cfstr64vs	mvdx7, [r9], #-392	; 0xfffffe78
    1b88:	63672f64 	cmnvs	r7, #100, 30	; 0x190
    1b8c:	72612d63 	rsbvc	r2, r1, #6336	; 0x18c0
    1b90:	6f6e2d6d 	svcvs	0x006e2d6d
    1b94:	652d656e 	strvs	r6, [sp, #-1390]!	; 0xfffffa92
    1b98:	2d696261 	sfmcs	f6, 2, [r9, #-388]!	; 0xfffffe7c
    1b9c:	6b396c47 	blvs	e5ccc0 <_bss_end+0xe53a14>
    1ba0:	672f3954 			; <UNDEFINED> instruction: 0x672f3954
    1ba4:	612d6363 			; <UNDEFINED> instruction: 0x612d6363
    1ba8:	6e2d6d72 	mcrvs	13, 1, r6, cr13, cr2, {3}
    1bac:	2d656e6f 	stclcs	14, cr6, [r5, #-444]!	; 0xfffffe44
    1bb0:	69626165 	stmdbvs	r2!, {r0, r2, r5, r6, r8, sp, lr}^
    1bb4:	322d392d 	eorcc	r3, sp, #737280	; 0xb4000
    1bb8:	2d393130 	ldfcss	f3, [r9, #-192]!	; 0xffffff40
    1bbc:	622f3471 	eorvs	r3, pc, #1895825408	; 0x71000000
    1bc0:	646c6975 	strbtvs	r6, [ip], #-2421	; 0xfffff68b
    1bc4:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
    1bc8:	6e6f6e2d 	cdpvs	14, 6, cr6, cr15, cr13, {1}
    1bcc:	61652d65 	cmnvs	r5, r5, ror #26
    1bd0:	612f6962 			; <UNDEFINED> instruction: 0x612f6962
    1bd4:	762f6d72 			; <UNDEFINED> instruction: 0x762f6d72
    1bd8:	2f657435 	svccs	0x00657435
    1bdc:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
    1be0:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    1be4:	00636367 	rsbeq	r6, r3, r7, ror #6
    1be8:	5f617369 	svcpl	0x00617369
    1bec:	5f746962 	svcpl	0x00746962
    1bf0:	65736d63 	ldrbvs	r6, [r3, #-3427]!	; 0xfffff29d
    1bf4:	52415400 	subpl	r5, r1, #0, 8
    1bf8:	5f544547 	svcpl	0x00544547
    1bfc:	5f555043 	svcpl	0x00555043
    1c00:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1c04:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    1c08:	41540033 	cmpmi	r4, r3, lsr r0
    1c0c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1c10:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1c14:	6e65675f 	mcrvs	7, 3, r6, cr5, cr15, {2}
    1c18:	63697265 	cmnvs	r9, #1342177286	; 0x50000006
    1c1c:	00613776 	rsbeq	r3, r1, r6, ror r7
    1c20:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1c24:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1c28:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1c2c:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1c30:	36376178 			; <UNDEFINED> instruction: 0x36376178
    1c34:	6d726100 	ldfvse	f6, [r2, #-0]
    1c38:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1c3c:	6f6e5f68 	svcvs	0x006e5f68
    1c40:	6c6f765f 	stclvs	6, cr7, [pc], #-380	; 1acc <CPSR_IRQ_INHIBIT+0x1a4c>
    1c44:	6c697461 	cfstrdvs	mvd7, [r9], #-388	; 0xfffffe7c
    1c48:	65635f65 	strbvs	r5, [r3, #-3941]!	; 0xfffff09b
    1c4c:	53414200 	movtpl	r4, #4608	; 0x1200
    1c50:	52415f45 	subpl	r5, r1, #276	; 0x114
    1c54:	385f4843 	ldmdacc	pc, {r0, r1, r6, fp, lr}^	; <UNPREDICTABLE>
    1c58:	73690041 	cmnvc	r9, #65	; 0x41
    1c5c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1c60:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1c64:	7435766d 	ldrtvc	r7, [r5], #-1645	; 0xfffff993
    1c68:	53414200 	movtpl	r4, #4608	; 0x1200
    1c6c:	52415f45 	subpl	r5, r1, #276	; 0x114
    1c70:	385f4843 	ldmdacc	pc, {r0, r1, r6, fp, lr}^	; <UNPREDICTABLE>
    1c74:	41540052 	cmpmi	r4, r2, asr r0
    1c78:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1c7c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1c80:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1c84:	61786574 	cmnvs	r8, r4, ror r5
    1c88:	6f633337 	svcvs	0x00633337
    1c8c:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1c90:	00353361 	eorseq	r3, r5, r1, ror #6
    1c94:	5f4d5241 	svcpl	0x004d5241
    1c98:	6100564e 	tstvs	r0, lr, asr #12
    1c9c:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1ca0:	34686372 	strbtcc	r6, [r8], #-882	; 0xfffffc8e
    1ca4:	6d726100 	ldfvse	f6, [r2, #-0]
    1ca8:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1cac:	61003668 	tstvs	r0, r8, ror #12
    1cb0:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1cb4:	37686372 			; <UNDEFINED> instruction: 0x37686372
    1cb8:	6d726100 	ldfvse	f6, [r2, #-0]
    1cbc:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1cc0:	6c003868 	stcvs	8, cr3, [r0], {104}	; 0x68
    1cc4:	20676e6f 	rsbcs	r6, r7, pc, ror #28
    1cc8:	62756f64 	rsbsvs	r6, r5, #100, 30	; 0x190
    1ccc:	6100656c 	tstvs	r0, ip, ror #10
    1cd0:	745f6d72 	ldrbvc	r6, [pc], #-3442	; 1cd8 <CPSR_IRQ_INHIBIT+0x1c58>
    1cd4:	5f656e75 	svcpl	0x00656e75
    1cd8:	61637378 	smcvs	14136	; 0x3738
    1cdc:	6d00656c 	cfstr32vs	mvfx6, [r0, #-432]	; 0xfffffe50
    1ce0:	6e696b61 	vnmulvs.f64	d22, d9, d17
    1ce4:	6f635f67 	svcvs	0x00635f67
    1ce8:	5f74736e 	svcpl	0x0074736e
    1cec:	6c626174 	stfvse	f6, [r2], #-464	; 0xfffffe30
    1cf0:	68740065 	ldmdavs	r4!, {r0, r2, r5, r6}^
    1cf4:	5f626d75 	svcpl	0x00626d75
    1cf8:	6c6c6163 	stfvse	f6, [ip], #-396	; 0xfffffe74
    1cfc:	6169765f 	cmnvs	r9, pc, asr r6
    1d00:	62616c5f 	rsbvs	r6, r1, #24320	; 0x5f00
    1d04:	69006c65 	stmdbvs	r0, {r0, r2, r5, r6, sl, fp, sp, lr}
    1d08:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1d0c:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    1d10:	00357670 	eorseq	r7, r5, r0, ror r6
    1d14:	5f617369 	svcpl	0x00617369
    1d18:	5f746962 	svcpl	0x00746962
    1d1c:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1d20:	54006b36 	strpl	r6, [r0], #-2870	; 0xfffff4ca
    1d24:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1d28:	50435f54 	subpl	r5, r3, r4, asr pc
    1d2c:	6f635f55 	svcvs	0x00635f55
    1d30:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1d34:	54003761 	strpl	r3, [r0], #-1889	; 0xfffff89f
    1d38:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1d3c:	50435f54 	subpl	r5, r3, r4, asr pc
    1d40:	6f635f55 	svcvs	0x00635f55
    1d44:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1d48:	54003861 	strpl	r3, [r0], #-2145	; 0xfffff79f
    1d4c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1d50:	50435f54 	subpl	r5, r3, r4, asr pc
    1d54:	6f635f55 	svcvs	0x00635f55
    1d58:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1d5c:	41003961 	tstmi	r0, r1, ror #18
    1d60:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    1d64:	415f5343 	cmpmi	pc, r3, asr #6
    1d68:	00534350 	subseq	r4, r3, r0, asr r3
    1d6c:	5f4d5241 	svcpl	0x004d5241
    1d70:	5f534350 	svcpl	0x00534350
    1d74:	43505441 	cmpmi	r0, #1090519040	; 0x41000000
    1d78:	6f630053 	svcvs	0x00630053
    1d7c:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
    1d80:	6f642078 	svcvs	0x00642078
    1d84:	656c6275 	strbvs	r6, [ip, #-629]!	; 0xfffffd8b
    1d88:	52415400 	subpl	r5, r1, #0, 8
    1d8c:	5f544547 	svcpl	0x00544547
    1d90:	5f555043 	svcpl	0x00555043
    1d94:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1d98:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    1d9c:	726f6333 	rsbvc	r6, pc, #-872415232	; 0xcc000000
    1da0:	61786574 	cmnvs	r8, r4, ror r5
    1da4:	54003335 	strpl	r3, [r0], #-821	; 0xfffffccb
    1da8:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1dac:	50435f54 	subpl	r5, r3, r4, asr pc
    1db0:	6f635f55 	svcvs	0x00635f55
    1db4:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1db8:	6c70306d 	ldclvs	0, cr3, [r0], #-436	; 0xfffffe4c
    1dbc:	61007375 	tstvs	r0, r5, ror r3
    1dc0:	635f6d72 	cmpvs	pc, #7296	; 0x1c80
    1dc4:	73690063 	cmnvc	r9, #99	; 0x63
    1dc8:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1dcc:	73785f74 	cmnvc	r8, #116, 30	; 0x1d0
    1dd0:	656c6163 	strbvs	r6, [ip, #-355]!	; 0xfffffe9d
    1dd4:	6f645f00 	svcvs	0x00645f00
    1dd8:	755f746e 	ldrbvc	r7, [pc, #-1134]	; 1972 <CPSR_IRQ_INHIBIT+0x18f2>
    1ddc:	745f6573 	ldrbvc	r6, [pc], #-1395	; 1de4 <CPSR_IRQ_INHIBIT+0x1d64>
    1de0:	5f656572 	svcpl	0x00656572
    1de4:	65726568 	ldrbvs	r6, [r2, #-1384]!	; 0xfffffa98
    1de8:	4154005f 	cmpmi	r4, pc, asr r0
    1dec:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1df0:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1df4:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1df8:	64743031 	ldrbtvs	r3, [r4], #-49	; 0xffffffcf
    1dfc:	5400696d 	strpl	r6, [r0], #-2413	; 0xfffff693
    1e00:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1e04:	50435f54 	subpl	r5, r3, r4, asr pc
    1e08:	6f635f55 	svcvs	0x00635f55
    1e0c:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1e10:	62003561 	andvs	r3, r0, #406847488	; 0x18400000
    1e14:	5f657361 	svcpl	0x00657361
    1e18:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1e1c:	63657469 	cmnvs	r5, #1761607680	; 0x69000000
    1e20:	65727574 	ldrbvs	r7, [r2, #-1396]!	; 0xfffffa8c
    1e24:	6d726100 	ldfvse	f6, [r2, #-0]
    1e28:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1e2c:	72635f68 	rsbvc	r5, r3, #104, 30	; 0x1a0
    1e30:	41540063 	cmpmi	r4, r3, rrx
    1e34:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1e38:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1e3c:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1e40:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    1e44:	616d7331 	cmnvs	sp, r1, lsr r3
    1e48:	756d6c6c 	strbvc	r6, [sp, #-3180]!	; 0xfffff394
    1e4c:	7069746c 	rsbvc	r7, r9, ip, ror #8
    1e50:	6100796c 	tstvs	r0, ip, ror #18
    1e54:	635f6d72 	cmpvs	pc, #7296	; 0x1c80
    1e58:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
    1e5c:	635f746e 	cmpvs	pc, #1845493760	; 0x6e000000
    1e60:	73690063 	cmnvc	r9, #99	; 0x63
    1e64:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1e68:	72635f74 	rsbvc	r5, r3, #116, 30	; 0x1d0
    1e6c:	00323363 	eorseq	r3, r2, r3, ror #6
    1e70:	5f4d5241 	svcpl	0x004d5241
    1e74:	69004c50 	stmdbvs	r0, {r4, r6, sl, fp, lr}
    1e78:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1e7c:	765f7469 	ldrbvc	r7, [pc], -r9, ror #8
    1e80:	33767066 	cmncc	r6, #102	; 0x66
    1e84:	61736900 	cmnvs	r3, r0, lsl #18
    1e88:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1e8c:	7066765f 	rsbvc	r7, r6, pc, asr r6
    1e90:	42003476 	andmi	r3, r0, #1979711488	; 0x76000000
    1e94:	5f455341 	svcpl	0x00455341
    1e98:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1e9c:	3254365f 	subscc	r3, r4, #99614720	; 0x5f00000
    1ea0:	53414200 	movtpl	r4, #4608	; 0x1200
    1ea4:	52415f45 	subpl	r5, r1, #276	; 0x114
    1ea8:	385f4843 	ldmdacc	pc, {r0, r1, r6, fp, lr}^	; <UNPREDICTABLE>
    1eac:	414d5f4d 	cmpmi	sp, sp, asr #30
    1eb0:	54004e49 	strpl	r4, [r0], #-3657	; 0xfffff1b7
    1eb4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1eb8:	50435f54 	subpl	r5, r3, r4, asr pc
    1ebc:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1ec0:	6474396d 	ldrbtvs	r3, [r4], #-2413	; 0xfffff693
    1ec4:	4100696d 	tstmi	r0, sp, ror #18
    1ec8:	415f4d52 	cmpmi	pc, r2, asr sp	; <UNPREDICTABLE>
    1ecc:	4142004c 	cmpmi	r2, ip, asr #32
    1ed0:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1ed4:	5f484352 	svcpl	0x00484352
    1ed8:	61004d37 	tstvs	r0, r7, lsr sp
    1edc:	745f6d72 	ldrbvc	r6, [pc], #-3442	; 1ee4 <CPSR_IRQ_INHIBIT+0x1e64>
    1ee0:	65677261 	strbvs	r7, [r7, #-609]!	; 0xfffffd9f
    1ee4:	616c5f74 	smcvs	50676	; 0xc5f4
    1ee8:	006c6562 	rsbeq	r6, ip, r2, ror #10
    1eec:	5f6d7261 	svcpl	0x006d7261
    1ef0:	67726174 			; <UNDEFINED> instruction: 0x67726174
    1ef4:	695f7465 	ldmdbvs	pc, {r0, r2, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    1ef8:	006e736e 	rsbeq	r7, lr, lr, ror #6
    1efc:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1f00:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1f04:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1f08:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1f0c:	00347278 	eorseq	r7, r4, r8, ror r2
    1f10:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1f14:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1f18:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1f1c:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1f20:	00357278 	eorseq	r7, r5, r8, ror r2
    1f24:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1f28:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1f2c:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1f30:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1f34:	00377278 	eorseq	r7, r7, r8, ror r2
    1f38:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1f3c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1f40:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1f44:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1f48:	00387278 	eorseq	r7, r8, r8, ror r2
    1f4c:	5f617369 	svcpl	0x00617369
    1f50:	5f746962 	svcpl	0x00746962
    1f54:	6561706c 	strbvs	r7, [r1, #-108]!	; 0xffffff94
    1f58:	61736900 	cmnvs	r3, r0, lsl #18
    1f5c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1f60:	6975715f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, r8, ip, sp, lr}^
    1f64:	615f6b72 	cmpvs	pc, r2, ror fp	; <UNPREDICTABLE>
    1f68:	36766d72 			; <UNDEFINED> instruction: 0x36766d72
    1f6c:	69007a6b 	stmdbvs	r0, {r0, r1, r3, r5, r6, r9, fp, ip, sp, lr}
    1f70:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1f74:	6e5f7469 	cdpvs	4, 5, cr7, cr15, cr9, {3}
    1f78:	006d746f 	rsbeq	r7, sp, pc, ror #8
    1f7c:	5f617369 	svcpl	0x00617369
    1f80:	5f746962 	svcpl	0x00746962
    1f84:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1f88:	73690034 	cmnvc	r9, #52	; 0x34
    1f8c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1f90:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1f94:	0036766d 	eorseq	r7, r6, sp, ror #12
    1f98:	5f617369 	svcpl	0x00617369
    1f9c:	5f746962 	svcpl	0x00746962
    1fa0:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1fa4:	73690037 	cmnvc	r9, #55	; 0x37
    1fa8:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1fac:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1fb0:	0038766d 	eorseq	r7, r8, sp, ror #12
    1fb4:	6e6f645f 	mcrvs	4, 3, r6, cr15, cr15, {2}
    1fb8:	73755f74 	cmnvc	r5, #116, 30	; 0x1d0
    1fbc:	74725f65 	ldrbtvc	r5, [r2], #-3941	; 0xfffff09b
    1fc0:	65685f78 	strbvs	r5, [r8, #-3960]!	; 0xfffff088
    1fc4:	005f6572 	subseq	r6, pc, r2, ror r5	; <UNPREDICTABLE>
    1fc8:	74495155 	strbvc	r5, [r9], #-341	; 0xfffffeab
    1fcc:	00657079 	rsbeq	r7, r5, r9, ror r0
    1fd0:	5f617369 	svcpl	0x00617369
    1fd4:	5f746962 	svcpl	0x00746962
    1fd8:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1fdc:	00657435 	rsbeq	r7, r5, r5, lsr r4
    1fe0:	5f6d7261 	svcpl	0x006d7261
    1fe4:	656e7574 	strbvs	r7, [lr, #-1396]!	; 0xfffffa8c
    1fe8:	6d726100 	ldfvse	f6, [r2, #-0]
    1fec:	7070635f 	rsbsvc	r6, r0, pc, asr r3
    1ff0:	746e695f 	strbtvc	r6, [lr], #-2399	; 0xfffff6a1
    1ff4:	6f777265 	svcvs	0x00777265
    1ff8:	66006b72 			; <UNDEFINED> instruction: 0x66006b72
    1ffc:	5f636e75 	svcpl	0x00636e75
    2000:	00727470 	rsbseq	r7, r2, r0, ror r4
    2004:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2008:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    200c:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    2010:	32396d72 	eorscc	r6, r9, #7296	; 0x1c80
    2014:	68007430 	stmdavs	r0, {r4, r5, sl, ip, sp, lr}
    2018:	5f626174 	svcpl	0x00626174
    201c:	54007165 	strpl	r7, [r0], #-357	; 0xfffffe9b
    2020:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2024:	50435f54 	subpl	r5, r3, r4, asr pc
    2028:	61665f55 	cmnvs	r6, r5, asr pc
    202c:	00363235 	eorseq	r3, r6, r5, lsr r2
    2030:	5f6d7261 	svcpl	0x006d7261
    2034:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    2038:	7568745f 	strbvc	r7, [r8, #-1119]!	; 0xfffffba1
    203c:	685f626d 	ldmdavs	pc, {r0, r2, r3, r5, r6, r9, sp, lr}^	; <UNPREDICTABLE>
    2040:	76696477 			; <UNDEFINED> instruction: 0x76696477
    2044:	61746800 	cmnvs	r4, r0, lsl #16
    2048:	71655f62 	cmnvc	r5, r2, ror #30
    204c:	696f705f 	stmdbvs	pc!, {r0, r1, r2, r3, r4, r6, ip, sp, lr}^	; <UNPREDICTABLE>
    2050:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
    2054:	6d726100 	ldfvse	f6, [r2, #-0]
    2058:	6369705f 	cmnvs	r9, #95	; 0x5f
    205c:	6765725f 			; <UNDEFINED> instruction: 0x6765725f
    2060:	65747369 	ldrbvs	r7, [r4, #-873]!	; 0xfffffc97
    2064:	41540072 	cmpmi	r4, r2, ror r0
    2068:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    206c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2070:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2074:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    2078:	616d7330 	cmnvs	sp, r0, lsr r3
    207c:	756d6c6c 	strbvc	r6, [sp, #-3180]!	; 0xfffff394
    2080:	7069746c 	rsbvc	r7, r9, ip, ror #8
    2084:	5400796c 	strpl	r7, [r0], #-2412	; 0xfffff694
    2088:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    208c:	50435f54 	subpl	r5, r3, r4, asr pc
    2090:	706d5f55 	rsbvc	r5, sp, r5, asr pc
    2094:	65726f63 	ldrbvs	r6, [r2, #-3939]!	; 0xfffff09d
    2098:	66766f6e 	ldrbtvs	r6, [r6], -lr, ror #30
    209c:	73690070 	cmnvc	r9, #112	; 0x70
    20a0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    20a4:	75715f74 	ldrbvc	r5, [r1, #-3956]!	; 0xfffff08c
    20a8:	5f6b7269 	svcpl	0x006b7269
    20ac:	5f336d63 	svcpl	0x00336d63
    20b0:	6472646c 	ldrbtvs	r6, [r2], #-1132	; 0xfffffb94
    20b4:	4d524100 	ldfmie	f4, [r2, #-0]
    20b8:	0043435f 	subeq	r4, r3, pc, asr r3
    20bc:	5f6d7261 	svcpl	0x006d7261
    20c0:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    20c4:	00325f38 	eorseq	r5, r2, r8, lsr pc
    20c8:	5f6d7261 	svcpl	0x006d7261
    20cc:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    20d0:	00335f38 	eorseq	r5, r3, r8, lsr pc
    20d4:	5f6d7261 	svcpl	0x006d7261
    20d8:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    20dc:	00345f38 	eorseq	r5, r4, r8, lsr pc
    20e0:	47524154 			; <UNDEFINED> instruction: 0x47524154
    20e4:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    20e8:	665f5550 			; <UNDEFINED> instruction: 0x665f5550
    20ec:	3236706d 	eorscc	r7, r6, #109	; 0x6d
    20f0:	52410036 	subpl	r0, r1, #54	; 0x36
    20f4:	53435f4d 	movtpl	r5, #16205	; 0x3f4d
    20f8:	6d726100 	ldfvse	f6, [r2, #-0]
    20fc:	3170665f 	cmncc	r0, pc, asr r6
    2100:	6e695f36 	mcrvs	15, 3, r5, cr9, cr6, {1}
    2104:	61007473 	tstvs	r0, r3, ror r4
    2108:	625f6d72 	subsvs	r6, pc, #7296	; 0x1c80
    210c:	5f657361 	svcpl	0x00657361
    2110:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    2114:	52415400 	subpl	r5, r1, #0, 8
    2118:	5f544547 	svcpl	0x00544547
    211c:	5f555043 	svcpl	0x00555043
    2120:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2124:	31617865 	cmncc	r1, r5, ror #16
    2128:	726f6335 	rsbvc	r6, pc, #-738197504	; 0xd4000000
    212c:	61786574 	cmnvs	r8, r4, ror r5
    2130:	72610037 	rsbvc	r0, r1, #55	; 0x37
    2134:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    2138:	65376863 	ldrvs	r6, [r7, #-2147]!	; 0xfffff79d
    213c:	4154006d 	cmpmi	r4, sp, rrx
    2140:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2144:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2148:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    214c:	61786574 	cmnvs	r8, r4, ror r5
    2150:	61003237 	tstvs	r0, r7, lsr r2
    2154:	705f6d72 	subsvc	r6, pc, r2, ror sp	; <UNPREDICTABLE>
    2158:	645f7363 	ldrbvs	r7, [pc], #-867	; 2160 <CPSR_IRQ_INHIBIT+0x20e0>
    215c:	75616665 	strbvc	r6, [r1, #-1637]!	; 0xfffff99b
    2160:	4100746c 	tstmi	r0, ip, ror #8
    2164:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    2168:	415f5343 	cmpmi	pc, r3, asr #6
    216c:	53435041 	movtpl	r5, #12353	; 0x3041
    2170:	434f4c5f 	movtmi	r4, #64607	; 0xfc5f
    2174:	54004c41 	strpl	r4, [r0], #-3137	; 0xfffff3bf
    2178:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    217c:	50435f54 	subpl	r5, r3, r4, asr pc
    2180:	6f635f55 	svcvs	0x00635f55
    2184:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2188:	00353761 	eorseq	r3, r5, r1, ror #14
    218c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2190:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2194:	735f5550 	cmpvc	pc, #80, 10	; 0x14000000
    2198:	6e6f7274 	mcrvs	2, 3, r7, cr15, cr4, {3}
    219c:	6d726167 	ldfvse	f6, [r2, #-412]!	; 0xfffffe64
    21a0:	6d726100 	ldfvse	f6, [r2, #-0]
    21a4:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    21a8:	68745f68 	ldmdavs	r4!, {r3, r5, r6, r8, r9, sl, fp, ip, lr}^
    21ac:	31626d75 	smccc	9941	; 0x26d5
    21b0:	6d726100 	ldfvse	f6, [r2, #-0]
    21b4:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    21b8:	68745f68 	ldmdavs	r4!, {r3, r5, r6, r8, r9, sl, fp, ip, lr}^
    21bc:	32626d75 	rsbcc	r6, r2, #7488	; 0x1d40
    21c0:	52415400 	subpl	r5, r1, #0, 8
    21c4:	5f544547 	svcpl	0x00544547
    21c8:	5f555043 	svcpl	0x00555043
    21cc:	6d6d7769 	stclvs	7, cr7, [sp, #-420]!	; 0xfffffe5c
    21d0:	61007478 	tstvs	r0, r8, ror r4
    21d4:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    21d8:	35686372 	strbcc	r6, [r8, #-882]!	; 0xfffffc8e
    21dc:	73690074 	cmnvc	r9, #116	; 0x74
    21e0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    21e4:	706d5f74 	rsbvc	r5, sp, r4, ror pc
    21e8:	6d726100 	ldfvse	f6, [r2, #-0]
    21ec:	5f646c5f 	svcpl	0x00646c5f
    21f0:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
    21f4:	72610064 	rsbvc	r0, r1, #100	; 0x64
    21f8:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    21fc:	5f386863 	svcpl	0x00386863
    2200:	Address 0x0000000000002200 is out of bounds.


Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347 	bcc	10d0d24 <_bss_end+0x10c7a78>
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
  10:	4b5a3605 	blmi	168d82c <_bss_end+0x1684580>
  14:	08070600 	stmdaeq	r7, {r9, sl}
  18:	0a010901 	beq	42424 <_bss_end+0x39178>
  1c:	14041202 	strne	r1, [r4], #-514	; 0xfffffdfe
  20:	17011501 	strne	r1, [r1, -r1, lsl #10]
  24:	1a011803 	bne	46038 <_bss_end+0x3cd8c>
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
  20:	8b040e42 	blhi	103930 <_bss_end+0xfa684>
  24:	0b0d4201 	bleq	350830 <_bss_end+0x347584>
  28:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
  2c:	00000ecb 	andeq	r0, r0, fp, asr #29
  30:	0000001c 	andeq	r0, r0, ip, lsl r0
  34:	00000000 	andeq	r0, r0, r0
  38:	000080cc 	andeq	r8, r0, ip, asr #1
  3c:	0000002c 	andeq	r0, r0, ip, lsr #32
  40:	8b040e42 	blhi	103950 <_bss_end+0xfa6a4>
  44:	0b0d4201 	bleq	350850 <_bss_end+0x3475a4>
  48:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
  4c:	00000ecb 	andeq	r0, r0, fp, asr #29
  50:	0000001c 	andeq	r0, r0, ip, lsl r0
  54:	00000000 	andeq	r0, r0, r0
  58:	000080f8 	strdeq	r8, [r0], -r8	; <UNPREDICTABLE>
  5c:	00000020 	andeq	r0, r0, r0, lsr #32
  60:	8b040e42 	blhi	103970 <_bss_end+0xfa6c4>
  64:	0b0d4201 	bleq	350870 <_bss_end+0x3475c4>
  68:	420d0d48 	andmi	r0, sp, #72, 26	; 0x1200
  6c:	00000ecb 	andeq	r0, r0, fp, asr #29
  70:	0000001c 	andeq	r0, r0, ip, lsl r0
  74:	00000000 	andeq	r0, r0, r0
  78:	00008118 	andeq	r8, r0, r8, lsl r1
  7c:	00000018 	andeq	r0, r0, r8, lsl r0
  80:	8b040e42 	blhi	103990 <_bss_end+0xfa6e4>
  84:	0b0d4201 	bleq	350890 <_bss_end+0x3475e4>
  88:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  8c:	00000ecb 	andeq	r0, r0, fp, asr #29
  90:	0000001c 	andeq	r0, r0, ip, lsl r0
  94:	00000000 	andeq	r0, r0, r0
  98:	00008130 	andeq	r8, r0, r0, lsr r1
  9c:	00000018 	andeq	r0, r0, r8, lsl r0
  a0:	8b040e42 	blhi	1039b0 <_bss_end+0xfa704>
  a4:	0b0d4201 	bleq	3508b0 <_bss_end+0x347604>
  a8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  ac:	00000ecb 	andeq	r0, r0, fp, asr #29
  b0:	0000001c 	andeq	r0, r0, ip, lsl r0
  b4:	00000000 	andeq	r0, r0, r0
  b8:	00008148 	andeq	r8, r0, r8, asr #2
  bc:	00000018 	andeq	r0, r0, r8, lsl r0
  c0:	8b040e42 	blhi	1039d0 <_bss_end+0xfa724>
  c4:	0b0d4201 	bleq	3508d0 <_bss_end+0x347624>
  c8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  cc:	00000ecb 	andeq	r0, r0, fp, asr #29
  d0:	00000014 	andeq	r0, r0, r4, lsl r0
  d4:	00000000 	andeq	r0, r0, r0
  d8:	00008160 	andeq	r8, r0, r0, ror #2
  dc:	0000000c 	andeq	r0, r0, ip
  e0:	8b040e42 	blhi	1039f0 <_bss_end+0xfa744>
  e4:	0b0d4201 	bleq	3508f0 <_bss_end+0x347644>
  e8:	0000000c 	andeq	r0, r0, ip
  ec:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  f0:	7c020001 	stcvc	0, cr0, [r2], {1}
  f4:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  f8:	0000001c 	andeq	r0, r0, ip, lsl r0
  fc:	000000e8 	andeq	r0, r0, r8, ror #1
 100:	0000816c 	andeq	r8, r0, ip, ror #2
 104:	00000034 	andeq	r0, r0, r4, lsr r0
 108:	8b040e42 	blhi	103a18 <_bss_end+0xfa76c>
 10c:	0b0d4201 	bleq	350918 <_bss_end+0x34766c>
 110:	420d0d52 	andmi	r0, sp, #5248	; 0x1480
 114:	00000ecb 	andeq	r0, r0, fp, asr #29
 118:	0000001c 	andeq	r0, r0, ip, lsl r0
 11c:	000000e8 	andeq	r0, r0, r8, ror #1
 120:	000081a0 	andeq	r8, r0, r0, lsr #3
 124:	00000114 	andeq	r0, r0, r4, lsl r1
 128:	8b040e42 	blhi	103a38 <_bss_end+0xfa78c>
 12c:	0b0d4201 	bleq	350938 <_bss_end+0x34768c>
 130:	0d0d8002 	stceq	0, cr8, [sp, #-8]
 134:	000ecb42 	andeq	ip, lr, r2, asr #22
 138:	0000001c 	andeq	r0, r0, ip, lsl r0
 13c:	000000e8 	andeq	r0, r0, r8, ror #1
 140:	000082b4 			; <UNDEFINED> instruction: 0x000082b4
 144:	00000074 	andeq	r0, r0, r4, ror r0
 148:	8b040e42 	blhi	103a58 <_bss_end+0xfa7ac>
 14c:	0b0d4201 	bleq	350958 <_bss_end+0x3476ac>
 150:	420d0d72 	andmi	r0, sp, #7296	; 0x1c80
 154:	00000ecb 	andeq	r0, r0, fp, asr #29
 158:	0000001c 	andeq	r0, r0, ip, lsl r0
 15c:	000000e8 	andeq	r0, r0, r8, ror #1
 160:	00008328 	andeq	r8, r0, r8, lsr #6
 164:	00000074 	andeq	r0, r0, r4, ror r0
 168:	8b040e42 	blhi	103a78 <_bss_end+0xfa7cc>
 16c:	0b0d4201 	bleq	350978 <_bss_end+0x3476cc>
 170:	420d0d72 	andmi	r0, sp, #7296	; 0x1c80
 174:	00000ecb 	andeq	r0, r0, fp, asr #29
 178:	0000001c 	andeq	r0, r0, ip, lsl r0
 17c:	000000e8 	andeq	r0, r0, r8, ror #1
 180:	0000839c 	muleq	r0, ip, r3
 184:	00000074 	andeq	r0, r0, r4, ror r0
 188:	8b040e42 	blhi	103a98 <_bss_end+0xfa7ec>
 18c:	0b0d4201 	bleq	350998 <_bss_end+0x3476ec>
 190:	420d0d72 	andmi	r0, sp, #7296	; 0x1c80
 194:	00000ecb 	andeq	r0, r0, fp, asr #29
 198:	0000001c 	andeq	r0, r0, ip, lsl r0
 19c:	000000e8 	andeq	r0, r0, r8, ror #1
 1a0:	00008410 	andeq	r8, r0, r0, lsl r4
 1a4:	000000a8 	andeq	r0, r0, r8, lsr #1
 1a8:	8b080e42 	blhi	203ab8 <_bss_end+0x1fa80c>
 1ac:	42018e02 	andmi	r8, r1, #2, 28
 1b0:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 1b4:	080d0c4e 	stmdaeq	sp, {r1, r2, r3, r6, sl, fp}
 1b8:	0000001c 	andeq	r0, r0, ip, lsl r0
 1bc:	000000e8 	andeq	r0, r0, r8, ror #1
 1c0:	000084b8 			; <UNDEFINED> instruction: 0x000084b8
 1c4:	0000007c 	andeq	r0, r0, ip, ror r0
 1c8:	8b080e42 	blhi	203ad8 <_bss_end+0x1fa82c>
 1cc:	42018e02 	andmi	r8, r1, #2, 28
 1d0:	78040b0c 	stmdavc	r4, {r2, r3, r8, r9, fp}
 1d4:	00080d0c 	andeq	r0, r8, ip, lsl #26
 1d8:	0000001c 	andeq	r0, r0, ip, lsl r0
 1dc:	000000e8 	andeq	r0, r0, r8, ror #1
 1e0:	00008534 	andeq	r8, r0, r4, lsr r5
 1e4:	00000084 	andeq	r0, r0, r4, lsl #1
 1e8:	8b080e42 	blhi	203af8 <_bss_end+0x1fa84c>
 1ec:	42018e02 	andmi	r8, r1, #2, 28
 1f0:	7c040b0c 			; <UNDEFINED> instruction: 0x7c040b0c
 1f4:	00080d0c 	andeq	r0, r8, ip, lsl #26
 1f8:	0000001c 	andeq	r0, r0, ip, lsl r0
 1fc:	000000e8 	andeq	r0, r0, r8, ror #1
 200:	000085b8 			; <UNDEFINED> instruction: 0x000085b8
 204:	0000010c 	andeq	r0, r0, ip, lsl #2
 208:	8b040e42 	blhi	103b18 <_bss_end+0xfa86c>
 20c:	0b0d4201 	bleq	350a18 <_bss_end+0x34776c>
 210:	0d0d7e02 	stceq	14, cr7, [sp, #-8]
 214:	000ecb42 	andeq	ip, lr, r2, asr #22
 218:	0000001c 	andeq	r0, r0, ip, lsl r0
 21c:	000000e8 	andeq	r0, r0, r8, ror #1
 220:	000086c4 	andeq	r8, r0, r4, asr #13
 224:	000000b4 	strheq	r0, [r0], -r4
 228:	8b080e42 	blhi	203b38 <_bss_end+0x1fa88c>
 22c:	42018e02 	andmi	r8, r1, #2, 28
 230:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 234:	080d0c54 	stmdaeq	sp, {r2, r4, r6, sl, fp}
 238:	0000001c 	andeq	r0, r0, ip, lsl r0
 23c:	000000e8 	andeq	r0, r0, r8, ror #1
 240:	00008778 	andeq	r8, r0, r8, ror r7
 244:	000000d8 	ldrdeq	r0, [r0], -r8
 248:	8b080e42 	blhi	203b58 <_bss_end+0x1fa8ac>
 24c:	42018e02 	andmi	r8, r1, #2, 28
 250:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 254:	080d0c66 	stmdaeq	sp, {r1, r2, r5, r6, sl, fp}
 258:	0000001c 	andeq	r0, r0, ip, lsl r0
 25c:	000000e8 	andeq	r0, r0, r8, ror #1
 260:	00008850 	andeq	r8, r0, r0, asr r8
 264:	00000074 	andeq	r0, r0, r4, ror r0
 268:	8b040e42 	blhi	103b78 <_bss_end+0xfa8cc>
 26c:	0b0d4201 	bleq	350a78 <_bss_end+0x3477cc>
 270:	420d0d72 	andmi	r0, sp, #7296	; 0x1c80
 274:	00000ecb 	andeq	r0, r0, fp, asr #29
 278:	0000001c 	andeq	r0, r0, ip, lsl r0
 27c:	000000e8 	andeq	r0, r0, r8, ror #1
 280:	000088c4 	andeq	r8, r0, r4, asr #17
 284:	00000074 	andeq	r0, r0, r4, ror r0
 288:	8b080e42 	blhi	203b98 <_bss_end+0x1fa8ec>
 28c:	42018e02 	andmi	r8, r1, #2, 28
 290:	74040b0c 	strvc	r0, [r4], #-2828	; 0xfffff4f4
 294:	00080d0c 	andeq	r0, r8, ip, lsl #26
 298:	0000001c 	andeq	r0, r0, ip, lsl r0
 29c:	000000e8 	andeq	r0, r0, r8, ror #1
 2a0:	00008938 	andeq	r8, r0, r8, lsr r9
 2a4:	00000054 	andeq	r0, r0, r4, asr r0
 2a8:	8b080e42 	blhi	203bb8 <_bss_end+0x1fa90c>
 2ac:	42018e02 	andmi	r8, r1, #2, 28
 2b0:	5e040b0c 	vmlapl.f64	d0, d4, d12
 2b4:	00080d0c 	andeq	r0, r8, ip, lsl #26
 2b8:	00000018 	andeq	r0, r0, r8, lsl r0
 2bc:	000000e8 	andeq	r0, r0, r8, ror #1
 2c0:	0000898c 	andeq	r8, r0, ip, lsl #19
 2c4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2c8:	8b080e42 	blhi	203bd8 <_bss_end+0x1fa92c>
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
 2f4:	8b040e42 	blhi	103c04 <_bss_end+0xfa958>
 2f8:	0b0d4201 	bleq	350b04 <_bss_end+0x347858>
 2fc:	420d0d58 	andmi	r0, sp, #88, 26	; 0x1600
 300:	00000ecb 	andeq	r0, r0, fp, asr #29
 304:	0000001c 	andeq	r0, r0, ip, lsl r0
 308:	000002d4 	ldrdeq	r0, [r0], -r4
 30c:	000089e8 	andeq	r8, r0, r8, ror #19
 310:	00000038 	andeq	r0, r0, r8, lsr r0
 314:	8b040e42 	blhi	103c24 <_bss_end+0xfa978>
 318:	0b0d4201 	bleq	350b24 <_bss_end+0x347878>
 31c:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
 320:	00000ecb 	andeq	r0, r0, fp, asr #29
 324:	00000020 	andeq	r0, r0, r0, lsr #32
 328:	000002d4 	ldrdeq	r0, [r0], -r4
 32c:	00008a20 	andeq	r8, r0, r0, lsr #20
 330:	000000cc 	andeq	r0, r0, ip, asr #1
 334:	840c0e42 	strhi	r0, [ip], #-3650	; 0xfffff1be
 338:	8e028b03 	vmlahi.f64	d8, d2, d3
 33c:	0b0c4201 	bleq	310b48 <_bss_end+0x30789c>
 340:	0c600204 	sfmeq	f0, 2, [r0], #-16
 344:	00000c0d 	andeq	r0, r0, sp, lsl #24
 348:	0000001c 	andeq	r0, r0, ip, lsl r0
 34c:	000002d4 	ldrdeq	r0, [r0], -r4
 350:	00008aec 	andeq	r8, r0, ip, ror #21
 354:	0000004c 	andeq	r0, r0, ip, asr #32
 358:	8b080e42 	blhi	203c68 <_bss_end+0x1fa9bc>
 35c:	42018e02 	andmi	r8, r1, #2, 28
 360:	60040b0c 	andvs	r0, r4, ip, lsl #22
 364:	00080d0c 	andeq	r0, r8, ip, lsl #26
 368:	0000001c 	andeq	r0, r0, ip, lsl r0
 36c:	000002d4 	ldrdeq	r0, [r0], -r4
 370:	00008b38 	andeq	r8, r0, r8, lsr fp
 374:	00000050 	andeq	r0, r0, r0, asr r0
 378:	8b080e42 	blhi	203c88 <_bss_end+0x1fa9dc>
 37c:	42018e02 	andmi	r8, r1, #2, 28
 380:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 384:	00080d0c 	andeq	r0, r8, ip, lsl #26
 388:	0000001c 	andeq	r0, r0, ip, lsl r0
 38c:	000002d4 	ldrdeq	r0, [r0], -r4
 390:	00008b88 	andeq	r8, r0, r8, lsl #23
 394:	00000040 	andeq	r0, r0, r0, asr #32
 398:	8b080e42 	blhi	203ca8 <_bss_end+0x1fa9fc>
 39c:	42018e02 	andmi	r8, r1, #2, 28
 3a0:	5a040b0c 	bpl	102fd8 <_bss_end+0xf9d2c>
 3a4:	00080d0c 	andeq	r0, r8, ip, lsl #26
 3a8:	0000001c 	andeq	r0, r0, ip, lsl r0
 3ac:	000002d4 	ldrdeq	r0, [r0], -r4
 3b0:	00008bc8 	andeq	r8, r0, r8, asr #23
 3b4:	00000054 	andeq	r0, r0, r4, asr r0
 3b8:	8b080e42 	blhi	203cc8 <_bss_end+0x1faa1c>
 3bc:	42018e02 	andmi	r8, r1, #2, 28
 3c0:	5e040b0c 	vmlapl.f64	d0, d4, d12
 3c4:	00080d0c 	andeq	r0, r8, ip, lsl #26
 3c8:	00000018 	andeq	r0, r0, r8, lsl r0
 3cc:	000002d4 	ldrdeq	r0, [r0], -r4
 3d0:	00008c1c 	andeq	r8, r0, ip, lsl ip
 3d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3d8:	8b080e42 	blhi	203ce8 <_bss_end+0x1faa3c>
 3dc:	42018e02 	andmi	r8, r1, #2, 28
 3e0:	00040b0c 	andeq	r0, r4, ip, lsl #22
 3e4:	0000000c 	andeq	r0, r0, ip
 3e8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 3ec:	7c020001 	stcvc	0, cr0, [r2], {1}
 3f0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 3f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3f8:	000003e4 	andeq	r0, r0, r4, ror #7
 3fc:	00008c38 	andeq	r8, r0, r8, lsr ip
 400:	00000018 	andeq	r0, r0, r8, lsl r0
 404:	8b040e42 	blhi	103d14 <_bss_end+0xfaa68>
 408:	0b0d4201 	bleq	350c14 <_bss_end+0x347968>
 40c:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
 410:	00000ecb 	andeq	r0, r0, fp, asr #29
 414:	00000028 	andeq	r0, r0, r8, lsr #32
 418:	000003e4 	andeq	r0, r0, r4, ror #7
 41c:	00008c50 	andeq	r8, r0, r0, asr ip
 420:	00000080 	andeq	r0, r0, r0, lsl #1
 424:	80200e44 	eorhi	r0, r0, r4, asr #28
 428:	82078108 	andhi	r8, r7, #8, 2
 42c:	84058306 	strhi	r8, [r5], #-774	; 0xfffffcfa
 430:	8c038b04 			; <UNDEFINED> instruction: 0x8c038b04
 434:	42018e02 	andmi	r8, r1, #2, 28
 438:	72040b0c 	andvc	r0, r4, #12, 22	; 0x3000
 43c:	00200d0c 	eoreq	r0, r0, ip, lsl #26
 440:	00000014 	andeq	r0, r0, r4, lsl r0
 444:	000003e4 	andeq	r0, r0, r4, ror #7
 448:	00008cd0 	ldrdeq	r8, [r0], -r0
 44c:	00000010 	andeq	r0, r0, r0, lsl r0
 450:	040b0c42 	streq	r0, [fp], #-3138	; 0xfffff3be
 454:	000d0c44 	andeq	r0, sp, r4, asr #24
 458:	0000001c 	andeq	r0, r0, ip, lsl r0
 45c:	000003e4 	andeq	r0, r0, r4, ror #7
 460:	00008ce0 	andeq	r8, r0, r0, ror #25
 464:	00000034 	andeq	r0, r0, r4, lsr r0
 468:	8b040e42 	blhi	103d78 <_bss_end+0xfaacc>
 46c:	0b0d4201 	bleq	350c78 <_bss_end+0x3479cc>
 470:	420d0d52 	andmi	r0, sp, #5248	; 0x1480
 474:	00000ecb 	andeq	r0, r0, fp, asr #29
 478:	0000001c 	andeq	r0, r0, ip, lsl r0
 47c:	000003e4 	andeq	r0, r0, r4, ror #7
 480:	00008d14 	andeq	r8, r0, r4, lsl sp
 484:	00000038 	andeq	r0, r0, r8, lsr r0
 488:	8b040e42 	blhi	103d98 <_bss_end+0xfaaec>
 48c:	0b0d4201 	bleq	350c98 <_bss_end+0x3479ec>
 490:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
 494:	00000ecb 	andeq	r0, r0, fp, asr #29
 498:	00000020 	andeq	r0, r0, r0, lsr #32
 49c:	000003e4 	andeq	r0, r0, r4, ror #7
 4a0:	00008d4c 	andeq	r8, r0, ip, asr #26
 4a4:	00000044 	andeq	r0, r0, r4, asr #32
 4a8:	840c0e42 	strhi	r0, [ip], #-3650	; 0xfffff1be
 4ac:	8e028b03 	vmlahi.f64	d8, d2, d3
 4b0:	0b0c4201 	bleq	310cbc <_bss_end+0x307a10>
 4b4:	0d0c5c04 	stceq	12, cr5, [ip, #-16]
 4b8:	0000000c 	andeq	r0, r0, ip
 4bc:	00000020 	andeq	r0, r0, r0, lsr #32
 4c0:	000003e4 	andeq	r0, r0, r4, ror #7
 4c4:	00008d90 	muleq	r0, r0, sp
 4c8:	00000044 	andeq	r0, r0, r4, asr #32
 4cc:	840c0e42 	strhi	r0, [ip], #-3650	; 0xfffff1be
 4d0:	8e028b03 	vmlahi.f64	d8, d2, d3
 4d4:	0b0c4201 	bleq	310ce0 <_bss_end+0x307a34>
 4d8:	0d0c5c04 	stceq	12, cr5, [ip, #-16]
 4dc:	0000000c 	andeq	r0, r0, ip
 4e0:	00000020 	andeq	r0, r0, r0, lsr #32
 4e4:	000003e4 	andeq	r0, r0, r4, ror #7
 4e8:	00008dd4 	ldrdeq	r8, [r0], -r4
 4ec:	00000068 	andeq	r0, r0, r8, rrx
 4f0:	840c0e42 	strhi	r0, [ip], #-3650	; 0xfffff1be
 4f4:	8e028b03 	vmlahi.f64	d8, d2, d3
 4f8:	0b0c4201 	bleq	310d04 <_bss_end+0x307a58>
 4fc:	0d0c6e04 	stceq	14, cr6, [ip, #-16]
 500:	0000000c 	andeq	r0, r0, ip
 504:	00000020 	andeq	r0, r0, r0, lsr #32
 508:	000003e4 	andeq	r0, r0, r4, ror #7
 50c:	00008e3c 	andeq	r8, r0, ip, lsr lr
 510:	00000068 	andeq	r0, r0, r8, rrx
 514:	840c0e42 	strhi	r0, [ip], #-3650	; 0xfffff1be
 518:	8e028b03 	vmlahi.f64	d8, d2, d3
 51c:	0b0c4201 	bleq	310d28 <_bss_end+0x307a7c>
 520:	0d0c6e04 	stceq	14, cr6, [ip, #-16]
 524:	0000000c 	andeq	r0, r0, ip
 528:	0000001c 	andeq	r0, r0, ip, lsl r0
 52c:	000003e4 	andeq	r0, r0, r4, ror #7
 530:	00008ea4 	andeq	r8, r0, r4, lsr #29
 534:	00000054 	andeq	r0, r0, r4, asr r0
 538:	8b080e42 	blhi	203e48 <_bss_end+0x1fab9c>
 53c:	42018e02 	andmi	r8, r1, #2, 28
 540:	5e040b0c 	vmlapl.f64	d0, d4, d12
 544:	00080d0c 	andeq	r0, r8, ip, lsl #26
 548:	00000018 	andeq	r0, r0, r8, lsl r0
 54c:	000003e4 	andeq	r0, r0, r4, ror #7
 550:	00008ef8 	strdeq	r8, [r0], -r8	; <UNPREDICTABLE>
 554:	0000001c 	andeq	r0, r0, ip, lsl r0
 558:	8b080e42 	blhi	203e68 <_bss_end+0x1fabbc>
 55c:	42018e02 	andmi	r8, r1, #2, 28
 560:	00040b0c 	andeq	r0, r4, ip, lsl #22
 564:	0000000c 	andeq	r0, r0, ip
 568:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 56c:	7c020001 	stcvc	0, cr0, [r2], {1}
 570:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 574:	00000018 	andeq	r0, r0, r8, lsl r0
 578:	00000564 	andeq	r0, r0, r4, ror #10
 57c:	00008f14 	andeq	r8, r0, r4, lsl pc
 580:	00000074 	andeq	r0, r0, r4, ror r0
 584:	8b080e42 	blhi	203e94 <_bss_end+0x1fabe8>
 588:	42018e02 	andmi	r8, r1, #2, 28
 58c:	00040b0c 	andeq	r0, r4, ip, lsl #22
 590:	00000018 	andeq	r0, r0, r8, lsl r0
 594:	00000564 	andeq	r0, r0, r4, ror #10
 598:	00008f88 	andeq	r8, r0, r8, lsl #31
 59c:	000000a8 	andeq	r0, r0, r8, lsr #1
 5a0:	8b080e42 	blhi	203eb0 <_bss_end+0x1fac04>
 5a4:	42018e02 	andmi	r8, r1, #2, 28
 5a8:	00040b0c 	andeq	r0, r4, ip, lsl #22
 5ac:	0000000c 	andeq	r0, r0, ip
 5b0:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 5b4:	7c020001 	stcvc	0, cr0, [r2], {1}
 5b8:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 5bc:	0000001c 	andeq	r0, r0, ip, lsl r0
 5c0:	000005ac 	andeq	r0, r0, ip, lsr #11
 5c4:	00009050 	andeq	r9, r0, r0, asr r0
 5c8:	00000068 	andeq	r0, r0, r8, rrx
 5cc:	8b040e42 	blhi	103edc <_bss_end+0xfac30>
 5d0:	0b0d4201 	bleq	350ddc <_bss_end+0x347b30>
 5d4:	420d0d68 	andmi	r0, sp, #104, 26	; 0x1a00
 5d8:	00000ecb 	andeq	r0, r0, fp, asr #29
 5dc:	0000001c 	andeq	r0, r0, ip, lsl r0
 5e0:	000005ac 	andeq	r0, r0, ip, lsr #11
 5e4:	000090b8 	strheq	r9, [r0], -r8
 5e8:	00000058 	andeq	r0, r0, r8, asr r0
 5ec:	8b080e42 	blhi	203efc <_bss_end+0x1fac50>
 5f0:	42018e02 	andmi	r8, r1, #2, 28
 5f4:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 5f8:	00080d0c 	andeq	r0, r8, ip, lsl #26
 5fc:	0000001c 	andeq	r0, r0, ip, lsl r0
 600:	000005ac 	andeq	r0, r0, ip, lsr #11
 604:	00009110 	andeq	r9, r0, r0, lsl r1
 608:	00000058 	andeq	r0, r0, r8, asr r0
 60c:	8b080e42 	blhi	203f1c <_bss_end+0x1fac70>
 610:	42018e02 	andmi	r8, r1, #2, 28
 614:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 618:	00080d0c 	andeq	r0, r8, ip, lsl #26

Disassembly of section .debug_ranges:

00000000 <.debug_ranges>:
   0:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
   4:	00000000 	andeq	r0, r0, r0
   8:	00008000 	andeq	r8, r0, r0
   c:	00008094 	muleq	r0, r4, r0
  10:	00009030 	andeq	r9, r0, r0, lsr r0
  14:	00009050 	andeq	r9, r0, r0, asr r0
	...
