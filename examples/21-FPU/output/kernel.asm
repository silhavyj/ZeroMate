
./kernel:     file format elf32-littlearm


Disassembly of section .text:

00008000 <_start>:
_start():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/start.s:17
.equ    CPSR_FIQ_INHIBIT,       0x40


;@ kernel reset vektor - tento kod se vykona pri kazdem resetu zarizeni (i prvnim spusteni)
_start:
	mov sp, #0x8000			;@ nastavime stack pointer na spodek zasobniku
    8000:	e3a0d902 	mov	sp, #32768	; 0x8000
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/start.s:20

	;@ nacteni tabulky vektoru preruseni do pameti
	mov r0, #0x8000			;@ adresa 0x8000 (_start) do r0
    8004:	e3a00902 	mov	r0, #32768	; 0x8000
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/start.s:21
    mov r1, #0x0000			;@ adresa 0x0000 (pocatek RAM) do r1 - tam budeme vkladat tabulku vektoru preruseni
    8008:	e3a01000 	mov	r1, #0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/start.s:23

	mrc p15, 0, r6, c1, c0, 2
    800c:	ee116f50 	mrc	15, 0, r6, cr1, cr0, {2}
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/start.s:24
    orr r6, r6, #0x300000
    8010:	e3866603 	orr	r6, r6, #3145728	; 0x300000
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/start.s:25
    mcr p15, 0, r6, c1, c0, 2
    8014:	ee016f50 	mcr	15, 0, r6, cr1, cr0, {2}
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/start.s:26
    mov r6, #0x40000000
    8018:	e3a06101 	mov	r6, #1073741824	; 0x40000000
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/start.s:27
    fmxr fpexc, r6
    801c:	eee86a10 	vmsr	fpexc, r6
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/start.s:30

	;@ a vracime se zpet do supervisor modu, SP si nastavime zpet na nasi hodnotu
    mov r0, #(CPSR_MODE_SVR | CPSR_IRQ_INHIBIT | CPSR_FIQ_INHIBIT)
    8020:	e3a000d3 	mov	r0, #211	; 0xd3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/start.s:31
    msr cpsr_c, r0
    8024:	e121f000 	msr	CPSR_c, r0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/start.s:32
    mov sp, #0x8000
    8028:	e3a0d902 	mov	sp, #32768	; 0x8000
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/start.s:34

	bl _c_startup			;@ C startup kod (inicializace prostredi)
    802c:	eb000280 	bl	8a34 <_c_startup>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/start.s:35
	bl _cpp_startup			;@ C++ startup kod (volani globalnich konstruktoru, ...)
    8030:	eb000299 	bl	8a9c <_cpp_startup>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/start.s:36
	bl _kernel_main			;@ skocime do hlavniho kodu jadra (v C)
    8034:	eb000238 	bl	891c <_kernel_main>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/start.s:37
	bl _cpp_shutdown		;@ C++ shutdown kod (volani globalnich destruktoru, ...)
    8038:	eb0002ad 	bl	8af4 <_cpp_shutdown>

0000803c <hang>:
hang():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/start.s:40

hang:
	b hang
    803c:	eafffffe 	b	803c <hang>

