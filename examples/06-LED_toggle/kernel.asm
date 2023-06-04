
./kernel:     file format elf32-littlearm


Disassembly of section .text:

00008000 <_start>:
_start():
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/start.s:8
;@ tady budou symboly, ktere chceme na zacatek kodove sekce
.section .text.start

;@ vstupni bod do kernelu - nechame ho vlozit na zacatek kodu
_start:
    mov sp,#0x8000			;@ nastavime stack pointer na spodek zasobniku
    8000:	e3a0d902 	mov	sp, #32768	; 0x8000
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/start.s:9
	bl _c_startup			;@ C startup kod (inicializace prostredi)
    8004:	eb0001a8 	bl	86ac <_c_startup>
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/start.s:10
	bl _cpp_startup			;@ C++ startup kod (volani globalnich konstruktoru, ...)
    8008:	eb0001c1 	bl	8714 <_cpp_startup>
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/start.s:11
    bl _kernel_main			;@ skocime do hlavniho kodu jadra (v C)
    800c:	eb00017b 	bl	8600 <_kernel_main>
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/start.s:12
	bl _cpp_shutdown		;@ C++ shutdown kod (volani globalnich destruktoru, ...)
    8010:	eb0001d5 	bl	876c <_cpp_shutdown>

00008014 <hang>:
hang():
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/start.s:14
hang:
    b hang
    8014:	eafffffe 	b	8014 <hang>

