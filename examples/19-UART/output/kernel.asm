
./kernel:     file format elf32-littlearm


Disassembly of section .text:

00008000 <_start>:
_start():
/mnt/c/Users/Kuba/Downloads/03/kernel/src/start.s:8
;@ tady budou symboly, ktere chceme na zacatek kodove sekce
.section .text.start

;@ vstupni bod do kernelu - nechame ho vlozit na zacatek kodu
_start:
    mov sp,#0x8000			;@ nastavime stack pointer na spodek zasobniku
    8000:	e3a0d902 	mov	sp, #32768	; 0x8000
/mnt/c/Users/Kuba/Downloads/03/kernel/src/start.s:9
	bl _c_startup			;@ C startup kod (inicializace prostredi)
    8004:	eb00048f 	bl	9248 <_c_startup>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/start.s:10
	bl _cpp_startup			;@ C++ startup kod (volani globalnich konstruktoru, ...)
    8008:	eb0004a8 	bl	92b0 <_cpp_startup>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/start.s:11
    bl _kernel_main			;@ skocime do hlavniho kodu jadra (v C)
    800c:	eb000475 	bl	91e8 <_kernel_main>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/start.s:12
	bl _cpp_shutdown		;@ C++ shutdown kod (volani globalnich destruktoru, ...)
    8010:	eb0004bc 	bl	9308 <_cpp_shutdown>

00008014 <hang>:
hang():
/mnt/c/Users/Kuba/Downloads/03/kernel/src/start.s:14
hang:
    b hang
    8014:	eafffffe 	b	8014 <hang>

00008018 <__cxa_guard_acquire>:
__cxa_guard_acquire():
/mnt/c/Users/Kuba/Downloads/03/kernel/src/cxx.cpp:11
	extern "C" int __cxa_guard_acquire (__guard *);
	extern "C" void __cxa_guard_release (__guard *);
	extern "C" void __cxa_guard_abort (__guard *);

	extern "C" int __cxa_guard_acquire (__guard *g)
	{
    8018:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    801c:	e28db000 	add	fp, sp, #0
    8020:	e24dd00c 	sub	sp, sp, #12
    8024:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/cxx.cpp:12
		return !*(char *)(g);
    8028:	e51b3008 	ldr	r3, [fp, #-8]
    802c:	e5d33000 	ldrb	r3, [r3]
    8030:	e3530000 	cmp	r3, #0
    8034:	03a03001 	moveq	r3, #1
    8038:	13a03000 	movne	r3, #0
    803c:	e6ef3073 	uxtb	r3, r3
/mnt/c/Users/Kuba/Downloads/03/kernel/src/cxx.cpp:13
	}
    8040:	e1a00003 	mov	r0, r3
    8044:	e28bd000 	add	sp, fp, #0
    8048:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    804c:	e12fff1e 	bx	lr

00008050 <__cxa_guard_release>:
__cxa_guard_release():
/mnt/c/Users/Kuba/Downloads/03/kernel/src/cxx.cpp:16

	extern "C" void __cxa_guard_release (__guard *g)
	{
    8050:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8054:	e28db000 	add	fp, sp, #0
    8058:	e24dd00c 	sub	sp, sp, #12
    805c:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/cxx.cpp:17
		*(char *)g = 1;
    8060:	e51b3008 	ldr	r3, [fp, #-8]
    8064:	e3a02001 	mov	r2, #1
    8068:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/cxx.cpp:18
	}
    806c:	e320f000 	nop	{0}
    8070:	e28bd000 	add	sp, fp, #0
    8074:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8078:	e12fff1e 	bx	lr

0000807c <__cxa_guard_abort>:
__cxa_guard_abort():
/mnt/c/Users/Kuba/Downloads/03/kernel/src/cxx.cpp:21

	extern "C" void __cxa_guard_abort (__guard *)
	{
    807c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8080:	e28db000 	add	fp, sp, #0
    8084:	e24dd00c 	sub	sp, sp, #12
    8088:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/cxx.cpp:23

	}
    808c:	e320f000 	nop	{0}
    8090:	e28bd000 	add	sp, fp, #0
    8094:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8098:	e12fff1e 	bx	lr

0000809c <__dso_handle>:
__dso_handle():
/mnt/c/Users/Kuba/Downloads/03/kernel/src/cxx.cpp:27
}

extern "C" void __dso_handle()
{
    809c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    80a0:	e28db000 	add	fp, sp, #0
/mnt/c/Users/Kuba/Downloads/03/kernel/src/cxx.cpp:29
    // ignore dtors for now
}
    80a4:	e320f000 	nop	{0}
    80a8:	e28bd000 	add	sp, fp, #0
    80ac:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    80b0:	e12fff1e 	bx	lr

000080b4 <__cxa_atexit>:
__cxa_atexit():
/mnt/c/Users/Kuba/Downloads/03/kernel/src/cxx.cpp:32

extern "C" void __cxa_atexit()
{
    80b4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    80b8:	e28db000 	add	fp, sp, #0
/mnt/c/Users/Kuba/Downloads/03/kernel/src/cxx.cpp:34
    // ignore dtors for now
}
    80bc:	e320f000 	nop	{0}
    80c0:	e28bd000 	add	sp, fp, #0
    80c4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    80c8:	e12fff1e 	bx	lr

000080cc <__cxa_pure_virtual>:
__cxa_pure_virtual():
/mnt/c/Users/Kuba/Downloads/03/kernel/src/cxx.cpp:37

extern "C" void __cxa_pure_virtual()
{
    80cc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    80d0:	e28db000 	add	fp, sp, #0
/mnt/c/Users/Kuba/Downloads/03/kernel/src/cxx.cpp:39
    // pure virtual method called
}
    80d4:	e320f000 	nop	{0}
    80d8:	e28bd000 	add	sp, fp, #0
    80dc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    80e0:	e12fff1e 	bx	lr

000080e4 <__aeabi_unwind_cpp_pr1>:
__aeabi_unwind_cpp_pr1():
/mnt/c/Users/Kuba/Downloads/03/kernel/src/cxx.cpp:42

extern "C" void __aeabi_unwind_cpp_pr1()
{
    80e4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    80e8:	e28db000 	add	fp, sp, #0
/mnt/c/Users/Kuba/Downloads/03/kernel/src/cxx.cpp:43 (discriminator 1)
	while (true)
    80ec:	eafffffe 	b	80ec <__aeabi_unwind_cpp_pr1+0x8>

000080f0 <_ZN4CAUXC1Ej>:
_ZN4CAUXC2Ej():
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/bcm_aux.cpp:5
#include <drivers/bcm_aux.h>

CAUX sAUX(hal::AUX_Base);

CAUX::CAUX(unsigned int aux_base)
    80f0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    80f4:	e28db000 	add	fp, sp, #0
    80f8:	e24dd00c 	sub	sp, sp, #12
    80fc:	e50b0008 	str	r0, [fp, #-8]
    8100:	e50b100c 	str	r1, [fp, #-12]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/bcm_aux.cpp:6
    : mAUX_Reg(reinterpret_cast<unsigned int*>(aux_base))
    8104:	e51b200c 	ldr	r2, [fp, #-12]
    8108:	e51b3008 	ldr	r3, [fp, #-8]
    810c:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/bcm_aux.cpp:9
{
    //
}
    8110:	e51b3008 	ldr	r3, [fp, #-8]
    8114:	e1a00003 	mov	r0, r3
    8118:	e28bd000 	add	sp, fp, #0
    811c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8120:	e12fff1e 	bx	lr

00008124 <_ZN4CAUX6EnableEN3hal15AUX_PeripheralsE>:
_ZN4CAUX6EnableEN3hal15AUX_PeripheralsE():
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/bcm_aux.cpp:12

void CAUX::Enable(hal::AUX_Peripherals aux_peripheral)
{
    8124:	e92d4800 	push	{fp, lr}
    8128:	e28db004 	add	fp, sp, #4
    812c:	e24dd008 	sub	sp, sp, #8
    8130:	e50b0008 	str	r0, [fp, #-8]
    8134:	e50b100c 	str	r1, [fp, #-12]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/bcm_aux.cpp:13
    Set_Register(hal::AUX_Reg::ENABLES, Get_Register(hal::AUX_Reg::ENABLES) | (1 << static_cast<uint32_t>(aux_peripheral)));
    8138:	e3a01001 	mov	r1, #1
    813c:	e51b0008 	ldr	r0, [fp, #-8]
    8140:	eb000031 	bl	820c <_ZN4CAUX12Get_RegisterEN3hal7AUX_RegE>
    8144:	e1a02000 	mov	r2, r0
    8148:	e51b300c 	ldr	r3, [fp, #-12]
    814c:	e3a01001 	mov	r1, #1
    8150:	e1a03311 	lsl	r3, r1, r3
    8154:	e1823003 	orr	r3, r2, r3
    8158:	e1a02003 	mov	r2, r3
    815c:	e3a01001 	mov	r1, #1
    8160:	e51b0008 	ldr	r0, [fp, #-8]
    8164:	eb000017 	bl	81c8 <_ZN4CAUX12Set_RegisterEN3hal7AUX_RegEj>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/bcm_aux.cpp:14
}
    8168:	e320f000 	nop	{0}
    816c:	e24bd004 	sub	sp, fp, #4
    8170:	e8bd8800 	pop	{fp, pc}

00008174 <_ZN4CAUX7DisableEN3hal15AUX_PeripheralsE>:
_ZN4CAUX7DisableEN3hal15AUX_PeripheralsE():
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/bcm_aux.cpp:17

void CAUX::Disable(hal::AUX_Peripherals aux_peripheral)
{
    8174:	e92d4800 	push	{fp, lr}
    8178:	e28db004 	add	fp, sp, #4
    817c:	e24dd008 	sub	sp, sp, #8
    8180:	e50b0008 	str	r0, [fp, #-8]
    8184:	e50b100c 	str	r1, [fp, #-12]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/bcm_aux.cpp:18
    Set_Register(hal::AUX_Reg::ENABLES, Get_Register(hal::AUX_Reg::ENABLES) & ~(1 << static_cast<uint32_t>(aux_peripheral)));
    8188:	e3a01001 	mov	r1, #1
    818c:	e51b0008 	ldr	r0, [fp, #-8]
    8190:	eb00001d 	bl	820c <_ZN4CAUX12Get_RegisterEN3hal7AUX_RegE>
    8194:	e1a02000 	mov	r2, r0
    8198:	e51b300c 	ldr	r3, [fp, #-12]
    819c:	e3a01001 	mov	r1, #1
    81a0:	e1a03311 	lsl	r3, r1, r3
    81a4:	e1e03003 	mvn	r3, r3
    81a8:	e0033002 	and	r3, r3, r2
    81ac:	e1a02003 	mov	r2, r3
    81b0:	e3a01001 	mov	r1, #1
    81b4:	e51b0008 	ldr	r0, [fp, #-8]
    81b8:	eb000002 	bl	81c8 <_ZN4CAUX12Set_RegisterEN3hal7AUX_RegEj>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/bcm_aux.cpp:19
}
    81bc:	e320f000 	nop	{0}
    81c0:	e24bd004 	sub	sp, fp, #4
    81c4:	e8bd8800 	pop	{fp, pc}

000081c8 <_ZN4CAUX12Set_RegisterEN3hal7AUX_RegEj>:
_ZN4CAUX12Set_RegisterEN3hal7AUX_RegEj():
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/bcm_aux.cpp:22

void CAUX::Set_Register(hal::AUX_Reg reg_idx, uint32_t value)
{
    81c8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    81cc:	e28db000 	add	fp, sp, #0
    81d0:	e24dd014 	sub	sp, sp, #20
    81d4:	e50b0008 	str	r0, [fp, #-8]
    81d8:	e50b100c 	str	r1, [fp, #-12]
    81dc:	e50b2010 	str	r2, [fp, #-16]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/bcm_aux.cpp:23
    mAUX_Reg[static_cast<unsigned int>(reg_idx)] = value;
    81e0:	e51b3008 	ldr	r3, [fp, #-8]
    81e4:	e5932000 	ldr	r2, [r3]
    81e8:	e51b300c 	ldr	r3, [fp, #-12]
    81ec:	e1a03103 	lsl	r3, r3, #2
    81f0:	e0823003 	add	r3, r2, r3
    81f4:	e51b2010 	ldr	r2, [fp, #-16]
    81f8:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/bcm_aux.cpp:24
}
    81fc:	e320f000 	nop	{0}
    8200:	e28bd000 	add	sp, fp, #0
    8204:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8208:	e12fff1e 	bx	lr

0000820c <_ZN4CAUX12Get_RegisterEN3hal7AUX_RegE>:
_ZN4CAUX12Get_RegisterEN3hal7AUX_RegE():
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/bcm_aux.cpp:27

uint32_t CAUX::Get_Register(hal::AUX_Reg reg_idx)
{
    820c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8210:	e28db000 	add	fp, sp, #0
    8214:	e24dd00c 	sub	sp, sp, #12
    8218:	e50b0008 	str	r0, [fp, #-8]
    821c:	e50b100c 	str	r1, [fp, #-12]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/bcm_aux.cpp:28
    return mAUX_Reg[static_cast<unsigned int>(reg_idx)];
    8220:	e51b3008 	ldr	r3, [fp, #-8]
    8224:	e5932000 	ldr	r2, [r3]
    8228:	e51b300c 	ldr	r3, [fp, #-12]
    822c:	e1a03103 	lsl	r3, r3, #2
    8230:	e0823003 	add	r3, r2, r3
    8234:	e5933000 	ldr	r3, [r3]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/bcm_aux.cpp:29
}
    8238:	e1a00003 	mov	r0, r3
    823c:	e28bd000 	add	sp, fp, #0
    8240:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8244:	e12fff1e 	bx	lr

00008248 <_Z41__static_initialization_and_destruction_0ii>:
_Z41__static_initialization_and_destruction_0ii():
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/bcm_aux.cpp:29
    8248:	e92d4800 	push	{fp, lr}
    824c:	e28db004 	add	fp, sp, #4
    8250:	e24dd008 	sub	sp, sp, #8
    8254:	e50b0008 	str	r0, [fp, #-8]
    8258:	e50b100c 	str	r1, [fp, #-12]
    825c:	e51b3008 	ldr	r3, [fp, #-8]
    8260:	e3530001 	cmp	r3, #1
    8264:	1a000006 	bne	8284 <_Z41__static_initialization_and_destruction_0ii+0x3c>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/bcm_aux.cpp:29 (discriminator 1)
    8268:	e51b300c 	ldr	r3, [fp, #-12]
    826c:	e59f201c 	ldr	r2, [pc, #28]	; 8290 <_Z41__static_initialization_and_destruction_0ii+0x48>
    8270:	e1530002 	cmp	r3, r2
    8274:	1a000002 	bne	8284 <_Z41__static_initialization_and_destruction_0ii+0x3c>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/bcm_aux.cpp:3
CAUX sAUX(hal::AUX_Base);
    8278:	e59f1014 	ldr	r1, [pc, #20]	; 8294 <_Z41__static_initialization_and_destruction_0ii+0x4c>
    827c:	e59f0014 	ldr	r0, [pc, #20]	; 8298 <_Z41__static_initialization_and_destruction_0ii+0x50>
    8280:	ebffff9a 	bl	80f0 <_ZN4CAUXC1Ej>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/bcm_aux.cpp:29
}
    8284:	e320f000 	nop	{0}
    8288:	e24bd004 	sub	sp, fp, #4
    828c:	e8bd8800 	pop	{fp, pc}
    8290:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>
    8294:	20215000 	eorcs	r5, r1, r0
    8298:	000096d0 	ldrdeq	r9, [r0], -r0

0000829c <_GLOBAL__sub_I_sAUX>:
_GLOBAL__sub_I_sAUX():
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/bcm_aux.cpp:29
    829c:	e92d4800 	push	{fp, lr}
    82a0:	e28db004 	add	fp, sp, #4
    82a4:	e59f1008 	ldr	r1, [pc, #8]	; 82b4 <_GLOBAL__sub_I_sAUX+0x18>
    82a8:	e3a00001 	mov	r0, #1
    82ac:	ebffffe5 	bl	8248 <_Z41__static_initialization_and_destruction_0ii>
    82b0:	e8bd8800 	pop	{fp, pc}
    82b4:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>

000082b8 <_ZN13CGPIO_HandlerC1Ej>:
_ZN13CGPIO_HandlerC2Ej():
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:6
#include <hal/peripherals.h>
#include <drivers/gpio.h>

CGPIO_Handler sGPIO(hal::GPIO_Base);

CGPIO_Handler::CGPIO_Handler(unsigned int gpio_base_addr)
    82b8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    82bc:	e28db000 	add	fp, sp, #0
    82c0:	e24dd00c 	sub	sp, sp, #12
    82c4:	e50b0008 	str	r0, [fp, #-8]
    82c8:	e50b100c 	str	r1, [fp, #-12]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:7
	: mGPIO(reinterpret_cast<unsigned int*>(gpio_base_addr))
    82cc:	e51b200c 	ldr	r2, [fp, #-12]
    82d0:	e51b3008 	ldr	r3, [fp, #-8]
    82d4:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:10
{
	//
}
    82d8:	e51b3008 	ldr	r3, [fp, #-8]
    82dc:	e1a00003 	mov	r0, r3
    82e0:	e28bd000 	add	sp, fp, #0
    82e4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    82e8:	e12fff1e 	bx	lr

000082ec <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_>:
_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_():
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:13

bool CGPIO_Handler::Get_GPFSEL_Location(uint32_t pin, uint32_t& reg, uint32_t& bit_idx) const
{
    82ec:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    82f0:	e28db000 	add	fp, sp, #0
    82f4:	e24dd014 	sub	sp, sp, #20
    82f8:	e50b0008 	str	r0, [fp, #-8]
    82fc:	e50b100c 	str	r1, [fp, #-12]
    8300:	e50b2010 	str	r2, [fp, #-16]
    8304:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:14
	if (pin > hal::GPIO_Pin_Count)
    8308:	e51b300c 	ldr	r3, [fp, #-12]
    830c:	e3530036 	cmp	r3, #54	; 0x36
    8310:	9a000001 	bls	831c <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0x30>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:15
		return false;
    8314:	e3a03000 	mov	r3, #0
    8318:	ea000033 	b	83ec <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0x100>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:17
	
	switch (pin / 10)
    831c:	e51b300c 	ldr	r3, [fp, #-12]
    8320:	e59f20d4 	ldr	r2, [pc, #212]	; 83fc <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0x110>
    8324:	e0832392 	umull	r2, r3, r2, r3
    8328:	e1a031a3 	lsr	r3, r3, #3
    832c:	e3530005 	cmp	r3, #5
    8330:	979ff103 	ldrls	pc, [pc, r3, lsl #2]
    8334:	ea00001d 	b	83b0 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0xc4>
    8338:	00008350 	andeq	r8, r0, r0, asr r3
    833c:	00008360 	andeq	r8, r0, r0, ror #6
    8340:	00008370 	andeq	r8, r0, r0, ror r3
    8344:	00008380 	andeq	r8, r0, r0, lsl #7
    8348:	00008390 	muleq	r0, r0, r3
    834c:	000083a0 	andeq	r8, r0, r0, lsr #7
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:19
	{
		case 0: reg = static_cast<uint32_t>(hal::GPIO_Reg::GPFSEL0); break;
    8350:	e51b3010 	ldr	r3, [fp, #-16]
    8354:	e3a02000 	mov	r2, #0
    8358:	e5832000 	str	r2, [r3]
    835c:	ea000013 	b	83b0 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0xc4>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:20
		case 1: reg = static_cast<uint32_t>(hal::GPIO_Reg::GPFSEL1); break;
    8360:	e51b3010 	ldr	r3, [fp, #-16]
    8364:	e3a02001 	mov	r2, #1
    8368:	e5832000 	str	r2, [r3]
    836c:	ea00000f 	b	83b0 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0xc4>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:21
		case 2: reg = static_cast<uint32_t>(hal::GPIO_Reg::GPFSEL2); break;
    8370:	e51b3010 	ldr	r3, [fp, #-16]
    8374:	e3a02002 	mov	r2, #2
    8378:	e5832000 	str	r2, [r3]
    837c:	ea00000b 	b	83b0 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0xc4>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:22
		case 3: reg = static_cast<uint32_t>(hal::GPIO_Reg::GPFSEL3); break;
    8380:	e51b3010 	ldr	r3, [fp, #-16]
    8384:	e3a02003 	mov	r2, #3
    8388:	e5832000 	str	r2, [r3]
    838c:	ea000007 	b	83b0 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0xc4>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:23
		case 4: reg = static_cast<uint32_t>(hal::GPIO_Reg::GPFSEL4); break;
    8390:	e51b3010 	ldr	r3, [fp, #-16]
    8394:	e3a02004 	mov	r2, #4
    8398:	e5832000 	str	r2, [r3]
    839c:	ea000003 	b	83b0 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0xc4>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:24
		case 5: reg = static_cast<uint32_t>(hal::GPIO_Reg::GPFSEL5); break;
    83a0:	e51b3010 	ldr	r3, [fp, #-16]
    83a4:	e3a02005 	mov	r2, #5
    83a8:	e5832000 	str	r2, [r3]
    83ac:	e320f000 	nop	{0}
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:27
	}
	
	bit_idx = (pin % 10) * 3;
    83b0:	e51b100c 	ldr	r1, [fp, #-12]
    83b4:	e59f3040 	ldr	r3, [pc, #64]	; 83fc <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0x110>
    83b8:	e0832193 	umull	r2, r3, r3, r1
    83bc:	e1a021a3 	lsr	r2, r3, #3
    83c0:	e1a03002 	mov	r3, r2
    83c4:	e1a03103 	lsl	r3, r3, #2
    83c8:	e0833002 	add	r3, r3, r2
    83cc:	e1a03083 	lsl	r3, r3, #1
    83d0:	e0412003 	sub	r2, r1, r3
    83d4:	e1a03002 	mov	r3, r2
    83d8:	e1a03083 	lsl	r3, r3, #1
    83dc:	e0832002 	add	r2, r3, r2
    83e0:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    83e4:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:29
	
	return true;
    83e8:	e3a03001 	mov	r3, #1
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:30
}
    83ec:	e1a00003 	mov	r0, r3
    83f0:	e28bd000 	add	sp, fp, #0
    83f4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    83f8:	e12fff1e 	bx	lr
    83fc:	cccccccd 	stclgt	12, cr12, [ip], {205}	; 0xcd

00008400 <_ZNK13CGPIO_Handler18Get_GPCLR_LocationEjRjS0_>:
_ZNK13CGPIO_Handler18Get_GPCLR_LocationEjRjS0_():
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:33

bool CGPIO_Handler::Get_GPCLR_Location(uint32_t pin, uint32_t& reg, uint32_t& bit_idx) const
{
    8400:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8404:	e28db000 	add	fp, sp, #0
    8408:	e24dd014 	sub	sp, sp, #20
    840c:	e50b0008 	str	r0, [fp, #-8]
    8410:	e50b100c 	str	r1, [fp, #-12]
    8414:	e50b2010 	str	r2, [fp, #-16]
    8418:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:34
	if (pin > hal::GPIO_Pin_Count)
    841c:	e51b300c 	ldr	r3, [fp, #-12]
    8420:	e3530036 	cmp	r3, #54	; 0x36
    8424:	9a000001 	bls	8430 <_ZNK13CGPIO_Handler18Get_GPCLR_LocationEjRjS0_+0x30>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:35
		return false;
    8428:	e3a03000 	mov	r3, #0
    842c:	ea00000c 	b	8464 <_ZNK13CGPIO_Handler18Get_GPCLR_LocationEjRjS0_+0x64>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:37
	
	reg = static_cast<uint32_t>((pin < 32) ? hal::GPIO_Reg::GPCLR0 : hal::GPIO_Reg::GPCLR1);
    8430:	e51b300c 	ldr	r3, [fp, #-12]
    8434:	e353001f 	cmp	r3, #31
    8438:	8a000001 	bhi	8444 <_ZNK13CGPIO_Handler18Get_GPCLR_LocationEjRjS0_+0x44>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:37 (discriminator 1)
    843c:	e3a0200a 	mov	r2, #10
    8440:	ea000000 	b	8448 <_ZNK13CGPIO_Handler18Get_GPCLR_LocationEjRjS0_+0x48>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:37 (discriminator 2)
    8444:	e3a0200b 	mov	r2, #11
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:37 (discriminator 4)
    8448:	e51b3010 	ldr	r3, [fp, #-16]
    844c:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:38 (discriminator 4)
	bit_idx = pin % 32;
    8450:	e51b300c 	ldr	r3, [fp, #-12]
    8454:	e203201f 	and	r2, r3, #31
    8458:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    845c:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:40 (discriminator 4)
	
	return true;
    8460:	e3a03001 	mov	r3, #1
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:41
}
    8464:	e1a00003 	mov	r0, r3
    8468:	e28bd000 	add	sp, fp, #0
    846c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8470:	e12fff1e 	bx	lr

00008474 <_ZNK13CGPIO_Handler18Get_GPSET_LocationEjRjS0_>:
_ZNK13CGPIO_Handler18Get_GPSET_LocationEjRjS0_():
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:44

bool CGPIO_Handler::Get_GPSET_Location(uint32_t pin, uint32_t& reg, uint32_t& bit_idx) const
{
    8474:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8478:	e28db000 	add	fp, sp, #0
    847c:	e24dd014 	sub	sp, sp, #20
    8480:	e50b0008 	str	r0, [fp, #-8]
    8484:	e50b100c 	str	r1, [fp, #-12]
    8488:	e50b2010 	str	r2, [fp, #-16]
    848c:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:45
	if (pin > hal::GPIO_Pin_Count)
    8490:	e51b300c 	ldr	r3, [fp, #-12]
    8494:	e3530036 	cmp	r3, #54	; 0x36
    8498:	9a000001 	bls	84a4 <_ZNK13CGPIO_Handler18Get_GPSET_LocationEjRjS0_+0x30>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:46
		return false;
    849c:	e3a03000 	mov	r3, #0
    84a0:	ea00000c 	b	84d8 <_ZNK13CGPIO_Handler18Get_GPSET_LocationEjRjS0_+0x64>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:48
	
	reg = static_cast<uint32_t>((pin < 32) ? hal::GPIO_Reg::GPSET0 : hal::GPIO_Reg::GPSET1);
    84a4:	e51b300c 	ldr	r3, [fp, #-12]
    84a8:	e353001f 	cmp	r3, #31
    84ac:	8a000001 	bhi	84b8 <_ZNK13CGPIO_Handler18Get_GPSET_LocationEjRjS0_+0x44>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:48 (discriminator 1)
    84b0:	e3a02007 	mov	r2, #7
    84b4:	ea000000 	b	84bc <_ZNK13CGPIO_Handler18Get_GPSET_LocationEjRjS0_+0x48>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:48 (discriminator 2)
    84b8:	e3a02008 	mov	r2, #8
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:48 (discriminator 4)
    84bc:	e51b3010 	ldr	r3, [fp, #-16]
    84c0:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:49 (discriminator 4)
	bit_idx = pin % 32;
    84c4:	e51b300c 	ldr	r3, [fp, #-12]
    84c8:	e203201f 	and	r2, r3, #31
    84cc:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    84d0:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:51 (discriminator 4)
	
	return true;
    84d4:	e3a03001 	mov	r3, #1
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:52
}
    84d8:	e1a00003 	mov	r0, r3
    84dc:	e28bd000 	add	sp, fp, #0
    84e0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    84e4:	e12fff1e 	bx	lr

000084e8 <_ZNK13CGPIO_Handler18Get_GPLEV_LocationEjRjS0_>:
_ZNK13CGPIO_Handler18Get_GPLEV_LocationEjRjS0_():
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:55

bool CGPIO_Handler::Get_GPLEV_Location(uint32_t pin, uint32_t& reg, uint32_t& bit_idx) const
{
    84e8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    84ec:	e28db000 	add	fp, sp, #0
    84f0:	e24dd014 	sub	sp, sp, #20
    84f4:	e50b0008 	str	r0, [fp, #-8]
    84f8:	e50b100c 	str	r1, [fp, #-12]
    84fc:	e50b2010 	str	r2, [fp, #-16]
    8500:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:56
	if (pin > hal::GPIO_Pin_Count)
    8504:	e51b300c 	ldr	r3, [fp, #-12]
    8508:	e3530036 	cmp	r3, #54	; 0x36
    850c:	9a000001 	bls	8518 <_ZNK13CGPIO_Handler18Get_GPLEV_LocationEjRjS0_+0x30>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:57
		return false;
    8510:	e3a03000 	mov	r3, #0
    8514:	ea00000c 	b	854c <_ZNK13CGPIO_Handler18Get_GPLEV_LocationEjRjS0_+0x64>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:59
	
	reg = static_cast<uint32_t>((pin < 32) ? hal::GPIO_Reg::GPLEV0 : hal::GPIO_Reg::GPLEV1);
    8518:	e51b300c 	ldr	r3, [fp, #-12]
    851c:	e353001f 	cmp	r3, #31
    8520:	8a000001 	bhi	852c <_ZNK13CGPIO_Handler18Get_GPLEV_LocationEjRjS0_+0x44>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:59 (discriminator 1)
    8524:	e3a0200d 	mov	r2, #13
    8528:	ea000000 	b	8530 <_ZNK13CGPIO_Handler18Get_GPLEV_LocationEjRjS0_+0x48>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:59 (discriminator 2)
    852c:	e3a0200e 	mov	r2, #14
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:59 (discriminator 4)
    8530:	e51b3010 	ldr	r3, [fp, #-16]
    8534:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:60 (discriminator 4)
	bit_idx = pin % 32;
    8538:	e51b300c 	ldr	r3, [fp, #-12]
    853c:	e203201f 	and	r2, r3, #31
    8540:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8544:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:62 (discriminator 4)
	
	return true;
    8548:	e3a03001 	mov	r3, #1
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:63
}
    854c:	e1a00003 	mov	r0, r3
    8550:	e28bd000 	add	sp, fp, #0
    8554:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8558:	e12fff1e 	bx	lr

0000855c <_ZN13CGPIO_Handler17Set_GPIO_FunctionEj14NGPIO_Function>:
_ZN13CGPIO_Handler17Set_GPIO_FunctionEj14NGPIO_Function():
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:66
		
void CGPIO_Handler::Set_GPIO_Function(uint32_t pin, NGPIO_Function func)
{
    855c:	e92d4800 	push	{fp, lr}
    8560:	e28db004 	add	fp, sp, #4
    8564:	e24dd018 	sub	sp, sp, #24
    8568:	e50b0010 	str	r0, [fp, #-16]
    856c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8570:	e1a03002 	mov	r3, r2
    8574:	e54b3015 	strb	r3, [fp, #-21]	; 0xffffffeb
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:68
	uint32_t reg, bit;
	if (Get_GPFSEL_Location(pin, reg, bit))
    8578:	e24b300c 	sub	r3, fp, #12
    857c:	e24b2008 	sub	r2, fp, #8
    8580:	e51b1014 	ldr	r1, [fp, #-20]	; 0xffffffec
    8584:	e51b0010 	ldr	r0, [fp, #-16]
    8588:	ebffff57 	bl	82ec <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_>
    858c:	e1a03000 	mov	r3, r0
    8590:	e3530000 	cmp	r3, #0
    8594:	1a000015 	bne	85f0 <_ZN13CGPIO_Handler17Set_GPIO_FunctionEj14NGPIO_Function+0x94>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:71
		return;
	
	mGPIO[reg] = (mGPIO[reg] & (~static_cast<unsigned int>(7 << bit)) )
    8598:	e51b3010 	ldr	r3, [fp, #-16]
    859c:	e5932000 	ldr	r2, [r3]
    85a0:	e51b3008 	ldr	r3, [fp, #-8]
    85a4:	e1a03103 	lsl	r3, r3, #2
    85a8:	e0823003 	add	r3, r2, r3
    85ac:	e5932000 	ldr	r2, [r3]
    85b0:	e51b300c 	ldr	r3, [fp, #-12]
    85b4:	e3a01007 	mov	r1, #7
    85b8:	e1a03311 	lsl	r3, r1, r3
    85bc:	e1e03003 	mvn	r3, r3
    85c0:	e0021003 	and	r1, r2, r3
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:72
				| (static_cast<unsigned int>(func) << bit);
    85c4:	e55b2015 	ldrb	r2, [fp, #-21]	; 0xffffffeb
    85c8:	e51b300c 	ldr	r3, [fp, #-12]
    85cc:	e1a02312 	lsl	r2, r2, r3
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:71
	mGPIO[reg] = (mGPIO[reg] & (~static_cast<unsigned int>(7 << bit)) )
    85d0:	e51b3010 	ldr	r3, [fp, #-16]
    85d4:	e5930000 	ldr	r0, [r3]
    85d8:	e51b3008 	ldr	r3, [fp, #-8]
    85dc:	e1a03103 	lsl	r3, r3, #2
    85e0:	e0803003 	add	r3, r0, r3
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:72
				| (static_cast<unsigned int>(func) << bit);
    85e4:	e1812002 	orr	r2, r1, r2
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:71
	mGPIO[reg] = (mGPIO[reg] & (~static_cast<unsigned int>(7 << bit)) )
    85e8:	e5832000 	str	r2, [r3]
    85ec:	ea000000 	b	85f4 <_ZN13CGPIO_Handler17Set_GPIO_FunctionEj14NGPIO_Function+0x98>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:69
		return;
    85f0:	e320f000 	nop	{0}
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:73
}
    85f4:	e24bd004 	sub	sp, fp, #4
    85f8:	e8bd8800 	pop	{fp, pc}

000085fc <_ZNK13CGPIO_Handler17Get_GPIO_FunctionEj>:
_ZNK13CGPIO_Handler17Get_GPIO_FunctionEj():
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:76

NGPIO_Function CGPIO_Handler::Get_GPIO_Function(uint32_t pin) const
{
    85fc:	e92d4800 	push	{fp, lr}
    8600:	e28db004 	add	fp, sp, #4
    8604:	e24dd010 	sub	sp, sp, #16
    8608:	e50b0010 	str	r0, [fp, #-16]
    860c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:78
	uint32_t reg, bit;
	if (Get_GPFSEL_Location(pin, reg, bit))
    8610:	e24b300c 	sub	r3, fp, #12
    8614:	e24b2008 	sub	r2, fp, #8
    8618:	e51b1014 	ldr	r1, [fp, #-20]	; 0xffffffec
    861c:	e51b0010 	ldr	r0, [fp, #-16]
    8620:	ebffff31 	bl	82ec <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_>
    8624:	e1a03000 	mov	r3, r0
    8628:	e3530000 	cmp	r3, #0
    862c:	0a000001 	beq	8638 <_ZNK13CGPIO_Handler17Get_GPIO_FunctionEj+0x3c>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:79
		return NGPIO_Function::Unspecified;
    8630:	e3a03008 	mov	r3, #8
    8634:	ea00000a 	b	8664 <_ZNK13CGPIO_Handler17Get_GPIO_FunctionEj+0x68>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:81
	
	return static_cast<NGPIO_Function>((mGPIO[reg] >> bit) & 7);
    8638:	e51b3010 	ldr	r3, [fp, #-16]
    863c:	e5932000 	ldr	r2, [r3]
    8640:	e51b3008 	ldr	r3, [fp, #-8]
    8644:	e1a03103 	lsl	r3, r3, #2
    8648:	e0823003 	add	r3, r2, r3
    864c:	e5932000 	ldr	r2, [r3]
    8650:	e51b300c 	ldr	r3, [fp, #-12]
    8654:	e1a03332 	lsr	r3, r2, r3
    8658:	e6ef3073 	uxtb	r3, r3
    865c:	e2033007 	and	r3, r3, #7
    8660:	e6ef3073 	uxtb	r3, r3
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:82 (discriminator 1)
}
    8664:	e1a00003 	mov	r0, r3
    8668:	e24bd004 	sub	sp, fp, #4
    866c:	e8bd8800 	pop	{fp, pc}

00008670 <_ZN13CGPIO_Handler10Set_OutputEjb>:
_ZN13CGPIO_Handler10Set_OutputEjb():
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:85

void CGPIO_Handler::Set_Output(uint32_t pin, bool set)
{
    8670:	e92d4800 	push	{fp, lr}
    8674:	e28db004 	add	fp, sp, #4
    8678:	e24dd018 	sub	sp, sp, #24
    867c:	e50b0010 	str	r0, [fp, #-16]
    8680:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8684:	e1a03002 	mov	r3, r2
    8688:	e54b3015 	strb	r3, [fp, #-21]	; 0xffffffeb
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:87
	uint32_t reg, bit;
	if (!(set && Get_GPSET_Location(pin, reg, bit)) && !(!set && Get_GPCLR_Location(pin, reg, bit)))
    868c:	e55b3015 	ldrb	r3, [fp, #-21]	; 0xffffffeb
    8690:	e2233001 	eor	r3, r3, #1
    8694:	e6ef3073 	uxtb	r3, r3
    8698:	e3530000 	cmp	r3, #0
    869c:	1a000009 	bne	86c8 <_ZN13CGPIO_Handler10Set_OutputEjb+0x58>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:87 (discriminator 2)
    86a0:	e24b300c 	sub	r3, fp, #12
    86a4:	e24b2008 	sub	r2, fp, #8
    86a8:	e51b1014 	ldr	r1, [fp, #-20]	; 0xffffffec
    86ac:	e51b0010 	ldr	r0, [fp, #-16]
    86b0:	ebffff6f 	bl	8474 <_ZNK13CGPIO_Handler18Get_GPSET_LocationEjRjS0_>
    86b4:	e1a03000 	mov	r3, r0
    86b8:	e2233001 	eor	r3, r3, #1
    86bc:	e6ef3073 	uxtb	r3, r3
    86c0:	e3530000 	cmp	r3, #0
    86c4:	0a00000e 	beq	8704 <_ZN13CGPIO_Handler10Set_OutputEjb+0x94>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:87 (discriminator 3)
    86c8:	e55b3015 	ldrb	r3, [fp, #-21]	; 0xffffffeb
    86cc:	e3530000 	cmp	r3, #0
    86d0:	1a000009 	bne	86fc <_ZN13CGPIO_Handler10Set_OutputEjb+0x8c>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:87 (discriminator 6)
    86d4:	e24b300c 	sub	r3, fp, #12
    86d8:	e24b2008 	sub	r2, fp, #8
    86dc:	e51b1014 	ldr	r1, [fp, #-20]	; 0xffffffec
    86e0:	e51b0010 	ldr	r0, [fp, #-16]
    86e4:	ebffff45 	bl	8400 <_ZNK13CGPIO_Handler18Get_GPCLR_LocationEjRjS0_>
    86e8:	e1a03000 	mov	r3, r0
    86ec:	e2233001 	eor	r3, r3, #1
    86f0:	e6ef3073 	uxtb	r3, r3
    86f4:	e3530000 	cmp	r3, #0
    86f8:	0a000001 	beq	8704 <_ZN13CGPIO_Handler10Set_OutputEjb+0x94>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:87 (discriminator 7)
    86fc:	e3a03001 	mov	r3, #1
    8700:	ea000000 	b	8708 <_ZN13CGPIO_Handler10Set_OutputEjb+0x98>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:87 (discriminator 8)
    8704:	e3a03000 	mov	r3, #0
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:87 (discriminator 10)
    8708:	e3530000 	cmp	r3, #0
    870c:	1a00000a 	bne	873c <_ZN13CGPIO_Handler10Set_OutputEjb+0xcc>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:90
		return;
	
	mGPIO[reg] = (1 << bit);
    8710:	e51b300c 	ldr	r3, [fp, #-12]
    8714:	e3a02001 	mov	r2, #1
    8718:	e1a01312 	lsl	r1, r2, r3
    871c:	e51b3010 	ldr	r3, [fp, #-16]
    8720:	e5932000 	ldr	r2, [r3]
    8724:	e51b3008 	ldr	r3, [fp, #-8]
    8728:	e1a03103 	lsl	r3, r3, #2
    872c:	e0823003 	add	r3, r2, r3
    8730:	e1a02001 	mov	r2, r1
    8734:	e5832000 	str	r2, [r3]
    8738:	ea000000 	b	8740 <_ZN13CGPIO_Handler10Set_OutputEjb+0xd0>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:88
		return;
    873c:	e320f000 	nop	{0}
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:91
}
    8740:	e24bd004 	sub	sp, fp, #4
    8744:	e8bd8800 	pop	{fp, pc}

00008748 <_Z41__static_initialization_and_destruction_0ii>:
_Z41__static_initialization_and_destruction_0ii():
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:91
    8748:	e92d4800 	push	{fp, lr}
    874c:	e28db004 	add	fp, sp, #4
    8750:	e24dd008 	sub	sp, sp, #8
    8754:	e50b0008 	str	r0, [fp, #-8]
    8758:	e50b100c 	str	r1, [fp, #-12]
    875c:	e51b3008 	ldr	r3, [fp, #-8]
    8760:	e3530001 	cmp	r3, #1
    8764:	1a000006 	bne	8784 <_Z41__static_initialization_and_destruction_0ii+0x3c>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:91 (discriminator 1)
    8768:	e51b300c 	ldr	r3, [fp, #-12]
    876c:	e59f201c 	ldr	r2, [pc, #28]	; 8790 <_Z41__static_initialization_and_destruction_0ii+0x48>
    8770:	e1530002 	cmp	r3, r2
    8774:	1a000002 	bne	8784 <_Z41__static_initialization_and_destruction_0ii+0x3c>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:4
CGPIO_Handler sGPIO(hal::GPIO_Base);
    8778:	e59f1014 	ldr	r1, [pc, #20]	; 8794 <_Z41__static_initialization_and_destruction_0ii+0x4c>
    877c:	e59f0014 	ldr	r0, [pc, #20]	; 8798 <_Z41__static_initialization_and_destruction_0ii+0x50>
    8780:	ebfffecc 	bl	82b8 <_ZN13CGPIO_HandlerC1Ej>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:91
}
    8784:	e320f000 	nop	{0}
    8788:	e24bd004 	sub	sp, fp, #4
    878c:	e8bd8800 	pop	{fp, pc}
    8790:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>
    8794:	20200000 	eorcs	r0, r0, r0
    8798:	000096d4 	ldrdeq	r9, [r0], -r4

0000879c <_GLOBAL__sub_I_sGPIO>:
_GLOBAL__sub_I_sGPIO():
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:91
    879c:	e92d4800 	push	{fp, lr}
    87a0:	e28db004 	add	fp, sp, #4
    87a4:	e59f1008 	ldr	r1, [pc, #8]	; 87b4 <_GLOBAL__sub_I_sGPIO+0x18>
    87a8:	e3a00001 	mov	r0, #1
    87ac:	ebffffe5 	bl	8748 <_Z41__static_initialization_and_destruction_0ii>
    87b0:	e8bd8800 	pop	{fp, pc}
    87b4:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>

000087b8 <_ZN8CMonitorC1Ejjj>:
_ZN8CMonitorC2Ejjj():
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:5
#include <drivers/monitor.h>

CMonitor sMonitor{ 0x30000000, 80, 25 };

CMonitor::CMonitor(unsigned int monitor_base_addr, unsigned int width, unsigned int height)
    87b8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    87bc:	e28db000 	add	fp, sp, #0
    87c0:	e24dd014 	sub	sp, sp, #20
    87c4:	e50b0008 	str	r0, [fp, #-8]
    87c8:	e50b100c 	str	r1, [fp, #-12]
    87cc:	e50b2010 	str	r2, [fp, #-16]
    87d0:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:6
: m_monitor{ reinterpret_cast<unsigned char*>(monitor_base_addr) }
    87d4:	e51b200c 	ldr	r2, [fp, #-12]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:10
, m_width{ width }
, m_height{ height }
, m_cursor{ 0, 0 }
, m_number_base{ DEFAULT_NUMBER_BASE }
    87d8:	e51b3008 	ldr	r3, [fp, #-8]
    87dc:	e5832000 	str	r2, [r3]
    87e0:	e51b3008 	ldr	r3, [fp, #-8]
    87e4:	e51b2010 	ldr	r2, [fp, #-16]
    87e8:	e5832004 	str	r2, [r3, #4]
    87ec:	e51b3008 	ldr	r3, [fp, #-8]
    87f0:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    87f4:	e5832008 	str	r2, [r3, #8]
    87f8:	e51b3008 	ldr	r3, [fp, #-8]
    87fc:	e3a02000 	mov	r2, #0
    8800:	e583200c 	str	r2, [r3, #12]
    8804:	e51b3008 	ldr	r3, [fp, #-8]
    8808:	e3a02000 	mov	r2, #0
    880c:	e5832010 	str	r2, [r3, #16]
    8810:	e51b3008 	ldr	r3, [fp, #-8]
    8814:	e3a0200a 	mov	r2, #10
    8818:	e5832014 	str	r2, [r3, #20]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:12
{
}
    881c:	e51b3008 	ldr	r3, [fp, #-8]
    8820:	e1a00003 	mov	r0, r3
    8824:	e28bd000 	add	sp, fp, #0
    8828:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    882c:	e12fff1e 	bx	lr

00008830 <_ZN8CMonitor5ClearEv>:
_ZN8CMonitor5ClearEv():
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:21
    m_cursor.y = 0;
    m_cursor.y = 0;
}

void CMonitor::Clear()
{
    8830:	e92d4800 	push	{fp, lr}
    8834:	e28db004 	add	fp, sp, #4
    8838:	e24dd010 	sub	sp, sp, #16
    883c:	e50b0010 	str	r0, [fp, #-16]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:22
    Reset_Cursor();
    8840:	e51b0010 	ldr	r0, [fp, #-16]
    8844:	eb00016d 	bl	8e00 <_ZN8CMonitor12Reset_CursorEv>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:24

    for (unsigned int y = 0; y < m_height; ++y)
    8848:	e3a03000 	mov	r3, #0
    884c:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:24 (discriminator 1)
    8850:	e51b3010 	ldr	r3, [fp, #-16]
    8854:	e5933008 	ldr	r3, [r3, #8]
    8858:	e51b2008 	ldr	r2, [fp, #-8]
    885c:	e1520003 	cmp	r2, r3
    8860:	2a000019 	bcs	88cc <_ZN8CMonitor5ClearEv+0x9c>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:26
    {
        for (unsigned int x = 0; x < m_width; ++x)
    8864:	e3a03000 	mov	r3, #0
    8868:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:26 (discriminator 3)
    886c:	e51b3010 	ldr	r3, [fp, #-16]
    8870:	e5933004 	ldr	r3, [r3, #4]
    8874:	e51b200c 	ldr	r2, [fp, #-12]
    8878:	e1520003 	cmp	r2, r3
    887c:	2a00000e 	bcs	88bc <_ZN8CMonitor5ClearEv+0x8c>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:28 (discriminator 2)
        {
            m_monitor[(y * m_width) + x] = ' ';
    8880:	e51b3010 	ldr	r3, [fp, #-16]
    8884:	e5932000 	ldr	r2, [r3]
    8888:	e51b3010 	ldr	r3, [fp, #-16]
    888c:	e5933004 	ldr	r3, [r3, #4]
    8890:	e51b1008 	ldr	r1, [fp, #-8]
    8894:	e0010391 	mul	r1, r1, r3
    8898:	e51b300c 	ldr	r3, [fp, #-12]
    889c:	e0813003 	add	r3, r1, r3
    88a0:	e0823003 	add	r3, r2, r3
    88a4:	e3a02020 	mov	r2, #32
    88a8:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:26 (discriminator 2)
        for (unsigned int x = 0; x < m_width; ++x)
    88ac:	e51b300c 	ldr	r3, [fp, #-12]
    88b0:	e2833001 	add	r3, r3, #1
    88b4:	e50b300c 	str	r3, [fp, #-12]
    88b8:	eaffffeb 	b	886c <_ZN8CMonitor5ClearEv+0x3c>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:24 (discriminator 2)
    for (unsigned int y = 0; y < m_height; ++y)
    88bc:	e51b3008 	ldr	r3, [fp, #-8]
    88c0:	e2833001 	add	r3, r3, #1
    88c4:	e50b3008 	str	r3, [fp, #-8]
    88c8:	eaffffe0 	b	8850 <_ZN8CMonitor5ClearEv+0x20>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:31
        }
    }
}
    88cc:	e320f000 	nop	{0}
    88d0:	e24bd004 	sub	sp, fp, #4
    88d4:	e8bd8800 	pop	{fp, pc}

000088d8 <_ZN8CMonitor6ScrollEv>:
_ZN8CMonitor6ScrollEv():
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:49
        m_cursor.y = m_height - 1;
    }
}

void CMonitor::Scroll()
{
    88d8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    88dc:	e28db000 	add	fp, sp, #0
    88e0:	e24dd01c 	sub	sp, sp, #28
    88e4:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:50
    for (unsigned int y = 1; y < m_height; ++y)
    88e8:	e3a03001 	mov	r3, #1
    88ec:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:50 (discriminator 1)
    88f0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    88f4:	e5933008 	ldr	r3, [r3, #8]
    88f8:	e51b2008 	ldr	r2, [fp, #-8]
    88fc:	e1520003 	cmp	r2, r3
    8900:	2a000024 	bcs	8998 <_ZN8CMonitor6ScrollEv+0xc0>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:52
    {
        for (unsigned int x = 0; x < m_width; ++x)
    8904:	e3a03000 	mov	r3, #0
    8908:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:52 (discriminator 3)
    890c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8910:	e5933004 	ldr	r3, [r3, #4]
    8914:	e51b200c 	ldr	r2, [fp, #-12]
    8918:	e1520003 	cmp	r2, r3
    891c:	2a000019 	bcs	8988 <_ZN8CMonitor6ScrollEv+0xb0>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:54 (discriminator 2)
        {
            m_monitor[((y - 1) * m_width) + x] = m_monitor[(y * m_width) + x];
    8920:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8924:	e5932000 	ldr	r2, [r3]
    8928:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    892c:	e5933004 	ldr	r3, [r3, #4]
    8930:	e51b1008 	ldr	r1, [fp, #-8]
    8934:	e0010391 	mul	r1, r1, r3
    8938:	e51b300c 	ldr	r3, [fp, #-12]
    893c:	e0813003 	add	r3, r1, r3
    8940:	e0822003 	add	r2, r2, r3
    8944:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8948:	e5931000 	ldr	r1, [r3]
    894c:	e51b3008 	ldr	r3, [fp, #-8]
    8950:	e2433001 	sub	r3, r3, #1
    8954:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    8958:	e5900004 	ldr	r0, [r0, #4]
    895c:	e0000390 	mul	r0, r0, r3
    8960:	e51b300c 	ldr	r3, [fp, #-12]
    8964:	e0803003 	add	r3, r0, r3
    8968:	e0813003 	add	r3, r1, r3
    896c:	e5d22000 	ldrb	r2, [r2]
    8970:	e6ef2072 	uxtb	r2, r2
    8974:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:52 (discriminator 2)
        for (unsigned int x = 0; x < m_width; ++x)
    8978:	e51b300c 	ldr	r3, [fp, #-12]
    897c:	e2833001 	add	r3, r3, #1
    8980:	e50b300c 	str	r3, [fp, #-12]
    8984:	eaffffe0 	b	890c <_ZN8CMonitor6ScrollEv+0x34>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:50 (discriminator 2)
    for (unsigned int y = 1; y < m_height; ++y)
    8988:	e51b3008 	ldr	r3, [fp, #-8]
    898c:	e2833001 	add	r3, r3, #1
    8990:	e50b3008 	str	r3, [fp, #-8]
    8994:	eaffffd5 	b	88f0 <_ZN8CMonitor6ScrollEv+0x18>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:58
        }
    }

    for (unsigned int x = 0; x < m_width; ++x)
    8998:	e3a03000 	mov	r3, #0
    899c:	e50b3010 	str	r3, [fp, #-16]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:58 (discriminator 3)
    89a0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    89a4:	e5933004 	ldr	r3, [r3, #4]
    89a8:	e51b2010 	ldr	r2, [fp, #-16]
    89ac:	e1520003 	cmp	r2, r3
    89b0:	2a000010 	bcs	89f8 <_ZN8CMonitor6ScrollEv+0x120>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:60 (discriminator 2)
    {
        m_monitor[((m_height - 1) * m_width) + x] = ' ';
    89b4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    89b8:	e5932000 	ldr	r2, [r3]
    89bc:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    89c0:	e5933008 	ldr	r3, [r3, #8]
    89c4:	e2433001 	sub	r3, r3, #1
    89c8:	e51b1018 	ldr	r1, [fp, #-24]	; 0xffffffe8
    89cc:	e5911004 	ldr	r1, [r1, #4]
    89d0:	e0010391 	mul	r1, r1, r3
    89d4:	e51b3010 	ldr	r3, [fp, #-16]
    89d8:	e0813003 	add	r3, r1, r3
    89dc:	e0823003 	add	r3, r2, r3
    89e0:	e3a02020 	mov	r2, #32
    89e4:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:58 (discriminator 2)
    for (unsigned int x = 0; x < m_width; ++x)
    89e8:	e51b3010 	ldr	r3, [fp, #-16]
    89ec:	e2833001 	add	r3, r3, #1
    89f0:	e50b3010 	str	r3, [fp, #-16]
    89f4:	eaffffe9 	b	89a0 <_ZN8CMonitor6ScrollEv+0xc8>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:62
    }
}
    89f8:	e320f000 	nop	{0}
    89fc:	e28bd000 	add	sp, fp, #0
    8a00:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8a04:	e12fff1e 	bx	lr

00008a08 <_ZN8CMonitorlsEc>:
_ZN8CMonitorlsEc():
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:70
{
    m_number_base = DEFAULT_NUMBER_BASE;
}

CMonitor& CMonitor::operator<<(char c)
{
    8a08:	e92d4800 	push	{fp, lr}
    8a0c:	e28db004 	add	fp, sp, #4
    8a10:	e24dd008 	sub	sp, sp, #8
    8a14:	e50b0008 	str	r0, [fp, #-8]
    8a18:	e1a03001 	mov	r3, r1
    8a1c:	e54b3009 	strb	r3, [fp, #-9]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:71
    if (c != '\n')
    8a20:	e55b3009 	ldrb	r3, [fp, #-9]
    8a24:	e353000a 	cmp	r3, #10
    8a28:	0a000012 	beq	8a78 <_ZN8CMonitorlsEc+0x70>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:73
    {
        m_monitor[(m_cursor.y * m_width) + m_cursor.x] = static_cast<unsigned char>(c);
    8a2c:	e51b3008 	ldr	r3, [fp, #-8]
    8a30:	e5932000 	ldr	r2, [r3]
    8a34:	e51b3008 	ldr	r3, [fp, #-8]
    8a38:	e593300c 	ldr	r3, [r3, #12]
    8a3c:	e51b1008 	ldr	r1, [fp, #-8]
    8a40:	e5911004 	ldr	r1, [r1, #4]
    8a44:	e0010391 	mul	r1, r1, r3
    8a48:	e51b3008 	ldr	r3, [fp, #-8]
    8a4c:	e5933010 	ldr	r3, [r3, #16]
    8a50:	e0813003 	add	r3, r1, r3
    8a54:	e0823003 	add	r3, r2, r3
    8a58:	e55b2009 	ldrb	r2, [fp, #-9]
    8a5c:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:74
        ++m_cursor.x;
    8a60:	e51b3008 	ldr	r3, [fp, #-8]
    8a64:	e5933010 	ldr	r3, [r3, #16]
    8a68:	e2832001 	add	r2, r3, #1
    8a6c:	e51b3008 	ldr	r3, [fp, #-8]
    8a70:	e5832010 	str	r2, [r3, #16]
    8a74:	ea000007 	b	8a98 <_ZN8CMonitorlsEc+0x90>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:78
    }
    else
    {
        m_cursor.x = 0;
    8a78:	e51b3008 	ldr	r3, [fp, #-8]
    8a7c:	e3a02000 	mov	r2, #0
    8a80:	e5832010 	str	r2, [r3, #16]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:79
        ++m_cursor.y;
    8a84:	e51b3008 	ldr	r3, [fp, #-8]
    8a88:	e593300c 	ldr	r3, [r3, #12]
    8a8c:	e2832001 	add	r2, r3, #1
    8a90:	e51b3008 	ldr	r3, [fp, #-8]
    8a94:	e583200c 	str	r2, [r3, #12]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:82
    }

    Adjust_Cursor();
    8a98:	e51b0008 	ldr	r0, [fp, #-8]
    8a9c:	eb0000e5 	bl	8e38 <_ZN8CMonitor13Adjust_CursorEv>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:84

    return *this;
    8aa0:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:85
}
    8aa4:	e1a00003 	mov	r0, r3
    8aa8:	e24bd004 	sub	sp, fp, #4
    8aac:	e8bd8800 	pop	{fp, pc}

00008ab0 <_ZN8CMonitorlsEPKc>:
_ZN8CMonitorlsEPKc():
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:88

CMonitor& CMonitor::operator<<(const char* str)
{
    8ab0:	e92d4800 	push	{fp, lr}
    8ab4:	e28db004 	add	fp, sp, #4
    8ab8:	e24dd010 	sub	sp, sp, #16
    8abc:	e50b0010 	str	r0, [fp, #-16]
    8ac0:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:89
    for (unsigned int i = 0; str[i] != '\0'; ++i)
    8ac4:	e3a03000 	mov	r3, #0
    8ac8:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:89 (discriminator 3)
    8acc:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8ad0:	e51b3008 	ldr	r3, [fp, #-8]
    8ad4:	e0823003 	add	r3, r2, r3
    8ad8:	e5d33000 	ldrb	r3, [r3]
    8adc:	e3530000 	cmp	r3, #0
    8ae0:	0a00000a 	beq	8b10 <_ZN8CMonitorlsEPKc+0x60>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:91 (discriminator 2)
    {
        *this << str[i];
    8ae4:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8ae8:	e51b3008 	ldr	r3, [fp, #-8]
    8aec:	e0823003 	add	r3, r2, r3
    8af0:	e5d33000 	ldrb	r3, [r3]
    8af4:	e1a01003 	mov	r1, r3
    8af8:	e51b0010 	ldr	r0, [fp, #-16]
    8afc:	ebffffc1 	bl	8a08 <_ZN8CMonitorlsEc>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:89 (discriminator 2)
    for (unsigned int i = 0; str[i] != '\0'; ++i)
    8b00:	e51b3008 	ldr	r3, [fp, #-8]
    8b04:	e2833001 	add	r3, r3, #1
    8b08:	e50b3008 	str	r3, [fp, #-8]
    8b0c:	eaffffee 	b	8acc <_ZN8CMonitorlsEPKc+0x1c>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:94
    }

    Reset_Number_Base();
    8b10:	e51b0010 	ldr	r0, [fp, #-16]
    8b14:	eb0000e9 	bl	8ec0 <_ZN8CMonitor17Reset_Number_BaseEv>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:96

    return *this;
    8b18:	e51b3010 	ldr	r3, [fp, #-16]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:97
}
    8b1c:	e1a00003 	mov	r0, r3
    8b20:	e24bd004 	sub	sp, fp, #4
    8b24:	e8bd8800 	pop	{fp, pc}

00008b28 <_ZN8CMonitorlsENS_12NNumber_BaseE>:
_ZN8CMonitorlsENS_12NNumber_BaseE():
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:100

CMonitor& CMonitor::operator<<(CMonitor::NNumber_Base number_base)
{
    8b28:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8b2c:	e28db000 	add	fp, sp, #0
    8b30:	e24dd00c 	sub	sp, sp, #12
    8b34:	e50b0008 	str	r0, [fp, #-8]
    8b38:	e50b100c 	str	r1, [fp, #-12]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:101
    m_number_base = number_base;
    8b3c:	e51b3008 	ldr	r3, [fp, #-8]
    8b40:	e51b200c 	ldr	r2, [fp, #-12]
    8b44:	e5832014 	str	r2, [r3, #20]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:103

    return *this;
    8b48:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:104
}
    8b4c:	e1a00003 	mov	r0, r3
    8b50:	e28bd000 	add	sp, fp, #0
    8b54:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8b58:	e12fff1e 	bx	lr

00008b5c <_ZN8CMonitorlsEj>:
_ZN8CMonitorlsEj():
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:107

CMonitor& CMonitor::operator<<(unsigned int num)
{
    8b5c:	e92d4800 	push	{fp, lr}
    8b60:	e28db004 	add	fp, sp, #4
    8b64:	e24dd008 	sub	sp, sp, #8
    8b68:	e50b0008 	str	r0, [fp, #-8]
    8b6c:	e50b100c 	str	r1, [fp, #-12]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:112
    static constexpr unsigned int BUFFER_SIZE = 16;

    static char s_buffer[BUFFER_SIZE];

    itoa(num, s_buffer, static_cast<unsigned int>(m_number_base));
    8b70:	e51b3008 	ldr	r3, [fp, #-8]
    8b74:	e5933014 	ldr	r3, [r3, #20]
    8b78:	e59f202c 	ldr	r2, [pc, #44]	; 8bac <_ZN8CMonitorlsEj+0x50>
    8b7c:	e51b100c 	ldr	r1, [fp, #-12]
    8b80:	e51b0008 	ldr	r0, [fp, #-8]
    8b84:	eb000021 	bl	8c10 <_ZN8CMonitor4itoaEjPcj>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:113
    *this << s_buffer;
    8b88:	e59f101c 	ldr	r1, [pc, #28]	; 8bac <_ZN8CMonitorlsEj+0x50>
    8b8c:	e51b0008 	ldr	r0, [fp, #-8]
    8b90:	ebffffc6 	bl	8ab0 <_ZN8CMonitorlsEPKc>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:114
    Reset_Number_Base();
    8b94:	e51b0008 	ldr	r0, [fp, #-8]
    8b98:	eb0000c8 	bl	8ec0 <_ZN8CMonitor17Reset_Number_BaseEv>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:116

    return *this;
    8b9c:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:117
}
    8ba0:	e1a00003 	mov	r0, r3
    8ba4:	e24bd004 	sub	sp, fp, #4
    8ba8:	e8bd8800 	pop	{fp, pc}
    8bac:	000096f0 	strdeq	r9, [r0], -r0

00008bb0 <_ZN8CMonitorlsEb>:
_ZN8CMonitorlsEb():
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:120

CMonitor& CMonitor::operator<<(bool value)
{
    8bb0:	e92d4800 	push	{fp, lr}
    8bb4:	e28db004 	add	fp, sp, #4
    8bb8:	e24dd008 	sub	sp, sp, #8
    8bbc:	e50b0008 	str	r0, [fp, #-8]
    8bc0:	e1a03001 	mov	r3, r1
    8bc4:	e54b3009 	strb	r3, [fp, #-9]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:121
    if (value)
    8bc8:	e55b3009 	ldrb	r3, [fp, #-9]
    8bcc:	e3530000 	cmp	r3, #0
    8bd0:	0a000003 	beq	8be4 <_ZN8CMonitorlsEb+0x34>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:123
    {
        *this << "true";
    8bd4:	e59f102c 	ldr	r1, [pc, #44]	; 8c08 <_ZN8CMonitorlsEb+0x58>
    8bd8:	e51b0008 	ldr	r0, [fp, #-8]
    8bdc:	ebffffb3 	bl	8ab0 <_ZN8CMonitorlsEPKc>
    8be0:	ea000002 	b	8bf0 <_ZN8CMonitorlsEb+0x40>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:127
    }
    else
    {
        *this << "false";
    8be4:	e59f1020 	ldr	r1, [pc, #32]	; 8c0c <_ZN8CMonitorlsEb+0x5c>
    8be8:	e51b0008 	ldr	r0, [fp, #-8]
    8bec:	ebffffaf 	bl	8ab0 <_ZN8CMonitorlsEPKc>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:130
    }

    Reset_Number_Base();
    8bf0:	e51b0008 	ldr	r0, [fp, #-8]
    8bf4:	eb0000b1 	bl	8ec0 <_ZN8CMonitor17Reset_Number_BaseEv>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:132

    return *this;
    8bf8:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:133
}
    8bfc:	e1a00003 	mov	r0, r3
    8c00:	e24bd004 	sub	sp, fp, #4
    8c04:	e8bd8800 	pop	{fp, pc}
    8c08:	00009654 	andeq	r9, r0, r4, asr r6
    8c0c:	0000965c 	andeq	r9, r0, ip, asr r6

00008c10 <_ZN8CMonitor4itoaEjPcj>:
_ZN8CMonitor4itoaEjPcj():
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:136

void CMonitor::itoa(unsigned int input, char* output, unsigned int base)
{
    8c10:	e92d4800 	push	{fp, lr}
    8c14:	e28db004 	add	fp, sp, #4
    8c18:	e24dd020 	sub	sp, sp, #32
    8c1c:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8c20:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    8c24:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    8c28:	e50b3024 	str	r3, [fp, #-36]	; 0xffffffdc
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:137
    int i = 0;
    8c2c:	e3a03000 	mov	r3, #0
    8c30:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:139

    while (input > 0)
    8c34:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8c38:	e3530000 	cmp	r3, #0
    8c3c:	0a000015 	beq	8c98 <_ZN8CMonitor4itoaEjPcj+0x88>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:141
    {
        output[i] = CharConvArr[input % base];
    8c40:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8c44:	e51b1024 	ldr	r1, [fp, #-36]	; 0xffffffdc
    8c48:	e1a00003 	mov	r0, r3
    8c4c:	eb00023e 	bl	954c <__aeabi_uidivmod>
    8c50:	e1a03001 	mov	r3, r1
    8c54:	e1a02003 	mov	r2, r3
    8c58:	e59f3128 	ldr	r3, [pc, #296]	; 8d88 <_ZN8CMonitor4itoaEjPcj+0x178>
    8c5c:	e0822003 	add	r2, r2, r3
    8c60:	e51b3008 	ldr	r3, [fp, #-8]
    8c64:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    8c68:	e0813003 	add	r3, r1, r3
    8c6c:	e5d22000 	ldrb	r2, [r2]
    8c70:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:142
        input /= base;
    8c74:	e51b1024 	ldr	r1, [fp, #-36]	; 0xffffffdc
    8c78:	e51b001c 	ldr	r0, [fp, #-28]	; 0xffffffe4
    8c7c:	eb0001b7 	bl	9360 <__udivsi3>
    8c80:	e1a03000 	mov	r3, r0
    8c84:	e50b301c 	str	r3, [fp, #-28]	; 0xffffffe4
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:144

        i++;
    8c88:	e51b3008 	ldr	r3, [fp, #-8]
    8c8c:	e2833001 	add	r3, r3, #1
    8c90:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:139
    while (input > 0)
    8c94:	eaffffe6 	b	8c34 <_ZN8CMonitor4itoaEjPcj+0x24>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:147
    }

    if (i == 0)
    8c98:	e51b3008 	ldr	r3, [fp, #-8]
    8c9c:	e3530000 	cmp	r3, #0
    8ca0:	1a000007 	bne	8cc4 <_ZN8CMonitor4itoaEjPcj+0xb4>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:149
    {
        output[i] = CharConvArr[0];
    8ca4:	e51b3008 	ldr	r3, [fp, #-8]
    8ca8:	e51b2020 	ldr	r2, [fp, #-32]	; 0xffffffe0
    8cac:	e0823003 	add	r3, r2, r3
    8cb0:	e3a02030 	mov	r2, #48	; 0x30
    8cb4:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:150
        i++;
    8cb8:	e51b3008 	ldr	r3, [fp, #-8]
    8cbc:	e2833001 	add	r3, r3, #1
    8cc0:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:153
    }

    output[i] = '\0';
    8cc4:	e51b3008 	ldr	r3, [fp, #-8]
    8cc8:	e51b2020 	ldr	r2, [fp, #-32]	; 0xffffffe0
    8ccc:	e0823003 	add	r3, r2, r3
    8cd0:	e3a02000 	mov	r2, #0
    8cd4:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:154
    i--;
    8cd8:	e51b3008 	ldr	r3, [fp, #-8]
    8cdc:	e2433001 	sub	r3, r3, #1
    8ce0:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:156

    for (int j = 0; j <= (i / 2); j++)
    8ce4:	e3a03000 	mov	r3, #0
    8ce8:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:156 (discriminator 3)
    8cec:	e51b3008 	ldr	r3, [fp, #-8]
    8cf0:	e1a02fa3 	lsr	r2, r3, #31
    8cf4:	e0823003 	add	r3, r2, r3
    8cf8:	e1a030c3 	asr	r3, r3, #1
    8cfc:	e1a02003 	mov	r2, r3
    8d00:	e51b300c 	ldr	r3, [fp, #-12]
    8d04:	e1530002 	cmp	r3, r2
    8d08:	ca00001b 	bgt	8d7c <_ZN8CMonitor4itoaEjPcj+0x16c>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:158 (discriminator 2)
    {
        char c = output[i - j];
    8d0c:	e51b2008 	ldr	r2, [fp, #-8]
    8d10:	e51b300c 	ldr	r3, [fp, #-12]
    8d14:	e0423003 	sub	r3, r2, r3
    8d18:	e1a02003 	mov	r2, r3
    8d1c:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8d20:	e0833002 	add	r3, r3, r2
    8d24:	e5d33000 	ldrb	r3, [r3]
    8d28:	e54b300d 	strb	r3, [fp, #-13]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:159 (discriminator 2)
        output[i - j] = output[j];
    8d2c:	e51b300c 	ldr	r3, [fp, #-12]
    8d30:	e51b2020 	ldr	r2, [fp, #-32]	; 0xffffffe0
    8d34:	e0822003 	add	r2, r2, r3
    8d38:	e51b1008 	ldr	r1, [fp, #-8]
    8d3c:	e51b300c 	ldr	r3, [fp, #-12]
    8d40:	e0413003 	sub	r3, r1, r3
    8d44:	e1a01003 	mov	r1, r3
    8d48:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8d4c:	e0833001 	add	r3, r3, r1
    8d50:	e5d22000 	ldrb	r2, [r2]
    8d54:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:160 (discriminator 2)
        output[j] = c;
    8d58:	e51b300c 	ldr	r3, [fp, #-12]
    8d5c:	e51b2020 	ldr	r2, [fp, #-32]	; 0xffffffe0
    8d60:	e0823003 	add	r3, r2, r3
    8d64:	e55b200d 	ldrb	r2, [fp, #-13]
    8d68:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:156 (discriminator 2)
    for (int j = 0; j <= (i / 2); j++)
    8d6c:	e51b300c 	ldr	r3, [fp, #-12]
    8d70:	e2833001 	add	r3, r3, #1
    8d74:	e50b300c 	str	r3, [fp, #-12]
    8d78:	eaffffdb 	b	8cec <_ZN8CMonitor4itoaEjPcj+0xdc>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:162
    }
}
    8d7c:	e320f000 	nop	{0}
    8d80:	e24bd004 	sub	sp, fp, #4
    8d84:	e8bd8800 	pop	{fp, pc}
    8d88:	00009664 	andeq	r9, r0, r4, ror #12

00008d8c <_Z41__static_initialization_and_destruction_0ii>:
_Z41__static_initialization_and_destruction_0ii():
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:162
    8d8c:	e92d4800 	push	{fp, lr}
    8d90:	e28db004 	add	fp, sp, #4
    8d94:	e24dd008 	sub	sp, sp, #8
    8d98:	e50b0008 	str	r0, [fp, #-8]
    8d9c:	e50b100c 	str	r1, [fp, #-12]
    8da0:	e51b3008 	ldr	r3, [fp, #-8]
    8da4:	e3530001 	cmp	r3, #1
    8da8:	1a000008 	bne	8dd0 <_Z41__static_initialization_and_destruction_0ii+0x44>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:162 (discriminator 1)
    8dac:	e51b300c 	ldr	r3, [fp, #-12]
    8db0:	e59f2024 	ldr	r2, [pc, #36]	; 8ddc <_Z41__static_initialization_and_destruction_0ii+0x50>
    8db4:	e1530002 	cmp	r3, r2
    8db8:	1a000004 	bne	8dd0 <_Z41__static_initialization_and_destruction_0ii+0x44>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:3
CMonitor sMonitor{ 0x30000000, 80, 25 };
    8dbc:	e3a03019 	mov	r3, #25
    8dc0:	e3a02050 	mov	r2, #80	; 0x50
    8dc4:	e3a01203 	mov	r1, #805306368	; 0x30000000
    8dc8:	e59f0010 	ldr	r0, [pc, #16]	; 8de0 <_Z41__static_initialization_and_destruction_0ii+0x54>
    8dcc:	ebfffe79 	bl	87b8 <_ZN8CMonitorC1Ejjj>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:162
}
    8dd0:	e320f000 	nop	{0}
    8dd4:	e24bd004 	sub	sp, fp, #4
    8dd8:	e8bd8800 	pop	{fp, pc}
    8ddc:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>
    8de0:	000096d8 	ldrdeq	r9, [r0], -r8

00008de4 <_GLOBAL__sub_I_sMonitor>:
_GLOBAL__sub_I_sMonitor():
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:162
    8de4:	e92d4800 	push	{fp, lr}
    8de8:	e28db004 	add	fp, sp, #4
    8dec:	e59f1008 	ldr	r1, [pc, #8]	; 8dfc <_GLOBAL__sub_I_sMonitor+0x18>
    8df0:	e3a00001 	mov	r0, #1
    8df4:	ebffffe4 	bl	8d8c <_Z41__static_initialization_and_destruction_0ii>
    8df8:	e8bd8800 	pop	{fp, pc}
    8dfc:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>

00008e00 <_ZN8CMonitor12Reset_CursorEv>:
_ZN8CMonitor12Reset_CursorEv():
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:15
{
    8e00:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8e04:	e28db000 	add	fp, sp, #0
    8e08:	e24dd00c 	sub	sp, sp, #12
    8e0c:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:16
    m_cursor.y = 0;
    8e10:	e51b3008 	ldr	r3, [fp, #-8]
    8e14:	e3a02000 	mov	r2, #0
    8e18:	e583200c 	str	r2, [r3, #12]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:17
    m_cursor.y = 0;
    8e1c:	e51b3008 	ldr	r3, [fp, #-8]
    8e20:	e3a02000 	mov	r2, #0
    8e24:	e583200c 	str	r2, [r3, #12]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:18
}
    8e28:	e320f000 	nop	{0}
    8e2c:	e28bd000 	add	sp, fp, #0
    8e30:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8e34:	e12fff1e 	bx	lr

00008e38 <_ZN8CMonitor13Adjust_CursorEv>:
_ZN8CMonitor13Adjust_CursorEv():
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:34
{
    8e38:	e92d4800 	push	{fp, lr}
    8e3c:	e28db004 	add	fp, sp, #4
    8e40:	e24dd008 	sub	sp, sp, #8
    8e44:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:35
    if (m_cursor.x >= m_width)
    8e48:	e51b3008 	ldr	r3, [fp, #-8]
    8e4c:	e5932010 	ldr	r2, [r3, #16]
    8e50:	e51b3008 	ldr	r3, [fp, #-8]
    8e54:	e5933004 	ldr	r3, [r3, #4]
    8e58:	e1520003 	cmp	r2, r3
    8e5c:	3a000007 	bcc	8e80 <_ZN8CMonitor13Adjust_CursorEv+0x48>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:37
        m_cursor.x = 0;
    8e60:	e51b3008 	ldr	r3, [fp, #-8]
    8e64:	e3a02000 	mov	r2, #0
    8e68:	e5832010 	str	r2, [r3, #16]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:38
        ++m_cursor.y;
    8e6c:	e51b3008 	ldr	r3, [fp, #-8]
    8e70:	e593300c 	ldr	r3, [r3, #12]
    8e74:	e2832001 	add	r2, r3, #1
    8e78:	e51b3008 	ldr	r3, [fp, #-8]
    8e7c:	e583200c 	str	r2, [r3, #12]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:41
    if (m_cursor.y >= m_height)
    8e80:	e51b3008 	ldr	r3, [fp, #-8]
    8e84:	e593200c 	ldr	r2, [r3, #12]
    8e88:	e51b3008 	ldr	r3, [fp, #-8]
    8e8c:	e5933008 	ldr	r3, [r3, #8]
    8e90:	e1520003 	cmp	r2, r3
    8e94:	3a000006 	bcc	8eb4 <_ZN8CMonitor13Adjust_CursorEv+0x7c>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:43
        Scroll();
    8e98:	e51b0008 	ldr	r0, [fp, #-8]
    8e9c:	ebfffe8d 	bl	88d8 <_ZN8CMonitor6ScrollEv>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:44
        m_cursor.y = m_height - 1;
    8ea0:	e51b3008 	ldr	r3, [fp, #-8]
    8ea4:	e5933008 	ldr	r3, [r3, #8]
    8ea8:	e2432001 	sub	r2, r3, #1
    8eac:	e51b3008 	ldr	r3, [fp, #-8]
    8eb0:	e583200c 	str	r2, [r3, #12]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:46
}
    8eb4:	e320f000 	nop	{0}
    8eb8:	e24bd004 	sub	sp, fp, #4
    8ebc:	e8bd8800 	pop	{fp, pc}

00008ec0 <_ZN8CMonitor17Reset_Number_BaseEv>:
_ZN8CMonitor17Reset_Number_BaseEv():
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:65
{
    8ec0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8ec4:	e28db000 	add	fp, sp, #0
    8ec8:	e24dd00c 	sub	sp, sp, #12
    8ecc:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:66
    m_number_base = DEFAULT_NUMBER_BASE;
    8ed0:	e51b3008 	ldr	r3, [fp, #-8]
    8ed4:	e3a0200a 	mov	r2, #10
    8ed8:	e5832014 	str	r2, [r3, #20]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/monitor.cpp:67
}
    8edc:	e320f000 	nop	{0}
    8ee0:	e28bd000 	add	sp, fp, #0
    8ee4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8ee8:	e12fff1e 	bx	lr

00008eec <_ZN5CUARTC1ER4CAUX>:
_ZN5CUARTC2ER4CAUX():
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/uart.cpp:7
#include <drivers/bcm_aux.h>
#include <drivers/monitor.h>

CUART sUART0(sAUX);

CUART::CUART(CAUX& aux)
    8eec:	e92d4800 	push	{fp, lr}
    8ef0:	e28db004 	add	fp, sp, #4
    8ef4:	e24dd008 	sub	sp, sp, #8
    8ef8:	e50b0008 	str	r0, [fp, #-8]
    8efc:	e50b100c 	str	r1, [fp, #-12]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/uart.cpp:8
    : mAUX(aux)
    8f00:	e51b3008 	ldr	r3, [fp, #-8]
    8f04:	e51b200c 	ldr	r2, [fp, #-12]
    8f08:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/uart.cpp:10
{
    mAUX.Enable(hal::AUX_Peripherals::MiniUART);
    8f0c:	e51b3008 	ldr	r3, [fp, #-8]
    8f10:	e5933000 	ldr	r3, [r3]
    8f14:	e3a01000 	mov	r1, #0
    8f18:	e1a00003 	mov	r0, r3
    8f1c:	ebfffc80 	bl	8124 <_ZN4CAUX6EnableEN3hal15AUX_PeripheralsE>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/uart.cpp:12
    //mAUX.Set_Register(hal::AUX_Reg::ENABLES, mAUX.Get_Register(hal::AUX_Reg::ENABLES) | 0x01);
    mAUX.Set_Register(hal::AUX_Reg::MU_IIR, 0);
    8f20:	e51b3008 	ldr	r3, [fp, #-8]
    8f24:	e5933000 	ldr	r3, [r3]
    8f28:	e3a02000 	mov	r2, #0
    8f2c:	e3a01012 	mov	r1, #18
    8f30:	e1a00003 	mov	r0, r3
    8f34:	ebfffca3 	bl	81c8 <_ZN4CAUX12Set_RegisterEN3hal7AUX_RegEj>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/uart.cpp:13
    mAUX.Set_Register(hal::AUX_Reg::MU_IER, 0);
    8f38:	e51b3008 	ldr	r3, [fp, #-8]
    8f3c:	e5933000 	ldr	r3, [r3]
    8f40:	e3a02000 	mov	r2, #0
    8f44:	e3a01011 	mov	r1, #17
    8f48:	e1a00003 	mov	r0, r3
    8f4c:	ebfffc9d 	bl	81c8 <_ZN4CAUX12Set_RegisterEN3hal7AUX_RegEj>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/uart.cpp:14
    mAUX.Set_Register(hal::AUX_Reg::MU_MCR, 0);
    8f50:	e51b3008 	ldr	r3, [fp, #-8]
    8f54:	e5933000 	ldr	r3, [r3]
    8f58:	e3a02000 	mov	r2, #0
    8f5c:	e3a01014 	mov	r1, #20
    8f60:	e1a00003 	mov	r0, r3
    8f64:	ebfffc97 	bl	81c8 <_ZN4CAUX12Set_RegisterEN3hal7AUX_RegEj>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/uart.cpp:15
    mAUX.Set_Register(hal::AUX_Reg::MU_CNTL, 3); // RX and TX enabled
    8f68:	e51b3008 	ldr	r3, [fp, #-8]
    8f6c:	e5933000 	ldr	r3, [r3]
    8f70:	e3a02003 	mov	r2, #3
    8f74:	e3a01018 	mov	r1, #24
    8f78:	e1a00003 	mov	r0, r3
    8f7c:	ebfffc91 	bl	81c8 <_ZN4CAUX12Set_RegisterEN3hal7AUX_RegEj>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/uart.cpp:16
}
    8f80:	e51b3008 	ldr	r3, [fp, #-8]
    8f84:	e1a00003 	mov	r0, r3
    8f88:	e24bd004 	sub	sp, fp, #4
    8f8c:	e8bd8800 	pop	{fp, pc}

00008f90 <_ZN5CUART15Set_Char_LengthE17NUART_Char_Length>:
_ZN5CUART15Set_Char_LengthE17NUART_Char_Length():
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/uart.cpp:19

void CUART::Set_Char_Length(NUART_Char_Length len)
{
    8f90:	e92d4810 	push	{r4, fp, lr}
    8f94:	e28db008 	add	fp, sp, #8
    8f98:	e24dd00c 	sub	sp, sp, #12
    8f9c:	e50b0010 	str	r0, [fp, #-16]
    8fa0:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/uart.cpp:20
    mAUX.Set_Register(hal::AUX_Reg::MU_LCR, (mAUX.Get_Register(hal::AUX_Reg::MU_LCR) & 0xFFFFFFFE) | static_cast<unsigned int>(len));
    8fa4:	e51b3010 	ldr	r3, [fp, #-16]
    8fa8:	e5934000 	ldr	r4, [r3]
    8fac:	e51b3010 	ldr	r3, [fp, #-16]
    8fb0:	e5933000 	ldr	r3, [r3]
    8fb4:	e3a01013 	mov	r1, #19
    8fb8:	e1a00003 	mov	r0, r3
    8fbc:	ebfffc92 	bl	820c <_ZN4CAUX12Get_RegisterEN3hal7AUX_RegE>
    8fc0:	e1a03000 	mov	r3, r0
    8fc4:	e3c32001 	bic	r2, r3, #1
    8fc8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8fcc:	e1823003 	orr	r3, r2, r3
    8fd0:	e1a02003 	mov	r2, r3
    8fd4:	e3a01013 	mov	r1, #19
    8fd8:	e1a00004 	mov	r0, r4
    8fdc:	ebfffc79 	bl	81c8 <_ZN4CAUX12Set_RegisterEN3hal7AUX_RegEj>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/uart.cpp:21
}
    8fe0:	e320f000 	nop	{0}
    8fe4:	e24bd008 	sub	sp, fp, #8
    8fe8:	e8bd8810 	pop	{r4, fp, pc}

00008fec <_ZN5CUART13Set_Baud_RateE15NUART_Baud_Rate>:
_ZN5CUART13Set_Baud_RateE15NUART_Baud_Rate():
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/uart.cpp:24

void CUART::Set_Baud_Rate(NUART_Baud_Rate rate)
{
    8fec:	e92d4800 	push	{fp, lr}
    8ff0:	e28db004 	add	fp, sp, #4
    8ff4:	e24dd010 	sub	sp, sp, #16
    8ff8:	e50b0010 	str	r0, [fp, #-16]
    8ffc:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/uart.cpp:25
    constexpr unsigned int Clock_Rate = 250000000; // taktovaci frekvence hlavniho jadra
    9000:	e59f3070 	ldr	r3, [pc, #112]	; 9078 <_ZN5CUART13Set_Baud_RateE15NUART_Baud_Rate+0x8c>
    9004:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/uart.cpp:26
    const unsigned int val = ((Clock_Rate / static_cast<unsigned int>(rate)) / 8) - 1;
    9008:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    900c:	e1a01003 	mov	r1, r3
    9010:	e59f0064 	ldr	r0, [pc, #100]	; 907c <_ZN5CUART13Set_Baud_RateE15NUART_Baud_Rate+0x90>
    9014:	eb0000d1 	bl	9360 <__udivsi3>
    9018:	e1a03000 	mov	r3, r0
    901c:	e2433001 	sub	r3, r3, #1
    9020:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/uart.cpp:28

    mAUX.Set_Register(hal::AUX_Reg::MU_CNTL, 0);
    9024:	e51b3010 	ldr	r3, [fp, #-16]
    9028:	e5933000 	ldr	r3, [r3]
    902c:	e3a02000 	mov	r2, #0
    9030:	e3a01018 	mov	r1, #24
    9034:	e1a00003 	mov	r0, r3
    9038:	ebfffc62 	bl	81c8 <_ZN4CAUX12Set_RegisterEN3hal7AUX_RegEj>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/uart.cpp:30

    mAUX.Set_Register(hal::AUX_Reg::MU_BAUD, val);
    903c:	e51b3010 	ldr	r3, [fp, #-16]
    9040:	e5933000 	ldr	r3, [r3]
    9044:	e51b200c 	ldr	r2, [fp, #-12]
    9048:	e3a0101a 	mov	r1, #26
    904c:	e1a00003 	mov	r0, r3
    9050:	ebfffc5c 	bl	81c8 <_ZN4CAUX12Set_RegisterEN3hal7AUX_RegEj>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/uart.cpp:32

    mAUX.Set_Register(hal::AUX_Reg::MU_CNTL, 3);
    9054:	e51b3010 	ldr	r3, [fp, #-16]
    9058:	e5933000 	ldr	r3, [r3]
    905c:	e3a02003 	mov	r2, #3
    9060:	e3a01018 	mov	r1, #24
    9064:	e1a00003 	mov	r0, r3
    9068:	ebfffc56 	bl	81c8 <_ZN4CAUX12Set_RegisterEN3hal7AUX_RegEj>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/uart.cpp:33
}
    906c:	e320f000 	nop	{0}
    9070:	e24bd004 	sub	sp, fp, #4
    9074:	e8bd8800 	pop	{fp, pc}
    9078:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}
    907c:	01dcd650 	bicseq	sp, ip, r0, asr r6

00009080 <_ZN5CUART5WriteEc>:
_ZN5CUART5WriteEc():
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/uart.cpp:36

void CUART::Write(char c)
{
    9080:	e92d4800 	push	{fp, lr}
    9084:	e28db004 	add	fp, sp, #4
    9088:	e24dd010 	sub	sp, sp, #16
    908c:	e50b0010 	str	r0, [fp, #-16]
    9090:	e1a03001 	mov	r3, r1
    9094:	e54b3011 	strb	r3, [fp, #-17]	; 0xffffffef
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/uart.cpp:37
    unsigned int value = (mAUX.Get_Register(hal::AUX_Reg::MU_LSR) & (1 << 5));
    9098:	e51b3010 	ldr	r3, [fp, #-16]
    909c:	e5933000 	ldr	r3, [r3]
    90a0:	e3a01015 	mov	r1, #21
    90a4:	e1a00003 	mov	r0, r3
    90a8:	ebfffc57 	bl	820c <_ZN4CAUX12Get_RegisterEN3hal7AUX_RegE>
    90ac:	e1a03000 	mov	r3, r0
    90b0:	e2033020 	and	r3, r3, #32
    90b4:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/uart.cpp:40

    // dokud ma status registr priznak "vystupni fronta plna", nelze prenaset dalsi bit
    while (!value)
    90b8:	e51b3008 	ldr	r3, [fp, #-8]
    90bc:	e3530000 	cmp	r3, #0
    90c0:	1a000008 	bne	90e8 <_ZN5CUART5WriteEc+0x68>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/uart.cpp:42
    {
        value = (mAUX.Get_Register(hal::AUX_Reg::MU_LSR) & (1 << 5));
    90c4:	e51b3010 	ldr	r3, [fp, #-16]
    90c8:	e5933000 	ldr	r3, [r3]
    90cc:	e3a01015 	mov	r1, #21
    90d0:	e1a00003 	mov	r0, r3
    90d4:	ebfffc4c 	bl	820c <_ZN4CAUX12Get_RegisterEN3hal7AUX_RegE>
    90d8:	e1a03000 	mov	r3, r0
    90dc:	e2033020 	and	r3, r3, #32
    90e0:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/uart.cpp:40
    while (!value)
    90e4:	eafffff3 	b	90b8 <_ZN5CUART5WriteEc+0x38>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/uart.cpp:46
        // sMonitor << value << '\n';
    }

    mAUX.Set_Register(hal::AUX_Reg::MU_IO, c);
    90e8:	e51b3010 	ldr	r3, [fp, #-16]
    90ec:	e5933000 	ldr	r3, [r3]
    90f0:	e55b2011 	ldrb	r2, [fp, #-17]	; 0xffffffef
    90f4:	e3a01010 	mov	r1, #16
    90f8:	e1a00003 	mov	r0, r3
    90fc:	ebfffc31 	bl	81c8 <_ZN4CAUX12Set_RegisterEN3hal7AUX_RegEj>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/uart.cpp:47
}
    9100:	e320f000 	nop	{0}
    9104:	e24bd004 	sub	sp, fp, #4
    9108:	e8bd8800 	pop	{fp, pc}

0000910c <_ZN5CUART5WriteEPKc>:
_ZN5CUART5WriteEPKc():
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/uart.cpp:50

void CUART::Write(const char* str)
{
    910c:	e92d4800 	push	{fp, lr}
    9110:	e28db004 	add	fp, sp, #4
    9114:	e24dd010 	sub	sp, sp, #16
    9118:	e50b0010 	str	r0, [fp, #-16]
    911c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/uart.cpp:53
    int i;

    for (i = 0; str[i] != '\0'; i++)
    9120:	e3a03000 	mov	r3, #0
    9124:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/uart.cpp:53 (discriminator 3)
    9128:	e51b3008 	ldr	r3, [fp, #-8]
    912c:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    9130:	e0823003 	add	r3, r2, r3
    9134:	e5d33000 	ldrb	r3, [r3]
    9138:	e3530000 	cmp	r3, #0
    913c:	0a00000a 	beq	916c <_ZN5CUART5WriteEPKc+0x60>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/uart.cpp:54 (discriminator 2)
        Write(str[i]);
    9140:	e51b3008 	ldr	r3, [fp, #-8]
    9144:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    9148:	e0823003 	add	r3, r2, r3
    914c:	e5d33000 	ldrb	r3, [r3]
    9150:	e1a01003 	mov	r1, r3
    9154:	e51b0010 	ldr	r0, [fp, #-16]
    9158:	ebffffc8 	bl	9080 <_ZN5CUART5WriteEc>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/uart.cpp:53 (discriminator 2)
    for (i = 0; str[i] != '\0'; i++)
    915c:	e51b3008 	ldr	r3, [fp, #-8]
    9160:	e2833001 	add	r3, r3, #1
    9164:	e50b3008 	str	r3, [fp, #-8]
    9168:	eaffffee 	b	9128 <_ZN5CUART5WriteEPKc+0x1c>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/uart.cpp:55
    916c:	e320f000 	nop	{0}
    9170:	e24bd004 	sub	sp, fp, #4
    9174:	e8bd8800 	pop	{fp, pc}

00009178 <_Z41__static_initialization_and_destruction_0ii>:
_Z41__static_initialization_and_destruction_0ii():
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/uart.cpp:55
    9178:	e92d4800 	push	{fp, lr}
    917c:	e28db004 	add	fp, sp, #4
    9180:	e24dd008 	sub	sp, sp, #8
    9184:	e50b0008 	str	r0, [fp, #-8]
    9188:	e50b100c 	str	r1, [fp, #-12]
    918c:	e51b3008 	ldr	r3, [fp, #-8]
    9190:	e3530001 	cmp	r3, #1
    9194:	1a000006 	bne	91b4 <_Z41__static_initialization_and_destruction_0ii+0x3c>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/uart.cpp:55 (discriminator 1)
    9198:	e51b300c 	ldr	r3, [fp, #-12]
    919c:	e59f201c 	ldr	r2, [pc, #28]	; 91c0 <_Z41__static_initialization_and_destruction_0ii+0x48>
    91a0:	e1530002 	cmp	r3, r2
    91a4:	1a000002 	bne	91b4 <_Z41__static_initialization_and_destruction_0ii+0x3c>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/uart.cpp:5
CUART sUART0(sAUX);
    91a8:	e59f1014 	ldr	r1, [pc, #20]	; 91c4 <_Z41__static_initialization_and_destruction_0ii+0x4c>
    91ac:	e59f0014 	ldr	r0, [pc, #20]	; 91c8 <_Z41__static_initialization_and_destruction_0ii+0x50>
    91b0:	ebffff4d 	bl	8eec <_ZN5CUARTC1ER4CAUX>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/uart.cpp:55
    91b4:	e320f000 	nop	{0}
    91b8:	e24bd004 	sub	sp, fp, #4
    91bc:	e8bd8800 	pop	{fp, pc}
    91c0:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>
    91c4:	000096d0 	ldrdeq	r9, [r0], -r0
    91c8:	00009700 	andeq	r9, r0, r0, lsl #14

000091cc <_GLOBAL__sub_I_sUART0>:
_GLOBAL__sub_I_sUART0():
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/uart.cpp:55
    91cc:	e92d4800 	push	{fp, lr}
    91d0:	e28db004 	add	fp, sp, #4
    91d4:	e59f1008 	ldr	r1, [pc, #8]	; 91e4 <_GLOBAL__sub_I_sUART0+0x18>
    91d8:	e3a00001 	mov	r0, #1
    91dc:	ebffffe5 	bl	9178 <_Z41__static_initialization_and_destruction_0ii>
    91e0:	e8bd8800 	pop	{fp, pc}
    91e4:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>

000091e8 <_kernel_main>:
_kernel_main():
/mnt/c/Users/Kuba/Downloads/03/kernel/src/main.cpp:9

// GPIO pin 47 je pripojeny na LED na desce (tzv. ACT LED)
constexpr uint32_t ACT_Pin = 47;

extern "C" int _kernel_main(void)
{
    91e8:	e92d4800 	push	{fp, lr}
    91ec:	e28db004 	add	fp, sp, #4
    91f0:	e24dd008 	sub	sp, sp, #8
/mnt/c/Users/Kuba/Downloads/03/kernel/src/main.cpp:10
	sMonitor.Clear();
    91f4:	e59f0038 	ldr	r0, [pc, #56]	; 9234 <_kernel_main+0x4c>
    91f8:	ebfffd8c 	bl	8830 <_ZN8CMonitor5ClearEv>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/main.cpp:13

	// nastavime ACT LED pin na vystupni
	sGPIO.Set_GPIO_Function(ACT_Pin, NGPIO_Function::Output);
    91fc:	e3a02001 	mov	r2, #1
    9200:	e3a0102f 	mov	r1, #47	; 0x2f
    9204:	e59f002c 	ldr	r0, [pc, #44]	; 9238 <_kernel_main+0x50>
    9208:	ebfffcd3 	bl	855c <_ZN13CGPIO_Handler17Set_GPIO_FunctionEj14NGPIO_Function>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/main.cpp:16

	// inicializujeme UART kanal 0
	sUART0.Set_Baud_Rate(NUART_Baud_Rate::BR_115200);
    920c:	e59f1028 	ldr	r1, [pc, #40]	; 923c <_kernel_main+0x54>
    9210:	e59f0028 	ldr	r0, [pc, #40]	; 9240 <_kernel_main+0x58>
    9214:	ebffff74 	bl	8fec <_ZN5CUART13Set_Baud_RateE15NUART_Baud_Rate>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/main.cpp:17
	sUART0.Set_Char_Length(NUART_Char_Length::Char_8);
    9218:	e3a01001 	mov	r1, #1
    921c:	e59f001c 	ldr	r0, [pc, #28]	; 9240 <_kernel_main+0x58>
    9220:	ebffff5a 	bl	8f90 <_ZN5CUART15Set_Char_LengthE17NUART_Char_Length>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/main.cpp:20

	// vypiseme ladici hlasku
	sUART0.Write("Welcome to KIV/OS RPiOS kernel\r\n");
    9224:	e59f1018 	ldr	r1, [pc, #24]	; 9244 <_kernel_main+0x5c>
    9228:	e59f0010 	ldr	r0, [pc, #16]	; 9240 <_kernel_main+0x58>
    922c:	ebffffb6 	bl	910c <_ZN5CUART5WriteEPKc>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/main.cpp:24 (discriminator 1)

	volatile unsigned int tim;
	
    while (1)
    9230:	eafffffe 	b	9230 <_kernel_main+0x48>
    9234:	000096d8 	ldrdeq	r9, [r0], -r8
    9238:	000096d4 	ldrdeq	r9, [r0], -r4
    923c:	0001c200 	andeq	ip, r1, r0, lsl #4
    9240:	00009700 	andeq	r9, r0, r0, lsl #14
    9244:	0000969c 	muleq	r0, ip, r6

00009248 <_c_startup>:
_c_startup():
/mnt/c/Users/Kuba/Downloads/03/kernel/src/startup.cpp:21
extern "C" dtor_ptr __DTOR_LIST__[0];
// konec pole destruktoru
extern "C" dtor_ptr __DTOR_END__[0];

extern "C" int _c_startup(void)
{
    9248:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    924c:	e28db000 	add	fp, sp, #0
    9250:	e24dd00c 	sub	sp, sp, #12
/mnt/c/Users/Kuba/Downloads/03/kernel/src/startup.cpp:25
	int* i;
	
	// vynulujeme .bss sekci
	for (i = (int*)_bss_start; i < (int*)_bss_end; i++)
    9254:	e59f304c 	ldr	r3, [pc, #76]	; 92a8 <_c_startup+0x60>
    9258:	e5933000 	ldr	r3, [r3]
    925c:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/startup.cpp:25 (discriminator 3)
    9260:	e59f3044 	ldr	r3, [pc, #68]	; 92ac <_c_startup+0x64>
    9264:	e5933000 	ldr	r3, [r3]
    9268:	e1a02003 	mov	r2, r3
    926c:	e51b3008 	ldr	r3, [fp, #-8]
    9270:	e1530002 	cmp	r3, r2
    9274:	2a000006 	bcs	9294 <_c_startup+0x4c>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/startup.cpp:26 (discriminator 2)
		*i = 0;
    9278:	e51b3008 	ldr	r3, [fp, #-8]
    927c:	e3a02000 	mov	r2, #0
    9280:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/startup.cpp:25 (discriminator 2)
	for (i = (int*)_bss_start; i < (int*)_bss_end; i++)
    9284:	e51b3008 	ldr	r3, [fp, #-8]
    9288:	e2833004 	add	r3, r3, #4
    928c:	e50b3008 	str	r3, [fp, #-8]
    9290:	eafffff2 	b	9260 <_c_startup+0x18>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/startup.cpp:28
	
	return 0;
    9294:	e3a03000 	mov	r3, #0
/mnt/c/Users/Kuba/Downloads/03/kernel/src/startup.cpp:29
}
    9298:	e1a00003 	mov	r0, r3
    929c:	e28bd000 	add	sp, fp, #0
    92a0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    92a4:	e12fff1e 	bx	lr
    92a8:	000096d0 	ldrdeq	r9, [r0], -r0
    92ac:	00009714 	andeq	r9, r0, r4, lsl r7

000092b0 <_cpp_startup>:
_cpp_startup():
/mnt/c/Users/Kuba/Downloads/03/kernel/src/startup.cpp:32

extern "C" int _cpp_startup(void)
{
    92b0:	e92d4800 	push	{fp, lr}
    92b4:	e28db004 	add	fp, sp, #4
    92b8:	e24dd008 	sub	sp, sp, #8
/mnt/c/Users/Kuba/Downloads/03/kernel/src/startup.cpp:37
	ctor_ptr* fnptr;
	
	// zavolame konstruktory globalnich C++ trid
	// v poli __CTOR_LIST__ jsou ukazatele na vygenerovane stuby volani konstruktoru
	for (fnptr = __CTOR_LIST__; fnptr < __CTOR_END__; fnptr++)
    92bc:	e59f303c 	ldr	r3, [pc, #60]	; 9300 <_cpp_startup+0x50>
    92c0:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/startup.cpp:37 (discriminator 3)
    92c4:	e51b3008 	ldr	r3, [fp, #-8]
    92c8:	e59f2034 	ldr	r2, [pc, #52]	; 9304 <_cpp_startup+0x54>
    92cc:	e1530002 	cmp	r3, r2
    92d0:	2a000006 	bcs	92f0 <_cpp_startup+0x40>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/startup.cpp:38 (discriminator 2)
		(*fnptr)();
    92d4:	e51b3008 	ldr	r3, [fp, #-8]
    92d8:	e5933000 	ldr	r3, [r3]
    92dc:	e12fff33 	blx	r3
/mnt/c/Users/Kuba/Downloads/03/kernel/src/startup.cpp:37 (discriminator 2)
	for (fnptr = __CTOR_LIST__; fnptr < __CTOR_END__; fnptr++)
    92e0:	e51b3008 	ldr	r3, [fp, #-8]
    92e4:	e2833004 	add	r3, r3, #4
    92e8:	e50b3008 	str	r3, [fp, #-8]
    92ec:	eafffff4 	b	92c4 <_cpp_startup+0x14>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/startup.cpp:40
	
	return 0;
    92f0:	e3a03000 	mov	r3, #0
/mnt/c/Users/Kuba/Downloads/03/kernel/src/startup.cpp:41
}
    92f4:	e1a00003 	mov	r0, r3
    92f8:	e24bd004 	sub	sp, fp, #4
    92fc:	e8bd8800 	pop	{fp, pc}
    9300:	000096c0 	andeq	r9, r0, r0, asr #13
    9304:	000096d0 	ldrdeq	r9, [r0], -r0

00009308 <_cpp_shutdown>:
_cpp_shutdown():
/mnt/c/Users/Kuba/Downloads/03/kernel/src/startup.cpp:44

extern "C" int _cpp_shutdown(void)
{
    9308:	e92d4800 	push	{fp, lr}
    930c:	e28db004 	add	fp, sp, #4
    9310:	e24dd008 	sub	sp, sp, #8
/mnt/c/Users/Kuba/Downloads/03/kernel/src/startup.cpp:48
	dtor_ptr* fnptr;
	
	// zavolame destruktory globalnich C++ trid
	for (fnptr = __DTOR_LIST__; fnptr < __DTOR_END__; fnptr++)
    9314:	e59f303c 	ldr	r3, [pc, #60]	; 9358 <_cpp_shutdown+0x50>
    9318:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Downloads/03/kernel/src/startup.cpp:48 (discriminator 3)
    931c:	e51b3008 	ldr	r3, [fp, #-8]
    9320:	e59f2034 	ldr	r2, [pc, #52]	; 935c <_cpp_shutdown+0x54>
    9324:	e1530002 	cmp	r3, r2
    9328:	2a000006 	bcs	9348 <_cpp_shutdown+0x40>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/startup.cpp:49 (discriminator 2)
		(*fnptr)();
    932c:	e51b3008 	ldr	r3, [fp, #-8]
    9330:	e5933000 	ldr	r3, [r3]
    9334:	e12fff33 	blx	r3
/mnt/c/Users/Kuba/Downloads/03/kernel/src/startup.cpp:48 (discriminator 2)
	for (fnptr = __DTOR_LIST__; fnptr < __DTOR_END__; fnptr++)
    9338:	e51b3008 	ldr	r3, [fp, #-8]
    933c:	e2833004 	add	r3, r3, #4
    9340:	e50b3008 	str	r3, [fp, #-8]
    9344:	eafffff4 	b	931c <_cpp_shutdown+0x14>
/mnt/c/Users/Kuba/Downloads/03/kernel/src/startup.cpp:51
	
	return 0;
    9348:	e3a03000 	mov	r3, #0
/mnt/c/Users/Kuba/Downloads/03/kernel/src/startup.cpp:52
}
    934c:	e1a00003 	mov	r0, r3
    9350:	e24bd004 	sub	sp, fp, #4
    9354:	e8bd8800 	pop	{fp, pc}
    9358:	000096d0 	ldrdeq	r9, [r0], -r0
    935c:	000096d0 	ldrdeq	r9, [r0], -r0

00009360 <__udivsi3>:
__udivsi3():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1104
    9360:	e2512001 	subs	r2, r1, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1106
    9364:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1107
    9368:	3a000074 	bcc	9540 <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1108
    936c:	e1500001 	cmp	r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1109
    9370:	9a00006b 	bls	9524 <__udivsi3+0x1c4>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1110
    9374:	e1110002 	tst	r1, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1111
    9378:	0a00006c 	beq	9530 <__udivsi3+0x1d0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1113
    937c:	e16f3f10 	clz	r3, r0
    9380:	e16f2f11 	clz	r2, r1
    9384:	e0423003 	sub	r3, r2, r3
    9388:	e273301f 	rsbs	r3, r3, #31
    938c:	10833083 	addne	r3, r3, r3, lsl #1
    9390:	e3a02000 	mov	r2, #0
    9394:	108ff103 	addne	pc, pc, r3, lsl #2
    9398:	e1a00000 	nop			; (mov r0, r0)
    939c:	e1500f81 	cmp	r0, r1, lsl #31
    93a0:	e0a22002 	adc	r2, r2, r2
    93a4:	20400f81 	subcs	r0, r0, r1, lsl #31
    93a8:	e1500f01 	cmp	r0, r1, lsl #30
    93ac:	e0a22002 	adc	r2, r2, r2
    93b0:	20400f01 	subcs	r0, r0, r1, lsl #30
    93b4:	e1500e81 	cmp	r0, r1, lsl #29
    93b8:	e0a22002 	adc	r2, r2, r2
    93bc:	20400e81 	subcs	r0, r0, r1, lsl #29
    93c0:	e1500e01 	cmp	r0, r1, lsl #28
    93c4:	e0a22002 	adc	r2, r2, r2
    93c8:	20400e01 	subcs	r0, r0, r1, lsl #28
    93cc:	e1500d81 	cmp	r0, r1, lsl #27
    93d0:	e0a22002 	adc	r2, r2, r2
    93d4:	20400d81 	subcs	r0, r0, r1, lsl #27
    93d8:	e1500d01 	cmp	r0, r1, lsl #26
    93dc:	e0a22002 	adc	r2, r2, r2
    93e0:	20400d01 	subcs	r0, r0, r1, lsl #26
    93e4:	e1500c81 	cmp	r0, r1, lsl #25
    93e8:	e0a22002 	adc	r2, r2, r2
    93ec:	20400c81 	subcs	r0, r0, r1, lsl #25
    93f0:	e1500c01 	cmp	r0, r1, lsl #24
    93f4:	e0a22002 	adc	r2, r2, r2
    93f8:	20400c01 	subcs	r0, r0, r1, lsl #24
    93fc:	e1500b81 	cmp	r0, r1, lsl #23
    9400:	e0a22002 	adc	r2, r2, r2
    9404:	20400b81 	subcs	r0, r0, r1, lsl #23
    9408:	e1500b01 	cmp	r0, r1, lsl #22
    940c:	e0a22002 	adc	r2, r2, r2
    9410:	20400b01 	subcs	r0, r0, r1, lsl #22
    9414:	e1500a81 	cmp	r0, r1, lsl #21
    9418:	e0a22002 	adc	r2, r2, r2
    941c:	20400a81 	subcs	r0, r0, r1, lsl #21
    9420:	e1500a01 	cmp	r0, r1, lsl #20
    9424:	e0a22002 	adc	r2, r2, r2
    9428:	20400a01 	subcs	r0, r0, r1, lsl #20
    942c:	e1500981 	cmp	r0, r1, lsl #19
    9430:	e0a22002 	adc	r2, r2, r2
    9434:	20400981 	subcs	r0, r0, r1, lsl #19
    9438:	e1500901 	cmp	r0, r1, lsl #18
    943c:	e0a22002 	adc	r2, r2, r2
    9440:	20400901 	subcs	r0, r0, r1, lsl #18
    9444:	e1500881 	cmp	r0, r1, lsl #17
    9448:	e0a22002 	adc	r2, r2, r2
    944c:	20400881 	subcs	r0, r0, r1, lsl #17
    9450:	e1500801 	cmp	r0, r1, lsl #16
    9454:	e0a22002 	adc	r2, r2, r2
    9458:	20400801 	subcs	r0, r0, r1, lsl #16
    945c:	e1500781 	cmp	r0, r1, lsl #15
    9460:	e0a22002 	adc	r2, r2, r2
    9464:	20400781 	subcs	r0, r0, r1, lsl #15
    9468:	e1500701 	cmp	r0, r1, lsl #14
    946c:	e0a22002 	adc	r2, r2, r2
    9470:	20400701 	subcs	r0, r0, r1, lsl #14
    9474:	e1500681 	cmp	r0, r1, lsl #13
    9478:	e0a22002 	adc	r2, r2, r2
    947c:	20400681 	subcs	r0, r0, r1, lsl #13
    9480:	e1500601 	cmp	r0, r1, lsl #12
    9484:	e0a22002 	adc	r2, r2, r2
    9488:	20400601 	subcs	r0, r0, r1, lsl #12
    948c:	e1500581 	cmp	r0, r1, lsl #11
    9490:	e0a22002 	adc	r2, r2, r2
    9494:	20400581 	subcs	r0, r0, r1, lsl #11
    9498:	e1500501 	cmp	r0, r1, lsl #10
    949c:	e0a22002 	adc	r2, r2, r2
    94a0:	20400501 	subcs	r0, r0, r1, lsl #10
    94a4:	e1500481 	cmp	r0, r1, lsl #9
    94a8:	e0a22002 	adc	r2, r2, r2
    94ac:	20400481 	subcs	r0, r0, r1, lsl #9
    94b0:	e1500401 	cmp	r0, r1, lsl #8
    94b4:	e0a22002 	adc	r2, r2, r2
    94b8:	20400401 	subcs	r0, r0, r1, lsl #8
    94bc:	e1500381 	cmp	r0, r1, lsl #7
    94c0:	e0a22002 	adc	r2, r2, r2
    94c4:	20400381 	subcs	r0, r0, r1, lsl #7
    94c8:	e1500301 	cmp	r0, r1, lsl #6
    94cc:	e0a22002 	adc	r2, r2, r2
    94d0:	20400301 	subcs	r0, r0, r1, lsl #6
    94d4:	e1500281 	cmp	r0, r1, lsl #5
    94d8:	e0a22002 	adc	r2, r2, r2
    94dc:	20400281 	subcs	r0, r0, r1, lsl #5
    94e0:	e1500201 	cmp	r0, r1, lsl #4
    94e4:	e0a22002 	adc	r2, r2, r2
    94e8:	20400201 	subcs	r0, r0, r1, lsl #4
    94ec:	e1500181 	cmp	r0, r1, lsl #3
    94f0:	e0a22002 	adc	r2, r2, r2
    94f4:	20400181 	subcs	r0, r0, r1, lsl #3
    94f8:	e1500101 	cmp	r0, r1, lsl #2
    94fc:	e0a22002 	adc	r2, r2, r2
    9500:	20400101 	subcs	r0, r0, r1, lsl #2
    9504:	e1500081 	cmp	r0, r1, lsl #1
    9508:	e0a22002 	adc	r2, r2, r2
    950c:	20400081 	subcs	r0, r0, r1, lsl #1
    9510:	e1500001 	cmp	r0, r1
    9514:	e0a22002 	adc	r2, r2, r2
    9518:	20400001 	subcs	r0, r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1115
    951c:	e1a00002 	mov	r0, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1116
    9520:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1119
    9524:	03a00001 	moveq	r0, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1120
    9528:	13a00000 	movne	r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1121
    952c:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1123
    9530:	e16f2f11 	clz	r2, r1
    9534:	e262201f 	rsb	r2, r2, #31
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1125
    9538:	e1a00230 	lsr	r0, r0, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1126
    953c:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1130
    9540:	e3500000 	cmp	r0, #0
    9544:	13e00000 	mvnne	r0, #0
    9548:	ea000007 	b	956c <__aeabi_idiv0>

0000954c <__aeabi_uidivmod>:
__aeabi_uidivmod():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1161
    954c:	e3510000 	cmp	r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1162
    9550:	0afffffa 	beq	9540 <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1163
    9554:	e92d4003 	push	{r0, r1, lr}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1164
    9558:	ebffff80 	bl	9360 <__udivsi3>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1165
    955c:	e8bd4006 	pop	{r1, r2, lr}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1166
    9560:	e0030092 	mul	r3, r2, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1167
    9564:	e0411003 	sub	r1, r1, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1168
    9568:	e12fff1e 	bx	lr

0000956c <__aeabi_idiv0>:
__aeabi_ldiv0():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1466
    956c:	e12fff1e 	bx	lr

Disassembly of section .ARM.extab:

00009570 <.ARM.extab>:
    9570:	81019b40 	tsthi	r1, r0, asr #22
    9574:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    9578:	00000000 	andeq	r0, r0, r0
    957c:	81019b41 	tsthi	r1, r1, asr #22
    9580:	8481b0b0 	strhi	fp, [r1], #176	; 0xb0
    9584:	00000000 	andeq	r0, r0, r0
    9588:	81019b40 	tsthi	r1, r0, asr #22
    958c:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    9590:	00000000 	andeq	r0, r0, r0
    9594:	81019b40 	tsthi	r1, r0, asr #22
    9598:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    959c:	00000000 	andeq	r0, r0, r0
    95a0:	81019b40 	tsthi	r1, r0, asr #22
    95a4:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    95a8:	00000000 	andeq	r0, r0, r0
    95ac:	81019b40 	tsthi	r1, r0, asr #22
    95b0:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    95b4:	00000000 	andeq	r0, r0, r0
    95b8:	81019b40 	tsthi	r1, r0, asr #22
    95bc:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    95c0:	00000000 	andeq	r0, r0, r0
    95c4:	81019b40 	tsthi	r1, r0, asr #22
    95c8:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    95cc:	00000000 	andeq	r0, r0, r0

Disassembly of section .ARM.exidx:

000095d0 <.ARM.exidx>:
    95d0:	7fffea48 	svcvc	0x00ffea48
    95d4:	00000001 	andeq	r0, r0, r1
    95d8:	7ffff914 	svcvc	0x00fff914
    95dc:	7fffff94 	svcvc	0x00ffff94
    95e0:	7ffff9b0 	svcvc	0x00fff9b0
    95e4:	7fffff98 	svcvc	0x00ffff98
    95e8:	7ffffa04 	svcvc	0x00fffa04
    95ec:	7fffff9c 	svcvc	0x00ffff9c
    95f0:	7ffffa90 	svcvc	0x00fffa90
    95f4:	7fffffa0 	svcvc	0x00ffffa0
    95f8:	7ffffb14 	svcvc	0x00fffb14
    95fc:	7fffffa4 	svcvc	0x00ffffa4
    9600:	7ffffb78 	svcvc	0x00fffb78
    9604:	00000001 	andeq	r0, r0, r1
    9608:	7ffffbe0 	svcvc	0x00fffbe0
    960c:	7fffffa0 	svcvc	0x00ffffa0
    9610:	7ffffc38 	svcvc	0x00fffc38
    9614:	00000001 	andeq	r0, r0, r1
    9618:	7ffffc98 	svcvc	0x00fffc98
    961c:	7fffff9c 	svcvc	0x00ffff9c
    9620:	7ffffce8 	svcvc	0x00fffce8
    9624:	7fffffa0 	svcvc	0x00ffffa0
    9628:	7ffffd38 	svcvc	0x00fffd38
    962c:	00000001 	andeq	r0, r0, r1

Disassembly of section .rodata:

00009630 <_ZN3halL15Peripheral_BaseE>:
    9630:	20000000 	andcs	r0, r0, r0

00009634 <_ZN3halL9GPIO_BaseE>:
    9634:	20200000 	eorcs	r0, r0, r0

00009638 <_ZN3halL14GPIO_Pin_CountE>:
    9638:	00000036 	andeq	r0, r0, r6, lsr r0

0000963c <_ZN3halL8AUX_BaseE>:
    963c:	20215000 	eorcs	r5, r1, r0

00009640 <_ZN3halL15Peripheral_BaseE>:
    9640:	20000000 	andcs	r0, r0, r0

00009644 <_ZN3halL9GPIO_BaseE>:
    9644:	20200000 	eorcs	r0, r0, r0

00009648 <_ZN3halL14GPIO_Pin_CountE>:
    9648:	00000036 	andeq	r0, r0, r6, lsr r0

0000964c <_ZN3halL8AUX_BaseE>:
    964c:	20215000 	eorcs	r5, r1, r0

00009650 <_ZZN8CMonitorlsEjE11BUFFER_SIZE>:
    9650:	00000010 	andeq	r0, r0, r0, lsl r0
    9654:	65757274 	ldrbvs	r7, [r5, #-628]!	; 0xfffffd8c
    9658:	00000000 	andeq	r0, r0, r0
    965c:	736c6166 	cmnvc	ip, #-2147483623	; 0x80000019
    9660:	00000065 	andeq	r0, r0, r5, rrx
    9664:	33323130 	teqcc	r2, #48, 2
    9668:	37363534 			; <UNDEFINED> instruction: 0x37363534
    966c:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    9670:	46454443 	strbmi	r4, [r5], -r3, asr #8
    9674:	00000000 	andeq	r0, r0, r0

00009678 <_ZN3halL15Peripheral_BaseE>:
    9678:	20000000 	andcs	r0, r0, r0

0000967c <_ZN3halL9GPIO_BaseE>:
    967c:	20200000 	eorcs	r0, r0, r0

00009680 <_ZN3halL14GPIO_Pin_CountE>:
    9680:	00000036 	andeq	r0, r0, r6, lsr r0

00009684 <_ZN3halL8AUX_BaseE>:
    9684:	20215000 	eorcs	r5, r1, r0

00009688 <_ZN3halL15Peripheral_BaseE>:
    9688:	20000000 	andcs	r0, r0, r0

0000968c <_ZN3halL9GPIO_BaseE>:
    968c:	20200000 	eorcs	r0, r0, r0

00009690 <_ZN3halL14GPIO_Pin_CountE>:
    9690:	00000036 	andeq	r0, r0, r6, lsr r0

00009694 <_ZN3halL8AUX_BaseE>:
    9694:	20215000 	eorcs	r5, r1, r0

00009698 <_ZL7ACT_Pin>:
    9698:	0000002f 	andeq	r0, r0, pc, lsr #32
    969c:	636c6557 	cmnvs	ip, #364904448	; 0x15c00000
    96a0:	20656d6f 	rsbcs	r6, r5, pc, ror #26
    96a4:	4b206f74 	blmi	82547c <_bss_end+0x81bd68>
    96a8:	4f2f5649 	svcmi	0x002f5649
    96ac:	50522053 	subspl	r2, r2, r3, asr r0
    96b0:	20534f69 	subscs	r4, r3, r9, ror #30
    96b4:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
    96b8:	0a0d6c65 	beq	364854 <_bss_end+0x35b140>
	...

Disassembly of section .data:

000096c0 <__CTOR_LIST__>:
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:2355
    96c0:	0000829c 	muleq	r0, ip, r2
    96c4:	0000879c 	muleq	r0, ip, r7
    96c8:	00008de4 	andeq	r8, r0, r4, ror #27
    96cc:	000091cc 	andeq	r9, r0, ip, asr #3

Disassembly of section .bss:

000096d0 <sAUX>:
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/bcm_aux.cpp:3
CAUX sAUX(hal::AUX_Base);
    96d0:	00000000 	andeq	r0, r0, r0

000096d4 <sGPIO>:
/mnt/c/Users/Kuba/Downloads/03/kernel/src/drivers/gpio.cpp:4
CGPIO_Handler sGPIO(hal::GPIO_Base);
    96d4:	00000000 	andeq	r0, r0, r0

000096d8 <sMonitor>:
	...

000096f0 <_ZZN8CMonitorlsEjE8s_buffer>:
	...

00009700 <sUART0>:
	...

Disassembly of section .debug_info:

00000000 <.debug_info>:
       0:	00000126 	andeq	r0, r0, r6, lsr #2
       4:	00000004 	andeq	r0, r0, r4
       8:	01040000 	mrseq	r0, (UNDEF: 4)
       c:	00000097 	muleq	r0, r7, r0
      10:	00001404 	andeq	r1, r0, r4, lsl #8
      14:	00005800 	andeq	r5, r0, r0, lsl #16
      18:	00801800 	addeq	r1, r0, r0, lsl #16
      1c:	0000d800 	andeq	sp, r0, r0, lsl #16
      20:	00000000 	andeq	r0, r0, r0
      24:	015d0200 	cmpeq	sp, r0, lsl #4
      28:	29010000 	stmdbcs	r1, {}	; <UNPREDICTABLE>
      2c:	0080e411 	addeq	lr, r0, r1, lsl r4
      30:	00000c00 	andeq	r0, r0, r0, lsl #24
      34:	029c0100 	addseq	r0, ip, #0, 2
      38:	0000014a 	andeq	r0, r0, sl, asr #2
      3c:	cc112401 	cfldrsgt	mvf2, [r1], {1}
      40:	18000080 	stmdane	r0, {r7}
      44:	01000000 	mrseq	r0, (UNDEF: 0)
      48:	008a029c 	umulleq	r0, sl, ip, r2
      4c:	1f010000 	svcne	0x00010000
      50:	0080b411 	addeq	fp, r0, r1, lsl r4
      54:	00001800 	andeq	r1, r0, r0, lsl #16
      58:	029c0100 	addseq	r0, ip, #0, 2
      5c:	0000007d 	andeq	r0, r0, sp, ror r0
      60:	9c111a01 			; <UNDEFINED> instruction: 0x9c111a01
      64:	18000080 	stmdane	r0, {r7}
      68:	01000000 	mrseq	r0, (UNDEF: 0)
      6c:	013f039c 	teqeq	pc, ip	; <illegal shifter operand>	; <UNPREDICTABLE>
      70:	00020000 	andeq	r0, r2, r0
      74:	000000bb 	strheq	r0, [r0], -fp
      78:	00004604 	andeq	r4, r0, r4, lsl #12
      7c:	12140100 	andsne	r0, r4, #0, 2
      80:	0000008a 	andeq	r0, r0, sl, lsl #1
      84:	0000bb05 	andeq	fp, r0, r5, lsl #22
      88:	74060000 	strvc	r0, [r6], #-0
      8c:	01000001 	tsteq	r0, r1
      90:	00c11c04 	sbceq	r1, r1, r4, lsl #24
      94:	00040000 	andeq	r0, r4, r0
      98:	01000000 	mrseq	r0, (UNDEF: 0)
      9c:	00a8120f 	adceq	r1, r8, pc, lsl #4
      a0:	bb050000 	bllt	1400a8 <_bss_end+0x136994>
      a4:	00000000 	andeq	r0, r0, r0
      a8:	00012b07 	andeq	r2, r1, r7, lsl #22
      ac:	110a0100 	mrsne	r0, (UNDEF: 26)
      b0:	00000105 	andeq	r0, r0, r5, lsl #2
      b4:	0000bb05 	andeq	fp, r0, r5, lsl #22
      b8:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
      bc:	00008a04 	andeq	r8, r0, r4, lsl #20
      c0:	05080900 	streq	r0, [r8, #-2304]	; 0xfffff700
      c4:	0000017c 	andeq	r0, r0, ip, ror r1
      c8:	0000780a 	andeq	r7, r0, sl, lsl #16
      cc:	00807c00 	addeq	r7, r0, r0, lsl #24
      d0:	00002000 	andeq	r2, r0, r0
      d4:	e49c0100 	ldr	r0, [ip], #256	; 0x100
      d8:	0b000000 	bleq	e0 <shift+0xe0>
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
     11c:	0a010067 	beq	402c0 <_bss_end+0x36bac>
     120:	0000bb2f 	andeq	fp, r0, pc, lsr #22
     124:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     128:	03ef0000 	mvneq	r0, #0
     12c:	00040000 	andeq	r0, r4, r0
     130:	000000d0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     134:	00970104 	addseq	r0, r7, r4, lsl #2
     138:	d6040000 	strle	r0, [r4], -r0
     13c:	58000002 	stmdapl	r0, {r1}
     140:	f0000000 			; <UNDEFINED> instruction: 0xf0000000
     144:	c8000080 	stmdagt	r0, {r7}
     148:	93000001 	movwls	r0, #1
     14c:	02000000 	andeq	r0, r0, #0
     150:	02d10801 	sbcseq	r0, r1, #65536	; 0x10000
     154:	02020000 	andeq	r0, r2, #0
     158:	00018a05 	andeq	r8, r1, r5, lsl #20
     15c:	05040300 	streq	r0, [r4, #-768]	; 0xfffffd00
     160:	00746e69 	rsbseq	r6, r4, r9, ror #28
     164:	c8080102 	stmdagt	r8, {r1, r8}
     168:	02000002 	andeq	r0, r0, #2
     16c:	036b0702 	cmneq	fp, #524288	; 0x80000
     170:	39040000 	stmdbcc	r4, {}	; <UNPREDICTABLE>
     174:	04000003 	streq	r0, [r0], #-3
     178:	0059070b 	subseq	r0, r9, fp, lsl #14
     17c:	48050000 	stmdami	r5, {}	; <UNPREDICTABLE>
     180:	02000000 	andeq	r0, r0, #0
     184:	11130704 	tstne	r3, r4, lsl #14
     188:	68060000 	stmdavs	r6, {}	; <UNPREDICTABLE>
     18c:	02006c61 	andeq	r6, r0, #24832	; 0x6100
     190:	01680b07 	cmneq	r8, r7, lsl #22
     194:	8c070000 	stchi	0, cr0, [r7], {-0}
     198:	02000002 	andeq	r0, r0, #2
     19c:	016f1a0a 	cmneq	pc, sl, lsl #20
     1a0:	00000000 	andeq	r0, r0, r0
     1a4:	22072000 	andcs	r2, r7, #0
     1a8:	02000003 	andeq	r0, r0, #3
     1ac:	016f1a0d 	cmneq	pc, sp, lsl #20
     1b0:	00000000 	andeq	r0, r0, r0
     1b4:	a9082020 	stmdbge	r8, {r5, sp}
     1b8:	02000003 	andeq	r0, r0, #3
     1bc:	00541510 	subseq	r1, r4, r0, lsl r5
     1c0:	07360000 	ldreq	r0, [r6, -r0]!
     1c4:	0000040b 	andeq	r0, r0, fp, lsl #8
     1c8:	6f1a4202 	svcvs	0x001a4202
     1cc:	00000001 	andeq	r0, r0, r1
     1d0:	09202150 	stmdbeq	r0!, {r4, r6, r8, sp}
     1d4:	000001a9 	andeq	r0, r0, r9, lsr #3
     1d8:	00330405 	eorseq	r0, r3, r5, lsl #8
     1dc:	44020000 	strmi	r0, [r2], #-0
     1e0:	0001460d 	andeq	r4, r1, sp, lsl #12
     1e4:	52490a00 	subpl	r0, r9, #0, 20
     1e8:	0b000051 	bleq	334 <shift+0x334>
     1ec:	000001e6 	andeq	r0, r0, r6, ror #3
     1f0:	042b0b01 	strteq	r0, [fp], #-2817	; 0xfffff4ff
     1f4:	0b100000 	bleq	4001fc <_bss_end+0x3f6ae8>
     1f8:	00000314 	andeq	r0, r0, r4, lsl r3
     1fc:	03570b11 	cmpeq	r7, #17408	; 0x4400
     200:	0b120000 	bleq	480208 <_bss_end+0x476af4>
     204:	00000386 	andeq	r0, r0, r6, lsl #7
     208:	031b0b13 	tsteq	fp, #19456	; 0x4c00
     20c:	0b140000 	bleq	500214 <_bss_end+0x4f6b00>
     210:	0000043a 	andeq	r0, r0, sl, lsr r4
     214:	03ff0b15 	mvnseq	r0, #21504	; 0x5400
     218:	0b160000 	bleq	580220 <_bss_end+0x576b0c>
     21c:	00000472 	andeq	r0, r0, r2, ror r4
     220:	035e0b17 	cmpeq	lr, #23552	; 0x5c00
     224:	0b180000 	bleq	60022c <_bss_end+0x5f6b18>
     228:	00000414 	andeq	r0, r0, r4, lsl r4
     22c:	03970b19 	orrseq	r0, r7, #25600	; 0x6400
     230:	0b1a0000 	bleq	680238 <_bss_end+0x676b24>
     234:	00000276 	andeq	r0, r0, r6, ror r2
     238:	02810b20 	addeq	r0, r1, #32, 22	; 0x8000
     23c:	0b210000 	bleq	840244 <_bss_end+0x836b30>
     240:	0000039f 	muleq	r0, pc, r3	; <UNPREDICTABLE>
     244:	025a0b22 	subseq	r0, sl, #34816	; 0x8800
     248:	0b240000 	bleq	900250 <_bss_end+0x8f6b3c>
     24c:	0000038d 	andeq	r0, r0, sp, lsl #7
     250:	02ab0b25 	adceq	r0, fp, #37888	; 0x9400
     254:	0b300000 	bleq	c0025c <_bss_end+0xbf6b48>
     258:	000002b6 			; <UNDEFINED> instruction: 0x000002b6
     25c:	019e0b31 	orrseq	r0, lr, r1, lsr fp
     260:	0b320000 	bleq	c80268 <_bss_end+0xc76b54>
     264:	0000037e 	andeq	r0, r0, lr, ror r3
     268:	01940b34 	orrseq	r0, r4, r4, lsr fp
     26c:	00350000 	eorseq	r0, r5, r0
     270:	0002160c 	andeq	r1, r2, ip, lsl #12
     274:	33040500 	movwcc	r0, #17664	; 0x4500
     278:	02000000 	andeq	r0, r0, #0
     27c:	310b0d6a 	tstcc	fp, sl, ror #26
     280:	00000004 	andeq	r0, r0, r4
     284:	0003660b 	andeq	r6, r3, fp, lsl #12
     288:	060b0100 	streq	r0, [fp], -r0, lsl #2
     28c:	02000004 	andeq	r0, r0, #4
     290:	04020000 	streq	r0, [r2], #-0
     294:	00110e07 	andseq	r0, r1, r7, lsl #28
     298:	01680500 	cmneq	r8, r0, lsl #10
     29c:	6c0d0000 	stcvs	0, cr0, [sp], {-0}
     2a0:	0d000000 	stceq	0, cr0, [r0, #-0]
     2a4:	0000007c 	andeq	r0, r0, ip, ror r0
     2a8:	00008c0d 	andeq	r8, r0, sp, lsl #24
     2ac:	00990d00 	addseq	r0, r9, r0, lsl #26
     2b0:	a10e0000 	mrsge	r0, (UNDEF: 14)
     2b4:	0400000a 	streq	r0, [r0], #-10
     2b8:	4c070603 	stcmi	6, cr0, [r7], {3}
     2bc:	0f000002 	svceq	0x00000002
     2c0:	000001a8 	andeq	r0, r0, r8, lsr #3
     2c4:	521d0a03 	andspl	r0, sp, #12288	; 0x3000
     2c8:	00000002 	andeq	r0, r0, r2
     2cc:	000aa110 	andeq	sl, sl, r0, lsl r1
     2d0:	090d0300 	stmdbeq	sp, {r8, r9}
     2d4:	00000226 	andeq	r0, r0, r6, lsr #4
     2d8:	00000257 	andeq	r0, r0, r7, asr r2
     2dc:	0001bb01 	andeq	fp, r1, r1, lsl #22
     2e0:	0001c600 	andeq	ip, r1, r0, lsl #12
     2e4:	02571100 	subseq	r1, r7, #0, 2
     2e8:	59120000 	ldmdbpl	r2, {}	; <UNPREDICTABLE>
     2ec:	00000000 	andeq	r0, r0, r0
     2f0:	0002c113 	andeq	ip, r2, r3, lsl r1
     2f4:	0e100300 	cdpeq	3, 1, cr0, cr0, cr0, {0}
     2f8:	000001ee 	andeq	r0, r0, lr, ror #3
     2fc:	0001db01 	andeq	sp, r1, r1, lsl #22
     300:	0001e600 	andeq	lr, r1, r0, lsl #12
     304:	02571100 	subseq	r1, r7, #0, 2
     308:	46120000 	ldrmi	r0, [r2], -r0
     30c:	00000001 	andeq	r0, r0, r1
     310:	00034213 	andeq	r4, r3, r3, lsl r2
     314:	0e120300 	cdpeq	3, 1, cr0, cr2, cr0, {0}
     318:	00000449 	andeq	r0, r0, r9, asr #8
     31c:	0001fb01 	andeq	pc, r1, r1, lsl #22
     320:	00020600 	andeq	r0, r2, r0, lsl #12
     324:	02571100 	subseq	r1, r7, #0, 2
     328:	46120000 	ldrmi	r0, [r2], -r0
     32c:	00000001 	andeq	r0, r0, r1
     330:	0003f213 	andeq	pc, r3, r3, lsl r2	; <UNPREDICTABLE>
     334:	0e150300 	cdpeq	3, 1, cr0, cr5, cr0, {0}
     338:	00000233 	andeq	r0, r0, r3, lsr r2
     33c:	00021b01 	andeq	r1, r2, r1, lsl #22
     340:	00022b00 	andeq	r2, r2, r0, lsl #22
     344:	02571100 	subseq	r1, r7, #0, 2
     348:	a9120000 	ldmdbge	r2, {}	; <UNPREDICTABLE>
     34c:	12000000 	andne	r0, r0, #0
     350:	00000048 	andeq	r0, r0, r8, asr #32
     354:	034a1400 	movteq	r1, #41984	; 0xa400
     358:	17030000 	strne	r0, [r3, -r0]
     35c:	0001b112 	andeq	fp, r1, r2, lsl r1
     360:	00004800 	andeq	r4, r0, r0, lsl #16
     364:	02400100 	subeq	r0, r0, #0, 2
     368:	57110000 	ldrpl	r0, [r1, -r0]
     36c:	12000002 	andne	r0, r0, #2
     370:	000000a9 	andeq	r0, r0, r9, lsr #1
     374:	04150000 	ldreq	r0, [r5], #-0
     378:	00000059 	andeq	r0, r0, r9, asr r0
     37c:	00024c05 	andeq	r4, r2, r5, lsl #24
     380:	88041500 	stmdahi	r4, {r8, sl, ip}
     384:	05000001 	streq	r0, [r0, #-1]
     388:	00000257 	andeq	r0, r0, r7, asr r2
     38c:	00027116 	andeq	r7, r2, r6, lsl r1
     390:	0d1a0300 	ldceq	3, cr0, [sl, #-0]
     394:	00000188 	andeq	r0, r0, r8, lsl #3
     398:	00026217 	andeq	r6, r2, r7, lsl r2
     39c:	06030100 	streq	r0, [r3], -r0, lsl #2
     3a0:	96d00305 	ldrbls	r0, [r0], r5, lsl #6
     3a4:	62180000 	andsvs	r0, r8, #0
     3a8:	9c000002 	stcls	0, cr0, [r0], {2}
     3ac:	1c000082 	stcne	0, cr0, [r0], {130}	; 0x82
     3b0:	01000000 	mrseq	r0, (UNDEF: 0)
     3b4:	03b8199c 			; <UNDEFINED> instruction: 0x03b8199c
     3b8:	82480000 	subhi	r0, r8, #0
     3bc:	00540000 	subseq	r0, r4, r0
     3c0:	9c010000 	stcls	0, cr0, [r1], {-0}
     3c4:	000002bd 			; <UNDEFINED> instruction: 0x000002bd
     3c8:	00029c1a 	andeq	r9, r2, sl, lsl ip
     3cc:	011d0100 	tsteq	sp, r0, lsl #2
     3d0:	00000033 	andeq	r0, r0, r3, lsr r0
     3d4:	1a749102 	bne	1d247e4 <_bss_end+0x1d1b0d0>
     3d8:	000003e2 	andeq	r0, r0, r2, ror #7
     3dc:	33011d01 	movwcc	r1, #7425	; 0x1d01
     3e0:	02000000 	andeq	r0, r0, #0
     3e4:	1b007091 	blne	1c630 <_bss_end+0x12f1c>
     3e8:	0000022b 	andeq	r0, r0, fp, lsr #4
     3ec:	d70a1a01 	strle	r1, [sl, -r1, lsl #20]
     3f0:	0c000002 	stceq	0, cr0, [r0], {2}
     3f4:	3c000082 	stccc	0, cr0, [r0], {130}	; 0x82
     3f8:	01000000 	mrseq	r0, (UNDEF: 0)
     3fc:	0002f39c 	muleq	r2, ip, r3
     400:	03ed1c00 	mvneq	r1, #0, 24
     404:	025d0000 	subseq	r0, sp, #0
     408:	91020000 	mrsls	r0, (UNDEF: 2)
     40c:	04411a74 	strbeq	r1, [r1], #-2676	; 0xfffff58c
     410:	1a010000 	bne	40418 <_bss_end+0x36d04>
     414:	0000a92a 	andeq	sl, r0, sl, lsr #18
     418:	70910200 	addsvc	r0, r1, r0, lsl #4
     41c:	02061d00 	andeq	r1, r6, #0, 26
     420:	06010000 	streq	r0, [r1], -r0
     424:	0000030c 	andeq	r0, r0, ip, lsl #6
     428:	000081c8 	andeq	r8, r0, r8, asr #3
     42c:	00000044 	andeq	r0, r0, r4, asr #32
     430:	03379c01 	teqeq	r7, #256	; 0x100
     434:	ed1c0000 	ldc	0, cr0, [ip, #-0]
     438:	5d000003 	stcpl	0, cr0, [r0, #-12]
     43c:	02000002 	andeq	r0, r0, #2
     440:	411a7491 			; <UNDEFINED> instruction: 0x411a7491
     444:	01000004 	tsteq	r0, r4
     448:	00a92615 	adceq	r2, r9, r5, lsl r6
     44c:	91020000 	mrsls	r0, (UNDEF: 2)
     450:	01d71a70 	bicseq	r1, r7, r0, ror sl
     454:	15010000 	strne	r0, [r1, #-0]
     458:	00004838 	andeq	r4, r0, r8, lsr r8
     45c:	6c910200 	lfmvs	f0, 4, [r1], {0}
     460:	01e61e00 	mvneq	r1, r0, lsl #28
     464:	10010000 	andne	r0, r1, r0
     468:	00035106 	andeq	r5, r3, r6, lsl #2
     46c:	00817400 	addeq	r7, r1, r0, lsl #8
     470:	00005400 	andeq	r5, r0, r0, lsl #8
     474:	6d9c0100 	ldfvss	f0, [ip]
     478:	1c000003 	stcne	0, cr0, [r0], {3}
     47c:	000003ed 	andeq	r0, r0, sp, ror #7
     480:	0000025d 	andeq	r0, r0, sp, asr r2
     484:	1a749102 	bne	1d24894 <_bss_end+0x1d1b180>
     488:	0000041c 	andeq	r0, r0, ip, lsl r4
     48c:	46291001 	strtmi	r1, [r9], -r1
     490:	02000001 	andeq	r0, r0, #1
     494:	1e007091 	mcrne	0, 0, r7, cr0, cr1, {4}
     498:	000001c6 	andeq	r0, r0, r6, asr #3
     49c:	87060b01 	strhi	r0, [r6, -r1, lsl #22]
     4a0:	24000003 	strcs	r0, [r0], #-3
     4a4:	50000081 	andpl	r0, r0, r1, lsl #1
     4a8:	01000000 	mrseq	r0, (UNDEF: 0)
     4ac:	0003a39c 	muleq	r3, ip, r3
     4b0:	03ed1c00 	mvneq	r1, #0, 24
     4b4:	025d0000 	subseq	r0, sp, #0
     4b8:	91020000 	mrsls	r0, (UNDEF: 2)
     4bc:	041c1a74 	ldreq	r1, [ip], #-2676	; 0xfffff58c
     4c0:	0b010000 	bleq	404c8 <_bss_end+0x36db4>
     4c4:	00014628 	andeq	r4, r1, r8, lsr #12
     4c8:	70910200 	addsvc	r0, r1, r0, lsl #4
     4cc:	01a21f00 			; <UNDEFINED> instruction: 0x01a21f00
     4d0:	05010000 	streq	r0, [r1, #-0]
     4d4:	0003b401 	andeq	fp, r3, r1, lsl #8
     4d8:	03ca0000 	biceq	r0, sl, #0
     4dc:	ed200000 	stc	0, cr0, [r0, #-0]
     4e0:	5d000003 	stcpl	0, cr0, [r0, #-12]
     4e4:	21000002 	tstcs	r0, r2
     4e8:	000001dd 	ldrdeq	r0, [r0], -sp
     4ec:	59190501 	ldmdbpl	r9, {r0, r8, sl}
     4f0:	00000000 	andeq	r0, r0, r0
     4f4:	0003a322 	andeq	sl, r3, r2, lsr #6
     4f8:	00032c00 	andeq	r2, r3, r0, lsl #24
     4fc:	0003e100 	andeq	lr, r3, r0, lsl #2
     500:	0080f000 	addeq	pc, r0, r0
     504:	00003400 	andeq	r3, r0, r0, lsl #8
     508:	239c0100 	orrscs	r0, ip, #0, 2
     50c:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
     510:	23749102 	cmncs	r4, #-2147483648	; 0x80000000
     514:	000003bd 			; <UNDEFINED> instruction: 0x000003bd
     518:	00709102 	rsbseq	r9, r0, r2, lsl #2
     51c:	00068500 	andeq	r8, r6, r0, lsl #10
     520:	12000400 	andne	r0, r0, #0, 8
     524:	04000003 	streq	r0, [r0], #-3
     528:	00009701 	andeq	r9, r0, r1, lsl #14
     52c:	06a50400 	strteq	r0, [r5], r0, lsl #8
     530:	00580000 	subseq	r0, r8, r0
     534:	82b80000 	adcshi	r0, r8, #0
     538:	05000000 	streq	r0, [r0, #-0]
     53c:	01f80000 	mvnseq	r0, r0
     540:	01020000 	mrseq	r0, (UNDEF: 2)
     544:	0002d108 	andeq	sp, r2, r8, lsl #2
     548:	05020200 	streq	r0, [r2, #-512]	; 0xfffffe00
     54c:	0000018a 	andeq	r0, r0, sl, lsl #3
     550:	69050403 	stmdbvs	r5, {r0, r1, sl}
     554:	0400746e 	streq	r7, [r0], #-1134	; 0xfffffb92
     558:	0000057b 	andeq	r0, r0, fp, ror r5
     55c:	46070902 	strmi	r0, [r7], -r2, lsl #18
     560:	02000000 	andeq	r0, r0, #0
     564:	02c80801 	sbceq	r0, r8, #65536	; 0x10000
     568:	02020000 	andeq	r0, r2, #0
     56c:	00036b07 	andeq	r6, r3, r7, lsl #22
     570:	03390400 	teqeq	r9, #0, 8
     574:	0b020000 	bleq	8057c <_bss_end+0x76e68>
     578:	00006507 	andeq	r6, r0, r7, lsl #10
     57c:	00540500 	subseq	r0, r4, r0, lsl #10
     580:	04020000 	streq	r0, [r2], #-0
     584:	00111307 	andseq	r1, r1, r7, lsl #6
     588:	61680600 	cmnvs	r8, r0, lsl #12
     58c:	0703006c 	streq	r0, [r3, -ip, rrx]
     590:	0001770b 	andeq	r7, r1, fp, lsl #14
     594:	028c0700 	addeq	r0, ip, #0, 14
     598:	0a030000 	beq	c05a0 <_bss_end+0xb6e8c>
     59c:	00017e1a 	andeq	r7, r1, sl, lsl lr
     5a0:	00000000 	andeq	r0, r0, r0
     5a4:	03220720 			; <UNDEFINED> instruction: 0x03220720
     5a8:	0d030000 	stceq	0, cr0, [r3, #-0]
     5ac:	00017e1a 	andeq	r7, r1, sl, lsl lr
     5b0:	20000000 	andcs	r0, r0, r0
     5b4:	03a90820 			; <UNDEFINED> instruction: 0x03a90820
     5b8:	10030000 	andne	r0, r3, r0
     5bc:	00006015 	andeq	r6, r0, r5, lsl r0
     5c0:	18093600 	stmdane	r9, {r9, sl, ip, sp}
     5c4:	05000007 	streq	r0, [r0, #-7]
     5c8:	00003304 	andeq	r3, r0, r4, lsl #6
     5cc:	0d130300 	ldceq	3, cr0, [r3, #-0]
     5d0:	00000166 	andeq	r0, r0, r6, ror #2
     5d4:	0004ba0a 	andeq	fp, r4, sl, lsl #20
     5d8:	c20a0000 	andgt	r0, sl, #0
     5dc:	01000004 	tsteq	r0, r4
     5e0:	0004ca0a 	andeq	ip, r4, sl, lsl #20
     5e4:	d20a0200 	andle	r0, sl, #0, 4
     5e8:	03000004 	movweq	r0, #4
     5ec:	0004da0a 	andeq	sp, r4, sl, lsl #20
     5f0:	e20a0400 	and	r0, sl, #0, 8
     5f4:	05000004 	streq	r0, [r0, #-4]
     5f8:	0004ac0a 	andeq	sl, r4, sl, lsl #24
     5fc:	b30a0700 	movwlt	r0, #42752	; 0xa700
     600:	08000004 	stmdaeq	r0, {r2}
     604:	0008060a 	andeq	r0, r8, sl, lsl #12
     608:	8e0a0a00 	vmlahi.f32	s0, s20, s0
     60c:	0b000006 	bleq	62c <shift+0x62c>
     610:	0007590a 	andeq	r5, r7, sl, lsl #18
     614:	600a0d00 	andvs	r0, sl, r0, lsl #26
     618:	0e000007 	cdpeq	0, 0, cr0, cr0, cr7, {0}
     61c:	0005830a 	andeq	r8, r5, sl, lsl #6
     620:	8a0a1000 	bhi	284628 <_bss_end+0x27af14>
     624:	11000005 	tstne	r0, r5
     628:	0004fe0a 	andeq	pc, r4, sl, lsl #28
     62c:	050a1300 	streq	r1, [sl, #-768]	; 0xfffffd00
     630:	14000005 	strne	r0, [r0], #-5
     634:	0007d40a 	andeq	sp, r7, sl, lsl #8
     638:	db0a1600 	blle	285e40 <_bss_end+0x27c72c>
     63c:	17000007 	strne	r0, [r0, -r7]
     640:	0006e00a 	andeq	lr, r6, sl
     644:	e70a1900 	str	r1, [sl, -r0, lsl #18]
     648:	1a000006 	bne	668 <shift+0x668>
     64c:	0005a20a 	andeq	sl, r5, sl, lsl #4
     650:	fd0a1c00 	stc2	12, cr1, [sl, #-0]
     654:	1d000006 	stcne	0, cr0, [r0, #-24]	; 0xffffffe8
     658:	0006950a 	andeq	r9, r6, sl, lsl #10
     65c:	9d0a1f00 	stcls	15, cr1, [sl, #-0]
     660:	20000006 	andcs	r0, r0, r6
     664:	00063a0a 	andeq	r3, r6, sl, lsl #20
     668:	420a2200 	andmi	r2, sl, #0, 4
     66c:	23000006 	movwcs	r0, #6
     670:	0005e10a 	andeq	lr, r5, sl, lsl #2
     674:	ea0a2500 	b	289a7c <_bss_end+0x280368>
     678:	26000004 	strcs	r0, [r0], -r4
     67c:	0004f40a 	andeq	pc, r4, sl, lsl #8
     680:	07002700 	streq	r2, [r0, -r0, lsl #14]
     684:	0000040b 	andeq	r0, r0, fp, lsl #8
     688:	7e1a4203 	cdpvc	2, 1, cr4, cr10, cr3, {0}
     68c:	00000001 	andeq	r0, r0, r1
     690:	00202150 	eoreq	r2, r0, r0, asr r1
     694:	0e070402 	cdpeq	4, 0, cr0, cr7, cr2, {0}
     698:	05000011 	streq	r0, [r0, #-17]	; 0xffffffef
     69c:	00000177 	andeq	r0, r0, r7, ror r1
     6a0:	0000780b 	andeq	r7, r0, fp, lsl #16
     6a4:	00880b00 	addeq	r0, r8, r0, lsl #22
     6a8:	980b0000 	stmdals	fp, {}	; <UNPREDICTABLE>
     6ac:	0b000000 	bleq	6b4 <shift+0x6b4>
     6b0:	00000166 	andeq	r0, r0, r6, ror #2
     6b4:	00074a09 	andeq	r4, r7, r9, lsl #20
     6b8:	3a010700 	bcc	422c0 <_bss_end+0x38bac>
     6bc:	04000000 	streq	r0, [r0], #-0
     6c0:	01e00c06 	mvneq	r0, r6, lsl #24
     6c4:	ce0a0000 	cdpgt	0, 0, cr0, cr10, cr0, {0}
     6c8:	00000007 	andeq	r0, r0, r7
     6cc:	0007850a 	andeq	r8, r7, sl, lsl #10
     6d0:	000a0100 	andeq	r0, sl, r0, lsl #2
     6d4:	02000008 	andeq	r0, r0, #8
     6d8:	0007fa0a 	andeq	pc, r7, sl, lsl #20
     6dc:	e20a0300 	and	r0, sl, #0, 6
     6e0:	04000007 	streq	r0, [r0], #-7
     6e4:	0007e80a 	andeq	lr, r7, sl, lsl #16
     6e8:	ee0a0500 	cfsh32	mvfx0, mvfx10, #0
     6ec:	06000007 	streq	r0, [r0], -r7
     6f0:	0007f40a 	andeq	pc, r7, sl, lsl #8
     6f4:	960a0700 	strls	r0, [sl], -r0, lsl #14
     6f8:	08000005 	stmdaeq	r0, {r0, r2}
     6fc:	05c00c00 	strbeq	r0, [r0, #3072]	; 0xc00
     700:	04040000 	streq	r0, [r4], #-0
     704:	0341071a 	movteq	r0, #5914	; 0x171a
     708:	5e0d0000 	cdppl	0, 0, cr0, cr13, cr0, {0}
     70c:	04000005 	streq	r0, [r0], #-5
     710:	034c171e 	movteq	r1, #50974	; 0xc71e
     714:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
     718:	00000704 	andeq	r0, r0, r4, lsl #14
     71c:	2e082204 	cdpcs	2, 0, cr2, cr8, cr4, {0}
     720:	51000005 	tstpl	r0, r5
     724:	02000003 	andeq	r0, r0, #3
     728:	00000213 	andeq	r0, r0, r3, lsl r2
     72c:	00000228 	andeq	r0, r0, r8, lsr #4
     730:	0003580f 	andeq	r5, r3, pc, lsl #16
     734:	00541000 	subseq	r1, r4, r0
     738:	63100000 	tstvs	r0, #0
     73c:	10000003 	andne	r0, r0, r3
     740:	00000363 	andeq	r0, r0, r3, ror #6
     744:	07bb0e00 	ldreq	r0, [fp, r0, lsl #28]!
     748:	24040000 	strcs	r0, [r4], #-0
     74c:	00064a08 	andeq	r4, r6, r8, lsl #20
     750:	00035100 	andeq	r5, r3, r0, lsl #2
     754:	02410200 	subeq	r0, r1, #0, 4
     758:	02560000 	subseq	r0, r6, #0
     75c:	580f0000 	stmdapl	pc, {}	; <UNPREDICTABLE>
     760:	10000003 	andne	r0, r0, r3
     764:	00000054 	andeq	r0, r0, r4, asr r0
     768:	00036310 	andeq	r6, r3, r0, lsl r3
     76c:	03631000 	cmneq	r3, #0
     770:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
     774:	000005ce 	andeq	r0, r0, lr, asr #11
     778:	8c082604 	stchi	6, cr2, [r8], {4}
     77c:	51000007 	tstpl	r0, r7
     780:	02000003 	andeq	r0, r0, #3
     784:	0000026f 	andeq	r0, r0, pc, ror #4
     788:	00000284 	andeq	r0, r0, r4, lsl #5
     78c:	0003580f 	andeq	r5, r3, pc, lsl #16
     790:	00541000 	subseq	r1, r4, r0
     794:	63100000 	tstvs	r0, #0
     798:	10000003 	andne	r0, r0, r3
     79c:	00000363 	andeq	r0, r0, r3, ror #6
     7a0:	05e70e00 	strbeq	r0, [r7, #3584]!	; 0xe00
     7a4:	28040000 	stmdacs	r4, {}	; <UNPREDICTABLE>
     7a8:	00047d08 	andeq	r7, r4, r8, lsl #26
     7ac:	00035100 	andeq	r5, r3, r0, lsl #2
     7b0:	029d0200 	addseq	r0, sp, #0, 4
     7b4:	02b20000 	adcseq	r0, r2, #0
     7b8:	580f0000 	stmdapl	pc, {}	; <UNPREDICTABLE>
     7bc:	10000003 	andne	r0, r0, r3
     7c0:	00000054 	andeq	r0, r0, r4, asr r0
     7c4:	00036310 	andeq	r6, r3, r0, lsl r3
     7c8:	03631000 	cmneq	r3, #0
     7cc:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
     7d0:	000005c0 	andeq	r0, r0, r0, asr #11
     7d4:	64032b04 	strvs	r2, [r3], #-2820	; 0xfffff4fc
     7d8:	69000005 	stmdbvs	r0, {r0, r2}
     7dc:	01000003 	tsteq	r0, r3
     7e0:	000002cb 	andeq	r0, r0, fp, asr #5
     7e4:	000002d6 	ldrdeq	r0, [r0], -r6
     7e8:	0003690f 	andeq	r6, r3, pc, lsl #18
     7ec:	00651000 	rsbeq	r1, r5, r0
     7f0:	11000000 	mrsne	r0, (UNDEF: 0)
     7f4:	00000767 	andeq	r0, r0, r7, ror #14
     7f8:	21082e04 	tstcs	r8, r4, lsl #28
     7fc:	01000007 	tsteq	r0, r7
     800:	000002eb 	andeq	r0, r0, fp, ror #5
     804:	000002fb 	strdeq	r0, [r0], -fp
     808:	0003690f 	andeq	r6, r3, pc, lsl #18
     80c:	00541000 	subseq	r1, r4, r0
     810:	97100000 	ldrls	r0, [r0, -r0]
     814:	00000001 	andeq	r0, r0, r1
     818:	0005ae0e 	andeq	sl, r5, lr, lsl #28
     81c:	12300400 	eorsne	r0, r0, #0, 8
     820:	000005fa 	strdeq	r0, [r0], -sl
     824:	00000197 	muleq	r0, r7, r1
     828:	00031401 	andeq	r1, r3, r1, lsl #8
     82c:	00031f00 	andeq	r1, r3, r0, lsl #30
     830:	03580f00 	cmpeq	r8, #0, 30
     834:	54100000 	ldrpl	r0, [r0], #-0
     838:	00000000 	andeq	r0, r0, r0
     83c:	00078112 	andeq	r8, r7, r2, lsl r1
     840:	08330400 	ldmdaeq	r3!, {sl}
     844:	0000050c 	andeq	r0, r0, ip, lsl #10
     848:	00033001 	andeq	r3, r3, r1
     84c:	03690f00 	cmneq	r9, #0, 30
     850:	54100000 	ldrpl	r0, [r0], #-0
     854:	10000000 	andne	r0, r0, r0
     858:	00000351 	andeq	r0, r0, r1, asr r3
     85c:	e0050000 	and	r0, r5, r0
     860:	13000001 	movwne	r0, #1
     864:	00006504 	andeq	r6, r0, r4, lsl #10
     868:	03460500 	movteq	r0, #25856	; 0x6500
     86c:	01020000 	mrseq	r0, (UNDEF: 2)
     870:	00059102 	andeq	r9, r5, r2, lsl #2
     874:	41041300 	mrsmi	r1, LR_abt
     878:	05000003 	streq	r0, [r0, #-3]
     87c:	00000358 	andeq	r0, r0, r8, asr r3
     880:	00540414 	subseq	r0, r4, r4, lsl r4
     884:	04130000 	ldreq	r0, [r3], #-0
     888:	000001e0 	andeq	r0, r0, r0, ror #3
     88c:	00036905 	andeq	r6, r3, r5, lsl #18
     890:	06881500 	streq	r1, [r8], r0, lsl #10
     894:	37040000 	strcc	r0, [r4, -r0]
     898:	0001e016 	andeq	lr, r1, r6, lsl r0
     89c:	03741600 	cmneq	r4, #0, 12
     8a0:	04010000 	streq	r0, [r1], #-0
     8a4:	d403050f 	strle	r0, [r3], #-1295	; 0xfffffaf1
     8a8:	17000096 			; <UNDEFINED> instruction: 0x17000096
     8ac:	00000679 	andeq	r0, r0, r9, ror r6
     8b0:	0000879c 	muleq	r0, ip, r7
     8b4:	0000001c 	andeq	r0, r0, ip, lsl r0
     8b8:	b8189c01 	ldmdalt	r8, {r0, sl, fp, ip, pc}
     8bc:	48000003 	stmdami	r0, {r0, r1}
     8c0:	54000087 	strpl	r0, [r0], #-135	; 0xffffff79
     8c4:	01000000 	mrseq	r0, (UNDEF: 0)
     8c8:	0003cf9c 	muleq	r3, ip, pc	; <UNPREDICTABLE>
     8cc:	029c1900 	addseq	r1, ip, #0, 18
     8d0:	5b010000 	blpl	408d8 <_bss_end+0x371c4>
     8d4:	00003301 	andeq	r3, r0, r1, lsl #6
     8d8:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     8dc:	0003e219 	andeq	lr, r3, r9, lsl r2
     8e0:	015b0100 	cmpeq	fp, r0, lsl #2
     8e4:	00000033 	andeq	r0, r0, r3, lsr r0
     8e8:	00709102 	rsbseq	r9, r0, r2, lsl #2
     8ec:	00031f1a 	andeq	r1, r3, sl, lsl pc
     8f0:	06540100 	ldrbeq	r0, [r4], -r0, lsl #2
     8f4:	000003e9 	andeq	r0, r0, r9, ror #7
     8f8:	00008670 	andeq	r8, r0, r0, ror r6
     8fc:	000000d8 	ldrdeq	r0, [r0], -r8
     900:	04329c01 	ldrteq	r9, [r2], #-3073	; 0xfffff3ff
     904:	ed1b0000 	ldc	0, cr0, [fp, #-0]
     908:	6f000003 	svcvs	0x00000003
     90c:	02000003 	andeq	r0, r0, #3
     910:	701c6c91 	mulsvc	ip, r1, ip
     914:	01006e69 	tsteq	r0, r9, ror #28
     918:	00542954 	subseq	r2, r4, r4, asr r9
     91c:	91020000 	mrsls	r0, (UNDEF: 2)
     920:	65731c68 	ldrbvs	r1, [r3, #-3176]!	; 0xfffff398
     924:	54010074 	strpl	r0, [r1], #-116	; 0xffffff8c
     928:	00035133 	andeq	r5, r3, r3, lsr r1
     92c:	67910200 	ldrvs	r0, [r1, r0, lsl #4]
     930:	6765721d 			; <UNDEFINED> instruction: 0x6765721d
     934:	0b560100 	bleq	1580d3c <_bss_end+0x1577628>
     938:	00000054 	andeq	r0, r0, r4, asr r0
     93c:	1d749102 	ldfnep	f1, [r4, #-8]!
     940:	00746962 	rsbseq	r6, r4, r2, ror #18
     944:	54105601 	ldrpl	r5, [r0], #-1537	; 0xfffff9ff
     948:	02000000 	andeq	r0, r0, #0
     94c:	1a007091 	bne	1cb98 <_bss_end+0x13484>
     950:	000002fb 	strdeq	r0, [r0], -fp
     954:	4c104b01 			; <UNDEFINED> instruction: 0x4c104b01
     958:	fc000004 	stc2	0, cr0, [r0], {4}
     95c:	74000085 	strvc	r0, [r0], #-133	; 0xffffff7b
     960:	01000000 	mrseq	r0, (UNDEF: 0)
     964:	0004869c 	muleq	r4, ip, r6
     968:	03ed1b00 	mvneq	r1, #0, 22
     96c:	035e0000 	cmpeq	lr, #0
     970:	91020000 	mrsls	r0, (UNDEF: 2)
     974:	69701c6c 	ldmdbvs	r0!, {r2, r3, r5, r6, sl, fp, ip}^
     978:	4b01006e 	blmi	40b38 <_bss_end+0x37424>
     97c:	0000543a 	andeq	r5, r0, sl, lsr r4
     980:	68910200 	ldmvs	r1, {r9}
     984:	6765721d 			; <UNDEFINED> instruction: 0x6765721d
     988:	0b4d0100 	bleq	1340d90 <_bss_end+0x133767c>
     98c:	00000054 	andeq	r0, r0, r4, asr r0
     990:	1d749102 	ldfnep	f1, [r4, #-8]!
     994:	00746962 	rsbseq	r6, r4, r2, ror #18
     998:	54104d01 	ldrpl	r4, [r0], #-3329	; 0xfffff2ff
     99c:	02000000 	andeq	r0, r0, #0
     9a0:	1a007091 	bne	1cbec <_bss_end+0x134d8>
     9a4:	000002d6 	ldrdeq	r0, [r0], -r6
     9a8:	a0064101 	andge	r4, r6, r1, lsl #2
     9ac:	5c000004 	stcpl	0, cr0, [r0], {4}
     9b0:	a0000085 	andge	r0, r0, r5, lsl #1
     9b4:	01000000 	mrseq	r0, (UNDEF: 0)
     9b8:	0004e99c 	muleq	r4, ip, r9
     9bc:	03ed1b00 	mvneq	r1, #0, 22
     9c0:	036f0000 	cmneq	pc, #0
     9c4:	91020000 	mrsls	r0, (UNDEF: 2)
     9c8:	69701c6c 	ldmdbvs	r0!, {r2, r3, r5, r6, sl, fp, ip}^
     9cc:	4101006e 	tstmi	r1, lr, rrx
     9d0:	00005430 	andeq	r5, r0, r0, lsr r4
     9d4:	68910200 	ldmvs	r1, {r9}
     9d8:	0005a919 	andeq	sl, r5, r9, lsl r9
     9dc:	44410100 	strbmi	r0, [r1], #-256	; 0xffffff00
     9e0:	00000197 	muleq	r0, r7, r1
     9e4:	1d679102 	stfnep	f1, [r7, #-8]!
     9e8:	00676572 	rsbeq	r6, r7, r2, ror r5
     9ec:	540b4301 	strpl	r4, [fp], #-769	; 0xfffffcff
     9f0:	02000000 	andeq	r0, r0, #0
     9f4:	621d7491 	andsvs	r7, sp, #-1862270976	; 0x91000000
     9f8:	01007469 	tsteq	r0, r9, ror #8
     9fc:	00541043 	subseq	r1, r4, r3, asr #32
     a00:	91020000 	mrsls	r0, (UNDEF: 2)
     a04:	841e0070 	ldrhi	r0, [lr], #-112	; 0xffffff90
     a08:	01000002 	tsteq	r0, r2
     a0c:	05030636 	streq	r0, [r3, #-1590]	; 0xfffff9ca
     a10:	84e80000 	strbthi	r0, [r8], #0
     a14:	00740000 	rsbseq	r0, r4, r0
     a18:	9c010000 	stcls	0, cr0, [r1], {-0}
     a1c:	0000053d 	andeq	r0, r0, sp, lsr r5
     a20:	0003ed1b 	andeq	lr, r3, fp, lsl sp
     a24:	00035e00 	andeq	r5, r3, r0, lsl #28
     a28:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     a2c:	6e69701c 	mcrvs	0, 3, r7, cr9, cr12, {0}
     a30:	31360100 	teqcc	r6, r0, lsl #2
     a34:	00000054 	andeq	r0, r0, r4, asr r0
     a38:	1c709102 	ldfnep	f1, [r0], #-8
     a3c:	00676572 	rsbeq	r6, r7, r2, ror r5
     a40:	63403601 	movtvs	r3, #1537	; 0x601
     a44:	02000003 	andeq	r0, r0, #3
     a48:	79196c91 	ldmdbvc	r9, {r0, r4, r7, sl, fp, sp, lr}
     a4c:	01000007 	tsteq	r0, r7
     a50:	03634f36 	cmneq	r3, #54, 30	; 0xd8
     a54:	91020000 	mrsls	r0, (UNDEF: 2)
     a58:	561e0068 	ldrpl	r0, [lr], -r8, rrx
     a5c:	01000002 	tsteq	r0, r2
     a60:	0557062b 	ldrbeq	r0, [r7, #-1579]	; 0xfffff9d5
     a64:	84740000 	ldrbthi	r0, [r4], #-0
     a68:	00740000 	rsbseq	r0, r4, r0
     a6c:	9c010000 	stcls	0, cr0, [r1], {-0}
     a70:	00000591 	muleq	r0, r1, r5
     a74:	0003ed1b 	andeq	lr, r3, fp, lsl sp
     a78:	00035e00 	andeq	r5, r3, r0, lsl #28
     a7c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     a80:	6e69701c 	mcrvs	0, 3, r7, cr9, cr12, {0}
     a84:	312b0100 			; <UNDEFINED> instruction: 0x312b0100
     a88:	00000054 	andeq	r0, r0, r4, asr r0
     a8c:	1c709102 	ldfnep	f1, [r0], #-8
     a90:	00676572 	rsbeq	r6, r7, r2, ror r5
     a94:	63402b01 	movtvs	r2, #2817	; 0xb01
     a98:	02000003 	andeq	r0, r0, #3
     a9c:	79196c91 	ldmdbvc	r9, {r0, r4, r7, sl, fp, sp, lr}
     aa0:	01000007 	tsteq	r0, r7
     aa4:	03634f2b 	cmneq	r3, #43, 30	; 0xac
     aa8:	91020000 	mrsls	r0, (UNDEF: 2)
     aac:	281e0068 	ldmdacs	lr, {r3, r5, r6}
     ab0:	01000002 	tsteq	r0, r2
     ab4:	05ab0620 	streq	r0, [fp, #1568]!	; 0x620
     ab8:	84000000 	strhi	r0, [r0], #-0
     abc:	00740000 	rsbseq	r0, r4, r0
     ac0:	9c010000 	stcls	0, cr0, [r1], {-0}
     ac4:	000005e5 	andeq	r0, r0, r5, ror #11
     ac8:	0003ed1b 	andeq	lr, r3, fp, lsl sp
     acc:	00035e00 	andeq	r5, r3, r0, lsl #28
     ad0:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     ad4:	6e69701c 	mcrvs	0, 3, r7, cr9, cr12, {0}
     ad8:	31200100 			; <UNDEFINED> instruction: 0x31200100
     adc:	00000054 	andeq	r0, r0, r4, asr r0
     ae0:	1c709102 	ldfnep	f1, [r0], #-8
     ae4:	00676572 	rsbeq	r6, r7, r2, ror r5
     ae8:	63402001 	movtvs	r2, #1
     aec:	02000003 	andeq	r0, r0, #3
     af0:	79196c91 	ldmdbvc	r9, {r0, r4, r7, sl, fp, sp, lr}
     af4:	01000007 	tsteq	r0, r7
     af8:	03634f20 	cmneq	r3, #32, 30	; 0x80
     afc:	91020000 	mrsls	r0, (UNDEF: 2)
     b00:	fa1e0068 	blx	780ca8 <_bss_end+0x777594>
     b04:	01000001 	tsteq	r0, r1
     b08:	05ff060c 	ldrbeq	r0, [pc, #1548]!	; 111c <shift+0x111c>
     b0c:	82ec0000 	rschi	r0, ip, #0
     b10:	01140000 	tsteq	r4, r0
     b14:	9c010000 	stcls	0, cr0, [r1], {-0}
     b18:	00000639 	andeq	r0, r0, r9, lsr r6
     b1c:	0003ed1b 	andeq	lr, r3, fp, lsl sp
     b20:	00035e00 	andeq	r5, r3, r0, lsl #28
     b24:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     b28:	6e69701c 	mcrvs	0, 3, r7, cr9, cr12, {0}
     b2c:	320c0100 	andcc	r0, ip, #0, 2
     b30:	00000054 	andeq	r0, r0, r4, asr r0
     b34:	1c709102 	ldfnep	f1, [r0], #-8
     b38:	00676572 	rsbeq	r6, r7, r2, ror r5
     b3c:	63410c01 	movtvs	r0, #7169	; 0x1c01
     b40:	02000003 	andeq	r0, r0, #3
     b44:	79196c91 	ldmdbvc	r9, {r0, r4, r7, sl, fp, sp, lr}
     b48:	01000007 	tsteq	r0, r7
     b4c:	0363500c 	cmneq	r3, #12
     b50:	91020000 	mrsls	r0, (UNDEF: 2)
     b54:	b21f0068 	andslt	r0, pc, #104	; 0x68
     b58:	01000002 	tsteq	r0, r2
     b5c:	064a0106 	strbeq	r0, [sl], -r6, lsl #2
     b60:	60000000 	andvs	r0, r0, r0
     b64:	20000006 	andcs	r0, r0, r6
     b68:	000003ed 	andeq	r0, r0, sp, ror #7
     b6c:	0000036f 	andeq	r0, r0, pc, ror #6
     b70:	0006ee21 	andeq	lr, r6, r1, lsr #28
     b74:	2b060100 	blcs	180f7c <_bss_end+0x177868>
     b78:	00000065 	andeq	r0, r0, r5, rrx
     b7c:	06392200 	ldrteq	r2, [r9], -r0, lsl #4
     b80:	06230000 	strteq	r0, [r3], -r0
     b84:	06770000 	ldrbteq	r0, [r7], -r0
     b88:	82b80000 	adcshi	r0, r8, #0
     b8c:	00340000 	eorseq	r0, r4, r0
     b90:	9c010000 	stcls	0, cr0, [r1], {-0}
     b94:	00064a23 	andeq	r4, r6, r3, lsr #20
     b98:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     b9c:	00065323 	andeq	r5, r6, r3, lsr #6
     ba0:	70910200 	addsvc	r0, r1, r0, lsl #4
     ba4:	06b40000 	ldrteq	r0, [r4], r0
     ba8:	00040000 	andeq	r0, r4, r0
     bac:	00000547 	andeq	r0, r0, r7, asr #10
     bb0:	00970104 	addseq	r0, r7, r4, lsl #2
     bb4:	27040000 	strcs	r0, [r4, -r0]
     bb8:	5800000a 	stmdapl	r0, {r1, r3}
	...
     bc4:	9c000000 	stcls	0, cr0, [r0], {-0}
     bc8:	02000004 	andeq	r0, r0, #4
     bcc:	0000090d 	andeq	r0, r0, sp, lsl #18
     bd0:	07030218 	smladeq	r3, r8, r2, r0
     bd4:	00000266 	andeq	r0, r0, r6, ror #4
     bd8:	00088b03 	andeq	r8, r8, r3, lsl #22
     bdc:	66040700 	strvs	r0, [r4], -r0, lsl #14
     be0:	02000002 	andeq	r0, r0, #2
     be4:	52011006 	andpl	r1, r1, #6
     be8:	04000000 	streq	r0, [r0], #-0
     bec:	00584548 	subseq	r4, r8, r8, asr #10
     bf0:	45440410 	strbmi	r0, [r4, #-1040]	; 0xfffffbf0
     bf4:	000a0043 	andeq	r0, sl, r3, asr #32
     bf8:	00003205 	andeq	r3, r0, r5, lsl #4
     bfc:	08980600 	ldmeq	r8, {r9, sl}
     c00:	02080000 	andeq	r0, r8, #0
     c04:	007b0c24 	rsbseq	r0, fp, r4, lsr #24
     c08:	79070000 	stmdbvc	r7, {}	; <UNPREDICTABLE>
     c0c:	16260200 	strtne	r0, [r6], -r0, lsl #4
     c10:	00000266 	andeq	r0, r0, r6, ror #4
     c14:	00780700 	rsbseq	r0, r8, r0, lsl #14
     c18:	66162702 	ldrvs	r2, [r6], -r2, lsl #14
     c1c:	04000002 	streq	r0, [r0], #-2
     c20:	09ea0800 	stmibeq	sl!, {fp}^
     c24:	0c020000 	stceq	0, cr0, [r2], {-0}
     c28:	0000521b 	andeq	r5, r0, fp, lsl r2
     c2c:	090a0100 	stmdbeq	sl, {r8}
     c30:	0000095d 	andeq	r0, r0, sp, asr r9
     c34:	78280d02 	stmdavc	r8!, {r1, r8, sl, fp}
     c38:	01000002 	tsteq	r0, r2
     c3c:	00090d0a 	andeq	r0, r9, sl, lsl #26
     c40:	0e100200 	cdpeq	2, 1, cr0, cr0, cr0, {0}
     c44:	000009d7 	ldrdeq	r0, [r0], -r7
     c48:	00000289 	andeq	r0, r0, r9, lsl #5
     c4c:	0000af01 	andeq	sl, r0, r1, lsl #30
     c50:	0000c400 	andeq	ip, r0, r0, lsl #8
     c54:	02890b00 	addeq	r0, r9, #0, 22
     c58:	660c0000 	strvs	r0, [ip], -r0
     c5c:	0c000002 	stceq	0, cr0, [r0], {2}
     c60:	00000266 	andeq	r0, r0, r6, ror #4
     c64:	0002660c 	andeq	r6, r2, ip, lsl #12
     c68:	340d0000 	strcc	r0, [sp], #-0
     c6c:	02000008 	andeq	r0, r0, #8
     c70:	08f80a12 	ldmeq	r8!, {r1, r4, r9, fp}^
     c74:	d9010000 	stmdble	r1, {}	; <UNPREDICTABLE>
     c78:	df000000 	svcle	0x00000000
     c7c:	0b000000 	bleq	c84 <shift+0xc84>
     c80:	00000289 	andeq	r0, r0, r9, lsl #5
     c84:	09160e00 	ldmdbeq	r6, {r9, sl, fp}
     c88:	14020000 	strne	r0, [r2], #-0
     c8c:	00097a0f 	andeq	r7, r9, pc, lsl #20
     c90:	00029400 	andeq	r9, r2, r0, lsl #8
     c94:	00f80100 	rscseq	r0, r8, r0, lsl #2
     c98:	01030000 	mrseq	r0, (UNDEF: 3)
     c9c:	890b0000 	stmdbhi	fp, {}	; <UNPREDICTABLE>
     ca0:	0c000002 	stceq	0, cr0, [r0], {2}
     ca4:	0000027d 	andeq	r0, r0, sp, ror r2
     ca8:	09160e00 	ldmdbeq	r6, {r9, sl, fp}
     cac:	15020000 	strne	r0, [r2, #-0]
     cb0:	0009210f 	andeq	r2, r9, pc, lsl #2
     cb4:	00029400 	andeq	r9, r2, r0, lsl #8
     cb8:	011c0100 	tsteq	ip, r0, lsl #2
     cbc:	01270000 			; <UNDEFINED> instruction: 0x01270000
     cc0:	890b0000 	stmdbhi	fp, {}	; <UNPREDICTABLE>
     cc4:	0c000002 	stceq	0, cr0, [r0], {2}
     cc8:	00000272 	andeq	r0, r0, r2, ror r2
     ccc:	09160e00 	ldmdbeq	r6, {r9, sl, fp}
     cd0:	16020000 	strne	r0, [r2], -r0
     cd4:	0009fe0f 	andeq	pc, r9, pc, lsl #28
     cd8:	00029400 	andeq	r9, r2, r0, lsl #8
     cdc:	01400100 	mrseq	r0, (UNDEF: 80)
     ce0:	014b0000 	mrseq	r0, (UNDEF: 75)
     ce4:	890b0000 	stmdbhi	fp, {}	; <UNPREDICTABLE>
     ce8:	0c000002 	stceq	0, cr0, [r0], {2}
     cec:	00000032 	andeq	r0, r0, r2, lsr r0
     cf0:	09160e00 	ldmdbeq	r6, {r9, sl, fp}
     cf4:	17020000 	strne	r0, [r2, -r0]
     cf8:	0009a90f 	andeq	sl, r9, pc, lsl #18
     cfc:	00029400 	andeq	r9, r2, r0, lsl #8
     d00:	01640100 	cmneq	r4, r0, lsl #2
     d04:	016f0000 	cmneq	pc, r0
     d08:	890b0000 	stmdbhi	fp, {}	; <UNPREDICTABLE>
     d0c:	0c000002 	stceq	0, cr0, [r0], {2}
     d10:	00000266 	andeq	r0, r0, r6, ror #4
     d14:	09160e00 	ldmdbeq	r6, {r9, sl, fp}
     d18:	18020000 	stmdane	r2, {}	; <UNPREDICTABLE>
     d1c:	0009690f 	andeq	r6, r9, pc, lsl #18
     d20:	00029400 	andeq	r9, r2, r0, lsl #8
     d24:	01880100 	orreq	r0, r8, r0, lsl #2
     d28:	01930000 	orrseq	r0, r3, r0
     d2c:	890b0000 	stmdbhi	fp, {}	; <UNPREDICTABLE>
     d30:	0c000002 	stceq	0, cr0, [r0], {2}
     d34:	0000029a 	muleq	r0, sl, r2
     d38:	087d0f00 	ldmdaeq	sp!, {r8, r9, sl, fp}^
     d3c:	1b020000 	blne	80d44 <_bss_end+0x77630>
     d40:	00084d11 	andeq	r4, r8, r1, lsl sp
     d44:	0001a700 	andeq	sl, r1, r0, lsl #14
     d48:	0001ad00 	andeq	sl, r1, r0, lsl #26
     d4c:	02890b00 	addeq	r0, r9, #0, 22
     d50:	0f000000 	svceq	0x00000000
     d54:	00000870 	andeq	r0, r0, r0, ror r8
     d58:	ba111c02 	blt	447d68 <_bss_end+0x43e654>
     d5c:	c1000009 	tstgt	r0, r9
     d60:	c7000001 	strgt	r0, [r0, -r1]
     d64:	0b000001 	bleq	d70 <shift+0xd70>
     d68:	00000289 	andeq	r0, r0, r9, lsl #5
     d6c:	08220f00 	stmdaeq	r2!, {r8, r9, sl, fp}
     d70:	1d020000 	stcne	0, cr0, [r2, #-0]
     d74:	0008a211 	andeq	sl, r8, r1, lsl r2
     d78:	0001db00 	andeq	sp, r1, r0, lsl #22
     d7c:	0001e100 	andeq	lr, r1, r0, lsl #2
     d80:	02890b00 	addeq	r0, r9, #0, 22
     d84:	0f000000 	svceq	0x00000000
     d88:	0000080d 	andeq	r0, r0, sp, lsl #16
     d8c:	930a1f02 	movwls	r1, #44802	; 0xaf02
     d90:	f5000009 			; <UNDEFINED> instruction: 0xf5000009
     d94:	fb000001 	blx	da2 <shift+0xda2>
     d98:	0b000001 	bleq	da4 <shift+0xda4>
     d9c:	00000289 	andeq	r0, r0, r9, lsl #5
     da0:	086b0f00 	stmdaeq	fp!, {r8, r9, sl, fp}^
     da4:	21020000 	mrscs	r0, (UNDEF: 2)
     da8:	0009340a 	andeq	r3, r9, sl, lsl #8
     dac:	00020f00 	andeq	r0, r2, r0, lsl #30
     db0:	00022400 	andeq	r2, r2, r0, lsl #8
     db4:	02890b00 	addeq	r0, r9, #0, 22
     db8:	660c0000 	strvs	r0, [ip], -r0
     dbc:	0c000002 	stceq	0, cr0, [r0], {2}
     dc0:	000002a1 	andeq	r0, r0, r1, lsr #5
     dc4:	0002660c 	andeq	r6, r2, ip, lsl #12
     dc8:	c4100000 	ldrgt	r0, [r0], #-0
     dcc:	02000008 	andeq	r0, r0, #8
     dd0:	02ad232b 	adceq	r2, sp, #-1409286144	; 0xac000000
     dd4:	10000000 	andne	r0, r0, r0
     dd8:	0000098b 	andeq	r0, r0, fp, lsl #19
     ddc:	66122c02 	ldrvs	r2, [r2], -r2, lsl #24
     de0:	04000002 	streq	r0, [r0], #-2
     de4:	00094b10 	andeq	r4, r9, r0, lsl fp
     de8:	122d0200 	eorne	r0, sp, #0, 4
     dec:	00000266 	andeq	r0, r0, r6, ror #4
     df0:	09541008 	ldmdbeq	r4, {r3, ip}^
     df4:	2e020000 	cdpcs	0, 0, cr0, cr2, cr0, {0}
     df8:	0000570f 	andeq	r5, r0, pc, lsl #14
     dfc:	14100c00 	ldrne	r0, [r0], #-3072	; 0xfffff400
     e00:	02000008 	andeq	r0, r0, #8
     e04:	0032122f 	eorseq	r1, r2, pc, lsr #4
     e08:	00140000 	andseq	r0, r4, r0
     e0c:	13070411 	movwne	r0, #29713	; 0x7411
     e10:	05000011 	streq	r0, [r0, #-17]	; 0xffffffef
     e14:	00000266 	andeq	r0, r0, r6, ror #4
     e18:	02840412 	addeq	r0, r4, #301989888	; 0x12000000
     e1c:	72050000 	andvc	r0, r5, #0
     e20:	11000002 	tstne	r0, r2
     e24:	02d10801 	sbcseq	r0, r1, #65536	; 0x10000
     e28:	7d050000 	stcvc	0, cr0, [r5, #-0]
     e2c:	12000002 	andne	r0, r0, #2
     e30:	00002504 	andeq	r2, r0, r4, lsl #10
     e34:	02890500 	addeq	r0, r9, #0, 10
     e38:	04130000 	ldreq	r0, [r3], #-0
     e3c:	00000025 	andeq	r0, r0, r5, lsr #32
     e40:	91020111 	tstls	r2, r1, lsl r1
     e44:	12000005 	andne	r0, r0, #5
     e48:	00027d04 	andeq	r7, r2, r4, lsl #26
     e4c:	b9041200 	stmdblt	r4, {r9, ip}
     e50:	05000002 	streq	r0, [r0, #-2]
     e54:	000002a7 	andeq	r0, r0, r7, lsr #5
     e58:	c8080111 	stmdagt	r8, {r0, r4, r8}
     e5c:	14000002 	strne	r0, [r0], #-2
     e60:	000002b2 			; <UNDEFINED> instruction: 0x000002b2
     e64:	0008dd15 	andeq	sp, r8, r5, lsl sp
     e68:	11320200 	teqne	r2, r0, lsl #4
     e6c:	00000025 	andeq	r0, r0, r5, lsr #32
     e70:	0002be16 	andeq	fp, r2, r6, lsl lr
     e74:	0a030100 	beq	c127c <_bss_end+0xb7b68>
     e78:	96d80305 	ldrbls	r0, [r8], r5, lsl #6
     e7c:	ce170000 	cdpgt	0, 1, cr0, cr7, cr0, {0}
     e80:	e4000008 	str	r0, [r0], #-8
     e84:	1c00008d 	stcne	0, cr0, [r0], {141}	; 0x8d
     e88:	01000000 	mrseq	r0, (UNDEF: 0)
     e8c:	03b8189c 			; <UNDEFINED> instruction: 0x03b8189c
     e90:	8d8c0000 	stchi	0, cr0, [ip]
     e94:	00580000 	subseq	r0, r8, r0
     e98:	9c010000 	stcls	0, cr0, [r1], {-0}
     e9c:	00000319 	andeq	r0, r0, r9, lsl r3
     ea0:	00029c19 	andeq	r9, r2, r9, lsl ip
     ea4:	01a20100 			; <UNDEFINED> instruction: 0x01a20100
     ea8:	00000319 	andeq	r0, r0, r9, lsl r3
     eac:	19749102 	ldmdbne	r4!, {r1, r8, ip, pc}^
     eb0:	000003e2 	andeq	r0, r0, r2, ror #7
     eb4:	1901a201 	stmdbne	r1, {r0, r9, sp, pc}
     eb8:	02000003 	andeq	r0, r0, #3
     ebc:	1a007091 	bne	1d108 <_bss_end+0x139f4>
     ec0:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
     ec4:	fb1b0074 	blx	6c109e <_bss_end+0x6b798a>
     ec8:	01000001 	tsteq	r0, r1
     ecc:	033a0687 	teqeq	sl, #141557760	; 0x8700000
     ed0:	8c100000 	ldchi	0, cr0, [r0], {-0}
     ed4:	017c0000 	cmneq	ip, r0
     ed8:	9c010000 	stcls	0, cr0, [r1], {-0}
     edc:	000003af 	andeq	r0, r0, pc, lsr #7
     ee0:	0003ed1c 	andeq	lr, r3, ip, lsl sp
     ee4:	00028f00 	andeq	r8, r2, r0, lsl #30
     ee8:	64910200 	ldrvs	r0, [r1], #512	; 0x200
     eec:	000a6519 	andeq	r6, sl, r9, lsl r5
     ef0:	22870100 	addcs	r0, r7, #0, 2
     ef4:	00000266 	andeq	r0, r0, r6, ror #4
     ef8:	19609102 	stmdbne	r0!, {r1, r8, ip, pc}^
     efc:	00000a20 	andeq	r0, r0, r0, lsr #20
     f00:	a12f8701 			; <UNDEFINED> instruction: 0xa12f8701
     f04:	02000002 	andeq	r0, r0, #2
     f08:	0d195c91 	ldceq	12, cr5, [r9, #-580]	; 0xfffffdbc
     f0c:	0100000e 	tsteq	r0, lr
     f10:	02664487 	rsbeq	r4, r6, #-2030043136	; 0x87000000
     f14:	91020000 	mrsls	r0, (UNDEF: 2)
     f18:	00691d58 	rsbeq	r1, r9, r8, asr sp
     f1c:	19098901 	stmdbne	r9, {r0, r8, fp, pc}
     f20:	02000003 	andeq	r0, r0, #3
     f24:	e41e7491 	ldr	r7, [lr], #-1169	; 0xfffffb6f
     f28:	9800008c 	stmdals	r0, {r2, r3, r7}
     f2c:	1d000000 	stcne	0, cr0, [r0, #-0]
     f30:	9c01006a 	stcls	0, cr0, [r1], {106}	; 0x6a
     f34:	0003190e 	andeq	r1, r3, lr, lsl #18
     f38:	70910200 	addsvc	r0, r1, r0, lsl #4
     f3c:	008d0c1e 	addeq	r0, sp, lr, lsl ip
     f40:	00006000 	andeq	r6, r0, r0
     f44:	00631d00 	rsbeq	r1, r3, r0, lsl #26
     f48:	7d0e9e01 	stcvc	14, cr9, [lr, #-4]
     f4c:	02000002 	andeq	r0, r0, #2
     f50:	00006f91 	muleq	r0, r1, pc	; <UNPREDICTABLE>
     f54:	016f1b00 	cmneq	pc, r0, lsl #22
     f58:	77010000 	strvc	r0, [r1, -r0]
     f5c:	0003c90b 	andeq	ip, r3, fp, lsl #18
     f60:	008bb000 	addeq	fp, fp, r0
     f64:	00006000 	andeq	r6, r0, r0
     f68:	e59c0100 	ldr	r0, [ip, #256]	; 0x100
     f6c:	1c000003 	stcne	0, cr0, [r0], {3}
     f70:	000003ed 	andeq	r0, r0, sp, ror #7
     f74:	0000028f 	andeq	r0, r0, pc, lsl #5
     f78:	19749102 	ldmdbne	r4!, {r1, r8, ip, pc}^
     f7c:	000001d7 	ldrdeq	r0, [r0], -r7
     f80:	9a257701 	bls	95eb8c <_bss_end+0x955478>
     f84:	02000002 	andeq	r0, r0, #2
     f88:	1b007391 	blne	1ddd4 <_bss_end+0x146c0>
     f8c:	0000014b 	andeq	r0, r0, fp, asr #2
     f90:	ff0b6a01 			; <UNDEFINED> instruction: 0xff0b6a01
     f94:	5c000003 	stcpl	0, cr0, [r0], {3}
     f98:	5400008b 	strpl	r0, [r0], #-139	; 0xffffff75
     f9c:	01000000 	mrseq	r0, (UNDEF: 0)
     fa0:	00043f9c 	muleq	r4, ip, pc	; <UNPREDICTABLE>
     fa4:	03ed1c00 	mvneq	r1, #0, 24
     fa8:	028f0000 	addeq	r0, pc, #0
     fac:	91020000 	mrsls	r0, (UNDEF: 2)
     fb0:	756e1f74 	strbvc	r1, [lr, #-3956]!	; 0xfffff08c
     fb4:	6a01006d 	bvs	41170 <_bss_end+0x37a5c>
     fb8:	0002662d 	andeq	r6, r2, sp, lsr #12
     fbc:	70910200 	addsvc	r0, r1, r0, lsl #4
     fc0:	000a7420 	andeq	r7, sl, r0, lsr #8
     fc4:	236c0100 	cmncs	ip, #0, 2
     fc8:	0000026d 	andeq	r0, r0, sp, ror #4
     fcc:	96500305 	ldrbls	r0, [r0], -r5, lsl #6
     fd0:	6b210000 	blvs	840fd8 <_bss_end+0x8378c4>
     fd4:	0100000a 	tsteq	r0, sl
     fd8:	043f116e 	ldrteq	r1, [pc], #-366	; fe0 <shift+0xfe0>
     fdc:	03050000 	movweq	r0, #20480	; 0x5000
     fe0:	000096f0 	strdeq	r9, [r0], -r0
     fe4:	027d2200 	rsbseq	r2, sp, #0, 4
     fe8:	044f0000 	strbeq	r0, [pc], #-0	; ff0 <shift+0xff0>
     fec:	66230000 	strtvs	r0, [r3], -r0
     ff0:	0f000002 	svceq	0x00000002
     ff4:	01272400 			; <UNDEFINED> instruction: 0x01272400
     ff8:	63010000 	movwvs	r0, #4096	; 0x1000
     ffc:	0004690b 	andeq	r6, r4, fp, lsl #18
    1000:	008b2800 	addeq	r2, fp, r0, lsl #16
    1004:	00003400 	andeq	r3, r0, r0, lsl #8
    1008:	859c0100 	ldrhi	r0, [ip, #256]	; 0x100
    100c:	1c000004 	stcne	0, cr0, [r0], {4}
    1010:	000003ed 	andeq	r0, r0, sp, ror #7
    1014:	0000028f 	andeq	r0, r0, pc, lsl #5
    1018:	19749102 	ldmdbne	r4!, {r1, r8, ip, pc}^
    101c:	00000816 	andeq	r0, r0, r6, lsl r8
    1020:	32376301 	eorscc	r6, r7, #67108864	; 0x4000000
    1024:	02000000 	andeq	r0, r0, #0
    1028:	1b007091 	blne	1d274 <_bss_end+0x13b60>
    102c:	00000103 	andeq	r0, r0, r3, lsl #2
    1030:	9f0b5701 	svcls	0x000b5701
    1034:	b0000004 	andlt	r0, r0, r4
    1038:	7800008a 	stmdavc	r0, {r1, r3, r7}
    103c:	01000000 	mrseq	r0, (UNDEF: 0)
    1040:	0004d29c 	muleq	r4, ip, r2
    1044:	03ed1c00 	mvneq	r1, #0, 24
    1048:	028f0000 	addeq	r0, pc, #0
    104c:	91020000 	mrsls	r0, (UNDEF: 2)
    1050:	74731f6c 	ldrbtvc	r1, [r3], #-3948	; 0xfffff094
    1054:	57010072 	smlsdxpl	r1, r2, r0, r0
    1058:	0002722c 	andeq	r7, r2, ip, lsr #4
    105c:	68910200 	ldmvs	r1, {r9}
    1060:	008ac41e 	addeq	ip, sl, lr, lsl r4
    1064:	00004c00 	andeq	r4, r0, r0, lsl #24
    1068:	00691d00 	rsbeq	r1, r9, r0, lsl #26
    106c:	66175901 	ldrvs	r5, [r7], -r1, lsl #18
    1070:	02000002 	andeq	r0, r0, #2
    1074:	00007491 	muleq	r0, r1, r4
    1078:	0000df1b 	andeq	sp, r0, fp, lsl pc
    107c:	0b450100 	bleq	1141484 <_bss_end+0x1137d70>
    1080:	000004ec 	andeq	r0, r0, ip, ror #9
    1084:	00008a08 	andeq	r8, r0, r8, lsl #20
    1088:	000000a8 	andeq	r0, r0, r8, lsr #1
    108c:	05069c01 	streq	r9, [r6, #-3073]	; 0xfffff3ff
    1090:	ed1c0000 	ldc	0, cr0, [ip, #-0]
    1094:	8f000003 	svchi	0x00000003
    1098:	02000002 	andeq	r0, r0, #2
    109c:	631f7491 	tstvs	pc, #-1862270976	; 0x91000000
    10a0:	25450100 	strbcs	r0, [r5, #-256]	; 0xffffff00
    10a4:	0000027d 	andeq	r0, r0, sp, ror r2
    10a8:	00739102 	rsbseq	r9, r3, r2, lsl #2
    10ac:	0001c724 	andeq	ip, r1, r4, lsr #14
    10b0:	06400100 	strbeq	r0, [r0], -r0, lsl #2
    10b4:	00000520 	andeq	r0, r0, r0, lsr #10
    10b8:	00008ec0 	andeq	r8, r0, r0, asr #29
    10bc:	0000002c 	andeq	r0, r0, ip, lsr #32
    10c0:	052d9c01 	streq	r9, [sp, #-3073]!	; 0xfffff3ff
    10c4:	ed1c0000 	ldc	0, cr0, [ip, #-0]
    10c8:	8f000003 	svchi	0x00000003
    10cc:	02000002 	andeq	r0, r0, #2
    10d0:	24007491 	strcs	r7, [r0], #-1169	; 0xfffffb6f
    10d4:	000001e1 	andeq	r0, r0, r1, ror #3
    10d8:	47063001 	strmi	r3, [r6, -r1]
    10dc:	d8000005 	stmdale	r0, {r0, r2}
    10e0:	30000088 	andcc	r0, r0, r8, lsl #1
    10e4:	01000001 	tsteq	r0, r1
    10e8:	00059d9c 	muleq	r5, ip, sp
    10ec:	03ed1c00 	mvneq	r1, #0, 24
    10f0:	028f0000 	addeq	r0, pc, #0
    10f4:	91020000 	mrsls	r0, (UNDEF: 2)
    10f8:	88e82564 	stmiahi	r8!, {r2, r5, r6, r8, sl, sp}^
    10fc:	00b00000 	adcseq	r0, r0, r0
    1100:	05850000 	streq	r0, [r5]
    1104:	791d0000 	ldmdbvc	sp, {}	; <UNPREDICTABLE>
    1108:	17320100 	ldrne	r0, [r2, -r0, lsl #2]!
    110c:	00000266 	andeq	r0, r0, r6, ror #4
    1110:	1e749102 	expnes	f1, f2
    1114:	00008904 	andeq	r8, r0, r4, lsl #18
    1118:	00000084 	andeq	r0, r0, r4, lsl #1
    111c:	0100781d 	tsteq	r0, sp, lsl r8
    1120:	02661b34 	rsbeq	r1, r6, #52, 22	; 0xd000
    1124:	91020000 	mrsls	r0, (UNDEF: 2)
    1128:	1e000070 	mcrne	0, 0, r0, cr0, cr0, {3}
    112c:	00008998 	muleq	r0, r8, r9
    1130:	00000060 	andeq	r0, r0, r0, rrx
    1134:	0100781d 	tsteq	r0, sp, lsl r8
    1138:	0266173a 	rsbeq	r1, r6, #15204352	; 0xe80000
    113c:	91020000 	mrsls	r0, (UNDEF: 2)
    1140:	1b00006c 	blne	12f8 <shift+0x12f8>
    1144:	00000193 	muleq	r0, r3, r1
    1148:	b7062101 	strlt	r2, [r6, -r1, lsl #2]
    114c:	38000005 	stmdacc	r0, {r0, r2}
    1150:	8800008e 	stmdahi	r0, {r1, r2, r3, r7}
    1154:	01000000 	mrseq	r0, (UNDEF: 0)
    1158:	0005c49c 	muleq	r5, ip, r4
    115c:	03ed1c00 	mvneq	r1, #0, 24
    1160:	028f0000 	addeq	r0, pc, #0
    1164:	91020000 	mrsls	r0, (UNDEF: 2)
    1168:	c41b0074 	ldrgt	r0, [fp], #-116	; 0xffffff8c
    116c:	01000000 	mrseq	r0, (UNDEF: 0)
    1170:	05de0614 	ldrbeq	r0, [lr, #1556]	; 0x614
    1174:	88300000 	ldmdahi	r0!, {}	; <UNPREDICTABLE>
    1178:	00a80000 	adceq	r0, r8, r0
    117c:	9c010000 	stcls	0, cr0, [r1], {-0}
    1180:	00000619 	andeq	r0, r0, r9, lsl r6
    1184:	0003ed1c 	andeq	lr, r3, ip, lsl sp
    1188:	00028f00 	andeq	r8, r2, r0, lsl #30
    118c:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1190:	0088481e 	addeq	r4, r8, lr, lsl r8
    1194:	00008400 	andeq	r8, r0, r0, lsl #8
    1198:	00791d00 	rsbseq	r1, r9, r0, lsl #26
    119c:	66171801 	ldrvs	r1, [r7], -r1, lsl #16
    11a0:	02000002 	andeq	r0, r0, #2
    11a4:	641e7491 	ldrvs	r7, [lr], #-1169	; 0xfffffb6f
    11a8:	58000088 	stmdapl	r0, {r3, r7}
    11ac:	1d000000 	stcne	0, cr0, [r0, #-0]
    11b0:	1a010078 	bne	41398 <_bss_end+0x37c84>
    11b4:	0002661b 	andeq	r6, r2, fp, lsl r6
    11b8:	70910200 	addsvc	r0, r1, r0, lsl #4
    11bc:	24000000 	strcs	r0, [r0], #-0
    11c0:	000001ad 	andeq	r0, r0, sp, lsr #3
    11c4:	33060e01 	movwcc	r0, #28161	; 0x6e01
    11c8:	00000006 	andeq	r0, r0, r6
    11cc:	3800008e 	stmdacc	r0, {r1, r2, r3, r7}
    11d0:	01000000 	mrseq	r0, (UNDEF: 0)
    11d4:	0006409c 	muleq	r6, ip, r0
    11d8:	03ed1c00 	mvneq	r1, #0, 24
    11dc:	028f0000 	addeq	r0, pc, #0
    11e0:	91020000 	mrsls	r0, (UNDEF: 2)
    11e4:	96260074 			; <UNDEFINED> instruction: 0x96260074
    11e8:	01000000 	mrseq	r0, (UNDEF: 0)
    11ec:	06510105 	ldrbeq	r0, [r1], -r5, lsl #2
    11f0:	7f000000 	svcvc	0x00000000
    11f4:	27000006 	strcs	r0, [r0, -r6]
    11f8:	000003ed 	andeq	r0, r0, sp, ror #7
    11fc:	0000028f 	andeq	r0, r0, pc, lsl #5
    1200:	0008e628 	andeq	lr, r8, r8, lsr #12
    1204:	21050100 	mrscs	r0, (UNDEF: 21)
    1208:	00000266 	andeq	r0, r0, r6, ror #4
    120c:	00098d28 	andeq	r8, r9, r8, lsr #26
    1210:	41050100 	mrsmi	r0, (UNDEF: 21)
    1214:	00000266 	andeq	r0, r0, r6, ror #4
    1218:	00094d28 	andeq	r4, r9, r8, lsr #26
    121c:	55050100 	strpl	r0, [r5, #-256]	; 0xffffff00
    1220:	00000266 	andeq	r0, r0, r6, ror #4
    1224:	06402900 	strbeq	r2, [r0], -r0, lsl #18
    1228:	083a0000 	ldmdaeq	sl!, {}	; <UNPREDICTABLE>
    122c:	06960000 	ldreq	r0, [r6], r0
    1230:	87b80000 	ldrhi	r0, [r8, r0]!
    1234:	00780000 	rsbseq	r0, r8, r0
    1238:	9c010000 	stcls	0, cr0, [r1], {-0}
    123c:	0006512a 	andeq	r5, r6, sl, lsr #2
    1240:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1244:	00065a2a 	andeq	r5, r6, sl, lsr #20
    1248:	70910200 	addsvc	r0, r1, r0, lsl #4
    124c:	0006662a 	andeq	r6, r6, sl, lsr #12
    1250:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1254:	0006722a 	andeq	r7, r6, sl, lsr #4
    1258:	68910200 	ldmvs	r1, {r9}
    125c:	056f0000 	strbeq	r0, [pc, #-0]!	; 1264 <shift+0x1264>
    1260:	00040000 	andeq	r0, r4, r0
    1264:	000007ef 	andeq	r0, r0, pc, ror #15
    1268:	00970104 	addseq	r0, r7, r4, lsl #2
    126c:	f7040000 			; <UNDEFINED> instruction: 0xf7040000
    1270:	5800000a 	stmdapl	r0, {r1, r3}
    1274:	ec000000 	stc	0, cr0, [r0], {-0}
    1278:	fc00008e 	stc2	0, cr0, [r0], {142}	; 0x8e
    127c:	51000002 	tstpl	r0, r2
    1280:	02000008 	andeq	r0, r0, #8
    1284:	02d10801 	sbcseq	r0, r1, #65536	; 0x10000
    1288:	25030000 	strcs	r0, [r3, #-0]
    128c:	02000000 	andeq	r0, r0, #0
    1290:	018a0502 	orreq	r0, sl, r2, lsl #10
    1294:	04040000 	streq	r0, [r4], #-0
    1298:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
    129c:	08010200 	stmdaeq	r1, {r9}
    12a0:	000002c8 	andeq	r0, r0, r8, asr #5
    12a4:	6b070202 	blvs	1c1ab4 <_bss_end+0x1b83a0>
    12a8:	05000003 	streq	r0, [r0, #-3]
    12ac:	00000339 	andeq	r0, r0, r9, lsr r3
    12b0:	5e070b05 	vmlapl.f64	d0, d7, d5
    12b4:	03000000 	movweq	r0, #0
    12b8:	0000004d 	andeq	r0, r0, sp, asr #32
    12bc:	13070402 	movwne	r0, #29698	; 0x7402
    12c0:	03000011 	movweq	r0, #17
    12c4:	0000005e 	andeq	r0, r0, lr, asr r0
    12c8:	6c616806 	stclvs	8, cr6, [r1], #-24	; 0xffffffe8
    12cc:	0b070200 	bleq	1c1ad4 <_bss_end+0x1b83c0>
    12d0:	00000172 	andeq	r0, r0, r2, ror r1
    12d4:	00028c07 	andeq	r8, r2, r7, lsl #24
    12d8:	1a0a0200 	bne	281ae0 <_bss_end+0x2783cc>
    12dc:	00000179 	andeq	r0, r0, r9, ror r1
    12e0:	20000000 	andcs	r0, r0, r0
    12e4:	00032207 	andeq	r2, r3, r7, lsl #4
    12e8:	1a0d0200 	bne	341af0 <_bss_end+0x3383dc>
    12ec:	00000179 	andeq	r0, r0, r9, ror r1
    12f0:	20200000 	eorcs	r0, r0, r0
    12f4:	0003a908 	andeq	sl, r3, r8, lsl #18
    12f8:	15100200 	ldrne	r0, [r0, #-512]	; 0xfffffe00
    12fc:	00000059 	andeq	r0, r0, r9, asr r0
    1300:	040b0736 	streq	r0, [fp], #-1846	; 0xfffff8ca
    1304:	42020000 	andmi	r0, r2, #0
    1308:	0001791a 	andeq	r7, r1, sl, lsl r9
    130c:	21500000 	cmpcs	r0, r0
    1310:	01a90920 			; <UNDEFINED> instruction: 0x01a90920
    1314:	04050000 	streq	r0, [r5], #-0
    1318:	00000038 	andeq	r0, r0, r8, lsr r0
    131c:	500d4402 	andpl	r4, sp, r2, lsl #8
    1320:	0a000001 	beq	132c <shift+0x132c>
    1324:	00515249 	subseq	r5, r1, r9, asr #4
    1328:	01e60b00 	mvneq	r0, r0, lsl #22
    132c:	0b010000 	bleq	41334 <_bss_end+0x37c20>
    1330:	0000042b 	andeq	r0, r0, fp, lsr #8
    1334:	03140b10 	tsteq	r4, #16, 22	; 0x4000
    1338:	0b110000 	bleq	441340 <_bss_end+0x437c2c>
    133c:	00000357 	andeq	r0, r0, r7, asr r3
    1340:	03860b12 	orreq	r0, r6, #18432	; 0x4800
    1344:	0b130000 	bleq	4c134c <_bss_end+0x4b7c38>
    1348:	0000031b 	andeq	r0, r0, fp, lsl r3
    134c:	043a0b14 	ldrteq	r0, [sl], #-2836	; 0xfffff4ec
    1350:	0b150000 	bleq	541358 <_bss_end+0x537c44>
    1354:	000003ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    1358:	04720b16 	ldrbteq	r0, [r2], #-2838	; 0xfffff4ea
    135c:	0b170000 	bleq	5c1364 <_bss_end+0x5b7c50>
    1360:	0000035e 	andeq	r0, r0, lr, asr r3
    1364:	04140b18 	ldreq	r0, [r4], #-2840	; 0xfffff4e8
    1368:	0b190000 	bleq	641370 <_bss_end+0x637c5c>
    136c:	00000397 	muleq	r0, r7, r3
    1370:	02760b1a 	rsbseq	r0, r6, #26624	; 0x6800
    1374:	0b200000 	bleq	80137c <_bss_end+0x7f7c68>
    1378:	00000281 	andeq	r0, r0, r1, lsl #5
    137c:	039f0b21 	orrseq	r0, pc, #33792	; 0x8400
    1380:	0b220000 	bleq	881388 <_bss_end+0x877c74>
    1384:	0000025a 	andeq	r0, r0, sl, asr r2
    1388:	038d0b24 	orreq	r0, sp, #36, 22	; 0x9000
    138c:	0b250000 	bleq	941394 <_bss_end+0x937c80>
    1390:	000002ab 	andeq	r0, r0, fp, lsr #5
    1394:	02b60b30 	adcseq	r0, r6, #48, 22	; 0xc000
    1398:	0b310000 	bleq	c413a0 <_bss_end+0xc37c8c>
    139c:	0000019e 	muleq	r0, lr, r1
    13a0:	037e0b32 	cmneq	lr, #51200	; 0xc800
    13a4:	0b340000 	bleq	d013ac <_bss_end+0xcf7c98>
    13a8:	00000194 	muleq	r0, r4, r1
    13ac:	160c0035 			; <UNDEFINED> instruction: 0x160c0035
    13b0:	05000002 	streq	r0, [r0, #-2]
    13b4:	00003804 	andeq	r3, r0, r4, lsl #16
    13b8:	0d6a0200 	sfmeq	f0, 2, [sl, #-0]
    13bc:	0004310b 	andeq	r3, r4, fp, lsl #2
    13c0:	660b0000 	strvs	r0, [fp], -r0
    13c4:	01000003 	tsteq	r0, r3
    13c8:	0004060b 	andeq	r0, r4, fp, lsl #12
    13cc:	00000200 	andeq	r0, r0, r0, lsl #4
    13d0:	0e070402 	cdpeq	4, 0, cr0, cr7, cr2, {0}
    13d4:	03000011 	movweq	r0, #17
    13d8:	00000172 	andeq	r0, r0, r2, ror r1
    13dc:	0000760d 	andeq	r7, r0, sp, lsl #12
    13e0:	00860d00 	addeq	r0, r6, r0, lsl #26
    13e4:	960d0000 	strls	r0, [sp], -r0
    13e8:	0d000000 	stceq	0, cr0, [r0, #-0]
    13ec:	000000a3 	andeq	r0, r0, r3, lsr #1
    13f0:	000aa10e 	andeq	sl, sl, lr, lsl #2
    13f4:	06030400 	streq	r0, [r3], -r0, lsl #8
    13f8:	00025607 	andeq	r5, r2, r7, lsl #12
    13fc:	01a80f00 			; <UNDEFINED> instruction: 0x01a80f00
    1400:	0a030000 	beq	c1408 <_bss_end+0xb7cf4>
    1404:	00025c1d 	andeq	r5, r2, sp, lsl ip
    1408:	a1100000 	tstge	r0, r0
    140c:	0300000a 	movweq	r0, #10
    1410:	0226090d 	eoreq	r0, r6, #212992	; 0x34000
    1414:	02610000 	rsbeq	r0, r1, #0
    1418:	c5010000 	strgt	r0, [r1, #-0]
    141c:	d0000001 	andle	r0, r0, r1
    1420:	11000001 	tstne	r0, r1
    1424:	00000261 	andeq	r0, r0, r1, ror #4
    1428:	00005e12 	andeq	r5, r0, r2, lsl lr
    142c:	c1130000 	tstgt	r3, r0
    1430:	03000002 	movweq	r0, #2
    1434:	01ee0e10 	mvneq	r0, r0, lsl lr
    1438:	e5010000 	str	r0, [r1, #-0]
    143c:	f0000001 			; <UNDEFINED> instruction: 0xf0000001
    1440:	11000001 	tstne	r0, r1
    1444:	00000261 	andeq	r0, r0, r1, ror #4
    1448:	00015012 	andeq	r5, r1, r2, lsl r0
    144c:	42130000 	andsmi	r0, r3, #0
    1450:	03000003 	movweq	r0, #3
    1454:	04490e12 	strbeq	r0, [r9], #-3602	; 0xfffff1ee
    1458:	05010000 	streq	r0, [r1, #-0]
    145c:	10000002 	andne	r0, r0, r2
    1460:	11000002 	tstne	r0, r2
    1464:	00000261 	andeq	r0, r0, r1, ror #4
    1468:	00015012 	andeq	r5, r1, r2, lsl r0
    146c:	f2130000 	vhadd.s16	d0, d3, d0
    1470:	03000003 	movweq	r0, #3
    1474:	02330e15 	eorseq	r0, r3, #336	; 0x150
    1478:	25010000 	strcs	r0, [r1, #-0]
    147c:	35000002 	strcc	r0, [r0, #-2]
    1480:	11000002 	tstne	r0, r2
    1484:	00000261 	andeq	r0, r0, r1, ror #4
    1488:	0000b312 	andeq	fp, r0, r2, lsl r3
    148c:	004d1200 	subeq	r1, sp, r0, lsl #4
    1490:	14000000 	strne	r0, [r0], #-0
    1494:	0000034a 	andeq	r0, r0, sl, asr #6
    1498:	b1121703 	tstlt	r2, r3, lsl #14
    149c:	4d000001 	stcmi	0, cr0, [r0, #-4]
    14a0:	01000000 	mrseq	r0, (UNDEF: 0)
    14a4:	0000024a 	andeq	r0, r0, sl, asr #4
    14a8:	00026111 	andeq	r6, r2, r1, lsl r1
    14ac:	00b31200 	adcseq	r1, r3, r0, lsl #4
    14b0:	00000000 	andeq	r0, r0, r0
    14b4:	005e0415 	subseq	r0, lr, r5, lsl r4
    14b8:	56030000 	strpl	r0, [r3], -r0
    14bc:	15000002 	strne	r0, [r0, #-2]
    14c0:	00019204 	andeq	r9, r1, r4, lsl #4
    14c4:	02711600 	rsbseq	r1, r1, #0, 12
    14c8:	1a030000 	bne	c14d0 <_bss_end+0xb7dbc>
    14cc:	0001920d 	andeq	r9, r1, sp, lsl #4
    14d0:	0b900900 	bleq	fe4038d8 <_bss_end+0xfe3fa1c4>
    14d4:	04050000 	streq	r0, [r5], #-0
    14d8:	00000038 	andeq	r0, r0, r8, lsr r0
    14dc:	920c0604 	andls	r0, ip, #4, 12	; 0x400000
    14e0:	0b000002 	bleq	14f0 <shift+0x14f0>
    14e4:	00000ace 	andeq	r0, r0, lr, asr #21
    14e8:	0ad50b00 	beq	ff5440f0 <_bss_end+0xff53a9dc>
    14ec:	00010000 	andeq	r0, r1, r0
    14f0:	000bf109 	andeq	pc, fp, r9, lsl #2
    14f4:	38040500 	stmdacc	r4, {r8, sl}
    14f8:	04000000 	streq	r0, [r0], #-0
    14fc:	02df0c0c 	sbcseq	r0, pc, #12, 24	; 0xc00
    1500:	46170000 	ldrmi	r0, [r7], -r0
    1504:	b000000b 	andlt	r0, r0, fp
    1508:	0c011704 	stceq	7, cr1, [r1], {4}
    150c:	09600000 	stmdbeq	r0!, {}^	; <UNPREDICTABLE>
    1510:	000bc017 	andeq	ip, fp, r7, lsl r0
    1514:	1712c000 	ldrne	ip, [r2, -r0]
    1518:	00000aa6 	andeq	r0, r0, r6, lsr #21
    151c:	b7172580 	ldrlt	r2, [r7, -r0, lsl #11]
    1520:	0000000b 	andeq	r0, r0, fp
    1524:	0a8a174b 	beq	fe287258 <_bss_end+0xfe27db44>
    1528:	96000000 	strls	r0, [r0], -r0
    152c:	000ab417 	andeq	fp, sl, r7, lsl r4
    1530:	18e10000 	stmiane	r1!, {}^	; <UNPREDICTABLE>
    1534:	00000a80 	andeq	r0, r0, r0, lsl #21
    1538:	0001c200 	andeq	ip, r1, r0, lsl #4
    153c:	0aae0e00 	beq	feb84d44 <_bss_end+0xfeb7b630>
    1540:	04040000 	streq	r0, [r4], #-0
    1544:	039a0718 	orrseq	r0, sl, #24, 14	; 0x600000
    1548:	dc0f0000 	stcle	0, cr0, [pc], {-0}
    154c:	0400000a 	streq	r0, [r0], #-10
    1550:	039a0f1b 	orrseq	r0, sl, #27, 30	; 0x6c
    1554:	10000000 	andne	r0, r0, r0
    1558:	00000aae 	andeq	r0, r0, lr, lsr #21
    155c:	60091e04 	andvs	r1, r9, r4, lsl #28
    1560:	a000000b 	andge	r0, r0, fp
    1564:	01000003 	tsteq	r0, r3
    1568:	00000312 	andeq	r0, r0, r2, lsl r3
    156c:	0000031d 	andeq	r0, r0, sp, lsl r3
    1570:	0003a011 	andeq	sl, r3, r1, lsl r0
    1574:	039a1200 	orrseq	r1, sl, #0, 4
    1578:	13000000 	movwne	r0, #0
    157c:	00000ba2 	andeq	r0, r0, r2, lsr #23
    1580:	730e2004 	movwvc	r2, #57348	; 0xe004
    1584:	0100000b 	tsteq	r0, fp
    1588:	00000332 	andeq	r0, r0, r2, lsr r3
    158c:	0000033d 	andeq	r0, r0, sp, lsr r3
    1590:	0003a011 	andeq	sl, r3, r1, lsl r0
    1594:	02731200 	rsbseq	r1, r3, #0, 4
    1598:	13000000 	movwne	r0, #0
    159c:	00000bc8 	andeq	r0, r0, r8, asr #23
    15a0:	d60e2104 	strle	r2, [lr], -r4, lsl #2
    15a4:	0100000b 	tsteq	r0, fp
    15a8:	00000352 	andeq	r0, r0, r2, asr r3
    15ac:	0000035d 	andeq	r0, r0, sp, asr r3
    15b0:	0003a011 	andeq	sl, r3, r1, lsl r0
    15b4:	02921200 	addseq	r1, r2, #0, 4
    15b8:	13000000 	movwne	r0, #0
    15bc:	00000ac8 	andeq	r0, r0, r8, asr #21
    15c0:	4e0e2504 	cfsh32mi	mvfx2, mvfx14, #4
    15c4:	0100000b 	tsteq	r0, fp
    15c8:	00000372 	andeq	r0, r0, r2, ror r3
    15cc:	0000037d 	andeq	r0, r0, sp, ror r3
    15d0:	0003a011 	andeq	sl, r3, r1, lsl r0
    15d4:	00251200 	eoreq	r1, r5, r0, lsl #4
    15d8:	19000000 	stmdbne	r0, {}	; <UNPREDICTABLE>
    15dc:	00000ac8 	andeq	r0, r0, r8, asr #21
    15e0:	320e2604 	andcc	r2, lr, #4, 12	; 0x400000
    15e4:	0100000b 	tsteq	r0, fp
    15e8:	0000038e 	andeq	r0, r0, lr, lsl #7
    15ec:	0003a011 	andeq	sl, r3, r1, lsl r0
    15f0:	03ab1200 			; <UNDEFINED> instruction: 0x03ab1200
    15f4:	00000000 	andeq	r0, r0, r0
    15f8:	0192041a 	orrseq	r0, r2, sl, lsl r4
    15fc:	04150000 	ldreq	r0, [r5], #-0
    1600:	000002df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    1604:	0003a003 	andeq	sl, r3, r3
    1608:	2c041500 	cfstr32cs	mvfx1, [r4], {-0}
    160c:	16000000 	strne	r0, [r0], -r0
    1610:	00000af0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    1614:	df0e2904 	svcle	0x000e2904
    1618:	02000002 	andeq	r0, r0, #2
    161c:	05910201 	ldreq	r0, [r1, #513]	; 0x201
    1620:	b11b0000 	tstlt	fp, r0
    1624:	01000003 	tsteq	r0, r3
    1628:	03050705 	movweq	r0, #22277	; 0x5705
    162c:	00009700 	andeq	r9, r0, r0, lsl #14
    1630:	000ae11c 	andeq	lr, sl, ip, lsl r1
    1634:	0091cc00 	addseq	ip, r1, r0, lsl #24
    1638:	00001c00 	andeq	r1, r0, r0, lsl #24
    163c:	1d9c0100 	ldfnes	f0, [ip]
    1640:	000003b8 			; <UNDEFINED> instruction: 0x000003b8
    1644:	00009178 	andeq	r9, r0, r8, ror r1
    1648:	00000054 	andeq	r0, r0, r4, asr r0
    164c:	04139c01 	ldreq	r9, [r3], #-3073	; 0xfffff3ff
    1650:	9c1e0000 	ldcls	0, cr0, [lr], {-0}
    1654:	01000002 	tsteq	r0, r2
    1658:	00380137 	eorseq	r0, r8, r7, lsr r1
    165c:	91020000 	mrsls	r0, (UNDEF: 2)
    1660:	03e21e74 	mvneq	r1, #116, 28	; 0x740
    1664:	37010000 	strcc	r0, [r1, -r0]
    1668:	00003801 	andeq	r3, r0, r1, lsl #16
    166c:	70910200 	addsvc	r0, r1, r0, lsl #4
    1670:	037d1f00 	cmneq	sp, #0, 30
    1674:	31010000 	mrscc	r0, (UNDEF: 1)
    1678:	00042d06 	andeq	r2, r4, r6, lsl #26
    167c:	00910c00 	addseq	r0, r1, r0, lsl #24
    1680:	00006c00 	andeq	r6, r0, r0, lsl #24
    1684:	569c0100 	ldrpl	r0, [ip], r0, lsl #2
    1688:	20000004 	andcs	r0, r0, r4
    168c:	000003ed 	andeq	r0, r0, sp, ror #7
    1690:	000003a6 	andeq	r0, r0, r6, lsr #7
    1694:	216c9102 	cmncs	ip, r2, lsl #2
    1698:	00727473 	rsbseq	r7, r2, r3, ror r4
    169c:	ab1f3101 	blge	7cdaa8 <_bss_end+0x7c4394>
    16a0:	02000003 	andeq	r0, r0, #3
    16a4:	69226891 	stmdbvs	r2!, {r0, r4, r7, fp, sp, lr}
    16a8:	09330100 	ldmdbeq	r3!, {r8}
    16ac:	00000038 	andeq	r0, r0, r8, lsr r0
    16b0:	00749102 	rsbseq	r9, r4, r2, lsl #2
    16b4:	00035d1f 	andeq	r5, r3, pc, lsl sp
    16b8:	06230100 	strteq	r0, [r3], -r0, lsl #2
    16bc:	00000470 	andeq	r0, r0, r0, ror r4
    16c0:	00009080 	andeq	r9, r0, r0, lsl #1
    16c4:	0000008c 	andeq	r0, r0, ip, lsl #1
    16c8:	04999c01 	ldreq	r9, [r9], #3073	; 0xc01
    16cc:	ed200000 	stc	0, cr0, [r0, #-0]
    16d0:	a6000003 	strge	r0, [r0], -r3
    16d4:	02000003 	andeq	r0, r0, #3
    16d8:	63216c91 			; <UNDEFINED> instruction: 0x63216c91
    16dc:	18230100 	stmdane	r3!, {r8}
    16e0:	00000025 	andeq	r0, r0, r5, lsr #32
    16e4:	236b9102 	cmncs	fp, #-2147483648	; 0x80000000
    16e8:	000001d7 	ldrdeq	r0, [r0], -r7
    16ec:	5e122501 	cfmul32pl	mvfx2, mvfx2, mvfx1
    16f0:	02000000 	andeq	r0, r0, #0
    16f4:	1f007491 	svcne	0x00007491
    16f8:	0000033d 	andeq	r0, r0, sp, lsr r3
    16fc:	b3061701 	movwlt	r1, #26369	; 0x6701
    1700:	ec000004 	stc	0, cr0, [r0], {4}
    1704:	9400008f 	strls	r0, [r0], #-143	; 0xffffff71
    1708:	01000000 	mrseq	r0, (UNDEF: 0)
    170c:	0004ed9c 	muleq	r4, ip, sp
    1710:	03ed2000 	mvneq	r2, #0
    1714:	03a60000 			; <UNDEFINED> instruction: 0x03a60000
    1718:	91020000 	mrsls	r0, (UNDEF: 2)
    171c:	0bb21e6c 	bleq	fec890d4 <_bss_end+0xfec7f9c0>
    1720:	17010000 	strne	r0, [r1, -r0]
    1724:	0002922b 	andeq	r9, r2, fp, lsr #4
    1728:	68910200 	ldmvs	r1, {r9}
    172c:	000abd24 	andeq	fp, sl, r4, lsr #26
    1730:	1c190100 	ldfnes	f0, [r9], {-0}
    1734:	00000065 	andeq	r0, r0, r5, rrx
    1738:	22749102 	rsbscs	r9, r4, #-2147483648	; 0x80000000
    173c:	006c6176 	rsbeq	r6, ip, r6, ror r1
    1740:	65181a01 	ldrvs	r1, [r8, #-2561]	; 0xfffff5ff
    1744:	02000000 	andeq	r0, r0, #0
    1748:	1f007091 	svcne	0x00007091
    174c:	0000031d 	andeq	r0, r0, sp, lsl r3
    1750:	07061201 	streq	r1, [r6, -r1, lsl #4]
    1754:	90000005 	andls	r0, r0, r5
    1758:	5c00008f 	stcpl	0, cr0, [r0], {143}	; 0x8f
    175c:	01000000 	mrseq	r0, (UNDEF: 0)
    1760:	0005239c 	muleq	r5, ip, r3
    1764:	03ed2000 	mvneq	r2, #0
    1768:	03a60000 			; <UNDEFINED> instruction: 0x03a60000
    176c:	91020000 	mrsls	r0, (UNDEF: 2)
    1770:	656c216c 	strbvs	r2, [ip, #-364]!	; 0xfffffe94
    1774:	1201006e 	andne	r0, r1, #110	; 0x6e
    1778:	0002732f 	andeq	r7, r2, pc, lsr #6
    177c:	68910200 	ldmvs	r1, {r9}
    1780:	02f92500 	rscseq	r2, r9, #0, 10
    1784:	07010000 	streq	r0, [r1, -r0]
    1788:	00053401 	andeq	r3, r5, r1, lsl #8
    178c:	054a0000 	strbeq	r0, [sl, #-0]
    1790:	ed260000 	stc	0, cr0, [r6, #-0]
    1794:	a6000003 	strge	r0, [r0], -r3
    1798:	27000003 	strcs	r0, [r0, -r3]
    179c:	00787561 	rsbseq	r7, r8, r1, ror #10
    17a0:	9a140701 	bls	5033ac <_bss_end+0x4f9c98>
    17a4:	00000003 	andeq	r0, r0, r3
    17a8:	00052328 	andeq	r2, r5, r8, lsr #6
    17ac:	000a9300 	andeq	r9, sl, r0, lsl #6
    17b0:	00056100 	andeq	r6, r5, r0, lsl #2
    17b4:	008eec00 	addeq	lr, lr, r0, lsl #24
    17b8:	0000a400 	andeq	sl, r0, r0, lsl #8
    17bc:	299c0100 	ldmibcs	ip, {r8}
    17c0:	00000534 	andeq	r0, r0, r4, lsr r5
    17c4:	29749102 	ldmdbcs	r4!, {r1, r8, ip, pc}^
    17c8:	0000053d 	andeq	r0, r0, sp, lsr r5
    17cc:	00709102 	rsbseq	r9, r0, r2, lsl #2
    17d0:	00083500 	andeq	r3, r8, r0, lsl #10
    17d4:	77000400 	strvc	r0, [r0, -r0, lsl #8]
    17d8:	0400000a 	streq	r0, [r0], #-10
    17dc:	00009701 	andeq	r9, r0, r1, lsl #14
    17e0:	0c090400 	cfstrseq	mvf0, [r9], {-0}
    17e4:	00580000 	subseq	r0, r8, r0
    17e8:	91e80000 	mvnls	r0, r0
    17ec:	00600000 	rsbeq	r0, r0, r0
    17f0:	0a2b0000 	beq	ac17f8 <_bss_end+0xab80e4>
    17f4:	01020000 	mrseq	r0, (UNDEF: 2)
    17f8:	0002d108 	andeq	sp, r2, r8, lsl #2
    17fc:	00250300 	eoreq	r0, r5, r0, lsl #6
    1800:	02020000 	andeq	r0, r2, #0
    1804:	00018a05 	andeq	r8, r1, r5, lsl #20
    1808:	05040400 	streq	r0, [r4, #-1024]	; 0xfffffc00
    180c:	00746e69 	rsbseq	r6, r4, r9, ror #28
    1810:	00057b05 	andeq	r7, r5, r5, lsl #22
    1814:	07090200 	streq	r0, [r9, -r0, lsl #4]
    1818:	0000004b 	andeq	r0, r0, fp, asr #32
    181c:	c8080102 	stmdagt	r8, {r1, r8}
    1820:	06000002 	streq	r0, [r0], -r2
    1824:	0000004b 	andeq	r0, r0, fp, asr #32
    1828:	6b070202 	blvs	1c2038 <_bss_end+0x1b8924>
    182c:	05000003 	streq	r0, [r0, #-3]
    1830:	00000339 	andeq	r0, r0, r9, lsr r3
    1834:	6f070b02 	svcvs	0x00070b02
    1838:	03000000 	movweq	r0, #0
    183c:	0000005e 	andeq	r0, r0, lr, asr r0
    1840:	13070402 	movwne	r0, #29698	; 0x7402
    1844:	06000011 			; <UNDEFINED> instruction: 0x06000011
    1848:	0000006f 	andeq	r0, r0, pc, rrx
    184c:	00074a07 	andeq	r4, r7, r7, lsl #20
    1850:	3f010700 	svccc	0x00010700
    1854:	03000000 	movweq	r0, #0
    1858:	00c40c06 	sbceq	r0, r4, r6, lsl #24
    185c:	ce080000 	cdpgt	0, 0, cr0, cr8, cr0, {0}
    1860:	00000007 	andeq	r0, r0, r7
    1864:	00078508 	andeq	r8, r7, r8, lsl #10
    1868:	00080100 	andeq	r0, r8, r0, lsl #2
    186c:	02000008 	andeq	r0, r0, #8
    1870:	0007fa08 	andeq	pc, r7, r8, lsl #20
    1874:	e2080300 	and	r0, r8, #0, 6
    1878:	04000007 	streq	r0, [r0], #-7
    187c:	0007e808 	andeq	lr, r7, r8, lsl #16
    1880:	ee080500 	cfsh32	mvfx0, mvfx8, #0
    1884:	06000007 	streq	r0, [r0], -r7
    1888:	0007f408 	andeq	pc, r7, r8, lsl #8
    188c:	96080700 	strls	r0, [r8], -r0, lsl #14
    1890:	08000005 	stmdaeq	r0, {r0, r2}
    1894:	05c00900 	strbeq	r0, [r0, #2304]	; 0x900
    1898:	03040000 	movweq	r0, #16384	; 0x4000
    189c:	0225071a 	eoreq	r0, r5, #6815744	; 0x680000
    18a0:	5e0a0000 	cdppl	0, 0, cr0, cr10, cr0, {0}
    18a4:	03000005 	movweq	r0, #5
    18a8:	0230171e 	eorseq	r1, r0, #7864320	; 0x780000
    18ac:	0b000000 	bleq	18b4 <shift+0x18b4>
    18b0:	00000704 	andeq	r0, r0, r4, lsl #14
    18b4:	2e082203 	cdpcs	2, 0, cr2, cr8, cr3, {0}
    18b8:	35000005 	strcc	r0, [r0, #-5]
    18bc:	02000002 	andeq	r0, r0, #2
    18c0:	000000f7 	strdeq	r0, [r0], -r7
    18c4:	0000010c 	andeq	r0, r0, ip, lsl #2
    18c8:	00023c0c 	andeq	r3, r2, ip, lsl #24
    18cc:	005e0d00 	subseq	r0, lr, r0, lsl #26
    18d0:	420d0000 	andmi	r0, sp, #0
    18d4:	0d000002 	stceq	0, cr0, [r0, #-8]
    18d8:	00000242 	andeq	r0, r0, r2, asr #4
    18dc:	07bb0b00 	ldreq	r0, [fp, r0, lsl #22]!
    18e0:	24030000 	strcs	r0, [r3], #-0
    18e4:	00064a08 	andeq	r4, r6, r8, lsl #20
    18e8:	00023500 	andeq	r3, r2, r0, lsl #10
    18ec:	01250200 			; <UNDEFINED> instruction: 0x01250200
    18f0:	013a0000 	teqeq	sl, r0
    18f4:	3c0c0000 	stccc	0, cr0, [ip], {-0}
    18f8:	0d000002 	stceq	0, cr0, [r0, #-8]
    18fc:	0000005e 	andeq	r0, r0, lr, asr r0
    1900:	0002420d 	andeq	r4, r2, sp, lsl #4
    1904:	02420d00 	subeq	r0, r2, #0, 26
    1908:	0b000000 	bleq	1910 <shift+0x1910>
    190c:	000005ce 	andeq	r0, r0, lr, asr #11
    1910:	8c082603 	stchi	6, cr2, [r8], {3}
    1914:	35000007 	strcc	r0, [r0, #-7]
    1918:	02000002 	andeq	r0, r0, #2
    191c:	00000153 	andeq	r0, r0, r3, asr r1
    1920:	00000168 	andeq	r0, r0, r8, ror #2
    1924:	00023c0c 	andeq	r3, r2, ip, lsl #24
    1928:	005e0d00 	subseq	r0, lr, r0, lsl #26
    192c:	420d0000 	andmi	r0, sp, #0
    1930:	0d000002 	stceq	0, cr0, [r0, #-8]
    1934:	00000242 	andeq	r0, r0, r2, asr #4
    1938:	05e70b00 	strbeq	r0, [r7, #2816]!	; 0xb00
    193c:	28030000 	stmdacs	r3, {}	; <UNPREDICTABLE>
    1940:	00047d08 	andeq	r7, r4, r8, lsl #26
    1944:	00023500 	andeq	r3, r2, r0, lsl #10
    1948:	01810200 	orreq	r0, r1, r0, lsl #4
    194c:	01960000 	orrseq	r0, r6, r0
    1950:	3c0c0000 	stccc	0, cr0, [ip], {-0}
    1954:	0d000002 	stceq	0, cr0, [r0, #-8]
    1958:	0000005e 	andeq	r0, r0, lr, asr r0
    195c:	0002420d 	andeq	r4, r2, sp, lsl #4
    1960:	02420d00 	subeq	r0, r2, #0, 26
    1964:	0b000000 	bleq	196c <shift+0x196c>
    1968:	000005c0 	andeq	r0, r0, r0, asr #11
    196c:	64032b03 	strvs	r2, [r3], #-2819	; 0xfffff4fd
    1970:	48000005 	stmdami	r0, {r0, r2}
    1974:	01000002 	tsteq	r0, r2
    1978:	000001af 	andeq	r0, r0, pc, lsr #3
    197c:	000001ba 			; <UNDEFINED> instruction: 0x000001ba
    1980:	0002480c 	andeq	r4, r2, ip, lsl #16
    1984:	006f0d00 	rsbeq	r0, pc, r0, lsl #26
    1988:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    198c:	00000767 	andeq	r0, r0, r7, ror #14
    1990:	21082e03 	tstcs	r8, r3, lsl #28
    1994:	01000007 	tsteq	r0, r7
    1998:	000001cf 	andeq	r0, r0, pc, asr #3
    199c:	000001df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    19a0:	0002480c 	andeq	r4, r2, ip, lsl #16
    19a4:	005e0d00 	subseq	r0, lr, r0, lsl #26
    19a8:	7b0d0000 	blvc	3419b0 <_bss_end+0x33829c>
    19ac:	00000000 	andeq	r0, r0, r0
    19b0:	0005ae0b 	andeq	sl, r5, fp, lsl #28
    19b4:	12300300 	eorsne	r0, r0, #0, 6
    19b8:	000005fa 	strdeq	r0, [r0], -sl
    19bc:	0000007b 	andeq	r0, r0, fp, ror r0
    19c0:	0001f801 	andeq	pc, r1, r1, lsl #16
    19c4:	00020300 	andeq	r0, r2, r0, lsl #6
    19c8:	023c0c00 	eorseq	r0, ip, #0, 24
    19cc:	5e0d0000 	cdppl	0, 0, cr0, cr13, cr0, {0}
    19d0:	00000000 	andeq	r0, r0, r0
    19d4:	0007810f 	andeq	r8, r7, pc, lsl #2
    19d8:	08330300 	ldmdaeq	r3!, {r8, r9}
    19dc:	0000050c 	andeq	r0, r0, ip, lsl #10
    19e0:	00021401 	andeq	r1, r2, r1, lsl #8
    19e4:	02480c00 	subeq	r0, r8, #0, 24
    19e8:	5e0d0000 	cdppl	0, 0, cr0, cr13, cr0, {0}
    19ec:	0d000000 	stceq	0, cr0, [r0, #-0]
    19f0:	00000235 	andeq	r0, r0, r5, lsr r2
    19f4:	c4030000 	strgt	r0, [r3], #-0
    19f8:	10000000 	andne	r0, r0, r0
    19fc:	00006f04 	andeq	r6, r0, r4, lsl #30
    1a00:	022a0300 	eoreq	r0, sl, #0, 6
    1a04:	01020000 	mrseq	r0, (UNDEF: 2)
    1a08:	00059102 	andeq	r9, r5, r2, lsl #2
    1a0c:	25041000 	strcs	r1, [r4, #-0]
    1a10:	11000002 	tstne	r0, r2
    1a14:	00005e04 	andeq	r5, r0, r4, lsl #28
    1a18:	c4041000 	strgt	r1, [r4], #-0
    1a1c:	12000000 	andne	r0, r0, #0
    1a20:	00000688 	andeq	r0, r0, r8, lsl #13
    1a24:	c4163703 	ldrgt	r3, [r6], #-1795	; 0xfffff8fd
    1a28:	13000000 	movwne	r0, #0
    1a2c:	006c6168 	rsbeq	r6, ip, r8, ror #2
    1a30:	620b0704 	andvs	r0, fp, #4, 14	; 0x100000
    1a34:	14000003 	strne	r0, [r0], #-3
    1a38:	0000028c 	andeq	r0, r0, ip, lsl #5
    1a3c:	691a0a04 	ldmdbvs	sl, {r2, r9, fp}
    1a40:	00000003 	andeq	r0, r0, r3
    1a44:	14200000 	strtne	r0, [r0], #-0
    1a48:	00000322 	andeq	r0, r0, r2, lsr #6
    1a4c:	691a0d04 	ldmdbvs	sl, {r2, r8, sl, fp}
    1a50:	00000003 	andeq	r0, r0, r3
    1a54:	15202000 	strne	r2, [r0, #-0]!
    1a58:	000003a9 	andeq	r0, r0, r9, lsr #7
    1a5c:	6a151004 	bvs	545a74 <_bss_end+0x53c360>
    1a60:	36000000 	strcc	r0, [r0], -r0
    1a64:	00040b14 	andeq	r0, r4, r4, lsl fp
    1a68:	1a420400 	bne	1082a70 <_bss_end+0x107935c>
    1a6c:	00000369 	andeq	r0, r0, r9, ror #6
    1a70:	20215000 	eorcs	r5, r1, r0
    1a74:	0001a907 	andeq	sl, r1, r7, lsl #18
    1a78:	38040500 	stmdacc	r4, {r8, sl}
    1a7c:	04000000 	streq	r0, [r0], #-0
    1a80:	03400d44 	movteq	r0, #3396	; 0xd44
    1a84:	49160000 	ldmdbmi	r6, {}	; <UNPREDICTABLE>
    1a88:	00005152 	andeq	r5, r0, r2, asr r1
    1a8c:	0001e608 	andeq	lr, r1, r8, lsl #12
    1a90:	2b080100 	blcs	201e98 <_bss_end+0x1f8784>
    1a94:	10000004 	andne	r0, r0, r4
    1a98:	00031408 	andeq	r1, r3, r8, lsl #8
    1a9c:	57081100 	strpl	r1, [r8, -r0, lsl #2]
    1aa0:	12000003 	andne	r0, r0, #3
    1aa4:	00038608 	andeq	r8, r3, r8, lsl #12
    1aa8:	1b081300 	blne	2066b0 <_bss_end+0x1fcf9c>
    1aac:	14000003 	strne	r0, [r0], #-3
    1ab0:	00043a08 	andeq	r3, r4, r8, lsl #20
    1ab4:	ff081500 			; <UNDEFINED> instruction: 0xff081500
    1ab8:	16000003 	strne	r0, [r0], -r3
    1abc:	00047208 	andeq	r7, r4, r8, lsl #4
    1ac0:	5e081700 	cdppl	7, 0, cr1, cr8, cr0, {0}
    1ac4:	18000003 	stmdane	r0, {r0, r1}
    1ac8:	00041408 	andeq	r1, r4, r8, lsl #8
    1acc:	97081900 	strls	r1, [r8, -r0, lsl #18]
    1ad0:	1a000003 	bne	1ae4 <shift+0x1ae4>
    1ad4:	00027608 	andeq	r7, r2, r8, lsl #12
    1ad8:	81082000 	mrshi	r2, (UNDEF: 8)
    1adc:	21000002 	tstcs	r0, r2
    1ae0:	00039f08 	andeq	r9, r3, r8, lsl #30
    1ae4:	5a082200 	bpl	20a2ec <_bss_end+0x200bd8>
    1ae8:	24000002 	strcs	r0, [r0], #-2
    1aec:	00038d08 	andeq	r8, r3, r8, lsl #26
    1af0:	ab082500 	blge	20aef8 <_bss_end+0x2017e4>
    1af4:	30000002 	andcc	r0, r0, r2
    1af8:	0002b608 	andeq	fp, r2, r8, lsl #12
    1afc:	9e083100 	adflse	f3, f0, f0
    1b00:	32000001 	andcc	r0, r0, #1
    1b04:	00037e08 	andeq	r7, r3, r8, lsl #28
    1b08:	94083400 	strls	r3, [r8], #-1024	; 0xfffffc00
    1b0c:	35000001 	strcc	r0, [r0, #-1]
    1b10:	02161700 	andseq	r1, r6, #0, 14
    1b14:	04050000 	streq	r0, [r5], #-0
    1b18:	00000038 	andeq	r0, r0, r8, lsr r0
    1b1c:	080d6a04 	stmdaeq	sp, {r2, r9, fp, sp, lr}
    1b20:	00000431 	andeq	r0, r0, r1, lsr r4
    1b24:	03660800 	cmneq	r6, #0, 16
    1b28:	08010000 	stmdaeq	r1, {}	; <UNPREDICTABLE>
    1b2c:	00000406 	andeq	r0, r0, r6, lsl #8
    1b30:	02000002 	andeq	r0, r0, #2
    1b34:	110e0704 	tstne	lr, r4, lsl #14
    1b38:	62030000 	andvs	r0, r3, #0
    1b3c:	18000003 	stmdane	r0, {r0, r1}
    1b40:	00000266 	andeq	r0, r0, r6, ror #4
    1b44:	00027618 	andeq	r7, r2, r8, lsl r6
    1b48:	02861800 	addeq	r1, r6, #0, 16
    1b4c:	93180000 	tstls	r8, #0
    1b50:	09000002 	stmdbeq	r0, {r1}
    1b54:	00000aa1 	andeq	r0, r0, r1, lsr #21
    1b58:	07060504 	streq	r0, [r6, -r4, lsl #10]
    1b5c:	00000446 	andeq	r0, r0, r6, asr #8
    1b60:	0001a80a 	andeq	sl, r1, sl, lsl #16
    1b64:	1d0a0500 	cfstr32ne	mvfx0, [sl, #-0]
    1b68:	00000230 	andeq	r0, r0, r0, lsr r2
    1b6c:	0aa10b00 	beq	fe844774 <_bss_end+0xfe83b060>
    1b70:	0d050000 	stceq	0, cr0, [r5, #-0]
    1b74:	00022609 	andeq	r2, r2, r9, lsl #12
    1b78:	00044600 	andeq	r4, r4, r0, lsl #12
    1b7c:	03b50100 			; <UNDEFINED> instruction: 0x03b50100
    1b80:	03c00000 	biceq	r0, r0, #0
    1b84:	460c0000 	strmi	r0, [ip], -r0
    1b88:	0d000004 	stceq	0, cr0, [r0, #-16]
    1b8c:	0000006f 	andeq	r0, r0, pc, rrx
    1b90:	02c10e00 	sbceq	r0, r1, #0, 28
    1b94:	10050000 	andne	r0, r5, r0
    1b98:	0001ee0e 	andeq	lr, r1, lr, lsl #28
    1b9c:	03d50100 	bicseq	r0, r5, #0, 2
    1ba0:	03e00000 	mvneq	r0, #0
    1ba4:	460c0000 	strmi	r0, [ip], -r0
    1ba8:	0d000004 	stceq	0, cr0, [r0, #-16]
    1bac:	00000340 	andeq	r0, r0, r0, asr #6
    1bb0:	03420e00 	movteq	r0, #11776	; 0x2e00
    1bb4:	12050000 	andne	r0, r5, #0
    1bb8:	0004490e 	andeq	r4, r4, lr, lsl #18
    1bbc:	03f50100 	mvnseq	r0, #0, 2
    1bc0:	04000000 	streq	r0, [r0], #-0
    1bc4:	460c0000 	strmi	r0, [ip], -r0
    1bc8:	0d000004 	stceq	0, cr0, [r0, #-16]
    1bcc:	00000340 	andeq	r0, r0, r0, asr #6
    1bd0:	03f20e00 	mvnseq	r0, #0, 28
    1bd4:	15050000 	strne	r0, [r5, #-0]
    1bd8:	0002330e 	andeq	r3, r2, lr, lsl #6
    1bdc:	04150100 	ldreq	r0, [r5], #-256	; 0xffffff00
    1be0:	04250000 	strteq	r0, [r5], #-0
    1be4:	460c0000 	strmi	r0, [ip], -r0
    1be8:	0d000004 	stceq	0, cr0, [r0, #-16]
    1bec:	000002a3 	andeq	r0, r0, r3, lsr #5
    1bf0:	00005e0d 	andeq	r5, r0, sp, lsl #28
    1bf4:	4a190000 	bmi	641bfc <_bss_end+0x6384e8>
    1bf8:	05000003 	streq	r0, [r0, #-3]
    1bfc:	01b11217 			; <UNDEFINED> instruction: 0x01b11217
    1c00:	005e0000 	subseq	r0, lr, r0
    1c04:	3a010000 	bcc	41c0c <_bss_end+0x384f8>
    1c08:	0c000004 	stceq	0, cr0, [r0], {4}
    1c0c:	00000446 	andeq	r0, r0, r6, asr #8
    1c10:	0002a30d 	andeq	sl, r2, sp, lsl #6
    1c14:	10000000 	andne	r0, r0, r0
    1c18:	00038204 	andeq	r8, r3, r4, lsl #4
    1c1c:	0b900700 	bleq	fe403824 <_bss_end+0xfe3fa110>
    1c20:	04050000 	streq	r0, [r5], #-0
    1c24:	00000038 	andeq	r0, r0, r8, lsr r0
    1c28:	6b0c0606 	blvs	303448 <_bss_end+0x2f9d34>
    1c2c:	08000004 	stmdaeq	r0, {r2}
    1c30:	00000ace 	andeq	r0, r0, lr, asr #21
    1c34:	0ad50800 	beq	ff543c3c <_bss_end+0xff53a528>
    1c38:	00010000 	andeq	r0, r1, r0
    1c3c:	000bf107 	andeq	pc, fp, r7, lsl #2
    1c40:	38040500 	stmdacc	r4, {r8, sl}
    1c44:	06000000 	streq	r0, [r0], -r0
    1c48:	04b80c0c 	ldrteq	r0, [r8], #3084	; 0xc0c
    1c4c:	461a0000 	ldrmi	r0, [sl], -r0
    1c50:	b000000b 	andlt	r0, r0, fp
    1c54:	0c011a04 			; <UNDEFINED> instruction: 0x0c011a04
    1c58:	09600000 	stmdbeq	r0!, {}^	; <UNPREDICTABLE>
    1c5c:	000bc01a 	andeq	ip, fp, sl, lsl r0
    1c60:	1a12c000 	bne	4b1c68 <_bss_end+0x4a8554>
    1c64:	00000aa6 	andeq	r0, r0, r6, lsr #21
    1c68:	b71a2580 	ldrlt	r2, [sl, -r0, lsl #11]
    1c6c:	0000000b 	andeq	r0, r0, fp
    1c70:	0a8a1a4b 	beq	fe2885a4 <_bss_end+0xfe27ee90>
    1c74:	96000000 	strls	r0, [r0], -r0
    1c78:	000ab41a 	andeq	fp, sl, sl, lsl r4
    1c7c:	1be10000 	blne	ff841c84 <_bss_end+0xff838570>
    1c80:	00000a80 	andeq	r0, r0, r0, lsl #21
    1c84:	0001c200 	andeq	ip, r1, r0, lsl #4
    1c88:	0aae0900 	beq	feb84090 <_bss_end+0xfeb7a97c>
    1c8c:	06040000 	streq	r0, [r4], -r0
    1c90:	05730718 	ldrbeq	r0, [r3, #-1816]!	; 0xfffff8e8
    1c94:	dc0a0000 	stcle	0, cr0, [sl], {-0}
    1c98:	0600000a 	streq	r0, [r0], -sl
    1c9c:	05730f1b 	ldrbeq	r0, [r3, #-3867]!	; 0xfffff0e5
    1ca0:	0b000000 	bleq	1ca8 <shift+0x1ca8>
    1ca4:	00000aae 	andeq	r0, r0, lr, lsr #21
    1ca8:	60091e06 	andvs	r1, r9, r6, lsl #28
    1cac:	7900000b 	stmdbvc	r0, {r0, r1, r3}
    1cb0:	01000005 	tsteq	r0, r5
    1cb4:	000004eb 	andeq	r0, r0, fp, ror #9
    1cb8:	000004f6 	strdeq	r0, [r0], -r6
    1cbc:	0005790c 	andeq	r7, r5, ip, lsl #18
    1cc0:	05730d00 	ldrbeq	r0, [r3, #-3328]!	; 0xfffff300
    1cc4:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    1cc8:	00000ba2 	andeq	r0, r0, r2, lsr #23
    1ccc:	730e2006 	movwvc	r2, #57350	; 0xe006
    1cd0:	0100000b 	tsteq	r0, fp
    1cd4:	0000050b 	andeq	r0, r0, fp, lsl #10
    1cd8:	00000516 	andeq	r0, r0, r6, lsl r5
    1cdc:	0005790c 	andeq	r7, r5, ip, lsl #18
    1ce0:	044c0d00 	strbeq	r0, [ip], #-3328	; 0xfffff300
    1ce4:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    1ce8:	00000bc8 	andeq	r0, r0, r8, asr #23
    1cec:	d60e2106 	strle	r2, [lr], -r6, lsl #2
    1cf0:	0100000b 	tsteq	r0, fp
    1cf4:	0000052b 	andeq	r0, r0, fp, lsr #10
    1cf8:	00000536 	andeq	r0, r0, r6, lsr r5
    1cfc:	0005790c 	andeq	r7, r5, ip, lsl #18
    1d00:	046b0d00 	strbteq	r0, [fp], #-3328	; 0xfffff300
    1d04:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    1d08:	00000ac8 	andeq	r0, r0, r8, asr #21
    1d0c:	4e0e2506 	cfsh32mi	mvfx2, mvfx14, #6
    1d10:	0100000b 	tsteq	r0, fp
    1d14:	0000054b 	andeq	r0, r0, fp, asr #10
    1d18:	00000556 	andeq	r0, r0, r6, asr r5
    1d1c:	0005790c 	andeq	r7, r5, ip, lsl #18
    1d20:	00250d00 	eoreq	r0, r5, r0, lsl #26
    1d24:	0f000000 	svceq	0x00000000
    1d28:	00000ac8 	andeq	r0, r0, r8, asr #21
    1d2c:	320e2606 	andcc	r2, lr, #6291456	; 0x600000
    1d30:	0100000b 	tsteq	r0, fp
    1d34:	00000567 	andeq	r0, r0, r7, ror #10
    1d38:	0005790c 	andeq	r7, r5, ip, lsl #18
    1d3c:	057f0d00 	ldrbeq	r0, [pc, #-3328]!	; 1044 <shift+0x1044>
    1d40:	00000000 	andeq	r0, r0, r0
    1d44:	03820411 	orreq	r0, r2, #285212672	; 0x11000000
    1d48:	04100000 	ldreq	r0, [r0], #-0
    1d4c:	000004b8 			; <UNDEFINED> instruction: 0x000004b8
    1d50:	002c0410 	eoreq	r0, ip, r0, lsl r4
    1d54:	7f030000 	svcvc	0x00030000
    1d58:	12000005 	andne	r0, r0, #5
    1d5c:	00000af0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    1d60:	b80e2906 	stmdalt	lr, {r1, r2, r8, fp, sp}
    1d64:	09000004 	stmdbeq	r0, {r2}
    1d68:	0000090d 	andeq	r0, r0, sp, lsl #18
    1d6c:	07030718 	smladeq	r3, r8, r7, r0
    1d70:	000007d7 	ldrdeq	r0, [r0], -r7
    1d74:	00088b1c 	andeq	r8, r8, ip, lsl fp
    1d78:	6f040700 	svcvs	0x00040700
    1d7c:	07000000 	streq	r0, [r0, -r0]
    1d80:	c3011006 	movwgt	r1, #4102	; 0x1006
    1d84:	16000005 	strne	r0, [r0], -r5
    1d88:	00584548 	subseq	r4, r8, r8, asr #10
    1d8c:	45441610 	strbmi	r1, [r4, #-1552]	; 0xfffff9f0
    1d90:	000a0043 	andeq	r0, sl, r3, asr #32
    1d94:	0005a303 	andeq	sl, r5, r3, lsl #6
    1d98:	08981d00 	ldmeq	r8, {r8, sl, fp, ip}
    1d9c:	07080000 	streq	r0, [r8, -r0]
    1da0:	05ec0c24 	strbeq	r0, [ip, #3108]!	; 0xc24
    1da4:	791e0000 	ldmdbvc	lr, {}	; <UNPREDICTABLE>
    1da8:	16260700 	strtne	r0, [r6], -r0, lsl #14
    1dac:	0000006f 	andeq	r0, r0, pc, rrx
    1db0:	00781e00 	rsbseq	r1, r8, r0, lsl #28
    1db4:	6f162707 	svcvs	0x00162707
    1db8:	04000000 	streq	r0, [r0], #-0
    1dbc:	09ea1f00 	stmibeq	sl!, {r8, r9, sl, fp, ip}^
    1dc0:	0c070000 	stceq	0, cr0, [r7], {-0}
    1dc4:	0005c31b 	andeq	ip, r5, fp, lsl r3
    1dc8:	200a0100 	andcs	r0, sl, r0, lsl #2
    1dcc:	0000095d 	andeq	r0, r0, sp, asr r9
    1dd0:	85280d07 	strhi	r0, [r8, #-3335]!	; 0xfffff2f9
    1dd4:	01000005 	tsteq	r0, r5
    1dd8:	00090d21 	andeq	r0, r9, r1, lsr #26
    1ddc:	0e100700 	cdpeq	7, 1, cr0, cr0, cr0, {0}
    1de0:	000009d7 	ldrdeq	r0, [r0], -r7
    1de4:	000007d7 	ldrdeq	r0, [r0], -r7
    1de8:	00062001 	andeq	r2, r6, r1
    1dec:	00063500 	andeq	r3, r6, r0, lsl #10
    1df0:	07d70c00 	ldrbeq	r0, [r7, r0, lsl #24]
    1df4:	6f0d0000 	svcvs	0x000d0000
    1df8:	0d000000 	stceq	0, cr0, [r0, #-0]
    1dfc:	0000006f 	andeq	r0, r0, pc, rrx
    1e00:	00006f0d 	andeq	r6, r0, sp, lsl #30
    1e04:	340e0000 	strcc	r0, [lr], #-0
    1e08:	07000008 	streq	r0, [r0, -r8]
    1e0c:	08f80a12 	ldmeq	r8!, {r1, r4, r9, fp}^
    1e10:	4a010000 	bmi	41e18 <_bss_end+0x38704>
    1e14:	50000006 	andpl	r0, r0, r6
    1e18:	0c000006 	stceq	0, cr0, [r0], {6}
    1e1c:	000007d7 	ldrdeq	r0, [r0], -r7
    1e20:	09160b00 	ldmdbeq	r6, {r8, r9, fp}
    1e24:	14070000 	strne	r0, [r7], #-0
    1e28:	00097a0f 	andeq	r7, r9, pc, lsl #20
    1e2c:	0007dd00 	andeq	sp, r7, r0, lsl #26
    1e30:	06690100 	strbteq	r0, [r9], -r0, lsl #2
    1e34:	06740000 	ldrbteq	r0, [r4], -r0
    1e38:	d70c0000 	strle	r0, [ip, -r0]
    1e3c:	0d000007 	stceq	0, cr0, [r0, #-28]	; 0xffffffe4
    1e40:	00000025 	andeq	r0, r0, r5, lsr #32
    1e44:	09160b00 	ldmdbeq	r6, {r8, r9, fp}
    1e48:	15070000 	strne	r0, [r7, #-0]
    1e4c:	0009210f 	andeq	r2, r9, pc, lsl #2
    1e50:	0007dd00 	andeq	sp, r7, r0, lsl #26
    1e54:	068d0100 	streq	r0, [sp], r0, lsl #2
    1e58:	06980000 	ldreq	r0, [r8], r0
    1e5c:	d70c0000 	strle	r0, [ip, -r0]
    1e60:	0d000007 	stceq	0, cr0, [r0, #-28]	; 0xffffffe4
    1e64:	0000057f 	andeq	r0, r0, pc, ror r5
    1e68:	09160b00 	ldmdbeq	r6, {r8, r9, fp}
    1e6c:	16070000 	strne	r0, [r7], -r0
    1e70:	0009fe0f 	andeq	pc, r9, pc, lsl #28
    1e74:	0007dd00 	andeq	sp, r7, r0, lsl #26
    1e78:	06b10100 	ldrteq	r0, [r1], r0, lsl #2
    1e7c:	06bc0000 	ldrteq	r0, [ip], r0
    1e80:	d70c0000 	strle	r0, [ip, -r0]
    1e84:	0d000007 	stceq	0, cr0, [r0, #-28]	; 0xffffffe4
    1e88:	000005a3 	andeq	r0, r0, r3, lsr #11
    1e8c:	09160b00 	ldmdbeq	r6, {r8, r9, fp}
    1e90:	17070000 	strne	r0, [r7, -r0]
    1e94:	0009a90f 	andeq	sl, r9, pc, lsl #18
    1e98:	0007dd00 	andeq	sp, r7, r0, lsl #26
    1e9c:	06d50100 	ldrbeq	r0, [r5], r0, lsl #2
    1ea0:	06e00000 	strbteq	r0, [r0], r0
    1ea4:	d70c0000 	strle	r0, [ip, -r0]
    1ea8:	0d000007 	stceq	0, cr0, [r0, #-28]	; 0xffffffe4
    1eac:	0000006f 	andeq	r0, r0, pc, rrx
    1eb0:	09160b00 	ldmdbeq	r6, {r8, r9, fp}
    1eb4:	18070000 	stmdane	r7, {}	; <UNPREDICTABLE>
    1eb8:	0009690f 	andeq	r6, r9, pc, lsl #18
    1ebc:	0007dd00 	andeq	sp, r7, r0, lsl #26
    1ec0:	06f90100 	ldrbteq	r0, [r9], r0, lsl #2
    1ec4:	07040000 	streq	r0, [r4, -r0]
    1ec8:	d70c0000 	strle	r0, [ip, -r0]
    1ecc:	0d000007 	stceq	0, cr0, [r0, #-28]	; 0xffffffe4
    1ed0:	00000235 	andeq	r0, r0, r5, lsr r2
    1ed4:	087d2200 	ldmdaeq	sp!, {r9, sp}^
    1ed8:	1b070000 	blne	1c1ee0 <_bss_end+0x1b87cc>
    1edc:	00084d11 	andeq	r4, r8, r1, lsl sp
    1ee0:	00071800 	andeq	r1, r7, r0, lsl #16
    1ee4:	00071e00 	andeq	r1, r7, r0, lsl #28
    1ee8:	07d70c00 	ldrbeq	r0, [r7, r0, lsl #24]
    1eec:	22000000 	andcs	r0, r0, #0
    1ef0:	00000870 	andeq	r0, r0, r0, ror r8
    1ef4:	ba111c07 	blt	448f18 <_bss_end+0x43f804>
    1ef8:	32000009 	andcc	r0, r0, #9
    1efc:	38000007 	stmdacc	r0, {r0, r1, r2}
    1f00:	0c000007 	stceq	0, cr0, [r0], {7}
    1f04:	000007d7 	ldrdeq	r0, [r0], -r7
    1f08:	08222200 	stmdaeq	r2!, {r9, sp}
    1f0c:	1d070000 	stcne	0, cr0, [r7, #-0]
    1f10:	0008a211 	andeq	sl, r8, r1, lsl r2
    1f14:	00074c00 	andeq	r4, r7, r0, lsl #24
    1f18:	00075200 	andeq	r5, r7, r0, lsl #4
    1f1c:	07d70c00 	ldrbeq	r0, [r7, r0, lsl #24]
    1f20:	22000000 	andcs	r0, r0, #0
    1f24:	0000080d 	andeq	r0, r0, sp, lsl #16
    1f28:	930a1f07 	movwls	r1, #44807	; 0xaf07
    1f2c:	66000009 	strvs	r0, [r0], -r9
    1f30:	6c000007 	stcvs	0, cr0, [r0], {7}
    1f34:	0c000007 	stceq	0, cr0, [r0], {7}
    1f38:	000007d7 	ldrdeq	r0, [r0], -r7
    1f3c:	086b2200 	stmdaeq	fp!, {r9, sp}^
    1f40:	21070000 	mrscs	r0, (UNDEF: 7)
    1f44:	0009340a 	andeq	r3, r9, sl, lsl #8
    1f48:	00078000 	andeq	r8, r7, r0
    1f4c:	00079500 	andeq	r9, r7, r0, lsl #10
    1f50:	07d70c00 	ldrbeq	r0, [r7, r0, lsl #24]
    1f54:	6f0d0000 	svcvs	0x000d0000
    1f58:	0d000000 	stceq	0, cr0, [r0, #-0]
    1f5c:	000007e3 	andeq	r0, r0, r3, ror #15
    1f60:	00006f0d 	andeq	r6, r0, sp, lsl #30
    1f64:	c40a0000 	strgt	r0, [sl], #-0
    1f68:	07000008 	streq	r0, [r0, -r8]
    1f6c:	07ef232b 	strbeq	r2, [pc, fp, lsr #6]!
    1f70:	0a000000 	beq	1f78 <shift+0x1f78>
    1f74:	0000098b 	andeq	r0, r0, fp, lsl #19
    1f78:	6f122c07 	svcvs	0x00122c07
    1f7c:	04000000 	streq	r0, [r0], #-0
    1f80:	00094b0a 	andeq	r4, r9, sl, lsl #22
    1f84:	122d0700 	eorne	r0, sp, #0, 14
    1f88:	0000006f 	andeq	r0, r0, pc, rrx
    1f8c:	09540a08 	ldmdbeq	r4, {r3, r9, fp}^
    1f90:	2e070000 	cdpcs	0, 0, cr0, cr7, cr0, {0}
    1f94:	0005c80f 	andeq	ip, r5, pc, lsl #16
    1f98:	140a0c00 	strne	r0, [sl], #-3072	; 0xfffff400
    1f9c:	07000008 	streq	r0, [r0, -r8]
    1fa0:	05a3122f 	streq	r1, [r3, #559]!	; 0x22f
    1fa4:	00140000 	andseq	r0, r4, r0
    1fa8:	05960410 	ldreq	r0, [r6, #1040]	; 0x410
    1fac:	04110000 	ldreq	r0, [r1], #-0
    1fb0:	00000596 	muleq	r0, r6, r5
    1fb4:	00250410 	eoreq	r0, r5, r0, lsl r4
    1fb8:	04100000 	ldreq	r0, [r0], #-0
    1fbc:	00000052 	andeq	r0, r0, r2, asr r0
    1fc0:	0007e903 	andeq	lr, r7, r3, lsl #18
    1fc4:	08dd1200 	ldmeq	sp, {r9, ip}^
    1fc8:	32070000 	andcc	r0, r7, #0
    1fcc:	00059611 	andeq	r9, r5, r1, lsl r6
    1fd0:	0c492300 	mcrreq	3, 0, r2, r9, cr0
    1fd4:	06010000 	streq	r0, [r1], -r0
    1fd8:	00006a14 	andeq	r6, r0, r4, lsl sl
    1fdc:	98030500 	stmdals	r3, {r8, sl}
    1fe0:	24000096 	strcs	r0, [r0], #-150	; 0xffffff6a
    1fe4:	00000c3c 	andeq	r0, r0, ip, lsr ip
    1fe8:	38100801 	ldmdacc	r0, {r0, fp}
    1fec:	e8000000 	stmda	r0, {}	; <UNPREDICTABLE>
    1ff0:	60000091 	mulvs	r0, r1, r0
    1ff4:	01000000 	mrseq	r0, (UNDEF: 0)
    1ff8:	6974259c 	ldmdbvs	r4!, {r2, r3, r4, r7, r8, sl, sp}^
    1ffc:	1601006d 	strne	r0, [r1], -sp, rrx
    2000:	00007618 	andeq	r7, r0, r8, lsl r6
    2004:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    2008:	00220000 	eoreq	r0, r2, r0
    200c:	00020000 	andeq	r0, r2, r0
    2010:	00000ce6 	andeq	r0, r0, r6, ror #25
    2014:	0b610104 	bleq	184242c <_bss_end+0x1838d18>
    2018:	80000000 	andhi	r0, r0, r0
    201c:	80180000 	andshi	r0, r8, r0
    2020:	0c510000 	mraeq	r0, r1, acc0
    2024:	00580000 	subseq	r0, r8, r0
    2028:	0c830000 	stceq	0, cr0, [r3], {0}
    202c:	80010000 	andhi	r0, r1, r0
    2030:	0000014b 	andeq	r0, r0, fp, asr #2
    2034:	0cfa0004 	ldcleq	0, cr0, [sl], #16
    2038:	01040000 	mrseq	r0, (UNDEF: 4)
    203c:	00000097 	muleq	r0, r7, r0
    2040:	000cd604 	andeq	sp, ip, r4, lsl #12
    2044:	00005800 	andeq	r5, r0, r0, lsl #16
    2048:	00924800 	addseq	r4, r2, r0, lsl #16
    204c:	00011800 	andeq	r1, r1, r0, lsl #16
    2050:	000bc500 	andeq	ip, fp, r0, lsl #10
    2054:	0d230200 	sfmeq	f0, 4, [r3, #-0]
    2058:	02010000 	andeq	r0, r1, #0
    205c:	00003107 	andeq	r3, r0, r7, lsl #2
    2060:	37040300 	strcc	r0, [r4, -r0, lsl #6]
    2064:	04000000 	streq	r0, [r0], #-0
    2068:	000d4402 	andeq	r4, sp, r2, lsl #8
    206c:	07030100 	streq	r0, [r3, -r0, lsl #2]
    2070:	00000031 	andeq	r0, r0, r1, lsr r0
    2074:	000c8f05 	andeq	r8, ip, r5, lsl #30
    2078:	10060100 	andne	r0, r6, r0, lsl #2
    207c:	00000050 	andeq	r0, r0, r0, asr r0
    2080:	69050406 	stmdbvs	r5, {r1, r2, sl}
    2084:	0500746e 	streq	r7, [r0, #-1134]	; 0xfffffb92
    2088:	00000d0c 	andeq	r0, r0, ip, lsl #26
    208c:	50100801 	andspl	r0, r0, r1, lsl #16
    2090:	07000000 	streq	r0, [r0, -r0]
    2094:	00000025 	andeq	r0, r0, r5, lsr #32
    2098:	00000076 	andeq	r0, r0, r6, ror r0
    209c:	00007608 	andeq	r7, r0, r8, lsl #12
    20a0:	ffffff00 			; <UNDEFINED> instruction: 0xffffff00
    20a4:	040900ff 	streq	r0, [r9], #-255	; 0xffffff01
    20a8:	00111307 	andseq	r1, r1, r7, lsl #6
    20ac:	0cad0500 	cfstr32eq	mvfx0, [sp]
    20b0:	0b010000 	bleq	420b8 <_bss_end+0x389a4>
    20b4:	00006315 	andeq	r6, r0, r5, lsl r3
    20b8:	0ca00500 	cfstr32eq	mvfx0, [r0]
    20bc:	0d010000 	stceq	0, cr0, [r1, #-0]
    20c0:	00006315 	andeq	r6, r0, r5, lsl r3
    20c4:	00380700 	eorseq	r0, r8, r0, lsl #14
    20c8:	00a80000 	adceq	r0, r8, r0
    20cc:	76080000 	strvc	r0, [r8], -r0
    20d0:	ff000000 			; <UNDEFINED> instruction: 0xff000000
    20d4:	00ffffff 	ldrshteq	pc, [pc], #255	; <UNPREDICTABLE>
    20d8:	000d1505 	andeq	r1, sp, r5, lsl #10
    20dc:	15100100 	ldrne	r0, [r0, #-256]	; 0xffffff00
    20e0:	00000095 	muleq	r0, r5, r0
    20e4:	000cbb05 	andeq	fp, ip, r5, lsl #22
    20e8:	15120100 	ldrne	r0, [r2, #-256]	; 0xffffff00
    20ec:	00000095 	muleq	r0, r5, r0
    20f0:	000cc80a 	andeq	ip, ip, sl, lsl #16
    20f4:	102b0100 	eorne	r0, fp, r0, lsl #2
    20f8:	00000050 	andeq	r0, r0, r0, asr r0
    20fc:	00009308 	andeq	r9, r0, r8, lsl #6
    2100:	00000058 	andeq	r0, r0, r8, asr r0
    2104:	00ea9c01 	rsceq	r9, sl, r1, lsl #24
    2108:	9a0b0000 	bls	2c2110 <_bss_end+0x2b89fc>
    210c:	0100000c 	tsteq	r0, ip
    2110:	00ea0c2d 	rsceq	r0, sl, sp, lsr #24
    2114:	91020000 	mrsls	r0, (UNDEF: 2)
    2118:	04030074 	streq	r0, [r3], #-116	; 0xffffff8c
    211c:	00000038 	andeq	r0, r0, r8, lsr r0
    2120:	000d370a 	andeq	r3, sp, sl, lsl #14
    2124:	101f0100 	andsne	r0, pc, r0, lsl #2
    2128:	00000050 	andeq	r0, r0, r0, asr r0
    212c:	000092b0 			; <UNDEFINED> instruction: 0x000092b0
    2130:	00000058 	andeq	r0, r0, r8, asr r0
    2134:	011a9c01 	tsteq	sl, r1, lsl #24
    2138:	9a0b0000 	bls	2c2140 <_bss_end+0x2b8a2c>
    213c:	0100000c 	tsteq	r0, ip
    2140:	011a0c21 	tsteq	sl, r1, lsr #24
    2144:	91020000 	mrsls	r0, (UNDEF: 2)
    2148:	04030074 	streq	r0, [r3], #-116	; 0xffffff8c
    214c:	00000025 	andeq	r0, r0, r5, lsr #32
    2150:	000d2c0c 	andeq	r2, sp, ip, lsl #24
    2154:	10140100 	andsne	r0, r4, r0, lsl #2
    2158:	00000050 	andeq	r0, r0, r0, asr r0
    215c:	00009248 	andeq	r9, r0, r8, asr #4
    2160:	00000068 	andeq	r0, r0, r8, rrx
    2164:	01489c01 	cmpeq	r8, r1, lsl #24
    2168:	690d0000 	stmdbvs	sp, {}	; <UNPREDICTABLE>
    216c:	07160100 	ldreq	r0, [r6, -r0, lsl #2]
    2170:	00000148 	andeq	r0, r0, r8, asr #2
    2174:	00749102 	rsbseq	r9, r4, r2, lsl #2
    2178:	00500403 	subseq	r0, r0, r3, lsl #8
    217c:	22000000 	andcs	r0, r0, #0
    2180:	02000000 	andeq	r0, r0, #0
    2184:	000dc000 	andeq	ip, sp, r0
    2188:	96010400 	strls	r0, [r1], -r0, lsl #8
    218c:	6000000c 	andvs	r0, r0, ip
    2190:	6c000093 	stcvs	0, cr0, [r0], {147}	; 0x93
    2194:	4d000095 	stcmi	0, cr0, [r0, #-596]	; 0xfffffdac
    2198:	7d00000d 	stcvc	0, cr0, [r0, #-52]	; 0xffffffcc
    219c:	e500000d 	str	r0, [r0, #-13]
    21a0:	0100000d 	tsteq	r0, sp
    21a4:	00002280 	andeq	r2, r0, r0, lsl #5
    21a8:	d4000200 	strle	r0, [r0], #-512	; 0xfffffe00
    21ac:	0400000d 	streq	r0, [r0], #-13
    21b0:	000d1301 	andeq	r1, sp, r1, lsl #6
    21b4:	00956c00 	addseq	r6, r5, r0, lsl #24
    21b8:	00957000 	addseq	r7, r5, r0
    21bc:	000d4d00 	andeq	r4, sp, r0, lsl #26
    21c0:	000d7d00 	andeq	r7, sp, r0, lsl #26
    21c4:	000de500 	andeq	lr, sp, r0, lsl #10
    21c8:	2a800100 	bcs	fe0025d0 <_bss_end+0xfdff8ebc>
    21cc:	04000003 	streq	r0, [r0], #-3
    21d0:	000de800 	andeq	lr, sp, r0, lsl #16
    21d4:	11010400 	tstne	r1, r0, lsl #8
    21d8:	0c00000f 	stceq	0, cr0, [r0], {15}
    21dc:	000010ca 	andeq	r1, r0, sl, asr #1
    21e0:	00000d7d 	andeq	r0, r0, sp, ror sp
    21e4:	00000d73 	andeq	r0, r0, r3, ror sp
    21e8:	69050402 	stmdbvs	r5, {r1, sl}
    21ec:	0300746e 	movweq	r7, #1134	; 0x46e
    21f0:	11130704 	tstne	r3, r4, lsl #14
    21f4:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    21f8:	00017c05 	andeq	r7, r1, r5, lsl #24
    21fc:	04080300 	streq	r0, [r8], #-768	; 0xfffffd00
    2200:	000010be 	strheq	r1, [r0], -lr
    2204:	c8080103 	stmdagt	r8, {r0, r1, r8}
    2208:	03000002 	movweq	r0, #2
    220c:	02ca0601 	sbceq	r0, sl, #1048576	; 0x100000
    2210:	96040000 	strls	r0, [r4], -r0
    2214:	07000012 	smladeq	r0, r2, r0, r0
    2218:	00003901 	andeq	r3, r0, r1, lsl #18
    221c:	06170100 	ldreq	r0, [r7], -r0, lsl #2
    2220:	000001d4 	ldrdeq	r0, [r0], -r4
    2224:	000e2005 	andeq	r2, lr, r5
    2228:	45050000 	strmi	r0, [r5, #-0]
    222c:	01000013 	tsteq	r0, r3, lsl r0
    2230:	000ff305 	andeq	pc, pc, r5, lsl #6
    2234:	b1050200 	mrslt	r0, SP_usr
    2238:	03000010 	movweq	r0, #16
    223c:	0012af05 	andseq	sl, r2, r5, lsl #30
    2240:	55050400 	strpl	r0, [r5, #-1024]	; 0xfffffc00
    2244:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
    2248:	0012c505 	andseq	ip, r2, r5, lsl #10
    224c:	fa050600 	blx	143a54 <_bss_end+0x13a340>
    2250:	07000010 	smladeq	r0, r0, r0, r0
    2254:	00124005 	andseq	r4, r2, r5
    2258:	4e050800 	cdpmi	8, 0, cr0, cr5, cr0, {0}
    225c:	09000012 	stmdbeq	r0, {r1, r4}
    2260:	00125c05 	andseq	r5, r2, r5, lsl #24
    2264:	63050a00 	movwvs	r0, #23040	; 0x5a00
    2268:	0b000011 	bleq	22b4 <shift+0x22b4>
    226c:	00115305 	andseq	r5, r1, r5, lsl #6
    2270:	3c050c00 	stccc	12, cr0, [r5], {-0}
    2274:	0d00000e 	stceq	0, cr0, [r0, #-56]	; 0xffffffc8
    2278:	000e5505 	andeq	r5, lr, r5, lsl #10
    227c:	44050e00 	strmi	r0, [r5], #-3584	; 0xfffff200
    2280:	0f000011 	svceq	0x00000011
    2284:	00130805 	andseq	r0, r3, r5, lsl #16
    2288:	85051000 	strhi	r1, [r5, #-0]
    228c:	11000012 	tstne	r0, r2, lsl r0
    2290:	0012f905 	andseq	pc, r2, r5, lsl #18
    2294:	02051200 	andeq	r1, r5, #0, 4
    2298:	1300000f 	movwne	r0, #15
    229c:	000e7f05 	andeq	r7, lr, r5, lsl #30
    22a0:	49051400 	stmdbmi	r5, {sl, ip}
    22a4:	1500000e 	strne	r0, [r0, #-14]
    22a8:	0011e205 	andseq	lr, r1, r5, lsl #4
    22ac:	b6051600 	strlt	r1, [r5], -r0, lsl #12
    22b0:	1700000e 	strne	r0, [r0, -lr]
    22b4:	000df105 	andeq	pc, sp, r5, lsl #2
    22b8:	eb051800 	bl	1482c0 <_bss_end+0x13ebac>
    22bc:	19000012 	stmdbne	r0, {r1, r4}
    22c0:	00112005 	andseq	r2, r1, r5
    22c4:	fa051a00 	blx	148acc <_bss_end+0x13f3b8>
    22c8:	1b000011 	blne	2314 <shift+0x2314>
    22cc:	000e8a05 	andeq	r8, lr, r5, lsl #20
    22d0:	96051c00 	strls	r1, [r5], -r0, lsl #24
    22d4:	1d000010 	stcne	0, cr0, [r0, #-64]	; 0xffffffc0
    22d8:	000fe505 	andeq	lr, pc, r5, lsl #10
    22dc:	77051e00 	strvc	r1, [r5, -r0, lsl #28]
    22e0:	1f000012 	svcne	0x00000012
    22e4:	0012d305 	andseq	sp, r2, r5, lsl #6
    22e8:	14052000 	strne	r2, [r5], #-0
    22ec:	21000013 	tstcs	r0, r3, lsl r0
    22f0:	00132205 	andseq	r2, r3, r5, lsl #4
    22f4:	37052200 	strcc	r2, [r5, -r0, lsl #4]
    22f8:	23000011 	movwcs	r0, #17
    22fc:	00105a05 	andseq	r5, r0, r5, lsl #20
    2300:	99052400 	stmdbls	r5, {sl, sp}
    2304:	2500000e 	strcs	r0, [r0, #-14]
    2308:	0010ed05 	andseq	lr, r0, r5, lsl #26
    230c:	ff052600 			; <UNDEFINED> instruction: 0xff052600
    2310:	2700000f 	strcs	r0, [r0, -pc]
    2314:	0012a205 	andseq	sl, r2, r5, lsl #4
    2318:	0f052800 	svceq	0x00052800
    231c:	29000010 	stmdbcs	r0, {r4}
    2320:	00101e05 	andseq	r1, r0, r5, lsl #28
    2324:	2d052a00 	vstrcs	s4, [r5, #-0]
    2328:	2b000010 	blcs	2370 <shift+0x2370>
    232c:	00103c05 	andseq	r3, r0, r5, lsl #24
    2330:	ca052c00 	bgt	14d338 <_bss_end+0x143c24>
    2334:	2d00000f 	stccs	0, cr0, [r0, #-60]	; 0xffffffc4
    2338:	00104b05 	andseq	r4, r0, r5, lsl #22
    233c:	31052e00 	tstcc	r5, r0, lsl #28
    2340:	2f000012 	svccs	0x00000012
    2344:	00106905 	andseq	r6, r0, r5, lsl #18
    2348:	78053000 	stmdavc	r5, {ip, sp}
    234c:	31000010 	tstcc	r0, r0, lsl r0
    2350:	000e2a05 	andeq	r2, lr, r5, lsl #20
    2354:	82053200 	andhi	r3, r5, #0, 4
    2358:	33000011 	movwcc	r0, #17
    235c:	00119205 	andseq	r9, r1, r5, lsl #4
    2360:	a2053400 	andge	r3, r5, #0, 8
    2364:	35000011 	strcc	r0, [r0, #-17]	; 0xffffffef
    2368:	000fb805 	andeq	fp, pc, r5, lsl #16
    236c:	b2053600 	andlt	r3, r5, #0, 12
    2370:	37000011 	smladcc	r0, r1, r0, r0
    2374:	0011c205 	andseq	ip, r1, r5, lsl #4
    2378:	d2053800 	andle	r3, r5, #0, 16
    237c:	39000011 	stmdbcc	r0, {r0, r4}
    2380:	000ea905 	andeq	sl, lr, r5, lsl #18
    2384:	62053a00 	andvs	r3, r5, #0, 20
    2388:	3b00000e 	blcc	23c8 <shift+0x23c8>
    238c:	00108705 	andseq	r8, r0, r5, lsl #14
    2390:	01053c00 	tsteq	r5, r0, lsl #24
    2394:	3d00000e 	stccc	0, cr0, [r0, #-56]	; 0xffffffc8
    2398:	0011ed05 	andseq	lr, r1, r5, lsl #26
    239c:	06003e00 	streq	r3, [r0], -r0, lsl #28
    23a0:	00000ee9 	andeq	r0, r0, r9, ror #29
    23a4:	026b0102 	rsbeq	r0, fp, #-2147483648	; 0x80000000
    23a8:	0001ff08 	andeq	pc, r1, r8, lsl #30
    23ac:	10ac0700 	adcne	r0, ip, r0, lsl #14
    23b0:	70010000 	andvc	r0, r1, r0
    23b4:	00471402 	subeq	r1, r7, r2, lsl #8
    23b8:	07000000 	streq	r0, [r0, -r0]
    23bc:	00000fc5 	andeq	r0, r0, r5, asr #31
    23c0:	14027101 	strne	r7, [r2], #-257	; 0xfffffeff
    23c4:	00000047 	andeq	r0, r0, r7, asr #32
    23c8:	d4080001 	strle	r0, [r8], #-1
    23cc:	09000001 	stmdbeq	r0, {r0}
    23d0:	000001ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    23d4:	00000214 	andeq	r0, r0, r4, lsl r2
    23d8:	0000240a 	andeq	r2, r0, sl, lsl #8
    23dc:	08001100 	stmdaeq	r0, {r8, ip}
    23e0:	00000204 	andeq	r0, r0, r4, lsl #4
    23e4:	0011700b 	andseq	r7, r1, fp
    23e8:	02740100 	rsbseq	r0, r4, #0, 2
    23ec:	00021426 	andeq	r1, r2, r6, lsr #8
    23f0:	3d3a2400 	cfldrscc	mvf2, [sl, #-0]
    23f4:	3d0f3d0a 	stccc	13, cr3, [pc, #-40]	; 23d4 <shift+0x23d4>
    23f8:	3d323d24 	ldccc	13, cr3, [r2, #-144]!	; 0xffffff70
    23fc:	3d053d02 	stccc	13, cr3, [r5, #-8]
    2400:	3d0d3d13 	stccc	13, cr3, [sp, #-76]	; 0xffffffb4
    2404:	3d233d0c 	stccc	13, cr3, [r3, #-48]!	; 0xffffffd0
    2408:	3d263d11 	stccc	13, cr3, [r6, #-68]!	; 0xffffffbc
    240c:	3d173d01 	ldccc	13, cr3, [r7, #-4]
    2410:	3d093d08 	stccc	13, cr3, [r9, #-32]	; 0xffffffe0
    2414:	02030000 	andeq	r0, r3, #0
    2418:	00036b07 	andeq	r6, r3, r7, lsl #22
    241c:	08010300 	stmdaeq	r1, {r8, r9}
    2420:	000002d1 	ldrdeq	r0, [r0], -r1
    2424:	59040d0c 	stmdbpl	r4, {r2, r3, r8, sl, fp}
    2428:	0e000002 	cdpeq	0, 0, cr0, cr0, cr2, {0}
    242c:	00001330 	andeq	r1, r0, r0, lsr r3
    2430:	00390107 	eorseq	r0, r9, r7, lsl #2
    2434:	f7020000 			; <UNDEFINED> instruction: 0xf7020000
    2438:	029e0604 	addseq	r0, lr, #4, 12	; 0x400000
    243c:	c3050000 	movwgt	r0, #20480	; 0x5000
    2440:	0000000e 	andeq	r0, r0, lr
    2444:	000ece05 	andeq	ip, lr, r5, lsl #28
    2448:	e0050100 	and	r0, r5, r0, lsl #2
    244c:	0200000e 	andeq	r0, r0, #14
    2450:	000efa05 	andeq	pc, lr, r5, lsl #20
    2454:	6a050300 	bvs	14305c <_bss_end+0x139948>
    2458:	04000012 	streq	r0, [r0], #-18	; 0xffffffee
    245c:	000fd905 	andeq	sp, pc, r5, lsl #18
    2460:	23050500 	movwcs	r0, #21760	; 0x5500
    2464:	06000012 			; <UNDEFINED> instruction: 0x06000012
    2468:	05020300 	streq	r0, [r2, #-768]	; 0xfffffd00
    246c:	0000018a 	andeq	r0, r0, sl, lsl #3
    2470:	09070803 	stmdbeq	r7, {r0, r1, fp}
    2474:	03000011 	movweq	r0, #17
    2478:	0e1a0404 	cfmulseq	mvf0, mvf10, mvf4
    247c:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    2480:	000e1203 	andeq	r1, lr, r3, lsl #4
    2484:	04080300 	streq	r0, [r8], #-768	; 0xfffffd00
    2488:	000010c3 	andeq	r1, r0, r3, asr #1
    248c:	14031003 	strne	r1, [r3], #-3
    2490:	0f000012 	svceq	0x00000012
    2494:	0000120b 	andeq	r1, r0, fp, lsl #4
    2498:	5a102a03 	bpl	40ccac <_bss_end+0x403598>
    249c:	09000002 	stmdbeq	r0, {r1}
    24a0:	000002c8 	andeq	r0, r0, r8, asr #5
    24a4:	000002df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    24a8:	ad110010 	ldcge	0, cr0, [r1, #-64]	; 0xffffffc0
    24ac:	0300000c 	movweq	r0, #12
    24b0:	02d4112f 	sbcseq	r1, r4, #-1073741813	; 0xc000000b
    24b4:	15110000 	ldrne	r0, [r1, #-0]
    24b8:	0300000d 	movweq	r0, #13
    24bc:	02d41130 	sbcseq	r1, r4, #48, 2
    24c0:	c8090000 	stmdagt	r9, {}	; <UNPREDICTABLE>
    24c4:	07000002 	streq	r0, [r0, -r2]
    24c8:	0a000003 	beq	24dc <shift+0x24dc>
    24cc:	00000024 	andeq	r0, r0, r4, lsr #32
    24d0:	df120001 	svcle	0x00120001
    24d4:	04000002 	streq	r0, [r0], #-2
    24d8:	f70a0933 			; <UNDEFINED> instruction: 0xf70a0933
    24dc:	05000002 	streq	r0, [r0, #-2]
    24e0:	0096c003 	addseq	ip, r6, r3
    24e4:	02eb1200 	rsceq	r1, fp, #0, 4
    24e8:	34040000 	strcc	r0, [r4], #-0
    24ec:	02f70a09 	rscseq	r0, r7, #36864	; 0x9000
    24f0:	03050000 	movweq	r0, #20480	; 0x5000
    24f4:	000096d0 	ldrdeq	r9, [r0], -r0
	...

Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
   0:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
   4:	030b130e 	movweq	r1, #45838	; 0xb30e
   8:	110e1b0e 	tstne	lr, lr, lsl #22
   c:	10061201 	andne	r1, r6, r1, lsl #4
  10:	02000017 	andeq	r0, r0, #23
  14:	193f002e 	ldmdbne	pc!, {r1, r2, r3, r5}	; <UNPREDICTABLE>
  18:	0b3a0e03 	bleq	e8382c <_bss_end+0xe7a118>
  1c:	0b390b3b 	bleq	e42d10 <_bss_end+0xe395fc>
  20:	06120111 			; <UNDEFINED> instruction: 0x06120111
  24:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
  28:	03000019 	movweq	r0, #25
  2c:	0e030139 	mcreq	1, 0, r0, cr3, cr9, {1}
  30:	0b3b0b3a 	bleq	ec2d20 <_bss_end+0xeb960c>
  34:	00001301 	andeq	r1, r0, r1, lsl #6
  38:	3f012e04 	svccc	0x00012e04
  3c:	3a0e0319 	bcc	380ca8 <_bss_end+0x377594>
  40:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
  44:	01193c0b 	tsteq	r9, fp, lsl #24
  48:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
  4c:	13490005 	movtne	r0, #36869	; 0x9005
  50:	16060000 	strne	r0, [r6], -r0
  54:	3a0e0300 	bcc	380c5c <_bss_end+0x377548>
  58:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
  5c:	0013490b 	andseq	r4, r3, fp, lsl #18
  60:	012e0700 			; <UNDEFINED> instruction: 0x012e0700
  64:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
  68:	0b3b0b3a 	bleq	ec2d58 <_bss_end+0xeb9644>
  6c:	13490b39 	movtne	r0, #39737	; 0x9b39
  70:	0000193c 	andeq	r1, r0, ip, lsr r9
  74:	0b000f08 	bleq	3c9c <shift+0x3c9c>
  78:	0013490b 	andseq	r4, r3, fp, lsl #18
  7c:	00240900 	eoreq	r0, r4, r0, lsl #18
  80:	0b3e0b0b 	bleq	f82cb4 <_bss_end+0xf795a0>
  84:	00000e03 	andeq	r0, r0, r3, lsl #28
  88:	47012e0a 	strmi	r2, [r1, -sl, lsl #28]
  8c:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
  90:	97184006 	ldrls	r4, [r8, -r6]
  94:	13011942 	movwne	r1, #6466	; 0x1942
  98:	050b0000 	streq	r0, [fp, #-0]
  9c:	02134900 	andseq	r4, r3, #0, 18
  a0:	0c000018 	stceq	0, cr0, [r0], {24}
  a4:	08030005 	stmdaeq	r3, {r0, r2}
  a8:	0b3b0b3a 	bleq	ec2d98 <_bss_end+0xeb9684>
  ac:	13490b39 	movtne	r0, #39737	; 0x9b39
  b0:	00001802 	andeq	r1, r0, r2, lsl #16
  b4:	0b00240d 	bleq	90f0 <_ZN5CUART5WriteEc+0x70>
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
  e4:	0b0b0024 	bleq	2c017c <_bss_end+0x2b6a68>
  e8:	0e030b3e 	vmoveq.16	d3[0], r0
  ec:	24030000 	strcs	r0, [r3], #-0
  f0:	3e0b0b00 	vmlacc.f64	d0, d11, d0
  f4:	0008030b 	andeq	r0, r8, fp, lsl #6
  f8:	00160400 	andseq	r0, r6, r0, lsl #8
  fc:	0b3a0e03 	bleq	e83910 <_bss_end+0xe7a1fc>
 100:	0b390b3b 	bleq	e42df4 <_bss_end+0xe396e0>
 104:	00001349 	andeq	r1, r0, r9, asr #6
 108:	49002605 	stmdbmi	r0, {r0, r2, r9, sl, sp}
 10c:	06000013 			; <UNDEFINED> instruction: 0x06000013
 110:	08030139 	stmdaeq	r3, {r0, r3, r4, r5, r8}
 114:	0b3b0b3a 	bleq	ec2e04 <_bss_end+0xeb96f0>
 118:	13010b39 	movwne	r0, #6969	; 0x1b39
 11c:	34070000 	strcc	r0, [r7], #-0
 120:	3a0e0300 	bcc	380d28 <_bss_end+0x377614>
 124:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 128:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
 12c:	6c061c19 	stcvs	12, cr1, [r6], {25}
 130:	08000019 	stmdaeq	r0, {r0, r3, r4}
 134:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 138:	0b3b0b3a 	bleq	ec2e28 <_bss_end+0xeb9714>
 13c:	13490b39 	movtne	r0, #39737	; 0x9b39
 140:	0b1c193c 	bleq	706638 <_bss_end+0x6fcf24>
 144:	0000196c 	andeq	r1, r0, ip, ror #18
 148:	03010409 	movweq	r0, #5129	; 0x1409
 14c:	3e196d0e 	cdpcc	13, 1, cr6, cr9, cr14, {0}
 150:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
 154:	3b0b3a13 	blcc	2ce9a8 <_bss_end+0x2c5294>
 158:	010b390b 	tsteq	fp, fp, lsl #18
 15c:	0a000013 	beq	1b0 <shift+0x1b0>
 160:	08030028 	stmdaeq	r3, {r3, r5}
 164:	00000b1c 	andeq	r0, r0, ip, lsl fp
 168:	0300280b 	movweq	r2, #2059	; 0x80b
 16c:	000b1c0e 	andeq	r1, fp, lr, lsl #24
 170:	01040c00 	tsteq	r4, r0, lsl #24
 174:	196d0e03 	stmdbne	sp!, {r0, r1, r9, sl, fp}^
 178:	0b0b0b3e 	bleq	2c2e78 <_bss_end+0x2b9764>
 17c:	0b3a1349 	bleq	e84ea8 <_bss_end+0xe7b794>
 180:	0b390b3b 	bleq	e42e74 <_bss_end+0xe39760>
 184:	340d0000 	strcc	r0, [sp], #-0
 188:	00134700 	andseq	r4, r3, r0, lsl #14
 18c:	01020e00 	tsteq	r2, r0, lsl #28
 190:	0b0b0e03 	bleq	2c39a4 <_bss_end+0x2ba290>
 194:	0b3b0b3a 	bleq	ec2e84 <_bss_end+0xeb9770>
 198:	13010b39 	movwne	r0, #6969	; 0x1b39
 19c:	0d0f0000 	stceq	0, cr0, [pc, #-0]	; 1a4 <shift+0x1a4>
 1a0:	3a0e0300 	bcc	380da8 <_bss_end+0x377694>
 1a4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 1a8:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 1ac:	1000000b 	andne	r0, r0, fp
 1b0:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 1b4:	0b3a0e03 	bleq	e839c8 <_bss_end+0xe7a2b4>
 1b8:	0b390b3b 	bleq	e42eac <_bss_end+0xe39798>
 1bc:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 1c0:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 1c4:	13011364 	movwne	r1, #4964	; 0x1364
 1c8:	05110000 	ldreq	r0, [r1, #-0]
 1cc:	34134900 	ldrcc	r4, [r3], #-2304	; 0xfffff700
 1d0:	12000019 	andne	r0, r0, #25
 1d4:	13490005 	movtne	r0, #36869	; 0x9005
 1d8:	2e130000 	cdpcs	0, 1, cr0, cr3, cr0, {0}
 1dc:	03193f01 	tsteq	r9, #1, 30
 1e0:	3b0b3a0e 	blcc	2cea20 <_bss_end+0x2c530c>
 1e4:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 1e8:	3c0b320e 	sfmcc	f3, 4, [fp], {14}
 1ec:	01136419 	tsteq	r3, r9, lsl r4
 1f0:	14000013 	strne	r0, [r0], #-19	; 0xffffffed
 1f4:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 1f8:	0b3a0e03 	bleq	e83a0c <_bss_end+0xe7a2f8>
 1fc:	0b390b3b 	bleq	e42ef0 <_bss_end+0xe397dc>
 200:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 204:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 208:	00001364 	andeq	r1, r0, r4, ror #6
 20c:	0b000f15 	bleq	3e68 <shift+0x3e68>
 210:	0013490b 	andseq	r4, r3, fp, lsl #18
 214:	00341600 	eorseq	r1, r4, r0, lsl #12
 218:	0b3a0e03 	bleq	e83a2c <_bss_end+0xe7a318>
 21c:	0b390b3b 	bleq	e42f10 <_bss_end+0xe397fc>
 220:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
 224:	0000193c 	andeq	r1, r0, ip, lsr r9
 228:	47003417 	smladmi	r0, r7, r4, r3
 22c:	3b0b3a13 	blcc	2cea80 <_bss_end+0x2c536c>
 230:	020b390b 	andeq	r3, fp, #180224	; 0x2c000
 234:	18000018 	stmdane	r0, {r3, r4}
 238:	0e03002e 	cdpeq	0, 0, cr0, cr3, cr14, {1}
 23c:	01111934 	tsteq	r1, r4, lsr r9
 240:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 244:	00194296 	mulseq	r9, r6, r2
 248:	012e1900 			; <UNDEFINED> instruction: 0x012e1900
 24c:	19340e03 	ldmdbne	r4!, {r0, r1, r9, sl, fp}
 250:	06120111 			; <UNDEFINED> instruction: 0x06120111
 254:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 258:	00130119 	andseq	r0, r3, r9, lsl r1
 25c:	00051a00 	andeq	r1, r5, r0, lsl #20
 260:	0b3a0e03 	bleq	e83a74 <_bss_end+0xe7a360>
 264:	0b390b3b 	bleq	e42f58 <_bss_end+0xe39844>
 268:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 26c:	2e1b0000 	cdpcs	0, 1, cr0, cr11, cr0, {0}
 270:	3a134701 	bcc	4d1e7c <_bss_end+0x4c8768>
 274:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 278:	1113640b 	tstne	r3, fp, lsl #8
 27c:	40061201 	andmi	r1, r6, r1, lsl #4
 280:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 284:	00001301 	andeq	r1, r0, r1, lsl #6
 288:	0300051c 	movweq	r0, #1308	; 0x51c
 28c:	3413490e 	ldrcc	r4, [r3], #-2318	; 0xfffff6f2
 290:	00180219 	andseq	r0, r8, r9, lsl r2
 294:	012e1d00 			; <UNDEFINED> instruction: 0x012e1d00
 298:	0b3a1347 	bleq	e84fbc <_bss_end+0xe7b8a8>
 29c:	13640b39 	cmnne	r4, #58368	; 0xe400
 2a0:	06120111 			; <UNDEFINED> instruction: 0x06120111
 2a4:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 2a8:	00130119 	andseq	r0, r3, r9, lsl r1
 2ac:	012e1e00 			; <UNDEFINED> instruction: 0x012e1e00
 2b0:	0b3a1347 	bleq	e84fd4 <_bss_end+0xe7b8c0>
 2b4:	0b390b3b 	bleq	e42fa8 <_bss_end+0xe39894>
 2b8:	01111364 	tsteq	r1, r4, ror #6
 2bc:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 2c0:	01194296 			; <UNDEFINED> instruction: 0x01194296
 2c4:	1f000013 	svcne	0x00000013
 2c8:	1347012e 	movtne	r0, #28974	; 0x712e
 2cc:	0b3b0b3a 	bleq	ec2fbc <_bss_end+0xeb98a8>
 2d0:	13640b39 	cmnne	r4, #58368	; 0xe400
 2d4:	13010b20 	movwne	r0, #6944	; 0x1b20
 2d8:	05200000 	streq	r0, [r0, #-0]!
 2dc:	490e0300 	stmdbmi	lr, {r8, r9}
 2e0:	00193413 	andseq	r3, r9, r3, lsl r4
 2e4:	00052100 	andeq	r2, r5, r0, lsl #2
 2e8:	0b3a0e03 	bleq	e83afc <_bss_end+0xe7a3e8>
 2ec:	0b390b3b 	bleq	e42fe0 <_bss_end+0xe398cc>
 2f0:	00001349 	andeq	r1, r0, r9, asr #6
 2f4:	31012e22 	tstcc	r1, r2, lsr #28
 2f8:	640e6e13 	strvs	r6, [lr], #-3603	; 0xfffff1ed
 2fc:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 300:	97184006 	ldrls	r4, [r8, -r6]
 304:	00001942 	andeq	r1, r0, r2, asr #18
 308:	31000523 	tstcc	r0, r3, lsr #10
 30c:	00180213 	andseq	r0, r8, r3, lsl r2
 310:	11010000 	mrsne	r0, (UNDEF: 1)
 314:	130e2501 	movwne	r2, #58625	; 0xe501
 318:	1b0e030b 	blne	380f4c <_bss_end+0x377838>
 31c:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 320:	00171006 	andseq	r1, r7, r6
 324:	00240200 	eoreq	r0, r4, r0, lsl #4
 328:	0b3e0b0b 	bleq	f82f5c <_bss_end+0xf79848>
 32c:	00000e03 	andeq	r0, r0, r3, lsl #28
 330:	0b002403 	bleq	9344 <_cpp_shutdown+0x3c>
 334:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 338:	04000008 	streq	r0, [r0], #-8
 33c:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
 340:	0b3b0b3a 	bleq	ec3030 <_bss_end+0xeb991c>
 344:	13490b39 	movtne	r0, #39737	; 0x9b39
 348:	26050000 	strcs	r0, [r5], -r0
 34c:	00134900 	andseq	r4, r3, r0, lsl #18
 350:	01390600 	teqeq	r9, r0, lsl #12
 354:	0b3a0803 	bleq	e82368 <_bss_end+0xe78c54>
 358:	0b390b3b 	bleq	e4304c <_bss_end+0xe39938>
 35c:	00001301 	andeq	r1, r0, r1, lsl #6
 360:	03003407 	movweq	r3, #1031	; 0x407
 364:	3b0b3a0e 	blcc	2ceba4 <_bss_end+0x2c5490>
 368:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 36c:	1c193c13 	ldcne	12, cr3, [r9], {19}
 370:	00196c06 	andseq	r6, r9, r6, lsl #24
 374:	00340800 	eorseq	r0, r4, r0, lsl #16
 378:	0b3a0e03 	bleq	e83b8c <_bss_end+0xe7a478>
 37c:	0b390b3b 	bleq	e43070 <_bss_end+0xe3995c>
 380:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 384:	196c0b1c 	stmdbne	ip!, {r2, r3, r4, r8, r9, fp}^
 388:	04090000 	streq	r0, [r9], #-0
 38c:	6d0e0301 	stcvs	3, cr0, [lr, #-4]
 390:	0b0b3e19 	bleq	2cfbfc <_bss_end+0x2c64e8>
 394:	3a13490b 	bcc	4d27c8 <_bss_end+0x4c90b4>
 398:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 39c:	0013010b 	andseq	r0, r3, fp, lsl #2
 3a0:	00280a00 	eoreq	r0, r8, r0, lsl #20
 3a4:	0b1c0e03 	bleq	703bb8 <_bss_end+0x6fa4a4>
 3a8:	340b0000 	strcc	r0, [fp], #-0
 3ac:	00134700 	andseq	r4, r3, r0, lsl #14
 3b0:	01020c00 	tsteq	r2, r0, lsl #24
 3b4:	0b0b0e03 	bleq	2c3bc8 <_bss_end+0x2ba4b4>
 3b8:	0b3b0b3a 	bleq	ec30a8 <_bss_end+0xeb9994>
 3bc:	13010b39 	movwne	r0, #6969	; 0x1b39
 3c0:	0d0d0000 	stceq	0, cr0, [sp, #-0]
 3c4:	3a0e0300 	bcc	380fcc <_bss_end+0x3778b8>
 3c8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 3cc:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 3d0:	0e00000b 	cdpeq	0, 0, cr0, cr0, cr11, {0}
 3d4:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 3d8:	0b3a0e03 	bleq	e83bec <_bss_end+0xe7a4d8>
 3dc:	0b390b3b 	bleq	e430d0 <_bss_end+0xe399bc>
 3e0:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 3e4:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 3e8:	13011364 	movwne	r1, #4964	; 0x1364
 3ec:	050f0000 	streq	r0, [pc, #-0]	; 3f4 <shift+0x3f4>
 3f0:	34134900 	ldrcc	r4, [r3], #-2304	; 0xfffff700
 3f4:	10000019 	andne	r0, r0, r9, lsl r0
 3f8:	13490005 	movtne	r0, #36869	; 0x9005
 3fc:	2e110000 	cdpcs	0, 1, cr0, cr1, cr0, {0}
 400:	03193f01 	tsteq	r9, #1, 30
 404:	3b0b3a0e 	blcc	2cec44 <_bss_end+0x2c5530>
 408:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 40c:	3c0b320e 	sfmcc	f3, 4, [fp], {14}
 410:	01136419 	tsteq	r3, r9, lsl r4
 414:	12000013 	andne	r0, r0, #19
 418:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 41c:	0b3a0e03 	bleq	e83c30 <_bss_end+0xe7a51c>
 420:	0b390b3b 	bleq	e43114 <_bss_end+0xe39a00>
 424:	0b320e6e 	bleq	c83de4 <_bss_end+0xc7a6d0>
 428:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 42c:	0f130000 	svceq	0x00130000
 430:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 434:	14000013 	strne	r0, [r0], #-19	; 0xffffffed
 438:	0b0b0010 	bleq	2c0480 <_bss_end+0x2b6d6c>
 43c:	00001349 	andeq	r1, r0, r9, asr #6
 440:	03003415 	movweq	r3, #1045	; 0x415
 444:	3b0b3a0e 	blcc	2cec84 <_bss_end+0x2c5570>
 448:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 44c:	3c193f13 	ldccc	15, cr3, [r9], {19}
 450:	16000019 			; <UNDEFINED> instruction: 0x16000019
 454:	13470034 	movtne	r0, #28724	; 0x7034
 458:	0b3b0b3a 	bleq	ec3148 <_bss_end+0xeb9a34>
 45c:	18020b39 	stmdane	r2, {r0, r3, r4, r5, r8, r9, fp}
 460:	2e170000 	cdpcs	0, 1, cr0, cr7, cr0, {0}
 464:	340e0300 	strcc	r0, [lr], #-768	; 0xfffffd00
 468:	12011119 	andne	r1, r1, #1073741830	; 0x40000006
 46c:	96184006 	ldrls	r4, [r8], -r6
 470:	00001942 	andeq	r1, r0, r2, asr #18
 474:	03012e18 	movweq	r2, #7704	; 0x1e18
 478:	1119340e 	tstne	r9, lr, lsl #8
 47c:	40061201 	andmi	r1, r6, r1, lsl #4
 480:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
 484:	00001301 	andeq	r1, r0, r1, lsl #6
 488:	03000519 	movweq	r0, #1305	; 0x519
 48c:	3b0b3a0e 	blcc	2ceccc <_bss_end+0x2c55b8>
 490:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 494:	00180213 	andseq	r0, r8, r3, lsl r2
 498:	012e1a00 			; <UNDEFINED> instruction: 0x012e1a00
 49c:	0b3a1347 	bleq	e851c0 <_bss_end+0xe7baac>
 4a0:	0b390b3b 	bleq	e43194 <_bss_end+0xe39a80>
 4a4:	01111364 	tsteq	r1, r4, ror #6
 4a8:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 4ac:	01194296 			; <UNDEFINED> instruction: 0x01194296
 4b0:	1b000013 	blne	504 <shift+0x504>
 4b4:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
 4b8:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
 4bc:	00001802 	andeq	r1, r0, r2, lsl #16
 4c0:	0300051c 	movweq	r0, #1308	; 0x51c
 4c4:	3b0b3a08 	blcc	2cecec <_bss_end+0x2c55d8>
 4c8:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 4cc:	00180213 	andseq	r0, r8, r3, lsl r2
 4d0:	00341d00 	eorseq	r1, r4, r0, lsl #26
 4d4:	0b3a0803 	bleq	e824e8 <_bss_end+0xe78dd4>
 4d8:	0b390b3b 	bleq	e431cc <_bss_end+0xe39ab8>
 4dc:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 4e0:	2e1e0000 	cdpcs	0, 1, cr0, cr14, cr0, {0}
 4e4:	3a134701 	bcc	4d20f0 <_bss_end+0x4c89dc>
 4e8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 4ec:	1113640b 	tstne	r3, fp, lsl #8
 4f0:	40061201 	andmi	r1, r6, r1, lsl #4
 4f4:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 4f8:	00001301 	andeq	r1, r0, r1, lsl #6
 4fc:	47012e1f 	smladmi	r1, pc, lr, r2	; <UNPREDICTABLE>
 500:	3b0b3a13 	blcc	2ced54 <_bss_end+0x2c5640>
 504:	640b390b 	strvs	r3, [fp], #-2315	; 0xfffff6f5
 508:	010b2013 	tsteq	fp, r3, lsl r0
 50c:	20000013 	andcs	r0, r0, r3, lsl r0
 510:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
 514:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
 518:	05210000 	streq	r0, [r1, #-0]!
 51c:	3a0e0300 	bcc	381124 <_bss_end+0x377a10>
 520:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 524:	0013490b 	andseq	r4, r3, fp, lsl #18
 528:	012e2200 			; <UNDEFINED> instruction: 0x012e2200
 52c:	0e6e1331 	mcreq	3, 3, r1, cr14, cr1, {1}
 530:	01111364 	tsteq	r1, r4, ror #6
 534:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 538:	00194297 	mulseq	r9, r7, r2
 53c:	00052300 	andeq	r2, r5, r0, lsl #6
 540:	18021331 	stmdane	r2, {r0, r4, r5, r8, r9, ip}
 544:	01000000 	mrseq	r0, (UNDEF: 0)
 548:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
 54c:	0e030b13 	vmoveq.32	d3[0], r0
 550:	17550e1b 	smmlane	r5, fp, lr, r0
 554:	17100111 			; <UNDEFINED> instruction: 0x17100111
 558:	02020000 	andeq	r0, r2, #0
 55c:	0b0e0301 	bleq	381168 <_bss_end+0x377a54>
 560:	3b0b3a0b 	blcc	2ced94 <_bss_end+0x2c5680>
 564:	010b390b 	tsteq	fp, fp, lsl #18
 568:	03000013 	movweq	r0, #19
 56c:	0e030104 	adfeqs	f0, f3, f4
 570:	0b3e196d 	bleq	f86b2c <_bss_end+0xf7d418>
 574:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 578:	0b3b0b3a 	bleq	ec3268 <_bss_end+0xeb9b54>
 57c:	0b320b39 	bleq	c83268 <_bss_end+0xc79b54>
 580:	00001301 	andeq	r1, r0, r1, lsl #6
 584:	03002804 	movweq	r2, #2052	; 0x804
 588:	000b1c08 	andeq	r1, fp, r8, lsl #24
 58c:	00260500 	eoreq	r0, r6, r0, lsl #10
 590:	00001349 	andeq	r1, r0, r9, asr #6
 594:	03011306 	movweq	r1, #4870	; 0x1306
 598:	3a0b0b0e 	bcc	2c31d8 <_bss_end+0x2b9ac4>
 59c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 5a0:	0013010b 	andseq	r0, r3, fp, lsl #2
 5a4:	000d0700 	andeq	r0, sp, r0, lsl #14
 5a8:	0b3a0803 	bleq	e825bc <_bss_end+0xe78ea8>
 5ac:	0b390b3b 	bleq	e432a0 <_bss_end+0xe39b8c>
 5b0:	0b381349 	bleq	e052dc <_bss_end+0xdfbbc8>
 5b4:	0d080000 	stceq	0, cr0, [r8, #-0]
 5b8:	3a0e0300 	bcc	3811c0 <_bss_end+0x377aac>
 5bc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 5c0:	3f13490b 	svccc	0x0013490b
 5c4:	3c0b3219 	sfmcc	f3, 4, [fp], {25}
 5c8:	6c0b1c19 	stcvs	12, cr1, [fp], {25}
 5cc:	09000019 	stmdbeq	r0, {r0, r3, r4}
 5d0:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 5d4:	0b3b0b3a 	bleq	ec32c4 <_bss_end+0xeb9bb0>
 5d8:	13490b39 	movtne	r0, #39737	; 0x9b39
 5dc:	0b32193f 	bleq	c86ae0 <_bss_end+0xc7d3cc>
 5e0:	196c193c 	stmdbne	ip!, {r2, r3, r4, r5, r8, fp, ip}^
 5e4:	2e0a0000 	cdpcs	0, 0, cr0, cr10, cr0, {0}
 5e8:	03193f01 	tsteq	r9, #1, 30
 5ec:	3b0b3a0e 	blcc	2cee2c <_bss_end+0x2c5718>
 5f0:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 5f4:	3213490e 	andscc	r4, r3, #229376	; 0x38000
 5f8:	63193c0b 	tstvs	r9, #2816	; 0xb00
 5fc:	01136419 	tsteq	r3, r9, lsl r4
 600:	0b000013 	bleq	654 <shift+0x654>
 604:	13490005 	movtne	r0, #36869	; 0x9005
 608:	00001934 	andeq	r1, r0, r4, lsr r9
 60c:	4900050c 	stmdbmi	r0, {r2, r3, r8, sl}
 610:	0d000013 	stceq	0, cr0, [r0, #-76]	; 0xffffffb4
 614:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 618:	0b3a0e03 	bleq	e83e2c <_bss_end+0xe7a718>
 61c:	0b390b3b 	bleq	e43310 <_bss_end+0xe39bfc>
 620:	0b320e6e 	bleq	c83fe0 <_bss_end+0xc7a8cc>
 624:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 628:	00001301 	andeq	r1, r0, r1, lsl #6
 62c:	3f012e0e 	svccc	0x00012e0e
 630:	3a0e0319 	bcc	38129c <_bss_end+0x377b88>
 634:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 638:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 63c:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
 640:	01136419 	tsteq	r3, r9, lsl r4
 644:	0f000013 	svceq	0x00000013
 648:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 64c:	0b3a0e03 	bleq	e83e60 <_bss_end+0xe7a74c>
 650:	0b390b3b 	bleq	e43344 <_bss_end+0xe39c30>
 654:	193c0e6e 	ldmdbne	ip!, {r1, r2, r3, r5, r6, r9, sl, fp}
 658:	13011364 	movwne	r1, #4964	; 0x1364
 65c:	0d100000 	ldceq	0, cr0, [r0, #-0]
 660:	3a0e0300 	bcc	381268 <_bss_end+0x377b54>
 664:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 668:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 66c:	1100000b 	tstne	r0, fp
 670:	0b0b0024 	bleq	2c0708 <_bss_end+0x2b6ff4>
 674:	0e030b3e 	vmoveq.16	d3[0], r0
 678:	0f120000 	svceq	0x00120000
 67c:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 680:	13000013 	movwne	r0, #19
 684:	0b0b0010 	bleq	2c06cc <_bss_end+0x2b6fb8>
 688:	00001349 	andeq	r1, r0, r9, asr #6
 68c:	49003514 	stmdbmi	r0, {r2, r4, r8, sl, ip, sp}
 690:	15000013 	strne	r0, [r0, #-19]	; 0xffffffed
 694:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 698:	0b3b0b3a 	bleq	ec3388 <_bss_end+0xeb9c74>
 69c:	13490b39 	movtne	r0, #39737	; 0x9b39
 6a0:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
 6a4:	34160000 	ldrcc	r0, [r6], #-0
 6a8:	3a134700 	bcc	4d22b0 <_bss_end+0x4c8b9c>
 6ac:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 6b0:	0018020b 	andseq	r0, r8, fp, lsl #4
 6b4:	002e1700 	eoreq	r1, lr, r0, lsl #14
 6b8:	19340e03 	ldmdbne	r4!, {r0, r1, r9, sl, fp}
 6bc:	06120111 			; <UNDEFINED> instruction: 0x06120111
 6c0:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 6c4:	18000019 	stmdane	r0, {r0, r3, r4}
 6c8:	0e03012e 	adfeqsp	f0, f3, #0.5
 6cc:	01111934 	tsteq	r1, r4, lsr r9
 6d0:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 6d4:	01194296 			; <UNDEFINED> instruction: 0x01194296
 6d8:	19000013 	stmdbne	r0, {r0, r1, r4}
 6dc:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
 6e0:	0b3b0b3a 	bleq	ec33d0 <_bss_end+0xeb9cbc>
 6e4:	13490b39 	movtne	r0, #39737	; 0x9b39
 6e8:	00001802 	andeq	r1, r0, r2, lsl #16
 6ec:	0b00241a 	bleq	975c <_bss_end+0x48>
 6f0:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 6f4:	1b000008 	blne	71c <shift+0x71c>
 6f8:	1347012e 	movtne	r0, #28974	; 0x712e
 6fc:	0b3b0b3a 	bleq	ec33ec <_bss_end+0xeb9cd8>
 700:	13640b39 	cmnne	r4, #58368	; 0xe400
 704:	06120111 			; <UNDEFINED> instruction: 0x06120111
 708:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 70c:	00130119 	andseq	r0, r3, r9, lsl r1
 710:	00051c00 	andeq	r1, r5, r0, lsl #24
 714:	13490e03 	movtne	r0, #40451	; 0x9e03
 718:	18021934 	stmdane	r2, {r2, r4, r5, r8, fp, ip}
 71c:	341d0000 	ldrcc	r0, [sp], #-0
 720:	3a080300 	bcc	201328 <_bss_end+0x1f7c14>
 724:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 728:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 72c:	1e000018 	mcrne	0, 0, r0, cr0, cr8, {0}
 730:	0111010b 	tsteq	r1, fp, lsl #2
 734:	00000612 	andeq	r0, r0, r2, lsl r6
 738:	0300051f 	movweq	r0, #1311	; 0x51f
 73c:	3b0b3a08 	blcc	2cef64 <_bss_end+0x2c5850>
 740:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 744:	00180213 	andseq	r0, r8, r3, lsl r2
 748:	00342000 	eorseq	r2, r4, r0
 74c:	0b3a0e03 	bleq	e83f60 <_bss_end+0xe7a84c>
 750:	0b390b3b 	bleq	e43444 <_bss_end+0xe39d30>
 754:	196c1349 	stmdbne	ip!, {r0, r3, r6, r8, r9, ip}^
 758:	00001802 	andeq	r1, r0, r2, lsl #16
 75c:	03003421 	movweq	r3, #1057	; 0x421
 760:	3b0b3a0e 	blcc	2cefa0 <_bss_end+0x2c588c>
 764:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 768:	00180213 	andseq	r0, r8, r3, lsl r2
 76c:	01012200 	mrseq	r2, R9_usr
 770:	13011349 	movwne	r1, #4937	; 0x1349
 774:	21230000 			; <UNDEFINED> instruction: 0x21230000
 778:	2f134900 	svccs	0x00134900
 77c:	2400000b 	strcs	r0, [r0], #-11
 780:	1347012e 	movtne	r0, #28974	; 0x712e
 784:	0b3b0b3a 	bleq	ec3474 <_bss_end+0xeb9d60>
 788:	13640b39 	cmnne	r4, #58368	; 0xe400
 78c:	06120111 			; <UNDEFINED> instruction: 0x06120111
 790:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 794:	00130119 	andseq	r0, r3, r9, lsl r1
 798:	010b2500 	tsteq	fp, r0, lsl #10
 79c:	06120111 			; <UNDEFINED> instruction: 0x06120111
 7a0:	00001301 	andeq	r1, r0, r1, lsl #6
 7a4:	47012e26 	strmi	r2, [r1, -r6, lsr #28]
 7a8:	3b0b3a13 	blcc	2ceffc <_bss_end+0x2c58e8>
 7ac:	640b390b 	strvs	r3, [fp], #-2315	; 0xfffff6f5
 7b0:	010b2013 	tsteq	fp, r3, lsl r0
 7b4:	27000013 	smladcs	r0, r3, r0, r0
 7b8:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
 7bc:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
 7c0:	05280000 	streq	r0, [r8, #-0]!
 7c4:	3a0e0300 	bcc	3813cc <_bss_end+0x377cb8>
 7c8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 7cc:	0013490b 	andseq	r4, r3, fp, lsl #18
 7d0:	012e2900 			; <UNDEFINED> instruction: 0x012e2900
 7d4:	0e6e1331 	mcreq	3, 3, r1, cr14, cr1, {1}
 7d8:	01111364 	tsteq	r1, r4, ror #6
 7dc:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 7e0:	00194297 	mulseq	r9, r7, r2
 7e4:	00052a00 	andeq	r2, r5, r0, lsl #20
 7e8:	18021331 	stmdane	r2, {r0, r4, r5, r8, r9, ip}
 7ec:	01000000 	mrseq	r0, (UNDEF: 0)
 7f0:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
 7f4:	0e030b13 	vmoveq.32	d3[0], r0
 7f8:	01110e1b 	tsteq	r1, fp, lsl lr
 7fc:	17100612 			; <UNDEFINED> instruction: 0x17100612
 800:	24020000 	strcs	r0, [r2], #-0
 804:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 808:	000e030b 	andeq	r0, lr, fp, lsl #6
 80c:	00260300 	eoreq	r0, r6, r0, lsl #6
 810:	00001349 	andeq	r1, r0, r9, asr #6
 814:	0b002404 	bleq	982c <_bss_end+0x118>
 818:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 81c:	05000008 	streq	r0, [r0, #-8]
 820:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
 824:	0b3b0b3a 	bleq	ec3514 <_bss_end+0xeb9e00>
 828:	13490b39 	movtne	r0, #39737	; 0x9b39
 82c:	39060000 	stmdbcc	r6, {}	; <UNPREDICTABLE>
 830:	3a080301 	bcc	20143c <_bss_end+0x1f7d28>
 834:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 838:	0013010b 	andseq	r0, r3, fp, lsl #2
 83c:	00340700 	eorseq	r0, r4, r0, lsl #14
 840:	0b3a0e03 	bleq	e84054 <_bss_end+0xe7a940>
 844:	0b390b3b 	bleq	e43538 <_bss_end+0xe39e24>
 848:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 84c:	196c061c 	stmdbne	ip!, {r2, r3, r4, r9, sl}^
 850:	34080000 	strcc	r0, [r8], #-0
 854:	3a0e0300 	bcc	38145c <_bss_end+0x377d48>
 858:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 85c:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
 860:	6c0b1c19 	stcvs	12, cr1, [fp], {25}
 864:	09000019 	stmdbeq	r0, {r0, r3, r4}
 868:	0e030104 	adfeqs	f0, f3, f4
 86c:	0b3e196d 	bleq	f86e28 <_bss_end+0xf7d714>
 870:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 874:	0b3b0b3a 	bleq	ec3564 <_bss_end+0xeb9e50>
 878:	13010b39 	movwne	r0, #6969	; 0x1b39
 87c:	280a0000 	stmdacs	sl, {}	; <UNPREDICTABLE>
 880:	1c080300 	stcne	3, cr0, [r8], {-0}
 884:	0b00000b 	bleq	8b8 <shift+0x8b8>
 888:	0e030028 	cdpeq	0, 0, cr0, cr3, cr8, {1}
 88c:	00000b1c 	andeq	r0, r0, ip, lsl fp
 890:	0301040c 	movweq	r0, #5132	; 0x140c
 894:	3e196d0e 	cdpcc	13, 1, cr6, cr9, cr14, {0}
 898:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
 89c:	3b0b3a13 	blcc	2cf0f0 <_bss_end+0x2c59dc>
 8a0:	000b390b 	andeq	r3, fp, fp, lsl #18
 8a4:	00340d00 	eorseq	r0, r4, r0, lsl #26
 8a8:	00001347 	andeq	r1, r0, r7, asr #6
 8ac:	0301020e 	movweq	r0, #4622	; 0x120e
 8b0:	3a0b0b0e 	bcc	2c34f0 <_bss_end+0x2b9ddc>
 8b4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 8b8:	0013010b 	andseq	r0, r3, fp, lsl #2
 8bc:	000d0f00 	andeq	r0, sp, r0, lsl #30
 8c0:	0b3a0e03 	bleq	e840d4 <_bss_end+0xe7a9c0>
 8c4:	0b390b3b 	bleq	e435b8 <_bss_end+0xe39ea4>
 8c8:	0b381349 	bleq	e055f4 <_bss_end+0xdfbee0>
 8cc:	2e100000 	cdpcs	0, 1, cr0, cr0, cr0, {0}
 8d0:	03193f01 	tsteq	r9, #1, 30
 8d4:	3b0b3a0e 	blcc	2cf114 <_bss_end+0x2c5a00>
 8d8:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 8dc:	3213490e 	andscc	r4, r3, #229376	; 0x38000
 8e0:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 8e4:	00130113 	andseq	r0, r3, r3, lsl r1
 8e8:	00051100 	andeq	r1, r5, r0, lsl #2
 8ec:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
 8f0:	05120000 	ldreq	r0, [r2, #-0]
 8f4:	00134900 	andseq	r4, r3, r0, lsl #18
 8f8:	012e1300 			; <UNDEFINED> instruction: 0x012e1300
 8fc:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 900:	0b3b0b3a 	bleq	ec35f0 <_bss_end+0xeb9edc>
 904:	0e6e0b39 	vmoveq.8	d14[5], r0
 908:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 90c:	13011364 	movwne	r1, #4964	; 0x1364
 910:	2e140000 	cdpcs	0, 1, cr0, cr4, cr0, {0}
 914:	03193f01 	tsteq	r9, #1, 30
 918:	3b0b3a0e 	blcc	2cf158 <_bss_end+0x2c5a44>
 91c:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 920:	3213490e 	andscc	r4, r3, #229376	; 0x38000
 924:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 928:	15000013 	strne	r0, [r0, #-19]	; 0xffffffed
 92c:	0b0b000f 	bleq	2c0970 <_bss_end+0x2b725c>
 930:	00001349 	andeq	r1, r0, r9, asr #6
 934:	03003416 	movweq	r3, #1046	; 0x416
 938:	3b0b3a0e 	blcc	2cf178 <_bss_end+0x2c5a64>
 93c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 940:	3c193f13 	ldccc	15, cr3, [r9], {19}
 944:	17000019 	smladne	r0, r9, r0, r0
 948:	0e030028 	cdpeq	0, 0, cr0, cr3, cr8, {1}
 94c:	0000051c 	andeq	r0, r0, ip, lsl r5
 950:	03002818 	movweq	r2, #2072	; 0x818
 954:	00061c0e 	andeq	r1, r6, lr, lsl #24
 958:	012e1900 			; <UNDEFINED> instruction: 0x012e1900
 95c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 960:	0b3b0b3a 	bleq	ec3650 <_bss_end+0xeb9f3c>
 964:	0e6e0b39 	vmoveq.8	d14[5], r0
 968:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 96c:	00001364 	andeq	r1, r0, r4, ror #6
 970:	0b00101a 	bleq	49e0 <shift+0x49e0>
 974:	0013490b 	andseq	r4, r3, fp, lsl #18
 978:	00341b00 	eorseq	r1, r4, r0, lsl #22
 97c:	0b3a1347 	bleq	e856a0 <_bss_end+0xe7bf8c>
 980:	0b390b3b 	bleq	e43674 <_bss_end+0xe39f60>
 984:	00001802 	andeq	r1, r0, r2, lsl #16
 988:	03002e1c 	movweq	r2, #3612	; 0xe1c
 98c:	1119340e 	tstne	r9, lr, lsl #8
 990:	40061201 	andmi	r1, r6, r1, lsl #4
 994:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
 998:	2e1d0000 	cdpcs	0, 1, cr0, cr13, cr0, {0}
 99c:	340e0301 	strcc	r0, [lr], #-769	; 0xfffffcff
 9a0:	12011119 	andne	r1, r1, #1073741830	; 0x40000006
 9a4:	96184006 	ldrls	r4, [r8], -r6
 9a8:	13011942 	movwne	r1, #6466	; 0x1942
 9ac:	051e0000 	ldreq	r0, [lr, #-0]
 9b0:	3a0e0300 	bcc	3815b8 <_bss_end+0x377ea4>
 9b4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 9b8:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 9bc:	1f000018 	svcne	0x00000018
 9c0:	1347012e 	movtne	r0, #28974	; 0x712e
 9c4:	0b3b0b3a 	bleq	ec36b4 <_bss_end+0xeb9fa0>
 9c8:	13640b39 	cmnne	r4, #58368	; 0xe400
 9cc:	06120111 			; <UNDEFINED> instruction: 0x06120111
 9d0:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 9d4:	00130119 	andseq	r0, r3, r9, lsl r1
 9d8:	00052000 	andeq	r2, r5, r0
 9dc:	13490e03 	movtne	r0, #40451	; 0x9e03
 9e0:	18021934 	stmdane	r2, {r2, r4, r5, r8, fp, ip}
 9e4:	05210000 	streq	r0, [r1, #-0]!
 9e8:	3a080300 	bcc	2015f0 <_bss_end+0x1f7edc>
 9ec:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 9f0:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 9f4:	22000018 	andcs	r0, r0, #24
 9f8:	08030034 	stmdaeq	r3, {r2, r4, r5}
 9fc:	0b3b0b3a 	bleq	ec36ec <_bss_end+0xeb9fd8>
 a00:	13490b39 	movtne	r0, #39737	; 0x9b39
 a04:	00001802 	andeq	r1, r0, r2, lsl #16
 a08:	03003423 	movweq	r3, #1059	; 0x423
 a0c:	3b0b3a0e 	blcc	2cf24c <_bss_end+0x2c5b38>
 a10:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 a14:	00180213 	andseq	r0, r8, r3, lsl r2
 a18:	00342400 	eorseq	r2, r4, r0, lsl #8
 a1c:	0b3a0e03 	bleq	e84230 <_bss_end+0xe7ab1c>
 a20:	0b390b3b 	bleq	e43714 <_bss_end+0xe3a000>
 a24:	196c1349 	stmdbne	ip!, {r0, r3, r6, r8, r9, ip}^
 a28:	00001802 	andeq	r1, r0, r2, lsl #16
 a2c:	47012e25 	strmi	r2, [r1, -r5, lsr #28]
 a30:	3b0b3a13 	blcc	2cf284 <_bss_end+0x2c5b70>
 a34:	640b390b 	strvs	r3, [fp], #-2315	; 0xfffff6f5
 a38:	010b2013 	tsteq	fp, r3, lsl r0
 a3c:	26000013 			; <UNDEFINED> instruction: 0x26000013
 a40:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
 a44:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
 a48:	05270000 	streq	r0, [r7, #-0]!
 a4c:	3a080300 	bcc	201654 <_bss_end+0x1f7f40>
 a50:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 a54:	0013490b 	andseq	r4, r3, fp, lsl #18
 a58:	012e2800 			; <UNDEFINED> instruction: 0x012e2800
 a5c:	0e6e1331 	mcreq	3, 3, r1, cr14, cr1, {1}
 a60:	01111364 	tsteq	r1, r4, ror #6
 a64:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 a68:	00194296 	mulseq	r9, r6, r2
 a6c:	00052900 	andeq	r2, r5, r0, lsl #18
 a70:	18021331 	stmdane	r2, {r0, r4, r5, r8, r9, ip}
 a74:	01000000 	mrseq	r0, (UNDEF: 0)
 a78:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
 a7c:	0e030b13 	vmoveq.32	d3[0], r0
 a80:	01110e1b 	tsteq	r1, fp, lsl lr
 a84:	17100612 			; <UNDEFINED> instruction: 0x17100612
 a88:	24020000 	strcs	r0, [r2], #-0
 a8c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 a90:	000e030b 	andeq	r0, lr, fp, lsl #6
 a94:	00260300 	eoreq	r0, r6, r0, lsl #6
 a98:	00001349 	andeq	r1, r0, r9, asr #6
 a9c:	0b002404 	bleq	9ab4 <_bss_end+0x3a0>
 aa0:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 aa4:	05000008 	streq	r0, [r0, #-8]
 aa8:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
 aac:	0b3b0b3a 	bleq	ec379c <_bss_end+0xeba088>
 ab0:	13490b39 	movtne	r0, #39737	; 0x9b39
 ab4:	35060000 	strcc	r0, [r6, #-0]
 ab8:	00134900 	andseq	r4, r3, r0, lsl #18
 abc:	01040700 	tsteq	r4, r0, lsl #14
 ac0:	196d0e03 	stmdbne	sp!, {r0, r1, r9, sl, fp}^
 ac4:	0b0b0b3e 	bleq	2c37c4 <_bss_end+0x2ba0b0>
 ac8:	0b3a1349 	bleq	e857f4 <_bss_end+0xe7c0e0>
 acc:	0b390b3b 	bleq	e437c0 <_bss_end+0xe3a0ac>
 ad0:	00001301 	andeq	r1, r0, r1, lsl #6
 ad4:	03002808 	movweq	r2, #2056	; 0x808
 ad8:	000b1c0e 	andeq	r1, fp, lr, lsl #24
 adc:	01020900 	tsteq	r2, r0, lsl #18
 ae0:	0b0b0e03 	bleq	2c42f4 <_bss_end+0x2babe0>
 ae4:	0b3b0b3a 	bleq	ec37d4 <_bss_end+0xeba0c0>
 ae8:	13010b39 	movwne	r0, #6969	; 0x1b39
 aec:	0d0a0000 	stceq	0, cr0, [sl, #-0]
 af0:	3a0e0300 	bcc	3816f8 <_bss_end+0x377fe4>
 af4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 af8:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 afc:	0b00000b 	bleq	b30 <shift+0xb30>
 b00:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 b04:	0b3a0e03 	bleq	e84318 <_bss_end+0xe7ac04>
 b08:	0b390b3b 	bleq	e437fc <_bss_end+0xe3a0e8>
 b0c:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 b10:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 b14:	13011364 	movwne	r1, #4964	; 0x1364
 b18:	050c0000 	streq	r0, [ip, #-0]
 b1c:	34134900 	ldrcc	r4, [r3], #-2304	; 0xfffff700
 b20:	0d000019 	stceq	0, cr0, [r0, #-100]	; 0xffffff9c
 b24:	13490005 	movtne	r0, #36869	; 0x9005
 b28:	2e0e0000 	cdpcs	0, 0, cr0, cr14, cr0, {0}
 b2c:	03193f01 	tsteq	r9, #1, 30
 b30:	3b0b3a0e 	blcc	2cf370 <_bss_end+0x2c5c5c>
 b34:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 b38:	3c0b320e 	sfmcc	f3, 4, [fp], {14}
 b3c:	01136419 	tsteq	r3, r9, lsl r4
 b40:	0f000013 	svceq	0x00000013
 b44:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 b48:	0b3a0e03 	bleq	e8435c <_bss_end+0xe7ac48>
 b4c:	0b390b3b 	bleq	e43840 <_bss_end+0xe3a12c>
 b50:	0b320e6e 	bleq	c84510 <_bss_end+0xc7adfc>
 b54:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 b58:	0f100000 	svceq	0x00100000
 b5c:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 b60:	11000013 	tstne	r0, r3, lsl r0
 b64:	0b0b0010 	bleq	2c0bac <_bss_end+0x2b7498>
 b68:	00001349 	andeq	r1, r0, r9, asr #6
 b6c:	03003412 	movweq	r3, #1042	; 0x412
 b70:	3b0b3a0e 	blcc	2cf3b0 <_bss_end+0x2c5c9c>
 b74:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 b78:	3c193f13 	ldccc	15, cr3, [r9], {19}
 b7c:	13000019 	movwne	r0, #25
 b80:	08030139 	stmdaeq	r3, {r0, r3, r4, r5, r8}
 b84:	0b3b0b3a 	bleq	ec3874 <_bss_end+0xeba160>
 b88:	13010b39 	movwne	r0, #6969	; 0x1b39
 b8c:	34140000 	ldrcc	r0, [r4], #-0
 b90:	3a0e0300 	bcc	381798 <_bss_end+0x378084>
 b94:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 b98:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
 b9c:	6c061c19 	stcvs	12, cr1, [r6], {25}
 ba0:	15000019 	strne	r0, [r0, #-25]	; 0xffffffe7
 ba4:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 ba8:	0b3b0b3a 	bleq	ec3898 <_bss_end+0xeba184>
 bac:	13490b39 	movtne	r0, #39737	; 0x9b39
 bb0:	0b1c193c 	bleq	7070a8 <_bss_end+0x6fd994>
 bb4:	0000196c 	andeq	r1, r0, ip, ror #18
 bb8:	03002816 	movweq	r2, #2070	; 0x816
 bbc:	000b1c08 	andeq	r1, fp, r8, lsl #24
 bc0:	01041700 	tsteq	r4, r0, lsl #14
 bc4:	196d0e03 	stmdbne	sp!, {r0, r1, r9, sl, fp}^
 bc8:	0b0b0b3e 	bleq	2c38c8 <_bss_end+0x2ba1b4>
 bcc:	0b3a1349 	bleq	e858f8 <_bss_end+0xe7c1e4>
 bd0:	0b390b3b 	bleq	e438c4 <_bss_end+0xe3a1b0>
 bd4:	34180000 	ldrcc	r0, [r8], #-0
 bd8:	00134700 	andseq	r4, r3, r0, lsl #14
 bdc:	012e1900 			; <UNDEFINED> instruction: 0x012e1900
 be0:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 be4:	0b3b0b3a 	bleq	ec38d4 <_bss_end+0xeba1c0>
 be8:	0e6e0b39 	vmoveq.8	d14[5], r0
 bec:	0b321349 	bleq	c85918 <_bss_end+0xc7c204>
 bf0:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 bf4:	281a0000 	ldmdacs	sl, {}	; <UNPREDICTABLE>
 bf8:	1c0e0300 	stcne	3, cr0, [lr], {-0}
 bfc:	1b000005 	blne	c18 <shift+0xc18>
 c00:	0e030028 	cdpeq	0, 0, cr0, cr3, cr8, {1}
 c04:	0000061c 	andeq	r0, r0, ip, lsl r6
 c08:	0301041c 	movweq	r0, #5148	; 0x141c
 c0c:	3e196d0e 	cdpcc	13, 1, cr6, cr9, cr14, {0}
 c10:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
 c14:	3b0b3a13 	blcc	2cf468 <_bss_end+0x2c5d54>
 c18:	320b390b 	andcc	r3, fp, #180224	; 0x2c000
 c1c:	0013010b 	andseq	r0, r3, fp, lsl #2
 c20:	01131d00 	tsteq	r3, r0, lsl #26
 c24:	0b0b0e03 	bleq	2c4438 <_bss_end+0x2bad24>
 c28:	0b3b0b3a 	bleq	ec3918 <_bss_end+0xeba204>
 c2c:	13010b39 	movwne	r0, #6969	; 0x1b39
 c30:	0d1e0000 	ldceq	0, cr0, [lr, #-0]
 c34:	3a080300 	bcc	20183c <_bss_end+0x1f8128>
 c38:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 c3c:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 c40:	1f00000b 	svcne	0x0000000b
 c44:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 c48:	0b3b0b3a 	bleq	ec3938 <_bss_end+0xeba224>
 c4c:	13490b39 	movtne	r0, #39737	; 0x9b39
 c50:	0b32193f 	bleq	c87154 <_bss_end+0xc7da40>
 c54:	0b1c193c 	bleq	70714c <_bss_end+0x6fda38>
 c58:	0000196c 	andeq	r1, r0, ip, ror #18
 c5c:	03000d20 	movweq	r0, #3360	; 0xd20
 c60:	3b0b3a0e 	blcc	2cf4a0 <_bss_end+0x2c5d8c>
 c64:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 c68:	32193f13 	andscc	r3, r9, #19, 30	; 0x4c
 c6c:	6c193c0b 	ldcvs	12, cr3, [r9], {11}
 c70:	21000019 	tstcs	r0, r9, lsl r0
 c74:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 c78:	0b3a0e03 	bleq	e8448c <_bss_end+0xe7ad78>
 c7c:	0b390b3b 	bleq	e43970 <_bss_end+0xe3a25c>
 c80:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 c84:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 c88:	13641963 	cmnne	r4, #1622016	; 0x18c000
 c8c:	00001301 	andeq	r1, r0, r1, lsl #6
 c90:	3f012e22 	svccc	0x00012e22
 c94:	3a0e0319 	bcc	381900 <_bss_end+0x3781ec>
 c98:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 c9c:	3c0e6e0b 	stccc	14, cr6, [lr], {11}
 ca0:	01136419 	tsteq	r3, r9, lsl r4
 ca4:	23000013 	movwcs	r0, #19
 ca8:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 cac:	0b3b0b3a 	bleq	ec399c <_bss_end+0xeba288>
 cb0:	13490b39 	movtne	r0, #39737	; 0x9b39
 cb4:	1802196c 	stmdane	r2, {r2, r3, r5, r6, r8, fp, ip}
 cb8:	2e240000 	cdpcs	0, 2, cr0, cr4, cr0, {0}
 cbc:	03193f01 	tsteq	r9, #1, 30
 cc0:	3b0b3a0e 	blcc	2cf500 <_bss_end+0x2c5dec>
 cc4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 cc8:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 ccc:	96184006 	ldrls	r4, [r8], -r6
 cd0:	00001942 	andeq	r1, r0, r2, asr #18
 cd4:	03003425 	movweq	r3, #1061	; 0x425
 cd8:	3b0b3a08 	blcc	2cf500 <_bss_end+0x2c5dec>
 cdc:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 ce0:	00180213 	andseq	r0, r8, r3, lsl r2
 ce4:	11010000 	mrsne	r0, (UNDEF: 1)
 ce8:	11061000 	mrsne	r1, (UNDEF: 6)
 cec:	03011201 	movweq	r1, #4609	; 0x1201
 cf0:	250e1b0e 	strcs	r1, [lr, #-2830]	; 0xfffff4f2
 cf4:	0005130e 	andeq	r1, r5, lr, lsl #6
 cf8:	11010000 	mrsne	r0, (UNDEF: 1)
 cfc:	130e2501 	movwne	r2, #58625	; 0xe501
 d00:	1b0e030b 	blne	381934 <_bss_end+0x378220>
 d04:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 d08:	00171006 	andseq	r1, r7, r6
 d0c:	00160200 	andseq	r0, r6, r0, lsl #4
 d10:	0b3a0e03 	bleq	e84524 <_bss_end+0xe7ae10>
 d14:	0b390b3b 	bleq	e43a08 <_bss_end+0xe3a2f4>
 d18:	00001349 	andeq	r1, r0, r9, asr #6
 d1c:	0b000f03 	bleq	4930 <shift+0x4930>
 d20:	0013490b 	andseq	r4, r3, fp, lsl #18
 d24:	00150400 	andseq	r0, r5, r0, lsl #8
 d28:	34050000 	strcc	r0, [r5], #-0
 d2c:	3a0e0300 	bcc	381934 <_bss_end+0x378220>
 d30:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 d34:	3f13490b 	svccc	0x0013490b
 d38:	00193c19 	andseq	r3, r9, r9, lsl ip
 d3c:	00240600 	eoreq	r0, r4, r0, lsl #12
 d40:	0b3e0b0b 	bleq	f83974 <_bss_end+0xf7a260>
 d44:	00000803 	andeq	r0, r0, r3, lsl #16
 d48:	49010107 	stmdbmi	r1, {r0, r1, r2, r8}
 d4c:	00130113 	andseq	r0, r3, r3, lsl r1
 d50:	00210800 	eoreq	r0, r1, r0, lsl #16
 d54:	062f1349 	strteq	r1, [pc], -r9, asr #6
 d58:	24090000 	strcs	r0, [r9], #-0
 d5c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 d60:	000e030b 	andeq	r0, lr, fp, lsl #6
 d64:	012e0a00 			; <UNDEFINED> instruction: 0x012e0a00
 d68:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 d6c:	0b3b0b3a 	bleq	ec3a5c <_bss_end+0xeba348>
 d70:	13490b39 	movtne	r0, #39737	; 0x9b39
 d74:	06120111 			; <UNDEFINED> instruction: 0x06120111
 d78:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 d7c:	00130119 	andseq	r0, r3, r9, lsl r1
 d80:	00340b00 	eorseq	r0, r4, r0, lsl #22
 d84:	0b3a0e03 	bleq	e84598 <_bss_end+0xe7ae84>
 d88:	0b390b3b 	bleq	e43a7c <_bss_end+0xe3a368>
 d8c:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 d90:	2e0c0000 	cdpcs	0, 0, cr0, cr12, cr0, {0}
 d94:	03193f01 	tsteq	r9, #1, 30
 d98:	3b0b3a0e 	blcc	2cf5d8 <_bss_end+0x2c5ec4>
 d9c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 da0:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 da4:	97184006 	ldrls	r4, [r8, -r6]
 da8:	13011942 	movwne	r1, #6466	; 0x1942
 dac:	340d0000 	strcc	r0, [sp], #-0
 db0:	3a080300 	bcc	2019b8 <_bss_end+0x1f82a4>
 db4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 db8:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 dbc:	00000018 	andeq	r0, r0, r8, lsl r0
 dc0:	10001101 	andne	r1, r0, r1, lsl #2
 dc4:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
 dc8:	1b0e0301 	blne	3819d4 <_bss_end+0x3782c0>
 dcc:	130e250e 	movwne	r2, #58638	; 0xe50e
 dd0:	00000005 	andeq	r0, r0, r5
 dd4:	10001101 	andne	r1, r0, r1, lsl #2
 dd8:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
 ddc:	1b0e0301 	blne	3819e8 <_bss_end+0x3782d4>
 de0:	130e250e 	movwne	r2, #58638	; 0xe50e
 de4:	00000005 	andeq	r0, r0, r5
 de8:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
 dec:	030b130e 	movweq	r1, #45838	; 0xb30e
 df0:	100e1b0e 	andne	r1, lr, lr, lsl #22
 df4:	02000017 	andeq	r0, r0, #23
 df8:	0b0b0024 	bleq	2c0e90 <_bss_end+0x2b777c>
 dfc:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
 e00:	24030000 	strcs	r0, [r3], #-0
 e04:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 e08:	000e030b 	andeq	r0, lr, fp, lsl #6
 e0c:	01040400 	tsteq	r4, r0, lsl #8
 e10:	0b3e0e03 	bleq	f84624 <_bss_end+0xf7af10>
 e14:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 e18:	0b3b0b3a 	bleq	ec3b08 <_bss_end+0xeba3f4>
 e1c:	13010b39 	movwne	r0, #6969	; 0x1b39
 e20:	28050000 	stmdacs	r5, {}	; <UNPREDICTABLE>
 e24:	1c0e0300 	stcne	3, cr0, [lr], {-0}
 e28:	0600000b 	streq	r0, [r0], -fp
 e2c:	0e030113 	mcreq	1, 0, r0, cr3, cr3, {0}
 e30:	0b3a0b0b 	bleq	e83a64 <_bss_end+0xe7a350>
 e34:	0b39053b 	bleq	e42328 <_bss_end+0xe38c14>
 e38:	00001301 	andeq	r1, r0, r1, lsl #6
 e3c:	03000d07 	movweq	r0, #3335	; 0xd07
 e40:	3b0b3a0e 	blcc	2cf680 <_bss_end+0x2c5f6c>
 e44:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
 e48:	000b3813 	andeq	r3, fp, r3, lsl r8
 e4c:	00260800 	eoreq	r0, r6, r0, lsl #16
 e50:	00001349 	andeq	r1, r0, r9, asr #6
 e54:	49010109 	stmdbmi	r1, {r0, r3, r8}
 e58:	00130113 	andseq	r0, r3, r3, lsl r1
 e5c:	00210a00 	eoreq	r0, r1, r0, lsl #20
 e60:	0b2f1349 	bleq	bc5b8c <_bss_end+0xbbc478>
 e64:	340b0000 	strcc	r0, [fp], #-0
 e68:	3a0e0300 	bcc	381a70 <_bss_end+0x37835c>
 e6c:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 e70:	1c13490b 			; <UNDEFINED> instruction: 0x1c13490b
 e74:	0c00000a 	stceq	0, cr0, [r0], {10}
 e78:	19270015 	stmdbne	r7!, {r0, r2, r4}
 e7c:	0f0d0000 	svceq	0x000d0000
 e80:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 e84:	0e000013 	mcreq	0, 0, r0, cr0, cr3, {0}
 e88:	0e030104 	adfeqs	f0, f3, f4
 e8c:	0b0b0b3e 	bleq	2c3b8c <_bss_end+0x2ba478>
 e90:	0b3a1349 	bleq	e85bbc <_bss_end+0xe7c4a8>
 e94:	0b39053b 	bleq	e42388 <_bss_end+0xe38c74>
 e98:	00001301 	andeq	r1, r0, r1, lsl #6
 e9c:	0300160f 	movweq	r1, #1551	; 0x60f
 ea0:	3b0b3a0e 	blcc	2cf6e0 <_bss_end+0x2c5fcc>
 ea4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 ea8:	10000013 	andne	r0, r0, r3, lsl r0
 eac:	00000021 	andeq	r0, r0, r1, lsr #32
 eb0:	03003411 	movweq	r3, #1041	; 0x411
 eb4:	3b0b3a0e 	blcc	2cf6f4 <_bss_end+0x2c5fe0>
 eb8:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 ebc:	3c193f13 	ldccc	15, cr3, [r9], {19}
 ec0:	12000019 	andne	r0, r0, #25
 ec4:	13470034 	movtne	r0, #28724	; 0x7034
 ec8:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 ecc:	13490b39 	movtne	r0, #39737	; 0x9b39
 ed0:	00001802 	andeq	r1, r0, r2, lsl #16
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
  34:	000001c8 	andeq	r0, r0, r8, asr #3
	...
  40:	0000001c 	andeq	r0, r0, ip, lsl r0
  44:	051d0002 	ldreq	r0, [sp, #-2]
  48:	00040000 	andeq	r0, r4, r0
  4c:	00000000 	andeq	r0, r0, r0
  50:	000082b8 			; <UNDEFINED> instruction: 0x000082b8
  54:	00000500 	andeq	r0, r0, r0, lsl #10
	...
  60:	00000034 	andeq	r0, r0, r4, lsr r0
  64:	0ba60002 	bleq	fe980074 <_bss_end+0xfe976960>
  68:	00040000 	andeq	r0, r4, r0
  6c:	00000000 	andeq	r0, r0, r0
  70:	000087b8 			; <UNDEFINED> instruction: 0x000087b8
  74:	00000648 	andeq	r0, r0, r8, asr #12
  78:	00008e00 	andeq	r8, r0, r0, lsl #28
  7c:	00000038 	andeq	r0, r0, r8, lsr r0
  80:	00008e38 	andeq	r8, r0, r8, lsr lr
  84:	00000088 	andeq	r0, r0, r8, lsl #1
  88:	00008ec0 	andeq	r8, r0, r0, asr #29
  8c:	0000002c 	andeq	r0, r0, ip, lsr #32
	...
  98:	0000001c 	andeq	r0, r0, ip, lsl r0
  9c:	125e0002 	subsne	r0, lr, #2
  a0:	00040000 	andeq	r0, r4, r0
  a4:	00000000 	andeq	r0, r0, r0
  a8:	00008eec 	andeq	r8, r0, ip, ror #29
  ac:	000002fc 	strdeq	r0, [r0], -ip
	...
  b8:	0000001c 	andeq	r0, r0, ip, lsl r0
  bc:	17d10002 	ldrbne	r0, [r1, r2]
  c0:	00040000 	andeq	r0, r4, r0
  c4:	00000000 	andeq	r0, r0, r0
  c8:	000091e8 	andeq	r9, r0, r8, ror #3
  cc:	00000060 	andeq	r0, r0, r0, rrx
	...
  d8:	0000001c 	andeq	r0, r0, ip, lsl r0
  dc:	200a0002 	andcs	r0, sl, r2
  e0:	00040000 	andeq	r0, r4, r0
  e4:	00000000 	andeq	r0, r0, r0
  e8:	00008000 	andeq	r8, r0, r0
  ec:	00000018 	andeq	r0, r0, r8, lsl r0
	...
  f8:	0000001c 	andeq	r0, r0, ip, lsl r0
  fc:	20300002 	eorscs	r0, r0, r2
 100:	00040000 	andeq	r0, r4, r0
 104:	00000000 	andeq	r0, r0, r0
 108:	00009248 	andeq	r9, r0, r8, asr #4
 10c:	00000118 	andeq	r0, r0, r8, lsl r1
	...
 118:	0000001c 	andeq	r0, r0, ip, lsl r0
 11c:	217f0002 	cmncs	pc, r2
 120:	00040000 	andeq	r0, r4, r0
 124:	00000000 	andeq	r0, r0, r0
 128:	00009360 	andeq	r9, r0, r0, ror #6
 12c:	0000020c 	andeq	r0, r0, ip, lsl #4
	...
 138:	0000001c 	andeq	r0, r0, ip, lsl r0
 13c:	21a50002 			; <UNDEFINED> instruction: 0x21a50002
 140:	00040000 	andeq	r0, r4, r0
 144:	00000000 	andeq	r0, r0, r0
 148:	0000956c 	andeq	r9, r0, ip, ror #10
 14c:	00000004 	andeq	r0, r0, r4
	...
 158:	00000014 	andeq	r0, r0, r4, lsl r0
 15c:	21cb0002 	biccs	r0, fp, r2
 160:	00040000 	andeq	r0, r4, r0
	...

Disassembly of section .debug_line:

00000000 <.debug_line>:
   0:	0000008f 	andeq	r0, r0, pc, lsl #1
   4:	00560003 	subseq	r0, r6, r3
   8:	01020000 	mrseq	r0, (UNDEF: 2)
   c:	000d0efb 	strdeq	r0, [sp], -fp
  10:	01010101 	tsteq	r1, r1, lsl #2
  14:	01000000 	mrseq	r0, (UNDEF: 0)
  18:	2f010000 	svccs	0x00010000
  1c:	2f746e6d 	svccs	0x00746e6d
  20:	73552f63 	cmpvc	r5, #396	; 0x18c
  24:	2f737265 	svccs	0x00737265
  28:	6162754b 	cmnvs	r2, fp, asr #10
  2c:	776f442f 	strbvc	r4, [pc, -pc, lsr #8]!
  30:	616f6c6e 	cmnvs	pc, lr, ror #24
  34:	302f7364 	eorcc	r7, pc, r4, ror #6
  38:	656b2f33 	strbvs	r2, [fp, #-3891]!	; 0xfffff0cd
  3c:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
  40:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
  44:	78630000 	stmdavc	r3!, {}^	; <UNPREDICTABLE>
  48:	70632e78 	rsbvc	r2, r3, r8, ror lr
  4c:	00010070 	andeq	r0, r1, r0, ror r0
  50:	75623c00 	strbvc	r3, [r2, #-3072]!	; 0xfffff400
  54:	2d746c69 	ldclcs	12, cr6, [r4, #-420]!	; 0xfffffe5c
  58:	003e6e69 	eorseq	r6, lr, r9, ror #28
  5c:	00000000 	andeq	r0, r0, r0
  60:	05000205 	streq	r0, [r0, #-517]	; 0xfffffdfb
  64:	00801802 	addeq	r1, r0, r2, lsl #16
  68:	010a0300 	mrseq	r0, (UNDEF: 58)
  6c:	05830b05 	streq	r0, [r3, #2821]	; 0xb05
  70:	02054a0a 	andeq	r4, r5, #40960	; 0xa000
  74:	0e058583 	cfsh32eq	mvfx8, mvfx5, #-61
  78:	67020583 	strvs	r0, [r2, -r3, lsl #11]
  7c:	01058485 	smlabbeq	r5, r5, r4, r8
  80:	4c854c86 	stcmi	12, cr4, [r5], {134}	; 0x86
  84:	05854c85 	streq	r4, [r5, #3205]	; 0xc85
  88:	04020002 	streq	r0, [r2], #-2
  8c:	02024b01 	andeq	r4, r2, #1024	; 0x400
  90:	61010100 	mrsvs	r0, (UNDEF: 17)
  94:	03000001 	movweq	r0, #1
  98:	0000f100 	andeq	pc, r0, r0, lsl #2
  9c:	fb010200 	blx	408a6 <_bss_end+0x37192>
  a0:	01000d0e 	tsteq	r0, lr, lsl #26
  a4:	00010101 	andeq	r0, r1, r1, lsl #2
  a8:	00010000 	andeq	r0, r1, r0
  ac:	6d2f0100 	stfvss	f0, [pc, #-0]	; b4 <shift+0xb4>
  b0:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
  b4:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
  b8:	4b2f7372 	blmi	bdce88 <_bss_end+0xbd3774>
  bc:	2f616275 	svccs	0x00616275
  c0:	6e776f44 	cdpvs	15, 7, cr6, cr7, cr4, {2}
  c4:	64616f6c 	strbtvs	r6, [r1], #-3948	; 0xfffff094
  c8:	33302f73 	teqcc	r0, #460	; 0x1cc
  cc:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
  d0:	2f6c656e 	svccs	0x006c656e
  d4:	2f637273 	svccs	0x00637273
  d8:	76697264 	strbtvc	r7, [r9], -r4, ror #4
  dc:	00737265 	rsbseq	r7, r3, r5, ror #4
  e0:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
  e4:	552f632f 	strpl	r6, [pc, #-815]!	; fffffdbd <_bss_end+0xffff66a9>
  e8:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
  ec:	62754b2f 	rsbsvs	r4, r5, #48128	; 0xbc00
  f0:	6f442f61 	svcvs	0x00442f61
  f4:	6f6c6e77 	svcvs	0x006c6e77
  f8:	2f736461 	svccs	0x00736461
  fc:	6b2f3330 	blvs	bccdc4 <_bss_end+0xbc36b0>
 100:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 104:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
 108:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 10c:	6f622f65 	svcvs	0x00622f65
 110:	2f647261 	svccs	0x00647261
 114:	30697072 	rsbcc	r7, r9, r2, ror r0
 118:	6c61682f 	stclvs	8, cr6, [r1], #-188	; 0xffffff44
 11c:	6e6d2f00 	cdpvs	15, 6, cr2, cr13, cr0, {0}
 120:	2f632f74 	svccs	0x00632f74
 124:	72657355 	rsbvc	r7, r5, #1409286145	; 0x54000001
 128:	754b2f73 	strbvc	r2, [fp, #-3955]	; 0xfffff08d
 12c:	442f6162 	strtmi	r6, [pc], #-354	; 134 <shift+0x134>
 130:	6c6e776f 	stclvs	7, cr7, [lr], #-444	; 0xfffffe44
 134:	7364616f 	cmnvc	r4, #-1073741797	; 0xc000001b
 138:	2f33302f 	svccs	0x0033302f
 13c:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 140:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 144:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 148:	642f6564 	strtvs	r6, [pc], #-1380	; 150 <shift+0x150>
 14c:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
 150:	00007372 	andeq	r7, r0, r2, ror r3
 154:	5f6d6362 	svcpl	0x006d6362
 158:	2e787561 	cdpcs	5, 7, cr7, cr8, cr1, {3}
 15c:	00707063 	rsbseq	r7, r0, r3, rrx
 160:	70000001 	andvc	r0, r0, r1
 164:	70697265 	rsbvc	r7, r9, r5, ror #4
 168:	61726568 	cmnvs	r2, r8, ror #10
 16c:	682e736c 	stmdavs	lr!, {r2, r3, r5, r6, r8, r9, ip, sp, lr}
 170:	00000200 	andeq	r0, r0, r0, lsl #4
 174:	5f6d6362 	svcpl	0x006d6362
 178:	2e787561 	cdpcs	5, 7, cr7, cr8, cr1, {3}
 17c:	00030068 	andeq	r0, r3, r8, rrx
 180:	746e6900 	strbtvc	r6, [lr], #-2304	; 0xfffff700
 184:	2e666564 	cdpcs	5, 6, cr6, cr6, cr4, {3}
 188:	00020068 	andeq	r0, r2, r8, rrx
 18c:	01050000 	mrseq	r0, (UNDEF: 5)
 190:	f0020500 			; <UNDEFINED> instruction: 0xf0020500
 194:	16000080 	strne	r0, [r0], -r0, lsl #1
 198:	059f3905 	ldreq	r3, [pc, #2309]	; aa5 <shift+0xaa5>
 19c:	05a16901 	streq	r6, [r1, #2305]!	; 0x901
 1a0:	55059f35 	strpl	r9, [r5, #-3893]	; 0xfffff0cb
 1a4:	2e520582 	cdpcs	5, 5, cr0, cr2, cr2, {4}
 1a8:	054a1105 	strbeq	r1, [sl, #-261]	; 0xfffffefb
 1ac:	05699f01 	strbeq	r9, [r9, #-3841]!	; 0xfffff0ff
 1b0:	56059f35 			; <UNDEFINED> instruction: 0x56059f35
 1b4:	2e530582 	cdpcs	5, 5, cr0, cr3, cr2, {4}
 1b8:	054a4f05 	strbeq	r4, [sl, #-3845]	; 0xfffff0fb
 1bc:	01052e11 	tsteq	r5, r1, lsl lr
 1c0:	0505699f 	streq	r6, [r5, #-2463]	; 0xfffff661
 1c4:	4a0e05bb 	bmi	3818b8 <_bss_end+0x3781a4>
 1c8:	052e3005 	streq	r3, [lr, #-5]!
 1cc:	01054a32 	tsteq	r5, r2, lsr sl
 1d0:	0c05854b 	cfstr32eq	mvfx8, [r5], {75}	; 0x4b
 1d4:	4a15059f 	bmi	541858 <_bss_end+0x538144>
 1d8:	052e3705 	streq	r3, [lr, #-1797]!	; 0xfffff8fb
 1dc:	9e826701 	cdpls	7, 8, cr6, cr2, cr1, {0}
 1e0:	01040200 	mrseq	r0, R12_usr
 1e4:	18056606 	stmdane	r5, {r1, r2, r9, sl, sp, lr}
 1e8:	82660306 	rsbhi	r0, r6, #402653184	; 0x18000000
 1ec:	1a030105 	bne	c0608 <_bss_end+0xb6ef4>
 1f0:	024aba66 	subeq	fp, sl, #417792	; 0x66000
 1f4:	0101000a 	tsteq	r1, sl
 1f8:	000002a0 	andeq	r0, r0, r0, lsr #5
 1fc:	00eb0003 	rsceq	r0, fp, r3
 200:	01020000 	mrseq	r0, (UNDEF: 2)
 204:	000d0efb 	strdeq	r0, [sp], -fp
 208:	01010101 	tsteq	r1, r1, lsl #2
 20c:	01000000 	mrseq	r0, (UNDEF: 0)
 210:	2f010000 	svccs	0x00010000
 214:	2f746e6d 	svccs	0x00746e6d
 218:	73552f63 	cmpvc	r5, #396	; 0x18c
 21c:	2f737265 	svccs	0x00737265
 220:	6162754b 	cmnvs	r2, fp, asr #10
 224:	776f442f 	strbvc	r4, [pc, -pc, lsr #8]!
 228:	616f6c6e 	cmnvs	pc, lr, ror #24
 22c:	302f7364 	eorcc	r7, pc, r4, ror #6
 230:	656b2f33 	strbvs	r2, [fp, #-3891]!	; 0xfffff0cd
 234:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
 238:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
 23c:	6972642f 	ldmdbvs	r2!, {r0, r1, r2, r3, r5, sl, sp, lr}^
 240:	73726576 	cmnvc	r2, #494927872	; 0x1d800000
 244:	6e6d2f00 	cdpvs	15, 6, cr2, cr13, cr0, {0}
 248:	2f632f74 	svccs	0x00632f74
 24c:	72657355 	rsbvc	r7, r5, #1409286145	; 0x54000001
 250:	754b2f73 	strbvc	r2, [fp, #-3955]	; 0xfffff08d
 254:	442f6162 	strtmi	r6, [pc], #-354	; 25c <shift+0x25c>
 258:	6c6e776f 	stclvs	7, cr7, [lr], #-444	; 0xfffffe44
 25c:	7364616f 	cmnvc	r4, #-1073741797	; 0xc000001b
 260:	2f33302f 	svccs	0x0033302f
 264:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 268:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 26c:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 270:	622f6564 	eorvs	r6, pc, #100, 10	; 0x19000000
 274:	6472616f 	ldrbtvs	r6, [r2], #-367	; 0xfffffe91
 278:	6970722f 	ldmdbvs	r0!, {r0, r1, r2, r3, r5, r9, ip, sp, lr}^
 27c:	61682f30 	cmnvs	r8, r0, lsr pc
 280:	6d2f006c 	stcvs	0, cr0, [pc, #-432]!	; d8 <shift+0xd8>
 284:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
 288:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
 28c:	4b2f7372 	blmi	bdd05c <_bss_end+0xbd3948>
 290:	2f616275 	svccs	0x00616275
 294:	6e776f44 	cdpvs	15, 7, cr6, cr7, cr4, {2}
 298:	64616f6c 	strbtvs	r6, [r1], #-3948	; 0xfffff094
 29c:	33302f73 	teqcc	r0, #460	; 0x1cc
 2a0:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 2a4:	2f6c656e 	svccs	0x006c656e
 2a8:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 2ac:	2f656475 	svccs	0x00656475
 2b0:	76697264 	strbtvc	r7, [r9], -r4, ror #4
 2b4:	00737265 	rsbseq	r7, r3, r5, ror #4
 2b8:	69706700 	ldmdbvs	r0!, {r8, r9, sl, sp, lr}^
 2bc:	70632e6f 	rsbvc	r2, r3, pc, ror #28
 2c0:	00010070 	andeq	r0, r1, r0, ror r0
 2c4:	746e6900 	strbtvc	r6, [lr], #-2304	; 0xfffff700
 2c8:	2e666564 	cdpcs	5, 6, cr6, cr6, cr4, {3}
 2cc:	00020068 	andeq	r0, r2, r8, rrx
 2d0:	72657000 	rsbvc	r7, r5, #0
 2d4:	65687069 	strbvs	r7, [r8, #-105]!	; 0xffffff97
 2d8:	736c6172 	cmnvc	ip, #-2147483620	; 0x8000001c
 2dc:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 2e0:	70670000 	rsbvc	r0, r7, r0
 2e4:	682e6f69 	stmdavs	lr!, {r0, r3, r5, r6, r8, r9, sl, fp, sp, lr}
 2e8:	00000300 	andeq	r0, r0, r0, lsl #6
 2ec:	00010500 	andeq	r0, r1, r0, lsl #10
 2f0:	82b80205 	adcshi	r0, r8, #1342177280	; 0x50000000
 2f4:	05170000 	ldreq	r0, [r7, #-0]
 2f8:	01059f39 	tsteq	r5, r9, lsr pc
 2fc:	0205a169 	andeq	sl, r5, #1073741850	; 0x4000001a
 300:	670a05d7 			; <UNDEFINED> instruction: 0x670a05d7
 304:	054c0e05 	strbeq	r0, [ip, #-3589]	; 0xfffff1fb
 308:	0f058202 	svceq	0x00058202
 30c:	40052208 	andmi	r2, r5, r8, lsl #4
 310:	2f0f0566 	svccs	0x000f0566
 314:	05664005 	strbeq	r4, [r6, #-5]!
 318:	40052f0f 	andmi	r2, r5, pc, lsl #30
 31c:	2f0f0566 	svccs	0x000f0566
 320:	05664005 	strbeq	r4, [r6, #-5]!
 324:	40052f0f 	andmi	r2, r5, pc, lsl #30
 328:	2f0f0566 	svccs	0x000f0566
 32c:	05664005 	strbeq	r4, [r6, #-5]!
 330:	17053111 	smladne	r5, r1, r1, r3
 334:	0a052008 	beq	14835c <_bss_end+0x13ec48>
 338:	4c090566 	cfstr32mi	mvfx0, [r9], {102}	; 0x66
 33c:	a12f0105 			; <UNDEFINED> instruction: 0xa12f0105
 340:	05d70205 	ldrbeq	r0, [r7, #517]	; 0x205
 344:	0805670a 	stmdaeq	r5, {r1, r3, r8, r9, sl, sp, lr}
 348:	0402004c 	streq	r0, [r2], #-76	; 0xffffffb4
 34c:	00660601 	rsbeq	r0, r6, r1, lsl #12
 350:	4a020402 	bmi	81360 <_bss_end+0x77c4c>
 354:	02000605 	andeq	r0, r0, #5242880	; 0x500000
 358:	2e060404 	cdpcs	4, 0, cr0, cr6, cr4, {0}
 35c:	02001005 	andeq	r1, r0, #5
 360:	054b0404 	strbeq	r0, [fp, #-1028]	; 0xfffffbfc
 364:	0402000a 	streq	r0, [r2], #-10
 368:	09054a04 	stmdbeq	r5, {r2, r9, fp, lr}
 36c:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
 370:	2f01054c 	svccs	0x0001054c
 374:	d7020585 	strle	r0, [r2, -r5, lsl #11]
 378:	05670a05 	strbeq	r0, [r7, #-2565]!	; 0xfffff5fb
 37c:	02004c08 	andeq	r4, r0, #8, 24	; 0x800
 380:	66060104 	strvs	r0, [r6], -r4, lsl #2
 384:	02040200 	andeq	r0, r4, #0, 4
 388:	0006054a 	andeq	r0, r6, sl, asr #10
 38c:	06040402 	streq	r0, [r4], -r2, lsl #8
 390:	0010052e 	andseq	r0, r0, lr, lsr #10
 394:	4b040402 	blmi	1013a4 <_bss_end+0xf7c90>
 398:	02000a05 	andeq	r0, r0, #20480	; 0x5000
 39c:	054a0404 	strbeq	r0, [sl, #-1028]	; 0xfffffbfc
 3a0:	04020009 	streq	r0, [r2], #-9
 3a4:	01054c04 	tsteq	r5, r4, lsl #24
 3a8:	0205852f 	andeq	r8, r5, #197132288	; 0xbc00000
 3ac:	670a05d7 			; <UNDEFINED> instruction: 0x670a05d7
 3b0:	004c0805 	subeq	r0, ip, r5, lsl #16
 3b4:	06010402 	streq	r0, [r1], -r2, lsl #8
 3b8:	04020066 	streq	r0, [r2], #-102	; 0xffffff9a
 3bc:	06054a02 	streq	r4, [r5], -r2, lsl #20
 3c0:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
 3c4:	10052e06 	andne	r2, r5, r6, lsl #28
 3c8:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
 3cc:	000a054b 	andeq	r0, sl, fp, asr #10
 3d0:	4a040402 	bmi	1013e0 <_bss_end+0xf7ccc>
 3d4:	02000905 	andeq	r0, r0, #81920	; 0x14000
 3d8:	054c0404 	strbeq	r0, [ip, #-1028]	; 0xfffffbfc
 3dc:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 3e0:	0205d819 	andeq	sp, r5, #1638400	; 0x190000
 3e4:	4d1005ba 	cfldr32mi	mvfx0, [r0, #-744]	; 0xfffffd18
 3e8:	054a1905 	strbeq	r1, [sl, #-2309]	; 0xfffff6fb
 3ec:	1e05823b 	mcrne	2, 0, r8, cr5, cr11, {1}
 3f0:	2e1b0566 	cfmsc32cs	mvfx0, mvfx11, mvfx6
 3f4:	052f0805 	streq	r0, [pc, #-2053]!	; fffffbf7 <_bss_end+0xffff64e3>
 3f8:	02052e28 	andeq	r2, r5, #40, 28	; 0x280
 3fc:	4a0b0549 	bmi	2c1928 <_bss_end+0x2b8214>
 400:	05670505 	strbeq	r0, [r7, #-1285]!	; 0xfffffafb
 404:	03052d0d 	movweq	r2, #23821	; 0x5d0d
 408:	32010548 	andcc	r0, r1, #72, 10	; 0x12000000
 40c:	a019054d 	andsge	r0, r9, sp, asr #10
 410:	05ba0205 	ldreq	r0, [sl, #517]!	; 0x205
 414:	26054b1a 			; <UNDEFINED> instruction: 0x26054b1a
 418:	4a2f054c 	bmi	bc1950 <_bss_end+0xbb823c>
 41c:	05823105 	streq	r3, [r2, #261]	; 0x105
 420:	3c054a09 			; <UNDEFINED> instruction: 0x3c054a09
 424:	0001052e 	andeq	r0, r1, lr, lsr #10
 428:	4b010402 	blmi	41438 <_bss_end+0x37d24>
 42c:	d8080569 	stmdale	r8, {r0, r3, r5, r6, r8, sl}
 430:	05663205 	strbeq	r3, [r6, #-517]!	; 0xfffffdfb
 434:	04020021 	streq	r0, [r2], #-33	; 0xffffffdf
 438:	06054a02 	streq	r4, [r5], -r2, lsl #20
 43c:	02040200 	andeq	r0, r4, #0, 4
 440:	003205f2 	ldrshteq	r0, [r2], -r2
 444:	4a030402 	bmi	c1454 <_bss_end+0xb7d40>
 448:	02005105 	andeq	r5, r0, #1073741825	; 0x40000001
 44c:	05660604 	strbeq	r0, [r6, #-1540]!	; 0xfffff9fc
 450:	04020035 	streq	r0, [r2], #-53	; 0xffffffcb
 454:	3205f206 	andcc	pc, r5, #1610612736	; 0x60000000
 458:	07040200 	streq	r0, [r4, -r0, lsl #4]
 45c:	0402004a 	streq	r0, [r2], #-74	; 0xffffffb6
 460:	054a0608 	strbeq	r0, [sl, #-1544]	; 0xfffff9f8
 464:	04020002 	streq	r0, [r2], #-2
 468:	052e060a 	streq	r0, [lr, #-1546]!	; 0xfffff9f6
 46c:	02054d12 	andeq	r4, r5, #1152	; 0x480
 470:	4a0b0566 	bmi	2c1a10 <_bss_end+0x2b82fc>
 474:	05661205 	strbeq	r1, [r6, #-517]!	; 0xfffffdfb
 478:	03052e0d 	movweq	r2, #24077	; 0x5e0d
 47c:	31010548 	tstcc	r1, r8, asr #10
 480:	02009e4a 	andeq	r9, r0, #1184	; 0x4a0
 484:	66060104 	strvs	r0, [r6], -r4, lsl #2
 488:	03062305 	movweq	r2, #25349	; 0x6305
 48c:	05827fa9 	streq	r7, [r2, #4009]	; 0xfa9
 490:	00d70301 	sbcseq	r0, r7, r1, lsl #6
 494:	024aba66 	subeq	fp, sl, #417792	; 0x66000
 498:	0101000a 	tsteq	r1, sl
 49c:	000003b1 			; <UNDEFINED> instruction: 0x000003b1
 4a0:	00970003 	addseq	r0, r7, r3
 4a4:	01020000 	mrseq	r0, (UNDEF: 2)
 4a8:	000d0efb 	strdeq	r0, [sp], -fp
 4ac:	01010101 	tsteq	r1, r1, lsl #2
 4b0:	01000000 	mrseq	r0, (UNDEF: 0)
 4b4:	2f010000 	svccs	0x00010000
 4b8:	2f746e6d 	svccs	0x00746e6d
 4bc:	73552f63 	cmpvc	r5, #396	; 0x18c
 4c0:	2f737265 	svccs	0x00737265
 4c4:	6162754b 	cmnvs	r2, fp, asr #10
 4c8:	776f442f 	strbvc	r4, [pc, -pc, lsr #8]!
 4cc:	616f6c6e 	cmnvs	pc, lr, ror #24
 4d0:	302f7364 	eorcc	r7, pc, r4, ror #6
 4d4:	656b2f33 	strbvs	r2, [fp, #-3891]!	; 0xfffff0cd
 4d8:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
 4dc:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
 4e0:	6972642f 	ldmdbvs	r2!, {r0, r1, r2, r3, r5, sl, sp, lr}^
 4e4:	73726576 	cmnvc	r2, #494927872	; 0x1d800000
 4e8:	6e6d2f00 	cdpvs	15, 6, cr2, cr13, cr0, {0}
 4ec:	2f632f74 	svccs	0x00632f74
 4f0:	72657355 	rsbvc	r7, r5, #1409286145	; 0x54000001
 4f4:	754b2f73 	strbvc	r2, [fp, #-3955]	; 0xfffff08d
 4f8:	442f6162 	strtmi	r6, [pc], #-354	; 500 <shift+0x500>
 4fc:	6c6e776f 	stclvs	7, cr7, [lr], #-444	; 0xfffffe44
 500:	7364616f 	cmnvc	r4, #-1073741797	; 0xc000001b
 504:	2f33302f 	svccs	0x0033302f
 508:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 50c:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 510:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 514:	642f6564 	strtvs	r6, [pc], #-1380	; 51c <shift+0x51c>
 518:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
 51c:	00007372 	andeq	r7, r0, r2, ror r3
 520:	696e6f6d 	stmdbvs	lr!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
 524:	2e726f74 	mrccs	15, 3, r6, cr2, cr4, {3}
 528:	00707063 	rsbseq	r7, r0, r3, rrx
 52c:	6d000001 	stcvs	0, cr0, [r0, #-4]
 530:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
 534:	682e726f 	stmdavs	lr!, {r0, r1, r2, r3, r5, r6, r9, ip, sp, lr}
 538:	00000200 	andeq	r0, r0, r0, lsl #4
 53c:	00010500 	andeq	r0, r1, r0, lsl #10
 540:	87b80205 	ldrhi	r0, [r8, r5, lsl #4]!
 544:	05160000 	ldreq	r0, [r6, #-0]
 548:	2605d70e 	strcs	sp, [r5], -lr, lsl #14
 54c:	02010532 	andeq	r0, r1, #209715200	; 0xc800000
 550:	09031422 	stmdbeq	r3, {r1, r5, sl, ip}
 554:	8311059e 	tsthi	r1, #662700032	; 0x27800000
 558:	054c1705 	strbeq	r1, [ip, #-1797]	; 0xfffff8fb
 55c:	04020022 	streq	r0, [r2], #-34	; 0xffffffde
 560:	20054a01 	andcs	r4, r5, r1, lsl #20
 564:	01040200 	mrseq	r0, R12_usr
 568:	681b054a 	ldmdavs	fp, {r1, r3, r6, r8, sl}
 56c:	02002605 	andeq	r2, r0, #5242880	; 0x500000
 570:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
 574:	04020024 	streq	r0, [r2], #-36	; 0xffffffdc
 578:	0d054a03 	vstreq	s8, [r5, #-12]
 57c:	02040200 	andeq	r0, r4, #0, 4
 580:	001c0568 	andseq	r0, ip, r8, ror #10
 584:	4a020402 	bmi	81594 <_bss_end+0x77e80>
 588:	02001a05 	andeq	r1, r0, #20480	; 0x5000
 58c:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 590:	04020025 	streq	r0, [r2], #-37	; 0xffffffdb
 594:	28054a02 	stmdacs	r5, {r1, r9, fp, lr}
 598:	02040200 	andeq	r0, r4, #0, 4
 59c:	002a054a 	eoreq	r0, sl, sl, asr #10
 5a0:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
 5a4:	02000905 	andeq	r0, r0, #81920	; 0x14000
 5a8:	05480204 	strbeq	r0, [r8, #-516]	; 0xfffffdfc
 5ac:	04020005 	streq	r0, [r2], #-5
 5b0:	01058002 	tsteq	r5, r2
 5b4:	66120389 	ldrvs	r0, [r2], -r9, lsl #7
 5b8:	05831705 	streq	r1, [r3, #1797]	; 0x705
 5bc:	04020022 	streq	r0, [r2], #-34	; 0xffffffde
 5c0:	20054a01 	andcs	r4, r5, r1, lsl #20
 5c4:	01040200 	mrseq	r0, R12_usr
 5c8:	681b054a 	ldmdavs	fp, {r1, r3, r6, r8, sl}
 5cc:	02002605 	andeq	r2, r0, #5242880	; 0x500000
 5d0:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
 5d4:	04020024 	streq	r0, [r2], #-36	; 0xffffffdc
 5d8:	32054a03 	andcc	r4, r5, #12288	; 0x3000
 5dc:	02040200 	andeq	r0, r4, #0, 4
 5e0:	00410568 	subeq	r0, r1, r8, ror #10
 5e4:	4a020402 	bmi	815f4 <_bss_end+0x77ee0>
 5e8:	02003f05 	andeq	r3, r0, #5, 30
 5ec:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 5f0:	0402004a 	streq	r0, [r2], #-74	; 0xffffffb6
 5f4:	4d054a02 	vstrmi	s8, [r5, #-8]
 5f8:	02040200 	andeq	r0, r4, #0, 4
 5fc:	000d054a 	andeq	r0, sp, sl, asr #10
 600:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
 604:	02001b05 	andeq	r1, r0, #5120	; 0x1400
 608:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 60c:	04020022 	streq	r0, [r2], #-34	; 0xffffffde
 610:	20054a02 	andcs	r4, r5, r2, lsl #20
 614:	02040200 	andeq	r0, r4, #0, 4
 618:	002b054a 	eoreq	r0, fp, sl, asr #10
 61c:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
 620:	02002e05 	andeq	r2, r0, #5, 28	; 0x50
 624:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 628:	0402004d 	streq	r0, [r2], #-77	; 0xffffffb3
 62c:	30052e02 	andcc	r2, r5, r2, lsl #28
 630:	02040200 	andeq	r0, r4, #0, 4
 634:	0009054a 	andeq	r0, r9, sl, asr #10
 638:	2c020402 	cfstrscs	mvf0, [r2], {2}
 63c:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
 640:	05800204 	streq	r0, [r0, #516]	; 0x204
 644:	22058a17 	andcs	r8, r5, #94208	; 0x17000
 648:	03040200 	movweq	r0, #16896	; 0x4200
 64c:	0020054a 	eoreq	r0, r0, sl, asr #10
 650:	4a030402 	bmi	c1660 <_bss_end+0xb7f4c>
 654:	02000905 	andeq	r0, r0, #81920	; 0x14000
 658:	05680204 	strbeq	r0, [r8, #-516]!	; 0xfffffdfc
 65c:	04020015 	streq	r0, [r2], #-21	; 0xffffffeb
 660:	1e054a02 	vmlane.f32	s8, s10, s4
 664:	02040200 	andeq	r0, r4, #0, 4
 668:	0025054a 	eoreq	r0, r5, sl, asr #10
 66c:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
 670:	02002305 	andeq	r2, r0, #335544320	; 0x14000000
 674:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 678:	0402002e 	streq	r0, [r2], #-46	; 0xffffffd2
 67c:	31052e02 	tstcc	r5, r2, lsl #28
 680:	02040200 	andeq	r0, r4, #0, 4
 684:	0033054a 	eorseq	r0, r3, sl, asr #10
 688:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
 68c:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
 690:	05480204 	strbeq	r0, [r8, #-516]	; 0xfffffdfc
 694:	058a8601 	streq	r8, [sl, #1537]	; 0x601
 698:	0905bb05 	stmdbeq	r5, {r0, r2, r8, r9, fp, ip, sp, pc}
 69c:	4a1d0568 	bmi	741c44 <_bss_end+0x738530>
 6a0:	054a2105 	strbeq	r2, [sl, #-261]	; 0xfffffefb
 6a4:	35054a1f 	strcc	r4, [r5, #-2591]	; 0xfffff5e1
 6a8:	4a2a052e 	bmi	a81b68 <_bss_end+0xa78454>
 6ac:	052e3605 	streq	r3, [lr, #-1541]!	; 0xfffff9fb
 6b0:	14052e38 	strne	r2, [r5], #-3640	; 0xfffff1c8
 6b4:	4a09054b 	bmi	241be8 <_bss_end+0x2384d4>
 6b8:	67861405 	strvs	r1, [r6, r5, lsl #8]
 6bc:	054a0905 	strbeq	r0, [sl, #-2309]	; 0xfffff6fb
 6c0:	0d056912 	vstreq.16	s12, [r5, #-36]	; 0xffffffdc	; <UNPREDICTABLE>
 6c4:	2f01054c 	svccs	0x0001054c
 6c8:	9f170569 	svcls	0x00170569
 6cc:	02002305 	andeq	r2, r0, #335544320	; 0x14000000
 6d0:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
 6d4:	04020025 	streq	r0, [r2], #-37	; 0xffffffdb
 6d8:	17058203 	strne	r8, [r5, -r3, lsl #4]
 6dc:	02040200 	andeq	r0, r4, #0, 4
 6e0:	0005054c 	andeq	r0, r5, ip, asr #10
 6e4:	d4020402 	strle	r0, [r2], #-1026	; 0xfffffbfe
 6e8:	05871605 	streq	r1, [r7, #1541]	; 0x605
 6ec:	01054c0d 	tsteq	r5, sp, lsl #24
 6f0:	1305692f 	movwne	r6, #22831	; 0x592f
 6f4:	680d059f 	stmdavs	sp, {r0, r1, r2, r3, r4, r7, r8, sl}
 6f8:	852f0105 	strhi	r0, [pc, #-261]!	; 5fb <shift+0x5fb>
 6fc:	05a33305 	streq	r3, [r3, #773]!	; 0x305
 700:	0e054a09 	vmlaeq.f32	s8, s10, s18
 704:	67160583 	ldrvs	r0, [r6, -r3, lsl #11]
 708:	054c0d05 	strbeq	r0, [ip, #-3333]	; 0xfffff2fb
 70c:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 710:	1205bb05 	andne	fp, r5, #5120	; 0x1400
 714:	16058668 	strne	r8, [r5], -r8, ror #12
 718:	4c0d0569 	cfstr32mi	mvfx0, [sp], {105}	; 0x69
 71c:	a12f0105 			; <UNDEFINED> instruction: 0xa12f0105
 720:	05d70905 	ldrbeq	r0, [r7, #2309]	; 0x905
 724:	27054c12 	smladcs	r5, r2, ip, r4
 728:	ba2d0568 	blt	b41cd0 <_bss_end+0xb385bc>
 72c:	054a1005 	strbeq	r1, [sl, #-5]
 730:	2d052e11 	stccs	14, cr2, [r5, #-68]	; 0xffffffbc
 734:	2e13054a 	cfmac32cs	mvfx0, mvfx3, mvfx10
 738:	052f0f05 	streq	r0, [pc, #-3845]!	; fffff83b <_bss_end+0xffff6127>
 73c:	0505a00a 	streq	sl, [r5, #-10]
 740:	10053661 	andne	r3, r5, r1, ror #12
 744:	2e110568 	cfmsc32cs	mvfx0, mvfx1, mvfx8
 748:	054a2205 	strbeq	r2, [sl, #-517]	; 0xfffffdfb
 74c:	0a052e13 	beq	14bfa0 <_bss_end+0x14288c>
 750:	690c052f 	stmdbvs	ip, {r0, r1, r2, r3, r5, r8, sl}
 754:	052e0d05 	streq	r0, [lr, #-3333]!	; 0xfffff2fb
 758:	06054a0f 	streq	r4, [r5], -pc, lsl #20
 75c:	680e054b 	stmdavs	lr, {r0, r1, r3, r6, r8, sl}
 760:	02001d05 	andeq	r1, r0, #320	; 0x140
 764:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
 768:	04020017 	streq	r0, [r2], #-23	; 0xffffffe9
 76c:	1b059e03 	blne	167f80 <_bss_end+0x15e86c>
 770:	02040200 	andeq	r0, r4, #0, 4
 774:	001e0568 	andseq	r0, lr, r8, ror #10
 778:	82020402 	andhi	r0, r2, #33554432	; 0x2000000
 77c:	02000e05 	andeq	r0, r0, #5, 28	; 0x50
 780:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 784:	04020020 	streq	r0, [r2], #-32	; 0xffffffe0
 788:	21054b02 	tstcs	r5, r2, lsl #22
 78c:	02040200 	andeq	r0, r4, #0, 4
 790:	0012052e 	andseq	r0, r2, lr, lsr #10
 794:	4a020402 	bmi	817a4 <_bss_end+0x78090>
 798:	02001505 	andeq	r1, r0, #20971520	; 0x1400000
 79c:	05820204 	streq	r0, [r2, #516]	; 0x204
 7a0:	04020021 	streq	r0, [r2], #-33	; 0xffffffdf
 7a4:	17054a02 	strne	r4, [r5, -r2, lsl #20]
 7a8:	02040200 	andeq	r0, r4, #0, 4
 7ac:	0010052e 	andseq	r0, r0, lr, lsr #10
 7b0:	2f020402 	svccs	0x00020402
 7b4:	02001105 	andeq	r1, r0, #1073741825	; 0x40000001
 7b8:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
 7bc:	04020013 	streq	r0, [r2], #-19	; 0xffffffed
 7c0:	05054a02 	streq	r4, [r5, #-2562]	; 0xfffff5fe
 7c4:	02040200 	andeq	r0, r4, #0, 4
 7c8:	88010546 	stmdahi	r1, {r1, r2, r6, r8, sl}
 7cc:	02009e82 	andeq	r9, r0, #2080	; 0x820
 7d0:	66060104 	strvs	r0, [r6], -r4, lsl #2
 7d4:	03062705 	movweq	r2, #26373	; 0x6705
 7d8:	05827ee1 	streq	r7, [r2, #3809]	; 0xee1
 7dc:	019f0301 	orrseq	r0, pc, r1, lsl #6
 7e0:	024a9e9e 	subeq	r9, sl, #2528	; 0x9e0
 7e4:	0101000a 	tsteq	r1, sl
 7e8:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
 7ec:	008e0002 	addeq	r0, lr, r2
 7f0:	010e0300 	mrseq	r0, ELR_hyp
 7f4:	67831005 	strvs	r1, [r3, r5]
 7f8:	02670105 	rsbeq	r0, r7, #1073741825	; 0x40000001
 7fc:	01010008 	tsteq	r1, r8
 800:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
 804:	008e3802 	addeq	r3, lr, r2, lsl #16
 808:	01210300 			; <UNDEFINED> instruction: 0x01210300
 80c:	05831205 	streq	r1, [r3, #517]	; 0x205
 810:	05054a17 	streq	r4, [r5, #-2583]	; 0xfffff5e9
 814:	4c14054a 	cfldr32mi	mvfx0, [r4], {74}	; 0x4a
 818:	4a090567 	bmi	241dbc <_bss_end+0x2386a8>
 81c:	05691205 	strbeq	r1, [r9, #-517]!	; 0xfffffdfb
 820:	05054a17 	streq	r4, [r5, #-2583]	; 0xfffff5e9
 824:	4c0f054a 	cfstr32mi	mvfx0, [pc], {74}	; 0x4a
 828:	054b1605 	strbeq	r1, [fp, #-1541]	; 0xfffff9fb
 82c:	14054a1f 	strne	r4, [r5], #-2591	; 0xfffff5e1
 830:	4c01052e 	cfstr32mi	mvfx0, [r1], {46}	; 0x2e
 834:	01000602 	tsteq	r0, r2, lsl #12
 838:	00010501 	andeq	r0, r1, r1, lsl #10
 83c:	8ec00205 	cdphi	2, 12, cr0, cr0, cr5, {0}
 840:	c0030000 	andgt	r0, r3, r0
 844:	13050100 	movwne	r0, #20736	; 0x5100
 848:	67010583 	strvs	r0, [r1, -r3, lsl #11]
 84c:	01000802 	tsteq	r0, r2, lsl #16
 850:	0001d601 	andeq	sp, r1, r1, lsl #12
 854:	f8000300 			; <UNDEFINED> instruction: 0xf8000300
 858:	02000000 	andeq	r0, r0, #0
 85c:	0d0efb01 	vstreq	d15, [lr, #-4]
 860:	01010100 	mrseq	r0, (UNDEF: 17)
 864:	00000001 	andeq	r0, r0, r1
 868:	01000001 	tsteq	r0, r1
 86c:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
 870:	552f632f 	strpl	r6, [pc, #-815]!	; 549 <shift+0x549>
 874:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 878:	62754b2f 	rsbsvs	r4, r5, #48128	; 0xbc00
 87c:	6f442f61 	svcvs	0x00442f61
 880:	6f6c6e77 	svcvs	0x006c6e77
 884:	2f736461 	svccs	0x00736461
 888:	6b2f3330 	blvs	bcd550 <_bss_end+0xbc3e3c>
 88c:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 890:	72732f6c 	rsbsvc	r2, r3, #108, 30	; 0x1b0
 894:	72642f63 	rsbvc	r2, r4, #396	; 0x18c
 898:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
 89c:	6d2f0073 	stcvs	0, cr0, [pc, #-460]!	; 6d8 <shift+0x6d8>
 8a0:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
 8a4:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
 8a8:	4b2f7372 	blmi	bdd678 <_bss_end+0xbd3f64>
 8ac:	2f616275 	svccs	0x00616275
 8b0:	6e776f44 	cdpvs	15, 7, cr6, cr7, cr4, {2}
 8b4:	64616f6c 	strbtvs	r6, [r1], #-3948	; 0xfffff094
 8b8:	33302f73 	teqcc	r0, #460	; 0x1cc
 8bc:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 8c0:	2f6c656e 	svccs	0x006c656e
 8c4:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 8c8:	2f656475 	svccs	0x00656475
 8cc:	72616f62 	rsbvc	r6, r1, #392	; 0x188
 8d0:	70722f64 	rsbsvc	r2, r2, r4, ror #30
 8d4:	682f3069 	stmdavs	pc!, {r0, r3, r5, r6, ip, sp}	; <UNPREDICTABLE>
 8d8:	2f006c61 	svccs	0x00006c61
 8dc:	2f746e6d 	svccs	0x00746e6d
 8e0:	73552f63 	cmpvc	r5, #396	; 0x18c
 8e4:	2f737265 	svccs	0x00737265
 8e8:	6162754b 	cmnvs	r2, fp, asr #10
 8ec:	776f442f 	strbvc	r4, [pc, -pc, lsr #8]!
 8f0:	616f6c6e 	cmnvs	pc, lr, ror #24
 8f4:	302f7364 	eorcc	r7, pc, r4, ror #6
 8f8:	656b2f33 	strbvs	r2, [fp, #-3891]!	; 0xfffff0cd
 8fc:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
 900:	636e692f 	cmnvs	lr, #770048	; 0xbc000
 904:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
 908:	6972642f 	ldmdbvs	r2!, {r0, r1, r2, r3, r5, sl, sp, lr}^
 90c:	73726576 	cmnvc	r2, #494927872	; 0x1d800000
 910:	61750000 	cmnvs	r5, r0
 914:	632e7472 			; <UNDEFINED> instruction: 0x632e7472
 918:	01007070 	tsteq	r0, r0, ror r0
 91c:	65700000 	ldrbvs	r0, [r0, #-0]!
 920:	68706972 	ldmdavs	r0!, {r1, r4, r5, r6, r8, fp, sp, lr}^
 924:	6c617265 	sfmvs	f7, 2, [r1], #-404	; 0xfffffe6c
 928:	00682e73 	rsbeq	r2, r8, r3, ror lr
 92c:	62000002 	andvs	r0, r0, #2
 930:	615f6d63 	cmpvs	pc, r3, ror #26
 934:	682e7875 	stmdavs	lr!, {r0, r2, r4, r5, r6, fp, ip, sp, lr}
 938:	00000300 	andeq	r0, r0, r0, lsl #6
 93c:	74726175 	ldrbtvc	r6, [r2], #-373	; 0xfffffe8b
 940:	0300682e 	movweq	r6, #2094	; 0x82e
 944:	6e690000 	cdpvs	0, 6, cr0, cr9, cr0, {0}
 948:	66656474 			; <UNDEFINED> instruction: 0x66656474
 94c:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 950:	05000000 	streq	r0, [r0, #-0]
 954:	02050001 	andeq	r0, r5, #1
 958:	00008eec 	andeq	r8, r0, ip, ror #29
 95c:	9f0f0518 	svcls	0x000f0518
 960:	05680505 	strbeq	r0, [r8, #-1285]!	; 0xfffffafb
 964:	05054a10 	streq	r4, [r5, #-2576]	; 0xfffff5f0
 968:	4a160568 	bmi	581f10 <_bss_end+0x5787fc>
 96c:	05830505 	streq	r0, [r3, #1285]	; 0x505
 970:	05054a16 	streq	r4, [r5, #-2582]	; 0xfffff5ea
 974:	4a160583 	bmi	581f88 <_bss_end+0x578874>
 978:	05830505 	streq	r0, [r3, #1285]	; 0x505
 97c:	01054a16 	tsteq	r5, r6, lsl sl
 980:	05058583 	streq	r8, [r5, #-1411]	; 0xfffffa7d
 984:	4a2e059f 	bmi	b82008 <_bss_end+0xb788f4>
 988:	054a3f05 	strbeq	r3, [sl, #-3845]	; 0xfffff0fb
 98c:	66058256 			; <UNDEFINED> instruction: 0x66058256
 990:	2e16052e 	cfmul64cs	mvdx0, mvdx6, mvdx14
 994:	699f0105 	ldmibvs	pc, {r0, r2, r8}	; <UNPREDICTABLE>
 998:	059f1c05 	ldreq	r1, [pc, #3077]	; 15a5 <shift+0x15a5>
 99c:	53054b2d 	movwpl	r4, #23341	; 0x5b2d
 9a0:	8218052e 	andshi	r0, r8, #192937984	; 0xb800000
 9a4:	054c0505 	strbeq	r0, [ip, #-1285]	; 0xfffffafb
 9a8:	05054a16 	streq	r4, [r5, #-2582]	; 0xfffff5ea
 9ac:	4a160584 	bmi	581fc4 <_bss_end+0x5788b0>
 9b0:	05840505 	streq	r0, [r4, #1285]	; 0x505
 9b4:	01054a16 	tsteq	r5, r6, lsl sl
 9b8:	1b05a183 	blne	168fcc <_bss_end+0x15f8b8>
 9bc:	4a2c05bb 	bmi	b020b0 <_bss_end+0xaf899c>
 9c0:	05824d05 	streq	r4, [r2, #3333]	; 0xd05
 9c4:	12054d0c 	andne	r4, r5, #12, 26	; 0x300
 9c8:	4a230568 	bmi	8c1f70 <_bss_end+0x8b885c>
 9cc:	05820f05 	streq	r0, [r2, #3845]	; 0xf05
 9d0:	05344805 	ldreq	r4, [r4, #-2053]!	; 0xfffff7fb
 9d4:	01054a16 	tsteq	r5, r6, lsl sl
 9d8:	0c056983 			; <UNDEFINED> instruction: 0x0c056983
 9dc:	001505a1 	andseq	r0, r5, r1, lsr #11
 9e0:	4a030402 	bmi	c19f0 <_bss_end+0xb82dc>
 9e4:	02001605 	andeq	r1, r0, #5242880	; 0x500000
 9e8:	052e0304 	streq	r0, [lr, #-772]!	; 0xfffffcfc
 9ec:	04020018 	streq	r0, [r2], #-24	; 0xffffffe8
 9f0:	13056603 	movwne	r6, #22019	; 0x5603
 9f4:	02040200 	andeq	r0, r4, #0, 4
 9f8:	0014054b 	andseq	r0, r4, fp, asr #10
 9fc:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
 a00:	02000e05 	andeq	r0, r0, #5, 28	; 0x50
 a04:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 a08:	04020005 	streq	r0, [r2], #-5
 a0c:	01058102 	tsteq	r5, r2, lsl #2
 a10:	009e6684 	addseq	r6, lr, r4, lsl #13
 a14:	06010402 	streq	r0, [r1], -r2, lsl #8
 a18:	06120566 	ldreq	r0, [r2], -r6, ror #10
 a1c:	05824e03 	streq	r4, [r2, #3587]	; 0xe03
 a20:	66320301 	ldrtvs	r0, [r2], -r1, lsl #6
 a24:	0a024aba 	beq	93514 <_bss_end+0x89e00>
 a28:	32010100 	andcc	r0, r1, #0, 2
 a2c:	03000001 	movweq	r0, #1
 a30:	00010700 	andeq	r0, r1, r0, lsl #14
 a34:	fb010200 	blx	4123e <_bss_end+0x37b2a>
 a38:	01000d0e 	tsteq	r0, lr, lsl #26
 a3c:	00010101 	andeq	r0, r1, r1, lsl #2
 a40:	00010000 	andeq	r0, r1, r0
 a44:	6d2f0100 	stfvss	f0, [pc, #-0]	; a4c <shift+0xa4c>
 a48:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
 a4c:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
 a50:	4b2f7372 	blmi	bdd820 <_bss_end+0xbd410c>
 a54:	2f616275 	svccs	0x00616275
 a58:	6e776f44 	cdpvs	15, 7, cr6, cr7, cr4, {2}
 a5c:	64616f6c 	strbtvs	r6, [r1], #-3948	; 0xfffff094
 a60:	33302f73 	teqcc	r0, #460	; 0x1cc
 a64:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 a68:	2f6c656e 	svccs	0x006c656e
 a6c:	00637273 	rsbeq	r7, r3, r3, ror r2
 a70:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
 a74:	552f632f 	strpl	r6, [pc, #-815]!	; 74d <shift+0x74d>
 a78:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 a7c:	62754b2f 	rsbsvs	r4, r5, #48128	; 0xbc00
 a80:	6f442f61 	svcvs	0x00442f61
 a84:	6f6c6e77 	svcvs	0x006c6e77
 a88:	2f736461 	svccs	0x00736461
 a8c:	6b2f3330 	blvs	bcd754 <_bss_end+0xbc4040>
 a90:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 a94:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
 a98:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 a9c:	6f622f65 	svcvs	0x00622f65
 aa0:	2f647261 	svccs	0x00647261
 aa4:	30697072 	rsbcc	r7, r9, r2, ror r0
 aa8:	6c61682f 	stclvs	8, cr6, [r1], #-188	; 0xffffff44
 aac:	6e6d2f00 	cdpvs	15, 6, cr2, cr13, cr0, {0}
 ab0:	2f632f74 	svccs	0x00632f74
 ab4:	72657355 	rsbvc	r7, r5, #1409286145	; 0x54000001
 ab8:	754b2f73 	strbvc	r2, [fp, #-3955]	; 0xfffff08d
 abc:	442f6162 	strtmi	r6, [pc], #-354	; ac4 <shift+0xac4>
 ac0:	6c6e776f 	stclvs	7, cr7, [lr], #-444	; 0xfffffe44
 ac4:	7364616f 	cmnvc	r4, #-1073741797	; 0xc000001b
 ac8:	2f33302f 	svccs	0x0033302f
 acc:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 ad0:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 ad4:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 ad8:	642f6564 	strtvs	r6, [pc], #-1380	; ae0 <shift+0xae0>
 adc:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
 ae0:	00007372 	andeq	r7, r0, r2, ror r3
 ae4:	6e69616d 	powvsez	f6, f1, #5.0
 ae8:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
 aec:	00000100 	andeq	r0, r0, r0, lsl #2
 af0:	64746e69 	ldrbtvs	r6, [r4], #-3689	; 0xfffff197
 af4:	682e6665 	stmdavs	lr!, {r0, r2, r5, r6, r9, sl, sp, lr}
 af8:	00000200 	andeq	r0, r0, r0, lsl #4
 afc:	6f697067 	svcvs	0x00697067
 b00:	0300682e 	movweq	r6, #2094	; 0x82e
 b04:	65700000 	ldrbvs	r0, [r0, #-0]!
 b08:	68706972 	ldmdavs	r0!, {r1, r4, r5, r6, r8, fp, sp, lr}^
 b0c:	6c617265 	sfmvs	f7, 2, [r1], #-404	; 0xfffffe6c
 b10:	00682e73 	rsbeq	r2, r8, r3, ror lr
 b14:	62000002 	andvs	r0, r0, #2
 b18:	615f6d63 	cmpvs	pc, r3, ror #26
 b1c:	682e7875 	stmdavs	lr!, {r0, r2, r4, r5, r6, fp, ip, sp, lr}
 b20:	00000300 	andeq	r0, r0, r0, lsl #6
 b24:	74726175 	ldrbtvc	r6, [r2], #-373	; 0xfffffe8b
 b28:	0300682e 	movweq	r6, #2094	; 0x82e
 b2c:	6f6d0000 	svcvs	0x006d0000
 b30:	6f74696e 	svcvs	0x0074696e
 b34:	00682e72 	rsbeq	r2, r8, r2, ror lr
 b38:	00000003 	andeq	r0, r0, r3
 b3c:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
 b40:	0091e802 	addseq	lr, r1, r2, lsl #16
 b44:	10051a00 	andne	r1, r5, r0, lsl #20
 b48:	4d190567 	cfldr32mi	mvfx0, [r9, #-412]	; 0xfffffe64
 b4c:	05851605 	streq	r1, [r5, #1541]	; 0x605
 b50:	0e056718 	mcreq	7, 0, r6, cr5, cr8, {0}
 b54:	00050569 	andeq	r0, r5, r9, ror #10
 b58:	6a010402 	bvs	41b68 <_bss_end+0x38454>
 b5c:	01000c02 	tsteq	r0, r2, lsl #24
 b60:	00006001 	andeq	r6, r0, r1
 b64:	48000300 	stmdami	r0, {r8, r9}
 b68:	02000000 	andeq	r0, r0, #0
 b6c:	0d0efb01 	vstreq	d15, [lr, #-4]
 b70:	01010100 	mrseq	r0, (UNDEF: 17)
 b74:	00000001 	andeq	r0, r0, r1
 b78:	01000001 	tsteq	r0, r1
 b7c:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
 b80:	552f632f 	strpl	r6, [pc, #-815]!	; 859 <shift+0x859>
 b84:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 b88:	62754b2f 	rsbsvs	r4, r5, #48128	; 0xbc00
 b8c:	6f442f61 	svcvs	0x00442f61
 b90:	6f6c6e77 	svcvs	0x006c6e77
 b94:	2f736461 	svccs	0x00736461
 b98:	6b2f3330 	blvs	bcd860 <_bss_end+0xbc414c>
 b9c:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 ba0:	72732f6c 	rsbsvc	r2, r3, #108, 30	; 0x1b0
 ba4:	73000063 	movwvc	r0, #99	; 0x63
 ba8:	74726174 	ldrbtvc	r6, [r2], #-372	; 0xfffffe8c
 bac:	0100732e 	tsteq	r0, lr, lsr #6
 bb0:	00000000 	andeq	r0, r0, r0
 bb4:	80000205 	andhi	r0, r0, r5, lsl #4
 bb8:	2f190000 	svccs	0x00190000
 bbc:	302f2f2f 	eorcc	r2, pc, pc, lsr #30
 bc0:	01000202 	tsteq	r0, r2, lsl #4
 bc4:	0000cd01 	andeq	ip, r0, r1, lsl #26
 bc8:	4c000300 	stcmi	3, cr0, [r0], {-0}
 bcc:	02000000 	andeq	r0, r0, #0
 bd0:	0d0efb01 	vstreq	d15, [lr, #-4]
 bd4:	01010100 	mrseq	r0, (UNDEF: 17)
 bd8:	00000001 	andeq	r0, r0, r1
 bdc:	01000001 	tsteq	r0, r1
 be0:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
 be4:	552f632f 	strpl	r6, [pc, #-815]!	; 8bd <shift+0x8bd>
 be8:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 bec:	62754b2f 	rsbsvs	r4, r5, #48128	; 0xbc00
 bf0:	6f442f61 	svcvs	0x00442f61
 bf4:	6f6c6e77 	svcvs	0x006c6e77
 bf8:	2f736461 	svccs	0x00736461
 bfc:	6b2f3330 	blvs	bcd8c4 <_bss_end+0xbc41b0>
 c00:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 c04:	72732f6c 	rsbsvc	r2, r3, #108, 30	; 0x1b0
 c08:	73000063 	movwvc	r0, #99	; 0x63
 c0c:	74726174 	ldrbtvc	r6, [r2], #-372	; 0xfffffe8c
 c10:	632e7075 			; <UNDEFINED> instruction: 0x632e7075
 c14:	01007070 	tsteq	r0, r0, ror r0
 c18:	05000000 	streq	r0, [r0, #-0]
 c1c:	02050001 	andeq	r0, r5, #1
 c20:	00009248 	andeq	r9, r0, r8, asr #4
 c24:	05011403 	streq	r1, [r1, #-1027]	; 0xfffffbfd
 c28:	1f056a09 	svcne	0x00056a09
 c2c:	03040200 	movweq	r0, #16896	; 0x4200
 c30:	00060566 	andeq	r0, r6, r6, ror #10
 c34:	bb020402 	bllt	81c44 <_bss_end+0x78530>
 c38:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
 c3c:	05650204 	strbeq	r0, [r5, #-516]!	; 0xfffffdfc
 c40:	01058509 	tsteq	r5, r9, lsl #10
 c44:	0d05bd2f 	stceq	13, cr11, [r5, #-188]	; 0xffffff44
 c48:	0024056b 	eoreq	r0, r4, fp, ror #10
 c4c:	4a030402 	bmi	c1c5c <_bss_end+0xb8548>
 c50:	02000405 	andeq	r0, r0, #83886080	; 0x5000000
 c54:	05830204 	streq	r0, [r3, #516]	; 0x204
 c58:	0402000b 	streq	r0, [r2], #-11
 c5c:	02054a02 	andeq	r4, r5, #8192	; 0x2000
 c60:	02040200 	andeq	r0, r4, #0, 4
 c64:	8509052d 	strhi	r0, [r9, #-1325]	; 0xfffffad3
 c68:	a12f0105 			; <UNDEFINED> instruction: 0xa12f0105
 c6c:	056a0d05 	strbeq	r0, [sl, #-3333]!	; 0xfffff2fb
 c70:	04020024 	streq	r0, [r2], #-36	; 0xffffffdc
 c74:	04054a03 	streq	r4, [r5], #-2563	; 0xfffff5fd
 c78:	02040200 	andeq	r0, r4, #0, 4
 c7c:	000b0583 	andeq	r0, fp, r3, lsl #11
 c80:	4a020402 	bmi	81c90 <_bss_end+0x7857c>
 c84:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
 c88:	052d0204 	streq	r0, [sp, #-516]!	; 0xfffffdfc
 c8c:	01058509 	tsteq	r5, r9, lsl #10
 c90:	000a022f 	andeq	r0, sl, pc, lsr #4
 c94:	00790101 	rsbseq	r0, r9, r1, lsl #2
 c98:	00030000 	andeq	r0, r3, r0
 c9c:	00000046 	andeq	r0, r0, r6, asr #32
 ca0:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
 ca4:	0101000d 	tsteq	r1, sp
 ca8:	00000101 	andeq	r0, r0, r1, lsl #2
 cac:	00000100 	andeq	r0, r0, r0, lsl #2
 cb0:	2f2e2e01 	svccs	0x002e2e01
 cb4:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 cb8:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 cbc:	2f2e2e2f 	svccs	0x002e2e2f
 cc0:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; c10 <shift+0xc10>
 cc4:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
 cc8:	6f632f63 	svcvs	0x00632f63
 ccc:	6769666e 	strbvs	r6, [r9, -lr, ror #12]!
 cd0:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
 cd4:	696c0000 	stmdbvs	ip!, {}^	; <UNPREDICTABLE>
 cd8:	75663162 	strbvc	r3, [r6, #-354]!	; 0xfffffe9e
 cdc:	2e73636e 	cdpcs	3, 7, cr6, cr3, cr14, {3}
 ce0:	00010053 	andeq	r0, r1, r3, asr r0
 ce4:	05000000 	streq	r0, [r0, #-0]
 ce8:	00936002 	addseq	r6, r3, r2
 cec:	08cf0300 	stmiaeq	pc, {r8, r9}^	; <UNPREDICTABLE>
 cf0:	2f2f3001 	svccs	0x002f3001
 cf4:	302f2f2f 	eorcc	r2, pc, pc, lsr #30
 cf8:	1401d002 	strne	sp, [r1], #-2
 cfc:	2f2f312f 	svccs	0x002f312f
 d00:	322f4c30 	eorcc	r4, pc, #48, 24	; 0x3000
 d04:	2f661f03 	svccs	0x00661f03
 d08:	2f2f2f2f 	svccs	0x002f2f2f
 d0c:	02022f2f 	andeq	r2, r2, #47, 30	; 0xbc
 d10:	5c010100 	stfpls	f0, [r1], {-0}
 d14:	03000000 	movweq	r0, #0
 d18:	00004600 	andeq	r4, r0, r0, lsl #12
 d1c:	fb010200 	blx	41526 <_bss_end+0x37e12>
 d20:	01000d0e 	tsteq	r0, lr, lsl #26
 d24:	00010101 	andeq	r0, r1, r1, lsl #2
 d28:	00010000 	andeq	r0, r1, r0
 d2c:	2e2e0100 	sufcse	f0, f6, f0
 d30:	2f2e2e2f 	svccs	0x002e2e2f
 d34:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 d38:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 d3c:	2f2e2e2f 	svccs	0x002e2e2f
 d40:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
 d44:	632f6363 			; <UNDEFINED> instruction: 0x632f6363
 d48:	69666e6f 	stmdbvs	r6!, {r0, r1, r2, r3, r5, r6, r9, sl, fp, sp, lr}^
 d4c:	72612f67 	rsbvc	r2, r1, #412	; 0x19c
 d50:	6c00006d 	stcvs	0, cr0, [r0], {109}	; 0x6d
 d54:	66316269 	ldrtvs	r6, [r1], -r9, ror #4
 d58:	73636e75 	cmnvc	r3, #1872	; 0x750
 d5c:	0100532e 	tsteq	r0, lr, lsr #6
 d60:	00000000 	andeq	r0, r0, r0
 d64:	956c0205 	strbls	r0, [ip, #-517]!	; 0xfffffdfb
 d68:	b9030000 	stmdblt	r3, {}	; <UNPREDICTABLE>
 d6c:	0202010b 	andeq	r0, r2, #-1073741822	; 0xc0000002
 d70:	a4010100 	strge	r0, [r1], #-256	; 0xffffff00
 d74:	03000000 	movweq	r0, #0
 d78:	00009e00 	andeq	r9, r0, r0, lsl #28
 d7c:	fb010200 	blx	41586 <_bss_end+0x37e72>
 d80:	01000d0e 	tsteq	r0, lr, lsl #26
 d84:	00010101 	andeq	r0, r1, r1, lsl #2
 d88:	00010000 	andeq	r0, r1, r0
 d8c:	2e2e0100 	sufcse	f0, f6, f0
 d90:	2f2e2e2f 	svccs	0x002e2e2f
 d94:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 d98:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 d9c:	672f2e2f 	strvs	r2, [pc, -pc, lsr #28]!
 da0:	2e006363 	cdpcs	3, 0, cr6, cr0, cr3, {3}
 da4:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 da8:	2f2e2e2f 	svccs	0x002e2e2f
 dac:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 db0:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 db4:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
 db8:	2f636367 	svccs	0x00636367
 dbc:	672f2e2e 	strvs	r2, [pc, -lr, lsr #28]!
 dc0:	632f6363 			; <UNDEFINED> instruction: 0x632f6363
 dc4:	69666e6f 	stmdbvs	r6!, {r0, r1, r2, r3, r5, r6, r9, sl, fp, sp, lr}^
 dc8:	72612f67 	rsbvc	r2, r1, #412	; 0x19c
 dcc:	2e2e006d 	cdpcs	0, 2, cr0, cr14, cr13, {3}
 dd0:	2f2e2e2f 	svccs	0x002e2e2f
 dd4:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 dd8:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 ddc:	2f2e2e2f 	svccs	0x002e2e2f
 de0:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
 de4:	00006363 	andeq	r6, r0, r3, ror #6
 de8:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
 dec:	2e617369 	cdpcs	3, 6, cr7, cr1, cr9, {3}
 df0:	00010068 	andeq	r0, r1, r8, rrx
 df4:	6d726100 	ldfvse	f6, [r2, #-0]
 df8:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 dfc:	62670000 	rsbvs	r0, r7, #0
 e00:	74632d6c 	strbtvc	r2, [r3], #-3436	; 0xfffff294
 e04:	2e73726f 	cdpcs	2, 7, cr7, cr3, cr15, {3}
 e08:	00030068 	andeq	r0, r3, r8, rrx
 e0c:	62696c00 	rsbvs	r6, r9, #0, 24
 e10:	32636367 	rsbcc	r6, r3, #-1677721599	; 0x9c000001
 e14:	0300632e 	movweq	r6, #814	; 0x32e
 e18:	Address 0x0000000000000e18 is out of bounds.


Disassembly of section .debug_str:

00000000 <.debug_str>:
       0:	78635f5f 	stmdavc	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, sl, fp, ip, lr}^
       4:	75675f61 	strbvc	r5, [r7, #-3937]!	; 0xfffff09f
       8:	5f647261 	svcpl	0x00647261
       c:	656c6572 	strbvs	r6, [ip, #-1394]!	; 0xfffffa8e
      10:	00657361 	rsbeq	r7, r5, r1, ror #6
      14:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
      18:	552f632f 	strpl	r6, [pc, #-815]!	; fffffcf1 <_bss_end+0xffff65dd>
      1c:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
      20:	62754b2f 	rsbsvs	r4, r5, #48128	; 0xbc00
      24:	6f442f61 	svcvs	0x00442f61
      28:	6f6c6e77 	svcvs	0x006c6e77
      2c:	2f736461 	svccs	0x00736461
      30:	6b2f3330 	blvs	bcccf8 <_bss_end+0xbc35e4>
      34:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
      38:	72732f6c 	rsbsvc	r2, r3, #108, 30	; 0x1b0
      3c:	78632f63 	stmdavc	r3!, {r0, r1, r5, r6, r8, r9, sl, fp, sp}^
      40:	70632e78 	rsbvc	r2, r3, r8, ror lr
      44:	5f5f0070 	svcpl	0x005f0070
      48:	5f617863 	svcpl	0x00617863
      4c:	72617567 	rsbvc	r7, r1, #432013312	; 0x19c00000
      50:	62615f64 	rsbvs	r5, r1, #100, 30	; 0x190
      54:	0074726f 	rsbseq	r7, r4, pc, ror #4
      58:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
      5c:	552f632f 	strpl	r6, [pc, #-815]!	; fffffd35 <_bss_end+0xffff6621>
      60:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
      64:	62754b2f 	rsbsvs	r4, r5, #48128	; 0xbc00
      68:	6f442f61 	svcvs	0x00442f61
      6c:	6f6c6e77 	svcvs	0x006c6e77
      70:	2f736461 	svccs	0x00736461
      74:	622f3330 	eorvs	r3, pc, #48, 6	; 0xc0000000
      78:	646c6975 	strbtvs	r6, [ip], #-2421	; 0xfffff68b
      7c:	645f5f00 	ldrbvs	r5, [pc], #-3840	; 84 <shift+0x84>
      80:	685f6f73 	ldmdavs	pc, {r0, r1, r4, r5, r6, r8, r9, sl, fp, sp, lr}^	; <UNPREDICTABLE>
      84:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
      88:	5f5f0065 	svcpl	0x005f0065
      8c:	5f617863 	svcpl	0x00617863
      90:	78657461 	stmdavc	r5!, {r0, r5, r6, sl, ip, sp, lr}^
      94:	47007469 	strmi	r7, [r0, -r9, ror #8]
      98:	4320554e 			; <UNDEFINED> instruction: 0x4320554e
      9c:	34312b2b 	ldrtcc	r2, [r1], #-2859	; 0xfffff4d5
      a0:	2e303120 	rsfcssp	f3, f0, f0
      a4:	20312e33 	eorscs	r2, r1, r3, lsr lr
      a8:	31323032 	teqcc	r2, r2, lsr r0
      ac:	31323630 	teqcc	r2, r0, lsr r6
      b0:	65722820 	ldrbvs	r2, [r2, #-2080]!	; 0xfffff7e0
      b4:	7361656c 	cmnvc	r1, #108, 10	; 0x1b000000
      b8:	2d202965 			; <UNDEFINED> instruction: 0x2d202965
      bc:	6f6c666d 	svcvs	0x006c666d
      c0:	612d7461 			; <UNDEFINED> instruction: 0x612d7461
      c4:	683d6962 	ldmdavs	sp!, {r1, r5, r6, r8, fp, sp, lr}
      c8:	20647261 	rsbcs	r7, r4, r1, ror #4
      cc:	70666d2d 	rsbvc	r6, r6, sp, lsr #26
      d0:	66763d75 			; <UNDEFINED> instruction: 0x66763d75
      d4:	6d2d2070 	stcvs	0, cr2, [sp, #-448]!	; 0xfffffe40
      d8:	616f6c66 	cmnvs	pc, r6, ror #24
      dc:	62612d74 	rsbvs	r2, r1, #116, 26	; 0x1d00
      e0:	61683d69 	cmnvs	r8, r9, ror #26
      e4:	2d206472 	cfstrscs	mvf6, [r0, #-456]!	; 0xfffffe38
      e8:	7570666d 	ldrbvc	r6, [r0, #-1645]!	; 0xfffff993
      ec:	7066763d 	rsbvc	r7, r6, sp, lsr r6
      f0:	746d2d20 	strbtvc	r2, [sp], #-3360	; 0xfffff2e0
      f4:	3d656e75 	stclcc	14, cr6, [r5, #-468]!	; 0xfffffe2c
      f8:	316d7261 	cmncc	sp, r1, ror #4
      fc:	6a363731 	bvs	d8ddc8 <_bss_end+0xd846b4>
     100:	732d667a 			; <UNDEFINED> instruction: 0x732d667a
     104:	616d2d20 	cmnvs	sp, r0, lsr #26
     108:	2d206d72 	stccs	13, cr6, [r0, #-456]!	; 0xfffffe38
     10c:	6372616d 	cmnvs	r2, #1073741851	; 0x4000001b
     110:	72613d68 	rsbvc	r3, r1, #104, 26	; 0x1a00
     114:	7a36766d 	bvc	d9dad0 <_bss_end+0xd943bc>
     118:	70662b6b 	rsbvc	r2, r6, fp, ror #22
     11c:	20672d20 	rsbcs	r2, r7, r0, lsr #26
     120:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
     124:	2d20304f 	stccs	0, cr3, [r0, #-316]!	; 0xfffffec4
     128:	5f00304f 	svcpl	0x0000304f
     12c:	6178635f 	cmnvs	r8, pc, asr r3
     130:	6175675f 	cmnvs	r5, pc, asr r7
     134:	615f6472 	cmpvs	pc, r2, ror r4	; <UNPREDICTABLE>
     138:	69757163 	ldmdbvs	r5!, {r0, r1, r5, r6, r8, ip, sp, lr}^
     13c:	5f006572 	svcpl	0x00006572
     140:	7878635f 	ldmdavc	r8!, {r0, r1, r2, r3, r4, r6, r8, r9, sp, lr}^
     144:	76696261 	strbtvc	r6, [r9], -r1, ror #4
     148:	5f5f0031 	svcpl	0x005f0031
     14c:	5f617863 	svcpl	0x00617863
     150:	65727570 	ldrbvs	r7, [r2, #-1392]!	; 0xfffffa90
     154:	7269765f 	rsbvc	r7, r9, #99614720	; 0x5f00000
     158:	6c617574 	cfstr64vs	mvdx7, [r1], #-464	; 0xfffffe30
     15c:	615f5f00 	cmpvs	pc, r0, lsl #30
     160:	69626165 	stmdbvs	r2!, {r0, r2, r5, r6, r8, sp, lr}^
     164:	776e755f 			; <UNDEFINED> instruction: 0x776e755f
     168:	5f646e69 	svcpl	0x00646e69
     16c:	5f707063 	svcpl	0x00707063
     170:	00317270 	eorseq	r7, r1, r0, ror r2
     174:	75675f5f 	strbvc	r5, [r7, #-3935]!	; 0xfffff0a1
     178:	00647261 	rsbeq	r7, r4, r1, ror #4
     17c:	676e6f6c 	strbvs	r6, [lr, -ip, ror #30]!
     180:	6e6f6c20 	cdpvs	12, 6, cr6, cr15, cr0, {1}
     184:	6e692067 	cdpvs	0, 6, cr2, cr9, cr7, {3}
     188:	68730074 	ldmdavs	r3!, {r2, r4, r5, r6}^
     18c:	2074726f 	rsbscs	r7, r4, pc, ror #4
     190:	00746e69 	rsbseq	r6, r4, r9, ror #28
     194:	31495053 	qdaddcc	r5, r3, r9
     198:	4545505f 	strbmi	r5, [r5, #-95]	; 0xffffffa1
     19c:	5053004b 	subspl	r0, r3, fp, asr #32
     1a0:	535f3149 	cmppl	pc, #1073741842	; 0x40000012
     1a4:	00544154 	subseq	r4, r4, r4, asr r1
     1a8:	5855416d 	ldmdapl	r5, {r0, r2, r3, r5, r6, r8, lr}^
     1ac:	6765525f 			; <UNDEFINED> instruction: 0x6765525f
     1b0:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     1b4:	55414334 	strbpl	r4, [r1, #-820]	; 0xfffffccc
     1b8:	47323158 			; <UNDEFINED> instruction: 0x47323158
     1bc:	525f7465 	subspl	r7, pc, #1694498816	; 0x65000000
     1c0:	73696765 	cmnvc	r9, #26476544	; 0x1940000
     1c4:	45726574 	ldrbmi	r6, [r2, #-1396]!	; 0xfffffa8c
     1c8:	6168334e 	cmnvs	r8, lr, asr #6
     1cc:	5541376c 	strbpl	r3, [r1, #-1900]	; 0xfffff894
     1d0:	65525f58 	ldrbvs	r5, [r2, #-3928]	; 0xfffff0a8
     1d4:	76004567 	strvc	r4, [r0], -r7, ror #10
     1d8:	65756c61 	ldrbvs	r6, [r5, #-3169]!	; 0xfffff39f
     1dc:	78756100 	ldmdavc	r5!, {r8, sp, lr}^
     1e0:	7361625f 	cmnvc	r1, #-268435451	; 0xf0000005
     1e4:	4e450065 	cdpmi	0, 4, cr0, cr5, cr5, {3}
     1e8:	454c4241 	strbmi	r4, [ip, #-577]	; 0xfffffdbf
     1ec:	5a5f0053 	bpl	17c0340 <_bss_end+0x17b6c2c>
     1f0:	4143344e 	cmpmi	r3, lr, asr #8
     1f4:	45365855 	ldrmi	r5, [r6, #-2133]!	; 0xfffff7ab
     1f8:	6c62616e 	stfvse	f6, [r2], #-440	; 0xfffffe48
     1fc:	334e4565 	movtcc	r4, #58725	; 0xe565
     200:	316c6168 	cmncc	ip, r8, ror #2
     204:	58554135 	ldmdapl	r5, {r0, r2, r4, r5, r8, lr}^
     208:	7265505f 	rsbvc	r5, r5, #95	; 0x5f
     20c:	65687069 	strbvs	r7, [r8, #-105]!	; 0xffffff97
     210:	736c6172 	cmnvc	ip, #-2147483620	; 0x8000001c
     214:	55410045 	strbpl	r0, [r1, #-69]	; 0xffffffbb
     218:	65505f58 	ldrbvs	r5, [r0, #-3928]	; 0xfffff0a8
     21c:	68706972 	ldmdavs	r0!, {r1, r4, r5, r6, r8, fp, sp, lr}^
     220:	6c617265 	sfmvs	f7, 2, [r1], #-404	; 0xfffffe6c
     224:	5a5f0073 	bpl	17c03f8 <_bss_end+0x17b6ce4>
     228:	4143344e 	cmpmi	r3, lr, asr #8
     22c:	34435855 	strbcc	r5, [r3], #-2133	; 0xfffff7ab
     230:	5f006a45 	svcpl	0x00006a45
     234:	43344e5a 	teqmi	r4, #1440	; 0x5a0
     238:	31585541 	cmpcc	r8, r1, asr #10
     23c:	74655332 	strbtvc	r5, [r5], #-818	; 0xfffffcce
     240:	6765525f 			; <UNDEFINED> instruction: 0x6765525f
     244:	65747369 	ldrbvs	r7, [r4, #-873]!	; 0xfffffc97
     248:	334e4572 	movtcc	r4, #58738	; 0xe572
     24c:	376c6168 	strbcc	r6, [ip, -r8, ror #2]!
     250:	5f585541 	svcpl	0x00585541
     254:	45676552 	strbmi	r6, [r7, #-1362]!	; 0xfffffaae
     258:	5053006a 	subspl	r0, r3, sl, rrx
     25c:	495f3049 	ldmdbmi	pc, {r0, r3, r6, ip, sp}^	; <UNPREDICTABLE>
     260:	475f004f 	ldrbmi	r0, [pc, -pc, asr #32]
     264:	41424f4c 	cmpmi	r2, ip, asr #30
     268:	735f5f4c 	cmpvc	pc, #76, 30	; 0x130
     26c:	495f6275 	ldmdbmi	pc, {r0, r2, r4, r5, r6, r9, sp, lr}^	; <UNPREDICTABLE>
     270:	5541735f 	strbpl	r7, [r1, #-863]	; 0xfffffca1
     274:	50530058 	subspl	r0, r3, r8, asr r0
     278:	435f3049 	cmpmi	pc, #73	; 0x49
     27c:	304c544e 	subcc	r5, ip, lr, asr #8
     280:	49505300 	ldmdbmi	r0, {r8, r9, ip, lr}^
     284:	4e435f30 	mcrmi	15, 2, r5, cr3, cr0, {1}
     288:	00314c54 	eorseq	r4, r1, r4, asr ip
     28c:	69726550 	ldmdbvs	r2!, {r4, r6, r8, sl, sp, lr}^
     290:	72656870 	rsbvc	r6, r5, #112, 16	; 0x700000
     294:	425f6c61 	subsmi	r6, pc, #24832	; 0x6100
     298:	00657361 	rsbeq	r7, r5, r1, ror #6
     29c:	6e695f5f 	mcrvs	15, 3, r5, cr9, cr15, {2}
     2a0:	61697469 	cmnvs	r9, r9, ror #8
     2a4:	657a696c 	ldrbvs	r6, [sl, #-2412]!	; 0xfffff694
     2a8:	5300705f 	movwpl	r7, #95	; 0x5f
     2ac:	5f314950 	svcpl	0x00314950
     2b0:	4c544e43 	mrrcmi	14, 4, r4, r4, cr3	; <UNPREDICTABLE>
     2b4:	50530030 	subspl	r0, r3, r0, lsr r0
     2b8:	435f3149 	cmpmi	pc, #1073741842	; 0x40000012
     2bc:	314c544e 	cmpcc	ip, lr, asr #8
     2c0:	616e4500 	cmnvs	lr, r0, lsl #10
     2c4:	00656c62 	rsbeq	r6, r5, r2, ror #24
     2c8:	69736e75 	ldmdbvs	r3!, {r0, r2, r4, r5, r6, r9, sl, fp, sp, lr}^
     2cc:	64656e67 	strbtvs	r6, [r5], #-3687	; 0xfffff199
     2d0:	61686320 	cmnvs	r8, r0, lsr #6
     2d4:	6d2f0072 	stcvs	0, cr0, [pc, #-456]!	; 114 <shift+0x114>
     2d8:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
     2dc:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
     2e0:	4b2f7372 	blmi	bdd0b0 <_bss_end+0xbd399c>
     2e4:	2f616275 	svccs	0x00616275
     2e8:	6e776f44 	cdpvs	15, 7, cr6, cr7, cr4, {2}
     2ec:	64616f6c 	strbtvs	r6, [r1], #-3948	; 0xfffff094
     2f0:	33302f73 	teqcc	r0, #460	; 0x1cc
     2f4:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
     2f8:	2f6c656e 	svccs	0x006c656e
     2fc:	2f637273 	svccs	0x00637273
     300:	76697264 	strbtvc	r7, [r9], -r4, ror #4
     304:	2f737265 	svccs	0x00737265
     308:	5f6d6362 	svcpl	0x006d6362
     30c:	2e787561 	cdpcs	5, 7, cr7, cr8, cr1, {3}
     310:	00707063 	rsbseq	r7, r0, r3, rrx
     314:	495f554d 	ldmdbmi	pc, {r0, r2, r3, r6, r8, sl, ip, lr}^	; <UNPREDICTABLE>
     318:	4d005245 	sfmmi	f5, 4, [r0, #-276]	; 0xfffffeec
     31c:	434d5f55 	movtmi	r5, #57173	; 0xdf55
     320:	50470052 	subpl	r0, r7, r2, asr r0
     324:	425f4f49 	subsmi	r4, pc, #292	; 0x124
     328:	00657361 	rsbeq	r7, r5, r1, ror #6
     32c:	344e5a5f 	strbcc	r5, [lr], #-2655	; 0xfffff5a1
     330:	58554143 	ldmdapl	r5, {r0, r1, r6, r8, lr}^
     334:	6a453243 	bvs	114cc48 <_bss_end+0x1143534>
     338:	6e697500 	cdpvs	5, 6, cr7, cr9, cr0, {0}
     33c:	5f323374 	svcpl	0x00323374
     340:	69440074 	stmdbvs	r4, {r2, r4, r5, r6}^
     344:	6c626173 	stfvse	f6, [r2], #-460	; 0xfffffe34
     348:	65470065 	strbvs	r0, [r7, #-101]	; 0xffffff9b
     34c:	65525f74 	ldrbvs	r5, [r2, #-3956]	; 0xfffff08c
     350:	74736967 	ldrbtvc	r6, [r3], #-2407	; 0xfffff699
     354:	4d007265 	sfmmi	f7, 4, [r0, #-404]	; 0xfffffe6c
     358:	49495f55 	stmdbmi	r9, {r0, r2, r4, r6, r8, r9, sl, fp, ip, lr}^
     35c:	554d0052 	strbpl	r0, [sp, #-82]	; 0xffffffae
     360:	544e435f 	strbpl	r4, [lr], #-863	; 0xfffffca1
     364:	5053004c 	subspl	r0, r3, ip, asr #32
     368:	73003149 	movwvc	r3, #329	; 0x149
     36c:	74726f68 	ldrbtvc	r6, [r2], #-3944	; 0xfffff098
     370:	736e7520 	cmnvc	lr, #32, 10	; 0x8000000
     374:	656e6769 	strbvs	r6, [lr, #-1897]!	; 0xfffff897
     378:	6e692064 	cdpvs	0, 6, cr2, cr9, cr4, {3}
     37c:	50530074 	subspl	r0, r3, r4, ror r0
     380:	495f3149 	ldmdbmi	pc, {r0, r3, r6, r8, ip, sp}^	; <UNPREDICTABLE>
     384:	554d004f 	strbpl	r0, [sp, #-79]	; 0xffffffb1
     388:	52434c5f 	subpl	r4, r3, #24320	; 0x5f00
     38c:	49505300 	ldmdbmi	r0, {r8, r9, ip, lr}^
     390:	45505f30 	ldrbmi	r5, [r0, #-3888]	; 0xfffff0d0
     394:	4d004b45 	vstrmi	d4, [r0, #-276]	; 0xfffffeec
     398:	41425f55 	cmpmi	r2, r5, asr pc
     39c:	53004455 	movwpl	r4, #1109	; 0x455
     3a0:	5f304950 	svcpl	0x00304950
     3a4:	54415453 	strbpl	r5, [r1], #-1107	; 0xfffffbad
     3a8:	49504700 	ldmdbmi	r0, {r8, r9, sl, lr}^
     3ac:	69505f4f 	ldmdbvs	r0, {r0, r1, r2, r3, r6, r8, r9, sl, fp, ip, lr}^
     3b0:	6f435f6e 	svcvs	0x00435f6e
     3b4:	00746e75 	rsbseq	r6, r4, r5, ror lr
     3b8:	74735f5f 	ldrbtvc	r5, [r3], #-3935	; 0xfffff0a1
     3bc:	63697461 	cmnvs	r9, #1627389952	; 0x61000000
     3c0:	696e695f 	stmdbvs	lr!, {r0, r1, r2, r3, r4, r6, r8, fp, sp, lr}^
     3c4:	6c616974 			; <UNDEFINED> instruction: 0x6c616974
     3c8:	74617a69 	strbtvc	r7, [r1], #-2665	; 0xfffff597
     3cc:	5f6e6f69 	svcpl	0x006e6f69
     3d0:	5f646e61 	svcpl	0x00646e61
     3d4:	74736564 	ldrbtvc	r6, [r3], #-1380	; 0xfffffa9c
     3d8:	74637572 	strbtvc	r7, [r3], #-1394	; 0xfffffa8e
     3dc:	5f6e6f69 	svcpl	0x006e6f69
     3e0:	5f5f0030 	svcpl	0x005f0030
     3e4:	6f697270 	svcvs	0x00697270
     3e8:	79746972 	ldmdbvc	r4!, {r1, r4, r5, r6, r8, fp, sp, lr}^
     3ec:	69687400 	stmdbvs	r8!, {sl, ip, sp, lr}^
     3f0:	65530073 	ldrbvs	r0, [r3, #-115]	; 0xffffff8d
     3f4:	65525f74 	ldrbvs	r5, [r2, #-3956]	; 0xfffff08c
     3f8:	74736967 	ldrbtvc	r6, [r3], #-2407	; 0xfffff699
     3fc:	4d007265 	sfmmi	f7, 4, [r0, #-404]	; 0xfffffe6c
     400:	534d5f55 	movtpl	r5, #57173	; 0xdf55
     404:	50530052 	subspl	r0, r3, r2, asr r0
     408:	41003249 	tstmi	r0, r9, asr #4
     40c:	425f5855 	subsmi	r5, pc, #5570560	; 0x550000
     410:	00657361 	rsbeq	r7, r5, r1, ror #6
     414:	535f554d 	cmppl	pc, #322961408	; 0x13400000
     418:	00544154 	subseq	r4, r4, r4, asr r1
     41c:	5f787561 	svcpl	0x00787561
     420:	69726570 	ldmdbvs	r2!, {r4, r5, r6, r8, sl, sp, lr}^
     424:	72656870 	rsbvc	r6, r5, #112, 16	; 0x700000
     428:	4d006c61 	stcmi	12, cr6, [r0, #-388]	; 0xfffffe7c
     42c:	4f495f55 	svcmi	0x00495f55
     430:	6e694d00 	cdpvs	13, 6, cr4, cr9, cr0, {0}
     434:	52415569 	subpl	r5, r1, #440401920	; 0x1a400000
     438:	554d0054 	strbpl	r0, [sp, #-84]	; 0xffffffac
     43c:	52534c5f 	subspl	r4, r3, #24320	; 0x5f00
     440:	67657200 	strbvs	r7, [r5, -r0, lsl #4]!
     444:	7864695f 	stmdavc	r4!, {r0, r1, r2, r3, r4, r6, r8, fp, sp, lr}^
     448:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     44c:	55414334 	strbpl	r4, [r1, #-820]	; 0xfffffccc
     450:	69443758 	stmdbvs	r4, {r3, r4, r6, r8, r9, sl, ip, sp}^
     454:	6c626173 	stfvse	f6, [r2], #-460	; 0xfffffe34
     458:	334e4565 	movtcc	r4, #58725	; 0xe565
     45c:	316c6168 	cmncc	ip, r8, ror #2
     460:	58554135 	ldmdapl	r5, {r0, r2, r4, r5, r8, lr}^
     464:	7265505f 	rsbvc	r5, r5, #95	; 0x5f
     468:	65687069 	strbvs	r7, [r8, #-105]!	; 0xffffff97
     46c:	736c6172 	cmnvc	ip, #-2147483620	; 0x8000001c
     470:	554d0045 	strbpl	r0, [sp, #-69]	; 0xffffffbb
     474:	5243535f 	subpl	r5, r3, #2080374785	; 0x7c000001
     478:	48435441 	stmdami	r3, {r0, r6, sl, ip, lr}^
     47c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     480:	4333314b 	teqmi	r3, #-1073741806	; 0xc0000012
     484:	4f495047 	svcmi	0x00495047
     488:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     48c:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     490:	65473831 	strbvs	r3, [r7, #-2097]	; 0xfffff7cf
     494:	50475f74 	subpl	r5, r7, r4, ror pc
     498:	5f56454c 	svcpl	0x0056454c
     49c:	61636f4c 	cmnvs	r3, ip, asr #30
     4a0:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     4a4:	6a526a45 	bvs	149adc0 <_bss_end+0x14916ac>
     4a8:	005f3053 	subseq	r3, pc, r3, asr r0	; <UNPREDICTABLE>
     4ac:	45535047 	ldrbmi	r5, [r3, #-71]	; 0xffffffb9
     4b0:	47003054 	smlsdmi	r0, r4, r0, r3
     4b4:	54455350 	strbpl	r5, [r5], #-848	; 0xfffffcb0
     4b8:	50470031 	subpl	r0, r7, r1, lsr r0
     4bc:	4c455346 	mcrrmi	3, 4, r5, r5, cr6
     4c0:	50470030 	subpl	r0, r7, r0, lsr r0
     4c4:	4c455346 	mcrrmi	3, 4, r5, r5, cr6
     4c8:	50470031 	subpl	r0, r7, r1, lsr r0
     4cc:	4c455346 	mcrrmi	3, 4, r5, r5, cr6
     4d0:	50470032 	subpl	r0, r7, r2, lsr r0
     4d4:	4c455346 	mcrrmi	3, 4, r5, r5, cr6
     4d8:	50470033 	subpl	r0, r7, r3, lsr r0
     4dc:	4c455346 	mcrrmi	3, 4, r5, r5, cr6
     4e0:	50470034 	subpl	r0, r7, r4, lsr r0
     4e4:	4c455346 	mcrrmi	3, 4, r5, r5, cr6
     4e8:	50470035 	subpl	r0, r7, r5, lsr r0
     4ec:	43445550 	movtmi	r5, #17744	; 0x4550
     4f0:	00304b4c 	eorseq	r4, r0, ip, asr #22
     4f4:	55505047 	ldrbpl	r5, [r0, #-71]	; 0xffffffb9
     4f8:	4b4c4344 	blmi	1311210 <_bss_end+0x1307afc>
     4fc:	50470031 	subpl	r0, r7, r1, lsr r0
     500:	304e4552 	subcc	r4, lr, r2, asr r5
     504:	52504700 	subspl	r4, r0, #0, 14
     508:	00314e45 	eorseq	r4, r1, r5, asr #28
     50c:	314e5a5f 	cmpcc	lr, pc, asr sl
     510:	50474333 	subpl	r4, r7, r3, lsr r3
     514:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     518:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     51c:	30317265 	eorscc	r7, r1, r5, ror #4
     520:	5f746553 	svcpl	0x00746553
     524:	7074754f 	rsbsvc	r7, r4, pc, asr #10
     528:	6a457475 	bvs	115d704 <_bss_end+0x1153ff0>
     52c:	5a5f0062 	bpl	17c06bc <_bss_end+0x17b6fa8>
     530:	33314b4e 	teqcc	r1, #79872	; 0x13800
     534:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     538:	61485f4f 	cmpvs	r8, pc, asr #30
     53c:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     540:	47393172 			; <UNDEFINED> instruction: 0x47393172
     544:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     548:	45534650 	ldrbmi	r4, [r3, #-1616]	; 0xfffff9b0
     54c:	6f4c5f4c 	svcvs	0x004c5f4c
     550:	69746163 	ldmdbvs	r4!, {r0, r1, r5, r6, r8, sp, lr}^
     554:	6a456e6f 	bvs	115bf18 <_bss_end+0x1152804>
     558:	30536a52 	subscc	r6, r3, r2, asr sl
     55c:	476d005f 			; <UNDEFINED> instruction: 0x476d005f
     560:	004f4950 	subeq	r4, pc, r0, asr r9	; <UNPREDICTABLE>
     564:	314e5a5f 	cmpcc	lr, pc, asr sl
     568:	50474333 	subpl	r4, r7, r3, lsr r3
     56c:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     570:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     574:	34437265 	strbcc	r7, [r3], #-613	; 0xfffffd9b
     578:	75006a45 	strvc	r6, [r0, #-2629]	; 0xfffff5bb
     57c:	38746e69 	ldmdacc	r4!, {r0, r3, r5, r6, r9, sl, fp, sp, lr}^
     580:	4700745f 	smlsdmi	r0, pc, r4, r7	; <UNPREDICTABLE>
     584:	53444550 	movtpl	r4, #17744	; 0x4550
     588:	50470030 	subpl	r0, r7, r0, lsr r0
     58c:	31534445 	cmpcc	r3, r5, asr #8
     590:	6f6f6200 	svcvs	0x006f6200
     594:	6e55006c 	cdpvs	0, 5, cr0, cr5, cr12, {3}
     598:	63657073 	cmnvs	r5, #115	; 0x73
     59c:	65696669 	strbvs	r6, [r9, #-1641]!	; 0xfffff997
     5a0:	50470064 	subpl	r0, r7, r4, rrx
     5a4:	304e454c 	subcc	r4, lr, ip, asr #10
     5a8:	6e756600 	cdpvs	6, 7, cr6, cr5, cr0, {0}
     5ac:	65470063 	strbvs	r0, [r7, #-99]	; 0xffffff9d
     5b0:	50475f74 	subpl	r5, r7, r4, ror pc
     5b4:	465f4f49 	ldrbmi	r4, [pc], -r9, asr #30
     5b8:	74636e75 	strbtvc	r6, [r3], #-3701	; 0xfffff18b
     5bc:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     5c0:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     5c4:	61485f4f 	cmpvs	r8, pc, asr #30
     5c8:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     5cc:	65470072 	strbvs	r0, [r7, #-114]	; 0xffffff8e
     5d0:	50475f74 	subpl	r5, r7, r4, ror pc
     5d4:	5f544553 	svcpl	0x00544553
     5d8:	61636f4c 	cmnvs	r3, ip, asr #30
     5dc:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     5e0:	50504700 	subspl	r4, r0, r0, lsl #14
     5e4:	47004455 	smlsdmi	r0, r5, r4, r4
     5e8:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     5ec:	56454c50 			; <UNDEFINED> instruction: 0x56454c50
     5f0:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     5f4:	6f697461 	svcvs	0x00697461
     5f8:	5a5f006e 	bpl	17c07b8 <_bss_end+0x17b70a4>
     5fc:	33314b4e 	teqcc	r1, #79872	; 0x13800
     600:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     604:	61485f4f 	cmpvs	r8, pc, asr #30
     608:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     60c:	47373172 			; <UNDEFINED> instruction: 0x47373172
     610:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     614:	5f4f4950 	svcpl	0x004f4950
     618:	636e7546 	cmnvs	lr, #293601280	; 0x11800000
     61c:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     620:	5f006a45 	svcpl	0x00006a45
     624:	33314e5a 	teqcc	r1, #1440	; 0x5a0
     628:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     62c:	61485f4f 	cmpvs	r8, pc, asr #30
     630:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     634:	45324372 	ldrmi	r4, [r2, #-882]!	; 0xfffffc8e
     638:	5047006a 	subpl	r0, r7, sl, rrx
     63c:	4e454641 	cdpmi	6, 4, cr4, cr5, cr1, {2}
     640:	50470030 	subpl	r0, r7, r0, lsr r0
     644:	4e454641 	cdpmi	6, 4, cr4, cr5, cr1, {2}
     648:	5a5f0031 	bpl	17c0714 <_bss_end+0x17b7000>
     64c:	33314b4e 	teqcc	r1, #79872	; 0x13800
     650:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     654:	61485f4f 	cmpvs	r8, pc, asr #30
     658:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     65c:	47383172 			; <UNDEFINED> instruction: 0x47383172
     660:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     664:	524c4350 	subpl	r4, ip, #80, 6	; 0x40000001
     668:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     66c:	6f697461 	svcvs	0x00697461
     670:	526a456e 	rsbpl	r4, sl, #461373440	; 0x1b800000
     674:	5f30536a 	svcpl	0x0030536a
     678:	4c475f00 	mcrrmi	15, 0, r5, r7, cr0
     67c:	4c41424f 	sfmmi	f4, 2, [r1], {79}	; 0x4f
     680:	75735f5f 	ldrbvc	r5, [r3, #-3935]!	; 0xfffff0a1
     684:	5f495f62 	svcpl	0x00495f62
     688:	49504773 	ldmdbmi	r0, {r0, r1, r4, r5, r6, r8, r9, sl, lr}^
     68c:	5047004f 	subpl	r0, r7, pc, asr #32
     690:	31524c43 	cmpcc	r2, r3, asr #24
     694:	41504700 	cmpmi	r0, r0, lsl #14
     698:	304e4552 	subcc	r4, lr, r2, asr r5
     69c:	41504700 	cmpmi	r0, r0, lsl #14
     6a0:	314e4552 	cmpcc	lr, r2, asr r5
     6a4:	6e6d2f00 	cdpvs	15, 6, cr2, cr13, cr0, {0}
     6a8:	2f632f74 	svccs	0x00632f74
     6ac:	72657355 	rsbvc	r7, r5, #1409286145	; 0x54000001
     6b0:	754b2f73 	strbvc	r2, [fp, #-3955]	; 0xfffff08d
     6b4:	442f6162 	strtmi	r6, [pc], #-354	; 6bc <shift+0x6bc>
     6b8:	6c6e776f 	stclvs	7, cr7, [lr], #-444	; 0xfffffe44
     6bc:	7364616f 	cmnvc	r4, #-1073741797	; 0xc000001b
     6c0:	2f33302f 	svccs	0x0033302f
     6c4:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
     6c8:	732f6c65 			; <UNDEFINED> instruction: 0x732f6c65
     6cc:	642f6372 	strtvs	r6, [pc], #-882	; 6d4 <shift+0x6d4>
     6d0:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
     6d4:	672f7372 			; <UNDEFINED> instruction: 0x672f7372
     6d8:	2e6f6970 			; <UNDEFINED> instruction: 0x2e6f6970
     6dc:	00707063 	rsbseq	r7, r0, r3, rrx
     6e0:	45485047 	strbmi	r5, [r8, #-71]	; 0xffffffb9
     6e4:	4700304e 	strmi	r3, [r0, -lr, asr #32]
     6e8:	4e454850 	mcrmi	8, 2, r4, cr5, cr0, {2}
     6ec:	70670031 	rsbvc	r0, r7, r1, lsr r0
     6f0:	625f6f69 	subsvs	r6, pc, #420	; 0x1a4
     6f4:	5f657361 	svcpl	0x00657361
     6f8:	72646461 	rsbvc	r6, r4, #1627389952	; 0x61000000
     6fc:	4c504700 	mrrcmi	7, 0, r4, r0, cr0
     700:	00314e45 	eorseq	r4, r1, r5, asr #28
     704:	5f746547 	svcpl	0x00746547
     708:	53465047 	movtpl	r5, #24647	; 0x6047
     70c:	4c5f4c45 	mrrcmi	12, 4, r4, pc, cr5	; <UNPREDICTABLE>
     710:	7461636f 	strbtvc	r6, [r1], #-879	; 0xfffffc91
     714:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     718:	4f495047 	svcmi	0x00495047
     71c:	6765525f 			; <UNDEFINED> instruction: 0x6765525f
     720:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     724:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     728:	5f4f4950 	svcpl	0x004f4950
     72c:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     730:	3172656c 	cmncc	r2, ip, ror #10
     734:	74655337 	strbtvc	r5, [r5], #-823	; 0xfffffcc9
     738:	4950475f 	ldmdbmi	r0, {r0, r1, r2, r3, r4, r6, r8, r9, sl, lr}^
     73c:	75465f4f 	strbvc	r5, [r6, #-3919]	; 0xfffff0b1
     740:	6974636e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, r9, sp, lr}^
     744:	6a456e6f 	bvs	115c108 <_bss_end+0x11529f4>
     748:	474e3431 	smlaldxmi	r3, lr, r1, r4
     74c:	5f4f4950 	svcpl	0x004f4950
     750:	636e7546 	cmnvs	lr, #293601280	; 0x11800000
     754:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     758:	4c504700 	mrrcmi	7, 0, r4, r0, cr0
     75c:	00305645 	eorseq	r5, r0, r5, asr #12
     760:	454c5047 	strbmi	r5, [ip, #-71]	; 0xffffffb9
     764:	53003156 	movwpl	r3, #342	; 0x156
     768:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     76c:	5f4f4950 	svcpl	0x004f4950
     770:	636e7546 	cmnvs	lr, #293601280	; 0x11800000
     774:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     778:	74696200 	strbtvc	r6, [r9], #-512	; 0xfffffe00
     77c:	7864695f 	stmdavc	r4!, {r0, r1, r2, r3, r4, r6, r8, fp, sp, lr}^
     780:	74655300 	strbtvc	r5, [r5], #-768	; 0xfffffd00
     784:	74754f5f 	ldrbtvc	r4, [r5], #-3935	; 0xfffff0a1
     788:	00747570 	rsbseq	r7, r4, r0, ror r5
     78c:	4b4e5a5f 	blmi	1397110 <_bss_end+0x138d9fc>
     790:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     794:	5f4f4950 	svcpl	0x004f4950
     798:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     79c:	3172656c 	cmncc	r2, ip, ror #10
     7a0:	74654738 	strbtvc	r4, [r5], #-1848	; 0xfffff8c8
     7a4:	5350475f 	cmppl	r0, #24903680	; 0x17c0000
     7a8:	4c5f5445 	cfldrdmi	mvd5, [pc], {69}	; 0x45
     7ac:	7461636f 	strbtvc	r6, [r1], #-879	; 0xfffffc91
     7b0:	456e6f69 	strbmi	r6, [lr, #-3945]!	; 0xfffff097
     7b4:	536a526a 	cmnpl	sl, #-1610612730	; 0xa0000006
     7b8:	47005f30 	smladxmi	r0, r0, pc, r5	; <UNPREDICTABLE>
     7bc:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     7c0:	524c4350 	subpl	r4, ip, #80, 6	; 0x40000001
     7c4:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     7c8:	6f697461 	svcvs	0x00697461
     7cc:	6e49006e 	cdpvs	0, 4, cr0, cr9, cr14, {3}
     7d0:	00747570 	rsbseq	r7, r4, r0, ror r5
     7d4:	45465047 	strbmi	r5, [r6, #-71]	; 0xffffffb9
     7d8:	4700304e 	strmi	r3, [r0, -lr, asr #32]
     7dc:	4e454650 	mcrmi	6, 2, r4, cr5, cr0, {2}
     7e0:	6c410031 	mcrrvs	0, 3, r0, r1, cr1
     7e4:	00305f74 	eorseq	r5, r0, r4, ror pc
     7e8:	5f746c41 	svcpl	0x00746c41
     7ec:	6c410031 	mcrrvs	0, 3, r0, r1, cr1
     7f0:	00325f74 	eorseq	r5, r2, r4, ror pc
     7f4:	5f746c41 	svcpl	0x00746c41
     7f8:	6c410033 	mcrrvs	0, 3, r0, r1, cr3
     7fc:	00345f74 	eorseq	r5, r4, r4, ror pc
     800:	5f746c41 	svcpl	0x00746c41
     804:	50470035 	subpl	r0, r7, r5, lsr r0
     808:	30524c43 	subscc	r4, r2, r3, asr #24
     80c:	72635300 	rsbvc	r5, r3, #0, 6
     810:	006c6c6f 	rsbeq	r6, ip, pc, ror #24
     814:	756e5f6d 	strbvc	r5, [lr, #-3949]!	; 0xfffff093
     818:	7265626d 	rsbvc	r6, r5, #-805306362	; 0xd0000006
     81c:	7361625f 	cmnvc	r1, #-268435451	; 0xf0000005
     820:	65520065 	ldrbvs	r0, [r2, #-101]	; 0xffffff9b
     824:	5f746573 	svcpl	0x00746573
     828:	626d754e 	rsbvs	r7, sp, #327155712	; 0x13800000
     82c:	425f7265 	subsmi	r7, pc, #1342177286	; 0x50000006
     830:	00657361 	rsbeq	r7, r5, r1, ror #6
     834:	61656c43 	cmnvs	r5, r3, asr #24
     838:	5a5f0072 	bpl	17c0a08 <_bss_end+0x17b72f4>
     83c:	4d43384e 	stclmi	8, cr3, [r3, #-312]	; 0xfffffec8
     840:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
     844:	3243726f 	subcc	r7, r3, #-268435450	; 0xf0000006
     848:	6a6a6a45 	bvs	1a9b164 <_bss_end+0x1a91a50>
     84c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     850:	6f4d4338 	svcvs	0x004d4338
     854:	6f74696e 	svcvs	0x0074696e
     858:	41333172 	teqmi	r3, r2, ror r1
     85c:	73756a64 	cmnvc	r5, #100, 20	; 0x64000
     860:	75435f74 	strbvc	r5, [r3, #-3956]	; 0xfffff08c
     864:	726f7372 	rsbvc	r7, pc, #-939524095	; 0xc8000001
     868:	69007645 	stmdbvs	r0, {r0, r2, r6, r9, sl, ip, sp, lr}
     86c:	00616f74 	rsbeq	r6, r1, r4, ror pc
     870:	65736552 	ldrbvs	r6, [r3, #-1362]!	; 0xfffffaae
     874:	75435f74 	strbvc	r5, [r3, #-3956]	; 0xfffff08c
     878:	726f7372 	rsbvc	r7, pc, #-939524095	; 0xc8000001
     87c:	6a644100 	bvs	1910c84 <_bss_end+0x1907570>
     880:	5f747375 	svcpl	0x00747375
     884:	73727543 	cmnvc	r2, #281018368	; 0x10c00000
     888:	4e00726f 	cdpmi	2, 0, cr7, cr0, cr15, {3}
     88c:	626d754e 	rsbvs	r7, sp, #327155712	; 0x13800000
     890:	425f7265 	subsmi	r7, pc, #1342177286	; 0x50000006
     894:	00657361 	rsbeq	r7, r5, r1, ror #6
     898:	736f5054 	cmnvc	pc, #84	; 0x54
     89c:	6f697469 	svcvs	0x00697469
     8a0:	5a5f006e 	bpl	17c0a60 <_bss_end+0x17b734c>
     8a4:	4d43384e 	stclmi	8, cr3, [r3, #-312]	; 0xfffffec8
     8a8:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
     8ac:	3731726f 	ldrcc	r7, [r1, -pc, ror #4]!
     8b0:	65736552 	ldrbvs	r6, [r3, #-1362]!	; 0xfffffaae
     8b4:	754e5f74 	strbvc	r5, [lr, #-3956]	; 0xfffff08c
     8b8:	7265626d 	rsbvc	r6, r5, #-805306362	; 0xd0000006
     8bc:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
     8c0:	00764565 	rsbseq	r4, r6, r5, ror #10
     8c4:	6f6d5f6d 	svcvs	0x006d5f6d
     8c8:	6f74696e 	svcvs	0x0074696e
     8cc:	475f0072 			; <UNDEFINED> instruction: 0x475f0072
     8d0:	41424f4c 	cmpmi	r2, ip, asr #30
     8d4:	735f5f4c 	cmpvc	pc, #76, 30	; 0x130
     8d8:	495f6275 	ldmdbmi	pc, {r0, r2, r4, r5, r6, r9, sp, lr}^	; <UNPREDICTABLE>
     8dc:	6f4d735f 	svcvs	0x004d735f
     8e0:	6f74696e 	svcvs	0x0074696e
     8e4:	6f6d0072 	svcvs	0x006d0072
     8e8:	6f74696e 	svcvs	0x0074696e
     8ec:	61625f72 	smcvs	9714	; 0x25f2
     8f0:	615f6573 	cmpvs	pc, r3, ror r5	; <UNPREDICTABLE>
     8f4:	00726464 	rsbseq	r6, r2, r4, ror #8
     8f8:	384e5a5f 	stmdacc	lr, {r0, r1, r2, r3, r4, r6, r9, fp, ip, lr}^
     8fc:	6e6f4d43 	cdpvs	13, 6, cr4, cr15, cr3, {2}
     900:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
     904:	656c4335 	strbvs	r4, [ip, #-821]!	; 0xfffffccb
     908:	76457261 	strbvc	r7, [r5], -r1, ror #4
     90c:	6f4d4300 	svcvs	0x004d4300
     910:	6f74696e 	svcvs	0x0074696e
     914:	706f0072 	rsbvc	r0, pc, r2, ror r0	; <UNPREDICTABLE>
     918:	74617265 	strbtvc	r7, [r1], #-613	; 0xfffffd9b
     91c:	3c3c726f 	lfmcc	f7, 4, [ip], #-444	; 0xfffffe44
     920:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     924:	6f4d4338 	svcvs	0x004d4338
     928:	6f74696e 	svcvs	0x0074696e
     92c:	45736c72 	ldrbmi	r6, [r3, #-3186]!	; 0xfffff38e
     930:	00634b50 	rsbeq	r4, r3, r0, asr fp
     934:	384e5a5f 	stmdacc	lr, {r0, r1, r2, r3, r4, r6, r9, fp, ip, lr}^
     938:	6e6f4d43 	cdpvs	13, 6, cr4, cr15, cr3, {2}
     93c:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
     940:	6f746934 	svcvs	0x00746934
     944:	506a4561 	rsbpl	r4, sl, r1, ror #10
     948:	6d006a63 	vstrvs	s12, [r0, #-396]	; 0xfffffe74
     94c:	6965685f 	stmdbvs	r5!, {r0, r1, r2, r3, r4, r6, fp, sp, lr}^
     950:	00746867 	rsbseq	r6, r4, r7, ror #16
     954:	75635f6d 	strbvc	r5, [r3, #-3949]!	; 0xfffff093
     958:	726f7372 	rsbvc	r7, pc, #-939524095	; 0xc8000001
     95c:	61684300 	cmnvs	r8, r0, lsl #6
     960:	6e6f4372 	mcrvs	3, 3, r4, cr15, cr2, {3}
     964:	72724176 	rsbsvc	r4, r2, #-2147483619	; 0x8000001d
     968:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     96c:	6f4d4338 	svcvs	0x004d4338
     970:	6f74696e 	svcvs	0x0074696e
     974:	45736c72 	ldrbmi	r6, [r3, #-3186]!	; 0xfffff38e
     978:	5a5f0062 	bpl	17c0b08 <_bss_end+0x17b73f4>
     97c:	4d43384e 	stclmi	8, cr3, [r3, #-312]	; 0xfffffec8
     980:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
     984:	736c726f 	cmnvc	ip, #-268435450	; 0xf0000006
     988:	6d006345 	stcvs	3, cr6, [r0, #-276]	; 0xfffffeec
     98c:	6469775f 	strbtvs	r7, [r9], #-1887	; 0xfffff8a1
     990:	5f006874 	svcpl	0x00006874
     994:	43384e5a 	teqmi	r8, #1440	; 0x5a0
     998:	696e6f4d 	stmdbvs	lr!, {r0, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     99c:	36726f74 	uhsub16cc	r6, r2, r4
     9a0:	6f726353 	svcvs	0x00726353
     9a4:	76456c6c 	strbvc	r6, [r5], -ip, ror #24
     9a8:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     9ac:	6f4d4338 	svcvs	0x004d4338
     9b0:	6f74696e 	svcvs	0x0074696e
     9b4:	45736c72 	ldrbmi	r6, [r3, #-3186]!	; 0xfffff38e
     9b8:	5a5f006a 	bpl	17c0b68 <_bss_end+0x17b7454>
     9bc:	4d43384e 	stclmi	8, cr3, [r3, #-312]	; 0xfffffec8
     9c0:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
     9c4:	3231726f 	eorscc	r7, r1, #-268435450	; 0xf0000006
     9c8:	65736552 	ldrbvs	r6, [r3, #-1362]!	; 0xfffffaae
     9cc:	75435f74 	strbvc	r5, [r3, #-3956]	; 0xfffff08c
     9d0:	726f7372 	rsbvc	r7, pc, #-939524095	; 0xc8000001
     9d4:	5f007645 	svcpl	0x00007645
     9d8:	43384e5a 	teqmi	r8, #1440	; 0x5a0
     9dc:	696e6f4d 	stmdbvs	lr!, {r0, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     9e0:	43726f74 	cmnmi	r2, #116, 30	; 0x1d0
     9e4:	6a6a4534 	bvs	1a91ebc <_bss_end+0x1a887a8>
     9e8:	4544006a 	strbmi	r0, [r4, #-106]	; 0xffffff96
     9ec:	4c554146 	ldfmie	f4, [r5], {70}	; 0x46
     9f0:	554e5f54 	strbpl	r5, [lr, #-3924]	; 0xfffff0ac
     9f4:	5245424d 	subpl	r4, r5, #-805306364	; 0xd0000004
     9f8:	5341425f 	movtpl	r4, #4703	; 0x125f
     9fc:	5a5f0045 	bpl	17c0b18 <_bss_end+0x17b7404>
     a00:	4d43384e 	stclmi	8, cr3, [r3, #-312]	; 0xfffffec8
     a04:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
     a08:	736c726f 	cmnvc	ip, #-268435450	; 0xf0000006
     a0c:	5f534e45 	svcpl	0x00534e45
     a10:	4e4e3231 	mcrmi	2, 2, r3, cr14, cr1, {1}
     a14:	65626d75 	strbvs	r6, [r2, #-3445]!	; 0xfffff28b
     a18:	61425f72 	hvcvs	9714	; 0x25f2
     a1c:	00456573 	subeq	r6, r5, r3, ror r5
     a20:	7074756f 	rsbsvc	r7, r4, pc, ror #10
     a24:	2f007475 	svccs	0x00007475
     a28:	2f746e6d 	svccs	0x00746e6d
     a2c:	73552f63 	cmpvc	r5, #396	; 0x18c
     a30:	2f737265 	svccs	0x00737265
     a34:	6162754b 	cmnvs	r2, fp, asr #10
     a38:	776f442f 	strbvc	r4, [pc, -pc, lsr #8]!
     a3c:	616f6c6e 	cmnvs	pc, lr, ror #24
     a40:	302f7364 	eorcc	r7, pc, r4, ror #6
     a44:	656b2f33 	strbvs	r2, [fp, #-3891]!	; 0xfffff0cd
     a48:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
     a4c:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
     a50:	6972642f 	ldmdbvs	r2!, {r0, r1, r2, r3, r5, sl, sp, lr}^
     a54:	73726576 	cmnvc	r2, #494927872	; 0x1d800000
     a58:	6e6f6d2f 	cdpvs	13, 6, cr6, cr15, cr15, {1}
     a5c:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
     a60:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
     a64:	706e6900 	rsbvc	r6, lr, r0, lsl #18
     a68:	73007475 	movwvc	r7, #1141	; 0x475
     a6c:	6675625f 			; <UNDEFINED> instruction: 0x6675625f
     a70:	00726566 	rsbseq	r6, r2, r6, ror #10
     a74:	46465542 	strbmi	r5, [r6], -r2, asr #10
     a78:	535f5245 	cmppl	pc, #1342177284	; 0x50000004
     a7c:	00455a49 	subeq	r5, r5, r9, asr #20
     a80:	315f5242 	cmpcc	pc, r2, asr #4
     a84:	30323531 	eorscc	r3, r2, r1, lsr r5
     a88:	52420030 	subpl	r0, r2, #48	; 0x30
     a8c:	3438335f 	ldrtcc	r3, [r8], #-863	; 0xfffffca1
     a90:	5f003030 	svcpl	0x00003030
     a94:	43354e5a 	teqmi	r5, #1440	; 0x5a0
     a98:	54524155 	ldrbpl	r4, [r2], #-341	; 0xfffffeab
     a9c:	52453243 	subpl	r3, r5, #805306372	; 0x30000004
     aa0:	55414334 	strbpl	r4, [r1, #-820]	; 0xfffffccc
     aa4:	52420058 	subpl	r0, r2, #88	; 0x58
     aa8:	3036395f 	eorscc	r3, r6, pc, asr r9
     aac:	55430030 	strbpl	r0, [r3, #-48]	; 0xffffffd0
     ab0:	00545241 	subseq	r5, r4, r1, asr #4
     ab4:	355f5242 	ldrbcc	r5, [pc, #-578]	; 87a <shift+0x87a>
     ab8:	30303637 	eorscc	r3, r0, r7, lsr r6
     abc:	6f6c4300 	svcvs	0x006c4300
     ac0:	525f6b63 	subspl	r6, pc, #101376	; 0x18c00
     ac4:	00657461 	rsbeq	r7, r5, r1, ror #8
     ac8:	74697257 	strbtvc	r7, [r9], #-599	; 0xfffffda9
     acc:	68430065 	stmdavs	r3, {r0, r2, r5, r6}^
     ad0:	375f7261 	ldrbcc	r7, [pc, -r1, ror #4]
     ad4:	61684300 	cmnvs	r8, r0, lsl #6
     ad8:	00385f72 	eorseq	r5, r8, r2, ror pc
     adc:	5855416d 	ldmdapl	r5, {r0, r2, r3, r5, r6, r8, lr}^
     ae0:	4c475f00 	mcrrmi	15, 0, r5, r7, cr0
     ae4:	4c41424f 	sfmmi	f4, 2, [r1], {79}	; 0x4f
     ae8:	75735f5f 	ldrbvc	r5, [r3, #-3935]!	; 0xfffff0a1
     aec:	5f495f62 	svcpl	0x00495f62
     af0:	52415573 	subpl	r5, r1, #482344960	; 0x1cc00000
     af4:	2f003054 	svccs	0x00003054
     af8:	2f746e6d 	svccs	0x00746e6d
     afc:	73552f63 	cmpvc	r5, #396	; 0x18c
     b00:	2f737265 	svccs	0x00737265
     b04:	6162754b 	cmnvs	r2, fp, asr #10
     b08:	776f442f 	strbvc	r4, [pc, -pc, lsr #8]!
     b0c:	616f6c6e 	cmnvs	pc, lr, ror #24
     b10:	302f7364 	eorcc	r7, pc, r4, ror #6
     b14:	656b2f33 	strbvs	r2, [fp, #-3891]!	; 0xfffff0cd
     b18:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
     b1c:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
     b20:	6972642f 	ldmdbvs	r2!, {r0, r1, r2, r3, r5, sl, sp, lr}^
     b24:	73726576 	cmnvc	r2, #494927872	; 0x1d800000
     b28:	7261752f 	rsbvc	r7, r1, #197132288	; 0xbc00000
     b2c:	70632e74 	rsbvc	r2, r3, r4, ror lr
     b30:	5a5f0070 	bpl	17c0cf8 <_bss_end+0x17b75e4>
     b34:	5543354e 	strbpl	r3, [r3, #-1358]	; 0xfffffab2
     b38:	35545241 	ldrbcc	r5, [r4, #-577]	; 0xfffffdbf
     b3c:	74697257 	strbtvc	r7, [r9], #-599	; 0xfffffda9
     b40:	4b504565 	blmi	14120dc <_bss_end+0x14089c8>
     b44:	52420063 	subpl	r0, r2, #99	; 0x63
     b48:	3032315f 	eorscc	r3, r2, pc, asr r1
     b4c:	5a5f0030 	bpl	17c0c14 <_bss_end+0x17b7500>
     b50:	5543354e 	strbpl	r3, [r3, #-1358]	; 0xfffffab2
     b54:	35545241 	ldrbcc	r5, [r4, #-577]	; 0xfffffdbf
     b58:	74697257 	strbtvc	r7, [r9], #-599	; 0xfffffda9
     b5c:	00634565 	rsbeq	r4, r3, r5, ror #10
     b60:	354e5a5f 	strbcc	r5, [lr, #-2655]	; 0xfffff5a1
     b64:	52415543 	subpl	r5, r1, #281018368	; 0x10c00000
     b68:	45344354 	ldrmi	r4, [r4, #-852]!	; 0xfffffcac
     b6c:	41433452 	cmpmi	r3, r2, asr r4
     b70:	5f005855 	svcpl	0x00005855
     b74:	43354e5a 	teqmi	r5, #1440	; 0x5a0
     b78:	54524155 	ldrbpl	r4, [r2], #-341	; 0xfffffeab
     b7c:	65533531 	ldrbvs	r3, [r3, #-1329]	; 0xfffffacf
     b80:	68435f74 	stmdavs	r3, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     b84:	4c5f7261 	lfmmi	f7, 2, [pc], {97}	; 0x61
     b88:	74676e65 	strbtvc	r6, [r7], #-3685	; 0xfffff19b
     b8c:	37314568 	ldrcc	r4, [r1, -r8, ror #10]!
     b90:	5241554e 	subpl	r5, r1, #327155712	; 0x13800000
     b94:	68435f54 	stmdavs	r3, {r2, r4, r6, r8, r9, sl, fp, ip, lr}^
     b98:	4c5f7261 	lfmmi	f7, 2, [pc], {97}	; 0x61
     b9c:	74676e65 	strbtvc	r6, [r7], #-3685	; 0xfffff19b
     ba0:	65530068 	ldrbvs	r0, [r3, #-104]	; 0xffffff98
     ba4:	68435f74 	stmdavs	r3, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     ba8:	4c5f7261 	lfmmi	f7, 2, [pc], {97}	; 0x61
     bac:	74676e65 	strbtvc	r6, [r7], #-3685	; 0xfffff19b
     bb0:	61720068 	cmnvs	r2, r8, rrx
     bb4:	42006574 	andmi	r6, r0, #116, 10	; 0x1d000000
     bb8:	39315f52 	ldmdbcc	r1!, {r1, r4, r6, r8, r9, sl, fp, ip, lr}
     bbc:	00303032 	eorseq	r3, r0, r2, lsr r0
     bc0:	345f5242 	ldrbcc	r5, [pc], #-578	; bc8 <shift+0xbc8>
     bc4:	00303038 	eorseq	r3, r0, r8, lsr r0
     bc8:	5f746553 	svcpl	0x00746553
     bcc:	64756142 	ldrbtvs	r6, [r5], #-322	; 0xfffffebe
     bd0:	7461525f 	strbtvc	r5, [r1], #-607	; 0xfffffda1
     bd4:	5a5f0065 	bpl	17c0d70 <_bss_end+0x17b765c>
     bd8:	5543354e 	strbpl	r3, [r3, #-1358]	; 0xfffffab2
     bdc:	31545241 	cmpcc	r4, r1, asr #4
     be0:	74655333 	strbtvc	r5, [r5], #-819	; 0xfffffccd
     be4:	7561425f 	strbvc	r4, [r1, #-607]!	; 0xfffffda1
     be8:	61525f64 	cmpvs	r2, r4, ror #30
     bec:	31456574 	hvccc	22100	; 0x5654
     bf0:	41554e35 	cmpmi	r5, r5, lsr lr
     bf4:	425f5452 	subsmi	r5, pc, #1375731712	; 0x52000000
     bf8:	5f647561 	svcpl	0x00647561
     bfc:	65746152 	ldrbvs	r6, [r4, #-338]!	; 0xfffffeae
     c00:	5f524200 	svcpl	0x00524200
     c04:	30303432 	eorscc	r3, r0, r2, lsr r4
     c08:	6e6d2f00 	cdpvs	15, 6, cr2, cr13, cr0, {0}
     c0c:	2f632f74 	svccs	0x00632f74
     c10:	72657355 	rsbvc	r7, r5, #1409286145	; 0x54000001
     c14:	754b2f73 	strbvc	r2, [fp, #-3955]	; 0xfffff08d
     c18:	442f6162 	strtmi	r6, [pc], #-354	; c20 <shift+0xc20>
     c1c:	6c6e776f 	stclvs	7, cr7, [lr], #-444	; 0xfffffe44
     c20:	7364616f 	cmnvc	r4, #-1073741797	; 0xc000001b
     c24:	2f33302f 	svccs	0x0033302f
     c28:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
     c2c:	732f6c65 			; <UNDEFINED> instruction: 0x732f6c65
     c30:	6d2f6372 	stcvs	3, cr6, [pc, #-456]!	; a70 <shift+0xa70>
     c34:	2e6e6961 	vnmulcs.f16	s13, s28, s3	; <UNPREDICTABLE>
     c38:	00707063 	rsbseq	r7, r0, r3, rrx
     c3c:	72656b5f 	rsbvc	r6, r5, #97280	; 0x17c00
     c40:	5f6c656e 	svcpl	0x006c656e
     c44:	6e69616d 	powvsez	f6, f1, #5.0
     c48:	54434100 	strbpl	r4, [r3], #-256	; 0xffffff00
     c4c:	6e69505f 	mcrvs	0, 3, r5, cr9, cr15, {2}
     c50:	6e6d2f00 	cdpvs	15, 6, cr2, cr13, cr0, {0}
     c54:	2f632f74 	svccs	0x00632f74
     c58:	72657355 	rsbvc	r7, r5, #1409286145	; 0x54000001
     c5c:	754b2f73 	strbvc	r2, [fp, #-3955]	; 0xfffff08d
     c60:	442f6162 	strtmi	r6, [pc], #-354	; c68 <shift+0xc68>
     c64:	6c6e776f 	stclvs	7, cr7, [lr], #-444	; 0xfffffe44
     c68:	7364616f 	cmnvc	r4, #-1073741797	; 0xc000001b
     c6c:	2f33302f 	svccs	0x0033302f
     c70:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
     c74:	732f6c65 			; <UNDEFINED> instruction: 0x732f6c65
     c78:	732f6372 			; <UNDEFINED> instruction: 0x732f6372
     c7c:	74726174 	ldrbtvc	r6, [r2], #-372	; 0xfffffe8c
     c80:	4700732e 	strmi	r7, [r0, -lr, lsr #6]
     c84:	4120554e 			; <UNDEFINED> instruction: 0x4120554e
     c88:	2e322053 	mrccs	0, 1, r2, cr2, cr3, {2}
     c8c:	5f003833 	svcpl	0x00003833
     c90:	5f737362 	svcpl	0x00737362
     c94:	72617473 	rsbvc	r7, r1, #1929379840	; 0x73000000
     c98:	6e660074 	mcrvs	0, 3, r0, cr6, cr4, {3}
     c9c:	00727470 	rsbseq	r7, r2, r0, ror r4
     ca0:	54435f5f 	strbpl	r5, [r3], #-3935	; 0xfffff0a1
     ca4:	455f524f 	ldrbmi	r5, [pc, #-591]	; a5d <shift+0xa5d>
     ca8:	5f5f444e 	svcpl	0x005f444e
     cac:	435f5f00 	cmpmi	pc, #0, 30
     cb0:	5f524f54 	svcpl	0x00524f54
     cb4:	5453494c 	ldrbpl	r4, [r3], #-2380	; 0xfffff6b4
     cb8:	5f005f5f 	svcpl	0x00005f5f
     cbc:	4f54445f 	svcmi	0x0054445f
     cc0:	4e455f52 	mcrmi	15, 2, r5, cr5, cr2, {2}
     cc4:	005f5f44 	subseq	r5, pc, r4, asr #30
     cc8:	7070635f 	rsbsvc	r6, r0, pc, asr r3
     ccc:	7568735f 	strbvc	r7, [r8, #-863]!	; 0xfffffca1
     cd0:	776f6474 			; <UNDEFINED> instruction: 0x776f6474
     cd4:	6d2f006e 	stcvs	0, cr0, [pc, #-440]!	; b24 <shift+0xb24>
     cd8:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
     cdc:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
     ce0:	4b2f7372 	blmi	bddab0 <_bss_end+0xbd439c>
     ce4:	2f616275 	svccs	0x00616275
     ce8:	6e776f44 	cdpvs	15, 7, cr6, cr7, cr4, {2}
     cec:	64616f6c 	strbtvs	r6, [r1], #-3948	; 0xfffff094
     cf0:	33302f73 	teqcc	r0, #460	; 0x1cc
     cf4:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
     cf8:	2f6c656e 	svccs	0x006c656e
     cfc:	2f637273 	svccs	0x00637273
     d00:	72617473 	rsbvc	r7, r1, #1929379840	; 0x73000000
     d04:	2e707574 	mrccs	5, 3, r7, cr0, cr4, {3}
     d08:	00707063 	rsbseq	r7, r0, r3, rrx
     d0c:	7373625f 	cmnvc	r3, #-268435451	; 0xf0000005
     d10:	646e655f 	strbtvs	r6, [lr], #-1375	; 0xfffffaa1
     d14:	445f5f00 	ldrbmi	r5, [pc], #-3840	; d1c <shift+0xd1c>
     d18:	5f524f54 	svcpl	0x00524f54
     d1c:	5453494c 	ldrbpl	r4, [r3], #-2380	; 0xfffff6b4
     d20:	63005f5f 	movwvs	r5, #3935	; 0xf5f
     d24:	5f726f74 	svcpl	0x00726f74
     d28:	00727470 	rsbseq	r7, r2, r0, ror r4
     d2c:	735f635f 	cmpvc	pc, #2080374785	; 0x7c000001
     d30:	74726174 	ldrbtvc	r6, [r2], #-372	; 0xfffffe8c
     d34:	5f007075 	svcpl	0x00007075
     d38:	5f707063 	svcpl	0x00707063
     d3c:	72617473 	rsbvc	r7, r1, #1929379840	; 0x73000000
     d40:	00707574 	rsbseq	r7, r0, r4, ror r5
     d44:	726f7464 	rsbvc	r7, pc, #100, 8	; 0x64000000
     d48:	7274705f 	rsbsvc	r7, r4, #95	; 0x5f
     d4c:	2f2e2e00 	svccs	0x002e2e00
     d50:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     d54:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     d58:	2f2e2e2f 	svccs	0x002e2e2f
     d5c:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; cac <shift+0xcac>
     d60:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
     d64:	6f632f63 	svcvs	0x00632f63
     d68:	6769666e 	strbvs	r6, [r9, -lr, ror #12]!
     d6c:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
     d70:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
     d74:	6e756631 	mrcvs	6, 3, r6, cr5, cr1, {1}
     d78:	532e7363 			; <UNDEFINED> instruction: 0x532e7363
     d7c:	75622f00 	strbvc	r2, [r2, #-3840]!	; 0xfffff100
     d80:	2f646c69 	svccs	0x00646c69
     d84:	2d636367 	stclcs	3, cr6, [r3, #-412]!	; 0xfffffe64
     d88:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
     d8c:	656e6f6e 	strbvs	r6, [lr, #-3950]!	; 0xfffff092
     d90:	6261652d 	rsbvs	r6, r1, #188743680	; 0xb400000
     d94:	59682d69 	stmdbpl	r8!, {r0, r3, r5, r6, r8, sl, fp, sp}^
     d98:	344b6766 	strbcc	r6, [fp], #-1894	; 0xfffff89a
     d9c:	6363672f 	cmnvs	r3, #12320768	; 0xbc0000
     da0:	6d72612d 	ldfvse	f6, [r2, #-180]!	; 0xffffff4c
     da4:	6e6f6e2d 	cdpvs	14, 6, cr6, cr15, cr13, {1}
     da8:	61652d65 	cmnvs	r5, r5, ror #26
     dac:	312d6962 			; <UNDEFINED> instruction: 0x312d6962
     db0:	2d332e30 	ldccs	14, cr2, [r3, #-192]!	; 0xffffff40
     db4:	31323032 	teqcc	r2, r2, lsr r0
     db8:	2f37302e 	svccs	0x0037302e
     dbc:	6c697562 	cfstr64vs	mvdx7, [r9], #-392	; 0xfffffe78
     dc0:	72612f64 	rsbvc	r2, r1, #100, 30	; 0x190
     dc4:	6f6e2d6d 	svcvs	0x006e2d6d
     dc8:	652d656e 	strvs	r6, [sp, #-1390]!	; 0xfffffa92
     dcc:	2f696261 	svccs	0x00696261
     dd0:	2f6d7261 	svccs	0x006d7261
     dd4:	65743576 	ldrbvs	r3, [r4, #-1398]!	; 0xfffffa8a
     dd8:	7261682f 	rsbvc	r6, r1, #3080192	; 0x2f0000
     ddc:	696c2f64 	stmdbvs	ip!, {r2, r5, r6, r8, r9, sl, fp, sp}^
     de0:	63636762 	cmnvs	r3, #25690112	; 0x1880000
     de4:	554e4700 	strbpl	r4, [lr, #-1792]	; 0xfffff900
     de8:	20534120 	subscs	r4, r3, r0, lsr #2
     dec:	37332e32 			; <UNDEFINED> instruction: 0x37332e32
     df0:	61736900 	cmnvs	r3, r0, lsl #18
     df4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
     df8:	6572705f 	ldrbvs	r7, [r2, #-95]!	; 0xffffffa1
     dfc:	73657264 	cmnvc	r5, #100, 4	; 0x40000006
     e00:	61736900 	cmnvs	r3, r0, lsl #18
     e04:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
     e08:	7066765f 	rsbvc	r7, r6, pc, asr r6
     e0c:	7361625f 	cmnvc	r1, #-268435451	; 0xf0000005
     e10:	6f630065 	svcvs	0x00630065
     e14:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
     e18:	6c662078 	stclvs	0, cr2, [r6], #-480	; 0xfffffe20
     e1c:	0074616f 	rsbseq	r6, r4, pc, ror #2
     e20:	5f617369 	svcpl	0x00617369
     e24:	69626f6e 	stmdbvs	r2!, {r1, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
     e28:	73690074 	cmnvc	r9, #116	; 0x74
     e2c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
     e30:	766d5f74 	uqsub16vc	r5, sp, r4
     e34:	6c665f65 	stclvs	15, cr5, [r6], #-404	; 0xfffffe6c
     e38:	0074616f 	rsbseq	r6, r4, pc, ror #2
     e3c:	5f617369 	svcpl	0x00617369
     e40:	5f746962 	svcpl	0x00746962
     e44:	36317066 	ldrtcc	r7, [r1], -r6, rrx
     e48:	61736900 	cmnvs	r3, r0, lsl #18
     e4c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
     e50:	6365735f 	cmnvs	r5, #2080374785	; 0x7c000001
     e54:	61736900 	cmnvs	r3, r0, lsl #18
     e58:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
     e5c:	6964615f 	stmdbvs	r4!, {r0, r1, r2, r3, r4, r6, r8, sp, lr}^
     e60:	73690076 	cmnvc	r9, #118	; 0x76
     e64:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
     e68:	75715f74 	ldrbvc	r5, [r1, #-3956]!	; 0xfffff08c
     e6c:	5f6b7269 	svcpl	0x006b7269
     e70:	765f6f6e 	ldrbvc	r6, [pc], -lr, ror #30
     e74:	74616c6f 	strbtvc	r6, [r1], #-3183	; 0xfffff391
     e78:	5f656c69 	svcpl	0x00656c69
     e7c:	69006563 	stmdbvs	r0, {r0, r1, r5, r6, r8, sl, sp, lr}
     e80:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
     e84:	6d5f7469 	cfldrdvs	mvd7, [pc, #-420]	; ce8 <shift+0xce8>
     e88:	73690070 	cmnvc	r9, #112	; 0x70
     e8c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
     e90:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
     e94:	7435766d 	ldrtvc	r7, [r5], #-1645	; 0xfffff993
     e98:	61736900 	cmnvs	r3, r0, lsl #18
     e9c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
     ea0:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
     ea4:	65743576 	ldrbvs	r3, [r4, #-1398]!	; 0xfffffa8a
     ea8:	61736900 	cmnvs	r3, r0, lsl #18
     eac:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
     eb0:	6f656e5f 	svcvs	0x00656e5f
     eb4:	7369006e 	cmnvc	r9, #110	; 0x6e
     eb8:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
     ebc:	66625f74 	uqsub16vs	r5, r2, r4
     ec0:	46003631 			; <UNDEFINED> instruction: 0x46003631
     ec4:	52435350 	subpl	r5, r3, #80, 6	; 0x40000001
     ec8:	554e455f 	strbpl	r4, [lr, #-1375]	; 0xfffffaa1
     ecc:	5046004d 	subpl	r0, r6, sp, asr #32
     ed0:	5f524353 	svcpl	0x00524353
     ed4:	76637a6e 	strbtvc	r7, [r3], -lr, ror #20
     ed8:	455f6371 	ldrbmi	r6, [pc, #-881]	; b6f <shift+0xb6f>
     edc:	004d554e 	subeq	r5, sp, lr, asr #10
     ee0:	5f525056 	svcpl	0x00525056
     ee4:	4d554e45 	ldclmi	14, cr4, [r5, #-276]	; 0xfffffeec
     ee8:	69626600 	stmdbvs	r2!, {r9, sl, sp, lr}^
     eec:	6d695f74 	stclvs	15, cr5, [r9, #-464]!	; 0xfffffe30
     ef0:	63696c70 	cmnvs	r9, #112, 24	; 0x7000
     ef4:	6f697461 	svcvs	0x00697461
     ef8:	3050006e 	subscc	r0, r0, lr, rrx
     efc:	554e455f 	strbpl	r4, [lr, #-1375]	; 0xfffffaa1
     f00:	7369004d 	cmnvc	r9, #77	; 0x4d
     f04:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
     f08:	72635f74 	rsbvc	r5, r3, #116, 30	; 0x1d0
     f0c:	6f747079 	svcvs	0x00747079
     f10:	554e4700 	strbpl	r4, [lr, #-1792]	; 0xfffff900
     f14:	37314320 	ldrcc	r4, [r1, -r0, lsr #6]!
     f18:	2e303120 	rsfcssp	f3, f0, f0
     f1c:	20312e33 	eorscs	r2, r1, r3, lsr lr
     f20:	31323032 	teqcc	r2, r2, lsr r0
     f24:	31323630 	teqcc	r2, r0, lsr r6
     f28:	65722820 	ldrbvs	r2, [r2, #-2080]!	; 0xfffff7e0
     f2c:	7361656c 	cmnvc	r1, #108, 10	; 0x1b000000
     f30:	2d202965 			; <UNDEFINED> instruction: 0x2d202965
     f34:	6d72616d 	ldfvse	f6, [r2, #-436]!	; 0xfffffe4c
     f38:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
     f3c:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
     f40:	6962612d 	stmdbvs	r2!, {r0, r2, r3, r5, r8, sp, lr}^
     f44:	7261683d 	rsbvc	r6, r1, #3997696	; 0x3d0000
     f48:	6d2d2064 	stcvs	0, cr2, [sp, #-400]!	; 0xfffffe70
     f4c:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
     f50:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
     f54:	65743576 	ldrbvs	r3, [r4, #-1398]!	; 0xfffffa8a
     f58:	2070662b 	rsbscs	r6, r0, fp, lsr #12
     f5c:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
     f60:	672d2067 	strvs	r2, [sp, -r7, rrx]!
     f64:	324f2d20 	subcc	r2, pc, #32, 26	; 0x800
     f68:	324f2d20 	subcc	r2, pc, #32, 26	; 0x800
     f6c:	324f2d20 	subcc	r2, pc, #32, 26	; 0x800
     f70:	62662d20 	rsbvs	r2, r6, #32, 26	; 0x800
     f74:	646c6975 	strbtvs	r6, [ip], #-2421	; 0xfffff68b
     f78:	2d676e69 	stclcs	14, cr6, [r7, #-420]!	; 0xfffffe5c
     f7c:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
     f80:	2d206363 	stccs	3, cr6, [r0, #-396]!	; 0xfffffe74
     f84:	2d6f6e66 	stclcs	14, cr6, [pc, #-408]!	; df4 <shift+0xdf4>
     f88:	63617473 	cmnvs	r1, #1929379840	; 0x73000000
     f8c:	72702d6b 	rsbsvc	r2, r0, #6848	; 0x1ac0
     f90:	6365746f 	cmnvs	r5, #1862270976	; 0x6f000000
     f94:	20726f74 	rsbscs	r6, r2, r4, ror pc
     f98:	6f6e662d 	svcvs	0x006e662d
     f9c:	6c6e692d 			; <UNDEFINED> instruction: 0x6c6e692d
     fa0:	20656e69 	rsbcs	r6, r5, r9, ror #28
     fa4:	6976662d 	ldmdbvs	r6!, {r0, r2, r3, r5, r9, sl, sp, lr}^
     fa8:	69626973 	stmdbvs	r2!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
     fac:	7974696c 	ldmdbvc	r4!, {r2, r3, r5, r6, r8, fp, sp, lr}^
     fb0:	6469683d 	strbtvs	r6, [r9], #-2109	; 0xfffff7c3
     fb4:	006e6564 	rsbeq	r6, lr, r4, ror #10
     fb8:	5f617369 	svcpl	0x00617369
     fbc:	5f746962 	svcpl	0x00746962
     fc0:	76696474 			; <UNDEFINED> instruction: 0x76696474
     fc4:	6e6f6300 	cdpvs	3, 6, cr6, cr15, cr0, {0}
     fc8:	73690073 	cmnvc	r9, #115	; 0x73
     fcc:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
     fd0:	77695f74 			; <UNDEFINED> instruction: 0x77695f74
     fd4:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
     fd8:	43504600 	cmpmi	r0, #0, 12
     fdc:	5f535458 	svcpl	0x00535458
     fe0:	4d554e45 	ldclmi	14, cr4, [r5, #-276]	; 0xfffffeec
     fe4:	61736900 	cmnvs	r3, r0, lsl #18
     fe8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
     fec:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
     ff0:	69003676 	stmdbvs	r0, {r1, r2, r4, r5, r6, r9, sl, ip, sp}
     ff4:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
     ff8:	6d5f7469 	cfldrdvs	mvd7, [pc, #-420]	; e5c <shift+0xe5c>
     ffc:	69006576 	stmdbvs	r0, {r1, r2, r4, r5, r6, r8, sl, sp, lr}
    1000:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1004:	695f7469 	ldmdbvs	pc, {r0, r3, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    1008:	786d6d77 	stmdavc	sp!, {r0, r1, r2, r4, r5, r6, r8, sl, fp, sp, lr}^
    100c:	69003274 	stmdbvs	r0, {r2, r4, r5, r6, r9, ip, sp}
    1010:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1014:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    1018:	70636564 	rsbvc	r6, r3, r4, ror #10
    101c:	73690030 	cmnvc	r9, #48	; 0x30
    1020:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1024:	64635f74 	strbtvs	r5, [r3], #-3956	; 0xfffff08c
    1028:	31706365 	cmncc	r0, r5, ror #6
    102c:	61736900 	cmnvs	r3, r0, lsl #18
    1030:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1034:	6564635f 	strbvs	r6, [r4, #-863]!	; 0xfffffca1
    1038:	00327063 	eorseq	r7, r2, r3, rrx
    103c:	5f617369 	svcpl	0x00617369
    1040:	5f746962 	svcpl	0x00746962
    1044:	63656463 	cmnvs	r5, #1660944384	; 0x63000000
    1048:	69003370 	stmdbvs	r0, {r4, r5, r6, r8, r9, ip, sp}
    104c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1050:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    1054:	70636564 	rsbvc	r6, r3, r4, ror #10
    1058:	73690034 	cmnvc	r9, #52	; 0x34
    105c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1060:	70665f74 	rsbvc	r5, r6, r4, ror pc
    1064:	6c62645f 	cfstrdvs	mvd6, [r2], #-380	; 0xfffffe84
    1068:	61736900 	cmnvs	r3, r0, lsl #18
    106c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1070:	6564635f 	strbvs	r6, [r4, #-863]!	; 0xfffffca1
    1074:	00367063 	eorseq	r7, r6, r3, rrx
    1078:	5f617369 	svcpl	0x00617369
    107c:	5f746962 	svcpl	0x00746962
    1080:	63656463 	cmnvs	r5, #1660944384	; 0x63000000
    1084:	69003770 	stmdbvs	r0, {r4, r5, r6, r8, r9, sl, ip, sp}
    1088:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    108c:	615f7469 	cmpvs	pc, r9, ror #8
    1090:	36766d72 			; <UNDEFINED> instruction: 0x36766d72
    1094:	7369006b 	cmnvc	r9, #107	; 0x6b
    1098:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    109c:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    10a0:	5f38766d 	svcpl	0x0038766d
    10a4:	6d5f6d31 	ldclvs	13, cr6, [pc, #-196]	; fe8 <shift+0xfe8>
    10a8:	006e6961 	rsbeq	r6, lr, r1, ror #18
    10ac:	65746e61 	ldrbvs	r6, [r4, #-3681]!	; 0xfffff19f
    10b0:	61736900 	cmnvs	r3, r0, lsl #18
    10b4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    10b8:	736d635f 	cmnvc	sp, #2080374785	; 0x7c000001
    10bc:	6f6c0065 	svcvs	0x006c0065
    10c0:	6420676e 	strtvs	r6, [r0], #-1902	; 0xfffff892
    10c4:	6c62756f 	cfstr64vs	mvdx7, [r2], #-444	; 0xfffffe44
    10c8:	2e2e0065 	cdpcs	0, 2, cr0, cr14, cr5, {3}
    10cc:	2f2e2e2f 	svccs	0x002e2e2f
    10d0:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    10d4:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    10d8:	2f2e2e2f 	svccs	0x002e2e2f
    10dc:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    10e0:	6c2f6363 	stcvs	3, cr6, [pc], #-396	; f5c <shift+0xf5c>
    10e4:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    10e8:	632e3263 			; <UNDEFINED> instruction: 0x632e3263
    10ec:	61736900 	cmnvs	r3, r0, lsl #18
    10f0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    10f4:	7670665f 			; <UNDEFINED> instruction: 0x7670665f
    10f8:	73690035 	cmnvc	r9, #53	; 0x35
    10fc:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1100:	73785f74 	cmnvc	r8, #116, 30	; 0x1d0
    1104:	656c6163 	strbvs	r6, [ip, #-355]!	; 0xfffffe9d
    1108:	6e6f6c00 	cdpvs	12, 6, cr6, cr15, cr0, {0}
    110c:	6f6c2067 	svcvs	0x006c2067
    1110:	7520676e 	strvc	r6, [r0, #-1902]!	; 0xfffff892
    1114:	6769736e 	strbvs	r7, [r9, -lr, ror #6]!
    1118:	2064656e 	rsbcs	r6, r4, lr, ror #10
    111c:	00746e69 	rsbseq	r6, r4, r9, ror #28
    1120:	5f617369 	svcpl	0x00617369
    1124:	5f746962 	svcpl	0x00746962
    1128:	72697571 	rsbvc	r7, r9, #473956352	; 0x1c400000
    112c:	6d635f6b 	stclvs	15, cr5, [r3, #-428]!	; 0xfffffe54
    1130:	646c5f33 	strbtvs	r5, [ip], #-3891	; 0xfffff0cd
    1134:	69006472 	stmdbvs	r0, {r1, r4, r5, r6, sl, sp, lr}
    1138:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    113c:	695f7469 	ldmdbvs	pc, {r0, r3, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    1140:	006d6d38 	rsbeq	r6, sp, r8, lsr sp
    1144:	5f617369 	svcpl	0x00617369
    1148:	5f746962 	svcpl	0x00746962
    114c:	645f7066 	ldrbvs	r7, [pc], #-102	; 1154 <shift+0x1154>
    1150:	69003233 	stmdbvs	r0, {r0, r1, r4, r5, r9, ip, sp}
    1154:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1158:	615f7469 	cmpvs	pc, r9, ror #8
    115c:	37766d72 			; <UNDEFINED> instruction: 0x37766d72
    1160:	69006d65 	stmdbvs	r0, {r0, r2, r5, r6, r8, sl, fp, sp, lr}
    1164:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1168:	6c5f7469 	cfldrdvs	mvd7, [pc], {105}	; 0x69
    116c:	00656170 	rsbeq	r6, r5, r0, ror r1
    1170:	5f6c6c61 	svcpl	0x006c6c61
    1174:	6c706d69 	ldclvs	13, cr6, [r0], #-420	; 0xfffffe5c
    1178:	5f646569 	svcpl	0x00646569
    117c:	74696266 	strbtvc	r6, [r9], #-614	; 0xfffffd9a
    1180:	73690073 	cmnvc	r9, #115	; 0x73
    1184:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1188:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    118c:	5f38766d 	svcpl	0x0038766d
    1190:	73690031 	cmnvc	r9, #49	; 0x31
    1194:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1198:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    119c:	5f38766d 	svcpl	0x0038766d
    11a0:	73690032 	cmnvc	r9, #50	; 0x32
    11a4:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    11a8:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    11ac:	5f38766d 	svcpl	0x0038766d
    11b0:	73690033 	cmnvc	r9, #51	; 0x33
    11b4:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    11b8:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    11bc:	5f38766d 	svcpl	0x0038766d
    11c0:	73690034 	cmnvc	r9, #52	; 0x34
    11c4:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    11c8:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    11cc:	5f38766d 	svcpl	0x0038766d
    11d0:	73690035 	cmnvc	r9, #53	; 0x35
    11d4:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    11d8:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    11dc:	5f38766d 	svcpl	0x0038766d
    11e0:	73690036 	cmnvc	r9, #54	; 0x36
    11e4:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    11e8:	62735f74 	rsbsvs	r5, r3, #116, 30	; 0x1d0
    11ec:	61736900 	cmnvs	r3, r0, lsl #18
    11f0:	6d756e5f 	ldclvs	14, cr6, [r5, #-380]!	; 0xfffffe84
    11f4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    11f8:	73690073 	cmnvc	r9, #115	; 0x73
    11fc:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1200:	6d735f74 	ldclvs	15, cr5, [r3, #-464]!	; 0xfffffe30
    1204:	6d6c6c61 	stclvs	12, cr6, [ip, #-388]!	; 0xfffffe7c
    1208:	66006c75 			; <UNDEFINED> instruction: 0x66006c75
    120c:	5f636e75 	svcpl	0x00636e75
    1210:	00727470 	rsbseq	r7, r2, r0, ror r4
    1214:	706d6f63 	rsbvc	r6, sp, r3, ror #30
    1218:	2078656c 	rsbscs	r6, r8, ip, ror #10
    121c:	62756f64 	rsbsvs	r6, r5, #100, 30	; 0x190
    1220:	4e00656c 	cfsh32mi	mvfx6, mvfx0, #60
    1224:	50465f42 	subpl	r5, r6, r2, asr #30
    1228:	5359535f 	cmppl	r9, #2080374785	; 0x7c000001
    122c:	53474552 	movtpl	r4, #30034	; 0x7552
    1230:	61736900 	cmnvs	r3, r0, lsl #18
    1234:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1238:	6564635f 	strbvs	r6, [r4, #-863]!	; 0xfffffca1
    123c:	00357063 	eorseq	r7, r5, r3, rrx
    1240:	5f617369 	svcpl	0x00617369
    1244:	5f746962 	svcpl	0x00746962
    1248:	76706676 			; <UNDEFINED> instruction: 0x76706676
    124c:	73690032 	cmnvc	r9, #50	; 0x32
    1250:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1254:	66765f74 	uhsub16vs	r5, r6, r4
    1258:	00337670 	eorseq	r7, r3, r0, ror r6
    125c:	5f617369 	svcpl	0x00617369
    1260:	5f746962 	svcpl	0x00746962
    1264:	76706676 			; <UNDEFINED> instruction: 0x76706676
    1268:	50460034 	subpl	r0, r6, r4, lsr r0
    126c:	4e545843 	cdpmi	8, 5, cr5, cr4, cr3, {2}
    1270:	4e455f53 	mcrmi	15, 2, r5, cr5, cr3, {2}
    1274:	69004d55 	stmdbvs	r0, {r0, r2, r4, r6, r8, sl, fp, lr}
    1278:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    127c:	745f7469 	ldrbvc	r7, [pc], #-1129	; 1284 <shift+0x1284>
    1280:	626d7568 	rsbvs	r7, sp, #104, 10	; 0x1a000000
    1284:	61736900 	cmnvs	r3, r0, lsl #18
    1288:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    128c:	3170665f 	cmncc	r0, pc, asr r6
    1290:	6e6f6336 	mcrvs	3, 3, r6, cr15, cr6, {1}
    1294:	73690076 	cmnvc	r9, #118	; 0x76
    1298:	65665f61 	strbvs	r5, [r6, #-3937]!	; 0xfffff09f
    129c:	72757461 	rsbsvc	r7, r5, #1627389952	; 0x61000000
    12a0:	73690065 	cmnvc	r9, #101	; 0x65
    12a4:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    12a8:	6f6e5f74 	svcvs	0x006e5f74
    12ac:	69006d74 	stmdbvs	r0, {r2, r4, r5, r6, r8, sl, fp, sp, lr}
    12b0:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    12b4:	715f7469 	cmpvc	pc, r9, ror #8
    12b8:	6b726975 	blvs	1c9b894 <_bss_end+0x1c92180>
    12bc:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    12c0:	7a6b3676 	bvc	1aceca0 <_bss_end+0x1ac558c>
    12c4:	61736900 	cmnvs	r3, r0, lsl #18
    12c8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    12cc:	6372635f 	cmnvs	r2, #2080374785	; 0x7c000001
    12d0:	69003233 	stmdbvs	r0, {r0, r1, r4, r5, r9, ip, sp}
    12d4:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    12d8:	715f7469 	cmpvc	pc, r9, ror #8
    12dc:	6b726975 	blvs	1c9b8b8 <_bss_end+0x1c921a4>
    12e0:	5f6f6e5f 	svcpl	0x006f6e5f
    12e4:	636d7361 	cmnvs	sp, #-2080374783	; 0x84000001
    12e8:	69007570 	stmdbvs	r0, {r4, r5, r6, r8, sl, ip, sp, lr}
    12ec:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    12f0:	615f7469 	cmpvs	pc, r9, ror #8
    12f4:	34766d72 	ldrbtcc	r6, [r6], #-3442	; 0xfffff28e
    12f8:	61736900 	cmnvs	r3, r0, lsl #18
    12fc:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1300:	7568745f 	strbvc	r7, [r8, #-1119]!	; 0xfffffba1
    1304:	0032626d 	eorseq	r6, r2, sp, ror #4
    1308:	5f617369 	svcpl	0x00617369
    130c:	5f746962 	svcpl	0x00746962
    1310:	00386562 	eorseq	r6, r8, r2, ror #10
    1314:	5f617369 	svcpl	0x00617369
    1318:	5f746962 	svcpl	0x00746962
    131c:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1320:	73690037 	cmnvc	r9, #55	; 0x37
    1324:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1328:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    132c:	0038766d 	eorseq	r7, r8, sp, ror #12
    1330:	5f706676 	svcpl	0x00706676
    1334:	72737973 	rsbsvc	r7, r3, #1884160	; 0x1cc000
    1338:	5f736765 	svcpl	0x00736765
    133c:	6f636e65 	svcvs	0x00636e65
    1340:	676e6964 	strbvs	r6, [lr, -r4, ror #18]!
    1344:	61736900 	cmnvs	r3, r0, lsl #18
    1348:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    134c:	3170665f 	cmncc	r0, pc, asr r6
    1350:	6c6d6636 	stclvs	6, cr6, [sp], #-216	; 0xffffff28
    1354:	61736900 	cmnvs	r3, r0, lsl #18
    1358:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    135c:	746f645f 	strbtvc	r6, [pc], #-1119	; 1364 <shift+0x1364>
    1360:	646f7270 	strbtvs	r7, [pc], #-624	; 1368 <shift+0x1368>
	...

Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347 	bcc	10d0d24 <_bss_end+0x10c7610>
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
  10:	4b5a3605 	blmi	168d82c <_bss_end+0x1684118>
  14:	08070600 	stmdaeq	r7, {r9, sl}
  18:	0a010901 	beq	42424 <_bss_end+0x38d10>
  1c:	14041202 	strne	r1, [r4], #-514	; 0xfffffdfe
  20:	17011501 	strne	r1, [r1, -r1, lsl #10]
  24:	1a011803 	bne	46038 <_bss_end+0x3c924>
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
  20:	8b040e42 	blhi	103930 <_bss_end+0xfa21c>
  24:	0b0d4201 	bleq	350830 <_bss_end+0x34711c>
  28:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
  2c:	00000ecb 	andeq	r0, r0, fp, asr #29
  30:	0000001c 	andeq	r0, r0, ip, lsl r0
  34:	00000000 	andeq	r0, r0, r0
  38:	00008050 	andeq	r8, r0, r0, asr r0
  3c:	0000002c 	andeq	r0, r0, ip, lsr #32
  40:	8b040e42 	blhi	103950 <_bss_end+0xfa23c>
  44:	0b0d4201 	bleq	350850 <_bss_end+0x34713c>
  48:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
  4c:	00000ecb 	andeq	r0, r0, fp, asr #29
  50:	0000001c 	andeq	r0, r0, ip, lsl r0
  54:	00000000 	andeq	r0, r0, r0
  58:	0000807c 	andeq	r8, r0, ip, ror r0
  5c:	00000020 	andeq	r0, r0, r0, lsr #32
  60:	8b040e42 	blhi	103970 <_bss_end+0xfa25c>
  64:	0b0d4201 	bleq	350870 <_bss_end+0x34715c>
  68:	420d0d48 	andmi	r0, sp, #72, 26	; 0x1200
  6c:	00000ecb 	andeq	r0, r0, fp, asr #29
  70:	0000001c 	andeq	r0, r0, ip, lsl r0
  74:	00000000 	andeq	r0, r0, r0
  78:	0000809c 	muleq	r0, ip, r0
  7c:	00000018 	andeq	r0, r0, r8, lsl r0
  80:	8b040e42 	blhi	103990 <_bss_end+0xfa27c>
  84:	0b0d4201 	bleq	350890 <_bss_end+0x34717c>
  88:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  8c:	00000ecb 	andeq	r0, r0, fp, asr #29
  90:	0000001c 	andeq	r0, r0, ip, lsl r0
  94:	00000000 	andeq	r0, r0, r0
  98:	000080b4 	strheq	r8, [r0], -r4
  9c:	00000018 	andeq	r0, r0, r8, lsl r0
  a0:	8b040e42 	blhi	1039b0 <_bss_end+0xfa29c>
  a4:	0b0d4201 	bleq	3508b0 <_bss_end+0x34719c>
  a8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  ac:	00000ecb 	andeq	r0, r0, fp, asr #29
  b0:	0000001c 	andeq	r0, r0, ip, lsl r0
  b4:	00000000 	andeq	r0, r0, r0
  b8:	000080cc 	andeq	r8, r0, ip, asr #1
  bc:	00000018 	andeq	r0, r0, r8, lsl r0
  c0:	8b040e42 	blhi	1039d0 <_bss_end+0xfa2bc>
  c4:	0b0d4201 	bleq	3508d0 <_bss_end+0x3471bc>
  c8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  cc:	00000ecb 	andeq	r0, r0, fp, asr #29
  d0:	00000014 	andeq	r0, r0, r4, lsl r0
  d4:	00000000 	andeq	r0, r0, r0
  d8:	000080e4 	andeq	r8, r0, r4, ror #1
  dc:	0000000c 	andeq	r0, r0, ip
  e0:	8b040e42 	blhi	1039f0 <_bss_end+0xfa2dc>
  e4:	0b0d4201 	bleq	3508f0 <_bss_end+0x3471dc>
  e8:	0000000c 	andeq	r0, r0, ip
  ec:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  f0:	7c020001 	stcvc	0, cr0, [r2], {1}
  f4:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  f8:	0000001c 	andeq	r0, r0, ip, lsl r0
  fc:	000000e8 	andeq	r0, r0, r8, ror #1
 100:	000080f0 	strdeq	r8, [r0], -r0
 104:	00000034 	andeq	r0, r0, r4, lsr r0
 108:	8b040e42 	blhi	103a18 <_bss_end+0xfa304>
 10c:	0b0d4201 	bleq	350918 <_bss_end+0x347204>
 110:	420d0d52 	andmi	r0, sp, #5248	; 0x1480
 114:	00000ecb 	andeq	r0, r0, fp, asr #29
 118:	0000001c 	andeq	r0, r0, ip, lsl r0
 11c:	000000e8 	andeq	r0, r0, r8, ror #1
 120:	00008124 	andeq	r8, r0, r4, lsr #2
 124:	00000050 	andeq	r0, r0, r0, asr r0
 128:	8b080e42 	blhi	203a38 <_bss_end+0x1fa324>
 12c:	42018e02 	andmi	r8, r1, #2, 28
 130:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 134:	00080d0c 	andeq	r0, r8, ip, lsl #26
 138:	0000001c 	andeq	r0, r0, ip, lsl r0
 13c:	000000e8 	andeq	r0, r0, r8, ror #1
 140:	00008174 	andeq	r8, r0, r4, ror r1
 144:	00000054 	andeq	r0, r0, r4, asr r0
 148:	8b080e42 	blhi	203a58 <_bss_end+0x1fa344>
 14c:	42018e02 	andmi	r8, r1, #2, 28
 150:	64040b0c 	strvs	r0, [r4], #-2828	; 0xfffff4f4
 154:	00080d0c 	andeq	r0, r8, ip, lsl #26
 158:	0000001c 	andeq	r0, r0, ip, lsl r0
 15c:	000000e8 	andeq	r0, r0, r8, ror #1
 160:	000081c8 	andeq	r8, r0, r8, asr #3
 164:	00000044 	andeq	r0, r0, r4, asr #32
 168:	8b040e42 	blhi	103a78 <_bss_end+0xfa364>
 16c:	0b0d4201 	bleq	350978 <_bss_end+0x347264>
 170:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 174:	00000ecb 	andeq	r0, r0, fp, asr #29
 178:	0000001c 	andeq	r0, r0, ip, lsl r0
 17c:	000000e8 	andeq	r0, r0, r8, ror #1
 180:	0000820c 	andeq	r8, r0, ip, lsl #4
 184:	0000003c 	andeq	r0, r0, ip, lsr r0
 188:	8b040e42 	blhi	103a98 <_bss_end+0xfa384>
 18c:	0b0d4201 	bleq	350998 <_bss_end+0x347284>
 190:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 194:	00000ecb 	andeq	r0, r0, fp, asr #29
 198:	0000001c 	andeq	r0, r0, ip, lsl r0
 19c:	000000e8 	andeq	r0, r0, r8, ror #1
 1a0:	00008248 	andeq	r8, r0, r8, asr #4
 1a4:	00000054 	andeq	r0, r0, r4, asr r0
 1a8:	8b080e42 	blhi	203ab8 <_bss_end+0x1fa3a4>
 1ac:	42018e02 	andmi	r8, r1, #2, 28
 1b0:	5e040b0c 	vmlapl.f64	d0, d4, d12
 1b4:	00080d0c 	andeq	r0, r8, ip, lsl #26
 1b8:	00000018 	andeq	r0, r0, r8, lsl r0
 1bc:	000000e8 	andeq	r0, r0, r8, ror #1
 1c0:	0000829c 	muleq	r0, ip, r2
 1c4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1c8:	8b080e42 	blhi	203ad8 <_bss_end+0x1fa3c4>
 1cc:	42018e02 	andmi	r8, r1, #2, 28
 1d0:	00040b0c 	andeq	r0, r4, ip, lsl #22
 1d4:	0000000c 	andeq	r0, r0, ip
 1d8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 1dc:	7c020001 	stcvc	0, cr0, [r2], {1}
 1e0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 1e4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1e8:	000001d4 	ldrdeq	r0, [r0], -r4
 1ec:	000082b8 			; <UNDEFINED> instruction: 0x000082b8
 1f0:	00000034 	andeq	r0, r0, r4, lsr r0
 1f4:	8b040e42 	blhi	103b04 <_bss_end+0xfa3f0>
 1f8:	0b0d4201 	bleq	350a04 <_bss_end+0x3472f0>
 1fc:	420d0d52 	andmi	r0, sp, #5248	; 0x1480
 200:	00000ecb 	andeq	r0, r0, fp, asr #29
 204:	0000001c 	andeq	r0, r0, ip, lsl r0
 208:	000001d4 	ldrdeq	r0, [r0], -r4
 20c:	000082ec 	andeq	r8, r0, ip, ror #5
 210:	00000114 	andeq	r0, r0, r4, lsl r1
 214:	8b040e42 	blhi	103b24 <_bss_end+0xfa410>
 218:	0b0d4201 	bleq	350a24 <_bss_end+0x347310>
 21c:	0d0d8002 	stceq	0, cr8, [sp, #-8]
 220:	000ecb42 	andeq	ip, lr, r2, asr #22
 224:	0000001c 	andeq	r0, r0, ip, lsl r0
 228:	000001d4 	ldrdeq	r0, [r0], -r4
 22c:	00008400 	andeq	r8, r0, r0, lsl #8
 230:	00000074 	andeq	r0, r0, r4, ror r0
 234:	8b040e42 	blhi	103b44 <_bss_end+0xfa430>
 238:	0b0d4201 	bleq	350a44 <_bss_end+0x347330>
 23c:	420d0d72 	andmi	r0, sp, #7296	; 0x1c80
 240:	00000ecb 	andeq	r0, r0, fp, asr #29
 244:	0000001c 	andeq	r0, r0, ip, lsl r0
 248:	000001d4 	ldrdeq	r0, [r0], -r4
 24c:	00008474 	andeq	r8, r0, r4, ror r4
 250:	00000074 	andeq	r0, r0, r4, ror r0
 254:	8b040e42 	blhi	103b64 <_bss_end+0xfa450>
 258:	0b0d4201 	bleq	350a64 <_bss_end+0x347350>
 25c:	420d0d72 	andmi	r0, sp, #7296	; 0x1c80
 260:	00000ecb 	andeq	r0, r0, fp, asr #29
 264:	0000001c 	andeq	r0, r0, ip, lsl r0
 268:	000001d4 	ldrdeq	r0, [r0], -r4
 26c:	000084e8 	andeq	r8, r0, r8, ror #9
 270:	00000074 	andeq	r0, r0, r4, ror r0
 274:	8b040e42 	blhi	103b84 <_bss_end+0xfa470>
 278:	0b0d4201 	bleq	350a84 <_bss_end+0x347370>
 27c:	420d0d72 	andmi	r0, sp, #7296	; 0x1c80
 280:	00000ecb 	andeq	r0, r0, fp, asr #29
 284:	0000001c 	andeq	r0, r0, ip, lsl r0
 288:	000001d4 	ldrdeq	r0, [r0], -r4
 28c:	0000855c 	andeq	r8, r0, ip, asr r5
 290:	000000a0 	andeq	r0, r0, r0, lsr #1
 294:	8b080e42 	blhi	203ba4 <_bss_end+0x1fa490>
 298:	42018e02 	andmi	r8, r1, #2, 28
 29c:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 2a0:	080d0c4a 	stmdaeq	sp, {r1, r3, r6, sl, fp}
 2a4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2a8:	000001d4 	ldrdeq	r0, [r0], -r4
 2ac:	000085fc 	strdeq	r8, [r0], -ip
 2b0:	00000074 	andeq	r0, r0, r4, ror r0
 2b4:	8b080e42 	blhi	203bc4 <_bss_end+0x1fa4b0>
 2b8:	42018e02 	andmi	r8, r1, #2, 28
 2bc:	74040b0c 	strvc	r0, [r4], #-2828	; 0xfffff4f4
 2c0:	00080d0c 	andeq	r0, r8, ip, lsl #26
 2c4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2c8:	000001d4 	ldrdeq	r0, [r0], -r4
 2cc:	00008670 	andeq	r8, r0, r0, ror r6
 2d0:	000000d8 	ldrdeq	r0, [r0], -r8
 2d4:	8b080e42 	blhi	203be4 <_bss_end+0x1fa4d0>
 2d8:	42018e02 	andmi	r8, r1, #2, 28
 2dc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 2e0:	080d0c66 	stmdaeq	sp, {r1, r2, r5, r6, sl, fp}
 2e4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2e8:	000001d4 	ldrdeq	r0, [r0], -r4
 2ec:	00008748 	andeq	r8, r0, r8, asr #14
 2f0:	00000054 	andeq	r0, r0, r4, asr r0
 2f4:	8b080e42 	blhi	203c04 <_bss_end+0x1fa4f0>
 2f8:	42018e02 	andmi	r8, r1, #2, 28
 2fc:	5e040b0c 	vmlapl.f64	d0, d4, d12
 300:	00080d0c 	andeq	r0, r8, ip, lsl #26
 304:	00000018 	andeq	r0, r0, r8, lsl r0
 308:	000001d4 	ldrdeq	r0, [r0], -r4
 30c:	0000879c 	muleq	r0, ip, r7
 310:	0000001c 	andeq	r0, r0, ip, lsl r0
 314:	8b080e42 	blhi	203c24 <_bss_end+0x1fa510>
 318:	42018e02 	andmi	r8, r1, #2, 28
 31c:	00040b0c 	andeq	r0, r4, ip, lsl #22
 320:	0000000c 	andeq	r0, r0, ip
 324:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 328:	7c020001 	stcvc	0, cr0, [r2], {1}
 32c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 330:	0000001c 	andeq	r0, r0, ip, lsl r0
 334:	00000320 	andeq	r0, r0, r0, lsr #6
 338:	000087b8 			; <UNDEFINED> instruction: 0x000087b8
 33c:	00000078 	andeq	r0, r0, r8, ror r0
 340:	8b040e42 	blhi	103c50 <_bss_end+0xfa53c>
 344:	0b0d4201 	bleq	350b50 <_bss_end+0x34743c>
 348:	420d0d74 	andmi	r0, sp, #116, 26	; 0x1d00
 34c:	00000ecb 	andeq	r0, r0, fp, asr #29
 350:	0000001c 	andeq	r0, r0, ip, lsl r0
 354:	00000320 	andeq	r0, r0, r0, lsr #6
 358:	00008e00 	andeq	r8, r0, r0, lsl #28
 35c:	00000038 	andeq	r0, r0, r8, lsr r0
 360:	8b040e42 	blhi	103c70 <_bss_end+0xfa55c>
 364:	0b0d4201 	bleq	350b70 <_bss_end+0x34745c>
 368:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
 36c:	00000ecb 	andeq	r0, r0, fp, asr #29
 370:	0000001c 	andeq	r0, r0, ip, lsl r0
 374:	00000320 	andeq	r0, r0, r0, lsr #6
 378:	00008830 	andeq	r8, r0, r0, lsr r8
 37c:	000000a8 	andeq	r0, r0, r8, lsr #1
 380:	8b080e42 	blhi	203c90 <_bss_end+0x1fa57c>
 384:	42018e02 	andmi	r8, r1, #2, 28
 388:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 38c:	080d0c4e 	stmdaeq	sp, {r1, r2, r3, r6, sl, fp}
 390:	0000001c 	andeq	r0, r0, ip, lsl r0
 394:	00000320 	andeq	r0, r0, r0, lsr #6
 398:	00008e38 	andeq	r8, r0, r8, lsr lr
 39c:	00000088 	andeq	r0, r0, r8, lsl #1
 3a0:	8b080e42 	blhi	203cb0 <_bss_end+0x1fa59c>
 3a4:	42018e02 	andmi	r8, r1, #2, 28
 3a8:	7e040b0c 	vmlavc.f64	d0, d4, d12
 3ac:	00080d0c 	andeq	r0, r8, ip, lsl #26
 3b0:	0000001c 	andeq	r0, r0, ip, lsl r0
 3b4:	00000320 	andeq	r0, r0, r0, lsr #6
 3b8:	000088d8 	ldrdeq	r8, [r0], -r8	; <UNPREDICTABLE>
 3bc:	00000130 	andeq	r0, r0, r0, lsr r1
 3c0:	8b040e42 	blhi	103cd0 <_bss_end+0xfa5bc>
 3c4:	0b0d4201 	bleq	350bd0 <_bss_end+0x3474bc>
 3c8:	0d0d9002 	stceq	0, cr9, [sp, #-8]
 3cc:	000ecb42 	andeq	ip, lr, r2, asr #22
 3d0:	0000001c 	andeq	r0, r0, ip, lsl r0
 3d4:	00000320 	andeq	r0, r0, r0, lsr #6
 3d8:	00008ec0 	andeq	r8, r0, r0, asr #29
 3dc:	0000002c 	andeq	r0, r0, ip, lsr #32
 3e0:	8b040e42 	blhi	103cf0 <_bss_end+0xfa5dc>
 3e4:	0b0d4201 	bleq	350bf0 <_bss_end+0x3474dc>
 3e8:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 3ec:	00000ecb 	andeq	r0, r0, fp, asr #29
 3f0:	0000001c 	andeq	r0, r0, ip, lsl r0
 3f4:	00000320 	andeq	r0, r0, r0, lsr #6
 3f8:	00008a08 	andeq	r8, r0, r8, lsl #20
 3fc:	000000a8 	andeq	r0, r0, r8, lsr #1
 400:	8b080e42 	blhi	203d10 <_bss_end+0x1fa5fc>
 404:	42018e02 	andmi	r8, r1, #2, 28
 408:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 40c:	080d0c4e 	stmdaeq	sp, {r1, r2, r3, r6, sl, fp}
 410:	0000001c 	andeq	r0, r0, ip, lsl r0
 414:	00000320 	andeq	r0, r0, r0, lsr #6
 418:	00008ab0 			; <UNDEFINED> instruction: 0x00008ab0
 41c:	00000078 	andeq	r0, r0, r8, ror r0
 420:	8b080e42 	blhi	203d30 <_bss_end+0x1fa61c>
 424:	42018e02 	andmi	r8, r1, #2, 28
 428:	76040b0c 	strvc	r0, [r4], -ip, lsl #22
 42c:	00080d0c 	andeq	r0, r8, ip, lsl #26
 430:	0000001c 	andeq	r0, r0, ip, lsl r0
 434:	00000320 	andeq	r0, r0, r0, lsr #6
 438:	00008b28 	andeq	r8, r0, r8, lsr #22
 43c:	00000034 	andeq	r0, r0, r4, lsr r0
 440:	8b040e42 	blhi	103d50 <_bss_end+0xfa63c>
 444:	0b0d4201 	bleq	350c50 <_bss_end+0x34753c>
 448:	420d0d52 	andmi	r0, sp, #5248	; 0x1480
 44c:	00000ecb 	andeq	r0, r0, fp, asr #29
 450:	0000001c 	andeq	r0, r0, ip, lsl r0
 454:	00000320 	andeq	r0, r0, r0, lsr #6
 458:	00008b5c 	andeq	r8, r0, ip, asr fp
 45c:	00000054 	andeq	r0, r0, r4, asr r0
 460:	8b080e42 	blhi	203d70 <_bss_end+0x1fa65c>
 464:	42018e02 	andmi	r8, r1, #2, 28
 468:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 46c:	00080d0c 	andeq	r0, r8, ip, lsl #26
 470:	0000001c 	andeq	r0, r0, ip, lsl r0
 474:	00000320 	andeq	r0, r0, r0, lsr #6
 478:	00008bb0 			; <UNDEFINED> instruction: 0x00008bb0
 47c:	00000060 	andeq	r0, r0, r0, rrx
 480:	8b080e42 	blhi	203d90 <_bss_end+0x1fa67c>
 484:	42018e02 	andmi	r8, r1, #2, 28
 488:	66040b0c 	strvs	r0, [r4], -ip, lsl #22
 48c:	00080d0c 	andeq	r0, r8, ip, lsl #26
 490:	0000001c 	andeq	r0, r0, ip, lsl r0
 494:	00000320 	andeq	r0, r0, r0, lsr #6
 498:	00008c10 	andeq	r8, r0, r0, lsl ip
 49c:	0000017c 	andeq	r0, r0, ip, ror r1
 4a0:	8b080e42 	blhi	203db0 <_bss_end+0x1fa69c>
 4a4:	42018e02 	andmi	r8, r1, #2, 28
 4a8:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 4ac:	080d0cb6 	stmdaeq	sp, {r1, r2, r4, r5, r7, sl, fp}
 4b0:	0000001c 	andeq	r0, r0, ip, lsl r0
 4b4:	00000320 	andeq	r0, r0, r0, lsr #6
 4b8:	00008d8c 	andeq	r8, r0, ip, lsl #27
 4bc:	00000058 	andeq	r0, r0, r8, asr r0
 4c0:	8b080e42 	blhi	203dd0 <_bss_end+0x1fa6bc>
 4c4:	42018e02 	andmi	r8, r1, #2, 28
 4c8:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 4cc:	00080d0c 	andeq	r0, r8, ip, lsl #26
 4d0:	00000018 	andeq	r0, r0, r8, lsl r0
 4d4:	00000320 	andeq	r0, r0, r0, lsr #6
 4d8:	00008de4 	andeq	r8, r0, r4, ror #27
 4dc:	0000001c 	andeq	r0, r0, ip, lsl r0
 4e0:	8b080e42 	blhi	203df0 <_bss_end+0x1fa6dc>
 4e4:	42018e02 	andmi	r8, r1, #2, 28
 4e8:	00040b0c 	andeq	r0, r4, ip, lsl #22
 4ec:	0000000c 	andeq	r0, r0, ip
 4f0:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 4f4:	7c020001 	stcvc	0, cr0, [r2], {1}
 4f8:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 4fc:	0000001c 	andeq	r0, r0, ip, lsl r0
 500:	000004ec 	andeq	r0, r0, ip, ror #9
 504:	00008eec 	andeq	r8, r0, ip, ror #29
 508:	000000a4 	andeq	r0, r0, r4, lsr #1
 50c:	8b080e42 	blhi	203e1c <_bss_end+0x1fa708>
 510:	42018e02 	andmi	r8, r1, #2, 28
 514:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 518:	080d0c4c 	stmdaeq	sp, {r2, r3, r6, sl, fp}
 51c:	00000020 	andeq	r0, r0, r0, lsr #32
 520:	000004ec 	andeq	r0, r0, ip, ror #9
 524:	00008f90 	muleq	r0, r0, pc	; <UNPREDICTABLE>
 528:	0000005c 	andeq	r0, r0, ip, asr r0
 52c:	840c0e42 	strhi	r0, [ip], #-3650	; 0xfffff1be
 530:	8e028b03 	vmlahi.f64	d8, d2, d3
 534:	0b0c4201 	bleq	310d40 <_bss_end+0x30762c>
 538:	0d0c6804 	stceq	8, cr6, [ip, #-16]
 53c:	0000000c 	andeq	r0, r0, ip
 540:	0000001c 	andeq	r0, r0, ip, lsl r0
 544:	000004ec 	andeq	r0, r0, ip, ror #9
 548:	00008fec 	andeq	r8, r0, ip, ror #31
 54c:	00000094 	muleq	r0, r4, r0
 550:	8b080e42 	blhi	203e60 <_bss_end+0x1fa74c>
 554:	42018e02 	andmi	r8, r1, #2, 28
 558:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 55c:	080d0c40 	stmdaeq	sp, {r6, sl, fp}
 560:	0000001c 	andeq	r0, r0, ip, lsl r0
 564:	000004ec 	andeq	r0, r0, ip, ror #9
 568:	00009080 	andeq	r9, r0, r0, lsl #1
 56c:	0000008c 	andeq	r0, r0, ip, lsl #1
 570:	8b080e42 	blhi	203e80 <_bss_end+0x1fa76c>
 574:	42018e02 	andmi	r8, r1, #2, 28
 578:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 57c:	080d0c40 	stmdaeq	sp, {r6, sl, fp}
 580:	0000001c 	andeq	r0, r0, ip, lsl r0
 584:	000004ec 	andeq	r0, r0, ip, ror #9
 588:	0000910c 	andeq	r9, r0, ip, lsl #2
 58c:	0000006c 	andeq	r0, r0, ip, rrx
 590:	8b080e42 	blhi	203ea0 <_bss_end+0x1fa78c>
 594:	42018e02 	andmi	r8, r1, #2, 28
 598:	70040b0c 	andvc	r0, r4, ip, lsl #22
 59c:	00080d0c 	andeq	r0, r8, ip, lsl #26
 5a0:	0000001c 	andeq	r0, r0, ip, lsl r0
 5a4:	000004ec 	andeq	r0, r0, ip, ror #9
 5a8:	00009178 	andeq	r9, r0, r8, ror r1
 5ac:	00000054 	andeq	r0, r0, r4, asr r0
 5b0:	8b080e42 	blhi	203ec0 <_bss_end+0x1fa7ac>
 5b4:	42018e02 	andmi	r8, r1, #2, 28
 5b8:	5e040b0c 	vmlapl.f64	d0, d4, d12
 5bc:	00080d0c 	andeq	r0, r8, ip, lsl #26
 5c0:	00000018 	andeq	r0, r0, r8, lsl r0
 5c4:	000004ec 	andeq	r0, r0, ip, ror #9
 5c8:	000091cc 	andeq	r9, r0, ip, asr #3
 5cc:	0000001c 	andeq	r0, r0, ip, lsl r0
 5d0:	8b080e42 	blhi	203ee0 <_bss_end+0x1fa7cc>
 5d4:	42018e02 	andmi	r8, r1, #2, 28
 5d8:	00040b0c 	andeq	r0, r4, ip, lsl #22
 5dc:	0000000c 	andeq	r0, r0, ip
 5e0:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 5e4:	7c020001 	stcvc	0, cr0, [r2], {1}
 5e8:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 5ec:	00000018 	andeq	r0, r0, r8, lsl r0
 5f0:	000005dc 	ldrdeq	r0, [r0], -ip
 5f4:	000091e8 	andeq	r9, r0, r8, ror #3
 5f8:	00000060 	andeq	r0, r0, r0, rrx
 5fc:	8b080e42 	blhi	203f0c <_bss_end+0x1fa7f8>
 600:	42018e02 	andmi	r8, r1, #2, 28
 604:	00040b0c 	andeq	r0, r4, ip, lsl #22
 608:	0000000c 	andeq	r0, r0, ip
 60c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 610:	7c020001 	stcvc	0, cr0, [r2], {1}
 614:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 618:	0000001c 	andeq	r0, r0, ip, lsl r0
 61c:	00000608 	andeq	r0, r0, r8, lsl #12
 620:	00009248 	andeq	r9, r0, r8, asr #4
 624:	00000068 	andeq	r0, r0, r8, rrx
 628:	8b040e42 	blhi	103f38 <_bss_end+0xfa824>
 62c:	0b0d4201 	bleq	350e38 <_bss_end+0x347724>
 630:	420d0d68 	andmi	r0, sp, #104, 26	; 0x1a00
 634:	00000ecb 	andeq	r0, r0, fp, asr #29
 638:	0000001c 	andeq	r0, r0, ip, lsl r0
 63c:	00000608 	andeq	r0, r0, r8, lsl #12
 640:	000092b0 			; <UNDEFINED> instruction: 0x000092b0
 644:	00000058 	andeq	r0, r0, r8, asr r0
 648:	8b080e42 	blhi	203f58 <_bss_end+0x1fa844>
 64c:	42018e02 	andmi	r8, r1, #2, 28
 650:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 654:	00080d0c 	andeq	r0, r8, ip, lsl #26
 658:	0000001c 	andeq	r0, r0, ip, lsl r0
 65c:	00000608 	andeq	r0, r0, r8, lsl #12
 660:	00009308 	andeq	r9, r0, r8, lsl #6
 664:	00000058 	andeq	r0, r0, r8, asr r0
 668:	8b080e42 	blhi	203f78 <_bss_end+0x1fa864>
 66c:	42018e02 	andmi	r8, r1, #2, 28
 670:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 674:	00080d0c 	andeq	r0, r8, ip, lsl #26
 678:	0000000c 	andeq	r0, r0, ip
 67c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 680:	7c010001 	stcvc	0, cr0, [r1], {1}
 684:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 688:	0000000c 	andeq	r0, r0, ip
 68c:	00000678 	andeq	r0, r0, r8, ror r6
 690:	00009360 	andeq	r9, r0, r0, ror #6
 694:	000001ec 	andeq	r0, r0, ip, ror #3

Disassembly of section .debug_ranges:

00000000 <.debug_ranges>:
   0:	000087b8 			; <UNDEFINED> instruction: 0x000087b8
   4:	00008e00 	andeq	r8, r0, r0, lsl #28
   8:	00008e00 	andeq	r8, r0, r0, lsl #28
   c:	00008e38 	andeq	r8, r0, r8, lsr lr
  10:	00008e38 	andeq	r8, r0, r8, lsr lr
  14:	00008ec0 	andeq	r8, r0, r0, asr #29
  18:	00008ec0 	andeq	r8, r0, r0, asr #29
  1c:	00008eec 	andeq	r8, r0, ip, ror #29
	...
