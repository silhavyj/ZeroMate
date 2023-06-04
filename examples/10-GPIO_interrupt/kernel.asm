
./kernel:     file format elf32-littlearm


Disassembly of section .text:

00008000 <_start>:
_start():
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/start.s:14
	;@	- sem skoci bootloader, prvni na co narazi je "ldr pc, _reset_ptr" -> tedy se chova jako kdyby slo o reset a skoci na zacatek provadeni
	;@	- v cele svoji krase (vsechny "ldr" instrukce) slouzi jako predloha skutecne tabulce vektoru preruseni
	;@ na dany offset procesor skoci, kdyz je vyvolano libovolne preruseni
	;@ ARM nastavuje rovnou registr PC na tuto adresu, tzn. na teto adrese musi byt kodovana 4B instrukce skoku nekam jinam
	;@ oproti tomu napr. x86 (x86_64) obsahuje v tabulce rovnou adresu a procesor nastavuje PC (CS:IP) na adresu kterou najde v tabulce
	ldr pc, _reset_ptr						;@ 0x00 - reset - vyvolano pri resetu procesoru
    8000:	e59ff018 	ldr	pc, [pc, #24]	; 8020 <_reset_ptr>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/start.s:15
	ldr pc, _undefined_instruction_ptr		;@ 0x04 - undefined instruction - vyjimka, vyvolana pri dekodovani nezname instrukce
    8004:	e59ff018 	ldr	pc, [pc, #24]	; 8024 <_undefined_instruction_ptr>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/start.s:16
	ldr pc, _software_interrupt_ptr			;@ 0x08 - software interrupt - vyvolano, kdyz procesor provede instrukci swi
    8008:	e59ff018 	ldr	pc, [pc, #24]	; 8028 <_software_interrupt_ptr>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/start.s:17
	ldr pc, _prefetch_abort_ptr				;@ 0x0C - prefetch abort - vyvolano, kdyz se procesor snazi napr. nacist instrukci z mista, odkud nacist nejde
    800c:	e59ff018 	ldr	pc, [pc, #24]	; 802c <_prefetch_abort_ptr>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/start.s:18
	ldr pc, _data_abort_ptr					;@ 0x10 - data abort - vyvolano, kdyz se procesor snazi napr. nacist data z mista, odkud nacist nejdou
    8010:	e59ff018 	ldr	pc, [pc, #24]	; 8030 <_data_abort_ptr>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/start.s:19
	ldr pc, _unused_handler_ptr				;@ 0x14 - unused - ve specifikaci ARM neni uvedeno zadne vyuziti
    8014:	e59ff018 	ldr	pc, [pc, #24]	; 8034 <_unused_handler_ptr>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/start.s:20
	ldr pc, _irq_ptr						;@ 0x18 - IRQ - hardwarove preruseni (general purpose)
    8018:	e59ff018 	ldr	pc, [pc, #24]	; 8038 <_irq_ptr>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/start.s:21
	ldr pc, _fast_interrupt_ptr				;@ 0x1C - fast interrupt request - prioritni IRQ pro vysokorychlostni zalezitosti
    801c:	e59ff018 	ldr	pc, [pc, #24]	; 803c <_fast_interrupt_ptr>

00008020 <_reset_ptr>:
_reset_ptr():
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/start.s:21
    8020:	00008040 	andeq	r8, r0, r0, asr #32

00008024 <_undefined_instruction_ptr>:
_undefined_instruction_ptr():
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/start.s:21
    8024:	00008cd8 	ldrdeq	r8, [r0], -r8	; <UNPREDICTABLE>

00008028 <_software_interrupt_ptr>:
_software_interrupt_ptr():
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/start.s:21
    8028:	000089a8 	andeq	r8, r0, r8, lsr #19

0000802c <_prefetch_abort_ptr>:
_prefetch_abort_ptr():
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/start.s:21
    802c:	00008cdc 	ldrdeq	r8, [r0], -ip

00008030 <_data_abort_ptr>:
_data_abort_ptr():
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/start.s:21
    8030:	00008ce0 	andeq	r8, r0, r0, ror #25

00008034 <_unused_handler_ptr>:
_unused_handler_ptr():
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/start.s:21
    8034:	00008040 	andeq	r8, r0, r0, asr #32

00008038 <_irq_ptr>:
_irq_ptr():
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/start.s:21
    8038:	000089c0 	andeq	r8, r0, r0, asr #19

0000803c <_fast_interrupt_ptr>:
_fast_interrupt_ptr():
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/start.s:21
    803c:	00008a1c 	andeq	r8, r0, ip, lsl sl

00008040 <_reset>:
_reset():
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/start.s:50
.equ    CPSR_FIQ_INHIBIT,       0x40


;@ kernel reset vektor - tento kod se vykona pri kazdem resetu zarizeni (i prvnim spusteni)
_reset:
	mov sp, #0x8000			;@ nastavime stack pointer na spodek zasobniku
    8040:	e3a0d902 	mov	sp, #32768	; 0x8000
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/start.s:53

	;@ nacteni tabulky vektoru preruseni do pameti
	mov r0, #0x8000			;@ adresa 0x8000 (_start) do r0
    8044:	e3a00902 	mov	r0, #32768	; 0x8000
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/start.s:54
    mov r1, #0x0000			;@ adresa 0x0000 (pocatek RAM) do r1 - tam budeme vkladat tabulku vektoru preruseni
    8048:	e3a01000 	mov	r1, #0
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/start.s:58

	;@ Thumb instrukce - nacteni 4B slov z pameti ulozene v r0 (0x8000) do registru r2, 3, ... 9
	;@                 - ulozeni obsahu registru r2, 3, ... 9 do pameti ulozene v registru r1 (0x0000)
    ldmia r0!,{r2, r3, r4, r5, r6, r7, r8, r9}
    804c:	e8b003fc 	ldm	r0!, {r2, r3, r4, r5, r6, r7, r8, r9}
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/start.s:59
    stmia r1!,{r2, r3, r4, r5, r6, r7, r8, r9}
    8050:	e8a103fc 	stmia	r1!, {r2, r3, r4, r5, r6, r7, r8, r9}
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/start.s:60
    ldmia r0!,{r2, r3, r4, r5, r6, r7, r8, r9}
    8054:	e8b003fc 	ldm	r0!, {r2, r3, r4, r5, r6, r7, r8, r9}
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/start.s:61
    stmia r1!,{r2, r3, r4, r5, r6, r7, r8, r9}
    8058:	e8a103fc 	stmia	r1!, {r2, r3, r4, r5, r6, r7, r8, r9}
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/start.s:64

	;@ na moment se prepneme do IRQ rezimu, nastavime mu stack pointer
	mov r0, #(CPSR_MODE_IRQ | CPSR_IRQ_INHIBIT | CPSR_FIQ_INHIBIT)
    805c:	e3a000d2 	mov	r0, #210	; 0xd2
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/start.s:65
    msr cpsr_c, r0
    8060:	e121f000 	msr	CPSR_c, r0
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/start.s:66
    mov sp, #0x7000
    8064:	e3a0da07 	mov	sp, #28672	; 0x7000
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/start.s:69

	;@ na moment se prepneme do FIQ rezimu, nastavime mu stack pointer
	mov r0, #(CPSR_MODE_FIQ | CPSR_IRQ_INHIBIT | CPSR_FIQ_INHIBIT)
    8068:	e3a000d1 	mov	r0, #209	; 0xd1
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/start.s:70
    msr cpsr_c, r0
    806c:	e121f000 	msr	CPSR_c, r0
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/start.s:71
    mov sp, #0x6000
    8070:	e3a0da06 	mov	sp, #24576	; 0x6000
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/start.s:74

	;@ a vracime se zpet do supervisor modu, SP si nastavime zpet na nasi hodnotu
    mov r0, #(CPSR_MODE_SVR | CPSR_IRQ_INHIBIT | CPSR_FIQ_INHIBIT)
    8074:	e3a000d3 	mov	r0, #211	; 0xd3
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/start.s:75
    msr cpsr_c, r0
    8078:	e121f000 	msr	CPSR_c, r0
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/start.s:76
    mov sp, #0x8000
    807c:	e3a0d902 	mov	sp, #32768	; 0x8000
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/start.s:78

	bl _c_startup			;@ C startup kod (inicializace prostredi)
    8080:	eb000317 	bl	8ce4 <_c_startup>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/start.s:79
	bl _cpp_startup			;@ C++ startup kod (volani globalnich konstruktoru, ...)
    8084:	eb000330 	bl	8d4c <_cpp_startup>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/start.s:80
	bl _kernel_main			;@ skocime do hlavniho kodu jadra (v C)
    8088:	eb0002f4 	bl	8c60 <_kernel_main>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/start.s:81
	bl _cpp_shutdown		;@ C++ shutdown kod (volani globalnich destruktoru, ...)
    808c:	eb000344 	bl	8da4 <_cpp_shutdown>

00008090 <hang>:
hang():
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/start.s:83
hang:
	b hang
    8090:	eafffffe 	b	8090 <hang>

00008094 <__cxa_guard_acquire>:
__cxa_guard_acquire():
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/cxx.cpp:11
    extern "C" int __cxa_guard_acquire(__guard*);
    extern "C" void __cxa_guard_release(__guard*);
    extern "C" void __cxa_guard_abort(__guard*);

    extern "C" int __cxa_guard_acquire(__guard* g)
    {
    8094:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8098:	e28db000 	add	fp, sp, #0
    809c:	e24dd00c 	sub	sp, sp, #12
    80a0:	e50b0008 	str	r0, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/cxx.cpp:12
        return !*(char*)(g);
    80a4:	e51b3008 	ldr	r3, [fp, #-8]
    80a8:	e5d33000 	ldrb	r3, [r3]
    80ac:	e3530000 	cmp	r3, #0
    80b0:	03a03001 	moveq	r3, #1
    80b4:	13a03000 	movne	r3, #0
    80b8:	e6ef3073 	uxtb	r3, r3
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/cxx.cpp:13
    }
    80bc:	e1a00003 	mov	r0, r3
    80c0:	e28bd000 	add	sp, fp, #0
    80c4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    80c8:	e12fff1e 	bx	lr

000080cc <__cxa_guard_release>:
__cxa_guard_release():
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/cxx.cpp:16

    extern "C" void __cxa_guard_release(__guard* g)
    {
    80cc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    80d0:	e28db000 	add	fp, sp, #0
    80d4:	e24dd00c 	sub	sp, sp, #12
    80d8:	e50b0008 	str	r0, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/cxx.cpp:17
        *(char*)g = 1;
    80dc:	e51b3008 	ldr	r3, [fp, #-8]
    80e0:	e3a02001 	mov	r2, #1
    80e4:	e5c32000 	strb	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/cxx.cpp:18
    }
    80e8:	e320f000 	nop	{0}
    80ec:	e28bd000 	add	sp, fp, #0
    80f0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    80f4:	e12fff1e 	bx	lr

000080f8 <__cxa_guard_abort>:
__cxa_guard_abort():
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/cxx.cpp:21

    extern "C" void __cxa_guard_abort(__guard*)
    {
    80f8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    80fc:	e28db000 	add	fp, sp, #0
    8100:	e24dd00c 	sub	sp, sp, #12
    8104:	e50b0008 	str	r0, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/cxx.cpp:22
    }
    8108:	e320f000 	nop	{0}
    810c:	e28bd000 	add	sp, fp, #0
    8110:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8114:	e12fff1e 	bx	lr

00008118 <__dso_handle>:
__dso_handle():
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/cxx.cpp:26
}

extern "C" void __dso_handle()
{
    8118:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    811c:	e28db000 	add	fp, sp, #0
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/cxx.cpp:28
    // ignore dtors for now
}
    8120:	e320f000 	nop	{0}
    8124:	e28bd000 	add	sp, fp, #0
    8128:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    812c:	e12fff1e 	bx	lr

00008130 <__cxa_atexit>:
__cxa_atexit():
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/cxx.cpp:31

extern "C" void __cxa_atexit()
{
    8130:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8134:	e28db000 	add	fp, sp, #0
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/cxx.cpp:33
    // ignore dtors for now
}
    8138:	e320f000 	nop	{0}
    813c:	e28bd000 	add	sp, fp, #0
    8140:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8144:	e12fff1e 	bx	lr

00008148 <__cxa_pure_virtual>:
__cxa_pure_virtual():
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/cxx.cpp:36

extern "C" void __cxa_pure_virtual()
{
    8148:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    814c:	e28db000 	add	fp, sp, #0
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/cxx.cpp:38
    // pure virtual method called
}
    8150:	e320f000 	nop	{0}
    8154:	e28bd000 	add	sp, fp, #0
    8158:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    815c:	e12fff1e 	bx	lr

00008160 <__aeabi_unwind_cpp_pr1>:
__aeabi_unwind_cpp_pr1():
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/cxx.cpp:41

extern "C" void __aeabi_unwind_cpp_pr1()
{
    8160:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8164:	e28db000 	add	fp, sp, #0
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/cxx.cpp:42 (discriminator 1)
    while (true)
    8168:	eafffffe 	b	8168 <__aeabi_unwind_cpp_pr1+0x8>

0000816c <_ZN13CGPIO_HandlerC1Ej>:
_ZN13CGPIO_HandlerC2Ej():
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:6
#include <hal/peripherals.h>
#include <drivers/gpio.h>

CGPIO_Handler sGPIO(hal::GPIO_Base);

CGPIO_Handler::CGPIO_Handler(unsigned int gpio_base_addr)
    816c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8170:	e28db000 	add	fp, sp, #0
    8174:	e24dd00c 	sub	sp, sp, #12
    8178:	e50b0008 	str	r0, [fp, #-8]
    817c:	e50b100c 	str	r1, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:7
: mGPIO(reinterpret_cast<unsigned int*>(gpio_base_addr))
    8180:	e51b200c 	ldr	r2, [fp, #-12]
    8184:	e51b3008 	ldr	r3, [fp, #-8]
    8188:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:10
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
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:13

bool CGPIO_Handler::Get_GPFSEL_Location(uint32_t pin, uint32_t& reg, uint32_t& bit_idx) const
{
    81a0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    81a4:	e28db000 	add	fp, sp, #0
    81a8:	e24dd014 	sub	sp, sp, #20
    81ac:	e50b0008 	str	r0, [fp, #-8]
    81b0:	e50b100c 	str	r1, [fp, #-12]
    81b4:	e50b2010 	str	r2, [fp, #-16]
    81b8:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:14
    if (pin > hal::GPIO_Pin_Count)
    81bc:	e51b300c 	ldr	r3, [fp, #-12]
    81c0:	e3530036 	cmp	r3, #54	; 0x36
    81c4:	9a000001 	bls	81d0 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0x30>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:15
        return false;
    81c8:	e3a03000 	mov	r3, #0
    81cc:	ea000033 	b	82a0 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0x100>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:17

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
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:20
    {
        case 0:
            reg = static_cast<uint32_t>(hal::GPIO_Reg::GPFSEL0);
    8204:	e51b3010 	ldr	r3, [fp, #-16]
    8208:	e3a02000 	mov	r2, #0
    820c:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:21
            break;
    8210:	ea000013 	b	8264 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0xc4>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:23
        case 1:
            reg = static_cast<uint32_t>(hal::GPIO_Reg::GPFSEL1);
    8214:	e51b3010 	ldr	r3, [fp, #-16]
    8218:	e3a02001 	mov	r2, #1
    821c:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:24
            break;
    8220:	ea00000f 	b	8264 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0xc4>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:26
        case 2:
            reg = static_cast<uint32_t>(hal::GPIO_Reg::GPFSEL2);
    8224:	e51b3010 	ldr	r3, [fp, #-16]
    8228:	e3a02002 	mov	r2, #2
    822c:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:27
            break;
    8230:	ea00000b 	b	8264 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0xc4>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:29
        case 3:
            reg = static_cast<uint32_t>(hal::GPIO_Reg::GPFSEL3);
    8234:	e51b3010 	ldr	r3, [fp, #-16]
    8238:	e3a02003 	mov	r2, #3
    823c:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:30
            break;
    8240:	ea000007 	b	8264 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0xc4>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:32
        case 4:
            reg = static_cast<uint32_t>(hal::GPIO_Reg::GPFSEL4);
    8244:	e51b3010 	ldr	r3, [fp, #-16]
    8248:	e3a02004 	mov	r2, #4
    824c:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:33
            break;
    8250:	ea000003 	b	8264 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0xc4>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:35
        case 5:
            reg = static_cast<uint32_t>(hal::GPIO_Reg::GPFSEL5);
    8254:	e51b3010 	ldr	r3, [fp, #-16]
    8258:	e3a02005 	mov	r2, #5
    825c:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:36
            break;
    8260:	e320f000 	nop	{0}
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:39
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
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:41

    return true;
    829c:	e3a03001 	mov	r3, #1
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:42
}
    82a0:	e1a00003 	mov	r0, r3
    82a4:	e28bd000 	add	sp, fp, #0
    82a8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    82ac:	e12fff1e 	bx	lr
    82b0:	cccccccd 	stclgt	12, cr12, [ip], {205}	; 0xcd

000082b4 <_ZNK13CGPIO_Handler18Get_GPCLR_LocationEjRjS0_>:
_ZNK13CGPIO_Handler18Get_GPCLR_LocationEjRjS0_():
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:45

bool CGPIO_Handler::Get_GPCLR_Location(uint32_t pin, uint32_t& reg, uint32_t& bit_idx) const
{
    82b4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    82b8:	e28db000 	add	fp, sp, #0
    82bc:	e24dd014 	sub	sp, sp, #20
    82c0:	e50b0008 	str	r0, [fp, #-8]
    82c4:	e50b100c 	str	r1, [fp, #-12]
    82c8:	e50b2010 	str	r2, [fp, #-16]
    82cc:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:46
    if (pin > hal::GPIO_Pin_Count)
    82d0:	e51b300c 	ldr	r3, [fp, #-12]
    82d4:	e3530036 	cmp	r3, #54	; 0x36
    82d8:	9a000001 	bls	82e4 <_ZNK13CGPIO_Handler18Get_GPCLR_LocationEjRjS0_+0x30>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:47
        return false;
    82dc:	e3a03000 	mov	r3, #0
    82e0:	ea00000c 	b	8318 <_ZNK13CGPIO_Handler18Get_GPCLR_LocationEjRjS0_+0x64>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:49

    reg = static_cast<uint32_t>((pin < 32) ? hal::GPIO_Reg::GPCLR0 : hal::GPIO_Reg::GPCLR1);
    82e4:	e51b300c 	ldr	r3, [fp, #-12]
    82e8:	e353001f 	cmp	r3, #31
    82ec:	8a000001 	bhi	82f8 <_ZNK13CGPIO_Handler18Get_GPCLR_LocationEjRjS0_+0x44>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:49 (discriminator 1)
    82f0:	e3a0200a 	mov	r2, #10
    82f4:	ea000000 	b	82fc <_ZNK13CGPIO_Handler18Get_GPCLR_LocationEjRjS0_+0x48>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:49 (discriminator 2)
    82f8:	e3a0200b 	mov	r2, #11
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:49 (discriminator 4)
    82fc:	e51b3010 	ldr	r3, [fp, #-16]
    8300:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:50 (discriminator 4)
    bit_idx = pin % 32;
    8304:	e51b300c 	ldr	r3, [fp, #-12]
    8308:	e203201f 	and	r2, r3, #31
    830c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8310:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:52 (discriminator 4)

    return true;
    8314:	e3a03001 	mov	r3, #1
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:53
}
    8318:	e1a00003 	mov	r0, r3
    831c:	e28bd000 	add	sp, fp, #0
    8320:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8324:	e12fff1e 	bx	lr

00008328 <_ZNK13CGPIO_Handler18Get_GPSET_LocationEjRjS0_>:
_ZNK13CGPIO_Handler18Get_GPSET_LocationEjRjS0_():
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:56

bool CGPIO_Handler::Get_GPSET_Location(uint32_t pin, uint32_t& reg, uint32_t& bit_idx) const
{
    8328:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    832c:	e28db000 	add	fp, sp, #0
    8330:	e24dd014 	sub	sp, sp, #20
    8334:	e50b0008 	str	r0, [fp, #-8]
    8338:	e50b100c 	str	r1, [fp, #-12]
    833c:	e50b2010 	str	r2, [fp, #-16]
    8340:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:57
    if (pin > hal::GPIO_Pin_Count)
    8344:	e51b300c 	ldr	r3, [fp, #-12]
    8348:	e3530036 	cmp	r3, #54	; 0x36
    834c:	9a000001 	bls	8358 <_ZNK13CGPIO_Handler18Get_GPSET_LocationEjRjS0_+0x30>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:58
        return false;
    8350:	e3a03000 	mov	r3, #0
    8354:	ea00000c 	b	838c <_ZNK13CGPIO_Handler18Get_GPSET_LocationEjRjS0_+0x64>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:60

    reg = static_cast<uint32_t>((pin < 32) ? hal::GPIO_Reg::GPSET0 : hal::GPIO_Reg::GPSET1);
    8358:	e51b300c 	ldr	r3, [fp, #-12]
    835c:	e353001f 	cmp	r3, #31
    8360:	8a000001 	bhi	836c <_ZNK13CGPIO_Handler18Get_GPSET_LocationEjRjS0_+0x44>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:60 (discriminator 1)
    8364:	e3a02007 	mov	r2, #7
    8368:	ea000000 	b	8370 <_ZNK13CGPIO_Handler18Get_GPSET_LocationEjRjS0_+0x48>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:60 (discriminator 2)
    836c:	e3a02008 	mov	r2, #8
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:60 (discriminator 4)
    8370:	e51b3010 	ldr	r3, [fp, #-16]
    8374:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:61 (discriminator 4)
    bit_idx = pin % 32;
    8378:	e51b300c 	ldr	r3, [fp, #-12]
    837c:	e203201f 	and	r2, r3, #31
    8380:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8384:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:63 (discriminator 4)

    return true;
    8388:	e3a03001 	mov	r3, #1
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:64
}
    838c:	e1a00003 	mov	r0, r3
    8390:	e28bd000 	add	sp, fp, #0
    8394:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8398:	e12fff1e 	bx	lr

0000839c <_ZNK13CGPIO_Handler18Get_GPLEV_LocationEjRjS0_>:
_ZNK13CGPIO_Handler18Get_GPLEV_LocationEjRjS0_():
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:67

bool CGPIO_Handler::Get_GPLEV_Location(uint32_t pin, uint32_t& reg, uint32_t& bit_idx) const
{
    839c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    83a0:	e28db000 	add	fp, sp, #0
    83a4:	e24dd014 	sub	sp, sp, #20
    83a8:	e50b0008 	str	r0, [fp, #-8]
    83ac:	e50b100c 	str	r1, [fp, #-12]
    83b0:	e50b2010 	str	r2, [fp, #-16]
    83b4:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:68
    if (pin > hal::GPIO_Pin_Count)
    83b8:	e51b300c 	ldr	r3, [fp, #-12]
    83bc:	e3530036 	cmp	r3, #54	; 0x36
    83c0:	9a000001 	bls	83cc <_ZNK13CGPIO_Handler18Get_GPLEV_LocationEjRjS0_+0x30>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:69
        return false;
    83c4:	e3a03000 	mov	r3, #0
    83c8:	ea00000c 	b	8400 <_ZNK13CGPIO_Handler18Get_GPLEV_LocationEjRjS0_+0x64>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:71

    reg = static_cast<uint32_t>((pin < 32) ? hal::GPIO_Reg::GPLEV0 : hal::GPIO_Reg::GPLEV1);
    83cc:	e51b300c 	ldr	r3, [fp, #-12]
    83d0:	e353001f 	cmp	r3, #31
    83d4:	8a000001 	bhi	83e0 <_ZNK13CGPIO_Handler18Get_GPLEV_LocationEjRjS0_+0x44>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:71 (discriminator 1)
    83d8:	e3a0200d 	mov	r2, #13
    83dc:	ea000000 	b	83e4 <_ZNK13CGPIO_Handler18Get_GPLEV_LocationEjRjS0_+0x48>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:71 (discriminator 2)
    83e0:	e3a0200e 	mov	r2, #14
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:71 (discriminator 4)
    83e4:	e51b3010 	ldr	r3, [fp, #-16]
    83e8:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:72 (discriminator 4)
    bit_idx = pin % 32;
    83ec:	e51b300c 	ldr	r3, [fp, #-12]
    83f0:	e203201f 	and	r2, r3, #31
    83f4:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    83f8:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:74 (discriminator 4)

    return true;
    83fc:	e3a03001 	mov	r3, #1
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:75
}
    8400:	e1a00003 	mov	r0, r3
    8404:	e28bd000 	add	sp, fp, #0
    8408:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    840c:	e12fff1e 	bx	lr

00008410 <_ZN13CGPIO_Handler17Set_GPIO_FunctionEj14NGPIO_Function>:
_ZN13CGPIO_Handler17Set_GPIO_FunctionEj14NGPIO_Function():
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:78

void CGPIO_Handler::Set_GPIO_Function(uint32_t pin, NGPIO_Function func)
{
    8410:	e92d4800 	push	{fp, lr}
    8414:	e28db004 	add	fp, sp, #4
    8418:	e24dd018 	sub	sp, sp, #24
    841c:	e50b0010 	str	r0, [fp, #-16]
    8420:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8424:	e1a03002 	mov	r3, r2
    8428:	e54b3015 	strb	r3, [fp, #-21]	; 0xffffffeb
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:80
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
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:83
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
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:81
        return;
    84ac:	e320f000 	nop	{0}
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:84
}
    84b0:	e24bd004 	sub	sp, fp, #4
    84b4:	e8bd8800 	pop	{fp, pc}

000084b8 <_ZNK13CGPIO_Handler17Get_GPIO_FunctionEj>:
_ZNK13CGPIO_Handler17Get_GPIO_FunctionEj():
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:87

NGPIO_Function CGPIO_Handler::Get_GPIO_Function(uint32_t pin) const
{
    84b8:	e92d4800 	push	{fp, lr}
    84bc:	e28db004 	add	fp, sp, #4
    84c0:	e24dd010 	sub	sp, sp, #16
    84c4:	e50b0010 	str	r0, [fp, #-16]
    84c8:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:89
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
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:90
        return NGPIO_Function::Unspecified;
    84f4:	e3a03008 	mov	r3, #8
    84f8:	ea00000a 	b	8528 <_ZNK13CGPIO_Handler17Get_GPIO_FunctionEj+0x70>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:92

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
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:93 (discriminator 1)
}
    8528:	e1a00003 	mov	r0, r3
    852c:	e24bd004 	sub	sp, fp, #4
    8530:	e8bd8800 	pop	{fp, pc}

00008534 <_ZN13CGPIO_Handler19Enable_Event_DetectEj20NGPIO_Interrupt_Type>:
_ZN13CGPIO_Handler19Enable_Event_DetectEj20NGPIO_Interrupt_Type():
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:96

void CGPIO_Handler::Enable_Event_Detect(uint32_t pin, NGPIO_Interrupt_Type type)
{
    8534:	e92d4800 	push	{fp, lr}
    8538:	e28db004 	add	fp, sp, #4
    853c:	e24dd020 	sub	sp, sp, #32
    8540:	e50b0010 	str	r0, [fp, #-16]
    8544:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8548:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:98
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
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:101
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
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:99
        return;
    85ac:	e320f000 	nop	{0}
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:108
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
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:111

bool CGPIO_Handler::Get_GP_IRQ_Detect_Location(uint32_t pin, NGPIO_Interrupt_Type type, uint32_t& reg, uint32_t& bit_idx) const
{
    85b8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    85bc:	e28db000 	add	fp, sp, #0
    85c0:	e24dd014 	sub	sp, sp, #20
    85c4:	e50b0008 	str	r0, [fp, #-8]
    85c8:	e50b100c 	str	r1, [fp, #-12]
    85cc:	e50b2010 	str	r2, [fp, #-16]
    85d0:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:112
    if (pin > hal::GPIO_Pin_Count)
    85d4:	e51b300c 	ldr	r3, [fp, #-12]
    85d8:	e3530036 	cmp	r3, #54	; 0x36
    85dc:	9a000001 	bls	85e8 <_ZNK13CGPIO_Handler26Get_GP_IRQ_Detect_LocationEj20NGPIO_Interrupt_TypeRjS1_+0x30>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:113
        return false;
    85e0:	e3a03000 	mov	r3, #0
    85e4:	ea000032 	b	86b4 <_ZNK13CGPIO_Handler26Get_GP_IRQ_Detect_LocationEj20NGPIO_Interrupt_TypeRjS1_+0xfc>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:115

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
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:120

    switch (type)
    {
        case NGPIO_Interrupt_Type::Rising_Edge:
            reg = static_cast<uint32_t>((pin < 32) ? hal::GPIO_Reg::GPREN0 : hal::GPIO_Reg::GPREN1);
    8618:	e51b300c 	ldr	r3, [fp, #-12]
    861c:	e353001f 	cmp	r3, #31
    8620:	8a000001 	bhi	862c <_ZNK13CGPIO_Handler26Get_GP_IRQ_Detect_LocationEj20NGPIO_Interrupt_TypeRjS1_+0x74>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:120 (discriminator 1)
    8624:	e3a02013 	mov	r2, #19
    8628:	ea000000 	b	8630 <_ZNK13CGPIO_Handler26Get_GP_IRQ_Detect_LocationEj20NGPIO_Interrupt_TypeRjS1_+0x78>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:120 (discriminator 2)
    862c:	e3a02014 	mov	r2, #20
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:120 (discriminator 4)
    8630:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8634:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:121 (discriminator 4)
            break;
    8638:	ea00001c 	b	86b0 <_ZNK13CGPIO_Handler26Get_GP_IRQ_Detect_LocationEj20NGPIO_Interrupt_TypeRjS1_+0xf8>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:123
        case NGPIO_Interrupt_Type::Falling_Edge:
            reg = static_cast<uint32_t>((pin < 32) ? hal::GPIO_Reg::GPFEN0 : hal::GPIO_Reg::GPFEN1);
    863c:	e51b300c 	ldr	r3, [fp, #-12]
    8640:	e353001f 	cmp	r3, #31
    8644:	8a000001 	bhi	8650 <_ZNK13CGPIO_Handler26Get_GP_IRQ_Detect_LocationEj20NGPIO_Interrupt_TypeRjS1_+0x98>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:123 (discriminator 1)
    8648:	e3a02016 	mov	r2, #22
    864c:	ea000000 	b	8654 <_ZNK13CGPIO_Handler26Get_GP_IRQ_Detect_LocationEj20NGPIO_Interrupt_TypeRjS1_+0x9c>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:123 (discriminator 2)
    8650:	e3a02017 	mov	r2, #23
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:123 (discriminator 4)
    8654:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8658:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:124 (discriminator 4)
            break;
    865c:	ea000013 	b	86b0 <_ZNK13CGPIO_Handler26Get_GP_IRQ_Detect_LocationEj20NGPIO_Interrupt_TypeRjS1_+0xf8>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:126
        case NGPIO_Interrupt_Type::High:
            reg = static_cast<uint32_t>((pin < 32) ? hal::GPIO_Reg::GPHEN0 : hal::GPIO_Reg::GPHEN1);
    8660:	e51b300c 	ldr	r3, [fp, #-12]
    8664:	e353001f 	cmp	r3, #31
    8668:	8a000001 	bhi	8674 <_ZNK13CGPIO_Handler26Get_GP_IRQ_Detect_LocationEj20NGPIO_Interrupt_TypeRjS1_+0xbc>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:126 (discriminator 1)
    866c:	e3a02019 	mov	r2, #25
    8670:	ea000000 	b	8678 <_ZNK13CGPIO_Handler26Get_GP_IRQ_Detect_LocationEj20NGPIO_Interrupt_TypeRjS1_+0xc0>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:126 (discriminator 2)
    8674:	e3a0201a 	mov	r2, #26
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:126 (discriminator 4)
    8678:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    867c:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:127 (discriminator 4)
            break;
    8680:	ea00000a 	b	86b0 <_ZNK13CGPIO_Handler26Get_GP_IRQ_Detect_LocationEj20NGPIO_Interrupt_TypeRjS1_+0xf8>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:129
        case NGPIO_Interrupt_Type::Low:
            reg = static_cast<uint32_t>((pin < 32) ? hal::GPIO_Reg::GPLEN0 : hal::GPIO_Reg::GPLEN1);
    8684:	e51b300c 	ldr	r3, [fp, #-12]
    8688:	e353001f 	cmp	r3, #31
    868c:	8a000001 	bhi	8698 <_ZNK13CGPIO_Handler26Get_GP_IRQ_Detect_LocationEj20NGPIO_Interrupt_TypeRjS1_+0xe0>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:129 (discriminator 1)
    8690:	e3a0201c 	mov	r2, #28
    8694:	ea000000 	b	869c <_ZNK13CGPIO_Handler26Get_GP_IRQ_Detect_LocationEj20NGPIO_Interrupt_TypeRjS1_+0xe4>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:129 (discriminator 2)
    8698:	e3a0201d 	mov	r2, #29
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:129 (discriminator 4)
    869c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    86a0:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:130 (discriminator 4)
            break;
    86a4:	ea000001 	b	86b0 <_ZNK13CGPIO_Handler26Get_GP_IRQ_Detect_LocationEj20NGPIO_Interrupt_TypeRjS1_+0xf8>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:132
        default:
            return false;
    86a8:	e3a03000 	mov	r3, #0
    86ac:	ea000000 	b	86b4 <_ZNK13CGPIO_Handler26Get_GP_IRQ_Detect_LocationEj20NGPIO_Interrupt_TypeRjS1_+0xfc>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:135
    }

    return true;
    86b0:	e3a03001 	mov	r3, #1
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:136
}
    86b4:	e1a00003 	mov	r0, r3
    86b8:	e28bd000 	add	sp, fp, #0
    86bc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    86c0:	e12fff1e 	bx	lr

000086c4 <_ZN13CGPIO_Handler20Disable_Event_DetectEj20NGPIO_Interrupt_Type>:
_ZN13CGPIO_Handler20Disable_Event_DetectEj20NGPIO_Interrupt_Type():
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:139

void CGPIO_Handler::Disable_Event_Detect(uint32_t pin, NGPIO_Interrupt_Type type)
{
    86c4:	e92d4800 	push	{fp, lr}
    86c8:	e28db004 	add	fp, sp, #4
    86cc:	e24dd028 	sub	sp, sp, #40	; 0x28
    86d0:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    86d4:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    86d8:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:141
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
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:144
        return;

    uint32_t val = mGPIO[reg];
    8710:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8714:	e5932000 	ldr	r2, [r3]
    8718:	e51b300c 	ldr	r3, [fp, #-12]
    871c:	e1a03103 	lsl	r3, r3, #2
    8720:	e0823003 	add	r3, r2, r3
    8724:	e5933000 	ldr	r3, [r3]
    8728:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:145
    val &= ~(1 << bit);
    872c:	e51b3010 	ldr	r3, [fp, #-16]
    8730:	e3a02001 	mov	r2, #1
    8734:	e1a03312 	lsl	r3, r2, r3
    8738:	e1e03003 	mvn	r3, r3
    873c:	e1a02003 	mov	r2, r3
    8740:	e51b3008 	ldr	r3, [fp, #-8]
    8744:	e0033002 	and	r3, r3, r2
    8748:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:146
    mGPIO[reg] = val;
    874c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8750:	e5932000 	ldr	r2, [r3]
    8754:	e51b300c 	ldr	r3, [fp, #-12]
    8758:	e1a03103 	lsl	r3, r3, #2
    875c:	e0823003 	add	r3, r2, r3
    8760:	e51b2008 	ldr	r2, [fp, #-8]
    8764:	e5832000 	str	r2, [r3]
    8768:	ea000000 	b	8770 <_ZN13CGPIO_Handler20Disable_Event_DetectEj20NGPIO_Interrupt_Type+0xac>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:142
        return;
    876c:	e320f000 	nop	{0}
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:147
}
    8770:	e24bd004 	sub	sp, fp, #4
    8774:	e8bd8800 	pop	{fp, pc}

00008778 <_ZN13CGPIO_Handler10Set_OutputEjb>:
_ZN13CGPIO_Handler10Set_OutputEjb():
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:150

void CGPIO_Handler::Set_Output(uint32_t pin, bool set)
{
    8778:	e92d4800 	push	{fp, lr}
    877c:	e28db004 	add	fp, sp, #4
    8780:	e24dd018 	sub	sp, sp, #24
    8784:	e50b0010 	str	r0, [fp, #-16]
    8788:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    878c:	e1a03002 	mov	r3, r2
    8790:	e54b3015 	strb	r3, [fp, #-21]	; 0xffffffeb
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:152
    uint32_t reg, bit;
    if (!(set && Get_GPSET_Location(pin, reg, bit)) && !(!set && Get_GPCLR_Location(pin, reg, bit)))
    8794:	e55b3015 	ldrb	r3, [fp, #-21]	; 0xffffffeb
    8798:	e2233001 	eor	r3, r3, #1
    879c:	e6ef3073 	uxtb	r3, r3
    87a0:	e3530000 	cmp	r3, #0
    87a4:	1a000009 	bne	87d0 <_ZN13CGPIO_Handler10Set_OutputEjb+0x58>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:152 (discriminator 2)
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
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:152 (discriminator 3)
    87d0:	e55b3015 	ldrb	r3, [fp, #-21]	; 0xffffffeb
    87d4:	e3530000 	cmp	r3, #0
    87d8:	1a000009 	bne	8804 <_ZN13CGPIO_Handler10Set_OutputEjb+0x8c>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:152 (discriminator 6)
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
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:152 (discriminator 7)
    8804:	e3a03001 	mov	r3, #1
    8808:	ea000000 	b	8810 <_ZN13CGPIO_Handler10Set_OutputEjb+0x98>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:152 (discriminator 8)
    880c:	e3a03000 	mov	r3, #0
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:152 (discriminator 10)
    8810:	e3530000 	cmp	r3, #0
    8814:	1a00000a 	bne	8844 <_ZN13CGPIO_Handler10Set_OutputEjb+0xcc>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:155
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
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:153
        return;
    8844:	e320f000 	nop	{0}
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:156
}
    8848:	e24bd004 	sub	sp, fp, #4
    884c:	e8bd8800 	pop	{fp, pc}

00008850 <_ZNK13CGPIO_Handler18Get_GPEDS_LocationEjRjS0_>:
_ZNK13CGPIO_Handler18Get_GPEDS_LocationEjRjS0_():
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:159

bool CGPIO_Handler::Get_GPEDS_Location(uint32_t pin, uint32_t& reg, uint32_t& bit_idx) const
{
    8850:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8854:	e28db000 	add	fp, sp, #0
    8858:	e24dd014 	sub	sp, sp, #20
    885c:	e50b0008 	str	r0, [fp, #-8]
    8860:	e50b100c 	str	r1, [fp, #-12]
    8864:	e50b2010 	str	r2, [fp, #-16]
    8868:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:160
    if (pin > hal::GPIO_Pin_Count)
    886c:	e51b300c 	ldr	r3, [fp, #-12]
    8870:	e3530036 	cmp	r3, #54	; 0x36
    8874:	9a000001 	bls	8880 <_ZNK13CGPIO_Handler18Get_GPEDS_LocationEjRjS0_+0x30>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:161
        return false;
    8878:	e3a03000 	mov	r3, #0
    887c:	ea00000c 	b	88b4 <_ZNK13CGPIO_Handler18Get_GPEDS_LocationEjRjS0_+0x64>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:163

    reg = static_cast<uint32_t>((pin < 32) ? hal::GPIO_Reg::GPEDS0 : hal::GPIO_Reg::GPEDS1);
    8880:	e51b300c 	ldr	r3, [fp, #-12]
    8884:	e353001f 	cmp	r3, #31
    8888:	8a000001 	bhi	8894 <_ZNK13CGPIO_Handler18Get_GPEDS_LocationEjRjS0_+0x44>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:163 (discriminator 1)
    888c:	e3a02010 	mov	r2, #16
    8890:	ea000000 	b	8898 <_ZNK13CGPIO_Handler18Get_GPEDS_LocationEjRjS0_+0x48>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:163 (discriminator 2)
    8894:	e3a02011 	mov	r2, #17
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:163 (discriminator 4)
    8898:	e51b3010 	ldr	r3, [fp, #-16]
    889c:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:164 (discriminator 4)
    bit_idx = pin % 32;
    88a0:	e51b300c 	ldr	r3, [fp, #-12]
    88a4:	e203201f 	and	r2, r3, #31
    88a8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    88ac:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:166 (discriminator 4)

    return true;
    88b0:	e3a03001 	mov	r3, #1
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:167
}
    88b4:	e1a00003 	mov	r0, r3
    88b8:	e28bd000 	add	sp, fp, #0
    88bc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    88c0:	e12fff1e 	bx	lr

000088c4 <_ZN13CGPIO_Handler20Clear_Detected_EventEj>:
_ZN13CGPIO_Handler20Clear_Detected_EventEj():
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:170

void CGPIO_Handler::Clear_Detected_Event(uint32_t pin)
{
    88c4:	e92d4800 	push	{fp, lr}
    88c8:	e28db004 	add	fp, sp, #4
    88cc:	e24dd010 	sub	sp, sp, #16
    88d0:	e50b0010 	str	r0, [fp, #-16]
    88d4:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:172
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
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:176
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
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:173
        return;
    892c:	e320f000 	nop	{0}
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:177
    8930:	e24bd004 	sub	sp, fp, #4
    8934:	e8bd8800 	pop	{fp, pc}

00008938 <_Z41__static_initialization_and_destruction_0ii>:
_Z41__static_initialization_and_destruction_0ii():
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:177
    8938:	e92d4800 	push	{fp, lr}
    893c:	e28db004 	add	fp, sp, #4
    8940:	e24dd008 	sub	sp, sp, #8
    8944:	e50b0008 	str	r0, [fp, #-8]
    8948:	e50b100c 	str	r1, [fp, #-12]
    894c:	e51b3008 	ldr	r3, [fp, #-8]
    8950:	e3530001 	cmp	r3, #1
    8954:	1a000006 	bne	8974 <_Z41__static_initialization_and_destruction_0ii+0x3c>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:177 (discriminator 1)
    8958:	e51b300c 	ldr	r3, [fp, #-12]
    895c:	e59f201c 	ldr	r2, [pc, #28]	; 8980 <_Z41__static_initialization_and_destruction_0ii+0x48>
    8960:	e1530002 	cmp	r3, r2
    8964:	1a000002 	bne	8974 <_Z41__static_initialization_and_destruction_0ii+0x3c>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:4
CGPIO_Handler sGPIO(hal::GPIO_Base);
    8968:	e59f1014 	ldr	r1, [pc, #20]	; 8984 <_Z41__static_initialization_and_destruction_0ii+0x4c>
    896c:	e59f0014 	ldr	r0, [pc, #20]	; 8988 <_Z41__static_initialization_and_destruction_0ii+0x50>
    8970:	ebfffdfd 	bl	816c <_ZN13CGPIO_HandlerC1Ej>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:177
    8974:	e320f000 	nop	{0}
    8978:	e24bd004 	sub	sp, fp, #4
    897c:	e8bd8800 	pop	{fp, pc}
    8980:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>
    8984:	20200000 	eorcs	r0, r0, r0
    8988:	00008ecc 	andeq	r8, r0, ip, asr #29

0000898c <_GLOBAL__sub_I_sGPIO>:
_GLOBAL__sub_I_sGPIO():
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/drivers/gpio.cpp:177
    898c:	e92d4800 	push	{fp, lr}
    8990:	e28db004 	add	fp, sp, #4
    8994:	e59f1008 	ldr	r1, [pc, #8]	; 89a4 <_GLOBAL__sub_I_sGPIO+0x18>
    8998:	e3a00001 	mov	r0, #1
    899c:	ebffffe5 	bl	8938 <_Z41__static_initialization_and_destruction_0ii>
    89a0:	e8bd8800 	pop	{fp, pc}
    89a4:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>

000089a8 <software_interrupt_handler>:
software_interrupt_handler():
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/interrupt_controller.cpp:7
#include <hal/peripherals.h>
#include <drivers/gpio.h>
#include <interrupt_controller.h>

extern "C" void __attribute__((interrupt("SWI"))) software_interrupt_handler()
{
    89a8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    89ac:	e28db000 	add	fp, sp, #0
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/interrupt_controller.cpp:8
}
    89b0:	e320f000 	nop	{0}
    89b4:	e28bd000 	add	sp, fp, #0
    89b8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    89bc:	e1b0f00e 	movs	pc, lr

000089c0 <irq_handler>:
irq_handler():
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/interrupt_controller.cpp:11

extern "C" void __attribute__((interrupt("IRQ"))) irq_handler()
{
    89c0:	e24ee004 	sub	lr, lr, #4
    89c4:	e92d581f 	push	{r0, r1, r2, r3, r4, fp, ip, lr}
    89c8:	e28db01c 	add	fp, sp, #28
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/interrupt_controller.cpp:13
    static bool status = true;
    sGPIO.Set_Output(47, status);
    89cc:	e59f3040 	ldr	r3, [pc, #64]	; 8a14 <irq_handler+0x54>
    89d0:	e5d33000 	ldrb	r3, [r3]
    89d4:	e1a02003 	mov	r2, r3
    89d8:	e3a0102f 	mov	r1, #47	; 0x2f
    89dc:	e59f0034 	ldr	r0, [pc, #52]	; 8a18 <irq_handler+0x58>
    89e0:	ebffff64 	bl	8778 <_ZN13CGPIO_Handler10Set_OutputEjb>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/interrupt_controller.cpp:14
    status = !status;
    89e4:	e59f3028 	ldr	r3, [pc, #40]	; 8a14 <irq_handler+0x54>
    89e8:	e5d33000 	ldrb	r3, [r3]
    89ec:	e2233001 	eor	r3, r3, #1
    89f0:	e6ef2073 	uxtb	r2, r3
    89f4:	e59f3018 	ldr	r3, [pc, #24]	; 8a14 <irq_handler+0x54>
    89f8:	e5c32000 	strb	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/interrupt_controller.cpp:16

    sGPIO.Clear_Detected_Event(5);
    89fc:	e3a01005 	mov	r1, #5
    8a00:	e59f0010 	ldr	r0, [pc, #16]	; 8a18 <irq_handler+0x58>
    8a04:	ebffffae 	bl	88c4 <_ZN13CGPIO_Handler20Clear_Detected_EventEj>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/interrupt_controller.cpp:17
}
    8a08:	e320f000 	nop	{0}
    8a0c:	e24bd01c 	sub	sp, fp, #28
    8a10:	e8fd981f 	ldm	sp!, {r0, r1, r2, r3, r4, fp, ip, pc}^
    8a14:	00008ec8 	andeq	r8, r0, r8, asr #29
    8a18:	00008ecc 	andeq	r8, r0, ip, asr #29

00008a1c <fast_interrupt_handler>:
fast_interrupt_handler():
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/interrupt_controller.cpp:20

extern "C" void __attribute__((interrupt("FIQ"))) fast_interrupt_handler()
{
    8a1c:	e24db004 	sub	fp, sp, #4
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/interrupt_controller.cpp:21
}
    8a20:	e320f000 	nop	{0}
    8a24:	e28bd004 	add	sp, fp, #4
    8a28:	e25ef004 	subs	pc, lr, #4

00008a2c <_ZN21CInterrupt_ControllerC1Em>:
_ZN21CInterrupt_ControllerC2Em():
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/interrupt_controller.cpp:25

CInterrupt_Controller sInterruptCtl(hal::Interrupt_Controller_Base);

CInterrupt_Controller::CInterrupt_Controller(unsigned long base)
    8a2c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8a30:	e28db000 	add	fp, sp, #0
    8a34:	e24dd00c 	sub	sp, sp, #12
    8a38:	e50b0008 	str	r0, [fp, #-8]
    8a3c:	e50b100c 	str	r1, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/interrupt_controller.cpp:26
: mInterrupt_Regs(reinterpret_cast<unsigned int*>(base))
    8a40:	e51b200c 	ldr	r2, [fp, #-12]
    8a44:	e51b3008 	ldr	r3, [fp, #-8]
    8a48:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/interrupt_controller.cpp:28
{
}
    8a4c:	e51b3008 	ldr	r3, [fp, #-8]
    8a50:	e1a00003 	mov	r0, r3
    8a54:	e28bd000 	add	sp, fp, #0
    8a58:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8a5c:	e12fff1e 	bx	lr

00008a60 <_ZN21CInterrupt_Controller4RegsEN3hal24Interrupt_Controller_RegE>:
_ZN21CInterrupt_Controller4RegsEN3hal24Interrupt_Controller_RegE():
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/interrupt_controller.cpp:31

volatile unsigned int& CInterrupt_Controller::Regs(hal::Interrupt_Controller_Reg reg)
{
    8a60:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8a64:	e28db000 	add	fp, sp, #0
    8a68:	e24dd00c 	sub	sp, sp, #12
    8a6c:	e50b0008 	str	r0, [fp, #-8]
    8a70:	e50b100c 	str	r1, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/interrupt_controller.cpp:32
    return mInterrupt_Regs[static_cast<unsigned int>(reg)];
    8a74:	e51b3008 	ldr	r3, [fp, #-8]
    8a78:	e5932000 	ldr	r2, [r3]
    8a7c:	e51b300c 	ldr	r3, [fp, #-12]
    8a80:	e1a03103 	lsl	r3, r3, #2
    8a84:	e0823003 	add	r3, r2, r3
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/interrupt_controller.cpp:33
}
    8a88:	e1a00003 	mov	r0, r3
    8a8c:	e28bd000 	add	sp, fp, #0
    8a90:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8a94:	e12fff1e 	bx	lr

00008a98 <_ZN21CInterrupt_Controller16Enable_Basic_IRQEN3hal16IRQ_Basic_SourceE>:
_ZN21CInterrupt_Controller16Enable_Basic_IRQEN3hal16IRQ_Basic_SourceE():
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/interrupt_controller.cpp:36

void CInterrupt_Controller::Enable_Basic_IRQ(hal::IRQ_Basic_Source source_idx)
{
    8a98:	e92d4810 	push	{r4, fp, lr}
    8a9c:	e28db008 	add	fp, sp, #8
    8aa0:	e24dd00c 	sub	sp, sp, #12
    8aa4:	e50b0010 	str	r0, [fp, #-16]
    8aa8:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/interrupt_controller.cpp:37
    Regs(hal::Interrupt_Controller_Reg::IRQ_Basic_Enable) = (1 << static_cast<unsigned int>(source_idx));
    8aac:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8ab0:	e3a02001 	mov	r2, #1
    8ab4:	e1a04312 	lsl	r4, r2, r3
    8ab8:	e3a01006 	mov	r1, #6
    8abc:	e51b0010 	ldr	r0, [fp, #-16]
    8ac0:	ebffffe6 	bl	8a60 <_ZN21CInterrupt_Controller4RegsEN3hal24Interrupt_Controller_RegE>
    8ac4:	e1a03000 	mov	r3, r0
    8ac8:	e1a02004 	mov	r2, r4
    8acc:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/interrupt_controller.cpp:38
}
    8ad0:	e320f000 	nop	{0}
    8ad4:	e24bd008 	sub	sp, fp, #8
    8ad8:	e8bd8810 	pop	{r4, fp, pc}

00008adc <_ZN21CInterrupt_Controller17Disable_Basic_IRQEN3hal16IRQ_Basic_SourceE>:
_ZN21CInterrupt_Controller17Disable_Basic_IRQEN3hal16IRQ_Basic_SourceE():
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/interrupt_controller.cpp:41

void CInterrupt_Controller::Disable_Basic_IRQ(hal::IRQ_Basic_Source source_idx)
{
    8adc:	e92d4810 	push	{r4, fp, lr}
    8ae0:	e28db008 	add	fp, sp, #8
    8ae4:	e24dd00c 	sub	sp, sp, #12
    8ae8:	e50b0010 	str	r0, [fp, #-16]
    8aec:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/interrupt_controller.cpp:42
    Regs(hal::Interrupt_Controller_Reg::IRQ_Basic_Disable) = (1 << static_cast<unsigned int>(source_idx));
    8af0:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8af4:	e3a02001 	mov	r2, #1
    8af8:	e1a04312 	lsl	r4, r2, r3
    8afc:	e3a01009 	mov	r1, #9
    8b00:	e51b0010 	ldr	r0, [fp, #-16]
    8b04:	ebffffd5 	bl	8a60 <_ZN21CInterrupt_Controller4RegsEN3hal24Interrupt_Controller_RegE>
    8b08:	e1a03000 	mov	r3, r0
    8b0c:	e1a02004 	mov	r2, r4
    8b10:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/interrupt_controller.cpp:43
}
    8b14:	e320f000 	nop	{0}
    8b18:	e24bd008 	sub	sp, fp, #8
    8b1c:	e8bd8810 	pop	{r4, fp, pc}

00008b20 <_ZN21CInterrupt_Controller10Enable_IRQEN3hal10IRQ_SourceE>:
_ZN21CInterrupt_Controller10Enable_IRQEN3hal10IRQ_SourceE():
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/interrupt_controller.cpp:46

void CInterrupt_Controller::Enable_IRQ(hal::IRQ_Source source_idx)
{
    8b20:	e92d4810 	push	{r4, fp, lr}
    8b24:	e28db008 	add	fp, sp, #8
    8b28:	e24dd014 	sub	sp, sp, #20
    8b2c:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8b30:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/interrupt_controller.cpp:47
    const unsigned int idx_base = static_cast<unsigned int>(source_idx);
    8b34:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8b38:	e50b3010 	str	r3, [fp, #-16]
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/interrupt_controller.cpp:49

    Regs(idx_base < 32 ? hal::Interrupt_Controller_Reg::IRQ_Enable_1 : hal::Interrupt_Controller_Reg::IRQ_Enable_2) = (1 << (idx_base % 32));
    8b3c:	e51b3010 	ldr	r3, [fp, #-16]
    8b40:	e203301f 	and	r3, r3, #31
    8b44:	e3a02001 	mov	r2, #1
    8b48:	e1a04312 	lsl	r4, r2, r3
    8b4c:	e51b3010 	ldr	r3, [fp, #-16]
    8b50:	e353001f 	cmp	r3, #31
    8b54:	8a000001 	bhi	8b60 <_ZN21CInterrupt_Controller10Enable_IRQEN3hal10IRQ_SourceE+0x40>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/interrupt_controller.cpp:49 (discriminator 1)
    8b58:	e3a03004 	mov	r3, #4
    8b5c:	ea000000 	b	8b64 <_ZN21CInterrupt_Controller10Enable_IRQEN3hal10IRQ_SourceE+0x44>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/interrupt_controller.cpp:49 (discriminator 2)
    8b60:	e3a03005 	mov	r3, #5
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/interrupt_controller.cpp:49 (discriminator 4)
    8b64:	e1a01003 	mov	r1, r3
    8b68:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    8b6c:	ebffffbb 	bl	8a60 <_ZN21CInterrupt_Controller4RegsEN3hal24Interrupt_Controller_RegE>
    8b70:	e1a03000 	mov	r3, r0
    8b74:	e1a02004 	mov	r2, r4
    8b78:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/interrupt_controller.cpp:50 (discriminator 4)
}
    8b7c:	e320f000 	nop	{0}
    8b80:	e24bd008 	sub	sp, fp, #8
    8b84:	e8bd8810 	pop	{r4, fp, pc}

00008b88 <_ZN21CInterrupt_Controller11Disable_IRQEN3hal10IRQ_SourceE>:
_ZN21CInterrupt_Controller11Disable_IRQEN3hal10IRQ_SourceE():
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/interrupt_controller.cpp:53

void CInterrupt_Controller::Disable_IRQ(hal::IRQ_Source source_idx)
{
    8b88:	e92d4810 	push	{r4, fp, lr}
    8b8c:	e28db008 	add	fp, sp, #8
    8b90:	e24dd014 	sub	sp, sp, #20
    8b94:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8b98:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/interrupt_controller.cpp:54
    const unsigned int idx_base = static_cast<unsigned int>(source_idx);
    8b9c:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8ba0:	e50b3010 	str	r3, [fp, #-16]
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/interrupt_controller.cpp:56

    Regs(idx_base < 32 ? hal::Interrupt_Controller_Reg::IRQ_Disable_1 : hal::Interrupt_Controller_Reg::IRQ_Disable_2) = (1 << (idx_base % 32));
    8ba4:	e51b3010 	ldr	r3, [fp, #-16]
    8ba8:	e203301f 	and	r3, r3, #31
    8bac:	e3a02001 	mov	r2, #1
    8bb0:	e1a04312 	lsl	r4, r2, r3
    8bb4:	e51b3010 	ldr	r3, [fp, #-16]
    8bb8:	e353001f 	cmp	r3, #31
    8bbc:	8a000001 	bhi	8bc8 <_ZN21CInterrupt_Controller11Disable_IRQEN3hal10IRQ_SourceE+0x40>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/interrupt_controller.cpp:56 (discriminator 1)
    8bc0:	e3a03007 	mov	r3, #7
    8bc4:	ea000000 	b	8bcc <_ZN21CInterrupt_Controller11Disable_IRQEN3hal10IRQ_SourceE+0x44>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/interrupt_controller.cpp:56 (discriminator 2)
    8bc8:	e3a03008 	mov	r3, #8
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/interrupt_controller.cpp:56 (discriminator 4)
    8bcc:	e1a01003 	mov	r1, r3
    8bd0:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    8bd4:	ebffffa1 	bl	8a60 <_ZN21CInterrupt_Controller4RegsEN3hal24Interrupt_Controller_RegE>
    8bd8:	e1a03000 	mov	r3, r0
    8bdc:	e1a02004 	mov	r2, r4
    8be0:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/interrupt_controller.cpp:57 (discriminator 4)
}
    8be4:	e320f000 	nop	{0}
    8be8:	e24bd008 	sub	sp, fp, #8
    8bec:	e8bd8810 	pop	{r4, fp, pc}

00008bf0 <_Z41__static_initialization_and_destruction_0ii>:
_Z41__static_initialization_and_destruction_0ii():
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/interrupt_controller.cpp:57
    8bf0:	e92d4800 	push	{fp, lr}
    8bf4:	e28db004 	add	fp, sp, #4
    8bf8:	e24dd008 	sub	sp, sp, #8
    8bfc:	e50b0008 	str	r0, [fp, #-8]
    8c00:	e50b100c 	str	r1, [fp, #-12]
    8c04:	e51b3008 	ldr	r3, [fp, #-8]
    8c08:	e3530001 	cmp	r3, #1
    8c0c:	1a000006 	bne	8c2c <_Z41__static_initialization_and_destruction_0ii+0x3c>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/interrupt_controller.cpp:57 (discriminator 1)
    8c10:	e51b300c 	ldr	r3, [fp, #-12]
    8c14:	e59f201c 	ldr	r2, [pc, #28]	; 8c38 <_Z41__static_initialization_and_destruction_0ii+0x48>
    8c18:	e1530002 	cmp	r3, r2
    8c1c:	1a000002 	bne	8c2c <_Z41__static_initialization_and_destruction_0ii+0x3c>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/interrupt_controller.cpp:23
CInterrupt_Controller sInterruptCtl(hal::Interrupt_Controller_Base);
    8c20:	e59f1014 	ldr	r1, [pc, #20]	; 8c3c <_Z41__static_initialization_and_destruction_0ii+0x4c>
    8c24:	e59f0014 	ldr	r0, [pc, #20]	; 8c40 <_Z41__static_initialization_and_destruction_0ii+0x50>
    8c28:	ebffff7f 	bl	8a2c <_ZN21CInterrupt_ControllerC1Em>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/interrupt_controller.cpp:57
}
    8c2c:	e320f000 	nop	{0}
    8c30:	e24bd004 	sub	sp, fp, #4
    8c34:	e8bd8800 	pop	{fp, pc}
    8c38:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>
    8c3c:	2000b200 	andcs	fp, r0, r0, lsl #4
    8c40:	00008ed0 	ldrdeq	r8, [r0], -r0

00008c44 <_GLOBAL__sub_I_software_interrupt_handler>:
_GLOBAL__sub_I_software_interrupt_handler():
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/interrupt_controller.cpp:57
    8c44:	e92d4800 	push	{fp, lr}
    8c48:	e28db004 	add	fp, sp, #4
    8c4c:	e59f1008 	ldr	r1, [pc, #8]	; 8c5c <_GLOBAL__sub_I_software_interrupt_handler+0x18>
    8c50:	e3a00001 	mov	r0, #1
    8c54:	ebffffe5 	bl	8bf0 <_Z41__static_initialization_and_destruction_0ii>
    8c58:	e8bd8800 	pop	{fp, pc}
    8c5c:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>

00008c60 <_kernel_main>:
_kernel_main():
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/main.cpp:5
#include <drivers/gpio.h>
#include <interrupt_controller.h>

extern "C" int _kernel_main(void)
{
    8c60:	e92d4800 	push	{fp, lr}
    8c64:	e28db004 	add	fp, sp, #4
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/main.cpp:6
    sGPIO.Set_GPIO_Function(47, NGPIO_Function::Output);
    8c68:	e3a02001 	mov	r2, #1
    8c6c:	e3a0102f 	mov	r1, #47	; 0x2f
    8c70:	e59f0044 	ldr	r0, [pc, #68]	; 8cbc <_kernel_main+0x5c>
    8c74:	ebfffde5 	bl	8410 <_ZN13CGPIO_Handler17Set_GPIO_FunctionEj14NGPIO_Function>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/main.cpp:7
    sGPIO.Set_GPIO_Function(5, NGPIO_Function::Input);
    8c78:	e3a02000 	mov	r2, #0
    8c7c:	e3a01005 	mov	r1, #5
    8c80:	e59f0034 	ldr	r0, [pc, #52]	; 8cbc <_kernel_main+0x5c>
    8c84:	ebfffde1 	bl	8410 <_ZN13CGPIO_Handler17Set_GPIO_FunctionEj14NGPIO_Function>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/main.cpp:9

    sGPIO.Enable_Event_Detect(5, NGPIO_Interrupt_Type::Rising_Edge);
    8c88:	e3a02000 	mov	r2, #0
    8c8c:	e3a01005 	mov	r1, #5
    8c90:	e59f0024 	ldr	r0, [pc, #36]	; 8cbc <_kernel_main+0x5c>
    8c94:	ebfffe26 	bl	8534 <_ZN13CGPIO_Handler19Enable_Event_DetectEj20NGPIO_Interrupt_Type>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/main.cpp:10
    sGPIO.Enable_Event_Detect(5, NGPIO_Interrupt_Type::Falling_Edge);
    8c98:	e3a02001 	mov	r2, #1
    8c9c:	e3a01005 	mov	r1, #5
    8ca0:	e59f0014 	ldr	r0, [pc, #20]	; 8cbc <_kernel_main+0x5c>
    8ca4:	ebfffe22 	bl	8534 <_ZN13CGPIO_Handler19Enable_Event_DetectEj20NGPIO_Interrupt_Type>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/main.cpp:12

    sInterruptCtl.Enable_IRQ(hal::IRQ_Source::GPIO_0);
    8ca8:	e3a01031 	mov	r1, #49	; 0x31
    8cac:	e59f000c 	ldr	r0, [pc, #12]	; 8cc0 <_kernel_main+0x60>
    8cb0:	ebffff9a 	bl	8b20 <_ZN21CInterrupt_Controller10Enable_IRQEN3hal10IRQ_SourceE>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/main.cpp:14

    enable_irq();
    8cb4:	eb000002 	bl	8cc4 <enable_irq>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/main.cpp:16 (discriminator 1)

    while (1)
    8cb8:	eafffffe 	b	8cb8 <_kernel_main+0x58>
    8cbc:	00008ecc 	andeq	r8, r0, ip, asr #29
    8cc0:	00008ed0 	ldrdeq	r8, [r0], -r0

00008cc4 <enable_irq>:
enable_irq():
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/start.s:90
;@ tady budou ostatni symboly, ktere nevyzaduji zadne specialni misto
.section .text

.global enable_irq
enable_irq:
    mrs r0, cpsr		;@ presun ridiciho registru (CPSR) do general purpose registru (R0)
    8cc4:	e10f0000 	mrs	r0, CPSR
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/start.s:91
    bic r0, r0, #0x80	;@ vypne bit 7 v registru r0 ("IRQ mask bit")
    8cc8:	e3c00080 	bic	r0, r0, #128	; 0x80
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/start.s:92
    msr cpsr_c, r0		;@ nacteme upraveny general purpose (R0) registr do ridiciho (CPSR)
    8ccc:	e121f000 	msr	CPSR_c, r0
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/start.s:93
    cpsie i				;@ povoli preruseni
    8cd0:	f1080080 	cpsie	i
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/start.s:94
    bx lr
    8cd4:	e12fff1e 	bx	lr

00008cd8 <undefined_instruction_handler>:
undefined_instruction_handler():
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/start.s:97

undefined_instruction_handler:
	b hang
    8cd8:	eafffcec 	b	8090 <hang>

00008cdc <prefetch_abort_handler>:
prefetch_abort_handler():
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/start.s:102

prefetch_abort_handler:
	;@ tady pak muzeme osetrit, kdyz program zasahne do mista, ktere nema mapovane ve svem virtualnim adr. prostoru
	;@ a treba vyvolat nasi obdobu segfaultu
	b hang
    8cdc:	eafffceb 	b	8090 <hang>

00008ce0 <data_abort_handler>:
data_abort_handler():
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/start.s:107

data_abort_handler:
	;@ tady pak muzeme osetrit, kdyz program zasahne do mista, ktere nema mapovane ve svem virtualnim adr. prostoru
	;@ a treba vyvolat nasi obdobu segfaultu
	b hang
    8ce0:	eafffcea 	b	8090 <hang>

00008ce4 <_c_startup>:
_c_startup():
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/startup.cpp:21
extern "C" dtor_ptr __DTOR_LIST__[0];
// konec pole destruktoru
extern "C" dtor_ptr __DTOR_END__[0];

extern "C" int _c_startup(void)
{
    8ce4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8ce8:	e28db000 	add	fp, sp, #0
    8cec:	e24dd00c 	sub	sp, sp, #12
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/startup.cpp:25
    int* i;

    // vynulujeme .bss sekci
    for (i = (int*)_bss_start; i < (int*)_bss_end; i++)
    8cf0:	e59f304c 	ldr	r3, [pc, #76]	; 8d44 <_c_startup+0x60>
    8cf4:	e5933000 	ldr	r3, [r3]
    8cf8:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/startup.cpp:25 (discriminator 3)
    8cfc:	e59f3044 	ldr	r3, [pc, #68]	; 8d48 <_c_startup+0x64>
    8d00:	e5933000 	ldr	r3, [r3]
    8d04:	e1a02003 	mov	r2, r3
    8d08:	e51b3008 	ldr	r3, [fp, #-8]
    8d0c:	e1530002 	cmp	r3, r2
    8d10:	2a000006 	bcs	8d30 <_c_startup+0x4c>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/startup.cpp:26 (discriminator 2)
        *i = 0;
    8d14:	e51b3008 	ldr	r3, [fp, #-8]
    8d18:	e3a02000 	mov	r2, #0
    8d1c:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/startup.cpp:25 (discriminator 2)
    for (i = (int*)_bss_start; i < (int*)_bss_end; i++)
    8d20:	e51b3008 	ldr	r3, [fp, #-8]
    8d24:	e2833004 	add	r3, r3, #4
    8d28:	e50b3008 	str	r3, [fp, #-8]
    8d2c:	eafffff2 	b	8cfc <_c_startup+0x18>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/startup.cpp:28

    return 0;
    8d30:	e3a03000 	mov	r3, #0
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/startup.cpp:29
}
    8d34:	e1a00003 	mov	r0, r3
    8d38:	e28bd000 	add	sp, fp, #0
    8d3c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8d40:	e12fff1e 	bx	lr
    8d44:	00008ecc 	andeq	r8, r0, ip, asr #29
    8d48:	00008ee4 	andeq	r8, r0, r4, ror #29

00008d4c <_cpp_startup>:
_cpp_startup():
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/startup.cpp:32

extern "C" int _cpp_startup(void)
{
    8d4c:	e92d4800 	push	{fp, lr}
    8d50:	e28db004 	add	fp, sp, #4
    8d54:	e24dd008 	sub	sp, sp, #8
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/startup.cpp:37
    ctor_ptr* fnptr;

    // zavolame konstruktory globalnich C++ trid
    // v poli __CTOR_LIST__ jsou ukazatele na vygenerovane stuby volani konstruktoru
    for (fnptr = __CTOR_LIST__; fnptr < __CTOR_END__; fnptr++)
    8d58:	e59f303c 	ldr	r3, [pc, #60]	; 8d9c <_cpp_startup+0x50>
    8d5c:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/startup.cpp:37 (discriminator 3)
    8d60:	e51b3008 	ldr	r3, [fp, #-8]
    8d64:	e59f2034 	ldr	r2, [pc, #52]	; 8da0 <_cpp_startup+0x54>
    8d68:	e1530002 	cmp	r3, r2
    8d6c:	2a000006 	bcs	8d8c <_cpp_startup+0x40>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/startup.cpp:38 (discriminator 2)
        (*fnptr)();
    8d70:	e51b3008 	ldr	r3, [fp, #-8]
    8d74:	e5933000 	ldr	r3, [r3]
    8d78:	e12fff33 	blx	r3
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/startup.cpp:37 (discriminator 2)
    for (fnptr = __CTOR_LIST__; fnptr < __CTOR_END__; fnptr++)
    8d7c:	e51b3008 	ldr	r3, [fp, #-8]
    8d80:	e2833004 	add	r3, r3, #4
    8d84:	e50b3008 	str	r3, [fp, #-8]
    8d88:	eafffff4 	b	8d60 <_cpp_startup+0x14>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/startup.cpp:40

    return 0;
    8d8c:	e3a03000 	mov	r3, #0
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/startup.cpp:41
}
    8d90:	e1a00003 	mov	r0, r3
    8d94:	e24bd004 	sub	sp, fp, #4
    8d98:	e8bd8800 	pop	{fp, pc}
    8d9c:	00008ec0 	andeq	r8, r0, r0, asr #29
    8da0:	00008ec8 	andeq	r8, r0, r8, asr #29

00008da4 <_cpp_shutdown>:
_cpp_shutdown():
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/startup.cpp:44

extern "C" int _cpp_shutdown(void)
{
    8da4:	e92d4800 	push	{fp, lr}
    8da8:	e28db004 	add	fp, sp, #4
    8dac:	e24dd008 	sub	sp, sp, #8
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/startup.cpp:48
    dtor_ptr* fnptr;

    // zavolame destruktory globalnich C++ trid
    for (fnptr = __DTOR_LIST__; fnptr < __DTOR_END__; fnptr++)
    8db0:	e59f303c 	ldr	r3, [pc, #60]	; 8df4 <_cpp_shutdown+0x50>
    8db4:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/startup.cpp:48 (discriminator 3)
    8db8:	e51b3008 	ldr	r3, [fp, #-8]
    8dbc:	e59f2034 	ldr	r2, [pc, #52]	; 8df8 <_cpp_shutdown+0x54>
    8dc0:	e1530002 	cmp	r3, r2
    8dc4:	2a000006 	bcs	8de4 <_cpp_shutdown+0x40>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/startup.cpp:49 (discriminator 2)
        (*fnptr)();
    8dc8:	e51b3008 	ldr	r3, [fp, #-8]
    8dcc:	e5933000 	ldr	r3, [r3]
    8dd0:	e12fff33 	blx	r3
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/startup.cpp:48 (discriminator 2)
    for (fnptr = __DTOR_LIST__; fnptr < __DTOR_END__; fnptr++)
    8dd4:	e51b3008 	ldr	r3, [fp, #-8]
    8dd8:	e2833004 	add	r3, r3, #4
    8ddc:	e50b3008 	str	r3, [fp, #-8]
    8de0:	eafffff4 	b	8db8 <_cpp_shutdown+0x14>
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/startup.cpp:51

    return 0;
    8de4:	e3a03000 	mov	r3, #0
/home/silhavyj/School/ZeroMate/examples/09-GPIO_interrupt/kernel/src/startup.cpp:52
}
    8de8:	e1a00003 	mov	r0, r3
    8dec:	e24bd004 	sub	sp, fp, #4
    8df0:	e8bd8800 	pop	{fp, pc}
    8df4:	00008ec8 	andeq	r8, r0, r8, asr #29
    8df8:	00008ec8 	andeq	r8, r0, r8, asr #29

Disassembly of section .ARM.extab:

00008dfc <.ARM.extab>:
    8dfc:	81019b46 	tsthi	r1, r6, asr #22
    8e00:	b10f8581 	smlabblt	pc, r1, r5, r8	; <UNPREDICTABLE>
    8e04:	00000000 	andeq	r0, r0, r0
    8e08:	81019b40 	tsthi	r1, r0, asr #22
    8e0c:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    8e10:	00000000 	andeq	r0, r0, r0
    8e14:	81019b40 	tsthi	r1, r0, asr #22
    8e18:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    8e1c:	00000000 	andeq	r0, r0, r0
    8e20:	81019b40 	tsthi	r1, r0, asr #22
    8e24:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    8e28:	00000000 	andeq	r0, r0, r0

Disassembly of section .ARM.exidx:

00008e2c <.ARM.exidx>:
    8e2c:	7ffff268 	svcvc	0x00fff268
    8e30:	00000001 	andeq	r0, r0, r1
    8e34:	7ffffb8c 	svcvc	0x00fffb8c
    8e38:	7fffffc4 	svcvc	0x00ffffc4
    8e3c:	7ffffbe0 	svcvc	0x00fffbe0
    8e40:	00000001 	andeq	r0, r0, r1
    8e44:	7ffffe1c 	svcvc	0x00fffe1c
    8e48:	7fffffc0 	svcvc	0x00ffffc0
    8e4c:	7ffffe78 	svcvc	0x00fffe78
    8e50:	00000001 	andeq	r0, r0, r1
    8e54:	7ffffef8 	svcvc	0x00fffef8
    8e58:	7fffffbc 	svcvc	0x00ffffbc
    8e5c:	7fffff48 	svcvc	0x00ffff48
    8e60:	7fffffc0 	svcvc	0x00ffffc0
    8e64:	7fffff98 	svcvc	0x00ffff98
    8e68:	00000001 	andeq	r0, r0, r1

Disassembly of section .rodata:

00008e6c <_ZN3halL18Default_Clock_RateE>:
    8e6c:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

00008e70 <_ZN3halL15Peripheral_BaseE>:
    8e70:	20000000 	andcs	r0, r0, r0

00008e74 <_ZN3halL9GPIO_BaseE>:
    8e74:	20200000 	eorcs	r0, r0, r0

00008e78 <_ZN3halL14GPIO_Pin_CountE>:
    8e78:	00000036 	andeq	r0, r0, r6, lsr r0

00008e7c <_ZN3halL8AUX_BaseE>:
    8e7c:	20215000 	eorcs	r5, r1, r0

00008e80 <_ZN3halL25Interrupt_Controller_BaseE>:
    8e80:	2000b200 	andcs	fp, r0, r0, lsl #4

00008e84 <_ZN3halL10Timer_BaseE>:
    8e84:	2000b400 	andcs	fp, r0, r0, lsl #8

00008e88 <_ZN3halL18Default_Clock_RateE>:
    8e88:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

00008e8c <_ZN3halL15Peripheral_BaseE>:
    8e8c:	20000000 	andcs	r0, r0, r0

00008e90 <_ZN3halL9GPIO_BaseE>:
    8e90:	20200000 	eorcs	r0, r0, r0

00008e94 <_ZN3halL14GPIO_Pin_CountE>:
    8e94:	00000036 	andeq	r0, r0, r6, lsr r0

00008e98 <_ZN3halL8AUX_BaseE>:
    8e98:	20215000 	eorcs	r5, r1, r0

00008e9c <_ZN3halL25Interrupt_Controller_BaseE>:
    8e9c:	2000b200 	andcs	fp, r0, r0, lsl #4

00008ea0 <_ZN3halL10Timer_BaseE>:
    8ea0:	2000b400 	andcs	fp, r0, r0, lsl #8

00008ea4 <_ZN3halL18Default_Clock_RateE>:
    8ea4:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

00008ea8 <_ZN3halL15Peripheral_BaseE>:
    8ea8:	20000000 	andcs	r0, r0, r0

00008eac <_ZN3halL9GPIO_BaseE>:
    8eac:	20200000 	eorcs	r0, r0, r0

00008eb0 <_ZN3halL14GPIO_Pin_CountE>:
    8eb0:	00000036 	andeq	r0, r0, r6, lsr r0

00008eb4 <_ZN3halL8AUX_BaseE>:
    8eb4:	20215000 	eorcs	r5, r1, r0

00008eb8 <_ZN3halL25Interrupt_Controller_BaseE>:
    8eb8:	2000b200 	andcs	fp, r0, r0, lsl #4

00008ebc <_ZN3halL10Timer_BaseE>:
    8ebc:	2000b400 	andcs	fp, r0, r0, lsl #8

Disassembly of section .data:

00008ec0 <__CTOR_LIST__>:
    8ec0:	0000898c 	andeq	r8, r0, ip, lsl #19
    8ec4:	00008c44 	andeq	r8, r0, r4, asr #24

00008ec8 <__DTOR_LIST__>:
__DTOR_END__():
    8ec8:	Address 0x0000000000008ec8 is out of bounds.


Disassembly of section .bss:

00008ecc <sGPIO>:
_bss_start():
    8ecc:	00000000 	andeq	r0, r0, r0

00008ed0 <sInterruptCtl>:
	...

Disassembly of section .debug_info:

00000000 <.debug_info>:
       0:	00000126 	andeq	r0, r0, r6, lsr #2
       4:	00000004 	andeq	r0, r0, r4
       8:	01040000 	mrseq	r0, (UNDEF: 4)
       c:	00000000 	andeq	r0, r0, r0
      10:	0000ca04 	andeq	ip, r0, r4, lsl #20
      14:	00017500 	andeq	r7, r1, r0, lsl #10
      18:	00809400 	addeq	r9, r0, r0, lsl #8
      1c:	0000d800 	andeq	sp, r0, r0, lsl #16
      20:	00000000 	andeq	r0, r0, r0
      24:	01b50200 			; <UNDEFINED> instruction: 0x01b50200
      28:	28010000 	stmdacs	r1, {}	; <UNPREDICTABLE>
      2c:	00816011 	addeq	r6, r1, r1, lsl r0
      30:	00000c00 	andeq	r0, r0, r0, lsl #24
      34:	029c0100 	addseq	r0, ip, #0, 2
      38:	00000162 	andeq	r0, r0, r2, ror #2
      3c:	48112301 	ldmdami	r1, {r0, r8, r9, sp}
      40:	18000081 	stmdane	r0, {r0, r7}
      44:	01000000 	mrseq	r0, (UNDEF: 0)
      48:	0136029c 	teqeq	r6, ip	; <illegal shifter operand>
      4c:	1e010000 	cdpne	0, 0, cr0, cr1, cr0, {0}
      50:	00813011 	addeq	r3, r1, r1, lsl r0
      54:	00001800 	andeq	r1, r0, r0, lsl #16
      58:	029c0100 	addseq	r0, ip, #0, 2
      5c:	00000129 	andeq	r0, r0, r9, lsr #2
      60:	18111901 	ldmdane	r1, {r0, r8, fp, ip}
      64:	18000081 	stmdane	r0, {r0, r7}
      68:	01000000 	mrseq	r0, (UNDEF: 0)
      6c:	0157039c 			; <UNDEFINED> instruction: 0x0157039c
      70:	00020000 	andeq	r0, r2, r0
      74:	000000bb 	strheq	r0, [r0], -fp
      78:	00011704 	andeq	r1, r1, r4, lsl #14
      7c:	15140100 	ldrne	r0, [r4, #-256]	; 0xffffff00
      80:	0000008a 	andeq	r0, r0, sl, lsl #1
      84:	0000bb05 	andeq	fp, r0, r5, lsl #22
      88:	cc060000 	stcgt	0, cr0, [r6], {-0}
      8c:	01000001 	tsteq	r0, r1
      90:	00c11f04 	sbceq	r1, r1, r4, lsl #30
      94:	b6040000 	strlt	r0, [r4], -r0
      98:	01000000 	mrseq	r0, (UNDEF: 0)
      9c:	00a8150f 	adceq	r1, r8, pc, lsl #10
      a0:	bb050000 	bllt	1400a8 <_bss_end+0x1371c4>
      a4:	00000000 	andeq	r0, r0, r0
      a8:	00014307 	andeq	r4, r1, r7, lsl #6
      ac:	140a0100 	strne	r0, [sl], #-256	; 0xffffff00
      b0:	00000105 	andeq	r0, r0, r5, lsl #2
      b4:	0000bb05 	andeq	fp, r0, r5, lsl #22
      b8:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
      bc:	00008a04 	andeq	r8, r0, r4, lsl #20
      c0:	05080900 	streq	r0, [r8, #-2304]	; 0xfffff700
      c4:	000001d4 	ldrdeq	r0, [r0], -r4
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
     11c:	0a010067 	beq	402c0 <_bss_end+0x373dc>
     120:	0000bb31 	andeq	fp, r0, r1, lsr fp
     124:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     128:	099f0000 	ldmibeq	pc, {}	; <UNPREDICTABLE>
     12c:	00040000 	andeq	r0, r4, r0
     130:	000000d0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     134:	00000104 	andeq	r0, r0, r4, lsl #2
     138:	9d040000 	stcls	0, cr0, [r4, #-0]
     13c:	75000003 	strvc	r0, [r0, #-3]
     140:	6c000001 	stcvs	0, cr0, [r0], {1}
     144:	3c000081 	stccc	0, cr0, [r0], {129}	; 0x81
     148:	ae000008 	cdpge	0, 0, cr0, cr0, cr8, {0}
     14c:	02000000 	andeq	r0, r0, #0
     150:	058b0801 	streq	r0, [fp, #2049]	; 0x801
     154:	02020000 	andeq	r0, r2, #0
     158:	0002a305 	andeq	sl, r2, r5, lsl #6
     15c:	05040300 	streq	r0, [r4, #-768]	; 0xfffffd00
     160:	00746e69 	rsbseq	r6, r4, r9, ror #28
     164:	00037e04 	andeq	r7, r3, r4, lsl #28
     168:	07090200 	streq	r0, [r9, -r0, lsl #4]
     16c:	00000046 	andeq	r0, r0, r6, asr #32
     170:	82080102 	andhi	r0, r8, #-2147483648	; 0x80000000
     174:	02000005 	andeq	r0, r0, #5
     178:	05e30702 	strbeq	r0, [r3, #1794]!	; 0x702
     17c:	94040000 	strls	r0, [r4], #-0
     180:	02000003 	andeq	r0, r0, #3
     184:	0065070b 	rsbeq	r0, r5, fp, lsl #14
     188:	54050000 	strpl	r0, [r5], #-0
     18c:	02000000 	andeq	r0, r0, #0
     190:	12600704 	rsbne	r0, r0, #4, 14	; 0x100000
     194:	65050000 	strvs	r0, [r5, #-0]
     198:	06000000 	streq	r0, [r0], -r0
     19c:	006c6168 	rsbeq	r6, ip, r8, ror #2
     1a0:	ac0b0703 	stcge	7, cr0, [fp], {3}
     1a4:	07000001 	streq	r0, [r0, -r1]
     1a8:	000007fa 	strdeq	r0, [r0], -sl
     1ac:	6c1c0903 			; <UNDEFINED> instruction: 0x6c1c0903
     1b0:	80000000 	andhi	r0, r0, r0
     1b4:	070ee6b2 			; <UNDEFINED> instruction: 0x070ee6b2
     1b8:	000004d1 	ldrdeq	r0, [r0], -r1
     1bc:	b81d0c03 	ldmdalt	sp, {r0, r1, sl, fp}
     1c0:	00000001 	andeq	r0, r0, r1
     1c4:	07200000 	streq	r0, [r0, -r0]!
     1c8:	000005a5 	andeq	r0, r0, r5, lsr #11
     1cc:	b81d0f03 	ldmdalt	sp, {r0, r1, r8, r9, sl, fp}
     1d0:	00000001 	andeq	r0, r0, r1
     1d4:	08202000 	stmdaeq	r0!, {sp}
     1d8:	00000654 	andeq	r0, r0, r4, asr r6
     1dc:	60181203 	andsvs	r1, r8, r3, lsl #4
     1e0:	36000000 	strcc	r0, [r0], -r0
     1e4:	00069d09 	andeq	r9, r6, r9, lsl #26
     1e8:	33040500 	movwcc	r0, #17664	; 0x4500
     1ec:	03000000 	movweq	r0, #0
     1f0:	017b1015 	cmneq	fp, r5, lsl r0
     1f4:	1f0a0000 	svcne	0x000a0000
     1f8:	00000002 	andeq	r0, r0, r2
     1fc:	0002270a 	andeq	r2, r2, sl, lsl #14
     200:	2f0a0100 	svccs	0x000a0100
     204:	02000002 	andeq	r0, r0, #2
     208:	0002370a 	andeq	r3, r2, sl, lsl #14
     20c:	3f0a0300 	svccc	0x000a0300
     210:	04000002 	streq	r0, [r0], #-2
     214:	0002470a 	andeq	r4, r2, sl, lsl #14
     218:	110a0500 	tstne	sl, r0, lsl #10
     21c:	07000002 	streq	r0, [r0, -r2]
     220:	0002180a 	andeq	r1, r2, sl, lsl #16
     224:	1f0a0800 	svcne	0x000a0800
     228:	0a000008 	beq	250 <CPSR_IRQ_INHIBIT+0x1d0>
     22c:	0005af0a 	andeq	sl, r5, sl, lsl #30
     230:	360a0b00 	strcc	r0, [sl], -r0, lsl #22
     234:	0d000007 	stceq	0, cr0, [r0, #-28]	; 0xffffffe4
     238:	00073d0a 	andeq	r3, r7, sl, lsl #26
     23c:	860a0e00 	strhi	r0, [sl], -r0, lsl #28
     240:	10000003 	andne	r0, r0, r3
     244:	00038d0a 	andeq	r8, r3, sl, lsl #26
     248:	010a1100 	mrseq	r1, (UNDEF: 26)
     24c:	13000003 	movwne	r0, #3
     250:	0003080a 	andeq	r0, r3, sl, lsl #16
     254:	ba0a1400 	blt	28525c <_bss_end+0x27c378>
     258:	16000007 	strne	r0, [r0], -r7
     25c:	00024f0a 	andeq	r4, r2, sl, lsl #30
     260:	c60a1700 	strgt	r1, [sl], -r0, lsl #14
     264:	19000005 	stmdbne	r0, {r0, r2}
     268:	0005cd0a 	andeq	ip, r5, sl, lsl #26
     26c:	190a1a00 	stmdbne	sl, {r9, fp, ip}
     270:	1c000004 	stcne	0, cr0, [r0], {4}
     274:	0005f60a 	andeq	pc, r5, sl, lsl #12
     278:	b60a1d00 	strlt	r1, [sl], -r0, lsl #26
     27c:	1f000005 	svcne	0x00000005
     280:	0005be0a 	andeq	fp, r5, sl, lsl #28
     284:	430a2000 	movwmi	r2, #40960	; 0xa000
     288:	22000005 	andcs	r0, r0, #5
     28c:	00054b0a 	andeq	r4, r5, sl, lsl #22
     290:	a00a2300 	andge	r2, sl, r0, lsl #6
     294:	25000004 	strcs	r0, [r0, #-4]
     298:	0002ad0a 	andeq	sl, r2, sl, lsl #26
     29c:	b70a2600 	strlt	r2, [sl, -r0, lsl #12]
     2a0:	27000002 	strcs	r0, [r0, -r2]
     2a4:	07980700 	ldreq	r0, [r8, r0, lsl #14]
     2a8:	44030000 	strmi	r0, [r3], #-0
     2ac:	0001b81d 	andeq	fp, r1, sp, lsl r8
     2b0:	21500000 	cmpcs	r0, r0
     2b4:	02560720 	subseq	r0, r6, #32, 14	; 0x800000
     2b8:	73030000 	movwvc	r0, #12288	; 0x3000
     2bc:	0001b81d 	andeq	fp, r1, sp, lsl r8
     2c0:	00b20000 	adcseq	r0, r2, r0
     2c4:	06680720 	strbteq	r0, [r8], -r0, lsr #14
     2c8:	a6030000 	strge	r0, [r3], -r0
     2cc:	0001b81d 	andeq	fp, r1, sp, lsl r8
     2d0:	00b40000 	adcseq	r0, r4, r0
     2d4:	7d0b0020 	stcvc	0, cr0, [fp, #-128]	; 0xffffff80
     2d8:	02000000 	andeq	r0, r0, #0
     2dc:	125b0704 	subsne	r0, fp, #4, 14	; 0x100000
     2e0:	b1050000 	mrslt	r0, (UNDEF: 5)
     2e4:	0b000001 	bleq	2f0 <CPSR_IRQ_INHIBIT+0x270>
     2e8:	0000008d 	andeq	r0, r0, sp, lsl #1
     2ec:	00009d0b 	andeq	r9, r0, fp, lsl #26
     2f0:	00ad0b00 	adceq	r0, sp, r0, lsl #22
     2f4:	7b0b0000 	blvc	2c02fc <_bss_end+0x2b7418>
     2f8:	0b000001 	bleq	304 <CPSR_IRQ_INHIBIT+0x284>
     2fc:	0000018b 	andeq	r0, r0, fp, lsl #3
     300:	00019b0b 	andeq	r9, r1, fp, lsl #22
     304:	07150900 	ldreq	r0, [r5, -r0, lsl #18]
     308:	01070000 	mrseq	r0, (UNDEF: 7)
     30c:	0000003a 	andeq	r0, r0, sl, lsr r0
     310:	240c0604 	strcs	r0, [ip], #-1540	; 0xfffff9fc
     314:	0a000002 	beq	324 <CPSR_IRQ_INHIBIT+0x2a4>
     318:	000007b4 			; <UNDEFINED> instruction: 0x000007b4
     31c:	07c50a00 	strbeq	r0, [r5, r0, lsl #20]
     320:	0a010000 	beq	40328 <_bss_end+0x37444>
     324:	00000819 	andeq	r0, r0, r9, lsl r8
     328:	08130a02 	ldmdaeq	r3, {r1, r9, fp}
     32c:	0a030000 	beq	c0334 <_bss_end+0xb7450>
     330:	000007ee 	andeq	r0, r0, lr, ror #15
     334:	07f40a04 	ldrbeq	r0, [r4, r4, lsl #20]!
     338:	0a050000 	beq	140340 <_bss_end+0x13745c>
     33c:	00000730 	andeq	r0, r0, r0, lsr r7
     340:	080d0a06 	stmdaeq	sp, {r1, r2, r9, fp}
     344:	0a070000 	beq	1c034c <_bss_end+0x1b7468>
     348:	000003f8 	strdeq	r0, [r0], -r8
     34c:	ec090008 	stc	0, cr0, [r9], {8}
     350:	05000002 	streq	r0, [r0, #-2]
     354:	00003304 	andeq	r3, r0, r4, lsl #6
     358:	0c180400 	cfldrseq	mvf0, [r8], {-0}
     35c:	0000024f 	andeq	r0, r0, pc, asr #4
     360:	0007240a 	andeq	r2, r7, sl, lsl #8
     364:	e10a0000 	mrs	r0, (UNDEF: 10)
     368:	01000007 	tsteq	r0, r7
     36c:	00029e0a 	andeq	r9, r2, sl, lsl #28
     370:	4c0c0200 	sfmmi	f0, 4, [ip], {-0}
     374:	0300776f 	movweq	r7, #1903	; 0x76f
     378:	047f0d00 	ldrbteq	r0, [pc], #-3328	; 380 <CPSR_IRQ_INHIBIT+0x300>
     37c:	04040000 	streq	r0, [r4], #-0
     380:	047b0723 	ldrbteq	r0, [fp], #-1827	; 0xfffff8dd
     384:	610e0000 	mrsvs	r0, (UNDEF: 14)
     388:	04000003 	streq	r0, [r0], #-3
     38c:	04861927 	streq	r1, [r6], #2343	; 0x927
     390:	0f000000 	svceq	0x00000000
     394:	00000640 	andeq	r0, r0, r0, asr #12
     398:	310a2b04 	tstcc	sl, r4, lsl #22
     39c:	8b000003 	blhi	3b0 <CPSR_IRQ_INHIBIT+0x330>
     3a0:	02000004 	andeq	r0, r0, #4
     3a4:	00000282 	andeq	r0, r0, r2, lsl #5
     3a8:	00000297 	muleq	r0, r7, r2
     3ac:	00049210 	andeq	r9, r4, r0, lsl r2
     3b0:	00541100 	subseq	r1, r4, r0, lsl #2
     3b4:	9d110000 	ldcls	0, cr0, [r1, #-0]
     3b8:	11000004 	tstne	r0, r4
     3bc:	0000049d 	muleq	r0, sp, r4
     3c0:	07a10f00 	streq	r0, [r1, r0, lsl #30]!
     3c4:	2d040000 	stccs	0, cr0, [r4, #-0]
     3c8:	0005530a 	andeq	r5, r5, sl, lsl #6
     3cc:	00048b00 	andeq	r8, r4, r0, lsl #22
     3d0:	02b00200 	adcseq	r0, r0, #0, 4
     3d4:	02c50000 	sbceq	r0, r5, #0
     3d8:	92100000 	andsls	r0, r0, #0
     3dc:	11000004 	tstne	r0, r4
     3e0:	00000054 	andeq	r0, r0, r4, asr r0
     3e4:	00049d11 	andeq	r9, r4, r1, lsl sp
     3e8:	049d1100 	ldreq	r1, [sp], #256	; 0x100
     3ec:	0f000000 	svceq	0x00000000
     3f0:	0000048d 	andeq	r0, r0, sp, lsl #9
     3f4:	690a2f04 	stmdbvs	sl, {r2, r8, r9, sl, fp, sp}
     3f8:	8b000007 	blhi	41c <CPSR_IRQ_INHIBIT+0x39c>
     3fc:	02000004 	andeq	r0, r0, #4
     400:	000002de 	ldrdeq	r0, [r0], -lr
     404:	000002f3 	strdeq	r0, [r0], -r3
     408:	00049210 	andeq	r9, r4, r0, lsl r2
     40c:	00541100 	subseq	r1, r4, r0, lsl #2
     410:	9d110000 	ldcls	0, cr0, [r1, #-0]
     414:	11000004 	tstne	r0, r4
     418:	0000049d 	muleq	r0, sp, r4
     41c:	04e10f00 	strbteq	r0, [r1], #3840	; 0xf00
     420:	31040000 	mrscc	r0, (UNDEF: 4)
     424:	0001e20a 	andeq	lr, r1, sl, lsl #4
     428:	00048b00 	andeq	r8, r4, r0, lsl #22
     42c:	030c0200 	movweq	r0, #49664	; 0xc200
     430:	03210000 			; <UNDEFINED> instruction: 0x03210000
     434:	92100000 	andsls	r0, r0, #0
     438:	11000004 	tstne	r0, r4
     43c:	00000054 	andeq	r0, r0, r4, asr r0
     440:	00049d11 	andeq	r9, r4, r1, lsl sp
     444:	049d1100 	ldreq	r1, [sp], #256	; 0x100
     448:	0f000000 	svceq	0x00000000
     44c:	0000028b 	andeq	r0, r0, fp, lsl #5
     450:	110a3204 	tstne	sl, r4, lsl #4
     454:	8b000006 	blhi	474 <CPSR_IRQ_INHIBIT+0x3f4>
     458:	02000004 	andeq	r0, r0, #4
     45c:	0000033a 	andeq	r0, r0, sl, lsr r3
     460:	0000034f 	andeq	r0, r0, pc, asr #6
     464:	00049210 	andeq	r9, r4, r0, lsl r2
     468:	00541100 	subseq	r1, r4, r0, lsl #2
     46c:	9d110000 	ldcls	0, cr0, [r1, #-0]
     470:	11000004 	tstne	r0, r4
     474:	0000049d 	muleq	r0, sp, r4
     478:	047f0f00 	ldrbteq	r0, [pc], #-3840	; 480 <CPSR_IRQ_INHIBIT+0x400>
     47c:	35040000 	strcc	r0, [r4, #-0]
     480:	00036705 	andeq	r6, r3, r5, lsl #14
     484:	0004a300 	andeq	sl, r4, r0, lsl #6
     488:	03680100 	cmneq	r8, #0, 2
     48c:	03730000 	cmneq	r3, #0
     490:	a3100000 	tstge	r0, #0
     494:	11000004 	tstne	r0, r4
     498:	00000065 	andeq	r0, r0, r5, rrx
     49c:	07441200 	strbeq	r1, [r4, -r0, lsl #4]
     4a0:	38040000 	stmdacc	r4, {}	; <UNPREDICTABLE>
     4a4:	0006ec0a 	andeq	lr, r6, sl, lsl #24
     4a8:	03880100 	orreq	r0, r8, #0, 2
     4ac:	03980000 	orrseq	r0, r8, #0
     4b0:	a3100000 	tstge	r0, #0
     4b4:	11000004 	tstne	r0, r4
     4b8:	00000054 	andeq	r0, r0, r4, asr r0
     4bc:	0001db11 	andeq	sp, r1, r1, lsl fp
     4c0:	6d0f0000 	stcvs	0, cr0, [pc, #-0]	; 4c8 <CPSR_IRQ_INHIBIT+0x448>
     4c4:	04000004 	streq	r0, [r0], #-4
     4c8:	04f4143a 	ldrbteq	r1, [r4], #1082	; 0x43a
     4cc:	01db0000 	bicseq	r0, fp, r0
     4d0:	b1010000 	mrslt	r0, (UNDEF: 1)
     4d4:	bc000003 	stclt	0, cr0, [r0], {3}
     4d8:	10000003 	andne	r0, r0, r3
     4dc:	00000492 	muleq	r0, r2, r4
     4e0:	00005411 	andeq	r5, r0, r1, lsl r4
     4e4:	c1120000 	tstgt	r2, r0
     4e8:	04000007 	streq	r0, [r0], #-7
     4ec:	030f0a3d 	movweq	r0, #64061	; 0xfa3d
     4f0:	d1010000 	mrsle	r0, (UNDEF: 1)
     4f4:	e1000003 	tst	r0, r3
     4f8:	10000003 	andne	r0, r0, r3
     4fc:	000004a3 	andeq	r0, r0, r3, lsr #9
     500:	00005411 	andeq	r5, r0, r1, lsl r4
     504:	048b1100 	streq	r1, [fp], #256	; 0x100
     508:	12000000 	andne	r0, r0, #0
     50c:	00000404 	andeq	r0, r0, r4, lsl #8
     510:	a60a3f04 	strge	r3, [sl], -r4, lsl #30
     514:	01000004 	tsteq	r0, r4
     518:	000003f6 	strdeq	r0, [r0], -r6
     51c:	00000401 	andeq	r0, r0, r1, lsl #8
     520:	0004a310 	andeq	sl, r4, r0, lsl r3
     524:	00541100 	subseq	r1, r4, r0, lsl #2
     528:	12000000 	andne	r0, r0, #0
     52c:	000005fd 	strdeq	r0, [r0], -sp
     530:	c10a4104 	tstgt	sl, r4, lsl #2
     534:	01000002 	tsteq	r0, r2
     538:	00000416 	andeq	r0, r0, r6, lsl r4
     53c:	00000426 	andeq	r0, r0, r6, lsr #8
     540:	0004a310 	andeq	sl, r4, r0, lsl r3
     544:	00541100 	subseq	r1, r4, r0, lsl #2
     548:	24110000 	ldrcs	r0, [r1], #-0
     54c:	00000002 	andeq	r0, r0, r2
     550:	0007cc12 	andeq	ip, r7, r2, lsl ip
     554:	0a420400 	beq	108155c <_bss_end+0x1078678>
     558:	000006ab 	andeq	r0, r0, fp, lsr #13
     55c:	00043b01 	andeq	r3, r4, r1, lsl #22
     560:	00044b00 	andeq	r4, r4, r0, lsl #22
     564:	04a31000 	strteq	r1, [r3], #0
     568:	54110000 	ldrpl	r0, [r1], #-0
     56c:	11000000 	mrsne	r0, (UNDEF: 0)
     570:	00000224 	andeq	r0, r0, r4, lsr #4
     574:	02701300 	rsbseq	r1, r0, #0, 6
     578:	43040000 	movwmi	r0, #16384	; 0x4000
     57c:	0004200a 	andeq	r2, r4, sl
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
     5b8:	000003f3 	strdeq	r0, [r0], -r3
     5bc:	047b0414 	ldrbteq	r0, [fp], #-1044	; 0xfffffbec
     5c0:	92050000 	andls	r0, r5, #0
     5c4:	15000004 	strne	r0, [r0, #-4]
     5c8:	00005404 	andeq	r5, r0, r4, lsl #8
     5cc:	4f041400 	svcmi	0x00041400
     5d0:	05000002 	streq	r0, [r0, #-2]
     5d4:	000004a3 	andeq	r0, r0, r3, lsr #9
     5d8:	00059f16 	andeq	r9, r5, r6, lsl pc
     5dc:	16470400 	strbne	r0, [r7], -r0, lsl #8
     5e0:	0000024f 	andeq	r0, r0, pc, asr #4
     5e4:	0004ae17 	andeq	sl, r4, r7, lsl lr
     5e8:	0f040100 	svceq	0x00040100
     5ec:	8ecc0305 	cdphi	3, 12, cr0, cr12, cr5, {0}
     5f0:	90180000 	andsls	r0, r8, r0
     5f4:	8c000005 	stchi	0, cr0, [r0], {5}
     5f8:	1c000089 	stcne	0, cr0, [r0], {137}	; 0x89
     5fc:	01000000 	mrseq	r0, (UNDEF: 0)
     600:	0673199c 			; <UNDEFINED> instruction: 0x0673199c
     604:	89380000 	ldmdbhi	r8!, {}	; <UNPREDICTABLE>
     608:	00540000 	subseq	r0, r4, r0
     60c:	9c010000 	stcls	0, cr0, [r1], {-0}
     610:	00000509 	andeq	r0, r0, r9, lsl #10
     614:	00051d1a 	andeq	r1, r5, sl, lsl sp
     618:	01b10100 			; <UNDEFINED> instruction: 0x01b10100
     61c:	00000033 	andeq	r0, r0, r3, lsr r0
     620:	1a749102 	bne	1d24a30 <_bss_end+0x1d1bb4c>
     624:	0000075e 	andeq	r0, r0, lr, asr r7
     628:	3301b101 	movwcc	fp, #4353	; 0x1101
     62c:	02000000 	andeq	r0, r0, #0
     630:	1b007091 	blne	1c87c <_bss_end+0x13998>
     634:	000003e1 	andeq	r0, r0, r1, ror #7
     638:	2306a901 	movwcs	sl, #26881	; 0x6901
     63c:	c4000005 	strgt	r0, [r0], #-5
     640:	74000088 	strvc	r0, [r0], #-136	; 0xffffff78
     644:	01000000 	mrseq	r0, (UNDEF: 0)
     648:	00055d9c 	muleq	r5, ip, sp
     64c:	06a61c00 	strteq	r1, [r6], r0, lsl #24
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
     6a0:	06a61c00 	strteq	r1, [r6], r0, lsl #24
     6a4:	04980000 	ldreq	r0, [r8], #0
     6a8:	91020000 	mrsls	r0, (UNDEF: 2)
     6ac:	69701d74 	ldmdbvs	r0!, {r2, r4, r5, r6, r8, sl, fp, ip}^
     6b0:	9e01006e 	cdpls	0, 0, cr0, cr1, cr14, {3}
     6b4:	00005431 	andeq	r5, r0, r1, lsr r4
     6b8:	70910200 	addsvc	r0, r1, r0, lsl #4
     6bc:	6765721d 			; <UNDEFINED> instruction: 0x6765721d
     6c0:	409e0100 	addsmi	r0, lr, r0, lsl #2
     6c4:	0000049d 	muleq	r0, sp, r4
     6c8:	1a6c9102 	bne	1b24ad8 <_bss_end+0x1b1bbf4>
     6cc:	00000756 	andeq	r0, r0, r6, asr r7
     6d0:	9d4f9e01 	stclls	14, cr9, [pc, #-4]	; 6d4 <CPSR_IRQ_INHIBIT+0x654>
     6d4:	02000004 	andeq	r0, r0, #4
     6d8:	1b006891 	blne	1a924 <_bss_end+0x11a40>
     6dc:	000003bc 			; <UNDEFINED> instruction: 0x000003bc
     6e0:	cb069501 	blgt	1a5aec <_bss_end+0x19cc08>
     6e4:	78000005 	stmdavc	r0, {r0, r2}
     6e8:	d8000087 	stmdale	r0, {r0, r1, r2, r7}
     6ec:	01000000 	mrseq	r0, (UNDEF: 0)
     6f0:	0006149c 	muleq	r6, ip, r4
     6f4:	06a61c00 	strteq	r1, [r6], r0, lsl #24
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
     758:	0006a61c 	andeq	sl, r6, ip, lsl r6
     75c:	0004a900 	andeq	sl, r4, r0, lsl #18
     760:	64910200 	ldrvs	r0, [r1], #512	; 0x200
     764:	6e69701d 	mcrvs	0, 3, r7, cr9, cr13, {0}
     768:	338a0100 	orrcc	r0, sl, #0, 2
     76c:	00000054 	andeq	r0, r0, r4, asr r0
     770:	1a609102 	bne	1824b80 <_bss_end+0x181bc9c>
     774:	00001c9f 	muleq	r0, pc, ip	; <UNPREDICTABLE>
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
     7c8:	a61c0000 	ldrge	r0, [ip], -r0
     7cc:	98000006 	stmdals	r0, {r1, r2}
     7d0:	02000004 	andeq	r0, r0, #4
     7d4:	701d7491 	mulsvc	sp, r1, r4
     7d8:	01006e69 	tsteq	r0, r9, ror #28
     7dc:	0054396e 	subseq	r3, r4, lr, ror #18
     7e0:	91020000 	mrsls	r0, (UNDEF: 2)
     7e4:	1c9f1a70 	vldmiane	pc, {s2-s113}
     7e8:	6e010000 	cdpvs	0, 0, cr0, cr1, cr0, {0}
     7ec:	00022453 	andeq	r2, r2, r3, asr r4
     7f0:	6c910200 	lfmvs	f0, 4, [r1], {0}
     7f4:	6765721d 			; <UNDEFINED> instruction: 0x6765721d
     7f8:	636e0100 	cmnvs	lr, #0, 2
     7fc:	0000049d 	muleq	r0, sp, r4
     800:	1a689102 	bne	1a24c10 <_bss_end+0x1a1bd2c>
     804:	00000756 	andeq	r0, r0, r6, asr r7
     808:	9d726e01 	ldclls	14, cr6, [r2, #-4]!
     80c:	02000004 	andeq	r0, r0, #4
     810:	1b000091 	blne	a5c <CPSR_IRQ_INHIBIT+0x9dc>
     814:	00000401 	andeq	r0, r0, r1, lsl #8
     818:	03065f01 	movweq	r5, #28417	; 0x6f01
     81c:	34000007 	strcc	r0, [r0], #-7
     820:	84000085 	strhi	r0, [r0], #-133	; 0xffffff7b
     824:	01000000 	mrseq	r0, (UNDEF: 0)
     828:	00074c9c 	muleq	r7, ip, ip
     82c:	06a61c00 	strteq	r1, [r6], r0, lsl #24
     830:	04a90000 	strteq	r0, [r9], #0
     834:	91020000 	mrsls	r0, (UNDEF: 2)
     838:	69701d6c 	ldmdbvs	r0!, {r2, r3, r5, r6, r8, sl, fp, ip}^
     83c:	5f01006e 	svcpl	0x0001006e
     840:	00005432 	andeq	r5, r0, r2, lsr r4
     844:	68910200 	ldmvs	r1, {r9}
     848:	001c9f1a 	andseq	r9, ip, sl, lsl pc
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
     890:	0006a61c 	andeq	sl, r6, ip, lsl r6
     894:	00049800 	andeq	r9, r4, r0, lsl #16
     898:	6c910200 	lfmvs	f0, 4, [r1], {0}
     89c:	6e69701d 	mcrvs	0, 3, r7, cr9, cr13, {0}
     8a0:	3a560100 	bcc	1580ca8 <_bss_end+0x1577dc4>
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
     8e4:	0006a61c 	andeq	sl, r6, ip, lsl r6
     8e8:	0004a900 	andeq	sl, r4, r0, lsl #18
     8ec:	6c910200 	lfmvs	f0, 4, [r1], {0}
     8f0:	6e69701d 	mcrvs	0, 3, r7, cr9, cr13, {0}
     8f4:	304d0100 	subcc	r0, sp, r0, lsl #2
     8f8:	00000054 	andeq	r0, r0, r4, asr r0
     8fc:	1a689102 	bne	1a24d0c <_bss_end+0x1a1be28>
     900:	00000663 	andeq	r0, r0, r3, ror #12
     904:	db444d01 	blle	1113d10 <_bss_end+0x110ae2c>
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
     948:	000006a6 	andeq	r0, r0, r6, lsr #13
     94c:	00000498 	muleq	r0, r8, r4
     950:	1d749102 	ldfnep	f1, [r4, #-8]!
     954:	006e6970 	rsbeq	r6, lr, r0, ror r9
     958:	54314201 	ldrtpl	r4, [r1], #-513	; 0xfffffdff
     95c:	02000000 	andeq	r0, r0, #0
     960:	721d7091 	andsvc	r7, sp, #145	; 0x91
     964:	01006765 	tsteq	r0, r5, ror #14
     968:	049d4042 	ldreq	r4, [sp], #66	; 0x42
     96c:	91020000 	mrsls	r0, (UNDEF: 2)
     970:	07561a6c 	ldrbeq	r1, [r6, -ip, ror #20]
     974:	42010000 	andmi	r0, r1, #0
     978:	00049d4f 	andeq	r9, r4, pc, asr #26
     97c:	68910200 	ldmvs	r1, {r9}
     980:	02c51f00 	sbceq	r1, r5, #0, 30
     984:	37010000 	strcc	r0, [r1, -r0]
     988:	00087106 	andeq	r7, r8, r6, lsl #2
     98c:	00832800 	addeq	r2, r3, r0, lsl #16
     990:	00007400 	andeq	r7, r0, r0, lsl #8
     994:	ab9c0100 	blge	fe700d9c <_bss_end+0xfe6f7eb8>
     998:	1c000008 	stcne	0, cr0, [r0], {8}
     99c:	000006a6 	andeq	r0, r0, r6, lsr #13
     9a0:	00000498 	muleq	r0, r8, r4
     9a4:	1d749102 	ldfnep	f1, [r4, #-8]!
     9a8:	006e6970 	rsbeq	r6, lr, r0, ror r9
     9ac:	54313701 	ldrtpl	r3, [r1], #-1793	; 0xfffff8ff
     9b0:	02000000 	andeq	r0, r0, #0
     9b4:	721d7091 	andsvc	r7, sp, #145	; 0x91
     9b8:	01006765 	tsteq	r0, r5, ror #14
     9bc:	049d4037 	ldreq	r4, [sp], #55	; 0x37
     9c0:	91020000 	mrsls	r0, (UNDEF: 2)
     9c4:	07561a6c 	ldrbeq	r1, [r6, -ip, ror #20]
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
     9f0:	000006a6 	andeq	r0, r0, r6, lsr #13
     9f4:	00000498 	muleq	r0, r8, r4
     9f8:	1d749102 	ldfnep	f1, [r4, #-8]!
     9fc:	006e6970 	rsbeq	r6, lr, r0, ror r9
     a00:	54312c01 	ldrtpl	r2, [r1], #-3073	; 0xfffff3ff
     a04:	02000000 	andeq	r0, r0, #0
     a08:	721d7091 	andsvc	r7, sp, #145	; 0x91
     a0c:	01006765 	tsteq	r0, r5, ror #14
     a10:	049d402c 	ldreq	r4, [sp], #44	; 0x2c
     a14:	91020000 	mrsls	r0, (UNDEF: 2)
     a18:	07561a6c 	ldrbeq	r1, [r6, -ip, ror #20]
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
     a44:	000006a6 	andeq	r0, r0, r6, lsr #13
     a48:	00000498 	muleq	r0, r8, r4
     a4c:	1d749102 	ldfnep	f1, [r4, #-8]!
     a50:	006e6970 	rsbeq	r6, lr, r0, ror r9
     a54:	54320c01 	ldrtpl	r0, [r2], #-3073	; 0xfffff3ff
     a58:	02000000 	andeq	r0, r0, #0
     a5c:	721d7091 	andsvc	r7, sp, #145	; 0x91
     a60:	01006765 	tsteq	r0, r5, ror #14
     a64:	049d410c 	ldreq	r4, [sp], #268	; 0x10c
     a68:	91020000 	mrsls	r0, (UNDEF: 2)
     a6c:	07561a6c 	ldrbeq	r1, [r6, -ip, ror #20]
     a70:	0c010000 	stceq	0, cr0, [r1], {-0}
     a74:	00049d50 	andeq	r9, r4, r0, asr sp
     a78:	68910200 	ldmvs	r1, {r9}
     a7c:	034f2000 	movteq	r2, #61440	; 0xf000
     a80:	06010000 	streq	r0, [r1], -r0
     a84:	00096401 	andeq	r6, r9, r1, lsl #8
     a88:	097a0000 	ldmdbeq	sl!, {}^	; <UNPREDICTABLE>
     a8c:	a6210000 	strtge	r0, [r1], -r0
     a90:	a9000006 	stmdbge	r0, {r1, r2}
     a94:	22000004 	andcs	r0, r0, #4
     a98:	000005d4 	ldrdeq	r0, [r0], -r4
     a9c:	652b0601 	strvs	r0, [fp, #-1537]!	; 0xfffff9ff
     aa0:	00000000 	andeq	r0, r0, r0
     aa4:	00095323 	andeq	r5, r9, r3, lsr #6
     aa8:	00052c00 	andeq	r2, r5, r0, lsl #24
     aac:	00099100 	andeq	r9, r9, r0, lsl #2
     ab0:	00816c00 	addeq	r6, r1, r0, lsl #24
     ab4:	00003400 	andeq	r3, r0, r0, lsl #8
     ab8:	249c0100 	ldrcs	r0, [ip], #256	; 0x100
     abc:	00000964 	andeq	r0, r0, r4, ror #18
     ac0:	24749102 	ldrbtcs	r9, [r4], #-258	; 0xfffffefe
     ac4:	0000096d 	andeq	r0, r0, sp, ror #18
     ac8:	00709102 	rsbseq	r9, r0, r2, lsl #2
     acc:	00080100 	andeq	r0, r8, r0, lsl #2
     ad0:	10000400 	andne	r0, r0, r0, lsl #8
     ad4:	04000003 	streq	r0, [r0], #-3
     ad8:	00000001 	andeq	r0, r0, r1
     adc:	0a330400 	beq	cc1ae4 <_bss_end+0xcb8c00>
     ae0:	01750000 	cmneq	r5, r0
     ae4:	89a80000 	stmibhi	r8!, {}	; <UNPREDICTABLE>
     ae8:	02b80000 	adcseq	r0, r8, #0
     aec:	04d10000 	ldrbeq	r0, [r1], #0
     af0:	01020000 	mrseq	r0, (UNDEF: 2)
     af4:	00058b08 	andeq	r8, r5, r8, lsl #22
     af8:	05020200 	streq	r0, [r2, #-512]	; 0xfffffe00
     afc:	000002a3 	andeq	r0, r0, r3, lsr #5
     b00:	69050403 	stmdbvs	r5, {r0, r1, sl}
     b04:	0400746e 	streq	r7, [r0], #-1134	; 0xfffffb92
     b08:	0000037e 	andeq	r0, r0, lr, ror r3
     b0c:	46070902 	strmi	r0, [r7], -r2, lsl #18
     b10:	02000000 	andeq	r0, r0, #0
     b14:	05820801 	streq	r0, [r2, #2049]	; 0x801
     b18:	02020000 	andeq	r0, r2, #0
     b1c:	0005e307 	andeq	lr, r5, r7, lsl #6
     b20:	03940400 	orrseq	r0, r4, #0, 8
     b24:	0b020000 	bleq	80b2c <_bss_end+0x77c48>
     b28:	00006507 	andeq	r6, r0, r7, lsl #10
     b2c:	00540500 	subseq	r0, r4, r0, lsl #10
     b30:	04020000 	streq	r0, [r2], #-0
     b34:	00126007 	andseq	r6, r2, r7
     b38:	00650500 	rsbeq	r0, r5, r0, lsl #10
     b3c:	65060000 	strvs	r0, [r6, #-0]
     b40:	07000000 	streq	r0, [r0, -r0]
     b44:	006c6168 	rsbeq	r6, ip, r8, ror #2
     b48:	e30b0703 	movw	r0, #46851	; 0xb703
     b4c:	08000001 	stmdaeq	r0, {r0}
     b50:	000007fa 	strdeq	r0, [r0], -sl
     b54:	6c1c0903 			; <UNDEFINED> instruction: 0x6c1c0903
     b58:	80000000 	andhi	r0, r0, r0
     b5c:	080ee6b2 	stmdaeq	lr, {r1, r4, r5, r7, r9, sl, sp, lr, pc}
     b60:	000004d1 	ldrdeq	r0, [r0], -r1
     b64:	ef1d0c03 	svc	0x001d0c03
     b68:	00000001 	andeq	r0, r0, r1
     b6c:	08200000 	stmdaeq	r0!, {}	; <UNPREDICTABLE>
     b70:	000005a5 	andeq	r0, r0, r5, lsr #11
     b74:	ef1d0f03 	svc	0x001d0f03
     b78:	00000001 	andeq	r0, r0, r1
     b7c:	09202000 	stmdbeq	r0!, {sp}
     b80:	00000654 	andeq	r0, r0, r4, asr r6
     b84:	60181203 	andsvs	r1, r8, r3, lsl #4
     b88:	36000000 	strcc	r0, [r0], -r0
     b8c:	00079808 	andeq	r9, r7, r8, lsl #16
     b90:	1d440300 	stclne	3, cr0, [r4, #-0]
     b94:	000001ef 	andeq	r0, r0, pc, ror #3
     b98:	20215000 	eorcs	r5, r1, r0
     b9c:	00025608 	andeq	r5, r2, r8, lsl #12
     ba0:	1d730300 	ldclne	3, cr0, [r3, #-0]
     ba4:	000001ef 	andeq	r0, r0, pc, ror #3
     ba8:	2000b200 	andcs	fp, r0, r0, lsl #4
     bac:	0008cb0a 	andeq	ip, r8, sl, lsl #22
     bb0:	33040500 	movwcc	r0, #17664	; 0x4500
     bb4:	03000000 	movweq	r0, #0
     bb8:	012e1075 			; <UNDEFINED> instruction: 0x012e1075
     bbc:	7f0b0000 	svcvc	0x000b0000
     bc0:	00000009 	andeq	r0, r0, r9
     bc4:	000ba70b 	andeq	sl, fp, fp, lsl #14
     bc8:	ce0b0100 	adfgte	f0, f3, f0
     bcc:	0200000b 	andeq	r0, r0, #11
     bd0:	000b4d0b 	andeq	r4, fp, fp, lsl #26
     bd4:	ac0b0300 	stcge	3, cr0, [fp], {-0}
     bd8:	04000008 	streq	r0, [r0], #-8
     bdc:	0008b90b 	andeq	fp, r8, fp, lsl #18
     be0:	8f0b0500 	svchi	0x000b0500
     be4:	0600000b 	streq	r0, [r0], -fp
     be8:	000c150b 	andeq	r1, ip, fp, lsl #10
     bec:	230b0700 	movwcs	r0, #46848	; 0xb700
     bf0:	0800000c 	stmdaeq	r0, {r2, r3}
     bf4:	0009b30b 	andeq	fp, r9, fp, lsl #6
     bf8:	0a000900 	beq	3000 <CPSR_IRQ_INHIBIT+0x2f80>
     bfc:	00000906 	andeq	r0, r0, r6, lsl #18
     c00:	00330405 	eorseq	r0, r3, r5, lsl #8
     c04:	83030000 	movwhi	r0, #12288	; 0x3000
     c08:	00017110 	andeq	r7, r1, r0, lsl r1
     c0c:	09270b00 	stmdbeq	r7!, {r8, r9, fp}
     c10:	0b000000 	bleq	c18 <CPSR_IRQ_INHIBIT+0xb98>
     c14:	0000087a 	andeq	r0, r0, sl, ror r8
     c18:	0a1d0b01 	beq	743824 <_bss_end+0x73a940>
     c1c:	0b020000 	bleq	80c24 <_bss_end+0x77d40>
     c20:	00000a28 	andeq	r0, r0, r8, lsr #20
     c24:	0a910b03 	beq	fe443838 <_bss_end+0xfe43a954>
     c28:	0b040000 	bleq	100c30 <_bss_end+0xf7d4c>
     c2c:	00000870 	andeq	r0, r0, r0, ror r8
     c30:	08e40b05 	stmiaeq	r4!, {r0, r2, r8, r9, fp}^
     c34:	0b060000 	bleq	180c3c <_bss_end+0x177d58>
     c38:	000008f5 	strdeq	r0, [r0], -r5
     c3c:	b50a0007 	strlt	r0, [sl, #-7]
     c40:	0500000b 	streq	r0, [r0, #-11]
     c44:	00003304 	andeq	r3, r0, r4, lsl #6
     c48:	108f0300 	addne	r0, pc, r0, lsl #6
     c4c:	000001d2 	ldrdeq	r0, [r0], -r2
     c50:	5855410c 	ldmdapl	r5, {r2, r3, r8, lr}^
     c54:	3a0b1d00 	bcc	2c805c <_bss_end+0x2bf178>
     c58:	2b00000b 	blcs	c8c <CPSR_IRQ_INHIBIT+0xc0c>
     c5c:	000c310b 	andeq	r3, ip, fp, lsl #2
     c60:	370b2d00 	strcc	r2, [fp, -r0, lsl #26]
     c64:	2e00000c 	cdpcs	0, 0, cr0, cr0, cr12, {0}
     c68:	494d530c 	stmdbmi	sp, {r2, r3, r8, r9, ip, lr}^
     c6c:	dc0b3000 	stcle	0, cr3, [fp], {-0}
     c70:	3100000b 	tstcc	r0, fp
     c74:	000be30b 	andeq	lr, fp, fp, lsl #6
     c78:	ea0b3200 	b	2cd480 <_bss_end+0x2c459c>
     c7c:	3300000b 	movwcc	r0, #11
     c80:	000bf10b 	andeq	pc, fp, fp, lsl #2
     c84:	490c3400 	stmdbmi	ip, {sl, ip, sp}
     c88:	35004332 	strcc	r4, [r0, #-818]	; 0xfffffcce
     c8c:	4950530c 	ldmdbmi	r0, {r2, r3, r8, r9, ip, lr}^
     c90:	500c3600 	andpl	r3, ip, r0, lsl #12
     c94:	37004d43 	strcc	r4, [r0, -r3, asr #26]
     c98:	0008c60b 	andeq	ip, r8, fp, lsl #12
     c9c:	08003900 	stmdaeq	r0, {r8, fp, ip, sp}
     ca0:	00000668 	andeq	r0, r0, r8, ror #12
     ca4:	ef1da603 	svc	0x001da603
     ca8:	00000001 	andeq	r0, r0, r1
     cac:	002000b4 	strhteq	r0, [r0], -r4
     cb0:	0000820d 	andeq	r8, r0, sp, lsl #4
     cb4:	07040200 	streq	r0, [r4, -r0, lsl #4]
     cb8:	0000125b 	andeq	r1, r0, fp, asr r2
     cbc:	0001e805 	andeq	lr, r1, r5, lsl #16
     cc0:	00920d00 	addseq	r0, r2, r0, lsl #26
     cc4:	a20d0000 	andge	r0, sp, #0
     cc8:	0d000000 	stceq	0, cr0, [r0, #-0]
     ccc:	000000b2 	strheq	r0, [r0], -r2
     cd0:	0000bf0d 	andeq	fp, r0, sp, lsl #30
     cd4:	00cf0d00 	sbceq	r0, pc, r0, lsl #26
     cd8:	d20d0000 	andle	r0, sp, #0
     cdc:	0a000001 	beq	ce8 <CPSR_IRQ_INHIBIT+0xc68>
     ce0:	00000715 	andeq	r0, r0, r5, lsl r7
     ce4:	003a0107 	eorseq	r0, sl, r7, lsl #2
     ce8:	06040000 	streq	r0, [r4], -r0
     cec:	00025b0c 	andeq	r5, r2, ip, lsl #22
     cf0:	07b40b00 	ldreq	r0, [r4, r0, lsl #22]!
     cf4:	0b000000 	bleq	cfc <CPSR_IRQ_INHIBIT+0xc7c>
     cf8:	000007c5 	andeq	r0, r0, r5, asr #15
     cfc:	08190b01 	ldmdaeq	r9, {r0, r8, r9, fp}
     d00:	0b020000 	bleq	80d08 <_bss_end+0x77e24>
     d04:	00000813 	andeq	r0, r0, r3, lsl r8
     d08:	07ee0b03 	strbeq	r0, [lr, r3, lsl #22]!
     d0c:	0b040000 	bleq	100d14 <_bss_end+0xf7e30>
     d10:	000007f4 	strdeq	r0, [r0], -r4
     d14:	07300b05 	ldreq	r0, [r0, -r5, lsl #22]!
     d18:	0b060000 	bleq	180d20 <_bss_end+0x177e3c>
     d1c:	0000080d 	andeq	r0, r0, sp, lsl #16
     d20:	03f80b07 	mvnseq	r0, #7168	; 0x1c00
     d24:	00080000 	andeq	r0, r8, r0
     d28:	0002ec0a 	andeq	lr, r2, sl, lsl #24
     d2c:	33040500 	movwcc	r0, #17664	; 0x4500
     d30:	04000000 	streq	r0, [r0], #-0
     d34:	02860c18 	addeq	r0, r6, #24, 24	; 0x1800
     d38:	240b0000 	strcs	r0, [fp], #-0
     d3c:	00000007 	andeq	r0, r0, r7
     d40:	0007e10b 	andeq	lr, r7, fp, lsl #2
     d44:	9e0b0100 	adflse	f0, f3, f0
     d48:	02000002 	andeq	r0, r0, #2
     d4c:	776f4c0c 	strbvc	r4, [pc, -ip, lsl #24]!
     d50:	0e000300 	cdpeq	3, 0, cr0, cr0, cr0, {0}
     d54:	0000047f 	andeq	r0, r0, pc, ror r4
     d58:	07230404 	streq	r0, [r3, -r4, lsl #8]!
     d5c:	000004b2 			; <UNDEFINED> instruction: 0x000004b2
     d60:	0003610f 	andeq	r6, r3, pc, lsl #2
     d64:	19270400 	stmdbne	r7!, {sl}
     d68:	000004bd 			; <UNDEFINED> instruction: 0x000004bd
     d6c:	06401000 	strbeq	r1, [r0], -r0
     d70:	2b040000 	blcs	100d78 <_bss_end+0xf7e94>
     d74:	0003310a 	andeq	r3, r3, sl, lsl #2
     d78:	0004c200 	andeq	ip, r4, r0, lsl #4
     d7c:	02b90200 	adcseq	r0, r9, #0, 4
     d80:	02ce0000 	sbceq	r0, lr, #0
     d84:	c9110000 	ldmdbgt	r1, {}	; <UNPREDICTABLE>
     d88:	12000004 	andne	r0, r0, #4
     d8c:	00000054 	andeq	r0, r0, r4, asr r0
     d90:	0004cf12 	andeq	ip, r4, r2, lsl pc
     d94:	04cf1200 	strbeq	r1, [pc], #512	; d9c <CPSR_IRQ_INHIBIT+0xd1c>
     d98:	10000000 	andne	r0, r0, r0
     d9c:	000007a1 	andeq	r0, r0, r1, lsr #15
     da0:	530a2d04 	movwpl	r2, #44292	; 0xad04
     da4:	c2000005 	andgt	r0, r0, #5
     da8:	02000004 	andeq	r0, r0, #4
     dac:	000002e7 	andeq	r0, r0, r7, ror #5
     db0:	000002fc 	strdeq	r0, [r0], -ip
     db4:	0004c911 	andeq	ip, r4, r1, lsl r9
     db8:	00541200 	subseq	r1, r4, r0, lsl #4
     dbc:	cf120000 	svcgt	0x00120000
     dc0:	12000004 	andne	r0, r0, #4
     dc4:	000004cf 	andeq	r0, r0, pc, asr #9
     dc8:	048d1000 	streq	r1, [sp], #0
     dcc:	2f040000 	svccs	0x00040000
     dd0:	0007690a 	andeq	r6, r7, sl, lsl #18
     dd4:	0004c200 	andeq	ip, r4, r0, lsl #4
     dd8:	03150200 	tsteq	r5, #0, 4
     ddc:	032a0000 			; <UNDEFINED> instruction: 0x032a0000
     de0:	c9110000 	ldmdbgt	r1, {}	; <UNPREDICTABLE>
     de4:	12000004 	andne	r0, r0, #4
     de8:	00000054 	andeq	r0, r0, r4, asr r0
     dec:	0004cf12 	andeq	ip, r4, r2, lsl pc
     df0:	04cf1200 	strbeq	r1, [pc], #512	; df8 <CPSR_IRQ_INHIBIT+0xd78>
     df4:	10000000 	andne	r0, r0, r0
     df8:	000004e1 	andeq	r0, r0, r1, ror #9
     dfc:	e20a3104 	and	r3, sl, #4, 2
     e00:	c2000001 	andgt	r0, r0, #1
     e04:	02000004 	andeq	r0, r0, #4
     e08:	00000343 	andeq	r0, r0, r3, asr #6
     e0c:	00000358 	andeq	r0, r0, r8, asr r3
     e10:	0004c911 	andeq	ip, r4, r1, lsl r9
     e14:	00541200 	subseq	r1, r4, r0, lsl #4
     e18:	cf120000 	svcgt	0x00120000
     e1c:	12000004 	andne	r0, r0, #4
     e20:	000004cf 	andeq	r0, r0, pc, asr #9
     e24:	028b1000 	addeq	r1, fp, #0
     e28:	32040000 	andcc	r0, r4, #0
     e2c:	0006110a 	andeq	r1, r6, sl, lsl #2
     e30:	0004c200 	andeq	ip, r4, r0, lsl #4
     e34:	03710200 	cmneq	r1, #0, 4
     e38:	03860000 	orreq	r0, r6, #0
     e3c:	c9110000 	ldmdbgt	r1, {}	; <UNPREDICTABLE>
     e40:	12000004 	andne	r0, r0, #4
     e44:	00000054 	andeq	r0, r0, r4, asr r0
     e48:	0004cf12 	andeq	ip, r4, r2, lsl pc
     e4c:	04cf1200 	strbeq	r1, [pc], #512	; e54 <CPSR_IRQ_INHIBIT+0xdd4>
     e50:	10000000 	andne	r0, r0, r0
     e54:	0000047f 	andeq	r0, r0, pc, ror r4
     e58:	67053504 	strvs	r3, [r5, -r4, lsl #10]
     e5c:	d5000003 	strle	r0, [r0, #-3]
     e60:	01000004 	tsteq	r0, r4
     e64:	0000039f 	muleq	r0, pc, r3	; <UNPREDICTABLE>
     e68:	000003aa 	andeq	r0, r0, sl, lsr #7
     e6c:	0004d511 	andeq	sp, r4, r1, lsl r5
     e70:	00651200 	rsbeq	r1, r5, r0, lsl #4
     e74:	13000000 	movwne	r0, #0
     e78:	00000744 	andeq	r0, r0, r4, asr #14
     e7c:	ec0a3804 	stc	8, cr3, [sl], {4}
     e80:	01000006 	tsteq	r0, r6
     e84:	000003bf 			; <UNDEFINED> instruction: 0x000003bf
     e88:	000003cf 	andeq	r0, r0, pc, asr #7
     e8c:	0004d511 	andeq	sp, r4, r1, lsl r5
     e90:	00541200 	subseq	r1, r4, r0, lsl #4
     e94:	12120000 	andsne	r0, r2, #0
     e98:	00000002 	andeq	r0, r0, r2
     e9c:	00046d10 	andeq	r6, r4, r0, lsl sp
     ea0:	143a0400 	ldrtne	r0, [sl], #-1024	; 0xfffffc00
     ea4:	000004f4 	strdeq	r0, [r0], -r4
     ea8:	00000212 	andeq	r0, r0, r2, lsl r2
     eac:	0003e801 	andeq	lr, r3, r1, lsl #16
     eb0:	0003f300 	andeq	pc, r3, r0, lsl #6
     eb4:	04c91100 	strbeq	r1, [r9], #256	; 0x100
     eb8:	54120000 	ldrpl	r0, [r2], #-0
     ebc:	00000000 	andeq	r0, r0, r0
     ec0:	0007c113 	andeq	ip, r7, r3, lsl r1
     ec4:	0a3d0400 	beq	f41ecc <_bss_end+0xf38fe8>
     ec8:	0000030f 	andeq	r0, r0, pc, lsl #6
     ecc:	00040801 	andeq	r0, r4, r1, lsl #16
     ed0:	00041800 	andeq	r1, r4, r0, lsl #16
     ed4:	04d51100 	ldrbeq	r1, [r5], #256	; 0x100
     ed8:	54120000 	ldrpl	r0, [r2], #-0
     edc:	12000000 	andne	r0, r0, #0
     ee0:	000004c2 	andeq	r0, r0, r2, asr #9
     ee4:	04041300 	streq	r1, [r4], #-768	; 0xfffffd00
     ee8:	3f040000 	svccc	0x00040000
     eec:	0004a60a 	andeq	sl, r4, sl, lsl #12
     ef0:	042d0100 	strteq	r0, [sp], #-256	; 0xffffff00
     ef4:	04380000 	ldrteq	r0, [r8], #-0
     ef8:	d5110000 	ldrle	r0, [r1, #-0]
     efc:	12000004 	andne	r0, r0, #4
     f00:	00000054 	andeq	r0, r0, r4, asr r0
     f04:	05fd1300 	ldrbeq	r1, [sp, #768]!	; 0x300
     f08:	41040000 	mrsmi	r0, (UNDEF: 4)
     f0c:	0002c10a 	andeq	ip, r2, sl, lsl #2
     f10:	044d0100 	strbeq	r0, [sp], #-256	; 0xffffff00
     f14:	045d0000 	ldrbeq	r0, [sp], #-0
     f18:	d5110000 	ldrle	r0, [r1, #-0]
     f1c:	12000004 	andne	r0, r0, #4
     f20:	00000054 	andeq	r0, r0, r4, asr r0
     f24:	00025b12 	andeq	r5, r2, r2, lsl fp
     f28:	cc130000 	ldcgt	0, cr0, [r3], {-0}
     f2c:	04000007 	streq	r0, [r0], #-7
     f30:	06ab0a42 	strteq	r0, [fp], r2, asr #20
     f34:	72010000 	andvc	r0, r1, #0
     f38:	82000004 	andhi	r0, r0, #4
     f3c:	11000004 	tstne	r0, r4
     f40:	000004d5 	ldrdeq	r0, [r0], -r5
     f44:	00005412 	andeq	r5, r0, r2, lsl r4
     f48:	025b1200 	subseq	r1, fp, #0, 4
     f4c:	14000000 	strne	r0, [r0], #-0
     f50:	00000270 	andeq	r0, r0, r0, ror r2
     f54:	200a4304 	andcs	r4, sl, r4, lsl #6
     f58:	c2000004 	andgt	r0, r0, #4
     f5c:	01000004 	tsteq	r0, r4
     f60:	00000497 	muleq	r0, r7, r4
     f64:	0004c911 	andeq	ip, r4, r1, lsl r9
     f68:	00541200 	subseq	r1, r4, r0, lsl #4
     f6c:	5b120000 	blpl	480f74 <_bss_end+0x478090>
     f70:	12000002 	andne	r0, r0, #2
     f74:	000004cf 	andeq	r0, r0, pc, asr #9
     f78:	0004cf12 	andeq	ip, r4, r2, lsl pc
     f7c:	05000000 	streq	r0, [r0, #-0]
     f80:	00000286 	andeq	r0, r0, r6, lsl #5
     f84:	00650415 	rsbeq	r0, r5, r5, lsl r4
     f88:	b7050000 	strlt	r0, [r5, -r0]
     f8c:	02000004 	andeq	r0, r0, #4
     f90:	03f30201 	mvnseq	r0, #268435456	; 0x10000000
     f94:	04150000 	ldreq	r0, [r5], #-0
     f98:	000004b2 			; <UNDEFINED> instruction: 0x000004b2
     f9c:	00540416 	subseq	r0, r4, r6, lsl r4
     fa0:	04150000 	ldreq	r0, [r5], #-0
     fa4:	00000286 	andeq	r0, r0, r6, lsl #5
     fa8:	00059f17 	andeq	r9, r5, r7, lsl pc
     fac:	16470400 	strbne	r0, [r7], -r0, lsl #8
     fb0:	00000286 	andeq	r0, r0, r6, lsl #5
     fb4:	00099d0e 	andeq	r9, r9, lr, lsl #26
     fb8:	09050400 	stmdbeq	r5, {sl}
     fbc:	0005c607 	andeq	ip, r5, r7, lsl #12
     fc0:	09170f00 	ldmdbeq	r7, {r8, r9, sl, fp}
     fc4:	0d050000 	stceq	0, cr0, [r5, #-0]
     fc8:	0005c61c 	andeq	ip, r5, ip, lsl r6
     fcc:	22100000 	andscs	r0, r0, #0
     fd0:	05000009 	streq	r0, [r0, #-9]
     fd4:	082f1c10 	stmdaeq	pc!, {r4, sl, fp, ip}	; <UNPREDICTABLE>
     fd8:	05cc0000 	strbeq	r0, [ip]
     fdc:	1a020000 	bne	80fe4 <_bss_end+0x78100>
     fe0:	25000005 	strcs	r0, [r0, #-5]
     fe4:	11000005 	tstne	r0, r5
     fe8:	000005d2 	ldrdeq	r0, [r0], -r2
     fec:	0000df12 	andeq	sp, r0, r2, lsl pc
     ff0:	9d100000 	ldcls	0, cr0, [r0, #-0]
     ff4:	05000009 	streq	r0, [r0, #-9]
     ff8:	0b1b0513 	bleq	6c244c <_bss_end+0x6b9568>
     ffc:	05d20000 	ldrbeq	r0, [r2]
    1000:	3e010000 	cdpcc	0, 0, cr0, cr1, cr0, {0}
    1004:	49000005 	stmdbmi	r0, {r0, r2}
    1008:	11000005 	tstne	r0, r5
    100c:	000005d2 	ldrdeq	r0, [r0], -r2
    1010:	0001e812 	andeq	lr, r1, r2, lsl r8
    1014:	c5130000 	ldrgt	r0, [r3, #-0]
    1018:	05000009 	streq	r0, [r0, #-9]
    101c:	0ad50a16 	beq	ff54387c <_bss_end+0xff53a998>
    1020:	5e010000 	cdppl	0, 0, cr0, cr1, cr0, {0}
    1024:	69000005 	stmdbvs	r0, {r0, r2}
    1028:	11000005 	tstne	r0, r5
    102c:	000005d2 	ldrdeq	r0, [r0], -r2
    1030:	00012e12 	andeq	r2, r1, r2, lsl lr
    1034:	f8130000 			; <UNDEFINED> instruction: 0xf8130000
    1038:	0500000b 	streq	r0, [r0, #-11]
    103c:	09d60a18 	ldmibeq	r6, {r3, r4, r9, fp}^
    1040:	7e010000 	cdpvc	0, 0, cr0, cr1, cr0, {0}
    1044:	89000005 	stmdbhi	r0, {r0, r2}
    1048:	11000005 	tstne	r0, r5
    104c:	000005d2 	ldrdeq	r0, [r0], -r2
    1050:	00012e12 	andeq	r2, r1, r2, lsl lr
    1054:	82130000 	andshi	r0, r3, #0
    1058:	05000008 	streq	r0, [r0, #-8]
    105c:	0a9b0a1b 	beq	fe6c38d0 <_bss_end+0xfe6ba9ec>
    1060:	9e010000 	cdpls	0, 0, cr0, cr1, cr0, {0}
    1064:	a9000005 	stmdbge	r0, {r0, r2}
    1068:	11000005 	tstne	r0, r5
    106c:	000005d2 	ldrdeq	r0, [r0], -r2
    1070:	00017112 	andeq	r7, r1, r2, lsl r1
    1074:	91180000 	tstls	r8, r0
    1078:	05000009 	streq	r0, [r0, #-9]
    107c:	092d0a1d 	pusheq	{r0, r2, r3, r4, r9, fp}
    1080:	ba010000 	blt	41088 <_bss_end+0x381a4>
    1084:	11000005 	tstne	r0, r5
    1088:	000005d2 	ldrdeq	r0, [r0], -r2
    108c:	00017112 	andeq	r7, r1, r2, lsl r1
    1090:	15000000 	strne	r0, [r0, #-0]
    1094:	00007104 	andeq	r7, r0, r4, lsl #2
    1098:	71041600 	tstvc	r4, r0, lsl #12
    109c:	15000000 	strne	r0, [r0, #-0]
    10a0:	0004e704 	andeq	lr, r4, r4, lsl #14
    10a4:	05d20500 	ldrbeq	r0, [r2, #1280]	; 0x500
    10a8:	c0170000 	andsgt	r0, r7, r0
    10ac:	0500000b 	streq	r0, [r0, #-11]
    10b0:	04e71e20 	strbteq	r1, [r7], #3616	; 0xe20
    10b4:	dd190000 	ldcle	0, cr0, [r9, #-0]
    10b8:	01000005 	tsteq	r0, r5
    10bc:	03051717 	movweq	r1, #22295	; 0x5717
    10c0:	00008ed0 	ldrdeq	r8, [r0], -r0
    10c4:	000b651a 	andeq	r6, fp, sl, lsl r5
    10c8:	008c4400 	addeq	r4, ip, r0, lsl #8
    10cc:	00001c00 	andeq	r1, r0, r0, lsl #24
    10d0:	1b9c0100 	blne	fe7014d8 <_bss_end+0xfe6f85f4>
    10d4:	00000673 	andeq	r0, r0, r3, ror r6
    10d8:	00008bf0 	strdeq	r8, [r0], -r0
    10dc:	00000054 	andeq	r0, r0, r4, asr r0
    10e0:	06389c01 	ldrteq	r9, [r8], -r1, lsl #24
    10e4:	1d1c0000 	ldcne	0, cr0, [ip, #-0]
    10e8:	01000005 	tsteq	r0, r5
    10ec:	00330139 	eorseq	r0, r3, r9, lsr r1
    10f0:	91020000 	mrsls	r0, (UNDEF: 2)
    10f4:	075e1c74 			; <UNDEFINED> instruction: 0x075e1c74
    10f8:	39010000 	stmdbcc	r1, {}	; <UNPREDICTABLE>
    10fc:	00003301 	andeq	r3, r0, r1, lsl #6
    1100:	70910200 	addsvc	r0, r1, r0, lsl #4
    1104:	05a91d00 	streq	r1, [r9, #3328]!	; 0xd00
    1108:	34010000 	strcc	r0, [r1], #-0
    110c:	00065206 	andeq	r5, r6, r6, lsl #4
    1110:	008b8800 	addeq	r8, fp, r0, lsl #16
    1114:	00006800 	andeq	r6, r0, r0, lsl #16
    1118:	7d9c0100 	ldfvcs	f0, [ip]
    111c:	1e000006 	cdpne	0, 0, cr0, cr0, cr6, {0}
    1120:	000006a6 	andeq	r0, r0, r6, lsr #13
    1124:	000005d8 	ldrdeq	r0, [r0], -r8
    1128:	1c649102 	stfnep	f1, [r4], #-8
    112c:	00000c0a 	andeq	r0, r0, sl, lsl #24
    1130:	71393401 	teqvc	r9, r1, lsl #8
    1134:	02000001 	andeq	r0, r0, #1
    1138:	261f6091 			; <UNDEFINED> instruction: 0x261f6091
    113c:	01000008 	tsteq	r0, r8
    1140:	006c1836 	rsbeq	r1, ip, r6, lsr r8
    1144:	91020000 	mrsls	r0, (UNDEF: 2)
    1148:	891d006c 	ldmdbhi	sp, {r2, r3, r5, r6}
    114c:	01000005 	tsteq	r0, r5
    1150:	0697062d 	ldreq	r0, [r7], sp, lsr #12
    1154:	8b200000 	blhi	80115c <_bss_end+0x7f8278>
    1158:	00680000 	rsbeq	r0, r8, r0
    115c:	9c010000 	stcls	0, cr0, [r1], {-0}
    1160:	000006c2 	andeq	r0, r0, r2, asr #13
    1164:	0006a61e 	andeq	sl, r6, lr, lsl r6
    1168:	0005d800 	andeq	sp, r5, r0, lsl #16
    116c:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    1170:	000c0a1c 	andeq	r0, ip, ip, lsl sl
    1174:	382d0100 	stmdacc	sp!, {r8}
    1178:	00000171 	andeq	r0, r0, r1, ror r1
    117c:	1f609102 	svcne	0x00609102
    1180:	00000826 	andeq	r0, r0, r6, lsr #16
    1184:	6c182f01 	ldcvs	15, cr2, [r8], {1}
    1188:	02000000 	andeq	r0, r0, #0
    118c:	1d006c91 	stcne	12, cr6, [r0, #-580]	; 0xfffffdbc
    1190:	00000569 	andeq	r0, r0, r9, ror #10
    1194:	dc062801 	stcle	8, cr2, [r6], {1}
    1198:	dc000006 	stcle	0, cr0, [r0], {6}
    119c:	4400008a 	strmi	r0, [r0], #-138	; 0xffffff76
    11a0:	01000000 	mrseq	r0, (UNDEF: 0)
    11a4:	0006f89c 	muleq	r6, ip, r8
    11a8:	06a61e00 	strteq	r1, [r6], r0, lsl #28
    11ac:	05d80000 	ldrbeq	r0, [r8]
    11b0:	91020000 	mrsls	r0, (UNDEF: 2)
    11b4:	0c0a1c6c 	stceq	12, cr1, [sl], {108}	; 0x6c
    11b8:	28010000 	stmdacs	r1, {}	; <UNPREDICTABLE>
    11bc:	00012e45 	andeq	r2, r1, r5, asr #28
    11c0:	68910200 	ldmvs	r1, {r9}
    11c4:	05491d00 	strbeq	r1, [r9, #-3328]	; 0xfffff300
    11c8:	23010000 	movwcs	r0, #4096	; 0x1000
    11cc:	00071206 	andeq	r1, r7, r6, lsl #4
    11d0:	008a9800 	addeq	r9, sl, r0, lsl #16
    11d4:	00004400 	andeq	r4, r0, r0, lsl #8
    11d8:	2e9c0100 	fmlcse	f0, f4, f0
    11dc:	1e000007 	cdpne	0, 0, cr0, cr0, cr7, {0}
    11e0:	000006a6 	andeq	r0, r0, r6, lsr #13
    11e4:	000005d8 	ldrdeq	r0, [r0], -r8
    11e8:	1c6c9102 	stfnep	f1, [ip], #-8
    11ec:	00000c0a 	andeq	r0, r0, sl, lsl #24
    11f0:	2e442301 	cdpcs	3, 4, cr2, cr4, cr1, {0}
    11f4:	02000001 	andeq	r0, r0, #1
    11f8:	20006891 	mulcs	r0, r1, r8
    11fc:	00000501 	andeq	r0, r0, r1, lsl #10
    1200:	48181e01 	ldmdami	r8, {r0, r9, sl, fp, ip}
    1204:	60000007 	andvs	r0, r0, r7
    1208:	3800008a 	stmdacc	r0, {r1, r3, r7}
    120c:	01000000 	mrseq	r0, (UNDEF: 0)
    1210:	0007649c 	muleq	r7, ip, r4
    1214:	06a61e00 	strteq	r1, [r6], r0, lsl #28
    1218:	05d80000 	ldrbeq	r0, [r8]
    121c:	91020000 	mrsls	r0, (UNDEF: 2)
    1220:	65722174 	ldrbvs	r2, [r2, #-372]!	; 0xfffffe8c
    1224:	1e010067 	cdpne	0, 0, cr0, cr1, cr7, {3}
    1228:	0000df52 	andeq	sp, r0, r2, asr pc
    122c:	70910200 	addsvc	r0, r1, r0, lsl #4
    1230:	05252200 	streq	r2, [r5, #-512]!	; 0xfffffe00
    1234:	19010000 	stmdbne	r1, {}	; <UNPREDICTABLE>
    1238:	00077501 	andeq	r7, r7, r1, lsl #10
    123c:	078b0000 	streq	r0, [fp, r0]
    1240:	a6230000 	strtge	r0, [r3], -r0
    1244:	d8000006 	stmdale	r0, {r1, r2}
    1248:	24000005 	strcs	r0, [r0], #-5
    124c:	0000082a 	andeq	r0, r0, sl, lsr #16
    1250:	e83c1901 	ldmda	ip!, {r0, r8, fp, ip}
    1254:	00000001 	andeq	r0, r0, r1
    1258:	00076425 	andeq	r6, r7, r5, lsr #8
    125c:	00088d00 	andeq	r8, r8, r0, lsl #26
    1260:	0007a600 	andeq	sl, r7, r0, lsl #12
    1264:	008a2c00 	addeq	r2, sl, r0, lsl #24
    1268:	00003400 	andeq	r3, r0, r0, lsl #8
    126c:	b79c0100 	ldrlt	r0, [ip, r0, lsl #2]
    1270:	26000007 	strcs	r0, [r0], -r7
    1274:	00000775 	andeq	r0, r0, r5, ror r7
    1278:	26749102 	ldrbtcs	r9, [r4], -r2, lsl #2
    127c:	0000077e 	andeq	r0, r0, lr, ror r7
    1280:	00709102 	rsbseq	r9, r0, r2, lsl #2
    1284:	00096827 	andeq	r6, r9, r7, lsr #16
    1288:	33130100 	tstcc	r3, #0, 2
    128c:	00008a1c 	andeq	r8, r0, ip, lsl sl
    1290:	00000010 	andeq	r0, r0, r0, lsl r0
    1294:	59289c01 	stmdbpl	r8!, {r0, sl, fp, ip, pc}
    1298:	0100000b 	tsteq	r0, fp
    129c:	89c0330a 	stmibhi	r0, {r1, r3, r8, r9, ip, sp}^
    12a0:	005c0000 	subseq	r0, ip, r0
    12a4:	9c010000 	stcls	0, cr0, [r1], {-0}
    12a8:	000007f2 	strdeq	r0, [r0], -r2
    12ac:	000ba01f 	andeq	sl, fp, pc, lsl r0
    12b0:	110c0100 	mrsne	r0, (UNDEF: 28)
    12b4:	000004c2 	andeq	r0, r0, r2, asr #9
    12b8:	8ec80305 	cdphi	3, 12, cr0, cr8, cr5, {0}
    12bc:	27000000 	strcs	r0, [r0, -r0]
    12c0:	00000b74 	andeq	r0, r0, r4, ror fp
    12c4:	a8330601 	ldmdage	r3!, {r0, r9, sl}
    12c8:	18000089 	stmdane	r0, {r0, r3, r7}
    12cc:	01000000 	mrseq	r0, (UNDEF: 0)
    12d0:	05f7009c 	ldrbeq	r0, [r7, #156]!	; 0x9c
    12d4:	00040000 	andeq	r0, r4, r0
    12d8:	000005a2 	andeq	r0, r0, r2, lsr #11
    12dc:	00000104 	andeq	r0, r0, r4, lsl #2
    12e0:	3d040000 	stccc	0, cr0, [r4, #-0]
    12e4:	7500000c 	strvc	r0, [r0, #-12]
    12e8:	60000001 	andvs	r0, r0, r1
    12ec:	6400008c 	strvs	r0, [r0], #-140	; 0xffffff74
    12f0:	5e000000 	cdppl	0, 0, cr0, cr0, cr0, {0}
    12f4:	02000007 	andeq	r0, r0, #7
    12f8:	058b0801 	streq	r0, [fp, #2049]	; 0x801
    12fc:	02020000 	andeq	r0, r2, #0
    1300:	0002a305 	andeq	sl, r2, r5, lsl #6
    1304:	05040300 	streq	r0, [r4, #-768]	; 0xfffffd00
    1308:	00746e69 	rsbseq	r6, r4, r9, ror #28
    130c:	00037e04 	andeq	r7, r3, r4, lsl #28
    1310:	07090200 	streq	r0, [r9, -r0, lsl #4]
    1314:	00000046 	andeq	r0, r0, r6, asr #32
    1318:	82080102 	andhi	r0, r8, #-2147483648	; 0x80000000
    131c:	02000005 	andeq	r0, r0, #5
    1320:	05e30702 	strbeq	r0, [r3, #1794]!	; 0x702
    1324:	94040000 	strls	r0, [r4], #-0
    1328:	02000003 	andeq	r0, r0, #3
    132c:	0065070b 	rsbeq	r0, r5, fp, lsl #14
    1330:	54050000 	strpl	r0, [r5], #-0
    1334:	02000000 	andeq	r0, r0, #0
    1338:	12600704 	rsbne	r0, r0, #4, 14	; 0x100000
    133c:	65050000 	strvs	r0, [r5, #-0]
    1340:	06000000 	streq	r0, [r0], -r0
    1344:	00000065 	andeq	r0, r0, r5, rrx
    1348:	00071507 	andeq	r1, r7, r7, lsl #10
    134c:	3a010700 	bcc	42f54 <_bss_end+0x3a070>
    1350:	03000000 	movweq	r0, #0
    1354:	00bf0c06 	adcseq	r0, pc, r6, lsl #24
    1358:	b4080000 	strlt	r0, [r8], #-0
    135c:	00000007 	andeq	r0, r0, r7
    1360:	0007c508 	andeq	ip, r7, r8, lsl #10
    1364:	19080100 	stmdbne	r8, {r8}
    1368:	02000008 	andeq	r0, r0, #8
    136c:	00081308 	andeq	r1, r8, r8, lsl #6
    1370:	ee080300 	cdp	3, 0, cr0, cr8, cr0, {0}
    1374:	04000007 	streq	r0, [r0], #-7
    1378:	0007f408 	andeq	pc, r7, r8, lsl #8
    137c:	30080500 	andcc	r0, r8, r0, lsl #10
    1380:	06000007 	streq	r0, [r0], -r7
    1384:	00080d08 	andeq	r0, r8, r8, lsl #26
    1388:	f8080700 			; <UNDEFINED> instruction: 0xf8080700
    138c:	08000003 	stmdaeq	r0, {r0, r1}
    1390:	02ec0700 	rsceq	r0, ip, #0, 14
    1394:	04050000 	streq	r0, [r5], #-0
    1398:	00000033 	andeq	r0, r0, r3, lsr r0
    139c:	ea0c1803 	b	3073b0 <_bss_end+0x2fe4cc>
    13a0:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    13a4:	00000724 	andeq	r0, r0, r4, lsr #14
    13a8:	07e10800 	strbeq	r0, [r1, r0, lsl #16]!
    13ac:	08010000 	stmdaeq	r1, {}	; <UNPREDICTABLE>
    13b0:	0000029e 	muleq	r0, lr, r2
    13b4:	6f4c0902 	svcvs	0x004c0902
    13b8:	00030077 	andeq	r0, r3, r7, ror r0
    13bc:	00047f0a 	andeq	r7, r4, sl, lsl #30
    13c0:	23030400 	movwcs	r0, #13312	; 0x3400
    13c4:	00031607 	andeq	r1, r3, r7, lsl #12
    13c8:	03610b00 	cmneq	r1, #0, 22
    13cc:	27030000 	strcs	r0, [r3, -r0]
    13d0:	00032119 	andeq	r2, r3, r9, lsl r1
    13d4:	400c0000 	andmi	r0, ip, r0
    13d8:	03000006 	movweq	r0, #6
    13dc:	03310a2b 	teqeq	r1, #176128	; 0x2b000
    13e0:	03260000 			; <UNDEFINED> instruction: 0x03260000
    13e4:	1d020000 	stcne	0, cr0, [r2, #-0]
    13e8:	32000001 	andcc	r0, r0, #1
    13ec:	0d000001 	stceq	0, cr0, [r0, #-4]
    13f0:	0000032d 	andeq	r0, r0, sp, lsr #6
    13f4:	0000540e 	andeq	r5, r0, lr, lsl #8
    13f8:	03330e00 	teqeq	r3, #0, 28
    13fc:	330e0000 	movwcc	r0, #57344	; 0xe000
    1400:	00000003 	andeq	r0, r0, r3
    1404:	0007a10c 	andeq	sl, r7, ip, lsl #2
    1408:	0a2d0300 	beq	b42010 <_bss_end+0xb3912c>
    140c:	00000553 	andeq	r0, r0, r3, asr r5
    1410:	00000326 	andeq	r0, r0, r6, lsr #6
    1414:	00014b02 	andeq	r4, r1, r2, lsl #22
    1418:	00016000 	andeq	r6, r1, r0
    141c:	032d0d00 			; <UNDEFINED> instruction: 0x032d0d00
    1420:	540e0000 	strpl	r0, [lr], #-0
    1424:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    1428:	00000333 	andeq	r0, r0, r3, lsr r3
    142c:	0003330e 	andeq	r3, r3, lr, lsl #6
    1430:	8d0c0000 	stchi	0, cr0, [ip, #-0]
    1434:	03000004 	movweq	r0, #4
    1438:	07690a2f 	strbeq	r0, [r9, -pc, lsr #20]!
    143c:	03260000 			; <UNDEFINED> instruction: 0x03260000
    1440:	79020000 	stmdbvc	r2, {}	; <UNPREDICTABLE>
    1444:	8e000001 	cdphi	0, 0, cr0, cr0, cr1, {0}
    1448:	0d000001 	stceq	0, cr0, [r0, #-4]
    144c:	0000032d 	andeq	r0, r0, sp, lsr #6
    1450:	0000540e 	andeq	r5, r0, lr, lsl #8
    1454:	03330e00 	teqeq	r3, #0, 28
    1458:	330e0000 	movwcc	r0, #57344	; 0xe000
    145c:	00000003 	andeq	r0, r0, r3
    1460:	0004e10c 	andeq	lr, r4, ip, lsl #2
    1464:	0a310300 	beq	c4206c <_bss_end+0xc39188>
    1468:	000001e2 	andeq	r0, r0, r2, ror #3
    146c:	00000326 	andeq	r0, r0, r6, lsr #6
    1470:	0001a702 	andeq	sl, r1, r2, lsl #14
    1474:	0001bc00 	andeq	fp, r1, r0, lsl #24
    1478:	032d0d00 			; <UNDEFINED> instruction: 0x032d0d00
    147c:	540e0000 	strpl	r0, [lr], #-0
    1480:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    1484:	00000333 	andeq	r0, r0, r3, lsr r3
    1488:	0003330e 	andeq	r3, r3, lr, lsl #6
    148c:	8b0c0000 	blhi	301494 <_bss_end+0x2f85b0>
    1490:	03000002 	movweq	r0, #2
    1494:	06110a32 			; <UNDEFINED> instruction: 0x06110a32
    1498:	03260000 			; <UNDEFINED> instruction: 0x03260000
    149c:	d5020000 	strle	r0, [r2, #-0]
    14a0:	ea000001 	b	14ac <CPSR_IRQ_INHIBIT+0x142c>
    14a4:	0d000001 	stceq	0, cr0, [r0, #-4]
    14a8:	0000032d 	andeq	r0, r0, sp, lsr #6
    14ac:	0000540e 	andeq	r5, r0, lr, lsl #8
    14b0:	03330e00 	teqeq	r3, #0, 28
    14b4:	330e0000 	movwcc	r0, #57344	; 0xe000
    14b8:	00000003 	andeq	r0, r0, r3
    14bc:	00047f0c 	andeq	r7, r4, ip, lsl #30
    14c0:	05350300 	ldreq	r0, [r5, #-768]!	; 0xfffffd00
    14c4:	00000367 	andeq	r0, r0, r7, ror #6
    14c8:	00000339 	andeq	r0, r0, r9, lsr r3
    14cc:	00020301 	andeq	r0, r2, r1, lsl #6
    14d0:	00020e00 	andeq	r0, r2, r0, lsl #28
    14d4:	03390d00 	teqeq	r9, #0, 26
    14d8:	650e0000 	strvs	r0, [lr, #-0]
    14dc:	00000000 	andeq	r0, r0, r0
    14e0:	0007440f 	andeq	r4, r7, pc, lsl #8
    14e4:	0a380300 	beq	e020ec <_bss_end+0xdf9208>
    14e8:	000006ec 	andeq	r0, r0, ip, ror #13
    14ec:	00022301 	andeq	r2, r2, r1, lsl #6
    14f0:	00023300 	andeq	r3, r2, r0, lsl #6
    14f4:	03390d00 	teqeq	r9, #0, 26
    14f8:	540e0000 	strpl	r0, [lr], #-0
    14fc:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    1500:	00000076 	andeq	r0, r0, r6, ror r0
    1504:	046d0c00 	strbteq	r0, [sp], #-3072	; 0xfffff400
    1508:	3a030000 	bcc	c1510 <_bss_end+0xb862c>
    150c:	0004f414 	andeq	pc, r4, r4, lsl r4	; <UNPREDICTABLE>
    1510:	00007600 	andeq	r7, r0, r0, lsl #12
    1514:	024c0100 	subeq	r0, ip, #0, 2
    1518:	02570000 	subseq	r0, r7, #0
    151c:	2d0d0000 	stccs	0, cr0, [sp, #-0]
    1520:	0e000003 	cdpeq	0, 0, cr0, cr0, cr3, {0}
    1524:	00000054 	andeq	r0, r0, r4, asr r0
    1528:	07c10f00 	strbeq	r0, [r1, r0, lsl #30]
    152c:	3d030000 	stccc	0, cr0, [r3, #-0]
    1530:	00030f0a 	andeq	r0, r3, sl, lsl #30
    1534:	026c0100 	rsbeq	r0, ip, #0, 2
    1538:	027c0000 	rsbseq	r0, ip, #0
    153c:	390d0000 	stmdbcc	sp, {}	; <UNPREDICTABLE>
    1540:	0e000003 	cdpeq	0, 0, cr0, cr0, cr3, {0}
    1544:	00000054 	andeq	r0, r0, r4, asr r0
    1548:	0003260e 	andeq	r2, r3, lr, lsl #12
    154c:	040f0000 	streq	r0, [pc], #-0	; 1554 <CPSR_IRQ_INHIBIT+0x14d4>
    1550:	03000004 	movweq	r0, #4
    1554:	04a60a3f 	strteq	r0, [r6], #2623	; 0xa3f
    1558:	91010000 	mrsls	r0, (UNDEF: 1)
    155c:	9c000002 	stcls	0, cr0, [r0], {2}
    1560:	0d000002 	stceq	0, cr0, [r0, #-8]
    1564:	00000339 	andeq	r0, r0, r9, lsr r3
    1568:	0000540e 	andeq	r5, r0, lr, lsl #8
    156c:	fd0f0000 	stc2	0, cr0, [pc, #-0]	; 1574 <CPSR_IRQ_INHIBIT+0x14f4>
    1570:	03000005 	movweq	r0, #5
    1574:	02c10a41 	sbceq	r0, r1, #266240	; 0x41000
    1578:	b1010000 	mrslt	r0, (UNDEF: 1)
    157c:	c1000002 	tstgt	r0, r2
    1580:	0d000002 	stceq	0, cr0, [r0, #-8]
    1584:	00000339 	andeq	r0, r0, r9, lsr r3
    1588:	0000540e 	andeq	r5, r0, lr, lsl #8
    158c:	00bf0e00 	adcseq	r0, pc, r0, lsl #28
    1590:	0f000000 	svceq	0x00000000
    1594:	000007cc 	andeq	r0, r0, ip, asr #15
    1598:	ab0a4203 	blge	291dac <_bss_end+0x288ec8>
    159c:	01000006 	tsteq	r0, r6
    15a0:	000002d6 	ldrdeq	r0, [r0], -r6
    15a4:	000002e6 	andeq	r0, r0, r6, ror #5
    15a8:	0003390d 	andeq	r3, r3, sp, lsl #18
    15ac:	00540e00 	subseq	r0, r4, r0, lsl #28
    15b0:	bf0e0000 	svclt	0x000e0000
    15b4:	00000000 	andeq	r0, r0, r0
    15b8:	00027010 	andeq	r7, r2, r0, lsl r0
    15bc:	0a430300 	beq	10c21c4 <_bss_end+0x10b92e0>
    15c0:	00000420 	andeq	r0, r0, r0, lsr #8
    15c4:	00000326 	andeq	r0, r0, r6, lsr #6
    15c8:	0002fb01 	andeq	pc, r2, r1, lsl #22
    15cc:	032d0d00 			; <UNDEFINED> instruction: 0x032d0d00
    15d0:	540e0000 	strpl	r0, [lr], #-0
    15d4:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    15d8:	000000bf 	strheq	r0, [r0], -pc	; <UNPREDICTABLE>
    15dc:	0003330e 	andeq	r3, r3, lr, lsl #6
    15e0:	03330e00 	teqeq	r3, #0, 28
    15e4:	00000000 	andeq	r0, r0, r0
    15e8:	0000ea05 	andeq	lr, r0, r5, lsl #20
    15ec:	65041100 	strvs	r1, [r4, #-256]	; 0xffffff00
    15f0:	05000000 	streq	r0, [r0, #-0]
    15f4:	0000031b 	andeq	r0, r0, fp, lsl r3
    15f8:	f3020102 	vrhadd.u8	d0, d2, d2
    15fc:	11000003 	tstne	r0, r3
    1600:	00031604 	andeq	r1, r3, r4, lsl #12
    1604:	54041200 	strpl	r1, [r4], #-512	; 0xfffffe00
    1608:	11000000 	mrsne	r0, (UNDEF: 0)
    160c:	0000ea04 	andeq	lr, r0, r4, lsl #20
    1610:	059f1300 	ldreq	r1, [pc, #768]	; 1918 <CPSR_IRQ_INHIBIT+0x1898>
    1614:	47030000 	strmi	r0, [r3, -r0]
    1618:	0000ea16 	andeq	lr, r0, r6, lsl sl
    161c:	61681400 	cmnvs	r8, r0, lsl #8
    1620:	0704006c 	streq	r0, [r4, -ip, rrx]
    1624:	0004b80b 	andeq	fp, r4, fp, lsl #16
    1628:	07fa1500 	ldrbeq	r1, [sl, r0, lsl #10]!
    162c:	09040000 	stmdbeq	r4, {}	; <UNPREDICTABLE>
    1630:	00006c1c 	andeq	r6, r0, ip, lsl ip
    1634:	e6b28000 	ldrt	r8, [r2], r0
    1638:	04d1150e 	ldrbeq	r1, [r1], #1294	; 0x50e
    163c:	0c040000 	stceq	0, cr0, [r4], {-0}
    1640:	0004c41d 	andeq	ip, r4, sp, lsl r4
    1644:	00000000 	andeq	r0, r0, r0
    1648:	05a51520 	streq	r1, [r5, #1312]!	; 0x520
    164c:	0f040000 	svceq	0x00040000
    1650:	0004c41d 	andeq	ip, r4, sp, lsl r4
    1654:	20000000 	andcs	r0, r0, r0
    1658:	06541620 	ldrbeq	r1, [r4], -r0, lsr #12
    165c:	12040000 	andne	r0, r4, #0
    1660:	00006018 	andeq	r6, r0, r8, lsl r0
    1664:	98153600 	ldmdals	r5, {r9, sl, ip, sp}
    1668:	04000007 	streq	r0, [r0], #-7
    166c:	04c41d44 	strbeq	r1, [r4], #3396	; 0xd44
    1670:	50000000 	andpl	r0, r0, r0
    1674:	56152021 	ldrpl	r2, [r5], -r1, lsr #32
    1678:	04000002 	streq	r0, [r0], #-2
    167c:	04c41d73 	strbeq	r1, [r4], #3443	; 0xd73
    1680:	b2000000 	andlt	r0, r0, #0
    1684:	cb072000 	blgt	1c968c <_bss_end+0x1c07a8>
    1688:	05000008 	streq	r0, [r0, #-8]
    168c:	00003304 	andeq	r3, r0, r4, lsl #6
    1690:	10750400 	rsbsne	r0, r5, r0, lsl #8
    1694:	00000403 	andeq	r0, r0, r3, lsl #8
    1698:	00097f08 	andeq	r7, r9, r8, lsl #30
    169c:	a7080000 	strge	r0, [r8, -r0]
    16a0:	0100000b 	tsteq	r0, fp
    16a4:	000bce08 	andeq	ip, fp, r8, lsl #28
    16a8:	4d080200 	sfmmi	f0, 4, [r8, #-0]
    16ac:	0300000b 	movweq	r0, #11
    16b0:	0008ac08 	andeq	sl, r8, r8, lsl #24
    16b4:	b9080400 	stmdblt	r8, {sl}
    16b8:	05000008 	streq	r0, [r0, #-8]
    16bc:	000b8f08 	andeq	r8, fp, r8, lsl #30
    16c0:	15080600 	strne	r0, [r8, #-1536]	; 0xfffffa00
    16c4:	0700000c 	streq	r0, [r0, -ip]
    16c8:	000c2308 	andeq	r2, ip, r8, lsl #6
    16cc:	b3080800 	movwlt	r0, #34816	; 0x8800
    16d0:	09000009 	stmdbeq	r0, {r0, r3}
    16d4:	09060700 	stmdbeq	r6, {r8, r9, sl}
    16d8:	04050000 	streq	r0, [r5], #-0
    16dc:	00000033 	andeq	r0, r0, r3, lsr r0
    16e0:	46108304 	ldrmi	r8, [r0], -r4, lsl #6
    16e4:	08000004 	stmdaeq	r0, {r2}
    16e8:	00000927 	andeq	r0, r0, r7, lsr #18
    16ec:	087a0800 	ldmdaeq	sl!, {fp}^
    16f0:	08010000 	stmdaeq	r1, {}	; <UNPREDICTABLE>
    16f4:	00000a1d 	andeq	r0, r0, sp, lsl sl
    16f8:	0a280802 	beq	a03708 <_bss_end+0x9fa824>
    16fc:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    1700:	00000a91 	muleq	r0, r1, sl
    1704:	08700804 	ldmdaeq	r0!, {r2, fp}^
    1708:	08050000 	stmdaeq	r5, {}	; <UNPREDICTABLE>
    170c:	000008e4 	andeq	r0, r0, r4, ror #17
    1710:	08f50806 	ldmeq	r5!, {r1, r2, fp}^
    1714:	00070000 	andeq	r0, r7, r0
    1718:	000bb507 	andeq	fp, fp, r7, lsl #10
    171c:	33040500 	movwcc	r0, #17664	; 0x4500
    1720:	04000000 	streq	r0, [r0], #-0
    1724:	04a7108f 	strteq	r1, [r7], #143	; 0x8f
    1728:	41090000 	mrsmi	r0, (UNDEF: 9)
    172c:	1d005855 	stcne	8, cr5, [r0, #-340]	; 0xfffffeac
    1730:	000b3a08 	andeq	r3, fp, r8, lsl #20
    1734:	31082b00 	tstcc	r8, r0, lsl #22
    1738:	2d00000c 	stccs	0, cr0, [r0, #-48]	; 0xffffffd0
    173c:	000c3708 	andeq	r3, ip, r8, lsl #14
    1740:	53092e00 	movwpl	r2, #40448	; 0x9e00
    1744:	3000494d 	andcc	r4, r0, sp, asr #18
    1748:	000bdc08 	andeq	sp, fp, r8, lsl #24
    174c:	e3083100 	movw	r3, #33024	; 0x8100
    1750:	3200000b 	andcc	r0, r0, #11
    1754:	000bea08 	andeq	lr, fp, r8, lsl #20
    1758:	f1083300 			; <UNDEFINED> instruction: 0xf1083300
    175c:	3400000b 	strcc	r0, [r0], #-11
    1760:	43324909 	teqmi	r2, #147456	; 0x24000
    1764:	53093500 	movwpl	r3, #38144	; 0x9500
    1768:	36004950 			; <UNDEFINED> instruction: 0x36004950
    176c:	4d435009 	stclmi	0, cr5, [r3, #-36]	; 0xffffffdc
    1770:	c6083700 	strgt	r3, [r8], -r0, lsl #14
    1774:	39000008 	stmdbcc	r0, {r3}
    1778:	06681500 	strbteq	r1, [r8], -r0, lsl #10
    177c:	a6040000 	strge	r0, [r4], -r0
    1780:	0004c41d 	andeq	ip, r4, sp, lsl r4
    1784:	00b40000 	adcseq	r0, r4, r0
    1788:	57170020 	ldrpl	r0, [r7, -r0, lsr #32]
    178c:	02000003 	andeq	r0, r0, #3
    1790:	125b0704 	subsne	r0, fp, #4, 14	; 0x100000
    1794:	bd050000 	stclt	0, cr0, [r5, #-0]
    1798:	17000004 	strne	r0, [r0, -r4]
    179c:	00000367 	andeq	r0, r0, r7, ror #6
    17a0:	00037717 	andeq	r7, r3, r7, lsl r7
    17a4:	03871700 	orreq	r1, r7, #0, 14
    17a8:	94170000 	ldrls	r0, [r7], #-0
    17ac:	17000003 	strne	r0, [r0, -r3]
    17b0:	000003a4 	andeq	r0, r0, r4, lsr #7
    17b4:	0004a717 	andeq	sl, r4, r7, lsl r7
    17b8:	099d0a00 	ldmibeq	sp, {r9, fp}
    17bc:	05040000 	streq	r0, [r4, #-0]
    17c0:	05c60709 	strbeq	r0, [r6, #1801]	; 0x709
    17c4:	170b0000 	strne	r0, [fp, -r0]
    17c8:	05000009 	streq	r0, [r0, #-9]
    17cc:	05c61c0d 	strbeq	r1, [r6, #3085]	; 0xc0d
    17d0:	0c000000 	stceq	0, cr0, [r0], {-0}
    17d4:	00000922 	andeq	r0, r0, r2, lsr #18
    17d8:	2f1c1005 	svccs	0x001c1005
    17dc:	cc000008 	stcgt	0, cr0, [r0], {8}
    17e0:	02000005 	andeq	r0, r0, #5
    17e4:	0000051a 	andeq	r0, r0, sl, lsl r5
    17e8:	00000525 	andeq	r0, r0, r5, lsr #10
    17ec:	0005d20d 	andeq	sp, r5, sp, lsl #4
    17f0:	03b40e00 			; <UNDEFINED> instruction: 0x03b40e00
    17f4:	0c000000 	stceq	0, cr0, [r0], {-0}
    17f8:	0000099d 	muleq	r0, sp, r9
    17fc:	1b051305 	blne	146418 <_bss_end+0x13d534>
    1800:	d200000b 	andle	r0, r0, #11
    1804:	01000005 	tsteq	r0, r5
    1808:	0000053e 	andeq	r0, r0, lr, lsr r5
    180c:	00000549 	andeq	r0, r0, r9, asr #10
    1810:	0005d20d 	andeq	sp, r5, sp, lsl #4
    1814:	04bd0e00 	ldrteq	r0, [sp], #3584	; 0xe00
    1818:	0f000000 	svceq	0x00000000
    181c:	000009c5 	andeq	r0, r0, r5, asr #19
    1820:	d50a1605 	strle	r1, [sl, #-1541]	; 0xfffff9fb
    1824:	0100000a 	tsteq	r0, sl
    1828:	0000055e 	andeq	r0, r0, lr, asr r5
    182c:	00000569 	andeq	r0, r0, r9, ror #10
    1830:	0005d20d 	andeq	sp, r5, sp, lsl #4
    1834:	04030e00 	streq	r0, [r3], #-3584	; 0xfffff200
    1838:	0f000000 	svceq	0x00000000
    183c:	00000bf8 	strdeq	r0, [r0], -r8
    1840:	d60a1805 	strle	r1, [sl], -r5, lsl #16
    1844:	01000009 	tsteq	r0, r9
    1848:	0000057e 	andeq	r0, r0, lr, ror r5
    184c:	00000589 	andeq	r0, r0, r9, lsl #11
    1850:	0005d20d 	andeq	sp, r5, sp, lsl #4
    1854:	04030e00 	streq	r0, [r3], #-3584	; 0xfffff200
    1858:	0f000000 	svceq	0x00000000
    185c:	00000882 	andeq	r0, r0, r2, lsl #17
    1860:	9b0a1b05 	blls	28847c <_bss_end+0x27f598>
    1864:	0100000a 	tsteq	r0, sl
    1868:	0000059e 	muleq	r0, lr, r5
    186c:	000005a9 	andeq	r0, r0, r9, lsr #11
    1870:	0005d20d 	andeq	sp, r5, sp, lsl #4
    1874:	04460e00 	strbeq	r0, [r6], #-3584	; 0xfffff200
    1878:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
    187c:	00000991 	muleq	r0, r1, r9
    1880:	2d0a1d05 	stccs	13, cr1, [sl, #-20]	; 0xffffffec
    1884:	01000009 	tsteq	r0, r9
    1888:	000005ba 			; <UNDEFINED> instruction: 0x000005ba
    188c:	0005d20d 	andeq	sp, r5, sp, lsl #4
    1890:	04460e00 	strbeq	r0, [r6], #-3584	; 0xfffff200
    1894:	00000000 	andeq	r0, r0, r0
    1898:	00710411 	rsbseq	r0, r1, r1, lsl r4
    189c:	04120000 	ldreq	r0, [r2], #-0
    18a0:	00000071 	andeq	r0, r0, r1, ror r0
    18a4:	04e70411 	strbteq	r0, [r7], #1041	; 0x411
    18a8:	c0130000 	andsgt	r0, r3, r0
    18ac:	0500000b 	streq	r0, [r0, #-11]
    18b0:	04e71e20 	strbteq	r1, [r7], #3616	; 0xe20
    18b4:	8b190000 	blhi	6418bc <_bss_end+0x6389d8>
    18b8:	0100000c 	tsteq	r0, ip
    18bc:	00331004 	eorseq	r1, r3, r4
    18c0:	8c600000 	stclhi	0, cr0, [r0], #-0
    18c4:	00640000 	rsbeq	r0, r4, r0
    18c8:	9c010000 	stcls	0, cr0, [r1], {-0}
    18cc:	00001e00 	andeq	r1, r0, r0, lsl #28
    18d0:	27000200 	strcs	r0, [r0, -r0, lsl #4]
    18d4:	04000007 	streq	r0, [r0], #-7
    18d8:	00092301 	andeq	r2, r9, r1, lsl #6
    18dc:	00000000 	andeq	r0, r0, r0
    18e0:	000c9800 	andeq	r9, ip, r0, lsl #16
    18e4:	00017500 	andeq	r7, r1, r0, lsl #10
    18e8:	000ce500 	andeq	lr, ip, r0, lsl #10
    18ec:	4b800100 	blmi	fe001cf4 <_bss_end+0xfdff8e10>
    18f0:	04000001 	streq	r0, [r0], #-1
    18f4:	00073900 	andeq	r3, r7, r0, lsl #18
    18f8:	00010400 	andeq	r0, r1, r0, lsl #8
    18fc:	04000000 	streq	r0, [r0], #-0
    1900:	00000cf1 	strdeq	r0, [r0], -r1
    1904:	00000175 	andeq	r0, r0, r5, ror r1
    1908:	00008ce4 	andeq	r8, r0, r4, ror #25
    190c:	00000118 	andeq	r0, r0, r8, lsl r1
    1910:	000009d5 	ldrdeq	r0, [r0], -r5
    1914:	000da302 	andeq	sl, sp, r2, lsl #6
    1918:	07020100 	streq	r0, [r2, -r0, lsl #2]
    191c:	00000031 	andeq	r0, r0, r1, lsr r0
    1920:	00370403 	eorseq	r0, r7, r3, lsl #8
    1924:	02040000 	andeq	r0, r4, #0
    1928:	00000d9a 	muleq	r0, sl, sp
    192c:	31070301 	tstcc	r7, r1, lsl #6
    1930:	05000000 	streq	r0, [r0, #-0]
    1934:	00000d42 	andeq	r0, r0, r2, asr #26
    1938:	50100601 	andspl	r0, r0, r1, lsl #12
    193c:	06000000 	streq	r0, [r0], -r0
    1940:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
    1944:	83050074 	movwhi	r0, #20596	; 0x5074
    1948:	0100000d 	tsteq	r0, sp
    194c:	00501008 	subseq	r1, r0, r8
    1950:	25070000 	strcs	r0, [r7, #-0]
    1954:	76000000 	strvc	r0, [r0], -r0
    1958:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    195c:	00000076 	andeq	r0, r0, r6, ror r0
    1960:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
    1964:	07040900 	streq	r0, [r4, -r0, lsl #18]
    1968:	00001260 	andeq	r1, r0, r0, ror #4
    196c:	000d5a05 	andeq	r5, sp, r5, lsl #20
    1970:	150b0100 	strne	r0, [fp, #-256]	; 0xffffff00
    1974:	00000063 	andeq	r0, r0, r3, rrx
    1978:	000d4d05 	andeq	r4, sp, r5, lsl #26
    197c:	150d0100 	strne	r0, [sp, #-256]	; 0xffffff00
    1980:	00000063 	andeq	r0, r0, r3, rrx
    1984:	00003807 	andeq	r3, r0, r7, lsl #16
    1988:	0000a800 	andeq	sl, r0, r0, lsl #16
    198c:	00760800 	rsbseq	r0, r6, r0, lsl #16
    1990:	ffff0000 			; <UNDEFINED> instruction: 0xffff0000
    1994:	0500ffff 	streq	pc, [r0, #-4095]	; 0xfffff001
    1998:	00000d8c 	andeq	r0, r0, ip, lsl #27
    199c:	95151001 	ldrls	r1, [r5, #-1]
    19a0:	05000000 	streq	r0, [r0, #-0]
    19a4:	00000d68 	andeq	r0, r0, r8, ror #26
    19a8:	95151201 	ldrls	r1, [r5, #-513]	; 0xfffffdff
    19ac:	0a000000 	beq	19b4 <CPSR_IRQ_INHIBIT+0x1934>
    19b0:	00000d75 	andeq	r0, r0, r5, ror sp
    19b4:	50102b01 	andspl	r2, r0, r1, lsl #22
    19b8:	a4000000 	strge	r0, [r0], #-0
    19bc:	5800008d 	stmdapl	r0, {r0, r2, r3, r7}
    19c0:	01000000 	mrseq	r0, (UNDEF: 0)
    19c4:	0000ea9c 	muleq	r0, ip, sl
    19c8:	0dc40b00 	vstreq	d16, [r4]
    19cc:	2d010000 	stccs	0, cr0, [r1, #-0]
    19d0:	0000ea0f 	andeq	lr, r0, pc, lsl #20
    19d4:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    19d8:	38040300 	stmdacc	r4, {r8, r9}
    19dc:	0a000000 	beq	19e4 <CPSR_IRQ_INHIBIT+0x1964>
    19e0:	00000db7 			; <UNDEFINED> instruction: 0x00000db7
    19e4:	50101f01 	andspl	r1, r0, r1, lsl #30
    19e8:	4c000000 	stcmi	0, cr0, [r0], {-0}
    19ec:	5800008d 	stmdapl	r0, {r0, r2, r3, r7}
    19f0:	01000000 	mrseq	r0, (UNDEF: 0)
    19f4:	00011a9c 	muleq	r1, ip, sl
    19f8:	0dc40b00 	vstreq	d16, [r4]
    19fc:	21010000 	mrscs	r0, (UNDEF: 1)
    1a00:	00011a0f 	andeq	r1, r1, pc, lsl #20
    1a04:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1a08:	25040300 	strcs	r0, [r4, #-768]	; 0xfffffd00
    1a0c:	0c000000 	stceq	0, cr0, [r0], {-0}
    1a10:	00000dac 	andeq	r0, r0, ip, lsr #27
    1a14:	50101401 	andspl	r1, r0, r1, lsl #8
    1a18:	e4000000 	str	r0, [r0], #-0
    1a1c:	6800008c 	stmdavs	r0, {r2, r3, r7}
    1a20:	01000000 	mrseq	r0, (UNDEF: 0)
    1a24:	0001489c 	muleq	r1, ip, r8
    1a28:	00690d00 	rsbeq	r0, r9, r0, lsl #26
    1a2c:	480a1601 	stmdami	sl, {r0, r9, sl, ip}
    1a30:	02000001 	andeq	r0, r0, #1
    1a34:	03007491 	movweq	r7, #1169	; 0x491
    1a38:	00005004 	andeq	r5, r0, r4
    1a3c:	09320000 	ldmdbeq	r2!, {}	; <UNPREDICTABLE>
    1a40:	00040000 	andeq	r0, r4, r0
    1a44:	000007ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    1a48:	11330104 	teqne	r3, r4, lsl #2
    1a4c:	8a0c0000 	bhi	301a54 <_bss_end+0x2f8b70>
    1a50:	57000010 	smladpl	r0, r0, r0, r0
    1a54:	c1000018 	tstgt	r0, r8, lsl r0
    1a58:	0200000a 	andeq	r0, r0, #10
    1a5c:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
    1a60:	04030074 	streq	r0, [r3], #-116	; 0xffffff8c
    1a64:	00126007 	andseq	r6, r2, r7
    1a68:	05080300 	streq	r0, [r8, #-768]	; 0xfffffd00
    1a6c:	000001d4 	ldrdeq	r0, [r0], -r4
    1a70:	97040803 	strls	r0, [r4, -r3, lsl #16]
    1a74:	04000019 	streq	r0, [r0], #-25	; 0xffffffe7
    1a78:	000010e5 	andeq	r1, r0, r5, ror #1
    1a7c:	24162a01 	ldrcs	r2, [r6], #-2561	; 0xfffff5ff
    1a80:	04000000 	streq	r0, [r0], #-0
    1a84:	00001554 	andeq	r1, r0, r4, asr r5
    1a88:	51152f01 	tstpl	r5, r1, lsl #30
    1a8c:	05000000 	streq	r0, [r0, #-0]
    1a90:	00005704 	andeq	r5, r0, r4, lsl #14
    1a94:	00390600 	eorseq	r0, r9, r0, lsl #12
    1a98:	00660000 	rsbeq	r0, r6, r0
    1a9c:	66070000 	strvs	r0, [r7], -r0
    1aa0:	00000000 	andeq	r0, r0, r0
    1aa4:	006c0405 	rsbeq	r0, ip, r5, lsl #8
    1aa8:	04080000 	streq	r0, [r8], #-0
    1aac:	00001ceb 	andeq	r1, r0, fp, ror #25
    1ab0:	790f3601 	stmdbvc	pc, {r0, r9, sl, ip, sp}	; <UNPREDICTABLE>
    1ab4:	05000000 	streq	r0, [r0, #-0]
    1ab8:	00007f04 	andeq	r7, r0, r4, lsl #30
    1abc:	001d0600 	andseq	r0, sp, r0, lsl #12
    1ac0:	00930000 	addseq	r0, r3, r0
    1ac4:	66070000 	strvs	r0, [r7], -r0
    1ac8:	07000000 	streq	r0, [r0, -r0]
    1acc:	00000066 	andeq	r0, r0, r6, rrx
    1ad0:	08010300 	stmdaeq	r1, {r8, r9}
    1ad4:	00000582 	andeq	r0, r0, r2, lsl #11
    1ad8:	00178c09 	andseq	r8, r7, r9, lsl #24
    1adc:	12bb0100 	adcsne	r0, fp, #0, 2
    1ae0:	00000045 	andeq	r0, r0, r5, asr #32
    1ae4:	001d1909 	andseq	r1, sp, r9, lsl #18
    1ae8:	10be0100 	adcsne	r0, lr, r0, lsl #2
    1aec:	0000006d 	andeq	r0, r0, sp, rrx
    1af0:	84060103 	strhi	r0, [r6], #-259	; 0xfffffefd
    1af4:	0a000005 	beq	1b10 <CPSR_IRQ_INHIBIT+0x1a90>
    1af8:	00001474 	andeq	r1, r0, r4, ror r4
    1afc:	00930107 	addseq	r0, r3, r7, lsl #2
    1b00:	17020000 	strne	r0, [r2, -r0]
    1b04:	0001e606 	andeq	lr, r1, r6, lsl #12
    1b08:	0f430b00 	svceq	0x00430b00
    1b0c:	0b000000 	bleq	1b14 <CPSR_IRQ_INHIBIT+0x1a94>
    1b10:	00001391 	muleq	r0, r1, r3
    1b14:	18bc0b01 	ldmne	ip!, {r0, r8, r9, fp}
    1b18:	0b020000 	bleq	81b20 <_bss_end+0x78c3c>
    1b1c:	00001c2d 	andeq	r1, r0, sp, lsr #24
    1b20:	17fb0b03 	ldrbne	r0, [fp, r3, lsl #22]!
    1b24:	0b040000 	bleq	101b2c <_bss_end+0xf8c48>
    1b28:	00001b36 	andeq	r1, r0, r6, lsr fp
    1b2c:	1a9a0b05 	bne	fe684748 <_bss_end+0xfe67b864>
    1b30:	0b060000 	bleq	181b38 <_bss_end+0x178c54>
    1b34:	00000f64 	andeq	r0, r0, r4, ror #30
    1b38:	1b4b0b07 	blne	12c475c <_bss_end+0x12bb878>
    1b3c:	0b080000 	bleq	201b44 <_bss_end+0x1f8c60>
    1b40:	00001b59 	andeq	r1, r0, r9, asr fp
    1b44:	1c200b09 			; <UNDEFINED> instruction: 0x1c200b09
    1b48:	0b0a0000 	bleq	281b50 <_bss_end+0x278c6c>
    1b4c:	00001752 	andeq	r1, r0, r2, asr r7
    1b50:	11260b0b 			; <UNDEFINED> instruction: 0x11260b0b
    1b54:	0b0c0000 	bleq	301b5c <_bss_end+0x2f8c78>
    1b58:	00001203 	andeq	r1, r0, r3, lsl #4
    1b5c:	14b80b0d 	ldrtne	r0, [r8], #2829	; 0xb0d
    1b60:	0b0e0000 	bleq	381b68 <_bss_end+0x378c84>
    1b64:	000014ce 	andeq	r1, r0, lr, asr #9
    1b68:	13cb0b0f 	bicne	r0, fp, #15360	; 0x3c00
    1b6c:	0b100000 	bleq	401b74 <_bss_end+0x3f8c90>
    1b70:	000017df 	ldrdeq	r1, [r0], -pc	; <UNPREDICTABLE>
    1b74:	14370b11 	ldrtne	r0, [r7], #-2833	; 0xfffff4ef
    1b78:	0b120000 	bleq	481b80 <_bss_end+0x478c9c>
    1b7c:	00001eb2 			; <UNDEFINED> instruction: 0x00001eb2
    1b80:	0fcd0b13 	svceq	0x00cd0b13
    1b84:	0b140000 	bleq	501b8c <_bss_end+0x4f8ca8>
    1b88:	0000145b 	andeq	r1, r0, fp, asr r4
    1b8c:	0f0a0b15 	svceq	0x000a0b15
    1b90:	0b160000 	bleq	581b98 <_bss_end+0x578cb4>
    1b94:	00001c50 	andeq	r1, r0, r0, asr ip
    1b98:	1d720b17 	fldmdbxne	r2!, {d16-d26}	;@ Deprecated
    1b9c:	0b180000 	bleq	601ba4 <_bss_end+0x5f8cc0>
    1ba0:	00001480 	andeq	r1, r0, r0, lsl #9
    1ba4:	192e0b19 	stmdbne	lr!, {r0, r3, r4, r8, r9, fp}
    1ba8:	0b1a0000 	bleq	681bb0 <_bss_end+0x678ccc>
    1bac:	00001c5e 	andeq	r1, r0, lr, asr ip
    1bb0:	0e390b1b 	vmoveq.32	r0, d9[1]
    1bb4:	0b1c0000 	bleq	701bbc <_bss_end+0x6f8cd8>
    1bb8:	00001c6c 	andeq	r1, r0, ip, ror #24
    1bbc:	1c7a0b1d 			; <UNDEFINED> instruction: 0x1c7a0b1d
    1bc0:	0b1e0000 	bleq	781bc8 <_bss_end+0x778ce4>
    1bc4:	00000de7 	andeq	r0, r0, r7, ror #27
    1bc8:	1ca40b1f 	fstmiaxne	r4!, {d0-d14}	;@ Deprecated
    1bcc:	0b200000 	bleq	801bd4 <_bss_end+0x7f8cf0>
    1bd0:	000019db 	ldrdeq	r1, [r0], -fp
    1bd4:	17b10b21 	ldrne	r0, [r1, r1, lsr #22]!
    1bd8:	0b220000 	bleq	881be0 <_bss_end+0x878cfc>
    1bdc:	00001c43 	andeq	r1, r0, r3, asr #24
    1be0:	16b50b23 	ldrtne	r0, [r5], r3, lsr #22
    1be4:	0b240000 	bleq	901bec <_bss_end+0x8f8d08>
    1be8:	000015b7 			; <UNDEFINED> instruction: 0x000015b7
    1bec:	12d10b25 	sbcsne	r0, r1, #37888	; 0x9400
    1bf0:	0b260000 	bleq	981bf8 <_bss_end+0x978d14>
    1bf4:	000015d5 	ldrdeq	r1, [r0], -r5
    1bf8:	136d0b27 	cmnne	sp, #39936	; 0x9c00
    1bfc:	0b280000 	bleq	a01c04 <_bss_end+0x9f8d20>
    1c00:	000015e5 	andeq	r1, r0, r5, ror #11
    1c04:	15f50b29 	ldrbne	r0, [r5, #2857]!	; 0xb29
    1c08:	0b2a0000 	bleq	a81c10 <_bss_end+0xa78d2c>
    1c0c:	00001738 	andeq	r1, r0, r8, lsr r7
    1c10:	155e0b2b 	ldrbne	r0, [lr, #-2859]	; 0xfffff4d5
    1c14:	0b2c0000 	bleq	b01c1c <_bss_end+0xaf8d38>
    1c18:	000019e8 	andeq	r1, r0, r8, ror #19
    1c1c:	13120b2d 	tstne	r2, #46080	; 0xb400
    1c20:	002e0000 	eoreq	r0, lr, r0
    1c24:	0014f00a 	andseq	pc, r4, sl
    1c28:	93010700 	movwls	r0, #5888	; 0x1700
    1c2c:	03000000 	movweq	r0, #0
    1c30:	03c70617 	biceq	r0, r7, #24117248	; 0x1700000
    1c34:	250b0000 	strcs	r0, [fp, #-0]
    1c38:	00000012 	andeq	r0, r0, r2, lsl r0
    1c3c:	000e770b 	andeq	r7, lr, fp, lsl #14
    1c40:	600b0100 	andvs	r0, fp, r0, lsl #2
    1c44:	0200001e 	andeq	r0, r0, #30
    1c48:	001cf30b 	andseq	pc, ip, fp, lsl #6
    1c4c:	450b0300 	strmi	r0, [fp, #-768]	; 0xfffffd00
    1c50:	04000012 	streq	r0, [r0], #-18	; 0xffffffee
    1c54:	000f2f0b 	andeq	r2, pc, fp, lsl #30
    1c58:	ee0b0500 	cfsh32	mvfx0, mvfx11, #0
    1c5c:	06000012 			; <UNDEFINED> instruction: 0x06000012
    1c60:	0012350b 	andseq	r3, r2, fp, lsl #10
    1c64:	870b0700 	strhi	r0, [fp, -r0, lsl #14]
    1c68:	0800001b 	stmdaeq	r0, {r0, r1, r3, r4}
    1c6c:	001cd80b 	andseq	sp, ip, fp, lsl #16
    1c70:	be0b0900 	vmlalt.f16	s0, s22, s0	; <UNPREDICTABLE>
    1c74:	0a00001a 	beq	1ce4 <CPSR_IRQ_INHIBIT+0x1c64>
    1c78:	000f820b 	andeq	r8, pc, fp, lsl #4
    1c7c:	8f0b0b00 	svchi	0x000b0b00
    1c80:	0c000012 	stceq	0, cr0, [r0], {18}
    1c84:	000ef80b 	andeq	pc, lr, fp, lsl #16
    1c88:	950b0d00 	strls	r0, [fp, #-3328]	; 0xfffff300
    1c8c:	0e00001e 	mcreq	0, 0, r0, cr0, cr14, {0}
    1c90:	0017250b 	andseq	r2, r7, fp, lsl #10
    1c94:	020b0f00 	andeq	r0, fp, #0, 30
    1c98:	10000014 	andne	r0, r0, r4, lsl r0
    1c9c:	0017620b 	andseq	r6, r7, fp, lsl #4
    1ca0:	b40b1100 	strlt	r1, [fp], #-256	; 0xffffff00
    1ca4:	1200001d 	andne	r0, r0, #29
    1ca8:	0010450b 	andseq	r4, r0, fp, lsl #10
    1cac:	150b1300 	strne	r1, [fp, #-768]	; 0xfffffd00
    1cb0:	14000014 	strne	r0, [r0], #-20	; 0xffffffec
    1cb4:	0016780b 	andseq	r7, r6, fp, lsl #16
    1cb8:	100b1500 	andne	r1, fp, r0, lsl #10
    1cbc:	16000012 			; <UNDEFINED> instruction: 0x16000012
    1cc0:	0016c40b 	andseq	ip, r6, fp, lsl #8
    1cc4:	da0b1700 	ble	2c78cc <_bss_end+0x2be9e8>
    1cc8:	18000014 	stmdane	r0, {r2, r4}
    1ccc:	000f4d0b 	andeq	r4, pc, fp, lsl #26
    1cd0:	5b0b1900 	blpl	2c80d8 <_bss_end+0x2bf1f4>
    1cd4:	1a00001d 	bne	1d50 <CPSR_IRQ_INHIBIT+0x1cd0>
    1cd8:	0016440b 	andseq	r4, r6, fp, lsl #8
    1cdc:	ec0b1b00 			; <UNDEFINED> instruction: 0xec0b1b00
    1ce0:	1c000013 	stcne	0, cr0, [r0], {19}
    1ce4:	000e220b 	andeq	r2, lr, fp, lsl #4
    1ce8:	8f0b1d00 	svchi	0x000b1d00
    1cec:	1e000015 	mcrne	0, 0, r0, cr0, cr5, {0}
    1cf0:	00157b0b 	andseq	r7, r5, fp, lsl #22
    1cf4:	7b0b1f00 	blvc	2c98fc <_bss_end+0x2c0a18>
    1cf8:	2000001a 	andcs	r0, r0, sl, lsl r0
    1cfc:	001b060b 	andseq	r0, fp, fp, lsl #12
    1d00:	3a0b2100 	bcc	2ca108 <_bss_end+0x2c1224>
    1d04:	2200001d 	andcs	r0, r0, #29
    1d08:	00131f0b 	andseq	r1, r3, fp, lsl #30
    1d0c:	de0b2300 	cdple	3, 0, cr2, cr11, cr0, {0}
    1d10:	24000018 	strcs	r0, [r0], #-24	; 0xffffffe8
    1d14:	001ad30b 	andseq	sp, sl, fp, lsl #6
    1d18:	f70b2500 			; <UNDEFINED> instruction: 0xf70b2500
    1d1c:	26000019 			; <UNDEFINED> instruction: 0x26000019
    1d20:	001a0b0b 	andseq	r0, sl, fp, lsl #22
    1d24:	1f0b2700 	svcne	0x000b2700
    1d28:	2800001a 	stmdacs	r0, {r1, r3, r4}
    1d2c:	0010d00b 	andseq	sp, r0, fp
    1d30:	300b2900 	andcc	r2, fp, r0, lsl #18
    1d34:	2a000010 	bcs	1d7c <CPSR_IRQ_INHIBIT+0x1cfc>
    1d38:	0010580b 	andseq	r5, r0, fp, lsl #16
    1d3c:	d00b2b00 	andle	r2, fp, r0, lsl #22
    1d40:	2c00001b 	stccs	0, cr0, [r0], {27}
    1d44:	0010ad0b 	andseq	sl, r0, fp, lsl #26
    1d48:	e40b2d00 	str	r2, [fp], #-3328	; 0xfffff300
    1d4c:	2e00001b 	mcrcs	0, 0, r0, cr0, cr11, {0}
    1d50:	001bf80b 	andseq	pc, fp, fp, lsl #16
    1d54:	0c0b2f00 	stceq	15, cr2, [fp], {-0}
    1d58:	3000001c 	andcc	r0, r0, ip, lsl r0
    1d5c:	0012a10b 	andseq	sl, r2, fp, lsl #2
    1d60:	7b0b3100 	blvc	2ce168 <_bss_end+0x2c5284>
    1d64:	32000012 	andcc	r0, r0, #18
    1d68:	0015a30b 	andseq	sl, r5, fp, lsl #6
    1d6c:	750b3300 	strvc	r3, [fp, #-768]	; 0xfffffd00
    1d70:	34000017 	strcc	r0, [r0], #-23	; 0xffffffe9
    1d74:	001de90b 	andseq	lr, sp, fp, lsl #18
    1d78:	ca0b3500 	bgt	2cf180 <_bss_end+0x2c629c>
    1d7c:	3600000d 	strcc	r0, [r0], -sp
    1d80:	0013a10b 	andseq	sl, r3, fp, lsl #2
    1d84:	b60b3700 	strlt	r3, [fp], -r0, lsl #14
    1d88:	38000013 	stmdacc	r0, {r0, r1, r4}
    1d8c:	0016050b 	andseq	r0, r6, fp, lsl #10
    1d90:	2f0b3900 	svccs	0x000b3900
    1d94:	3a000016 	bcc	1df4 <CPSR_IRQ_INHIBIT+0x1d74>
    1d98:	001e120b 	andseq	r1, lr, fp, lsl #4
    1d9c:	c90b3b00 	stmdbgt	fp, {r8, r9, fp, ip, sp}
    1da0:	3c000018 	stccc	0, cr0, [r0], {24}
    1da4:	0013440b 	andseq	r4, r3, fp, lsl #8
    1da8:	890b3d00 	stmdbhi	fp, {r8, sl, fp, ip, sp}
    1dac:	3e00000e 	cdpcc	0, 0, cr0, cr0, cr14, {0}
    1db0:	000e470b 	andeq	r4, lr, fp, lsl #14
    1db4:	c10b3f00 	tstgt	fp, r0, lsl #30
    1db8:	40000017 	andmi	r0, r0, r7, lsl r0
    1dbc:	00194a0b 	andseq	r4, r9, fp, lsl #20
    1dc0:	5d0b4100 	stfpls	f4, [fp, #-0]
    1dc4:	4200001a 	andmi	r0, r0, #26
    1dc8:	00161a0b 	andseq	r1, r6, fp, lsl #20
    1dcc:	4b0b4300 	blmi	2d29d4 <_bss_end+0x2c9af0>
    1dd0:	4400001e 	strmi	r0, [r0], #-30	; 0xffffffe2
    1dd4:	0018f40b 	andseq	pc, r8, fp, lsl #8
    1dd8:	740b4500 	strvc	r4, [fp], #-1280	; 0xfffffb00
    1ddc:	46000010 			; <UNDEFINED> instruction: 0x46000010
    1de0:	0016f50b 	andseq	pc, r6, fp, lsl #10
    1de4:	280b4700 	stmdacs	fp, {r8, r9, sl, lr}
    1de8:	48000015 	stmdami	r0, {r0, r2, r4}
    1dec:	000e060b 	andeq	r0, lr, fp, lsl #12
    1df0:	1a0b4900 	bne	2d41f8 <_bss_end+0x2cb314>
    1df4:	4a00000f 	bmi	1e38 <CPSR_IRQ_INHIBIT+0x1db8>
    1df8:	0013580b 	andseq	r5, r3, fp, lsl #16
    1dfc:	560b4b00 	strpl	r4, [fp], -r0, lsl #22
    1e00:	4c000016 	stcmi	0, cr0, [r0], {22}
    1e04:	07020300 	streq	r0, [r2, -r0, lsl #6]
    1e08:	000005e3 	andeq	r0, r0, r3, ror #11
    1e0c:	0003e40c 	andeq	lr, r3, ip, lsl #8
    1e10:	0003d900 	andeq	sp, r3, r0, lsl #18
    1e14:	0e000d00 	cdpeq	13, 0, cr0, cr0, cr0, {0}
    1e18:	000003ce 	andeq	r0, r0, lr, asr #7
    1e1c:	03f00405 	mvnseq	r0, #83886080	; 0x5000000
    1e20:	de0e0000 	cdple	0, 0, cr0, cr14, cr0, {0}
    1e24:	03000003 	movweq	r0, #3
    1e28:	058b0801 	streq	r0, [fp, #2049]	; 0x801
    1e2c:	e90e0000 	stmdb	lr, {}	; <UNPREDICTABLE>
    1e30:	0f000003 	svceq	0x00000003
    1e34:	00000fbe 			; <UNDEFINED> instruction: 0x00000fbe
    1e38:	1a014c04 	bne	54e50 <_bss_end+0x4bf6c>
    1e3c:	000003d9 	ldrdeq	r0, [r0], -r9
    1e40:	0013dc0f 	andseq	sp, r3, pc, lsl #24
    1e44:	01820400 	orreq	r0, r2, r0, lsl #8
    1e48:	0003d91a 	andeq	sp, r3, sl, lsl r9
    1e4c:	03e90c00 	mvneq	r0, #0, 24
    1e50:	041a0000 	ldreq	r0, [sl], #-0
    1e54:	000d0000 	andeq	r0, sp, r0
    1e58:	0015c709 	andseq	ip, r5, r9, lsl #14
    1e5c:	0d2d0500 	cfstr32eq	mvfx0, [sp, #-0]
    1e60:	0000040f 	andeq	r0, r0, pc, lsl #8
    1e64:	001cb409 	andseq	fp, ip, r9, lsl #8
    1e68:	1c380500 	cfldr32ne	mvfx0, [r8], #-0
    1e6c:	000001e6 	andeq	r0, r0, r6, ror #3
    1e70:	0012b50a 	andseq	fp, r2, sl, lsl #10
    1e74:	93010700 	movwls	r0, #5888	; 0x1700
    1e78:	05000000 	streq	r0, [r0, #-0]
    1e7c:	04a50e3a 	strteq	r0, [r5], #3642	; 0xe3a
    1e80:	1b0b0000 	blne	2c1e88 <_bss_end+0x2b8fa4>
    1e84:	0000000e 	andeq	r0, r0, lr
    1e88:	0014c70b 	andseq	ip, r4, fp, lsl #14
    1e8c:	c60b0100 	strgt	r0, [fp], -r0, lsl #2
    1e90:	0200001d 	andeq	r0, r0, #29
    1e94:	001d890b 	andseq	r8, sp, fp, lsl #18
    1e98:	1e0b0300 	cdpne	3, 0, cr0, cr11, cr0, {0}
    1e9c:	04000018 	streq	r0, [r0], #-24	; 0xffffffe8
    1ea0:	001b440b 	andseq	r4, fp, fp, lsl #8
    1ea4:	010b0500 	tsteq	fp, r0, lsl #10
    1ea8:	06000010 			; <UNDEFINED> instruction: 0x06000010
    1eac:	000fe30b 	andeq	lr, pc, fp, lsl #6
    1eb0:	fc0b0700 	stc2	7, cr0, [fp], {-0}
    1eb4:	08000011 	stmdaeq	r0, {r0, r4}
    1eb8:	0016da0b 	andseq	sp, r6, fp, lsl #20
    1ebc:	080b0900 	stmdaeq	fp, {r8, fp}
    1ec0:	0a000010 	beq	1f08 <CPSR_IRQ_INHIBIT+0x1e88>
    1ec4:	0016e10b 	andseq	lr, r6, fp, lsl #2
    1ec8:	6d0b0b00 	vstrvs	d0, [fp, #-0]
    1ecc:	0c000010 	stceq	0, cr0, [r0], {16}
    1ed0:	000ffa0b 	andeq	pc, pc, fp, lsl #20
    1ed4:	9b0b0d00 	blls	2c52dc <_bss_end+0x2bc3f8>
    1ed8:	0e00001b 	mcreq	0, 0, r0, cr0, cr11, {0}
    1edc:	0019680b 	andseq	r6, r9, fp, lsl #16
    1ee0:	04000f00 	streq	r0, [r0], #-3840	; 0xfffff100
    1ee4:	00001a93 	muleq	r0, r3, sl
    1ee8:	32013f05 	andcc	r3, r1, #5, 30
    1eec:	09000004 	stmdbeq	r0, {r2}
    1ef0:	00001b27 	andeq	r1, r0, r7, lsr #22
    1ef4:	a50f4105 	strge	r4, [pc, #-261]	; 1df7 <CPSR_IRQ_INHIBIT+0x1d77>
    1ef8:	09000004 	stmdbeq	r0, {r2}
    1efc:	00001baf 	andeq	r1, r0, pc, lsr #23
    1f00:	1d0c4a05 	vstrne	s8, [ip, #-20]	; 0xffffffec
    1f04:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
    1f08:	00000fa2 	andeq	r0, r0, r2, lsr #31
    1f0c:	1d0c4b05 	vstrne	d4, [ip, #-20]	; 0xffffffec
    1f10:	10000000 	andne	r0, r0, r0
    1f14:	00001c88 	andeq	r1, r0, r8, lsl #25
    1f18:	001bc009 	andseq	ip, fp, r9
    1f1c:	144c0500 	strbne	r0, [ip], #-1280	; 0xfffffb00
    1f20:	000004e6 	andeq	r0, r0, r6, ror #9
    1f24:	04d50405 	ldrbeq	r0, [r5], #1029	; 0x405
    1f28:	09110000 	ldmdbeq	r1, {}	; <UNPREDICTABLE>
    1f2c:	00001491 	muleq	r0, r1, r4
    1f30:	f90f4e05 			; <UNDEFINED> instruction: 0xf90f4e05
    1f34:	05000004 	streq	r0, [r0, #-4]
    1f38:	0004ec04 	andeq	lr, r4, r4, lsl #24
    1f3c:	1aa91200 	bne	fea46744 <_bss_end+0xfea3d860>
    1f40:	0b090000 	bleq	241f48 <_bss_end+0x239064>
    1f44:	05000018 	streq	r0, [r0, #-24]	; 0xffffffe8
    1f48:	05100d52 	ldreq	r0, [r0, #-3410]	; 0xfffff2ae
    1f4c:	04050000 	streq	r0, [r5], #-0
    1f50:	000004ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    1f54:	00111913 	andseq	r1, r1, r3, lsl r9
    1f58:	67053400 	strvs	r3, [r5, -r0, lsl #8]
    1f5c:	05411501 	strbeq	r1, [r1, #-1281]	; 0xfffffaff
    1f60:	d0140000 	andsle	r0, r4, r0
    1f64:	05000015 	streq	r0, [r0, #-21]	; 0xffffffeb
    1f68:	de0f0169 	adfleez	f0, f7, #1.0
    1f6c:	00000003 	andeq	r0, r0, r3
    1f70:	0010fd14 	andseq	pc, r0, r4, lsl sp	; <UNPREDICTABLE>
    1f74:	016a0500 	cmneq	sl, r0, lsl #10
    1f78:	00054614 	andeq	r4, r5, r4, lsl r6
    1f7c:	0e000400 	cfcpyseq	mvf0, mvf0
    1f80:	00000516 	andeq	r0, r0, r6, lsl r5
    1f84:	0000b90c 	andeq	fp, r0, ip, lsl #18
    1f88:	00055600 	andeq	r5, r5, r0, lsl #12
    1f8c:	00241500 	eoreq	r1, r4, r0, lsl #10
    1f90:	002d0000 	eoreq	r0, sp, r0
    1f94:	0005410c 	andeq	r4, r5, ip, lsl #2
    1f98:	00056100 	andeq	r6, r5, r0, lsl #2
    1f9c:	0e000d00 	cdpeq	13, 0, cr0, cr0, cr0, {0}
    1fa0:	00000556 	andeq	r0, r0, r6, asr r5
    1fa4:	0014ff0f 	andseq	pc, r4, pc, lsl #30
    1fa8:	016b0500 	cmneq	fp, r0, lsl #10
    1fac:	00056103 	andeq	r6, r5, r3, lsl #2
    1fb0:	17450f00 	strbne	r0, [r5, -r0, lsl #30]
    1fb4:	6e050000 	cdpvs	0, 0, cr0, cr5, cr0, {0}
    1fb8:	001d0c01 	andseq	r0, sp, r1, lsl #24
    1fbc:	e7160000 	ldr	r0, [r6, -r0]
    1fc0:	0700001a 	smladeq	r0, sl, r0, r0
    1fc4:	00009301 	andeq	r9, r0, r1, lsl #6
    1fc8:	01810500 	orreq	r0, r1, r0, lsl #10
    1fcc:	00062a06 	andeq	r2, r6, r6, lsl #20
    1fd0:	0eb00b00 	vmoveq.f64	d0, #0	; 0x40000000  2.0
    1fd4:	0b000000 	bleq	1fdc <CPSR_IRQ_INHIBIT+0x1f5c>
    1fd8:	00000ebc 			; <UNDEFINED> instruction: 0x00000ebc
    1fdc:	0ec80b02 	vdiveq.f64	d16, d8, d2
    1fe0:	0b030000 	bleq	c1fe8 <_bss_end+0xb9104>
    1fe4:	000012e1 	andeq	r1, r0, r1, ror #5
    1fe8:	0ed40b03 	vfnmseq.f64	d16, d4, d3
    1fec:	0b040000 	bleq	101ff4 <_bss_end+0xf9110>
    1ff0:	0000142a 	andeq	r1, r0, sl, lsr #8
    1ff4:	15100b04 	ldrne	r0, [r0, #-2820]	; 0xfffff4fc
    1ff8:	0b050000 	bleq	142000 <_bss_end+0x13911c>
    1ffc:	00001466 	andeq	r1, r0, r6, ror #8
    2000:	0f930b05 	svceq	0x00930b05
    2004:	0b050000 	bleq	14200c <_bss_end+0x139128>
    2008:	00000ee0 	andeq	r0, r0, r0, ror #29
    200c:	168e0b06 	strne	r0, [lr], r6, lsl #22
    2010:	0b060000 	bleq	182018 <_bss_end+0x179134>
    2014:	000010ef 	andeq	r1, r0, pc, ror #1
    2018:	169b0b06 	ldrne	r0, [fp], r6, lsl #22
    201c:	0b060000 	bleq	182024 <_bss_end+0x179140>
    2020:	00001b67 	andeq	r1, r0, r7, ror #22
    2024:	16a80b06 	strtne	r0, [r8], r6, lsl #22
    2028:	0b060000 	bleq	182030 <_bss_end+0x17914c>
    202c:	000016e8 	andeq	r1, r0, r8, ror #13
    2030:	0eec0b06 	vfmaeq.f64	d16, d12, d6
    2034:	0b070000 	bleq	1c203c <_bss_end+0x1b9158>
    2038:	000017ee 	andeq	r1, r0, lr, ror #15
    203c:	183b0b07 	ldmdane	fp!, {r0, r1, r2, r8, r9, fp}
    2040:	0b070000 	bleq	1c2048 <_bss_end+0x1b9164>
    2044:	00001ba2 	andeq	r1, r0, r2, lsr #23
    2048:	10c20b07 	sbcne	r0, r2, r7, lsl #22
    204c:	0b070000 	bleq	1c2054 <_bss_end+0x1b9170>
    2050:	00001921 	andeq	r1, r0, r1, lsr #18
    2054:	0e650b08 	vmuleq.f64	d16, d5, d8
    2058:	0b080000 	bleq	202060 <_bss_end+0x1f917c>
    205c:	00001b75 	andeq	r1, r0, r5, ror fp
    2060:	193d0b08 	ldmdbne	sp!, {r3, r8, r9, fp}
    2064:	00080000 	andeq	r0, r8, r0
    2068:	001ddb0f 	andseq	sp, sp, pc, lsl #22
    206c:	019f0500 	orrseq	r0, pc, r0, lsl #10
    2070:	0005801f 	andeq	r8, r5, pc, lsl r0
    2074:	196f0f00 	stmdbne	pc!, {r8, r9, sl, fp}^	; <UNPREDICTABLE>
    2078:	a2050000 	andge	r0, r5, #0
    207c:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2080:	1d0f0000 	stcne	0, cr0, [pc, #-0]	; 2088 <CPSR_IRQ_INHIBIT+0x2008>
    2084:	05000015 	streq	r0, [r0, #-21]	; 0xffffffeb
    2088:	1d0c01a5 	stfnes	f0, [ip, #-660]	; 0xfffffd6c
    208c:	0f000000 	svceq	0x00000000
    2090:	00001ea7 	andeq	r1, r0, r7, lsr #29
    2094:	0c01a805 	stceq	8, cr10, [r1], {5}
    2098:	0000001d 	andeq	r0, r0, sp, lsl r0
    209c:	000fb20f 	andeq	fp, pc, pc, lsl #4
    20a0:	01ab0500 			; <UNDEFINED> instruction: 0x01ab0500
    20a4:	00001d0c 	andeq	r1, r0, ip, lsl #26
    20a8:	19790f00 	ldmdbne	r9!, {r8, r9, sl, fp}^
    20ac:	ae050000 	cdpge	0, 0, cr0, cr5, cr0, {0}
    20b0:	001d0c01 	andseq	r0, sp, r1, lsl #24
    20b4:	250f0000 	strcs	r0, [pc, #-0]	; 20bc <CPSR_IRQ_INHIBIT+0x203c>
    20b8:	05000018 	streq	r0, [r0, #-24]	; 0xffffffe8
    20bc:	1d0c01b1 	stfnes	f0, [ip, #-708]	; 0xfffffd3c
    20c0:	0f000000 	svceq	0x00000000
    20c4:	00001830 	andeq	r1, r0, r0, lsr r8
    20c8:	0c01b405 	cfstrseq	mvf11, [r1], {5}
    20cc:	0000001d 	andeq	r0, r0, sp, lsl r0
    20d0:	0019830f 	andseq	r8, r9, pc, lsl #6
    20d4:	01b70500 			; <UNDEFINED> instruction: 0x01b70500
    20d8:	00001d0c 	andeq	r1, r0, ip, lsl #26
    20dc:	166a0f00 	strbtne	r0, [sl], -r0, lsl #30
    20e0:	ba050000 	blt	1420e8 <_bss_end+0x139204>
    20e4:	001d0c01 	andseq	r0, sp, r1, lsl #24
    20e8:	060f0000 	streq	r0, [pc], -r0
    20ec:	0500001e 	streq	r0, [r0, #-30]	; 0xffffffe2
    20f0:	1d0c01bd 	stfnes	f0, [ip, #-756]	; 0xfffffd0c
    20f4:	0f000000 	svceq	0x00000000
    20f8:	0000198d 	andeq	r1, r0, sp, lsl #19
    20fc:	0c01c005 	stceq	0, cr12, [r1], {5}
    2100:	0000001d 	andeq	r0, r0, sp, lsl r0
    2104:	001eca0f 	andseq	ip, lr, pc, lsl #20
    2108:	01c30500 	biceq	r0, r3, r0, lsl #10
    210c:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2110:	1d900f00 	ldcne	15, cr0, [r0]
    2114:	c6050000 	strgt	r0, [r5], -r0
    2118:	001d0c01 	andseq	r0, sp, r1, lsl #24
    211c:	9c0f0000 	stcls	0, cr0, [pc], {-0}
    2120:	0500001d 	streq	r0, [r0, #-29]	; 0xffffffe3
    2124:	1d0c01c9 	stfnes	f0, [ip, #-804]	; 0xfffffcdc
    2128:	0f000000 	svceq	0x00000000
    212c:	00001da8 	andeq	r1, r0, r8, lsr #27
    2130:	0c01cc05 	stceq	12, cr12, [r1], {5}
    2134:	0000001d 	andeq	r0, r0, sp, lsl r0
    2138:	001dcd0f 	andseq	ip, sp, pc, lsl #26
    213c:	01d00500 	bicseq	r0, r0, r0, lsl #10
    2140:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2144:	1ebd0f00 	cdpne	15, 11, cr0, cr13, cr0, {0}
    2148:	d3050000 	movwle	r0, #20480	; 0x5000
    214c:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2150:	0f0f0000 	svceq	0x000f0000
    2154:	05000010 	streq	r0, [r0, #-16]
    2158:	1d0c01d6 	stfnes	f0, [ip, #-856]	; 0xfffffca8
    215c:	0f000000 	svceq	0x00000000
    2160:	00000df6 	strdeq	r0, [r0], -r6
    2164:	0c01d905 			; <UNDEFINED> instruction: 0x0c01d905
    2168:	0000001d 	andeq	r0, r0, sp, lsl r0
    216c:	0013010f 	andseq	r0, r3, pc, lsl #2
    2170:	01dc0500 	bicseq	r0, ip, r0, lsl #10
    2174:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2178:	0fea0f00 	svceq	0x00ea0f00
    217c:	df050000 	svcle	0x00050000
    2180:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2184:	a30f0000 	movwge	r0, #61440	; 0xf000
    2188:	05000019 	streq	r0, [r0, #-25]	; 0xffffffe7
    218c:	1d0c01e2 	stfnes	f0, [ip, #-904]	; 0xfffffc78
    2190:	0f000000 	svceq	0x00000000
    2194:	00001546 	andeq	r1, r0, r6, asr #10
    2198:	0c01e505 	cfstr32eq	mvfx14, [r1], {5}
    219c:	0000001d 	andeq	r0, r0, sp, lsl r0
    21a0:	00179e0f 	andseq	r9, r7, pc, lsl #28
    21a4:	01e80500 	mvneq	r0, r0, lsl #10
    21a8:	00001d0c 	andeq	r1, r0, ip, lsl #26
    21ac:	1cbd0f00 	ldcne	15, cr0, [sp]
    21b0:	ef050000 	svc	0x00050000
    21b4:	001d0c01 	andseq	r0, sp, r1, lsl #24
    21b8:	750f0000 	strvc	r0, [pc, #-0]	; 21c0 <CPSR_IRQ_INHIBIT+0x2140>
    21bc:	0500001e 	streq	r0, [r0, #-30]	; 0xffffffe2
    21c0:	1d0c01f2 	stfnes	f0, [ip, #-968]	; 0xfffffc38
    21c4:	0f000000 	svceq	0x00000000
    21c8:	00001e85 	andeq	r1, r0, r5, lsl #29
    21cc:	0c01f505 	cfstr32eq	mvfx15, [r1], {5}
    21d0:	0000001d 	andeq	r0, r0, sp, lsl r0
    21d4:	0011060f 	andseq	r0, r1, pc, lsl #12
    21d8:	01f80500 	mvnseq	r0, r0, lsl #10
    21dc:	00001d0c 	andeq	r1, r0, ip, lsl #26
    21e0:	1d040f00 	stcne	15, cr0, [r4, #-0]
    21e4:	fb050000 	blx	1421ee <_bss_end+0x13930a>
    21e8:	001d0c01 	andseq	r0, sp, r1, lsl #24
    21ec:	090f0000 	stmdbeq	pc, {}	; <UNPREDICTABLE>
    21f0:	05000019 	streq	r0, [r0, #-25]	; 0xffffffe7
    21f4:	1d0c01fe 	stfnes	f0, [ip, #-1016]	; 0xfffffc08
    21f8:	0f000000 	svceq	0x00000000
    21fc:	0000137a 	andeq	r1, r0, sl, ror r3
    2200:	0c020205 	sfmeq	f0, 4, [r2], {5}
    2204:	0000001d 	andeq	r0, r0, sp, lsl r0
    2208:	001af90f 	andseq	pc, sl, pc, lsl #18
    220c:	020a0500 	andeq	r0, sl, #0, 10
    2210:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2214:	126d0f00 	rsbne	r0, sp, #0, 30
    2218:	0d050000 	stceq	0, cr0, [r5, #-0]
    221c:	001d0c02 	andseq	r0, sp, r2, lsl #24
    2220:	1d0c0000 	stcne	0, cr0, [ip, #-0]
    2224:	ef000000 	svc	0x00000000
    2228:	0d000007 	stceq	0, cr0, [r0, #-28]	; 0xffffffe4
    222c:	14460f00 	strbne	r0, [r6], #-3840	; 0xfffff100
    2230:	fb050000 	blx	14223a <_bss_end+0x139356>
    2234:	07e40c03 	strbeq	r0, [r4, r3, lsl #24]!
    2238:	e60c0000 	str	r0, [ip], -r0
    223c:	0c000004 	stceq	0, cr0, [r0], {4}
    2240:	15000008 	strne	r0, [r0, #-8]
    2244:	00000024 	andeq	r0, r0, r4, lsr #32
    2248:	c60f000d 	strgt	r0, [pc], -sp
    224c:	05000019 	streq	r0, [r0, #-25]	; 0xffffffe7
    2250:	fc140584 	ldc2	5, cr0, [r4], {132}	; 0x84
    2254:	16000007 	strne	r0, [r0], -r7
    2258:	00001508 	andeq	r1, r0, r8, lsl #10
    225c:	00930107 	addseq	r0, r3, r7, lsl #2
    2260:	8b050000 	blhi	142268 <_bss_end+0x139384>
    2264:	08570605 	ldmdaeq	r7, {r0, r2, r9, sl}^
    2268:	c30b0000 	movwgt	r0, #45056	; 0xb000
    226c:	00000012 	andeq	r0, r0, r2, lsl r0
    2270:	0017130b 	andseq	r1, r7, fp, lsl #6
    2274:	9b0b0100 	blls	2c267c <_bss_end+0x2b9798>
    2278:	0200000e 	andeq	r0, r0, #14
    227c:	001e370b 	andseq	r3, lr, fp, lsl #14
    2280:	400b0300 	andmi	r0, fp, r0, lsl #6
    2284:	0400001a 	streq	r0, [r0], #-26	; 0xffffffe6
    2288:	001a330b 	andseq	r3, sl, fp, lsl #6
    228c:	720b0500 	andvc	r0, fp, #0, 10
    2290:	0600000f 	streq	r0, [r0], -pc
    2294:	1e270f00 	cdpne	15, 2, cr0, cr7, cr0, {0}
    2298:	98050000 	stmdals	r5, {}	; <UNPREDICTABLE>
    229c:	08191505 	ldmdaeq	r9, {r0, r2, r8, sl, ip}
    22a0:	290f0000 	stmdbcs	pc, {}	; <UNPREDICTABLE>
    22a4:	0500001d 	streq	r0, [r0, #-29]	; 0xffffffe3
    22a8:	24110799 	ldrcs	r0, [r1], #-1945	; 0xfffff867
    22ac:	0f000000 	svceq	0x00000000
    22b0:	000019b3 			; <UNDEFINED> instruction: 0x000019b3
    22b4:	0c07ae05 	stceq	14, cr10, [r7], {5}
    22b8:	0000001d 	andeq	r0, r0, sp, lsl r0
    22bc:	001c9c04 	andseq	r9, ip, r4, lsl #24
    22c0:	167b0600 	ldrbtne	r0, [fp], -r0, lsl #12
    22c4:	00000093 	muleq	r0, r3, r0
    22c8:	00087e0e 	andeq	r7, r8, lr, lsl #28
    22cc:	05020300 	streq	r0, [r2, #-768]	; 0xfffffd00
    22d0:	000002a3 	andeq	r0, r0, r3, lsr #5
    22d4:	56070803 	strpl	r0, [r7], -r3, lsl #16
    22d8:	03000012 	movweq	r0, #18
    22dc:	102a0404 	eorne	r0, sl, r4, lsl #8
    22e0:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    22e4:	00102203 	andseq	r2, r0, r3, lsl #4
    22e8:	04080300 	streq	r0, [r8], #-768	; 0xfffffd00
    22ec:	0000199c 	muleq	r0, ip, r9
    22f0:	4e031003 	cdpmi	0, 0, cr1, cr3, cr3, {0}
    22f4:	0c00001a 	stceq	0, cr0, [r0], {26}
    22f8:	0000088a 	andeq	r0, r0, sl, lsl #17
    22fc:	000008c9 	andeq	r0, r0, r9, asr #17
    2300:	00002415 	andeq	r2, r0, r5, lsl r4
    2304:	0e00ff00 	cdpeq	15, 0, cr15, cr0, cr0, {0}
    2308:	000008b9 			; <UNDEFINED> instruction: 0x000008b9
    230c:	0018480f 	andseq	r4, r8, pc, lsl #16
    2310:	01fc0600 	mvnseq	r0, r0, lsl #12
    2314:	0008c916 	andeq	ip, r8, r6, lsl r9
    2318:	0fd90f00 	svceq	0x00d90f00
    231c:	02060000 	andeq	r0, r6, #0
    2320:	08c91602 	stmiaeq	r9, {r1, r9, sl, ip}^
    2324:	cf040000 	svcgt	0x00040000
    2328:	0700001c 	smladeq	r0, ip, r0, r0
    232c:	04f9102a 	ldrbteq	r1, [r9], #42	; 0x2a
    2330:	e80c0000 	stmda	ip, {}	; <UNPREDICTABLE>
    2334:	ff000008 			; <UNDEFINED> instruction: 0xff000008
    2338:	0d000008 	stceq	0, cr0, [r0, #-32]	; 0xffffffe0
    233c:	0d5a0900 	vldreq.16	s1, [sl, #-0]	; <UNPREDICTABLE>
    2340:	2f070000 	svccs	0x00070000
    2344:	0008f411 	andeq	pc, r8, r1, lsl r4	; <UNPREDICTABLE>
    2348:	0d8c0900 	vstreq.16	s0, [ip]	; <UNPREDICTABLE>
    234c:	30070000 	andcc	r0, r7, r0
    2350:	0008f411 	andeq	pc, r8, r1, lsl r4	; <UNPREDICTABLE>
    2354:	08ff1700 	ldmeq	pc!, {r8, r9, sl, ip}^	; <UNPREDICTABLE>
    2358:	33080000 	movwcc	r0, #32768	; 0x8000
    235c:	03050a09 	movweq	r0, #23049	; 0x5a09
    2360:	00008ec0 	andeq	r8, r0, r0, asr #29
    2364:	00090b17 	andeq	r0, r9, r7, lsl fp
    2368:	09340800 	ldmdbeq	r4!, {fp}
    236c:	c803050a 	stmdagt	r3, {r1, r3, r8, sl}
    2370:	0000008e 	andeq	r0, r0, lr, lsl #1

Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
   0:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
   4:	030b130e 	movweq	r1, #45838	; 0xb30e
   8:	110e1b0e 	tstne	lr, lr, lsl #22
   c:	10061201 	andne	r1, r6, r1, lsl #4
  10:	02000017 	andeq	r0, r0, #23
  14:	193f002e 	ldmdbne	pc!, {r1, r2, r3, r5}	; <UNPREDICTABLE>
  18:	0b3a0e03 	bleq	e8382c <_bss_end+0xe7a948>
  1c:	0b390b3b 	bleq	e42d10 <_bss_end+0xe39e2c>
  20:	06120111 			; <UNDEFINED> instruction: 0x06120111
  24:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
  28:	03000019 	movweq	r0, #25
  2c:	0e030139 	mcreq	1, 0, r0, cr3, cr9, {1}
  30:	0b3b0b3a 	bleq	ec2d20 <_bss_end+0xeb9e3c>
  34:	00001301 	andeq	r1, r0, r1, lsl #6
  38:	3f012e04 	svccc	0x00012e04
  3c:	3a0e0319 	bcc	380ca8 <_bss_end+0x377dc4>
  40:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
  44:	01193c0b 	tsteq	r9, fp, lsl #24
  48:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
  4c:	13490005 	movtne	r0, #36869	; 0x9005
  50:	16060000 	strne	r0, [r6], -r0
  54:	3a0e0300 	bcc	380c5c <_bss_end+0x377d78>
  58:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
  5c:	0013490b 	andseq	r4, r3, fp, lsl #18
  60:	012e0700 			; <UNDEFINED> instruction: 0x012e0700
  64:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
  68:	0b3b0b3a 	bleq	ec2d58 <_bss_end+0xeb9e74>
  6c:	13490b39 	movtne	r0, #39737	; 0x9b39
  70:	0000193c 	andeq	r1, r0, ip, lsr r9
  74:	0b000f08 	bleq	3c9c <CPSR_IRQ_INHIBIT+0x3c1c>
  78:	0013490b 	andseq	r4, r3, fp, lsl #18
  7c:	00240900 	eoreq	r0, r4, r0, lsl #18
  80:	0b3e0b0b 	bleq	f82cb4 <_bss_end+0xf79dd0>
  84:	00000e03 	andeq	r0, r0, r3, lsl #28
  88:	47012e0a 	strmi	r2, [r1, -sl, lsl #28]
  8c:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
  90:	97184006 	ldrls	r4, [r8, -r6]
  94:	13011942 	movwne	r1, #6466	; 0x1942
  98:	050b0000 	streq	r0, [fp, #-0]
  9c:	02134900 	andseq	r4, r3, #0, 18
  a0:	0c000018 	stceq	0, cr0, [r0], {24}
  a4:	08030005 	stmdaeq	r3, {r0, r2}
  a8:	0b3b0b3a 	bleq	ec2d98 <_bss_end+0xeb9eb4>
  ac:	13490b39 	movtne	r0, #39737	; 0x9b39
  b0:	00001802 	andeq	r1, r0, r2, lsl #16
  b4:	0b00240d 	bleq	90f0 <_bss_end+0x20c>
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
  e4:	0b0b0024 	bleq	2c017c <_bss_end+0x2b7298>
  e8:	0e030b3e 	vmoveq.16	d3[0], r0
  ec:	24030000 	strcs	r0, [r3], #-0
  f0:	3e0b0b00 	vmlacc.f64	d0, d11, d0
  f4:	0008030b 	andeq	r0, r8, fp, lsl #6
  f8:	00160400 	andseq	r0, r6, r0, lsl #8
  fc:	0b3a0e03 	bleq	e83910 <_bss_end+0xe7aa2c>
 100:	0b390b3b 	bleq	e42df4 <_bss_end+0xe39f10>
 104:	00001349 	andeq	r1, r0, r9, asr #6
 108:	49002605 	stmdbmi	r0, {r0, r2, r9, sl, sp}
 10c:	06000013 			; <UNDEFINED> instruction: 0x06000013
 110:	08030139 	stmdaeq	r3, {r0, r3, r4, r5, r8}
 114:	0b3b0b3a 	bleq	ec2e04 <_bss_end+0xeb9f20>
 118:	13010b39 	movwne	r0, #6969	; 0x1b39
 11c:	34070000 	strcc	r0, [r7], #-0
 120:	3a0e0300 	bcc	380d28 <_bss_end+0x377e44>
 124:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 128:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
 12c:	6c061c19 	stcvs	12, cr1, [r6], {25}
 130:	08000019 	stmdaeq	r0, {r0, r3, r4}
 134:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 138:	0b3b0b3a 	bleq	ec2e28 <_bss_end+0xeb9f44>
 13c:	13490b39 	movtne	r0, #39737	; 0x9b39
 140:	0b1c193c 	bleq	706638 <_bss_end+0x6fd754>
 144:	0000196c 	andeq	r1, r0, ip, ror #18
 148:	03010409 	movweq	r0, #5129	; 0x1409
 14c:	3e196d0e 	cdpcc	13, 1, cr6, cr9, cr14, {0}
 150:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
 154:	3b0b3a13 	blcc	2ce9a8 <_bss_end+0x2c5ac4>
 158:	010b390b 	tsteq	fp, fp, lsl #18
 15c:	0a000013 	beq	1b0 <CPSR_IRQ_INHIBIT+0x130>
 160:	0e030028 	cdpeq	0, 0, cr0, cr3, cr8, {1}
 164:	00000b1c 	andeq	r0, r0, ip, lsl fp
 168:	4700340b 	strmi	r3, [r0, -fp, lsl #8]
 16c:	0c000013 	stceq	0, cr0, [r0], {19}
 170:	08030028 	stmdaeq	r3, {r3, r5}
 174:	00000b1c 	andeq	r0, r0, ip, lsl fp
 178:	0301020d 	movweq	r0, #4621	; 0x120d
 17c:	3a0b0b0e 	bcc	2c2dbc <_bss_end+0x2b9ed8>
 180:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 184:	0013010b 	andseq	r0, r3, fp, lsl #2
 188:	000d0e00 	andeq	r0, sp, r0, lsl #28
 18c:	0b3a0e03 	bleq	e839a0 <_bss_end+0xe7aabc>
 190:	0b390b3b 	bleq	e42e84 <_bss_end+0xe39fa0>
 194:	0b381349 	bleq	e04ec0 <_bss_end+0xdfbfdc>
 198:	2e0f0000 	cdpcs	0, 0, cr0, cr15, cr0, {0}
 19c:	03193f01 	tsteq	r9, #1, 30
 1a0:	3b0b3a0e 	blcc	2ce9e0 <_bss_end+0x2c5afc>
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
 1cc:	0b3b0b3a 	bleq	ec2ebc <_bss_end+0xeb9fd8>
 1d0:	0e6e0b39 	vmoveq.8	d14[5], r0
 1d4:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 1d8:	13011364 	movwne	r1, #4964	; 0x1364
 1dc:	2e130000 	cdpcs	0, 1, cr0, cr3, cr0, {0}
 1e0:	03193f01 	tsteq	r9, #1, 30
 1e4:	3b0b3a0e 	blcc	2cea24 <_bss_end+0x2c5b40>
 1e8:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 1ec:	3213490e 	andscc	r4, r3, #229376	; 0x38000
 1f0:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 1f4:	14000013 	strne	r0, [r0], #-19	; 0xffffffed
 1f8:	0b0b000f 	bleq	2c023c <_bss_end+0x2b7358>
 1fc:	00001349 	andeq	r1, r0, r9, asr #6
 200:	0b001015 	bleq	425c <CPSR_IRQ_INHIBIT+0x41dc>
 204:	0013490b 	andseq	r4, r3, fp, lsl #18
 208:	00341600 	eorseq	r1, r4, r0, lsl #12
 20c:	0b3a0e03 	bleq	e83a20 <_bss_end+0xe7ab3c>
 210:	0b390b3b 	bleq	e42f04 <_bss_end+0xe3a020>
 214:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
 218:	0000193c 	andeq	r1, r0, ip, lsr r9
 21c:	47003417 	smladmi	r0, r7, r4, r3
 220:	3b0b3a13 	blcc	2cea74 <_bss_end+0x2c5b90>
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
 254:	0b3a0e03 	bleq	e83a68 <_bss_end+0xe7ab84>
 258:	0b390b3b 	bleq	e42f4c <_bss_end+0xe3a068>
 25c:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 260:	2e1b0000 	cdpcs	0, 1, cr0, cr11, cr0, {0}
 264:	3a134701 	bcc	4d1e70 <_bss_end+0x4c8f8c>
 268:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 26c:	1113640b 	tstne	r3, fp, lsl #8
 270:	40061201 	andmi	r1, r6, r1, lsl #4
 274:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
 278:	00001301 	andeq	r1, r0, r1, lsl #6
 27c:	0300051c 	movweq	r0, #1308	; 0x51c
 280:	3413490e 	ldrcc	r4, [r3], #-2318	; 0xfffff6f2
 284:	00180219 	andseq	r0, r8, r9, lsl r2
 288:	00051d00 	andeq	r1, r5, r0, lsl #26
 28c:	0b3a0803 	bleq	e822a0 <_bss_end+0xe793bc>
 290:	0b390b3b 	bleq	e42f84 <_bss_end+0xe3a0a0>
 294:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 298:	341e0000 	ldrcc	r0, [lr], #-0
 29c:	3a080300 	bcc	200ea4 <_bss_end+0x1f7fc0>
 2a0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 2a4:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 2a8:	1f000018 	svcne	0x00000018
 2ac:	1347012e 	movtne	r0, #28974	; 0x712e
 2b0:	0b3b0b3a 	bleq	ec2fa0 <_bss_end+0xeba0bc>
 2b4:	13640b39 	cmnne	r4, #58368	; 0xe400
 2b8:	06120111 			; <UNDEFINED> instruction: 0x06120111
 2bc:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 2c0:	00130119 	andseq	r0, r3, r9, lsl r1
 2c4:	012e2000 			; <UNDEFINED> instruction: 0x012e2000
 2c8:	0b3a1347 	bleq	e84fec <_bss_end+0xe7c108>
 2cc:	0b390b3b 	bleq	e42fc0 <_bss_end+0xe3a0dc>
 2d0:	0b201364 	bleq	805068 <_bss_end+0x7fc184>
 2d4:	00001301 	andeq	r1, r0, r1, lsl #6
 2d8:	03000521 	movweq	r0, #1313	; 0x521
 2dc:	3413490e 	ldrcc	r4, [r3], #-2318	; 0xfffff6f2
 2e0:	22000019 	andcs	r0, r0, #25
 2e4:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
 2e8:	0b3b0b3a 	bleq	ec2fd8 <_bss_end+0xeba0f4>
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
 324:	0b0b0024 	bleq	2c03bc <_bss_end+0x2b74d8>
 328:	0e030b3e 	vmoveq.16	d3[0], r0
 32c:	24030000 	strcs	r0, [r3], #-0
 330:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 334:	0008030b 	andeq	r0, r8, fp, lsl #6
 338:	00160400 	andseq	r0, r6, r0, lsl #8
 33c:	0b3a0e03 	bleq	e83b50 <_bss_end+0xe7ac6c>
 340:	0b390b3b 	bleq	e43034 <_bss_end+0xe3a150>
 344:	00001349 	andeq	r1, r0, r9, asr #6
 348:	49002605 	stmdbmi	r0, {r0, r2, r9, sl, sp}
 34c:	06000013 			; <UNDEFINED> instruction: 0x06000013
 350:	13490035 	movtne	r0, #36917	; 0x9035
 354:	39070000 	stmdbcc	r7, {}	; <UNPREDICTABLE>
 358:	3a080301 	bcc	200f64 <_bss_end+0x1f8080>
 35c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 360:	0013010b 	andseq	r0, r3, fp, lsl #2
 364:	00340800 	eorseq	r0, r4, r0, lsl #16
 368:	0b3a0e03 	bleq	e83b7c <_bss_end+0xe7ac98>
 36c:	0b390b3b 	bleq	e43060 <_bss_end+0xe3a17c>
 370:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 374:	196c061c 	stmdbne	ip!, {r2, r3, r4, r9, sl}^
 378:	34090000 	strcc	r0, [r9], #-0
 37c:	3a0e0300 	bcc	380f84 <_bss_end+0x3780a0>
 380:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 384:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
 388:	6c0b1c19 	stcvs	12, cr1, [fp], {25}
 38c:	0a000019 	beq	3f8 <CPSR_IRQ_INHIBIT+0x378>
 390:	0e030104 	adfeqs	f0, f3, f4
 394:	0b3e196d 	bleq	f86950 <_bss_end+0xf7da6c>
 398:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 39c:	0b3b0b3a 	bleq	ec308c <_bss_end+0xeba1a8>
 3a0:	13010b39 	movwne	r0, #6969	; 0x1b39
 3a4:	280b0000 	stmdacs	fp, {}	; <UNPREDICTABLE>
 3a8:	1c0e0300 	stcne	3, cr0, [lr], {-0}
 3ac:	0c00000b 	stceq	0, cr0, [r0], {11}
 3b0:	08030028 	stmdaeq	r3, {r3, r5}
 3b4:	00000b1c 	andeq	r0, r0, ip, lsl fp
 3b8:	4700340d 	strmi	r3, [r0, -sp, lsl #8]
 3bc:	0e000013 	mcreq	0, 0, r0, cr0, cr3, {0}
 3c0:	0e030102 	adfeqs	f0, f3, f2
 3c4:	0b3a0b0b 	bleq	e82ff8 <_bss_end+0xe7a114>
 3c8:	0b390b3b 	bleq	e430bc <_bss_end+0xe3a1d8>
 3cc:	00001301 	andeq	r1, r0, r1, lsl #6
 3d0:	03000d0f 	movweq	r0, #3343	; 0xd0f
 3d4:	3b0b3a0e 	blcc	2cec14 <_bss_end+0x2c5d30>
 3d8:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 3dc:	000b3813 	andeq	r3, fp, r3, lsl r8
 3e0:	012e1000 			; <UNDEFINED> instruction: 0x012e1000
 3e4:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 3e8:	0b3b0b3a 	bleq	ec30d8 <_bss_end+0xeba1f4>
 3ec:	0e6e0b39 	vmoveq.8	d14[5], r0
 3f0:	0b321349 	bleq	c8511c <_bss_end+0xc7c238>
 3f4:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 3f8:	00001301 	andeq	r1, r0, r1, lsl #6
 3fc:	49000511 	stmdbmi	r0, {r0, r4, r8, sl}
 400:	00193413 	andseq	r3, r9, r3, lsl r4
 404:	00051200 	andeq	r1, r5, r0, lsl #4
 408:	00001349 	andeq	r1, r0, r9, asr #6
 40c:	3f012e13 	svccc	0x00012e13
 410:	3a0e0319 	bcc	38107c <_bss_end+0x378198>
 414:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 418:	320e6e0b 	andcc	r6, lr, #11, 28	; 0xb0
 41c:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 420:	00130113 	andseq	r0, r3, r3, lsl r1
 424:	012e1400 			; <UNDEFINED> instruction: 0x012e1400
 428:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 42c:	0b3b0b3a 	bleq	ec311c <_bss_end+0xeba238>
 430:	0e6e0b39 	vmoveq.8	d14[5], r0
 434:	0b321349 	bleq	c85160 <_bss_end+0xc7c27c>
 438:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 43c:	0f150000 	svceq	0x00150000
 440:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 444:	16000013 			; <UNDEFINED> instruction: 0x16000013
 448:	0b0b0010 	bleq	2c0490 <_bss_end+0x2b75ac>
 44c:	00001349 	andeq	r1, r0, r9, asr #6
 450:	03003417 	movweq	r3, #1047	; 0x417
 454:	3b0b3a0e 	blcc	2cec94 <_bss_end+0x2c5db0>
 458:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 45c:	3c193f13 	ldccc	15, cr3, [r9], {19}
 460:	18000019 	stmdane	r0, {r0, r3, r4}
 464:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 468:	0b3a0e03 	bleq	e83c7c <_bss_end+0xe7ad98>
 46c:	0b390b3b 	bleq	e43160 <_bss_end+0xe3a27c>
 470:	0b320e6e 	bleq	c83e30 <_bss_end+0xc7af4c>
 474:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 478:	34190000 	ldrcc	r0, [r9], #-0
 47c:	3a134700 	bcc	4d2084 <_bss_end+0x4c91a0>
 480:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 484:	0018020b 	andseq	r0, r8, fp, lsl #4
 488:	002e1a00 	eoreq	r1, lr, r0, lsl #20
 48c:	19340e03 	ldmdbne	r4!, {r0, r1, r9, sl, fp}
 490:	06120111 			; <UNDEFINED> instruction: 0x06120111
 494:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 498:	1b000019 	blne	504 <CPSR_IRQ_INHIBIT+0x484>
 49c:	0e03012e 	adfeqsp	f0, f3, #0.5
 4a0:	01111934 	tsteq	r1, r4, lsr r9
 4a4:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 4a8:	01194296 			; <UNDEFINED> instruction: 0x01194296
 4ac:	1c000013 	stcne	0, cr0, [r0], {19}
 4b0:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
 4b4:	0b3b0b3a 	bleq	ec31a4 <_bss_end+0xeba2c0>
 4b8:	13490b39 	movtne	r0, #39737	; 0x9b39
 4bc:	00001802 	andeq	r1, r0, r2, lsl #16
 4c0:	47012e1d 	smladmi	r1, sp, lr, r2
 4c4:	3b0b3a13 	blcc	2ced18 <_bss_end+0x2c5e34>
 4c8:	640b390b 	strvs	r3, [fp], #-2315	; 0xfffff6f5
 4cc:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 4d0:	96184006 	ldrls	r4, [r8], -r6
 4d4:	13011942 	movwne	r1, #6466	; 0x1942
 4d8:	051e0000 	ldreq	r0, [lr, #-0]
 4dc:	490e0300 	stmdbmi	lr, {r8, r9}
 4e0:	02193413 	andseq	r3, r9, #318767104	; 0x13000000
 4e4:	1f000018 	svcne	0x00000018
 4e8:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 4ec:	0b3b0b3a 	bleq	ec31dc <_bss_end+0xeba2f8>
 4f0:	13490b39 	movtne	r0, #39737	; 0x9b39
 4f4:	00001802 	andeq	r1, r0, r2, lsl #16
 4f8:	47012e20 	strmi	r2, [r1, -r0, lsr #28]
 4fc:	3b0b3a13 	blcc	2ced50 <_bss_end+0x2c5e6c>
 500:	640b390b 	strvs	r3, [fp], #-2315	; 0xfffff6f5
 504:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 508:	97184006 	ldrls	r4, [r8, -r6]
 50c:	13011942 	movwne	r1, #6466	; 0x1942
 510:	05210000 	streq	r0, [r1, #-0]!
 514:	3a080300 	bcc	20111c <_bss_end+0x1f8238>
 518:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 51c:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 520:	22000018 	andcs	r0, r0, #24
 524:	1347012e 	movtne	r0, #28974	; 0x712e
 528:	0b3b0b3a 	bleq	ec3218 <_bss_end+0xeba334>
 52c:	13640b39 	cmnne	r4, #58368	; 0xe400
 530:	13010b20 	movwne	r0, #6944	; 0x1b20
 534:	05230000 	streq	r0, [r3, #-0]!
 538:	490e0300 	stmdbmi	lr, {r8, r9}
 53c:	00193413 	andseq	r3, r9, r3, lsl r4
 540:	00052400 	andeq	r2, r5, r0, lsl #8
 544:	0b3a0e03 	bleq	e83d58 <_bss_end+0xe7ae74>
 548:	0b390b3b 	bleq	e4323c <_bss_end+0xe3a358>
 54c:	00001349 	andeq	r1, r0, r9, asr #6
 550:	31012e25 	tstcc	r1, r5, lsr #28
 554:	640e6e13 	strvs	r6, [lr], #-3603	; 0xfffff1ed
 558:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 55c:	97184006 	ldrls	r4, [r8, -r6]
 560:	13011942 	movwne	r1, #6466	; 0x1942
 564:	05260000 	streq	r0, [r6, #-0]!
 568:	02133100 	andseq	r3, r3, #0, 2
 56c:	27000018 	smladcs	r0, r8, r0, r0
 570:	193f002e 	ldmdbne	pc!, {r1, r2, r3, r5}	; <UNPREDICTABLE>
 574:	0b3a0e03 	bleq	e83d88 <_bss_end+0xe7aea4>
 578:	0b390b3b 	bleq	e4326c <_bss_end+0xe3a388>
 57c:	06120111 			; <UNDEFINED> instruction: 0x06120111
 580:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 584:	28000019 	stmdacs	r0, {r0, r3, r4}
 588:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 58c:	0b3a0e03 	bleq	e83da0 <_bss_end+0xe7aebc>
 590:	0b390b3b 	bleq	e43284 <_bss_end+0xe3a3a0>
 594:	06120111 			; <UNDEFINED> instruction: 0x06120111
 598:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 59c:	00130119 	andseq	r0, r3, r9, lsl r1
 5a0:	11010000 	mrsne	r0, (UNDEF: 1)
 5a4:	130e2501 	movwne	r2, #58625	; 0xe501
 5a8:	1b0e030b 	blne	3811dc <_bss_end+0x3782f8>
 5ac:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 5b0:	00171006 	andseq	r1, r7, r6
 5b4:	00240200 	eoreq	r0, r4, r0, lsl #4
 5b8:	0b3e0b0b 	bleq	f831ec <_bss_end+0xf7a308>
 5bc:	00000e03 	andeq	r0, r0, r3, lsl #28
 5c0:	0b002403 	bleq	95d4 <_bss_end+0x6f0>
 5c4:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 5c8:	04000008 	streq	r0, [r0], #-8
 5cc:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
 5d0:	0b3b0b3a 	bleq	ec32c0 <_bss_end+0xeba3dc>
 5d4:	13490b39 	movtne	r0, #39737	; 0x9b39
 5d8:	26050000 	strcs	r0, [r5], -r0
 5dc:	00134900 	andseq	r4, r3, r0, lsl #18
 5e0:	00350600 	eorseq	r0, r5, r0, lsl #12
 5e4:	00001349 	andeq	r1, r0, r9, asr #6
 5e8:	03010407 	movweq	r0, #5127	; 0x1407
 5ec:	3e196d0e 	cdpcc	13, 1, cr6, cr9, cr14, {0}
 5f0:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
 5f4:	3b0b3a13 	blcc	2cee48 <_bss_end+0x2c5f64>
 5f8:	010b390b 	tsteq	fp, fp, lsl #18
 5fc:	08000013 	stmdaeq	r0, {r0, r1, r4}
 600:	0e030028 	cdpeq	0, 0, cr0, cr3, cr8, {1}
 604:	00000b1c 	andeq	r0, r0, ip, lsl fp
 608:	03002809 	movweq	r2, #2057	; 0x809
 60c:	000b1c08 	andeq	r1, fp, r8, lsl #24
 610:	01020a00 	tsteq	r2, r0, lsl #20
 614:	0b0b0e03 	bleq	2c3e28 <_bss_end+0x2baf44>
 618:	0b3b0b3a 	bleq	ec3308 <_bss_end+0xeba424>
 61c:	13010b39 	movwne	r0, #6969	; 0x1b39
 620:	0d0b0000 	stceq	0, cr0, [fp, #-0]
 624:	3a0e0300 	bcc	38122c <_bss_end+0x378348>
 628:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 62c:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 630:	0c00000b 	stceq	0, cr0, [r0], {11}
 634:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 638:	0b3a0e03 	bleq	e83e4c <_bss_end+0xe7af68>
 63c:	0b390b3b 	bleq	e43330 <_bss_end+0xe3a44c>
 640:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 644:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 648:	13011364 	movwne	r1, #4964	; 0x1364
 64c:	050d0000 	streq	r0, [sp, #-0]
 650:	34134900 	ldrcc	r4, [r3], #-2304	; 0xfffff700
 654:	0e000019 	mcreq	0, 0, r0, cr0, cr9, {0}
 658:	13490005 	movtne	r0, #36869	; 0x9005
 65c:	2e0f0000 	cdpcs	0, 0, cr0, cr15, cr0, {0}
 660:	03193f01 	tsteq	r9, #1, 30
 664:	3b0b3a0e 	blcc	2ceea4 <_bss_end+0x2c5fc0>
 668:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 66c:	3c0b320e 	sfmcc	f3, 4, [fp], {14}
 670:	01136419 	tsteq	r3, r9, lsl r4
 674:	10000013 	andne	r0, r0, r3, lsl r0
 678:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 67c:	0b3a0e03 	bleq	e83e90 <_bss_end+0xe7afac>
 680:	0b390b3b 	bleq	e43374 <_bss_end+0xe3a490>
 684:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 688:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 68c:	00001364 	andeq	r1, r0, r4, ror #6
 690:	0b000f11 	bleq	42dc <CPSR_IRQ_INHIBIT+0x425c>
 694:	0013490b 	andseq	r4, r3, fp, lsl #18
 698:	00101200 	andseq	r1, r0, r0, lsl #4
 69c:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 6a0:	34130000 	ldrcc	r0, [r3], #-0
 6a4:	3a0e0300 	bcc	3812ac <_bss_end+0x3783c8>
 6a8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 6ac:	3f13490b 	svccc	0x0013490b
 6b0:	00193c19 	andseq	r3, r9, r9, lsl ip
 6b4:	01391400 	teqeq	r9, r0, lsl #8
 6b8:	0b3a0803 	bleq	e826cc <_bss_end+0xe797e8>
 6bc:	0b390b3b 	bleq	e433b0 <_bss_end+0xe3a4cc>
 6c0:	00001301 	andeq	r1, r0, r1, lsl #6
 6c4:	03003415 	movweq	r3, #1045	; 0x415
 6c8:	3b0b3a0e 	blcc	2cef08 <_bss_end+0x2c6024>
 6cc:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 6d0:	1c193c13 	ldcne	12, cr3, [r9], {19}
 6d4:	00196c06 	andseq	r6, r9, r6, lsl #24
 6d8:	00341600 	eorseq	r1, r4, r0, lsl #12
 6dc:	0b3a0e03 	bleq	e83ef0 <_bss_end+0xe7b00c>
 6e0:	0b390b3b 	bleq	e433d4 <_bss_end+0xe3a4f0>
 6e4:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 6e8:	196c0b1c 	stmdbne	ip!, {r2, r3, r4, r8, r9, fp}^
 6ec:	34170000 	ldrcc	r0, [r7], #-0
 6f0:	00134700 	andseq	r4, r3, r0, lsl #14
 6f4:	012e1800 			; <UNDEFINED> instruction: 0x012e1800
 6f8:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 6fc:	0b3b0b3a 	bleq	ec33ec <_bss_end+0xeba508>
 700:	0e6e0b39 	vmoveq.8	d14[5], r0
 704:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 708:	00001364 	andeq	r1, r0, r4, ror #6
 70c:	3f002e19 	svccc	0x00002e19
 710:	3a0e0319 	bcc	38137c <_bss_end+0x378498>
 714:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 718:	1113490b 	tstne	r3, fp, lsl #18
 71c:	40061201 	andmi	r1, r6, r1, lsl #4
 720:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
 724:	01000000 	mrseq	r0, (UNDEF: 0)
 728:	06100011 			; <UNDEFINED> instruction: 0x06100011
 72c:	0e030655 	mcreq	6, 0, r0, cr3, cr5, {2}
 730:	0e250e1b 	mcreq	14, 1, r0, cr5, cr11, {0}
 734:	00000513 	andeq	r0, r0, r3, lsl r5
 738:	01110100 	tsteq	r1, r0, lsl #2
 73c:	0b130e25 	bleq	4c3fd8 <_bss_end+0x4bb0f4>
 740:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
 744:	06120111 			; <UNDEFINED> instruction: 0x06120111
 748:	00001710 	andeq	r1, r0, r0, lsl r7
 74c:	03001602 	movweq	r1, #1538	; 0x602
 750:	3b0b3a0e 	blcc	2cef90 <_bss_end+0x2c60ac>
 754:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 758:	03000013 	movweq	r0, #19
 75c:	0b0b000f 	bleq	2c07a0 <_bss_end+0x2b78bc>
 760:	00001349 	andeq	r1, r0, r9, asr #6
 764:	00001504 	andeq	r1, r0, r4, lsl #10
 768:	00340500 	eorseq	r0, r4, r0, lsl #10
 76c:	0b3a0e03 	bleq	e83f80 <_bss_end+0xe7b09c>
 770:	0b390b3b 	bleq	e43464 <_bss_end+0xe3a580>
 774:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
 778:	0000193c 	andeq	r1, r0, ip, lsr r9
 77c:	0b002406 	bleq	979c <_bss_end+0x8b8>
 780:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 784:	07000008 	streq	r0, [r0, -r8]
 788:	13490101 	movtne	r0, #37121	; 0x9101
 78c:	00001301 	andeq	r1, r0, r1, lsl #6
 790:	49002108 	stmdbmi	r0, {r3, r8, sp}
 794:	00062f13 	andeq	r2, r6, r3, lsl pc
 798:	00240900 	eoreq	r0, r4, r0, lsl #18
 79c:	0b3e0b0b 	bleq	f833d0 <_bss_end+0xf7a4ec>
 7a0:	00000e03 	andeq	r0, r0, r3, lsl #28
 7a4:	3f012e0a 	svccc	0x00012e0a
 7a8:	3a0e0319 	bcc	381414 <_bss_end+0x378530>
 7ac:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 7b0:	1113490b 	tstne	r3, fp, lsl #18
 7b4:	40061201 	andmi	r1, r6, r1, lsl #4
 7b8:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
 7bc:	00001301 	andeq	r1, r0, r1, lsl #6
 7c0:	0300340b 	movweq	r3, #1035	; 0x40b
 7c4:	3b0b3a0e 	blcc	2cf004 <_bss_end+0x2c6120>
 7c8:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 7cc:	00180213 	andseq	r0, r8, r3, lsl r2
 7d0:	012e0c00 			; <UNDEFINED> instruction: 0x012e0c00
 7d4:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 7d8:	0b3b0b3a 	bleq	ec34c8 <_bss_end+0xeba5e4>
 7dc:	13490b39 	movtne	r0, #39737	; 0x9b39
 7e0:	06120111 			; <UNDEFINED> instruction: 0x06120111
 7e4:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 7e8:	00130119 	andseq	r0, r3, r9, lsl r1
 7ec:	00340d00 	eorseq	r0, r4, r0, lsl #26
 7f0:	0b3a0803 	bleq	e82804 <_bss_end+0xe79920>
 7f4:	0b390b3b 	bleq	e434e8 <_bss_end+0xe3a604>
 7f8:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 7fc:	01000000 	mrseq	r0, (UNDEF: 0)
 800:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
 804:	0e030b13 	vmoveq.32	d3[0], r0
 808:	17100e1b 			; <UNDEFINED> instruction: 0x17100e1b
 80c:	24020000 	strcs	r0, [r2], #-0
 810:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 814:	0008030b 	andeq	r0, r8, fp, lsl #6
 818:	00240300 	eoreq	r0, r4, r0, lsl #6
 81c:	0b3e0b0b 	bleq	f83450 <_bss_end+0xf7a56c>
 820:	00000e03 	andeq	r0, r0, r3, lsl #28
 824:	03001604 	movweq	r1, #1540	; 0x604
 828:	3b0b3a0e 	blcc	2cf068 <_bss_end+0x2c6184>
 82c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 830:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
 834:	0b0b000f 	bleq	2c0878 <_bss_end+0x2b7994>
 838:	00001349 	andeq	r1, r0, r9, asr #6
 83c:	27011506 	strcs	r1, [r1, -r6, lsl #10]
 840:	01134919 	tsteq	r3, r9, lsl r9
 844:	07000013 	smladeq	r0, r3, r0, r0
 848:	13490005 	movtne	r0, #36869	; 0x9005
 84c:	26080000 	strcs	r0, [r8], -r0
 850:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
 854:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 858:	0b3b0b3a 	bleq	ec3548 <_bss_end+0xeba664>
 85c:	13490b39 	movtne	r0, #39737	; 0x9b39
 860:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
 864:	040a0000 	streq	r0, [sl], #-0
 868:	3e0e0301 	cdpcc	3, 0, cr0, cr14, cr1, {0}
 86c:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
 870:	3b0b3a13 	blcc	2cf0c4 <_bss_end+0x2c61e0>
 874:	010b390b 	tsteq	fp, fp, lsl #18
 878:	0b000013 	bleq	8cc <CPSR_IRQ_INHIBIT+0x84c>
 87c:	0e030028 	cdpeq	0, 0, cr0, cr3, cr8, {1}
 880:	00000b1c 	andeq	r0, r0, ip, lsl fp
 884:	4901010c 	stmdbmi	r1, {r2, r3, r8}
 888:	00130113 	andseq	r0, r3, r3, lsl r1
 88c:	00210d00 	eoreq	r0, r1, r0, lsl #26
 890:	260e0000 	strcs	r0, [lr], -r0
 894:	00134900 	andseq	r4, r3, r0, lsl #18
 898:	00340f00 	eorseq	r0, r4, r0, lsl #30
 89c:	0b3a0e03 	bleq	e840b0 <_bss_end+0xe7b1cc>
 8a0:	0b39053b 	bleq	e41d94 <_bss_end+0xe38eb0>
 8a4:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
 8a8:	0000193c 	andeq	r1, r0, ip, lsr r9
 8ac:	03001310 	movweq	r1, #784	; 0x310
 8b0:	00193c0e 	andseq	r3, r9, lr, lsl #24
 8b4:	00151100 	andseq	r1, r5, r0, lsl #2
 8b8:	00001927 	andeq	r1, r0, r7, lsr #18
 8bc:	03001712 	movweq	r1, #1810	; 0x712
 8c0:	00193c0e 	andseq	r3, r9, lr, lsl #24
 8c4:	01131300 	tsteq	r3, r0, lsl #6
 8c8:	0b0b0e03 	bleq	2c40dc <_bss_end+0x2bb1f8>
 8cc:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 8d0:	13010b39 	movwne	r0, #6969	; 0x1b39
 8d4:	0d140000 	ldceq	0, cr0, [r4, #-0]
 8d8:	3a0e0300 	bcc	3814e0 <_bss_end+0x3785fc>
 8dc:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 8e0:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 8e4:	1500000b 	strne	r0, [r0, #-11]
 8e8:	13490021 	movtne	r0, #36897	; 0x9021
 8ec:	00000b2f 	andeq	r0, r0, pc, lsr #22
 8f0:	03010416 	movweq	r0, #5142	; 0x1416
 8f4:	0b0b3e0e 	bleq	2d0134 <_bss_end+0x2c7250>
 8f8:	3a13490b 	bcc	4d2d2c <_bss_end+0x4c9e48>
 8fc:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 900:	0013010b 	andseq	r0, r3, fp, lsl #2
 904:	00341700 	eorseq	r1, r4, r0, lsl #14
 908:	0b3a1347 	bleq	e8562c <_bss_end+0xe7c748>
 90c:	0b39053b 	bleq	e41e00 <_bss_end+0xe38f1c>
 910:	00001802 	andeq	r1, r0, r2, lsl #16
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
  44:	0acd0002 	beq	ff340054 <_bss_end+0xff337170>
  48:	00040000 	andeq	r0, r4, r0
  4c:	00000000 	andeq	r0, r0, r0
  50:	000089a8 	andeq	r8, r0, r8, lsr #19
  54:	000002b8 			; <UNDEFINED> instruction: 0x000002b8
	...
  60:	0000001c 	andeq	r0, r0, ip, lsl r0
  64:	12d20002 	sbcsne	r0, r2, #2
  68:	00040000 	andeq	r0, r4, r0
  6c:	00000000 	andeq	r0, r0, r0
  70:	00008c60 	andeq	r8, r0, r0, ror #24
  74:	00000064 	andeq	r0, r0, r4, rrx
	...
  80:	00000024 	andeq	r0, r0, r4, lsr #32
  84:	18cd0002 	stmiane	sp, {r1}^
  88:	00040000 	andeq	r0, r4, r0
  8c:	00000000 	andeq	r0, r0, r0
  90:	00008000 	andeq	r8, r0, r0
  94:	00000094 	muleq	r0, r4, r0
  98:	00008cc4 	andeq	r8, r0, r4, asr #25
  9c:	00000020 	andeq	r0, r0, r0, lsr #32
	...
  a8:	0000001c 	andeq	r0, r0, ip, lsl r0
  ac:	18ef0002 	stmiane	pc!, {r1}^	; <UNPREDICTABLE>
  b0:	00040000 	andeq	r0, r4, r0
  b4:	00000000 	andeq	r0, r0, r0
  b8:	00008ce4 	andeq	r8, r0, r4, ror #25
  bc:	00000118 	andeq	r0, r0, r8, lsl r1
	...
  c8:	00000014 	andeq	r0, r0, r4, lsl r0
  cc:	1a3e0002 	bne	f800dc <_bss_end+0xf771f8>
  d0:	00040000 	andeq	r0, r4, r0
	...

Disassembly of section .debug_line:

00000000 <.debug_line>:
   0:	000000aa 	andeq	r0, r0, sl, lsr #1
   4:	00710003 	rsbseq	r0, r1, r3
   8:	01020000 	mrseq	r0, (UNDEF: 2)
   c:	000d0efb 	strdeq	r0, [sp], -fp
  10:	01010101 	tsteq	r1, r1, lsl #2
  14:	01000000 	mrseq	r0, (UNDEF: 0)
  18:	2f010000 	svccs	0x00010000
  1c:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
  20:	6c69732f 	stclvs	3, cr7, [r9], #-188	; 0xffffff44
  24:	79766168 	ldmdbvc	r6!, {r3, r5, r6, r8, sp, lr}^
  28:	63532f6a 	cmpvs	r3, #424	; 0x1a8
  2c:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; fffffe94 <_bss_end+0xffff6fb0>
  30:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
  34:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
  38:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
  3c:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
  40:	302f7365 	eorcc	r7, pc, r5, ror #6
  44:	50472d39 	subpl	r2, r7, r9, lsr sp
  48:	695f4f49 	ldmdbvs	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
  4c:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
  50:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
  54:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
  58:	2f6c656e 	svccs	0x006c656e
  5c:	00637273 	rsbeq	r7, r3, r3, ror r2
  60:	78786300 	ldmdavc	r8!, {r8, r9, sp, lr}^
  64:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
  68:	00000100 	andeq	r0, r0, r0, lsl #2
  6c:	6975623c 	ldmdbvs	r5!, {r2, r3, r4, r5, r9, sp, lr}^
  70:	692d746c 	pushvs	{r2, r3, r5, r6, sl, ip, sp, lr}
  74:	00003e6e 	andeq	r3, r0, lr, ror #28
  78:	05000000 	streq	r0, [r0, #-0]
  7c:	02050005 	andeq	r0, r5, #5
  80:	00008094 	muleq	r0, r4, r0
  84:	05010a03 	streq	r0, [r1, #-2563]	; 0xfffff5fd
  88:	10058311 	andne	r8, r5, r1, lsl r3
  8c:	8305054a 	movwhi	r0, #21834	; 0x554a
  90:	83130585 	tsthi	r3, #557842432	; 0x21400000
  94:	85670505 	strbhi	r0, [r7, #-1285]!	; 0xfffffafb
  98:	86010583 	strhi	r0, [r1], -r3, lsl #11
  9c:	854c854c 	strbhi	r8, [ip, #-1356]	; 0xfffffab4
  a0:	0505854c 	streq	r8, [r5, #-1356]	; 0xfffffab4
  a4:	01040200 	mrseq	r0, R12_usr
  a8:	0002024b 	andeq	r0, r2, fp, asr #4
  ac:	041f0101 	ldreq	r0, [pc], #-257	; b4 <CPSR_IRQ_INHIBIT+0x34>
  b0:	00030000 	andeq	r0, r3, r0
  b4:	0000013c 	andeq	r0, r0, ip, lsr r1
  b8:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
  bc:	0101000d 	tsteq	r1, sp
  c0:	00000101 	andeq	r0, r0, r1, lsl #2
  c4:	00000100 	andeq	r0, r0, r0, lsl #2
  c8:	6f682f01 	svcvs	0x00682f01
  cc:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
  d0:	61686c69 	cmnvs	r8, r9, ror #24
  d4:	2f6a7976 	svccs	0x006a7976
  d8:	6f686353 	svcvs	0x00686353
  dc:	5a2f6c6f 	bpl	bdb2a0 <_bss_end+0xbd23bc>
  e0:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; ffffff54 <_bss_end+0xffff7070>
  e4:	2f657461 	svccs	0x00657461
  e8:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
  ec:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
  f0:	2d39302f 	ldccs	0, cr3, [r9, #-188]!	; 0xffffff44
  f4:	4f495047 	svcmi	0x00495047
  f8:	746e695f 	strbtvc	r6, [lr], #-2399	; 0xfffff6a1
  fc:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
 100:	6b2f7470 	blvs	bdd2c8 <_bss_end+0xbd43e4>
 104:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 108:	72732f6c 	rsbsvc	r2, r3, #108, 30	; 0x1b0
 10c:	72642f63 	rsbvc	r2, r4, #396	; 0x18c
 110:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
 114:	682f0073 	stmdavs	pc!, {r0, r1, r4, r5, r6}	; <UNPREDICTABLE>
 118:	2f656d6f 	svccs	0x00656d6f
 11c:	686c6973 	stmdavs	ip!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
 120:	6a797661 	bvs	1e5daac <_bss_end+0x1e54bc8>
 124:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
 128:	2f6c6f6f 	svccs	0x006c6f6f
 12c:	6f72655a 	svcvs	0x0072655a
 130:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
 134:	6178652f 	cmnvs	r8, pc, lsr #10
 138:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
 13c:	39302f73 	ldmdbcc	r0!, {r0, r1, r4, r5, r6, r8, r9, sl, fp, sp}
 140:	4950472d 	ldmdbmi	r0, {r0, r2, r3, r5, r8, r9, sl, lr}^
 144:	6e695f4f 	cdpvs	15, 6, cr5, cr9, cr15, {2}
 148:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
 14c:	2f747075 	svccs	0x00747075
 150:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 154:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 158:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 15c:	622f6564 	eorvs	r6, pc, #100, 10	; 0x19000000
 160:	6472616f 	ldrbtvs	r6, [r2], #-367	; 0xfffffe91
 164:	6970722f 	ldmdbvs	r0!, {r0, r1, r2, r3, r5, r9, ip, sp, lr}^
 168:	61682f30 	cmnvs	r8, r0, lsr pc
 16c:	682f006c 	stmdavs	pc!, {r2, r3, r5, r6}	; <UNPREDICTABLE>
 170:	2f656d6f 	svccs	0x00656d6f
 174:	686c6973 	stmdavs	ip!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
 178:	6a797661 	bvs	1e5db04 <_bss_end+0x1e54c20>
 17c:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
 180:	2f6c6f6f 	svccs	0x006c6f6f
 184:	6f72655a 	svcvs	0x0072655a
 188:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
 18c:	6178652f 	cmnvs	r8, pc, lsr #10
 190:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
 194:	39302f73 	ldmdbcc	r0!, {r0, r1, r4, r5, r6, r8, r9, sl, fp, sp}
 198:	4950472d 	ldmdbmi	r0, {r0, r2, r3, r5, r8, r9, sl, lr}^
 19c:	6e695f4f 	cdpvs	15, 6, cr5, cr9, cr15, {2}
 1a0:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
 1a4:	2f747075 	svccs	0x00747075
 1a8:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 1ac:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 1b0:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 1b4:	642f6564 	strtvs	r6, [pc], #-1380	; 1bc <CPSR_IRQ_INHIBIT+0x13c>
 1b8:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
 1bc:	00007372 	andeq	r7, r0, r2, ror r3
 1c0:	6f697067 	svcvs	0x00697067
 1c4:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
 1c8:	00000100 	andeq	r0, r0, r0, lsl #2
 1cc:	64746e69 	ldrbtvs	r6, [r4], #-3689	; 0xfffff197
 1d0:	682e6665 	stmdavs	lr!, {r0, r2, r5, r6, r9, sl, sp, lr}
 1d4:	00000200 	andeq	r0, r0, r0, lsl #4
 1d8:	69726570 	ldmdbvs	r2!, {r4, r5, r6, r8, sl, sp, lr}^
 1dc:	72656870 	rsbvc	r6, r5, #112, 16	; 0x700000
 1e0:	2e736c61 	cdpcs	12, 7, cr6, cr3, cr1, {3}
 1e4:	00020068 	andeq	r0, r2, r8, rrx
 1e8:	69706700 	ldmdbvs	r0!, {r8, r9, sl, sp, lr}^
 1ec:	00682e6f 	rsbeq	r2, r8, pc, ror #28
 1f0:	00000003 	andeq	r0, r0, r3
 1f4:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
 1f8:	00816c02 	addeq	r6, r1, r2, lsl #24
 1fc:	38051700 	stmdacc	r5, {r8, r9, sl, ip}
 200:	6901059f 	stmdbvs	r1, {r0, r1, r2, r3, r4, r7, r8, sl}
 204:	d70505a1 	strle	r0, [r5, -r1, lsr #11]
 208:	05671005 	strbeq	r1, [r7, #-5]!
 20c:	93084c11 	movwls	r4, #35857	; 0x8c11
 210:	05670d05 	strbeq	r0, [r7, #-3333]!	; 0xfffff2fb
 214:	0d053011 	stceq	0, cr3, [r5, #-68]	; 0xffffffbc
 218:	30110567 	andscc	r0, r1, r7, ror #10
 21c:	05670d05 	strbeq	r0, [r7, #-3333]!	; 0xfffff2fb
 220:	0d053011 	stceq	0, cr3, [r5, #-68]	; 0xffffffbc
 224:	30110567 	andscc	r0, r1, r7, ror #10
 228:	05670d05 	strbeq	r0, [r7, #-3333]!	; 0xfffff2fb
 22c:	0d053011 	stceq	0, cr3, [r5, #-68]	; 0xffffffbc
 230:	31140567 	tstcc	r4, r7, ror #10
 234:	20081a05 	andcs	r1, r8, r5, lsl #20
 238:	05660d05 	strbeq	r0, [r6, #-3333]!	; 0xfffff2fb
 23c:	01054c0c 	tsteq	r5, ip, lsl #24
 240:	0505a12f 	streq	sl, [r5, #-303]	; 0xfffffed1
 244:	671005d7 			; <UNDEFINED> instruction: 0x671005d7
 248:	004c0b05 	subeq	r0, ip, r5, lsl #22
 24c:	06010402 	streq	r0, [r1], -r2, lsl #8
 250:	04020066 	streq	r0, [r2], #-102	; 0xffffff9a
 254:	09054a02 	stmdbeq	r5, {r1, r9, fp, lr}
 258:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
 25c:	13052e06 	movwne	r2, #24070	; 0x5e06
 260:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
 264:	000d054b 	andeq	r0, sp, fp, asr #10
 268:	4a040402 	bmi	101278 <_bss_end+0xf8394>
 26c:	02000c05 	andeq	r0, r0, #1280	; 0x500
 270:	054c0404 	strbeq	r0, [ip, #-1028]	; 0xfffffbfc
 274:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 278:	1005d705 	andne	sp, r5, r5, lsl #14
 27c:	4c0b0567 	cfstr32mi	mvfx0, [fp], {103}	; 0x67
 280:	01040200 	mrseq	r0, R12_usr
 284:	02006606 	andeq	r6, r0, #6291456	; 0x600000
 288:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 28c:	04020009 	streq	r0, [r2], #-9
 290:	052e0604 	streq	r0, [lr, #-1540]!	; 0xfffff9fc
 294:	04020013 	streq	r0, [r2], #-19	; 0xffffffed
 298:	0d054b04 	vstreq	d4, [r5, #-16]
 29c:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
 2a0:	000c054a 	andeq	r0, ip, sl, asr #10
 2a4:	4c040402 	cfstrsmi	mvf0, [r4], {2}
 2a8:	852f0105 	strhi	r0, [pc, #-261]!	; 1ab <CPSR_IRQ_INHIBIT+0x12b>
 2ac:	05d70505 	ldrbeq	r0, [r7, #1285]	; 0x505
 2b0:	0b056710 	bleq	159ef8 <_bss_end+0x151014>
 2b4:	0402004c 	streq	r0, [r2], #-76	; 0xffffffb4
 2b8:	00660601 	rsbeq	r0, r6, r1, lsl #12
 2bc:	4a020402 	bmi	812cc <_bss_end+0x783e8>
 2c0:	02000905 	andeq	r0, r0, #81920	; 0x14000
 2c4:	2e060404 	cdpcs	4, 0, cr0, cr6, cr4, {0}
 2c8:	02001305 	andeq	r1, r0, #335544320	; 0x14000000
 2cc:	054b0404 	strbeq	r0, [fp, #-1028]	; 0xfffffbfc
 2d0:	0402000d 	streq	r0, [r2], #-13
 2d4:	0c054a04 			; <UNDEFINED> instruction: 0x0c054a04
 2d8:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
 2dc:	2f01054c 	svccs	0x0001054c
 2e0:	d81d0585 	ldmdale	sp, {r0, r2, r7, r8, sl}
 2e4:	05ba0905 	ldreq	r0, [sl, #2309]!	; 0x905
 2e8:	13054a05 	movwne	r4, #23045	; 0x5a05
 2ec:	4a1c054d 	bmi	701828 <_bss_end+0x6f8944>
 2f0:	05823e05 	streq	r3, [r2, #3589]	; 0xe05
 2f4:	1e056621 	cfmadd32ne	mvax1, mvfx6, mvfx5, mvfx1
 2f8:	2e4b052e 	cdpcs	5, 4, cr0, cr11, cr14, {1}
 2fc:	052e6b05 	streq	r6, [lr, #-2821]!	; 0xfffff4fb
 300:	0e054a05 	vmlaeq.f32	s8, s10, s10
 304:	6648054a 	strbvs	r0, [r8], -sl, asr #10
 308:	052e1005 	streq	r1, [lr, #-5]!
 30c:	01054809 	tsteq	r5, r9, lsl #16
 310:	1d054d31 	stcne	13, cr4, [r5, #-196]	; 0xffffff3c
 314:	ba0905a0 	blt	24199c <_bss_end+0x238ab8>
 318:	054a0505 	strbeq	r0, [sl, #-1285]	; 0xfffffafb
 31c:	29054b20 	stmdbcs	r5, {r5, r8, r9, fp, lr}
 320:	4a32054c 	bmi	c81858 <_bss_end+0xc78974>
 324:	05823405 	streq	r3, [r2, #1029]	; 0x405
 328:	3f054a0c 	svccc	0x00054a0c
 32c:	0001052e 	andeq	r0, r1, lr, lsr #10
 330:	4b010402 	blmi	41340 <_bss_end+0x3845c>
 334:	bc240569 	cfstr32lt	mvfx0, [r4], #-420	; 0xfffffe5c
 338:	20080905 	andcs	r0, r8, r5, lsl #18
 33c:	054a0505 	strbeq	r0, [sl, #-1285]	; 0xfffffafb
 340:	05054d15 	streq	r4, [r5, #-3349]	; 0xfffff2eb
 344:	4a0e0566 	bmi	3818e4 <_bss_end+0x378a00>
 348:	05661505 	strbeq	r1, [r6, #-1285]!	; 0xfffffafb
 34c:	09052e10 	stmdbeq	r5, {r4, r9, sl, fp, sp}
 350:	03010548 	movweq	r0, #5448	; 0x1548
 354:	054d2e09 	strbeq	r2, [sp, #-3593]	; 0xfffff1f7
 358:	1005d705 	andne	sp, r5, r5, lsl #14
 35c:	4c130567 	cfldr32mi	mvfx0, [r3], {103}	; 0x67
 360:	054a0d05 	strbeq	r0, [sl, #-3333]	; 0xfffff2fb
 364:	00410813 	subeq	r0, r1, r3, lsl r8
 368:	06010402 	streq	r0, [r1], -r2, lsl #8
 36c:	04020066 	streq	r0, [r2], #-102	; 0xffffff9a
 370:	11054a02 	tstne	r5, r2, lsl #20
 374:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
 378:	0d052e06 	stceq	14, cr2, [r5, #-24]	; 0xffffffe8
 37c:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
 380:	3013054b 	andscc	r0, r3, fp, asr #10
 384:	01040200 	mrseq	r0, R12_usr
 388:	02006606 	andeq	r6, r0, #6291456	; 0x600000
 38c:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 390:	04020011 	streq	r0, [r2], #-17	; 0xffffffef
 394:	052e0604 	streq	r0, [lr, #-1540]!	; 0xfffff9fc
 398:	0402000d 	streq	r0, [r2], #-13
 39c:	13054b04 	movwne	r4, #23300	; 0x5b04
 3a0:	04020030 	streq	r0, [r2], #-48	; 0xffffffd0
 3a4:	00660601 	rsbeq	r0, r6, r1, lsl #12
 3a8:	4a020402 	bmi	813b8 <_bss_end+0x784d4>
 3ac:	02001105 	andeq	r1, r0, #1073741825	; 0x40000001
 3b0:	2e060404 	cdpcs	4, 0, cr0, cr6, cr4, {0}
 3b4:	02000d05 	andeq	r0, r0, #320	; 0x140
 3b8:	054b0404 	strbeq	r0, [fp, #-1028]	; 0xfffffbfc
 3bc:	02003013 	andeq	r3, r0, #19
 3c0:	66060104 	strvs	r0, [r6], -r4, lsl #2
 3c4:	02040200 	andeq	r0, r4, #0, 4
 3c8:	0011054a 	andseq	r0, r1, sl, asr #10
 3cc:	06040402 	streq	r0, [r4], -r2, lsl #8
 3d0:	000d052e 	andeq	r0, sp, lr, lsr #10
 3d4:	4b040402 	blmi	1013e4 <_bss_end+0xf8500>
 3d8:	05301405 	ldreq	r1, [r0, #-1029]!	; 0xfffffbfb
 3dc:	01054d0c 	tsteq	r5, ip, lsl #26
 3e0:	2405852f 	strcs	r8, [r5], #-1327	; 0xfffffad1
 3e4:	080905bc 	stmdaeq	r9, {r2, r3, r4, r5, r7, r8, sl}
 3e8:	4a050520 	bmi	141870 <_bss_end+0x13898c>
 3ec:	054d1405 	strbeq	r1, [sp, #-1029]	; 0xfffffbfb
 3f0:	0e054a1d 			; <UNDEFINED> instruction: 0x0e054a1d
 3f4:	4b100566 	blmi	401994 <_bss_end+0x3f8ab0>
 3f8:	05660c05 	strbeq	r0, [r6, #-3077]!	; 0xfffff3fb
 3fc:	05054a09 	streq	r4, [r5, #-2569]	; 0xfffff5f7
 400:	4a0e0567 	bmi	3819a4 <_bss_end+0x378ac0>
 404:	05661005 	strbeq	r1, [r6, #-5]!
 408:	01056209 	tsteq	r5, r9, lsl #4
 40c:	0b054d33 	bleq	1538e0 <_bss_end+0x14a9fc>
 410:	663505d8 			; <UNDEFINED> instruction: 0x663505d8
 414:	02002405 	andeq	r2, r0, #83886080	; 0x5000000
 418:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 41c:	04020009 	streq	r0, [r2], #-9
 420:	3505f202 	strcc	pc, [r5, #-514]	; 0xfffffdfe
 424:	03040200 	movweq	r0, #16896	; 0x4200
 428:	0054054a 	subseq	r0, r4, sl, asr #10
 42c:	66060402 	strvs	r0, [r6], -r2, lsl #8
 430:	02003805 	andeq	r3, r0, #327680	; 0x50000
 434:	05f20604 	ldrbeq	r0, [r2, #1540]!	; 0x604
 438:	04020035 	streq	r0, [r2], #-53	; 0xffffffcb
 43c:	02004a07 	andeq	r4, r0, #28672	; 0x7000
 440:	4a060804 	bmi	182458 <_bss_end+0x179574>
 444:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
 448:	2e060a04 	vmlacs.f32	s0, s12, s8
 44c:	054d1505 	strbeq	r1, [sp, #-1285]	; 0xfffffafb
 450:	0e056605 	cfmadd32eq	mvax0, mvfx6, mvfx5, mvfx5
 454:	6615054a 	ldrvs	r0, [r5], -sl, asr #10
 458:	052e1005 	streq	r1, [lr, #-5]!
 45c:	01054809 	tsteq	r5, r9, lsl #16
 460:	05054d31 	streq	r4, [r5, #-3377]	; 0xfffff2cf
 464:	671005d7 			; <UNDEFINED> instruction: 0x671005d7
 468:	004c0b05 	subeq	r0, ip, r5, lsl #22
 46c:	06010402 	streq	r0, [r1], -r2, lsl #8
 470:	04020066 	streq	r0, [r2], #-102	; 0xffffff9a
 474:	09054a02 	stmdbeq	r5, {r1, r9, fp, lr}
 478:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
 47c:	13052e06 	movwne	r2, #24070	; 0x5e06
 480:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
 484:	000d054b 	andeq	r0, sp, fp, asr #10
 488:	4a040402 	bmi	101498 <_bss_end+0xf85b4>
 48c:	02000c05 	andeq	r0, r0, #1280	; 0x500
 490:	054c0404 	strbeq	r0, [ip, #-1028]	; 0xfffffbfc
 494:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 498:	0905a01c 	stmdbeq	r5, {r2, r3, r4, sp, pc}
 49c:	4a0505ba 	bmi	141b8c <_bss_end+0x138ca8>
 4a0:	054e1405 	strbeq	r1, [lr, #-1029]	; 0xfffffbfb
 4a4:	0e056605 	cfmadd32eq	mvax0, mvfx6, mvfx5, mvfx5
 4a8:	6614054a 	ldrvs	r0, [r4], -sl, asr #10
 4ac:	052e1005 	streq	r1, [lr, #-5]!
 4b0:	01054709 	tsteq	r5, r9, lsl #14
 4b4:	009e4a32 	addseq	r4, lr, r2, lsr sl
 4b8:	06010402 	streq	r0, [r1], -r2, lsl #8
 4bc:	06230566 	strteq	r0, [r3], -r6, ror #10
 4c0:	827ed303 	rsbshi	sp, lr, #201326592	; 0xc000000
 4c4:	ad030105 	stfges	f0, [r3, #-20]	; 0xffffffec
 4c8:	4aba6601 	bmi	fee99cd4 <_bss_end+0xfee90df0>
 4cc:	01000a02 	tsteq	r0, r2, lsl #20
 4d0:	00028901 	andeq	r8, r2, r1, lsl #18
 4d4:	a7000300 	strge	r0, [r0, -r0, lsl #6]
 4d8:	02000001 	andeq	r0, r0, #1
 4dc:	0d0efb01 	vstreq	d15, [lr, #-4]
 4e0:	01010100 	mrseq	r0, (UNDEF: 17)
 4e4:	00000001 	andeq	r0, r0, r1
 4e8:	01000001 	tsteq	r0, r1
 4ec:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 438 <CPSR_IRQ_INHIBIT+0x3b8>
 4f0:	69732f65 	ldmdbvs	r3!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 4f4:	7661686c 	strbtvc	r6, [r1], -ip, ror #16
 4f8:	532f6a79 			; <UNDEFINED> instruction: 0x532f6a79
 4fc:	6f6f6863 	svcvs	0x006f6863
 500:	655a2f6c 	ldrbvs	r2, [sl, #-3948]	; 0xfffff094
 504:	614d6f72 	hvcvs	55026	; 0xd6f2
 508:	652f6574 	strvs	r6, [pc, #-1396]!	; ffffff9c <_bss_end+0xffff70b8>
 50c:	706d6178 	rsbvc	r6, sp, r8, ror r1
 510:	2f73656c 	svccs	0x0073656c
 514:	472d3930 			; <UNDEFINED> instruction: 0x472d3930
 518:	5f4f4950 	svcpl	0x004f4950
 51c:	65746e69 	ldrbvs	r6, [r4, #-3689]!	; 0xfffff197
 520:	70757272 	rsbsvc	r7, r5, r2, ror r2
 524:	656b2f74 	strbvs	r2, [fp, #-3956]!	; 0xfffff08c
 528:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
 52c:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
 530:	6f682f00 	svcvs	0x00682f00
 534:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
 538:	61686c69 	cmnvs	r8, r9, ror #24
 53c:	2f6a7976 	svccs	0x006a7976
 540:	6f686353 	svcvs	0x00686353
 544:	5a2f6c6f 	bpl	bdb708 <_bss_end+0xbd2824>
 548:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 3bc <CPSR_IRQ_INHIBIT+0x33c>
 54c:	2f657461 	svccs	0x00657461
 550:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
 554:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
 558:	2d39302f 	ldccs	0, cr3, [r9, #-188]!	; 0xffffff44
 55c:	4f495047 	svcmi	0x00495047
 560:	746e695f 	strbtvc	r6, [lr], #-2399	; 0xfffff6a1
 564:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
 568:	6b2f7470 	blvs	bdd730 <_bss_end+0xbd484c>
 56c:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 570:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
 574:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 578:	6f622f65 	svcvs	0x00622f65
 57c:	2f647261 	svccs	0x00647261
 580:	30697072 	rsbcc	r7, r9, r2, ror r0
 584:	6c61682f 	stclvs	8, cr6, [r1], #-188	; 0xffffff44
 588:	6f682f00 	svcvs	0x00682f00
 58c:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
 590:	61686c69 	cmnvs	r8, r9, ror #24
 594:	2f6a7976 	svccs	0x006a7976
 598:	6f686353 	svcvs	0x00686353
 59c:	5a2f6c6f 	bpl	bdb760 <_bss_end+0xbd287c>
 5a0:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 414 <CPSR_IRQ_INHIBIT+0x394>
 5a4:	2f657461 	svccs	0x00657461
 5a8:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
 5ac:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
 5b0:	2d39302f 	ldccs	0, cr3, [r9, #-188]!	; 0xffffff44
 5b4:	4f495047 	svcmi	0x00495047
 5b8:	746e695f 	strbtvc	r6, [lr], #-2399	; 0xfffff6a1
 5bc:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
 5c0:	6b2f7470 	blvs	bdd788 <_bss_end+0xbd48a4>
 5c4:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 5c8:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
 5cc:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 5d0:	72642f65 	rsbvc	r2, r4, #404	; 0x194
 5d4:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
 5d8:	682f0073 	stmdavs	pc!, {r0, r1, r4, r5, r6}	; <UNPREDICTABLE>
 5dc:	2f656d6f 	svccs	0x00656d6f
 5e0:	686c6973 	stmdavs	ip!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
 5e4:	6a797661 	bvs	1e5df70 <_bss_end+0x1e5508c>
 5e8:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
 5ec:	2f6c6f6f 	svccs	0x006c6f6f
 5f0:	6f72655a 	svcvs	0x0072655a
 5f4:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
 5f8:	6178652f 	cmnvs	r8, pc, lsr #10
 5fc:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
 600:	39302f73 	ldmdbcc	r0!, {r0, r1, r4, r5, r6, r8, r9, sl, fp, sp}
 604:	4950472d 	ldmdbmi	r0, {r0, r2, r3, r5, r8, r9, sl, lr}^
 608:	6e695f4f 	cdpvs	15, 6, cr5, cr9, cr15, {2}
 60c:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
 610:	2f747075 	svccs	0x00747075
 614:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 618:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 61c:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 620:	00006564 	andeq	r6, r0, r4, ror #10
 624:	65746e69 	ldrbvs	r6, [r4, #-3689]!	; 0xfffff197
 628:	70757272 	rsbsvc	r7, r5, r2, ror r2
 62c:	6f635f74 	svcvs	0x00635f74
 630:	6f72746e 	svcvs	0x0072746e
 634:	72656c6c 	rsbvc	r6, r5, #108, 24	; 0x6c00
 638:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
 63c:	00000100 	andeq	r0, r0, r0, lsl #2
 640:	64746e69 	ldrbtvs	r6, [r4], #-3689	; 0xfffff197
 644:	682e6665 	stmdavs	lr!, {r0, r2, r5, r6, r9, sl, sp, lr}
 648:	00000200 	andeq	r0, r0, r0, lsl #4
 64c:	69726570 	ldmdbvs	r2!, {r4, r5, r6, r8, sl, sp, lr}^
 650:	72656870 	rsbvc	r6, r5, #112, 16	; 0x700000
 654:	2e736c61 	cdpcs	12, 7, cr6, cr3, cr1, {3}
 658:	00020068 	andeq	r0, r2, r8, rrx
 65c:	69706700 	ldmdbvs	r0!, {r8, r9, sl, sp, lr}^
 660:	00682e6f 	rsbeq	r2, r8, pc, ror #28
 664:	69000003 	stmdbvs	r0, {r0, r1}
 668:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
 66c:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
 670:	6e6f635f 	mcrvs	3, 3, r6, cr15, cr15, {2}
 674:	6c6f7274 	sfmvs	f7, 2, [pc], #-464	; 4ac <CPSR_IRQ_INHIBIT+0x42c>
 678:	2e72656c 	cdpcs	5, 7, cr6, cr2, cr12, {3}
 67c:	00040068 	andeq	r0, r4, r8, rrx
 680:	01050000 	mrseq	r0, (UNDEF: 5)
 684:	a8020500 	stmdage	r2, {r8, sl}
 688:	18000089 	stmdane	r0, {r0, r3, r7}
 68c:	1505854b 	strne	r8, [r5, #-1355]	; 0xfffffab5
 690:	bb0e0568 	bllt	381c38 <_bss_end+0x378d54>
 694:	05820c05 	streq	r0, [r2, #3077]	; 0xc05
 698:	01054c1f 	tsteq	r5, pc, lsl ip
 69c:	6a2fa167 	bvs	be8c40 <_bss_end+0xbdfd5c>
 6a0:	059f1305 	ldreq	r1, [pc, #773]	; 9ad <CPSR_IRQ_INHIBIT+0x92d>
 6a4:	01052e38 	tsteq	r5, r8, lsr lr
 6a8:	0c05a14c 	stfeqd	f2, [r5], {76}	; 0x4c
 6ac:	4a1c059f 	bmi	701d30 <_bss_end+0x6f8e4c>
 6b0:	052e3a05 	streq	r3, [lr, #-2565]!	; 0xfffff5fb
 6b4:	05854b01 	streq	r4, [r5, #2817]	; 0xb01
 6b8:	40059f43 	andmi	r9, r5, r3, asr #30
 6bc:	4a39052e 	bmi	e41b7c <_bss_end+0xe38c98>
 6c0:	05824005 	streq	r4, [r2, #5]
 6c4:	01052e3b 	tsteq	r5, fp, lsr lr
 6c8:	4405692f 	strmi	r6, [r5], #-2351	; 0xfffff6d1
 6cc:	2e41059f 	mcrcs	5, 2, r0, cr1, cr15, {4}
 6d0:	054a3a05 	strbeq	r3, [sl, #-2565]	; 0xfffff5fb
 6d4:	3c058241 	sfmcc	f0, 1, [r5], {65}	; 0x41
 6d8:	2f01052e 	svccs	0x0001052e
 6dc:	9f180569 	svcls	0x00180569
 6e0:	4c018705 	stcmi	7, cr8, [r1], {5}
 6e4:	054a7a05 	strbeq	r7, [sl, #-2565]	; 0xfffff5fb
 6e8:	02004a73 	andeq	r4, r0, #471040	; 0x73000
 6ec:	66060104 	strvs	r0, [r6], -r4, lsl #2
 6f0:	02040200 	andeq	r0, r4, #0, 4
 6f4:	0402004a 	streq	r0, [r2], #-74	; 0xffffffb6
 6f8:	7a052e04 	bvc	14bf10 <_bss_end+0x14302c>
 6fc:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
 700:	75058206 	strvc	r8, [r5, #-518]	; 0xfffffdfa
 704:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
 708:	0001052e 	andeq	r0, r1, lr, lsr #10
 70c:	2f040402 	svccs	0x00040402
 710:	9f180569 	svcls	0x00180569
 714:	4c018905 			; <UNDEFINED> instruction: 0x4c018905
 718:	054a7c05 	strbeq	r7, [sl, #-3077]	; 0xfffff3fb
 71c:	02004a75 	andeq	r4, r0, #479232	; 0x75000
 720:	66060104 	strvs	r0, [r6], -r4, lsl #2
 724:	02040200 	andeq	r0, r4, #0, 4
 728:	0402004a 	streq	r0, [r2], #-74	; 0xffffffb6
 72c:	7c052e04 	stcvc	14, cr2, [r5], {4}
 730:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
 734:	77058206 	strvc	r8, [r5, -r6, lsl #4]
 738:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
 73c:	0001052e 	andeq	r0, r1, lr, lsr #10
 740:	2f040402 	svccs	0x00040402
 744:	02009e66 	andeq	r9, r0, #1632	; 0x660
 748:	66060104 	strvs	r0, [r6], -r4, lsl #2
 74c:	03064305 	movweq	r4, #25349	; 0x6305
 750:	0105825e 	tsteq	r5, lr, asr r2
 754:	ba662203 	blt	1988f68 <_bss_end+0x1980084>
 758:	000a024a 	andeq	r0, sl, sl, asr #4
 75c:	01c10101 	biceq	r0, r1, r1, lsl #2
 760:	00030000 	andeq	r0, r3, r0
 764:	00000197 	muleq	r0, r7, r1
 768:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
 76c:	0101000d 	tsteq	r1, sp
 770:	00000101 	andeq	r0, r0, r1, lsl #2
 774:	00000100 	andeq	r0, r0, r0, lsl #2
 778:	6f682f01 	svcvs	0x00682f01
 77c:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
 780:	61686c69 	cmnvs	r8, r9, ror #24
 784:	2f6a7976 	svccs	0x006a7976
 788:	6f686353 	svcvs	0x00686353
 78c:	5a2f6c6f 	bpl	bdb950 <_bss_end+0xbd2a6c>
 790:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 604 <CPSR_IRQ_INHIBIT+0x584>
 794:	2f657461 	svccs	0x00657461
 798:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
 79c:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
 7a0:	2d39302f 	ldccs	0, cr3, [r9, #-188]!	; 0xffffff44
 7a4:	4f495047 	svcmi	0x00495047
 7a8:	746e695f 	strbtvc	r6, [lr], #-2399	; 0xfffff6a1
 7ac:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
 7b0:	6b2f7470 	blvs	bdd978 <_bss_end+0xbd4a94>
 7b4:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 7b8:	72732f6c 	rsbsvc	r2, r3, #108, 30	; 0x1b0
 7bc:	682f0063 	stmdavs	pc!, {r0, r1, r5, r6}	; <UNPREDICTABLE>
 7c0:	2f656d6f 	svccs	0x00656d6f
 7c4:	686c6973 	stmdavs	ip!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
 7c8:	6a797661 	bvs	1e5e154 <_bss_end+0x1e55270>
 7cc:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
 7d0:	2f6c6f6f 	svccs	0x006c6f6f
 7d4:	6f72655a 	svcvs	0x0072655a
 7d8:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
 7dc:	6178652f 	cmnvs	r8, pc, lsr #10
 7e0:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
 7e4:	39302f73 	ldmdbcc	r0!, {r0, r1, r4, r5, r6, r8, r9, sl, fp, sp}
 7e8:	4950472d 	ldmdbmi	r0, {r0, r2, r3, r5, r8, r9, sl, lr}^
 7ec:	6e695f4f 	cdpvs	15, 6, cr5, cr9, cr15, {2}
 7f0:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
 7f4:	2f747075 	svccs	0x00747075
 7f8:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 7fc:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 800:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 804:	622f6564 	eorvs	r6, pc, #100, 10	; 0x19000000
 808:	6472616f 	ldrbtvs	r6, [r2], #-367	; 0xfffffe91
 80c:	6970722f 	ldmdbvs	r0!, {r0, r1, r2, r3, r5, r9, ip, sp, lr}^
 810:	61682f30 	cmnvs	r8, r0, lsr pc
 814:	682f006c 	stmdavs	pc!, {r2, r3, r5, r6}	; <UNPREDICTABLE>
 818:	2f656d6f 	svccs	0x00656d6f
 81c:	686c6973 	stmdavs	ip!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
 820:	6a797661 	bvs	1e5e1ac <_bss_end+0x1e552c8>
 824:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
 828:	2f6c6f6f 	svccs	0x006c6f6f
 82c:	6f72655a 	svcvs	0x0072655a
 830:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
 834:	6178652f 	cmnvs	r8, pc, lsr #10
 838:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
 83c:	39302f73 	ldmdbcc	r0!, {r0, r1, r4, r5, r6, r8, r9, sl, fp, sp}
 840:	4950472d 	ldmdbmi	r0, {r0, r2, r3, r5, r8, r9, sl, lr}^
 844:	6e695f4f 	cdpvs	15, 6, cr5, cr9, cr15, {2}
 848:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
 84c:	2f747075 	svccs	0x00747075
 850:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 854:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 858:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 85c:	642f6564 	strtvs	r6, [pc], #-1380	; 864 <CPSR_IRQ_INHIBIT+0x7e4>
 860:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
 864:	2f007372 	svccs	0x00007372
 868:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
 86c:	6c69732f 	stclvs	3, cr7, [r9], #-188	; 0xffffff44
 870:	79766168 	ldmdbvc	r6!, {r3, r5, r6, r8, sp, lr}^
 874:	63532f6a 	cmpvs	r3, #424	; 0x1a8
 878:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; 6e0 <CPSR_IRQ_INHIBIT+0x660>
 87c:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
 880:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
 884:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 888:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
 88c:	302f7365 	eorcc	r7, pc, r5, ror #6
 890:	50472d39 	subpl	r2, r7, r9, lsr sp
 894:	695f4f49 	ldmdbvs	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
 898:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
 89c:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
 8a0:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 8a4:	2f6c656e 	svccs	0x006c656e
 8a8:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 8ac:	00656475 	rsbeq	r6, r5, r5, ror r4
 8b0:	69616d00 	stmdbvs	r1!, {r8, sl, fp, sp, lr}^
 8b4:	70632e6e 	rsbvc	r2, r3, lr, ror #28
 8b8:	00010070 	andeq	r0, r1, r0, ror r0
 8bc:	746e6900 	strbtvc	r6, [lr], #-2304	; 0xfffff700
 8c0:	2e666564 	cdpcs	5, 6, cr6, cr6, cr4, {3}
 8c4:	00020068 	andeq	r0, r2, r8, rrx
 8c8:	69706700 	ldmdbvs	r0!, {r8, r9, sl, sp, lr}^
 8cc:	00682e6f 	rsbeq	r2, r8, pc, ror #28
 8d0:	70000003 	andvc	r0, r0, r3
 8d4:	70697265 	rsbvc	r7, r9, r5, ror #4
 8d8:	61726568 	cmnvs	r2, r8, ror #10
 8dc:	682e736c 	stmdavs	lr!, {r2, r3, r5, r6, r8, r9, ip, sp, lr}
 8e0:	00000200 	andeq	r0, r0, r0, lsl #4
 8e4:	65746e69 	ldrbvs	r6, [r4, #-3689]!	; 0xfffff197
 8e8:	70757272 	rsbsvc	r7, r5, r2, ror r2
 8ec:	6f635f74 	svcvs	0x00635f74
 8f0:	6f72746e 	svcvs	0x0072746e
 8f4:	72656c6c 	rsbvc	r6, r5, #108, 24	; 0x6c00
 8f8:	0400682e 	streq	r6, [r0], #-2094	; 0xfffff7d2
 8fc:	05000000 	streq	r0, [r0, #-0]
 900:	02050001 	andeq	r0, r5, #1
 904:	00008c60 	andeq	r8, r0, r0, ror #24
 908:	4b1c0516 	blmi	701d68 <_bss_end+0x6f8e84>
 90c:	841e0583 	ldrhi	r0, [lr], #-1411	; 0xfffffa7d
 910:	841d0583 	ldrhi	r0, [sp], #-1411	; 0xfffffa7d
 914:	05680f05 	strbeq	r0, [r8, #-3845]!	; 0xfffff0fb
 918:	04020005 	streq	r0, [r2], #-5
 91c:	06023001 	streq	r3, [r2], -r1
 920:	ae010100 	adfges	f0, f1, f0
 924:	03000000 	movweq	r0, #0
 928:	00006300 	andeq	r6, r0, r0, lsl #6
 92c:	fb010200 	blx	41136 <_bss_end+0x38252>
 930:	01000d0e 	tsteq	r0, lr, lsl #26
 934:	00010101 	andeq	r0, r1, r1, lsl #2
 938:	00010000 	andeq	r0, r1, r0
 93c:	682f0100 	stmdavs	pc!, {r8}	; <UNPREDICTABLE>
 940:	2f656d6f 	svccs	0x00656d6f
 944:	686c6973 	stmdavs	ip!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
 948:	6a797661 	bvs	1e5e2d4 <_bss_end+0x1e553f0>
 94c:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
 950:	2f6c6f6f 	svccs	0x006c6f6f
 954:	6f72655a 	svcvs	0x0072655a
 958:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
 95c:	6178652f 	cmnvs	r8, pc, lsr #10
 960:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
 964:	39302f73 	ldmdbcc	r0!, {r0, r1, r4, r5, r6, r8, r9, sl, fp, sp}
 968:	4950472d 	ldmdbmi	r0, {r0, r2, r3, r5, r8, r9, sl, lr}^
 96c:	6e695f4f 	cdpvs	15, 6, cr5, cr9, cr15, {2}
 970:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
 974:	2f747075 	svccs	0x00747075
 978:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 97c:	732f6c65 			; <UNDEFINED> instruction: 0x732f6c65
 980:	00006372 	andeq	r6, r0, r2, ror r3
 984:	72617473 	rsbvc	r7, r1, #1929379840	; 0x73000000
 988:	00732e74 	rsbseq	r2, r3, r4, ror lr
 98c:	00000001 	andeq	r0, r0, r1
 990:	00020500 	andeq	r0, r2, r0, lsl #10
 994:	03000080 	movweq	r0, #128	; 0x80
 998:	2f2f010d 	svccs	0x002f010d
 99c:	2f2f2f2f 	svccs	0x002f2f2f
 9a0:	081d032f 	ldmdaeq	sp, {r0, r1, r2, r3, r5, r8, r9}
 9a4:	322f3120 	eorcc	r3, pc, #32, 2
 9a8:	312f2f2f 			; <UNDEFINED> instruction: 0x312f2f2f
 9ac:	2f312f2f 	svccs	0x00312f2f
 9b0:	2f2f312f 	svccs	0x002f312f
 9b4:	2f2f2f30 	svccs	0x002f2f30
 9b8:	00020230 	andeq	r0, r2, r0, lsr r2
 9bc:	05000101 	streq	r0, [r0, #-257]	; 0xfffffeff
 9c0:	008cc402 	addeq	ip, ip, r2, lsl #8
 9c4:	00d90300 	sbcseq	r0, r9, r0, lsl #6
 9c8:	2f2f2f01 	svccs	0x002f2f01
 9cc:	3333312f 	teqcc	r3, #-1073741813	; 0xc000000b
 9d0:	01000202 	tsteq	r0, r2, lsl #4
 9d4:	0000e801 	andeq	lr, r0, r1, lsl #16
 9d8:	67000300 	strvs	r0, [r0, -r0, lsl #6]
 9dc:	02000000 	andeq	r0, r0, #0
 9e0:	0d0efb01 	vstreq	d15, [lr, #-4]
 9e4:	01010100 	mrseq	r0, (UNDEF: 17)
 9e8:	00000001 	andeq	r0, r0, r1
 9ec:	01000001 	tsteq	r0, r1
 9f0:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 93c <CPSR_IRQ_INHIBIT+0x8bc>
 9f4:	69732f65 	ldmdbvs	r3!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 9f8:	7661686c 	strbtvc	r6, [r1], -ip, ror #16
 9fc:	532f6a79 			; <UNDEFINED> instruction: 0x532f6a79
 a00:	6f6f6863 	svcvs	0x006f6863
 a04:	655a2f6c 	ldrbvs	r2, [sl, #-3948]	; 0xfffff094
 a08:	614d6f72 	hvcvs	55026	; 0xd6f2
 a0c:	652f6574 	strvs	r6, [pc, #-1396]!	; 4a0 <CPSR_IRQ_INHIBIT+0x420>
 a10:	706d6178 	rsbvc	r6, sp, r8, ror r1
 a14:	2f73656c 	svccs	0x0073656c
 a18:	472d3930 			; <UNDEFINED> instruction: 0x472d3930
 a1c:	5f4f4950 	svcpl	0x004f4950
 a20:	65746e69 	ldrbvs	r6, [r4, #-3689]!	; 0xfffff197
 a24:	70757272 	rsbsvc	r7, r5, r2, ror r2
 a28:	656b2f74 	strbvs	r2, [fp, #-3956]!	; 0xfffff08c
 a2c:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
 a30:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
 a34:	74730000 	ldrbtvc	r0, [r3], #-0
 a38:	75747261 	ldrbvc	r7, [r4, #-609]!	; 0xfffffd9f
 a3c:	70632e70 	rsbvc	r2, r3, r0, ror lr
 a40:	00010070 	andeq	r0, r1, r0, ror r0
 a44:	01050000 	mrseq	r0, (UNDEF: 5)
 a48:	e4020500 	str	r0, [r2], #-1280	; 0xfffffb00
 a4c:	0300008c 	movweq	r0, #140	; 0x8c
 a50:	0c050114 	stfeqs	f0, [r5], {20}
 a54:	0022056a 	eoreq	r0, r2, sl, ror #10
 a58:	66030402 	strvs	r0, [r3], -r2, lsl #8
 a5c:	02000c05 	andeq	r0, r0, #1280	; 0x500
 a60:	05bb0204 	ldreq	r0, [fp, #516]!	; 0x204
 a64:	04020005 	streq	r0, [r2], #-5
 a68:	0c056502 	cfstr32eq	mvfx6, [r5], {2}
 a6c:	2f010585 	svccs	0x00010585
 a70:	6b1005bd 	blvs	40216c <_bss_end+0x3f9288>
 a74:	02002705 	andeq	r2, r0, #1310720	; 0x140000
 a78:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
 a7c:	0402000a 	streq	r0, [r2], #-10
 a80:	11058302 	tstne	r5, r2, lsl #6
 a84:	02040200 	andeq	r0, r4, #0, 4
 a88:	0005054a 	andeq	r0, r5, sl, asr #10
 a8c:	2d020402 	cfstrscs	mvf0, [r2, #-8]
 a90:	05850c05 	streq	r0, [r5, #3077]	; 0xc05
 a94:	05a12f01 	streq	r2, [r1, #3841]!	; 0xf01
 a98:	27056a10 	smladcs	r5, r0, sl, r6
 a9c:	03040200 	movweq	r0, #16896	; 0x4200
 aa0:	000a054a 	andeq	r0, sl, sl, asr #10
 aa4:	83020402 	movwhi	r0, #9218	; 0x2402
 aa8:	02001105 	andeq	r1, r0, #1073741825	; 0x40000001
 aac:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 ab0:	04020005 	streq	r0, [r2], #-5
 ab4:	0c052d02 	stceq	13, cr2, [r5], {2}
 ab8:	2f010585 	svccs	0x00010585
 abc:	01000a02 	tsteq	r0, r2, lsl #20
 ac0:	00010301 	andeq	r0, r1, r1, lsl #6
 ac4:	fd000300 	stc2	3, cr0, [r0, #-0]
 ac8:	02000000 	andeq	r0, r0, #0
 acc:	0d0efb01 	vstreq	d15, [lr, #-4]
 ad0:	01010100 	mrseq	r0, (UNDEF: 17)
 ad4:	00000001 	andeq	r0, r0, r1
 ad8:	01000001 	tsteq	r0, r1
 adc:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 ae0:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 ae4:	2f2e2e2f 	svccs	0x002e2e2f
 ae8:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 aec:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
 af0:	63636762 	cmnvs	r3, #25690112	; 0x1880000
 af4:	2f2e2e2f 	svccs	0x002e2e2f
 af8:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 afc:	00656475 	rsbeq	r6, r5, r5, ror r4
 b00:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 b04:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 b08:	2f2e2e2f 	svccs	0x002e2e2f
 b0c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 b10:	6363672f 	cmnvs	r3, #12320768	; 0xbc0000
 b14:	2f2e2e00 	svccs	0x002e2e00
 b18:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 b1c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 b20:	2f2e2e2f 	svccs	0x002e2e2f
 b24:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; a74 <CPSR_IRQ_INHIBIT+0x9f4>
 b28:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
 b2c:	2e2e2f63 	cdpcs	15, 2, cr2, cr14, cr3, {3}
 b30:	6363672f 	cmnvs	r3, #12320768	; 0xbc0000
 b34:	6e6f632f 	cdpvs	3, 6, cr6, cr15, cr15, {1}
 b38:	2f676966 	svccs	0x00676966
 b3c:	006d7261 	rsbeq	r7, sp, r1, ror #4
 b40:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 b44:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 b48:	2f2e2e2f 	svccs	0x002e2e2f
 b4c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 b50:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
 b54:	63636762 	cmnvs	r3, #25690112	; 0x1880000
 b58:	61680000 	cmnvs	r8, r0
 b5c:	61746873 	cmnvs	r4, r3, ror r8
 b60:	00682e62 	rsbeq	r2, r8, r2, ror #28
 b64:	61000001 	tstvs	r0, r1
 b68:	692d6d72 	pushvs	{r1, r4, r5, r6, r8, sl, fp, sp, lr}
 b6c:	682e6173 	stmdavs	lr!, {r0, r1, r4, r5, r6, r8, sp, lr}
 b70:	00000200 	andeq	r0, r0, r0, lsl #4
 b74:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
 b78:	2e757063 	cdpcs	0, 7, cr7, cr5, cr3, {3}
 b7c:	00020068 	andeq	r0, r2, r8, rrx
 b80:	736e6900 	cmnvc	lr, #0, 18
 b84:	6f632d6e 	svcvs	0x00632d6e
 b88:	6174736e 	cmnvs	r4, lr, ror #6
 b8c:	2e73746e 	cdpcs	4, 7, cr7, cr3, cr14, {3}
 b90:	00020068 	andeq	r0, r2, r8, rrx
 b94:	6d726100 	ldfvse	f6, [r2, #-0]
 b98:	0300682e 	movweq	r6, #2094	; 0x82e
 b9c:	696c0000 	stmdbvs	ip!, {}^	; <UNPREDICTABLE>
 ba0:	63636762 	cmnvs	r3, #25690112	; 0x1880000
 ba4:	00682e32 	rsbeq	r2, r8, r2, lsr lr
 ba8:	67000004 	strvs	r0, [r0, -r4]
 bac:	632d6c62 			; <UNDEFINED> instruction: 0x632d6c62
 bb0:	73726f74 	cmnvc	r2, #116, 30	; 0x1d0
 bb4:	0400682e 	streq	r6, [r0], #-2094	; 0xfffff7d2
 bb8:	696c0000 	stmdbvs	ip!, {}^	; <UNPREDICTABLE>
 bbc:	63636762 	cmnvs	r3, #25690112	; 0x1880000
 bc0:	00632e32 	rsbeq	r2, r3, r2, lsr lr
 bc4:	00000004 	andeq	r0, r0, r4

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
      20:	5b202965 	blpl	80a5bc <_bss_end+0x8016d8>
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
      88:	7a6a3637 	bvc	1a8d96c <_bss_end+0x1a84a88>
      8c:	20732d66 	rsbscs	r2, r3, r6, ror #26
      90:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
      94:	6d2d206d 	stcvs	0, cr2, [sp, #-436]!	; 0xfffffe4c
      98:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
      9c:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
      a0:	6b7a3676 	blvs	1e8da80 <_bss_end+0x1e84b9c>
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
      d4:	6a797661 	bvs	1e5da60 <_bss_end+0x1e54b7c>
      d8:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
      dc:	2f6c6f6f 	svccs	0x006c6f6f
      e0:	6f72655a 	svcvs	0x0072655a
      e4:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
      e8:	6178652f 	cmnvs	r8, pc, lsr #10
      ec:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
      f0:	39302f73 	ldmdbcc	r0!, {r0, r1, r4, r5, r6, r8, r9, sl, fp, sp}
      f4:	4950472d 	ldmdbmi	r0, {r0, r2, r3, r5, r8, r9, sl, lr}^
      f8:	6e695f4f 	cdpvs	15, 6, cr5, cr9, cr15, {2}
      fc:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
     100:	2f747075 	svccs	0x00747075
     104:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
     108:	732f6c65 			; <UNDEFINED> instruction: 0x732f6c65
     10c:	632f6372 			; <UNDEFINED> instruction: 0x632f6372
     110:	632e7878 			; <UNDEFINED> instruction: 0x632e7878
     114:	5f007070 	svcpl	0x00007070
     118:	6178635f 	cmnvs	r8, pc, asr r3
     11c:	6175675f 	cmnvs	r5, pc, asr r7
     120:	615f6472 	cmpvs	pc, r2, ror r4	; <UNPREDICTABLE>
     124:	74726f62 	ldrbtvc	r6, [r2], #-3938	; 0xfffff09e
     128:	645f5f00 	ldrbvs	r5, [pc], #-3840	; 130 <CPSR_IRQ_INHIBIT+0xb0>
     12c:	685f6f73 	ldmdavs	pc, {r0, r1, r4, r5, r6, r8, r9, sl, fp, sp, lr}^	; <UNPREDICTABLE>
     130:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     134:	5f5f0065 	svcpl	0x005f0065
     138:	5f617863 	svcpl	0x00617863
     13c:	78657461 	stmdavc	r5!, {r0, r5, r6, sl, ip, sp, lr}^
     140:	5f007469 	svcpl	0x00007469
     144:	6178635f 	cmnvs	r8, pc, asr r3
     148:	6175675f 	cmnvs	r5, pc, asr r7
     14c:	615f6472 	cmpvs	pc, r2, ror r4	; <UNPREDICTABLE>
     150:	69757163 	ldmdbvs	r5!, {r0, r1, r5, r6, r8, ip, sp, lr}^
     154:	5f006572 	svcpl	0x00006572
     158:	7878635f 	ldmdavc	r8!, {r0, r1, r2, r3, r4, r6, r8, r9, sp, lr}^
     15c:	76696261 	strbtvc	r6, [r9], -r1, ror #4
     160:	5f5f0031 	svcpl	0x005f0031
     164:	5f617863 	svcpl	0x00617863
     168:	65727570 	ldrbvs	r7, [r2, #-1392]!	; 0xfffffa90
     16c:	7269765f 	rsbvc	r7, r9, #99614720	; 0x5f00000
     170:	6c617574 	cfstr64vs	mvdx7, [r1], #-464	; 0xfffffe30
     174:	6f682f00 	svcvs	0x00682f00
     178:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
     17c:	61686c69 	cmnvs	r8, r9, ror #24
     180:	2f6a7976 	svccs	0x006a7976
     184:	6f686353 	svcvs	0x00686353
     188:	5a2f6c6f 	bpl	bdb34c <_bss_end+0xbd2468>
     18c:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 0 <CPSR_MODE_FIQ-0x11>
     190:	2f657461 	svccs	0x00657461
     194:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
     198:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
     19c:	2d39302f 	ldccs	0, cr3, [r9, #-188]!	; 0xffffff44
     1a0:	4f495047 	svcmi	0x00495047
     1a4:	746e695f 	strbtvc	r6, [lr], #-2399	; 0xfffff6a1
     1a8:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
     1ac:	622f7470 	eorvs	r7, pc, #112, 8	; 0x70000000
     1b0:	646c6975 	strbtvs	r6, [ip], #-2421	; 0xfffff68b
     1b4:	615f5f00 	cmpvs	pc, r0, lsl #30
     1b8:	69626165 	stmdbvs	r2!, {r0, r2, r5, r6, r8, sp, lr}^
     1bc:	776e755f 			; <UNDEFINED> instruction: 0x776e755f
     1c0:	5f646e69 	svcpl	0x00646e69
     1c4:	5f707063 	svcpl	0x00707063
     1c8:	00317270 	eorseq	r7, r1, r0, ror r2
     1cc:	75675f5f 	strbvc	r5, [r7, #-3935]!	; 0xfffff0a1
     1d0:	00647261 	rsbeq	r7, r4, r1, ror #4
     1d4:	676e6f6c 	strbvs	r6, [lr, -ip, ror #30]!
     1d8:	6e6f6c20 	cdpvs	12, 6, cr6, cr15, cr0, {1}
     1dc:	6e692067 	cdpvs	0, 6, cr2, cr9, cr7, {3}
     1e0:	5a5f0074 	bpl	17c03b8 <_bss_end+0x17b74d4>
     1e4:	33314b4e 	teqcc	r1, #79872	; 0x13800
     1e8:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     1ec:	61485f4f 	cmpvs	r8, pc, asr #30
     1f0:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     1f4:	47383172 			; <UNDEFINED> instruction: 0x47383172
     1f8:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     1fc:	56454c50 			; <UNDEFINED> instruction: 0x56454c50
     200:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     204:	6f697461 	svcvs	0x00697461
     208:	526a456e 	rsbpl	r4, sl, #461373440	; 0x1b800000
     20c:	5f30536a 	svcpl	0x0030536a
     210:	53504700 	cmppl	r0, #0, 14
     214:	00305445 	eorseq	r5, r0, r5, asr #8
     218:	45535047 	ldrbmi	r5, [r3, #-71]	; 0xffffffb9
     21c:	47003154 	smlsdmi	r0, r4, r1, r3
     220:	45534650 	ldrbmi	r4, [r3, #-1616]	; 0xfffff9b0
     224:	4700304c 	strmi	r3, [r0, -ip, asr #32]
     228:	45534650 	ldrbmi	r4, [r3, #-1616]	; 0xfffff9b0
     22c:	4700314c 	strmi	r3, [r0, -ip, asr #2]
     230:	45534650 	ldrbmi	r4, [r3, #-1616]	; 0xfffff9b0
     234:	4700324c 	strmi	r3, [r0, -ip, asr #4]
     238:	45534650 	ldrbmi	r4, [r3, #-1616]	; 0xfffff9b0
     23c:	4700334c 	strmi	r3, [r0, -ip, asr #6]
     240:	45534650 	ldrbmi	r4, [r3, #-1616]	; 0xfffff9b0
     244:	4700344c 	strmi	r3, [r0, -ip, asr #8]
     248:	45534650 	ldrbmi	r4, [r3, #-1616]	; 0xfffff9b0
     24c:	4700354c 	strmi	r3, [r0, -ip, asr #10]
     250:	4e454650 	mcrmi	6, 2, r4, cr5, cr0, {2}
     254:	6e490031 	mcrvs	0, 2, r0, cr9, cr1, {1}
     258:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
     25c:	5f747075 	svcpl	0x00747075
     260:	746e6f43 	strbtvc	r6, [lr], #-3907	; 0xfffff0bd
     264:	6c6c6f72 	stclvs	15, cr6, [ip], #-456	; 0xfffffe38
     268:	425f7265 	subsmi	r7, pc, #1342177286	; 0x50000006
     26c:	00657361 	rsbeq	r7, r5, r1, ror #6
     270:	5f746547 	svcpl	0x00746547
     274:	495f5047 	ldmdbmi	pc, {r0, r1, r2, r6, ip, lr}^	; <UNPREDICTABLE>
     278:	445f5152 	ldrbmi	r5, [pc], #-338	; 280 <CPSR_IRQ_INHIBIT+0x200>
     27c:	63657465 	cmnvs	r5, #1694498816	; 0x65000000
     280:	6f4c5f74 	svcvs	0x004c5f74
     284:	69746163 	ldmdbvs	r4!, {r0, r1, r5, r6, r8, sp, lr}^
     288:	47006e6f 	strmi	r6, [r0, -pc, ror #28]
     28c:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     290:	53444550 	movtpl	r4, #17744	; 0x4550
     294:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     298:	6f697461 	svcvs	0x00697461
     29c:	6948006e 	stmdbvs	r8, {r1, r2, r3, r5, r6}^
     2a0:	73006867 	movwvc	r6, #2151	; 0x867
     2a4:	74726f68 	ldrbtvc	r6, [r2], #-3944	; 0xfffff098
     2a8:	746e6920 	strbtvc	r6, [lr], #-2336	; 0xfffff6e0
     2ac:	50504700 	subspl	r4, r0, r0, lsl #14
     2b0:	4c434455 	cfstrdmi	mvd4, [r3], {85}	; 0x55
     2b4:	4700304b 	strmi	r3, [r0, -fp, asr #32]
     2b8:	44555050 	ldrbmi	r5, [r5], #-80	; 0xffffffb0
     2bc:	314b4c43 	cmpcc	fp, r3, asr #24
     2c0:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     2c4:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     2c8:	5f4f4950 	svcpl	0x004f4950
     2cc:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     2d0:	3172656c 	cmncc	r2, ip, ror #10
     2d4:	616e4539 	cmnvs	lr, r9, lsr r5
     2d8:	5f656c62 	svcpl	0x00656c62
     2dc:	6e657645 	cdpvs	6, 6, cr7, cr5, cr5, {2}
     2e0:	65445f74 	strbvs	r5, [r4, #-3956]	; 0xfffff08c
     2e4:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
     2e8:	30326a45 	eorscc	r6, r2, r5, asr #20
     2ec:	4950474e 	ldmdbmi	r0, {r1, r2, r3, r6, r8, r9, sl, lr}^
     2f0:	6e495f4f 	cdpvs	15, 4, cr5, cr9, cr15, {2}
     2f4:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
     2f8:	5f747075 	svcpl	0x00747075
     2fc:	65707954 	ldrbvs	r7, [r0, #-2388]!	; 0xfffff6ac
     300:	52504700 	subspl	r4, r0, #0, 14
     304:	00304e45 	eorseq	r4, r0, r5, asr #28
     308:	45525047 	ldrbmi	r5, [r2, #-71]	; 0xffffffb9
     30c:	5f00314e 	svcpl	0x0000314e
     310:	33314e5a 	teqcc	r1, #1440	; 0x5a0
     314:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     318:	61485f4f 	cmpvs	r8, pc, asr #30
     31c:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     320:	53303172 	teqpl	r0, #-2147483620	; 0x8000001c
     324:	4f5f7465 	svcmi	0x005f7465
     328:	75707475 	ldrbvc	r7, [r0, #-1141]!	; 0xfffffb8b
     32c:	626a4574 	rsbvs	r4, sl, #116, 10	; 0x1d000000
     330:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     334:	4333314b 	teqmi	r3, #-1073741806	; 0xc0000012
     338:	4f495047 	svcmi	0x00495047
     33c:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     340:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     344:	65473931 	strbvs	r3, [r7, #-2353]	; 0xfffff6cf
     348:	50475f74 	subpl	r5, r7, r4, ror pc
     34c:	4c455346 	mcrrmi	3, 4, r5, r5, cr6
     350:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     354:	6f697461 	svcvs	0x00697461
     358:	526a456e 	rsbpl	r4, sl, #461373440	; 0x1b800000
     35c:	5f30536a 	svcpl	0x0030536a
     360:	50476d00 	subpl	r6, r7, r0, lsl #26
     364:	5f004f49 	svcpl	0x00004f49
     368:	33314e5a 	teqcc	r1, #1440	; 0x5a0
     36c:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     370:	61485f4f 	cmpvs	r8, pc, asr #30
     374:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     378:	45344372 	ldrmi	r4, [r4, #-882]!	; 0xfffffc8e
     37c:	6975006a 	ldmdbvs	r5!, {r1, r3, r5, r6}^
     380:	5f38746e 	svcpl	0x0038746e
     384:	50470074 	subpl	r0, r7, r4, ror r0
     388:	30534445 	subscc	r4, r3, r5, asr #8
     38c:	45504700 	ldrbmi	r4, [r0, #-1792]	; 0xfffff900
     390:	00315344 	eorseq	r5, r1, r4, asr #6
     394:	746e6975 	strbtvc	r6, [lr], #-2421	; 0xfffff68b
     398:	745f3233 	ldrbvc	r3, [pc], #-563	; 3a0 <CPSR_IRQ_INHIBIT+0x320>
     39c:	6f682f00 	svcvs	0x00682f00
     3a0:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
     3a4:	61686c69 	cmnvs	r8, r9, ror #24
     3a8:	2f6a7976 	svccs	0x006a7976
     3ac:	6f686353 	svcvs	0x00686353
     3b0:	5a2f6c6f 	bpl	bdb574 <_bss_end+0xbd2690>
     3b4:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 228 <CPSR_IRQ_INHIBIT+0x1a8>
     3b8:	2f657461 	svccs	0x00657461
     3bc:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
     3c0:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
     3c4:	2d39302f 	ldccs	0, cr3, [r9, #-188]!	; 0xffffff44
     3c8:	4f495047 	svcmi	0x00495047
     3cc:	746e695f 	strbtvc	r6, [lr], #-2399	; 0xfffff6a1
     3d0:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
     3d4:	6b2f7470 	blvs	bdd59c <_bss_end+0xbd46b8>
     3d8:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
     3dc:	72732f6c 	rsbsvc	r2, r3, #108, 30	; 0x1b0
     3e0:	72642f63 	rsbvc	r2, r4, #396	; 0x18c
     3e4:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
     3e8:	70672f73 	rsbvc	r2, r7, r3, ror pc
     3ec:	632e6f69 			; <UNDEFINED> instruction: 0x632e6f69
     3f0:	62007070 	andvs	r7, r0, #112	; 0x70
     3f4:	006c6f6f 	rsbeq	r6, ip, pc, ror #30
     3f8:	70736e55 	rsbsvc	r6, r3, r5, asr lr
     3fc:	66696365 	strbtvs	r6, [r9], -r5, ror #6
     400:	00646569 	rsbeq	r6, r4, r9, ror #10
     404:	61656c43 	cmnvs	r5, r3, asr #24
     408:	65445f72 	strbvs	r5, [r4, #-3954]	; 0xfffff08e
     40c:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
     410:	455f6465 	ldrbmi	r6, [pc, #-1125]	; ffffffb3 <_bss_end+0xffff70cf>
     414:	746e6576 	strbtvc	r6, [lr], #-1398	; 0xfffffa8a
     418:	4c504700 	mrrcmi	7, 0, r4, r0, cr0
     41c:	00304e45 	eorseq	r4, r0, r5, asr #28
     420:	4b4e5a5f 	blmi	1396da4 <_bss_end+0x138dec0>
     424:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     428:	5f4f4950 	svcpl	0x004f4950
     42c:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     430:	3272656c 	rsbscc	r6, r2, #108, 10	; 0x1b000000
     434:	74654736 	strbtvc	r4, [r5], #-1846	; 0xfffff8ca
     438:	5f50475f 	svcpl	0x0050475f
     43c:	5f515249 	svcpl	0x00515249
     440:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
     444:	4c5f7463 	cfldrdmi	mvd7, [pc], {99}	; 0x63
     448:	7461636f 	strbtvc	r6, [r1], #-879	; 0xfffffc91
     44c:	456e6f69 	strbmi	r6, [lr, #-3945]!	; 0xfffff097
     450:	4e30326a 	cdpmi	2, 3, cr3, cr0, cr10, {3}
     454:	4f495047 	svcmi	0x00495047
     458:	746e495f 	strbtvc	r4, [lr], #-2399	; 0xfffff6a1
     45c:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
     460:	545f7470 	ldrbpl	r7, [pc], #-1136	; 468 <CPSR_IRQ_INHIBIT+0x3e8>
     464:	52657079 	rsbpl	r7, r5, #121	; 0x79
     468:	5f31536a 	svcpl	0x0031536a
     46c:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     470:	4950475f 	ldmdbmi	r0, {r0, r1, r2, r3, r4, r6, r8, r9, sl, lr}^
     474:	75465f4f 	strbvc	r5, [r6, #-3919]	; 0xfffff0b1
     478:	6974636e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, r9, sp, lr}^
     47c:	43006e6f 	movwmi	r6, #3695	; 0xe6f
     480:	4f495047 	svcmi	0x00495047
     484:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     488:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     48c:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     490:	5350475f 	cmppl	r0, #24903680	; 0x17c0000
     494:	4c5f5445 	cfldrdmi	mvd5, [pc], {69}	; 0x45
     498:	7461636f 	strbtvc	r6, [r1], #-879	; 0xfffffc91
     49c:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     4a0:	55505047 	ldrbpl	r5, [r0, #-71]	; 0xffffffb9
     4a4:	5a5f0044 	bpl	17c05bc <_bss_end+0x17b76d8>
     4a8:	4333314e 	teqmi	r3, #-2147483629	; 0x80000013
     4ac:	4f495047 	svcmi	0x00495047
     4b0:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     4b4:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     4b8:	6c433032 	mcrrvs	0, 3, r3, r3, cr2
     4bc:	5f726165 	svcpl	0x00726165
     4c0:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
     4c4:	64657463 	strbtvs	r7, [r5], #-1123	; 0xfffffb9d
     4c8:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
     4cc:	6a45746e 	bvs	115d68c <_bss_end+0x11547a8>
     4d0:	72655000 	rsbvc	r5, r5, #0
     4d4:	65687069 	strbvs	r7, [r8, #-105]!	; 0xffffff97
     4d8:	5f6c6172 	svcpl	0x006c6172
     4dc:	65736142 	ldrbvs	r6, [r3, #-322]!	; 0xfffffebe
     4e0:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     4e4:	4c50475f 	mrrcmi	7, 5, r4, r0, cr15
     4e8:	4c5f5645 	mrrcmi	6, 4, r5, pc, cr5	; <UNPREDICTABLE>
     4ec:	7461636f 	strbtvc	r6, [r1], #-879	; 0xfffffc91
     4f0:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     4f4:	4b4e5a5f 	blmi	1396e78 <_bss_end+0x138df94>
     4f8:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     4fc:	5f4f4950 	svcpl	0x004f4950
     500:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     504:	3172656c 	cmncc	r2, ip, ror #10
     508:	74654737 	strbtvc	r4, [r5], #-1847	; 0xfffff8c9
     50c:	4950475f 	ldmdbmi	r0, {r0, r1, r2, r3, r4, r6, r8, r9, sl, lr}^
     510:	75465f4f 	strbvc	r5, [r6, #-3919]	; 0xfffff0b1
     514:	6974636e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, r9, sp, lr}^
     518:	6a456e6f 	bvs	115bedc <_bss_end+0x1152ff8>
     51c:	695f5f00 	ldmdbvs	pc, {r8, r9, sl, fp, ip, lr}^	; <UNPREDICTABLE>
     520:	6974696e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, fp, sp, lr}^
     524:	7a696c61 	bvc	1a5b6b0 <_bss_end+0x1a527cc>
     528:	00705f65 	rsbseq	r5, r0, r5, ror #30
     52c:	314e5a5f 	cmpcc	lr, pc, asr sl
     530:	50474333 	subpl	r4, r7, r3, lsr r3
     534:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     538:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     53c:	32437265 	subcc	r7, r3, #1342177286	; 0x50000006
     540:	47006a45 	strmi	r6, [r0, -r5, asr #20]
     544:	45464150 	strbmi	r4, [r6, #-336]	; 0xfffffeb0
     548:	4700304e 	strmi	r3, [r0, -lr, asr #32]
     54c:	45464150 	strbmi	r4, [r6, #-336]	; 0xfffffeb0
     550:	5f00314e 	svcpl	0x0000314e
     554:	314b4e5a 	cmpcc	fp, sl, asr lr
     558:	50474333 	subpl	r4, r7, r3, lsr r3
     55c:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     560:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     564:	38317265 	ldmdacc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     568:	5f746547 	svcpl	0x00746547
     56c:	4c435047 	mcrrmi	0, 4, r5, r3, cr7
     570:	6f4c5f52 	svcvs	0x004c5f52
     574:	69746163 	ldmdbvs	r4!, {r0, r1, r5, r6, r8, sp, lr}^
     578:	6a456e6f 	bvs	115bf3c <_bss_end+0x1153058>
     57c:	30536a52 	subscc	r6, r3, r2, asr sl
     580:	6e75005f 	mrcvs	0, 3, r0, cr5, cr15, {2}
     584:	6e676973 			; <UNDEFINED> instruction: 0x6e676973
     588:	63206465 			; <UNDEFINED> instruction: 0x63206465
     58c:	00726168 	rsbseq	r6, r2, r8, ror #2
     590:	4f4c475f 	svcmi	0x004c475f
     594:	5f4c4142 	svcpl	0x004c4142
     598:	6275735f 	rsbsvs	r7, r5, #2080374785	; 0x7c000001
     59c:	735f495f 	cmpvc	pc, #1556480	; 0x17c000
     5a0:	4f495047 	svcmi	0x00495047
     5a4:	49504700 	ldmdbmi	r0, {r8, r9, sl, lr}^
     5a8:	61425f4f 	cmpvs	r2, pc, asr #30
     5ac:	47006573 	smlsdxmi	r0, r3, r5, r6
     5b0:	524c4350 	subpl	r4, ip, #80, 6	; 0x40000001
     5b4:	50470031 	subpl	r0, r7, r1, lsr r0
     5b8:	4e455241 	cdpmi	2, 4, cr5, cr5, cr1, {2}
     5bc:	50470030 	subpl	r0, r7, r0, lsr r0
     5c0:	4e455241 	cdpmi	2, 4, cr5, cr5, cr1, {2}
     5c4:	50470031 	subpl	r0, r7, r1, lsr r0
     5c8:	304e4548 	subcc	r4, lr, r8, asr #10
     5cc:	48504700 	ldmdami	r0, {r8, r9, sl, lr}^
     5d0:	00314e45 	eorseq	r4, r1, r5, asr #28
     5d4:	6f697067 	svcvs	0x00697067
     5d8:	7361625f 	cmnvc	r1, #-268435451	; 0xf0000005
     5dc:	64615f65 	strbtvs	r5, [r1], #-3941	; 0xfffff09b
     5e0:	73007264 	movwvc	r7, #612	; 0x264
     5e4:	74726f68 	ldrbtvc	r6, [r2], #-3944	; 0xfffff098
     5e8:	736e7520 	cmnvc	lr, #32, 10	; 0x8000000
     5ec:	656e6769 	strbvs	r6, [lr, #-1897]!	; 0xfffff897
     5f0:	6e692064 	cdpvs	0, 6, cr2, cr9, cr4, {3}
     5f4:	50470074 	subpl	r0, r7, r4, ror r0
     5f8:	314e454c 	cmpcc	lr, ip, asr #10
     5fc:	616e4500 	cmnvs	lr, r0, lsl #10
     600:	5f656c62 	svcpl	0x00656c62
     604:	6e657645 	cdpvs	6, 6, cr7, cr5, cr5, {2}
     608:	65445f74 	strbvs	r5, [r4, #-3956]	; 0xfffff08c
     60c:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
     610:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     614:	4333314b 	teqmi	r3, #-1073741806	; 0xc0000012
     618:	4f495047 	svcmi	0x00495047
     61c:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     620:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     624:	65473831 	strbvs	r3, [r7, #-2097]	; 0xfffff7cf
     628:	50475f74 	subpl	r5, r7, r4, ror pc
     62c:	5f534445 	svcpl	0x00534445
     630:	61636f4c 	cmnvs	r3, ip, asr #30
     634:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     638:	6a526a45 	bvs	149af54 <_bss_end+0x1492070>
     63c:	005f3053 	subseq	r3, pc, r3, asr r0	; <UNPREDICTABLE>
     640:	5f746547 	svcpl	0x00746547
     644:	53465047 	movtpl	r5, #24647	; 0x6047
     648:	4c5f4c45 	mrrcmi	12, 4, r4, pc, cr5	; <UNPREDICTABLE>
     64c:	7461636f 	strbtvc	r6, [r1], #-879	; 0xfffffc91
     650:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     654:	4f495047 	svcmi	0x00495047
     658:	6e69505f 	mcrvs	0, 3, r5, cr9, cr15, {2}
     65c:	756f435f 	strbvc	r4, [pc, #-863]!	; 305 <CPSR_IRQ_INHIBIT+0x285>
     660:	6600746e 	strvs	r7, [r0], -lr, ror #8
     664:	00636e75 	rsbeq	r6, r3, r5, ror lr
     668:	656d6954 	strbvs	r6, [sp, #-2388]!	; 0xfffff6ac
     66c:	61425f72 	hvcvs	9714	; 0x25f2
     670:	5f006573 	svcpl	0x00006573
     674:	6174735f 	cmnvs	r4, pc, asr r3
     678:	5f636974 	svcpl	0x00636974
     67c:	74696e69 	strbtvc	r6, [r9], #-3689	; 0xfffff197
     680:	696c6169 	stmdbvs	ip!, {r0, r3, r5, r6, r8, sp, lr}^
     684:	6974617a 	ldmdbvs	r4!, {r1, r3, r4, r5, r6, r8, sp, lr}^
     688:	615f6e6f 	cmpvs	pc, pc, ror #28
     68c:	645f646e 	ldrbvs	r6, [pc], #-1134	; 694 <CPSR_IRQ_INHIBIT+0x614>
     690:	72747365 	rsbsvc	r7, r4, #-1811939327	; 0x94000001
     694:	69746375 	ldmdbvs	r4!, {r0, r2, r4, r5, r6, r8, r9, sp, lr}^
     698:	305f6e6f 	subscc	r6, pc, pc, ror #28
     69c:	49504700 	ldmdbmi	r0, {r8, r9, sl, lr}^
     6a0:	65525f4f 	ldrbvs	r5, [r2, #-3919]	; 0xfffff0b1
     6a4:	68740067 	ldmdavs	r4!, {r0, r1, r2, r5, r6}^
     6a8:	5f007369 	svcpl	0x00007369
     6ac:	33314e5a 	teqcc	r1, #1440	; 0x5a0
     6b0:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     6b4:	61485f4f 	cmpvs	r8, pc, asr #30
     6b8:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     6bc:	44303272 	ldrtmi	r3, [r0], #-626	; 0xfffffd8e
     6c0:	62617369 	rsbvs	r7, r1, #-1543503871	; 0xa4000001
     6c4:	455f656c 	ldrbmi	r6, [pc, #-1388]	; 160 <CPSR_IRQ_INHIBIT+0xe0>
     6c8:	746e6576 	strbtvc	r6, [lr], #-1398	; 0xfffffa8a
     6cc:	7465445f 	strbtvc	r4, [r5], #-1119	; 0xfffffba1
     6d0:	45746365 	ldrbmi	r6, [r4, #-869]!	; 0xfffffc9b
     6d4:	4e30326a 	cdpmi	2, 3, cr3, cr0, cr10, {3}
     6d8:	4f495047 	svcmi	0x00495047
     6dc:	746e495f 	strbtvc	r4, [lr], #-2399	; 0xfffff6a1
     6e0:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
     6e4:	545f7470 	ldrbpl	r7, [pc], #-1136	; 6ec <CPSR_IRQ_INHIBIT+0x66c>
     6e8:	00657079 	rsbeq	r7, r5, r9, ror r0
     6ec:	314e5a5f 	cmpcc	lr, pc, asr sl
     6f0:	50474333 	subpl	r4, r7, r3, lsr r3
     6f4:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     6f8:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     6fc:	37317265 	ldrcc	r7, [r1, -r5, ror #4]!
     700:	5f746553 	svcpl	0x00746553
     704:	4f495047 	svcmi	0x00495047
     708:	6e75465f 	mrcvs	6, 3, r4, cr5, cr15, {2}
     70c:	6f697463 	svcvs	0x00697463
     710:	316a456e 	cmncc	sl, lr, ror #10
     714:	50474e34 	subpl	r4, r7, r4, lsr lr
     718:	465f4f49 	ldrbmi	r4, [pc], -r9, asr #30
     71c:	74636e75 	strbtvc	r6, [r3], #-3701	; 0xfffff18b
     720:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     724:	69736952 	ldmdbvs	r3!, {r1, r4, r6, r8, fp, sp, lr}^
     728:	455f676e 	ldrbmi	r6, [pc, #-1902]	; ffffffc2 <_bss_end+0xffff70de>
     72c:	00656764 	rsbeq	r6, r5, r4, ror #14
     730:	5f746c41 	svcpl	0x00746c41
     734:	50470032 	subpl	r0, r7, r2, lsr r0
     738:	3056454c 	subscc	r4, r6, ip, asr #10
     73c:	4c504700 	mrrcmi	7, 0, r4, r0, cr0
     740:	00315645 	eorseq	r5, r1, r5, asr #12
     744:	5f746553 	svcpl	0x00746553
     748:	4f495047 	svcmi	0x00495047
     74c:	6e75465f 	mrcvs	6, 3, r4, cr5, cr15, {2}
     750:	6f697463 	svcvs	0x00697463
     754:	6962006e 	stmdbvs	r2!, {r1, r2, r3, r5, r6}^
     758:	64695f74 	strbtvs	r5, [r9], #-3956	; 0xfffff08c
     75c:	5f5f0078 	svcpl	0x005f0078
     760:	6f697270 	svcvs	0x00697270
     764:	79746972 	ldmdbvc	r4!, {r1, r4, r5, r6, r8, fp, sp, lr}^
     768:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     76c:	4333314b 	teqmi	r3, #-1073741806	; 0xc0000012
     770:	4f495047 	svcmi	0x00495047
     774:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     778:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     77c:	65473831 	strbvs	r3, [r7, #-2097]	; 0xfffff7cf
     780:	50475f74 	subpl	r5, r7, r4, ror pc
     784:	5f544553 	svcpl	0x00544553
     788:	61636f4c 	cmnvs	r3, ip, asr #30
     78c:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     790:	6a526a45 	bvs	149b0ac <_bss_end+0x14921c8>
     794:	005f3053 	subseq	r3, pc, r3, asr r0	; <UNPREDICTABLE>
     798:	5f585541 	svcpl	0x00585541
     79c:	65736142 	ldrbvs	r6, [r3, #-322]!	; 0xfffffebe
     7a0:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     7a4:	4350475f 	cmpmi	r0, #24903680	; 0x17c0000
     7a8:	4c5f524c 	lfmmi	f5, 2, [pc], {76}	; 0x4c
     7ac:	7461636f 	strbtvc	r6, [r1], #-879	; 0xfffffc91
     7b0:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     7b4:	75706e49 	ldrbvc	r6, [r0, #-3657]!	; 0xfffff1b7
     7b8:	50470074 	subpl	r0, r7, r4, ror r0
     7bc:	304e4546 	subcc	r4, lr, r6, asr #10
     7c0:	74655300 	strbtvc	r5, [r5], #-768	; 0xfffffd00
     7c4:	74754f5f 	ldrbtvc	r4, [r5], #-3935	; 0xfffff0a1
     7c8:	00747570 	rsbseq	r7, r4, r0, ror r5
     7cc:	61736944 	cmnvs	r3, r4, asr #18
     7d0:	5f656c62 	svcpl	0x00656c62
     7d4:	6e657645 	cdpvs	6, 6, cr7, cr5, cr5, {2}
     7d8:	65445f74 	strbvs	r5, [r4, #-3956]	; 0xfffff08c
     7dc:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
     7e0:	6c614600 	stclvs	6, cr4, [r1], #-0
     7e4:	676e696c 	strbvs	r6, [lr, -ip, ror #18]!
     7e8:	6764455f 			; <UNDEFINED> instruction: 0x6764455f
     7ec:	6c410065 	mcrrvs	0, 6, r0, r1, cr5
     7f0:	00305f74 	eorseq	r5, r0, r4, ror pc
     7f4:	5f746c41 	svcpl	0x00746c41
     7f8:	65440031 	strbvs	r0, [r4, #-49]	; 0xffffffcf
     7fc:	6c756166 	ldfvse	f6, [r5], #-408	; 0xfffffe68
     800:	6c435f74 	mcrrvs	15, 7, r5, r3, cr4
     804:	5f6b636f 	svcpl	0x006b636f
     808:	65746152 	ldrbvs	r6, [r4, #-338]!	; 0xfffffeae
     80c:	746c4100 	strbtvc	r4, [ip], #-256	; 0xffffff00
     810:	4100335f 	tstmi	r0, pc, asr r3
     814:	345f746c 	ldrbcc	r7, [pc], #-1132	; 81c <CPSR_IRQ_INHIBIT+0x79c>
     818:	746c4100 	strbtvc	r4, [ip], #-256	; 0xffffff00
     81c:	4700355f 	smlsdmi	r0, pc, r5, r3	; <UNPREDICTABLE>
     820:	524c4350 	subpl	r4, ip, #80, 6	; 0x40000001
     824:	64690030 	strbtvs	r0, [r9], #-48	; 0xffffffd0
     828:	61625f78 	smcvs	9720	; 0x25f8
     82c:	5f006573 	svcpl	0x00006573
     830:	31324e5a 	teqcc	r2, sl, asr lr
     834:	746e4943 	strbtvc	r4, [lr], #-2371	; 0xfffff6bd
     838:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
     83c:	435f7470 	cmpmi	pc, #112, 8	; 0x70000000
     840:	72746e6f 	rsbsvc	r6, r4, #1776	; 0x6f0
     844:	656c6c6f 	strbvs	r6, [ip, #-3183]!	; 0xfffff391
     848:	65523472 	ldrbvs	r3, [r2, #-1138]	; 0xfffffb8e
     84c:	4e457367 	cdpmi	3, 4, cr7, cr5, cr7, {3}
     850:	6c616833 	stclvs	8, cr6, [r1], #-204	; 0xffffff34
     854:	6e493432 	mcrvs	4, 2, r3, cr9, cr2, {1}
     858:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
     85c:	5f747075 	svcpl	0x00747075
     860:	746e6f43 	strbtvc	r6, [lr], #-3907	; 0xfffff0bd
     864:	6c6c6f72 	stclvs	15, cr6, [ip], #-456	; 0xfffffe38
     868:	525f7265 	subspl	r7, pc, #1342177286	; 0x50000006
     86c:	00456765 	subeq	r6, r5, r5, ror #14
     870:	31555047 	cmpcc	r5, r7, asr #32
     874:	6c61485f 	stclvs	8, cr4, [r1], #-380	; 0xfffffe84
     878:	614d0074 	hvcvs	53252	; 0xd004
     87c:	6f626c69 	svcvs	0x00626c69
     880:	6e450078 	mcrvs	0, 2, r0, cr5, cr8, {3}
     884:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     888:	5152495f 	cmppl	r2, pc, asr r9
     88c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     890:	49433132 	stmdbmi	r3, {r1, r4, r5, r8, ip, sp}^
     894:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
     898:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
     89c:	6e6f435f 	mcrvs	3, 3, r4, cr15, cr15, {2}
     8a0:	6c6f7274 	sfmvs	f7, 2, [pc], #-464	; 6d8 <CPSR_IRQ_INHIBIT+0x658>
     8a4:	4372656c 	cmnmi	r2, #108, 10	; 0x1b000000
     8a8:	006d4532 	rsbeq	r4, sp, r2, lsr r5
     8ac:	5f515249 	svcpl	0x00515249
     8b0:	62616e45 	rsbvs	r6, r1, #1104	; 0x450
     8b4:	315f656c 	cmpcc	pc, ip, ror #10
     8b8:	51524900 	cmppl	r2, r0, lsl #18
     8bc:	616e455f 	cmnvs	lr, pc, asr r5
     8c0:	5f656c62 	svcpl	0x00656c62
     8c4:	41550032 	cmpmi	r5, r2, lsr r0
     8c8:	49005452 	stmdbmi	r0, {r1, r4, r6, sl, ip, lr}
     8cc:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
     8d0:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
     8d4:	6e6f435f 	mcrvs	3, 3, r4, cr15, cr15, {2}
     8d8:	6c6f7274 	sfmvs	f7, 2, [pc], #-464	; 710 <CPSR_IRQ_INHIBIT+0x690>
     8dc:	5f72656c 	svcpl	0x0072656c
     8e0:	00676552 	rsbeq	r6, r7, r2, asr r5
     8e4:	656c6c49 	strbvs	r6, [ip, #-3145]!	; 0xfffff3b7
     8e8:	5f6c6167 	svcpl	0x006c6167
     8ec:	65636341 	strbvs	r6, [r3, #-833]!	; 0xfffffcbf
     8f0:	315f7373 	cmpcc	pc, r3, ror r3	; <UNPREDICTABLE>
     8f4:	6c6c4900 			; <UNDEFINED> instruction: 0x6c6c4900
     8f8:	6c616765 	stclvs	7, cr6, [r1], #-404	; 0xfffffe6c
     8fc:	6363415f 	cmnvs	r3, #-1073741801	; 0xc0000017
     900:	5f737365 	svcpl	0x00737365
     904:	52490032 	subpl	r0, r9, #50	; 0x32
     908:	61425f51 	cmpvs	r2, r1, asr pc
     90c:	5f636973 	svcpl	0x00636973
     910:	72756f53 	rsbsvc	r6, r5, #332	; 0x14c
     914:	6d006563 	cfstr32vs	mvfx6, [r0, #-396]	; 0xfffffe74
     918:	65746e49 	ldrbvs	r6, [r4, #-3657]!	; 0xfffff1b7
     91c:	70757272 	rsbsvc	r7, r5, r2, ror r2
     920:	65525f74 	ldrbvs	r5, [r2, #-3956]	; 0xfffff08c
     924:	54007367 	strpl	r7, [r0], #-871	; 0xfffffc99
     928:	72656d69 	rsbvc	r6, r5, #6720	; 0x1a40
     92c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     930:	49433132 	stmdbmi	r3, {r1, r4, r5, r8, ip, sp}^
     934:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
     938:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
     93c:	6e6f435f 	mcrvs	3, 3, r4, cr15, cr15, {2}
     940:	6c6f7274 	sfmvs	f7, 2, [pc], #-464	; 778 <CPSR_IRQ_INHIBIT+0x6f8>
     944:	3172656c 	cmncc	r2, ip, ror #10
     948:	73694431 	cmnvc	r9, #822083584	; 0x31000000
     94c:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     950:	5152495f 	cmppl	r2, pc, asr r9
     954:	68334e45 	ldmdavs	r3!, {r0, r2, r6, r9, sl, fp, lr}
     958:	30316c61 	eorscc	r6, r1, r1, ror #24
     95c:	5f515249 	svcpl	0x00515249
     960:	72756f53 	rsbsvc	r6, r5, #332	; 0x14c
     964:	00456563 	subeq	r6, r5, r3, ror #10
     968:	74736166 	ldrbtvc	r6, [r3], #-358	; 0xfffffe9a
     96c:	746e695f 	strbtvc	r6, [lr], #-2399	; 0xfffff6a1
     970:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
     974:	685f7470 	ldmdavs	pc, {r4, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
     978:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     97c:	49007265 	stmdbmi	r0, {r0, r2, r5, r6, r9, ip, sp, lr}
     980:	425f5152 	subsmi	r5, pc, #-2147483628	; 0x80000014
     984:	63697361 	cmnvs	r9, #-2080374783	; 0x84000001
     988:	6e65505f 	mcrvs	0, 3, r5, cr5, cr15, {2}
     98c:	676e6964 	strbvs	r6, [lr, -r4, ror #18]!
     990:	73694400 	cmnvc	r9, #0, 8
     994:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     998:	5152495f 	cmppl	r2, pc, asr r9
     99c:	6e494300 	cdpvs	3, 4, cr4, cr9, cr0, {0}
     9a0:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
     9a4:	5f747075 	svcpl	0x00747075
     9a8:	746e6f43 	strbtvc	r6, [lr], #-3907	; 0xfffff0bd
     9ac:	6c6c6f72 	stclvs	15, cr6, [ip], #-456	; 0xfffffe38
     9b0:	49007265 	stmdbmi	r0, {r0, r2, r5, r6, r9, ip, sp, lr}
     9b4:	425f5152 	subsmi	r5, pc, #-2147483628	; 0x80000014
     9b8:	63697361 	cmnvs	r9, #-2080374783	; 0x84000001
     9bc:	7369445f 	cmnvc	r9, #1593835520	; 0x5f000000
     9c0:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     9c4:	616e4500 	cmnvs	lr, r0, lsl #10
     9c8:	5f656c62 	svcpl	0x00656c62
     9cc:	69736142 	ldmdbvs	r3!, {r1, r6, r8, sp, lr}^
     9d0:	52495f63 	subpl	r5, r9, #396	; 0x18c
     9d4:	5a5f0051 	bpl	17c0b20 <_bss_end+0x17b7c3c>
     9d8:	4331324e 	teqmi	r1, #-536870908	; 0xe0000004
     9dc:	65746e49 	ldrbvs	r6, [r4, #-3657]!	; 0xfffff1b7
     9e0:	70757272 	rsbsvc	r7, r5, r2, ror r2
     9e4:	6f435f74 	svcvs	0x00435f74
     9e8:	6f72746e 	svcvs	0x0072746e
     9ec:	72656c6c 	rsbvc	r6, r5, #108, 24	; 0x6c00
     9f0:	69443731 	stmdbvs	r4, {r0, r4, r5, r8, r9, sl, ip, sp}^
     9f4:	6c626173 	stfvse	f6, [r2], #-460	; 0xfffffe34
     9f8:	61425f65 	cmpvs	r2, r5, ror #30
     9fc:	5f636973 	svcpl	0x00636973
     a00:	45515249 	ldrbmi	r5, [r1, #-585]	; 0xfffffdb7
     a04:	6168334e 	cmnvs	r8, lr, asr #6
     a08:	4936316c 	ldmdbmi	r6!, {r2, r3, r5, r6, r8, ip, sp}
     a0c:	425f5152 	subsmi	r5, pc, #-2147483628	; 0x80000014
     a10:	63697361 	cmnvs	r9, #-2080374783	; 0x84000001
     a14:	756f535f 	strbvc	r5, [pc, #-863]!	; 6bd <CPSR_IRQ_INHIBIT+0x63d>
     a18:	45656372 	strbmi	r6, [r5, #-882]!	; 0xfffffc8e
     a1c:	6f6f4400 	svcvs	0x006f4400
     a20:	6c656272 	sfmvs	f6, 2, [r5], #-456	; 0xfffffe38
     a24:	00305f6c 	eorseq	r5, r0, ip, ror #30
     a28:	726f6f44 	rsbvc	r6, pc, #68, 30	; 0x110
     a2c:	6c6c6562 	cfstr64vs	mvdx6, [ip], #-392	; 0xfffffe78
     a30:	2f00315f 	svccs	0x0000315f
     a34:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     a38:	6c69732f 	stclvs	3, cr7, [r9], #-188	; 0xffffff44
     a3c:	79766168 	ldmdbvc	r6!, {r3, r5, r6, r8, sp, lr}^
     a40:	63532f6a 	cmpvs	r3, #424	; 0x1a8
     a44:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; 8ac <CPSR_IRQ_INHIBIT+0x82c>
     a48:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
     a4c:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
     a50:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
     a54:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
     a58:	302f7365 	eorcc	r7, pc, r5, ror #6
     a5c:	50472d39 	subpl	r2, r7, r9, lsr sp
     a60:	695f4f49 	ldmdbvs	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     a64:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
     a68:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
     a6c:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
     a70:	2f6c656e 	svccs	0x006c656e
     a74:	2f637273 	svccs	0x00637273
     a78:	65746e69 	ldrbvs	r6, [r4, #-3689]!	; 0xfffff197
     a7c:	70757272 	rsbsvc	r7, r5, r2, ror r2
     a80:	6f635f74 	svcvs	0x00635f74
     a84:	6f72746e 	svcvs	0x0072746e
     a88:	72656c6c 	rsbvc	r6, r5, #108, 24	; 0x6c00
     a8c:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
     a90:	55504700 	ldrbpl	r4, [r0, #-1792]	; 0xfffff900
     a94:	61485f30 	cmpvs	r8, r0, lsr pc
     a98:	5f00746c 	svcpl	0x0000746c
     a9c:	31324e5a 	teqcc	r2, sl, asr lr
     aa0:	746e4943 	strbtvc	r4, [lr], #-2371	; 0xfffff6bd
     aa4:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
     aa8:	435f7470 	cmpmi	pc, #112, 8	; 0x70000000
     aac:	72746e6f 	rsbsvc	r6, r4, #1776	; 0x6f0
     ab0:	656c6c6f 	strbvs	r6, [ip, #-3183]!	; 0xfffff391
     ab4:	45303172 	ldrmi	r3, [r0, #-370]!	; 0xfffffe8e
     ab8:	6c62616e 	stfvse	f6, [r2], #-440	; 0xfffffe48
     abc:	52495f65 	subpl	r5, r9, #404	; 0x194
     ac0:	334e4551 	movtcc	r4, #58705	; 0xe551
     ac4:	316c6168 	cmncc	ip, r8, ror #2
     ac8:	51524930 	cmppl	r2, r0, lsr r9
     acc:	756f535f 	strbvc	r5, [pc, #-863]!	; 775 <CPSR_IRQ_INHIBIT+0x6f5>
     ad0:	45656372 	strbmi	r6, [r5, #-882]!	; 0xfffffc8e
     ad4:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     ad8:	49433132 	stmdbmi	r3, {r1, r4, r5, r8, ip, sp}^
     adc:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
     ae0:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
     ae4:	6e6f435f 	mcrvs	3, 3, r4, cr15, cr15, {2}
     ae8:	6c6f7274 	sfmvs	f7, 2, [pc], #-464	; 920 <CPSR_IRQ_INHIBIT+0x8a0>
     aec:	3172656c 	cmncc	r2, ip, ror #10
     af0:	616e4536 	cmnvs	lr, r6, lsr r5
     af4:	5f656c62 	svcpl	0x00656c62
     af8:	69736142 	ldmdbvs	r3!, {r1, r6, r8, sp, lr}^
     afc:	52495f63 	subpl	r5, r9, #396	; 0x18c
     b00:	334e4551 	movtcc	r4, #58705	; 0xe551
     b04:	316c6168 	cmncc	ip, r8, ror #2
     b08:	51524936 	cmppl	r2, r6, lsr r9
     b0c:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
     b10:	535f6369 	cmppl	pc, #-1543503871	; 0xa4000001
     b14:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     b18:	5f004565 	svcpl	0x00004565
     b1c:	31324e5a 	teqcc	r2, sl, asr lr
     b20:	746e4943 	strbtvc	r4, [lr], #-2371	; 0xfffff6bd
     b24:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
     b28:	435f7470 	cmpmi	pc, #112, 8	; 0x70000000
     b2c:	72746e6f 	rsbsvc	r6, r4, #1776	; 0x6f0
     b30:	656c6c6f 	strbvs	r6, [ip, #-3183]!	; 0xfffff391
     b34:	45344372 	ldrmi	r4, [r4, #-882]!	; 0xfffffc8e
     b38:	3249006d 	subcc	r0, r9, #109	; 0x6d
     b3c:	50535f43 	subspl	r5, r3, r3, asr #30
     b40:	4c535f49 	mrrcmi	15, 4, r5, r3, cr9
     b44:	5f455641 	svcpl	0x00455641
     b48:	54494e49 	strbpl	r4, [r9], #-3657	; 0xfffff1b7
     b4c:	51494600 	cmppl	r9, r0, lsl #12
     b50:	6e6f435f 	mcrvs	3, 3, r4, cr15, cr15, {2}
     b54:	6c6f7274 	sfmvs	f7, 2, [pc], #-464	; 98c <CPSR_IRQ_INHIBIT+0x90c>
     b58:	71726900 	cmnvc	r2, r0, lsl #18
     b5c:	6e61685f 	mcrvs	8, 3, r6, cr1, cr15, {2}
     b60:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     b64:	4c475f00 	mcrrmi	15, 0, r5, r7, cr0
     b68:	4c41424f 	sfmmi	f4, 2, [r1], {79}	; 0x4f
     b6c:	75735f5f 	ldrbvc	r5, [r3, #-3935]!	; 0xfffff0a1
     b70:	5f495f62 	svcpl	0x00495f62
     b74:	74666f73 	strbtvc	r6, [r6], #-3955	; 0xfffff08d
     b78:	65726177 	ldrbvs	r6, [r2, #-375]!	; 0xfffffe89
     b7c:	746e695f 	strbtvc	r6, [lr], #-2399	; 0xfffff6a1
     b80:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
     b84:	685f7470 	ldmdavs	pc, {r4, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
     b88:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     b8c:	49007265 	stmdbmi	r0, {r0, r2, r5, r6, r9, ip, sp, lr}
     b90:	425f5152 	subsmi	r5, pc, #-2147483628	; 0x80000014
     b94:	63697361 	cmnvs	r9, #-2080374783	; 0x84000001
     b98:	616e455f 	cmnvs	lr, pc, asr r5
     b9c:	00656c62 	rsbeq	r6, r5, r2, ror #24
     ba0:	74617473 	strbtvc	r7, [r1], #-1139	; 0xfffffb8d
     ba4:	49007375 	stmdbmi	r0, {r0, r2, r4, r5, r6, r8, r9, ip, sp, lr}
     ba8:	505f5152 	subspl	r5, pc, r2, asr r1	; <UNPREDICTABLE>
     bac:	69646e65 	stmdbvs	r4!, {r0, r2, r5, r6, r9, sl, fp, sp, lr}^
     bb0:	315f676e 	cmpcc	pc, lr, ror #14
     bb4:	51524900 	cmppl	r2, r0, lsl #18
     bb8:	756f535f 	strbvc	r5, [pc, #-863]!	; 861 <CPSR_IRQ_INHIBIT+0x7e1>
     bbc:	00656372 	rsbeq	r6, r5, r2, ror r3
     bc0:	746e4973 	strbtvc	r4, [lr], #-2419	; 0xfffff68d
     bc4:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
     bc8:	74437470 	strbvc	r7, [r3], #-1136	; 0xfffffb90
     bcc:	5249006c 	subpl	r0, r9, #108	; 0x6c
     bd0:	65505f51 	ldrbvs	r5, [r0, #-3921]	; 0xfffff0af
     bd4:	6e69646e 	cdpvs	4, 6, cr6, cr9, cr14, {3}
     bd8:	00325f67 	eorseq	r5, r2, r7, ror #30
     bdc:	4f495047 	svcmi	0x00495047
     be0:	4700305f 	smlsdmi	r0, pc, r0, r3	; <UNPREDICTABLE>
     be4:	5f4f4950 	svcpl	0x004f4950
     be8:	50470031 	subpl	r0, r7, r1, lsr r0
     bec:	325f4f49 	subscc	r4, pc, #292	; 0x124
     bf0:	49504700 	ldmdbmi	r0, {r8, r9, sl, lr}^
     bf4:	00335f4f 	eorseq	r5, r3, pc, asr #30
     bf8:	61736944 	cmnvs	r3, r4, asr #18
     bfc:	5f656c62 	svcpl	0x00656c62
     c00:	69736142 	ldmdbvs	r3!, {r1, r6, r8, sp, lr}^
     c04:	52495f63 	subpl	r5, r9, #396	; 0x18c
     c08:	6f730051 	svcvs	0x00730051
     c0c:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     c10:	7864695f 	stmdavc	r4!, {r0, r1, r2, r3, r4, r6, r8, fp, sp, lr}^
     c14:	51524900 	cmppl	r2, r0, lsl #18
     c18:	7369445f 	cmnvc	r9, #1593835520	; 0x5f000000
     c1c:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     c20:	4900315f 	stmdbmi	r0, {r0, r1, r2, r3, r4, r6, r8, ip, sp}
     c24:	445f5152 	ldrbmi	r5, [pc], #-338	; c2c <CPSR_IRQ_INHIBIT+0xbac>
     c28:	62617369 	rsbvs	r7, r1, #-1543503871	; 0xa4000001
     c2c:	325f656c 	subscc	r6, pc, #108, 10	; 0x1b000000
     c30:	41575000 	cmpmi	r7, r0
     c34:	5000305f 	andpl	r3, r0, pc, asr r0
     c38:	315f4157 	cmpcc	pc, r7, asr r1	; <UNPREDICTABLE>
     c3c:	6f682f00 	svcvs	0x00682f00
     c40:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
     c44:	61686c69 	cmnvs	r8, r9, ror #24
     c48:	2f6a7976 	svccs	0x006a7976
     c4c:	6f686353 	svcvs	0x00686353
     c50:	5a2f6c6f 	bpl	bdbe14 <_bss_end+0xbd2f30>
     c54:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; ac8 <CPSR_IRQ_INHIBIT+0xa48>
     c58:	2f657461 	svccs	0x00657461
     c5c:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
     c60:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
     c64:	2d39302f 	ldccs	0, cr3, [r9, #-188]!	; 0xffffff44
     c68:	4f495047 	svcmi	0x00495047
     c6c:	746e695f 	strbtvc	r6, [lr], #-2399	; 0xfffff6a1
     c70:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
     c74:	6b2f7470 	blvs	bdde3c <_bss_end+0xbd4f58>
     c78:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
     c7c:	72732f6c 	rsbsvc	r2, r3, #108, 30	; 0x1b0
     c80:	616d2f63 	cmnvs	sp, r3, ror #30
     c84:	632e6e69 			; <UNDEFINED> instruction: 0x632e6e69
     c88:	5f007070 	svcpl	0x00007070
     c8c:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
     c90:	6d5f6c65 	ldclvs	12, cr6, [pc, #-404]	; b04 <CPSR_IRQ_INHIBIT+0xa84>
     c94:	006e6961 	rsbeq	r6, lr, r1, ror #18
     c98:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; be4 <CPSR_IRQ_INHIBIT+0xb64>
     c9c:	69732f65 	ldmdbvs	r3!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
     ca0:	7661686c 	strbtvc	r6, [r1], -ip, ror #16
     ca4:	532f6a79 			; <UNDEFINED> instruction: 0x532f6a79
     ca8:	6f6f6863 	svcvs	0x006f6863
     cac:	655a2f6c 	ldrbvs	r2, [sl, #-3948]	; 0xfffff094
     cb0:	614d6f72 	hvcvs	55026	; 0xd6f2
     cb4:	652f6574 	strvs	r6, [pc, #-1396]!	; 748 <CPSR_IRQ_INHIBIT+0x6c8>
     cb8:	706d6178 	rsbvc	r6, sp, r8, ror r1
     cbc:	2f73656c 	svccs	0x0073656c
     cc0:	472d3930 			; <UNDEFINED> instruction: 0x472d3930
     cc4:	5f4f4950 	svcpl	0x004f4950
     cc8:	65746e69 	ldrbvs	r6, [r4, #-3689]!	; 0xfffff197
     ccc:	70757272 	rsbsvc	r7, r5, r2, ror r2
     cd0:	656b2f74 	strbvs	r2, [fp, #-3956]!	; 0xfffff08c
     cd4:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
     cd8:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
     cdc:	6174732f 	cmnvs	r4, pc, lsr #6
     ce0:	732e7472 			; <UNDEFINED> instruction: 0x732e7472
     ce4:	554e4700 	strbpl	r4, [lr, #-1792]	; 0xfffff900
     ce8:	20534120 	subscs	r4, r3, r0, lsr #2
     cec:	34332e32 	ldrtcc	r2, [r3], #-3634	; 0xfffff1ce
     cf0:	6f682f00 	svcvs	0x00682f00
     cf4:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
     cf8:	61686c69 	cmnvs	r8, r9, ror #24
     cfc:	2f6a7976 	svccs	0x006a7976
     d00:	6f686353 	svcvs	0x00686353
     d04:	5a2f6c6f 	bpl	bdbec8 <_bss_end+0xbd2fe4>
     d08:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; b7c <CPSR_IRQ_INHIBIT+0xafc>
     d0c:	2f657461 	svccs	0x00657461
     d10:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
     d14:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
     d18:	2d39302f 	ldccs	0, cr3, [r9, #-188]!	; 0xffffff44
     d1c:	4f495047 	svcmi	0x00495047
     d20:	746e695f 	strbtvc	r6, [lr], #-2399	; 0xfffff6a1
     d24:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
     d28:	6b2f7470 	blvs	bddef0 <_bss_end+0xbd500c>
     d2c:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
     d30:	72732f6c 	rsbsvc	r2, r3, #108, 30	; 0x1b0
     d34:	74732f63 	ldrbtvc	r2, [r3], #-3939	; 0xfffff09d
     d38:	75747261 	ldrbvc	r7, [r4, #-609]!	; 0xfffffd9f
     d3c:	70632e70 	rsbvc	r2, r3, r0, ror lr
     d40:	625f0070 	subsvs	r0, pc, #112	; 0x70
     d44:	735f7373 	cmpvc	pc, #-872415231	; 0xcc000001
     d48:	74726174 	ldrbtvc	r6, [r2], #-372	; 0xfffffe8c
     d4c:	435f5f00 	cmpmi	pc, #0, 30
     d50:	5f524f54 	svcpl	0x00524f54
     d54:	5f444e45 	svcpl	0x00444e45
     d58:	5f5f005f 	svcpl	0x005f005f
     d5c:	524f5443 	subpl	r5, pc, #1124073472	; 0x43000000
     d60:	53494c5f 	movtpl	r4, #40031	; 0x9c5f
     d64:	005f5f54 	subseq	r5, pc, r4, asr pc	; <UNPREDICTABLE>
     d68:	54445f5f 	strbpl	r5, [r4], #-3935	; 0xfffff0a1
     d6c:	455f524f 	ldrbmi	r5, [pc, #-591]	; b25 <CPSR_IRQ_INHIBIT+0xaa5>
     d70:	5f5f444e 	svcpl	0x005f444e
     d74:	70635f00 	rsbvc	r5, r3, r0, lsl #30
     d78:	68735f70 	ldmdavs	r3!, {r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     d7c:	6f647475 	svcvs	0x00647475
     d80:	5f006e77 	svcpl	0x00006e77
     d84:	5f737362 	svcpl	0x00737362
     d88:	00646e65 	rsbeq	r6, r4, r5, ror #28
     d8c:	54445f5f 	strbpl	r5, [r4], #-3935	; 0xfffff0a1
     d90:	4c5f524f 	lfmmi	f5, 2, [pc], {79}	; 0x4f
     d94:	5f545349 	svcpl	0x00545349
     d98:	7464005f 	strbtvc	r0, [r4], #-95	; 0xffffffa1
     d9c:	705f726f 	subsvc	r7, pc, pc, ror #4
     da0:	63007274 	movwvs	r7, #628	; 0x274
     da4:	5f726f74 	svcpl	0x00726f74
     da8:	00727470 	rsbseq	r7, r2, r0, ror r4
     dac:	735f635f 	cmpvc	pc, #2080374785	; 0x7c000001
     db0:	74726174 	ldrbtvc	r6, [r2], #-372	; 0xfffffe8c
     db4:	5f007075 	svcpl	0x00007075
     db8:	5f707063 	svcpl	0x00707063
     dbc:	72617473 	rsbvc	r7, r1, #1929379840	; 0x73000000
     dc0:	00707574 	rsbseq	r7, r0, r4, ror r5
     dc4:	74706e66 	ldrbtvc	r6, [r0], #-3686	; 0xfffff19a
     dc8:	41540072 	cmpmi	r4, r2, ror r0
     dcc:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
     dd0:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
     dd4:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
     dd8:	61786574 	cmnvs	r8, r4, ror r5
     ddc:	6f633731 	svcvs	0x00633731
     de0:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
     de4:	69003761 	stmdbvs	r0, {r0, r5, r6, r8, r9, sl, ip, sp}
     de8:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
     dec:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
     df0:	62645f70 	rsbvs	r5, r4, #112, 30	; 0x1c0
     df4:	7261006c 	rsbvc	r0, r1, #108	; 0x6c
     df8:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
     dfc:	695f6863 	ldmdbvs	pc, {r0, r1, r5, r6, fp, sp, lr}^	; <UNPREDICTABLE>
     e00:	786d6d77 	stmdavc	sp!, {r0, r1, r2, r4, r5, r6, r8, sl, fp, sp, lr}^
     e04:	41540074 	cmpmi	r4, r4, ror r0
     e08:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
     e0c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
     e10:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
     e14:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
     e18:	41003332 	tstmi	r0, r2, lsr r3
     e1c:	455f4d52 	ldrbmi	r4, [pc, #-3410]	; d2 <CPSR_IRQ_INHIBIT+0x52>
     e20:	41540051 	cmpmi	r4, r1, asr r0
     e24:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
     e28:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
     e2c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
     e30:	36353131 			; <UNDEFINED> instruction: 0x36353131
     e34:	73663274 	cmnvc	r6, #116, 4	; 0x40000007
     e38:	61736900 	cmnvs	r3, r0, lsl #18
     e3c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
     e40:	7568745f 	strbvc	r7, [r8, #-1119]!	; 0xfffffba1
     e44:	5400626d 	strpl	r6, [r0], #-621	; 0xfffffd93
     e48:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
     e4c:	50435f54 	subpl	r5, r3, r4, asr pc
     e50:	6f635f55 	svcvs	0x00635f55
     e54:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
     e58:	63373561 	teqvs	r7, #406847488	; 0x18400000
     e5c:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
     e60:	33356178 	teqcc	r5, #120, 2
     e64:	53414200 	movtpl	r4, #4608	; 0x1200
     e68:	52415f45 	subpl	r5, r1, #276	; 0x114
     e6c:	385f4843 	ldmdacc	pc, {r0, r1, r6, fp, lr}^	; <UNPREDICTABLE>
     e70:	41425f4d 	cmpmi	r2, sp, asr #30
     e74:	54004553 	strpl	r4, [r0], #-1363	; 0xfffffaad
     e78:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
     e7c:	50435f54 	subpl	r5, r3, r4, asr pc
     e80:	72615f55 	rsbvc	r5, r1, #340	; 0x154
     e84:	3031386d 	eorscc	r3, r1, sp, ror #16
     e88:	52415400 	subpl	r5, r1, #0, 8
     e8c:	5f544547 	svcpl	0x00544547
     e90:	5f555043 	svcpl	0x00555043
     e94:	6e656778 	mcrvs	7, 3, r6, cr5, cr8, {3}
     e98:	41003165 	tstmi	r0, r5, ror #2
     e9c:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
     ea0:	415f5343 	cmpmi	pc, r3, asr #6
     ea4:	53435041 	movtpl	r5, #12353	; 0x3041
     ea8:	4d57495f 	vldrmi.16	s9, [r7, #-190]	; 0xffffff42	; <UNPREDICTABLE>
     eac:	0054584d 	subseq	r5, r4, sp, asr #16
     eb0:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
     eb4:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
     eb8:	00305f48 	eorseq	r5, r0, r8, asr #30
     ebc:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
     ec0:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
     ec4:	00325f48 	eorseq	r5, r2, r8, asr #30
     ec8:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
     ecc:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
     ed0:	00335f48 	eorseq	r5, r3, r8, asr #30
     ed4:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
     ed8:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
     edc:	00345f48 	eorseq	r5, r4, r8, asr #30
     ee0:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
     ee4:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
     ee8:	00365f48 	eorseq	r5, r6, r8, asr #30
     eec:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
     ef0:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
     ef4:	00375f48 	eorseq	r5, r7, r8, asr #30
     ef8:	47524154 			; <UNDEFINED> instruction: 0x47524154
     efc:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
     f00:	785f5550 	ldmdavc	pc, {r4, r6, r8, sl, ip, lr}^	; <UNPREDICTABLE>
     f04:	6c616373 	stclvs	3, cr6, [r1], #-460	; 0xfffffe34
     f08:	73690065 	cmnvc	r9, #101	; 0x65
     f0c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
     f10:	72705f74 	rsbsvc	r5, r0, #116, 30	; 0x1d0
     f14:	65726465 	ldrbvs	r6, [r2, #-1125]!	; 0xfffffb9b
     f18:	41540073 	cmpmi	r4, r3, ror r0
     f1c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
     f20:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
     f24:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
     f28:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
     f2c:	54003333 	strpl	r3, [r0], #-819	; 0xfffffccd
     f30:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
     f34:	50435f54 	subpl	r5, r3, r4, asr pc
     f38:	72615f55 	rsbvc	r5, r1, #340	; 0x154
     f3c:	6474376d 	ldrbtvs	r3, [r4], #-1901	; 0xfffff893
     f40:	6900696d 	stmdbvs	r0, {r0, r2, r3, r5, r6, r8, fp, sp, lr}
     f44:	6e5f6173 	mrcvs	1, 2, r6, cr15, cr3, {3}
     f48:	7469626f 	strbtvc	r6, [r9], #-623	; 0xfffffd91
     f4c:	52415400 	subpl	r5, r1, #0, 8
     f50:	5f544547 	svcpl	0x00544547
     f54:	5f555043 	svcpl	0x00555043
     f58:	316d7261 	cmncc	sp, r1, ror #4
     f5c:	6a363731 	bvs	d8ec28 <_bss_end+0xd85d44>
     f60:	0073667a 	rsbseq	r6, r3, sl, ror r6
     f64:	5f617369 	svcpl	0x00617369
     f68:	5f746962 	svcpl	0x00746962
     f6c:	76706676 			; <UNDEFINED> instruction: 0x76706676
     f70:	52410032 	subpl	r0, r1, #50	; 0x32
     f74:	43505f4d 	cmpmi	r0, #308	; 0x134
     f78:	4e555f53 	mrcmi	15, 2, r5, cr5, cr3, {2}
     f7c:	574f4e4b 	strbpl	r4, [pc, -fp, asr #28]
     f80:	4154004e 	cmpmi	r4, lr, asr #32
     f84:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
     f88:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
     f8c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
     f90:	42006539 	andmi	r6, r0, #239075328	; 0xe400000
     f94:	5f455341 	svcpl	0x00455341
     f98:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
     f9c:	4554355f 	ldrbmi	r3, [r4, #-1375]	; 0xfffffaa1
     fa0:	7261004a 	rsbvc	r0, r1, #74	; 0x4a
     fa4:	63635f6d 	cmnvs	r3, #436	; 0x1b4
     fa8:	5f6d7366 	svcpl	0x006d7366
     fac:	74617473 	strbtvc	r7, [r1], #-1139	; 0xfffffb8d
     fb0:	72610065 	rsbvc	r0, r1, #101	; 0x65
     fb4:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
     fb8:	74356863 	ldrtvc	r6, [r5], #-2147	; 0xfffff79d
     fbc:	6e750065 	cdpvs	0, 7, cr0, cr5, cr5, {3}
     fc0:	63657073 	cmnvs	r5, #115	; 0x73
     fc4:	7274735f 	rsbsvc	r7, r4, #2080374785	; 0x7c000001
     fc8:	73676e69 	cmnvc	r7, #1680	; 0x690
     fcc:	61736900 	cmnvs	r3, r0, lsl #18
     fd0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
     fd4:	6365735f 	cmnvs	r5, #2080374785	; 0x7c000001
     fd8:	635f5f00 	cmpvs	pc, #0, 30
     fdc:	745f7a6c 	ldrbvc	r7, [pc], #-2668	; fe4 <CPSR_IRQ_INHIBIT+0xf64>
     fe0:	41006261 	tstmi	r0, r1, ror #4
     fe4:	565f4d52 			; <UNDEFINED> instruction: 0x565f4d52
     fe8:	72610043 	rsbvc	r0, r1, #67	; 0x43
     fec:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
     ff0:	785f6863 	ldmdavc	pc, {r0, r1, r5, r6, fp, sp, lr}^	; <UNPREDICTABLE>
     ff4:	6c616373 	stclvs	3, cr6, [r1], #-460	; 0xfffffe34
     ff8:	52410065 	subpl	r0, r1, #101	; 0x65
     ffc:	454c5f4d 	strbmi	r5, [ip, #-3917]	; 0xfffff0b3
    1000:	4d524100 	ldfmie	f4, [r2, #-0]
    1004:	0053565f 	subseq	r5, r3, pc, asr r6
    1008:	5f4d5241 	svcpl	0x004d5241
    100c:	61004547 	tstvs	r0, r7, asr #10
    1010:	745f6d72 	ldrbvc	r6, [pc], #-3442	; 1018 <CPSR_IRQ_INHIBIT+0xf98>
    1014:	5f656e75 	svcpl	0x00656e75
    1018:	6f727473 	svcvs	0x00727473
    101c:	7261676e 	rsbvc	r6, r1, #28835840	; 0x1b80000
    1020:	6f63006d 	svcvs	0x0063006d
    1024:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
    1028:	6c662078 	stclvs	0, cr2, [r6], #-480	; 0xfffffe20
    102c:	0074616f 	rsbseq	r6, r4, pc, ror #2
    1030:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1034:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1038:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    103c:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1040:	35316178 	ldrcc	r6, [r1, #-376]!	; 0xfffffe88
    1044:	52415400 	subpl	r5, r1, #0, 8
    1048:	5f544547 	svcpl	0x00544547
    104c:	5f555043 	svcpl	0x00555043
    1050:	32376166 	eorscc	r6, r7, #-2147483623	; 0x80000019
    1054:	00657436 	rsbeq	r7, r5, r6, lsr r4
    1058:	47524154 			; <UNDEFINED> instruction: 0x47524154
    105c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1060:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1064:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1068:	37316178 			; <UNDEFINED> instruction: 0x37316178
    106c:	4d524100 	ldfmie	f4, [r2, #-0]
    1070:	0054475f 	subseq	r4, r4, pc, asr r7
    1074:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1078:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    107c:	6e5f5550 	mrcvs	5, 2, r5, cr15, cr0, {2}
    1080:	65766f65 	ldrbvs	r6, [r6, #-3941]!	; 0xfffff09b
    1084:	6e657372 	mcrvs	3, 3, r7, cr5, cr2, {3}
    1088:	2e2e0031 	mcrcs	0, 1, r0, cr14, cr1, {1}
    108c:	2f2e2e2f 	svccs	0x002e2e2f
    1090:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1094:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1098:	2f2e2e2f 	svccs	0x002e2e2f
    109c:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    10a0:	6c2f6363 	stcvs	3, cr6, [pc], #-396	; f1c <CPSR_IRQ_INHIBIT+0xe9c>
    10a4:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    10a8:	632e3263 			; <UNDEFINED> instruction: 0x632e3263
    10ac:	52415400 	subpl	r5, r1, #0, 8
    10b0:	5f544547 	svcpl	0x00544547
    10b4:	5f555043 	svcpl	0x00555043
    10b8:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    10bc:	34727865 	ldrbtcc	r7, [r2], #-2149	; 0xfffff79b
    10c0:	41420066 	cmpmi	r2, r6, rrx
    10c4:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    10c8:	5f484352 	svcpl	0x00484352
    10cc:	004d4537 	subeq	r4, sp, r7, lsr r5
    10d0:	47524154 			; <UNDEFINED> instruction: 0x47524154
    10d4:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    10d8:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    10dc:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    10e0:	32316178 	eorscc	r6, r1, #120, 2
    10e4:	73616800 	cmnvc	r1, #0, 16
    10e8:	6c617668 	stclvs	6, cr7, [r1], #-416	; 0xfffffe60
    10ec:	4200745f 	andmi	r7, r0, #1593835520	; 0x5f000000
    10f0:	5f455341 	svcpl	0x00455341
    10f4:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    10f8:	5a4b365f 	bpl	12cea7c <_bss_end+0x12c5b98>
    10fc:	61736900 	cmnvs	r3, r0, lsl #18
    1100:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1104:	72610073 	rsbvc	r0, r1, #115	; 0x73
    1108:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    110c:	615f6863 	cmpvs	pc, r3, ror #16
    1110:	685f6d72 	ldmdavs	pc, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^	; <UNPREDICTABLE>
    1114:	76696477 			; <UNDEFINED> instruction: 0x76696477
    1118:	6d726100 	ldfvse	f6, [r2, #-0]
    111c:	7570665f 	ldrbvc	r6, [r0, #-1631]!	; 0xfffff9a1
    1120:	7365645f 	cmnvc	r5, #1593835520	; 0x5f000000
    1124:	73690063 	cmnvc	r9, #99	; 0x63
    1128:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    112c:	70665f74 	rsbvc	r5, r6, r4, ror pc
    1130:	47003631 	smladxmi	r0, r1, r6, r3
    1134:	4320554e 			; <UNDEFINED> instruction: 0x4320554e
    1138:	39203731 	stmdbcc	r0!, {r0, r4, r5, r8, r9, sl, ip, sp}
    113c:	312e322e 			; <UNDEFINED> instruction: 0x312e322e
    1140:	31303220 	teqcc	r0, r0, lsr #4
    1144:	32303139 	eorscc	r3, r0, #1073741838	; 0x4000000e
    1148:	72282035 	eorvc	r2, r8, #53	; 0x35
    114c:	61656c65 	cmnvs	r5, r5, ror #24
    1150:	20296573 	eorcs	r6, r9, r3, ror r5
    1154:	4d52415b 	ldfmie	f4, [r2, #-364]	; 0xfffffe94
    1158:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
    115c:	622d392d 	eorvs	r3, sp, #737280	; 0xb4000
    1160:	636e6172 	cmnvs	lr, #-2147483620	; 0x8000001c
    1164:	65722068 	ldrbvs	r2, [r2, #-104]!	; 0xffffff98
    1168:	69736976 	ldmdbvs	r3!, {r1, r2, r4, r5, r6, r8, fp, sp, lr}^
    116c:	32206e6f 	eorcc	r6, r0, #1776	; 0x6f0
    1170:	39353737 	ldmdbcc	r5!, {r0, r1, r2, r4, r5, r8, r9, sl, ip, sp}
    1174:	2d205d39 	stccs	13, cr5, [r0, #-228]!	; 0xffffff1c
    1178:	6d72616d 	ldfvse	f6, [r2, #-436]!	; 0xfffffe4c
    117c:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
    1180:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
    1184:	6962612d 	stmdbvs	r2!, {r0, r2, r3, r5, r8, sp, lr}^
    1188:	7261683d 	rsbvc	r6, r1, #3997696	; 0x3d0000
    118c:	6d2d2064 	stcvs	0, cr2, [sp, #-400]!	; 0xfffffe70
    1190:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1194:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
    1198:	65743576 	ldrbvs	r3, [r4, #-1398]!	; 0xfffffa8a
    119c:	2070662b 	rsbscs	r6, r0, fp, lsr #12
    11a0:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
    11a4:	672d2067 	strvs	r2, [sp, -r7, rrx]!
    11a8:	324f2d20 	subcc	r2, pc, #32, 26	; 0x800
    11ac:	324f2d20 	subcc	r2, pc, #32, 26	; 0x800
    11b0:	324f2d20 	subcc	r2, pc, #32, 26	; 0x800
    11b4:	62662d20 	rsbvs	r2, r6, #32, 26	; 0x800
    11b8:	646c6975 	strbtvs	r6, [ip], #-2421	; 0xfffff68b
    11bc:	2d676e69 	stclcs	14, cr6, [r7, #-420]!	; 0xfffffe5c
    11c0:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    11c4:	2d206363 	stccs	3, cr6, [r0, #-396]!	; 0xfffffe74
    11c8:	2d6f6e66 	stclcs	14, cr6, [pc, #-408]!	; 1038 <CPSR_IRQ_INHIBIT+0xfb8>
    11cc:	63617473 	cmnvs	r1, #1929379840	; 0x73000000
    11d0:	72702d6b 	rsbsvc	r2, r0, #6848	; 0x1ac0
    11d4:	6365746f 	cmnvs	r5, #1862270976	; 0x6f000000
    11d8:	20726f74 	rsbscs	r6, r2, r4, ror pc
    11dc:	6f6e662d 	svcvs	0x006e662d
    11e0:	6c6e692d 			; <UNDEFINED> instruction: 0x6c6e692d
    11e4:	20656e69 	rsbcs	r6, r5, r9, ror #28
    11e8:	6976662d 	ldmdbvs	r6!, {r0, r2, r3, r5, r9, sl, sp, lr}^
    11ec:	69626973 	stmdbvs	r2!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
    11f0:	7974696c 	ldmdbvc	r4!, {r2, r3, r5, r6, r8, fp, sp, lr}^
    11f4:	6469683d 	strbtvs	r6, [r9], #-2109	; 0xfffff7c3
    11f8:	006e6564 	rsbeq	r6, lr, r4, ror #10
    11fc:	5f4d5241 	svcpl	0x004d5241
    1200:	69004948 	stmdbvs	r0, {r3, r6, r8, fp, lr}
    1204:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1208:	615f7469 	cmpvs	pc, r9, ror #8
    120c:	00766964 	rsbseq	r6, r6, r4, ror #18
    1210:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1214:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1218:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    121c:	31316d72 	teqcc	r1, r2, ror sp
    1220:	736a3633 	cmnvc	sl, #53477376	; 0x3300000
    1224:	52415400 	subpl	r5, r1, #0, 8
    1228:	5f544547 	svcpl	0x00544547
    122c:	5f555043 	svcpl	0x00555043
    1230:	386d7261 	stmdacc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    1234:	52415400 	subpl	r5, r1, #0, 8
    1238:	5f544547 	svcpl	0x00544547
    123c:	5f555043 	svcpl	0x00555043
    1240:	396d7261 	stmdbcc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    1244:	52415400 	subpl	r5, r1, #0, 8
    1248:	5f544547 	svcpl	0x00544547
    124c:	5f555043 	svcpl	0x00555043
    1250:	32366166 	eorscc	r6, r6, #-2147483623	; 0x80000019
    1254:	6f6c0036 	svcvs	0x006c0036
    1258:	6c20676e 	stcvs	7, cr6, [r0], #-440	; 0xfffffe48
    125c:	20676e6f 	rsbcs	r6, r7, pc, ror #28
    1260:	69736e75 	ldmdbvs	r3!, {r0, r2, r4, r5, r6, r9, sl, fp, sp, lr}^
    1264:	64656e67 	strbtvs	r6, [r5], #-3687	; 0xfffff199
    1268:	746e6920 	strbtvc	r6, [lr], #-2336	; 0xfffff6e0
    126c:	6d726100 	ldfvse	f6, [r2, #-0]
    1270:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1274:	6d635f68 	stclvs	15, cr5, [r3, #-416]!	; 0xfffffe60
    1278:	54006573 	strpl	r6, [r0], #-1395	; 0xfffffa8d
    127c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1280:	50435f54 	subpl	r5, r3, r4, asr pc
    1284:	6f635f55 	svcvs	0x00635f55
    1288:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    128c:	5400346d 	strpl	r3, [r0], #-1133	; 0xfffffb93
    1290:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1294:	50435f54 	subpl	r5, r3, r4, asr pc
    1298:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    129c:	6530316d 	ldrvs	r3, [r0, #-365]!	; 0xfffffe93
    12a0:	52415400 	subpl	r5, r1, #0, 8
    12a4:	5f544547 	svcpl	0x00544547
    12a8:	5f555043 	svcpl	0x00555043
    12ac:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    12b0:	376d7865 	strbcc	r7, [sp, -r5, ror #16]!
    12b4:	6d726100 	ldfvse	f6, [r2, #-0]
    12b8:	6e6f635f 	mcrvs	3, 3, r6, cr15, cr15, {2}
    12bc:	6f635f64 	svcvs	0x00635f64
    12c0:	41006564 	tstmi	r0, r4, ror #10
    12c4:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    12c8:	415f5343 	cmpmi	pc, r3, asr #6
    12cc:	53435041 	movtpl	r5, #12353	; 0x3041
    12d0:	61736900 	cmnvs	r3, r0, lsl #18
    12d4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    12d8:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    12dc:	325f3876 	subscc	r3, pc, #7733248	; 0x760000
    12e0:	53414200 	movtpl	r4, #4608	; 0x1200
    12e4:	52415f45 	subpl	r5, r1, #276	; 0x114
    12e8:	335f4843 	cmpcc	pc, #4390912	; 0x430000
    12ec:	4154004d 	cmpmi	r4, sp, asr #32
    12f0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    12f4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    12f8:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    12fc:	74303137 	ldrtvc	r3, [r0], #-311	; 0xfffffec9
    1300:	6d726100 	ldfvse	f6, [r2, #-0]
    1304:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1308:	77695f68 	strbvc	r5, [r9, -r8, ror #30]!
    130c:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
    1310:	73690032 	cmnvc	r9, #50	; 0x32
    1314:	756e5f61 	strbvc	r5, [lr, #-3937]!	; 0xfffff09f
    1318:	69625f6d 	stmdbvs	r2!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
    131c:	54007374 	strpl	r7, [r0], #-884	; 0xfffffc8c
    1320:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1324:	50435f54 	subpl	r5, r3, r4, asr pc
    1328:	6f635f55 	svcvs	0x00635f55
    132c:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1330:	6c70306d 	ldclvs	0, cr3, [r0], #-436	; 0xfffffe4c
    1334:	6d737375 	ldclvs	3, cr7, [r3, #-468]!	; 0xfffffe2c
    1338:	6d6c6c61 	stclvs	12, cr6, [ip, #-388]!	; 0xfffffe7c
    133c:	69746c75 	ldmdbvs	r4!, {r0, r2, r4, r5, r6, sl, fp, sp, lr}^
    1340:	00796c70 	rsbseq	r6, r9, r0, ror ip
    1344:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1348:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    134c:	655f5550 	ldrbvs	r5, [pc, #-1360]	; e04 <CPSR_IRQ_INHIBIT+0xd84>
    1350:	6f6e7978 	svcvs	0x006e7978
    1354:	00316d73 	eorseq	r6, r1, r3, ror sp
    1358:	47524154 			; <UNDEFINED> instruction: 0x47524154
    135c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1360:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1364:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1368:	32357278 	eorscc	r7, r5, #120, 4	; 0x80000007
    136c:	61736900 	cmnvs	r3, r0, lsl #18
    1370:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1374:	6964745f 	stmdbvs	r4!, {r0, r1, r2, r3, r4, r6, sl, ip, sp, lr}^
    1378:	72700076 	rsbsvc	r0, r0, #118	; 0x76
    137c:	72656665 	rsbvc	r6, r5, #105906176	; 0x6500000
    1380:	6f656e5f 	svcvs	0x00656e5f
    1384:	6f665f6e 	svcvs	0x00665f6e
    1388:	34365f72 	ldrtcc	r5, [r6], #-3954	; 0xfffff08e
    138c:	73746962 	cmnvc	r4, #1605632	; 0x188000
    1390:	61736900 	cmnvs	r3, r0, lsl #18
    1394:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1398:	3170665f 	cmncc	r0, pc, asr r6
    139c:	6c6d6636 	stclvs	6, cr6, [sp], #-216	; 0xffffff28
    13a0:	52415400 	subpl	r5, r1, #0, 8
    13a4:	5f544547 	svcpl	0x00544547
    13a8:	5f555043 	svcpl	0x00555043
    13ac:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    13b0:	33617865 	cmncc	r1, #6619136	; 0x650000
    13b4:	41540032 	cmpmi	r4, r2, lsr r0
    13b8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    13bc:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    13c0:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    13c4:	61786574 	cmnvs	r8, r4, ror r5
    13c8:	69003533 	stmdbvs	r0, {r0, r1, r4, r5, r8, sl, ip, sp}
    13cc:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    13d0:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    13d4:	63363170 	teqvs	r6, #112, 2
    13d8:	00766e6f 	rsbseq	r6, r6, pc, ror #28
    13dc:	70736e75 	rsbsvc	r6, r3, r5, ror lr
    13e0:	5f766365 	svcpl	0x00766365
    13e4:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
    13e8:	0073676e 	rsbseq	r6, r3, lr, ror #14
    13ec:	47524154 			; <UNDEFINED> instruction: 0x47524154
    13f0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    13f4:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    13f8:	31316d72 	teqcc	r1, r2, ror sp
    13fc:	32743635 	rsbscc	r3, r4, #55574528	; 0x3500000
    1400:	41540073 	cmpmi	r4, r3, ror r0
    1404:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1408:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    140c:	3661665f 			; <UNDEFINED> instruction: 0x3661665f
    1410:	65743630 	ldrbvs	r3, [r4, #-1584]!	; 0xfffff9d0
    1414:	52415400 	subpl	r5, r1, #0, 8
    1418:	5f544547 	svcpl	0x00544547
    141c:	5f555043 	svcpl	0x00555043
    1420:	396d7261 	stmdbcc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    1424:	6a653632 	bvs	194ecf4 <_bss_end+0x1945e10>
    1428:	41420073 	hvcmi	8195	; 0x2003
    142c:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1430:	5f484352 	svcpl	0x00484352
    1434:	69005434 	stmdbvs	r0, {r2, r4, r5, sl, ip, lr}
    1438:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    143c:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    1440:	74707972 	ldrbtvc	r7, [r0], #-2418	; 0xfffff68e
    1444:	7261006f 	rsbvc	r0, r1, #111	; 0x6f
    1448:	65725f6d 	ldrbvs	r5, [r2, #-3949]!	; 0xfffff093
    144c:	695f7367 	ldmdbvs	pc, {r0, r1, r2, r5, r6, r8, r9, ip, sp, lr}^	; <UNPREDICTABLE>
    1450:	65735f6e 	ldrbvs	r5, [r3, #-3950]!	; 0xfffff092
    1454:	6e657571 	mcrvs	5, 3, r7, cr5, cr1, {3}
    1458:	69006563 	stmdbvs	r0, {r0, r1, r5, r6, r8, sl, sp, lr}
    145c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1460:	735f7469 	cmpvc	pc, #1761607680	; 0x69000000
    1464:	41420062 	cmpmi	r2, r2, rrx
    1468:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    146c:	5f484352 	svcpl	0x00484352
    1470:	00455435 	subeq	r5, r5, r5, lsr r4
    1474:	5f617369 	svcpl	0x00617369
    1478:	74616566 	strbtvc	r6, [r1], #-1382	; 0xfffffa9a
    147c:	00657275 	rsbeq	r7, r5, r5, ror r2
    1480:	5f617369 	svcpl	0x00617369
    1484:	5f746962 	svcpl	0x00746962
    1488:	6c616d73 	stclvs	13, cr6, [r1], #-460	; 0xfffffe34
    148c:	6c756d6c 	ldclvs	13, cr6, [r5], #-432	; 0xfffffe50
    1490:	6d726100 	ldfvse	f6, [r2, #-0]
    1494:	6e616c5f 	mcrvs	12, 3, r6, cr1, cr15, {2}
    1498:	756f5f67 	strbvc	r5, [pc, #-3943]!	; 539 <CPSR_IRQ_INHIBIT+0x4b9>
    149c:	74757074 	ldrbtvc	r7, [r5], #-116	; 0xffffff8c
    14a0:	6a626f5f 	bvs	189d224 <_bss_end+0x1894340>
    14a4:	5f746365 	svcpl	0x00746365
    14a8:	72747461 	rsbsvc	r7, r4, #1627389952	; 0x61000000
    14ac:	74756269 	ldrbtvc	r6, [r5], #-617	; 0xfffffd97
    14b0:	685f7365 	ldmdavs	pc, {r0, r2, r5, r6, r8, r9, ip, sp, lr}^	; <UNPREDICTABLE>
    14b4:	006b6f6f 	rsbeq	r6, fp, pc, ror #30
    14b8:	5f617369 	svcpl	0x00617369
    14bc:	5f746962 	svcpl	0x00746962
    14c0:	645f7066 	ldrbvs	r7, [pc], #-102	; 14c8 <CPSR_IRQ_INHIBIT+0x1448>
    14c4:	41003233 	tstmi	r0, r3, lsr r2
    14c8:	4e5f4d52 	mrcmi	13, 2, r4, cr15, cr2, {2}
    14cc:	73690045 	cmnvc	r9, #69	; 0x45
    14d0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    14d4:	65625f74 	strbvs	r5, [r2, #-3956]!	; 0xfffff08c
    14d8:	41540038 	cmpmi	r4, r8, lsr r0
    14dc:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    14e0:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    14e4:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    14e8:	36373131 			; <UNDEFINED> instruction: 0x36373131
    14ec:	00737a6a 	rsbseq	r7, r3, sl, ror #20
    14f0:	636f7270 	cmnvs	pc, #112, 4
    14f4:	6f737365 	svcvs	0x00737365
    14f8:	79745f72 	ldmdbvc	r4!, {r1, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    14fc:	61006570 	tstvs	r0, r0, ror r5
    1500:	665f6c6c 	ldrbvs	r6, [pc], -ip, ror #24
    1504:	00737570 	rsbseq	r7, r3, r0, ror r5
    1508:	5f6d7261 	svcpl	0x006d7261
    150c:	00736370 	rsbseq	r6, r3, r0, ror r3
    1510:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1514:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1518:	54355f48 	ldrtpl	r5, [r5], #-3912	; 0xfffff0b8
    151c:	6d726100 	ldfvse	f6, [r2, #-0]
    1520:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1524:	00743468 	rsbseq	r3, r4, r8, ror #8
    1528:	47524154 			; <UNDEFINED> instruction: 0x47524154
    152c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1530:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1534:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1538:	36376178 			; <UNDEFINED> instruction: 0x36376178
    153c:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1540:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    1544:	72610035 	rsbvc	r0, r1, #53	; 0x35
    1548:	75745f6d 	ldrbvc	r5, [r4, #-3949]!	; 0xfffff093
    154c:	775f656e 	ldrbvc	r6, [pc, -lr, ror #10]
    1550:	00667562 	rsbeq	r7, r6, r2, ror #10
    1554:	62617468 	rsbvs	r7, r1, #104, 8	; 0x68000000
    1558:	7361685f 	cmnvc	r1, #6225920	; 0x5f0000
    155c:	73690068 	cmnvc	r9, #104	; 0x68
    1560:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1564:	75715f74 	ldrbvc	r5, [r1, #-3956]!	; 0xfffff08c
    1568:	5f6b7269 	svcpl	0x006b7269
    156c:	765f6f6e 	ldrbvc	r6, [pc], -lr, ror #30
    1570:	74616c6f 	strbtvc	r6, [r1], #-3183	; 0xfffff391
    1574:	5f656c69 	svcpl	0x00656c69
    1578:	54006563 	strpl	r6, [r0], #-1379	; 0xfffffa9d
    157c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1580:	50435f54 	subpl	r5, r3, r4, asr pc
    1584:	6f635f55 	svcvs	0x00635f55
    1588:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    158c:	5400306d 	strpl	r3, [r0], #-109	; 0xffffff93
    1590:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1594:	50435f54 	subpl	r5, r3, r4, asr pc
    1598:	6f635f55 	svcvs	0x00635f55
    159c:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    15a0:	5400316d 	strpl	r3, [r0], #-365	; 0xfffffe93
    15a4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    15a8:	50435f54 	subpl	r5, r3, r4, asr pc
    15ac:	6f635f55 	svcvs	0x00635f55
    15b0:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    15b4:	6900336d 	stmdbvs	r0, {r0, r2, r3, r5, r6, r8, r9, ip, sp}
    15b8:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    15bc:	615f7469 	cmpvs	pc, r9, ror #8
    15c0:	38766d72 	ldmdacc	r6!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^
    15c4:	6100315f 	tstvs	r0, pc, asr r1
    15c8:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    15cc:	5f686372 	svcpl	0x00686372
    15d0:	656d616e 	strbvs	r6, [sp, #-366]!	; 0xfffffe92
    15d4:	61736900 	cmnvs	r3, r0, lsl #18
    15d8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    15dc:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    15e0:	335f3876 	cmpcc	pc, #7733248	; 0x760000
    15e4:	61736900 	cmnvs	r3, r0, lsl #18
    15e8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    15ec:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    15f0:	345f3876 	ldrbcc	r3, [pc], #-2166	; 15f8 <CPSR_IRQ_INHIBIT+0x1578>
    15f4:	61736900 	cmnvs	r3, r0, lsl #18
    15f8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    15fc:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1600:	355f3876 	ldrbcc	r3, [pc, #-2166]	; d92 <CPSR_IRQ_INHIBIT+0xd12>
    1604:	52415400 	subpl	r5, r1, #0, 8
    1608:	5f544547 	svcpl	0x00544547
    160c:	5f555043 	svcpl	0x00555043
    1610:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1614:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    1618:	41540033 	cmpmi	r4, r3, lsr r0
    161c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1620:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1624:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1628:	61786574 	cmnvs	r8, r4, ror r5
    162c:	54003535 	strpl	r3, [r0], #-1333	; 0xfffffacb
    1630:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1634:	50435f54 	subpl	r5, r3, r4, asr pc
    1638:	6f635f55 	svcvs	0x00635f55
    163c:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1640:	00373561 	eorseq	r3, r7, r1, ror #10
    1644:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1648:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    164c:	6d5f5550 	cfldr64vs	mvdx5, [pc, #-320]	; 1514 <CPSR_IRQ_INHIBIT+0x1494>
    1650:	726f6370 	rsbvc	r6, pc, #112, 6	; 0xc0000001
    1654:	41540065 	cmpmi	r4, r5, rrx
    1658:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    165c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1660:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1664:	6e6f6e5f 	mcrvs	14, 3, r6, cr15, cr15, {2}
    1668:	72610065 	rsbvc	r0, r1, #101	; 0x65
    166c:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    1670:	6e5f6863 	cdpvs	8, 5, cr6, cr15, cr3, {3}
    1674:	006d746f 	rsbeq	r7, sp, pc, ror #8
    1678:	47524154 			; <UNDEFINED> instruction: 0x47524154
    167c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1680:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1684:	30316d72 	eorscc	r6, r1, r2, ror sp
    1688:	6a653632 	bvs	194ef58 <_bss_end+0x1946074>
    168c:	41420073 	hvcmi	8195	; 0x2003
    1690:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1694:	5f484352 	svcpl	0x00484352
    1698:	42004a36 	andmi	r4, r0, #221184	; 0x36000
    169c:	5f455341 	svcpl	0x00455341
    16a0:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    16a4:	004b365f 	subeq	r3, fp, pc, asr r6
    16a8:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    16ac:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    16b0:	4d365f48 	ldcmi	15, cr5, [r6, #-288]!	; 0xfffffee0
    16b4:	61736900 	cmnvs	r3, r0, lsl #18
    16b8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    16bc:	6d77695f 			; <UNDEFINED> instruction: 0x6d77695f
    16c0:	0074786d 	rsbseq	r7, r4, sp, ror #16
    16c4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    16c8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    16cc:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    16d0:	31316d72 	teqcc	r1, r2, ror sp
    16d4:	666a3633 			; <UNDEFINED> instruction: 0x666a3633
    16d8:	52410073 	subpl	r0, r1, #115	; 0x73
    16dc:	534c5f4d 	movtpl	r5, #53069	; 0xcf4d
    16e0:	4d524100 	ldfmie	f4, [r2, #-0]
    16e4:	00544c5f 	subseq	r4, r4, pc, asr ip
    16e8:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    16ec:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    16f0:	5a365f48 	bpl	d99418 <_bss_end+0xd90534>
    16f4:	52415400 	subpl	r5, r1, #0, 8
    16f8:	5f544547 	svcpl	0x00544547
    16fc:	5f555043 	svcpl	0x00555043
    1700:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1704:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    1708:	726f6335 	rsbvc	r6, pc, #-738197504	; 0xd4000000
    170c:	61786574 	cmnvs	r8, r4, ror r5
    1710:	41003535 	tstmi	r0, r5, lsr r5
    1714:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    1718:	415f5343 	cmpmi	pc, r3, asr #6
    171c:	53435041 	movtpl	r5, #12353	; 0x3041
    1720:	5046565f 	subpl	r5, r6, pc, asr r6
    1724:	52415400 	subpl	r5, r1, #0, 8
    1728:	5f544547 	svcpl	0x00544547
    172c:	5f555043 	svcpl	0x00555043
    1730:	6d6d7769 	stclvs	7, cr7, [sp, #-420]!	; 0xfffffe5c
    1734:	00327478 	eorseq	r7, r2, r8, ror r4
    1738:	5f617369 	svcpl	0x00617369
    173c:	5f746962 	svcpl	0x00746962
    1740:	6e6f656e 	cdpvs	5, 6, cr6, cr15, cr14, {3}
    1744:	6d726100 	ldfvse	f6, [r2, #-0]
    1748:	7570665f 	ldrbvc	r6, [r0, #-1631]!	; 0xfffff9a1
    174c:	7474615f 	ldrbtvc	r6, [r4], #-351	; 0xfffffea1
    1750:	73690072 	cmnvc	r9, #114	; 0x72
    1754:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1758:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    175c:	6537766d 	ldrvs	r7, [r7, #-1645]!	; 0xfffff993
    1760:	4154006d 	cmpmi	r4, sp, rrx
    1764:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1768:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    176c:	3661665f 			; <UNDEFINED> instruction: 0x3661665f
    1770:	65743632 	ldrbvs	r3, [r4, #-1586]!	; 0xfffff9ce
    1774:	52415400 	subpl	r5, r1, #0, 8
    1778:	5f544547 	svcpl	0x00544547
    177c:	5f555043 	svcpl	0x00555043
    1780:	7672616d 	ldrbtvc	r6, [r2], -sp, ror #2
    1784:	5f6c6c65 	svcpl	0x006c6c65
    1788:	00346a70 	eorseq	r6, r4, r0, ror sl
    178c:	62617468 	rsbvs	r7, r1, #104, 8	; 0x68000000
    1790:	7361685f 	cmnvc	r1, #6225920	; 0x5f0000
    1794:	6f705f68 	svcvs	0x00705f68
    1798:	65746e69 	ldrbvs	r6, [r4, #-3689]!	; 0xfffff197
    179c:	72610072 	rsbvc	r0, r1, #114	; 0x72
    17a0:	75745f6d 	ldrbvc	r5, [r4, #-3949]!	; 0xfffff093
    17a4:	635f656e 	cmpvs	pc, #461373440	; 0x1b800000
    17a8:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    17ac:	39615f78 	stmdbcc	r1!, {r3, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    17b0:	61736900 	cmnvs	r3, r0, lsl #18
    17b4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    17b8:	6d77695f 			; <UNDEFINED> instruction: 0x6d77695f
    17bc:	3274786d 	rsbscc	r7, r4, #7143424	; 0x6d0000
    17c0:	52415400 	subpl	r5, r1, #0, 8
    17c4:	5f544547 	svcpl	0x00544547
    17c8:	5f555043 	svcpl	0x00555043
    17cc:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    17d0:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    17d4:	726f6332 	rsbvc	r6, pc, #-939524096	; 0xc8000000
    17d8:	61786574 	cmnvs	r8, r4, ror r5
    17dc:	69003335 	stmdbvs	r0, {r0, r2, r4, r5, r8, r9, ip, sp}
    17e0:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    17e4:	745f7469 	ldrbvc	r7, [pc], #-1129	; 17ec <CPSR_IRQ_INHIBIT+0x176c>
    17e8:	626d7568 	rsbvs	r7, sp, #104, 10	; 0x1a000000
    17ec:	41420032 	cmpmi	r2, r2, lsr r0
    17f0:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    17f4:	5f484352 	svcpl	0x00484352
    17f8:	69004137 	stmdbvs	r0, {r0, r1, r2, r4, r5, r8, lr}
    17fc:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1800:	645f7469 	ldrbvs	r7, [pc], #-1129	; 1808 <CPSR_IRQ_INHIBIT+0x1788>
    1804:	7270746f 	rsbsvc	r7, r0, #1862270976	; 0x6f000000
    1808:	6100646f 	tstvs	r0, pc, ror #8
    180c:	665f6d72 			; <UNDEFINED> instruction: 0x665f6d72
    1810:	5f363170 	svcpl	0x00363170
    1814:	65707974 	ldrbvs	r7, [r0, #-2420]!	; 0xfffff68c
    1818:	646f6e5f 	strbtvs	r6, [pc], #-3679	; 1820 <CPSR_IRQ_INHIBIT+0x17a0>
    181c:	52410065 	subpl	r0, r1, #101	; 0x65
    1820:	494d5f4d 	stmdbmi	sp, {r0, r2, r3, r6, r8, r9, sl, fp, ip, lr}^
    1824:	6d726100 	ldfvse	f6, [r2, #-0]
    1828:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    182c:	006b3668 	rsbeq	r3, fp, r8, ror #12
    1830:	5f6d7261 	svcpl	0x006d7261
    1834:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1838:	42006d36 	andmi	r6, r0, #3456	; 0xd80
    183c:	5f455341 	svcpl	0x00455341
    1840:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1844:	0052375f 	subseq	r3, r2, pc, asr r7
    1848:	6f705f5f 	svcvs	0x00705f5f
    184c:	756f6370 	strbvc	r6, [pc, #-880]!	; 14e4 <CPSR_IRQ_INHIBIT+0x1464>
    1850:	745f746e 	ldrbvc	r7, [pc], #-1134	; 1858 <CPSR_IRQ_INHIBIT+0x17d8>
    1854:	2f006261 	svccs	0x00006261
    1858:	6c697562 	cfstr64vs	mvdx7, [r9], #-392	; 0xfffffe78
    185c:	63672f64 	cmnvs	r7, #100, 30	; 0x190
    1860:	72612d63 	rsbvc	r2, r1, #6336	; 0x18c0
    1864:	6f6e2d6d 	svcvs	0x006e2d6d
    1868:	652d656e 	strvs	r6, [sp, #-1390]!	; 0xfffffa92
    186c:	2d696261 	sfmcs	f6, 2, [r9, #-388]!	; 0xfffffe7c
    1870:	6b396c47 	blvs	e5c994 <_bss_end+0xe53ab0>
    1874:	672f3954 			; <UNDEFINED> instruction: 0x672f3954
    1878:	612d6363 			; <UNDEFINED> instruction: 0x612d6363
    187c:	6e2d6d72 	mcrvs	13, 1, r6, cr13, cr2, {3}
    1880:	2d656e6f 	stclcs	14, cr6, [r5, #-444]!	; 0xfffffe44
    1884:	69626165 	stmdbvs	r2!, {r0, r2, r5, r6, r8, sp, lr}^
    1888:	322d392d 	eorcc	r3, sp, #737280	; 0xb4000
    188c:	2d393130 	ldfcss	f3, [r9, #-192]!	; 0xffffff40
    1890:	622f3471 	eorvs	r3, pc, #1895825408	; 0x71000000
    1894:	646c6975 	strbtvs	r6, [ip], #-2421	; 0xfffff68b
    1898:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
    189c:	6e6f6e2d 	cdpvs	14, 6, cr6, cr15, cr13, {1}
    18a0:	61652d65 	cmnvs	r5, r5, ror #26
    18a4:	612f6962 			; <UNDEFINED> instruction: 0x612f6962
    18a8:	762f6d72 			; <UNDEFINED> instruction: 0x762f6d72
    18ac:	2f657435 	svccs	0x00657435
    18b0:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
    18b4:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    18b8:	00636367 	rsbeq	r6, r3, r7, ror #6
    18bc:	5f617369 	svcpl	0x00617369
    18c0:	5f746962 	svcpl	0x00746962
    18c4:	65736d63 	ldrbvs	r6, [r3, #-3427]!	; 0xfffff29d
    18c8:	52415400 	subpl	r5, r1, #0, 8
    18cc:	5f544547 	svcpl	0x00544547
    18d0:	5f555043 	svcpl	0x00555043
    18d4:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    18d8:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    18dc:	41540033 	cmpmi	r4, r3, lsr r0
    18e0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    18e4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    18e8:	6e65675f 	mcrvs	7, 3, r6, cr5, cr15, {2}
    18ec:	63697265 	cmnvs	r9, #1342177286	; 0x50000006
    18f0:	00613776 	rsbeq	r3, r1, r6, ror r7
    18f4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    18f8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    18fc:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1900:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1904:	36376178 			; <UNDEFINED> instruction: 0x36376178
    1908:	6d726100 	ldfvse	f6, [r2, #-0]
    190c:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1910:	6f6e5f68 	svcvs	0x006e5f68
    1914:	6c6f765f 	stclvs	6, cr7, [pc], #-380	; 17a0 <CPSR_IRQ_INHIBIT+0x1720>
    1918:	6c697461 	cfstrdvs	mvd7, [r9], #-388	; 0xfffffe7c
    191c:	65635f65 	strbvs	r5, [r3, #-3941]!	; 0xfffff09b
    1920:	53414200 	movtpl	r4, #4608	; 0x1200
    1924:	52415f45 	subpl	r5, r1, #276	; 0x114
    1928:	385f4843 	ldmdacc	pc, {r0, r1, r6, fp, lr}^	; <UNPREDICTABLE>
    192c:	73690041 	cmnvc	r9, #65	; 0x41
    1930:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1934:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1938:	7435766d 	ldrtvc	r7, [r5], #-1645	; 0xfffff993
    193c:	53414200 	movtpl	r4, #4608	; 0x1200
    1940:	52415f45 	subpl	r5, r1, #276	; 0x114
    1944:	385f4843 	ldmdacc	pc, {r0, r1, r6, fp, lr}^	; <UNPREDICTABLE>
    1948:	41540052 	cmpmi	r4, r2, asr r0
    194c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1950:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1954:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1958:	61786574 	cmnvs	r8, r4, ror r5
    195c:	6f633337 	svcvs	0x00633337
    1960:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1964:	00353361 	eorseq	r3, r5, r1, ror #6
    1968:	5f4d5241 	svcpl	0x004d5241
    196c:	6100564e 	tstvs	r0, lr, asr #12
    1970:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1974:	34686372 	strbtcc	r6, [r8], #-882	; 0xfffffc8e
    1978:	6d726100 	ldfvse	f6, [r2, #-0]
    197c:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1980:	61003668 	tstvs	r0, r8, ror #12
    1984:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1988:	37686372 			; <UNDEFINED> instruction: 0x37686372
    198c:	6d726100 	ldfvse	f6, [r2, #-0]
    1990:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1994:	6c003868 	stcvs	8, cr3, [r0], {104}	; 0x68
    1998:	20676e6f 	rsbcs	r6, r7, pc, ror #28
    199c:	62756f64 	rsbsvs	r6, r5, #100, 30	; 0x190
    19a0:	6100656c 	tstvs	r0, ip, ror #10
    19a4:	745f6d72 	ldrbvc	r6, [pc], #-3442	; 19ac <CPSR_IRQ_INHIBIT+0x192c>
    19a8:	5f656e75 	svcpl	0x00656e75
    19ac:	61637378 	smcvs	14136	; 0x3738
    19b0:	6d00656c 	cfstr32vs	mvfx6, [r0, #-432]	; 0xfffffe50
    19b4:	6e696b61 	vnmulvs.f64	d22, d9, d17
    19b8:	6f635f67 	svcvs	0x00635f67
    19bc:	5f74736e 	svcpl	0x0074736e
    19c0:	6c626174 	stfvse	f6, [r2], #-464	; 0xfffffe30
    19c4:	68740065 	ldmdavs	r4!, {r0, r2, r5, r6}^
    19c8:	5f626d75 	svcpl	0x00626d75
    19cc:	6c6c6163 	stfvse	f6, [ip], #-396	; 0xfffffe74
    19d0:	6169765f 	cmnvs	r9, pc, asr r6
    19d4:	62616c5f 	rsbvs	r6, r1, #24320	; 0x5f00
    19d8:	69006c65 	stmdbvs	r0, {r0, r2, r5, r6, sl, fp, sp, lr}
    19dc:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    19e0:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    19e4:	00357670 	eorseq	r7, r5, r0, ror r6
    19e8:	5f617369 	svcpl	0x00617369
    19ec:	5f746962 	svcpl	0x00746962
    19f0:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    19f4:	54006b36 	strpl	r6, [r0], #-2870	; 0xfffff4ca
    19f8:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    19fc:	50435f54 	subpl	r5, r3, r4, asr pc
    1a00:	6f635f55 	svcvs	0x00635f55
    1a04:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1a08:	54003761 	strpl	r3, [r0], #-1889	; 0xfffff89f
    1a0c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1a10:	50435f54 	subpl	r5, r3, r4, asr pc
    1a14:	6f635f55 	svcvs	0x00635f55
    1a18:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1a1c:	54003861 	strpl	r3, [r0], #-2145	; 0xfffff79f
    1a20:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1a24:	50435f54 	subpl	r5, r3, r4, asr pc
    1a28:	6f635f55 	svcvs	0x00635f55
    1a2c:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1a30:	41003961 	tstmi	r0, r1, ror #18
    1a34:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    1a38:	415f5343 	cmpmi	pc, r3, asr #6
    1a3c:	00534350 	subseq	r4, r3, r0, asr r3
    1a40:	5f4d5241 	svcpl	0x004d5241
    1a44:	5f534350 	svcpl	0x00534350
    1a48:	43505441 	cmpmi	r0, #1090519040	; 0x41000000
    1a4c:	6f630053 	svcvs	0x00630053
    1a50:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
    1a54:	6f642078 	svcvs	0x00642078
    1a58:	656c6275 	strbvs	r6, [ip, #-629]!	; 0xfffffd8b
    1a5c:	52415400 	subpl	r5, r1, #0, 8
    1a60:	5f544547 	svcpl	0x00544547
    1a64:	5f555043 	svcpl	0x00555043
    1a68:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1a6c:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    1a70:	726f6333 	rsbvc	r6, pc, #-872415232	; 0xcc000000
    1a74:	61786574 	cmnvs	r8, r4, ror r5
    1a78:	54003335 	strpl	r3, [r0], #-821	; 0xfffffccb
    1a7c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1a80:	50435f54 	subpl	r5, r3, r4, asr pc
    1a84:	6f635f55 	svcvs	0x00635f55
    1a88:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1a8c:	6c70306d 	ldclvs	0, cr3, [r0], #-436	; 0xfffffe4c
    1a90:	61007375 	tstvs	r0, r5, ror r3
    1a94:	635f6d72 	cmpvs	pc, #7296	; 0x1c80
    1a98:	73690063 	cmnvc	r9, #99	; 0x63
    1a9c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1aa0:	73785f74 	cmnvc	r8, #116, 30	; 0x1d0
    1aa4:	656c6163 	strbvs	r6, [ip, #-355]!	; 0xfffffe9d
    1aa8:	6f645f00 	svcvs	0x00645f00
    1aac:	755f746e 	ldrbvc	r7, [pc, #-1134]	; 1646 <CPSR_IRQ_INHIBIT+0x15c6>
    1ab0:	745f6573 	ldrbvc	r6, [pc], #-1395	; 1ab8 <CPSR_IRQ_INHIBIT+0x1a38>
    1ab4:	5f656572 	svcpl	0x00656572
    1ab8:	65726568 	ldrbvs	r6, [r2, #-1384]!	; 0xfffffa98
    1abc:	4154005f 	cmpmi	r4, pc, asr r0
    1ac0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1ac4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1ac8:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1acc:	64743031 	ldrbtvs	r3, [r4], #-49	; 0xffffffcf
    1ad0:	5400696d 	strpl	r6, [r0], #-2413	; 0xfffff693
    1ad4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1ad8:	50435f54 	subpl	r5, r3, r4, asr pc
    1adc:	6f635f55 	svcvs	0x00635f55
    1ae0:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1ae4:	62003561 	andvs	r3, r0, #406847488	; 0x18400000
    1ae8:	5f657361 	svcpl	0x00657361
    1aec:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1af0:	63657469 	cmnvs	r5, #1761607680	; 0x69000000
    1af4:	65727574 	ldrbvs	r7, [r2, #-1396]!	; 0xfffffa8c
    1af8:	6d726100 	ldfvse	f6, [r2, #-0]
    1afc:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1b00:	72635f68 	rsbvc	r5, r3, #104, 30	; 0x1a0
    1b04:	41540063 	cmpmi	r4, r3, rrx
    1b08:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1b0c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1b10:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1b14:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    1b18:	616d7331 	cmnvs	sp, r1, lsr r3
    1b1c:	756d6c6c 	strbvc	r6, [sp, #-3180]!	; 0xfffff394
    1b20:	7069746c 	rsbvc	r7, r9, ip, ror #8
    1b24:	6100796c 	tstvs	r0, ip, ror #18
    1b28:	635f6d72 	cmpvs	pc, #7296	; 0x1c80
    1b2c:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
    1b30:	635f746e 	cmpvs	pc, #1845493760	; 0x6e000000
    1b34:	73690063 	cmnvc	r9, #99	; 0x63
    1b38:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1b3c:	72635f74 	rsbvc	r5, r3, #116, 30	; 0x1d0
    1b40:	00323363 	eorseq	r3, r2, r3, ror #6
    1b44:	5f4d5241 	svcpl	0x004d5241
    1b48:	69004c50 	stmdbvs	r0, {r4, r6, sl, fp, lr}
    1b4c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1b50:	765f7469 	ldrbvc	r7, [pc], -r9, ror #8
    1b54:	33767066 	cmncc	r6, #102	; 0x66
    1b58:	61736900 	cmnvs	r3, r0, lsl #18
    1b5c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1b60:	7066765f 	rsbvc	r7, r6, pc, asr r6
    1b64:	42003476 	andmi	r3, r0, #1979711488	; 0x76000000
    1b68:	5f455341 	svcpl	0x00455341
    1b6c:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1b70:	3254365f 	subscc	r3, r4, #99614720	; 0x5f00000
    1b74:	53414200 	movtpl	r4, #4608	; 0x1200
    1b78:	52415f45 	subpl	r5, r1, #276	; 0x114
    1b7c:	385f4843 	ldmdacc	pc, {r0, r1, r6, fp, lr}^	; <UNPREDICTABLE>
    1b80:	414d5f4d 	cmpmi	sp, sp, asr #30
    1b84:	54004e49 	strpl	r4, [r0], #-3657	; 0xfffff1b7
    1b88:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1b8c:	50435f54 	subpl	r5, r3, r4, asr pc
    1b90:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1b94:	6474396d 	ldrbtvs	r3, [r4], #-2413	; 0xfffff693
    1b98:	4100696d 	tstmi	r0, sp, ror #18
    1b9c:	415f4d52 	cmpmi	pc, r2, asr sp	; <UNPREDICTABLE>
    1ba0:	4142004c 	cmpmi	r2, ip, asr #32
    1ba4:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1ba8:	5f484352 	svcpl	0x00484352
    1bac:	61004d37 	tstvs	r0, r7, lsr sp
    1bb0:	745f6d72 	ldrbvc	r6, [pc], #-3442	; 1bb8 <CPSR_IRQ_INHIBIT+0x1b38>
    1bb4:	65677261 	strbvs	r7, [r7, #-609]!	; 0xfffffd9f
    1bb8:	616c5f74 	smcvs	50676	; 0xc5f4
    1bbc:	006c6562 	rsbeq	r6, ip, r2, ror #10
    1bc0:	5f6d7261 	svcpl	0x006d7261
    1bc4:	67726174 			; <UNDEFINED> instruction: 0x67726174
    1bc8:	695f7465 	ldmdbvs	pc, {r0, r2, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    1bcc:	006e736e 	rsbeq	r7, lr, lr, ror #6
    1bd0:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1bd4:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1bd8:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1bdc:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1be0:	00347278 	eorseq	r7, r4, r8, ror r2
    1be4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1be8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1bec:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1bf0:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1bf4:	00357278 	eorseq	r7, r5, r8, ror r2
    1bf8:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1bfc:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1c00:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1c04:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1c08:	00377278 	eorseq	r7, r7, r8, ror r2
    1c0c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1c10:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1c14:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1c18:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1c1c:	00387278 	eorseq	r7, r8, r8, ror r2
    1c20:	5f617369 	svcpl	0x00617369
    1c24:	5f746962 	svcpl	0x00746962
    1c28:	6561706c 	strbvs	r7, [r1, #-108]!	; 0xffffff94
    1c2c:	61736900 	cmnvs	r3, r0, lsl #18
    1c30:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1c34:	6975715f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, r8, ip, sp, lr}^
    1c38:	615f6b72 	cmpvs	pc, r2, ror fp	; <UNPREDICTABLE>
    1c3c:	36766d72 			; <UNDEFINED> instruction: 0x36766d72
    1c40:	69007a6b 	stmdbvs	r0, {r0, r1, r3, r5, r6, r9, fp, ip, sp, lr}
    1c44:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1c48:	6e5f7469 	cdpvs	4, 5, cr7, cr15, cr9, {3}
    1c4c:	006d746f 	rsbeq	r7, sp, pc, ror #8
    1c50:	5f617369 	svcpl	0x00617369
    1c54:	5f746962 	svcpl	0x00746962
    1c58:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1c5c:	73690034 	cmnvc	r9, #52	; 0x34
    1c60:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1c64:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1c68:	0036766d 	eorseq	r7, r6, sp, ror #12
    1c6c:	5f617369 	svcpl	0x00617369
    1c70:	5f746962 	svcpl	0x00746962
    1c74:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1c78:	73690037 	cmnvc	r9, #55	; 0x37
    1c7c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1c80:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1c84:	0038766d 	eorseq	r7, r8, sp, ror #12
    1c88:	6e6f645f 	mcrvs	4, 3, r6, cr15, cr15, {2}
    1c8c:	73755f74 	cmnvc	r5, #116, 30	; 0x1d0
    1c90:	74725f65 	ldrbtvc	r5, [r2], #-3941	; 0xfffff09b
    1c94:	65685f78 	strbvs	r5, [r8, #-3960]!	; 0xfffff088
    1c98:	005f6572 	subseq	r6, pc, r2, ror r5	; <UNPREDICTABLE>
    1c9c:	74495155 	strbvc	r5, [r9], #-341	; 0xfffffeab
    1ca0:	00657079 	rsbeq	r7, r5, r9, ror r0
    1ca4:	5f617369 	svcpl	0x00617369
    1ca8:	5f746962 	svcpl	0x00746962
    1cac:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1cb0:	00657435 	rsbeq	r7, r5, r5, lsr r4
    1cb4:	5f6d7261 	svcpl	0x006d7261
    1cb8:	656e7574 	strbvs	r7, [lr, #-1396]!	; 0xfffffa8c
    1cbc:	6d726100 	ldfvse	f6, [r2, #-0]
    1cc0:	7070635f 	rsbsvc	r6, r0, pc, asr r3
    1cc4:	746e695f 	strbtvc	r6, [lr], #-2399	; 0xfffff6a1
    1cc8:	6f777265 	svcvs	0x00777265
    1ccc:	66006b72 			; <UNDEFINED> instruction: 0x66006b72
    1cd0:	5f636e75 	svcpl	0x00636e75
    1cd4:	00727470 	rsbseq	r7, r2, r0, ror r4
    1cd8:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1cdc:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1ce0:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1ce4:	32396d72 	eorscc	r6, r9, #7296	; 0x1c80
    1ce8:	68007430 	stmdavs	r0, {r4, r5, sl, ip, sp, lr}
    1cec:	5f626174 	svcpl	0x00626174
    1cf0:	54007165 	strpl	r7, [r0], #-357	; 0xfffffe9b
    1cf4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1cf8:	50435f54 	subpl	r5, r3, r4, asr pc
    1cfc:	61665f55 	cmnvs	r6, r5, asr pc
    1d00:	00363235 	eorseq	r3, r6, r5, lsr r2
    1d04:	5f6d7261 	svcpl	0x006d7261
    1d08:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1d0c:	7568745f 	strbvc	r7, [r8, #-1119]!	; 0xfffffba1
    1d10:	685f626d 	ldmdavs	pc, {r0, r2, r3, r5, r6, r9, sp, lr}^	; <UNPREDICTABLE>
    1d14:	76696477 			; <UNDEFINED> instruction: 0x76696477
    1d18:	61746800 	cmnvs	r4, r0, lsl #16
    1d1c:	71655f62 	cmnvc	r5, r2, ror #30
    1d20:	696f705f 	stmdbvs	pc!, {r0, r1, r2, r3, r4, r6, ip, sp, lr}^	; <UNPREDICTABLE>
    1d24:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
    1d28:	6d726100 	ldfvse	f6, [r2, #-0]
    1d2c:	6369705f 	cmnvs	r9, #95	; 0x5f
    1d30:	6765725f 			; <UNDEFINED> instruction: 0x6765725f
    1d34:	65747369 	ldrbvs	r7, [r4, #-873]!	; 0xfffffc97
    1d38:	41540072 	cmpmi	r4, r2, ror r0
    1d3c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1d40:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1d44:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1d48:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    1d4c:	616d7330 	cmnvs	sp, r0, lsr r3
    1d50:	756d6c6c 	strbvc	r6, [sp, #-3180]!	; 0xfffff394
    1d54:	7069746c 	rsbvc	r7, r9, ip, ror #8
    1d58:	5400796c 	strpl	r7, [r0], #-2412	; 0xfffff694
    1d5c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1d60:	50435f54 	subpl	r5, r3, r4, asr pc
    1d64:	706d5f55 	rsbvc	r5, sp, r5, asr pc
    1d68:	65726f63 	ldrbvs	r6, [r2, #-3939]!	; 0xfffff09d
    1d6c:	66766f6e 	ldrbtvs	r6, [r6], -lr, ror #30
    1d70:	73690070 	cmnvc	r9, #112	; 0x70
    1d74:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1d78:	75715f74 	ldrbvc	r5, [r1, #-3956]!	; 0xfffff08c
    1d7c:	5f6b7269 	svcpl	0x006b7269
    1d80:	5f336d63 	svcpl	0x00336d63
    1d84:	6472646c 	ldrbtvs	r6, [r2], #-1132	; 0xfffffb94
    1d88:	4d524100 	ldfmie	f4, [r2, #-0]
    1d8c:	0043435f 	subeq	r4, r3, pc, asr r3
    1d90:	5f6d7261 	svcpl	0x006d7261
    1d94:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1d98:	00325f38 	eorseq	r5, r2, r8, lsr pc
    1d9c:	5f6d7261 	svcpl	0x006d7261
    1da0:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1da4:	00335f38 	eorseq	r5, r3, r8, lsr pc
    1da8:	5f6d7261 	svcpl	0x006d7261
    1dac:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1db0:	00345f38 	eorseq	r5, r4, r8, lsr pc
    1db4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1db8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1dbc:	665f5550 			; <UNDEFINED> instruction: 0x665f5550
    1dc0:	3236706d 	eorscc	r7, r6, #109	; 0x6d
    1dc4:	52410036 	subpl	r0, r1, #54	; 0x36
    1dc8:	53435f4d 	movtpl	r5, #16205	; 0x3f4d
    1dcc:	6d726100 	ldfvse	f6, [r2, #-0]
    1dd0:	3170665f 	cmncc	r0, pc, asr r6
    1dd4:	6e695f36 	mcrvs	15, 3, r5, cr9, cr6, {1}
    1dd8:	61007473 	tstvs	r0, r3, ror r4
    1ddc:	625f6d72 	subsvs	r6, pc, #7296	; 0x1c80
    1de0:	5f657361 	svcpl	0x00657361
    1de4:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1de8:	52415400 	subpl	r5, r1, #0, 8
    1dec:	5f544547 	svcpl	0x00544547
    1df0:	5f555043 	svcpl	0x00555043
    1df4:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1df8:	31617865 	cmncc	r1, r5, ror #16
    1dfc:	726f6335 	rsbvc	r6, pc, #-738197504	; 0xd4000000
    1e00:	61786574 	cmnvs	r8, r4, ror r5
    1e04:	72610037 	rsbvc	r0, r1, #55	; 0x37
    1e08:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    1e0c:	65376863 	ldrvs	r6, [r7, #-2147]!	; 0xfffff79d
    1e10:	4154006d 	cmpmi	r4, sp, rrx
    1e14:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1e18:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1e1c:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1e20:	61786574 	cmnvs	r8, r4, ror r5
    1e24:	61003237 	tstvs	r0, r7, lsr r2
    1e28:	705f6d72 	subsvc	r6, pc, r2, ror sp	; <UNPREDICTABLE>
    1e2c:	645f7363 	ldrbvs	r7, [pc], #-867	; 1e34 <CPSR_IRQ_INHIBIT+0x1db4>
    1e30:	75616665 	strbvc	r6, [r1, #-1637]!	; 0xfffff99b
    1e34:	4100746c 	tstmi	r0, ip, ror #8
    1e38:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    1e3c:	415f5343 	cmpmi	pc, r3, asr #6
    1e40:	53435041 	movtpl	r5, #12353	; 0x3041
    1e44:	434f4c5f 	movtmi	r4, #64607	; 0xfc5f
    1e48:	54004c41 	strpl	r4, [r0], #-3137	; 0xfffff3bf
    1e4c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1e50:	50435f54 	subpl	r5, r3, r4, asr pc
    1e54:	6f635f55 	svcvs	0x00635f55
    1e58:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1e5c:	00353761 	eorseq	r3, r5, r1, ror #14
    1e60:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1e64:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1e68:	735f5550 	cmpvc	pc, #80, 10	; 0x14000000
    1e6c:	6e6f7274 	mcrvs	2, 3, r7, cr15, cr4, {3}
    1e70:	6d726167 	ldfvse	f6, [r2, #-412]!	; 0xfffffe64
    1e74:	6d726100 	ldfvse	f6, [r2, #-0]
    1e78:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1e7c:	68745f68 	ldmdavs	r4!, {r3, r5, r6, r8, r9, sl, fp, ip, lr}^
    1e80:	31626d75 	smccc	9941	; 0x26d5
    1e84:	6d726100 	ldfvse	f6, [r2, #-0]
    1e88:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1e8c:	68745f68 	ldmdavs	r4!, {r3, r5, r6, r8, r9, sl, fp, ip, lr}^
    1e90:	32626d75 	rsbcc	r6, r2, #7488	; 0x1d40
    1e94:	52415400 	subpl	r5, r1, #0, 8
    1e98:	5f544547 	svcpl	0x00544547
    1e9c:	5f555043 	svcpl	0x00555043
    1ea0:	6d6d7769 	stclvs	7, cr7, [sp, #-420]!	; 0xfffffe5c
    1ea4:	61007478 	tstvs	r0, r8, ror r4
    1ea8:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1eac:	35686372 	strbcc	r6, [r8, #-882]!	; 0xfffffc8e
    1eb0:	73690074 	cmnvc	r9, #116	; 0x74
    1eb4:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1eb8:	706d5f74 	rsbvc	r5, sp, r4, ror pc
    1ebc:	6d726100 	ldfvse	f6, [r2, #-0]
    1ec0:	5f646c5f 	svcpl	0x00646c5f
    1ec4:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
    1ec8:	72610064 	rsbvc	r0, r1, #100	; 0x64
    1ecc:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    1ed0:	5f386863 	svcpl	0x00386863
    1ed4:	Address 0x0000000000001ed4 is out of bounds.


Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347 	bcc	10d0d24 <_bss_end+0x10c7e40>
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
  10:	4b5a3605 	blmi	168d82c <_bss_end+0x1684948>
  14:	08070600 	stmdaeq	r7, {r9, sl}
  18:	0a010901 	beq	42424 <_bss_end+0x39540>
  1c:	14041202 	strne	r1, [r4], #-514	; 0xfffffdfe
  20:	17011501 	strne	r1, [r1, -r1, lsl #10]
  24:	1a011803 	bne	46038 <_bss_end+0x3d154>
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
  20:	8b040e42 	blhi	103930 <_bss_end+0xfaa4c>
  24:	0b0d4201 	bleq	350830 <_bss_end+0x34794c>
  28:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
  2c:	00000ecb 	andeq	r0, r0, fp, asr #29
  30:	0000001c 	andeq	r0, r0, ip, lsl r0
  34:	00000000 	andeq	r0, r0, r0
  38:	000080cc 	andeq	r8, r0, ip, asr #1
  3c:	0000002c 	andeq	r0, r0, ip, lsr #32
  40:	8b040e42 	blhi	103950 <_bss_end+0xfaa6c>
  44:	0b0d4201 	bleq	350850 <_bss_end+0x34796c>
  48:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
  4c:	00000ecb 	andeq	r0, r0, fp, asr #29
  50:	0000001c 	andeq	r0, r0, ip, lsl r0
  54:	00000000 	andeq	r0, r0, r0
  58:	000080f8 	strdeq	r8, [r0], -r8	; <UNPREDICTABLE>
  5c:	00000020 	andeq	r0, r0, r0, lsr #32
  60:	8b040e42 	blhi	103970 <_bss_end+0xfaa8c>
  64:	0b0d4201 	bleq	350870 <_bss_end+0x34798c>
  68:	420d0d48 	andmi	r0, sp, #72, 26	; 0x1200
  6c:	00000ecb 	andeq	r0, r0, fp, asr #29
  70:	0000001c 	andeq	r0, r0, ip, lsl r0
  74:	00000000 	andeq	r0, r0, r0
  78:	00008118 	andeq	r8, r0, r8, lsl r1
  7c:	00000018 	andeq	r0, r0, r8, lsl r0
  80:	8b040e42 	blhi	103990 <_bss_end+0xfaaac>
  84:	0b0d4201 	bleq	350890 <_bss_end+0x3479ac>
  88:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  8c:	00000ecb 	andeq	r0, r0, fp, asr #29
  90:	0000001c 	andeq	r0, r0, ip, lsl r0
  94:	00000000 	andeq	r0, r0, r0
  98:	00008130 	andeq	r8, r0, r0, lsr r1
  9c:	00000018 	andeq	r0, r0, r8, lsl r0
  a0:	8b040e42 	blhi	1039b0 <_bss_end+0xfaacc>
  a4:	0b0d4201 	bleq	3508b0 <_bss_end+0x3479cc>
  a8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  ac:	00000ecb 	andeq	r0, r0, fp, asr #29
  b0:	0000001c 	andeq	r0, r0, ip, lsl r0
  b4:	00000000 	andeq	r0, r0, r0
  b8:	00008148 	andeq	r8, r0, r8, asr #2
  bc:	00000018 	andeq	r0, r0, r8, lsl r0
  c0:	8b040e42 	blhi	1039d0 <_bss_end+0xfaaec>
  c4:	0b0d4201 	bleq	3508d0 <_bss_end+0x3479ec>
  c8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  cc:	00000ecb 	andeq	r0, r0, fp, asr #29
  d0:	00000014 	andeq	r0, r0, r4, lsl r0
  d4:	00000000 	andeq	r0, r0, r0
  d8:	00008160 	andeq	r8, r0, r0, ror #2
  dc:	0000000c 	andeq	r0, r0, ip
  e0:	8b040e42 	blhi	1039f0 <_bss_end+0xfab0c>
  e4:	0b0d4201 	bleq	3508f0 <_bss_end+0x347a0c>
  e8:	0000000c 	andeq	r0, r0, ip
  ec:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  f0:	7c020001 	stcvc	0, cr0, [r2], {1}
  f4:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  f8:	0000001c 	andeq	r0, r0, ip, lsl r0
  fc:	000000e8 	andeq	r0, r0, r8, ror #1
 100:	0000816c 	andeq	r8, r0, ip, ror #2
 104:	00000034 	andeq	r0, r0, r4, lsr r0
 108:	8b040e42 	blhi	103a18 <_bss_end+0xfab34>
 10c:	0b0d4201 	bleq	350918 <_bss_end+0x347a34>
 110:	420d0d52 	andmi	r0, sp, #5248	; 0x1480
 114:	00000ecb 	andeq	r0, r0, fp, asr #29
 118:	0000001c 	andeq	r0, r0, ip, lsl r0
 11c:	000000e8 	andeq	r0, r0, r8, ror #1
 120:	000081a0 	andeq	r8, r0, r0, lsr #3
 124:	00000114 	andeq	r0, r0, r4, lsl r1
 128:	8b040e42 	blhi	103a38 <_bss_end+0xfab54>
 12c:	0b0d4201 	bleq	350938 <_bss_end+0x347a54>
 130:	0d0d8002 	stceq	0, cr8, [sp, #-8]
 134:	000ecb42 	andeq	ip, lr, r2, asr #22
 138:	0000001c 	andeq	r0, r0, ip, lsl r0
 13c:	000000e8 	andeq	r0, r0, r8, ror #1
 140:	000082b4 			; <UNDEFINED> instruction: 0x000082b4
 144:	00000074 	andeq	r0, r0, r4, ror r0
 148:	8b040e42 	blhi	103a58 <_bss_end+0xfab74>
 14c:	0b0d4201 	bleq	350958 <_bss_end+0x347a74>
 150:	420d0d72 	andmi	r0, sp, #7296	; 0x1c80
 154:	00000ecb 	andeq	r0, r0, fp, asr #29
 158:	0000001c 	andeq	r0, r0, ip, lsl r0
 15c:	000000e8 	andeq	r0, r0, r8, ror #1
 160:	00008328 	andeq	r8, r0, r8, lsr #6
 164:	00000074 	andeq	r0, r0, r4, ror r0
 168:	8b040e42 	blhi	103a78 <_bss_end+0xfab94>
 16c:	0b0d4201 	bleq	350978 <_bss_end+0x347a94>
 170:	420d0d72 	andmi	r0, sp, #7296	; 0x1c80
 174:	00000ecb 	andeq	r0, r0, fp, asr #29
 178:	0000001c 	andeq	r0, r0, ip, lsl r0
 17c:	000000e8 	andeq	r0, r0, r8, ror #1
 180:	0000839c 	muleq	r0, ip, r3
 184:	00000074 	andeq	r0, r0, r4, ror r0
 188:	8b040e42 	blhi	103a98 <_bss_end+0xfabb4>
 18c:	0b0d4201 	bleq	350998 <_bss_end+0x347ab4>
 190:	420d0d72 	andmi	r0, sp, #7296	; 0x1c80
 194:	00000ecb 	andeq	r0, r0, fp, asr #29
 198:	0000001c 	andeq	r0, r0, ip, lsl r0
 19c:	000000e8 	andeq	r0, r0, r8, ror #1
 1a0:	00008410 	andeq	r8, r0, r0, lsl r4
 1a4:	000000a8 	andeq	r0, r0, r8, lsr #1
 1a8:	8b080e42 	blhi	203ab8 <_bss_end+0x1fabd4>
 1ac:	42018e02 	andmi	r8, r1, #2, 28
 1b0:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 1b4:	080d0c4e 	stmdaeq	sp, {r1, r2, r3, r6, sl, fp}
 1b8:	0000001c 	andeq	r0, r0, ip, lsl r0
 1bc:	000000e8 	andeq	r0, r0, r8, ror #1
 1c0:	000084b8 			; <UNDEFINED> instruction: 0x000084b8
 1c4:	0000007c 	andeq	r0, r0, ip, ror r0
 1c8:	8b080e42 	blhi	203ad8 <_bss_end+0x1fabf4>
 1cc:	42018e02 	andmi	r8, r1, #2, 28
 1d0:	78040b0c 	stmdavc	r4, {r2, r3, r8, r9, fp}
 1d4:	00080d0c 	andeq	r0, r8, ip, lsl #26
 1d8:	0000001c 	andeq	r0, r0, ip, lsl r0
 1dc:	000000e8 	andeq	r0, r0, r8, ror #1
 1e0:	00008534 	andeq	r8, r0, r4, lsr r5
 1e4:	00000084 	andeq	r0, r0, r4, lsl #1
 1e8:	8b080e42 	blhi	203af8 <_bss_end+0x1fac14>
 1ec:	42018e02 	andmi	r8, r1, #2, 28
 1f0:	7c040b0c 			; <UNDEFINED> instruction: 0x7c040b0c
 1f4:	00080d0c 	andeq	r0, r8, ip, lsl #26
 1f8:	0000001c 	andeq	r0, r0, ip, lsl r0
 1fc:	000000e8 	andeq	r0, r0, r8, ror #1
 200:	000085b8 			; <UNDEFINED> instruction: 0x000085b8
 204:	0000010c 	andeq	r0, r0, ip, lsl #2
 208:	8b040e42 	blhi	103b18 <_bss_end+0xfac34>
 20c:	0b0d4201 	bleq	350a18 <_bss_end+0x347b34>
 210:	0d0d7e02 	stceq	14, cr7, [sp, #-8]
 214:	000ecb42 	andeq	ip, lr, r2, asr #22
 218:	0000001c 	andeq	r0, r0, ip, lsl r0
 21c:	000000e8 	andeq	r0, r0, r8, ror #1
 220:	000086c4 	andeq	r8, r0, r4, asr #13
 224:	000000b4 	strheq	r0, [r0], -r4
 228:	8b080e42 	blhi	203b38 <_bss_end+0x1fac54>
 22c:	42018e02 	andmi	r8, r1, #2, 28
 230:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 234:	080d0c54 	stmdaeq	sp, {r2, r4, r6, sl, fp}
 238:	0000001c 	andeq	r0, r0, ip, lsl r0
 23c:	000000e8 	andeq	r0, r0, r8, ror #1
 240:	00008778 	andeq	r8, r0, r8, ror r7
 244:	000000d8 	ldrdeq	r0, [r0], -r8
 248:	8b080e42 	blhi	203b58 <_bss_end+0x1fac74>
 24c:	42018e02 	andmi	r8, r1, #2, 28
 250:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 254:	080d0c66 	stmdaeq	sp, {r1, r2, r5, r6, sl, fp}
 258:	0000001c 	andeq	r0, r0, ip, lsl r0
 25c:	000000e8 	andeq	r0, r0, r8, ror #1
 260:	00008850 	andeq	r8, r0, r0, asr r8
 264:	00000074 	andeq	r0, r0, r4, ror r0
 268:	8b040e42 	blhi	103b78 <_bss_end+0xfac94>
 26c:	0b0d4201 	bleq	350a78 <_bss_end+0x347b94>
 270:	420d0d72 	andmi	r0, sp, #7296	; 0x1c80
 274:	00000ecb 	andeq	r0, r0, fp, asr #29
 278:	0000001c 	andeq	r0, r0, ip, lsl r0
 27c:	000000e8 	andeq	r0, r0, r8, ror #1
 280:	000088c4 	andeq	r8, r0, r4, asr #17
 284:	00000074 	andeq	r0, r0, r4, ror r0
 288:	8b080e42 	blhi	203b98 <_bss_end+0x1facb4>
 28c:	42018e02 	andmi	r8, r1, #2, 28
 290:	74040b0c 	strvc	r0, [r4], #-2828	; 0xfffff4f4
 294:	00080d0c 	andeq	r0, r8, ip, lsl #26
 298:	0000001c 	andeq	r0, r0, ip, lsl r0
 29c:	000000e8 	andeq	r0, r0, r8, ror #1
 2a0:	00008938 	andeq	r8, r0, r8, lsr r9
 2a4:	00000054 	andeq	r0, r0, r4, asr r0
 2a8:	8b080e42 	blhi	203bb8 <_bss_end+0x1facd4>
 2ac:	42018e02 	andmi	r8, r1, #2, 28
 2b0:	5e040b0c 	vmlapl.f64	d0, d4, d12
 2b4:	00080d0c 	andeq	r0, r8, ip, lsl #26
 2b8:	00000018 	andeq	r0, r0, r8, lsl r0
 2bc:	000000e8 	andeq	r0, r0, r8, ror #1
 2c0:	0000898c 	andeq	r8, r0, ip, lsl #19
 2c4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2c8:	8b080e42 	blhi	203bd8 <_bss_end+0x1facf4>
 2cc:	42018e02 	andmi	r8, r1, #2, 28
 2d0:	00040b0c 	andeq	r0, r4, ip, lsl #22
 2d4:	0000000c 	andeq	r0, r0, ip
 2d8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 2dc:	7c020001 	stcvc	0, cr0, [r2], {1}
 2e0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 2e4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2e8:	000002d4 	ldrdeq	r0, [r0], -r4
 2ec:	000089a8 	andeq	r8, r0, r8, lsr #19
 2f0:	00000018 	andeq	r0, r0, r8, lsl r0
 2f4:	8b040e42 	blhi	103c04 <_bss_end+0xfad20>
 2f8:	0b0d4201 	bleq	350b04 <_bss_end+0x347c20>
 2fc:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
 300:	00000ecb 	andeq	r0, r0, fp, asr #29
 304:	00000028 	andeq	r0, r0, r8, lsr #32
 308:	000002d4 	ldrdeq	r0, [r0], -r4
 30c:	000089c0 	andeq	r8, r0, r0, asr #19
 310:	0000005c 	andeq	r0, r0, ip, asr r0
 314:	80200e44 	eorhi	r0, r0, r4, asr #28
 318:	82078108 	andhi	r8, r7, #8, 2
 31c:	84058306 	strhi	r8, [r5], #-774	; 0xfffffcfa
 320:	8c038b04 			; <UNDEFINED> instruction: 0x8c038b04
 324:	42018e02 	andmi	r8, r1, #2, 28
 328:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 32c:	00200d0c 	eoreq	r0, r0, ip, lsl #26
 330:	00000014 	andeq	r0, r0, r4, lsl r0
 334:	000002d4 	ldrdeq	r0, [r0], -r4
 338:	00008a1c 	andeq	r8, r0, ip, lsl sl
 33c:	00000010 	andeq	r0, r0, r0, lsl r0
 340:	040b0c42 	streq	r0, [fp], #-3138	; 0xfffff3be
 344:	000d0c44 	andeq	r0, sp, r4, asr #24
 348:	0000001c 	andeq	r0, r0, ip, lsl r0
 34c:	000002d4 	ldrdeq	r0, [r0], -r4
 350:	00008a2c 	andeq	r8, r0, ip, lsr #20
 354:	00000034 	andeq	r0, r0, r4, lsr r0
 358:	8b040e42 	blhi	103c68 <_bss_end+0xfad84>
 35c:	0b0d4201 	bleq	350b68 <_bss_end+0x347c84>
 360:	420d0d52 	andmi	r0, sp, #5248	; 0x1480
 364:	00000ecb 	andeq	r0, r0, fp, asr #29
 368:	0000001c 	andeq	r0, r0, ip, lsl r0
 36c:	000002d4 	ldrdeq	r0, [r0], -r4
 370:	00008a60 	andeq	r8, r0, r0, ror #20
 374:	00000038 	andeq	r0, r0, r8, lsr r0
 378:	8b040e42 	blhi	103c88 <_bss_end+0xfada4>
 37c:	0b0d4201 	bleq	350b88 <_bss_end+0x347ca4>
 380:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
 384:	00000ecb 	andeq	r0, r0, fp, asr #29
 388:	00000020 	andeq	r0, r0, r0, lsr #32
 38c:	000002d4 	ldrdeq	r0, [r0], -r4
 390:	00008a98 	muleq	r0, r8, sl
 394:	00000044 	andeq	r0, r0, r4, asr #32
 398:	840c0e42 	strhi	r0, [ip], #-3650	; 0xfffff1be
 39c:	8e028b03 	vmlahi.f64	d8, d2, d3
 3a0:	0b0c4201 	bleq	310bac <_bss_end+0x307cc8>
 3a4:	0d0c5c04 	stceq	12, cr5, [ip, #-16]
 3a8:	0000000c 	andeq	r0, r0, ip
 3ac:	00000020 	andeq	r0, r0, r0, lsr #32
 3b0:	000002d4 	ldrdeq	r0, [r0], -r4
 3b4:	00008adc 	ldrdeq	r8, [r0], -ip
 3b8:	00000044 	andeq	r0, r0, r4, asr #32
 3bc:	840c0e42 	strhi	r0, [ip], #-3650	; 0xfffff1be
 3c0:	8e028b03 	vmlahi.f64	d8, d2, d3
 3c4:	0b0c4201 	bleq	310bd0 <_bss_end+0x307cec>
 3c8:	0d0c5c04 	stceq	12, cr5, [ip, #-16]
 3cc:	0000000c 	andeq	r0, r0, ip
 3d0:	00000020 	andeq	r0, r0, r0, lsr #32
 3d4:	000002d4 	ldrdeq	r0, [r0], -r4
 3d8:	00008b20 	andeq	r8, r0, r0, lsr #22
 3dc:	00000068 	andeq	r0, r0, r8, rrx
 3e0:	840c0e42 	strhi	r0, [ip], #-3650	; 0xfffff1be
 3e4:	8e028b03 	vmlahi.f64	d8, d2, d3
 3e8:	0b0c4201 	bleq	310bf4 <_bss_end+0x307d10>
 3ec:	0d0c6e04 	stceq	14, cr6, [ip, #-16]
 3f0:	0000000c 	andeq	r0, r0, ip
 3f4:	00000020 	andeq	r0, r0, r0, lsr #32
 3f8:	000002d4 	ldrdeq	r0, [r0], -r4
 3fc:	00008b88 	andeq	r8, r0, r8, lsl #23
 400:	00000068 	andeq	r0, r0, r8, rrx
 404:	840c0e42 	strhi	r0, [ip], #-3650	; 0xfffff1be
 408:	8e028b03 	vmlahi.f64	d8, d2, d3
 40c:	0b0c4201 	bleq	310c18 <_bss_end+0x307d34>
 410:	0d0c6e04 	stceq	14, cr6, [ip, #-16]
 414:	0000000c 	andeq	r0, r0, ip
 418:	0000001c 	andeq	r0, r0, ip, lsl r0
 41c:	000002d4 	ldrdeq	r0, [r0], -r4
 420:	00008bf0 	strdeq	r8, [r0], -r0
 424:	00000054 	andeq	r0, r0, r4, asr r0
 428:	8b080e42 	blhi	203d38 <_bss_end+0x1fae54>
 42c:	42018e02 	andmi	r8, r1, #2, 28
 430:	5e040b0c 	vmlapl.f64	d0, d4, d12
 434:	00080d0c 	andeq	r0, r8, ip, lsl #26
 438:	00000018 	andeq	r0, r0, r8, lsl r0
 43c:	000002d4 	ldrdeq	r0, [r0], -r4
 440:	00008c44 	andeq	r8, r0, r4, asr #24
 444:	0000001c 	andeq	r0, r0, ip, lsl r0
 448:	8b080e42 	blhi	203d58 <_bss_end+0x1fae74>
 44c:	42018e02 	andmi	r8, r1, #2, 28
 450:	00040b0c 	andeq	r0, r4, ip, lsl #22
 454:	0000000c 	andeq	r0, r0, ip
 458:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 45c:	7c020001 	stcvc	0, cr0, [r2], {1}
 460:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 464:	00000018 	andeq	r0, r0, r8, lsl r0
 468:	00000454 	andeq	r0, r0, r4, asr r4
 46c:	00008c60 	andeq	r8, r0, r0, ror #24
 470:	00000064 	andeq	r0, r0, r4, rrx
 474:	8b080e42 	blhi	203d84 <_bss_end+0x1faea0>
 478:	42018e02 	andmi	r8, r1, #2, 28
 47c:	00040b0c 	andeq	r0, r4, ip, lsl #22
 480:	0000000c 	andeq	r0, r0, ip
 484:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 488:	7c020001 	stcvc	0, cr0, [r2], {1}
 48c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 490:	0000001c 	andeq	r0, r0, ip, lsl r0
 494:	00000480 	andeq	r0, r0, r0, lsl #9
 498:	00008ce4 	andeq	r8, r0, r4, ror #25
 49c:	00000068 	andeq	r0, r0, r8, rrx
 4a0:	8b040e42 	blhi	103db0 <_bss_end+0xfaecc>
 4a4:	0b0d4201 	bleq	350cb0 <_bss_end+0x347dcc>
 4a8:	420d0d68 	andmi	r0, sp, #104, 26	; 0x1a00
 4ac:	00000ecb 	andeq	r0, r0, fp, asr #29
 4b0:	0000001c 	andeq	r0, r0, ip, lsl r0
 4b4:	00000480 	andeq	r0, r0, r0, lsl #9
 4b8:	00008d4c 	andeq	r8, r0, ip, asr #26
 4bc:	00000058 	andeq	r0, r0, r8, asr r0
 4c0:	8b080e42 	blhi	203dd0 <_bss_end+0x1faeec>
 4c4:	42018e02 	andmi	r8, r1, #2, 28
 4c8:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 4cc:	00080d0c 	andeq	r0, r8, ip, lsl #26
 4d0:	0000001c 	andeq	r0, r0, ip, lsl r0
 4d4:	00000480 	andeq	r0, r0, r0, lsl #9
 4d8:	00008da4 	andeq	r8, r0, r4, lsr #27
 4dc:	00000058 	andeq	r0, r0, r8, asr r0
 4e0:	8b080e42 	blhi	203df0 <_bss_end+0x1faf0c>
 4e4:	42018e02 	andmi	r8, r1, #2, 28
 4e8:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 4ec:	00080d0c 	andeq	r0, r8, ip, lsl #26

Disassembly of section .debug_ranges:

00000000 <.debug_ranges>:
   0:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
   4:	00000000 	andeq	r0, r0, r0
   8:	00008000 	andeq	r8, r0, r0
   c:	00008094 	muleq	r0, r4, r0
  10:	00008cc4 	andeq	r8, r0, r4, asr #25
  14:	00008ce4 	andeq	r8, r0, r4, ror #25
	...
