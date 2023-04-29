
./kernel:     file format elf32-littlearm


Disassembly of section .text:

00008000 <_start>:
_start():
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/start.s:8
;@ tady budou symboly, ktere chceme na zacatek kodove sekce
.section .text.start

;@ vstupni bod do kernelu - nechame ho vlozit na zacatek kodu
_start:
    mov sp,#0x8000			;@ nastavime stack pointer na spodek zasobniku
    8000:	e3a0d902 	mov	sp, #32768	; 0x8000
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/start.s:9
	bl _c_startup			;@ C startup kod (inicializace prostredi)
    8004:	eb0001a8 	bl	86ac <_c_startup>
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/start.s:10
	bl _cpp_startup			;@ C++ startup kod (volani globalnich konstruktoru, ...)
    8008:	eb0001c1 	bl	8714 <_cpp_startup>
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/start.s:11
    bl _kernel_main			;@ skocime do hlavniho kodu jadra (v C)
    800c:	eb00017b 	bl	8600 <_kernel_main>
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/start.s:12
	bl _cpp_shutdown		;@ C++ shutdown kod (volani globalnich destruktoru, ...)
    8010:	eb0001d5 	bl	876c <_cpp_shutdown>

00008014 <hang>:
hang():
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/start.s:14
hang:
    b hang
    8014:	eafffffe 	b	8014 <hang>