00008040 <__cxa_guard_acquire>:
__cxa_guard_acquire():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/cxx.cpp:11
    extern "C" int __cxa_guard_acquire(__guard*);
    extern "C" void __cxa_guard_release(__guard*);
    extern "C" void __cxa_guard_abort(__guard*);

    extern "C" int __cxa_guard_acquire(__guard* g)
    {
    8040:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8044:	e28db000 	add	fp, sp, #0
    8048:	e24dd00c 	sub	sp, sp, #12
    804c:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/cxx.cpp:12
        return !*(char*)(g);
    8050:	e51b3008 	ldr	r3, [fp, #-8]
    8054:	e5d33000 	ldrb	r3, [r3]
    8058:	e3530000 	cmp	r3, #0
    805c:	03a03001 	moveq	r3, #1
    8060:	13a03000 	movne	r3, #0
    8064:	e6ef3073 	uxtb	r3, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/cxx.cpp:13
    }
    8068:	e1a00003 	mov	r0, r3
    806c:	e28bd000 	add	sp, fp, #0
    8070:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8074:	e12fff1e 	bx	lr

00008078 <__cxa_guard_release>:
__cxa_guard_release():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/cxx.cpp:16

    extern "C" void __cxa_guard_release(__guard* g)
    {
    8078:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    807c:	e28db000 	add	fp, sp, #0
    8080:	e24dd00c 	sub	sp, sp, #12
    8084:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/cxx.cpp:17
        *(char*)g = 1;
    8088:	e51b3008 	ldr	r3, [fp, #-8]
    808c:	e3a02001 	mov	r2, #1
    8090:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/cxx.cpp:18
    }
    8094:	e320f000 	nop	{0}
    8098:	e28bd000 	add	sp, fp, #0
    809c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    80a0:	e12fff1e 	bx	lr

000080a4 <__cxa_guard_abort>:
__cxa_guard_abort():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/cxx.cpp:21

    extern "C" void __cxa_guard_abort(__guard*)
    {
    80a4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    80a8:	e28db000 	add	fp, sp, #0
    80ac:	e24dd00c 	sub	sp, sp, #12
    80b0:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/cxx.cpp:22
    }
    80b4:	e320f000 	nop	{0}
    80b8:	e28bd000 	add	sp, fp, #0
    80bc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    80c0:	e12fff1e 	bx	lr

000080c4 <__dso_handle>:
__dso_handle():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/cxx.cpp:26
}

extern "C" void __dso_handle()
{
    80c4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    80c8:	e28db000 	add	fp, sp, #0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/cxx.cpp:28
    // ignore dtors for now
}
    80cc:	e320f000 	nop	{0}
    80d0:	e28bd000 	add	sp, fp, #0
    80d4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    80d8:	e12fff1e 	bx	lr

000080dc <__cxa_atexit>:
__cxa_atexit():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/cxx.cpp:31

extern "C" void __cxa_atexit()
{
    80dc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    80e0:	e28db000 	add	fp, sp, #0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/cxx.cpp:33
    // ignore dtors for now
}
    80e4:	e320f000 	nop	{0}
    80e8:	e28bd000 	add	sp, fp, #0
    80ec:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    80f0:	e12fff1e 	bx	lr

000080f4 <__cxa_pure_virtual>:
__cxa_pure_virtual():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/cxx.cpp:36

extern "C" void __cxa_pure_virtual()
{
    80f4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    80f8:	e28db000 	add	fp, sp, #0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/cxx.cpp:38
    // pure virtual method called
}
    80fc:	e320f000 	nop	{0}
    8100:	e28bd000 	add	sp, fp, #0
    8104:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8108:	e12fff1e 	bx	lr

0000810c <__aeabi_unwind_cpp_pr1>:
__aeabi_unwind_cpp_pr1():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/cxx.cpp:41

extern "C" void __aeabi_unwind_cpp_pr1()
{
    810c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8110:	e28db000 	add	fp, sp, #0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/cxx.cpp:42 (discriminator 1)
    while (true)
    8114:	eafffffe 	b	8114 <__aeabi_unwind_cpp_pr1+0x8>

00008118 <_ZN8CMonitorC1Ejjj>:
_ZN8CMonitorC2Ejjj():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:5
#include <drivers/monitor.h>

CMonitor sMonitor{ 0x30000000, 80, 25 };

CMonitor::CMonitor(unsigned int monitor_base_addr, unsigned int width, unsigned int height)
    8118:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    811c:	e28db000 	add	fp, sp, #0
    8120:	e24dd014 	sub	sp, sp, #20
    8124:	e50b0008 	str	r0, [fp, #-8]
    8128:	e50b100c 	str	r1, [fp, #-12]
    812c:	e50b2010 	str	r2, [fp, #-16]
    8130:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:6
: m_monitor{ reinterpret_cast<unsigned char*>(monitor_base_addr) }
    8134:	e51b200c 	ldr	r2, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:10
, m_width{ width }
, m_height{ height }
, m_cursor{ 0, 0 }
, m_number_base{ DEFAULT_NUMBER_BASE }
    8138:	e51b3008 	ldr	r3, [fp, #-8]
    813c:	e5832000 	str	r2, [r3]
    8140:	e51b3008 	ldr	r3, [fp, #-8]
    8144:	e51b2010 	ldr	r2, [fp, #-16]
    8148:	e5832004 	str	r2, [r3, #4]
    814c:	e51b3008 	ldr	r3, [fp, #-8]
    8150:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8154:	e5832008 	str	r2, [r3, #8]
    8158:	e51b3008 	ldr	r3, [fp, #-8]
    815c:	e3a02000 	mov	r2, #0
    8160:	e583200c 	str	r2, [r3, #12]
    8164:	e51b3008 	ldr	r3, [fp, #-8]
    8168:	e3a02000 	mov	r2, #0
    816c:	e5832010 	str	r2, [r3, #16]
    8170:	e51b3008 	ldr	r3, [fp, #-8]
    8174:	e3a0200a 	mov	r2, #10
    8178:	e5832014 	str	r2, [r3, #20]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:12
{
}
    817c:	e51b3008 	ldr	r3, [fp, #-8]
    8180:	e1a00003 	mov	r0, r3
    8184:	e28bd000 	add	sp, fp, #0
    8188:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    818c:	e12fff1e 	bx	lr

00008190 <_ZN8CMonitor5ClearEv>:
_ZN8CMonitor5ClearEv():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:21
    m_cursor.y = 0;
    m_cursor.y = 0;
}

void CMonitor::Clear()
{
    8190:	e92d4800 	push	{fp, lr}
    8194:	e28db004 	add	fp, sp, #4
    8198:	e24dd010 	sub	sp, sp, #16
    819c:	e50b0010 	str	r0, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:22
    Reset_Cursor();
    81a0:	e51b0010 	ldr	r0, [fp, #-16]
    81a4:	eb00016d 	bl	8760 <_ZN8CMonitor12Reset_CursorEv>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:24

    for (unsigned int y = 0; y < m_height; ++y)
    81a8:	e3a03000 	mov	r3, #0
    81ac:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:24 (discriminator 1)
    81b0:	e51b3010 	ldr	r3, [fp, #-16]
    81b4:	e5933008 	ldr	r3, [r3, #8]
    81b8:	e51b2008 	ldr	r2, [fp, #-8]
    81bc:	e1520003 	cmp	r2, r3
    81c0:	2a000019 	bcs	822c <_ZN8CMonitor5ClearEv+0x9c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:26
    {
        for (unsigned int x = 0; x < m_width; ++x)
    81c4:	e3a03000 	mov	r3, #0
    81c8:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:26 (discriminator 3)
    81cc:	e51b3010 	ldr	r3, [fp, #-16]
    81d0:	e5933004 	ldr	r3, [r3, #4]
    81d4:	e51b200c 	ldr	r2, [fp, #-12]
    81d8:	e1520003 	cmp	r2, r3
    81dc:	2a00000e 	bcs	821c <_ZN8CMonitor5ClearEv+0x8c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:28 (discriminator 2)
        {
            m_monitor[(y * m_width) + x] = ' ';
    81e0:	e51b3010 	ldr	r3, [fp, #-16]
    81e4:	e5932000 	ldr	r2, [r3]
    81e8:	e51b3010 	ldr	r3, [fp, #-16]
    81ec:	e5933004 	ldr	r3, [r3, #4]
    81f0:	e51b1008 	ldr	r1, [fp, #-8]
    81f4:	e0010391 	mul	r1, r1, r3
    81f8:	e51b300c 	ldr	r3, [fp, #-12]
    81fc:	e0813003 	add	r3, r1, r3
    8200:	e0823003 	add	r3, r2, r3
    8204:	e3a02020 	mov	r2, #32
    8208:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:26 (discriminator 2)
        for (unsigned int x = 0; x < m_width; ++x)
    820c:	e51b300c 	ldr	r3, [fp, #-12]
    8210:	e2833001 	add	r3, r3, #1
    8214:	e50b300c 	str	r3, [fp, #-12]
    8218:	eaffffeb 	b	81cc <_ZN8CMonitor5ClearEv+0x3c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:24 (discriminator 2)
    for (unsigned int y = 0; y < m_height; ++y)
    821c:	e51b3008 	ldr	r3, [fp, #-8]
    8220:	e2833001 	add	r3, r3, #1
    8224:	e50b3008 	str	r3, [fp, #-8]
    8228:	eaffffe0 	b	81b0 <_ZN8CMonitor5ClearEv+0x20>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:31
        }
    }
}
    822c:	e320f000 	nop	{0}
    8230:	e24bd004 	sub	sp, fp, #4
    8234:	e8bd8800 	pop	{fp, pc}

00008238 <_ZN8CMonitor6ScrollEv>:
_ZN8CMonitor6ScrollEv():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:49
        m_cursor.y = m_height - 1;
    }
}

void CMonitor::Scroll()
{
    8238:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    823c:	e28db000 	add	fp, sp, #0
    8240:	e24dd01c 	sub	sp, sp, #28
    8244:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:50
    for (unsigned int y = 1; y < m_height; ++y)
    8248:	e3a03001 	mov	r3, #1
    824c:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:50 (discriminator 1)
    8250:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8254:	e5933008 	ldr	r3, [r3, #8]
    8258:	e51b2008 	ldr	r2, [fp, #-8]
    825c:	e1520003 	cmp	r2, r3
    8260:	2a000024 	bcs	82f8 <_ZN8CMonitor6ScrollEv+0xc0>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:52
    {
        for (unsigned int x = 0; x < m_width; ++x)
    8264:	e3a03000 	mov	r3, #0
    8268:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:52 (discriminator 3)
    826c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8270:	e5933004 	ldr	r3, [r3, #4]
    8274:	e51b200c 	ldr	r2, [fp, #-12]
    8278:	e1520003 	cmp	r2, r3
    827c:	2a000019 	bcs	82e8 <_ZN8CMonitor6ScrollEv+0xb0>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:54 (discriminator 2)
        {
            m_monitor[((y - 1) * m_width) + x] = m_monitor[(y * m_width) + x];
    8280:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8284:	e5932000 	ldr	r2, [r3]
    8288:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    828c:	e5933004 	ldr	r3, [r3, #4]
    8290:	e51b1008 	ldr	r1, [fp, #-8]
    8294:	e0010391 	mul	r1, r1, r3
    8298:	e51b300c 	ldr	r3, [fp, #-12]
    829c:	e0813003 	add	r3, r1, r3
    82a0:	e0822003 	add	r2, r2, r3
    82a4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    82a8:	e5931000 	ldr	r1, [r3]
    82ac:	e51b3008 	ldr	r3, [fp, #-8]
    82b0:	e2433001 	sub	r3, r3, #1
    82b4:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    82b8:	e5900004 	ldr	r0, [r0, #4]
    82bc:	e0000390 	mul	r0, r0, r3
    82c0:	e51b300c 	ldr	r3, [fp, #-12]
    82c4:	e0803003 	add	r3, r0, r3
    82c8:	e0813003 	add	r3, r1, r3
    82cc:	e5d22000 	ldrb	r2, [r2]
    82d0:	e6ef2072 	uxtb	r2, r2
    82d4:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:52 (discriminator 2)
        for (unsigned int x = 0; x < m_width; ++x)
    82d8:	e51b300c 	ldr	r3, [fp, #-12]
    82dc:	e2833001 	add	r3, r3, #1
    82e0:	e50b300c 	str	r3, [fp, #-12]
    82e4:	eaffffe0 	b	826c <_ZN8CMonitor6ScrollEv+0x34>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:50 (discriminator 2)
    for (unsigned int y = 1; y < m_height; ++y)
    82e8:	e51b3008 	ldr	r3, [fp, #-8]
    82ec:	e2833001 	add	r3, r3, #1
    82f0:	e50b3008 	str	r3, [fp, #-8]
    82f4:	eaffffd5 	b	8250 <_ZN8CMonitor6ScrollEv+0x18>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:58
        }
    }

    for (unsigned int x = 0; x < m_width; ++x)
    82f8:	e3a03000 	mov	r3, #0
    82fc:	e50b3010 	str	r3, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:58 (discriminator 3)
    8300:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8304:	e5933004 	ldr	r3, [r3, #4]
    8308:	e51b2010 	ldr	r2, [fp, #-16]
    830c:	e1520003 	cmp	r2, r3
    8310:	2a000010 	bcs	8358 <_ZN8CMonitor6ScrollEv+0x120>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:60 (discriminator 2)
    {
        m_monitor[((m_height - 1) * m_width) + x] = ' ';
    8314:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8318:	e5932000 	ldr	r2, [r3]
    831c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8320:	e5933008 	ldr	r3, [r3, #8]
    8324:	e2433001 	sub	r3, r3, #1
    8328:	e51b1018 	ldr	r1, [fp, #-24]	; 0xffffffe8
    832c:	e5911004 	ldr	r1, [r1, #4]
    8330:	e0010391 	mul	r1, r1, r3
    8334:	e51b3010 	ldr	r3, [fp, #-16]
    8338:	e0813003 	add	r3, r1, r3
    833c:	e0823003 	add	r3, r2, r3
    8340:	e3a02020 	mov	r2, #32
    8344:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:58 (discriminator 2)
    for (unsigned int x = 0; x < m_width; ++x)
    8348:	e51b3010 	ldr	r3, [fp, #-16]
    834c:	e2833001 	add	r3, r3, #1
    8350:	e50b3010 	str	r3, [fp, #-16]
    8354:	eaffffe9 	b	8300 <_ZN8CMonitor6ScrollEv+0xc8>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:62
    }
}
    8358:	e320f000 	nop	{0}
    835c:	e28bd000 	add	sp, fp, #0
    8360:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8364:	e12fff1e 	bx	lr

00008368 <_ZN8CMonitorlsEc>:
_ZN8CMonitorlsEc():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:70
{
    m_number_base = DEFAULT_NUMBER_BASE;
}

CMonitor& CMonitor::operator<<(char c)
{
    8368:	e92d4800 	push	{fp, lr}
    836c:	e28db004 	add	fp, sp, #4
    8370:	e24dd008 	sub	sp, sp, #8
    8374:	e50b0008 	str	r0, [fp, #-8]
    8378:	e1a03001 	mov	r3, r1
    837c:	e54b3009 	strb	r3, [fp, #-9]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:71
    if (c != '\n')
    8380:	e55b3009 	ldrb	r3, [fp, #-9]
    8384:	e353000a 	cmp	r3, #10
    8388:	0a000012 	beq	83d8 <_ZN8CMonitorlsEc+0x70>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:73
    {
        m_monitor[(m_cursor.y * m_width) + m_cursor.x] = static_cast<unsigned char>(c);
    838c:	e51b3008 	ldr	r3, [fp, #-8]
    8390:	e5932000 	ldr	r2, [r3]
    8394:	e51b3008 	ldr	r3, [fp, #-8]
    8398:	e593300c 	ldr	r3, [r3, #12]
    839c:	e51b1008 	ldr	r1, [fp, #-8]
    83a0:	e5911004 	ldr	r1, [r1, #4]
    83a4:	e0010391 	mul	r1, r1, r3
    83a8:	e51b3008 	ldr	r3, [fp, #-8]
    83ac:	e5933010 	ldr	r3, [r3, #16]
    83b0:	e0813003 	add	r3, r1, r3
    83b4:	e0823003 	add	r3, r2, r3
    83b8:	e55b2009 	ldrb	r2, [fp, #-9]
    83bc:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:74
        ++m_cursor.x;
    83c0:	e51b3008 	ldr	r3, [fp, #-8]
    83c4:	e5933010 	ldr	r3, [r3, #16]
    83c8:	e2832001 	add	r2, r3, #1
    83cc:	e51b3008 	ldr	r3, [fp, #-8]
    83d0:	e5832010 	str	r2, [r3, #16]
    83d4:	ea000007 	b	83f8 <_ZN8CMonitorlsEc+0x90>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:78
    }
    else
    {
        m_cursor.x = 0;
    83d8:	e51b3008 	ldr	r3, [fp, #-8]
    83dc:	e3a02000 	mov	r2, #0
    83e0:	e5832010 	str	r2, [r3, #16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:79
        ++m_cursor.y;
    83e4:	e51b3008 	ldr	r3, [fp, #-8]
    83e8:	e593300c 	ldr	r3, [r3, #12]
    83ec:	e2832001 	add	r2, r3, #1
    83f0:	e51b3008 	ldr	r3, [fp, #-8]
    83f4:	e583200c 	str	r2, [r3, #12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:82
    }

    Adjust_Cursor();
    83f8:	e51b0008 	ldr	r0, [fp, #-8]
    83fc:	eb0000e5 	bl	8798 <_ZN8CMonitor13Adjust_CursorEv>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:84

    return *this;
    8400:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:85
}
    8404:	e1a00003 	mov	r0, r3
    8408:	e24bd004 	sub	sp, fp, #4
    840c:	e8bd8800 	pop	{fp, pc}

00008410 <_ZN8CMonitorlsEPKc>:
_ZN8CMonitorlsEPKc():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:88

CMonitor& CMonitor::operator<<(const char* str)
{
    8410:	e92d4800 	push	{fp, lr}
    8414:	e28db004 	add	fp, sp, #4
    8418:	e24dd010 	sub	sp, sp, #16
    841c:	e50b0010 	str	r0, [fp, #-16]
    8420:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:89
    for (unsigned int i = 0; str[i] != '\0'; ++i)
    8424:	e3a03000 	mov	r3, #0
    8428:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:89 (discriminator 3)
    842c:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8430:	e51b3008 	ldr	r3, [fp, #-8]
    8434:	e0823003 	add	r3, r2, r3
    8438:	e5d33000 	ldrb	r3, [r3]
    843c:	e3530000 	cmp	r3, #0
    8440:	0a00000a 	beq	8470 <_ZN8CMonitorlsEPKc+0x60>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:91 (discriminator 2)
    {
        *this << str[i];
    8444:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8448:	e51b3008 	ldr	r3, [fp, #-8]
    844c:	e0823003 	add	r3, r2, r3
    8450:	e5d33000 	ldrb	r3, [r3]
    8454:	e1a01003 	mov	r1, r3
    8458:	e51b0010 	ldr	r0, [fp, #-16]
    845c:	ebffffc1 	bl	8368 <_ZN8CMonitorlsEc>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:89 (discriminator 2)
    for (unsigned int i = 0; str[i] != '\0'; ++i)
    8460:	e51b3008 	ldr	r3, [fp, #-8]
    8464:	e2833001 	add	r3, r3, #1
    8468:	e50b3008 	str	r3, [fp, #-8]
    846c:	eaffffee 	b	842c <_ZN8CMonitorlsEPKc+0x1c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:94
    }

    Reset_Number_Base();
    8470:	e51b0010 	ldr	r0, [fp, #-16]
    8474:	eb0000e9 	bl	8820 <_ZN8CMonitor17Reset_Number_BaseEv>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:96

    return *this;
    8478:	e51b3010 	ldr	r3, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:97
}
    847c:	e1a00003 	mov	r0, r3
    8480:	e24bd004 	sub	sp, fp, #4
    8484:	e8bd8800 	pop	{fp, pc}

00008488 <_ZN8CMonitorlsENS_12NNumber_BaseE>:
_ZN8CMonitorlsENS_12NNumber_BaseE():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:100

CMonitor& CMonitor::operator<<(CMonitor::NNumber_Base number_base)
{
    8488:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    848c:	e28db000 	add	fp, sp, #0
    8490:	e24dd00c 	sub	sp, sp, #12
    8494:	e50b0008 	str	r0, [fp, #-8]
    8498:	e50b100c 	str	r1, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:101
    m_number_base = number_base;
    849c:	e51b3008 	ldr	r3, [fp, #-8]
    84a0:	e51b200c 	ldr	r2, [fp, #-12]
    84a4:	e5832014 	str	r2, [r3, #20]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:103

    return *this;
    84a8:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:104
}
    84ac:	e1a00003 	mov	r0, r3
    84b0:	e28bd000 	add	sp, fp, #0
    84b4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    84b8:	e12fff1e 	bx	lr

000084bc <_ZN8CMonitorlsEj>:
_ZN8CMonitorlsEj():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:107

CMonitor& CMonitor::operator<<(unsigned int num)
{
    84bc:	e92d4800 	push	{fp, lr}
    84c0:	e28db004 	add	fp, sp, #4
    84c4:	e24dd008 	sub	sp, sp, #8
    84c8:	e50b0008 	str	r0, [fp, #-8]
    84cc:	e50b100c 	str	r1, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:112
    static constexpr unsigned int BUFFER_SIZE = 16;

    static char s_buffer[BUFFER_SIZE];

    itoa(num, s_buffer, static_cast<unsigned int>(m_number_base));
    84d0:	e51b3008 	ldr	r3, [fp, #-8]
    84d4:	e5933014 	ldr	r3, [r3, #20]
    84d8:	e59f202c 	ldr	r2, [pc, #44]	; 850c <_ZN8CMonitorlsEj+0x50>
    84dc:	e51b100c 	ldr	r1, [fp, #-12]
    84e0:	e51b0008 	ldr	r0, [fp, #-8]
    84e4:	eb000021 	bl	8570 <_ZN8CMonitor4itoaEjPcj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:113
    *this << s_buffer;
    84e8:	e59f101c 	ldr	r1, [pc, #28]	; 850c <_ZN8CMonitorlsEj+0x50>
    84ec:	e51b0008 	ldr	r0, [fp, #-8]
    84f0:	ebffffc6 	bl	8410 <_ZN8CMonitorlsEPKc>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:114
    Reset_Number_Base();
    84f4:	e51b0008 	ldr	r0, [fp, #-8]
    84f8:	eb0000c8 	bl	8820 <_ZN8CMonitor17Reset_Number_BaseEv>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:116

    return *this;
    84fc:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:117
}
    8500:	e1a00003 	mov	r0, r3
    8504:	e24bd004 	sub	sp, fp, #4
    8508:	e8bd8800 	pop	{fp, pc}
    850c:	00008df4 	strdeq	r8, [r0], -r4

00008510 <_ZN8CMonitorlsEb>:
_ZN8CMonitorlsEb():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:120

CMonitor& CMonitor::operator<<(bool value)
{
    8510:	e92d4800 	push	{fp, lr}
    8514:	e28db004 	add	fp, sp, #4
    8518:	e24dd008 	sub	sp, sp, #8
    851c:	e50b0008 	str	r0, [fp, #-8]
    8520:	e1a03001 	mov	r3, r1
    8524:	e54b3009 	strb	r3, [fp, #-9]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:121
    if (value)
    8528:	e55b3009 	ldrb	r3, [fp, #-9]
    852c:	e3530000 	cmp	r3, #0
    8530:	0a000003 	beq	8544 <_ZN8CMonitorlsEb+0x34>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:123
    {
        *this << "true";
    8534:	e59f102c 	ldr	r1, [pc, #44]	; 8568 <_ZN8CMonitorlsEb+0x58>
    8538:	e51b0008 	ldr	r0, [fp, #-8]
    853c:	ebffffb3 	bl	8410 <_ZN8CMonitorlsEPKc>
    8540:	ea000002 	b	8550 <_ZN8CMonitorlsEb+0x40>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:127
    }
    else
    {
        *this << "false";
    8544:	e59f1020 	ldr	r1, [pc, #32]	; 856c <_ZN8CMonitorlsEb+0x5c>
    8548:	e51b0008 	ldr	r0, [fp, #-8]
    854c:	ebffffaf 	bl	8410 <_ZN8CMonitorlsEPKc>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:130
    }

    Reset_Number_Base();
    8550:	e51b0008 	ldr	r0, [fp, #-8]
    8554:	eb0000b1 	bl	8820 <_ZN8CMonitor17Reset_Number_BaseEv>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:132

    return *this;
    8558:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:133
}
    855c:	e1a00003 	mov	r0, r3
    8560:	e24bd004 	sub	sp, fp, #4
    8564:	e8bd8800 	pop	{fp, pc}
    8568:	00008db4 			; <UNDEFINED> instruction: 0x00008db4
    856c:	00008dbc 			; <UNDEFINED> instruction: 0x00008dbc

00008570 <_ZN8CMonitor4itoaEjPcj>:
_ZN8CMonitor4itoaEjPcj():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:136

void CMonitor::itoa(unsigned int input, char* output, unsigned int base)
{
    8570:	e92d4800 	push	{fp, lr}
    8574:	e28db004 	add	fp, sp, #4
    8578:	e24dd020 	sub	sp, sp, #32
    857c:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8580:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    8584:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    8588:	e50b3024 	str	r3, [fp, #-36]	; 0xffffffdc
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:137
    int i = 0;
    858c:	e3a03000 	mov	r3, #0
    8590:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:139

    while (input > 0)
    8594:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8598:	e3530000 	cmp	r3, #0
    859c:	0a000015 	beq	85f8 <_ZN8CMonitor4itoaEjPcj+0x88>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:141
    {        
        output[i] = CharConvArr[input % base];
    85a0:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    85a4:	e51b1024 	ldr	r1, [fp, #-36]	; 0xffffffdc
    85a8:	e1a00003 	mov	r0, r3
    85ac:	eb0001e1 	bl	8d38 <__aeabi_uidivmod>
    85b0:	e1a03001 	mov	r3, r1
    85b4:	e1a02003 	mov	r2, r3
    85b8:	e59f3128 	ldr	r3, [pc, #296]	; 86e8 <_ZN8CMonitor4itoaEjPcj+0x178>
    85bc:	e0822003 	add	r2, r2, r3
    85c0:	e51b3008 	ldr	r3, [fp, #-8]
    85c4:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    85c8:	e0813003 	add	r3, r1, r3
    85cc:	e5d22000 	ldrb	r2, [r2]
    85d0:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:142
        input /= base;
    85d4:	e51b1024 	ldr	r1, [fp, #-36]	; 0xffffffdc
    85d8:	e51b001c 	ldr	r0, [fp, #-28]	; 0xffffffe4
    85dc:	eb00015a 	bl	8b4c <__udivsi3>
    85e0:	e1a03000 	mov	r3, r0
    85e4:	e50b301c 	str	r3, [fp, #-28]	; 0xffffffe4
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:144
        
        i++;
    85e8:	e51b3008 	ldr	r3, [fp, #-8]
    85ec:	e2833001 	add	r3, r3, #1
    85f0:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:139
    while (input > 0)
    85f4:	eaffffe6 	b	8594 <_ZN8CMonitor4itoaEjPcj+0x24>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:147
    }

    if (i == 0)
    85f8:	e51b3008 	ldr	r3, [fp, #-8]
    85fc:	e3530000 	cmp	r3, #0
    8600:	1a000007 	bne	8624 <_ZN8CMonitor4itoaEjPcj+0xb4>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:149
    {
        output[i] = CharConvArr[0];
    8604:	e51b3008 	ldr	r3, [fp, #-8]
    8608:	e51b2020 	ldr	r2, [fp, #-32]	; 0xffffffe0
    860c:	e0823003 	add	r3, r2, r3
    8610:	e3a02030 	mov	r2, #48	; 0x30
    8614:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:150
        i++;
    8618:	e51b3008 	ldr	r3, [fp, #-8]
    861c:	e2833001 	add	r3, r3, #1
    8620:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:153
    }

    output[i] = '\0';
    8624:	e51b3008 	ldr	r3, [fp, #-8]
    8628:	e51b2020 	ldr	r2, [fp, #-32]	; 0xffffffe0
    862c:	e0823003 	add	r3, r2, r3
    8630:	e3a02000 	mov	r2, #0
    8634:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:154
    i--;
    8638:	e51b3008 	ldr	r3, [fp, #-8]
    863c:	e2433001 	sub	r3, r3, #1
    8640:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:156

    for (int j = 0; j <= (i / 2); j++)
    8644:	e3a03000 	mov	r3, #0
    8648:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:156 (discriminator 3)
    864c:	e51b3008 	ldr	r3, [fp, #-8]
    8650:	e1a02fa3 	lsr	r2, r3, #31
    8654:	e0823003 	add	r3, r2, r3
    8658:	e1a030c3 	asr	r3, r3, #1
    865c:	e1a02003 	mov	r2, r3
    8660:	e51b300c 	ldr	r3, [fp, #-12]
    8664:	e1530002 	cmp	r3, r2
    8668:	ca00001b 	bgt	86dc <_ZN8CMonitor4itoaEjPcj+0x16c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:158 (discriminator 2)
    {
        char c = output[i - j];
    866c:	e51b2008 	ldr	r2, [fp, #-8]
    8670:	e51b300c 	ldr	r3, [fp, #-12]
    8674:	e0423003 	sub	r3, r2, r3
    8678:	e1a02003 	mov	r2, r3
    867c:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8680:	e0833002 	add	r3, r3, r2
    8684:	e5d33000 	ldrb	r3, [r3]
    8688:	e54b300d 	strb	r3, [fp, #-13]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:159 (discriminator 2)
        output[i - j] = output[j];
    868c:	e51b300c 	ldr	r3, [fp, #-12]
    8690:	e51b2020 	ldr	r2, [fp, #-32]	; 0xffffffe0
    8694:	e0822003 	add	r2, r2, r3
    8698:	e51b1008 	ldr	r1, [fp, #-8]
    869c:	e51b300c 	ldr	r3, [fp, #-12]
    86a0:	e0413003 	sub	r3, r1, r3
    86a4:	e1a01003 	mov	r1, r3
    86a8:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    86ac:	e0833001 	add	r3, r3, r1
    86b0:	e5d22000 	ldrb	r2, [r2]
    86b4:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:160 (discriminator 2)
        output[j] = c;
    86b8:	e51b300c 	ldr	r3, [fp, #-12]
    86bc:	e51b2020 	ldr	r2, [fp, #-32]	; 0xffffffe0
    86c0:	e0823003 	add	r3, r2, r3
    86c4:	e55b200d 	ldrb	r2, [fp, #-13]
    86c8:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:156 (discriminator 2)
    for (int j = 0; j <= (i / 2); j++)
    86cc:	e51b300c 	ldr	r3, [fp, #-12]
    86d0:	e2833001 	add	r3, r3, #1
    86d4:	e50b300c 	str	r3, [fp, #-12]
    86d8:	eaffffdb 	b	864c <_ZN8CMonitor4itoaEjPcj+0xdc>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:162
    }
}
    86dc:	e320f000 	nop	{0}
    86e0:	e24bd004 	sub	sp, fp, #4
    86e4:	e8bd8800 	pop	{fp, pc}
    86e8:	00008dc4 	andeq	r8, r0, r4, asr #27

000086ec <_Z41__static_initialization_and_destruction_0ii>:
_Z41__static_initialization_and_destruction_0ii():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:162
    86ec:	e92d4800 	push	{fp, lr}
    86f0:	e28db004 	add	fp, sp, #4
    86f4:	e24dd008 	sub	sp, sp, #8
    86f8:	e50b0008 	str	r0, [fp, #-8]
    86fc:	e50b100c 	str	r1, [fp, #-12]
    8700:	e51b3008 	ldr	r3, [fp, #-8]
    8704:	e3530001 	cmp	r3, #1
    8708:	1a000008 	bne	8730 <_Z41__static_initialization_and_destruction_0ii+0x44>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:162 (discriminator 1)
    870c:	e51b300c 	ldr	r3, [fp, #-12]
    8710:	e59f2024 	ldr	r2, [pc, #36]	; 873c <_Z41__static_initialization_and_destruction_0ii+0x50>
    8714:	e1530002 	cmp	r3, r2
    8718:	1a000004 	bne	8730 <_Z41__static_initialization_and_destruction_0ii+0x44>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:3
CMonitor sMonitor{ 0x30000000, 80, 25 };
    871c:	e3a03019 	mov	r3, #25
    8720:	e3a02050 	mov	r2, #80	; 0x50
    8724:	e3a01203 	mov	r1, #805306368	; 0x30000000
    8728:	e59f0010 	ldr	r0, [pc, #16]	; 8740 <_Z41__static_initialization_and_destruction_0ii+0x54>
    872c:	ebfffe79 	bl	8118 <_ZN8CMonitorC1Ejjj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:162
}
    8730:	e320f000 	nop	{0}
    8734:	e24bd004 	sub	sp, fp, #4
    8738:	e8bd8800 	pop	{fp, pc}
    873c:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>
    8740:	00008ddc 	ldrdeq	r8, [r0], -ip

00008744 <_GLOBAL__sub_I_sMonitor>:
_GLOBAL__sub_I_sMonitor():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:162
    8744:	e92d4800 	push	{fp, lr}
    8748:	e28db004 	add	fp, sp, #4
    874c:	e59f1008 	ldr	r1, [pc, #8]	; 875c <_GLOBAL__sub_I_sMonitor+0x18>
    8750:	e3a00001 	mov	r0, #1
    8754:	ebffffe4 	bl	86ec <_Z41__static_initialization_and_destruction_0ii>
    8758:	e8bd8800 	pop	{fp, pc}
    875c:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>

00008760 <_ZN8CMonitor12Reset_CursorEv>:
_ZN8CMonitor12Reset_CursorEv():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:15
{
    8760:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8764:	e28db000 	add	fp, sp, #0
    8768:	e24dd00c 	sub	sp, sp, #12
    876c:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:16
    m_cursor.y = 0;
    8770:	e51b3008 	ldr	r3, [fp, #-8]
    8774:	e3a02000 	mov	r2, #0
    8778:	e583200c 	str	r2, [r3, #12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:17
    m_cursor.y = 0;
    877c:	e51b3008 	ldr	r3, [fp, #-8]
    8780:	e3a02000 	mov	r2, #0
    8784:	e583200c 	str	r2, [r3, #12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:18
}
    8788:	e320f000 	nop	{0}
    878c:	e28bd000 	add	sp, fp, #0
    8790:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8794:	e12fff1e 	bx	lr

00008798 <_ZN8CMonitor13Adjust_CursorEv>:
_ZN8CMonitor13Adjust_CursorEv():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:34
{
    8798:	e92d4800 	push	{fp, lr}
    879c:	e28db004 	add	fp, sp, #4
    87a0:	e24dd008 	sub	sp, sp, #8
    87a4:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:35
    if (m_cursor.x >= m_width)
    87a8:	e51b3008 	ldr	r3, [fp, #-8]
    87ac:	e5932010 	ldr	r2, [r3, #16]
    87b0:	e51b3008 	ldr	r3, [fp, #-8]
    87b4:	e5933004 	ldr	r3, [r3, #4]
    87b8:	e1520003 	cmp	r2, r3
    87bc:	3a000007 	bcc	87e0 <_ZN8CMonitor13Adjust_CursorEv+0x48>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:37
        m_cursor.x = 0;
    87c0:	e51b3008 	ldr	r3, [fp, #-8]
    87c4:	e3a02000 	mov	r2, #0
    87c8:	e5832010 	str	r2, [r3, #16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:38
        ++m_cursor.y;
    87cc:	e51b3008 	ldr	r3, [fp, #-8]
    87d0:	e593300c 	ldr	r3, [r3, #12]
    87d4:	e2832001 	add	r2, r3, #1
    87d8:	e51b3008 	ldr	r3, [fp, #-8]
    87dc:	e583200c 	str	r2, [r3, #12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:41
    if (m_cursor.y >= m_height)
    87e0:	e51b3008 	ldr	r3, [fp, #-8]
    87e4:	e593200c 	ldr	r2, [r3, #12]
    87e8:	e51b3008 	ldr	r3, [fp, #-8]
    87ec:	e5933008 	ldr	r3, [r3, #8]
    87f0:	e1520003 	cmp	r2, r3
    87f4:	3a000006 	bcc	8814 <_ZN8CMonitor13Adjust_CursorEv+0x7c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:43
        Scroll();
    87f8:	e51b0008 	ldr	r0, [fp, #-8]
    87fc:	ebfffe8d 	bl	8238 <_ZN8CMonitor6ScrollEv>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:44
        m_cursor.y = m_height - 1;
    8800:	e51b3008 	ldr	r3, [fp, #-8]
    8804:	e5933008 	ldr	r3, [r3, #8]
    8808:	e2432001 	sub	r2, r3, #1
    880c:	e51b3008 	ldr	r3, [fp, #-8]
    8810:	e583200c 	str	r2, [r3, #12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:46
}
    8814:	e320f000 	nop	{0}
    8818:	e24bd004 	sub	sp, fp, #4
    881c:	e8bd8800 	pop	{fp, pc}

00008820 <_ZN8CMonitor17Reset_Number_BaseEv>:
_ZN8CMonitor17Reset_Number_BaseEv():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:65
{
    8820:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8824:	e28db000 	add	fp, sp, #0
    8828:	e24dd00c 	sub	sp, sp, #12
    882c:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:66
    m_number_base = DEFAULT_NUMBER_BASE;
    8830:	e51b3008 	ldr	r3, [fp, #-8]
    8834:	e3a0200a 	mov	r2, #10
    8838:	e5832014 	str	r2, [r3, #20]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/drivers/monitor.cpp:67
}
    883c:	e320f000 	nop	{0}
    8840:	e28bd000 	add	sp, fp, #0
    8844:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8848:	e12fff1e 	bx	lr

0000884c <_Z10custom_sinf>:
_Z10custom_sinf():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/main.cpp:4
#include <drivers/monitor.h>

float custom_sin(float x)
{
    884c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8850:	e28db000 	add	fp, sp, #0
    8854:	e24dd024 	sub	sp, sp, #36	; 0x24
    8858:	ed0b0a08 	vstr	s0, [fp, #-32]	; 0xffffffe0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/main.cpp:5
    float result = 0.0F;
    885c:	e3a03000 	mov	r3, #0
    8860:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/main.cpp:6
    float term = x;
    8864:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8868:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/main.cpp:7
    float sign = 1.0F;
    886c:	e3a035fe 	mov	r3, #1065353216	; 0x3f800000
    8870:	e50b3010 	str	r3, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/main.cpp:8
    float factorial = 1.0F;
    8874:	e3a035fe 	mov	r3, #1065353216	; 0x3f800000
    8878:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/main.cpp:10

    for (int i = 0; i < 10; i++)
    887c:	e3a03000 	mov	r3, #0
    8880:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/main.cpp:10 (discriminator 3)
    8884:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8888:	e3530009 	cmp	r3, #9
    888c:	ca00001c 	bgt	8904 <_Z10custom_sinf+0xb8>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/main.cpp:12 (discriminator 2)
    {
        result += sign * term;
    8890:	ed1b7a04 	vldr	s14, [fp, #-16]
    8894:	ed5b7a03 	vldr	s15, [fp, #-12]
    8898:	ee677a27 	vmul.f32	s15, s14, s15
    889c:	ed1b7a02 	vldr	s14, [fp, #-8]
    88a0:	ee777a27 	vadd.f32	s15, s14, s15
    88a4:	ed4b7a02 	vstr	s15, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/main.cpp:13 (discriminator 2)
        sign = -sign;
    88a8:	ed5b7a04 	vldr	s15, [fp, #-16]
    88ac:	eef17a67 	vneg.f32	s15, s15
    88b0:	ed4b7a04 	vstr	s15, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/main.cpp:14 (discriminator 2)
        term = term * x * x / ((2 * i + 2) * (2 * i + 3));
    88b4:	ed1b7a03 	vldr	s14, [fp, #-12]
    88b8:	ed5b7a08 	vldr	s15, [fp, #-32]	; 0xffffffe0
    88bc:	ee277a27 	vmul.f32	s14, s14, s15
    88c0:	ed5b7a08 	vldr	s15, [fp, #-32]	; 0xffffffe0
    88c4:	ee676a27 	vmul.f32	s13, s14, s15
    88c8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    88cc:	e2833001 	add	r3, r3, #1
    88d0:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    88d4:	e1a02082 	lsl	r2, r2, #1
    88d8:	e2822003 	add	r2, r2, #3
    88dc:	e0030392 	mul	r3, r2, r3
    88e0:	e1a03083 	lsl	r3, r3, #1
    88e4:	ee073a90 	vmov	s15, r3
    88e8:	eeb87ae7 	vcvt.f32.s32	s14, s15
    88ec:	eec67a87 	vdiv.f32	s15, s13, s14
    88f0:	ed4b7a03 	vstr	s15, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/main.cpp:10 (discriminator 2)
    for (int i = 0; i < 10; i++)
    88f4:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    88f8:	e2833001 	add	r3, r3, #1
    88fc:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
    8900:	eaffffdf 	b	8884 <_Z10custom_sinf+0x38>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/main.cpp:17
    }

    return result;
    8904:	e51b3008 	ldr	r3, [fp, #-8]
    8908:	ee073a90 	vmov	s15, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/main.cpp:18
}
    890c:	eeb00a67 	vmov.f32	s0, s15
    8910:	e28bd000 	add	sp, fp, #0
    8914:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8918:	e12fff1e 	bx	lr

0000891c <_kernel_main>:
_kernel_main():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/main.cpp:21

extern "C" int _kernel_main(void)
{
    891c:	e92d4800 	push	{fp, lr}
    8920:	e28db004 	add	fp, sp, #4
    8924:	e24dd028 	sub	sp, sp, #40	; 0x28
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/main.cpp:22
    sMonitor.Clear();
    8928:	e59f00f4 	ldr	r0, [pc, #244]	; 8a24 <_kernel_main+0x108>
    892c:	ebfffe17 	bl	8190 <_ZN8CMonitor5ClearEv>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/main.cpp:24

    float angle = 0.0F;
    8930:	e3a03000 	mov	r3, #0
    8934:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/main.cpp:25
    float frequency = 1.0F;
    8938:	e3a035fe 	mov	r3, #1065353216	; 0x3f800000
    893c:	e50b3010 	str	r3, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/main.cpp:27

    float M_PI = 3.14159265358979323846F;
    8940:	e59f30e0 	ldr	r3, [pc, #224]	; 8a28 <_kernel_main+0x10c>
    8944:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/main.cpp:29

    float one = 1.0F;
    8948:	e3a035fe 	mov	r3, #1065353216	; 0x3f800000
    894c:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/main.cpp:30
    float twenty = 40.0F;
    8950:	e59f30d4 	ldr	r3, [pc, #212]	; 8a2c <_kernel_main+0x110>
    8954:	e50b301c 	str	r3, [fp, #-28]	; 0xffffffe4
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/main.cpp:31
    float zero_point_1 = 0.1F;
    8958:	e59f30d0 	ldr	r3, [pc, #208]	; 8a30 <_kernel_main+0x114>
    895c:	e50b3020 	str	r3, [fp, #-32]	; 0xffffffe0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/main.cpp:32
    float two = 2.0F;
    8960:	e3a03101 	mov	r3, #1073741824	; 0x40000000
    8964:	e50b3024 	str	r3, [fp, #-36]	; 0xffffffdc
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/main.cpp:36

    while (1)
    {
        float value = custom_sin(angle);
    8968:	ed1b0a02 	vldr	s0, [fp, #-8]
    896c:	ebffffb6 	bl	884c <_Z10custom_sinf>
    8970:	ed0b0a0a 	vstr	s0, [fp, #-40]	; 0xffffffd8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/main.cpp:37
        int numStars = (int)((value + one) * twenty);
    8974:	ed1b7a0a 	vldr	s14, [fp, #-40]	; 0xffffffd8
    8978:	ed5b7a06 	vldr	s15, [fp, #-24]	; 0xffffffe8
    897c:	ee377a27 	vadd.f32	s14, s14, s15
    8980:	ed5b7a07 	vldr	s15, [fp, #-28]	; 0xffffffe4
    8984:	ee677a27 	vmul.f32	s15, s14, s15
    8988:	eefd7ae7 	vcvt.s32.f32	s15, s15
    898c:	ee173a90 	vmov	r3, s15
    8990:	e50b302c 	str	r3, [fp, #-44]	; 0xffffffd4
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/main.cpp:39

        for (int i = 0; i < numStars; i++)
    8994:	e3a03000 	mov	r3, #0
    8998:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/main.cpp:39 (discriminator 3)
    899c:	e51b200c 	ldr	r2, [fp, #-12]
    89a0:	e51b302c 	ldr	r3, [fp, #-44]	; 0xffffffd4
    89a4:	e1520003 	cmp	r2, r3
    89a8:	aa000006 	bge	89c8 <_kernel_main+0xac>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/main.cpp:41 (discriminator 2)
        {
            sMonitor << '*';
    89ac:	e3a0102a 	mov	r1, #42	; 0x2a
    89b0:	e59f006c 	ldr	r0, [pc, #108]	; 8a24 <_kernel_main+0x108>
    89b4:	ebfffe6b 	bl	8368 <_ZN8CMonitorlsEc>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/main.cpp:39 (discriminator 2)
        for (int i = 0; i < numStars; i++)
    89b8:	e51b300c 	ldr	r3, [fp, #-12]
    89bc:	e2833001 	add	r3, r3, #1
    89c0:	e50b300c 	str	r3, [fp, #-12]
    89c4:	eafffff4 	b	899c <_kernel_main+0x80>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/main.cpp:44
        }

        sMonitor << '\n';
    89c8:	e3a0100a 	mov	r1, #10
    89cc:	e59f0050 	ldr	r0, [pc, #80]	; 8a24 <_kernel_main+0x108>
    89d0:	ebfffe64 	bl	8368 <_ZN8CMonitorlsEc>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/main.cpp:46

        angle += zero_point_1 * frequency;
    89d4:	ed1b7a08 	vldr	s14, [fp, #-32]	; 0xffffffe0
    89d8:	ed5b7a04 	vldr	s15, [fp, #-16]
    89dc:	ee677a27 	vmul.f32	s15, s14, s15
    89e0:	ed1b7a02 	vldr	s14, [fp, #-8]
    89e4:	ee777a27 	vadd.f32	s15, s14, s15
    89e8:	ed4b7a02 	vstr	s15, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/main.cpp:47
        if (angle >= two * M_PI)
    89ec:	ed1b7a09 	vldr	s14, [fp, #-36]	; 0xffffffdc
    89f0:	ed5b7a05 	vldr	s15, [fp, #-20]	; 0xffffffec
    89f4:	ee677a27 	vmul.f32	s15, s14, s15
    89f8:	ed1b7a02 	vldr	s14, [fp, #-8]
    89fc:	eeb47ae7 	vcmpe.f32	s14, s15
    8a00:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8a04:	ba000005 	blt	8a20 <_kernel_main+0x104>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/main.cpp:49
        {
            angle -= two * M_PI;
    8a08:	ed1b7a09 	vldr	s14, [fp, #-36]	; 0xffffffdc
    8a0c:	ed5b7a05 	vldr	s15, [fp, #-20]	; 0xffffffec
    8a10:	ee677a27 	vmul.f32	s15, s14, s15
    8a14:	ed1b7a02 	vldr	s14, [fp, #-8]
    8a18:	ee777a67 	vsub.f32	s15, s14, s15
    8a1c:	ed4b7a02 	vstr	s15, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/main.cpp:51
        }
    }
    8a20:	eaffffd0 	b	8968 <_kernel_main+0x4c>
    8a24:	00008ddc 	ldrdeq	r8, [r0], -ip
    8a28:	40490fdb 	ldrdmi	r0, [r9], #-251	; 0xffffff05
    8a2c:	42200000 	eormi	r0, r0, #0
    8a30:	3dcccccd 	stclcc	12, cr12, [ip, #820]	; 0x334

00008a34 <_c_startup>:
_c_startup():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/startup.cpp:21
extern "C" dtor_ptr __DTOR_LIST__[0];
// konec pole destruktoru
extern "C" dtor_ptr __DTOR_END__[0];

extern "C" int _c_startup(void)
{
    8a34:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8a38:	e28db000 	add	fp, sp, #0
    8a3c:	e24dd00c 	sub	sp, sp, #12
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/startup.cpp:25
    int* i;

    // vynulujeme .bss sekci
    for (i = (int*)_bss_start; i < (int*)_bss_end; i++)
    8a40:	e59f304c 	ldr	r3, [pc, #76]	; 8a94 <_c_startup+0x60>
    8a44:	e5933000 	ldr	r3, [r3]
    8a48:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/startup.cpp:25 (discriminator 3)
    8a4c:	e59f3044 	ldr	r3, [pc, #68]	; 8a98 <_c_startup+0x64>
    8a50:	e5933000 	ldr	r3, [r3]
    8a54:	e1a02003 	mov	r2, r3
    8a58:	e51b3008 	ldr	r3, [fp, #-8]
    8a5c:	e1530002 	cmp	r3, r2
    8a60:	2a000006 	bcs	8a80 <_c_startup+0x4c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/startup.cpp:26 (discriminator 2)
        *i = 0;
    8a64:	e51b3008 	ldr	r3, [fp, #-8]
    8a68:	e3a02000 	mov	r2, #0
    8a6c:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/startup.cpp:25 (discriminator 2)
    for (i = (int*)_bss_start; i < (int*)_bss_end; i++)
    8a70:	e51b3008 	ldr	r3, [fp, #-8]
    8a74:	e2833004 	add	r3, r3, #4
    8a78:	e50b3008 	str	r3, [fp, #-8]
    8a7c:	eafffff2 	b	8a4c <_c_startup+0x18>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/startup.cpp:28

    return 0;
    8a80:	e3a03000 	mov	r3, #0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/startup.cpp:29
}
    8a84:	e1a00003 	mov	r0, r3
    8a88:	e28bd000 	add	sp, fp, #0
    8a8c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8a90:	e12fff1e 	bx	lr
    8a94:	00008ddc 	ldrdeq	r8, [r0], -ip
    8a98:	00008e14 	andeq	r8, r0, r4, lsl lr

00008a9c <_cpp_startup>:
_cpp_startup():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/startup.cpp:32

extern "C" int _cpp_startup(void)
{
    8a9c:	e92d4800 	push	{fp, lr}
    8aa0:	e28db004 	add	fp, sp, #4
    8aa4:	e24dd008 	sub	sp, sp, #8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/startup.cpp:37
    ctor_ptr* fnptr;

    // zavolame konstruktory globalnich C++ trid
    // v poli __CTOR_LIST__ jsou ukazatele na vygenerovane stuby volani konstruktoru
    for (fnptr = __CTOR_LIST__; fnptr < __CTOR_END__; fnptr++)
    8aa8:	e59f303c 	ldr	r3, [pc, #60]	; 8aec <_cpp_startup+0x50>
    8aac:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/startup.cpp:37 (discriminator 3)
    8ab0:	e51b3008 	ldr	r3, [fp, #-8]
    8ab4:	e59f2034 	ldr	r2, [pc, #52]	; 8af0 <_cpp_startup+0x54>
    8ab8:	e1530002 	cmp	r3, r2
    8abc:	2a000006 	bcs	8adc <_cpp_startup+0x40>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/startup.cpp:38 (discriminator 2)
        (*fnptr)();
    8ac0:	e51b3008 	ldr	r3, [fp, #-8]
    8ac4:	e5933000 	ldr	r3, [r3]
    8ac8:	e12fff33 	blx	r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/startup.cpp:37 (discriminator 2)
    for (fnptr = __CTOR_LIST__; fnptr < __CTOR_END__; fnptr++)
    8acc:	e51b3008 	ldr	r3, [fp, #-8]
    8ad0:	e2833004 	add	r3, r3, #4
    8ad4:	e50b3008 	str	r3, [fp, #-8]
    8ad8:	eafffff4 	b	8ab0 <_cpp_startup+0x14>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/startup.cpp:40

    return 0;
    8adc:	e3a03000 	mov	r3, #0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/startup.cpp:41
}
    8ae0:	e1a00003 	mov	r0, r3
    8ae4:	e24bd004 	sub	sp, fp, #4
    8ae8:	e8bd8800 	pop	{fp, pc}
    8aec:	00008dd8 	ldrdeq	r8, [r0], -r8	; <UNPREDICTABLE>
    8af0:	00008ddc 	ldrdeq	r8, [r0], -ip

00008af4 <_cpp_shutdown>:
_cpp_shutdown():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/startup.cpp:44

extern "C" int _cpp_shutdown(void)
{
    8af4:	e92d4800 	push	{fp, lr}
    8af8:	e28db004 	add	fp, sp, #4
    8afc:	e24dd008 	sub	sp, sp, #8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/startup.cpp:48
    dtor_ptr* fnptr;

    // zavolame destruktory globalnich C++ trid
    for (fnptr = __DTOR_LIST__; fnptr < __DTOR_END__; fnptr++)
    8b00:	e59f303c 	ldr	r3, [pc, #60]	; 8b44 <_cpp_shutdown+0x50>
    8b04:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/startup.cpp:48 (discriminator 3)
    8b08:	e51b3008 	ldr	r3, [fp, #-8]
    8b0c:	e59f2034 	ldr	r2, [pc, #52]	; 8b48 <_cpp_shutdown+0x54>
    8b10:	e1530002 	cmp	r3, r2
    8b14:	2a000006 	bcs	8b34 <_cpp_shutdown+0x40>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/startup.cpp:49 (discriminator 2)
        (*fnptr)();
    8b18:	e51b3008 	ldr	r3, [fp, #-8]
    8b1c:	e5933000 	ldr	r3, [r3]
    8b20:	e12fff33 	blx	r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/startup.cpp:48 (discriminator 2)
    for (fnptr = __DTOR_LIST__; fnptr < __DTOR_END__; fnptr++)
    8b24:	e51b3008 	ldr	r3, [fp, #-8]
    8b28:	e2833004 	add	r3, r3, #4
    8b2c:	e50b3008 	str	r3, [fp, #-8]
    8b30:	eafffff4 	b	8b08 <_cpp_shutdown+0x14>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/startup.cpp:51

    return 0;
    8b34:	e3a03000 	mov	r3, #0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/21-FPU/kernel/src/startup.cpp:52
}
    8b38:	e1a00003 	mov	r0, r3
    8b3c:	e24bd004 	sub	sp, fp, #4
    8b40:	e8bd8800 	pop	{fp, pc}
    8b44:	00008ddc 	ldrdeq	r8, [r0], -ip
    8b48:	00008ddc 	ldrdeq	r8, [r0], -ip

00008b4c <__udivsi3>:
__udivsi3():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1104
    8b4c:	e2512001 	subs	r2, r1, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1106
    8b50:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1107
    8b54:	3a000074 	bcc	8d2c <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1108
    8b58:	e1500001 	cmp	r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1109
    8b5c:	9a00006b 	bls	8d10 <__udivsi3+0x1c4>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1110
    8b60:	e1110002 	tst	r1, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1111
    8b64:	0a00006c 	beq	8d1c <__udivsi3+0x1d0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1113
    8b68:	e16f3f10 	clz	r3, r0
    8b6c:	e16f2f11 	clz	r2, r1
    8b70:	e0423003 	sub	r3, r2, r3
    8b74:	e273301f 	rsbs	r3, r3, #31
    8b78:	10833083 	addne	r3, r3, r3, lsl #1
    8b7c:	e3a02000 	mov	r2, #0
    8b80:	108ff103 	addne	pc, pc, r3, lsl #2
    8b84:	e1a00000 	nop			; (mov r0, r0)
    8b88:	e1500f81 	cmp	r0, r1, lsl #31
    8b8c:	e0a22002 	adc	r2, r2, r2
    8b90:	20400f81 	subcs	r0, r0, r1, lsl #31
    8b94:	e1500f01 	cmp	r0, r1, lsl #30
    8b98:	e0a22002 	adc	r2, r2, r2
    8b9c:	20400f01 	subcs	r0, r0, r1, lsl #30
    8ba0:	e1500e81 	cmp	r0, r1, lsl #29
    8ba4:	e0a22002 	adc	r2, r2, r2
    8ba8:	20400e81 	subcs	r0, r0, r1, lsl #29
    8bac:	e1500e01 	cmp	r0, r1, lsl #28
    8bb0:	e0a22002 	adc	r2, r2, r2
    8bb4:	20400e01 	subcs	r0, r0, r1, lsl #28
    8bb8:	e1500d81 	cmp	r0, r1, lsl #27
    8bbc:	e0a22002 	adc	r2, r2, r2
    8bc0:	20400d81 	subcs	r0, r0, r1, lsl #27
    8bc4:	e1500d01 	cmp	r0, r1, lsl #26
    8bc8:	e0a22002 	adc	r2, r2, r2
    8bcc:	20400d01 	subcs	r0, r0, r1, lsl #26
    8bd0:	e1500c81 	cmp	r0, r1, lsl #25
    8bd4:	e0a22002 	adc	r2, r2, r2
    8bd8:	20400c81 	subcs	r0, r0, r1, lsl #25
    8bdc:	e1500c01 	cmp	r0, r1, lsl #24
    8be0:	e0a22002 	adc	r2, r2, r2
    8be4:	20400c01 	subcs	r0, r0, r1, lsl #24
    8be8:	e1500b81 	cmp	r0, r1, lsl #23
    8bec:	e0a22002 	adc	r2, r2, r2
    8bf0:	20400b81 	subcs	r0, r0, r1, lsl #23
    8bf4:	e1500b01 	cmp	r0, r1, lsl #22
    8bf8:	e0a22002 	adc	r2, r2, r2
    8bfc:	20400b01 	subcs	r0, r0, r1, lsl #22
    8c00:	e1500a81 	cmp	r0, r1, lsl #21
    8c04:	e0a22002 	adc	r2, r2, r2
    8c08:	20400a81 	subcs	r0, r0, r1, lsl #21
    8c0c:	e1500a01 	cmp	r0, r1, lsl #20
    8c10:	e0a22002 	adc	r2, r2, r2
    8c14:	20400a01 	subcs	r0, r0, r1, lsl #20
    8c18:	e1500981 	cmp	r0, r1, lsl #19
    8c1c:	e0a22002 	adc	r2, r2, r2
    8c20:	20400981 	subcs	r0, r0, r1, lsl #19
    8c24:	e1500901 	cmp	r0, r1, lsl #18
    8c28:	e0a22002 	adc	r2, r2, r2
    8c2c:	20400901 	subcs	r0, r0, r1, lsl #18
    8c30:	e1500881 	cmp	r0, r1, lsl #17
    8c34:	e0a22002 	adc	r2, r2, r2
    8c38:	20400881 	subcs	r0, r0, r1, lsl #17
    8c3c:	e1500801 	cmp	r0, r1, lsl #16
    8c40:	e0a22002 	adc	r2, r2, r2
    8c44:	20400801 	subcs	r0, r0, r1, lsl #16
    8c48:	e1500781 	cmp	r0, r1, lsl #15
    8c4c:	e0a22002 	adc	r2, r2, r2
    8c50:	20400781 	subcs	r0, r0, r1, lsl #15
    8c54:	e1500701 	cmp	r0, r1, lsl #14
    8c58:	e0a22002 	adc	r2, r2, r2
    8c5c:	20400701 	subcs	r0, r0, r1, lsl #14
    8c60:	e1500681 	cmp	r0, r1, lsl #13
    8c64:	e0a22002 	adc	r2, r2, r2
    8c68:	20400681 	subcs	r0, r0, r1, lsl #13
    8c6c:	e1500601 	cmp	r0, r1, lsl #12
    8c70:	e0a22002 	adc	r2, r2, r2
    8c74:	20400601 	subcs	r0, r0, r1, lsl #12
    8c78:	e1500581 	cmp	r0, r1, lsl #11
    8c7c:	e0a22002 	adc	r2, r2, r2
    8c80:	20400581 	subcs	r0, r0, r1, lsl #11
    8c84:	e1500501 	cmp	r0, r1, lsl #10
    8c88:	e0a22002 	adc	r2, r2, r2
    8c8c:	20400501 	subcs	r0, r0, r1, lsl #10
    8c90:	e1500481 	cmp	r0, r1, lsl #9
    8c94:	e0a22002 	adc	r2, r2, r2
    8c98:	20400481 	subcs	r0, r0, r1, lsl #9
    8c9c:	e1500401 	cmp	r0, r1, lsl #8
    8ca0:	e0a22002 	adc	r2, r2, r2
    8ca4:	20400401 	subcs	r0, r0, r1, lsl #8
    8ca8:	e1500381 	cmp	r0, r1, lsl #7
    8cac:	e0a22002 	adc	r2, r2, r2
    8cb0:	20400381 	subcs	r0, r0, r1, lsl #7
    8cb4:	e1500301 	cmp	r0, r1, lsl #6
    8cb8:	e0a22002 	adc	r2, r2, r2
    8cbc:	20400301 	subcs	r0, r0, r1, lsl #6
    8cc0:	e1500281 	cmp	r0, r1, lsl #5
    8cc4:	e0a22002 	adc	r2, r2, r2
    8cc8:	20400281 	subcs	r0, r0, r1, lsl #5
    8ccc:	e1500201 	cmp	r0, r1, lsl #4
    8cd0:	e0a22002 	adc	r2, r2, r2
    8cd4:	20400201 	subcs	r0, r0, r1, lsl #4
    8cd8:	e1500181 	cmp	r0, r1, lsl #3
    8cdc:	e0a22002 	adc	r2, r2, r2
    8ce0:	20400181 	subcs	r0, r0, r1, lsl #3
    8ce4:	e1500101 	cmp	r0, r1, lsl #2
    8ce8:	e0a22002 	adc	r2, r2, r2
    8cec:	20400101 	subcs	r0, r0, r1, lsl #2
    8cf0:	e1500081 	cmp	r0, r1, lsl #1
    8cf4:	e0a22002 	adc	r2, r2, r2
    8cf8:	20400081 	subcs	r0, r0, r1, lsl #1
    8cfc:	e1500001 	cmp	r0, r1
    8d00:	e0a22002 	adc	r2, r2, r2
    8d04:	20400001 	subcs	r0, r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1115
    8d08:	e1a00002 	mov	r0, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1116
    8d0c:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1119
    8d10:	03a00001 	moveq	r0, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1120
    8d14:	13a00000 	movne	r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1121
    8d18:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1123
    8d1c:	e16f2f11 	clz	r2, r1
    8d20:	e262201f 	rsb	r2, r2, #31
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1125
    8d24:	e1a00230 	lsr	r0, r0, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1126
    8d28:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1130
    8d2c:	e3500000 	cmp	r0, #0
    8d30:	13e00000 	mvnne	r0, #0
    8d34:	ea000007 	b	8d58 <__aeabi_idiv0>

00008d38 <__aeabi_uidivmod>:
__aeabi_uidivmod():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1161
    8d38:	e3510000 	cmp	r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1162
    8d3c:	0afffffa 	beq	8d2c <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1163
    8d40:	e92d4003 	push	{r0, r1, lr}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1164
    8d44:	ebffff80 	bl	8b4c <__udivsi3>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1165
    8d48:	e8bd4006 	pop	{r1, r2, lr}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1166
    8d4c:	e0030092 	mul	r3, r2, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1167
    8d50:	e0411003 	sub	r1, r1, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1168
    8d54:	e12fff1e 	bx	lr

00008d58 <__aeabi_idiv0>:
__aeabi_ldiv0():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1466
    8d58:	e12fff1e 	bx	lr

Disassembly of section .ARM.extab:

00008d5c <.ARM.extab>:
    8d5c:	81019b40 	tsthi	r1, r0, asr #22
    8d60:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    8d64:	00000000 	andeq	r0, r0, r0
    8d68:	81019b40 	tsthi	r1, r0, asr #22
    8d6c:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    8d70:	00000000 	andeq	r0, r0, r0
    8d74:	81019b40 	tsthi	r1, r0, asr #22
    8d78:	8480b0b0 	strhi	fp, [r0], #176	; 0xb0
    8d7c:	00000000 	andeq	r0, r0, r0

Disassembly of section .ARM.exidx:

00008d80 <.ARM.exidx>:
    8d80:	7ffff2c0 	svcvc	0x00fff2c0
    8d84:	00000001 	andeq	r0, r0, r1
    8d88:	7ffffb94 	svcvc	0x00fffb94
    8d8c:	7fffffd0 	svcvc	0x00ffffd0
    8d90:	7ffffca4 	svcvc	0x00fffca4
    8d94:	00000001 	andeq	r0, r0, r1
    8d98:	7ffffd04 	svcvc	0x00fffd04
    8d9c:	7fffffcc 	svcvc	0x00ffffcc
    8da0:	7ffffd54 	svcvc	0x00fffd54
    8da4:	7fffffd0 	svcvc	0x00ffffd0
    8da8:	7ffffda4 	svcvc	0x00fffda4
    8dac:	00000001 	andeq	r0, r0, r1

Disassembly of section .rodata:

00008db0 <_ZZN8CMonitorlsEjE11BUFFER_SIZE>:
    8db0:	00000010 	andeq	r0, r0, r0, lsl r0
    8db4:	65757274 	ldrbvs	r7, [r5, #-628]!	; 0xfffffd8c
    8db8:	00000000 	andeq	r0, r0, r0
    8dbc:	736c6166 	cmnvc	ip, #-2147483623	; 0x80000019
    8dc0:	00000065 	andeq	r0, r0, r5, rrx
    8dc4:	33323130 	teqcc	r2, #48, 2
    8dc8:	37363534 			; <UNDEFINED> instruction: 0x37363534
    8dcc:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    8dd0:	46454443 	strbmi	r4, [r5], -r3, asr #8
	...

Disassembly of section .data:

00008dd8 <__CTOR_LIST__>:
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:2355
    8dd8:	00008744 	andeq	r8, r0, r4, asr #14

Disassembly of section .bss:

00008ddc <sMonitor>:
	...

00008df4 <_ZZN8CMonitorlsEjE8s_buffer>:
	...

Disassembly of section .debug_info:

00000000 <.debug_info>:
       0:	00000126 	andeq	r0, r0, r6, lsr #2
       4:	00000004 	andeq	r0, r0, r4
       8:	01040000 	mrseq	r0, (UNDEF: 4)
       c:	00000088 	andeq	r0, r0, r8, lsl #1
      10:	00001404 	andeq	r1, r0, r4, lsl #8
      14:	00011c00 	andeq	r1, r1, r0, lsl #24
      18:	00804000 	addeq	r4, r0, r0
      1c:	0000d800 	andeq	sp, r0, r0, lsl #16
      20:	00000000 	andeq	r0, r0, r0
      24:	01890200 	orreq	r0, r9, r0, lsl #4
      28:	28010000 	stmdacs	r1, {}	; <UNPREDICTABLE>
      2c:	00810c11 	addeq	r0, r1, r1, lsl ip
      30:	00000c00 	andeq	r0, r0, r0, lsl #24
      34:	029c0100 	addseq	r0, ip, #0, 2
      38:	00000176 	andeq	r0, r0, r6, ror r1
      3c:	f4112301 			; <UNDEFINED> instruction: 0xf4112301
      40:	18000080 	stmdane	r0, {r7}
      44:	01000000 	mrseq	r0, (UNDEF: 0)
      48:	007b029c 			; <UNDEFINED> instruction: 0x007b029c
      4c:	1e010000 	cdpne	0, 0, cr0, cr1, cr0, {0}
      50:	0080dc11 	addeq	sp, r0, r1, lsl ip
      54:	00001800 	andeq	r1, r0, r0, lsl #16
      58:	029c0100 	addseq	r0, ip, #0, 2
      5c:	0000006e 	andeq	r0, r0, lr, rrx
      60:	c4111901 	ldrgt	r1, [r1], #-2305	; 0xfffff6ff
      64:	18000080 	stmdane	r0, {r7}
      68:	01000000 	mrseq	r0, (UNDEF: 0)
      6c:	016b039c 			; <UNDEFINED> instruction: 0x016b039c
      70:	00020000 	andeq	r0, r2, r0
      74:	000000bb 	strheq	r0, [r0], -fp
      78:	00005c04 	andeq	r5, r0, r4, lsl #24
      7c:	15140100 	ldrne	r0, [r4, #-256]	; 0xffffff00
      80:	0000008a 	andeq	r0, r0, sl, lsl #1
      84:	0000bb05 	andeq	fp, r0, r5, lsl #22
      88:	a0060000 	andge	r0, r6, r0
      8c:	01000001 	tsteq	r0, r1
      90:	00c11f04 	sbceq	r1, r1, r4, lsl #30
      94:	00040000 	andeq	r0, r4, r0
      98:	01000000 	mrseq	r0, (UNDEF: 0)
      9c:	00a8150f 	adceq	r1, r8, pc, lsl #10
      a0:	bb050000 	bllt	1400a8 <_bss_end+0x137294>
      a4:	00000000 	andeq	r0, r0, r0
      a8:	00015707 	andeq	r5, r1, r7, lsl #14
      ac:	140a0100 	strne	r0, [sl], #-256	; 0xffffff00
      b0:	00000105 	andeq	r0, r0, r5, lsl #2
      b4:	0000bb05 	andeq	fp, r0, r5, lsl #22
      b8:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
      bc:	00008a04 	andeq	r8, r0, r4, lsl #20
      c0:	05080900 	streq	r0, [r8, #-2304]	; 0xfffff700
      c4:	000001a8 	andeq	r0, r0, r8, lsr #3
      c8:	0000780a 	andeq	r7, r0, sl, lsl #16
      cc:	0080a400 	addeq	sl, r0, r0, lsl #8
      d0:	00002000 	andeq	r2, r0, r0
      d4:	e49c0100 	ldr	r0, [ip], #256	; 0x100
      d8:	0b000000 	bleq	e0 <CPSR_IRQ_INHIBIT+0x60>
      dc:	000000bb 	strheq	r0, [r0], -fp
      e0:	00749102 	rsbseq	r9, r4, r2, lsl #2
      e4:	0000960a 	andeq	r9, r0, sl, lsl #12
      e8:	00807800 	addeq	r7, r0, r0, lsl #16
      ec:	00002c00 	andeq	r2, r0, r0, lsl #24
      f0:	059c0100 	ldreq	r0, [ip, #256]	; 0x100
      f4:	0c000001 	stceq	0, cr0, [r0], {1}
      f8:	0f010067 	svceq	0x00010067
      fc:	0000bb32 	andeq	fp, r0, r2, lsr fp
     100:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     104:	05040d00 	streq	r0, [r4, #-3328]	; 0xfffff300
     108:	00746e69 	rsbseq	r6, r4, r9, ror #28
     10c:	0000a80e 	andeq	sl, r0, lr, lsl #16
     110:	00804000 	addeq	r4, r0, r0
     114:	00003800 	andeq	r3, r0, r0, lsl #16
     118:	0c9c0100 	ldfeqs	f0, [ip], {0}
     11c:	0a010067 	beq	402c0 <_bss_end+0x374ac>
     120:	0000bb31 	andeq	fp, r0, r1, lsr fp
     124:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     128:	06b40000 	ldrteq	r0, [r4], r0
     12c:	00040000 	andeq	r0, r4, r0
     130:	000000d0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     134:	00880104 	addeq	r0, r8, r4, lsl #2
     138:	4d040000 	stcmi	0, cr0, [r4, #-0]
     13c:	1c000004 	stcne	0, cr0, [r0], {4}
     140:	00000001 	andeq	r0, r0, r1
     144:	00000000 	andeq	r0, r0, r0
     148:	a9000000 	stmdbge	r0, {}	; <UNPREDICTABLE>
     14c:	02000000 	andeq	r0, r0, #0
     150:	000002ca 	andeq	r0, r0, sl, asr #5
     154:	07030218 	smladeq	r3, r8, r2, r0
     158:	00000266 	andeq	r0, r0, r6, ror #4
     15c:	00025d03 	andeq	r5, r2, r3, lsl #26
     160:	66040700 	strvs	r0, [r4], -r0, lsl #14
     164:	02000002 	andeq	r0, r0, #2
     168:	52011006 	andpl	r1, r1, #6
     16c:	04000000 	streq	r0, [r0], #-0
     170:	00584548 	subseq	r4, r8, r8, asr #10
     174:	45440410 	strbmi	r0, [r4, #-1040]	; 0xfffffbf0
     178:	000a0043 	andeq	r0, sl, r3, asr #32
     17c:	00003205 	andeq	r3, r0, r5, lsl #4
     180:	026a0600 	rsbeq	r0, sl, #0, 12
     184:	02080000 	andeq	r0, r8, #0
     188:	007b0c24 	rsbseq	r0, fp, r4, lsr #24
     18c:	79070000 	stmdbvc	r7, {}	; <UNPREDICTABLE>
     190:	16260200 	strtne	r0, [r6], -r0, lsl #4
     194:	00000266 	andeq	r0, r0, r6, ror #4
     198:	00780700 	rsbseq	r0, r8, r0, lsl #14
     19c:	66162702 	ldrvs	r2, [r6], -r2, lsl #14
     1a0:	04000002 	streq	r0, [r0], #-2
     1a4:	03bc0800 			; <UNDEFINED> instruction: 0x03bc0800
     1a8:	0c020000 	stceq	0, cr0, [r2], {-0}
     1ac:	0000521b 	andeq	r5, r0, fp, lsl r2
     1b0:	090a0100 	stmdbeq	sl, {r8}
     1b4:	0000031a 	andeq	r0, r0, sl, lsl r3
     1b8:	78280d02 	stmdavc	r8!, {r1, r8, sl, fp}
     1bc:	01000002 	tsteq	r0, r2
     1c0:	0002ca0a 	andeq	ip, r2, sl, lsl #20
     1c4:	0e100200 	cdpeq	2, 1, cr0, cr0, cr0, {0}
     1c8:	00000394 	muleq	r0, r4, r3
     1cc:	00000289 	andeq	r0, r0, r9, lsl #5
     1d0:	0000af01 	andeq	sl, r0, r1, lsl #30
     1d4:	0000c400 	andeq	ip, r0, r0, lsl #8
     1d8:	02890b00 	addeq	r0, r9, #0, 22
     1dc:	660c0000 	strvs	r0, [ip], -r0
     1e0:	0c000002 	stceq	0, cr0, [r0], {2}
     1e4:	00000266 	andeq	r0, r0, r6, ror #4
     1e8:	0002660c 	andeq	r6, r2, ip, lsl #12
     1ec:	f30d0000 	vhadd.u8	d0, d13, d0
     1f0:	02000001 	andeq	r0, r0, #1
     1f4:	03a70a12 			; <UNDEFINED> instruction: 0x03a70a12
     1f8:	d9010000 	stmdble	r1, {}	; <UNPREDICTABLE>
     1fc:	df000000 	svcle	0x00000000
     200:	0b000000 	bleq	208 <CPSR_IRQ_INHIBIT+0x188>
     204:	00000289 	andeq	r0, r0, r9, lsl #5
     208:	02d30e00 	sbcseq	r0, r3, #0, 28
     20c:	14020000 	strne	r0, [r2], #-0
     210:	0003370f 	andeq	r3, r3, pc, lsl #14
     214:	00029400 	andeq	r9, r2, r0, lsl #8
     218:	00f80100 	rscseq	r0, r8, r0, lsl #2
     21c:	01030000 	mrseq	r0, (UNDEF: 3)
     220:	890b0000 	stmdbhi	fp, {}	; <UNPREDICTABLE>
     224:	0c000002 	stceq	0, cr0, [r0], {2}
     228:	0000027d 	andeq	r0, r0, sp, ror r2
     22c:	02d30e00 	sbcseq	r0, r3, #0, 28
     230:	15020000 	strne	r0, [r2, #-0]
     234:	0002de0f 	andeq	sp, r2, pc, lsl #28
     238:	00029400 	andeq	r9, r2, r0, lsl #8
     23c:	011c0100 	tsteq	ip, r0, lsl #2
     240:	01270000 			; <UNDEFINED> instruction: 0x01270000
     244:	890b0000 	stmdbhi	fp, {}	; <UNPREDICTABLE>
     248:	0c000002 	stceq	0, cr0, [r0], {2}
     24c:	00000272 	andeq	r0, r0, r2, ror r2
     250:	02d30e00 	sbcseq	r0, r3, #0, 28
     254:	16020000 	strne	r0, [r2], -r0
     258:	0003d00f 	andeq	sp, r3, pc
     25c:	00029400 	andeq	r9, r2, r0, lsl #8
     260:	01400100 	mrseq	r0, (UNDEF: 80)
     264:	014b0000 	mrseq	r0, (UNDEF: 75)
     268:	890b0000 	stmdbhi	fp, {}	; <UNPREDICTABLE>
     26c:	0c000002 	stceq	0, cr0, [r0], {2}
     270:	00000032 	andeq	r0, r0, r2, lsr r0
     274:	02d30e00 	sbcseq	r0, r3, #0, 28
     278:	17020000 	strne	r0, [r2, -r0]
     27c:	0003660f 	andeq	r6, r3, pc, lsl #12
     280:	00029400 	andeq	r9, r2, r0, lsl #8
     284:	01640100 	cmneq	r4, r0, lsl #2
     288:	016f0000 	cmneq	pc, r0
     28c:	890b0000 	stmdbhi	fp, {}	; <UNPREDICTABLE>
     290:	0c000002 	stceq	0, cr0, [r0], {2}
     294:	00000266 	andeq	r0, r0, r6, ror #4
     298:	02d30e00 	sbcseq	r0, r3, #0, 28
     29c:	18020000 	stmdane	r2, {}	; <UNPREDICTABLE>
     2a0:	0003260f 	andeq	r2, r3, pc, lsl #12
     2a4:	00029400 	andeq	r9, r2, r0, lsl #8
     2a8:	01880100 	orreq	r0, r8, r0, lsl #2
     2ac:	01930000 	orrseq	r0, r3, r0
     2b0:	890b0000 	stmdbhi	fp, {}	; <UNPREDICTABLE>
     2b4:	0c000002 	stceq	0, cr0, [r0], {2}
     2b8:	0000029a 	muleq	r0, sl, r2
     2bc:	024f0f00 	subeq	r0, pc, #0, 30
     2c0:	1b020000 	blne	802c8 <_bss_end+0x774b4>
     2c4:	00020c11 	andeq	r0, r2, r1, lsl ip
     2c8:	0001a700 	andeq	sl, r1, r0, lsl #14
     2cc:	0001ad00 	andeq	sl, r1, r0, lsl #26
     2d0:	02890b00 	addeq	r0, r9, #0, 22
     2d4:	0f000000 	svceq	0x00000000
     2d8:	0000022f 	andeq	r0, r0, pc, lsr #4
     2dc:	77111c02 	ldrvc	r1, [r1, -r2, lsl #24]
     2e0:	c1000003 	tstgt	r0, r3
     2e4:	c7000001 	strgt	r0, [r0, -r1]
     2e8:	0b000001 	bleq	2f4 <CPSR_IRQ_INHIBIT+0x274>
     2ec:	00000289 	andeq	r0, r0, r9, lsl #5
     2f0:	01e10f00 	mvneq	r0, r0, lsl #30
     2f4:	1d020000 	stcne	0, cr0, [r2, #-0]
     2f8:	00027411 	andeq	r7, r2, r1, lsl r4
     2fc:	0001db00 	andeq	sp, r1, r0, lsl #22
     300:	0001e100 	andeq	lr, r1, r0, lsl #2
     304:	02890b00 	addeq	r0, r9, #0, 22
     308:	0f000000 	svceq	0x00000000
     30c:	000001c1 	andeq	r0, r0, r1, asr #3
     310:	500a1f02 	andpl	r1, sl, r2, lsl #30
     314:	f5000003 			; <UNDEFINED> instruction: 0xf5000003
     318:	fb000001 	blx	326 <CPSR_IRQ_INHIBIT+0x2a6>
     31c:	0b000001 	bleq	328 <CPSR_IRQ_INHIBIT+0x2a8>
     320:	00000289 	andeq	r0, r0, r9, lsl #5
     324:	022a0f00 	eoreq	r0, sl, #0, 30
     328:	21020000 	mrscs	r0, (UNDEF: 2)
     32c:	0002f10a 	andeq	pc, r2, sl, lsl #2
     330:	00020f00 	andeq	r0, r2, r0, lsl #30
     334:	00022400 	andeq	r2, r2, r0, lsl #8
     338:	02890b00 	addeq	r0, r9, #0, 22
     33c:	660c0000 	strvs	r0, [ip], -r0
     340:	0c000002 	stceq	0, cr0, [r0], {2}
     344:	000002a1 	andeq	r0, r0, r1, lsr #5
     348:	0002660c 	andeq	r6, r2, ip, lsl #12
     34c:	96100000 	ldrls	r0, [r0], -r0
     350:	02000002 	andeq	r0, r0, #2
     354:	02ad232b 	adceq	r2, sp, #-1409286144	; 0xac000000
     358:	10000000 	andne	r0, r0, r0
     35c:	00000348 	andeq	r0, r0, r8, asr #6
     360:	66122c02 	ldrvs	r2, [r2], -r2, lsl #24
     364:	04000002 	streq	r0, [r0], #-2
     368:	00030810 	andeq	r0, r3, r0, lsl r8
     36c:	122d0200 	eorne	r0, sp, #0, 4
     370:	00000266 	andeq	r0, r0, r6, ror #4
     374:	03111008 	tsteq	r1, #8
     378:	2e020000 	cdpcs	0, 0, cr0, cr2, cr0, {0}
     37c:	0000570f 	andeq	r5, r0, pc, lsl #14
     380:	d3100c00 	tstle	r0, #0, 24
     384:	02000001 	andeq	r0, r0, #1
     388:	0032122f 	eorseq	r1, r2, pc, lsr #4
     38c:	00140000 	andseq	r0, r4, r0
     390:	57070411 	smladpl	r7, r1, r4, r0
     394:	0500000a 	streq	r0, [r0, #-10]
     398:	00000266 	andeq	r0, r0, r6, ror #4
     39c:	02840412 	addeq	r0, r4, #301989888	; 0x12000000
     3a0:	72050000 	andvc	r0, r5, #0
     3a4:	11000002 	tstne	r0, r2
     3a8:	02450801 	subeq	r0, r5, #65536	; 0x10000
     3ac:	7d050000 	stcvc	0, cr0, [r5, #-0]
     3b0:	12000002 	andne	r0, r0, #2
     3b4:	00002504 	andeq	r2, r0, r4, lsl #10
     3b8:	02890500 	addeq	r0, r9, #0, 10
     3bc:	04130000 	ldreq	r0, [r3], #-0
     3c0:	00000025 	andeq	r0, r0, r5, lsr #32
     3c4:	ce020111 	mcrgt	1, 0, r0, cr2, cr1, {0}
     3c8:	12000001 	andne	r0, r0, #1
     3cc:	00027d04 	andeq	r7, r2, r4, lsl #26
     3d0:	b9041200 	stmdblt	r4, {r9, ip}
     3d4:	05000002 	streq	r0, [r0, #-2]
     3d8:	000002a7 	andeq	r0, r0, r7, lsr #5
     3dc:	3c080111 	stfccs	f0, [r8], {17}
     3e0:	14000002 	strne	r0, [r0], #-2
     3e4:	000002b2 			; <UNDEFINED> instruction: 0x000002b2
     3e8:	0002af15 	andeq	sl, r2, r5, lsl pc
     3ec:	11320200 	teqne	r2, r0, lsl #4
     3f0:	00000025 	andeq	r0, r0, r5, lsr #32
     3f4:	0002be16 	andeq	fp, r2, r6, lsl lr
     3f8:	0a030100 	beq	c0800 <_bss_end+0xb79ec>
     3fc:	8ddc0305 	ldclhi	3, cr0, [ip, #20]
     400:	a0170000 	andsge	r0, r7, r0
     404:	44000002 	strmi	r0, [r0], #-2
     408:	1c000087 	stcne	0, cr0, [r0], {135}	; 0x87
     40c:	01000000 	mrseq	r0, (UNDEF: 0)
     410:	0423189c 	strteq	r1, [r3], #-2204	; 0xfffff764
     414:	86ec0000 	strbthi	r0, [ip], r0
     418:	00580000 	subseq	r0, r8, r0
     41c:	9c010000 	stcls	0, cr0, [r1], {-0}
     420:	00000319 	andeq	r0, r0, r9, lsl r3
     424:	00040819 	andeq	r0, r4, r9, lsl r8
     428:	01a20100 			; <UNDEFINED> instruction: 0x01a20100
     42c:	00000319 	andeq	r0, r0, r9, lsl r3
     430:	19749102 	ldmdbne	r4!, {r1, r8, ip, pc}^
     434:	000001b6 			; <UNDEFINED> instruction: 0x000001b6
     438:	1901a201 	stmdbne	r1, {r0, r9, sp, pc}
     43c:	02000003 	andeq	r0, r0, #3
     440:	1a007091 	bne	1c68c <_bss_end+0x13878>
     444:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
     448:	fb1b0074 	blx	6c0622 <_bss_end+0x6b780e>
     44c:	01000001 	tsteq	r0, r1
     450:	033a0687 	teqeq	sl, #141557760	; 0x8700000
     454:	85700000 	ldrbhi	r0, [r0, #-0]!
     458:	017c0000 	cmneq	ip, r0
     45c:	9c010000 	stcls	0, cr0, [r1], {-0}
     460:	000003af 	andeq	r0, r0, pc, lsr #7
     464:	00024a1c 	andeq	r4, r2, ip, lsl sl
     468:	00028f00 	andeq	r8, r2, r0, lsl #30
     46c:	64910200 	ldrvs	r0, [r1], #512	; 0x200
     470:	0003f919 	andeq	pc, r3, r9, lsl r9	; <UNPREDICTABLE>
     474:	22870100 	addcs	r0, r7, #0, 2
     478:	00000266 	andeq	r0, r0, r6, ror #4
     47c:	19609102 	stmdbne	r0!, {r1, r8, ip, pc}^
     480:	000003f2 	strdeq	r0, [r0], -r2
     484:	a12f8701 			; <UNDEFINED> instruction: 0xa12f8701
     488:	02000002 	andeq	r0, r0, #2
     48c:	47195c91 			; <UNDEFINED> instruction: 0x47195c91
     490:	01000007 	tsteq	r0, r7
     494:	02664487 	rsbeq	r4, r6, #-2030043136	; 0x87000000
     498:	91020000 	mrsls	r0, (UNDEF: 2)
     49c:	00691d58 	rsbeq	r1, r9, r8, asr sp
     4a0:	19098901 	stmdbne	r9, {r0, r8, fp, pc}
     4a4:	02000003 	andeq	r0, r0, #3
     4a8:	441e7491 	ldrmi	r7, [lr], #-1169	; 0xfffffb6f
     4ac:	98000086 	stmdals	r0, {r1, r2, r7}
     4b0:	1d000000 	stcne	0, cr0, [r0, #-0]
     4b4:	9c01006a 	stcls	0, cr0, [r1], {106}	; 0x6a
     4b8:	0003190e 	andeq	r1, r3, lr, lsl #18
     4bc:	70910200 	addsvc	r0, r1, r0, lsl #4
     4c0:	00866c1e 	addeq	r6, r6, lr, lsl ip
     4c4:	00006000 	andeq	r6, r0, r0
     4c8:	00631d00 	rsbeq	r1, r3, r0, lsl #26
     4cc:	7d0e9e01 	stcvc	14, cr9, [lr, #-4]
     4d0:	02000002 	andeq	r0, r0, #2
     4d4:	00006f91 	muleq	r0, r1, pc	; <UNPREDICTABLE>
     4d8:	016f1b00 	cmneq	pc, r0, lsl #22
     4dc:	77010000 	strvc	r0, [r1, -r0]
     4e0:	0003c90b 	andeq	ip, r3, fp, lsl #18
     4e4:	00851000 	addeq	r1, r5, r0
     4e8:	00006000 	andeq	r6, r0, r0
     4ec:	e59c0100 	ldr	r0, [ip, #256]	; 0x100
     4f0:	1c000003 	stcne	0, cr0, [r0], {3}
     4f4:	0000024a 	andeq	r0, r0, sl, asr #4
     4f8:	0000028f 	andeq	r0, r0, pc, lsl #5
     4fc:	19749102 	ldmdbne	r4!, {r1, r8, ip, pc}^
     500:	000001c8 	andeq	r0, r0, r8, asr #3
     504:	9a257701 	bls	95e110 <_bss_end+0x9552fc>
     508:	02000002 	andeq	r0, r0, #2
     50c:	1b007391 	blne	1d358 <_bss_end+0x14544>
     510:	0000014b 	andeq	r0, r0, fp, asr #2
     514:	ff0b6a01 			; <UNDEFINED> instruction: 0xff0b6a01
     518:	bc000003 	stclt	0, cr0, [r0], {3}
     51c:	54000084 	strpl	r0, [r0], #-132	; 0xffffff7c
     520:	01000000 	mrseq	r0, (UNDEF: 0)
     524:	00043f9c 	muleq	r4, ip, pc	; <UNPREDICTABLE>
     528:	024a1c00 	subeq	r1, sl, #0, 24
     52c:	028f0000 	addeq	r0, pc, #0
     530:	91020000 	mrsls	r0, (UNDEF: 2)
     534:	756e1f74 	strbvc	r1, [lr, #-3956]!	; 0xfffff08c
     538:	6a01006d 	bvs	406f4 <_bss_end+0x378e0>
     53c:	0002662d 	andeq	r6, r2, sp, lsr #12
     540:	70910200 	addsvc	r0, r1, r0, lsl #4
     544:	00041720 	andeq	r1, r4, r0, lsr #14
     548:	236c0100 	cmncs	ip, #0, 2
     54c:	0000026d 	andeq	r0, r0, sp, ror #4
     550:	8db00305 	ldchi	3, cr0, [r0, #20]!
     554:	ff210000 			; <UNDEFINED> instruction: 0xff210000
     558:	01000003 	tsteq	r0, r3
     55c:	043f116e 	ldrteq	r1, [pc], #-366	; 564 <CPSR_IRQ_INHIBIT+0x4e4>
     560:	03050000 	movweq	r0, #20480	; 0x5000
     564:	00008df4 	strdeq	r8, [r0], -r4
     568:	027d2200 	rsbseq	r2, sp, #0, 4
     56c:	044f0000 	strbeq	r0, [pc], #-0	; 574 <CPSR_IRQ_INHIBIT+0x4f4>
     570:	66230000 	strtvs	r0, [r3], -r0
     574:	0f000002 	svceq	0x00000002
     578:	01272400 			; <UNDEFINED> instruction: 0x01272400
     57c:	63010000 	movwvs	r0, #4096	; 0x1000
     580:	0004690b 	andeq	r6, r4, fp, lsl #18
     584:	00848800 	addeq	r8, r4, r0, lsl #16
     588:	00003400 	andeq	r3, r0, r0, lsl #8
     58c:	859c0100 	ldrhi	r0, [ip, #256]	; 0x100
     590:	1c000004 	stcne	0, cr0, [r0], {4}
     594:	0000024a 	andeq	r0, r0, sl, asr #4
     598:	0000028f 	andeq	r0, r0, pc, lsl #5
     59c:	19749102 	ldmdbne	r4!, {r1, r8, ip, pc}^
     5a0:	000001d5 	ldrdeq	r0, [r0], -r5
     5a4:	32376301 	eorscc	r6, r7, #67108864	; 0x4000000
     5a8:	02000000 	andeq	r0, r0, #0
     5ac:	1b007091 	blne	1c7f8 <_bss_end+0x139e4>
     5b0:	00000103 	andeq	r0, r0, r3, lsl #2
     5b4:	9f0b5701 	svcls	0x000b5701
     5b8:	10000004 	andne	r0, r0, r4
     5bc:	78000084 	stmdavc	r0, {r2, r7}
     5c0:	01000000 	mrseq	r0, (UNDEF: 0)
     5c4:	0004d29c 	muleq	r4, ip, r2
     5c8:	024a1c00 	subeq	r1, sl, #0, 24
     5cc:	028f0000 	addeq	r0, pc, #0
     5d0:	91020000 	mrsls	r0, (UNDEF: 2)
     5d4:	74731f6c 	ldrbtvc	r1, [r3], #-3948	; 0xfffff094
     5d8:	57010072 	smlsdxpl	r1, r2, r0, r0
     5dc:	0002722c 	andeq	r7, r2, ip, lsr #4
     5e0:	68910200 	ldmvs	r1, {r9}
     5e4:	0084241e 	addeq	r2, r4, lr, lsl r4
     5e8:	00004c00 	andeq	r4, r0, r0, lsl #24
     5ec:	00691d00 	rsbeq	r1, r9, r0, lsl #26
     5f0:	66175901 	ldrvs	r5, [r7], -r1, lsl #18
     5f4:	02000002 	andeq	r0, r0, #2
     5f8:	00007491 	muleq	r0, r1, r4
     5fc:	0000df1b 	andeq	sp, r0, fp, lsl pc
     600:	0b450100 	bleq	1140a08 <_bss_end+0x1137bf4>
     604:	000004ec 	andeq	r0, r0, ip, ror #9
     608:	00008368 	andeq	r8, r0, r8, ror #6
     60c:	000000a8 	andeq	r0, r0, r8, lsr #1
     610:	05069c01 	streq	r9, [r6, #-3073]	; 0xfffff3ff
     614:	4a1c0000 	bmi	70061c <_bss_end+0x6f7808>
     618:	8f000002 	svchi	0x00000002
     61c:	02000002 	andeq	r0, r0, #2
     620:	631f7491 	tstvs	pc, #-1862270976	; 0x91000000
     624:	25450100 	strbcs	r0, [r5, #-256]	; 0xffffff00
     628:	0000027d 	andeq	r0, r0, sp, ror r2
     62c:	00739102 	rsbseq	r9, r3, r2, lsl #2
     630:	0001c724 	andeq	ip, r1, r4, lsr #14
     634:	06400100 	strbeq	r0, [r0], -r0, lsl #2
     638:	00000520 	andeq	r0, r0, r0, lsr #10
     63c:	00008820 	andeq	r8, r0, r0, lsr #16
     640:	0000002c 	andeq	r0, r0, ip, lsr #32
     644:	052d9c01 	streq	r9, [sp, #-3073]!	; 0xfffff3ff
     648:	4a1c0000 	bmi	700650 <_bss_end+0x6f783c>
     64c:	8f000002 	svchi	0x00000002
     650:	02000002 	andeq	r0, r0, #2
     654:	24007491 	strcs	r7, [r0], #-1169	; 0xfffffb6f
     658:	000001e1 	andeq	r0, r0, r1, ror #3
     65c:	47063001 	strmi	r3, [r6, -r1]
     660:	38000005 	stmdacc	r0, {r0, r2}
     664:	30000082 	andcc	r0, r0, r2, lsl #1
     668:	01000001 	tsteq	r0, r1
     66c:	00059d9c 	muleq	r5, ip, sp
     670:	024a1c00 	subeq	r1, sl, #0, 24
     674:	028f0000 	addeq	r0, pc, #0
     678:	91020000 	mrsls	r0, (UNDEF: 2)
     67c:	82482564 	subhi	r2, r8, #100, 10	; 0x19000000
     680:	00b00000 	adcseq	r0, r0, r0
     684:	05850000 	streq	r0, [r5]
     688:	791d0000 	ldmdbvc	sp, {}	; <UNPREDICTABLE>
     68c:	17320100 	ldrne	r0, [r2, -r0, lsl #2]!
     690:	00000266 	andeq	r0, r0, r6, ror #4
     694:	1e749102 	expnes	f1, f2
     698:	00008264 	andeq	r8, r0, r4, ror #4
     69c:	00000084 	andeq	r0, r0, r4, lsl #1
     6a0:	0100781d 	tsteq	r0, sp, lsl r8
     6a4:	02661b34 	rsbeq	r1, r6, #52, 22	; 0xd000
     6a8:	91020000 	mrsls	r0, (UNDEF: 2)
     6ac:	1e000070 	mcrne	0, 0, r0, cr0, cr0, {3}
     6b0:	000082f8 	strdeq	r8, [r0], -r8	; <UNPREDICTABLE>
     6b4:	00000060 	andeq	r0, r0, r0, rrx
     6b8:	0100781d 	tsteq	r0, sp, lsl r8
     6bc:	0266173a 	rsbeq	r1, r6, #15204352	; 0xe80000
     6c0:	91020000 	mrsls	r0, (UNDEF: 2)
     6c4:	1b00006c 	blne	87c <CPSR_IRQ_INHIBIT+0x7fc>
     6c8:	00000193 	muleq	r0, r3, r1
     6cc:	b7062101 	strlt	r2, [r6, -r1, lsl #2]
     6d0:	98000005 	stmdals	r0, {r0, r2}
     6d4:	88000087 	stmdahi	r0, {r0, r1, r2, r7}
     6d8:	01000000 	mrseq	r0, (UNDEF: 0)
     6dc:	0005c49c 	muleq	r5, ip, r4
     6e0:	024a1c00 	subeq	r1, sl, #0, 24
     6e4:	028f0000 	addeq	r0, pc, #0
     6e8:	91020000 	mrsls	r0, (UNDEF: 2)
     6ec:	c41b0074 	ldrgt	r0, [fp], #-116	; 0xffffff8c
     6f0:	01000000 	mrseq	r0, (UNDEF: 0)
     6f4:	05de0614 	ldrbeq	r0, [lr, #1556]	; 0x614
     6f8:	81900000 	orrshi	r0, r0, r0
     6fc:	00a80000 	adceq	r0, r8, r0
     700:	9c010000 	stcls	0, cr0, [r1], {-0}
     704:	00000619 	andeq	r0, r0, r9, lsl r6
     708:	00024a1c 	andeq	r4, r2, ip, lsl sl
     70c:	00028f00 	andeq	r8, r2, r0, lsl #30
     710:	6c910200 	lfmvs	f0, 4, [r1], {0}
     714:	0081a81e 	addeq	sl, r1, lr, lsl r8
     718:	00008400 	andeq	r8, r0, r0, lsl #8
     71c:	00791d00 	rsbseq	r1, r9, r0, lsl #26
     720:	66171801 	ldrvs	r1, [r7], -r1, lsl #16
     724:	02000002 	andeq	r0, r0, #2
     728:	c41e7491 	ldrgt	r7, [lr], #-1169	; 0xfffffb6f
     72c:	58000081 	stmdapl	r0, {r0, r7}
     730:	1d000000 	stcne	0, cr0, [r0, #-0]
     734:	1a010078 	bne	4091c <_bss_end+0x37b08>
     738:	0002661b 	andeq	r6, r2, fp, lsl r6
     73c:	70910200 	addsvc	r0, r1, r0, lsl #4
     740:	24000000 	strcs	r0, [r0], #-0
     744:	000001ad 	andeq	r0, r0, sp, lsr #3
     748:	33060e01 	movwcc	r0, #28161	; 0x6e01
     74c:	60000006 	andvs	r0, r0, r6
     750:	38000087 	stmdacc	r0, {r0, r1, r2, r7}
     754:	01000000 	mrseq	r0, (UNDEF: 0)
     758:	0006409c 	muleq	r6, ip, r0
     75c:	024a1c00 	subeq	r1, sl, #0, 24
     760:	028f0000 	addeq	r0, pc, #0
     764:	91020000 	mrsls	r0, (UNDEF: 2)
     768:	96260074 			; <UNDEFINED> instruction: 0x96260074
     76c:	01000000 	mrseq	r0, (UNDEF: 0)
     770:	06510105 	ldrbeq	r0, [r1], -r5, lsl #2
     774:	7f000000 	svcvc	0x00000000
     778:	27000006 	strcs	r0, [r0, -r6]
     77c:	0000024a 	andeq	r0, r0, sl, asr #4
     780:	0000028f 	andeq	r0, r0, pc, lsl #5
     784:	0002b828 	andeq	fp, r2, r8, lsr #16
     788:	21050100 	mrscs	r0, (UNDEF: 21)
     78c:	00000266 	andeq	r0, r0, r6, ror #4
     790:	00034a28 	andeq	r4, r3, r8, lsr #20
     794:	41050100 	mrsmi	r0, (UNDEF: 21)
     798:	00000266 	andeq	r0, r0, r6, ror #4
     79c:	00030a28 	andeq	r0, r3, r8, lsr #20
     7a0:	55050100 	strpl	r0, [r5, #-256]	; 0xffffff00
     7a4:	00000266 	andeq	r0, r0, r6, ror #4
     7a8:	06402900 	strbeq	r2, [r0], -r0, lsl #18
     7ac:	01f90000 	mvnseq	r0, r0
     7b0:	06960000 	ldreq	r0, [r6], r0
     7b4:	81180000 	tsthi	r8, r0
     7b8:	00780000 	rsbseq	r0, r8, r0
     7bc:	9c010000 	stcls	0, cr0, [r1], {-0}
     7c0:	0006512a 	andeq	r5, r6, sl, lsr #2
     7c4:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     7c8:	00065a2a 	andeq	r5, r6, sl, lsr #20
     7cc:	70910200 	addsvc	r0, r1, r0, lsl #4
     7d0:	0006662a 	andeq	r6, r6, sl, lsr #12
     7d4:	6c910200 	lfmvs	f0, 4, [r1], {0}
     7d8:	0006722a 	andeq	r7, r6, sl, lsr #4
     7dc:	68910200 	ldmvs	r1, {r9}
     7e0:	04090000 	streq	r0, [r9], #-0
     7e4:	00040000 	andeq	r0, r4, r0
     7e8:	00000378 	andeq	r0, r0, r8, ror r3
     7ec:	00880104 	addeq	r0, r8, r4, lsl #2
     7f0:	e1040000 	mrs	r0, (UNDEF: 4)
     7f4:	1c000004 	stcne	0, cr0, [r0], {4}
     7f8:	4c000001 	stcmi	0, cr0, [r0], {1}
     7fc:	e8000088 	stmda	r0, {r3, r7}
     800:	8a000001 	bhi	80c <CPSR_IRQ_INHIBIT+0x78c>
     804:	02000004 	andeq	r0, r0, #4
     808:	000002ca 	andeq	r0, r0, sl, asr #5
     80c:	07030218 	smladeq	r3, r8, r2, r0
     810:	00000266 	andeq	r0, r0, r6, ror #4
     814:	00025d03 	andeq	r5, r2, r3, lsl #26
     818:	66040700 	strvs	r0, [r4], -r0, lsl #14
     81c:	02000002 	andeq	r0, r0, #2
     820:	52011006 	andpl	r1, r1, #6
     824:	04000000 	streq	r0, [r0], #-0
     828:	00584548 	subseq	r4, r8, r8, asr #10
     82c:	45440410 	strbmi	r0, [r4, #-1040]	; 0xfffffbf0
     830:	000a0043 	andeq	r0, sl, r3, asr #32
     834:	00003205 	andeq	r3, r0, r5, lsl #4
     838:	026a0600 	rsbeq	r0, sl, #0, 12
     83c:	02080000 	andeq	r0, r8, #0
     840:	007b0c24 	rsbseq	r0, fp, r4, lsr #24
     844:	79070000 	stmdbvc	r7, {}	; <UNPREDICTABLE>
     848:	16260200 	strtne	r0, [r6], -r0, lsl #4
     84c:	00000266 	andeq	r0, r0, r6, ror #4
     850:	00780700 	rsbseq	r0, r8, r0, lsl #14
     854:	66162702 	ldrvs	r2, [r6], -r2, lsl #14
     858:	04000002 	streq	r0, [r0], #-2
     85c:	03bc0800 			; <UNDEFINED> instruction: 0x03bc0800
     860:	0c020000 	stceq	0, cr0, [r2], {-0}
     864:	0000521b 	andeq	r5, r0, fp, lsl r2
     868:	090a0100 	stmdbeq	sl, {r8}
     86c:	0000031a 	andeq	r0, r0, sl, lsl r3
     870:	73280d02 			; <UNDEFINED> instruction: 0x73280d02
     874:	01000002 	tsteq	r0, r2
     878:	0002ca0a 	andeq	ip, r2, sl, lsl #20
     87c:	0e100200 	cdpeq	2, 1, cr0, cr0, cr0, {0}
     880:	00000394 	muleq	r0, r4, r3
     884:	00000284 	andeq	r0, r0, r4, lsl #5
     888:	0000af01 	andeq	sl, r0, r1, lsl #30
     88c:	0000c400 	andeq	ip, r0, r0, lsl #8
     890:	02840b00 	addeq	r0, r4, #0, 22
     894:	660c0000 	strvs	r0, [ip], -r0
     898:	0c000002 	stceq	0, cr0, [r0], {2}
     89c:	00000266 	andeq	r0, r0, r6, ror #4
     8a0:	0002660c 	andeq	r6, r2, ip, lsl #12
     8a4:	f30d0000 	vhadd.u8	d0, d13, d0
     8a8:	02000001 	andeq	r0, r0, #1
     8ac:	03a70a12 			; <UNDEFINED> instruction: 0x03a70a12
     8b0:	d9010000 	stmdble	r1, {}	; <UNPREDICTABLE>
     8b4:	df000000 	svcle	0x00000000
     8b8:	0b000000 	bleq	8c0 <CPSR_IRQ_INHIBIT+0x840>
     8bc:	00000284 	andeq	r0, r0, r4, lsl #5
     8c0:	02d30e00 	sbcseq	r0, r3, #0, 28
     8c4:	14020000 	strne	r0, [r2], #-0
     8c8:	0003370f 	andeq	r3, r3, pc, lsl #14
     8cc:	00028a00 	andeq	r8, r2, r0, lsl #20
     8d0:	00f80100 	rscseq	r0, r8, r0, lsl #2
     8d4:	01030000 	mrseq	r0, (UNDEF: 3)
     8d8:	840b0000 	strhi	r0, [fp], #-0
     8dc:	0c000002 	stceq	0, cr0, [r0], {2}
     8e0:	00000278 	andeq	r0, r0, r8, ror r2
     8e4:	02d30e00 	sbcseq	r0, r3, #0, 28
     8e8:	15020000 	strne	r0, [r2, #-0]
     8ec:	0002de0f 	andeq	sp, r2, pc, lsl #28
     8f0:	00028a00 	andeq	r8, r2, r0, lsl #20
     8f4:	011c0100 	tsteq	ip, r0, lsl #2
     8f8:	01270000 			; <UNDEFINED> instruction: 0x01270000
     8fc:	840b0000 	strhi	r0, [fp], #-0
     900:	0c000002 	stceq	0, cr0, [r0], {2}
     904:	0000026d 	andeq	r0, r0, sp, ror #4
     908:	02d30e00 	sbcseq	r0, r3, #0, 28
     90c:	16020000 	strne	r0, [r2], -r0
     910:	0003d00f 	andeq	sp, r3, pc
     914:	00028a00 	andeq	r8, r2, r0, lsl #20
     918:	01400100 	mrseq	r0, (UNDEF: 80)
     91c:	014b0000 	mrseq	r0, (UNDEF: 75)
     920:	840b0000 	strhi	r0, [fp], #-0
     924:	0c000002 	stceq	0, cr0, [r0], {2}
     928:	00000032 	andeq	r0, r0, r2, lsr r0
     92c:	02d30e00 	sbcseq	r0, r3, #0, 28
     930:	17020000 	strne	r0, [r2, -r0]
     934:	0003660f 	andeq	r6, r3, pc, lsl #12
     938:	00028a00 	andeq	r8, r2, r0, lsl #20
     93c:	01640100 	cmneq	r4, r0, lsl #2
     940:	016f0000 	cmneq	pc, r0
     944:	840b0000 	strhi	r0, [fp], #-0
     948:	0c000002 	stceq	0, cr0, [r0], {2}
     94c:	00000266 	andeq	r0, r0, r6, ror #4
     950:	02d30e00 	sbcseq	r0, r3, #0, 28
     954:	18020000 	stmdane	r2, {}	; <UNPREDICTABLE>
     958:	0003260f 	andeq	r2, r3, pc, lsl #12
     95c:	00028a00 	andeq	r8, r2, r0, lsl #20
     960:	01880100 	orreq	r0, r8, r0, lsl #2
     964:	01930000 	orrseq	r0, r3, r0
     968:	840b0000 	strhi	r0, [fp], #-0
     96c:	0c000002 	stceq	0, cr0, [r0], {2}
     970:	00000290 	muleq	r0, r0, r2
     974:	024f0f00 	subeq	r0, pc, #0, 30
     978:	1b020000 	blne	80980 <_bss_end+0x77b6c>
     97c:	00020c11 	andeq	r0, r2, r1, lsl ip
     980:	0001a700 	andeq	sl, r1, r0, lsl #14
     984:	0001ad00 	andeq	sl, r1, r0, lsl #26
     988:	02840b00 	addeq	r0, r4, #0, 22
     98c:	0f000000 	svceq	0x00000000
     990:	0000022f 	andeq	r0, r0, pc, lsr #4
     994:	77111c02 	ldrvc	r1, [r1, -r2, lsl #24]
     998:	c1000003 	tstgt	r0, r3
     99c:	c7000001 	strgt	r0, [r0, -r1]
     9a0:	0b000001 	bleq	9ac <CPSR_IRQ_INHIBIT+0x92c>
     9a4:	00000284 	andeq	r0, r0, r4, lsl #5
     9a8:	01e10f00 	mvneq	r0, r0, lsl #30
     9ac:	1d020000 	stcne	0, cr0, [r2, #-0]
     9b0:	00027411 	andeq	r7, r2, r1, lsl r4
     9b4:	0001db00 	andeq	sp, r1, r0, lsl #22
     9b8:	0001e100 	andeq	lr, r1, r0, lsl #2
     9bc:	02840b00 	addeq	r0, r4, #0, 22
     9c0:	0f000000 	svceq	0x00000000
     9c4:	000001c1 	andeq	r0, r0, r1, asr #3
     9c8:	500a1f02 	andpl	r1, sl, r2, lsl #30
     9cc:	f5000003 			; <UNDEFINED> instruction: 0xf5000003
     9d0:	fb000001 	blx	9de <CPSR_IRQ_INHIBIT+0x95e>
     9d4:	0b000001 	bleq	9e0 <CPSR_IRQ_INHIBIT+0x960>
     9d8:	00000284 	andeq	r0, r0, r4, lsl #5
     9dc:	022a0f00 	eoreq	r0, sl, #0, 30
     9e0:	21020000 	mrscs	r0, (UNDEF: 2)
     9e4:	0002f10a 	andeq	pc, r2, sl, lsl #2
     9e8:	00020f00 	andeq	r0, r2, r0, lsl #30
     9ec:	00022400 	andeq	r2, r2, r0, lsl #8
     9f0:	02840b00 	addeq	r0, r4, #0, 22
     9f4:	660c0000 	strvs	r0, [ip], -r0
     9f8:	0c000002 	stceq	0, cr0, [r0], {2}
     9fc:	00000297 	muleq	r0, r7, r2
     a00:	0002660c 	andeq	r6, r2, ip, lsl #12
     a04:	96100000 	ldrls	r0, [r0], -r0
     a08:	02000002 	andeq	r0, r0, #2
     a0c:	02a3232b 	adceq	r2, r3, #-1409286144	; 0xac000000
     a10:	10000000 	andne	r0, r0, r0
     a14:	00000348 	andeq	r0, r0, r8, asr #6
     a18:	66122c02 	ldrvs	r2, [r2], -r2, lsl #24
     a1c:	04000002 	streq	r0, [r0], #-2
     a20:	00030810 	andeq	r0, r3, r0, lsl r8
     a24:	122d0200 	eorne	r0, sp, #0, 4
     a28:	00000266 	andeq	r0, r0, r6, ror #4
     a2c:	03111008 	tsteq	r1, #8
     a30:	2e020000 	cdpcs	0, 0, cr0, cr2, cr0, {0}
     a34:	0000570f 	andeq	r5, r0, pc, lsl #14
     a38:	d3100c00 	tstle	r0, #0, 24
     a3c:	02000001 	andeq	r0, r0, #1
     a40:	0032122f 	eorseq	r1, r2, pc, lsr #4
     a44:	00140000 	andseq	r0, r4, r0
     a48:	57070411 	smladpl	r7, r1, r4, r0
     a4c:	1200000a 	andne	r0, r0, #10
     a50:	00027f04 	andeq	r7, r2, r4, lsl #30
     a54:	026d0500 	rsbeq	r0, sp, #0, 10
     a58:	01110000 	tsteq	r1, r0
     a5c:	00024508 	andeq	r4, r2, r8, lsl #10
     a60:	02780500 	rsbseq	r0, r8, #0, 10
     a64:	04120000 	ldreq	r0, [r2], #-0
     a68:	00000025 	andeq	r0, r0, r5, lsr #32
     a6c:	00250413 	eoreq	r0, r5, r3, lsl r4
     a70:	01110000 	tsteq	r1, r0
     a74:	0001ce02 	andeq	ip, r1, r2, lsl #28
     a78:	78041200 	stmdavc	r4, {r9, ip}
     a7c:	12000002 	andne	r0, r0, #2
     a80:	0002af04 	andeq	sl, r2, r4, lsl #30
     a84:	029d0500 	addseq	r0, sp, #0, 10
     a88:	01110000 	tsteq	r1, r0
     a8c:	00023c08 	andeq	r3, r2, r8, lsl #24
     a90:	02a81400 	adceq	r1, r8, #0, 8
     a94:	af150000 	svcge	0x00150000
     a98:	02000002 	andeq	r0, r0, #2
     a9c:	00251132 	eoreq	r1, r5, r2, lsr r1
     aa0:	31160000 	tstcc	r6, r0
     aa4:	01000005 	tsteq	r0, r5
     aa8:	03831014 	orreq	r1, r3, #20
     aac:	891c0000 	ldmdbhi	ip, {}	; <UNPREDICTABLE>
     ab0:	01180000 	tsteq	r8, r0
     ab4:	9c010000 	stcls	0, cr0, [r1], {-0}
     ab8:	00000383 	andeq	r0, r0, r3, lsl #7
     abc:	0004ba17 	andeq	fp, r4, r7, lsl sl
     ac0:	0b180100 	bleq	600ec8 <_bss_end+0x5f80b4>
     ac4:	0000038a 	andeq	r0, r0, sl, lsl #7
     ac8:	17749102 	ldrbne	r9, [r4, -r2, lsl #2]!
     acc:	000004c5 	andeq	r0, r0, r5, asr #9
     ad0:	8a0b1901 	bhi	2c6edc <_bss_end+0x2be0c8>
     ad4:	02000003 	andeq	r0, r0, #3
     ad8:	3e176c91 	mrccc	12, 0, r6, cr7, cr1, {4}
     adc:	01000005 	tsteq	r0, r5
     ae0:	038a0b1b 	orreq	r0, sl, #27648	; 0x6c00
     ae4:	91020000 	mrsls	r0, (UNDEF: 2)
     ae8:	6e6f1868 	cdpvs	8, 6, cr1, cr15, cr8, {3}
     aec:	1d010065 	stcne	0, cr0, [r1, #-404]	; 0xfffffe6c
     af0:	00038a0b 	andeq	r8, r3, fp, lsl #20
     af4:	64910200 	ldrvs	r0, [r1], #512	; 0x200
     af8:	0004cf17 	andeq	ip, r4, r7, lsl pc
     afc:	0b1e0100 	bleq	780f04 <_bss_end+0x7780f0>
     b00:	0000038a 	andeq	r0, r0, sl, lsl #7
     b04:	17609102 	strbne	r9, [r0, -r2, lsl #2]!
     b08:	00000543 	andeq	r0, r0, r3, asr #10
     b0c:	8a0b1f01 	bhi	2c8718 <_bss_end+0x2bf904>
     b10:	02000003 	andeq	r0, r0, #3
     b14:	74185c91 	ldrvc	r5, [r8], #-3217	; 0xfffff36f
     b18:	01006f77 	tsteq	r0, r7, ror pc
     b1c:	038a0b20 	orreq	r0, sl, #32, 22	; 0x8000
     b20:	91020000 	mrsls	r0, (UNDEF: 2)
     b24:	89681958 	stmdbhi	r8!, {r3, r4, r6, r8, fp, ip}^
     b28:	00b80000 	adcseq	r0, r8, r0
     b2c:	c8170000 	ldmdagt	r7, {}	; <UNPREDICTABLE>
     b30:	01000001 	tsteq	r0, r1
     b34:	038a0f24 	orreq	r0, sl, #36, 30	; 0x90
     b38:	91020000 	mrsls	r0, (UNDEF: 2)
     b3c:	04a11754 	strteq	r1, [r1], #1876	; 0x754
     b40:	25010000 	strcs	r0, [r1, #-0]
     b44:	0003830d 	andeq	r8, r3, sp, lsl #6
     b48:	50910200 	addspl	r0, r1, r0, lsl #4
     b4c:	00899419 	addeq	r9, r9, r9, lsl r4
     b50:	00003400 	andeq	r3, r0, r0, lsl #8
     b54:	00691800 	rsbeq	r1, r9, r0, lsl #16
     b58:	83122701 	tsthi	r2, #262144	; 0x40000
     b5c:	02000003 	andeq	r0, r0, #3
     b60:	00007091 	muleq	r0, r1, r0
     b64:	05041a00 	streq	r1, [r4, #-2560]	; 0xfffff600
     b68:	00746e69 	rsbseq	r6, r4, r9, ror #28
     b6c:	54040411 	strpl	r0, [r4], #-1041	; 0xfffffbef
     b70:	1b000007 	blne	b94 <CPSR_IRQ_INHIBIT+0xb14>
     b74:	000004d6 	ldrdeq	r0, [r0], -r6
     b78:	aa070301 	bge	1c1784 <_bss_end+0x1b8970>
     b7c:	8a000004 	bhi	b94 <CPSR_IRQ_INHIBIT+0xb14>
     b80:	4c000003 	stcmi	0, cr0, [r0], {3}
     b84:	d0000088 	andle	r0, r0, r8, lsl #1
     b88:	01000000 	mrseq	r0, (UNDEF: 0)
     b8c:	00781c9c 			; <UNDEFINED> instruction: 0x00781c9c
     b90:	8a180301 	bhi	60179c <_bss_end+0x5f8988>
     b94:	02000003 	andeq	r0, r0, #3
     b98:	2a175c91 	bcs	5d7de4 <_bss_end+0x5cefd0>
     b9c:	01000005 	tsteq	r0, r5
     ba0:	038a0b05 	orreq	r0, sl, #5120	; 0x1400
     ba4:	91020000 	mrsls	r0, (UNDEF: 2)
     ba8:	05501774 	ldrbeq	r1, [r0, #-1908]	; 0xfffff88c
     bac:	06010000 	streq	r0, [r1], -r0
     bb0:	00038a0b 	andeq	r8, r3, fp, lsl #20
     bb4:	70910200 	addsvc	r0, r1, r0, lsl #4
     bb8:	0004c017 	andeq	ip, r4, r7, lsl r0
     bbc:	0b070100 	bleq	1c0fc4 <_bss_end+0x1b81b0>
     bc0:	0000038a 	andeq	r0, r0, sl, lsl #7
     bc4:	176c9102 	strbne	r9, [ip, -r2, lsl #2]!
     bc8:	00000555 	andeq	r0, r0, r5, asr r5
     bcc:	8a0b0801 	bhi	2c2bd8 <_bss_end+0x2b9dc4>
     bd0:	02000003 	andeq	r0, r0, #3
     bd4:	7c196491 	cfldrsvc	mvf6, [r9], {145}	; 0x91
     bd8:	88000088 	stmdahi	r0, {r3, r7}
     bdc:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
     be0:	0a010069 	beq	40d8c <_bss_end+0x37f78>
     be4:	0003830e 	andeq	r8, r3, lr, lsl #6
     be8:	68910200 	ldmvs	r1, {r9}
     bec:	22000000 	andcs	r0, r0, #0
     bf0:	02000000 	andeq	r0, r0, #0
     bf4:	00055700 	andeq	r5, r5, r0, lsl #14
     bf8:	0e010400 	cfcpyseq	mvf0, mvf1
     bfc:	00000006 	andeq	r0, r0, r6
     c00:	40000080 	andmi	r0, r0, r0, lsl #1
     c04:	5f000080 	svcpl	0x00000080
     c08:	1c000005 	stcne	0, cr0, [r0], {5}
     c0c:	a7000001 	strge	r0, [r0, -r1]
     c10:	01000005 	tsteq	r0, r5
     c14:	00014b80 	andeq	r4, r1, r0, lsl #23
     c18:	6b000400 	blvs	1c20 <CPSR_IRQ_INHIBIT+0x1ba0>
     c1c:	04000005 	streq	r0, [r0], #-5
     c20:	00008801 	andeq	r8, r0, r1, lsl #16
     c24:	061a0400 	ldreq	r0, [sl], -r0, lsl #8
     c28:	011c0000 	tsteq	ip, r0
     c2c:	8a340000 	bhi	d00c34 <_bss_end+0xcf7e20>
     c30:	01180000 	tsteq	r8, r0
     c34:	06940000 	ldreq	r0, [r4], r0
     c38:	b3020000 	movwlt	r0, #8192	; 0x2000
     c3c:	01000005 	tsteq	r0, r5
     c40:	00310702 	eorseq	r0, r1, r2, lsl #14
     c44:	04030000 	streq	r0, [r3], #-0
     c48:	00000037 	andeq	r0, r0, r7, lsr r0
     c4c:	067e0204 	ldrbteq	r0, [lr], -r4, lsl #4
     c50:	03010000 	movweq	r0, #4096	; 0x1000
     c54:	00003107 	andeq	r3, r0, r7, lsl #2
     c58:	05bc0500 	ldreq	r0, [ip, #1280]!	; 0x500
     c5c:	06010000 	streq	r0, [r1], -r0
     c60:	00005010 	andeq	r5, r0, r0, lsl r0
     c64:	05040600 	streq	r0, [r4, #-1536]	; 0xfffffa00
     c68:	00746e69 	rsbseq	r6, r4, r9, ror #28
     c6c:	00060305 	andeq	r0, r6, r5, lsl #6
     c70:	10080100 	andne	r0, r8, r0, lsl #2
     c74:	00000050 	andeq	r0, r0, r0, asr r0
     c78:	00002507 	andeq	r2, r0, r7, lsl #10
     c7c:	00007600 	andeq	r7, r0, r0, lsl #12
     c80:	00760800 	rsbseq	r0, r6, r0, lsl #16
     c84:	ffff0000 			; <UNDEFINED> instruction: 0xffff0000
     c88:	0900ffff 	stmdbeq	r0, {r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, fp, ip, sp, lr, pc}
     c8c:	0a570704 	beq	15c28a4 <_bss_end+0x15b9a90>
     c90:	da050000 	ble	140c98 <_bss_end+0x137e84>
     c94:	01000005 	tsteq	r0, r5
     c98:	0063150b 	rsbeq	r1, r3, fp, lsl #10
     c9c:	cd050000 	stcgt	0, cr0, [r5, #-0]
     ca0:	01000005 	tsteq	r0, r5
     ca4:	0063150d 	rsbeq	r1, r3, sp, lsl #10
     ca8:	38070000 	stmdacc	r7, {}	; <UNPREDICTABLE>
     cac:	a8000000 	stmdage	r0, {}	; <UNPREDICTABLE>
     cb0:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
     cb4:	00000076 	andeq	r0, r0, r6, ror r0
     cb8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
     cbc:	060c0500 	streq	r0, [ip], -r0, lsl #10
     cc0:	10010000 	andne	r0, r1, r0
     cc4:	00009515 	andeq	r9, r0, r5, lsl r5
     cc8:	05e80500 	strbeq	r0, [r8, #1280]!	; 0x500
     ccc:	12010000 	andne	r0, r1, #0
     cd0:	00009515 	andeq	r9, r0, r5, lsl r5
     cd4:	05f50a00 	ldrbeq	r0, [r5, #2560]!	; 0xa00
     cd8:	2b010000 	blcs	40ce0 <_bss_end+0x37ecc>
     cdc:	00005010 	andeq	r5, r0, r0, lsl r0
     ce0:	008af400 	addeq	pc, sl, r0, lsl #8
     ce4:	00005800 	andeq	r5, r0, r0, lsl #16
     ce8:	ea9c0100 	b	fe7010f0 <_bss_end+0xfe6f82dc>
     cec:	0b000000 	bleq	cf4 <CPSR_IRQ_INHIBIT+0xc74>
     cf0:	000005c7 	andeq	r0, r0, r7, asr #11
     cf4:	ea0f2d01 	b	3cc100 <_bss_end+0x3c32ec>
     cf8:	02000000 	andeq	r0, r0, #0
     cfc:	03007491 	movweq	r7, #1169	; 0x491
     d00:	00003804 	andeq	r3, r0, r4, lsl #16
     d04:	06710a00 	ldrbteq	r0, [r1], -r0, lsl #20
     d08:	1f010000 	svcne	0x00010000
     d0c:	00005010 	andeq	r5, r0, r0, lsl r0
     d10:	008a9c00 	addeq	r9, sl, r0, lsl #24
     d14:	00005800 	andeq	r5, r0, r0, lsl #16
     d18:	1a9c0100 	bne	fe701120 <_bss_end+0xfe6f830c>
     d1c:	0b000001 	bleq	d28 <CPSR_IRQ_INHIBIT+0xca8>
     d20:	000005c7 	andeq	r0, r0, r7, asr #11
     d24:	1a0f2101 	bne	3c9130 <_bss_end+0x3c031c>
     d28:	02000001 	andeq	r0, r0, #1
     d2c:	03007491 	movweq	r7, #1169	; 0x491
     d30:	00002504 	andeq	r2, r0, r4, lsl #10
     d34:	06660c00 	strbteq	r0, [r6], -r0, lsl #24
     d38:	14010000 	strne	r0, [r1], #-0
     d3c:	00005010 	andeq	r5, r0, r0, lsl r0
     d40:	008a3400 	addeq	r3, sl, r0, lsl #8
     d44:	00006800 	andeq	r6, r0, r0, lsl #16
     d48:	489c0100 	ldmmi	ip, {r8}
     d4c:	0d000001 	stceq	0, cr0, [r0, #-4]
     d50:	16010069 	strne	r0, [r1], -r9, rrx
     d54:	0001480a 	andeq	r4, r1, sl, lsl #16
     d58:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     d5c:	50040300 	andpl	r0, r4, r0, lsl #6
     d60:	00000000 	andeq	r0, r0, r0
     d64:	00000022 	andeq	r0, r0, r2, lsr #32
     d68:	06310002 	ldrteq	r0, [r1], -r2
     d6c:	01040000 	mrseq	r0, (UNDEF: 4)
     d70:	0000077b 	andeq	r0, r0, fp, ror r7
     d74:	00008b4c 	andeq	r8, r0, ip, asr #22
     d78:	00008d58 	andeq	r8, r0, r8, asr sp
     d7c:	00000687 	andeq	r0, r0, r7, lsl #13
     d80:	000006b7 			; <UNDEFINED> instruction: 0x000006b7
     d84:	0000071f 	andeq	r0, r0, pc, lsl r7
     d88:	00228001 	eoreq	r8, r2, r1
     d8c:	00020000 	andeq	r0, r2, r0
     d90:	00000645 	andeq	r0, r0, r5, asr #12
     d94:	07f80104 	ldrbeq	r0, [r8, r4, lsl #2]!
     d98:	8d580000 	ldclhi	0, cr0, [r8, #-0]
     d9c:	8d5c0000 	ldclhi	0, cr0, [ip, #-0]
     da0:	06870000 	streq	r0, [r7], r0
     da4:	06b70000 	ldrteq	r0, [r7], r0
     da8:	071f0000 	ldreq	r0, [pc, -r0]
     dac:	80010000 	andhi	r0, r1, r0
     db0:	0000032a 	andeq	r0, r0, sl, lsr #6
     db4:	06590004 	ldrbeq	r0, [r9], -r4
     db8:	01040000 	mrseq	r0, (UNDEF: 4)
     dbc:	00000855 	andeq	r0, r0, r5, asr r8
     dc0:	000a0e0c 	andeq	r0, sl, ip, lsl #28
     dc4:	0006b700 	andeq	fp, r6, r0, lsl #14
     dc8:	00085800 	andeq	r5, r8, r0, lsl #16
     dcc:	05040200 	streq	r0, [r4, #-512]	; 0xfffffe00
     dd0:	00746e69 	rsbseq	r6, r4, r9, ror #28
     dd4:	57070403 	strpl	r0, [r7, -r3, lsl #8]
     dd8:	0300000a 	movweq	r0, #10
     ddc:	01a80508 			; <UNDEFINED> instruction: 0x01a80508
     de0:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
     de4:	000a0204 	andeq	r0, sl, r4, lsl #4
     de8:	08010300 	stmdaeq	r1, {r8, r9}
     dec:	0000023c 	andeq	r0, r0, ip, lsr r2
     df0:	3e060103 	adfccs	f0, f6, f3
     df4:	04000002 	streq	r0, [r0], #-2
     df8:	00000bed 	andeq	r0, r0, sp, ror #23
     dfc:	00390107 	eorseq	r0, r9, r7, lsl #2
     e00:	17010000 	strne	r0, [r1, -r0]
     e04:	0001d406 	andeq	sp, r1, r6, lsl #8
     e08:	075a0500 	ldrbeq	r0, [sl, -r0, lsl #10]
     e0c:	05000000 	streq	r0, [r0, #-0]
     e10:	00000c9c 	muleq	r0, ip, ip
     e14:	09370501 	ldmdbeq	r7!, {r0, r8, sl}
     e18:	05020000 	streq	r0, [r2, #-0]
     e1c:	000009f5 	strdeq	r0, [r0], -r5
     e20:	0c060503 	cfstr32eq	mvfx0, [r6], {3}
     e24:	05040000 	streq	r0, [r4, #-0]
     e28:	00000cac 	andeq	r0, r0, ip, lsr #25
     e2c:	0c1c0505 	cfldr32eq	mvfx0, [ip], {5}
     e30:	05060000 	streq	r0, [r6, #-0]
     e34:	00000a3e 	andeq	r0, r0, lr, lsr sl
     e38:	0b970507 	bleq	fe5c225c <_bss_end+0xfe5b9448>
     e3c:	05080000 	streq	r0, [r8, #-0]
     e40:	00000ba5 	andeq	r0, r0, r5, lsr #23
     e44:	0bb30509 	bleq	fecc2270 <_bss_end+0xfecb945c>
     e48:	050a0000 	streq	r0, [sl, #-0]
     e4c:	00000aba 			; <UNDEFINED> instruction: 0x00000aba
     e50:	0aaa050b 	beq	fea82284 <_bss_end+0xfea79470>
     e54:	050c0000 	streq	r0, [ip, #-0]
     e58:	00000776 	andeq	r0, r0, r6, ror r7
     e5c:	0799050d 	ldreq	r0, [r9, sp, lsl #10]
     e60:	050e0000 	streq	r0, [lr, #-0]
     e64:	00000a9b 	muleq	r0, fp, sl
     e68:	0c5f050f 	cfldr64eq	mvdx0, [pc], {15}
     e6c:	05100000 	ldreq	r0, [r0, #-0]
     e70:	00000bdc 	ldrdeq	r0, [r0], -ip
     e74:	0c500511 	cfldr64eq	mvdx0, [r0], {17}
     e78:	05120000 	ldreq	r0, [r2, #-0]
     e7c:	00000846 	andeq	r0, r0, r6, asr #16
     e80:	07c30513 	bfieq	r0, r3, (invalid: 10:3)
     e84:	05140000 	ldreq	r0, [r4, #-0]
     e88:	0000078d 	andeq	r0, r0, sp, lsl #15
     e8c:	0b390515 	bleq	e422e8 <_bss_end+0xe394d4>
     e90:	05160000 	ldreq	r0, [r6, #-0]
     e94:	000007fa 	strdeq	r0, [r0], -sl
     e98:	072b0517 			; <UNDEFINED> instruction: 0x072b0517
     e9c:	05180000 	ldreq	r0, [r8, #-0]
     ea0:	00000c42 	andeq	r0, r0, r2, asr #24
     ea4:	0a640519 	beq	1902310 <_bss_end+0x18f94fc>
     ea8:	051a0000 	ldreq	r0, [sl, #-0]
     eac:	00000b51 	andeq	r0, r0, r1, asr fp
     eb0:	07ce051b 	bfieq	r0, fp, #10, #5
     eb4:	051c0000 	ldreq	r0, [ip, #-0]
     eb8:	000009da 	ldrdeq	r0, [r0], -sl
     ebc:	0929051d 	stmdbeq	r9!, {r0, r2, r3, r4, r8, sl}
     ec0:	051e0000 	ldreq	r0, [lr, #-0]
     ec4:	00000bce 	andeq	r0, r0, lr, asr #23
     ec8:	0c2a051f 	cfstr32eq	mvfx0, [sl], #-124	; 0xffffff84
     ecc:	05200000 	streq	r0, [r0, #-0]!
     ed0:	00000c6b 	andeq	r0, r0, fp, ror #24
     ed4:	0c790521 	cfldr64eq	mvdx0, [r9], #-132	; 0xffffff7c
     ed8:	05220000 	streq	r0, [r2, #-0]!
     edc:	00000a7b 	andeq	r0, r0, fp, ror sl
     ee0:	099e0523 	ldmibeq	lr, {r0, r1, r5, r8, sl}
     ee4:	05240000 	streq	r0, [r4, #-0]!
     ee8:	000007dd 	ldrdeq	r0, [r0], -sp
     eec:	0a310525 	beq	c42388 <_bss_end+0xc39574>
     ef0:	05260000 	streq	r0, [r6, #-0]!
     ef4:	00000943 	andeq	r0, r0, r3, asr #18
     ef8:	0bf90527 	bleq	ffe4239c <_bss_end+0xffe39588>
     efc:	05280000 	streq	r0, [r8, #-0]!
     f00:	00000953 	andeq	r0, r0, r3, asr r9
     f04:	09620529 	stmdbeq	r2!, {r0, r3, r5, r8, sl}^
     f08:	052a0000 	streq	r0, [sl, #-0]!
     f0c:	00000971 	andeq	r0, r0, r1, ror r9
     f10:	0980052b 	stmibeq	r0, {r0, r1, r3, r5, r8, sl}
     f14:	052c0000 	streq	r0, [ip, #-0]!
     f18:	0000090e 	andeq	r0, r0, lr, lsl #18
     f1c:	098f052d 	stmibeq	pc, {r0, r2, r3, r5, r8, sl}	; <UNPREDICTABLE>
     f20:	052e0000 	streq	r0, [lr, #-0]!
     f24:	00000b88 	andeq	r0, r0, r8, lsl #23
     f28:	09ad052f 	stmibeq	sp!, {r0, r1, r2, r3, r5, r8, sl}
     f2c:	05300000 	ldreq	r0, [r0, #-0]!
     f30:	000009bc 			; <UNDEFINED> instruction: 0x000009bc
     f34:	07640531 			; <UNDEFINED> instruction: 0x07640531
     f38:	05320000 	ldreq	r0, [r2, #-0]!
     f3c:	00000ad9 	ldrdeq	r0, [r0], -r9
     f40:	0ae90533 	beq	ffa42414 <_bss_end+0xffa39600>
     f44:	05340000 	ldreq	r0, [r4, #-0]!
     f48:	00000af9 	strdeq	r0, [r0], -r9
     f4c:	08fc0535 	ldmeq	ip!, {r0, r2, r4, r5, r8, sl}^
     f50:	05360000 	ldreq	r0, [r6, #-0]!
     f54:	00000b09 	andeq	r0, r0, r9, lsl #22
     f58:	0b190537 	bleq	64243c <_bss_end+0x639628>
     f5c:	05380000 	ldreq	r0, [r8, #-0]!
     f60:	00000b29 	andeq	r0, r0, r9, lsr #22
     f64:	07ed0539 			; <UNDEFINED> instruction: 0x07ed0539
     f68:	053a0000 	ldreq	r0, [sl, #-0]!
     f6c:	000007a6 	andeq	r0, r0, r6, lsr #15
     f70:	09cb053b 	stmibeq	fp, {r0, r1, r3, r4, r5, r8, sl}^
     f74:	053c0000 	ldreq	r0, [ip, #-0]!
     f78:	0000073b 	andeq	r0, r0, fp, lsr r7
     f7c:	0b44053d 	bleq	1102478 <_bss_end+0x10f9664>
     f80:	003e0000 	eorseq	r0, lr, r0
     f84:	00082d06 	andeq	r2, r8, r6, lsl #26
     f88:	6b010200 	blvs	41790 <_bss_end+0x3897c>
     f8c:	01ff0802 	mvnseq	r0, r2, lsl #16
     f90:	f0070000 			; <UNDEFINED> instruction: 0xf0070000
     f94:	01000009 	tsteq	r0, r9
     f98:	47140270 			; <UNDEFINED> instruction: 0x47140270
     f9c:	00000000 	andeq	r0, r0, r0
     fa0:	00090907 	andeq	r0, r9, r7, lsl #18
     fa4:	02710100 	rsbseq	r0, r1, #0, 2
     fa8:	00004714 	andeq	r4, r0, r4, lsl r7
     fac:	08000100 	stmdaeq	r0, {r8}
     fb0:	000001d4 	ldrdeq	r0, [r0], -r4
     fb4:	0001ff09 	andeq	pc, r1, r9, lsl #30
     fb8:	00021400 	andeq	r1, r2, r0, lsl #8
     fbc:	00240a00 	eoreq	r0, r4, r0, lsl #20
     fc0:	00110000 	andseq	r0, r1, r0
     fc4:	00020408 	andeq	r0, r2, r8, lsl #8
     fc8:	0ac70b00 	beq	ff1c3bd0 <_bss_end+0xff1badbc>
     fcc:	74010000 	strvc	r0, [r1], #-0
     fd0:	02142602 	andseq	r2, r4, #2097152	; 0x200000
     fd4:	3a240000 	bcc	900fdc <_bss_end+0x8f81c8>
     fd8:	0f3d0a3d 	svceq	0x003d0a3d
     fdc:	323d243d 	eorscc	r2, sp, #1023410176	; 0x3d000000
     fe0:	053d023d 	ldreq	r0, [sp, #-573]!	; 0xfffffdc3
     fe4:	0d3d133d 	ldceq	3, cr1, [sp, #-244]!	; 0xffffff0c
     fe8:	233d0c3d 	teqcs	sp, #15616	; 0x3d00
     fec:	263d113d 			; <UNDEFINED> instruction: 0x263d113d
     ff0:	173d013d 			; <UNDEFINED> instruction: 0x173d013d
     ff4:	093d083d 	ldmdbeq	sp!, {r0, r2, r3, r4, r5, fp}
     ff8:	0300003d 	movweq	r0, #61	; 0x3d
     ffc:	0a880702 	beq	fe202c0c <_bss_end+0xfe1f9df8>
    1000:	01030000 	mrseq	r0, (UNDEF: 3)
    1004:	00024508 	andeq	r4, r2, r8, lsl #10
    1008:	040d0c00 	streq	r0, [sp], #-3072	; 0xfffff400
    100c:	00000259 	andeq	r0, r0, r9, asr r2
    1010:	000c870e 	andeq	r8, ip, lr, lsl #14
    1014:	39010700 	stmdbcc	r1, {r8, r9, sl}
    1018:	02000000 	andeq	r0, r0, #0
    101c:	9e0604f7 	mcrls	4, 0, r0, cr6, cr7, {7}
    1020:	05000002 	streq	r0, [r0, #-2]
    1024:	00000807 	andeq	r0, r0, r7, lsl #16
    1028:	08120500 	ldmdaeq	r2, {r8, sl}
    102c:	05010000 	streq	r0, [r1, #-0]
    1030:	00000824 	andeq	r0, r0, r4, lsr #16
    1034:	083e0502 	ldmdaeq	lr!, {r1, r8, sl}
    1038:	05030000 	streq	r0, [r3, #-0]
    103c:	00000bc1 	andeq	r0, r0, r1, asr #23
    1040:	091d0504 	ldmdbeq	sp, {r2, r8, sl}
    1044:	05050000 	streq	r0, [r5, #-0]
    1048:	00000b7a 	andeq	r0, r0, sl, ror fp
    104c:	02030006 	andeq	r0, r3, #6
    1050:	00078305 	andeq	r8, r7, r5, lsl #6
    1054:	07080300 	streq	r0, [r8, -r0, lsl #6]
    1058:	00000a4d 	andeq	r0, r0, sp, asr #20
    105c:	54040403 	strpl	r0, [r4], #-1027	; 0xfffffbfd
    1060:	03000007 	movweq	r0, #7
    1064:	074c0308 	strbeq	r0, [ip, -r8, lsl #6]
    1068:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    106c:	000a0704 	andeq	r0, sl, r4, lsl #14
    1070:	03100300 	tsteq	r0, #0, 6
    1074:	00000b6b 	andeq	r0, r0, fp, ror #22
    1078:	000b620f 	andeq	r6, fp, pc, lsl #4
    107c:	102a0300 	eorne	r0, sl, r0, lsl #6
    1080:	0000025a 	andeq	r0, r0, sl, asr r2
    1084:	0002c809 	andeq	ip, r2, r9, lsl #16
    1088:	0002df00 	andeq	sp, r2, r0, lsl #30
    108c:	11001000 	mrsne	r1, (UNDEF: 0)
    1090:	000005da 	ldrdeq	r0, [r0], -sl
    1094:	d4112f03 	ldrle	r2, [r1], #-3843	; 0xfffff0fd
    1098:	11000002 	tstne	r0, r2
    109c:	0000060c 	andeq	r0, r0, ip, lsl #12
    10a0:	d4113003 	ldrle	r3, [r1], #-3
    10a4:	09000002 	stmdbeq	r0, {r1}
    10a8:	000002c8 	andeq	r0, r0, r8, asr #5
    10ac:	00000307 	andeq	r0, r0, r7, lsl #6
    10b0:	0000240a 	andeq	r2, r0, sl, lsl #8
    10b4:	12000100 	andne	r0, r0, #0, 2
    10b8:	000002df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    10bc:	0a093304 	beq	24dcd4 <_bss_end+0x244ec0>
    10c0:	000002f7 	strdeq	r0, [r0], -r7
    10c4:	8dd80305 	ldclhi	3, cr0, [r8, #20]
    10c8:	eb120000 	bl	4810d0 <_bss_end+0x4782bc>
    10cc:	04000002 	streq	r0, [r0], #-2
    10d0:	f70a0934 			; <UNDEFINED> instruction: 0xf70a0934
    10d4:	05000002 	streq	r0, [r0, #-2]
    10d8:	008ddc03 	addeq	sp, sp, r3, lsl #24
	...

Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
   0:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
   4:	030b130e 	movweq	r1, #45838	; 0xb30e
   8:	110e1b0e 	tstne	lr, lr, lsl #22
   c:	10061201 	andne	r1, r6, r1, lsl #4
  10:	02000017 	andeq	r0, r0, #23
  14:	193f002e 	ldmdbne	pc!, {r1, r2, r3, r5}	; <UNPREDICTABLE>
  18:	0b3a0e03 	bleq	e8382c <_bss_end+0xe7aa18>
  1c:	0b390b3b 	bleq	e42d10 <_bss_end+0xe39efc>
  20:	06120111 			; <UNDEFINED> instruction: 0x06120111
  24:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
  28:	03000019 	movweq	r0, #25
  2c:	0e030139 	mcreq	1, 0, r0, cr3, cr9, {1}
  30:	0b3b0b3a 	bleq	ec2d20 <_bss_end+0xeb9f0c>
  34:	00001301 	andeq	r1, r0, r1, lsl #6
  38:	3f012e04 	svccc	0x00012e04
  3c:	3a0e0319 	bcc	380ca8 <_bss_end+0x377e94>
  40:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
  44:	01193c0b 	tsteq	r9, fp, lsl #24
  48:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
  4c:	13490005 	movtne	r0, #36869	; 0x9005
  50:	16060000 	strne	r0, [r6], -r0
  54:	3a0e0300 	bcc	380c5c <_bss_end+0x377e48>
  58:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
  5c:	0013490b 	andseq	r4, r3, fp, lsl #18
  60:	012e0700 			; <UNDEFINED> instruction: 0x012e0700
  64:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
  68:	0b3b0b3a 	bleq	ec2d58 <_bss_end+0xeb9f44>
  6c:	13490b39 	movtne	r0, #39737	; 0x9b39
  70:	0000193c 	andeq	r1, r0, ip, lsr r9
  74:	0b000f08 	bleq	3c9c <CPSR_IRQ_INHIBIT+0x3c1c>
  78:	0013490b 	andseq	r4, r3, fp, lsl #18
  7c:	00240900 	eoreq	r0, r4, r0, lsl #18
  80:	0b3e0b0b 	bleq	f82cb4 <_bss_end+0xf79ea0>
  84:	00000e03 	andeq	r0, r0, r3, lsl #28
  88:	47012e0a 	strmi	r2, [r1, -sl, lsl #28]
  8c:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
  90:	97184006 	ldrls	r4, [r8, -r6]
  94:	13011942 	movwne	r1, #6466	; 0x1942
  98:	050b0000 	streq	r0, [fp, #-0]
  9c:	02134900 	andseq	r4, r3, #0, 18
  a0:	0c000018 	stceq	0, cr0, [r0], {24}
  a4:	08030005 	stmdaeq	r3, {r0, r2}
  a8:	0b3b0b3a 	bleq	ec2d98 <_bss_end+0xeb9f84>
  ac:	13490b39 	movtne	r0, #39737	; 0x9b39
  b0:	00001802 	andeq	r1, r0, r2, lsl #16
  b4:	0b00240d 	bleq	90f0 <_bss_end+0x2dc>
  b8:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
  bc:	0e000008 	cdpeq	0, 0, cr0, cr0, cr8, {0}
  c0:	1347012e 	movtne	r0, #28974	; 0x712e
  c4:	06120111 			; <UNDEFINED> instruction: 0x06120111
  c8:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
  cc:	00000019 	andeq	r0, r0, r9, lsl r0
  d0:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
  d4:	030b130e 	movweq	r1, #45838	; 0xb30e
  d8:	550e1b0e 	strpl	r1, [lr, #-2830]	; 0xfffff4f2
  dc:	10011117 	andne	r1, r1, r7, lsl r1
  e0:	02000017 	andeq	r0, r0, #23
  e4:	0e030102 	adfeqs	f0, f3, f2
  e8:	0b3a0b0b 	bleq	e82d1c <_bss_end+0xe79f08>
  ec:	0b390b3b 	bleq	e42de0 <_bss_end+0xe39fcc>
  f0:	00001301 	andeq	r1, r0, r1, lsl #6
  f4:	03010403 	movweq	r0, #5123	; 0x1403
  f8:	3e196d0e 	cdpcc	13, 1, cr6, cr9, cr14, {0}
  fc:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
 100:	3b0b3a13 	blcc	2ce954 <_bss_end+0x2c5b40>
 104:	320b390b 	andcc	r3, fp, #180224	; 0x2c000
 108:	0013010b 	andseq	r0, r3, fp, lsl #2
 10c:	00280400 	eoreq	r0, r8, r0, lsl #8
 110:	0b1c0803 	bleq	702124 <_bss_end+0x6f9310>
 114:	26050000 	strcs	r0, [r5], -r0
 118:	00134900 	andseq	r4, r3, r0, lsl #18
 11c:	01130600 	tsteq	r3, r0, lsl #12
 120:	0b0b0e03 	bleq	2c3934 <_bss_end+0x2bab20>
 124:	0b3b0b3a 	bleq	ec2e14 <_bss_end+0xeba000>
 128:	13010b39 	movwne	r0, #6969	; 0x1b39
 12c:	0d070000 	stceq	0, cr0, [r7, #-0]
 130:	3a080300 	bcc	200d38 <_bss_end+0x1f7f24>
 134:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 138:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 13c:	0800000b 	stmdaeq	r0, {r0, r1, r3}
 140:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 144:	0b3b0b3a 	bleq	ec2e34 <_bss_end+0xeba020>
 148:	13490b39 	movtne	r0, #39737	; 0x9b39
 14c:	0b32193f 	bleq	c86650 <_bss_end+0xc7d83c>
 150:	0b1c193c 	bleq	706648 <_bss_end+0x6fd834>
 154:	0000196c 	andeq	r1, r0, ip, ror #18
 158:	03000d09 	movweq	r0, #3337	; 0xd09
 15c:	3b0b3a0e 	blcc	2ce99c <_bss_end+0x2c5b88>
 160:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 164:	32193f13 	andscc	r3, r9, #19, 30	; 0x4c
 168:	6c193c0b 	ldcvs	12, cr3, [r9], {11}
 16c:	0a000019 	beq	1d8 <CPSR_IRQ_INHIBIT+0x158>
 170:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 174:	0b3a0e03 	bleq	e83988 <_bss_end+0xe7ab74>
 178:	0b390b3b 	bleq	e42e6c <_bss_end+0xe3a058>
 17c:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 180:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 184:	13641963 	cmnne	r4, #1622016	; 0x18c000
 188:	00001301 	andeq	r1, r0, r1, lsl #6
 18c:	4900050b 	stmdbmi	r0, {r0, r1, r3, r8, sl}
 190:	00193413 	andseq	r3, r9, r3, lsl r4
 194:	00050c00 	andeq	r0, r5, r0, lsl #24
 198:	00001349 	andeq	r1, r0, r9, asr #6
 19c:	3f012e0d 	svccc	0x00012e0d
 1a0:	3a0e0319 	bcc	380e0c <_bss_end+0x377ff8>
 1a4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 1a8:	320e6e0b 	andcc	r6, lr, #11, 28	; 0xb0
 1ac:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 1b0:	00130113 	andseq	r0, r3, r3, lsl r1
 1b4:	012e0e00 			; <UNDEFINED> instruction: 0x012e0e00
 1b8:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 1bc:	0b3b0b3a 	bleq	ec2eac <_bss_end+0xeba098>
 1c0:	0e6e0b39 	vmoveq.8	d14[5], r0
 1c4:	0b321349 	bleq	c84ef0 <_bss_end+0xc7c0dc>
 1c8:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 1cc:	00001301 	andeq	r1, r0, r1, lsl #6
 1d0:	3f012e0f 	svccc	0x00012e0f
 1d4:	3a0e0319 	bcc	380e40 <_bss_end+0x37802c>
 1d8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 1dc:	3c0e6e0b 	stccc	14, cr6, [lr], {11}
 1e0:	01136419 	tsteq	r3, r9, lsl r4
 1e4:	10000013 	andne	r0, r0, r3, lsl r0
 1e8:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 1ec:	0b3b0b3a 	bleq	ec2edc <_bss_end+0xeba0c8>
 1f0:	13490b39 	movtne	r0, #39737	; 0x9b39
 1f4:	00000b38 	andeq	r0, r0, r8, lsr fp
 1f8:	0b002411 	bleq	9244 <_bss_end+0x430>
 1fc:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 200:	1200000e 	andne	r0, r0, #14
 204:	0b0b000f 	bleq	2c0248 <_bss_end+0x2b7434>
 208:	00001349 	andeq	r1, r0, r9, asr #6
 20c:	0b001013 	bleq	4260 <CPSR_IRQ_INHIBIT+0x41e0>
 210:	0013490b 	andseq	r4, r3, fp, lsl #18
 214:	00351400 	eorseq	r1, r5, r0, lsl #8
 218:	00001349 	andeq	r1, r0, r9, asr #6
 21c:	03003415 	movweq	r3, #1045	; 0x415
 220:	3b0b3a0e 	blcc	2cea60 <_bss_end+0x2c5c4c>
 224:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 228:	3c193f13 	ldccc	15, cr3, [r9], {19}
 22c:	16000019 			; <UNDEFINED> instruction: 0x16000019
 230:	13470034 	movtne	r0, #28724	; 0x7034
 234:	0b3b0b3a 	bleq	ec2f24 <_bss_end+0xeba110>
 238:	18020b39 	stmdane	r2, {r0, r3, r4, r5, r8, r9, fp}
 23c:	2e170000 	cdpcs	0, 1, cr0, cr7, cr0, {0}
 240:	340e0300 	strcc	r0, [lr], #-768	; 0xfffffd00
 244:	12011119 	andne	r1, r1, #1073741830	; 0x40000006
 248:	96184006 	ldrls	r4, [r8], -r6
 24c:	00001942 	andeq	r1, r0, r2, asr #18
 250:	03012e18 	movweq	r2, #7704	; 0x1e18
 254:	1119340e 	tstne	r9, lr, lsl #8
 258:	40061201 	andmi	r1, r6, r1, lsl #4
 25c:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
 260:	00001301 	andeq	r1, r0, r1, lsl #6
 264:	03000519 	movweq	r0, #1305	; 0x519
 268:	3b0b3a0e 	blcc	2ceaa8 <_bss_end+0x2c5c94>
 26c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 270:	00180213 	andseq	r0, r8, r3, lsl r2
 274:	00241a00 	eoreq	r1, r4, r0, lsl #20
 278:	0b3e0b0b 	bleq	f82eac <_bss_end+0xf7a098>
 27c:	00000803 	andeq	r0, r0, r3, lsl #16
 280:	47012e1b 	smladmi	r1, fp, lr, r2
 284:	3b0b3a13 	blcc	2cead8 <_bss_end+0x2c5cc4>
 288:	640b390b 	strvs	r3, [fp], #-2315	; 0xfffff6f5
 28c:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 290:	96184006 	ldrls	r4, [r8], -r6
 294:	13011942 	movwne	r1, #6466	; 0x1942
 298:	051c0000 	ldreq	r0, [ip, #-0]
 29c:	490e0300 	stmdbmi	lr, {r8, r9}
 2a0:	02193413 	andseq	r3, r9, #318767104	; 0x13000000
 2a4:	1d000018 	stcne	0, cr0, [r0, #-96]	; 0xffffffa0
 2a8:	08030034 	stmdaeq	r3, {r2, r4, r5}
 2ac:	0b3b0b3a 	bleq	ec2f9c <_bss_end+0xeba188>
 2b0:	13490b39 	movtne	r0, #39737	; 0x9b39
 2b4:	00001802 	andeq	r1, r0, r2, lsl #16
 2b8:	11010b1e 	tstne	r1, lr, lsl fp
 2bc:	00061201 	andeq	r1, r6, r1, lsl #4
 2c0:	00051f00 	andeq	r1, r5, r0, lsl #30
 2c4:	0b3a0803 	bleq	e822d8 <_bss_end+0xe794c4>
 2c8:	0b390b3b 	bleq	e42fbc <_bss_end+0xe3a1a8>
 2cc:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 2d0:	34200000 	strtcc	r0, [r0], #-0
 2d4:	3a0e0300 	bcc	380edc <_bss_end+0x3780c8>
 2d8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 2dc:	6c13490b 			; <UNDEFINED> instruction: 0x6c13490b
 2e0:	00180219 	andseq	r0, r8, r9, lsl r2
 2e4:	00342100 	eorseq	r2, r4, r0, lsl #2
 2e8:	0b3a0e03 	bleq	e83afc <_bss_end+0xe7ace8>
 2ec:	0b390b3b 	bleq	e42fe0 <_bss_end+0xe3a1cc>
 2f0:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 2f4:	01220000 			; <UNDEFINED> instruction: 0x01220000
 2f8:	01134901 	tsteq	r3, r1, lsl #18
 2fc:	23000013 	movwcs	r0, #19
 300:	13490021 	movtne	r0, #36897	; 0x9021
 304:	00000b2f 	andeq	r0, r0, pc, lsr #22
 308:	47012e24 	strmi	r2, [r1, -r4, lsr #28]
 30c:	3b0b3a13 	blcc	2ceb60 <_bss_end+0x2c5d4c>
 310:	640b390b 	strvs	r3, [fp], #-2315	; 0xfffff6f5
 314:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 318:	97184006 	ldrls	r4, [r8, -r6]
 31c:	13011942 	movwne	r1, #6466	; 0x1942
 320:	0b250000 	bleq	940328 <_bss_end+0x937514>
 324:	12011101 	andne	r1, r1, #1073741824	; 0x40000000
 328:	00130106 	andseq	r0, r3, r6, lsl #2
 32c:	012e2600 			; <UNDEFINED> instruction: 0x012e2600
 330:	0b3a1347 	bleq	e85054 <_bss_end+0xe7c240>
 334:	0b390b3b 	bleq	e43028 <_bss_end+0xe3a214>
 338:	0b201364 	bleq	8050d0 <_bss_end+0x7fc2bc>
 33c:	00001301 	andeq	r1, r0, r1, lsl #6
 340:	03000527 	movweq	r0, #1319	; 0x527
 344:	3413490e 	ldrcc	r4, [r3], #-2318	; 0xfffff6f2
 348:	28000019 	stmdacs	r0, {r0, r3, r4}
 34c:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
 350:	0b3b0b3a 	bleq	ec3040 <_bss_end+0xeba22c>
 354:	13490b39 	movtne	r0, #39737	; 0x9b39
 358:	2e290000 	cdpcs	0, 2, cr0, cr9, cr0, {0}
 35c:	6e133101 	mufvss	f3, f3, f1
 360:	1113640e 	tstne	r3, lr, lsl #8
 364:	40061201 	andmi	r1, r6, r1, lsl #4
 368:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 36c:	052a0000 	streq	r0, [sl, #-0]!
 370:	02133100 	andseq	r3, r3, #0, 2
 374:	00000018 	andeq	r0, r0, r8, lsl r0
 378:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
 37c:	030b130e 	movweq	r1, #45838	; 0xb30e
 380:	110e1b0e 	tstne	lr, lr, lsl #22
 384:	10061201 	andne	r1, r6, r1, lsl #4
 388:	02000017 	andeq	r0, r0, #23
 38c:	0e030102 	adfeqs	f0, f3, f2
 390:	0b3a0b0b 	bleq	e82fc4 <_bss_end+0xe7a1b0>
 394:	0b390b3b 	bleq	e43088 <_bss_end+0xe3a274>
 398:	00001301 	andeq	r1, r0, r1, lsl #6
 39c:	03010403 	movweq	r0, #5123	; 0x1403
 3a0:	3e196d0e 	cdpcc	13, 1, cr6, cr9, cr14, {0}
 3a4:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
 3a8:	3b0b3a13 	blcc	2cebfc <_bss_end+0x2c5de8>
 3ac:	320b390b 	andcc	r3, fp, #180224	; 0x2c000
 3b0:	0013010b 	andseq	r0, r3, fp, lsl #2
 3b4:	00280400 	eoreq	r0, r8, r0, lsl #8
 3b8:	0b1c0803 	bleq	7023cc <_bss_end+0x6f95b8>
 3bc:	26050000 	strcs	r0, [r5], -r0
 3c0:	00134900 	andseq	r4, r3, r0, lsl #18
 3c4:	01130600 	tsteq	r3, r0, lsl #12
 3c8:	0b0b0e03 	bleq	2c3bdc <_bss_end+0x2badc8>
 3cc:	0b3b0b3a 	bleq	ec30bc <_bss_end+0xeba2a8>
 3d0:	13010b39 	movwne	r0, #6969	; 0x1b39
 3d4:	0d070000 	stceq	0, cr0, [r7, #-0]
 3d8:	3a080300 	bcc	200fe0 <_bss_end+0x1f81cc>
 3dc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 3e0:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 3e4:	0800000b 	stmdaeq	r0, {r0, r1, r3}
 3e8:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 3ec:	0b3b0b3a 	bleq	ec30dc <_bss_end+0xeba2c8>
 3f0:	13490b39 	movtne	r0, #39737	; 0x9b39
 3f4:	0b32193f 	bleq	c868f8 <_bss_end+0xc7dae4>
 3f8:	0b1c193c 	bleq	7068f0 <_bss_end+0x6fdadc>
 3fc:	0000196c 	andeq	r1, r0, ip, ror #18
 400:	03000d09 	movweq	r0, #3337	; 0xd09
 404:	3b0b3a0e 	blcc	2cec44 <_bss_end+0x2c5e30>
 408:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 40c:	32193f13 	andscc	r3, r9, #19, 30	; 0x4c
 410:	6c193c0b 	ldcvs	12, cr3, [r9], {11}
 414:	0a000019 	beq	480 <CPSR_IRQ_INHIBIT+0x400>
 418:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 41c:	0b3a0e03 	bleq	e83c30 <_bss_end+0xe7ae1c>
 420:	0b390b3b 	bleq	e43114 <_bss_end+0xe3a300>
 424:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 428:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 42c:	13641963 	cmnne	r4, #1622016	; 0x18c000
 430:	00001301 	andeq	r1, r0, r1, lsl #6
 434:	4900050b 	stmdbmi	r0, {r0, r1, r3, r8, sl}
 438:	00193413 	andseq	r3, r9, r3, lsl r4
 43c:	00050c00 	andeq	r0, r5, r0, lsl #24
 440:	00001349 	andeq	r1, r0, r9, asr #6
 444:	3f012e0d 	svccc	0x00012e0d
 448:	3a0e0319 	bcc	3810b4 <_bss_end+0x3782a0>
 44c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 450:	320e6e0b 	andcc	r6, lr, #11, 28	; 0xb0
 454:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 458:	00130113 	andseq	r0, r3, r3, lsl r1
 45c:	012e0e00 			; <UNDEFINED> instruction: 0x012e0e00
 460:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 464:	0b3b0b3a 	bleq	ec3154 <_bss_end+0xeba340>
 468:	0e6e0b39 	vmoveq.8	d14[5], r0
 46c:	0b321349 	bleq	c85198 <_bss_end+0xc7c384>
 470:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 474:	00001301 	andeq	r1, r0, r1, lsl #6
 478:	3f012e0f 	svccc	0x00012e0f
 47c:	3a0e0319 	bcc	3810e8 <_bss_end+0x3782d4>
 480:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 484:	3c0e6e0b 	stccc	14, cr6, [lr], {11}
 488:	01136419 	tsteq	r3, r9, lsl r4
 48c:	10000013 	andne	r0, r0, r3, lsl r0
 490:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 494:	0b3b0b3a 	bleq	ec3184 <_bss_end+0xeba370>
 498:	13490b39 	movtne	r0, #39737	; 0x9b39
 49c:	00000b38 	andeq	r0, r0, r8, lsr fp
 4a0:	0b002411 	bleq	94ec <_bss_end+0x6d8>
 4a4:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 4a8:	1200000e 	andne	r0, r0, #14
 4ac:	0b0b000f 	bleq	2c04f0 <_bss_end+0x2b76dc>
 4b0:	00001349 	andeq	r1, r0, r9, asr #6
 4b4:	0b001013 	bleq	4508 <CPSR_IRQ_INHIBIT+0x4488>
 4b8:	0013490b 	andseq	r4, r3, fp, lsl #18
 4bc:	00351400 	eorseq	r1, r5, r0, lsl #8
 4c0:	00001349 	andeq	r1, r0, r9, asr #6
 4c4:	03003415 	movweq	r3, #1045	; 0x415
 4c8:	3b0b3a0e 	blcc	2ced08 <_bss_end+0x2c5ef4>
 4cc:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 4d0:	3c193f13 	ldccc	15, cr3, [r9], {19}
 4d4:	16000019 			; <UNDEFINED> instruction: 0x16000019
 4d8:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 4dc:	0b3a0e03 	bleq	e83cf0 <_bss_end+0xe7aedc>
 4e0:	0b390b3b 	bleq	e431d4 <_bss_end+0xe3a3c0>
 4e4:	01111349 	tsteq	r1, r9, asr #6
 4e8:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 4ec:	01194296 			; <UNDEFINED> instruction: 0x01194296
 4f0:	17000013 	smladne	r0, r3, r0, r0
 4f4:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 4f8:	0b3b0b3a 	bleq	ec31e8 <_bss_end+0xeba3d4>
 4fc:	13490b39 	movtne	r0, #39737	; 0x9b39
 500:	00001802 	andeq	r1, r0, r2, lsl #16
 504:	03003418 	movweq	r3, #1048	; 0x418
 508:	3b0b3a08 	blcc	2ced30 <_bss_end+0x2c5f1c>
 50c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 510:	00180213 	andseq	r0, r8, r3, lsl r2
 514:	010b1900 	tsteq	fp, r0, lsl #18
 518:	06120111 			; <UNDEFINED> instruction: 0x06120111
 51c:	241a0000 	ldrcs	r0, [sl], #-0
 520:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 524:	0008030b 	andeq	r0, r8, fp, lsl #6
 528:	012e1b00 			; <UNDEFINED> instruction: 0x012e1b00
 52c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 530:	0b3b0b3a 	bleq	ec3220 <_bss_end+0xeba40c>
 534:	0e6e0b39 	vmoveq.8	d14[5], r0
 538:	01111349 	tsteq	r1, r9, asr #6
 53c:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 540:	00194297 	mulseq	r9, r7, r2
 544:	00051c00 	andeq	r1, r5, r0, lsl #24
 548:	0b3a0803 	bleq	e8255c <_bss_end+0xe79748>
 54c:	0b390b3b 	bleq	e43240 <_bss_end+0xe3a42c>
 550:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 554:	01000000 	mrseq	r0, (UNDEF: 0)
 558:	06100011 			; <UNDEFINED> instruction: 0x06100011
 55c:	01120111 	tsteq	r2, r1, lsl r1
 560:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
 564:	05130e25 	ldreq	r0, [r3, #-3621]	; 0xfffff1db
 568:	01000000 	mrseq	r0, (UNDEF: 0)
 56c:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
 570:	0e030b13 	vmoveq.32	d3[0], r0
 574:	01110e1b 	tsteq	r1, fp, lsl lr
 578:	17100612 			; <UNDEFINED> instruction: 0x17100612
 57c:	16020000 	strne	r0, [r2], -r0
 580:	3a0e0300 	bcc	381188 <_bss_end+0x378374>
 584:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 588:	0013490b 	andseq	r4, r3, fp, lsl #18
 58c:	000f0300 	andeq	r0, pc, r0, lsl #6
 590:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 594:	15040000 	strne	r0, [r4, #-0]
 598:	05000000 	streq	r0, [r0, #-0]
 59c:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 5a0:	0b3b0b3a 	bleq	ec3290 <_bss_end+0xeba47c>
 5a4:	13490b39 	movtne	r0, #39737	; 0x9b39
 5a8:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
 5ac:	24060000 	strcs	r0, [r6], #-0
 5b0:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 5b4:	0008030b 	andeq	r0, r8, fp, lsl #6
 5b8:	01010700 	tsteq	r1, r0, lsl #14
 5bc:	13011349 	movwne	r1, #4937	; 0x1349
 5c0:	21080000 	mrscs	r0, (UNDEF: 8)
 5c4:	2f134900 	svccs	0x00134900
 5c8:	09000006 	stmdbeq	r0, {r1, r2}
 5cc:	0b0b0024 	bleq	2c0664 <_bss_end+0x2b7850>
 5d0:	0e030b3e 	vmoveq.16	d3[0], r0
 5d4:	2e0a0000 	cdpcs	0, 0, cr0, cr10, cr0, {0}
 5d8:	03193f01 	tsteq	r9, #1, 30
 5dc:	3b0b3a0e 	blcc	2cee1c <_bss_end+0x2c6008>
 5e0:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 5e4:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 5e8:	96184006 	ldrls	r4, [r8], -r6
 5ec:	13011942 	movwne	r1, #6466	; 0x1942
 5f0:	340b0000 	strcc	r0, [fp], #-0
 5f4:	3a0e0300 	bcc	3811fc <_bss_end+0x3783e8>
 5f8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 5fc:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 600:	0c000018 	stceq	0, cr0, [r0], {24}
 604:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 608:	0b3a0e03 	bleq	e83e1c <_bss_end+0xe7b008>
 60c:	0b390b3b 	bleq	e43300 <_bss_end+0xe3a4ec>
 610:	01111349 	tsteq	r1, r9, asr #6
 614:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 618:	01194297 			; <UNDEFINED> instruction: 0x01194297
 61c:	0d000013 	stceq	0, cr0, [r0, #-76]	; 0xffffffb4
 620:	08030034 	stmdaeq	r3, {r2, r4, r5}
 624:	0b3b0b3a 	bleq	ec3314 <_bss_end+0xeba500>
 628:	13490b39 	movtne	r0, #39737	; 0x9b39
 62c:	00001802 	andeq	r1, r0, r2, lsl #16
 630:	00110100 	andseq	r0, r1, r0, lsl #2
 634:	01110610 	tsteq	r1, r0, lsl r6
 638:	0e030112 	mcreq	1, 0, r0, cr3, cr2, {0}
 63c:	0e250e1b 	mcreq	14, 1, r0, cr5, cr11, {0}
 640:	00000513 	andeq	r0, r0, r3, lsl r5
 644:	00110100 	andseq	r0, r1, r0, lsl #2
 648:	01110610 	tsteq	r1, r0, lsl r6
 64c:	0e030112 	mcreq	1, 0, r0, cr3, cr2, {0}
 650:	0e250e1b 	mcreq	14, 1, r0, cr5, cr11, {0}
 654:	00000513 	andeq	r0, r0, r3, lsl r5
 658:	01110100 	tsteq	r1, r0, lsl #2
 65c:	0b130e25 	bleq	4c3ef8 <_bss_end+0x4bb0e4>
 660:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
 664:	00001710 	andeq	r1, r0, r0, lsl r7
 668:	0b002402 	bleq	9678 <_bss_end+0x864>
 66c:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 670:	03000008 	movweq	r0, #8
 674:	0b0b0024 	bleq	2c070c <_bss_end+0x2b78f8>
 678:	0e030b3e 	vmoveq.16	d3[0], r0
 67c:	04040000 	streq	r0, [r4], #-0
 680:	3e0e0301 	cdpcc	3, 0, cr0, cr14, cr1, {0}
 684:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
 688:	3b0b3a13 	blcc	2ceedc <_bss_end+0x2c60c8>
 68c:	010b390b 	tsteq	fp, fp, lsl #18
 690:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
 694:	0e030028 	cdpeq	0, 0, cr0, cr3, cr8, {1}
 698:	00000b1c 	andeq	r0, r0, ip, lsl fp
 69c:	03011306 	movweq	r1, #4870	; 0x1306
 6a0:	3a0b0b0e 	bcc	2c32e0 <_bss_end+0x2ba4cc>
 6a4:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 6a8:	0013010b 	andseq	r0, r3, fp, lsl #2
 6ac:	000d0700 	andeq	r0, sp, r0, lsl #14
 6b0:	0b3a0e03 	bleq	e83ec4 <_bss_end+0xe7b0b0>
 6b4:	0b39053b 	bleq	e41ba8 <_bss_end+0xe38d94>
 6b8:	0b381349 	bleq	e053e4 <_bss_end+0xdfc5d0>
 6bc:	26080000 	strcs	r0, [r8], -r0
 6c0:	00134900 	andseq	r4, r3, r0, lsl #18
 6c4:	01010900 	tsteq	r1, r0, lsl #18
 6c8:	13011349 	movwne	r1, #4937	; 0x1349
 6cc:	210a0000 	mrscs	r0, (UNDEF: 10)
 6d0:	2f134900 	svccs	0x00134900
 6d4:	0b00000b 	bleq	708 <CPSR_IRQ_INHIBIT+0x688>
 6d8:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 6dc:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 6e0:	13490b39 	movtne	r0, #39737	; 0x9b39
 6e4:	00000a1c 	andeq	r0, r0, ip, lsl sl
 6e8:	2700150c 	strcs	r1, [r0, -ip, lsl #10]
 6ec:	0d000019 	stceq	0, cr0, [r0, #-100]	; 0xffffff9c
 6f0:	0b0b000f 	bleq	2c0734 <_bss_end+0x2b7920>
 6f4:	00001349 	andeq	r1, r0, r9, asr #6
 6f8:	0301040e 	movweq	r0, #5134	; 0x140e
 6fc:	0b0b3e0e 	bleq	2cff3c <_bss_end+0x2c7128>
 700:	3a13490b 	bcc	4d2b34 <_bss_end+0x4c9d20>
 704:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 708:	0013010b 	andseq	r0, r3, fp, lsl #2
 70c:	00160f00 	andseq	r0, r6, r0, lsl #30
 710:	0b3a0e03 	bleq	e83f24 <_bss_end+0xe7b110>
 714:	0b390b3b 	bleq	e43408 <_bss_end+0xe3a5f4>
 718:	00001349 	andeq	r1, r0, r9, asr #6
 71c:	00002110 	andeq	r2, r0, r0, lsl r1
 720:	00341100 	eorseq	r1, r4, r0, lsl #2
 724:	0b3a0e03 	bleq	e83f38 <_bss_end+0xe7b124>
 728:	0b390b3b 	bleq	e4341c <_bss_end+0xe3a608>
 72c:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
 730:	0000193c 	andeq	r1, r0, ip, lsr r9
 734:	47003412 	smladmi	r0, r2, r4, r3
 738:	3b0b3a13 	blcc	2cef8c <_bss_end+0x2c6178>
 73c:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
 740:	00180213 	andseq	r0, r8, r3, lsl r2
	...

Disassembly of section .debug_aranges:

00000000 <.debug_aranges>:
   0:	0000001c 	andeq	r0, r0, ip, lsl r0
   4:	00000002 	andeq	r0, r0, r2
   8:	00040000 	andeq	r0, r4, r0
   c:	00000000 	andeq	r0, r0, r0
  10:	00008040 	andeq	r8, r0, r0, asr #32
  14:	000000d8 	ldrdeq	r0, [r0], -r8
	...
  20:	00000034 	andeq	r0, r0, r4, lsr r0
  24:	012a0002 			; <UNDEFINED> instruction: 0x012a0002
  28:	00040000 	andeq	r0, r4, r0
  2c:	00000000 	andeq	r0, r0, r0
  30:	00008118 	andeq	r8, r0, r8, lsl r1
  34:	00000648 	andeq	r0, r0, r8, asr #12
  38:	00008760 	andeq	r8, r0, r0, ror #14
  3c:	00000038 	andeq	r0, r0, r8, lsr r0
  40:	00008798 	muleq	r0, r8, r7
  44:	00000088 	andeq	r0, r0, r8, lsl #1
  48:	00008820 	andeq	r8, r0, r0, lsr #16
  4c:	0000002c 	andeq	r0, r0, ip, lsr #32
	...
  58:	0000001c 	andeq	r0, r0, ip, lsl r0
  5c:	07e20002 	strbeq	r0, [r2, r2]!
  60:	00040000 	andeq	r0, r4, r0
  64:	00000000 	andeq	r0, r0, r0
  68:	0000884c 	andeq	r8, r0, ip, asr #16
  6c:	000001e8 	andeq	r0, r0, r8, ror #3
	...
  78:	0000001c 	andeq	r0, r0, ip, lsl r0
  7c:	0bef0002 	bleq	ffbc008c <_bss_end+0xffbb7278>
  80:	00040000 	andeq	r0, r4, r0
  84:	00000000 	andeq	r0, r0, r0
  88:	00008000 	andeq	r8, r0, r0
  8c:	00000040 	andeq	r0, r0, r0, asr #32
	...
  98:	0000001c 	andeq	r0, r0, ip, lsl r0
  9c:	0c150002 	ldceq	0, cr0, [r5], {2}
  a0:	00040000 	andeq	r0, r4, r0
  a4:	00000000 	andeq	r0, r0, r0
  a8:	00008a34 	andeq	r8, r0, r4, lsr sl
  ac:	00000118 	andeq	r0, r0, r8, lsl r1
	...
  b8:	0000001c 	andeq	r0, r0, ip, lsl r0
  bc:	0d640002 	stcleq	0, cr0, [r4, #-8]!
  c0:	00040000 	andeq	r0, r4, r0
  c4:	00000000 	andeq	r0, r0, r0
  c8:	00008b4c 	andeq	r8, r0, ip, asr #22
  cc:	0000020c 	andeq	r0, r0, ip, lsl #4
	...
  d8:	0000001c 	andeq	r0, r0, ip, lsl r0
  dc:	0d8a0002 	stceq	0, cr0, [sl, #8]
  e0:	00040000 	andeq	r0, r4, r0
  e4:	00000000 	andeq	r0, r0, r0
  e8:	00008d58 	andeq	r8, r0, r8, asr sp
  ec:	00000004 	andeq	r0, r0, r4
	...
  f8:	00000014 	andeq	r0, r0, r4, lsl r0
  fc:	0db00002 	ldceq	0, cr0, [r0, #8]!
 100:	00040000 	andeq	r0, r4, r0
	...

Disassembly of section .debug_line:

00000000 <.debug_line>:
   0:	000000a5 	andeq	r0, r0, r5, lsr #1
   4:	006c0003 	rsbeq	r0, ip, r3
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
  34:	5a2f7374 	bpl	bdce0c <_bss_end+0xbd3ff8>
  38:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; fffffeac <_bss_end+0xffff7098>
  3c:	2f657461 	svccs	0x00657461
  40:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
  44:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
  48:	2d31322f 	lfmcs	f3, 4, [r1, #-188]!	; 0xffffff44
  4c:	2f555046 	svccs	0x00555046
  50:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
  54:	732f6c65 			; <UNDEFINED> instruction: 0x732f6c65
  58:	00006372 	andeq	r6, r0, r2, ror r3
  5c:	2e787863 	cdpcs	8, 7, cr7, cr8, cr3, {3}
  60:	00707063 	rsbseq	r7, r0, r3, rrx
  64:	3c000001 	stccc	0, cr0, [r0], {1}
  68:	6c697562 	cfstr64vs	mvdx7, [r9], #-392	; 0xfffffe78
  6c:	6e692d74 	mcrvs	13, 3, r2, cr9, cr4, {3}
  70:	0000003e 	andeq	r0, r0, lr, lsr r0
  74:	05050000 	streq	r0, [r5, #-0]
  78:	40020500 	andmi	r0, r2, r0, lsl #10
  7c:	03000080 	movweq	r0, #128	; 0x80
  80:	1105010a 	tstne	r5, sl, lsl #2
  84:	4a100583 	bmi	401698 <_bss_end+0x3f8884>
  88:	85830505 	strhi	r0, [r3, #1285]	; 0x505
  8c:	05831305 	streq	r1, [r3, #773]	; 0x305
  90:	83856705 	orrhi	r6, r5, #1310720	; 0x140000
  94:	4c860105 	stfmis	f0, [r6], {5}
  98:	4c854c85 	stcmi	12, cr4, [r5], {133}	; 0x85
  9c:	00050585 	andeq	r0, r5, r5, lsl #11
  a0:	4b010402 	blmi	410b0 <_bss_end+0x3829c>
  a4:	01000202 	tsteq	r0, r2, lsl #4
  a8:	0003dd01 	andeq	sp, r3, r1, lsl #26
  ac:	c3000300 	movwgt	r0, #768	; 0x300
  b0:	02000000 	andeq	r0, r0, #0
  b4:	0d0efb01 	vstreq	d15, [lr, #-4]
  b8:	01010100 	mrseq	r0, (UNDEF: 17)
  bc:	00000001 	andeq	r0, r0, r1
  c0:	01000001 	tsteq	r0, r1
  c4:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
  c8:	552f632f 	strpl	r6, [pc, #-815]!	; fffffda1 <_bss_end+0xffff6f8d>
  cc:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
  d0:	62754b2f 	rsbsvs	r4, r5, #48128	; 0xbc00
  d4:	6f442f61 	svcvs	0x00442f61
  d8:	656d7563 	strbvs	r7, [sp, #-1379]!	; 0xfffffa9d
  dc:	2f73746e 	svccs	0x0073746e
  e0:	6f72655a 	svcvs	0x0072655a
  e4:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
  e8:	6178652f 	cmnvs	r8, pc, lsr #10
  ec:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
  f0:	31322f73 	teqcc	r2, r3, ror pc
  f4:	5550462d 	ldrbpl	r4, [r0, #-1581]	; 0xfffff9d3
  f8:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
  fc:	2f6c656e 	svccs	0x006c656e
 100:	2f637273 	svccs	0x00637273
 104:	76697264 	strbtvc	r7, [r9], -r4, ror #4
 108:	00737265 	rsbseq	r7, r3, r5, ror #4
 10c:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
 110:	552f632f 	strpl	r6, [pc, #-815]!	; fffffde9 <_bss_end+0xffff6fd5>
 114:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 118:	62754b2f 	rsbsvs	r4, r5, #48128	; 0xbc00
 11c:	6f442f61 	svcvs	0x00442f61
 120:	656d7563 	strbvs	r7, [sp, #-1379]!	; 0xfffffa9d
 124:	2f73746e 	svccs	0x0073746e
 128:	6f72655a 	svcvs	0x0072655a
 12c:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
 130:	6178652f 	cmnvs	r8, pc, lsr #10
 134:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
 138:	31322f73 	teqcc	r2, r3, ror pc
 13c:	5550462d 	ldrbpl	r4, [r0, #-1581]	; 0xfffff9d3
 140:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 144:	2f6c656e 	svccs	0x006c656e
 148:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 14c:	2f656475 	svccs	0x00656475
 150:	76697264 	strbtvc	r7, [r9], -r4, ror #4
 154:	00737265 	rsbseq	r7, r3, r5, ror #4
 158:	6e6f6d00 	cdpvs	13, 6, cr6, cr15, cr0, {0}
 15c:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
 160:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
 164:	00000100 	andeq	r0, r0, r0, lsl #2
 168:	696e6f6d 	stmdbvs	lr!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
 16c:	2e726f74 	mrccs	15, 3, r6, cr2, cr4, {3}
 170:	00020068 	andeq	r0, r2, r8, rrx
 174:	01050000 	mrseq	r0, (UNDEF: 5)
 178:	18020500 	stmdane	r2, {r8, sl}
 17c:	16000081 	strne	r0, [r0], -r1, lsl #1
 180:	05d70e05 	ldrbeq	r0, [r7, #3589]	; 0xe05
 184:	01053226 	tsteq	r5, r6, lsr #4
 188:	03142202 	tsteq	r4, #536870912	; 0x20000000
 18c:	11059e09 	tstne	r5, r9, lsl #28
 190:	4c170583 	cfldr32mi	mvfx0, [r7], {131}	; 0x83
 194:	02002205 	andeq	r2, r0, #1342177280	; 0x50000000
 198:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
 19c:	04020020 	streq	r0, [r2], #-32	; 0xffffffe0
 1a0:	1b054a01 	blne	1529ac <_bss_end+0x149b98>
 1a4:	00260568 	eoreq	r0, r6, r8, ror #10
 1a8:	4a030402 	bmi	c11b8 <_bss_end+0xb83a4>
 1ac:	02002405 	andeq	r2, r0, #83886080	; 0x5000000
 1b0:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
 1b4:	0402000d 	streq	r0, [r2], #-13
 1b8:	1c056802 	stcne	8, cr6, [r5], {2}
 1bc:	02040200 	andeq	r0, r4, #0, 4
 1c0:	001a054a 	andseq	r0, sl, sl, asr #10
 1c4:	4a020402 	bmi	811d4 <_bss_end+0x783c0>
 1c8:	02002505 	andeq	r2, r0, #20971520	; 0x1400000
 1cc:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 1d0:	04020028 	streq	r0, [r2], #-40	; 0xffffffd8
 1d4:	2a054a02 	bcs	1529e4 <_bss_end+0x149bd0>
 1d8:	02040200 	andeq	r0, r4, #0, 4
 1dc:	0009052e 	andeq	r0, r9, lr, lsr #10
 1e0:	48020402 	stmdami	r2, {r1, sl}
 1e4:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
 1e8:	05800204 	streq	r0, [r0, #516]	; 0x204
 1ec:	12038901 	andne	r8, r3, #16384	; 0x4000
 1f0:	83170566 	tsthi	r7, #427819008	; 0x19800000
 1f4:	02002205 	andeq	r2, r0, #1342177280	; 0x50000000
 1f8:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
 1fc:	04020020 	streq	r0, [r2], #-32	; 0xffffffe0
 200:	1b054a01 	blne	152a0c <_bss_end+0x149bf8>
 204:	00260568 	eoreq	r0, r6, r8, ror #10
 208:	4a030402 	bmi	c1218 <_bss_end+0xb8404>
 20c:	02002405 	andeq	r2, r0, #83886080	; 0x5000000
 210:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
 214:	04020032 	streq	r0, [r2], #-50	; 0xffffffce
 218:	41056802 	tstmi	r5, r2, lsl #16
 21c:	02040200 	andeq	r0, r4, #0, 4
 220:	003f054a 	eorseq	r0, pc, sl, asr #10
 224:	4a020402 	bmi	81234 <_bss_end+0x78420>
 228:	02004a05 	andeq	r4, r0, #20480	; 0x5000
 22c:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 230:	0402004d 	streq	r0, [r2], #-77	; 0xffffffb3
 234:	0d054a02 	vstreq	s8, [r5, #-8]
 238:	02040200 	andeq	r0, r4, #0, 4
 23c:	001b052e 	andseq	r0, fp, lr, lsr #10
 240:	4a020402 	bmi	81250 <_bss_end+0x7843c>
 244:	02002205 	andeq	r2, r0, #1342177280	; 0x50000000
 248:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 24c:	04020020 	streq	r0, [r2], #-32	; 0xffffffe0
 250:	2b054a02 	blcs	152a60 <_bss_end+0x149c4c>
 254:	02040200 	andeq	r0, r4, #0, 4
 258:	002e052e 	eoreq	r0, lr, lr, lsr #10
 25c:	4a020402 	bmi	8126c <_bss_end+0x78458>
 260:	02004d05 	andeq	r4, r0, #320	; 0x140
 264:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
 268:	04020030 	streq	r0, [r2], #-48	; 0xffffffd0
 26c:	09054a02 	stmdbeq	r5, {r1, r9, fp, lr}
 270:	02040200 	andeq	r0, r4, #0, 4
 274:	0005052c 	andeq	r0, r5, ip, lsr #10
 278:	80020402 	andhi	r0, r2, r2, lsl #8
 27c:	058a1705 	streq	r1, [sl, #1797]	; 0x705
 280:	04020022 	streq	r0, [r2], #-34	; 0xffffffde
 284:	20054a03 	andcs	r4, r5, r3, lsl #20
 288:	03040200 	movweq	r0, #16896	; 0x4200
 28c:	0009054a 	andeq	r0, r9, sl, asr #10
 290:	68020402 	stmdavs	r2, {r1, sl}
 294:	02001505 	andeq	r1, r0, #20971520	; 0x1400000
 298:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 29c:	0402001e 	streq	r0, [r2], #-30	; 0xffffffe2
 2a0:	25054a02 	strcs	r4, [r5, #-2562]	; 0xfffff5fe
 2a4:	02040200 	andeq	r0, r4, #0, 4
 2a8:	0023052e 	eoreq	r0, r3, lr, lsr #10
 2ac:	4a020402 	bmi	812bc <_bss_end+0x784a8>
 2b0:	02002e05 	andeq	r2, r0, #5, 28	; 0x50
 2b4:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
 2b8:	04020031 	streq	r0, [r2], #-49	; 0xffffffcf
 2bc:	33054a02 	movwcc	r4, #23042	; 0x5a02
 2c0:	02040200 	andeq	r0, r4, #0, 4
 2c4:	0005052e 	andeq	r0, r5, lr, lsr #10
 2c8:	48020402 	stmdami	r2, {r1, sl}
 2cc:	8a860105 	bhi	fe1806e8 <_bss_end+0xfe1778d4>
 2d0:	05bb0505 	ldreq	r0, [fp, #1285]!	; 0x505
 2d4:	1d056809 	stcne	8, cr6, [r5, #-36]	; 0xffffffdc
 2d8:	4a21054a 	bmi	841808 <_bss_end+0x8389f4>
 2dc:	054a1f05 	strbeq	r1, [sl, #-3845]	; 0xfffff0fb
 2e0:	2a052e35 	bcs	14bbbc <_bss_end+0x142da8>
 2e4:	2e36054a 	cdpcs	5, 3, cr0, cr6, cr10, {2}
 2e8:	052e3805 	streq	r3, [lr, #-2053]!	; 0xfffff7fb
 2ec:	09054b14 	stmdbeq	r5, {r2, r4, r8, r9, fp, lr}
 2f0:	8614054a 	ldrhi	r0, [r4], -sl, asr #10
 2f4:	4a090567 	bmi	241898 <_bss_end+0x238a84>
 2f8:	05691205 	strbeq	r1, [r9, #-517]!	; 0xfffffdfb
 2fc:	01054c0d 	tsteq	r5, sp, lsl #24
 300:	1705692f 	strne	r6, [r5, -pc, lsr #18]
 304:	0023059f 	mlaeq	r3, pc, r5, r0	; <UNPREDICTABLE>
 308:	4a030402 	bmi	c1318 <_bss_end+0xb8504>
 30c:	02002505 	andeq	r2, r0, #20971520	; 0x1400000
 310:	05820304 	streq	r0, [r2, #772]	; 0x304
 314:	04020017 	streq	r0, [r2], #-23	; 0xffffffe9
 318:	05054c02 	streq	r4, [r5, #-3074]	; 0xfffff3fe
 31c:	02040200 	andeq	r0, r4, #0, 4
 320:	871605d4 			; <UNDEFINED> instruction: 0x871605d4
 324:	054c0d05 	strbeq	r0, [ip, #-3333]	; 0xfffff2fb
 328:	05692f01 	strbeq	r2, [r9, #-3841]!	; 0xfffff0ff
 32c:	0d059f13 	stceq	15, cr9, [r5, #-76]	; 0xffffffb4
 330:	2f010568 	svccs	0x00010568
 334:	a3330585 	teqge	r3, #557842432	; 0x21400000
 338:	054a0905 	strbeq	r0, [sl, #-2309]	; 0xfffff6fb
 33c:	1605830e 	strne	r8, [r5], -lr, lsl #6
 340:	4c0d0567 	cfstr32mi	mvfx0, [sp], {103}	; 0x67
 344:	852f0105 	strhi	r0, [pc, #-261]!	; 247 <CPSR_IRQ_INHIBIT+0x1c7>
 348:	05bb0505 	ldreq	r0, [fp, #1285]!	; 0x505
 34c:	05866812 	streq	r6, [r6, #2066]	; 0x812
 350:	0d056916 	vstreq.16	s12, [r5, #-44]	; 0xffffffd4	; <UNPREDICTABLE>
 354:	2f01054c 	svccs	0x0001054c
 358:	d70905a1 	strle	r0, [r9, -r1, lsr #11]
 35c:	054c1205 	strbeq	r1, [ip, #-517]	; 0xfffffdfb
 360:	2d056827 	stccs	8, cr6, [r5, #-156]	; 0xffffff64
 364:	4a1005ba 	bmi	401a54 <_bss_end+0x3f8c40>
 368:	052e1105 	streq	r1, [lr, #-261]!	; 0xfffffefb
 36c:	13054a2d 	movwne	r4, #23085	; 0x5a2d
 370:	2f0f052e 	svccs	0x000f052e
 374:	05a00a05 	streq	r0, [r0, #2565]!	; 0xa05
 378:	05366105 	ldreq	r6, [r6, #-261]!	; 0xfffffefb
 37c:	11056810 	tstne	r5, r0, lsl r8
 380:	4a22052e 	bmi	881840 <_bss_end+0x878a2c>
 384:	052e1305 	streq	r1, [lr, #-773]!	; 0xfffffcfb
 388:	0c052f0a 	stceq	15, cr2, [r5], {10}
 38c:	2e0d0569 	cfsh32cs	mvfx0, mvfx13, #57
 390:	054a0f05 	strbeq	r0, [sl, #-3845]	; 0xfffff0fb
 394:	0e054b06 	vmlaeq.f64	d4, d5, d6
 398:	001d0568 	andseq	r0, sp, r8, ror #10
 39c:	4a030402 	bmi	c13ac <_bss_end+0xb8598>
 3a0:	02001705 	andeq	r1, r0, #1310720	; 0x140000
 3a4:	059e0304 	ldreq	r0, [lr, #772]	; 0x304
 3a8:	0402001b 	streq	r0, [r2], #-27	; 0xffffffe5
 3ac:	1e056802 	cdpne	8, 0, cr6, cr5, cr2, {0}
 3b0:	02040200 	andeq	r0, r4, #0, 4
 3b4:	000e0582 	andeq	r0, lr, r2, lsl #11
 3b8:	4a020402 	bmi	813c8 <_bss_end+0x785b4>
 3bc:	02002005 	andeq	r2, r0, #5
 3c0:	054b0204 	strbeq	r0, [fp, #-516]	; 0xfffffdfc
 3c4:	04020021 	streq	r0, [r2], #-33	; 0xffffffdf
 3c8:	12052e02 	andne	r2, r5, #2, 28
 3cc:	02040200 	andeq	r0, r4, #0, 4
 3d0:	0015054a 	andseq	r0, r5, sl, asr #10
 3d4:	82020402 	andhi	r0, r2, #33554432	; 0x2000000
 3d8:	02002105 	andeq	r2, r0, #1073741825	; 0x40000001
 3dc:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 3e0:	04020017 	streq	r0, [r2], #-23	; 0xffffffe9
 3e4:	10052e02 	andne	r2, r5, r2, lsl #28
 3e8:	02040200 	andeq	r0, r4, #0, 4
 3ec:	0011052f 	andseq	r0, r1, pc, lsr #10
 3f0:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
 3f4:	02001305 	andeq	r1, r0, #335544320	; 0x14000000
 3f8:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 3fc:	04020005 	streq	r0, [r2], #-5
 400:	01054602 	tsteq	r5, r2, lsl #12
 404:	009e8288 	addseq	r8, lr, r8, lsl #5
 408:	06010402 	streq	r0, [r1], -r2, lsl #8
 40c:	06270566 	strteq	r0, [r7], -r6, ror #10
 410:	827ee103 	rsbshi	lr, lr, #-1073741824	; 0xc0000000
 414:	9f030105 	svcls	0x00030105
 418:	4a9e9e01 	bmi	fe7a7c24 <_bss_end+0xfe79ee10>
 41c:	01000a02 	tsteq	r0, r2, lsl #20
 420:	00010501 	andeq	r0, r1, r1, lsl #10
 424:	87600205 	strbhi	r0, [r0, -r5, lsl #4]!
 428:	0e030000 	cdpeq	0, 0, cr0, cr3, cr0, {0}
 42c:	83100501 	tsthi	r0, #4194304	; 0x400000
 430:	67010567 	strvs	r0, [r1, -r7, ror #10]
 434:	01000802 	tsteq	r0, r2, lsl #16
 438:	00010501 	andeq	r0, r1, r1, lsl #10
 43c:	87980205 	ldrhi	r0, [r8, r5, lsl #4]
 440:	21030000 	mrscs	r0, (UNDEF: 3)
 444:	83120501 	tsthi	r2, #4194304	; 0x400000
 448:	054a1705 	strbeq	r1, [sl, #-1797]	; 0xfffff8fb
 44c:	14054a05 	strne	r4, [r5], #-2565	; 0xfffff5fb
 450:	0905674c 	stmdbeq	r5, {r2, r3, r6, r8, r9, sl, sp, lr}
 454:	6912054a 	ldmdbvs	r2, {r1, r3, r6, r8, sl}
 458:	054a1705 	strbeq	r1, [sl, #-1797]	; 0xfffff8fb
 45c:	0f054a05 	svceq	0x00054a05
 460:	4b16054c 	blmi	581998 <_bss_end+0x578b84>
 464:	054a1f05 	strbeq	r1, [sl, #-3845]	; 0xfffff0fb
 468:	01052e14 	tsteq	r5, r4, lsl lr
 46c:	0006024c 	andeq	r0, r6, ip, asr #4
 470:	01050101 	tsteq	r5, r1, lsl #2
 474:	20020500 	andcs	r0, r2, r0, lsl #10
 478:	03000088 	movweq	r0, #136	; 0x88
 47c:	050100c0 	streq	r0, [r1, #-192]	; 0xffffff40
 480:	01058313 	tsteq	r5, r3, lsl r3
 484:	00080267 	andeq	r0, r8, r7, ror #4
 488:	01800101 	orreq	r0, r0, r1, lsl #2
 48c:	00030000 	andeq	r0, r3, r0
 490:	000000b8 	strheq	r0, [r0], -r8
 494:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
 498:	0101000d 	tsteq	r1, sp
 49c:	00000101 	andeq	r0, r0, r1, lsl #2
 4a0:	00000100 	andeq	r0, r0, r0, lsl #2
 4a4:	6e6d2f01 	cdpvs	15, 6, cr2, cr13, cr1, {0}
 4a8:	2f632f74 	svccs	0x00632f74
 4ac:	72657355 	rsbvc	r7, r5, #1409286145	; 0x54000001
 4b0:	754b2f73 	strbvc	r2, [fp, #-3955]	; 0xfffff08d
 4b4:	442f6162 	strtmi	r6, [pc], #-354	; 4bc <CPSR_IRQ_INHIBIT+0x43c>
 4b8:	6d75636f 	ldclvs	3, cr6, [r5, #-444]!	; 0xfffffe44
 4bc:	73746e65 	cmnvc	r4, #1616	; 0x650
 4c0:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
 4c4:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
 4c8:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 4cc:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
 4d0:	322f7365 	eorcc	r7, pc, #-1811939327	; 0x94000001
 4d4:	50462d31 	subpl	r2, r6, r1, lsr sp
 4d8:	656b2f55 	strbvs	r2, [fp, #-3925]!	; 0xfffff0ab
 4dc:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
 4e0:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
 4e4:	6e6d2f00 	cdpvs	15, 6, cr2, cr13, cr0, {0}
 4e8:	2f632f74 	svccs	0x00632f74
 4ec:	72657355 	rsbvc	r7, r5, #1409286145	; 0x54000001
 4f0:	754b2f73 	strbvc	r2, [fp, #-3955]	; 0xfffff08d
 4f4:	442f6162 	strtmi	r6, [pc], #-354	; 4fc <CPSR_IRQ_INHIBIT+0x47c>
 4f8:	6d75636f 	ldclvs	3, cr6, [r5, #-444]!	; 0xfffffe44
 4fc:	73746e65 	cmnvc	r4, #1616	; 0x650
 500:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
 504:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
 508:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 50c:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
 510:	322f7365 	eorcc	r7, pc, #-1811939327	; 0x94000001
 514:	50462d31 	subpl	r2, r6, r1, lsr sp
 518:	656b2f55 	strbvs	r2, [fp, #-3925]!	; 0xfffff0ab
 51c:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
 520:	636e692f 	cmnvs	lr, #770048	; 0xbc000
 524:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
 528:	6972642f 	ldmdbvs	r2!, {r0, r1, r2, r3, r5, sl, sp, lr}^
 52c:	73726576 	cmnvc	r2, #494927872	; 0x1d800000
 530:	616d0000 	cmnvs	sp, r0
 534:	632e6e69 			; <UNDEFINED> instruction: 0x632e6e69
 538:	01007070 	tsteq	r0, r0, ror r0
 53c:	6f6d0000 	svcvs	0x006d0000
 540:	6f74696e 	svcvs	0x0074696e
 544:	00682e72 	rsbeq	r2, r8, r2, ror lr
 548:	00000002 	andeq	r0, r0, r2
 54c:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
 550:	00884c02 	addeq	r4, r8, r2, lsl #24
 554:	0b051500 	bleq	14595c <_bss_end+0x13cb48>
 558:	4b4b4b83 	blmi	12d336c <_bss_end+0x12ca558>
 55c:	054c0e05 	strbeq	r0, [ip, #-3589]	; 0xfffff1fb
 560:	04020017 	streq	r0, [r2], #-23	; 0xffffffe9
 564:	18054a03 	stmdane	r5, {r0, r1, r9, fp, lr}
 568:	02040200 	andeq	r0, r4, #0, 4
 56c:	00100568 	andseq	r0, r0, r8, ror #10
 570:	66020402 	strvs	r0, [r2], -r2, lsl #8
 574:	02000e05 	andeq	r0, r0, #5, 28	; 0x50
 578:	05670204 	strbeq	r0, [r7, #-516]!	; 0xfffffdfc
 57c:	04020015 	streq	r0, [r2], #-21	; 0xffffffeb
 580:	19056702 	stmdbne	r5, {r1, r8, r9, sl, sp, lr}
 584:	02040200 	andeq	r0, r4, #0, 4
 588:	00270566 	eoreq	r0, r7, r6, ror #10
 58c:	4a020402 	bmi	8159c <_bss_end+0x78788>
 590:	02003105 	andeq	r3, r0, #1073741825	; 0x40000001
 594:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 598:	04020035 	streq	r0, [r2], #-53	; 0xffffffcb
 59c:	2c054a02 			; <UNDEFINED> instruction: 0x2c054a02
 5a0:	02040200 	andeq	r0, r4, #0, 4
 5a4:	001d052e 	andseq	r0, sp, lr, lsr #10
 5a8:	4a020402 	bmi	815b8 <_bss_end+0x787a4>
 5ac:	02000e05 	andeq	r0, r0, #5, 28	; 0x50
 5b0:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 5b4:	04020005 	streq	r0, [r2], #-5
 5b8:	0c054602 	stceq	6, cr4, [r5], {2}
 5bc:	4b010589 	blmi	41be8 <_bss_end+0x38dd4>
 5c0:	67130585 	ldrvs	r0, [r3, -r5, lsl #11]
 5c4:	4b4c0b05 	blmi	13031e0 <_bss_end+0x12fa3cc>
 5c8:	4b4b4c4c 	blmi	12d3700 <_bss_end+0x12ca8ec>
 5cc:	4e21054b 	cfsh64mi	mvdx0, mvdx1, #43
 5d0:	05672505 	strbeq	r2, [r7, #-1285]!	; 0xfffffafb
 5d4:	0d05662c 	stceq	6, cr6, [r5, #-176]	; 0xffffff50
 5d8:	6812054a 	ldmdavs	r2, {r1, r3, r6, r8, sl}
 5dc:	02001b05 	andeq	r1, r0, #5120	; 0x1400
 5e0:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
 5e4:	04020019 	streq	r0, [r2], #-25	; 0xffffffe7
 5e8:	09058402 	stmdbeq	r5, {r1, sl, pc}
 5ec:	02040200 	andeq	r0, r4, #0, 4
 5f0:	87150564 	ldrhi	r0, [r5, -r4, ror #10]
 5f4:	05681f05 	strbeq	r1, [r8, #-3845]!	; 0xfffff0fb
 5f8:	1a05660f 	bne	159e3c <_bss_end+0x151028>
 5fc:	66090567 	strvs	r0, [r9], -r7, ror #10
 600:	05841a05 	streq	r1, [r4, #2565]	; 0xa05
 604:	05056613 	streq	r6, [r5, #-1555]	; 0xfffff9ed
 608:	000a0268 	andeq	r0, sl, r8, ror #4
 60c:	00820101 	addeq	r0, r2, r1, lsl #2
 610:	00030000 	andeq	r0, r3, r0
 614:	0000005e 	andeq	r0, r0, lr, asr r0
 618:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
 61c:	0101000d 	tsteq	r1, sp
 620:	00000101 	andeq	r0, r0, r1, lsl #2
 624:	00000100 	andeq	r0, r0, r0, lsl #2
 628:	6e6d2f01 	cdpvs	15, 6, cr2, cr13, cr1, {0}
 62c:	2f632f74 	svccs	0x00632f74
 630:	72657355 	rsbvc	r7, r5, #1409286145	; 0x54000001
 634:	754b2f73 	strbvc	r2, [fp, #-3955]	; 0xfffff08d
 638:	442f6162 	strtmi	r6, [pc], #-354	; 640 <CPSR_IRQ_INHIBIT+0x5c0>
 63c:	6d75636f 	ldclvs	3, cr6, [r5, #-444]!	; 0xfffffe44
 640:	73746e65 	cmnvc	r4, #1616	; 0x650
 644:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
 648:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
 64c:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 650:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
 654:	322f7365 	eorcc	r7, pc, #-1811939327	; 0x94000001
 658:	50462d31 	subpl	r2, r6, r1, lsr sp
 65c:	656b2f55 	strbvs	r2, [fp, #-3925]!	; 0xfffff0ab
 660:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
 664:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
 668:	74730000 	ldrbtvc	r0, [r3], #-0
 66c:	2e747261 	cdpcs	2, 7, cr7, cr4, cr1, {3}
 670:	00010073 	andeq	r0, r1, r3, ror r0
 674:	05000000 	streq	r0, [r0, #-0]
 678:	00800002 	addeq	r0, r0, r2
 67c:	01100300 	tsteq	r0, r0, lsl #6
 680:	2f302f31 	svccs	0x00302f31
 684:	312f2f2f 			; <UNDEFINED> instruction: 0x312f2f2f
 688:	2f302f2f 	svccs	0x00302f2f
 68c:	02312f2f 	eorseq	r2, r1, #47, 30	; 0xbc
 690:	01010002 	tsteq	r1, r2
 694:	000000e3 	andeq	r0, r0, r3, ror #1
 698:	00620003 	rsbeq	r0, r2, r3
 69c:	01020000 	mrseq	r0, (UNDEF: 2)
 6a0:	000d0efb 	strdeq	r0, [sp], -fp
 6a4:	01010101 	tsteq	r1, r1, lsl #2
 6a8:	01000000 	mrseq	r0, (UNDEF: 0)
 6ac:	2f010000 	svccs	0x00010000
 6b0:	2f746e6d 	svccs	0x00746e6d
 6b4:	73552f63 	cmpvc	r5, #396	; 0x18c
 6b8:	2f737265 	svccs	0x00737265
 6bc:	6162754b 	cmnvs	r2, fp, asr #10
 6c0:	636f442f 	cmnvs	pc, #788529152	; 0x2f000000
 6c4:	6e656d75 	mcrvs	13, 3, r6, cr5, cr5, {3}
 6c8:	5a2f7374 	bpl	bdd4a0 <_bss_end+0xbd468c>
 6cc:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 540 <CPSR_IRQ_INHIBIT+0x4c0>
 6d0:	2f657461 	svccs	0x00657461
 6d4:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
 6d8:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
 6dc:	2d31322f 	lfmcs	f3, 4, [r1, #-188]!	; 0xffffff44
 6e0:	2f555046 	svccs	0x00555046
 6e4:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 6e8:	732f6c65 			; <UNDEFINED> instruction: 0x732f6c65
 6ec:	00006372 	andeq	r6, r0, r2, ror r3
 6f0:	72617473 	rsbvc	r7, r1, #1929379840	; 0x73000000
 6f4:	2e707574 	mrccs	5, 3, r7, cr0, cr4, {3}
 6f8:	00707063 	rsbseq	r7, r0, r3, rrx
 6fc:	00000001 	andeq	r0, r0, r1
 700:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
 704:	008a3402 	addeq	r3, sl, r2, lsl #8
 708:	01140300 	tsteq	r4, r0, lsl #6
 70c:	056a0c05 	strbeq	r0, [sl, #-3077]!	; 0xfffff3fb
 710:	04020022 	streq	r0, [r2], #-34	; 0xffffffde
 714:	0c056603 	stceq	6, cr6, [r5], {3}
 718:	02040200 	andeq	r0, r4, #0, 4
 71c:	000505bb 			; <UNDEFINED> instruction: 0x000505bb
 720:	65020402 	strvs	r0, [r2, #-1026]	; 0xfffffbfe
 724:	05850c05 	streq	r0, [r5, #3077]	; 0xc05
 728:	05bd2f01 	ldreq	r2, [sp, #3841]!	; 0xf01
 72c:	27056b10 	smladcs	r5, r0, fp, r6
 730:	03040200 	movweq	r0, #16896	; 0x4200
 734:	000a054a 	andeq	r0, sl, sl, asr #10
 738:	83020402 	movwhi	r0, #9218	; 0x2402
 73c:	02001105 	andeq	r1, r0, #1073741825	; 0x40000001
 740:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 744:	04020005 	streq	r0, [r2], #-5
 748:	0c052d02 	stceq	13, cr2, [r5], {2}
 74c:	2f010585 	svccs	0x00010585
 750:	6a1005a1 	bvs	401ddc <_bss_end+0x3f8fc8>
 754:	02002705 	andeq	r2, r0, #1310720	; 0x140000
 758:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
 75c:	0402000a 	streq	r0, [r2], #-10
 760:	11058302 	tstne	r5, r2, lsl #6
 764:	02040200 	andeq	r0, r4, #0, 4
 768:	0005054a 	andeq	r0, r5, sl, asr #10
 76c:	2d020402 	cfstrscs	mvf0, [r2, #-8]
 770:	05850c05 	streq	r0, [r5, #3077]	; 0xc05
 774:	0a022f01 	beq	8c380 <_bss_end+0x8356c>
 778:	79010100 	stmdbvc	r1, {r8}
 77c:	03000000 	movweq	r0, #0
 780:	00004600 	andeq	r4, r0, r0, lsl #12
 784:	fb010200 	blx	40f8e <_bss_end+0x3817a>
 788:	01000d0e 	tsteq	r0, lr, lsl #26
 78c:	00010101 	andeq	r0, r1, r1, lsl #2
 790:	00010000 	andeq	r0, r1, r0
 794:	2e2e0100 	sufcse	f0, f6, f0
 798:	2f2e2e2f 	svccs	0x002e2e2f
 79c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 7a0:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 7a4:	2f2e2e2f 	svccs	0x002e2e2f
 7a8:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
 7ac:	632f6363 			; <UNDEFINED> instruction: 0x632f6363
 7b0:	69666e6f 	stmdbvs	r6!, {r0, r1, r2, r3, r5, r6, r9, sl, fp, sp, lr}^
 7b4:	72612f67 	rsbvc	r2, r1, #412	; 0x19c
 7b8:	6c00006d 	stcvs	0, cr0, [r0], {109}	; 0x6d
 7bc:	66316269 	ldrtvs	r6, [r1], -r9, ror #4
 7c0:	73636e75 	cmnvc	r3, #1872	; 0x750
 7c4:	0100532e 	tsteq	r0, lr, lsr #6
 7c8:	00000000 	andeq	r0, r0, r0
 7cc:	8b4c0205 	blhi	1300fe8 <_bss_end+0x12f81d4>
 7d0:	cf030000 	svcgt	0x00030000
 7d4:	2f300108 	svccs	0x00300108
 7d8:	2f2f2f2f 	svccs	0x002f2f2f
 7dc:	01d00230 	bicseq	r0, r0, r0, lsr r2
 7e0:	2f312f14 	svccs	0x00312f14
 7e4:	2f4c302f 	svccs	0x004c302f
 7e8:	661f0332 			; <UNDEFINED> instruction: 0x661f0332
 7ec:	2f2f2f2f 	svccs	0x002f2f2f
 7f0:	022f2f2f 	eoreq	r2, pc, #47, 30	; 0xbc
 7f4:	01010002 	tsteq	r1, r2
 7f8:	0000005c 	andeq	r0, r0, ip, asr r0
 7fc:	00460003 	subeq	r0, r6, r3
 800:	01020000 	mrseq	r0, (UNDEF: 2)
 804:	000d0efb 	strdeq	r0, [sp], -fp
 808:	01010101 	tsteq	r1, r1, lsl #2
 80c:	01000000 	mrseq	r0, (UNDEF: 0)
 810:	2e010000 	cdpcs	0, 0, cr0, cr1, cr0, {0}
 814:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 818:	2f2e2e2f 	svccs	0x002e2e2f
 81c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 820:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 824:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
 828:	2f636367 	svccs	0x00636367
 82c:	666e6f63 	strbtvs	r6, [lr], -r3, ror #30
 830:	612f6769 			; <UNDEFINED> instruction: 0x612f6769
 834:	00006d72 	andeq	r6, r0, r2, ror sp
 838:	3162696c 	cmncc	r2, ip, ror #18
 83c:	636e7566 	cmnvs	lr, #427819008	; 0x19800000
 840:	00532e73 	subseq	r2, r3, r3, ror lr
 844:	00000001 	andeq	r0, r0, r1
 848:	58020500 	stmdapl	r2, {r8, sl}
 84c:	0300008d 	movweq	r0, #141	; 0x8d
 850:	02010bb9 	andeq	r0, r1, #189440	; 0x2e400
 854:	01010002 	tsteq	r1, r2
 858:	000000a4 	andeq	r0, r0, r4, lsr #1
 85c:	009e0003 	addseq	r0, lr, r3
 860:	01020000 	mrseq	r0, (UNDEF: 2)
 864:	000d0efb 	strdeq	r0, [sp], -fp
 868:	01010101 	tsteq	r1, r1, lsl #2
 86c:	01000000 	mrseq	r0, (UNDEF: 0)
 870:	2e010000 	cdpcs	0, 0, cr0, cr1, cr0, {0}
 874:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 878:	2f2e2e2f 	svccs	0x002e2e2f
 87c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 880:	2f2e2f2e 	svccs	0x002e2f2e
 884:	00636367 	rsbeq	r6, r3, r7, ror #6
 888:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 88c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 890:	2f2e2e2f 	svccs	0x002e2e2f
 894:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 898:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
 89c:	63636762 	cmnvs	r3, #25690112	; 0x1880000
 8a0:	2f2e2e2f 	svccs	0x002e2e2f
 8a4:	2f636367 	svccs	0x00636367
 8a8:	666e6f63 	strbtvs	r6, [lr], -r3, ror #30
 8ac:	612f6769 			; <UNDEFINED> instruction: 0x612f6769
 8b0:	2e006d72 	mcrcs	13, 0, r6, cr0, cr2, {3}
 8b4:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 8b8:	2f2e2e2f 	svccs	0x002e2e2f
 8bc:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 8c0:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 8c4:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
 8c8:	00636367 	rsbeq	r6, r3, r7, ror #6
 8cc:	6d726100 	ldfvse	f6, [r2, #-0]
 8d0:	6173692d 	cmnvs	r3, sp, lsr #18
 8d4:	0100682e 	tsteq	r0, lr, lsr #16
 8d8:	72610000 	rsbvc	r0, r1, #0
 8dc:	00682e6d 	rsbeq	r2, r8, sp, ror #28
 8e0:	67000002 	strvs	r0, [r0, -r2]
 8e4:	632d6c62 			; <UNDEFINED> instruction: 0x632d6c62
 8e8:	73726f74 	cmnvc	r2, #116, 30	; 0x1d0
 8ec:	0300682e 	movweq	r6, #2094	; 0x82e
 8f0:	696c0000 	stmdbvs	ip!, {}^	; <UNPREDICTABLE>
 8f4:	63636762 	cmnvs	r3, #25690112	; 0x1880000
 8f8:	00632e32 	rsbeq	r2, r3, r2, lsr lr
 8fc:	00000003 	andeq	r0, r0, r3

Disassembly of section .debug_str:

00000000 <.debug_str>:
   0:	78635f5f 	stmdavc	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, sl, fp, ip, lr}^
   4:	75675f61 	strbvc	r5, [r7, #-3937]!	; 0xfffff09f
   8:	5f647261 	svcpl	0x00647261
   c:	656c6572 	strbvs	r6, [ip, #-1394]!	; 0xfffffa8e
  10:	00657361 	rsbeq	r7, r5, r1, ror #6
  14:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
  18:	552f632f 	strpl	r6, [pc, #-815]!	; fffffcf1 <_bss_end+0xffff6edd>
  1c:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
  20:	62754b2f 	rsbsvs	r4, r5, #48128	; 0xbc00
  24:	6f442f61 	svcvs	0x00442f61
  28:	656d7563 	strbvs	r7, [sp, #-1379]!	; 0xfffffa9d
  2c:	2f73746e 	svccs	0x0073746e
  30:	6f72655a 	svcvs	0x0072655a
  34:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
  38:	6178652f 	cmnvs	r8, pc, lsr #10
  3c:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
  40:	31322f73 	teqcc	r2, r3, ror pc
  44:	5550462d 	ldrbpl	r4, [r0, #-1581]	; 0xfffff9d3
  48:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
  4c:	2f6c656e 	svccs	0x006c656e
  50:	2f637273 	svccs	0x00637273
  54:	2e787863 	cdpcs	8, 7, cr7, cr8, cr3, {3}
  58:	00707063 	rsbseq	r7, r0, r3, rrx
  5c:	78635f5f 	stmdavc	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, sl, fp, ip, lr}^
  60:	75675f61 	strbvc	r5, [r7, #-3937]!	; 0xfffff09f
  64:	5f647261 	svcpl	0x00647261
  68:	726f6261 	rsbvc	r6, pc, #268435462	; 0x10000006
  6c:	5f5f0074 	svcpl	0x005f0074
  70:	5f6f7364 	svcpl	0x006f7364
  74:	646e6168 	strbtvs	r6, [lr], #-360	; 0xfffffe98
  78:	5f00656c 	svcpl	0x0000656c
  7c:	6178635f 	cmnvs	r8, pc, asr r3
  80:	6574615f 	ldrbvs	r6, [r4, #-351]!	; 0xfffffea1
  84:	00746978 	rsbseq	r6, r4, r8, ror r9
  88:	20554e47 	subscs	r4, r5, r7, asr #28
  8c:	312b2b43 			; <UNDEFINED> instruction: 0x312b2b43
  90:	30312034 	eorscc	r2, r1, r4, lsr r0
  94:	312e332e 			; <UNDEFINED> instruction: 0x312e332e
  98:	32303220 	eorscc	r3, r0, #32, 4
  9c:	32363031 	eorscc	r3, r6, #49	; 0x31
  a0:	72282031 	eorvc	r2, r8, #49	; 0x31
  a4:	61656c65 	cmnvs	r5, r5, ror #24
  a8:	20296573 	eorcs	r6, r9, r3, ror r5
  ac:	6c666d2d 	stclvs	13, cr6, [r6], #-180	; 0xffffff4c
  b0:	2d74616f 	ldfcse	f6, [r4, #-444]!	; 0xfffffe44
  b4:	3d696261 	sfmcc	f6, 2, [r9, #-388]!	; 0xfffffe7c
  b8:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
  bc:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
  c0:	763d7570 			; <UNDEFINED> instruction: 0x763d7570
  c4:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
  c8:	6f6c666d 	svcvs	0x006c666d
  cc:	612d7461 			; <UNDEFINED> instruction: 0x612d7461
  d0:	683d6962 	ldmdavs	sp!, {r1, r5, r6, r8, fp, sp, lr}
  d4:	20647261 	rsbcs	r7, r4, r1, ror #4
  d8:	70666d2d 	rsbvc	r6, r6, sp, lsr #26
  dc:	66763d75 			; <UNDEFINED> instruction: 0x66763d75
  e0:	6d2d2070 	stcvs	0, cr2, [sp, #-448]!	; 0xfffffe40
  e4:	656e7574 	strbvs	r7, [lr, #-1396]!	; 0xfffffa8c
  e8:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
  ec:	36373131 			; <UNDEFINED> instruction: 0x36373131
  f0:	2d667a6a 	vstmdbcs	r6!, {s15-s120}
  f4:	6d2d2073 	stcvs	0, cr2, [sp, #-460]!	; 0xfffffe34
  f8:	206d7261 	rsbcs	r7, sp, r1, ror #4
  fc:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
 100:	613d6863 	teqvs	sp, r3, ror #16
 104:	36766d72 			; <UNDEFINED> instruction: 0x36766d72
 108:	662b6b7a 			; <UNDEFINED> instruction: 0x662b6b7a
 10c:	672d2070 			; <UNDEFINED> instruction: 0x672d2070
 110:	20672d20 	rsbcs	r2, r7, r0, lsr #26
 114:	20304f2d 	eorscs	r4, r0, sp, lsr #30
 118:	00304f2d 	eorseq	r4, r0, sp, lsr #30
 11c:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
 120:	552f632f 	strpl	r6, [pc, #-815]!	; fffffdf9 <_bss_end+0xffff6fe5>
 124:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 128:	62754b2f 	rsbsvs	r4, r5, #48128	; 0xbc00
 12c:	6f442f61 	svcvs	0x00442f61
 130:	656d7563 	strbvs	r7, [sp, #-1379]!	; 0xfffffa9d
 134:	2f73746e 	svccs	0x0073746e
 138:	6f72655a 	svcvs	0x0072655a
 13c:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
 140:	6178652f 	cmnvs	r8, pc, lsr #10
 144:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
 148:	31322f73 	teqcc	r2, r3, ror pc
 14c:	5550462d 	ldrbpl	r4, [r0, #-1581]	; 0xfffff9d3
 150:	6975622f 	ldmdbvs	r5!, {r0, r1, r2, r3, r5, r9, sp, lr}^
 154:	5f00646c 	svcpl	0x0000646c
 158:	6178635f 	cmnvs	r8, pc, asr r3
 15c:	6175675f 	cmnvs	r5, pc, asr r7
 160:	615f6472 	cmpvs	pc, r2, ror r4	; <UNPREDICTABLE>
 164:	69757163 	ldmdbvs	r5!, {r0, r1, r5, r6, r8, ip, sp, lr}^
 168:	5f006572 	svcpl	0x00006572
 16c:	7878635f 	ldmdavc	r8!, {r0, r1, r2, r3, r4, r6, r8, r9, sp, lr}^
 170:	76696261 	strbtvc	r6, [r9], -r1, ror #4
 174:	5f5f0031 	svcpl	0x005f0031
 178:	5f617863 	svcpl	0x00617863
 17c:	65727570 	ldrbvs	r7, [r2, #-1392]!	; 0xfffffa90
 180:	7269765f 	rsbvc	r7, r9, #99614720	; 0x5f00000
 184:	6c617574 	cfstr64vs	mvdx7, [r1], #-464	; 0xfffffe30
 188:	615f5f00 	cmpvs	pc, r0, lsl #30
 18c:	69626165 	stmdbvs	r2!, {r0, r2, r5, r6, r8, sp, lr}^
 190:	776e755f 			; <UNDEFINED> instruction: 0x776e755f
 194:	5f646e69 	svcpl	0x00646e69
 198:	5f707063 	svcpl	0x00707063
 19c:	00317270 	eorseq	r7, r1, r0, ror r2
 1a0:	75675f5f 	strbvc	r5, [r7, #-3935]!	; 0xfffff0a1
 1a4:	00647261 	rsbeq	r7, r4, r1, ror #4
 1a8:	676e6f6c 	strbvs	r6, [lr, -ip, ror #30]!
 1ac:	6e6f6c20 	cdpvs	12, 6, cr6, cr15, cr0, {1}
 1b0:	6e692067 	cdpvs	0, 6, cr2, cr9, cr7, {3}
 1b4:	5f5f0074 	svcpl	0x005f0074
 1b8:	6f697270 	svcvs	0x00697270
 1bc:	79746972 	ldmdbvc	r4!, {r1, r4, r5, r6, r8, fp, sp, lr}^
 1c0:	72635300 	rsbvc	r5, r3, #0, 6
 1c4:	006c6c6f 	rsbeq	r6, ip, pc, ror #24
 1c8:	756c6176 	strbvc	r6, [ip, #-374]!	; 0xfffffe8a
 1cc:	6f620065 	svcvs	0x00620065
 1d0:	6d006c6f 	stcvs	12, cr6, [r0, #-444]	; 0xfffffe44
 1d4:	6d756e5f 	ldclvs	14, cr6, [r5, #-380]!	; 0xfffffe84
 1d8:	5f726562 	svcpl	0x00726562
 1dc:	65736162 	ldrbvs	r6, [r3, #-354]!	; 0xfffffe9e
 1e0:	73655200 	cmnvc	r5, #0, 4
 1e4:	4e5f7465 	cdpmi	4, 5, cr7, cr15, cr5, {3}
 1e8:	65626d75 	strbvs	r6, [r2, #-3445]!	; 0xfffff28b
 1ec:	61425f72 	hvcvs	9714	; 0x25f2
 1f0:	43006573 	movwmi	r6, #1395	; 0x573
 1f4:	7261656c 	rsbvc	r6, r1, #108, 10	; 0x1b000000
 1f8:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
 1fc:	6f4d4338 	svcvs	0x004d4338
 200:	6f74696e 	svcvs	0x0074696e
 204:	45324372 	ldrmi	r4, [r2, #-882]!	; 0xfffffc8e
 208:	006a6a6a 	rsbeq	r6, sl, sl, ror #20
 20c:	384e5a5f 	stmdacc	lr, {r0, r1, r2, r3, r4, r6, r9, fp, ip, lr}^
 210:	6e6f4d43 	cdpvs	13, 6, cr4, cr15, cr3, {2}
 214:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
 218:	64413331 	strbvs	r3, [r1], #-817	; 0xfffffccf
 21c:	7473756a 	ldrbtvc	r7, [r3], #-1386	; 0xfffffa96
 220:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
 224:	45726f73 	ldrbmi	r6, [r2, #-3955]!	; 0xfffff08d
 228:	74690076 	strbtvc	r0, [r9], #-118	; 0xffffff8a
 22c:	5200616f 	andpl	r6, r0, #-1073741797	; 0xc000001b
 230:	74657365 	strbtvc	r7, [r5], #-869	; 0xfffffc9b
 234:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
 238:	00726f73 	rsbseq	r6, r2, r3, ror pc
 23c:	69736e75 	ldmdbvs	r3!, {r0, r2, r4, r5, r6, r9, sl, fp, sp, lr}^
 240:	64656e67 	strbtvs	r6, [r5], #-3687	; 0xfffff199
 244:	61686320 	cmnvs	r8, r0, lsr #6
 248:	68740072 	ldmdavs	r4!, {r1, r4, r5, r6}^
 24c:	41007369 	tstmi	r0, r9, ror #6
 250:	73756a64 	cmnvc	r5, #100, 20	; 0x64000
 254:	75435f74 	strbvc	r5, [r3, #-3956]	; 0xfffff08c
 258:	726f7372 	rsbvc	r7, pc, #-939524095	; 0xc8000001
 25c:	754e4e00 	strbvc	r4, [lr, #-3584]	; 0xfffff200
 260:	7265626d 	rsbvc	r6, r5, #-805306362	; 0xd0000006
 264:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
 268:	50540065 	subspl	r0, r4, r5, rrx
 26c:	7469736f 	strbtvc	r7, [r9], #-879	; 0xfffffc91
 270:	006e6f69 	rsbeq	r6, lr, r9, ror #30
 274:	384e5a5f 	stmdacc	lr, {r0, r1, r2, r3, r4, r6, r9, fp, ip, lr}^
 278:	6e6f4d43 	cdpvs	13, 6, cr4, cr15, cr3, {2}
 27c:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
 280:	65523731 	ldrbvs	r3, [r2, #-1841]	; 0xfffff8cf
 284:	5f746573 	svcpl	0x00746573
 288:	626d754e 	rsbvs	r7, sp, #327155712	; 0x13800000
 28c:	425f7265 	subsmi	r7, pc, #1342177286	; 0x50000006
 290:	45657361 	strbmi	r7, [r5, #-865]!	; 0xfffffc9f
 294:	5f6d0076 	svcpl	0x006d0076
 298:	696e6f6d 	stmdbvs	lr!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
 29c:	00726f74 	rsbseq	r6, r2, r4, ror pc
 2a0:	4f4c475f 	svcmi	0x004c475f
 2a4:	5f4c4142 	svcpl	0x004c4142
 2a8:	6275735f 	rsbsvs	r7, r5, #2080374785	; 0x7c000001
 2ac:	735f495f 	cmpvc	pc, #1556480	; 0x17c000
 2b0:	696e6f4d 	stmdbvs	lr!, {r0, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
 2b4:	00726f74 	rsbseq	r6, r2, r4, ror pc
 2b8:	696e6f6d 	stmdbvs	lr!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
 2bc:	5f726f74 	svcpl	0x00726f74
 2c0:	65736162 	ldrbvs	r6, [r3, #-354]!	; 0xfffffe9e
 2c4:	6464615f 	strbtvs	r6, [r4], #-351	; 0xfffffea1
 2c8:	4d430072 	stclmi	0, cr0, [r3, #-456]	; 0xfffffe38
 2cc:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
 2d0:	6f00726f 	svcvs	0x0000726f
 2d4:	61726570 	cmnvs	r2, r0, ror r5
 2d8:	3c726f74 	ldclcc	15, cr6, [r2], #-464	; 0xfffffe30
 2dc:	5a5f003c 	bpl	17c03d4 <_bss_end+0x17b75c0>
 2e0:	4d43384e 	stclmi	8, cr3, [r3, #-312]	; 0xfffffec8
 2e4:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
 2e8:	736c726f 	cmnvc	ip, #-268435450	; 0xf0000006
 2ec:	634b5045 	movtvs	r5, #45125	; 0xb045
 2f0:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
 2f4:	6f4d4338 	svcvs	0x004d4338
 2f8:	6f74696e 	svcvs	0x0074696e
 2fc:	74693472 	strbtvc	r3, [r9], #-1138	; 0xfffffb8e
 300:	6a45616f 	bvs	11588c4 <_bss_end+0x114fab0>
 304:	006a6350 	rsbeq	r6, sl, r0, asr r3
 308:	65685f6d 	strbvs	r5, [r8, #-3949]!	; 0xfffff093
 30c:	74686769 	strbtvc	r6, [r8], #-1897	; 0xfffff897
 310:	635f6d00 	cmpvs	pc, #0, 26
 314:	6f737275 	svcvs	0x00737275
 318:	68430072 	stmdavs	r3, {r1, r4, r5, r6}^
 31c:	6f437261 	svcvs	0x00437261
 320:	7241766e 	subvc	r7, r1, #115343360	; 0x6e00000
 324:	5a5f0072 	bpl	17c04f4 <_bss_end+0x17b76e0>
 328:	4d43384e 	stclmi	8, cr3, [r3, #-312]	; 0xfffffec8
 32c:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
 330:	736c726f 	cmnvc	ip, #-268435450	; 0xf0000006
 334:	5f006245 	svcpl	0x00006245
 338:	43384e5a 	teqmi	r8, #1440	; 0x5a0
 33c:	696e6f4d 	stmdbvs	lr!, {r0, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
 340:	6c726f74 	ldclvs	15, cr6, [r2], #-464	; 0xfffffe30
 344:	00634573 	rsbeq	r4, r3, r3, ror r5
 348:	69775f6d 	ldmdbvs	r7!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
 34c:	00687464 	rsbeq	r7, r8, r4, ror #8
 350:	384e5a5f 	stmdacc	lr, {r0, r1, r2, r3, r4, r6, r9, fp, ip, lr}^
 354:	6e6f4d43 	cdpvs	13, 6, cr4, cr15, cr3, {2}
 358:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
 35c:	72635336 	rsbvc	r5, r3, #-671088640	; 0xd8000000
 360:	456c6c6f 	strbmi	r6, [ip, #-3183]!	; 0xfffff391
 364:	5a5f0076 	bpl	17c0544 <_bss_end+0x17b7730>
 368:	4d43384e 	stclmi	8, cr3, [r3, #-312]	; 0xfffffec8
 36c:	74696e6f 	strbtvc	r6, [r9], #-3695	; 0xfffff191
 370:	736c726f 	cmnvc	ip, #-268435450	; 0xf0000006
 374:	5f006a45 	svcpl	0x00006a45
 378:	43384e5a 	teqmi	r8, #1440	; 0x5a0
 37c:	696e6f4d 	stmdbvs	lr!, {r0, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
 380:	31726f74 	cmncc	r2, r4, ror pc
 384:	73655232 	cmnvc	r5, #536870915	; 0x20000003
 388:	435f7465 	cmpmi	pc, #1694498816	; 0x65000000
 38c:	6f737275 	svcvs	0x00737275
 390:	00764572 	rsbseq	r4, r6, r2, ror r5
 394:	384e5a5f 	stmdacc	lr, {r0, r1, r2, r3, r4, r6, r9, fp, ip, lr}^
 398:	6e6f4d43 	cdpvs	13, 6, cr4, cr15, cr3, {2}
 39c:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
 3a0:	6a453443 	bvs	114d4b4 <_bss_end+0x11446a0>
 3a4:	5f006a6a 	svcpl	0x00006a6a
 3a8:	43384e5a 	teqmi	r8, #1440	; 0x5a0
 3ac:	696e6f4d 	stmdbvs	lr!, {r0, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
 3b0:	35726f74 	ldrbcc	r6, [r2, #-3956]!	; 0xfffff08c
 3b4:	61656c43 	cmnvs	r5, r3, asr #24
 3b8:	00764572 	rsbseq	r4, r6, r2, ror r5
 3bc:	41464544 	cmpmi	r6, r4, asr #10
 3c0:	5f544c55 	svcpl	0x00544c55
 3c4:	424d554e 	submi	r5, sp, #327155712	; 0x13800000
 3c8:	425f5245 	subsmi	r5, pc, #1342177284	; 0x50000004
 3cc:	00455341 	subeq	r5, r5, r1, asr #6
 3d0:	384e5a5f 	stmdacc	lr, {r0, r1, r2, r3, r4, r6, r9, fp, ip, lr}^
 3d4:	6e6f4d43 	cdpvs	13, 6, cr4, cr15, cr3, {2}
 3d8:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
 3dc:	4e45736c 	cdpmi	3, 4, cr7, cr5, cr12, {3}
 3e0:	32315f53 	eorscc	r5, r1, #332	; 0x14c
 3e4:	6d754e4e 	ldclvs	14, cr4, [r5, #-312]!	; 0xfffffec8
 3e8:	5f726562 	svcpl	0x00726562
 3ec:	65736142 	ldrbvs	r6, [r3, #-322]!	; 0xfffffebe
 3f0:	756f0045 	strbvc	r0, [pc, #-69]!	; 3b3 <CPSR_IRQ_INHIBIT+0x333>
 3f4:	74757074 	ldrbtvc	r7, [r5], #-116	; 0xffffff8c
 3f8:	706e6900 	rsbvc	r6, lr, r0, lsl #18
 3fc:	73007475 	movwvc	r7, #1141	; 0x475
 400:	6675625f 			; <UNDEFINED> instruction: 0x6675625f
 404:	00726566 	rsbseq	r6, r2, r6, ror #10
 408:	6e695f5f 	mcrvs	15, 3, r5, cr9, cr15, {2}
 40c:	61697469 	cmnvs	r9, r9, ror #8
 410:	657a696c 	ldrbvs	r6, [sl, #-2412]!	; 0xfffff694
 414:	4200705f 	andmi	r7, r0, #95	; 0x5f
 418:	45464655 	strbmi	r4, [r6, #-1621]	; 0xfffff9ab
 41c:	49535f52 	ldmdbmi	r3, {r1, r4, r6, r8, r9, sl, fp, ip, lr}^
 420:	5f00455a 	svcpl	0x0000455a
 424:	6174735f 	cmnvs	r4, pc, asr r3
 428:	5f636974 	svcpl	0x00636974
 42c:	74696e69 	strbtvc	r6, [r9], #-3689	; 0xfffff197
 430:	696c6169 	stmdbvs	ip!, {r0, r3, r5, r6, r8, sp, lr}^
 434:	6974617a 	ldmdbvs	r4!, {r1, r3, r4, r5, r6, r8, sp, lr}^
 438:	615f6e6f 	cmpvs	pc, pc, ror #28
 43c:	645f646e 	ldrbvs	r6, [pc], #-1134	; 444 <CPSR_IRQ_INHIBIT+0x3c4>
 440:	72747365 	rsbsvc	r7, r4, #-1811939327	; 0x94000001
 444:	69746375 	ldmdbvs	r4!, {r0, r2, r4, r5, r6, r8, r9, sp, lr}^
 448:	305f6e6f 	subscc	r6, pc, pc, ror #28
 44c:	6e6d2f00 	cdpvs	15, 6, cr2, cr13, cr0, {0}
 450:	2f632f74 	svccs	0x00632f74
 454:	72657355 	rsbvc	r7, r5, #1409286145	; 0x54000001
 458:	754b2f73 	strbvc	r2, [fp, #-3955]	; 0xfffff08d
 45c:	442f6162 	strtmi	r6, [pc], #-354	; 464 <CPSR_IRQ_INHIBIT+0x3e4>
 460:	6d75636f 	ldclvs	3, cr6, [r5, #-444]!	; 0xfffffe44
 464:	73746e65 	cmnvc	r4, #1616	; 0x650
 468:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
 46c:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
 470:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 474:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
 478:	322f7365 	eorcc	r7, pc, #-1811939327	; 0x94000001
 47c:	50462d31 	subpl	r2, r6, r1, lsr sp
 480:	656b2f55 	strbvs	r2, [fp, #-3925]!	; 0xfffff0ab
 484:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
 488:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
 48c:	6972642f 	ldmdbvs	r2!, {r0, r1, r2, r3, r5, sl, sp, lr}^
 490:	73726576 	cmnvc	r2, #494927872	; 0x1d800000
 494:	6e6f6d2f 	cdpvs	13, 6, cr6, cr15, cr15, {1}
 498:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
 49c:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
 4a0:	6d756e00 	ldclvs	14, cr6, [r5, #-0]
 4a4:	72617453 	rsbvc	r7, r1, #1392508928	; 0x53000000
 4a8:	5a5f0073 	bpl	17c067c <_bss_end+0x17b7868>
 4ac:	75633031 	strbvc	r3, [r3, #-49]!	; 0xffffffcf
 4b0:	6d6f7473 	cfstrdvs	mvd7, [pc, #-460]!	; 2ec <CPSR_IRQ_INHIBIT+0x26c>
 4b4:	6e69735f 	mcrvs	3, 3, r7, cr9, cr15, {2}
 4b8:	6e610066 	cdpvs	0, 6, cr0, cr1, cr6, {3}
 4bc:	00656c67 	rsbeq	r6, r5, r7, ror #24
 4c0:	6e676973 			; <UNDEFINED> instruction: 0x6e676973
 4c4:	65726600 	ldrbvs	r6, [r2, #-1536]!	; 0xfffffa00
 4c8:	6e657571 	mcrvs	5, 3, r7, cr5, cr1, {3}
 4cc:	74007963 	strvc	r7, [r0], #-2403	; 0xfffff69d
 4d0:	746e6577 	strbtvc	r6, [lr], #-1399	; 0xfffffa89
 4d4:	75630079 	strbvc	r0, [r3, #-121]!	; 0xffffff87
 4d8:	6d6f7473 	cfstrdvs	mvd7, [pc, #-460]!	; 314 <CPSR_IRQ_INHIBIT+0x294>
 4dc:	6e69735f 	mcrvs	3, 3, r7, cr9, cr15, {2}
 4e0:	6e6d2f00 	cdpvs	15, 6, cr2, cr13, cr0, {0}
 4e4:	2f632f74 	svccs	0x00632f74
 4e8:	72657355 	rsbvc	r7, r5, #1409286145	; 0x54000001
 4ec:	754b2f73 	strbvc	r2, [fp, #-3955]	; 0xfffff08d
 4f0:	442f6162 	strtmi	r6, [pc], #-354	; 4f8 <CPSR_IRQ_INHIBIT+0x478>
 4f4:	6d75636f 	ldclvs	3, cr6, [r5, #-444]!	; 0xfffffe44
 4f8:	73746e65 	cmnvc	r4, #1616	; 0x650
 4fc:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
 500:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
 504:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 508:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
 50c:	322f7365 	eorcc	r7, pc, #-1811939327	; 0x94000001
 510:	50462d31 	subpl	r2, r6, r1, lsr sp
 514:	656b2f55 	strbvs	r2, [fp, #-3925]!	; 0xfffff0ab
 518:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
 51c:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
 520:	69616d2f 	stmdbvs	r1!, {r0, r1, r2, r3, r5, r8, sl, fp, sp, lr}^
 524:	70632e6e 	rsbvc	r2, r3, lr, ror #28
 528:	65720070 	ldrbvs	r0, [r2, #-112]!	; 0xffffff90
 52c:	746c7573 	strbtvc	r7, [ip], #-1395	; 0xfffffa8d
 530:	656b5f00 	strbvs	r5, [fp, #-3840]!	; 0xfffff100
 534:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
 538:	69616d5f 	stmdbvs	r1!, {r0, r1, r2, r3, r4, r6, r8, sl, fp, sp, lr}^
 53c:	5f4d006e 	svcpl	0x004d006e
 540:	7a004950 	bvc	12a88 <_bss_end+0x9c74>
 544:	5f6f7265 	svcpl	0x006f7265
 548:	6e696f70 	mcrvs	15, 3, r6, cr9, cr0, {3}
 54c:	00315f74 	eorseq	r5, r1, r4, ror pc
 550:	6d726574 	cfldr64vs	mvdx6, [r2, #-464]!	; 0xfffffe30
 554:	63616600 	cmnvs	r1, #0, 12
 558:	69726f74 	ldmdbvs	r2!, {r2, r4, r5, r6, r8, r9, sl, fp, sp, lr}^
 55c:	2f006c61 	svccs	0x00006c61
 560:	2f746e6d 	svccs	0x00746e6d
 564:	73552f63 	cmpvc	r5, #396	; 0x18c
 568:	2f737265 	svccs	0x00737265
 56c:	6162754b 	cmnvs	r2, fp, asr #10
 570:	636f442f 	cmnvs	pc, #788529152	; 0x2f000000
 574:	6e656d75 	mcrvs	13, 3, r6, cr5, cr5, {3}
 578:	5a2f7374 	bpl	bdd350 <_bss_end+0xbd453c>
 57c:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 3f0 <CPSR_IRQ_INHIBIT+0x370>
 580:	2f657461 	svccs	0x00657461
 584:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
 588:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
 58c:	2d31322f 	lfmcs	f3, 4, [r1, #-188]!	; 0xffffff44
 590:	2f555046 	svccs	0x00555046
 594:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 598:	732f6c65 			; <UNDEFINED> instruction: 0x732f6c65
 59c:	732f6372 			; <UNDEFINED> instruction: 0x732f6372
 5a0:	74726174 	ldrbtvc	r6, [r2], #-372	; 0xfffffe8c
 5a4:	4700732e 	strmi	r7, [r0, -lr, lsr #6]
 5a8:	4120554e 			; <UNDEFINED> instruction: 0x4120554e
 5ac:	2e322053 	mrccs	0, 1, r2, cr2, cr3, {2}
 5b0:	63003833 	movwvs	r3, #2099	; 0x833
 5b4:	5f726f74 	svcpl	0x00726f74
 5b8:	00727470 	rsbseq	r7, r2, r0, ror r4
 5bc:	7373625f 	cmnvc	r3, #-268435451	; 0xf0000005
 5c0:	6174735f 	cmnvs	r4, pc, asr r3
 5c4:	66007472 			; <UNDEFINED> instruction: 0x66007472
 5c8:	7274706e 	rsbsvc	r7, r4, #110	; 0x6e
 5cc:	435f5f00 	cmpmi	pc, #0, 30
 5d0:	5f524f54 	svcpl	0x00524f54
 5d4:	5f444e45 	svcpl	0x00444e45
 5d8:	5f5f005f 	svcpl	0x005f005f
 5dc:	524f5443 	subpl	r5, pc, #1124073472	; 0x43000000
 5e0:	53494c5f 	movtpl	r4, #40031	; 0x9c5f
 5e4:	005f5f54 	subseq	r5, pc, r4, asr pc	; <UNPREDICTABLE>
 5e8:	54445f5f 	strbpl	r5, [r4], #-3935	; 0xfffff0a1
 5ec:	455f524f 	ldrbmi	r5, [pc, #-591]	; 3a5 <CPSR_IRQ_INHIBIT+0x325>
 5f0:	5f5f444e 	svcpl	0x005f444e
 5f4:	70635f00 	rsbvc	r5, r3, r0, lsl #30
 5f8:	68735f70 	ldmdavs	r3!, {r4, r5, r6, r8, r9, sl, fp, ip, lr}^
 5fc:	6f647475 	svcvs	0x00647475
 600:	5f006e77 	svcpl	0x00006e77
 604:	5f737362 	svcpl	0x00737362
 608:	00646e65 	rsbeq	r6, r4, r5, ror #28
 60c:	54445f5f 	strbpl	r5, [r4], #-3935	; 0xfffff0a1
 610:	4c5f524f 	lfmmi	f5, 2, [pc], {79}	; 0x4f
 614:	5f545349 	svcpl	0x00545349
 618:	6d2f005f 	stcvs	0, cr0, [pc, #-380]!	; 4a4 <CPSR_IRQ_INHIBIT+0x424>
 61c:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
 620:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
 624:	4b2f7372 	blmi	bdd3f4 <_bss_end+0xbd45e0>
 628:	2f616275 	svccs	0x00616275
 62c:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
 630:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
 634:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
 638:	614d6f72 	hvcvs	55026	; 0xd6f2
 63c:	652f6574 	strvs	r6, [pc, #-1396]!	; d0 <CPSR_IRQ_INHIBIT+0x50>
 640:	706d6178 	rsbvc	r6, sp, r8, ror r1
 644:	2f73656c 	svccs	0x0073656c
 648:	462d3132 			; <UNDEFINED> instruction: 0x462d3132
 64c:	6b2f5550 	blvs	bd5b94 <_bss_end+0xbccd80>
 650:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 654:	72732f6c 	rsbsvc	r2, r3, #108, 30	; 0x1b0
 658:	74732f63 	ldrbtvc	r2, [r3], #-3939	; 0xfffff09d
 65c:	75747261 	ldrbvc	r7, [r4, #-609]!	; 0xfffffd9f
 660:	70632e70 	rsbvc	r2, r3, r0, ror lr
 664:	635f0070 	cmpvs	pc, #112	; 0x70
 668:	6174735f 	cmnvs	r4, pc, asr r3
 66c:	70757472 	rsbsvc	r7, r5, r2, ror r4
 670:	70635f00 	rsbvc	r5, r3, r0, lsl #30
 674:	74735f70 	ldrbtvc	r5, [r3], #-3952	; 0xfffff090
 678:	75747261 	ldrbvc	r7, [r4, #-609]!	; 0xfffffd9f
 67c:	74640070 	strbtvc	r0, [r4], #-112	; 0xffffff90
 680:	705f726f 	subsvc	r7, pc, pc, ror #4
 684:	2e007274 	mcrcs	2, 0, r7, cr0, cr4, {3}
 688:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 68c:	2f2e2e2f 	svccs	0x002e2e2f
 690:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 694:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 698:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
 69c:	2f636367 	svccs	0x00636367
 6a0:	666e6f63 	strbtvs	r6, [lr], -r3, ror #30
 6a4:	612f6769 			; <UNDEFINED> instruction: 0x612f6769
 6a8:	6c2f6d72 	stcvs	13, cr6, [pc], #-456	; 4e8 <CPSR_IRQ_INHIBIT+0x468>
 6ac:	66316269 	ldrtvs	r6, [r1], -r9, ror #4
 6b0:	73636e75 	cmnvc	r3, #1872	; 0x750
 6b4:	2f00532e 	svccs	0x0000532e
 6b8:	6c697562 	cfstr64vs	mvdx7, [r9], #-392	; 0xfffffe78
 6bc:	63672f64 	cmnvs	r7, #100, 30	; 0x190
 6c0:	72612d63 	rsbvc	r2, r1, #6336	; 0x18c0
 6c4:	6f6e2d6d 	svcvs	0x006e2d6d
 6c8:	652d656e 	strvs	r6, [sp, #-1390]!	; 0xfffffa92
 6cc:	2d696261 	sfmcs	f6, 2, [r9, #-388]!	; 0xfffffe7c
 6d0:	67665968 	strbvs	r5, [r6, -r8, ror #18]!
 6d4:	672f344b 	strvs	r3, [pc, -fp, asr #8]!
 6d8:	612d6363 			; <UNDEFINED> instruction: 0x612d6363
 6dc:	6e2d6d72 	mcrvs	13, 1, r6, cr13, cr2, {3}
 6e0:	2d656e6f 	stclcs	14, cr6, [r5, #-444]!	; 0xfffffe44
 6e4:	69626165 	stmdbvs	r2!, {r0, r2, r5, r6, r8, sp, lr}^
 6e8:	2e30312d 	rsfcssp	f3, f0, #5.0
 6ec:	30322d33 	eorscc	r2, r2, r3, lsr sp
 6f0:	302e3132 	eorcc	r3, lr, r2, lsr r1
 6f4:	75622f37 	strbvc	r2, [r2, #-3895]!	; 0xfffff0c9
 6f8:	2f646c69 	svccs	0x00646c69
 6fc:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
 700:	656e6f6e 	strbvs	r6, [lr, #-3950]!	; 0xfffff092
 704:	6261652d 	rsbvs	r6, r1, #188743680	; 0xb400000
 708:	72612f69 	rsbvc	r2, r1, #420	; 0x1a4
 70c:	35762f6d 	ldrbcc	r2, [r6, #-3949]!	; 0xfffff093
 710:	682f6574 	stmdavs	pc!, {r2, r4, r5, r6, r8, sl, sp, lr}	; <UNPREDICTABLE>
 714:	2f647261 	svccs	0x00647261
 718:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
 71c:	47006363 	strmi	r6, [r0, -r3, ror #6]
 720:	4120554e 			; <UNDEFINED> instruction: 0x4120554e
 724:	2e322053 	mrccs	0, 1, r2, cr2, cr3, {2}
 728:	69003733 	stmdbvs	r0, {r0, r1, r4, r5, r8, r9, sl, ip, sp}
 72c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 730:	705f7469 	subsvc	r7, pc, r9, ror #8
 734:	72646572 	rsbvc	r6, r4, #478150656	; 0x1c800000
 738:	69007365 	stmdbvs	r0, {r0, r2, r5, r6, r8, r9, ip, sp, lr}
 73c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 740:	765f7469 	ldrbvc	r7, [pc], -r9, ror #8
 744:	625f7066 	subsvs	r7, pc, #102	; 0x66
 748:	00657361 	rsbeq	r7, r5, r1, ror #6
 74c:	706d6f63 	rsbvc	r6, sp, r3, ror #30
 750:	2078656c 	rsbscs	r6, r8, ip, ror #10
 754:	616f6c66 	cmnvs	pc, r6, ror #24
 758:	73690074 	cmnvc	r9, #116	; 0x74
 75c:	6f6e5f61 	svcvs	0x006e5f61
 760:	00746962 	rsbseq	r6, r4, r2, ror #18
 764:	5f617369 	svcpl	0x00617369
 768:	5f746962 	svcpl	0x00746962
 76c:	5f65766d 	svcpl	0x0065766d
 770:	616f6c66 	cmnvs	pc, r6, ror #24
 774:	73690074 	cmnvc	r9, #116	; 0x74
 778:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 77c:	70665f74 	rsbvc	r5, r6, r4, ror pc
 780:	73003631 	movwvc	r3, #1585	; 0x631
 784:	74726f68 	ldrbtvc	r6, [r2], #-3944	; 0xfffff098
 788:	746e6920 	strbtvc	r6, [lr], #-2336	; 0xfffff6e0
 78c:	61736900 	cmnvs	r3, r0, lsl #18
 790:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 794:	6365735f 	cmnvs	r5, #2080374785	; 0x7c000001
 798:	61736900 	cmnvs	r3, r0, lsl #18
 79c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 7a0:	6964615f 	stmdbvs	r4!, {r0, r1, r2, r3, r4, r6, r8, sp, lr}^
 7a4:	73690076 	cmnvc	r9, #118	; 0x76
 7a8:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 7ac:	75715f74 	ldrbvc	r5, [r1, #-3956]!	; 0xfffff08c
 7b0:	5f6b7269 	svcpl	0x006b7269
 7b4:	765f6f6e 	ldrbvc	r6, [pc], -lr, ror #30
 7b8:	74616c6f 	strbtvc	r6, [r1], #-3183	; 0xfffff391
 7bc:	5f656c69 	svcpl	0x00656c69
 7c0:	69006563 	stmdbvs	r0, {r0, r1, r5, r6, r8, sl, sp, lr}
 7c4:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 7c8:	6d5f7469 	cfldrdvs	mvd7, [pc, #-420]	; 62c <CPSR_IRQ_INHIBIT+0x5ac>
 7cc:	73690070 	cmnvc	r9, #112	; 0x70
 7d0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 7d4:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
 7d8:	7435766d 	ldrtvc	r7, [r5], #-1645	; 0xfffff993
 7dc:	61736900 	cmnvs	r3, r0, lsl #18
 7e0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 7e4:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
 7e8:	65743576 	ldrbvs	r3, [r4, #-1398]!	; 0xfffffa8a
 7ec:	61736900 	cmnvs	r3, r0, lsl #18
 7f0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 7f4:	6f656e5f 	svcvs	0x00656e5f
 7f8:	7369006e 	cmnvc	r9, #110	; 0x6e
 7fc:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 800:	66625f74 	uqsub16vs	r5, r2, r4
 804:	46003631 			; <UNDEFINED> instruction: 0x46003631
 808:	52435350 	subpl	r5, r3, #80, 6	; 0x40000001
 80c:	554e455f 	strbpl	r4, [lr, #-1375]	; 0xfffffaa1
 810:	5046004d 	subpl	r0, r6, sp, asr #32
 814:	5f524353 	svcpl	0x00524353
 818:	76637a6e 	strbtvc	r7, [r3], -lr, ror #20
 81c:	455f6371 	ldrbmi	r6, [pc, #-881]	; 4b3 <CPSR_IRQ_INHIBIT+0x433>
 820:	004d554e 	subeq	r5, sp, lr, asr #10
 824:	5f525056 	svcpl	0x00525056
 828:	4d554e45 	ldclmi	14, cr4, [r5, #-276]	; 0xfffffeec
 82c:	69626600 	stmdbvs	r2!, {r9, sl, sp, lr}^
 830:	6d695f74 	stclvs	15, cr5, [r9, #-464]!	; 0xfffffe30
 834:	63696c70 	cmnvs	r9, #112, 24	; 0x7000
 838:	6f697461 	svcvs	0x00697461
 83c:	3050006e 	subscc	r0, r0, lr, rrx
 840:	554e455f 	strbpl	r4, [lr, #-1375]	; 0xfffffaa1
 844:	7369004d 	cmnvc	r9, #77	; 0x4d
 848:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 84c:	72635f74 	rsbvc	r5, r3, #116, 30	; 0x1d0
 850:	6f747079 	svcvs	0x00747079
 854:	554e4700 	strbpl	r4, [lr, #-1792]	; 0xfffff900
 858:	37314320 	ldrcc	r4, [r1, -r0, lsr #6]!
 85c:	2e303120 	rsfcssp	f3, f0, f0
 860:	20312e33 	eorscs	r2, r1, r3, lsr lr
 864:	31323032 	teqcc	r2, r2, lsr r0
 868:	31323630 	teqcc	r2, r0, lsr r6
 86c:	65722820 	ldrbvs	r2, [r2, #-2080]!	; 0xfffff7e0
 870:	7361656c 	cmnvc	r1, #108, 10	; 0x1b000000
 874:	2d202965 			; <UNDEFINED> instruction: 0x2d202965
 878:	6d72616d 	ldfvse	f6, [r2, #-436]!	; 0xfffffe4c
 87c:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
 880:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
 884:	6962612d 	stmdbvs	r2!, {r0, r2, r3, r5, r8, sp, lr}^
 888:	7261683d 	rsbvc	r6, r1, #3997696	; 0x3d0000
 88c:	6d2d2064 	stcvs	0, cr2, [sp, #-400]!	; 0xfffffe70
 890:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
 894:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
 898:	65743576 	ldrbvs	r3, [r4, #-1398]!	; 0xfffffa8a
 89c:	2070662b 	rsbscs	r6, r0, fp, lsr #12
 8a0:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
 8a4:	672d2067 	strvs	r2, [sp, -r7, rrx]!
 8a8:	324f2d20 	subcc	r2, pc, #32, 26	; 0x800
 8ac:	324f2d20 	subcc	r2, pc, #32, 26	; 0x800
 8b0:	324f2d20 	subcc	r2, pc, #32, 26	; 0x800
 8b4:	62662d20 	rsbvs	r2, r6, #32, 26	; 0x800
 8b8:	646c6975 	strbtvs	r6, [ip], #-2421	; 0xfffff68b
 8bc:	2d676e69 	stclcs	14, cr6, [r7, #-420]!	; 0xfffffe5c
 8c0:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
 8c4:	2d206363 	stccs	3, cr6, [r0, #-396]!	; 0xfffffe74
 8c8:	2d6f6e66 	stclcs	14, cr6, [pc, #-408]!	; 738 <CPSR_IRQ_INHIBIT+0x6b8>
 8cc:	63617473 	cmnvs	r1, #1929379840	; 0x73000000
 8d0:	72702d6b 	rsbsvc	r2, r0, #6848	; 0x1ac0
 8d4:	6365746f 	cmnvs	r5, #1862270976	; 0x6f000000
 8d8:	20726f74 	rsbscs	r6, r2, r4, ror pc
 8dc:	6f6e662d 	svcvs	0x006e662d
 8e0:	6c6e692d 			; <UNDEFINED> instruction: 0x6c6e692d
 8e4:	20656e69 	rsbcs	r6, r5, r9, ror #28
 8e8:	6976662d 	ldmdbvs	r6!, {r0, r2, r3, r5, r9, sl, sp, lr}^
 8ec:	69626973 	stmdbvs	r2!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
 8f0:	7974696c 	ldmdbvc	r4!, {r2, r3, r5, r6, r8, fp, sp, lr}^
 8f4:	6469683d 	strbtvs	r6, [r9], #-2109	; 0xfffff7c3
 8f8:	006e6564 	rsbeq	r6, lr, r4, ror #10
 8fc:	5f617369 	svcpl	0x00617369
 900:	5f746962 	svcpl	0x00746962
 904:	76696474 			; <UNDEFINED> instruction: 0x76696474
 908:	6e6f6300 	cdpvs	3, 6, cr6, cr15, cr0, {0}
 90c:	73690073 	cmnvc	r9, #115	; 0x73
 910:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 914:	77695f74 			; <UNDEFINED> instruction: 0x77695f74
 918:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
 91c:	43504600 	cmpmi	r0, #0, 12
 920:	5f535458 	svcpl	0x00535458
 924:	4d554e45 	ldclmi	14, cr4, [r5, #-276]	; 0xfffffeec
 928:	61736900 	cmnvs	r3, r0, lsl #18
 92c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 930:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
 934:	69003676 	stmdbvs	r0, {r1, r2, r4, r5, r6, r9, sl, ip, sp}
 938:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 93c:	6d5f7469 	cfldrdvs	mvd7, [pc, #-420]	; 7a0 <CPSR_IRQ_INHIBIT+0x720>
 940:	69006576 	stmdbvs	r0, {r1, r2, r4, r5, r6, r8, sl, sp, lr}
 944:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 948:	695f7469 	ldmdbvs	pc, {r0, r3, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
 94c:	786d6d77 	stmdavc	sp!, {r0, r1, r2, r4, r5, r6, r8, sl, fp, sp, lr}^
 950:	69003274 	stmdbvs	r0, {r2, r4, r5, r6, r9, ip, sp}
 954:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 958:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
 95c:	70636564 	rsbvc	r6, r3, r4, ror #10
 960:	73690030 	cmnvc	r9, #48	; 0x30
 964:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 968:	64635f74 	strbtvs	r5, [r3], #-3956	; 0xfffff08c
 96c:	31706365 	cmncc	r0, r5, ror #6
 970:	61736900 	cmnvs	r3, r0, lsl #18
 974:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 978:	6564635f 	strbvs	r6, [r4, #-863]!	; 0xfffffca1
 97c:	00327063 	eorseq	r7, r2, r3, rrx
 980:	5f617369 	svcpl	0x00617369
 984:	5f746962 	svcpl	0x00746962
 988:	63656463 	cmnvs	r5, #1660944384	; 0x63000000
 98c:	69003370 	stmdbvs	r0, {r4, r5, r6, r8, r9, ip, sp}
 990:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 994:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
 998:	70636564 	rsbvc	r6, r3, r4, ror #10
 99c:	73690034 	cmnvc	r9, #52	; 0x34
 9a0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 9a4:	70665f74 	rsbvc	r5, r6, r4, ror pc
 9a8:	6c62645f 	cfstrdvs	mvd6, [r2], #-380	; 0xfffffe84
 9ac:	61736900 	cmnvs	r3, r0, lsl #18
 9b0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 9b4:	6564635f 	strbvs	r6, [r4, #-863]!	; 0xfffffca1
 9b8:	00367063 	eorseq	r7, r6, r3, rrx
 9bc:	5f617369 	svcpl	0x00617369
 9c0:	5f746962 	svcpl	0x00746962
 9c4:	63656463 	cmnvs	r5, #1660944384	; 0x63000000
 9c8:	69003770 	stmdbvs	r0, {r4, r5, r6, r8, r9, sl, ip, sp}
 9cc:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 9d0:	615f7469 	cmpvs	pc, r9, ror #8
 9d4:	36766d72 			; <UNDEFINED> instruction: 0x36766d72
 9d8:	7369006b 	cmnvc	r9, #107	; 0x6b
 9dc:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 9e0:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
 9e4:	5f38766d 	svcpl	0x0038766d
 9e8:	6d5f6d31 	ldclvs	13, cr6, [pc, #-196]	; 92c <CPSR_IRQ_INHIBIT+0x8ac>
 9ec:	006e6961 	rsbeq	r6, lr, r1, ror #18
 9f0:	65746e61 	ldrbvs	r6, [r4, #-3681]!	; 0xfffff19f
 9f4:	61736900 	cmnvs	r3, r0, lsl #18
 9f8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 9fc:	736d635f 	cmnvc	sp, #2080374785	; 0x7c000001
 a00:	6f6c0065 	svcvs	0x006c0065
 a04:	6420676e 	strtvs	r6, [r0], #-1902	; 0xfffff892
 a08:	6c62756f 	cfstr64vs	mvdx7, [r2], #-444	; 0xfffffe44
 a0c:	2e2e0065 	cdpcs	0, 2, cr0, cr14, cr5, {3}
 a10:	2f2e2e2f 	svccs	0x002e2e2f
 a14:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 a18:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 a1c:	2f2e2e2f 	svccs	0x002e2e2f
 a20:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
 a24:	6c2f6363 	stcvs	3, cr6, [pc], #-396	; 8a0 <CPSR_IRQ_INHIBIT+0x820>
 a28:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
 a2c:	632e3263 			; <UNDEFINED> instruction: 0x632e3263
 a30:	61736900 	cmnvs	r3, r0, lsl #18
 a34:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 a38:	7670665f 			; <UNDEFINED> instruction: 0x7670665f
 a3c:	73690035 	cmnvc	r9, #53	; 0x35
 a40:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 a44:	73785f74 	cmnvc	r8, #116, 30	; 0x1d0
 a48:	656c6163 	strbvs	r6, [ip, #-355]!	; 0xfffffe9d
 a4c:	6e6f6c00 	cdpvs	12, 6, cr6, cr15, cr0, {0}
 a50:	6f6c2067 	svcvs	0x006c2067
 a54:	7520676e 	strvc	r6, [r0, #-1902]!	; 0xfffff892
 a58:	6769736e 	strbvs	r7, [r9, -lr, ror #6]!
 a5c:	2064656e 	rsbcs	r6, r4, lr, ror #10
 a60:	00746e69 	rsbseq	r6, r4, r9, ror #28
 a64:	5f617369 	svcpl	0x00617369
 a68:	5f746962 	svcpl	0x00746962
 a6c:	72697571 	rsbvc	r7, r9, #473956352	; 0x1c400000
 a70:	6d635f6b 	stclvs	15, cr5, [r3, #-428]!	; 0xfffffe54
 a74:	646c5f33 	strbtvs	r5, [ip], #-3891	; 0xfffff0cd
 a78:	69006472 	stmdbvs	r0, {r1, r4, r5, r6, sl, sp, lr}
 a7c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 a80:	695f7469 	ldmdbvs	pc, {r0, r3, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
 a84:	006d6d38 	rsbeq	r6, sp, r8, lsr sp
 a88:	726f6873 	rsbvc	r6, pc, #7536640	; 0x730000
 a8c:	6e752074 	mrcvs	0, 3, r2, cr5, cr4, {3}
 a90:	6e676973 			; <UNDEFINED> instruction: 0x6e676973
 a94:	69206465 	stmdbvs	r0!, {r0, r2, r5, r6, sl, sp, lr}
 a98:	6900746e 	stmdbvs	r0, {r1, r2, r3, r5, r6, sl, ip, sp, lr}
 a9c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 aa0:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
 aa4:	33645f70 	cmncc	r4, #112, 30	; 0x1c0
 aa8:	73690032 	cmnvc	r9, #50	; 0x32
 aac:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 ab0:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
 ab4:	6537766d 	ldrvs	r7, [r7, #-1645]!	; 0xfffff993
 ab8:	7369006d 	cmnvc	r9, #109	; 0x6d
 abc:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 ac0:	706c5f74 	rsbvc	r5, ip, r4, ror pc
 ac4:	61006561 	tstvs	r0, r1, ror #10
 ac8:	695f6c6c 	ldmdbvs	pc, {r2, r3, r5, r6, sl, fp, sp, lr}^	; <UNPREDICTABLE>
 acc:	696c706d 	stmdbvs	ip!, {r0, r2, r3, r5, r6, ip, sp, lr}^
 ad0:	665f6465 	ldrbvs	r6, [pc], -r5, ror #8
 ad4:	73746962 	cmnvc	r4, #1605632	; 0x188000
 ad8:	61736900 	cmnvs	r3, r0, lsl #18
 adc:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 ae0:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
 ae4:	315f3876 	cmpcc	pc, r6, ror r8	; <UNPREDICTABLE>
 ae8:	61736900 	cmnvs	r3, r0, lsl #18
 aec:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 af0:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
 af4:	325f3876 	subscc	r3, pc, #7733248	; 0x760000
 af8:	61736900 	cmnvs	r3, r0, lsl #18
 afc:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 b00:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
 b04:	335f3876 	cmpcc	pc, #7733248	; 0x760000
 b08:	61736900 	cmnvs	r3, r0, lsl #18
 b0c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 b10:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
 b14:	345f3876 	ldrbcc	r3, [pc], #-2166	; b1c <CPSR_IRQ_INHIBIT+0xa9c>
 b18:	61736900 	cmnvs	r3, r0, lsl #18
 b1c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 b20:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
 b24:	355f3876 	ldrbcc	r3, [pc, #-2166]	; 2b6 <CPSR_IRQ_INHIBIT+0x236>
 b28:	61736900 	cmnvs	r3, r0, lsl #18
 b2c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 b30:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
 b34:	365f3876 			; <UNDEFINED> instruction: 0x365f3876
 b38:	61736900 	cmnvs	r3, r0, lsl #18
 b3c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 b40:	0062735f 	rsbeq	r7, r2, pc, asr r3
 b44:	5f617369 	svcpl	0x00617369
 b48:	5f6d756e 	svcpl	0x006d756e
 b4c:	73746962 	cmnvc	r4, #1605632	; 0x188000
 b50:	61736900 	cmnvs	r3, r0, lsl #18
 b54:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 b58:	616d735f 	cmnvs	sp, pc, asr r3
 b5c:	756d6c6c 	strbvc	r6, [sp, #-3180]!	; 0xfffff394
 b60:	7566006c 	strbvc	r0, [r6, #-108]!	; 0xffffff94
 b64:	705f636e 	subsvc	r6, pc, lr, ror #6
 b68:	63007274 	movwvs	r7, #628	; 0x274
 b6c:	6c706d6f 	ldclvs	13, cr6, [r0], #-444	; 0xfffffe44
 b70:	64207865 	strtvs	r7, [r0], #-2149	; 0xfffff79b
 b74:	6c62756f 	cfstr64vs	mvdx7, [r2], #-444	; 0xfffffe44
 b78:	424e0065 	submi	r0, lr, #101	; 0x65
 b7c:	5f50465f 	svcpl	0x0050465f
 b80:	52535953 	subspl	r5, r3, #1359872	; 0x14c000
 b84:	00534745 	subseq	r4, r3, r5, asr #14
 b88:	5f617369 	svcpl	0x00617369
 b8c:	5f746962 	svcpl	0x00746962
 b90:	63656463 	cmnvs	r5, #1660944384	; 0x63000000
 b94:	69003570 	stmdbvs	r0, {r4, r5, r6, r8, sl, ip, sp}
 b98:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 b9c:	765f7469 	ldrbvc	r7, [pc], -r9, ror #8
 ba0:	32767066 	rsbscc	r7, r6, #102	; 0x66
 ba4:	61736900 	cmnvs	r3, r0, lsl #18
 ba8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 bac:	7066765f 	rsbvc	r7, r6, pc, asr r6
 bb0:	69003376 	stmdbvs	r0, {r1, r2, r4, r5, r6, r8, r9, ip, sp}
 bb4:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 bb8:	765f7469 	ldrbvc	r7, [pc], -r9, ror #8
 bbc:	34767066 	ldrbtcc	r7, [r6], #-102	; 0xffffff9a
 bc0:	43504600 	cmpmi	r0, #0, 12
 bc4:	534e5458 	movtpl	r5, #58456	; 0xe458
 bc8:	554e455f 	strbpl	r4, [lr, #-1375]	; 0xfffffaa1
 bcc:	7369004d 	cmnvc	r9, #77	; 0x4d
 bd0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 bd4:	68745f74 	ldmdavs	r4!, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
 bd8:	00626d75 	rsbeq	r6, r2, r5, ror sp
 bdc:	5f617369 	svcpl	0x00617369
 be0:	5f746962 	svcpl	0x00746962
 be4:	36317066 	ldrtcc	r7, [r1], -r6, rrx
 be8:	766e6f63 	strbtvc	r6, [lr], -r3, ror #30
 bec:	61736900 	cmnvs	r3, r0, lsl #18
 bf0:	6165665f 	cmnvs	r5, pc, asr r6
 bf4:	65727574 	ldrbvs	r7, [r2, #-1396]!	; 0xfffffa8c
 bf8:	61736900 	cmnvs	r3, r0, lsl #18
 bfc:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 c00:	746f6e5f 	strbtvc	r6, [pc], #-3679	; c08 <CPSR_IRQ_INHIBIT+0xb88>
 c04:	7369006d 	cmnvc	r9, #109	; 0x6d
 c08:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 c0c:	75715f74 	ldrbvc	r5, [r1, #-3956]!	; 0xfffff08c
 c10:	5f6b7269 	svcpl	0x006b7269
 c14:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
 c18:	007a6b36 	rsbseq	r6, sl, r6, lsr fp
 c1c:	5f617369 	svcpl	0x00617369
 c20:	5f746962 	svcpl	0x00746962
 c24:	33637263 	cmncc	r3, #805306374	; 0x30000006
 c28:	73690032 	cmnvc	r9, #50	; 0x32
 c2c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 c30:	75715f74 	ldrbvc	r5, [r1, #-3956]!	; 0xfffff08c
 c34:	5f6b7269 	svcpl	0x006b7269
 c38:	615f6f6e 	cmpvs	pc, lr, ror #30
 c3c:	70636d73 	rsbvc	r6, r3, r3, ror sp
 c40:	73690075 	cmnvc	r9, #117	; 0x75
 c44:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 c48:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
 c4c:	0034766d 	eorseq	r7, r4, sp, ror #12
 c50:	5f617369 	svcpl	0x00617369
 c54:	5f746962 	svcpl	0x00746962
 c58:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
 c5c:	69003262 	stmdbvs	r0, {r1, r5, r6, r9, ip, sp}
 c60:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 c64:	625f7469 	subsvs	r7, pc, #1761607680	; 0x69000000
 c68:	69003865 	stmdbvs	r0, {r0, r2, r5, r6, fp, ip, sp}
 c6c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 c70:	615f7469 	cmpvs	pc, r9, ror #8
 c74:	37766d72 			; <UNDEFINED> instruction: 0x37766d72
 c78:	61736900 	cmnvs	r3, r0, lsl #18
 c7c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 c80:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
 c84:	76003876 			; <UNDEFINED> instruction: 0x76003876
 c88:	735f7066 	cmpvc	pc, #102	; 0x66
 c8c:	65727379 	ldrbvs	r7, [r2, #-889]!	; 0xfffffc87
 c90:	655f7367 	ldrbvs	r7, [pc, #-871]	; 931 <CPSR_IRQ_INHIBIT+0x8b1>
 c94:	646f636e 	strbtvs	r6, [pc], #-878	; c9c <CPSR_IRQ_INHIBIT+0xc1c>
 c98:	00676e69 	rsbeq	r6, r7, r9, ror #28
 c9c:	5f617369 	svcpl	0x00617369
 ca0:	5f746962 	svcpl	0x00746962
 ca4:	36317066 	ldrtcc	r7, [r1], -r6, rrx
 ca8:	006c6d66 	rsbeq	r6, ip, r6, ror #26
 cac:	5f617369 	svcpl	0x00617369
 cb0:	5f746962 	svcpl	0x00746962
 cb4:	70746f64 	rsbsvc	r6, r4, r4, ror #30
 cb8:	00646f72 	rsbeq	r6, r4, r2, ror pc

Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347 	bcc	10d0d24 <_bss_end+0x10c7f10>
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
  10:	4b5a3605 	blmi	168d82c <_bss_end+0x1684a18>
  14:	08070600 	stmdaeq	r7, {r9, sl}
  18:	0a010901 	beq	42424 <_bss_end+0x39610>
  1c:	14041202 	strne	r1, [r4], #-514	; 0xfffffdfe
  20:	17011501 	strne	r1, [r1, -r1, lsl #10]
  24:	1a011803 	bne	46038 <_bss_end+0x3d224>
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
  18:	00008040 	andeq	r8, r0, r0, asr #32
  1c:	00000038 	andeq	r0, r0, r8, lsr r0
  20:	8b040e42 	blhi	103930 <_bss_end+0xfab1c>
  24:	0b0d4201 	bleq	350830 <_bss_end+0x347a1c>
  28:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
  2c:	00000ecb 	andeq	r0, r0, fp, asr #29
  30:	0000001c 	andeq	r0, r0, ip, lsl r0
  34:	00000000 	andeq	r0, r0, r0
  38:	00008078 	andeq	r8, r0, r8, ror r0
  3c:	0000002c 	andeq	r0, r0, ip, lsr #32
  40:	8b040e42 	blhi	103950 <_bss_end+0xfab3c>
  44:	0b0d4201 	bleq	350850 <_bss_end+0x347a3c>
  48:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
  4c:	00000ecb 	andeq	r0, r0, fp, asr #29
  50:	0000001c 	andeq	r0, r0, ip, lsl r0
  54:	00000000 	andeq	r0, r0, r0
  58:	000080a4 	andeq	r8, r0, r4, lsr #1
  5c:	00000020 	andeq	r0, r0, r0, lsr #32
  60:	8b040e42 	blhi	103970 <_bss_end+0xfab5c>
  64:	0b0d4201 	bleq	350870 <_bss_end+0x347a5c>
  68:	420d0d48 	andmi	r0, sp, #72, 26	; 0x1200
  6c:	00000ecb 	andeq	r0, r0, fp, asr #29
  70:	0000001c 	andeq	r0, r0, ip, lsl r0
  74:	00000000 	andeq	r0, r0, r0
  78:	000080c4 	andeq	r8, r0, r4, asr #1
  7c:	00000018 	andeq	r0, r0, r8, lsl r0
  80:	8b040e42 	blhi	103990 <_bss_end+0xfab7c>
  84:	0b0d4201 	bleq	350890 <_bss_end+0x347a7c>
  88:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  8c:	00000ecb 	andeq	r0, r0, fp, asr #29
  90:	0000001c 	andeq	r0, r0, ip, lsl r0
  94:	00000000 	andeq	r0, r0, r0
  98:	000080dc 	ldrdeq	r8, [r0], -ip
  9c:	00000018 	andeq	r0, r0, r8, lsl r0
  a0:	8b040e42 	blhi	1039b0 <_bss_end+0xfab9c>
  a4:	0b0d4201 	bleq	3508b0 <_bss_end+0x347a9c>
  a8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  ac:	00000ecb 	andeq	r0, r0, fp, asr #29
  b0:	0000001c 	andeq	r0, r0, ip, lsl r0
  b4:	00000000 	andeq	r0, r0, r0
  b8:	000080f4 	strdeq	r8, [r0], -r4
  bc:	00000018 	andeq	r0, r0, r8, lsl r0
  c0:	8b040e42 	blhi	1039d0 <_bss_end+0xfabbc>
  c4:	0b0d4201 	bleq	3508d0 <_bss_end+0x347abc>
  c8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  cc:	00000ecb 	andeq	r0, r0, fp, asr #29
  d0:	00000014 	andeq	r0, r0, r4, lsl r0
  d4:	00000000 	andeq	r0, r0, r0
  d8:	0000810c 	andeq	r8, r0, ip, lsl #2
  dc:	0000000c 	andeq	r0, r0, ip
  e0:	8b040e42 	blhi	1039f0 <_bss_end+0xfabdc>
  e4:	0b0d4201 	bleq	3508f0 <_bss_end+0x347adc>
  e8:	0000000c 	andeq	r0, r0, ip
  ec:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  f0:	7c020001 	stcvc	0, cr0, [r2], {1}
  f4:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  f8:	0000001c 	andeq	r0, r0, ip, lsl r0
  fc:	000000e8 	andeq	r0, r0, r8, ror #1
 100:	00008118 	andeq	r8, r0, r8, lsl r1
 104:	00000078 	andeq	r0, r0, r8, ror r0
 108:	8b040e42 	blhi	103a18 <_bss_end+0xfac04>
 10c:	0b0d4201 	bleq	350918 <_bss_end+0x347b04>
 110:	420d0d74 	andmi	r0, sp, #116, 26	; 0x1d00
 114:	00000ecb 	andeq	r0, r0, fp, asr #29
 118:	0000001c 	andeq	r0, r0, ip, lsl r0
 11c:	000000e8 	andeq	r0, r0, r8, ror #1
 120:	00008760 	andeq	r8, r0, r0, ror #14
 124:	00000038 	andeq	r0, r0, r8, lsr r0
 128:	8b040e42 	blhi	103a38 <_bss_end+0xfac24>
 12c:	0b0d4201 	bleq	350938 <_bss_end+0x347b24>
 130:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
 134:	00000ecb 	andeq	r0, r0, fp, asr #29
 138:	0000001c 	andeq	r0, r0, ip, lsl r0
 13c:	000000e8 	andeq	r0, r0, r8, ror #1
 140:	00008190 	muleq	r0, r0, r1
 144:	000000a8 	andeq	r0, r0, r8, lsr #1
 148:	8b080e42 	blhi	203a58 <_bss_end+0x1fac44>
 14c:	42018e02 	andmi	r8, r1, #2, 28
 150:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 154:	080d0c4e 	stmdaeq	sp, {r1, r2, r3, r6, sl, fp}
 158:	0000001c 	andeq	r0, r0, ip, lsl r0
 15c:	000000e8 	andeq	r0, r0, r8, ror #1
 160:	00008798 	muleq	r0, r8, r7
 164:	00000088 	andeq	r0, r0, r8, lsl #1
 168:	8b080e42 	blhi	203a78 <_bss_end+0x1fac64>
 16c:	42018e02 	andmi	r8, r1, #2, 28
 170:	7e040b0c 	vmlavc.f64	d0, d4, d12
 174:	00080d0c 	andeq	r0, r8, ip, lsl #26
 178:	0000001c 	andeq	r0, r0, ip, lsl r0
 17c:	000000e8 	andeq	r0, r0, r8, ror #1
 180:	00008238 	andeq	r8, r0, r8, lsr r2
 184:	00000130 	andeq	r0, r0, r0, lsr r1
 188:	8b040e42 	blhi	103a98 <_bss_end+0xfac84>
 18c:	0b0d4201 	bleq	350998 <_bss_end+0x347b84>
 190:	0d0d9002 	stceq	0, cr9, [sp, #-8]
 194:	000ecb42 	andeq	ip, lr, r2, asr #22
 198:	0000001c 	andeq	r0, r0, ip, lsl r0
 19c:	000000e8 	andeq	r0, r0, r8, ror #1
 1a0:	00008820 	andeq	r8, r0, r0, lsr #16
 1a4:	0000002c 	andeq	r0, r0, ip, lsr #32
 1a8:	8b040e42 	blhi	103ab8 <_bss_end+0xfaca4>
 1ac:	0b0d4201 	bleq	3509b8 <_bss_end+0x347ba4>
 1b0:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 1b4:	00000ecb 	andeq	r0, r0, fp, asr #29
 1b8:	0000001c 	andeq	r0, r0, ip, lsl r0
 1bc:	000000e8 	andeq	r0, r0, r8, ror #1
 1c0:	00008368 	andeq	r8, r0, r8, ror #6
 1c4:	000000a8 	andeq	r0, r0, r8, lsr #1
 1c8:	8b080e42 	blhi	203ad8 <_bss_end+0x1facc4>
 1cc:	42018e02 	andmi	r8, r1, #2, 28
 1d0:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 1d4:	080d0c4e 	stmdaeq	sp, {r1, r2, r3, r6, sl, fp}
 1d8:	0000001c 	andeq	r0, r0, ip, lsl r0
 1dc:	000000e8 	andeq	r0, r0, r8, ror #1
 1e0:	00008410 	andeq	r8, r0, r0, lsl r4
 1e4:	00000078 	andeq	r0, r0, r8, ror r0
 1e8:	8b080e42 	blhi	203af8 <_bss_end+0x1face4>
 1ec:	42018e02 	andmi	r8, r1, #2, 28
 1f0:	76040b0c 	strvc	r0, [r4], -ip, lsl #22
 1f4:	00080d0c 	andeq	r0, r8, ip, lsl #26
 1f8:	0000001c 	andeq	r0, r0, ip, lsl r0
 1fc:	000000e8 	andeq	r0, r0, r8, ror #1
 200:	00008488 	andeq	r8, r0, r8, lsl #9
 204:	00000034 	andeq	r0, r0, r4, lsr r0
 208:	8b040e42 	blhi	103b18 <_bss_end+0xfad04>
 20c:	0b0d4201 	bleq	350a18 <_bss_end+0x347c04>
 210:	420d0d52 	andmi	r0, sp, #5248	; 0x1480
 214:	00000ecb 	andeq	r0, r0, fp, asr #29
 218:	0000001c 	andeq	r0, r0, ip, lsl r0
 21c:	000000e8 	andeq	r0, r0, r8, ror #1
 220:	000084bc 			; <UNDEFINED> instruction: 0x000084bc
 224:	00000054 	andeq	r0, r0, r4, asr r0
 228:	8b080e42 	blhi	203b38 <_bss_end+0x1fad24>
 22c:	42018e02 	andmi	r8, r1, #2, 28
 230:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 234:	00080d0c 	andeq	r0, r8, ip, lsl #26
 238:	0000001c 	andeq	r0, r0, ip, lsl r0
 23c:	000000e8 	andeq	r0, r0, r8, ror #1
 240:	00008510 	andeq	r8, r0, r0, lsl r5
 244:	00000060 	andeq	r0, r0, r0, rrx
 248:	8b080e42 	blhi	203b58 <_bss_end+0x1fad44>
 24c:	42018e02 	andmi	r8, r1, #2, 28
 250:	66040b0c 	strvs	r0, [r4], -ip, lsl #22
 254:	00080d0c 	andeq	r0, r8, ip, lsl #26
 258:	0000001c 	andeq	r0, r0, ip, lsl r0
 25c:	000000e8 	andeq	r0, r0, r8, ror #1
 260:	00008570 	andeq	r8, r0, r0, ror r5
 264:	0000017c 	andeq	r0, r0, ip, ror r1
 268:	8b080e42 	blhi	203b78 <_bss_end+0x1fad64>
 26c:	42018e02 	andmi	r8, r1, #2, 28
 270:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 274:	080d0cb6 	stmdaeq	sp, {r1, r2, r4, r5, r7, sl, fp}
 278:	0000001c 	andeq	r0, r0, ip, lsl r0
 27c:	000000e8 	andeq	r0, r0, r8, ror #1
 280:	000086ec 	andeq	r8, r0, ip, ror #13
 284:	00000058 	andeq	r0, r0, r8, asr r0
 288:	8b080e42 	blhi	203b98 <_bss_end+0x1fad84>
 28c:	42018e02 	andmi	r8, r1, #2, 28
 290:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 294:	00080d0c 	andeq	r0, r8, ip, lsl #26
 298:	00000018 	andeq	r0, r0, r8, lsl r0
 29c:	000000e8 	andeq	r0, r0, r8, ror #1
 2a0:	00008744 	andeq	r8, r0, r4, asr #14
 2a4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2a8:	8b080e42 	blhi	203bb8 <_bss_end+0x1fada4>
 2ac:	42018e02 	andmi	r8, r1, #2, 28
 2b0:	00040b0c 	andeq	r0, r4, ip, lsl #22
 2b4:	0000000c 	andeq	r0, r0, ip
 2b8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 2bc:	7c020001 	stcvc	0, cr0, [r2], {1}
 2c0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 2c4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2c8:	000002b4 			; <UNDEFINED> instruction: 0x000002b4
 2cc:	0000884c 	andeq	r8, r0, ip, asr #16
 2d0:	000000d0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
 2d4:	8b040e42 	blhi	103be4 <_bss_end+0xfadd0>
 2d8:	0b0d4201 	bleq	350ae4 <_bss_end+0x347cd0>
 2dc:	0d0d6002 	stceq	0, cr6, [sp, #-8]
 2e0:	000ecb42 	andeq	ip, lr, r2, asr #22
 2e4:	00000018 	andeq	r0, r0, r8, lsl r0
 2e8:	000002b4 			; <UNDEFINED> instruction: 0x000002b4
 2ec:	0000891c 	andeq	r8, r0, ip, lsl r9
 2f0:	00000118 	andeq	r0, r0, r8, lsl r1
 2f4:	8b080e42 	blhi	203c04 <_bss_end+0x1fadf0>
 2f8:	42018e02 	andmi	r8, r1, #2, 28
 2fc:	00040b0c 	andeq	r0, r4, ip, lsl #22
 300:	0000000c 	andeq	r0, r0, ip
 304:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 308:	7c020001 	stcvc	0, cr0, [r2], {1}
 30c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 310:	0000001c 	andeq	r0, r0, ip, lsl r0
 314:	00000300 	andeq	r0, r0, r0, lsl #6
 318:	00008a34 	andeq	r8, r0, r4, lsr sl
 31c:	00000068 	andeq	r0, r0, r8, rrx
 320:	8b040e42 	blhi	103c30 <_bss_end+0xfae1c>
 324:	0b0d4201 	bleq	350b30 <_bss_end+0x347d1c>
 328:	420d0d68 	andmi	r0, sp, #104, 26	; 0x1a00
 32c:	00000ecb 	andeq	r0, r0, fp, asr #29
 330:	0000001c 	andeq	r0, r0, ip, lsl r0
 334:	00000300 	andeq	r0, r0, r0, lsl #6
 338:	00008a9c 	muleq	r0, ip, sl
 33c:	00000058 	andeq	r0, r0, r8, asr r0
 340:	8b080e42 	blhi	203c50 <_bss_end+0x1fae3c>
 344:	42018e02 	andmi	r8, r1, #2, 28
 348:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 34c:	00080d0c 	andeq	r0, r8, ip, lsl #26
 350:	0000001c 	andeq	r0, r0, ip, lsl r0
 354:	00000300 	andeq	r0, r0, r0, lsl #6
 358:	00008af4 	strdeq	r8, [r0], -r4
 35c:	00000058 	andeq	r0, r0, r8, asr r0
 360:	8b080e42 	blhi	203c70 <_bss_end+0x1fae5c>
 364:	42018e02 	andmi	r8, r1, #2, 28
 368:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 36c:	00080d0c 	andeq	r0, r8, ip, lsl #26
 370:	0000000c 	andeq	r0, r0, ip
 374:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 378:	7c010001 	stcvc	0, cr0, [r1], {1}
 37c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 380:	0000000c 	andeq	r0, r0, ip
 384:	00000370 	andeq	r0, r0, r0, ror r3
 388:	00008b4c 	andeq	r8, r0, ip, asr #22
 38c:	000001ec 	andeq	r0, r0, ip, ror #3

Disassembly of section .debug_ranges:

00000000 <.debug_ranges>:
   0:	00008118 	andeq	r8, r0, r8, lsl r1
   4:	00008760 	andeq	r8, r0, r0, ror #14
   8:	00008760 	andeq	r8, r0, r0, ror #14
   c:	00008798 	muleq	r0, r8, r7
  10:	00008798 	muleq	r0, r8, r7
  14:	00008820 	andeq	r8, r0, r0, lsr #16
  18:	00008820 	andeq	r8, r0, r0, lsr #16
  1c:	0000884c 	andeq	r8, r0, ip, asr #16
	...