00008018 <__cxa_guard_acquire>:
__cxa_guard_acquire():
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/cxx.cpp:11
    extern "C" int __cxa_guard_acquire(__guard*);
    extern "C" void __cxa_guard_release(__guard*);
    extern "C" void __cxa_guard_abort(__guard*);

    extern "C" int __cxa_guard_acquire(__guard* g)
    {
    8018:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    801c:	e28db000 	add	fp, sp, #0
    8020:	e24dd00c 	sub	sp, sp, #12
    8024:	e50b0008 	str	r0, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/cxx.cpp:12
        return !*(char*)(g);
    8028:	e51b3008 	ldr	r3, [fp, #-8]
    802c:	e5d33000 	ldrb	r3, [r3]
    8030:	e3530000 	cmp	r3, #0
    8034:	03a03001 	moveq	r3, #1
    8038:	13a03000 	movne	r3, #0
    803c:	e6ef3073 	uxtb	r3, r3
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/cxx.cpp:13
    }
    8040:	e1a00003 	mov	r0, r3
    8044:	e28bd000 	add	sp, fp, #0
    8048:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    804c:	e12fff1e 	bx	lr

00008050 <__cxa_guard_release>:
__cxa_guard_release():
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/cxx.cpp:16

    extern "C" void __cxa_guard_release(__guard* g)
    {
    8050:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8054:	e28db000 	add	fp, sp, #0
    8058:	e24dd00c 	sub	sp, sp, #12
    805c:	e50b0008 	str	r0, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/cxx.cpp:17
        *(char*)g = 1;
    8060:	e51b3008 	ldr	r3, [fp, #-8]
    8064:	e3a02001 	mov	r2, #1
    8068:	e5c32000 	strb	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/cxx.cpp:18
    }
    806c:	e320f000 	nop	{0}
    8070:	e28bd000 	add	sp, fp, #0
    8074:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8078:	e12fff1e 	bx	lr

0000807c <__cxa_guard_abort>:
__cxa_guard_abort():
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/cxx.cpp:21

    extern "C" void __cxa_guard_abort(__guard*)
    {
    807c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8080:	e28db000 	add	fp, sp, #0
    8084:	e24dd00c 	sub	sp, sp, #12
    8088:	e50b0008 	str	r0, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/cxx.cpp:22
    }
    808c:	e320f000 	nop	{0}
    8090:	e28bd000 	add	sp, fp, #0
    8094:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8098:	e12fff1e 	bx	lr

0000809c <__dso_handle>:
__dso_handle():
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/cxx.cpp:26
}

extern "C" void __dso_handle()
{
    809c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    80a0:	e28db000 	add	fp, sp, #0
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/cxx.cpp:28
    // ignore dtors for now
}
    80a4:	e320f000 	nop	{0}
    80a8:	e28bd000 	add	sp, fp, #0
    80ac:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    80b0:	e12fff1e 	bx	lr

000080b4 <__cxa_atexit>:
__cxa_atexit():
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/cxx.cpp:31

extern "C" void __cxa_atexit()
{
    80b4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    80b8:	e28db000 	add	fp, sp, #0
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/cxx.cpp:33
    // ignore dtors for now
}
    80bc:	e320f000 	nop	{0}
    80c0:	e28bd000 	add	sp, fp, #0
    80c4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    80c8:	e12fff1e 	bx	lr

000080cc <__cxa_pure_virtual>:
__cxa_pure_virtual():
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/cxx.cpp:36

extern "C" void __cxa_pure_virtual()
{
    80cc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    80d0:	e28db000 	add	fp, sp, #0
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/cxx.cpp:38
    // pure virtual method called
}
    80d4:	e320f000 	nop	{0}
    80d8:	e28bd000 	add	sp, fp, #0
    80dc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    80e0:	e12fff1e 	bx	lr

000080e4 <__aeabi_unwind_cpp_pr1>:
__aeabi_unwind_cpp_pr1():
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/cxx.cpp:41

extern "C" void __aeabi_unwind_cpp_pr1()
{
    80e4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    80e8:	e28db000 	add	fp, sp, #0
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/cxx.cpp:42 (discriminator 1)
    while (true)
    80ec:	eafffffe 	b	80ec <__aeabi_unwind_cpp_pr1+0x8>

000080f0 <_ZN13CGPIO_HandlerC1Ej>:
_ZN13CGPIO_HandlerC2Ej():
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:6
#include <hal/peripherals.h>
#include <drivers/gpio.h>

CGPIO_Handler sGPIO(hal::GPIO_Base);

CGPIO_Handler::CGPIO_Handler(unsigned int gpio_base_addr)
    80f0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    80f4:	e28db000 	add	fp, sp, #0
    80f8:	e24dd00c 	sub	sp, sp, #12
    80fc:	e50b0008 	str	r0, [fp, #-8]
    8100:	e50b100c 	str	r1, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:7
: mGPIO(reinterpret_cast<unsigned int*>(gpio_base_addr))
    8104:	e51b200c 	ldr	r2, [fp, #-12]
    8108:	e51b3008 	ldr	r3, [fp, #-8]
    810c:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:10
{
    //
}
    8110:	e51b3008 	ldr	r3, [fp, #-8]
    8114:	e1a00003 	mov	r0, r3
    8118:	e28bd000 	add	sp, fp, #0
    811c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8120:	e12fff1e 	bx	lr

00008124 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_>:
_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_():
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:13

bool CGPIO_Handler::Get_GPFSEL_Location(uint32_t pin, uint32_t& reg, uint32_t& bit_idx) const
{
    8124:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8128:	e28db000 	add	fp, sp, #0
    812c:	e24dd014 	sub	sp, sp, #20
    8130:	e50b0008 	str	r0, [fp, #-8]
    8134:	e50b100c 	str	r1, [fp, #-12]
    8138:	e50b2010 	str	r2, [fp, #-16]
    813c:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:14
    if (pin > hal::GPIO_Pin_Count)
    8140:	e51b300c 	ldr	r3, [fp, #-12]
    8144:	e3530036 	cmp	r3, #54	; 0x36
    8148:	9a000001 	bls	8154 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0x30>
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:15
        return false;
    814c:	e3a03000 	mov	r3, #0
    8150:	ea000033 	b	8224 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0x100>
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:17

    switch (pin / 10)
    8154:	e51b300c 	ldr	r3, [fp, #-12]
    8158:	e59f20d4 	ldr	r2, [pc, #212]	; 8234 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0x110>
    815c:	e0832392 	umull	r2, r3, r2, r3
    8160:	e1a031a3 	lsr	r3, r3, #3
    8164:	e3530005 	cmp	r3, #5
    8168:	979ff103 	ldrls	pc, [pc, r3, lsl #2]
    816c:	ea00001d 	b	81e8 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0xc4>
    8170:	00008188 	andeq	r8, r0, r8, lsl #3
    8174:	00008198 	muleq	r0, r8, r1
    8178:	000081a8 	andeq	r8, r0, r8, lsr #3
    817c:	000081b8 			; <UNDEFINED> instruction: 0x000081b8
    8180:	000081c8 	andeq	r8, r0, r8, asr #3
    8184:	000081d8 	ldrdeq	r8, [r0], -r8	; <UNPREDICTABLE>
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:20
    {
        case 0:
            reg = static_cast<uint32_t>(hal::GPIO_Reg::GPFSEL0);
    8188:	e51b3010 	ldr	r3, [fp, #-16]
    818c:	e3a02000 	mov	r2, #0
    8190:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:21
            break;
    8194:	ea000013 	b	81e8 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0xc4>
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:23
        case 1:
            reg = static_cast<uint32_t>(hal::GPIO_Reg::GPFSEL1);
    8198:	e51b3010 	ldr	r3, [fp, #-16]
    819c:	e3a02001 	mov	r2, #1
    81a0:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:24
            break;
    81a4:	ea00000f 	b	81e8 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0xc4>
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:26
        case 2:
            reg = static_cast<uint32_t>(hal::GPIO_Reg::GPFSEL2);
    81a8:	e51b3010 	ldr	r3, [fp, #-16]
    81ac:	e3a02002 	mov	r2, #2
    81b0:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:27
            break;
    81b4:	ea00000b 	b	81e8 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0xc4>
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:29
        case 3:
            reg = static_cast<uint32_t>(hal::GPIO_Reg::GPFSEL3);
    81b8:	e51b3010 	ldr	r3, [fp, #-16]
    81bc:	e3a02003 	mov	r2, #3
    81c0:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:30
            break;
    81c4:	ea000007 	b	81e8 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0xc4>
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:32
        case 4:
            reg = static_cast<uint32_t>(hal::GPIO_Reg::GPFSEL4);
    81c8:	e51b3010 	ldr	r3, [fp, #-16]
    81cc:	e3a02004 	mov	r2, #4
    81d0:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:33
            break;
    81d4:	ea000003 	b	81e8 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0xc4>
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:35
        case 5:
            reg = static_cast<uint32_t>(hal::GPIO_Reg::GPFSEL5);
    81d8:	e51b3010 	ldr	r3, [fp, #-16]
    81dc:	e3a02005 	mov	r2, #5
    81e0:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:36
            break;
    81e4:	e320f000 	nop	{0}
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:39
    }

    bit_idx = (pin % 10) * 3;
    81e8:	e51b100c 	ldr	r1, [fp, #-12]
    81ec:	e59f3040 	ldr	r3, [pc, #64]	; 8234 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0x110>
    81f0:	e0832193 	umull	r2, r3, r3, r1
    81f4:	e1a021a3 	lsr	r2, r3, #3
    81f8:	e1a03002 	mov	r3, r2
    81fc:	e1a03103 	lsl	r3, r3, #2
    8200:	e0833002 	add	r3, r3, r2
    8204:	e1a03083 	lsl	r3, r3, #1
    8208:	e0412003 	sub	r2, r1, r3
    820c:	e1a03002 	mov	r3, r2
    8210:	e1a03083 	lsl	r3, r3, #1
    8214:	e0832002 	add	r2, r3, r2
    8218:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    821c:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:41

    return true;
    8220:	e3a03001 	mov	r3, #1
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:42
}
    8224:	e1a00003 	mov	r0, r3
    8228:	e28bd000 	add	sp, fp, #0
    822c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8230:	e12fff1e 	bx	lr
    8234:	cccccccd 	stclgt	12, cr12, [ip], {205}	; 0xcd

00008238 <_ZNK13CGPIO_Handler18Get_GPCLR_LocationEjRjS0_>:
_ZNK13CGPIO_Handler18Get_GPCLR_LocationEjRjS0_():
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:45

bool CGPIO_Handler::Get_GPCLR_Location(uint32_t pin, uint32_t& reg, uint32_t& bit_idx) const
{
    8238:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    823c:	e28db000 	add	fp, sp, #0
    8240:	e24dd014 	sub	sp, sp, #20
    8244:	e50b0008 	str	r0, [fp, #-8]
    8248:	e50b100c 	str	r1, [fp, #-12]
    824c:	e50b2010 	str	r2, [fp, #-16]
    8250:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:46
    if (pin > hal::GPIO_Pin_Count)
    8254:	e51b300c 	ldr	r3, [fp, #-12]
    8258:	e3530036 	cmp	r3, #54	; 0x36
    825c:	9a000001 	bls	8268 <_ZNK13CGPIO_Handler18Get_GPCLR_LocationEjRjS0_+0x30>
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:47
        return false;
    8260:	e3a03000 	mov	r3, #0
    8264:	ea00000c 	b	829c <_ZNK13CGPIO_Handler18Get_GPCLR_LocationEjRjS0_+0x64>
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:49

    reg = static_cast<uint32_t>((pin < 32) ? hal::GPIO_Reg::GPCLR0 : hal::GPIO_Reg::GPCLR1);
    8268:	e51b300c 	ldr	r3, [fp, #-12]
    826c:	e353001f 	cmp	r3, #31
    8270:	8a000001 	bhi	827c <_ZNK13CGPIO_Handler18Get_GPCLR_LocationEjRjS0_+0x44>
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:49 (discriminator 1)
    8274:	e3a0200a 	mov	r2, #10
    8278:	ea000000 	b	8280 <_ZNK13CGPIO_Handler18Get_GPCLR_LocationEjRjS0_+0x48>
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:49 (discriminator 2)
    827c:	e3a0200b 	mov	r2, #11
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:49 (discriminator 4)
    8280:	e51b3010 	ldr	r3, [fp, #-16]
    8284:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:50 (discriminator 4)
    bit_idx = pin % 32;
    8288:	e51b300c 	ldr	r3, [fp, #-12]
    828c:	e203201f 	and	r2, r3, #31
    8290:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8294:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:52 (discriminator 4)

    return true;
    8298:	e3a03001 	mov	r3, #1
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:53
}
    829c:	e1a00003 	mov	r0, r3
    82a0:	e28bd000 	add	sp, fp, #0
    82a4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    82a8:	e12fff1e 	bx	lr

000082ac <_ZNK13CGPIO_Handler18Get_GPSET_LocationEjRjS0_>:
_ZNK13CGPIO_Handler18Get_GPSET_LocationEjRjS0_():
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:56

bool CGPIO_Handler::Get_GPSET_Location(uint32_t pin, uint32_t& reg, uint32_t& bit_idx) const
{
    82ac:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    82b0:	e28db000 	add	fp, sp, #0
    82b4:	e24dd014 	sub	sp, sp, #20
    82b8:	e50b0008 	str	r0, [fp, #-8]
    82bc:	e50b100c 	str	r1, [fp, #-12]
    82c0:	e50b2010 	str	r2, [fp, #-16]
    82c4:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:57
    if (pin > hal::GPIO_Pin_Count)
    82c8:	e51b300c 	ldr	r3, [fp, #-12]
    82cc:	e3530036 	cmp	r3, #54	; 0x36
    82d0:	9a000001 	bls	82dc <_ZNK13CGPIO_Handler18Get_GPSET_LocationEjRjS0_+0x30>
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:58
        return false;
    82d4:	e3a03000 	mov	r3, #0
    82d8:	ea00000c 	b	8310 <_ZNK13CGPIO_Handler18Get_GPSET_LocationEjRjS0_+0x64>
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:60

    reg = static_cast<uint32_t>((pin < 32) ? hal::GPIO_Reg::GPSET0 : hal::GPIO_Reg::GPSET1);
    82dc:	e51b300c 	ldr	r3, [fp, #-12]
    82e0:	e353001f 	cmp	r3, #31
    82e4:	8a000001 	bhi	82f0 <_ZNK13CGPIO_Handler18Get_GPSET_LocationEjRjS0_+0x44>
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:60 (discriminator 1)
    82e8:	e3a02007 	mov	r2, #7
    82ec:	ea000000 	b	82f4 <_ZNK13CGPIO_Handler18Get_GPSET_LocationEjRjS0_+0x48>
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:60 (discriminator 2)
    82f0:	e3a02008 	mov	r2, #8
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:60 (discriminator 4)
    82f4:	e51b3010 	ldr	r3, [fp, #-16]
    82f8:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:61 (discriminator 4)
    bit_idx = pin % 32;
    82fc:	e51b300c 	ldr	r3, [fp, #-12]
    8300:	e203201f 	and	r2, r3, #31
    8304:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8308:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:63 (discriminator 4)

    return true;
    830c:	e3a03001 	mov	r3, #1
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:64
}
    8310:	e1a00003 	mov	r0, r3
    8314:	e28bd000 	add	sp, fp, #0
    8318:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    831c:	e12fff1e 	bx	lr

00008320 <_ZNK13CGPIO_Handler18Get_GPLEV_LocationEjRjS0_>:
_ZNK13CGPIO_Handler18Get_GPLEV_LocationEjRjS0_():
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:67

bool CGPIO_Handler::Get_GPLEV_Location(uint32_t pin, uint32_t& reg, uint32_t& bit_idx) const
{
    8320:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8324:	e28db000 	add	fp, sp, #0
    8328:	e24dd014 	sub	sp, sp, #20
    832c:	e50b0008 	str	r0, [fp, #-8]
    8330:	e50b100c 	str	r1, [fp, #-12]
    8334:	e50b2010 	str	r2, [fp, #-16]
    8338:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:68
    if (pin > hal::GPIO_Pin_Count)
    833c:	e51b300c 	ldr	r3, [fp, #-12]
    8340:	e3530036 	cmp	r3, #54	; 0x36
    8344:	9a000001 	bls	8350 <_ZNK13CGPIO_Handler18Get_GPLEV_LocationEjRjS0_+0x30>
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:69
        return false;
    8348:	e3a03000 	mov	r3, #0
    834c:	ea00000c 	b	8384 <_ZNK13CGPIO_Handler18Get_GPLEV_LocationEjRjS0_+0x64>
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:71

    reg = static_cast<uint32_t>((pin < 32) ? hal::GPIO_Reg::GPLEV0 : hal::GPIO_Reg::GPLEV1);
    8350:	e51b300c 	ldr	r3, [fp, #-12]
    8354:	e353001f 	cmp	r3, #31
    8358:	8a000001 	bhi	8364 <_ZNK13CGPIO_Handler18Get_GPLEV_LocationEjRjS0_+0x44>
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:71 (discriminator 1)
    835c:	e3a0200d 	mov	r2, #13
    8360:	ea000000 	b	8368 <_ZNK13CGPIO_Handler18Get_GPLEV_LocationEjRjS0_+0x48>
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:71 (discriminator 2)
    8364:	e3a0200e 	mov	r2, #14
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:71 (discriminator 4)
    8368:	e51b3010 	ldr	r3, [fp, #-16]
    836c:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:72 (discriminator 4)
    bit_idx = pin % 32;
    8370:	e51b300c 	ldr	r3, [fp, #-12]
    8374:	e203201f 	and	r2, r3, #31
    8378:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    837c:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:74 (discriminator 4)

    return true;
    8380:	e3a03001 	mov	r3, #1
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:75
}
    8384:	e1a00003 	mov	r0, r3
    8388:	e28bd000 	add	sp, fp, #0
    838c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8390:	e12fff1e 	bx	lr

00008394 <_ZN13CGPIO_Handler17Set_GPIO_FunctionEj14NGPIO_Function>:
_ZN13CGPIO_Handler17Set_GPIO_FunctionEj14NGPIO_Function():
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:78

void CGPIO_Handler::Set_GPIO_Function(uint32_t pin, NGPIO_Function func)
{
    8394:	e92d4800 	push	{fp, lr}
    8398:	e28db004 	add	fp, sp, #4
    839c:	e24dd018 	sub	sp, sp, #24
    83a0:	e50b0010 	str	r0, [fp, #-16]
    83a4:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    83a8:	e1a03002 	mov	r3, r2
    83ac:	e54b3015 	strb	r3, [fp, #-21]	; 0xffffffeb
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:80
    uint32_t reg, bit;
    if (!Get_GPFSEL_Location(pin, reg, bit))
    83b0:	e24b300c 	sub	r3, fp, #12
    83b4:	e24b2008 	sub	r2, fp, #8
    83b8:	e51b1014 	ldr	r1, [fp, #-20]	; 0xffffffec
    83bc:	e51b0010 	ldr	r0, [fp, #-16]
    83c0:	ebffff57 	bl	8124 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_>
    83c4:	e1a03000 	mov	r3, r0
    83c8:	e2233001 	eor	r3, r3, #1
    83cc:	e6ef3073 	uxtb	r3, r3
    83d0:	e3530000 	cmp	r3, #0
    83d4:	1a000015 	bne	8430 <_ZN13CGPIO_Handler17Set_GPIO_FunctionEj14NGPIO_Function+0x9c>
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:83
        return;

    mGPIO[reg] = (mGPIO[reg] & (~static_cast<unsigned int>(7 << bit))) | (static_cast<unsigned int>(func) << bit);
    83d8:	e51b3010 	ldr	r3, [fp, #-16]
    83dc:	e5932000 	ldr	r2, [r3]
    83e0:	e51b3008 	ldr	r3, [fp, #-8]
    83e4:	e1a03103 	lsl	r3, r3, #2
    83e8:	e0823003 	add	r3, r2, r3
    83ec:	e5932000 	ldr	r2, [r3]
    83f0:	e51b300c 	ldr	r3, [fp, #-12]
    83f4:	e3a01007 	mov	r1, #7
    83f8:	e1a03311 	lsl	r3, r1, r3
    83fc:	e1e03003 	mvn	r3, r3
    8400:	e0021003 	and	r1, r2, r3
    8404:	e55b2015 	ldrb	r2, [fp, #-21]	; 0xffffffeb
    8408:	e51b300c 	ldr	r3, [fp, #-12]
    840c:	e1a02312 	lsl	r2, r2, r3
    8410:	e51b3010 	ldr	r3, [fp, #-16]
    8414:	e5930000 	ldr	r0, [r3]
    8418:	e51b3008 	ldr	r3, [fp, #-8]
    841c:	e1a03103 	lsl	r3, r3, #2
    8420:	e0803003 	add	r3, r0, r3
    8424:	e1812002 	orr	r2, r1, r2
    8428:	e5832000 	str	r2, [r3]
    842c:	ea000000 	b	8434 <_ZN13CGPIO_Handler17Set_GPIO_FunctionEj14NGPIO_Function+0xa0>
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:81
        return;
    8430:	e320f000 	nop	{0}
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:84
}
    8434:	e24bd004 	sub	sp, fp, #4
    8438:	e8bd8800 	pop	{fp, pc}

0000843c <_ZNK13CGPIO_Handler17Get_GPIO_FunctionEj>:
_ZNK13CGPIO_Handler17Get_GPIO_FunctionEj():
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:87

NGPIO_Function CGPIO_Handler::Get_GPIO_Function(uint32_t pin) const
{
    843c:	e92d4800 	push	{fp, lr}
    8440:	e28db004 	add	fp, sp, #4
    8444:	e24dd010 	sub	sp, sp, #16
    8448:	e50b0010 	str	r0, [fp, #-16]
    844c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:89
    uint32_t reg, bit;
    if (!Get_GPFSEL_Location(pin, reg, bit))
    8450:	e24b300c 	sub	r3, fp, #12
    8454:	e24b2008 	sub	r2, fp, #8
    8458:	e51b1014 	ldr	r1, [fp, #-20]	; 0xffffffec
    845c:	e51b0010 	ldr	r0, [fp, #-16]
    8460:	ebffff2f 	bl	8124 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_>
    8464:	e1a03000 	mov	r3, r0
    8468:	e2233001 	eor	r3, r3, #1
    846c:	e6ef3073 	uxtb	r3, r3
    8470:	e3530000 	cmp	r3, #0
    8474:	0a000001 	beq	8480 <_ZNK13CGPIO_Handler17Get_GPIO_FunctionEj+0x44>
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:90
        return NGPIO_Function::Unspecified;
    8478:	e3a03008 	mov	r3, #8
    847c:	ea00000a 	b	84ac <_ZNK13CGPIO_Handler17Get_GPIO_FunctionEj+0x70>
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:92

    return static_cast<NGPIO_Function>((mGPIO[reg] >> bit) & 7);
    8480:	e51b3010 	ldr	r3, [fp, #-16]
    8484:	e5932000 	ldr	r2, [r3]
    8488:	e51b3008 	ldr	r3, [fp, #-8]
    848c:	e1a03103 	lsl	r3, r3, #2
    8490:	e0823003 	add	r3, r2, r3
    8494:	e5932000 	ldr	r2, [r3]
    8498:	e51b300c 	ldr	r3, [fp, #-12]
    849c:	e1a03332 	lsr	r3, r2, r3
    84a0:	e6ef3073 	uxtb	r3, r3
    84a4:	e2033007 	and	r3, r3, #7
    84a8:	e6ef3073 	uxtb	r3, r3
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:93 (discriminator 1)
}
    84ac:	e1a00003 	mov	r0, r3
    84b0:	e24bd004 	sub	sp, fp, #4
    84b4:	e8bd8800 	pop	{fp, pc}

000084b8 <_ZN13CGPIO_Handler10Set_OutputEjb>:
_ZN13CGPIO_Handler10Set_OutputEjb():
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:96

void CGPIO_Handler::Set_Output(uint32_t pin, bool set)
{
    84b8:	e92d4800 	push	{fp, lr}
    84bc:	e28db004 	add	fp, sp, #4
    84c0:	e24dd018 	sub	sp, sp, #24
    84c4:	e50b0010 	str	r0, [fp, #-16]
    84c8:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    84cc:	e1a03002 	mov	r3, r2
    84d0:	e54b3015 	strb	r3, [fp, #-21]	; 0xffffffeb
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:98
    uint32_t reg, bit;
    if (!(set && Get_GPSET_Location(pin, reg, bit)) && !(!set && Get_GPCLR_Location(pin, reg, bit)))
    84d4:	e55b3015 	ldrb	r3, [fp, #-21]	; 0xffffffeb
    84d8:	e2233001 	eor	r3, r3, #1
    84dc:	e6ef3073 	uxtb	r3, r3
    84e0:	e3530000 	cmp	r3, #0
    84e4:	1a000009 	bne	8510 <_ZN13CGPIO_Handler10Set_OutputEjb+0x58>
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:98 (discriminator 2)
    84e8:	e24b300c 	sub	r3, fp, #12
    84ec:	e24b2008 	sub	r2, fp, #8
    84f0:	e51b1014 	ldr	r1, [fp, #-20]	; 0xffffffec
    84f4:	e51b0010 	ldr	r0, [fp, #-16]
    84f8:	ebffff6b 	bl	82ac <_ZNK13CGPIO_Handler18Get_GPSET_LocationEjRjS0_>
    84fc:	e1a03000 	mov	r3, r0
    8500:	e2233001 	eor	r3, r3, #1
    8504:	e6ef3073 	uxtb	r3, r3
    8508:	e3530000 	cmp	r3, #0
    850c:	0a00000e 	beq	854c <_ZN13CGPIO_Handler10Set_OutputEjb+0x94>
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:98 (discriminator 3)
    8510:	e55b3015 	ldrb	r3, [fp, #-21]	; 0xffffffeb
    8514:	e3530000 	cmp	r3, #0
    8518:	1a000009 	bne	8544 <_ZN13CGPIO_Handler10Set_OutputEjb+0x8c>
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:98 (discriminator 6)
    851c:	e24b300c 	sub	r3, fp, #12
    8520:	e24b2008 	sub	r2, fp, #8
    8524:	e51b1014 	ldr	r1, [fp, #-20]	; 0xffffffec
    8528:	e51b0010 	ldr	r0, [fp, #-16]
    852c:	ebffff41 	bl	8238 <_ZNK13CGPIO_Handler18Get_GPCLR_LocationEjRjS0_>
    8530:	e1a03000 	mov	r3, r0
    8534:	e2233001 	eor	r3, r3, #1
    8538:	e6ef3073 	uxtb	r3, r3
    853c:	e3530000 	cmp	r3, #0
    8540:	0a000001 	beq	854c <_ZN13CGPIO_Handler10Set_OutputEjb+0x94>
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:98 (discriminator 7)
    8544:	e3a03001 	mov	r3, #1
    8548:	ea000000 	b	8550 <_ZN13CGPIO_Handler10Set_OutputEjb+0x98>
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:98 (discriminator 8)
    854c:	e3a03000 	mov	r3, #0
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:98 (discriminator 10)
    8550:	e3530000 	cmp	r3, #0
    8554:	1a00000a 	bne	8584 <_ZN13CGPIO_Handler10Set_OutputEjb+0xcc>
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:101
        return;

    mGPIO[reg] = (1 << bit);
    8558:	e51b300c 	ldr	r3, [fp, #-12]
    855c:	e3a02001 	mov	r2, #1
    8560:	e1a01312 	lsl	r1, r2, r3
    8564:	e51b3010 	ldr	r3, [fp, #-16]
    8568:	e5932000 	ldr	r2, [r3]
    856c:	e51b3008 	ldr	r3, [fp, #-8]
    8570:	e1a03103 	lsl	r3, r3, #2
    8574:	e0823003 	add	r3, r2, r3
    8578:	e1a02001 	mov	r2, r1
    857c:	e5832000 	str	r2, [r3]
    8580:	ea000000 	b	8588 <_ZN13CGPIO_Handler10Set_OutputEjb+0xd0>
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:99
        return;
    8584:	e320f000 	nop	{0}
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:102
}
    8588:	e24bd004 	sub	sp, fp, #4
    858c:	e8bd8800 	pop	{fp, pc}

00008590 <_Z41__static_initialization_and_destruction_0ii>:
_Z41__static_initialization_and_destruction_0ii():
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:102
    8590:	e92d4800 	push	{fp, lr}
    8594:	e28db004 	add	fp, sp, #4
    8598:	e24dd008 	sub	sp, sp, #8
    859c:	e50b0008 	str	r0, [fp, #-8]
    85a0:	e50b100c 	str	r1, [fp, #-12]
    85a4:	e51b3008 	ldr	r3, [fp, #-8]
    85a8:	e3530001 	cmp	r3, #1
    85ac:	1a000006 	bne	85cc <_Z41__static_initialization_and_destruction_0ii+0x3c>
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:102 (discriminator 1)
    85b0:	e51b300c 	ldr	r3, [fp, #-12]
    85b4:	e59f201c 	ldr	r2, [pc, #28]	; 85d8 <_Z41__static_initialization_and_destruction_0ii+0x48>
    85b8:	e1530002 	cmp	r3, r2
    85bc:	1a000002 	bne	85cc <_Z41__static_initialization_and_destruction_0ii+0x3c>
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:4
CGPIO_Handler sGPIO(hal::GPIO_Base);
    85c0:	e59f1014 	ldr	r1, [pc, #20]	; 85dc <_Z41__static_initialization_and_destruction_0ii+0x4c>
    85c4:	e59f0014 	ldr	r0, [pc, #20]	; 85e0 <_Z41__static_initialization_and_destruction_0ii+0x50>
    85c8:	ebfffec8 	bl	80f0 <_ZN13CGPIO_HandlerC1Ej>
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:102
}
    85cc:	e320f000 	nop	{0}
    85d0:	e24bd004 	sub	sp, fp, #4
    85d4:	e8bd8800 	pop	{fp, pc}
    85d8:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>
    85dc:	20200000 	eorcs	r0, r0, r0
    85e0:	0000882c 	andeq	r8, r0, ip, lsr #16

000085e4 <_GLOBAL__sub_I_sGPIO>:
_GLOBAL__sub_I_sGPIO():
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/drivers/gpio.cpp:102
    85e4:	e92d4800 	push	{fp, lr}
    85e8:	e28db004 	add	fp, sp, #4
    85ec:	e59f1008 	ldr	r1, [pc, #8]	; 85fc <_GLOBAL__sub_I_sGPIO+0x18>
    85f0:	e3a00001 	mov	r0, #1
    85f4:	ebffffe5 	bl	8590 <_Z41__static_initialization_and_destruction_0ii>
    85f8:	e8bd8800 	pop	{fp, pc}
    85fc:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>

00008600 <_kernel_main>:
_kernel_main():
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/main.cpp:7

// GPIO pin 47 je pripojeny na LED na desce (tzv. ACT LED)
constexpr uint32_t ACT_Pin = 47;

extern "C" int _kernel_main(void)
{
    8600:	e92d4800 	push	{fp, lr}
    8604:	e28db004 	add	fp, sp, #4
    8608:	e24dd008 	sub	sp, sp, #8
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/main.cpp:9
    // nastavime ACT LED pin na vystupni
    sGPIO.Set_GPIO_Function(ACT_Pin, NGPIO_Function::Output);
    860c:	e3a02001 	mov	r2, #1
    8610:	e3a0102f 	mov	r1, #47	; 0x2f
    8614:	e59f008c 	ldr	r0, [pc, #140]	; 86a8 <_kernel_main+0xa8>
    8618:	ebffff5d 	bl	8394 <_ZN13CGPIO_Handler17Set_GPIO_FunctionEj14NGPIO_Function>
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/main.cpp:16
    volatile unsigned int tim;

    while (1)
    {
        // spalime 500000 taktu (cekani par milisekund)
        for (tim = 0; tim < 0x5000; tim++)
    861c:	e3a03000 	mov	r3, #0
    8620:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/main.cpp:16 (discriminator 3)
    8624:	e51b3008 	ldr	r3, [fp, #-8]
    8628:	e3530a05 	cmp	r3, #20480	; 0x5000
    862c:	33a03001 	movcc	r3, #1
    8630:	23a03000 	movcs	r3, #0
    8634:	e6ef3073 	uxtb	r3, r3
    8638:	e3530000 	cmp	r3, #0
    863c:	0a000003 	beq	8650 <_kernel_main+0x50>
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/main.cpp:16 (discriminator 2)
    8640:	e51b3008 	ldr	r3, [fp, #-8]
    8644:	e2833001 	add	r3, r3, #1
    8648:	e50b3008 	str	r3, [fp, #-8]
    864c:	eafffff4 	b	8624 <_kernel_main+0x24>
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/main.cpp:20
            ;

        // zhasneme LED
        sGPIO.Set_Output(ACT_Pin, true);
    8650:	e3a02001 	mov	r2, #1
    8654:	e3a0102f 	mov	r1, #47	; 0x2f
    8658:	e59f0048 	ldr	r0, [pc, #72]	; 86a8 <_kernel_main+0xa8>
    865c:	ebffff95 	bl	84b8 <_ZN13CGPIO_Handler10Set_OutputEjb>
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/main.cpp:23

        // opet cekani
        for (tim = 0; tim < 0x5000; tim++)
    8660:	e3a03000 	mov	r3, #0
    8664:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/main.cpp:23 (discriminator 3)
    8668:	e51b3008 	ldr	r3, [fp, #-8]
    866c:	e3530a05 	cmp	r3, #20480	; 0x5000
    8670:	33a03001 	movcc	r3, #1
    8674:	23a03000 	movcs	r3, #0
    8678:	e6ef3073 	uxtb	r3, r3
    867c:	e3530000 	cmp	r3, #0
    8680:	0a000003 	beq	8694 <_kernel_main+0x94>
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/main.cpp:23 (discriminator 2)
    8684:	e51b3008 	ldr	r3, [fp, #-8]
    8688:	e2833001 	add	r3, r3, #1
    868c:	e50b3008 	str	r3, [fp, #-8]
    8690:	eafffff4 	b	8668 <_kernel_main+0x68>
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/main.cpp:27
            ;

        // rozsvitime LED
        sGPIO.Set_Output(ACT_Pin, false);
    8694:	e3a02000 	mov	r2, #0
    8698:	e3a0102f 	mov	r1, #47	; 0x2f
    869c:	e59f0004 	ldr	r0, [pc, #4]	; 86a8 <_kernel_main+0xa8>
    86a0:	ebffff84 	bl	84b8 <_ZN13CGPIO_Handler10Set_OutputEjb>
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/main.cpp:16
        for (tim = 0; tim < 0x5000; tim++)
    86a4:	eaffffdc 	b	861c <_kernel_main+0x1c>
    86a8:	0000882c 	andeq	r8, r0, ip, lsr #16

000086ac <_c_startup>:
_c_startup():
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/startup.cpp:21
extern "C" dtor_ptr __DTOR_LIST__[0];
// konec pole destruktoru
extern "C" dtor_ptr __DTOR_END__[0];

extern "C" int _c_startup(void)
{
    86ac:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    86b0:	e28db000 	add	fp, sp, #0
    86b4:	e24dd00c 	sub	sp, sp, #12
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/startup.cpp:25
    int* i;

    // vynulujeme .bss sekci
    for (i = (int*)_bss_start; i < (int*)_bss_end; i++)
    86b8:	e59f304c 	ldr	r3, [pc, #76]	; 870c <_c_startup+0x60>
    86bc:	e5933000 	ldr	r3, [r3]
    86c0:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/startup.cpp:25 (discriminator 3)
    86c4:	e59f3044 	ldr	r3, [pc, #68]	; 8710 <_c_startup+0x64>
    86c8:	e5933000 	ldr	r3, [r3]
    86cc:	e1a02003 	mov	r2, r3
    86d0:	e51b3008 	ldr	r3, [fp, #-8]
    86d4:	e1530002 	cmp	r3, r2
    86d8:	2a000006 	bcs	86f8 <_c_startup+0x4c>
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/startup.cpp:26 (discriminator 2)
        *i = 0;
    86dc:	e51b3008 	ldr	r3, [fp, #-8]
    86e0:	e3a02000 	mov	r2, #0
    86e4:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/startup.cpp:25 (discriminator 2)
    for (i = (int*)_bss_start; i < (int*)_bss_end; i++)
    86e8:	e51b3008 	ldr	r3, [fp, #-8]
    86ec:	e2833004 	add	r3, r3, #4
    86f0:	e50b3008 	str	r3, [fp, #-8]
    86f4:	eafffff2 	b	86c4 <_c_startup+0x18>
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/startup.cpp:28

    return 0;
    86f8:	e3a03000 	mov	r3, #0
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/startup.cpp:29
}
    86fc:	e1a00003 	mov	r0, r3
    8700:	e28bd000 	add	sp, fp, #0
    8704:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8708:	e12fff1e 	bx	lr
    870c:	0000882c 	andeq	r8, r0, ip, lsr #16
    8710:	00008840 	andeq	r8, r0, r0, asr #16

00008714 <_cpp_startup>:
_cpp_startup():
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/startup.cpp:32

extern "C" int _cpp_startup(void)
{
    8714:	e92d4800 	push	{fp, lr}
    8718:	e28db004 	add	fp, sp, #4
    871c:	e24dd008 	sub	sp, sp, #8
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/startup.cpp:37
    ctor_ptr* fnptr;

    // zavolame konstruktory globalnich C++ trid
    // v poli __CTOR_LIST__ jsou ukazatele na vygenerovane stuby volani konstruktoru
    for (fnptr = __CTOR_LIST__; fnptr < __CTOR_END__; fnptr++)
    8720:	e59f303c 	ldr	r3, [pc, #60]	; 8764 <_cpp_startup+0x50>
    8724:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/startup.cpp:37 (discriminator 3)
    8728:	e51b3008 	ldr	r3, [fp, #-8]
    872c:	e59f2034 	ldr	r2, [pc, #52]	; 8768 <_cpp_startup+0x54>
    8730:	e1530002 	cmp	r3, r2
    8734:	2a000006 	bcs	8754 <_cpp_startup+0x40>
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/startup.cpp:38 (discriminator 2)
        (*fnptr)();
    8738:	e51b3008 	ldr	r3, [fp, #-8]
    873c:	e5933000 	ldr	r3, [r3]
    8740:	e12fff33 	blx	r3
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/startup.cpp:37 (discriminator 2)
    for (fnptr = __CTOR_LIST__; fnptr < __CTOR_END__; fnptr++)
    8744:	e51b3008 	ldr	r3, [fp, #-8]
    8748:	e2833004 	add	r3, r3, #4
    874c:	e50b3008 	str	r3, [fp, #-8]
    8750:	eafffff4 	b	8728 <_cpp_startup+0x14>
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/startup.cpp:40

    return 0;
    8754:	e3a03000 	mov	r3, #0
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/startup.cpp:41
}
    8758:	e1a00003 	mov	r0, r3
    875c:	e24bd004 	sub	sp, fp, #4
    8760:	e8bd8800 	pop	{fp, pc}
    8764:	00008828 	andeq	r8, r0, r8, lsr #16
    8768:	0000882c 	andeq	r8, r0, ip, lsr #16

0000876c <_cpp_shutdown>:
_cpp_shutdown():
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/startup.cpp:44

extern "C" int _cpp_shutdown(void)
{
    876c:	e92d4800 	push	{fp, lr}
    8770:	e28db004 	add	fp, sp, #4
    8774:	e24dd008 	sub	sp, sp, #8
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/startup.cpp:48
    dtor_ptr* fnptr;

    // zavolame destruktory globalnich C++ trid
    for (fnptr = __DTOR_LIST__; fnptr < __DTOR_END__; fnptr++)
    8778:	e59f303c 	ldr	r3, [pc, #60]	; 87bc <_cpp_shutdown+0x50>
    877c:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/startup.cpp:48 (discriminator 3)
    8780:	e51b3008 	ldr	r3, [fp, #-8]
    8784:	e59f2034 	ldr	r2, [pc, #52]	; 87c0 <_cpp_shutdown+0x54>
    8788:	e1530002 	cmp	r3, r2
    878c:	2a000006 	bcs	87ac <_cpp_shutdown+0x40>
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/startup.cpp:49 (discriminator 2)
        (*fnptr)();
    8790:	e51b3008 	ldr	r3, [fp, #-8]
    8794:	e5933000 	ldr	r3, [r3]
    8798:	e12fff33 	blx	r3
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/startup.cpp:48 (discriminator 2)
    for (fnptr = __DTOR_LIST__; fnptr < __DTOR_END__; fnptr++)
    879c:	e51b3008 	ldr	r3, [fp, #-8]
    87a0:	e2833004 	add	r3, r3, #4
    87a4:	e50b3008 	str	r3, [fp, #-8]
    87a8:	eafffff4 	b	8780 <_cpp_shutdown+0x14>
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/startup.cpp:51

    return 0;
    87ac:	e3a03000 	mov	r3, #0
/home/silhavyj/School/ZeroMate/examples/06-LED_toggle/kernel/src/startup.cpp:52
}
    87b0:	e1a00003 	mov	r0, r3
    87b4:	e24bd004 	sub	sp, fp, #4
    87b8:	e8bd8800 	pop	{fp, pc}
    87bc:	0000882c 	andeq	r8, r0, ip, lsr #16
    87c0:	0000882c 	andeq	r8, r0, ip, lsr #16

Disassembly of section .ARM.extab:

000087c4 <.ARM.extab>:
    87c4:	81019b40 	tsthi	r1, r0, asr #22
    87c8:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    87cc:	00000000 	andeq	r0, r0, r0
    87d0:	81019b40 	tsthi	r1, r0, asr #22
    87d4:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    87d8:	00000000 	andeq	r0, r0, r0
    87dc:	81019b40 	tsthi	r1, r0, asr #22
    87e0:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    87e4:	00000000 	andeq	r0, r0, r0

Disassembly of section .ARM.exidx:

000087e8 <.ARM.exidx>:
    87e8:	7ffff830 	svcvc	0x00fff830
    87ec:	00000001 	andeq	r0, r0, r1
    87f0:	7ffffe10 	svcvc	0x00fffe10
    87f4:	7fffffd0 	svcvc	0x00ffffd0
    87f8:	7ffffeb4 	svcvc	0x00fffeb4
    87fc:	00000001 	andeq	r0, r0, r1
    8800:	7fffff14 	svcvc	0x00ffff14
    8804:	7fffffcc 	svcvc	0x00ffffcc
    8808:	7fffff64 	svcvc	0x00ffff64
    880c:	7fffffd0 	svcvc	0x00ffffd0
    8810:	7fffffb4 	svcvc	0x00ffffb4
    8814:	00000001 	andeq	r0, r0, r1

Disassembly of section .rodata:

00008818 <_ZN3halL15Peripheral_BaseE>:
    8818:	20000000 	andcs	r0, r0, r0

0000881c <_ZN3halL9GPIO_BaseE>:
    881c:	20200000 	eorcs	r0, r0, r0

00008820 <_ZN3halL14GPIO_Pin_CountE>:
    8820:	00000036 	andeq	r0, r0, r6, lsr r0

00008824 <_ZL7ACT_Pin>:
    8824:	0000002f 	andeq	r0, r0, pc, lsr #32

Disassembly of section .data:

00008828 <__CTOR_LIST__>:
    8828:	000085e4 	andeq	r8, r0, r4, ror #11

Disassembly of section .bss:

0000882c <sGPIO>:
	...

Disassembly of section .debug_info:

00000000 <.debug_info>:
       0:	00000126 	andeq	r0, r0, r6, lsr #2
       4:	00000004 	andeq	r0, r0, r4
       8:	01040000 	mrseq	r0, (UNDEF: 4)
       c:	00000085 	andeq	r0, r0, r5, lsl #1
      10:	00000004 	andeq	r0, r0, r4
      14:	00004900 	andeq	r4, r0, r0, lsl #18
      18:	00801800 	addeq	r1, r0, r0, lsl #16
      1c:	0000d800 	andeq	sp, r0, r0, lsl #16
      20:	00000000 	andeq	r0, r0, r0
      24:	01ad0200 			; <UNDEFINED> instruction: 0x01ad0200
      28:	28010000 	stmdacs	r1, {}	; <UNPREDICTABLE>
      2c:	0080e411 	addeq	lr, r0, r1, lsl r4
      30:	00000c00 	andeq	r0, r0, r0, lsl #24
      34:	029c0100 	addseq	r0, ip, #0, 2
      38:	0000019a 	muleq	r0, sl, r1
      3c:	cc112301 	ldcgt	3, cr2, [r1], {1}
      40:	18000080 	stmdane	r0, {r7}
      44:	01000000 	mrseq	r0, (UNDEF: 0)
      48:	016e029c 			; <UNDEFINED> instruction: 0x016e029c
      4c:	1e010000 	cdpne	0, 0, cr0, cr1, cr0, {0}
      50:	0080b411 	addeq	fp, r0, r1, lsl r4
      54:	00001800 	andeq	r1, r0, r0, lsl #16
      58:	029c0100 	addseq	r0, ip, #0, 2
      5c:	00000161 	andeq	r0, r0, r1, ror #2
      60:	9c111901 			; <UNDEFINED> instruction: 0x9c111901
      64:	18000080 	stmdane	r0, {r7}
      68:	01000000 	mrseq	r0, (UNDEF: 0)
      6c:	018f039c 			; <UNDEFINED> instruction: 0x018f039c
      70:	00020000 	andeq	r0, r2, r0
      74:	000000bb 	strheq	r0, [r0], -fp
      78:	00014f04 	andeq	r4, r1, r4, lsl #30
      7c:	15140100 	ldrne	r0, [r4, #-256]	; 0xffffff00
      80:	0000008a 	andeq	r0, r0, sl, lsl #1
      84:	0000bb05 	andeq	fp, r0, r5, lsl #22
      88:	c4060000 	strgt	r0, [r6], #-0
      8c:	01000001 	tsteq	r0, r1
      90:	00c11f04 	sbceq	r1, r1, r4, lsl #30
      94:	3b040000 	blcc	10009c <_bss_end+0xf785c>
      98:	01000001 	tsteq	r0, r1
      9c:	00a8150f 	adceq	r1, r8, pc, lsl #10
      a0:	bb050000 	bllt	1400a8 <_bss_end+0x137868>
      a4:	00000000 	andeq	r0, r0, r0
      a8:	00017b07 	andeq	r7, r1, r7, lsl #22
      ac:	140a0100 	strne	r0, [sl], #-256	; 0xffffff00
      b0:	00000105 	andeq	r0, r0, r5, lsl #2
      b4:	0000bb05 	andeq	fp, r0, r5, lsl #22
      b8:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
      bc:	00008a04 	andeq	r8, r0, r4, lsl #20
      c0:	05080900 	streq	r0, [r8, #-2304]	; 0xfffff700
      c4:	000001cc 	andeq	r0, r0, ip, asr #3
      c8:	0000780a 	andeq	r7, r0, sl, lsl #16
      cc:	00807c00 	addeq	r7, r0, r0, lsl #24
      d0:	00002000 	andeq	r2, r0, r0
      d4:	e49c0100 	ldr	r0, [ip], #256	; 0x100
      d8:	0b000000 	bleq	e0 <_start-0x7f20>
      dc:	000000bb 	strheq	r0, [r0], -fp
      e0:	00749102 	rsbseq	r9, r4, r2, lsl #2
      e4:	0000960a 	andeq	r9, r0, sl, lsl #12
      e8:	00805000 	addeq	r5, r0, r0
      ec:	00002c00 	andeq	r2, r0, r0, lsl #24
      f0:	059c0100 	ldreq	r0, [ip, #256]	; 0x100
      f4:	0c000001 	stceq	0, cr0, [r0], {1}
      f8:	0f010067 	svceq	0x00010067
      fc:	0000bb32 	andeq	fp, r0, r2, lsr fp
     100:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     104:	05040d00 	streq	r0, [r4, #-3328]	; 0xfffff300
     108:	00746e69 	rsbseq	r6, r4, r9, ror #28
     10c:	0000a80e 	andeq	sl, r0, lr, lsl #16
     110:	00801800 	addeq	r1, r0, r0, lsl #16
     114:	00003800 	andeq	r3, r0, r0, lsl #16
     118:	0c9c0100 	ldfeqs	f0, [ip], {0}
     11c:	0a010067 	beq	402c0 <_bss_end+0x37a80>
     120:	0000bb31 	andeq	fp, r0, r1, lsr fp
     124:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     128:	066c0000 	strbteq	r0, [ip], -r0
     12c:	00040000 	andeq	r0, r4, r0
     130:	000000d0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     134:	00850104 	addeq	r0, r5, r4, lsl #2
     138:	09040000 	stmdbeq	r4, {}	; <UNPREDICTABLE>
     13c:	49000002 	stmdbmi	r0, {r1}
     140:	f0000000 			; <UNDEFINED> instruction: 0xf0000000
     144:	10000080 	andne	r0, r0, r0, lsl #1
     148:	aa000005 	bge	164 <_start-0x7e9c>
     14c:	02000000 	andeq	r0, r0, #0
     150:	03c40801 	biceq	r0, r4, #65536	; 0x10000
     154:	02020000 	andeq	r0, r2, #0
     158:	00056c05 	andeq	r6, r5, r5, lsl #24
     15c:	05040300 	streq	r0, [r4, #-768]	; 0xfffffd00
     160:	00746e69 	rsbseq	r6, r4, r9, ror #28
     164:	0004c304 	andeq	ip, r4, r4, lsl #6
     168:	07090200 	streq	r0, [r9, -r0, lsl #4]
     16c:	00000046 	andeq	r0, r0, r6, asr #32
     170:	bb080102 	bllt	200580 <_bss_end+0x1f7d40>
     174:	02000003 	andeq	r0, r0, #3
     178:	03f90702 	mvnseq	r0, #524288	; 0x80000
     17c:	76040000 	strvc	r0, [r4], -r0
     180:	02000005 	andeq	r0, r0, #5
     184:	0065070b 	rsbeq	r0, r5, fp, lsl #14
     188:	54050000 	strpl	r0, [r5], #-0
     18c:	02000000 	andeq	r0, r0, #0
     190:	0c460704 	mcrreq	7, 0, r0, r6, cr4
     194:	68060000 	stmdavs	r6, {}	; <UNPREDICTABLE>
     198:	03006c61 	movweq	r6, #3169	; 0xc61
     19c:	01630b07 	cmneq	r3, r7, lsl #22
     1a0:	84070000 	strhi	r0, [r7], #-0
     1a4:	03000004 	movweq	r0, #4
     1a8:	016a1d0a 	cmneq	sl, sl, lsl #26
     1ac:	00000000 	andeq	r0, r0, r0
     1b0:	15072000 	strne	r2, [r7, #-0]
     1b4:	03000006 	movweq	r0, #6
     1b8:	016a1d0d 	cmneq	sl, sp, lsl #26
     1bc:	00000000 	andeq	r0, r0, r0
     1c0:	0c082020 	stceq	0, cr2, [r8], {32}
     1c4:	03000004 	movweq	r0, #4
     1c8:	00601810 	rsbeq	r1, r0, r0, lsl r8
     1cc:	09360000 	ldmdbeq	r6!, {}	; <UNPREDICTABLE>
     1d0:	00000392 	muleq	r0, r2, r3
     1d4:	00330405 	eorseq	r0, r3, r5, lsl #8
     1d8:	13030000 	movwne	r0, #12288	; 0x3000
     1dc:	05f50a10 	ldrbeq	r0, [r5, #2576]!	; 0xa10
     1e0:	0a000000 	beq	1e8 <_start-0x7e18>
     1e4:	000005fd 	strdeq	r0, [r0], -sp
     1e8:	06050a01 	streq	r0, [r5], -r1, lsl #20
     1ec:	0a020000 	beq	801f4 <_bss_end+0x779b4>
     1f0:	0000060d 	andeq	r0, r0, sp, lsl #12
     1f4:	047c0a03 	ldrbteq	r0, [ip], #-2563	; 0xfffff5fd
     1f8:	0a040000 	beq	100200 <_bss_end+0xf79c0>
     1fc:	0000061f 	andeq	r0, r0, pc, lsl r6
     200:	041b0a05 	ldreq	r0, [fp], #-2565	; 0xfffff5fb
     204:	0a070000 	beq	1c020c <_bss_end+0x1b79cc>
     208:	00000422 	andeq	r0, r0, r2, lsr #8
     20c:	03f20a08 	mvnseq	r0, #8, 20	; 0x8000
     210:	0a0a0000 	beq	280218 <_bss_end+0x2779d8>
     214:	00000315 	andeq	r0, r0, r5, lsl r3
     218:	039b0a0b 	orrseq	r0, fp, #45056	; 0xb000
     21c:	0a0d0000 	beq	340224 <_bss_end+0x3379e4>
     220:	000003a2 	andeq	r0, r0, r2, lsr #7
     224:	04a50a0e 	strteq	r0, [r5], #2574	; 0xa0e
     228:	0a100000 	beq	400230 <_bss_end+0x3f79f0>
     22c:	000004ac 	andeq	r0, r0, ip, lsr #9
     230:	01da0a11 	bicseq	r0, sl, r1, lsl sl
     234:	0a130000 	beq	4c023c <_bss_end+0x4b79fc>
     238:	000001e1 	andeq	r0, r0, r1, ror #3
     23c:	04690a14 	strbteq	r0, [r9], #-2580	; 0xfffff5ec
     240:	0a160000 	beq	580248 <_bss_end+0x577a08>
     244:	00000470 	andeq	r0, r0, r0, ror r4
     248:	05840a17 	streq	r0, [r4, #2583]	; 0xa17
     24c:	0a190000 	beq	640254 <_bss_end+0x637a14>
     250:	0000058b 	andeq	r0, r0, fp, lsl #11
     254:	05560a1a 	ldrbeq	r0, [r6, #-2586]	; 0xfffff5e6
     258:	0a1c0000 	beq	700260 <_bss_end+0x6f7a20>
     25c:	0000055d 	andeq	r0, r0, sp, asr r5
     260:	04b30a1d 	ldrteq	r0, [r3], #2589	; 0xa1d
     264:	0a1f0000 	beq	7c026c <_bss_end+0x7b7a2c>
     268:	000004bb 			; <UNDEFINED> instruction: 0x000004bb
     26c:	054e0a20 	strbeq	r0, [lr, #-2592]	; 0xfffff5e0
     270:	0a220000 	beq	880278 <_bss_end+0x877a38>
     274:	000001e8 	andeq	r0, r0, r8, ror #3
     278:	03b50a23 			; <UNDEFINED> instruction: 0x03b50a23
     27c:	0a250000 	beq	940284 <_bss_end+0x937a44>
     280:	00000388 	andeq	r0, r0, r8, lsl #7
     284:	03e80a26 	mvneq	r0, #155648	; 0x26000
     288:	00270000 	eoreq	r0, r7, r0
     28c:	07040200 	streq	r0, [r4, -r0, lsl #4]
     290:	00000c41 	andeq	r0, r0, r1, asr #24
     294:	00016305 	andeq	r6, r1, r5, lsl #6
     298:	00780b00 	rsbseq	r0, r8, r0, lsl #22
     29c:	880b0000 	stmdahi	fp, {}	; <UNPREDICTABLE>
     2a0:	0b000000 	bleq	2a8 <_start-0x7d58>
     2a4:	00000098 	muleq	r0, r8, r0
     2a8:	0005220c 	andeq	r2, r5, ip, lsl #4
     2ac:	3a010700 	bcc	41eb4 <_bss_end+0x39674>
     2b0:	04000000 	streq	r0, [r0], #-0
     2b4:	01c70c06 	biceq	r0, r7, r6, lsl #24
     2b8:	940a0000 	strls	r0, [sl], #-0
     2bc:	00000004 	andeq	r0, r0, r4
     2c0:	0002020a 	andeq	r0, r2, sl, lsl #4
     2c4:	2f0a0100 	svccs	0x000a0100
     2c8:	02000004 	andeq	r0, r0, #4
     2cc:	0004290a 	andeq	r2, r4, sl, lsl #18
     2d0:	cf0a0300 	svcgt	0x000a0300
     2d4:	04000003 	streq	r0, [r0], #-3
     2d8:	0003af0a 	andeq	sl, r3, sl, lsl #30
     2dc:	c90a0500 	stmdbgt	sl, {r8, sl}
     2e0:	06000003 	streq	r0, [r0], -r3
     2e4:	0003a90a 	andeq	sl, r3, sl, lsl #18
     2e8:	5b0a0700 	blpl	281ef0 <_bss_end+0x2796b0>
     2ec:	08000002 	stmdaeq	r0, {r1}
     2f0:	01f00d00 	mvnseq	r0, r0, lsl #26
     2f4:	04040000 	streq	r0, [r4], #-0
     2f8:	0328071a 			; <UNDEFINED> instruction: 0x0328071a
     2fc:	480e0000 	stmdami	lr, {}	; <UNPREDICTABLE>
     300:	04000005 	streq	r0, [r0], #-5
     304:	0333191e 	teqeq	r3, #491520	; 0x78000
     308:	0f000000 	svceq	0x00000000
     30c:	00000331 	andeq	r0, r0, r1, lsr r3
     310:	450a2204 	strmi	r2, [sl, #-516]	; 0xfffffdfc
     314:	38000003 	stmdacc	r0, {r0, r1}
     318:	02000003 	andeq	r0, r0, #3
     31c:	000001fa 	strdeq	r0, [r0], -sl
     320:	0000020f 	andeq	r0, r0, pc, lsl #4
     324:	00033f10 	andeq	r3, r3, r0, lsl pc
     328:	00541100 	subseq	r1, r4, r0, lsl #2
     32c:	4a110000 	bmi	440334 <_bss_end+0x437af4>
     330:	11000003 	tstne	r0, r3
     334:	0000034a 	andeq	r0, r0, sl, asr #6
     338:	03d50f00 	bicseq	r0, r5, #0, 30
     33c:	24040000 	strcs	r0, [r4], #-0
     340:	0002e60a 	andeq	lr, r2, sl, lsl #12
     344:	00033800 	andeq	r3, r3, r0, lsl #16
     348:	02280200 	eoreq	r0, r8, #0, 4
     34c:	023d0000 	eorseq	r0, sp, #0
     350:	3f100000 	svccc	0x00100000
     354:	11000003 	tstne	r0, r3
     358:	00000054 	andeq	r0, r0, r4, asr r0
     35c:	00034a11 	andeq	r4, r3, r1, lsl sl
     360:	034a1100 	movteq	r1, #41216	; 0xa100
     364:	0f000000 	svceq	0x00000000
     368:	00000375 	andeq	r0, r0, r5, ror r3
     36c:	b70a2604 	strlt	r2, [sl, -r4, lsl #12]
     370:	38000002 	stmdacc	r0, {r1}
     374:	02000003 	andeq	r0, r0, #3
     378:	00000256 	andeq	r0, r0, r6, asr r2
     37c:	0000026b 	andeq	r0, r0, fp, ror #4
     380:	00033f10 	andeq	r3, r3, r0, lsl pc
     384:	00541100 	subseq	r1, r4, r0, lsl #2
     388:	4a110000 	bmi	440390 <_bss_end+0x437b50>
     38c:	11000003 	tstne	r0, r3
     390:	0000034a 	andeq	r0, r0, sl, asr #6
     394:	05b80f00 	ldreq	r0, [r8, #3840]!	; 0xf00
     398:	28040000 	stmdacs	r4, {}	; <UNPREDICTABLE>
     39c:	0002760a 	andeq	r7, r2, sl, lsl #12
     3a0:	00033800 	andeq	r3, r3, r0, lsl #16
     3a4:	02840200 	addeq	r0, r4, #0, 4
     3a8:	02990000 	addseq	r0, r9, #0
     3ac:	3f100000 	svccc	0x00100000
     3b0:	11000003 	tstne	r0, r3
     3b4:	00000054 	andeq	r0, r0, r4, asr r0
     3b8:	00034a11 	andeq	r4, r3, r1, lsl sl
     3bc:	034a1100 	movteq	r1, #41216	; 0xa100
     3c0:	0f000000 	svceq	0x00000000
     3c4:	000001f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     3c8:	a1052b04 	tstge	r5, r4, lsl #22
     3cc:	50000005 	andpl	r0, r0, r5
     3d0:	01000003 	tsteq	r0, r3
     3d4:	000002b2 			; <UNDEFINED> instruction: 0x000002b2
     3d8:	000002bd 			; <UNDEFINED> instruction: 0x000002bd
     3dc:	00035010 	andeq	r5, r3, r0, lsl r0
     3e0:	00651100 	rsbeq	r1, r5, r0, lsl #2
     3e4:	12000000 	andne	r0, r0, #0
     3e8:	00000457 	andeq	r0, r0, r7, asr r4
     3ec:	f90a2e04 			; <UNDEFINED> instruction: 0xf90a2e04
     3f0:	01000004 	tsteq	r0, r4
     3f4:	000002d2 	ldrdeq	r0, [r0], -r2
     3f8:	000002e2 	andeq	r0, r0, r2, ror #5
     3fc:	00035010 	andeq	r5, r3, r0, lsl r0
     400:	00541100 	subseq	r1, r4, r0, lsl #2
     404:	7e110000 	cdpvc	0, 1, cr0, cr1, cr0, {0}
     408:	00000001 	andeq	r0, r0, r1
     40c:	0002a50f 	andeq	sl, r2, pc, lsl #10
     410:	14300400 	ldrtne	r0, [r0], #-1024	; 0xfffffc00
     414:	000004d0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     418:	0000017e 	andeq	r0, r0, lr, ror r1
     41c:	0002fb01 	andeq	pc, r2, r1, lsl #22
     420:	00030600 	andeq	r0, r3, r0, lsl #12
     424:	033f1000 	teqeq	pc, #0
     428:	54110000 	ldrpl	r0, [r1], #-0
     42c:	00000000 	andeq	r0, r0, r0
     430:	0001fe13 	andeq	pc, r1, r3, lsl lr	; <UNPREDICTABLE>
     434:	0a330400 	beq	cc143c <_bss_end+0xcb8bfc>
     438:	00000435 	andeq	r0, r0, r5, lsr r4
     43c:	00031701 	andeq	r1, r3, r1, lsl #14
     440:	03501000 	cmpeq	r0, #0
     444:	54110000 	ldrpl	r0, [r1], #-0
     448:	11000000 	mrsne	r0, (UNDEF: 0)
     44c:	00000338 	andeq	r0, r0, r8, lsr r3
     450:	c7050000 	strgt	r0, [r5, -r0]
     454:	14000001 	strne	r0, [r0], #-1
     458:	00006504 	andeq	r6, r0, r4, lsl #10
     45c:	032d0500 			; <UNDEFINED> instruction: 0x032d0500
     460:	01020000 	mrseq	r0, (UNDEF: 2)
     464:	00057f02 	andeq	r7, r5, r2, lsl #30
     468:	28041400 	stmdacs	r4, {sl, ip}
     46c:	05000003 	streq	r0, [r0, #-3]
     470:	0000033f 	andeq	r0, r0, pc, lsr r3
     474:	00540415 	subseq	r0, r4, r5, lsl r4
     478:	04140000 	ldreq	r0, [r4], #-0
     47c:	000001c7 	andeq	r0, r0, r7, asr #3
     480:	00035005 	andeq	r5, r3, r5
     484:	032b1600 			; <UNDEFINED> instruction: 0x032b1600
     488:	37040000 	strcc	r0, [r4, -r0]
     48c:	0001c716 	andeq	ip, r1, r6, lsl r7
     490:	035b1700 	cmpeq	fp, #0, 14
     494:	04010000 	streq	r0, [r1], #-0
     498:	2c03050f 	cfstr32cs	mvfx0, [r3], {15}
     49c:	18000088 	stmdane	r0, {r3, r7}
     4a0:	0000031c 	andeq	r0, r0, ip, lsl r3
     4a4:	000085e4 	andeq	r8, r0, r4, ror #11
     4a8:	0000001c 	andeq	r0, r0, ip, lsl r0
     4ac:	cb199c01 	blgt	6674b8 <_bss_end+0x65ec78>
     4b0:	90000005 	andls	r0, r0, r5
     4b4:	54000085 	strpl	r0, [r0], #-133	; 0xffffff7b
     4b8:	01000000 	mrseq	r0, (UNDEF: 0)
     4bc:	0003b69c 	muleq	r3, ip, r6
     4c0:	05921a00 	ldreq	r1, [r2, #2560]	; 0xa00
     4c4:	66010000 	strvs	r0, [r1], -r0
     4c8:	00003301 	andeq	r3, r0, r1, lsl #6
     4cc:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     4d0:	00049a1a 	andeq	r9, r4, sl, lsl sl
     4d4:	01660100 	cmneq	r6, r0, lsl #2
     4d8:	00000033 	andeq	r0, r0, r3, lsr r0
     4dc:	00709102 	rsbseq	r9, r0, r2, lsl #2
     4e0:	0003061b 	andeq	r0, r3, fp, lsl r6
     4e4:	065f0100 	ldrbeq	r0, [pc], -r0, lsl #2
     4e8:	000003d0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     4ec:	000084b8 			; <UNDEFINED> instruction: 0x000084b8
     4f0:	000000d8 	ldrdeq	r0, [r0], -r8
     4f4:	04199c01 	ldreq	r9, [r9], #-3073	; 0xfffff3ff
     4f8:	cb1c0000 	blgt	700500 <_bss_end+0x6f7cc0>
     4fc:	56000004 	strpl	r0, [r0], -r4
     500:	02000003 	andeq	r0, r0, #3
     504:	701d6c91 	mulsvc	sp, r1, ip
     508:	01006e69 	tsteq	r0, r9, ror #28
     50c:	0054295f 	subseq	r2, r4, pc, asr r9
     510:	91020000 	mrsls	r0, (UNDEF: 2)
     514:	65731d68 	ldrbvs	r1, [r3, #-3432]!	; 0xfffff298
     518:	5f010074 	svcpl	0x00010074
     51c:	00033833 	andeq	r3, r3, r3, lsr r8
     520:	67910200 	ldrvs	r0, [r1, r0, lsl #4]
     524:	6765721e 			; <UNDEFINED> instruction: 0x6765721e
     528:	0e610100 	poweqs	f0, f1, f0
     52c:	00000054 	andeq	r0, r0, r4, asr r0
     530:	1e749102 	expnes	f1, f2
     534:	00746962 	rsbseq	r6, r4, r2, ror #18
     538:	54136101 	ldrpl	r6, [r3], #-257	; 0xfffffeff
     53c:	02000000 	andeq	r0, r0, #0
     540:	1b007091 	blne	1c78c <_bss_end+0x13f4c>
     544:	000002e2 	andeq	r0, r0, r2, ror #5
     548:	33105601 	tstcc	r0, #1048576	; 0x100000
     54c:	3c000004 	stccc	0, cr0, [r0], {4}
     550:	7c000084 	stcvc	0, cr0, [r0], {132}	; 0x84
     554:	01000000 	mrseq	r0, (UNDEF: 0)
     558:	00046d9c 	muleq	r4, ip, sp
     55c:	04cb1c00 	strbeq	r1, [fp], #3072	; 0xc00
     560:	03450000 	movteq	r0, #20480	; 0x5000
     564:	91020000 	mrsls	r0, (UNDEF: 2)
     568:	69701d6c 	ldmdbvs	r0!, {r2, r3, r5, r6, r8, sl, fp, ip}^
     56c:	5601006e 	strpl	r0, [r1], -lr, rrx
     570:	0000543a 	andeq	r5, r0, sl, lsr r4
     574:	68910200 	ldmvs	r1, {r9}
     578:	6765721e 			; <UNDEFINED> instruction: 0x6765721e
     57c:	0e580100 	rdfeqe	f0, f0, f0
     580:	00000054 	andeq	r0, r0, r4, asr r0
     584:	1e749102 	expnes	f1, f2
     588:	00746962 	rsbseq	r6, r4, r2, ror #18
     58c:	54135801 	ldrpl	r5, [r3], #-2049	; 0xfffff7ff
     590:	02000000 	andeq	r0, r0, #0
     594:	1b007091 	blne	1c7e0 <_bss_end+0x13fa0>
     598:	000002bd 			; <UNDEFINED> instruction: 0x000002bd
     59c:	87064d01 	strhi	r4, [r6, -r1, lsl #26]
     5a0:	94000004 	strls	r0, [r0], #-4
     5a4:	a8000083 	stmdage	r0, {r0, r1, r7}
     5a8:	01000000 	mrseq	r0, (UNDEF: 0)
     5ac:	0004d09c 	muleq	r4, ip, r0
     5b0:	04cb1c00 	strbeq	r1, [fp], #3072	; 0xc00
     5b4:	03560000 	cmpeq	r6, #0
     5b8:	91020000 	mrsls	r0, (UNDEF: 2)
     5bc:	69701d6c 	ldmdbvs	r0!, {r2, r3, r5, r6, r8, sl, fp, ip}^
     5c0:	4d01006e 	stcmi	0, cr0, [r1, #-440]	; 0xfffffe48
     5c4:	00005430 	andeq	r5, r0, r0, lsr r4
     5c8:	68910200 	ldmvs	r1, {r9}
     5cc:	0004771a 	andeq	r7, r4, sl, lsl r7
     5d0:	444d0100 	strbmi	r0, [sp], #-256	; 0xffffff00
     5d4:	0000017e 	andeq	r0, r0, lr, ror r1
     5d8:	1e679102 	lgnnes	f1, f2
     5dc:	00676572 	rsbeq	r6, r7, r2, ror r5
     5e0:	540e4f01 	strpl	r4, [lr], #-3841	; 0xfffff0ff
     5e4:	02000000 	andeq	r0, r0, #0
     5e8:	621e7491 	andsvs	r7, lr, #-1862270976	; 0x91000000
     5ec:	01007469 	tsteq	r0, r9, ror #8
     5f0:	0054134f 	subseq	r1, r4, pc, asr #6
     5f4:	91020000 	mrsls	r0, (UNDEF: 2)
     5f8:	6b1f0070 	blvs	7c07c0 <_bss_end+0x7b7f80>
     5fc:	01000002 	tsteq	r0, r2
     600:	04ea0642 	strbteq	r0, [sl], #1602	; 0x642
     604:	83200000 	nophi	{0}	; <UNPREDICTABLE>
     608:	00740000 	rsbseq	r0, r4, r0
     60c:	9c010000 	stcls	0, cr0, [r1], {-0}
     610:	00000524 	andeq	r0, r0, r4, lsr #10
     614:	0004cb1c 	andeq	ip, r4, ip, lsl fp
     618:	00034500 	andeq	r4, r3, r0, lsl #10
     61c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     620:	6e69701d 	mcrvs	0, 3, r7, cr9, cr13, {0}
     624:	31420100 	mrscc	r0, (UNDEF: 82)
     628:	00000054 	andeq	r0, r0, r4, asr r0
     62c:	1d709102 	ldfnep	f1, [r0, #-8]!
     630:	00676572 	rsbeq	r6, r7, r2, ror r5
     634:	4a404201 	bmi	1010e40 <_bss_end+0x1008600>
     638:	02000003 	andeq	r0, r0, #3
     63c:	641a6c91 	ldrvs	r6, [sl], #-3217	; 0xfffff36f
     640:	01000005 	tsteq	r0, r5
     644:	034a4f42 	movteq	r4, #44866	; 0xaf42
     648:	91020000 	mrsls	r0, (UNDEF: 2)
     64c:	3d1f0068 	ldccc	0, cr0, [pc, #-416]	; 4b4 <_start-0x7b4c>
     650:	01000002 	tsteq	r0, r2
     654:	053e0637 	ldreq	r0, [lr, #-1591]!	; 0xfffff9c9
     658:	82ac0000 	adchi	r0, ip, #0
     65c:	00740000 	rsbseq	r0, r4, r0
     660:	9c010000 	stcls	0, cr0, [r1], {-0}
     664:	00000578 	andeq	r0, r0, r8, ror r5
     668:	0004cb1c 	andeq	ip, r4, ip, lsl fp
     66c:	00034500 	andeq	r4, r3, r0, lsl #10
     670:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     674:	6e69701d 	mcrvs	0, 3, r7, cr9, cr13, {0}
     678:	31370100 	teqcc	r7, r0, lsl #2
     67c:	00000054 	andeq	r0, r0, r4, asr r0
     680:	1d709102 	ldfnep	f1, [r0, #-8]!
     684:	00676572 	rsbeq	r6, r7, r2, ror r5
     688:	4a403701 	bmi	100e294 <_bss_end+0x1005a54>
     68c:	02000003 	andeq	r0, r0, #3
     690:	641a6c91 	ldrvs	r6, [sl], #-3217	; 0xfffff36f
     694:	01000005 	tsteq	r0, r5
     698:	034a4f37 	movteq	r4, #44855	; 0xaf37
     69c:	91020000 	mrsls	r0, (UNDEF: 2)
     6a0:	0f1f0068 	svceq	0x001f0068
     6a4:	01000002 	tsteq	r0, r2
     6a8:	0592062c 	ldreq	r0, [r2, #1580]	; 0x62c
     6ac:	82380000 	eorshi	r0, r8, #0
     6b0:	00740000 	rsbseq	r0, r4, r0
     6b4:	9c010000 	stcls	0, cr0, [r1], {-0}
     6b8:	000005cc 	andeq	r0, r0, ip, asr #11
     6bc:	0004cb1c 	andeq	ip, r4, ip, lsl fp
     6c0:	00034500 	andeq	r4, r3, r0, lsl #10
     6c4:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     6c8:	6e69701d 	mcrvs	0, 3, r7, cr9, cr13, {0}
     6cc:	312c0100 			; <UNDEFINED> instruction: 0x312c0100
     6d0:	00000054 	andeq	r0, r0, r4, asr r0
     6d4:	1d709102 	ldfnep	f1, [r0, #-8]!
     6d8:	00676572 	rsbeq	r6, r7, r2, ror r5
     6dc:	4a402c01 	bmi	100b6e8 <_bss_end+0x1002ea8>
     6e0:	02000003 	andeq	r0, r0, #3
     6e4:	641a6c91 	ldrvs	r6, [sl], #-3217	; 0xfffff36f
     6e8:	01000005 	tsteq	r0, r5
     6ec:	034a4f2c 	movteq	r4, #44844	; 0xaf2c
     6f0:	91020000 	mrsls	r0, (UNDEF: 2)
     6f4:	e11f0068 	tst	pc, r8, rrx
     6f8:	01000001 	tsteq	r0, r1
     6fc:	05e6060c 	strbeq	r0, [r6, #1548]!	; 0x60c
     700:	81240000 			; <UNDEFINED> instruction: 0x81240000
     704:	01140000 	tsteq	r4, r0
     708:	9c010000 	stcls	0, cr0, [r1], {-0}
     70c:	00000620 	andeq	r0, r0, r0, lsr #12
     710:	0004cb1c 	andeq	ip, r4, ip, lsl fp
     714:	00034500 	andeq	r4, r3, r0, lsl #10
     718:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     71c:	6e69701d 	mcrvs	0, 3, r7, cr9, cr13, {0}
     720:	320c0100 	andcc	r0, ip, #0, 2
     724:	00000054 	andeq	r0, r0, r4, asr r0
     728:	1d709102 	ldfnep	f1, [r0, #-8]!
     72c:	00676572 	rsbeq	r6, r7, r2, ror r5
     730:	4a410c01 	bmi	104373c <_bss_end+0x103aefc>
     734:	02000003 	andeq	r0, r0, #3
     738:	641a6c91 	ldrvs	r6, [sl], #-3217	; 0xfffff36f
     73c:	01000005 	tsteq	r0, r5
     740:	034a500c 	movteq	r5, #40972	; 0xa00c
     744:	91020000 	mrsls	r0, (UNDEF: 2)
     748:	99200068 	stmdbls	r0!, {r3, r5, r6}
     74c:	01000002 	tsteq	r0, r2
     750:	06310106 	ldrteq	r0, [r1], -r6, lsl #2
     754:	47000000 	strmi	r0, [r0, -r0]
     758:	21000006 	tstcs	r0, r6
     75c:	000004cb 	andeq	r0, r0, fp, asr #9
     760:	00000356 	andeq	r0, r0, r6, asr r3
     764:	00026722 	andeq	r6, r2, r2, lsr #14
     768:	2b060100 	blcs	180b70 <_bss_end+0x178330>
     76c:	00000065 	andeq	r0, r0, r5, rrx
     770:	06202300 	strteq	r2, [r0], -r0, lsl #6
     774:	05310000 	ldreq	r0, [r1, #-0]!
     778:	065e0000 	ldrbeq	r0, [lr], -r0
     77c:	80f00000 	rscshi	r0, r0, r0
     780:	00340000 	eorseq	r0, r4, r0
     784:	9c010000 	stcls	0, cr0, [r1], {-0}
     788:	00063124 	andeq	r3, r6, r4, lsr #2
     78c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     790:	00063a24 	andeq	r3, r6, r4, lsr #20
     794:	70910200 	addsvc	r0, r1, r0, lsl #4
     798:	02850000 	addeq	r0, r5, #0
     79c:	00040000 	andeq	r0, r4, r0
     7a0:	0000031a 	andeq	r0, r0, sl, lsl r3
     7a4:	00850104 	addeq	r0, r5, r4, lsl #2
     7a8:	27040000 	strcs	r0, [r4, -r0]
     7ac:	49000006 	stmdbmi	r0, {r1, r2}
     7b0:	00000000 	andeq	r0, r0, r0
     7b4:	ac000086 	stcge	0, cr0, [r0], {134}	; 0x86
     7b8:	94000000 	strls	r0, [r0], #-0
     7bc:	02000003 	andeq	r0, r0, #3
     7c0:	03c40801 	biceq	r0, r4, #65536	; 0x10000
     7c4:	02020000 	andeq	r0, r2, #0
     7c8:	00056c05 	andeq	r6, r5, r5, lsl #24
     7cc:	05040300 	streq	r0, [r4, #-768]	; 0xfffffd00
     7d0:	00746e69 	rsbseq	r6, r4, r9, ror #28
     7d4:	0004c304 	andeq	ip, r4, r4, lsl #6
     7d8:	07090200 	streq	r0, [r9, -r0, lsl #4]
     7dc:	00000046 	andeq	r0, r0, r6, asr #32
     7e0:	bb080102 	bllt	200bf0 <_bss_end+0x1f83b0>
     7e4:	02000003 	andeq	r0, r0, #3
     7e8:	03f90702 	mvnseq	r0, #524288	; 0x80000
     7ec:	76040000 	strvc	r0, [r4], -r0
     7f0:	02000005 	andeq	r0, r0, #5
     7f4:	0065070b 	rsbeq	r0, r5, fp, lsl #14
     7f8:	54050000 	strpl	r0, [r5], #-0
     7fc:	02000000 	andeq	r0, r0, #0
     800:	0c460704 	mcrreq	7, 0, r0, r6, cr4
     804:	65060000 	strvs	r0, [r6, #-0]
     808:	07000000 	streq	r0, [r0, -r0]
     80c:	00000522 	andeq	r0, r0, r2, lsr #10
     810:	003a0107 	eorseq	r0, sl, r7, lsl #2
     814:	06030000 	streq	r0, [r3], -r0
     818:	0000ba0c 	andeq	fp, r0, ip, lsl #20
     81c:	04940800 	ldreq	r0, [r4], #2048	; 0x800
     820:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
     824:	00000202 	andeq	r0, r0, r2, lsl #4
     828:	042f0801 	strteq	r0, [pc], #-2049	; 830 <_start-0x77d0>
     82c:	08020000 	stmdaeq	r2, {}	; <UNPREDICTABLE>
     830:	00000429 	andeq	r0, r0, r9, lsr #8
     834:	03cf0803 	biceq	r0, pc, #196608	; 0x30000
     838:	08040000 	stmdaeq	r4, {}	; <UNPREDICTABLE>
     83c:	000003af 	andeq	r0, r0, pc, lsr #7
     840:	03c90805 	biceq	r0, r9, #327680	; 0x50000
     844:	08060000 	stmdaeq	r6, {}	; <UNPREDICTABLE>
     848:	000003a9 	andeq	r0, r0, r9, lsr #7
     84c:	025b0807 	subseq	r0, fp, #458752	; 0x70000
     850:	00080000 	andeq	r0, r8, r0
     854:	0001f009 	andeq	pc, r1, r9
     858:	1a030400 	bne	c1860 <_bss_end+0xb9020>
     85c:	00021b07 	andeq	r1, r2, r7, lsl #22
     860:	05480a00 	strbeq	r0, [r8, #-2560]	; 0xfffff600
     864:	1e030000 	cdpne	0, 0, cr0, cr3, cr0, {0}
     868:	00022619 	andeq	r2, r2, r9, lsl r6
     86c:	310b0000 	mrscc	r0, (UNDEF: 11)
     870:	03000003 	movweq	r0, #3
     874:	03450a22 	movteq	r0, #23074	; 0x5a22
     878:	022b0000 	eoreq	r0, fp, #0
     87c:	ed020000 	stc	0, cr0, [r2, #-0]
     880:	02000000 	andeq	r0, r0, #0
     884:	0c000001 	stceq	0, cr0, [r0], {1}
     888:	00000232 	andeq	r0, r0, r2, lsr r2
     88c:	0000540d 	andeq	r5, r0, sp, lsl #8
     890:	02380d00 	eorseq	r0, r8, #0, 26
     894:	380d0000 	stmdacc	sp, {}	; <UNPREDICTABLE>
     898:	00000002 	andeq	r0, r0, r2
     89c:	0003d50b 	andeq	sp, r3, fp, lsl #10
     8a0:	0a240300 	beq	9014a8 <_bss_end+0x8f8c68>
     8a4:	000002e6 	andeq	r0, r0, r6, ror #5
     8a8:	0000022b 	andeq	r0, r0, fp, lsr #4
     8ac:	00011b02 	andeq	r1, r1, r2, lsl #22
     8b0:	00013000 	andeq	r3, r1, r0
     8b4:	02320c00 	eorseq	r0, r2, #0, 24
     8b8:	540d0000 	strpl	r0, [sp], #-0
     8bc:	0d000000 	stceq	0, cr0, [r0, #-0]
     8c0:	00000238 	andeq	r0, r0, r8, lsr r2
     8c4:	0002380d 	andeq	r3, r2, sp, lsl #16
     8c8:	750b0000 	strvc	r0, [fp, #-0]
     8cc:	03000003 	movweq	r0, #3
     8d0:	02b70a26 	adcseq	r0, r7, #155648	; 0x26000
     8d4:	022b0000 	eoreq	r0, fp, #0
     8d8:	49020000 	stmdbmi	r2, {}	; <UNPREDICTABLE>
     8dc:	5e000001 	cdppl	0, 0, cr0, cr0, cr1, {0}
     8e0:	0c000001 	stceq	0, cr0, [r0], {1}
     8e4:	00000232 	andeq	r0, r0, r2, lsr r2
     8e8:	0000540d 	andeq	r5, r0, sp, lsl #8
     8ec:	02380d00 	eorseq	r0, r8, #0, 26
     8f0:	380d0000 	stmdacc	sp, {}	; <UNPREDICTABLE>
     8f4:	00000002 	andeq	r0, r0, r2
     8f8:	0005b80b 	andeq	fp, r5, fp, lsl #16
     8fc:	0a280300 	beq	a01504 <_bss_end+0x9f8cc4>
     900:	00000276 	andeq	r0, r0, r6, ror r2
     904:	0000022b 	andeq	r0, r0, fp, lsr #4
     908:	00017702 	andeq	r7, r1, r2, lsl #14
     90c:	00018c00 	andeq	r8, r1, r0, lsl #24
     910:	02320c00 	eorseq	r0, r2, #0, 24
     914:	540d0000 	strpl	r0, [sp], #-0
     918:	0d000000 	stceq	0, cr0, [r0, #-0]
     91c:	00000238 	andeq	r0, r0, r8, lsr r2
     920:	0002380d 	andeq	r3, r2, sp, lsl #16
     924:	f00b0000 			; <UNDEFINED> instruction: 0xf00b0000
     928:	03000001 	movweq	r0, #1
     92c:	05a1052b 	streq	r0, [r1, #1323]!	; 0x52b
     930:	023e0000 	eorseq	r0, lr, #0
     934:	a5010000 	strge	r0, [r1, #-0]
     938:	b0000001 	andlt	r0, r0, r1
     93c:	0c000001 	stceq	0, cr0, [r0], {1}
     940:	0000023e 	andeq	r0, r0, lr, lsr r2
     944:	0000650d 	andeq	r6, r0, sp, lsl #10
     948:	570e0000 	strpl	r0, [lr, -r0]
     94c:	03000004 	movweq	r0, #4
     950:	04f90a2e 	ldrbteq	r0, [r9], #2606	; 0xa2e
     954:	c5010000 	strgt	r0, [r1, #-0]
     958:	d5000001 	strle	r0, [r0, #-1]
     95c:	0c000001 	stceq	0, cr0, [r0], {1}
     960:	0000023e 	andeq	r0, r0, lr, lsr r2
     964:	0000540d 	andeq	r5, r0, sp, lsl #8
     968:	00710d00 	rsbseq	r0, r1, r0, lsl #26
     96c:	0b000000 	bleq	974 <_start-0x768c>
     970:	000002a5 	andeq	r0, r0, r5, lsr #5
     974:	d0143003 	andsle	r3, r4, r3
     978:	71000004 	tstvc	r0, r4
     97c:	01000000 	mrseq	r0, (UNDEF: 0)
     980:	000001ee 	andeq	r0, r0, lr, ror #3
     984:	000001f9 	strdeq	r0, [r0], -r9
     988:	0002320c 	andeq	r3, r2, ip, lsl #4
     98c:	00540d00 	subseq	r0, r4, r0, lsl #26
     990:	0f000000 	svceq	0x00000000
     994:	000001fe 	strdeq	r0, [r0], -lr
     998:	350a3303 	strcc	r3, [sl, #-771]	; 0xfffffcfd
     99c:	01000004 	tsteq	r0, r4
     9a0:	0000020a 	andeq	r0, r0, sl, lsl #4
     9a4:	00023e0c 	andeq	r3, r2, ip, lsl #28
     9a8:	00540d00 	subseq	r0, r4, r0, lsl #26
     9ac:	2b0d0000 	blcs	3409b4 <_bss_end+0x338174>
     9b0:	00000002 	andeq	r0, r0, r2
     9b4:	00ba0500 	adcseq	r0, sl, r0, lsl #10
     9b8:	04100000 	ldreq	r0, [r0], #-0
     9bc:	00000065 	andeq	r0, r0, r5, rrx
     9c0:	00022005 	andeq	r2, r2, r5
     9c4:	02010200 	andeq	r0, r1, #0, 4
     9c8:	0000057f 	andeq	r0, r0, pc, ror r5
     9cc:	021b0410 	andseq	r0, fp, #16, 8	; 0x10000000
     9d0:	04110000 	ldreq	r0, [r1], #-0
     9d4:	00000054 	andeq	r0, r0, r4, asr r0
     9d8:	00ba0410 	adcseq	r0, sl, r0, lsl r4
     9dc:	2b120000 	blcs	4809e4 <_bss_end+0x4781a4>
     9e0:	03000003 	movweq	r0, #3
     9e4:	00ba1637 	adcseq	r1, sl, r7, lsr r6
     9e8:	71130000 	tstvc	r3, r0
     9ec:	01000006 	tsteq	r0, r6
     9f0:	00601404 	rsbeq	r1, r0, r4, lsl #8
     9f4:	03050000 	movweq	r0, #20480	; 0x5000
     9f8:	00008824 	andeq	r8, r0, r4, lsr #16
     9fc:	00067914 	andeq	r7, r6, r4, lsl r9
     a00:	10060100 	andne	r0, r6, r0, lsl #2
     a04:	00000033 	andeq	r0, r0, r3, lsr r0
     a08:	00008600 	andeq	r8, r0, r0, lsl #12
     a0c:	000000ac 	andeq	r0, r0, ip, lsr #1
     a10:	74159c01 	ldrvc	r9, [r5], #-3073	; 0xfffff3ff
     a14:	01006d69 	tsteq	r0, r9, ror #26
     a18:	006c1b0b 	rsbeq	r1, ip, fp, lsl #22
     a1c:	91020000 	mrsls	r0, (UNDEF: 2)
     a20:	22000074 	andcs	r0, r0, #116	; 0x74
     a24:	02000000 	andeq	r0, r0, #0
     a28:	00046100 	andeq	r6, r4, r0, lsl #2
     a2c:	f4010400 	vst3.8	{d0-d2}, [r1], r0
     a30:	00000004 	andeq	r0, r0, r4
     a34:	18000080 	stmdane	r0, {r7}
     a38:	86000080 	strhi	r0, [r0], -r0, lsl #1
     a3c:	49000006 	stmdbmi	r0, {r1, r2}
     a40:	cf000000 	svcgt	0x00000000
     a44:	01000006 	tsteq	r0, r6
     a48:	00014b80 	andeq	r4, r1, r0, lsl #23
     a4c:	75000400 	strvc	r0, [r0, #-1024]	; 0xfffffc00
     a50:	04000004 	streq	r0, [r0], #-4
     a54:	00008501 	andeq	r8, r0, r1, lsl #10
     a58:	071c0400 	ldreq	r0, [ip, -r0, lsl #8]
     a5c:	00490000 	subeq	r0, r9, r0
     a60:	86ac0000 	strthi	r0, [ip], r0
     a64:	01180000 	tsteq	r8, r0
     a68:	056f0000 	strbeq	r0, [pc, #-0]!	; a70 <_start-0x7590>
     a6c:	89020000 	stmdbhi	r2, {}	; <UNPREDICTABLE>
     a70:	01000007 	tsteq	r0, r7
     a74:	00310702 	eorseq	r0, r1, r2, lsl #14
     a78:	04030000 	streq	r0, [r3], #-0
     a7c:	00000037 	andeq	r0, r0, r7, lsr r0
     a80:	07800204 	streq	r0, [r0, r4, lsl #4]
     a84:	03010000 	movweq	r0, #4096	; 0x1000
     a88:	00003107 	andeq	r3, r0, r7, lsl #2
     a8c:	06db0500 	ldrbeq	r0, [fp], r0, lsl #10
     a90:	06010000 	streq	r0, [r1], -r0
     a94:	00005010 	andeq	r5, r0, r0, lsl r0
     a98:	05040600 	streq	r0, [r4, #-1536]	; 0xfffffa00
     a9c:	00746e69 	rsbseq	r6, r4, r9, ror #28
     aa0:	00076905 	andeq	r6, r7, r5, lsl #18
     aa4:	10080100 	andne	r0, r8, r0, lsl #2
     aa8:	00000050 	andeq	r0, r0, r0, asr r0
     aac:	00002507 	andeq	r2, r0, r7, lsl #10
     ab0:	00007600 	andeq	r7, r0, r0, lsl #12
     ab4:	00760800 	rsbseq	r0, r6, r0, lsl #16
     ab8:	ffff0000 			; <UNDEFINED> instruction: 0xffff0000
     abc:	0900ffff 	stmdbeq	r0, {r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, fp, ip, sp, lr, pc}
     ac0:	0c460704 	mcrreq	7, 0, r0, r6, cr4
     ac4:	f3050000 	vhadd.u8	d0, d5, d0
     ac8:	01000006 	tsteq	r0, r6
     acc:	0063150b 	rsbeq	r1, r3, fp, lsl #10
     ad0:	e6050000 	str	r0, [r5], -r0
     ad4:	01000006 	tsteq	r0, r6
     ad8:	0063150d 	rsbeq	r1, r3, sp, lsl #10
     adc:	38070000 	stmdacc	r7, {}	; <UNPREDICTABLE>
     ae0:	a8000000 	stmdage	r0, {}	; <UNPREDICTABLE>
     ae4:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
     ae8:	00000076 	andeq	r0, r0, r6, ror r0
     aec:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
     af0:	07720500 	ldrbeq	r0, [r2, -r0, lsl #10]!
     af4:	10010000 	andne	r0, r1, r0
     af8:	00009515 	andeq	r9, r0, r5, lsl r5
     afc:	07010500 	streq	r0, [r1, -r0, lsl #10]
     b00:	12010000 	andne	r0, r1, #0
     b04:	00009515 	andeq	r9, r0, r5, lsl r5
     b08:	070e0a00 	streq	r0, [lr, -r0, lsl #20]
     b0c:	2b010000 	blcs	40b14 <_bss_end+0x382d4>
     b10:	00005010 	andeq	r5, r0, r0, lsl r0
     b14:	00876c00 	addeq	r6, r7, r0, lsl #24
     b18:	00005800 	andeq	r5, r0, r0, lsl #16
     b1c:	ea9c0100 	b	fe700f24 <_bss_end+0xfe6f86e4>
     b20:	0b000000 	bleq	b28 <_start-0x74d8>
     b24:	000007aa 	andeq	r0, r0, sl, lsr #15
     b28:	ea0f2d01 	b	3cbf34 <_bss_end+0x3c36f4>
     b2c:	02000000 	andeq	r0, r0, #0
     b30:	03007491 	movweq	r7, #1169	; 0x491
     b34:	00003804 	andeq	r3, r0, r4, lsl #16
     b38:	079d0a00 	ldreq	r0, [sp, r0, lsl #20]
     b3c:	1f010000 	svcne	0x00010000
     b40:	00005010 	andeq	r5, r0, r0, lsl r0
     b44:	00871400 	addeq	r1, r7, r0, lsl #8
     b48:	00005800 	andeq	r5, r0, r0, lsl #16
     b4c:	1a9c0100 	bne	fe700f54 <_bss_end+0xfe6f8714>
     b50:	0b000001 	bleq	b5c <_start-0x74a4>
     b54:	000007aa 	andeq	r0, r0, sl, lsr #15
     b58:	1a0f2101 	bne	3c8f64 <_bss_end+0x3c0724>
     b5c:	02000001 	andeq	r0, r0, #1
     b60:	03007491 	movweq	r7, #1169	; 0x491
     b64:	00002504 	andeq	r2, r0, r4, lsl #10
     b68:	07920c00 	ldreq	r0, [r2, r0, lsl #24]
     b6c:	14010000 	strne	r0, [r1], #-0
     b70:	00005010 	andeq	r5, r0, r0, lsl r0
     b74:	0086ac00 	addeq	sl, r6, r0, lsl #24
     b78:	00006800 	andeq	r6, r0, r0, lsl #16
     b7c:	489c0100 	ldmmi	ip, {r8}
     b80:	0d000001 	stceq	0, cr0, [r0, #-4]
     b84:	16010069 	strne	r0, [r1], -r9, rrx
     b88:	0001480a 	andeq	r4, r1, sl, lsl #16
     b8c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     b90:	50040300 	andpl	r0, r4, r0, lsl #6
     b94:	00000000 	andeq	r0, r0, r0
     b98:	00000932 	andeq	r0, r0, r2, lsr r9
     b9c:	053b0004 	ldreq	r0, [fp, #-4]!
     ba0:	01040000 	mrseq	r0, (UNDEF: 4)
     ba4:	00000b19 	andeq	r0, r0, r9, lsl fp
     ba8:	000a700c 	andeq	r7, sl, ip
     bac:	00123d00 	andseq	r3, r2, r0, lsl #26
     bb0:	00065700 	andeq	r5, r6, r0, lsl #14
     bb4:	05040200 	streq	r0, [r4, #-512]	; 0xfffffe00
     bb8:	00746e69 	rsbseq	r6, r4, r9, ror #28
     bbc:	46070403 	strmi	r0, [r7], -r3, lsl #8
     bc0:	0300000c 	movweq	r0, #12
     bc4:	01cc0508 	biceq	r0, ip, r8, lsl #10
     bc8:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
     bcc:	00137d04 	andseq	r7, r3, r4, lsl #26
     bd0:	0acb0400 	beq	ff2c1bd8 <_bss_end+0xff2b9398>
     bd4:	2a010000 	bcs	40bdc <_bss_end+0x3839c>
     bd8:	00002416 	andeq	r2, r0, r6, lsl r4
     bdc:	0f3a0400 	svceq	0x003a0400
     be0:	2f010000 	svccs	0x00010000
     be4:	00005115 	andeq	r5, r0, r5, lsl r1
     be8:	57040500 	strpl	r0, [r4, -r0, lsl #10]
     bec:	06000000 	streq	r0, [r0], -r0
     bf0:	00000039 	andeq	r0, r0, r9, lsr r0
     bf4:	00000066 	andeq	r0, r0, r6, rrx
     bf8:	00006607 	andeq	r6, r0, r7, lsl #12
     bfc:	04050000 	streq	r0, [r5], #-0
     c00:	0000006c 	andeq	r0, r0, ip, rrx
     c04:	16d10408 	ldrbne	r0, [r1], r8, lsl #8
     c08:	36010000 	strcc	r0, [r1], -r0
     c0c:	0000790f 	andeq	r7, r0, pc, lsl #18
     c10:	7f040500 	svcvc	0x00040500
     c14:	06000000 	streq	r0, [r0], -r0
     c18:	0000001d 	andeq	r0, r0, sp, lsl r0
     c1c:	00000093 	muleq	r0, r3, r0
     c20:	00006607 	andeq	r6, r0, r7, lsl #12
     c24:	00660700 	rsbeq	r0, r6, r0, lsl #14
     c28:	03000000 	movweq	r0, #0
     c2c:	03bb0801 			; <UNDEFINED> instruction: 0x03bb0801
     c30:	72090000 	andvc	r0, r9, #0
     c34:	01000011 	tsteq	r0, r1, lsl r0
     c38:	004512bb 	strheq	r1, [r5], #-43	; 0xffffffd5
     c3c:	ff090000 			; <UNDEFINED> instruction: 0xff090000
     c40:	01000016 	tsteq	r0, r6, lsl r0
     c44:	006d10be 	strhteq	r1, [sp], #-14
     c48:	01030000 	mrseq	r0, (UNDEF: 3)
     c4c:	0003bd06 	andeq	fp, r3, r6, lsl #26
     c50:	0e5a0a00 	vnmlseq.f32	s1, s20, s0
     c54:	01070000 	mrseq	r0, (UNDEF: 7)
     c58:	00000093 	muleq	r0, r3, r0
     c5c:	e6061702 	str	r1, [r6], -r2, lsl #14
     c60:	0b000001 	bleq	c6c <_start-0x7394>
     c64:	00000929 	andeq	r0, r0, r9, lsr #18
     c68:	0d770b00 	vldmdbeq	r7!, {d16-d15}
     c6c:	0b010000 	bleq	40c74 <_bss_end+0x38434>
     c70:	000012a2 	andeq	r1, r0, r2, lsr #5
     c74:	16130b02 	ldrne	r0, [r3], -r2, lsl #22
     c78:	0b030000 	bleq	c0c80 <_bss_end+0xb8440>
     c7c:	000011e1 	andeq	r1, r0, r1, ror #3
     c80:	151c0b04 	ldrne	r0, [ip, #-2820]	; 0xfffff4fc
     c84:	0b050000 	bleq	140c8c <_bss_end+0x13844c>
     c88:	00001480 	andeq	r1, r0, r0, lsl #9
     c8c:	094a0b06 	stmdbeq	sl, {r1, r2, r8, r9, fp}^
     c90:	0b070000 	bleq	1c0c98 <_bss_end+0x1b8458>
     c94:	00001531 	andeq	r1, r0, r1, lsr r5
     c98:	153f0b08 	ldrne	r0, [pc, #-2824]!	; 198 <_start-0x7e68>
     c9c:	0b090000 	bleq	240ca4 <_bss_end+0x238464>
     ca0:	00001606 	andeq	r1, r0, r6, lsl #12
     ca4:	11380b0a 	teqne	r8, sl, lsl #22
     ca8:	0b0b0000 	bleq	2c0cb0 <_bss_end+0x2b8470>
     cac:	00000b0c 	andeq	r0, r0, ip, lsl #22
     cb0:	0be90b0c 	bleq	ffa438e8 <_bss_end+0xffa3b0a8>
     cb4:	0b0d0000 	bleq	340cbc <_bss_end+0x33847c>
     cb8:	00000e9e 	muleq	r0, lr, lr
     cbc:	0eb40b0e 	vmoveq.f64	d0, #78	; 0x3e700000  0.2343750
     cc0:	0b0f0000 	bleq	3c0cc8 <_bss_end+0x3b8488>
     cc4:	00000db1 			; <UNDEFINED> instruction: 0x00000db1
     cc8:	11c50b10 	bicne	r0, r5, r0, lsl fp
     ccc:	0b110000 	bleq	440cd4 <_bss_end+0x438494>
     cd0:	00000e1d 	andeq	r0, r0, sp, lsl lr
     cd4:	18980b12 	ldmne	r8, {r1, r4, r8, r9, fp}
     cd8:	0b130000 	bleq	4c0ce0 <_bss_end+0x4b84a0>
     cdc:	000009b3 			; <UNDEFINED> instruction: 0x000009b3
     ce0:	0e410b14 	vmoveq.8	d1[0], r0
     ce4:	0b150000 	bleq	540cec <_bss_end+0x5384ac>
     ce8:	000008f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     cec:	16360b16 			; <UNDEFINED> instruction: 0x16360b16
     cf0:	0b170000 	bleq	5c0cf8 <_bss_end+0x5b84b8>
     cf4:	00001758 	andeq	r1, r0, r8, asr r7
     cf8:	0e660b18 	vmoveq.8	d6[4], r0
     cfc:	0b190000 	bleq	640d04 <_bss_end+0x6384c4>
     d00:	00001314 	andeq	r1, r0, r4, lsl r3
     d04:	16440b1a 			; <UNDEFINED> instruction: 0x16440b1a
     d08:	0b1b0000 	bleq	6c0d10 <_bss_end+0x6b84d0>
     d0c:	0000081f 	andeq	r0, r0, pc, lsl r8
     d10:	16520b1c 			; <UNDEFINED> instruction: 0x16520b1c
     d14:	0b1d0000 	bleq	740d1c <_bss_end+0x7384dc>
     d18:	00001660 	andeq	r1, r0, r0, ror #12
     d1c:	07cd0b1e 	bfieq	r0, lr, (invalid: 22:13)
     d20:	0b1f0000 	bleq	7c0d28 <_bss_end+0x7b84e8>
     d24:	0000168a 	andeq	r1, r0, sl, lsl #13
     d28:	13c10b20 	bicne	r0, r1, #32, 22	; 0x8000
     d2c:	0b210000 	bleq	840d34 <_bss_end+0x8384f4>
     d30:	00001197 	muleq	r0, r7, r1
     d34:	16290b22 	strtne	r0, [r9], -r2, lsr #22
     d38:	0b230000 	bleq	8c0d40 <_bss_end+0x8b8500>
     d3c:	0000109b 	muleq	r0, fp, r0
     d40:	0f9d0b24 	svceq	0x009d0b24
     d44:	0b250000 	bleq	940d4c <_bss_end+0x93850c>
     d48:	00000cb7 			; <UNDEFINED> instruction: 0x00000cb7
     d4c:	0fbb0b26 	svceq	0x00bb0b26
     d50:	0b270000 	bleq	9c0d58 <_bss_end+0x9b8518>
     d54:	00000d53 	andeq	r0, r0, r3, asr sp
     d58:	0fcb0b28 	svceq	0x00cb0b28
     d5c:	0b290000 	bleq	a40d64 <_bss_end+0xa38524>
     d60:	00000fdb 	ldrdeq	r0, [r0], -fp
     d64:	111e0b2a 	tstne	lr, sl, lsr #22
     d68:	0b2b0000 	bleq	ac0d70 <_bss_end+0xab8530>
     d6c:	00000f44 	andeq	r0, r0, r4, asr #30
     d70:	13ce0b2c 	bicne	r0, lr, #44, 22	; 0xb000
     d74:	0b2d0000 	bleq	b40d7c <_bss_end+0xb3853c>
     d78:	00000cf8 	strdeq	r0, [r0], -r8
     d7c:	d60a002e 	strle	r0, [sl], -lr, lsr #32
     d80:	0700000e 	streq	r0, [r0, -lr]
     d84:	00009301 	andeq	r9, r0, r1, lsl #6
     d88:	06170300 	ldreq	r0, [r7], -r0, lsl #6
     d8c:	000003c7 	andeq	r0, r0, r7, asr #7
     d90:	000c0b0b 	andeq	r0, ip, fp, lsl #22
     d94:	5d0b0000 	stcpl	0, cr0, [fp, #-0]
     d98:	01000008 	tsteq	r0, r8
     d9c:	0018460b 	andseq	r4, r8, fp, lsl #12
     da0:	d90b0200 	stmdble	fp, {r9}
     da4:	03000016 	movweq	r0, #22
     da8:	000c2b0b 	andeq	r2, ip, fp, lsl #22
     dac:	150b0400 	strne	r0, [fp, #-1024]	; 0xfffffc00
     db0:	05000009 	streq	r0, [r0, #-9]
     db4:	000cd40b 	andeq	sp, ip, fp, lsl #8
     db8:	1b0b0600 	blne	2c25c0 <_bss_end+0x2b9d80>
     dbc:	0700000c 	streq	r0, [r0, -ip]
     dc0:	00156d0b 	andseq	r6, r5, fp, lsl #26
     dc4:	be0b0800 	cdplt	8, 0, cr0, cr11, cr0, {0}
     dc8:	09000016 	stmdbeq	r0, {r1, r2, r4}
     dcc:	0014a40b 	andseq	sl, r4, fp, lsl #8
     dd0:	680b0a00 	stmdavs	fp, {r9, fp}
     dd4:	0b000009 	bleq	e00 <_start-0x7200>
     dd8:	000c750b 	andeq	r7, ip, fp, lsl #10
     ddc:	de0b0c00 	cdple	12, 0, cr0, cr11, cr0, {0}
     de0:	0d000008 	stceq	0, cr0, [r0, #-32]	; 0xffffffe0
     de4:	00187b0b 	andseq	r7, r8, fp, lsl #22
     de8:	0b0b0e00 	bleq	2c45f0 <_bss_end+0x2bbdb0>
     dec:	0f000011 	svceq	0x00000011
     df0:	000de80b 	andeq	lr, sp, fp, lsl #16
     df4:	480b1000 	stmdami	fp, {ip}
     df8:	11000011 	tstne	r0, r1, lsl r0
     dfc:	00179a0b 	andseq	r9, r7, fp, lsl #20
     e00:	2b0b1200 	blcs	2c5608 <_bss_end+0x2bcdc8>
     e04:	1300000a 	movwne	r0, #10
     e08:	000dfb0b 	andeq	pc, sp, fp, lsl #22
     e0c:	5e0b1400 	cfcpyspl	mvf1, mvf11
     e10:	15000010 	strne	r0, [r0, #-16]
     e14:	000bf60b 	andeq	pc, fp, fp, lsl #12
     e18:	aa0b1600 	bge	2c6620 <_bss_end+0x2bdde0>
     e1c:	17000010 	smladne	r0, r0, r0, r0
     e20:	000ec00b 	andeq	ip, lr, fp
     e24:	330b1800 	movwcc	r1, #47104	; 0xb800
     e28:	19000009 	stmdbne	r0, {r0, r3}
     e2c:	0017410b 	andseq	r4, r7, fp, lsl #2
     e30:	2a0b1a00 	bcs	2c7638 <_bss_end+0x2bedf8>
     e34:	1b000010 	blne	e7c <_start-0x7184>
     e38:	000dd20b 	andeq	sp, sp, fp, lsl #4
     e3c:	080b1c00 	stmdaeq	fp, {sl, fp, ip}
     e40:	1d000008 	stcne	0, cr0, [r0, #-32]	; 0xffffffe0
     e44:	000f750b 	andeq	r7, pc, fp, lsl #10
     e48:	610b1e00 	tstvs	fp, r0, lsl #28
     e4c:	1f00000f 	svcne	0x0000000f
     e50:	0014610b 	andseq	r6, r4, fp, lsl #2
     e54:	ec0b2000 	stc	0, cr2, [fp], {-0}
     e58:	21000014 	tstcs	r0, r4, lsl r0
     e5c:	0017200b 	andseq	r2, r7, fp
     e60:	050b2200 	streq	r2, [fp, #-512]	; 0xfffffe00
     e64:	2300000d 	movwcs	r0, #13
     e68:	0012c40b 	andseq	ip, r2, fp, lsl #8
     e6c:	b90b2400 	stmdblt	fp, {sl, sp}
     e70:	25000014 	strcs	r0, [r0, #-20]	; 0xffffffec
     e74:	0013dd0b 	andseq	sp, r3, fp, lsl #26
     e78:	f10b2600 			; <UNDEFINED> instruction: 0xf10b2600
     e7c:	27000013 	smladcs	r0, r3, r0, r0
     e80:	0014050b 	andseq	r0, r4, fp, lsl #10
     e84:	b60b2800 	strlt	r2, [fp], -r0, lsl #16
     e88:	2900000a 	stmdbcs	r0, {r1, r3}
     e8c:	000a160b 	andeq	r1, sl, fp, lsl #12
     e90:	3e0b2a00 	vmlacc.f32	s4, s22, s0
     e94:	2b00000a 	blcs	ec4 <_start-0x713c>
     e98:	0015b60b 	andseq	fp, r5, fp, lsl #12
     e9c:	930b2c00 	movwls	r2, #48128	; 0xbc00
     ea0:	2d00000a 	stccs	0, cr0, [r0, #-40]	; 0xffffffd8
     ea4:	0015ca0b 	andseq	ip, r5, fp, lsl #20
     ea8:	de0b2e00 	cdple	14, 0, cr2, cr11, cr0, {0}
     eac:	2f000015 	svccs	0x00000015
     eb0:	0015f20b 	andseq	pc, r5, fp, lsl #4
     eb4:	870b3000 	strhi	r3, [fp, -r0]
     eb8:	3100000c 	tstcc	r0, ip
     ebc:	000c610b 	andeq	r6, ip, fp, lsl #2
     ec0:	890b3200 	stmdbhi	fp, {r9, ip, sp}
     ec4:	3300000f 	movwcc	r0, #15
     ec8:	00115b0b 	andseq	r5, r1, fp, lsl #22
     ecc:	cf0b3400 	svcgt	0x000b3400
     ed0:	35000017 	strcc	r0, [r0, #-23]	; 0xffffffe9
     ed4:	0007b00b 	andeq	fp, r7, fp
     ed8:	870b3600 	strhi	r3, [fp, -r0, lsl #12]
     edc:	3700000d 	strcc	r0, [r0, -sp]
     ee0:	000d9c0b 	andeq	r9, sp, fp, lsl #24
     ee4:	eb0b3800 	bl	2ceeec <_bss_end+0x2c66ac>
     ee8:	3900000f 	stmdbcc	r0, {r0, r1, r2, r3}
     eec:	0010150b 	andseq	r1, r0, fp, lsl #10
     ef0:	f80b3a00 			; <UNDEFINED> instruction: 0xf80b3a00
     ef4:	3b000017 	blcc	f58 <_start-0x70a8>
     ef8:	0012af0b 	andseq	sl, r2, fp, lsl #30
     efc:	2a0b3c00 	bcs	2cff04 <_bss_end+0x2c76c4>
     f00:	3d00000d 	stccc	0, cr0, [r0, #-52]	; 0xffffffcc
     f04:	00086f0b 	andeq	r6, r8, fp, lsl #30
     f08:	2d0b3e00 	stccs	14, cr3, [fp, #-0]
     f0c:	3f000008 	svccc	0x00000008
     f10:	0011a70b 	andseq	sl, r1, fp, lsl #14
     f14:	300b4000 	andcc	r4, fp, r0
     f18:	41000013 	tstmi	r0, r3, lsl r0
     f1c:	0014430b 	andseq	r4, r4, fp, lsl #6
     f20:	000b4200 	andeq	r4, fp, r0, lsl #4
     f24:	43000010 	movwmi	r0, #16
     f28:	0018310b 	andseq	r3, r8, fp, lsl #2
     f2c:	da0b4400 	ble	2d1f34 <_bss_end+0x2c96f4>
     f30:	45000012 	strmi	r0, [r0, #-18]	; 0xffffffee
     f34:	000a5a0b 	andeq	r5, sl, fp, lsl #20
     f38:	db0b4600 	blle	2d2740 <_bss_end+0x2c9f00>
     f3c:	47000010 	smladmi	r0, r0, r0, r0
     f40:	000f0e0b 	andeq	r0, pc, fp, lsl #28
     f44:	ec0b4800 	stc	8, cr4, [fp], {-0}
     f48:	49000007 	stmdbmi	r0, {r0, r1, r2}
     f4c:	0009000b 	andeq	r0, r9, fp
     f50:	3e0b4a00 	vmlacc.f32	s8, s22, s0
     f54:	4b00000d 	blmi	f90 <_start-0x7070>
     f58:	00103c0b 	andseq	r3, r0, fp, lsl #24
     f5c:	03004c00 	movweq	r4, #3072	; 0xc00
     f60:	03f90702 	mvnseq	r0, #524288	; 0x80000
     f64:	e40c0000 	str	r0, [ip], #-0
     f68:	d9000003 	stmdble	r0, {r0, r1}
     f6c:	0d000003 	stceq	0, cr0, [r0, #-12]
     f70:	03ce0e00 	biceq	r0, lr, #0, 28
     f74:	04050000 	streq	r0, [r5], #-0
     f78:	000003f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     f7c:	0003de0e 	andeq	sp, r3, lr, lsl #28
     f80:	08010300 	stmdaeq	r1, {r8, r9}
     f84:	000003c4 	andeq	r0, r0, r4, asr #7
     f88:	0003e90e 	andeq	lr, r3, lr, lsl #18
     f8c:	09a40f00 	stmibeq	r4!, {r8, r9, sl, fp}
     f90:	4c040000 	stcmi	0, cr0, [r4], {-0}
     f94:	03d91a01 	bicseq	r1, r9, #4096	; 0x1000
     f98:	c20f0000 	andgt	r0, pc, #0
     f9c:	0400000d 	streq	r0, [r0], #-13
     fa0:	d91a0182 	ldmdble	sl, {r1, r7, r8}
     fa4:	0c000003 	stceq	0, cr0, [r0], {3}
     fa8:	000003e9 	andeq	r0, r0, r9, ror #7
     fac:	0000041a 	andeq	r0, r0, sl, lsl r4
     fb0:	ad09000d 	stcge	0, cr0, [r9, #-52]	; 0xffffffcc
     fb4:	0500000f 	streq	r0, [r0, #-15]
     fb8:	040f0d2d 	streq	r0, [pc], #-3373	; fc0 <_start-0x7040>
     fbc:	9a090000 	bls	240fc4 <_bss_end+0x238784>
     fc0:	05000016 	streq	r0, [r0, #-22]	; 0xffffffea
     fc4:	01e61c38 	mvneq	r1, r8, lsr ip
     fc8:	9b0a0000 	blls	280fd0 <_bss_end+0x278790>
     fcc:	0700000c 	streq	r0, [r0, -ip]
     fd0:	00009301 	andeq	r9, r0, r1, lsl #6
     fd4:	0e3a0500 	cfabs32eq	mvfx0, mvfx10
     fd8:	000004a5 	andeq	r0, r0, r5, lsr #9
     fdc:	0008010b 	andeq	r0, r8, fp, lsl #2
     fe0:	ad0b0000 	stcge	0, cr0, [fp, #-0]
     fe4:	0100000e 	tsteq	r0, lr
     fe8:	0017ac0b 	andseq	sl, r7, fp, lsl #24
     fec:	6f0b0200 	svcvs	0x000b0200
     ff0:	03000017 	movweq	r0, #23
     ff4:	0012040b 	andseq	r0, r2, fp, lsl #8
     ff8:	2a0b0400 	bcs	2c2000 <_bss_end+0x2b97c0>
     ffc:	05000015 	streq	r0, [r0, #-21]	; 0xffffffeb
    1000:	0009e70b 	andeq	lr, r9, fp, lsl #14
    1004:	c90b0600 	stmdbgt	fp, {r9, sl}
    1008:	07000009 	streq	r0, [r0, -r9]
    100c:	000be20b 	andeq	lr, fp, fp, lsl #4
    1010:	c00b0800 	andgt	r0, fp, r0, lsl #16
    1014:	09000010 	stmdbeq	r0, {r4}
    1018:	0009ee0b 	andeq	lr, r9, fp, lsl #28
    101c:	c70b0a00 	strgt	r0, [fp, -r0, lsl #20]
    1020:	0b000010 	bleq	1068 <_start-0x6f98>
    1024:	000a530b 	andeq	r5, sl, fp, lsl #6
    1028:	e00b0c00 	and	r0, fp, r0, lsl #24
    102c:	0d000009 	stceq	0, cr0, [r0, #-36]	; 0xffffffdc
    1030:	0015810b 	andseq	r8, r5, fp, lsl #2
    1034:	4e0b0e00 	cdpmi	14, 0, cr0, cr11, cr0, {0}
    1038:	0f000013 	svceq	0x00000013
    103c:	14790400 	ldrbtne	r0, [r9], #-1024	; 0xfffffc00
    1040:	3f050000 	svccc	0x00050000
    1044:	00043201 	andeq	r3, r4, r1, lsl #4
    1048:	150d0900 	strne	r0, [sp, #-2304]	; 0xfffff700
    104c:	41050000 	mrsmi	r0, (UNDEF: 5)
    1050:	0004a50f 	andeq	sl, r4, pc, lsl #10
    1054:	15950900 	ldrne	r0, [r5, #2304]	; 0x900
    1058:	4a050000 	bmi	141060 <_bss_end+0x138820>
    105c:	00001d0c 	andeq	r1, r0, ip, lsl #26
    1060:	09880900 	stmibeq	r8, {r8, fp}
    1064:	4b050000 	blmi	14106c <_bss_end+0x13882c>
    1068:	00001d0c 	andeq	r1, r0, ip, lsl #26
    106c:	166e1000 	strbtne	r1, [lr], -r0
    1070:	a6090000 	strge	r0, [r9], -r0
    1074:	05000015 	streq	r0, [r0, #-21]	; 0xffffffeb
    1078:	04e6144c 	strbteq	r1, [r6], #1100	; 0x44c
    107c:	04050000 	streq	r0, [r5], #-0
    1080:	000004d5 	ldrdeq	r0, [r0], -r5
    1084:	0e770911 			; <UNDEFINED> instruction: 0x0e770911
    1088:	4e050000 	cdpmi	0, 0, cr0, cr5, cr0, {0}
    108c:	0004f90f 	andeq	pc, r4, pc, lsl #18
    1090:	ec040500 	cfstr32	mvfx0, [r4], {-0}
    1094:	12000004 	andne	r0, r0, #4
    1098:	0000148f 	andeq	r1, r0, pc, lsl #9
    109c:	0011f109 	andseq	pc, r1, r9, lsl #2
    10a0:	0d520500 	cfldr64eq	mvdx0, [r2, #-0]
    10a4:	00000510 	andeq	r0, r0, r0, lsl r5
    10a8:	04ff0405 	ldrbteq	r0, [pc], #1029	; 10b0 <_start-0x6f50>
    10ac:	ff130000 			; <UNDEFINED> instruction: 0xff130000
    10b0:	3400000a 	strcc	r0, [r0], #-10
    10b4:	15016705 	strne	r6, [r1, #-1797]	; 0xfffff8fb
    10b8:	00000541 	andeq	r0, r0, r1, asr #10
    10bc:	000fb614 	andeq	fp, pc, r4, lsl r6	; <UNPREDICTABLE>
    10c0:	01690500 	cmneq	r9, r0, lsl #10
    10c4:	0003de0f 	andeq	sp, r3, pc, lsl #28
    10c8:	e3140000 	tst	r4, #0
    10cc:	0500000a 	streq	r0, [r0, #-10]
    10d0:	4614016a 	ldrmi	r0, [r4], -sl, ror #2
    10d4:	04000005 	streq	r0, [r0], #-5
    10d8:	05160e00 	ldreq	r0, [r6, #-3584]	; 0xfffff200
    10dc:	b90c0000 	stmdblt	ip, {}	; <UNPREDICTABLE>
    10e0:	56000000 	strpl	r0, [r0], -r0
    10e4:	15000005 	strne	r0, [r0, #-5]
    10e8:	00000024 	andeq	r0, r0, r4, lsr #32
    10ec:	410c002d 	tstmi	ip, sp, lsr #32
    10f0:	61000005 	tstvs	r0, r5
    10f4:	0d000005 	stceq	0, cr0, [r0, #-20]	; 0xffffffec
    10f8:	05560e00 	ldrbeq	r0, [r6, #-3584]	; 0xfffff200
    10fc:	e50f0000 	str	r0, [pc, #-0]	; 1104 <_start-0x6efc>
    1100:	0500000e 	streq	r0, [r0, #-14]
    1104:	6103016b 	tstvs	r3, fp, ror #2
    1108:	0f000005 	svceq	0x00000005
    110c:	0000112b 	andeq	r1, r0, fp, lsr #2
    1110:	0c016e05 	stceq	14, cr6, [r1], {5}
    1114:	0000001d 	andeq	r0, r0, sp, lsl r0
    1118:	0014cd16 	andseq	ip, r4, r6, lsl sp
    111c:	93010700 	movwls	r0, #5888	; 0x1700
    1120:	05000000 	streq	r0, [r0, #-0]
    1124:	2a060181 	bcs	181730 <_bss_end+0x178ef0>
    1128:	0b000006 	bleq	1148 <_start-0x6eb8>
    112c:	00000896 	muleq	r0, r6, r8
    1130:	08a20b00 	stmiaeq	r2!, {r8, r9, fp}
    1134:	0b020000 	bleq	8113c <_bss_end+0x788fc>
    1138:	000008ae 	andeq	r0, r0, lr, lsr #17
    113c:	0cc70b03 	fstmiaxeq	r7, {d16}	;@ Deprecated
    1140:	0b030000 	bleq	c1148 <_bss_end+0xb8908>
    1144:	000008ba 			; <UNDEFINED> instruction: 0x000008ba
    1148:	0e100b04 	vnmlseq.f64	d0, d0, d4
    114c:	0b040000 	bleq	101154 <_bss_end+0xf8914>
    1150:	00000ef6 	strdeq	r0, [r0], -r6
    1154:	0e4c0b05 	vmlaeq.f64	d16, d12, d5
    1158:	0b050000 	bleq	141160 <_bss_end+0x138920>
    115c:	00000979 	andeq	r0, r0, r9, ror r9
    1160:	08c60b05 	stmiaeq	r6, {r0, r2, r8, r9, fp}^
    1164:	0b060000 	bleq	18116c <_bss_end+0x17892c>
    1168:	00001074 	andeq	r1, r0, r4, ror r0
    116c:	0ad50b06 	beq	ff543d8c <_bss_end+0xff53b54c>
    1170:	0b060000 	bleq	181178 <_bss_end+0x178938>
    1174:	00001081 	andeq	r1, r0, r1, lsl #1
    1178:	154d0b06 	strbne	r0, [sp, #-2822]	; 0xfffff4fa
    117c:	0b060000 	bleq	181184 <_bss_end+0x178944>
    1180:	0000108e 	andeq	r1, r0, lr, lsl #1
    1184:	10ce0b06 	sbcne	r0, lr, r6, lsl #22
    1188:	0b060000 	bleq	181190 <_bss_end+0x178950>
    118c:	000008d2 	ldrdeq	r0, [r0], -r2
    1190:	11d40b07 	bicsne	r0, r4, r7, lsl #22
    1194:	0b070000 	bleq	1c119c <_bss_end+0x1b895c>
    1198:	00001221 	andeq	r1, r0, r1, lsr #4
    119c:	15880b07 	strne	r0, [r8, #2823]	; 0xb07
    11a0:	0b070000 	bleq	1c11a8 <_bss_end+0x1b8968>
    11a4:	00000aa8 	andeq	r0, r0, r8, lsr #21
    11a8:	13070b07 	movwne	r0, #31495	; 0x7b07
    11ac:	0b080000 	bleq	2011b4 <_bss_end+0x1f8974>
    11b0:	0000084b 	andeq	r0, r0, fp, asr #16
    11b4:	155b0b08 	ldrbne	r0, [fp, #-2824]	; 0xfffff4f8
    11b8:	0b080000 	bleq	2011c0 <_bss_end+0x1f8980>
    11bc:	00001323 	andeq	r1, r0, r3, lsr #6
    11c0:	c10f0008 	tstgt	pc, r8
    11c4:	05000017 	streq	r0, [r0, #-23]	; 0xffffffe9
    11c8:	801f019f 	mulshi	pc, pc, r1	; <UNPREDICTABLE>
    11cc:	0f000005 	svceq	0x00000005
    11d0:	00001355 	andeq	r1, r0, r5, asr r3
    11d4:	0c01a205 	sfmeq	f2, 1, [r1], {5}
    11d8:	0000001d 	andeq	r0, r0, sp, lsl r0
    11dc:	000f030f 	andeq	r0, pc, pc, lsl #6
    11e0:	01a50500 			; <UNDEFINED> instruction: 0x01a50500
    11e4:	00001d0c 	andeq	r1, r0, ip, lsl #26
    11e8:	188d0f00 	stmne	sp, {r8, r9, sl, fp}
    11ec:	a8050000 	stmdage	r5, {}	; <UNPREDICTABLE>
    11f0:	001d0c01 	andseq	r0, sp, r1, lsl #24
    11f4:	980f0000 	stmdals	pc, {}	; <UNPREDICTABLE>
    11f8:	05000009 	streq	r0, [r0, #-9]
    11fc:	1d0c01ab 	stfnes	f0, [ip, #-684]	; 0xfffffd54
    1200:	0f000000 	svceq	0x00000000
    1204:	0000135f 	andeq	r1, r0, pc, asr r3
    1208:	0c01ae05 	stceq	14, cr10, [r1], {5}
    120c:	0000001d 	andeq	r0, r0, sp, lsl r0
    1210:	00120b0f 	andseq	r0, r2, pc, lsl #22
    1214:	01b10500 			; <UNDEFINED> instruction: 0x01b10500
    1218:	00001d0c 	andeq	r1, r0, ip, lsl #26
    121c:	12160f00 	andsne	r0, r6, #0, 30
    1220:	b4050000 	strlt	r0, [r5], #-0
    1224:	001d0c01 	andseq	r0, sp, r1, lsl #24
    1228:	690f0000 	stmdbvs	pc, {}	; <UNPREDICTABLE>
    122c:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
    1230:	1d0c01b7 	stfnes	f0, [ip, #-732]	; 0xfffffd24
    1234:	0f000000 	svceq	0x00000000
    1238:	00001050 	andeq	r1, r0, r0, asr r0
    123c:	0c01ba05 			; <UNDEFINED> instruction: 0x0c01ba05
    1240:	0000001d 	andeq	r0, r0, sp, lsl r0
    1244:	0017ec0f 	andseq	lr, r7, pc, lsl #24
    1248:	01bd0500 			; <UNDEFINED> instruction: 0x01bd0500
    124c:	00001d0c 	andeq	r1, r0, ip, lsl #26
    1250:	13730f00 	cmnne	r3, #0, 30
    1254:	c0050000 	andgt	r0, r5, r0
    1258:	001d0c01 	andseq	r0, sp, r1, lsl #24
    125c:	b00f0000 	andlt	r0, pc, r0
    1260:	05000018 	streq	r0, [r0, #-24]	; 0xffffffe8
    1264:	1d0c01c3 	stfnes	f0, [ip, #-780]	; 0xfffffcf4
    1268:	0f000000 	svceq	0x00000000
    126c:	00001776 	andeq	r1, r0, r6, ror r7
    1270:	0c01c605 	stceq	6, cr12, [r1], {5}
    1274:	0000001d 	andeq	r0, r0, sp, lsl r0
    1278:	0017820f 	andseq	r8, r7, pc, lsl #4
    127c:	01c90500 	biceq	r0, r9, r0, lsl #10
    1280:	00001d0c 	andeq	r1, r0, ip, lsl #26
    1284:	178e0f00 	strne	r0, [lr, r0, lsl #30]
    1288:	cc050000 	stcgt	0, cr0, [r5], {-0}
    128c:	001d0c01 	andseq	r0, sp, r1, lsl #24
    1290:	b30f0000 	movwlt	r0, #61440	; 0xf000
    1294:	05000017 	streq	r0, [r0, #-23]	; 0xffffffe9
    1298:	1d0c01d0 	stfnes	f0, [ip, #-832]	; 0xfffffcc0
    129c:	0f000000 	svceq	0x00000000
    12a0:	000018a3 	andeq	r1, r0, r3, lsr #17
    12a4:	0c01d305 	stceq	3, cr13, [r1], {5}
    12a8:	0000001d 	andeq	r0, r0, sp, lsl r0
    12ac:	0009f50f 	andeq	pc, r9, pc, lsl #10
    12b0:	01d60500 	bicseq	r0, r6, r0, lsl #10
    12b4:	00001d0c 	andeq	r1, r0, ip, lsl #26
    12b8:	07dc0f00 	ldrbeq	r0, [ip, r0, lsl #30]
    12bc:	d9050000 	stmdble	r5, {}	; <UNPREDICTABLE>
    12c0:	001d0c01 	andseq	r0, sp, r1, lsl #24
    12c4:	e70f0000 	str	r0, [pc, -r0]
    12c8:	0500000c 	streq	r0, [r0, #-12]
    12cc:	1d0c01dc 	stfnes	f0, [ip, #-880]	; 0xfffffc90
    12d0:	0f000000 	svceq	0x00000000
    12d4:	000009d0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    12d8:	0c01df05 	stceq	15, cr13, [r1], {5}
    12dc:	0000001d 	andeq	r0, r0, sp, lsl r0
    12e0:	0013890f 	andseq	r8, r3, pc, lsl #18
    12e4:	01e20500 	mvneq	r0, r0, lsl #10
    12e8:	00001d0c 	andeq	r1, r0, ip, lsl #26
    12ec:	0f2c0f00 	svceq	0x002c0f00
    12f0:	e5050000 	str	r0, [r5, #-0]
    12f4:	001d0c01 	andseq	r0, sp, r1, lsl #24
    12f8:	840f0000 	strhi	r0, [pc], #-0	; 1300 <_start-0x6d00>
    12fc:	05000011 	streq	r0, [r0, #-17]	; 0xffffffef
    1300:	1d0c01e8 	stfnes	f0, [ip, #-928]	; 0xfffffc60
    1304:	0f000000 	svceq	0x00000000
    1308:	000016a3 	andeq	r1, r0, r3, lsr #13
    130c:	0c01ef05 	stceq	15, cr14, [r1], {5}
    1310:	0000001d 	andeq	r0, r0, sp, lsl r0
    1314:	00185b0f 	andseq	r5, r8, pc, lsl #22
    1318:	01f20500 	mvnseq	r0, r0, lsl #10
    131c:	00001d0c 	andeq	r1, r0, ip, lsl #26
    1320:	186b0f00 	stmdane	fp!, {r8, r9, sl, fp}^
    1324:	f5050000 			; <UNDEFINED> instruction: 0xf5050000
    1328:	001d0c01 	andseq	r0, sp, r1, lsl #24
    132c:	ec0f0000 	stc	0, cr0, [pc], {-0}
    1330:	0500000a 	streq	r0, [r0, #-10]
    1334:	1d0c01f8 	stfnes	f0, [ip, #-992]	; 0xfffffc20
    1338:	0f000000 	svceq	0x00000000
    133c:	000016ea 	andeq	r1, r0, sl, ror #13
    1340:	0c01fb05 			; <UNDEFINED> instruction: 0x0c01fb05
    1344:	0000001d 	andeq	r0, r0, sp, lsl r0
    1348:	0012ef0f 	andseq	lr, r2, pc, lsl #30
    134c:	01fe0500 	mvnseq	r0, r0, lsl #10
    1350:	00001d0c 	andeq	r1, r0, ip, lsl #26
    1354:	0d600f00 	stcleq	15, cr0, [r0, #-0]
    1358:	02050000 	andeq	r0, r5, #0
    135c:	001d0c02 	andseq	r0, sp, r2, lsl #24
    1360:	df0f0000 	svcle	0x000f0000
    1364:	05000014 	streq	r0, [r0, #-20]	; 0xffffffec
    1368:	1d0c020a 	sfmne	f0, 4, [ip, #-40]	; 0xffffffd8
    136c:	0f000000 	svceq	0x00000000
    1370:	00000c53 	andeq	r0, r0, r3, asr ip
    1374:	0c020d05 	stceq	13, cr0, [r2], {5}
    1378:	0000001d 	andeq	r0, r0, sp, lsl r0
    137c:	00001d0c 	andeq	r1, r0, ip, lsl #26
    1380:	0007ef00 	andeq	lr, r7, r0, lsl #30
    1384:	0f000d00 	svceq	0x00000d00
    1388:	00000e2c 	andeq	r0, r0, ip, lsr #28
    138c:	0c03fb05 			; <UNDEFINED> instruction: 0x0c03fb05
    1390:	000007e4 	andeq	r0, r0, r4, ror #15
    1394:	0004e60c 	andeq	lr, r4, ip, lsl #12
    1398:	00080c00 	andeq	r0, r8, r0, lsl #24
    139c:	00241500 	eoreq	r1, r4, r0, lsl #10
    13a0:	000d0000 	andeq	r0, sp, r0
    13a4:	0013ac0f 	andseq	sl, r3, pc, lsl #24
    13a8:	05840500 	streq	r0, [r4, #1280]	; 0x500
    13ac:	0007fc14 	andeq	pc, r7, r4, lsl ip	; <UNPREDICTABLE>
    13b0:	0eee1600 	cdpeq	6, 14, cr1, cr14, cr0, {0}
    13b4:	01070000 	mrseq	r0, (UNDEF: 7)
    13b8:	00000093 	muleq	r0, r3, r0
    13bc:	06058b05 	streq	r8, [r5], -r5, lsl #22
    13c0:	00000857 	andeq	r0, r0, r7, asr r8
    13c4:	000ca90b 	andeq	sl, ip, fp, lsl #18
    13c8:	f90b0000 			; <UNDEFINED> instruction: 0xf90b0000
    13cc:	01000010 	tsteq	r0, r0, lsl r0
    13d0:	0008810b 	andeq	r8, r8, fp, lsl #2
    13d4:	1d0b0200 	sfmne	f0, 4, [fp, #-0]
    13d8:	03000018 	movweq	r0, #24
    13dc:	0014260b 	andseq	r2, r4, fp, lsl #12
    13e0:	190b0400 	stmdbne	fp, {sl}
    13e4:	05000014 	streq	r0, [r0, #-20]	; 0xffffffec
    13e8:	0009580b 	andeq	r5, r9, fp, lsl #16
    13ec:	0f000600 	svceq	0x00000600
    13f0:	0000180d 	andeq	r1, r0, sp, lsl #16
    13f4:	15059805 	strne	r9, [r5, #-2053]	; 0xfffff7fb
    13f8:	00000819 	andeq	r0, r0, r9, lsl r8
    13fc:	00170f0f 	andseq	r0, r7, pc, lsl #30
    1400:	07990500 	ldreq	r0, [r9, r0, lsl #10]
    1404:	00002411 	andeq	r2, r0, r1, lsl r4
    1408:	13990f00 	orrsne	r0, r9, #0, 30
    140c:	ae050000 	cdpge	0, 0, cr0, cr5, cr0, {0}
    1410:	001d0c07 	andseq	r0, sp, r7, lsl #24
    1414:	82040000 	andhi	r0, r4, #0
    1418:	06000016 			; <UNDEFINED> instruction: 0x06000016
    141c:	0093167b 	addseq	r1, r3, fp, ror r6
    1420:	7e0e0000 	cdpvc	0, 0, cr0, cr14, cr0, {0}
    1424:	03000008 	movweq	r0, #8
    1428:	056c0502 	strbeq	r0, [ip, #-1282]!	; 0xfffffafe
    142c:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    1430:	000c3c07 	andeq	r3, ip, r7, lsl #24
    1434:	04040300 	streq	r0, [r4], #-768	; 0xfffffd00
    1438:	00000a10 	andeq	r0, r0, r0, lsl sl
    143c:	08030803 	stmdaeq	r3, {r0, r1, fp}
    1440:	0300000a 	movweq	r0, #10
    1444:	13820408 	orrne	r0, r2, #8, 8	; 0x8000000
    1448:	10030000 	andne	r0, r3, r0
    144c:	00143403 	andseq	r3, r4, r3, lsl #8
    1450:	088a0c00 	stmeq	sl, {sl, fp}
    1454:	08c90000 	stmiaeq	r9, {}^	; <UNPREDICTABLE>
    1458:	24150000 	ldrcs	r0, [r5], #-0
    145c:	ff000000 			; <UNDEFINED> instruction: 0xff000000
    1460:	08b90e00 	ldmeq	r9!, {r9, sl, fp}
    1464:	2e0f0000 	cdpcs	0, 0, cr0, cr15, cr0, {0}
    1468:	06000012 			; <UNDEFINED> instruction: 0x06000012
    146c:	c91601fc 	ldmdbgt	r6, {r2, r3, r4, r5, r6, r7, r8}
    1470:	0f000008 	svceq	0x00000008
    1474:	000009bf 			; <UNDEFINED> instruction: 0x000009bf
    1478:	16020206 	strne	r0, [r2], -r6, lsl #4
    147c:	000008c9 	andeq	r0, r0, r9, asr #17
    1480:	0016b504 	andseq	fp, r6, r4, lsl #10
    1484:	102a0700 	eorne	r0, sl, r0, lsl #14
    1488:	000004f9 	strdeq	r0, [r0], -r9
    148c:	0008e80c 	andeq	lr, r8, ip, lsl #16
    1490:	0008ff00 	andeq	pc, r8, r0, lsl #30
    1494:	09000d00 	stmdbeq	r0, {r8, sl, fp}
    1498:	000006f3 	strdeq	r0, [r0], -r3
    149c:	f4112f07 			; <UNDEFINED> instruction: 0xf4112f07
    14a0:	09000008 	stmdbeq	r0, {r3}
    14a4:	00000772 	andeq	r0, r0, r2, ror r7
    14a8:	f4113007 			; <UNDEFINED> instruction: 0xf4113007
    14ac:	17000008 	strne	r0, [r0, -r8]
    14b0:	000008ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    14b4:	0a093308 	beq	24e0dc <_bss_end+0x24589c>
    14b8:	88280305 	stmdahi	r8!, {r0, r2, r8, r9}
    14bc:	0b170000 	bleq	5c14c4 <_bss_end+0x5b8c84>
    14c0:	08000009 	stmdaeq	r0, {r0, r3}
    14c4:	050a0934 	streq	r0, [sl, #-2356]	; 0xfffff6cc
    14c8:	00882c03 	addeq	r2, r8, r3, lsl #24
	...

Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
   0:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
   4:	030b130e 	movweq	r1, #45838	; 0xb30e
   8:	110e1b0e 	tstne	lr, lr, lsl #22
   c:	10061201 	andne	r1, r6, r1, lsl #4
  10:	02000017 	andeq	r0, r0, #23
  14:	193f002e 	ldmdbne	pc!, {r1, r2, r3, r5}	; <UNPREDICTABLE>
  18:	0b3a0e03 	bleq	e8382c <_bss_end+0xe7afec>
  1c:	0b390b3b 	bleq	e42d10 <_bss_end+0xe3a4d0>
  20:	06120111 			; <UNDEFINED> instruction: 0x06120111
  24:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
  28:	03000019 	movweq	r0, #25
  2c:	0e030139 	mcreq	1, 0, r0, cr3, cr9, {1}
  30:	0b3b0b3a 	bleq	ec2d20 <_bss_end+0xeba4e0>
  34:	00001301 	andeq	r1, r0, r1, lsl #6
  38:	3f012e04 	svccc	0x00012e04
  3c:	3a0e0319 	bcc	380ca8 <_bss_end+0x378468>
  40:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
  44:	01193c0b 	tsteq	r9, fp, lsl #24
  48:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
  4c:	13490005 	movtne	r0, #36869	; 0x9005
  50:	16060000 	strne	r0, [r6], -r0
  54:	3a0e0300 	bcc	380c5c <_bss_end+0x37841c>
  58:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
  5c:	0013490b 	andseq	r4, r3, fp, lsl #18
  60:	012e0700 			; <UNDEFINED> instruction: 0x012e0700
  64:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
  68:	0b3b0b3a 	bleq	ec2d58 <_bss_end+0xeba518>
  6c:	13490b39 	movtne	r0, #39737	; 0x9b39
  70:	0000193c 	andeq	r1, r0, ip, lsr r9
  74:	0b000f08 	bleq	3c9c <_start-0x4364>
  78:	0013490b 	andseq	r4, r3, fp, lsl #18
  7c:	00240900 	eoreq	r0, r4, r0, lsl #18
  80:	0b3e0b0b 	bleq	f82cb4 <_bss_end+0xf7a474>
  84:	00000e03 	andeq	r0, r0, r3, lsl #28
  88:	47012e0a 	strmi	r2, [r1, -sl, lsl #28]
  8c:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
  90:	97184006 	ldrls	r4, [r8, -r6]
  94:	13011942 	movwne	r1, #6466	; 0x1942
  98:	050b0000 	streq	r0, [fp, #-0]
  9c:	02134900 	andseq	r4, r3, #0, 18
  a0:	0c000018 	stceq	0, cr0, [r0], {24}
  a4:	08030005 	stmdaeq	r3, {r0, r2}
  a8:	0b3b0b3a 	bleq	ec2d98 <_bss_end+0xeba558>
  ac:	13490b39 	movtne	r0, #39737	; 0x9b39
  b0:	00001802 	andeq	r1, r0, r2, lsl #16
  b4:	0b00240d 	bleq	90f0 <_bss_end+0x8b0>
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
  e4:	0b0b0024 	bleq	2c017c <_bss_end+0x2b793c>
  e8:	0e030b3e 	vmoveq.16	d3[0], r0
  ec:	24030000 	strcs	r0, [r3], #-0
  f0:	3e0b0b00 	vmlacc.f64	d0, d11, d0
  f4:	0008030b 	andeq	r0, r8, fp, lsl #6
  f8:	00160400 	andseq	r0, r6, r0, lsl #8
  fc:	0b3a0e03 	bleq	e83910 <_bss_end+0xe7b0d0>
 100:	0b390b3b 	bleq	e42df4 <_bss_end+0xe3a5b4>
 104:	00001349 	andeq	r1, r0, r9, asr #6
 108:	49002605 	stmdbmi	r0, {r0, r2, r9, sl, sp}
 10c:	06000013 			; <UNDEFINED> instruction: 0x06000013
 110:	08030139 	stmdaeq	r3, {r0, r3, r4, r5, r8}
 114:	0b3b0b3a 	bleq	ec2e04 <_bss_end+0xeba5c4>
 118:	13010b39 	movwne	r0, #6969	; 0x1b39
 11c:	34070000 	strcc	r0, [r7], #-0
 120:	3a0e0300 	bcc	380d28 <_bss_end+0x3784e8>
 124:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 128:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
 12c:	6c061c19 	stcvs	12, cr1, [r6], {25}
 130:	08000019 	stmdaeq	r0, {r0, r3, r4}
 134:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 138:	0b3b0b3a 	bleq	ec2e28 <_bss_end+0xeba5e8>
 13c:	13490b39 	movtne	r0, #39737	; 0x9b39
 140:	0b1c193c 	bleq	706638 <_bss_end+0x6fddf8>
 144:	0000196c 	andeq	r1, r0, ip, ror #18
 148:	03010409 	movweq	r0, #5129	; 0x1409
 14c:	3e196d0e 	cdpcc	13, 1, cr6, cr9, cr14, {0}
 150:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
 154:	3b0b3a13 	blcc	2ce9a8 <_bss_end+0x2c6168>
 158:	000b390b 	andeq	r3, fp, fp, lsl #18
 15c:	00280a00 	eoreq	r0, r8, r0, lsl #20
 160:	0b1c0e03 	bleq	703974 <_bss_end+0x6fb134>
 164:	340b0000 	strcc	r0, [fp], #-0
 168:	00134700 	andseq	r4, r3, r0, lsl #14
 16c:	01040c00 	tsteq	r4, r0, lsl #24
 170:	196d0e03 	stmdbne	sp!, {r0, r1, r9, sl, fp}^
 174:	0b0b0b3e 	bleq	2c2e74 <_bss_end+0x2ba634>
 178:	0b3a1349 	bleq	e84ea4 <_bss_end+0xe7c664>
 17c:	0b390b3b 	bleq	e42e70 <_bss_end+0xe3a630>
 180:	00001301 	andeq	r1, r0, r1, lsl #6
 184:	0301020d 	movweq	r0, #4621	; 0x120d
 188:	3a0b0b0e 	bcc	2c2dc8 <_bss_end+0x2ba588>
 18c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 190:	0013010b 	andseq	r0, r3, fp, lsl #2
 194:	000d0e00 	andeq	r0, sp, r0, lsl #28
 198:	0b3a0e03 	bleq	e839ac <_bss_end+0xe7b16c>
 19c:	0b390b3b 	bleq	e42e90 <_bss_end+0xe3a650>
 1a0:	0b381349 	bleq	e04ecc <_bss_end+0xdfc68c>
 1a4:	2e0f0000 	cdpcs	0, 0, cr0, cr15, cr0, {0}
 1a8:	03193f01 	tsteq	r9, #1, 30
 1ac:	3b0b3a0e 	blcc	2ce9ec <_bss_end+0x2c61ac>
 1b0:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 1b4:	3213490e 	andscc	r4, r3, #229376	; 0x38000
 1b8:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 1bc:	00130113 	andseq	r0, r3, r3, lsl r1
 1c0:	00051000 	andeq	r1, r5, r0
 1c4:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
 1c8:	05110000 	ldreq	r0, [r1, #-0]
 1cc:	00134900 	andseq	r4, r3, r0, lsl #18
 1d0:	012e1200 			; <UNDEFINED> instruction: 0x012e1200
 1d4:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 1d8:	0b3b0b3a 	bleq	ec2ec8 <_bss_end+0xeba688>
 1dc:	0e6e0b39 	vmoveq.8	d14[5], r0
 1e0:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 1e4:	13011364 	movwne	r1, #4964	; 0x1364
 1e8:	2e130000 	cdpcs	0, 1, cr0, cr3, cr0, {0}
 1ec:	03193f01 	tsteq	r9, #1, 30
 1f0:	3b0b3a0e 	blcc	2cea30 <_bss_end+0x2c61f0>
 1f4:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 1f8:	3c0b320e 	sfmcc	f3, 4, [fp], {14}
 1fc:	00136419 	andseq	r6, r3, r9, lsl r4
 200:	000f1400 	andeq	r1, pc, r0, lsl #8
 204:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 208:	10150000 	andsne	r0, r5, r0
 20c:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 210:	16000013 			; <UNDEFINED> instruction: 0x16000013
 214:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 218:	0b3b0b3a 	bleq	ec2f08 <_bss_end+0xeba6c8>
 21c:	13490b39 	movtne	r0, #39737	; 0x9b39
 220:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
 224:	34170000 	ldrcc	r0, [r7], #-0
 228:	3a134700 	bcc	4d1e30 <_bss_end+0x4c95f0>
 22c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 230:	0018020b 	andseq	r0, r8, fp, lsl #4
 234:	002e1800 	eoreq	r1, lr, r0, lsl #16
 238:	19340e03 	ldmdbne	r4!, {r0, r1, r9, sl, fp}
 23c:	06120111 			; <UNDEFINED> instruction: 0x06120111
 240:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 244:	19000019 	stmdbne	r0, {r0, r3, r4}
 248:	0e03012e 	adfeqsp	f0, f3, #0.5
 24c:	01111934 	tsteq	r1, r4, lsr r9
 250:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 254:	01194296 			; <UNDEFINED> instruction: 0x01194296
 258:	1a000013 	bne	2ac <_start-0x7d54>
 25c:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
 260:	0b3b0b3a 	bleq	ec2f50 <_bss_end+0xeba710>
 264:	13490b39 	movtne	r0, #39737	; 0x9b39
 268:	00001802 	andeq	r1, r0, r2, lsl #16
 26c:	47012e1b 	smladmi	r1, fp, lr, r2
 270:	3b0b3a13 	blcc	2ceac4 <_bss_end+0x2c6284>
 274:	640b390b 	strvs	r3, [fp], #-2315	; 0xfffff6f5
 278:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 27c:	96184006 	ldrls	r4, [r8], -r6
 280:	13011942 	movwne	r1, #6466	; 0x1942
 284:	051c0000 	ldreq	r0, [ip, #-0]
 288:	490e0300 	stmdbmi	lr, {r8, r9}
 28c:	02193413 	andseq	r3, r9, #318767104	; 0x13000000
 290:	1d000018 	stcne	0, cr0, [r0, #-96]	; 0xffffffa0
 294:	08030005 	stmdaeq	r3, {r0, r2}
 298:	0b3b0b3a 	bleq	ec2f88 <_bss_end+0xeba748>
 29c:	13490b39 	movtne	r0, #39737	; 0x9b39
 2a0:	00001802 	andeq	r1, r0, r2, lsl #16
 2a4:	0300341e 	movweq	r3, #1054	; 0x41e
 2a8:	3b0b3a08 	blcc	2cead0 <_bss_end+0x2c6290>
 2ac:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 2b0:	00180213 	andseq	r0, r8, r3, lsl r2
 2b4:	012e1f00 			; <UNDEFINED> instruction: 0x012e1f00
 2b8:	0b3a1347 	bleq	e84fdc <_bss_end+0xe7c79c>
 2bc:	0b390b3b 	bleq	e42fb0 <_bss_end+0xe3a770>
 2c0:	01111364 	tsteq	r1, r4, ror #6
 2c4:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 2c8:	01194297 			; <UNDEFINED> instruction: 0x01194297
 2cc:	20000013 	andcs	r0, r0, r3, lsl r0
 2d0:	1347012e 	movtne	r0, #28974	; 0x712e
 2d4:	0b3b0b3a 	bleq	ec2fc4 <_bss_end+0xeba784>
 2d8:	13640b39 	cmnne	r4, #58368	; 0xe400
 2dc:	13010b20 	movwne	r0, #6944	; 0x1b20
 2e0:	05210000 	streq	r0, [r1, #-0]!
 2e4:	490e0300 	stmdbmi	lr, {r8, r9}
 2e8:	00193413 	andseq	r3, r9, r3, lsl r4
 2ec:	00052200 	andeq	r2, r5, r0, lsl #4
 2f0:	0b3a0e03 	bleq	e83b04 <_bss_end+0xe7b2c4>
 2f4:	0b390b3b 	bleq	e42fe8 <_bss_end+0xe3a7a8>
 2f8:	00001349 	andeq	r1, r0, r9, asr #6
 2fc:	31012e23 	tstcc	r1, r3, lsr #28
 300:	640e6e13 	strvs	r6, [lr], #-3603	; 0xfffff1ed
 304:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 308:	97184006 	ldrls	r4, [r8, -r6]
 30c:	00001942 	andeq	r1, r0, r2, asr #18
 310:	31000524 	tstcc	r0, r4, lsr #10
 314:	00180213 	andseq	r0, r8, r3, lsl r2
 318:	11010000 	mrsne	r0, (UNDEF: 1)
 31c:	130e2501 	movwne	r2, #58625	; 0xe501
 320:	1b0e030b 	blne	380f54 <_bss_end+0x378714>
 324:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 328:	00171006 	andseq	r1, r7, r6
 32c:	00240200 	eoreq	r0, r4, r0, lsl #4
 330:	0b3e0b0b 	bleq	f82f64 <_bss_end+0xf7a724>
 334:	00000e03 	andeq	r0, r0, r3, lsl #28
 338:	0b002403 	bleq	934c <_bss_end+0xb0c>
 33c:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 340:	04000008 	streq	r0, [r0], #-8
 344:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
 348:	0b3b0b3a 	bleq	ec3038 <_bss_end+0xeba7f8>
 34c:	13490b39 	movtne	r0, #39737	; 0x9b39
 350:	26050000 	strcs	r0, [r5], -r0
 354:	00134900 	andseq	r4, r3, r0, lsl #18
 358:	00350600 	eorseq	r0, r5, r0, lsl #12
 35c:	00001349 	andeq	r1, r0, r9, asr #6
 360:	03010407 	movweq	r0, #5127	; 0x1407
 364:	3e196d0e 	cdpcc	13, 1, cr6, cr9, cr14, {0}
 368:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
 36c:	3b0b3a13 	blcc	2cebc0 <_bss_end+0x2c6380>
 370:	010b390b 	tsteq	fp, fp, lsl #18
 374:	08000013 	stmdaeq	r0, {r0, r1, r4}
 378:	0e030028 	cdpeq	0, 0, cr0, cr3, cr8, {1}
 37c:	00000b1c 	andeq	r0, r0, ip, lsl fp
 380:	03010209 	movweq	r0, #4617	; 0x1209
 384:	3a0b0b0e 	bcc	2c2fc4 <_bss_end+0x2ba784>
 388:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 38c:	0013010b 	andseq	r0, r3, fp, lsl #2
 390:	000d0a00 	andeq	r0, sp, r0, lsl #20
 394:	0b3a0e03 	bleq	e83ba8 <_bss_end+0xe7b368>
 398:	0b390b3b 	bleq	e4308c <_bss_end+0xe3a84c>
 39c:	0b381349 	bleq	e050c8 <_bss_end+0xdfc888>
 3a0:	2e0b0000 	cdpcs	0, 0, cr0, cr11, cr0, {0}
 3a4:	03193f01 	tsteq	r9, #1, 30
 3a8:	3b0b3a0e 	blcc	2cebe8 <_bss_end+0x2c63a8>
 3ac:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 3b0:	3213490e 	andscc	r4, r3, #229376	; 0x38000
 3b4:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 3b8:	00130113 	andseq	r0, r3, r3, lsl r1
 3bc:	00050c00 	andeq	r0, r5, r0, lsl #24
 3c0:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
 3c4:	050d0000 	streq	r0, [sp, #-0]
 3c8:	00134900 	andseq	r4, r3, r0, lsl #18
 3cc:	012e0e00 			; <UNDEFINED> instruction: 0x012e0e00
 3d0:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 3d4:	0b3b0b3a 	bleq	ec30c4 <_bss_end+0xeba884>
 3d8:	0e6e0b39 	vmoveq.8	d14[5], r0
 3dc:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 3e0:	13011364 	movwne	r1, #4964	; 0x1364
 3e4:	2e0f0000 	cdpcs	0, 0, cr0, cr15, cr0, {0}
 3e8:	03193f01 	tsteq	r9, #1, 30
 3ec:	3b0b3a0e 	blcc	2cec2c <_bss_end+0x2c63ec>
 3f0:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 3f4:	3c0b320e 	sfmcc	f3, 4, [fp], {14}
 3f8:	00136419 	andseq	r6, r3, r9, lsl r4
 3fc:	000f1000 	andeq	r1, pc, r0
 400:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 404:	10110000 	andsne	r0, r1, r0
 408:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 40c:	12000013 	andne	r0, r0, #19
 410:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 414:	0b3b0b3a 	bleq	ec3104 <_bss_end+0xeba8c4>
 418:	13490b39 	movtne	r0, #39737	; 0x9b39
 41c:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
 420:	34130000 	ldrcc	r0, [r3], #-0
 424:	3a0e0300 	bcc	38102c <_bss_end+0x3787ec>
 428:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 42c:	6c13490b 			; <UNDEFINED> instruction: 0x6c13490b
 430:	00180219 	andseq	r0, r8, r9, lsl r2
 434:	012e1400 			; <UNDEFINED> instruction: 0x012e1400
 438:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 43c:	0b3b0b3a 	bleq	ec312c <_bss_end+0xeba8ec>
 440:	13490b39 	movtne	r0, #39737	; 0x9b39
 444:	06120111 			; <UNDEFINED> instruction: 0x06120111
 448:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 44c:	15000019 	strne	r0, [r0, #-25]	; 0xffffffe7
 450:	08030034 	stmdaeq	r3, {r2, r4, r5}
 454:	0b3b0b3a 	bleq	ec3144 <_bss_end+0xeba904>
 458:	13490b39 	movtne	r0, #39737	; 0x9b39
 45c:	00001802 	andeq	r1, r0, r2, lsl #16
 460:	00110100 	andseq	r0, r1, r0, lsl #2
 464:	01110610 	tsteq	r1, r0, lsl r6
 468:	0e030112 	mcreq	1, 0, r0, cr3, cr2, {0}
 46c:	0e250e1b 	mcreq	14, 1, r0, cr5, cr11, {0}
 470:	00000513 	andeq	r0, r0, r3, lsl r5
 474:	01110100 	tsteq	r1, r0, lsl #2
 478:	0b130e25 	bleq	4c3d14 <_bss_end+0x4bb4d4>
 47c:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
 480:	06120111 			; <UNDEFINED> instruction: 0x06120111
 484:	00001710 	andeq	r1, r0, r0, lsl r7
 488:	03001602 	movweq	r1, #1538	; 0x602
 48c:	3b0b3a0e 	blcc	2ceccc <_bss_end+0x2c648c>
 490:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 494:	03000013 	movweq	r0, #19
 498:	0b0b000f 	bleq	2c04dc <_bss_end+0x2b7c9c>
 49c:	00001349 	andeq	r1, r0, r9, asr #6
 4a0:	00001504 	andeq	r1, r0, r4, lsl #10
 4a4:	00340500 	eorseq	r0, r4, r0, lsl #10
 4a8:	0b3a0e03 	bleq	e83cbc <_bss_end+0xe7b47c>
 4ac:	0b390b3b 	bleq	e431a0 <_bss_end+0xe3a960>
 4b0:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
 4b4:	0000193c 	andeq	r1, r0, ip, lsr r9
 4b8:	0b002406 	bleq	94d8 <_bss_end+0xc98>
 4bc:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 4c0:	07000008 	streq	r0, [r0, -r8]
 4c4:	13490101 	movtne	r0, #37121	; 0x9101
 4c8:	00001301 	andeq	r1, r0, r1, lsl #6
 4cc:	49002108 	stmdbmi	r0, {r3, r8, sp}
 4d0:	00062f13 	andeq	r2, r6, r3, lsl pc
 4d4:	00240900 	eoreq	r0, r4, r0, lsl #18
 4d8:	0b3e0b0b 	bleq	f8310c <_bss_end+0xf7a8cc>
 4dc:	00000e03 	andeq	r0, r0, r3, lsl #28
 4e0:	3f012e0a 	svccc	0x00012e0a
 4e4:	3a0e0319 	bcc	381150 <_bss_end+0x378910>
 4e8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 4ec:	1113490b 	tstne	r3, fp, lsl #18
 4f0:	40061201 	andmi	r1, r6, r1, lsl #4
 4f4:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
 4f8:	00001301 	andeq	r1, r0, r1, lsl #6
 4fc:	0300340b 	movweq	r3, #1035	; 0x40b
 500:	3b0b3a0e 	blcc	2ced40 <_bss_end+0x2c6500>
 504:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 508:	00180213 	andseq	r0, r8, r3, lsl r2
 50c:	012e0c00 			; <UNDEFINED> instruction: 0x012e0c00
 510:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 514:	0b3b0b3a 	bleq	ec3204 <_bss_end+0xeba9c4>
 518:	13490b39 	movtne	r0, #39737	; 0x9b39
 51c:	06120111 			; <UNDEFINED> instruction: 0x06120111
 520:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 524:	00130119 	andseq	r0, r3, r9, lsl r1
 528:	00340d00 	eorseq	r0, r4, r0, lsl #26
 52c:	0b3a0803 	bleq	e82540 <_bss_end+0xe79d00>
 530:	0b390b3b 	bleq	e43224 <_bss_end+0xe3a9e4>
 534:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 538:	01000000 	mrseq	r0, (UNDEF: 0)
 53c:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
 540:	0e030b13 	vmoveq.32	d3[0], r0
 544:	17100e1b 			; <UNDEFINED> instruction: 0x17100e1b
 548:	24020000 	strcs	r0, [r2], #-0
 54c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 550:	0008030b 	andeq	r0, r8, fp, lsl #6
 554:	00240300 	eoreq	r0, r4, r0, lsl #6
 558:	0b3e0b0b 	bleq	f8318c <_bss_end+0xf7a94c>
 55c:	00000e03 	andeq	r0, r0, r3, lsl #28
 560:	03001604 	movweq	r1, #1540	; 0x604
 564:	3b0b3a0e 	blcc	2ceda4 <_bss_end+0x2c6564>
 568:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 56c:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
 570:	0b0b000f 	bleq	2c05b4 <_bss_end+0x2b7d74>
 574:	00001349 	andeq	r1, r0, r9, asr #6
 578:	27011506 	strcs	r1, [r1, -r6, lsl #10]
 57c:	01134919 	tsteq	r3, r9, lsl r9
 580:	07000013 	smladeq	r0, r3, r0, r0
 584:	13490005 	movtne	r0, #36869	; 0x9005
 588:	26080000 	strcs	r0, [r8], -r0
 58c:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
 590:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 594:	0b3b0b3a 	bleq	ec3284 <_bss_end+0xebaa44>
 598:	13490b39 	movtne	r0, #39737	; 0x9b39
 59c:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
 5a0:	040a0000 	streq	r0, [sl], #-0
 5a4:	3e0e0301 	cdpcc	3, 0, cr0, cr14, cr1, {0}
 5a8:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
 5ac:	3b0b3a13 	blcc	2cee00 <_bss_end+0x2c65c0>
 5b0:	010b390b 	tsteq	fp, fp, lsl #18
 5b4:	0b000013 	bleq	608 <_start-0x79f8>
 5b8:	0e030028 	cdpeq	0, 0, cr0, cr3, cr8, {1}
 5bc:	00000b1c 	andeq	r0, r0, ip, lsl fp
 5c0:	4901010c 	stmdbmi	r1, {r2, r3, r8}
 5c4:	00130113 	andseq	r0, r3, r3, lsl r1
 5c8:	00210d00 	eoreq	r0, r1, r0, lsl #26
 5cc:	260e0000 	strcs	r0, [lr], -r0
 5d0:	00134900 	andseq	r4, r3, r0, lsl #18
 5d4:	00340f00 	eorseq	r0, r4, r0, lsl #30
 5d8:	0b3a0e03 	bleq	e83dec <_bss_end+0xe7b5ac>
 5dc:	0b39053b 	bleq	e41ad0 <_bss_end+0xe39290>
 5e0:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
 5e4:	0000193c 	andeq	r1, r0, ip, lsr r9
 5e8:	03001310 	movweq	r1, #784	; 0x310
 5ec:	00193c0e 	andseq	r3, r9, lr, lsl #24
 5f0:	00151100 	andseq	r1, r5, r0, lsl #2
 5f4:	00001927 	andeq	r1, r0, r7, lsr #18
 5f8:	03001712 	movweq	r1, #1810	; 0x712
 5fc:	00193c0e 	andseq	r3, r9, lr, lsl #24
 600:	01131300 	tsteq	r3, r0, lsl #6
 604:	0b0b0e03 	bleq	2c3e18 <_bss_end+0x2bb5d8>
 608:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 60c:	13010b39 	movwne	r0, #6969	; 0x1b39
 610:	0d140000 	ldceq	0, cr0, [r4, #-0]
 614:	3a0e0300 	bcc	38121c <_bss_end+0x3789dc>
 618:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 61c:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 620:	1500000b 	strne	r0, [r0, #-11]
 624:	13490021 	movtne	r0, #36897	; 0x9021
 628:	00000b2f 	andeq	r0, r0, pc, lsr #22
 62c:	03010416 	movweq	r0, #5142	; 0x1416
 630:	0b0b3e0e 	bleq	2cfe70 <_bss_end+0x2c7630>
 634:	3a13490b 	bcc	4d2a68 <_bss_end+0x4ca228>
 638:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 63c:	0013010b 	andseq	r0, r3, fp, lsl #2
 640:	00341700 	eorseq	r1, r4, r0, lsl #14
 644:	0b3a1347 	bleq	e85368 <_bss_end+0xe7cb28>
 648:	0b39053b 	bleq	e41b3c <_bss_end+0xe392fc>
 64c:	00001802 	andeq	r1, r0, r2, lsl #16
	...

Disassembly of section .debug_aranges:

00000000 <.debug_aranges>:
   0:	0000001c 	andeq	r0, r0, ip, lsl r0
   4:	00000002 	andeq	r0, r0, r2
   8:	00040000 	andeq	r0, r4, r0
   c:	00000000 	andeq	r0, r0, r0
  10:	00008018 	andeq	r8, r0, r8, lsl r0
  14:	000000d8 	ldrdeq	r0, [r0], -r8
	...
  20:	0000001c 	andeq	r0, r0, ip, lsl r0
  24:	012a0002 			; <UNDEFINED> instruction: 0x012a0002
  28:	00040000 	andeq	r0, r4, r0
  2c:	00000000 	andeq	r0, r0, r0
  30:	000080f0 	strdeq	r8, [r0], -r0
  34:	00000510 	andeq	r0, r0, r0, lsl r5
	...
  40:	0000001c 	andeq	r0, r0, ip, lsl r0
  44:	079a0002 	ldreq	r0, [sl, r2]
  48:	00040000 	andeq	r0, r4, r0
  4c:	00000000 	andeq	r0, r0, r0
  50:	00008600 	andeq	r8, r0, r0, lsl #12
  54:	000000ac 	andeq	r0, r0, ip, lsr #1
	...
  60:	0000001c 	andeq	r0, r0, ip, lsl r0
  64:	0a230002 	beq	8c0074 <_bss_end+0x8b7834>
  68:	00040000 	andeq	r0, r4, r0
  6c:	00000000 	andeq	r0, r0, r0
  70:	00008000 	andeq	r8, r0, r0
  74:	00000018 	andeq	r0, r0, r8, lsl r0
	...
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	0a490002 	beq	1240094 <_bss_end+0x1237854>
  88:	00040000 	andeq	r0, r4, r0
  8c:	00000000 	andeq	r0, r0, r0
  90:	000086ac 	andeq	r8, r0, ip, lsr #13
  94:	00000118 	andeq	r0, r0, r8, lsl r1
	...
  a0:	00000014 	andeq	r0, r0, r4, lsl r0
  a4:	0b980002 	bleq	fe6000b4 <_bss_end+0xfe5f7874>
  a8:	00040000 	andeq	r0, r4, r0
	...

Disassembly of section .debug_line:

00000000 <.debug_line>:
   0:	000000a6 	andeq	r0, r0, r6, lsr #1
   4:	006d0003 	rsbeq	r0, sp, r3
   8:	01020000 	mrseq	r0, (UNDEF: 2)
   c:	000d0efb 	strdeq	r0, [sp], -fp
  10:	01010101 	tsteq	r1, r1, lsl #2
  14:	01000000 	mrseq	r0, (UNDEF: 0)
  18:	2f010000 	svccs	0x00010000
  1c:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
  20:	6c69732f 	stclvs	3, cr7, [r9], #-188	; 0xffffff44
  24:	79766168 	ldmdbvc	r6!, {r3, r5, r6, r8, sp, lr}^
  28:	63532f6a 	cmpvs	r3, #424	; 0x1a8
  2c:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; fffffe94 <_bss_end+0xffff7654>
  30:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
  34:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
  38:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
  3c:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
  40:	302f7365 	eorcc	r7, pc, r5, ror #6
  44:	454c2d36 	strbmi	r2, [ip, #-3382]	; 0xfffff2ca
  48:	6f745f44 	svcvs	0x00745f44
  4c:	656c6767 	strbvs	r6, [ip, #-1895]!	; 0xfffff899
  50:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
  54:	2f6c656e 	svccs	0x006c656e
  58:	00637273 	rsbeq	r7, r3, r3, ror r2
  5c:	78786300 	ldmdavc	r8!, {r8, r9, sp, lr}^
  60:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
  64:	00000100 	andeq	r0, r0, r0, lsl #2
  68:	6975623c 	ldmdbvs	r5!, {r2, r3, r4, r5, r9, sp, lr}^
  6c:	692d746c 	pushvs	{r2, r3, r5, r6, sl, ip, sp, lr}
  70:	00003e6e 	andeq	r3, r0, lr, ror #28
  74:	05000000 	streq	r0, [r0, #-0]
  78:	02050005 	andeq	r0, r5, #5
  7c:	00008018 	andeq	r8, r0, r8, lsl r0
  80:	05010a03 	streq	r0, [r1, #-2563]	; 0xfffff5fd
  84:	10058311 	andne	r8, r5, r1, lsl r3
  88:	8305054a 	movwhi	r0, #21834	; 0x554a
  8c:	83130585 	tsthi	r3, #557842432	; 0x21400000
  90:	85670505 	strbhi	r0, [r7, #-1285]!	; 0xfffffafb
  94:	86010583 	strhi	r0, [r1], -r3, lsl #11
  98:	854c854c 	strbhi	r8, [ip, #-1356]	; 0xfffffab4
  9c:	0505854c 	streq	r8, [r5, #-1356]	; 0xfffffab4
  a0:	01040200 	mrseq	r0, R12_usr
  a4:	0002024b 	andeq	r0, r2, fp, asr #4
  a8:	02e60101 	rsceq	r0, r6, #1073741824	; 0x40000000
  ac:	00030000 	andeq	r0, r3, r0
  b0:	00000130 	andeq	r0, r0, r0, lsr r1
  b4:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
  b8:	0101000d 	tsteq	r1, sp
  bc:	00000101 	andeq	r0, r0, r1, lsl #2
  c0:	00000100 	andeq	r0, r0, r0, lsl #2
  c4:	6f682f01 	svcvs	0x00682f01
  c8:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
  cc:	61686c69 	cmnvs	r8, r9, ror #24
  d0:	2f6a7976 	svccs	0x006a7976
  d4:	6f686353 	svcvs	0x00686353
  d8:	5a2f6c6f 	bpl	bdb29c <_bss_end+0xbd2a5c>
  dc:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; ffffff50 <_bss_end+0xffff7710>
  e0:	2f657461 	svccs	0x00657461
  e4:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
  e8:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
  ec:	2d36302f 	ldccs	0, cr3, [r6, #-188]!	; 0xffffff44
  f0:	5f44454c 	svcpl	0x0044454c
  f4:	67676f74 			; <UNDEFINED> instruction: 0x67676f74
  f8:	6b2f656c 	blvs	bd96b0 <_bss_end+0xbd0e70>
  fc:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 100:	72732f6c 	rsbsvc	r2, r3, #108, 30	; 0x1b0
 104:	72642f63 	rsbvc	r2, r4, #396	; 0x18c
 108:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
 10c:	682f0073 	stmdavs	pc!, {r0, r1, r4, r5, r6}	; <UNPREDICTABLE>
 110:	2f656d6f 	svccs	0x00656d6f
 114:	686c6973 	stmdavs	ip!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
 118:	6a797661 	bvs	1e5daa4 <_bss_end+0x1e55264>
 11c:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
 120:	2f6c6f6f 	svccs	0x006c6f6f
 124:	6f72655a 	svcvs	0x0072655a
 128:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
 12c:	6178652f 	cmnvs	r8, pc, lsr #10
 130:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
 134:	36302f73 	shsub16cc	r2, r0, r3
 138:	44454c2d 	strbmi	r4, [r5], #-3117	; 0xfffff3d3
 13c:	676f745f 			; <UNDEFINED> instruction: 0x676f745f
 140:	2f656c67 	svccs	0x00656c67
 144:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 148:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 14c:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 150:	622f6564 	eorvs	r6, pc, #100, 10	; 0x19000000
 154:	6472616f 	ldrbtvs	r6, [r2], #-367	; 0xfffffe91
 158:	6970722f 	ldmdbvs	r0!, {r0, r1, r2, r3, r5, r9, ip, sp, lr}^
 15c:	61682f30 	cmnvs	r8, r0, lsr pc
 160:	682f006c 	stmdavs	pc!, {r2, r3, r5, r6}	; <UNPREDICTABLE>
 164:	2f656d6f 	svccs	0x00656d6f
 168:	686c6973 	stmdavs	ip!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
 16c:	6a797661 	bvs	1e5daf8 <_bss_end+0x1e552b8>
 170:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
 174:	2f6c6f6f 	svccs	0x006c6f6f
 178:	6f72655a 	svcvs	0x0072655a
 17c:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
 180:	6178652f 	cmnvs	r8, pc, lsr #10
 184:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
 188:	36302f73 	shsub16cc	r2, r0, r3
 18c:	44454c2d 	strbmi	r4, [r5], #-3117	; 0xfffff3d3
 190:	676f745f 			; <UNDEFINED> instruction: 0x676f745f
 194:	2f656c67 	svccs	0x00656c67
 198:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 19c:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 1a0:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 1a4:	642f6564 	strtvs	r6, [pc], #-1380	; 1ac <_start-0x7e54>
 1a8:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
 1ac:	00007372 	andeq	r7, r0, r2, ror r3
 1b0:	6f697067 	svcvs	0x00697067
 1b4:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
 1b8:	00000100 	andeq	r0, r0, r0, lsl #2
 1bc:	64746e69 	ldrbtvs	r6, [r4], #-3689	; 0xfffff197
 1c0:	682e6665 	stmdavs	lr!, {r0, r2, r5, r6, r9, sl, sp, lr}
 1c4:	00000200 	andeq	r0, r0, r0, lsl #4
 1c8:	69726570 	ldmdbvs	r2!, {r4, r5, r6, r8, sl, sp, lr}^
 1cc:	72656870 	rsbvc	r6, r5, #112, 16	; 0x700000
 1d0:	2e736c61 	cdpcs	12, 7, cr6, cr3, cr1, {3}
 1d4:	00020068 	andeq	r0, r2, r8, rrx
 1d8:	69706700 	ldmdbvs	r0!, {r8, r9, sl, sp, lr}^
 1dc:	00682e6f 	rsbeq	r2, r8, pc, ror #28
 1e0:	00000003 	andeq	r0, r0, r3
 1e4:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
 1e8:	0080f002 	addeq	pc, r0, r2
 1ec:	38051700 	stmdacc	r5, {r8, r9, sl, ip}
 1f0:	6901059f 	stmdbvs	r1, {r0, r1, r2, r3, r4, r7, r8, sl}
 1f4:	d70505a1 	strle	r0, [r5, -r1, lsr #11]
 1f8:	05671005 	strbeq	r1, [r7, #-5]!
 1fc:	93084c11 	movwls	r4, #35857	; 0x8c11
 200:	05670d05 	strbeq	r0, [r7, #-3333]!	; 0xfffff2fb
 204:	0d053011 	stceq	0, cr3, [r5, #-68]	; 0xffffffbc
 208:	30110567 	andscc	r0, r1, r7, ror #10
 20c:	05670d05 	strbeq	r0, [r7, #-3333]!	; 0xfffff2fb
 210:	0d053011 	stceq	0, cr3, [r5, #-68]	; 0xffffffbc
 214:	30110567 	andscc	r0, r1, r7, ror #10
 218:	05670d05 	strbeq	r0, [r7, #-3333]!	; 0xfffff2fb
 21c:	0d053011 	stceq	0, cr3, [r5, #-68]	; 0xffffffbc
 220:	31140567 	tstcc	r4, r7, ror #10
 224:	20081a05 	andcs	r1, r8, r5, lsl #20
 228:	05660d05 	strbeq	r0, [r6, #-3333]!	; 0xfffff2fb
 22c:	01054c0c 	tsteq	r5, ip, lsl #24
 230:	0505a12f 	streq	sl, [r5, #-303]	; 0xfffffed1
 234:	671005d7 			; <UNDEFINED> instruction: 0x671005d7
 238:	004c0b05 	subeq	r0, ip, r5, lsl #22
 23c:	06010402 	streq	r0, [r1], -r2, lsl #8
 240:	04020066 	streq	r0, [r2], #-102	; 0xffffff9a
 244:	09054a02 	stmdbeq	r5, {r1, r9, fp, lr}
 248:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
 24c:	13052e06 	movwne	r2, #24070	; 0x5e06
 250:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
 254:	000d054b 	andeq	r0, sp, fp, asr #10
 258:	4a040402 	bmi	101268 <_bss_end+0xf8a28>
 25c:	02000c05 	andeq	r0, r0, #1280	; 0x500
 260:	054c0404 	strbeq	r0, [ip, #-1028]	; 0xfffffbfc
 264:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 268:	1005d705 	andne	sp, r5, r5, lsl #14
 26c:	4c0b0567 	cfstr32mi	mvfx0, [fp], {103}	; 0x67
 270:	01040200 	mrseq	r0, R12_usr
 274:	02006606 	andeq	r6, r0, #6291456	; 0x600000
 278:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 27c:	04020009 	streq	r0, [r2], #-9
 280:	052e0604 	streq	r0, [lr, #-1540]!	; 0xfffff9fc
 284:	04020013 	streq	r0, [r2], #-19	; 0xffffffed
 288:	0d054b04 	vstreq	d4, [r5, #-16]
 28c:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
 290:	000c054a 	andeq	r0, ip, sl, asr #10
 294:	4c040402 	cfstrsmi	mvf0, [r4], {2}
 298:	852f0105 	strhi	r0, [pc, #-261]!	; 19b <_start-0x7e65>
 29c:	05d70505 	ldrbeq	r0, [r7, #1285]	; 0x505
 2a0:	0b056710 	bleq	159ee8 <_bss_end+0x1516a8>
 2a4:	0402004c 	streq	r0, [r2], #-76	; 0xffffffb4
 2a8:	00660601 	rsbeq	r0, r6, r1, lsl #12
 2ac:	4a020402 	bmi	812bc <_bss_end+0x78a7c>
 2b0:	02000905 	andeq	r0, r0, #81920	; 0x14000
 2b4:	2e060404 	cdpcs	4, 0, cr0, cr6, cr4, {0}
 2b8:	02001305 	andeq	r1, r0, #335544320	; 0x14000000
 2bc:	054b0404 	strbeq	r0, [fp, #-1028]	; 0xfffffbfc
 2c0:	0402000d 	streq	r0, [r2], #-13
 2c4:	0c054a04 			; <UNDEFINED> instruction: 0x0c054a04
 2c8:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
 2cc:	2f01054c 	svccs	0x0001054c
 2d0:	d81d0585 	ldmdale	sp, {r0, r2, r7, r8, sl}
 2d4:	05ba0905 	ldreq	r0, [sl, #2309]!	; 0x905
 2d8:	13054a05 	movwne	r4, #23045	; 0x5a05
 2dc:	4a1c054d 	bmi	701818 <_bss_end+0x6f8fd8>
 2e0:	05823e05 	streq	r3, [r2, #3589]	; 0xe05
 2e4:	1e056621 	cfmadd32ne	mvax1, mvfx6, mvfx5, mvfx1
 2e8:	2e4b052e 	cdpcs	5, 4, cr0, cr11, cr14, {1}
 2ec:	052e6b05 	streq	r6, [lr, #-2821]!	; 0xfffff4fb
 2f0:	0e054a05 	vmlaeq.f32	s8, s10, s10
 2f4:	6648054a 	strbvs	r0, [r8], -sl, asr #10
 2f8:	052e1005 	streq	r1, [lr, #-5]!
 2fc:	01054809 	tsteq	r5, r9, lsl #16
 300:	1d054d31 	stcne	13, cr4, [r5, #-196]	; 0xffffff3c
 304:	ba0905a0 	blt	24198c <_bss_end+0x23914c>
 308:	054a0505 	strbeq	r0, [sl, #-1285]	; 0xfffffafb
 30c:	29054b20 	stmdbcs	r5, {r5, r8, r9, fp, lr}
 310:	4a32054c 	bmi	c81848 <_bss_end+0xc79008>
 314:	05823405 	streq	r3, [r2, #1029]	; 0x405
 318:	3f054a0c 	svccc	0x00054a0c
 31c:	0001052e 	andeq	r0, r1, lr, lsr #10
 320:	4b010402 	blmi	41330 <_bss_end+0x38af0>
 324:	d80b0569 	stmdale	fp, {r0, r3, r5, r6, r8, sl}
 328:	05663505 	strbeq	r3, [r6, #-1285]!	; 0xfffffafb
 32c:	04020024 	streq	r0, [r2], #-36	; 0xffffffdc
 330:	09054a02 	stmdbeq	r5, {r1, r9, fp, lr}
 334:	02040200 	andeq	r0, r4, #0, 4
 338:	003505f2 	ldrshteq	r0, [r5], -r2
 33c:	4a030402 	bmi	c134c <_bss_end+0xb8b0c>
 340:	02005405 	andeq	r5, r0, #83886080	; 0x5000000
 344:	05660604 	strbeq	r0, [r6, #-1540]!	; 0xfffff9fc
 348:	04020038 	streq	r0, [r2], #-56	; 0xffffffc8
 34c:	3505f206 	strcc	pc, [r5, #-518]	; 0xfffffdfa
 350:	07040200 	streq	r0, [r4, -r0, lsl #4]
 354:	0402004a 	streq	r0, [r2], #-74	; 0xffffffb6
 358:	054a0608 	strbeq	r0, [sl, #-1544]	; 0xfffff9f8
 35c:	04020005 	streq	r0, [r2], #-5
 360:	052e060a 	streq	r0, [lr, #-1546]!	; 0xfffff9f6
 364:	05054d15 	streq	r4, [r5, #-3349]	; 0xfffff2eb
 368:	4a0e0566 	bmi	381908 <_bss_end+0x3790c8>
 36c:	05661505 	strbeq	r1, [r6, #-1285]!	; 0xfffffafb
 370:	09052e10 	stmdbeq	r5, {r4, r9, sl, fp, sp}
 374:	31010548 	tstcc	r1, r8, asr #10
 378:	02009e4a 	andeq	r9, r0, #1184	; 0x4a0
 37c:	66060104 	strvs	r0, [r6], -r4, lsl #2
 380:	03062305 	movweq	r2, #25349	; 0x6305
 384:	05827f9e 	streq	r7, [r2, #3998]	; 0xf9e
 388:	00e20301 	rsceq	r0, r2, r1, lsl #6
 38c:	024aba66 	subeq	fp, sl, #417792	; 0x66000
 390:	0101000a 	tsteq	r1, sl
 394:	0000015c 	andeq	r0, r0, ip, asr r1
 398:	01170003 	tsteq	r7, r3
 39c:	01020000 	mrseq	r0, (UNDEF: 2)
 3a0:	000d0efb 	strdeq	r0, [sp], -fp
 3a4:	01010101 	tsteq	r1, r1, lsl #2
 3a8:	01000000 	mrseq	r0, (UNDEF: 0)
 3ac:	2f010000 	svccs	0x00010000
 3b0:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
 3b4:	6c69732f 	stclvs	3, cr7, [r9], #-188	; 0xffffff44
 3b8:	79766168 	ldmdbvc	r6!, {r3, r5, r6, r8, sp, lr}^
 3bc:	63532f6a 	cmpvs	r3, #424	; 0x1a8
 3c0:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; 228 <_start-0x7dd8>
 3c4:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
 3c8:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
 3cc:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 3d0:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
 3d4:	302f7365 	eorcc	r7, pc, r5, ror #6
 3d8:	454c2d36 	strbmi	r2, [ip, #-3382]	; 0xfffff2ca
 3dc:	6f745f44 	svcvs	0x00745f44
 3e0:	656c6767 	strbvs	r6, [ip, #-1895]!	; 0xfffff899
 3e4:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 3e8:	2f6c656e 	svccs	0x006c656e
 3ec:	00637273 	rsbeq	r7, r3, r3, ror r2
 3f0:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 33c <_start-0x7cc4>
 3f4:	69732f65 	ldmdbvs	r3!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 3f8:	7661686c 	strbtvc	r6, [r1], -ip, ror #16
 3fc:	532f6a79 			; <UNDEFINED> instruction: 0x532f6a79
 400:	6f6f6863 	svcvs	0x006f6863
 404:	655a2f6c 	ldrbvs	r2, [sl, #-3948]	; 0xfffff094
 408:	614d6f72 	hvcvs	55026	; 0xd6f2
 40c:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffea0 <_bss_end+0xffff7660>
 410:	706d6178 	rsbvc	r6, sp, r8, ror r1
 414:	2f73656c 	svccs	0x0073656c
 418:	4c2d3630 	stcmi	6, cr3, [sp], #-192	; 0xffffff40
 41c:	745f4445 	ldrbvc	r4, [pc], #-1093	; 424 <_start-0x7bdc>
 420:	6c67676f 	stclvs	7, cr6, [r7], #-444	; 0xfffffe44
 424:	656b2f65 	strbvs	r2, [fp, #-3941]!	; 0xfffff09b
 428:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
 42c:	636e692f 	cmnvs	lr, #770048	; 0xbc000
 430:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
 434:	616f622f 	cmnvs	pc, pc, lsr #4
 438:	722f6472 	eorvc	r6, pc, #1912602624	; 0x72000000
 43c:	2f306970 	svccs	0x00306970
 440:	006c6168 	rsbeq	r6, ip, r8, ror #2
 444:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 390 <_start-0x7c70>
 448:	69732f65 	ldmdbvs	r3!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 44c:	7661686c 	strbtvc	r6, [r1], -ip, ror #16
 450:	532f6a79 			; <UNDEFINED> instruction: 0x532f6a79
 454:	6f6f6863 	svcvs	0x006f6863
 458:	655a2f6c 	ldrbvs	r2, [sl, #-3948]	; 0xfffff094
 45c:	614d6f72 	hvcvs	55026	; 0xd6f2
 460:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffef4 <_bss_end+0xffff76b4>
 464:	706d6178 	rsbvc	r6, sp, r8, ror r1
 468:	2f73656c 	svccs	0x0073656c
 46c:	4c2d3630 	stcmi	6, cr3, [sp], #-192	; 0xffffff40
 470:	745f4445 	ldrbvc	r4, [pc], #-1093	; 478 <_start-0x7b88>
 474:	6c67676f 	stclvs	7, cr6, [r7], #-444	; 0xfffffe44
 478:	656b2f65 	strbvs	r2, [fp, #-3941]!	; 0xfffff09b
 47c:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
 480:	636e692f 	cmnvs	lr, #770048	; 0xbc000
 484:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
 488:	6972642f 	ldmdbvs	r2!, {r0, r1, r2, r3, r5, sl, sp, lr}^
 48c:	73726576 	cmnvc	r2, #494927872	; 0x1d800000
 490:	616d0000 	cmnvs	sp, r0
 494:	632e6e69 			; <UNDEFINED> instruction: 0x632e6e69
 498:	01007070 	tsteq	r0, r0, ror r0
 49c:	6e690000 	cdpvs	0, 6, cr0, cr9, cr0, {0}
 4a0:	66656474 			; <UNDEFINED> instruction: 0x66656474
 4a4:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 4a8:	70670000 	rsbvc	r0, r7, r0
 4ac:	682e6f69 	stmdavs	lr!, {r0, r3, r5, r6, r8, r9, sl, fp, sp, lr}
 4b0:	00000300 	andeq	r0, r0, r0, lsl #6
 4b4:	00010500 	andeq	r0, r1, r0, lsl #10
 4b8:	86000205 	strhi	r0, [r0], -r5, lsl #4
 4bc:	05180000 	ldreq	r0, [r8, #-0]
 4c0:	1205681c 	andne	r6, r5, #28, 16	; 0x1c0000
 4c4:	001b0589 	andseq	r0, fp, r9, lsl #11
 4c8:	4a030402 	bmi	c14d8 <_bss_end+0xb8c98>
 4cc:	02000905 	andeq	r0, r0, #81920	; 0x14000
 4d0:	05d60204 	ldrbeq	r0, [r6, #516]	; 0x204
 4d4:	12058619 	andne	r8, r5, #26214400	; 0x1900000
 4d8:	001b0585 	andseq	r0, fp, r5, lsl #11
 4dc:	4a030402 	bmi	c14ec <_bss_end+0xb8cac>
 4e0:	02000905 	andeq	r0, r0, #81920	; 0x14000
 4e4:	05d60204 	ldrbeq	r0, [r6, #516]	; 0x204
 4e8:	12058619 	andne	r8, r5, #26214400	; 0x1900000
 4ec:	02827503 	addeq	r7, r2, #12582912	; 0xc00000
 4f0:	01010004 	tsteq	r1, r4
 4f4:	00000077 	andeq	r0, r0, r7, ror r0
 4f8:	005f0003 	subseq	r0, pc, r3
 4fc:	01020000 	mrseq	r0, (UNDEF: 2)
 500:	000d0efb 	strdeq	r0, [sp], -fp
 504:	01010101 	tsteq	r1, r1, lsl #2
 508:	01000000 	mrseq	r0, (UNDEF: 0)
 50c:	2f010000 	svccs	0x00010000
 510:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
 514:	6c69732f 	stclvs	3, cr7, [r9], #-188	; 0xffffff44
 518:	79766168 	ldmdbvc	r6!, {r3, r5, r6, r8, sp, lr}^
 51c:	63532f6a 	cmpvs	r3, #424	; 0x1a8
 520:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; 388 <_start-0x7c78>
 524:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
 528:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
 52c:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 530:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
 534:	302f7365 	eorcc	r7, pc, r5, ror #6
 538:	454c2d36 	strbmi	r2, [ip, #-3382]	; 0xfffff2ca
 53c:	6f745f44 	svcvs	0x00745f44
 540:	656c6767 	strbvs	r6, [ip, #-1895]!	; 0xfffff899
 544:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 548:	2f6c656e 	svccs	0x006c656e
 54c:	00637273 	rsbeq	r7, r3, r3, ror r2
 550:	61747300 	cmnvs	r4, r0, lsl #6
 554:	732e7472 			; <UNDEFINED> instruction: 0x732e7472
 558:	00000100 	andeq	r0, r0, r0, lsl #2
 55c:	02050000 	andeq	r0, r5, #0
 560:	00008000 	andeq	r8, r0, r0
 564:	2f2f2f19 	svccs	0x002f2f19
 568:	0202302f 	andeq	r3, r2, #47	; 0x2f
 56c:	e4010100 	str	r0, [r1], #-256	; 0xffffff00
 570:	03000000 	movweq	r0, #0
 574:	00006300 	andeq	r6, r0, r0, lsl #6
 578:	fb010200 	blx	40d82 <_bss_end+0x38542>
 57c:	01000d0e 	tsteq	r0, lr, lsl #26
 580:	00010101 	andeq	r0, r1, r1, lsl #2
 584:	00010000 	andeq	r0, r1, r0
 588:	682f0100 	stmdavs	pc!, {r8}	; <UNPREDICTABLE>
 58c:	2f656d6f 	svccs	0x00656d6f
 590:	686c6973 	stmdavs	ip!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
 594:	6a797661 	bvs	1e5df20 <_bss_end+0x1e556e0>
 598:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
 59c:	2f6c6f6f 	svccs	0x006c6f6f
 5a0:	6f72655a 	svcvs	0x0072655a
 5a4:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
 5a8:	6178652f 	cmnvs	r8, pc, lsr #10
 5ac:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
 5b0:	36302f73 	shsub16cc	r2, r0, r3
 5b4:	44454c2d 	strbmi	r4, [r5], #-3117	; 0xfffff3d3
 5b8:	676f745f 			; <UNDEFINED> instruction: 0x676f745f
 5bc:	2f656c67 	svccs	0x00656c67
 5c0:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 5c4:	732f6c65 			; <UNDEFINED> instruction: 0x732f6c65
 5c8:	00006372 	andeq	r6, r0, r2, ror r3
 5cc:	72617473 	rsbvc	r7, r1, #1929379840	; 0x73000000
 5d0:	2e707574 	mrccs	5, 3, r7, cr0, cr4, {3}
 5d4:	00707063 	rsbseq	r7, r0, r3, rrx
 5d8:	00000001 	andeq	r0, r0, r1
 5dc:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
 5e0:	0086ac02 	addeq	sl, r6, r2, lsl #24
 5e4:	01140300 	tsteq	r4, r0, lsl #6
 5e8:	056a0c05 	strbeq	r0, [sl, #-3077]!	; 0xfffff3fb
 5ec:	04020022 	streq	r0, [r2], #-34	; 0xffffffde
 5f0:	0c056603 	stceq	6, cr6, [r5], {3}
 5f4:	02040200 	andeq	r0, r4, #0, 4
 5f8:	000505bb 			; <UNDEFINED> instruction: 0x000505bb
 5fc:	65020402 	strvs	r0, [r2, #-1026]	; 0xfffffbfe
 600:	05850c05 	streq	r0, [r5, #3077]	; 0xc05
 604:	05bd2f01 	ldreq	r2, [sp, #3841]!	; 0xf01
 608:	27056b10 	smladcs	r5, r0, fp, r6
 60c:	03040200 	movweq	r0, #16896	; 0x4200
 610:	000a054a 	andeq	r0, sl, sl, asr #10
 614:	83020402 	movwhi	r0, #9218	; 0x2402
 618:	02001105 	andeq	r1, r0, #1073741825	; 0x40000001
 61c:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 620:	04020005 	streq	r0, [r2], #-5
 624:	0c052d02 	stceq	13, cr2, [r5], {2}
 628:	2f010585 	svccs	0x00010585
 62c:	6a1005a1 	bvs	401cb8 <_bss_end+0x3f9478>
 630:	02002705 	andeq	r2, r0, #1310720	; 0x140000
 634:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
 638:	0402000a 	streq	r0, [r2], #-10
 63c:	11058302 	tstne	r5, r2, lsl #6
 640:	02040200 	andeq	r0, r4, #0, 4
 644:	0005054a 	andeq	r0, r5, sl, asr #10
 648:	2d020402 	cfstrscs	mvf0, [r2, #-8]
 64c:	05850c05 	streq	r0, [r5, #3077]	; 0xc05
 650:	0a022f01 	beq	8c25c <_bss_end+0x83a1c>
 654:	03010100 	movweq	r0, #4352	; 0x1100
 658:	03000001 	movweq	r0, #1
 65c:	0000fd00 	andeq	pc, r0, r0, lsl #26
 660:	fb010200 	blx	40e6a <_bss_end+0x3862a>
 664:	01000d0e 	tsteq	r0, lr, lsl #26
 668:	00010101 	andeq	r0, r1, r1, lsl #2
 66c:	00010000 	andeq	r0, r1, r0
 670:	2e2e0100 	sufcse	f0, f6, f0
 674:	2f2e2e2f 	svccs	0x002e2e2f
 678:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 67c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 680:	2f2e2e2f 	svccs	0x002e2e2f
 684:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
 688:	2e2f6363 	cdpcs	3, 2, cr6, cr15, cr3, {3}
 68c:	6e692f2e 	cdpvs	15, 6, cr2, cr9, cr14, {1}
 690:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 694:	2e2e0065 	cdpcs	0, 2, cr0, cr14, cr5, {3}
 698:	2f2e2e2f 	svccs	0x002e2e2f
 69c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 6a0:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 6a4:	672f2e2f 	strvs	r2, [pc, -pc, lsr #28]!
 6a8:	2e006363 	cdpcs	3, 0, cr6, cr0, cr3, {3}
 6ac:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 6b0:	2f2e2e2f 	svccs	0x002e2e2f
 6b4:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 6b8:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 6bc:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
 6c0:	2f636367 	svccs	0x00636367
 6c4:	672f2e2e 	strvs	r2, [pc, -lr, lsr #28]!
 6c8:	632f6363 			; <UNDEFINED> instruction: 0x632f6363
 6cc:	69666e6f 	stmdbvs	r6!, {r0, r1, r2, r3, r5, r6, r9, sl, fp, sp, lr}^
 6d0:	72612f67 	rsbvc	r2, r1, #412	; 0x19c
 6d4:	2e2e006d 	cdpcs	0, 2, cr0, cr14, cr13, {3}
 6d8:	2f2e2e2f 	svccs	0x002e2e2f
 6dc:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 6e0:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 6e4:	2f2e2e2f 	svccs	0x002e2e2f
 6e8:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
 6ec:	00006363 	andeq	r6, r0, r3, ror #6
 6f0:	68736168 	ldmdavs	r3!, {r3, r5, r6, r8, sp, lr}^
 6f4:	2e626174 	mcrcs	1, 3, r6, cr2, cr4, {3}
 6f8:	00010068 	andeq	r0, r1, r8, rrx
 6fc:	6d726100 	ldfvse	f6, [r2, #-0]
 700:	6173692d 	cmnvs	r3, sp, lsr #18
 704:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 708:	72610000 	rsbvc	r0, r1, #0
 70c:	70632d6d 	rsbvc	r2, r3, sp, ror #26
 710:	00682e75 	rsbeq	r2, r8, r5, ror lr
 714:	69000002 	stmdbvs	r0, {r1}
 718:	2d6e736e 	stclcs	3, cr7, [lr, #-440]!	; 0xfffffe48
 71c:	736e6f63 	cmnvc	lr, #396	; 0x18c
 720:	746e6174 	strbtvc	r6, [lr], #-372	; 0xfffffe8c
 724:	00682e73 	rsbeq	r2, r8, r3, ror lr
 728:	61000002 	tstvs	r0, r2
 72c:	682e6d72 	stmdavs	lr!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}
 730:	00000300 	andeq	r0, r0, r0, lsl #6
 734:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
 738:	2e326363 	cdpcs	3, 3, cr6, cr2, cr3, {3}
 73c:	00040068 	andeq	r0, r4, r8, rrx
 740:	6c626700 	stclvs	7, cr6, [r2], #-0
 744:	6f74632d 	svcvs	0x0074632d
 748:	682e7372 	stmdavs	lr!, {r1, r4, r5, r6, r8, r9, ip, sp, lr}
 74c:	00000400 	andeq	r0, r0, r0, lsl #8
 750:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
 754:	2e326363 	cdpcs	3, 3, cr6, cr2, cr3, {3}
 758:	00040063 	andeq	r0, r4, r3, rrx
	...

Disassembly of section .debug_str:

00000000 <.debug_str>:
       0:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; ffffff4c <_bss_end+0xffff770c>
       4:	69732f65 	ldmdbvs	r3!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
       8:	7661686c 	strbtvc	r6, [r1], -ip, ror #16
       c:	532f6a79 			; <UNDEFINED> instruction: 0x532f6a79
      10:	6f6f6863 	svcvs	0x006f6863
      14:	655a2f6c 	ldrbvs	r2, [sl, #-3948]	; 0xfffff094
      18:	614d6f72 	hvcvs	55026	; 0xd6f2
      1c:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffab0 <_bss_end+0xffff7270>
      20:	706d6178 	rsbvc	r6, sp, r8, ror r1
      24:	2f73656c 	svccs	0x0073656c
      28:	4c2d3630 	stcmi	6, cr3, [sp], #-192	; 0xffffff40
      2c:	745f4445 	ldrbvc	r4, [pc], #-1093	; 34 <_start-0x7fcc>
      30:	6c67676f 	stclvs	7, cr6, [r7], #-444	; 0xfffffe44
      34:	656b2f65 	strbvs	r2, [fp, #-3941]!	; 0xfffff09b
      38:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
      3c:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
      40:	7878632f 	ldmdavc	r8!, {r0, r1, r2, r3, r5, r8, r9, sp, lr}^
      44:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
      48:	6f682f00 	svcvs	0x00682f00
      4c:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
      50:	61686c69 	cmnvs	r8, r9, ror #24
      54:	2f6a7976 	svccs	0x006a7976
      58:	6f686353 	svcvs	0x00686353
      5c:	5a2f6c6f 	bpl	bdb220 <_bss_end+0xbd29e0>
      60:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; fffffed4 <_bss_end+0xffff7694>
      64:	2f657461 	svccs	0x00657461
      68:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
      6c:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
      70:	2d36302f 	ldccs	0, cr3, [r6, #-188]!	; 0xffffff44
      74:	5f44454c 	svcpl	0x0044454c
      78:	67676f74 			; <UNDEFINED> instruction: 0x67676f74
      7c:	622f656c 	eorvs	r6, pc, #108, 10	; 0x1b000000
      80:	646c6975 	strbtvs	r6, [ip], #-2421	; 0xfffff68b
      84:	554e4700 	strbpl	r4, [lr, #-1792]	; 0xfffff900
      88:	2b2b4320 	blcs	ad0d10 <_bss_end+0xac84d0>
      8c:	39203431 	stmdbcc	r0!, {r0, r4, r5, sl, ip, sp}
      90:	312e322e 			; <UNDEFINED> instruction: 0x312e322e
      94:	31303220 	teqcc	r0, r0, lsr #4
      98:	32303139 	eorscc	r3, r0, #1073741838	; 0x4000000e
      9c:	72282035 	eorvc	r2, r8, #53	; 0x35
      a0:	61656c65 	cmnvs	r5, r5, ror #24
      a4:	20296573 	eorcs	r6, r9, r3, ror r5
      a8:	4d52415b 	ldfmie	f4, [r2, #-364]	; 0xfffffe94
      ac:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
      b0:	622d392d 	eorvs	r3, sp, #737280	; 0xb4000
      b4:	636e6172 	cmnvs	lr, #-2147483620	; 0x8000001c
      b8:	65722068 	ldrbvs	r2, [r2, #-104]!	; 0xffffff98
      bc:	69736976 	ldmdbvs	r3!, {r1, r2, r4, r5, r6, r8, fp, sp, lr}^
      c0:	32206e6f 	eorcc	r6, r0, #1776	; 0x6f0
      c4:	39353737 	ldmdbcc	r5!, {r0, r1, r2, r4, r5, r8, r9, sl, ip, sp}
      c8:	2d205d39 	stccs	13, cr5, [r0, #-228]!	; 0xffffff1c
      cc:	6f6c666d 	svcvs	0x006c666d
      d0:	612d7461 			; <UNDEFINED> instruction: 0x612d7461
      d4:	683d6962 	ldmdavs	sp!, {r1, r5, r6, r8, fp, sp, lr}
      d8:	20647261 	rsbcs	r7, r4, r1, ror #4
      dc:	70666d2d 	rsbvc	r6, r6, sp, lsr #26
      e0:	66763d75 			; <UNDEFINED> instruction: 0x66763d75
      e4:	6d2d2070 	stcvs	0, cr2, [sp, #-448]!	; 0xfffffe40
      e8:	616f6c66 	cmnvs	pc, r6, ror #24
      ec:	62612d74 	rsbvs	r2, r1, #116, 26	; 0x1d00
      f0:	61683d69 	cmnvs	r8, r9, ror #26
      f4:	2d206472 	cfstrscs	mvf6, [r0, #-456]!	; 0xfffffe38
      f8:	7570666d 	ldrbvc	r6, [r0, #-1645]!	; 0xfffff993
      fc:	7066763d 	rsbvc	r7, r6, sp, lsr r6
     100:	746d2d20 	strbtvc	r2, [sp], #-3360	; 0xfffff2e0
     104:	3d656e75 	stclcc	14, cr6, [r5, #-468]!	; 0xfffffe2c
     108:	316d7261 	cmncc	sp, r1, ror #4
     10c:	6a363731 	bvs	d8ddd8 <_bss_end+0xd85598>
     110:	732d667a 			; <UNDEFINED> instruction: 0x732d667a
     114:	616d2d20 	cmnvs	sp, r0, lsr #26
     118:	2d206d72 	stccs	13, cr6, [r0, #-456]!	; 0xfffffe38
     11c:	6372616d 	cmnvs	r2, #1073741851	; 0x4000001b
     120:	72613d68 	rsbvc	r3, r1, #104, 26	; 0x1a00
     124:	7a36766d 	bvc	d9dae0 <_bss_end+0xd952a0>
     128:	70662b6b 	rsbvc	r2, r6, fp, ror #22
     12c:	20672d20 	rsbcs	r2, r7, r0, lsr #26
     130:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
     134:	2d20304f 	stccs	0, cr3, [r0, #-316]!	; 0xfffffec4
     138:	5f00304f 	svcpl	0x0000304f
     13c:	6178635f 	cmnvs	r8, pc, asr r3
     140:	6175675f 	cmnvs	r5, pc, asr r7
     144:	725f6472 	subsvc	r6, pc, #1912602624	; 0x72000000
     148:	61656c65 	cmnvs	r5, r5, ror #24
     14c:	5f006573 	svcpl	0x00006573
     150:	6178635f 	cmnvs	r8, pc, asr r3
     154:	6175675f 	cmnvs	r5, pc, asr r7
     158:	615f6472 	cmpvs	pc, r2, ror r4	; <UNPREDICTABLE>
     15c:	74726f62 	ldrbtvc	r6, [r2], #-3938	; 0xfffff09e
     160:	645f5f00 	ldrbvs	r5, [pc], #-3840	; 168 <_start-0x7e98>
     164:	685f6f73 	ldmdavs	pc, {r0, r1, r4, r5, r6, r8, r9, sl, fp, sp, lr}^	; <UNPREDICTABLE>
     168:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     16c:	5f5f0065 	svcpl	0x005f0065
     170:	5f617863 	svcpl	0x00617863
     174:	78657461 	stmdavc	r5!, {r0, r5, r6, sl, ip, sp, lr}^
     178:	5f007469 	svcpl	0x00007469
     17c:	6178635f 	cmnvs	r8, pc, asr r3
     180:	6175675f 	cmnvs	r5, pc, asr r7
     184:	615f6472 	cmpvs	pc, r2, ror r4	; <UNPREDICTABLE>
     188:	69757163 	ldmdbvs	r5!, {r0, r1, r5, r6, r8, ip, sp, lr}^
     18c:	5f006572 	svcpl	0x00006572
     190:	7878635f 	ldmdavc	r8!, {r0, r1, r2, r3, r4, r6, r8, r9, sp, lr}^
     194:	76696261 	strbtvc	r6, [r9], -r1, ror #4
     198:	5f5f0031 	svcpl	0x005f0031
     19c:	5f617863 	svcpl	0x00617863
     1a0:	65727570 	ldrbvs	r7, [r2, #-1392]!	; 0xfffffa90
     1a4:	7269765f 	rsbvc	r7, r9, #99614720	; 0x5f00000
     1a8:	6c617574 	cfstr64vs	mvdx7, [r1], #-464	; 0xfffffe30
     1ac:	615f5f00 	cmpvs	pc, r0, lsl #30
     1b0:	69626165 	stmdbvs	r2!, {r0, r2, r5, r6, r8, sp, lr}^
     1b4:	776e755f 			; <UNDEFINED> instruction: 0x776e755f
     1b8:	5f646e69 	svcpl	0x00646e69
     1bc:	5f707063 	svcpl	0x00707063
     1c0:	00317270 	eorseq	r7, r1, r0, ror r2
     1c4:	75675f5f 	strbvc	r5, [r7, #-3935]!	; 0xfffff0a1
     1c8:	00647261 	rsbeq	r7, r4, r1, ror #4
     1cc:	676e6f6c 	strbvs	r6, [lr, -ip, ror #30]!
     1d0:	6e6f6c20 	cdpvs	12, 6, cr6, cr15, cr0, {1}
     1d4:	6e692067 	cdpvs	0, 6, cr2, cr9, cr7, {3}
     1d8:	50470074 	subpl	r0, r7, r4, ror r0
     1dc:	304e4552 	subcc	r4, lr, r2, asr r5
     1e0:	52504700 	subspl	r4, r0, #0, 14
     1e4:	00314e45 	eorseq	r4, r1, r5, asr #28
     1e8:	46415047 	strbmi	r5, [r1], -r7, asr #32
     1ec:	00314e45 	eorseq	r4, r1, r5, asr #28
     1f0:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     1f4:	61485f4f 	cmpvs	r8, pc, asr #30
     1f8:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     1fc:	65530072 	ldrbvs	r0, [r3, #-114]	; 0xffffff8e
     200:	754f5f74 	strbvc	r5, [pc, #-3956]	; fffff294 <_bss_end+0xffff6a54>
     204:	74757074 	ldrbtvc	r7, [r5], #-116	; 0xffffff8c
     208:	6f682f00 	svcvs	0x00682f00
     20c:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
     210:	61686c69 	cmnvs	r8, r9, ror #24
     214:	2f6a7976 	svccs	0x006a7976
     218:	6f686353 	svcvs	0x00686353
     21c:	5a2f6c6f 	bpl	bdb3e0 <_bss_end+0xbd2ba0>
     220:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 94 <_start-0x7f6c>
     224:	2f657461 	svccs	0x00657461
     228:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
     22c:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
     230:	2d36302f 	ldccs	0, cr3, [r6, #-188]!	; 0xffffff44
     234:	5f44454c 	svcpl	0x0044454c
     238:	67676f74 			; <UNDEFINED> instruction: 0x67676f74
     23c:	6b2f656c 	blvs	bd97f4 <_bss_end+0xbd0fb4>
     240:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
     244:	72732f6c 	rsbsvc	r2, r3, #108, 30	; 0x1b0
     248:	72642f63 	rsbvc	r2, r4, #396	; 0x18c
     24c:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
     250:	70672f73 	rsbvc	r2, r7, r3, ror pc
     254:	632e6f69 			; <UNDEFINED> instruction: 0x632e6f69
     258:	55007070 	strpl	r7, [r0, #-112]	; 0xffffff90
     25c:	6570736e 	ldrbvs	r7, [r0, #-878]!	; 0xfffffc92
     260:	69666963 	stmdbvs	r6!, {r0, r1, r5, r6, r8, fp, sp, lr}^
     264:	67006465 	strvs	r6, [r0, -r5, ror #8]
     268:	5f6f6970 	svcpl	0x006f6970
     26c:	65736162 	ldrbvs	r6, [r3, #-354]!	; 0xfffffe9e
     270:	6464615f 	strbtvs	r6, [r4], #-351	; 0xfffffea1
     274:	5a5f0072 	bpl	17c0444 <_bss_end+0x17b7c04>
     278:	33314b4e 	teqcc	r1, #79872	; 0x13800
     27c:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     280:	61485f4f 	cmpvs	r8, pc, asr #30
     284:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     288:	47383172 			; <UNDEFINED> instruction: 0x47383172
     28c:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     290:	56454c50 			; <UNDEFINED> instruction: 0x56454c50
     294:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     298:	6f697461 	svcvs	0x00697461
     29c:	526a456e 	rsbpl	r4, sl, #461373440	; 0x1b800000
     2a0:	5f30536a 	svcpl	0x0030536a
     2a4:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     2a8:	4950475f 	ldmdbmi	r0, {r0, r1, r2, r3, r4, r6, r8, r9, sl, lr}^
     2ac:	75465f4f 	strbvc	r5, [r6, #-3919]	; 0xfffff0b1
     2b0:	6974636e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, r9, sp, lr}^
     2b4:	5f006e6f 	svcpl	0x00006e6f
     2b8:	314b4e5a 	cmpcc	fp, sl, asr lr
     2bc:	50474333 	subpl	r4, r7, r3, lsr r3
     2c0:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     2c4:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     2c8:	38317265 	ldmdacc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     2cc:	5f746547 	svcpl	0x00746547
     2d0:	45535047 	ldrbmi	r5, [r3, #-71]	; 0xffffffb9
     2d4:	6f4c5f54 	svcvs	0x004c5f54
     2d8:	69746163 	ldmdbvs	r4!, {r0, r1, r5, r6, r8, sp, lr}^
     2dc:	6a456e6f 	bvs	115bca0 <_bss_end+0x1153460>
     2e0:	30536a52 	subscc	r6, r3, r2, asr sl
     2e4:	5a5f005f 	bpl	17c0468 <_bss_end+0x17b7c28>
     2e8:	33314b4e 	teqcc	r1, #79872	; 0x13800
     2ec:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     2f0:	61485f4f 	cmpvs	r8, pc, asr #30
     2f4:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     2f8:	47383172 			; <UNDEFINED> instruction: 0x47383172
     2fc:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     300:	524c4350 	subpl	r4, ip, #80, 6	; 0x40000001
     304:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     308:	6f697461 	svcvs	0x00697461
     30c:	526a456e 	rsbpl	r4, sl, #461373440	; 0x1b800000
     310:	5f30536a 	svcpl	0x0030536a
     314:	43504700 	cmpmi	r0, #0, 14
     318:	0031524c 	eorseq	r5, r1, ip, asr #4
     31c:	4f4c475f 	svcmi	0x004c475f
     320:	5f4c4142 	svcpl	0x004c4142
     324:	6275735f 	rsbsvs	r7, r5, #2080374785	; 0x7c000001
     328:	735f495f 	cmpvc	pc, #1556480	; 0x17c000
     32c:	4f495047 	svcmi	0x00495047
     330:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     334:	4650475f 			; <UNDEFINED> instruction: 0x4650475f
     338:	5f4c4553 	svcpl	0x004c4553
     33c:	61636f4c 	cmnvs	r3, ip, asr #30
     340:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
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
     374:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     378:	5350475f 	cmppl	r0, #24903680	; 0x17c0000
     37c:	4c5f5445 	cfldrdmi	mvd5, [pc], {69}	; 0x45
     380:	7461636f 	strbtvc	r6, [r1], #-879	; 0xfffffc91
     384:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     388:	55505047 	ldrbpl	r5, [r0, #-71]	; 0xffffffb9
     38c:	4b4c4344 	blmi	13110a4 <_bss_end+0x1308864>
     390:	50470030 	subpl	r0, r7, r0, lsr r0
     394:	525f4f49 	subspl	r4, pc, #292	; 0x124
     398:	47006765 	strmi	r6, [r0, -r5, ror #14]
     39c:	56454c50 			; <UNDEFINED> instruction: 0x56454c50
     3a0:	50470030 	subpl	r0, r7, r0, lsr r0
     3a4:	3156454c 	cmpcc	r6, ip, asr #10
     3a8:	746c4100 	strbtvc	r4, [ip], #-256	; 0xffffff00
     3ac:	4100335f 	tstmi	r0, pc, asr r3
     3b0:	315f746c 	cmpcc	pc, ip, ror #8
     3b4:	50504700 	subspl	r4, r0, r0, lsl #14
     3b8:	75004455 	strvc	r4, [r0, #-1109]	; 0xfffffbab
     3bc:	6769736e 	strbvs	r7, [r9, -lr, ror #6]!
     3c0:	2064656e 	rsbcs	r6, r4, lr, ror #10
     3c4:	72616863 	rsbvc	r6, r1, #6488064	; 0x630000
     3c8:	746c4100 	strbtvc	r4, [ip], #-256	; 0xffffff00
     3cc:	4100325f 	tstmi	r0, pc, asr r2
     3d0:	305f746c 	subscc	r7, pc, ip, ror #8
     3d4:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     3d8:	4350475f 	cmpmi	r0, #24903680	; 0x17c0000
     3dc:	4c5f524c 	lfmmi	f5, 2, [pc], {76}	; 0x4c
     3e0:	7461636f 	strbtvc	r6, [r1], #-879	; 0xfffffc91
     3e4:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     3e8:	55505047 	ldrbpl	r5, [r0, #-71]	; 0xffffffb9
     3ec:	4b4c4344 	blmi	1311104 <_bss_end+0x13088c4>
     3f0:	50470031 	subpl	r0, r7, r1, lsr r0
     3f4:	30524c43 	subscc	r4, r2, r3, asr #24
     3f8:	6f687300 	svcvs	0x00687300
     3fc:	75207472 	strvc	r7, [r0, #-1138]!	; 0xfffffb8e
     400:	6769736e 	strbvs	r7, [r9, -lr, ror #6]!
     404:	2064656e 	rsbcs	r6, r4, lr, ror #10
     408:	00746e69 	rsbseq	r6, r4, r9, ror #28
     40c:	4f495047 	svcmi	0x00495047
     410:	6e69505f 	mcrvs	0, 3, r5, cr9, cr15, {2}
     414:	756f435f 	strbvc	r4, [pc, #-863]!	; bd <_start-0x7f43>
     418:	4700746e 	strmi	r7, [r0, -lr, ror #8]
     41c:	54455350 	strbpl	r5, [r5], #-848	; 0xfffffcb0
     420:	50470030 	subpl	r0, r7, r0, lsr r0
     424:	31544553 	cmpcc	r4, r3, asr r5
     428:	746c4100 	strbtvc	r4, [ip], #-256	; 0xffffff00
     42c:	4100345f 	tstmi	r0, pc, asr r4
     430:	355f746c 	ldrbcc	r7, [pc, #-1132]	; ffffffcc <_bss_end+0xffff778c>
     434:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     438:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     43c:	5f4f4950 	svcpl	0x004f4950
     440:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     444:	3172656c 	cmncc	r2, ip, ror #10
     448:	74655330 	strbtvc	r5, [r5], #-816	; 0xfffffcd0
     44c:	74754f5f 	ldrbtvc	r4, [r5], #-3935	; 0xfffff0a1
     450:	45747570 	ldrbmi	r7, [r4, #-1392]!	; 0xfffffa90
     454:	5300626a 	movwpl	r6, #618	; 0x26a
     458:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     45c:	5f4f4950 	svcpl	0x004f4950
     460:	636e7546 	cmnvs	lr, #293601280	; 0x11800000
     464:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     468:	46504700 	ldrbmi	r4, [r0], -r0, lsl #14
     46c:	00304e45 	eorseq	r4, r0, r5, asr #28
     470:	45465047 	strbmi	r5, [r6, #-71]	; 0xffffffb9
     474:	6600314e 	strvs	r3, [r0], -lr, asr #2
     478:	00636e75 	rsbeq	r6, r3, r5, ror lr
     47c:	53465047 	movtpl	r5, #24647	; 0x6047
     480:	00344c45 	eorseq	r4, r4, r5, asr #24
     484:	69726550 	ldmdbvs	r2!, {r4, r6, r8, sl, sp, lr}^
     488:	72656870 	rsbvc	r6, r5, #112, 16	; 0x700000
     48c:	425f6c61 	subsmi	r6, pc, #24832	; 0x6100
     490:	00657361 	rsbeq	r7, r5, r1, ror #6
     494:	75706e49 	ldrbvc	r6, [r0, #-3657]!	; 0xfffff1b7
     498:	5f5f0074 	svcpl	0x005f0074
     49c:	6f697270 	svcvs	0x00697270
     4a0:	79746972 	ldmdbvc	r4!, {r1, r4, r5, r6, r8, fp, sp, lr}^
     4a4:	45504700 	ldrbmi	r4, [r0, #-1792]	; 0xfffff900
     4a8:	00305344 	eorseq	r5, r0, r4, asr #6
     4ac:	44455047 	strbmi	r5, [r5], #-71	; 0xffffffb9
     4b0:	47003153 	smlsdmi	r0, r3, r1, r3
     4b4:	45524150 	ldrbmi	r4, [r2, #-336]	; 0xfffffeb0
     4b8:	4700304e 	strmi	r3, [r0, -lr, asr #32]
     4bc:	45524150 	ldrbmi	r4, [r2, #-336]	; 0xfffffeb0
     4c0:	7500314e 	strvc	r3, [r0, #-334]	; 0xfffffeb2
     4c4:	38746e69 	ldmdacc	r4!, {r0, r3, r5, r6, r9, sl, fp, sp, lr}^
     4c8:	7400745f 	strvc	r7, [r0], #-1119	; 0xfffffba1
     4cc:	00736968 	rsbseq	r6, r3, r8, ror #18
     4d0:	4b4e5a5f 	blmi	1396e54 <_bss_end+0x138e614>
     4d4:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     4d8:	5f4f4950 	svcpl	0x004f4950
     4dc:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     4e0:	3172656c 	cmncc	r2, ip, ror #10
     4e4:	74654737 	strbtvc	r4, [r5], #-1847	; 0xfffff8c9
     4e8:	4950475f 	ldmdbmi	r0, {r0, r1, r2, r3, r4, r6, r8, r9, sl, lr}^
     4ec:	75465f4f 	strbvc	r5, [r6, #-3919]	; 0xfffff0b1
     4f0:	6974636e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, r9, sp, lr}^
     4f4:	6a456e6f 	bvs	115beb8 <_bss_end+0x1153678>
     4f8:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     4fc:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     500:	5f4f4950 	svcpl	0x004f4950
     504:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     508:	3172656c 	cmncc	r2, ip, ror #10
     50c:	74655337 	strbtvc	r5, [r5], #-823	; 0xfffffcc9
     510:	4950475f 	ldmdbmi	r0, {r0, r1, r2, r3, r4, r6, r8, r9, sl, lr}^
     514:	75465f4f 	strbvc	r5, [r6, #-3919]	; 0xfffff0b1
     518:	6974636e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, r9, sp, lr}^
     51c:	6a456e6f 	bvs	115bee0 <_bss_end+0x11536a0>
     520:	474e3431 	smlaldxmi	r3, lr, r1, r4
     524:	5f4f4950 	svcpl	0x004f4950
     528:	636e7546 	cmnvs	lr, #293601280	; 0x11800000
     52c:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     530:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     534:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     538:	5f4f4950 	svcpl	0x004f4950
     53c:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     540:	4372656c 	cmnmi	r2, #108, 10	; 0x1b000000
     544:	006a4532 	rsbeq	r4, sl, r2, lsr r5
     548:	4950476d 	ldmdbmi	r0, {r0, r2, r3, r5, r6, r8, r9, sl, lr}^
     54c:	5047004f 	subpl	r0, r7, pc, asr #32
     550:	4e454641 	cdpmi	6, 4, cr4, cr5, cr1, {2}
     554:	50470030 	subpl	r0, r7, r0, lsr r0
     558:	304e454c 	subcc	r4, lr, ip, asr #10
     55c:	4c504700 	mrrcmi	7, 0, r4, r0, cr0
     560:	00314e45 	eorseq	r4, r1, r5, asr #28
     564:	5f746962 	svcpl	0x00746962
     568:	00786469 	rsbseq	r6, r8, r9, ror #8
     56c:	726f6873 	rsbvc	r6, pc, #7536640	; 0x730000
     570:	6e692074 	mcrvs	0, 3, r2, cr9, cr4, {3}
     574:	69750074 	ldmdbvs	r5!, {r2, r4, r5, r6}^
     578:	3233746e 	eorscc	r7, r3, #1845493760	; 0x6e000000
     57c:	6200745f 	andvs	r7, r0, #1593835520	; 0x5f000000
     580:	006c6f6f 	rsbeq	r6, ip, pc, ror #30
     584:	45485047 	strbmi	r5, [r8, #-71]	; 0xffffffb9
     588:	4700304e 	strmi	r3, [r0, -lr, asr #32]
     58c:	4e454850 	mcrmi	8, 2, r4, cr5, cr0, {2}
     590:	5f5f0031 	svcpl	0x005f0031
     594:	74696e69 	strbtvc	r6, [r9], #-3689	; 0xfffff197
     598:	696c6169 	stmdbvs	ip!, {r0, r3, r5, r6, r8, sp, lr}^
     59c:	705f657a 	subsvc	r6, pc, sl, ror r5	; <UNPREDICTABLE>
     5a0:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     5a4:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     5a8:	5f4f4950 	svcpl	0x004f4950
     5ac:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     5b0:	4372656c 	cmnmi	r2, #108, 10	; 0x1b000000
     5b4:	006a4534 	rsbeq	r4, sl, r4, lsr r5
     5b8:	5f746547 	svcpl	0x00746547
     5bc:	454c5047 	strbmi	r5, [ip, #-71]	; 0xffffffb9
     5c0:	6f4c5f56 	svcvs	0x004c5f56
     5c4:	69746163 	ldmdbvs	r4!, {r0, r1, r5, r6, r8, sp, lr}^
     5c8:	5f006e6f 	svcpl	0x00006e6f
     5cc:	6174735f 	cmnvs	r4, pc, asr r3
     5d0:	5f636974 	svcpl	0x00636974
     5d4:	74696e69 	strbtvc	r6, [r9], #-3689	; 0xfffff197
     5d8:	696c6169 	stmdbvs	ip!, {r0, r3, r5, r6, r8, sp, lr}^
     5dc:	6974617a 	ldmdbvs	r4!, {r1, r3, r4, r5, r6, r8, sp, lr}^
     5e0:	615f6e6f 	cmpvs	pc, pc, ror #28
     5e4:	645f646e 	ldrbvs	r6, [pc], #-1134	; 5ec <_start-0x7a14>
     5e8:	72747365 	rsbsvc	r7, r4, #-1811939327	; 0x94000001
     5ec:	69746375 	ldmdbvs	r4!, {r0, r2, r4, r5, r6, r8, r9, sp, lr}^
     5f0:	305f6e6f 	subscc	r6, pc, pc, ror #28
     5f4:	46504700 	ldrbmi	r4, [r0], -r0, lsl #14
     5f8:	304c4553 	subcc	r4, ip, r3, asr r5
     5fc:	46504700 	ldrbmi	r4, [r0], -r0, lsl #14
     600:	314c4553 	cmpcc	ip, r3, asr r5
     604:	46504700 	ldrbmi	r4, [r0], -r0, lsl #14
     608:	324c4553 	subcc	r4, ip, #348127232	; 0x14c00000
     60c:	46504700 	ldrbmi	r4, [r0], -r0, lsl #14
     610:	334c4553 	movtcc	r4, #50515	; 0xc553
     614:	49504700 	ldmdbmi	r0, {r8, r9, sl, lr}^
     618:	61425f4f 	cmpvs	r2, pc, asr #30
     61c:	47006573 	smlsdxmi	r0, r3, r5, r6
     620:	45534650 	ldrbmi	r4, [r3, #-1616]	; 0xfffff9b0
     624:	2f00354c 	svccs	0x0000354c
     628:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     62c:	6c69732f 	stclvs	3, cr7, [r9], #-188	; 0xffffff44
     630:	79766168 	ldmdbvc	r6!, {r3, r5, r6, r8, sp, lr}^
     634:	63532f6a 	cmpvs	r3, #424	; 0x1a8
     638:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; 4a0 <_start-0x7b60>
     63c:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
     640:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
     644:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
     648:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
     64c:	302f7365 	eorcc	r7, pc, r5, ror #6
     650:	454c2d36 	strbmi	r2, [ip, #-3382]	; 0xfffff2ca
     654:	6f745f44 	svcvs	0x00745f44
     658:	656c6767 	strbvs	r6, [ip, #-1895]!	; 0xfffff899
     65c:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
     660:	2f6c656e 	svccs	0x006c656e
     664:	2f637273 	svccs	0x00637273
     668:	6e69616d 	powvsez	f6, f1, #5.0
     66c:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
     670:	54434100 	strbpl	r4, [r3], #-256	; 0xffffff00
     674:	6e69505f 	mcrvs	0, 3, r5, cr9, cr15, {2}
     678:	656b5f00 	strbvs	r5, [fp, #-3840]!	; 0xfffff100
     67c:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
     680:	69616d5f 	stmdbvs	r1!, {r0, r1, r2, r3, r4, r6, r8, sl, fp, sp, lr}^
     684:	682f006e 	stmdavs	pc!, {r1, r2, r3, r5, r6}	; <UNPREDICTABLE>
     688:	2f656d6f 	svccs	0x00656d6f
     68c:	686c6973 	stmdavs	ip!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
     690:	6a797661 	bvs	1e5e01c <_bss_end+0x1e557dc>
     694:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
     698:	2f6c6f6f 	svccs	0x006c6f6f
     69c:	6f72655a 	svcvs	0x0072655a
     6a0:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
     6a4:	6178652f 	cmnvs	r8, pc, lsr #10
     6a8:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
     6ac:	36302f73 	shsub16cc	r2, r0, r3
     6b0:	44454c2d 	strbmi	r4, [r5], #-3117	; 0xfffff3d3
     6b4:	676f745f 			; <UNDEFINED> instruction: 0x676f745f
     6b8:	2f656c67 	svccs	0x00656c67
     6bc:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
     6c0:	732f6c65 			; <UNDEFINED> instruction: 0x732f6c65
     6c4:	732f6372 			; <UNDEFINED> instruction: 0x732f6372
     6c8:	74726174 	ldrbtvc	r6, [r2], #-372	; 0xfffffe8c
     6cc:	4700732e 	strmi	r7, [r0, -lr, lsr #6]
     6d0:	4120554e 			; <UNDEFINED> instruction: 0x4120554e
     6d4:	2e322053 	mrccs	0, 1, r2, cr2, cr3, {2}
     6d8:	5f003433 	svcpl	0x00003433
     6dc:	5f737362 	svcpl	0x00737362
     6e0:	72617473 	rsbvc	r7, r1, #1929379840	; 0x73000000
     6e4:	5f5f0074 	svcpl	0x005f0074
     6e8:	524f5443 	subpl	r5, pc, #1124073472	; 0x43000000
     6ec:	444e455f 	strbmi	r4, [lr], #-1375	; 0xfffffaa1
     6f0:	5f005f5f 	svcpl	0x00005f5f
     6f4:	4f54435f 	svcmi	0x0054435f
     6f8:	494c5f52 	stmdbmi	ip, {r1, r4, r6, r8, r9, sl, fp, ip, lr}^
     6fc:	5f5f5453 	svcpl	0x005f5453
     700:	445f5f00 	ldrbmi	r5, [pc], #-3840	; 708 <_start-0x78f8>
     704:	5f524f54 	svcpl	0x00524f54
     708:	5f444e45 	svcpl	0x00444e45
     70c:	635f005f 	cmpvs	pc, #95	; 0x5f
     710:	735f7070 	cmpvc	pc, #112	; 0x70
     714:	64747568 	ldrbtvs	r7, [r4], #-1384	; 0xfffffa98
     718:	006e776f 	rsbeq	r7, lr, pc, ror #14
     71c:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 668 <_start-0x7998>
     720:	69732f65 	ldmdbvs	r3!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
     724:	7661686c 	strbtvc	r6, [r1], -ip, ror #16
     728:	532f6a79 			; <UNDEFINED> instruction: 0x532f6a79
     72c:	6f6f6863 	svcvs	0x006f6863
     730:	655a2f6c 	ldrbvs	r2, [sl, #-3948]	; 0xfffff094
     734:	614d6f72 	hvcvs	55026	; 0xd6f2
     738:	652f6574 	strvs	r6, [pc, #-1396]!	; 1cc <_start-0x7e34>
     73c:	706d6178 	rsbvc	r6, sp, r8, ror r1
     740:	2f73656c 	svccs	0x0073656c
     744:	4c2d3630 	stcmi	6, cr3, [sp], #-192	; 0xffffff40
     748:	745f4445 	ldrbvc	r4, [pc], #-1093	; 750 <_start-0x78b0>
     74c:	6c67676f 	stclvs	7, cr6, [r7], #-444	; 0xfffffe44
     750:	656b2f65 	strbvs	r2, [fp, #-3941]!	; 0xfffff09b
     754:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
     758:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
     75c:	6174732f 	cmnvs	r4, pc, lsr #6
     760:	70757472 	rsbsvc	r7, r5, r2, ror r4
     764:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
     768:	73625f00 	cmnvc	r2, #0, 30
     76c:	6e655f73 	mcrvs	15, 3, r5, cr5, cr3, {3}
     770:	5f5f0064 	svcpl	0x005f0064
     774:	524f5444 	subpl	r5, pc, #68, 8	; 0x44000000
     778:	53494c5f 	movtpl	r4, #40031	; 0x9c5f
     77c:	005f5f54 	subseq	r5, pc, r4, asr pc	; <UNPREDICTABLE>
     780:	726f7464 	rsbvc	r7, pc, #100, 8	; 0x64000000
     784:	7274705f 	rsbsvc	r7, r4, #95	; 0x5f
     788:	6f746300 	svcvs	0x00746300
     78c:	74705f72 	ldrbtvc	r5, [r0], #-3954	; 0xfffff08e
     790:	635f0072 	cmpvs	pc, #114	; 0x72
     794:	6174735f 	cmnvs	r4, pc, asr r3
     798:	70757472 	rsbsvc	r7, r5, r2, ror r4
     79c:	70635f00 	rsbvc	r5, r3, r0, lsl #30
     7a0:	74735f70 	ldrbtvc	r5, [r3], #-3952	; 0xfffff090
     7a4:	75747261 	ldrbvc	r7, [r4, #-609]!	; 0xfffffd9f
     7a8:	6e660070 	mcrvs	0, 3, r0, cr6, cr0, {3}
     7ac:	00727470 	rsbseq	r7, r2, r0, ror r4
     7b0:	47524154 			; <UNDEFINED> instruction: 0x47524154
     7b4:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
     7b8:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
     7bc:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
     7c0:	37316178 			; <UNDEFINED> instruction: 0x37316178
     7c4:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
     7c8:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
     7cc:	61736900 	cmnvs	r3, r0, lsl #18
     7d0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
     7d4:	5f70665f 	svcpl	0x0070665f
     7d8:	006c6264 	rsbeq	r6, ip, r4, ror #4
     7dc:	5f6d7261 	svcpl	0x006d7261
     7e0:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
     7e4:	6d77695f 			; <UNDEFINED> instruction: 0x6d77695f
     7e8:	0074786d 	rsbseq	r7, r4, sp, ror #16
     7ec:	47524154 			; <UNDEFINED> instruction: 0x47524154
     7f0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
     7f4:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
     7f8:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
     7fc:	33326d78 	teqcc	r2, #120, 26	; 0x1e00
     800:	4d524100 	ldfmie	f4, [r2, #-0]
     804:	0051455f 	subseq	r4, r1, pc, asr r5
     808:	47524154 			; <UNDEFINED> instruction: 0x47524154
     80c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
     810:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
     814:	31316d72 	teqcc	r1, r2, ror sp
     818:	32743635 	rsbscc	r3, r4, #55574528	; 0x3500000
     81c:	69007366 	stmdbvs	r0, {r1, r2, r5, r6, r8, r9, ip, sp, lr}
     820:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
     824:	745f7469 	ldrbvc	r7, [pc], #-1129	; 82c <_start-0x77d4>
     828:	626d7568 	rsbvs	r7, sp, #104, 10	; 0x1a000000
     82c:	52415400 	subpl	r5, r1, #0, 8
     830:	5f544547 	svcpl	0x00544547
     834:	5f555043 	svcpl	0x00555043
     838:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
     83c:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
     840:	726f6337 	rsbvc	r6, pc, #-603979776	; 0xdc000000
     844:	61786574 	cmnvs	r8, r4, ror r5
     848:	42003335 	andmi	r3, r0, #-738197504	; 0xd4000000
     84c:	5f455341 	svcpl	0x00455341
     850:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
     854:	5f4d385f 	svcpl	0x004d385f
     858:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
     85c:	52415400 	subpl	r5, r1, #0, 8
     860:	5f544547 	svcpl	0x00544547
     864:	5f555043 	svcpl	0x00555043
     868:	386d7261 	stmdacc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
     86c:	54003031 	strpl	r3, [r0], #-49	; 0xffffffcf
     870:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
     874:	50435f54 	subpl	r5, r3, r4, asr pc
     878:	67785f55 			; <UNDEFINED> instruction: 0x67785f55
     87c:	31656e65 	cmncc	r5, r5, ror #28
     880:	4d524100 	ldfmie	f4, [r2, #-0]
     884:	5343505f 	movtpl	r5, #12383	; 0x305f
     888:	5041415f 	subpl	r4, r1, pc, asr r1
     88c:	495f5343 	ldmdbmi	pc, {r0, r1, r6, r8, r9, ip, lr}^	; <UNPREDICTABLE>
     890:	584d4d57 	stmdapl	sp, {r0, r1, r2, r4, r6, r8, sl, fp, lr}^
     894:	41420054 	qdaddmi	r0, r4, r2
     898:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
     89c:	5f484352 	svcpl	0x00484352
     8a0:	41420030 	cmpmi	r2, r0, lsr r0
     8a4:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
     8a8:	5f484352 	svcpl	0x00484352
     8ac:	41420032 	cmpmi	r2, r2, lsr r0
     8b0:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
     8b4:	5f484352 	svcpl	0x00484352
     8b8:	41420033 	cmpmi	r2, r3, lsr r0
     8bc:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
     8c0:	5f484352 	svcpl	0x00484352
     8c4:	41420034 	cmpmi	r2, r4, lsr r0
     8c8:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
     8cc:	5f484352 	svcpl	0x00484352
     8d0:	41420036 	cmpmi	r2, r6, lsr r0
     8d4:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
     8d8:	5f484352 	svcpl	0x00484352
     8dc:	41540037 	cmpmi	r4, r7, lsr r0
     8e0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
     8e4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
     8e8:	6373785f 	cmnvs	r3, #6225920	; 0x5f0000
     8ec:	00656c61 	rsbeq	r6, r5, r1, ror #24
     8f0:	5f617369 	svcpl	0x00617369
     8f4:	5f746962 	svcpl	0x00746962
     8f8:	64657270 	strbtvs	r7, [r5], #-624	; 0xfffffd90
     8fc:	00736572 	rsbseq	r6, r3, r2, ror r5
     900:	47524154 			; <UNDEFINED> instruction: 0x47524154
     904:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
     908:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
     90c:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
     910:	33336d78 	teqcc	r3, #120, 26	; 0x1e00
     914:	52415400 	subpl	r5, r1, #0, 8
     918:	5f544547 	svcpl	0x00544547
     91c:	5f555043 	svcpl	0x00555043
     920:	376d7261 	strbcc	r7, [sp, -r1, ror #4]!
     924:	696d6474 	stmdbvs	sp!, {r2, r4, r5, r6, sl, sp, lr}^
     928:	61736900 	cmnvs	r3, r0, lsl #18
     92c:	626f6e5f 	rsbvs	r6, pc, #1520	; 0x5f0
     930:	54007469 	strpl	r7, [r0], #-1129	; 0xfffffb97
     934:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
     938:	50435f54 	subpl	r5, r3, r4, asr pc
     93c:	72615f55 	rsbvc	r5, r1, #340	; 0x154
     940:	3731316d 	ldrcc	r3, [r1, -sp, ror #2]!
     944:	667a6a36 			; <UNDEFINED> instruction: 0x667a6a36
     948:	73690073 	cmnvc	r9, #115	; 0x73
     94c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
     950:	66765f74 	uhsub16vs	r5, r6, r4
     954:	00327670 	eorseq	r7, r2, r0, ror r6
     958:	5f4d5241 	svcpl	0x004d5241
     95c:	5f534350 	svcpl	0x00534350
     960:	4e4b4e55 	mcrmi	14, 2, r4, cr11, cr5, {2}
     964:	004e574f 	subeq	r5, lr, pc, asr #14
     968:	47524154 			; <UNDEFINED> instruction: 0x47524154
     96c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
     970:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
     974:	65396d72 	ldrvs	r6, [r9, #-3442]!	; 0xfffff28e
     978:	53414200 	movtpl	r4, #4608	; 0x1200
     97c:	52415f45 	subpl	r5, r1, #276	; 0x114
     980:	355f4843 	ldrbcc	r4, [pc, #-2115]	; 145 <_start-0x7ebb>
     984:	004a4554 	subeq	r4, sl, r4, asr r5
     988:	5f6d7261 	svcpl	0x006d7261
     98c:	73666363 	cmnvc	r6, #-1946157055	; 0x8c000001
     990:	74735f6d 	ldrbtvc	r5, [r3], #-3949	; 0xfffff093
     994:	00657461 	rsbeq	r7, r5, r1, ror #8
     998:	5f6d7261 	svcpl	0x006d7261
     99c:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
     9a0:	00657435 	rsbeq	r7, r5, r5, lsr r4
     9a4:	70736e75 	rsbsvc	r6, r3, r5, ror lr
     9a8:	735f6365 	cmpvc	pc, #-1811939327	; 0x94000001
     9ac:	6e697274 	mcrvs	2, 3, r7, cr9, cr4, {3}
     9b0:	69007367 	stmdbvs	r0, {r0, r1, r2, r5, r6, r8, r9, ip, sp, lr}
     9b4:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
     9b8:	735f7469 	cmpvc	pc, #1761607680	; 0x69000000
     9bc:	5f006365 	svcpl	0x00006365
     9c0:	7a6c635f 	bvc	1b19744 <_bss_end+0x1b10f04>
     9c4:	6261745f 	rsbvs	r7, r1, #1593835520	; 0x5f000000
     9c8:	4d524100 	ldfmie	f4, [r2, #-0]
     9cc:	0043565f 	subeq	r5, r3, pc, asr r6
     9d0:	5f6d7261 	svcpl	0x006d7261
     9d4:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
     9d8:	6373785f 	cmnvs	r3, #6225920	; 0x5f0000
     9dc:	00656c61 	rsbeq	r6, r5, r1, ror #24
     9e0:	5f4d5241 	svcpl	0x004d5241
     9e4:	4100454c 	tstmi	r0, ip, asr #10
     9e8:	565f4d52 			; <UNDEFINED> instruction: 0x565f4d52
     9ec:	52410053 	subpl	r0, r1, #83	; 0x53
     9f0:	45475f4d 	strbmi	r5, [r7, #-3917]	; 0xfffff0b3
     9f4:	6d726100 	ldfvse	f6, [r2, #-0]
     9f8:	6e75745f 	mrcvs	4, 3, r7, cr5, cr15, {2}
     9fc:	74735f65 	ldrbtvc	r5, [r3], #-3941	; 0xfffff09b
     a00:	676e6f72 			; <UNDEFINED> instruction: 0x676e6f72
     a04:	006d7261 	rsbeq	r7, sp, r1, ror #4
     a08:	706d6f63 	rsbvc	r6, sp, r3, ror #30
     a0c:	2078656c 	rsbscs	r6, r8, ip, ror #10
     a10:	616f6c66 	cmnvs	pc, r6, ror #24
     a14:	41540074 	cmpmi	r4, r4, ror r0
     a18:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
     a1c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
     a20:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
     a24:	61786574 	cmnvs	r8, r4, ror r5
     a28:	54003531 	strpl	r3, [r0], #-1329	; 0xfffffacf
     a2c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
     a30:	50435f54 	subpl	r5, r3, r4, asr pc
     a34:	61665f55 	cmnvs	r6, r5, asr pc
     a38:	74363237 	ldrtvc	r3, [r6], #-567	; 0xfffffdc9
     a3c:	41540065 	cmpmi	r4, r5, rrx
     a40:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
     a44:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
     a48:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
     a4c:	61786574 	cmnvs	r8, r4, ror r5
     a50:	41003731 	tstmi	r0, r1, lsr r7
     a54:	475f4d52 			; <UNDEFINED> instruction: 0x475f4d52
     a58:	41540054 	cmpmi	r4, r4, asr r0
     a5c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
     a60:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
     a64:	6f656e5f 	svcvs	0x00656e5f
     a68:	73726576 	cmnvc	r2, #494927872	; 0x1d800000
     a6c:	00316e65 	eorseq	r6, r1, r5, ror #28
     a70:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     a74:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     a78:	2f2e2e2f 	svccs	0x002e2e2f
     a7c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     a80:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
     a84:	63636762 	cmnvs	r3, #25690112	; 0x1880000
     a88:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
     a8c:	32636367 	rsbcc	r6, r3, #-1677721599	; 0x9c000001
     a90:	5400632e 	strpl	r6, [r0], #-814	; 0xfffffcd2
     a94:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
     a98:	50435f54 	subpl	r5, r3, r4, asr pc
     a9c:	6f635f55 	svcvs	0x00635f55
     aa0:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
     aa4:	00663472 	rsbeq	r3, r6, r2, ror r4
     aa8:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
     aac:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
     ab0:	45375f48 	ldrmi	r5, [r7, #-3912]!	; 0xfffff0b8
     ab4:	4154004d 	cmpmi	r4, sp, asr #32
     ab8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
     abc:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
     ac0:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
     ac4:	61786574 	cmnvs	r8, r4, ror r5
     ac8:	68003231 	stmdavs	r0, {r0, r4, r5, r9, ip, sp}
     acc:	76687361 	strbtvc	r7, [r8], -r1, ror #6
     ad0:	745f6c61 	ldrbvc	r6, [pc], #-3169	; ad8 <_start-0x7528>
     ad4:	53414200 	movtpl	r4, #4608	; 0x1200
     ad8:	52415f45 	subpl	r5, r1, #276	; 0x114
     adc:	365f4843 	ldrbcc	r4, [pc], -r3, asr #16
     ae0:	69005a4b 	stmdbvs	r0, {r0, r1, r3, r6, r9, fp, ip, lr}
     ae4:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
     ae8:	00737469 	rsbseq	r7, r3, r9, ror #8
     aec:	5f6d7261 	svcpl	0x006d7261
     af0:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
     af4:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
     af8:	6477685f 	ldrbtvs	r6, [r7], #-2143	; 0xfffff7a1
     afc:	61007669 	tstvs	r0, r9, ror #12
     b00:	665f6d72 			; <UNDEFINED> instruction: 0x665f6d72
     b04:	645f7570 	ldrbvs	r7, [pc], #-1392	; b0c <_start-0x74f4>
     b08:	00637365 	rsbeq	r7, r3, r5, ror #6
     b0c:	5f617369 	svcpl	0x00617369
     b10:	5f746962 	svcpl	0x00746962
     b14:	36317066 	ldrtcc	r7, [r1], -r6, rrx
     b18:	554e4700 	strbpl	r4, [lr, #-1792]	; 0xfffff900
     b1c:	37314320 	ldrcc	r4, [r1, -r0, lsr #6]!
     b20:	322e3920 	eorcc	r3, lr, #32, 18	; 0x80000
     b24:	3220312e 	eorcc	r3, r0, #-2147483637	; 0x8000000b
     b28:	31393130 	teqcc	r9, r0, lsr r1
     b2c:	20353230 	eorscs	r3, r5, r0, lsr r2
     b30:	6c657228 	sfmvs	f7, 2, [r5], #-160	; 0xffffff60
     b34:	65736165 	ldrbvs	r6, [r3, #-357]!	; 0xfffffe9b
     b38:	415b2029 	cmpmi	fp, r9, lsr #32
     b3c:	612f4d52 			; <UNDEFINED> instruction: 0x612f4d52
     b40:	392d6d72 	pushcc	{r1, r4, r5, r6, r8, sl, fp, sp, lr}
     b44:	6172622d 	cmnvs	r2, sp, lsr #4
     b48:	2068636e 	rsbcs	r6, r8, lr, ror #6
     b4c:	69766572 	ldmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
     b50:	6e6f6973 			; <UNDEFINED> instruction: 0x6e6f6973
     b54:	37373220 	ldrcc	r3, [r7, -r0, lsr #4]!
     b58:	5d393935 			; <UNDEFINED> instruction: 0x5d393935
     b5c:	616d2d20 	cmnvs	sp, r0, lsr #26
     b60:	2d206d72 	stccs	13, cr6, [r0, #-456]!	; 0xfffffe38
     b64:	6f6c666d 	svcvs	0x006c666d
     b68:	612d7461 			; <UNDEFINED> instruction: 0x612d7461
     b6c:	683d6962 	ldmdavs	sp!, {r1, r5, r6, r8, fp, sp, lr}
     b70:	20647261 	rsbcs	r7, r4, r1, ror #4
     b74:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
     b78:	613d6863 	teqvs	sp, r3, ror #16
     b7c:	35766d72 	ldrbcc	r6, [r6, #-3442]!	; 0xfffff28e
     b80:	662b6574 			; <UNDEFINED> instruction: 0x662b6574
     b84:	672d2070 			; <UNDEFINED> instruction: 0x672d2070
     b88:	20672d20 	rsbcs	r2, r7, r0, lsr #26
     b8c:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
     b90:	2d20324f 	sfmcs	f3, 4, [r0, #-316]!	; 0xfffffec4
     b94:	2d20324f 	sfmcs	f3, 4, [r0, #-316]!	; 0xfffffec4
     b98:	2d20324f 	sfmcs	f3, 4, [r0, #-316]!	; 0xfffffec4
     b9c:	69756266 	ldmdbvs	r5!, {r1, r2, r5, r6, r9, sp, lr}^
     ba0:	6e69646c 	cdpvs	4, 6, cr6, cr9, cr12, {3}
     ba4:	696c2d67 	stmdbvs	ip!, {r0, r1, r2, r5, r6, r8, sl, fp, sp}^
     ba8:	63636762 	cmnvs	r3, #25690112	; 0x1880000
     bac:	6e662d20 	cdpvs	13, 6, cr2, cr6, cr0, {1}
     bb0:	74732d6f 	ldrbtvc	r2, [r3], #-3439	; 0xfffff291
     bb4:	2d6b6361 	stclcs	3, cr6, [fp, #-388]!	; 0xfffffe7c
     bb8:	746f7270 	strbtvc	r7, [pc], #-624	; bc0 <_start-0x7440>
     bbc:	6f746365 	svcvs	0x00746365
     bc0:	662d2072 			; <UNDEFINED> instruction: 0x662d2072
     bc4:	692d6f6e 	pushvs	{r1, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}
     bc8:	6e696c6e 	cdpvs	12, 6, cr6, cr9, cr14, {3}
     bcc:	662d2065 	strtvs	r2, [sp], -r5, rrx
     bd0:	69736976 	ldmdbvs	r3!, {r1, r2, r4, r5, r6, r8, fp, sp, lr}^
     bd4:	696c6962 	stmdbvs	ip!, {r1, r5, r6, r8, fp, sp, lr}^
     bd8:	683d7974 	ldmdavs	sp!, {r2, r4, r5, r6, r8, fp, ip, sp, lr}
     bdc:	65646469 	strbvs	r6, [r4, #-1129]!	; 0xfffffb97
     be0:	5241006e 	subpl	r0, r1, #110	; 0x6e
     be4:	49485f4d 	stmdbmi	r8, {r0, r2, r3, r6, r8, r9, sl, fp, ip, lr}^
     be8:	61736900 	cmnvs	r3, r0, lsl #18
     bec:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
     bf0:	6964615f 	stmdbvs	r4!, {r0, r1, r2, r3, r4, r6, r8, sp, lr}^
     bf4:	41540076 	cmpmi	r4, r6, ror r0
     bf8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
     bfc:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
     c00:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
     c04:	36333131 			; <UNDEFINED> instruction: 0x36333131
     c08:	5400736a 	strpl	r7, [r0], #-874	; 0xfffffc96
     c0c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
     c10:	50435f54 	subpl	r5, r3, r4, asr pc
     c14:	72615f55 	rsbvc	r5, r1, #340	; 0x154
     c18:	5400386d 	strpl	r3, [r0], #-2157	; 0xfffff793
     c1c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
     c20:	50435f54 	subpl	r5, r3, r4, asr pc
     c24:	72615f55 	rsbvc	r5, r1, #340	; 0x154
     c28:	5400396d 	strpl	r3, [r0], #-2413	; 0xfffff693
     c2c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
     c30:	50435f54 	subpl	r5, r3, r4, asr pc
     c34:	61665f55 	cmnvs	r6, r5, asr pc
     c38:	00363236 	eorseq	r3, r6, r6, lsr r2
     c3c:	676e6f6c 	strbvs	r6, [lr, -ip, ror #30]!
     c40:	6e6f6c20 	cdpvs	12, 6, cr6, cr15, cr0, {1}
     c44:	6e752067 	cdpvs	0, 7, cr2, cr5, cr7, {3}
     c48:	6e676973 			; <UNDEFINED> instruction: 0x6e676973
     c4c:	69206465 	stmdbvs	r0!, {r0, r2, r5, r6, sl, sp, lr}
     c50:	6100746e 	tstvs	r0, lr, ror #8
     c54:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
     c58:	5f686372 	svcpl	0x00686372
     c5c:	65736d63 	ldrbvs	r6, [r3, #-3427]!	; 0xfffff29d
     c60:	52415400 	subpl	r5, r1, #0, 8
     c64:	5f544547 	svcpl	0x00544547
     c68:	5f555043 	svcpl	0x00555043
     c6c:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
     c70:	346d7865 	strbtcc	r7, [sp], #-2149	; 0xfffff79b
     c74:	52415400 	subpl	r5, r1, #0, 8
     c78:	5f544547 	svcpl	0x00544547
     c7c:	5f555043 	svcpl	0x00555043
     c80:	316d7261 	cmncc	sp, r1, ror #4
     c84:	54006530 	strpl	r6, [r0], #-1328	; 0xfffffad0
     c88:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
     c8c:	50435f54 	subpl	r5, r3, r4, asr pc
     c90:	6f635f55 	svcvs	0x00635f55
     c94:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
     c98:	6100376d 	tstvs	r0, sp, ror #14
     c9c:	635f6d72 	cmpvs	pc, #7296	; 0x1c80
     ca0:	5f646e6f 	svcpl	0x00646e6f
     ca4:	65646f63 	strbvs	r6, [r4, #-3939]!	; 0xfffff09d
     ca8:	4d524100 	ldfmie	f4, [r2, #-0]
     cac:	5343505f 	movtpl	r5, #12383	; 0x305f
     cb0:	5041415f 	subpl	r4, r1, pc, asr r1
     cb4:	69005343 	stmdbvs	r0, {r0, r1, r6, r8, r9, ip, lr}
     cb8:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
     cbc:	615f7469 	cmpvs	pc, r9, ror #8
     cc0:	38766d72 	ldmdacc	r6!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^
     cc4:	4200325f 	andmi	r3, r0, #-268435451	; 0xf0000005
     cc8:	5f455341 	svcpl	0x00455341
     ccc:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
     cd0:	004d335f 	subeq	r3, sp, pc, asr r3
     cd4:	47524154 			; <UNDEFINED> instruction: 0x47524154
     cd8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
     cdc:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
     ce0:	31376d72 	teqcc	r7, r2, ror sp
     ce4:	61007430 	tstvs	r0, r0, lsr r4
     ce8:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
     cec:	5f686372 	svcpl	0x00686372
     cf0:	6d6d7769 	stclvs	7, cr7, [sp, #-420]!	; 0xfffffe5c
     cf4:	00327478 	eorseq	r7, r2, r8, ror r4
     cf8:	5f617369 	svcpl	0x00617369
     cfc:	5f6d756e 	svcpl	0x006d756e
     d00:	73746962 	cmnvc	r4, #1605632	; 0x188000
     d04:	52415400 	subpl	r5, r1, #0, 8
     d08:	5f544547 	svcpl	0x00544547
     d0c:	5f555043 	svcpl	0x00555043
     d10:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
     d14:	306d7865 	rsbcc	r7, sp, r5, ror #16
     d18:	73756c70 	cmnvc	r5, #112, 24	; 0x7000
     d1c:	6c616d73 	stclvs	13, cr6, [r1], #-460	; 0xfffffe34
     d20:	6c756d6c 	ldclvs	13, cr6, [r5], #-432	; 0xfffffe50
     d24:	6c706974 			; <UNDEFINED> instruction: 0x6c706974
     d28:	41540079 	cmpmi	r4, r9, ror r0
     d2c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
     d30:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
     d34:	7978655f 	ldmdbvc	r8!, {r0, r1, r2, r3, r4, r6, r8, sl, sp, lr}^
     d38:	6d736f6e 	ldclvs	15, cr6, [r3, #-440]!	; 0xfffffe48
     d3c:	41540031 	cmpmi	r4, r1, lsr r0
     d40:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
     d44:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
     d48:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
     d4c:	72786574 	rsbsvc	r6, r8, #116, 10	; 0x1d000000
     d50:	69003235 	stmdbvs	r0, {r0, r2, r4, r5, r9, ip, sp}
     d54:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
     d58:	745f7469 	ldrbvc	r7, [pc], #-1129	; d60 <_start-0x72a0>
     d5c:	00766964 	rsbseq	r6, r6, r4, ror #18
     d60:	66657270 			; <UNDEFINED> instruction: 0x66657270
     d64:	6e5f7265 	cdpvs	2, 5, cr7, cr15, cr5, {3}
     d68:	5f6e6f65 	svcpl	0x006e6f65
     d6c:	5f726f66 	svcpl	0x00726f66
     d70:	69623436 	stmdbvs	r2!, {r1, r2, r4, r5, sl, ip, sp}^
     d74:	69007374 	stmdbvs	r0, {r2, r4, r5, r6, r8, r9, ip, sp, lr}
     d78:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
     d7c:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
     d80:	66363170 			; <UNDEFINED> instruction: 0x66363170
     d84:	54006c6d 	strpl	r6, [r0], #-3181	; 0xfffff393
     d88:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
     d8c:	50435f54 	subpl	r5, r3, r4, asr pc
     d90:	6f635f55 	svcvs	0x00635f55
     d94:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
     d98:	00323361 	eorseq	r3, r2, r1, ror #6
     d9c:	47524154 			; <UNDEFINED> instruction: 0x47524154
     da0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
     da4:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
     da8:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
     dac:	35336178 	ldrcc	r6, [r3, #-376]!	; 0xfffffe88
     db0:	61736900 	cmnvs	r3, r0, lsl #18
     db4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
     db8:	3170665f 	cmncc	r0, pc, asr r6
     dbc:	6e6f6336 	mcrvs	3, 3, r6, cr15, cr6, {1}
     dc0:	6e750076 	mrcvs	0, 3, r0, cr5, cr6, {3}
     dc4:	63657073 	cmnvs	r5, #115	; 0x73
     dc8:	74735f76 	ldrbtvc	r5, [r3], #-3958	; 0xfffff08a
     dcc:	676e6972 			; <UNDEFINED> instruction: 0x676e6972
     dd0:	41540073 	cmpmi	r4, r3, ror r0
     dd4:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
     dd8:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
     ddc:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
     de0:	36353131 			; <UNDEFINED> instruction: 0x36353131
     de4:	00733274 	rsbseq	r3, r3, r4, ror r2
     de8:	47524154 			; <UNDEFINED> instruction: 0x47524154
     dec:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
     df0:	665f5550 			; <UNDEFINED> instruction: 0x665f5550
     df4:	36303661 	ldrtcc	r3, [r0], -r1, ror #12
     df8:	54006574 	strpl	r6, [r0], #-1396	; 0xfffffa8c
     dfc:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
     e00:	50435f54 	subpl	r5, r3, r4, asr pc
     e04:	72615f55 	rsbvc	r5, r1, #340	; 0x154
     e08:	3632396d 	ldrtcc	r3, [r2], -sp, ror #18
     e0c:	00736a65 	rsbseq	r6, r3, r5, ror #20
     e10:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
     e14:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
     e18:	54345f48 	ldrtpl	r5, [r4], #-3912	; 0xfffff0b8
     e1c:	61736900 	cmnvs	r3, r0, lsl #18
     e20:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
     e24:	7972635f 	ldmdbvc	r2!, {r0, r1, r2, r3, r4, r6, r8, r9, sp, lr}^
     e28:	006f7470 	rsbeq	r7, pc, r0, ror r4	; <UNPREDICTABLE>
     e2c:	5f6d7261 	svcpl	0x006d7261
     e30:	73676572 	cmnvc	r7, #478150656	; 0x1c800000
     e34:	5f6e695f 	svcpl	0x006e695f
     e38:	75716573 	ldrbvc	r6, [r1, #-1395]!	; 0xfffffa8d
     e3c:	65636e65 	strbvs	r6, [r3, #-3685]!	; 0xfffff19b
     e40:	61736900 	cmnvs	r3, r0, lsl #18
     e44:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
     e48:	0062735f 	rsbeq	r7, r2, pc, asr r3
     e4c:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
     e50:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
     e54:	54355f48 	ldrtpl	r5, [r5], #-3912	; 0xfffff0b8
     e58:	73690045 	cmnvc	r9, #69	; 0x45
     e5c:	65665f61 	strbvs	r5, [r6, #-3937]!	; 0xfffff09f
     e60:	72757461 	rsbsvc	r7, r5, #1627389952	; 0x61000000
     e64:	73690065 	cmnvc	r9, #101	; 0x65
     e68:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
     e6c:	6d735f74 	ldclvs	15, cr5, [r3, #-464]!	; 0xfffffe30
     e70:	6d6c6c61 	stclvs	12, cr6, [ip, #-388]!	; 0xfffffe7c
     e74:	61006c75 	tstvs	r0, r5, ror ip
     e78:	6c5f6d72 	mrrcvs	13, 7, r6, pc, cr2	; <UNPREDICTABLE>
     e7c:	5f676e61 	svcpl	0x00676e61
     e80:	7074756f 	rsbsvc	r7, r4, pc, ror #10
     e84:	6f5f7475 	svcvs	0x005f7475
     e88:	63656a62 	cmnvs	r5, #401408	; 0x62000
     e8c:	74615f74 	strbtvc	r5, [r1], #-3956	; 0xfffff08c
     e90:	62697274 	rsbvs	r7, r9, #116, 4	; 0x40000007
     e94:	73657475 	cmnvc	r5, #1962934272	; 0x75000000
     e98:	6f6f685f 	svcvs	0x006f685f
     e9c:	7369006b 	cmnvc	r9, #107	; 0x6b
     ea0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
     ea4:	70665f74 	rsbvc	r5, r6, r4, ror pc
     ea8:	3233645f 	eorscc	r6, r3, #1593835520	; 0x5f000000
     eac:	4d524100 	ldfmie	f4, [r2, #-0]
     eb0:	00454e5f 	subeq	r4, r5, pc, asr lr
     eb4:	5f617369 	svcpl	0x00617369
     eb8:	5f746962 	svcpl	0x00746962
     ebc:	00386562 	eorseq	r6, r8, r2, ror #10
     ec0:	47524154 			; <UNDEFINED> instruction: 0x47524154
     ec4:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
     ec8:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
     ecc:	31316d72 	teqcc	r1, r2, ror sp
     ed0:	7a6a3637 	bvc	1a8e7b4 <_bss_end+0x1a85f74>
     ed4:	72700073 	rsbsvc	r0, r0, #115	; 0x73
     ed8:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     edc:	5f726f73 	svcpl	0x00726f73
     ee0:	65707974 	ldrbvs	r7, [r0, #-2420]!	; 0xfffff68c
     ee4:	6c6c6100 	stfvse	f6, [ip], #-0
     ee8:	7570665f 	ldrbvc	r6, [r0, #-1631]!	; 0xfffff9a1
     eec:	72610073 	rsbvc	r0, r1, #115	; 0x73
     ef0:	63705f6d 	cmnvs	r0, #436	; 0x1b4
     ef4:	41420073 	hvcmi	8195	; 0x2003
     ef8:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
     efc:	5f484352 	svcpl	0x00484352
     f00:	61005435 	tstvs	r0, r5, lsr r4
     f04:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
     f08:	34686372 	strbtcc	r6, [r8], #-882	; 0xfffffc8e
     f0c:	41540074 	cmpmi	r4, r4, ror r0
     f10:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
     f14:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
     f18:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
     f1c:	61786574 	cmnvs	r8, r4, ror r5
     f20:	6f633637 	svcvs	0x00633637
     f24:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
     f28:	00353561 	eorseq	r3, r5, r1, ror #10
     f2c:	5f6d7261 	svcpl	0x006d7261
     f30:	656e7574 	strbvs	r7, [lr, #-1396]!	; 0xfffffa8c
     f34:	7562775f 	strbvc	r7, [r2, #-1887]!	; 0xfffff8a1
     f38:	74680066 	strbtvc	r0, [r8], #-102	; 0xffffff9a
     f3c:	685f6261 	ldmdavs	pc, {r0, r5, r6, r9, sp, lr}^	; <UNPREDICTABLE>
     f40:	00687361 	rsbeq	r7, r8, r1, ror #6
     f44:	5f617369 	svcpl	0x00617369
     f48:	5f746962 	svcpl	0x00746962
     f4c:	72697571 	rsbvc	r7, r9, #473956352	; 0x1c400000
     f50:	6f6e5f6b 	svcvs	0x006e5f6b
     f54:	6c6f765f 	stclvs	6, cr7, [pc], #-380	; de0 <_start-0x7220>
     f58:	6c697461 	cfstrdvs	mvd7, [r9], #-388	; 0xfffffe7c
     f5c:	65635f65 	strbvs	r5, [r3, #-3941]!	; 0xfffff09b
     f60:	52415400 	subpl	r5, r1, #0, 8
     f64:	5f544547 	svcpl	0x00544547
     f68:	5f555043 	svcpl	0x00555043
     f6c:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
     f70:	306d7865 	rsbcc	r7, sp, r5, ror #16
     f74:	52415400 	subpl	r5, r1, #0, 8
     f78:	5f544547 	svcpl	0x00544547
     f7c:	5f555043 	svcpl	0x00555043
     f80:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
     f84:	316d7865 	cmncc	sp, r5, ror #16
     f88:	52415400 	subpl	r5, r1, #0, 8
     f8c:	5f544547 	svcpl	0x00544547
     f90:	5f555043 	svcpl	0x00555043
     f94:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
     f98:	336d7865 	cmncc	sp, #6619136	; 0x650000
     f9c:	61736900 	cmnvs	r3, r0, lsl #18
     fa0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
     fa4:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
     fa8:	315f3876 	cmpcc	pc, r6, ror r8	; <UNPREDICTABLE>
     fac:	6d726100 	ldfvse	f6, [r2, #-0]
     fb0:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
     fb4:	616e5f68 	cmnvs	lr, r8, ror #30
     fb8:	6900656d 	stmdbvs	r0, {r0, r2, r3, r5, r6, r8, sl, sp, lr}
     fbc:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
     fc0:	615f7469 	cmpvs	pc, r9, ror #8
     fc4:	38766d72 	ldmdacc	r6!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^
     fc8:	6900335f 	stmdbvs	r0, {r0, r1, r2, r3, r4, r6, r8, r9, ip, sp}
     fcc:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
     fd0:	615f7469 	cmpvs	pc, r9, ror #8
     fd4:	38766d72 	ldmdacc	r6!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^
     fd8:	6900345f 	stmdbvs	r0, {r0, r1, r2, r3, r4, r6, sl, ip, sp}
     fdc:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
     fe0:	615f7469 	cmpvs	pc, r9, ror #8
     fe4:	38766d72 	ldmdacc	r6!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^
     fe8:	5400355f 	strpl	r3, [r0], #-1375	; 0xfffffaa1
     fec:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
     ff0:	50435f54 	subpl	r5, r3, r4, asr pc
     ff4:	6f635f55 	svcvs	0x00635f55
     ff8:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
     ffc:	00333561 	eorseq	r3, r3, r1, ror #10
    1000:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1004:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1008:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    100c:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1010:	35356178 	ldrcc	r6, [r5, #-376]!	; 0xfffffe88
    1014:	52415400 	subpl	r5, r1, #0, 8
    1018:	5f544547 	svcpl	0x00544547
    101c:	5f555043 	svcpl	0x00555043
    1020:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1024:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    1028:	41540037 	cmpmi	r4, r7, lsr r0
    102c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1030:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1034:	63706d5f 	cmnvs	r0, #6080	; 0x17c0
    1038:	0065726f 	rsbeq	r7, r5, pc, ror #4
    103c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1040:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1044:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1048:	6e5f6d72 	mrcvs	13, 2, r6, cr15, cr2, {3}
    104c:	00656e6f 	rsbeq	r6, r5, pc, ror #28
    1050:	5f6d7261 	svcpl	0x006d7261
    1054:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1058:	746f6e5f 	strbtvc	r6, [pc], #-3679	; 1060 <_start-0x6fa0>
    105c:	4154006d 	cmpmi	r4, sp, rrx
    1060:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1064:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1068:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    106c:	36323031 			; <UNDEFINED> instruction: 0x36323031
    1070:	00736a65 	rsbseq	r6, r3, r5, ror #20
    1074:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1078:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    107c:	4a365f48 	bmi	d98da4 <_bss_end+0xd90564>
    1080:	53414200 	movtpl	r4, #4608	; 0x1200
    1084:	52415f45 	subpl	r5, r1, #276	; 0x114
    1088:	365f4843 	ldrbcc	r4, [pc], -r3, asr #16
    108c:	4142004b 	cmpmi	r2, fp, asr #32
    1090:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1094:	5f484352 	svcpl	0x00484352
    1098:	69004d36 	stmdbvs	r0, {r1, r2, r4, r5, r8, sl, fp, lr}
    109c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    10a0:	695f7469 	ldmdbvs	pc, {r0, r3, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    10a4:	786d6d77 	stmdavc	sp!, {r0, r1, r2, r4, r5, r6, r8, sl, fp, sp, lr}^
    10a8:	41540074 	cmpmi	r4, r4, ror r0
    10ac:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    10b0:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    10b4:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    10b8:	36333131 			; <UNDEFINED> instruction: 0x36333131
    10bc:	0073666a 	rsbseq	r6, r3, sl, ror #12
    10c0:	5f4d5241 	svcpl	0x004d5241
    10c4:	4100534c 	tstmi	r0, ip, asr #6
    10c8:	4c5f4d52 	mrrcmi	13, 5, r4, pc, cr2	; <UNPREDICTABLE>
    10cc:	41420054 	qdaddmi	r0, r4, r2
    10d0:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    10d4:	5f484352 	svcpl	0x00484352
    10d8:	54005a36 	strpl	r5, [r0], #-2614	; 0xfffff5ca
    10dc:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    10e0:	50435f54 	subpl	r5, r3, r4, asr pc
    10e4:	6f635f55 	svcvs	0x00635f55
    10e8:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    10ec:	63353761 	teqvs	r5, #25427968	; 0x1840000
    10f0:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    10f4:	35356178 	ldrcc	r6, [r5, #-376]!	; 0xfffffe88
    10f8:	4d524100 	ldfmie	f4, [r2, #-0]
    10fc:	5343505f 	movtpl	r5, #12383	; 0x305f
    1100:	5041415f 	subpl	r4, r1, pc, asr r1
    1104:	565f5343 	ldrbpl	r5, [pc], -r3, asr #6
    1108:	54005046 	strpl	r5, [r0], #-70	; 0xffffffba
    110c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1110:	50435f54 	subpl	r5, r3, r4, asr pc
    1114:	77695f55 			; <UNDEFINED> instruction: 0x77695f55
    1118:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
    111c:	73690032 	cmnvc	r9, #50	; 0x32
    1120:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1124:	656e5f74 	strbvs	r5, [lr, #-3956]!	; 0xfffff08c
    1128:	61006e6f 	tstvs	r0, pc, ror #28
    112c:	665f6d72 			; <UNDEFINED> instruction: 0x665f6d72
    1130:	615f7570 	cmpvs	pc, r0, ror r5	; <UNPREDICTABLE>
    1134:	00727474 	rsbseq	r7, r2, r4, ror r4
    1138:	5f617369 	svcpl	0x00617369
    113c:	5f746962 	svcpl	0x00746962
    1140:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1144:	006d6537 	rsbeq	r6, sp, r7, lsr r5
    1148:	47524154 			; <UNDEFINED> instruction: 0x47524154
    114c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1150:	665f5550 			; <UNDEFINED> instruction: 0x665f5550
    1154:	36323661 	ldrtcc	r3, [r2], -r1, ror #12
    1158:	54006574 	strpl	r6, [r0], #-1396	; 0xfffffa8c
    115c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1160:	50435f54 	subpl	r5, r3, r4, asr pc
    1164:	616d5f55 	cmnvs	sp, r5, asr pc
    1168:	6c657672 	stclvs	6, cr7, [r5], #-456	; 0xfffffe38
    116c:	6a705f6c 	bvs	1c18f24 <_bss_end+0x1c106e4>
    1170:	74680034 	strbtvc	r0, [r8], #-52	; 0xffffffcc
    1174:	685f6261 	ldmdavs	pc, {r0, r5, r6, r9, sp, lr}^	; <UNPREDICTABLE>
    1178:	5f687361 	svcpl	0x00687361
    117c:	6e696f70 	mcrvs	15, 3, r6, cr9, cr0, {3}
    1180:	00726574 	rsbseq	r6, r2, r4, ror r5
    1184:	5f6d7261 	svcpl	0x006d7261
    1188:	656e7574 	strbvs	r7, [lr, #-1396]!	; 0xfffffa8c
    118c:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1190:	5f786574 	svcpl	0x00786574
    1194:	69003961 	stmdbvs	r0, {r0, r5, r6, r8, fp, ip, sp}
    1198:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    119c:	695f7469 	ldmdbvs	pc, {r0, r3, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    11a0:	786d6d77 	stmdavc	sp!, {r0, r1, r2, r4, r5, r6, r8, sl, fp, sp, lr}^
    11a4:	54003274 	strpl	r3, [r0], #-628	; 0xfffffd8c
    11a8:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    11ac:	50435f54 	subpl	r5, r3, r4, asr pc
    11b0:	6f635f55 	svcvs	0x00635f55
    11b4:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    11b8:	63323761 	teqvs	r2, #25427968	; 0x1840000
    11bc:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    11c0:	33356178 	teqcc	r5, #120, 2
    11c4:	61736900 	cmnvs	r3, r0, lsl #18
    11c8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    11cc:	7568745f 	strbvc	r7, [r8, #-1119]!	; 0xfffffba1
    11d0:	0032626d 	eorseq	r6, r2, sp, ror #4
    11d4:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    11d8:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    11dc:	41375f48 	teqmi	r7, r8, asr #30
    11e0:	61736900 	cmnvs	r3, r0, lsl #18
    11e4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    11e8:	746f645f 	strbtvc	r6, [pc], #-1119	; 11f0 <_start-0x6e10>
    11ec:	646f7270 	strbtvs	r7, [pc], #-624	; 11f4 <_start-0x6e0c>
    11f0:	6d726100 	ldfvse	f6, [r2, #-0]
    11f4:	3170665f 	cmncc	r0, pc, asr r6
    11f8:	79745f36 	ldmdbvc	r4!, {r1, r2, r4, r5, r8, r9, sl, fp, ip, lr}^
    11fc:	6e5f6570 	mrcvs	5, 2, r6, cr15, cr0, {3}
    1200:	0065646f 	rsbeq	r6, r5, pc, ror #8
    1204:	5f4d5241 	svcpl	0x004d5241
    1208:	6100494d 	tstvs	r0, sp, asr #18
    120c:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1210:	36686372 			; <UNDEFINED> instruction: 0x36686372
    1214:	7261006b 	rsbvc	r0, r1, #107	; 0x6b
    1218:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    121c:	6d366863 	ldcvs	8, cr6, [r6, #-396]!	; 0xfffffe74
    1220:	53414200 	movtpl	r4, #4608	; 0x1200
    1224:	52415f45 	subpl	r5, r1, #276	; 0x114
    1228:	375f4843 	ldrbcc	r4, [pc, -r3, asr #16]
    122c:	5f5f0052 	svcpl	0x005f0052
    1230:	63706f70 	cmnvs	r0, #112, 30	; 0x1c0
    1234:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
    1238:	6261745f 	rsbvs	r7, r1, #1593835520	; 0x5f000000
    123c:	75622f00 	strbvc	r2, [r2, #-3840]!	; 0xfffff100
    1240:	2f646c69 	svccs	0x00646c69
    1244:	2d636367 	stclcs	3, cr6, [r3, #-412]!	; 0xfffffe64
    1248:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
    124c:	656e6f6e 	strbvs	r6, [lr, #-3950]!	; 0xfffff092
    1250:	6261652d 	rsbvs	r6, r1, #188743680	; 0xb400000
    1254:	6c472d69 	mcrrvs	13, 6, r2, r7, cr9
    1258:	39546b39 	ldmdbcc	r4, {r0, r3, r4, r5, r8, r9, fp, sp, lr}^
    125c:	6363672f 	cmnvs	r3, #12320768	; 0xbc0000
    1260:	6d72612d 	ldfvse	f6, [r2, #-180]!	; 0xffffff4c
    1264:	6e6f6e2d 	cdpvs	14, 6, cr6, cr15, cr13, {1}
    1268:	61652d65 	cmnvs	r5, r5, ror #26
    126c:	392d6962 	pushcc	{r1, r5, r6, r8, fp, sp, lr}
    1270:	3130322d 	teqcc	r0, sp, lsr #4
    1274:	34712d39 	ldrbtcc	r2, [r1], #-3385	; 0xfffff2c7
    1278:	6975622f 	ldmdbvs	r5!, {r0, r1, r2, r3, r5, r9, sp, lr}^
    127c:	612f646c 			; <UNDEFINED> instruction: 0x612f646c
    1280:	6e2d6d72 	mcrvs	13, 1, r6, cr13, cr2, {3}
    1284:	2d656e6f 	stclcs	14, cr6, [r5, #-444]!	; 0xfffffe44
    1288:	69626165 	stmdbvs	r2!, {r0, r2, r5, r6, r8, sp, lr}^
    128c:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
    1290:	7435762f 	ldrtvc	r7, [r5], #-1583	; 0xfffff9d1
    1294:	61682f65 	cmnvs	r8, r5, ror #30
    1298:	6c2f6472 	cfstrsvs	mvf6, [pc], #-456	; 10d8 <_start-0x6f28>
    129c:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    12a0:	73690063 	cmnvc	r9, #99	; 0x63
    12a4:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    12a8:	6d635f74 	stclvs	15, cr5, [r3, #-464]!	; 0xfffffe30
    12ac:	54006573 	strpl	r6, [r0], #-1395	; 0xfffffa8d
    12b0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    12b4:	50435f54 	subpl	r5, r3, r4, asr pc
    12b8:	6f635f55 	svcvs	0x00635f55
    12bc:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    12c0:	00333761 	eorseq	r3, r3, r1, ror #14
    12c4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    12c8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    12cc:	675f5550 			; <UNDEFINED> instruction: 0x675f5550
    12d0:	72656e65 	rsbvc	r6, r5, #1616	; 0x650
    12d4:	37766369 	ldrbcc	r6, [r6, -r9, ror #6]!
    12d8:	41540061 	cmpmi	r4, r1, rrx
    12dc:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    12e0:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    12e4:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    12e8:	61786574 	cmnvs	r8, r4, ror r5
    12ec:	61003637 	tstvs	r0, r7, lsr r6
    12f0:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    12f4:	5f686372 	svcpl	0x00686372
    12f8:	765f6f6e 	ldrbvc	r6, [pc], -lr, ror #30
    12fc:	74616c6f 	strbtvc	r6, [r1], #-3183	; 0xfffff391
    1300:	5f656c69 	svcpl	0x00656c69
    1304:	42006563 	andmi	r6, r0, #415236096	; 0x18c00000
    1308:	5f455341 	svcpl	0x00455341
    130c:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1310:	0041385f 	subeq	r3, r1, pc, asr r8
    1314:	5f617369 	svcpl	0x00617369
    1318:	5f746962 	svcpl	0x00746962
    131c:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1320:	42007435 	andmi	r7, r0, #889192448	; 0x35000000
    1324:	5f455341 	svcpl	0x00455341
    1328:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    132c:	0052385f 	subseq	r3, r2, pc, asr r8
    1330:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1334:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1338:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    133c:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1340:	33376178 	teqcc	r7, #120, 2
    1344:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1348:	33617865 	cmncc	r1, #6619136	; 0x650000
    134c:	52410035 	subpl	r0, r1, #53	; 0x35
    1350:	564e5f4d 	strbpl	r5, [lr], -sp, asr #30
    1354:	6d726100 	ldfvse	f6, [r2, #-0]
    1358:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    135c:	61003468 	tstvs	r0, r8, ror #8
    1360:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1364:	36686372 			; <UNDEFINED> instruction: 0x36686372
    1368:	6d726100 	ldfvse	f6, [r2, #-0]
    136c:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1370:	61003768 	tstvs	r0, r8, ror #14
    1374:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1378:	38686372 	stmdacc	r8!, {r1, r4, r5, r6, r8, r9, sp, lr}^
    137c:	6e6f6c00 	cdpvs	12, 6, cr6, cr15, cr0, {0}
    1380:	6f642067 	svcvs	0x00642067
    1384:	656c6275 	strbvs	r6, [ip, #-629]!	; 0xfffffd8b
    1388:	6d726100 	ldfvse	f6, [r2, #-0]
    138c:	6e75745f 	mrcvs	4, 3, r7, cr5, cr15, {2}
    1390:	73785f65 	cmnvc	r8, #404	; 0x194
    1394:	656c6163 	strbvs	r6, [ip, #-355]!	; 0xfffffe9d
    1398:	6b616d00 	blvs	185c7a0 <_bss_end+0x1853f60>
    139c:	5f676e69 	svcpl	0x00676e69
    13a0:	736e6f63 	cmnvc	lr, #396	; 0x18c
    13a4:	61745f74 	cmnvs	r4, r4, ror pc
    13a8:	00656c62 	rsbeq	r6, r5, r2, ror #24
    13ac:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    13b0:	61635f62 	cmnvs	r3, r2, ror #30
    13b4:	765f6c6c 	ldrbvc	r6, [pc], -ip, ror #24
    13b8:	6c5f6169 	ldfvse	f6, [pc], {105}	; 0x69
    13bc:	6c656261 	sfmvs	f6, 2, [r5], #-388	; 0xfffffe7c
    13c0:	61736900 	cmnvs	r3, r0, lsl #18
    13c4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    13c8:	7670665f 			; <UNDEFINED> instruction: 0x7670665f
    13cc:	73690035 	cmnvc	r9, #53	; 0x35
    13d0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    13d4:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    13d8:	6b36766d 	blvs	d9ed94 <_bss_end+0xd96554>
    13dc:	52415400 	subpl	r5, r1, #0, 8
    13e0:	5f544547 	svcpl	0x00544547
    13e4:	5f555043 	svcpl	0x00555043
    13e8:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    13ec:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    13f0:	52415400 	subpl	r5, r1, #0, 8
    13f4:	5f544547 	svcpl	0x00544547
    13f8:	5f555043 	svcpl	0x00555043
    13fc:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1400:	38617865 	stmdacc	r1!, {r0, r2, r5, r6, fp, ip, sp, lr}^
    1404:	52415400 	subpl	r5, r1, #0, 8
    1408:	5f544547 	svcpl	0x00544547
    140c:	5f555043 	svcpl	0x00555043
    1410:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1414:	39617865 	stmdbcc	r1!, {r0, r2, r5, r6, fp, ip, sp, lr}^
    1418:	4d524100 	ldfmie	f4, [r2, #-0]
    141c:	5343505f 	movtpl	r5, #12383	; 0x305f
    1420:	4350415f 	cmpmi	r0, #-1073741801	; 0xc0000017
    1424:	52410053 	subpl	r0, r1, #83	; 0x53
    1428:	43505f4d 	cmpmi	r0, #308	; 0x134
    142c:	54415f53 	strbpl	r5, [r1], #-3923	; 0xfffff0ad
    1430:	00534350 	subseq	r4, r3, r0, asr r3
    1434:	706d6f63 	rsbvc	r6, sp, r3, ror #30
    1438:	2078656c 	rsbscs	r6, r8, ip, ror #10
    143c:	62756f64 	rsbsvs	r6, r5, #100, 30	; 0x190
    1440:	5400656c 	strpl	r6, [r0], #-1388	; 0xfffffa94
    1444:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1448:	50435f54 	subpl	r5, r3, r4, asr pc
    144c:	6f635f55 	svcvs	0x00635f55
    1450:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1454:	63333761 	teqvs	r3, #25427968	; 0x1840000
    1458:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    145c:	33356178 	teqcc	r5, #120, 2
    1460:	52415400 	subpl	r5, r1, #0, 8
    1464:	5f544547 	svcpl	0x00544547
    1468:	5f555043 	svcpl	0x00555043
    146c:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1470:	306d7865 	rsbcc	r7, sp, r5, ror #16
    1474:	73756c70 	cmnvc	r5, #112, 24	; 0x7000
    1478:	6d726100 	ldfvse	f6, [r2, #-0]
    147c:	0063635f 	rsbeq	r6, r3, pc, asr r3
    1480:	5f617369 	svcpl	0x00617369
    1484:	5f746962 	svcpl	0x00746962
    1488:	61637378 	smcvs	14136	; 0x3738
    148c:	5f00656c 	svcpl	0x0000656c
    1490:	746e6f64 	strbtvc	r6, [lr], #-3940	; 0xfffff09c
    1494:	6573755f 	ldrbvs	r7, [r3, #-1375]!	; 0xfffffaa1
    1498:	6572745f 	ldrbvs	r7, [r2, #-1119]!	; 0xfffffba1
    149c:	65685f65 	strbvs	r5, [r8, #-3941]!	; 0xfffff09b
    14a0:	005f6572 	subseq	r6, pc, r2, ror r5	; <UNPREDICTABLE>
    14a4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    14a8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    14ac:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    14b0:	30316d72 	eorscc	r6, r1, r2, ror sp
    14b4:	696d6474 	stmdbvs	sp!, {r2, r4, r5, r6, sl, sp, lr}^
    14b8:	52415400 	subpl	r5, r1, #0, 8
    14bc:	5f544547 	svcpl	0x00544547
    14c0:	5f555043 	svcpl	0x00555043
    14c4:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    14c8:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    14cc:	73616200 	cmnvc	r1, #0, 4
    14d0:	72615f65 	rsbvc	r5, r1, #404	; 0x194
    14d4:	74696863 	strbtvc	r6, [r9], #-2147	; 0xfffff79d
    14d8:	75746365 	ldrbvc	r6, [r4, #-869]!	; 0xfffffc9b
    14dc:	61006572 	tstvs	r0, r2, ror r5
    14e0:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    14e4:	5f686372 	svcpl	0x00686372
    14e8:	00637263 	rsbeq	r7, r3, r3, ror #4
    14ec:	47524154 			; <UNDEFINED> instruction: 0x47524154
    14f0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    14f4:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    14f8:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    14fc:	73316d78 	teqvc	r1, #120, 26	; 0x1e00
    1500:	6c6c616d 	stfvse	f6, [ip], #-436	; 0xfffffe4c
    1504:	746c756d 	strbtvc	r7, [ip], #-1389	; 0xfffffa93
    1508:	796c7069 	stmdbvc	ip!, {r0, r3, r5, r6, ip, sp, lr}^
    150c:	6d726100 	ldfvse	f6, [r2, #-0]
    1510:	7275635f 	rsbsvc	r6, r5, #2080374785	; 0x7c000001
    1514:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
    1518:	0063635f 	rsbeq	r6, r3, pc, asr r3
    151c:	5f617369 	svcpl	0x00617369
    1520:	5f746962 	svcpl	0x00746962
    1524:	33637263 	cmncc	r3, #805306374	; 0x30000006
    1528:	52410032 	subpl	r0, r1, #50	; 0x32
    152c:	4c505f4d 	mrrcmi	15, 4, r5, r0, cr13
    1530:	61736900 	cmnvs	r3, r0, lsl #18
    1534:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1538:	7066765f 	rsbvc	r7, r6, pc, asr r6
    153c:	69003376 	stmdbvs	r0, {r1, r2, r4, r5, r6, r8, r9, ip, sp}
    1540:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1544:	765f7469 	ldrbvc	r7, [pc], -r9, ror #8
    1548:	34767066 	ldrbtcc	r7, [r6], #-102	; 0xffffff9a
    154c:	53414200 	movtpl	r4, #4608	; 0x1200
    1550:	52415f45 	subpl	r5, r1, #276	; 0x114
    1554:	365f4843 	ldrbcc	r4, [pc], -r3, asr #16
    1558:	42003254 	andmi	r3, r0, #84, 4	; 0x40000005
    155c:	5f455341 	svcpl	0x00455341
    1560:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1564:	5f4d385f 	svcpl	0x004d385f
    1568:	4e49414d 	dvfmiem	f4, f1, #5.0
    156c:	52415400 	subpl	r5, r1, #0, 8
    1570:	5f544547 	svcpl	0x00544547
    1574:	5f555043 	svcpl	0x00555043
    1578:	396d7261 	stmdbcc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    157c:	696d6474 	stmdbvs	sp!, {r2, r4, r5, r6, sl, sp, lr}^
    1580:	4d524100 	ldfmie	f4, [r2, #-0]
    1584:	004c415f 	subeq	r4, ip, pc, asr r1
    1588:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    158c:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1590:	4d375f48 	ldcmi	15, cr5, [r7, #-288]!	; 0xfffffee0
    1594:	6d726100 	ldfvse	f6, [r2, #-0]
    1598:	7261745f 	rsbvc	r7, r1, #1593835520	; 0x5f000000
    159c:	5f746567 	svcpl	0x00746567
    15a0:	6562616c 	strbvs	r6, [r2, #-364]!	; 0xfffffe94
    15a4:	7261006c 	rsbvc	r0, r1, #108	; 0x6c
    15a8:	61745f6d 	cmnvs	r4, sp, ror #30
    15ac:	74656772 	strbtvc	r6, [r5], #-1906	; 0xfffff88e
    15b0:	736e695f 	cmnvc	lr, #1556480	; 0x17c000
    15b4:	4154006e 	cmpmi	r4, lr, rrx
    15b8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    15bc:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    15c0:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    15c4:	72786574 	rsbsvc	r6, r8, #116, 10	; 0x1d000000
    15c8:	41540034 	cmpmi	r4, r4, lsr r0
    15cc:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    15d0:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    15d4:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    15d8:	72786574 	rsbsvc	r6, r8, #116, 10	; 0x1d000000
    15dc:	41540035 	cmpmi	r4, r5, lsr r0
    15e0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    15e4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    15e8:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    15ec:	72786574 	rsbsvc	r6, r8, #116, 10	; 0x1d000000
    15f0:	41540037 	cmpmi	r4, r7, lsr r0
    15f4:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    15f8:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    15fc:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1600:	72786574 	rsbsvc	r6, r8, #116, 10	; 0x1d000000
    1604:	73690038 	cmnvc	r9, #56	; 0x38
    1608:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    160c:	706c5f74 	rsbvc	r5, ip, r4, ror pc
    1610:	69006561 	stmdbvs	r0, {r0, r5, r6, r8, sl, sp, lr}
    1614:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1618:	715f7469 	cmpvc	pc, r9, ror #8
    161c:	6b726975 	blvs	1c9bbf8 <_bss_end+0x1c933b8>
    1620:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1624:	7a6b3676 	bvc	1acf004 <_bss_end+0x1ac67c4>
    1628:	61736900 	cmnvs	r3, r0, lsl #18
    162c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1630:	746f6e5f 	strbtvc	r6, [pc], #-3679	; 1638 <_start-0x69c8>
    1634:	7369006d 	cmnvc	r9, #109	; 0x6d
    1638:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    163c:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1640:	0034766d 	eorseq	r7, r4, sp, ror #12
    1644:	5f617369 	svcpl	0x00617369
    1648:	5f746962 	svcpl	0x00746962
    164c:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1650:	73690036 	cmnvc	r9, #54	; 0x36
    1654:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1658:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    165c:	0037766d 	eorseq	r7, r7, sp, ror #12
    1660:	5f617369 	svcpl	0x00617369
    1664:	5f746962 	svcpl	0x00746962
    1668:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    166c:	645f0038 	ldrbvs	r0, [pc], #-56	; 1674 <_start-0x698c>
    1670:	5f746e6f 	svcpl	0x00746e6f
    1674:	5f657375 	svcpl	0x00657375
    1678:	5f787472 	svcpl	0x00787472
    167c:	65726568 	ldrbvs	r6, [r2, #-1384]!	; 0xfffffa98
    1680:	5155005f 	cmppl	r5, pc, asr r0
    1684:	70797449 	rsbsvc	r7, r9, r9, asr #8
    1688:	73690065 	cmnvc	r9, #101	; 0x65
    168c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1690:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1694:	7435766d 	ldrtvc	r7, [r5], #-1645	; 0xfffff993
    1698:	72610065 	rsbvc	r0, r1, #101	; 0x65
    169c:	75745f6d 	ldrbvc	r5, [r4, #-3949]!	; 0xfffff093
    16a0:	6100656e 	tstvs	r0, lr, ror #10
    16a4:	635f6d72 	cmpvs	pc, #7296	; 0x1c80
    16a8:	695f7070 	ldmdbvs	pc, {r4, r5, r6, ip, sp, lr}^	; <UNPREDICTABLE>
    16ac:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
    16b0:	6b726f77 	blvs	1c9d494 <_bss_end+0x1c94c54>
    16b4:	6e756600 	cdpvs	6, 7, cr6, cr5, cr0, {0}
    16b8:	74705f63 	ldrbtvc	r5, [r0], #-3939	; 0xfffff09d
    16bc:	41540072 	cmpmi	r4, r2, ror r0
    16c0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    16c4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    16c8:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    16cc:	74303239 	ldrtvc	r3, [r0], #-569	; 0xfffffdc7
    16d0:	61746800 	cmnvs	r4, r0, lsl #16
    16d4:	71655f62 	cmnvc	r5, r2, ror #30
    16d8:	52415400 	subpl	r5, r1, #0, 8
    16dc:	5f544547 	svcpl	0x00544547
    16e0:	5f555043 	svcpl	0x00555043
    16e4:	32356166 	eorscc	r6, r5, #-2147483623	; 0x80000019
    16e8:	72610036 	rsbvc	r0, r1, #54	; 0x36
    16ec:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    16f0:	745f6863 	ldrbvc	r6, [pc], #-2147	; 16f8 <_start-0x6908>
    16f4:	626d7568 	rsbvs	r7, sp, #104, 10	; 0x1a000000
    16f8:	6477685f 	ldrbtvs	r6, [r7], #-2143	; 0xfffff7a1
    16fc:	68007669 	stmdavs	r0, {r0, r3, r5, r6, r9, sl, ip, sp, lr}
    1700:	5f626174 	svcpl	0x00626174
    1704:	705f7165 	subsvc	r7, pc, r5, ror #2
    1708:	746e696f 	strbtvc	r6, [lr], #-2415	; 0xfffff691
    170c:	61007265 	tstvs	r0, r5, ror #4
    1710:	705f6d72 	subsvc	r6, pc, r2, ror sp	; <UNPREDICTABLE>
    1714:	725f6369 	subsvc	r6, pc, #-1543503871	; 0xa4000001
    1718:	73696765 	cmnvc	r9, #26476544	; 0x1940000
    171c:	00726574 	rsbseq	r6, r2, r4, ror r5
    1720:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1724:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1728:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    172c:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1730:	73306d78 	teqvc	r0, #120, 26	; 0x1e00
    1734:	6c6c616d 	stfvse	f6, [ip], #-436	; 0xfffffe4c
    1738:	746c756d 	strbtvc	r7, [ip], #-1389	; 0xfffffa93
    173c:	796c7069 	stmdbvc	ip!, {r0, r3, r5, r6, ip, sp, lr}^
    1740:	52415400 	subpl	r5, r1, #0, 8
    1744:	5f544547 	svcpl	0x00544547
    1748:	5f555043 	svcpl	0x00555043
    174c:	6f63706d 	svcvs	0x0063706d
    1750:	6f6e6572 	svcvs	0x006e6572
    1754:	00706676 	rsbseq	r6, r0, r6, ror r6
    1758:	5f617369 	svcpl	0x00617369
    175c:	5f746962 	svcpl	0x00746962
    1760:	72697571 	rsbvc	r7, r9, #473956352	; 0x1c400000
    1764:	6d635f6b 	stclvs	15, cr5, [r3, #-428]!	; 0xfffffe54
    1768:	646c5f33 	strbtvs	r5, [ip], #-3891	; 0xfffff0cd
    176c:	41006472 	tstmi	r0, r2, ror r4
    1770:	435f4d52 	cmpmi	pc, #5248	; 0x1480
    1774:	72610043 	rsbvc	r0, r1, #67	; 0x43
    1778:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    177c:	5f386863 	svcpl	0x00386863
    1780:	72610032 	rsbvc	r0, r1, #50	; 0x32
    1784:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    1788:	5f386863 	svcpl	0x00386863
    178c:	72610033 	rsbvc	r0, r1, #51	; 0x33
    1790:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    1794:	5f386863 	svcpl	0x00386863
    1798:	41540034 	cmpmi	r4, r4, lsr r0
    179c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    17a0:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    17a4:	706d665f 	rsbvc	r6, sp, pc, asr r6
    17a8:	00363236 	eorseq	r3, r6, r6, lsr r2
    17ac:	5f4d5241 	svcpl	0x004d5241
    17b0:	61005343 	tstvs	r0, r3, asr #6
    17b4:	665f6d72 			; <UNDEFINED> instruction: 0x665f6d72
    17b8:	5f363170 	svcpl	0x00363170
    17bc:	74736e69 	ldrbtvc	r6, [r3], #-3689	; 0xfffff197
    17c0:	6d726100 	ldfvse	f6, [r2, #-0]
    17c4:	7361625f 	cmnvc	r1, #-268435451	; 0xf0000005
    17c8:	72615f65 	rsbvc	r5, r1, #404	; 0x194
    17cc:	54006863 	strpl	r6, [r0], #-2147	; 0xfffff79d
    17d0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    17d4:	50435f54 	subpl	r5, r3, r4, asr pc
    17d8:	6f635f55 	svcvs	0x00635f55
    17dc:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    17e0:	63353161 	teqvs	r5, #1073741848	; 0x40000018
    17e4:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    17e8:	00376178 	eorseq	r6, r7, r8, ror r1
    17ec:	5f6d7261 	svcpl	0x006d7261
    17f0:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    17f4:	006d6537 	rsbeq	r6, sp, r7, lsr r5
    17f8:	47524154 			; <UNDEFINED> instruction: 0x47524154
    17fc:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1800:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1804:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1808:	32376178 	eorscc	r6, r7, #120, 2
    180c:	6d726100 	ldfvse	f6, [r2, #-0]
    1810:	7363705f 	cmnvc	r3, #95	; 0x5f
    1814:	6665645f 			; <UNDEFINED> instruction: 0x6665645f
    1818:	746c7561 	strbtvc	r7, [ip], #-1377	; 0xfffffa9f
    181c:	4d524100 	ldfmie	f4, [r2, #-0]
    1820:	5343505f 	movtpl	r5, #12383	; 0x305f
    1824:	5041415f 	subpl	r4, r1, pc, asr r1
    1828:	4c5f5343 	mrrcmi	3, 4, r5, pc, cr3	; <UNPREDICTABLE>
    182c:	4c41434f 	mcrrmi	3, 4, r4, r1, cr15
    1830:	52415400 	subpl	r5, r1, #0, 8
    1834:	5f544547 	svcpl	0x00544547
    1838:	5f555043 	svcpl	0x00555043
    183c:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1840:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    1844:	41540035 	cmpmi	r4, r5, lsr r0
    1848:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    184c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1850:	7274735f 	rsbsvc	r7, r4, #2080374785	; 0x7c000001
    1854:	61676e6f 	cmnvs	r7, pc, ror #28
    1858:	61006d72 	tstvs	r0, r2, ror sp
    185c:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1860:	5f686372 	svcpl	0x00686372
    1864:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    1868:	61003162 	tstvs	r0, r2, ror #2
    186c:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1870:	5f686372 	svcpl	0x00686372
    1874:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    1878:	54003262 	strpl	r3, [r0], #-610	; 0xfffffd9e
    187c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1880:	50435f54 	subpl	r5, r3, r4, asr pc
    1884:	77695f55 			; <UNDEFINED> instruction: 0x77695f55
    1888:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
    188c:	6d726100 	ldfvse	f6, [r2, #-0]
    1890:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1894:	00743568 	rsbseq	r3, r4, r8, ror #10
    1898:	5f617369 	svcpl	0x00617369
    189c:	5f746962 	svcpl	0x00746962
    18a0:	6100706d 	tstvs	r0, sp, rrx
    18a4:	6c5f6d72 	mrrcvs	13, 7, r6, pc, cr2	; <UNPREDICTABLE>
    18a8:	63735f64 	cmnvs	r3, #100, 30	; 0x190
    18ac:	00646568 	rsbeq	r6, r4, r8, ror #10
    18b0:	5f6d7261 	svcpl	0x006d7261
    18b4:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    18b8:	00315f38 	eorseq	r5, r1, r8, lsr pc

Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347 	bcc	10d0d24 <_bss_end+0x10c84e4>
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
  10:	4b5a3605 	blmi	168d82c <_bss_end+0x1684fec>
  14:	08070600 	stmdaeq	r7, {r9, sl}
  18:	0a010901 	beq	42424 <_bss_end+0x39be4>
  1c:	14041202 	strne	r1, [r4], #-514	; 0xfffffdfe
  20:	17011501 	strne	r1, [r1, -r1, lsl #10]
  24:	1a011803 	bne	46038 <_bss_end+0x3d7f8>
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
  18:	00008018 	andeq	r8, r0, r8, lsl r0
  1c:	00000038 	andeq	r0, r0, r8, lsr r0
  20:	8b040e42 	blhi	103930 <_bss_end+0xfb0f0>
  24:	0b0d4201 	bleq	350830 <_bss_end+0x347ff0>
  28:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
  2c:	00000ecb 	andeq	r0, r0, fp, asr #29
  30:	0000001c 	andeq	r0, r0, ip, lsl r0
  34:	00000000 	andeq	r0, r0, r0
  38:	00008050 	andeq	r8, r0, r0, asr r0
  3c:	0000002c 	andeq	r0, r0, ip, lsr #32
  40:	8b040e42 	blhi	103950 <_bss_end+0xfb110>
  44:	0b0d4201 	bleq	350850 <_bss_end+0x348010>
  48:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
  4c:	00000ecb 	andeq	r0, r0, fp, asr #29
  50:	0000001c 	andeq	r0, r0, ip, lsl r0
  54:	00000000 	andeq	r0, r0, r0
  58:	0000807c 	andeq	r8, r0, ip, ror r0
  5c:	00000020 	andeq	r0, r0, r0, lsr #32
  60:	8b040e42 	blhi	103970 <_bss_end+0xfb130>
  64:	0b0d4201 	bleq	350870 <_bss_end+0x348030>
  68:	420d0d48 	andmi	r0, sp, #72, 26	; 0x1200
  6c:	00000ecb 	andeq	r0, r0, fp, asr #29
  70:	0000001c 	andeq	r0, r0, ip, lsl r0
  74:	00000000 	andeq	r0, r0, r0
  78:	0000809c 	muleq	r0, ip, r0
  7c:	00000018 	andeq	r0, r0, r8, lsl r0
  80:	8b040e42 	blhi	103990 <_bss_end+0xfb150>
  84:	0b0d4201 	bleq	350890 <_bss_end+0x348050>
  88:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  8c:	00000ecb 	andeq	r0, r0, fp, asr #29
  90:	0000001c 	andeq	r0, r0, ip, lsl r0
  94:	00000000 	andeq	r0, r0, r0
  98:	000080b4 	strheq	r8, [r0], -r4
  9c:	00000018 	andeq	r0, r0, r8, lsl r0
  a0:	8b040e42 	blhi	1039b0 <_bss_end+0xfb170>
  a4:	0b0d4201 	bleq	3508b0 <_bss_end+0x348070>
  a8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  ac:	00000ecb 	andeq	r0, r0, fp, asr #29
  b0:	0000001c 	andeq	r0, r0, ip, lsl r0
  b4:	00000000 	andeq	r0, r0, r0
  b8:	000080cc 	andeq	r8, r0, ip, asr #1
  bc:	00000018 	andeq	r0, r0, r8, lsl r0
  c0:	8b040e42 	blhi	1039d0 <_bss_end+0xfb190>
  c4:	0b0d4201 	bleq	3508d0 <_bss_end+0x348090>
  c8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  cc:	00000ecb 	andeq	r0, r0, fp, asr #29
  d0:	00000014 	andeq	r0, r0, r4, lsl r0
  d4:	00000000 	andeq	r0, r0, r0
  d8:	000080e4 	andeq	r8, r0, r4, ror #1
  dc:	0000000c 	andeq	r0, r0, ip
  e0:	8b040e42 	blhi	1039f0 <_bss_end+0xfb1b0>
  e4:	0b0d4201 	bleq	3508f0 <_bss_end+0x3480b0>
  e8:	0000000c 	andeq	r0, r0, ip
  ec:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  f0:	7c020001 	stcvc	0, cr0, [r2], {1}
  f4:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  f8:	0000001c 	andeq	r0, r0, ip, lsl r0
  fc:	000000e8 	andeq	r0, r0, r8, ror #1
 100:	000080f0 	strdeq	r8, [r0], -r0
 104:	00000034 	andeq	r0, r0, r4, lsr r0
 108:	8b040e42 	blhi	103a18 <_bss_end+0xfb1d8>
 10c:	0b0d4201 	bleq	350918 <_bss_end+0x3480d8>
 110:	420d0d52 	andmi	r0, sp, #5248	; 0x1480
 114:	00000ecb 	andeq	r0, r0, fp, asr #29
 118:	0000001c 	andeq	r0, r0, ip, lsl r0
 11c:	000000e8 	andeq	r0, r0, r8, ror #1
 120:	00008124 	andeq	r8, r0, r4, lsr #2
 124:	00000114 	andeq	r0, r0, r4, lsl r1
 128:	8b040e42 	blhi	103a38 <_bss_end+0xfb1f8>
 12c:	0b0d4201 	bleq	350938 <_bss_end+0x3480f8>
 130:	0d0d8002 	stceq	0, cr8, [sp, #-8]
 134:	000ecb42 	andeq	ip, lr, r2, asr #22
 138:	0000001c 	andeq	r0, r0, ip, lsl r0
 13c:	000000e8 	andeq	r0, r0, r8, ror #1
 140:	00008238 	andeq	r8, r0, r8, lsr r2
 144:	00000074 	andeq	r0, r0, r4, ror r0
 148:	8b040e42 	blhi	103a58 <_bss_end+0xfb218>
 14c:	0b0d4201 	bleq	350958 <_bss_end+0x348118>
 150:	420d0d72 	andmi	r0, sp, #7296	; 0x1c80
 154:	00000ecb 	andeq	r0, r0, fp, asr #29
 158:	0000001c 	andeq	r0, r0, ip, lsl r0
 15c:	000000e8 	andeq	r0, r0, r8, ror #1
 160:	000082ac 	andeq	r8, r0, ip, lsr #5
 164:	00000074 	andeq	r0, r0, r4, ror r0
 168:	8b040e42 	blhi	103a78 <_bss_end+0xfb238>
 16c:	0b0d4201 	bleq	350978 <_bss_end+0x348138>
 170:	420d0d72 	andmi	r0, sp, #7296	; 0x1c80
 174:	00000ecb 	andeq	r0, r0, fp, asr #29
 178:	0000001c 	andeq	r0, r0, ip, lsl r0
 17c:	000000e8 	andeq	r0, r0, r8, ror #1
 180:	00008320 	andeq	r8, r0, r0, lsr #6
 184:	00000074 	andeq	r0, r0, r4, ror r0
 188:	8b040e42 	blhi	103a98 <_bss_end+0xfb258>
 18c:	0b0d4201 	bleq	350998 <_bss_end+0x348158>
 190:	420d0d72 	andmi	r0, sp, #7296	; 0x1c80
 194:	00000ecb 	andeq	r0, r0, fp, asr #29
 198:	0000001c 	andeq	r0, r0, ip, lsl r0
 19c:	000000e8 	andeq	r0, r0, r8, ror #1
 1a0:	00008394 	muleq	r0, r4, r3
 1a4:	000000a8 	andeq	r0, r0, r8, lsr #1
 1a8:	8b080e42 	blhi	203ab8 <_bss_end+0x1fb278>
 1ac:	42018e02 	andmi	r8, r1, #2, 28
 1b0:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 1b4:	080d0c4e 	stmdaeq	sp, {r1, r2, r3, r6, sl, fp}
 1b8:	0000001c 	andeq	r0, r0, ip, lsl r0
 1bc:	000000e8 	andeq	r0, r0, r8, ror #1
 1c0:	0000843c 	andeq	r8, r0, ip, lsr r4
 1c4:	0000007c 	andeq	r0, r0, ip, ror r0
 1c8:	8b080e42 	blhi	203ad8 <_bss_end+0x1fb298>
 1cc:	42018e02 	andmi	r8, r1, #2, 28
 1d0:	78040b0c 	stmdavc	r4, {r2, r3, r8, r9, fp}
 1d4:	00080d0c 	andeq	r0, r8, ip, lsl #26
 1d8:	0000001c 	andeq	r0, r0, ip, lsl r0
 1dc:	000000e8 	andeq	r0, r0, r8, ror #1
 1e0:	000084b8 			; <UNDEFINED> instruction: 0x000084b8
 1e4:	000000d8 	ldrdeq	r0, [r0], -r8
 1e8:	8b080e42 	blhi	203af8 <_bss_end+0x1fb2b8>
 1ec:	42018e02 	andmi	r8, r1, #2, 28
 1f0:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 1f4:	080d0c66 	stmdaeq	sp, {r1, r2, r5, r6, sl, fp}
 1f8:	0000001c 	andeq	r0, r0, ip, lsl r0
 1fc:	000000e8 	andeq	r0, r0, r8, ror #1
 200:	00008590 	muleq	r0, r0, r5
 204:	00000054 	andeq	r0, r0, r4, asr r0
 208:	8b080e42 	blhi	203b18 <_bss_end+0x1fb2d8>
 20c:	42018e02 	andmi	r8, r1, #2, 28
 210:	5e040b0c 	vmlapl.f64	d0, d4, d12
 214:	00080d0c 	andeq	r0, r8, ip, lsl #26
 218:	00000018 	andeq	r0, r0, r8, lsl r0
 21c:	000000e8 	andeq	r0, r0, r8, ror #1
 220:	000085e4 	andeq	r8, r0, r4, ror #11
 224:	0000001c 	andeq	r0, r0, ip, lsl r0
 228:	8b080e42 	blhi	203b38 <_bss_end+0x1fb2f8>
 22c:	42018e02 	andmi	r8, r1, #2, 28
 230:	00040b0c 	andeq	r0, r4, ip, lsl #22
 234:	0000000c 	andeq	r0, r0, ip
 238:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 23c:	7c020001 	stcvc	0, cr0, [r2], {1}
 240:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 244:	00000018 	andeq	r0, r0, r8, lsl r0
 248:	00000234 	andeq	r0, r0, r4, lsr r2
 24c:	00008600 	andeq	r8, r0, r0, lsl #12
 250:	000000ac 	andeq	r0, r0, ip, lsr #1
 254:	8b080e42 	blhi	203b64 <_bss_end+0x1fb324>
 258:	42018e02 	andmi	r8, r1, #2, 28
 25c:	00040b0c 	andeq	r0, r4, ip, lsl #22
 260:	0000000c 	andeq	r0, r0, ip
 264:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 268:	7c020001 	stcvc	0, cr0, [r2], {1}
 26c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 270:	0000001c 	andeq	r0, r0, ip, lsl r0
 274:	00000260 	andeq	r0, r0, r0, ror #4
 278:	000086ac 	andeq	r8, r0, ip, lsr #13
 27c:	00000068 	andeq	r0, r0, r8, rrx
 280:	8b040e42 	blhi	103b90 <_bss_end+0xfb350>
 284:	0b0d4201 	bleq	350a90 <_bss_end+0x348250>
 288:	420d0d68 	andmi	r0, sp, #104, 26	; 0x1a00
 28c:	00000ecb 	andeq	r0, r0, fp, asr #29
 290:	0000001c 	andeq	r0, r0, ip, lsl r0
 294:	00000260 	andeq	r0, r0, r0, ror #4
 298:	00008714 	andeq	r8, r0, r4, lsl r7
 29c:	00000058 	andeq	r0, r0, r8, asr r0
 2a0:	8b080e42 	blhi	203bb0 <_bss_end+0x1fb370>
 2a4:	42018e02 	andmi	r8, r1, #2, 28
 2a8:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 2ac:	00080d0c 	andeq	r0, r8, ip, lsl #26
 2b0:	0000001c 	andeq	r0, r0, ip, lsl r0
 2b4:	00000260 	andeq	r0, r0, r0, ror #4
 2b8:	0000876c 	andeq	r8, r0, ip, ror #14
 2bc:	00000058 	andeq	r0, r0, r8, asr r0
 2c0:	8b080e42 	blhi	203bd0 <_bss_end+0x1fb390>
 2c4:	42018e02 	andmi	r8, r1, #2, 28
 2c8:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 2cc:	00080d0c 	andeq	r0, r8, ip, lsl #26