00008018 <__cxa_guard_acquire>:
__cxa_guard_acquire():
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/cxx.cpp:11
	extern "C" int __cxa_guard_acquire (__guard *);
	extern "C" void __cxa_guard_release (__guard *);
	extern "C" void __cxa_guard_abort (__guard *);

	extern "C" int __cxa_guard_acquire (__guard *g)
	{
    8018:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    801c:	e28db000 	add	fp, sp, #0
    8020:	e24dd00c 	sub	sp, sp, #12
    8024:	e50b0008 	str	r0, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/cxx.cpp:12
		return !*(char *)(g);
    8028:	e51b3008 	ldr	r3, [fp, #-8]
    802c:	e5d33000 	ldrb	r3, [r3]
    8030:	e3530000 	cmp	r3, #0
    8034:	03a03001 	moveq	r3, #1
    8038:	13a03000 	movne	r3, #0
    803c:	e6ef3073 	uxtb	r3, r3
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/cxx.cpp:13
	}
    8040:	e1a00003 	mov	r0, r3
    8044:	e28bd000 	add	sp, fp, #0
    8048:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    804c:	e12fff1e 	bx	lr

00008050 <__cxa_guard_release>:
__cxa_guard_release():
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/cxx.cpp:16

	extern "C" void __cxa_guard_release (__guard *g)
	{
    8050:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8054:	e28db000 	add	fp, sp, #0
    8058:	e24dd00c 	sub	sp, sp, #12
    805c:	e50b0008 	str	r0, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/cxx.cpp:17
		*(char *)g = 1;
    8060:	e51b3008 	ldr	r3, [fp, #-8]
    8064:	e3a02001 	mov	r2, #1
    8068:	e5c32000 	strb	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/cxx.cpp:18
	}
    806c:	e320f000 	nop	{0}
    8070:	e28bd000 	add	sp, fp, #0
    8074:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8078:	e12fff1e 	bx	lr

0000807c <__cxa_guard_abort>:
__cxa_guard_abort():
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/cxx.cpp:21

	extern "C" void __cxa_guard_abort (__guard *)
	{
    807c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8080:	e28db000 	add	fp, sp, #0
    8084:	e24dd00c 	sub	sp, sp, #12
    8088:	e50b0008 	str	r0, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/cxx.cpp:23

	}
    808c:	e320f000 	nop	{0}
    8090:	e28bd000 	add	sp, fp, #0
    8094:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8098:	e12fff1e 	bx	lr

0000809c <__dso_handle>:
__dso_handle():
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/cxx.cpp:27
}

extern "C" void __dso_handle()
{
    809c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    80a0:	e28db000 	add	fp, sp, #0
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/cxx.cpp:29
    // ignore dtors for now
}
    80a4:	e320f000 	nop	{0}
    80a8:	e28bd000 	add	sp, fp, #0
    80ac:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    80b0:	e12fff1e 	bx	lr

000080b4 <__cxa_atexit>:
__cxa_atexit():
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/cxx.cpp:32

extern "C" void __cxa_atexit()
{
    80b4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    80b8:	e28db000 	add	fp, sp, #0
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/cxx.cpp:34
    // ignore dtors for now
}
    80bc:	e320f000 	nop	{0}
    80c0:	e28bd000 	add	sp, fp, #0
    80c4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    80c8:	e12fff1e 	bx	lr

000080cc <__cxa_pure_virtual>:
__cxa_pure_virtual():
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/cxx.cpp:37

extern "C" void __cxa_pure_virtual()
{
    80cc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    80d0:	e28db000 	add	fp, sp, #0
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/cxx.cpp:39
    // pure virtual method called
}
    80d4:	e320f000 	nop	{0}
    80d8:	e28bd000 	add	sp, fp, #0
    80dc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    80e0:	e12fff1e 	bx	lr

000080e4 <__aeabi_unwind_cpp_pr1>:
__aeabi_unwind_cpp_pr1():
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/cxx.cpp:42

extern "C" void __aeabi_unwind_cpp_pr1()
{
    80e4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    80e8:	e28db000 	add	fp, sp, #0
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/cxx.cpp:43 (discriminator 1)
	while (true)
    80ec:	eafffffe 	b	80ec <__aeabi_unwind_cpp_pr1+0x8>

000080f0 <_ZN13CGPIO_HandlerC1Ej>:
_ZN13CGPIO_HandlerC2Ej():
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:6
#include <hal/peripherals.h>
#include <drivers/gpio.h>

CGPIO_Handler sGPIO(hal::GPIO_Base);

CGPIO_Handler::CGPIO_Handler(unsigned int gpio_base_addr)
    80f0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    80f4:	e28db000 	add	fp, sp, #0
    80f8:	e24dd00c 	sub	sp, sp, #12
    80fc:	e50b0008 	str	r0, [fp, #-8]
    8100:	e50b100c 	str	r1, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:7
	: mGPIO(reinterpret_cast<unsigned int*>(gpio_base_addr))
    8104:	e51b200c 	ldr	r2, [fp, #-12]
    8108:	e51b3008 	ldr	r3, [fp, #-8]
    810c:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:10
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
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:13

bool CGPIO_Handler::Get_GPFSEL_Location(uint32_t pin, uint32_t& reg, uint32_t& bit_idx) const
{
    8124:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8128:	e28db000 	add	fp, sp, #0
    812c:	e24dd014 	sub	sp, sp, #20
    8130:	e50b0008 	str	r0, [fp, #-8]
    8134:	e50b100c 	str	r1, [fp, #-12]
    8138:	e50b2010 	str	r2, [fp, #-16]
    813c:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:14
	if (pin > hal::GPIO_Pin_Count)
    8140:	e51b300c 	ldr	r3, [fp, #-12]
    8144:	e3530036 	cmp	r3, #54	; 0x36
    8148:	9a000001 	bls	8154 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0x30>
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:15
		return false;
    814c:	e3a03000 	mov	r3, #0
    8150:	ea000033 	b	8224 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0x100>
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:17
	
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
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:19
	{
		case 0: reg = static_cast<uint32_t>(hal::GPIO_Reg::GPFSEL0); break;
    8188:	e51b3010 	ldr	r3, [fp, #-16]
    818c:	e3a02000 	mov	r2, #0
    8190:	e5832000 	str	r2, [r3]
    8194:	ea000013 	b	81e8 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0xc4>
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:20
		case 1: reg = static_cast<uint32_t>(hal::GPIO_Reg::GPFSEL1); break;
    8198:	e51b3010 	ldr	r3, [fp, #-16]
    819c:	e3a02001 	mov	r2, #1
    81a0:	e5832000 	str	r2, [r3]
    81a4:	ea00000f 	b	81e8 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0xc4>
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:21
		case 2: reg = static_cast<uint32_t>(hal::GPIO_Reg::GPFSEL2); break;
    81a8:	e51b3010 	ldr	r3, [fp, #-16]
    81ac:	e3a02002 	mov	r2, #2
    81b0:	e5832000 	str	r2, [r3]
    81b4:	ea00000b 	b	81e8 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0xc4>
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:22
		case 3: reg = static_cast<uint32_t>(hal::GPIO_Reg::GPFSEL3); break;
    81b8:	e51b3010 	ldr	r3, [fp, #-16]
    81bc:	e3a02003 	mov	r2, #3
    81c0:	e5832000 	str	r2, [r3]
    81c4:	ea000007 	b	81e8 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0xc4>
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:23
		case 4: reg = static_cast<uint32_t>(hal::GPIO_Reg::GPFSEL4); break;
    81c8:	e51b3010 	ldr	r3, [fp, #-16]
    81cc:	e3a02004 	mov	r2, #4
    81d0:	e5832000 	str	r2, [r3]
    81d4:	ea000003 	b	81e8 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0xc4>
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:24
		case 5: reg = static_cast<uint32_t>(hal::GPIO_Reg::GPFSEL5); break;
    81d8:	e51b3010 	ldr	r3, [fp, #-16]
    81dc:	e3a02005 	mov	r2, #5
    81e0:	e5832000 	str	r2, [r3]
    81e4:	e320f000 	nop	{0}
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:27
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
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:29
	
	return true;
    8220:	e3a03001 	mov	r3, #1
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:30
}
    8224:	e1a00003 	mov	r0, r3
    8228:	e28bd000 	add	sp, fp, #0
    822c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8230:	e12fff1e 	bx	lr
    8234:	cccccccd 	stclgt	12, cr12, [ip], {205}	; 0xcd

00008238 <_ZNK13CGPIO_Handler18Get_GPCLR_LocationEjRjS0_>:
_ZNK13CGPIO_Handler18Get_GPCLR_LocationEjRjS0_():
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:33

bool CGPIO_Handler::Get_GPCLR_Location(uint32_t pin, uint32_t& reg, uint32_t& bit_idx) const
{
    8238:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    823c:	e28db000 	add	fp, sp, #0
    8240:	e24dd014 	sub	sp, sp, #20
    8244:	e50b0008 	str	r0, [fp, #-8]
    8248:	e50b100c 	str	r1, [fp, #-12]
    824c:	e50b2010 	str	r2, [fp, #-16]
    8250:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:34
	if (pin > hal::GPIO_Pin_Count)
    8254:	e51b300c 	ldr	r3, [fp, #-12]
    8258:	e3530036 	cmp	r3, #54	; 0x36
    825c:	9a000001 	bls	8268 <_ZNK13CGPIO_Handler18Get_GPCLR_LocationEjRjS0_+0x30>
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:35
		return false;
    8260:	e3a03000 	mov	r3, #0
    8264:	ea00000c 	b	829c <_ZNK13CGPIO_Handler18Get_GPCLR_LocationEjRjS0_+0x64>
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:37
	
	reg = static_cast<uint32_t>((pin < 32) ? hal::GPIO_Reg::GPCLR0 : hal::GPIO_Reg::GPCLR1);
    8268:	e51b300c 	ldr	r3, [fp, #-12]
    826c:	e353001f 	cmp	r3, #31
    8270:	8a000001 	bhi	827c <_ZNK13CGPIO_Handler18Get_GPCLR_LocationEjRjS0_+0x44>
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:37 (discriminator 1)
    8274:	e3a0200a 	mov	r2, #10
    8278:	ea000000 	b	8280 <_ZNK13CGPIO_Handler18Get_GPCLR_LocationEjRjS0_+0x48>
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:37 (discriminator 2)
    827c:	e3a0200b 	mov	r2, #11
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:37 (discriminator 4)
    8280:	e51b3010 	ldr	r3, [fp, #-16]
    8284:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:38 (discriminator 4)
	bit_idx = pin % 32;
    8288:	e51b300c 	ldr	r3, [fp, #-12]
    828c:	e203201f 	and	r2, r3, #31
    8290:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8294:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:40 (discriminator 4)
	
	return true;
    8298:	e3a03001 	mov	r3, #1
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:41
}
    829c:	e1a00003 	mov	r0, r3
    82a0:	e28bd000 	add	sp, fp, #0
    82a4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    82a8:	e12fff1e 	bx	lr

000082ac <_ZNK13CGPIO_Handler18Get_GPSET_LocationEjRjS0_>:
_ZNK13CGPIO_Handler18Get_GPSET_LocationEjRjS0_():
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:44

bool CGPIO_Handler::Get_GPSET_Location(uint32_t pin, uint32_t& reg, uint32_t& bit_idx) const
{
    82ac:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    82b0:	e28db000 	add	fp, sp, #0
    82b4:	e24dd014 	sub	sp, sp, #20
    82b8:	e50b0008 	str	r0, [fp, #-8]
    82bc:	e50b100c 	str	r1, [fp, #-12]
    82c0:	e50b2010 	str	r2, [fp, #-16]
    82c4:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:45
	if (pin > hal::GPIO_Pin_Count)
    82c8:	e51b300c 	ldr	r3, [fp, #-12]
    82cc:	e3530036 	cmp	r3, #54	; 0x36
    82d0:	9a000001 	bls	82dc <_ZNK13CGPIO_Handler18Get_GPSET_LocationEjRjS0_+0x30>
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:46
		return false;
    82d4:	e3a03000 	mov	r3, #0
    82d8:	ea00000c 	b	8310 <_ZNK13CGPIO_Handler18Get_GPSET_LocationEjRjS0_+0x64>
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:48
	
	reg = static_cast<uint32_t>((pin < 32) ? hal::GPIO_Reg::GPSET0 : hal::GPIO_Reg::GPSET1);
    82dc:	e51b300c 	ldr	r3, [fp, #-12]
    82e0:	e353001f 	cmp	r3, #31
    82e4:	8a000001 	bhi	82f0 <_ZNK13CGPIO_Handler18Get_GPSET_LocationEjRjS0_+0x44>
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:48 (discriminator 1)
    82e8:	e3a02007 	mov	r2, #7
    82ec:	ea000000 	b	82f4 <_ZNK13CGPIO_Handler18Get_GPSET_LocationEjRjS0_+0x48>
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:48 (discriminator 2)
    82f0:	e3a02008 	mov	r2, #8
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:48 (discriminator 4)
    82f4:	e51b3010 	ldr	r3, [fp, #-16]
    82f8:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:49 (discriminator 4)
	bit_idx = pin % 32;
    82fc:	e51b300c 	ldr	r3, [fp, #-12]
    8300:	e203201f 	and	r2, r3, #31
    8304:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8308:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:51 (discriminator 4)
	
	return true;
    830c:	e3a03001 	mov	r3, #1
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:52
}
    8310:	e1a00003 	mov	r0, r3
    8314:	e28bd000 	add	sp, fp, #0
    8318:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    831c:	e12fff1e 	bx	lr

00008320 <_ZNK13CGPIO_Handler18Get_GPLEV_LocationEjRjS0_>:
_ZNK13CGPIO_Handler18Get_GPLEV_LocationEjRjS0_():
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:55

bool CGPIO_Handler::Get_GPLEV_Location(uint32_t pin, uint32_t& reg, uint32_t& bit_idx) const
{
    8320:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8324:	e28db000 	add	fp, sp, #0
    8328:	e24dd014 	sub	sp, sp, #20
    832c:	e50b0008 	str	r0, [fp, #-8]
    8330:	e50b100c 	str	r1, [fp, #-12]
    8334:	e50b2010 	str	r2, [fp, #-16]
    8338:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:56
	if (pin > hal::GPIO_Pin_Count)
    833c:	e51b300c 	ldr	r3, [fp, #-12]
    8340:	e3530036 	cmp	r3, #54	; 0x36
    8344:	9a000001 	bls	8350 <_ZNK13CGPIO_Handler18Get_GPLEV_LocationEjRjS0_+0x30>
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:57
		return false;
    8348:	e3a03000 	mov	r3, #0
    834c:	ea00000c 	b	8384 <_ZNK13CGPIO_Handler18Get_GPLEV_LocationEjRjS0_+0x64>
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:59
	
	reg = static_cast<uint32_t>((pin < 32) ? hal::GPIO_Reg::GPLEV0 : hal::GPIO_Reg::GPLEV1);
    8350:	e51b300c 	ldr	r3, [fp, #-12]
    8354:	e353001f 	cmp	r3, #31
    8358:	8a000001 	bhi	8364 <_ZNK13CGPIO_Handler18Get_GPLEV_LocationEjRjS0_+0x44>
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:59 (discriminator 1)
    835c:	e3a0200d 	mov	r2, #13
    8360:	ea000000 	b	8368 <_ZNK13CGPIO_Handler18Get_GPLEV_LocationEjRjS0_+0x48>
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:59 (discriminator 2)
    8364:	e3a0200e 	mov	r2, #14
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:59 (discriminator 4)
    8368:	e51b3010 	ldr	r3, [fp, #-16]
    836c:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:60 (discriminator 4)
	bit_idx = pin % 32;
    8370:	e51b300c 	ldr	r3, [fp, #-12]
    8374:	e203201f 	and	r2, r3, #31
    8378:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    837c:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:62 (discriminator 4)
	
	return true;
    8380:	e3a03001 	mov	r3, #1
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:63
}
    8384:	e1a00003 	mov	r0, r3
    8388:	e28bd000 	add	sp, fp, #0
    838c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8390:	e12fff1e 	bx	lr

00008394 <_ZN13CGPIO_Handler17Set_GPIO_FunctionEj14NGPIO_Function>:
_ZN13CGPIO_Handler17Set_GPIO_FunctionEj14NGPIO_Function():
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:66
		
void CGPIO_Handler::Set_GPIO_Function(uint32_t pin, NGPIO_Function func)
{
    8394:	e92d4800 	push	{fp, lr}
    8398:	e28db004 	add	fp, sp, #4
    839c:	e24dd018 	sub	sp, sp, #24
    83a0:	e50b0010 	str	r0, [fp, #-16]
    83a4:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    83a8:	e1a03002 	mov	r3, r2
    83ac:	e54b3015 	strb	r3, [fp, #-21]	; 0xffffffeb
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:68
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
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:71
		return;
	
	mGPIO[reg] = (mGPIO[reg] & (~static_cast<unsigned int>(7 << bit)) )
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
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:72
				| (static_cast<unsigned int>(func) << bit);
    8404:	e55b2015 	ldrb	r2, [fp, #-21]	; 0xffffffeb
    8408:	e51b300c 	ldr	r3, [fp, #-12]
    840c:	e1a02312 	lsl	r2, r2, r3
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:71
	mGPIO[reg] = (mGPIO[reg] & (~static_cast<unsigned int>(7 << bit)) )
    8410:	e51b3010 	ldr	r3, [fp, #-16]
    8414:	e5930000 	ldr	r0, [r3]
    8418:	e51b3008 	ldr	r3, [fp, #-8]
    841c:	e1a03103 	lsl	r3, r3, #2
    8420:	e0803003 	add	r3, r0, r3
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:72
				| (static_cast<unsigned int>(func) << bit);
    8424:	e1812002 	orr	r2, r1, r2
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:71
	mGPIO[reg] = (mGPIO[reg] & (~static_cast<unsigned int>(7 << bit)) )
    8428:	e5832000 	str	r2, [r3]
    842c:	ea000000 	b	8434 <_ZN13CGPIO_Handler17Set_GPIO_FunctionEj14NGPIO_Function+0xa0>
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:69
		return;
    8430:	e320f000 	nop	{0}
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:73
}
    8434:	e24bd004 	sub	sp, fp, #4
    8438:	e8bd8800 	pop	{fp, pc}

0000843c <_ZNK13CGPIO_Handler17Get_GPIO_FunctionEj>:
_ZNK13CGPIO_Handler17Get_GPIO_FunctionEj():
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:76

NGPIO_Function CGPIO_Handler::Get_GPIO_Function(uint32_t pin) const
{
    843c:	e92d4800 	push	{fp, lr}
    8440:	e28db004 	add	fp, sp, #4
    8444:	e24dd010 	sub	sp, sp, #16
    8448:	e50b0010 	str	r0, [fp, #-16]
    844c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:78
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
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:79
		return NGPIO_Function::Unspecified;
    8478:	e3a03008 	mov	r3, #8
    847c:	ea00000a 	b	84ac <_ZNK13CGPIO_Handler17Get_GPIO_FunctionEj+0x70>
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:81
	
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
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:82 (discriminator 1)
}
    84ac:	e1a00003 	mov	r0, r3
    84b0:	e24bd004 	sub	sp, fp, #4
    84b4:	e8bd8800 	pop	{fp, pc}

000084b8 <_ZN13CGPIO_Handler10Set_OutputEjb>:
_ZN13CGPIO_Handler10Set_OutputEjb():
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:85

void CGPIO_Handler::Set_Output(uint32_t pin, bool set)
{
    84b8:	e92d4800 	push	{fp, lr}
    84bc:	e28db004 	add	fp, sp, #4
    84c0:	e24dd018 	sub	sp, sp, #24
    84c4:	e50b0010 	str	r0, [fp, #-16]
    84c8:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    84cc:	e1a03002 	mov	r3, r2
    84d0:	e54b3015 	strb	r3, [fp, #-21]	; 0xffffffeb
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:87
	uint32_t reg, bit;
	if (!(set && Get_GPSET_Location(pin, reg, bit)) && !(!set && Get_GPCLR_Location(pin, reg, bit)))
    84d4:	e55b3015 	ldrb	r3, [fp, #-21]	; 0xffffffeb
    84d8:	e2233001 	eor	r3, r3, #1
    84dc:	e6ef3073 	uxtb	r3, r3
    84e0:	e3530000 	cmp	r3, #0
    84e4:	1a000009 	bne	8510 <_ZN13CGPIO_Handler10Set_OutputEjb+0x58>
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:87 (discriminator 2)
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
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:87 (discriminator 3)
    8510:	e55b3015 	ldrb	r3, [fp, #-21]	; 0xffffffeb
    8514:	e3530000 	cmp	r3, #0
    8518:	1a000009 	bne	8544 <_ZN13CGPIO_Handler10Set_OutputEjb+0x8c>
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:87 (discriminator 6)
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
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:87 (discriminator 7)
    8544:	e3a03001 	mov	r3, #1
    8548:	ea000000 	b	8550 <_ZN13CGPIO_Handler10Set_OutputEjb+0x98>
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:87 (discriminator 8)
    854c:	e3a03000 	mov	r3, #0
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:87 (discriminator 10)
    8550:	e3530000 	cmp	r3, #0
    8554:	1a00000a 	bne	8584 <_ZN13CGPIO_Handler10Set_OutputEjb+0xcc>
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:90
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
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:88
		return;
    8584:	e320f000 	nop	{0}
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:91
}
    8588:	e24bd004 	sub	sp, fp, #4
    858c:	e8bd8800 	pop	{fp, pc}

00008590 <_Z41__static_initialization_and_destruction_0ii>:
_Z41__static_initialization_and_destruction_0ii():
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:91
    8590:	e92d4800 	push	{fp, lr}
    8594:	e28db004 	add	fp, sp, #4
    8598:	e24dd008 	sub	sp, sp, #8
    859c:	e50b0008 	str	r0, [fp, #-8]
    85a0:	e50b100c 	str	r1, [fp, #-12]
    85a4:	e51b3008 	ldr	r3, [fp, #-8]
    85a8:	e3530001 	cmp	r3, #1
    85ac:	1a000006 	bne	85cc <_Z41__static_initialization_and_destruction_0ii+0x3c>
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:91 (discriminator 1)
    85b0:	e51b300c 	ldr	r3, [fp, #-12]
    85b4:	e59f201c 	ldr	r2, [pc, #28]	; 85d8 <_Z41__static_initialization_and_destruction_0ii+0x48>
    85b8:	e1530002 	cmp	r3, r2
    85bc:	1a000002 	bne	85cc <_Z41__static_initialization_and_destruction_0ii+0x3c>
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:4
CGPIO_Handler sGPIO(hal::GPIO_Base);
    85c0:	e59f1014 	ldr	r1, [pc, #20]	; 85dc <_Z41__static_initialization_and_destruction_0ii+0x4c>
    85c4:	e59f0014 	ldr	r0, [pc, #20]	; 85e0 <_Z41__static_initialization_and_destruction_0ii+0x50>
    85c8:	ebfffec8 	bl	80f0 <_ZN13CGPIO_HandlerC1Ej>
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:91
}
    85cc:	e320f000 	nop	{0}
    85d0:	e24bd004 	sub	sp, fp, #4
    85d4:	e8bd8800 	pop	{fp, pc}
    85d8:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>
    85dc:	20200000 	eorcs	r0, r0, r0
    85e0:	0000882c 	andeq	r8, r0, ip, lsr #16

000085e4 <_GLOBAL__sub_I_sGPIO>:
_GLOBAL__sub_I_sGPIO():
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/drivers/gpio.cpp:91
    85e4:	e92d4800 	push	{fp, lr}
    85e8:	e28db004 	add	fp, sp, #4
    85ec:	e59f1008 	ldr	r1, [pc, #8]	; 85fc <_GLOBAL__sub_I_sGPIO+0x18>
    85f0:	e3a00001 	mov	r0, #1
    85f4:	ebffffe5 	bl	8590 <_Z41__static_initialization_and_destruction_0ii>
    85f8:	e8bd8800 	pop	{fp, pc}
    85fc:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>

00008600 <_kernel_main>:
_kernel_main():
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/main.cpp:7

// GPIO pin 47 je pripojeny na LED na desce (tzv. ACT LED)
constexpr uint32_t ACT_Pin = 47;

extern "C" int _kernel_main(void)
{
    8600:	e92d4800 	push	{fp, lr}
    8604:	e28db004 	add	fp, sp, #4
    8608:	e24dd008 	sub	sp, sp, #8
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/main.cpp:9
	// nastavime ACT LED pin na vystupni
	sGPIO.Set_GPIO_Function(ACT_Pin, NGPIO_Function::Output);
    860c:	e3a02001 	mov	r2, #1
    8610:	e3a0102f 	mov	r1, #47	; 0x2f
    8614:	e59f008c 	ldr	r0, [pc, #140]	; 86a8 <_kernel_main+0xa8>
    8618:	ebffff5d 	bl	8394 <_ZN13CGPIO_Handler17Set_GPIO_FunctionEj14NGPIO_Function>
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/main.cpp:16
	volatile unsigned int tim;
	
    while (1)
    {
		// spalime 500000 taktu (cekani par milisekund)
        for(tim = 0; tim < 0x5000; tim++)
    861c:	e3a03000 	mov	r3, #0
    8620:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/main.cpp:16 (discriminator 3)
    8624:	e51b3008 	ldr	r3, [fp, #-8]
    8628:	e3530a05 	cmp	r3, #20480	; 0x5000
    862c:	33a03001 	movcc	r3, #1
    8630:	23a03000 	movcs	r3, #0
    8634:	e6ef3073 	uxtb	r3, r3
    8638:	e3530000 	cmp	r3, #0
    863c:	0a000003 	beq	8650 <_kernel_main+0x50>
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/main.cpp:16 (discriminator 2)
    8640:	e51b3008 	ldr	r3, [fp, #-8]
    8644:	e2833001 	add	r3, r3, #1
    8648:	e50b3008 	str	r3, [fp, #-8]
    864c:	eafffff4 	b	8624 <_kernel_main+0x24>
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/main.cpp:20
            ;
		
		// zhasneme LED
		sGPIO.Set_Output(ACT_Pin, true);
    8650:	e3a02001 	mov	r2, #1
    8654:	e3a0102f 	mov	r1, #47	; 0x2f
    8658:	e59f0048 	ldr	r0, [pc, #72]	; 86a8 <_kernel_main+0xa8>
    865c:	ebffff95 	bl	84b8 <_ZN13CGPIO_Handler10Set_OutputEjb>
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/main.cpp:23

		// opet cekani
        for(tim = 0; tim < 0x5000; tim++)
    8660:	e3a03000 	mov	r3, #0
    8664:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/main.cpp:23 (discriminator 3)
    8668:	e51b3008 	ldr	r3, [fp, #-8]
    866c:	e3530a05 	cmp	r3, #20480	; 0x5000
    8670:	33a03001 	movcc	r3, #1
    8674:	23a03000 	movcs	r3, #0
    8678:	e6ef3073 	uxtb	r3, r3
    867c:	e3530000 	cmp	r3, #0
    8680:	0a000003 	beq	8694 <_kernel_main+0x94>
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/main.cpp:23 (discriminator 2)
    8684:	e51b3008 	ldr	r3, [fp, #-8]
    8688:	e2833001 	add	r3, r3, #1
    868c:	e50b3008 	str	r3, [fp, #-8]
    8690:	eafffff4 	b	8668 <_kernel_main+0x68>
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/main.cpp:27
            ;

		// rozsvitime LED
		sGPIO.Set_Output(ACT_Pin, false);
    8694:	e3a02000 	mov	r2, #0
    8698:	e3a0102f 	mov	r1, #47	; 0x2f
    869c:	e59f0004 	ldr	r0, [pc, #4]	; 86a8 <_kernel_main+0xa8>
    86a0:	ebffff84 	bl	84b8 <_ZN13CGPIO_Handler10Set_OutputEjb>
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/main.cpp:16
        for(tim = 0; tim < 0x5000; tim++)
    86a4:	eaffffdc 	b	861c <_kernel_main+0x1c>
    86a8:	0000882c 	andeq	r8, r0, ip, lsr #16

000086ac <_c_startup>:
_c_startup():
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/startup.cpp:21
extern "C" dtor_ptr __DTOR_LIST__[0];
// konec pole destruktoru
extern "C" dtor_ptr __DTOR_END__[0];

extern "C" int _c_startup(void)
{
    86ac:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    86b0:	e28db000 	add	fp, sp, #0
    86b4:	e24dd00c 	sub	sp, sp, #12
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/startup.cpp:25
	int* i;
	
	// vynulujeme .bss sekci
	for (i = (int*)_bss_start; i < (int*)_bss_end; i++)
    86b8:	e59f304c 	ldr	r3, [pc, #76]	; 870c <_c_startup+0x60>
    86bc:	e5933000 	ldr	r3, [r3]
    86c0:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/startup.cpp:25 (discriminator 3)
    86c4:	e59f3044 	ldr	r3, [pc, #68]	; 8710 <_c_startup+0x64>
    86c8:	e5933000 	ldr	r3, [r3]
    86cc:	e1a02003 	mov	r2, r3
    86d0:	e51b3008 	ldr	r3, [fp, #-8]
    86d4:	e1530002 	cmp	r3, r2
    86d8:	2a000006 	bcs	86f8 <_c_startup+0x4c>
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/startup.cpp:26 (discriminator 2)
		*i = 0;
    86dc:	e51b3008 	ldr	r3, [fp, #-8]
    86e0:	e3a02000 	mov	r2, #0
    86e4:	e5832000 	str	r2, [r3]
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/startup.cpp:25 (discriminator 2)
	for (i = (int*)_bss_start; i < (int*)_bss_end; i++)
    86e8:	e51b3008 	ldr	r3, [fp, #-8]
    86ec:	e2833004 	add	r3, r3, #4
    86f0:	e50b3008 	str	r3, [fp, #-8]
    86f4:	eafffff2 	b	86c4 <_c_startup+0x18>
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/startup.cpp:28
	
	return 0;
    86f8:	e3a03000 	mov	r3, #0
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/startup.cpp:29
}
    86fc:	e1a00003 	mov	r0, r3
    8700:	e28bd000 	add	sp, fp, #0
    8704:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8708:	e12fff1e 	bx	lr
    870c:	0000882c 	andeq	r8, r0, ip, lsr #16
    8710:	00008840 	andeq	r8, r0, r0, asr #16

00008714 <_cpp_startup>:
_cpp_startup():
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/startup.cpp:32

extern "C" int _cpp_startup(void)
{
    8714:	e92d4800 	push	{fp, lr}
    8718:	e28db004 	add	fp, sp, #4
    871c:	e24dd008 	sub	sp, sp, #8
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/startup.cpp:37
	ctor_ptr* fnptr;
	
	// zavolame konstruktory globalnich C++ trid
	// v poli __CTOR_LIST__ jsou ukazatele na vygenerovane stuby volani konstruktoru
	for (fnptr = __CTOR_LIST__; fnptr < __CTOR_END__; fnptr++)
    8720:	e59f303c 	ldr	r3, [pc, #60]	; 8764 <_cpp_startup+0x50>
    8724:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/startup.cpp:37 (discriminator 3)
    8728:	e51b3008 	ldr	r3, [fp, #-8]
    872c:	e59f2034 	ldr	r2, [pc, #52]	; 8768 <_cpp_startup+0x54>
    8730:	e1530002 	cmp	r3, r2
    8734:	2a000006 	bcs	8754 <_cpp_startup+0x40>
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/startup.cpp:38 (discriminator 2)
		(*fnptr)();
    8738:	e51b3008 	ldr	r3, [fp, #-8]
    873c:	e5933000 	ldr	r3, [r3]
    8740:	e12fff33 	blx	r3
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/startup.cpp:37 (discriminator 2)
	for (fnptr = __CTOR_LIST__; fnptr < __CTOR_END__; fnptr++)
    8744:	e51b3008 	ldr	r3, [fp, #-8]
    8748:	e2833004 	add	r3, r3, #4
    874c:	e50b3008 	str	r3, [fp, #-8]
    8750:	eafffff4 	b	8728 <_cpp_startup+0x14>
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/startup.cpp:40
	
	return 0;
    8754:	e3a03000 	mov	r3, #0
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/startup.cpp:41
}
    8758:	e1a00003 	mov	r0, r3
    875c:	e24bd004 	sub	sp, fp, #4
    8760:	e8bd8800 	pop	{fp, pc}
    8764:	00008828 	andeq	r8, r0, r8, lsr #16
    8768:	0000882c 	andeq	r8, r0, ip, lsr #16

0000876c <_cpp_shutdown>:
_cpp_shutdown():
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/startup.cpp:44

extern "C" int _cpp_shutdown(void)
{
    876c:	e92d4800 	push	{fp, lr}
    8770:	e28db004 	add	fp, sp, #4
    8774:	e24dd008 	sub	sp, sp, #8
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/startup.cpp:48
	dtor_ptr* fnptr;
	
	// zavolame destruktory globalnich C++ trid
	for (fnptr = __DTOR_LIST__; fnptr < __DTOR_END__; fnptr++)
    8778:	e59f303c 	ldr	r3, [pc, #60]	; 87bc <_cpp_shutdown+0x50>
    877c:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/startup.cpp:48 (discriminator 3)
    8780:	e51b3008 	ldr	r3, [fp, #-8]
    8784:	e59f2034 	ldr	r2, [pc, #52]	; 87c0 <_cpp_shutdown+0x54>
    8788:	e1530002 	cmp	r3, r2
    878c:	2a000006 	bcs	87ac <_cpp_shutdown+0x40>
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/startup.cpp:49 (discriminator 2)
		(*fnptr)();
    8790:	e51b3008 	ldr	r3, [fp, #-8]
    8794:	e5933000 	ldr	r3, [r3]
    8798:	e12fff33 	blx	r3
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/startup.cpp:48 (discriminator 2)
	for (fnptr = __DTOR_LIST__; fnptr < __DTOR_END__; fnptr++)
    879c:	e51b3008 	ldr	r3, [fp, #-8]
    87a0:	e2833004 	add	r3, r3, #4
    87a4:	e50b3008 	str	r3, [fp, #-8]
    87a8:	eafffff4 	b	8780 <_cpp_shutdown+0x14>
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/startup.cpp:51
	
	return 0;
    87ac:	e3a03000 	mov	r3, #0
/home/silhavyj/School/ZeroMate/examples/LED_toggle/exercise_02/02_kernel/kernel/src/startup.cpp:52
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
       c:	0000004f 	andeq	r0, r0, pc, asr #32
      10:	00014504 	andeq	r4, r1, r4, lsl #10
      14:	00000000 	andeq	r0, r0, r0
      18:	00801800 	addeq	r1, r0, r0, lsl #16
      1c:	0000d800 	andeq	sp, r0, r0, lsl #16
      20:	00000000 	andeq	r0, r0, r0
      24:	01d30200 	bicseq	r0, r3, r0, lsl #4
      28:	29010000 	stmdbcs	r1, {}	; <UNPREDICTABLE>
      2c:	0080e411 	addeq	lr, r0, r1, lsl r4
      30:	00000c00 	andeq	r0, r0, r0, lsl #24
      34:	029c0100 	addseq	r0, ip, #0, 2
      38:	000001c0 	andeq	r0, r0, r0, asr #3
      3c:	cc112401 	cfldrsgt	mvf2, [r1], {1}
      40:	18000080 	stmdane	r0, {r7}
      44:	01000000 	mrseq	r0, (UNDEF: 0)
      48:	0138029c 	teqeq	r8, ip	; <illegal shifter operand>
      4c:	1f010000 	svcne	0x00010000
      50:	0080b411 	addeq	fp, r0, r1, lsl r4
      54:	00001800 	andeq	r1, r0, r0, lsl #16
      58:	029c0100 	addseq	r0, ip, #0, 2
      5c:	0000012b 	andeq	r0, r0, fp, lsr #2
      60:	9c111a01 			; <UNDEFINED> instruction: 0x9c111a01
      64:	18000080 	stmdane	r0, {r7}
      68:	01000000 	mrseq	r0, (UNDEF: 0)
      6c:	01b5039c 			; <UNDEFINED> instruction: 0x01b5039c
      70:	00020000 	andeq	r0, r2, r0
      74:	000000bb 	strheq	r0, [r0], -fp
      78:	00011904 	andeq	r1, r1, r4, lsl #18
      7c:	12140100 	andsne	r0, r4, #0, 2
      80:	0000008a 	andeq	r0, r0, sl, lsl #1
      84:	0000bb05 	andeq	fp, r0, r5, lsl #22
      88:	ea060000 	b	180090 <_bss_end+0x177850>
      8c:	01000001 	tsteq	r0, r1
      90:	00c11c04 	sbceq	r1, r1, r4, lsl #24
      94:	05040000 	streq	r0, [r4, #-0]
      98:	01000001 	tsteq	r0, r1
      9c:	00a8120f 	adceq	r1, r8, pc, lsl #4
      a0:	bb050000 	bllt	1400a8 <_bss_end+0x137868>
      a4:	00000000 	andeq	r0, r0, r0
      a8:	0001a107 	andeq	sl, r1, r7, lsl #2
      ac:	110a0100 	mrsne	r0, (UNDEF: 26)
      b0:	00000105 	andeq	r0, r0, r5, lsl #2
      b4:	0000bb05 	andeq	fp, r0, r5, lsl #22
      b8:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
      bc:	00008a04 	andeq	r8, r0, r4, lsl #20
      c0:	05080900 	streq	r0, [r8, #-2304]	; 0xfffff700
      c4:	000001f2 	strdeq	r0, [r0], -r2
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
      fc:	0000bb30 	andeq	fp, r0, r0, lsr fp
     100:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     104:	05040d00 	streq	r0, [r4, #-3328]	; 0xfffff300
     108:	00746e69 	rsbseq	r6, r4, r9, ror #28
     10c:	0000a80e 	andeq	sl, r0, lr, lsl #16
     110:	00801800 	addeq	r1, r0, r0, lsl #16
     114:	00003800 	andeq	r3, r0, r0, lsl #16
     118:	0c9c0100 	ldfeqs	f0, [ip], {0}
     11c:	0a010067 	beq	402c0 <_bss_end+0x37a80>
     120:	0000bb2f 	andeq	fp, r0, pc, lsr #22
     124:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     128:	066c0000 	strbteq	r0, [ip], -r0
     12c:	00040000 	andeq	r0, r4, r0
     130:	000000d0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     134:	004f0104 	subeq	r0, pc, r4, lsl #2
     138:	66040000 	strvs	r0, [r4], -r0
     13c:	00000005 	andeq	r0, r0, r5
     140:	f0000000 			; <UNDEFINED> instruction: 0xf0000000
     144:	10000080 	andne	r0, r0, r0, lsl #1
     148:	bd000005 	stclt	0, cr0, [r0, #-20]	; 0xffffffec
     14c:	02000000 	andeq	r0, r0, #0
     150:	039b0801 	orrseq	r0, fp, #65536	; 0x10000
     154:	02020000 	andeq	r0, r2, #0
     158:	00054705 	andeq	r4, r5, r5, lsl #14
     15c:	05040300 	streq	r0, [r4, #-768]	; 0xfffffd00
     160:	00746e69 	rsbseq	r6, r4, r9, ror #28
     164:	00049e04 	andeq	r9, r4, r4, lsl #28
     168:	07090200 	streq	r0, [r9, -r0, lsl #4]
     16c:	00000046 	andeq	r0, r0, r6, asr #32
     170:	92080102 	andls	r0, r8, #-2147483648	; 0x80000000
     174:	02000003 	andeq	r0, r0, #3
     178:	03d40702 	bicseq	r0, r4, #524288	; 0x80000
     17c:	51040000 	mrspl	r0, (UNDEF: 4)
     180:	02000005 	andeq	r0, r0, #5
     184:	0065070b 	rsbeq	r0, r5, fp, lsl #14
     188:	54050000 	strpl	r0, [r5], #-0
     18c:	02000000 	andeq	r0, r0, #0
     190:	0cb80704 	ldceq	7, cr0, [r8], #16
     194:	68060000 	stmdavs	r6, {}	; <UNPREDICTABLE>
     198:	03006c61 	movweq	r6, #3169	; 0xc61
     19c:	01630b07 	cmneq	r3, r7, lsl #22
     1a0:	5f070000 	svcpl	0x00070000
     1a4:	03000004 	movweq	r0, #4
     1a8:	016a1a0a 	cmneq	sl, sl, lsl #20
     1ac:	00000000 	andeq	r0, r0, r0
     1b0:	4e072000 	cdpmi	0, 0, cr2, cr7, cr0, {0}
     1b4:	03000006 	movweq	r0, #6
     1b8:	016a1a0d 	cmneq	sl, sp, lsl #20
     1bc:	00000000 	andeq	r0, r0, r0
     1c0:	e7082020 	str	r2, [r8, -r0, lsr #32]
     1c4:	03000003 	movweq	r0, #3
     1c8:	00601510 	rsbeq	r1, r0, r0, lsl r5
     1cc:	09360000 	ldmdbeq	r6!, {}	; <UNPREDICTABLE>
     1d0:	00000363 	andeq	r0, r0, r3, ror #6
     1d4:	00330405 	eorseq	r0, r3, r5, lsl #8
     1d8:	13030000 	movwne	r0, #12288	; 0x3000
     1dc:	062e0a0d 	strteq	r0, [lr], -sp, lsl #20
     1e0:	0a000000 	beq	1e8 <_start-0x7e18>
     1e4:	00000636 	andeq	r0, r0, r6, lsr r6
     1e8:	063e0a01 	ldrteq	r0, [lr], -r1, lsl #20
     1ec:	0a020000 	beq	801f4 <_bss_end+0x779b4>
     1f0:	00000646 	andeq	r0, r0, r6, asr #12
     1f4:	04570a03 	ldrbeq	r0, [r7], #-2563	; 0xfffff5fd
     1f8:	0a040000 	beq	100200 <_bss_end+0xf79c0>
     1fc:	00000658 	andeq	r0, r0, r8, asr r6
     200:	03f60a05 	mvnseq	r0, #20480	; 0x5000
     204:	0a070000 	beq	1c020c <_bss_end+0x1b79cc>
     208:	000003fd 	strdeq	r0, [r0], -sp
     20c:	03cd0a08 	biceq	r0, sp, #8, 20	; 0x8000
     210:	0a0a0000 	beq	280218 <_bss_end+0x2779d8>
     214:	000002f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     218:	03720a0b 	cmneq	r2, #45056	; 0xb000
     21c:	0a0d0000 	beq	340224 <_bss_end+0x3379e4>
     220:	00000379 	andeq	r0, r0, r9, ror r3
     224:	04800a0e 	streq	r0, [r0], #2574	; 0xa0e
     228:	0a100000 	beq	400230 <_bss_end+0x3f79f0>
     22c:	00000487 	andeq	r0, r0, r7, lsl #9
     230:	02000a11 	andeq	r0, r0, #69632	; 0x11000
     234:	0a130000 	beq	4c023c <_bss_end+0x4b79fc>
     238:	00000207 	andeq	r0, r0, r7, lsl #4
     23c:	04440a14 	strbeq	r0, [r4], #-2580	; 0xfffff5ec
     240:	0a160000 	beq	580248 <_bss_end+0x577a08>
     244:	0000044b 	andeq	r0, r0, fp, asr #8
     248:	055f0a17 	ldrbeq	r0, [pc, #-2583]	; fffff839 <_bss_end+0xffff6ff9>
     24c:	0a190000 	beq	640254 <_bss_end+0x637a14>
     250:	0000024a 	andeq	r0, r0, sl, asr #4
     254:	05310a1a 	ldreq	r0, [r1, #-2586]!	; 0xfffff5e6
     258:	0a1c0000 	beq	700260 <_bss_end+0x6f7a20>
     25c:	00000538 	andeq	r0, r0, r8, lsr r5
     260:	048e0a1d 	streq	r0, [lr], #2589	; 0xa1d
     264:	0a1f0000 	beq	7c026c <_bss_end+0x7b7a2c>
     268:	00000496 	muleq	r0, r6, r4
     26c:	05290a20 	streq	r0, [r9, #-2592]!	; 0xfffff5e0
     270:	0a220000 	beq	880278 <_bss_end+0x877a38>
     274:	0000020e 	andeq	r0, r0, lr, lsl #4
     278:	038c0a23 	orreq	r0, ip, #143360	; 0x23000
     27c:	0a250000 	beq	940284 <_bss_end+0x937a44>
     280:	000003a0 	andeq	r0, r0, r0, lsr #7
     284:	03c30a26 	biceq	r0, r3, #155648	; 0x26000
     288:	00270000 	eoreq	r0, r7, r0
     28c:	07040200 	streq	r0, [r4, -r0, lsl #4]
     290:	00000cb3 			; <UNDEFINED> instruction: 0x00000cb3
     294:	00016305 	andeq	r6, r1, r5, lsl #6
     298:	00780b00 	rsbseq	r0, r8, r0, lsl #22
     29c:	880b0000 	stmdahi	fp, {}	; <UNPREDICTABLE>
     2a0:	0b000000 	bleq	2a8 <_start-0x7d58>
     2a4:	00000098 	muleq	r0, r8, r0
     2a8:	0004fd0c 	andeq	pc, r4, ip, lsl #26
     2ac:	3a010700 	bcc	41eb4 <_bss_end+0x39674>
     2b0:	04000000 	streq	r0, [r0], #-0
     2b4:	01c70c06 	biceq	r0, r7, r6, lsl #24
     2b8:	6f0a0000 	svcvs	0x000a0000
     2bc:	00000004 	andeq	r0, r0, r4
     2c0:	0002280a 	andeq	r2, r2, sl, lsl #16
     2c4:	0a0a0100 	beq	2806cc <_bss_end+0x277e8c>
     2c8:	02000004 	andeq	r0, r0, #4
     2cc:	0004040a 	andeq	r0, r4, sl, lsl #8
     2d0:	aa0a0300 	bge	280ed8 <_bss_end+0x278698>
     2d4:	04000003 	streq	r0, [r0], #-3
     2d8:	0003860a 	andeq	r8, r3, sl, lsl #12
     2dc:	800a0500 	andhi	r0, sl, r0, lsl #10
     2e0:	06000003 	streq	r0, [r0], -r3
     2e4:	00036c0a 	andeq	r6, r3, sl, lsl #24
     2e8:	2f0a0700 	svccs	0x000a0700
     2ec:	08000002 	stmdaeq	r0, {r1}
     2f0:	02160d00 	andseq	r0, r6, #0, 26
     2f4:	04040000 	streq	r0, [r4], #-0
     2f8:	0328071a 			; <UNDEFINED> instruction: 0x0328071a
     2fc:	230e0000 	movwcs	r0, #57344	; 0xe000
     300:	04000005 	streq	r0, [r0], #-5
     304:	0333171e 	teqeq	r3, #7864320	; 0x780000
     308:	0f000000 	svceq	0x00000000
     30c:	0000030c 	andeq	r0, r0, ip, lsl #6
     310:	20082204 	andcs	r2, r8, r4, lsl #4
     314:	38000003 	stmdacc	r0, {r0, r1}
     318:	02000003 	andeq	r0, r0, #3
     31c:	000001fa 	strdeq	r0, [r0], -sl
     320:	0000020f 	andeq	r0, r0, pc, lsl #4
     324:	00033f10 	andeq	r3, r3, r0, lsl pc
     328:	00541100 	subseq	r1, r4, r0, lsl #2
     32c:	4a110000 	bmi	440334 <_bss_end+0x437af4>
     330:	11000003 	tstne	r0, r3
     334:	0000034a 	andeq	r0, r0, sl, asr #6
     338:	03b00f00 	movseq	r0, #0, 30
     33c:	24040000 	strcs	r0, [r4], #-0
     340:	0002c108 	andeq	ip, r2, r8, lsl #2
     344:	00033800 	andeq	r3, r3, r0, lsl #16
     348:	02280200 	eoreq	r0, r8, #0, 4
     34c:	023d0000 	eorseq	r0, sp, #0
     350:	3f100000 	svccc	0x00100000
     354:	11000003 	tstne	r0, r3
     358:	00000054 	andeq	r0, r0, r4, asr r0
     35c:	00034a11 	andeq	r4, r3, r1, lsl sl
     360:	034a1100 	movteq	r1, #41216	; 0xa100
     364:	0f000000 	svceq	0x00000000
     368:	00000350 	andeq	r0, r0, r0, asr r3
     36c:	92082604 	andls	r2, r8, #4, 12	; 0x400000
     370:	38000002 	stmdacc	r0, {r1}
     374:	02000003 	andeq	r0, r0, #3
     378:	00000256 	andeq	r0, r0, r6, asr r2
     37c:	0000026b 	andeq	r0, r0, fp, ror #4
     380:	00033f10 	andeq	r3, r3, r0, lsl pc
     384:	00541100 	subseq	r1, r4, r0, lsl #2
     388:	4a110000 	bmi	440390 <_bss_end+0x437b50>
     38c:	11000003 	tstne	r0, r3
     390:	0000034a 	andeq	r0, r0, sl, asr #6
     394:	05f10f00 	ldrbeq	r0, [r1, #3840]!	; 0xf00
     398:	28040000 	stmdacs	r4, {}	; <UNPREDICTABLE>
     39c:	00025108 	andeq	r5, r2, r8, lsl #2
     3a0:	00033800 	andeq	r3, r3, r0, lsl #16
     3a4:	02840200 	addeq	r0, r4, #0, 4
     3a8:	02990000 	addseq	r0, r9, #0
     3ac:	3f100000 	svccc	0x00100000
     3b0:	11000003 	tstne	r0, r3
     3b4:	00000054 	andeq	r0, r0, r4, asr r0
     3b8:	00034a11 	andeq	r4, r3, r1, lsl sl
     3bc:	034a1100 	movteq	r1, #41216	; 0xa100
     3c0:	0f000000 	svceq	0x00000000
     3c4:	00000216 	andeq	r0, r0, r6, lsl r2
     3c8:	da032b04 	ble	cafe0 <_bss_end+0xc27a0>
     3cc:	50000005 	andpl	r0, r0, r5
     3d0:	01000003 	tsteq	r0, r3
     3d4:	000002b2 			; <UNDEFINED> instruction: 0x000002b2
     3d8:	000002bd 			; <UNDEFINED> instruction: 0x000002bd
     3dc:	00035010 	andeq	r5, r3, r0, lsl r0
     3e0:	00651100 	rsbeq	r1, r5, r0, lsl #2
     3e4:	12000000 	andne	r0, r0, #0
     3e8:	00000432 	andeq	r0, r0, r2, lsr r4
     3ec:	d4082e04 	strle	r2, [r8], #-3588	; 0xfffff1fc
     3f0:	01000004 	tsteq	r0, r4
     3f4:	000002d2 	ldrdeq	r0, [r0], -r2
     3f8:	000002e2 	andeq	r0, r0, r2, ror #5
     3fc:	00035010 	andeq	r5, r3, r0, lsl r0
     400:	00541100 	subseq	r1, r4, r0, lsl #2
     404:	7e110000 	cdpvc	0, 1, cr0, cr1, cr0, {0}
     408:	00000001 	andeq	r0, r0, r1
     40c:	0002800f 	andeq	r8, r2, pc
     410:	12300400 	eorsne	r0, r0, #0, 8
     414:	000004ab 	andeq	r0, r0, fp, lsr #9
     418:	0000017e 	andeq	r0, r0, lr, ror r1
     41c:	0002fb01 	andeq	pc, r2, r1, lsl #22
     420:	00030600 	andeq	r0, r3, r0, lsl #12
     424:	033f1000 	teqeq	pc, #0
     428:	54110000 	ldrpl	r0, [r1], #-0
     42c:	00000000 	andeq	r0, r0, r0
     430:	00022413 	andeq	r2, r2, r3, lsl r4
     434:	08330400 	ldmdaeq	r3!, {sl}
     438:	00000410 	andeq	r0, r0, r0, lsl r4
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
     464:	00055a02 	andeq	r5, r5, r2, lsl #20
     468:	28041400 	stmdacs	r4, {sl, ip}
     46c:	05000003 	streq	r0, [r0, #-3]
     470:	0000033f 	andeq	r0, r0, pc, lsr r3
     474:	00540415 	subseq	r0, r4, r5, lsl r4
     478:	04140000 	ldreq	r0, [r4], #-0
     47c:	000001c7 	andeq	r0, r0, r7, asr #3
     480:	00035005 	andeq	r5, r3, r5
     484:	03061600 	movweq	r1, #26112	; 0x6600
     488:	37040000 	strcc	r0, [r4, -r0]
     48c:	0001c716 	andeq	ip, r1, r6, lsl r7
     490:	035b1700 	cmpeq	fp, #0, 14
     494:	04010000 	streq	r0, [r1], #-0
     498:	2c03050f 	cfstr32cs	mvfx0, [r3], {15}
     49c:	18000088 	stmdane	r0, {r3, r7}
     4a0:	000002f7 	strdeq	r0, [r0], -r7
     4a4:	000085e4 	andeq	r8, r0, r4, ror #11
     4a8:	0000001c 	andeq	r0, r0, ip, lsl r0
     4ac:	04199c01 	ldreq	r9, [r9], #-3073	; 0xfffff3ff
     4b0:	90000006 	andls	r0, r0, r6
     4b4:	54000085 	strpl	r0, [r0], #-133	; 0xffffff7b
     4b8:	01000000 	mrseq	r0, (UNDEF: 0)
     4bc:	0003b69c 	muleq	r3, ip, r6
     4c0:	05cb1a00 	strbeq	r1, [fp, #2560]	; 0xa00
     4c4:	5b010000 	blpl	404cc <_bss_end+0x37c8c>
     4c8:	00003301 	andeq	r3, r0, r1, lsl #6
     4cc:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     4d0:	0004751a 	andeq	r7, r4, sl, lsl r5
     4d4:	015b0100 	cmpeq	fp, r0, lsl #2
     4d8:	00000033 	andeq	r0, r0, r3, lsr r0
     4dc:	00709102 	rsbseq	r9, r0, r2, lsl #2
     4e0:	0003061b 	andeq	r0, r3, fp, lsl r6
     4e4:	06540100 	ldrbeq	r0, [r4], -r0, lsl #2
     4e8:	000003d0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     4ec:	000084b8 			; <UNDEFINED> instruction: 0x000084b8
     4f0:	000000d8 	ldrdeq	r0, [r0], -r8
     4f4:	04199c01 	ldreq	r9, [r9], #-3073	; 0xfffff3ff
     4f8:	a61c0000 	ldrge	r0, [ip], -r0
     4fc:	56000004 	strpl	r0, [r0], -r4
     500:	02000003 	andeq	r0, r0, #3
     504:	701d6c91 	mulsvc	sp, r1, ip
     508:	01006e69 	tsteq	r0, r9, ror #28
     50c:	00542954 	subseq	r2, r4, r4, asr r9
     510:	91020000 	mrsls	r0, (UNDEF: 2)
     514:	65731d68 	ldrbvs	r1, [r3, #-3432]!	; 0xfffff298
     518:	54010074 	strpl	r0, [r1], #-116	; 0xffffff8c
     51c:	00033833 	andeq	r3, r3, r3, lsr r8
     520:	67910200 	ldrvs	r0, [r1, r0, lsl #4]
     524:	6765721e 			; <UNDEFINED> instruction: 0x6765721e
     528:	0b560100 	bleq	1580930 <_bss_end+0x15780f0>
     52c:	00000054 	andeq	r0, r0, r4, asr r0
     530:	1e749102 	expnes	f1, f2
     534:	00746962 	rsbseq	r6, r4, r2, ror #18
     538:	54105601 	ldrpl	r5, [r0], #-1537	; 0xfffff9ff
     53c:	02000000 	andeq	r0, r0, #0
     540:	1b007091 	blne	1c78c <_bss_end+0x13f4c>
     544:	000002e2 	andeq	r0, r0, r2, ror #5
     548:	33104b01 	tstcc	r0, #1024	; 0x400
     54c:	3c000004 	stccc	0, cr0, [r0], {4}
     550:	7c000084 	stcvc	0, cr0, [r0], {132}	; 0x84
     554:	01000000 	mrseq	r0, (UNDEF: 0)
     558:	00046d9c 	muleq	r4, ip, sp
     55c:	04a61c00 	strteq	r1, [r6], #3072	; 0xc00
     560:	03450000 	movteq	r0, #20480	; 0x5000
     564:	91020000 	mrsls	r0, (UNDEF: 2)
     568:	69701d6c 	ldmdbvs	r0!, {r2, r3, r5, r6, r8, sl, fp, ip}^
     56c:	4b01006e 	blmi	4072c <_bss_end+0x37eec>
     570:	0000543a 	andeq	r5, r0, sl, lsr r4
     574:	68910200 	ldmvs	r1, {r9}
     578:	6765721e 			; <UNDEFINED> instruction: 0x6765721e
     57c:	0b4d0100 	bleq	1340984 <_bss_end+0x1338144>
     580:	00000054 	andeq	r0, r0, r4, asr r0
     584:	1e749102 	expnes	f1, f2
     588:	00746962 	rsbseq	r6, r4, r2, ror #18
     58c:	54104d01 	ldrpl	r4, [r0], #-3329	; 0xfffff2ff
     590:	02000000 	andeq	r0, r0, #0
     594:	1b007091 	blne	1c7e0 <_bss_end+0x13fa0>
     598:	000002bd 			; <UNDEFINED> instruction: 0x000002bd
     59c:	87064101 	strhi	r4, [r6, -r1, lsl #2]
     5a0:	94000004 	strls	r0, [r0], #-4
     5a4:	a8000083 	stmdage	r0, {r0, r1, r7}
     5a8:	01000000 	mrseq	r0, (UNDEF: 0)
     5ac:	0004d09c 	muleq	r4, ip, r0
     5b0:	04a61c00 	strteq	r1, [r6], #3072	; 0xc00
     5b4:	03560000 	cmpeq	r6, #0
     5b8:	91020000 	mrsls	r0, (UNDEF: 2)
     5bc:	69701d6c 	ldmdbvs	r0!, {r2, r3, r5, r6, r8, sl, fp, ip}^
     5c0:	4101006e 	tstmi	r1, lr, rrx
     5c4:	00005430 	andeq	r5, r0, r0, lsr r4
     5c8:	68910200 	ldmvs	r1, {r9}
     5cc:	0004521a 	andeq	r5, r4, sl, lsl r2
     5d0:	44410100 	strbmi	r0, [r1], #-256	; 0xffffff00
     5d4:	0000017e 	andeq	r0, r0, lr, ror r1
     5d8:	1e679102 	lgnnes	f1, f2
     5dc:	00676572 	rsbeq	r6, r7, r2, ror r5
     5e0:	540b4301 	strpl	r4, [fp], #-769	; 0xfffffcff
     5e4:	02000000 	andeq	r0, r0, #0
     5e8:	621e7491 	andsvs	r7, lr, #-1862270976	; 0x91000000
     5ec:	01007469 	tsteq	r0, r9, ror #8
     5f0:	00541043 	subseq	r1, r4, r3, asr #32
     5f4:	91020000 	mrsls	r0, (UNDEF: 2)
     5f8:	6b1f0070 	blvs	7c07c0 <_bss_end+0x7b7f80>
     5fc:	01000002 	tsteq	r0, r2
     600:	04ea0636 	strbteq	r0, [sl], #1590	; 0x636
     604:	83200000 	nophi	{0}	; <UNPREDICTABLE>
     608:	00740000 	rsbseq	r0, r4, r0
     60c:	9c010000 	stcls	0, cr0, [r1], {-0}
     610:	00000524 	andeq	r0, r0, r4, lsr #10
     614:	0004a61c 	andeq	sl, r4, ip, lsl r6
     618:	00034500 	andeq	r4, r3, r0, lsl #10
     61c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     620:	6e69701d 	mcrvs	0, 3, r7, cr9, cr13, {0}
     624:	31360100 	teqcc	r6, r0, lsl #2
     628:	00000054 	andeq	r0, r0, r4, asr r0
     62c:	1d709102 	ldfnep	f1, [r0, #-8]!
     630:	00676572 	rsbeq	r6, r7, r2, ror r5
     634:	4a403601 	bmi	100de40 <_bss_end+0x1005600>
     638:	02000003 	andeq	r0, r0, #3
     63c:	3f1a6c91 	svccc	0x001a6c91
     640:	01000005 	tsteq	r0, r5
     644:	034a4f36 	movteq	r4, #44854	; 0xaf36
     648:	91020000 	mrsls	r0, (UNDEF: 2)
     64c:	3d1f0068 	ldccc	0, cr0, [pc, #-416]	; 4b4 <_start-0x7b4c>
     650:	01000002 	tsteq	r0, r2
     654:	053e062b 	ldreq	r0, [lr, #-1579]!	; 0xfffff9d5
     658:	82ac0000 	adchi	r0, ip, #0
     65c:	00740000 	rsbseq	r0, r4, r0
     660:	9c010000 	stcls	0, cr0, [r1], {-0}
     664:	00000578 	andeq	r0, r0, r8, ror r5
     668:	0004a61c 	andeq	sl, r4, ip, lsl r6
     66c:	00034500 	andeq	r4, r3, r0, lsl #10
     670:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     674:	6e69701d 	mcrvs	0, 3, r7, cr9, cr13, {0}
     678:	312b0100 			; <UNDEFINED> instruction: 0x312b0100
     67c:	00000054 	andeq	r0, r0, r4, asr r0
     680:	1d709102 	ldfnep	f1, [r0, #-8]!
     684:	00676572 	rsbeq	r6, r7, r2, ror r5
     688:	4a402b01 	bmi	100b294 <_bss_end+0x1002a54>
     68c:	02000003 	andeq	r0, r0, #3
     690:	3f1a6c91 	svccc	0x001a6c91
     694:	01000005 	tsteq	r0, r5
     698:	034a4f2b 	movteq	r4, #44843	; 0xaf2b
     69c:	91020000 	mrsls	r0, (UNDEF: 2)
     6a0:	0f1f0068 	svceq	0x001f0068
     6a4:	01000002 	tsteq	r0, r2
     6a8:	05920620 	ldreq	r0, [r2, #1568]	; 0x620
     6ac:	82380000 	eorshi	r0, r8, #0
     6b0:	00740000 	rsbseq	r0, r4, r0
     6b4:	9c010000 	stcls	0, cr0, [r1], {-0}
     6b8:	000005cc 	andeq	r0, r0, ip, asr #11
     6bc:	0004a61c 	andeq	sl, r4, ip, lsl r6
     6c0:	00034500 	andeq	r4, r3, r0, lsl #10
     6c4:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     6c8:	6e69701d 	mcrvs	0, 3, r7, cr9, cr13, {0}
     6cc:	31200100 			; <UNDEFINED> instruction: 0x31200100
     6d0:	00000054 	andeq	r0, r0, r4, asr r0
     6d4:	1d709102 	ldfnep	f1, [r0, #-8]!
     6d8:	00676572 	rsbeq	r6, r7, r2, ror r5
     6dc:	4a402001 	bmi	10086e8 <_bss_end+0xfffea8>
     6e0:	02000003 	andeq	r0, r0, #3
     6e4:	3f1a6c91 	svccc	0x001a6c91
     6e8:	01000005 	tsteq	r0, r5
     6ec:	034a4f20 	movteq	r4, #44832	; 0xaf20
     6f0:	91020000 	mrsls	r0, (UNDEF: 2)
     6f4:	e11f0068 	tst	pc, r8, rrx
     6f8:	01000001 	tsteq	r0, r1
     6fc:	05e6060c 	strbeq	r0, [r6, #1548]!	; 0x60c
     700:	81240000 			; <UNDEFINED> instruction: 0x81240000
     704:	01140000 	tsteq	r4, r0
     708:	9c010000 	stcls	0, cr0, [r1], {-0}
     70c:	00000620 	andeq	r0, r0, r0, lsr #12
     710:	0004a61c 	andeq	sl, r4, ip, lsl r6
     714:	00034500 	andeq	r4, r3, r0, lsl #10
     718:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     71c:	6e69701d 	mcrvs	0, 3, r7, cr9, cr13, {0}
     720:	320c0100 	andcc	r0, ip, #0, 2
     724:	00000054 	andeq	r0, r0, r4, asr r0
     728:	1d709102 	ldfnep	f1, [r0, #-8]!
     72c:	00676572 	rsbeq	r6, r7, r2, ror r5
     730:	4a410c01 	bmi	104373c <_bss_end+0x103aefc>
     734:	02000003 	andeq	r0, r0, #3
     738:	3f1a6c91 	svccc	0x001a6c91
     73c:	01000005 	tsteq	r0, r5
     740:	034a500c 	movteq	r5, #40972	; 0xa00c
     744:	91020000 	mrsls	r0, (UNDEF: 2)
     748:	99200068 	stmdbls	r0!, {r3, r5, r6}
     74c:	01000002 	tsteq	r0, r2
     750:	06310106 	ldrteq	r0, [r1], -r6, lsl #2
     754:	47000000 	strmi	r0, [r0, -r0]
     758:	21000006 	tstcs	r0, r6
     75c:	000004a6 	andeq	r0, r0, r6, lsr #9
     760:	00000356 	andeq	r0, r0, r6, asr r3
     764:	00023b22 	andeq	r3, r2, r2, lsr #22
     768:	2b060100 	blcs	180b70 <_bss_end+0x178330>
     76c:	00000065 	andeq	r0, r0, r5, rrx
     770:	06202300 	strteq	r2, [r0], -r0, lsl #6
     774:	050c0000 	streq	r0, [ip, #-0]
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
     7a4:	004f0104 	subeq	r0, pc, r4, lsl #2
     7a8:	60040000 	andvs	r0, r4, r0
     7ac:	00000006 	andeq	r0, r0, r6
     7b0:	00000000 	andeq	r0, r0, r0
     7b4:	ac000086 	stcge	0, cr0, [r0], {134}	; 0x86
     7b8:	e2000000 	and	r0, r0, #0
     7bc:	02000003 	andeq	r0, r0, #3
     7c0:	039b0801 	orrseq	r0, fp, #65536	; 0x10000
     7c4:	02020000 	andeq	r0, r2, #0
     7c8:	00054705 	andeq	r4, r5, r5, lsl #14
     7cc:	05040300 	streq	r0, [r4, #-768]	; 0xfffffd00
     7d0:	00746e69 	rsbseq	r6, r4, r9, ror #28
     7d4:	00049e04 	andeq	r9, r4, r4, lsl #28
     7d8:	07090200 	streq	r0, [r9, -r0, lsl #4]
     7dc:	00000046 	andeq	r0, r0, r6, asr #32
     7e0:	92080102 	andls	r0, r8, #-2147483648	; 0x80000000
     7e4:	02000003 	andeq	r0, r0, #3
     7e8:	03d40702 	bicseq	r0, r4, #524288	; 0x80000
     7ec:	51040000 	mrspl	r0, (UNDEF: 4)
     7f0:	02000005 	andeq	r0, r0, #5
     7f4:	0065070b 	rsbeq	r0, r5, fp, lsl #14
     7f8:	54050000 	strpl	r0, [r5], #-0
     7fc:	02000000 	andeq	r0, r0, #0
     800:	0cb80704 	ldceq	7, cr0, [r8], #16
     804:	65060000 	strvs	r0, [r6, #-0]
     808:	07000000 	streq	r0, [r0, -r0]
     80c:	000004fd 	strdeq	r0, [r0], -sp
     810:	003a0107 	eorseq	r0, sl, r7, lsl #2
     814:	06030000 	streq	r0, [r3], -r0
     818:	0000ba0c 	andeq	fp, r0, ip, lsl #20
     81c:	046f0800 	strbteq	r0, [pc], #-2048	; 824 <_start-0x77dc>
     820:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
     824:	00000228 	andeq	r0, r0, r8, lsr #4
     828:	040a0801 	streq	r0, [sl], #-2049	; 0xfffff7ff
     82c:	08020000 	stmdaeq	r2, {}	; <UNPREDICTABLE>
     830:	00000404 	andeq	r0, r0, r4, lsl #8
     834:	03aa0803 			; <UNDEFINED> instruction: 0x03aa0803
     838:	08040000 	stmdaeq	r4, {}	; <UNPREDICTABLE>
     83c:	00000386 	andeq	r0, r0, r6, lsl #7
     840:	03800805 	orreq	r0, r0, #327680	; 0x50000
     844:	08060000 	stmdaeq	r6, {}	; <UNPREDICTABLE>
     848:	0000036c 	andeq	r0, r0, ip, ror #6
     84c:	022f0807 	eoreq	r0, pc, #458752	; 0x70000
     850:	00080000 	andeq	r0, r8, r0
     854:	00021609 	andeq	r1, r2, r9, lsl #12
     858:	1a030400 	bne	c1860 <_bss_end+0xb9020>
     85c:	00021b07 	andeq	r1, r2, r7, lsl #22
     860:	05230a00 	streq	r0, [r3, #-2560]!	; 0xfffff600
     864:	1e030000 	cdpne	0, 0, cr0, cr3, cr0, {0}
     868:	00022617 	andeq	r2, r2, r7, lsl r6
     86c:	0c0b0000 	stceq	0, cr0, [fp], {-0}
     870:	03000003 	movweq	r0, #3
     874:	03200822 			; <UNDEFINED> instruction: 0x03200822
     878:	022b0000 	eoreq	r0, fp, #0
     87c:	ed020000 	stc	0, cr0, [r2, #-0]
     880:	02000000 	andeq	r0, r0, #0
     884:	0c000001 	stceq	0, cr0, [r0], {1}
     888:	00000232 	andeq	r0, r0, r2, lsr r2
     88c:	0000540d 	andeq	r5, r0, sp, lsl #8
     890:	02380d00 	eorseq	r0, r8, #0, 26
     894:	380d0000 	stmdacc	sp, {}	; <UNPREDICTABLE>
     898:	00000002 	andeq	r0, r0, r2
     89c:	0003b00b 	andeq	fp, r3, fp
     8a0:	08240300 	stmdaeq	r4!, {r8, r9}
     8a4:	000002c1 	andeq	r0, r0, r1, asr #5
     8a8:	0000022b 	andeq	r0, r0, fp, lsr #4
     8ac:	00011b02 	andeq	r1, r1, r2, lsl #22
     8b0:	00013000 	andeq	r3, r1, r0
     8b4:	02320c00 	eorseq	r0, r2, #0, 24
     8b8:	540d0000 	strpl	r0, [sp], #-0
     8bc:	0d000000 	stceq	0, cr0, [r0, #-0]
     8c0:	00000238 	andeq	r0, r0, r8, lsr r2
     8c4:	0002380d 	andeq	r3, r2, sp, lsl #16
     8c8:	500b0000 	andpl	r0, fp, r0
     8cc:	03000003 	movweq	r0, #3
     8d0:	02920826 	addseq	r0, r2, #2490368	; 0x260000
     8d4:	022b0000 	eoreq	r0, fp, #0
     8d8:	49020000 	stmdbmi	r2, {}	; <UNPREDICTABLE>
     8dc:	5e000001 	cdppl	0, 0, cr0, cr0, cr1, {0}
     8e0:	0c000001 	stceq	0, cr0, [r0], {1}
     8e4:	00000232 	andeq	r0, r0, r2, lsr r2
     8e8:	0000540d 	andeq	r5, r0, sp, lsl #8
     8ec:	02380d00 	eorseq	r0, r8, #0, 26
     8f0:	380d0000 	stmdacc	sp, {}	; <UNPREDICTABLE>
     8f4:	00000002 	andeq	r0, r0, r2
     8f8:	0005f10b 	andeq	pc, r5, fp, lsl #2
     8fc:	08280300 	stmdaeq	r8!, {r8, r9}
     900:	00000251 	andeq	r0, r0, r1, asr r2
     904:	0000022b 	andeq	r0, r0, fp, lsr #4
     908:	00017702 	andeq	r7, r1, r2, lsl #14
     90c:	00018c00 	andeq	r8, r1, r0, lsl #24
     910:	02320c00 	eorseq	r0, r2, #0, 24
     914:	540d0000 	strpl	r0, [sp], #-0
     918:	0d000000 	stceq	0, cr0, [r0, #-0]
     91c:	00000238 	andeq	r0, r0, r8, lsr r2
     920:	0002380d 	andeq	r3, r2, sp, lsl #16
     924:	160b0000 	strne	r0, [fp], -r0
     928:	03000002 	movweq	r0, #2
     92c:	05da032b 	ldrbeq	r0, [sl, #811]	; 0x32b
     930:	023e0000 	eorseq	r0, lr, #0
     934:	a5010000 	strge	r0, [r1, #-0]
     938:	b0000001 	andlt	r0, r0, r1
     93c:	0c000001 	stceq	0, cr0, [r0], {1}
     940:	0000023e 	andeq	r0, r0, lr, lsr r2
     944:	0000650d 	andeq	r6, r0, sp, lsl #10
     948:	320e0000 	andcc	r0, lr, #0
     94c:	03000004 	movweq	r0, #4
     950:	04d4082e 	ldrbeq	r0, [r4], #2094	; 0x82e
     954:	c5010000 	strgt	r0, [r1, #-0]
     958:	d5000001 	strle	r0, [r0, #-1]
     95c:	0c000001 	stceq	0, cr0, [r0], {1}
     960:	0000023e 	andeq	r0, r0, lr, lsr r2
     964:	0000540d 	andeq	r5, r0, sp, lsl #8
     968:	00710d00 	rsbseq	r0, r1, r0, lsl #26
     96c:	0b000000 	bleq	974 <_start-0x768c>
     970:	00000280 	andeq	r0, r0, r0, lsl #5
     974:	ab123003 	blge	48c988 <_bss_end+0x484148>
     978:	71000004 	tstvc	r0, r4
     97c:	01000000 	mrseq	r0, (UNDEF: 0)
     980:	000001ee 	andeq	r0, r0, lr, ror #3
     984:	000001f9 	strdeq	r0, [r0], -r9
     988:	0002320c 	andeq	r3, r2, ip, lsl #4
     98c:	00540d00 	subseq	r0, r4, r0, lsl #26
     990:	0f000000 	svceq	0x00000000
     994:	00000224 	andeq	r0, r0, r4, lsr #4
     998:	10083303 	andne	r3, r8, r3, lsl #6
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
     9c8:	0000055a 	andeq	r0, r0, sl, asr r5
     9cc:	021b0410 	andseq	r0, fp, #16, 8	; 0x10000000
     9d0:	04110000 	ldreq	r0, [r1], #-0
     9d4:	00000054 	andeq	r0, r0, r4, asr r0
     9d8:	00ba0410 	adcseq	r0, sl, r0, lsl r4
     9dc:	06120000 	ldreq	r0, [r2], -r0
     9e0:	03000003 	movweq	r0, #3
     9e4:	00ba1637 	adcseq	r1, sl, r7, lsr r6
     9e8:	bd130000 	ldclt	0, cr0, [r3, #-0]
     9ec:	01000006 	tsteq	r0, r6
     9f0:	00601404 	rsbeq	r1, r0, r4, lsl #8
     9f4:	03050000 	movweq	r0, #20480	; 0x5000
     9f8:	00008824 	andeq	r8, r0, r4, lsr #16
     9fc:	0006c514 	andeq	ip, r6, r4, lsl r5
     a00:	10060100 	andne	r0, r6, r0, lsl #2
     a04:	00000033 	andeq	r0, r0, r3, lsr r0
     a08:	00008600 	andeq	r8, r0, r0, lsl #12
     a0c:	000000ac 	andeq	r0, r0, ip, lsr #1
     a10:	74159c01 	ldrvc	r9, [r5], #-3073	; 0xfffff3ff
     a14:	01006d69 	tsteq	r0, r9, ror #26
     a18:	006c180b 	rsbeq	r1, ip, fp, lsl #16
     a1c:	91020000 	mrsls	r0, (UNDEF: 2)
     a20:	22000074 	andcs	r0, r0, #116	; 0x74
     a24:	02000000 	andeq	r0, r0, #0
     a28:	00046100 	andeq	r6, r4, r0, lsl #2
     a2c:	7b010400 	blvc	41a34 <_bss_end+0x391f4>
     a30:	00000005 	andeq	r0, r0, r5
     a34:	18000080 	stmdane	r0, {r7}
     a38:	d2000080 	andle	r0, r0, #128	; 0x80
     a3c:	00000006 	andeq	r0, r0, r6
     a40:	2e000000 	cdpcs	0, 0, cr0, cr0, cr0, {0}
     a44:	01000007 	tsteq	r0, r7
     a48:	00014b80 	andeq	r4, r1, r0, lsl #23
     a4c:	75000400 	strvc	r0, [r0, #-1024]	; 0xfffffc00
     a50:	04000004 	streq	r0, [r0], #-4
     a54:	00004f01 	andeq	r4, r0, r1, lsl #30
     a58:	07450400 	strbeq	r0, [r5, -r0, lsl #8]
     a5c:	00000000 	andeq	r0, r0, r0
     a60:	86ac0000 	strthi	r0, [ip], r0
     a64:	01180000 	tsteq	r8, r0
     a68:	06090000 	streq	r0, [r9], -r0
     a6c:	fb020000 	blx	80a76 <_bss_end+0x78236>
     a70:	01000007 	tsteq	r0, r7
     a74:	00310702 	eorseq	r0, r1, r2, lsl #14
     a78:	04030000 	streq	r0, [r3], #-0
     a7c:	00000037 	andeq	r0, r0, r7, lsr r0
     a80:	07f20204 	ldrbeq	r0, [r2, r4, lsl #4]!
     a84:	03010000 	movweq	r0, #4096	; 0x1000
     a88:	00003107 	andeq	r3, r0, r7, lsl #2
     a8c:	073a0500 	ldreq	r0, [sl, -r0, lsl #10]!
     a90:	06010000 	streq	r0, [r1], -r0
     a94:	00005010 	andeq	r5, r0, r0, lsl r0
     a98:	05040600 	streq	r0, [r4, #-1536]	; 0xfffffa00
     a9c:	00746e69 	rsbseq	r6, r4, r9, ror #28
     aa0:	0007db05 	andeq	sp, r7, r5, lsl #22
     aa4:	10080100 	andne	r0, r8, r0, lsl #2
     aa8:	00000050 	andeq	r0, r0, r0, asr r0
     aac:	00002507 	andeq	r2, r0, r7, lsl #10
     ab0:	00007600 	andeq	r7, r0, r0, lsl #12
     ab4:	00760800 	rsbseq	r0, r6, r0, lsl #16
     ab8:	ffff0000 			; <UNDEFINED> instruction: 0xffff0000
     abc:	0900ffff 	stmdbeq	r0, {r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, fp, ip, sp, lr, pc}
     ac0:	0cb80704 	ldceq	7, cr0, [r8], #16
     ac4:	b2050000 	andlt	r0, r5, #0
     ac8:	01000007 	tsteq	r0, r7
     acc:	0063150b 	rsbeq	r1, r3, fp, lsl #10
     ad0:	a5050000 	strge	r0, [r5, #-0]
     ad4:	01000007 	tsteq	r0, r7
     ad8:	0063150d 	rsbeq	r1, r3, sp, lsl #10
     adc:	38070000 	stmdacc	r7, {}	; <UNPREDICTABLE>
     ae0:	a8000000 	stmdage	r0, {}	; <UNPREDICTABLE>
     ae4:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
     ae8:	00000076 	andeq	r0, r0, r6, ror r0
     aec:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
     af0:	07e40500 	strbeq	r0, [r4, r0, lsl #10]!
     af4:	10010000 	andne	r0, r1, r0
     af8:	00009515 	andeq	r9, r0, r5, lsl r5
     afc:	07c00500 	strbeq	r0, [r0, r0, lsl #10]
     b00:	12010000 	andne	r0, r1, #0
     b04:	00009515 	andeq	r9, r0, r5, lsl r5
     b08:	07cd0a00 	strbeq	r0, [sp, r0, lsl #20]
     b0c:	2b010000 	blcs	40b14 <_bss_end+0x382d4>
     b10:	00005010 	andeq	r5, r0, r0, lsl r0
     b14:	00876c00 	addeq	r6, r7, r0, lsl #24
     b18:	00005800 	andeq	r5, r0, r0, lsl #16
     b1c:	ea9c0100 	b	fe700f24 <_bss_end+0xfe6f86e4>
     b20:	0b000000 	bleq	b28 <_start-0x74d8>
     b24:	0000081c 	andeq	r0, r0, ip, lsl r8
     b28:	ea0c2d01 	b	30bf34 <_bss_end+0x3036f4>
     b2c:	02000000 	andeq	r0, r0, #0
     b30:	03007491 	movweq	r7, #1169	; 0x491
     b34:	00003804 	andeq	r3, r0, r4, lsl #16
     b38:	080f0a00 	stmdaeq	pc, {r9, fp}	; <UNPREDICTABLE>
     b3c:	1f010000 	svcne	0x00010000
     b40:	00005010 	andeq	r5, r0, r0, lsl r0
     b44:	00871400 	addeq	r1, r7, r0, lsl #8
     b48:	00005800 	andeq	r5, r0, r0, lsl #16
     b4c:	1a9c0100 	bne	fe700f54 <_bss_end+0xfe6f8714>
     b50:	0b000001 	bleq	b5c <_start-0x74a4>
     b54:	0000081c 	andeq	r0, r0, ip, lsl r8
     b58:	1a0c2101 	bne	308f64 <_bss_end+0x300724>
     b5c:	02000001 	andeq	r0, r0, #1
     b60:	03007491 	movweq	r7, #1169	; 0x491
     b64:	00002504 	andeq	r2, r0, r4, lsl #10
     b68:	08040c00 	stmdaeq	r4, {sl, fp}
     b6c:	14010000 	strne	r0, [r1], #-0
     b70:	00005010 	andeq	r5, r0, r0, lsl r0
     b74:	0086ac00 	addeq	sl, r6, r0, lsl #24
     b78:	00006800 	andeq	r6, r0, r0, lsl #16
     b7c:	489c0100 	ldmmi	ip, {r8}
     b80:	0d000001 	stceq	0, cr0, [r0, #-4]
     b84:	16010069 	strne	r0, [r1], -r9, rrx
     b88:	00014807 	andeq	r4, r1, r7, lsl #16
     b8c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     b90:	50040300 	andpl	r0, r4, r0, lsl #6
     b94:	00000000 	andeq	r0, r0, r0
     b98:	00000932 	andeq	r0, r0, r2, lsr r9
     b9c:	053b0004 	ldreq	r0, [fp, #-4]!
     ba0:	01040000 	mrseq	r0, (UNDEF: 4)
     ba4:	00000b8b 	andeq	r0, r0, fp, lsl #23
     ba8:	000ae20c 	andeq	lr, sl, ip, lsl #4
     bac:	0012af00 	andseq	sl, r2, r0, lsl #30
     bb0:	00070400 	andeq	r0, r7, r0, lsl #8
     bb4:	05040200 	streq	r0, [r4, #-512]	; 0xfffffe00
     bb8:	00746e69 	rsbseq	r6, r4, r9, ror #28
     bbc:	b8070403 	stmdalt	r7, {r0, r1, sl}
     bc0:	0300000c 	movweq	r0, #12
     bc4:	01f20508 	mvnseq	r0, r8, lsl #10
     bc8:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
     bcc:	0013ef04 	andseq	lr, r3, r4, lsl #30
     bd0:	0b3d0400 	bleq	f41bd8 <_bss_end+0xf39398>
     bd4:	2a010000 	bcs	40bdc <_bss_end+0x3839c>
     bd8:	00002416 	andeq	r2, r0, r6, lsl r4
     bdc:	0fac0400 	svceq	0x00ac0400
     be0:	2f010000 	svccs	0x00010000
     be4:	00005115 	andeq	r5, r0, r5, lsl r1
     be8:	57040500 	strpl	r0, [r4, -r0, lsl #10]
     bec:	06000000 	streq	r0, [r0], -r0
     bf0:	00000039 	andeq	r0, r0, r9, lsr r0
     bf4:	00000066 	andeq	r0, r0, r6, rrx
     bf8:	00006607 	andeq	r6, r0, r7, lsl #12
     bfc:	04050000 	streq	r0, [r5], #-0
     c00:	0000006c 	andeq	r0, r0, ip, rrx
     c04:	17430408 	strbne	r0, [r3, -r8, lsl #8]
     c08:	36010000 	strcc	r0, [r1], -r0
     c0c:	0000790f 	andeq	r7, r0, pc, lsl #18
     c10:	7f040500 	svcvc	0x00040500
     c14:	06000000 	streq	r0, [r0], -r0
     c18:	0000001d 	andeq	r0, r0, sp, lsl r0
     c1c:	00000093 	muleq	r0, r3, r0
     c20:	00006607 	andeq	r6, r0, r7, lsl #12
     c24:	00660700 	rsbeq	r0, r6, r0, lsl #14
     c28:	03000000 	movweq	r0, #0
     c2c:	03920801 	orrseq	r0, r2, #65536	; 0x10000
     c30:	e4090000 	str	r0, [r9], #-0
     c34:	01000011 	tsteq	r0, r1, lsl r0
     c38:	004512bb 	strheq	r1, [r5], #-43	; 0xffffffd5
     c3c:	71090000 	mrsvc	r0, (UNDEF: 9)
     c40:	01000017 	tsteq	r0, r7, lsl r0
     c44:	006d10be 	strhteq	r1, [sp], #-14
     c48:	01030000 	mrseq	r0, (UNDEF: 3)
     c4c:	00039406 	andeq	r9, r3, r6, lsl #8
     c50:	0ecc0a00 	vdiveq.f32	s1, s24, s0
     c54:	01070000 	mrseq	r0, (UNDEF: 7)
     c58:	00000093 	muleq	r0, r3, r0
     c5c:	e6061702 	str	r1, [r6], -r2, lsl #14
     c60:	0b000001 	bleq	c6c <_start-0x7394>
     c64:	0000099b 	muleq	r0, fp, r9
     c68:	0de90b00 			; <UNDEFINED> instruction: 0x0de90b00
     c6c:	0b010000 	bleq	40c74 <_bss_end+0x38434>
     c70:	00001314 	andeq	r1, r0, r4, lsl r3
     c74:	16850b02 	strne	r0, [r5], r2, lsl #22
     c78:	0b030000 	bleq	c0c80 <_bss_end+0xb8440>
     c7c:	00001253 	andeq	r1, r0, r3, asr r2
     c80:	158e0b04 	strne	r0, [lr, #2820]	; 0xb04
     c84:	0b050000 	bleq	140c8c <_bss_end+0x13844c>
     c88:	000014f2 	strdeq	r1, [r0], -r2
     c8c:	09bc0b06 	ldmibeq	ip!, {r1, r2, r8, r9, fp}
     c90:	0b070000 	bleq	1c0c98 <_bss_end+0x1b8458>
     c94:	000015a3 	andeq	r1, r0, r3, lsr #11
     c98:	15b10b08 	ldrne	r0, [r1, #2824]!	; 0xb08
     c9c:	0b090000 	bleq	240ca4 <_bss_end+0x238464>
     ca0:	00001678 	andeq	r1, r0, r8, ror r6
     ca4:	11aa0b0a 			; <UNDEFINED> instruction: 0x11aa0b0a
     ca8:	0b0b0000 	bleq	2c0cb0 <_bss_end+0x2b8470>
     cac:	00000b7e 	andeq	r0, r0, lr, ror fp
     cb0:	0c5b0b0c 	mrrceq	11, 0, r0, fp, cr12
     cb4:	0b0d0000 	bleq	340cbc <_bss_end+0x33847c>
     cb8:	00000f10 	andeq	r0, r0, r0, lsl pc
     cbc:	0f260b0e 	svceq	0x00260b0e
     cc0:	0b0f0000 	bleq	3c0cc8 <_bss_end+0x3b8488>
     cc4:	00000e23 	andeq	r0, r0, r3, lsr #28
     cc8:	12370b10 	eorsne	r0, r7, #16, 22	; 0x4000
     ccc:	0b110000 	bleq	440cd4 <_bss_end+0x438494>
     cd0:	00000e8f 	andeq	r0, r0, pc, lsl #29
     cd4:	190a0b12 	stmdbne	sl, {r1, r4, r8, r9, fp}
     cd8:	0b130000 	bleq	4c0ce0 <_bss_end+0x4b84a0>
     cdc:	00000a25 	andeq	r0, r0, r5, lsr #20
     ce0:	0eb30b14 	vmoveq.32	r0, d3[1]
     ce4:	0b150000 	bleq	540cec <_bss_end+0x5384ac>
     ce8:	00000962 	andeq	r0, r0, r2, ror #18
     cec:	16a80b16 	ssatne	r0, #9, r6, lsl #22
     cf0:	0b170000 	bleq	5c0cf8 <_bss_end+0x5b84b8>
     cf4:	000017ca 	andeq	r1, r0, sl, asr #15
     cf8:	0ed80b18 	vmoveq.u8	r0, d8[0]
     cfc:	0b190000 	bleq	640d04 <_bss_end+0x6384c4>
     d00:	00001386 	andeq	r1, r0, r6, lsl #7
     d04:	16b60b1a 	ssatne	r0, #23, sl, lsl #22
     d08:	0b1b0000 	bleq	6c0d10 <_bss_end+0x6b84d0>
     d0c:	00000891 	muleq	r0, r1, r8
     d10:	16c40b1c 			; <UNDEFINED> instruction: 0x16c40b1c
     d14:	0b1d0000 	bleq	740d1c <_bss_end+0x7384dc>
     d18:	000016d2 	ldrdeq	r1, [r0], -r2
     d1c:	083f0b1e 	ldmdaeq	pc!, {r1, r2, r3, r4, r8, r9, fp}	; <UNPREDICTABLE>
     d20:	0b1f0000 	bleq	7c0d28 <_bss_end+0x7b84e8>
     d24:	000016fc 	strdeq	r1, [r0], -ip
     d28:	14330b20 	ldrtne	r0, [r3], #-2848	; 0xfffff4e0
     d2c:	0b210000 	bleq	840d34 <_bss_end+0x8384f4>
     d30:	00001209 	andeq	r1, r0, r9, lsl #4
     d34:	169b0b22 	ldrne	r0, [fp], r2, lsr #22
     d38:	0b230000 	bleq	8c0d40 <_bss_end+0x8b8500>
     d3c:	0000110d 	andeq	r1, r0, sp, lsl #2
     d40:	100f0b24 	andne	r0, pc, r4, lsr #22
     d44:	0b250000 	bleq	940d4c <_bss_end+0x93850c>
     d48:	00000d29 	andeq	r0, r0, r9, lsr #26
     d4c:	102d0b26 	eorne	r0, sp, r6, lsr #22
     d50:	0b270000 	bleq	9c0d58 <_bss_end+0x9b8518>
     d54:	00000dc5 	andeq	r0, r0, r5, asr #27
     d58:	103d0b28 	eorsne	r0, sp, r8, lsr #22
     d5c:	0b290000 	bleq	a40d64 <_bss_end+0xa38524>
     d60:	0000104d 	andeq	r1, r0, sp, asr #32
     d64:	11900b2a 	orrsne	r0, r0, sl, lsr #22
     d68:	0b2b0000 	bleq	ac0d70 <_bss_end+0xab8530>
     d6c:	00000fb6 			; <UNDEFINED> instruction: 0x00000fb6
     d70:	14400b2c 	strbne	r0, [r0], #-2860	; 0xfffff4d4
     d74:	0b2d0000 	bleq	b40d7c <_bss_end+0xb3853c>
     d78:	00000d6a 	andeq	r0, r0, sl, ror #26
     d7c:	480a002e 	stmdami	sl, {r1, r2, r3, r5}
     d80:	0700000f 	streq	r0, [r0, -pc]
     d84:	00009301 	andeq	r9, r0, r1, lsl #6
     d88:	06170300 	ldreq	r0, [r7], -r0, lsl #6
     d8c:	000003c7 	andeq	r0, r0, r7, asr #7
     d90:	000c7d0b 	andeq	r7, ip, fp, lsl #26
     d94:	cf0b0000 	svcgt	0x000b0000
     d98:	01000008 	tsteq	r0, r8
     d9c:	0018b80b 	andseq	fp, r8, fp, lsl #16
     da0:	4b0b0200 	blmi	2c15a8 <_bss_end+0x2b8d68>
     da4:	03000017 	movweq	r0, #23
     da8:	000c9d0b 	andeq	r9, ip, fp, lsl #26
     dac:	870b0400 	strhi	r0, [fp, -r0, lsl #8]
     db0:	05000009 	streq	r0, [r0, #-9]
     db4:	000d460b 	andeq	r4, sp, fp, lsl #12
     db8:	8d0b0600 	stchi	6, cr0, [fp, #-0]
     dbc:	0700000c 	streq	r0, [r0, -ip]
     dc0:	0015df0b 	andseq	sp, r5, fp, lsl #30
     dc4:	300b0800 	andcc	r0, fp, r0, lsl #16
     dc8:	09000017 	stmdbeq	r0, {r0, r1, r2, r4}
     dcc:	0015160b 	andseq	r1, r5, fp, lsl #12
     dd0:	da0b0a00 	ble	2c35d8 <_bss_end+0x2bad98>
     dd4:	0b000009 	bleq	e00 <_start-0x7200>
     dd8:	000ce70b 	andeq	lr, ip, fp, lsl #14
     ddc:	500b0c00 	andpl	r0, fp, r0, lsl #24
     de0:	0d000009 	stceq	0, cr0, [r0, #-36]	; 0xffffffdc
     de4:	0018ed0b 	andseq	lr, r8, fp, lsl #26
     de8:	7d0b0e00 	stcvc	14, cr0, [fp, #-0]
     dec:	0f000011 	svceq	0x00000011
     df0:	000e5a0b 	andeq	r5, lr, fp, lsl #20
     df4:	ba0b1000 	blt	2c4dfc <_bss_end+0x2bc5bc>
     df8:	11000011 	tstne	r0, r1, lsl r0
     dfc:	00180c0b 	andseq	r0, r8, fp, lsl #24
     e00:	9d0b1200 	sfmls	f1, 4, [fp, #-0]
     e04:	1300000a 	movwne	r0, #10
     e08:	000e6d0b 	andeq	r6, lr, fp, lsl #26
     e0c:	d00b1400 	andle	r1, fp, r0, lsl #8
     e10:	15000010 	strne	r0, [r0, #-16]
     e14:	000c680b 	andeq	r6, ip, fp, lsl #16
     e18:	1c0b1600 	stcne	6, cr1, [fp], {-0}
     e1c:	17000011 	smladne	r0, r1, r0, r0
     e20:	000f320b 	andeq	r3, pc, fp, lsl #4
     e24:	a50b1800 	strge	r1, [fp, #-2048]	; 0xfffff800
     e28:	19000009 	stmdbne	r0, {r0, r3}
     e2c:	0017b30b 	andseq	fp, r7, fp, lsl #6
     e30:	9c0b1a00 			; <UNDEFINED> instruction: 0x9c0b1a00
     e34:	1b000010 	blne	e7c <_start-0x7184>
     e38:	000e440b 	andeq	r4, lr, fp, lsl #8
     e3c:	7a0b1c00 	bvc	2c7e44 <_bss_end+0x2bf604>
     e40:	1d000008 	stcne	0, cr0, [r0, #-32]	; 0xffffffe0
     e44:	000fe70b 	andeq	lr, pc, fp, lsl #14
     e48:	d30b1e00 	movwle	r1, #48640	; 0xbe00
     e4c:	1f00000f 	svcne	0x0000000f
     e50:	0014d30b 	andseq	sp, r4, fp, lsl #6
     e54:	5e0b2000 	cdppl	0, 0, cr2, cr11, cr0, {0}
     e58:	21000015 	tstcs	r0, r5, lsl r0
     e5c:	0017920b 	andseq	r9, r7, fp, lsl #4
     e60:	770b2200 	strvc	r2, [fp, -r0, lsl #4]
     e64:	2300000d 	movwcs	r0, #13
     e68:	0013360b 	andseq	r3, r3, fp, lsl #12
     e6c:	2b0b2400 	blcs	2c9e74 <_bss_end+0x2c1634>
     e70:	25000015 	strcs	r0, [r0, #-21]	; 0xffffffeb
     e74:	00144f0b 	andseq	r4, r4, fp, lsl #30
     e78:	630b2600 	movwvs	r2, #46592	; 0xb600
     e7c:	27000014 	smladcs	r0, r4, r0, r0
     e80:	0014770b 	andseq	r7, r4, fp, lsl #14
     e84:	280b2800 	stmdacs	fp, {fp, sp}
     e88:	2900000b 	stmdbcs	r0, {r0, r1, r3}
     e8c:	000a880b 	andeq	r8, sl, fp, lsl #16
     e90:	b00b2a00 	andlt	r2, fp, r0, lsl #20
     e94:	2b00000a 	blcs	ec4 <_start-0x713c>
     e98:	0016280b 	andseq	r2, r6, fp, lsl #16
     e9c:	050b2c00 	streq	r2, [fp, #-3072]	; 0xfffff400
     ea0:	2d00000b 	stccs	0, cr0, [r0, #-44]	; 0xffffffd4
     ea4:	00163c0b 	andseq	r3, r6, fp, lsl #24
     ea8:	500b2e00 	andpl	r2, fp, r0, lsl #28
     eac:	2f000016 	svccs	0x00000016
     eb0:	0016640b 	andseq	r6, r6, fp, lsl #8
     eb4:	f90b3000 			; <UNDEFINED> instruction: 0xf90b3000
     eb8:	3100000c 	tstcc	r0, ip
     ebc:	000cd30b 	andeq	sp, ip, fp, lsl #6
     ec0:	fb0b3200 	blx	2cd6ca <_bss_end+0x2c4e8a>
     ec4:	3300000f 	movwcc	r0, #15
     ec8:	0011cd0b 	andseq	ip, r1, fp, lsl #26
     ecc:	410b3400 	tstmi	fp, r0, lsl #8
     ed0:	35000018 	strcc	r0, [r0, #-24]	; 0xffffffe8
     ed4:	0008220b 	andeq	r2, r8, fp, lsl #4
     ed8:	f90b3600 			; <UNDEFINED> instruction: 0xf90b3600
     edc:	3700000d 	strcc	r0, [r0, -sp]
     ee0:	000e0e0b 	andeq	r0, lr, fp, lsl #28
     ee4:	5d0b3800 	stcpl	8, cr3, [fp, #-0]
     ee8:	39000010 	stmdbcc	r0, {r4}
     eec:	0010870b 	andseq	r8, r0, fp, lsl #14
     ef0:	6a0b3a00 	bvs	2cf6f8 <_bss_end+0x2c6eb8>
     ef4:	3b000018 	blcc	f5c <_start-0x70a4>
     ef8:	0013210b 	andseq	r2, r3, fp, lsl #2
     efc:	9c0b3c00 	stcls	12, cr3, [fp], {-0}
     f00:	3d00000d 	stccc	0, cr0, [r0, #-52]	; 0xffffffcc
     f04:	0008e10b 	andeq	lr, r8, fp, lsl #2
     f08:	9f0b3e00 	svcls	0x000b3e00
     f0c:	3f000008 	svccc	0x00000008
     f10:	0012190b 	andseq	r1, r2, fp, lsl #18
     f14:	a20b4000 	andge	r4, fp, #0
     f18:	41000013 	tstmi	r0, r3, lsl r0
     f1c:	0014b50b 	andseq	fp, r4, fp, lsl #10
     f20:	720b4200 	andvc	r4, fp, #0, 4
     f24:	43000010 	movwmi	r0, #16
     f28:	0018a30b 	andseq	sl, r8, fp, lsl #6
     f2c:	4c0b4400 	cfstrsmi	mvf4, [fp], {-0}
     f30:	45000013 	strmi	r0, [r0, #-19]	; 0xffffffed
     f34:	000acc0b 	andeq	ip, sl, fp, lsl #24
     f38:	4d0b4600 	stcmi	6, cr4, [fp, #-0]
     f3c:	47000011 	smladmi	r0, r1, r0, r0
     f40:	000f800b 	andeq	r8, pc, fp
     f44:	5e0b4800 	cdppl	8, 0, cr4, cr11, cr0, {0}
     f48:	49000008 	stmdbmi	r0, {r3}
     f4c:	0009720b 	andeq	r7, r9, fp, lsl #4
     f50:	b00b4a00 	andlt	r4, fp, r0, lsl #20
     f54:	4b00000d 	blmi	f90 <_start-0x7070>
     f58:	0010ae0b 	andseq	sl, r0, fp, lsl #28
     f5c:	03004c00 	movweq	r4, #3072	; 0xc00
     f60:	03d40702 	bicseq	r0, r4, #524288	; 0x80000
     f64:	e40c0000 	str	r0, [ip], #-0
     f68:	d9000003 	stmdble	r0, {r0, r1}
     f6c:	0d000003 	stceq	0, cr0, [r0, #-12]
     f70:	03ce0e00 	biceq	r0, lr, #0, 28
     f74:	04050000 	streq	r0, [r5], #-0
     f78:	000003f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     f7c:	0003de0e 	andeq	sp, r3, lr, lsl #28
     f80:	08010300 	stmdaeq	r1, {r8, r9}
     f84:	0000039b 	muleq	r0, fp, r3
     f88:	0003e90e 	andeq	lr, r3, lr, lsl #18
     f8c:	0a160f00 	beq	584b94 <_bss_end+0x57c354>
     f90:	4c040000 	stcmi	0, cr0, [r4], {-0}
     f94:	03d91a01 	bicseq	r1, r9, #4096	; 0x1000
     f98:	340f0000 	strcc	r0, [pc], #-0	; fa0 <_start-0x7060>
     f9c:	0400000e 	streq	r0, [r0], #-14
     fa0:	d91a0182 	ldmdble	sl, {r1, r7, r8}
     fa4:	0c000003 	stceq	0, cr0, [r0], {3}
     fa8:	000003e9 	andeq	r0, r0, r9, ror #7
     fac:	0000041a 	andeq	r0, r0, sl, lsl r4
     fb0:	1f09000d 	svcne	0x0009000d
     fb4:	05000010 	streq	r0, [r0, #-16]
     fb8:	040f0d2d 	streq	r0, [pc], #-3373	; fc0 <_start-0x7040>
     fbc:	0c090000 	stceq	0, cr0, [r9], {-0}
     fc0:	05000017 	streq	r0, [r0, #-23]	; 0xffffffe9
     fc4:	01e61c38 	mvneq	r1, r8, lsr ip
     fc8:	0d0a0000 	stceq	0, cr0, [sl, #-0]
     fcc:	0700000d 	streq	r0, [r0, -sp]
     fd0:	00009301 	andeq	r9, r0, r1, lsl #6
     fd4:	0e3a0500 	cfabs32eq	mvfx0, mvfx10
     fd8:	000004a5 	andeq	r0, r0, r5, lsr #9
     fdc:	0008730b 	andeq	r7, r8, fp, lsl #6
     fe0:	1f0b0000 	svcne	0x000b0000
     fe4:	0100000f 	tsteq	r0, pc
     fe8:	00181e0b 	andseq	r1, r8, fp, lsl #28
     fec:	e10b0200 	mrs	r0, R11_fiq
     ff0:	03000017 	movweq	r0, #23
     ff4:	0012760b 	andseq	r7, r2, fp, lsl #12
     ff8:	9c0b0400 	cfstrsls	mvf0, [fp], {-0}
     ffc:	05000015 	streq	r0, [r0, #-21]	; 0xffffffeb
    1000:	000a590b 	andeq	r5, sl, fp, lsl #18
    1004:	3b0b0600 	blcc	2c280c <_bss_end+0x2b9fcc>
    1008:	0700000a 	streq	r0, [r0, -sl]
    100c:	000c540b 	andeq	r5, ip, fp, lsl #8
    1010:	320b0800 	andcc	r0, fp, #0, 16
    1014:	09000011 	stmdbeq	r0, {r0, r4}
    1018:	000a600b 	andeq	r6, sl, fp
    101c:	390b0a00 	stmdbcc	fp, {r9, fp}
    1020:	0b000011 	bleq	106c <_start-0x6f94>
    1024:	000ac50b 	andeq	ip, sl, fp, lsl #10
    1028:	520b0c00 	andpl	r0, fp, #0, 24
    102c:	0d00000a 	stceq	0, cr0, [r0, #-40]	; 0xffffffd8
    1030:	0015f30b 	andseq	pc, r5, fp, lsl #6
    1034:	c00b0e00 	andgt	r0, fp, r0, lsl #28
    1038:	0f000013 	svceq	0x00000013
    103c:	14eb0400 	strbtne	r0, [fp], #1024	; 0x400
    1040:	3f050000 	svccc	0x00050000
    1044:	00043201 	andeq	r3, r4, r1, lsl #4
    1048:	157f0900 	ldrbne	r0, [pc, #-2304]!	; 750 <_start-0x78b0>
    104c:	41050000 	mrsmi	r0, (UNDEF: 5)
    1050:	0004a50f 	andeq	sl, r4, pc, lsl #10
    1054:	16070900 	strne	r0, [r7], -r0, lsl #18
    1058:	4a050000 	bmi	141060 <_bss_end+0x138820>
    105c:	00001d0c 	andeq	r1, r0, ip, lsl #26
    1060:	09fa0900 	ldmibeq	sl!, {r8, fp}^
    1064:	4b050000 	blmi	14106c <_bss_end+0x13882c>
    1068:	00001d0c 	andeq	r1, r0, ip, lsl #26
    106c:	16e01000 	strbtne	r1, [r0], r0
    1070:	18090000 	stmdane	r9, {}	; <UNPREDICTABLE>
    1074:	05000016 	streq	r0, [r0, #-22]	; 0xffffffea
    1078:	04e6144c 	strbteq	r1, [r6], #1100	; 0x44c
    107c:	04050000 	streq	r0, [r5], #-0
    1080:	000004d5 	ldrdeq	r0, [r0], -r5
    1084:	0ee90911 			; <UNDEFINED> instruction: 0x0ee90911
    1088:	4e050000 	cdpmi	0, 0, cr0, cr5, cr0, {0}
    108c:	0004f90f 	andeq	pc, r4, pc, lsl #18
    1090:	ec040500 	cfstr32	mvfx0, [r4], {-0}
    1094:	12000004 	andne	r0, r0, #4
    1098:	00001501 	andeq	r1, r0, r1, lsl #10
    109c:	00126309 	andseq	r6, r2, r9, lsl #6
    10a0:	0d520500 	cfldr64eq	mvdx0, [r2, #-0]
    10a4:	00000510 	andeq	r0, r0, r0, lsl r5
    10a8:	04ff0405 	ldrbteq	r0, [pc], #1029	; 10b0 <_start-0x6f50>
    10ac:	71130000 	tstvc	r3, r0
    10b0:	3400000b 	strcc	r0, [r0], #-11
    10b4:	15016705 	strne	r6, [r1, #-1797]	; 0xfffff8fb
    10b8:	00000541 	andeq	r0, r0, r1, asr #10
    10bc:	00102814 	andseq	r2, r0, r4, lsl r8
    10c0:	01690500 	cmneq	r9, r0, lsl #10
    10c4:	0003de0f 	andeq	sp, r3, pc, lsl #28
    10c8:	55140000 	ldrpl	r0, [r4, #-0]
    10cc:	0500000b 	streq	r0, [r0, #-11]
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
    10fc:	570f0000 	strpl	r0, [pc, -r0]
    1100:	0500000f 	streq	r0, [r0, #-15]
    1104:	6103016b 	tstvs	r3, fp, ror #2
    1108:	0f000005 	svceq	0x00000005
    110c:	0000119d 	muleq	r0, sp, r1
    1110:	0c016e05 	stceq	14, cr6, [r1], {5}
    1114:	0000001d 	andeq	r0, r0, sp, lsl r0
    1118:	00153f16 	andseq	r3, r5, r6, lsl pc
    111c:	93010700 	movwls	r0, #5888	; 0x1700
    1120:	05000000 	streq	r0, [r0, #-0]
    1124:	2a060181 	bcs	181730 <_bss_end+0x178ef0>
    1128:	0b000006 	bleq	1148 <_start-0x6eb8>
    112c:	00000908 	andeq	r0, r0, r8, lsl #18
    1130:	09140b00 	ldmdbeq	r4, {r8, r9, fp}
    1134:	0b020000 	bleq	8113c <_bss_end+0x788fc>
    1138:	00000920 	andeq	r0, r0, r0, lsr #18
    113c:	0d390b03 	fldmdbxeq	r9!, {d0}	;@ Deprecated
    1140:	0b030000 	bleq	c1148 <_bss_end+0xb8908>
    1144:	0000092c 	andeq	r0, r0, ip, lsr #18
    1148:	0e820b04 	vdiveq.f64	d0, d2, d4
    114c:	0b040000 	bleq	101154 <_bss_end+0xf8914>
    1150:	00000f68 	andeq	r0, r0, r8, ror #30
    1154:	0ebe0b05 	vmoveq.f64	d0, #229	; 0xbf280000 -0.6562500
    1158:	0b050000 	bleq	141160 <_bss_end+0x138920>
    115c:	000009eb 	andeq	r0, r0, fp, ror #19
    1160:	09380b05 	ldmdbeq	r8!, {r0, r2, r8, r9, fp}
    1164:	0b060000 	bleq	18116c <_bss_end+0x17892c>
    1168:	000010e6 	andeq	r1, r0, r6, ror #1
    116c:	0b470b06 	bleq	11c3d8c <_bss_end+0x11bb54c>
    1170:	0b060000 	bleq	181178 <_bss_end+0x178938>
    1174:	000010f3 	strdeq	r1, [r0], -r3
    1178:	15bf0b06 	ldrne	r0, [pc, #2822]!	; 1c86 <_start-0x637a>
    117c:	0b060000 	bleq	181184 <_bss_end+0x178944>
    1180:	00001100 	andeq	r1, r0, r0, lsl #2
    1184:	11400b06 	cmpne	r0, r6, lsl #22
    1188:	0b060000 	bleq	181190 <_bss_end+0x178950>
    118c:	00000944 	andeq	r0, r0, r4, asr #18
    1190:	12460b07 	subne	r0, r6, #7168	; 0x1c00
    1194:	0b070000 	bleq	1c119c <_bss_end+0x1b895c>
    1198:	00001293 	muleq	r0, r3, r2
    119c:	15fa0b07 	ldrbne	r0, [sl, #2823]!	; 0xb07
    11a0:	0b070000 	bleq	1c11a8 <_bss_end+0x1b8968>
    11a4:	00000b1a 	andeq	r0, r0, sl, lsl fp
    11a8:	13790b07 	cmnne	r9, #7168	; 0x1c00
    11ac:	0b080000 	bleq	2011b4 <_bss_end+0x1f8974>
    11b0:	000008bd 			; <UNDEFINED> instruction: 0x000008bd
    11b4:	15cd0b08 	strbne	r0, [sp, #2824]	; 0xb08
    11b8:	0b080000 	bleq	2011c0 <_bss_end+0x1f8980>
    11bc:	00001395 	muleq	r0, r5, r3
    11c0:	330f0008 	movwcc	r0, #61448	; 0xf008
    11c4:	05000018 	streq	r0, [r0, #-24]	; 0xffffffe8
    11c8:	801f019f 	mulshi	pc, pc, r1	; <UNPREDICTABLE>
    11cc:	0f000005 	svceq	0x00000005
    11d0:	000013c7 	andeq	r1, r0, r7, asr #7
    11d4:	0c01a205 	sfmeq	f2, 1, [r1], {5}
    11d8:	0000001d 	andeq	r0, r0, sp, lsl r0
    11dc:	000f750f 	andeq	r7, pc, pc, lsl #10
    11e0:	01a50500 			; <UNDEFINED> instruction: 0x01a50500
    11e4:	00001d0c 	andeq	r1, r0, ip, lsl #26
    11e8:	18ff0f00 	ldmne	pc!, {r8, r9, sl, fp}^	; <UNPREDICTABLE>
    11ec:	a8050000 	stmdage	r5, {}	; <UNPREDICTABLE>
    11f0:	001d0c01 	andseq	r0, sp, r1, lsl #24
    11f4:	0a0f0000 	beq	3c11fc <_bss_end+0x3b89bc>
    11f8:	0500000a 	streq	r0, [r0, #-10]
    11fc:	1d0c01ab 	stfnes	f0, [ip, #-684]	; 0xfffffd54
    1200:	0f000000 	svceq	0x00000000
    1204:	000013d1 	ldrdeq	r1, [r0], -r1	; <UNPREDICTABLE>
    1208:	0c01ae05 	stceq	14, cr10, [r1], {5}
    120c:	0000001d 	andeq	r0, r0, sp, lsl r0
    1210:	00127d0f 	andseq	r7, r2, pc, lsl #26
    1214:	01b10500 			; <UNDEFINED> instruction: 0x01b10500
    1218:	00001d0c 	andeq	r1, r0, ip, lsl #26
    121c:	12880f00 	addne	r0, r8, #0, 30
    1220:	b4050000 	strlt	r0, [r5], #-0
    1224:	001d0c01 	andseq	r0, sp, r1, lsl #24
    1228:	db0f0000 	blle	3c1230 <_bss_end+0x3b89f0>
    122c:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
    1230:	1d0c01b7 	stfnes	f0, [ip, #-732]	; 0xfffffd24
    1234:	0f000000 	svceq	0x00000000
    1238:	000010c2 	andeq	r1, r0, r2, asr #1
    123c:	0c01ba05 			; <UNDEFINED> instruction: 0x0c01ba05
    1240:	0000001d 	andeq	r0, r0, sp, lsl r0
    1244:	00185e0f 	andseq	r5, r8, pc, lsl #28
    1248:	01bd0500 			; <UNDEFINED> instruction: 0x01bd0500
    124c:	00001d0c 	andeq	r1, r0, ip, lsl #26
    1250:	13e50f00 	mvnne	r0, #0, 30
    1254:	c0050000 	andgt	r0, r5, r0
    1258:	001d0c01 	andseq	r0, sp, r1, lsl #24
    125c:	220f0000 	andcs	r0, pc, #0
    1260:	05000019 	streq	r0, [r0, #-25]	; 0xffffffe7
    1264:	1d0c01c3 	stfnes	f0, [ip, #-780]	; 0xfffffcf4
    1268:	0f000000 	svceq	0x00000000
    126c:	000017e8 	andeq	r1, r0, r8, ror #15
    1270:	0c01c605 	stceq	6, cr12, [r1], {5}
    1274:	0000001d 	andeq	r0, r0, sp, lsl r0
    1278:	0017f40f 	andseq	pc, r7, pc, lsl #8
    127c:	01c90500 	biceq	r0, r9, r0, lsl #10
    1280:	00001d0c 	andeq	r1, r0, ip, lsl #26
    1284:	18000f00 	stmdane	r0, {r8, r9, sl, fp}
    1288:	cc050000 	stcgt	0, cr0, [r5], {-0}
    128c:	001d0c01 	andseq	r0, sp, r1, lsl #24
    1290:	250f0000 	strcs	r0, [pc, #-0]	; 1298 <_start-0x6d68>
    1294:	05000018 	streq	r0, [r0, #-24]	; 0xffffffe8
    1298:	1d0c01d0 	stfnes	f0, [ip, #-832]	; 0xfffffcc0
    129c:	0f000000 	svceq	0x00000000
    12a0:	00001915 	andeq	r1, r0, r5, lsl r9
    12a4:	0c01d305 	stceq	3, cr13, [r1], {5}
    12a8:	0000001d 	andeq	r0, r0, sp, lsl r0
    12ac:	000a670f 	andeq	r6, sl, pc, lsl #14
    12b0:	01d60500 	bicseq	r0, r6, r0, lsl #10
    12b4:	00001d0c 	andeq	r1, r0, ip, lsl #26
    12b8:	084e0f00 	stmdaeq	lr, {r8, r9, sl, fp}^
    12bc:	d9050000 	stmdble	r5, {}	; <UNPREDICTABLE>
    12c0:	001d0c01 	andseq	r0, sp, r1, lsl #24
    12c4:	590f0000 	stmdbpl	pc, {}	; <UNPREDICTABLE>
    12c8:	0500000d 	streq	r0, [r0, #-13]
    12cc:	1d0c01dc 	stfnes	f0, [ip, #-880]	; 0xfffffc90
    12d0:	0f000000 	svceq	0x00000000
    12d4:	00000a42 	andeq	r0, r0, r2, asr #20
    12d8:	0c01df05 	stceq	15, cr13, [r1], {5}
    12dc:	0000001d 	andeq	r0, r0, sp, lsl r0
    12e0:	0013fb0f 	andseq	pc, r3, pc, lsl #22
    12e4:	01e20500 	mvneq	r0, r0, lsl #10
    12e8:	00001d0c 	andeq	r1, r0, ip, lsl #26
    12ec:	0f9e0f00 	svceq	0x009e0f00
    12f0:	e5050000 	str	r0, [r5, #-0]
    12f4:	001d0c01 	andseq	r0, sp, r1, lsl #24
    12f8:	f60f0000 			; <UNDEFINED> instruction: 0xf60f0000
    12fc:	05000011 	streq	r0, [r0, #-17]	; 0xffffffef
    1300:	1d0c01e8 	stfnes	f0, [ip, #-928]	; 0xfffffc60
    1304:	0f000000 	svceq	0x00000000
    1308:	00001715 	andeq	r1, r0, r5, lsl r7
    130c:	0c01ef05 	stceq	15, cr14, [r1], {5}
    1310:	0000001d 	andeq	r0, r0, sp, lsl r0
    1314:	0018cd0f 	andseq	ip, r8, pc, lsl #26
    1318:	01f20500 	mvnseq	r0, r0, lsl #10
    131c:	00001d0c 	andeq	r1, r0, ip, lsl #26
    1320:	18dd0f00 	ldmne	sp, {r8, r9, sl, fp}^
    1324:	f5050000 			; <UNDEFINED> instruction: 0xf5050000
    1328:	001d0c01 	andseq	r0, sp, r1, lsl #24
    132c:	5e0f0000 	cdppl	0, 0, cr0, cr15, cr0, {0}
    1330:	0500000b 	streq	r0, [r0, #-11]
    1334:	1d0c01f8 	stfnes	f0, [ip, #-992]	; 0xfffffc20
    1338:	0f000000 	svceq	0x00000000
    133c:	0000175c 	andeq	r1, r0, ip, asr r7
    1340:	0c01fb05 			; <UNDEFINED> instruction: 0x0c01fb05
    1344:	0000001d 	andeq	r0, r0, sp, lsl r0
    1348:	0013610f 	andseq	r6, r3, pc, lsl #2
    134c:	01fe0500 	mvnseq	r0, r0, lsl #10
    1350:	00001d0c 	andeq	r1, r0, ip, lsl #26
    1354:	0dd20f00 	ldcleq	15, cr0, [r2]
    1358:	02050000 	andeq	r0, r5, #0
    135c:	001d0c02 	andseq	r0, sp, r2, lsl #24
    1360:	510f0000 	mrspl	r0, CPSR
    1364:	05000015 	streq	r0, [r0, #-21]	; 0xffffffeb
    1368:	1d0c020a 	sfmne	f0, 4, [ip, #-40]	; 0xffffffd8
    136c:	0f000000 	svceq	0x00000000
    1370:	00000cc5 	andeq	r0, r0, r5, asr #25
    1374:	0c020d05 	stceq	13, cr0, [r2], {5}
    1378:	0000001d 	andeq	r0, r0, sp, lsl r0
    137c:	00001d0c 	andeq	r1, r0, ip, lsl #26
    1380:	0007ef00 	andeq	lr, r7, r0, lsl #30
    1384:	0f000d00 	svceq	0x00000d00
    1388:	00000e9e 	muleq	r0, lr, lr
    138c:	0c03fb05 			; <UNDEFINED> instruction: 0x0c03fb05
    1390:	000007e4 	andeq	r0, r0, r4, ror #15
    1394:	0004e60c 	andeq	lr, r4, ip, lsl #12
    1398:	00080c00 	andeq	r0, r8, r0, lsl #24
    139c:	00241500 	eoreq	r1, r4, r0, lsl #10
    13a0:	000d0000 	andeq	r0, sp, r0
    13a4:	00141e0f 	andseq	r1, r4, pc, lsl #28
    13a8:	05840500 	streq	r0, [r4, #1280]	; 0x500
    13ac:	0007fc14 	andeq	pc, r7, r4, lsl ip	; <UNPREDICTABLE>
    13b0:	0f601600 	svceq	0x00601600
    13b4:	01070000 	mrseq	r0, (UNDEF: 7)
    13b8:	00000093 	muleq	r0, r3, r0
    13bc:	06058b05 	streq	r8, [r5], -r5, lsl #22
    13c0:	00000857 	andeq	r0, r0, r7, asr r8
    13c4:	000d1b0b 	andeq	r1, sp, fp, lsl #22
    13c8:	6b0b0000 	blvs	2c13d0 <_bss_end+0x2b8b90>
    13cc:	01000011 	tsteq	r0, r1, lsl r0
    13d0:	0008f30b 	andeq	pc, r8, fp, lsl #6
    13d4:	8f0b0200 	svchi	0x000b0200
    13d8:	03000018 	movweq	r0, #24
    13dc:	0014980b 	andseq	r9, r4, fp, lsl #16
    13e0:	8b0b0400 	blhi	2c23e8 <_bss_end+0x2b9ba8>
    13e4:	05000014 	streq	r0, [r0, #-20]	; 0xffffffec
    13e8:	0009ca0b 	andeq	ip, r9, fp, lsl #20
    13ec:	0f000600 	svceq	0x00000600
    13f0:	0000187f 	andeq	r1, r0, pc, ror r8
    13f4:	15059805 	strne	r9, [r5, #-2053]	; 0xfffff7fb
    13f8:	00000819 	andeq	r0, r0, r9, lsl r8
    13fc:	0017810f 	andseq	r8, r7, pc, lsl #2
    1400:	07990500 	ldreq	r0, [r9, r0, lsl #10]
    1404:	00002411 	andeq	r2, r0, r1, lsl r4
    1408:	140b0f00 	strne	r0, [fp], #-3840	; 0xfffff100
    140c:	ae050000 	cdpge	0, 0, cr0, cr5, cr0, {0}
    1410:	001d0c07 	andseq	r0, sp, r7, lsl #24
    1414:	f4040000 	vst4.8	{d0-d3}, [r4], r0
    1418:	06000016 			; <UNDEFINED> instruction: 0x06000016
    141c:	0093167b 	addseq	r1, r3, fp, ror r6
    1420:	7e0e0000 	cdpvc	0, 0, cr0, cr14, cr0, {0}
    1424:	03000008 	movweq	r0, #8
    1428:	05470502 	strbeq	r0, [r7, #-1282]	; 0xfffffafe
    142c:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    1430:	000cae07 	andeq	sl, ip, r7, lsl #28
    1434:	04040300 	streq	r0, [r4], #-768	; 0xfffffd00
    1438:	00000a82 	andeq	r0, r0, r2, lsl #21
    143c:	7a030803 	bvc	c3450 <_bss_end+0xbac10>
    1440:	0300000a 	movweq	r0, #10
    1444:	13f40408 	mvnsne	r0, #8, 8	; 0x8000000
    1448:	10030000 	andne	r0, r3, r0
    144c:	0014a603 	andseq	sl, r4, r3, lsl #12
    1450:	088a0c00 	stmeq	sl, {sl, fp}
    1454:	08c90000 	stmiaeq	r9, {}^	; <UNPREDICTABLE>
    1458:	24150000 	ldrcs	r0, [r5], #-0
    145c:	ff000000 			; <UNDEFINED> instruction: 0xff000000
    1460:	08b90e00 	ldmeq	r9!, {r9, sl, fp}
    1464:	a00f0000 	andge	r0, pc, r0
    1468:	06000012 			; <UNDEFINED> instruction: 0x06000012
    146c:	c91601fc 	ldmdbgt	r6, {r2, r3, r4, r5, r6, r7, r8}
    1470:	0f000008 	svceq	0x00000008
    1474:	00000a31 	andeq	r0, r0, r1, lsr sl
    1478:	16020206 	strne	r0, [r2], -r6, lsl #4
    147c:	000008c9 	andeq	r0, r0, r9, asr #17
    1480:	00172704 	andseq	r2, r7, r4, lsl #14
    1484:	102a0700 	eorne	r0, sl, r0, lsl #14
    1488:	000004f9 	strdeq	r0, [r0], -r9
    148c:	0008e80c 	andeq	lr, r8, ip, lsl #16
    1490:	0008ff00 	andeq	pc, r8, r0, lsl #30
    1494:	09000d00 	stmdbeq	r0, {r8, sl, fp}
    1498:	000007b2 			; <UNDEFINED> instruction: 0x000007b2
    149c:	f4112f07 			; <UNDEFINED> instruction: 0xf4112f07
    14a0:	09000008 	stmdbeq	r0, {r3}
    14a4:	000007e4 	andeq	r0, r0, r4, ror #15
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
   0:	000000b9 	strheq	r0, [r0], -r9
   4:	00800003 	addeq	r0, r0, r3
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
  40:	4c2f7365 	stcmi	3, cr7, [pc], #-404	; fffffeb4 <_bss_end+0xffff7674>
  44:	745f4445 	ldrbvc	r4, [pc], #-1093	; 4c <_start-0x7fb4>
  48:	6c67676f 	stclvs	7, cr6, [r7], #-444	; 0xfffffe44
  4c:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
  50:	69637265 	stmdbvs	r3!, {r0, r2, r5, r6, r9, ip, sp, lr}^
  54:	305f6573 	subscc	r6, pc, r3, ror r5	; <UNPREDICTABLE>
  58:	32302f32 	eorscc	r2, r0, #50, 30	; 0xc8
  5c:	72656b5f 	rsbvc	r6, r5, #97280	; 0x17c00
  60:	2f6c656e 	svccs	0x006c656e
  64:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
  68:	732f6c65 			; <UNDEFINED> instruction: 0x732f6c65
  6c:	00006372 	andeq	r6, r0, r2, ror r3
  70:	2e787863 	cdpcs	8, 7, cr7, cr8, cr3, {3}
  74:	00707063 	rsbseq	r7, r0, r3, rrx
  78:	3c000001 	stccc	0, cr0, [r0], {1}
  7c:	6c697562 	cfstr64vs	mvdx7, [r9], #-392	; 0xfffffe78
  80:	6e692d74 	mcrvs	13, 3, r2, cr9, cr4, {3}
  84:	0000003e 	andeq	r0, r0, lr, lsr r0
  88:	02050000 	andeq	r0, r5, #0
  8c:	18020500 	stmdane	r2, {r8, sl}
  90:	03000080 	movweq	r0, #128	; 0x80
  94:	0b05010a 	bleq	1404c4 <_bss_end+0x137c84>
  98:	4a0a0583 	bmi	2816ac <_bss_end+0x278e6c>
  9c:	85830205 	strhi	r0, [r3, #517]	; 0x205
  a0:	05830e05 	streq	r0, [r3, #3589]	; 0xe05
  a4:	84856702 	strhi	r6, [r5], #1794	; 0x702
  a8:	4c860105 	stfmis	f0, [r6], {5}
  ac:	4c854c85 	stcmi	12, cr4, [r5], {133}	; 0x85
  b0:	00020585 	andeq	r0, r2, r5, lsl #11
  b4:	4b010402 	blmi	410c4 <_bss_end+0x38884>
  b8:	01000202 	tsteq	r0, r2, lsl #4
  bc:	00032101 	andeq	r2, r3, r1, lsl #2
  c0:	69000300 	stmdbvs	r0, {r8, r9}
  c4:	02000001 	andeq	r0, r0, #1
  c8:	0d0efb01 	vstreq	d15, [lr, #-4]
  cc:	01010100 	mrseq	r0, (UNDEF: 17)
  d0:	00000001 	andeq	r0, r0, r1
  d4:	01000001 	tsteq	r0, r1
  d8:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 24 <_start-0x7fdc>
  dc:	69732f65 	ldmdbvs	r3!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
  e0:	7661686c 	strbtvc	r6, [r1], -ip, ror #16
  e4:	532f6a79 			; <UNDEFINED> instruction: 0x532f6a79
  e8:	6f6f6863 	svcvs	0x006f6863
  ec:	655a2f6c 	ldrbvs	r2, [sl, #-3948]	; 0xfffff094
  f0:	614d6f72 	hvcvs	55026	; 0xd6f2
  f4:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffb88 <_bss_end+0xffff7348>
  f8:	706d6178 	rsbvc	r6, sp, r8, ror r1
  fc:	2f73656c 	svccs	0x0073656c
 100:	5f44454c 	svcpl	0x0044454c
 104:	67676f74 			; <UNDEFINED> instruction: 0x67676f74
 108:	652f656c 	strvs	r6, [pc, #-1388]!	; fffffba4 <_bss_end+0xffff7364>
 10c:	63726578 	cmnvs	r2, #120, 10	; 0x1e000000
 110:	5f657369 	svcpl	0x00657369
 114:	302f3230 	eorcc	r3, pc, r0, lsr r2	; <UNPREDICTABLE>
 118:	656b5f32 	strbvs	r5, [fp, #-3890]!	; 0xfffff0ce
 11c:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
 120:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 124:	2f6c656e 	svccs	0x006c656e
 128:	2f637273 	svccs	0x00637273
 12c:	76697264 	strbtvc	r7, [r9], -r4, ror #4
 130:	00737265 	rsbseq	r7, r3, r5, ror #4
 134:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 80 <_start-0x7f80>
 138:	69732f65 	ldmdbvs	r3!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 13c:	7661686c 	strbtvc	r6, [r1], -ip, ror #16
 140:	532f6a79 			; <UNDEFINED> instruction: 0x532f6a79
 144:	6f6f6863 	svcvs	0x006f6863
 148:	655a2f6c 	ldrbvs	r2, [sl, #-3948]	; 0xfffff094
 14c:	614d6f72 	hvcvs	55026	; 0xd6f2
 150:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffbe4 <_bss_end+0xffff73a4>
 154:	706d6178 	rsbvc	r6, sp, r8, ror r1
 158:	2f73656c 	svccs	0x0073656c
 15c:	5f44454c 	svcpl	0x0044454c
 160:	67676f74 			; <UNDEFINED> instruction: 0x67676f74
 164:	652f656c 	strvs	r6, [pc, #-1388]!	; fffffc00 <_bss_end+0xffff73c0>
 168:	63726578 	cmnvs	r2, #120, 10	; 0x1e000000
 16c:	5f657369 	svcpl	0x00657369
 170:	302f3230 	eorcc	r3, pc, r0, lsr r2	; <UNPREDICTABLE>
 174:	656b5f32 	strbvs	r5, [fp, #-3890]!	; 0xfffff0ce
 178:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
 17c:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 180:	2f6c656e 	svccs	0x006c656e
 184:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 188:	2f656475 	svccs	0x00656475
 18c:	72616f62 	rsbvc	r6, r1, #392	; 0x188
 190:	70722f64 	rsbsvc	r2, r2, r4, ror #30
 194:	682f3069 	stmdavs	pc!, {r0, r3, r5, r6, ip, sp}	; <UNPREDICTABLE>
 198:	2f006c61 	svccs	0x00006c61
 19c:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
 1a0:	6c69732f 	stclvs	3, cr7, [r9], #-188	; 0xffffff44
 1a4:	79766168 	ldmdbvc	r6!, {r3, r5, r6, r8, sp, lr}^
 1a8:	63532f6a 	cmpvs	r3, #424	; 0x1a8
 1ac:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; 14 <_start-0x7fec>
 1b0:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
 1b4:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
 1b8:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 1bc:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
 1c0:	4c2f7365 	stcmi	3, cr7, [pc], #-404	; 34 <_start-0x7fcc>
 1c4:	745f4445 	ldrbvc	r4, [pc], #-1093	; 1cc <_start-0x7e34>
 1c8:	6c67676f 	stclvs	7, cr6, [r7], #-444	; 0xfffffe44
 1cc:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 1d0:	69637265 	stmdbvs	r3!, {r0, r2, r5, r6, r9, ip, sp, lr}^
 1d4:	305f6573 	subscc	r6, pc, r3, ror r5	; <UNPREDICTABLE>
 1d8:	32302f32 	eorscc	r2, r0, #50, 30	; 0xc8
 1dc:	72656b5f 	rsbvc	r6, r5, #97280	; 0x17c00
 1e0:	2f6c656e 	svccs	0x006c656e
 1e4:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 1e8:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 1ec:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 1f0:	642f6564 	strtvs	r6, [pc], #-1380	; 1f8 <_start-0x7e08>
 1f4:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
 1f8:	00007372 	andeq	r7, r0, r2, ror r3
 1fc:	6f697067 	svcvs	0x00697067
 200:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
 204:	00000100 	andeq	r0, r0, r0, lsl #2
 208:	64746e69 	ldrbtvs	r6, [r4], #-3689	; 0xfffff197
 20c:	682e6665 	stmdavs	lr!, {r0, r2, r5, r6, r9, sl, sp, lr}
 210:	00000200 	andeq	r0, r0, r0, lsl #4
 214:	69726570 	ldmdbvs	r2!, {r4, r5, r6, r8, sl, sp, lr}^
 218:	72656870 	rsbvc	r6, r5, #112, 16	; 0x700000
 21c:	2e736c61 	cdpcs	12, 7, cr6, cr3, cr1, {3}
 220:	00020068 	andeq	r0, r2, r8, rrx
 224:	69706700 	ldmdbvs	r0!, {r8, r9, sl, sp, lr}^
 228:	00682e6f 	rsbeq	r2, r8, pc, ror #28
 22c:	00000003 	andeq	r0, r0, r3
 230:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
 234:	0080f002 	addeq	pc, r0, r2
 238:	39051700 	stmdbcc	r5, {r8, r9, sl, ip}
 23c:	6901059f 	stmdbvs	r1, {r0, r1, r2, r3, r4, r7, r8, sl}
 240:	d70205a1 	strle	r0, [r2, -r1, lsr #11]
 244:	05670a05 	strbeq	r0, [r7, #-2565]!	; 0xfffff5fb
 248:	0f054c0e 	svceq	0x00054c0e
 24c:	40059208 	andmi	r9, r5, r8, lsl #4
 250:	2f0f0566 	svccs	0x000f0566
 254:	05664005 	strbeq	r4, [r6, #-5]!
 258:	40052f0f 	andmi	r2, r5, pc, lsl #30
 25c:	2f0f0566 	svccs	0x000f0566
 260:	05664005 	strbeq	r4, [r6, #-5]!
 264:	40052f0f 	andmi	r2, r5, pc, lsl #30
 268:	2f0f0566 	svccs	0x000f0566
 26c:	05664005 	strbeq	r4, [r6, #-5]!
 270:	17053111 	smladne	r5, r1, r1, r3
 274:	0a052008 	beq	14829c <_bss_end+0x13fa5c>
 278:	4c090566 	cfstr32mi	mvfx0, [r9], {102}	; 0x66
 27c:	a12f0105 			; <UNDEFINED> instruction: 0xa12f0105
 280:	05d70205 	ldrbeq	r0, [r7, #517]	; 0x205
 284:	0805670a 	stmdaeq	r5, {r1, r3, r8, r9, sl, sp, lr}
 288:	0402004c 	streq	r0, [r2], #-76	; 0xffffffb4
 28c:	00660601 	rsbeq	r0, r6, r1, lsl #12
 290:	4a020402 	bmi	812a0 <_bss_end+0x78a60>
 294:	02000605 	andeq	r0, r0, #5242880	; 0x500000
 298:	2e060404 	cdpcs	4, 0, cr0, cr6, cr4, {0}
 29c:	02001005 	andeq	r1, r0, #5
 2a0:	054b0404 	strbeq	r0, [fp, #-1028]	; 0xfffffbfc
 2a4:	0402000a 	streq	r0, [r2], #-10
 2a8:	09054a04 	stmdbeq	r5, {r2, r9, fp, lr}
 2ac:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
 2b0:	2f01054c 	svccs	0x0001054c
 2b4:	d7020585 	strle	r0, [r2, -r5, lsl #11]
 2b8:	05670a05 	strbeq	r0, [r7, #-2565]!	; 0xfffff5fb
 2bc:	02004c08 	andeq	r4, r0, #8, 24	; 0x800
 2c0:	66060104 	strvs	r0, [r6], -r4, lsl #2
 2c4:	02040200 	andeq	r0, r4, #0, 4
 2c8:	0006054a 	andeq	r0, r6, sl, asr #10
 2cc:	06040402 	streq	r0, [r4], -r2, lsl #8
 2d0:	0010052e 	andseq	r0, r0, lr, lsr #10
 2d4:	4b040402 	blmi	1012e4 <_bss_end+0xf8aa4>
 2d8:	02000a05 	andeq	r0, r0, #20480	; 0x5000
 2dc:	054a0404 	strbeq	r0, [sl, #-1028]	; 0xfffffbfc
 2e0:	04020009 	streq	r0, [r2], #-9
 2e4:	01054c04 	tsteq	r5, r4, lsl #24
 2e8:	0205852f 	andeq	r8, r5, #197132288	; 0xbc00000
 2ec:	670a05d7 			; <UNDEFINED> instruction: 0x670a05d7
 2f0:	004c0805 	subeq	r0, ip, r5, lsl #16
 2f4:	06010402 	streq	r0, [r1], -r2, lsl #8
 2f8:	04020066 	streq	r0, [r2], #-102	; 0xffffff9a
 2fc:	06054a02 	streq	r4, [r5], -r2, lsl #20
 300:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
 304:	10052e06 	andne	r2, r5, r6, lsl #28
 308:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
 30c:	000a054b 	andeq	r0, sl, fp, asr #10
 310:	4a040402 	bmi	101320 <_bss_end+0xf8ae0>
 314:	02000905 	andeq	r0, r0, #81920	; 0x14000
 318:	054c0404 	strbeq	r0, [ip, #-1028]	; 0xfffffbfc
 31c:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 320:	0605d81a 			; <UNDEFINED> instruction: 0x0605d81a
 324:	4a0205ba 	bmi	81a14 <_bss_end+0x791d4>
 328:	054d1005 	strbeq	r1, [sp, #-5]
 32c:	3b054a19 	blcc	152b98 <_bss_end+0x14a358>
 330:	661e0582 	ldrvs	r0, [lr], -r2, lsl #11
 334:	052e1b05 	streq	r1, [lr, #-2821]!	; 0xfffff4fb
 338:	28052f08 	stmdacs	r5, {r3, r8, r9, sl, fp, sp}
 33c:	4902052e 	stmdbmi	r2, {r1, r2, r3, r5, r8, sl}
 340:	054a0b05 	strbeq	r0, [sl, #-2821]	; 0xfffff4fb
 344:	0d056705 	stceq	7, cr6, [r5, #-20]	; 0xffffffec
 348:	4803052d 	stmdami	r3, {r0, r2, r3, r5, r8, sl}
 34c:	4d320105 	ldfmis	f0, [r2, #-20]!	; 0xffffffec
 350:	05a01a05 	streq	r1, [r0, #2565]!	; 0xa05
 354:	0205ba06 	andeq	fp, r5, #24576	; 0x6000
 358:	4b1a054a 	blmi	681888 <_bss_end+0x679048>
 35c:	054c2605 	strbeq	r2, [ip, #-1541]	; 0xfffff9fb
 360:	31054a2f 	tstcc	r5, pc, lsr #20
 364:	4a090582 	bmi	241974 <_bss_end+0x239134>
 368:	052e3c05 	streq	r3, [lr, #-3077]!	; 0xfffff3fb
 36c:	04020001 	streq	r0, [r2], #-1
 370:	05694b01 	strbeq	r4, [r9, #-2817]!	; 0xfffff4ff
 374:	3205d808 	andcc	sp, r5, #8, 16	; 0x80000
 378:	00210566 	eoreq	r0, r1, r6, ror #10
 37c:	4a020402 	bmi	8138c <_bss_end+0x78b4c>
 380:	02000605 	andeq	r0, r0, #5242880	; 0x500000
 384:	05f20204 	ldrbeq	r0, [r2, #516]!	; 0x204
 388:	04020032 	streq	r0, [r2], #-50	; 0xffffffce
 38c:	51054a03 	tstpl	r5, r3, lsl #20
 390:	06040200 	streq	r0, [r4], -r0, lsl #4
 394:	00350566 	eorseq	r0, r5, r6, ror #10
 398:	f2060402 	vshl.s8	d0, d2, d6
 39c:	02003205 	andeq	r3, r0, #1342177280	; 0x50000000
 3a0:	004a0704 	subeq	r0, sl, r4, lsl #14
 3a4:	06080402 	streq	r0, [r8], -r2, lsl #8
 3a8:	0002054a 	andeq	r0, r2, sl, asr #10
 3ac:	060a0402 	streq	r0, [sl], -r2, lsl #8
 3b0:	4d12052e 	cfldr32mi	mvfx0, [r2, #-184]	; 0xffffff48
 3b4:	05660205 	strbeq	r0, [r6, #-517]!	; 0xfffffdfb
 3b8:	12054a0b 	andne	r4, r5, #45056	; 0xb000
 3bc:	2e0d0566 	cfsh32cs	mvfx0, mvfx13, #54
 3c0:	05480305 	strbeq	r0, [r8, #-773]	; 0xfffffcfb
 3c4:	9e4a3101 	dvflse	f3, f2, f1
 3c8:	01040200 	mrseq	r0, R12_usr
 3cc:	23056606 	movwcs	r6, #22022	; 0x5606
 3d0:	7fa90306 	svcvc	0x00a90306
 3d4:	03010582 	movweq	r0, #5506	; 0x1582
 3d8:	ba6600d7 	blt	198073c <_bss_end+0x1977efc>
 3dc:	000a024a 	andeq	r0, sl, sl, asr #4
 3e0:	01950101 	orrseq	r0, r5, r1, lsl #2
 3e4:	00030000 	andeq	r0, r3, r0
 3e8:	00000150 	andeq	r0, r0, r0, asr r1
 3ec:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
 3f0:	0101000d 	tsteq	r1, sp
 3f4:	00000101 	andeq	r0, r0, r1, lsl #2
 3f8:	00000100 	andeq	r0, r0, r0, lsl #2
 3fc:	6f682f01 	svcvs	0x00682f01
 400:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
 404:	61686c69 	cmnvs	r8, r9, ror #24
 408:	2f6a7976 	svccs	0x006a7976
 40c:	6f686353 	svcvs	0x00686353
 410:	5a2f6c6f 	bpl	bdb5d4 <_bss_end+0xbd2d94>
 414:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 288 <_start-0x7d78>
 418:	2f657461 	svccs	0x00657461
 41c:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
 420:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
 424:	44454c2f 	strbmi	r4, [r5], #-3119	; 0xfffff3d1
 428:	676f745f 			; <UNDEFINED> instruction: 0x676f745f
 42c:	2f656c67 	svccs	0x00656c67
 430:	72657865 	rsbvc	r7, r5, #6619136	; 0x650000
 434:	65736963 	ldrbvs	r6, [r3, #-2403]!	; 0xfffff69d
 438:	2f32305f 	svccs	0x0032305f
 43c:	6b5f3230 	blvs	17ccd04 <_bss_end+0x17c44c4>
 440:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 444:	656b2f6c 	strbvs	r2, [fp, #-3948]!	; 0xfffff094
 448:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
 44c:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
 450:	6f682f00 	svcvs	0x00682f00
 454:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
 458:	61686c69 	cmnvs	r8, r9, ror #24
 45c:	2f6a7976 	svccs	0x006a7976
 460:	6f686353 	svcvs	0x00686353
 464:	5a2f6c6f 	bpl	bdb628 <_bss_end+0xbd2de8>
 468:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 2dc <_start-0x7d24>
 46c:	2f657461 	svccs	0x00657461
 470:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
 474:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
 478:	44454c2f 	strbmi	r4, [r5], #-3119	; 0xfffff3d1
 47c:	676f745f 			; <UNDEFINED> instruction: 0x676f745f
 480:	2f656c67 	svccs	0x00656c67
 484:	72657865 	rsbvc	r7, r5, #6619136	; 0x650000
 488:	65736963 	ldrbvs	r6, [r3, #-2403]!	; 0xfffff69d
 48c:	2f32305f 	svccs	0x0032305f
 490:	6b5f3230 	blvs	17ccd58 <_bss_end+0x17c4518>
 494:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 498:	656b2f6c 	strbvs	r2, [fp, #-3948]!	; 0xfffff094
 49c:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
 4a0:	636e692f 	cmnvs	lr, #770048	; 0xbc000
 4a4:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
 4a8:	616f622f 	cmnvs	pc, pc, lsr #4
 4ac:	722f6472 	eorvc	r6, pc, #1912602624	; 0x72000000
 4b0:	2f306970 	svccs	0x00306970
 4b4:	006c6168 	rsbeq	r6, ip, r8, ror #2
 4b8:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 404 <_start-0x7bfc>
 4bc:	69732f65 	ldmdbvs	r3!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 4c0:	7661686c 	strbtvc	r6, [r1], -ip, ror #16
 4c4:	532f6a79 			; <UNDEFINED> instruction: 0x532f6a79
 4c8:	6f6f6863 	svcvs	0x006f6863
 4cc:	655a2f6c 	ldrbvs	r2, [sl, #-3948]	; 0xfffff094
 4d0:	614d6f72 	hvcvs	55026	; 0xd6f2
 4d4:	652f6574 	strvs	r6, [pc, #-1396]!	; ffffff68 <_bss_end+0xffff7728>
 4d8:	706d6178 	rsbvc	r6, sp, r8, ror r1
 4dc:	2f73656c 	svccs	0x0073656c
 4e0:	5f44454c 	svcpl	0x0044454c
 4e4:	67676f74 			; <UNDEFINED> instruction: 0x67676f74
 4e8:	652f656c 	strvs	r6, [pc, #-1388]!	; ffffff84 <_bss_end+0xffff7744>
 4ec:	63726578 	cmnvs	r2, #120, 10	; 0x1e000000
 4f0:	5f657369 	svcpl	0x00657369
 4f4:	302f3230 	eorcc	r3, pc, r0, lsr r2	; <UNPREDICTABLE>
 4f8:	656b5f32 	strbvs	r5, [fp, #-3890]!	; 0xfffff0ce
 4fc:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
 500:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 504:	2f6c656e 	svccs	0x006c656e
 508:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 50c:	2f656475 	svccs	0x00656475
 510:	76697264 	strbtvc	r7, [r9], -r4, ror #4
 514:	00737265 	rsbseq	r7, r3, r5, ror #4
 518:	69616d00 	stmdbvs	r1!, {r8, sl, fp, sp, lr}^
 51c:	70632e6e 	rsbvc	r2, r3, lr, ror #28
 520:	00010070 	andeq	r0, r1, r0, ror r0
 524:	746e6900 	strbtvc	r6, [lr], #-2304	; 0xfffff700
 528:	2e666564 	cdpcs	5, 6, cr6, cr6, cr4, {3}
 52c:	00020068 	andeq	r0, r2, r8, rrx
 530:	69706700 	ldmdbvs	r0!, {r8, r9, sl, sp, lr}^
 534:	00682e6f 	rsbeq	r2, r8, pc, ror #28
 538:	00000003 	andeq	r0, r0, r3
 53c:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
 540:	00860002 	addeq	r0, r6, r2
 544:	19051800 	stmdbne	r5, {fp, ip}
 548:	89110568 	ldmdbhi	r1, {r3, r5, r6, r8, sl}
 54c:	02001a05 	andeq	r1, r0, #20480	; 0x5000
 550:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
 554:	04020009 	streq	r0, [r2], #-9
 558:	1305d602 	movwne	sp, #22018	; 0x5602
 55c:	85110586 	ldrhi	r0, [r1, #-1414]	; 0xfffffa7a
 560:	02001a05 	andeq	r1, r0, #20480	; 0x5000
 564:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
 568:	04020009 	streq	r0, [r2], #-9
 56c:	1305d602 	movwne	sp, #22018	; 0x5602
 570:	03110586 	tsteq	r1, #562036736	; 0x21800000
 574:	04028275 	streq	r8, [r2], #-629	; 0xfffffd8b
 578:	8a010100 	bhi	40980 <_bss_end+0x38140>
 57c:	03000000 	movweq	r0, #0
 580:	00007200 	andeq	r7, r0, r0, lsl #4
 584:	fb010200 	blx	40d8e <_bss_end+0x3854e>
 588:	01000d0e 	tsteq	r0, lr, lsl #26
 58c:	00010101 	andeq	r0, r1, r1, lsl #2
 590:	00010000 	andeq	r0, r1, r0
 594:	682f0100 	stmdavs	pc!, {r8}	; <UNPREDICTABLE>
 598:	2f656d6f 	svccs	0x00656d6f
 59c:	686c6973 	stmdavs	ip!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
 5a0:	6a797661 	bvs	1e5df2c <_bss_end+0x1e556ec>
 5a4:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
 5a8:	2f6c6f6f 	svccs	0x006c6f6f
 5ac:	6f72655a 	svcvs	0x0072655a
 5b0:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
 5b4:	6178652f 	cmnvs	r8, pc, lsr #10
 5b8:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
 5bc:	454c2f73 	strbmi	r2, [ip, #-3955]	; 0xfffff08d
 5c0:	6f745f44 	svcvs	0x00745f44
 5c4:	656c6767 	strbvs	r6, [ip, #-1895]!	; 0xfffff899
 5c8:	6578652f 	ldrbvs	r6, [r8, #-1327]!	; 0xfffffad1
 5cc:	73696372 	cmnvc	r9, #-939524095	; 0xc8000001
 5d0:	32305f65 	eorscc	r5, r0, #404	; 0x194
 5d4:	5f32302f 	svcpl	0x0032302f
 5d8:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 5dc:	6b2f6c65 	blvs	bdb778 <_bss_end+0xbd2f38>
 5e0:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 5e4:	72732f6c 	rsbsvc	r2, r3, #108, 30	; 0x1b0
 5e8:	73000063 	movwvc	r0, #99	; 0x63
 5ec:	74726174 	ldrbtvc	r6, [r2], #-372	; 0xfffffe8c
 5f0:	0100732e 	tsteq	r0, lr, lsr #6
 5f4:	00000000 	andeq	r0, r0, r0
 5f8:	80000205 	andhi	r0, r0, r5, lsl #4
 5fc:	2f190000 	svccs	0x00190000
 600:	302f2f2f 	eorcc	r2, pc, pc, lsr #30
 604:	01000202 	tsteq	r0, r2, lsl #4
 608:	0000f701 	andeq	pc, r0, r1, lsl #14
 60c:	76000300 	strvc	r0, [r0], -r0, lsl #6
 610:	02000000 	andeq	r0, r0, #0
 614:	0d0efb01 	vstreq	d15, [lr, #-4]
 618:	01010100 	mrseq	r0, (UNDEF: 17)
 61c:	00000001 	andeq	r0, r0, r1
 620:	01000001 	tsteq	r0, r1
 624:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 570 <_start-0x7a90>
 628:	69732f65 	ldmdbvs	r3!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 62c:	7661686c 	strbtvc	r6, [r1], -ip, ror #16
 630:	532f6a79 			; <UNDEFINED> instruction: 0x532f6a79
 634:	6f6f6863 	svcvs	0x006f6863
 638:	655a2f6c 	ldrbvs	r2, [sl, #-3948]	; 0xfffff094
 63c:	614d6f72 	hvcvs	55026	; 0xd6f2
 640:	652f6574 	strvs	r6, [pc, #-1396]!	; d4 <_start-0x7f2c>
 644:	706d6178 	rsbvc	r6, sp, r8, ror r1
 648:	2f73656c 	svccs	0x0073656c
 64c:	5f44454c 	svcpl	0x0044454c
 650:	67676f74 			; <UNDEFINED> instruction: 0x67676f74
 654:	652f656c 	strvs	r6, [pc, #-1388]!	; f0 <_start-0x7f10>
 658:	63726578 	cmnvs	r2, #120, 10	; 0x1e000000
 65c:	5f657369 	svcpl	0x00657369
 660:	302f3230 	eorcc	r3, pc, r0, lsr r2	; <UNPREDICTABLE>
 664:	656b5f32 	strbvs	r5, [fp, #-3890]!	; 0xfffff0ce
 668:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
 66c:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 670:	2f6c656e 	svccs	0x006c656e
 674:	00637273 	rsbeq	r7, r3, r3, ror r2
 678:	61747300 	cmnvs	r4, r0, lsl #6
 67c:	70757472 	rsbsvc	r7, r5, r2, ror r4
 680:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
 684:	00000100 	andeq	r0, r0, r0, lsl #2
 688:	00010500 	andeq	r0, r1, r0, lsl #10
 68c:	86ac0205 	strthi	r0, [ip], r5, lsl #4
 690:	14030000 	strne	r0, [r3], #-0
 694:	6a090501 	bvs	241aa0 <_bss_end+0x239260>
 698:	02001f05 	andeq	r1, r0, #5, 30
 69c:	05660304 	strbeq	r0, [r6, #-772]!	; 0xfffffcfc
 6a0:	04020006 	streq	r0, [r2], #-6
 6a4:	0205bb02 	andeq	fp, r5, #2048	; 0x800
 6a8:	02040200 	andeq	r0, r4, #0, 4
 6ac:	85090565 	strhi	r0, [r9, #-1381]	; 0xfffffa9b
 6b0:	bd2f0105 	stflts	f0, [pc, #-20]!	; 6a4 <_start-0x795c>
 6b4:	056b0d05 	strbeq	r0, [fp, #-3333]!	; 0xfffff2fb
 6b8:	04020024 	streq	r0, [r2], #-36	; 0xffffffdc
 6bc:	04054a03 	streq	r4, [r5], #-2563	; 0xfffff5fd
 6c0:	02040200 	andeq	r0, r4, #0, 4
 6c4:	000b0583 	andeq	r0, fp, r3, lsl #11
 6c8:	4a020402 	bmi	816d8 <_bss_end+0x78e98>
 6cc:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
 6d0:	052d0204 	streq	r0, [sp, #-516]!	; 0xfffffdfc
 6d4:	01058509 	tsteq	r5, r9, lsl #10
 6d8:	0d05a12f 	stfeqd	f2, [r5, #-188]	; 0xffffff44
 6dc:	0024056a 	eoreq	r0, r4, sl, ror #10
 6e0:	4a030402 	bmi	c16f0 <_bss_end+0xb8eb0>
 6e4:	02000405 	andeq	r0, r0, #83886080	; 0x5000000
 6e8:	05830204 	streq	r0, [r3, #516]	; 0x204
 6ec:	0402000b 	streq	r0, [r2], #-11
 6f0:	02054a02 	andeq	r4, r5, #8192	; 0x2000
 6f4:	02040200 	andeq	r0, r4, #0, 4
 6f8:	8509052d 	strhi	r0, [r9, #-1325]	; 0xfffffad3
 6fc:	022f0105 	eoreq	r0, pc, #1073741825	; 0x40000001
 700:	0101000a 	tsteq	r1, sl
 704:	00000103 	andeq	r0, r0, r3, lsl #2
 708:	00fd0003 	rscseq	r0, sp, r3
 70c:	01020000 	mrseq	r0, (UNDEF: 2)
 710:	000d0efb 	strdeq	r0, [sp], -fp
 714:	01010101 	tsteq	r1, r1, lsl #2
 718:	01000000 	mrseq	r0, (UNDEF: 0)
 71c:	2e010000 	cdpcs	0, 0, cr0, cr1, cr0, {0}
 720:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 724:	2f2e2e2f 	svccs	0x002e2e2f
 728:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 72c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 730:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
 734:	2f636367 	svccs	0x00636367
 738:	692f2e2e 	stmdbvs	pc!, {r1, r2, r3, r5, r9, sl, fp, sp}	; <UNPREDICTABLE>
 73c:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 740:	2e006564 	cfsh32cs	mvfx6, mvfx0, #52
 744:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 748:	2f2e2e2f 	svccs	0x002e2e2f
 74c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 750:	2f2e2f2e 	svccs	0x002e2f2e
 754:	00636367 	rsbeq	r6, r3, r7, ror #6
 758:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 75c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 760:	2f2e2e2f 	svccs	0x002e2e2f
 764:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 768:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
 76c:	63636762 	cmnvs	r3, #25690112	; 0x1880000
 770:	2f2e2e2f 	svccs	0x002e2e2f
 774:	2f636367 	svccs	0x00636367
 778:	666e6f63 	strbtvs	r6, [lr], -r3, ror #30
 77c:	612f6769 			; <UNDEFINED> instruction: 0x612f6769
 780:	2e006d72 	mcrcs	13, 0, r6, cr0, cr2, {3}
 784:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 788:	2f2e2e2f 	svccs	0x002e2e2f
 78c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 790:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 794:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
 798:	00636367 	rsbeq	r6, r3, r7, ror #6
 79c:	73616800 	cmnvc	r1, #0, 16
 7a0:	62617468 	rsbvs	r7, r1, #104, 8	; 0x68000000
 7a4:	0100682e 	tsteq	r0, lr, lsr #16
 7a8:	72610000 	rsbvc	r0, r1, #0
 7ac:	73692d6d 	cmnvc	r9, #6976	; 0x1b40
 7b0:	00682e61 	rsbeq	r2, r8, r1, ror #28
 7b4:	61000002 	tstvs	r0, r2
 7b8:	632d6d72 			; <UNDEFINED> instruction: 0x632d6d72
 7bc:	682e7570 	stmdavs	lr!, {r4, r5, r6, r8, sl, ip, sp, lr}
 7c0:	00000200 	andeq	r0, r0, r0, lsl #4
 7c4:	6e736e69 	cdpvs	14, 7, cr6, cr3, cr9, {3}
 7c8:	6e6f632d 	cdpvs	3, 6, cr6, cr15, cr13, {1}
 7cc:	6e617473 	mcrvs	4, 3, r7, cr1, cr3, {3}
 7d0:	682e7374 	stmdavs	lr!, {r2, r4, r5, r6, r8, r9, ip, sp, lr}
 7d4:	00000200 	andeq	r0, r0, r0, lsl #4
 7d8:	2e6d7261 	cdpcs	2, 6, cr7, cr13, cr1, {3}
 7dc:	00030068 	andeq	r0, r3, r8, rrx
 7e0:	62696c00 	rsbvs	r6, r9, #0, 24
 7e4:	32636367 	rsbcc	r6, r3, #-1677721599	; 0x9c000001
 7e8:	0400682e 	streq	r6, [r0], #-2094	; 0xfffff7d2
 7ec:	62670000 	rsbvs	r0, r7, #0
 7f0:	74632d6c 	strbtvc	r2, [r3], #-3436	; 0xfffff294
 7f4:	2e73726f 	cdpcs	2, 7, cr7, cr3, cr15, {3}
 7f8:	00040068 	andeq	r0, r4, r8, rrx
 7fc:	62696c00 	rsbvs	r6, r9, #0, 24
 800:	32636367 	rsbcc	r6, r3, #-1677721599	; 0x9c000001
 804:	0400632e 	streq	r6, [r0], #-814	; 0xfffffcd2
 808:	Address 0x0000000000000808 is out of bounds.


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
      28:	5f44454c 	svcpl	0x0044454c
      2c:	67676f74 			; <UNDEFINED> instruction: 0x67676f74
      30:	652f656c 	strvs	r6, [pc, #-1388]!	; fffffacc <_bss_end+0xffff728c>
      34:	63726578 	cmnvs	r2, #120, 10	; 0x1e000000
      38:	5f657369 	svcpl	0x00657369
      3c:	302f3230 	eorcc	r3, pc, r0, lsr r2	; <UNPREDICTABLE>
      40:	656b5f32 	strbvs	r5, [fp, #-3890]!	; 0xfffff0ce
      44:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
      48:	6975622f 	ldmdbvs	r5!, {r0, r1, r2, r3, r5, r9, sp, lr}^
      4c:	4700646c 	strmi	r6, [r0, -ip, ror #8]
      50:	4320554e 			; <UNDEFINED> instruction: 0x4320554e
      54:	34312b2b 	ldrtcc	r2, [r1], #-2859	; 0xfffff4d5
      58:	322e3920 	eorcc	r3, lr, #32, 18	; 0x80000
      5c:	3220312e 	eorcc	r3, r0, #-2147483637	; 0x8000000b
      60:	31393130 	teqcc	r9, r0, lsr r1
      64:	20353230 	eorscs	r3, r5, r0, lsr r2
      68:	6c657228 	sfmvs	f7, 2, [r5], #-160	; 0xffffff60
      6c:	65736165 	ldrbvs	r6, [r3, #-357]!	; 0xfffffe9b
      70:	415b2029 	cmpmi	fp, r9, lsr #32
      74:	612f4d52 			; <UNDEFINED> instruction: 0x612f4d52
      78:	392d6d72 	pushcc	{r1, r4, r5, r6, r8, sl, fp, sp, lr}
      7c:	6172622d 	cmnvs	r2, sp, lsr #4
      80:	2068636e 	rsbcs	r6, r8, lr, ror #6
      84:	69766572 	ldmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
      88:	6e6f6973 			; <UNDEFINED> instruction: 0x6e6f6973
      8c:	37373220 	ldrcc	r3, [r7, -r0, lsr #4]!
      90:	5d393935 			; <UNDEFINED> instruction: 0x5d393935
      94:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
      98:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
      9c:	6962612d 	stmdbvs	r2!, {r0, r2, r3, r5, r8, sp, lr}^
      a0:	7261683d 	rsbvc	r6, r1, #3997696	; 0x3d0000
      a4:	6d2d2064 	stcvs	0, cr2, [sp, #-400]!	; 0xfffffe70
      a8:	3d757066 	ldclcc	0, cr7, [r5, #-408]!	; 0xfffffe68
      ac:	20706676 	rsbscs	r6, r0, r6, ror r6
      b0:	6c666d2d 	stclvs	13, cr6, [r6], #-180	; 0xffffff4c
      b4:	2d74616f 	ldfcse	f6, [r4, #-444]!	; 0xfffffe44
      b8:	3d696261 	sfmcc	f6, 2, [r9, #-388]!	; 0xfffffe7c
      bc:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
      c0:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
      c4:	763d7570 			; <UNDEFINED> instruction: 0x763d7570
      c8:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
      cc:	6e75746d 	cdpvs	4, 7, cr7, cr5, cr13, {3}
      d0:	72613d65 	rsbvc	r3, r1, #6464	; 0x1940
      d4:	3731316d 	ldrcc	r3, [r1, -sp, ror #2]!
      d8:	667a6a36 			; <UNDEFINED> instruction: 0x667a6a36
      dc:	2d20732d 	stccs	3, cr7, [r0, #-180]!	; 0xffffff4c
      e0:	6d72616d 	ldfvse	f6, [r2, #-436]!	; 0xfffffe4c
      e4:	616d2d20 	cmnvs	sp, r0, lsr #26
      e8:	3d686372 	stclcc	3, cr6, [r8, #-456]!	; 0xfffffe38
      ec:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
      f0:	2b6b7a36 	blcs	1ade9d0 <_bss_end+0x1ad6190>
      f4:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
      f8:	672d2067 	strvs	r2, [sp, -r7, rrx]!
      fc:	304f2d20 	subcc	r2, pc, r0, lsr #26
     100:	304f2d20 	subcc	r2, pc, r0, lsr #26
     104:	635f5f00 	cmpvs	pc, #0, 30
     108:	675f6178 			; <UNDEFINED> instruction: 0x675f6178
     10c:	64726175 	ldrbtvs	r6, [r2], #-373	; 0xfffffe8b
     110:	6c65725f 	sfmvs	f7, 2, [r5], #-380	; 0xfffffe84
     114:	65736165 	ldrbvs	r6, [r3, #-357]!	; 0xfffffe9b
     118:	635f5f00 	cmpvs	pc, #0, 30
     11c:	675f6178 			; <UNDEFINED> instruction: 0x675f6178
     120:	64726175 	ldrbtvs	r6, [r2], #-373	; 0xfffffe8b
     124:	6f62615f 	svcvs	0x0062615f
     128:	5f007472 	svcpl	0x00007472
     12c:	6f73645f 	svcvs	0x0073645f
     130:	6e61685f 	mcrvs	8, 3, r6, cr1, cr15, {2}
     134:	00656c64 	rsbeq	r6, r5, r4, ror #24
     138:	78635f5f 	stmdavc	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, sl, fp, ip, lr}^
     13c:	74615f61 	strbtvc	r5, [r1], #-3937	; 0xfffff09f
     140:	74697865 	strbtvc	r7, [r9], #-2149	; 0xfffff79b
     144:	6f682f00 	svcvs	0x00682f00
     148:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
     14c:	61686c69 	cmnvs	r8, r9, ror #24
     150:	2f6a7976 	svccs	0x006a7976
     154:	6f686353 	svcvs	0x00686353
     158:	5a2f6c6f 	bpl	bdb31c <_bss_end+0xbd2adc>
     15c:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; ffffffd0 <_bss_end+0xffff7790>
     160:	2f657461 	svccs	0x00657461
     164:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
     168:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
     16c:	44454c2f 	strbmi	r4, [r5], #-3119	; 0xfffff3d1
     170:	676f745f 			; <UNDEFINED> instruction: 0x676f745f
     174:	2f656c67 	svccs	0x00656c67
     178:	72657865 	rsbvc	r7, r5, #6619136	; 0x650000
     17c:	65736963 	ldrbvs	r6, [r3, #-2403]!	; 0xfffff69d
     180:	2f32305f 	svccs	0x0032305f
     184:	6b5f3230 	blvs	17cca4c <_bss_end+0x17c420c>
     188:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
     18c:	656b2f6c 	strbvs	r2, [fp, #-3948]!	; 0xfffff094
     190:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
     194:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
     198:	7878632f 	ldmdavc	r8!, {r0, r1, r2, r3, r5, r8, r9, sp, lr}^
     19c:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
     1a0:	635f5f00 	cmpvs	pc, #0, 30
     1a4:	675f6178 			; <UNDEFINED> instruction: 0x675f6178
     1a8:	64726175 	ldrbtvs	r6, [r2], #-373	; 0xfffffe8b
     1ac:	7163615f 	cmnvc	r3, pc, asr r1
     1b0:	65726975 	ldrbvs	r6, [r2, #-2421]!	; 0xfffff68b
     1b4:	635f5f00 	cmpvs	pc, #0, 30
     1b8:	62617878 	rsbvs	r7, r1, #120, 16	; 0x780000
     1bc:	00317669 	eorseq	r7, r1, r9, ror #12
     1c0:	78635f5f 	stmdavc	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, sl, fp, ip, lr}^
     1c4:	75705f61 	ldrbvc	r5, [r0, #-3937]!	; 0xfffff09f
     1c8:	765f6572 			; <UNDEFINED> instruction: 0x765f6572
     1cc:	75747269 	ldrbvc	r7, [r4, #-617]!	; 0xfffffd97
     1d0:	5f006c61 	svcpl	0x00006c61
     1d4:	6165615f 	cmnvs	r5, pc, asr r1
     1d8:	755f6962 	ldrbvc	r6, [pc, #-2402]	; fffff87e <_bss_end+0xffff703e>
     1dc:	6e69776e 	cdpvs	7, 6, cr7, cr9, cr14, {3}
     1e0:	70635f64 	rsbvc	r5, r3, r4, ror #30
     1e4:	72705f70 	rsbsvc	r5, r0, #112, 30	; 0x1c0
     1e8:	5f5f0031 	svcpl	0x005f0031
     1ec:	72617567 	rsbvc	r7, r1, #432013312	; 0x19c00000
     1f0:	6f6c0064 	svcvs	0x006c0064
     1f4:	6c20676e 	stcvs	7, cr6, [r0], #-440	; 0xfffffe48
     1f8:	20676e6f 	rsbcs	r6, r7, pc, ror #28
     1fc:	00746e69 	rsbseq	r6, r4, r9, ror #28
     200:	45525047 	ldrbmi	r5, [r2, #-71]	; 0xffffffb9
     204:	4700304e 	strmi	r3, [r0, -lr, asr #32]
     208:	4e455250 	mcrmi	2, 2, r5, cr5, cr0, {2}
     20c:	50470031 	subpl	r0, r7, r1, lsr r0
     210:	4e454641 	cdpmi	6, 4, cr4, cr5, cr1, {2}
     214:	47430031 	smlaldxmi	r0, r3, r1, r0
     218:	5f4f4950 	svcpl	0x004f4950
     21c:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     220:	0072656c 	rsbseq	r6, r2, ip, ror #10
     224:	5f746553 	svcpl	0x00746553
     228:	7074754f 	rsbsvc	r7, r4, pc, asr #10
     22c:	55007475 	strpl	r7, [r0, #-1141]	; 0xfffffb8b
     230:	6570736e 	ldrbvs	r7, [r0, #-878]!	; 0xfffffc92
     234:	69666963 	stmdbvs	r6!, {r0, r1, r5, r6, r8, fp, sp, lr}^
     238:	67006465 	strvs	r6, [r0, -r5, ror #8]
     23c:	5f6f6970 	svcpl	0x006f6970
     240:	65736162 	ldrbvs	r6, [r3, #-354]!	; 0xfffffe9e
     244:	6464615f 	strbtvs	r6, [r4], #-351	; 0xfffffea1
     248:	50470072 	subpl	r0, r7, r2, ror r0
     24c:	314e4548 	cmpcc	lr, r8, asr #10
     250:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     254:	4333314b 	teqmi	r3, #-1073741806	; 0xc0000012
     258:	4f495047 	svcmi	0x00495047
     25c:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     260:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     264:	65473831 	strbvs	r3, [r7, #-2097]	; 0xfffff7cf
     268:	50475f74 	subpl	r5, r7, r4, ror pc
     26c:	5f56454c 	svcpl	0x0056454c
     270:	61636f4c 	cmnvs	r3, ip, asr #30
     274:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     278:	6a526a45 	bvs	149ab94 <_bss_end+0x1492354>
     27c:	005f3053 	subseq	r3, pc, r3, asr r0	; <UNPREDICTABLE>
     280:	5f746547 	svcpl	0x00746547
     284:	4f495047 	svcmi	0x00495047
     288:	6e75465f 	mrcvs	6, 3, r4, cr5, cr15, {2}
     28c:	6f697463 	svcvs	0x00697463
     290:	5a5f006e 	bpl	17c0450 <_bss_end+0x17b7c10>
     294:	33314b4e 	teqcc	r1, #79872	; 0x13800
     298:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     29c:	61485f4f 	cmpvs	r8, pc, asr #30
     2a0:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     2a4:	47383172 			; <UNDEFINED> instruction: 0x47383172
     2a8:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     2ac:	54455350 	strbpl	r5, [r5], #-848	; 0xfffffcb0
     2b0:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     2b4:	6f697461 	svcvs	0x00697461
     2b8:	526a456e 	rsbpl	r4, sl, #461373440	; 0x1b800000
     2bc:	5f30536a 	svcpl	0x0030536a
     2c0:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     2c4:	4333314b 	teqmi	r3, #-1073741806	; 0xc0000012
     2c8:	4f495047 	svcmi	0x00495047
     2cc:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     2d0:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     2d4:	65473831 	strbvs	r3, [r7, #-2097]	; 0xfffff7cf
     2d8:	50475f74 	subpl	r5, r7, r4, ror pc
     2dc:	5f524c43 	svcpl	0x00524c43
     2e0:	61636f4c 	cmnvs	r3, ip, asr #30
     2e4:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     2e8:	6a526a45 	bvs	149ac04 <_bss_end+0x14923c4>
     2ec:	005f3053 	subseq	r3, pc, r3, asr r0	; <UNPREDICTABLE>
     2f0:	4c435047 	mcrrmi	0, 4, r5, r3, cr7
     2f4:	5f003152 	svcpl	0x00003152
     2f8:	424f4c47 	submi	r4, pc, #18176	; 0x4700
     2fc:	5f5f4c41 	svcpl	0x005f4c41
     300:	5f627573 	svcpl	0x00627573
     304:	47735f49 	ldrbmi	r5, [r3, -r9, asr #30]!
     308:	004f4950 	subeq	r4, pc, r0, asr r9	; <UNPREDICTABLE>
     30c:	5f746547 	svcpl	0x00746547
     310:	53465047 	movtpl	r5, #24647	; 0x6047
     314:	4c5f4c45 	mrrcmi	12, 4, r4, pc, cr5	; <UNPREDICTABLE>
     318:	7461636f 	strbtvc	r6, [r1], #-879	; 0xfffffc91
     31c:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     320:	4b4e5a5f 	blmi	1396ca4 <_bss_end+0x138e464>
     324:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     328:	5f4f4950 	svcpl	0x004f4950
     32c:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     330:	3172656c 	cmncc	r2, ip, ror #10
     334:	74654739 	strbtvc	r4, [r5], #-1849	; 0xfffff8c7
     338:	4650475f 			; <UNDEFINED> instruction: 0x4650475f
     33c:	5f4c4553 	svcpl	0x004c4553
     340:	61636f4c 	cmnvs	r3, ip, asr #30
     344:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     348:	6a526a45 	bvs	149ac64 <_bss_end+0x1492424>
     34c:	005f3053 	subseq	r3, pc, r3, asr r0	; <UNPREDICTABLE>
     350:	5f746547 	svcpl	0x00746547
     354:	45535047 	ldrbmi	r5, [r3, #-71]	; 0xffffffb9
     358:	6f4c5f54 	svcvs	0x004c5f54
     35c:	69746163 	ldmdbvs	r4!, {r0, r1, r5, r6, r8, sp, lr}^
     360:	47006e6f 	strmi	r6, [r0, -pc, ror #28]
     364:	5f4f4950 	svcpl	0x004f4950
     368:	00676552 	rsbeq	r6, r7, r2, asr r5
     36c:	5f746c41 	svcpl	0x00746c41
     370:	50470033 	subpl	r0, r7, r3, lsr r0
     374:	3056454c 	subscc	r4, r6, ip, asr #10
     378:	4c504700 	mrrcmi	7, 0, r4, r0, cr0
     37c:	00315645 	eorseq	r5, r1, r5, asr #12
     380:	5f746c41 	svcpl	0x00746c41
     384:	6c410032 	mcrrvs	0, 3, r0, r1, cr2
     388:	00315f74 	eorseq	r5, r1, r4, ror pc
     38c:	55505047 	ldrbpl	r5, [r0, #-71]	; 0xffffffb9
     390:	6e750044 	cdpvs	0, 7, cr0, cr5, cr4, {2}
     394:	6e676973 			; <UNDEFINED> instruction: 0x6e676973
     398:	63206465 			; <UNDEFINED> instruction: 0x63206465
     39c:	00726168 	rsbseq	r6, r2, r8, ror #2
     3a0:	55505047 	ldrbpl	r5, [r0, #-71]	; 0xffffffb9
     3a4:	4b4c4344 	blmi	13110bc <_bss_end+0x130887c>
     3a8:	6c410030 	mcrrvs	0, 3, r0, r1, cr0
     3ac:	00305f74 	eorseq	r5, r0, r4, ror pc
     3b0:	5f746547 	svcpl	0x00746547
     3b4:	4c435047 	mcrrmi	0, 4, r5, r3, cr7
     3b8:	6f4c5f52 	svcvs	0x004c5f52
     3bc:	69746163 	ldmdbvs	r4!, {r0, r1, r5, r6, r8, sp, lr}^
     3c0:	47006e6f 	strmi	r6, [r0, -pc, ror #28]
     3c4:	44555050 	ldrbmi	r5, [r5], #-80	; 0xffffffb0
     3c8:	314b4c43 	cmpcc	fp, r3, asr #24
     3cc:	43504700 	cmpmi	r0, #0, 14
     3d0:	0030524c 	eorseq	r5, r0, ip, asr #4
     3d4:	726f6873 	rsbvc	r6, pc, #7536640	; 0x730000
     3d8:	6e752074 	mrcvs	0, 3, r2, cr5, cr4, {3}
     3dc:	6e676973 			; <UNDEFINED> instruction: 0x6e676973
     3e0:	69206465 	stmdbvs	r0!, {r0, r2, r5, r6, sl, sp, lr}
     3e4:	4700746e 	strmi	r7, [r0, -lr, ror #8]
     3e8:	5f4f4950 	svcpl	0x004f4950
     3ec:	5f6e6950 	svcpl	0x006e6950
     3f0:	6e756f43 	cdpvs	15, 7, cr6, cr5, cr3, {2}
     3f4:	50470074 	subpl	r0, r7, r4, ror r0
     3f8:	30544553 	subscc	r4, r4, r3, asr r5
     3fc:	53504700 	cmppl	r0, #0, 14
     400:	00315445 	eorseq	r5, r1, r5, asr #8
     404:	5f746c41 	svcpl	0x00746c41
     408:	6c410034 	mcrrvs	0, 3, r0, r1, cr4
     40c:	00355f74 	eorseq	r5, r5, r4, ror pc
     410:	314e5a5f 	cmpcc	lr, pc, asr sl
     414:	50474333 	subpl	r4, r7, r3, lsr r3
     418:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     41c:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     420:	30317265 	eorscc	r7, r1, r5, ror #4
     424:	5f746553 	svcpl	0x00746553
     428:	7074754f 	rsbsvc	r7, r4, pc, asr #10
     42c:	6a457475 	bvs	115d608 <_bss_end+0x1154dc8>
     430:	65530062 	ldrbvs	r0, [r3, #-98]	; 0xffffff9e
     434:	50475f74 	subpl	r5, r7, r4, ror pc
     438:	465f4f49 	ldrbmi	r4, [pc], -r9, asr #30
     43c:	74636e75 	strbtvc	r6, [r3], #-3701	; 0xfffff18b
     440:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     444:	45465047 	strbmi	r5, [r6, #-71]	; 0xffffffb9
     448:	4700304e 	strmi	r3, [r0, -lr, asr #32]
     44c:	4e454650 	mcrmi	6, 2, r4, cr5, cr0, {2}
     450:	75660031 	strbvc	r0, [r6, #-49]!	; 0xffffffcf
     454:	4700636e 	strmi	r6, [r0, -lr, ror #6]
     458:	45534650 	ldrbmi	r4, [r3, #-1616]	; 0xfffff9b0
     45c:	5000344c 	andpl	r3, r0, ip, asr #8
     460:	70697265 	rsbvc	r7, r9, r5, ror #4
     464:	61726568 	cmnvs	r2, r8, ror #10
     468:	61425f6c 	cmpvs	r2, ip, ror #30
     46c:	49006573 	stmdbmi	r0, {r0, r1, r4, r5, r6, r8, sl, sp, lr}
     470:	7475706e 	ldrbtvc	r7, [r5], #-110	; 0xffffff92
     474:	705f5f00 	subsvc	r5, pc, r0, lsl #30
     478:	726f6972 	rsbvc	r6, pc, #1867776	; 0x1c8000
     47c:	00797469 	rsbseq	r7, r9, r9, ror #8
     480:	44455047 	strbmi	r5, [r5], #-71	; 0xffffffb9
     484:	47003053 	smlsdmi	r0, r3, r0, r3
     488:	53444550 	movtpl	r4, #17744	; 0x4550
     48c:	50470031 	subpl	r0, r7, r1, lsr r0
     490:	4e455241 	cdpmi	2, 4, cr5, cr5, cr1, {2}
     494:	50470030 	subpl	r0, r7, r0, lsr r0
     498:	4e455241 	cdpmi	2, 4, cr5, cr5, cr1, {2}
     49c:	69750031 	ldmdbvs	r5!, {r0, r4, r5}^
     4a0:	5f38746e 	svcpl	0x0038746e
     4a4:	68740074 	ldmdavs	r4!, {r2, r4, r5, r6}^
     4a8:	5f007369 	svcpl	0x00007369
     4ac:	314b4e5a 	cmpcc	fp, sl, asr lr
     4b0:	50474333 	subpl	r4, r7, r3, lsr r3
     4b4:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     4b8:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     4bc:	37317265 	ldrcc	r7, [r1, -r5, ror #4]!
     4c0:	5f746547 	svcpl	0x00746547
     4c4:	4f495047 	svcmi	0x00495047
     4c8:	6e75465f 	mrcvs	6, 3, r4, cr5, cr15, {2}
     4cc:	6f697463 	svcvs	0x00697463
     4d0:	006a456e 	rsbeq	r4, sl, lr, ror #10
     4d4:	314e5a5f 	cmpcc	lr, pc, asr sl
     4d8:	50474333 	subpl	r4, r7, r3, lsr r3
     4dc:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     4e0:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     4e4:	37317265 	ldrcc	r7, [r1, -r5, ror #4]!
     4e8:	5f746553 	svcpl	0x00746553
     4ec:	4f495047 	svcmi	0x00495047
     4f0:	6e75465f 	mrcvs	6, 3, r4, cr5, cr15, {2}
     4f4:	6f697463 	svcvs	0x00697463
     4f8:	316a456e 	cmncc	sl, lr, ror #10
     4fc:	50474e34 	subpl	r4, r7, r4, lsr lr
     500:	465f4f49 	ldrbmi	r4, [pc], -r9, asr #30
     504:	74636e75 	strbtvc	r6, [r3], #-3701	; 0xfffff18b
     508:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     50c:	314e5a5f 	cmpcc	lr, pc, asr sl
     510:	50474333 	subpl	r4, r7, r3, lsr r3
     514:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     518:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     51c:	32437265 	subcc	r7, r3, #1342177286	; 0x50000006
     520:	6d006a45 	vstrvs	s12, [r0, #-276]	; 0xfffffeec
     524:	4f495047 	svcmi	0x00495047
     528:	41504700 	cmpmi	r0, r0, lsl #14
     52c:	304e4546 	subcc	r4, lr, r6, asr #10
     530:	4c504700 	mrrcmi	7, 0, r4, r0, cr0
     534:	00304e45 	eorseq	r4, r0, r5, asr #28
     538:	454c5047 	strbmi	r5, [ip, #-71]	; 0xffffffb9
     53c:	6200314e 	andvs	r3, r0, #-2147483629	; 0x80000013
     540:	695f7469 	ldmdbvs	pc, {r0, r3, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
     544:	73007864 	movwvc	r7, #2148	; 0x864
     548:	74726f68 	ldrbtvc	r6, [r2], #-3944	; 0xfffff098
     54c:	746e6920 	strbtvc	r6, [lr], #-2336	; 0xfffff6e0
     550:	6e697500 	cdpvs	5, 6, cr7, cr9, cr0, {0}
     554:	5f323374 	svcpl	0x00323374
     558:	6f620074 	svcvs	0x00620074
     55c:	47006c6f 	strmi	r6, [r0, -pc, ror #24]
     560:	4e454850 	mcrmi	8, 2, r4, cr5, cr0, {2}
     564:	682f0030 	stmdavs	pc!, {r4, r5}	; <UNPREDICTABLE>
     568:	2f656d6f 	svccs	0x00656d6f
     56c:	686c6973 	stmdavs	ip!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
     570:	6a797661 	bvs	1e5defc <_bss_end+0x1e556bc>
     574:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
     578:	2f6c6f6f 	svccs	0x006c6f6f
     57c:	6f72655a 	svcvs	0x0072655a
     580:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
     584:	6178652f 	cmnvs	r8, pc, lsr #10
     588:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
     58c:	454c2f73 	strbmi	r2, [ip, #-3955]	; 0xfffff08d
     590:	6f745f44 	svcvs	0x00745f44
     594:	656c6767 	strbvs	r6, [ip, #-1895]!	; 0xfffff899
     598:	6578652f 	ldrbvs	r6, [r8, #-1327]!	; 0xfffffad1
     59c:	73696372 	cmnvc	r9, #-939524095	; 0xc8000001
     5a0:	32305f65 	eorscc	r5, r0, #404	; 0x194
     5a4:	5f32302f 	svcpl	0x0032302f
     5a8:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
     5ac:	6b2f6c65 	blvs	bdb748 <_bss_end+0xbd2f08>
     5b0:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
     5b4:	72732f6c 	rsbsvc	r2, r3, #108, 30	; 0x1b0
     5b8:	72642f63 	rsbvc	r2, r4, #396	; 0x18c
     5bc:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
     5c0:	70672f73 	rsbvc	r2, r7, r3, ror pc
     5c4:	632e6f69 			; <UNDEFINED> instruction: 0x632e6f69
     5c8:	5f007070 	svcpl	0x00007070
     5cc:	696e695f 	stmdbvs	lr!, {r0, r1, r2, r3, r4, r6, r8, fp, sp, lr}^
     5d0:	6c616974 			; <UNDEFINED> instruction: 0x6c616974
     5d4:	5f657a69 	svcpl	0x00657a69
     5d8:	5a5f0070 	bpl	17c07a0 <_bss_end+0x17b7f60>
     5dc:	4333314e 	teqmi	r3, #-2147483629	; 0x80000013
     5e0:	4f495047 	svcmi	0x00495047
     5e4:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     5e8:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     5ec:	6a453443 	bvs	114d700 <_bss_end+0x1144ec0>
     5f0:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     5f4:	4c50475f 	mrrcmi	7, 5, r4, r0, cr15
     5f8:	4c5f5645 	mrrcmi	6, 4, r5, pc, cr5	; <UNPREDICTABLE>
     5fc:	7461636f 	strbtvc	r6, [r1], #-879	; 0xfffffc91
     600:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     604:	74735f5f 	ldrbtvc	r5, [r3], #-3935	; 0xfffff0a1
     608:	63697461 	cmnvs	r9, #1627389952	; 0x61000000
     60c:	696e695f 	stmdbvs	lr!, {r0, r1, r2, r3, r4, r6, r8, fp, sp, lr}^
     610:	6c616974 			; <UNDEFINED> instruction: 0x6c616974
     614:	74617a69 	strbtvc	r7, [r1], #-2665	; 0xfffff597
     618:	5f6e6f69 	svcpl	0x006e6f69
     61c:	5f646e61 	svcpl	0x00646e61
     620:	74736564 	ldrbtvc	r6, [r3], #-1380	; 0xfffffa9c
     624:	74637572 	strbtvc	r7, [r3], #-1394	; 0xfffffa8e
     628:	5f6e6f69 	svcpl	0x006e6f69
     62c:	50470030 	subpl	r0, r7, r0, lsr r0
     630:	4c455346 	mcrrmi	3, 4, r5, r5, cr6
     634:	50470030 	subpl	r0, r7, r0, lsr r0
     638:	4c455346 	mcrrmi	3, 4, r5, r5, cr6
     63c:	50470031 	subpl	r0, r7, r1, lsr r0
     640:	4c455346 	mcrrmi	3, 4, r5, r5, cr6
     644:	50470032 	subpl	r0, r7, r2, lsr r0
     648:	4c455346 	mcrrmi	3, 4, r5, r5, cr6
     64c:	50470033 	subpl	r0, r7, r3, lsr r0
     650:	425f4f49 	subsmi	r4, pc, #292	; 0x124
     654:	00657361 	rsbeq	r7, r5, r1, ror #6
     658:	53465047 	movtpl	r5, #24647	; 0x6047
     65c:	00354c45 	eorseq	r4, r5, r5, asr #24
     660:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 5ac <_start-0x7a54>
     664:	69732f65 	ldmdbvs	r3!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
     668:	7661686c 	strbtvc	r6, [r1], -ip, ror #16
     66c:	532f6a79 			; <UNDEFINED> instruction: 0x532f6a79
     670:	6f6f6863 	svcvs	0x006f6863
     674:	655a2f6c 	ldrbvs	r2, [sl, #-3948]	; 0xfffff094
     678:	614d6f72 	hvcvs	55026	; 0xd6f2
     67c:	652f6574 	strvs	r6, [pc, #-1396]!	; 110 <_start-0x7ef0>
     680:	706d6178 	rsbvc	r6, sp, r8, ror r1
     684:	2f73656c 	svccs	0x0073656c
     688:	5f44454c 	svcpl	0x0044454c
     68c:	67676f74 			; <UNDEFINED> instruction: 0x67676f74
     690:	652f656c 	strvs	r6, [pc, #-1388]!	; 12c <_start-0x7ed4>
     694:	63726578 	cmnvs	r2, #120, 10	; 0x1e000000
     698:	5f657369 	svcpl	0x00657369
     69c:	302f3230 	eorcc	r3, pc, r0, lsr r2	; <UNPREDICTABLE>
     6a0:	656b5f32 	strbvs	r5, [fp, #-3890]!	; 0xfffff0ce
     6a4:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
     6a8:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
     6ac:	2f6c656e 	svccs	0x006c656e
     6b0:	2f637273 	svccs	0x00637273
     6b4:	6e69616d 	powvsez	f6, f1, #5.0
     6b8:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
     6bc:	54434100 	strbpl	r4, [r3], #-256	; 0xffffff00
     6c0:	6e69505f 	mcrvs	0, 3, r5, cr9, cr15, {2}
     6c4:	656b5f00 	strbvs	r5, [fp, #-3840]!	; 0xfffff100
     6c8:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
     6cc:	69616d5f 	stmdbvs	r1!, {r0, r1, r2, r3, r4, r6, r8, sl, fp, sp, lr}^
     6d0:	682f006e 	stmdavs	pc!, {r1, r2, r3, r5, r6}	; <UNPREDICTABLE>
     6d4:	2f656d6f 	svccs	0x00656d6f
     6d8:	686c6973 	stmdavs	ip!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
     6dc:	6a797661 	bvs	1e5e068 <_bss_end+0x1e55828>
     6e0:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
     6e4:	2f6c6f6f 	svccs	0x006c6f6f
     6e8:	6f72655a 	svcvs	0x0072655a
     6ec:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
     6f0:	6178652f 	cmnvs	r8, pc, lsr #10
     6f4:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
     6f8:	454c2f73 	strbmi	r2, [ip, #-3955]	; 0xfffff08d
     6fc:	6f745f44 	svcvs	0x00745f44
     700:	656c6767 	strbvs	r6, [ip, #-1895]!	; 0xfffff899
     704:	6578652f 	ldrbvs	r6, [r8, #-1327]!	; 0xfffffad1
     708:	73696372 	cmnvc	r9, #-939524095	; 0xc8000001
     70c:	32305f65 	eorscc	r5, r0, #404	; 0x194
     710:	5f32302f 	svcpl	0x0032302f
     714:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
     718:	6b2f6c65 	blvs	bdb8b4 <_bss_end+0xbd3074>
     71c:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
     720:	72732f6c 	rsbsvc	r2, r3, #108, 30	; 0x1b0
     724:	74732f63 	ldrbtvc	r2, [r3], #-3939	; 0xfffff09d
     728:	2e747261 	cdpcs	2, 7, cr7, cr4, cr1, {3}
     72c:	4e470073 	mcrmi	0, 2, r0, cr7, cr3, {3}
     730:	53412055 	movtpl	r2, #4181	; 0x1055
     734:	332e3220 			; <UNDEFINED> instruction: 0x332e3220
     738:	625f0034 	subsvs	r0, pc, #52	; 0x34
     73c:	735f7373 	cmpvc	pc, #-872415231	; 0xcc000001
     740:	74726174 	ldrbtvc	r6, [r2], #-372	; 0xfffffe8c
     744:	6f682f00 	svcvs	0x00682f00
     748:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
     74c:	61686c69 	cmnvs	r8, r9, ror #24
     750:	2f6a7976 	svccs	0x006a7976
     754:	6f686353 	svcvs	0x00686353
     758:	5a2f6c6f 	bpl	bdb91c <_bss_end+0xbd30dc>
     75c:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 5d0 <_start-0x7a30>
     760:	2f657461 	svccs	0x00657461
     764:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
     768:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
     76c:	44454c2f 	strbmi	r4, [r5], #-3119	; 0xfffff3d1
     770:	676f745f 			; <UNDEFINED> instruction: 0x676f745f
     774:	2f656c67 	svccs	0x00656c67
     778:	72657865 	rsbvc	r7, r5, #6619136	; 0x650000
     77c:	65736963 	ldrbvs	r6, [r3, #-2403]!	; 0xfffff69d
     780:	2f32305f 	svccs	0x0032305f
     784:	6b5f3230 	blvs	17cd04c <_bss_end+0x17c480c>
     788:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
     78c:	656b2f6c 	strbvs	r2, [fp, #-3948]!	; 0xfffff094
     790:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
     794:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
     798:	6174732f 	cmnvs	r4, pc, lsr #6
     79c:	70757472 	rsbsvc	r7, r5, r2, ror r4
     7a0:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
     7a4:	435f5f00 	cmpmi	pc, #0, 30
     7a8:	5f524f54 	svcpl	0x00524f54
     7ac:	5f444e45 	svcpl	0x00444e45
     7b0:	5f5f005f 	svcpl	0x005f005f
     7b4:	524f5443 	subpl	r5, pc, #1124073472	; 0x43000000
     7b8:	53494c5f 	movtpl	r4, #40031	; 0x9c5f
     7bc:	005f5f54 	subseq	r5, pc, r4, asr pc	; <UNPREDICTABLE>
     7c0:	54445f5f 	strbpl	r5, [r4], #-3935	; 0xfffff0a1
     7c4:	455f524f 	ldrbmi	r5, [pc, #-591]	; 57d <_start-0x7a83>
     7c8:	5f5f444e 	svcpl	0x005f444e
     7cc:	70635f00 	rsbvc	r5, r3, r0, lsl #30
     7d0:	68735f70 	ldmdavs	r3!, {r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     7d4:	6f647475 	svcvs	0x00647475
     7d8:	5f006e77 	svcpl	0x00006e77
     7dc:	5f737362 	svcpl	0x00737362
     7e0:	00646e65 	rsbeq	r6, r4, r5, ror #28
     7e4:	54445f5f 	strbpl	r5, [r4], #-3935	; 0xfffff0a1
     7e8:	4c5f524f 	lfmmi	f5, 2, [pc], {79}	; 0x4f
     7ec:	5f545349 	svcpl	0x00545349
     7f0:	7464005f 	strbtvc	r0, [r4], #-95	; 0xffffffa1
     7f4:	705f726f 	subsvc	r7, pc, pc, ror #4
     7f8:	63007274 	movwvs	r7, #628	; 0x274
     7fc:	5f726f74 	svcpl	0x00726f74
     800:	00727470 	rsbseq	r7, r2, r0, ror r4
     804:	735f635f 	cmpvc	pc, #2080374785	; 0x7c000001
     808:	74726174 	ldrbtvc	r6, [r2], #-372	; 0xfffffe8c
     80c:	5f007075 	svcpl	0x00007075
     810:	5f707063 	svcpl	0x00707063
     814:	72617473 	rsbvc	r7, r1, #1929379840	; 0x73000000
     818:	00707574 	rsbseq	r7, r0, r4, ror r5
     81c:	74706e66 	ldrbtvc	r6, [r0], #-3686	; 0xfffff19a
     820:	41540072 	cmpmi	r4, r2, ror r0
     824:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
     828:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
     82c:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
     830:	61786574 	cmnvs	r8, r4, ror r5
     834:	6f633731 	svcvs	0x00633731
     838:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
     83c:	69003761 	stmdbvs	r0, {r0, r5, r6, r8, r9, sl, ip, sp}
     840:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
     844:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
     848:	62645f70 	rsbvs	r5, r4, #112, 30	; 0x1c0
     84c:	7261006c 	rsbvc	r0, r1, #108	; 0x6c
     850:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
     854:	695f6863 	ldmdbvs	pc, {r0, r1, r5, r6, fp, sp, lr}^	; <UNPREDICTABLE>
     858:	786d6d77 	stmdavc	sp!, {r0, r1, r2, r4, r5, r6, r8, sl, fp, sp, lr}^
     85c:	41540074 	cmpmi	r4, r4, ror r0
     860:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
     864:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
     868:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
     86c:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
     870:	41003332 	tstmi	r0, r2, lsr r3
     874:	455f4d52 	ldrbmi	r4, [pc, #-3410]	; fffffb2a <_bss_end+0xffff72ea>
     878:	41540051 	cmpmi	r4, r1, asr r0
     87c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
     880:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
     884:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
     888:	36353131 			; <UNDEFINED> instruction: 0x36353131
     88c:	73663274 	cmnvc	r6, #116, 4	; 0x40000007
     890:	61736900 	cmnvs	r3, r0, lsl #18
     894:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
     898:	7568745f 	strbvc	r7, [r8, #-1119]!	; 0xfffffba1
     89c:	5400626d 	strpl	r6, [r0], #-621	; 0xfffffd93
     8a0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
     8a4:	50435f54 	subpl	r5, r3, r4, asr pc
     8a8:	6f635f55 	svcvs	0x00635f55
     8ac:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
     8b0:	63373561 	teqvs	r7, #406847488	; 0x18400000
     8b4:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
     8b8:	33356178 	teqcc	r5, #120, 2
     8bc:	53414200 	movtpl	r4, #4608	; 0x1200
     8c0:	52415f45 	subpl	r5, r1, #276	; 0x114
     8c4:	385f4843 	ldmdacc	pc, {r0, r1, r6, fp, lr}^	; <UNPREDICTABLE>
     8c8:	41425f4d 	cmpmi	r2, sp, asr #30
     8cc:	54004553 	strpl	r4, [r0], #-1363	; 0xfffffaad
     8d0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
     8d4:	50435f54 	subpl	r5, r3, r4, asr pc
     8d8:	72615f55 	rsbvc	r5, r1, #340	; 0x154
     8dc:	3031386d 	eorscc	r3, r1, sp, ror #16
     8e0:	52415400 	subpl	r5, r1, #0, 8
     8e4:	5f544547 	svcpl	0x00544547
     8e8:	5f555043 	svcpl	0x00555043
     8ec:	6e656778 	mcrvs	7, 3, r6, cr5, cr8, {3}
     8f0:	41003165 	tstmi	r0, r5, ror #2
     8f4:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
     8f8:	415f5343 	cmpmi	pc, r3, asr #6
     8fc:	53435041 	movtpl	r5, #12353	; 0x3041
     900:	4d57495f 	vldrmi.16	s9, [r7, #-190]	; 0xffffff42	; <UNPREDICTABLE>
     904:	0054584d 	subseq	r5, r4, sp, asr #16
     908:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
     90c:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
     910:	00305f48 	eorseq	r5, r0, r8, asr #30
     914:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
     918:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
     91c:	00325f48 	eorseq	r5, r2, r8, asr #30
     920:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
     924:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
     928:	00335f48 	eorseq	r5, r3, r8, asr #30
     92c:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
     930:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
     934:	00345f48 	eorseq	r5, r4, r8, asr #30
     938:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
     93c:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
     940:	00365f48 	eorseq	r5, r6, r8, asr #30
     944:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
     948:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
     94c:	00375f48 	eorseq	r5, r7, r8, asr #30
     950:	47524154 			; <UNDEFINED> instruction: 0x47524154
     954:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
     958:	785f5550 	ldmdavc	pc, {r4, r6, r8, sl, ip, lr}^	; <UNPREDICTABLE>
     95c:	6c616373 	stclvs	3, cr6, [r1], #-460	; 0xfffffe34
     960:	73690065 	cmnvc	r9, #101	; 0x65
     964:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
     968:	72705f74 	rsbsvc	r5, r0, #116, 30	; 0x1d0
     96c:	65726465 	ldrbvs	r6, [r2, #-1125]!	; 0xfffffb9b
     970:	41540073 	cmpmi	r4, r3, ror r0
     974:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
     978:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
     97c:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
     980:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
     984:	54003333 	strpl	r3, [r0], #-819	; 0xfffffccd
     988:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
     98c:	50435f54 	subpl	r5, r3, r4, asr pc
     990:	72615f55 	rsbvc	r5, r1, #340	; 0x154
     994:	6474376d 	ldrbtvs	r3, [r4], #-1901	; 0xfffff893
     998:	6900696d 	stmdbvs	r0, {r0, r2, r3, r5, r6, r8, fp, sp, lr}
     99c:	6e5f6173 	mrcvs	1, 2, r6, cr15, cr3, {3}
     9a0:	7469626f 	strbtvc	r6, [r9], #-623	; 0xfffffd91
     9a4:	52415400 	subpl	r5, r1, #0, 8
     9a8:	5f544547 	svcpl	0x00544547
     9ac:	5f555043 	svcpl	0x00555043
     9b0:	316d7261 	cmncc	sp, r1, ror #4
     9b4:	6a363731 	bvs	d8e680 <_bss_end+0xd85e40>
     9b8:	0073667a 	rsbseq	r6, r3, sl, ror r6
     9bc:	5f617369 	svcpl	0x00617369
     9c0:	5f746962 	svcpl	0x00746962
     9c4:	76706676 			; <UNDEFINED> instruction: 0x76706676
     9c8:	52410032 	subpl	r0, r1, #50	; 0x32
     9cc:	43505f4d 	cmpmi	r0, #308	; 0x134
     9d0:	4e555f53 	mrcmi	15, 2, r5, cr5, cr3, {2}
     9d4:	574f4e4b 	strbpl	r4, [pc, -fp, asr #28]
     9d8:	4154004e 	cmpmi	r4, lr, asr #32
     9dc:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
     9e0:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
     9e4:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
     9e8:	42006539 	andmi	r6, r0, #239075328	; 0xe400000
     9ec:	5f455341 	svcpl	0x00455341
     9f0:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
     9f4:	4554355f 	ldrbmi	r3, [r4, #-1375]	; 0xfffffaa1
     9f8:	7261004a 	rsbvc	r0, r1, #74	; 0x4a
     9fc:	63635f6d 	cmnvs	r3, #436	; 0x1b4
     a00:	5f6d7366 	svcpl	0x006d7366
     a04:	74617473 	strbtvc	r7, [r1], #-1139	; 0xfffffb8d
     a08:	72610065 	rsbvc	r0, r1, #101	; 0x65
     a0c:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
     a10:	74356863 	ldrtvc	r6, [r5], #-2147	; 0xfffff79d
     a14:	6e750065 	cdpvs	0, 7, cr0, cr5, cr5, {3}
     a18:	63657073 	cmnvs	r5, #115	; 0x73
     a1c:	7274735f 	rsbsvc	r7, r4, #2080374785	; 0x7c000001
     a20:	73676e69 	cmnvc	r7, #1680	; 0x690
     a24:	61736900 	cmnvs	r3, r0, lsl #18
     a28:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
     a2c:	6365735f 	cmnvs	r5, #2080374785	; 0x7c000001
     a30:	635f5f00 	cmpvs	pc, #0, 30
     a34:	745f7a6c 	ldrbvc	r7, [pc], #-2668	; a3c <_start-0x75c4>
     a38:	41006261 	tstmi	r0, r1, ror #4
     a3c:	565f4d52 			; <UNDEFINED> instruction: 0x565f4d52
     a40:	72610043 	rsbvc	r0, r1, #67	; 0x43
     a44:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
     a48:	785f6863 	ldmdavc	pc, {r0, r1, r5, r6, fp, sp, lr}^	; <UNPREDICTABLE>
     a4c:	6c616373 	stclvs	3, cr6, [r1], #-460	; 0xfffffe34
     a50:	52410065 	subpl	r0, r1, #101	; 0x65
     a54:	454c5f4d 	strbmi	r5, [ip, #-3917]	; 0xfffff0b3
     a58:	4d524100 	ldfmie	f4, [r2, #-0]
     a5c:	0053565f 	subseq	r5, r3, pc, asr r6
     a60:	5f4d5241 	svcpl	0x004d5241
     a64:	61004547 	tstvs	r0, r7, asr #10
     a68:	745f6d72 	ldrbvc	r6, [pc], #-3442	; a70 <_start-0x7590>
     a6c:	5f656e75 	svcpl	0x00656e75
     a70:	6f727473 	svcvs	0x00727473
     a74:	7261676e 	rsbvc	r6, r1, #28835840	; 0x1b80000
     a78:	6f63006d 	svcvs	0x0063006d
     a7c:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
     a80:	6c662078 	stclvs	0, cr2, [r6], #-480	; 0xfffffe20
     a84:	0074616f 	rsbseq	r6, r4, pc, ror #2
     a88:	47524154 			; <UNDEFINED> instruction: 0x47524154
     a8c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
     a90:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
     a94:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
     a98:	35316178 	ldrcc	r6, [r1, #-376]!	; 0xfffffe88
     a9c:	52415400 	subpl	r5, r1, #0, 8
     aa0:	5f544547 	svcpl	0x00544547
     aa4:	5f555043 	svcpl	0x00555043
     aa8:	32376166 	eorscc	r6, r7, #-2147483623	; 0x80000019
     aac:	00657436 	rsbeq	r7, r5, r6, lsr r4
     ab0:	47524154 			; <UNDEFINED> instruction: 0x47524154
     ab4:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
     ab8:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
     abc:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
     ac0:	37316178 			; <UNDEFINED> instruction: 0x37316178
     ac4:	4d524100 	ldfmie	f4, [r2, #-0]
     ac8:	0054475f 	subseq	r4, r4, pc, asr r7
     acc:	47524154 			; <UNDEFINED> instruction: 0x47524154
     ad0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
     ad4:	6e5f5550 	mrcvs	5, 2, r5, cr15, cr0, {2}
     ad8:	65766f65 	ldrbvs	r6, [r6, #-3941]!	; 0xfffff09b
     adc:	6e657372 	mcrvs	3, 3, r7, cr5, cr2, {3}
     ae0:	2e2e0031 	mcrcs	0, 1, r0, cr14, cr1, {1}
     ae4:	2f2e2e2f 	svccs	0x002e2e2f
     ae8:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     aec:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     af0:	2f2e2e2f 	svccs	0x002e2e2f
     af4:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
     af8:	6c2f6363 	stcvs	3, cr6, [pc], #-396	; 974 <_start-0x768c>
     afc:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
     b00:	632e3263 			; <UNDEFINED> instruction: 0x632e3263
     b04:	52415400 	subpl	r5, r1, #0, 8
     b08:	5f544547 	svcpl	0x00544547
     b0c:	5f555043 	svcpl	0x00555043
     b10:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
     b14:	34727865 	ldrbtcc	r7, [r2], #-2149	; 0xfffff79b
     b18:	41420066 	cmpmi	r2, r6, rrx
     b1c:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
     b20:	5f484352 	svcpl	0x00484352
     b24:	004d4537 	subeq	r4, sp, r7, lsr r5
     b28:	47524154 			; <UNDEFINED> instruction: 0x47524154
     b2c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
     b30:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
     b34:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
     b38:	32316178 	eorscc	r6, r1, #120, 2
     b3c:	73616800 	cmnvc	r1, #0, 16
     b40:	6c617668 	stclvs	6, cr7, [r1], #-416	; 0xfffffe60
     b44:	4200745f 	andmi	r7, r0, #1593835520	; 0x5f000000
     b48:	5f455341 	svcpl	0x00455341
     b4c:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
     b50:	5a4b365f 	bpl	12ce4d4 <_bss_end+0x12c5c94>
     b54:	61736900 	cmnvs	r3, r0, lsl #18
     b58:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
     b5c:	72610073 	rsbvc	r0, r1, #115	; 0x73
     b60:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
     b64:	615f6863 	cmpvs	pc, r3, ror #16
     b68:	685f6d72 	ldmdavs	pc, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^	; <UNPREDICTABLE>
     b6c:	76696477 			; <UNDEFINED> instruction: 0x76696477
     b70:	6d726100 	ldfvse	f6, [r2, #-0]
     b74:	7570665f 	ldrbvc	r6, [r0, #-1631]!	; 0xfffff9a1
     b78:	7365645f 	cmnvc	r5, #1593835520	; 0x5f000000
     b7c:	73690063 	cmnvc	r9, #99	; 0x63
     b80:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
     b84:	70665f74 	rsbvc	r5, r6, r4, ror pc
     b88:	47003631 	smladxmi	r0, r1, r6, r3
     b8c:	4320554e 			; <UNDEFINED> instruction: 0x4320554e
     b90:	39203731 	stmdbcc	r0!, {r0, r4, r5, r8, r9, sl, ip, sp}
     b94:	312e322e 			; <UNDEFINED> instruction: 0x312e322e
     b98:	31303220 	teqcc	r0, r0, lsr #4
     b9c:	32303139 	eorscc	r3, r0, #1073741838	; 0x4000000e
     ba0:	72282035 	eorvc	r2, r8, #53	; 0x35
     ba4:	61656c65 	cmnvs	r5, r5, ror #24
     ba8:	20296573 	eorcs	r6, r9, r3, ror r5
     bac:	4d52415b 	ldfmie	f4, [r2, #-364]	; 0xfffffe94
     bb0:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
     bb4:	622d392d 	eorvs	r3, sp, #737280	; 0xb4000
     bb8:	636e6172 	cmnvs	lr, #-2147483620	; 0x8000001c
     bbc:	65722068 	ldrbvs	r2, [r2, #-104]!	; 0xffffff98
     bc0:	69736976 	ldmdbvs	r3!, {r1, r2, r4, r5, r6, r8, fp, sp, lr}^
     bc4:	32206e6f 	eorcc	r6, r0, #1776	; 0x6f0
     bc8:	39353737 	ldmdbcc	r5!, {r0, r1, r2, r4, r5, r8, r9, sl, ip, sp}
     bcc:	2d205d39 	stccs	13, cr5, [r0, #-228]!	; 0xffffff1c
     bd0:	6d72616d 	ldfvse	f6, [r2, #-436]!	; 0xfffffe4c
     bd4:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
     bd8:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
     bdc:	6962612d 	stmdbvs	r2!, {r0, r2, r3, r5, r8, sp, lr}^
     be0:	7261683d 	rsbvc	r6, r1, #3997696	; 0x3d0000
     be4:	6d2d2064 	stcvs	0, cr2, [sp, #-400]!	; 0xfffffe70
     be8:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
     bec:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
     bf0:	65743576 	ldrbvs	r3, [r4, #-1398]!	; 0xfffffa8a
     bf4:	2070662b 	rsbscs	r6, r0, fp, lsr #12
     bf8:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
     bfc:	672d2067 	strvs	r2, [sp, -r7, rrx]!
     c00:	324f2d20 	subcc	r2, pc, #32, 26	; 0x800
     c04:	324f2d20 	subcc	r2, pc, #32, 26	; 0x800
     c08:	324f2d20 	subcc	r2, pc, #32, 26	; 0x800
     c0c:	62662d20 	rsbvs	r2, r6, #32, 26	; 0x800
     c10:	646c6975 	strbtvs	r6, [ip], #-2421	; 0xfffff68b
     c14:	2d676e69 	stclcs	14, cr6, [r7, #-420]!	; 0xfffffe5c
     c18:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
     c1c:	2d206363 	stccs	3, cr6, [r0, #-396]!	; 0xfffffe74
     c20:	2d6f6e66 	stclcs	14, cr6, [pc, #-408]!	; a90 <_start-0x7570>
     c24:	63617473 	cmnvs	r1, #1929379840	; 0x73000000
     c28:	72702d6b 	rsbsvc	r2, r0, #6848	; 0x1ac0
     c2c:	6365746f 	cmnvs	r5, #1862270976	; 0x6f000000
     c30:	20726f74 	rsbscs	r6, r2, r4, ror pc
     c34:	6f6e662d 	svcvs	0x006e662d
     c38:	6c6e692d 			; <UNDEFINED> instruction: 0x6c6e692d
     c3c:	20656e69 	rsbcs	r6, r5, r9, ror #28
     c40:	6976662d 	ldmdbvs	r6!, {r0, r2, r3, r5, r9, sl, sp, lr}^
     c44:	69626973 	stmdbvs	r2!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
     c48:	7974696c 	ldmdbvc	r4!, {r2, r3, r5, r6, r8, fp, sp, lr}^
     c4c:	6469683d 	strbtvs	r6, [r9], #-2109	; 0xfffff7c3
     c50:	006e6564 	rsbeq	r6, lr, r4, ror #10
     c54:	5f4d5241 	svcpl	0x004d5241
     c58:	69004948 	stmdbvs	r0, {r3, r6, r8, fp, lr}
     c5c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
     c60:	615f7469 	cmpvs	pc, r9, ror #8
     c64:	00766964 	rsbseq	r6, r6, r4, ror #18
     c68:	47524154 			; <UNDEFINED> instruction: 0x47524154
     c6c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
     c70:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
     c74:	31316d72 	teqcc	r1, r2, ror sp
     c78:	736a3633 	cmnvc	sl, #53477376	; 0x3300000
     c7c:	52415400 	subpl	r5, r1, #0, 8
     c80:	5f544547 	svcpl	0x00544547
     c84:	5f555043 	svcpl	0x00555043
     c88:	386d7261 	stmdacc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
     c8c:	52415400 	subpl	r5, r1, #0, 8
     c90:	5f544547 	svcpl	0x00544547
     c94:	5f555043 	svcpl	0x00555043
     c98:	396d7261 	stmdbcc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
     c9c:	52415400 	subpl	r5, r1, #0, 8
     ca0:	5f544547 	svcpl	0x00544547
     ca4:	5f555043 	svcpl	0x00555043
     ca8:	32366166 	eorscc	r6, r6, #-2147483623	; 0x80000019
     cac:	6f6c0036 	svcvs	0x006c0036
     cb0:	6c20676e 	stcvs	7, cr6, [r0], #-440	; 0xfffffe48
     cb4:	20676e6f 	rsbcs	r6, r7, pc, ror #28
     cb8:	69736e75 	ldmdbvs	r3!, {r0, r2, r4, r5, r6, r9, sl, fp, sp, lr}^
     cbc:	64656e67 	strbtvs	r6, [r5], #-3687	; 0xfffff199
     cc0:	746e6920 	strbtvc	r6, [lr], #-2336	; 0xfffff6e0
     cc4:	6d726100 	ldfvse	f6, [r2, #-0]
     cc8:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
     ccc:	6d635f68 	stclvs	15, cr5, [r3, #-416]!	; 0xfffffe60
     cd0:	54006573 	strpl	r6, [r0], #-1395	; 0xfffffa8d
     cd4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
     cd8:	50435f54 	subpl	r5, r3, r4, asr pc
     cdc:	6f635f55 	svcvs	0x00635f55
     ce0:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
     ce4:	5400346d 	strpl	r3, [r0], #-1133	; 0xfffffb93
     ce8:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
     cec:	50435f54 	subpl	r5, r3, r4, asr pc
     cf0:	72615f55 	rsbvc	r5, r1, #340	; 0x154
     cf4:	6530316d 	ldrvs	r3, [r0, #-365]!	; 0xfffffe93
     cf8:	52415400 	subpl	r5, r1, #0, 8
     cfc:	5f544547 	svcpl	0x00544547
     d00:	5f555043 	svcpl	0x00555043
     d04:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
     d08:	376d7865 	strbcc	r7, [sp, -r5, ror #16]!
     d0c:	6d726100 	ldfvse	f6, [r2, #-0]
     d10:	6e6f635f 	mcrvs	3, 3, r6, cr15, cr15, {2}
     d14:	6f635f64 	svcvs	0x00635f64
     d18:	41006564 	tstmi	r0, r4, ror #10
     d1c:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
     d20:	415f5343 	cmpmi	pc, r3, asr #6
     d24:	53435041 	movtpl	r5, #12353	; 0x3041
     d28:	61736900 	cmnvs	r3, r0, lsl #18
     d2c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
     d30:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
     d34:	325f3876 	subscc	r3, pc, #7733248	; 0x760000
     d38:	53414200 	movtpl	r4, #4608	; 0x1200
     d3c:	52415f45 	subpl	r5, r1, #276	; 0x114
     d40:	335f4843 	cmpcc	pc, #4390912	; 0x430000
     d44:	4154004d 	cmpmi	r4, sp, asr #32
     d48:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
     d4c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
     d50:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
     d54:	74303137 	ldrtvc	r3, [r0], #-311	; 0xfffffec9
     d58:	6d726100 	ldfvse	f6, [r2, #-0]
     d5c:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
     d60:	77695f68 	strbvc	r5, [r9, -r8, ror #30]!
     d64:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
     d68:	73690032 	cmnvc	r9, #50	; 0x32
     d6c:	756e5f61 	strbvc	r5, [lr, #-3937]!	; 0xfffff09f
     d70:	69625f6d 	stmdbvs	r2!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
     d74:	54007374 	strpl	r7, [r0], #-884	; 0xfffffc8c
     d78:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
     d7c:	50435f54 	subpl	r5, r3, r4, asr pc
     d80:	6f635f55 	svcvs	0x00635f55
     d84:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
     d88:	6c70306d 	ldclvs	0, cr3, [r0], #-436	; 0xfffffe4c
     d8c:	6d737375 	ldclvs	3, cr7, [r3, #-468]!	; 0xfffffe2c
     d90:	6d6c6c61 	stclvs	12, cr6, [ip, #-388]!	; 0xfffffe7c
     d94:	69746c75 	ldmdbvs	r4!, {r0, r2, r4, r5, r6, sl, fp, sp, lr}^
     d98:	00796c70 	rsbseq	r6, r9, r0, ror ip
     d9c:	47524154 			; <UNDEFINED> instruction: 0x47524154
     da0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
     da4:	655f5550 	ldrbvs	r5, [pc, #-1360]	; 85c <_start-0x77a4>
     da8:	6f6e7978 	svcvs	0x006e7978
     dac:	00316d73 	eorseq	r6, r1, r3, ror sp
     db0:	47524154 			; <UNDEFINED> instruction: 0x47524154
     db4:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
     db8:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
     dbc:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
     dc0:	32357278 	eorscc	r7, r5, #120, 4	; 0x80000007
     dc4:	61736900 	cmnvs	r3, r0, lsl #18
     dc8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
     dcc:	6964745f 	stmdbvs	r4!, {r0, r1, r2, r3, r4, r6, sl, ip, sp, lr}^
     dd0:	72700076 	rsbsvc	r0, r0, #118	; 0x76
     dd4:	72656665 	rsbvc	r6, r5, #105906176	; 0x6500000
     dd8:	6f656e5f 	svcvs	0x00656e5f
     ddc:	6f665f6e 	svcvs	0x00665f6e
     de0:	34365f72 	ldrtcc	r5, [r6], #-3954	; 0xfffff08e
     de4:	73746962 	cmnvc	r4, #1605632	; 0x188000
     de8:	61736900 	cmnvs	r3, r0, lsl #18
     dec:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
     df0:	3170665f 	cmncc	r0, pc, asr r6
     df4:	6c6d6636 	stclvs	6, cr6, [sp], #-216	; 0xffffff28
     df8:	52415400 	subpl	r5, r1, #0, 8
     dfc:	5f544547 	svcpl	0x00544547
     e00:	5f555043 	svcpl	0x00555043
     e04:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
     e08:	33617865 	cmncc	r1, #6619136	; 0x650000
     e0c:	41540032 	cmpmi	r4, r2, lsr r0
     e10:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
     e14:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
     e18:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
     e1c:	61786574 	cmnvs	r8, r4, ror r5
     e20:	69003533 	stmdbvs	r0, {r0, r1, r4, r5, r8, sl, ip, sp}
     e24:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
     e28:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
     e2c:	63363170 	teqvs	r6, #112, 2
     e30:	00766e6f 	rsbseq	r6, r6, pc, ror #28
     e34:	70736e75 	rsbsvc	r6, r3, r5, ror lr
     e38:	5f766365 	svcpl	0x00766365
     e3c:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
     e40:	0073676e 	rsbseq	r6, r3, lr, ror #14
     e44:	47524154 			; <UNDEFINED> instruction: 0x47524154
     e48:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
     e4c:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
     e50:	31316d72 	teqcc	r1, r2, ror sp
     e54:	32743635 	rsbscc	r3, r4, #55574528	; 0x3500000
     e58:	41540073 	cmpmi	r4, r3, ror r0
     e5c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
     e60:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
     e64:	3661665f 			; <UNDEFINED> instruction: 0x3661665f
     e68:	65743630 	ldrbvs	r3, [r4, #-1584]!	; 0xfffff9d0
     e6c:	52415400 	subpl	r5, r1, #0, 8
     e70:	5f544547 	svcpl	0x00544547
     e74:	5f555043 	svcpl	0x00555043
     e78:	396d7261 	stmdbcc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
     e7c:	6a653632 	bvs	194e74c <_bss_end+0x1945f0c>
     e80:	41420073 	hvcmi	8195	; 0x2003
     e84:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
     e88:	5f484352 	svcpl	0x00484352
     e8c:	69005434 	stmdbvs	r0, {r2, r4, r5, sl, ip, lr}
     e90:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
     e94:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
     e98:	74707972 	ldrbtvc	r7, [r0], #-2418	; 0xfffff68e
     e9c:	7261006f 	rsbvc	r0, r1, #111	; 0x6f
     ea0:	65725f6d 	ldrbvs	r5, [r2, #-3949]!	; 0xfffff093
     ea4:	695f7367 	ldmdbvs	pc, {r0, r1, r2, r5, r6, r8, r9, ip, sp, lr}^	; <UNPREDICTABLE>
     ea8:	65735f6e 	ldrbvs	r5, [r3, #-3950]!	; 0xfffff092
     eac:	6e657571 	mcrvs	5, 3, r7, cr5, cr1, {3}
     eb0:	69006563 	stmdbvs	r0, {r0, r1, r5, r6, r8, sl, sp, lr}
     eb4:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
     eb8:	735f7469 	cmpvc	pc, #1761607680	; 0x69000000
     ebc:	41420062 	cmpmi	r2, r2, rrx
     ec0:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
     ec4:	5f484352 	svcpl	0x00484352
     ec8:	00455435 	subeq	r5, r5, r5, lsr r4
     ecc:	5f617369 	svcpl	0x00617369
     ed0:	74616566 	strbtvc	r6, [r1], #-1382	; 0xfffffa9a
     ed4:	00657275 	rsbeq	r7, r5, r5, ror r2
     ed8:	5f617369 	svcpl	0x00617369
     edc:	5f746962 	svcpl	0x00746962
     ee0:	6c616d73 	stclvs	13, cr6, [r1], #-460	; 0xfffffe34
     ee4:	6c756d6c 	ldclvs	13, cr6, [r5], #-432	; 0xfffffe50
     ee8:	6d726100 	ldfvse	f6, [r2, #-0]
     eec:	6e616c5f 	mcrvs	12, 3, r6, cr1, cr15, {2}
     ef0:	756f5f67 	strbvc	r5, [pc, #-3943]!	; ffffff91 <_bss_end+0xffff7751>
     ef4:	74757074 	ldrbtvc	r7, [r5], #-116	; 0xffffff8c
     ef8:	6a626f5f 	bvs	189cc7c <_bss_end+0x189443c>
     efc:	5f746365 	svcpl	0x00746365
     f00:	72747461 	rsbsvc	r7, r4, #1627389952	; 0x61000000
     f04:	74756269 	ldrbtvc	r6, [r5], #-617	; 0xfffffd97
     f08:	685f7365 	ldmdavs	pc, {r0, r2, r5, r6, r8, r9, ip, sp, lr}^	; <UNPREDICTABLE>
     f0c:	006b6f6f 	rsbeq	r6, fp, pc, ror #30
     f10:	5f617369 	svcpl	0x00617369
     f14:	5f746962 	svcpl	0x00746962
     f18:	645f7066 	ldrbvs	r7, [pc], #-102	; f20 <_start-0x70e0>
     f1c:	41003233 	tstmi	r0, r3, lsr r2
     f20:	4e5f4d52 	mrcmi	13, 2, r4, cr15, cr2, {2}
     f24:	73690045 	cmnvc	r9, #69	; 0x45
     f28:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
     f2c:	65625f74 	strbvs	r5, [r2, #-3956]!	; 0xfffff08c
     f30:	41540038 	cmpmi	r4, r8, lsr r0
     f34:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
     f38:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
     f3c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
     f40:	36373131 			; <UNDEFINED> instruction: 0x36373131
     f44:	00737a6a 	rsbseq	r7, r3, sl, ror #20
     f48:	636f7270 	cmnvs	pc, #112, 4
     f4c:	6f737365 	svcvs	0x00737365
     f50:	79745f72 	ldmdbvc	r4!, {r1, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     f54:	61006570 	tstvs	r0, r0, ror r5
     f58:	665f6c6c 	ldrbvs	r6, [pc], -ip, ror #24
     f5c:	00737570 	rsbseq	r7, r3, r0, ror r5
     f60:	5f6d7261 	svcpl	0x006d7261
     f64:	00736370 	rsbseq	r6, r3, r0, ror r3
     f68:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
     f6c:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
     f70:	54355f48 	ldrtpl	r5, [r5], #-3912	; 0xfffff0b8
     f74:	6d726100 	ldfvse	f6, [r2, #-0]
     f78:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
     f7c:	00743468 	rsbseq	r3, r4, r8, ror #8
     f80:	47524154 			; <UNDEFINED> instruction: 0x47524154
     f84:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
     f88:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
     f8c:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
     f90:	36376178 			; <UNDEFINED> instruction: 0x36376178
     f94:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
     f98:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
     f9c:	72610035 	rsbvc	r0, r1, #53	; 0x35
     fa0:	75745f6d 	ldrbvc	r5, [r4, #-3949]!	; 0xfffff093
     fa4:	775f656e 	ldrbvc	r6, [pc, -lr, ror #10]
     fa8:	00667562 	rsbeq	r7, r6, r2, ror #10
     fac:	62617468 	rsbvs	r7, r1, #104, 8	; 0x68000000
     fb0:	7361685f 	cmnvc	r1, #6225920	; 0x5f0000
     fb4:	73690068 	cmnvc	r9, #104	; 0x68
     fb8:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
     fbc:	75715f74 	ldrbvc	r5, [r1, #-3956]!	; 0xfffff08c
     fc0:	5f6b7269 	svcpl	0x006b7269
     fc4:	765f6f6e 	ldrbvc	r6, [pc], -lr, ror #30
     fc8:	74616c6f 	strbtvc	r6, [r1], #-3183	; 0xfffff391
     fcc:	5f656c69 	svcpl	0x00656c69
     fd0:	54006563 	strpl	r6, [r0], #-1379	; 0xfffffa9d
     fd4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
     fd8:	50435f54 	subpl	r5, r3, r4, asr pc
     fdc:	6f635f55 	svcvs	0x00635f55
     fe0:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
     fe4:	5400306d 	strpl	r3, [r0], #-109	; 0xffffff93
     fe8:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
     fec:	50435f54 	subpl	r5, r3, r4, asr pc
     ff0:	6f635f55 	svcvs	0x00635f55
     ff4:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
     ff8:	5400316d 	strpl	r3, [r0], #-365	; 0xfffffe93
     ffc:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1000:	50435f54 	subpl	r5, r3, r4, asr pc
    1004:	6f635f55 	svcvs	0x00635f55
    1008:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    100c:	6900336d 	stmdbvs	r0, {r0, r2, r3, r5, r6, r8, r9, ip, sp}
    1010:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1014:	615f7469 	cmpvs	pc, r9, ror #8
    1018:	38766d72 	ldmdacc	r6!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^
    101c:	6100315f 	tstvs	r0, pc, asr r1
    1020:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1024:	5f686372 	svcpl	0x00686372
    1028:	656d616e 	strbvs	r6, [sp, #-366]!	; 0xfffffe92
    102c:	61736900 	cmnvs	r3, r0, lsl #18
    1030:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1034:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1038:	335f3876 	cmpcc	pc, #7733248	; 0x760000
    103c:	61736900 	cmnvs	r3, r0, lsl #18
    1040:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1044:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1048:	345f3876 	ldrbcc	r3, [pc], #-2166	; 1050 <_start-0x6fb0>
    104c:	61736900 	cmnvs	r3, r0, lsl #18
    1050:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1054:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1058:	355f3876 	ldrbcc	r3, [pc, #-2166]	; 7ea <_start-0x7816>
    105c:	52415400 	subpl	r5, r1, #0, 8
    1060:	5f544547 	svcpl	0x00544547
    1064:	5f555043 	svcpl	0x00555043
    1068:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    106c:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    1070:	41540033 	cmpmi	r4, r3, lsr r0
    1074:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1078:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    107c:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1080:	61786574 	cmnvs	r8, r4, ror r5
    1084:	54003535 	strpl	r3, [r0], #-1333	; 0xfffffacb
    1088:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    108c:	50435f54 	subpl	r5, r3, r4, asr pc
    1090:	6f635f55 	svcvs	0x00635f55
    1094:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1098:	00373561 	eorseq	r3, r7, r1, ror #10
    109c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    10a0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    10a4:	6d5f5550 	cfldr64vs	mvdx5, [pc, #-320]	; f6c <_start-0x7094>
    10a8:	726f6370 	rsbvc	r6, pc, #112, 6	; 0xc0000001
    10ac:	41540065 	cmpmi	r4, r5, rrx
    10b0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    10b4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    10b8:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    10bc:	6e6f6e5f 	mcrvs	14, 3, r6, cr15, cr15, {2}
    10c0:	72610065 	rsbvc	r0, r1, #101	; 0x65
    10c4:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    10c8:	6e5f6863 	cdpvs	8, 5, cr6, cr15, cr3, {3}
    10cc:	006d746f 	rsbeq	r7, sp, pc, ror #8
    10d0:	47524154 			; <UNDEFINED> instruction: 0x47524154
    10d4:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    10d8:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    10dc:	30316d72 	eorscc	r6, r1, r2, ror sp
    10e0:	6a653632 	bvs	194e9b0 <_bss_end+0x1946170>
    10e4:	41420073 	hvcmi	8195	; 0x2003
    10e8:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    10ec:	5f484352 	svcpl	0x00484352
    10f0:	42004a36 	andmi	r4, r0, #221184	; 0x36000
    10f4:	5f455341 	svcpl	0x00455341
    10f8:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    10fc:	004b365f 	subeq	r3, fp, pc, asr r6
    1100:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1104:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1108:	4d365f48 	ldcmi	15, cr5, [r6, #-288]!	; 0xfffffee0
    110c:	61736900 	cmnvs	r3, r0, lsl #18
    1110:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1114:	6d77695f 			; <UNDEFINED> instruction: 0x6d77695f
    1118:	0074786d 	rsbseq	r7, r4, sp, ror #16
    111c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1120:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1124:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1128:	31316d72 	teqcc	r1, r2, ror sp
    112c:	666a3633 			; <UNDEFINED> instruction: 0x666a3633
    1130:	52410073 	subpl	r0, r1, #115	; 0x73
    1134:	534c5f4d 	movtpl	r5, #53069	; 0xcf4d
    1138:	4d524100 	ldfmie	f4, [r2, #-0]
    113c:	00544c5f 	subseq	r4, r4, pc, asr ip
    1140:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1144:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1148:	5a365f48 	bpl	d98e70 <_bss_end+0xd90630>
    114c:	52415400 	subpl	r5, r1, #0, 8
    1150:	5f544547 	svcpl	0x00544547
    1154:	5f555043 	svcpl	0x00555043
    1158:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    115c:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    1160:	726f6335 	rsbvc	r6, pc, #-738197504	; 0xd4000000
    1164:	61786574 	cmnvs	r8, r4, ror r5
    1168:	41003535 	tstmi	r0, r5, lsr r5
    116c:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    1170:	415f5343 	cmpmi	pc, r3, asr #6
    1174:	53435041 	movtpl	r5, #12353	; 0x3041
    1178:	5046565f 	subpl	r5, r6, pc, asr r6
    117c:	52415400 	subpl	r5, r1, #0, 8
    1180:	5f544547 	svcpl	0x00544547
    1184:	5f555043 	svcpl	0x00555043
    1188:	6d6d7769 	stclvs	7, cr7, [sp, #-420]!	; 0xfffffe5c
    118c:	00327478 	eorseq	r7, r2, r8, ror r4
    1190:	5f617369 	svcpl	0x00617369
    1194:	5f746962 	svcpl	0x00746962
    1198:	6e6f656e 	cdpvs	5, 6, cr6, cr15, cr14, {3}
    119c:	6d726100 	ldfvse	f6, [r2, #-0]
    11a0:	7570665f 	ldrbvc	r6, [r0, #-1631]!	; 0xfffff9a1
    11a4:	7474615f 	ldrbtvc	r6, [r4], #-351	; 0xfffffea1
    11a8:	73690072 	cmnvc	r9, #114	; 0x72
    11ac:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    11b0:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    11b4:	6537766d 	ldrvs	r7, [r7, #-1645]!	; 0xfffff993
    11b8:	4154006d 	cmpmi	r4, sp, rrx
    11bc:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    11c0:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    11c4:	3661665f 			; <UNDEFINED> instruction: 0x3661665f
    11c8:	65743632 	ldrbvs	r3, [r4, #-1586]!	; 0xfffff9ce
    11cc:	52415400 	subpl	r5, r1, #0, 8
    11d0:	5f544547 	svcpl	0x00544547
    11d4:	5f555043 	svcpl	0x00555043
    11d8:	7672616d 	ldrbtvc	r6, [r2], -sp, ror #2
    11dc:	5f6c6c65 	svcpl	0x006c6c65
    11e0:	00346a70 	eorseq	r6, r4, r0, ror sl
    11e4:	62617468 	rsbvs	r7, r1, #104, 8	; 0x68000000
    11e8:	7361685f 	cmnvc	r1, #6225920	; 0x5f0000
    11ec:	6f705f68 	svcvs	0x00705f68
    11f0:	65746e69 	ldrbvs	r6, [r4, #-3689]!	; 0xfffff197
    11f4:	72610072 	rsbvc	r0, r1, #114	; 0x72
    11f8:	75745f6d 	ldrbvc	r5, [r4, #-3949]!	; 0xfffff093
    11fc:	635f656e 	cmpvs	pc, #461373440	; 0x1b800000
    1200:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1204:	39615f78 	stmdbcc	r1!, {r3, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    1208:	61736900 	cmnvs	r3, r0, lsl #18
    120c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1210:	6d77695f 			; <UNDEFINED> instruction: 0x6d77695f
    1214:	3274786d 	rsbscc	r7, r4, #7143424	; 0x6d0000
    1218:	52415400 	subpl	r5, r1, #0, 8
    121c:	5f544547 	svcpl	0x00544547
    1220:	5f555043 	svcpl	0x00555043
    1224:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1228:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    122c:	726f6332 	rsbvc	r6, pc, #-939524096	; 0xc8000000
    1230:	61786574 	cmnvs	r8, r4, ror r5
    1234:	69003335 	stmdbvs	r0, {r0, r2, r4, r5, r8, r9, ip, sp}
    1238:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    123c:	745f7469 	ldrbvc	r7, [pc], #-1129	; 1244 <_start-0x6dbc>
    1240:	626d7568 	rsbvs	r7, sp, #104, 10	; 0x1a000000
    1244:	41420032 	cmpmi	r2, r2, lsr r0
    1248:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    124c:	5f484352 	svcpl	0x00484352
    1250:	69004137 	stmdbvs	r0, {r0, r1, r2, r4, r5, r8, lr}
    1254:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1258:	645f7469 	ldrbvs	r7, [pc], #-1129	; 1260 <_start-0x6da0>
    125c:	7270746f 	rsbsvc	r7, r0, #1862270976	; 0x6f000000
    1260:	6100646f 	tstvs	r0, pc, ror #8
    1264:	665f6d72 			; <UNDEFINED> instruction: 0x665f6d72
    1268:	5f363170 	svcpl	0x00363170
    126c:	65707974 	ldrbvs	r7, [r0, #-2420]!	; 0xfffff68c
    1270:	646f6e5f 	strbtvs	r6, [pc], #-3679	; 1278 <_start-0x6d88>
    1274:	52410065 	subpl	r0, r1, #101	; 0x65
    1278:	494d5f4d 	stmdbmi	sp, {r0, r2, r3, r6, r8, r9, sl, fp, ip, lr}^
    127c:	6d726100 	ldfvse	f6, [r2, #-0]
    1280:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1284:	006b3668 	rsbeq	r3, fp, r8, ror #12
    1288:	5f6d7261 	svcpl	0x006d7261
    128c:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1290:	42006d36 	andmi	r6, r0, #3456	; 0xd80
    1294:	5f455341 	svcpl	0x00455341
    1298:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    129c:	0052375f 	subseq	r3, r2, pc, asr r7
    12a0:	6f705f5f 	svcvs	0x00705f5f
    12a4:	756f6370 	strbvc	r6, [pc, #-880]!	; f3c <_start-0x70c4>
    12a8:	745f746e 	ldrbvc	r7, [pc], #-1134	; 12b0 <_start-0x6d50>
    12ac:	2f006261 	svccs	0x00006261
    12b0:	6c697562 	cfstr64vs	mvdx7, [r9], #-392	; 0xfffffe78
    12b4:	63672f64 	cmnvs	r7, #100, 30	; 0x190
    12b8:	72612d63 	rsbvc	r2, r1, #6336	; 0x18c0
    12bc:	6f6e2d6d 	svcvs	0x006e2d6d
    12c0:	652d656e 	strvs	r6, [sp, #-1390]!	; 0xfffffa92
    12c4:	2d696261 	sfmcs	f6, 2, [r9, #-388]!	; 0xfffffe7c
    12c8:	6b396c47 	blvs	e5c3ec <_bss_end+0xe53bac>
    12cc:	672f3954 			; <UNDEFINED> instruction: 0x672f3954
    12d0:	612d6363 			; <UNDEFINED> instruction: 0x612d6363
    12d4:	6e2d6d72 	mcrvs	13, 1, r6, cr13, cr2, {3}
    12d8:	2d656e6f 	stclcs	14, cr6, [r5, #-444]!	; 0xfffffe44
    12dc:	69626165 	stmdbvs	r2!, {r0, r2, r5, r6, r8, sp, lr}^
    12e0:	322d392d 	eorcc	r3, sp, #737280	; 0xb4000
    12e4:	2d393130 	ldfcss	f3, [r9, #-192]!	; 0xffffff40
    12e8:	622f3471 	eorvs	r3, pc, #1895825408	; 0x71000000
    12ec:	646c6975 	strbtvs	r6, [ip], #-2421	; 0xfffff68b
    12f0:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
    12f4:	6e6f6e2d 	cdpvs	14, 6, cr6, cr15, cr13, {1}
    12f8:	61652d65 	cmnvs	r5, r5, ror #26
    12fc:	612f6962 			; <UNDEFINED> instruction: 0x612f6962
    1300:	762f6d72 			; <UNDEFINED> instruction: 0x762f6d72
    1304:	2f657435 	svccs	0x00657435
    1308:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
    130c:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    1310:	00636367 	rsbeq	r6, r3, r7, ror #6
    1314:	5f617369 	svcpl	0x00617369
    1318:	5f746962 	svcpl	0x00746962
    131c:	65736d63 	ldrbvs	r6, [r3, #-3427]!	; 0xfffff29d
    1320:	52415400 	subpl	r5, r1, #0, 8
    1324:	5f544547 	svcpl	0x00544547
    1328:	5f555043 	svcpl	0x00555043
    132c:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1330:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    1334:	41540033 	cmpmi	r4, r3, lsr r0
    1338:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    133c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1340:	6e65675f 	mcrvs	7, 3, r6, cr5, cr15, {2}
    1344:	63697265 	cmnvs	r9, #1342177286	; 0x50000006
    1348:	00613776 	rsbeq	r3, r1, r6, ror r7
    134c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1350:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1354:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1358:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    135c:	36376178 			; <UNDEFINED> instruction: 0x36376178
    1360:	6d726100 	ldfvse	f6, [r2, #-0]
    1364:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1368:	6f6e5f68 	svcvs	0x006e5f68
    136c:	6c6f765f 	stclvs	6, cr7, [pc], #-380	; 11f8 <_start-0x6e08>
    1370:	6c697461 	cfstrdvs	mvd7, [r9], #-388	; 0xfffffe7c
    1374:	65635f65 	strbvs	r5, [r3, #-3941]!	; 0xfffff09b
    1378:	53414200 	movtpl	r4, #4608	; 0x1200
    137c:	52415f45 	subpl	r5, r1, #276	; 0x114
    1380:	385f4843 	ldmdacc	pc, {r0, r1, r6, fp, lr}^	; <UNPREDICTABLE>
    1384:	73690041 	cmnvc	r9, #65	; 0x41
    1388:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    138c:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1390:	7435766d 	ldrtvc	r7, [r5], #-1645	; 0xfffff993
    1394:	53414200 	movtpl	r4, #4608	; 0x1200
    1398:	52415f45 	subpl	r5, r1, #276	; 0x114
    139c:	385f4843 	ldmdacc	pc, {r0, r1, r6, fp, lr}^	; <UNPREDICTABLE>
    13a0:	41540052 	cmpmi	r4, r2, asr r0
    13a4:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    13a8:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    13ac:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    13b0:	61786574 	cmnvs	r8, r4, ror r5
    13b4:	6f633337 	svcvs	0x00633337
    13b8:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    13bc:	00353361 	eorseq	r3, r5, r1, ror #6
    13c0:	5f4d5241 	svcpl	0x004d5241
    13c4:	6100564e 	tstvs	r0, lr, asr #12
    13c8:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    13cc:	34686372 	strbtcc	r6, [r8], #-882	; 0xfffffc8e
    13d0:	6d726100 	ldfvse	f6, [r2, #-0]
    13d4:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    13d8:	61003668 	tstvs	r0, r8, ror #12
    13dc:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    13e0:	37686372 			; <UNDEFINED> instruction: 0x37686372
    13e4:	6d726100 	ldfvse	f6, [r2, #-0]
    13e8:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    13ec:	6c003868 	stcvs	8, cr3, [r0], {104}	; 0x68
    13f0:	20676e6f 	rsbcs	r6, r7, pc, ror #28
    13f4:	62756f64 	rsbsvs	r6, r5, #100, 30	; 0x190
    13f8:	6100656c 	tstvs	r0, ip, ror #10
    13fc:	745f6d72 	ldrbvc	r6, [pc], #-3442	; 1404 <_start-0x6bfc>
    1400:	5f656e75 	svcpl	0x00656e75
    1404:	61637378 	smcvs	14136	; 0x3738
    1408:	6d00656c 	cfstr32vs	mvfx6, [r0, #-432]	; 0xfffffe50
    140c:	6e696b61 	vnmulvs.f64	d22, d9, d17
    1410:	6f635f67 	svcvs	0x00635f67
    1414:	5f74736e 	svcpl	0x0074736e
    1418:	6c626174 	stfvse	f6, [r2], #-464	; 0xfffffe30
    141c:	68740065 	ldmdavs	r4!, {r0, r2, r5, r6}^
    1420:	5f626d75 	svcpl	0x00626d75
    1424:	6c6c6163 	stfvse	f6, [ip], #-396	; 0xfffffe74
    1428:	6169765f 	cmnvs	r9, pc, asr r6
    142c:	62616c5f 	rsbvs	r6, r1, #24320	; 0x5f00
    1430:	69006c65 	stmdbvs	r0, {r0, r2, r5, r6, sl, fp, sp, lr}
    1434:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1438:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    143c:	00357670 	eorseq	r7, r5, r0, ror r6
    1440:	5f617369 	svcpl	0x00617369
    1444:	5f746962 	svcpl	0x00746962
    1448:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    144c:	54006b36 	strpl	r6, [r0], #-2870	; 0xfffff4ca
    1450:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1454:	50435f54 	subpl	r5, r3, r4, asr pc
    1458:	6f635f55 	svcvs	0x00635f55
    145c:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1460:	54003761 	strpl	r3, [r0], #-1889	; 0xfffff89f
    1464:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1468:	50435f54 	subpl	r5, r3, r4, asr pc
    146c:	6f635f55 	svcvs	0x00635f55
    1470:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1474:	54003861 	strpl	r3, [r0], #-2145	; 0xfffff79f
    1478:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    147c:	50435f54 	subpl	r5, r3, r4, asr pc
    1480:	6f635f55 	svcvs	0x00635f55
    1484:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1488:	41003961 	tstmi	r0, r1, ror #18
    148c:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    1490:	415f5343 	cmpmi	pc, r3, asr #6
    1494:	00534350 	subseq	r4, r3, r0, asr r3
    1498:	5f4d5241 	svcpl	0x004d5241
    149c:	5f534350 	svcpl	0x00534350
    14a0:	43505441 	cmpmi	r0, #1090519040	; 0x41000000
    14a4:	6f630053 	svcvs	0x00630053
    14a8:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
    14ac:	6f642078 	svcvs	0x00642078
    14b0:	656c6275 	strbvs	r6, [ip, #-629]!	; 0xfffffd8b
    14b4:	52415400 	subpl	r5, r1, #0, 8
    14b8:	5f544547 	svcpl	0x00544547
    14bc:	5f555043 	svcpl	0x00555043
    14c0:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    14c4:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    14c8:	726f6333 	rsbvc	r6, pc, #-872415232	; 0xcc000000
    14cc:	61786574 	cmnvs	r8, r4, ror r5
    14d0:	54003335 	strpl	r3, [r0], #-821	; 0xfffffccb
    14d4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    14d8:	50435f54 	subpl	r5, r3, r4, asr pc
    14dc:	6f635f55 	svcvs	0x00635f55
    14e0:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    14e4:	6c70306d 	ldclvs	0, cr3, [r0], #-436	; 0xfffffe4c
    14e8:	61007375 	tstvs	r0, r5, ror r3
    14ec:	635f6d72 	cmpvs	pc, #7296	; 0x1c80
    14f0:	73690063 	cmnvc	r9, #99	; 0x63
    14f4:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    14f8:	73785f74 	cmnvc	r8, #116, 30	; 0x1d0
    14fc:	656c6163 	strbvs	r6, [ip, #-355]!	; 0xfffffe9d
    1500:	6f645f00 	svcvs	0x00645f00
    1504:	755f746e 	ldrbvc	r7, [pc, #-1134]	; 109e <_start-0x6f62>
    1508:	745f6573 	ldrbvc	r6, [pc], #-1395	; 1510 <_start-0x6af0>
    150c:	5f656572 	svcpl	0x00656572
    1510:	65726568 	ldrbvs	r6, [r2, #-1384]!	; 0xfffffa98
    1514:	4154005f 	cmpmi	r4, pc, asr r0
    1518:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    151c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1520:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1524:	64743031 	ldrbtvs	r3, [r4], #-49	; 0xffffffcf
    1528:	5400696d 	strpl	r6, [r0], #-2413	; 0xfffff693
    152c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1530:	50435f54 	subpl	r5, r3, r4, asr pc
    1534:	6f635f55 	svcvs	0x00635f55
    1538:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    153c:	62003561 	andvs	r3, r0, #406847488	; 0x18400000
    1540:	5f657361 	svcpl	0x00657361
    1544:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1548:	63657469 	cmnvs	r5, #1761607680	; 0x69000000
    154c:	65727574 	ldrbvs	r7, [r2, #-1396]!	; 0xfffffa8c
    1550:	6d726100 	ldfvse	f6, [r2, #-0]
    1554:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1558:	72635f68 	rsbvc	r5, r3, #104, 30	; 0x1a0
    155c:	41540063 	cmpmi	r4, r3, rrx
    1560:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1564:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1568:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    156c:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    1570:	616d7331 	cmnvs	sp, r1, lsr r3
    1574:	756d6c6c 	strbvc	r6, [sp, #-3180]!	; 0xfffff394
    1578:	7069746c 	rsbvc	r7, r9, ip, ror #8
    157c:	6100796c 	tstvs	r0, ip, ror #18
    1580:	635f6d72 	cmpvs	pc, #7296	; 0x1c80
    1584:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
    1588:	635f746e 	cmpvs	pc, #1845493760	; 0x6e000000
    158c:	73690063 	cmnvc	r9, #99	; 0x63
    1590:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1594:	72635f74 	rsbvc	r5, r3, #116, 30	; 0x1d0
    1598:	00323363 	eorseq	r3, r2, r3, ror #6
    159c:	5f4d5241 	svcpl	0x004d5241
    15a0:	69004c50 	stmdbvs	r0, {r4, r6, sl, fp, lr}
    15a4:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    15a8:	765f7469 	ldrbvc	r7, [pc], -r9, ror #8
    15ac:	33767066 	cmncc	r6, #102	; 0x66
    15b0:	61736900 	cmnvs	r3, r0, lsl #18
    15b4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    15b8:	7066765f 	rsbvc	r7, r6, pc, asr r6
    15bc:	42003476 	andmi	r3, r0, #1979711488	; 0x76000000
    15c0:	5f455341 	svcpl	0x00455341
    15c4:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    15c8:	3254365f 	subscc	r3, r4, #99614720	; 0x5f00000
    15cc:	53414200 	movtpl	r4, #4608	; 0x1200
    15d0:	52415f45 	subpl	r5, r1, #276	; 0x114
    15d4:	385f4843 	ldmdacc	pc, {r0, r1, r6, fp, lr}^	; <UNPREDICTABLE>
    15d8:	414d5f4d 	cmpmi	sp, sp, asr #30
    15dc:	54004e49 	strpl	r4, [r0], #-3657	; 0xfffff1b7
    15e0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    15e4:	50435f54 	subpl	r5, r3, r4, asr pc
    15e8:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    15ec:	6474396d 	ldrbtvs	r3, [r4], #-2413	; 0xfffff693
    15f0:	4100696d 	tstmi	r0, sp, ror #18
    15f4:	415f4d52 	cmpmi	pc, r2, asr sp	; <UNPREDICTABLE>
    15f8:	4142004c 	cmpmi	r2, ip, asr #32
    15fc:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1600:	5f484352 	svcpl	0x00484352
    1604:	61004d37 	tstvs	r0, r7, lsr sp
    1608:	745f6d72 	ldrbvc	r6, [pc], #-3442	; 1610 <_start-0x69f0>
    160c:	65677261 	strbvs	r7, [r7, #-609]!	; 0xfffffd9f
    1610:	616c5f74 	smcvs	50676	; 0xc5f4
    1614:	006c6562 	rsbeq	r6, ip, r2, ror #10
    1618:	5f6d7261 	svcpl	0x006d7261
    161c:	67726174 			; <UNDEFINED> instruction: 0x67726174
    1620:	695f7465 	ldmdbvs	pc, {r0, r2, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    1624:	006e736e 	rsbeq	r7, lr, lr, ror #6
    1628:	47524154 			; <UNDEFINED> instruction: 0x47524154
    162c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1630:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1634:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1638:	00347278 	eorseq	r7, r4, r8, ror r2
    163c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1640:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1644:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1648:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    164c:	00357278 	eorseq	r7, r5, r8, ror r2
    1650:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1654:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1658:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    165c:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1660:	00377278 	eorseq	r7, r7, r8, ror r2
    1664:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1668:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    166c:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1670:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1674:	00387278 	eorseq	r7, r8, r8, ror r2
    1678:	5f617369 	svcpl	0x00617369
    167c:	5f746962 	svcpl	0x00746962
    1680:	6561706c 	strbvs	r7, [r1, #-108]!	; 0xffffff94
    1684:	61736900 	cmnvs	r3, r0, lsl #18
    1688:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    168c:	6975715f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, r8, ip, sp, lr}^
    1690:	615f6b72 	cmpvs	pc, r2, ror fp	; <UNPREDICTABLE>
    1694:	36766d72 			; <UNDEFINED> instruction: 0x36766d72
    1698:	69007a6b 	stmdbvs	r0, {r0, r1, r3, r5, r6, r9, fp, ip, sp, lr}
    169c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    16a0:	6e5f7469 	cdpvs	4, 5, cr7, cr15, cr9, {3}
    16a4:	006d746f 	rsbeq	r7, sp, pc, ror #8
    16a8:	5f617369 	svcpl	0x00617369
    16ac:	5f746962 	svcpl	0x00746962
    16b0:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    16b4:	73690034 	cmnvc	r9, #52	; 0x34
    16b8:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    16bc:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    16c0:	0036766d 	eorseq	r7, r6, sp, ror #12
    16c4:	5f617369 	svcpl	0x00617369
    16c8:	5f746962 	svcpl	0x00746962
    16cc:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    16d0:	73690037 	cmnvc	r9, #55	; 0x37
    16d4:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    16d8:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    16dc:	0038766d 	eorseq	r7, r8, sp, ror #12
    16e0:	6e6f645f 	mcrvs	4, 3, r6, cr15, cr15, {2}
    16e4:	73755f74 	cmnvc	r5, #116, 30	; 0x1d0
    16e8:	74725f65 	ldrbtvc	r5, [r2], #-3941	; 0xfffff09b
    16ec:	65685f78 	strbvs	r5, [r8, #-3960]!	; 0xfffff088
    16f0:	005f6572 	subseq	r6, pc, r2, ror r5	; <UNPREDICTABLE>
    16f4:	74495155 	strbvc	r5, [r9], #-341	; 0xfffffeab
    16f8:	00657079 	rsbeq	r7, r5, r9, ror r0
    16fc:	5f617369 	svcpl	0x00617369
    1700:	5f746962 	svcpl	0x00746962
    1704:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1708:	00657435 	rsbeq	r7, r5, r5, lsr r4
    170c:	5f6d7261 	svcpl	0x006d7261
    1710:	656e7574 	strbvs	r7, [lr, #-1396]!	; 0xfffffa8c
    1714:	6d726100 	ldfvse	f6, [r2, #-0]
    1718:	7070635f 	rsbsvc	r6, r0, pc, asr r3
    171c:	746e695f 	strbtvc	r6, [lr], #-2399	; 0xfffff6a1
    1720:	6f777265 	svcvs	0x00777265
    1724:	66006b72 			; <UNDEFINED> instruction: 0x66006b72
    1728:	5f636e75 	svcpl	0x00636e75
    172c:	00727470 	rsbseq	r7, r2, r0, ror r4
    1730:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1734:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1738:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    173c:	32396d72 	eorscc	r6, r9, #7296	; 0x1c80
    1740:	68007430 	stmdavs	r0, {r4, r5, sl, ip, sp, lr}
    1744:	5f626174 	svcpl	0x00626174
    1748:	54007165 	strpl	r7, [r0], #-357	; 0xfffffe9b
    174c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1750:	50435f54 	subpl	r5, r3, r4, asr pc
    1754:	61665f55 	cmnvs	r6, r5, asr pc
    1758:	00363235 	eorseq	r3, r6, r5, lsr r2
    175c:	5f6d7261 	svcpl	0x006d7261
    1760:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1764:	7568745f 	strbvc	r7, [r8, #-1119]!	; 0xfffffba1
    1768:	685f626d 	ldmdavs	pc, {r0, r2, r3, r5, r6, r9, sp, lr}^	; <UNPREDICTABLE>
    176c:	76696477 			; <UNDEFINED> instruction: 0x76696477
    1770:	61746800 	cmnvs	r4, r0, lsl #16
    1774:	71655f62 	cmnvc	r5, r2, ror #30
    1778:	696f705f 	stmdbvs	pc!, {r0, r1, r2, r3, r4, r6, ip, sp, lr}^	; <UNPREDICTABLE>
    177c:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
    1780:	6d726100 	ldfvse	f6, [r2, #-0]
    1784:	6369705f 	cmnvs	r9, #95	; 0x5f
    1788:	6765725f 			; <UNDEFINED> instruction: 0x6765725f
    178c:	65747369 	ldrbvs	r7, [r4, #-873]!	; 0xfffffc97
    1790:	41540072 	cmpmi	r4, r2, ror r0
    1794:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1798:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    179c:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    17a0:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    17a4:	616d7330 	cmnvs	sp, r0, lsr r3
    17a8:	756d6c6c 	strbvc	r6, [sp, #-3180]!	; 0xfffff394
    17ac:	7069746c 	rsbvc	r7, r9, ip, ror #8
    17b0:	5400796c 	strpl	r7, [r0], #-2412	; 0xfffff694
    17b4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    17b8:	50435f54 	subpl	r5, r3, r4, asr pc
    17bc:	706d5f55 	rsbvc	r5, sp, r5, asr pc
    17c0:	65726f63 	ldrbvs	r6, [r2, #-3939]!	; 0xfffff09d
    17c4:	66766f6e 	ldrbtvs	r6, [r6], -lr, ror #30
    17c8:	73690070 	cmnvc	r9, #112	; 0x70
    17cc:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    17d0:	75715f74 	ldrbvc	r5, [r1, #-3956]!	; 0xfffff08c
    17d4:	5f6b7269 	svcpl	0x006b7269
    17d8:	5f336d63 	svcpl	0x00336d63
    17dc:	6472646c 	ldrbtvs	r6, [r2], #-1132	; 0xfffffb94
    17e0:	4d524100 	ldfmie	f4, [r2, #-0]
    17e4:	0043435f 	subeq	r4, r3, pc, asr r3
    17e8:	5f6d7261 	svcpl	0x006d7261
    17ec:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    17f0:	00325f38 	eorseq	r5, r2, r8, lsr pc
    17f4:	5f6d7261 	svcpl	0x006d7261
    17f8:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    17fc:	00335f38 	eorseq	r5, r3, r8, lsr pc
    1800:	5f6d7261 	svcpl	0x006d7261
    1804:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1808:	00345f38 	eorseq	r5, r4, r8, lsr pc
    180c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1810:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1814:	665f5550 			; <UNDEFINED> instruction: 0x665f5550
    1818:	3236706d 	eorscc	r7, r6, #109	; 0x6d
    181c:	52410036 	subpl	r0, r1, #54	; 0x36
    1820:	53435f4d 	movtpl	r5, #16205	; 0x3f4d
    1824:	6d726100 	ldfvse	f6, [r2, #-0]
    1828:	3170665f 	cmncc	r0, pc, asr r6
    182c:	6e695f36 	mcrvs	15, 3, r5, cr9, cr6, {1}
    1830:	61007473 	tstvs	r0, r3, ror r4
    1834:	625f6d72 	subsvs	r6, pc, #7296	; 0x1c80
    1838:	5f657361 	svcpl	0x00657361
    183c:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1840:	52415400 	subpl	r5, r1, #0, 8
    1844:	5f544547 	svcpl	0x00544547
    1848:	5f555043 	svcpl	0x00555043
    184c:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1850:	31617865 	cmncc	r1, r5, ror #16
    1854:	726f6335 	rsbvc	r6, pc, #-738197504	; 0xd4000000
    1858:	61786574 	cmnvs	r8, r4, ror r5
    185c:	72610037 	rsbvc	r0, r1, #55	; 0x37
    1860:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    1864:	65376863 	ldrvs	r6, [r7, #-2147]!	; 0xfffff79d
    1868:	4154006d 	cmpmi	r4, sp, rrx
    186c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1870:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1874:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1878:	61786574 	cmnvs	r8, r4, ror r5
    187c:	61003237 	tstvs	r0, r7, lsr r2
    1880:	705f6d72 	subsvc	r6, pc, r2, ror sp	; <UNPREDICTABLE>
    1884:	645f7363 	ldrbvs	r7, [pc], #-867	; 188c <_start-0x6774>
    1888:	75616665 	strbvc	r6, [r1, #-1637]!	; 0xfffff99b
    188c:	4100746c 	tstmi	r0, ip, ror #8
    1890:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    1894:	415f5343 	cmpmi	pc, r3, asr #6
    1898:	53435041 	movtpl	r5, #12353	; 0x3041
    189c:	434f4c5f 	movtmi	r4, #64607	; 0xfc5f
    18a0:	54004c41 	strpl	r4, [r0], #-3137	; 0xfffff3bf
    18a4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    18a8:	50435f54 	subpl	r5, r3, r4, asr pc
    18ac:	6f635f55 	svcvs	0x00635f55
    18b0:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    18b4:	00353761 	eorseq	r3, r5, r1, ror #14
    18b8:	47524154 			; <UNDEFINED> instruction: 0x47524154
    18bc:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    18c0:	735f5550 	cmpvc	pc, #80, 10	; 0x14000000
    18c4:	6e6f7274 	mcrvs	2, 3, r7, cr15, cr4, {3}
    18c8:	6d726167 	ldfvse	f6, [r2, #-412]!	; 0xfffffe64
    18cc:	6d726100 	ldfvse	f6, [r2, #-0]
    18d0:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    18d4:	68745f68 	ldmdavs	r4!, {r3, r5, r6, r8, r9, sl, fp, ip, lr}^
    18d8:	31626d75 	smccc	9941	; 0x26d5
    18dc:	6d726100 	ldfvse	f6, [r2, #-0]
    18e0:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    18e4:	68745f68 	ldmdavs	r4!, {r3, r5, r6, r8, r9, sl, fp, ip, lr}^
    18e8:	32626d75 	rsbcc	r6, r2, #7488	; 0x1d40
    18ec:	52415400 	subpl	r5, r1, #0, 8
    18f0:	5f544547 	svcpl	0x00544547
    18f4:	5f555043 	svcpl	0x00555043
    18f8:	6d6d7769 	stclvs	7, cr7, [sp, #-420]!	; 0xfffffe5c
    18fc:	61007478 	tstvs	r0, r8, ror r4
    1900:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1904:	35686372 	strbcc	r6, [r8, #-882]!	; 0xfffffc8e
    1908:	73690074 	cmnvc	r9, #116	; 0x74
    190c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1910:	706d5f74 	rsbvc	r5, sp, r4, ror pc
    1914:	6d726100 	ldfvse	f6, [r2, #-0]
    1918:	5f646c5f 	svcpl	0x00646c5f
    191c:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
    1920:	72610064 	rsbvc	r0, r1, #100	; 0x64
    1924:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    1928:	5f386863 	svcpl	0x00386863
    192c:	Address 0x000000000000192c is out of bounds.


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
