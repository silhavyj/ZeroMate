
./kernel:     file format elf32-littlearm


Disassembly of section .text:

00008000 <_start>:
_start():
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/start.s:8
;@ tady budou symboly, ktere chceme na zacatek kodove sekce
.section .text.start

;@ vstupni bod do kernelu - nechame ho vlozit na zacatek kodu
_start:
    mov sp,#0x8000			;@ nastavime stack pointer na spodek zasobniku
    8000:	e3a0d902 	mov	sp, #32768	; 0x8000
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/start.s:9
	bl _c_startup			;@ C startup kod (inicializace prostredi)
    8004:	eb0003f6 	bl	8fe4 <_c_startup>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/start.s:10
	bl _cpp_startup			;@ C++ startup kod (volani globalnich konstruktoru, ...)
    8008:	eb00040f 	bl	904c <_cpp_startup>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/start.s:11
    bl _kernel_main			;@ skocime do hlavniho kodu jadra (v C)
    800c:	eb000387 	bl	8e30 <_kernel_main>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/start.s:12
	bl _cpp_shutdown		;@ C++ shutdown kod (volani globalnich destruktoru, ...)
    8010:	eb000423 	bl	90a4 <_cpp_shutdown>

00008014 <hang>:
hang():
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/start.s:14
hang:
    b hang
    8014:	eafffffe 	b	8014 <hang>

00008018 <__cxa_guard_acquire>:
__cxa_guard_acquire():
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/cxx.cpp:11
    extern "C" int __cxa_guard_acquire(__guard*);
    extern "C" void __cxa_guard_release(__guard*);
    extern "C" void __cxa_guard_abort(__guard*);

    extern "C" int __cxa_guard_acquire(__guard* g)
    {
    8018:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    801c:	e28db000 	add	fp, sp, #0
    8020:	e24dd00c 	sub	sp, sp, #12
    8024:	e50b0008 	str	r0, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/cxx.cpp:12
        return !*(char*)(g);
    8028:	e51b3008 	ldr	r3, [fp, #-8]
    802c:	e5d33000 	ldrb	r3, [r3]
    8030:	e3530000 	cmp	r3, #0
    8034:	03a03001 	moveq	r3, #1
    8038:	13a03000 	movne	r3, #0
    803c:	e6ef3073 	uxtb	r3, r3
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/cxx.cpp:13
    }
    8040:	e1a00003 	mov	r0, r3
    8044:	e28bd000 	add	sp, fp, #0
    8048:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    804c:	e12fff1e 	bx	lr

00008050 <__cxa_guard_release>:
__cxa_guard_release():
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/cxx.cpp:16

    extern "C" void __cxa_guard_release(__guard* g)
    {
    8050:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8054:	e28db000 	add	fp, sp, #0
    8058:	e24dd00c 	sub	sp, sp, #12
    805c:	e50b0008 	str	r0, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/cxx.cpp:17
        *(char*)g = 1;
    8060:	e51b3008 	ldr	r3, [fp, #-8]
    8064:	e3a02001 	mov	r2, #1
    8068:	e5c32000 	strb	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/cxx.cpp:18
    }
    806c:	e320f000 	nop	{0}
    8070:	e28bd000 	add	sp, fp, #0
    8074:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8078:	e12fff1e 	bx	lr

0000807c <__cxa_guard_abort>:
__cxa_guard_abort():
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/cxx.cpp:21

    extern "C" void __cxa_guard_abort(__guard*)
    {
    807c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8080:	e28db000 	add	fp, sp, #0
    8084:	e24dd00c 	sub	sp, sp, #12
    8088:	e50b0008 	str	r0, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/cxx.cpp:22
    }
    808c:	e320f000 	nop	{0}
    8090:	e28bd000 	add	sp, fp, #0
    8094:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8098:	e12fff1e 	bx	lr

0000809c <__dso_handle>:
__dso_handle():
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/cxx.cpp:26
}

extern "C" void __dso_handle()
{
    809c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    80a0:	e28db000 	add	fp, sp, #0
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/cxx.cpp:28
    // ignore dtors for now
}
    80a4:	e320f000 	nop	{0}
    80a8:	e28bd000 	add	sp, fp, #0
    80ac:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    80b0:	e12fff1e 	bx	lr

000080b4 <__cxa_atexit>:
__cxa_atexit():
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/cxx.cpp:31

extern "C" void __cxa_atexit()
{
    80b4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    80b8:	e28db000 	add	fp, sp, #0
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/cxx.cpp:33
    // ignore dtors for now
}
    80bc:	e320f000 	nop	{0}
    80c0:	e28bd000 	add	sp, fp, #0
    80c4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    80c8:	e12fff1e 	bx	lr

000080cc <__cxa_pure_virtual>:
__cxa_pure_virtual():
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/cxx.cpp:36

extern "C" void __cxa_pure_virtual()
{
    80cc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    80d0:	e28db000 	add	fp, sp, #0
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/cxx.cpp:38
    // pure virtual method called
}
    80d4:	e320f000 	nop	{0}
    80d8:	e28bd000 	add	sp, fp, #0
    80dc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    80e0:	e12fff1e 	bx	lr

000080e4 <__aeabi_unwind_cpp_pr1>:
__aeabi_unwind_cpp_pr1():
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/cxx.cpp:41

extern "C" void __aeabi_unwind_cpp_pr1()
{
    80e4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    80e8:	e28db000 	add	fp, sp, #0
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/cxx.cpp:42 (discriminator 1)
    while (true)
    80ec:	eafffffe 	b	80ec <__aeabi_unwind_cpp_pr1+0x8>

000080f0 <_ZN13CGPIO_HandlerC1Ej>:
_ZN13CGPIO_HandlerC2Ej():
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:6
#include <hal/peripherals.h>
#include <drivers/gpio.h>

CGPIO_Handler sGPIO(hal::GPIO_Base);

CGPIO_Handler::CGPIO_Handler(unsigned int gpio_base_addr)
    80f0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    80f4:	e28db000 	add	fp, sp, #0
    80f8:	e24dd00c 	sub	sp, sp, #12
    80fc:	e50b0008 	str	r0, [fp, #-8]
    8100:	e50b100c 	str	r1, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:7
: mGPIO(reinterpret_cast<unsigned int*>(gpio_base_addr))
    8104:	e51b200c 	ldr	r2, [fp, #-12]
    8108:	e51b3008 	ldr	r3, [fp, #-8]
    810c:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:10
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
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:13

bool CGPIO_Handler::Get_GPFSEL_Location(uint32_t pin, uint32_t& reg, uint32_t& bit_idx) const
{
    8124:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8128:	e28db000 	add	fp, sp, #0
    812c:	e24dd014 	sub	sp, sp, #20
    8130:	e50b0008 	str	r0, [fp, #-8]
    8134:	e50b100c 	str	r1, [fp, #-12]
    8138:	e50b2010 	str	r2, [fp, #-16]
    813c:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:14
    if (pin > hal::GPIO_Pin_Count)
    8140:	e51b300c 	ldr	r3, [fp, #-12]
    8144:	e3530036 	cmp	r3, #54	; 0x36
    8148:	9a000001 	bls	8154 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0x30>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:15
        return false;
    814c:	e3a03000 	mov	r3, #0
    8150:	ea000033 	b	8224 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0x100>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:17

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
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:20
    {
        case 0:
            reg = static_cast<uint32_t>(hal::GPIO_Reg::GPFSEL0);
    8188:	e51b3010 	ldr	r3, [fp, #-16]
    818c:	e3a02000 	mov	r2, #0
    8190:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:21
            break;
    8194:	ea000013 	b	81e8 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0xc4>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:23
        case 1:
            reg = static_cast<uint32_t>(hal::GPIO_Reg::GPFSEL1);
    8198:	e51b3010 	ldr	r3, [fp, #-16]
    819c:	e3a02001 	mov	r2, #1
    81a0:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:24
            break;
    81a4:	ea00000f 	b	81e8 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0xc4>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:26
        case 2:
            reg = static_cast<uint32_t>(hal::GPIO_Reg::GPFSEL2);
    81a8:	e51b3010 	ldr	r3, [fp, #-16]
    81ac:	e3a02002 	mov	r2, #2
    81b0:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:27
            break;
    81b4:	ea00000b 	b	81e8 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0xc4>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:29
        case 3:
            reg = static_cast<uint32_t>(hal::GPIO_Reg::GPFSEL3);
    81b8:	e51b3010 	ldr	r3, [fp, #-16]
    81bc:	e3a02003 	mov	r2, #3
    81c0:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:30
            break;
    81c4:	ea000007 	b	81e8 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0xc4>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:32
        case 4:
            reg = static_cast<uint32_t>(hal::GPIO_Reg::GPFSEL4);
    81c8:	e51b3010 	ldr	r3, [fp, #-16]
    81cc:	e3a02004 	mov	r2, #4
    81d0:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:33
            break;
    81d4:	ea000003 	b	81e8 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0xc4>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:35
        case 5:
            reg = static_cast<uint32_t>(hal::GPIO_Reg::GPFSEL5);
    81d8:	e51b3010 	ldr	r3, [fp, #-16]
    81dc:	e3a02005 	mov	r2, #5
    81e0:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:36
            break;
    81e4:	e320f000 	nop	{0}
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:39
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
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:41

    return true;
    8220:	e3a03001 	mov	r3, #1
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:42
}
    8224:	e1a00003 	mov	r0, r3
    8228:	e28bd000 	add	sp, fp, #0
    822c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8230:	e12fff1e 	bx	lr
    8234:	cccccccd 	stclgt	12, cr12, [ip], {205}	; 0xcd

00008238 <_ZNK13CGPIO_Handler18Get_GPCLR_LocationEjRjS0_>:
_ZNK13CGPIO_Handler18Get_GPCLR_LocationEjRjS0_():
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:45

bool CGPIO_Handler::Get_GPCLR_Location(uint32_t pin, uint32_t& reg, uint32_t& bit_idx) const
{
    8238:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    823c:	e28db000 	add	fp, sp, #0
    8240:	e24dd014 	sub	sp, sp, #20
    8244:	e50b0008 	str	r0, [fp, #-8]
    8248:	e50b100c 	str	r1, [fp, #-12]
    824c:	e50b2010 	str	r2, [fp, #-16]
    8250:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:46
    if (pin > hal::GPIO_Pin_Count)
    8254:	e51b300c 	ldr	r3, [fp, #-12]
    8258:	e3530036 	cmp	r3, #54	; 0x36
    825c:	9a000001 	bls	8268 <_ZNK13CGPIO_Handler18Get_GPCLR_LocationEjRjS0_+0x30>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:47
        return false;
    8260:	e3a03000 	mov	r3, #0
    8264:	ea00000c 	b	829c <_ZNK13CGPIO_Handler18Get_GPCLR_LocationEjRjS0_+0x64>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:49

    reg = static_cast<uint32_t>((pin < 32) ? hal::GPIO_Reg::GPCLR0 : hal::GPIO_Reg::GPCLR1);
    8268:	e51b300c 	ldr	r3, [fp, #-12]
    826c:	e353001f 	cmp	r3, #31
    8270:	8a000001 	bhi	827c <_ZNK13CGPIO_Handler18Get_GPCLR_LocationEjRjS0_+0x44>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:49 (discriminator 1)
    8274:	e3a0200a 	mov	r2, #10
    8278:	ea000000 	b	8280 <_ZNK13CGPIO_Handler18Get_GPCLR_LocationEjRjS0_+0x48>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:49 (discriminator 2)
    827c:	e3a0200b 	mov	r2, #11
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:49 (discriminator 4)
    8280:	e51b3010 	ldr	r3, [fp, #-16]
    8284:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:50 (discriminator 4)
    bit_idx = pin % 32;
    8288:	e51b300c 	ldr	r3, [fp, #-12]
    828c:	e203201f 	and	r2, r3, #31
    8290:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8294:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:52 (discriminator 4)

    return true;
    8298:	e3a03001 	mov	r3, #1
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:53
}
    829c:	e1a00003 	mov	r0, r3
    82a0:	e28bd000 	add	sp, fp, #0
    82a4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    82a8:	e12fff1e 	bx	lr

000082ac <_ZNK13CGPIO_Handler18Get_GPSET_LocationEjRjS0_>:
_ZNK13CGPIO_Handler18Get_GPSET_LocationEjRjS0_():
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:56

bool CGPIO_Handler::Get_GPSET_Location(uint32_t pin, uint32_t& reg, uint32_t& bit_idx) const
{
    82ac:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    82b0:	e28db000 	add	fp, sp, #0
    82b4:	e24dd014 	sub	sp, sp, #20
    82b8:	e50b0008 	str	r0, [fp, #-8]
    82bc:	e50b100c 	str	r1, [fp, #-12]
    82c0:	e50b2010 	str	r2, [fp, #-16]
    82c4:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:57
    if (pin > hal::GPIO_Pin_Count)
    82c8:	e51b300c 	ldr	r3, [fp, #-12]
    82cc:	e3530036 	cmp	r3, #54	; 0x36
    82d0:	9a000001 	bls	82dc <_ZNK13CGPIO_Handler18Get_GPSET_LocationEjRjS0_+0x30>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:58
        return false;
    82d4:	e3a03000 	mov	r3, #0
    82d8:	ea00000c 	b	8310 <_ZNK13CGPIO_Handler18Get_GPSET_LocationEjRjS0_+0x64>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:60

    reg = static_cast<uint32_t>((pin < 32) ? hal::GPIO_Reg::GPSET0 : hal::GPIO_Reg::GPSET1);
    82dc:	e51b300c 	ldr	r3, [fp, #-12]
    82e0:	e353001f 	cmp	r3, #31
    82e4:	8a000001 	bhi	82f0 <_ZNK13CGPIO_Handler18Get_GPSET_LocationEjRjS0_+0x44>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:60 (discriminator 1)
    82e8:	e3a02007 	mov	r2, #7
    82ec:	ea000000 	b	82f4 <_ZNK13CGPIO_Handler18Get_GPSET_LocationEjRjS0_+0x48>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:60 (discriminator 2)
    82f0:	e3a02008 	mov	r2, #8
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:60 (discriminator 4)
    82f4:	e51b3010 	ldr	r3, [fp, #-16]
    82f8:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:61 (discriminator 4)
    bit_idx = pin % 32;
    82fc:	e51b300c 	ldr	r3, [fp, #-12]
    8300:	e203201f 	and	r2, r3, #31
    8304:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8308:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:63 (discriminator 4)

    return true;
    830c:	e3a03001 	mov	r3, #1
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:64
}
    8310:	e1a00003 	mov	r0, r3
    8314:	e28bd000 	add	sp, fp, #0
    8318:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    831c:	e12fff1e 	bx	lr

00008320 <_ZNK13CGPIO_Handler18Get_GPLEV_LocationEjRjS0_>:
_ZNK13CGPIO_Handler18Get_GPLEV_LocationEjRjS0_():
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:67

bool CGPIO_Handler::Get_GPLEV_Location(uint32_t pin, uint32_t& reg, uint32_t& bit_idx) const
{
    8320:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8324:	e28db000 	add	fp, sp, #0
    8328:	e24dd014 	sub	sp, sp, #20
    832c:	e50b0008 	str	r0, [fp, #-8]
    8330:	e50b100c 	str	r1, [fp, #-12]
    8334:	e50b2010 	str	r2, [fp, #-16]
    8338:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:68
    if (pin > hal::GPIO_Pin_Count)
    833c:	e51b300c 	ldr	r3, [fp, #-12]
    8340:	e3530036 	cmp	r3, #54	; 0x36
    8344:	9a000001 	bls	8350 <_ZNK13CGPIO_Handler18Get_GPLEV_LocationEjRjS0_+0x30>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:69
        return false;
    8348:	e3a03000 	mov	r3, #0
    834c:	ea00000c 	b	8384 <_ZNK13CGPIO_Handler18Get_GPLEV_LocationEjRjS0_+0x64>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:71

    reg = static_cast<uint32_t>((pin < 32) ? hal::GPIO_Reg::GPLEV0 : hal::GPIO_Reg::GPLEV1);
    8350:	e51b300c 	ldr	r3, [fp, #-12]
    8354:	e353001f 	cmp	r3, #31
    8358:	8a000001 	bhi	8364 <_ZNK13CGPIO_Handler18Get_GPLEV_LocationEjRjS0_+0x44>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:71 (discriminator 1)
    835c:	e3a0200d 	mov	r2, #13
    8360:	ea000000 	b	8368 <_ZNK13CGPIO_Handler18Get_GPLEV_LocationEjRjS0_+0x48>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:71 (discriminator 2)
    8364:	e3a0200e 	mov	r2, #14
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:71 (discriminator 4)
    8368:	e51b3010 	ldr	r3, [fp, #-16]
    836c:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:72 (discriminator 4)
    bit_idx = pin % 32;
    8370:	e51b300c 	ldr	r3, [fp, #-12]
    8374:	e203201f 	and	r2, r3, #31
    8378:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    837c:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:74 (discriminator 4)

    return true;
    8380:	e3a03001 	mov	r3, #1
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:75
}
    8384:	e1a00003 	mov	r0, r3
    8388:	e28bd000 	add	sp, fp, #0
    838c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8390:	e12fff1e 	bx	lr

00008394 <_ZN13CGPIO_Handler17Set_GPIO_FunctionEj14NGPIO_Function>:
_ZN13CGPIO_Handler17Set_GPIO_FunctionEj14NGPIO_Function():
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:78

void CGPIO_Handler::Set_GPIO_Function(uint32_t pin, NGPIO_Function func)
{
    8394:	e92d4800 	push	{fp, lr}
    8398:	e28db004 	add	fp, sp, #4
    839c:	e24dd018 	sub	sp, sp, #24
    83a0:	e50b0010 	str	r0, [fp, #-16]
    83a4:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    83a8:	e1a03002 	mov	r3, r2
    83ac:	e54b3015 	strb	r3, [fp, #-21]	; 0xffffffeb
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:80
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
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:83
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
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:81
        return;
    8430:	e320f000 	nop	{0}
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:84
}
    8434:	e24bd004 	sub	sp, fp, #4
    8438:	e8bd8800 	pop	{fp, pc}

0000843c <_ZNK13CGPIO_Handler17Get_GPIO_FunctionEj>:
_ZNK13CGPIO_Handler17Get_GPIO_FunctionEj():
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:87

NGPIO_Function CGPIO_Handler::Get_GPIO_Function(uint32_t pin) const
{
    843c:	e92d4800 	push	{fp, lr}
    8440:	e28db004 	add	fp, sp, #4
    8444:	e24dd010 	sub	sp, sp, #16
    8448:	e50b0010 	str	r0, [fp, #-16]
    844c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:89
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
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:90
        return NGPIO_Function::Unspecified;
    8478:	e3a03008 	mov	r3, #8
    847c:	ea00000a 	b	84ac <_ZNK13CGPIO_Handler17Get_GPIO_FunctionEj+0x70>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:92

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
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:93 (discriminator 1)
}
    84ac:	e1a00003 	mov	r0, r3
    84b0:	e24bd004 	sub	sp, fp, #4
    84b4:	e8bd8800 	pop	{fp, pc}

000084b8 <_ZN13CGPIO_Handler10Set_OutputEjb>:
_ZN13CGPIO_Handler10Set_OutputEjb():
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:96

void CGPIO_Handler::Set_Output(uint32_t pin, bool set)
{
    84b8:	e92d4800 	push	{fp, lr}
    84bc:	e28db004 	add	fp, sp, #4
    84c0:	e24dd018 	sub	sp, sp, #24
    84c4:	e50b0010 	str	r0, [fp, #-16]
    84c8:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    84cc:	e1a03002 	mov	r3, r2
    84d0:	e54b3015 	strb	r3, [fp, #-21]	; 0xffffffeb
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:98
    uint32_t reg, bit;
    if (!(set && Get_GPSET_Location(pin, reg, bit)) && !(!set && Get_GPCLR_Location(pin, reg, bit)))
    84d4:	e55b3015 	ldrb	r3, [fp, #-21]	; 0xffffffeb
    84d8:	e2233001 	eor	r3, r3, #1
    84dc:	e6ef3073 	uxtb	r3, r3
    84e0:	e3530000 	cmp	r3, #0
    84e4:	1a000009 	bne	8510 <_ZN13CGPIO_Handler10Set_OutputEjb+0x58>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:98 (discriminator 2)
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
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:98 (discriminator 3)
    8510:	e55b3015 	ldrb	r3, [fp, #-21]	; 0xffffffeb
    8514:	e3530000 	cmp	r3, #0
    8518:	1a000009 	bne	8544 <_ZN13CGPIO_Handler10Set_OutputEjb+0x8c>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:98 (discriminator 6)
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
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:98 (discriminator 7)
    8544:	e3a03001 	mov	r3, #1
    8548:	ea000000 	b	8550 <_ZN13CGPIO_Handler10Set_OutputEjb+0x98>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:98 (discriminator 8)
    854c:	e3a03000 	mov	r3, #0
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:98 (discriminator 10)
    8550:	e3530000 	cmp	r3, #0
    8554:	1a00000a 	bne	8584 <_ZN13CGPIO_Handler10Set_OutputEjb+0xcc>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:101
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
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:99
        return;
    8584:	e320f000 	nop	{0}
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:102
}
    8588:	e24bd004 	sub	sp, fp, #4
    858c:	e8bd8800 	pop	{fp, pc}

00008590 <_Z41__static_initialization_and_destruction_0ii>:
_Z41__static_initialization_and_destruction_0ii():
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:102
    8590:	e92d4800 	push	{fp, lr}
    8594:	e28db004 	add	fp, sp, #4
    8598:	e24dd008 	sub	sp, sp, #8
    859c:	e50b0008 	str	r0, [fp, #-8]
    85a0:	e50b100c 	str	r1, [fp, #-12]
    85a4:	e51b3008 	ldr	r3, [fp, #-8]
    85a8:	e3530001 	cmp	r3, #1
    85ac:	1a000006 	bne	85cc <_Z41__static_initialization_and_destruction_0ii+0x3c>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:102 (discriminator 1)
    85b0:	e51b300c 	ldr	r3, [fp, #-12]
    85b4:	e59f201c 	ldr	r2, [pc, #28]	; 85d8 <_Z41__static_initialization_and_destruction_0ii+0x48>
    85b8:	e1530002 	cmp	r3, r2
    85bc:	1a000002 	bne	85cc <_Z41__static_initialization_and_destruction_0ii+0x3c>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:4
CGPIO_Handler sGPIO(hal::GPIO_Base);
    85c0:	e59f1014 	ldr	r1, [pc, #20]	; 85dc <_Z41__static_initialization_and_destruction_0ii+0x4c>
    85c4:	e59f0014 	ldr	r0, [pc, #20]	; 85e0 <_Z41__static_initialization_and_destruction_0ii+0x50>
    85c8:	ebfffec8 	bl	80f0 <_ZN13CGPIO_HandlerC1Ej>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:102
}
    85cc:	e320f000 	nop	{0}
    85d0:	e24bd004 	sub	sp, fp, #4
    85d4:	e8bd8800 	pop	{fp, pc}
    85d8:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>
    85dc:	20200000 	eorcs	r0, r0, r0
    85e0:	0000921c 	andeq	r9, r0, ip, lsl r2

000085e4 <_GLOBAL__sub_I_sGPIO>:
_GLOBAL__sub_I_sGPIO():
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/gpio.cpp:102
    85e4:	e92d4800 	push	{fp, lr}
    85e8:	e28db004 	add	fp, sp, #4
    85ec:	e59f1008 	ldr	r1, [pc, #8]	; 85fc <_GLOBAL__sub_I_sGPIO+0x18>
    85f0:	e3a00001 	mov	r0, #1
    85f4:	ebffffe5 	bl	8590 <_Z41__static_initialization_and_destruction_0ii>
    85f8:	e8bd8800 	pop	{fp, pc}
    85fc:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>

00008600 <_ZN8CMonitorC1Ejjj>:
_ZN8CMonitorC2Ejjj():
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:5
#include <drivers/monitor.h>

CMonitor sMonitor{ 0x30000000, 80, 25 };

CMonitor::CMonitor(unsigned int monitor_base_addr, unsigned int width, unsigned int height)
    8600:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8604:	e28db000 	add	fp, sp, #0
    8608:	e24dd014 	sub	sp, sp, #20
    860c:	e50b0008 	str	r0, [fp, #-8]
    8610:	e50b100c 	str	r1, [fp, #-12]
    8614:	e50b2010 	str	r2, [fp, #-16]
    8618:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:6
: m_monitor{ reinterpret_cast<unsigned char*>(monitor_base_addr) }
    861c:	e51b200c 	ldr	r2, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:10
, m_width{ width }
, m_height{ height }
, m_cursor{ 0, 0 }
, m_number_base{ DEFAULT_NUMBER_BASE }
    8620:	e51b3008 	ldr	r3, [fp, #-8]
    8624:	e5832000 	str	r2, [r3]
    8628:	e51b3008 	ldr	r3, [fp, #-8]
    862c:	e51b2010 	ldr	r2, [fp, #-16]
    8630:	e5832004 	str	r2, [r3, #4]
    8634:	e51b3008 	ldr	r3, [fp, #-8]
    8638:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    863c:	e5832008 	str	r2, [r3, #8]
    8640:	e51b3008 	ldr	r3, [fp, #-8]
    8644:	e3a02000 	mov	r2, #0
    8648:	e583200c 	str	r2, [r3, #12]
    864c:	e51b3008 	ldr	r3, [fp, #-8]
    8650:	e3a02000 	mov	r2, #0
    8654:	e5832010 	str	r2, [r3, #16]
    8658:	e51b3008 	ldr	r3, [fp, #-8]
    865c:	e3a0200a 	mov	r2, #10
    8660:	e5832014 	str	r2, [r3, #20]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:12
{
}
    8664:	e51b3008 	ldr	r3, [fp, #-8]
    8668:	e1a00003 	mov	r0, r3
    866c:	e28bd000 	add	sp, fp, #0
    8670:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8674:	e12fff1e 	bx	lr

00008678 <_ZN8CMonitor5ClearEv>:
_ZN8CMonitor5ClearEv():
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:21
    m_cursor.y = 0;
    m_cursor.y = 0;
}

void CMonitor::Clear()
{
    8678:	e92d4800 	push	{fp, lr}
    867c:	e28db004 	add	fp, sp, #4
    8680:	e24dd010 	sub	sp, sp, #16
    8684:	e50b0010 	str	r0, [fp, #-16]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:22
    Reset_Cursor();
    8688:	e51b0010 	ldr	r0, [fp, #-16]
    868c:	eb000169 	bl	8c38 <_ZN8CMonitor12Reset_CursorEv>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:24

    for (unsigned int y = 0; y < m_height; ++y)
    8690:	e3a03000 	mov	r3, #0
    8694:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:24 (discriminator 1)
    8698:	e51b3010 	ldr	r3, [fp, #-16]
    869c:	e5933008 	ldr	r3, [r3, #8]
    86a0:	e51b2008 	ldr	r2, [fp, #-8]
    86a4:	e1520003 	cmp	r2, r3
    86a8:	2a000019 	bcs	8714 <_ZN8CMonitor5ClearEv+0x9c>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:26
    {
        for (unsigned int x = 0; x < m_width; ++x)
    86ac:	e3a03000 	mov	r3, #0
    86b0:	e50b300c 	str	r3, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:26 (discriminator 3)
    86b4:	e51b3010 	ldr	r3, [fp, #-16]
    86b8:	e5933004 	ldr	r3, [r3, #4]
    86bc:	e51b200c 	ldr	r2, [fp, #-12]
    86c0:	e1520003 	cmp	r2, r3
    86c4:	2a00000e 	bcs	8704 <_ZN8CMonitor5ClearEv+0x8c>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:28 (discriminator 2)
        {
            m_monitor[(y * m_width) + x] = ' ';
    86c8:	e51b3010 	ldr	r3, [fp, #-16]
    86cc:	e5932000 	ldr	r2, [r3]
    86d0:	e51b3010 	ldr	r3, [fp, #-16]
    86d4:	e5933004 	ldr	r3, [r3, #4]
    86d8:	e51b1008 	ldr	r1, [fp, #-8]
    86dc:	e0010391 	mul	r1, r1, r3
    86e0:	e51b300c 	ldr	r3, [fp, #-12]
    86e4:	e0813003 	add	r3, r1, r3
    86e8:	e0823003 	add	r3, r2, r3
    86ec:	e3a02020 	mov	r2, #32
    86f0:	e5c32000 	strb	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:26 (discriminator 2)
        for (unsigned int x = 0; x < m_width; ++x)
    86f4:	e51b300c 	ldr	r3, [fp, #-12]
    86f8:	e2833001 	add	r3, r3, #1
    86fc:	e50b300c 	str	r3, [fp, #-12]
    8700:	eaffffeb 	b	86b4 <_ZN8CMonitor5ClearEv+0x3c>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:24 (discriminator 2)
    for (unsigned int y = 0; y < m_height; ++y)
    8704:	e51b3008 	ldr	r3, [fp, #-8]
    8708:	e2833001 	add	r3, r3, #1
    870c:	e50b3008 	str	r3, [fp, #-8]
    8710:	eaffffe0 	b	8698 <_ZN8CMonitor5ClearEv+0x20>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:31
        }
    }
}
    8714:	e320f000 	nop	{0}
    8718:	e24bd004 	sub	sp, fp, #4
    871c:	e8bd8800 	pop	{fp, pc}

00008720 <_ZN8CMonitor6ScrollEv>:
_ZN8CMonitor6ScrollEv():
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:49
        m_cursor.y = m_height - 1;
    }
}

void CMonitor::Scroll()
{
    8720:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8724:	e28db000 	add	fp, sp, #0
    8728:	e24dd01c 	sub	sp, sp, #28
    872c:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:50
    for (unsigned int y = 1; y < m_height; ++y)
    8730:	e3a03001 	mov	r3, #1
    8734:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:50 (discriminator 1)
    8738:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    873c:	e5933008 	ldr	r3, [r3, #8]
    8740:	e51b2008 	ldr	r2, [fp, #-8]
    8744:	e1520003 	cmp	r2, r3
    8748:	2a000024 	bcs	87e0 <_ZN8CMonitor6ScrollEv+0xc0>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:52
    {
        for (unsigned int x = 0; x < m_width; ++x)
    874c:	e3a03000 	mov	r3, #0
    8750:	e50b300c 	str	r3, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:52 (discriminator 3)
    8754:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8758:	e5933004 	ldr	r3, [r3, #4]
    875c:	e51b200c 	ldr	r2, [fp, #-12]
    8760:	e1520003 	cmp	r2, r3
    8764:	2a000019 	bcs	87d0 <_ZN8CMonitor6ScrollEv+0xb0>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:54 (discriminator 2)
        {
            m_monitor[((y - 1) * m_width) + x] = m_monitor[(y * m_width) + x];
    8768:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    876c:	e5932000 	ldr	r2, [r3]
    8770:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8774:	e5933004 	ldr	r3, [r3, #4]
    8778:	e51b1008 	ldr	r1, [fp, #-8]
    877c:	e0010391 	mul	r1, r1, r3
    8780:	e51b300c 	ldr	r3, [fp, #-12]
    8784:	e0813003 	add	r3, r1, r3
    8788:	e0822003 	add	r2, r2, r3
    878c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8790:	e5931000 	ldr	r1, [r3]
    8794:	e51b3008 	ldr	r3, [fp, #-8]
    8798:	e2433001 	sub	r3, r3, #1
    879c:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    87a0:	e5900004 	ldr	r0, [r0, #4]
    87a4:	e0000390 	mul	r0, r0, r3
    87a8:	e51b300c 	ldr	r3, [fp, #-12]
    87ac:	e0803003 	add	r3, r0, r3
    87b0:	e0813003 	add	r3, r1, r3
    87b4:	e5d22000 	ldrb	r2, [r2]
    87b8:	e6ef2072 	uxtb	r2, r2
    87bc:	e5c32000 	strb	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:52 (discriminator 2)
        for (unsigned int x = 0; x < m_width; ++x)
    87c0:	e51b300c 	ldr	r3, [fp, #-12]
    87c4:	e2833001 	add	r3, r3, #1
    87c8:	e50b300c 	str	r3, [fp, #-12]
    87cc:	eaffffe0 	b	8754 <_ZN8CMonitor6ScrollEv+0x34>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:50 (discriminator 2)
    for (unsigned int y = 1; y < m_height; ++y)
    87d0:	e51b3008 	ldr	r3, [fp, #-8]
    87d4:	e2833001 	add	r3, r3, #1
    87d8:	e50b3008 	str	r3, [fp, #-8]
    87dc:	eaffffd5 	b	8738 <_ZN8CMonitor6ScrollEv+0x18>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:58
        }
    }

    for (unsigned int x = 0; x < m_width; ++x)
    87e0:	e3a03000 	mov	r3, #0
    87e4:	e50b3010 	str	r3, [fp, #-16]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:58 (discriminator 3)
    87e8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    87ec:	e5933004 	ldr	r3, [r3, #4]
    87f0:	e51b2010 	ldr	r2, [fp, #-16]
    87f4:	e1520003 	cmp	r2, r3
    87f8:	2a000010 	bcs	8840 <_ZN8CMonitor6ScrollEv+0x120>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:60 (discriminator 2)
    {
        m_monitor[((m_height - 1) * m_width) + x] = ' ';
    87fc:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8800:	e5932000 	ldr	r2, [r3]
    8804:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8808:	e5933008 	ldr	r3, [r3, #8]
    880c:	e2433001 	sub	r3, r3, #1
    8810:	e51b1018 	ldr	r1, [fp, #-24]	; 0xffffffe8
    8814:	e5911004 	ldr	r1, [r1, #4]
    8818:	e0010391 	mul	r1, r1, r3
    881c:	e51b3010 	ldr	r3, [fp, #-16]
    8820:	e0813003 	add	r3, r1, r3
    8824:	e0823003 	add	r3, r2, r3
    8828:	e3a02020 	mov	r2, #32
    882c:	e5c32000 	strb	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:58 (discriminator 2)
    for (unsigned int x = 0; x < m_width; ++x)
    8830:	e51b3010 	ldr	r3, [fp, #-16]
    8834:	e2833001 	add	r3, r3, #1
    8838:	e50b3010 	str	r3, [fp, #-16]
    883c:	eaffffe9 	b	87e8 <_ZN8CMonitor6ScrollEv+0xc8>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:62
    }
}
    8840:	e320f000 	nop	{0}
    8844:	e28bd000 	add	sp, fp, #0
    8848:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    884c:	e12fff1e 	bx	lr

00008850 <_ZN8CMonitorlsEc>:
_ZN8CMonitorlsEc():
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:70
{
    m_number_base = DEFAULT_NUMBER_BASE;
}

CMonitor& CMonitor::operator<<(char c)
{
    8850:	e92d4800 	push	{fp, lr}
    8854:	e28db004 	add	fp, sp, #4
    8858:	e24dd008 	sub	sp, sp, #8
    885c:	e50b0008 	str	r0, [fp, #-8]
    8860:	e1a03001 	mov	r3, r1
    8864:	e54b3009 	strb	r3, [fp, #-9]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:71
    if (c != '\n')
    8868:	e55b3009 	ldrb	r3, [fp, #-9]
    886c:	e353000a 	cmp	r3, #10
    8870:	0a000012 	beq	88c0 <_ZN8CMonitorlsEc+0x70>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:73
    {
        m_monitor[(m_cursor.y * m_width) + m_cursor.x] = static_cast<unsigned char>(c);
    8874:	e51b3008 	ldr	r3, [fp, #-8]
    8878:	e5932000 	ldr	r2, [r3]
    887c:	e51b3008 	ldr	r3, [fp, #-8]
    8880:	e593300c 	ldr	r3, [r3, #12]
    8884:	e51b1008 	ldr	r1, [fp, #-8]
    8888:	e5911004 	ldr	r1, [r1, #4]
    888c:	e0010391 	mul	r1, r1, r3
    8890:	e51b3008 	ldr	r3, [fp, #-8]
    8894:	e5933010 	ldr	r3, [r3, #16]
    8898:	e0813003 	add	r3, r1, r3
    889c:	e0823003 	add	r3, r2, r3
    88a0:	e55b2009 	ldrb	r2, [fp, #-9]
    88a4:	e5c32000 	strb	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:74
        ++m_cursor.x;
    88a8:	e51b3008 	ldr	r3, [fp, #-8]
    88ac:	e5933010 	ldr	r3, [r3, #16]
    88b0:	e2832001 	add	r2, r3, #1
    88b4:	e51b3008 	ldr	r3, [fp, #-8]
    88b8:	e5832010 	str	r2, [r3, #16]
    88bc:	ea000007 	b	88e0 <_ZN8CMonitorlsEc+0x90>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:78
    }
    else
    {
        m_cursor.x = 0;
    88c0:	e51b3008 	ldr	r3, [fp, #-8]
    88c4:	e3a02000 	mov	r2, #0
    88c8:	e5832010 	str	r2, [r3, #16]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:79
        ++m_cursor.y;
    88cc:	e51b3008 	ldr	r3, [fp, #-8]
    88d0:	e593300c 	ldr	r3, [r3, #12]
    88d4:	e2832001 	add	r2, r3, #1
    88d8:	e51b3008 	ldr	r3, [fp, #-8]
    88dc:	e583200c 	str	r2, [r3, #12]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:82
    }

    Adjust_Cursor();
    88e0:	e51b0008 	ldr	r0, [fp, #-8]
    88e4:	eb0000e1 	bl	8c70 <_ZN8CMonitor13Adjust_CursorEv>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:84

    return *this;
    88e8:	e51b3008 	ldr	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:85
}
    88ec:	e1a00003 	mov	r0, r3
    88f0:	e24bd004 	sub	sp, fp, #4
    88f4:	e8bd8800 	pop	{fp, pc}

000088f8 <_ZN8CMonitorlsEPKc>:
_ZN8CMonitorlsEPKc():
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:88

CMonitor& CMonitor::operator<<(const char* str)
{
    88f8:	e92d4800 	push	{fp, lr}
    88fc:	e28db004 	add	fp, sp, #4
    8900:	e24dd010 	sub	sp, sp, #16
    8904:	e50b0010 	str	r0, [fp, #-16]
    8908:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:89
    for (unsigned int i = 0; str[i] != '\0'; ++i)
    890c:	e3a03000 	mov	r3, #0
    8910:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:89 (discriminator 3)
    8914:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8918:	e51b3008 	ldr	r3, [fp, #-8]
    891c:	e0823003 	add	r3, r2, r3
    8920:	e5d33000 	ldrb	r3, [r3]
    8924:	e3530000 	cmp	r3, #0
    8928:	0a00000a 	beq	8958 <_ZN8CMonitorlsEPKc+0x60>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:91 (discriminator 2)
    {
        *this << str[i];
    892c:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8930:	e51b3008 	ldr	r3, [fp, #-8]
    8934:	e0823003 	add	r3, r2, r3
    8938:	e5d33000 	ldrb	r3, [r3]
    893c:	e1a01003 	mov	r1, r3
    8940:	e51b0010 	ldr	r0, [fp, #-16]
    8944:	ebffffc1 	bl	8850 <_ZN8CMonitorlsEc>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:89 (discriminator 2)
    for (unsigned int i = 0; str[i] != '\0'; ++i)
    8948:	e51b3008 	ldr	r3, [fp, #-8]
    894c:	e2833001 	add	r3, r3, #1
    8950:	e50b3008 	str	r3, [fp, #-8]
    8954:	eaffffee 	b	8914 <_ZN8CMonitorlsEPKc+0x1c>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:94
    }

    Reset_Number_Base();
    8958:	e51b0010 	ldr	r0, [fp, #-16]
    895c:	eb0000e5 	bl	8cf8 <_ZN8CMonitor17Reset_Number_BaseEv>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:96

    return *this;
    8960:	e51b3010 	ldr	r3, [fp, #-16]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:97
}
    8964:	e1a00003 	mov	r0, r3
    8968:	e24bd004 	sub	sp, fp, #4
    896c:	e8bd8800 	pop	{fp, pc}

00008970 <_ZN8CMonitorlsENS_12NNumber_BaseE>:
_ZN8CMonitorlsENS_12NNumber_BaseE():
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:100

CMonitor& CMonitor::operator<<(CMonitor::NNumber_Base number_base)
{
    8970:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8974:	e28db000 	add	fp, sp, #0
    8978:	e24dd00c 	sub	sp, sp, #12
    897c:	e50b0008 	str	r0, [fp, #-8]
    8980:	e50b100c 	str	r1, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:101
    m_number_base = number_base;
    8984:	e51b3008 	ldr	r3, [fp, #-8]
    8988:	e51b200c 	ldr	r2, [fp, #-12]
    898c:	e5832014 	str	r2, [r3, #20]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:103

    return *this;
    8990:	e51b3008 	ldr	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:104
}
    8994:	e1a00003 	mov	r0, r3
    8998:	e28bd000 	add	sp, fp, #0
    899c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    89a0:	e12fff1e 	bx	lr

000089a4 <_ZN8CMonitorlsEj>:
_ZN8CMonitorlsEj():
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:107

CMonitor& CMonitor::operator<<(unsigned int num)
{
    89a4:	e92d4800 	push	{fp, lr}
    89a8:	e28db004 	add	fp, sp, #4
    89ac:	e24dd008 	sub	sp, sp, #8
    89b0:	e50b0008 	str	r0, [fp, #-8]
    89b4:	e50b100c 	str	r1, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:112
    static constexpr unsigned int BUFFER_SIZE = 16;

    static char s_buffer[BUFFER_SIZE];

    itoa(num, s_buffer, static_cast<unsigned int>(m_number_base));
    89b8:	e51b3008 	ldr	r3, [fp, #-8]
    89bc:	e5933014 	ldr	r3, [r3, #20]
    89c0:	e59f202c 	ldr	r2, [pc, #44]	; 89f4 <_ZN8CMonitorlsEj+0x50>
    89c4:	e51b100c 	ldr	r1, [fp, #-12]
    89c8:	e51b0008 	ldr	r0, [fp, #-8]
    89cc:	eb000021 	bl	8a58 <_ZN8CMonitor4itoaEjPcj>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:113
    *this << s_buffer;
    89d0:	e59f101c 	ldr	r1, [pc, #28]	; 89f4 <_ZN8CMonitorlsEj+0x50>
    89d4:	e51b0008 	ldr	r0, [fp, #-8]
    89d8:	ebffffc6 	bl	88f8 <_ZN8CMonitorlsEPKc>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:114
    Reset_Number_Base();
    89dc:	e51b0008 	ldr	r0, [fp, #-8]
    89e0:	eb0000c4 	bl	8cf8 <_ZN8CMonitor17Reset_Number_BaseEv>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:116

    return *this;
    89e4:	e51b3008 	ldr	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:117
}
    89e8:	e1a00003 	mov	r0, r3
    89ec:	e24bd004 	sub	sp, fp, #4
    89f0:	e8bd8800 	pop	{fp, pc}
    89f4:	00009238 	andeq	r9, r0, r8, lsr r2

000089f8 <_ZN8CMonitorlsEb>:
_ZN8CMonitorlsEb():
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:120

CMonitor& CMonitor::operator<<(bool value)
{
    89f8:	e92d4800 	push	{fp, lr}
    89fc:	e28db004 	add	fp, sp, #4
    8a00:	e24dd008 	sub	sp, sp, #8
    8a04:	e50b0008 	str	r0, [fp, #-8]
    8a08:	e1a03001 	mov	r3, r1
    8a0c:	e54b3009 	strb	r3, [fp, #-9]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:121
    if (value)
    8a10:	e55b3009 	ldrb	r3, [fp, #-9]
    8a14:	e3530000 	cmp	r3, #0
    8a18:	0a000003 	beq	8a2c <_ZN8CMonitorlsEb+0x34>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:123
    {
        *this << "true";
    8a1c:	e59f102c 	ldr	r1, [pc, #44]	; 8a50 <_ZN8CMonitorlsEb+0x58>
    8a20:	e51b0008 	ldr	r0, [fp, #-8]
    8a24:	ebffffb3 	bl	88f8 <_ZN8CMonitorlsEPKc>
    8a28:	ea000002 	b	8a38 <_ZN8CMonitorlsEb+0x40>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:127
    }
    else
    {
        *this << "false";
    8a2c:	e59f1020 	ldr	r1, [pc, #32]	; 8a54 <_ZN8CMonitorlsEb+0x5c>
    8a30:	e51b0008 	ldr	r0, [fp, #-8]
    8a34:	ebffffaf 	bl	88f8 <_ZN8CMonitorlsEPKc>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:130
    }

    Reset_Number_Base();
    8a38:	e51b0008 	ldr	r0, [fp, #-8]
    8a3c:	eb0000ad 	bl	8cf8 <_ZN8CMonitor17Reset_Number_BaseEv>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:132

    return *this;
    8a40:	e51b3008 	ldr	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:133
}
    8a44:	e1a00003 	mov	r0, r3
    8a48:	e24bd004 	sub	sp, fp, #4
    8a4c:	e8bd8800 	pop	{fp, pc}
    8a50:	00009160 	andeq	r9, r0, r0, ror #2
    8a54:	00009168 	andeq	r9, r0, r8, ror #2

00008a58 <_ZN8CMonitor4itoaEjPcj>:
_ZN8CMonitor4itoaEjPcj():
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:178

    return a;
}

void CMonitor::itoa(unsigned int input, char* output, unsigned int base)
{
    8a58:	e92d4800 	push	{fp, lr}
    8a5c:	e28db004 	add	fp, sp, #4
    8a60:	e24dd020 	sub	sp, sp, #32
    8a64:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8a68:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    8a6c:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    8a70:	e50b3024 	str	r3, [fp, #-36]	; 0xffffffdc
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:179
    int i = 0;
    8a74:	e3a03000 	mov	r3, #0
    8a78:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:181

    while (input > 0)
    8a7c:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8a80:	e3530000 	cmp	r3, #0
    8a84:	0a000014 	beq	8adc <_ZN8CMonitor4itoaEjPcj+0x84>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:183
    {
        output[i] = CharConvArr[Remainder(input, base)];
    8a88:	e51b2024 	ldr	r2, [fp, #-36]	; 0xffffffdc
    8a8c:	e51b101c 	ldr	r1, [fp, #-28]	; 0xffffffe4
    8a90:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    8a94:	eb0000c6 	bl	8db4 <_ZN8CMonitor9RemainderEjj>
    8a98:	e1a03000 	mov	r3, r0
    8a9c:	e59f211c 	ldr	r2, [pc, #284]	; 8bc0 <_ZN8CMonitor4itoaEjPcj+0x168>
    8aa0:	e0832002 	add	r2, r3, r2
    8aa4:	e51b3008 	ldr	r3, [fp, #-8]
    8aa8:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    8aac:	e0813003 	add	r3, r1, r3
    8ab0:	e5d22000 	ldrb	r2, [r2]
    8ab4:	e5c32000 	strb	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:184
        input = Divide(input, base);
    8ab8:	e51b2024 	ldr	r2, [fp, #-36]	; 0xffffffdc
    8abc:	e51b101c 	ldr	r1, [fp, #-28]	; 0xffffffe4
    8ac0:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    8ac4:	eb000096 	bl	8d24 <_ZN8CMonitor6DivideEjj>
    8ac8:	e50b001c 	str	r0, [fp, #-28]	; 0xffffffe4
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:185
        i++;
    8acc:	e51b3008 	ldr	r3, [fp, #-8]
    8ad0:	e2833001 	add	r3, r3, #1
    8ad4:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:181
    while (input > 0)
    8ad8:	eaffffe7 	b	8a7c <_ZN8CMonitor4itoaEjPcj+0x24>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:188
    }

    if (i == 0)
    8adc:	e51b3008 	ldr	r3, [fp, #-8]
    8ae0:	e3530000 	cmp	r3, #0
    8ae4:	1a000007 	bne	8b08 <_ZN8CMonitor4itoaEjPcj+0xb0>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:190
    {
        output[i] = CharConvArr[0];
    8ae8:	e51b3008 	ldr	r3, [fp, #-8]
    8aec:	e51b2020 	ldr	r2, [fp, #-32]	; 0xffffffe0
    8af0:	e0823003 	add	r3, r2, r3
    8af4:	e3a02030 	mov	r2, #48	; 0x30
    8af8:	e5c32000 	strb	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:191
        i++;
    8afc:	e51b3008 	ldr	r3, [fp, #-8]
    8b00:	e2833001 	add	r3, r3, #1
    8b04:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:194
    }

    output[i] = '\0';
    8b08:	e51b3008 	ldr	r3, [fp, #-8]
    8b0c:	e51b2020 	ldr	r2, [fp, #-32]	; 0xffffffe0
    8b10:	e0823003 	add	r3, r2, r3
    8b14:	e3a02000 	mov	r2, #0
    8b18:	e5c32000 	strb	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:195
    i--;
    8b1c:	e51b3008 	ldr	r3, [fp, #-8]
    8b20:	e2433001 	sub	r3, r3, #1
    8b24:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:197

    for (int j = 0; j <= (i >> 1); j++)
    8b28:	e3a03000 	mov	r3, #0
    8b2c:	e50b300c 	str	r3, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:197 (discriminator 3)
    8b30:	e51b3008 	ldr	r3, [fp, #-8]
    8b34:	e1a030c3 	asr	r3, r3, #1
    8b38:	e51b200c 	ldr	r2, [fp, #-12]
    8b3c:	e1520003 	cmp	r2, r3
    8b40:	ca00001b 	bgt	8bb4 <_ZN8CMonitor4itoaEjPcj+0x15c>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:199 (discriminator 2)
    {
        char c = output[i - j];
    8b44:	e51b2008 	ldr	r2, [fp, #-8]
    8b48:	e51b300c 	ldr	r3, [fp, #-12]
    8b4c:	e0423003 	sub	r3, r2, r3
    8b50:	e1a02003 	mov	r2, r3
    8b54:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8b58:	e0833002 	add	r3, r3, r2
    8b5c:	e5d33000 	ldrb	r3, [r3]
    8b60:	e54b300d 	strb	r3, [fp, #-13]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:200 (discriminator 2)
        output[i - j] = output[j];
    8b64:	e51b300c 	ldr	r3, [fp, #-12]
    8b68:	e51b2020 	ldr	r2, [fp, #-32]	; 0xffffffe0
    8b6c:	e0822003 	add	r2, r2, r3
    8b70:	e51b1008 	ldr	r1, [fp, #-8]
    8b74:	e51b300c 	ldr	r3, [fp, #-12]
    8b78:	e0413003 	sub	r3, r1, r3
    8b7c:	e1a01003 	mov	r1, r3
    8b80:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8b84:	e0833001 	add	r3, r3, r1
    8b88:	e5d22000 	ldrb	r2, [r2]
    8b8c:	e5c32000 	strb	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:201 (discriminator 2)
        output[j] = c;
    8b90:	e51b300c 	ldr	r3, [fp, #-12]
    8b94:	e51b2020 	ldr	r2, [fp, #-32]	; 0xffffffe0
    8b98:	e0823003 	add	r3, r2, r3
    8b9c:	e55b200d 	ldrb	r2, [fp, #-13]
    8ba0:	e5c32000 	strb	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:197 (discriminator 2)
    for (int j = 0; j <= (i >> 1); j++)
    8ba4:	e51b300c 	ldr	r3, [fp, #-12]
    8ba8:	e2833001 	add	r3, r3, #1
    8bac:	e50b300c 	str	r3, [fp, #-12]
    8bb0:	eaffffde 	b	8b30 <_ZN8CMonitor4itoaEjPcj+0xd8>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:203
    }
}
    8bb4:	e320f000 	nop	{0}
    8bb8:	e24bd004 	sub	sp, fp, #4
    8bbc:	e8bd8800 	pop	{fp, pc}
    8bc0:	00009170 	andeq	r9, r0, r0, ror r1

00008bc4 <_Z41__static_initialization_and_destruction_0ii>:
_Z41__static_initialization_and_destruction_0ii():
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:203
    8bc4:	e92d4800 	push	{fp, lr}
    8bc8:	e28db004 	add	fp, sp, #4
    8bcc:	e24dd008 	sub	sp, sp, #8
    8bd0:	e50b0008 	str	r0, [fp, #-8]
    8bd4:	e50b100c 	str	r1, [fp, #-12]
    8bd8:	e51b3008 	ldr	r3, [fp, #-8]
    8bdc:	e3530001 	cmp	r3, #1
    8be0:	1a000008 	bne	8c08 <_Z41__static_initialization_and_destruction_0ii+0x44>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:203 (discriminator 1)
    8be4:	e51b300c 	ldr	r3, [fp, #-12]
    8be8:	e59f2024 	ldr	r2, [pc, #36]	; 8c14 <_Z41__static_initialization_and_destruction_0ii+0x50>
    8bec:	e1530002 	cmp	r3, r2
    8bf0:	1a000004 	bne	8c08 <_Z41__static_initialization_and_destruction_0ii+0x44>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:3
CMonitor sMonitor{ 0x30000000, 80, 25 };
    8bf4:	e3a03019 	mov	r3, #25
    8bf8:	e3a02050 	mov	r2, #80	; 0x50
    8bfc:	e3a01203 	mov	r1, #805306368	; 0x30000000
    8c00:	e59f0010 	ldr	r0, [pc, #16]	; 8c18 <_Z41__static_initialization_and_destruction_0ii+0x54>
    8c04:	ebfffe7d 	bl	8600 <_ZN8CMonitorC1Ejjj>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:203
}
    8c08:	e320f000 	nop	{0}
    8c0c:	e24bd004 	sub	sp, fp, #4
    8c10:	e8bd8800 	pop	{fp, pc}
    8c14:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>
    8c18:	00009220 	andeq	r9, r0, r0, lsr #4

00008c1c <_GLOBAL__sub_I_sMonitor>:
_GLOBAL__sub_I_sMonitor():
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:203
    8c1c:	e92d4800 	push	{fp, lr}
    8c20:	e28db004 	add	fp, sp, #4
    8c24:	e59f1008 	ldr	r1, [pc, #8]	; 8c34 <_GLOBAL__sub_I_sMonitor+0x18>
    8c28:	e3a00001 	mov	r0, #1
    8c2c:	ebffffe4 	bl	8bc4 <_Z41__static_initialization_and_destruction_0ii>
    8c30:	e8bd8800 	pop	{fp, pc}
    8c34:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>

00008c38 <_ZN8CMonitor12Reset_CursorEv>:
_ZN8CMonitor12Reset_CursorEv():
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:15
{
    8c38:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8c3c:	e28db000 	add	fp, sp, #0
    8c40:	e24dd00c 	sub	sp, sp, #12
    8c44:	e50b0008 	str	r0, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:16
    m_cursor.y = 0;
    8c48:	e51b3008 	ldr	r3, [fp, #-8]
    8c4c:	e3a02000 	mov	r2, #0
    8c50:	e583200c 	str	r2, [r3, #12]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:17
    m_cursor.y = 0;
    8c54:	e51b3008 	ldr	r3, [fp, #-8]
    8c58:	e3a02000 	mov	r2, #0
    8c5c:	e583200c 	str	r2, [r3, #12]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:18
}
    8c60:	e320f000 	nop	{0}
    8c64:	e28bd000 	add	sp, fp, #0
    8c68:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8c6c:	e12fff1e 	bx	lr

00008c70 <_ZN8CMonitor13Adjust_CursorEv>:
_ZN8CMonitor13Adjust_CursorEv():
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:34
{
    8c70:	e92d4800 	push	{fp, lr}
    8c74:	e28db004 	add	fp, sp, #4
    8c78:	e24dd008 	sub	sp, sp, #8
    8c7c:	e50b0008 	str	r0, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:35
    if (m_cursor.x >= m_width)
    8c80:	e51b3008 	ldr	r3, [fp, #-8]
    8c84:	e5932010 	ldr	r2, [r3, #16]
    8c88:	e51b3008 	ldr	r3, [fp, #-8]
    8c8c:	e5933004 	ldr	r3, [r3, #4]
    8c90:	e1520003 	cmp	r2, r3
    8c94:	3a000007 	bcc	8cb8 <_ZN8CMonitor13Adjust_CursorEv+0x48>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:37
        m_cursor.x = 0;
    8c98:	e51b3008 	ldr	r3, [fp, #-8]
    8c9c:	e3a02000 	mov	r2, #0
    8ca0:	e5832010 	str	r2, [r3, #16]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:38
        ++m_cursor.y;
    8ca4:	e51b3008 	ldr	r3, [fp, #-8]
    8ca8:	e593300c 	ldr	r3, [r3, #12]
    8cac:	e2832001 	add	r2, r3, #1
    8cb0:	e51b3008 	ldr	r3, [fp, #-8]
    8cb4:	e583200c 	str	r2, [r3, #12]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:41
    if (m_cursor.y >= m_height)
    8cb8:	e51b3008 	ldr	r3, [fp, #-8]
    8cbc:	e593200c 	ldr	r2, [r3, #12]
    8cc0:	e51b3008 	ldr	r3, [fp, #-8]
    8cc4:	e5933008 	ldr	r3, [r3, #8]
    8cc8:	e1520003 	cmp	r2, r3
    8ccc:	3a000006 	bcc	8cec <_ZN8CMonitor13Adjust_CursorEv+0x7c>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:43
        Scroll();
    8cd0:	e51b0008 	ldr	r0, [fp, #-8]
    8cd4:	ebfffe91 	bl	8720 <_ZN8CMonitor6ScrollEv>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:44
        m_cursor.y = m_height - 1;
    8cd8:	e51b3008 	ldr	r3, [fp, #-8]
    8cdc:	e5933008 	ldr	r3, [r3, #8]
    8ce0:	e2432001 	sub	r2, r3, #1
    8ce4:	e51b3008 	ldr	r3, [fp, #-8]
    8ce8:	e583200c 	str	r2, [r3, #12]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:46
}
    8cec:	e320f000 	nop	{0}
    8cf0:	e24bd004 	sub	sp, fp, #4
    8cf4:	e8bd8800 	pop	{fp, pc}

00008cf8 <_ZN8CMonitor17Reset_Number_BaseEv>:
_ZN8CMonitor17Reset_Number_BaseEv():
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:65
{
    8cf8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8cfc:	e28db000 	add	fp, sp, #0
    8d00:	e24dd00c 	sub	sp, sp, #12
    8d04:	e50b0008 	str	r0, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:66
    m_number_base = DEFAULT_NUMBER_BASE;
    8d08:	e51b3008 	ldr	r3, [fp, #-8]
    8d0c:	e3a0200a 	mov	r2, #10
    8d10:	e5832014 	str	r2, [r3, #20]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:67
}
    8d14:	e320f000 	nop	{0}
    8d18:	e28bd000 	add	sp, fp, #0
    8d1c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8d20:	e12fff1e 	bx	lr

00008d24 <_ZN8CMonitor6DivideEjj>:
_ZN8CMonitor6DivideEjj():
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:136
{
    8d24:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8d28:	e28db000 	add	fp, sp, #0
    8d2c:	e24dd01c 	sub	sp, sp, #28
    8d30:	e50b0010 	str	r0, [fp, #-16]
    8d34:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8d38:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:137
    if (b == 0)
    8d3c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8d40:	e3530000 	cmp	r3, #0
    8d44:	1a000001 	bne	8d50 <_ZN8CMonitor6DivideEjj+0x2c>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:140
        return 0;
    8d48:	e3a03000 	mov	r3, #0
    8d4c:	ea000014 	b	8da4 <_ZN8CMonitor6DivideEjj+0x80>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:142
    if (a < b)
    8d50:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8d54:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8d58:	e1520003 	cmp	r2, r3
    8d5c:	2a000001 	bcs	8d68 <_ZN8CMonitor6DivideEjj+0x44>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:144
        return 0;
    8d60:	e3a03000 	mov	r3, #0
    8d64:	ea00000e 	b	8da4 <_ZN8CMonitor6DivideEjj+0x80>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:147
    unsigned int quotient = 0;
    8d68:	e3a03000 	mov	r3, #0
    8d6c:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:149
    while (a >= b)
    8d70:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8d74:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8d78:	e1520003 	cmp	r2, r3
    8d7c:	3a000007 	bcc	8da0 <_ZN8CMonitor6DivideEjj+0x7c>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:151
        a -= b;
    8d80:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8d84:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8d88:	e0423003 	sub	r3, r2, r3
    8d8c:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:152
        quotient++;
    8d90:	e51b3008 	ldr	r3, [fp, #-8]
    8d94:	e2833001 	add	r3, r3, #1
    8d98:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:149
    while (a >= b)
    8d9c:	eafffff3 	b	8d70 <_ZN8CMonitor6DivideEjj+0x4c>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:155
    return quotient;
    8da0:	e51b3008 	ldr	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:156
}
    8da4:	e1a00003 	mov	r0, r3
    8da8:	e28bd000 	add	sp, fp, #0
    8dac:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8db0:	e12fff1e 	bx	lr

00008db4 <_ZN8CMonitor9RemainderEjj>:
_ZN8CMonitor9RemainderEjj():
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:159
{
    8db4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8db8:	e28db000 	add	fp, sp, #0
    8dbc:	e24dd014 	sub	sp, sp, #20
    8dc0:	e50b0008 	str	r0, [fp, #-8]
    8dc4:	e50b100c 	str	r1, [fp, #-12]
    8dc8:	e50b2010 	str	r2, [fp, #-16]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:160
    if (b == 0)
    8dcc:	e51b3010 	ldr	r3, [fp, #-16]
    8dd0:	e3530000 	cmp	r3, #0
    8dd4:	1a000001 	bne	8de0 <_ZN8CMonitor9RemainderEjj+0x2c>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:163
        return 0;
    8dd8:	e3a03000 	mov	r3, #0
    8ddc:	ea00000f 	b	8e20 <_ZN8CMonitor9RemainderEjj+0x6c>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:165
    if (a < b)
    8de0:	e51b200c 	ldr	r2, [fp, #-12]
    8de4:	e51b3010 	ldr	r3, [fp, #-16]
    8de8:	e1520003 	cmp	r2, r3
    8dec:	2a000001 	bcs	8df8 <_ZN8CMonitor9RemainderEjj+0x44>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:167
        return a;
    8df0:	e51b300c 	ldr	r3, [fp, #-12]
    8df4:	ea000009 	b	8e20 <_ZN8CMonitor9RemainderEjj+0x6c>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:169
    while (a >= b)
    8df8:	e51b200c 	ldr	r2, [fp, #-12]
    8dfc:	e51b3010 	ldr	r3, [fp, #-16]
    8e00:	e1520003 	cmp	r2, r3
    8e04:	3a000004 	bcc	8e1c <_ZN8CMonitor9RemainderEjj+0x68>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:171
        a -= b;
    8e08:	e51b200c 	ldr	r2, [fp, #-12]
    8e0c:	e51b3010 	ldr	r3, [fp, #-16]
    8e10:	e0423003 	sub	r3, r2, r3
    8e14:	e50b300c 	str	r3, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:169
    while (a >= b)
    8e18:	eafffff6 	b	8df8 <_ZN8CMonitor9RemainderEjj+0x44>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:174
    return a;
    8e1c:	e51b300c 	ldr	r3, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/drivers/monitor.cpp:175
}
    8e20:	e1a00003 	mov	r0, r3
    8e24:	e28bd000 	add	sp, fp, #0
    8e28:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8e2c:	e12fff1e 	bx	lr

00008e30 <_kernel_main>:
_kernel_main():
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/main.cpp:8

// GPIO pin 47 je pripojeny na LED na desce (tzv. ACT LED)
constexpr uint32_t ACT_Pin = 47;

extern "C" int _kernel_main(void)
{
    8e30:	e92d4800 	push	{fp, lr}
    8e34:	e28db004 	add	fp, sp, #4
    8e38:	e24dd008 	sub	sp, sp, #8
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/main.cpp:9
    sMonitor.Clear();
    8e3c:	e59f0174 	ldr	r0, [pc, #372]	; 8fb8 <_kernel_main+0x188>
    8e40:	ebfffe0c 	bl	8678 <_ZN8CMonitor5ClearEv>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/main.cpp:10
    sMonitor << "Hello from the kernel :)\n\n";
    8e44:	e59f1170 	ldr	r1, [pc, #368]	; 8fbc <_kernel_main+0x18c>
    8e48:	e59f0168 	ldr	r0, [pc, #360]	; 8fb8 <_kernel_main+0x188>
    8e4c:	ebfffea9 	bl	88f8 <_ZN8CMonitorlsEPKc>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/main.cpp:12
    
    sMonitor << "Running monitor tests...\nVariable x = " << 137U << "; variable y = 0x" << CMonitor::NNumber_Base::HEX << 199999U << '\n';
    8e50:	e59f1168 	ldr	r1, [pc, #360]	; 8fc0 <_kernel_main+0x190>
    8e54:	e59f015c 	ldr	r0, [pc, #348]	; 8fb8 <_kernel_main+0x188>
    8e58:	ebfffea6 	bl	88f8 <_ZN8CMonitorlsEPKc>
    8e5c:	e1a03000 	mov	r3, r0
    8e60:	e3a01089 	mov	r1, #137	; 0x89
    8e64:	e1a00003 	mov	r0, r3
    8e68:	ebfffecd 	bl	89a4 <_ZN8CMonitorlsEj>
    8e6c:	e1a03000 	mov	r3, r0
    8e70:	e59f114c 	ldr	r1, [pc, #332]	; 8fc4 <_kernel_main+0x194>
    8e74:	e1a00003 	mov	r0, r3
    8e78:	ebfffe9e 	bl	88f8 <_ZN8CMonitorlsEPKc>
    8e7c:	e1a03000 	mov	r3, r0
    8e80:	e3a01010 	mov	r1, #16
    8e84:	e1a00003 	mov	r0, r3
    8e88:	ebfffeb8 	bl	8970 <_ZN8CMonitorlsENS_12NNumber_BaseE>
    8e8c:	e1a03000 	mov	r3, r0
    8e90:	e59f1130 	ldr	r1, [pc, #304]	; 8fc8 <_kernel_main+0x198>
    8e94:	e1a00003 	mov	r0, r3
    8e98:	ebfffec1 	bl	89a4 <_ZN8CMonitorlsEj>
    8e9c:	e1a03000 	mov	r3, r0
    8ea0:	e3a0100a 	mov	r1, #10
    8ea4:	e1a00003 	mov	r0, r3
    8ea8:	ebfffe68 	bl	8850 <_ZN8CMonitorlsEc>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/main.cpp:13
    sMonitor << "15 == 0 is " << (15 == 0) << '\n';
    8eac:	e59f1118 	ldr	r1, [pc, #280]	; 8fcc <_kernel_main+0x19c>
    8eb0:	e59f0100 	ldr	r0, [pc, #256]	; 8fb8 <_kernel_main+0x188>
    8eb4:	ebfffe8f 	bl	88f8 <_ZN8CMonitorlsEPKc>
    8eb8:	e1a03000 	mov	r3, r0
    8ebc:	e3a01000 	mov	r1, #0
    8ec0:	e1a00003 	mov	r0, r3
    8ec4:	ebfffecb 	bl	89f8 <_ZN8CMonitorlsEb>
    8ec8:	e1a03000 	mov	r3, r0
    8ecc:	e3a0100a 	mov	r1, #10
    8ed0:	e1a00003 	mov	r0, r3
    8ed4:	ebfffe5d 	bl	8850 <_ZN8CMonitorlsEc>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/main.cpp:14
    sMonitor << "15 != 0 is " << (15 != 0) << "\n\n";
    8ed8:	e59f10f0 	ldr	r1, [pc, #240]	; 8fd0 <_kernel_main+0x1a0>
    8edc:	e59f00d4 	ldr	r0, [pc, #212]	; 8fb8 <_kernel_main+0x188>
    8ee0:	ebfffe84 	bl	88f8 <_ZN8CMonitorlsEPKc>
    8ee4:	e1a03000 	mov	r3, r0
    8ee8:	e3a01001 	mov	r1, #1
    8eec:	e1a00003 	mov	r0, r3
    8ef0:	ebfffec0 	bl	89f8 <_ZN8CMonitorlsEb>
    8ef4:	e1a03000 	mov	r3, r0
    8ef8:	e59f10d4 	ldr	r1, [pc, #212]	; 8fd4 <_kernel_main+0x1a4>
    8efc:	e1a00003 	mov	r0, r3
    8f00:	ebfffe7c 	bl	88f8 <_ZN8CMonitorlsEPKc>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/main.cpp:17
    
    // nastavime ACT LED pin na vystupni
    sGPIO.Set_GPIO_Function(ACT_Pin, NGPIO_Function::Output);
    8f04:	e3a02001 	mov	r2, #1
    8f08:	e3a0102f 	mov	r1, #47	; 0x2f
    8f0c:	e59f00c4 	ldr	r0, [pc, #196]	; 8fd8 <_kernel_main+0x1a8>
    8f10:	ebfffd1f 	bl	8394 <_ZN13CGPIO_Handler17Set_GPIO_FunctionEj14NGPIO_Function>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/main.cpp:24
    volatile unsigned int tim;

    while (1)
    {
        // spalime 500000 taktu (cekani par milisekund)
        for (tim = 0; tim < 0x5000; tim++)
    8f14:	e3a03000 	mov	r3, #0
    8f18:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/main.cpp:24 (discriminator 3)
    8f1c:	e51b3008 	ldr	r3, [fp, #-8]
    8f20:	e3530a05 	cmp	r3, #20480	; 0x5000
    8f24:	33a03001 	movcc	r3, #1
    8f28:	23a03000 	movcs	r3, #0
    8f2c:	e6ef3073 	uxtb	r3, r3
    8f30:	e3530000 	cmp	r3, #0
    8f34:	0a000003 	beq	8f48 <_kernel_main+0x118>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/main.cpp:24 (discriminator 2)
    8f38:	e51b3008 	ldr	r3, [fp, #-8]
    8f3c:	e2833001 	add	r3, r3, #1
    8f40:	e50b3008 	str	r3, [fp, #-8]
    8f44:	eafffff4 	b	8f1c <_kernel_main+0xec>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/main.cpp:28
            ;

        // zhasneme LED
        sGPIO.Set_Output(ACT_Pin, true);
    8f48:	e3a02001 	mov	r2, #1
    8f4c:	e3a0102f 	mov	r1, #47	; 0x2f
    8f50:	e59f0080 	ldr	r0, [pc, #128]	; 8fd8 <_kernel_main+0x1a8>
    8f54:	ebfffd57 	bl	84b8 <_ZN13CGPIO_Handler10Set_OutputEjb>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/main.cpp:29
        sMonitor << "LED is ON\n";
    8f58:	e59f107c 	ldr	r1, [pc, #124]	; 8fdc <_kernel_main+0x1ac>
    8f5c:	e59f0054 	ldr	r0, [pc, #84]	; 8fb8 <_kernel_main+0x188>
    8f60:	ebfffe64 	bl	88f8 <_ZN8CMonitorlsEPKc>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/main.cpp:32

        // opet cekani
        for (tim = 0; tim < 0x5000; tim++)
    8f64:	e3a03000 	mov	r3, #0
    8f68:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/main.cpp:32 (discriminator 3)
    8f6c:	e51b3008 	ldr	r3, [fp, #-8]
    8f70:	e3530a05 	cmp	r3, #20480	; 0x5000
    8f74:	33a03001 	movcc	r3, #1
    8f78:	23a03000 	movcs	r3, #0
    8f7c:	e6ef3073 	uxtb	r3, r3
    8f80:	e3530000 	cmp	r3, #0
    8f84:	0a000003 	beq	8f98 <_kernel_main+0x168>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/main.cpp:32 (discriminator 2)
    8f88:	e51b3008 	ldr	r3, [fp, #-8]
    8f8c:	e2833001 	add	r3, r3, #1
    8f90:	e50b3008 	str	r3, [fp, #-8]
    8f94:	eafffff4 	b	8f6c <_kernel_main+0x13c>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/main.cpp:36
            ;

        // rozsvitime LED
        sGPIO.Set_Output(ACT_Pin, false);
    8f98:	e3a02000 	mov	r2, #0
    8f9c:	e3a0102f 	mov	r1, #47	; 0x2f
    8fa0:	e59f0030 	ldr	r0, [pc, #48]	; 8fd8 <_kernel_main+0x1a8>
    8fa4:	ebfffd43 	bl	84b8 <_ZN13CGPIO_Handler10Set_OutputEjb>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/main.cpp:37
        sMonitor << "LED is OFF\n";
    8fa8:	e59f1030 	ldr	r1, [pc, #48]	; 8fe0 <_kernel_main+0x1b0>
    8fac:	e59f0004 	ldr	r0, [pc, #4]	; 8fb8 <_kernel_main+0x188>
    8fb0:	ebfffe50 	bl	88f8 <_ZN8CMonitorlsEPKc>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/main.cpp:24
        for (tim = 0; tim < 0x5000; tim++)
    8fb4:	eaffffd6 	b	8f14 <_kernel_main+0xe4>
    8fb8:	00009220 	andeq	r9, r0, r0, lsr #4
    8fbc:	00009188 	andeq	r9, r0, r8, lsl #3
    8fc0:	000091a4 	andeq	r9, r0, r4, lsr #3
    8fc4:	000091cc 	andeq	r9, r0, ip, asr #3
    8fc8:	00030d3f 	andeq	r0, r3, pc, lsr sp
    8fcc:	000091e0 	andeq	r9, r0, r0, ror #3
    8fd0:	000091ec 	andeq	r9, r0, ip, ror #3
    8fd4:	000091f8 	strdeq	r9, [r0], -r8
    8fd8:	0000921c 	andeq	r9, r0, ip, lsl r2
    8fdc:	000091fc 	strdeq	r9, [r0], -ip
    8fe0:	00009208 	andeq	r9, r0, r8, lsl #4

00008fe4 <_c_startup>:
_c_startup():
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/startup.cpp:21
extern "C" dtor_ptr __DTOR_LIST__[0];
// konec pole destruktoru
extern "C" dtor_ptr __DTOR_END__[0];

extern "C" int _c_startup(void)
{
    8fe4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8fe8:	e28db000 	add	fp, sp, #0
    8fec:	e24dd00c 	sub	sp, sp, #12
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/startup.cpp:25
    int* i;

    // vynulujeme .bss sekci
    for (i = (int*)_bss_start; i < (int*)_bss_end; i++)
    8ff0:	e59f304c 	ldr	r3, [pc, #76]	; 9044 <_c_startup+0x60>
    8ff4:	e5933000 	ldr	r3, [r3]
    8ff8:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/startup.cpp:25 (discriminator 3)
    8ffc:	e59f3044 	ldr	r3, [pc, #68]	; 9048 <_c_startup+0x64>
    9000:	e5933000 	ldr	r3, [r3]
    9004:	e1a02003 	mov	r2, r3
    9008:	e51b3008 	ldr	r3, [fp, #-8]
    900c:	e1530002 	cmp	r3, r2
    9010:	2a000006 	bcs	9030 <_c_startup+0x4c>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/startup.cpp:26 (discriminator 2)
        *i = 0;
    9014:	e51b3008 	ldr	r3, [fp, #-8]
    9018:	e3a02000 	mov	r2, #0
    901c:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/startup.cpp:25 (discriminator 2)
    for (i = (int*)_bss_start; i < (int*)_bss_end; i++)
    9020:	e51b3008 	ldr	r3, [fp, #-8]
    9024:	e2833004 	add	r3, r3, #4
    9028:	e50b3008 	str	r3, [fp, #-8]
    902c:	eafffff2 	b	8ffc <_c_startup+0x18>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/startup.cpp:28

    return 0;
    9030:	e3a03000 	mov	r3, #0
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/startup.cpp:29
}
    9034:	e1a00003 	mov	r0, r3
    9038:	e28bd000 	add	sp, fp, #0
    903c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9040:	e12fff1e 	bx	lr
    9044:	0000921c 	andeq	r9, r0, ip, lsl r2
    9048:	00009258 	andeq	r9, r0, r8, asr r2

0000904c <_cpp_startup>:
_cpp_startup():
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/startup.cpp:32

extern "C" int _cpp_startup(void)
{
    904c:	e92d4800 	push	{fp, lr}
    9050:	e28db004 	add	fp, sp, #4
    9054:	e24dd008 	sub	sp, sp, #8
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/startup.cpp:37
    ctor_ptr* fnptr;

    // zavolame konstruktory globalnich C++ trid
    // v poli __CTOR_LIST__ jsou ukazatele na vygenerovane stuby volani konstruktoru
    for (fnptr = __CTOR_LIST__; fnptr < __CTOR_END__; fnptr++)
    9058:	e59f303c 	ldr	r3, [pc, #60]	; 909c <_cpp_startup+0x50>
    905c:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/startup.cpp:37 (discriminator 3)
    9060:	e51b3008 	ldr	r3, [fp, #-8]
    9064:	e59f2034 	ldr	r2, [pc, #52]	; 90a0 <_cpp_startup+0x54>
    9068:	e1530002 	cmp	r3, r2
    906c:	2a000006 	bcs	908c <_cpp_startup+0x40>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/startup.cpp:38 (discriminator 2)
        (*fnptr)();
    9070:	e51b3008 	ldr	r3, [fp, #-8]
    9074:	e5933000 	ldr	r3, [r3]
    9078:	e12fff33 	blx	r3
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/startup.cpp:37 (discriminator 2)
    for (fnptr = __CTOR_LIST__; fnptr < __CTOR_END__; fnptr++)
    907c:	e51b3008 	ldr	r3, [fp, #-8]
    9080:	e2833004 	add	r3, r3, #4
    9084:	e50b3008 	str	r3, [fp, #-8]
    9088:	eafffff4 	b	9060 <_cpp_startup+0x14>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/startup.cpp:40

    return 0;
    908c:	e3a03000 	mov	r3, #0
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/startup.cpp:41
}
    9090:	e1a00003 	mov	r0, r3
    9094:	e24bd004 	sub	sp, fp, #4
    9098:	e8bd8800 	pop	{fp, pc}
    909c:	00009214 	andeq	r9, r0, r4, lsl r2
    90a0:	0000921c 	andeq	r9, r0, ip, lsl r2

000090a4 <_cpp_shutdown>:
_cpp_shutdown():
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/startup.cpp:44

extern "C" int _cpp_shutdown(void)
{
    90a4:	e92d4800 	push	{fp, lr}
    90a8:	e28db004 	add	fp, sp, #4
    90ac:	e24dd008 	sub	sp, sp, #8
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/startup.cpp:48
    dtor_ptr* fnptr;

    // zavolame destruktory globalnich C++ trid
    for (fnptr = __DTOR_LIST__; fnptr < __DTOR_END__; fnptr++)
    90b0:	e59f303c 	ldr	r3, [pc, #60]	; 90f4 <_cpp_shutdown+0x50>
    90b4:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/startup.cpp:48 (discriminator 3)
    90b8:	e51b3008 	ldr	r3, [fp, #-8]
    90bc:	e59f2034 	ldr	r2, [pc, #52]	; 90f8 <_cpp_shutdown+0x54>
    90c0:	e1530002 	cmp	r3, r2
    90c4:	2a000006 	bcs	90e4 <_cpp_shutdown+0x40>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/startup.cpp:49 (discriminator 2)
        (*fnptr)();
    90c8:	e51b3008 	ldr	r3, [fp, #-8]
    90cc:	e5933000 	ldr	r3, [r3]
    90d0:	e12fff33 	blx	r3
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/startup.cpp:48 (discriminator 2)
    for (fnptr = __DTOR_LIST__; fnptr < __DTOR_END__; fnptr++)
    90d4:	e51b3008 	ldr	r3, [fp, #-8]
    90d8:	e2833004 	add	r3, r3, #4
    90dc:	e50b3008 	str	r3, [fp, #-8]
    90e0:	eafffff4 	b	90b8 <_cpp_shutdown+0x14>
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/startup.cpp:51

    return 0;
    90e4:	e3a03000 	mov	r3, #0
/home/silhavyj/School/ZeroMate/examples/07-LED_toggle_debug_monitor/kernel/src/startup.cpp:52
}
    90e8:	e1a00003 	mov	r0, r3
    90ec:	e24bd004 	sub	sp, fp, #4
    90f0:	e8bd8800 	pop	{fp, pc}
    90f4:	0000921c 	andeq	r9, r0, ip, lsl r2
    90f8:	0000921c 	andeq	r9, r0, ip, lsl r2

Disassembly of section .ARM.extab:

000090fc <.ARM.extab>:
    90fc:	81019b40 	tsthi	r1, r0, asr #22
    9100:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    9104:	00000000 	andeq	r0, r0, r0
    9108:	81019b40 	tsthi	r1, r0, asr #22
    910c:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    9110:	00000000 	andeq	r0, r0, r0
    9114:	81019b40 	tsthi	r1, r0, asr #22
    9118:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    911c:	00000000 	andeq	r0, r0, r0

Disassembly of section .ARM.exidx:

00009120 <.ARM.exidx>:
    9120:	7fffeef8 	svcvc	0x00ffeef8
    9124:	00000001 	andeq	r0, r0, r1
    9128:	7ffffd08 	svcvc	0x00fffd08
    912c:	7fffffd0 	svcvc	0x00ffffd0
    9130:	7ffffeb4 	svcvc	0x00fffeb4
    9134:	00000001 	andeq	r0, r0, r1
    9138:	7fffff14 	svcvc	0x00ffff14
    913c:	7fffffcc 	svcvc	0x00ffffcc
    9140:	7fffff64 	svcvc	0x00ffff64
    9144:	7fffffd0 	svcvc	0x00ffffd0
    9148:	7fffffb4 	svcvc	0x00ffffb4
    914c:	00000001 	andeq	r0, r0, r1

Disassembly of section .rodata:

00009150 <_ZN3halL15Peripheral_BaseE>:
    9150:	20000000 	andcs	r0, r0, r0

00009154 <_ZN3halL9GPIO_BaseE>:
    9154:	20200000 	eorcs	r0, r0, r0

00009158 <_ZN3halL14GPIO_Pin_CountE>:
    9158:	00000036 	andeq	r0, r0, r6, lsr r0

0000915c <_ZZN8CMonitorlsEjE11BUFFER_SIZE>:
    915c:	00000010 	andeq	r0, r0, r0, lsl r0
    9160:	65757274 	ldrbvs	r7, [r5, #-628]!	; 0xfffffd8c
    9164:	00000000 	andeq	r0, r0, r0
    9168:	736c6166 	cmnvc	ip, #-2147483623	; 0x80000019
    916c:	00000065 	andeq	r0, r0, r5, rrx
    9170:	33323130 	teqcc	r2, #48, 2
    9174:	37363534 			; <UNDEFINED> instruction: 0x37363534
    9178:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    917c:	46454443 	strbmi	r4, [r5], -r3, asr #8
    9180:	00000000 	andeq	r0, r0, r0

00009184 <_ZL7ACT_Pin>:
    9184:	0000002f 	andeq	r0, r0, pc, lsr #32
    9188:	6c6c6548 	cfstr64vs	mvdx6, [ip], #-288	; 0xfffffee0
    918c:	7266206f 	rsbvc	r2, r6, #111	; 0x6f
    9190:	74206d6f 	strtvc	r6, [r0], #-3439	; 0xfffff291
    9194:	6b206568 	blvs	82273c <_bss_end+0x8194e4>
    9198:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
    919c:	293a206c 	ldmdbcs	sl!, {r2, r3, r5, r6, sp}
    91a0:	00000a0a 	andeq	r0, r0, sl, lsl #20
    91a4:	6e6e7552 	mcrvs	5, 3, r7, cr14, cr2, {2}
    91a8:	20676e69 	rsbcs	r6, r7, r9, ror #28
    91ac:	696e6f6d 	stmdbvs	lr!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
    91b0:	20726f74 	rsbscs	r6, r2, r4, ror pc
    91b4:	74736574 	ldrbtvc	r6, [r3], #-1396	; 0xfffffa8c
    91b8:	2e2e2e73 	mcrcs	14, 1, r2, cr14, cr3, {3}
    91bc:	7261560a 	rsbvc	r5, r1, #10485760	; 0xa00000
    91c0:	6c626169 	stfvse	f6, [r2], #-420	; 0xfffffe5c
    91c4:	20782065 	rsbscs	r2, r8, r5, rrx
    91c8:	0000203d 	andeq	r2, r0, sp, lsr r0
    91cc:	6176203b 	cmnvs	r6, fp, lsr r0
    91d0:	62616972 	rsbvs	r6, r1, #1867776	; 0x1c8000
    91d4:	7920656c 	stmdbvc	r0!, {r2, r3, r5, r6, r8, sl, sp, lr}
    91d8:	30203d20 	eorcc	r3, r0, r0, lsr #26
    91dc:	00000078 	andeq	r0, r0, r8, ror r0
    91e0:	3d203531 	cfstr32cc	mvfx3, [r0, #-196]!	; 0xffffff3c
    91e4:	2030203d 	eorscs	r2, r0, sp, lsr r0
    91e8:	00207369 	eoreq	r7, r0, r9, ror #6
    91ec:	21203531 			; <UNDEFINED> instruction: 0x21203531
    91f0:	2030203d 	eorscs	r2, r0, sp, lsr r0
    91f4:	00207369 	eoreq	r7, r0, r9, ror #6
    91f8:	00000a0a 	andeq	r0, r0, sl, lsl #20
    91fc:	2044454c 	subcs	r4, r4, ip, asr #10
    9200:	4f207369 	svcmi	0x00207369
    9204:	00000a4e 	andeq	r0, r0, lr, asr #20
    9208:	2044454c 	subcs	r4, r4, ip, asr #10
    920c:	4f207369 	svcmi	0x00207369
    9210:	000a4646 	andeq	r4, sl, r6, asr #12

Disassembly of section .data:

00009214 <__CTOR_LIST__>:
    9214:	000085e4 	andeq	r8, r0, r4, ror #11
    9218:	00008c1c 	andeq	r8, r0, ip, lsl ip

Disassembly of section .bss:

0000921c <sGPIO>:
_bss_start():
    921c:	00000000 	andeq	r0, r0, r0

00009220 <sMonitor>:
	...

00009238 <_ZZN8CMonitorlsEjE8s_buffer>:
	...

Disassembly of section .debug_info:

00000000 <.debug_info>:
       0:	00000126 	andeq	r0, r0, r6, lsr #2
       4:	00000004 	andeq	r0, r0, r4
       8:	01040000 	mrseq	r0, (UNDEF: 4)
       c:	00000000 	andeq	r0, r0, r0
      10:	0000dc04 	andeq	sp, r0, r4, lsl #24
      14:	00014d00 	andeq	r4, r1, r0, lsl #26
      18:	00801800 	addeq	r1, r0, r0, lsl #16
      1c:	0000d800 	andeq	sp, r0, r0, lsl #16
      20:	00000000 	andeq	r0, r0, r0
      24:	01c90200 	biceq	r0, r9, r0, lsl #4
      28:	28010000 	stmdacs	r1, {}	; <UNPREDICTABLE>
      2c:	0080e411 	addeq	lr, r0, r1, lsl r4
      30:	00000c00 	andeq	r0, r0, r0, lsl #24
      34:	029c0100 	addseq	r0, ip, #0, 2
      38:	000001b6 			; <UNDEFINED> instruction: 0x000001b6
      3c:	cc112301 	ldcgt	3, cr2, [r1], {1}
      40:	18000080 	stmdane	r0, {r7}
      44:	01000000 	mrseq	r0, (UNDEF: 0)
      48:	0140029c 			; <UNDEFINED> instruction: 0x0140029c
      4c:	1e010000 	cdpne	0, 0, cr0, cr1, cr0, {0}
      50:	0080b411 	addeq	fp, r0, r1, lsl r4
      54:	00001800 	andeq	r1, r0, r0, lsl #16
      58:	029c0100 	addseq	r0, ip, #0, 2
      5c:	00000133 	andeq	r0, r0, r3, lsr r1
      60:	9c111901 			; <UNDEFINED> instruction: 0x9c111901
      64:	18000080 	stmdane	r0, {r7}
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
      a0:	bb050000 	bllt	1400a8 <_bss_end+0x136e50>
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
     11c:	0a010067 	beq	402c0 <_bss_end+0x37068>
     120:	0000bb31 	andeq	fp, r0, r1, lsr fp
     124:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     128:	066c0000 	strbteq	r0, [ip], -r0
     12c:	00040000 	andeq	r0, r4, r0
     130:	000000d0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     134:	00000104 	andeq	r0, r0, r4, lsl #2
     138:	5e040000 	cdppl	0, 0, cr0, cr4, cr0, {0}
     13c:	4d000004 	stcmi	0, cr0, [r0, #-16]
     140:	f0000001 			; <UNDEFINED> instruction: 0xf0000001
     144:	10000080 	andne	r0, r0, r0, lsl #1
     148:	b8000005 	stmdalt	r0, {r0, r2}
     14c:	02000000 	andeq	r0, r0, #0
     150:	038e0801 	orreq	r0, lr, #65536	; 0x10000
     154:	02020000 	andeq	r0, r2, #0
     158:	00059605 	andeq	r9, r5, r5, lsl #12
     15c:	05040300 	streq	r0, [r4, #-768]	; 0xfffffd00
     160:	00746e69 	rsbseq	r6, r4, r9, ror #28
     164:	0004ed04 	andeq	lr, r4, r4, lsl #26
     168:	07090200 	streq	r0, [r9, -r0, lsl #4]
     16c:	00000046 	andeq	r0, r0, r6, asr #32
     170:	85080102 	strhi	r0, [r8, #-258]	; 0xfffffefe
     174:	02000003 	andeq	r0, r0, #3
     178:	03c30702 	biceq	r0, r3, #524288	; 0x80000
     17c:	a0040000 	andge	r0, r4, r0
     180:	02000005 	andeq	r0, r0, #5
     184:	0065070b 	rsbeq	r0, r5, fp, lsl #14
     188:	54050000 	strpl	r0, [r5], #-0
     18c:	02000000 	andeq	r0, r0, #0
     190:	0f830704 	svceq	0x00830704
     194:	68060000 	stmdavs	r6, {}	; <UNPREDICTABLE>
     198:	03006c61 	movweq	r6, #3169	; 0xc61
     19c:	01630b07 	cmneq	r3, r7, lsl #22
     1a0:	4e070000 	cdpmi	0, 0, cr0, cr7, cr0, {0}
     1a4:	03000004 	movweq	r0, #4
     1a8:	016a1d0a 	cmneq	sl, sl, lsl #26
     1ac:	00000000 	andeq	r0, r0, r0
     1b0:	3f072000 	svccc	0x00072000
     1b4:	03000006 	movweq	r0, #6
     1b8:	016a1d0d 	cmneq	sl, sp, lsl #26
     1bc:	00000000 	andeq	r0, r0, r0
     1c0:	d6082020 	strle	r2, [r8], -r0, lsr #32
     1c4:	03000003 	movweq	r0, #3
     1c8:	00601810 	rsbeq	r1, r0, r0, lsl r8
     1cc:	09360000 	ldmdbeq	r6!, {}	; <UNPREDICTABLE>
     1d0:	0000035c 	andeq	r0, r0, ip, asr r3
     1d4:	00330405 	eorseq	r0, r3, r5, lsl #8
     1d8:	13030000 	movwne	r0, #12288	; 0x3000
     1dc:	061f0a10 			; <UNDEFINED> instruction: 0x061f0a10
     1e0:	0a000000 	beq	1e8 <_start-0x7e18>
     1e4:	00000627 	andeq	r0, r0, r7, lsr #12
     1e8:	062f0a01 	strteq	r0, [pc], -r1, lsl #20
     1ec:	0a020000 	beq	801f4 <_bss_end+0x76f9c>
     1f0:	00000637 	andeq	r0, r0, r7, lsr r6
     1f4:	04460a03 	strbeq	r0, [r6], #-2563	; 0xfffff5fd
     1f8:	0a040000 	beq	100200 <_bss_end+0xf6fa8>
     1fc:	00000649 	andeq	r0, r0, r9, asr #12
     200:	03e50a05 	mvneq	r0, #20480	; 0x5000
     204:	0a070000 	beq	1c020c <_bss_end+0x1b6fb4>
     208:	000003ec 	andeq	r0, r0, ip, ror #7
     20c:	03bc0a08 			; <UNDEFINED> instruction: 0x03bc0a08
     210:	0a0a0000 	beq	280218 <_bss_end+0x276fc0>
     214:	000002df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
     218:	03650a0b 	cmneq	r5, #45056	; 0xb000
     21c:	0a0d0000 	beq	340224 <_bss_end+0x336fcc>
     220:	0000036c 	andeq	r0, r0, ip, ror #6
     224:	04cf0a0e 	strbeq	r0, [pc], #2574	; 22c <_start-0x7dd4>
     228:	0a100000 	beq	400230 <_bss_end+0x3f6fd8>
     22c:	000004d6 	ldrdeq	r0, [r0], -r6
     230:	01f60a11 	mvnseq	r0, r1, lsl sl
     234:	0a130000 	beq	4c023c <_bss_end+0x4b6fe4>
     238:	000001fd 	strdeq	r0, [r0], -sp
     23c:	04330a14 	ldrteq	r0, [r3], #-2580	; 0xfffff5ec
     240:	0a160000 	beq	580248 <_bss_end+0x576ff0>
     244:	0000043a 	andeq	r0, r0, sl, lsr r4
     248:	05ae0a17 	streq	r0, [lr, #2583]!	; 0xa17
     24c:	0a190000 	beq	640254 <_bss_end+0x636ffc>
     250:	000005b5 			; <UNDEFINED> instruction: 0x000005b5
     254:	05800a1a 	streq	r0, [r0, #2586]	; 0xa1a
     258:	0a1c0000 	beq	700260 <_bss_end+0x6f7008>
     25c:	00000587 	andeq	r0, r0, r7, lsl #11
     260:	04dd0a1d 	ldrbeq	r0, [sp], #2589	; 0xa1d
     264:	0a1f0000 	beq	7c026c <_bss_end+0x7b7014>
     268:	000004e5 	andeq	r0, r0, r5, ror #9
     26c:	05780a20 	ldrbeq	r0, [r8, #-2592]!	; 0xfffff5e0
     270:	0a220000 	beq	880278 <_bss_end+0x877020>
     274:	00000204 	andeq	r0, r0, r4, lsl #4
     278:	037f0a23 	cmneq	pc, #143360	; 0x23000
     27c:	0a250000 	beq	940284 <_bss_end+0x93702c>
     280:	00000352 	andeq	r0, r0, r2, asr r3
     284:	03b20a26 			; <UNDEFINED> instruction: 0x03b20a26
     288:	00270000 	eoreq	r0, r7, r0
     28c:	07040200 	streq	r0, [r4, -r0, lsl #4]
     290:	00000f7e 	andeq	r0, r0, lr, ror pc
     294:	00016305 	andeq	r6, r1, r5, lsl #6
     298:	00780b00 	rsbseq	r0, r8, r0, lsl #22
     29c:	880b0000 	stmdahi	fp, {}	; <UNPREDICTABLE>
     2a0:	0b000000 	bleq	2a8 <_start-0x7d58>
     2a4:	00000098 	muleq	r0, r8, r0
     2a8:	00054c0c 	andeq	r4, r5, ip, lsl #24
     2ac:	3a010700 	bcc	41eb4 <_bss_end+0x38c5c>
     2b0:	04000000 	streq	r0, [r0], #-0
     2b4:	01c70c06 	biceq	r0, r7, r6, lsl #24
     2b8:	be0a0000 	cdplt	0, 0, cr0, cr10, cr0, {0}
     2bc:	00000004 	andeq	r0, r0, r4
     2c0:	00021e0a 	andeq	r1, r2, sl, lsl #28
     2c4:	f90a0100 			; <UNDEFINED> instruction: 0xf90a0100
     2c8:	02000003 	andeq	r0, r0, #3
     2cc:	0003f30a 	andeq	pc, r3, sl, lsl #6
     2d0:	990a0300 	stmdbls	sl, {r8, r9}
     2d4:	04000003 	streq	r0, [r0], #-3
     2d8:	0003790a 	andeq	r7, r3, sl, lsl #18
     2dc:	930a0500 	movwls	r0, #42240	; 0xa500
     2e0:	06000003 	streq	r0, [r0], -r3
     2e4:	0003730a 	andeq	r7, r3, sl, lsl #6
     2e8:	250a0700 	strcs	r0, [sl, #-1792]	; 0xfffff900
     2ec:	08000002 	stmdaeq	r0, {r1}
     2f0:	020c0d00 	andeq	r0, ip, #0, 26
     2f4:	04040000 	streq	r0, [r4], #-0
     2f8:	0328071a 			; <UNDEFINED> instruction: 0x0328071a
     2fc:	720e0000 	andvc	r0, lr, #0
     300:	04000005 	streq	r0, [r0], #-5
     304:	0333191e 	teqeq	r3, #491520	; 0x78000
     308:	0f000000 	svceq	0x00000000
     30c:	000002fb 	strdeq	r0, [r0], -fp
     310:	0f0a2204 	svceq	0x000a2204
     314:	38000003 	stmdacc	r0, {r0, r1}
     318:	02000003 	andeq	r0, r0, #3
     31c:	000001fa 	strdeq	r0, [r0], -sl
     320:	0000020f 	andeq	r0, r0, pc, lsl #4
     324:	00033f10 	andeq	r3, r3, r0, lsl pc
     328:	00541100 	subseq	r1, r4, r0, lsl #2
     32c:	4a110000 	bmi	440334 <_bss_end+0x4370dc>
     330:	11000003 	tstne	r0, r3
     334:	0000034a 	andeq	r0, r0, sl, asr #6
     338:	039f0f00 	orrseq	r0, pc, #0, 30
     33c:	24040000 	strcs	r0, [r4], #-0
     340:	0002b00a 	andeq	fp, r2, sl
     344:	00033800 	andeq	r3, r3, r0, lsl #16
     348:	02280200 	eoreq	r0, r8, #0, 4
     34c:	023d0000 	eorseq	r0, sp, #0
     350:	3f100000 	svccc	0x00100000
     354:	11000003 	tstne	r0, r3
     358:	00000054 	andeq	r0, r0, r4, asr r0
     35c:	00034a11 	andeq	r4, r3, r1, lsl sl
     360:	034a1100 	movteq	r1, #41216	; 0xa100
     364:	0f000000 	svceq	0x00000000
     368:	0000033f 	andeq	r0, r0, pc, lsr r3
     36c:	810a2604 	tsthi	sl, r4, lsl #12
     370:	38000002 	stmdacc	r0, {r1}
     374:	02000003 	andeq	r0, r0, #3
     378:	00000256 	andeq	r0, r0, r6, asr r2
     37c:	0000026b 	andeq	r0, r0, fp, ror #4
     380:	00033f10 	andeq	r3, r3, r0, lsl pc
     384:	00541100 	subseq	r1, r4, r0, lsl #2
     388:	4a110000 	bmi	440390 <_bss_end+0x437138>
     38c:	11000003 	tstne	r0, r3
     390:	0000034a 	andeq	r0, r0, sl, asr #6
     394:	05e20f00 	strbeq	r0, [r2, #3840]!	; 0xf00
     398:	28040000 	stmdacs	r4, {}	; <UNPREDICTABLE>
     39c:	0002400a 	andeq	r4, r2, sl
     3a0:	00033800 	andeq	r3, r3, r0, lsl #16
     3a4:	02840200 	addeq	r0, r4, #0, 4
     3a8:	02990000 	addseq	r0, r9, #0
     3ac:	3f100000 	svccc	0x00100000
     3b0:	11000003 	tstne	r0, r3
     3b4:	00000054 	andeq	r0, r0, r4, asr r0
     3b8:	00034a11 	andeq	r4, r3, r1, lsl sl
     3bc:	034a1100 	movteq	r1, #41216	; 0xa100
     3c0:	0f000000 	svceq	0x00000000
     3c4:	0000020c 	andeq	r0, r0, ip, lsl #4
     3c8:	cb052b04 	blgt	14afe0 <_bss_end+0x141d88>
     3cc:	50000005 	andpl	r0, r0, r5
     3d0:	01000003 	tsteq	r0, r3
     3d4:	000002b2 			; <UNDEFINED> instruction: 0x000002b2
     3d8:	000002bd 			; <UNDEFINED> instruction: 0x000002bd
     3dc:	00035010 	andeq	r5, r3, r0, lsl r0
     3e0:	00651100 	rsbeq	r1, r5, r0, lsl #2
     3e4:	12000000 	andne	r0, r0, #0
     3e8:	00000421 	andeq	r0, r0, r1, lsr #8
     3ec:	230a2e04 	movwcs	r2, #44548	; 0xae04
     3f0:	01000005 	tsteq	r0, r5
     3f4:	000002d2 	ldrdeq	r0, [r0], -r2
     3f8:	000002e2 	andeq	r0, r0, r2, ror #5
     3fc:	00035010 	andeq	r5, r3, r0, lsl r0
     400:	00541100 	subseq	r1, r4, r0, lsl #2
     404:	7e110000 	cdpvc	0, 1, cr0, cr1, cr0, {0}
     408:	00000001 	andeq	r0, r0, r1
     40c:	00026f0f 	andeq	r6, r2, pc, lsl #30
     410:	14300400 	ldrtne	r0, [r0], #-1024	; 0xfffffc00
     414:	000004fa 	strdeq	r0, [r0], -sl
     418:	0000017e 	andeq	r0, r0, lr, ror r1
     41c:	0002fb01 	andeq	pc, r2, r1, lsl #22
     420:	00030600 	andeq	r0, r3, r0, lsl #12
     424:	033f1000 	teqeq	pc, #0
     428:	54110000 	ldrpl	r0, [r1], #-0
     42c:	00000000 	andeq	r0, r0, r0
     430:	00021a13 	andeq	r1, r2, r3, lsl sl
     434:	0a330400 	beq	cc143c <_bss_end+0xcb81e4>
     438:	000003ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
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
     464:	0005a902 	andeq	sl, r5, r2, lsl #18
     468:	28041400 	stmdacs	r4, {sl, ip}
     46c:	05000003 	streq	r0, [r0, #-3]
     470:	0000033f 	andeq	r0, r0, pc, lsr r3
     474:	00540415 	subseq	r0, r4, r5, lsl r4
     478:	04140000 	ldreq	r0, [r4], #-0
     47c:	000001c7 	andeq	r0, r0, r7, asr #3
     480:	00035005 	andeq	r5, r3, r5
     484:	02f51600 	rscseq	r1, r5, #0, 12
     488:	37040000 	strcc	r0, [r4, -r0]
     48c:	0001c716 	andeq	ip, r1, r6, lsl r7
     490:	035b1700 	cmpeq	fp, #0, 14
     494:	04010000 	streq	r0, [r1], #-0
     498:	1c03050f 	cfstr32ne	mvfx0, [r3], {15}
     49c:	18000092 	stmdane	r0, {r1, r4, r7}
     4a0:	000002e6 	andeq	r0, r0, r6, ror #5
     4a4:	000085e4 	andeq	r8, r0, r4, ror #11
     4a8:	0000001c 	andeq	r0, r0, ip, lsl r0
     4ac:	f5199c01 			; <UNDEFINED> instruction: 0xf5199c01
     4b0:	90000005 	andls	r0, r0, r5
     4b4:	54000085 	strpl	r0, [r0], #-133	; 0xffffff7b
     4b8:	01000000 	mrseq	r0, (UNDEF: 0)
     4bc:	0003b69c 	muleq	r3, ip, r6
     4c0:	05bc1a00 	ldreq	r1, [ip, #2560]!	; 0xa00
     4c4:	66010000 	strvs	r0, [r1], -r0
     4c8:	00003301 	andeq	r3, r0, r1, lsl #6
     4cc:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     4d0:	0004c41a 	andeq	ip, r4, sl, lsl r4
     4d4:	01660100 	cmneq	r6, r0, lsl #2
     4d8:	00000033 	andeq	r0, r0, r3, lsr r0
     4dc:	00709102 	rsbseq	r9, r0, r2, lsl #2
     4e0:	0003061b 	andeq	r0, r3, fp, lsl r6
     4e4:	065f0100 	ldrbeq	r0, [pc], -r0, lsl #2
     4e8:	000003d0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     4ec:	000084b8 			; <UNDEFINED> instruction: 0x000084b8
     4f0:	000000d8 	ldrdeq	r0, [r0], -r8
     4f4:	04199c01 	ldreq	r9, [r9], #-3073	; 0xfffff3ff
     4f8:	f51c0000 			; <UNDEFINED> instruction: 0xf51c0000
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
     540:	1b007091 	blne	1c78c <_bss_end+0x13534>
     544:	000002e2 	andeq	r0, r0, r2, ror #5
     548:	33105601 	tstcc	r0, #1048576	; 0x100000
     54c:	3c000004 	stccc	0, cr0, [r0], {4}
     550:	7c000084 	stcvc	0, cr0, [r0], {132}	; 0x84
     554:	01000000 	mrseq	r0, (UNDEF: 0)
     558:	00046d9c 	muleq	r4, ip, sp
     55c:	04f51c00 	ldrbteq	r1, [r5], #3072	; 0xc00
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
     594:	1b007091 	blne	1c7e0 <_bss_end+0x13588>
     598:	000002bd 			; <UNDEFINED> instruction: 0x000002bd
     59c:	87064d01 	strhi	r4, [r6, -r1, lsl #26]
     5a0:	94000004 	strls	r0, [r0], #-4
     5a4:	a8000083 	stmdage	r0, {r0, r1, r7}
     5a8:	01000000 	mrseq	r0, (UNDEF: 0)
     5ac:	0004d09c 	muleq	r4, ip, r0
     5b0:	04f51c00 	ldrbteq	r1, [r5], #3072	; 0xc00
     5b4:	03560000 	cmpeq	r6, #0
     5b8:	91020000 	mrsls	r0, (UNDEF: 2)
     5bc:	69701d6c 	ldmdbvs	r0!, {r2, r3, r5, r6, r8, sl, fp, ip}^
     5c0:	4d01006e 	stcmi	0, cr0, [r1, #-440]	; 0xfffffe48
     5c4:	00005430 	andeq	r5, r0, r0, lsr r4
     5c8:	68910200 	ldmvs	r1, {r9}
     5cc:	0004411a 	andeq	r4, r4, sl, lsl r1
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
     5f8:	6b1f0070 	blvs	7c07c0 <_bss_end+0x7b7568>
     5fc:	01000002 	tsteq	r0, r2
     600:	04ea0642 	strbteq	r0, [sl], #1602	; 0x642
     604:	83200000 	nophi	{0}	; <UNPREDICTABLE>
     608:	00740000 	rsbseq	r0, r4, r0
     60c:	9c010000 	stcls	0, cr0, [r1], {-0}
     610:	00000524 	andeq	r0, r0, r4, lsr #10
     614:	0004f51c 	andeq	pc, r4, ip, lsl r5	; <UNPREDICTABLE>
     618:	00034500 	andeq	r4, r3, r0, lsl #10
     61c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     620:	6e69701d 	mcrvs	0, 3, r7, cr9, cr13, {0}
     624:	31420100 	mrscc	r0, (UNDEF: 82)
     628:	00000054 	andeq	r0, r0, r4, asr r0
     62c:	1d709102 	ldfnep	f1, [r0, #-8]!
     630:	00676572 	rsbeq	r6, r7, r2, ror r5
     634:	4a404201 	bmi	1010e40 <_bss_end+0x1007be8>
     638:	02000003 	andeq	r0, r0, #3
     63c:	8e1a6c91 	mrchi	12, 0, r6, cr10, cr1, {4}
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
     668:	0004f51c 	andeq	pc, r4, ip, lsl r5	; <UNPREDICTABLE>
     66c:	00034500 	andeq	r4, r3, r0, lsl #10
     670:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     674:	6e69701d 	mcrvs	0, 3, r7, cr9, cr13, {0}
     678:	31370100 	teqcc	r7, r0, lsl #2
     67c:	00000054 	andeq	r0, r0, r4, asr r0
     680:	1d709102 	ldfnep	f1, [r0, #-8]!
     684:	00676572 	rsbeq	r6, r7, r2, ror r5
     688:	4a403701 	bmi	100e294 <_bss_end+0x100503c>
     68c:	02000003 	andeq	r0, r0, #3
     690:	8e1a6c91 	mrchi	12, 0, r6, cr10, cr1, {4}
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
     6bc:	0004f51c 	andeq	pc, r4, ip, lsl r5	; <UNPREDICTABLE>
     6c0:	00034500 	andeq	r4, r3, r0, lsl #10
     6c4:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     6c8:	6e69701d 	mcrvs	0, 3, r7, cr9, cr13, {0}
     6cc:	312c0100 			; <UNDEFINED> instruction: 0x312c0100
     6d0:	00000054 	andeq	r0, r0, r4, asr r0
     6d4:	1d709102 	ldfnep	f1, [r0, #-8]!
     6d8:	00676572 	rsbeq	r6, r7, r2, ror r5
     6dc:	4a402c01 	bmi	100b6e8 <_bss_end+0x1002490>
     6e0:	02000003 	andeq	r0, r0, #3
     6e4:	8e1a6c91 	mrchi	12, 0, r6, cr10, cr1, {4}
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
     710:	0004f51c 	andeq	pc, r4, ip, lsl r5	; <UNPREDICTABLE>
     714:	00034500 	andeq	r4, r3, r0, lsl #10
     718:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     71c:	6e69701d 	mcrvs	0, 3, r7, cr9, cr13, {0}
     720:	320c0100 	andcc	r0, ip, #0, 2
     724:	00000054 	andeq	r0, r0, r4, asr r0
     728:	1d709102 	ldfnep	f1, [r0, #-8]!
     72c:	00676572 	rsbeq	r6, r7, r2, ror r5
     730:	4a410c01 	bmi	104373c <_bss_end+0x103a4e4>
     734:	02000003 	andeq	r0, r0, #3
     738:	8e1a6c91 	mrchi	12, 0, r6, cr10, cr1, {4}
     73c:	01000005 	tsteq	r0, r5
     740:	034a500c 	movteq	r5, #40972	; 0xa00c
     744:	91020000 	mrsls	r0, (UNDEF: 2)
     748:	99200068 	stmdbls	r0!, {r3, r5, r6}
     74c:	01000002 	tsteq	r0, r2
     750:	06310106 	ldrteq	r0, [r1], -r6, lsl #2
     754:	47000000 	strmi	r0, [r0, -r0]
     758:	21000006 	tstcs	r0, r6
     75c:	000004f5 	strdeq	r0, [r0], -r5
     760:	00000356 	andeq	r0, r0, r6, asr r3
     764:	00023122 	andeq	r3, r2, r2, lsr #2
     768:	2b060100 	blcs	180b70 <_bss_end+0x177918>
     76c:	00000065 	andeq	r0, r0, r5, rrx
     770:	06202300 	strteq	r2, [r0], -r0, lsl #6
     774:	055b0000 	ldrbeq	r0, [fp, #-0]
     778:	065e0000 	ldrbeq	r0, [lr], -r0
     77c:	80f00000 	rscshi	r0, r0, r0
     780:	00340000 	eorseq	r0, r4, r0
     784:	9c010000 	stcls	0, cr0, [r1], {-0}
     788:	00063124 	andeq	r3, r6, r4, lsr #2
     78c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     790:	00063a24 	andeq	r3, r6, r4, lsr #20
     794:	70910200 	addsvc	r0, r1, r0, lsl #4
     798:	07950000 	ldreq	r0, [r5, r0]
     79c:	00040000 	andeq	r0, r4, r0
     7a0:	0000031a 	andeq	r0, r0, sl, lsl r3
     7a4:	00000104 	andeq	r0, r0, r4, lsl #2
     7a8:	56040000 	strpl	r0, [r4], -r0
     7ac:	4d000008 	stcmi	0, cr0, [r0, #-32]	; 0xffffffe0
     7b0:	00000001 	andeq	r0, r0, r1
     7b4:	00000000 	andeq	r0, r0, r0
     7b8:	cc000000 	stcgt	0, cr0, [r0], {-0}
     7bc:	02000003 	andeq	r0, r0, #3
     7c0:	000007a3 	andeq	r0, r0, r3, lsr #15
     7c4:	07030218 	smladeq	r3, r8, r2, r0
     7c8:	000002b6 			; <UNDEFINED> instruction: 0x000002b6
     7cc:	0006ff03 	andeq	pc, r6, r3, lsl #30
     7d0:	b6040700 	strlt	r0, [r4], -r0, lsl #14
     7d4:	02000002 	andeq	r0, r0, #2
     7d8:	52011006 	andpl	r1, r1, #6
     7dc:	04000000 	streq	r0, [r0], #-0
     7e0:	00584548 	subseq	r4, r8, r8, asr #10
     7e4:	45440410 	strbmi	r0, [r4, #-1040]	; 0xfffffbf0
     7e8:	000a0043 	andeq	r0, sl, r3, asr #32
     7ec:	00003205 	andeq	r3, r0, r5, lsl #4
     7f0:	070c0600 	streq	r0, [ip, -r0, lsl #12]
     7f4:	02080000 	andeq	r0, r8, #0
     7f8:	007b0c27 	rsbseq	r0, fp, r7, lsr #24
     7fc:	79070000 	stmdbvc	r7, {}	; <UNPREDICTABLE>
     800:	16290200 	strtne	r0, [r9], -r0, lsl #4
     804:	000002b6 			; <UNDEFINED> instruction: 0x000002b6
     808:	00780700 	rsbseq	r0, r8, r0, lsl #14
     80c:	b6162a02 	ldrlt	r2, [r6], -r2, lsl #20
     810:	04000002 	streq	r0, [r0], #-2
     814:	08fa0800 	ldmeq	sl!, {fp}^
     818:	0c020000 	stceq	0, cr0, [r2], {-0}
     81c:	0000521b 	andeq	r5, r0, fp, lsl r2
     820:	090a0100 	stmdbeq	sl, {r8}
     824:	0000080a 	andeq	r0, r0, sl, lsl #16
     828:	c8280d02 	stmdagt	r8!, {r1, r8, sl, fp}
     82c:	01000002 	tsteq	r0, r2
     830:	0007a30a 	andeq	sl, r7, sl, lsl #6
     834:	0e100200 	cdpeq	2, 1, cr0, cr0, cr0, {0}
     838:	000008e7 	andeq	r0, r0, r7, ror #17
     83c:	000002d9 	ldrdeq	r0, [r0], -r9
     840:	0000af01 	andeq	sl, r0, r1, lsl #30
     844:	0000c400 	andeq	ip, r0, r0, lsl #8
     848:	02d90b00 	sbcseq	r0, r9, #0, 22
     84c:	b60c0000 	strlt	r0, [ip], -r0
     850:	0c000002 	stceq	0, cr0, [r0], {2}
     854:	000002b6 			; <UNDEFINED> instruction: 0x000002b6
     858:	0002b60c 	andeq	fp, r2, ip, lsl #12
     85c:	bf0d0000 	svclt	0x000d0000
     860:	02000006 	andeq	r0, r0, #6
     864:	076c0a12 			; <UNDEFINED> instruction: 0x076c0a12
     868:	d9010000 	stmdble	r1, {}	; <UNPREDICTABLE>
     86c:	df000000 	svcle	0x00000000
     870:	0b000000 	bleq	878 <_start-0x7788>
     874:	000002d9 	ldrdeq	r0, [r0], -r9
     878:	07c30e00 	strbeq	r0, [r3, r0, lsl #28]
     87c:	14020000 	strne	r0, [r2], #-0
     880:	0008270f 	andeq	r2, r8, pc, lsl #14
     884:	0002e400 	andeq	lr, r2, r0, lsl #8
     888:	00f80100 	rscseq	r0, r8, r0, lsl #2
     88c:	01030000 	mrseq	r0, (UNDEF: 3)
     890:	d90b0000 	stmdble	fp, {}	; <UNPREDICTABLE>
     894:	0c000002 	stceq	0, cr0, [r0], {2}
     898:	000002cd 	andeq	r0, r0, sp, asr #5
     89c:	07c30e00 	strbeq	r0, [r3, r0, lsl #28]
     8a0:	15020000 	strne	r0, [r2, #-0]
     8a4:	0007ce0f 	andeq	ip, r7, pc, lsl #28
     8a8:	0002e400 	andeq	lr, r2, r0, lsl #8
     8ac:	011c0100 	tsteq	ip, r0, lsl #2
     8b0:	01270000 			; <UNDEFINED> instruction: 0x01270000
     8b4:	d90b0000 	stmdble	fp, {}	; <UNPREDICTABLE>
     8b8:	0c000002 	stceq	0, cr0, [r0], {2}
     8bc:	000002c2 	andeq	r0, r0, r2, asr #5
     8c0:	07c30e00 	strbeq	r0, [r3, r0, lsl #28]
     8c4:	16020000 	strne	r0, [r2], -r0
     8c8:	0007810f 	andeq	r8, r7, pc, lsl #2
     8cc:	0002e400 	andeq	lr, r2, r0, lsl #8
     8d0:	01400100 	mrseq	r0, (UNDEF: 80)
     8d4:	014b0000 	mrseq	r0, (UNDEF: 75)
     8d8:	d90b0000 	stmdble	fp, {}	; <UNPREDICTABLE>
     8dc:	0c000002 	stceq	0, cr0, [r0], {2}
     8e0:	00000032 	andeq	r0, r0, r2, lsr r0
     8e4:	07c30e00 	strbeq	r0, [r3, r0, lsl #28]
     8e8:	17020000 	strne	r0, [r2, -r0]
     8ec:	0008b90f 	andeq	fp, r8, pc, lsl #18
     8f0:	0002e400 	andeq	lr, r2, r0, lsl #8
     8f4:	01640100 	cmneq	r4, r0, lsl #2
     8f8:	016f0000 	cmneq	pc, r0
     8fc:	d90b0000 	stmdble	fp, {}	; <UNPREDICTABLE>
     900:	0c000002 	stceq	0, cr0, [r0], {2}
     904:	000002b6 			; <UNDEFINED> instruction: 0x000002b6
     908:	07c30e00 	strbeq	r0, [r3, r0, lsl #28]
     90c:	18020000 	stmdane	r2, {}	; <UNPREDICTABLE>
     910:	0008160f 	andeq	r1, r8, pc, lsl #12
     914:	0002e400 	andeq	lr, r2, r0, lsl #8
     918:	01880100 	orreq	r0, r8, r0, lsl #2
     91c:	01930000 	orrseq	r0, r3, r0
     920:	d90b0000 	stmdble	fp, {}	; <UNPREDICTABLE>
     924:	0c000002 	stceq	0, cr0, [r0], {2}
     928:	000002ea 	andeq	r0, r0, sl, ror #5
     92c:	06ea0f00 	strbteq	r0, [sl], r0, lsl #30
     930:	1b020000 	blne	80938 <_bss_end+0x776e0>
     934:	00066711 	andeq	r6, r6, r1, lsl r7
     938:	0001a700 	andeq	sl, r1, r0, lsl #14
     93c:	0001ad00 	andeq	sl, r1, r0, lsl #26
     940:	02d90b00 	sbcseq	r0, r9, #0, 22
     944:	0f000000 	svceq	0x00000000
     948:	000006dd 	ldrdeq	r0, [r0], -sp
     94c:	ca111c02 	bgt	44795c <_bss_end+0x43e704>
     950:	c1000008 	tstgt	r0, r8
     954:	c7000001 	strgt	r0, [r0, -r1]
     958:	0b000001 	bleq	964 <_start-0x769c>
     95c:	000002d9 	ldrdeq	r0, [r0], -r9
     960:	06930f00 	ldreq	r0, [r3], r0, lsl #30
     964:	1d020000 	stcne	0, cr0, [r2, #-0]
     968:	00071611 	andeq	r1, r7, r1, lsl r6
     96c:	0001db00 	andeq	sp, r1, r0, lsl #22
     970:	0001e100 	andeq	lr, r1, r0, lsl #2
     974:	02d90b00 	sbcseq	r0, r9, #0, 22
     978:	10000000 	andne	r0, r0, r0
     97c:	000006f8 	strdeq	r0, [r0], -r8
     980:	ac191f02 	ldcge	15, cr1, [r9], {2}
     984:	b6000007 	strlt	r0, [r0], -r7
     988:	f9000002 			; <UNDEFINED> instruction: 0xf9000002
     98c:	09000001 	stmdbeq	r0, {r0}
     990:	0b000002 	bleq	9a0 <_start-0x7660>
     994:	000002d9 	ldrdeq	r0, [r0], -r9
     998:	0002b60c 	andeq	fp, r2, ip, lsl #12
     99c:	02b60c00 	adcseq	r0, r6, #0, 24
     9a0:	10000000 	andne	r0, r0, r0
     9a4:	00000930 	andeq	r0, r0, r0, lsr r9
     9a8:	a5192002 	ldrge	r2, [r9, #-2]
     9ac:	b6000006 	strlt	r0, [r0], -r6
     9b0:	21000002 	tstcs	r0, r2
     9b4:	31000002 	tstcc	r0, r2
     9b8:	0b000002 	bleq	9c8 <_start-0x7638>
     9bc:	000002d9 	ldrdeq	r0, [r0], -r9
     9c0:	0002b60c 	andeq	fp, r2, ip, lsl #12
     9c4:	02b60c00 	adcseq	r0, r6, #0, 24
     9c8:	0f000000 	svceq	0x00000000
     9cc:	00000651 	andeq	r0, r0, r1, asr r6
     9d0:	400a2202 	andmi	r2, sl, r2, lsl #4
     9d4:	45000008 	strmi	r0, [r0, #-8]
     9d8:	4b000002 	blmi	9e8 <_start-0x7618>
     9dc:	0b000002 	bleq	9ec <_start-0x7614>
     9e0:	000002d9 	ldrdeq	r0, [r0], -r9
     9e4:	06d80f00 	ldrbeq	r0, [r8], r0, lsl #30
     9e8:	24020000 	strcs	r0, [r2], #-0
     9ec:	0007e10a 	andeq	lr, r7, sl, lsl #2
     9f0:	00025f00 	andeq	r5, r2, r0, lsl #30
     9f4:	00027400 	andeq	r7, r2, r0, lsl #8
     9f8:	02d90b00 	sbcseq	r0, r9, #0, 22
     9fc:	b60c0000 	strlt	r0, [ip], -r0
     a00:	0c000002 	stceq	0, cr0, [r0], {2}
     a04:	000002f1 	strdeq	r0, [r0], -r1
     a08:	0002b60c 	andeq	fp, r2, ip, lsl #12
     a0c:	38110000 	ldmdacc	r1, {}	; <UNPREDICTABLE>
     a10:	02000007 	andeq	r0, r0, #7
     a14:	02fd232e 	rscseq	r2, sp, #-1207959552	; 0xb8000000
     a18:	11000000 	mrsne	r0, (UNDEF: 0)
     a1c:	00000838 	andeq	r0, r0, r8, lsr r8
     a20:	b6122f02 	ldrlt	r2, [r2], -r2, lsl #30
     a24:	04000002 	streq	r0, [r0], #-2
     a28:	0007f811 	andeq	pc, r7, r1, lsl r8	; <UNPREDICTABLE>
     a2c:	12300200 	eorsne	r0, r0, #0, 4
     a30:	000002b6 			; <UNDEFINED> instruction: 0x000002b6
     a34:	08011108 	stmdaeq	r1, {r3, r8, ip}
     a38:	31020000 	mrscc	r0, (UNDEF: 2)
     a3c:	0000570f 	andeq	r5, r0, pc, lsl #14
     a40:	85110c00 	ldrhi	r0, [r1, #-3072]	; 0xfffff400
     a44:	02000006 	andeq	r0, r0, #6
     a48:	00321232 	eorseq	r1, r2, r2, lsr r2
     a4c:	00140000 	andseq	r0, r4, r0
     a50:	83070412 	movwhi	r0, #29714	; 0x7412
     a54:	0500000f 	streq	r0, [r0, #-15]
     a58:	000002b6 			; <UNDEFINED> instruction: 0x000002b6
     a5c:	02d40413 	sbcseq	r0, r4, #318767104	; 0x13000000
     a60:	c2050000 	andgt	r0, r5, #0
     a64:	12000002 	andne	r0, r0, #2
     a68:	038e0801 	orreq	r0, lr, #65536	; 0x10000
     a6c:	cd050000 	stcgt	0, cr0, [r5, #-0]
     a70:	13000002 	movwne	r0, #2
     a74:	00002504 	andeq	r2, r0, r4, lsl #10
     a78:	02d90500 	sbcseq	r0, r9, #0, 10
     a7c:	04140000 	ldreq	r0, [r4], #-0
     a80:	00000025 	andeq	r0, r0, r5, lsr #32
     a84:	a9020112 	stmdbge	r2, {r1, r4, r8}
     a88:	13000005 	movwne	r0, #5
     a8c:	0002cd04 	andeq	ip, r2, r4, lsl #26
     a90:	09041300 	stmdbeq	r4, {r8, r9, ip}
     a94:	05000003 	streq	r0, [r0, #-3]
     a98:	000002f7 	strdeq	r0, [r0], -r7
     a9c:	85080112 	strhi	r0, [r8, #-274]	; 0xfffffeee
     aa0:	15000003 	strne	r0, [r0, #-3]
     aa4:	00000302 	andeq	r0, r0, r2, lsl #6
     aa8:	00075116 	andeq	r5, r7, r6, lsl r1
     aac:	11350200 	teqne	r5, r0, lsl #4
     ab0:	00000025 	andeq	r0, r0, r5, lsr #32
     ab4:	00030e17 	andeq	r0, r3, r7, lsl lr
     ab8:	0a030100 	beq	c0ec0 <_bss_end+0xb7c68>
     abc:	92200305 	eorls	r0, r0, #335544320	; 0x14000000
     ac0:	42180000 	andsmi	r0, r8, #0
     ac4:	1c000007 	stcne	0, cr0, [r0], {7}
     ac8:	1c00008c 	stcne	0, cr0, [r0], {140}	; 0x8c
     acc:	01000000 	mrseq	r0, (UNDEF: 0)
     ad0:	05f5199c 	ldrbeq	r1, [r5, #2460]!	; 0x99c
     ad4:	8bc40000 	blhi	ff100adc <_bss_end+0xff0f7884>
     ad8:	00580000 	subseq	r0, r8, r0
     adc:	9c010000 	stcls	0, cr0, [r1], {-0}
     ae0:	00000369 	andeq	r0, r0, r9, ror #6
     ae4:	0005bc1a 	andeq	fp, r5, sl, lsl ip
     ae8:	01cb0100 	biceq	r0, fp, r0, lsl #2
     aec:	00000369 	andeq	r0, r0, r9, ror #6
     af0:	1a749102 	bne	1d24f00 <_bss_end+0x1d1bca8>
     af4:	000004c4 	andeq	r0, r0, r4, asr #9
     af8:	6901cb01 	stmdbvs	r1, {r0, r8, r9, fp, lr, pc}
     afc:	02000003 	andeq	r0, r0, #3
     b00:	1b007091 	blne	1cd4c <_bss_end+0x13af4>
     b04:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
     b08:	4b1c0074 	blmi	700ce0 <_bss_end+0x6f7a88>
     b0c:	01000002 	tsteq	r0, r2
     b10:	038a06b1 	orreq	r0, sl, #185597952	; 0xb100000
     b14:	8a580000 	bhi	1600b1c <_bss_end+0x15f78c4>
     b18:	016c0000 	cmneq	ip, r0
     b1c:	9c010000 	stcls	0, cr0, [r1], {-0}
     b20:	000003ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
     b24:	0004f51d 	andeq	pc, r4, sp, lsl r5	; <UNPREDICTABLE>
     b28:	0002df00 	andeq	sp, r2, r0, lsl #30
     b2c:	64910200 	ldrvs	r0, [r1], #512	; 0x200
     b30:	0009151a 	andeq	r1, r9, sl, lsl r5
     b34:	22b10100 	adcscs	r0, r1, #0, 2
     b38:	000002b6 			; <UNDEFINED> instruction: 0x000002b6
     b3c:	1a609102 	bne	1824f4c <_bss_end+0x181bcf4>
     b40:	0000090e 	andeq	r0, r0, lr, lsl #18
     b44:	f12fb101 			; <UNDEFINED> instruction: 0xf12fb101
     b48:	02000002 	andeq	r0, r0, #2
     b4c:	8e1a5c91 	mrchi	12, 0, r5, cr10, cr1, {4}
     b50:	01000006 	tsteq	r0, r6
     b54:	02b644b1 	adcseq	r4, r6, #-1325400064	; 0xb1000000
     b58:	91020000 	mrsls	r0, (UNDEF: 2)
     b5c:	00691e58 	rsbeq	r1, r9, r8, asr lr
     b60:	6909b301 	stmdbvs	r9, {r0, r8, r9, ip, sp, pc}
     b64:	02000003 	andeq	r0, r0, #3
     b68:	281f7491 	ldmdacs	pc, {r0, r4, r7, sl, ip, sp, lr}	; <UNPREDICTABLE>
     b6c:	8c00008b 	stchi	0, cr0, [r0], {139}	; 0x8b
     b70:	1e000000 	cdpne	0, 0, cr0, cr0, cr0, {0}
     b74:	c501006a 	strgt	r0, [r1, #-106]	; 0xffffff96
     b78:	0003690e 	andeq	r6, r3, lr, lsl #18
     b7c:	70910200 	addsvc	r0, r1, r0, lsl #4
     b80:	008b441f 	addeq	r4, fp, pc, lsl r4
     b84:	00006000 	andeq	r6, r0, r0
     b88:	00631e00 	rsbeq	r1, r3, r0, lsl #28
     b8c:	cd0ec701 	stcgt	7, cr12, [lr, #-4]
     b90:	02000002 	andeq	r0, r0, #2
     b94:	00006f91 	muleq	r0, r1, pc	; <UNPREDICTABLE>
     b98:	02092000 	andeq	r2, r9, #0
     b9c:	9e010000 	cdpls	0, 0, cr0, cr1, cr0, {0}
     ba0:	0004190e 	andeq	r1, r4, lr, lsl #18
     ba4:	008db400 	addeq	fp, sp, r0, lsl #8
     ba8:	00007c00 	andeq	r7, r0, r0, lsl #24
     bac:	409c0100 	addsmi	r0, ip, r0, lsl #2
     bb0:	1d000004 	stcne	0, cr0, [r0, #-16]
     bb4:	000004f5 	strdeq	r0, [r0], -r5
     bb8:	000002df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
     bbc:	21749102 	cmncs	r4, r2, lsl #2
     bc0:	9e010061 	cdpls	0, 0, cr0, cr1, cr1, {3}
     bc4:	0002b62f 	andeq	fp, r2, pc, lsr #12
     bc8:	70910200 	addsvc	r0, r1, r0, lsl #4
     bcc:	01006221 	tsteq	r0, r1, lsr #4
     bd0:	02b63f9e 	adcseq	r3, r6, #632	; 0x278
     bd4:	91020000 	mrsls	r0, (UNDEF: 2)
     bd8:	e120006c 			; <UNDEFINED> instruction: 0xe120006c
     bdc:	01000001 	tsteq	r0, r1
     be0:	045a0e87 	ldrbeq	r0, [sl], #-3719	; 0xfffff179
     be4:	8d240000 	stchi	0, cr0, [r4, #-0]
     be8:	00900000 	addseq	r0, r0, r0
     bec:	9c010000 	stcls	0, cr0, [r1], {-0}
     bf0:	00000490 	muleq	r0, r0, r4
     bf4:	0004f51d 	andeq	pc, r4, sp, lsl r5	; <UNPREDICTABLE>
     bf8:	0002df00 	andeq	sp, r2, r0, lsl #30
     bfc:	6c910200 	lfmvs	f0, 4, [r1], {0}
     c00:	01006121 	tsteq	r0, r1, lsr #2
     c04:	02b62c87 	adcseq	r2, r6, #34560	; 0x8700
     c08:	91020000 	mrsls	r0, (UNDEF: 2)
     c0c:	00622168 	rsbeq	r2, r2, r8, ror #2
     c10:	b63c8701 	ldrtlt	r8, [ip], -r1, lsl #14
     c14:	02000002 	andeq	r0, r0, #2
     c18:	5e226491 	mcrpl	4, 1, r6, cr2, cr1, {4}
     c1c:	01000006 	tsteq	r0, r6
     c20:	02b61293 	adcseq	r1, r6, #805306377	; 0x30000009
     c24:	91020000 	mrsls	r0, (UNDEF: 2)
     c28:	6f1c0074 	svcvs	0x001c0074
     c2c:	01000001 	tsteq	r0, r1
     c30:	04aa0b77 	strteq	r0, [sl], #2935	; 0xb77
     c34:	89f80000 	ldmibhi	r8!, {}^	; <UNPREDICTABLE>
     c38:	00600000 	rsbeq	r0, r0, r0
     c3c:	9c010000 	stcls	0, cr0, [r1], {-0}
     c40:	000004c6 	andeq	r0, r0, r6, asr #9
     c44:	0004f51d 	andeq	pc, r4, sp, lsl r5	; <UNPREDICTABLE>
     c48:	0002df00 	andeq	sp, r2, r0, lsl #30
     c4c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     c50:	0006581a 	andeq	r5, r6, sl, lsl r8
     c54:	25770100 	ldrbcs	r0, [r7, #-256]!	; 0xffffff00
     c58:	000002ea 	andeq	r0, r0, sl, ror #5
     c5c:	00739102 	rsbseq	r9, r3, r2, lsl #2
     c60:	00014b1c 	andeq	r4, r1, ip, lsl fp
     c64:	0b6a0100 	bleq	1a8106c <_bss_end+0x1a77e14>
     c68:	000004e0 	andeq	r0, r0, r0, ror #9
     c6c:	000089a4 	andeq	r8, r0, r4, lsr #19
     c70:	00000054 	andeq	r0, r0, r4, asr r0
     c74:	05209c01 	streq	r9, [r0, #-3073]!	; 0xfffff3ff
     c78:	f51d0000 			; <UNDEFINED> instruction: 0xf51d0000
     c7c:	df000004 	svcle	0x00000004
     c80:	02000002 	andeq	r0, r0, #2
     c84:	6e217491 	mcrvs	4, 1, r7, cr1, cr1, {4}
     c88:	01006d75 	tsteq	r0, r5, ror sp
     c8c:	02b62d6a 	adcseq	r2, r6, #6784	; 0x1a80
     c90:	91020000 	mrsls	r0, (UNDEF: 2)
     c94:	09242370 	stmdbeq	r4!, {r4, r5, r6, r8, r9, sp}
     c98:	6c010000 	stcvs	0, cr0, [r1], {-0}
     c9c:	0002bd23 	andeq	fp, r2, r3, lsr #26
     ca0:	5c030500 	cfstr32pl	mvfx0, [r3], {-0}
     ca4:	22000091 	andcs	r0, r0, #145	; 0x91
     ca8:	0000091b 	andeq	r0, r0, fp, lsl r9
     cac:	20116e01 	andscs	r6, r1, r1, lsl #28
     cb0:	05000005 	streq	r0, [r0, #-5]
     cb4:	00923803 	addseq	r3, r2, r3, lsl #16
     cb8:	cd240000 	stcgt	0, cr0, [r4, #-0]
     cbc:	30000002 	andcc	r0, r0, r2
     cc0:	25000005 	strcs	r0, [r0, #-5]
     cc4:	000002b6 			; <UNDEFINED> instruction: 0x000002b6
     cc8:	2720000f 	strcs	r0, [r0, -pc]!
     ccc:	01000001 	tsteq	r0, r1
     cd0:	054a0b63 	strbeq	r0, [sl, #-2915]	; 0xfffff49d
     cd4:	89700000 	ldmdbhi	r0!, {}^	; <UNPREDICTABLE>
     cd8:	00340000 	eorseq	r0, r4, r0
     cdc:	9c010000 	stcls	0, cr0, [r1], {-0}
     ce0:	00000566 	andeq	r0, r0, r6, ror #10
     ce4:	0004f51d 	andeq	pc, r4, sp, lsl r5	; <UNPREDICTABLE>
     ce8:	0002df00 	andeq	sp, r2, r0, lsl #30
     cec:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     cf0:	0006871a 	andeq	r8, r6, sl, lsl r7
     cf4:	37630100 	strbcc	r0, [r3, -r0, lsl #2]!
     cf8:	00000032 	andeq	r0, r0, r2, lsr r0
     cfc:	00709102 	rsbseq	r9, r0, r2, lsl #2
     d00:	0001031c 	andeq	r0, r1, ip, lsl r3
     d04:	0b570100 	bleq	15c110c <_bss_end+0x15b7eb4>
     d08:	00000580 	andeq	r0, r0, r0, lsl #11
     d0c:	000088f8 	strdeq	r8, [r0], -r8	; <UNPREDICTABLE>
     d10:	00000078 	andeq	r0, r0, r8, ror r0
     d14:	05b39c01 	ldreq	r9, [r3, #3073]!	; 0xc01
     d18:	f51d0000 			; <UNDEFINED> instruction: 0xf51d0000
     d1c:	df000004 	svcle	0x00000004
     d20:	02000002 	andeq	r0, r0, #2
     d24:	73216c91 			; <UNDEFINED> instruction: 0x73216c91
     d28:	01007274 	tsteq	r0, r4, ror r2
     d2c:	02c22c57 	sbceq	r2, r2, #22272	; 0x5700
     d30:	91020000 	mrsls	r0, (UNDEF: 2)
     d34:	890c1f68 	stmdbhi	ip, {r3, r5, r6, r8, r9, sl, fp, ip}
     d38:	004c0000 	subeq	r0, ip, r0
     d3c:	691e0000 	ldmdbvs	lr, {}	; <UNPREDICTABLE>
     d40:	17590100 	ldrbne	r0, [r9, -r0, lsl #2]
     d44:	000002b6 			; <UNDEFINED> instruction: 0x000002b6
     d48:	00749102 	rsbseq	r9, r4, r2, lsl #2
     d4c:	00df1c00 	sbcseq	r1, pc, r0, lsl #24
     d50:	45010000 	strmi	r0, [r1, #-0]
     d54:	0005cd0b 	andeq	ip, r5, fp, lsl #26
     d58:	00885000 	addeq	r5, r8, r0
     d5c:	0000a800 	andeq	sl, r0, r0, lsl #16
     d60:	e79c0100 	ldr	r0, [ip, r0, lsl #2]
     d64:	1d000005 	stcne	0, cr0, [r0, #-20]	; 0xffffffec
     d68:	000004f5 	strdeq	r0, [r0], -r5
     d6c:	000002df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
     d70:	21749102 	cmncs	r4, r2, lsl #2
     d74:	45010063 	strmi	r0, [r1, #-99]	; 0xffffff9d
     d78:	0002cd25 	andeq	ip, r2, r5, lsr #26
     d7c:	73910200 	orrsvc	r0, r1, #0, 4
     d80:	01c72000 	biceq	r2, r7, r0
     d84:	40010000 	andmi	r0, r1, r0
     d88:	00060106 	andeq	r0, r6, r6, lsl #2
     d8c:	008cf800 	addeq	pc, ip, r0, lsl #16
     d90:	00002c00 	andeq	r2, r0, r0, lsl #24
     d94:	0e9c0100 	fmleqe	f0, f4, f0
     d98:	1d000006 	stcne	0, cr0, [r0, #-24]	; 0xffffffe8
     d9c:	000004f5 	strdeq	r0, [r0], -r5
     da0:	000002df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
     da4:	00749102 	rsbseq	r9, r4, r2, lsl #2
     da8:	00023120 	andeq	r3, r2, r0, lsr #2
     dac:	06300100 	ldrteq	r0, [r0], -r0, lsl #2
     db0:	00000628 	andeq	r0, r0, r8, lsr #12
     db4:	00008720 	andeq	r8, r0, r0, lsr #14
     db8:	00000130 	andeq	r0, r0, r0, lsr r1
     dbc:	067e9c01 	ldrbteq	r9, [lr], -r1, lsl #24
     dc0:	f51d0000 			; <UNDEFINED> instruction: 0xf51d0000
     dc4:	df000004 	svcle	0x00000004
     dc8:	02000002 	andeq	r0, r0, #2
     dcc:	30266491 	mlacc	r6, r1, r4, r6
     dd0:	b0000087 	andlt	r0, r0, r7, lsl #1
     dd4:	66000000 	strvs	r0, [r0], -r0
     dd8:	1e000006 	cdpne	0, 0, cr0, cr0, cr6, {0}
     ddc:	32010079 	andcc	r0, r1, #121	; 0x79
     de0:	0002b617 	andeq	fp, r2, r7, lsl r6
     de4:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     de8:	00874c1f 	addeq	r4, r7, pc, lsl ip
     dec:	00008400 	andeq	r8, r0, r0, lsl #8
     df0:	00781e00 	rsbseq	r1, r8, r0, lsl #28
     df4:	b61b3401 	ldrlt	r3, [fp], -r1, lsl #8
     df8:	02000002 	andeq	r0, r0, #2
     dfc:	00007091 	muleq	r0, r1, r0
     e00:	0087e01f 	addeq	lr, r7, pc, lsl r0
     e04:	00006000 	andeq	r6, r0, r0
     e08:	00781e00 	rsbseq	r1, r8, r0, lsl #28
     e0c:	b6173a01 	ldrlt	r3, [r7], -r1, lsl #20
     e10:	02000002 	andeq	r0, r0, #2
     e14:	00006c91 	muleq	r0, r1, ip
     e18:	0001931c 	andeq	r9, r1, ip, lsl r3
     e1c:	06210100 	strteq	r0, [r1], -r0, lsl #2
     e20:	00000698 	muleq	r0, r8, r6
     e24:	00008c70 	andeq	r8, r0, r0, ror ip
     e28:	00000088 	andeq	r0, r0, r8, lsl #1
     e2c:	06a59c01 	strteq	r9, [r5], r1, lsl #24
     e30:	f51d0000 			; <UNDEFINED> instruction: 0xf51d0000
     e34:	df000004 	svcle	0x00000004
     e38:	02000002 	andeq	r0, r0, #2
     e3c:	1c007491 	cfstrsne	mvf7, [r0], {145}	; 0x91
     e40:	000000c4 	andeq	r0, r0, r4, asr #1
     e44:	bf061401 	svclt	0x00061401
     e48:	78000006 	stmdavc	r0, {r1, r2}
     e4c:	a8000086 	stmdage	r0, {r1, r2, r7}
     e50:	01000000 	mrseq	r0, (UNDEF: 0)
     e54:	0006fa9c 	muleq	r6, ip, sl
     e58:	04f51d00 	ldrbteq	r1, [r5], #3328	; 0xd00
     e5c:	02df0000 	sbcseq	r0, pc, #0
     e60:	91020000 	mrsls	r0, (UNDEF: 2)
     e64:	86901f6c 	ldrhi	r1, [r0], ip, ror #30
     e68:	00840000 	addeq	r0, r4, r0
     e6c:	791e0000 	ldmdbvc	lr, {}	; <UNPREDICTABLE>
     e70:	17180100 	ldrne	r0, [r8, -r0, lsl #2]
     e74:	000002b6 			; <UNDEFINED> instruction: 0x000002b6
     e78:	1f749102 	svcne	0x00749102
     e7c:	000086ac 	andeq	r8, r0, ip, lsr #13
     e80:	00000058 	andeq	r0, r0, r8, asr r0
     e84:	0100781e 	tsteq	r0, lr, lsl r8
     e88:	02b61b1a 	adcseq	r1, r6, #26624	; 0x6800
     e8c:	91020000 	mrsls	r0, (UNDEF: 2)
     e90:	00000070 	andeq	r0, r0, r0, ror r0
     e94:	0001ad20 	andeq	sl, r1, r0, lsr #26
     e98:	060e0100 	streq	r0, [lr], -r0, lsl #2
     e9c:	00000714 	andeq	r0, r0, r4, lsl r7
     ea0:	00008c38 	andeq	r8, r0, r8, lsr ip
     ea4:	00000038 	andeq	r0, r0, r8, lsr r0
     ea8:	07219c01 	streq	r9, [r1, -r1, lsl #24]!
     eac:	f51d0000 			; <UNDEFINED> instruction: 0xf51d0000
     eb0:	df000004 	svcle	0x00000004
     eb4:	02000002 	andeq	r0, r0, #2
     eb8:	27007491 			; <UNDEFINED> instruction: 0x27007491
     ebc:	00000096 	muleq	r0, r6, r0
     ec0:	32010501 	andcc	r0, r1, #4194304	; 0x400000
     ec4:	00000007 	andeq	r0, r0, r7
     ec8:	00000760 	andeq	r0, r0, r0, ror #14
     ecc:	0004f528 	andeq	pc, r4, r8, lsr #10
     ed0:	0002df00 	andeq	sp, r2, r0, lsl #30
     ed4:	075a2900 	ldrbeq	r2, [sl, -r0, lsl #18]
     ed8:	05010000 	streq	r0, [r1, #-0]
     edc:	0002b621 	andeq	fp, r2, r1, lsr #12
     ee0:	083a2900 	ldmdaeq	sl!, {r8, fp, sp}
     ee4:	05010000 	streq	r0, [r1, #-0]
     ee8:	0002b641 	andeq	fp, r2, r1, asr #12
     eec:	07fa2900 	ldrbeq	r2, [sl, r0, lsl #18]!
     ef0:	05010000 	streq	r0, [r1, #-0]
     ef4:	0002b655 	andeq	fp, r2, r5, asr r6
     ef8:	212a0000 			; <UNDEFINED> instruction: 0x212a0000
     efc:	c5000007 	strgt	r0, [r0, #-7]
     f00:	77000006 	strvc	r0, [r0, -r6]
     f04:	00000007 	andeq	r0, r0, r7
     f08:	78000086 	stmdavc	r0, {r1, r2, r7}
     f0c:	01000000 	mrseq	r0, (UNDEF: 0)
     f10:	07322b9c 			; <UNDEFINED> instruction: 0x07322b9c
     f14:	91020000 	mrsls	r0, (UNDEF: 2)
     f18:	073b2b74 			; <UNDEFINED> instruction: 0x073b2b74
     f1c:	91020000 	mrsls	r0, (UNDEF: 2)
     f20:	07472b70 	smlsldxeq	r2, r7, r0, fp
     f24:	91020000 	mrsls	r0, (UNDEF: 2)
     f28:	07532b6c 	ldrbeq	r2, [r3, -ip, ror #22]
     f2c:	91020000 	mrsls	r0, (UNDEF: 2)
     f30:	54000068 	strpl	r0, [r0], #-104	; 0xffffff98
     f34:	04000005 	streq	r0, [r0], #-5
     f38:	0005db00 	andeq	sp, r5, r0, lsl #22
     f3c:	00010400 	andeq	r0, r1, r0, lsl #8
     f40:	04000000 	streq	r0, [r0], #-0
     f44:	0000094f 	andeq	r0, r0, pc, asr #18
     f48:	0000014d 	andeq	r0, r0, sp, asr #2
     f4c:	00008e30 	andeq	r8, r0, r0, lsr lr
     f50:	000001b4 			; <UNDEFINED> instruction: 0x000001b4
     f54:	0000082d 	andeq	r0, r0, sp, lsr #16
     f58:	8e080102 	adfhie	f0, f0, f2
     f5c:	03000003 	movweq	r0, #3
     f60:	00000025 	andeq	r0, r0, r5, lsr #32
     f64:	96050202 	strls	r0, [r5], -r2, lsl #4
     f68:	04000005 	streq	r0, [r0], #-5
     f6c:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
     f70:	ed050074 	stc	0, cr0, [r5, #-464]	; 0xfffffe30
     f74:	02000004 	andeq	r0, r0, #4
     f78:	004b0709 	subeq	r0, fp, r9, lsl #14
     f7c:	01020000 	mrseq	r0, (UNDEF: 2)
     f80:	00038508 	andeq	r8, r3, r8, lsl #10
     f84:	004b0600 	subeq	r0, fp, r0, lsl #12
     f88:	02020000 	andeq	r0, r2, #0
     f8c:	0003c307 	andeq	ip, r3, r7, lsl #6
     f90:	05a00500 	streq	r0, [r0, #1280]!	; 0x500
     f94:	0b020000 	bleq	80f9c <_bss_end+0x77d44>
     f98:	00006f07 	andeq	r6, r0, r7, lsl #30
     f9c:	005e0300 	subseq	r0, lr, r0, lsl #6
     fa0:	04020000 	streq	r0, [r2], #-0
     fa4:	000f8307 	andeq	r8, pc, r7, lsl #6
     fa8:	006f0600 	rsbeq	r0, pc, r0, lsl #12
     fac:	4c070000 	stcmi	0, cr0, [r7], {-0}
     fb0:	07000005 	streq	r0, [r0, -r5]
     fb4:	00003f01 	andeq	r3, r0, r1, lsl #30
     fb8:	0c060300 	stceq	3, cr0, [r6], {-0}
     fbc:	000000c4 	andeq	r0, r0, r4, asr #1
     fc0:	0004be08 	andeq	fp, r4, r8, lsl #28
     fc4:	1e080000 	cdpne	0, 0, cr0, cr8, cr0, {0}
     fc8:	01000002 	tsteq	r0, r2
     fcc:	0003f908 	andeq	pc, r3, r8, lsl #18
     fd0:	f3080200 	vhsub.u8	d0, d8, d0
     fd4:	03000003 	movweq	r0, #3
     fd8:	00039908 	andeq	r9, r3, r8, lsl #18
     fdc:	79080400 	stmdbvc	r8, {sl}
     fe0:	05000003 	streq	r0, [r0, #-3]
     fe4:	00039308 	andeq	r9, r3, r8, lsl #6
     fe8:	73080600 	movwvc	r0, #34304	; 0x8600
     fec:	07000003 	streq	r0, [r0, -r3]
     ff0:	00022508 	andeq	r2, r2, r8, lsl #10
     ff4:	09000800 	stmdbeq	r0, {fp}
     ff8:	0000020c 	andeq	r0, r0, ip, lsl #4
     ffc:	071a0304 	ldreq	r0, [sl, -r4, lsl #6]
    1000:	00000225 	andeq	r0, r0, r5, lsr #4
    1004:	0005720a 	andeq	r7, r5, sl, lsl #4
    1008:	191e0300 	ldmdbne	lr, {r8, r9}
    100c:	00000230 	andeq	r0, r0, r0, lsr r2
    1010:	02fb0b00 	rscseq	r0, fp, #0, 22
    1014:	22030000 	andcs	r0, r3, #0
    1018:	00030f0a 	andeq	r0, r3, sl, lsl #30
    101c:	00023500 	andeq	r3, r2, r0, lsl #10
    1020:	00f70200 	rscseq	r0, r7, r0, lsl #4
    1024:	010c0000 	mrseq	r0, (UNDEF: 12)
    1028:	3c0c0000 	stccc	0, cr0, [ip], {-0}
    102c:	0d000002 	stceq	0, cr0, [r0, #-8]
    1030:	0000005e 	andeq	r0, r0, lr, asr r0
    1034:	0002420d 	andeq	r4, r2, sp, lsl #4
    1038:	02420d00 	subeq	r0, r2, #0, 26
    103c:	0b000000 	bleq	1044 <_start-0x6fbc>
    1040:	0000039f 	muleq	r0, pc, r3	; <UNPREDICTABLE>
    1044:	b00a2403 	andlt	r2, sl, r3, lsl #8
    1048:	35000002 	strcc	r0, [r0, #-2]
    104c:	02000002 	andeq	r0, r0, #2
    1050:	00000125 	andeq	r0, r0, r5, lsr #2
    1054:	0000013a 	andeq	r0, r0, sl, lsr r1
    1058:	00023c0c 	andeq	r3, r2, ip, lsl #24
    105c:	005e0d00 	subseq	r0, lr, r0, lsl #26
    1060:	420d0000 	andmi	r0, sp, #0
    1064:	0d000002 	stceq	0, cr0, [r0, #-8]
    1068:	00000242 	andeq	r0, r0, r2, asr #4
    106c:	033f0b00 	teqeq	pc, #0, 22
    1070:	26030000 	strcs	r0, [r3], -r0
    1074:	0002810a 	andeq	r8, r2, sl, lsl #2
    1078:	00023500 	andeq	r3, r2, r0, lsl #10
    107c:	01530200 	cmpeq	r3, r0, lsl #4
    1080:	01680000 	cmneq	r8, r0
    1084:	3c0c0000 	stccc	0, cr0, [ip], {-0}
    1088:	0d000002 	stceq	0, cr0, [r0, #-8]
    108c:	0000005e 	andeq	r0, r0, lr, asr r0
    1090:	0002420d 	andeq	r4, r2, sp, lsl #4
    1094:	02420d00 	subeq	r0, r2, #0, 26
    1098:	0b000000 	bleq	10a0 <_start-0x6f60>
    109c:	000005e2 	andeq	r0, r0, r2, ror #11
    10a0:	400a2803 	andmi	r2, sl, r3, lsl #16
    10a4:	35000002 	strcc	r0, [r0, #-2]
    10a8:	02000002 	andeq	r0, r0, #2
    10ac:	00000181 	andeq	r0, r0, r1, lsl #3
    10b0:	00000196 	muleq	r0, r6, r1
    10b4:	00023c0c 	andeq	r3, r2, ip, lsl #24
    10b8:	005e0d00 	subseq	r0, lr, r0, lsl #26
    10bc:	420d0000 	andmi	r0, sp, #0
    10c0:	0d000002 	stceq	0, cr0, [r0, #-8]
    10c4:	00000242 	andeq	r0, r0, r2, asr #4
    10c8:	020c0b00 	andeq	r0, ip, #0, 22
    10cc:	2b030000 	blcs	c10d4 <_bss_end+0xb7e7c>
    10d0:	0005cb05 	andeq	ip, r5, r5, lsl #22
    10d4:	00024800 	andeq	r4, r2, r0, lsl #16
    10d8:	01af0100 			; <UNDEFINED> instruction: 0x01af0100
    10dc:	01ba0000 			; <UNDEFINED> instruction: 0x01ba0000
    10e0:	480c0000 	stmdami	ip, {}	; <UNPREDICTABLE>
    10e4:	0d000002 	stceq	0, cr0, [r0, #-8]
    10e8:	0000006f 	andeq	r0, r0, pc, rrx
    10ec:	04210e00 	strteq	r0, [r1], #-3584	; 0xfffff200
    10f0:	2e030000 	cdpcs	0, 0, cr0, cr3, cr0, {0}
    10f4:	0005230a 	andeq	r2, r5, sl, lsl #6
    10f8:	01cf0100 	biceq	r0, pc, r0, lsl #2
    10fc:	01df0000 	bicseq	r0, pc, r0
    1100:	480c0000 	stmdami	ip, {}	; <UNPREDICTABLE>
    1104:	0d000002 	stceq	0, cr0, [r0, #-8]
    1108:	0000005e 	andeq	r0, r0, lr, asr r0
    110c:	00007b0d 	andeq	r7, r0, sp, lsl #22
    1110:	6f0b0000 	svcvs	0x000b0000
    1114:	03000002 	movweq	r0, #2
    1118:	04fa1430 	ldrbteq	r1, [sl], #1072	; 0x430
    111c:	007b0000 	rsbseq	r0, fp, r0
    1120:	f8010000 			; <UNDEFINED> instruction: 0xf8010000
    1124:	03000001 	movweq	r0, #1
    1128:	0c000002 	stceq	0, cr0, [r0], {2}
    112c:	0000023c 	andeq	r0, r0, ip, lsr r2
    1130:	00005e0d 	andeq	r5, r0, sp, lsl #28
    1134:	1a0f0000 	bne	3c113c <_bss_end+0x3b7ee4>
    1138:	03000002 	movweq	r0, #2
    113c:	03ff0a33 	mvnseq	r0, #208896	; 0x33000
    1140:	14010000 	strne	r0, [r1], #-0
    1144:	0c000002 	stceq	0, cr0, [r0], {2}
    1148:	00000248 	andeq	r0, r0, r8, asr #4
    114c:	00005e0d 	andeq	r5, r0, sp, lsl #28
    1150:	02350d00 	eorseq	r0, r5, #0, 26
    1154:	00000000 	andeq	r0, r0, r0
    1158:	0000c403 	andeq	ip, r0, r3, lsl #8
    115c:	6f041000 	svcvs	0x00041000
    1160:	03000000 	movweq	r0, #0
    1164:	0000022a 	andeq	r0, r0, sl, lsr #4
    1168:	a9020102 	stmdbge	r2, {r1, r8}
    116c:	10000005 	andne	r0, r0, r5
    1170:	00022504 	andeq	r2, r2, r4, lsl #10
    1174:	5e041100 	adfpls	f1, f4, f0
    1178:	10000000 	andne	r0, r0, r0
    117c:	0000c404 	andeq	ip, r0, r4, lsl #8
    1180:	02f51200 	rscseq	r1, r5, #0, 4
    1184:	37030000 	strcc	r0, [r3, -r0]
    1188:	0000c416 	andeq	ip, r0, r6, lsl r4
    118c:	07a30900 	streq	r0, [r3, r0, lsl #18]!
    1190:	04180000 	ldreq	r0, [r8], #-0
    1194:	04eb0703 	strbteq	r0, [fp], #1795	; 0x703
    1198:	ff130000 			; <UNDEFINED> instruction: 0xff130000
    119c:	07000006 	streq	r0, [r0, -r6]
    11a0:	00006f04 	andeq	r6, r0, r4, lsl #30
    11a4:	10060400 	andne	r0, r6, r0, lsl #8
    11a8:	00028701 	andeq	r8, r2, r1, lsl #14
    11ac:	45481400 	strbmi	r1, [r8, #-1024]	; 0xfffffc00
    11b0:	14100058 	ldrne	r0, [r0], #-88	; 0xffffffa8
    11b4:	00434544 	subeq	r4, r3, r4, asr #10
    11b8:	6703000a 	strvs	r0, [r3, -sl]
    11bc:	15000002 	strne	r0, [r0, #-2]
    11c0:	0000070c 	andeq	r0, r0, ip, lsl #14
    11c4:	0c270408 	cfstrseq	mvf0, [r7], #-32	; 0xffffffe0
    11c8:	000002b0 			; <UNDEFINED> instruction: 0x000002b0
    11cc:	04007916 	streq	r7, [r0], #-2326	; 0xfffff6ea
    11d0:	006f1629 	rsbeq	r1, pc, r9, lsr #12
    11d4:	16000000 	strne	r0, [r0], -r0
    11d8:	2a040078 	bcs	1013c0 <_bss_end+0xf8168>
    11dc:	00006f16 	andeq	r6, r0, r6, lsl pc
    11e0:	17000400 	strne	r0, [r0, -r0, lsl #8]
    11e4:	000008fa 	strdeq	r0, [r0], -sl
    11e8:	871b0c04 	ldrhi	r0, [fp, -r4, lsl #24]
    11ec:	01000002 	tsteq	r0, r2
    11f0:	080a180a 	stmdaeq	sl, {r1, r3, fp, ip}
    11f4:	0d040000 	stceq	0, cr0, [r4, #-0]
    11f8:	0004f128 	andeq	pc, r4, r8, lsr #2
    11fc:	a3190100 	tstge	r9, #0, 2
    1200:	04000007 	streq	r0, [r0], #-7
    1204:	08e70e10 	stmiaeq	r7!, {r4, r9, sl, fp}^
    1208:	04f60000 	ldrbteq	r0, [r6], #0
    120c:	e4010000 	str	r0, [r1], #-0
    1210:	f9000002 			; <UNDEFINED> instruction: 0xf9000002
    1214:	0c000002 	stceq	0, cr0, [r0], {2}
    1218:	000004f6 	strdeq	r0, [r0], -r6
    121c:	00006f0d 	andeq	r6, r0, sp, lsl #30
    1220:	006f0d00 	rsbeq	r0, pc, r0, lsl #26
    1224:	6f0d0000 	svcvs	0x000d0000
    1228:	00000000 	andeq	r0, r0, r0
    122c:	0006bf0e 	andeq	fp, r6, lr, lsl #30
    1230:	0a120400 	beq	482238 <_bss_end+0x478fe0>
    1234:	0000076c 	andeq	r0, r0, ip, ror #14
    1238:	00030e01 	andeq	r0, r3, r1, lsl #28
    123c:	00031400 	andeq	r1, r3, r0, lsl #8
    1240:	04f60c00 	ldrbteq	r0, [r6], #3072	; 0xc00
    1244:	0b000000 	bleq	124c <_start-0x6db4>
    1248:	000007c3 	andeq	r0, r0, r3, asr #15
    124c:	270f1404 	strcs	r1, [pc, -r4, lsl #8]
    1250:	fc000008 	stc2	0, cr0, [r0], {8}
    1254:	01000004 	tsteq	r0, r4
    1258:	0000032d 	andeq	r0, r0, sp, lsr #6
    125c:	00000338 	andeq	r0, r0, r8, lsr r3
    1260:	0004f60c 	andeq	pc, r4, ip, lsl #12
    1264:	00250d00 	eoreq	r0, r5, r0, lsl #26
    1268:	0b000000 	bleq	1270 <_start-0x6d90>
    126c:	000007c3 	andeq	r0, r0, r3, asr #15
    1270:	ce0f1504 	cfsh32gt	mvfx1, mvfx15, #4
    1274:	fc000007 	stc2	0, cr0, [r0], {7}
    1278:	01000004 	tsteq	r0, r4
    127c:	00000351 	andeq	r0, r0, r1, asr r3
    1280:	0000035c 	andeq	r0, r0, ip, asr r3
    1284:	0004f60c 	andeq	pc, r4, ip, lsl #12
    1288:	04eb0d00 	strbteq	r0, [fp], #3328	; 0xd00
    128c:	0b000000 	bleq	1294 <_start-0x6d6c>
    1290:	000007c3 	andeq	r0, r0, r3, asr #15
    1294:	810f1604 	tsthi	pc, r4, lsl #12
    1298:	fc000007 	stc2	0, cr0, [r0], {7}
    129c:	01000004 	tsteq	r0, r4
    12a0:	00000375 	andeq	r0, r0, r5, ror r3
    12a4:	00000380 	andeq	r0, r0, r0, lsl #7
    12a8:	0004f60c 	andeq	pc, r4, ip, lsl #12
    12ac:	02670d00 	rsbeq	r0, r7, #0, 26
    12b0:	0b000000 	bleq	12b8 <_start-0x6d48>
    12b4:	000007c3 	andeq	r0, r0, r3, asr #15
    12b8:	b90f1704 	stmdblt	pc, {r2, r8, r9, sl, ip}	; <UNPREDICTABLE>
    12bc:	fc000008 	stc2	0, cr0, [r0], {8}
    12c0:	01000004 	tsteq	r0, r4
    12c4:	00000399 	muleq	r0, r9, r3
    12c8:	000003a4 	andeq	r0, r0, r4, lsr #7
    12cc:	0004f60c 	andeq	pc, r4, ip, lsl #12
    12d0:	006f0d00 	rsbeq	r0, pc, r0, lsl #26
    12d4:	0b000000 	bleq	12dc <_start-0x6d24>
    12d8:	000007c3 	andeq	r0, r0, r3, asr #15
    12dc:	160f1804 	strne	r1, [pc], -r4, lsl #16
    12e0:	fc000008 	stc2	0, cr0, [r0], {8}
    12e4:	01000004 	tsteq	r0, r4
    12e8:	000003bd 			; <UNDEFINED> instruction: 0x000003bd
    12ec:	000003c8 	andeq	r0, r0, r8, asr #7
    12f0:	0004f60c 	andeq	pc, r4, ip, lsl #12
    12f4:	02350d00 	eorseq	r0, r5, #0, 26
    12f8:	1a000000 	bne	1300 <_start-0x6d00>
    12fc:	000006ea 	andeq	r0, r0, sl, ror #13
    1300:	67111b04 	ldrvs	r1, [r1, -r4, lsl #22]
    1304:	dc000006 	stcle	0, cr0, [r0], {6}
    1308:	e2000003 	and	r0, r0, #3
    130c:	0c000003 	stceq	0, cr0, [r0], {3}
    1310:	000004f6 	strdeq	r0, [r0], -r6
    1314:	06dd1a00 	ldrbeq	r1, [sp], r0, lsl #20
    1318:	1c040000 	stcne	0, cr0, [r4], {-0}
    131c:	0008ca11 	andeq	ip, r8, r1, lsl sl
    1320:	0003f600 	andeq	pc, r3, r0, lsl #12
    1324:	0003fc00 	andeq	pc, r3, r0, lsl #24
    1328:	04f60c00 	ldrbteq	r0, [r6], #3072	; 0xc00
    132c:	1a000000 	bne	1334 <_start-0x6ccc>
    1330:	00000693 	muleq	r0, r3, r6
    1334:	16111d04 	ldrne	r1, [r1], -r4, lsl #26
    1338:	10000007 	andne	r0, r0, r7
    133c:	16000004 	strne	r0, [r0], -r4
    1340:	0c000004 	stceq	0, cr0, [r0], {4}
    1344:	000004f6 	strdeq	r0, [r0], -r6
    1348:	06f81b00 	ldrbteq	r1, [r8], r0, lsl #22
    134c:	1f040000 	svcne	0x00040000
    1350:	0007ac19 	andeq	sl, r7, r9, lsl ip
    1354:	00006f00 	andeq	r6, r0, r0, lsl #30
    1358:	00042e00 	andeq	r2, r4, r0, lsl #28
    135c:	00043e00 	andeq	r3, r4, r0, lsl #28
    1360:	04f60c00 	ldrbteq	r0, [r6], #3072	; 0xc00
    1364:	6f0d0000 	svcvs	0x000d0000
    1368:	0d000000 	stceq	0, cr0, [r0, #-0]
    136c:	0000006f 	andeq	r0, r0, pc, rrx
    1370:	09301b00 	ldmdbeq	r0!, {r8, r9, fp, ip}
    1374:	20040000 	andcs	r0, r4, r0
    1378:	0006a519 	andeq	sl, r6, r9, lsl r5
    137c:	00006f00 	andeq	r6, r0, r0, lsl #30
    1380:	00045600 	andeq	r5, r4, r0, lsl #12
    1384:	00046600 	andeq	r6, r4, r0, lsl #12
    1388:	04f60c00 	ldrbteq	r0, [r6], #3072	; 0xc00
    138c:	6f0d0000 	svcvs	0x000d0000
    1390:	0d000000 	stceq	0, cr0, [r0, #-0]
    1394:	0000006f 	andeq	r0, r0, pc, rrx
    1398:	06511a00 	ldrbeq	r1, [r1], -r0, lsl #20
    139c:	22040000 	andcs	r0, r4, #0
    13a0:	0008400a 	andeq	r4, r8, sl
    13a4:	00047a00 	andeq	r7, r4, r0, lsl #20
    13a8:	00048000 	andeq	r8, r4, r0
    13ac:	04f60c00 	ldrbteq	r0, [r6], #3072	; 0xc00
    13b0:	1a000000 	bne	13b8 <_start-0x6c48>
    13b4:	000006d8 	ldrdeq	r0, [r0], -r8
    13b8:	e10a2404 	tst	sl, r4, lsl #8
    13bc:	94000007 	strls	r0, [r0], #-7
    13c0:	a9000004 	stmdbge	r0, {r2}
    13c4:	0c000004 	stceq	0, cr0, [r0], {4}
    13c8:	000004f6 	strdeq	r0, [r0], -r6
    13cc:	00006f0d 	andeq	r6, r0, sp, lsl #30
    13d0:	05020d00 	streq	r0, [r2, #-3328]	; 0xfffff300
    13d4:	6f0d0000 	svcvs	0x000d0000
    13d8:	00000000 	andeq	r0, r0, r0
    13dc:	0007380a 	andeq	r3, r7, sl, lsl #16
    13e0:	232e0400 			; <UNDEFINED> instruction: 0x232e0400
    13e4:	0000050e 	andeq	r0, r0, lr, lsl #10
    13e8:	08380a00 	ldmdaeq	r8!, {r9, fp}
    13ec:	2f040000 	svccs	0x00040000
    13f0:	00006f12 	andeq	r6, r0, r2, lsl pc
    13f4:	f80a0400 			; <UNDEFINED> instruction: 0xf80a0400
    13f8:	04000007 	streq	r0, [r0], #-7
    13fc:	006f1230 	rsbeq	r1, pc, r0, lsr r2	; <UNPREDICTABLE>
    1400:	0a080000 	beq	201408 <_bss_end+0x1f81b0>
    1404:	00000801 	andeq	r0, r0, r1, lsl #16
    1408:	8c0f3104 	stfhis	f3, [pc], {4}
    140c:	0c000002 	stceq	0, cr0, [r0], {2}
    1410:	0006850a 	andeq	r8, r6, sl, lsl #10
    1414:	12320400 	eorsne	r0, r2, #0, 8
    1418:	00000267 	andeq	r0, r0, r7, ror #4
    141c:	04100014 	ldreq	r0, [r0], #-20	; 0xffffffec
    1420:	0000002c 	andeq	r0, r0, ip, lsr #32
    1424:	0004eb03 	andeq	lr, r4, r3, lsl #22
    1428:	5a041000 	bpl	105430 <_bss_end+0xfc1d8>
    142c:	11000002 	tstne	r0, r2
    1430:	00025a04 	andeq	r5, r2, r4, lsl #20
    1434:	25041000 	strcs	r1, [r4, #-0]
    1438:	10000000 	andne	r0, r0, r0
    143c:	00005204 	andeq	r5, r0, r4, lsl #4
    1440:	05080300 	streq	r0, [r8, #-768]	; 0xfffffd00
    1444:	51120000 	tstpl	r2, r0
    1448:	04000007 	streq	r0, [r0], #-7
    144c:	025a1135 	subseq	r1, sl, #1073741837	; 0x4000000d
    1450:	3a1c0000 	bcc	701458 <_bss_end+0x6f8200>
    1454:	01000009 	tsteq	r0, r9
    1458:	006a1405 	rsbeq	r1, sl, r5, lsl #8
    145c:	03050000 	movweq	r0, #20480	; 0x5000
    1460:	00009184 	andeq	r9, r0, r4, lsl #3
    1464:	0009421d 	andeq	r4, r9, sp, lsl r2
    1468:	10070100 	andne	r0, r7, r0, lsl #2
    146c:	00000038 	andeq	r0, r0, r8, lsr r0
    1470:	00008e30 	andeq	r8, r0, r0, lsr lr
    1474:	000001b4 			; <UNDEFINED> instruction: 0x000001b4
    1478:	741e9c01 	ldrvc	r9, [lr], #-3073	; 0xfffff3ff
    147c:	01006d69 	tsteq	r0, r9, ror #26
    1480:	00761b13 	rsbseq	r1, r6, r3, lsl fp
    1484:	91020000 	mrsls	r0, (UNDEF: 2)
    1488:	22000074 	andcs	r0, r0, #116	; 0x74
    148c:	02000000 	andeq	r0, r0, #0
    1490:	0007e300 	andeq	lr, r7, r0, lsl #6
    1494:	f3010400 	vshl.u8	d0, d0, d1
    1498:	00000009 	andeq	r0, r0, r9
    149c:	18000080 	stmdane	r0, {r7}
    14a0:	a7000080 	strge	r0, [r0, -r0, lsl #1]
    14a4:	4d000009 	stcmi	0, cr0, [r0, #-36]	; 0xffffffdc
    14a8:	fe000001 	cdp2	0, 0, cr0, cr0, cr1, {0}
    14ac:	01000009 	tsteq	r0, r9
    14b0:	00014b80 	andeq	r4, r1, r0, lsl #23
    14b4:	f7000400 			; <UNDEFINED> instruction: 0xf7000400
    14b8:	04000007 	streq	r0, [r0], #-7
    14bc:	00000001 	andeq	r0, r0, r1
    14c0:	0a130400 	beq	4c24c8 <_bss_end+0x4b9270>
    14c4:	014d0000 	mrseq	r0, (UNDEF: 77)
    14c8:	8fe40000 	svchi	0x00e40000
    14cc:	01180000 	tsteq	r8, r0
    14d0:	0a7c0000 	beq	1f014d8 <_bss_end+0x1ef8280>
    14d4:	0a020000 	beq	814dc <_bss_end+0x78284>
    14d8:	0100000a 	tsteq	r0, sl
    14dc:	00310702 	eorseq	r0, r1, r2, lsl #14
    14e0:	04030000 	streq	r0, [r3], #-0
    14e4:	00000037 	andeq	r0, r0, r7, lsr r0
    14e8:	0ac60204 	beq	ff181d00 <_bss_end+0xff178aa8>
    14ec:	03010000 	movweq	r0, #4096	; 0x1000
    14f0:	00003107 	andeq	r3, r0, r7, lsl #2
    14f4:	0a6e0500 	beq	1b828fc <_bss_end+0x1b796a4>
    14f8:	06010000 	streq	r0, [r1], -r0
    14fc:	00005010 	andeq	r5, r0, r0, lsl r0
    1500:	05040600 	streq	r0, [r4, #-1536]	; 0xfffffa00
    1504:	00746e69 	rsbseq	r6, r4, r9, ror #28
    1508:	000aaf05 	andeq	sl, sl, r5, lsl #30
    150c:	10080100 	andne	r0, r8, r0, lsl #2
    1510:	00000050 	andeq	r0, r0, r0, asr r0
    1514:	00002507 	andeq	r2, r0, r7, lsl #10
    1518:	00007600 	andeq	r7, r0, r0, lsl #12
    151c:	00760800 	rsbseq	r0, r6, r0, lsl #16
    1520:	ffff0000 			; <UNDEFINED> instruction: 0xffff0000
    1524:	0900ffff 	stmdbeq	r0, {r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, fp, ip, sp, lr, pc}
    1528:	0f830704 	svceq	0x00830704
    152c:	86050000 	strhi	r0, [r5], -r0
    1530:	0100000a 	tsteq	r0, sl
    1534:	0063150b 	rsbeq	r1, r3, fp, lsl #10
    1538:	79050000 	stmdbvc	r5, {}	; <UNPREDICTABLE>
    153c:	0100000a 	tsteq	r0, sl
    1540:	0063150d 	rsbeq	r1, r3, sp, lsl #10
    1544:	38070000 	stmdacc	r7, {}	; <UNPREDICTABLE>
    1548:	a8000000 	stmdage	r0, {}	; <UNPREDICTABLE>
    154c:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    1550:	00000076 	andeq	r0, r0, r6, ror r0
    1554:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
    1558:	0ab80500 	beq	fee02960 <_bss_end+0xfedf9708>
    155c:	10010000 	andne	r0, r1, r0
    1560:	00009515 	andeq	r9, r0, r5, lsl r5
    1564:	0a940500 	beq	fe50296c <_bss_end+0xfe4f9714>
    1568:	12010000 	andne	r0, r1, #0
    156c:	00009515 	andeq	r9, r0, r5, lsl r5
    1570:	0aa10a00 	beq	fe843d78 <_bss_end+0xfe83ab20>
    1574:	2b010000 	blcs	4157c <_bss_end+0x38324>
    1578:	00005010 	andeq	r5, r0, r0, lsl r0
    157c:	0090a400 	addseq	sl, r0, r0, lsl #8
    1580:	00005800 	andeq	r5, r0, r0, lsl #16
    1584:	ea9c0100 	b	fe70198c <_bss_end+0xfe6f8734>
    1588:	0b000000 	bleq	1590 <_start-0x6a70>
    158c:	00000ae7 	andeq	r0, r0, r7, ror #21
    1590:	ea0f2d01 	b	3cc99c <_bss_end+0x3c3744>
    1594:	02000000 	andeq	r0, r0, #0
    1598:	03007491 	movweq	r7, #1169	; 0x491
    159c:	00003804 	andeq	r3, r0, r4, lsl #16
    15a0:	0ada0a00 	beq	ff683da8 <_bss_end+0xff67ab50>
    15a4:	1f010000 	svcne	0x00010000
    15a8:	00005010 	andeq	r5, r0, r0, lsl r0
    15ac:	00904c00 	addseq	r4, r0, r0, lsl #24
    15b0:	00005800 	andeq	r5, r0, r0, lsl #16
    15b4:	1a9c0100 	bne	fe7019bc <_bss_end+0xfe6f8764>
    15b8:	0b000001 	bleq	15c4 <_start-0x6a3c>
    15bc:	00000ae7 	andeq	r0, r0, r7, ror #21
    15c0:	1a0f2101 	bne	3c99cc <_bss_end+0x3c0774>
    15c4:	02000001 	andeq	r0, r0, #1
    15c8:	03007491 	movweq	r7, #1169	; 0x491
    15cc:	00002504 	andeq	r2, r0, r4, lsl #10
    15d0:	0acf0c00 	beq	ff3c45d8 <_bss_end+0xff3bb380>
    15d4:	14010000 	strne	r0, [r1], #-0
    15d8:	00005010 	andeq	r5, r0, r0, lsl r0
    15dc:	008fe400 	addeq	lr, pc, r0, lsl #8
    15e0:	00006800 	andeq	r6, r0, r0, lsl #16
    15e4:	489c0100 	ldmmi	ip, {r8}
    15e8:	0d000001 	stceq	0, cr0, [r0, #-4]
    15ec:	16010069 	strne	r0, [r1], -r9, rrx
    15f0:	0001480a 	andeq	r4, r1, sl, lsl #16
    15f4:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    15f8:	50040300 	andpl	r0, r4, r0, lsl #6
    15fc:	00000000 	andeq	r0, r0, r0
    1600:	00000932 	andeq	r0, r0, r2, lsr r9
    1604:	08bd0004 	ldmfdeq	sp!, {r2}
    1608:	01040000 	mrseq	r0, (UNDEF: 4)
    160c:	00000e56 	andeq	r0, r0, r6, asr lr
    1610:	000dad0c 	andeq	sl, sp, ip, lsl #26
    1614:	00157a00 	andseq	r7, r5, r0, lsl #20
    1618:	000b7200 	andeq	r7, fp, r0, lsl #4
    161c:	05040200 	streq	r0, [r4, #-512]	; 0xfffffe00
    1620:	00746e69 	rsbseq	r6, r4, r9, ror #28
    1624:	83070403 	movwhi	r0, #29699	; 0x7403
    1628:	0300000f 	movweq	r0, #15
    162c:	01e80508 	mvneq	r0, r8, lsl #10
    1630:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    1634:	0016ba04 	andseq	fp, r6, r4, lsl #20
    1638:	0e080400 	cfcpyseq	mvf0, mvf8
    163c:	2a010000 	bcs	41644 <_bss_end+0x383ec>
    1640:	00002416 	andeq	r2, r0, r6, lsl r4
    1644:	12770400 	rsbsne	r0, r7, #0, 8
    1648:	2f010000 	svccs	0x00010000
    164c:	00005115 	andeq	r5, r0, r5, lsl r1
    1650:	57040500 	strpl	r0, [r4, -r0, lsl #10]
    1654:	06000000 	streq	r0, [r0], -r0
    1658:	00000039 	andeq	r0, r0, r9, lsr r0
    165c:	00000066 	andeq	r0, r0, r6, rrx
    1660:	00006607 	andeq	r6, r0, r7, lsl #12
    1664:	04050000 	streq	r0, [r5], #-0
    1668:	0000006c 	andeq	r0, r0, ip, rrx
    166c:	1a0e0408 	bne	382694 <_bss_end+0x37943c>
    1670:	36010000 	strcc	r0, [r1], -r0
    1674:	0000790f 	andeq	r7, r0, pc, lsl #18
    1678:	7f040500 	svcvc	0x00040500
    167c:	06000000 	streq	r0, [r0], -r0
    1680:	0000001d 	andeq	r0, r0, sp, lsl r0
    1684:	00000093 	muleq	r0, r3, r0
    1688:	00006607 	andeq	r6, r0, r7, lsl #12
    168c:	00660700 	rsbeq	r0, r6, r0, lsl #14
    1690:	03000000 	movweq	r0, #0
    1694:	03850801 	orreq	r0, r5, #65536	; 0x10000
    1698:	af090000 	svcge	0x00090000
    169c:	01000014 	tsteq	r0, r4, lsl r0
    16a0:	004512bb 	strheq	r1, [r5], #-43	; 0xffffffd5
    16a4:	3c090000 	stccc	0, cr0, [r9], {-0}
    16a8:	0100001a 	tsteq	r0, sl, lsl r0
    16ac:	006d10be 	strhteq	r1, [sp], #-14
    16b0:	01030000 	mrseq	r0, (UNDEF: 3)
    16b4:	00038706 	andeq	r8, r3, r6, lsl #14
    16b8:	11970a00 	orrsne	r0, r7, r0, lsl #20
    16bc:	01070000 	mrseq	r0, (UNDEF: 7)
    16c0:	00000093 	muleq	r0, r3, r0
    16c4:	e6061702 	str	r1, [r6], -r2, lsl #14
    16c8:	0b000001 	bleq	16d4 <_start-0x692c>
    16cc:	00000c66 	andeq	r0, r0, r6, ror #24
    16d0:	10b40b00 	adcsne	r0, r4, r0, lsl #22
    16d4:	0b010000 	bleq	416dc <_bss_end+0x38484>
    16d8:	000015df 	ldrdeq	r1, [r0], -pc	; <UNPREDICTABLE>
    16dc:	19500b02 	ldmdbne	r0, {r1, r8, r9, fp}^
    16e0:	0b030000 	bleq	c16e8 <_bss_end+0xb8490>
    16e4:	0000151e 	andeq	r1, r0, lr, lsl r5
    16e8:	18590b04 	ldmdane	r9, {r2, r8, r9, fp}^
    16ec:	0b050000 	bleq	1416f4 <_bss_end+0x13849c>
    16f0:	000017bd 			; <UNDEFINED> instruction: 0x000017bd
    16f4:	0c870b06 	vstmiaeq	r7, {d0-d2}
    16f8:	0b070000 	bleq	1c1700 <_bss_end+0x1b84a8>
    16fc:	0000186e 	andeq	r1, r0, lr, ror #16
    1700:	187c0b08 	ldmdane	ip!, {r3, r8, r9, fp}^
    1704:	0b090000 	bleq	24170c <_bss_end+0x2384b4>
    1708:	00001943 	andeq	r1, r0, r3, asr #18
    170c:	14750b0a 	ldrbtne	r0, [r5], #-2826	; 0xfffff4f6
    1710:	0b0b0000 	bleq	2c1718 <_bss_end+0x2b84c0>
    1714:	00000e49 	andeq	r0, r0, r9, asr #28
    1718:	0f260b0c 	svceq	0x00260b0c
    171c:	0b0d0000 	bleq	341724 <_bss_end+0x3384cc>
    1720:	000011db 	ldrdeq	r1, [r0], -fp
    1724:	11f10b0e 	mvnsne	r0, lr, lsl #22
    1728:	0b0f0000 	bleq	3c1730 <_bss_end+0x3b84d8>
    172c:	000010ee 	andeq	r1, r0, lr, ror #1
    1730:	15020b10 	strne	r0, [r2, #-2832]	; 0xfffff4f0
    1734:	0b110000 	bleq	44173c <_bss_end+0x4384e4>
    1738:	0000115a 	andeq	r1, r0, sl, asr r1
    173c:	1bd50b12 	blne	ff54438c <_bss_end+0xff53b134>
    1740:	0b130000 	bleq	4c1748 <_bss_end+0x4b84f0>
    1744:	00000cf0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    1748:	117e0b14 	cmnne	lr, r4, lsl fp
    174c:	0b150000 	bleq	541754 <_bss_end+0x5384fc>
    1750:	00000c2d 	andeq	r0, r0, sp, lsr #24
    1754:	19730b16 	ldmdbne	r3!, {r1, r2, r4, r8, r9, fp}^
    1758:	0b170000 	bleq	5c1760 <_bss_end+0x5b8508>
    175c:	00001a95 	muleq	r0, r5, sl
    1760:	11a30b18 			; <UNDEFINED> instruction: 0x11a30b18
    1764:	0b190000 	bleq	64176c <_bss_end+0x638514>
    1768:	00001651 	andeq	r1, r0, r1, asr r6
    176c:	19810b1a 	stmibne	r1, {r1, r3, r4, r8, r9, fp}
    1770:	0b1b0000 	bleq	6c1778 <_bss_end+0x6b8520>
    1774:	00000b5c 	andeq	r0, r0, ip, asr fp
    1778:	198f0b1c 	stmibne	pc, {r2, r3, r4, r8, r9, fp}	; <UNPREDICTABLE>
    177c:	0b1d0000 	bleq	741784 <_bss_end+0x73852c>
    1780:	0000199d 	muleq	r0, sp, r9
    1784:	0b0a0b1e 	bleq	284404 <_bss_end+0x27b1ac>
    1788:	0b1f0000 	bleq	7c1790 <_bss_end+0x7b8538>
    178c:	000019c7 	andeq	r1, r0, r7, asr #19
    1790:	16fe0b20 	ldrbtne	r0, [lr], r0, lsr #22
    1794:	0b210000 	bleq	84179c <_bss_end+0x838544>
    1798:	000014d4 	ldrdeq	r1, [r0], -r4
    179c:	19660b22 	stmdbne	r6!, {r1, r5, r8, r9, fp}^
    17a0:	0b230000 	bleq	8c17a8 <_bss_end+0x8b8550>
    17a4:	000013d8 	ldrdeq	r1, [r0], -r8
    17a8:	12da0b24 	sbcsne	r0, sl, #36, 22	; 0x9000
    17ac:	0b250000 	bleq	9417b4 <_bss_end+0x93855c>
    17b0:	00000ff4 	strdeq	r0, [r0], -r4
    17b4:	12f80b26 	rscsne	r0, r8, #38912	; 0x9800
    17b8:	0b270000 	bleq	9c17c0 <_bss_end+0x9b8568>
    17bc:	00001090 	muleq	r0, r0, r0
    17c0:	13080b28 	movwne	r0, #35624	; 0x8b28
    17c4:	0b290000 	bleq	a417cc <_bss_end+0xa38574>
    17c8:	00001318 	andeq	r1, r0, r8, lsl r3
    17cc:	145b0b2a 	ldrbne	r0, [fp], #-2858	; 0xfffff4d6
    17d0:	0b2b0000 	bleq	ac17d8 <_bss_end+0xab8580>
    17d4:	00001281 	andeq	r1, r0, r1, lsl #5
    17d8:	170b0b2c 	strne	r0, [fp, -ip, lsr #22]
    17dc:	0b2d0000 	bleq	b417e4 <_bss_end+0xb3858c>
    17e0:	00001035 	andeq	r1, r0, r5, lsr r0
    17e4:	130a002e 	movwne	r0, #41006	; 0xa02e
    17e8:	07000012 	smladeq	r0, r2, r0, r0
    17ec:	00009301 	andeq	r9, r0, r1, lsl #6
    17f0:	06170300 	ldreq	r0, [r7], -r0, lsl #6
    17f4:	000003c7 	andeq	r0, r0, r7, asr #7
    17f8:	000f480b 	andeq	r4, pc, fp, lsl #16
    17fc:	9a0b0000 	bls	2c1804 <_bss_end+0x2b85ac>
    1800:	0100000b 	tsteq	r0, fp
    1804:	001b830b 	andseq	r8, fp, fp, lsl #6
    1808:	160b0200 	strne	r0, [fp], -r0, lsl #4
    180c:	0300001a 	movweq	r0, #26
    1810:	000f680b 	andeq	r6, pc, fp, lsl #16
    1814:	520b0400 	andpl	r0, fp, #0, 8
    1818:	0500000c 	streq	r0, [r0, #-12]
    181c:	0010110b 	andseq	r1, r0, fp, lsl #2
    1820:	580b0600 	stmdapl	fp, {r9, sl}
    1824:	0700000f 	streq	r0, [r0, -pc]
    1828:	0018aa0b 	andseq	sl, r8, fp, lsl #20
    182c:	fb0b0800 	blx	2c3836 <_bss_end+0x2ba5de>
    1830:	09000019 	stmdbeq	r0, {r0, r3, r4}
    1834:	0017e10b 	andseq	lr, r7, fp, lsl #2
    1838:	a50b0a00 	strge	r0, [fp, #-2560]	; 0xfffff600
    183c:	0b00000c 	bleq	1874 <_start-0x678c>
    1840:	000fb20b 	andeq	fp, pc, fp, lsl #4
    1844:	1b0b0c00 	blne	2c484c <_bss_end+0x2bb5f4>
    1848:	0d00000c 	stceq	0, cr0, [r0, #-48]	; 0xffffffd0
    184c:	001bb80b 	andseq	fp, fp, fp, lsl #16
    1850:	480b0e00 	stmdami	fp, {r9, sl, fp}
    1854:	0f000014 	svceq	0x00000014
    1858:	0011250b 	andseq	r2, r1, fp, lsl #10
    185c:	850b1000 	strhi	r1, [fp, #-0]
    1860:	11000014 	tstne	r0, r4, lsl r0
    1864:	001ad70b 	andseq	sp, sl, fp, lsl #14
    1868:	680b1200 	stmdavs	fp, {r9, ip}
    186c:	1300000d 	movwne	r0, #13
    1870:	0011380b 	andseq	r3, r1, fp, lsl #16
    1874:	9b0b1400 	blls	2c687c <_bss_end+0x2bd624>
    1878:	15000013 	strne	r0, [r0, #-19]	; 0xffffffed
    187c:	000f330b 	andeq	r3, pc, fp, lsl #6
    1880:	e70b1600 	str	r1, [fp, -r0, lsl #12]
    1884:	17000013 	smladne	r0, r3, r0, r0
    1888:	0011fd0b 	andseq	pc, r1, fp, lsl #26
    188c:	700b1800 	andvc	r1, fp, r0, lsl #16
    1890:	1900000c 	stmdbne	r0, {r2, r3}
    1894:	001a7e0b 	andseq	r7, sl, fp, lsl #28
    1898:	670b1a00 	strvs	r1, [fp, -r0, lsl #20]
    189c:	1b000013 	blne	18f0 <_start-0x6710>
    18a0:	00110f0b 	andseq	r0, r1, fp, lsl #30
    18a4:	450b1c00 	strmi	r1, [fp, #-3072]	; 0xfffff400
    18a8:	1d00000b 	stcne	0, cr0, [r0, #-44]	; 0xffffffd4
    18ac:	0012b20b 	andseq	fp, r2, fp, lsl #4
    18b0:	9e0b1e00 	cdpls	14, 0, cr1, cr11, cr0, {0}
    18b4:	1f000012 	svcne	0x00000012
    18b8:	00179e0b 	andseq	r9, r7, fp, lsl #28
    18bc:	290b2000 	stmdbcs	fp, {sp}
    18c0:	21000018 	tstcs	r0, r8, lsl r0
    18c4:	001a5d0b 	andseq	r5, sl, fp, lsl #26
    18c8:	420b2200 	andmi	r2, fp, #0, 4
    18cc:	23000010 	movwcs	r0, #16
    18d0:	0016010b 	andseq	r0, r6, fp, lsl #2
    18d4:	f60b2400 			; <UNDEFINED> instruction: 0xf60b2400
    18d8:	25000017 	strcs	r0, [r0, #-23]	; 0xffffffe9
    18dc:	00171a0b 	andseq	r1, r7, fp, lsl #20
    18e0:	2e0b2600 	cfmadd32cs	mvax0, mvfx2, mvfx11, mvfx0
    18e4:	27000017 	smladcs	r0, r7, r0, r0
    18e8:	0017420b 	andseq	r4, r7, fp, lsl #4
    18ec:	f30b2800 	vsub.i8	d2, d11, d0
    18f0:	2900000d 	stmdbcs	r0, {r0, r2, r3}
    18f4:	000d530b 	andeq	r5, sp, fp, lsl #6
    18f8:	7b0b2a00 	blvc	2cc100 <_bss_end+0x2c2ea8>
    18fc:	2b00000d 	blcs	1938 <_start-0x66c8>
    1900:	0018f30b 	andseq	pc, r8, fp, lsl #6
    1904:	d00b2c00 	andle	r2, fp, r0, lsl #24
    1908:	2d00000d 	stccs	0, cr0, [r0, #-52]	; 0xffffffcc
    190c:	0019070b 	andseq	r0, r9, fp, lsl #14
    1910:	1b0b2e00 	blne	2cd118 <_bss_end+0x2c3ec0>
    1914:	2f000019 	svccs	0x00000019
    1918:	00192f0b 	andseq	r2, r9, fp, lsl #30
    191c:	c40b3000 	strgt	r3, [fp], #-0
    1920:	3100000f 	tstcc	r0, pc
    1924:	000f9e0b 	andeq	r9, pc, fp, lsl #28
    1928:	c60b3200 	strgt	r3, [fp], -r0, lsl #4
    192c:	33000012 	movwcc	r0, #18
    1930:	0014980b 	andseq	r9, r4, fp, lsl #16
    1934:	0c0b3400 	cfstrseq	mvf3, [fp], {-0}
    1938:	3500001b 	strcc	r0, [r0, #-27]	; 0xffffffe5
    193c:	000aed0b 	andeq	lr, sl, fp, lsl #26
    1940:	c40b3600 	strgt	r3, [fp], #-1536	; 0xfffffa00
    1944:	37000010 	smladcc	r0, r0, r0, r0
    1948:	0010d90b 	andseq	sp, r0, fp, lsl #18
    194c:	280b3800 	stmdacs	fp, {fp, ip, sp}
    1950:	39000013 	stmdbcc	r0, {r0, r1, r4}
    1954:	0013520b 	andseq	r5, r3, fp, lsl #4
    1958:	350b3a00 	strcc	r3, [fp, #-2560]	; 0xfffff600
    195c:	3b00001b 	blcc	19d0 <_start-0x6630>
    1960:	0015ec0b 	andseq	lr, r5, fp, lsl #24
    1964:	670b3c00 	strvs	r3, [fp, -r0, lsl #24]
    1968:	3d000010 	stccc	0, cr0, [r0, #-64]	; 0xffffffc0
    196c:	000bac0b 	andeq	sl, fp, fp, lsl #24
    1970:	6a0b3e00 	bvs	2d1178 <_bss_end+0x2c7f20>
    1974:	3f00000b 	svccc	0x0000000b
    1978:	0014e40b 	andseq	lr, r4, fp, lsl #8
    197c:	6d0b4000 	stcvs	0, cr4, [fp, #-0]
    1980:	41000016 	tstmi	r0, r6, lsl r0
    1984:	0017800b 	andseq	r8, r7, fp
    1988:	3d0b4200 	sfmcc	f4, 4, [fp, #-0]
    198c:	43000013 	movwmi	r0, #19
    1990:	001b6e0b 	andseq	r6, fp, fp, lsl #28
    1994:	170b4400 	strne	r4, [fp, -r0, lsl #8]
    1998:	45000016 	strmi	r0, [r0, #-22]	; 0xffffffea
    199c:	000d970b 	andeq	r9, sp, fp, lsl #14
    19a0:	180b4600 	stmdane	fp, {r9, sl, lr}
    19a4:	47000014 	smladmi	r0, r4, r0, r0
    19a8:	00124b0b 	andseq	r4, r2, fp, lsl #22
    19ac:	290b4800 	stmdbcs	fp, {fp, lr}
    19b0:	4900000b 	stmdbmi	r0, {r0, r1, r3}
    19b4:	000c3d0b 	andeq	r3, ip, fp, lsl #26
    19b8:	7b0b4a00 	blvc	2d41c0 <_bss_end+0x2caf68>
    19bc:	4b000010 	blmi	1a04 <_start-0x65fc>
    19c0:	0013790b 	andseq	r7, r3, fp, lsl #18
    19c4:	03004c00 	movweq	r4, #3072	; 0xc00
    19c8:	03c30702 	biceq	r0, r3, #524288	; 0x80000
    19cc:	e40c0000 	str	r0, [ip], #-0
    19d0:	d9000003 	stmdble	r0, {r0, r1}
    19d4:	0d000003 	stceq	0, cr0, [r0, #-12]
    19d8:	03ce0e00 	biceq	r0, lr, #0, 28
    19dc:	04050000 	streq	r0, [r5], #-0
    19e0:	000003f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    19e4:	0003de0e 	andeq	sp, r3, lr, lsl #28
    19e8:	08010300 	stmdaeq	r1, {r8, r9}
    19ec:	0000038e 	andeq	r0, r0, lr, lsl #7
    19f0:	0003e90e 	andeq	lr, r3, lr, lsl #18
    19f4:	0ce10f00 	stcleq	15, cr0, [r1]
    19f8:	4c040000 	stcmi	0, cr0, [r4], {-0}
    19fc:	03d91a01 	bicseq	r1, r9, #4096	; 0x1000
    1a00:	ff0f0000 			; <UNDEFINED> instruction: 0xff0f0000
    1a04:	04000010 	streq	r0, [r0], #-16
    1a08:	d91a0182 	ldmdble	sl, {r1, r7, r8}
    1a0c:	0c000003 	stceq	0, cr0, [r0], {3}
    1a10:	000003e9 	andeq	r0, r0, r9, ror #7
    1a14:	0000041a 	andeq	r0, r0, sl, lsl r4
    1a18:	ea09000d 	b	241a54 <_bss_end+0x2387fc>
    1a1c:	05000012 	streq	r0, [r0, #-18]	; 0xffffffee
    1a20:	040f0d2d 	streq	r0, [pc], #-3373	; 1a28 <_start-0x65d8>
    1a24:	d7090000 	strle	r0, [r9, -r0]
    1a28:	05000019 	streq	r0, [r0, #-25]	; 0xffffffe7
    1a2c:	01e61c38 	mvneq	r1, r8, lsr ip
    1a30:	d80a0000 	stmdale	sl, {}	; <UNPREDICTABLE>
    1a34:	0700000f 	streq	r0, [r0, -pc]
    1a38:	00009301 	andeq	r9, r0, r1, lsl #6
    1a3c:	0e3a0500 	cfabs32eq	mvfx0, mvfx10
    1a40:	000004a5 	andeq	r0, r0, r5, lsr #9
    1a44:	000b3e0b 	andeq	r3, fp, fp, lsl #28
    1a48:	ea0b0000 	b	2c1a50 <_bss_end+0x2b87f8>
    1a4c:	01000011 	tsteq	r0, r1, lsl r0
    1a50:	001ae90b 	andseq	lr, sl, fp, lsl #18
    1a54:	ac0b0200 	sfmge	f0, 4, [fp], {-0}
    1a58:	0300001a 	movweq	r0, #26
    1a5c:	0015410b 	andseq	r4, r5, fp, lsl #2
    1a60:	670b0400 	strvs	r0, [fp, -r0, lsl #8]
    1a64:	05000018 	streq	r0, [r0, #-24]	; 0xffffffe8
    1a68:	000d240b 	andeq	r2, sp, fp, lsl #8
    1a6c:	060b0600 	streq	r0, [fp], -r0, lsl #12
    1a70:	0700000d 	streq	r0, [r0, -sp]
    1a74:	000f1f0b 	andeq	r1, pc, fp, lsl #30
    1a78:	fd0b0800 	stc2	8, cr0, [fp, #-0]
    1a7c:	09000013 	stmdbeq	r0, {r0, r1, r4}
    1a80:	000d2b0b 	andeq	r2, sp, fp, lsl #22
    1a84:	040b0a00 	streq	r0, [fp], #-2560	; 0xfffff600
    1a88:	0b000014 	bleq	1ae0 <_start-0x6520>
    1a8c:	000d900b 	andeq	r9, sp, fp
    1a90:	1d0b0c00 	stcne	12, cr0, [fp, #-0]
    1a94:	0d00000d 	stceq	0, cr0, [r0, #-52]	; 0xffffffcc
    1a98:	0018be0b 	andseq	fp, r8, fp, lsl #28
    1a9c:	8b0b0e00 	blhi	2c52a4 <_bss_end+0x2bc04c>
    1aa0:	0f000016 	svceq	0x00000016
    1aa4:	17b60400 	ldrne	r0, [r6, r0, lsl #8]!
    1aa8:	3f050000 	svccc	0x00050000
    1aac:	00043201 	andeq	r3, r4, r1, lsl #4
    1ab0:	184a0900 	stmdane	sl, {r8, fp}^
    1ab4:	41050000 	mrsmi	r0, (UNDEF: 5)
    1ab8:	0004a50f 	andeq	sl, r4, pc, lsl #10
    1abc:	18d20900 	ldmne	r2, {r8, fp}^
    1ac0:	4a050000 	bmi	141ac8 <_bss_end+0x138870>
    1ac4:	00001d0c 	andeq	r1, r0, ip, lsl #26
    1ac8:	0cc50900 			; <UNDEFINED> instruction: 0x0cc50900
    1acc:	4b050000 	blmi	141ad4 <_bss_end+0x13887c>
    1ad0:	00001d0c 	andeq	r1, r0, ip, lsl #26
    1ad4:	19ab1000 	stmibne	fp!, {ip}
    1ad8:	e3090000 	movw	r0, #36864	; 0x9000
    1adc:	05000018 	streq	r0, [r0, #-24]	; 0xffffffe8
    1ae0:	04e6144c 	strbteq	r1, [r6], #1100	; 0x44c
    1ae4:	04050000 	streq	r0, [r5], #-0
    1ae8:	000004d5 	ldrdeq	r0, [r0], -r5
    1aec:	11b40911 			; <UNDEFINED> instruction: 0x11b40911
    1af0:	4e050000 	cdpmi	0, 0, cr0, cr5, cr0, {0}
    1af4:	0004f90f 	andeq	pc, r4, pc, lsl #18
    1af8:	ec040500 	cfstr32	mvfx0, [r4], {-0}
    1afc:	12000004 	andne	r0, r0, #4
    1b00:	000017cc 	andeq	r1, r0, ip, asr #15
    1b04:	00152e09 	andseq	r2, r5, r9, lsl #28
    1b08:	0d520500 	cfldr64eq	mvdx0, [r2, #-0]
    1b0c:	00000510 	andeq	r0, r0, r0, lsl r5
    1b10:	04ff0405 	ldrbteq	r0, [pc], #1029	; 1b18 <_start-0x64e8>
    1b14:	3c130000 	ldccc	0, cr0, [r3], {-0}
    1b18:	3400000e 	strcc	r0, [r0], #-14
    1b1c:	15016705 	strne	r6, [r1, #-1797]	; 0xfffff8fb
    1b20:	00000541 	andeq	r0, r0, r1, asr #10
    1b24:	0012f314 	andseq	pc, r2, r4, lsl r3	; <UNPREDICTABLE>
    1b28:	01690500 	cmneq	r9, r0, lsl #10
    1b2c:	0003de0f 	andeq	sp, r3, pc, lsl #28
    1b30:	20140000 	andscs	r0, r4, r0
    1b34:	0500000e 	streq	r0, [r0, #-14]
    1b38:	4614016a 	ldrmi	r0, [r4], -sl, ror #2
    1b3c:	04000005 	streq	r0, [r0], #-5
    1b40:	05160e00 	ldreq	r0, [r6, #-3584]	; 0xfffff200
    1b44:	b90c0000 	stmdblt	ip, {}	; <UNPREDICTABLE>
    1b48:	56000000 	strpl	r0, [r0], -r0
    1b4c:	15000005 	strne	r0, [r0, #-5]
    1b50:	00000024 	andeq	r0, r0, r4, lsr #32
    1b54:	410c002d 	tstmi	ip, sp, lsr #32
    1b58:	61000005 	tstvs	r0, r5
    1b5c:	0d000005 	stceq	0, cr0, [r0, #-20]	; 0xffffffec
    1b60:	05560e00 	ldrbeq	r0, [r6, #-3584]	; 0xfffff200
    1b64:	220f0000 	andcs	r0, pc, #0
    1b68:	05000012 	streq	r0, [r0, #-18]	; 0xffffffee
    1b6c:	6103016b 	tstvs	r3, fp, ror #2
    1b70:	0f000005 	svceq	0x00000005
    1b74:	00001468 	andeq	r1, r0, r8, ror #8
    1b78:	0c016e05 	stceq	14, cr6, [r1], {5}
    1b7c:	0000001d 	andeq	r0, r0, sp, lsl r0
    1b80:	00180a16 	andseq	r0, r8, r6, lsl sl
    1b84:	93010700 	movwls	r0, #5888	; 0x1700
    1b88:	05000000 	streq	r0, [r0, #-0]
    1b8c:	2a060181 	bcs	182198 <_bss_end+0x178f40>
    1b90:	0b000006 	bleq	1bb0 <_start-0x6450>
    1b94:	00000bd3 	ldrdeq	r0, [r0], -r3
    1b98:	0bdf0b00 	bleq	ff7c47a0 <_bss_end+0xff7bb548>
    1b9c:	0b020000 	bleq	81ba4 <_bss_end+0x7894c>
    1ba0:	00000beb 	andeq	r0, r0, fp, ror #23
    1ba4:	10040b03 	andne	r0, r4, r3, lsl #22
    1ba8:	0b030000 	bleq	c1bb0 <_bss_end+0xb8958>
    1bac:	00000bf7 	strdeq	r0, [r0], -r7
    1bb0:	114d0b04 	cmpne	sp, r4, lsl #22
    1bb4:	0b040000 	bleq	101bbc <_bss_end+0xf8964>
    1bb8:	00001233 	andeq	r1, r0, r3, lsr r2
    1bbc:	11890b05 	orrne	r0, r9, r5, lsl #22
    1bc0:	0b050000 	bleq	141bc8 <_bss_end+0x138970>
    1bc4:	00000cb6 			; <UNDEFINED> instruction: 0x00000cb6
    1bc8:	0c030b05 			; <UNDEFINED> instruction: 0x0c030b05
    1bcc:	0b060000 	bleq	181bd4 <_bss_end+0x17897c>
    1bd0:	000013b1 			; <UNDEFINED> instruction: 0x000013b1
    1bd4:	0e120b06 	vnmlseq.f64	d0, d2, d6
    1bd8:	0b060000 	bleq	181be0 <_bss_end+0x178988>
    1bdc:	000013be 			; <UNDEFINED> instruction: 0x000013be
    1be0:	188a0b06 	stmne	sl, {r1, r2, r8, r9, fp}
    1be4:	0b060000 	bleq	181bec <_bss_end+0x178994>
    1be8:	000013cb 	andeq	r1, r0, fp, asr #7
    1bec:	140b0b06 	strne	r0, [fp], #-2822	; 0xfffff4fa
    1bf0:	0b060000 	bleq	181bf8 <_bss_end+0x1789a0>
    1bf4:	00000c0f 	andeq	r0, r0, pc, lsl #24
    1bf8:	15110b07 	ldrne	r0, [r1, #-2823]	; 0xfffff4f9
    1bfc:	0b070000 	bleq	1c1c04 <_bss_end+0x1b89ac>
    1c00:	0000155e 	andeq	r1, r0, lr, asr r5
    1c04:	18c50b07 	stmiane	r5, {r0, r1, r2, r8, r9, fp}^
    1c08:	0b070000 	bleq	1c1c10 <_bss_end+0x1b89b8>
    1c0c:	00000de5 	andeq	r0, r0, r5, ror #27
    1c10:	16440b07 	strbne	r0, [r4], -r7, lsl #22
    1c14:	0b080000 	bleq	201c1c <_bss_end+0x1f89c4>
    1c18:	00000b88 	andeq	r0, r0, r8, lsl #23
    1c1c:	18980b08 	ldmne	r8, {r3, r8, r9, fp}
    1c20:	0b080000 	bleq	201c28 <_bss_end+0x1f89d0>
    1c24:	00001660 	andeq	r1, r0, r0, ror #12
    1c28:	fe0f0008 	cdp2	0, 0, cr0, cr15, cr8, {0}
    1c2c:	0500001a 	streq	r0, [r0, #-26]	; 0xffffffe6
    1c30:	801f019f 	mulshi	pc, pc, r1	; <UNPREDICTABLE>
    1c34:	0f000005 	svceq	0x00000005
    1c38:	00001692 	muleq	r0, r2, r6
    1c3c:	0c01a205 	sfmeq	f2, 1, [r1], {5}
    1c40:	0000001d 	andeq	r0, r0, sp, lsl r0
    1c44:	0012400f 	andseq	r4, r2, pc
    1c48:	01a50500 			; <UNDEFINED> instruction: 0x01a50500
    1c4c:	00001d0c 	andeq	r1, r0, ip, lsl #26
    1c50:	1bca0f00 	blne	ff285858 <_bss_end+0xff27c600>
    1c54:	a8050000 	stmdage	r5, {}	; <UNPREDICTABLE>
    1c58:	001d0c01 	andseq	r0, sp, r1, lsl #24
    1c5c:	d50f0000 	strle	r0, [pc, #-0]	; 1c64 <_start-0x639c>
    1c60:	0500000c 	streq	r0, [r0, #-12]
    1c64:	1d0c01ab 	stfnes	f0, [ip, #-684]	; 0xfffffd54
    1c68:	0f000000 	svceq	0x00000000
    1c6c:	0000169c 	muleq	r0, ip, r6
    1c70:	0c01ae05 	stceq	14, cr10, [r1], {5}
    1c74:	0000001d 	andeq	r0, r0, sp, lsl r0
    1c78:	0015480f 	andseq	r4, r5, pc, lsl #16
    1c7c:	01b10500 			; <UNDEFINED> instruction: 0x01b10500
    1c80:	00001d0c 	andeq	r1, r0, ip, lsl #26
    1c84:	15530f00 	ldrbne	r0, [r3, #-3840]	; 0xfffff100
    1c88:	b4050000 	strlt	r0, [r5], #-0
    1c8c:	001d0c01 	andseq	r0, sp, r1, lsl #24
    1c90:	a60f0000 	strge	r0, [pc], -r0
    1c94:	05000016 	streq	r0, [r0, #-22]	; 0xffffffea
    1c98:	1d0c01b7 	stfnes	f0, [ip, #-732]	; 0xfffffd24
    1c9c:	0f000000 	svceq	0x00000000
    1ca0:	0000138d 	andeq	r1, r0, sp, lsl #7
    1ca4:	0c01ba05 			; <UNDEFINED> instruction: 0x0c01ba05
    1ca8:	0000001d 	andeq	r0, r0, sp, lsl r0
    1cac:	001b290f 	andseq	r2, fp, pc, lsl #18
    1cb0:	01bd0500 			; <UNDEFINED> instruction: 0x01bd0500
    1cb4:	00001d0c 	andeq	r1, r0, ip, lsl #26
    1cb8:	16b00f00 	ldrtne	r0, [r0], r0, lsl #30
    1cbc:	c0050000 	andgt	r0, r5, r0
    1cc0:	001d0c01 	andseq	r0, sp, r1, lsl #24
    1cc4:	ed0f0000 	stc	0, cr0, [pc, #-0]	; 1ccc <_start-0x6334>
    1cc8:	0500001b 	streq	r0, [r0, #-27]	; 0xffffffe5
    1ccc:	1d0c01c3 	stfnes	f0, [ip, #-780]	; 0xfffffcf4
    1cd0:	0f000000 	svceq	0x00000000
    1cd4:	00001ab3 			; <UNDEFINED> instruction: 0x00001ab3
    1cd8:	0c01c605 	stceq	6, cr12, [r1], {5}
    1cdc:	0000001d 	andeq	r0, r0, sp, lsl r0
    1ce0:	001abf0f 	andseq	fp, sl, pc, lsl #30
    1ce4:	01c90500 	biceq	r0, r9, r0, lsl #10
    1ce8:	00001d0c 	andeq	r1, r0, ip, lsl #26
    1cec:	1acb0f00 	bne	ff2c58f4 <_bss_end+0xff2bc69c>
    1cf0:	cc050000 	stcgt	0, cr0, [r5], {-0}
    1cf4:	001d0c01 	andseq	r0, sp, r1, lsl #24
    1cf8:	f00f0000 			; <UNDEFINED> instruction: 0xf00f0000
    1cfc:	0500001a 	streq	r0, [r0, #-26]	; 0xffffffe6
    1d00:	1d0c01d0 	stfnes	f0, [ip, #-832]	; 0xfffffcc0
    1d04:	0f000000 	svceq	0x00000000
    1d08:	00001be0 	andeq	r1, r0, r0, ror #23
    1d0c:	0c01d305 	stceq	3, cr13, [r1], {5}
    1d10:	0000001d 	andeq	r0, r0, sp, lsl r0
    1d14:	000d320f 	andeq	r3, sp, pc, lsl #4
    1d18:	01d60500 	bicseq	r0, r6, r0, lsl #10
    1d1c:	00001d0c 	andeq	r1, r0, ip, lsl #26
    1d20:	0b190f00 	bleq	645928 <_bss_end+0x63c6d0>
    1d24:	d9050000 	stmdble	r5, {}	; <UNPREDICTABLE>
    1d28:	001d0c01 	andseq	r0, sp, r1, lsl #24
    1d2c:	240f0000 	strcs	r0, [pc], #-0	; 1d34 <_start-0x62cc>
    1d30:	05000010 	streq	r0, [r0, #-16]
    1d34:	1d0c01dc 	stfnes	f0, [ip, #-880]	; 0xfffffc90
    1d38:	0f000000 	svceq	0x00000000
    1d3c:	00000d0d 	andeq	r0, r0, sp, lsl #26
    1d40:	0c01df05 	stceq	15, cr13, [r1], {5}
    1d44:	0000001d 	andeq	r0, r0, sp, lsl r0
    1d48:	0016c60f 	andseq	ip, r6, pc, lsl #12
    1d4c:	01e20500 	mvneq	r0, r0, lsl #10
    1d50:	00001d0c 	andeq	r1, r0, ip, lsl #26
    1d54:	12690f00 	rsbne	r0, r9, #0, 30
    1d58:	e5050000 	str	r0, [r5, #-0]
    1d5c:	001d0c01 	andseq	r0, sp, r1, lsl #24
    1d60:	c10f0000 	mrsgt	r0, CPSR
    1d64:	05000014 	streq	r0, [r0, #-20]	; 0xffffffec
    1d68:	1d0c01e8 	stfnes	f0, [ip, #-928]	; 0xfffffc60
    1d6c:	0f000000 	svceq	0x00000000
    1d70:	000019e0 	andeq	r1, r0, r0, ror #19
    1d74:	0c01ef05 	stceq	15, cr14, [r1], {5}
    1d78:	0000001d 	andeq	r0, r0, sp, lsl r0
    1d7c:	001b980f 	andseq	r9, fp, pc, lsl #16
    1d80:	01f20500 	mvnseq	r0, r0, lsl #10
    1d84:	00001d0c 	andeq	r1, r0, ip, lsl #26
    1d88:	1ba80f00 	blne	fea05990 <_bss_end+0xfe9fc738>
    1d8c:	f5050000 			; <UNDEFINED> instruction: 0xf5050000
    1d90:	001d0c01 	andseq	r0, sp, r1, lsl #24
    1d94:	290f0000 	stmdbcs	pc, {}	; <UNPREDICTABLE>
    1d98:	0500000e 	streq	r0, [r0, #-14]
    1d9c:	1d0c01f8 	stfnes	f0, [ip, #-992]	; 0xfffffc20
    1da0:	0f000000 	svceq	0x00000000
    1da4:	00001a27 	andeq	r1, r0, r7, lsr #20
    1da8:	0c01fb05 			; <UNDEFINED> instruction: 0x0c01fb05
    1dac:	0000001d 	andeq	r0, r0, sp, lsl r0
    1db0:	00162c0f 	andseq	r2, r6, pc, lsl #24
    1db4:	01fe0500 	mvnseq	r0, r0, lsl #10
    1db8:	00001d0c 	andeq	r1, r0, ip, lsl #26
    1dbc:	109d0f00 	addsne	r0, sp, r0, lsl #30
    1dc0:	02050000 	andeq	r0, r5, #0
    1dc4:	001d0c02 	andseq	r0, sp, r2, lsl #24
    1dc8:	1c0f0000 	stcne	0, cr0, [pc], {-0}
    1dcc:	05000018 	streq	r0, [r0, #-24]	; 0xffffffe8
    1dd0:	1d0c020a 	sfmne	f0, 4, [ip, #-40]	; 0xffffffd8
    1dd4:	0f000000 	svceq	0x00000000
    1dd8:	00000f90 	muleq	r0, r0, pc	; <UNPREDICTABLE>
    1ddc:	0c020d05 	stceq	13, cr0, [r2], {5}
    1de0:	0000001d 	andeq	r0, r0, sp, lsl r0
    1de4:	00001d0c 	andeq	r1, r0, ip, lsl #26
    1de8:	0007ef00 	andeq	lr, r7, r0, lsl #30
    1dec:	0f000d00 	svceq	0x00000d00
    1df0:	00001169 	andeq	r1, r0, r9, ror #2
    1df4:	0c03fb05 			; <UNDEFINED> instruction: 0x0c03fb05
    1df8:	000007e4 	andeq	r0, r0, r4, ror #15
    1dfc:	0004e60c 	andeq	lr, r4, ip, lsl #12
    1e00:	00080c00 	andeq	r0, r8, r0, lsl #24
    1e04:	00241500 	eoreq	r1, r4, r0, lsl #10
    1e08:	000d0000 	andeq	r0, sp, r0
    1e0c:	0016e90f 	andseq	lr, r6, pc, lsl #18
    1e10:	05840500 	streq	r0, [r4, #1280]	; 0x500
    1e14:	0007fc14 	andeq	pc, r7, r4, lsl ip	; <UNPREDICTABLE>
    1e18:	122b1600 	eorne	r1, fp, #0, 12
    1e1c:	01070000 	mrseq	r0, (UNDEF: 7)
    1e20:	00000093 	muleq	r0, r3, r0
    1e24:	06058b05 	streq	r8, [r5], -r5, lsl #22
    1e28:	00000857 	andeq	r0, r0, r7, asr r8
    1e2c:	000fe60b 	andeq	lr, pc, fp, lsl #12
    1e30:	360b0000 	strcc	r0, [fp], -r0
    1e34:	01000014 	tsteq	r0, r4, lsl r0
    1e38:	000bbe0b 	andeq	fp, fp, fp, lsl #28
    1e3c:	5a0b0200 	bpl	2c2644 <_bss_end+0x2b93ec>
    1e40:	0300001b 	movweq	r0, #27
    1e44:	0017630b 	andseq	r6, r7, fp, lsl #6
    1e48:	560b0400 	strpl	r0, [fp], -r0, lsl #8
    1e4c:	05000017 	streq	r0, [r0, #-23]	; 0xffffffe9
    1e50:	000c950b 	andeq	r9, ip, fp, lsl #10
    1e54:	0f000600 	svceq	0x00000600
    1e58:	00001b4a 	andeq	r1, r0, sl, asr #22
    1e5c:	15059805 	strne	r9, [r5, #-2053]	; 0xfffff7fb
    1e60:	00000819 	andeq	r0, r0, r9, lsl r8
    1e64:	001a4c0f 	andseq	r4, sl, pc, lsl #24
    1e68:	07990500 	ldreq	r0, [r9, r0, lsl #10]
    1e6c:	00002411 	andeq	r2, r0, r1, lsl r4
    1e70:	16d60f00 	ldrbne	r0, [r6], r0, lsl #30
    1e74:	ae050000 	cdpge	0, 0, cr0, cr5, cr0, {0}
    1e78:	001d0c07 	andseq	r0, sp, r7, lsl #24
    1e7c:	bf040000 	svclt	0x00040000
    1e80:	06000019 			; <UNDEFINED> instruction: 0x06000019
    1e84:	0093167b 	addseq	r1, r3, fp, ror r6
    1e88:	7e0e0000 	cdpvc	0, 0, cr0, cr14, cr0, {0}
    1e8c:	03000008 	movweq	r0, #8
    1e90:	05960502 	ldreq	r0, [r6, #1282]	; 0x502
    1e94:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    1e98:	000f7907 	andeq	r7, pc, r7, lsl #18
    1e9c:	04040300 	streq	r0, [r4], #-768	; 0xfffffd00
    1ea0:	00000d4d 	andeq	r0, r0, sp, asr #26
    1ea4:	45030803 	strmi	r0, [r3, #-2051]	; 0xfffff7fd
    1ea8:	0300000d 	movweq	r0, #13
    1eac:	16bf0408 	ldrtne	r0, [pc], r8, lsl #8
    1eb0:	10030000 	andne	r0, r3, r0
    1eb4:	00177103 	andseq	r7, r7, r3, lsl #2
    1eb8:	088a0c00 	stmeq	sl, {sl, fp}
    1ebc:	08c90000 	stmiaeq	r9, {}^	; <UNPREDICTABLE>
    1ec0:	24150000 	ldrcs	r0, [r5], #-0
    1ec4:	ff000000 			; <UNDEFINED> instruction: 0xff000000
    1ec8:	08b90e00 	ldmeq	r9!, {r9, sl, fp}
    1ecc:	6b0f0000 	blvs	3c1ed4 <_bss_end+0x3b8c7c>
    1ed0:	06000015 			; <UNDEFINED> instruction: 0x06000015
    1ed4:	c91601fc 	ldmdbgt	r6, {r2, r3, r4, r5, r6, r7, r8}
    1ed8:	0f000008 	svceq	0x00000008
    1edc:	00000cfc 	strdeq	r0, [r0], -ip
    1ee0:	16020206 	strne	r0, [r2], -r6, lsl #4
    1ee4:	000008c9 	andeq	r0, r0, r9, asr #17
    1ee8:	0019f204 	andseq	pc, r9, r4, lsl #4
    1eec:	102a0700 	eorne	r0, sl, r0, lsl #14
    1ef0:	000004f9 	strdeq	r0, [r0], -r9
    1ef4:	0008e80c 	andeq	lr, r8, ip, lsl #16
    1ef8:	0008ff00 	andeq	pc, r8, r0, lsl #30
    1efc:	09000d00 	stmdbeq	r0, {r8, sl, fp}
    1f00:	00000a86 	andeq	r0, r0, r6, lsl #21
    1f04:	f4112f07 			; <UNDEFINED> instruction: 0xf4112f07
    1f08:	09000008 	stmdbeq	r0, {r3}
    1f0c:	00000ab8 			; <UNDEFINED> instruction: 0x00000ab8
    1f10:	f4113007 			; <UNDEFINED> instruction: 0xf4113007
    1f14:	17000008 	strne	r0, [r0, -r8]
    1f18:	000008ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    1f1c:	0a093308 	beq	24eb44 <_bss_end+0x2458ec>
    1f20:	92140305 	andsls	r0, r4, #335544320	; 0x14000000
    1f24:	0b170000 	bleq	5c1f2c <_bss_end+0x5b8cd4>
    1f28:	08000009 	stmdaeq	r0, {r0, r3}
    1f2c:	050a0934 	streq	r0, [sl, #-2356]	; 0xfffff6cc
    1f30:	00921c03 	addseq	r1, r2, r3, lsl #24
	...

Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
   0:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
   4:	030b130e 	movweq	r1, #45838	; 0xb30e
   8:	110e1b0e 	tstne	lr, lr, lsl #22
   c:	10061201 	andne	r1, r6, r1, lsl #4
  10:	02000017 	andeq	r0, r0, #23
  14:	193f002e 	ldmdbne	pc!, {r1, r2, r3, r5}	; <UNPREDICTABLE>
  18:	0b3a0e03 	bleq	e8382c <_bss_end+0xe7a5d4>
  1c:	0b390b3b 	bleq	e42d10 <_bss_end+0xe39ab8>
  20:	06120111 			; <UNDEFINED> instruction: 0x06120111
  24:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
  28:	03000019 	movweq	r0, #25
  2c:	0e030139 	mcreq	1, 0, r0, cr3, cr9, {1}
  30:	0b3b0b3a 	bleq	ec2d20 <_bss_end+0xeb9ac8>
  34:	00001301 	andeq	r1, r0, r1, lsl #6
  38:	3f012e04 	svccc	0x00012e04
  3c:	3a0e0319 	bcc	380ca8 <_bss_end+0x377a50>
  40:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
  44:	01193c0b 	tsteq	r9, fp, lsl #24
  48:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
  4c:	13490005 	movtne	r0, #36869	; 0x9005
  50:	16060000 	strne	r0, [r6], -r0
  54:	3a0e0300 	bcc	380c5c <_bss_end+0x377a04>
  58:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
  5c:	0013490b 	andseq	r4, r3, fp, lsl #18
  60:	012e0700 			; <UNDEFINED> instruction: 0x012e0700
  64:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
  68:	0b3b0b3a 	bleq	ec2d58 <_bss_end+0xeb9b00>
  6c:	13490b39 	movtne	r0, #39737	; 0x9b39
  70:	0000193c 	andeq	r1, r0, ip, lsr r9
  74:	0b000f08 	bleq	3c9c <_start-0x4364>
  78:	0013490b 	andseq	r4, r3, fp, lsl #18
  7c:	00240900 	eoreq	r0, r4, r0, lsl #18
  80:	0b3e0b0b 	bleq	f82cb4 <_bss_end+0xf79a5c>
  84:	00000e03 	andeq	r0, r0, r3, lsl #28
  88:	47012e0a 	strmi	r2, [r1, -sl, lsl #28]
  8c:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
  90:	97184006 	ldrls	r4, [r8, -r6]
  94:	13011942 	movwne	r1, #6466	; 0x1942
  98:	050b0000 	streq	r0, [fp, #-0]
  9c:	02134900 	andseq	r4, r3, #0, 18
  a0:	0c000018 	stceq	0, cr0, [r0], {24}
  a4:	08030005 	stmdaeq	r3, {r0, r2}
  a8:	0b3b0b3a 	bleq	ec2d98 <_bss_end+0xeb9b40>
  ac:	13490b39 	movtne	r0, #39737	; 0x9b39
  b0:	00001802 	andeq	r1, r0, r2, lsl #16
  b4:	0b00240d 	bleq	90f0 <_cpp_shutdown+0x4c>
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
  e4:	0b0b0024 	bleq	2c017c <_bss_end+0x2b6f24>
  e8:	0e030b3e 	vmoveq.16	d3[0], r0
  ec:	24030000 	strcs	r0, [r3], #-0
  f0:	3e0b0b00 	vmlacc.f64	d0, d11, d0
  f4:	0008030b 	andeq	r0, r8, fp, lsl #6
  f8:	00160400 	andseq	r0, r6, r0, lsl #8
  fc:	0b3a0e03 	bleq	e83910 <_bss_end+0xe7a6b8>
 100:	0b390b3b 	bleq	e42df4 <_bss_end+0xe39b9c>
 104:	00001349 	andeq	r1, r0, r9, asr #6
 108:	49002605 	stmdbmi	r0, {r0, r2, r9, sl, sp}
 10c:	06000013 			; <UNDEFINED> instruction: 0x06000013
 110:	08030139 	stmdaeq	r3, {r0, r3, r4, r5, r8}
 114:	0b3b0b3a 	bleq	ec2e04 <_bss_end+0xeb9bac>
 118:	13010b39 	movwne	r0, #6969	; 0x1b39
 11c:	34070000 	strcc	r0, [r7], #-0
 120:	3a0e0300 	bcc	380d28 <_bss_end+0x377ad0>
 124:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 128:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
 12c:	6c061c19 	stcvs	12, cr1, [r6], {25}
 130:	08000019 	stmdaeq	r0, {r0, r3, r4}
 134:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 138:	0b3b0b3a 	bleq	ec2e28 <_bss_end+0xeb9bd0>
 13c:	13490b39 	movtne	r0, #39737	; 0x9b39
 140:	0b1c193c 	bleq	706638 <_bss_end+0x6fd3e0>
 144:	0000196c 	andeq	r1, r0, ip, ror #18
 148:	03010409 	movweq	r0, #5129	; 0x1409
 14c:	3e196d0e 	cdpcc	13, 1, cr6, cr9, cr14, {0}
 150:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
 154:	3b0b3a13 	blcc	2ce9a8 <_bss_end+0x2c5750>
 158:	000b390b 	andeq	r3, fp, fp, lsl #18
 15c:	00280a00 	eoreq	r0, r8, r0, lsl #20
 160:	0b1c0e03 	bleq	703974 <_bss_end+0x6fa71c>
 164:	340b0000 	strcc	r0, [fp], #-0
 168:	00134700 	andseq	r4, r3, r0, lsl #14
 16c:	01040c00 	tsteq	r4, r0, lsl #24
 170:	196d0e03 	stmdbne	sp!, {r0, r1, r9, sl, fp}^
 174:	0b0b0b3e 	bleq	2c2e74 <_bss_end+0x2b9c1c>
 178:	0b3a1349 	bleq	e84ea4 <_bss_end+0xe7bc4c>
 17c:	0b390b3b 	bleq	e42e70 <_bss_end+0xe39c18>
 180:	00001301 	andeq	r1, r0, r1, lsl #6
 184:	0301020d 	movweq	r0, #4621	; 0x120d
 188:	3a0b0b0e 	bcc	2c2dc8 <_bss_end+0x2b9b70>
 18c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 190:	0013010b 	andseq	r0, r3, fp, lsl #2
 194:	000d0e00 	andeq	r0, sp, r0, lsl #28
 198:	0b3a0e03 	bleq	e839ac <_bss_end+0xe7a754>
 19c:	0b390b3b 	bleq	e42e90 <_bss_end+0xe39c38>
 1a0:	0b381349 	bleq	e04ecc <_bss_end+0xdfbc74>
 1a4:	2e0f0000 	cdpcs	0, 0, cr0, cr15, cr0, {0}
 1a8:	03193f01 	tsteq	r9, #1, 30
 1ac:	3b0b3a0e 	blcc	2ce9ec <_bss_end+0x2c5794>
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
 1d8:	0b3b0b3a 	bleq	ec2ec8 <_bss_end+0xeb9c70>
 1dc:	0e6e0b39 	vmoveq.8	d14[5], r0
 1e0:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 1e4:	13011364 	movwne	r1, #4964	; 0x1364
 1e8:	2e130000 	cdpcs	0, 1, cr0, cr3, cr0, {0}
 1ec:	03193f01 	tsteq	r9, #1, 30
 1f0:	3b0b3a0e 	blcc	2cea30 <_bss_end+0x2c57d8>
 1f4:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 1f8:	3c0b320e 	sfmcc	f3, 4, [fp], {14}
 1fc:	00136419 	andseq	r6, r3, r9, lsl r4
 200:	000f1400 	andeq	r1, pc, r0, lsl #8
 204:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 208:	10150000 	andsne	r0, r5, r0
 20c:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 210:	16000013 			; <UNDEFINED> instruction: 0x16000013
 214:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 218:	0b3b0b3a 	bleq	ec2f08 <_bss_end+0xeb9cb0>
 21c:	13490b39 	movtne	r0, #39737	; 0x9b39
 220:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
 224:	34170000 	ldrcc	r0, [r7], #-0
 228:	3a134700 	bcc	4d1e30 <_bss_end+0x4c8bd8>
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
 260:	0b3b0b3a 	bleq	ec2f50 <_bss_end+0xeb9cf8>
 264:	13490b39 	movtne	r0, #39737	; 0x9b39
 268:	00001802 	andeq	r1, r0, r2, lsl #16
 26c:	47012e1b 	smladmi	r1, fp, lr, r2
 270:	3b0b3a13 	blcc	2ceac4 <_bss_end+0x2c586c>
 274:	640b390b 	strvs	r3, [fp], #-2315	; 0xfffff6f5
 278:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 27c:	96184006 	ldrls	r4, [r8], -r6
 280:	13011942 	movwne	r1, #6466	; 0x1942
 284:	051c0000 	ldreq	r0, [ip, #-0]
 288:	490e0300 	stmdbmi	lr, {r8, r9}
 28c:	02193413 	andseq	r3, r9, #318767104	; 0x13000000
 290:	1d000018 	stcne	0, cr0, [r0, #-96]	; 0xffffffa0
 294:	08030005 	stmdaeq	r3, {r0, r2}
 298:	0b3b0b3a 	bleq	ec2f88 <_bss_end+0xeb9d30>
 29c:	13490b39 	movtne	r0, #39737	; 0x9b39
 2a0:	00001802 	andeq	r1, r0, r2, lsl #16
 2a4:	0300341e 	movweq	r3, #1054	; 0x41e
 2a8:	3b0b3a08 	blcc	2cead0 <_bss_end+0x2c5878>
 2ac:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 2b0:	00180213 	andseq	r0, r8, r3, lsl r2
 2b4:	012e1f00 			; <UNDEFINED> instruction: 0x012e1f00
 2b8:	0b3a1347 	bleq	e84fdc <_bss_end+0xe7bd84>
 2bc:	0b390b3b 	bleq	e42fb0 <_bss_end+0xe39d58>
 2c0:	01111364 	tsteq	r1, r4, ror #6
 2c4:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 2c8:	01194297 			; <UNDEFINED> instruction: 0x01194297
 2cc:	20000013 	andcs	r0, r0, r3, lsl r0
 2d0:	1347012e 	movtne	r0, #28974	; 0x712e
 2d4:	0b3b0b3a 	bleq	ec2fc4 <_bss_end+0xeb9d6c>
 2d8:	13640b39 	cmnne	r4, #58368	; 0xe400
 2dc:	13010b20 	movwne	r0, #6944	; 0x1b20
 2e0:	05210000 	streq	r0, [r1, #-0]!
 2e4:	490e0300 	stmdbmi	lr, {r8, r9}
 2e8:	00193413 	andseq	r3, r9, r3, lsl r4
 2ec:	00052200 	andeq	r2, r5, r0, lsl #4
 2f0:	0b3a0e03 	bleq	e83b04 <_bss_end+0xe7a8ac>
 2f4:	0b390b3b 	bleq	e42fe8 <_bss_end+0xe39d90>
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
 320:	1b0e030b 	blne	380f54 <_bss_end+0x377cfc>
 324:	1117550e 	tstne	r7, lr, lsl #10
 328:	00171001 	andseq	r1, r7, r1
 32c:	01020200 	mrseq	r0, R10_usr
 330:	0b0b0e03 	bleq	2c3b44 <_bss_end+0x2ba8ec>
 334:	0b3b0b3a 	bleq	ec3024 <_bss_end+0xeb9dcc>
 338:	13010b39 	movwne	r0, #6969	; 0x1b39
 33c:	04030000 	streq	r0, [r3], #-0
 340:	6d0e0301 	stcvs	3, cr0, [lr, #-4]
 344:	0b0b3e19 	bleq	2cfbb0 <_bss_end+0x2c6958>
 348:	3a13490b 	bcc	4d277c <_bss_end+0x4c9524>
 34c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 350:	010b320b 	tsteq	fp, fp, lsl #4
 354:	04000013 	streq	r0, [r0], #-19	; 0xffffffed
 358:	08030028 	stmdaeq	r3, {r3, r5}
 35c:	00000b1c 	andeq	r0, r0, ip, lsl fp
 360:	49002605 	stmdbmi	r0, {r0, r2, r9, sl, sp}
 364:	06000013 			; <UNDEFINED> instruction: 0x06000013
 368:	0e030113 	mcreq	1, 0, r0, cr3, cr3, {0}
 36c:	0b3a0b0b 	bleq	e82fa0 <_bss_end+0xe79d48>
 370:	0b390b3b 	bleq	e43064 <_bss_end+0xe39e0c>
 374:	00001301 	andeq	r1, r0, r1, lsl #6
 378:	03000d07 	movweq	r0, #3335	; 0xd07
 37c:	3b0b3a08 	blcc	2ceba4 <_bss_end+0x2c594c>
 380:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 384:	000b3813 	andeq	r3, fp, r3, lsl r8
 388:	000d0800 	andeq	r0, sp, r0, lsl #16
 38c:	0b3a0e03 	bleq	e83ba0 <_bss_end+0xe7a948>
 390:	0b390b3b 	bleq	e43084 <_bss_end+0xe39e2c>
 394:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
 398:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 39c:	196c0b1c 	stmdbne	ip!, {r2, r3, r4, r8, r9, fp}^
 3a0:	0d090000 	stceq	0, cr0, [r9, #-0]
 3a4:	3a0e0300 	bcc	380fac <_bss_end+0x377d54>
 3a8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 3ac:	3f13490b 	svccc	0x0013490b
 3b0:	3c0b3219 	sfmcc	f3, 4, [fp], {25}
 3b4:	00196c19 	andseq	r6, r9, r9, lsl ip
 3b8:	012e0a00 			; <UNDEFINED> instruction: 0x012e0a00
 3bc:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 3c0:	0b3b0b3a 	bleq	ec30b0 <_bss_end+0xeb9e58>
 3c4:	0e6e0b39 	vmoveq.8	d14[5], r0
 3c8:	0b321349 	bleq	c850f4 <_bss_end+0xc7be9c>
 3cc:	1963193c 	stmdbne	r3!, {r2, r3, r4, r5, r8, fp, ip}^
 3d0:	13011364 	movwne	r1, #4964	; 0x1364
 3d4:	050b0000 	streq	r0, [fp, #-0]
 3d8:	34134900 	ldrcc	r4, [r3], #-2304	; 0xfffff700
 3dc:	0c000019 	stceq	0, cr0, [r0], {25}
 3e0:	13490005 	movtne	r0, #36869	; 0x9005
 3e4:	2e0d0000 	cdpcs	0, 0, cr0, cr13, cr0, {0}
 3e8:	03193f01 	tsteq	r9, #1, 30
 3ec:	3b0b3a0e 	blcc	2cec2c <_bss_end+0x2c59d4>
 3f0:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 3f4:	3c0b320e 	sfmcc	f3, 4, [fp], {14}
 3f8:	01136419 	tsteq	r3, r9, lsl r4
 3fc:	0e000013 	mcreq	0, 0, r0, cr0, cr3, {0}
 400:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 404:	0b3a0e03 	bleq	e83c18 <_bss_end+0xe7a9c0>
 408:	0b390b3b 	bleq	e430fc <_bss_end+0xe39ea4>
 40c:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 410:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 414:	13011364 	movwne	r1, #4964	; 0x1364
 418:	2e0f0000 	cdpcs	0, 0, cr0, cr15, cr0, {0}
 41c:	03193f01 	tsteq	r9, #1, 30
 420:	3b0b3a0e 	blcc	2cec60 <_bss_end+0x2c5a08>
 424:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 428:	64193c0e 	ldrvs	r3, [r9], #-3086	; 0xfffff3f2
 42c:	00130113 	andseq	r0, r3, r3, lsl r1
 430:	012e1000 			; <UNDEFINED> instruction: 0x012e1000
 434:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 438:	0b3b0b3a 	bleq	ec3128 <_bss_end+0xeb9ed0>
 43c:	0e6e0b39 	vmoveq.8	d14[5], r0
 440:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 444:	13011364 	movwne	r1, #4964	; 0x1364
 448:	0d110000 	ldceq	0, cr0, [r1, #-0]
 44c:	3a0e0300 	bcc	381054 <_bss_end+0x377dfc>
 450:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 454:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 458:	1200000b 	andne	r0, r0, #11
 45c:	0b0b0024 	bleq	2c04f4 <_bss_end+0x2b729c>
 460:	0e030b3e 	vmoveq.16	d3[0], r0
 464:	0f130000 	svceq	0x00130000
 468:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 46c:	14000013 	strne	r0, [r0], #-19	; 0xffffffed
 470:	0b0b0010 	bleq	2c04b8 <_bss_end+0x2b7260>
 474:	00001349 	andeq	r1, r0, r9, asr #6
 478:	49003515 	stmdbmi	r0, {r0, r2, r4, r8, sl, ip, sp}
 47c:	16000013 			; <UNDEFINED> instruction: 0x16000013
 480:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 484:	0b3b0b3a 	bleq	ec3174 <_bss_end+0xeb9f1c>
 488:	13490b39 	movtne	r0, #39737	; 0x9b39
 48c:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
 490:	34170000 	ldrcc	r0, [r7], #-0
 494:	3a134700 	bcc	4d209c <_bss_end+0x4c8e44>
 498:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 49c:	0018020b 	andseq	r0, r8, fp, lsl #4
 4a0:	002e1800 	eoreq	r1, lr, r0, lsl #16
 4a4:	19340e03 	ldmdbne	r4!, {r0, r1, r9, sl, fp}
 4a8:	06120111 			; <UNDEFINED> instruction: 0x06120111
 4ac:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 4b0:	19000019 	stmdbne	r0, {r0, r3, r4}
 4b4:	0e03012e 	adfeqsp	f0, f3, #0.5
 4b8:	01111934 	tsteq	r1, r4, lsr r9
 4bc:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 4c0:	01194296 			; <UNDEFINED> instruction: 0x01194296
 4c4:	1a000013 	bne	518 <_start-0x7ae8>
 4c8:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
 4cc:	0b3b0b3a 	bleq	ec31bc <_bss_end+0xeb9f64>
 4d0:	13490b39 	movtne	r0, #39737	; 0x9b39
 4d4:	00001802 	andeq	r1, r0, r2, lsl #16
 4d8:	0b00241b 	bleq	954c <_bss_end+0x2f4>
 4dc:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 4e0:	1c000008 	stcne	0, cr0, [r0], {8}
 4e4:	1347012e 	movtne	r0, #28974	; 0x712e
 4e8:	0b3b0b3a 	bleq	ec31d8 <_bss_end+0xeb9f80>
 4ec:	13640b39 	cmnne	r4, #58368	; 0xe400
 4f0:	06120111 			; <UNDEFINED> instruction: 0x06120111
 4f4:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 4f8:	00130119 	andseq	r0, r3, r9, lsl r1
 4fc:	00051d00 	andeq	r1, r5, r0, lsl #26
 500:	13490e03 	movtne	r0, #40451	; 0x9e03
 504:	18021934 	stmdane	r2, {r2, r4, r5, r8, fp, ip}
 508:	341e0000 	ldrcc	r0, [lr], #-0
 50c:	3a080300 	bcc	201114 <_bss_end+0x1f7ebc>
 510:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 514:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 518:	1f000018 	svcne	0x00000018
 51c:	0111010b 	tsteq	r1, fp, lsl #2
 520:	00000612 	andeq	r0, r0, r2, lsl r6
 524:	47012e20 	strmi	r2, [r1, -r0, lsr #28]
 528:	3b0b3a13 	blcc	2ced7c <_bss_end+0x2c5b24>
 52c:	640b390b 	strvs	r3, [fp], #-2315	; 0xfffff6f5
 530:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 534:	97184006 	ldrls	r4, [r8, -r6]
 538:	13011942 	movwne	r1, #6466	; 0x1942
 53c:	05210000 	streq	r0, [r1, #-0]!
 540:	3a080300 	bcc	201148 <_bss_end+0x1f7ef0>
 544:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 548:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 54c:	22000018 	andcs	r0, r0, #24
 550:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 554:	0b3b0b3a 	bleq	ec3244 <_bss_end+0xeb9fec>
 558:	13490b39 	movtne	r0, #39737	; 0x9b39
 55c:	00001802 	andeq	r1, r0, r2, lsl #16
 560:	03003423 	movweq	r3, #1059	; 0x423
 564:	3b0b3a0e 	blcc	2ceda4 <_bss_end+0x2c5b4c>
 568:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 56c:	02196c13 	andseq	r6, r9, #4864	; 0x1300
 570:	24000018 	strcs	r0, [r0], #-24	; 0xffffffe8
 574:	13490101 	movtne	r0, #37121	; 0x9101
 578:	00001301 	andeq	r1, r0, r1, lsl #6
 57c:	49002125 	stmdbmi	r0, {r0, r2, r5, r8, sp}
 580:	000b2f13 	andeq	r2, fp, r3, lsl pc
 584:	010b2600 	tsteq	fp, r0, lsl #12
 588:	06120111 			; <UNDEFINED> instruction: 0x06120111
 58c:	00001301 	andeq	r1, r0, r1, lsl #6
 590:	47012e27 	strmi	r2, [r1, -r7, lsr #28]
 594:	3b0b3a13 	blcc	2cede8 <_bss_end+0x2c5b90>
 598:	640b390b 	strvs	r3, [fp], #-2315	; 0xfffff6f5
 59c:	010b2013 	tsteq	fp, r3, lsl r0
 5a0:	28000013 	stmdacs	r0, {r0, r1, r4}
 5a4:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
 5a8:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
 5ac:	05290000 	streq	r0, [r9, #-0]!
 5b0:	3a0e0300 	bcc	3811b8 <_bss_end+0x377f60>
 5b4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 5b8:	0013490b 	andseq	r4, r3, fp, lsl #18
 5bc:	012e2a00 			; <UNDEFINED> instruction: 0x012e2a00
 5c0:	0e6e1331 	mcreq	3, 3, r1, cr14, cr1, {1}
 5c4:	01111364 	tsteq	r1, r4, ror #6
 5c8:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 5cc:	00194297 	mulseq	r9, r7, r2
 5d0:	00052b00 	andeq	r2, r5, r0, lsl #22
 5d4:	18021331 	stmdane	r2, {r0, r4, r5, r8, r9, ip}
 5d8:	01000000 	mrseq	r0, (UNDEF: 0)
 5dc:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
 5e0:	0e030b13 	vmoveq.32	d3[0], r0
 5e4:	01110e1b 	tsteq	r1, fp, lsl lr
 5e8:	17100612 			; <UNDEFINED> instruction: 0x17100612
 5ec:	24020000 	strcs	r0, [r2], #-0
 5f0:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 5f4:	000e030b 	andeq	r0, lr, fp, lsl #6
 5f8:	00260300 	eoreq	r0, r6, r0, lsl #6
 5fc:	00001349 	andeq	r1, r0, r9, asr #6
 600:	0b002404 	bleq	9618 <_bss_end+0x3c0>
 604:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 608:	05000008 	streq	r0, [r0, #-8]
 60c:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
 610:	0b3b0b3a 	bleq	ec3300 <_bss_end+0xeba0a8>
 614:	13490b39 	movtne	r0, #39737	; 0x9b39
 618:	35060000 	strcc	r0, [r6, #-0]
 61c:	00134900 	andseq	r4, r3, r0, lsl #18
 620:	01040700 	tsteq	r4, r0, lsl #14
 624:	196d0e03 	stmdbne	sp!, {r0, r1, r9, sl, fp}^
 628:	0b0b0b3e 	bleq	2c3328 <_bss_end+0x2ba0d0>
 62c:	0b3a1349 	bleq	e85358 <_bss_end+0xe7c100>
 630:	0b390b3b 	bleq	e43324 <_bss_end+0xe3a0cc>
 634:	00001301 	andeq	r1, r0, r1, lsl #6
 638:	03002808 	movweq	r2, #2056	; 0x808
 63c:	000b1c0e 	andeq	r1, fp, lr, lsl #24
 640:	01020900 	tsteq	r2, r0, lsl #18
 644:	0b0b0e03 	bleq	2c3e58 <_bss_end+0x2bac00>
 648:	0b3b0b3a 	bleq	ec3338 <_bss_end+0xeba0e0>
 64c:	13010b39 	movwne	r0, #6969	; 0x1b39
 650:	0d0a0000 	stceq	0, cr0, [sl, #-0]
 654:	3a0e0300 	bcc	38125c <_bss_end+0x378004>
 658:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 65c:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 660:	0b00000b 	bleq	694 <_start-0x796c>
 664:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 668:	0b3a0e03 	bleq	e83e7c <_bss_end+0xe7ac24>
 66c:	0b390b3b 	bleq	e43360 <_bss_end+0xe3a108>
 670:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 674:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 678:	13011364 	movwne	r1, #4964	; 0x1364
 67c:	050c0000 	streq	r0, [ip, #-0]
 680:	34134900 	ldrcc	r4, [r3], #-2304	; 0xfffff700
 684:	0d000019 	stceq	0, cr0, [r0, #-100]	; 0xffffff9c
 688:	13490005 	movtne	r0, #36869	; 0x9005
 68c:	2e0e0000 	cdpcs	0, 0, cr0, cr14, cr0, {0}
 690:	03193f01 	tsteq	r9, #1, 30
 694:	3b0b3a0e 	blcc	2ceed4 <_bss_end+0x2c5c7c>
 698:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 69c:	3c0b320e 	sfmcc	f3, 4, [fp], {14}
 6a0:	01136419 	tsteq	r3, r9, lsl r4
 6a4:	0f000013 	svceq	0x00000013
 6a8:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 6ac:	0b3a0e03 	bleq	e83ec0 <_bss_end+0xe7ac68>
 6b0:	0b390b3b 	bleq	e433a4 <_bss_end+0xe3a14c>
 6b4:	0b320e6e 	bleq	c84074 <_bss_end+0xc7ae1c>
 6b8:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 6bc:	0f100000 	svceq	0x00100000
 6c0:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 6c4:	11000013 	tstne	r0, r3, lsl r0
 6c8:	0b0b0010 	bleq	2c0710 <_bss_end+0x2b74b8>
 6cc:	00001349 	andeq	r1, r0, r9, asr #6
 6d0:	03003412 	movweq	r3, #1042	; 0x412
 6d4:	3b0b3a0e 	blcc	2cef14 <_bss_end+0x2c5cbc>
 6d8:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 6dc:	3c193f13 	ldccc	15, cr3, [r9], {19}
 6e0:	13000019 	movwne	r0, #25
 6e4:	0e030104 	adfeqs	f0, f3, f4
 6e8:	0b3e196d 	bleq	f86ca4 <_bss_end+0xf7da4c>
 6ec:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 6f0:	0b3b0b3a 	bleq	ec33e0 <_bss_end+0xeba188>
 6f4:	0b320b39 	bleq	c833e0 <_bss_end+0xc7a188>
 6f8:	00001301 	andeq	r1, r0, r1, lsl #6
 6fc:	03002814 	movweq	r2, #2068	; 0x814
 700:	000b1c08 	andeq	r1, fp, r8, lsl #24
 704:	01131500 	tsteq	r3, r0, lsl #10
 708:	0b0b0e03 	bleq	2c3f1c <_bss_end+0x2bacc4>
 70c:	0b3b0b3a 	bleq	ec33fc <_bss_end+0xeba1a4>
 710:	13010b39 	movwne	r0, #6969	; 0x1b39
 714:	0d160000 	ldceq	0, cr0, [r6, #-0]
 718:	3a080300 	bcc	201320 <_bss_end+0x1f80c8>
 71c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 720:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 724:	1700000b 	strne	r0, [r0, -fp]
 728:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 72c:	0b3b0b3a 	bleq	ec341c <_bss_end+0xeba1c4>
 730:	13490b39 	movtne	r0, #39737	; 0x9b39
 734:	0b32193f 	bleq	c86c38 <_bss_end+0xc7d9e0>
 738:	0b1c193c 	bleq	706c30 <_bss_end+0x6fd9d8>
 73c:	0000196c 	andeq	r1, r0, ip, ror #18
 740:	03000d18 	movweq	r0, #3352	; 0xd18
 744:	3b0b3a0e 	blcc	2cef84 <_bss_end+0x2c5d2c>
 748:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 74c:	32193f13 	andscc	r3, r9, #19, 30	; 0x4c
 750:	6c193c0b 	ldcvs	12, cr3, [r9], {11}
 754:	19000019 	stmdbne	r0, {r0, r3, r4}
 758:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 75c:	0b3a0e03 	bleq	e83f70 <_bss_end+0xe7ad18>
 760:	0b390b3b 	bleq	e43454 <_bss_end+0xe3a1fc>
 764:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 768:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 76c:	13641963 	cmnne	r4, #1622016	; 0x18c000
 770:	00001301 	andeq	r1, r0, r1, lsl #6
 774:	3f012e1a 	svccc	0x00012e1a
 778:	3a0e0319 	bcc	3813e4 <_bss_end+0x37818c>
 77c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 780:	3c0e6e0b 	stccc	14, cr6, [lr], {11}
 784:	01136419 	tsteq	r3, r9, lsl r4
 788:	1b000013 	blne	7dc <_start-0x7824>
 78c:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 790:	0b3a0e03 	bleq	e83fa4 <_bss_end+0xe7ad4c>
 794:	0b390b3b 	bleq	e43488 <_bss_end+0xe3a230>
 798:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 79c:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 7a0:	00001301 	andeq	r1, r0, r1, lsl #6
 7a4:	0300341c 	movweq	r3, #1052	; 0x41c
 7a8:	3b0b3a0e 	blcc	2cefe8 <_bss_end+0x2c5d90>
 7ac:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 7b0:	02196c13 	andseq	r6, r9, #4864	; 0x1300
 7b4:	1d000018 	stcne	0, cr0, [r0, #-96]	; 0xffffffa0
 7b8:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 7bc:	0b3a0e03 	bleq	e83fd0 <_bss_end+0xe7ad78>
 7c0:	0b390b3b 	bleq	e434b4 <_bss_end+0xe3a25c>
 7c4:	01111349 	tsteq	r1, r9, asr #6
 7c8:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 7cc:	00194296 	mulseq	r9, r6, r2
 7d0:	00341e00 	eorseq	r1, r4, r0, lsl #28
 7d4:	0b3a0803 	bleq	e827e8 <_bss_end+0xe79590>
 7d8:	0b390b3b 	bleq	e434cc <_bss_end+0xe3a274>
 7dc:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 7e0:	01000000 	mrseq	r0, (UNDEF: 0)
 7e4:	06100011 			; <UNDEFINED> instruction: 0x06100011
 7e8:	01120111 	tsteq	r2, r1, lsl r1
 7ec:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
 7f0:	05130e25 	ldreq	r0, [r3, #-3621]	; 0xfffff1db
 7f4:	01000000 	mrseq	r0, (UNDEF: 0)
 7f8:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
 7fc:	0e030b13 	vmoveq.32	d3[0], r0
 800:	01110e1b 	tsteq	r1, fp, lsl lr
 804:	17100612 			; <UNDEFINED> instruction: 0x17100612
 808:	16020000 	strne	r0, [r2], -r0
 80c:	3a0e0300 	bcc	381414 <_bss_end+0x3781bc>
 810:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 814:	0013490b 	andseq	r4, r3, fp, lsl #18
 818:	000f0300 	andeq	r0, pc, r0, lsl #6
 81c:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 820:	15040000 	strne	r0, [r4, #-0]
 824:	05000000 	streq	r0, [r0, #-0]
 828:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 82c:	0b3b0b3a 	bleq	ec351c <_bss_end+0xeba2c4>
 830:	13490b39 	movtne	r0, #39737	; 0x9b39
 834:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
 838:	24060000 	strcs	r0, [r6], #-0
 83c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 840:	0008030b 	andeq	r0, r8, fp, lsl #6
 844:	01010700 	tsteq	r1, r0, lsl #14
 848:	13011349 	movwne	r1, #4937	; 0x1349
 84c:	21080000 	mrscs	r0, (UNDEF: 8)
 850:	2f134900 	svccs	0x00134900
 854:	09000006 	stmdbeq	r0, {r1, r2}
 858:	0b0b0024 	bleq	2c08f0 <_bss_end+0x2b7698>
 85c:	0e030b3e 	vmoveq.16	d3[0], r0
 860:	2e0a0000 	cdpcs	0, 0, cr0, cr10, cr0, {0}
 864:	03193f01 	tsteq	r9, #1, 30
 868:	3b0b3a0e 	blcc	2cf0a8 <_bss_end+0x2c5e50>
 86c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 870:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 874:	96184006 	ldrls	r4, [r8], -r6
 878:	13011942 	movwne	r1, #6466	; 0x1942
 87c:	340b0000 	strcc	r0, [fp], #-0
 880:	3a0e0300 	bcc	381488 <_bss_end+0x378230>
 884:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 888:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 88c:	0c000018 	stceq	0, cr0, [r0], {24}
 890:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 894:	0b3a0e03 	bleq	e840a8 <_bss_end+0xe7ae50>
 898:	0b390b3b 	bleq	e4358c <_bss_end+0xe3a334>
 89c:	01111349 	tsteq	r1, r9, asr #6
 8a0:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 8a4:	01194297 			; <UNDEFINED> instruction: 0x01194297
 8a8:	0d000013 	stceq	0, cr0, [r0, #-76]	; 0xffffffb4
 8ac:	08030034 	stmdaeq	r3, {r2, r4, r5}
 8b0:	0b3b0b3a 	bleq	ec35a0 <_bss_end+0xeba348>
 8b4:	13490b39 	movtne	r0, #39737	; 0x9b39
 8b8:	00001802 	andeq	r1, r0, r2, lsl #16
 8bc:	01110100 	tsteq	r1, r0, lsl #2
 8c0:	0b130e25 	bleq	4c415c <_bss_end+0x4baf04>
 8c4:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
 8c8:	00001710 	andeq	r1, r0, r0, lsl r7
 8cc:	0b002402 	bleq	98dc <_bss_end+0x684>
 8d0:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 8d4:	03000008 	movweq	r0, #8
 8d8:	0b0b0024 	bleq	2c0970 <_bss_end+0x2b7718>
 8dc:	0e030b3e 	vmoveq.16	d3[0], r0
 8e0:	16040000 	strne	r0, [r4], -r0
 8e4:	3a0e0300 	bcc	3814ec <_bss_end+0x378294>
 8e8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 8ec:	0013490b 	andseq	r4, r3, fp, lsl #18
 8f0:	000f0500 	andeq	r0, pc, r0, lsl #10
 8f4:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 8f8:	15060000 	strne	r0, [r6, #-0]
 8fc:	49192701 	ldmdbmi	r9, {r0, r8, r9, sl, sp}
 900:	00130113 	andseq	r0, r3, r3, lsl r1
 904:	00050700 	andeq	r0, r5, r0, lsl #14
 908:	00001349 	andeq	r1, r0, r9, asr #6
 90c:	00002608 	andeq	r2, r0, r8, lsl #12
 910:	00340900 	eorseq	r0, r4, r0, lsl #18
 914:	0b3a0e03 	bleq	e84128 <_bss_end+0xe7aed0>
 918:	0b390b3b 	bleq	e4360c <_bss_end+0xe3a3b4>
 91c:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
 920:	0000193c 	andeq	r1, r0, ip, lsr r9
 924:	0301040a 	movweq	r0, #5130	; 0x140a
 928:	0b0b3e0e 	bleq	2d0168 <_bss_end+0x2c6f10>
 92c:	3a13490b 	bcc	4d2d60 <_bss_end+0x4c9b08>
 930:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 934:	0013010b 	andseq	r0, r3, fp, lsl #2
 938:	00280b00 	eoreq	r0, r8, r0, lsl #22
 93c:	0b1c0e03 	bleq	704150 <_bss_end+0x6faef8>
 940:	010c0000 	mrseq	r0, (UNDEF: 12)
 944:	01134901 	tsteq	r3, r1, lsl #18
 948:	0d000013 	stceq	0, cr0, [r0, #-76]	; 0xffffffb4
 94c:	00000021 	andeq	r0, r0, r1, lsr #32
 950:	4900260e 	stmdbmi	r0, {r1, r2, r3, r9, sl, sp}
 954:	0f000013 	svceq	0x00000013
 958:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 95c:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 960:	13490b39 	movtne	r0, #39737	; 0x9b39
 964:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
 968:	13100000 	tstne	r0, #0
 96c:	3c0e0300 	stccc	3, cr0, [lr], {-0}
 970:	11000019 	tstne	r0, r9, lsl r0
 974:	19270015 	stmdbne	r7!, {r0, r2, r4}
 978:	17120000 	ldrne	r0, [r2, -r0]
 97c:	3c0e0300 	stccc	3, cr0, [lr], {-0}
 980:	13000019 	movwne	r0, #25
 984:	0e030113 	mcreq	1, 0, r0, cr3, cr3, {0}
 988:	0b3a0b0b 	bleq	e835bc <_bss_end+0xe7a364>
 98c:	0b39053b 	bleq	e41e80 <_bss_end+0xe38c28>
 990:	00001301 	andeq	r1, r0, r1, lsl #6
 994:	03000d14 	movweq	r0, #3348	; 0xd14
 998:	3b0b3a0e 	blcc	2cf1d8 <_bss_end+0x2c5f80>
 99c:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
 9a0:	000b3813 	andeq	r3, fp, r3, lsl r8
 9a4:	00211500 	eoreq	r1, r1, r0, lsl #10
 9a8:	0b2f1349 	bleq	bc56d4 <_bss_end+0xbbc47c>
 9ac:	04160000 	ldreq	r0, [r6], #-0
 9b0:	3e0e0301 	cdpcc	3, 0, cr0, cr14, cr1, {0}
 9b4:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
 9b8:	3b0b3a13 	blcc	2cf20c <_bss_end+0x2c5fb4>
 9bc:	010b3905 	tsteq	fp, r5, lsl #18
 9c0:	17000013 	smladne	r0, r3, r0, r0
 9c4:	13470034 	movtne	r0, #28724	; 0x7034
 9c8:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 9cc:	18020b39 	stmdane	r2, {r0, r3, r4, r5, r8, r9, fp}
 9d0:	Address 0x00000000000009d0 is out of bounds.


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
  40:	00000044 	andeq	r0, r0, r4, asr #32
  44:	079a0002 	ldreq	r0, [sl, r2]
  48:	00040000 	andeq	r0, r4, r0
  4c:	00000000 	andeq	r0, r0, r0
  50:	00008600 	andeq	r8, r0, r0, lsl #12
  54:	00000638 	andeq	r0, r0, r8, lsr r6
  58:	00008c38 	andeq	r8, r0, r8, lsr ip
  5c:	00000038 	andeq	r0, r0, r8, lsr r0
  60:	00008c70 	andeq	r8, r0, r0, ror ip
  64:	00000088 	andeq	r0, r0, r8, lsl #1
  68:	00008cf8 	strdeq	r8, [r0], -r8	; <UNPREDICTABLE>
  6c:	0000002c 	andeq	r0, r0, ip, lsr #32
  70:	00008d24 	andeq	r8, r0, r4, lsr #26
  74:	00000090 	muleq	r0, r0, r0
  78:	00008db4 			; <UNDEFINED> instruction: 0x00008db4
  7c:	0000007c 	andeq	r0, r0, ip, ror r0
	...
  88:	0000001c 	andeq	r0, r0, ip, lsl r0
  8c:	0f330002 	svceq	0x00330002
  90:	00040000 	andeq	r0, r4, r0
  94:	00000000 	andeq	r0, r0, r0
  98:	00008e30 	andeq	r8, r0, r0, lsr lr
  9c:	000001b4 			; <UNDEFINED> instruction: 0x000001b4
	...
  a8:	0000001c 	andeq	r0, r0, ip, lsl r0
  ac:	148b0002 	strne	r0, [fp], #2
  b0:	00040000 	andeq	r0, r4, r0
  b4:	00000000 	andeq	r0, r0, r0
  b8:	00008000 	andeq	r8, r0, r0
  bc:	00000018 	andeq	r0, r0, r8, lsl r0
	...
  c8:	0000001c 	andeq	r0, r0, ip, lsl r0
  cc:	14b10002 	ldrtne	r0, [r1], #2
  d0:	00040000 	andeq	r0, r4, r0
  d4:	00000000 	andeq	r0, r0, r0
  d8:	00008fe4 	andeq	r8, r0, r4, ror #31
  dc:	00000118 	andeq	r0, r0, r8, lsl r1
	...
  e8:	00000014 	andeq	r0, r0, r4, lsl r0
  ec:	16000002 	strne	r0, [r0], -r2
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
  2c:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; fffffe94 <_bss_end+0xffff6c3c>
  30:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
  34:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
  38:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
  3c:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
  40:	302f7365 	eorcc	r7, pc, r5, ror #6
  44:	454c2d37 	strbmi	r2, [ip, #-3383]	; 0xfffff2c9
  48:	6f745f44 	svcvs	0x00745f44
  4c:	656c6767 	strbvs	r6, [ip, #-1895]!	; 0xfffff899
  50:	6265645f 	rsbvs	r6, r5, #1593835520	; 0x5f000000
  54:	6d5f6775 	ldclvs	7, cr6, [pc, #-468]	; fffffe88 <_bss_end+0xffff6c30>
  58:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
  5c:	6b2f726f 	blvs	bdca20 <_bss_end+0xbd37c8>
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
  88:	80180205 	andshi	r0, r8, r5, lsl #4
  8c:	0a030000 	beq	c0094 <_bss_end+0xb6e3c>
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
  b8:	00000310 	andeq	r0, r0, r0, lsl r3
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
  e4:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; ffffff4c <_bss_end+0xffff6cf4>
  e8:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
  ec:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
  f0:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
  f4:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
  f8:	302f7365 	eorcc	r7, pc, r5, ror #6
  fc:	454c2d37 	strbmi	r2, [ip, #-3383]	; 0xfffff2c9
 100:	6f745f44 	svcvs	0x00745f44
 104:	656c6767 	strbvs	r6, [ip, #-1895]!	; 0xfffff899
 108:	6265645f 	rsbvs	r6, r5, #1593835520	; 0x5f000000
 10c:	6d5f6775 	ldclvs	7, cr6, [pc, #-468]	; ffffff40 <_bss_end+0xffff6ce8>
 110:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
 114:	6b2f726f 	blvs	bdcad8 <_bss_end+0xbd3880>
 118:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 11c:	72732f6c 	rsbsvc	r2, r3, #108, 30	; 0x1b0
 120:	72642f63 	rsbvc	r2, r4, #396	; 0x18c
 124:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
 128:	682f0073 	stmdavs	pc!, {r0, r1, r4, r5, r6}	; <UNPREDICTABLE>
 12c:	2f656d6f 	svccs	0x00656d6f
 130:	686c6973 	stmdavs	ip!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
 134:	6a797661 	bvs	1e5dac0 <_bss_end+0x1e54868>
 138:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
 13c:	2f6c6f6f 	svccs	0x006c6f6f
 140:	6f72655a 	svcvs	0x0072655a
 144:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
 148:	6178652f 	cmnvs	r8, pc, lsr #10
 14c:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
 150:	37302f73 			; <UNDEFINED> instruction: 0x37302f73
 154:	44454c2d 	strbmi	r4, [r5], #-3117	; 0xfffff3d3
 158:	676f745f 			; <UNDEFINED> instruction: 0x676f745f
 15c:	5f656c67 	svcpl	0x00656c67
 160:	75626564 	strbvc	r6, [r2, #-1380]!	; 0xfffffa9c
 164:	6f6d5f67 	svcvs	0x006d5f67
 168:	6f74696e 	svcvs	0x0074696e
 16c:	656b2f72 	strbvs	r2, [fp, #-3954]!	; 0xfffff08e
 170:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
 174:	636e692f 	cmnvs	lr, #770048	; 0xbc000
 178:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
 17c:	616f622f 	cmnvs	pc, pc, lsr #4
 180:	722f6472 	eorvc	r6, pc, #1912602624	; 0x72000000
 184:	2f306970 	svccs	0x00306970
 188:	006c6168 	rsbeq	r6, ip, r8, ror #2
 18c:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; d8 <_start-0x7f28>
 190:	69732f65 	ldmdbvs	r3!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 194:	7661686c 	strbtvc	r6, [r1], -ip, ror #16
 198:	532f6a79 			; <UNDEFINED> instruction: 0x532f6a79
 19c:	6f6f6863 	svcvs	0x006f6863
 1a0:	655a2f6c 	ldrbvs	r2, [sl, #-3948]	; 0xfffff094
 1a4:	614d6f72 	hvcvs	55026	; 0xd6f2
 1a8:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffc3c <_bss_end+0xffff69e4>
 1ac:	706d6178 	rsbvc	r6, sp, r8, ror r1
 1b0:	2f73656c 	svccs	0x0073656c
 1b4:	4c2d3730 	stcmi	7, cr3, [sp], #-192	; 0xffffff40
 1b8:	745f4445 	ldrbvc	r4, [pc], #-1093	; 1c0 <_start-0x7e40>
 1bc:	6c67676f 	stclvs	7, cr6, [r7], #-444	; 0xfffffe44
 1c0:	65645f65 	strbvs	r5, [r4, #-3941]!	; 0xfffff09b
 1c4:	5f677562 	svcpl	0x00677562
 1c8:	696e6f6d 	stmdbvs	lr!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
 1cc:	2f726f74 	svccs	0x00726f74
 1d0:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 1d4:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 1d8:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 1dc:	642f6564 	strtvs	r6, [pc], #-1380	; 1e4 <_start-0x7e1c>
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
 220:	0080f002 	addeq	pc, r0, r2
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
 290:	4a040402 	bmi	1012a0 <_bss_end+0xf8048>
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
 2d0:	852f0105 	strhi	r0, [pc, #-261]!	; 1d3 <_start-0x7e2d>
 2d4:	05d70505 	ldrbeq	r0, [r7, #1285]	; 0x505
 2d8:	0b056710 	bleq	159f20 <_bss_end+0x150cc8>
 2dc:	0402004c 	streq	r0, [r2], #-76	; 0xffffffb4
 2e0:	00660601 	rsbeq	r0, r6, r1, lsl #12
 2e4:	4a020402 	bmi	812f4 <_bss_end+0x7809c>
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
 314:	4a1c054d 	bmi	701850 <_bss_end+0x6f85f8>
 318:	05823e05 	streq	r3, [r2, #3589]	; 0xe05
 31c:	1e056621 	cfmadd32ne	mvax1, mvfx6, mvfx5, mvfx1
 320:	2e4b052e 	cdpcs	5, 4, cr0, cr11, cr14, {1}
 324:	052e6b05 	streq	r6, [lr, #-2821]!	; 0xfffff4fb
 328:	0e054a05 	vmlaeq.f32	s8, s10, s10
 32c:	6648054a 	strbvs	r0, [r8], -sl, asr #10
 330:	052e1005 	streq	r1, [lr, #-5]!
 334:	01054809 	tsteq	r5, r9, lsl #16
 338:	1d054d31 	stcne	13, cr4, [r5, #-196]	; 0xffffff3c
 33c:	ba0905a0 	blt	2419c4 <_bss_end+0x23876c>
 340:	054a0505 	strbeq	r0, [sl, #-1285]	; 0xfffffafb
 344:	29054b20 	stmdbcs	r5, {r5, r8, r9, fp, lr}
 348:	4a32054c 	bmi	c81880 <_bss_end+0xc78628>
 34c:	05823405 	streq	r3, [r2, #1029]	; 0x405
 350:	3f054a0c 	svccc	0x00054a0c
 354:	0001052e 	andeq	r0, r1, lr, lsr #10
 358:	4b010402 	blmi	41368 <_bss_end+0x38110>
 35c:	d80b0569 	stmdale	fp, {r0, r3, r5, r6, r8, sl}
 360:	05663505 	strbeq	r3, [r6, #-1285]!	; 0xfffffafb
 364:	04020024 	streq	r0, [r2], #-36	; 0xffffffdc
 368:	09054a02 	stmdbeq	r5, {r1, r9, fp, lr}
 36c:	02040200 	andeq	r0, r4, #0, 4
 370:	003505f2 	ldrshteq	r0, [r5], -r2
 374:	4a030402 	bmi	c1384 <_bss_end+0xb812c>
 378:	02005405 	andeq	r5, r0, #83886080	; 0x5000000
 37c:	05660604 	strbeq	r0, [r6, #-1540]!	; 0xfffff9fc
 380:	04020038 	streq	r0, [r2], #-56	; 0xffffffc8
 384:	3505f206 	strcc	pc, [r5, #-518]	; 0xfffffdfa
 388:	07040200 	streq	r0, [r4, -r0, lsl #4]
 38c:	0402004a 	streq	r0, [r2], #-74	; 0xffffffb6
 390:	054a0608 	strbeq	r0, [sl, #-1544]	; 0xfffff9f8
 394:	04020005 	streq	r0, [r2], #-5
 398:	052e060a 	streq	r0, [lr, #-1546]!	; 0xfffff9f6
 39c:	05054d15 	streq	r4, [r5, #-3349]	; 0xfffff2eb
 3a0:	4a0e0566 	bmi	381940 <_bss_end+0x3786e8>
 3a4:	05661505 	strbeq	r1, [r6, #-1285]!	; 0xfffffafb
 3a8:	09052e10 	stmdbeq	r5, {r4, r9, sl, fp, sp}
 3ac:	31010548 	tstcc	r1, r8, asr #10
 3b0:	02009e4a 	andeq	r9, r0, #1184	; 0x4a0
 3b4:	66060104 	strvs	r0, [r6], -r4, lsl #2
 3b8:	03062305 	movweq	r2, #25349	; 0x6305
 3bc:	05827f9e 	streq	r7, [r2, #3998]	; 0xf9e
 3c0:	00e20301 	rsceq	r0, r2, r1, lsl #6
 3c4:	024aba66 	subeq	fp, sl, #417792	; 0x66000
 3c8:	0101000a 	tsteq	r1, sl
 3cc:	0000045d 	andeq	r0, r0, sp, asr r4
 3d0:	00e10003 	rsceq	r0, r1, r3
 3d4:	01020000 	mrseq	r0, (UNDEF: 2)
 3d8:	000d0efb 	strdeq	r0, [sp], -fp
 3dc:	01010101 	tsteq	r1, r1, lsl #2
 3e0:	01000000 	mrseq	r0, (UNDEF: 0)
 3e4:	2f010000 	svccs	0x00010000
 3e8:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
 3ec:	6c69732f 	stclvs	3, cr7, [r9], #-188	; 0xffffff44
 3f0:	79766168 	ldmdbvc	r6!, {r3, r5, r6, r8, sp, lr}^
 3f4:	63532f6a 	cmpvs	r3, #424	; 0x1a8
 3f8:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; 260 <_start-0x7da0>
 3fc:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
 400:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
 404:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 408:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
 40c:	302f7365 	eorcc	r7, pc, r5, ror #6
 410:	454c2d37 	strbmi	r2, [ip, #-3383]	; 0xfffff2c9
 414:	6f745f44 	svcvs	0x00745f44
 418:	656c6767 	strbvs	r6, [ip, #-1895]!	; 0xfffff899
 41c:	6265645f 	rsbvs	r6, r5, #1593835520	; 0x5f000000
 420:	6d5f6775 	ldclvs	7, cr6, [pc, #-468]	; 254 <_start-0x7dac>
 424:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
 428:	6b2f726f 	blvs	bdcdec <_bss_end+0xbd3b94>
 42c:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 430:	72732f6c 	rsbsvc	r2, r3, #108, 30	; 0x1b0
 434:	72642f63 	rsbvc	r2, r4, #396	; 0x18c
 438:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
 43c:	682f0073 	stmdavs	pc!, {r0, r1, r4, r5, r6}	; <UNPREDICTABLE>
 440:	2f656d6f 	svccs	0x00656d6f
 444:	686c6973 	stmdavs	ip!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
 448:	6a797661 	bvs	1e5ddd4 <_bss_end+0x1e54b7c>
 44c:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
 450:	2f6c6f6f 	svccs	0x006c6f6f
 454:	6f72655a 	svcvs	0x0072655a
 458:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
 45c:	6178652f 	cmnvs	r8, pc, lsr #10
 460:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
 464:	37302f73 			; <UNDEFINED> instruction: 0x37302f73
 468:	44454c2d 	strbmi	r4, [r5], #-3117	; 0xfffff3d3
 46c:	676f745f 			; <UNDEFINED> instruction: 0x676f745f
 470:	5f656c67 	svcpl	0x00656c67
 474:	75626564 	strbvc	r6, [r2, #-1380]!	; 0xfffffa9c
 478:	6f6d5f67 	svcvs	0x006d5f67
 47c:	6f74696e 	svcvs	0x0074696e
 480:	656b2f72 	strbvs	r2, [fp, #-3954]!	; 0xfffff08e
 484:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
 488:	636e692f 	cmnvs	lr, #770048	; 0xbc000
 48c:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
 490:	6972642f 	ldmdbvs	r2!, {r0, r1, r2, r3, r5, sl, sp, lr}^
 494:	73726576 	cmnvc	r2, #494927872	; 0x1d800000
 498:	6f6d0000 	svcvs	0x006d0000
 49c:	6f74696e 	svcvs	0x0074696e
 4a0:	70632e72 	rsbvc	r2, r3, r2, ror lr
 4a4:	00010070 	andeq	r0, r1, r0, ror r0
 4a8:	6e6f6d00 	cdpvs	13, 6, cr6, cr15, cr0, {0}
 4ac:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
 4b0:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 4b4:	05000000 	streq	r0, [r0, #-0]
 4b8:	02050001 	andeq	r0, r5, #1
 4bc:	00008600 	andeq	r8, r0, r0, lsl #12
 4c0:	d70e0516 	smladle	lr, r6, r5, r0
 4c4:	05322605 	ldreq	r2, [r2, #-1541]!	; 0xfffff9fb
 4c8:	14220201 	strtne	r0, [r2], #-513	; 0xfffffdff
 4cc:	059e0903 	ldreq	r0, [lr, #2307]	; 0x903
 4d0:	17058311 	smladne	r5, r1, r3, r8
 4d4:	0022054c 	eoreq	r0, r2, ip, asr #10
 4d8:	4a010402 	bmi	414e8 <_bss_end+0x38290>
 4dc:	02002005 	andeq	r2, r0, #5
 4e0:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
 4e4:	2605681b 			; <UNDEFINED> instruction: 0x2605681b
 4e8:	03040200 	movweq	r0, #16896	; 0x4200
 4ec:	0024054a 	eoreq	r0, r4, sl, asr #10
 4f0:	4a030402 	bmi	c1500 <_bss_end+0xb82a8>
 4f4:	02000d05 	andeq	r0, r0, #320	; 0x140
 4f8:	05680204 	strbeq	r0, [r8, #-516]!	; 0xfffffdfc
 4fc:	0402001c 	streq	r0, [r2], #-28	; 0xffffffe4
 500:	1a054a02 	bne	152d10 <_bss_end+0x149ab8>
 504:	02040200 	andeq	r0, r4, #0, 4
 508:	0025054a 	eoreq	r0, r5, sl, asr #10
 50c:	4a020402 	bmi	8151c <_bss_end+0x782c4>
 510:	02002805 	andeq	r2, r0, #327680	; 0x50000
 514:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 518:	0402002a 	streq	r0, [r2], #-42	; 0xffffffd6
 51c:	09052e02 	stmdbeq	r5, {r1, r9, sl, fp, sp}
 520:	02040200 	andeq	r0, r4, #0, 4
 524:	00050548 	andeq	r0, r5, r8, asr #10
 528:	80020402 	andhi	r0, r2, r2, lsl #8
 52c:	03890105 	orreq	r0, r9, #1073741825	; 0x40000001
 530:	17056612 	smladne	r5, r2, r6, r6
 534:	00220583 	eoreq	r0, r2, r3, lsl #11
 538:	4a010402 	bmi	41548 <_bss_end+0x382f0>
 53c:	02002005 	andeq	r2, r0, #5
 540:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
 544:	2605681b 			; <UNDEFINED> instruction: 0x2605681b
 548:	03040200 	movweq	r0, #16896	; 0x4200
 54c:	0024054a 	eoreq	r0, r4, sl, asr #10
 550:	4a030402 	bmi	c1560 <_bss_end+0xb8308>
 554:	02003205 	andeq	r3, r0, #1342177280	; 0x50000000
 558:	05680204 	strbeq	r0, [r8, #-516]!	; 0xfffffdfc
 55c:	04020041 	streq	r0, [r2], #-65	; 0xffffffbf
 560:	3f054a02 	svccc	0x00054a02
 564:	02040200 	andeq	r0, r4, #0, 4
 568:	004a054a 	subeq	r0, sl, sl, asr #10
 56c:	4a020402 	bmi	8157c <_bss_end+0x78324>
 570:	02004d05 	andeq	r4, r0, #320	; 0x140
 574:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 578:	0402000d 	streq	r0, [r2], #-13
 57c:	1b052e02 	blne	14bd8c <_bss_end+0x142b34>
 580:	02040200 	andeq	r0, r4, #0, 4
 584:	0022054a 	eoreq	r0, r2, sl, asr #10
 588:	4a020402 	bmi	81598 <_bss_end+0x78340>
 58c:	02002005 	andeq	r2, r0, #5
 590:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 594:	0402002b 	streq	r0, [r2], #-43	; 0xffffffd5
 598:	2e052e02 	cdpcs	14, 0, cr2, cr5, cr2, {0}
 59c:	02040200 	andeq	r0, r4, #0, 4
 5a0:	004d054a 	subeq	r0, sp, sl, asr #10
 5a4:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
 5a8:	02003005 	andeq	r3, r0, #5
 5ac:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 5b0:	04020009 	streq	r0, [r2], #-9
 5b4:	05052c02 	streq	r2, [r5, #-3074]	; 0xfffff3fe
 5b8:	02040200 	andeq	r0, r4, #0, 4
 5bc:	8a170580 	bhi	5c1bc4 <_bss_end+0x5b896c>
 5c0:	02002205 	andeq	r2, r0, #1342177280	; 0x50000000
 5c4:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
 5c8:	04020020 	streq	r0, [r2], #-32	; 0xffffffe0
 5cc:	09054a03 	stmdbeq	r5, {r0, r1, r9, fp, lr}
 5d0:	02040200 	andeq	r0, r4, #0, 4
 5d4:	00150568 	andseq	r0, r5, r8, ror #10
 5d8:	4a020402 	bmi	815e8 <_bss_end+0x78390>
 5dc:	02001e05 	andeq	r1, r0, #5, 28	; 0x50
 5e0:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 5e4:	04020025 	streq	r0, [r2], #-37	; 0xffffffdb
 5e8:	23052e02 	movwcs	r2, #24066	; 0x5e02
 5ec:	02040200 	andeq	r0, r4, #0, 4
 5f0:	002e054a 	eoreq	r0, lr, sl, asr #10
 5f4:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
 5f8:	02003105 	andeq	r3, r0, #1073741825	; 0x40000001
 5fc:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 600:	04020033 	streq	r0, [r2], #-51	; 0xffffffcd
 604:	05052e02 	streq	r2, [r5, #-3586]	; 0xfffff1fe
 608:	02040200 	andeq	r0, r4, #0, 4
 60c:	86010548 	strhi	r0, [r1], -r8, asr #10
 610:	bb05058a 	bllt	141c40 <_bss_end+0x1389e8>
 614:	05680905 	strbeq	r0, [r8, #-2309]!	; 0xfffff6fb
 618:	21054a1d 	tstcs	r5, sp, lsl sl
 61c:	4a1f054a 	bmi	7c1b4c <_bss_end+0x7b88f4>
 620:	052e3505 	streq	r3, [lr, #-1285]!	; 0xfffffafb
 624:	36054a2a 	strcc	r4, [r5], -sl, lsr #20
 628:	2e38052e 	cdpcs	5, 3, cr0, cr8, cr14, {1}
 62c:	054b1405 	strbeq	r1, [fp, #-1029]	; 0xfffffbfb
 630:	14054a09 	strne	r4, [r5], #-2569	; 0xfffff5f7
 634:	09056786 	stmdbeq	r5, {r1, r2, r7, r8, r9, sl, sp, lr}
 638:	6912054a 	ldmdbvs	r2, {r1, r3, r6, r8, sl}
 63c:	054c0d05 	strbeq	r0, [ip, #-3333]	; 0xfffff2fb
 640:	05692f01 	strbeq	r2, [r9, #-3841]!	; 0xfffff0ff
 644:	23059f17 	movwcs	r9, #24343	; 0x5f17
 648:	03040200 	movweq	r0, #16896	; 0x4200
 64c:	0025054a 	eoreq	r0, r5, sl, asr #10
 650:	82030402 	andhi	r0, r3, #33554432	; 0x2000000
 654:	02001705 	andeq	r1, r0, #1310720	; 0x140000
 658:	054c0204 	strbeq	r0, [ip, #-516]	; 0xfffffdfc
 65c:	04020005 	streq	r0, [r2], #-5
 660:	1605d402 	strne	sp, [r5], -r2, lsl #8
 664:	4c0d0587 	cfstr32mi	mvfx0, [sp], {135}	; 0x87
 668:	692f0105 	stmdbvs	pc!, {r0, r2, r8}	; <UNPREDICTABLE>
 66c:	059f1305 	ldreq	r1, [pc, #773]	; 979 <_start-0x7687>
 670:	0105680d 	tsteq	r5, sp, lsl #16
 674:	3305852f 	movwcc	r8, #21807	; 0x552f
 678:	4a0905a3 	bmi	241d0c <_bss_end+0x238ab4>
 67c:	05830e05 	streq	r0, [r3, #3589]	; 0xe05
 680:	0d056716 	stceq	7, cr6, [r5, #-88]	; 0xffffffa8
 684:	2f01054c 	svccs	0x0001054c
 688:	bb050585 	bllt	141ca4 <_bss_end+0x138a4c>
 68c:	86681205 	strbthi	r1, [r8], -r5, lsl #4
 690:	05691605 	strbeq	r1, [r9, #-1541]!	; 0xfffff9fb
 694:	01054c0d 	tsteq	r5, sp, lsl #24
 698:	9e2d032f 	cdpls	3, 2, cr0, cr13, cr15, {1}
 69c:	05d70905 	ldrbeq	r0, [r7, #2309]	; 0x905
 6a0:	2a054c12 	bcs	1536f0 <_bss_end+0x14a498>
 6a4:	9e370568 	cdpls	5, 3, cr0, cr7, cr8, {3}
 6a8:	054a1005 	strbeq	r1, [sl, #-5]
 6ac:	37052e11 	smladcc	r5, r1, lr, r2
 6b0:	2e13054a 	cfmac32cs	mvfx0, mvfx3, mvfx10
 6b4:	052f1705 	streq	r1, [pc, #-1797]!	; ffffffb7 <_bss_end+0xffff6d5f>
 6b8:	05059f0a 	streq	r9, [r5, #-3850]	; 0xfffff0f6
 6bc:	10053562 	andne	r3, r5, r2, ror #10
 6c0:	2e110568 	cfmsc32cs	mvfx0, mvfx1, mvfx8
 6c4:	054a2205 	strbeq	r2, [sl, #-517]	; 0xfffffdfb
 6c8:	0a052e13 	beq	14bf1c <_bss_end+0x142cc4>
 6cc:	690c052f 	stmdbvs	ip, {r0, r1, r2, r3, r5, r8, sl}
 6d0:	052e0d05 	streq	r0, [lr, #-3333]!	; 0xfffff2fb
 6d4:	06054a0f 	streq	r4, [r5], -pc, lsl #20
 6d8:	680e054b 	stmdavs	lr, {r0, r1, r3, r6, r8, sl}
 6dc:	02001d05 	andeq	r1, r0, #320	; 0x140
 6e0:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
 6e4:	04020017 	streq	r0, [r2], #-23	; 0xffffffe9
 6e8:	1b054a03 	blne	152efc <_bss_end+0x149ca4>
 6ec:	02040200 	andeq	r0, r4, #0, 4
 6f0:	001e0568 	andseq	r0, lr, r8, ror #10
 6f4:	82020402 	andhi	r0, r2, #33554432	; 0x2000000
 6f8:	02000e05 	andeq	r0, r0, #5, 28	; 0x50
 6fc:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 700:	04020020 	streq	r0, [r2], #-32	; 0xffffffe0
 704:	21054b02 	tstcs	r5, r2, lsl #22
 708:	02040200 	andeq	r0, r4, #0, 4
 70c:	0012052e 	andseq	r0, r2, lr, lsr #10
 710:	4a020402 	bmi	81720 <_bss_end+0x784c8>
 714:	02001505 	andeq	r1, r0, #20971520	; 0x1400000
 718:	05820204 	streq	r0, [r2, #516]	; 0x204
 71c:	04020021 	streq	r0, [r2], #-33	; 0xffffffdf
 720:	17054a02 	strne	r4, [r5, -r2, lsl #20]
 724:	02040200 	andeq	r0, r4, #0, 4
 728:	0010052e 	andseq	r0, r0, lr, lsr #10
 72c:	2f020402 	svccs	0x00020402
 730:	02001105 	andeq	r1, r0, #1073741825	; 0x40000001
 734:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
 738:	04020013 	streq	r0, [r2], #-19	; 0xffffffed
 73c:	05054a02 	streq	r4, [r5, #-2562]	; 0xfffff5fe
 740:	02040200 	andeq	r0, r4, #0, 4
 744:	88010546 	stmdahi	r1, {r1, r2, r6, r8, sl}
 748:	02009e82 	andeq	r9, r0, #2080	; 0x820
 74c:	66060104 	strvs	r0, [r6], -r4, lsl #2
 750:	03062705 	movweq	r2, #26373	; 0x6705
 754:	05827eb8 	streq	r7, [r2, #3768]	; 0xeb8
 758:	01c80301 	biceq	r0, r8, r1, lsl #6
 75c:	024a9e9e 	subeq	r9, sl, #2528	; 0x9e0
 760:	0101000a 	tsteq	r1, sl
 764:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
 768:	008c3802 	addeq	r3, ip, r2, lsl #16
 76c:	010e0300 	mrseq	r0, ELR_hyp
 770:	67831005 	strvs	r1, [r3, r5]
 774:	02670105 	rsbeq	r0, r7, #1073741825	; 0x40000001
 778:	01010008 	tsteq	r1, r8
 77c:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
 780:	008c7002 	addeq	r7, ip, r2
 784:	01210300 			; <UNDEFINED> instruction: 0x01210300
 788:	05831205 	streq	r1, [r3, #517]	; 0x205
 78c:	05054a17 	streq	r4, [r5, #-2583]	; 0xfffff5e9
 790:	4c14054a 	cfldr32mi	mvfx0, [r4], {74}	; 0x4a
 794:	4a090567 	bmi	241d38 <_bss_end+0x238ae0>
 798:	05691205 	strbeq	r1, [r9, #-517]!	; 0xfffffdfb
 79c:	05054a17 	streq	r4, [r5, #-2583]	; 0xfffff5e9
 7a0:	4c0f054a 	cfstr32mi	mvfx0, [pc], {74}	; 0x4a
 7a4:	054b1605 	strbeq	r1, [fp, #-1541]	; 0xfffff9fb
 7a8:	14054a1f 	strne	r4, [r5], #-2591	; 0xfffff5e1
 7ac:	4c01052e 	cfstr32mi	mvfx0, [r1], {46}	; 0x2e
 7b0:	01000602 	tsteq	r0, r2, lsl #12
 7b4:	00010501 	andeq	r0, r1, r1, lsl #10
 7b8:	8cf80205 	lfmhi	f0, 2, [r8], #20
 7bc:	c0030000 	andgt	r0, r3, r0
 7c0:	13050100 	movwne	r0, #20736	; 0x5100
 7c4:	67010583 	strvs	r0, [r1, -r3, lsl #11]
 7c8:	01000802 	tsteq	r0, r2, lsl #16
 7cc:	00010501 	andeq	r0, r1, r1, lsl #10
 7d0:	8d240205 	sfmhi	f0, 4, [r4, #-20]!	; 0xffffffec
 7d4:	87030000 	strhi	r0, [r3, -r0]
 7d8:	05050101 	streq	r0, [r5, #-257]	; 0xfffffeff
 7dc:	691005bb 	ldmdbvs	r0, {r0, r1, r3, r4, r5, r7, r8, sl}
 7e0:	054c0505 	strbeq	r0, [ip, #-1285]	; 0xfffffafb
 7e4:	12058410 	andne	r8, r5, #16, 8	; 0x10000000
 7e8:	4c0e054d 	cfstr32mi	mvfx0, [lr], {77}	; 0x4d
 7ec:	05840b05 	streq	r0, [r4, #2821]	; 0xb05
 7f0:	05058311 	streq	r8, [r5, #-785]	; 0xfffffcef
 7f4:	340c0563 	strcc	r0, [ip], #-1379	; 0xfffffa9d
 7f8:	022f0105 	eoreq	r0, pc, #1073741825	; 0x40000001
 7fc:	01010008 	tsteq	r1, r8
 800:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
 804:	008db402 	addeq	fp, sp, r2, lsl #8
 808:	019e0300 	orrseq	r0, lr, r0, lsl #6
 80c:	bb050501 	bllt	141c18 <_bss_end+0x1389c0>
 810:	05691005 	strbeq	r1, [r9, #-5]!
 814:	10054c05 	andne	r4, r5, r5, lsl #24
 818:	4c0e0584 	cfstr32mi	mvfx0, [lr], {132}	; 0x84
 81c:	05840b05 	streq	r0, [r4, #2821]	; 0xb05
 820:	0c058005 	stceq	0, cr8, [r5], {5}
 824:	2f010533 	svccs	0x00010533
 828:	01000802 	tsteq	r0, r2, lsl #16
 82c:	0001c201 	andeq	ip, r1, r1, lsl #4
 830:	4e000300 	cdpmi	3, 0, cr0, cr0, cr0, {0}
 834:	02000001 	andeq	r0, r0, #1
 838:	0d0efb01 	vstreq	d15, [lr, #-4]
 83c:	01010100 	mrseq	r0, (UNDEF: 17)
 840:	00000001 	andeq	r0, r0, r1
 844:	01000001 	tsteq	r0, r1
 848:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 794 <_start-0x786c>
 84c:	69732f65 	ldmdbvs	r3!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 850:	7661686c 	strbtvc	r6, [r1], -ip, ror #16
 854:	532f6a79 			; <UNDEFINED> instruction: 0x532f6a79
 858:	6f6f6863 	svcvs	0x006f6863
 85c:	655a2f6c 	ldrbvs	r2, [sl, #-3948]	; 0xfffff094
 860:	614d6f72 	hvcvs	55026	; 0xd6f2
 864:	652f6574 	strvs	r6, [pc, #-1396]!	; 2f8 <_start-0x7d08>
 868:	706d6178 	rsbvc	r6, sp, r8, ror r1
 86c:	2f73656c 	svccs	0x0073656c
 870:	4c2d3730 	stcmi	7, cr3, [sp], #-192	; 0xffffff40
 874:	745f4445 	ldrbvc	r4, [pc], #-1093	; 87c <_start-0x7784>
 878:	6c67676f 	stclvs	7, cr6, [r7], #-444	; 0xfffffe44
 87c:	65645f65 	strbvs	r5, [r4, #-3941]!	; 0xfffff09b
 880:	5f677562 	svcpl	0x00677562
 884:	696e6f6d 	stmdbvs	lr!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
 888:	2f726f74 	svccs	0x00726f74
 88c:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 890:	732f6c65 			; <UNDEFINED> instruction: 0x732f6c65
 894:	2f006372 	svccs	0x00006372
 898:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
 89c:	6c69732f 	stclvs	3, cr7, [r9], #-188	; 0xffffff44
 8a0:	79766168 	ldmdbvc	r6!, {r3, r5, r6, r8, sp, lr}^
 8a4:	63532f6a 	cmpvs	r3, #424	; 0x1a8
 8a8:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; 710 <_start-0x78f0>
 8ac:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
 8b0:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
 8b4:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 8b8:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
 8bc:	302f7365 	eorcc	r7, pc, r5, ror #6
 8c0:	454c2d37 	strbmi	r2, [ip, #-3383]	; 0xfffff2c9
 8c4:	6f745f44 	svcvs	0x00745f44
 8c8:	656c6767 	strbvs	r6, [ip, #-1895]!	; 0xfffff899
 8cc:	6265645f 	rsbvs	r6, r5, #1593835520	; 0x5f000000
 8d0:	6d5f6775 	ldclvs	7, cr6, [pc, #-468]	; 704 <_start-0x78fc>
 8d4:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
 8d8:	6b2f726f 	blvs	bdd29c <_bss_end+0xbd4044>
 8dc:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 8e0:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
 8e4:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 8e8:	6f622f65 	svcvs	0x00622f65
 8ec:	2f647261 	svccs	0x00647261
 8f0:	30697072 	rsbcc	r7, r9, r2, ror r0
 8f4:	6c61682f 	stclvs	8, cr6, [r1], #-188	; 0xffffff44
 8f8:	6f682f00 	svcvs	0x00682f00
 8fc:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
 900:	61686c69 	cmnvs	r8, r9, ror #24
 904:	2f6a7976 	svccs	0x006a7976
 908:	6f686353 	svcvs	0x00686353
 90c:	5a2f6c6f 	bpl	bdbad0 <_bss_end+0xbd2878>
 910:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 784 <_start-0x787c>
 914:	2f657461 	svccs	0x00657461
 918:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
 91c:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
 920:	2d37302f 	ldccs	0, cr3, [r7, #-188]!	; 0xffffff44
 924:	5f44454c 	svcpl	0x0044454c
 928:	67676f74 			; <UNDEFINED> instruction: 0x67676f74
 92c:	645f656c 	ldrbvs	r6, [pc], #-1388	; 934 <_start-0x76cc>
 930:	67756265 	ldrbvs	r6, [r5, -r5, ror #4]!
 934:	6e6f6d5f 	mcrvs	13, 3, r6, cr15, cr15, {2}
 938:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
 93c:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 940:	2f6c656e 	svccs	0x006c656e
 944:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 948:	2f656475 	svccs	0x00656475
 94c:	76697264 	strbtvc	r7, [r9], -r4, ror #4
 950:	00737265 	rsbseq	r7, r3, r5, ror #4
 954:	69616d00 	stmdbvs	r1!, {r8, sl, fp, sp, lr}^
 958:	70632e6e 	rsbvc	r2, r3, lr, ror #28
 95c:	00010070 	andeq	r0, r1, r0, ror r0
 960:	746e6900 	strbtvc	r6, [lr], #-2304	; 0xfffff700
 964:	2e666564 	cdpcs	5, 6, cr6, cr6, cr4, {3}
 968:	00020068 	andeq	r0, r2, r8, rrx
 96c:	69706700 	ldmdbvs	r0!, {r8, r9, sl, sp, lr}^
 970:	00682e6f 	rsbeq	r2, r8, pc, ror #28
 974:	6d000003 	stcvs	0, cr0, [r0, #-12]
 978:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
 97c:	682e726f 	stmdavs	lr!, {r0, r1, r2, r3, r5, r6, r9, ip, sp, lr}
 980:	00000300 	andeq	r0, r0, r0, lsl #6
 984:	00010500 	andeq	r0, r1, r0, lsl #10
 988:	8e300205 	cdphi	2, 3, cr0, cr0, cr5, {0}
 98c:	05190000 	ldreq	r0, [r9, #-0]
 990:	11056713 	tstne	r5, r3, lsl r7
 994:	3e05684b 	cdpcc	8, 0, cr6, cr5, cr11, {2}
 998:	82460582 	subhi	r0, r6, #545259520	; 0x20800000
 99c:	05827505 	streq	r7, [r2, #1285]	; 0x505
 9a0:	8705827c 	smlsdxhi	r5, ip, r2, r8
 9a4:	11058201 	tstne	r5, r1, lsl #4
 9a8:	822a0567 	eorhi	r0, sl, #432013312	; 0x19c00000
 9ac:	05822f05 	streq	r2, [r2, #3845]	; 0xf05
 9b0:	2a056711 	bcs	15a5fc <_bss_end+0x1513a4>
 9b4:	822f0582 	eorhi	r0, pc, #545259520	; 0x20800000
 9b8:	05691c05 	strbeq	r1, [r9, #-3077]!	; 0xfffff3fb
 9bc:	1b058912 	blne	162e0c <_bss_end+0x159bb4>
 9c0:	03040200 	movweq	r0, #16896	; 0x4200
 9c4:	0009054a 	andeq	r0, r9, sl, asr #10
 9c8:	d6020402 	strle	r0, [r2], -r2, lsl #8
 9cc:	05861905 	streq	r1, [r6, #2309]	; 0x905
 9d0:	12058315 	andne	r8, r5, #1409286144	; 0x54000000
 9d4:	001b0569 	andseq	r0, fp, r9, ror #10
 9d8:	4a030402 	bmi	c19e8 <_bss_end+0xb8790>
 9dc:	02000905 	andeq	r0, r0, #81920	; 0x14000
 9e0:	05d60204 	ldrbeq	r0, [r6, #516]	; 0x204
 9e4:	15058619 	strne	r8, [r5, #-1561]	; 0xfffff9e7
 9e8:	03120583 	tsteq	r2, #549453824	; 0x20c00000
 9ec:	18026673 	stmdane	r2, {r0, r1, r4, r5, r6, r9, sl, sp, lr}
 9f0:	85010100 	strhi	r0, [r1, #-256]	; 0xffffff00
 9f4:	03000000 	movweq	r0, #0
 9f8:	00006d00 	andeq	r6, r0, r0, lsl #26
 9fc:	fb010200 	blx	41206 <_bss_end+0x37fae>
 a00:	01000d0e 	tsteq	r0, lr, lsl #26
 a04:	00010101 	andeq	r0, r1, r1, lsl #2
 a08:	00010000 	andeq	r0, r1, r0
 a0c:	682f0100 	stmdavs	pc!, {r8}	; <UNPREDICTABLE>
 a10:	2f656d6f 	svccs	0x00656d6f
 a14:	686c6973 	stmdavs	ip!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
 a18:	6a797661 	bvs	1e5e3a4 <_bss_end+0x1e5514c>
 a1c:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
 a20:	2f6c6f6f 	svccs	0x006c6f6f
 a24:	6f72655a 	svcvs	0x0072655a
 a28:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
 a2c:	6178652f 	cmnvs	r8, pc, lsr #10
 a30:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
 a34:	37302f73 			; <UNDEFINED> instruction: 0x37302f73
 a38:	44454c2d 	strbmi	r4, [r5], #-3117	; 0xfffff3d3
 a3c:	676f745f 			; <UNDEFINED> instruction: 0x676f745f
 a40:	5f656c67 	svcpl	0x00656c67
 a44:	75626564 	strbvc	r6, [r2, #-1380]!	; 0xfffffa9c
 a48:	6f6d5f67 	svcvs	0x006d5f67
 a4c:	6f74696e 	svcvs	0x0074696e
 a50:	656b2f72 	strbvs	r2, [fp, #-3954]!	; 0xfffff08e
 a54:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
 a58:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
 a5c:	74730000 	ldrbtvc	r0, [r3], #-0
 a60:	2e747261 	cdpcs	2, 7, cr7, cr4, cr1, {3}
 a64:	00010073 	andeq	r0, r1, r3, ror r0
 a68:	05000000 	streq	r0, [r0, #-0]
 a6c:	00800002 	addeq	r0, r0, r2
 a70:	2f2f1900 	svccs	0x002f1900
 a74:	02302f2f 	eorseq	r2, r0, #47, 30	; 0xbc
 a78:	01010002 	tsteq	r1, r2
 a7c:	000000f2 	strdeq	r0, [r0], -r2
 a80:	00710003 	rsbseq	r0, r1, r3
 a84:	01020000 	mrseq	r0, (UNDEF: 2)
 a88:	000d0efb 	strdeq	r0, [sp], -fp
 a8c:	01010101 	tsteq	r1, r1, lsl #2
 a90:	01000000 	mrseq	r0, (UNDEF: 0)
 a94:	2f010000 	svccs	0x00010000
 a98:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
 a9c:	6c69732f 	stclvs	3, cr7, [r9], #-188	; 0xffffff44
 aa0:	79766168 	ldmdbvc	r6!, {r3, r5, r6, r8, sp, lr}^
 aa4:	63532f6a 	cmpvs	r3, #424	; 0x1a8
 aa8:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; 910 <_start-0x76f0>
 aac:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
 ab0:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
 ab4:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 ab8:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
 abc:	302f7365 	eorcc	r7, pc, r5, ror #6
 ac0:	454c2d37 	strbmi	r2, [ip, #-3383]	; 0xfffff2c9
 ac4:	6f745f44 	svcvs	0x00745f44
 ac8:	656c6767 	strbvs	r6, [ip, #-1895]!	; 0xfffff899
 acc:	6265645f 	rsbvs	r6, r5, #1593835520	; 0x5f000000
 ad0:	6d5f6775 	ldclvs	7, cr6, [pc, #-468]	; 904 <_start-0x76fc>
 ad4:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
 ad8:	6b2f726f 	blvs	bdd49c <_bss_end+0xbd4244>
 adc:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 ae0:	72732f6c 	rsbsvc	r2, r3, #108, 30	; 0x1b0
 ae4:	73000063 	movwvc	r0, #99	; 0x63
 ae8:	74726174 	ldrbtvc	r6, [r2], #-372	; 0xfffffe8c
 aec:	632e7075 			; <UNDEFINED> instruction: 0x632e7075
 af0:	01007070 	tsteq	r0, r0, ror r0
 af4:	05000000 	streq	r0, [r0, #-0]
 af8:	02050001 	andeq	r0, r5, #1
 afc:	00008fe4 	andeq	r8, r0, r4, ror #31
 b00:	05011403 	streq	r1, [r1, #-1027]	; 0xfffffbfd
 b04:	22056a0c 	andcs	r6, r5, #12, 20	; 0xc000
 b08:	03040200 	movweq	r0, #16896	; 0x4200
 b0c:	000c0566 	andeq	r0, ip, r6, ror #10
 b10:	bb020402 	bllt	81b20 <_bss_end+0x788c8>
 b14:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
 b18:	05650204 	strbeq	r0, [r5, #-516]!	; 0xfffffdfc
 b1c:	0105850c 	tsteq	r5, ip, lsl #10
 b20:	1005bd2f 	andne	fp, r5, pc, lsr #26
 b24:	0027056b 	eoreq	r0, r7, fp, ror #10
 b28:	4a030402 	bmi	c1b38 <_bss_end+0xb88e0>
 b2c:	02000a05 	andeq	r0, r0, #20480	; 0x5000
 b30:	05830204 	streq	r0, [r3, #516]	; 0x204
 b34:	04020011 	streq	r0, [r2], #-17	; 0xffffffef
 b38:	05054a02 	streq	r4, [r5, #-2562]	; 0xfffff5fe
 b3c:	02040200 	andeq	r0, r4, #0, 4
 b40:	850c052d 	strhi	r0, [ip, #-1325]	; 0xfffffad3
 b44:	a12f0105 			; <UNDEFINED> instruction: 0xa12f0105
 b48:	056a1005 	strbeq	r1, [sl, #-5]!
 b4c:	04020027 	streq	r0, [r2], #-39	; 0xffffffd9
 b50:	0a054a03 	beq	153364 <_bss_end+0x14a10c>
 b54:	02040200 	andeq	r0, r4, #0, 4
 b58:	00110583 	andseq	r0, r1, r3, lsl #11
 b5c:	4a020402 	bmi	81b6c <_bss_end+0x78914>
 b60:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
 b64:	052d0204 	streq	r0, [sp, #-516]!	; 0xfffffdfc
 b68:	0105850c 	tsteq	r5, ip, lsl #10
 b6c:	000a022f 	andeq	r0, sl, pc, lsr #4
 b70:	01030101 	tsteq	r3, r1, lsl #2
 b74:	00030000 	andeq	r0, r3, r0
 b78:	000000fd 	strdeq	r0, [r0], -sp
 b7c:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
 b80:	0101000d 	tsteq	r1, sp
 b84:	00000101 	andeq	r0, r0, r1, lsl #2
 b88:	00000100 	andeq	r0, r0, r0, lsl #2
 b8c:	2f2e2e01 	svccs	0x002e2e01
 b90:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 b94:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 b98:	2f2e2e2f 	svccs	0x002e2e2f
 b9c:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; aec <_start-0x7514>
 ba0:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
 ba4:	2e2e2f63 	cdpcs	15, 2, cr2, cr14, cr3, {3}
 ba8:	636e692f 	cmnvs	lr, #770048	; 0xbc000
 bac:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
 bb0:	2f2e2e00 	svccs	0x002e2e00
 bb4:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 bb8:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 bbc:	2f2e2e2f 	svccs	0x002e2e2f
 bc0:	63672f2e 	cmnvs	r7, #46, 30	; 0xb8
 bc4:	2e2e0063 	cdpcs	0, 2, cr0, cr14, cr3, {3}
 bc8:	2f2e2e2f 	svccs	0x002e2e2f
 bcc:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 bd0:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 bd4:	2f2e2e2f 	svccs	0x002e2e2f
 bd8:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
 bdc:	2e2f6363 	cdpcs	3, 2, cr6, cr15, cr3, {3}
 be0:	63672f2e 	cmnvs	r7, #46, 30	; 0xb8
 be4:	6f632f63 	svcvs	0x00632f63
 be8:	6769666e 	strbvs	r6, [r9, -lr, ror #12]!
 bec:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
 bf0:	2f2e2e00 	svccs	0x002e2e00
 bf4:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 bf8:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 bfc:	2f2e2e2f 	svccs	0x002e2e2f
 c00:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; b50 <_start-0x74b0>
 c04:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
 c08:	68000063 	stmdavs	r0, {r0, r1, r5, r6}
 c0c:	74687361 	strbtvc	r7, [r8], #-865	; 0xfffffc9f
 c10:	682e6261 	stmdavs	lr!, {r0, r5, r6, r9, sp, lr}
 c14:	00000100 	andeq	r0, r0, r0, lsl #2
 c18:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
 c1c:	2e617369 	cdpcs	3, 6, cr7, cr1, cr9, {3}
 c20:	00020068 	andeq	r0, r2, r8, rrx
 c24:	6d726100 	ldfvse	f6, [r2, #-0]
 c28:	7570632d 	ldrbvc	r6, [r0, #-813]!	; 0xfffffcd3
 c2c:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 c30:	6e690000 	cdpvs	0, 6, cr0, cr9, cr0, {0}
 c34:	632d6e73 			; <UNDEFINED> instruction: 0x632d6e73
 c38:	74736e6f 	ldrbtvc	r6, [r3], #-3695	; 0xfffff191
 c3c:	73746e61 	cmnvc	r4, #1552	; 0x610
 c40:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 c44:	72610000 	rsbvc	r0, r1, #0
 c48:	00682e6d 	rsbeq	r2, r8, sp, ror #28
 c4c:	6c000003 	stcvs	0, cr0, [r0], {3}
 c50:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
 c54:	682e3263 	stmdavs	lr!, {r0, r1, r5, r6, r9, ip, sp}
 c58:	00000400 	andeq	r0, r0, r0, lsl #8
 c5c:	2d6c6267 	sfmcs	f6, 2, [ip, #-412]!	; 0xfffffe64
 c60:	726f7463 	rsbvc	r7, pc, #1660944384	; 0x63000000
 c64:	00682e73 	rsbeq	r2, r8, r3, ror lr
 c68:	6c000004 	stcvs	0, cr0, [r0], {4}
 c6c:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
 c70:	632e3263 			; <UNDEFINED> instruction: 0x632e3263
 c74:	00000400 	andeq	r0, r0, r0, lsl #8
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
      20:	5b202965 	blpl	80a5bc <_bss_end+0x801364>
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
      88:	7a6a3637 	bvc	1a8d96c <_bss_end+0x1a84714>
      8c:	20732d66 	rsbscs	r2, r3, r6, ror #26
      90:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
      94:	6d2d206d 	stcvs	0, cr2, [sp, #-436]!	; 0xfffffe4c
      98:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
      9c:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
      a0:	6b7a3676 	blvs	1e8da80 <_bss_end+0x1e84828>
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
      dc:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 28 <_start-0x7fd8>
      e0:	69732f65 	ldmdbvs	r3!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
      e4:	7661686c 	strbtvc	r6, [r1], -ip, ror #16
      e8:	532f6a79 			; <UNDEFINED> instruction: 0x532f6a79
      ec:	6f6f6863 	svcvs	0x006f6863
      f0:	655a2f6c 	ldrbvs	r2, [sl, #-3948]	; 0xfffff094
      f4:	614d6f72 	hvcvs	55026	; 0xd6f2
      f8:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffb8c <_bss_end+0xffff6934>
      fc:	706d6178 	rsbvc	r6, sp, r8, ror r1
     100:	2f73656c 	svccs	0x0073656c
     104:	4c2d3730 	stcmi	7, cr3, [sp], #-192	; 0xffffff40
     108:	745f4445 	ldrbvc	r4, [pc], #-1093	; 110 <_start-0x7ef0>
     10c:	6c67676f 	stclvs	7, cr6, [r7], #-444	; 0xfffffe44
     110:	65645f65 	strbvs	r5, [r4, #-3941]!	; 0xfffff09b
     114:	5f677562 	svcpl	0x00677562
     118:	696e6f6d 	stmdbvs	lr!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
     11c:	2f726f74 	svccs	0x00726f74
     120:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
     124:	732f6c65 			; <UNDEFINED> instruction: 0x732f6c65
     128:	632f6372 			; <UNDEFINED> instruction: 0x632f6372
     12c:	632e7878 			; <UNDEFINED> instruction: 0x632e7878
     130:	5f007070 	svcpl	0x00007070
     134:	6f73645f 	svcvs	0x0073645f
     138:	6e61685f 	mcrvs	8, 3, r6, cr1, cr15, {2}
     13c:	00656c64 	rsbeq	r6, r5, r4, ror #24
     140:	78635f5f 	stmdavc	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, sl, fp, ip, lr}^
     144:	74615f61 	strbtvc	r5, [r1], #-3937	; 0xfffff09f
     148:	74697865 	strbtvc	r7, [r9], #-2149	; 0xfffff79b
     14c:	6f682f00 	svcvs	0x00682f00
     150:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
     154:	61686c69 	cmnvs	r8, r9, ror #24
     158:	2f6a7976 	svccs	0x006a7976
     15c:	6f686353 	svcvs	0x00686353
     160:	5a2f6c6f 	bpl	bdb324 <_bss_end+0xbd20cc>
     164:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; ffffffd8 <_bss_end+0xffff6d80>
     168:	2f657461 	svccs	0x00657461
     16c:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
     170:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
     174:	2d37302f 	ldccs	0, cr3, [r7, #-188]!	; 0xffffff44
     178:	5f44454c 	svcpl	0x0044454c
     17c:	67676f74 			; <UNDEFINED> instruction: 0x67676f74
     180:	645f656c 	ldrbvs	r6, [pc], #-1388	; 188 <_start-0x7e78>
     184:	67756265 	ldrbvs	r6, [r5, -r5, ror #4]!
     188:	6e6f6d5f 	mcrvs	13, 3, r6, cr15, cr15, {2}
     18c:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
     190:	6975622f 	ldmdbvs	r5!, {r0, r1, r2, r3, r5, r9, sp, lr}^
     194:	5f00646c 	svcpl	0x0000646c
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
     1f4:	50470074 	subpl	r0, r7, r4, ror r0
     1f8:	304e4552 	subcc	r4, lr, r2, asr r5
     1fc:	52504700 	subspl	r4, r0, #0, 14
     200:	00314e45 	eorseq	r4, r1, r5, asr #28
     204:	46415047 	strbmi	r5, [r1], -r7, asr #32
     208:	00314e45 	eorseq	r4, r1, r5, asr #28
     20c:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     210:	61485f4f 	cmpvs	r8, pc, asr #30
     214:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     218:	65530072 	ldrbvs	r0, [r3, #-114]	; 0xffffff8e
     21c:	754f5f74 	strbvc	r5, [pc, #-3956]	; fffff2b0 <_bss_end+0xffff6058>
     220:	74757074 	ldrbtvc	r7, [r5], #-116	; 0xffffff8c
     224:	736e5500 	cmnvc	lr, #0, 10
     228:	69636570 	stmdbvs	r3!, {r4, r5, r6, r8, sl, sp, lr}^
     22c:	64656966 	strbtvs	r6, [r5], #-2406	; 0xfffff69a
     230:	69706700 	ldmdbvs	r0!, {r8, r9, sl, sp, lr}^
     234:	61625f6f 	cmnvs	r2, pc, ror #30
     238:	615f6573 	cmpvs	pc, r3, ror r5	; <UNPREDICTABLE>
     23c:	00726464 	rsbseq	r6, r2, r4, ror #8
     240:	4b4e5a5f 	blmi	1396bc4 <_bss_end+0x138d96c>
     244:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     248:	5f4f4950 	svcpl	0x004f4950
     24c:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     250:	3172656c 	cmncc	r2, ip, ror #10
     254:	74654738 	strbtvc	r4, [r5], #-1848	; 0xfffff8c8
     258:	4c50475f 	mrrcmi	7, 5, r4, r0, cr15
     25c:	4c5f5645 	mrrcmi	6, 4, r5, pc, cr5	; <UNPREDICTABLE>
     260:	7461636f 	strbtvc	r6, [r1], #-879	; 0xfffffc91
     264:	456e6f69 	strbmi	r6, [lr, #-3945]!	; 0xfffff097
     268:	536a526a 	cmnpl	sl, #-1610612730	; 0xa0000006
     26c:	47005f30 	smladxmi	r0, r0, pc, r5	; <UNPREDICTABLE>
     270:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     274:	5f4f4950 	svcpl	0x004f4950
     278:	636e7546 	cmnvs	lr, #293601280	; 0x11800000
     27c:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     280:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     284:	4333314b 	teqmi	r3, #-1073741806	; 0xc0000012
     288:	4f495047 	svcmi	0x00495047
     28c:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     290:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     294:	65473831 	strbvs	r3, [r7, #-2097]	; 0xfffff7cf
     298:	50475f74 	subpl	r5, r7, r4, ror pc
     29c:	5f544553 	svcpl	0x00544553
     2a0:	61636f4c 	cmnvs	r3, ip, asr #30
     2a4:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     2a8:	6a526a45 	bvs	149abc4 <_bss_end+0x149196c>
     2ac:	005f3053 	subseq	r3, pc, r3, asr r0	; <UNPREDICTABLE>
     2b0:	4b4e5a5f 	blmi	1396c34 <_bss_end+0x138d9dc>
     2b4:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     2b8:	5f4f4950 	svcpl	0x004f4950
     2bc:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     2c0:	3172656c 	cmncc	r2, ip, ror #10
     2c4:	74654738 	strbtvc	r4, [r5], #-1848	; 0xfffff8c8
     2c8:	4350475f 	cmpmi	r0, #24903680	; 0x17c0000
     2cc:	4c5f524c 	lfmmi	f5, 2, [pc], {76}	; 0x4c
     2d0:	7461636f 	strbtvc	r6, [r1], #-879	; 0xfffffc91
     2d4:	456e6f69 	strbmi	r6, [lr, #-3945]!	; 0xfffff097
     2d8:	536a526a 	cmnpl	sl, #-1610612730	; 0xa0000006
     2dc:	47005f30 	smladxmi	r0, r0, pc, r5	; <UNPREDICTABLE>
     2e0:	524c4350 	subpl	r4, ip, #80, 6	; 0x40000001
     2e4:	475f0031 	smmlarmi	pc, r1, r0, r0	; <UNPREDICTABLE>
     2e8:	41424f4c 	cmpmi	r2, ip, asr #30
     2ec:	735f5f4c 	cmpvc	pc, #76, 30	; 0x130
     2f0:	495f6275 	ldmdbmi	pc, {r0, r2, r4, r5, r6, r9, sp, lr}^	; <UNPREDICTABLE>
     2f4:	5047735f 	subpl	r7, r7, pc, asr r3
     2f8:	47004f49 	strmi	r4, [r0, -r9, asr #30]
     2fc:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     300:	45534650 	ldrbmi	r4, [r3, #-1616]	; 0xfffff9b0
     304:	6f4c5f4c 	svcvs	0x004c5f4c
     308:	69746163 	ldmdbvs	r4!, {r0, r1, r5, r6, r8, sp, lr}^
     30c:	5f006e6f 	svcpl	0x00006e6f
     310:	314b4e5a 	cmpcc	fp, sl, asr lr
     314:	50474333 	subpl	r4, r7, r3, lsr r3
     318:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     31c:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     320:	39317265 	ldmdbcc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     324:	5f746547 	svcpl	0x00746547
     328:	53465047 	movtpl	r5, #24647	; 0x6047
     32c:	4c5f4c45 	mrrcmi	12, 4, r4, pc, cr5	; <UNPREDICTABLE>
     330:	7461636f 	strbtvc	r6, [r1], #-879	; 0xfffffc91
     334:	456e6f69 	strbmi	r6, [lr, #-3945]!	; 0xfffff097
     338:	536a526a 	cmnpl	sl, #-1610612730	; 0xa0000006
     33c:	47005f30 	smladxmi	r0, r0, pc, r5	; <UNPREDICTABLE>
     340:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     344:	54455350 	strbpl	r5, [r5], #-848	; 0xfffffcb0
     348:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     34c:	6f697461 	svcvs	0x00697461
     350:	5047006e 	subpl	r0, r7, lr, rrx
     354:	43445550 	movtmi	r5, #17744	; 0x4550
     358:	00304b4c 	eorseq	r4, r0, ip, asr #22
     35c:	4f495047 	svcmi	0x00495047
     360:	6765525f 			; <UNDEFINED> instruction: 0x6765525f
     364:	4c504700 	mrrcmi	7, 0, r4, r0, cr0
     368:	00305645 	eorseq	r5, r0, r5, asr #12
     36c:	454c5047 	strbmi	r5, [ip, #-71]	; 0xffffffb9
     370:	41003156 	tstmi	r0, r6, asr r1
     374:	335f746c 	cmpcc	pc, #108, 8	; 0x6c000000
     378:	746c4100 	strbtvc	r4, [ip], #-256	; 0xffffff00
     37c:	4700315f 	smlsdmi	r0, pc, r1, r3	; <UNPREDICTABLE>
     380:	44555050 	ldrbmi	r5, [r5], #-80	; 0xffffffb0
     384:	736e7500 	cmnvc	lr, #0, 10
     388:	656e6769 	strbvs	r6, [lr, #-1897]!	; 0xfffff897
     38c:	68632064 	stmdavs	r3!, {r2, r5, r6, sp}^
     390:	41007261 	tstmi	r0, r1, ror #4
     394:	325f746c 	subscc	r7, pc, #108, 8	; 0x6c000000
     398:	746c4100 	strbtvc	r4, [ip], #-256	; 0xffffff00
     39c:	4700305f 	smlsdmi	r0, pc, r0, r3	; <UNPREDICTABLE>
     3a0:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     3a4:	524c4350 	subpl	r4, ip, #80, 6	; 0x40000001
     3a8:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     3ac:	6f697461 	svcvs	0x00697461
     3b0:	5047006e 	subpl	r0, r7, lr, rrx
     3b4:	43445550 	movtmi	r5, #17744	; 0x4550
     3b8:	00314b4c 	eorseq	r4, r1, ip, asr #22
     3bc:	4c435047 	mcrrmi	0, 4, r5, r3, cr7
     3c0:	73003052 	movwvc	r3, #82	; 0x52
     3c4:	74726f68 	ldrbtvc	r6, [r2], #-3944	; 0xfffff098
     3c8:	736e7520 	cmnvc	lr, #32, 10	; 0x8000000
     3cc:	656e6769 	strbvs	r6, [lr, #-1897]!	; 0xfffff897
     3d0:	6e692064 	cdpvs	0, 6, cr2, cr9, cr4, {3}
     3d4:	50470074 	subpl	r0, r7, r4, ror r0
     3d8:	505f4f49 	subspl	r4, pc, r9, asr #30
     3dc:	435f6e69 	cmpmi	pc, #1680	; 0x690
     3e0:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
     3e4:	53504700 	cmppl	r0, #0, 14
     3e8:	00305445 	eorseq	r5, r0, r5, asr #8
     3ec:	45535047 	ldrbmi	r5, [r3, #-71]	; 0xffffffb9
     3f0:	41003154 	tstmi	r0, r4, asr r1
     3f4:	345f746c 	ldrbcc	r7, [pc], #-1132	; 3fc <_start-0x7c04>
     3f8:	746c4100 	strbtvc	r4, [ip], #-256	; 0xffffff00
     3fc:	5f00355f 	svcpl	0x0000355f
     400:	33314e5a 	teqcc	r1, #1440	; 0x5a0
     404:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     408:	61485f4f 	cmpvs	r8, pc, asr #30
     40c:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     410:	53303172 	teqpl	r0, #-2147483620	; 0x8000001c
     414:	4f5f7465 	svcmi	0x005f7465
     418:	75707475 	ldrbvc	r7, [r0, #-1141]!	; 0xfffffb8b
     41c:	626a4574 	rsbvs	r4, sl, #116, 10	; 0x1d000000
     420:	74655300 	strbtvc	r5, [r5], #-768	; 0xfffffd00
     424:	4950475f 	ldmdbmi	r0, {r0, r1, r2, r3, r4, r6, r8, r9, sl, lr}^
     428:	75465f4f 	strbvc	r5, [r6, #-3919]	; 0xfffff0b1
     42c:	6974636e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, r9, sp, lr}^
     430:	47006e6f 	strmi	r6, [r0, -pc, ror #28]
     434:	4e454650 	mcrmi	6, 2, r4, cr5, cr0, {2}
     438:	50470030 	subpl	r0, r7, r0, lsr r0
     43c:	314e4546 	cmpcc	lr, r6, asr #10
     440:	6e756600 	cdpvs	6, 7, cr6, cr5, cr0, {0}
     444:	50470063 	subpl	r0, r7, r3, rrx
     448:	4c455346 	mcrrmi	3, 4, r5, r5, cr6
     44c:	65500034 	ldrbvs	r0, [r0, #-52]	; 0xffffffcc
     450:	68706972 	ldmdavs	r0!, {r1, r4, r5, r6, r8, fp, sp, lr}^
     454:	6c617265 	sfmvs	f7, 2, [r1], #-404	; 0xfffffe6c
     458:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
     45c:	682f0065 	stmdavs	pc!, {r0, r2, r5, r6}	; <UNPREDICTABLE>
     460:	2f656d6f 	svccs	0x00656d6f
     464:	686c6973 	stmdavs	ip!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
     468:	6a797661 	bvs	1e5ddf4 <_bss_end+0x1e54b9c>
     46c:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
     470:	2f6c6f6f 	svccs	0x006c6f6f
     474:	6f72655a 	svcvs	0x0072655a
     478:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
     47c:	6178652f 	cmnvs	r8, pc, lsr #10
     480:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
     484:	37302f73 			; <UNDEFINED> instruction: 0x37302f73
     488:	44454c2d 	strbmi	r4, [r5], #-3117	; 0xfffff3d3
     48c:	676f745f 			; <UNDEFINED> instruction: 0x676f745f
     490:	5f656c67 	svcpl	0x00656c67
     494:	75626564 	strbvc	r6, [r2, #-1380]!	; 0xfffffa9c
     498:	6f6d5f67 	svcvs	0x006d5f67
     49c:	6f74696e 	svcvs	0x0074696e
     4a0:	656b2f72 	strbvs	r2, [fp, #-3954]!	; 0xfffff08e
     4a4:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
     4a8:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
     4ac:	6972642f 	ldmdbvs	r2!, {r0, r1, r2, r3, r5, sl, sp, lr}^
     4b0:	73726576 	cmnvc	r2, #494927872	; 0x1d800000
     4b4:	6970672f 	ldmdbvs	r0!, {r0, r1, r2, r3, r5, r8, r9, sl, sp, lr}^
     4b8:	70632e6f 	rsbvc	r2, r3, pc, ror #28
     4bc:	6e490070 	mcrvs	0, 2, r0, cr9, cr0, {3}
     4c0:	00747570 	rsbseq	r7, r4, r0, ror r5
     4c4:	72705f5f 	rsbsvc	r5, r0, #380	; 0x17c
     4c8:	69726f69 	ldmdbvs	r2!, {r0, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
     4cc:	47007974 	smlsdxmi	r0, r4, r9, r7
     4d0:	53444550 	movtpl	r4, #17744	; 0x4550
     4d4:	50470030 	subpl	r0, r7, r0, lsr r0
     4d8:	31534445 	cmpcc	r3, r5, asr #8
     4dc:	41504700 	cmpmi	r0, r0, lsl #14
     4e0:	304e4552 	subcc	r4, lr, r2, asr r5
     4e4:	41504700 	cmpmi	r0, r0, lsl #14
     4e8:	314e4552 	cmpcc	lr, r2, asr r5
     4ec:	6e697500 	cdpvs	5, 6, cr7, cr9, cr0, {0}
     4f0:	745f3874 	ldrbvc	r3, [pc], #-2164	; 4f8 <_start-0x7b08>
     4f4:	69687400 	stmdbvs	r8!, {sl, ip, sp, lr}^
     4f8:	5a5f0073 	bpl	17c06cc <_bss_end+0x17b7474>
     4fc:	33314b4e 	teqcc	r1, #79872	; 0x13800
     500:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     504:	61485f4f 	cmpvs	r8, pc, asr #30
     508:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     50c:	47373172 			; <UNDEFINED> instruction: 0x47373172
     510:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     514:	5f4f4950 	svcpl	0x004f4950
     518:	636e7546 	cmnvs	lr, #293601280	; 0x11800000
     51c:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     520:	5f006a45 	svcpl	0x00006a45
     524:	33314e5a 	teqcc	r1, #1440	; 0x5a0
     528:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     52c:	61485f4f 	cmpvs	r8, pc, asr #30
     530:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     534:	53373172 	teqpl	r7, #-2147483620	; 0x8000001c
     538:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     53c:	5f4f4950 	svcpl	0x004f4950
     540:	636e7546 	cmnvs	lr, #293601280	; 0x11800000
     544:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     548:	34316a45 	ldrtcc	r6, [r1], #-2629	; 0xfffff5bb
     54c:	4950474e 	ldmdbmi	r0, {r1, r2, r3, r6, r8, r9, sl, lr}^
     550:	75465f4f 	strbvc	r5, [r6, #-3919]	; 0xfffff0b1
     554:	6974636e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, r9, sp, lr}^
     558:	5f006e6f 	svcpl	0x00006e6f
     55c:	33314e5a 	teqcc	r1, #1440	; 0x5a0
     560:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     564:	61485f4f 	cmpvs	r8, pc, asr #30
     568:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     56c:	45324372 	ldrmi	r4, [r2, #-882]!	; 0xfffffc8e
     570:	476d006a 	strbmi	r0, [sp, -sl, rrx]!
     574:	004f4950 	subeq	r4, pc, r0, asr r9	; <UNPREDICTABLE>
     578:	46415047 	strbmi	r5, [r1], -r7, asr #32
     57c:	00304e45 	eorseq	r4, r0, r5, asr #28
     580:	454c5047 	strbmi	r5, [ip, #-71]	; 0xffffffb9
     584:	4700304e 	strmi	r3, [r0, -lr, asr #32]
     588:	4e454c50 	mcrmi	12, 2, r4, cr5, cr0, {2}
     58c:	69620031 	stmdbvs	r2!, {r0, r4, r5}^
     590:	64695f74 	strbtvs	r5, [r9], #-3956	; 0xfffff08c
     594:	68730078 	ldmdavs	r3!, {r3, r4, r5, r6}^
     598:	2074726f 	rsbscs	r7, r4, pc, ror #4
     59c:	00746e69 	rsbseq	r6, r4, r9, ror #28
     5a0:	746e6975 	strbtvc	r6, [lr], #-2421	; 0xfffff68b
     5a4:	745f3233 	ldrbvc	r3, [pc], #-563	; 5ac <_start-0x7a54>
     5a8:	6f6f6200 	svcvs	0x006f6200
     5ac:	5047006c 	subpl	r0, r7, ip, rrx
     5b0:	304e4548 	subcc	r4, lr, r8, asr #10
     5b4:	48504700 	ldmdami	r0, {r8, r9, sl, lr}^
     5b8:	00314e45 	eorseq	r4, r1, r5, asr #28
     5bc:	6e695f5f 	mcrvs	15, 3, r5, cr9, cr15, {2}
     5c0:	61697469 	cmnvs	r9, r9, ror #8
     5c4:	657a696c 	ldrbvs	r6, [sl, #-2412]!	; 0xfffff694
     5c8:	5f00705f 	svcpl	0x0000705f
     5cc:	33314e5a 	teqcc	r1, #1440	; 0x5a0
     5d0:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     5d4:	61485f4f 	cmpvs	r8, pc, asr #30
     5d8:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     5dc:	45344372 	ldrmi	r4, [r4, #-882]!	; 0xfffffc8e
     5e0:	6547006a 	strbvs	r0, [r7, #-106]	; 0xffffff96
     5e4:	50475f74 	subpl	r5, r7, r4, ror pc
     5e8:	5f56454c 	svcpl	0x0056454c
     5ec:	61636f4c 	cmnvs	r3, ip, asr #30
     5f0:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     5f4:	735f5f00 	cmpvc	pc, #0, 30
     5f8:	69746174 	ldmdbvs	r4!, {r2, r4, r5, r6, r8, sp, lr}^
     5fc:	6e695f63 	cdpvs	15, 6, cr5, cr9, cr3, {3}
     600:	61697469 	cmnvs	r9, r9, ror #8
     604:	617a696c 	cmnvs	sl, ip, ror #18
     608:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     60c:	646e615f 	strbtvs	r6, [lr], #-351	; 0xfffffea1
     610:	7365645f 	cmnvc	r5, #1593835520	; 0x5f000000
     614:	63757274 	cmnvs	r5, #116, 4	; 0x40000007
     618:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     61c:	4700305f 	smlsdmi	r0, pc, r0, r3	; <UNPREDICTABLE>
     620:	45534650 	ldrbmi	r4, [r3, #-1616]	; 0xfffff9b0
     624:	4700304c 	strmi	r3, [r0, -ip, asr #32]
     628:	45534650 	ldrbmi	r4, [r3, #-1616]	; 0xfffff9b0
     62c:	4700314c 	strmi	r3, [r0, -ip, asr #2]
     630:	45534650 	ldrbmi	r4, [r3, #-1616]	; 0xfffff9b0
     634:	4700324c 	strmi	r3, [r0, -ip, asr #4]
     638:	45534650 	ldrbmi	r4, [r3, #-1616]	; 0xfffff9b0
     63c:	4700334c 	strmi	r3, [r0, -ip, asr #6]
     640:	5f4f4950 	svcpl	0x004f4950
     644:	65736142 	ldrbvs	r6, [r3, #-322]!	; 0xfffffebe
     648:	46504700 	ldrbmi	r4, [r0], -r0, lsl #14
     64c:	354c4553 	strbcc	r4, [ip, #-1363]	; 0xfffffaad
     650:	72635300 	rsbvc	r5, r3, #0, 6
     654:	006c6c6f 	rsbeq	r6, ip, pc, ror #24
     658:	756c6176 	strbvc	r6, [ip, #-374]!	; 0xfffffe8a
     65c:	75710065 	ldrbvc	r0, [r1, #-101]!	; 0xffffff9b
     660:	6569746f 	strbvs	r7, [r9, #-1135]!	; 0xfffffb91
     664:	5f00746e 	svcpl	0x0000746e
     668:	43384e5a 	teqmi	r8, #1440	; 0x5a0
     66c:	696e6f4d 	stmdbvs	lr!, {r0, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     670:	31726f74 	cmncc	r2, r4, ror pc
     674:	6a644133 	bvs	1910b48 <_bss_end+0x19078f0>
     678:	5f747375 	svcpl	0x00747375
     67c:	73727543 	cmnvc	r2, #281018368	; 0x10c00000
     680:	7645726f 	strbvc	r7, [r5], -pc, ror #4
     684:	6e5f6d00 	cdpvs	13, 5, cr6, cr15, cr0, {0}
     688:	65626d75 	strbvs	r6, [r2, #-3445]!	; 0xfffff28b
     68c:	61625f72 	smcvs	9714	; 0x25f2
     690:	52006573 	andpl	r6, r0, #482344960	; 0x1cc00000
     694:	74657365 	strbtvc	r7, [r5], #-869	; 0xfffffc9b
     698:	6d754e5f 	ldclvs	14, cr4, [r5, #-380]!	; 0xfffffe84
     69c:	5f726562 	svcpl	0x00726562
     6a0:	65736142 	ldrbvs	r6, [r3, #-322]!	; 0xfffffebe
     6a4:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     6a8:	6f4d4338 	svcvs	0x004d4338
     6ac:	6f74696e 	svcvs	0x0074696e
     6b0:	65523972 	ldrbvs	r3, [r2, #-2418]	; 0xfffff68e
     6b4:	6e69616d 	powvsez	f6, f1, #5.0
     6b8:	45726564 	ldrbmi	r6, [r2, #-1380]!	; 0xfffffa9c
     6bc:	43006a6a 	movwmi	r6, #2666	; 0xa6a
     6c0:	7261656c 	rsbvc	r6, r1, #108, 10	; 0x1b000000
     6c4:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     6c8:	6f4d4338 	svcvs	0x004d4338
     6cc:	6f74696e 	svcvs	0x0074696e
     6d0:	45324372 	ldrmi	r4, [r2, #-882]!	; 0xfffffc8e
     6d4:	006a6a6a 	rsbeq	r6, sl, sl, ror #20
     6d8:	616f7469 	cmnvs	pc, r9, ror #8
     6dc:	73655200 	cmnvc	r5, #0, 4
     6e0:	435f7465 	cmpmi	pc, #1694498816	; 0x65000000
     6e4:	6f737275 	svcvs	0x00737275
     6e8:	64410072 	strbvs	r0, [r1], #-114	; 0xffffff8e
     6ec:	7473756a 	ldrbtvc	r7, [r3], #-1386	; 0xfffffa96
     6f0:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     6f4:	00726f73 	rsbseq	r6, r2, r3, ror pc
     6f8:	69766944 	ldmdbvs	r6!, {r2, r6, r8, fp, sp, lr}^
     6fc:	4e006564 	cfsh32mi	mvfx6, mvfx0, #52
     700:	626d754e 	rsbvs	r7, sp, #327155712	; 0x13800000
     704:	425f7265 	subsmi	r7, pc, #1342177286	; 0x50000006
     708:	00657361 	rsbeq	r7, r5, r1, ror #6
     70c:	736f5054 	cmnvc	pc, #84	; 0x54
     710:	6f697469 	svcvs	0x00697469
     714:	5a5f006e 	bpl	17c08d4 <_bss_end+0x17b767c>
     718:	4d43384e 	stclmi	8, cr3, [r3, #-312]	; 0xfffffec8
     71c:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
     720:	3731726f 	ldrcc	r7, [r1, -pc, ror #4]!
     724:	65736552 	ldrbvs	r6, [r3, #-1362]!	; 0xfffffaae
     728:	754e5f74 	strbvc	r5, [lr, #-3956]	; 0xfffff08c
     72c:	7265626d 	rsbvc	r6, r5, #-805306362	; 0xd0000006
     730:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
     734:	00764565 	rsbseq	r4, r6, r5, ror #10
     738:	6f6d5f6d 	svcvs	0x006d5f6d
     73c:	6f74696e 	svcvs	0x0074696e
     740:	475f0072 			; <UNDEFINED> instruction: 0x475f0072
     744:	41424f4c 	cmpmi	r2, ip, asr #30
     748:	735f5f4c 	cmpvc	pc, #76, 30	; 0x130
     74c:	495f6275 	ldmdbmi	pc, {r0, r2, r4, r5, r6, r9, sp, lr}^	; <UNPREDICTABLE>
     750:	6f4d735f 	svcvs	0x004d735f
     754:	6f74696e 	svcvs	0x0074696e
     758:	6f6d0072 	svcvs	0x006d0072
     75c:	6f74696e 	svcvs	0x0074696e
     760:	61625f72 	smcvs	9714	; 0x25f2
     764:	615f6573 	cmpvs	pc, r3, ror r5	; <UNPREDICTABLE>
     768:	00726464 	rsbseq	r6, r2, r4, ror #8
     76c:	384e5a5f 	stmdacc	lr, {r0, r1, r2, r3, r4, r6, r9, fp, ip, lr}^
     770:	6e6f4d43 	cdpvs	13, 6, cr4, cr15, cr3, {2}
     774:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
     778:	656c4335 	strbvs	r4, [ip, #-821]!	; 0xfffffccb
     77c:	76457261 	strbvc	r7, [r5], -r1, ror #4
     780:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     784:	6f4d4338 	svcvs	0x004d4338
     788:	6f74696e 	svcvs	0x0074696e
     78c:	45736c72 	ldrbmi	r6, [r3, #-3186]!	; 0xfffff38e
     790:	315f534e 	cmpcc	pc, lr, asr #6
     794:	754e4e32 	strbvc	r4, [lr, #-3634]	; 0xfffff1ce
     798:	7265626d 	rsbvc	r6, r5, #-805306362	; 0xd0000006
     79c:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
     7a0:	43004565 	movwmi	r4, #1381	; 0x565
     7a4:	696e6f4d 	stmdbvs	lr!, {r0, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     7a8:	00726f74 	rsbseq	r6, r2, r4, ror pc
     7ac:	384e5a5f 	stmdacc	lr, {r0, r1, r2, r3, r4, r6, r9, fp, ip, lr}^
     7b0:	6e6f4d43 	cdpvs	13, 6, cr4, cr15, cr3, {2}
     7b4:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
     7b8:	76694436 			; <UNDEFINED> instruction: 0x76694436
     7bc:	45656469 	strbmi	r6, [r5, #-1129]!	; 0xfffffb97
     7c0:	6f006a6a 	svcvs	0x00006a6a
     7c4:	61726570 	cmnvs	r2, r0, ror r5
     7c8:	3c726f74 	ldclcc	15, cr6, [r2], #-464	; 0xfffffe30
     7cc:	5a5f003c 	bpl	17c08c4 <_bss_end+0x17b766c>
     7d0:	4d43384e 	stclmi	8, cr3, [r3, #-312]	; 0xfffffec8
     7d4:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
     7d8:	736c726f 	cmnvc	ip, #-268435450	; 0xf0000006
     7dc:	634b5045 	movtvs	r5, #45125	; 0xb045
     7e0:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     7e4:	6f4d4338 	svcvs	0x004d4338
     7e8:	6f74696e 	svcvs	0x0074696e
     7ec:	74693472 	strbtvc	r3, [r9], #-1138	; 0xfffffb8e
     7f0:	6a45616f 	bvs	1158db4 <_bss_end+0x114fb5c>
     7f4:	006a6350 	rsbeq	r6, sl, r0, asr r3
     7f8:	65685f6d 	strbvs	r5, [r8, #-3949]!	; 0xfffff093
     7fc:	74686769 	strbtvc	r6, [r8], #-1897	; 0xfffff897
     800:	635f6d00 	cmpvs	pc, #0, 26
     804:	6f737275 	svcvs	0x00737275
     808:	68430072 	stmdavs	r3, {r1, r4, r5, r6}^
     80c:	6f437261 	svcvs	0x00437261
     810:	7241766e 	subvc	r7, r1, #115343360	; 0x6e00000
     814:	5a5f0072 	bpl	17c09e4 <_bss_end+0x17b778c>
     818:	4d43384e 	stclmi	8, cr3, [r3, #-312]	; 0xfffffec8
     81c:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
     820:	736c726f 	cmnvc	ip, #-268435450	; 0xf0000006
     824:	5f006245 	svcpl	0x00006245
     828:	43384e5a 	teqmi	r8, #1440	; 0x5a0
     82c:	696e6f4d 	stmdbvs	lr!, {r0, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     830:	6c726f74 	ldclvs	15, cr6, [r2], #-464	; 0xfffffe30
     834:	00634573 	rsbeq	r4, r3, r3, ror r5
     838:	69775f6d 	ldmdbvs	r7!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
     83c:	00687464 	rsbeq	r7, r8, r4, ror #8
     840:	384e5a5f 	stmdacc	lr, {r0, r1, r2, r3, r4, r6, r9, fp, ip, lr}^
     844:	6e6f4d43 	cdpvs	13, 6, cr4, cr15, cr3, {2}
     848:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
     84c:	72635336 	rsbvc	r5, r3, #-671088640	; 0xd8000000
     850:	456c6c6f 	strbmi	r6, [ip, #-3183]!	; 0xfffff391
     854:	682f0076 	stmdavs	pc!, {r1, r2, r4, r5, r6}	; <UNPREDICTABLE>
     858:	2f656d6f 	svccs	0x00656d6f
     85c:	686c6973 	stmdavs	ip!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
     860:	6a797661 	bvs	1e5e1ec <_bss_end+0x1e54f94>
     864:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
     868:	2f6c6f6f 	svccs	0x006c6f6f
     86c:	6f72655a 	svcvs	0x0072655a
     870:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
     874:	6178652f 	cmnvs	r8, pc, lsr #10
     878:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
     87c:	37302f73 			; <UNDEFINED> instruction: 0x37302f73
     880:	44454c2d 	strbmi	r4, [r5], #-3117	; 0xfffff3d3
     884:	676f745f 			; <UNDEFINED> instruction: 0x676f745f
     888:	5f656c67 	svcpl	0x00656c67
     88c:	75626564 	strbvc	r6, [r2, #-1380]!	; 0xfffffa9c
     890:	6f6d5f67 	svcvs	0x006d5f67
     894:	6f74696e 	svcvs	0x0074696e
     898:	656b2f72 	strbvs	r2, [fp, #-3954]!	; 0xfffff08e
     89c:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
     8a0:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
     8a4:	6972642f 	ldmdbvs	r2!, {r0, r1, r2, r3, r5, sl, sp, lr}^
     8a8:	73726576 	cmnvc	r2, #494927872	; 0x1d800000
     8ac:	6e6f6d2f 	cdpvs	13, 6, cr6, cr15, cr15, {1}
     8b0:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
     8b4:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
     8b8:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     8bc:	6f4d4338 	svcvs	0x004d4338
     8c0:	6f74696e 	svcvs	0x0074696e
     8c4:	45736c72 	ldrbmi	r6, [r3, #-3186]!	; 0xfffff38e
     8c8:	5a5f006a 	bpl	17c0a78 <_bss_end+0x17b7820>
     8cc:	4d43384e 	stclmi	8, cr3, [r3, #-312]	; 0xfffffec8
     8d0:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
     8d4:	3231726f 	eorscc	r7, r1, #-268435450	; 0xf0000006
     8d8:	65736552 	ldrbvs	r6, [r3, #-1362]!	; 0xfffffaae
     8dc:	75435f74 	strbvc	r5, [r3, #-3956]	; 0xfffff08c
     8e0:	726f7372 	rsbvc	r7, pc, #-939524095	; 0xc8000001
     8e4:	5f007645 	svcpl	0x00007645
     8e8:	43384e5a 	teqmi	r8, #1440	; 0x5a0
     8ec:	696e6f4d 	stmdbvs	lr!, {r0, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     8f0:	43726f74 	cmnmi	r2, #116, 30	; 0x1d0
     8f4:	6a6a4534 	bvs	1a91dcc <_bss_end+0x1a88b74>
     8f8:	4544006a 	strbmi	r0, [r4, #-106]	; 0xffffff96
     8fc:	4c554146 	ldfmie	f4, [r5], {70}	; 0x46
     900:	554e5f54 	strbpl	r5, [lr, #-3924]	; 0xfffff0ac
     904:	5245424d 	subpl	r4, r5, #-805306364	; 0xd0000004
     908:	5341425f 	movtpl	r4, #4703	; 0x125f
     90c:	756f0045 	strbvc	r0, [pc, #-69]!	; 8cf <_start-0x7731>
     910:	74757074 	ldrbtvc	r7, [r5], #-116	; 0xffffff8c
     914:	706e6900 	rsbvc	r6, lr, r0, lsl #18
     918:	73007475 	movwvc	r7, #1141	; 0x475
     91c:	6675625f 			; <UNDEFINED> instruction: 0x6675625f
     920:	00726566 	rsbseq	r6, r2, r6, ror #10
     924:	46465542 	strbmi	r5, [r6], -r2, asr #10
     928:	535f5245 	cmppl	pc, #1342177284	; 0x50000004
     92c:	00455a49 	subeq	r5, r5, r9, asr #20
     930:	616d6552 	cmnvs	sp, r2, asr r5
     934:	65646e69 	strbvs	r6, [r4, #-3689]!	; 0xfffff197
     938:	43410072 	movtmi	r0, #4210	; 0x1072
     93c:	69505f54 	ldmdbvs	r0, {r2, r4, r6, r8, r9, sl, fp, ip, lr}^
     940:	6b5f006e 	blvs	17c0b00 <_bss_end+0x17b78a8>
     944:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
     948:	616d5f6c 	cmnvs	sp, ip, ror #30
     94c:	2f006e69 	svccs	0x00006e69
     950:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     954:	6c69732f 	stclvs	3, cr7, [r9], #-188	; 0xffffff44
     958:	79766168 	ldmdbvc	r6!, {r3, r5, r6, r8, sp, lr}^
     95c:	63532f6a 	cmpvs	r3, #424	; 0x1a8
     960:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; 7c8 <_start-0x7838>
     964:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
     968:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
     96c:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
     970:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
     974:	302f7365 	eorcc	r7, pc, r5, ror #6
     978:	454c2d37 	strbmi	r2, [ip, #-3383]	; 0xfffff2c9
     97c:	6f745f44 	svcvs	0x00745f44
     980:	656c6767 	strbvs	r6, [ip, #-1895]!	; 0xfffff899
     984:	6265645f 	rsbvs	r6, r5, #1593835520	; 0x5f000000
     988:	6d5f6775 	ldclvs	7, cr6, [pc, #-468]	; 7bc <_start-0x7844>
     98c:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
     990:	6b2f726f 	blvs	bdd354 <_bss_end+0xbd40fc>
     994:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
     998:	72732f6c 	rsbsvc	r2, r3, #108, 30	; 0x1b0
     99c:	616d2f63 	cmnvs	sp, r3, ror #30
     9a0:	632e6e69 			; <UNDEFINED> instruction: 0x632e6e69
     9a4:	2f007070 	svccs	0x00007070
     9a8:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     9ac:	6c69732f 	stclvs	3, cr7, [r9], #-188	; 0xffffff44
     9b0:	79766168 	ldmdbvc	r6!, {r3, r5, r6, r8, sp, lr}^
     9b4:	63532f6a 	cmpvs	r3, #424	; 0x1a8
     9b8:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; 820 <_start-0x77e0>
     9bc:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
     9c0:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
     9c4:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
     9c8:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
     9cc:	302f7365 	eorcc	r7, pc, r5, ror #6
     9d0:	454c2d37 	strbmi	r2, [ip, #-3383]	; 0xfffff2c9
     9d4:	6f745f44 	svcvs	0x00745f44
     9d8:	656c6767 	strbvs	r6, [ip, #-1895]!	; 0xfffff899
     9dc:	6265645f 	rsbvs	r6, r5, #1593835520	; 0x5f000000
     9e0:	6d5f6775 	ldclvs	7, cr6, [pc, #-468]	; 814 <_start-0x77ec>
     9e4:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
     9e8:	6b2f726f 	blvs	bdd3ac <_bss_end+0xbd4154>
     9ec:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
     9f0:	72732f6c 	rsbsvc	r2, r3, #108, 30	; 0x1b0
     9f4:	74732f63 	ldrbtvc	r2, [r3], #-3939	; 0xfffff09d
     9f8:	2e747261 	cdpcs	2, 7, cr7, cr4, cr1, {3}
     9fc:	4e470073 	mcrmi	0, 2, r0, cr7, cr3, {3}
     a00:	53412055 	movtpl	r2, #4181	; 0x1055
     a04:	332e3220 			; <UNDEFINED> instruction: 0x332e3220
     a08:	74630034 	strbtvc	r0, [r3], #-52	; 0xffffffcc
     a0c:	705f726f 	subsvc	r7, pc, pc, ror #4
     a10:	2f007274 	svccs	0x00007274
     a14:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     a18:	6c69732f 	stclvs	3, cr7, [r9], #-188	; 0xffffff44
     a1c:	79766168 	ldmdbvc	r6!, {r3, r5, r6, r8, sp, lr}^
     a20:	63532f6a 	cmpvs	r3, #424	; 0x1a8
     a24:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; 88c <_start-0x7774>
     a28:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
     a2c:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
     a30:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
     a34:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
     a38:	302f7365 	eorcc	r7, pc, r5, ror #6
     a3c:	454c2d37 	strbmi	r2, [ip, #-3383]	; 0xfffff2c9
     a40:	6f745f44 	svcvs	0x00745f44
     a44:	656c6767 	strbvs	r6, [ip, #-1895]!	; 0xfffff899
     a48:	6265645f 	rsbvs	r6, r5, #1593835520	; 0x5f000000
     a4c:	6d5f6775 	ldclvs	7, cr6, [pc, #-468]	; 880 <_start-0x7780>
     a50:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
     a54:	6b2f726f 	blvs	bdd418 <_bss_end+0xbd41c0>
     a58:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
     a5c:	72732f6c 	rsbsvc	r2, r3, #108, 30	; 0x1b0
     a60:	74732f63 	ldrbtvc	r2, [r3], #-3939	; 0xfffff09d
     a64:	75747261 	ldrbvc	r7, [r4, #-609]!	; 0xfffffd9f
     a68:	70632e70 	rsbvc	r2, r3, r0, ror lr
     a6c:	625f0070 	subsvs	r0, pc, #112	; 0x70
     a70:	735f7373 	cmpvc	pc, #-872415231	; 0xcc000001
     a74:	74726174 	ldrbtvc	r6, [r2], #-372	; 0xfffffe8c
     a78:	435f5f00 	cmpmi	pc, #0, 30
     a7c:	5f524f54 	svcpl	0x00524f54
     a80:	5f444e45 	svcpl	0x00444e45
     a84:	5f5f005f 	svcpl	0x005f005f
     a88:	524f5443 	subpl	r5, pc, #1124073472	; 0x43000000
     a8c:	53494c5f 	movtpl	r4, #40031	; 0x9c5f
     a90:	005f5f54 	subseq	r5, pc, r4, asr pc	; <UNPREDICTABLE>
     a94:	54445f5f 	strbpl	r5, [r4], #-3935	; 0xfffff0a1
     a98:	455f524f 	ldrbmi	r5, [pc, #-591]	; 851 <_start-0x77af>
     a9c:	5f5f444e 	svcpl	0x005f444e
     aa0:	70635f00 	rsbvc	r5, r3, r0, lsl #30
     aa4:	68735f70 	ldmdavs	r3!, {r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     aa8:	6f647475 	svcvs	0x00647475
     aac:	5f006e77 	svcpl	0x00006e77
     ab0:	5f737362 	svcpl	0x00737362
     ab4:	00646e65 	rsbeq	r6, r4, r5, ror #28
     ab8:	54445f5f 	strbpl	r5, [r4], #-3935	; 0xfffff0a1
     abc:	4c5f524f 	lfmmi	f5, 2, [pc], {79}	; 0x4f
     ac0:	5f545349 	svcpl	0x00545349
     ac4:	7464005f 	strbtvc	r0, [r4], #-95	; 0xffffffa1
     ac8:	705f726f 	subsvc	r7, pc, pc, ror #4
     acc:	5f007274 	svcpl	0x00007274
     ad0:	74735f63 	ldrbtvc	r5, [r3], #-3939	; 0xfffff09d
     ad4:	75747261 	ldrbvc	r7, [r4, #-609]!	; 0xfffffd9f
     ad8:	635f0070 	cmpvs	pc, #112	; 0x70
     adc:	735f7070 	cmpvc	pc, #112	; 0x70
     ae0:	74726174 	ldrbtvc	r6, [r2], #-372	; 0xfffffe8c
     ae4:	66007075 			; <UNDEFINED> instruction: 0x66007075
     ae8:	7274706e 	rsbsvc	r7, r4, #110	; 0x6e
     aec:	52415400 	subpl	r5, r1, #0, 8
     af0:	5f544547 	svcpl	0x00544547
     af4:	5f555043 	svcpl	0x00555043
     af8:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
     afc:	31617865 	cmncc	r1, r5, ror #16
     b00:	726f6337 	rsbvc	r6, pc, #-603979776	; 0xdc000000
     b04:	61786574 	cmnvs	r8, r4, ror r5
     b08:	73690037 	cmnvc	r9, #55	; 0x37
     b0c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
     b10:	70665f74 	rsbvc	r5, r6, r4, ror pc
     b14:	6c62645f 	cfstrdvs	mvd6, [r2], #-380	; 0xfffffe84
     b18:	6d726100 	ldfvse	f6, [r2, #-0]
     b1c:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
     b20:	77695f68 	strbvc	r5, [r9, -r8, ror #30]!
     b24:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
     b28:	52415400 	subpl	r5, r1, #0, 8
     b2c:	5f544547 	svcpl	0x00544547
     b30:	5f555043 	svcpl	0x00555043
     b34:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
     b38:	326d7865 	rsbcc	r7, sp, #6619136	; 0x650000
     b3c:	52410033 	subpl	r0, r1, #51	; 0x33
     b40:	51455f4d 	cmppl	r5, sp, asr #30
     b44:	52415400 	subpl	r5, r1, #0, 8
     b48:	5f544547 	svcpl	0x00544547
     b4c:	5f555043 	svcpl	0x00555043
     b50:	316d7261 	cmncc	sp, r1, ror #4
     b54:	74363531 	ldrtvc	r3, [r6], #-1329	; 0xfffffacf
     b58:	00736632 	rsbseq	r6, r3, r2, lsr r6
     b5c:	5f617369 	svcpl	0x00617369
     b60:	5f746962 	svcpl	0x00746962
     b64:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
     b68:	41540062 	cmpmi	r4, r2, rrx
     b6c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
     b70:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
     b74:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
     b78:	61786574 	cmnvs	r8, r4, ror r5
     b7c:	6f633735 	svcvs	0x00633735
     b80:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
     b84:	00333561 	eorseq	r3, r3, r1, ror #10
     b88:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
     b8c:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
     b90:	4d385f48 	ldcmi	15, cr5, [r8, #-288]!	; 0xfffffee0
     b94:	5341425f 	movtpl	r4, #4703	; 0x125f
     b98:	41540045 	cmpmi	r4, r5, asr #32
     b9c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
     ba0:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
     ba4:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
     ba8:	00303138 	eorseq	r3, r0, r8, lsr r1
     bac:	47524154 			; <UNDEFINED> instruction: 0x47524154
     bb0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
     bb4:	785f5550 	ldmdavc	pc, {r4, r6, r8, sl, ip, lr}^	; <UNPREDICTABLE>
     bb8:	656e6567 	strbvs	r6, [lr, #-1383]!	; 0xfffffa99
     bbc:	52410031 	subpl	r0, r1, #49	; 0x31
     bc0:	43505f4d 	cmpmi	r0, #308	; 0x134
     bc4:	41415f53 	cmpmi	r1, r3, asr pc
     bc8:	5f534350 	svcpl	0x00534350
     bcc:	4d4d5749 	stclmi	7, cr5, [sp, #-292]	; 0xfffffedc
     bd0:	42005458 	andmi	r5, r0, #88, 8	; 0x58000000
     bd4:	5f455341 	svcpl	0x00455341
     bd8:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
     bdc:	4200305f 	andmi	r3, r0, #95	; 0x5f
     be0:	5f455341 	svcpl	0x00455341
     be4:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
     be8:	4200325f 	andmi	r3, r0, #-268435451	; 0xf0000005
     bec:	5f455341 	svcpl	0x00455341
     bf0:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
     bf4:	4200335f 	andmi	r3, r0, #2080374785	; 0x7c000001
     bf8:	5f455341 	svcpl	0x00455341
     bfc:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
     c00:	4200345f 	andmi	r3, r0, #1593835520	; 0x5f000000
     c04:	5f455341 	svcpl	0x00455341
     c08:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
     c0c:	4200365f 	andmi	r3, r0, #99614720	; 0x5f00000
     c10:	5f455341 	svcpl	0x00455341
     c14:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
     c18:	5400375f 	strpl	r3, [r0], #-1887	; 0xfffff8a1
     c1c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
     c20:	50435f54 	subpl	r5, r3, r4, asr pc
     c24:	73785f55 	cmnvc	r8, #340	; 0x154
     c28:	656c6163 	strbvs	r6, [ip, #-355]!	; 0xfffffe9d
     c2c:	61736900 	cmnvs	r3, r0, lsl #18
     c30:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
     c34:	6572705f 	ldrbvs	r7, [r2, #-95]!	; 0xffffffa1
     c38:	73657264 	cmnvc	r5, #100, 4	; 0x40000006
     c3c:	52415400 	subpl	r5, r1, #0, 8
     c40:	5f544547 	svcpl	0x00544547
     c44:	5f555043 	svcpl	0x00555043
     c48:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
     c4c:	336d7865 	cmncc	sp, #6619136	; 0x650000
     c50:	41540033 	cmpmi	r4, r3, lsr r0
     c54:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
     c58:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
     c5c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
     c60:	6d647437 	cfstrdvs	mvd7, [r4, #-220]!	; 0xffffff24
     c64:	73690069 	cmnvc	r9, #105	; 0x69
     c68:	6f6e5f61 	svcvs	0x006e5f61
     c6c:	00746962 	rsbseq	r6, r4, r2, ror #18
     c70:	47524154 			; <UNDEFINED> instruction: 0x47524154
     c74:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
     c78:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
     c7c:	31316d72 	teqcc	r1, r2, ror sp
     c80:	7a6a3637 	bvc	1a8e564 <_bss_end+0x1a8530c>
     c84:	69007366 	stmdbvs	r0, {r1, r2, r5, r6, r8, r9, ip, sp, lr}
     c88:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
     c8c:	765f7469 	ldrbvc	r7, [pc], -r9, ror #8
     c90:	32767066 	rsbscc	r7, r6, #102	; 0x66
     c94:	4d524100 	ldfmie	f4, [r2, #-0]
     c98:	5343505f 	movtpl	r5, #12383	; 0x305f
     c9c:	4b4e555f 	blmi	1396220 <_bss_end+0x138cfc8>
     ca0:	4e574f4e 	cdpmi	15, 5, cr4, cr7, cr14, {2}
     ca4:	52415400 	subpl	r5, r1, #0, 8
     ca8:	5f544547 	svcpl	0x00544547
     cac:	5f555043 	svcpl	0x00555043
     cb0:	396d7261 	stmdbcc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
     cb4:	41420065 	cmpmi	r2, r5, rrx
     cb8:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
     cbc:	5f484352 	svcpl	0x00484352
     cc0:	4a455435 	bmi	1155d9c <_bss_end+0x114cb44>
     cc4:	6d726100 	ldfvse	f6, [r2, #-0]
     cc8:	6663635f 			; <UNDEFINED> instruction: 0x6663635f
     ccc:	735f6d73 	cmpvc	pc, #7360	; 0x1cc0
     cd0:	65746174 	ldrbvs	r6, [r4, #-372]!	; 0xfffffe8c
     cd4:	6d726100 	ldfvse	f6, [r2, #-0]
     cd8:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
     cdc:	65743568 	ldrbvs	r3, [r4, #-1384]!	; 0xfffffa98
     ce0:	736e7500 	cmnvc	lr, #0, 10
     ce4:	5f636570 	svcpl	0x00636570
     ce8:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
     cec:	0073676e 	rsbseq	r6, r3, lr, ror #14
     cf0:	5f617369 	svcpl	0x00617369
     cf4:	5f746962 	svcpl	0x00746962
     cf8:	00636573 	rsbeq	r6, r3, r3, ror r5
     cfc:	6c635f5f 	stclvs	15, cr5, [r3], #-380	; 0xfffffe84
     d00:	61745f7a 	cmnvs	r4, sl, ror pc
     d04:	52410062 	subpl	r0, r1, #98	; 0x62
     d08:	43565f4d 	cmpmi	r6, #308	; 0x134
     d0c:	6d726100 	ldfvse	f6, [r2, #-0]
     d10:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
     d14:	73785f68 	cmnvc	r8, #104, 30	; 0x1a0
     d18:	656c6163 	strbvs	r6, [ip, #-355]!	; 0xfffffe9d
     d1c:	4d524100 	ldfmie	f4, [r2, #-0]
     d20:	00454c5f 	subeq	r4, r5, pc, asr ip
     d24:	5f4d5241 	svcpl	0x004d5241
     d28:	41005356 	tstmi	r0, r6, asr r3
     d2c:	475f4d52 			; <UNDEFINED> instruction: 0x475f4d52
     d30:	72610045 	rsbvc	r0, r1, #69	; 0x45
     d34:	75745f6d 	ldrbvc	r5, [r4, #-3949]!	; 0xfffff093
     d38:	735f656e 	cmpvc	pc, #461373440	; 0x1b800000
     d3c:	6e6f7274 	mcrvs	2, 3, r7, cr15, cr4, {3}
     d40:	6d726167 	ldfvse	f6, [r2, #-412]!	; 0xfffffe64
     d44:	6d6f6300 	stclvs	3, cr6, [pc, #-0]	; d4c <_start-0x72b4>
     d48:	78656c70 	stmdavc	r5!, {r4, r5, r6, sl, fp, sp, lr}^
     d4c:	6f6c6620 	svcvs	0x006c6620
     d50:	54007461 	strpl	r7, [r0], #-1121	; 0xfffffb9f
     d54:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
     d58:	50435f54 	subpl	r5, r3, r4, asr pc
     d5c:	6f635f55 	svcvs	0x00635f55
     d60:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
     d64:	00353161 	eorseq	r3, r5, r1, ror #2
     d68:	47524154 			; <UNDEFINED> instruction: 0x47524154
     d6c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
     d70:	665f5550 			; <UNDEFINED> instruction: 0x665f5550
     d74:	36323761 	ldrtcc	r3, [r2], -r1, ror #14
     d78:	54006574 	strpl	r6, [r0], #-1396	; 0xfffffa8c
     d7c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
     d80:	50435f54 	subpl	r5, r3, r4, asr pc
     d84:	6f635f55 	svcvs	0x00635f55
     d88:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
     d8c:	00373161 	eorseq	r3, r7, r1, ror #2
     d90:	5f4d5241 	svcpl	0x004d5241
     d94:	54005447 	strpl	r5, [r0], #-1095	; 0xfffffbb9
     d98:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
     d9c:	50435f54 	subpl	r5, r3, r4, asr pc
     da0:	656e5f55 	strbvs	r5, [lr, #-3925]!	; 0xfffff0ab
     da4:	7265766f 	rsbvc	r7, r5, #116391936	; 0x6f00000
     da8:	316e6573 	smccc	58963	; 0xe653
     dac:	2f2e2e00 	svccs	0x002e2e00
     db0:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     db4:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     db8:	2f2e2e2f 	svccs	0x002e2e2f
     dbc:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; d0c <_start-0x72f4>
     dc0:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
     dc4:	696c2f63 	stmdbvs	ip!, {r0, r1, r5, r6, r8, r9, sl, fp, sp}^
     dc8:	63636762 	cmnvs	r3, #25690112	; 0x1880000
     dcc:	00632e32 	rsbeq	r2, r3, r2, lsr lr
     dd0:	47524154 			; <UNDEFINED> instruction: 0x47524154
     dd4:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
     dd8:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
     ddc:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
     de0:	66347278 			; <UNDEFINED> instruction: 0x66347278
     de4:	53414200 	movtpl	r4, #4608	; 0x1200
     de8:	52415f45 	subpl	r5, r1, #276	; 0x114
     dec:	375f4843 	ldrbcc	r4, [pc, -r3, asr #16]
     df0:	54004d45 	strpl	r4, [r0], #-3397	; 0xfffff2bb
     df4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
     df8:	50435f54 	subpl	r5, r3, r4, asr pc
     dfc:	6f635f55 	svcvs	0x00635f55
     e00:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
     e04:	00323161 	eorseq	r3, r2, r1, ror #2
     e08:	68736168 	ldmdavs	r3!, {r3, r5, r6, r8, sp, lr}^
     e0c:	5f6c6176 	svcpl	0x006c6176
     e10:	41420074 	hvcmi	8196	; 0x2004
     e14:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
     e18:	5f484352 	svcpl	0x00484352
     e1c:	005a4b36 	subseq	r4, sl, r6, lsr fp
     e20:	5f617369 	svcpl	0x00617369
     e24:	73746962 	cmnvc	r4, #1605632	; 0x188000
     e28:	6d726100 	ldfvse	f6, [r2, #-0]
     e2c:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
     e30:	72615f68 	rsbvc	r5, r1, #104, 30	; 0x1a0
     e34:	77685f6d 	strbvc	r5, [r8, -sp, ror #30]!
     e38:	00766964 	rsbseq	r6, r6, r4, ror #18
     e3c:	5f6d7261 	svcpl	0x006d7261
     e40:	5f757066 	svcpl	0x00757066
     e44:	63736564 	cmnvs	r3, #100, 10	; 0x19000000
     e48:	61736900 	cmnvs	r3, r0, lsl #18
     e4c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
     e50:	3170665f 	cmncc	r0, pc, asr r6
     e54:	4e470036 	mcrmi	0, 2, r0, cr7, cr6, {1}
     e58:	31432055 	qdaddcc	r2, r5, r3
     e5c:	2e392037 	mrccs	0, 1, r2, cr9, cr7, {1}
     e60:	20312e32 	eorscs	r2, r1, r2, lsr lr
     e64:	39313032 	ldmdbcc	r1!, {r1, r4, r5, ip, sp}
     e68:	35323031 	ldrcc	r3, [r2, #-49]!	; 0xffffffcf
     e6c:	65722820 	ldrbvs	r2, [r2, #-2080]!	; 0xfffff7e0
     e70:	7361656c 	cmnvc	r1, #108, 10	; 0x1b000000
     e74:	5b202965 	blpl	80b410 <_bss_end+0x8021b8>
     e78:	2f4d5241 	svccs	0x004d5241
     e7c:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
     e80:	72622d39 	rsbvc	r2, r2, #3648	; 0xe40
     e84:	68636e61 	stmdavs	r3!, {r0, r5, r6, r9, sl, fp, sp, lr}^
     e88:	76657220 	strbtvc	r7, [r5], -r0, lsr #4
     e8c:	6f697369 	svcvs	0x00697369
     e90:	3732206e 	ldrcc	r2, [r2, -lr, rrx]!
     e94:	39393537 	ldmdbcc	r9!, {r0, r1, r2, r4, r5, r8, sl, ip, sp}
     e98:	6d2d205d 	stcvs	0, cr2, [sp, #-372]!	; 0xfffffe8c
     e9c:	206d7261 	rsbcs	r7, sp, r1, ror #4
     ea0:	6c666d2d 	stclvs	13, cr6, [r6], #-180	; 0xffffff4c
     ea4:	2d74616f 	ldfcse	f6, [r4, #-444]!	; 0xfffffe44
     ea8:	3d696261 	sfmcc	f6, 2, [r9, #-388]!	; 0xfffffe7c
     eac:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
     eb0:	616d2d20 	cmnvs	sp, r0, lsr #26
     eb4:	3d686372 	stclcc	3, cr6, [r8, #-456]!	; 0xfffffe38
     eb8:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
     ebc:	2b657435 	blcs	195df98 <_bss_end+0x1954d40>
     ec0:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
     ec4:	672d2067 	strvs	r2, [sp, -r7, rrx]!
     ec8:	20672d20 	rsbcs	r2, r7, r0, lsr #26
     ecc:	20324f2d 	eorscs	r4, r2, sp, lsr #30
     ed0:	20324f2d 	eorscs	r4, r2, sp, lsr #30
     ed4:	20324f2d 	eorscs	r4, r2, sp, lsr #30
     ed8:	7562662d 	strbvc	r6, [r2, #-1581]!	; 0xfffff9d3
     edc:	69646c69 	stmdbvs	r4!, {r0, r3, r5, r6, sl, fp, sp, lr}^
     ee0:	6c2d676e 	stcvs	7, cr6, [sp], #-440	; 0xfffffe48
     ee4:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
     ee8:	662d2063 	strtvs	r2, [sp], -r3, rrx
     eec:	732d6f6e 			; <UNDEFINED> instruction: 0x732d6f6e
     ef0:	6b636174 	blvs	18d94c8 <_bss_end+0x18d0270>
     ef4:	6f72702d 	svcvs	0x0072702d
     ef8:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
     efc:	2d20726f 	sfmcs	f7, 4, [r0, #-444]!	; 0xfffffe44
     f00:	2d6f6e66 	stclcs	14, cr6, [pc, #-408]!	; d70 <_start-0x7290>
     f04:	696c6e69 	stmdbvs	ip!, {r0, r3, r5, r6, r9, sl, fp, sp, lr}^
     f08:	2d20656e 	cfstr32cs	mvfx6, [r0, #-440]!	; 0xfffffe48
     f0c:	73697666 	cmnvc	r9, #106954752	; 0x6600000
     f10:	6c696269 	sfmvs	f6, 2, [r9], #-420	; 0xfffffe5c
     f14:	3d797469 	cfldrdcc	mvd7, [r9, #-420]!	; 0xfffffe5c
     f18:	64646968 	strbtvs	r6, [r4], #-2408	; 0xfffff698
     f1c:	41006e65 	tstmi	r0, r5, ror #28
     f20:	485f4d52 	ldmdami	pc, {r1, r4, r6, r8, sl, fp, lr}^	; <UNPREDICTABLE>
     f24:	73690049 	cmnvc	r9, #73	; 0x49
     f28:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
     f2c:	64615f74 	strbtvs	r5, [r1], #-3956	; 0xfffff08c
     f30:	54007669 	strpl	r7, [r0], #-1641	; 0xfffff997
     f34:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
     f38:	50435f54 	subpl	r5, r3, r4, asr pc
     f3c:	72615f55 	rsbvc	r5, r1, #340	; 0x154
     f40:	3331316d 	teqcc	r1, #1073741851	; 0x4000001b
     f44:	00736a36 	rsbseq	r6, r3, r6, lsr sl
     f48:	47524154 			; <UNDEFINED> instruction: 0x47524154
     f4c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
     f50:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
     f54:	00386d72 	eorseq	r6, r8, r2, ror sp
     f58:	47524154 			; <UNDEFINED> instruction: 0x47524154
     f5c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
     f60:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
     f64:	00396d72 	eorseq	r6, r9, r2, ror sp
     f68:	47524154 			; <UNDEFINED> instruction: 0x47524154
     f6c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
     f70:	665f5550 			; <UNDEFINED> instruction: 0x665f5550
     f74:	36323661 	ldrtcc	r3, [r2], -r1, ror #12
     f78:	6e6f6c00 	cdpvs	12, 6, cr6, cr15, cr0, {0}
     f7c:	6f6c2067 	svcvs	0x006c2067
     f80:	7520676e 	strvc	r6, [r0, #-1902]!	; 0xfffff892
     f84:	6769736e 	strbvs	r7, [r9, -lr, ror #6]!
     f88:	2064656e 	rsbcs	r6, r4, lr, ror #10
     f8c:	00746e69 	rsbseq	r6, r4, r9, ror #28
     f90:	5f6d7261 	svcpl	0x006d7261
     f94:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
     f98:	736d635f 	cmnvc	sp, #2080374785	; 0x7c000001
     f9c:	41540065 	cmpmi	r4, r5, rrx
     fa0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
     fa4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
     fa8:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
     fac:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
     fb0:	41540034 	cmpmi	r4, r4, lsr r0
     fb4:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
     fb8:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
     fbc:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
     fc0:	00653031 	rsbeq	r3, r5, r1, lsr r0
     fc4:	47524154 			; <UNDEFINED> instruction: 0x47524154
     fc8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
     fcc:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
     fd0:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
     fd4:	00376d78 	eorseq	r6, r7, r8, ror sp
     fd8:	5f6d7261 	svcpl	0x006d7261
     fdc:	646e6f63 	strbtvs	r6, [lr], #-3939	; 0xfffff09d
     fe0:	646f635f 	strbtvs	r6, [pc], #-863	; fe8 <_start-0x7018>
     fe4:	52410065 	subpl	r0, r1, #101	; 0x65
     fe8:	43505f4d 	cmpmi	r0, #308	; 0x134
     fec:	41415f53 	cmpmi	r1, r3, asr pc
     ff0:	00534350 	subseq	r4, r3, r0, asr r3
     ff4:	5f617369 	svcpl	0x00617369
     ff8:	5f746962 	svcpl	0x00746962
     ffc:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1000:	00325f38 	eorseq	r5, r2, r8, lsr pc
    1004:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1008:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    100c:	4d335f48 	ldcmi	15, cr5, [r3, #-288]!	; 0xfffffee0
    1010:	52415400 	subpl	r5, r1, #0, 8
    1014:	5f544547 	svcpl	0x00544547
    1018:	5f555043 	svcpl	0x00555043
    101c:	376d7261 	strbcc	r7, [sp, -r1, ror #4]!
    1020:	00743031 	rsbseq	r3, r4, r1, lsr r0
    1024:	5f6d7261 	svcpl	0x006d7261
    1028:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    102c:	6d77695f 			; <UNDEFINED> instruction: 0x6d77695f
    1030:	3274786d 	rsbscc	r7, r4, #7143424	; 0x6d0000
    1034:	61736900 	cmnvs	r3, r0, lsl #18
    1038:	6d756e5f 	ldclvs	14, cr6, [r5, #-380]!	; 0xfffffe84
    103c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1040:	41540073 	cmpmi	r4, r3, ror r0
    1044:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1048:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    104c:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1050:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    1054:	756c7030 	strbvc	r7, [ip, #-48]!	; 0xffffffd0
    1058:	616d7373 	smcvs	55091	; 0xd733
    105c:	756d6c6c 	strbvc	r6, [sp, #-3180]!	; 0xfffff394
    1060:	7069746c 	rsbvc	r7, r9, ip, ror #8
    1064:	5400796c 	strpl	r7, [r0], #-2412	; 0xfffff694
    1068:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    106c:	50435f54 	subpl	r5, r3, r4, asr pc
    1070:	78655f55 	stmdavc	r5!, {r0, r2, r4, r6, r8, r9, sl, fp, ip, lr}^
    1074:	736f6e79 	cmnvc	pc, #1936	; 0x790
    1078:	5400316d 	strpl	r3, [r0], #-365	; 0xfffffe93
    107c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1080:	50435f54 	subpl	r5, r3, r4, asr pc
    1084:	6f635f55 	svcvs	0x00635f55
    1088:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    108c:	00323572 	eorseq	r3, r2, r2, ror r5
    1090:	5f617369 	svcpl	0x00617369
    1094:	5f746962 	svcpl	0x00746962
    1098:	76696474 			; <UNDEFINED> instruction: 0x76696474
    109c:	65727000 	ldrbvs	r7, [r2, #-0]!
    10a0:	5f726566 	svcpl	0x00726566
    10a4:	6e6f656e 	cdpvs	5, 6, cr6, cr15, cr14, {3}
    10a8:	726f665f 	rsbvc	r6, pc, #99614720	; 0x5f00000
    10ac:	6234365f 	eorsvs	r3, r4, #99614720	; 0x5f00000
    10b0:	00737469 	rsbseq	r7, r3, r9, ror #8
    10b4:	5f617369 	svcpl	0x00617369
    10b8:	5f746962 	svcpl	0x00746962
    10bc:	36317066 	ldrtcc	r7, [r1], -r6, rrx
    10c0:	006c6d66 	rsbeq	r6, ip, r6, ror #26
    10c4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    10c8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    10cc:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    10d0:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    10d4:	32336178 	eorscc	r6, r3, #120, 2
    10d8:	52415400 	subpl	r5, r1, #0, 8
    10dc:	5f544547 	svcpl	0x00544547
    10e0:	5f555043 	svcpl	0x00555043
    10e4:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    10e8:	33617865 	cmncc	r1, #6619136	; 0x650000
    10ec:	73690035 	cmnvc	r9, #53	; 0x35
    10f0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    10f4:	70665f74 	rsbvc	r5, r6, r4, ror pc
    10f8:	6f633631 	svcvs	0x00633631
    10fc:	7500766e 	strvc	r7, [r0, #-1646]	; 0xfffff992
    1100:	6570736e 	ldrbvs	r7, [r0, #-878]!	; 0xfffffc92
    1104:	735f7663 	cmpvc	pc, #103809024	; 0x6300000
    1108:	6e697274 	mcrvs	2, 3, r7, cr9, cr4, {3}
    110c:	54007367 	strpl	r7, [r0], #-871	; 0xfffffc99
    1110:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1114:	50435f54 	subpl	r5, r3, r4, asr pc
    1118:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    111c:	3531316d 	ldrcc	r3, [r1, #-365]!	; 0xfffffe93
    1120:	73327436 	teqvc	r2, #905969664	; 0x36000000
    1124:	52415400 	subpl	r5, r1, #0, 8
    1128:	5f544547 	svcpl	0x00544547
    112c:	5f555043 	svcpl	0x00555043
    1130:	30366166 	eorscc	r6, r6, r6, ror #2
    1134:	00657436 	rsbeq	r7, r5, r6, lsr r4
    1138:	47524154 			; <UNDEFINED> instruction: 0x47524154
    113c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1140:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1144:	32396d72 	eorscc	r6, r9, #7296	; 0x1c80
    1148:	736a6536 	cmnvc	sl, #226492416	; 0xd800000
    114c:	53414200 	movtpl	r4, #4608	; 0x1200
    1150:	52415f45 	subpl	r5, r1, #276	; 0x114
    1154:	345f4843 	ldrbcc	r4, [pc], #-2115	; 115c <_start-0x6ea4>
    1158:	73690054 	cmnvc	r9, #84	; 0x54
    115c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1160:	72635f74 	rsbvc	r5, r3, #116, 30	; 0x1d0
    1164:	6f747079 	svcvs	0x00747079
    1168:	6d726100 	ldfvse	f6, [r2, #-0]
    116c:	6765725f 			; <UNDEFINED> instruction: 0x6765725f
    1170:	6e695f73 	mcrvs	15, 3, r5, cr9, cr3, {3}
    1174:	7165735f 	cmnvc	r5, pc, asr r3
    1178:	636e6575 	cmnvs	lr, #490733568	; 0x1d400000
    117c:	73690065 	cmnvc	r9, #101	; 0x65
    1180:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1184:	62735f74 	rsbsvs	r5, r3, #116, 30	; 0x1d0
    1188:	53414200 	movtpl	r4, #4608	; 0x1200
    118c:	52415f45 	subpl	r5, r1, #276	; 0x114
    1190:	355f4843 	ldrbcc	r4, [pc, #-2115]	; 955 <_start-0x76ab>
    1194:	69004554 	stmdbvs	r0, {r2, r4, r6, r8, sl, lr}
    1198:	665f6173 			; <UNDEFINED> instruction: 0x665f6173
    119c:	75746165 	ldrbvc	r6, [r4, #-357]!	; 0xfffffe9b
    11a0:	69006572 	stmdbvs	r0, {r1, r4, r5, r6, r8, sl, sp, lr}
    11a4:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    11a8:	735f7469 	cmpvc	pc, #1761607680	; 0x69000000
    11ac:	6c6c616d 	stfvse	f6, [ip], #-436	; 0xfffffe4c
    11b0:	006c756d 	rsbeq	r7, ip, sp, ror #10
    11b4:	5f6d7261 	svcpl	0x006d7261
    11b8:	676e616c 	strbvs	r6, [lr, -ip, ror #2]!
    11bc:	74756f5f 	ldrbtvc	r6, [r5], #-3935	; 0xfffff0a1
    11c0:	5f747570 	svcpl	0x00747570
    11c4:	656a626f 	strbvs	r6, [sl, #-623]!	; 0xfffffd91
    11c8:	615f7463 	cmpvs	pc, r3, ror #8
    11cc:	69727474 	ldmdbvs	r2!, {r2, r4, r5, r6, sl, ip, sp, lr}^
    11d0:	65747562 	ldrbvs	r7, [r4, #-1378]!	; 0xfffffa9e
    11d4:	6f685f73 	svcvs	0x00685f73
    11d8:	69006b6f 	stmdbvs	r0, {r0, r1, r2, r3, r5, r6, r8, r9, fp, sp, lr}
    11dc:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    11e0:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    11e4:	33645f70 	cmncc	r4, #112, 30	; 0x1c0
    11e8:	52410032 	subpl	r0, r1, #50	; 0x32
    11ec:	454e5f4d 	strbmi	r5, [lr, #-3917]	; 0xfffff0b3
    11f0:	61736900 	cmnvs	r3, r0, lsl #18
    11f4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    11f8:	3865625f 	stmdacc	r5!, {r0, r1, r2, r3, r4, r6, r9, sp, lr}^
    11fc:	52415400 	subpl	r5, r1, #0, 8
    1200:	5f544547 	svcpl	0x00544547
    1204:	5f555043 	svcpl	0x00555043
    1208:	316d7261 	cmncc	sp, r1, ror #4
    120c:	6a363731 	bvs	d8eed8 <_bss_end+0xd85c80>
    1210:	7000737a 	andvc	r7, r0, sl, ror r3
    1214:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    1218:	726f7373 	rsbvc	r7, pc, #-872415231	; 0xcc000001
    121c:	7079745f 	rsbsvc	r7, r9, pc, asr r4
    1220:	6c610065 	stclvs	0, cr0, [r1], #-404	; 0xfffffe6c
    1224:	70665f6c 	rsbvc	r5, r6, ip, ror #30
    1228:	61007375 	tstvs	r0, r5, ror r3
    122c:	705f6d72 	subsvc	r6, pc, r2, ror sp	; <UNPREDICTABLE>
    1230:	42007363 	andmi	r7, r0, #-1946157055	; 0x8c000001
    1234:	5f455341 	svcpl	0x00455341
    1238:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    123c:	0054355f 	subseq	r3, r4, pc, asr r5
    1240:	5f6d7261 	svcpl	0x006d7261
    1244:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1248:	54007434 	strpl	r7, [r0], #-1076	; 0xfffffbcc
    124c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1250:	50435f54 	subpl	r5, r3, r4, asr pc
    1254:	6f635f55 	svcvs	0x00635f55
    1258:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    125c:	63363761 	teqvs	r6, #25427968	; 0x1840000
    1260:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1264:	35356178 	ldrcc	r6, [r5, #-376]!	; 0xfffffe88
    1268:	6d726100 	ldfvse	f6, [r2, #-0]
    126c:	6e75745f 	mrcvs	4, 3, r7, cr5, cr15, {2}
    1270:	62775f65 	rsbsvs	r5, r7, #404	; 0x194
    1274:	68006675 	stmdavs	r0, {r0, r2, r4, r5, r6, r9, sl, sp, lr}
    1278:	5f626174 	svcpl	0x00626174
    127c:	68736168 	ldmdavs	r3!, {r3, r5, r6, r8, sp, lr}^
    1280:	61736900 	cmnvs	r3, r0, lsl #18
    1284:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1288:	6975715f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, r8, ip, sp, lr}^
    128c:	6e5f6b72 	vmovvs.s8	r6, d15[3]
    1290:	6f765f6f 	svcvs	0x00765f6f
    1294:	6974616c 	ldmdbvs	r4!, {r2, r3, r5, r6, r8, sp, lr}^
    1298:	635f656c 	cmpvs	pc, #108, 10	; 0x1b000000
    129c:	41540065 	cmpmi	r4, r5, rrx
    12a0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    12a4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    12a8:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    12ac:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    12b0:	41540030 	cmpmi	r4, r0, lsr r0
    12b4:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    12b8:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    12bc:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    12c0:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    12c4:	41540031 	cmpmi	r4, r1, lsr r0
    12c8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    12cc:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    12d0:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    12d4:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    12d8:	73690033 	cmnvc	r9, #51	; 0x33
    12dc:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    12e0:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    12e4:	5f38766d 	svcpl	0x0038766d
    12e8:	72610031 	rsbvc	r0, r1, #49	; 0x31
    12ec:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    12f0:	6e5f6863 	cdpvs	8, 5, cr6, cr15, cr3, {3}
    12f4:	00656d61 	rsbeq	r6, r5, r1, ror #26
    12f8:	5f617369 	svcpl	0x00617369
    12fc:	5f746962 	svcpl	0x00746962
    1300:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1304:	00335f38 	eorseq	r5, r3, r8, lsr pc
    1308:	5f617369 	svcpl	0x00617369
    130c:	5f746962 	svcpl	0x00746962
    1310:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1314:	00345f38 	eorseq	r5, r4, r8, lsr pc
    1318:	5f617369 	svcpl	0x00617369
    131c:	5f746962 	svcpl	0x00746962
    1320:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1324:	00355f38 	eorseq	r5, r5, r8, lsr pc
    1328:	47524154 			; <UNDEFINED> instruction: 0x47524154
    132c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1330:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1334:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1338:	33356178 	teqcc	r5, #120, 2
    133c:	52415400 	subpl	r5, r1, #0, 8
    1340:	5f544547 	svcpl	0x00544547
    1344:	5f555043 	svcpl	0x00555043
    1348:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    134c:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    1350:	41540035 	cmpmi	r4, r5, lsr r0
    1354:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1358:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    135c:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1360:	61786574 	cmnvs	r8, r4, ror r5
    1364:	54003735 	strpl	r3, [r0], #-1845	; 0xfffff8cb
    1368:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    136c:	50435f54 	subpl	r5, r3, r4, asr pc
    1370:	706d5f55 	rsbvc	r5, sp, r5, asr pc
    1374:	65726f63 	ldrbvs	r6, [r2, #-3939]!	; 0xfffff09d
    1378:	52415400 	subpl	r5, r1, #0, 8
    137c:	5f544547 	svcpl	0x00544547
    1380:	5f555043 	svcpl	0x00555043
    1384:	5f6d7261 	svcpl	0x006d7261
    1388:	656e6f6e 	strbvs	r6, [lr, #-3950]!	; 0xfffff092
    138c:	6d726100 	ldfvse	f6, [r2, #-0]
    1390:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1394:	6f6e5f68 	svcvs	0x006e5f68
    1398:	54006d74 	strpl	r6, [r0], #-3444	; 0xfffff28c
    139c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    13a0:	50435f54 	subpl	r5, r3, r4, asr pc
    13a4:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    13a8:	3230316d 	eorscc	r3, r0, #1073741851	; 0x4000001b
    13ac:	736a6536 	cmnvc	sl, #226492416	; 0xd800000
    13b0:	53414200 	movtpl	r4, #4608	; 0x1200
    13b4:	52415f45 	subpl	r5, r1, #276	; 0x114
    13b8:	365f4843 	ldrbcc	r4, [pc], -r3, asr #16
    13bc:	4142004a 	cmpmi	r2, sl, asr #32
    13c0:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    13c4:	5f484352 	svcpl	0x00484352
    13c8:	42004b36 	andmi	r4, r0, #55296	; 0xd800
    13cc:	5f455341 	svcpl	0x00455341
    13d0:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    13d4:	004d365f 	subeq	r3, sp, pc, asr r6
    13d8:	5f617369 	svcpl	0x00617369
    13dc:	5f746962 	svcpl	0x00746962
    13e0:	6d6d7769 	stclvs	7, cr7, [sp, #-420]!	; 0xfffffe5c
    13e4:	54007478 	strpl	r7, [r0], #-1144	; 0xfffffb88
    13e8:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    13ec:	50435f54 	subpl	r5, r3, r4, asr pc
    13f0:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    13f4:	3331316d 	teqcc	r1, #1073741851	; 0x4000001b
    13f8:	73666a36 	cmnvc	r6, #221184	; 0x36000
    13fc:	4d524100 	ldfmie	f4, [r2, #-0]
    1400:	00534c5f 	subseq	r4, r3, pc, asr ip
    1404:	5f4d5241 	svcpl	0x004d5241
    1408:	4200544c 	andmi	r5, r0, #76, 8	; 0x4c000000
    140c:	5f455341 	svcpl	0x00455341
    1410:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1414:	005a365f 	subseq	r3, sl, pc, asr r6
    1418:	47524154 			; <UNDEFINED> instruction: 0x47524154
    141c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1420:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1424:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1428:	35376178 	ldrcc	r6, [r7, #-376]!	; 0xfffffe88
    142c:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1430:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    1434:	52410035 	subpl	r0, r1, #53	; 0x35
    1438:	43505f4d 	cmpmi	r0, #308	; 0x134
    143c:	41415f53 	cmpmi	r1, r3, asr pc
    1440:	5f534350 	svcpl	0x00534350
    1444:	00504656 	subseq	r4, r0, r6, asr r6
    1448:	47524154 			; <UNDEFINED> instruction: 0x47524154
    144c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1450:	695f5550 	ldmdbvs	pc, {r4, r6, r8, sl, ip, lr}^	; <UNPREDICTABLE>
    1454:	786d6d77 	stmdavc	sp!, {r0, r1, r2, r4, r5, r6, r8, sl, fp, sp, lr}^
    1458:	69003274 	stmdbvs	r0, {r2, r4, r5, r6, r9, ip, sp}
    145c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1460:	6e5f7469 	cdpvs	4, 5, cr7, cr15, cr9, {3}
    1464:	006e6f65 	rsbeq	r6, lr, r5, ror #30
    1468:	5f6d7261 	svcpl	0x006d7261
    146c:	5f757066 	svcpl	0x00757066
    1470:	72747461 	rsbsvc	r7, r4, #1627389952	; 0x61000000
    1474:	61736900 	cmnvs	r3, r0, lsl #18
    1478:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    147c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1480:	6d653776 	stclvs	7, cr3, [r5, #-472]!	; 0xfffffe28
    1484:	52415400 	subpl	r5, r1, #0, 8
    1488:	5f544547 	svcpl	0x00544547
    148c:	5f555043 	svcpl	0x00555043
    1490:	32366166 	eorscc	r6, r6, #-2147483623	; 0x80000019
    1494:	00657436 	rsbeq	r7, r5, r6, lsr r4
    1498:	47524154 			; <UNDEFINED> instruction: 0x47524154
    149c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    14a0:	6d5f5550 	cfldr64vs	mvdx5, [pc, #-320]	; 1368 <_start-0x6c98>
    14a4:	65767261 	ldrbvs	r7, [r6, #-609]!	; 0xfffffd9f
    14a8:	705f6c6c 	subsvc	r6, pc, ip, ror #24
    14ac:	6800346a 	stmdavs	r0, {r1, r3, r5, r6, sl, ip, sp}
    14b0:	5f626174 	svcpl	0x00626174
    14b4:	68736168 	ldmdavs	r3!, {r3, r5, r6, r8, sp, lr}^
    14b8:	696f705f 	stmdbvs	pc!, {r0, r1, r2, r3, r4, r6, ip, sp, lr}^	; <UNPREDICTABLE>
    14bc:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
    14c0:	6d726100 	ldfvse	f6, [r2, #-0]
    14c4:	6e75745f 	mrcvs	4, 3, r7, cr5, cr15, {2}
    14c8:	6f635f65 	svcvs	0x00635f65
    14cc:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    14d0:	0039615f 	eorseq	r6, r9, pc, asr r1
    14d4:	5f617369 	svcpl	0x00617369
    14d8:	5f746962 	svcpl	0x00746962
    14dc:	6d6d7769 	stclvs	7, cr7, [sp, #-420]!	; 0xfffffe5c
    14e0:	00327478 	eorseq	r7, r2, r8, ror r4
    14e4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    14e8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    14ec:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    14f0:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    14f4:	32376178 	eorscc	r6, r7, #120, 2
    14f8:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    14fc:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    1500:	73690033 	cmnvc	r9, #51	; 0x33
    1504:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1508:	68745f74 	ldmdavs	r4!, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    150c:	32626d75 	rsbcc	r6, r2, #7488	; 0x1d40
    1510:	53414200 	movtpl	r4, #4608	; 0x1200
    1514:	52415f45 	subpl	r5, r1, #276	; 0x114
    1518:	375f4843 	ldrbcc	r4, [pc, -r3, asr #16]
    151c:	73690041 	cmnvc	r9, #65	; 0x41
    1520:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1524:	6f645f74 	svcvs	0x00645f74
    1528:	6f727074 	svcvs	0x00727074
    152c:	72610064 	rsbvc	r0, r1, #100	; 0x64
    1530:	70665f6d 	rsbvc	r5, r6, sp, ror #30
    1534:	745f3631 	ldrbvc	r3, [pc], #-1585	; 153c <_start-0x6ac4>
    1538:	5f657079 	svcpl	0x00657079
    153c:	65646f6e 	strbvs	r6, [r4, #-3950]!	; 0xfffff092
    1540:	4d524100 	ldfmie	f4, [r2, #-0]
    1544:	00494d5f 	subeq	r4, r9, pc, asr sp
    1548:	5f6d7261 	svcpl	0x006d7261
    154c:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1550:	61006b36 	tstvs	r0, r6, lsr fp
    1554:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1558:	36686372 			; <UNDEFINED> instruction: 0x36686372
    155c:	4142006d 	cmpmi	r2, sp, rrx
    1560:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1564:	5f484352 	svcpl	0x00484352
    1568:	5f005237 	svcpl	0x00005237
    156c:	706f705f 	rsbvc	r7, pc, pc, asr r0	; <UNPREDICTABLE>
    1570:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
    1574:	61745f74 	cmnvs	r4, r4, ror pc
    1578:	622f0062 	eorvs	r0, pc, #98	; 0x62
    157c:	646c6975 	strbtvs	r6, [ip], #-2421	; 0xfffff68b
    1580:	6363672f 	cmnvs	r3, #12320768	; 0xbc0000
    1584:	6d72612d 	ldfvse	f6, [r2, #-180]!	; 0xffffff4c
    1588:	6e6f6e2d 	cdpvs	14, 6, cr6, cr15, cr13, {1}
    158c:	61652d65 	cmnvs	r5, r5, ror #26
    1590:	472d6962 	strmi	r6, [sp, -r2, ror #18]!
    1594:	546b396c 	strbtpl	r3, [fp], #-2412	; 0xfffff694
    1598:	63672f39 	cmnvs	r7, #57, 30	; 0xe4
    159c:	72612d63 	rsbvc	r2, r1, #6336	; 0x18c0
    15a0:	6f6e2d6d 	svcvs	0x006e2d6d
    15a4:	652d656e 	strvs	r6, [sp, #-1390]!	; 0xfffffa92
    15a8:	2d696261 	sfmcs	f6, 2, [r9, #-388]!	; 0xfffffe7c
    15ac:	30322d39 	eorscc	r2, r2, r9, lsr sp
    15b0:	712d3931 			; <UNDEFINED> instruction: 0x712d3931
    15b4:	75622f34 	strbvc	r2, [r2, #-3892]!	; 0xfffff0cc
    15b8:	2f646c69 	svccs	0x00646c69
    15bc:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
    15c0:	656e6f6e 	strbvs	r6, [lr, #-3950]!	; 0xfffff092
    15c4:	6261652d 	rsbvs	r6, r1, #188743680	; 0xb400000
    15c8:	72612f69 	rsbvc	r2, r1, #420	; 0x1a4
    15cc:	35762f6d 	ldrbcc	r2, [r6, #-3949]!	; 0xfffff093
    15d0:	682f6574 	stmdavs	pc!, {r2, r4, r5, r6, r8, sl, sp, lr}	; <UNPREDICTABLE>
    15d4:	2f647261 	svccs	0x00647261
    15d8:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    15dc:	69006363 	stmdbvs	r0, {r0, r1, r5, r6, r8, r9, sp, lr}
    15e0:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    15e4:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    15e8:	0065736d 	rsbeq	r7, r5, sp, ror #6
    15ec:	47524154 			; <UNDEFINED> instruction: 0x47524154
    15f0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    15f4:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    15f8:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    15fc:	33376178 	teqcc	r7, #120, 2
    1600:	52415400 	subpl	r5, r1, #0, 8
    1604:	5f544547 	svcpl	0x00544547
    1608:	5f555043 	svcpl	0x00555043
    160c:	656e6567 	strbvs	r6, [lr, #-1383]!	; 0xfffffa99
    1610:	76636972 			; <UNDEFINED> instruction: 0x76636972
    1614:	54006137 	strpl	r6, [r0], #-311	; 0xfffffec9
    1618:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    161c:	50435f54 	subpl	r5, r3, r4, asr pc
    1620:	6f635f55 	svcvs	0x00635f55
    1624:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1628:	00363761 	eorseq	r3, r6, r1, ror #14
    162c:	5f6d7261 	svcpl	0x006d7261
    1630:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1634:	5f6f6e5f 	svcpl	0x006f6e5f
    1638:	616c6f76 	smcvs	50934	; 0xc6f6
    163c:	656c6974 	strbvs	r6, [ip, #-2420]!	; 0xfffff68c
    1640:	0065635f 	rsbeq	r6, r5, pc, asr r3
    1644:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1648:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    164c:	41385f48 	teqmi	r8, r8, asr #30
    1650:	61736900 	cmnvs	r3, r0, lsl #18
    1654:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1658:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    165c:	00743576 	rsbseq	r3, r4, r6, ror r5
    1660:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1664:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1668:	52385f48 	eorspl	r5, r8, #72, 30	; 0x120
    166c:	52415400 	subpl	r5, r1, #0, 8
    1670:	5f544547 	svcpl	0x00544547
    1674:	5f555043 	svcpl	0x00555043
    1678:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    167c:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    1680:	726f6333 	rsbvc	r6, pc, #-872415232	; 0xcc000000
    1684:	61786574 	cmnvs	r8, r4, ror r5
    1688:	41003533 	tstmi	r0, r3, lsr r5
    168c:	4e5f4d52 	mrcmi	13, 2, r4, cr15, cr2, {2}
    1690:	72610056 	rsbvc	r0, r1, #86	; 0x56
    1694:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    1698:	00346863 	eorseq	r6, r4, r3, ror #16
    169c:	5f6d7261 	svcpl	0x006d7261
    16a0:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    16a4:	72610036 	rsbvc	r0, r1, #54	; 0x36
    16a8:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    16ac:	00376863 	eorseq	r6, r7, r3, ror #16
    16b0:	5f6d7261 	svcpl	0x006d7261
    16b4:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    16b8:	6f6c0038 	svcvs	0x006c0038
    16bc:	6420676e 	strtvs	r6, [r0], #-1902	; 0xfffff892
    16c0:	6c62756f 	cfstr64vs	mvdx7, [r2], #-444	; 0xfffffe44
    16c4:	72610065 	rsbvc	r0, r1, #101	; 0x65
    16c8:	75745f6d 	ldrbvc	r5, [r4, #-3949]!	; 0xfffff093
    16cc:	785f656e 	ldmdavc	pc, {r1, r2, r3, r5, r6, r8, sl, sp, lr}^	; <UNPREDICTABLE>
    16d0:	6c616373 	stclvs	3, cr6, [r1], #-460	; 0xfffffe34
    16d4:	616d0065 	cmnvs	sp, r5, rrx
    16d8:	676e696b 	strbvs	r6, [lr, -fp, ror #18]!
    16dc:	6e6f635f 	mcrvs	3, 3, r6, cr15, cr15, {2}
    16e0:	745f7473 	ldrbvc	r7, [pc], #-1139	; 16e8 <_start-0x6918>
    16e4:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
    16e8:	75687400 	strbvc	r7, [r8, #-1024]!	; 0xfffffc00
    16ec:	635f626d 	cmpvs	pc, #-805306362	; 0xd0000006
    16f0:	5f6c6c61 	svcpl	0x006c6c61
    16f4:	5f616976 	svcpl	0x00616976
    16f8:	6562616c 	strbvs	r6, [r2, #-364]!	; 0xfffffe94
    16fc:	7369006c 	cmnvc	r9, #108	; 0x6c
    1700:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1704:	70665f74 	rsbvc	r5, r6, r4, ror pc
    1708:	69003576 	stmdbvs	r0, {r1, r2, r4, r5, r6, r8, sl, ip, sp}
    170c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1710:	615f7469 	cmpvs	pc, r9, ror #8
    1714:	36766d72 			; <UNDEFINED> instruction: 0x36766d72
    1718:	4154006b 	cmpmi	r4, fp, rrx
    171c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1720:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1724:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1728:	61786574 	cmnvs	r8, r4, ror r5
    172c:	41540037 	cmpmi	r4, r7, lsr r0
    1730:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1734:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1738:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    173c:	61786574 	cmnvs	r8, r4, ror r5
    1740:	41540038 	cmpmi	r4, r8, lsr r0
    1744:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1748:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    174c:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1750:	61786574 	cmnvs	r8, r4, ror r5
    1754:	52410039 	subpl	r0, r1, #57	; 0x39
    1758:	43505f4d 	cmpmi	r0, #308	; 0x134
    175c:	50415f53 	subpl	r5, r1, r3, asr pc
    1760:	41005343 	tstmi	r0, r3, asr #6
    1764:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    1768:	415f5343 	cmpmi	pc, r3, asr #6
    176c:	53435054 	movtpl	r5, #12372	; 0x3054
    1770:	6d6f6300 	stclvs	3, cr6, [pc, #-0]	; 1778 <_start-0x6888>
    1774:	78656c70 	stmdavc	r5!, {r4, r5, r6, sl, fp, sp, lr}^
    1778:	756f6420 	strbvc	r6, [pc, #-1056]!	; 1360 <_start-0x6ca0>
    177c:	00656c62 	rsbeq	r6, r5, r2, ror #24
    1780:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1784:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1788:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    178c:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1790:	33376178 	teqcc	r7, #120, 2
    1794:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1798:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    179c:	41540033 	cmpmi	r4, r3, lsr r0
    17a0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    17a4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    17a8:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    17ac:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    17b0:	756c7030 	strbvc	r7, [ip, #-48]!	; 0xffffffd0
    17b4:	72610073 	rsbvc	r0, r1, #115	; 0x73
    17b8:	63635f6d 	cmnvs	r3, #436	; 0x1b4
    17bc:	61736900 	cmnvs	r3, r0, lsl #18
    17c0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    17c4:	6373785f 	cmnvs	r3, #6225920	; 0x5f0000
    17c8:	00656c61 	rsbeq	r6, r5, r1, ror #24
    17cc:	6e6f645f 	mcrvs	4, 3, r6, cr15, cr15, {2}
    17d0:	73755f74 	cmnvc	r5, #116, 30	; 0x1d0
    17d4:	72745f65 	rsbsvc	r5, r4, #404	; 0x194
    17d8:	685f6565 	ldmdavs	pc, {r0, r2, r5, r6, r8, sl, sp, lr}^	; <UNPREDICTABLE>
    17dc:	5f657265 	svcpl	0x00657265
    17e0:	52415400 	subpl	r5, r1, #0, 8
    17e4:	5f544547 	svcpl	0x00544547
    17e8:	5f555043 	svcpl	0x00555043
    17ec:	316d7261 	cmncc	sp, r1, ror #4
    17f0:	6d647430 	cfstrdvs	mvd7, [r4, #-192]!	; 0xffffff40
    17f4:	41540069 	cmpmi	r4, r9, rrx
    17f8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    17fc:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1800:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1804:	61786574 	cmnvs	r8, r4, ror r5
    1808:	61620035 	cmnvs	r2, r5, lsr r0
    180c:	615f6573 	cmpvs	pc, r3, ror r5	; <UNPREDICTABLE>
    1810:	69686372 	stmdbvs	r8!, {r1, r4, r5, r6, r8, r9, sp, lr}^
    1814:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
    1818:	00657275 	rsbeq	r7, r5, r5, ror r2
    181c:	5f6d7261 	svcpl	0x006d7261
    1820:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1824:	6372635f 	cmnvs	r2, #2080374785	; 0x7c000001
    1828:	52415400 	subpl	r5, r1, #0, 8
    182c:	5f544547 	svcpl	0x00544547
    1830:	5f555043 	svcpl	0x00555043
    1834:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1838:	316d7865 	cmncc	sp, r5, ror #16
    183c:	6c616d73 	stclvs	13, cr6, [r1], #-460	; 0xfffffe34
    1840:	6c756d6c 	ldclvs	13, cr6, [r5], #-432	; 0xfffffe50
    1844:	6c706974 			; <UNDEFINED> instruction: 0x6c706974
    1848:	72610079 	rsbvc	r0, r1, #121	; 0x79
    184c:	75635f6d 	strbvc	r5, [r3, #-3949]!	; 0xfffff093
    1850:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
    1854:	63635f74 	cmnvs	r3, #116, 30	; 0x1d0
    1858:	61736900 	cmnvs	r3, r0, lsl #18
    185c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1860:	6372635f 	cmnvs	r2, #2080374785	; 0x7c000001
    1864:	41003233 	tstmi	r0, r3, lsr r2
    1868:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    186c:	7369004c 	cmnvc	r9, #76	; 0x4c
    1870:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1874:	66765f74 	uhsub16vs	r5, r6, r4
    1878:	00337670 	eorseq	r7, r3, r0, ror r6
    187c:	5f617369 	svcpl	0x00617369
    1880:	5f746962 	svcpl	0x00746962
    1884:	76706676 			; <UNDEFINED> instruction: 0x76706676
    1888:	41420034 	cmpmi	r2, r4, lsr r0
    188c:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1890:	5f484352 	svcpl	0x00484352
    1894:	00325436 	eorseq	r5, r2, r6, lsr r4
    1898:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    189c:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    18a0:	4d385f48 	ldcmi	15, cr5, [r8, #-288]!	; 0xfffffee0
    18a4:	49414d5f 	stmdbmi	r1, {r0, r1, r2, r3, r4, r6, r8, sl, fp, lr}^
    18a8:	4154004e 	cmpmi	r4, lr, asr #32
    18ac:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    18b0:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    18b4:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    18b8:	6d647439 	cfstrdvs	mvd7, [r4, #-228]!	; 0xffffff1c
    18bc:	52410069 	subpl	r0, r1, #105	; 0x69
    18c0:	4c415f4d 	mcrrmi	15, 4, r5, r1, cr13
    18c4:	53414200 	movtpl	r4, #4608	; 0x1200
    18c8:	52415f45 	subpl	r5, r1, #276	; 0x114
    18cc:	375f4843 	ldrbcc	r4, [pc, -r3, asr #16]
    18d0:	7261004d 	rsbvc	r0, r1, #77	; 0x4d
    18d4:	61745f6d 	cmnvs	r4, sp, ror #30
    18d8:	74656772 	strbtvc	r6, [r5], #-1906	; 0xfffff88e
    18dc:	62616c5f 	rsbvs	r6, r1, #24320	; 0x5f00
    18e0:	61006c65 	tstvs	r0, r5, ror #24
    18e4:	745f6d72 	ldrbvc	r6, [pc], #-3442	; 18ec <_start-0x6714>
    18e8:	65677261 	strbvs	r7, [r7, #-609]!	; 0xfffffd9f
    18ec:	6e695f74 	mcrvs	15, 3, r5, cr9, cr4, {3}
    18f0:	54006e73 	strpl	r6, [r0], #-3699	; 0xfffff18d
    18f4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    18f8:	50435f54 	subpl	r5, r3, r4, asr pc
    18fc:	6f635f55 	svcvs	0x00635f55
    1900:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1904:	54003472 	strpl	r3, [r0], #-1138	; 0xfffffb8e
    1908:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    190c:	50435f54 	subpl	r5, r3, r4, asr pc
    1910:	6f635f55 	svcvs	0x00635f55
    1914:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1918:	54003572 	strpl	r3, [r0], #-1394	; 0xfffffa8e
    191c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1920:	50435f54 	subpl	r5, r3, r4, asr pc
    1924:	6f635f55 	svcvs	0x00635f55
    1928:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    192c:	54003772 	strpl	r3, [r0], #-1906	; 0xfffff88e
    1930:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1934:	50435f54 	subpl	r5, r3, r4, asr pc
    1938:	6f635f55 	svcvs	0x00635f55
    193c:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1940:	69003872 	stmdbvs	r0, {r1, r4, r5, r6, fp, ip, sp}
    1944:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1948:	6c5f7469 	cfldrdvs	mvd7, [pc], {105}	; 0x69
    194c:	00656170 	rsbeq	r6, r5, r0, ror r1
    1950:	5f617369 	svcpl	0x00617369
    1954:	5f746962 	svcpl	0x00746962
    1958:	72697571 	rsbvc	r7, r9, #473956352	; 0x1c400000
    195c:	72615f6b 	rsbvc	r5, r1, #428	; 0x1ac
    1960:	6b36766d 	blvs	d9f31c <_bss_end+0xd960c4>
    1964:	7369007a 	cmnvc	r9, #122	; 0x7a
    1968:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    196c:	6f6e5f74 	svcvs	0x006e5f74
    1970:	69006d74 	stmdbvs	r0, {r2, r4, r5, r6, r8, sl, fp, sp, lr}
    1974:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1978:	615f7469 	cmpvs	pc, r9, ror #8
    197c:	34766d72 	ldrbtcc	r6, [r6], #-3442	; 0xfffff28e
    1980:	61736900 	cmnvs	r3, r0, lsl #18
    1984:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1988:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    198c:	69003676 	stmdbvs	r0, {r1, r2, r4, r5, r6, r9, sl, ip, sp}
    1990:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1994:	615f7469 	cmpvs	pc, r9, ror #8
    1998:	37766d72 			; <UNDEFINED> instruction: 0x37766d72
    199c:	61736900 	cmnvs	r3, r0, lsl #18
    19a0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    19a4:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    19a8:	5f003876 	svcpl	0x00003876
    19ac:	746e6f64 	strbtvc	r6, [lr], #-3940	; 0xfffff09c
    19b0:	6573755f 	ldrbvs	r7, [r3, #-1375]!	; 0xfffffaa1
    19b4:	7874725f 	ldmdavc	r4!, {r0, r1, r2, r3, r4, r6, r9, ip, sp, lr}^
    19b8:	7265685f 	rsbvc	r6, r5, #6225920	; 0x5f0000
    19bc:	55005f65 	strpl	r5, [r0, #-3941]	; 0xfffff09b
    19c0:	79744951 	ldmdbvc	r4!, {r0, r4, r6, r8, fp, lr}^
    19c4:	69006570 	stmdbvs	r0, {r4, r5, r6, r8, sl, sp, lr}
    19c8:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    19cc:	615f7469 	cmpvs	pc, r9, ror #8
    19d0:	35766d72 	ldrbcc	r6, [r6, #-3442]!	; 0xfffff28e
    19d4:	61006574 	tstvs	r0, r4, ror r5
    19d8:	745f6d72 	ldrbvc	r6, [pc], #-3442	; 19e0 <_start-0x6620>
    19dc:	00656e75 	rsbeq	r6, r5, r5, ror lr
    19e0:	5f6d7261 	svcpl	0x006d7261
    19e4:	5f707063 	svcpl	0x00707063
    19e8:	65746e69 	ldrbvs	r6, [r4, #-3689]!	; 0xfffff197
    19ec:	726f7772 	rsbvc	r7, pc, #29884416	; 0x1c80000
    19f0:	7566006b 	strbvc	r0, [r6, #-107]!	; 0xffffff95
    19f4:	705f636e 	subsvc	r6, pc, lr, ror #6
    19f8:	54007274 	strpl	r7, [r0], #-628	; 0xfffffd8c
    19fc:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1a00:	50435f54 	subpl	r5, r3, r4, asr pc
    1a04:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1a08:	3032396d 	eorscc	r3, r2, sp, ror #18
    1a0c:	74680074 	strbtvc	r0, [r8], #-116	; 0xffffff8c
    1a10:	655f6261 	ldrbvs	r6, [pc, #-609]	; 17b7 <_start-0x6849>
    1a14:	41540071 	cmpmi	r4, r1, ror r0
    1a18:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1a1c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1a20:	3561665f 	strbcc	r6, [r1, #-1631]!	; 0xfffff9a1
    1a24:	61003632 	tstvs	r0, r2, lsr r6
    1a28:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1a2c:	5f686372 	svcpl	0x00686372
    1a30:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    1a34:	77685f62 	strbvc	r5, [r8, -r2, ror #30]!
    1a38:	00766964 	rsbseq	r6, r6, r4, ror #18
    1a3c:	62617468 	rsbvs	r7, r1, #104, 8	; 0x68000000
    1a40:	5f71655f 	svcpl	0x0071655f
    1a44:	6e696f70 	mcrvs	15, 3, r6, cr9, cr0, {3}
    1a48:	00726574 	rsbseq	r6, r2, r4, ror r5
    1a4c:	5f6d7261 	svcpl	0x006d7261
    1a50:	5f636970 	svcpl	0x00636970
    1a54:	69676572 	stmdbvs	r7!, {r1, r4, r5, r6, r8, sl, sp, lr}^
    1a58:	72657473 	rsbvc	r7, r5, #1929379840	; 0x73000000
    1a5c:	52415400 	subpl	r5, r1, #0, 8
    1a60:	5f544547 	svcpl	0x00544547
    1a64:	5f555043 	svcpl	0x00555043
    1a68:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1a6c:	306d7865 	rsbcc	r7, sp, r5, ror #16
    1a70:	6c616d73 	stclvs	13, cr6, [r1], #-460	; 0xfffffe34
    1a74:	6c756d6c 	ldclvs	13, cr6, [r5], #-432	; 0xfffffe50
    1a78:	6c706974 			; <UNDEFINED> instruction: 0x6c706974
    1a7c:	41540079 	cmpmi	r4, r9, ror r0
    1a80:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1a84:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1a88:	63706d5f 	cmnvs	r0, #6080	; 0x17c0
    1a8c:	6e65726f 	cdpvs	2, 6, cr7, cr5, cr15, {3}
    1a90:	7066766f 	rsbvc	r7, r6, pc, ror #12
    1a94:	61736900 	cmnvs	r3, r0, lsl #18
    1a98:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1a9c:	6975715f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, r8, ip, sp, lr}^
    1aa0:	635f6b72 	cmpvs	pc, #116736	; 0x1c800
    1aa4:	6c5f336d 	mrrcvs	3, 6, r3, pc, cr13	; <UNPREDICTABLE>
    1aa8:	00647264 	rsbeq	r7, r4, r4, ror #4
    1aac:	5f4d5241 	svcpl	0x004d5241
    1ab0:	61004343 	tstvs	r0, r3, asr #6
    1ab4:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1ab8:	38686372 	stmdacc	r8!, {r1, r4, r5, r6, r8, r9, sp, lr}^
    1abc:	6100325f 	tstvs	r0, pc, asr r2
    1ac0:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1ac4:	38686372 	stmdacc	r8!, {r1, r4, r5, r6, r8, r9, sp, lr}^
    1ac8:	6100335f 	tstvs	r0, pc, asr r3
    1acc:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1ad0:	38686372 	stmdacc	r8!, {r1, r4, r5, r6, r8, r9, sp, lr}^
    1ad4:	5400345f 	strpl	r3, [r0], #-1119	; 0xfffffba1
    1ad8:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1adc:	50435f54 	subpl	r5, r3, r4, asr pc
    1ae0:	6d665f55 	stclvs	15, cr5, [r6, #-340]!	; 0xfffffeac
    1ae4:	36323670 			; <UNDEFINED> instruction: 0x36323670
    1ae8:	4d524100 	ldfmie	f4, [r2, #-0]
    1aec:	0053435f 	subseq	r4, r3, pc, asr r3
    1af0:	5f6d7261 	svcpl	0x006d7261
    1af4:	36317066 	ldrtcc	r7, [r1], -r6, rrx
    1af8:	736e695f 	cmnvc	lr, #1556480	; 0x17c000
    1afc:	72610074 	rsbvc	r0, r1, #116	; 0x74
    1b00:	61625f6d 	cmnvs	r2, sp, ror #30
    1b04:	615f6573 	cmpvs	pc, r3, ror r5	; <UNPREDICTABLE>
    1b08:	00686372 	rsbeq	r6, r8, r2, ror r3
    1b0c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1b10:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1b14:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1b18:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1b1c:	35316178 	ldrcc	r6, [r1, #-376]!	; 0xfffffe88
    1b20:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1b24:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    1b28:	6d726100 	ldfvse	f6, [r2, #-0]
    1b2c:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1b30:	6d653768 	stclvs	7, cr3, [r5, #-416]!	; 0xfffffe60
    1b34:	52415400 	subpl	r5, r1, #0, 8
    1b38:	5f544547 	svcpl	0x00544547
    1b3c:	5f555043 	svcpl	0x00555043
    1b40:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1b44:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    1b48:	72610032 	rsbvc	r0, r1, #50	; 0x32
    1b4c:	63705f6d 	cmnvs	r0, #436	; 0x1b4
    1b50:	65645f73 	strbvs	r5, [r4, #-3955]!	; 0xfffff08d
    1b54:	6c756166 	ldfvse	f6, [r5], #-408	; 0xfffffe68
    1b58:	52410074 	subpl	r0, r1, #116	; 0x74
    1b5c:	43505f4d 	cmpmi	r0, #308	; 0x134
    1b60:	41415f53 	cmpmi	r1, r3, asr pc
    1b64:	5f534350 	svcpl	0x00534350
    1b68:	41434f4c 	cmpmi	r3, ip, asr #30
    1b6c:	4154004c 	cmpmi	r4, ip, asr #32
    1b70:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1b74:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1b78:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1b7c:	61786574 	cmnvs	r8, r4, ror r5
    1b80:	54003537 	strpl	r3, [r0], #-1335	; 0xfffffac9
    1b84:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1b88:	50435f54 	subpl	r5, r3, r4, asr pc
    1b8c:	74735f55 	ldrbtvc	r5, [r3], #-3925	; 0xfffff0ab
    1b90:	676e6f72 			; <UNDEFINED> instruction: 0x676e6f72
    1b94:	006d7261 	rsbeq	r7, sp, r1, ror #4
    1b98:	5f6d7261 	svcpl	0x006d7261
    1b9c:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1ba0:	7568745f 	strbvc	r7, [r8, #-1119]!	; 0xfffffba1
    1ba4:	0031626d 	eorseq	r6, r1, sp, ror #4
    1ba8:	5f6d7261 	svcpl	0x006d7261
    1bac:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1bb0:	7568745f 	strbvc	r7, [r8, #-1119]!	; 0xfffffba1
    1bb4:	0032626d 	eorseq	r6, r2, sp, ror #4
    1bb8:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1bbc:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1bc0:	695f5550 	ldmdbvs	pc, {r4, r6, r8, sl, ip, lr}^	; <UNPREDICTABLE>
    1bc4:	786d6d77 	stmdavc	sp!, {r0, r1, r2, r4, r5, r6, r8, sl, fp, sp, lr}^
    1bc8:	72610074 	rsbvc	r0, r1, #116	; 0x74
    1bcc:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    1bd0:	74356863 	ldrtvc	r6, [r5], #-2147	; 0xfffff79d
    1bd4:	61736900 	cmnvs	r3, r0, lsl #18
    1bd8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1bdc:	00706d5f 	rsbseq	r6, r0, pc, asr sp
    1be0:	5f6d7261 	svcpl	0x006d7261
    1be4:	735f646c 	cmpvc	pc, #108, 8	; 0x6c000000
    1be8:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
    1bec:	6d726100 	ldfvse	f6, [r2, #-0]
    1bf0:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1bf4:	315f3868 	cmpcc	pc, r8, ror #16
	...

Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347 	bcc	10d0d24 <_bss_end+0x10c7acc>
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
  10:	4b5a3605 	blmi	168d82c <_bss_end+0x16845d4>
  14:	08070600 	stmdaeq	r7, {r9, sl}
  18:	0a010901 	beq	42424 <_bss_end+0x391cc>
  1c:	14041202 	strne	r1, [r4], #-514	; 0xfffffdfe
  20:	17011501 	strne	r1, [r1, -r1, lsl #10]
  24:	1a011803 	bne	46038 <_bss_end+0x3cde0>
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
  20:	8b040e42 	blhi	103930 <_bss_end+0xfa6d8>
  24:	0b0d4201 	bleq	350830 <_bss_end+0x3475d8>
  28:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
  2c:	00000ecb 	andeq	r0, r0, fp, asr #29
  30:	0000001c 	andeq	r0, r0, ip, lsl r0
  34:	00000000 	andeq	r0, r0, r0
  38:	00008050 	andeq	r8, r0, r0, asr r0
  3c:	0000002c 	andeq	r0, r0, ip, lsr #32
  40:	8b040e42 	blhi	103950 <_bss_end+0xfa6f8>
  44:	0b0d4201 	bleq	350850 <_bss_end+0x3475f8>
  48:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
  4c:	00000ecb 	andeq	r0, r0, fp, asr #29
  50:	0000001c 	andeq	r0, r0, ip, lsl r0
  54:	00000000 	andeq	r0, r0, r0
  58:	0000807c 	andeq	r8, r0, ip, ror r0
  5c:	00000020 	andeq	r0, r0, r0, lsr #32
  60:	8b040e42 	blhi	103970 <_bss_end+0xfa718>
  64:	0b0d4201 	bleq	350870 <_bss_end+0x347618>
  68:	420d0d48 	andmi	r0, sp, #72, 26	; 0x1200
  6c:	00000ecb 	andeq	r0, r0, fp, asr #29
  70:	0000001c 	andeq	r0, r0, ip, lsl r0
  74:	00000000 	andeq	r0, r0, r0
  78:	0000809c 	muleq	r0, ip, r0
  7c:	00000018 	andeq	r0, r0, r8, lsl r0
  80:	8b040e42 	blhi	103990 <_bss_end+0xfa738>
  84:	0b0d4201 	bleq	350890 <_bss_end+0x347638>
  88:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  8c:	00000ecb 	andeq	r0, r0, fp, asr #29
  90:	0000001c 	andeq	r0, r0, ip, lsl r0
  94:	00000000 	andeq	r0, r0, r0
  98:	000080b4 	strheq	r8, [r0], -r4
  9c:	00000018 	andeq	r0, r0, r8, lsl r0
  a0:	8b040e42 	blhi	1039b0 <_bss_end+0xfa758>
  a4:	0b0d4201 	bleq	3508b0 <_bss_end+0x347658>
  a8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  ac:	00000ecb 	andeq	r0, r0, fp, asr #29
  b0:	0000001c 	andeq	r0, r0, ip, lsl r0
  b4:	00000000 	andeq	r0, r0, r0
  b8:	000080cc 	andeq	r8, r0, ip, asr #1
  bc:	00000018 	andeq	r0, r0, r8, lsl r0
  c0:	8b040e42 	blhi	1039d0 <_bss_end+0xfa778>
  c4:	0b0d4201 	bleq	3508d0 <_bss_end+0x347678>
  c8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  cc:	00000ecb 	andeq	r0, r0, fp, asr #29
  d0:	00000014 	andeq	r0, r0, r4, lsl r0
  d4:	00000000 	andeq	r0, r0, r0
  d8:	000080e4 	andeq	r8, r0, r4, ror #1
  dc:	0000000c 	andeq	r0, r0, ip
  e0:	8b040e42 	blhi	1039f0 <_bss_end+0xfa798>
  e4:	0b0d4201 	bleq	3508f0 <_bss_end+0x347698>
  e8:	0000000c 	andeq	r0, r0, ip
  ec:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  f0:	7c020001 	stcvc	0, cr0, [r2], {1}
  f4:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  f8:	0000001c 	andeq	r0, r0, ip, lsl r0
  fc:	000000e8 	andeq	r0, r0, r8, ror #1
 100:	000080f0 	strdeq	r8, [r0], -r0
 104:	00000034 	andeq	r0, r0, r4, lsr r0
 108:	8b040e42 	blhi	103a18 <_bss_end+0xfa7c0>
 10c:	0b0d4201 	bleq	350918 <_bss_end+0x3476c0>
 110:	420d0d52 	andmi	r0, sp, #5248	; 0x1480
 114:	00000ecb 	andeq	r0, r0, fp, asr #29
 118:	0000001c 	andeq	r0, r0, ip, lsl r0
 11c:	000000e8 	andeq	r0, r0, r8, ror #1
 120:	00008124 	andeq	r8, r0, r4, lsr #2
 124:	00000114 	andeq	r0, r0, r4, lsl r1
 128:	8b040e42 	blhi	103a38 <_bss_end+0xfa7e0>
 12c:	0b0d4201 	bleq	350938 <_bss_end+0x3476e0>
 130:	0d0d8002 	stceq	0, cr8, [sp, #-8]
 134:	000ecb42 	andeq	ip, lr, r2, asr #22
 138:	0000001c 	andeq	r0, r0, ip, lsl r0
 13c:	000000e8 	andeq	r0, r0, r8, ror #1
 140:	00008238 	andeq	r8, r0, r8, lsr r2
 144:	00000074 	andeq	r0, r0, r4, ror r0
 148:	8b040e42 	blhi	103a58 <_bss_end+0xfa800>
 14c:	0b0d4201 	bleq	350958 <_bss_end+0x347700>
 150:	420d0d72 	andmi	r0, sp, #7296	; 0x1c80
 154:	00000ecb 	andeq	r0, r0, fp, asr #29
 158:	0000001c 	andeq	r0, r0, ip, lsl r0
 15c:	000000e8 	andeq	r0, r0, r8, ror #1
 160:	000082ac 	andeq	r8, r0, ip, lsr #5
 164:	00000074 	andeq	r0, r0, r4, ror r0
 168:	8b040e42 	blhi	103a78 <_bss_end+0xfa820>
 16c:	0b0d4201 	bleq	350978 <_bss_end+0x347720>
 170:	420d0d72 	andmi	r0, sp, #7296	; 0x1c80
 174:	00000ecb 	andeq	r0, r0, fp, asr #29
 178:	0000001c 	andeq	r0, r0, ip, lsl r0
 17c:	000000e8 	andeq	r0, r0, r8, ror #1
 180:	00008320 	andeq	r8, r0, r0, lsr #6
 184:	00000074 	andeq	r0, r0, r4, ror r0
 188:	8b040e42 	blhi	103a98 <_bss_end+0xfa840>
 18c:	0b0d4201 	bleq	350998 <_bss_end+0x347740>
 190:	420d0d72 	andmi	r0, sp, #7296	; 0x1c80
 194:	00000ecb 	andeq	r0, r0, fp, asr #29
 198:	0000001c 	andeq	r0, r0, ip, lsl r0
 19c:	000000e8 	andeq	r0, r0, r8, ror #1
 1a0:	00008394 	muleq	r0, r4, r3
 1a4:	000000a8 	andeq	r0, r0, r8, lsr #1
 1a8:	8b080e42 	blhi	203ab8 <_bss_end+0x1fa860>
 1ac:	42018e02 	andmi	r8, r1, #2, 28
 1b0:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 1b4:	080d0c4e 	stmdaeq	sp, {r1, r2, r3, r6, sl, fp}
 1b8:	0000001c 	andeq	r0, r0, ip, lsl r0
 1bc:	000000e8 	andeq	r0, r0, r8, ror #1
 1c0:	0000843c 	andeq	r8, r0, ip, lsr r4
 1c4:	0000007c 	andeq	r0, r0, ip, ror r0
 1c8:	8b080e42 	blhi	203ad8 <_bss_end+0x1fa880>
 1cc:	42018e02 	andmi	r8, r1, #2, 28
 1d0:	78040b0c 	stmdavc	r4, {r2, r3, r8, r9, fp}
 1d4:	00080d0c 	andeq	r0, r8, ip, lsl #26
 1d8:	0000001c 	andeq	r0, r0, ip, lsl r0
 1dc:	000000e8 	andeq	r0, r0, r8, ror #1
 1e0:	000084b8 			; <UNDEFINED> instruction: 0x000084b8
 1e4:	000000d8 	ldrdeq	r0, [r0], -r8
 1e8:	8b080e42 	blhi	203af8 <_bss_end+0x1fa8a0>
 1ec:	42018e02 	andmi	r8, r1, #2, 28
 1f0:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 1f4:	080d0c66 	stmdaeq	sp, {r1, r2, r5, r6, sl, fp}
 1f8:	0000001c 	andeq	r0, r0, ip, lsl r0
 1fc:	000000e8 	andeq	r0, r0, r8, ror #1
 200:	00008590 	muleq	r0, r0, r5
 204:	00000054 	andeq	r0, r0, r4, asr r0
 208:	8b080e42 	blhi	203b18 <_bss_end+0x1fa8c0>
 20c:	42018e02 	andmi	r8, r1, #2, 28
 210:	5e040b0c 	vmlapl.f64	d0, d4, d12
 214:	00080d0c 	andeq	r0, r8, ip, lsl #26
 218:	00000018 	andeq	r0, r0, r8, lsl r0
 21c:	000000e8 	andeq	r0, r0, r8, ror #1
 220:	000085e4 	andeq	r8, r0, r4, ror #11
 224:	0000001c 	andeq	r0, r0, ip, lsl r0
 228:	8b080e42 	blhi	203b38 <_bss_end+0x1fa8e0>
 22c:	42018e02 	andmi	r8, r1, #2, 28
 230:	00040b0c 	andeq	r0, r4, ip, lsl #22
 234:	0000000c 	andeq	r0, r0, ip
 238:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 23c:	7c020001 	stcvc	0, cr0, [r2], {1}
 240:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 244:	0000001c 	andeq	r0, r0, ip, lsl r0
 248:	00000234 	andeq	r0, r0, r4, lsr r2
 24c:	00008600 	andeq	r8, r0, r0, lsl #12
 250:	00000078 	andeq	r0, r0, r8, ror r0
 254:	8b040e42 	blhi	103b64 <_bss_end+0xfa90c>
 258:	0b0d4201 	bleq	350a64 <_bss_end+0x34780c>
 25c:	420d0d74 	andmi	r0, sp, #116, 26	; 0x1d00
 260:	00000ecb 	andeq	r0, r0, fp, asr #29
 264:	0000001c 	andeq	r0, r0, ip, lsl r0
 268:	00000234 	andeq	r0, r0, r4, lsr r2
 26c:	00008c38 	andeq	r8, r0, r8, lsr ip
 270:	00000038 	andeq	r0, r0, r8, lsr r0
 274:	8b040e42 	blhi	103b84 <_bss_end+0xfa92c>
 278:	0b0d4201 	bleq	350a84 <_bss_end+0x34782c>
 27c:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
 280:	00000ecb 	andeq	r0, r0, fp, asr #29
 284:	0000001c 	andeq	r0, r0, ip, lsl r0
 288:	00000234 	andeq	r0, r0, r4, lsr r2
 28c:	00008678 	andeq	r8, r0, r8, ror r6
 290:	000000a8 	andeq	r0, r0, r8, lsr #1
 294:	8b080e42 	blhi	203ba4 <_bss_end+0x1fa94c>
 298:	42018e02 	andmi	r8, r1, #2, 28
 29c:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 2a0:	080d0c4e 	stmdaeq	sp, {r1, r2, r3, r6, sl, fp}
 2a4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2a8:	00000234 	andeq	r0, r0, r4, lsr r2
 2ac:	00008c70 	andeq	r8, r0, r0, ror ip
 2b0:	00000088 	andeq	r0, r0, r8, lsl #1
 2b4:	8b080e42 	blhi	203bc4 <_bss_end+0x1fa96c>
 2b8:	42018e02 	andmi	r8, r1, #2, 28
 2bc:	7e040b0c 	vmlavc.f64	d0, d4, d12
 2c0:	00080d0c 	andeq	r0, r8, ip, lsl #26
 2c4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2c8:	00000234 	andeq	r0, r0, r4, lsr r2
 2cc:	00008720 	andeq	r8, r0, r0, lsr #14
 2d0:	00000130 	andeq	r0, r0, r0, lsr r1
 2d4:	8b040e42 	blhi	103be4 <_bss_end+0xfa98c>
 2d8:	0b0d4201 	bleq	350ae4 <_bss_end+0x34788c>
 2dc:	0d0d9002 	stceq	0, cr9, [sp, #-8]
 2e0:	000ecb42 	andeq	ip, lr, r2, asr #22
 2e4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2e8:	00000234 	andeq	r0, r0, r4, lsr r2
 2ec:	00008cf8 	strdeq	r8, [r0], -r8	; <UNPREDICTABLE>
 2f0:	0000002c 	andeq	r0, r0, ip, lsr #32
 2f4:	8b040e42 	blhi	103c04 <_bss_end+0xfa9ac>
 2f8:	0b0d4201 	bleq	350b04 <_bss_end+0x3478ac>
 2fc:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 300:	00000ecb 	andeq	r0, r0, fp, asr #29
 304:	0000001c 	andeq	r0, r0, ip, lsl r0
 308:	00000234 	andeq	r0, r0, r4, lsr r2
 30c:	00008850 	andeq	r8, r0, r0, asr r8
 310:	000000a8 	andeq	r0, r0, r8, lsr #1
 314:	8b080e42 	blhi	203c24 <_bss_end+0x1fa9cc>
 318:	42018e02 	andmi	r8, r1, #2, 28
 31c:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 320:	080d0c4e 	stmdaeq	sp, {r1, r2, r3, r6, sl, fp}
 324:	0000001c 	andeq	r0, r0, ip, lsl r0
 328:	00000234 	andeq	r0, r0, r4, lsr r2
 32c:	000088f8 	strdeq	r8, [r0], -r8	; <UNPREDICTABLE>
 330:	00000078 	andeq	r0, r0, r8, ror r0
 334:	8b080e42 	blhi	203c44 <_bss_end+0x1fa9ec>
 338:	42018e02 	andmi	r8, r1, #2, 28
 33c:	76040b0c 	strvc	r0, [r4], -ip, lsl #22
 340:	00080d0c 	andeq	r0, r8, ip, lsl #26
 344:	0000001c 	andeq	r0, r0, ip, lsl r0
 348:	00000234 	andeq	r0, r0, r4, lsr r2
 34c:	00008970 	andeq	r8, r0, r0, ror r9
 350:	00000034 	andeq	r0, r0, r4, lsr r0
 354:	8b040e42 	blhi	103c64 <_bss_end+0xfaa0c>
 358:	0b0d4201 	bleq	350b64 <_bss_end+0x34790c>
 35c:	420d0d52 	andmi	r0, sp, #5248	; 0x1480
 360:	00000ecb 	andeq	r0, r0, fp, asr #29
 364:	0000001c 	andeq	r0, r0, ip, lsl r0
 368:	00000234 	andeq	r0, r0, r4, lsr r2
 36c:	000089a4 	andeq	r8, r0, r4, lsr #19
 370:	00000054 	andeq	r0, r0, r4, asr r0
 374:	8b080e42 	blhi	203c84 <_bss_end+0x1faa2c>
 378:	42018e02 	andmi	r8, r1, #2, 28
 37c:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 380:	00080d0c 	andeq	r0, r8, ip, lsl #26
 384:	0000001c 	andeq	r0, r0, ip, lsl r0
 388:	00000234 	andeq	r0, r0, r4, lsr r2
 38c:	000089f8 	strdeq	r8, [r0], -r8	; <UNPREDICTABLE>
 390:	00000060 	andeq	r0, r0, r0, rrx
 394:	8b080e42 	blhi	203ca4 <_bss_end+0x1faa4c>
 398:	42018e02 	andmi	r8, r1, #2, 28
 39c:	66040b0c 	strvs	r0, [r4], -ip, lsl #22
 3a0:	00080d0c 	andeq	r0, r8, ip, lsl #26
 3a4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3a8:	00000234 	andeq	r0, r0, r4, lsr r2
 3ac:	00008d24 	andeq	r8, r0, r4, lsr #26
 3b0:	00000090 	muleq	r0, r0, r0
 3b4:	8b040e42 	blhi	103cc4 <_bss_end+0xfaa6c>
 3b8:	0b0d4201 	bleq	350bc4 <_bss_end+0x34796c>
 3bc:	0d0d4002 	stceq	0, cr4, [sp, #-8]
 3c0:	000ecb42 	andeq	ip, lr, r2, asr #22
 3c4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3c8:	00000234 	andeq	r0, r0, r4, lsr r2
 3cc:	00008db4 			; <UNDEFINED> instruction: 0x00008db4
 3d0:	0000007c 	andeq	r0, r0, ip, ror r0
 3d4:	8b040e42 	blhi	103ce4 <_bss_end+0xfaa8c>
 3d8:	0b0d4201 	bleq	350be4 <_bss_end+0x34798c>
 3dc:	420d0d76 	andmi	r0, sp, #7552	; 0x1d80
 3e0:	00000ecb 	andeq	r0, r0, fp, asr #29
 3e4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3e8:	00000234 	andeq	r0, r0, r4, lsr r2
 3ec:	00008a58 	andeq	r8, r0, r8, asr sl
 3f0:	0000016c 	andeq	r0, r0, ip, ror #2
 3f4:	8b080e42 	blhi	203d04 <_bss_end+0x1faaac>
 3f8:	42018e02 	andmi	r8, r1, #2, 28
 3fc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 400:	080d0cae 	stmdaeq	sp, {r1, r2, r3, r5, r7, sl, fp}
 404:	0000001c 	andeq	r0, r0, ip, lsl r0
 408:	00000234 	andeq	r0, r0, r4, lsr r2
 40c:	00008bc4 	andeq	r8, r0, r4, asr #23
 410:	00000058 	andeq	r0, r0, r8, asr r0
 414:	8b080e42 	blhi	203d24 <_bss_end+0x1faacc>
 418:	42018e02 	andmi	r8, r1, #2, 28
 41c:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 420:	00080d0c 	andeq	r0, r8, ip, lsl #26
 424:	00000018 	andeq	r0, r0, r8, lsl r0
 428:	00000234 	andeq	r0, r0, r4, lsr r2
 42c:	00008c1c 	andeq	r8, r0, ip, lsl ip
 430:	0000001c 	andeq	r0, r0, ip, lsl r0
 434:	8b080e42 	blhi	203d44 <_bss_end+0x1faaec>
 438:	42018e02 	andmi	r8, r1, #2, 28
 43c:	00040b0c 	andeq	r0, r4, ip, lsl #22
 440:	0000000c 	andeq	r0, r0, ip
 444:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 448:	7c020001 	stcvc	0, cr0, [r2], {1}
 44c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 450:	00000018 	andeq	r0, r0, r8, lsl r0
 454:	00000440 	andeq	r0, r0, r0, asr #8
 458:	00008e30 	andeq	r8, r0, r0, lsr lr
 45c:	000001b4 			; <UNDEFINED> instruction: 0x000001b4
 460:	8b080e42 	blhi	203d70 <_bss_end+0x1fab18>
 464:	42018e02 	andmi	r8, r1, #2, 28
 468:	00040b0c 	andeq	r0, r4, ip, lsl #22
 46c:	0000000c 	andeq	r0, r0, ip
 470:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 474:	7c020001 	stcvc	0, cr0, [r2], {1}
 478:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 47c:	0000001c 	andeq	r0, r0, ip, lsl r0
 480:	0000046c 	andeq	r0, r0, ip, ror #8
 484:	00008fe4 	andeq	r8, r0, r4, ror #31
 488:	00000068 	andeq	r0, r0, r8, rrx
 48c:	8b040e42 	blhi	103d9c <_bss_end+0xfab44>
 490:	0b0d4201 	bleq	350c9c <_bss_end+0x347a44>
 494:	420d0d68 	andmi	r0, sp, #104, 26	; 0x1a00
 498:	00000ecb 	andeq	r0, r0, fp, asr #29
 49c:	0000001c 	andeq	r0, r0, ip, lsl r0
 4a0:	0000046c 	andeq	r0, r0, ip, ror #8
 4a4:	0000904c 	andeq	r9, r0, ip, asr #32
 4a8:	00000058 	andeq	r0, r0, r8, asr r0
 4ac:	8b080e42 	blhi	203dbc <_bss_end+0x1fab64>
 4b0:	42018e02 	andmi	r8, r1, #2, 28
 4b4:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 4b8:	00080d0c 	andeq	r0, r8, ip, lsl #26
 4bc:	0000001c 	andeq	r0, r0, ip, lsl r0
 4c0:	0000046c 	andeq	r0, r0, ip, ror #8
 4c4:	000090a4 	andeq	r9, r0, r4, lsr #1
 4c8:	00000058 	andeq	r0, r0, r8, asr r0
 4cc:	8b080e42 	blhi	203ddc <_bss_end+0x1fab84>
 4d0:	42018e02 	andmi	r8, r1, #2, 28
 4d4:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 4d8:	00080d0c 	andeq	r0, r8, ip, lsl #26

Disassembly of section .debug_ranges:

00000000 <.debug_ranges>:
   0:	00008600 	andeq	r8, r0, r0, lsl #12
   4:	00008c38 	andeq	r8, r0, r8, lsr ip
   8:	00008c38 	andeq	r8, r0, r8, lsr ip
   c:	00008c70 	andeq	r8, r0, r0, ror ip
  10:	00008c70 	andeq	r8, r0, r0, ror ip
  14:	00008cf8 	strdeq	r8, [r0], -r8	; <UNPREDICTABLE>
  18:	00008cf8 	strdeq	r8, [r0], -r8	; <UNPREDICTABLE>
  1c:	00008d24 	andeq	r8, r0, r4, lsr #26
  20:	00008d24 	andeq	r8, r0, r4, lsr #26
  24:	00008db4 			; <UNDEFINED> instruction: 0x00008db4
  28:	00008db4 			; <UNDEFINED> instruction: 0x00008db4
  2c:	00008e30 	andeq	r8, r0, r0, lsr lr
	...
