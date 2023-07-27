
./kernel:     file format elf32-littlearm


Disassembly of section .text:

00008000 <_start>:
_start():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/start.s:8
;@ tady budou symboly, ktere chceme na zacatek kodove sekce
.section .text.start

;@ vstupni bod do kernelu - nechame ho vlozit na zacatek kodu
_start:
    mov sp,#0x8000			;@ nastavime stack pointer na spodek zasobniku
    8000:	e3a0d902 	mov	sp, #32768	; 0x8000
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/start.s:9
	bl _c_startup			;@ C startup kod (inicializace prostredi)
    8004:	eb000492 	bl	9254 <_c_startup>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/start.s:10
	bl _cpp_startup			;@ C++ startup kod (volani globalnich konstruktoru, ...)
    8008:	eb0004ab 	bl	92bc <_cpp_startup>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/start.s:11
    bl _kernel_main			;@ skocime do hlavniho kodu jadra (v C)
    800c:	eb000475 	bl	91e8 <_kernel_main>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/start.s:12
	bl _cpp_shutdown		;@ C++ shutdown kod (volani globalnich destruktoru, ...)
    8010:	eb0004bf 	bl	9314 <_cpp_shutdown>

00008014 <hang>:
hang():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/start.s:14
hang:
    b hang
    8014:	eafffffe 	b	8014 <hang>

00008018 <__cxa_guard_acquire>:
__cxa_guard_acquire():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/cxx.cpp:11
    extern "C" int __cxa_guard_acquire(__guard*);
    extern "C" void __cxa_guard_release(__guard*);
    extern "C" void __cxa_guard_abort(__guard*);

    extern "C" int __cxa_guard_acquire(__guard* g)
    {
    8018:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    801c:	e28db000 	add	fp, sp, #0
    8020:	e24dd00c 	sub	sp, sp, #12
    8024:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/cxx.cpp:12
        return !*(char*)(g);
    8028:	e51b3008 	ldr	r3, [fp, #-8]
    802c:	e5d33000 	ldrb	r3, [r3]
    8030:	e3530000 	cmp	r3, #0
    8034:	03a03001 	moveq	r3, #1
    8038:	13a03000 	movne	r3, #0
    803c:	e6ef3073 	uxtb	r3, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/cxx.cpp:13
    }
    8040:	e1a00003 	mov	r0, r3
    8044:	e28bd000 	add	sp, fp, #0
    8048:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    804c:	e12fff1e 	bx	lr

00008050 <__cxa_guard_release>:
__cxa_guard_release():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/cxx.cpp:16

    extern "C" void __cxa_guard_release(__guard* g)
    {
    8050:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8054:	e28db000 	add	fp, sp, #0
    8058:	e24dd00c 	sub	sp, sp, #12
    805c:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/cxx.cpp:17
        *(char*)g = 1;
    8060:	e51b3008 	ldr	r3, [fp, #-8]
    8064:	e3a02001 	mov	r2, #1
    8068:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/cxx.cpp:18
    }
    806c:	e320f000 	nop	{0}
    8070:	e28bd000 	add	sp, fp, #0
    8074:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8078:	e12fff1e 	bx	lr

0000807c <__cxa_guard_abort>:
__cxa_guard_abort():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/cxx.cpp:21

    extern "C" void __cxa_guard_abort(__guard*)
    {
    807c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8080:	e28db000 	add	fp, sp, #0
    8084:	e24dd00c 	sub	sp, sp, #12
    8088:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/cxx.cpp:22
    }
    808c:	e320f000 	nop	{0}
    8090:	e28bd000 	add	sp, fp, #0
    8094:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8098:	e12fff1e 	bx	lr

0000809c <__dso_handle>:
__dso_handle():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/cxx.cpp:26
}

extern "C" void __dso_handle()
{
    809c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    80a0:	e28db000 	add	fp, sp, #0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/cxx.cpp:28
    // ignore dtors for now
}
    80a4:	e320f000 	nop	{0}
    80a8:	e28bd000 	add	sp, fp, #0
    80ac:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    80b0:	e12fff1e 	bx	lr

000080b4 <__cxa_atexit>:
__cxa_atexit():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/cxx.cpp:31

extern "C" void __cxa_atexit()
{
    80b4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    80b8:	e28db000 	add	fp, sp, #0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/cxx.cpp:33
    // ignore dtors for now
}
    80bc:	e320f000 	nop	{0}
    80c0:	e28bd000 	add	sp, fp, #0
    80c4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    80c8:	e12fff1e 	bx	lr

000080cc <__cxa_pure_virtual>:
__cxa_pure_virtual():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/cxx.cpp:36

extern "C" void __cxa_pure_virtual()
{
    80cc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    80d0:	e28db000 	add	fp, sp, #0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/cxx.cpp:38
    // pure virtual method called
}
    80d4:	e320f000 	nop	{0}
    80d8:	e28bd000 	add	sp, fp, #0
    80dc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    80e0:	e12fff1e 	bx	lr

000080e4 <__aeabi_unwind_cpp_pr1>:
__aeabi_unwind_cpp_pr1():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/cxx.cpp:41

extern "C" void __aeabi_unwind_cpp_pr1()
{
    80e4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    80e8:	e28db000 	add	fp, sp, #0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/cxx.cpp:42 (discriminator 1)
    while (true)
    80ec:	eafffffe 	b	80ec <__aeabi_unwind_cpp_pr1+0x8>

000080f0 <_ZN4CAUXC1Ej>:
_ZN4CAUXC2Ej():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/bcm_aux.cpp:5
#include <drivers/bcm_aux.h>

CAUX sAUX(hal::AUX_Base);

CAUX::CAUX(unsigned int aux_base)
    80f0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    80f4:	e28db000 	add	fp, sp, #0
    80f8:	e24dd00c 	sub	sp, sp, #12
    80fc:	e50b0008 	str	r0, [fp, #-8]
    8100:	e50b100c 	str	r1, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/bcm_aux.cpp:6
: mAUX_Reg(reinterpret_cast<unsigned int*>(aux_base))
    8104:	e51b200c 	ldr	r2, [fp, #-12]
    8108:	e51b3008 	ldr	r3, [fp, #-8]
    810c:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/bcm_aux.cpp:9
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
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/bcm_aux.cpp:12

void CAUX::Enable(hal::AUX_Peripherals aux_peripheral)
{
    8124:	e92d4800 	push	{fp, lr}
    8128:	e28db004 	add	fp, sp, #4
    812c:	e24dd008 	sub	sp, sp, #8
    8130:	e50b0008 	str	r0, [fp, #-8]
    8134:	e50b100c 	str	r1, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/bcm_aux.cpp:14
    Set_Register(hal::AUX_Reg::ENABLES,
                 Get_Register(hal::AUX_Reg::ENABLES) | (1 << static_cast<uint32_t>(aux_peripheral)));
    8138:	e3a01001 	mov	r1, #1
    813c:	e51b0008 	ldr	r0, [fp, #-8]
    8140:	eb000031 	bl	820c <_ZN4CAUX12Get_RegisterEN3hal7AUX_RegE>
    8144:	e1a02000 	mov	r2, r0
    8148:	e51b300c 	ldr	r3, [fp, #-12]
    814c:	e3a01001 	mov	r1, #1
    8150:	e1a03311 	lsl	r3, r1, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/bcm_aux.cpp:13
    Set_Register(hal::AUX_Reg::ENABLES,
    8154:	e1823003 	orr	r3, r2, r3
    8158:	e1a02003 	mov	r2, r3
    815c:	e3a01001 	mov	r1, #1
    8160:	e51b0008 	ldr	r0, [fp, #-8]
    8164:	eb000017 	bl	81c8 <_ZN4CAUX12Set_RegisterEN3hal7AUX_RegEj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/bcm_aux.cpp:15
}
    8168:	e320f000 	nop	{0}
    816c:	e24bd004 	sub	sp, fp, #4
    8170:	e8bd8800 	pop	{fp, pc}

00008174 <_ZN4CAUX7DisableEN3hal15AUX_PeripheralsE>:
_ZN4CAUX7DisableEN3hal15AUX_PeripheralsE():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/bcm_aux.cpp:18

void CAUX::Disable(hal::AUX_Peripherals aux_peripheral)
{
    8174:	e92d4800 	push	{fp, lr}
    8178:	e28db004 	add	fp, sp, #4
    817c:	e24dd008 	sub	sp, sp, #8
    8180:	e50b0008 	str	r0, [fp, #-8]
    8184:	e50b100c 	str	r1, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/bcm_aux.cpp:20
    Set_Register(hal::AUX_Reg::ENABLES,
                 Get_Register(hal::AUX_Reg::ENABLES) & ~(1 << static_cast<uint32_t>(aux_peripheral)));
    8188:	e3a01001 	mov	r1, #1
    818c:	e51b0008 	ldr	r0, [fp, #-8]
    8190:	eb00001d 	bl	820c <_ZN4CAUX12Get_RegisterEN3hal7AUX_RegE>
    8194:	e1a02000 	mov	r2, r0
    8198:	e51b300c 	ldr	r3, [fp, #-12]
    819c:	e3a01001 	mov	r1, #1
    81a0:	e1a03311 	lsl	r3, r1, r3
    81a4:	e1e03003 	mvn	r3, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/bcm_aux.cpp:19
    Set_Register(hal::AUX_Reg::ENABLES,
    81a8:	e0033002 	and	r3, r3, r2
    81ac:	e1a02003 	mov	r2, r3
    81b0:	e3a01001 	mov	r1, #1
    81b4:	e51b0008 	ldr	r0, [fp, #-8]
    81b8:	eb000002 	bl	81c8 <_ZN4CAUX12Set_RegisterEN3hal7AUX_RegEj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/bcm_aux.cpp:21
}
    81bc:	e320f000 	nop	{0}
    81c0:	e24bd004 	sub	sp, fp, #4
    81c4:	e8bd8800 	pop	{fp, pc}

000081c8 <_ZN4CAUX12Set_RegisterEN3hal7AUX_RegEj>:
_ZN4CAUX12Set_RegisterEN3hal7AUX_RegEj():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/bcm_aux.cpp:24

void CAUX::Set_Register(hal::AUX_Reg reg_idx, uint32_t value)
{
    81c8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    81cc:	e28db000 	add	fp, sp, #0
    81d0:	e24dd014 	sub	sp, sp, #20
    81d4:	e50b0008 	str	r0, [fp, #-8]
    81d8:	e50b100c 	str	r1, [fp, #-12]
    81dc:	e50b2010 	str	r2, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/bcm_aux.cpp:25
    mAUX_Reg[static_cast<unsigned int>(reg_idx)] = value;
    81e0:	e51b3008 	ldr	r3, [fp, #-8]
    81e4:	e5932000 	ldr	r2, [r3]
    81e8:	e51b300c 	ldr	r3, [fp, #-12]
    81ec:	e1a03103 	lsl	r3, r3, #2
    81f0:	e0823003 	add	r3, r2, r3
    81f4:	e51b2010 	ldr	r2, [fp, #-16]
    81f8:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/bcm_aux.cpp:26
}
    81fc:	e320f000 	nop	{0}
    8200:	e28bd000 	add	sp, fp, #0
    8204:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8208:	e12fff1e 	bx	lr

0000820c <_ZN4CAUX12Get_RegisterEN3hal7AUX_RegE>:
_ZN4CAUX12Get_RegisterEN3hal7AUX_RegE():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/bcm_aux.cpp:29

uint32_t CAUX::Get_Register(hal::AUX_Reg reg_idx)
{
    820c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8210:	e28db000 	add	fp, sp, #0
    8214:	e24dd00c 	sub	sp, sp, #12
    8218:	e50b0008 	str	r0, [fp, #-8]
    821c:	e50b100c 	str	r1, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/bcm_aux.cpp:30
    return mAUX_Reg[static_cast<unsigned int>(reg_idx)];
    8220:	e51b3008 	ldr	r3, [fp, #-8]
    8224:	e5932000 	ldr	r2, [r3]
    8228:	e51b300c 	ldr	r3, [fp, #-12]
    822c:	e1a03103 	lsl	r3, r3, #2
    8230:	e0823003 	add	r3, r2, r3
    8234:	e5933000 	ldr	r3, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/bcm_aux.cpp:31
}
    8238:	e1a00003 	mov	r0, r3
    823c:	e28bd000 	add	sp, fp, #0
    8240:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8244:	e12fff1e 	bx	lr

00008248 <_Z41__static_initialization_and_destruction_0ii>:
_Z41__static_initialization_and_destruction_0ii():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/bcm_aux.cpp:31
    8248:	e92d4800 	push	{fp, lr}
    824c:	e28db004 	add	fp, sp, #4
    8250:	e24dd008 	sub	sp, sp, #8
    8254:	e50b0008 	str	r0, [fp, #-8]
    8258:	e50b100c 	str	r1, [fp, #-12]
    825c:	e51b3008 	ldr	r3, [fp, #-8]
    8260:	e3530001 	cmp	r3, #1
    8264:	1a000006 	bne	8284 <_Z41__static_initialization_and_destruction_0ii+0x3c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/bcm_aux.cpp:31 (discriminator 1)
    8268:	e51b300c 	ldr	r3, [fp, #-12]
    826c:	e59f201c 	ldr	r2, [pc, #28]	; 8290 <_Z41__static_initialization_and_destruction_0ii+0x48>
    8270:	e1530002 	cmp	r3, r2
    8274:	1a000002 	bne	8284 <_Z41__static_initialization_and_destruction_0ii+0x3c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/bcm_aux.cpp:3
CAUX sAUX(hal::AUX_Base);
    8278:	e59f1014 	ldr	r1, [pc, #20]	; 8294 <_Z41__static_initialization_and_destruction_0ii+0x4c>
    827c:	e59f0014 	ldr	r0, [pc, #20]	; 8298 <_Z41__static_initialization_and_destruction_0ii+0x50>
    8280:	ebffff9a 	bl	80f0 <_ZN4CAUXC1Ej>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/bcm_aux.cpp:31
}
    8284:	e320f000 	nop	{0}
    8288:	e24bd004 	sub	sp, fp, #4
    828c:	e8bd8800 	pop	{fp, pc}
    8290:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>
    8294:	20215000 	eorcs	r5, r1, r0
    8298:	000096d8 	ldrdeq	r9, [r0], -r8

0000829c <_GLOBAL__sub_I_sAUX>:
_GLOBAL__sub_I_sAUX():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/bcm_aux.cpp:31
    829c:	e92d4800 	push	{fp, lr}
    82a0:	e28db004 	add	fp, sp, #4
    82a4:	e59f1008 	ldr	r1, [pc, #8]	; 82b4 <_GLOBAL__sub_I_sAUX+0x18>
    82a8:	e3a00001 	mov	r0, #1
    82ac:	ebffffe5 	bl	8248 <_Z41__static_initialization_and_destruction_0ii>
    82b0:	e8bd8800 	pop	{fp, pc}
    82b4:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>

000082b8 <_ZN13CGPIO_HandlerC1Ej>:
_ZN13CGPIO_HandlerC2Ej():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:6
#include <hal/peripherals.h>
#include <drivers/gpio.h>

CGPIO_Handler sGPIO(hal::GPIO_Base);

CGPIO_Handler::CGPIO_Handler(unsigned int gpio_base_addr)
    82b8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    82bc:	e28db000 	add	fp, sp, #0
    82c0:	e24dd00c 	sub	sp, sp, #12
    82c4:	e50b0008 	str	r0, [fp, #-8]
    82c8:	e50b100c 	str	r1, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:7
: mGPIO(reinterpret_cast<unsigned int*>(gpio_base_addr))
    82cc:	e51b200c 	ldr	r2, [fp, #-12]
    82d0:	e51b3008 	ldr	r3, [fp, #-8]
    82d4:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:10
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
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:13

bool CGPIO_Handler::Get_GPFSEL_Location(uint32_t pin, uint32_t& reg, uint32_t& bit_idx) const
{
    82ec:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    82f0:	e28db000 	add	fp, sp, #0
    82f4:	e24dd014 	sub	sp, sp, #20
    82f8:	e50b0008 	str	r0, [fp, #-8]
    82fc:	e50b100c 	str	r1, [fp, #-12]
    8300:	e50b2010 	str	r2, [fp, #-16]
    8304:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:14
    if (pin > hal::GPIO_Pin_Count)
    8308:	e51b300c 	ldr	r3, [fp, #-12]
    830c:	e3530036 	cmp	r3, #54	; 0x36
    8310:	9a000001 	bls	831c <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0x30>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:15
        return false;
    8314:	e3a03000 	mov	r3, #0
    8318:	ea000033 	b	83ec <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0x100>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:17

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
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:20
    {
        case 0:
            reg = static_cast<uint32_t>(hal::GPIO_Reg::GPFSEL0);
    8350:	e51b3010 	ldr	r3, [fp, #-16]
    8354:	e3a02000 	mov	r2, #0
    8358:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:21
            break;
    835c:	ea000013 	b	83b0 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0xc4>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:23
        case 1:
            reg = static_cast<uint32_t>(hal::GPIO_Reg::GPFSEL1);
    8360:	e51b3010 	ldr	r3, [fp, #-16]
    8364:	e3a02001 	mov	r2, #1
    8368:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:24
            break;
    836c:	ea00000f 	b	83b0 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0xc4>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:26
        case 2:
            reg = static_cast<uint32_t>(hal::GPIO_Reg::GPFSEL2);
    8370:	e51b3010 	ldr	r3, [fp, #-16]
    8374:	e3a02002 	mov	r2, #2
    8378:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:27
            break;
    837c:	ea00000b 	b	83b0 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0xc4>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:29
        case 3:
            reg = static_cast<uint32_t>(hal::GPIO_Reg::GPFSEL3);
    8380:	e51b3010 	ldr	r3, [fp, #-16]
    8384:	e3a02003 	mov	r2, #3
    8388:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:30
            break;
    838c:	ea000007 	b	83b0 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0xc4>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:32
        case 4:
            reg = static_cast<uint32_t>(hal::GPIO_Reg::GPFSEL4);
    8390:	e51b3010 	ldr	r3, [fp, #-16]
    8394:	e3a02004 	mov	r2, #4
    8398:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:33
            break;
    839c:	ea000003 	b	83b0 <_ZNK13CGPIO_Handler19Get_GPFSEL_LocationEjRjS0_+0xc4>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:35
        case 5:
            reg = static_cast<uint32_t>(hal::GPIO_Reg::GPFSEL5);
    83a0:	e51b3010 	ldr	r3, [fp, #-16]
    83a4:	e3a02005 	mov	r2, #5
    83a8:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:36
            break;
    83ac:	e320f000 	nop	{0}
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:39
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
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:41

    return true;
    83e8:	e3a03001 	mov	r3, #1
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:42
}
    83ec:	e1a00003 	mov	r0, r3
    83f0:	e28bd000 	add	sp, fp, #0
    83f4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    83f8:	e12fff1e 	bx	lr
    83fc:	cccccccd 	stclgt	12, cr12, [ip], {205}	; 0xcd

00008400 <_ZNK13CGPIO_Handler18Get_GPCLR_LocationEjRjS0_>:
_ZNK13CGPIO_Handler18Get_GPCLR_LocationEjRjS0_():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:45

bool CGPIO_Handler::Get_GPCLR_Location(uint32_t pin, uint32_t& reg, uint32_t& bit_idx) const
{
    8400:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8404:	e28db000 	add	fp, sp, #0
    8408:	e24dd014 	sub	sp, sp, #20
    840c:	e50b0008 	str	r0, [fp, #-8]
    8410:	e50b100c 	str	r1, [fp, #-12]
    8414:	e50b2010 	str	r2, [fp, #-16]
    8418:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:46
    if (pin > hal::GPIO_Pin_Count)
    841c:	e51b300c 	ldr	r3, [fp, #-12]
    8420:	e3530036 	cmp	r3, #54	; 0x36
    8424:	9a000001 	bls	8430 <_ZNK13CGPIO_Handler18Get_GPCLR_LocationEjRjS0_+0x30>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:47
        return false;
    8428:	e3a03000 	mov	r3, #0
    842c:	ea00000c 	b	8464 <_ZNK13CGPIO_Handler18Get_GPCLR_LocationEjRjS0_+0x64>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:49

    reg = static_cast<uint32_t>((pin < 32) ? hal::GPIO_Reg::GPCLR0 : hal::GPIO_Reg::GPCLR1);
    8430:	e51b300c 	ldr	r3, [fp, #-12]
    8434:	e353001f 	cmp	r3, #31
    8438:	8a000001 	bhi	8444 <_ZNK13CGPIO_Handler18Get_GPCLR_LocationEjRjS0_+0x44>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:49 (discriminator 1)
    843c:	e3a0200a 	mov	r2, #10
    8440:	ea000000 	b	8448 <_ZNK13CGPIO_Handler18Get_GPCLR_LocationEjRjS0_+0x48>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:49 (discriminator 2)
    8444:	e3a0200b 	mov	r2, #11
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:49 (discriminator 4)
    8448:	e51b3010 	ldr	r3, [fp, #-16]
    844c:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:50 (discriminator 4)
    bit_idx = pin % 32;
    8450:	e51b300c 	ldr	r3, [fp, #-12]
    8454:	e203201f 	and	r2, r3, #31
    8458:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    845c:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:52 (discriminator 4)

    return true;
    8460:	e3a03001 	mov	r3, #1
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:53
}
    8464:	e1a00003 	mov	r0, r3
    8468:	e28bd000 	add	sp, fp, #0
    846c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8470:	e12fff1e 	bx	lr

00008474 <_ZNK13CGPIO_Handler18Get_GPSET_LocationEjRjS0_>:
_ZNK13CGPIO_Handler18Get_GPSET_LocationEjRjS0_():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:56

bool CGPIO_Handler::Get_GPSET_Location(uint32_t pin, uint32_t& reg, uint32_t& bit_idx) const
{
    8474:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8478:	e28db000 	add	fp, sp, #0
    847c:	e24dd014 	sub	sp, sp, #20
    8480:	e50b0008 	str	r0, [fp, #-8]
    8484:	e50b100c 	str	r1, [fp, #-12]
    8488:	e50b2010 	str	r2, [fp, #-16]
    848c:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:57
    if (pin > hal::GPIO_Pin_Count)
    8490:	e51b300c 	ldr	r3, [fp, #-12]
    8494:	e3530036 	cmp	r3, #54	; 0x36
    8498:	9a000001 	bls	84a4 <_ZNK13CGPIO_Handler18Get_GPSET_LocationEjRjS0_+0x30>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:58
        return false;
    849c:	e3a03000 	mov	r3, #0
    84a0:	ea00000c 	b	84d8 <_ZNK13CGPIO_Handler18Get_GPSET_LocationEjRjS0_+0x64>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:60

    reg = static_cast<uint32_t>((pin < 32) ? hal::GPIO_Reg::GPSET0 : hal::GPIO_Reg::GPSET1);
    84a4:	e51b300c 	ldr	r3, [fp, #-12]
    84a8:	e353001f 	cmp	r3, #31
    84ac:	8a000001 	bhi	84b8 <_ZNK13CGPIO_Handler18Get_GPSET_LocationEjRjS0_+0x44>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:60 (discriminator 1)
    84b0:	e3a02007 	mov	r2, #7
    84b4:	ea000000 	b	84bc <_ZNK13CGPIO_Handler18Get_GPSET_LocationEjRjS0_+0x48>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:60 (discriminator 2)
    84b8:	e3a02008 	mov	r2, #8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:60 (discriminator 4)
    84bc:	e51b3010 	ldr	r3, [fp, #-16]
    84c0:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:61 (discriminator 4)
    bit_idx = pin % 32;
    84c4:	e51b300c 	ldr	r3, [fp, #-12]
    84c8:	e203201f 	and	r2, r3, #31
    84cc:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    84d0:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:63 (discriminator 4)

    return true;
    84d4:	e3a03001 	mov	r3, #1
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:64
}
    84d8:	e1a00003 	mov	r0, r3
    84dc:	e28bd000 	add	sp, fp, #0
    84e0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    84e4:	e12fff1e 	bx	lr

000084e8 <_ZNK13CGPIO_Handler18Get_GPLEV_LocationEjRjS0_>:
_ZNK13CGPIO_Handler18Get_GPLEV_LocationEjRjS0_():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:67

bool CGPIO_Handler::Get_GPLEV_Location(uint32_t pin, uint32_t& reg, uint32_t& bit_idx) const
{
    84e8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    84ec:	e28db000 	add	fp, sp, #0
    84f0:	e24dd014 	sub	sp, sp, #20
    84f4:	e50b0008 	str	r0, [fp, #-8]
    84f8:	e50b100c 	str	r1, [fp, #-12]
    84fc:	e50b2010 	str	r2, [fp, #-16]
    8500:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:68
    if (pin > hal::GPIO_Pin_Count)
    8504:	e51b300c 	ldr	r3, [fp, #-12]
    8508:	e3530036 	cmp	r3, #54	; 0x36
    850c:	9a000001 	bls	8518 <_ZNK13CGPIO_Handler18Get_GPLEV_LocationEjRjS0_+0x30>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:69
        return false;
    8510:	e3a03000 	mov	r3, #0
    8514:	ea00000c 	b	854c <_ZNK13CGPIO_Handler18Get_GPLEV_LocationEjRjS0_+0x64>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:71

    reg = static_cast<uint32_t>((pin < 32) ? hal::GPIO_Reg::GPLEV0 : hal::GPIO_Reg::GPLEV1);
    8518:	e51b300c 	ldr	r3, [fp, #-12]
    851c:	e353001f 	cmp	r3, #31
    8520:	8a000001 	bhi	852c <_ZNK13CGPIO_Handler18Get_GPLEV_LocationEjRjS0_+0x44>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:71 (discriminator 1)
    8524:	e3a0200d 	mov	r2, #13
    8528:	ea000000 	b	8530 <_ZNK13CGPIO_Handler18Get_GPLEV_LocationEjRjS0_+0x48>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:71 (discriminator 2)
    852c:	e3a0200e 	mov	r2, #14
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:71 (discriminator 4)
    8530:	e51b3010 	ldr	r3, [fp, #-16]
    8534:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:72 (discriminator 4)
    bit_idx = pin % 32;
    8538:	e51b300c 	ldr	r3, [fp, #-12]
    853c:	e203201f 	and	r2, r3, #31
    8540:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8544:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:74 (discriminator 4)

    return true;
    8548:	e3a03001 	mov	r3, #1
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:75
}
    854c:	e1a00003 	mov	r0, r3
    8550:	e28bd000 	add	sp, fp, #0
    8554:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8558:	e12fff1e 	bx	lr

0000855c <_ZN13CGPIO_Handler17Set_GPIO_FunctionEj14NGPIO_Function>:
_ZN13CGPIO_Handler17Set_GPIO_FunctionEj14NGPIO_Function():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:78

void CGPIO_Handler::Set_GPIO_Function(uint32_t pin, NGPIO_Function func)
{
    855c:	e92d4800 	push	{fp, lr}
    8560:	e28db004 	add	fp, sp, #4
    8564:	e24dd018 	sub	sp, sp, #24
    8568:	e50b0010 	str	r0, [fp, #-16]
    856c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8570:	e1a03002 	mov	r3, r2
    8574:	e54b3015 	strb	r3, [fp, #-21]	; 0xffffffeb
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:80
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
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:83
        return;

    mGPIO[reg] = (mGPIO[reg] & (~static_cast<unsigned int>(7 << bit))) | (static_cast<unsigned int>(func) << bit);
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
    85c4:	e55b2015 	ldrb	r2, [fp, #-21]	; 0xffffffeb
    85c8:	e51b300c 	ldr	r3, [fp, #-12]
    85cc:	e1a02312 	lsl	r2, r2, r3
    85d0:	e51b3010 	ldr	r3, [fp, #-16]
    85d4:	e5930000 	ldr	r0, [r3]
    85d8:	e51b3008 	ldr	r3, [fp, #-8]
    85dc:	e1a03103 	lsl	r3, r3, #2
    85e0:	e0803003 	add	r3, r0, r3
    85e4:	e1812002 	orr	r2, r1, r2
    85e8:	e5832000 	str	r2, [r3]
    85ec:	ea000000 	b	85f4 <_ZN13CGPIO_Handler17Set_GPIO_FunctionEj14NGPIO_Function+0x98>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:81
        return;
    85f0:	e320f000 	nop	{0}
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:84
}
    85f4:	e24bd004 	sub	sp, fp, #4
    85f8:	e8bd8800 	pop	{fp, pc}

000085fc <_ZNK13CGPIO_Handler17Get_GPIO_FunctionEj>:
_ZNK13CGPIO_Handler17Get_GPIO_FunctionEj():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:87

NGPIO_Function CGPIO_Handler::Get_GPIO_Function(uint32_t pin) const
{
    85fc:	e92d4800 	push	{fp, lr}
    8600:	e28db004 	add	fp, sp, #4
    8604:	e24dd010 	sub	sp, sp, #16
    8608:	e50b0010 	str	r0, [fp, #-16]
    860c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:89
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
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:90
        return NGPIO_Function::Unspecified;
    8630:	e3a03008 	mov	r3, #8
    8634:	ea00000a 	b	8664 <_ZNK13CGPIO_Handler17Get_GPIO_FunctionEj+0x68>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:92

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
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:93 (discriminator 1)
}
    8664:	e1a00003 	mov	r0, r3
    8668:	e24bd004 	sub	sp, fp, #4
    866c:	e8bd8800 	pop	{fp, pc}

00008670 <_ZN13CGPIO_Handler10Set_OutputEjb>:
_ZN13CGPIO_Handler10Set_OutputEjb():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:96

void CGPIO_Handler::Set_Output(uint32_t pin, bool set)
{
    8670:	e92d4800 	push	{fp, lr}
    8674:	e28db004 	add	fp, sp, #4
    8678:	e24dd018 	sub	sp, sp, #24
    867c:	e50b0010 	str	r0, [fp, #-16]
    8680:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8684:	e1a03002 	mov	r3, r2
    8688:	e54b3015 	strb	r3, [fp, #-21]	; 0xffffffeb
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:98
    uint32_t reg, bit;
    if (!(set && Get_GPSET_Location(pin, reg, bit)) && !(!set && Get_GPCLR_Location(pin, reg, bit)))
    868c:	e55b3015 	ldrb	r3, [fp, #-21]	; 0xffffffeb
    8690:	e2233001 	eor	r3, r3, #1
    8694:	e6ef3073 	uxtb	r3, r3
    8698:	e3530000 	cmp	r3, #0
    869c:	1a000009 	bne	86c8 <_ZN13CGPIO_Handler10Set_OutputEjb+0x58>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:98 (discriminator 2)
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
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:98 (discriminator 3)
    86c8:	e55b3015 	ldrb	r3, [fp, #-21]	; 0xffffffeb
    86cc:	e3530000 	cmp	r3, #0
    86d0:	1a000009 	bne	86fc <_ZN13CGPIO_Handler10Set_OutputEjb+0x8c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:98 (discriminator 6)
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
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:98 (discriminator 7)
    86fc:	e3a03001 	mov	r3, #1
    8700:	ea000000 	b	8708 <_ZN13CGPIO_Handler10Set_OutputEjb+0x98>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:98 (discriminator 8)
    8704:	e3a03000 	mov	r3, #0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:98 (discriminator 10)
    8708:	e3530000 	cmp	r3, #0
    870c:	1a00000a 	bne	873c <_ZN13CGPIO_Handler10Set_OutputEjb+0xcc>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:101
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
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:99
        return;
    873c:	e320f000 	nop	{0}
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:102
}
    8740:	e24bd004 	sub	sp, fp, #4
    8744:	e8bd8800 	pop	{fp, pc}

00008748 <_Z41__static_initialization_and_destruction_0ii>:
_Z41__static_initialization_and_destruction_0ii():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:102
    8748:	e92d4800 	push	{fp, lr}
    874c:	e28db004 	add	fp, sp, #4
    8750:	e24dd008 	sub	sp, sp, #8
    8754:	e50b0008 	str	r0, [fp, #-8]
    8758:	e50b100c 	str	r1, [fp, #-12]
    875c:	e51b3008 	ldr	r3, [fp, #-8]
    8760:	e3530001 	cmp	r3, #1
    8764:	1a000006 	bne	8784 <_Z41__static_initialization_and_destruction_0ii+0x3c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:102 (discriminator 1)
    8768:	e51b300c 	ldr	r3, [fp, #-12]
    876c:	e59f201c 	ldr	r2, [pc, #28]	; 8790 <_Z41__static_initialization_and_destruction_0ii+0x48>
    8770:	e1530002 	cmp	r3, r2
    8774:	1a000002 	bne	8784 <_Z41__static_initialization_and_destruction_0ii+0x3c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:4
CGPIO_Handler sGPIO(hal::GPIO_Base);
    8778:	e59f1014 	ldr	r1, [pc, #20]	; 8794 <_Z41__static_initialization_and_destruction_0ii+0x4c>
    877c:	e59f0014 	ldr	r0, [pc, #20]	; 8798 <_Z41__static_initialization_and_destruction_0ii+0x50>
    8780:	ebfffecc 	bl	82b8 <_ZN13CGPIO_HandlerC1Ej>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:102
}
    8784:	e320f000 	nop	{0}
    8788:	e24bd004 	sub	sp, fp, #4
    878c:	e8bd8800 	pop	{fp, pc}
    8790:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>
    8794:	20200000 	eorcs	r0, r0, r0
    8798:	000096dc 	ldrdeq	r9, [r0], -ip

0000879c <_GLOBAL__sub_I_sGPIO>:
_GLOBAL__sub_I_sGPIO():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:102
    879c:	e92d4800 	push	{fp, lr}
    87a0:	e28db004 	add	fp, sp, #4
    87a4:	e59f1008 	ldr	r1, [pc, #8]	; 87b4 <_GLOBAL__sub_I_sGPIO+0x18>
    87a8:	e3a00001 	mov	r0, #1
    87ac:	ebffffe5 	bl	8748 <_Z41__static_initialization_and_destruction_0ii>
    87b0:	e8bd8800 	pop	{fp, pc}
    87b4:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>

000087b8 <_ZN8CMonitorC1Ejjj>:
_ZN8CMonitorC2Ejjj():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:5
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
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:6
: m_monitor{ reinterpret_cast<unsigned char*>(monitor_base_addr) }
    87d4:	e51b200c 	ldr	r2, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:10
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
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:12
{
}
    881c:	e51b3008 	ldr	r3, [fp, #-8]
    8820:	e1a00003 	mov	r0, r3
    8824:	e28bd000 	add	sp, fp, #0
    8828:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    882c:	e12fff1e 	bx	lr

00008830 <_ZN8CMonitor5ClearEv>:
_ZN8CMonitor5ClearEv():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:21
    m_cursor.y = 0;
    m_cursor.y = 0;
}

void CMonitor::Clear()
{
    8830:	e92d4800 	push	{fp, lr}
    8834:	e28db004 	add	fp, sp, #4
    8838:	e24dd010 	sub	sp, sp, #16
    883c:	e50b0010 	str	r0, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:22
    Reset_Cursor();
    8840:	e51b0010 	ldr	r0, [fp, #-16]
    8844:	eb00016d 	bl	8e00 <_ZN8CMonitor12Reset_CursorEv>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:24

    for (unsigned int y = 0; y < m_height; ++y)
    8848:	e3a03000 	mov	r3, #0
    884c:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:24 (discriminator 1)
    8850:	e51b3010 	ldr	r3, [fp, #-16]
    8854:	e5933008 	ldr	r3, [r3, #8]
    8858:	e51b2008 	ldr	r2, [fp, #-8]
    885c:	e1520003 	cmp	r2, r3
    8860:	2a000019 	bcs	88cc <_ZN8CMonitor5ClearEv+0x9c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:26
    {
        for (unsigned int x = 0; x < m_width; ++x)
    8864:	e3a03000 	mov	r3, #0
    8868:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:26 (discriminator 3)
    886c:	e51b3010 	ldr	r3, [fp, #-16]
    8870:	e5933004 	ldr	r3, [r3, #4]
    8874:	e51b200c 	ldr	r2, [fp, #-12]
    8878:	e1520003 	cmp	r2, r3
    887c:	2a00000e 	bcs	88bc <_ZN8CMonitor5ClearEv+0x8c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:28 (discriminator 2)
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
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:26 (discriminator 2)
        for (unsigned int x = 0; x < m_width; ++x)
    88ac:	e51b300c 	ldr	r3, [fp, #-12]
    88b0:	e2833001 	add	r3, r3, #1
    88b4:	e50b300c 	str	r3, [fp, #-12]
    88b8:	eaffffeb 	b	886c <_ZN8CMonitor5ClearEv+0x3c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:24 (discriminator 2)
    for (unsigned int y = 0; y < m_height; ++y)
    88bc:	e51b3008 	ldr	r3, [fp, #-8]
    88c0:	e2833001 	add	r3, r3, #1
    88c4:	e50b3008 	str	r3, [fp, #-8]
    88c8:	eaffffe0 	b	8850 <_ZN8CMonitor5ClearEv+0x20>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:31
        }
    }
}
    88cc:	e320f000 	nop	{0}
    88d0:	e24bd004 	sub	sp, fp, #4
    88d4:	e8bd8800 	pop	{fp, pc}

000088d8 <_ZN8CMonitor6ScrollEv>:
_ZN8CMonitor6ScrollEv():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:49
        m_cursor.y = m_height - 1;
    }
}

void CMonitor::Scroll()
{
    88d8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    88dc:	e28db000 	add	fp, sp, #0
    88e0:	e24dd01c 	sub	sp, sp, #28
    88e4:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:50
    for (unsigned int y = 1; y < m_height; ++y)
    88e8:	e3a03001 	mov	r3, #1
    88ec:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:50 (discriminator 1)
    88f0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    88f4:	e5933008 	ldr	r3, [r3, #8]
    88f8:	e51b2008 	ldr	r2, [fp, #-8]
    88fc:	e1520003 	cmp	r2, r3
    8900:	2a000024 	bcs	8998 <_ZN8CMonitor6ScrollEv+0xc0>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:52
    {
        for (unsigned int x = 0; x < m_width; ++x)
    8904:	e3a03000 	mov	r3, #0
    8908:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:52 (discriminator 3)
    890c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8910:	e5933004 	ldr	r3, [r3, #4]
    8914:	e51b200c 	ldr	r2, [fp, #-12]
    8918:	e1520003 	cmp	r2, r3
    891c:	2a000019 	bcs	8988 <_ZN8CMonitor6ScrollEv+0xb0>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:54 (discriminator 2)
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
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:52 (discriminator 2)
        for (unsigned int x = 0; x < m_width; ++x)
    8978:	e51b300c 	ldr	r3, [fp, #-12]
    897c:	e2833001 	add	r3, r3, #1
    8980:	e50b300c 	str	r3, [fp, #-12]
    8984:	eaffffe0 	b	890c <_ZN8CMonitor6ScrollEv+0x34>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:50 (discriminator 2)
    for (unsigned int y = 1; y < m_height; ++y)
    8988:	e51b3008 	ldr	r3, [fp, #-8]
    898c:	e2833001 	add	r3, r3, #1
    8990:	e50b3008 	str	r3, [fp, #-8]
    8994:	eaffffd5 	b	88f0 <_ZN8CMonitor6ScrollEv+0x18>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:58
        }
    }

    for (unsigned int x = 0; x < m_width; ++x)
    8998:	e3a03000 	mov	r3, #0
    899c:	e50b3010 	str	r3, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:58 (discriminator 3)
    89a0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    89a4:	e5933004 	ldr	r3, [r3, #4]
    89a8:	e51b2010 	ldr	r2, [fp, #-16]
    89ac:	e1520003 	cmp	r2, r3
    89b0:	2a000010 	bcs	89f8 <_ZN8CMonitor6ScrollEv+0x120>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:60 (discriminator 2)
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
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:58 (discriminator 2)
    for (unsigned int x = 0; x < m_width; ++x)
    89e8:	e51b3010 	ldr	r3, [fp, #-16]
    89ec:	e2833001 	add	r3, r3, #1
    89f0:	e50b3010 	str	r3, [fp, #-16]
    89f4:	eaffffe9 	b	89a0 <_ZN8CMonitor6ScrollEv+0xc8>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:62
    }
}
    89f8:	e320f000 	nop	{0}
    89fc:	e28bd000 	add	sp, fp, #0
    8a00:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8a04:	e12fff1e 	bx	lr

00008a08 <_ZN8CMonitorlsEc>:
_ZN8CMonitorlsEc():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:70
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
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:71
    if (c != '\n')
    8a20:	e55b3009 	ldrb	r3, [fp, #-9]
    8a24:	e353000a 	cmp	r3, #10
    8a28:	0a000012 	beq	8a78 <_ZN8CMonitorlsEc+0x70>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:73
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
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:74
        ++m_cursor.x;
    8a60:	e51b3008 	ldr	r3, [fp, #-8]
    8a64:	e5933010 	ldr	r3, [r3, #16]
    8a68:	e2832001 	add	r2, r3, #1
    8a6c:	e51b3008 	ldr	r3, [fp, #-8]
    8a70:	e5832010 	str	r2, [r3, #16]
    8a74:	ea000007 	b	8a98 <_ZN8CMonitorlsEc+0x90>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:78
    }
    else
    {
        m_cursor.x = 0;
    8a78:	e51b3008 	ldr	r3, [fp, #-8]
    8a7c:	e3a02000 	mov	r2, #0
    8a80:	e5832010 	str	r2, [r3, #16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:79
        ++m_cursor.y;
    8a84:	e51b3008 	ldr	r3, [fp, #-8]
    8a88:	e593300c 	ldr	r3, [r3, #12]
    8a8c:	e2832001 	add	r2, r3, #1
    8a90:	e51b3008 	ldr	r3, [fp, #-8]
    8a94:	e583200c 	str	r2, [r3, #12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:82
    }

    Adjust_Cursor();
    8a98:	e51b0008 	ldr	r0, [fp, #-8]
    8a9c:	eb0000e5 	bl	8e38 <_ZN8CMonitor13Adjust_CursorEv>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:84

    return *this;
    8aa0:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:85
}
    8aa4:	e1a00003 	mov	r0, r3
    8aa8:	e24bd004 	sub	sp, fp, #4
    8aac:	e8bd8800 	pop	{fp, pc}

00008ab0 <_ZN8CMonitorlsEPKc>:
_ZN8CMonitorlsEPKc():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:88

CMonitor& CMonitor::operator<<(const char* str)
{
    8ab0:	e92d4800 	push	{fp, lr}
    8ab4:	e28db004 	add	fp, sp, #4
    8ab8:	e24dd010 	sub	sp, sp, #16
    8abc:	e50b0010 	str	r0, [fp, #-16]
    8ac0:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:89
    for (unsigned int i = 0; str[i] != '\0'; ++i)
    8ac4:	e3a03000 	mov	r3, #0
    8ac8:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:89 (discriminator 3)
    8acc:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8ad0:	e51b3008 	ldr	r3, [fp, #-8]
    8ad4:	e0823003 	add	r3, r2, r3
    8ad8:	e5d33000 	ldrb	r3, [r3]
    8adc:	e3530000 	cmp	r3, #0
    8ae0:	0a00000a 	beq	8b10 <_ZN8CMonitorlsEPKc+0x60>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:91 (discriminator 2)
    {
        *this << str[i];
    8ae4:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8ae8:	e51b3008 	ldr	r3, [fp, #-8]
    8aec:	e0823003 	add	r3, r2, r3
    8af0:	e5d33000 	ldrb	r3, [r3]
    8af4:	e1a01003 	mov	r1, r3
    8af8:	e51b0010 	ldr	r0, [fp, #-16]
    8afc:	ebffffc1 	bl	8a08 <_ZN8CMonitorlsEc>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:89 (discriminator 2)
    for (unsigned int i = 0; str[i] != '\0'; ++i)
    8b00:	e51b3008 	ldr	r3, [fp, #-8]
    8b04:	e2833001 	add	r3, r3, #1
    8b08:	e50b3008 	str	r3, [fp, #-8]
    8b0c:	eaffffee 	b	8acc <_ZN8CMonitorlsEPKc+0x1c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:94
    }

    Reset_Number_Base();
    8b10:	e51b0010 	ldr	r0, [fp, #-16]
    8b14:	eb0000e9 	bl	8ec0 <_ZN8CMonitor17Reset_Number_BaseEv>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:96

    return *this;
    8b18:	e51b3010 	ldr	r3, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:97
}
    8b1c:	e1a00003 	mov	r0, r3
    8b20:	e24bd004 	sub	sp, fp, #4
    8b24:	e8bd8800 	pop	{fp, pc}

00008b28 <_ZN8CMonitorlsENS_12NNumber_BaseE>:
_ZN8CMonitorlsENS_12NNumber_BaseE():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:100

CMonitor& CMonitor::operator<<(CMonitor::NNumber_Base number_base)
{
    8b28:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8b2c:	e28db000 	add	fp, sp, #0
    8b30:	e24dd00c 	sub	sp, sp, #12
    8b34:	e50b0008 	str	r0, [fp, #-8]
    8b38:	e50b100c 	str	r1, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:101
    m_number_base = number_base;
    8b3c:	e51b3008 	ldr	r3, [fp, #-8]
    8b40:	e51b200c 	ldr	r2, [fp, #-12]
    8b44:	e5832014 	str	r2, [r3, #20]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:103

    return *this;
    8b48:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:104
}
    8b4c:	e1a00003 	mov	r0, r3
    8b50:	e28bd000 	add	sp, fp, #0
    8b54:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8b58:	e12fff1e 	bx	lr

00008b5c <_ZN8CMonitorlsEj>:
_ZN8CMonitorlsEj():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:107

CMonitor& CMonitor::operator<<(unsigned int num)
{
    8b5c:	e92d4800 	push	{fp, lr}
    8b60:	e28db004 	add	fp, sp, #4
    8b64:	e24dd008 	sub	sp, sp, #8
    8b68:	e50b0008 	str	r0, [fp, #-8]
    8b6c:	e50b100c 	str	r1, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:112
    static constexpr unsigned int BUFFER_SIZE = 16;

    static char s_buffer[BUFFER_SIZE];

    itoa(num, s_buffer, static_cast<unsigned int>(m_number_base));
    8b70:	e51b3008 	ldr	r3, [fp, #-8]
    8b74:	e5933014 	ldr	r3, [r3, #20]
    8b78:	e59f202c 	ldr	r2, [pc, #44]	; 8bac <_ZN8CMonitorlsEj+0x50>
    8b7c:	e51b100c 	ldr	r1, [fp, #-12]
    8b80:	e51b0008 	ldr	r0, [fp, #-8]
    8b84:	eb000021 	bl	8c10 <_ZN8CMonitor4itoaEjPcj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:113
    *this << s_buffer;
    8b88:	e59f101c 	ldr	r1, [pc, #28]	; 8bac <_ZN8CMonitorlsEj+0x50>
    8b8c:	e51b0008 	ldr	r0, [fp, #-8]
    8b90:	ebffffc6 	bl	8ab0 <_ZN8CMonitorlsEPKc>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:114
    Reset_Number_Base();
    8b94:	e51b0008 	ldr	r0, [fp, #-8]
    8b98:	eb0000c8 	bl	8ec0 <_ZN8CMonitor17Reset_Number_BaseEv>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:116

    return *this;
    8b9c:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:117
}
    8ba0:	e1a00003 	mov	r0, r3
    8ba4:	e24bd004 	sub	sp, fp, #4
    8ba8:	e8bd8800 	pop	{fp, pc}
    8bac:	000096f8 	strdeq	r9, [r0], -r8

00008bb0 <_ZN8CMonitorlsEb>:
_ZN8CMonitorlsEb():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:120

CMonitor& CMonitor::operator<<(bool value)
{
    8bb0:	e92d4800 	push	{fp, lr}
    8bb4:	e28db004 	add	fp, sp, #4
    8bb8:	e24dd008 	sub	sp, sp, #8
    8bbc:	e50b0008 	str	r0, [fp, #-8]
    8bc0:	e1a03001 	mov	r3, r1
    8bc4:	e54b3009 	strb	r3, [fp, #-9]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:121
    if (value)
    8bc8:	e55b3009 	ldrb	r3, [fp, #-9]
    8bcc:	e3530000 	cmp	r3, #0
    8bd0:	0a000003 	beq	8be4 <_ZN8CMonitorlsEb+0x34>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:123
    {
        *this << "true";
    8bd4:	e59f102c 	ldr	r1, [pc, #44]	; 8c08 <_ZN8CMonitorlsEb+0x58>
    8bd8:	e51b0008 	ldr	r0, [fp, #-8]
    8bdc:	ebffffb3 	bl	8ab0 <_ZN8CMonitorlsEPKc>
    8be0:	ea000002 	b	8bf0 <_ZN8CMonitorlsEb+0x40>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:127
    }
    else
    {
        *this << "false";
    8be4:	e59f1020 	ldr	r1, [pc, #32]	; 8c0c <_ZN8CMonitorlsEb+0x5c>
    8be8:	e51b0008 	ldr	r0, [fp, #-8]
    8bec:	ebffffaf 	bl	8ab0 <_ZN8CMonitorlsEPKc>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:130
    }

    Reset_Number_Base();
    8bf0:	e51b0008 	ldr	r0, [fp, #-8]
    8bf4:	eb0000b1 	bl	8ec0 <_ZN8CMonitor17Reset_Number_BaseEv>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:132

    return *this;
    8bf8:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:133
}
    8bfc:	e1a00003 	mov	r0, r3
    8c00:	e24bd004 	sub	sp, fp, #4
    8c04:	e8bd8800 	pop	{fp, pc}
    8c08:	00009660 	andeq	r9, r0, r0, ror #12
    8c0c:	00009668 	andeq	r9, r0, r8, ror #12

00008c10 <_ZN8CMonitor4itoaEjPcj>:
_ZN8CMonitor4itoaEjPcj():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:136

void CMonitor::itoa(unsigned int input, char* output, unsigned int base)
{
    8c10:	e92d4800 	push	{fp, lr}
    8c14:	e28db004 	add	fp, sp, #4
    8c18:	e24dd020 	sub	sp, sp, #32
    8c1c:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8c20:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    8c24:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    8c28:	e50b3024 	str	r3, [fp, #-36]	; 0xffffffdc
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:137
    int i = 0;
    8c2c:	e3a03000 	mov	r3, #0
    8c30:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:139

    while (input > 0)
    8c34:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8c38:	e3530000 	cmp	r3, #0
    8c3c:	0a000015 	beq	8c98 <_ZN8CMonitor4itoaEjPcj+0x88>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:141
    {
        output[i] = CharConvArr[input % base];
    8c40:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8c44:	e51b1024 	ldr	r1, [fp, #-36]	; 0xffffffdc
    8c48:	e1a00003 	mov	r0, r3
    8c4c:	eb000241 	bl	9558 <__aeabi_uidivmod>
    8c50:	e1a03001 	mov	r3, r1
    8c54:	e1a02003 	mov	r2, r3
    8c58:	e59f3128 	ldr	r3, [pc, #296]	; 8d88 <_ZN8CMonitor4itoaEjPcj+0x178>
    8c5c:	e0822003 	add	r2, r2, r3
    8c60:	e51b3008 	ldr	r3, [fp, #-8]
    8c64:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    8c68:	e0813003 	add	r3, r1, r3
    8c6c:	e5d22000 	ldrb	r2, [r2]
    8c70:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:142
        input /= base;
    8c74:	e51b1024 	ldr	r1, [fp, #-36]	; 0xffffffdc
    8c78:	e51b001c 	ldr	r0, [fp, #-28]	; 0xffffffe4
    8c7c:	eb0001ba 	bl	936c <__udivsi3>
    8c80:	e1a03000 	mov	r3, r0
    8c84:	e50b301c 	str	r3, [fp, #-28]	; 0xffffffe4
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:144

        i++;
    8c88:	e51b3008 	ldr	r3, [fp, #-8]
    8c8c:	e2833001 	add	r3, r3, #1
    8c90:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:139
    while (input > 0)
    8c94:	eaffffe6 	b	8c34 <_ZN8CMonitor4itoaEjPcj+0x24>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:147
    }

    if (i == 0)
    8c98:	e51b3008 	ldr	r3, [fp, #-8]
    8c9c:	e3530000 	cmp	r3, #0
    8ca0:	1a000007 	bne	8cc4 <_ZN8CMonitor4itoaEjPcj+0xb4>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:149
    {
        output[i] = CharConvArr[0];
    8ca4:	e51b3008 	ldr	r3, [fp, #-8]
    8ca8:	e51b2020 	ldr	r2, [fp, #-32]	; 0xffffffe0
    8cac:	e0823003 	add	r3, r2, r3
    8cb0:	e3a02030 	mov	r2, #48	; 0x30
    8cb4:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:150
        i++;
    8cb8:	e51b3008 	ldr	r3, [fp, #-8]
    8cbc:	e2833001 	add	r3, r3, #1
    8cc0:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:153
    }

    output[i] = '\0';
    8cc4:	e51b3008 	ldr	r3, [fp, #-8]
    8cc8:	e51b2020 	ldr	r2, [fp, #-32]	; 0xffffffe0
    8ccc:	e0823003 	add	r3, r2, r3
    8cd0:	e3a02000 	mov	r2, #0
    8cd4:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:154
    i--;
    8cd8:	e51b3008 	ldr	r3, [fp, #-8]
    8cdc:	e2433001 	sub	r3, r3, #1
    8ce0:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:156

    for (int j = 0; j <= (i / 2); j++)
    8ce4:	e3a03000 	mov	r3, #0
    8ce8:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:156 (discriminator 3)
    8cec:	e51b3008 	ldr	r3, [fp, #-8]
    8cf0:	e1a02fa3 	lsr	r2, r3, #31
    8cf4:	e0823003 	add	r3, r2, r3
    8cf8:	e1a030c3 	asr	r3, r3, #1
    8cfc:	e1a02003 	mov	r2, r3
    8d00:	e51b300c 	ldr	r3, [fp, #-12]
    8d04:	e1530002 	cmp	r3, r2
    8d08:	ca00001b 	bgt	8d7c <_ZN8CMonitor4itoaEjPcj+0x16c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:158 (discriminator 2)
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
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:159 (discriminator 2)
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
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:160 (discriminator 2)
        output[j] = c;
    8d58:	e51b300c 	ldr	r3, [fp, #-12]
    8d5c:	e51b2020 	ldr	r2, [fp, #-32]	; 0xffffffe0
    8d60:	e0823003 	add	r3, r2, r3
    8d64:	e55b200d 	ldrb	r2, [fp, #-13]
    8d68:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:156 (discriminator 2)
    for (int j = 0; j <= (i / 2); j++)
    8d6c:	e51b300c 	ldr	r3, [fp, #-12]
    8d70:	e2833001 	add	r3, r3, #1
    8d74:	e50b300c 	str	r3, [fp, #-12]
    8d78:	eaffffdb 	b	8cec <_ZN8CMonitor4itoaEjPcj+0xdc>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:162
    }
}
    8d7c:	e320f000 	nop	{0}
    8d80:	e24bd004 	sub	sp, fp, #4
    8d84:	e8bd8800 	pop	{fp, pc}
    8d88:	00009670 	andeq	r9, r0, r0, ror r6

00008d8c <_Z41__static_initialization_and_destruction_0ii>:
_Z41__static_initialization_and_destruction_0ii():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:162
    8d8c:	e92d4800 	push	{fp, lr}
    8d90:	e28db004 	add	fp, sp, #4
    8d94:	e24dd008 	sub	sp, sp, #8
    8d98:	e50b0008 	str	r0, [fp, #-8]
    8d9c:	e50b100c 	str	r1, [fp, #-12]
    8da0:	e51b3008 	ldr	r3, [fp, #-8]
    8da4:	e3530001 	cmp	r3, #1
    8da8:	1a000008 	bne	8dd0 <_Z41__static_initialization_and_destruction_0ii+0x44>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:162 (discriminator 1)
    8dac:	e51b300c 	ldr	r3, [fp, #-12]
    8db0:	e59f2024 	ldr	r2, [pc, #36]	; 8ddc <_Z41__static_initialization_and_destruction_0ii+0x50>
    8db4:	e1530002 	cmp	r3, r2
    8db8:	1a000004 	bne	8dd0 <_Z41__static_initialization_and_destruction_0ii+0x44>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:3
CMonitor sMonitor{ 0x30000000, 80, 25 };
    8dbc:	e3a03019 	mov	r3, #25
    8dc0:	e3a02050 	mov	r2, #80	; 0x50
    8dc4:	e3a01203 	mov	r1, #805306368	; 0x30000000
    8dc8:	e59f0010 	ldr	r0, [pc, #16]	; 8de0 <_Z41__static_initialization_and_destruction_0ii+0x54>
    8dcc:	ebfffe79 	bl	87b8 <_ZN8CMonitorC1Ejjj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:162
}
    8dd0:	e320f000 	nop	{0}
    8dd4:	e24bd004 	sub	sp, fp, #4
    8dd8:	e8bd8800 	pop	{fp, pc}
    8ddc:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>
    8de0:	000096e0 	andeq	r9, r0, r0, ror #13

00008de4 <_GLOBAL__sub_I_sMonitor>:
_GLOBAL__sub_I_sMonitor():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:162
    8de4:	e92d4800 	push	{fp, lr}
    8de8:	e28db004 	add	fp, sp, #4
    8dec:	e59f1008 	ldr	r1, [pc, #8]	; 8dfc <_GLOBAL__sub_I_sMonitor+0x18>
    8df0:	e3a00001 	mov	r0, #1
    8df4:	ebffffe4 	bl	8d8c <_Z41__static_initialization_and_destruction_0ii>
    8df8:	e8bd8800 	pop	{fp, pc}
    8dfc:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>

00008e00 <_ZN8CMonitor12Reset_CursorEv>:
_ZN8CMonitor12Reset_CursorEv():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:15
{
    8e00:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8e04:	e28db000 	add	fp, sp, #0
    8e08:	e24dd00c 	sub	sp, sp, #12
    8e0c:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:16
    m_cursor.y = 0;
    8e10:	e51b3008 	ldr	r3, [fp, #-8]
    8e14:	e3a02000 	mov	r2, #0
    8e18:	e583200c 	str	r2, [r3, #12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:17
    m_cursor.y = 0;
    8e1c:	e51b3008 	ldr	r3, [fp, #-8]
    8e20:	e3a02000 	mov	r2, #0
    8e24:	e583200c 	str	r2, [r3, #12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:18
}
    8e28:	e320f000 	nop	{0}
    8e2c:	e28bd000 	add	sp, fp, #0
    8e30:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8e34:	e12fff1e 	bx	lr

00008e38 <_ZN8CMonitor13Adjust_CursorEv>:
_ZN8CMonitor13Adjust_CursorEv():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:34
{
    8e38:	e92d4800 	push	{fp, lr}
    8e3c:	e28db004 	add	fp, sp, #4
    8e40:	e24dd008 	sub	sp, sp, #8
    8e44:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:35
    if (m_cursor.x >= m_width)
    8e48:	e51b3008 	ldr	r3, [fp, #-8]
    8e4c:	e5932010 	ldr	r2, [r3, #16]
    8e50:	e51b3008 	ldr	r3, [fp, #-8]
    8e54:	e5933004 	ldr	r3, [r3, #4]
    8e58:	e1520003 	cmp	r2, r3
    8e5c:	3a000007 	bcc	8e80 <_ZN8CMonitor13Adjust_CursorEv+0x48>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:37
        m_cursor.x = 0;
    8e60:	e51b3008 	ldr	r3, [fp, #-8]
    8e64:	e3a02000 	mov	r2, #0
    8e68:	e5832010 	str	r2, [r3, #16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:38
        ++m_cursor.y;
    8e6c:	e51b3008 	ldr	r3, [fp, #-8]
    8e70:	e593300c 	ldr	r3, [r3, #12]
    8e74:	e2832001 	add	r2, r3, #1
    8e78:	e51b3008 	ldr	r3, [fp, #-8]
    8e7c:	e583200c 	str	r2, [r3, #12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:41
    if (m_cursor.y >= m_height)
    8e80:	e51b3008 	ldr	r3, [fp, #-8]
    8e84:	e593200c 	ldr	r2, [r3, #12]
    8e88:	e51b3008 	ldr	r3, [fp, #-8]
    8e8c:	e5933008 	ldr	r3, [r3, #8]
    8e90:	e1520003 	cmp	r2, r3
    8e94:	3a000006 	bcc	8eb4 <_ZN8CMonitor13Adjust_CursorEv+0x7c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:43
        Scroll();
    8e98:	e51b0008 	ldr	r0, [fp, #-8]
    8e9c:	ebfffe8d 	bl	88d8 <_ZN8CMonitor6ScrollEv>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:44
        m_cursor.y = m_height - 1;
    8ea0:	e51b3008 	ldr	r3, [fp, #-8]
    8ea4:	e5933008 	ldr	r3, [r3, #8]
    8ea8:	e2432001 	sub	r2, r3, #1
    8eac:	e51b3008 	ldr	r3, [fp, #-8]
    8eb0:	e583200c 	str	r2, [r3, #12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:46
}
    8eb4:	e320f000 	nop	{0}
    8eb8:	e24bd004 	sub	sp, fp, #4
    8ebc:	e8bd8800 	pop	{fp, pc}

00008ec0 <_ZN8CMonitor17Reset_Number_BaseEv>:
_ZN8CMonitor17Reset_Number_BaseEv():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:65
{
    8ec0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8ec4:	e28db000 	add	fp, sp, #0
    8ec8:	e24dd00c 	sub	sp, sp, #12
    8ecc:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:66
    m_number_base = DEFAULT_NUMBER_BASE;
    8ed0:	e51b3008 	ldr	r3, [fp, #-8]
    8ed4:	e3a0200a 	mov	r2, #10
    8ed8:	e5832014 	str	r2, [r3, #20]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/monitor.cpp:67
}
    8edc:	e320f000 	nop	{0}
    8ee0:	e28bd000 	add	sp, fp, #0
    8ee4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8ee8:	e12fff1e 	bx	lr

00008eec <_ZN5CUARTC1ER4CAUX>:
_ZN5CUARTC2ER4CAUX():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/uart.cpp:7
#include <drivers/bcm_aux.h>
#include <drivers/monitor.h>

CUART sUART0(sAUX);

CUART::CUART(CAUX& aux)
    8eec:	e92d4800 	push	{fp, lr}
    8ef0:	e28db004 	add	fp, sp, #4
    8ef4:	e24dd008 	sub	sp, sp, #8
    8ef8:	e50b0008 	str	r0, [fp, #-8]
    8efc:	e50b100c 	str	r1, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/uart.cpp:8
: mAUX(aux)
    8f00:	e51b3008 	ldr	r3, [fp, #-8]
    8f04:	e51b200c 	ldr	r2, [fp, #-12]
    8f08:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/uart.cpp:10
{
    mAUX.Enable(hal::AUX_Peripherals::MiniUART);
    8f0c:	e51b3008 	ldr	r3, [fp, #-8]
    8f10:	e5933000 	ldr	r3, [r3]
    8f14:	e3a01000 	mov	r1, #0
    8f18:	e1a00003 	mov	r0, r3
    8f1c:	ebfffc80 	bl	8124 <_ZN4CAUX6EnableEN3hal15AUX_PeripheralsE>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/uart.cpp:12
    // mAUX.Set_Register(hal::AUX_Reg::ENABLES, mAUX.Get_Register(hal::AUX_Reg::ENABLES) | 0x01);
    mAUX.Set_Register(hal::AUX_Reg::MU_IIR, 0);
    8f20:	e51b3008 	ldr	r3, [fp, #-8]
    8f24:	e5933000 	ldr	r3, [r3]
    8f28:	e3a02000 	mov	r2, #0
    8f2c:	e3a01012 	mov	r1, #18
    8f30:	e1a00003 	mov	r0, r3
    8f34:	ebfffca3 	bl	81c8 <_ZN4CAUX12Set_RegisterEN3hal7AUX_RegEj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/uart.cpp:13
    mAUX.Set_Register(hal::AUX_Reg::MU_IER, 0);
    8f38:	e51b3008 	ldr	r3, [fp, #-8]
    8f3c:	e5933000 	ldr	r3, [r3]
    8f40:	e3a02000 	mov	r2, #0
    8f44:	e3a01011 	mov	r1, #17
    8f48:	e1a00003 	mov	r0, r3
    8f4c:	ebfffc9d 	bl	81c8 <_ZN4CAUX12Set_RegisterEN3hal7AUX_RegEj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/uart.cpp:14
    mAUX.Set_Register(hal::AUX_Reg::MU_MCR, 0);
    8f50:	e51b3008 	ldr	r3, [fp, #-8]
    8f54:	e5933000 	ldr	r3, [r3]
    8f58:	e3a02000 	mov	r2, #0
    8f5c:	e3a01014 	mov	r1, #20
    8f60:	e1a00003 	mov	r0, r3
    8f64:	ebfffc97 	bl	81c8 <_ZN4CAUX12Set_RegisterEN3hal7AUX_RegEj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/uart.cpp:15
    mAUX.Set_Register(hal::AUX_Reg::MU_CNTL, 3); // RX and TX enabled
    8f68:	e51b3008 	ldr	r3, [fp, #-8]
    8f6c:	e5933000 	ldr	r3, [r3]
    8f70:	e3a02003 	mov	r2, #3
    8f74:	e3a01018 	mov	r1, #24
    8f78:	e1a00003 	mov	r0, r3
    8f7c:	ebfffc91 	bl	81c8 <_ZN4CAUX12Set_RegisterEN3hal7AUX_RegEj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/uart.cpp:16
}
    8f80:	e51b3008 	ldr	r3, [fp, #-8]
    8f84:	e1a00003 	mov	r0, r3
    8f88:	e24bd004 	sub	sp, fp, #4
    8f8c:	e8bd8800 	pop	{fp, pc}

00008f90 <_ZN5CUART15Set_Char_LengthE17NUART_Char_Length>:
_ZN5CUART15Set_Char_LengthE17NUART_Char_Length():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/uart.cpp:19

void CUART::Set_Char_Length(NUART_Char_Length len)
{
    8f90:	e92d4810 	push	{r4, fp, lr}
    8f94:	e28db008 	add	fp, sp, #8
    8f98:	e24dd00c 	sub	sp, sp, #12
    8f9c:	e50b0010 	str	r0, [fp, #-16]
    8fa0:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/uart.cpp:20
    mAUX.Set_Register(hal::AUX_Reg::MU_LCR,
    8fa4:	e51b3010 	ldr	r3, [fp, #-16]
    8fa8:	e5934000 	ldr	r4, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/uart.cpp:21
                      (mAUX.Get_Register(hal::AUX_Reg::MU_LCR) & 0xFFFFFFFE) | static_cast<unsigned int>(len));
    8fac:	e51b3010 	ldr	r3, [fp, #-16]
    8fb0:	e5933000 	ldr	r3, [r3]
    8fb4:	e3a01013 	mov	r1, #19
    8fb8:	e1a00003 	mov	r0, r3
    8fbc:	ebfffc92 	bl	820c <_ZN4CAUX12Get_RegisterEN3hal7AUX_RegE>
    8fc0:	e1a03000 	mov	r3, r0
    8fc4:	e3c32001 	bic	r2, r3, #1
    8fc8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/uart.cpp:20
    mAUX.Set_Register(hal::AUX_Reg::MU_LCR,
    8fcc:	e1823003 	orr	r3, r2, r3
    8fd0:	e1a02003 	mov	r2, r3
    8fd4:	e3a01013 	mov	r1, #19
    8fd8:	e1a00004 	mov	r0, r4
    8fdc:	ebfffc79 	bl	81c8 <_ZN4CAUX12Set_RegisterEN3hal7AUX_RegEj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/uart.cpp:22
}
    8fe0:	e320f000 	nop	{0}
    8fe4:	e24bd008 	sub	sp, fp, #8
    8fe8:	e8bd8810 	pop	{r4, fp, pc}

00008fec <_ZN5CUART13Set_Baud_RateE15NUART_Baud_Rate>:
_ZN5CUART13Set_Baud_RateE15NUART_Baud_Rate():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/uart.cpp:25

void CUART::Set_Baud_Rate(NUART_Baud_Rate rate)
{
    8fec:	e92d4800 	push	{fp, lr}
    8ff0:	e28db004 	add	fp, sp, #4
    8ff4:	e24dd010 	sub	sp, sp, #16
    8ff8:	e50b0010 	str	r0, [fp, #-16]
    8ffc:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/uart.cpp:26
    constexpr unsigned int Clock_Rate = 250000000; // taktovaci frekvence hlavniho jadra
    9000:	e59f3070 	ldr	r3, [pc, #112]	; 9078 <_ZN5CUART13Set_Baud_RateE15NUART_Baud_Rate+0x8c>
    9004:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/uart.cpp:27
    const unsigned int val = ((Clock_Rate / static_cast<unsigned int>(rate)) / 8) - 1;
    9008:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    900c:	e1a01003 	mov	r1, r3
    9010:	e59f0064 	ldr	r0, [pc, #100]	; 907c <_ZN5CUART13Set_Baud_RateE15NUART_Baud_Rate+0x90>
    9014:	eb0000d4 	bl	936c <__udivsi3>
    9018:	e1a03000 	mov	r3, r0
    901c:	e2433001 	sub	r3, r3, #1
    9020:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/uart.cpp:29

    mAUX.Set_Register(hal::AUX_Reg::MU_CNTL, 0);
    9024:	e51b3010 	ldr	r3, [fp, #-16]
    9028:	e5933000 	ldr	r3, [r3]
    902c:	e3a02000 	mov	r2, #0
    9030:	e3a01018 	mov	r1, #24
    9034:	e1a00003 	mov	r0, r3
    9038:	ebfffc62 	bl	81c8 <_ZN4CAUX12Set_RegisterEN3hal7AUX_RegEj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/uart.cpp:31

    mAUX.Set_Register(hal::AUX_Reg::MU_BAUD, val);
    903c:	e51b3010 	ldr	r3, [fp, #-16]
    9040:	e5933000 	ldr	r3, [r3]
    9044:	e51b200c 	ldr	r2, [fp, #-12]
    9048:	e3a0101a 	mov	r1, #26
    904c:	e1a00003 	mov	r0, r3
    9050:	ebfffc5c 	bl	81c8 <_ZN4CAUX12Set_RegisterEN3hal7AUX_RegEj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/uart.cpp:33

    mAUX.Set_Register(hal::AUX_Reg::MU_CNTL, 3);
    9054:	e51b3010 	ldr	r3, [fp, #-16]
    9058:	e5933000 	ldr	r3, [r3]
    905c:	e3a02003 	mov	r2, #3
    9060:	e3a01018 	mov	r1, #24
    9064:	e1a00003 	mov	r0, r3
    9068:	ebfffc56 	bl	81c8 <_ZN4CAUX12Set_RegisterEN3hal7AUX_RegEj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/uart.cpp:34
}
    906c:	e320f000 	nop	{0}
    9070:	e24bd004 	sub	sp, fp, #4
    9074:	e8bd8800 	pop	{fp, pc}
    9078:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}
    907c:	01dcd650 	bicseq	sp, ip, r0, asr r6

00009080 <_ZN5CUART5WriteEc>:
_ZN5CUART5WriteEc():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/uart.cpp:37

void CUART::Write(char c)
{
    9080:	e92d4800 	push	{fp, lr}
    9084:	e28db004 	add	fp, sp, #4
    9088:	e24dd010 	sub	sp, sp, #16
    908c:	e50b0010 	str	r0, [fp, #-16]
    9090:	e1a03001 	mov	r3, r1
    9094:	e54b3011 	strb	r3, [fp, #-17]	; 0xffffffef
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/uart.cpp:38
    unsigned int value = (mAUX.Get_Register(hal::AUX_Reg::MU_LSR) & (1 << 5));
    9098:	e51b3010 	ldr	r3, [fp, #-16]
    909c:	e5933000 	ldr	r3, [r3]
    90a0:	e3a01015 	mov	r1, #21
    90a4:	e1a00003 	mov	r0, r3
    90a8:	ebfffc57 	bl	820c <_ZN4CAUX12Get_RegisterEN3hal7AUX_RegE>
    90ac:	e1a03000 	mov	r3, r0
    90b0:	e2033020 	and	r3, r3, #32
    90b4:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/uart.cpp:41

    // dokud ma status registr priznak "vystupni fronta plna", nelze prenaset dalsi bit
    while (!value)
    90b8:	e51b3008 	ldr	r3, [fp, #-8]
    90bc:	e3530000 	cmp	r3, #0
    90c0:	1a000008 	bne	90e8 <_ZN5CUART5WriteEc+0x68>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/uart.cpp:43
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
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/uart.cpp:41
    while (!value)
    90e4:	eafffff3 	b	90b8 <_ZN5CUART5WriteEc+0x38>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/uart.cpp:47
        // sMonitor << value << '\n';
    }

    mAUX.Set_Register(hal::AUX_Reg::MU_IO, c);
    90e8:	e51b3010 	ldr	r3, [fp, #-16]
    90ec:	e5933000 	ldr	r3, [r3]
    90f0:	e55b2011 	ldrb	r2, [fp, #-17]	; 0xffffffef
    90f4:	e3a01010 	mov	r1, #16
    90f8:	e1a00003 	mov	r0, r3
    90fc:	ebfffc31 	bl	81c8 <_ZN4CAUX12Set_RegisterEN3hal7AUX_RegEj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/uart.cpp:48
}
    9100:	e320f000 	nop	{0}
    9104:	e24bd004 	sub	sp, fp, #4
    9108:	e8bd8800 	pop	{fp, pc}

0000910c <_ZN5CUART5WriteEPKc>:
_ZN5CUART5WriteEPKc():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/uart.cpp:51

void CUART::Write(const char* str)
{
    910c:	e92d4800 	push	{fp, lr}
    9110:	e28db004 	add	fp, sp, #4
    9114:	e24dd010 	sub	sp, sp, #16
    9118:	e50b0010 	str	r0, [fp, #-16]
    911c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/uart.cpp:54
    int i;

    for (i = 0; str[i] != '\0'; i++)
    9120:	e3a03000 	mov	r3, #0
    9124:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/uart.cpp:54 (discriminator 3)
    9128:	e51b3008 	ldr	r3, [fp, #-8]
    912c:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    9130:	e0823003 	add	r3, r2, r3
    9134:	e5d33000 	ldrb	r3, [r3]
    9138:	e3530000 	cmp	r3, #0
    913c:	0a00000a 	beq	916c <_ZN5CUART5WriteEPKc+0x60>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/uart.cpp:55 (discriminator 2)
        Write(str[i]);
    9140:	e51b3008 	ldr	r3, [fp, #-8]
    9144:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    9148:	e0823003 	add	r3, r2, r3
    914c:	e5d33000 	ldrb	r3, [r3]
    9150:	e1a01003 	mov	r1, r3
    9154:	e51b0010 	ldr	r0, [fp, #-16]
    9158:	ebffffc8 	bl	9080 <_ZN5CUART5WriteEc>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/uart.cpp:54 (discriminator 2)
    for (i = 0; str[i] != '\0'; i++)
    915c:	e51b3008 	ldr	r3, [fp, #-8]
    9160:	e2833001 	add	r3, r3, #1
    9164:	e50b3008 	str	r3, [fp, #-8]
    9168:	eaffffee 	b	9128 <_ZN5CUART5WriteEPKc+0x1c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/uart.cpp:56
    916c:	e320f000 	nop	{0}
    9170:	e24bd004 	sub	sp, fp, #4
    9174:	e8bd8800 	pop	{fp, pc}

00009178 <_Z41__static_initialization_and_destruction_0ii>:
_Z41__static_initialization_and_destruction_0ii():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/uart.cpp:56
    9178:	e92d4800 	push	{fp, lr}
    917c:	e28db004 	add	fp, sp, #4
    9180:	e24dd008 	sub	sp, sp, #8
    9184:	e50b0008 	str	r0, [fp, #-8]
    9188:	e50b100c 	str	r1, [fp, #-12]
    918c:	e51b3008 	ldr	r3, [fp, #-8]
    9190:	e3530001 	cmp	r3, #1
    9194:	1a000006 	bne	91b4 <_Z41__static_initialization_and_destruction_0ii+0x3c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/uart.cpp:56 (discriminator 1)
    9198:	e51b300c 	ldr	r3, [fp, #-12]
    919c:	e59f201c 	ldr	r2, [pc, #28]	; 91c0 <_Z41__static_initialization_and_destruction_0ii+0x48>
    91a0:	e1530002 	cmp	r3, r2
    91a4:	1a000002 	bne	91b4 <_Z41__static_initialization_and_destruction_0ii+0x3c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/uart.cpp:5
CUART sUART0(sAUX);
    91a8:	e59f1014 	ldr	r1, [pc, #20]	; 91c4 <_Z41__static_initialization_and_destruction_0ii+0x4c>
    91ac:	e59f0014 	ldr	r0, [pc, #20]	; 91c8 <_Z41__static_initialization_and_destruction_0ii+0x50>
    91b0:	ebffff4d 	bl	8eec <_ZN5CUARTC1ER4CAUX>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/uart.cpp:56
    91b4:	e320f000 	nop	{0}
    91b8:	e24bd004 	sub	sp, fp, #4
    91bc:	e8bd8800 	pop	{fp, pc}
    91c0:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>
    91c4:	000096d8 	ldrdeq	r9, [r0], -r8
    91c8:	00009708 	andeq	r9, r0, r8, lsl #14

000091cc <_GLOBAL__sub_I_sUART0>:
_GLOBAL__sub_I_sUART0():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/uart.cpp:56
    91cc:	e92d4800 	push	{fp, lr}
    91d0:	e28db004 	add	fp, sp, #4
    91d4:	e59f1008 	ldr	r1, [pc, #8]	; 91e4 <_GLOBAL__sub_I_sUART0+0x18>
    91d8:	e3a00001 	mov	r0, #1
    91dc:	ebffffe5 	bl	9178 <_Z41__static_initialization_and_destruction_0ii>
    91e0:	e8bd8800 	pop	{fp, pc}
    91e4:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>

000091e8 <_kernel_main>:
_kernel_main():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/main.cpp:6
#include <drivers/gpio.h>
#include <drivers/uart.h>
#include <drivers/monitor.h>

extern "C" int _kernel_main(void)
{
    91e8:	e92d4800 	push	{fp, lr}
    91ec:	e28db004 	add	fp, sp, #4
    91f0:	e24dd008 	sub	sp, sp, #8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/main.cpp:8
    // inicializujeme UART kanal 0
    sUART0.Set_Baud_Rate(NUART_Baud_Rate::BR_9600);
    91f4:	e3a01d96 	mov	r1, #9600	; 0x2580
    91f8:	e59f004c 	ldr	r0, [pc, #76]	; 924c <_kernel_main+0x64>
    91fc:	ebffff7a 	bl	8fec <_ZN5CUART13Set_Baud_RateE15NUART_Baud_Rate>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/main.cpp:9
    sUART0.Set_Char_Length(NUART_Char_Length::Char_8);
    9200:	e3a01001 	mov	r1, #1
    9204:	e59f0040 	ldr	r0, [pc, #64]	; 924c <_kernel_main+0x64>
    9208:	ebffff60 	bl	8f90 <_ZN5CUART15Set_Char_LengthE17NUART_Char_Length>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/main.cpp:15

    volatile unsigned int tim;

    while (1)
    {
        sUART0.Write("Welcome to KIV/OS RPiOS kernel\r\n");
    920c:	e59f103c 	ldr	r1, [pc, #60]	; 9250 <_kernel_main+0x68>
    9210:	e59f0034 	ldr	r0, [pc, #52]	; 924c <_kernel_main+0x64>
    9214:	ebffffbc 	bl	910c <_ZN5CUART5WriteEPKc>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/main.cpp:17
        
        for (tim = 0; tim < 0x100; tim++)
    9218:	e3a03000 	mov	r3, #0
    921c:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/main.cpp:17 (discriminator 3)
    9220:	e51b3008 	ldr	r3, [fp, #-8]
    9224:	e35300ff 	cmp	r3, #255	; 0xff
    9228:	93a03001 	movls	r3, #1
    922c:	83a03000 	movhi	r3, #0
    9230:	e6ef3073 	uxtb	r3, r3
    9234:	e3530000 	cmp	r3, #0
    9238:	0afffff3 	beq	920c <_kernel_main+0x24>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/main.cpp:17 (discriminator 2)
    923c:	e51b3008 	ldr	r3, [fp, #-8]
    9240:	e2833001 	add	r3, r3, #1
    9244:	e50b3008 	str	r3, [fp, #-8]
    9248:	eafffff4 	b	9220 <_kernel_main+0x38>
    924c:	00009708 	andeq	r9, r0, r8, lsl #14
    9250:	000096a4 	andeq	r9, r0, r4, lsr #13

00009254 <_c_startup>:
_c_startup():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/startup.cpp:21
extern "C" dtor_ptr __DTOR_LIST__[0];
// konec pole destruktoru
extern "C" dtor_ptr __DTOR_END__[0];

extern "C" int _c_startup(void)
{
    9254:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9258:	e28db000 	add	fp, sp, #0
    925c:	e24dd00c 	sub	sp, sp, #12
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/startup.cpp:25
    int* i;

    // vynulujeme .bss sekci
    for (i = (int*)_bss_start; i < (int*)_bss_end; i++)
    9260:	e59f304c 	ldr	r3, [pc, #76]	; 92b4 <_c_startup+0x60>
    9264:	e5933000 	ldr	r3, [r3]
    9268:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/startup.cpp:25 (discriminator 3)
    926c:	e59f3044 	ldr	r3, [pc, #68]	; 92b8 <_c_startup+0x64>
    9270:	e5933000 	ldr	r3, [r3]
    9274:	e1a02003 	mov	r2, r3
    9278:	e51b3008 	ldr	r3, [fp, #-8]
    927c:	e1530002 	cmp	r3, r2
    9280:	2a000006 	bcs	92a0 <_c_startup+0x4c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/startup.cpp:26 (discriminator 2)
        *i = 0;
    9284:	e51b3008 	ldr	r3, [fp, #-8]
    9288:	e3a02000 	mov	r2, #0
    928c:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/startup.cpp:25 (discriminator 2)
    for (i = (int*)_bss_start; i < (int*)_bss_end; i++)
    9290:	e51b3008 	ldr	r3, [fp, #-8]
    9294:	e2833004 	add	r3, r3, #4
    9298:	e50b3008 	str	r3, [fp, #-8]
    929c:	eafffff2 	b	926c <_c_startup+0x18>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/startup.cpp:28

    return 0;
    92a0:	e3a03000 	mov	r3, #0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/startup.cpp:29
}
    92a4:	e1a00003 	mov	r0, r3
    92a8:	e28bd000 	add	sp, fp, #0
    92ac:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    92b0:	e12fff1e 	bx	lr
    92b4:	000096d8 	ldrdeq	r9, [r0], -r8
    92b8:	0000971c 	andeq	r9, r0, ip, lsl r7

000092bc <_cpp_startup>:
_cpp_startup():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/startup.cpp:32

extern "C" int _cpp_startup(void)
{
    92bc:	e92d4800 	push	{fp, lr}
    92c0:	e28db004 	add	fp, sp, #4
    92c4:	e24dd008 	sub	sp, sp, #8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/startup.cpp:37
    ctor_ptr* fnptr;

    // zavolame konstruktory globalnich C++ trid
    // v poli __CTOR_LIST__ jsou ukazatele na vygenerovane stuby volani konstruktoru
    for (fnptr = __CTOR_LIST__; fnptr < __CTOR_END__; fnptr++)
    92c8:	e59f303c 	ldr	r3, [pc, #60]	; 930c <_cpp_startup+0x50>
    92cc:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/startup.cpp:37 (discriminator 3)
    92d0:	e51b3008 	ldr	r3, [fp, #-8]
    92d4:	e59f2034 	ldr	r2, [pc, #52]	; 9310 <_cpp_startup+0x54>
    92d8:	e1530002 	cmp	r3, r2
    92dc:	2a000006 	bcs	92fc <_cpp_startup+0x40>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/startup.cpp:38 (discriminator 2)
        (*fnptr)();
    92e0:	e51b3008 	ldr	r3, [fp, #-8]
    92e4:	e5933000 	ldr	r3, [r3]
    92e8:	e12fff33 	blx	r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/startup.cpp:37 (discriminator 2)
    for (fnptr = __CTOR_LIST__; fnptr < __CTOR_END__; fnptr++)
    92ec:	e51b3008 	ldr	r3, [fp, #-8]
    92f0:	e2833004 	add	r3, r3, #4
    92f4:	e50b3008 	str	r3, [fp, #-8]
    92f8:	eafffff4 	b	92d0 <_cpp_startup+0x14>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/startup.cpp:40

    return 0;
    92fc:	e3a03000 	mov	r3, #0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/startup.cpp:41
}
    9300:	e1a00003 	mov	r0, r3
    9304:	e24bd004 	sub	sp, fp, #4
    9308:	e8bd8800 	pop	{fp, pc}
    930c:	000096c8 	andeq	r9, r0, r8, asr #13
    9310:	000096d8 	ldrdeq	r9, [r0], -r8

00009314 <_cpp_shutdown>:
_cpp_shutdown():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/startup.cpp:44

extern "C" int _cpp_shutdown(void)
{
    9314:	e92d4800 	push	{fp, lr}
    9318:	e28db004 	add	fp, sp, #4
    931c:	e24dd008 	sub	sp, sp, #8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/startup.cpp:48
    dtor_ptr* fnptr;

    // zavolame destruktory globalnich C++ trid
    for (fnptr = __DTOR_LIST__; fnptr < __DTOR_END__; fnptr++)
    9320:	e59f303c 	ldr	r3, [pc, #60]	; 9364 <_cpp_shutdown+0x50>
    9324:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/startup.cpp:48 (discriminator 3)
    9328:	e51b3008 	ldr	r3, [fp, #-8]
    932c:	e59f2034 	ldr	r2, [pc, #52]	; 9368 <_cpp_shutdown+0x54>
    9330:	e1530002 	cmp	r3, r2
    9334:	2a000006 	bcs	9354 <_cpp_shutdown+0x40>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/startup.cpp:49 (discriminator 2)
        (*fnptr)();
    9338:	e51b3008 	ldr	r3, [fp, #-8]
    933c:	e5933000 	ldr	r3, [r3]
    9340:	e12fff33 	blx	r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/startup.cpp:48 (discriminator 2)
    for (fnptr = __DTOR_LIST__; fnptr < __DTOR_END__; fnptr++)
    9344:	e51b3008 	ldr	r3, [fp, #-8]
    9348:	e2833004 	add	r3, r3, #4
    934c:	e50b3008 	str	r3, [fp, #-8]
    9350:	eafffff4 	b	9328 <_cpp_shutdown+0x14>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/startup.cpp:51

    return 0;
    9354:	e3a03000 	mov	r3, #0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/startup.cpp:52
}
    9358:	e1a00003 	mov	r0, r3
    935c:	e24bd004 	sub	sp, fp, #4
    9360:	e8bd8800 	pop	{fp, pc}
    9364:	000096d8 	ldrdeq	r9, [r0], -r8
    9368:	000096d8 	ldrdeq	r9, [r0], -r8

0000936c <__udivsi3>:
__udivsi3():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1104
    936c:	e2512001 	subs	r2, r1, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1106
    9370:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1107
    9374:	3a000074 	bcc	954c <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1108
    9378:	e1500001 	cmp	r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1109
    937c:	9a00006b 	bls	9530 <__udivsi3+0x1c4>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1110
    9380:	e1110002 	tst	r1, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1111
    9384:	0a00006c 	beq	953c <__udivsi3+0x1d0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1113
    9388:	e16f3f10 	clz	r3, r0
    938c:	e16f2f11 	clz	r2, r1
    9390:	e0423003 	sub	r3, r2, r3
    9394:	e273301f 	rsbs	r3, r3, #31
    9398:	10833083 	addne	r3, r3, r3, lsl #1
    939c:	e3a02000 	mov	r2, #0
    93a0:	108ff103 	addne	pc, pc, r3, lsl #2
    93a4:	e1a00000 	nop			; (mov r0, r0)
    93a8:	e1500f81 	cmp	r0, r1, lsl #31
    93ac:	e0a22002 	adc	r2, r2, r2
    93b0:	20400f81 	subcs	r0, r0, r1, lsl #31
    93b4:	e1500f01 	cmp	r0, r1, lsl #30
    93b8:	e0a22002 	adc	r2, r2, r2
    93bc:	20400f01 	subcs	r0, r0, r1, lsl #30
    93c0:	e1500e81 	cmp	r0, r1, lsl #29
    93c4:	e0a22002 	adc	r2, r2, r2
    93c8:	20400e81 	subcs	r0, r0, r1, lsl #29
    93cc:	e1500e01 	cmp	r0, r1, lsl #28
    93d0:	e0a22002 	adc	r2, r2, r2
    93d4:	20400e01 	subcs	r0, r0, r1, lsl #28
    93d8:	e1500d81 	cmp	r0, r1, lsl #27
    93dc:	e0a22002 	adc	r2, r2, r2
    93e0:	20400d81 	subcs	r0, r0, r1, lsl #27
    93e4:	e1500d01 	cmp	r0, r1, lsl #26
    93e8:	e0a22002 	adc	r2, r2, r2
    93ec:	20400d01 	subcs	r0, r0, r1, lsl #26
    93f0:	e1500c81 	cmp	r0, r1, lsl #25
    93f4:	e0a22002 	adc	r2, r2, r2
    93f8:	20400c81 	subcs	r0, r0, r1, lsl #25
    93fc:	e1500c01 	cmp	r0, r1, lsl #24
    9400:	e0a22002 	adc	r2, r2, r2
    9404:	20400c01 	subcs	r0, r0, r1, lsl #24
    9408:	e1500b81 	cmp	r0, r1, lsl #23
    940c:	e0a22002 	adc	r2, r2, r2
    9410:	20400b81 	subcs	r0, r0, r1, lsl #23
    9414:	e1500b01 	cmp	r0, r1, lsl #22
    9418:	e0a22002 	adc	r2, r2, r2
    941c:	20400b01 	subcs	r0, r0, r1, lsl #22
    9420:	e1500a81 	cmp	r0, r1, lsl #21
    9424:	e0a22002 	adc	r2, r2, r2
    9428:	20400a81 	subcs	r0, r0, r1, lsl #21
    942c:	e1500a01 	cmp	r0, r1, lsl #20
    9430:	e0a22002 	adc	r2, r2, r2
    9434:	20400a01 	subcs	r0, r0, r1, lsl #20
    9438:	e1500981 	cmp	r0, r1, lsl #19
    943c:	e0a22002 	adc	r2, r2, r2
    9440:	20400981 	subcs	r0, r0, r1, lsl #19
    9444:	e1500901 	cmp	r0, r1, lsl #18
    9448:	e0a22002 	adc	r2, r2, r2
    944c:	20400901 	subcs	r0, r0, r1, lsl #18
    9450:	e1500881 	cmp	r0, r1, lsl #17
    9454:	e0a22002 	adc	r2, r2, r2
    9458:	20400881 	subcs	r0, r0, r1, lsl #17
    945c:	e1500801 	cmp	r0, r1, lsl #16
    9460:	e0a22002 	adc	r2, r2, r2
    9464:	20400801 	subcs	r0, r0, r1, lsl #16
    9468:	e1500781 	cmp	r0, r1, lsl #15
    946c:	e0a22002 	adc	r2, r2, r2
    9470:	20400781 	subcs	r0, r0, r1, lsl #15
    9474:	e1500701 	cmp	r0, r1, lsl #14
    9478:	e0a22002 	adc	r2, r2, r2
    947c:	20400701 	subcs	r0, r0, r1, lsl #14
    9480:	e1500681 	cmp	r0, r1, lsl #13
    9484:	e0a22002 	adc	r2, r2, r2
    9488:	20400681 	subcs	r0, r0, r1, lsl #13
    948c:	e1500601 	cmp	r0, r1, lsl #12
    9490:	e0a22002 	adc	r2, r2, r2
    9494:	20400601 	subcs	r0, r0, r1, lsl #12
    9498:	e1500581 	cmp	r0, r1, lsl #11
    949c:	e0a22002 	adc	r2, r2, r2
    94a0:	20400581 	subcs	r0, r0, r1, lsl #11
    94a4:	e1500501 	cmp	r0, r1, lsl #10
    94a8:	e0a22002 	adc	r2, r2, r2
    94ac:	20400501 	subcs	r0, r0, r1, lsl #10
    94b0:	e1500481 	cmp	r0, r1, lsl #9
    94b4:	e0a22002 	adc	r2, r2, r2
    94b8:	20400481 	subcs	r0, r0, r1, lsl #9
    94bc:	e1500401 	cmp	r0, r1, lsl #8
    94c0:	e0a22002 	adc	r2, r2, r2
    94c4:	20400401 	subcs	r0, r0, r1, lsl #8
    94c8:	e1500381 	cmp	r0, r1, lsl #7
    94cc:	e0a22002 	adc	r2, r2, r2
    94d0:	20400381 	subcs	r0, r0, r1, lsl #7
    94d4:	e1500301 	cmp	r0, r1, lsl #6
    94d8:	e0a22002 	adc	r2, r2, r2
    94dc:	20400301 	subcs	r0, r0, r1, lsl #6
    94e0:	e1500281 	cmp	r0, r1, lsl #5
    94e4:	e0a22002 	adc	r2, r2, r2
    94e8:	20400281 	subcs	r0, r0, r1, lsl #5
    94ec:	e1500201 	cmp	r0, r1, lsl #4
    94f0:	e0a22002 	adc	r2, r2, r2
    94f4:	20400201 	subcs	r0, r0, r1, lsl #4
    94f8:	e1500181 	cmp	r0, r1, lsl #3
    94fc:	e0a22002 	adc	r2, r2, r2
    9500:	20400181 	subcs	r0, r0, r1, lsl #3
    9504:	e1500101 	cmp	r0, r1, lsl #2
    9508:	e0a22002 	adc	r2, r2, r2
    950c:	20400101 	subcs	r0, r0, r1, lsl #2
    9510:	e1500081 	cmp	r0, r1, lsl #1
    9514:	e0a22002 	adc	r2, r2, r2
    9518:	20400081 	subcs	r0, r0, r1, lsl #1
    951c:	e1500001 	cmp	r0, r1
    9520:	e0a22002 	adc	r2, r2, r2
    9524:	20400001 	subcs	r0, r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1115
    9528:	e1a00002 	mov	r0, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1116
    952c:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1119
    9530:	03a00001 	moveq	r0, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1120
    9534:	13a00000 	movne	r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1121
    9538:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1123
    953c:	e16f2f11 	clz	r2, r1
    9540:	e262201f 	rsb	r2, r2, #31
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1125
    9544:	e1a00230 	lsr	r0, r0, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1126
    9548:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1130
    954c:	e3500000 	cmp	r0, #0
    9550:	13e00000 	mvnne	r0, #0
    9554:	ea000007 	b	9578 <__aeabi_idiv0>

00009558 <__aeabi_uidivmod>:
__aeabi_uidivmod():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1161
    9558:	e3510000 	cmp	r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1162
    955c:	0afffffa 	beq	954c <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1163
    9560:	e92d4003 	push	{r0, r1, lr}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1164
    9564:	ebffff80 	bl	936c <__udivsi3>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1165
    9568:	e8bd4006 	pop	{r1, r2, lr}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1166
    956c:	e0030092 	mul	r3, r2, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1167
    9570:	e0411003 	sub	r1, r1, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1168
    9574:	e12fff1e 	bx	lr

00009578 <__aeabi_idiv0>:
__aeabi_ldiv0():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1466
    9578:	e12fff1e 	bx	lr

Disassembly of section .ARM.extab:

0000957c <.ARM.extab>:
    957c:	81019b40 	tsthi	r1, r0, asr #22
    9580:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    9584:	00000000 	andeq	r0, r0, r0
    9588:	81019b41 	tsthi	r1, r1, asr #22
    958c:	8481b0b0 	strhi	fp, [r1], #176	; 0xb0
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
    95d0:	81019b40 	tsthi	r1, r0, asr #22
    95d4:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    95d8:	00000000 	andeq	r0, r0, r0

Disassembly of section .ARM.exidx:

000095dc <.ARM.exidx>:
    95dc:	7fffea3c 	svcvc	0x00ffea3c
    95e0:	00000001 	andeq	r0, r0, r1
    95e4:	7ffff908 	svcvc	0x00fff908
    95e8:	7fffff94 	svcvc	0x00ffff94
    95ec:	7ffff9a4 	svcvc	0x00fff9a4
    95f0:	7fffff98 	svcvc	0x00ffff98
    95f4:	7ffff9f8 	svcvc	0x00fff9f8
    95f8:	7fffff9c 	svcvc	0x00ffff9c
    95fc:	7ffffa84 	svcvc	0x00fffa84
    9600:	7fffffa0 	svcvc	0x00ffffa0
    9604:	7ffffb08 	svcvc	0x00fffb08
    9608:	7fffffa4 	svcvc	0x00ffffa4
    960c:	7ffffb6c 	svcvc	0x00fffb6c
    9610:	00000001 	andeq	r0, r0, r1
    9614:	7ffffbd4 	svcvc	0x00fffbd4
    9618:	7fffffa0 	svcvc	0x00ffffa0
    961c:	7ffffc38 	svcvc	0x00fffc38
    9620:	00000001 	andeq	r0, r0, r1
    9624:	7ffffc98 	svcvc	0x00fffc98
    9628:	7fffff9c 	svcvc	0x00ffff9c
    962c:	7ffffce8 	svcvc	0x00fffce8
    9630:	7fffffa0 	svcvc	0x00ffffa0
    9634:	7ffffd38 	svcvc	0x00fffd38
    9638:	00000001 	andeq	r0, r0, r1

Disassembly of section .rodata:

0000963c <_ZN3halL15Peripheral_BaseE>:
    963c:	20000000 	andcs	r0, r0, r0

00009640 <_ZN3halL9GPIO_BaseE>:
    9640:	20200000 	eorcs	r0, r0, r0

00009644 <_ZN3halL14GPIO_Pin_CountE>:
    9644:	00000036 	andeq	r0, r0, r6, lsr r0

00009648 <_ZN3halL8AUX_BaseE>:
    9648:	20215000 	eorcs	r5, r1, r0

0000964c <_ZN3halL15Peripheral_BaseE>:
    964c:	20000000 	andcs	r0, r0, r0

00009650 <_ZN3halL9GPIO_BaseE>:
    9650:	20200000 	eorcs	r0, r0, r0

00009654 <_ZN3halL14GPIO_Pin_CountE>:
    9654:	00000036 	andeq	r0, r0, r6, lsr r0

00009658 <_ZN3halL8AUX_BaseE>:
    9658:	20215000 	eorcs	r5, r1, r0

0000965c <_ZZN8CMonitorlsEjE11BUFFER_SIZE>:
    965c:	00000010 	andeq	r0, r0, r0, lsl r0
    9660:	65757274 	ldrbvs	r7, [r5, #-628]!	; 0xfffffd8c
    9664:	00000000 	andeq	r0, r0, r0
    9668:	736c6166 	cmnvc	ip, #-2147483623	; 0x80000019
    966c:	00000065 	andeq	r0, r0, r5, rrx
    9670:	33323130 	teqcc	r2, #48, 2
    9674:	37363534 			; <UNDEFINED> instruction: 0x37363534
    9678:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    967c:	46454443 	strbmi	r4, [r5], -r3, asr #8
    9680:	00000000 	andeq	r0, r0, r0

00009684 <_ZN3halL15Peripheral_BaseE>:
    9684:	20000000 	andcs	r0, r0, r0

00009688 <_ZN3halL9GPIO_BaseE>:
    9688:	20200000 	eorcs	r0, r0, r0

0000968c <_ZN3halL14GPIO_Pin_CountE>:
    968c:	00000036 	andeq	r0, r0, r6, lsr r0

00009690 <_ZN3halL8AUX_BaseE>:
    9690:	20215000 	eorcs	r5, r1, r0

00009694 <_ZN3halL15Peripheral_BaseE>:
    9694:	20000000 	andcs	r0, r0, r0

00009698 <_ZN3halL9GPIO_BaseE>:
    9698:	20200000 	eorcs	r0, r0, r0

0000969c <_ZN3halL14GPIO_Pin_CountE>:
    969c:	00000036 	andeq	r0, r0, r6, lsr r0

000096a0 <_ZN3halL8AUX_BaseE>:
    96a0:	20215000 	eorcs	r5, r1, r0
    96a4:	636c6557 	cmnvs	ip, #364904448	; 0x15c00000
    96a8:	20656d6f 	rsbcs	r6, r5, pc, ror #26
    96ac:	4b206f74 	blmi	825484 <_bss_end+0x81bd68>
    96b0:	4f2f5649 	svcmi	0x002f5649
    96b4:	50522053 	subspl	r2, r2, r3, asr r0
    96b8:	20534f69 	subscs	r4, r3, r9, ror #30
    96bc:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
    96c0:	0a0d6c65 	beq	36485c <_bss_end+0x35b140>
	...

Disassembly of section .data:

000096c8 <__CTOR_LIST__>:
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:2355
    96c8:	0000829c 	muleq	r0, ip, r2
    96cc:	0000879c 	muleq	r0, ip, r7
    96d0:	00008de4 	andeq	r8, r0, r4, ror #27
    96d4:	000091cc 	andeq	r9, r0, ip, asr #3

Disassembly of section .bss:

000096d8 <sAUX>:
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/bcm_aux.cpp:3
CAUX sAUX(hal::AUX_Base);
    96d8:	00000000 	andeq	r0, r0, r0

000096dc <sGPIO>:
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-UART/kernel/src/drivers/gpio.cpp:4
CGPIO_Handler sGPIO(hal::GPIO_Base);
    96dc:	00000000 	andeq	r0, r0, r0

000096e0 <sMonitor>:
	...

000096f8 <_ZZN8CMonitorlsEjE8s_buffer>:
	...

00009708 <sUART0>:
	...

Disassembly of section .debug_info:

00000000 <.debug_info>:
       0:	00000126 	andeq	r0, r0, r6, lsr #2
       4:	00000004 	andeq	r0, r0, r4
       8:	01040000 	mrseq	r0, (UNDEF: 4)
       c:	000000a0 	andeq	r0, r0, r0, lsr #1
      10:	00002b04 	andeq	r2, r0, r4, lsl #22
      14:	00016600 	andeq	r6, r1, r0, lsl #12
      18:	00801800 	addeq	r1, r0, r0, lsl #16
      1c:	0000d800 	andeq	sp, r0, r0, lsl #16
      20:	00000000 	andeq	r0, r0, r0
      24:	00140200 	andseq	r0, r4, r0, lsl #4
      28:	28010000 	stmdacs	r1, {}	; <UNPREDICTABLE>
      2c:	0080e411 	addeq	lr, r0, r1, lsl r4
      30:	00000c00 	andeq	r0, r0, r0, lsl #24
      34:	029c0100 	addseq	r0, ip, #0, 2
      38:	00000153 	andeq	r0, r0, r3, asr r1
      3c:	cc112301 	ldcgt	3, cr2, [r1], {1}
      40:	18000080 	stmdane	r0, {r7}
      44:	01000000 	mrseq	r0, (UNDEF: 0)
      48:	0093029c 	umullseq	r0, r3, ip, r2
      4c:	1e010000 	cdpne	0, 0, cr0, cr1, cr0, {0}
      50:	0080b411 	addeq	fp, r0, r1, lsl r4
      54:	00001800 	andeq	r1, r0, r0, lsl #16
      58:	029c0100 	addseq	r0, ip, #0, 2
      5c:	00000086 	andeq	r0, r0, r6, lsl #1
      60:	9c111901 			; <UNDEFINED> instruction: 0x9c111901
      64:	18000080 	stmdane	r0, {r7}
      68:	01000000 	mrseq	r0, (UNDEF: 0)
      6c:	0148039c 			; <UNDEFINED> instruction: 0x0148039c
      70:	00020000 	andeq	r0, r2, r0
      74:	000000bb 	strheq	r0, [r0], -fp
      78:	00007404 	andeq	r7, r0, r4, lsl #8
      7c:	15140100 	ldrne	r0, [r4, #-256]	; 0xffffff00
      80:	0000008a 	andeq	r0, r0, sl, lsl #1
      84:	0000bb05 	andeq	fp, r0, r5, lsl #22
      88:	a2060000 	andge	r0, r6, #0
      8c:	01000001 	tsteq	r0, r1
      90:	00c11f04 	sbceq	r1, r1, r4, lsl #30
      94:	00040000 	andeq	r0, r4, r0
      98:	01000000 	mrseq	r0, (UNDEF: 0)
      9c:	00a8150f 	adceq	r1, r8, pc, lsl #10
      a0:	bb050000 	bllt	1400a8 <_bss_end+0x13698c>
      a4:	00000000 	andeq	r0, r0, r0
      a8:	00013407 	andeq	r3, r1, r7, lsl #8
      ac:	140a0100 	strne	r0, [sl], #-256	; 0xffffff00
      b0:	00000105 	andeq	r0, r0, r5, lsl #2
      b4:	0000bb05 	andeq	fp, r0, r5, lsl #22
      b8:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
      bc:	00008a04 	andeq	r8, r0, r4, lsl #20
      c0:	05080900 	streq	r0, [r8, #-2304]	; 0xfffff700
      c4:	000001aa 	andeq	r0, r0, sl, lsr #3
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
      fc:	0000bb32 	andeq	fp, r0, r2, lsr fp
     100:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     104:	05040d00 	streq	r0, [r4, #-3328]	; 0xfffff300
     108:	00746e69 	rsbseq	r6, r4, r9, ror #28
     10c:	0000a80e 	andeq	sl, r0, lr, lsl #16
     110:	00801800 	addeq	r1, r0, r0, lsl #16
     114:	00003800 	andeq	r3, r0, r0, lsl #16
     118:	0c9c0100 	ldfeqs	f0, [ip], {0}
     11c:	0a010067 	beq	402c0 <_bss_end+0x36ba4>
     120:	0000bb31 	andeq	fp, r0, r1, lsr fp
     124:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     128:	03f00000 	mvnseq	r0, #0
     12c:	00040000 	andeq	r0, r4, r0
     130:	000000d0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     134:	00a00104 	adceq	r0, r0, r4, lsl #2
     138:	fb040000 	blx	100142 <_bss_end+0xf6a26>
     13c:	66000003 	strvs	r0, [r0], -r3
     140:	f0000001 			; <UNDEFINED> instruction: 0xf0000001
     144:	c8000080 	stmdagt	r0, {r7}
     148:	aa000001 	bge	154 <shift+0x154>
     14c:	02000000 	andeq	r0, r0, #0
     150:	02ff0801 	rscseq	r0, pc, #65536	; 0x10000
     154:	02020000 	andeq	r0, r2, #0
     158:	0001b805 	andeq	fp, r1, r5, lsl #16
     15c:	05040300 	streq	r0, [r4, #-768]	; 0xfffffd00
     160:	00746e69 	rsbseq	r6, r4, r9, ror #28
     164:	f6080102 			; <UNDEFINED> instruction: 0xf6080102
     168:	02000002 	andeq	r0, r0, #2
     16c:	03600702 	cmneq	r0, #524288	; 0x80000
     170:	29040000 	stmdbcs	r4, {}	; <UNPREDICTABLE>
     174:	04000003 	streq	r0, [r0], #-3
     178:	0059070b 	subseq	r0, r9, fp, lsl #14
     17c:	48050000 	stmdami	r5, {}	; <UNPREDICTABLE>
     180:	02000000 	andeq	r0, r0, #0
     184:	11da0704 	bicsne	r0, sl, r4, lsl #14
     188:	68060000 	stmdavs	r6, {}	; <UNPREDICTABLE>
     18c:	02006c61 	andeq	r6, r0, #24832	; 0x6100
     190:	01680b07 	cmneq	r8, r7, lsl #22
     194:	ba070000 	blt	1c019c <_bss_end+0x1b6a80>
     198:	02000002 	andeq	r0, r0, #2
     19c:	016f1d0a 	cmneq	pc, sl, lsl #26
     1a0:	00000000 	andeq	r0, r0, r0
     1a4:	12072000 	andne	r2, r7, #0
     1a8:	02000003 	andeq	r0, r0, #3
     1ac:	016f1d0d 	cmneq	pc, sp, lsl #26
     1b0:	00000000 	andeq	r0, r0, r0
     1b4:	9e082020 	cdpls	0, 0, cr2, cr8, cr0, {1}
     1b8:	02000003 	andeq	r0, r0, #3
     1bc:	00541810 	subseq	r1, r4, r0, lsl r8
     1c0:	07360000 	ldreq	r0, [r6, -r0]!
     1c4:	00000450 	andeq	r0, r0, r0, asr r4
     1c8:	6f1d4202 	svcvs	0x001d4202
     1cc:	00000001 	andeq	r0, r0, r1
     1d0:	09202150 	stmdbeq	r0!, {r4, r6, r8, sp}
     1d4:	000001d7 	ldrdeq	r0, [r0], -r7
     1d8:	00330405 	eorseq	r0, r3, r5, lsl #8
     1dc:	44020000 	strmi	r0, [r2], #-0
     1e0:	00014610 	andeq	r4, r1, r0, lsl r6
     1e4:	52490a00 	subpl	r0, r9, #0, 20
     1e8:	0b000051 	bleq	334 <shift+0x334>
     1ec:	00000214 	andeq	r0, r0, r4, lsl r2
     1f0:	04700b01 	ldrbteq	r0, [r0], #-2817	; 0xfffff4ff
     1f4:	0b100000 	bleq	4001fc <_bss_end+0x3f6ae0>
     1f8:	00000304 	andeq	r0, r0, r4, lsl #6
     1fc:	03470b11 	movteq	r0, #31505	; 0x7b11
     200:	0b120000 	bleq	480208 <_bss_end+0x476aec>
     204:	0000037b 	andeq	r0, r0, fp, ror r3
     208:	030b0b13 	movweq	r0, #47891	; 0xbb13
     20c:	0b140000 	bleq	500214 <_bss_end+0x4f6af8>
     210:	0000047f 	andeq	r0, r0, pc, ror r4
     214:	03f40b15 	mvnseq	r0, #21504	; 0x5400
     218:	0b160000 	bleq	580220 <_bss_end+0x576b04>
     21c:	000004b7 			; <UNDEFINED> instruction: 0x000004b7
     220:	034e0b17 	movteq	r0, #60183	; 0xeb17
     224:	0b180000 	bleq	60022c <_bss_end+0x5f6b10>
     228:	00000459 	andeq	r0, r0, r9, asr r4
     22c:	038c0b19 	orreq	r0, ip, #25600	; 0x6400
     230:	0b1a0000 	bleq	680238 <_bss_end+0x676b1c>
     234:	000002a4 	andeq	r0, r0, r4, lsr #5
     238:	02af0b20 	adceq	r0, pc, #32, 22	; 0x8000
     23c:	0b210000 	bleq	840244 <_bss_end+0x836b28>
     240:	00000394 	muleq	r0, r4, r3
     244:	02880b22 	addeq	r0, r8, #34816	; 0x8800
     248:	0b240000 	bleq	900250 <_bss_end+0x8f6b34>
     24c:	00000382 	andeq	r0, r0, r2, lsl #7
     250:	02d90b25 	sbcseq	r0, r9, #37888	; 0x9400
     254:	0b300000 	bleq	c0025c <_bss_end+0xbf6b40>
     258:	000002e4 	andeq	r0, r0, r4, ror #5
     25c:	01cc0b31 	biceq	r0, ip, r1, lsr fp
     260:	0b320000 	bleq	c80268 <_bss_end+0xc76b4c>
     264:	00000373 	andeq	r0, r0, r3, ror r3
     268:	01c20b34 	biceq	r0, r2, r4, lsr fp
     26c:	00350000 	eorseq	r0, r5, r0
     270:	0002440c 	andeq	r4, r2, ip, lsl #8
     274:	33040500 	movwcc	r0, #17664	; 0x4500
     278:	02000000 	andeq	r0, r0, #0
     27c:	760b106a 	strvc	r1, [fp], -sl, rrx
     280:	00000004 	andeq	r0, r0, r4
     284:	0003560b 	andeq	r5, r3, fp, lsl #12
     288:	5b0b0100 	blpl	2c0690 <_bss_end+0x2b6f74>
     28c:	02000003 	andeq	r0, r0, #3
     290:	04020000 	streq	r0, [r2], #-0
     294:	0011d507 	andseq	sp, r1, r7, lsl #10
     298:	01680500 	cmneq	r8, r0, lsl #10
     29c:	6c0d0000 	stcvs	0, cr0, [sp], {-0}
     2a0:	0d000000 	stceq	0, cr0, [r0, #-0]
     2a4:	0000007c 	andeq	r0, r0, ip, ror r0
     2a8:	00008c0d 	andeq	r8, r0, sp, lsl #24
     2ac:	00990d00 	addseq	r0, r9, r0, lsl #26
     2b0:	140e0000 	strne	r0, [lr], #-0
     2b4:	0400000b 	streq	r0, [r0], #-11
     2b8:	4c070603 	stcmi	6, cr0, [r7], {3}
     2bc:	0f000002 	svceq	0x00000002
     2c0:	000001d6 	ldrdeq	r0, [r0], -r6
     2c4:	52190a03 	andspl	r0, r9, #12288	; 0x3000
     2c8:	00000002 	andeq	r0, r0, r2
     2cc:	000b1410 	andeq	r1, fp, r0, lsl r4
     2d0:	050d0300 	streq	r0, [sp, #-768]	; 0xfffffd00
     2d4:	00000254 	andeq	r0, r0, r4, asr r2
     2d8:	00000257 	andeq	r0, r0, r7, asr r2
     2dc:	0001bb01 	andeq	fp, r1, r1, lsl #22
     2e0:	0001c600 	andeq	ip, r1, r0, lsl #12
     2e4:	02571100 	subseq	r1, r7, #0, 2
     2e8:	59120000 	ldmdbpl	r2, {}	; <UNPREDICTABLE>
     2ec:	00000000 	andeq	r0, r0, r0
     2f0:	0002ef13 	andeq	lr, r2, r3, lsl pc
     2f4:	0a100300 	beq	400efc <_bss_end+0x3f77e0>
     2f8:	0000021c 	andeq	r0, r0, ip, lsl r2
     2fc:	0001db01 	andeq	sp, r1, r1, lsl #22
     300:	0001e600 	andeq	lr, r1, r0, lsl #12
     304:	02571100 	subseq	r1, r7, #0, 2
     308:	46120000 	ldrmi	r0, [r2], -r0
     30c:	00000001 	andeq	r0, r0, r1
     310:	00033213 	andeq	r3, r3, r3, lsl r2
     314:	0a120300 	beq	480f1c <_bss_end+0x477800>
     318:	0000048e 	andeq	r0, r0, lr, lsl #9
     31c:	0001fb01 	andeq	pc, r1, r1, lsl #22
     320:	00020600 	andeq	r0, r2, r0, lsl #12
     324:	02571100 	subseq	r1, r7, #0, 2
     328:	46120000 	ldrmi	r0, [r2], -r0
     32c:	00000001 	andeq	r0, r0, r1
     330:	0003e713 	andeq	lr, r3, r3, lsl r7
     334:	0a150300 	beq	540f3c <_bss_end+0x537820>
     338:	00000261 	andeq	r0, r0, r1, ror #4
     33c:	00021b01 	andeq	r1, r2, r1, lsl #22
     340:	00022b00 	andeq	r2, r2, r0, lsl #22
     344:	02571100 	subseq	r1, r7, #0, 2
     348:	a9120000 	ldmdbge	r2, {}	; <UNPREDICTABLE>
     34c:	12000000 	andne	r0, r0, #0
     350:	00000048 	andeq	r0, r0, r8, asr #32
     354:	033a1400 	teqeq	sl, #0, 8
     358:	17030000 	strne	r0, [r3, -r0]
     35c:	0001df0e 	andeq	sp, r1, lr, lsl #30
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
     38c:	00029f16 	andeq	r9, r2, r6, lsl pc
     390:	0d1a0300 	ldceq	3, cr0, [sl, #-0]
     394:	00000188 	andeq	r0, r0, r8, lsl #3
     398:	00026217 	andeq	r6, r2, r7, lsl r2
     39c:	06030100 	streq	r0, [r3], -r0, lsl #2
     3a0:	96d80305 	ldrbls	r0, [r8], r5, lsl #6
     3a4:	90180000 	andsls	r0, r8, r0
     3a8:	9c000002 	stcls	0, cr0, [r0], {2}
     3ac:	1c000082 	stcne	0, cr0, [r0], {130}	; 0x82
     3b0:	01000000 	mrseq	r0, (UNDEF: 0)
     3b4:	03ad199c 			; <UNDEFINED> instruction: 0x03ad199c
     3b8:	82480000 	subhi	r0, r8, #0
     3bc:	00540000 	subseq	r0, r4, r0
     3c0:	9c010000 	stcls	0, cr0, [r1], {-0}
     3c4:	000002bd 			; <UNDEFINED> instruction: 0x000002bd
     3c8:	0002ca1a 	andeq	ip, r2, sl, lsl sl
     3cc:	011f0100 	tsteq	pc, r0, lsl #2
     3d0:	00000033 	andeq	r0, r0, r3, lsr r0
     3d4:	1a749102 	bne	1d247e4 <_bss_end+0x1d1b0c8>
     3d8:	000003d7 	ldrdeq	r0, [r0], -r7
     3dc:	33011f01 	movwcc	r1, #7937	; 0x1f01
     3e0:	02000000 	andeq	r0, r0, #0
     3e4:	1b007091 	blne	1c630 <_bss_end+0x12f14>
     3e8:	0000022b 	andeq	r0, r0, fp, lsr #4
     3ec:	d70a1c01 	strle	r1, [sl, -r1, lsl #24]
     3f0:	0c000002 	stceq	0, cr0, [r0], {2}
     3f4:	3c000082 	stccc	0, cr0, [r0], {130}	; 0x82
     3f8:	01000000 	mrseq	r0, (UNDEF: 0)
     3fc:	0002f39c 	muleq	r2, ip, r3
     400:	03e21c00 	mvneq	r1, #0, 24
     404:	025d0000 	subseq	r0, sp, #0
     408:	91020000 	mrsls	r0, (UNDEF: 2)
     40c:	04861a74 	streq	r1, [r6], #2676	; 0xa74
     410:	1c010000 	stcne	0, cr0, [r1], {-0}
     414:	0000a92a 	andeq	sl, r0, sl, lsr #18
     418:	70910200 	addsvc	r0, r1, r0, lsl #4
     41c:	02061b00 	andeq	r1, r6, #0, 22
     420:	17010000 	strne	r0, [r1, -r0]
     424:	00030d06 	andeq	r0, r3, r6, lsl #26
     428:	0081c800 	addeq	ip, r1, r0, lsl #16
     42c:	00004400 	andeq	r4, r0, r0, lsl #8
     430:	389c0100 	ldmcc	ip, {r8}
     434:	1c000003 	stcne	0, cr0, [r0], {3}
     438:	000003e2 	andeq	r0, r0, r2, ror #7
     43c:	0000025d 	andeq	r0, r0, sp, asr r2
     440:	1a749102 	bne	1d24850 <_bss_end+0x1d1b134>
     444:	00000486 	andeq	r0, r0, r6, lsl #9
     448:	a9261701 	stmdbge	r6!, {r0, r8, r9, sl, ip}
     44c:	02000000 	andeq	r0, r0, #0
     450:	051a7091 	ldreq	r7, [sl, #-145]	; 0xffffff6f
     454:	01000002 	tsteq	r0, r2
     458:	00483817 	subeq	r3, r8, r7, lsl r8
     45c:	91020000 	mrsls	r0, (UNDEF: 2)
     460:	e61d006c 	ldr	r0, [sp], -ip, rrx
     464:	01000001 	tsteq	r0, r1
     468:	03520611 	cmpeq	r2, #17825792	; 0x1100000
     46c:	81740000 	cmnhi	r4, r0
     470:	00540000 	subseq	r0, r4, r0
     474:	9c010000 	stcls	0, cr0, [r1], {-0}
     478:	0000036e 	andeq	r0, r0, lr, ror #6
     47c:	0003e21c 	andeq	lr, r3, ip, lsl r2
     480:	00025d00 	andeq	r5, r2, r0, lsl #26
     484:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     488:	0004611a 	andeq	r6, r4, sl, lsl r1
     48c:	29110100 	ldmdbcs	r1, {r8}
     490:	00000146 	andeq	r0, r0, r6, asr #2
     494:	00709102 	rsbseq	r9, r0, r2, lsl #2
     498:	0001c61d 	andeq	ip, r1, sp, lsl r6
     49c:	060b0100 	streq	r0, [fp], -r0, lsl #2
     4a0:	00000388 	andeq	r0, r0, r8, lsl #7
     4a4:	00008124 	andeq	r8, r0, r4, lsr #2
     4a8:	00000050 	andeq	r0, r0, r0, asr r0
     4ac:	03a49c01 			; <UNDEFINED> instruction: 0x03a49c01
     4b0:	e21c0000 	ands	r0, ip, #0
     4b4:	5d000003 	stcpl	0, cr0, [r0, #-12]
     4b8:	02000002 	andeq	r0, r0, #2
     4bc:	611a7491 			; <UNDEFINED> instruction: 0x611a7491
     4c0:	01000004 	tsteq	r0, r4
     4c4:	0146280b 	cmpeq	r6, fp, lsl #16
     4c8:	91020000 	mrsls	r0, (UNDEF: 2)
     4cc:	a21e0070 	andsge	r0, lr, #112	; 0x70
     4d0:	01000001 	tsteq	r0, r1
     4d4:	03b50105 			; <UNDEFINED> instruction: 0x03b50105
     4d8:	cb000000 	blgt	4e0 <shift+0x4e0>
     4dc:	1f000003 	svcne	0x00000003
     4e0:	000003e2 	andeq	r0, r0, r2, ror #7
     4e4:	0000025d 	andeq	r0, r0, sp, asr r2
     4e8:	00020b20 	andeq	r0, r2, r0, lsr #22
     4ec:	19050100 	stmdbne	r5, {r8}
     4f0:	00000059 	andeq	r0, r0, r9, asr r0
     4f4:	03a42100 			; <UNDEFINED> instruction: 0x03a42100
     4f8:	031c0000 	tsteq	ip, #0
     4fc:	03e20000 	mvneq	r0, #0
     500:	80f00000 	rscshi	r0, r0, r0
     504:	00340000 	eorseq	r0, r4, r0
     508:	9c010000 	stcls	0, cr0, [r1], {-0}
     50c:	0003b522 	andeq	fp, r3, r2, lsr #10
     510:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     514:	0003be22 	andeq	fp, r3, r2, lsr #28
     518:	70910200 	addsvc	r0, r1, r0, lsl #4
     51c:	06850000 	streq	r0, [r5], r0
     520:	00040000 	andeq	r0, r4, r0
     524:	000002fa 	strdeq	r0, [r0], -sl
     528:	00a00104 	adceq	r0, r0, r4, lsl #2
     52c:	22040000 	andcs	r0, r4, #0
     530:	66000007 	strvs	r0, [r0], -r7
     534:	b8000001 	stmdalt	r0, {r0}
     538:	00000082 	andeq	r0, r0, r2, lsl #1
     53c:	54000005 	strpl	r0, [r0], #-5
     540:	02000002 	andeq	r0, r0, #2
     544:	02ff0801 	rscseq	r0, pc, #65536	; 0x10000
     548:	02020000 	andeq	r0, r2, #0
     54c:	0001b805 	andeq	fp, r1, r5, lsl #16
     550:	05040300 	streq	r0, [r4, #-768]	; 0xfffffd00
     554:	00746e69 	rsbseq	r6, r4, r9, ror #28
     558:	0005c004 	andeq	ip, r5, r4
     55c:	07090200 	streq	r0, [r9, -r0, lsl #4]
     560:	00000046 	andeq	r0, r0, r6, asr #32
     564:	f6080102 			; <UNDEFINED> instruction: 0xf6080102
     568:	02000002 	andeq	r0, r0, #2
     56c:	03600702 	cmneq	r0, #524288	; 0x80000
     570:	29040000 	stmdbcs	r4, {}	; <UNPREDICTABLE>
     574:	02000003 	andeq	r0, r0, #3
     578:	0065070b 	rsbeq	r0, r5, fp, lsl #14
     57c:	54050000 	strpl	r0, [r5], #-0
     580:	02000000 	andeq	r0, r0, #0
     584:	11da0704 	bicsne	r0, sl, r4, lsl #14
     588:	68060000 	stmdavs	r6, {}	; <UNPREDICTABLE>
     58c:	03006c61 	movweq	r6, #3169	; 0xc61
     590:	01770b07 	cmneq	r7, r7, lsl #22
     594:	ba070000 	blt	1c059c <_bss_end+0x1b6e80>
     598:	03000002 	movweq	r0, #2
     59c:	017e1d0a 	cmneq	lr, sl, lsl #26
     5a0:	00000000 	andeq	r0, r0, r0
     5a4:	12072000 	andne	r2, r7, #0
     5a8:	03000003 	movweq	r0, #3
     5ac:	017e1d0d 	cmneq	lr, sp, lsl #26
     5b0:	00000000 	andeq	r0, r0, r0
     5b4:	9e082020 	cdpls	0, 0, cr2, cr8, cr0, {1}
     5b8:	03000003 	movweq	r0, #3
     5bc:	00601810 	rsbeq	r1, r0, r0, lsl r8
     5c0:	09360000 	ldmdbeq	r6!, {}	; <UNPREDICTABLE>
     5c4:	00000835 	andeq	r0, r0, r5, lsr r8
     5c8:	00330405 	eorseq	r0, r3, r5, lsl #8
     5cc:	13030000 	movwne	r0, #12288	; 0x3000
     5d0:	00016610 	andeq	r6, r1, r0, lsl r6
     5d4:	04ff0a00 	ldrbteq	r0, [pc], #2560	; 5dc <shift+0x5dc>
     5d8:	0a000000 	beq	5e0 <shift+0x5e0>
     5dc:	00000507 	andeq	r0, r0, r7, lsl #10
     5e0:	050f0a01 	streq	r0, [pc, #-2561]	; fffffbe7 <_bss_end+0xffff64cb>
     5e4:	0a020000 	beq	805ec <_bss_end+0x76ed0>
     5e8:	00000517 	andeq	r0, r0, r7, lsl r5
     5ec:	051f0a03 	ldreq	r0, [pc, #-2563]	; fffffbf1 <_bss_end+0xffff64d5>
     5f0:	0a040000 	beq	1005f8 <_bss_end+0xf6edc>
     5f4:	00000527 	andeq	r0, r0, r7, lsr #10
     5f8:	04f10a05 	ldrbteq	r0, [r1], #2565	; 0xa05
     5fc:	0a070000 	beq	1c0604 <_bss_end+0x1b6ee8>
     600:	000004f8 	strdeq	r0, [r0], -r8
     604:	08620a08 	stmdaeq	r2!, {r3, r9, fp}^
     608:	0a0a0000 	beq	280610 <_bss_end+0x276ef4>
     60c:	000006d3 	ldrdeq	r0, [r0], -r3
     610:	07ac0a0b 	streq	r0, [ip, fp, lsl #20]!
     614:	0a0d0000 	beq	34061c <_bss_end+0x336f00>
     618:	000007b3 			; <UNDEFINED> instruction: 0x000007b3
     61c:	05c80a0e 	strbeq	r0, [r8, #2574]	; 0xa0e
     620:	0a100000 	beq	400628 <_bss_end+0x3f6f0c>
     624:	000005cf 	andeq	r0, r0, pc, asr #11
     628:	05430a11 	strbeq	r0, [r3, #-2577]	; 0xfffff5ef
     62c:	0a130000 	beq	4c0634 <_bss_end+0x4b6f18>
     630:	0000054a 	andeq	r0, r0, sl, asr #10
     634:	08270a14 	stmdaeq	r7!, {r2, r4, r9, fp}
     638:	0a160000 	beq	580640 <_bss_end+0x576f24>
     63c:	0000082e 	andeq	r0, r0, lr, lsr #16
     640:	06ea0a17 	usateq	r0, #10, r7, lsl #20
     644:	0a190000 	beq	64064c <_bss_end+0x636f30>
     648:	000006f1 	strdeq	r0, [r0], -r1
     64c:	05e70a1a 	strbeq	r0, [r7, #2586]!	; 0xa1a
     650:	0a1c0000 	beq	700658 <_bss_end+0x6f6f3c>
     654:	00000707 	andeq	r0, r0, r7, lsl #14
     658:	06da0a1d 			; <UNDEFINED> instruction: 0x06da0a1d
     65c:	0a1f0000 	beq	7c0664 <_bss_end+0x7b6f48>
     660:	000006e2 	andeq	r0, r0, r2, ror #13
     664:	067f0a20 	ldrbteq	r0, [pc], -r0, lsr #20
     668:	0a220000 	beq	880670 <_bss_end+0x876f54>
     66c:	00000687 	andeq	r0, r0, r7, lsl #13
     670:	06260a23 	strteq	r0, [r6], -r3, lsr #20
     674:	0a250000 	beq	94067c <_bss_end+0x936f60>
     678:	0000052f 	andeq	r0, r0, pc, lsr #10
     67c:	05390a26 	ldreq	r0, [r9, #-2598]!	; 0xfffff5da
     680:	00270000 	eoreq	r0, r7, r0
     684:	00045007 	andeq	r5, r4, r7
     688:	1d420300 	stclne	3, cr0, [r2, #-0]
     68c:	0000017e 	andeq	r0, r0, lr, ror r1
     690:	20215000 	eorcs	r5, r1, r0
     694:	07040200 	streq	r0, [r4, -r0, lsl #4]
     698:	000011d5 	ldrdeq	r1, [r0], -r5
     69c:	00017705 	andeq	r7, r1, r5, lsl #14
     6a0:	00780b00 	rsbseq	r0, r8, r0, lsl #22
     6a4:	880b0000 	stmdahi	fp, {}	; <UNPREDICTABLE>
     6a8:	0b000000 	bleq	6b0 <shift+0x6b0>
     6ac:	00000098 	muleq	r0, r8, r0
     6b0:	0001660b 	andeq	r6, r1, fp, lsl #12
     6b4:	079d0900 	ldreq	r0, [sp, r0, lsl #18]
     6b8:	01070000 	mrseq	r0, (UNDEF: 7)
     6bc:	0000003a 	andeq	r0, r0, sl, lsr r0
     6c0:	e00c0604 	and	r0, ip, r4, lsl #12
     6c4:	0a000001 	beq	6d0 <shift+0x6d0>
     6c8:	00000821 	andeq	r0, r0, r1, lsr #16
     6cc:	07d80a00 	ldrbeq	r0, [r8, r0, lsl #20]
     6d0:	0a010000 	beq	406d8 <_bss_end+0x36fbc>
     6d4:	0000085c 	andeq	r0, r0, ip, asr r8
     6d8:	08560a02 	ldmdaeq	r6, {r1, r9, fp}^
     6dc:	0a030000 	beq	c06e4 <_bss_end+0xb6fc8>
     6e0:	0000083e 	andeq	r0, r0, lr, lsr r8
     6e4:	08440a04 	stmdaeq	r4, {r2, r9, fp}^
     6e8:	0a050000 	beq	1406f0 <_bss_end+0x136fd4>
     6ec:	0000084a 	andeq	r0, r0, sl, asr #16
     6f0:	08500a06 	ldmdaeq	r0, {r1, r2, r9, fp}^
     6f4:	0a070000 	beq	1c06fc <_bss_end+0x1b6fe0>
     6f8:	000005db 	ldrdeq	r0, [r0], -fp
     6fc:	050c0008 	streq	r0, [ip, #-8]
     700:	04000006 	streq	r0, [r0], #-6
     704:	41071a04 	tstmi	r7, r4, lsl #20
     708:	0d000003 	stceq	0, cr0, [r0, #-12]
     70c:	000005a3 	andeq	r0, r0, r3, lsr #11
     710:	4c191e04 	ldcmi	14, cr1, [r9], {4}
     714:	00000003 	andeq	r0, r0, r3
     718:	00070e0e 	andeq	r0, r7, lr, lsl #28
     71c:	0a220400 	beq	881724 <_bss_end+0x878008>
     720:	00000573 	andeq	r0, r0, r3, ror r5
     724:	00000351 	andeq	r0, r0, r1, asr r3
     728:	00021302 	andeq	r1, r2, r2, lsl #6
     72c:	00022800 	andeq	r2, r2, r0, lsl #16
     730:	03580f00 	cmpeq	r8, #0, 30
     734:	54100000 	ldrpl	r0, [r0], #-0
     738:	10000000 	andne	r0, r0, r0
     73c:	00000363 	andeq	r0, r0, r3, ror #6
     740:	00036310 	andeq	r6, r3, r0, lsl r3
     744:	0e0e0000 	cdpeq	0, 0, cr0, cr14, cr0, {0}
     748:	04000008 	streq	r0, [r0], #-8
     74c:	068f0a24 	streq	r0, [pc], r4, lsr #20
     750:	03510000 	cmpeq	r1, #0
     754:	41020000 	mrsmi	r0, (UNDEF: 2)
     758:	56000002 	strpl	r0, [r0], -r2
     75c:	0f000002 	svceq	0x00000002
     760:	00000358 	andeq	r0, r0, r8, asr r3
     764:	00005410 	andeq	r5, r0, r0, lsl r4
     768:	03631000 	cmneq	r3, #0
     76c:	63100000 	tstvs	r0, #0
     770:	00000003 	andeq	r0, r0, r3
     774:	0006130e 	andeq	r1, r6, lr, lsl #6
     778:	0a260400 	beq	981780 <_bss_end+0x978064>
     77c:	000007df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
     780:	00000351 	andeq	r0, r0, r1, asr r3
     784:	00026f02 	andeq	r6, r2, r2, lsl #30
     788:	00028400 	andeq	r8, r2, r0, lsl #8
     78c:	03580f00 	cmpeq	r8, #0, 30
     790:	54100000 	ldrpl	r0, [r0], #-0
     794:	10000000 	andne	r0, r0, r0
     798:	00000363 	andeq	r0, r0, r3, ror #6
     79c:	00036310 	andeq	r6, r3, r0, lsl r3
     7a0:	2c0e0000 	stccs	0, cr0, [lr], {-0}
     7a4:	04000006 	streq	r0, [r0], #-6
     7a8:	04c20a28 	strbeq	r0, [r2], #2600	; 0xa28
     7ac:	03510000 	cmpeq	r1, #0
     7b0:	9d020000 	stcls	0, cr0, [r2, #-0]
     7b4:	b2000002 	andlt	r0, r0, #2
     7b8:	0f000002 	svceq	0x00000002
     7bc:	00000358 	andeq	r0, r0, r8, asr r3
     7c0:	00005410 	andeq	r5, r0, r0, lsl r4
     7c4:	03631000 	cmneq	r3, #0
     7c8:	63100000 	tstvs	r0, #0
     7cc:	00000003 	andeq	r0, r0, r3
     7d0:	0006050e 	andeq	r0, r6, lr, lsl #10
     7d4:	052b0400 	streq	r0, [fp, #-1024]!	; 0xfffffc00
     7d8:	000005a9 	andeq	r0, r0, r9, lsr #11
     7dc:	00000369 	andeq	r0, r0, r9, ror #6
     7e0:	0002cb01 	andeq	ip, r2, r1, lsl #22
     7e4:	0002d600 	andeq	sp, r2, r0, lsl #12
     7e8:	03690f00 	cmneq	r9, #0, 30
     7ec:	65100000 	ldrvs	r0, [r0, #-0]
     7f0:	00000000 	andeq	r0, r0, r0
     7f4:	0007ba11 	andeq	fp, r7, r1, lsl sl
     7f8:	0a2e0400 	beq	b81800 <_bss_end+0xb780e4>
     7fc:	00000774 	andeq	r0, r0, r4, ror r7
     800:	0002eb01 	andeq	lr, r2, r1, lsl #22
     804:	0002fb00 	andeq	pc, r2, r0, lsl #22
     808:	03690f00 	cmneq	r9, #0, 30
     80c:	54100000 	ldrpl	r0, [r0], #-0
     810:	10000000 	andne	r0, r0, r0
     814:	00000197 	muleq	r0, r7, r1
     818:	05f30e00 	ldrbeq	r0, [r3, #3584]!	; 0xe00
     81c:	30040000 	andcc	r0, r4, r0
     820:	00063f14 	andeq	r3, r6, r4, lsl pc
     824:	00019700 	andeq	r9, r1, r0, lsl #14
     828:	03140100 	tsteq	r4, #0, 2
     82c:	031f0000 	tsteq	pc, #0
     830:	580f0000 	stmdapl	pc, {}	; <UNPREDICTABLE>
     834:	10000003 	andne	r0, r0, r3
     838:	00000054 	andeq	r0, r0, r4, asr r0
     83c:	07d41200 	ldrbeq	r1, [r4, r0, lsl #4]
     840:	33040000 	movwcc	r0, #16384	; 0x4000
     844:	0005510a 	andeq	r5, r5, sl, lsl #2
     848:	03300100 	teqeq	r0, #0, 2
     84c:	690f0000 	stmdbvs	pc, {}	; <UNPREDICTABLE>
     850:	10000003 	andne	r0, r0, r3
     854:	00000054 	andeq	r0, r0, r4, asr r0
     858:	00035110 	andeq	r5, r3, r0, lsl r1
     85c:	05000000 	streq	r0, [r0, #-0]
     860:	000001e0 	andeq	r0, r0, r0, ror #3
     864:	00650413 	rsbeq	r0, r5, r3, lsl r4
     868:	46050000 	strmi	r0, [r5], -r0
     86c:	02000003 	andeq	r0, r0, #3
     870:	05d60201 	ldrbeq	r0, [r6, #513]	; 0x201
     874:	04130000 	ldreq	r0, [r3], #-0
     878:	00000341 	andeq	r0, r0, r1, asr #6
     87c:	00035805 	andeq	r5, r3, r5, lsl #16
     880:	54041400 	strpl	r1, [r4], #-1024	; 0xfffffc00
     884:	13000000 	movwne	r0, #0
     888:	0001e004 	andeq	lr, r1, r4
     88c:	03690500 	cmneq	r9, #0, 10
     890:	cd150000 	ldcgt	0, cr0, [r5, #-0]
     894:	04000006 	streq	r0, [r0], #-6
     898:	01e01637 	mvneq	r1, r7, lsr r6
     89c:	74160000 	ldrvc	r0, [r6], #-0
     8a0:	01000003 	tsteq	r0, r3
     8a4:	03050f04 	movweq	r0, #24324	; 0x5f04
     8a8:	000096dc 	ldrdeq	r9, [r0], -ip
     8ac:	0006be17 	andeq	fp, r6, r7, lsl lr
     8b0:	00879c00 	addeq	r9, r7, r0, lsl #24
     8b4:	00001c00 	andeq	r1, r0, r0, lsl #24
     8b8:	189c0100 	ldmne	ip, {r8}
     8bc:	000003ad 	andeq	r0, r0, sp, lsr #7
     8c0:	00008748 	andeq	r8, r0, r8, asr #14
     8c4:	00000054 	andeq	r0, r0, r4, asr r0
     8c8:	03cf9c01 	biceq	r9, pc, #256	; 0x100
     8cc:	ca190000 	bgt	6408d4 <_bss_end+0x6371b8>
     8d0:	01000002 	tsteq	r0, r2
     8d4:	00330166 	eorseq	r0, r3, r6, ror #2
     8d8:	91020000 	mrsls	r0, (UNDEF: 2)
     8dc:	03d71974 	bicseq	r1, r7, #116, 18	; 0x1d0000
     8e0:	66010000 	strvs	r0, [r1], -r0
     8e4:	00003301 	andeq	r3, r0, r1, lsl #6
     8e8:	70910200 	addsvc	r0, r1, r0, lsl #4
     8ec:	031f1a00 	tsteq	pc, #0, 20
     8f0:	5f010000 	svcpl	0x00010000
     8f4:	0003e906 	andeq	lr, r3, r6, lsl #18
     8f8:	00867000 	addeq	r7, r6, r0
     8fc:	0000d800 	andeq	sp, r0, r0, lsl #16
     900:	329c0100 	addscc	r0, ip, #0, 2
     904:	1b000004 	blne	91c <shift+0x91c>
     908:	000003e2 	andeq	r0, r0, r2, ror #7
     90c:	0000036f 	andeq	r0, r0, pc, ror #6
     910:	1c6c9102 	stfnep	f1, [ip], #-8
     914:	006e6970 	rsbeq	r6, lr, r0, ror r9
     918:	54295f01 	strtpl	r5, [r9], #-3841	; 0xfffff0ff
     91c:	02000000 	andeq	r0, r0, #0
     920:	731c6891 	tstvc	ip, #9502720	; 0x910000
     924:	01007465 	tsteq	r0, r5, ror #8
     928:	0351335f 	cmpeq	r1, #2080374785	; 0x7c000001
     92c:	91020000 	mrsls	r0, (UNDEF: 2)
     930:	65721d67 	ldrbvs	r1, [r2, #-3431]!	; 0xfffff299
     934:	61010067 	tstvs	r1, r7, rrx
     938:	0000540e 	andeq	r5, r0, lr, lsl #8
     93c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     940:	7469621d 	strbtvc	r6, [r9], #-541	; 0xfffffde3
     944:	13610100 	cmnne	r1, #0, 2
     948:	00000054 	andeq	r0, r0, r4, asr r0
     94c:	00709102 	rsbseq	r9, r0, r2, lsl #2
     950:	0002fb1a 	andeq	pc, r2, sl, lsl fp	; <UNPREDICTABLE>
     954:	10560100 	subsne	r0, r6, r0, lsl #2
     958:	0000044c 	andeq	r0, r0, ip, asr #8
     95c:	000085fc 	strdeq	r8, [r0], -ip
     960:	00000074 	andeq	r0, r0, r4, ror r0
     964:	04869c01 	streq	r9, [r6], #3073	; 0xc01
     968:	e21b0000 	ands	r0, fp, #0
     96c:	5e000003 	cdppl	0, 0, cr0, cr0, cr3, {0}
     970:	02000003 	andeq	r0, r0, #3
     974:	701c6c91 	mulsvc	ip, r1, ip
     978:	01006e69 	tsteq	r0, r9, ror #28
     97c:	00543a56 	subseq	r3, r4, r6, asr sl
     980:	91020000 	mrsls	r0, (UNDEF: 2)
     984:	65721d68 	ldrbvs	r1, [r2, #-3432]!	; 0xfffff298
     988:	58010067 	stmdapl	r1, {r0, r1, r2, r5, r6}
     98c:	0000540e 	andeq	r5, r0, lr, lsl #8
     990:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     994:	7469621d 	strbtvc	r6, [r9], #-541	; 0xfffffde3
     998:	13580100 	cmpne	r8, #0, 2
     99c:	00000054 	andeq	r0, r0, r4, asr r0
     9a0:	00709102 	rsbseq	r9, r0, r2, lsl #2
     9a4:	0002d61a 	andeq	sp, r2, sl, lsl r6
     9a8:	064d0100 	strbeq	r0, [sp], -r0, lsl #2
     9ac:	000004a0 	andeq	r0, r0, r0, lsr #9
     9b0:	0000855c 	andeq	r8, r0, ip, asr r5
     9b4:	000000a0 	andeq	r0, r0, r0, lsr #1
     9b8:	04e99c01 	strbteq	r9, [r9], #3073	; 0xc01
     9bc:	e21b0000 	ands	r0, fp, #0
     9c0:	6f000003 	svcvs	0x00000003
     9c4:	02000003 	andeq	r0, r0, #3
     9c8:	701c6c91 	mulsvc	ip, r1, ip
     9cc:	01006e69 	tsteq	r0, r9, ror #28
     9d0:	0054304d 	subseq	r3, r4, sp, asr #32
     9d4:	91020000 	mrsls	r0, (UNDEF: 2)
     9d8:	05ee1968 	strbeq	r1, [lr, #2408]!	; 0x968
     9dc:	4d010000 	stcmi	0, cr0, [r1, #-0]
     9e0:	00019744 	andeq	r9, r1, r4, asr #14
     9e4:	67910200 	ldrvs	r0, [r1, r0, lsl #4]
     9e8:	6765721d 			; <UNDEFINED> instruction: 0x6765721d
     9ec:	0e4f0100 	dvfeqe	f0, f7, f0
     9f0:	00000054 	andeq	r0, r0, r4, asr r0
     9f4:	1d749102 	ldfnep	f1, [r4, #-8]!
     9f8:	00746962 	rsbseq	r6, r4, r2, ror #18
     9fc:	54134f01 	ldrpl	r4, [r3], #-3841	; 0xfffff0ff
     a00:	02000000 	andeq	r0, r0, #0
     a04:	1e007091 	mcrne	0, 0, r7, cr0, cr1, {4}
     a08:	00000284 	andeq	r0, r0, r4, lsl #5
     a0c:	03064201 	movweq	r4, #25089	; 0x6201
     a10:	e8000005 	stmda	r0, {r0, r2}
     a14:	74000084 	strvc	r0, [r0], #-132	; 0xffffff7c
     a18:	01000000 	mrseq	r0, (UNDEF: 0)
     a1c:	00053d9c 	muleq	r5, ip, sp
     a20:	03e21b00 	mvneq	r1, #0, 22
     a24:	035e0000 	cmpeq	lr, #0
     a28:	91020000 	mrsls	r0, (UNDEF: 2)
     a2c:	69701c74 	ldmdbvs	r0!, {r2, r4, r5, r6, sl, fp, ip}^
     a30:	4201006e 	andmi	r0, r1, #110	; 0x6e
     a34:	00005431 	andeq	r5, r0, r1, lsr r4
     a38:	70910200 	addsvc	r0, r1, r0, lsl #4
     a3c:	6765721c 			; <UNDEFINED> instruction: 0x6765721c
     a40:	40420100 	submi	r0, r2, r0, lsl #2
     a44:	00000363 	andeq	r0, r0, r3, ror #6
     a48:	196c9102 	stmdbne	ip!, {r1, r8, ip, pc}^
     a4c:	000007cc 	andeq	r0, r0, ip, asr #15
     a50:	634f4201 	movtvs	r4, #61953	; 0xf201
     a54:	02000003 	andeq	r0, r0, #3
     a58:	1e006891 	mcrne	8, 0, r6, cr0, cr1, {4}
     a5c:	00000256 	andeq	r0, r0, r6, asr r2
     a60:	57063701 	strpl	r3, [r6, -r1, lsl #14]
     a64:	74000005 	strvc	r0, [r0], #-5
     a68:	74000084 	strvc	r0, [r0], #-132	; 0xffffff7c
     a6c:	01000000 	mrseq	r0, (UNDEF: 0)
     a70:	0005919c 	muleq	r5, ip, r1
     a74:	03e21b00 	mvneq	r1, #0, 22
     a78:	035e0000 	cmpeq	lr, #0
     a7c:	91020000 	mrsls	r0, (UNDEF: 2)
     a80:	69701c74 	ldmdbvs	r0!, {r2, r4, r5, r6, sl, fp, ip}^
     a84:	3701006e 	strcc	r0, [r1, -lr, rrx]
     a88:	00005431 	andeq	r5, r0, r1, lsr r4
     a8c:	70910200 	addsvc	r0, r1, r0, lsl #4
     a90:	6765721c 			; <UNDEFINED> instruction: 0x6765721c
     a94:	40370100 	eorsmi	r0, r7, r0, lsl #2
     a98:	00000363 	andeq	r0, r0, r3, ror #6
     a9c:	196c9102 	stmdbne	ip!, {r1, r8, ip, pc}^
     aa0:	000007cc 	andeq	r0, r0, ip, asr #15
     aa4:	634f3701 	movtvs	r3, #63233	; 0xf701
     aa8:	02000003 	andeq	r0, r0, #3
     aac:	1e006891 	mcrne	8, 0, r6, cr0, cr1, {4}
     ab0:	00000228 	andeq	r0, r0, r8, lsr #4
     ab4:	ab062c01 	blge	18bac0 <_bss_end+0x1823a4>
     ab8:	00000005 	andeq	r0, r0, r5
     abc:	74000084 	strvc	r0, [r0], #-132	; 0xffffff7c
     ac0:	01000000 	mrseq	r0, (UNDEF: 0)
     ac4:	0005e59c 	muleq	r5, ip, r5
     ac8:	03e21b00 	mvneq	r1, #0, 22
     acc:	035e0000 	cmpeq	lr, #0
     ad0:	91020000 	mrsls	r0, (UNDEF: 2)
     ad4:	69701c74 	ldmdbvs	r0!, {r2, r4, r5, r6, sl, fp, ip}^
     ad8:	2c01006e 	stccs	0, cr0, [r1], {110}	; 0x6e
     adc:	00005431 	andeq	r5, r0, r1, lsr r4
     ae0:	70910200 	addsvc	r0, r1, r0, lsl #4
     ae4:	6765721c 			; <UNDEFINED> instruction: 0x6765721c
     ae8:	402c0100 	eormi	r0, ip, r0, lsl #2
     aec:	00000363 	andeq	r0, r0, r3, ror #6
     af0:	196c9102 	stmdbne	ip!, {r1, r8, ip, pc}^
     af4:	000007cc 	andeq	r0, r0, ip, asr #15
     af8:	634f2c01 	movtvs	r2, #64513	; 0xfc01
     afc:	02000003 	andeq	r0, r0, #3
     b00:	1e006891 	mcrne	8, 0, r6, cr0, cr1, {4}
     b04:	000001fa 	strdeq	r0, [r0], -sl
     b08:	ff060c01 			; <UNDEFINED> instruction: 0xff060c01
     b0c:	ec000005 	stc	0, cr0, [r0], {5}
     b10:	14000082 	strne	r0, [r0], #-130	; 0xffffff7e
     b14:	01000001 	tsteq	r0, r1
     b18:	0006399c 	muleq	r6, ip, r9
     b1c:	03e21b00 	mvneq	r1, #0, 22
     b20:	035e0000 	cmpeq	lr, #0
     b24:	91020000 	mrsls	r0, (UNDEF: 2)
     b28:	69701c74 	ldmdbvs	r0!, {r2, r4, r5, r6, sl, fp, ip}^
     b2c:	0c01006e 	stceq	0, cr0, [r1], {110}	; 0x6e
     b30:	00005432 	andeq	r5, r0, r2, lsr r4
     b34:	70910200 	addsvc	r0, r1, r0, lsl #4
     b38:	6765721c 			; <UNDEFINED> instruction: 0x6765721c
     b3c:	410c0100 	mrsmi	r0, (UNDEF: 28)
     b40:	00000363 	andeq	r0, r0, r3, ror #6
     b44:	196c9102 	stmdbne	ip!, {r1, r8, ip, pc}^
     b48:	000007cc 	andeq	r0, r0, ip, asr #15
     b4c:	63500c01 	cmpvs	r0, #256	; 0x100
     b50:	02000003 	andeq	r0, r0, #3
     b54:	1f006891 	svcne	0x00006891
     b58:	000002b2 			; <UNDEFINED> instruction: 0x000002b2
     b5c:	4a010601 	bmi	42368 <_bss_end+0x38c4c>
     b60:	00000006 	andeq	r0, r0, r6
     b64:	00000660 	andeq	r0, r0, r0, ror #12
     b68:	0003e220 	andeq	lr, r3, r0, lsr #4
     b6c:	00036f00 	andeq	r6, r3, r0, lsl #30
     b70:	06f82100 	ldrbteq	r2, [r8], r0, lsl #2
     b74:	06010000 	streq	r0, [r1], -r0
     b78:	0000652b 	andeq	r6, r0, fp, lsr #10
     b7c:	39220000 	stmdbcc	r2!, {}	; <UNPREDICTABLE>
     b80:	68000006 	stmdavs	r0, {r1, r2}
     b84:	77000006 	strvc	r0, [r0, -r6]
     b88:	b8000006 	stmdalt	r0, {r1, r2}
     b8c:	34000082 	strcc	r0, [r0], #-130	; 0xffffff7e
     b90:	01000000 	mrseq	r0, (UNDEF: 0)
     b94:	064a239c 			; <UNDEFINED> instruction: 0x064a239c
     b98:	91020000 	mrsls	r0, (UNDEF: 2)
     b9c:	06532374 			; <UNDEFINED> instruction: 0x06532374
     ba0:	91020000 	mrsls	r0, (UNDEF: 2)
     ba4:	b4000070 	strlt	r0, [r0], #-112	; 0xffffff90
     ba8:	04000006 	streq	r0, [r0], #-6
     bac:	00052f00 	andeq	r2, r5, r0, lsl #30
     bb0:	a0010400 	andge	r0, r1, r0, lsl #8
     bb4:	04000000 	streq	r0, [r0], #-0
     bb8:	000008cc 	andeq	r0, r0, ip, asr #17
     bbc:	00000166 	andeq	r0, r0, r6, ror #2
	...
     bc8:	0000053d 	andeq	r0, r0, sp, lsr r5
     bcc:	0009b102 	andeq	fp, r9, r2, lsl #2
     bd0:	03021800 	movweq	r1, #10240	; 0x2800
     bd4:	00026607 	andeq	r6, r2, r7, lsl #12
     bd8:	092f0300 	stmdbeq	pc!, {r8, r9}	; <UNPREDICTABLE>
     bdc:	04070000 	streq	r0, [r7], #-0
     be0:	00000266 	andeq	r0, r0, r6, ror #4
     be4:	01100602 	tsteq	r0, r2, lsl #12
     be8:	00000052 	andeq	r0, r0, r2, asr r0
     bec:	58454804 	stmdapl	r5, {r2, fp, lr}^
     bf0:	44041000 	strmi	r1, [r4], #-0
     bf4:	0a004345 	beq	11910 <_bss_end+0x81f4>
     bf8:	00320500 	eorseq	r0, r2, r0, lsl #10
     bfc:	3c060000 	stccc	0, cr0, [r6], {-0}
     c00:	08000009 	stmdaeq	r0, {r0, r3}
     c04:	7b0c2402 	blvc	309c14 <_bss_end+0x3004f8>
     c08:	07000000 	streq	r0, [r0, -r0]
     c0c:	26020079 			; <UNDEFINED> instruction: 0x26020079
     c10:	00026616 	andeq	r6, r2, r6, lsl r6
     c14:	78070000 	stmdavc	r7, {}	; <UNPREDICTABLE>
     c18:	16270200 	strtne	r0, [r7], -r0, lsl #4
     c1c:	00000266 	andeq	r0, r0, r6, ror #4
     c20:	9b080004 	blls	200c38 <_bss_end+0x1f751c>
     c24:	0200000a 	andeq	r0, r0, #10
     c28:	00521b0c 	subseq	r1, r2, ip, lsl #22
     c2c:	0a010000 	beq	40c34 <_bss_end+0x37518>
     c30:	000a0109 	andeq	r0, sl, r9, lsl #2
     c34:	280d0200 	stmdacs	sp, {r9}
     c38:	00000278 	andeq	r0, r0, r8, ror r2
     c3c:	09b10a01 	ldmibeq	r1!, {r0, r9, fp}
     c40:	10020000 	andne	r0, r2, r0
     c44:	000a880e 	andeq	r8, sl, lr, lsl #16
     c48:	00028900 	andeq	r8, r2, r0, lsl #18
     c4c:	00af0100 	adceq	r0, pc, r0, lsl #2
     c50:	00c40000 	sbceq	r0, r4, r0
     c54:	890b0000 	stmdbhi	fp, {}	; <UNPREDICTABLE>
     c58:	0c000002 	stceq	0, cr0, [r0], {2}
     c5c:	00000266 	andeq	r0, r0, r6, ror #4
     c60:	0002660c 	andeq	r6, r2, ip, lsl #12
     c64:	02660c00 	rsbeq	r0, r6, #0, 24
     c68:	0d000000 	stceq	0, cr0, [r0, #-0]
     c6c:	00000890 	muleq	r0, r0, r8
     c70:	9c0a1202 	sfmls	f1, 4, [sl], {2}
     c74:	01000009 	tsteq	r0, r9
     c78:	000000d9 	ldrdeq	r0, [r0], -r9
     c7c:	000000df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
     c80:	0002890b 	andeq	r8, r2, fp, lsl #18
     c84:	ba0e0000 	blt	380c8c <_bss_end+0x377570>
     c88:	02000009 	andeq	r0, r0, #9
     c8c:	0a2b0f14 	beq	ac48e4 <_bss_end+0xabb1c8>
     c90:	02940000 	addseq	r0, r4, #0
     c94:	f8010000 			; <UNDEFINED> instruction: 0xf8010000
     c98:	03000000 	movweq	r0, #0
     c9c:	0b000001 	bleq	ca8 <shift+0xca8>
     ca0:	00000289 	andeq	r0, r0, r9, lsl #5
     ca4:	00027d0c 	andeq	r7, r2, ip, lsl #26
     ca8:	ba0e0000 	blt	380cb0 <_bss_end+0x377594>
     cac:	02000009 	andeq	r0, r0, #9
     cb0:	09c50f15 	stmibeq	r5, {r0, r2, r4, r8, r9, sl, fp}^
     cb4:	02940000 	addseq	r0, r4, #0
     cb8:	1c010000 	stcne	0, cr0, [r1], {-0}
     cbc:	27000001 	strcs	r0, [r0, -r1]
     cc0:	0b000001 	bleq	ccc <shift+0xccc>
     cc4:	00000289 	andeq	r0, r0, r9, lsl #5
     cc8:	0002720c 	andeq	r7, r2, ip, lsl #4
     ccc:	ba0e0000 	blt	380cd4 <_bss_end+0x3775b8>
     cd0:	02000009 	andeq	r0, r0, #9
     cd4:	0aaf0f16 	beq	febc4934 <_bss_end+0xfebbb218>
     cd8:	02940000 	addseq	r0, r4, #0
     cdc:	40010000 	andmi	r0, r1, r0
     ce0:	4b000001 	blmi	cec <shift+0xcec>
     ce4:	0b000001 	bleq	cf0 <shift+0xcf0>
     ce8:	00000289 	andeq	r0, r0, r9, lsl #5
     cec:	0000320c 	andeq	r3, r0, ip, lsl #4
     cf0:	ba0e0000 	blt	380cf8 <_bss_end+0x3775dc>
     cf4:	02000009 	andeq	r0, r0, #9
     cf8:	0a5a0f17 	beq	168495c <_bss_end+0x167b240>
     cfc:	02940000 	addseq	r0, r4, #0
     d00:	64010000 	strvs	r0, [r1], #-0
     d04:	6f000001 	svcvs	0x00000001
     d08:	0b000001 	bleq	d14 <shift+0xd14>
     d0c:	00000289 	andeq	r0, r0, r9, lsl #5
     d10:	0002660c 	andeq	r6, r2, ip, lsl #12
     d14:	ba0e0000 	blt	380d1c <_bss_end+0x377600>
     d18:	02000009 	andeq	r0, r0, #9
     d1c:	0a1a0f18 	beq	684984 <_bss_end+0x67b268>
     d20:	02940000 	addseq	r0, r4, #0
     d24:	88010000 	stmdahi	r1, {}	; <UNPREDICTABLE>
     d28:	93000001 	movwls	r0, #1
     d2c:	0b000001 	bleq	d38 <shift+0xd38>
     d30:	00000289 	andeq	r0, r0, r9, lsl #5
     d34:	00029a0c 	andeq	r9, r2, ip, lsl #20
     d38:	210f0000 	mrscs	r0, CPSR
     d3c:	02000009 	andeq	r0, r0, #9
     d40:	08a9111b 	stmiaeq	r9!, {r0, r1, r3, r4, r8, ip}
     d44:	01a70000 			; <UNDEFINED> instruction: 0x01a70000
     d48:	01ad0000 			; <UNDEFINED> instruction: 0x01ad0000
     d4c:	890b0000 	stmdbhi	fp, {}	; <UNPREDICTABLE>
     d50:	00000002 	andeq	r0, r0, r2
     d54:	000a0d0f 	andeq	r0, sl, pc, lsl #26
     d58:	111c0200 	tstne	ip, r0, lsl #4
     d5c:	00000a6b 	andeq	r0, r0, fp, ror #20
     d60:	000001c1 	andeq	r0, r0, r1, asr #3
     d64:	000001c7 	andeq	r0, r0, r7, asr #3
     d68:	0002890b 	andeq	r8, r2, fp, lsl #18
     d6c:	7e0f0000 	cdpvc	0, 0, cr0, cr15, cr0, {0}
     d70:	02000008 	andeq	r0, r0, #8
     d74:	0946111d 	stmdbeq	r6, {r0, r2, r3, r4, r8, ip}^
     d78:	01db0000 	bicseq	r0, fp, r0
     d7c:	01e10000 	mvneq	r0, r0
     d80:	890b0000 	stmdbhi	fp, {}	; <UNPREDICTABLE>
     d84:	00000002 	andeq	r0, r0, r2
     d88:	0008690f 	andeq	r6, r8, pc, lsl #18
     d8c:	0a1f0200 	beq	7c1594 <_bss_end+0x7b7e78>
     d90:	00000a44 	andeq	r0, r0, r4, asr #20
     d94:	000001f5 	strdeq	r0, [r0], -r5
     d98:	000001fb 	strdeq	r0, [r0], -fp
     d9c:	0002890b 	andeq	r8, r2, fp, lsl #18
     da0:	c70f0000 	strgt	r0, [pc, -r0]
     da4:	02000008 	andeq	r0, r0, #8
     da8:	09d80a21 	ldmibeq	r8, {r0, r5, r9, fp}^
     dac:	020f0000 	andeq	r0, pc, #0
     db0:	02240000 	eoreq	r0, r4, #0
     db4:	890b0000 	stmdbhi	fp, {}	; <UNPREDICTABLE>
     db8:	0c000002 	stceq	0, cr0, [r0], {2}
     dbc:	00000266 	andeq	r0, r0, r6, ror #4
     dc0:	0002a10c 	andeq	sl, r2, ip, lsl #2
     dc4:	02660c00 	rsbeq	r0, r6, #0, 24
     dc8:	10000000 	andne	r0, r0, r0
     dcc:	00000968 	andeq	r0, r0, r8, ror #18
     dd0:	ad232b02 	vstmdbge	r3!, {d2}
     dd4:	00000002 	andeq	r0, r0, r2
     dd8:	000a3c10 	andeq	r3, sl, r0, lsl ip
     ddc:	122c0200 	eorne	r0, ip, #0, 4
     de0:	00000266 	andeq	r0, r0, r6, ror #4
     de4:	09ef1004 	stmibeq	pc!, {r2, ip}^	; <UNPREDICTABLE>
     de8:	2d020000 	stccs	0, cr0, [r2, #-0]
     dec:	00026612 	andeq	r6, r2, r2, lsl r6
     df0:	f8100800 			; <UNDEFINED> instruction: 0xf8100800
     df4:	02000009 	andeq	r0, r0, #9
     df8:	00570f2e 	subseq	r0, r7, lr, lsr #30
     dfc:	100c0000 	andne	r0, ip, r0
     e00:	00000870 	andeq	r0, r0, r0, ror r8
     e04:	32122f02 	andscc	r2, r2, #2, 30
     e08:	14000000 	strne	r0, [r0], #-0
     e0c:	07041100 	streq	r1, [r4, -r0, lsl #2]
     e10:	000011da 	ldrdeq	r1, [r0], -sl
     e14:	00026605 	andeq	r6, r2, r5, lsl #12
     e18:	84041200 	strhi	r1, [r4], #-512	; 0xfffffe00
     e1c:	05000002 	streq	r0, [r0, #-2]
     e20:	00000272 	andeq	r0, r0, r2, ror r2
     e24:	ff080111 			; <UNDEFINED> instruction: 0xff080111
     e28:	05000002 	streq	r0, [r0, #-2]
     e2c:	0000027d 	andeq	r0, r0, sp, ror r2
     e30:	00250412 	eoreq	r0, r5, r2, lsl r4
     e34:	89050000 	stmdbhi	r5, {}	; <UNPREDICTABLE>
     e38:	13000002 	movwne	r0, #2
     e3c:	00002504 	andeq	r2, r0, r4, lsl #10
     e40:	02011100 	andeq	r1, r1, #0, 2
     e44:	000005d6 	ldrdeq	r0, [r0], -r6
     e48:	027d0412 	rsbseq	r0, sp, #301989888	; 0x12000000
     e4c:	04120000 	ldreq	r0, [r2], #-0
     e50:	000002b9 			; <UNDEFINED> instruction: 0x000002b9
     e54:	0002a705 	andeq	sl, r2, r5, lsl #14
     e58:	08011100 	stmdaeq	r1, {r8, ip}
     e5c:	000002f6 	strdeq	r0, [r0], -r6
     e60:	0002b214 	andeq	fp, r2, r4, lsl r2
     e64:	09811500 	stmibeq	r1, {r8, sl, ip}
     e68:	32020000 	andcc	r0, r2, #0
     e6c:	00002511 	andeq	r2, r0, r1, lsl r5
     e70:	02be1600 	adcseq	r1, lr, #0, 12
     e74:	03010000 	movweq	r0, #4096	; 0x1000
     e78:	e003050a 	and	r0, r3, sl, lsl #10
     e7c:	17000096 			; <UNDEFINED> instruction: 0x17000096
     e80:	00000972 	andeq	r0, r0, r2, ror r9
     e84:	00008de4 	andeq	r8, r0, r4, ror #27
     e88:	0000001c 	andeq	r0, r0, ip, lsl r0
     e8c:	ad189c01 	ldcge	12, cr9, [r8, #-4]
     e90:	8c000003 	stchi	0, cr0, [r0], {3}
     e94:	5800008d 	stmdapl	r0, {r0, r2, r3, r7}
     e98:	01000000 	mrseq	r0, (UNDEF: 0)
     e9c:	0003199c 	muleq	r3, ip, r9
     ea0:	02ca1900 	sbceq	r1, sl, #0, 18
     ea4:	a2010000 	andge	r0, r1, #0
     ea8:	00031901 	andeq	r1, r3, r1, lsl #18
     eac:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     eb0:	0003d719 	andeq	sp, r3, r9, lsl r7
     eb4:	01a20100 			; <UNDEFINED> instruction: 0x01a20100
     eb8:	00000319 	andeq	r0, r0, r9, lsl r3
     ebc:	00709102 	rsbseq	r9, r0, r2, lsl #2
     ec0:	6905041a 	stmdbvs	r5, {r1, r3, r4, sl}
     ec4:	1b00746e 	blne	1e084 <_bss_end+0x14968>
     ec8:	000001fb 	strdeq	r0, [r0], -fp
     ecc:	3a068701 	bcc	1a2ad8 <_bss_end+0x1993bc>
     ed0:	10000003 	andne	r0, r0, r3
     ed4:	7c00008c 	stcvc	0, cr0, [r0], {140}	; 0x8c
     ed8:	01000001 	tsteq	r0, r1
     edc:	0003af9c 	muleq	r3, ip, pc	; <UNPREDICTABLE>
     ee0:	03e21c00 	mvneq	r1, #0, 24
     ee4:	028f0000 	addeq	r0, pc, #0
     ee8:	91020000 	mrsls	r0, (UNDEF: 2)
     eec:	0ad81964 	beq	ff607484 <_bss_end+0xff5fdd68>
     ef0:	87010000 	strhi	r0, [r1, -r0]
     ef4:	00026622 	andeq	r6, r2, r2, lsr #12
     ef8:	60910200 	addsvs	r0, r1, r0, lsl #4
     efc:	000ad119 	andeq	sp, sl, r9, lsl r1
     f00:	2f870100 	svccs	0x00870100
     f04:	000002a1 	andeq	r0, r0, r1, lsr #5
     f08:	195c9102 	ldmdbne	ip, {r1, r8, ip, pc}^
     f0c:	00000ed4 	ldrdeq	r0, [r0], -r4
     f10:	66448701 	strbvs	r8, [r4], -r1, lsl #14
     f14:	02000002 	andeq	r0, r0, #2
     f18:	691d5891 	ldmdbvs	sp, {r0, r4, r7, fp, ip, lr}
     f1c:	09890100 	stmibeq	r9, {r8}
     f20:	00000319 	andeq	r0, r0, r9, lsl r3
     f24:	1e749102 	expnes	f1, f2
     f28:	00008ce4 	andeq	r8, r0, r4, ror #25
     f2c:	00000098 	muleq	r0, r8, r0
     f30:	01006a1d 	tsteq	r0, sp, lsl sl
     f34:	03190e9c 	tsteq	r9, #156, 28	; 0x9c0
     f38:	91020000 	mrsls	r0, (UNDEF: 2)
     f3c:	8d0c1e70 	stchi	14, cr1, [ip, #-448]	; 0xfffffe40
     f40:	00600000 	rsbeq	r0, r0, r0
     f44:	631d0000 	tstvs	sp, #0
     f48:	0e9e0100 	fmleqe	f0, f6, f0
     f4c:	0000027d 	andeq	r0, r0, sp, ror r2
     f50:	006f9102 	rsbeq	r9, pc, r2, lsl #2
     f54:	6f1b0000 	svcvs	0x001b0000
     f58:	01000001 	tsteq	r0, r1
     f5c:	03c90b77 	biceq	r0, r9, #121856	; 0x1dc00
     f60:	8bb00000 	blhi	fec00f68 <_bss_end+0xfebf784c>
     f64:	00600000 	rsbeq	r0, r0, r0
     f68:	9c010000 	stcls	0, cr0, [r1], {-0}
     f6c:	000003e5 	andeq	r0, r0, r5, ror #7
     f70:	0003e21c 	andeq	lr, r3, ip, lsl r2
     f74:	00028f00 	andeq	r8, r2, r0, lsl #30
     f78:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     f7c:	00020519 	andeq	r0, r2, r9, lsl r5
     f80:	25770100 	ldrbcs	r0, [r7, #-256]!	; 0xffffff00
     f84:	0000029a 	muleq	r0, sl, r2
     f88:	00739102 	rsbseq	r9, r3, r2, lsl #2
     f8c:	00014b1b 	andeq	r4, r1, fp, lsl fp
     f90:	0b6a0100 	bleq	1a81398 <_bss_end+0x1a77c7c>
     f94:	000003ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
     f98:	00008b5c 	andeq	r8, r0, ip, asr fp
     f9c:	00000054 	andeq	r0, r0, r4, asr r0
     fa0:	043f9c01 	ldrteq	r9, [pc], #-3073	; fa8 <shift+0xfa8>
     fa4:	e21c0000 	ands	r0, ip, #0
     fa8:	8f000003 	svchi	0x00000003
     fac:	02000002 	andeq	r0, r0, #2
     fb0:	6e1f7491 	cfcmpsvs	r7, mvf15, mvf1
     fb4:	01006d75 	tsteq	r0, r5, ror sp
     fb8:	02662d6a 	rsbeq	r2, r6, #6784	; 0x1a80
     fbc:	91020000 	mrsls	r0, (UNDEF: 2)
     fc0:	0ae72070 	beq	ff9c9188 <_bss_end+0xff9bfa6c>
     fc4:	6c010000 	stcvs	0, cr0, [r1], {-0}
     fc8:	00026d23 	andeq	r6, r2, r3, lsr #26
     fcc:	5c030500 	cfstr32pl	mvfx0, [r3], {-0}
     fd0:	21000096 	swpcs	r0, r6, [r0]	; <UNPREDICTABLE>
     fd4:	00000ade 	ldrdeq	r0, [r0], -lr
     fd8:	3f116e01 	svccc	0x00116e01
     fdc:	05000004 	streq	r0, [r0, #-4]
     fe0:	0096f803 	addseq	pc, r6, r3, lsl #16
     fe4:	7d220000 	stcvc	0, cr0, [r2, #-0]
     fe8:	4f000002 	svcmi	0x00000002
     fec:	23000004 	movwcs	r0, #4
     ff0:	00000266 	andeq	r0, r0, r6, ror #4
     ff4:	2724000f 	strcs	r0, [r4, -pc]!
     ff8:	01000001 	tsteq	r0, r1
     ffc:	04690b63 	strbteq	r0, [r9], #-2915	; 0xfffff49d
    1000:	8b280000 	blhi	a01008 <_bss_end+0x9f78ec>
    1004:	00340000 	eorseq	r0, r4, r0
    1008:	9c010000 	stcls	0, cr0, [r1], {-0}
    100c:	00000485 	andeq	r0, r0, r5, lsl #9
    1010:	0003e21c 	andeq	lr, r3, ip, lsl r2
    1014:	00028f00 	andeq	r8, r2, r0, lsl #30
    1018:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    101c:	00087219 	andeq	r7, r8, r9, lsl r2
    1020:	37630100 	strbcc	r0, [r3, -r0, lsl #2]!
    1024:	00000032 	andeq	r0, r0, r2, lsr r0
    1028:	00709102 	rsbseq	r9, r0, r2, lsl #2
    102c:	0001031b 	andeq	r0, r1, fp, lsl r3
    1030:	0b570100 	bleq	15c1438 <_bss_end+0x15b7d1c>
    1034:	0000049f 	muleq	r0, pc, r4	; <UNPREDICTABLE>
    1038:	00008ab0 			; <UNDEFINED> instruction: 0x00008ab0
    103c:	00000078 	andeq	r0, r0, r8, ror r0
    1040:	04d29c01 	ldrbeq	r9, [r2], #3073	; 0xc01
    1044:	e21c0000 	ands	r0, ip, #0
    1048:	8f000003 	svchi	0x00000003
    104c:	02000002 	andeq	r0, r0, #2
    1050:	731f6c91 	tstvc	pc, #37120	; 0x9100
    1054:	01007274 	tsteq	r0, r4, ror r2
    1058:	02722c57 	rsbseq	r2, r2, #22272	; 0x5700
    105c:	91020000 	mrsls	r0, (UNDEF: 2)
    1060:	8ac41e68 	bhi	ff108a08 <_bss_end+0xff0ff2ec>
    1064:	004c0000 	subeq	r0, ip, r0
    1068:	691d0000 	ldmdbvs	sp, {}	; <UNPREDICTABLE>
    106c:	17590100 	ldrbne	r0, [r9, -r0, lsl #2]
    1070:	00000266 	andeq	r0, r0, r6, ror #4
    1074:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1078:	00df1b00 	sbcseq	r1, pc, r0, lsl #22
    107c:	45010000 	strmi	r0, [r1, #-0]
    1080:	0004ec0b 	andeq	lr, r4, fp, lsl #24
    1084:	008a0800 	addeq	r0, sl, r0, lsl #16
    1088:	0000a800 	andeq	sl, r0, r0, lsl #16
    108c:	069c0100 	ldreq	r0, [ip], r0, lsl #2
    1090:	1c000005 	stcne	0, cr0, [r0], {5}
    1094:	000003e2 	andeq	r0, r0, r2, ror #7
    1098:	0000028f 	andeq	r0, r0, pc, lsl #5
    109c:	1f749102 	svcne	0x00749102
    10a0:	45010063 	strmi	r0, [r1, #-99]	; 0xffffff9d
    10a4:	00027d25 	andeq	r7, r2, r5, lsr #26
    10a8:	73910200 	orrsvc	r0, r1, #0, 4
    10ac:	01c72400 	biceq	r2, r7, r0, lsl #8
    10b0:	40010000 	andmi	r0, r1, r0
    10b4:	00052006 	andeq	r2, r5, r6
    10b8:	008ec000 	addeq	ip, lr, r0
    10bc:	00002c00 	andeq	r2, r0, r0, lsl #24
    10c0:	2d9c0100 	ldfcss	f0, [ip]
    10c4:	1c000005 	stcne	0, cr0, [r0], {5}
    10c8:	000003e2 	andeq	r0, r0, r2, ror #7
    10cc:	0000028f 	andeq	r0, r0, pc, lsl #5
    10d0:	00749102 	rsbseq	r9, r4, r2, lsl #2
    10d4:	0001e124 	andeq	lr, r1, r4, lsr #2
    10d8:	06300100 	ldrteq	r0, [r0], -r0, lsl #2
    10dc:	00000547 	andeq	r0, r0, r7, asr #10
    10e0:	000088d8 	ldrdeq	r8, [r0], -r8	; <UNPREDICTABLE>
    10e4:	00000130 	andeq	r0, r0, r0, lsr r1
    10e8:	059d9c01 	ldreq	r9, [sp, #3073]	; 0xc01
    10ec:	e21c0000 	ands	r0, ip, #0
    10f0:	8f000003 	svchi	0x00000003
    10f4:	02000002 	andeq	r0, r0, #2
    10f8:	e8256491 	stmda	r5!, {r0, r4, r7, sl, sp, lr}
    10fc:	b0000088 	andlt	r0, r0, r8, lsl #1
    1100:	85000000 	strhi	r0, [r0, #-0]
    1104:	1d000005 	stcne	0, cr0, [r0, #-20]	; 0xffffffec
    1108:	32010079 	andcc	r0, r1, #121	; 0x79
    110c:	00026617 	andeq	r6, r2, r7, lsl r6
    1110:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1114:	0089041e 	addeq	r0, r9, lr, lsl r4
    1118:	00008400 	andeq	r8, r0, r0, lsl #8
    111c:	00781d00 	rsbseq	r1, r8, r0, lsl #26
    1120:	661b3401 	ldrvs	r3, [fp], -r1, lsl #8
    1124:	02000002 	andeq	r0, r0, #2
    1128:	00007091 	muleq	r0, r1, r0
    112c:	0089981e 	addeq	r9, r9, lr, lsl r8
    1130:	00006000 	andeq	r6, r0, r0
    1134:	00781d00 	rsbseq	r1, r8, r0, lsl #26
    1138:	66173a01 	ldrvs	r3, [r7], -r1, lsl #20
    113c:	02000002 	andeq	r0, r0, #2
    1140:	00006c91 	muleq	r0, r1, ip
    1144:	0001931b 	andeq	r9, r1, fp, lsl r3
    1148:	06210100 	strteq	r0, [r1], -r0, lsl #2
    114c:	000005b7 			; <UNDEFINED> instruction: 0x000005b7
    1150:	00008e38 	andeq	r8, r0, r8, lsr lr
    1154:	00000088 	andeq	r0, r0, r8, lsl #1
    1158:	05c49c01 	strbeq	r9, [r4, #3073]	; 0xc01
    115c:	e21c0000 	ands	r0, ip, #0
    1160:	8f000003 	svchi	0x00000003
    1164:	02000002 	andeq	r0, r0, #2
    1168:	1b007491 	blne	1e3b4 <_bss_end+0x14c98>
    116c:	000000c4 	andeq	r0, r0, r4, asr #1
    1170:	de061401 	cdple	4, 0, cr1, cr6, cr1, {0}
    1174:	30000005 	andcc	r0, r0, r5
    1178:	a8000088 	stmdage	r0, {r3, r7}
    117c:	01000000 	mrseq	r0, (UNDEF: 0)
    1180:	0006199c 	muleq	r6, ip, r9
    1184:	03e21c00 	mvneq	r1, #0, 24
    1188:	028f0000 	addeq	r0, pc, #0
    118c:	91020000 	mrsls	r0, (UNDEF: 2)
    1190:	88481e6c 	stmdahi	r8, {r2, r3, r5, r6, r9, sl, fp, ip}^
    1194:	00840000 	addeq	r0, r4, r0
    1198:	791d0000 	ldmdbvc	sp, {}	; <UNPREDICTABLE>
    119c:	17180100 	ldrne	r0, [r8, -r0, lsl #2]
    11a0:	00000266 	andeq	r0, r0, r6, ror #4
    11a4:	1e749102 	expnes	f1, f2
    11a8:	00008864 	andeq	r8, r0, r4, ror #16
    11ac:	00000058 	andeq	r0, r0, r8, asr r0
    11b0:	0100781d 	tsteq	r0, sp, lsl r8
    11b4:	02661b1a 	rsbeq	r1, r6, #26624	; 0x6800
    11b8:	91020000 	mrsls	r0, (UNDEF: 2)
    11bc:	00000070 	andeq	r0, r0, r0, ror r0
    11c0:	0001ad24 	andeq	sl, r1, r4, lsr #26
    11c4:	060e0100 	streq	r0, [lr], -r0, lsl #2
    11c8:	00000633 	andeq	r0, r0, r3, lsr r6
    11cc:	00008e00 	andeq	r8, r0, r0, lsl #28
    11d0:	00000038 	andeq	r0, r0, r8, lsr r0
    11d4:	06409c01 	strbeq	r9, [r0], -r1, lsl #24
    11d8:	e21c0000 	ands	r0, ip, #0
    11dc:	8f000003 	svchi	0x00000003
    11e0:	02000002 	andeq	r0, r0, #2
    11e4:	26007491 			; <UNDEFINED> instruction: 0x26007491
    11e8:	00000096 	muleq	r0, r6, r0
    11ec:	51010501 	tstpl	r1, r1, lsl #10
    11f0:	00000006 	andeq	r0, r0, r6
    11f4:	0000067f 	andeq	r0, r0, pc, ror r6
    11f8:	0003e227 	andeq	lr, r3, r7, lsr #4
    11fc:	00028f00 	andeq	r8, r2, r0, lsl #30
    1200:	098a2800 	stmibeq	sl, {fp, sp}
    1204:	05010000 	streq	r0, [r1, #-0]
    1208:	00026621 	andeq	r6, r2, r1, lsr #12
    120c:	0a3e2800 	beq	f8b214 <_bss_end+0xf81af8>
    1210:	05010000 	streq	r0, [r1, #-0]
    1214:	00026641 	andeq	r6, r2, r1, asr #12
    1218:	09f12800 	ldmibeq	r1!, {fp, sp}^
    121c:	05010000 	streq	r0, [r1, #-0]
    1220:	00026655 	andeq	r6, r2, r5, asr r6
    1224:	40290000 	eormi	r0, r9, r0
    1228:	96000006 	strls	r0, [r0], -r6
    122c:	96000008 	strls	r0, [r0], -r8
    1230:	b8000006 	stmdalt	r0, {r1, r2}
    1234:	78000087 	stmdavc	r0, {r0, r1, r2, r7}
    1238:	01000000 	mrseq	r0, (UNDEF: 0)
    123c:	06512a9c 			; <UNDEFINED> instruction: 0x06512a9c
    1240:	91020000 	mrsls	r0, (UNDEF: 2)
    1244:	065a2a74 			; <UNDEFINED> instruction: 0x065a2a74
    1248:	91020000 	mrsls	r0, (UNDEF: 2)
    124c:	06662a70 			; <UNDEFINED> instruction: 0x06662a70
    1250:	91020000 	mrsls	r0, (UNDEF: 2)
    1254:	06722a6c 	ldrbteq	r2, [r2], -ip, ror #20
    1258:	91020000 	mrsls	r0, (UNDEF: 2)
    125c:	6f000068 	svcvs	0x00000068
    1260:	04000005 	streq	r0, [r0], #-5
    1264:	0007d700 	andeq	sp, r7, r0, lsl #14
    1268:	a0010400 	andge	r0, r1, r0, lsl #8
    126c:	04000000 	streq	r0, [r0], #-0
    1270:	00000b86 	andeq	r0, r0, r6, lsl #23
    1274:	00000166 	andeq	r0, r0, r6, ror #2
    1278:	00008eec 	andeq	r8, r0, ip, ror #29
    127c:	000002fc 	strdeq	r0, [r0], -ip
    1280:	00000920 	andeq	r0, r0, r0, lsr #18
    1284:	ff080102 			; <UNDEFINED> instruction: 0xff080102
    1288:	03000002 	movweq	r0, #2
    128c:	00000025 	andeq	r0, r0, r5, lsr #32
    1290:	b8050202 	stmdalt	r5, {r1, r9}
    1294:	04000001 	streq	r0, [r0], #-1
    1298:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
    129c:	01020074 	tsteq	r2, r4, ror r0
    12a0:	0002f608 	andeq	pc, r2, r8, lsl #12
    12a4:	07020200 	streq	r0, [r2, -r0, lsl #4]
    12a8:	00000360 	andeq	r0, r0, r0, ror #6
    12ac:	00032905 	andeq	r2, r3, r5, lsl #18
    12b0:	070b0500 	streq	r0, [fp, -r0, lsl #10]
    12b4:	0000005e 	andeq	r0, r0, lr, asr r0
    12b8:	00004d03 	andeq	r4, r0, r3, lsl #26
    12bc:	07040200 	streq	r0, [r4, -r0, lsl #4]
    12c0:	000011da 	ldrdeq	r1, [r0], -sl
    12c4:	00005e03 	andeq	r5, r0, r3, lsl #28
    12c8:	61680600 	cmnvs	r8, r0, lsl #12
    12cc:	0702006c 	streq	r0, [r2, -ip, rrx]
    12d0:	0001720b 	andeq	r7, r1, fp, lsl #4
    12d4:	02ba0700 	adcseq	r0, sl, #0, 14
    12d8:	0a020000 	beq	812e0 <_bss_end+0x77bc4>
    12dc:	0001791d 	andeq	r7, r1, sp, lsl r9
    12e0:	00000000 	andeq	r0, r0, r0
    12e4:	03120720 	tsteq	r2, #32, 14	; 0x800000
    12e8:	0d020000 	stceq	0, cr0, [r2, #-0]
    12ec:	0001791d 	andeq	r7, r1, sp, lsl r9
    12f0:	20000000 	andcs	r0, r0, r0
    12f4:	039e0820 	orrseq	r0, lr, #32, 16	; 0x200000
    12f8:	10020000 	andne	r0, r2, r0
    12fc:	00005918 	andeq	r5, r0, r8, lsl r9
    1300:	50073600 	andpl	r3, r7, r0, lsl #12
    1304:	02000004 	andeq	r0, r0, #4
    1308:	01791d42 	cmneq	r9, r2, asr #26
    130c:	50000000 	andpl	r0, r0, r0
    1310:	d7092021 	strle	r2, [r9, -r1, lsr #32]
    1314:	05000001 	streq	r0, [r0, #-1]
    1318:	00003804 	andeq	r3, r0, r4, lsl #16
    131c:	10440200 	subne	r0, r4, r0, lsl #4
    1320:	00000150 	andeq	r0, r0, r0, asr r1
    1324:	5152490a 	cmppl	r2, sl, lsl #18
    1328:	140b0000 	strne	r0, [fp], #-0
    132c:	01000002 	tsteq	r0, r2
    1330:	0004700b 	andeq	r7, r4, fp
    1334:	040b1000 	streq	r1, [fp], #-0
    1338:	11000003 	tstne	r0, r3
    133c:	0003470b 	andeq	r4, r3, fp, lsl #14
    1340:	7b0b1200 	blvc	2c5b48 <_bss_end+0x2bc42c>
    1344:	13000003 	movwne	r0, #3
    1348:	00030b0b 	andeq	r0, r3, fp, lsl #22
    134c:	7f0b1400 	svcvc	0x000b1400
    1350:	15000004 	strne	r0, [r0, #-4]
    1354:	0003f40b 	andeq	pc, r3, fp, lsl #8
    1358:	b70b1600 	strlt	r1, [fp, -r0, lsl #12]
    135c:	17000004 	strne	r0, [r0, -r4]
    1360:	00034e0b 	andeq	r4, r3, fp, lsl #28
    1364:	590b1800 	stmdbpl	fp, {fp, ip}
    1368:	19000004 	stmdbne	r0, {r2}
    136c:	00038c0b 	andeq	r8, r3, fp, lsl #24
    1370:	a40b1a00 	strge	r1, [fp], #-2560	; 0xfffff600
    1374:	20000002 	andcs	r0, r0, r2
    1378:	0002af0b 	andeq	sl, r2, fp, lsl #30
    137c:	940b2100 	strls	r2, [fp], #-256	; 0xffffff00
    1380:	22000003 	andcs	r0, r0, #3
    1384:	0002880b 	andeq	r8, r2, fp, lsl #16
    1388:	820b2400 	andhi	r2, fp, #0, 8
    138c:	25000003 	strcs	r0, [r0, #-3]
    1390:	0002d90b 	andeq	sp, r2, fp, lsl #18
    1394:	e40b3000 	str	r3, [fp], #-0
    1398:	31000002 	tstcc	r0, r2
    139c:	0001cc0b 	andeq	ip, r1, fp, lsl #24
    13a0:	730b3200 	movwvc	r3, #45568	; 0xb200
    13a4:	34000003 	strcc	r0, [r0], #-3
    13a8:	0001c20b 	andeq	ip, r1, fp, lsl #4
    13ac:	0c003500 	cfstr32eq	mvfx3, [r0], {-0}
    13b0:	00000244 	andeq	r0, r0, r4, asr #4
    13b4:	00380405 	eorseq	r0, r8, r5, lsl #8
    13b8:	6a020000 	bvs	813c0 <_bss_end+0x77ca4>
    13bc:	04760b10 	ldrbteq	r0, [r6], #-2832	; 0xfffff4f0
    13c0:	0b000000 	bleq	13c8 <shift+0x13c8>
    13c4:	00000356 	andeq	r0, r0, r6, asr r3
    13c8:	035b0b01 	cmpeq	fp, #1024	; 0x400
    13cc:	00020000 	andeq	r0, r2, r0
    13d0:	07040200 	streq	r0, [r4, -r0, lsl #4]
    13d4:	000011d5 	ldrdeq	r1, [r0], -r5
    13d8:	00017203 	andeq	r7, r1, r3, lsl #4
    13dc:	00760d00 	rsbseq	r0, r6, r0, lsl #26
    13e0:	860d0000 	strhi	r0, [sp], -r0
    13e4:	0d000000 	stceq	0, cr0, [r0, #-0]
    13e8:	00000096 	muleq	r0, r6, r0
    13ec:	0000a30d 	andeq	sl, r0, sp, lsl #6
    13f0:	0b140e00 	bleq	504bf8 <_bss_end+0x4fb4dc>
    13f4:	03040000 	movweq	r0, #16384	; 0x4000
    13f8:	02560706 	subseq	r0, r6, #1572864	; 0x180000
    13fc:	d60f0000 	strle	r0, [pc], -r0
    1400:	03000001 	movweq	r0, #1
    1404:	025c190a 	subseq	r1, ip, #163840	; 0x28000
    1408:	10000000 	andne	r0, r0, r0
    140c:	00000b14 	andeq	r0, r0, r4, lsl fp
    1410:	54050d03 	strpl	r0, [r5], #-3331	; 0xfffff2fd
    1414:	61000002 	tstvs	r0, r2
    1418:	01000002 	tsteq	r0, r2
    141c:	000001c5 	andeq	r0, r0, r5, asr #3
    1420:	000001d0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    1424:	00026111 	andeq	r6, r2, r1, lsl r1
    1428:	005e1200 	subseq	r1, lr, r0, lsl #4
    142c:	13000000 	movwne	r0, #0
    1430:	000002ef 	andeq	r0, r0, pc, ror #5
    1434:	1c0a1003 	stcne	0, cr1, [sl], {3}
    1438:	01000002 	tsteq	r0, r2
    143c:	000001e5 	andeq	r0, r0, r5, ror #3
    1440:	000001f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    1444:	00026111 	andeq	r6, r2, r1, lsl r1
    1448:	01501200 	cmpeq	r0, r0, lsl #4
    144c:	13000000 	movwne	r0, #0
    1450:	00000332 	andeq	r0, r0, r2, lsr r3
    1454:	8e0a1203 	cdphi	2, 0, cr1, cr10, cr3, {0}
    1458:	01000004 	tsteq	r0, r4
    145c:	00000205 	andeq	r0, r0, r5, lsl #4
    1460:	00000210 	andeq	r0, r0, r0, lsl r2
    1464:	00026111 	andeq	r6, r2, r1, lsl r1
    1468:	01501200 	cmpeq	r0, r0, lsl #4
    146c:	13000000 	movwne	r0, #0
    1470:	000003e7 	andeq	r0, r0, r7, ror #7
    1474:	610a1503 	tstvs	sl, r3, lsl #10
    1478:	01000002 	tsteq	r0, r2
    147c:	00000225 	andeq	r0, r0, r5, lsr #4
    1480:	00000235 	andeq	r0, r0, r5, lsr r2
    1484:	00026111 	andeq	r6, r2, r1, lsl r1
    1488:	00b31200 	adcseq	r1, r3, r0, lsl #4
    148c:	4d120000 	ldcmi	0, cr0, [r2, #-0]
    1490:	00000000 	andeq	r0, r0, r0
    1494:	00033a14 	andeq	r3, r3, r4, lsl sl
    1498:	0e170300 	cdpeq	3, 1, cr0, cr7, cr0, {0}
    149c:	000001df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    14a0:	0000004d 	andeq	r0, r0, sp, asr #32
    14a4:	00024a01 	andeq	r4, r2, r1, lsl #20
    14a8:	02611100 	rsbeq	r1, r1, #0, 2
    14ac:	b3120000 	tstlt	r2, #0
    14b0:	00000000 	andeq	r0, r0, r0
    14b4:	5e041500 	cfsh32pl	mvfx1, mvfx4, #0
    14b8:	03000000 	movweq	r0, #0
    14bc:	00000256 	andeq	r0, r0, r6, asr r2
    14c0:	01920415 	orrseq	r0, r2, r5, lsl r4
    14c4:	9f160000 	svcls	0x00160000
    14c8:	03000002 	movweq	r0, #2
    14cc:	01920d1a 	orrseq	r0, r2, sl, lsl sp
    14d0:	1a090000 	bne	2414d8 <_bss_end+0x237dbc>
    14d4:	0500000c 	streq	r0, [r0, #-12]
    14d8:	00003804 	andeq	r3, r0, r4, lsl #16
    14dc:	0c060400 	cfstrseq	mvf0, [r6], {-0}
    14e0:	00000292 	muleq	r0, r2, r2
    14e4:	000b410b 	andeq	r4, fp, fp, lsl #2
    14e8:	480b0000 	stmdami	fp, {}	; <UNPREDICTABLE>
    14ec:	0100000b 	tsteq	r0, fp
    14f0:	0c7b0900 			; <UNDEFINED> instruction: 0x0c7b0900
    14f4:	04050000 	streq	r0, [r5], #-0
    14f8:	00000038 	andeq	r0, r0, r8, lsr r0
    14fc:	df0c0c04 	svcle	0x000c0c04
    1500:	17000002 	strne	r0, [r0, -r2]
    1504:	00000b7e 	andeq	r0, r0, lr, ror fp
    1508:	8b1704b0 	blhi	5c27d0 <_bss_end+0x5b90b4>
    150c:	6000000c 	andvs	r0, r0, ip
    1510:	0c4a1709 	mcrreq	7, 0, r1, sl, cr9
    1514:	12c00000 	sbcne	r0, r0, #0
    1518:	000b1917 	andeq	r1, fp, r7, lsl r9
    151c:	17258000 	strne	r8, [r5, -r0]!
    1520:	00000c41 	andeq	r0, r0, r1, asr #24
    1524:	fd174b00 	ldc2	11, cr4, [r7, #-0]	; <UNPREDICTABLE>
    1528:	0000000a 	andeq	r0, r0, sl
    152c:	0b271796 	bleq	9c738c <_bss_end+0x9bdc70>
    1530:	e1000000 	mrs	r0, (UNDEF: 0)
    1534:	000af318 	andeq	pc, sl, r8, lsl r3	; <UNPREDICTABLE>
    1538:	01c20000 	biceq	r0, r2, r0
    153c:	210e0000 	mrscs	r0, (UNDEF: 14)
    1540:	0400000b 	streq	r0, [r0], #-11
    1544:	9a071804 	bls	1c755c <_bss_end+0x1bde40>
    1548:	0f000003 	svceq	0x00000003
    154c:	00000b4f 	andeq	r0, r0, pc, asr #22
    1550:	9a0b1b04 	bls	2c8168 <_bss_end+0x2bea4c>
    1554:	00000003 	andeq	r0, r0, r3
    1558:	000b2110 	andeq	r2, fp, r0, lsl r1
    155c:	051e0400 	ldreq	r0, [lr, #-1024]	; 0xfffffc00
    1560:	00000bea 	andeq	r0, r0, sl, ror #23
    1564:	000003a0 	andeq	r0, r0, r0, lsr #7
    1568:	00031201 	andeq	r1, r3, r1, lsl #4
    156c:	00031d00 	andeq	r1, r3, r0, lsl #26
    1570:	03a01100 	moveq	r1, #0, 2
    1574:	9a120000 	bls	48157c <_bss_end+0x477e60>
    1578:	00000003 	andeq	r0, r0, r3
    157c:	000c2c13 	andeq	r2, ip, r3, lsl ip
    1580:	0a200400 	beq	802588 <_bss_end+0x7f8e6c>
    1584:	00000bfd 	strdeq	r0, [r0], -sp
    1588:	00033201 	andeq	r3, r3, r1, lsl #4
    158c:	00033d00 	andeq	r3, r3, r0, lsl #26
    1590:	03a01100 	moveq	r1, #0, 2
    1594:	73120000 	tstvc	r2, #0
    1598:	00000002 	andeq	r0, r0, r2
    159c:	000c5213 	andeq	r5, ip, r3, lsl r2
    15a0:	0a210400 	beq	8425a8 <_bss_end+0x838e8c>
    15a4:	00000c60 	andeq	r0, r0, r0, ror #24
    15a8:	00035201 	andeq	r5, r3, r1, lsl #4
    15ac:	00035d00 	andeq	r5, r3, r0, lsl #26
    15b0:	03a01100 	moveq	r1, #0, 2
    15b4:	92120000 	andsls	r0, r2, #0
    15b8:	00000002 	andeq	r0, r0, r2
    15bc:	000b3b13 	andeq	r3, fp, r3, lsl fp
    15c0:	0a250400 	beq	9425c8 <_bss_end+0x938eac>
    15c4:	00000bd8 	ldrdeq	r0, [r0], -r8
    15c8:	00037201 	andeq	r7, r3, r1, lsl #4
    15cc:	00037d00 	andeq	r7, r3, r0, lsl #26
    15d0:	03a01100 	moveq	r1, #0, 2
    15d4:	25120000 	ldrcs	r0, [r2, #-0]
    15d8:	00000000 	andeq	r0, r0, r0
    15dc:	000b3b19 	andeq	r3, fp, r9, lsl fp
    15e0:	0a260400 	beq	9825e8 <_bss_end+0x978ecc>
    15e4:	00000b6a 	andeq	r0, r0, sl, ror #22
    15e8:	00038e01 	andeq	r8, r3, r1, lsl #28
    15ec:	03a01100 	moveq	r1, #0, 2
    15f0:	ab120000 	blge	4815f8 <_bss_end+0x477edc>
    15f4:	00000003 	andeq	r0, r0, r3
    15f8:	92041a00 	andls	r1, r4, #0, 20
    15fc:	15000001 	strne	r0, [r0, #-1]
    1600:	0002df04 	andeq	sp, r2, r4, lsl #30
    1604:	03a00300 	moveq	r0, #0, 6
    1608:	04150000 	ldreq	r0, [r5], #-0
    160c:	0000002c 	andeq	r0, r0, ip, lsr #32
    1610:	000b6316 	andeq	r6, fp, r6, lsl r3
    1614:	0e290400 	cdpeq	4, 2, cr0, cr9, cr0, {0}
    1618:	000002df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    161c:	d6020102 	strle	r0, [r2], -r2, lsl #2
    1620:	1b000005 	blne	163c <shift+0x163c>
    1624:	000003b1 			; <UNDEFINED> instruction: 0x000003b1
    1628:	05070501 	streq	r0, [r7, #-1281]	; 0xfffffaff
    162c:	00970803 	addseq	r0, r7, r3, lsl #16
    1630:	0b541c00 	bleq	1508638 <_bss_end+0x14fef1c>
    1634:	91cc0000 	bicls	r0, ip, r0
    1638:	001c0000 	andseq	r0, ip, r0
    163c:	9c010000 	stcls	0, cr0, [r1], {-0}
    1640:	0003ad1d 	andeq	sl, r3, sp, lsl sp
    1644:	00917800 	addseq	r7, r1, r0, lsl #16
    1648:	00005400 	andeq	r5, r0, r0, lsl #8
    164c:	139c0100 	orrsne	r0, ip, #0, 2
    1650:	1e000004 	cdpne	0, 0, cr0, cr0, cr4, {0}
    1654:	000002ca 	andeq	r0, r0, sl, asr #5
    1658:	38013801 	stmdacc	r1, {r0, fp, ip, sp}
    165c:	02000000 	andeq	r0, r0, #0
    1660:	d71e7491 			; <UNDEFINED> instruction: 0xd71e7491
    1664:	01000003 	tsteq	r0, r3
    1668:	00380138 	eorseq	r0, r8, r8, lsr r1
    166c:	91020000 	mrsls	r0, (UNDEF: 2)
    1670:	7d1f0070 	ldcvc	0, cr0, [pc, #-448]	; 14b8 <shift+0x14b8>
    1674:	01000003 	tsteq	r0, r3
    1678:	042d0632 	strteq	r0, [sp], #-1586	; 0xfffff9ce
    167c:	910c0000 	mrsls	r0, (UNDEF: 12)
    1680:	006c0000 	rsbeq	r0, ip, r0
    1684:	9c010000 	stcls	0, cr0, [r1], {-0}
    1688:	00000456 	andeq	r0, r0, r6, asr r4
    168c:	0003e220 	andeq	lr, r3, r0, lsr #4
    1690:	0003a600 	andeq	sl, r3, r0, lsl #12
    1694:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1698:	72747321 	rsbsvc	r7, r4, #-2080374784	; 0x84000000
    169c:	1f320100 	svcne	0x00320100
    16a0:	000003ab 	andeq	r0, r0, fp, lsr #7
    16a4:	22689102 	rsbcs	r9, r8, #-2147483648	; 0x80000000
    16a8:	34010069 	strcc	r0, [r1], #-105	; 0xffffff97
    16ac:	00003809 	andeq	r3, r0, r9, lsl #16
    16b0:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    16b4:	035d1f00 	cmpeq	sp, #0, 30
    16b8:	24010000 	strcs	r0, [r1], #-0
    16bc:	00047006 	andeq	r7, r4, r6
    16c0:	00908000 	addseq	r8, r0, r0
    16c4:	00008c00 	andeq	r8, r0, r0, lsl #24
    16c8:	999c0100 	ldmibls	ip, {r8}
    16cc:	20000004 	andcs	r0, r0, r4
    16d0:	000003e2 	andeq	r0, r0, r2, ror #7
    16d4:	000003a6 	andeq	r0, r0, r6, lsr #7
    16d8:	216c9102 	cmncs	ip, r2, lsl #2
    16dc:	24010063 	strcs	r0, [r1], #-99	; 0xffffff9d
    16e0:	00002518 	andeq	r2, r0, r8, lsl r5
    16e4:	6b910200 	blvs	fe441eec <_bss_end+0xfe4387d0>
    16e8:	00020523 	andeq	r0, r2, r3, lsr #10
    16ec:	12260100 	eorne	r0, r6, #0, 2
    16f0:	0000005e 	andeq	r0, r0, lr, asr r0
    16f4:	00749102 	rsbseq	r9, r4, r2, lsl #2
    16f8:	00033d1f 	andeq	r3, r3, pc, lsl sp
    16fc:	06180100 	ldreq	r0, [r8], -r0, lsl #2
    1700:	000004b3 			; <UNDEFINED> instruction: 0x000004b3
    1704:	00008fec 	andeq	r8, r0, ip, ror #31
    1708:	00000094 	muleq	r0, r4, r0
    170c:	04ed9c01 	strbteq	r9, [sp], #3073	; 0xc01
    1710:	e2200000 	eor	r0, r0, #0
    1714:	a6000003 	strge	r0, [r0], -r3
    1718:	02000003 	andeq	r0, r0, #3
    171c:	3c1e6c91 	ldccc	12, cr6, [lr], {145}	; 0x91
    1720:	0100000c 	tsteq	r0, ip
    1724:	02922b18 	addseq	r2, r2, #24, 22	; 0x6000
    1728:	91020000 	mrsls	r0, (UNDEF: 2)
    172c:	0b302468 	bleq	c0a8d4 <_bss_end+0xc011b8>
    1730:	1a010000 	bne	41738 <_bss_end+0x3801c>
    1734:	0000651c 	andeq	r6, r0, ip, lsl r5
    1738:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    173c:	6c617622 	stclvs	6, cr7, [r1], #-136	; 0xffffff78
    1740:	181b0100 	ldmdane	fp, {r8}
    1744:	00000065 	andeq	r0, r0, r5, rrx
    1748:	00709102 	rsbseq	r9, r0, r2, lsl #2
    174c:	00031d1f 	andeq	r1, r3, pc, lsl sp
    1750:	06120100 	ldreq	r0, [r2], -r0, lsl #2
    1754:	00000507 	andeq	r0, r0, r7, lsl #10
    1758:	00008f90 	muleq	r0, r0, pc	; <UNPREDICTABLE>
    175c:	0000005c 	andeq	r0, r0, ip, asr r0
    1760:	05239c01 	streq	r9, [r3, #-3073]!	; 0xfffff3ff
    1764:	e2200000 	eor	r0, r0, #0
    1768:	a6000003 	strge	r0, [r0], -r3
    176c:	02000003 	andeq	r0, r0, #3
    1770:	6c216c91 	stcvs	12, cr6, [r1], #-580	; 0xfffffdbc
    1774:	01006e65 	tsteq	r0, r5, ror #28
    1778:	02732f12 	rsbseq	r2, r3, #18, 30	; 0x48
    177c:	91020000 	mrsls	r0, (UNDEF: 2)
    1780:	f9250068 			; <UNDEFINED> instruction: 0xf9250068
    1784:	01000002 	tsteq	r0, r2
    1788:	05340107 	ldreq	r0, [r4, #-263]!	; 0xfffffef9
    178c:	4a000000 	bmi	1794 <shift+0x1794>
    1790:	26000005 	strcs	r0, [r0], -r5
    1794:	000003e2 	andeq	r0, r0, r2, ror #7
    1798:	000003a6 	andeq	r0, r0, r6, lsr #7
    179c:	78756127 	ldmdavc	r5!, {r0, r1, r2, r5, r8, sp, lr}^
    17a0:	14070100 	strne	r0, [r7], #-256	; 0xffffff00
    17a4:	0000039a 	muleq	r0, sl, r3
    17a8:	05232800 	streq	r2, [r3, #-2048]!	; 0xfffff800
    17ac:	0b060000 	bleq	1817b4 <_bss_end+0x178098>
    17b0:	05610000 	strbeq	r0, [r1, #-0]!
    17b4:	8eec0000 	cdphi	0, 14, cr0, cr12, cr0, {0}
    17b8:	00a40000 	adceq	r0, r4, r0
    17bc:	9c010000 	stcls	0, cr0, [r1], {-0}
    17c0:	00053429 	andeq	r3, r5, r9, lsr #8
    17c4:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    17c8:	00053d29 	andeq	r3, r5, r9, lsr #26
    17cc:	70910200 	addsvc	r0, r1, r0, lsl #4
    17d0:	03d60000 	bicseq	r0, r6, #0
    17d4:	00040000 	andeq	r0, r4, r0
    17d8:	00000a5f 	andeq	r0, r0, pc, asr sl
    17dc:	00a00104 	adceq	r0, r0, r4, lsl #2
    17e0:	93040000 	movwls	r0, #16384	; 0x4000
    17e4:	6600000c 	strvs	r0, [r0], -ip
    17e8:	e8000001 	stmda	r0, {r0}
    17ec:	6c000091 	stcvs	0, cr0, [r0], {145}	; 0x91
    17f0:	3f000000 	svccc	0x00000000
    17f4:	0200000b 	andeq	r0, r0, #11
    17f8:	02ff0801 	rscseq	r0, pc, #65536	; 0x10000
    17fc:	25030000 	strcs	r0, [r3, #-0]
    1800:	02000000 	andeq	r0, r0, #0
    1804:	01b80502 			; <UNDEFINED> instruction: 0x01b80502
    1808:	04040000 	streq	r0, [r4], #-0
    180c:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
    1810:	08010200 	stmdaeq	r1, {r9}
    1814:	000002f6 	strdeq	r0, [r0], -r6
    1818:	60070202 	andvs	r0, r7, r2, lsl #4
    181c:	05000003 	streq	r0, [r0, #-3]
    1820:	00000329 	andeq	r0, r0, r9, lsr #6
    1824:	5e070b05 	vmlapl.f64	d0, d7, d5
    1828:	03000000 	movweq	r0, #0
    182c:	0000004d 	andeq	r0, r0, sp, asr #32
    1830:	da070402 	ble	1c2840 <_bss_end+0x1b9124>
    1834:	06000011 			; <UNDEFINED> instruction: 0x06000011
    1838:	0000005e 	andeq	r0, r0, lr, asr r0
    183c:	005e0407 	subseq	r0, lr, r7, lsl #8
    1840:	6a030000 	bvs	c1848 <_bss_end+0xb812c>
    1844:	02000000 	andeq	r0, r0, #0
    1848:	05d60201 	ldrbeq	r0, [r6, #513]	; 0x201
    184c:	68080000 	stmdavs	r8, {}	; <UNPREDICTABLE>
    1850:	02006c61 	andeq	r6, r0, #24832	; 0x6100
    1854:	01840b07 	orreq	r0, r4, r7, lsl #22
    1858:	ba090000 	blt	241860 <_bss_end+0x238144>
    185c:	02000002 	andeq	r0, r0, #2
    1860:	018b1d0a 	orreq	r1, fp, sl, lsl #26
    1864:	00000000 	andeq	r0, r0, r0
    1868:	12092000 	andne	r2, r9, #0
    186c:	02000003 	andeq	r0, r0, #3
    1870:	018b1d0d 	orreq	r1, fp, sp, lsl #26
    1874:	00000000 	andeq	r0, r0, r0
    1878:	9e0a2020 	cdpls	0, 0, cr2, cr10, cr0, {1}
    187c:	02000003 	andeq	r0, r0, #3
    1880:	00591810 	subseq	r1, r9, r0, lsl r8
    1884:	09360000 	ldmdbeq	r6!, {}	; <UNPREDICTABLE>
    1888:	00000450 	andeq	r0, r0, r0, asr r4
    188c:	8b1d4202 	blhi	75209c <_bss_end+0x748980>
    1890:	00000001 	andeq	r0, r0, r1
    1894:	0b202150 	bleq	809ddc <_bss_end+0x8006c0>
    1898:	000001d7 	ldrdeq	r0, [r0], -r7
    189c:	00380405 	eorseq	r0, r8, r5, lsl #8
    18a0:	44020000 	strmi	r0, [r2], #-0
    18a4:	00016210 	andeq	r6, r1, r0, lsl r2
    18a8:	52490c00 	subpl	r0, r9, #0, 24
    18ac:	0d000051 	stceq	0, cr0, [r0, #-324]	; 0xfffffebc
    18b0:	00000214 	andeq	r0, r0, r4, lsl r2
    18b4:	04700d01 	ldrbteq	r0, [r0], #-3329	; 0xfffff2ff
    18b8:	0d100000 	ldceq	0, cr0, [r0, #-0]
    18bc:	00000304 	andeq	r0, r0, r4, lsl #6
    18c0:	03470d11 	movteq	r0, #32017	; 0x7d11
    18c4:	0d120000 	ldceq	0, cr0, [r2, #-0]
    18c8:	0000037b 	andeq	r0, r0, fp, ror r3
    18cc:	030b0d13 	movweq	r0, #48403	; 0xbd13
    18d0:	0d140000 	ldceq	0, cr0, [r4, #-0]
    18d4:	0000047f 	andeq	r0, r0, pc, ror r4
    18d8:	03f40d15 	mvnseq	r0, #1344	; 0x540
    18dc:	0d160000 	ldceq	0, cr0, [r6, #-0]
    18e0:	000004b7 			; <UNDEFINED> instruction: 0x000004b7
    18e4:	034e0d17 	movteq	r0, #60695	; 0xed17
    18e8:	0d180000 	ldceq	0, cr0, [r8, #-0]
    18ec:	00000459 	andeq	r0, r0, r9, asr r4
    18f0:	038c0d19 	orreq	r0, ip, #1600	; 0x640
    18f4:	0d1a0000 	ldceq	0, cr0, [sl, #-0]
    18f8:	000002a4 	andeq	r0, r0, r4, lsr #5
    18fc:	02af0d20 	adceq	r0, pc, #32, 26	; 0x800
    1900:	0d210000 	stceq	0, cr0, [r1, #-0]
    1904:	00000394 	muleq	r0, r4, r3
    1908:	02880d22 	addeq	r0, r8, #2176	; 0x880
    190c:	0d240000 	stceq	0, cr0, [r4, #-0]
    1910:	00000382 	andeq	r0, r0, r2, lsl #7
    1914:	02d90d25 	sbcseq	r0, r9, #2368	; 0x940
    1918:	0d300000 	ldceq	0, cr0, [r0, #-0]
    191c:	000002e4 	andeq	r0, r0, r4, ror #5
    1920:	01cc0d31 	biceq	r0, ip, r1, lsr sp
    1924:	0d320000 	ldceq	0, cr0, [r2, #-0]
    1928:	00000373 	andeq	r0, r0, r3, ror r3
    192c:	01c20d34 	biceq	r0, r2, r4, lsr sp
    1930:	00350000 	eorseq	r0, r5, r0
    1934:	0002440e 	andeq	r4, r2, lr, lsl #8
    1938:	38040500 	stmdacc	r4, {r8, sl}
    193c:	02000000 	andeq	r0, r0, #0
    1940:	760d106a 	strvc	r1, [sp], -sl, rrx
    1944:	00000004 	andeq	r0, r0, r4
    1948:	0003560d 	andeq	r5, r3, sp, lsl #12
    194c:	5b0d0100 	blpl	341d54 <_bss_end+0x338638>
    1950:	02000003 	andeq	r0, r0, #3
    1954:	04020000 	streq	r0, [r2], #-0
    1958:	0011d507 	andseq	sp, r1, r7, lsl #10
    195c:	01840300 	orreq	r0, r4, r0, lsl #6
    1960:	880f0000 	stmdahi	pc, {}	; <UNPREDICTABLE>
    1964:	0f000000 	svceq	0x00000000
    1968:	00000098 	muleq	r0, r8, r0
    196c:	0000a80f 	andeq	sl, r0, pc, lsl #16
    1970:	00b50f00 	adcseq	r0, r5, r0, lsl #30
    1974:	14100000 	ldrne	r0, [r0], #-0
    1978:	0400000b 	streq	r0, [r0], #-11
    197c:	68070603 	stmdavs	r7, {r0, r1, r9, sl}
    1980:	11000002 	tstne	r0, r2
    1984:	000001d6 	ldrdeq	r0, [r0], -r6
    1988:	70190a03 	andsvc	r0, r9, r3, lsl #20
    198c:	00000000 	andeq	r0, r0, r0
    1990:	000b1412 	andeq	r1, fp, r2, lsl r4
    1994:	050d0300 	streq	r0, [sp, #-768]	; 0xfffffd00
    1998:	00000254 	andeq	r0, r0, r4, asr r2
    199c:	00000268 	andeq	r0, r0, r8, ror #4
    19a0:	0001d701 	andeq	sp, r1, r1, lsl #14
    19a4:	0001e200 	andeq	lr, r1, r0, lsl #4
    19a8:	02681300 	rsbeq	r1, r8, #0, 6
    19ac:	5e140000 	cdppl	0, 1, cr0, cr4, cr0, {0}
    19b0:	00000000 	andeq	r0, r0, r0
    19b4:	0002ef15 	andeq	lr, r2, r5, lsl pc
    19b8:	0a100300 	beq	4025c0 <_bss_end+0x3f8ea4>
    19bc:	0000021c 	andeq	r0, r0, ip, lsl r2
    19c0:	0001f701 	andeq	pc, r1, r1, lsl #14
    19c4:	00020200 	andeq	r0, r2, r0, lsl #4
    19c8:	02681300 	rsbeq	r1, r8, #0, 6
    19cc:	62140000 	andsvs	r0, r4, #0
    19d0:	00000001 	andeq	r0, r0, r1
    19d4:	00033215 	andeq	r3, r3, r5, lsl r2
    19d8:	0a120300 	beq	4825e0 <_bss_end+0x478ec4>
    19dc:	0000048e 	andeq	r0, r0, lr, lsl #9
    19e0:	00021701 	andeq	r1, r2, r1, lsl #14
    19e4:	00022200 	andeq	r2, r2, r0, lsl #4
    19e8:	02681300 	rsbeq	r1, r8, #0, 6
    19ec:	62140000 	andsvs	r0, r4, #0
    19f0:	00000001 	andeq	r0, r0, r1
    19f4:	0003e715 	andeq	lr, r3, r5, lsl r7
    19f8:	0a150300 	beq	542600 <_bss_end+0x538ee4>
    19fc:	00000261 	andeq	r0, r0, r1, ror #4
    1a00:	00023701 	andeq	r3, r2, r1, lsl #14
    1a04:	00024700 	andeq	r4, r2, r0, lsl #14
    1a08:	02681300 	rsbeq	r1, r8, #0, 6
    1a0c:	c5140000 	ldrgt	r0, [r4, #-0]
    1a10:	14000000 	strne	r0, [r0], #-0
    1a14:	0000004d 	andeq	r0, r0, sp, asr #32
    1a18:	033a1600 	teqeq	sl, #0, 12
    1a1c:	17030000 	strne	r0, [r3, -r0]
    1a20:	0001df0e 	andeq	sp, r1, lr, lsl #30
    1a24:	00004d00 	andeq	r4, r0, r0, lsl #26
    1a28:	025c0100 	subseq	r0, ip, #0, 2
    1a2c:	68130000 	ldmdavs	r3, {}	; <UNPREDICTABLE>
    1a30:	14000002 	strne	r0, [r0], #-2
    1a34:	000000c5 	andeq	r0, r0, r5, asr #1
    1a38:	04070000 	streq	r0, [r7], #-0
    1a3c:	000001a4 	andeq	r0, r0, r4, lsr #3
    1a40:	000c1a0b 	andeq	r1, ip, fp, lsl #20
    1a44:	38040500 	stmdacc	r4, {r8, sl}
    1a48:	04000000 	streq	r0, [r0], #-0
    1a4c:	028d0c06 	addeq	r0, sp, #1536	; 0x600
    1a50:	410d0000 	mrsmi	r0, (UNDEF: 13)
    1a54:	0000000b 	andeq	r0, r0, fp
    1a58:	000b480d 	andeq	r4, fp, sp, lsl #16
    1a5c:	0b000100 	bleq	1e64 <shift+0x1e64>
    1a60:	00000c7b 	andeq	r0, r0, fp, ror ip
    1a64:	00380405 	eorseq	r0, r8, r5, lsl #8
    1a68:	0c040000 	stceq	0, cr0, [r4], {-0}
    1a6c:	0002da0c 	andeq	sp, r2, ip, lsl #20
    1a70:	0b7e1700 	bleq	1f87678 <_bss_end+0x1f7df5c>
    1a74:	04b00000 	ldrteq	r0, [r0], #0
    1a78:	000c8b17 	andeq	r8, ip, r7, lsl fp
    1a7c:	17096000 	strne	r6, [r9, -r0]
    1a80:	00000c4a 	andeq	r0, r0, sl, asr #24
    1a84:	191712c0 	ldmdbne	r7, {r6, r7, r9, ip}
    1a88:	8000000b 	andhi	r0, r0, fp
    1a8c:	0c411725 	mcrreq	7, 2, r1, r1, cr5
    1a90:	4b000000 	blmi	1a98 <shift+0x1a98>
    1a94:	000afd17 	andeq	pc, sl, r7, lsl sp	; <UNPREDICTABLE>
    1a98:	17960000 	ldrne	r0, [r6, r0]
    1a9c:	00000b27 	andeq	r0, r0, r7, lsr #22
    1aa0:	f318e100 	vrhadd.u16	d14, d8, d0
    1aa4:	0000000a 	andeq	r0, r0, sl
    1aa8:	000001c2 	andeq	r0, r0, r2, asr #3
    1aac:	000b2110 	andeq	r2, fp, r0, lsl r1
    1ab0:	18040400 	stmdane	r4, {sl}
    1ab4:	00039507 	andeq	r9, r3, r7, lsl #10
    1ab8:	0b4f1100 	bleq	13c5ec0 <_bss_end+0x13bc7a4>
    1abc:	1b040000 	blne	101ac4 <_bss_end+0xf83a8>
    1ac0:	0003950b 	andeq	r9, r3, fp, lsl #10
    1ac4:	21120000 	tstcs	r2, r0
    1ac8:	0400000b 	streq	r0, [r0], #-11
    1acc:	0bea051e 	bleq	ffa82f4c <_bss_end+0xffa79830>
    1ad0:	039b0000 	orrseq	r0, fp, #0
    1ad4:	0d010000 	stceq	0, cr0, [r1, #-0]
    1ad8:	18000003 	stmdane	r0, {r0, r1}
    1adc:	13000003 	movwne	r0, #3
    1ae0:	0000039b 	muleq	r0, fp, r3
    1ae4:	00039514 	andeq	r9, r3, r4, lsl r5
    1ae8:	2c150000 	ldccs	0, cr0, [r5], {-0}
    1aec:	0400000c 	streq	r0, [r0], #-12
    1af0:	0bfd0a20 	bleq	fff44378 <_bss_end+0xfff3ac5c>
    1af4:	2d010000 	stccs	0, cr0, [r1, #-0]
    1af8:	38000003 	stmdacc	r0, {r0, r1}
    1afc:	13000003 	movwne	r0, #3
    1b00:	0000039b 	muleq	r0, fp, r3
    1b04:	00026e14 	andeq	r6, r2, r4, lsl lr
    1b08:	52150000 	andspl	r0, r5, #0
    1b0c:	0400000c 	streq	r0, [r0], #-12
    1b10:	0c600a21 			; <UNDEFINED> instruction: 0x0c600a21
    1b14:	4d010000 	stcmi	0, cr0, [r1, #-0]
    1b18:	58000003 	stmdapl	r0, {r0, r1}
    1b1c:	13000003 	movwne	r0, #3
    1b20:	0000039b 	muleq	r0, fp, r3
    1b24:	00028d14 	andeq	r8, r2, r4, lsl sp
    1b28:	3b150000 	blcc	541b30 <_bss_end+0x538414>
    1b2c:	0400000b 	streq	r0, [r0], #-11
    1b30:	0bd80a25 	bleq	ff6043cc <_bss_end+0xff5facb0>
    1b34:	6d010000 	stcvs	0, cr0, [r1, #-0]
    1b38:	78000003 	stmdavc	r0, {r0, r1}
    1b3c:	13000003 	movwne	r0, #3
    1b40:	0000039b 	muleq	r0, fp, r3
    1b44:	00002514 	andeq	r2, r0, r4, lsl r5
    1b48:	3b190000 	blcc	641b50 <_bss_end+0x638434>
    1b4c:	0400000b 	streq	r0, [r0], #-11
    1b50:	0b6a0a26 	bleq	1a843f0 <_bss_end+0x1a7acd4>
    1b54:	89010000 	stmdbhi	r1, {}	; <UNPREDICTABLE>
    1b58:	13000003 	movwne	r0, #3
    1b5c:	0000039b 	muleq	r0, fp, r3
    1b60:	0003a114 	andeq	sl, r3, r4, lsl r1
    1b64:	1a000000 	bne	1b6c <shift+0x1b6c>
    1b68:	0001a404 	andeq	sl, r1, r4, lsl #8
    1b6c:	da040700 	ble	103774 <_bss_end+0xfa058>
    1b70:	07000002 	streq	r0, [r0, -r2]
    1b74:	00002c04 	andeq	r2, r0, r4, lsl #24
    1b78:	0b631b00 	bleq	18c8780 <_bss_end+0x18bf064>
    1b7c:	29040000 	stmdbcs	r4, {}	; <UNPREDICTABLE>
    1b80:	0002da0e 	andeq	sp, r2, lr, lsl #20
    1b84:	0cdd1c00 	ldcleq	12, cr1, [sp], {0}
    1b88:	05010000 	streq	r0, [r1, #-0]
    1b8c:	00003810 	andeq	r3, r0, r0, lsl r8
    1b90:	0091e800 	addseq	lr, r1, r0, lsl #16
    1b94:	00006c00 	andeq	r6, r0, r0, lsl #24
    1b98:	1d9c0100 	ldfnes	f0, [ip]
    1b9c:	006d6974 	rsbeq	r6, sp, r4, ror r9
    1ba0:	651b0b01 	ldrvs	r0, [fp, #-2817]	; 0xfffff4ff
    1ba4:	02000000 	andeq	r0, r0, #0
    1ba8:	00007491 	muleq	r0, r1, r4
    1bac:	00000022 	andeq	r0, r0, r2, lsr #32
    1bb0:	0c1c0002 	ldceq	0, cr0, [ip], {2}
    1bb4:	01040000 	mrseq	r0, (UNDEF: 4)
    1bb8:	00000ca7 	andeq	r0, r0, r7, lsr #25
    1bbc:	00008000 	andeq	r8, r0, r0
    1bc0:	00008018 	andeq	r8, r0, r8, lsl r0
    1bc4:	00000cea 	andeq	r0, r0, sl, ror #25
    1bc8:	00000166 	andeq	r0, r0, r6, ror #2
    1bcc:	00000d33 	andeq	r0, r0, r3, lsr sp
    1bd0:	014b8001 	cmpeq	fp, r1
    1bd4:	00040000 	andeq	r0, r4, r0
    1bd8:	00000c30 	andeq	r0, r0, r0, lsr ip
    1bdc:	00a00104 	adceq	r0, r0, r4, lsl #2
    1be0:	3f040000 	svccc	0x00040000
    1be4:	6600000d 	strvs	r0, [r0], -sp
    1be8:	54000001 	strpl	r0, [r0], #-1
    1bec:	18000092 	stmdane	r0, {r1, r4, r7}
    1bf0:	22000001 	andcs	r0, r0, #1
    1bf4:	0200000d 	andeq	r0, r0, #13
    1bf8:	00000dea 	andeq	r0, r0, sl, ror #27
    1bfc:	31070201 	tstcc	r7, r1, lsl #4
    1c00:	03000000 	movweq	r0, #0
    1c04:	00003704 	andeq	r3, r0, r4, lsl #14
    1c08:	0b020400 	bleq	82c10 <_bss_end+0x794f4>
    1c0c:	0100000e 	tsteq	r0, lr
    1c10:	00310703 	eorseq	r0, r1, r3, lsl #14
    1c14:	8c050000 	stchi	0, cr0, [r5], {-0}
    1c18:	0100000d 	tsteq	r0, sp
    1c1c:	00501006 	subseq	r1, r0, r6
    1c20:	04060000 	streq	r0, [r6], #-0
    1c24:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
    1c28:	0dd30500 	cfldr64eq	mvdx0, [r3]
    1c2c:	08010000 	stmdaeq	r1, {}	; <UNPREDICTABLE>
    1c30:	00005010 	andeq	r5, r0, r0, lsl r0
    1c34:	00250700 	eoreq	r0, r5, r0, lsl #14
    1c38:	00760000 	rsbseq	r0, r6, r0
    1c3c:	76080000 	strvc	r0, [r8], -r0
    1c40:	ff000000 			; <UNDEFINED> instruction: 0xff000000
    1c44:	00ffffff 	ldrshteq	pc, [pc], #255	; <UNPREDICTABLE>
    1c48:	da070409 	ble	1c2c74 <_bss_end+0x1b9558>
    1c4c:	05000011 	streq	r0, [r0, #-17]	; 0xffffffef
    1c50:	00000daa 	andeq	r0, r0, sl, lsr #27
    1c54:	63150b01 	tstvs	r5, #1024	; 0x400
    1c58:	05000000 	streq	r0, [r0, #-0]
    1c5c:	00000d9d 	muleq	r0, sp, sp
    1c60:	63150d01 	tstvs	r5, #1, 26	; 0x40
    1c64:	07000000 	streq	r0, [r0, -r0]
    1c68:	00000038 	andeq	r0, r0, r8, lsr r0
    1c6c:	000000a8 	andeq	r0, r0, r8, lsr #1
    1c70:	00007608 	andeq	r7, r0, r8, lsl #12
    1c74:	ffffff00 			; <UNDEFINED> instruction: 0xffffff00
    1c78:	dc0500ff 	stcle	0, cr0, [r5], {255}	; 0xff
    1c7c:	0100000d 	tsteq	r0, sp
    1c80:	00951510 	addseq	r1, r5, r0, lsl r5
    1c84:	b8050000 	stmdalt	r5, {}	; <UNPREDICTABLE>
    1c88:	0100000d 	tsteq	r0, sp
    1c8c:	00951512 	addseq	r1, r5, r2, lsl r5
    1c90:	c50a0000 	strgt	r0, [sl, #-0]
    1c94:	0100000d 	tsteq	r0, sp
    1c98:	0050102b 	subseq	r1, r0, fp, lsr #32
    1c9c:	93140000 	tstls	r4, #0
    1ca0:	00580000 	subseq	r0, r8, r0
    1ca4:	9c010000 	stcls	0, cr0, [r1], {-0}
    1ca8:	000000ea 	andeq	r0, r0, sl, ror #1
    1cac:	000d970b 	andeq	r9, sp, fp, lsl #14
    1cb0:	0f2d0100 	svceq	0x002d0100
    1cb4:	000000ea 	andeq	r0, r0, sl, ror #1
    1cb8:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1cbc:	00380403 	eorseq	r0, r8, r3, lsl #8
    1cc0:	fe0a0000 	cdp2	0, 0, cr0, cr10, cr0, {0}
    1cc4:	0100000d 	tsteq	r0, sp
    1cc8:	0050101f 	subseq	r1, r0, pc, lsl r0
    1ccc:	92bc0000 	adcsls	r0, ip, #0
    1cd0:	00580000 	subseq	r0, r8, r0
    1cd4:	9c010000 	stcls	0, cr0, [r1], {-0}
    1cd8:	0000011a 	andeq	r0, r0, sl, lsl r1
    1cdc:	000d970b 	andeq	r9, sp, fp, lsl #14
    1ce0:	0f210100 	svceq	0x00210100
    1ce4:	0000011a 	andeq	r0, r0, sl, lsl r1
    1ce8:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1cec:	00250403 	eoreq	r0, r5, r3, lsl #8
    1cf0:	f30c0000 	vhadd.u8	d0, d12, d0
    1cf4:	0100000d 	tsteq	r0, sp
    1cf8:	00501014 	subseq	r1, r0, r4, lsl r0
    1cfc:	92540000 	subsls	r0, r4, #0
    1d00:	00680000 	rsbeq	r0, r8, r0
    1d04:	9c010000 	stcls	0, cr0, [r1], {-0}
    1d08:	00000148 	andeq	r0, r0, r8, asr #2
    1d0c:	0100690d 	tsteq	r0, sp, lsl #18
    1d10:	01480a16 	cmpeq	r8, r6, lsl sl
    1d14:	91020000 	mrsls	r0, (UNDEF: 2)
    1d18:	04030074 	streq	r0, [r3], #-116	; 0xffffff8c
    1d1c:	00000050 	andeq	r0, r0, r0, asr r0
    1d20:	00002200 	andeq	r2, r0, r0, lsl #4
    1d24:	f6000200 			; <UNDEFINED> instruction: 0xf6000200
    1d28:	0400000c 	streq	r0, [r0], #-12
    1d2c:	000e0a01 	andeq	r0, lr, r1, lsl #20
    1d30:	00936c00 	addseq	r6, r3, r0, lsl #24
    1d34:	00957800 	addseq	r7, r5, r0, lsl #16
    1d38:	000e1400 	andeq	r1, lr, r0, lsl #8
    1d3c:	000e4400 	andeq	r4, lr, r0, lsl #8
    1d40:	000eac00 	andeq	sl, lr, r0, lsl #24
    1d44:	22800100 	addcs	r0, r0, #0, 2
    1d48:	02000000 	andeq	r0, r0, #0
    1d4c:	000d0a00 	andeq	r0, sp, r0, lsl #20
    1d50:	87010400 	strhi	r0, [r1, -r0, lsl #8]
    1d54:	7800000e 	stmdavc	r0, {r1, r2, r3}
    1d58:	7c000095 	stcvc	0, cr0, [r0], {149}	; 0x95
    1d5c:	14000095 	strne	r0, [r0], #-149	; 0xffffff6b
    1d60:	4400000e 	strmi	r0, [r0], #-14
    1d64:	ac00000e 	stcge	0, cr0, [r0], {14}
    1d68:	0100000e 	tsteq	r0, lr
    1d6c:	00032a80 	andeq	r2, r3, r0, lsl #21
    1d70:	1e000400 	cfcpysne	mvf0, mvf0
    1d74:	0400000d 	streq	r0, [r0], #-13
    1d78:	000fd801 	andeq	sp, pc, r1, lsl #16
    1d7c:	11910c00 	orrsne	r0, r1, r0, lsl #24
    1d80:	0e440000 	cdpeq	0, 4, cr0, cr4, cr0, {0}
    1d84:	0ee70000 	cdpeq	0, 14, cr0, cr7, cr0, {0}
    1d88:	04020000 	streq	r0, [r2], #-0
    1d8c:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
    1d90:	07040300 	streq	r0, [r4, -r0, lsl #6]
    1d94:	000011da 	ldrdeq	r1, [r0], -sl
    1d98:	aa050803 	bge	143dac <_bss_end+0x13a690>
    1d9c:	03000001 	movweq	r0, #1
    1da0:	11850408 	orrne	r0, r5, r8, lsl #8
    1da4:	01030000 	mrseq	r0, (UNDEF: 3)
    1da8:	0002f608 	andeq	pc, r2, r8, lsl #12
    1dac:	06010300 	streq	r0, [r1], -r0, lsl #6
    1db0:	000002f8 	strdeq	r0, [r0], -r8
    1db4:	00135d04 	andseq	r5, r3, r4, lsl #26
    1db8:	39010700 	stmdbcc	r1, {r8, r9, sl}
    1dbc:	01000000 	mrseq	r0, (UNDEF: 0)
    1dc0:	01d40617 	bicseq	r0, r4, r7, lsl r6
    1dc4:	e7050000 	str	r0, [r5, -r0]
    1dc8:	0000000e 	andeq	r0, r0, lr
    1dcc:	00140c05 	andseq	r0, r4, r5, lsl #24
    1dd0:	ba050100 	blt	1421d8 <_bss_end+0x138abc>
    1dd4:	02000010 	andeq	r0, r0, #16
    1dd8:	00117805 	andseq	r7, r1, r5, lsl #16
    1ddc:	76050300 	strvc	r0, [r5], -r0, lsl #6
    1de0:	04000013 	streq	r0, [r0], #-19	; 0xffffffed
    1de4:	00141c05 	andseq	r1, r4, r5, lsl #24
    1de8:	8c050500 	cfstr32hi	mvfx0, [r5], {-0}
    1dec:	06000013 			; <UNDEFINED> instruction: 0x06000013
    1df0:	0011c105 	andseq	ip, r1, r5, lsl #2
    1df4:	07050700 	streq	r0, [r5, -r0, lsl #14]
    1df8:	08000013 	stmdaeq	r0, {r0, r1, r4}
    1dfc:	00131505 	andseq	r1, r3, r5, lsl #10
    1e00:	23050900 	movwcs	r0, #22784	; 0x5900
    1e04:	0a000013 	beq	1e58 <shift+0x1e58>
    1e08:	00122a05 	andseq	r2, r2, r5, lsl #20
    1e0c:	1a050b00 	bne	144a14 <_bss_end+0x13b2f8>
    1e10:	0c000012 	stceq	0, cr0, [r0], {18}
    1e14:	000f0305 	andeq	r0, pc, r5, lsl #6
    1e18:	1c050d00 	stcne	13, cr0, [r5], {-0}
    1e1c:	0e00000f 	cdpeq	0, 0, cr0, cr0, cr15, {0}
    1e20:	00120b05 	andseq	r0, r2, r5, lsl #22
    1e24:	cf050f00 	svcgt	0x00050f00
    1e28:	10000013 	andne	r0, r0, r3, lsl r0
    1e2c:	00134c05 	andseq	r4, r3, r5, lsl #24
    1e30:	c0051100 	andgt	r1, r5, r0, lsl #2
    1e34:	12000013 	andne	r0, r0, #19
    1e38:	000fc905 	andeq	ip, pc, r5, lsl #18
    1e3c:	46051300 	strmi	r1, [r5], -r0, lsl #6
    1e40:	1400000f 	strne	r0, [r0], #-15
    1e44:	000f1005 	andeq	r1, pc, r5
    1e48:	a9051500 	stmdbge	r5, {r8, sl, ip}
    1e4c:	16000012 			; <UNDEFINED> instruction: 0x16000012
    1e50:	000f7d05 	andeq	r7, pc, r5, lsl #26
    1e54:	b8051700 	stmdalt	r5, {r8, r9, sl, ip}
    1e58:	1800000e 	stmdane	r0, {r1, r2, r3}
    1e5c:	0013b205 	andseq	fp, r3, r5, lsl #4
    1e60:	e7051900 	str	r1, [r5, -r0, lsl #18]
    1e64:	1a000011 	bne	1eb0 <shift+0x1eb0>
    1e68:	0012c105 	andseq	ip, r2, r5, lsl #2
    1e6c:	51051b00 	tstpl	r5, r0, lsl #22
    1e70:	1c00000f 	stcne	0, cr0, [r0], {15}
    1e74:	00115d05 	andseq	r5, r1, r5, lsl #26
    1e78:	ac051d00 	stcge	13, cr1, [r5], {-0}
    1e7c:	1e000010 	mcrne	0, 0, r0, cr0, cr0, {0}
    1e80:	00133e05 	andseq	r3, r3, r5, lsl #28
    1e84:	9a051f00 	bls	149a8c <_bss_end+0x140370>
    1e88:	20000013 	andcs	r0, r0, r3, lsl r0
    1e8c:	0013db05 	andseq	sp, r3, r5, lsl #22
    1e90:	e9052100 	stmdb	r5, {r8, sp}
    1e94:	22000013 	andcs	r0, r0, #19
    1e98:	0011fe05 	andseq	pc, r1, r5, lsl #28
    1e9c:	21052300 	mrscs	r2, SP_abt
    1ea0:	24000011 	strcs	r0, [r0], #-17	; 0xffffffef
    1ea4:	000f6005 	andeq	r6, pc, r5
    1ea8:	b4052500 	strlt	r2, [r5], #-1280	; 0xfffffb00
    1eac:	26000011 			; <UNDEFINED> instruction: 0x26000011
    1eb0:	0010c605 	andseq	ip, r0, r5, lsl #12
    1eb4:	69052700 	stmdbvs	r5, {r8, r9, sl, sp}
    1eb8:	28000013 	stmdacs	r0, {r0, r1, r4}
    1ebc:	0010d605 	andseq	sp, r0, r5, lsl #12
    1ec0:	e5052900 	str	r2, [r5, #-2304]	; 0xfffff700
    1ec4:	2a000010 	bcs	1f0c <shift+0x1f0c>
    1ec8:	0010f405 	andseq	pc, r0, r5, lsl #8
    1ecc:	03052b00 	movweq	r2, #23296	; 0x5b00
    1ed0:	2c000011 	stccs	0, cr0, [r0], {17}
    1ed4:	00109105 	andseq	r9, r0, r5, lsl #2
    1ed8:	12052d00 	andne	r2, r5, #0, 26
    1edc:	2e000011 	mcrcs	0, 0, r0, cr0, cr1, {0}
    1ee0:	0012f805 	andseq	pc, r2, r5, lsl #16
    1ee4:	30052f00 	andcc	r2, r5, r0, lsl #30
    1ee8:	30000011 	andcc	r0, r0, r1, lsl r0
    1eec:	00113f05 	andseq	r3, r1, r5, lsl #30
    1ef0:	f1053100 			; <UNDEFINED> instruction: 0xf1053100
    1ef4:	3200000e 	andcc	r0, r0, #14
    1ef8:	00124905 	andseq	r4, r2, r5, lsl #18
    1efc:	59053300 	stmdbpl	r5, {r8, r9, ip, sp}
    1f00:	34000012 	strcc	r0, [r0], #-18	; 0xffffffee
    1f04:	00126905 	andseq	r6, r2, r5, lsl #18
    1f08:	7f053500 	svcvc	0x00053500
    1f0c:	36000010 			; <UNDEFINED> instruction: 0x36000010
    1f10:	00127905 	andseq	r7, r2, r5, lsl #18
    1f14:	89053700 	stmdbhi	r5, {r8, r9, sl, ip, sp}
    1f18:	38000012 	stmdacc	r0, {r1, r4}
    1f1c:	00129905 	andseq	r9, r2, r5, lsl #18
    1f20:	70053900 	andvc	r3, r5, r0, lsl #18
    1f24:	3a00000f 	bcc	1f68 <shift+0x1f68>
    1f28:	000f2905 	andeq	r2, pc, r5, lsl #18
    1f2c:	4e053b00 	vmlami.f64	d3, d5, d0
    1f30:	3c000011 	stccc	0, cr0, [r0], {17}
    1f34:	000ec805 	andeq	ip, lr, r5, lsl #16
    1f38:	b4053d00 	strlt	r3, [r5], #-3328	; 0xfffff300
    1f3c:	3e000012 	mcrcc	0, 0, r0, cr0, cr2, {0}
    1f40:	0fb00600 	svceq	0x00b00600
    1f44:	01020000 	mrseq	r0, (UNDEF: 2)
    1f48:	ff08026b 			; <UNDEFINED> instruction: 0xff08026b
    1f4c:	07000001 	streq	r0, [r0, -r1]
    1f50:	00001173 	andeq	r1, r0, r3, ror r1
    1f54:	14027001 	strne	r7, [r2], #-1
    1f58:	00000047 	andeq	r0, r0, r7, asr #32
    1f5c:	108c0700 	addne	r0, ip, r0, lsl #14
    1f60:	71010000 	mrsvc	r0, (UNDEF: 1)
    1f64:	00471402 	subeq	r1, r7, r2, lsl #8
    1f68:	00010000 	andeq	r0, r1, r0
    1f6c:	0001d408 	andeq	sp, r1, r8, lsl #8
    1f70:	01ff0900 	mvnseq	r0, r0, lsl #18
    1f74:	02140000 	andseq	r0, r4, #0
    1f78:	240a0000 	strcs	r0, [sl], #-0
    1f7c:	11000000 	mrsne	r0, (UNDEF: 0)
    1f80:	02040800 	andeq	r0, r4, #0, 16
    1f84:	370b0000 	strcc	r0, [fp, -r0]
    1f88:	01000012 	tsteq	r0, r2, lsl r0
    1f8c:	14260274 	strtne	r0, [r6], #-628	; 0xfffffd8c
    1f90:	24000002 	strcs	r0, [r0], #-2
    1f94:	3d0a3d3a 	stccc	13, cr3, [sl, #-232]	; 0xffffff18
    1f98:	3d243d0f 	stccc	13, cr3, [r4, #-60]!	; 0xffffffc4
    1f9c:	3d023d32 	stccc	13, cr3, [r2, #-200]	; 0xffffff38
    1fa0:	3d133d05 	ldccc	13, cr3, [r3, #-20]	; 0xffffffec
    1fa4:	3d0c3d0d 	stccc	13, cr3, [ip, #-52]	; 0xffffffcc
    1fa8:	3d113d23 	ldccc	13, cr3, [r1, #-140]	; 0xffffff74
    1fac:	3d013d26 	stccc	13, cr3, [r1, #-152]	; 0xffffff68
    1fb0:	3d083d17 	stccc	13, cr3, [r8, #-92]	; 0xffffffa4
    1fb4:	00003d09 	andeq	r3, r0, r9, lsl #26
    1fb8:	60070203 	andvs	r0, r7, r3, lsl #4
    1fbc:	03000003 	movweq	r0, #3
    1fc0:	02ff0801 	rscseq	r0, pc, #65536	; 0x10000
    1fc4:	0d0c0000 	stceq	0, cr0, [ip, #-0]
    1fc8:	00025904 	andeq	r5, r2, r4, lsl #18
    1fcc:	13f70e00 	mvnsne	r0, #0, 28
    1fd0:	01070000 	mrseq	r0, (UNDEF: 7)
    1fd4:	00000039 	andeq	r0, r0, r9, lsr r0
    1fd8:	0604f702 	streq	pc, [r4], -r2, lsl #14
    1fdc:	0000029e 	muleq	r0, lr, r2
    1fe0:	000f8a05 	andeq	r8, pc, r5, lsl #20
    1fe4:	95050000 	strls	r0, [r5, #-0]
    1fe8:	0100000f 	tsteq	r0, pc
    1fec:	000fa705 	andeq	sl, pc, r5, lsl #14
    1ff0:	c1050200 	mrsgt	r0, SP_usr
    1ff4:	0300000f 	movweq	r0, #15
    1ff8:	00133105 	andseq	r3, r3, r5, lsl #2
    1ffc:	a0050400 	andge	r0, r5, r0, lsl #8
    2000:	05000010 	streq	r0, [r0, #-16]
    2004:	0012ea05 	andseq	lr, r2, r5, lsl #20
    2008:	03000600 	movweq	r0, #1536	; 0x600
    200c:	01b80502 			; <UNDEFINED> instruction: 0x01b80502
    2010:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    2014:	0011d007 	andseq	sp, r1, r7
    2018:	04040300 	streq	r0, [r4], #-768	; 0xfffffd00
    201c:	00000ee1 	andeq	r0, r0, r1, ror #29
    2020:	d9030803 	stmdble	r3, {r0, r1, fp}
    2024:	0300000e 	movweq	r0, #14
    2028:	118a0408 	orrne	r0, sl, r8, lsl #8
    202c:	10030000 	andne	r0, r3, r0
    2030:	0012db03 	andseq	sp, r2, r3, lsl #22
    2034:	12d20f00 	sbcsne	r0, r2, #0, 30
    2038:	2a030000 	bcs	c2040 <_bss_end+0xb8924>
    203c:	00025a10 	andeq	r5, r2, r0, lsl sl
    2040:	02c80900 	sbceq	r0, r8, #0, 18
    2044:	02df0000 	sbcseq	r0, pc, #0
    2048:	00100000 	andseq	r0, r0, r0
    204c:	000daa11 	andeq	sl, sp, r1, lsl sl
    2050:	112f0300 			; <UNDEFINED> instruction: 0x112f0300
    2054:	000002d4 	ldrdeq	r0, [r0], -r4
    2058:	000ddc11 	andeq	sp, sp, r1, lsl ip
    205c:	11300300 	teqne	r0, r0, lsl #6
    2060:	000002d4 	ldrdeq	r0, [r0], -r4
    2064:	0002c809 	andeq	ip, r2, r9, lsl #16
    2068:	00030700 	andeq	r0, r3, r0, lsl #14
    206c:	00240a00 	eoreq	r0, r4, r0, lsl #20
    2070:	00010000 	andeq	r0, r1, r0
    2074:	0002df12 	andeq	sp, r2, r2, lsl pc
    2078:	09330400 	ldmdbeq	r3!, {sl}
    207c:	0002f70a 	andeq	pc, r2, sl, lsl #14
    2080:	c8030500 	stmdagt	r3, {r8, sl}
    2084:	12000096 	andne	r0, r0, #150	; 0x96
    2088:	000002eb 	andeq	r0, r0, fp, ror #5
    208c:	0a093404 	beq	24f0a4 <_bss_end+0x245988>
    2090:	000002f7 	strdeq	r0, [r0], -r7
    2094:	96d80305 	ldrbls	r0, [r8], r5, lsl #6
    2098:	Address 0x0000000000002098 is out of bounds.


Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
   0:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
   4:	030b130e 	movweq	r1, #45838	; 0xb30e
   8:	110e1b0e 	tstne	lr, lr, lsl #22
   c:	10061201 	andne	r1, r6, r1, lsl #4
  10:	02000017 	andeq	r0, r0, #23
  14:	193f002e 	ldmdbne	pc!, {r1, r2, r3, r5}	; <UNPREDICTABLE>
  18:	0b3a0e03 	bleq	e8382c <_bss_end+0xe7a110>
  1c:	0b390b3b 	bleq	e42d10 <_bss_end+0xe395f4>
  20:	06120111 			; <UNDEFINED> instruction: 0x06120111
  24:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
  28:	03000019 	movweq	r0, #25
  2c:	0e030139 	mcreq	1, 0, r0, cr3, cr9, {1}
  30:	0b3b0b3a 	bleq	ec2d20 <_bss_end+0xeb9604>
  34:	00001301 	andeq	r1, r0, r1, lsl #6
  38:	3f012e04 	svccc	0x00012e04
  3c:	3a0e0319 	bcc	380ca8 <_bss_end+0x37758c>
  40:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
  44:	01193c0b 	tsteq	r9, fp, lsl #24
  48:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
  4c:	13490005 	movtne	r0, #36869	; 0x9005
  50:	16060000 	strne	r0, [r6], -r0
  54:	3a0e0300 	bcc	380c5c <_bss_end+0x377540>
  58:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
  5c:	0013490b 	andseq	r4, r3, fp, lsl #18
  60:	012e0700 			; <UNDEFINED> instruction: 0x012e0700
  64:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
  68:	0b3b0b3a 	bleq	ec2d58 <_bss_end+0xeb963c>
  6c:	13490b39 	movtne	r0, #39737	; 0x9b39
  70:	0000193c 	andeq	r1, r0, ip, lsr r9
  74:	0b000f08 	bleq	3c9c <shift+0x3c9c>
  78:	0013490b 	andseq	r4, r3, fp, lsl #18
  7c:	00240900 	eoreq	r0, r4, r0, lsl #18
  80:	0b3e0b0b 	bleq	f82cb4 <_bss_end+0xf79598>
  84:	00000e03 	andeq	r0, r0, r3, lsl #28
  88:	47012e0a 	strmi	r2, [r1, -sl, lsl #28]
  8c:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
  90:	97184006 	ldrls	r4, [r8, -r6]
  94:	13011942 	movwne	r1, #6466	; 0x1942
  98:	050b0000 	streq	r0, [fp, #-0]
  9c:	02134900 	andseq	r4, r3, #0, 18
  a0:	0c000018 	stceq	0, cr0, [r0], {24}
  a4:	08030005 	stmdaeq	r3, {r0, r2}
  a8:	0b3b0b3a 	bleq	ec2d98 <_bss_end+0xeb967c>
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
  e4:	0b0b0024 	bleq	2c017c <_bss_end+0x2b6a60>
  e8:	0e030b3e 	vmoveq.16	d3[0], r0
  ec:	24030000 	strcs	r0, [r3], #-0
  f0:	3e0b0b00 	vmlacc.f64	d0, d11, d0
  f4:	0008030b 	andeq	r0, r8, fp, lsl #6
  f8:	00160400 	andseq	r0, r6, r0, lsl #8
  fc:	0b3a0e03 	bleq	e83910 <_bss_end+0xe7a1f4>
 100:	0b390b3b 	bleq	e42df4 <_bss_end+0xe396d8>
 104:	00001349 	andeq	r1, r0, r9, asr #6
 108:	49002605 	stmdbmi	r0, {r0, r2, r9, sl, sp}
 10c:	06000013 			; <UNDEFINED> instruction: 0x06000013
 110:	08030139 	stmdaeq	r3, {r0, r3, r4, r5, r8}
 114:	0b3b0b3a 	bleq	ec2e04 <_bss_end+0xeb96e8>
 118:	13010b39 	movwne	r0, #6969	; 0x1b39
 11c:	34070000 	strcc	r0, [r7], #-0
 120:	3a0e0300 	bcc	380d28 <_bss_end+0x37760c>
 124:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 128:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
 12c:	6c061c19 	stcvs	12, cr1, [r6], {25}
 130:	08000019 	stmdaeq	r0, {r0, r3, r4}
 134:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 138:	0b3b0b3a 	bleq	ec2e28 <_bss_end+0xeb970c>
 13c:	13490b39 	movtne	r0, #39737	; 0x9b39
 140:	0b1c193c 	bleq	706638 <_bss_end+0x6fcf1c>
 144:	0000196c 	andeq	r1, r0, ip, ror #18
 148:	03010409 	movweq	r0, #5129	; 0x1409
 14c:	3e196d0e 	cdpcc	13, 1, cr6, cr9, cr14, {0}
 150:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
 154:	3b0b3a13 	blcc	2ce9a8 <_bss_end+0x2c528c>
 158:	010b390b 	tsteq	fp, fp, lsl #18
 15c:	0a000013 	beq	1b0 <shift+0x1b0>
 160:	08030028 	stmdaeq	r3, {r3, r5}
 164:	00000b1c 	andeq	r0, r0, ip, lsl fp
 168:	0300280b 	movweq	r2, #2059	; 0x80b
 16c:	000b1c0e 	andeq	r1, fp, lr, lsl #24
 170:	01040c00 	tsteq	r4, r0, lsl #24
 174:	196d0e03 	stmdbne	sp!, {r0, r1, r9, sl, fp}^
 178:	0b0b0b3e 	bleq	2c2e78 <_bss_end+0x2b975c>
 17c:	0b3a1349 	bleq	e84ea8 <_bss_end+0xe7b78c>
 180:	0b390b3b 	bleq	e42e74 <_bss_end+0xe39758>
 184:	340d0000 	strcc	r0, [sp], #-0
 188:	00134700 	andseq	r4, r3, r0, lsl #14
 18c:	01020e00 	tsteq	r2, r0, lsl #28
 190:	0b0b0e03 	bleq	2c39a4 <_bss_end+0x2ba288>
 194:	0b3b0b3a 	bleq	ec2e84 <_bss_end+0xeb9768>
 198:	13010b39 	movwne	r0, #6969	; 0x1b39
 19c:	0d0f0000 	stceq	0, cr0, [pc, #-0]	; 1a4 <shift+0x1a4>
 1a0:	3a0e0300 	bcc	380da8 <_bss_end+0x37768c>
 1a4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 1a8:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 1ac:	1000000b 	andne	r0, r0, fp
 1b0:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 1b4:	0b3a0e03 	bleq	e839c8 <_bss_end+0xe7a2ac>
 1b8:	0b390b3b 	bleq	e42eac <_bss_end+0xe39790>
 1bc:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 1c0:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 1c4:	13011364 	movwne	r1, #4964	; 0x1364
 1c8:	05110000 	ldreq	r0, [r1, #-0]
 1cc:	34134900 	ldrcc	r4, [r3], #-2304	; 0xfffff700
 1d0:	12000019 	andne	r0, r0, #25
 1d4:	13490005 	movtne	r0, #36869	; 0x9005
 1d8:	2e130000 	cdpcs	0, 1, cr0, cr3, cr0, {0}
 1dc:	03193f01 	tsteq	r9, #1, 30
 1e0:	3b0b3a0e 	blcc	2cea20 <_bss_end+0x2c5304>
 1e4:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 1e8:	3c0b320e 	sfmcc	f3, 4, [fp], {14}
 1ec:	01136419 	tsteq	r3, r9, lsl r4
 1f0:	14000013 	strne	r0, [r0], #-19	; 0xffffffed
 1f4:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 1f8:	0b3a0e03 	bleq	e83a0c <_bss_end+0xe7a2f0>
 1fc:	0b390b3b 	bleq	e42ef0 <_bss_end+0xe397d4>
 200:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 204:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 208:	00001364 	andeq	r1, r0, r4, ror #6
 20c:	0b000f15 	bleq	3e68 <shift+0x3e68>
 210:	0013490b 	andseq	r4, r3, fp, lsl #18
 214:	00341600 	eorseq	r1, r4, r0, lsl #12
 218:	0b3a0e03 	bleq	e83a2c <_bss_end+0xe7a310>
 21c:	0b390b3b 	bleq	e42f10 <_bss_end+0xe397f4>
 220:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
 224:	0000193c 	andeq	r1, r0, ip, lsr r9
 228:	47003417 	smladmi	r0, r7, r4, r3
 22c:	3b0b3a13 	blcc	2cea80 <_bss_end+0x2c5364>
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
 260:	0b3a0e03 	bleq	e83a74 <_bss_end+0xe7a358>
 264:	0b390b3b 	bleq	e42f58 <_bss_end+0xe3983c>
 268:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 26c:	2e1b0000 	cdpcs	0, 1, cr0, cr11, cr0, {0}
 270:	3a134701 	bcc	4d1e7c <_bss_end+0x4c8760>
 274:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 278:	1113640b 	tstne	r3, fp, lsl #8
 27c:	40061201 	andmi	r1, r6, r1, lsl #4
 280:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 284:	00001301 	andeq	r1, r0, r1, lsl #6
 288:	0300051c 	movweq	r0, #1308	; 0x51c
 28c:	3413490e 	ldrcc	r4, [r3], #-2318	; 0xfffff6f2
 290:	00180219 	andseq	r0, r8, r9, lsl r2
 294:	012e1d00 			; <UNDEFINED> instruction: 0x012e1d00
 298:	0b3a1347 	bleq	e84fbc <_bss_end+0xe7b8a0>
 29c:	0b390b3b 	bleq	e42f90 <_bss_end+0xe39874>
 2a0:	01111364 	tsteq	r1, r4, ror #6
 2a4:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 2a8:	01194296 			; <UNDEFINED> instruction: 0x01194296
 2ac:	1e000013 	mcrne	0, 0, r0, cr0, cr3, {0}
 2b0:	1347012e 	movtne	r0, #28974	; 0x712e
 2b4:	0b3b0b3a 	bleq	ec2fa4 <_bss_end+0xeb9888>
 2b8:	13640b39 	cmnne	r4, #58368	; 0xe400
 2bc:	13010b20 	movwne	r0, #6944	; 0x1b20
 2c0:	051f0000 	ldreq	r0, [pc, #-0]	; 2c8 <shift+0x2c8>
 2c4:	490e0300 	stmdbmi	lr, {r8, r9}
 2c8:	00193413 	andseq	r3, r9, r3, lsl r4
 2cc:	00052000 	andeq	r2, r5, r0
 2d0:	0b3a0e03 	bleq	e83ae4 <_bss_end+0xe7a3c8>
 2d4:	0b390b3b 	bleq	e42fc8 <_bss_end+0xe398ac>
 2d8:	00001349 	andeq	r1, r0, r9, asr #6
 2dc:	31012e21 	tstcc	r1, r1, lsr #28
 2e0:	640e6e13 	strvs	r6, [lr], #-3603	; 0xfffff1ed
 2e4:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 2e8:	97184006 	ldrls	r4, [r8, -r6]
 2ec:	00001942 	andeq	r1, r0, r2, asr #18
 2f0:	31000522 	tstcc	r0, r2, lsr #10
 2f4:	00180213 	andseq	r0, r8, r3, lsl r2
 2f8:	11010000 	mrsne	r0, (UNDEF: 1)
 2fc:	130e2501 	movwne	r2, #58625	; 0xe501
 300:	1b0e030b 	blne	380f34 <_bss_end+0x377818>
 304:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 308:	00171006 	andseq	r1, r7, r6
 30c:	00240200 	eoreq	r0, r4, r0, lsl #4
 310:	0b3e0b0b 	bleq	f82f44 <_bss_end+0xf79828>
 314:	00000e03 	andeq	r0, r0, r3, lsl #28
 318:	0b002403 	bleq	932c <_cpp_shutdown+0x18>
 31c:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 320:	04000008 	streq	r0, [r0], #-8
 324:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
 328:	0b3b0b3a 	bleq	ec3018 <_bss_end+0xeb98fc>
 32c:	13490b39 	movtne	r0, #39737	; 0x9b39
 330:	26050000 	strcs	r0, [r5], -r0
 334:	00134900 	andseq	r4, r3, r0, lsl #18
 338:	01390600 	teqeq	r9, r0, lsl #12
 33c:	0b3a0803 	bleq	e82350 <_bss_end+0xe78c34>
 340:	0b390b3b 	bleq	e43034 <_bss_end+0xe39918>
 344:	00001301 	andeq	r1, r0, r1, lsl #6
 348:	03003407 	movweq	r3, #1031	; 0x407
 34c:	3b0b3a0e 	blcc	2ceb8c <_bss_end+0x2c5470>
 350:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 354:	1c193c13 	ldcne	12, cr3, [r9], {19}
 358:	00196c06 	andseq	r6, r9, r6, lsl #24
 35c:	00340800 	eorseq	r0, r4, r0, lsl #16
 360:	0b3a0e03 	bleq	e83b74 <_bss_end+0xe7a458>
 364:	0b390b3b 	bleq	e43058 <_bss_end+0xe3993c>
 368:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 36c:	196c0b1c 	stmdbne	ip!, {r2, r3, r4, r8, r9, fp}^
 370:	04090000 	streq	r0, [r9], #-0
 374:	6d0e0301 	stcvs	3, cr0, [lr, #-4]
 378:	0b0b3e19 	bleq	2cfbe4 <_bss_end+0x2c64c8>
 37c:	3a13490b 	bcc	4d27b0 <_bss_end+0x4c9094>
 380:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 384:	0013010b 	andseq	r0, r3, fp, lsl #2
 388:	00280a00 	eoreq	r0, r8, r0, lsl #20
 38c:	0b1c0e03 	bleq	703ba0 <_bss_end+0x6fa484>
 390:	340b0000 	strcc	r0, [fp], #-0
 394:	00134700 	andseq	r4, r3, r0, lsl #14
 398:	01020c00 	tsteq	r2, r0, lsl #24
 39c:	0b0b0e03 	bleq	2c3bb0 <_bss_end+0x2ba494>
 3a0:	0b3b0b3a 	bleq	ec3090 <_bss_end+0xeb9974>
 3a4:	13010b39 	movwne	r0, #6969	; 0x1b39
 3a8:	0d0d0000 	stceq	0, cr0, [sp, #-0]
 3ac:	3a0e0300 	bcc	380fb4 <_bss_end+0x377898>
 3b0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 3b4:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 3b8:	0e00000b 	cdpeq	0, 0, cr0, cr0, cr11, {0}
 3bc:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 3c0:	0b3a0e03 	bleq	e83bd4 <_bss_end+0xe7a4b8>
 3c4:	0b390b3b 	bleq	e430b8 <_bss_end+0xe3999c>
 3c8:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 3cc:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 3d0:	13011364 	movwne	r1, #4964	; 0x1364
 3d4:	050f0000 	streq	r0, [pc, #-0]	; 3dc <shift+0x3dc>
 3d8:	34134900 	ldrcc	r4, [r3], #-2304	; 0xfffff700
 3dc:	10000019 	andne	r0, r0, r9, lsl r0
 3e0:	13490005 	movtne	r0, #36869	; 0x9005
 3e4:	2e110000 	cdpcs	0, 1, cr0, cr1, cr0, {0}
 3e8:	03193f01 	tsteq	r9, #1, 30
 3ec:	3b0b3a0e 	blcc	2cec2c <_bss_end+0x2c5510>
 3f0:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 3f4:	3c0b320e 	sfmcc	f3, 4, [fp], {14}
 3f8:	01136419 	tsteq	r3, r9, lsl r4
 3fc:	12000013 	andne	r0, r0, #19
 400:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 404:	0b3a0e03 	bleq	e83c18 <_bss_end+0xe7a4fc>
 408:	0b390b3b 	bleq	e430fc <_bss_end+0xe399e0>
 40c:	0b320e6e 	bleq	c83dcc <_bss_end+0xc7a6b0>
 410:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 414:	0f130000 	svceq	0x00130000
 418:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 41c:	14000013 	strne	r0, [r0], #-19	; 0xffffffed
 420:	0b0b0010 	bleq	2c0468 <_bss_end+0x2b6d4c>
 424:	00001349 	andeq	r1, r0, r9, asr #6
 428:	03003415 	movweq	r3, #1045	; 0x415
 42c:	3b0b3a0e 	blcc	2cec6c <_bss_end+0x2c5550>
 430:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 434:	3c193f13 	ldccc	15, cr3, [r9], {19}
 438:	16000019 			; <UNDEFINED> instruction: 0x16000019
 43c:	13470034 	movtne	r0, #28724	; 0x7034
 440:	0b3b0b3a 	bleq	ec3130 <_bss_end+0xeb9a14>
 444:	18020b39 	stmdane	r2, {r0, r3, r4, r5, r8, r9, fp}
 448:	2e170000 	cdpcs	0, 1, cr0, cr7, cr0, {0}
 44c:	340e0300 	strcc	r0, [lr], #-768	; 0xfffffd00
 450:	12011119 	andne	r1, r1, #1073741830	; 0x40000006
 454:	96184006 	ldrls	r4, [r8], -r6
 458:	00001942 	andeq	r1, r0, r2, asr #18
 45c:	03012e18 	movweq	r2, #7704	; 0x1e18
 460:	1119340e 	tstne	r9, lr, lsl #8
 464:	40061201 	andmi	r1, r6, r1, lsl #4
 468:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
 46c:	00001301 	andeq	r1, r0, r1, lsl #6
 470:	03000519 	movweq	r0, #1305	; 0x519
 474:	3b0b3a0e 	blcc	2cecb4 <_bss_end+0x2c5598>
 478:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 47c:	00180213 	andseq	r0, r8, r3, lsl r2
 480:	012e1a00 			; <UNDEFINED> instruction: 0x012e1a00
 484:	0b3a1347 	bleq	e851a8 <_bss_end+0xe7ba8c>
 488:	0b390b3b 	bleq	e4317c <_bss_end+0xe39a60>
 48c:	01111364 	tsteq	r1, r4, ror #6
 490:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 494:	01194296 			; <UNDEFINED> instruction: 0x01194296
 498:	1b000013 	blne	4ec <shift+0x4ec>
 49c:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
 4a0:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
 4a4:	00001802 	andeq	r1, r0, r2, lsl #16
 4a8:	0300051c 	movweq	r0, #1308	; 0x51c
 4ac:	3b0b3a08 	blcc	2cecd4 <_bss_end+0x2c55b8>
 4b0:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 4b4:	00180213 	andseq	r0, r8, r3, lsl r2
 4b8:	00341d00 	eorseq	r1, r4, r0, lsl #26
 4bc:	0b3a0803 	bleq	e824d0 <_bss_end+0xe78db4>
 4c0:	0b390b3b 	bleq	e431b4 <_bss_end+0xe39a98>
 4c4:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 4c8:	2e1e0000 	cdpcs	0, 1, cr0, cr14, cr0, {0}
 4cc:	3a134701 	bcc	4d20d8 <_bss_end+0x4c89bc>
 4d0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 4d4:	1113640b 	tstne	r3, fp, lsl #8
 4d8:	40061201 	andmi	r1, r6, r1, lsl #4
 4dc:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 4e0:	00001301 	andeq	r1, r0, r1, lsl #6
 4e4:	47012e1f 	smladmi	r1, pc, lr, r2	; <UNPREDICTABLE>
 4e8:	3b0b3a13 	blcc	2ced3c <_bss_end+0x2c5620>
 4ec:	640b390b 	strvs	r3, [fp], #-2315	; 0xfffff6f5
 4f0:	010b2013 	tsteq	fp, r3, lsl r0
 4f4:	20000013 	andcs	r0, r0, r3, lsl r0
 4f8:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
 4fc:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
 500:	05210000 	streq	r0, [r1, #-0]!
 504:	3a0e0300 	bcc	38110c <_bss_end+0x3779f0>
 508:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 50c:	0013490b 	andseq	r4, r3, fp, lsl #18
 510:	012e2200 			; <UNDEFINED> instruction: 0x012e2200
 514:	0e6e1331 	mcreq	3, 3, r1, cr14, cr1, {1}
 518:	01111364 	tsteq	r1, r4, ror #6
 51c:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 520:	00194297 	mulseq	r9, r7, r2
 524:	00052300 	andeq	r2, r5, r0, lsl #6
 528:	18021331 	stmdane	r2, {r0, r4, r5, r8, r9, ip}
 52c:	01000000 	mrseq	r0, (UNDEF: 0)
 530:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
 534:	0e030b13 	vmoveq.32	d3[0], r0
 538:	17550e1b 	smmlane	r5, fp, lr, r0
 53c:	17100111 			; <UNDEFINED> instruction: 0x17100111
 540:	02020000 	andeq	r0, r2, #0
 544:	0b0e0301 	bleq	381150 <_bss_end+0x377a34>
 548:	3b0b3a0b 	blcc	2ced7c <_bss_end+0x2c5660>
 54c:	010b390b 	tsteq	fp, fp, lsl #18
 550:	03000013 	movweq	r0, #19
 554:	0e030104 	adfeqs	f0, f3, f4
 558:	0b3e196d 	bleq	f86b14 <_bss_end+0xf7d3f8>
 55c:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 560:	0b3b0b3a 	bleq	ec3250 <_bss_end+0xeb9b34>
 564:	0b320b39 	bleq	c83250 <_bss_end+0xc79b34>
 568:	00001301 	andeq	r1, r0, r1, lsl #6
 56c:	03002804 	movweq	r2, #2052	; 0x804
 570:	000b1c08 	andeq	r1, fp, r8, lsl #24
 574:	00260500 	eoreq	r0, r6, r0, lsl #10
 578:	00001349 	andeq	r1, r0, r9, asr #6
 57c:	03011306 	movweq	r1, #4870	; 0x1306
 580:	3a0b0b0e 	bcc	2c31c0 <_bss_end+0x2b9aa4>
 584:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 588:	0013010b 	andseq	r0, r3, fp, lsl #2
 58c:	000d0700 	andeq	r0, sp, r0, lsl #14
 590:	0b3a0803 	bleq	e825a4 <_bss_end+0xe78e88>
 594:	0b390b3b 	bleq	e43288 <_bss_end+0xe39b6c>
 598:	0b381349 	bleq	e052c4 <_bss_end+0xdfbba8>
 59c:	0d080000 	stceq	0, cr0, [r8, #-0]
 5a0:	3a0e0300 	bcc	3811a8 <_bss_end+0x377a8c>
 5a4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 5a8:	3f13490b 	svccc	0x0013490b
 5ac:	3c0b3219 	sfmcc	f3, 4, [fp], {25}
 5b0:	6c0b1c19 	stcvs	12, cr1, [fp], {25}
 5b4:	09000019 	stmdbeq	r0, {r0, r3, r4}
 5b8:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 5bc:	0b3b0b3a 	bleq	ec32ac <_bss_end+0xeb9b90>
 5c0:	13490b39 	movtne	r0, #39737	; 0x9b39
 5c4:	0b32193f 	bleq	c86ac8 <_bss_end+0xc7d3ac>
 5c8:	196c193c 	stmdbne	ip!, {r2, r3, r4, r5, r8, fp, ip}^
 5cc:	2e0a0000 	cdpcs	0, 0, cr0, cr10, cr0, {0}
 5d0:	03193f01 	tsteq	r9, #1, 30
 5d4:	3b0b3a0e 	blcc	2cee14 <_bss_end+0x2c56f8>
 5d8:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 5dc:	3213490e 	andscc	r4, r3, #229376	; 0x38000
 5e0:	63193c0b 	tstvs	r9, #2816	; 0xb00
 5e4:	01136419 	tsteq	r3, r9, lsl r4
 5e8:	0b000013 	bleq	63c <shift+0x63c>
 5ec:	13490005 	movtne	r0, #36869	; 0x9005
 5f0:	00001934 	andeq	r1, r0, r4, lsr r9
 5f4:	4900050c 	stmdbmi	r0, {r2, r3, r8, sl}
 5f8:	0d000013 	stceq	0, cr0, [r0, #-76]	; 0xffffffb4
 5fc:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 600:	0b3a0e03 	bleq	e83e14 <_bss_end+0xe7a6f8>
 604:	0b390b3b 	bleq	e432f8 <_bss_end+0xe39bdc>
 608:	0b320e6e 	bleq	c83fc8 <_bss_end+0xc7a8ac>
 60c:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 610:	00001301 	andeq	r1, r0, r1, lsl #6
 614:	3f012e0e 	svccc	0x00012e0e
 618:	3a0e0319 	bcc	381284 <_bss_end+0x377b68>
 61c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 620:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 624:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
 628:	01136419 	tsteq	r3, r9, lsl r4
 62c:	0f000013 	svceq	0x00000013
 630:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 634:	0b3a0e03 	bleq	e83e48 <_bss_end+0xe7a72c>
 638:	0b390b3b 	bleq	e4332c <_bss_end+0xe39c10>
 63c:	193c0e6e 	ldmdbne	ip!, {r1, r2, r3, r5, r6, r9, sl, fp}
 640:	13011364 	movwne	r1, #4964	; 0x1364
 644:	0d100000 	ldceq	0, cr0, [r0, #-0]
 648:	3a0e0300 	bcc	381250 <_bss_end+0x377b34>
 64c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 650:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 654:	1100000b 	tstne	r0, fp
 658:	0b0b0024 	bleq	2c06f0 <_bss_end+0x2b6fd4>
 65c:	0e030b3e 	vmoveq.16	d3[0], r0
 660:	0f120000 	svceq	0x00120000
 664:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 668:	13000013 	movwne	r0, #19
 66c:	0b0b0010 	bleq	2c06b4 <_bss_end+0x2b6f98>
 670:	00001349 	andeq	r1, r0, r9, asr #6
 674:	49003514 	stmdbmi	r0, {r2, r4, r8, sl, ip, sp}
 678:	15000013 	strne	r0, [r0, #-19]	; 0xffffffed
 67c:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 680:	0b3b0b3a 	bleq	ec3370 <_bss_end+0xeb9c54>
 684:	13490b39 	movtne	r0, #39737	; 0x9b39
 688:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
 68c:	34160000 	ldrcc	r0, [r6], #-0
 690:	3a134700 	bcc	4d2298 <_bss_end+0x4c8b7c>
 694:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 698:	0018020b 	andseq	r0, r8, fp, lsl #4
 69c:	002e1700 	eoreq	r1, lr, r0, lsl #14
 6a0:	19340e03 	ldmdbne	r4!, {r0, r1, r9, sl, fp}
 6a4:	06120111 			; <UNDEFINED> instruction: 0x06120111
 6a8:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 6ac:	18000019 	stmdane	r0, {r0, r3, r4}
 6b0:	0e03012e 	adfeqsp	f0, f3, #0.5
 6b4:	01111934 	tsteq	r1, r4, lsr r9
 6b8:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 6bc:	01194296 			; <UNDEFINED> instruction: 0x01194296
 6c0:	19000013 	stmdbne	r0, {r0, r1, r4}
 6c4:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
 6c8:	0b3b0b3a 	bleq	ec33b8 <_bss_end+0xeb9c9c>
 6cc:	13490b39 	movtne	r0, #39737	; 0x9b39
 6d0:	00001802 	andeq	r1, r0, r2, lsl #16
 6d4:	0b00241a 	bleq	9744 <_bss_end+0x28>
 6d8:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 6dc:	1b000008 	blne	704 <shift+0x704>
 6e0:	1347012e 	movtne	r0, #28974	; 0x712e
 6e4:	0b3b0b3a 	bleq	ec33d4 <_bss_end+0xeb9cb8>
 6e8:	13640b39 	cmnne	r4, #58368	; 0xe400
 6ec:	06120111 			; <UNDEFINED> instruction: 0x06120111
 6f0:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 6f4:	00130119 	andseq	r0, r3, r9, lsl r1
 6f8:	00051c00 	andeq	r1, r5, r0, lsl #24
 6fc:	13490e03 	movtne	r0, #40451	; 0x9e03
 700:	18021934 	stmdane	r2, {r2, r4, r5, r8, fp, ip}
 704:	341d0000 	ldrcc	r0, [sp], #-0
 708:	3a080300 	bcc	201310 <_bss_end+0x1f7bf4>
 70c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 710:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 714:	1e000018 	mcrne	0, 0, r0, cr0, cr8, {0}
 718:	0111010b 	tsteq	r1, fp, lsl #2
 71c:	00000612 	andeq	r0, r0, r2, lsl r6
 720:	0300051f 	movweq	r0, #1311	; 0x51f
 724:	3b0b3a08 	blcc	2cef4c <_bss_end+0x2c5830>
 728:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 72c:	00180213 	andseq	r0, r8, r3, lsl r2
 730:	00342000 	eorseq	r2, r4, r0
 734:	0b3a0e03 	bleq	e83f48 <_bss_end+0xe7a82c>
 738:	0b390b3b 	bleq	e4342c <_bss_end+0xe39d10>
 73c:	196c1349 	stmdbne	ip!, {r0, r3, r6, r8, r9, ip}^
 740:	00001802 	andeq	r1, r0, r2, lsl #16
 744:	03003421 	movweq	r3, #1057	; 0x421
 748:	3b0b3a0e 	blcc	2cef88 <_bss_end+0x2c586c>
 74c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 750:	00180213 	andseq	r0, r8, r3, lsl r2
 754:	01012200 	mrseq	r2, R9_usr
 758:	13011349 	movwne	r1, #4937	; 0x1349
 75c:	21230000 			; <UNDEFINED> instruction: 0x21230000
 760:	2f134900 	svccs	0x00134900
 764:	2400000b 	strcs	r0, [r0], #-11
 768:	1347012e 	movtne	r0, #28974	; 0x712e
 76c:	0b3b0b3a 	bleq	ec345c <_bss_end+0xeb9d40>
 770:	13640b39 	cmnne	r4, #58368	; 0xe400
 774:	06120111 			; <UNDEFINED> instruction: 0x06120111
 778:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 77c:	00130119 	andseq	r0, r3, r9, lsl r1
 780:	010b2500 	tsteq	fp, r0, lsl #10
 784:	06120111 			; <UNDEFINED> instruction: 0x06120111
 788:	00001301 	andeq	r1, r0, r1, lsl #6
 78c:	47012e26 	strmi	r2, [r1, -r6, lsr #28]
 790:	3b0b3a13 	blcc	2cefe4 <_bss_end+0x2c58c8>
 794:	640b390b 	strvs	r3, [fp], #-2315	; 0xfffff6f5
 798:	010b2013 	tsteq	fp, r3, lsl r0
 79c:	27000013 	smladcs	r0, r3, r0, r0
 7a0:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
 7a4:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
 7a8:	05280000 	streq	r0, [r8, #-0]!
 7ac:	3a0e0300 	bcc	3813b4 <_bss_end+0x377c98>
 7b0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 7b4:	0013490b 	andseq	r4, r3, fp, lsl #18
 7b8:	012e2900 			; <UNDEFINED> instruction: 0x012e2900
 7bc:	0e6e1331 	mcreq	3, 3, r1, cr14, cr1, {1}
 7c0:	01111364 	tsteq	r1, r4, ror #6
 7c4:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 7c8:	00194297 	mulseq	r9, r7, r2
 7cc:	00052a00 	andeq	r2, r5, r0, lsl #20
 7d0:	18021331 	stmdane	r2, {r0, r4, r5, r8, r9, ip}
 7d4:	01000000 	mrseq	r0, (UNDEF: 0)
 7d8:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
 7dc:	0e030b13 	vmoveq.32	d3[0], r0
 7e0:	01110e1b 	tsteq	r1, fp, lsl lr
 7e4:	17100612 			; <UNDEFINED> instruction: 0x17100612
 7e8:	24020000 	strcs	r0, [r2], #-0
 7ec:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 7f0:	000e030b 	andeq	r0, lr, fp, lsl #6
 7f4:	00260300 	eoreq	r0, r6, r0, lsl #6
 7f8:	00001349 	andeq	r1, r0, r9, asr #6
 7fc:	0b002404 	bleq	9814 <_bss_end+0xf8>
 800:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 804:	05000008 	streq	r0, [r0, #-8]
 808:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
 80c:	0b3b0b3a 	bleq	ec34fc <_bss_end+0xeb9de0>
 810:	13490b39 	movtne	r0, #39737	; 0x9b39
 814:	39060000 	stmdbcc	r6, {}	; <UNPREDICTABLE>
 818:	3a080301 	bcc	201424 <_bss_end+0x1f7d08>
 81c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 820:	0013010b 	andseq	r0, r3, fp, lsl #2
 824:	00340700 	eorseq	r0, r4, r0, lsl #14
 828:	0b3a0e03 	bleq	e8403c <_bss_end+0xe7a920>
 82c:	0b390b3b 	bleq	e43520 <_bss_end+0xe39e04>
 830:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 834:	196c061c 	stmdbne	ip!, {r2, r3, r4, r9, sl}^
 838:	34080000 	strcc	r0, [r8], #-0
 83c:	3a0e0300 	bcc	381444 <_bss_end+0x377d28>
 840:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 844:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
 848:	6c0b1c19 	stcvs	12, cr1, [fp], {25}
 84c:	09000019 	stmdbeq	r0, {r0, r3, r4}
 850:	0e030104 	adfeqs	f0, f3, f4
 854:	0b3e196d 	bleq	f86e10 <_bss_end+0xf7d6f4>
 858:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 85c:	0b3b0b3a 	bleq	ec354c <_bss_end+0xeb9e30>
 860:	13010b39 	movwne	r0, #6969	; 0x1b39
 864:	280a0000 	stmdacs	sl, {}	; <UNPREDICTABLE>
 868:	1c080300 	stcne	3, cr0, [r8], {-0}
 86c:	0b00000b 	bleq	8a0 <shift+0x8a0>
 870:	0e030028 	cdpeq	0, 0, cr0, cr3, cr8, {1}
 874:	00000b1c 	andeq	r0, r0, ip, lsl fp
 878:	0301040c 	movweq	r0, #5132	; 0x140c
 87c:	3e196d0e 	cdpcc	13, 1, cr6, cr9, cr14, {0}
 880:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
 884:	3b0b3a13 	blcc	2cf0d8 <_bss_end+0x2c59bc>
 888:	000b390b 	andeq	r3, fp, fp, lsl #18
 88c:	00340d00 	eorseq	r0, r4, r0, lsl #26
 890:	00001347 	andeq	r1, r0, r7, asr #6
 894:	0301020e 	movweq	r0, #4622	; 0x120e
 898:	3a0b0b0e 	bcc	2c34d8 <_bss_end+0x2b9dbc>
 89c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 8a0:	0013010b 	andseq	r0, r3, fp, lsl #2
 8a4:	000d0f00 	andeq	r0, sp, r0, lsl #30
 8a8:	0b3a0e03 	bleq	e840bc <_bss_end+0xe7a9a0>
 8ac:	0b390b3b 	bleq	e435a0 <_bss_end+0xe39e84>
 8b0:	0b381349 	bleq	e055dc <_bss_end+0xdfbec0>
 8b4:	2e100000 	cdpcs	0, 1, cr0, cr0, cr0, {0}
 8b8:	03193f01 	tsteq	r9, #1, 30
 8bc:	3b0b3a0e 	blcc	2cf0fc <_bss_end+0x2c59e0>
 8c0:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 8c4:	3213490e 	andscc	r4, r3, #229376	; 0x38000
 8c8:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 8cc:	00130113 	andseq	r0, r3, r3, lsl r1
 8d0:	00051100 	andeq	r1, r5, r0, lsl #2
 8d4:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
 8d8:	05120000 	ldreq	r0, [r2, #-0]
 8dc:	00134900 	andseq	r4, r3, r0, lsl #18
 8e0:	012e1300 			; <UNDEFINED> instruction: 0x012e1300
 8e4:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 8e8:	0b3b0b3a 	bleq	ec35d8 <_bss_end+0xeb9ebc>
 8ec:	0e6e0b39 	vmoveq.8	d14[5], r0
 8f0:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 8f4:	13011364 	movwne	r1, #4964	; 0x1364
 8f8:	2e140000 	cdpcs	0, 1, cr0, cr4, cr0, {0}
 8fc:	03193f01 	tsteq	r9, #1, 30
 900:	3b0b3a0e 	blcc	2cf140 <_bss_end+0x2c5a24>
 904:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 908:	3213490e 	andscc	r4, r3, #229376	; 0x38000
 90c:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 910:	15000013 	strne	r0, [r0, #-19]	; 0xffffffed
 914:	0b0b000f 	bleq	2c0958 <_bss_end+0x2b723c>
 918:	00001349 	andeq	r1, r0, r9, asr #6
 91c:	03003416 	movweq	r3, #1046	; 0x416
 920:	3b0b3a0e 	blcc	2cf160 <_bss_end+0x2c5a44>
 924:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 928:	3c193f13 	ldccc	15, cr3, [r9], {19}
 92c:	17000019 	smladne	r0, r9, r0, r0
 930:	0e030028 	cdpeq	0, 0, cr0, cr3, cr8, {1}
 934:	0000051c 	andeq	r0, r0, ip, lsl r5
 938:	03002818 	movweq	r2, #2072	; 0x818
 93c:	00061c0e 	andeq	r1, r6, lr, lsl #24
 940:	012e1900 			; <UNDEFINED> instruction: 0x012e1900
 944:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 948:	0b3b0b3a 	bleq	ec3638 <_bss_end+0xeb9f1c>
 94c:	0e6e0b39 	vmoveq.8	d14[5], r0
 950:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 954:	00001364 	andeq	r1, r0, r4, ror #6
 958:	0b00101a 	bleq	49c8 <shift+0x49c8>
 95c:	0013490b 	andseq	r4, r3, fp, lsl #18
 960:	00341b00 	eorseq	r1, r4, r0, lsl #22
 964:	0b3a1347 	bleq	e85688 <_bss_end+0xe7bf6c>
 968:	0b390b3b 	bleq	e4365c <_bss_end+0xe39f40>
 96c:	00001802 	andeq	r1, r0, r2, lsl #16
 970:	03002e1c 	movweq	r2, #3612	; 0xe1c
 974:	1119340e 	tstne	r9, lr, lsl #8
 978:	40061201 	andmi	r1, r6, r1, lsl #4
 97c:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
 980:	2e1d0000 	cdpcs	0, 1, cr0, cr13, cr0, {0}
 984:	340e0301 	strcc	r0, [lr], #-769	; 0xfffffcff
 988:	12011119 	andne	r1, r1, #1073741830	; 0x40000006
 98c:	96184006 	ldrls	r4, [r8], -r6
 990:	13011942 	movwne	r1, #6466	; 0x1942
 994:	051e0000 	ldreq	r0, [lr, #-0]
 998:	3a0e0300 	bcc	3815a0 <_bss_end+0x377e84>
 99c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 9a0:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 9a4:	1f000018 	svcne	0x00000018
 9a8:	1347012e 	movtne	r0, #28974	; 0x712e
 9ac:	0b3b0b3a 	bleq	ec369c <_bss_end+0xeb9f80>
 9b0:	13640b39 	cmnne	r4, #58368	; 0xe400
 9b4:	06120111 			; <UNDEFINED> instruction: 0x06120111
 9b8:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 9bc:	00130119 	andseq	r0, r3, r9, lsl r1
 9c0:	00052000 	andeq	r2, r5, r0
 9c4:	13490e03 	movtne	r0, #40451	; 0x9e03
 9c8:	18021934 	stmdane	r2, {r2, r4, r5, r8, fp, ip}
 9cc:	05210000 	streq	r0, [r1, #-0]!
 9d0:	3a080300 	bcc	2015d8 <_bss_end+0x1f7ebc>
 9d4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 9d8:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 9dc:	22000018 	andcs	r0, r0, #24
 9e0:	08030034 	stmdaeq	r3, {r2, r4, r5}
 9e4:	0b3b0b3a 	bleq	ec36d4 <_bss_end+0xeb9fb8>
 9e8:	13490b39 	movtne	r0, #39737	; 0x9b39
 9ec:	00001802 	andeq	r1, r0, r2, lsl #16
 9f0:	03003423 	movweq	r3, #1059	; 0x423
 9f4:	3b0b3a0e 	blcc	2cf234 <_bss_end+0x2c5b18>
 9f8:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 9fc:	00180213 	andseq	r0, r8, r3, lsl r2
 a00:	00342400 	eorseq	r2, r4, r0, lsl #8
 a04:	0b3a0e03 	bleq	e84218 <_bss_end+0xe7aafc>
 a08:	0b390b3b 	bleq	e436fc <_bss_end+0xe39fe0>
 a0c:	196c1349 	stmdbne	ip!, {r0, r3, r6, r8, r9, ip}^
 a10:	00001802 	andeq	r1, r0, r2, lsl #16
 a14:	47012e25 	strmi	r2, [r1, -r5, lsr #28]
 a18:	3b0b3a13 	blcc	2cf26c <_bss_end+0x2c5b50>
 a1c:	640b390b 	strvs	r3, [fp], #-2315	; 0xfffff6f5
 a20:	010b2013 	tsteq	fp, r3, lsl r0
 a24:	26000013 			; <UNDEFINED> instruction: 0x26000013
 a28:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
 a2c:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
 a30:	05270000 	streq	r0, [r7, #-0]!
 a34:	3a080300 	bcc	20163c <_bss_end+0x1f7f20>
 a38:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 a3c:	0013490b 	andseq	r4, r3, fp, lsl #18
 a40:	012e2800 			; <UNDEFINED> instruction: 0x012e2800
 a44:	0e6e1331 	mcreq	3, 3, r1, cr14, cr1, {1}
 a48:	01111364 	tsteq	r1, r4, ror #6
 a4c:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 a50:	00194296 	mulseq	r9, r6, r2
 a54:	00052900 	andeq	r2, r5, r0, lsl #18
 a58:	18021331 	stmdane	r2, {r0, r4, r5, r8, r9, ip}
 a5c:	01000000 	mrseq	r0, (UNDEF: 0)
 a60:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
 a64:	0e030b13 	vmoveq.32	d3[0], r0
 a68:	01110e1b 	tsteq	r1, fp, lsl lr
 a6c:	17100612 			; <UNDEFINED> instruction: 0x17100612
 a70:	24020000 	strcs	r0, [r2], #-0
 a74:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 a78:	000e030b 	andeq	r0, lr, fp, lsl #6
 a7c:	00260300 	eoreq	r0, r6, r0, lsl #6
 a80:	00001349 	andeq	r1, r0, r9, asr #6
 a84:	0b002404 	bleq	9a9c <_bss_end+0x380>
 a88:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 a8c:	05000008 	streq	r0, [r0, #-8]
 a90:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
 a94:	0b3b0b3a 	bleq	ec3784 <_bss_end+0xeba068>
 a98:	13490b39 	movtne	r0, #39737	; 0x9b39
 a9c:	35060000 	strcc	r0, [r6, #-0]
 aa0:	00134900 	andseq	r4, r3, r0, lsl #18
 aa4:	000f0700 	andeq	r0, pc, r0, lsl #14
 aa8:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 aac:	39080000 	stmdbcc	r8, {}	; <UNPREDICTABLE>
 ab0:	3a080301 	bcc	2016bc <_bss_end+0x1f7fa0>
 ab4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 ab8:	0013010b 	andseq	r0, r3, fp, lsl #2
 abc:	00340900 	eorseq	r0, r4, r0, lsl #18
 ac0:	0b3a0e03 	bleq	e842d4 <_bss_end+0xe7abb8>
 ac4:	0b390b3b 	bleq	e437b8 <_bss_end+0xe3a09c>
 ac8:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 acc:	196c061c 	stmdbne	ip!, {r2, r3, r4, r9, sl}^
 ad0:	340a0000 	strcc	r0, [sl], #-0
 ad4:	3a0e0300 	bcc	3816dc <_bss_end+0x377fc0>
 ad8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 adc:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
 ae0:	6c0b1c19 	stcvs	12, cr1, [fp], {25}
 ae4:	0b000019 	bleq	b50 <shift+0xb50>
 ae8:	0e030104 	adfeqs	f0, f3, f4
 aec:	0b3e196d 	bleq	f870a8 <_bss_end+0xf7d98c>
 af0:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 af4:	0b3b0b3a 	bleq	ec37e4 <_bss_end+0xeba0c8>
 af8:	13010b39 	movwne	r0, #6969	; 0x1b39
 afc:	280c0000 	stmdacs	ip, {}	; <UNPREDICTABLE>
 b00:	1c080300 	stcne	3, cr0, [r8], {-0}
 b04:	0d00000b 	stceq	0, cr0, [r0, #-44]	; 0xffffffd4
 b08:	0e030028 	cdpeq	0, 0, cr0, cr3, cr8, {1}
 b0c:	00000b1c 	andeq	r0, r0, ip, lsl fp
 b10:	0301040e 	movweq	r0, #5134	; 0x140e
 b14:	3e196d0e 	cdpcc	13, 1, cr6, cr9, cr14, {0}
 b18:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
 b1c:	3b0b3a13 	blcc	2cf370 <_bss_end+0x2c5c54>
 b20:	000b390b 	andeq	r3, fp, fp, lsl #18
 b24:	00340f00 	eorseq	r0, r4, r0, lsl #30
 b28:	00001347 	andeq	r1, r0, r7, asr #6
 b2c:	03010210 	movweq	r0, #4624	; 0x1210
 b30:	3a0b0b0e 	bcc	2c3770 <_bss_end+0x2ba054>
 b34:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 b38:	0013010b 	andseq	r0, r3, fp, lsl #2
 b3c:	000d1100 	andeq	r1, sp, r0, lsl #2
 b40:	0b3a0e03 	bleq	e84354 <_bss_end+0xe7ac38>
 b44:	0b390b3b 	bleq	e43838 <_bss_end+0xe3a11c>
 b48:	0b381349 	bleq	e05874 <_bss_end+0xdfc158>
 b4c:	2e120000 	cdpcs	0, 1, cr0, cr2, cr0, {0}
 b50:	03193f01 	tsteq	r9, #1, 30
 b54:	3b0b3a0e 	blcc	2cf394 <_bss_end+0x2c5c78>
 b58:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 b5c:	3213490e 	andscc	r4, r3, #229376	; 0x38000
 b60:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 b64:	00130113 	andseq	r0, r3, r3, lsl r1
 b68:	00051300 	andeq	r1, r5, r0, lsl #6
 b6c:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
 b70:	05140000 	ldreq	r0, [r4, #-0]
 b74:	00134900 	andseq	r4, r3, r0, lsl #18
 b78:	012e1500 			; <UNDEFINED> instruction: 0x012e1500
 b7c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 b80:	0b3b0b3a 	bleq	ec3870 <_bss_end+0xeba154>
 b84:	0e6e0b39 	vmoveq.8	d14[5], r0
 b88:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 b8c:	13011364 	movwne	r1, #4964	; 0x1364
 b90:	2e160000 	cdpcs	0, 1, cr0, cr6, cr0, {0}
 b94:	03193f01 	tsteq	r9, #1, 30
 b98:	3b0b3a0e 	blcc	2cf3d8 <_bss_end+0x2c5cbc>
 b9c:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 ba0:	3213490e 	andscc	r4, r3, #229376	; 0x38000
 ba4:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 ba8:	17000013 	smladne	r0, r3, r0, r0
 bac:	0e030028 	cdpeq	0, 0, cr0, cr3, cr8, {1}
 bb0:	0000051c 	andeq	r0, r0, ip, lsl r5
 bb4:	03002818 	movweq	r2, #2072	; 0x818
 bb8:	00061c0e 	andeq	r1, r6, lr, lsl #24
 bbc:	012e1900 			; <UNDEFINED> instruction: 0x012e1900
 bc0:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 bc4:	0b3b0b3a 	bleq	ec38b4 <_bss_end+0xeba198>
 bc8:	0e6e0b39 	vmoveq.8	d14[5], r0
 bcc:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 bd0:	00001364 	andeq	r1, r0, r4, ror #6
 bd4:	0b00101a 	bleq	4c44 <shift+0x4c44>
 bd8:	0013490b 	andseq	r4, r3, fp, lsl #18
 bdc:	00341b00 	eorseq	r1, r4, r0, lsl #22
 be0:	0b3a0e03 	bleq	e843f4 <_bss_end+0xe7acd8>
 be4:	0b390b3b 	bleq	e438d8 <_bss_end+0xe3a1bc>
 be8:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
 bec:	0000193c 	andeq	r1, r0, ip, lsr r9
 bf0:	3f012e1c 	svccc	0x00012e1c
 bf4:	3a0e0319 	bcc	381860 <_bss_end+0x378144>
 bf8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 bfc:	1113490b 	tstne	r3, fp, lsl #18
 c00:	40061201 	andmi	r1, r6, r1, lsl #4
 c04:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
 c08:	341d0000 	ldrcc	r0, [sp], #-0
 c0c:	3a080300 	bcc	201814 <_bss_end+0x1f80f8>
 c10:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 c14:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 c18:	00000018 	andeq	r0, r0, r8, lsl r0
 c1c:	10001101 	andne	r1, r0, r1, lsl #2
 c20:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
 c24:	1b0e0301 	blne	381830 <_bss_end+0x378114>
 c28:	130e250e 	movwne	r2, #58638	; 0xe50e
 c2c:	00000005 	andeq	r0, r0, r5
 c30:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
 c34:	030b130e 	movweq	r1, #45838	; 0xb30e
 c38:	110e1b0e 	tstne	lr, lr, lsl #22
 c3c:	10061201 	andne	r1, r6, r1, lsl #4
 c40:	02000017 	andeq	r0, r0, #23
 c44:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
 c48:	0b3b0b3a 	bleq	ec3938 <_bss_end+0xeba21c>
 c4c:	13490b39 	movtne	r0, #39737	; 0x9b39
 c50:	0f030000 	svceq	0x00030000
 c54:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 c58:	04000013 	streq	r0, [r0], #-19	; 0xffffffed
 c5c:	00000015 	andeq	r0, r0, r5, lsl r0
 c60:	03003405 	movweq	r3, #1029	; 0x405
 c64:	3b0b3a0e 	blcc	2cf4a4 <_bss_end+0x2c5d88>
 c68:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 c6c:	3c193f13 	ldccc	15, cr3, [r9], {19}
 c70:	06000019 			; <UNDEFINED> instruction: 0x06000019
 c74:	0b0b0024 	bleq	2c0d0c <_bss_end+0x2b75f0>
 c78:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
 c7c:	01070000 	mrseq	r0, (UNDEF: 7)
 c80:	01134901 	tsteq	r3, r1, lsl #18
 c84:	08000013 	stmdaeq	r0, {r0, r1, r4}
 c88:	13490021 	movtne	r0, #36897	; 0x9021
 c8c:	0000062f 	andeq	r0, r0, pc, lsr #12
 c90:	0b002409 	bleq	9cbc <_bss_end+0x5a0>
 c94:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 c98:	0a00000e 	beq	cd8 <shift+0xcd8>
 c9c:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 ca0:	0b3a0e03 	bleq	e844b4 <_bss_end+0xe7ad98>
 ca4:	0b390b3b 	bleq	e43998 <_bss_end+0xe3a27c>
 ca8:	01111349 	tsteq	r1, r9, asr #6
 cac:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 cb0:	01194296 			; <UNDEFINED> instruction: 0x01194296
 cb4:	0b000013 	bleq	d08 <shift+0xd08>
 cb8:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 cbc:	0b3b0b3a 	bleq	ec39ac <_bss_end+0xeba290>
 cc0:	13490b39 	movtne	r0, #39737	; 0x9b39
 cc4:	00001802 	andeq	r1, r0, r2, lsl #16
 cc8:	3f012e0c 	svccc	0x00012e0c
 ccc:	3a0e0319 	bcc	381938 <_bss_end+0x37821c>
 cd0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 cd4:	1113490b 	tstne	r3, fp, lsl #18
 cd8:	40061201 	andmi	r1, r6, r1, lsl #4
 cdc:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 ce0:	00001301 	andeq	r1, r0, r1, lsl #6
 ce4:	0300340d 	movweq	r3, #1037	; 0x40d
 ce8:	3b0b3a08 	blcc	2cf510 <_bss_end+0x2c5df4>
 cec:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 cf0:	00180213 	andseq	r0, r8, r3, lsl r2
 cf4:	11010000 	mrsne	r0, (UNDEF: 1)
 cf8:	11061000 	mrsne	r1, (UNDEF: 6)
 cfc:	03011201 	movweq	r1, #4609	; 0x1201
 d00:	250e1b0e 	strcs	r1, [lr, #-2830]	; 0xfffff4f2
 d04:	0005130e 	andeq	r1, r5, lr, lsl #6
 d08:	11010000 	mrsne	r0, (UNDEF: 1)
 d0c:	11061000 	mrsne	r1, (UNDEF: 6)
 d10:	03011201 	movweq	r1, #4609	; 0x1201
 d14:	250e1b0e 	strcs	r1, [lr, #-2830]	; 0xfffff4f2
 d18:	0005130e 	andeq	r1, r5, lr, lsl #6
 d1c:	11010000 	mrsne	r0, (UNDEF: 1)
 d20:	130e2501 	movwne	r2, #58625	; 0xe501
 d24:	1b0e030b 	blne	381958 <_bss_end+0x37823c>
 d28:	0017100e 	andseq	r1, r7, lr
 d2c:	00240200 	eoreq	r0, r4, r0, lsl #4
 d30:	0b3e0b0b 	bleq	f83964 <_bss_end+0xf7a248>
 d34:	00000803 	andeq	r0, r0, r3, lsl #16
 d38:	0b002403 	bleq	9d4c <_bss_end+0x630>
 d3c:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 d40:	0400000e 	streq	r0, [r0], #-14
 d44:	0e030104 	adfeqs	f0, f3, f4
 d48:	0b0b0b3e 	bleq	2c3a48 <_bss_end+0x2ba32c>
 d4c:	0b3a1349 	bleq	e85a78 <_bss_end+0xe7c35c>
 d50:	0b390b3b 	bleq	e43a44 <_bss_end+0xe3a328>
 d54:	00001301 	andeq	r1, r0, r1, lsl #6
 d58:	03002805 	movweq	r2, #2053	; 0x805
 d5c:	000b1c0e 	andeq	r1, fp, lr, lsl #24
 d60:	01130600 	tsteq	r3, r0, lsl #12
 d64:	0b0b0e03 	bleq	2c4578 <_bss_end+0x2bae5c>
 d68:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 d6c:	13010b39 	movwne	r0, #6969	; 0x1b39
 d70:	0d070000 	stceq	0, cr0, [r7, #-0]
 d74:	3a0e0300 	bcc	38197c <_bss_end+0x378260>
 d78:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 d7c:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 d80:	0800000b 	stmdaeq	r0, {r0, r1, r3}
 d84:	13490026 	movtne	r0, #36902	; 0x9026
 d88:	01090000 	mrseq	r0, (UNDEF: 9)
 d8c:	01134901 	tsteq	r3, r1, lsl #18
 d90:	0a000013 	beq	de4 <shift+0xde4>
 d94:	13490021 	movtne	r0, #36897	; 0x9021
 d98:	00000b2f 	andeq	r0, r0, pc, lsr #22
 d9c:	0300340b 	movweq	r3, #1035	; 0x40b
 da0:	3b0b3a0e 	blcc	2cf5e0 <_bss_end+0x2c5ec4>
 da4:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
 da8:	000a1c13 	andeq	r1, sl, r3, lsl ip
 dac:	00150c00 	andseq	r0, r5, r0, lsl #24
 db0:	00001927 	andeq	r1, r0, r7, lsr #18
 db4:	0b000f0d 	bleq	49f0 <shift+0x49f0>
 db8:	0013490b 	andseq	r4, r3, fp, lsl #18
 dbc:	01040e00 	tsteq	r4, r0, lsl #28
 dc0:	0b3e0e03 	bleq	f845d4 <_bss_end+0xf7aeb8>
 dc4:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 dc8:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 dcc:	13010b39 	movwne	r0, #6969	; 0x1b39
 dd0:	160f0000 	strne	r0, [pc], -r0
 dd4:	3a0e0300 	bcc	3819dc <_bss_end+0x3782c0>
 dd8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 ddc:	0013490b 	andseq	r4, r3, fp, lsl #18
 de0:	00211000 	eoreq	r1, r1, r0
 de4:	34110000 	ldrcc	r0, [r1], #-0
 de8:	3a0e0300 	bcc	3819f0 <_bss_end+0x3782d4>
 dec:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 df0:	3f13490b 	svccc	0x0013490b
 df4:	00193c19 	andseq	r3, r9, r9, lsl ip
 df8:	00341200 	eorseq	r1, r4, r0, lsl #4
 dfc:	0b3a1347 	bleq	e85b20 <_bss_end+0xe7c404>
 e00:	0b39053b 	bleq	e422f4 <_bss_end+0xe38bd8>
 e04:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 e08:	Address 0x0000000000000e08 is out of bounds.


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
  44:	051e0002 	ldreq	r0, [lr, #-2]
  48:	00040000 	andeq	r0, r4, r0
  4c:	00000000 	andeq	r0, r0, r0
  50:	000082b8 			; <UNDEFINED> instruction: 0x000082b8
  54:	00000500 	andeq	r0, r0, r0, lsl #10
	...
  60:	00000034 	andeq	r0, r0, r4, lsr r0
  64:	0ba70002 	bleq	fe9c0074 <_bss_end+0xfe9b6958>
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
  9c:	125f0002 	subsne	r0, pc, #2
  a0:	00040000 	andeq	r0, r4, r0
  a4:	00000000 	andeq	r0, r0, r0
  a8:	00008eec 	andeq	r8, r0, ip, ror #29
  ac:	000002fc 	strdeq	r0, [r0], -ip
	...
  b8:	0000001c 	andeq	r0, r0, ip, lsl r0
  bc:	17d20002 	ldrbne	r0, [r2, r2]
  c0:	00040000 	andeq	r0, r4, r0
  c4:	00000000 	andeq	r0, r0, r0
  c8:	000091e8 	andeq	r9, r0, r8, ror #3
  cc:	0000006c 	andeq	r0, r0, ip, rrx
	...
  d8:	0000001c 	andeq	r0, r0, ip, lsl r0
  dc:	1bac0002 	blne	feb000ec <_bss_end+0xfeaf69d0>
  e0:	00040000 	andeq	r0, r4, r0
  e4:	00000000 	andeq	r0, r0, r0
  e8:	00008000 	andeq	r8, r0, r0
  ec:	00000018 	andeq	r0, r0, r8, lsl r0
	...
  f8:	0000001c 	andeq	r0, r0, ip, lsl r0
  fc:	1bd20002 	blne	ff48010c <_bss_end+0xff4769f0>
 100:	00040000 	andeq	r0, r4, r0
 104:	00000000 	andeq	r0, r0, r0
 108:	00009254 	andeq	r9, r0, r4, asr r2
 10c:	00000118 	andeq	r0, r0, r8, lsl r1
	...
 118:	0000001c 	andeq	r0, r0, ip, lsl r0
 11c:	1d210002 	stcne	0, cr0, [r1, #-8]!
 120:	00040000 	andeq	r0, r4, r0
 124:	00000000 	andeq	r0, r0, r0
 128:	0000936c 	andeq	r9, r0, ip, ror #6
 12c:	0000020c 	andeq	r0, r0, ip, lsl #4
	...
 138:	0000001c 	andeq	r0, r0, ip, lsl r0
 13c:	1d470002 	stclne	0, cr0, [r7, #-8]
 140:	00040000 	andeq	r0, r4, r0
 144:	00000000 	andeq	r0, r0, r0
 148:	00009578 	andeq	r9, r0, r8, ror r5
 14c:	00000004 	andeq	r0, r0, r4
	...
 158:	00000014 	andeq	r0, r0, r4, lsl r0
 15c:	1d6d0002 	stclne	0, cr0, [sp, #-8]!
 160:	00040000 	andeq	r0, r4, r0
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
  1c:	2f746e6d 	svccs	0x00746e6d
  20:	73552f63 	cmpvc	r5, #396	; 0x18c
  24:	2f737265 	svccs	0x00737265
  28:	6162754b 	cmnvs	r2, fp, asr #10
  2c:	636f442f 	cmnvs	pc, #788529152	; 0x2f000000
  30:	6e656d75 	mcrvs	13, 3, r6, cr5, cr5, {3}
  34:	5a2f7374 	bpl	bdce0c <_bss_end+0xbd36f0>
  38:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; fffffeac <_bss_end+0xffff6790>
  3c:	2f657461 	svccs	0x00657461
  40:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
  44:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
  48:	2d38312f 	ldfcss	f3, [r8, #-188]!	; 0xffffff44
  4c:	54524155 	ldrbpl	r4, [r2], #-341	; 0xfffffeab
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
  a8:	01a60101 			; <UNDEFINED> instruction: 0x01a60101
  ac:	00030000 	andeq	r0, r3, r0
  b0:	00000136 	andeq	r0, r0, r6, lsr r1
  b4:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
  b8:	0101000d 	tsteq	r1, sp
  bc:	00000101 	andeq	r0, r0, r1, lsl #2
  c0:	00000100 	andeq	r0, r0, r0, lsl #2
  c4:	6e6d2f01 	cdpvs	15, 6, cr2, cr13, cr1, {0}
  c8:	2f632f74 	svccs	0x00632f74
  cc:	72657355 	rsbvc	r7, r5, #1409286145	; 0x54000001
  d0:	754b2f73 	strbvc	r2, [fp, #-3955]	; 0xfffff08d
  d4:	442f6162 	strtmi	r6, [pc], #-354	; dc <shift+0xdc>
  d8:	6d75636f 	ldclvs	3, cr6, [r5, #-444]!	; 0xfffffe44
  dc:	73746e65 	cmnvc	r4, #1616	; 0x650
  e0:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
  e4:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
  e8:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
  ec:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
  f0:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
  f4:	41552d38 	cmpmi	r5, r8, lsr sp
  f8:	6b2f5452 	blvs	bd5248 <_bss_end+0xbcbb2c>
  fc:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 100:	72732f6c 	rsbsvc	r2, r3, #108, 30	; 0x1b0
 104:	72642f63 	rsbvc	r2, r4, #396	; 0x18c
 108:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
 10c:	6d2f0073 	stcvs	0, cr0, [pc, #-460]!	; ffffff48 <_bss_end+0xffff682c>
 110:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
 114:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
 118:	4b2f7372 	blmi	bdcee8 <_bss_end+0xbd37cc>
 11c:	2f616275 	svccs	0x00616275
 120:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
 124:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
 128:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
 12c:	614d6f72 	hvcvs	55026	; 0xd6f2
 130:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffbc4 <_bss_end+0xffff64a8>
 134:	706d6178 	rsbvc	r6, sp, r8, ror r1
 138:	2f73656c 	svccs	0x0073656c
 13c:	552d3831 	strpl	r3, [sp, #-2097]!	; 0xfffff7cf
 140:	2f545241 	svccs	0x00545241
 144:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 148:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 14c:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 150:	622f6564 	eorvs	r6, pc, #100, 10	; 0x19000000
 154:	6472616f 	ldrbtvs	r6, [r2], #-367	; 0xfffffe91
 158:	6970722f 	ldmdbvs	r0!, {r0, r1, r2, r3, r5, r9, ip, sp, lr}^
 15c:	61682f30 	cmnvs	r8, r0, lsr pc
 160:	6d2f006c 	stcvs	0, cr0, [pc, #-432]!	; ffffffb8 <_bss_end+0xffff689c>
 164:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
 168:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
 16c:	4b2f7372 	blmi	bdcf3c <_bss_end+0xbd3820>
 170:	2f616275 	svccs	0x00616275
 174:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
 178:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
 17c:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
 180:	614d6f72 	hvcvs	55026	; 0xd6f2
 184:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffc18 <_bss_end+0xffff64fc>
 188:	706d6178 	rsbvc	r6, sp, r8, ror r1
 18c:	2f73656c 	svccs	0x0073656c
 190:	552d3831 	strpl	r3, [sp, #-2097]!	; 0xfffff7cf
 194:	2f545241 	svccs	0x00545241
 198:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 19c:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 1a0:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 1a4:	642f6564 	strtvs	r6, [pc], #-1380	; 1ac <shift+0x1ac>
 1a8:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
 1ac:	00007372 	andeq	r7, r0, r2, ror r3
 1b0:	5f6d6362 	svcpl	0x006d6362
 1b4:	2e787561 	cdpcs	5, 7, cr7, cr8, cr1, {3}
 1b8:	00707063 	rsbseq	r7, r0, r3, rrx
 1bc:	70000001 	andvc	r0, r0, r1
 1c0:	70697265 	rsbvc	r7, r9, r5, ror #4
 1c4:	61726568 	cmnvs	r2, r8, ror #10
 1c8:	682e736c 	stmdavs	lr!, {r2, r3, r5, r6, r8, r9, ip, sp, lr}
 1cc:	00000200 	andeq	r0, r0, r0, lsl #4
 1d0:	5f6d6362 	svcpl	0x006d6362
 1d4:	2e787561 	cdpcs	5, 7, cr7, cr8, cr1, {3}
 1d8:	00030068 	andeq	r0, r3, r8, rrx
 1dc:	746e6900 	strbtvc	r6, [lr], #-2304	; 0xfffff700
 1e0:	2e666564 	cdpcs	5, 6, cr6, cr6, cr4, {3}
 1e4:	00020068 	andeq	r0, r2, r8, rrx
 1e8:	01050000 	mrseq	r0, (UNDEF: 5)
 1ec:	f0020500 			; <UNDEFINED> instruction: 0xf0020500
 1f0:	16000080 	strne	r0, [r0], -r0, lsl #1
 1f4:	059f3505 	ldreq	r3, [pc, #1285]	; 701 <shift+0x701>
 1f8:	05a16901 	streq	r6, [r1, #2305]!	; 0x901
 1fc:	3e05a01e 	mcrcc	0, 0, sl, cr5, cr14, {0}
 200:	2e3b0582 	cfadd32cs	mvfx0, mvfx11, mvfx2
 204:	05491105 	strbeq	r1, [r9, #-261]	; 0xfffffefb
 208:	0569a001 	strbeq	sl, [r9, #-1]!
 20c:	3f05a01e 	svccc	0x0005a01e
 210:	2e3c0582 	cfadd32cs	mvfx0, mvfx12, mvfx2
 214:	054a3805 	strbeq	r3, [sl, #-2053]	; 0xfffff7fb
 218:	01052d11 	tsteq	r5, r1, lsl sp
 21c:	050569a0 	streq	r6, [r5, #-2464]	; 0xfffff660
 220:	4a0e05bb 	bmi	381914 <_bss_end+0x3781f8>
 224:	052e3005 	streq	r3, [lr, #-5]!
 228:	01054a32 	tsteq	r5, r2, lsr sl
 22c:	0c05854b 	cfstr32eq	mvfx8, [r5], {75}	; 0x4b
 230:	4a15059f 	bmi	5418b4 <_bss_end+0x538198>
 234:	052e3705 	streq	r3, [lr, #-1797]!	; 0xfffff8fb
 238:	9e826701 	cdpls	7, 8, cr6, cr2, cr1, {0}
 23c:	01040200 	mrseq	r0, R12_usr
 240:	18056606 	stmdane	r5, {r1, r2, r9, sl, sp, lr}
 244:	82640306 	rsbhi	r0, r4, #402653184	; 0x18000000
 248:	1c030105 	stfnes	f0, [r3], {5}
 24c:	024aba66 	subeq	fp, sl, #417792	; 0x66000
 250:	0101000a 	tsteq	r1, sl
 254:	000002e5 	andeq	r0, r0, r5, ror #5
 258:	01300003 	teqeq	r0, r3
 25c:	01020000 	mrseq	r0, (UNDEF: 2)
 260:	000d0efb 	strdeq	r0, [sp], -fp
 264:	01010101 	tsteq	r1, r1, lsl #2
 268:	01000000 	mrseq	r0, (UNDEF: 0)
 26c:	2f010000 	svccs	0x00010000
 270:	2f746e6d 	svccs	0x00746e6d
 274:	73552f63 	cmpvc	r5, #396	; 0x18c
 278:	2f737265 	svccs	0x00737265
 27c:	6162754b 	cmnvs	r2, fp, asr #10
 280:	636f442f 	cmnvs	pc, #788529152	; 0x2f000000
 284:	6e656d75 	mcrvs	13, 3, r6, cr5, cr5, {3}
 288:	5a2f7374 	bpl	bdd060 <_bss_end+0xbd3944>
 28c:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 100 <shift+0x100>
 290:	2f657461 	svccs	0x00657461
 294:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
 298:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
 29c:	2d38312f 	ldfcss	f3, [r8, #-188]!	; 0xffffff44
 2a0:	54524155 	ldrbpl	r4, [r2], #-341	; 0xfffffeab
 2a4:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 2a8:	2f6c656e 	svccs	0x006c656e
 2ac:	2f637273 	svccs	0x00637273
 2b0:	76697264 	strbtvc	r7, [r9], -r4, ror #4
 2b4:	00737265 	rsbseq	r7, r3, r5, ror #4
 2b8:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
 2bc:	552f632f 	strpl	r6, [pc, #-815]!	; ffffff95 <_bss_end+0xffff6879>
 2c0:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 2c4:	62754b2f 	rsbsvs	r4, r5, #48128	; 0xbc00
 2c8:	6f442f61 	svcvs	0x00442f61
 2cc:	656d7563 	strbvs	r7, [sp, #-1379]!	; 0xfffffa9d
 2d0:	2f73746e 	svccs	0x0073746e
 2d4:	6f72655a 	svcvs	0x0072655a
 2d8:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
 2dc:	6178652f 	cmnvs	r8, pc, lsr #10
 2e0:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
 2e4:	38312f73 	ldmdacc	r1!, {r0, r1, r4, r5, r6, r8, r9, sl, fp, sp}
 2e8:	5241552d 	subpl	r5, r1, #188743680	; 0xb400000
 2ec:	656b2f54 	strbvs	r2, [fp, #-3924]!	; 0xfffff0ac
 2f0:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
 2f4:	636e692f 	cmnvs	lr, #770048	; 0xbc000
 2f8:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
 2fc:	616f622f 	cmnvs	pc, pc, lsr #4
 300:	722f6472 	eorvc	r6, pc, #1912602624	; 0x72000000
 304:	2f306970 	svccs	0x00306970
 308:	006c6168 	rsbeq	r6, ip, r8, ror #2
 30c:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
 310:	552f632f 	strpl	r6, [pc, #-815]!	; ffffffe9 <_bss_end+0xffff68cd>
 314:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 318:	62754b2f 	rsbsvs	r4, r5, #48128	; 0xbc00
 31c:	6f442f61 	svcvs	0x00442f61
 320:	656d7563 	strbvs	r7, [sp, #-1379]!	; 0xfffffa9d
 324:	2f73746e 	svccs	0x0073746e
 328:	6f72655a 	svcvs	0x0072655a
 32c:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
 330:	6178652f 	cmnvs	r8, pc, lsr #10
 334:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
 338:	38312f73 	ldmdacc	r1!, {r0, r1, r4, r5, r6, r8, r9, sl, fp, sp}
 33c:	5241552d 	subpl	r5, r1, #188743680	; 0xb400000
 340:	656b2f54 	strbvs	r2, [fp, #-3924]!	; 0xfffff0ac
 344:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
 348:	636e692f 	cmnvs	lr, #770048	; 0xbc000
 34c:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
 350:	6972642f 	ldmdbvs	r2!, {r0, r1, r2, r3, r5, sl, sp, lr}^
 354:	73726576 	cmnvc	r2, #494927872	; 0x1d800000
 358:	70670000 	rsbvc	r0, r7, r0
 35c:	632e6f69 			; <UNDEFINED> instruction: 0x632e6f69
 360:	01007070 	tsteq	r0, r0, ror r0
 364:	6e690000 	cdpvs	0, 6, cr0, cr9, cr0, {0}
 368:	66656474 			; <UNDEFINED> instruction: 0x66656474
 36c:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 370:	65700000 	ldrbvs	r0, [r0, #-0]!
 374:	68706972 	ldmdavs	r0!, {r1, r4, r5, r6, r8, fp, sp, lr}^
 378:	6c617265 	sfmvs	f7, 2, [r1], #-404	; 0xfffffe6c
 37c:	00682e73 	rsbeq	r2, r8, r3, ror lr
 380:	67000002 	strvs	r0, [r0, -r2]
 384:	2e6f6970 			; <UNDEFINED> instruction: 0x2e6f6970
 388:	00030068 	andeq	r0, r3, r8, rrx
 38c:	01050000 	mrseq	r0, (UNDEF: 5)
 390:	b8020500 	stmdalt	r2, {r8, sl}
 394:	17000082 	strne	r0, [r0, -r2, lsl #1]
 398:	059f3805 	ldreq	r3, [pc, #2053]	; ba5 <shift+0xba5>
 39c:	05a16901 	streq	r6, [r1, #2305]!	; 0x901
 3a0:	1005d705 	andne	sp, r5, r5, lsl #14
 3a4:	4c110567 	cfldr32mi	mvfx0, [r1], {103}	; 0x67
 3a8:	05820505 	streq	r0, [r2, #1285]	; 0x505
 3ac:	05230811 	streq	r0, [r3, #-2065]!	; 0xfffff7ef
 3b0:	1105670d 	tstne	r5, sp, lsl #14
 3b4:	670d0530 	smladxvs	sp, r0, r5, r0
 3b8:	05301105 	ldreq	r1, [r0, #-261]!	; 0xfffffefb
 3bc:	1105670d 	tstne	r5, sp, lsl #14
 3c0:	670d0530 	smladxvs	sp, r0, r5, r0
 3c4:	05301105 	ldreq	r1, [r0, #-261]!	; 0xfffffefb
 3c8:	1105670d 	tstne	r5, sp, lsl #14
 3cc:	670d0530 	smladxvs	sp, r0, r5, r0
 3d0:	05311405 	ldreq	r1, [r1, #-1029]!	; 0xfffffbfb
 3d4:	0520081a 	streq	r0, [r0, #-2074]!	; 0xfffff7e6
 3d8:	0c05660d 	stceq	6, cr6, [r5], {13}
 3dc:	2f01054c 	svccs	0x0001054c
 3e0:	d70505a1 	strle	r0, [r5, -r1, lsr #11]
 3e4:	05671005 	strbeq	r1, [r7, #-5]!
 3e8:	02004c0b 	andeq	r4, r0, #2816	; 0xb00
 3ec:	66060104 	strvs	r0, [r6], -r4, lsl #2
 3f0:	02040200 	andeq	r0, r4, #0, 4
 3f4:	0009054a 	andeq	r0, r9, sl, asr #10
 3f8:	06040402 	streq	r0, [r4], -r2, lsl #8
 3fc:	0013052e 	andseq	r0, r3, lr, lsr #10
 400:	4b040402 	blmi	101410 <_bss_end+0xf7cf4>
 404:	02000d05 	andeq	r0, r0, #320	; 0x140
 408:	054a0404 	strbeq	r0, [sl, #-1028]	; 0xfffffbfc
 40c:	0402000c 	streq	r0, [r2], #-12
 410:	01054c04 	tsteq	r5, r4, lsl #24
 414:	0505852f 	streq	r8, [r5, #-1327]	; 0xfffffad1
 418:	671005d7 			; <UNDEFINED> instruction: 0x671005d7
 41c:	004c0b05 	subeq	r0, ip, r5, lsl #22
 420:	06010402 	streq	r0, [r1], -r2, lsl #8
 424:	04020066 	streq	r0, [r2], #-102	; 0xffffff9a
 428:	09054a02 	stmdbeq	r5, {r1, r9, fp, lr}
 42c:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
 430:	13052e06 	movwne	r2, #24070	; 0x5e06
 434:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
 438:	000d054b 	andeq	r0, sp, fp, asr #10
 43c:	4a040402 	bmi	10144c <_bss_end+0xf7d30>
 440:	02000c05 	andeq	r0, r0, #1280	; 0x500
 444:	054c0404 	strbeq	r0, [ip, #-1028]	; 0xfffffbfc
 448:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 44c:	1005d705 	andne	sp, r5, r5, lsl #14
 450:	4c0b0567 	cfstr32mi	mvfx0, [fp], {103}	; 0x67
 454:	01040200 	mrseq	r0, R12_usr
 458:	02006606 	andeq	r6, r0, #6291456	; 0x600000
 45c:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 460:	04020009 	streq	r0, [r2], #-9
 464:	052e0604 	streq	r0, [lr, #-1540]!	; 0xfffff9fc
 468:	04020013 	streq	r0, [r2], #-19	; 0xffffffed
 46c:	0d054b04 	vstreq	d4, [r5, #-16]
 470:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
 474:	000c054a 	andeq	r0, ip, sl, asr #10
 478:	4c040402 	cfstrsmi	mvf0, [r4], {2}
 47c:	852f0105 	strhi	r0, [pc, #-261]!	; 37f <shift+0x37f>
 480:	05d81c05 	ldrbeq	r1, [r8, #3077]	; 0xc05
 484:	1305ba05 	movwne	fp, #23045	; 0x5a05
 488:	4a1c054d 	bmi	7019c4 <_bss_end+0x6f82a8>
 48c:	05823e05 	streq	r3, [r2, #3589]	; 0xe05
 490:	1e056621 	cfmadd32ne	mvax1, mvfx6, mvfx5, mvfx1
 494:	2e4b052e 	cdpcs	5, 4, cr0, cr11, cr14, {1}
 498:	052e6b05 	streq	r6, [lr, #-2821]!	; 0xfffff4fb
 49c:	0e054a05 	vmlaeq.f32	s8, s10, s10
 4a0:	6648054a 	strbvs	r0, [r8], -sl, asr #10
 4a4:	052e1005 	streq	r1, [lr, #-5]!
 4a8:	01054809 	tsteq	r5, r9, lsl #16
 4ac:	1c054d31 	stcne	13, cr4, [r5], {49}	; 0x31
 4b0:	ba0505a0 	blt	141b38 <_bss_end+0x13841c>
 4b4:	054b2005 	strbeq	r2, [fp, #-5]
 4b8:	32054c29 	andcc	r4, r5, #10496	; 0x2900
 4bc:	8234054a 	eorshi	r0, r4, #310378496	; 0x12800000
 4c0:	054a0c05 	strbeq	r0, [sl, #-3077]	; 0xfffff3fb
 4c4:	01052e3f 	tsteq	r5, pc, lsr lr
 4c8:	01040200 	mrseq	r0, R12_usr
 4cc:	0b05694b 	bleq	15aa00 <_bss_end+0x1512e4>
 4d0:	663505d8 			; <UNDEFINED> instruction: 0x663505d8
 4d4:	02002405 	andeq	r2, r0, #83886080	; 0x5000000
 4d8:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 4dc:	04020009 	streq	r0, [r2], #-9
 4e0:	3505f202 	strcc	pc, [r5, #-514]	; 0xfffffdfe
 4e4:	03040200 	movweq	r0, #16896	; 0x4200
 4e8:	0054054a 	subseq	r0, r4, sl, asr #10
 4ec:	66060402 	strvs	r0, [r6], -r2, lsl #8
 4f0:	02003805 	andeq	r3, r0, #327680	; 0x50000
 4f4:	05f20604 	ldrbeq	r0, [r2, #1540]!	; 0x604
 4f8:	04020035 	streq	r0, [r2], #-53	; 0xffffffcb
 4fc:	02004a07 	andeq	r4, r0, #28672	; 0x7000
 500:	4a060804 	bmi	182518 <_bss_end+0x178dfc>
 504:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
 508:	2e060a04 	vmlacs.f32	s0, s12, s8
 50c:	054d1505 	strbeq	r1, [sp, #-1285]	; 0xfffffafb
 510:	0e056605 	cfmadd32eq	mvax0, mvfx6, mvfx5, mvfx5
 514:	6615054a 	ldrvs	r0, [r5], -sl, asr #10
 518:	052e1005 	streq	r1, [lr, #-5]!
 51c:	01054809 	tsteq	r5, r9, lsl #16
 520:	009e4a31 	addseq	r4, lr, r1, lsr sl
 524:	06010402 	streq	r0, [r1], -r2, lsl #8
 528:	06230566 	strteq	r0, [r3], -r6, ror #10
 52c:	827f9e03 	rsbshi	r9, pc, #3, 28	; 0x30
 530:	e2030105 	and	r0, r3, #1073741825	; 0x40000001
 534:	4aba6600 	bmi	fee99d3c <_bss_end+0xfee90620>
 538:	01000a02 	tsteq	r0, r2, lsl #20
 53c:	0003df01 	andeq	sp, r3, r1, lsl #30
 540:	c5000300 	strgt	r0, [r0, #-768]	; 0xfffffd00
 544:	02000000 	andeq	r0, r0, #0
 548:	0d0efb01 	vstreq	d15, [lr, #-4]
 54c:	01010100 	mrseq	r0, (UNDEF: 17)
 550:	00000001 	andeq	r0, r0, r1
 554:	01000001 	tsteq	r0, r1
 558:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
 55c:	552f632f 	strpl	r6, [pc, #-815]!	; 235 <shift+0x235>
 560:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 564:	62754b2f 	rsbsvs	r4, r5, #48128	; 0xbc00
 568:	6f442f61 	svcvs	0x00442f61
 56c:	656d7563 	strbvs	r7, [sp, #-1379]!	; 0xfffffa9d
 570:	2f73746e 	svccs	0x0073746e
 574:	6f72655a 	svcvs	0x0072655a
 578:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
 57c:	6178652f 	cmnvs	r8, pc, lsr #10
 580:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
 584:	38312f73 	ldmdacc	r1!, {r0, r1, r4, r5, r6, r8, r9, sl, fp, sp}
 588:	5241552d 	subpl	r5, r1, #188743680	; 0xb400000
 58c:	656b2f54 	strbvs	r2, [fp, #-3924]!	; 0xfffff0ac
 590:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
 594:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
 598:	6972642f 	ldmdbvs	r2!, {r0, r1, r2, r3, r5, sl, sp, lr}^
 59c:	73726576 	cmnvc	r2, #494927872	; 0x1d800000
 5a0:	6e6d2f00 	cdpvs	15, 6, cr2, cr13, cr0, {0}
 5a4:	2f632f74 	svccs	0x00632f74
 5a8:	72657355 	rsbvc	r7, r5, #1409286145	; 0x54000001
 5ac:	754b2f73 	strbvc	r2, [fp, #-3955]	; 0xfffff08d
 5b0:	442f6162 	strtmi	r6, [pc], #-354	; 5b8 <shift+0x5b8>
 5b4:	6d75636f 	ldclvs	3, cr6, [r5, #-444]!	; 0xfffffe44
 5b8:	73746e65 	cmnvc	r4, #1616	; 0x650
 5bc:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
 5c0:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
 5c4:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 5c8:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
 5cc:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
 5d0:	41552d38 	cmpmi	r5, r8, lsr sp
 5d4:	6b2f5452 	blvs	bd5724 <_bss_end+0xbcc008>
 5d8:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 5dc:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
 5e0:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 5e4:	72642f65 	rsbvc	r2, r4, #404	; 0x194
 5e8:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
 5ec:	6d000073 	stcvs	0, cr0, [r0, #-460]	; 0xfffffe34
 5f0:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
 5f4:	632e726f 			; <UNDEFINED> instruction: 0x632e726f
 5f8:	01007070 	tsteq	r0, r0, ror r0
 5fc:	6f6d0000 	svcvs	0x006d0000
 600:	6f74696e 	svcvs	0x0074696e
 604:	00682e72 	rsbeq	r2, r8, r2, ror lr
 608:	00000002 	andeq	r0, r0, r2
 60c:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
 610:	0087b802 	addeq	fp, r7, r2, lsl #16
 614:	0e051600 	cfmadd32eq	mvax0, mvfx1, mvfx5, mvfx0
 618:	322605d7 	eorcc	r0, r6, #901775360	; 0x35c00000
 61c:	22020105 	andcs	r0, r2, #1073741825	; 0x40000001
 620:	9e090314 	mcrls	3, 0, r0, cr9, cr4, {0}
 624:	05831105 	streq	r1, [r3, #261]	; 0x105
 628:	22054c17 	andcs	r4, r5, #5888	; 0x1700
 62c:	01040200 	mrseq	r0, R12_usr
 630:	0020054a 	eoreq	r0, r0, sl, asr #10
 634:	4a010402 	bmi	41644 <_bss_end+0x37f28>
 638:	05681b05 	strbeq	r1, [r8, #-2821]!	; 0xfffff4fb
 63c:	04020026 	streq	r0, [r2], #-38	; 0xffffffda
 640:	24054a03 	strcs	r4, [r5], #-2563	; 0xfffff5fd
 644:	03040200 	movweq	r0, #16896	; 0x4200
 648:	000d054a 	andeq	r0, sp, sl, asr #10
 64c:	68020402 	stmdavs	r2, {r1, sl}
 650:	02001c05 	andeq	r1, r0, #1280	; 0x500
 654:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 658:	0402001a 	streq	r0, [r2], #-26	; 0xffffffe6
 65c:	25054a02 	strcs	r4, [r5, #-2562]	; 0xfffff5fe
 660:	02040200 	andeq	r0, r4, #0, 4
 664:	0028054a 	eoreq	r0, r8, sl, asr #10
 668:	4a020402 	bmi	81678 <_bss_end+0x77f5c>
 66c:	02002a05 	andeq	r2, r0, #20480	; 0x5000
 670:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
 674:	04020009 	streq	r0, [r2], #-9
 678:	05054802 	streq	r4, [r5, #-2050]	; 0xfffff7fe
 67c:	02040200 	andeq	r0, r4, #0, 4
 680:	89010580 	stmdbhi	r1, {r7, r8, sl}
 684:	05661203 	strbeq	r1, [r6, #-515]!	; 0xfffffdfd
 688:	22058317 	andcs	r8, r5, #1543503872	; 0x5c000000
 68c:	01040200 	mrseq	r0, R12_usr
 690:	0020054a 	eoreq	r0, r0, sl, asr #10
 694:	4a010402 	bmi	416a4 <_bss_end+0x37f88>
 698:	05681b05 	strbeq	r1, [r8, #-2821]!	; 0xfffff4fb
 69c:	04020026 	streq	r0, [r2], #-38	; 0xffffffda
 6a0:	24054a03 	strcs	r4, [r5], #-2563	; 0xfffff5fd
 6a4:	03040200 	movweq	r0, #16896	; 0x4200
 6a8:	0032054a 	eorseq	r0, r2, sl, asr #10
 6ac:	68020402 	stmdavs	r2, {r1, sl}
 6b0:	02004105 	andeq	r4, r0, #1073741825	; 0x40000001
 6b4:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 6b8:	0402003f 	streq	r0, [r2], #-63	; 0xffffffc1
 6bc:	4a054a02 	bmi	152ecc <_bss_end+0x1497b0>
 6c0:	02040200 	andeq	r0, r4, #0, 4
 6c4:	004d054a 	subeq	r0, sp, sl, asr #10
 6c8:	4a020402 	bmi	816d8 <_bss_end+0x77fbc>
 6cc:	02000d05 	andeq	r0, r0, #320	; 0x140
 6d0:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
 6d4:	0402001b 	streq	r0, [r2], #-27	; 0xffffffe5
 6d8:	22054a02 	andcs	r4, r5, #8192	; 0x2000
 6dc:	02040200 	andeq	r0, r4, #0, 4
 6e0:	0020054a 	eoreq	r0, r0, sl, asr #10
 6e4:	4a020402 	bmi	816f4 <_bss_end+0x77fd8>
 6e8:	02002b05 	andeq	r2, r0, #5120	; 0x1400
 6ec:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
 6f0:	0402002e 	streq	r0, [r2], #-46	; 0xffffffd2
 6f4:	4d054a02 	vstrmi	s8, [r5, #-8]
 6f8:	02040200 	andeq	r0, r4, #0, 4
 6fc:	0030052e 	eorseq	r0, r0, lr, lsr #10
 700:	4a020402 	bmi	81710 <_bss_end+0x77ff4>
 704:	02000905 	andeq	r0, r0, #81920	; 0x14000
 708:	052c0204 	streq	r0, [ip, #-516]!	; 0xfffffdfc
 70c:	04020005 	streq	r0, [r2], #-5
 710:	17058002 	strne	r8, [r5, -r2]
 714:	0022058a 	eoreq	r0, r2, sl, lsl #11
 718:	4a030402 	bmi	c1728 <_bss_end+0xb800c>
 71c:	02002005 	andeq	r2, r0, #5
 720:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
 724:	04020009 	streq	r0, [r2], #-9
 728:	15056802 	strne	r6, [r5, #-2050]	; 0xfffff7fe
 72c:	02040200 	andeq	r0, r4, #0, 4
 730:	001e054a 	andseq	r0, lr, sl, asr #10
 734:	4a020402 	bmi	81744 <_bss_end+0x78028>
 738:	02002505 	andeq	r2, r0, #20971520	; 0x1400000
 73c:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
 740:	04020023 	streq	r0, [r2], #-35	; 0xffffffdd
 744:	2e054a02 	vmlacs.f32	s8, s10, s4
 748:	02040200 	andeq	r0, r4, #0, 4
 74c:	0031052e 	eorseq	r0, r1, lr, lsr #10
 750:	4a020402 	bmi	81760 <_bss_end+0x78044>
 754:	02003305 	andeq	r3, r0, #335544320	; 0x14000000
 758:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
 75c:	04020005 	streq	r0, [r2], #-5
 760:	01054802 	tsteq	r5, r2, lsl #16
 764:	05058a86 	streq	r8, [r5, #-2694]	; 0xfffff57a
 768:	680905bb 	stmdavs	r9, {r0, r1, r3, r4, r5, r7, r8, sl}
 76c:	054a1d05 	strbeq	r1, [sl, #-3333]	; 0xfffff2fb
 770:	1f054a21 	svcne	0x00054a21
 774:	2e35054a 	cdpcs	5, 3, cr0, cr5, cr10, {2}
 778:	054a2a05 	strbeq	r2, [sl, #-2565]	; 0xfffff5fb
 77c:	38052e36 	stmdacc	r5, {r1, r2, r4, r5, r9, sl, fp, sp}
 780:	4b14052e 	blmi	501c40 <_bss_end+0x4f8524>
 784:	054a0905 	strbeq	r0, [sl, #-2309]	; 0xfffff6fb
 788:	05678614 	strbeq	r8, [r7, #-1556]!	; 0xfffff9ec
 78c:	12054a09 	andne	r4, r5, #36864	; 0x9000
 790:	4c0d0569 	cfstr32mi	mvfx0, [sp], {105}	; 0x69
 794:	692f0105 	stmdbvs	pc!, {r0, r2, r8}	; <UNPREDICTABLE>
 798:	059f1705 	ldreq	r1, [pc, #1797]	; ea5 <shift+0xea5>
 79c:	04020023 	streq	r0, [r2], #-35	; 0xffffffdd
 7a0:	25054a03 	strcs	r4, [r5, #-2563]	; 0xfffff5fd
 7a4:	03040200 	movweq	r0, #16896	; 0x4200
 7a8:	00170582 	andseq	r0, r7, r2, lsl #11
 7ac:	4c020402 	cfstrsmi	mvf0, [r2], {2}
 7b0:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
 7b4:	05d40204 	ldrbeq	r0, [r4, #516]	; 0x204
 7b8:	0d058716 	stceq	7, cr8, [r5, #-88]	; 0xffffffa8
 7bc:	2f01054c 	svccs	0x0001054c
 7c0:	9f130569 	svcls	0x00130569
 7c4:	05680d05 	strbeq	r0, [r8, #-3333]!	; 0xfffff2fb
 7c8:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 7cc:	0905a333 	stmdbeq	r5, {r0, r1, r4, r5, r8, r9, sp, pc}
 7d0:	830e054a 	movwhi	r0, #58698	; 0xe54a
 7d4:	05671605 	strbeq	r1, [r7, #-1541]!	; 0xfffff9fb
 7d8:	01054c0d 	tsteq	r5, sp, lsl #24
 7dc:	0505852f 	streq	r8, [r5, #-1327]	; 0xfffffad1
 7e0:	681205bb 	ldmdavs	r2, {r0, r1, r3, r4, r5, r7, r8, sl}
 7e4:	69160586 	ldmdbvs	r6, {r1, r2, r7, r8, sl}
 7e8:	054c0d05 	strbeq	r0, [ip, #-3333]	; 0xfffff2fb
 7ec:	05a12f01 	streq	r2, [r1, #3841]!	; 0xf01
 7f0:	1205d709 	andne	sp, r5, #2359296	; 0x240000
 7f4:	6827054c 	stmdavs	r7!, {r2, r3, r6, r8, sl}
 7f8:	05ba2d05 	ldreq	r2, [sl, #3333]!	; 0xd05
 7fc:	11054a10 	tstne	r5, r0, lsl sl
 800:	4a2d052e 	bmi	b41cc0 <_bss_end+0xb385a4>
 804:	052e1305 	streq	r1, [lr, #-773]!	; 0xfffffcfb
 808:	0a052f0f 	beq	14c44c <_bss_end+0x142d30>
 80c:	610505a0 	smlatbvs	r5, r0, r5, r0
 810:	68100536 	ldmdavs	r0, {r1, r2, r4, r5, r8, sl}
 814:	052e1105 	streq	r1, [lr, #-261]!	; 0xfffffefb
 818:	13054a22 	movwne	r4, #23074	; 0x5a22
 81c:	2f0a052e 	svccs	0x000a052e
 820:	05690c05 	strbeq	r0, [r9, #-3077]!	; 0xfffff3fb
 824:	0f052e0d 	svceq	0x00052e0d
 828:	4b06054a 	blmi	181d58 <_bss_end+0x17863c>
 82c:	05680e05 	strbeq	r0, [r8, #-3589]!	; 0xfffff1fb
 830:	0402001d 	streq	r0, [r2], #-29	; 0xffffffe3
 834:	17054a03 	strne	r4, [r5, -r3, lsl #20]
 838:	03040200 	movweq	r0, #16896	; 0x4200
 83c:	001b059e 	mulseq	fp, lr, r5
 840:	68020402 	stmdavs	r2, {r1, sl}
 844:	02001e05 	andeq	r1, r0, #5, 28	; 0x50
 848:	05820204 	streq	r0, [r2, #516]	; 0x204
 84c:	0402000e 	streq	r0, [r2], #-14
 850:	20054a02 	andcs	r4, r5, r2, lsl #20
 854:	02040200 	andeq	r0, r4, #0, 4
 858:	0021054b 	eoreq	r0, r1, fp, asr #10
 85c:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
 860:	02001205 	andeq	r1, r0, #1342177280	; 0x50000000
 864:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 868:	04020015 	streq	r0, [r2], #-21	; 0xffffffeb
 86c:	21058202 	tstcs	r5, r2, lsl #4
 870:	02040200 	andeq	r0, r4, #0, 4
 874:	0017054a 	andseq	r0, r7, sl, asr #10
 878:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
 87c:	02001005 	andeq	r1, r0, #5
 880:	052f0204 	streq	r0, [pc, #-516]!	; 684 <shift+0x684>
 884:	04020011 	streq	r0, [r2], #-17	; 0xffffffef
 888:	13052e02 	movwne	r2, #24066	; 0x5e02
 88c:	02040200 	andeq	r0, r4, #0, 4
 890:	0005054a 	andeq	r0, r5, sl, asr #10
 894:	46020402 	strmi	r0, [r2], -r2, lsl #8
 898:	82880105 	addhi	r0, r8, #1073741825	; 0x40000001
 89c:	0402009e 	streq	r0, [r2], #-158	; 0xffffff62
 8a0:	05660601 	strbeq	r0, [r6, #-1537]!	; 0xfffff9ff
 8a4:	e1030627 	tst	r3, r7, lsr #12
 8a8:	0105827e 	tsteq	r5, lr, ror r2
 8ac:	9e019f03 	cdpls	15, 0, cr9, cr1, cr3, {0}
 8b0:	0a024a9e 	beq	93330 <_bss_end+0x89c14>
 8b4:	05010100 	streq	r0, [r1, #-256]	; 0xffffff00
 8b8:	02050001 	andeq	r0, r5, #1
 8bc:	00008e00 	andeq	r8, r0, r0, lsl #28
 8c0:	05010e03 	streq	r0, [r1, #-3587]	; 0xfffff1fd
 8c4:	05678310 	strbeq	r8, [r7, #-784]!	; 0xfffffcf0
 8c8:	08026701 	stmdaeq	r2, {r0, r8, r9, sl, sp, lr}
 8cc:	05010100 	streq	r0, [r1, #-256]	; 0xffffff00
 8d0:	02050001 	andeq	r0, r5, #1
 8d4:	00008e38 	andeq	r8, r0, r8, lsr lr
 8d8:	05012103 	streq	r2, [r1, #-259]	; 0xfffffefd
 8dc:	17058312 	smladne	r5, r2, r3, r8
 8e0:	4a05054a 	bmi	141e10 <_bss_end+0x1386f4>
 8e4:	674c1405 	strbvs	r1, [ip, -r5, lsl #8]
 8e8:	054a0905 	strbeq	r0, [sl, #-2309]	; 0xfffff6fb
 8ec:	17056912 	smladne	r5, r2, r9, r6
 8f0:	4a05054a 	bmi	141e20 <_bss_end+0x138704>
 8f4:	054c0f05 	strbeq	r0, [ip, #-3845]	; 0xfffff0fb
 8f8:	1f054b16 	svcne	0x00054b16
 8fc:	2e14054a 	cfmac32cs	mvfx0, mvfx4, mvfx10
 900:	024c0105 	subeq	r0, ip, #1073741825	; 0x40000001
 904:	01010006 	tsteq	r1, r6
 908:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
 90c:	008ec002 	addeq	ip, lr, r2
 910:	00c00300 	sbceq	r0, r0, r0, lsl #6
 914:	83130501 	tsthi	r3, #4194304	; 0x400000
 918:	02670105 	rsbeq	r0, r7, #1073741825	; 0x40000001
 91c:	01010008 	tsteq	r1, r8
 920:	0000021b 	andeq	r0, r0, fp, lsl r2
 924:	013d0003 	teqeq	sp, r3
 928:	01020000 	mrseq	r0, (UNDEF: 2)
 92c:	000d0efb 	strdeq	r0, [sp], -fp
 930:	01010101 	tsteq	r1, r1, lsl #2
 934:	01000000 	mrseq	r0, (UNDEF: 0)
 938:	2f010000 	svccs	0x00010000
 93c:	2f746e6d 	svccs	0x00746e6d
 940:	73552f63 	cmpvc	r5, #396	; 0x18c
 944:	2f737265 	svccs	0x00737265
 948:	6162754b 	cmnvs	r2, fp, asr #10
 94c:	636f442f 	cmnvs	pc, #788529152	; 0x2f000000
 950:	6e656d75 	mcrvs	13, 3, r6, cr5, cr5, {3}
 954:	5a2f7374 	bpl	bdd72c <_bss_end+0xbd4010>
 958:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 7cc <shift+0x7cc>
 95c:	2f657461 	svccs	0x00657461
 960:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
 964:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
 968:	2d38312f 	ldfcss	f3, [r8, #-188]!	; 0xffffff44
 96c:	54524155 	ldrbpl	r4, [r2], #-341	; 0xfffffeab
 970:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 974:	2f6c656e 	svccs	0x006c656e
 978:	2f637273 	svccs	0x00637273
 97c:	76697264 	strbtvc	r7, [r9], -r4, ror #4
 980:	00737265 	rsbseq	r7, r3, r5, ror #4
 984:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
 988:	552f632f 	strpl	r6, [pc, #-815]!	; 661 <shift+0x661>
 98c:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 990:	62754b2f 	rsbsvs	r4, r5, #48128	; 0xbc00
 994:	6f442f61 	svcvs	0x00442f61
 998:	656d7563 	strbvs	r7, [sp, #-1379]!	; 0xfffffa9d
 99c:	2f73746e 	svccs	0x0073746e
 9a0:	6f72655a 	svcvs	0x0072655a
 9a4:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
 9a8:	6178652f 	cmnvs	r8, pc, lsr #10
 9ac:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
 9b0:	38312f73 	ldmdacc	r1!, {r0, r1, r4, r5, r6, r8, r9, sl, fp, sp}
 9b4:	5241552d 	subpl	r5, r1, #188743680	; 0xb400000
 9b8:	656b2f54 	strbvs	r2, [fp, #-3924]!	; 0xfffff0ac
 9bc:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
 9c0:	636e692f 	cmnvs	lr, #770048	; 0xbc000
 9c4:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
 9c8:	616f622f 	cmnvs	pc, pc, lsr #4
 9cc:	722f6472 	eorvc	r6, pc, #1912602624	; 0x72000000
 9d0:	2f306970 	svccs	0x00306970
 9d4:	006c6168 	rsbeq	r6, ip, r8, ror #2
 9d8:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
 9dc:	552f632f 	strpl	r6, [pc, #-815]!	; 6b5 <shift+0x6b5>
 9e0:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 9e4:	62754b2f 	rsbsvs	r4, r5, #48128	; 0xbc00
 9e8:	6f442f61 	svcvs	0x00442f61
 9ec:	656d7563 	strbvs	r7, [sp, #-1379]!	; 0xfffffa9d
 9f0:	2f73746e 	svccs	0x0073746e
 9f4:	6f72655a 	svcvs	0x0072655a
 9f8:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
 9fc:	6178652f 	cmnvs	r8, pc, lsr #10
 a00:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
 a04:	38312f73 	ldmdacc	r1!, {r0, r1, r4, r5, r6, r8, r9, sl, fp, sp}
 a08:	5241552d 	subpl	r5, r1, #188743680	; 0xb400000
 a0c:	656b2f54 	strbvs	r2, [fp, #-3924]!	; 0xfffff0ac
 a10:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
 a14:	636e692f 	cmnvs	lr, #770048	; 0xbc000
 a18:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
 a1c:	6972642f 	ldmdbvs	r2!, {r0, r1, r2, r3, r5, sl, sp, lr}^
 a20:	73726576 	cmnvc	r2, #494927872	; 0x1d800000
 a24:	61750000 	cmnvs	r5, r0
 a28:	632e7472 			; <UNDEFINED> instruction: 0x632e7472
 a2c:	01007070 	tsteq	r0, r0, ror r0
 a30:	65700000 	ldrbvs	r0, [r0, #-0]!
 a34:	68706972 	ldmdavs	r0!, {r1, r4, r5, r6, r8, fp, sp, lr}^
 a38:	6c617265 	sfmvs	f7, 2, [r1], #-404	; 0xfffffe6c
 a3c:	00682e73 	rsbeq	r2, r8, r3, ror lr
 a40:	62000002 	andvs	r0, r0, #2
 a44:	615f6d63 	cmpvs	pc, r3, ror #26
 a48:	682e7875 	stmdavs	lr!, {r0, r2, r4, r5, r6, fp, ip, sp, lr}
 a4c:	00000300 	andeq	r0, r0, r0, lsl #6
 a50:	74726175 	ldrbtvc	r6, [r2], #-373	; 0xfffffe8b
 a54:	0300682e 	movweq	r6, #2094	; 0x82e
 a58:	6e690000 	cdpvs	0, 6, cr0, cr9, cr0, {0}
 a5c:	66656474 			; <UNDEFINED> instruction: 0x66656474
 a60:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 a64:	05000000 	streq	r0, [r0, #-0]
 a68:	02050001 	andeq	r0, r5, #1
 a6c:	00008eec 	andeq	r8, r0, ip, ror #29
 a70:	9f0b0518 	svcls	0x000b0518
 a74:	05680505 	strbeq	r0, [r8, #-1285]!	; 0xfffffafb
 a78:	05054a10 	streq	r4, [r5, #-2576]	; 0xfffff5f0
 a7c:	4a160568 	bmi	582024 <_bss_end+0x578908>
 a80:	05830505 	streq	r0, [r3, #1285]	; 0x505
 a84:	05054a16 	streq	r4, [r5, #-2582]	; 0xfffff5ea
 a88:	4a160583 	bmi	58209c <_bss_end+0x578980>
 a8c:	05830505 	streq	r0, [r3, #1285]	; 0x505
 a90:	01054a16 	tsteq	r5, r6, lsl sl
 a94:	05058583 	streq	r8, [r5, #-1411]	; 0xfffffa7d
 a98:	4b18059f 	blmi	60211c <_bss_end+0x5f8a00>
 a9c:	054a2905 	strbeq	r2, [sl, #-2309]	; 0xfffff6fb
 aa0:	50058240 	andpl	r8, r5, r0, asr #4
 aa4:	2d16052e 	cfldr32cs	mvfx0, [r6, #-184]	; 0xffffff48
 aa8:	69a00105 	stmibvs	r0!, {r0, r2, r8}
 aac:	059f1c05 	ldreq	r1, [pc, #3077]	; 16b9 <shift+0x16b9>
 ab0:	53054b2d 	movwpl	r4, #23341	; 0x5b2d
 ab4:	8218052e 	andshi	r0, r8, #192937984	; 0xb800000
 ab8:	054c0505 	strbeq	r0, [ip, #-1285]	; 0xfffffafb
 abc:	05054a16 	streq	r4, [r5, #-2582]	; 0xfffff5ea
 ac0:	4a160584 	bmi	5820d8 <_bss_end+0x5789bc>
 ac4:	05840505 	streq	r0, [r4, #1285]	; 0x505
 ac8:	01054a16 	tsteq	r5, r6, lsl sl
 acc:	1b05a183 	blne	1690e0 <_bss_end+0x15f9c4>
 ad0:	4a2c05bb 	bmi	b021c4 <_bss_end+0xaf8aa8>
 ad4:	05824d05 	streq	r4, [r2, #3333]	; 0xd05
 ad8:	12054d0c 	andne	r4, r5, #12, 26	; 0x300
 adc:	4a230568 	bmi	8c2084 <_bss_end+0x8b8968>
 ae0:	05820f05 	streq	r0, [r2, #3845]	; 0xf05
 ae4:	05344805 	ldreq	r4, [r4, #-2053]!	; 0xfffff7fb
 ae8:	01054a16 	tsteq	r5, r6, lsl sl
 aec:	0c056983 			; <UNDEFINED> instruction: 0x0c056983
 af0:	001505a1 	andseq	r0, r5, r1, lsr #11
 af4:	4a030402 	bmi	c1b04 <_bss_end+0xb83e8>
 af8:	02001605 	andeq	r1, r0, #5242880	; 0x500000
 afc:	052e0304 	streq	r0, [lr, #-772]!	; 0xfffffcfc
 b00:	04020018 	streq	r0, [r2], #-24	; 0xffffffe8
 b04:	13056603 	movwne	r6, #22019	; 0x5603
 b08:	02040200 	andeq	r0, r4, #0, 4
 b0c:	0014054b 	andseq	r0, r4, fp, asr #10
 b10:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
 b14:	02000e05 	andeq	r0, r0, #5, 28	; 0x50
 b18:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 b1c:	04020005 	streq	r0, [r2], #-5
 b20:	01058102 	tsteq	r5, r2, lsl #2
 b24:	009e6684 	addseq	r6, lr, r4, lsl #13
 b28:	06010402 	streq	r0, [r1], -r2, lsl #8
 b2c:	06120566 	ldreq	r0, [r2], -r6, ror #10
 b30:	05824d03 	streq	r4, [r2, #3331]	; 0xd03
 b34:	66330301 	ldrtvs	r0, [r3], -r1, lsl #6
 b38:	0a024aba 	beq	93628 <_bss_end+0x89f0c>
 b3c:	64010100 	strvs	r0, [r1], #-256	; 0xffffff00
 b40:	03000001 	movweq	r0, #1
 b44:	00013500 	andeq	r3, r1, r0, lsl #10
 b48:	fb010200 	blx	41352 <_bss_end+0x37c36>
 b4c:	01000d0e 	tsteq	r0, lr, lsl #26
 b50:	00010101 	andeq	r0, r1, r1, lsl #2
 b54:	00010000 	andeq	r0, r1, r0
 b58:	6d2f0100 	stfvss	f0, [pc, #-0]	; b60 <shift+0xb60>
 b5c:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
 b60:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
 b64:	4b2f7372 	blmi	bdd934 <_bss_end+0xbd4218>
 b68:	2f616275 	svccs	0x00616275
 b6c:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
 b70:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
 b74:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
 b78:	614d6f72 	hvcvs	55026	; 0xd6f2
 b7c:	652f6574 	strvs	r6, [pc, #-1396]!	; 610 <shift+0x610>
 b80:	706d6178 	rsbvc	r6, sp, r8, ror r1
 b84:	2f73656c 	svccs	0x0073656c
 b88:	552d3831 	strpl	r3, [sp, #-2097]!	; 0xfffff7cf
 b8c:	2f545241 	svccs	0x00545241
 b90:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 b94:	732f6c65 			; <UNDEFINED> instruction: 0x732f6c65
 b98:	2f006372 	svccs	0x00006372
 b9c:	2f746e6d 	svccs	0x00746e6d
 ba0:	73552f63 	cmpvc	r5, #396	; 0x18c
 ba4:	2f737265 	svccs	0x00737265
 ba8:	6162754b 	cmnvs	r2, fp, asr #10
 bac:	636f442f 	cmnvs	pc, #788529152	; 0x2f000000
 bb0:	6e656d75 	mcrvs	13, 3, r6, cr5, cr5, {3}
 bb4:	5a2f7374 	bpl	bdd98c <_bss_end+0xbd4270>
 bb8:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; a2c <shift+0xa2c>
 bbc:	2f657461 	svccs	0x00657461
 bc0:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
 bc4:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
 bc8:	2d38312f 	ldfcss	f3, [r8, #-188]!	; 0xffffff44
 bcc:	54524155 	ldrbpl	r4, [r2], #-341	; 0xfffffeab
 bd0:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 bd4:	2f6c656e 	svccs	0x006c656e
 bd8:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 bdc:	2f656475 	svccs	0x00656475
 be0:	72616f62 	rsbvc	r6, r1, #392	; 0x188
 be4:	70722f64 	rsbsvc	r2, r2, r4, ror #30
 be8:	682f3069 	stmdavs	pc!, {r0, r3, r5, r6, ip, sp}	; <UNPREDICTABLE>
 bec:	2f006c61 	svccs	0x00006c61
 bf0:	2f746e6d 	svccs	0x00746e6d
 bf4:	73552f63 	cmpvc	r5, #396	; 0x18c
 bf8:	2f737265 	svccs	0x00737265
 bfc:	6162754b 	cmnvs	r2, fp, asr #10
 c00:	636f442f 	cmnvs	pc, #788529152	; 0x2f000000
 c04:	6e656d75 	mcrvs	13, 3, r6, cr5, cr5, {3}
 c08:	5a2f7374 	bpl	bdd9e0 <_bss_end+0xbd42c4>
 c0c:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; a80 <shift+0xa80>
 c10:	2f657461 	svccs	0x00657461
 c14:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
 c18:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
 c1c:	2d38312f 	ldfcss	f3, [r8, #-188]!	; 0xffffff44
 c20:	54524155 	ldrbpl	r4, [r2], #-341	; 0xfffffeab
 c24:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 c28:	2f6c656e 	svccs	0x006c656e
 c2c:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 c30:	2f656475 	svccs	0x00656475
 c34:	76697264 	strbtvc	r7, [r9], -r4, ror #4
 c38:	00737265 	rsbseq	r7, r3, r5, ror #4
 c3c:	69616d00 	stmdbvs	r1!, {r8, sl, fp, sp, lr}^
 c40:	70632e6e 	rsbvc	r2, r3, lr, ror #28
 c44:	00010070 	andeq	r0, r1, r0, ror r0
 c48:	72657000 	rsbvc	r7, r5, #0
 c4c:	65687069 	strbvs	r7, [r8, #-105]!	; 0xffffff97
 c50:	736c6172 	cmnvc	ip, #-2147483620	; 0x8000001c
 c54:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 c58:	63620000 	cmnvs	r2, #0
 c5c:	75615f6d 	strbvc	r5, [r1, #-3949]!	; 0xfffff093
 c60:	00682e78 	rsbeq	r2, r8, r8, ror lr
 c64:	75000003 	strvc	r0, [r0, #-3]
 c68:	2e747261 	cdpcs	2, 7, cr7, cr4, cr1, {3}
 c6c:	00030068 	andeq	r0, r3, r8, rrx
 c70:	746e6900 	strbtvc	r6, [lr], #-2304	; 0xfffff700
 c74:	2e666564 	cdpcs	5, 6, cr6, cr6, cr4, {3}
 c78:	00020068 	andeq	r0, r2, r8, rrx
 c7c:	01050000 	mrseq	r0, (UNDEF: 5)
 c80:	e8020500 	stmda	r2, {r8, sl}
 c84:	17000091 			; <UNDEFINED> instruction: 0x17000091
 c88:	05681905 	strbeq	r1, [r8, #-2309]!	; 0xfffff6fb
 c8c:	1505671b 	strne	r6, [r5, #-1819]	; 0xfffff8e5
 c90:	6812056c 	ldmdavs	r2, {r2, r3, r5, r6, r8, sl}
 c94:	02001b05 	andeq	r1, r0, #5120	; 0x1400
 c98:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
 c9c:	04020009 	streq	r0, [r2], #-9
 ca0:	0c02d602 	stceq	6, cr13, [r2], {2}
 ca4:	77010100 	strvc	r0, [r1, -r0, lsl #2]
 ca8:	03000000 	movweq	r0, #0
 cac:	00005f00 	andeq	r5, r0, r0, lsl #30
 cb0:	fb010200 	blx	414ba <_bss_end+0x37d9e>
 cb4:	01000d0e 	tsteq	r0, lr, lsl #26
 cb8:	00010101 	andeq	r0, r1, r1, lsl #2
 cbc:	00010000 	andeq	r0, r1, r0
 cc0:	6d2f0100 	stfvss	f0, [pc, #-0]	; cc8 <shift+0xcc8>
 cc4:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
 cc8:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
 ccc:	4b2f7372 	blmi	bdda9c <_bss_end+0xbd4380>
 cd0:	2f616275 	svccs	0x00616275
 cd4:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
 cd8:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
 cdc:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
 ce0:	614d6f72 	hvcvs	55026	; 0xd6f2
 ce4:	652f6574 	strvs	r6, [pc, #-1396]!	; 778 <shift+0x778>
 ce8:	706d6178 	rsbvc	r6, sp, r8, ror r1
 cec:	2f73656c 	svccs	0x0073656c
 cf0:	552d3831 	strpl	r3, [sp, #-2097]!	; 0xfffff7cf
 cf4:	2f545241 	svccs	0x00545241
 cf8:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 cfc:	732f6c65 			; <UNDEFINED> instruction: 0x732f6c65
 d00:	00006372 	andeq	r6, r0, r2, ror r3
 d04:	72617473 	rsbvc	r7, r1, #1929379840	; 0x73000000
 d08:	00732e74 	rsbseq	r2, r3, r4, ror lr
 d0c:	00000001 	andeq	r0, r0, r1
 d10:	00020500 	andeq	r0, r2, r0, lsl #10
 d14:	19000080 	stmdbne	r0, {r7}
 d18:	2f2f2f2f 	svccs	0x002f2f2f
 d1c:	00020230 	andeq	r0, r2, r0, lsr r2
 d20:	00e40101 	rsceq	r0, r4, r1, lsl #2
 d24:	00030000 	andeq	r0, r3, r0
 d28:	00000063 	andeq	r0, r0, r3, rrx
 d2c:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
 d30:	0101000d 	tsteq	r1, sp
 d34:	00000101 	andeq	r0, r0, r1, lsl #2
 d38:	00000100 	andeq	r0, r0, r0, lsl #2
 d3c:	6e6d2f01 	cdpvs	15, 6, cr2, cr13, cr1, {0}
 d40:	2f632f74 	svccs	0x00632f74
 d44:	72657355 	rsbvc	r7, r5, #1409286145	; 0x54000001
 d48:	754b2f73 	strbvc	r2, [fp, #-3955]	; 0xfffff08d
 d4c:	442f6162 	strtmi	r6, [pc], #-354	; d54 <shift+0xd54>
 d50:	6d75636f 	ldclvs	3, cr6, [r5, #-444]!	; 0xfffffe44
 d54:	73746e65 	cmnvc	r4, #1616	; 0x650
 d58:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
 d5c:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
 d60:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 d64:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
 d68:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
 d6c:	41552d38 	cmpmi	r5, r8, lsr sp
 d70:	6b2f5452 	blvs	bd5ec0 <_bss_end+0xbcc7a4>
 d74:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 d78:	72732f6c 	rsbsvc	r2, r3, #108, 30	; 0x1b0
 d7c:	73000063 	movwvc	r0, #99	; 0x63
 d80:	74726174 	ldrbtvc	r6, [r2], #-372	; 0xfffffe8c
 d84:	632e7075 			; <UNDEFINED> instruction: 0x632e7075
 d88:	01007070 	tsteq	r0, r0, ror r0
 d8c:	05000000 	streq	r0, [r0, #-0]
 d90:	02050001 	andeq	r0, r5, #1
 d94:	00009254 	andeq	r9, r0, r4, asr r2
 d98:	05011403 	streq	r1, [r1, #-1027]	; 0xfffffbfd
 d9c:	22056a0c 	andcs	r6, r5, #12, 20	; 0xc000
 da0:	03040200 	movweq	r0, #16896	; 0x4200
 da4:	000c0566 	andeq	r0, ip, r6, ror #10
 da8:	bb020402 	bllt	81db8 <_bss_end+0x7869c>
 dac:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
 db0:	05650204 	strbeq	r0, [r5, #-516]!	; 0xfffffdfc
 db4:	0105850c 	tsteq	r5, ip, lsl #10
 db8:	1005bd2f 	andne	fp, r5, pc, lsr #26
 dbc:	0027056b 	eoreq	r0, r7, fp, ror #10
 dc0:	4a030402 	bmi	c1dd0 <_bss_end+0xb86b4>
 dc4:	02000a05 	andeq	r0, r0, #20480	; 0x5000
 dc8:	05830204 	streq	r0, [r3, #516]	; 0x204
 dcc:	04020011 	streq	r0, [r2], #-17	; 0xffffffef
 dd0:	05054a02 	streq	r4, [r5, #-2562]	; 0xfffff5fe
 dd4:	02040200 	andeq	r0, r4, #0, 4
 dd8:	850c052d 	strhi	r0, [ip, #-1325]	; 0xfffffad3
 ddc:	a12f0105 			; <UNDEFINED> instruction: 0xa12f0105
 de0:	056a1005 	strbeq	r1, [sl, #-5]!
 de4:	04020027 	streq	r0, [r2], #-39	; 0xffffffd9
 de8:	0a054a03 	beq	1535fc <_bss_end+0x149ee0>
 dec:	02040200 	andeq	r0, r4, #0, 4
 df0:	00110583 	andseq	r0, r1, r3, lsl #11
 df4:	4a020402 	bmi	81e04 <_bss_end+0x786e8>
 df8:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
 dfc:	052d0204 	streq	r0, [sp, #-516]!	; 0xfffffdfc
 e00:	0105850c 	tsteq	r5, ip, lsl #10
 e04:	000a022f 	andeq	r0, sl, pc, lsr #4
 e08:	00790101 	rsbseq	r0, r9, r1, lsl #2
 e0c:	00030000 	andeq	r0, r3, r0
 e10:	00000046 	andeq	r0, r0, r6, asr #32
 e14:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
 e18:	0101000d 	tsteq	r1, sp
 e1c:	00000101 	andeq	r0, r0, r1, lsl #2
 e20:	00000100 	andeq	r0, r0, r0, lsl #2
 e24:	2f2e2e01 	svccs	0x002e2e01
 e28:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 e2c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 e30:	2f2e2e2f 	svccs	0x002e2e2f
 e34:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; d84 <shift+0xd84>
 e38:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
 e3c:	6f632f63 	svcvs	0x00632f63
 e40:	6769666e 	strbvs	r6, [r9, -lr, ror #12]!
 e44:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
 e48:	696c0000 	stmdbvs	ip!, {}^	; <UNPREDICTABLE>
 e4c:	75663162 	strbvc	r3, [r6, #-354]!	; 0xfffffe9e
 e50:	2e73636e 	cdpcs	3, 7, cr6, cr3, cr14, {3}
 e54:	00010053 	andeq	r0, r1, r3, asr r0
 e58:	05000000 	streq	r0, [r0, #-0]
 e5c:	00936c02 	addseq	r6, r3, r2, lsl #24
 e60:	08cf0300 	stmiaeq	pc, {r8, r9}^	; <UNPREDICTABLE>
 e64:	2f2f3001 	svccs	0x002f3001
 e68:	302f2f2f 	eorcc	r2, pc, pc, lsr #30
 e6c:	1401d002 	strne	sp, [r1], #-2
 e70:	2f2f312f 	svccs	0x002f312f
 e74:	322f4c30 	eorcc	r4, pc, #48, 24	; 0x3000
 e78:	2f661f03 	svccs	0x00661f03
 e7c:	2f2f2f2f 	svccs	0x002f2f2f
 e80:	02022f2f 	andeq	r2, r2, #47, 30	; 0xbc
 e84:	5c010100 	stfpls	f0, [r1], {-0}
 e88:	03000000 	movweq	r0, #0
 e8c:	00004600 	andeq	r4, r0, r0, lsl #12
 e90:	fb010200 	blx	4169a <_bss_end+0x37f7e>
 e94:	01000d0e 	tsteq	r0, lr, lsl #26
 e98:	00010101 	andeq	r0, r1, r1, lsl #2
 e9c:	00010000 	andeq	r0, r1, r0
 ea0:	2e2e0100 	sufcse	f0, f6, f0
 ea4:	2f2e2e2f 	svccs	0x002e2e2f
 ea8:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 eac:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 eb0:	2f2e2e2f 	svccs	0x002e2e2f
 eb4:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
 eb8:	632f6363 			; <UNDEFINED> instruction: 0x632f6363
 ebc:	69666e6f 	stmdbvs	r6!, {r0, r1, r2, r3, r5, r6, r9, sl, fp, sp, lr}^
 ec0:	72612f67 	rsbvc	r2, r1, #412	; 0x19c
 ec4:	6c00006d 	stcvs	0, cr0, [r0], {109}	; 0x6d
 ec8:	66316269 	ldrtvs	r6, [r1], -r9, ror #4
 ecc:	73636e75 	cmnvc	r3, #1872	; 0x750
 ed0:	0100532e 	tsteq	r0, lr, lsr #6
 ed4:	00000000 	andeq	r0, r0, r0
 ed8:	95780205 	ldrbls	r0, [r8, #-517]!	; 0xfffffdfb
 edc:	b9030000 	stmdblt	r3, {}	; <UNPREDICTABLE>
 ee0:	0202010b 	andeq	r0, r2, #-1073741822	; 0xc0000002
 ee4:	a4010100 	strge	r0, [r1], #-256	; 0xffffff00
 ee8:	03000000 	movweq	r0, #0
 eec:	00009e00 	andeq	r9, r0, r0, lsl #28
 ef0:	fb010200 	blx	416fa <_bss_end+0x37fde>
 ef4:	01000d0e 	tsteq	r0, lr, lsl #26
 ef8:	00010101 	andeq	r0, r1, r1, lsl #2
 efc:	00010000 	andeq	r0, r1, r0
 f00:	2e2e0100 	sufcse	f0, f6, f0
 f04:	2f2e2e2f 	svccs	0x002e2e2f
 f08:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 f0c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 f10:	672f2e2f 	strvs	r2, [pc, -pc, lsr #28]!
 f14:	2e006363 	cdpcs	3, 0, cr6, cr0, cr3, {3}
 f18:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 f1c:	2f2e2e2f 	svccs	0x002e2e2f
 f20:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 f24:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 f28:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
 f2c:	2f636367 	svccs	0x00636367
 f30:	672f2e2e 	strvs	r2, [pc, -lr, lsr #28]!
 f34:	632f6363 			; <UNDEFINED> instruction: 0x632f6363
 f38:	69666e6f 	stmdbvs	r6!, {r0, r1, r2, r3, r5, r6, r9, sl, fp, sp, lr}^
 f3c:	72612f67 	rsbvc	r2, r1, #412	; 0x19c
 f40:	2e2e006d 	cdpcs	0, 2, cr0, cr14, cr13, {3}
 f44:	2f2e2e2f 	svccs	0x002e2e2f
 f48:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 f4c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 f50:	2f2e2e2f 	svccs	0x002e2e2f
 f54:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
 f58:	00006363 	andeq	r6, r0, r3, ror #6
 f5c:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
 f60:	2e617369 	cdpcs	3, 6, cr7, cr1, cr9, {3}
 f64:	00010068 	andeq	r0, r1, r8, rrx
 f68:	6d726100 	ldfvse	f6, [r2, #-0]
 f6c:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 f70:	62670000 	rsbvs	r0, r7, #0
 f74:	74632d6c 	strbtvc	r2, [r3], #-3436	; 0xfffff294
 f78:	2e73726f 	cdpcs	2, 7, cr7, cr3, cr15, {3}
 f7c:	00030068 	andeq	r0, r3, r8, rrx
 f80:	62696c00 	rsbvs	r6, r9, #0, 24
 f84:	32636367 	rsbcc	r6, r3, #-1677721599	; 0x9c000001
 f88:	0300632e 	movweq	r6, #814	; 0x32e
 f8c:	Address 0x0000000000000f8c is out of bounds.


Disassembly of section .debug_str:

00000000 <.debug_str>:
       0:	78635f5f 	stmdavc	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, sl, fp, ip, lr}^
       4:	75675f61 	strbvc	r5, [r7, #-3937]!	; 0xfffff09f
       8:	5f647261 	svcpl	0x00647261
       c:	656c6572 	strbvs	r6, [ip, #-1394]!	; 0xfffffa8e
      10:	00657361 	rsbeq	r7, r5, r1, ror #6
      14:	65615f5f 	strbvs	r5, [r1, #-3935]!	; 0xfffff0a1
      18:	5f696261 	svcpl	0x00696261
      1c:	69776e75 	ldmdbvs	r7!, {r0, r2, r4, r5, r6, r9, sl, fp, sp, lr}^
      20:	635f646e 	cmpvs	pc, #1845493760	; 0x6e000000
      24:	705f7070 	subsvc	r7, pc, r0, ror r0	; <UNPREDICTABLE>
      28:	2f003172 	svccs	0x00003172
      2c:	2f746e6d 	svccs	0x00746e6d
      30:	73552f63 	cmpvc	r5, #396	; 0x18c
      34:	2f737265 	svccs	0x00737265
      38:	6162754b 	cmnvs	r2, fp, asr #10
      3c:	636f442f 	cmnvs	pc, #788529152	; 0x2f000000
      40:	6e656d75 	mcrvs	13, 3, r6, cr5, cr5, {3}
      44:	5a2f7374 	bpl	bdce1c <_bss_end+0xbd3700>
      48:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; fffffebc <_bss_end+0xffff67a0>
      4c:	2f657461 	svccs	0x00657461
      50:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
      54:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
      58:	2d38312f 	ldfcss	f3, [r8, #-188]!	; 0xffffff44
      5c:	54524155 	ldrbpl	r4, [r2], #-341	; 0xfffffeab
      60:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
      64:	2f6c656e 	svccs	0x006c656e
      68:	2f637273 	svccs	0x00637273
      6c:	2e787863 	cdpcs	8, 7, cr7, cr8, cr3, {3}
      70:	00707063 	rsbseq	r7, r0, r3, rrx
      74:	78635f5f 	stmdavc	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, sl, fp, ip, lr}^
      78:	75675f61 	strbvc	r5, [r7, #-3937]!	; 0xfffff09f
      7c:	5f647261 	svcpl	0x00647261
      80:	726f6261 	rsbvc	r6, pc, #268435462	; 0x10000006
      84:	5f5f0074 	svcpl	0x005f0074
      88:	5f6f7364 	svcpl	0x006f7364
      8c:	646e6168 	strbtvs	r6, [lr], #-360	; 0xfffffe98
      90:	5f00656c 	svcpl	0x0000656c
      94:	6178635f 	cmnvs	r8, pc, asr r3
      98:	6574615f 	ldrbvs	r6, [r4, #-351]!	; 0xfffffea1
      9c:	00746978 	rsbseq	r6, r4, r8, ror r9
      a0:	20554e47 	subscs	r4, r5, r7, asr #28
      a4:	312b2b43 			; <UNDEFINED> instruction: 0x312b2b43
      a8:	30312034 	eorscc	r2, r1, r4, lsr r0
      ac:	312e332e 			; <UNDEFINED> instruction: 0x312e332e
      b0:	32303220 	eorscc	r3, r0, #32, 4
      b4:	32363031 	eorscc	r3, r6, #49	; 0x31
      b8:	72282031 	eorvc	r2, r8, #49	; 0x31
      bc:	61656c65 	cmnvs	r5, r5, ror #24
      c0:	20296573 	eorcs	r6, r9, r3, ror r5
      c4:	6c666d2d 	stclvs	13, cr6, [r6], #-180	; 0xffffff4c
      c8:	2d74616f 	ldfcse	f6, [r4, #-444]!	; 0xfffffe44
      cc:	3d696261 	sfmcc	f6, 2, [r9, #-388]!	; 0xfffffe7c
      d0:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
      d4:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
      d8:	763d7570 			; <UNDEFINED> instruction: 0x763d7570
      dc:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
      e0:	6f6c666d 	svcvs	0x006c666d
      e4:	612d7461 			; <UNDEFINED> instruction: 0x612d7461
      e8:	683d6962 	ldmdavs	sp!, {r1, r5, r6, r8, fp, sp, lr}
      ec:	20647261 	rsbcs	r7, r4, r1, ror #4
      f0:	70666d2d 	rsbvc	r6, r6, sp, lsr #26
      f4:	66763d75 			; <UNDEFINED> instruction: 0x66763d75
      f8:	6d2d2070 	stcvs	0, cr2, [sp, #-448]!	; 0xfffffe40
      fc:	656e7574 	strbvs	r7, [lr, #-1396]!	; 0xfffffa8c
     100:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
     104:	36373131 			; <UNDEFINED> instruction: 0x36373131
     108:	2d667a6a 	vstmdbcs	r6!, {s15-s120}
     10c:	6d2d2073 	stcvs	0, cr2, [sp, #-460]!	; 0xfffffe34
     110:	206d7261 	rsbcs	r7, sp, r1, ror #4
     114:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
     118:	613d6863 	teqvs	sp, r3, ror #16
     11c:	36766d72 			; <UNDEFINED> instruction: 0x36766d72
     120:	662b6b7a 			; <UNDEFINED> instruction: 0x662b6b7a
     124:	672d2070 			; <UNDEFINED> instruction: 0x672d2070
     128:	20672d20 	rsbcs	r2, r7, r0, lsr #26
     12c:	20304f2d 	eorscs	r4, r0, sp, lsr #30
     130:	00304f2d 	eorseq	r4, r0, sp, lsr #30
     134:	78635f5f 	stmdavc	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, sl, fp, ip, lr}^
     138:	75675f61 	strbvc	r5, [r7, #-3937]!	; 0xfffff09f
     13c:	5f647261 	svcpl	0x00647261
     140:	75716361 	ldrbvc	r6, [r1, #-865]!	; 0xfffffc9f
     144:	00657269 	rsbeq	r7, r5, r9, ror #4
     148:	78635f5f 	stmdavc	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, sl, fp, ip, lr}^
     14c:	69626178 	stmdbvs	r2!, {r3, r4, r5, r6, r8, sp, lr}^
     150:	5f003176 	svcpl	0x00003176
     154:	6178635f 	cmnvs	r8, pc, asr r3
     158:	7275705f 	rsbsvc	r7, r5, #95	; 0x5f
     15c:	69765f65 	ldmdbvs	r6!, {r0, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     160:	61757472 	cmnvs	r5, r2, ror r4
     164:	6d2f006c 	stcvs	0, cr0, [pc, #-432]!	; ffffffbc <_bss_end+0xffff68a0>
     168:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
     16c:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
     170:	4b2f7372 	blmi	bdcf40 <_bss_end+0xbd3824>
     174:	2f616275 	svccs	0x00616275
     178:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
     17c:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
     180:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
     184:	614d6f72 	hvcvs	55026	; 0xd6f2
     188:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffc1c <_bss_end+0xffff6500>
     18c:	706d6178 	rsbvc	r6, sp, r8, ror r1
     190:	2f73656c 	svccs	0x0073656c
     194:	552d3831 	strpl	r3, [sp, #-2097]!	; 0xfffff7cf
     198:	2f545241 	svccs	0x00545241
     19c:	6c697562 	cfstr64vs	mvdx7, [r9], #-392	; 0xfffffe78
     1a0:	5f5f0064 	svcpl	0x005f0064
     1a4:	72617567 	rsbvc	r7, r1, #432013312	; 0x19c00000
     1a8:	6f6c0064 	svcvs	0x006c0064
     1ac:	6c20676e 	stcvs	7, cr6, [r0], #-440	; 0xfffffe48
     1b0:	20676e6f 	rsbcs	r6, r7, pc, ror #28
     1b4:	00746e69 	rsbseq	r6, r4, r9, ror #28
     1b8:	726f6873 	rsbvc	r6, pc, #7536640	; 0x730000
     1bc:	6e692074 	mcrvs	0, 3, r2, cr9, cr4, {3}
     1c0:	50530074 	subspl	r0, r3, r4, ror r0
     1c4:	505f3149 	subspl	r3, pc, r9, asr #2
     1c8:	004b4545 	subeq	r4, fp, r5, asr #10
     1cc:	31495053 	qdaddcc	r5, r3, r9
     1d0:	4154535f 	cmpmi	r4, pc, asr r3
     1d4:	416d0054 	qdsubmi	r0, r4, sp
     1d8:	525f5855 	subspl	r5, pc, #5570560	; 0x550000
     1dc:	5f006765 	svcpl	0x00006765
     1e0:	43344e5a 	teqmi	r4, #1440	; 0x5a0
     1e4:	31585541 	cmpcc	r8, r1, asr #10
     1e8:	74654732 	strbtvc	r4, [r5], #-1842	; 0xfffff8ce
     1ec:	6765525f 			; <UNDEFINED> instruction: 0x6765525f
     1f0:	65747369 	ldrbvs	r7, [r4, #-873]!	; 0xfffffc97
     1f4:	334e4572 	movtcc	r4, #58738	; 0xe572
     1f8:	376c6168 	strbcc	r6, [ip, -r8, ror #2]!
     1fc:	5f585541 	svcpl	0x00585541
     200:	45676552 	strbmi	r6, [r7, #-1362]!	; 0xfffffaae
     204:	6c617600 	stclvs	6, cr7, [r1], #-0
     208:	61006575 	tstvs	r0, r5, ror r5
     20c:	625f7875 	subsvs	r7, pc, #7667712	; 0x750000
     210:	00657361 	rsbeq	r7, r5, r1, ror #6
     214:	42414e45 	submi	r4, r1, #1104	; 0x450
     218:	0053454c 	subseq	r4, r3, ip, asr #10
     21c:	344e5a5f 	strbcc	r5, [lr], #-2655	; 0xfffff5a1
     220:	58554143 	ldmdapl	r5, {r0, r1, r6, r8, lr}^
     224:	616e4536 	cmnvs	lr, r6, lsr r5
     228:	45656c62 	strbmi	r6, [r5, #-3170]!	; 0xfffff39e
     22c:	6168334e 	cmnvs	r8, lr, asr #6
     230:	4135316c 	teqmi	r5, ip, ror #2
     234:	505f5855 	subspl	r5, pc, r5, asr r8	; <UNPREDICTABLE>
     238:	70697265 	rsbvc	r7, r9, r5, ror #4
     23c:	61726568 	cmnvs	r2, r8, ror #10
     240:	0045736c 	subeq	r7, r5, ip, ror #6
     244:	5f585541 	svcpl	0x00585541
     248:	69726550 	ldmdbvs	r2!, {r4, r6, r8, sl, sp, lr}^
     24c:	72656870 	rsbvc	r6, r5, #112, 16	; 0x700000
     250:	00736c61 	rsbseq	r6, r3, r1, ror #24
     254:	344e5a5f 	strbcc	r5, [lr], #-2655	; 0xfffff5a1
     258:	58554143 	ldmdapl	r5, {r0, r1, r6, r8, lr}^
     25c:	6a453443 	bvs	114d370 <_bss_end+0x1143c54>
     260:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     264:	55414334 	strbpl	r4, [r1, #-820]	; 0xfffffccc
     268:	53323158 	teqpl	r2, #88, 2
     26c:	525f7465 	subspl	r7, pc, #1694498816	; 0x65000000
     270:	73696765 	cmnvc	r9, #26476544	; 0x1940000
     274:	45726574 	ldrbmi	r6, [r2, #-1396]!	; 0xfffffa8c
     278:	6168334e 	cmnvs	r8, lr, asr #6
     27c:	5541376c 	strbpl	r3, [r1, #-1900]	; 0xfffff894
     280:	65525f58 	ldrbvs	r5, [r2, #-3928]	; 0xfffff0a8
     284:	006a4567 	rsbeq	r4, sl, r7, ror #10
     288:	30495053 	subcc	r5, r9, r3, asr r0
     28c:	004f495f 	subeq	r4, pc, pc, asr r9	; <UNPREDICTABLE>
     290:	4f4c475f 	svcmi	0x004c475f
     294:	5f4c4142 	svcpl	0x004c4142
     298:	6275735f 	rsbsvs	r7, r5, #2080374785	; 0x7c000001
     29c:	735f495f 	cmpvc	pc, #1556480	; 0x17c000
     2a0:	00585541 	subseq	r5, r8, r1, asr #10
     2a4:	30495053 	subcc	r5, r9, r3, asr r0
     2a8:	544e435f 	strbpl	r4, [lr], #-863	; 0xfffffca1
     2ac:	5300304c 	movwpl	r3, #76	; 0x4c
     2b0:	5f304950 	svcpl	0x00304950
     2b4:	4c544e43 	mrrcmi	14, 4, r4, r4, cr3	; <UNPREDICTABLE>
     2b8:	65500031 	ldrbvs	r0, [r0, #-49]	; 0xffffffcf
     2bc:	68706972 	ldmdavs	r0!, {r1, r4, r5, r6, r8, fp, sp, lr}^
     2c0:	6c617265 	sfmvs	f7, 2, [r1], #-404	; 0xfffffe6c
     2c4:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
     2c8:	5f5f0065 	svcpl	0x005f0065
     2cc:	74696e69 	strbtvc	r6, [r9], #-3689	; 0xfffff197
     2d0:	696c6169 	stmdbvs	ip!, {r0, r3, r5, r6, r8, sp, lr}^
     2d4:	705f657a 	subsvc	r6, pc, sl, ror r5	; <UNPREDICTABLE>
     2d8:	49505300 	ldmdbmi	r0, {r8, r9, ip, lr}^
     2dc:	4e435f31 	mcrmi	15, 2, r5, cr3, cr1, {1}
     2e0:	00304c54 	eorseq	r4, r0, r4, asr ip
     2e4:	31495053 	qdaddcc	r5, r3, r9
     2e8:	544e435f 	strbpl	r4, [lr], #-863	; 0xfffffca1
     2ec:	4500314c 	strmi	r3, [r0, #-332]	; 0xfffffeb4
     2f0:	6c62616e 	stfvse	f6, [r2], #-440	; 0xfffffe48
     2f4:	6e750065 	cdpvs	0, 7, cr0, cr5, cr5, {3}
     2f8:	6e676973 			; <UNDEFINED> instruction: 0x6e676973
     2fc:	63206465 			; <UNDEFINED> instruction: 0x63206465
     300:	00726168 	rsbseq	r6, r2, r8, ror #2
     304:	495f554d 	ldmdbmi	pc, {r0, r2, r3, r6, r8, sl, ip, lr}^	; <UNPREDICTABLE>
     308:	4d005245 	sfmmi	f5, 4, [r0, #-276]	; 0xfffffeec
     30c:	434d5f55 	movtmi	r5, #57173	; 0xdf55
     310:	50470052 	subpl	r0, r7, r2, asr r0
     314:	425f4f49 	subsmi	r4, pc, #292	; 0x124
     318:	00657361 	rsbeq	r7, r5, r1, ror #6
     31c:	344e5a5f 	strbcc	r5, [lr], #-2655	; 0xfffff5a1
     320:	58554143 	ldmdapl	r5, {r0, r1, r6, r8, lr}^
     324:	6a453243 	bvs	114cc38 <_bss_end+0x114351c>
     328:	6e697500 	cdpvs	5, 6, cr7, cr9, cr0, {0}
     32c:	5f323374 	svcpl	0x00323374
     330:	69440074 	stmdbvs	r4, {r2, r4, r5, r6}^
     334:	6c626173 	stfvse	f6, [r2], #-460	; 0xfffffe34
     338:	65470065 	strbvs	r0, [r7, #-101]	; 0xffffff9b
     33c:	65525f74 	ldrbvs	r5, [r2, #-3956]	; 0xfffff08c
     340:	74736967 	ldrbtvc	r6, [r3], #-2407	; 0xfffff699
     344:	4d007265 	sfmmi	f7, 4, [r0, #-404]	; 0xfffffe6c
     348:	49495f55 	stmdbmi	r9, {r0, r2, r4, r6, r8, r9, sl, fp, ip, lr}^
     34c:	554d0052 	strbpl	r0, [sp, #-82]	; 0xffffffae
     350:	544e435f 	strbpl	r4, [lr], #-863	; 0xfffffca1
     354:	5053004c 	subspl	r0, r3, ip, asr #32
     358:	53003149 	movwpl	r3, #329	; 0x149
     35c:	00324950 	eorseq	r4, r2, r0, asr r9
     360:	726f6873 	rsbvc	r6, pc, #7536640	; 0x730000
     364:	6e752074 	mrcvs	0, 3, r2, cr5, cr4, {3}
     368:	6e676973 			; <UNDEFINED> instruction: 0x6e676973
     36c:	69206465 	stmdbvs	r0!, {r0, r2, r5, r6, sl, sp, lr}
     370:	5300746e 	movwpl	r7, #1134	; 0x46e
     374:	5f314950 	svcpl	0x00314950
     378:	4d004f49 	stcmi	15, cr4, [r0, #-292]	; 0xfffffedc
     37c:	434c5f55 	movtmi	r5, #53077	; 0xcf55
     380:	50530052 	subspl	r0, r3, r2, asr r0
     384:	505f3049 	subspl	r3, pc, r9, asr #32
     388:	004b4545 	subeq	r4, fp, r5, asr #10
     38c:	425f554d 	subsmi	r5, pc, #322961408	; 0x13400000
     390:	00445541 	subeq	r5, r4, r1, asr #10
     394:	30495053 	subcc	r5, r9, r3, asr r0
     398:	4154535f 	cmpmi	r4, pc, asr r3
     39c:	50470054 	subpl	r0, r7, r4, asr r0
     3a0:	505f4f49 	subspl	r4, pc, r9, asr #30
     3a4:	435f6e69 	cmpmi	pc, #1680	; 0x690
     3a8:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
     3ac:	735f5f00 	cmpvc	pc, #0, 30
     3b0:	69746174 	ldmdbvs	r4!, {r2, r4, r5, r6, r8, sp, lr}^
     3b4:	6e695f63 	cdpvs	15, 6, cr5, cr9, cr3, {3}
     3b8:	61697469 	cmnvs	r9, r9, ror #8
     3bc:	617a696c 	cmnvs	sl, ip, ror #18
     3c0:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     3c4:	646e615f 	strbtvs	r6, [lr], #-351	; 0xfffffea1
     3c8:	7365645f 	cmnvc	r5, #1593835520	; 0x5f000000
     3cc:	63757274 	cmnvs	r5, #116, 4	; 0x40000007
     3d0:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     3d4:	5f00305f 	svcpl	0x0000305f
     3d8:	6972705f 	ldmdbvs	r2!, {r0, r1, r2, r3, r4, r6, ip, sp, lr}^
     3dc:	7469726f 	strbtvc	r7, [r9], #-623	; 0xfffffd91
     3e0:	68740079 	ldmdavs	r4!, {r0, r3, r4, r5, r6}^
     3e4:	53007369 	movwpl	r7, #873	; 0x369
     3e8:	525f7465 	subspl	r7, pc, #1694498816	; 0x65000000
     3ec:	73696765 	cmnvc	r9, #26476544	; 0x1940000
     3f0:	00726574 	rsbseq	r6, r2, r4, ror r5
     3f4:	4d5f554d 	cfldr64mi	mvdx5, [pc, #-308]	; 2c8 <shift+0x2c8>
     3f8:	2f005253 	svccs	0x00005253
     3fc:	2f746e6d 	svccs	0x00746e6d
     400:	73552f63 	cmpvc	r5, #396	; 0x18c
     404:	2f737265 	svccs	0x00737265
     408:	6162754b 	cmnvs	r2, fp, asr #10
     40c:	636f442f 	cmnvs	pc, #788529152	; 0x2f000000
     410:	6e656d75 	mcrvs	13, 3, r6, cr5, cr5, {3}
     414:	5a2f7374 	bpl	bdd1ec <_bss_end+0xbd3ad0>
     418:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 28c <shift+0x28c>
     41c:	2f657461 	svccs	0x00657461
     420:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
     424:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
     428:	2d38312f 	ldfcss	f3, [r8, #-188]!	; 0xffffff44
     42c:	54524155 	ldrbpl	r4, [r2], #-341	; 0xfffffeab
     430:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
     434:	2f6c656e 	svccs	0x006c656e
     438:	2f637273 	svccs	0x00637273
     43c:	76697264 	strbtvc	r7, [r9], -r4, ror #4
     440:	2f737265 	svccs	0x00737265
     444:	5f6d6362 	svcpl	0x006d6362
     448:	2e787561 	cdpcs	5, 7, cr7, cr8, cr1, {3}
     44c:	00707063 	rsbseq	r7, r0, r3, rrx
     450:	5f585541 	svcpl	0x00585541
     454:	65736142 	ldrbvs	r6, [r3, #-322]!	; 0xfffffebe
     458:	5f554d00 	svcpl	0x00554d00
     45c:	54415453 	strbpl	r5, [r1], #-1107	; 0xfffffbad
     460:	78756100 	ldmdavc	r5!, {r8, sp, lr}^
     464:	7265705f 	rsbvc	r7, r5, #95	; 0x5f
     468:	65687069 	strbvs	r7, [r8, #-105]!	; 0xffffff97
     46c:	006c6172 	rsbeq	r6, ip, r2, ror r1
     470:	495f554d 	ldmdbmi	pc, {r0, r2, r3, r6, r8, sl, ip, lr}^	; <UNPREDICTABLE>
     474:	694d004f 	stmdbvs	sp, {r0, r1, r2, r3, r6}^
     478:	4155696e 	cmpmi	r5, lr, ror #18
     47c:	4d005452 	cfstrsmi	mvf5, [r0, #-328]	; 0xfffffeb8
     480:	534c5f55 	movtpl	r5, #53077	; 0xcf55
     484:	65720052 	ldrbvs	r0, [r2, #-82]!	; 0xffffffae
     488:	64695f67 	strbtvs	r5, [r9], #-3943	; 0xfffff099
     48c:	5a5f0078 	bpl	17c0674 <_bss_end+0x17b6f58>
     490:	4143344e 	cmpmi	r3, lr, asr #8
     494:	44375855 	ldrtmi	r5, [r7], #-2133	; 0xfffff7ab
     498:	62617369 	rsbvs	r7, r1, #-1543503871	; 0xa4000001
     49c:	4e45656c 	cdpmi	5, 4, cr6, cr5, cr12, {3}
     4a0:	6c616833 	stclvs	8, cr6, [r1], #-204	; 0xffffff34
     4a4:	55413531 	strbpl	r3, [r1, #-1329]	; 0xfffffacf
     4a8:	65505f58 	ldrbvs	r5, [r0, #-3928]	; 0xfffff0a8
     4ac:	68706972 	ldmdavs	r0!, {r1, r4, r5, r6, r8, fp, sp, lr}^
     4b0:	6c617265 	sfmvs	f7, 2, [r1], #-404	; 0xfffffe6c
     4b4:	4d004573 	cfstr32mi	mvfx4, [r0, #-460]	; 0xfffffe34
     4b8:	43535f55 	cmpmi	r3, #340	; 0x154
     4bc:	43544152 	cmpmi	r4, #-2147483628	; 0x80000014
     4c0:	5a5f0048 	bpl	17c05e8 <_bss_end+0x17b6ecc>
     4c4:	33314b4e 	teqcc	r1, #79872	; 0x13800
     4c8:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     4cc:	61485f4f 	cmpvs	r8, pc, asr #30
     4d0:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     4d4:	47383172 			; <UNDEFINED> instruction: 0x47383172
     4d8:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     4dc:	56454c50 			; <UNDEFINED> instruction: 0x56454c50
     4e0:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     4e4:	6f697461 	svcvs	0x00697461
     4e8:	526a456e 	rsbpl	r4, sl, #461373440	; 0x1b800000
     4ec:	5f30536a 	svcpl	0x0030536a
     4f0:	53504700 	cmppl	r0, #0, 14
     4f4:	00305445 	eorseq	r5, r0, r5, asr #8
     4f8:	45535047 	ldrbmi	r5, [r3, #-71]	; 0xffffffb9
     4fc:	47003154 	smlsdmi	r0, r4, r1, r3
     500:	45534650 	ldrbmi	r4, [r3, #-1616]	; 0xfffff9b0
     504:	4700304c 	strmi	r3, [r0, -ip, asr #32]
     508:	45534650 	ldrbmi	r4, [r3, #-1616]	; 0xfffff9b0
     50c:	4700314c 	strmi	r3, [r0, -ip, asr #2]
     510:	45534650 	ldrbmi	r4, [r3, #-1616]	; 0xfffff9b0
     514:	4700324c 	strmi	r3, [r0, -ip, asr #4]
     518:	45534650 	ldrbmi	r4, [r3, #-1616]	; 0xfffff9b0
     51c:	4700334c 	strmi	r3, [r0, -ip, asr #6]
     520:	45534650 	ldrbmi	r4, [r3, #-1616]	; 0xfffff9b0
     524:	4700344c 	strmi	r3, [r0, -ip, asr #8]
     528:	45534650 	ldrbmi	r4, [r3, #-1616]	; 0xfffff9b0
     52c:	4700354c 	strmi	r3, [r0, -ip, asr #10]
     530:	44555050 	ldrbmi	r5, [r5], #-80	; 0xffffffb0
     534:	304b4c43 	subcc	r4, fp, r3, asr #24
     538:	50504700 	subspl	r4, r0, r0, lsl #14
     53c:	4c434455 	cfstrdmi	mvd4, [r3], {85}	; 0x55
     540:	4700314b 	strmi	r3, [r0, -fp, asr #2]
     544:	4e455250 	mcrmi	2, 2, r5, cr5, cr0, {2}
     548:	50470030 	subpl	r0, r7, r0, lsr r0
     54c:	314e4552 	cmpcc	lr, r2, asr r5
     550:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     554:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     558:	5f4f4950 	svcpl	0x004f4950
     55c:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     560:	3172656c 	cmncc	r2, ip, ror #10
     564:	74655330 	strbtvc	r5, [r5], #-816	; 0xfffffcd0
     568:	74754f5f 	ldrbtvc	r4, [r5], #-3935	; 0xfffff0a1
     56c:	45747570 	ldrbmi	r7, [r4, #-1392]!	; 0xfffffa90
     570:	5f00626a 	svcpl	0x0000626a
     574:	314b4e5a 	cmpcc	fp, sl, asr lr
     578:	50474333 	subpl	r4, r7, r3, lsr r3
     57c:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     580:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     584:	39317265 	ldmdbcc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     588:	5f746547 	svcpl	0x00746547
     58c:	53465047 	movtpl	r5, #24647	; 0x6047
     590:	4c5f4c45 	mrrcmi	12, 4, r4, pc, cr5	; <UNPREDICTABLE>
     594:	7461636f 	strbtvc	r6, [r1], #-879	; 0xfffffc91
     598:	456e6f69 	strbmi	r6, [lr, #-3945]!	; 0xfffff097
     59c:	536a526a 	cmnpl	sl, #-1610612730	; 0xa0000006
     5a0:	6d005f30 	stcvs	15, cr5, [r0, #-192]	; 0xffffff40
     5a4:	4f495047 	svcmi	0x00495047
     5a8:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     5ac:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     5b0:	5f4f4950 	svcpl	0x004f4950
     5b4:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     5b8:	4372656c 	cmnmi	r2, #108, 10	; 0x1b000000
     5bc:	006a4534 	rsbeq	r4, sl, r4, lsr r5
     5c0:	746e6975 	strbtvc	r6, [lr], #-2421	; 0xfffff68b
     5c4:	00745f38 	rsbseq	r5, r4, r8, lsr pc
     5c8:	44455047 	strbmi	r5, [r5], #-71	; 0xffffffb9
     5cc:	47003053 	smlsdmi	r0, r3, r0, r3
     5d0:	53444550 	movtpl	r4, #17744	; 0x4550
     5d4:	6f620031 	svcvs	0x00620031
     5d8:	55006c6f 	strpl	r6, [r0, #-3183]	; 0xfffff391
     5dc:	6570736e 	ldrbvs	r7, [r0, #-878]!	; 0xfffffc92
     5e0:	69666963 	stmdbvs	r6!, {r0, r1, r5, r6, r8, fp, sp, lr}^
     5e4:	47006465 	strmi	r6, [r0, -r5, ror #8]
     5e8:	4e454c50 	mcrmi	12, 2, r4, cr5, cr0, {2}
     5ec:	75660030 	strbvc	r0, [r6, #-48]!	; 0xffffffd0
     5f0:	4700636e 	strmi	r6, [r0, -lr, ror #6]
     5f4:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     5f8:	5f4f4950 	svcpl	0x004f4950
     5fc:	636e7546 	cmnvs	lr, #293601280	; 0x11800000
     600:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     604:	50474300 	subpl	r4, r7, r0, lsl #6
     608:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     60c:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     610:	47007265 	strmi	r7, [r0, -r5, ror #4]
     614:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     618:	54455350 	strbpl	r5, [r5], #-848	; 0xfffffcb0
     61c:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     620:	6f697461 	svcvs	0x00697461
     624:	5047006e 	subpl	r0, r7, lr, rrx
     628:	00445550 	subeq	r5, r4, r0, asr r5
     62c:	5f746547 	svcpl	0x00746547
     630:	454c5047 	strbmi	r5, [ip, #-71]	; 0xffffffb9
     634:	6f4c5f56 	svcvs	0x004c5f56
     638:	69746163 	ldmdbvs	r4!, {r0, r1, r5, r6, r8, sp, lr}^
     63c:	5f006e6f 	svcpl	0x00006e6f
     640:	314b4e5a 	cmpcc	fp, sl, asr lr
     644:	50474333 	subpl	r4, r7, r3, lsr r3
     648:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     64c:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     650:	37317265 	ldrcc	r7, [r1, -r5, ror #4]!
     654:	5f746547 	svcpl	0x00746547
     658:	4f495047 	svcmi	0x00495047
     65c:	6e75465f 	mrcvs	6, 3, r4, cr5, cr15, {2}
     660:	6f697463 	svcvs	0x00697463
     664:	006a456e 	rsbeq	r4, sl, lr, ror #10
     668:	314e5a5f 	cmpcc	lr, pc, asr sl
     66c:	50474333 	subpl	r4, r7, r3, lsr r3
     670:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     674:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     678:	32437265 	subcc	r7, r3, #1342177286	; 0x50000006
     67c:	47006a45 	strmi	r6, [r0, -r5, asr #20]
     680:	45464150 	strbmi	r4, [r6, #-336]	; 0xfffffeb0
     684:	4700304e 	strmi	r3, [r0, -lr, asr #32]
     688:	45464150 	strbmi	r4, [r6, #-336]	; 0xfffffeb0
     68c:	5f00314e 	svcpl	0x0000314e
     690:	314b4e5a 	cmpcc	fp, sl, asr lr
     694:	50474333 	subpl	r4, r7, r3, lsr r3
     698:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     69c:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     6a0:	38317265 	ldmdacc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     6a4:	5f746547 	svcpl	0x00746547
     6a8:	4c435047 	mcrrmi	0, 4, r5, r3, cr7
     6ac:	6f4c5f52 	svcvs	0x004c5f52
     6b0:	69746163 	ldmdbvs	r4!, {r0, r1, r5, r6, r8, sp, lr}^
     6b4:	6a456e6f 	bvs	115c078 <_bss_end+0x115295c>
     6b8:	30536a52 	subscc	r6, r3, r2, asr sl
     6bc:	475f005f 			; <UNDEFINED> instruction: 0x475f005f
     6c0:	41424f4c 	cmpmi	r2, ip, asr #30
     6c4:	735f5f4c 	cmpvc	pc, #76, 30	; 0x130
     6c8:	495f6275 	ldmdbmi	pc, {r0, r2, r4, r5, r6, r9, sp, lr}^	; <UNPREDICTABLE>
     6cc:	5047735f 	subpl	r7, r7, pc, asr r3
     6d0:	47004f49 	strmi	r4, [r0, -r9, asr #30]
     6d4:	524c4350 	subpl	r4, ip, #80, 6	; 0x40000001
     6d8:	50470031 	subpl	r0, r7, r1, lsr r0
     6dc:	4e455241 	cdpmi	2, 4, cr5, cr5, cr1, {2}
     6e0:	50470030 	subpl	r0, r7, r0, lsr r0
     6e4:	4e455241 	cdpmi	2, 4, cr5, cr5, cr1, {2}
     6e8:	50470031 	subpl	r0, r7, r1, lsr r0
     6ec:	304e4548 	subcc	r4, lr, r8, asr #10
     6f0:	48504700 	ldmdami	r0, {r8, r9, sl, lr}^
     6f4:	00314e45 	eorseq	r4, r1, r5, asr #28
     6f8:	6f697067 	svcvs	0x00697067
     6fc:	7361625f 	cmnvc	r1, #-268435451	; 0xf0000005
     700:	64615f65 	strbtvs	r5, [r1], #-3941	; 0xfffff09b
     704:	47007264 	strmi	r7, [r0, -r4, ror #4]
     708:	4e454c50 	mcrmi	12, 2, r4, cr5, cr0, {2}
     70c:	65470031 	strbvs	r0, [r7, #-49]	; 0xffffffcf
     710:	50475f74 	subpl	r5, r7, r4, ror pc
     714:	4c455346 	mcrrmi	3, 4, r5, r5, cr6
     718:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     71c:	6f697461 	svcvs	0x00697461
     720:	6d2f006e 	stcvs	0, cr0, [pc, #-440]!	; 570 <shift+0x570>
     724:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
     728:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
     72c:	4b2f7372 	blmi	bdd4fc <_bss_end+0xbd3de0>
     730:	2f616275 	svccs	0x00616275
     734:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
     738:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
     73c:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
     740:	614d6f72 	hvcvs	55026	; 0xd6f2
     744:	652f6574 	strvs	r6, [pc, #-1396]!	; 1d8 <shift+0x1d8>
     748:	706d6178 	rsbvc	r6, sp, r8, ror r1
     74c:	2f73656c 	svccs	0x0073656c
     750:	552d3831 	strpl	r3, [sp, #-2097]!	; 0xfffff7cf
     754:	2f545241 	svccs	0x00545241
     758:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
     75c:	732f6c65 			; <UNDEFINED> instruction: 0x732f6c65
     760:	642f6372 	strtvs	r6, [pc], #-882	; 768 <shift+0x768>
     764:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
     768:	672f7372 			; <UNDEFINED> instruction: 0x672f7372
     76c:	2e6f6970 			; <UNDEFINED> instruction: 0x2e6f6970
     770:	00707063 	rsbseq	r7, r0, r3, rrx
     774:	314e5a5f 	cmpcc	lr, pc, asr sl
     778:	50474333 	subpl	r4, r7, r3, lsr r3
     77c:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     780:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     784:	37317265 	ldrcc	r7, [r1, -r5, ror #4]!
     788:	5f746553 	svcpl	0x00746553
     78c:	4f495047 	svcmi	0x00495047
     790:	6e75465f 	mrcvs	6, 3, r4, cr5, cr15, {2}
     794:	6f697463 	svcvs	0x00697463
     798:	316a456e 	cmncc	sl, lr, ror #10
     79c:	50474e34 	subpl	r4, r7, r4, lsr lr
     7a0:	465f4f49 	ldrbmi	r4, [pc], -r9, asr #30
     7a4:	74636e75 	strbtvc	r6, [r3], #-3701	; 0xfffff18b
     7a8:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     7ac:	454c5047 	strbmi	r5, [ip, #-71]	; 0xffffffb9
     7b0:	47003056 	smlsdmi	r0, r6, r0, r3
     7b4:	56454c50 			; <UNDEFINED> instruction: 0x56454c50
     7b8:	65530031 	ldrbvs	r0, [r3, #-49]	; 0xffffffcf
     7bc:	50475f74 	subpl	r5, r7, r4, ror pc
     7c0:	465f4f49 	ldrbmi	r4, [pc], -r9, asr #30
     7c4:	74636e75 	strbtvc	r6, [r3], #-3701	; 0xfffff18b
     7c8:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     7cc:	5f746962 	svcpl	0x00746962
     7d0:	00786469 	rsbseq	r6, r8, r9, ror #8
     7d4:	5f746553 	svcpl	0x00746553
     7d8:	7074754f 	rsbsvc	r7, r4, pc, asr #10
     7dc:	5f007475 	svcpl	0x00007475
     7e0:	314b4e5a 	cmpcc	fp, sl, asr lr
     7e4:	50474333 	subpl	r4, r7, r3, lsr r3
     7e8:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     7ec:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     7f0:	38317265 	ldmdacc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     7f4:	5f746547 	svcpl	0x00746547
     7f8:	45535047 	ldrbmi	r5, [r3, #-71]	; 0xffffffb9
     7fc:	6f4c5f54 	svcvs	0x004c5f54
     800:	69746163 	ldmdbvs	r4!, {r0, r1, r5, r6, r8, sp, lr}^
     804:	6a456e6f 	bvs	115c1c8 <_bss_end+0x1152aac>
     808:	30536a52 	subscc	r6, r3, r2, asr sl
     80c:	6547005f 	strbvs	r0, [r7, #-95]	; 0xffffffa1
     810:	50475f74 	subpl	r5, r7, r4, ror pc
     814:	5f524c43 	svcpl	0x00524c43
     818:	61636f4c 	cmnvs	r3, ip, asr #30
     81c:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     820:	706e4900 	rsbvc	r4, lr, r0, lsl #18
     824:	47007475 	smlsdxmi	r0, r5, r4, r7
     828:	4e454650 	mcrmi	6, 2, r4, cr5, cr0, {2}
     82c:	50470030 	subpl	r0, r7, r0, lsr r0
     830:	314e4546 	cmpcc	lr, r6, asr #10
     834:	49504700 	ldmdbmi	r0, {r8, r9, sl, lr}^
     838:	65525f4f 	ldrbvs	r5, [r2, #-3919]	; 0xfffff0b1
     83c:	6c410067 	mcrrvs	0, 6, r0, r1, cr7
     840:	00305f74 	eorseq	r5, r0, r4, ror pc
     844:	5f746c41 	svcpl	0x00746c41
     848:	6c410031 	mcrrvs	0, 3, r0, r1, cr1
     84c:	00325f74 	eorseq	r5, r2, r4, ror pc
     850:	5f746c41 	svcpl	0x00746c41
     854:	6c410033 	mcrrvs	0, 3, r0, r1, cr3
     858:	00345f74 	eorseq	r5, r4, r4, ror pc
     85c:	5f746c41 	svcpl	0x00746c41
     860:	50470035 	subpl	r0, r7, r5, lsr r0
     864:	30524c43 	subscc	r4, r2, r3, asr #24
     868:	72635300 	rsbvc	r5, r3, #0, 6
     86c:	006c6c6f 	rsbeq	r6, ip, pc, ror #24
     870:	756e5f6d 	strbvc	r5, [lr, #-3949]!	; 0xfffff093
     874:	7265626d 	rsbvc	r6, r5, #-805306362	; 0xd0000006
     878:	7361625f 	cmnvc	r1, #-268435451	; 0xf0000005
     87c:	65520065 	ldrbvs	r0, [r2, #-101]	; 0xffffff9b
     880:	5f746573 	svcpl	0x00746573
     884:	626d754e 	rsbvs	r7, sp, #327155712	; 0x13800000
     888:	425f7265 	subsmi	r7, pc, #1342177286	; 0x50000006
     88c:	00657361 	rsbeq	r7, r5, r1, ror #6
     890:	61656c43 	cmnvs	r5, r3, asr #24
     894:	5a5f0072 	bpl	17c0a64 <_bss_end+0x17b7348>
     898:	4d43384e 	stclmi	8, cr3, [r3, #-312]	; 0xfffffec8
     89c:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
     8a0:	3243726f 	subcc	r7, r3, #-268435450	; 0xf0000006
     8a4:	6a6a6a45 	bvs	1a9b1c0 <_bss_end+0x1a91aa4>
     8a8:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     8ac:	6f4d4338 	svcvs	0x004d4338
     8b0:	6f74696e 	svcvs	0x0074696e
     8b4:	41333172 	teqmi	r3, r2, ror r1
     8b8:	73756a64 	cmnvc	r5, #100, 20	; 0x64000
     8bc:	75435f74 	strbvc	r5, [r3, #-3956]	; 0xfffff08c
     8c0:	726f7372 	rsbvc	r7, pc, #-939524095	; 0xc8000001
     8c4:	69007645 	stmdbvs	r0, {r0, r2, r6, r9, sl, ip, sp, lr}
     8c8:	00616f74 	rsbeq	r6, r1, r4, ror pc
     8cc:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
     8d0:	552f632f 	strpl	r6, [pc, #-815]!	; 5a9 <shift+0x5a9>
     8d4:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
     8d8:	62754b2f 	rsbsvs	r4, r5, #48128	; 0xbc00
     8dc:	6f442f61 	svcvs	0x00442f61
     8e0:	656d7563 	strbvs	r7, [sp, #-1379]!	; 0xfffffa9d
     8e4:	2f73746e 	svccs	0x0073746e
     8e8:	6f72655a 	svcvs	0x0072655a
     8ec:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
     8f0:	6178652f 	cmnvs	r8, pc, lsr #10
     8f4:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
     8f8:	38312f73 	ldmdacc	r1!, {r0, r1, r4, r5, r6, r8, r9, sl, fp, sp}
     8fc:	5241552d 	subpl	r5, r1, #188743680	; 0xb400000
     900:	656b2f54 	strbvs	r2, [fp, #-3924]!	; 0xfffff0ac
     904:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
     908:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
     90c:	6972642f 	ldmdbvs	r2!, {r0, r1, r2, r3, r5, sl, sp, lr}^
     910:	73726576 	cmnvc	r2, #494927872	; 0x1d800000
     914:	6e6f6d2f 	cdpvs	13, 6, cr6, cr15, cr15, {1}
     918:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
     91c:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
     920:	6a644100 	bvs	1910d28 <_bss_end+0x190760c>
     924:	5f747375 	svcpl	0x00747375
     928:	73727543 	cmnvc	r2, #281018368	; 0x10c00000
     92c:	4e00726f 	cdpmi	2, 0, cr7, cr0, cr15, {3}
     930:	626d754e 	rsbvs	r7, sp, #327155712	; 0x13800000
     934:	425f7265 	subsmi	r7, pc, #1342177286	; 0x50000006
     938:	00657361 	rsbeq	r7, r5, r1, ror #6
     93c:	736f5054 	cmnvc	pc, #84	; 0x54
     940:	6f697469 	svcvs	0x00697469
     944:	5a5f006e 	bpl	17c0b04 <_bss_end+0x17b73e8>
     948:	4d43384e 	stclmi	8, cr3, [r3, #-312]	; 0xfffffec8
     94c:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
     950:	3731726f 	ldrcc	r7, [r1, -pc, ror #4]!
     954:	65736552 	ldrbvs	r6, [r3, #-1362]!	; 0xfffffaae
     958:	754e5f74 	strbvc	r5, [lr, #-3956]	; 0xfffff08c
     95c:	7265626d 	rsbvc	r6, r5, #-805306362	; 0xd0000006
     960:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
     964:	00764565 	rsbseq	r4, r6, r5, ror #10
     968:	6f6d5f6d 	svcvs	0x006d5f6d
     96c:	6f74696e 	svcvs	0x0074696e
     970:	475f0072 			; <UNDEFINED> instruction: 0x475f0072
     974:	41424f4c 	cmpmi	r2, ip, asr #30
     978:	735f5f4c 	cmpvc	pc, #76, 30	; 0x130
     97c:	495f6275 	ldmdbmi	pc, {r0, r2, r4, r5, r6, r9, sp, lr}^	; <UNPREDICTABLE>
     980:	6f4d735f 	svcvs	0x004d735f
     984:	6f74696e 	svcvs	0x0074696e
     988:	6f6d0072 	svcvs	0x006d0072
     98c:	6f74696e 	svcvs	0x0074696e
     990:	61625f72 	smcvs	9714	; 0x25f2
     994:	615f6573 	cmpvs	pc, r3, ror r5	; <UNPREDICTABLE>
     998:	00726464 	rsbseq	r6, r2, r4, ror #8
     99c:	384e5a5f 	stmdacc	lr, {r0, r1, r2, r3, r4, r6, r9, fp, ip, lr}^
     9a0:	6e6f4d43 	cdpvs	13, 6, cr4, cr15, cr3, {2}
     9a4:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
     9a8:	656c4335 	strbvs	r4, [ip, #-821]!	; 0xfffffccb
     9ac:	76457261 	strbvc	r7, [r5], -r1, ror #4
     9b0:	6f4d4300 	svcvs	0x004d4300
     9b4:	6f74696e 	svcvs	0x0074696e
     9b8:	706f0072 	rsbvc	r0, pc, r2, ror r0	; <UNPREDICTABLE>
     9bc:	74617265 	strbtvc	r7, [r1], #-613	; 0xfffffd9b
     9c0:	3c3c726f 	lfmcc	f7, 4, [ip], #-444	; 0xfffffe44
     9c4:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     9c8:	6f4d4338 	svcvs	0x004d4338
     9cc:	6f74696e 	svcvs	0x0074696e
     9d0:	45736c72 	ldrbmi	r6, [r3, #-3186]!	; 0xfffff38e
     9d4:	00634b50 	rsbeq	r4, r3, r0, asr fp
     9d8:	384e5a5f 	stmdacc	lr, {r0, r1, r2, r3, r4, r6, r9, fp, ip, lr}^
     9dc:	6e6f4d43 	cdpvs	13, 6, cr4, cr15, cr3, {2}
     9e0:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
     9e4:	6f746934 	svcvs	0x00746934
     9e8:	506a4561 	rsbpl	r4, sl, r1, ror #10
     9ec:	6d006a63 	vstrvs	s12, [r0, #-396]	; 0xfffffe74
     9f0:	6965685f 	stmdbvs	r5!, {r0, r1, r2, r3, r4, r6, fp, sp, lr}^
     9f4:	00746867 	rsbseq	r6, r4, r7, ror #16
     9f8:	75635f6d 	strbvc	r5, [r3, #-3949]!	; 0xfffff093
     9fc:	726f7372 	rsbvc	r7, pc, #-939524095	; 0xc8000001
     a00:	61684300 	cmnvs	r8, r0, lsl #6
     a04:	6e6f4372 	mcrvs	3, 3, r4, cr15, cr2, {3}
     a08:	72724176 	rsbsvc	r4, r2, #-2147483619	; 0x8000001d
     a0c:	73655200 	cmnvc	r5, #0, 4
     a10:	435f7465 	cmpmi	pc, #1694498816	; 0x65000000
     a14:	6f737275 	svcvs	0x00737275
     a18:	5a5f0072 	bpl	17c0be8 <_bss_end+0x17b74cc>
     a1c:	4d43384e 	stclmi	8, cr3, [r3, #-312]	; 0xfffffec8
     a20:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
     a24:	736c726f 	cmnvc	ip, #-268435450	; 0xf0000006
     a28:	5f006245 	svcpl	0x00006245
     a2c:	43384e5a 	teqmi	r8, #1440	; 0x5a0
     a30:	696e6f4d 	stmdbvs	lr!, {r0, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     a34:	6c726f74 	ldclvs	15, cr6, [r2], #-464	; 0xfffffe30
     a38:	00634573 	rsbeq	r4, r3, r3, ror r5
     a3c:	69775f6d 	ldmdbvs	r7!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
     a40:	00687464 	rsbeq	r7, r8, r4, ror #8
     a44:	384e5a5f 	stmdacc	lr, {r0, r1, r2, r3, r4, r6, r9, fp, ip, lr}^
     a48:	6e6f4d43 	cdpvs	13, 6, cr4, cr15, cr3, {2}
     a4c:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
     a50:	72635336 	rsbvc	r5, r3, #-671088640	; 0xd8000000
     a54:	456c6c6f 	strbmi	r6, [ip, #-3183]!	; 0xfffff391
     a58:	5a5f0076 	bpl	17c0c38 <_bss_end+0x17b751c>
     a5c:	4d43384e 	stclmi	8, cr3, [r3, #-312]	; 0xfffffec8
     a60:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
     a64:	736c726f 	cmnvc	ip, #-268435450	; 0xf0000006
     a68:	5f006a45 	svcpl	0x00006a45
     a6c:	43384e5a 	teqmi	r8, #1440	; 0x5a0
     a70:	696e6f4d 	stmdbvs	lr!, {r0, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     a74:	31726f74 	cmncc	r2, r4, ror pc
     a78:	73655232 	cmnvc	r5, #536870915	; 0x20000003
     a7c:	435f7465 	cmpmi	pc, #1694498816	; 0x65000000
     a80:	6f737275 	svcvs	0x00737275
     a84:	00764572 	rsbseq	r4, r6, r2, ror r5
     a88:	384e5a5f 	stmdacc	lr, {r0, r1, r2, r3, r4, r6, r9, fp, ip, lr}^
     a8c:	6e6f4d43 	cdpvs	13, 6, cr4, cr15, cr3, {2}
     a90:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
     a94:	6a453443 	bvs	114dba8 <_bss_end+0x114448c>
     a98:	44006a6a 	strmi	r6, [r0], #-2666	; 0xfffff596
     a9c:	55414645 	strbpl	r4, [r1, #-1605]	; 0xfffff9bb
     aa0:	4e5f544c 	cdpmi	4, 5, cr5, cr15, cr12, {2}
     aa4:	45424d55 	strbmi	r4, [r2, #-3413]	; 0xfffff2ab
     aa8:	41425f52 	cmpmi	r2, r2, asr pc
     aac:	5f004553 	svcpl	0x00004553
     ab0:	43384e5a 	teqmi	r8, #1440	; 0x5a0
     ab4:	696e6f4d 	stmdbvs	lr!, {r0, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     ab8:	6c726f74 	ldclvs	15, cr6, [r2], #-464	; 0xfffffe30
     abc:	534e4573 	movtpl	r4, #58739	; 0xe573
     ac0:	4e32315f 	mrcmi	1, 1, r3, cr2, cr15, {2}
     ac4:	626d754e 	rsbvs	r7, sp, #327155712	; 0x13800000
     ac8:	425f7265 	subsmi	r7, pc, #1342177286	; 0x50000006
     acc:	45657361 	strbmi	r7, [r5, #-865]!	; 0xfffffc9f
     ad0:	74756f00 	ldrbtvc	r6, [r5], #-3840	; 0xfffff100
     ad4:	00747570 	rsbseq	r7, r4, r0, ror r5
     ad8:	75706e69 	ldrbvc	r6, [r0, #-3689]!	; 0xfffff197
     adc:	5f730074 	svcpl	0x00730074
     ae0:	66667562 	strbtvs	r7, [r6], -r2, ror #10
     ae4:	42007265 	andmi	r7, r0, #1342177286	; 0x50000006
     ae8:	45464655 	strbmi	r4, [r6, #-1621]	; 0xfffff9ab
     aec:	49535f52 	ldmdbmi	r3, {r1, r4, r6, r8, r9, sl, fp, ip, lr}^
     af0:	4200455a 	andmi	r4, r0, #377487360	; 0x16800000
     af4:	31315f52 	teqcc	r1, r2, asr pc
     af8:	30303235 	eorscc	r3, r0, r5, lsr r2
     afc:	5f524200 	svcpl	0x00524200
     b00:	30343833 	eorscc	r3, r4, r3, lsr r8
     b04:	5a5f0030 	bpl	17c0bcc <_bss_end+0x17b74b0>
     b08:	5543354e 	strbpl	r3, [r3, #-1358]	; 0xfffffab2
     b0c:	43545241 	cmpmi	r4, #268435460	; 0x10000004
     b10:	34524532 	ldrbcc	r4, [r2], #-1330	; 0xffffface
     b14:	58554143 	ldmdapl	r5, {r0, r1, r6, r8, lr}^
     b18:	5f524200 	svcpl	0x00524200
     b1c:	30303639 	eorscc	r3, r0, r9, lsr r6
     b20:	41554300 	cmpmi	r5, r0, lsl #6
     b24:	42005452 	andmi	r5, r0, #1375731712	; 0x52000000
     b28:	37355f52 			; <UNDEFINED> instruction: 0x37355f52
     b2c:	00303036 	eorseq	r3, r0, r6, lsr r0
     b30:	636f6c43 	cmnvs	pc, #17152	; 0x4300
     b34:	61525f6b 	cmpvs	r2, fp, ror #30
     b38:	57006574 	smlsdxpl	r0, r4, r5, r6
     b3c:	65746972 	ldrbvs	r6, [r4, #-2418]!	; 0xfffff68e
     b40:	61684300 	cmnvs	r8, r0, lsl #6
     b44:	00375f72 	eorseq	r5, r7, r2, ror pc
     b48:	72616843 	rsbvc	r6, r1, #4390912	; 0x430000
     b4c:	6d00385f 	stcvs	8, cr3, [r0, #-380]	; 0xfffffe84
     b50:	00585541 	subseq	r5, r8, r1, asr #10
     b54:	4f4c475f 	svcmi	0x004c475f
     b58:	5f4c4142 	svcpl	0x004c4142
     b5c:	6275735f 	rsbsvs	r7, r5, #2080374785	; 0x7c000001
     b60:	735f495f 	cmpvc	pc, #1556480	; 0x17c000
     b64:	54524155 	ldrbpl	r4, [r2], #-341	; 0xfffffeab
     b68:	5a5f0030 	bpl	17c0c30 <_bss_end+0x17b7514>
     b6c:	5543354e 	strbpl	r3, [r3, #-1358]	; 0xfffffab2
     b70:	35545241 	ldrbcc	r5, [r4, #-577]	; 0xfffffdbf
     b74:	74697257 	strbtvc	r7, [r9], #-599	; 0xfffffda9
     b78:	4b504565 	blmi	1412114 <_bss_end+0x14089f8>
     b7c:	52420063 	subpl	r0, r2, #99	; 0x63
     b80:	3032315f 	eorscc	r3, r2, pc, asr r1
     b84:	6d2f0030 	stcvs	0, cr0, [pc, #-192]!	; acc <shift+0xacc>
     b88:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
     b8c:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
     b90:	4b2f7372 	blmi	bdd960 <_bss_end+0xbd4244>
     b94:	2f616275 	svccs	0x00616275
     b98:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
     b9c:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
     ba0:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
     ba4:	614d6f72 	hvcvs	55026	; 0xd6f2
     ba8:	652f6574 	strvs	r6, [pc, #-1396]!	; 63c <shift+0x63c>
     bac:	706d6178 	rsbvc	r6, sp, r8, ror r1
     bb0:	2f73656c 	svccs	0x0073656c
     bb4:	552d3831 	strpl	r3, [sp, #-2097]!	; 0xfffff7cf
     bb8:	2f545241 	svccs	0x00545241
     bbc:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
     bc0:	732f6c65 			; <UNDEFINED> instruction: 0x732f6c65
     bc4:	642f6372 	strtvs	r6, [pc], #-882	; bcc <shift+0xbcc>
     bc8:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
     bcc:	752f7372 	strvc	r7, [pc, #-882]!	; 862 <shift+0x862>
     bd0:	2e747261 	cdpcs	2, 7, cr7, cr4, cr1, {3}
     bd4:	00707063 	rsbseq	r7, r0, r3, rrx
     bd8:	354e5a5f 	strbcc	r5, [lr, #-2655]	; 0xfffff5a1
     bdc:	52415543 	subpl	r5, r1, #281018368	; 0x10c00000
     be0:	72573554 	subsvc	r3, r7, #84, 10	; 0x15000000
     be4:	45657469 	strbmi	r7, [r5, #-1129]!	; 0xfffffb97
     be8:	5a5f0063 	bpl	17c0d7c <_bss_end+0x17b7660>
     bec:	5543354e 	strbpl	r3, [r3, #-1358]	; 0xfffffab2
     bf0:	43545241 	cmpmi	r4, #268435460	; 0x10000004
     bf4:	34524534 	ldrbcc	r4, [r2], #-1332	; 0xfffffacc
     bf8:	58554143 	ldmdapl	r5, {r0, r1, r6, r8, lr}^
     bfc:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     c00:	41554335 	cmpmi	r5, r5, lsr r3
     c04:	35315452 	ldrcc	r5, [r1, #-1106]!	; 0xfffffbae
     c08:	5f746553 	svcpl	0x00746553
     c0c:	72616843 	rsbvc	r6, r1, #4390912	; 0x430000
     c10:	6e654c5f 	mcrvs	12, 3, r4, cr5, cr15, {2}
     c14:	45687467 	strbmi	r7, [r8, #-1127]!	; 0xfffffb99
     c18:	554e3731 	strbpl	r3, [lr, #-1841]	; 0xfffff8cf
     c1c:	5f545241 	svcpl	0x00545241
     c20:	72616843 	rsbvc	r6, r1, #4390912	; 0x430000
     c24:	6e654c5f 	mcrvs	12, 3, r4, cr5, cr15, {2}
     c28:	00687467 	rsbeq	r7, r8, r7, ror #8
     c2c:	5f746553 	svcpl	0x00746553
     c30:	72616843 	rsbvc	r6, r1, #4390912	; 0x430000
     c34:	6e654c5f 	mcrvs	12, 3, r4, cr5, cr15, {2}
     c38:	00687467 	rsbeq	r7, r8, r7, ror #8
     c3c:	65746172 	ldrbvs	r6, [r4, #-370]!	; 0xfffffe8e
     c40:	5f524200 	svcpl	0x00524200
     c44:	30323931 	eorscc	r3, r2, r1, lsr r9
     c48:	52420030 	subpl	r0, r2, #48	; 0x30
     c4c:	3038345f 	eorscc	r3, r8, pc, asr r4
     c50:	65530030 	ldrbvs	r0, [r3, #-48]	; 0xffffffd0
     c54:	61425f74 	hvcvs	9716	; 0x25f4
     c58:	525f6475 	subspl	r6, pc, #1962934272	; 0x75000000
     c5c:	00657461 	rsbeq	r7, r5, r1, ror #8
     c60:	354e5a5f 	strbcc	r5, [lr, #-2655]	; 0xfffff5a1
     c64:	52415543 	subpl	r5, r1, #281018368	; 0x10c00000
     c68:	53333154 	teqpl	r3, #84, 2
     c6c:	425f7465 	subsmi	r7, pc, #1694498816	; 0x65000000
     c70:	5f647561 	svcpl	0x00647561
     c74:	65746152 	ldrbvs	r6, [r4, #-338]!	; 0xfffffeae
     c78:	4e353145 	rsfmism	f3, f5, f5
     c7c:	54524155 	ldrbpl	r4, [r2], #-341	; 0xfffffeab
     c80:	7561425f 	strbvc	r4, [r1, #-607]!	; 0xfffffda1
     c84:	61525f64 	cmpvs	r2, r4, ror #30
     c88:	42006574 	andmi	r6, r0, #116, 10	; 0x1d000000
     c8c:	34325f52 	ldrtcc	r5, [r2], #-3922	; 0xfffff0ae
     c90:	2f003030 	svccs	0x00003030
     c94:	2f746e6d 	svccs	0x00746e6d
     c98:	73552f63 	cmpvc	r5, #396	; 0x18c
     c9c:	2f737265 	svccs	0x00737265
     ca0:	6162754b 	cmnvs	r2, fp, asr #10
     ca4:	636f442f 	cmnvs	pc, #788529152	; 0x2f000000
     ca8:	6e656d75 	mcrvs	13, 3, r6, cr5, cr5, {3}
     cac:	5a2f7374 	bpl	bdda84 <_bss_end+0xbd4368>
     cb0:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; b24 <shift+0xb24>
     cb4:	2f657461 	svccs	0x00657461
     cb8:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
     cbc:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
     cc0:	2d38312f 	ldfcss	f3, [r8, #-188]!	; 0xffffff44
     cc4:	54524155 	ldrbpl	r4, [r2], #-341	; 0xfffffeab
     cc8:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
     ccc:	2f6c656e 	svccs	0x006c656e
     cd0:	2f637273 	svccs	0x00637273
     cd4:	6e69616d 	powvsez	f6, f1, #5.0
     cd8:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
     cdc:	656b5f00 	strbvs	r5, [fp, #-3840]!	; 0xfffff100
     ce0:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
     ce4:	69616d5f 	stmdbvs	r1!, {r0, r1, r2, r3, r4, r6, r8, sl, fp, sp, lr}^
     ce8:	6d2f006e 	stcvs	0, cr0, [pc, #-440]!	; b38 <shift+0xb38>
     cec:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
     cf0:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
     cf4:	4b2f7372 	blmi	bddac4 <_bss_end+0xbd43a8>
     cf8:	2f616275 	svccs	0x00616275
     cfc:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
     d00:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
     d04:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
     d08:	614d6f72 	hvcvs	55026	; 0xd6f2
     d0c:	652f6574 	strvs	r6, [pc, #-1396]!	; 7a0 <shift+0x7a0>
     d10:	706d6178 	rsbvc	r6, sp, r8, ror r1
     d14:	2f73656c 	svccs	0x0073656c
     d18:	552d3831 	strpl	r3, [sp, #-2097]!	; 0xfffff7cf
     d1c:	2f545241 	svccs	0x00545241
     d20:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
     d24:	732f6c65 			; <UNDEFINED> instruction: 0x732f6c65
     d28:	732f6372 			; <UNDEFINED> instruction: 0x732f6372
     d2c:	74726174 	ldrbtvc	r6, [r2], #-372	; 0xfffffe8c
     d30:	4700732e 	strmi	r7, [r0, -lr, lsr #6]
     d34:	4120554e 			; <UNDEFINED> instruction: 0x4120554e
     d38:	2e322053 	mrccs	0, 1, r2, cr2, cr3, {2}
     d3c:	2f003833 	svccs	0x00003833
     d40:	2f746e6d 	svccs	0x00746e6d
     d44:	73552f63 	cmpvc	r5, #396	; 0x18c
     d48:	2f737265 	svccs	0x00737265
     d4c:	6162754b 	cmnvs	r2, fp, asr #10
     d50:	636f442f 	cmnvs	pc, #788529152	; 0x2f000000
     d54:	6e656d75 	mcrvs	13, 3, r6, cr5, cr5, {3}
     d58:	5a2f7374 	bpl	bddb30 <_bss_end+0xbd4414>
     d5c:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; bd0 <shift+0xbd0>
     d60:	2f657461 	svccs	0x00657461
     d64:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
     d68:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
     d6c:	2d38312f 	ldfcss	f3, [r8, #-188]!	; 0xffffff44
     d70:	54524155 	ldrbpl	r4, [r2], #-341	; 0xfffffeab
     d74:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
     d78:	2f6c656e 	svccs	0x006c656e
     d7c:	2f637273 	svccs	0x00637273
     d80:	72617473 	rsbvc	r7, r1, #1929379840	; 0x73000000
     d84:	2e707574 	mrccs	5, 3, r7, cr0, cr4, {3}
     d88:	00707063 	rsbseq	r7, r0, r3, rrx
     d8c:	7373625f 	cmnvc	r3, #-268435451	; 0xf0000005
     d90:	6174735f 	cmnvs	r4, pc, asr r3
     d94:	66007472 			; <UNDEFINED> instruction: 0x66007472
     d98:	7274706e 	rsbsvc	r7, r4, #110	; 0x6e
     d9c:	435f5f00 	cmpmi	pc, #0, 30
     da0:	5f524f54 	svcpl	0x00524f54
     da4:	5f444e45 	svcpl	0x00444e45
     da8:	5f5f005f 	svcpl	0x005f005f
     dac:	524f5443 	subpl	r5, pc, #1124073472	; 0x43000000
     db0:	53494c5f 	movtpl	r4, #40031	; 0x9c5f
     db4:	005f5f54 	subseq	r5, pc, r4, asr pc	; <UNPREDICTABLE>
     db8:	54445f5f 	strbpl	r5, [r4], #-3935	; 0xfffff0a1
     dbc:	455f524f 	ldrbmi	r5, [pc, #-591]	; b75 <shift+0xb75>
     dc0:	5f5f444e 	svcpl	0x005f444e
     dc4:	70635f00 	rsbvc	r5, r3, r0, lsl #30
     dc8:	68735f70 	ldmdavs	r3!, {r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     dcc:	6f647475 	svcvs	0x00647475
     dd0:	5f006e77 	svcpl	0x00006e77
     dd4:	5f737362 	svcpl	0x00737362
     dd8:	00646e65 	rsbeq	r6, r4, r5, ror #28
     ddc:	54445f5f 	strbpl	r5, [r4], #-3935	; 0xfffff0a1
     de0:	4c5f524f 	lfmmi	f5, 2, [pc], {79}	; 0x4f
     de4:	5f545349 	svcpl	0x00545349
     de8:	7463005f 	strbtvc	r0, [r3], #-95	; 0xffffffa1
     dec:	705f726f 	subsvc	r7, pc, pc, ror #4
     df0:	5f007274 	svcpl	0x00007274
     df4:	74735f63 	ldrbtvc	r5, [r3], #-3939	; 0xfffff09d
     df8:	75747261 	ldrbvc	r7, [r4, #-609]!	; 0xfffffd9f
     dfc:	635f0070 	cmpvs	pc, #112	; 0x70
     e00:	735f7070 	cmpvc	pc, #112	; 0x70
     e04:	74726174 	ldrbtvc	r6, [r2], #-372	; 0xfffffe8c
     e08:	64007075 	strvs	r7, [r0], #-117	; 0xffffff8b
     e0c:	5f726f74 	svcpl	0x00726f74
     e10:	00727470 	rsbseq	r7, r2, r0, ror r4
     e14:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     e18:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     e1c:	2f2e2e2f 	svccs	0x002e2e2f
     e20:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     e24:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
     e28:	63636762 	cmnvs	r3, #25690112	; 0x1880000
     e2c:	6e6f632f 	cdpvs	3, 6, cr6, cr15, cr15, {1}
     e30:	2f676966 	svccs	0x00676966
     e34:	2f6d7261 	svccs	0x006d7261
     e38:	3162696c 	cmncc	r2, ip, ror #18
     e3c:	636e7566 	cmnvs	lr, #427819008	; 0x19800000
     e40:	00532e73 	subseq	r2, r3, r3, ror lr
     e44:	6975622f 	ldmdbvs	r5!, {r0, r1, r2, r3, r5, r9, sp, lr}^
     e48:	672f646c 	strvs	r6, [pc, -ip, ror #8]!
     e4c:	612d6363 			; <UNDEFINED> instruction: 0x612d6363
     e50:	6e2d6d72 	mcrvs	13, 1, r6, cr13, cr2, {3}
     e54:	2d656e6f 	stclcs	14, cr6, [r5, #-444]!	; 0xfffffe44
     e58:	69626165 	stmdbvs	r2!, {r0, r2, r5, r6, r8, sp, lr}^
     e5c:	6659682d 	ldrbvs	r6, [r9], -sp, lsr #16
     e60:	2f344b67 	svccs	0x00344b67
     e64:	2d636367 	stclcs	3, cr6, [r3, #-412]!	; 0xfffffe64
     e68:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
     e6c:	656e6f6e 	strbvs	r6, [lr, #-3950]!	; 0xfffff092
     e70:	6261652d 	rsbvs	r6, r1, #188743680	; 0xb400000
     e74:	30312d69 	eorscc	r2, r1, r9, ror #26
     e78:	322d332e 	eorcc	r3, sp, #-1207959552	; 0xb8000000
     e7c:	2e313230 	mrccs	2, 1, r3, cr1, cr0, {1}
     e80:	622f3730 	eorvs	r3, pc, #48, 14	; 0xc00000
     e84:	646c6975 	strbtvs	r6, [ip], #-2421	; 0xfffff68b
     e88:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
     e8c:	6e6f6e2d 	cdpvs	14, 6, cr6, cr15, cr13, {1}
     e90:	61652d65 	cmnvs	r5, r5, ror #26
     e94:	612f6962 			; <UNDEFINED> instruction: 0x612f6962
     e98:	762f6d72 			; <UNDEFINED> instruction: 0x762f6d72
     e9c:	2f657435 	svccs	0x00657435
     ea0:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
     ea4:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
     ea8:	00636367 	rsbeq	r6, r3, r7, ror #6
     eac:	20554e47 	subscs	r4, r5, r7, asr #28
     eb0:	32205341 	eorcc	r5, r0, #67108865	; 0x4000001
     eb4:	0037332e 	eorseq	r3, r7, lr, lsr #6
     eb8:	5f617369 	svcpl	0x00617369
     ebc:	5f746962 	svcpl	0x00746962
     ec0:	64657270 	strbtvs	r7, [r5], #-624	; 0xfffffd90
     ec4:	00736572 	rsbseq	r6, r3, r2, ror r5
     ec8:	5f617369 	svcpl	0x00617369
     ecc:	5f746962 	svcpl	0x00746962
     ed0:	5f706676 	svcpl	0x00706676
     ed4:	65736162 	ldrbvs	r6, [r3, #-354]!	; 0xfffffe9e
     ed8:	6d6f6300 	stclvs	3, cr6, [pc, #-0]	; ee0 <shift+0xee0>
     edc:	78656c70 	stmdavc	r5!, {r4, r5, r6, sl, fp, sp, lr}^
     ee0:	6f6c6620 	svcvs	0x006c6620
     ee4:	69007461 	stmdbvs	r0, {r0, r5, r6, sl, ip, sp, lr}
     ee8:	6e5f6173 	mrcvs	1, 2, r6, cr15, cr3, {3}
     eec:	7469626f 	strbtvc	r6, [r9], #-623	; 0xfffffd91
     ef0:	61736900 	cmnvs	r3, r0, lsl #18
     ef4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
     ef8:	65766d5f 	ldrbvs	r6, [r6, #-3423]!	; 0xfffff2a1
     efc:	6f6c665f 	svcvs	0x006c665f
     f00:	69007461 	stmdbvs	r0, {r0, r5, r6, sl, ip, sp, lr}
     f04:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
     f08:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
     f0c:	00363170 	eorseq	r3, r6, r0, ror r1
     f10:	5f617369 	svcpl	0x00617369
     f14:	5f746962 	svcpl	0x00746962
     f18:	00636573 	rsbeq	r6, r3, r3, ror r5
     f1c:	5f617369 	svcpl	0x00617369
     f20:	5f746962 	svcpl	0x00746962
     f24:	76696461 	strbtvc	r6, [r9], -r1, ror #8
     f28:	61736900 	cmnvs	r3, r0, lsl #18
     f2c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
     f30:	6975715f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, r8, ip, sp, lr}^
     f34:	6e5f6b72 	vmovvs.s8	r6, d15[3]
     f38:	6f765f6f 	svcvs	0x00765f6f
     f3c:	6974616c 	ldmdbvs	r4!, {r2, r3, r5, r6, r8, sp, lr}^
     f40:	635f656c 	cmpvs	pc, #108, 10	; 0x1b000000
     f44:	73690065 	cmnvc	r9, #101	; 0x65
     f48:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
     f4c:	706d5f74 	rsbvc	r5, sp, r4, ror pc
     f50:	61736900 	cmnvs	r3, r0, lsl #18
     f54:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
     f58:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
     f5c:	00743576 	rsbseq	r3, r4, r6, ror r5
     f60:	5f617369 	svcpl	0x00617369
     f64:	5f746962 	svcpl	0x00746962
     f68:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
     f6c:	00657435 	rsbeq	r7, r5, r5, lsr r4
     f70:	5f617369 	svcpl	0x00617369
     f74:	5f746962 	svcpl	0x00746962
     f78:	6e6f656e 	cdpvs	5, 6, cr6, cr15, cr14, {3}
     f7c:	61736900 	cmnvs	r3, r0, lsl #18
     f80:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
     f84:	3166625f 	cmncc	r6, pc, asr r2
     f88:	50460036 	subpl	r0, r6, r6, lsr r0
     f8c:	5f524353 	svcpl	0x00524353
     f90:	4d554e45 	ldclmi	14, cr4, [r5, #-276]	; 0xfffffeec
     f94:	53504600 	cmppl	r0, #0, 12
     f98:	6e5f5243 	cdpvs	2, 5, cr5, cr15, cr3, {2}
     f9c:	7176637a 	cmnvc	r6, sl, ror r3
     fa0:	4e455f63 	cdpmi	15, 4, cr5, cr5, cr3, {3}
     fa4:	56004d55 			; <UNDEFINED> instruction: 0x56004d55
     fa8:	455f5250 	ldrbmi	r5, [pc, #-592]	; d60 <shift+0xd60>
     fac:	004d554e 	subeq	r5, sp, lr, asr #10
     fb0:	74696266 	strbtvc	r6, [r9], #-614	; 0xfffffd9a
     fb4:	706d695f 	rsbvc	r6, sp, pc, asr r9
     fb8:	6163696c 	cmnvs	r3, ip, ror #18
     fbc:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     fc0:	5f305000 	svcpl	0x00305000
     fc4:	4d554e45 	ldclmi	14, cr4, [r5, #-276]	; 0xfffffeec
     fc8:	61736900 	cmnvs	r3, r0, lsl #18
     fcc:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
     fd0:	7972635f 	ldmdbvc	r2!, {r0, r1, r2, r3, r4, r6, r8, r9, sp, lr}^
     fd4:	006f7470 	rsbeq	r7, pc, r0, ror r4	; <UNPREDICTABLE>
     fd8:	20554e47 	subscs	r4, r5, r7, asr #28
     fdc:	20373143 	eorscs	r3, r7, r3, asr #2
     fe0:	332e3031 			; <UNDEFINED> instruction: 0x332e3031
     fe4:	3220312e 	eorcc	r3, r0, #-2147483637	; 0x8000000b
     fe8:	30313230 	eorscc	r3, r1, r0, lsr r2
     fec:	20313236 	eorscs	r3, r1, r6, lsr r2
     ff0:	6c657228 	sfmvs	f7, 2, [r5], #-160	; 0xffffff60
     ff4:	65736165 	ldrbvs	r6, [r3, #-357]!	; 0xfffffe9b
     ff8:	6d2d2029 	stcvs	0, cr2, [sp, #-164]!	; 0xffffff5c
     ffc:	206d7261 	rsbcs	r7, sp, r1, ror #4
    1000:	6c666d2d 	stclvs	13, cr6, [r6], #-180	; 0xffffff4c
    1004:	2d74616f 	ldfcse	f6, [r4, #-444]!	; 0xfffffe44
    1008:	3d696261 	sfmcc	f6, 2, [r9, #-388]!	; 0xfffffe7c
    100c:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
    1010:	616d2d20 	cmnvs	sp, r0, lsr #26
    1014:	3d686372 	stclcc	3, cr6, [r8, #-456]!	; 0xfffffe38
    1018:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    101c:	2b657435 	blcs	195e0f8 <_bss_end+0x19549dc>
    1020:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
    1024:	672d2067 	strvs	r2, [sp, -r7, rrx]!
    1028:	20672d20 	rsbcs	r2, r7, r0, lsr #26
    102c:	20324f2d 	eorscs	r4, r2, sp, lsr #30
    1030:	20324f2d 	eorscs	r4, r2, sp, lsr #30
    1034:	20324f2d 	eorscs	r4, r2, sp, lsr #30
    1038:	7562662d 	strbvc	r6, [r2, #-1581]!	; 0xfffff9d3
    103c:	69646c69 	stmdbvs	r4!, {r0, r3, r5, r6, sl, fp, sp, lr}^
    1040:	6c2d676e 	stcvs	7, cr6, [sp], #-440	; 0xfffffe48
    1044:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1048:	662d2063 	strtvs	r2, [sp], -r3, rrx
    104c:	732d6f6e 			; <UNDEFINED> instruction: 0x732d6f6e
    1050:	6b636174 	blvs	18d9628 <_bss_end+0x18cff0c>
    1054:	6f72702d 	svcvs	0x0072702d
    1058:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
    105c:	2d20726f 	sfmcs	f7, 4, [r0, #-444]!	; 0xfffffe44
    1060:	2d6f6e66 	stclcs	14, cr6, [pc, #-408]!	; ed0 <shift+0xed0>
    1064:	696c6e69 	stmdbvs	ip!, {r0, r3, r5, r6, r9, sl, fp, sp, lr}^
    1068:	2d20656e 	cfstr32cs	mvfx6, [r0, #-440]!	; 0xfffffe48
    106c:	73697666 	cmnvc	r9, #106954752	; 0x6600000
    1070:	6c696269 	sfmvs	f6, 2, [r9], #-420	; 0xfffffe5c
    1074:	3d797469 	cfldrdcc	mvd7, [r9, #-420]!	; 0xfffffe5c
    1078:	64646968 	strbtvs	r6, [r4], #-2408	; 0xfffff698
    107c:	69006e65 	stmdbvs	r0, {r0, r2, r5, r6, r9, sl, fp, sp, lr}
    1080:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1084:	745f7469 	ldrbvc	r7, [pc], #-1129	; 108c <shift+0x108c>
    1088:	00766964 	rsbseq	r6, r6, r4, ror #18
    108c:	736e6f63 	cmnvc	lr, #396	; 0x18c
    1090:	61736900 	cmnvs	r3, r0, lsl #18
    1094:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1098:	6d77695f 			; <UNDEFINED> instruction: 0x6d77695f
    109c:	0074786d 	rsbseq	r7, r4, sp, ror #16
    10a0:	58435046 	stmdapl	r3, {r1, r2, r6, ip, lr}^
    10a4:	455f5354 	ldrbmi	r5, [pc, #-852]	; d58 <shift+0xd58>
    10a8:	004d554e 	subeq	r5, sp, lr, asr #10
    10ac:	5f617369 	svcpl	0x00617369
    10b0:	5f746962 	svcpl	0x00746962
    10b4:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    10b8:	73690036 	cmnvc	r9, #54	; 0x36
    10bc:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    10c0:	766d5f74 	uqsub16vc	r5, sp, r4
    10c4:	73690065 	cmnvc	r9, #101	; 0x65
    10c8:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    10cc:	77695f74 			; <UNDEFINED> instruction: 0x77695f74
    10d0:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
    10d4:	73690032 	cmnvc	r9, #50	; 0x32
    10d8:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    10dc:	64635f74 	strbtvs	r5, [r3], #-3956	; 0xfffff08c
    10e0:	30706365 	rsbscc	r6, r0, r5, ror #6
    10e4:	61736900 	cmnvs	r3, r0, lsl #18
    10e8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    10ec:	6564635f 	strbvs	r6, [r4, #-863]!	; 0xfffffca1
    10f0:	00317063 	eorseq	r7, r1, r3, rrx
    10f4:	5f617369 	svcpl	0x00617369
    10f8:	5f746962 	svcpl	0x00746962
    10fc:	63656463 	cmnvs	r5, #1660944384	; 0x63000000
    1100:	69003270 	stmdbvs	r0, {r4, r5, r6, r9, ip, sp}
    1104:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1108:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    110c:	70636564 	rsbvc	r6, r3, r4, ror #10
    1110:	73690033 	cmnvc	r9, #51	; 0x33
    1114:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1118:	64635f74 	strbtvs	r5, [r3], #-3956	; 0xfffff08c
    111c:	34706365 	ldrbtcc	r6, [r0], #-869	; 0xfffffc9b
    1120:	61736900 	cmnvs	r3, r0, lsl #18
    1124:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1128:	5f70665f 	svcpl	0x0070665f
    112c:	006c6264 	rsbeq	r6, ip, r4, ror #4
    1130:	5f617369 	svcpl	0x00617369
    1134:	5f746962 	svcpl	0x00746962
    1138:	63656463 	cmnvs	r5, #1660944384	; 0x63000000
    113c:	69003670 	stmdbvs	r0, {r4, r5, r6, r9, sl, ip, sp}
    1140:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1144:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    1148:	70636564 	rsbvc	r6, r3, r4, ror #10
    114c:	73690037 	cmnvc	r9, #55	; 0x37
    1150:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1154:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1158:	6b36766d 	blvs	d9eb14 <_bss_end+0xd953f8>
    115c:	61736900 	cmnvs	r3, r0, lsl #18
    1160:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1164:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1168:	315f3876 	cmpcc	pc, r6, ror r8	; <UNPREDICTABLE>
    116c:	616d5f6d 	cmnvs	sp, sp, ror #30
    1170:	61006e69 	tstvs	r0, r9, ror #28
    1174:	0065746e 	rsbeq	r7, r5, lr, ror #8
    1178:	5f617369 	svcpl	0x00617369
    117c:	5f746962 	svcpl	0x00746962
    1180:	65736d63 	ldrbvs	r6, [r3, #-3427]!	; 0xfffff29d
    1184:	6e6f6c00 	cdpvs	12, 6, cr6, cr15, cr0, {0}
    1188:	6f642067 	svcvs	0x00642067
    118c:	656c6275 	strbvs	r6, [ip, #-629]!	; 0xfffffd8b
    1190:	2f2e2e00 	svccs	0x002e2e00
    1194:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1198:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    119c:	2f2e2e2f 	svccs	0x002e2e2f
    11a0:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 10f0 <shift+0x10f0>
    11a4:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    11a8:	696c2f63 	stmdbvs	ip!, {r0, r1, r5, r6, r8, r9, sl, fp, sp}^
    11ac:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    11b0:	00632e32 	rsbeq	r2, r3, r2, lsr lr
    11b4:	5f617369 	svcpl	0x00617369
    11b8:	5f746962 	svcpl	0x00746962
    11bc:	35767066 	ldrbcc	r7, [r6, #-102]!	; 0xffffff9a
    11c0:	61736900 	cmnvs	r3, r0, lsl #18
    11c4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    11c8:	6373785f 	cmnvs	r3, #6225920	; 0x5f0000
    11cc:	00656c61 	rsbeq	r6, r5, r1, ror #24
    11d0:	676e6f6c 	strbvs	r6, [lr, -ip, ror #30]!
    11d4:	6e6f6c20 	cdpvs	12, 6, cr6, cr15, cr0, {1}
    11d8:	6e752067 	cdpvs	0, 7, cr2, cr5, cr7, {3}
    11dc:	6e676973 			; <UNDEFINED> instruction: 0x6e676973
    11e0:	69206465 	stmdbvs	r0!, {r0, r2, r5, r6, sl, sp, lr}
    11e4:	6900746e 	stmdbvs	r0, {r1, r2, r3, r5, r6, sl, ip, sp, lr}
    11e8:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    11ec:	715f7469 	cmpvc	pc, r9, ror #8
    11f0:	6b726975 	blvs	1c9b7cc <_bss_end+0x1c920b0>
    11f4:	336d635f 	cmncc	sp, #2080374785	; 0x7c000001
    11f8:	72646c5f 	rsbvc	r6, r4, #24320	; 0x5f00
    11fc:	73690064 	cmnvc	r9, #100	; 0x64
    1200:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1204:	38695f74 	stmdacc	r9!, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    1208:	69006d6d 	stmdbvs	r0, {r0, r2, r3, r5, r6, r8, sl, fp, sp, lr}
    120c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1210:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    1214:	33645f70 	cmncc	r4, #112, 30	; 0x1c0
    1218:	73690032 	cmnvc	r9, #50	; 0x32
    121c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1220:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1224:	6537766d 	ldrvs	r7, [r7, #-1645]!	; 0xfffff993
    1228:	7369006d 	cmnvc	r9, #109	; 0x6d
    122c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1230:	706c5f74 	rsbvc	r5, ip, r4, ror pc
    1234:	61006561 	tstvs	r0, r1, ror #10
    1238:	695f6c6c 	ldmdbvs	pc, {r2, r3, r5, r6, sl, fp, sp, lr}^	; <UNPREDICTABLE>
    123c:	696c706d 	stmdbvs	ip!, {r0, r2, r3, r5, r6, ip, sp, lr}^
    1240:	665f6465 	ldrbvs	r6, [pc], -r5, ror #8
    1244:	73746962 	cmnvc	r4, #1605632	; 0x188000
    1248:	61736900 	cmnvs	r3, r0, lsl #18
    124c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1250:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1254:	315f3876 	cmpcc	pc, r6, ror r8	; <UNPREDICTABLE>
    1258:	61736900 	cmnvs	r3, r0, lsl #18
    125c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1260:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1264:	325f3876 	subscc	r3, pc, #7733248	; 0x760000
    1268:	61736900 	cmnvs	r3, r0, lsl #18
    126c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1270:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1274:	335f3876 	cmpcc	pc, #7733248	; 0x760000
    1278:	61736900 	cmnvs	r3, r0, lsl #18
    127c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1280:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1284:	345f3876 	ldrbcc	r3, [pc], #-2166	; 128c <shift+0x128c>
    1288:	61736900 	cmnvs	r3, r0, lsl #18
    128c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1290:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1294:	355f3876 	ldrbcc	r3, [pc, #-2166]	; a26 <shift+0xa26>
    1298:	61736900 	cmnvs	r3, r0, lsl #18
    129c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    12a0:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    12a4:	365f3876 			; <UNDEFINED> instruction: 0x365f3876
    12a8:	61736900 	cmnvs	r3, r0, lsl #18
    12ac:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    12b0:	0062735f 	rsbeq	r7, r2, pc, asr r3
    12b4:	5f617369 	svcpl	0x00617369
    12b8:	5f6d756e 	svcpl	0x006d756e
    12bc:	73746962 	cmnvc	r4, #1605632	; 0x188000
    12c0:	61736900 	cmnvs	r3, r0, lsl #18
    12c4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    12c8:	616d735f 	cmnvs	sp, pc, asr r3
    12cc:	756d6c6c 	strbvc	r6, [sp, #-3180]!	; 0xfffff394
    12d0:	7566006c 	strbvc	r0, [r6, #-108]!	; 0xffffff94
    12d4:	705f636e 	subsvc	r6, pc, lr, ror #6
    12d8:	63007274 	movwvs	r7, #628	; 0x274
    12dc:	6c706d6f 	ldclvs	13, cr6, [r0], #-444	; 0xfffffe44
    12e0:	64207865 	strtvs	r7, [r0], #-2149	; 0xfffff79b
    12e4:	6c62756f 	cfstr64vs	mvdx7, [r2], #-444	; 0xfffffe44
    12e8:	424e0065 	submi	r0, lr, #101	; 0x65
    12ec:	5f50465f 	svcpl	0x0050465f
    12f0:	52535953 	subspl	r5, r3, #1359872	; 0x14c000
    12f4:	00534745 	subseq	r4, r3, r5, asr #14
    12f8:	5f617369 	svcpl	0x00617369
    12fc:	5f746962 	svcpl	0x00746962
    1300:	63656463 	cmnvs	r5, #1660944384	; 0x63000000
    1304:	69003570 	stmdbvs	r0, {r4, r5, r6, r8, sl, ip, sp}
    1308:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    130c:	765f7469 	ldrbvc	r7, [pc], -r9, ror #8
    1310:	32767066 	rsbscc	r7, r6, #102	; 0x66
    1314:	61736900 	cmnvs	r3, r0, lsl #18
    1318:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    131c:	7066765f 	rsbvc	r7, r6, pc, asr r6
    1320:	69003376 	stmdbvs	r0, {r1, r2, r4, r5, r6, r8, r9, ip, sp}
    1324:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1328:	765f7469 	ldrbvc	r7, [pc], -r9, ror #8
    132c:	34767066 	ldrbtcc	r7, [r6], #-102	; 0xffffff9a
    1330:	43504600 	cmpmi	r0, #0, 12
    1334:	534e5458 	movtpl	r5, #58456	; 0xe458
    1338:	554e455f 	strbpl	r4, [lr, #-1375]	; 0xfffffaa1
    133c:	7369004d 	cmnvc	r9, #77	; 0x4d
    1340:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1344:	68745f74 	ldmdavs	r4!, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    1348:	00626d75 	rsbeq	r6, r2, r5, ror sp
    134c:	5f617369 	svcpl	0x00617369
    1350:	5f746962 	svcpl	0x00746962
    1354:	36317066 	ldrtcc	r7, [r1], -r6, rrx
    1358:	766e6f63 	strbtvc	r6, [lr], -r3, ror #30
    135c:	61736900 	cmnvs	r3, r0, lsl #18
    1360:	6165665f 	cmnvs	r5, pc, asr r6
    1364:	65727574 	ldrbvs	r7, [r2, #-1396]!	; 0xfffffa8c
    1368:	61736900 	cmnvs	r3, r0, lsl #18
    136c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1370:	746f6e5f 	strbtvc	r6, [pc], #-3679	; 1378 <shift+0x1378>
    1374:	7369006d 	cmnvc	r9, #109	; 0x6d
    1378:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    137c:	75715f74 	ldrbvc	r5, [r1, #-3956]!	; 0xfffff08c
    1380:	5f6b7269 	svcpl	0x006b7269
    1384:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1388:	007a6b36 	rsbseq	r6, sl, r6, lsr fp
    138c:	5f617369 	svcpl	0x00617369
    1390:	5f746962 	svcpl	0x00746962
    1394:	33637263 	cmncc	r3, #805306374	; 0x30000006
    1398:	73690032 	cmnvc	r9, #50	; 0x32
    139c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    13a0:	75715f74 	ldrbvc	r5, [r1, #-3956]!	; 0xfffff08c
    13a4:	5f6b7269 	svcpl	0x006b7269
    13a8:	615f6f6e 	cmpvs	pc, lr, ror #30
    13ac:	70636d73 	rsbvc	r6, r3, r3, ror sp
    13b0:	73690075 	cmnvc	r9, #117	; 0x75
    13b4:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    13b8:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    13bc:	0034766d 	eorseq	r7, r4, sp, ror #12
    13c0:	5f617369 	svcpl	0x00617369
    13c4:	5f746962 	svcpl	0x00746962
    13c8:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    13cc:	69003262 	stmdbvs	r0, {r1, r5, r6, r9, ip, sp}
    13d0:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    13d4:	625f7469 	subsvs	r7, pc, #1761607680	; 0x69000000
    13d8:	69003865 	stmdbvs	r0, {r0, r2, r5, r6, fp, ip, sp}
    13dc:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    13e0:	615f7469 	cmpvs	pc, r9, ror #8
    13e4:	37766d72 			; <UNDEFINED> instruction: 0x37766d72
    13e8:	61736900 	cmnvs	r3, r0, lsl #18
    13ec:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    13f0:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    13f4:	76003876 			; <UNDEFINED> instruction: 0x76003876
    13f8:	735f7066 	cmpvc	pc, #102	; 0x66
    13fc:	65727379 	ldrbvs	r7, [r2, #-889]!	; 0xfffffc87
    1400:	655f7367 	ldrbvs	r7, [pc, #-871]	; 10a1 <shift+0x10a1>
    1404:	646f636e 	strbtvs	r6, [pc], #-878	; 140c <shift+0x140c>
    1408:	00676e69 	rsbeq	r6, r7, r9, ror #28
    140c:	5f617369 	svcpl	0x00617369
    1410:	5f746962 	svcpl	0x00746962
    1414:	36317066 	ldrtcc	r7, [r1], -r6, rrx
    1418:	006c6d66 	rsbeq	r6, ip, r6, ror #26
    141c:	5f617369 	svcpl	0x00617369
    1420:	5f746962 	svcpl	0x00746962
    1424:	70746f64 	rsbsvc	r6, r4, r4, ror #30
    1428:	00646f72 	rsbeq	r6, r4, r2, ror pc

Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347 	bcc	10d0d24 <_bss_end+0x10c7608>
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
  10:	4b5a3605 	blmi	168d82c <_bss_end+0x1684110>
  14:	08070600 	stmdaeq	r7, {r9, sl}
  18:	0a010901 	beq	42424 <_bss_end+0x38d08>
  1c:	14041202 	strne	r1, [r4], #-514	; 0xfffffdfe
  20:	17011501 	strne	r1, [r1, -r1, lsl #10]
  24:	1a011803 	bne	46038 <_bss_end+0x3c91c>
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
  20:	8b040e42 	blhi	103930 <_bss_end+0xfa214>
  24:	0b0d4201 	bleq	350830 <_bss_end+0x347114>
  28:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
  2c:	00000ecb 	andeq	r0, r0, fp, asr #29
  30:	0000001c 	andeq	r0, r0, ip, lsl r0
  34:	00000000 	andeq	r0, r0, r0
  38:	00008050 	andeq	r8, r0, r0, asr r0
  3c:	0000002c 	andeq	r0, r0, ip, lsr #32
  40:	8b040e42 	blhi	103950 <_bss_end+0xfa234>
  44:	0b0d4201 	bleq	350850 <_bss_end+0x347134>
  48:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
  4c:	00000ecb 	andeq	r0, r0, fp, asr #29
  50:	0000001c 	andeq	r0, r0, ip, lsl r0
  54:	00000000 	andeq	r0, r0, r0
  58:	0000807c 	andeq	r8, r0, ip, ror r0
  5c:	00000020 	andeq	r0, r0, r0, lsr #32
  60:	8b040e42 	blhi	103970 <_bss_end+0xfa254>
  64:	0b0d4201 	bleq	350870 <_bss_end+0x347154>
  68:	420d0d48 	andmi	r0, sp, #72, 26	; 0x1200
  6c:	00000ecb 	andeq	r0, r0, fp, asr #29
  70:	0000001c 	andeq	r0, r0, ip, lsl r0
  74:	00000000 	andeq	r0, r0, r0
  78:	0000809c 	muleq	r0, ip, r0
  7c:	00000018 	andeq	r0, r0, r8, lsl r0
  80:	8b040e42 	blhi	103990 <_bss_end+0xfa274>
  84:	0b0d4201 	bleq	350890 <_bss_end+0x347174>
  88:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  8c:	00000ecb 	andeq	r0, r0, fp, asr #29
  90:	0000001c 	andeq	r0, r0, ip, lsl r0
  94:	00000000 	andeq	r0, r0, r0
  98:	000080b4 	strheq	r8, [r0], -r4
  9c:	00000018 	andeq	r0, r0, r8, lsl r0
  a0:	8b040e42 	blhi	1039b0 <_bss_end+0xfa294>
  a4:	0b0d4201 	bleq	3508b0 <_bss_end+0x347194>
  a8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  ac:	00000ecb 	andeq	r0, r0, fp, asr #29
  b0:	0000001c 	andeq	r0, r0, ip, lsl r0
  b4:	00000000 	andeq	r0, r0, r0
  b8:	000080cc 	andeq	r8, r0, ip, asr #1
  bc:	00000018 	andeq	r0, r0, r8, lsl r0
  c0:	8b040e42 	blhi	1039d0 <_bss_end+0xfa2b4>
  c4:	0b0d4201 	bleq	3508d0 <_bss_end+0x3471b4>
  c8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  cc:	00000ecb 	andeq	r0, r0, fp, asr #29
  d0:	00000014 	andeq	r0, r0, r4, lsl r0
  d4:	00000000 	andeq	r0, r0, r0
  d8:	000080e4 	andeq	r8, r0, r4, ror #1
  dc:	0000000c 	andeq	r0, r0, ip
  e0:	8b040e42 	blhi	1039f0 <_bss_end+0xfa2d4>
  e4:	0b0d4201 	bleq	3508f0 <_bss_end+0x3471d4>
  e8:	0000000c 	andeq	r0, r0, ip
  ec:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  f0:	7c020001 	stcvc	0, cr0, [r2], {1}
  f4:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  f8:	0000001c 	andeq	r0, r0, ip, lsl r0
  fc:	000000e8 	andeq	r0, r0, r8, ror #1
 100:	000080f0 	strdeq	r8, [r0], -r0
 104:	00000034 	andeq	r0, r0, r4, lsr r0
 108:	8b040e42 	blhi	103a18 <_bss_end+0xfa2fc>
 10c:	0b0d4201 	bleq	350918 <_bss_end+0x3471fc>
 110:	420d0d52 	andmi	r0, sp, #5248	; 0x1480
 114:	00000ecb 	andeq	r0, r0, fp, asr #29
 118:	0000001c 	andeq	r0, r0, ip, lsl r0
 11c:	000000e8 	andeq	r0, r0, r8, ror #1
 120:	00008124 	andeq	r8, r0, r4, lsr #2
 124:	00000050 	andeq	r0, r0, r0, asr r0
 128:	8b080e42 	blhi	203a38 <_bss_end+0x1fa31c>
 12c:	42018e02 	andmi	r8, r1, #2, 28
 130:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 134:	00080d0c 	andeq	r0, r8, ip, lsl #26
 138:	0000001c 	andeq	r0, r0, ip, lsl r0
 13c:	000000e8 	andeq	r0, r0, r8, ror #1
 140:	00008174 	andeq	r8, r0, r4, ror r1
 144:	00000054 	andeq	r0, r0, r4, asr r0
 148:	8b080e42 	blhi	203a58 <_bss_end+0x1fa33c>
 14c:	42018e02 	andmi	r8, r1, #2, 28
 150:	64040b0c 	strvs	r0, [r4], #-2828	; 0xfffff4f4
 154:	00080d0c 	andeq	r0, r8, ip, lsl #26
 158:	0000001c 	andeq	r0, r0, ip, lsl r0
 15c:	000000e8 	andeq	r0, r0, r8, ror #1
 160:	000081c8 	andeq	r8, r0, r8, asr #3
 164:	00000044 	andeq	r0, r0, r4, asr #32
 168:	8b040e42 	blhi	103a78 <_bss_end+0xfa35c>
 16c:	0b0d4201 	bleq	350978 <_bss_end+0x34725c>
 170:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 174:	00000ecb 	andeq	r0, r0, fp, asr #29
 178:	0000001c 	andeq	r0, r0, ip, lsl r0
 17c:	000000e8 	andeq	r0, r0, r8, ror #1
 180:	0000820c 	andeq	r8, r0, ip, lsl #4
 184:	0000003c 	andeq	r0, r0, ip, lsr r0
 188:	8b040e42 	blhi	103a98 <_bss_end+0xfa37c>
 18c:	0b0d4201 	bleq	350998 <_bss_end+0x34727c>
 190:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 194:	00000ecb 	andeq	r0, r0, fp, asr #29
 198:	0000001c 	andeq	r0, r0, ip, lsl r0
 19c:	000000e8 	andeq	r0, r0, r8, ror #1
 1a0:	00008248 	andeq	r8, r0, r8, asr #4
 1a4:	00000054 	andeq	r0, r0, r4, asr r0
 1a8:	8b080e42 	blhi	203ab8 <_bss_end+0x1fa39c>
 1ac:	42018e02 	andmi	r8, r1, #2, 28
 1b0:	5e040b0c 	vmlapl.f64	d0, d4, d12
 1b4:	00080d0c 	andeq	r0, r8, ip, lsl #26
 1b8:	00000018 	andeq	r0, r0, r8, lsl r0
 1bc:	000000e8 	andeq	r0, r0, r8, ror #1
 1c0:	0000829c 	muleq	r0, ip, r2
 1c4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1c8:	8b080e42 	blhi	203ad8 <_bss_end+0x1fa3bc>
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
 1f4:	8b040e42 	blhi	103b04 <_bss_end+0xfa3e8>
 1f8:	0b0d4201 	bleq	350a04 <_bss_end+0x3472e8>
 1fc:	420d0d52 	andmi	r0, sp, #5248	; 0x1480
 200:	00000ecb 	andeq	r0, r0, fp, asr #29
 204:	0000001c 	andeq	r0, r0, ip, lsl r0
 208:	000001d4 	ldrdeq	r0, [r0], -r4
 20c:	000082ec 	andeq	r8, r0, ip, ror #5
 210:	00000114 	andeq	r0, r0, r4, lsl r1
 214:	8b040e42 	blhi	103b24 <_bss_end+0xfa408>
 218:	0b0d4201 	bleq	350a24 <_bss_end+0x347308>
 21c:	0d0d8002 	stceq	0, cr8, [sp, #-8]
 220:	000ecb42 	andeq	ip, lr, r2, asr #22
 224:	0000001c 	andeq	r0, r0, ip, lsl r0
 228:	000001d4 	ldrdeq	r0, [r0], -r4
 22c:	00008400 	andeq	r8, r0, r0, lsl #8
 230:	00000074 	andeq	r0, r0, r4, ror r0
 234:	8b040e42 	blhi	103b44 <_bss_end+0xfa428>
 238:	0b0d4201 	bleq	350a44 <_bss_end+0x347328>
 23c:	420d0d72 	andmi	r0, sp, #7296	; 0x1c80
 240:	00000ecb 	andeq	r0, r0, fp, asr #29
 244:	0000001c 	andeq	r0, r0, ip, lsl r0
 248:	000001d4 	ldrdeq	r0, [r0], -r4
 24c:	00008474 	andeq	r8, r0, r4, ror r4
 250:	00000074 	andeq	r0, r0, r4, ror r0
 254:	8b040e42 	blhi	103b64 <_bss_end+0xfa448>
 258:	0b0d4201 	bleq	350a64 <_bss_end+0x347348>
 25c:	420d0d72 	andmi	r0, sp, #7296	; 0x1c80
 260:	00000ecb 	andeq	r0, r0, fp, asr #29
 264:	0000001c 	andeq	r0, r0, ip, lsl r0
 268:	000001d4 	ldrdeq	r0, [r0], -r4
 26c:	000084e8 	andeq	r8, r0, r8, ror #9
 270:	00000074 	andeq	r0, r0, r4, ror r0
 274:	8b040e42 	blhi	103b84 <_bss_end+0xfa468>
 278:	0b0d4201 	bleq	350a84 <_bss_end+0x347368>
 27c:	420d0d72 	andmi	r0, sp, #7296	; 0x1c80
 280:	00000ecb 	andeq	r0, r0, fp, asr #29
 284:	0000001c 	andeq	r0, r0, ip, lsl r0
 288:	000001d4 	ldrdeq	r0, [r0], -r4
 28c:	0000855c 	andeq	r8, r0, ip, asr r5
 290:	000000a0 	andeq	r0, r0, r0, lsr #1
 294:	8b080e42 	blhi	203ba4 <_bss_end+0x1fa488>
 298:	42018e02 	andmi	r8, r1, #2, 28
 29c:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 2a0:	080d0c4a 	stmdaeq	sp, {r1, r3, r6, sl, fp}
 2a4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2a8:	000001d4 	ldrdeq	r0, [r0], -r4
 2ac:	000085fc 	strdeq	r8, [r0], -ip
 2b0:	00000074 	andeq	r0, r0, r4, ror r0
 2b4:	8b080e42 	blhi	203bc4 <_bss_end+0x1fa4a8>
 2b8:	42018e02 	andmi	r8, r1, #2, 28
 2bc:	74040b0c 	strvc	r0, [r4], #-2828	; 0xfffff4f4
 2c0:	00080d0c 	andeq	r0, r8, ip, lsl #26
 2c4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2c8:	000001d4 	ldrdeq	r0, [r0], -r4
 2cc:	00008670 	andeq	r8, r0, r0, ror r6
 2d0:	000000d8 	ldrdeq	r0, [r0], -r8
 2d4:	8b080e42 	blhi	203be4 <_bss_end+0x1fa4c8>
 2d8:	42018e02 	andmi	r8, r1, #2, 28
 2dc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 2e0:	080d0c66 	stmdaeq	sp, {r1, r2, r5, r6, sl, fp}
 2e4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2e8:	000001d4 	ldrdeq	r0, [r0], -r4
 2ec:	00008748 	andeq	r8, r0, r8, asr #14
 2f0:	00000054 	andeq	r0, r0, r4, asr r0
 2f4:	8b080e42 	blhi	203c04 <_bss_end+0x1fa4e8>
 2f8:	42018e02 	andmi	r8, r1, #2, 28
 2fc:	5e040b0c 	vmlapl.f64	d0, d4, d12
 300:	00080d0c 	andeq	r0, r8, ip, lsl #26
 304:	00000018 	andeq	r0, r0, r8, lsl r0
 308:	000001d4 	ldrdeq	r0, [r0], -r4
 30c:	0000879c 	muleq	r0, ip, r7
 310:	0000001c 	andeq	r0, r0, ip, lsl r0
 314:	8b080e42 	blhi	203c24 <_bss_end+0x1fa508>
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
 340:	8b040e42 	blhi	103c50 <_bss_end+0xfa534>
 344:	0b0d4201 	bleq	350b50 <_bss_end+0x347434>
 348:	420d0d74 	andmi	r0, sp, #116, 26	; 0x1d00
 34c:	00000ecb 	andeq	r0, r0, fp, asr #29
 350:	0000001c 	andeq	r0, r0, ip, lsl r0
 354:	00000320 	andeq	r0, r0, r0, lsr #6
 358:	00008e00 	andeq	r8, r0, r0, lsl #28
 35c:	00000038 	andeq	r0, r0, r8, lsr r0
 360:	8b040e42 	blhi	103c70 <_bss_end+0xfa554>
 364:	0b0d4201 	bleq	350b70 <_bss_end+0x347454>
 368:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
 36c:	00000ecb 	andeq	r0, r0, fp, asr #29
 370:	0000001c 	andeq	r0, r0, ip, lsl r0
 374:	00000320 	andeq	r0, r0, r0, lsr #6
 378:	00008830 	andeq	r8, r0, r0, lsr r8
 37c:	000000a8 	andeq	r0, r0, r8, lsr #1
 380:	8b080e42 	blhi	203c90 <_bss_end+0x1fa574>
 384:	42018e02 	andmi	r8, r1, #2, 28
 388:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 38c:	080d0c4e 	stmdaeq	sp, {r1, r2, r3, r6, sl, fp}
 390:	0000001c 	andeq	r0, r0, ip, lsl r0
 394:	00000320 	andeq	r0, r0, r0, lsr #6
 398:	00008e38 	andeq	r8, r0, r8, lsr lr
 39c:	00000088 	andeq	r0, r0, r8, lsl #1
 3a0:	8b080e42 	blhi	203cb0 <_bss_end+0x1fa594>
 3a4:	42018e02 	andmi	r8, r1, #2, 28
 3a8:	7e040b0c 	vmlavc.f64	d0, d4, d12
 3ac:	00080d0c 	andeq	r0, r8, ip, lsl #26
 3b0:	0000001c 	andeq	r0, r0, ip, lsl r0
 3b4:	00000320 	andeq	r0, r0, r0, lsr #6
 3b8:	000088d8 	ldrdeq	r8, [r0], -r8	; <UNPREDICTABLE>
 3bc:	00000130 	andeq	r0, r0, r0, lsr r1
 3c0:	8b040e42 	blhi	103cd0 <_bss_end+0xfa5b4>
 3c4:	0b0d4201 	bleq	350bd0 <_bss_end+0x3474b4>
 3c8:	0d0d9002 	stceq	0, cr9, [sp, #-8]
 3cc:	000ecb42 	andeq	ip, lr, r2, asr #22
 3d0:	0000001c 	andeq	r0, r0, ip, lsl r0
 3d4:	00000320 	andeq	r0, r0, r0, lsr #6
 3d8:	00008ec0 	andeq	r8, r0, r0, asr #29
 3dc:	0000002c 	andeq	r0, r0, ip, lsr #32
 3e0:	8b040e42 	blhi	103cf0 <_bss_end+0xfa5d4>
 3e4:	0b0d4201 	bleq	350bf0 <_bss_end+0x3474d4>
 3e8:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 3ec:	00000ecb 	andeq	r0, r0, fp, asr #29
 3f0:	0000001c 	andeq	r0, r0, ip, lsl r0
 3f4:	00000320 	andeq	r0, r0, r0, lsr #6
 3f8:	00008a08 	andeq	r8, r0, r8, lsl #20
 3fc:	000000a8 	andeq	r0, r0, r8, lsr #1
 400:	8b080e42 	blhi	203d10 <_bss_end+0x1fa5f4>
 404:	42018e02 	andmi	r8, r1, #2, 28
 408:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 40c:	080d0c4e 	stmdaeq	sp, {r1, r2, r3, r6, sl, fp}
 410:	0000001c 	andeq	r0, r0, ip, lsl r0
 414:	00000320 	andeq	r0, r0, r0, lsr #6
 418:	00008ab0 			; <UNDEFINED> instruction: 0x00008ab0
 41c:	00000078 	andeq	r0, r0, r8, ror r0
 420:	8b080e42 	blhi	203d30 <_bss_end+0x1fa614>
 424:	42018e02 	andmi	r8, r1, #2, 28
 428:	76040b0c 	strvc	r0, [r4], -ip, lsl #22
 42c:	00080d0c 	andeq	r0, r8, ip, lsl #26
 430:	0000001c 	andeq	r0, r0, ip, lsl r0
 434:	00000320 	andeq	r0, r0, r0, lsr #6
 438:	00008b28 	andeq	r8, r0, r8, lsr #22
 43c:	00000034 	andeq	r0, r0, r4, lsr r0
 440:	8b040e42 	blhi	103d50 <_bss_end+0xfa634>
 444:	0b0d4201 	bleq	350c50 <_bss_end+0x347534>
 448:	420d0d52 	andmi	r0, sp, #5248	; 0x1480
 44c:	00000ecb 	andeq	r0, r0, fp, asr #29
 450:	0000001c 	andeq	r0, r0, ip, lsl r0
 454:	00000320 	andeq	r0, r0, r0, lsr #6
 458:	00008b5c 	andeq	r8, r0, ip, asr fp
 45c:	00000054 	andeq	r0, r0, r4, asr r0
 460:	8b080e42 	blhi	203d70 <_bss_end+0x1fa654>
 464:	42018e02 	andmi	r8, r1, #2, 28
 468:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 46c:	00080d0c 	andeq	r0, r8, ip, lsl #26
 470:	0000001c 	andeq	r0, r0, ip, lsl r0
 474:	00000320 	andeq	r0, r0, r0, lsr #6
 478:	00008bb0 			; <UNDEFINED> instruction: 0x00008bb0
 47c:	00000060 	andeq	r0, r0, r0, rrx
 480:	8b080e42 	blhi	203d90 <_bss_end+0x1fa674>
 484:	42018e02 	andmi	r8, r1, #2, 28
 488:	66040b0c 	strvs	r0, [r4], -ip, lsl #22
 48c:	00080d0c 	andeq	r0, r8, ip, lsl #26
 490:	0000001c 	andeq	r0, r0, ip, lsl r0
 494:	00000320 	andeq	r0, r0, r0, lsr #6
 498:	00008c10 	andeq	r8, r0, r0, lsl ip
 49c:	0000017c 	andeq	r0, r0, ip, ror r1
 4a0:	8b080e42 	blhi	203db0 <_bss_end+0x1fa694>
 4a4:	42018e02 	andmi	r8, r1, #2, 28
 4a8:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 4ac:	080d0cb6 	stmdaeq	sp, {r1, r2, r4, r5, r7, sl, fp}
 4b0:	0000001c 	andeq	r0, r0, ip, lsl r0
 4b4:	00000320 	andeq	r0, r0, r0, lsr #6
 4b8:	00008d8c 	andeq	r8, r0, ip, lsl #27
 4bc:	00000058 	andeq	r0, r0, r8, asr r0
 4c0:	8b080e42 	blhi	203dd0 <_bss_end+0x1fa6b4>
 4c4:	42018e02 	andmi	r8, r1, #2, 28
 4c8:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 4cc:	00080d0c 	andeq	r0, r8, ip, lsl #26
 4d0:	00000018 	andeq	r0, r0, r8, lsl r0
 4d4:	00000320 	andeq	r0, r0, r0, lsr #6
 4d8:	00008de4 	andeq	r8, r0, r4, ror #27
 4dc:	0000001c 	andeq	r0, r0, ip, lsl r0
 4e0:	8b080e42 	blhi	203df0 <_bss_end+0x1fa6d4>
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
 50c:	8b080e42 	blhi	203e1c <_bss_end+0x1fa700>
 510:	42018e02 	andmi	r8, r1, #2, 28
 514:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 518:	080d0c4c 	stmdaeq	sp, {r2, r3, r6, sl, fp}
 51c:	00000020 	andeq	r0, r0, r0, lsr #32
 520:	000004ec 	andeq	r0, r0, ip, ror #9
 524:	00008f90 	muleq	r0, r0, pc	; <UNPREDICTABLE>
 528:	0000005c 	andeq	r0, r0, ip, asr r0
 52c:	840c0e42 	strhi	r0, [ip], #-3650	; 0xfffff1be
 530:	8e028b03 	vmlahi.f64	d8, d2, d3
 534:	0b0c4201 	bleq	310d40 <_bss_end+0x307624>
 538:	0d0c6804 	stceq	8, cr6, [ip, #-16]
 53c:	0000000c 	andeq	r0, r0, ip
 540:	0000001c 	andeq	r0, r0, ip, lsl r0
 544:	000004ec 	andeq	r0, r0, ip, ror #9
 548:	00008fec 	andeq	r8, r0, ip, ror #31
 54c:	00000094 	muleq	r0, r4, r0
 550:	8b080e42 	blhi	203e60 <_bss_end+0x1fa744>
 554:	42018e02 	andmi	r8, r1, #2, 28
 558:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 55c:	080d0c40 	stmdaeq	sp, {r6, sl, fp}
 560:	0000001c 	andeq	r0, r0, ip, lsl r0
 564:	000004ec 	andeq	r0, r0, ip, ror #9
 568:	00009080 	andeq	r9, r0, r0, lsl #1
 56c:	0000008c 	andeq	r0, r0, ip, lsl #1
 570:	8b080e42 	blhi	203e80 <_bss_end+0x1fa764>
 574:	42018e02 	andmi	r8, r1, #2, 28
 578:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 57c:	080d0c40 	stmdaeq	sp, {r6, sl, fp}
 580:	0000001c 	andeq	r0, r0, ip, lsl r0
 584:	000004ec 	andeq	r0, r0, ip, ror #9
 588:	0000910c 	andeq	r9, r0, ip, lsl #2
 58c:	0000006c 	andeq	r0, r0, ip, rrx
 590:	8b080e42 	blhi	203ea0 <_bss_end+0x1fa784>
 594:	42018e02 	andmi	r8, r1, #2, 28
 598:	70040b0c 	andvc	r0, r4, ip, lsl #22
 59c:	00080d0c 	andeq	r0, r8, ip, lsl #26
 5a0:	0000001c 	andeq	r0, r0, ip, lsl r0
 5a4:	000004ec 	andeq	r0, r0, ip, ror #9
 5a8:	00009178 	andeq	r9, r0, r8, ror r1
 5ac:	00000054 	andeq	r0, r0, r4, asr r0
 5b0:	8b080e42 	blhi	203ec0 <_bss_end+0x1fa7a4>
 5b4:	42018e02 	andmi	r8, r1, #2, 28
 5b8:	5e040b0c 	vmlapl.f64	d0, d4, d12
 5bc:	00080d0c 	andeq	r0, r8, ip, lsl #26
 5c0:	00000018 	andeq	r0, r0, r8, lsl r0
 5c4:	000004ec 	andeq	r0, r0, ip, ror #9
 5c8:	000091cc 	andeq	r9, r0, ip, asr #3
 5cc:	0000001c 	andeq	r0, r0, ip, lsl r0
 5d0:	8b080e42 	blhi	203ee0 <_bss_end+0x1fa7c4>
 5d4:	42018e02 	andmi	r8, r1, #2, 28
 5d8:	00040b0c 	andeq	r0, r4, ip, lsl #22
 5dc:	0000000c 	andeq	r0, r0, ip
 5e0:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 5e4:	7c020001 	stcvc	0, cr0, [r2], {1}
 5e8:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 5ec:	00000018 	andeq	r0, r0, r8, lsl r0
 5f0:	000005dc 	ldrdeq	r0, [r0], -ip
 5f4:	000091e8 	andeq	r9, r0, r8, ror #3
 5f8:	0000006c 	andeq	r0, r0, ip, rrx
 5fc:	8b080e42 	blhi	203f0c <_bss_end+0x1fa7f0>
 600:	42018e02 	andmi	r8, r1, #2, 28
 604:	00040b0c 	andeq	r0, r4, ip, lsl #22
 608:	0000000c 	andeq	r0, r0, ip
 60c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 610:	7c020001 	stcvc	0, cr0, [r2], {1}
 614:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 618:	0000001c 	andeq	r0, r0, ip, lsl r0
 61c:	00000608 	andeq	r0, r0, r8, lsl #12
 620:	00009254 	andeq	r9, r0, r4, asr r2
 624:	00000068 	andeq	r0, r0, r8, rrx
 628:	8b040e42 	blhi	103f38 <_bss_end+0xfa81c>
 62c:	0b0d4201 	bleq	350e38 <_bss_end+0x34771c>
 630:	420d0d68 	andmi	r0, sp, #104, 26	; 0x1a00
 634:	00000ecb 	andeq	r0, r0, fp, asr #29
 638:	0000001c 	andeq	r0, r0, ip, lsl r0
 63c:	00000608 	andeq	r0, r0, r8, lsl #12
 640:	000092bc 			; <UNDEFINED> instruction: 0x000092bc
 644:	00000058 	andeq	r0, r0, r8, asr r0
 648:	8b080e42 	blhi	203f58 <_bss_end+0x1fa83c>
 64c:	42018e02 	andmi	r8, r1, #2, 28
 650:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 654:	00080d0c 	andeq	r0, r8, ip, lsl #26
 658:	0000001c 	andeq	r0, r0, ip, lsl r0
 65c:	00000608 	andeq	r0, r0, r8, lsl #12
 660:	00009314 	andeq	r9, r0, r4, lsl r3
 664:	00000058 	andeq	r0, r0, r8, asr r0
 668:	8b080e42 	blhi	203f78 <_bss_end+0x1fa85c>
 66c:	42018e02 	andmi	r8, r1, #2, 28
 670:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 674:	00080d0c 	andeq	r0, r8, ip, lsl #26
 678:	0000000c 	andeq	r0, r0, ip
 67c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 680:	7c010001 	stcvc	0, cr0, [r1], {1}
 684:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 688:	0000000c 	andeq	r0, r0, ip
 68c:	00000678 	andeq	r0, r0, r8, ror r6
 690:	0000936c 	andeq	r9, r0, ip, ror #6
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
