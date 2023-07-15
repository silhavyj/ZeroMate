
./kernel:     file format elf32-littlearm


Disassembly of section .text:

00008000 <_start>:
_start():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/17-FPU/kernel/src/start.s:8
;@ tady budou symboly, ktere chceme na zacatek kodove sekce
.section .text.start

;@ vstupni bod do kernelu - nechame ho vlozit na zacatek kodu
_start:
    mov sp,#0x8000			;@ nastavime stack pointer na spodek zasobniku
    8000:	e3a0d902 	mov	sp, #32768	; 0x8000
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/17-FPU/kernel/src/start.s:9
	bl _c_startup			;@ C startup kod (inicializace prostredi)
    8004:	eb000057 	bl	8168 <_c_startup>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/17-FPU/kernel/src/start.s:10
	bl _cpp_startup			;@ C++ startup kod (volani globalnich konstruktoru, ...)
    8008:	eb000070 	bl	81d0 <_cpp_startup>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/17-FPU/kernel/src/start.s:11
    bl _kernel_main			;@ skocime do hlavniho kodu jadra (v C)
    800c:	eb00004a 	bl	813c <_kernel_main>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/17-FPU/kernel/src/start.s:12
	bl _cpp_shutdown		;@ C++ shutdown kod (volani globalnich destruktoru, ...)
    8010:	eb000084 	bl	8228 <_cpp_shutdown>

00008014 <hang>:
hang():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/17-FPU/kernel/src/start.s:14
hang:
    b hang
    8014:	eafffffe 	b	8014 <hang>

00008018 <__cxa_guard_acquire>:
__cxa_guard_acquire():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/17-FPU/kernel/src/cxx.cpp:11
    extern "C" int __cxa_guard_acquire(__guard*);
    extern "C" void __cxa_guard_release(__guard*);
    extern "C" void __cxa_guard_abort(__guard*);

    extern "C" int __cxa_guard_acquire(__guard* g)
    {
    8018:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    801c:	e28db000 	add	fp, sp, #0
    8020:	e24dd00c 	sub	sp, sp, #12
    8024:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/17-FPU/kernel/src/cxx.cpp:12
        return !*(char*)(g);
    8028:	e51b3008 	ldr	r3, [fp, #-8]
    802c:	e5d33000 	ldrb	r3, [r3]
    8030:	e3530000 	cmp	r3, #0
    8034:	03a03001 	moveq	r3, #1
    8038:	13a03000 	movne	r3, #0
    803c:	e6ef3073 	uxtb	r3, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/17-FPU/kernel/src/cxx.cpp:13
    }
    8040:	e1a00003 	mov	r0, r3
    8044:	e28bd000 	add	sp, fp, #0
    8048:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    804c:	e12fff1e 	bx	lr

00008050 <__cxa_guard_release>:
__cxa_guard_release():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/17-FPU/kernel/src/cxx.cpp:16

    extern "C" void __cxa_guard_release(__guard* g)
    {
    8050:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8054:	e28db000 	add	fp, sp, #0
    8058:	e24dd00c 	sub	sp, sp, #12
    805c:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/17-FPU/kernel/src/cxx.cpp:17
        *(char*)g = 1;
    8060:	e51b3008 	ldr	r3, [fp, #-8]
    8064:	e3a02001 	mov	r2, #1
    8068:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/17-FPU/kernel/src/cxx.cpp:18
    }
    806c:	e320f000 	nop	{0}
    8070:	e28bd000 	add	sp, fp, #0
    8074:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8078:	e12fff1e 	bx	lr

0000807c <__cxa_guard_abort>:
__cxa_guard_abort():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/17-FPU/kernel/src/cxx.cpp:21

    extern "C" void __cxa_guard_abort(__guard*)
    {
    807c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8080:	e28db000 	add	fp, sp, #0
    8084:	e24dd00c 	sub	sp, sp, #12
    8088:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/17-FPU/kernel/src/cxx.cpp:22
    }
    808c:	e320f000 	nop	{0}
    8090:	e28bd000 	add	sp, fp, #0
    8094:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8098:	e12fff1e 	bx	lr

0000809c <__dso_handle>:
__dso_handle():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/17-FPU/kernel/src/cxx.cpp:26
}

extern "C" void __dso_handle()
{
    809c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    80a0:	e28db000 	add	fp, sp, #0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/17-FPU/kernel/src/cxx.cpp:28
    // ignore dtors for now
}
    80a4:	e320f000 	nop	{0}
    80a8:	e28bd000 	add	sp, fp, #0
    80ac:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    80b0:	e12fff1e 	bx	lr

000080b4 <__cxa_atexit>:
__cxa_atexit():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/17-FPU/kernel/src/cxx.cpp:31

extern "C" void __cxa_atexit()
{
    80b4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    80b8:	e28db000 	add	fp, sp, #0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/17-FPU/kernel/src/cxx.cpp:33
    // ignore dtors for now
}
    80bc:	e320f000 	nop	{0}
    80c0:	e28bd000 	add	sp, fp, #0
    80c4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    80c8:	e12fff1e 	bx	lr

000080cc <__cxa_pure_virtual>:
__cxa_pure_virtual():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/17-FPU/kernel/src/cxx.cpp:36

extern "C" void __cxa_pure_virtual()
{
    80cc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    80d0:	e28db000 	add	fp, sp, #0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/17-FPU/kernel/src/cxx.cpp:38
    // pure virtual method called
}
    80d4:	e320f000 	nop	{0}
    80d8:	e28bd000 	add	sp, fp, #0
    80dc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    80e0:	e12fff1e 	bx	lr

000080e4 <__aeabi_unwind_cpp_pr1>:
__aeabi_unwind_cpp_pr1():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/17-FPU/kernel/src/cxx.cpp:41

extern "C" void __aeabi_unwind_cpp_pr1()
{
    80e4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    80e8:	e28db000 	add	fp, sp, #0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/17-FPU/kernel/src/cxx.cpp:42 (discriminator 1)
    while (true)
    80ec:	eafffffe 	b	80ec <__aeabi_unwind_cpp_pr1+0x8>

000080f0 <_Z21Fahrenheit_To_Celsiusf>:
_Z21Fahrenheit_To_Celsiusf():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/17-FPU/kernel/src/main.cpp:2
float Fahrenheit_To_Celsius(float fahrenheit)
{
    80f0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    80f4:	e28db000 	add	fp, sp, #0
    80f8:	e24dd00c 	sub	sp, sp, #12
    80fc:	ed0b0a02 	vstr	s0, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/17-FPU/kernel/src/main.cpp:3
    return (fahrenheit - 32) * 5.0f / 9.0f;
    8100:	ed5b7a02 	vldr	s15, [fp, #-8]
    8104:	ed9f7a09 	vldr	s14, [pc, #36]	; 8130 <_Z21Fahrenheit_To_Celsiusf+0x40>
    8108:	ee777ac7 	vsub.f32	s15, s15, s14
    810c:	ed9f7a08 	vldr	s14, [pc, #32]	; 8134 <_Z21Fahrenheit_To_Celsiusf+0x44>
    8110:	ee677a87 	vmul.f32	s15, s15, s14
    8114:	ed9f7a07 	vldr	s14, [pc, #28]	; 8138 <_Z21Fahrenheit_To_Celsiusf+0x48>
    8118:	eec76a87 	vdiv.f32	s13, s15, s14
    811c:	eef07a66 	vmov.f32	s15, s13
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/17-FPU/kernel/src/main.cpp:4
}
    8120:	eeb00a67 	vmov.f32	s0, s15
    8124:	e28bd000 	add	sp, fp, #0
    8128:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    812c:	e12fff1e 	bx	lr
    8130:	42000000 	andmi	r0, r0, #0
    8134:	40a00000 	adcmi	r0, r0, r0
    8138:	41100000 	tstmi	r0, r0

0000813c <_kernel_main>:
_kernel_main():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/17-FPU/kernel/src/main.cpp:7

extern "C" int _kernel_main()
{
    813c:	e92d4800 	push	{fp, lr}
    8140:	e28db004 	add	fp, sp, #4
    8144:	e24dd008 	sub	sp, sp, #8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/17-FPU/kernel/src/main.cpp:8
    int celsius = Fahrenheit_To_Celsius(100.0f);
    8148:	ed9f0a05 	vldr	s0, [pc, #20]	; 8164 <_kernel_main+0x28>
    814c:	ebffffe7 	bl	80f0 <_Z21Fahrenheit_To_Celsiusf>
    8150:	eef07a40 	vmov.f32	s15, s0
    8154:	eefd7ae7 	vcvt.s32.f32	s15, s15
    8158:	ee173a90 	vmov	r3, s15
    815c:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/17-FPU/kernel/src/main.cpp:10 (discriminator 1)

    while (1)
    8160:	eafffffe 	b	8160 <_kernel_main+0x24>
    8164:	42c80000 	sbcmi	r0, r8, #0

00008168 <_c_startup>:
_c_startup():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/17-FPU/kernel/src/startup.cpp:21
extern "C" dtor_ptr __DTOR_LIST__[0];
// konec pole destruktoru
extern "C" dtor_ptr __DTOR_END__[0];

extern "C" int _c_startup(void)
{
    8168:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    816c:	e28db000 	add	fp, sp, #0
    8170:	e24dd00c 	sub	sp, sp, #12
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/17-FPU/kernel/src/startup.cpp:25
    int* i;

    // vynulujeme .bss sekci
    for (i = (int*)_bss_start; i < (int*)_bss_end; i++)
    8174:	e59f304c 	ldr	r3, [pc, #76]	; 81c8 <_c_startup+0x60>
    8178:	e5933000 	ldr	r3, [r3]
    817c:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/17-FPU/kernel/src/startup.cpp:25 (discriminator 3)
    8180:	e59f3044 	ldr	r3, [pc, #68]	; 81cc <_c_startup+0x64>
    8184:	e5933000 	ldr	r3, [r3]
    8188:	e1a02003 	mov	r2, r3
    818c:	e51b3008 	ldr	r3, [fp, #-8]
    8190:	e1530002 	cmp	r3, r2
    8194:	2a000006 	bcs	81b4 <_c_startup+0x4c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/17-FPU/kernel/src/startup.cpp:26 (discriminator 2)
        *i = 0;
    8198:	e51b3008 	ldr	r3, [fp, #-8]
    819c:	e3a02000 	mov	r2, #0
    81a0:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/17-FPU/kernel/src/startup.cpp:25 (discriminator 2)
    for (i = (int*)_bss_start; i < (int*)_bss_end; i++)
    81a4:	e51b3008 	ldr	r3, [fp, #-8]
    81a8:	e2833004 	add	r3, r3, #4
    81ac:	e50b3008 	str	r3, [fp, #-8]
    81b0:	eafffff2 	b	8180 <_c_startup+0x18>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/17-FPU/kernel/src/startup.cpp:28

    return 0;
    81b4:	e3a03000 	mov	r3, #0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/17-FPU/kernel/src/startup.cpp:29
}
    81b8:	e1a00003 	mov	r0, r3
    81bc:	e28bd000 	add	sp, fp, #0
    81c0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    81c4:	e12fff1e 	bx	lr
    81c8:	00008280 	andeq	r8, r0, r0, lsl #5
    81cc:	00008290 	muleq	r0, r0, r2

000081d0 <_cpp_startup>:
_cpp_startup():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/17-FPU/kernel/src/startup.cpp:32

extern "C" int _cpp_startup(void)
{
    81d0:	e92d4800 	push	{fp, lr}
    81d4:	e28db004 	add	fp, sp, #4
    81d8:	e24dd008 	sub	sp, sp, #8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/17-FPU/kernel/src/startup.cpp:37
    ctor_ptr* fnptr;

    // zavolame konstruktory globalnich C++ trid
    // v poli __CTOR_LIST__ jsou ukazatele na vygenerovane stuby volani konstruktoru
    for (fnptr = __CTOR_LIST__; fnptr < __CTOR_END__; fnptr++)
    81dc:	e59f303c 	ldr	r3, [pc, #60]	; 8220 <_cpp_startup+0x50>
    81e0:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/17-FPU/kernel/src/startup.cpp:37 (discriminator 3)
    81e4:	e51b3008 	ldr	r3, [fp, #-8]
    81e8:	e59f2034 	ldr	r2, [pc, #52]	; 8224 <_cpp_startup+0x54>
    81ec:	e1530002 	cmp	r3, r2
    81f0:	2a000006 	bcs	8210 <_cpp_startup+0x40>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/17-FPU/kernel/src/startup.cpp:38 (discriminator 2)
        (*fnptr)();
    81f4:	e51b3008 	ldr	r3, [fp, #-8]
    81f8:	e5933000 	ldr	r3, [r3]
    81fc:	e12fff33 	blx	r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/17-FPU/kernel/src/startup.cpp:37 (discriminator 2)
    for (fnptr = __CTOR_LIST__; fnptr < __CTOR_END__; fnptr++)
    8200:	e51b3008 	ldr	r3, [fp, #-8]
    8204:	e2833004 	add	r3, r3, #4
    8208:	e50b3008 	str	r3, [fp, #-8]
    820c:	eafffff4 	b	81e4 <_cpp_startup+0x14>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/17-FPU/kernel/src/startup.cpp:40

    return 0;
    8210:	e3a03000 	mov	r3, #0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/17-FPU/kernel/src/startup.cpp:41
}
    8214:	e1a00003 	mov	r0, r3
    8218:	e24bd004 	sub	sp, fp, #4
    821c:	e8bd8800 	pop	{fp, pc}
    8220:	00008280 	andeq	r8, r0, r0, lsl #5
    8224:	00008280 	andeq	r8, r0, r0, lsl #5

00008228 <_cpp_shutdown>:
_cpp_shutdown():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/17-FPU/kernel/src/startup.cpp:44

extern "C" int _cpp_shutdown(void)
{
    8228:	e92d4800 	push	{fp, lr}
    822c:	e28db004 	add	fp, sp, #4
    8230:	e24dd008 	sub	sp, sp, #8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/17-FPU/kernel/src/startup.cpp:48
    dtor_ptr* fnptr;

    // zavolame destruktory globalnich C++ trid
    for (fnptr = __DTOR_LIST__; fnptr < __DTOR_END__; fnptr++)
    8234:	e59f303c 	ldr	r3, [pc, #60]	; 8278 <_cpp_shutdown+0x50>
    8238:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/17-FPU/kernel/src/startup.cpp:48 (discriminator 3)
    823c:	e51b3008 	ldr	r3, [fp, #-8]
    8240:	e59f2034 	ldr	r2, [pc, #52]	; 827c <_cpp_shutdown+0x54>
    8244:	e1530002 	cmp	r3, r2
    8248:	2a000006 	bcs	8268 <_cpp_shutdown+0x40>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/17-FPU/kernel/src/startup.cpp:49 (discriminator 2)
        (*fnptr)();
    824c:	e51b3008 	ldr	r3, [fp, #-8]
    8250:	e5933000 	ldr	r3, [r3]
    8254:	e12fff33 	blx	r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/17-FPU/kernel/src/startup.cpp:48 (discriminator 2)
    for (fnptr = __DTOR_LIST__; fnptr < __DTOR_END__; fnptr++)
    8258:	e51b3008 	ldr	r3, [fp, #-8]
    825c:	e2833004 	add	r3, r3, #4
    8260:	e50b3008 	str	r3, [fp, #-8]
    8264:	eafffff4 	b	823c <_cpp_shutdown+0x14>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/17-FPU/kernel/src/startup.cpp:51

    return 0;
    8268:	e3a03000 	mov	r3, #0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/17-FPU/kernel/src/startup.cpp:52
}
    826c:	e1a00003 	mov	r0, r3
    8270:	e24bd004 	sub	sp, fp, #4
    8274:	e8bd8800 	pop	{fp, pc}
    8278:	00008280 	andeq	r8, r0, r0, lsl #5
    827c:	00008280 	andeq	r8, r0, r0, lsl #5

Disassembly of section .bss:

00008280 <_bss_start>:
	...

Disassembly of section .debug_info:

00000000 <.debug_info>:
   0:	00000126 	andeq	r0, r0, r6, lsr #2
   4:	00000004 	andeq	r0, r0, r4
   8:	01040000 	mrseq	r0, (UNDEF: 4)
   c:	00000061 	andeq	r0, r0, r1, rrx
  10:	00010f04 	andeq	r0, r1, r4, lsl #30
  14:	00000000 	andeq	r0, r0, r0
  18:	00801800 	addeq	r1, r0, r0, lsl #16
  1c:	0000d800 	andeq	sp, r0, r0, lsl #16
  20:	00000000 	andeq	r0, r0, r0
  24:	01a30200 			; <UNDEFINED> instruction: 0x01a30200
  28:	28010000 	stmdacs	r1, {}	; <UNPREDICTABLE>
  2c:	0080e411 	addeq	lr, r0, r1, lsl r4
  30:	00000c00 	andeq	r0, r0, r0, lsl #24
  34:	029c0100 	addseq	r0, ip, #0, 2
  38:	00000190 	muleq	r0, r0, r1
  3c:	cc112301 	ldcgt	3, cr2, [r1], {1}
  40:	18000080 	stmdane	r0, {r7}
  44:	01000000 	mrseq	r0, (UNDEF: 0)
  48:	0157029c 			; <UNDEFINED> instruction: 0x0157029c
  4c:	1e010000 	cdpne	0, 0, cr0, cr1, cr0, {0}
  50:	0080b411 	addeq	fp, r0, r1, lsl r4
  54:	00001800 	andeq	r1, r0, r0, lsl #16
  58:	029c0100 	addseq	r0, ip, #0, 2
  5c:	00000164 	andeq	r0, r0, r4, ror #2
  60:	9c111901 			; <UNDEFINED> instruction: 0x9c111901
  64:	18000080 	stmdane	r0, {r7}
  68:	01000000 	mrseq	r0, (UNDEF: 0)
  6c:	0185039c 			; <UNDEFINED> instruction: 0x0185039c
  70:	00020000 	andeq	r0, r2, r0
  74:	000000bb 	strheq	r0, [r0], -fp
  78:	00004f04 	andeq	r4, r0, r4, lsl #30
  7c:	15140100 	ldrne	r0, [r4, #-256]	; 0xffffff00
  80:	0000008a 	andeq	r0, r0, sl, lsl #1
  84:	0000bb05 	andeq	fp, r0, r5, lsl #22
  88:	ba060000 	blt	180090 <_bss_end+0x177e00>
  8c:	01000001 	tsteq	r0, r1
  90:	00c11f04 	sbceq	r1, r1, r4, lsl #30
  94:	3b040000 	blcc	10009c <_bss_end+0xf7e0c>
  98:	01000000 	mrseq	r0, (UNDEF: 0)
  9c:	00a8150f 	adceq	r1, r8, pc, lsl #10
  a0:	bb050000 	bllt	1400a8 <_bss_end+0x137e18>
  a4:	00000000 	andeq	r0, r0, r0
  a8:	00017107 	andeq	r7, r1, r7, lsl #2
  ac:	140a0100 	strne	r0, [sl], #-256	; 0xffffff00
  b0:	00000105 	andeq	r0, r0, r5, lsl #2
  b4:	0000bb05 	andeq	fp, r0, r5, lsl #22
  b8:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
  bc:	00008a04 	andeq	r8, r0, r4, lsl #20
  c0:	05080900 	streq	r0, [r8, #-2304]	; 0xfffff700
  c4:	000001c2 	andeq	r0, r0, r2, asr #3
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
 11c:	0a010067 	beq	402c0 <_bss_end+0x38030>
 120:	0000bb31 	andeq	fp, r0, r1, lsr fp
 124:	74910200 	ldrvc	r0, [r1], #512	; 0x200
 128:	00880000 	addeq	r0, r8, r0
 12c:	00040000 	andeq	r0, r4, r0
 130:	000000d0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
 134:	00610104 	rsbeq	r0, r1, r4, lsl #2
 138:	19040000 	stmdbne	r4, {}	; <UNPREDICTABLE>
 13c:	00000002 	andeq	r0, r0, r2
 140:	f0000000 			; <UNDEFINED> instruction: 0xf0000000
 144:	78000080 	stmdavc	r0, {r7}
 148:	a9000000 	stmdbge	r0, {}	; <UNPREDICTABLE>
 14c:	02000000 	andeq	r0, r0, #0
 150:	00000201 	andeq	r0, r0, r1, lsl #4
 154:	4f100601 	svcmi	0x00100601
 158:	3c000000 	stccc	0, cr0, [r0], {-0}
 15c:	2c000081 	stccs	0, cr0, [r0], {129}	; 0x81
 160:	01000000 	mrseq	r0, (UNDEF: 0)
 164:	00004f9c 	muleq	r0, ip, pc	; <UNPREDICTABLE>
 168:	02620300 	rsbeq	r0, r2, #0, 6
 16c:	08010000 	stmdaeq	r1, {}	; <UNPREDICTABLE>
 170:	00004f09 	andeq	r4, r0, r9, lsl #30
 174:	74910200 	ldrvc	r0, [r1], #512	; 0x200
 178:	05040400 	streq	r0, [r4, #-1024]	; 0xfffffc00
 17c:	00746e69 	rsbseq	r6, r4, r9, ror #28
 180:	0001eb05 	andeq	lr, r1, r5, lsl #22
 184:	07010100 	streq	r0, [r1, -r0, lsl #2]
 188:	000001d0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
 18c:	00000084 	andeq	r0, r0, r4, lsl #1
 190:	000080f0 	strdeq	r8, [r0], -r0
 194:	0000004c 	andeq	r0, r0, ip, asr #32
 198:	00849c01 	addeq	r9, r4, r1, lsl #24
 19c:	0e060000 	cdpeq	0, 0, cr0, cr6, cr0, {0}
 1a0:	01000002 	tsteq	r0, r2
 1a4:	00842301 	addeq	r2, r4, r1, lsl #6
 1a8:	91020000 	mrsls	r0, (UNDEF: 2)
 1ac:	04070074 	streq	r0, [r7], #-116	; 0xffffff8c
 1b0:	0003bb04 	andeq	fp, r3, r4, lsl #22
 1b4:	00220000 	eoreq	r0, r2, r0
 1b8:	00020000 	andeq	r0, r2, r0
 1bc:	00000156 	andeq	r0, r0, r6, asr r1
 1c0:	013b0104 	teqeq	fp, r4, lsl #2
 1c4:	80000000 	andhi	r0, r0, r0
 1c8:	80180000 	andshi	r0, r8, r0
 1cc:	026a0000 	rsbeq	r0, sl, #0
 1d0:	00000000 	andeq	r0, r0, r0
 1d4:	02b20000 	adcseq	r0, r2, #0
 1d8:	80010000 	andhi	r0, r1, r0
 1dc:	0000014b 	andeq	r0, r0, fp, asr #2
 1e0:	016a0004 	cmneq	sl, r4
 1e4:	01040000 	mrseq	r0, (UNDEF: 4)
 1e8:	00000061 	andeq	r0, r0, r1, rrx
 1ec:	0002be04 	andeq	fp, r2, r4, lsl #28
 1f0:	00000000 	andeq	r0, r0, r0
 1f4:	00816800 	addeq	r6, r1, r0, lsl #16
 1f8:	00011800 	andeq	r1, r1, r0, lsl #16
 1fc:	0001b500 	andeq	fp, r1, r0, lsl #10
 200:	036b0200 	cmneq	fp, #0, 4
 204:	02010000 	andeq	r0, r1, #0
 208:	00003107 	andeq	r3, r0, r7, lsl #2
 20c:	37040300 	strcc	r0, [r4, -r0, lsl #6]
 210:	04000000 	streq	r0, [r0], #-0
 214:	00036202 	andeq	r6, r3, r2, lsl #4
 218:	07030100 	streq	r0, [r3, -r0, lsl #2]
 21c:	00000031 	andeq	r0, r0, r1, lsr r0
 220:	00030a05 	andeq	r0, r3, r5, lsl #20
 224:	10060100 	andne	r0, r6, r0, lsl #2
 228:	00000050 	andeq	r0, r0, r0, asr r0
 22c:	69050406 	stmdbvs	r5, {r1, r2, sl}
 230:	0500746e 	streq	r7, [r0, #-1134]	; 0xfffffb92
 234:	0000034b 	andeq	r0, r0, fp, asr #6
 238:	50100801 	andspl	r0, r0, r1, lsl #16
 23c:	07000000 	streq	r0, [r0, -r0]
 240:	00000025 	andeq	r0, r0, r5, lsr #32
 244:	00000076 	andeq	r0, r0, r6, ror r0
 248:	00007608 	andeq	r7, r0, r8, lsl #12
 24c:	ffffff00 			; <UNDEFINED> instruction: 0xffffff00
 250:	040900ff 	streq	r0, [r9], #-255	; 0xffffff01
 254:	0006cc07 	andeq	ip, r6, r7, lsl #24
 258:	03220500 			; <UNDEFINED> instruction: 0x03220500
 25c:	0b010000 	bleq	40264 <_bss_end+0x37fd4>
 260:	00006315 	andeq	r6, r0, r5, lsl r3
 264:	03150500 	tsteq	r5, #0, 10
 268:	0d010000 	stceq	0, cr0, [r1, #-0]
 26c:	00006315 	andeq	r6, r0, r5, lsl r3
 270:	00380700 	eorseq	r0, r8, r0, lsl #14
 274:	00a80000 	adceq	r0, r8, r0
 278:	76080000 	strvc	r0, [r8], -r0
 27c:	ff000000 			; <UNDEFINED> instruction: 0xff000000
 280:	00ffffff 	ldrshteq	pc, [pc], #255	; <UNPREDICTABLE>
 284:	00035405 	andeq	r5, r3, r5, lsl #8
 288:	15100100 	ldrne	r0, [r0, #-256]	; 0xffffff00
 28c:	00000095 	muleq	r0, r5, r0
 290:	00033005 	andeq	r3, r3, r5
 294:	15120100 	ldrne	r0, [r2, #-256]	; 0xffffff00
 298:	00000095 	muleq	r0, r5, r0
 29c:	00033d0a 	andeq	r3, r3, sl, lsl #26
 2a0:	102b0100 	eorne	r0, fp, r0, lsl #2
 2a4:	00000050 	andeq	r0, r0, r0, asr r0
 2a8:	00008228 	andeq	r8, r0, r8, lsr #4
 2ac:	00000058 	andeq	r0, r0, r8, asr r0
 2b0:	00ea9c01 	rsceq	r9, sl, r1, lsl #24
 2b4:	8c0b0000 	stchi	0, cr0, [fp], {-0}
 2b8:	01000003 	tsteq	r0, r3
 2bc:	00ea0f2d 	rsceq	r0, sl, sp, lsr #30
 2c0:	91020000 	mrsls	r0, (UNDEF: 2)
 2c4:	04030074 	streq	r0, [r3], #-116	; 0xffffff8c
 2c8:	00000038 	andeq	r0, r0, r8, lsr r0
 2cc:	00037f0a 	andeq	r7, r3, sl, lsl #30
 2d0:	101f0100 	andsne	r0, pc, r0, lsl #2
 2d4:	00000050 	andeq	r0, r0, r0, asr r0
 2d8:	000081d0 	ldrdeq	r8, [r0], -r0
 2dc:	00000058 	andeq	r0, r0, r8, asr r0
 2e0:	011a9c01 	tsteq	sl, r1, lsl #24
 2e4:	8c0b0000 	stchi	0, cr0, [fp], {-0}
 2e8:	01000003 	tsteq	r0, r3
 2ec:	011a0f21 	tsteq	sl, r1, lsr #30
 2f0:	91020000 	mrsls	r0, (UNDEF: 2)
 2f4:	04030074 	streq	r0, [r3], #-116	; 0xffffff8c
 2f8:	00000025 	andeq	r0, r0, r5, lsr #32
 2fc:	0003740c 	andeq	r7, r3, ip, lsl #8
 300:	10140100 	andsne	r0, r4, r0, lsl #2
 304:	00000050 	andeq	r0, r0, r0, asr r0
 308:	00008168 	andeq	r8, r0, r8, ror #2
 30c:	00000068 	andeq	r0, r0, r8, rrx
 310:	01489c01 	cmpeq	r8, r1, lsl #24
 314:	690d0000 	stmdbvs	sp, {}	; <UNPREDICTABLE>
 318:	0a160100 	beq	580720 <_bss_end+0x578490>
 31c:	00000148 	andeq	r0, r0, r8, asr #2
 320:	00749102 	rsbseq	r9, r4, r2, lsl #2
 324:	00500403 	subseq	r0, r0, r3, lsl #8
 328:	2a000000 	bcs	330 <_start-0x7cd0>
 32c:	04000003 	streq	r0, [r0], #-3
 330:	00023000 	andeq	r3, r2, r0
 334:	bc010400 	cfstrslt	mvf0, [r1], {-0}
 338:	0c000004 	stceq	0, cr0, [r0], {4}
 33c:	00000675 	andeq	r0, r0, r5, ror r6
 340:	000007d7 	ldrdeq	r0, [r0], -r7
 344:	0000029c 	muleq	r0, ip, r2
 348:	69050402 	stmdbvs	r5, {r1, sl}
 34c:	0300746e 	movweq	r7, #1134	; 0x46e
 350:	06cc0704 	strbeq	r0, [ip], r4, lsl #14
 354:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
 358:	0001c205 	andeq	ip, r1, r5, lsl #4
 35c:	04080300 	streq	r0, [r8], #-768	; 0xfffffd00
 360:	00000669 	andeq	r0, r0, r9, ror #12
 364:	98080103 	stmdals	r8, {r0, r1, r8}
 368:	03000006 	movweq	r0, #6
 36c:	069a0601 	ldreq	r0, [sl], r1, lsl #12
 370:	ca040000 	bgt	100378 <_bss_end+0xf80e8>
 374:	07000008 	streq	r0, [r0, -r8]
 378:	00003901 	andeq	r3, r0, r1, lsl #18
 37c:	06170100 	ldreq	r0, [r7], -r0, lsl #2
 380:	000001d4 	ldrdeq	r0, [r0], -r4
 384:	0003c105 	andeq	ip, r3, r5, lsl #2
 388:	79050000 	stmdbvc	r5, {}	; <UNPREDICTABLE>
 38c:	01000009 	tsteq	r0, r9
 390:	00059e05 	andeq	r9, r5, r5, lsl #28
 394:	5c050200 	sfmpl	f0, 4, [r5], {-0}
 398:	03000006 	movweq	r0, #6
 39c:	0008e305 	andeq	lr, r8, r5, lsl #6
 3a0:	89050400 	stmdbhi	r5, {sl}
 3a4:	05000009 	streq	r0, [r0, #-9]
 3a8:	0008f905 	andeq	pc, r8, r5, lsl #18
 3ac:	b3050600 	movwlt	r0, #22016	; 0x5600
 3b0:	07000006 	streq	r0, [r0, -r6]
 3b4:	00087405 	andeq	r7, r8, r5, lsl #8
 3b8:	82050800 	andhi	r0, r5, #0, 16
 3bc:	09000008 	stmdbeq	r0, {r3}
 3c0:	00089005 	andeq	r9, r8, r5
 3c4:	2f050a00 	svccs	0x00050a00
 3c8:	0b000007 	bleq	3ec <_start-0x7c14>
 3cc:	00071f05 	andeq	r1, r7, r5, lsl #30
 3d0:	dd050c00 	stcle	12, cr0, [r5, #-0]
 3d4:	0d000003 	stceq	0, cr0, [r0, #-12]
 3d8:	00040005 	andeq	r0, r4, r5
 3dc:	10050e00 	andne	r0, r5, r0, lsl #28
 3e0:	0f000007 	svceq	0x00000007
 3e4:	00093c05 	andeq	r3, r9, r5, lsl #24
 3e8:	b9051000 	stmdblt	r5, {ip}
 3ec:	11000008 	tstne	r0, r8
 3f0:	00092d05 	andeq	r2, r9, r5, lsl #26
 3f4:	ad051200 	sfmge	f1, 4, [r5, #-0]
 3f8:	13000004 	movwne	r0, #4
 3fc:	00042a05 	andeq	r2, r4, r5, lsl #20
 400:	f4051400 	vst3.8	{d1-d3}, [r5], r0
 404:	15000003 	strne	r0, [r0, #-3]
 408:	0007ae05 	andeq	sl, r7, r5, lsl #28
 40c:	61051600 	tstvs	r5, r0, lsl #12
 410:	17000004 	strne	r0, [r0, -r4]
 414:	00039205 	andeq	r9, r3, r5, lsl #4
 418:	1f051800 	svcne	0x00051800
 41c:	19000009 	stmdbne	r0, {r0, r3}
 420:	0006d905 	andeq	sp, r6, r5, lsl #18
 424:	c6051a00 	strgt	r1, [r5], -r0, lsl #20
 428:	1b000007 	blne	44c <_start-0x7bb4>
 42c:	00043505 	andeq	r3, r4, r5, lsl #10
 430:	41051c00 	tstmi	r5, r0, lsl #24
 434:	1d000006 	stcne	0, cr0, [r0, #-24]	; 0xffffffe8
 438:	00059005 	andeq	r9, r5, r5
 43c:	ab051e00 	blge	147c44 <_bss_end+0x13f9b4>
 440:	1f000008 	svcne	0x00000008
 444:	00090705 	andeq	r0, r9, r5, lsl #14
 448:	48052000 	stmdami	r5, {sp}
 44c:	21000009 	tstcs	r0, r9
 450:	00095605 	andeq	r5, r9, r5, lsl #12
 454:	f0052200 			; <UNDEFINED> instruction: 0xf0052200
 458:	23000006 	movwcs	r0, #6
 45c:	00060505 	andeq	r0, r6, r5, lsl #10
 460:	44052400 	strmi	r2, [r5], #-1024	; 0xfffffc00
 464:	25000004 	strcs	r0, [r0, #-4]
 468:	0006a605 	andeq	sl, r6, r5, lsl #12
 46c:	aa052600 	bge	149c74 <_bss_end+0x1419e4>
 470:	27000005 	strcs	r0, [r0, -r5]
 474:	0008d605 	andeq	sp, r8, r5, lsl #12
 478:	ba052800 	blt	14a480 <_bss_end+0x1421f0>
 47c:	29000005 	stmdbcs	r0, {r0, r2}
 480:	0005c905 	andeq	ip, r5, r5, lsl #18
 484:	d8052a00 	stmdale	r5, {r9, fp, sp}
 488:	2b000005 	blcs	4a4 <_start-0x7b5c>
 48c:	0005e705 	andeq	lr, r5, r5, lsl #14
 490:	75052c00 	strvc	r2, [r5, #-3072]	; 0xfffff400
 494:	2d000005 	stccs	0, cr0, [r0, #-20]	; 0xffffffec
 498:	0005f605 	andeq	pc, r5, r5, lsl #12
 49c:	65052e00 	strvs	r2, [r5, #-3584]	; 0xfffff200
 4a0:	2f000008 	svccs	0x00000008
 4a4:	00061405 	andeq	r1, r6, r5, lsl #8
 4a8:	23053000 	movwcs	r3, #20480	; 0x5000
 4ac:	31000006 	tstcc	r0, r6
 4b0:	0003cb05 	andeq	ip, r3, r5, lsl #22
 4b4:	4e053200 	cdpmi	2, 0, cr3, cr5, cr0, {0}
 4b8:	33000007 	movwcc	r0, #7
 4bc:	00075e05 	andeq	r5, r7, r5, lsl #28
 4c0:	6e053400 	cfcpysvs	mvf3, mvf5
 4c4:	35000007 	strcc	r0, [r0, #-7]
 4c8:	00056305 	andeq	r6, r5, r5, lsl #6
 4cc:	7e053600 	cfmadd32vc	mvax0, mvfx3, mvfx5, mvfx0
 4d0:	37000007 	strcc	r0, [r0, -r7]
 4d4:	00078e05 	andeq	r8, r7, r5, lsl #28
 4d8:	9e053800 	cdpls	8, 0, cr3, cr5, cr0, {0}
 4dc:	39000007 	stmdbcc	r0, {r0, r1, r2}
 4e0:	00045405 	andeq	r5, r4, r5, lsl #8
 4e4:	0d053a00 	vstreq	s6, [r5, #-0]
 4e8:	3b000004 	blcc	500 <_start-0x7b00>
 4ec:	00063205 	andeq	r3, r6, r5, lsl #4
 4f0:	a2053c00 	andge	r3, r5, #0, 24
 4f4:	3d000003 	stccc	0, cr0, [r0, #-12]
 4f8:	0007b905 	andeq	fp, r7, r5, lsl #18
 4fc:	06003e00 	streq	r3, [r0], -r0, lsl #28
 500:	00000494 	muleq	r0, r4, r4
 504:	026b0102 	rsbeq	r0, fp, #-2147483648	; 0x80000000
 508:	0001ff08 	andeq	pc, r1, r8, lsl #30
 50c:	06570700 	ldrbeq	r0, [r7], -r0, lsl #14
 510:	70010000 	andvc	r0, r1, r0
 514:	00471402 	subeq	r1, r7, r2, lsl #8
 518:	07000000 	streq	r0, [r0, -r0]
 51c:	00000570 	andeq	r0, r0, r0, ror r5
 520:	14027101 	strne	r7, [r2], #-257	; 0xfffffeff
 524:	00000047 	andeq	r0, r0, r7, asr #32
 528:	d4080001 	strle	r0, [r8], #-1
 52c:	09000001 	stmdbeq	r0, {r0}
 530:	000001ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
 534:	00000214 	andeq	r0, r0, r4, lsl r2
 538:	0000240a 	andeq	r2, r0, sl, lsl #8
 53c:	08001100 	stmdaeq	r0, {r8, ip}
 540:	00000204 	andeq	r0, r0, r4, lsl #4
 544:	00073c0b 	andeq	r3, r7, fp, lsl #24
 548:	02740100 	rsbseq	r0, r4, #0, 2
 54c:	00021426 	andeq	r1, r2, r6, lsr #8
 550:	3d3a2400 	cfldrscc	mvf2, [sl, #-0]
 554:	3d0f3d0a 	stccc	13, cr3, [pc, #-40]	; 534 <_start-0x7acc>
 558:	3d323d24 	ldccc	13, cr3, [r2, #-144]!	; 0xffffff70
 55c:	3d053d02 	stccc	13, cr3, [r5, #-8]
 560:	3d0d3d13 	stccc	13, cr3, [sp, #-76]	; 0xffffffb4
 564:	3d233d0c 	stccc	13, cr3, [r3, #-48]!	; 0xffffffd0
 568:	3d263d11 	stccc	13, cr3, [r6, #-68]!	; 0xffffffbc
 56c:	3d173d01 	ldccc	13, cr3, [r7, #-4]
 570:	3d093d08 	stccc	13, cr3, [r9, #-32]	; 0xffffffe0
 574:	02030000 	andeq	r0, r3, #0
 578:	0006fd07 	andeq	pc, r6, r7, lsl #26
 57c:	08010300 	stmdaeq	r1, {r8, r9}
 580:	000006a1 	andeq	r0, r0, r1, lsr #13
 584:	59040d0c 	stmdbpl	r4, {r2, r3, r8, sl, fp}
 588:	0e000002 	cdpeq	0, 0, cr0, cr0, cr2, {0}
 58c:	00000964 	andeq	r0, r0, r4, ror #18
 590:	00390107 	eorseq	r0, r9, r7, lsl #2
 594:	f7020000 			; <UNDEFINED> instruction: 0xf7020000
 598:	029e0604 	addseq	r0, lr, #4, 12	; 0x400000
 59c:	6e050000 	cdpvs	0, 0, cr0, cr5, cr0, {0}
 5a0:	00000004 	andeq	r0, r0, r4
 5a4:	00047905 	andeq	r7, r4, r5, lsl #18
 5a8:	8b050100 	blhi	1409b0 <_bss_end+0x138720>
 5ac:	02000004 	andeq	r0, r0, #4
 5b0:	0004a505 	andeq	sl, r4, r5, lsl #10
 5b4:	9e050300 	cdpls	3, 0, cr0, cr5, cr0, {0}
 5b8:	04000008 	streq	r0, [r0], #-8
 5bc:	00058405 	andeq	r8, r5, r5, lsl #8
 5c0:	57050500 	strpl	r0, [r5, -r0, lsl #10]
 5c4:	06000008 	streq	r0, [r0], -r8
 5c8:	05020300 	streq	r0, [r2, #-768]	; 0xfffffd00
 5cc:	000003ea 	andeq	r0, r0, sl, ror #7
 5d0:	c2070803 	andgt	r0, r7, #196608	; 0x30000
 5d4:	03000006 	movweq	r0, #6
 5d8:	03bb0404 			; <UNDEFINED> instruction: 0x03bb0404
 5dc:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
 5e0:	0003b303 	andeq	fp, r3, r3, lsl #6
 5e4:	04080300 	streq	r0, [r8], #-768	; 0xfffffd00
 5e8:	0000066e 	andeq	r0, r0, lr, ror #12
 5ec:	48031003 	stmdami	r3, {r0, r1, ip}
 5f0:	0f000008 	svceq	0x00000008
 5f4:	0000083f 	andeq	r0, r0, pc, lsr r8
 5f8:	5a102a03 	bpl	40ae0c <_bss_end+0x402b7c>
 5fc:	09000002 	stmdbeq	r0, {r1}
 600:	000002c8 	andeq	r0, r0, r8, asr #5
 604:	000002df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
 608:	22110010 	andscs	r0, r1, #16
 60c:	03000003 	movweq	r0, #3
 610:	02d4112f 	sbcseq	r1, r4, #-1073741813	; 0xc000000b
 614:	54110000 	ldrpl	r0, [r1], #-0
 618:	03000003 	movweq	r0, #3
 61c:	02d41130 	sbcseq	r1, r4, #48, 2
 620:	c8090000 	stmdagt	r9, {}	; <UNPREDICTABLE>
 624:	07000002 	streq	r0, [r0, -r2]
 628:	0a000003 	beq	63c <_start-0x79c4>
 62c:	00000024 	andeq	r0, r0, r4, lsr #32
 630:	df120001 	svcle	0x00120001
 634:	04000002 	streq	r0, [r0], #-2
 638:	f70a0933 			; <UNDEFINED> instruction: 0xf70a0933
 63c:	05000002 	streq	r0, [r0, #-2]
 640:	00828003 	addeq	r8, r2, r3
 644:	02eb1200 	rsceq	r1, fp, #0, 4
 648:	34040000 	strcc	r0, [r4], #-0
 64c:	02f70a09 	rscseq	r0, r7, #36864	; 0x9000
 650:	03050000 	movweq	r0, #20480	; 0x5000
 654:	00008280 	andeq	r8, r0, r0, lsl #5
	...

Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
   0:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
   4:	030b130e 	movweq	r1, #45838	; 0xb30e
   8:	110e1b0e 	tstne	lr, lr, lsl #22
   c:	10061201 	andne	r1, r6, r1, lsl #4
  10:	02000017 	andeq	r0, r0, #23
  14:	193f002e 	ldmdbne	pc!, {r1, r2, r3, r5}	; <UNPREDICTABLE>
  18:	0b3a0e03 	bleq	e8382c <_bss_end+0xe7b59c>
  1c:	0b390b3b 	bleq	e42d10 <_bss_end+0xe3aa80>
  20:	06120111 			; <UNDEFINED> instruction: 0x06120111
  24:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
  28:	03000019 	movweq	r0, #25
  2c:	0e030139 	mcreq	1, 0, r0, cr3, cr9, {1}
  30:	0b3b0b3a 	bleq	ec2d20 <_bss_end+0xebaa90>
  34:	00001301 	andeq	r1, r0, r1, lsl #6
  38:	3f012e04 	svccc	0x00012e04
  3c:	3a0e0319 	bcc	380ca8 <_bss_end+0x378a18>
  40:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
  44:	01193c0b 	tsteq	r9, fp, lsl #24
  48:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
  4c:	13490005 	movtne	r0, #36869	; 0x9005
  50:	16060000 	strne	r0, [r6], -r0
  54:	3a0e0300 	bcc	380c5c <_bss_end+0x3789cc>
  58:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
  5c:	0013490b 	andseq	r4, r3, fp, lsl #18
  60:	012e0700 			; <UNDEFINED> instruction: 0x012e0700
  64:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
  68:	0b3b0b3a 	bleq	ec2d58 <_bss_end+0xebaac8>
  6c:	13490b39 	movtne	r0, #39737	; 0x9b39
  70:	0000193c 	andeq	r1, r0, ip, lsr r9
  74:	0b000f08 	bleq	3c9c <_start-0x4364>
  78:	0013490b 	andseq	r4, r3, fp, lsl #18
  7c:	00240900 	eoreq	r0, r4, r0, lsl #18
  80:	0b3e0b0b 	bleq	f82cb4 <_bss_end+0xf7aa24>
  84:	00000e03 	andeq	r0, r0, r3, lsl #28
  88:	47012e0a 	strmi	r2, [r1, -sl, lsl #28]
  8c:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
  90:	97184006 	ldrls	r4, [r8, -r6]
  94:	13011942 	movwne	r1, #6466	; 0x1942
  98:	050b0000 	streq	r0, [fp, #-0]
  9c:	02134900 	andseq	r4, r3, #0, 18
  a0:	0c000018 	stceq	0, cr0, [r0], {24}
  a4:	08030005 	stmdaeq	r3, {r0, r2}
  a8:	0b3b0b3a 	bleq	ec2d98 <_bss_end+0xebab08>
  ac:	13490b39 	movtne	r0, #39737	; 0x9b39
  b0:	00001802 	andeq	r1, r0, r2, lsl #16
  b4:	0b00240d 	bleq	90f0 <_bss_end+0xe60>
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
  e4:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
  e8:	0b3a0e03 	bleq	e838fc <_bss_end+0xe7b66c>
  ec:	0b390b3b 	bleq	e42de0 <_bss_end+0xe3ab50>
  f0:	01111349 	tsteq	r1, r9, asr #6
  f4:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
  f8:	01194296 			; <UNDEFINED> instruction: 0x01194296
  fc:	03000013 	movweq	r0, #19
 100:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 104:	0b3b0b3a 	bleq	ec2df4 <_bss_end+0xebab64>
 108:	13490b39 	movtne	r0, #39737	; 0x9b39
 10c:	00001802 	andeq	r1, r0, r2, lsl #16
 110:	0b002404 	bleq	9128 <_bss_end+0xe98>
 114:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 118:	05000008 	streq	r0, [r0, #-8]
 11c:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 120:	0b3a0e03 	bleq	e83934 <_bss_end+0xe7b6a4>
 124:	0b390b3b 	bleq	e42e18 <_bss_end+0xe3ab88>
 128:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 12c:	06120111 			; <UNDEFINED> instruction: 0x06120111
 130:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 134:	00130119 	andseq	r0, r3, r9, lsl r1
 138:	00050600 	andeq	r0, r5, r0, lsl #12
 13c:	0b3a0e03 	bleq	e83950 <_bss_end+0xe7b6c0>
 140:	0b390b3b 	bleq	e42e34 <_bss_end+0xe3aba4>
 144:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 148:	24070000 	strcs	r0, [r7], #-0
 14c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 150:	000e030b 	andeq	r0, lr, fp, lsl #6
 154:	11010000 	mrsne	r0, (UNDEF: 1)
 158:	11061000 	mrsne	r1, (UNDEF: 6)
 15c:	03011201 	movweq	r1, #4609	; 0x1201
 160:	250e1b0e 	strcs	r1, [lr, #-2830]	; 0xfffff4f2
 164:	0005130e 	andeq	r1, r5, lr, lsl #6
 168:	11010000 	mrsne	r0, (UNDEF: 1)
 16c:	130e2501 	movwne	r2, #58625	; 0xe501
 170:	1b0e030b 	blne	380da4 <_bss_end+0x378b14>
 174:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 178:	00171006 	andseq	r1, r7, r6
 17c:	00160200 	andseq	r0, r6, r0, lsl #4
 180:	0b3a0e03 	bleq	e83994 <_bss_end+0xe7b704>
 184:	0b390b3b 	bleq	e42e78 <_bss_end+0xe3abe8>
 188:	00001349 	andeq	r1, r0, r9, asr #6
 18c:	0b000f03 	bleq	3da0 <_start-0x4260>
 190:	0013490b 	andseq	r4, r3, fp, lsl #18
 194:	00150400 	andseq	r0, r5, r0, lsl #8
 198:	34050000 	strcc	r0, [r5], #-0
 19c:	3a0e0300 	bcc	380da4 <_bss_end+0x378b14>
 1a0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 1a4:	3f13490b 	svccc	0x0013490b
 1a8:	00193c19 	andseq	r3, r9, r9, lsl ip
 1ac:	00240600 	eoreq	r0, r4, r0, lsl #12
 1b0:	0b3e0b0b 	bleq	f82de4 <_bss_end+0xf7ab54>
 1b4:	00000803 	andeq	r0, r0, r3, lsl #16
 1b8:	49010107 	stmdbmi	r1, {r0, r1, r2, r8}
 1bc:	00130113 	andseq	r0, r3, r3, lsl r1
 1c0:	00210800 	eoreq	r0, r1, r0, lsl #16
 1c4:	062f1349 	strteq	r1, [pc], -r9, asr #6
 1c8:	24090000 	strcs	r0, [r9], #-0
 1cc:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 1d0:	000e030b 	andeq	r0, lr, fp, lsl #6
 1d4:	012e0a00 			; <UNDEFINED> instruction: 0x012e0a00
 1d8:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 1dc:	0b3b0b3a 	bleq	ec2ecc <_bss_end+0xebac3c>
 1e0:	13490b39 	movtne	r0, #39737	; 0x9b39
 1e4:	06120111 			; <UNDEFINED> instruction: 0x06120111
 1e8:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 1ec:	00130119 	andseq	r0, r3, r9, lsl r1
 1f0:	00340b00 	eorseq	r0, r4, r0, lsl #22
 1f4:	0b3a0e03 	bleq	e83a08 <_bss_end+0xe7b778>
 1f8:	0b390b3b 	bleq	e42eec <_bss_end+0xe3ac5c>
 1fc:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 200:	2e0c0000 	cdpcs	0, 0, cr0, cr12, cr0, {0}
 204:	03193f01 	tsteq	r9, #1, 30
 208:	3b0b3a0e 	blcc	2cea48 <_bss_end+0x2c67b8>
 20c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 210:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 214:	97184006 	ldrls	r4, [r8, -r6]
 218:	13011942 	movwne	r1, #6466	; 0x1942
 21c:	340d0000 	strcc	r0, [sp], #-0
 220:	3a080300 	bcc	200e28 <_bss_end+0x1f8b98>
 224:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 228:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 22c:	00000018 	andeq	r0, r0, r8, lsl r0
 230:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
 234:	030b130e 	movweq	r1, #45838	; 0xb30e
 238:	100e1b0e 	andne	r1, lr, lr, lsl #22
 23c:	02000017 	andeq	r0, r0, #23
 240:	0b0b0024 	bleq	2c02d8 <_bss_end+0x2b8048>
 244:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
 248:	24030000 	strcs	r0, [r3], #-0
 24c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 250:	000e030b 	andeq	r0, lr, fp, lsl #6
 254:	01040400 	tsteq	r4, r0, lsl #8
 258:	0b3e0e03 	bleq	f83a6c <_bss_end+0xf7b7dc>
 25c:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 260:	0b3b0b3a 	bleq	ec2f50 <_bss_end+0xebacc0>
 264:	13010b39 	movwne	r0, #6969	; 0x1b39
 268:	28050000 	stmdacs	r5, {}	; <UNPREDICTABLE>
 26c:	1c0e0300 	stcne	3, cr0, [lr], {-0}
 270:	0600000b 	streq	r0, [r0], -fp
 274:	0e030113 	mcreq	1, 0, r0, cr3, cr3, {0}
 278:	0b3a0b0b 	bleq	e82eac <_bss_end+0xe7ac1c>
 27c:	0b39053b 	bleq	e41770 <_bss_end+0xe394e0>
 280:	00001301 	andeq	r1, r0, r1, lsl #6
 284:	03000d07 	movweq	r0, #3335	; 0xd07
 288:	3b0b3a0e 	blcc	2ceac8 <_bss_end+0x2c6838>
 28c:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
 290:	000b3813 	andeq	r3, fp, r3, lsl r8
 294:	00260800 	eoreq	r0, r6, r0, lsl #16
 298:	00001349 	andeq	r1, r0, r9, asr #6
 29c:	49010109 	stmdbmi	r1, {r0, r3, r8}
 2a0:	00130113 	andseq	r0, r3, r3, lsl r1
 2a4:	00210a00 	eoreq	r0, r1, r0, lsl #20
 2a8:	0b2f1349 	bleq	bc4fd4 <_bss_end+0xbbcd44>
 2ac:	340b0000 	strcc	r0, [fp], #-0
 2b0:	3a0e0300 	bcc	380eb8 <_bss_end+0x378c28>
 2b4:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 2b8:	1c13490b 			; <UNDEFINED> instruction: 0x1c13490b
 2bc:	0c00000a 	stceq	0, cr0, [r0], {10}
 2c0:	19270015 	stmdbne	r7!, {r0, r2, r4}
 2c4:	0f0d0000 	svceq	0x000d0000
 2c8:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 2cc:	0e000013 	mcreq	0, 0, r0, cr0, cr3, {0}
 2d0:	0e030104 	adfeqs	f0, f3, f4
 2d4:	0b0b0b3e 	bleq	2c2fd4 <_bss_end+0x2bad44>
 2d8:	0b3a1349 	bleq	e85004 <_bss_end+0xe7cd74>
 2dc:	0b39053b 	bleq	e417d0 <_bss_end+0xe39540>
 2e0:	00001301 	andeq	r1, r0, r1, lsl #6
 2e4:	0300160f 	movweq	r1, #1551	; 0x60f
 2e8:	3b0b3a0e 	blcc	2ceb28 <_bss_end+0x2c6898>
 2ec:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 2f0:	10000013 	andne	r0, r0, r3, lsl r0
 2f4:	00000021 	andeq	r0, r0, r1, lsr #32
 2f8:	03003411 	movweq	r3, #1041	; 0x411
 2fc:	3b0b3a0e 	blcc	2ceb3c <_bss_end+0x2c68ac>
 300:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 304:	3c193f13 	ldccc	15, cr3, [r9], {19}
 308:	12000019 	andne	r0, r0, #25
 30c:	13470034 	movtne	r0, #28724	; 0x7034
 310:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 314:	13490b39 	movtne	r0, #39737	; 0x9b39
 318:	00001802 	andeq	r1, r0, r2, lsl #16
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
  34:	00000078 	andeq	r0, r0, r8, ror r0
	...
  40:	0000001c 	andeq	r0, r0, ip, lsl r0
  44:	01b60002 			; <UNDEFINED> instruction: 0x01b60002
  48:	00040000 	andeq	r0, r4, r0
  4c:	00000000 	andeq	r0, r0, r0
  50:	00008000 	andeq	r8, r0, r0
  54:	00000018 	andeq	r0, r0, r8, lsl r0
	...
  60:	0000001c 	andeq	r0, r0, ip, lsl r0
  64:	01dc0002 	bicseq	r0, ip, r2
  68:	00040000 	andeq	r0, r4, r0
  6c:	00000000 	andeq	r0, r0, r0
  70:	00008168 	andeq	r8, r0, r8, ror #2
  74:	00000118 	andeq	r0, r0, r8, lsl r1
	...
  80:	00000014 	andeq	r0, r0, r4, lsl r0
  84:	032b0002 			; <UNDEFINED> instruction: 0x032b0002
  88:	00040000 	andeq	r0, r4, r0
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
  34:	5a2f7374 	bpl	bdce0c <_bss_end+0xbd4b7c>
  38:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; fffffeac <_bss_end+0xffff7c1c>
  3c:	2f657461 	svccs	0x00657461
  40:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
  44:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
  48:	2d37312f 	ldfcss	f3, [r7, #-188]!	; 0xffffff44
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
  78:	18020500 	stmdane	r2, {r8, sl}
  7c:	03000080 	movweq	r0, #128	; 0x80
  80:	1105010a 	tstne	r5, sl, lsl #2
  84:	4a100583 	bmi	401698 <_bss_end+0x3f9408>
  88:	85830505 	strhi	r0, [r3, #1285]	; 0x505
  8c:	05831305 	streq	r1, [r3, #773]	; 0x305
  90:	83856705 	orrhi	r6, r5, #1310720	; 0x140000
  94:	4c860105 	stfmis	f0, [r6], {5}
  98:	4c854c85 	stcmi	12, cr4, [r5], {133}	; 0x85
  9c:	00050585 	andeq	r0, r5, r5, lsl #11
  a0:	4b010402 	blmi	410b0 <_bss_end+0x38e20>
  a4:	01000202 	tsteq	r0, r2, lsl #4
  a8:	00008e01 	andeq	r8, r0, r1, lsl #28
  ac:	5f000300 	svcpl	0x00000300
  b0:	02000000 	andeq	r0, r0, #0
  b4:	0d0efb01 	vstreq	d15, [lr, #-4]
  b8:	01010100 	mrseq	r0, (UNDEF: 17)
  bc:	00000001 	andeq	r0, r0, r1
  c0:	01000001 	tsteq	r0, r1
  c4:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
  c8:	552f632f 	strpl	r6, [pc, #-815]!	; fffffda1 <_bss_end+0xffff7b11>
  cc:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
  d0:	62754b2f 	rsbsvs	r4, r5, #48128	; 0xbc00
  d4:	6f442f61 	svcvs	0x00442f61
  d8:	656d7563 	strbvs	r7, [sp, #-1379]!	; 0xfffffa9d
  dc:	2f73746e 	svccs	0x0073746e
  e0:	6f72655a 	svcvs	0x0072655a
  e4:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
  e8:	6178652f 	cmnvs	r8, pc, lsr #10
  ec:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
  f0:	37312f73 			; <UNDEFINED> instruction: 0x37312f73
  f4:	5550462d 	ldrbpl	r4, [r0, #-1581]	; 0xfffff9d3
  f8:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
  fc:	2f6c656e 	svccs	0x006c656e
 100:	00637273 	rsbeq	r7, r3, r3, ror r2
 104:	69616d00 	stmdbvs	r1!, {r8, sl, fp, sp, lr}^
 108:	70632e6e 	rsbvc	r2, r3, lr, ror #28
 10c:	00010070 	andeq	r0, r1, r0, ror r0
 110:	01050000 	mrseq	r0, (UNDEF: 5)
 114:	f0020500 			; <UNDEFINED> instruction: 0xf0020500
 118:	13000080 	movwne	r0, #128	; 0x80
 11c:	05831805 	streq	r1, [r3, #2053]	; 0x805
 120:	2705661e 	smladcs	r5, lr, r6, r6
 124:	6701054a 	strvs	r0, [r1, -sl, asr #10]
 128:	672805d9 			; <UNDEFINED> instruction: 0x672805d9
 12c:	05662f05 	strbeq	r2, [r6, #-3845]!	; 0xfffff0fb
 130:	04020005 	streq	r0, [r2], #-5
 134:	04026801 	streq	r6, [r2], #-2049	; 0xfffff7ff
 138:	76010100 	strvc	r0, [r1], -r0, lsl #2
 13c:	03000000 	movweq	r0, #0
 140:	00005e00 	andeq	r5, r0, r0, lsl #28
 144:	fb010200 	blx	4094e <_bss_end+0x386be>
 148:	01000d0e 	tsteq	r0, lr, lsl #26
 14c:	00010101 	andeq	r0, r1, r1, lsl #2
 150:	00010000 	andeq	r0, r1, r0
 154:	6d2f0100 	stfvss	f0, [pc, #-0]	; 15c <_start-0x7ea4>
 158:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
 15c:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
 160:	4b2f7372 	blmi	bdcf30 <_bss_end+0xbd4ca0>
 164:	2f616275 	svccs	0x00616275
 168:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
 16c:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
 170:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
 174:	614d6f72 	hvcvs	55026	; 0xd6f2
 178:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffc0c <_bss_end+0xffff797c>
 17c:	706d6178 	rsbvc	r6, sp, r8, ror r1
 180:	2f73656c 	svccs	0x0073656c
 184:	462d3731 			; <UNDEFINED> instruction: 0x462d3731
 188:	6b2f5550 	blvs	bd56d0 <_bss_end+0xbcd440>
 18c:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 190:	72732f6c 	rsbsvc	r2, r3, #108, 30	; 0x1b0
 194:	73000063 	movwvc	r0, #99	; 0x63
 198:	74726174 	ldrbtvc	r6, [r2], #-372	; 0xfffffe8c
 19c:	0100732e 	tsteq	r0, lr, lsr #6
 1a0:	00000000 	andeq	r0, r0, r0
 1a4:	80000205 	andhi	r0, r0, r5, lsl #4
 1a8:	2f190000 	svccs	0x00190000
 1ac:	302f2f2f 	eorcc	r2, pc, pc, lsr #30
 1b0:	01000202 	tsteq	r0, r2, lsl #4
 1b4:	0000e301 	andeq	lr, r0, r1, lsl #6
 1b8:	62000300 	andvs	r0, r0, #0, 6
 1bc:	02000000 	andeq	r0, r0, #0
 1c0:	0d0efb01 	vstreq	d15, [lr, #-4]
 1c4:	01010100 	mrseq	r0, (UNDEF: 17)
 1c8:	00000001 	andeq	r0, r0, r1
 1cc:	01000001 	tsteq	r0, r1
 1d0:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
 1d4:	552f632f 	strpl	r6, [pc, #-815]!	; fffffead <_bss_end+0xffff7c1d>
 1d8:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 1dc:	62754b2f 	rsbsvs	r4, r5, #48128	; 0xbc00
 1e0:	6f442f61 	svcvs	0x00442f61
 1e4:	656d7563 	strbvs	r7, [sp, #-1379]!	; 0xfffffa9d
 1e8:	2f73746e 	svccs	0x0073746e
 1ec:	6f72655a 	svcvs	0x0072655a
 1f0:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
 1f4:	6178652f 	cmnvs	r8, pc, lsr #10
 1f8:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
 1fc:	37312f73 			; <UNDEFINED> instruction: 0x37312f73
 200:	5550462d 	ldrbpl	r4, [r0, #-1581]	; 0xfffff9d3
 204:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 208:	2f6c656e 	svccs	0x006c656e
 20c:	00637273 	rsbeq	r7, r3, r3, ror r2
 210:	61747300 	cmnvs	r4, r0, lsl #6
 214:	70757472 	rsbsvc	r7, r5, r2, ror r4
 218:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
 21c:	00000100 	andeq	r0, r0, r0, lsl #2
 220:	00010500 	andeq	r0, r1, r0, lsl #10
 224:	81680205 	cmnhi	r8, r5, lsl #4
 228:	14030000 	strne	r0, [r3], #-0
 22c:	6a0c0501 	bvs	301638 <_bss_end+0x2f93a8>
 230:	02002205 	andeq	r2, r0, #1342177280	; 0x50000000
 234:	05660304 	strbeq	r0, [r6, #-772]!	; 0xfffffcfc
 238:	0402000c 	streq	r0, [r2], #-12
 23c:	0505bb02 	streq	fp, [r5, #-2818]	; 0xfffff4fe
 240:	02040200 	andeq	r0, r4, #0, 4
 244:	850c0565 	strhi	r0, [ip, #-1381]	; 0xfffffa9b
 248:	bd2f0105 	stflts	f0, [pc, #-20]!	; 23c <_start-0x7dc4>
 24c:	056b1005 	strbeq	r1, [fp, #-5]!
 250:	04020027 	streq	r0, [r2], #-39	; 0xffffffd9
 254:	0a054a03 	beq	152a68 <_bss_end+0x14a7d8>
 258:	02040200 	andeq	r0, r4, #0, 4
 25c:	00110583 	andseq	r0, r1, r3, lsl #11
 260:	4a020402 	bmi	81270 <_bss_end+0x78fe0>
 264:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
 268:	052d0204 	streq	r0, [sp, #-516]!	; 0xfffffdfc
 26c:	0105850c 	tsteq	r5, ip, lsl #10
 270:	1005a12f 	andne	sl, r5, pc, lsr #2
 274:	0027056a 	eoreq	r0, r7, sl, ror #10
 278:	4a030402 	bmi	c1288 <_bss_end+0xb8ff8>
 27c:	02000a05 	andeq	r0, r0, #20480	; 0x5000
 280:	05830204 	streq	r0, [r3, #516]	; 0x204
 284:	04020011 	streq	r0, [r2], #-17	; 0xffffffef
 288:	05054a02 	streq	r4, [r5, #-2562]	; 0xfffff5fe
 28c:	02040200 	andeq	r0, r4, #0, 4
 290:	850c052d 	strhi	r0, [ip, #-1325]	; 0xfffffad3
 294:	022f0105 	eoreq	r0, pc, #1073741825	; 0x40000001
 298:	0101000a 	tsteq	r1, sl
 29c:	000000a4 	andeq	r0, r0, r4, lsr #1
 2a0:	009e0003 	addseq	r0, lr, r3
 2a4:	01020000 	mrseq	r0, (UNDEF: 2)
 2a8:	000d0efb 	strdeq	r0, [sp], -fp
 2ac:	01010101 	tsteq	r1, r1, lsl #2
 2b0:	01000000 	mrseq	r0, (UNDEF: 0)
 2b4:	2e010000 	cdpcs	0, 0, cr0, cr1, cr0, {0}
 2b8:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 2bc:	2f2e2e2f 	svccs	0x002e2e2f
 2c0:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 2c4:	2f2e2f2e 	svccs	0x002e2f2e
 2c8:	00636367 	rsbeq	r6, r3, r7, ror #6
 2cc:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 2d0:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 2d4:	2f2e2e2f 	svccs	0x002e2e2f
 2d8:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 2dc:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
 2e0:	63636762 	cmnvs	r3, #25690112	; 0x1880000
 2e4:	2f2e2e2f 	svccs	0x002e2e2f
 2e8:	2f636367 	svccs	0x00636367
 2ec:	666e6f63 	strbtvs	r6, [lr], -r3, ror #30
 2f0:	612f6769 			; <UNDEFINED> instruction: 0x612f6769
 2f4:	2e006d72 	mcrcs	13, 0, r6, cr0, cr2, {3}
 2f8:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 2fc:	2f2e2e2f 	svccs	0x002e2e2f
 300:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 304:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 308:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
 30c:	00636367 	rsbeq	r6, r3, r7, ror #6
 310:	6d726100 	ldfvse	f6, [r2, #-0]
 314:	6173692d 	cmnvs	r3, sp, lsr #18
 318:	0100682e 	tsteq	r0, lr, lsr #16
 31c:	72610000 	rsbvc	r0, r1, #0
 320:	00682e6d 	rsbeq	r2, r8, sp, ror #28
 324:	67000002 	strvs	r0, [r0, -r2]
 328:	632d6c62 			; <UNDEFINED> instruction: 0x632d6c62
 32c:	73726f74 	cmnvc	r2, #116, 30	; 0x1d0
 330:	0300682e 	movweq	r6, #2094	; 0x82e
 334:	696c0000 	stmdbvs	ip!, {}^	; <UNPREDICTABLE>
 338:	63636762 	cmnvs	r3, #25690112	; 0x1880000
 33c:	00632e32 	rsbeq	r2, r3, r2, lsr lr
 340:	00000003 	andeq	r0, r0, r3

Disassembly of section .debug_str:

00000000 <.debug_str>:
   0:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
   4:	552f632f 	strpl	r6, [pc, #-815]!	; fffffcdd <_bss_end+0xffff7a4d>
   8:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
   c:	62754b2f 	rsbsvs	r4, r5, #48128	; 0xbc00
  10:	6f442f61 	svcvs	0x00442f61
  14:	656d7563 	strbvs	r7, [sp, #-1379]!	; 0xfffffa9d
  18:	2f73746e 	svccs	0x0073746e
  1c:	6f72655a 	svcvs	0x0072655a
  20:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
  24:	6178652f 	cmnvs	r8, pc, lsr #10
  28:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
  2c:	37312f73 			; <UNDEFINED> instruction: 0x37312f73
  30:	5550462d 	ldrbpl	r4, [r0, #-1581]	; 0xfffff9d3
  34:	6975622f 	ldmdbvs	r5!, {r0, r1, r2, r3, r5, r9, sp, lr}^
  38:	5f00646c 	svcpl	0x0000646c
  3c:	6178635f 	cmnvs	r8, pc, asr r3
  40:	6175675f 	cmnvs	r5, pc, asr r7
  44:	725f6472 	subsvc	r6, pc, #1912602624	; 0x72000000
  48:	61656c65 	cmnvs	r5, r5, ror #24
  4c:	5f006573 	svcpl	0x00006573
  50:	6178635f 	cmnvs	r8, pc, asr r3
  54:	6175675f 	cmnvs	r5, pc, asr r7
  58:	615f6472 	cmpvs	pc, r2, ror r4	; <UNPREDICTABLE>
  5c:	74726f62 	ldrbtvc	r6, [r2], #-3938	; 0xfffff09e
  60:	554e4700 	strbpl	r4, [lr, #-1792]	; 0xfffff900
  64:	2b2b4320 	blcs	ad0cec <_bss_end+0xac8a5c>
  68:	31203431 			; <UNDEFINED> instruction: 0x31203431
  6c:	2e332e30 	mrccs	14, 1, r2, cr3, cr0, {1}
  70:	30322031 	eorscc	r2, r2, r1, lsr r0
  74:	36303132 			; <UNDEFINED> instruction: 0x36303132
  78:	28203132 	stmdacs	r0!, {r1, r4, r5, r8, ip, sp}
  7c:	656c6572 	strbvs	r6, [ip, #-1394]!	; 0xfffffa8e
  80:	29657361 	stmdbcs	r5!, {r0, r5, r6, r8, r9, ip, sp, lr}^
  84:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
  88:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
  8c:	6962612d 	stmdbvs	r2!, {r0, r2, r3, r5, r8, sp, lr}^
  90:	7261683d 	rsbvc	r6, r1, #3997696	; 0x3d0000
  94:	6d2d2064 	stcvs	0, cr2, [sp, #-400]!	; 0xfffffe70
  98:	3d757066 	ldclcc	0, cr7, [r5, #-408]!	; 0xfffffe68
  9c:	20706676 	rsbscs	r6, r0, r6, ror r6
  a0:	6c666d2d 	stclvs	13, cr6, [r6], #-180	; 0xffffff4c
  a4:	2d74616f 	ldfcse	f6, [r4, #-444]!	; 0xfffffe44
  a8:	3d696261 	sfmcc	f6, 2, [r9, #-388]!	; 0xfffffe7c
  ac:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
  b0:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
  b4:	763d7570 			; <UNDEFINED> instruction: 0x763d7570
  b8:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
  bc:	6e75746d 	cdpvs	4, 7, cr7, cr5, cr13, {3}
  c0:	72613d65 	rsbvc	r3, r1, #6464	; 0x1940
  c4:	3731316d 	ldrcc	r3, [r1, -sp, ror #2]!
  c8:	667a6a36 			; <UNDEFINED> instruction: 0x667a6a36
  cc:	2d20732d 	stccs	3, cr7, [r0, #-180]!	; 0xffffff4c
  d0:	6d72616d 	ldfvse	f6, [r2, #-436]!	; 0xfffffe4c
  d4:	616d2d20 	cmnvs	sp, r0, lsr #26
  d8:	3d686372 	stclcc	3, cr6, [r8, #-456]!	; 0xfffffe38
  dc:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
  e0:	2b6b7a36 	blcs	1ade9c0 <_bss_end+0x1ad6730>
  e4:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
  e8:	672d2067 	strvs	r2, [sp, -r7, rrx]!
  ec:	304f2d20 	subcc	r2, pc, r0, lsr #26
  f0:	304f2d20 	subcc	r2, pc, r0, lsr #26
  f4:	6e662d20 	cdpvs	13, 6, cr2, cr6, cr0, {1}
  f8:	78652d6f 	stmdavc	r5!, {r0, r1, r2, r3, r5, r6, r8, sl, fp, sp}^
  fc:	74706563 	ldrbtvc	r6, [r0], #-1379	; 0xfffffa9d
 100:	736e6f69 	cmnvc	lr, #420	; 0x1a4
 104:	6e662d20 	cdpvs	13, 6, cr2, cr6, cr0, {1}
 108:	74722d6f 	ldrbtvc	r2, [r2], #-3439	; 0xfffff291
 10c:	2f006974 	svccs	0x00006974
 110:	2f746e6d 	svccs	0x00746e6d
 114:	73552f63 	cmpvc	r5, #396	; 0x18c
 118:	2f737265 	svccs	0x00737265
 11c:	6162754b 	cmnvs	r2, fp, asr #10
 120:	636f442f 	cmnvs	pc, #788529152	; 0x2f000000
 124:	6e656d75 	mcrvs	13, 3, r6, cr5, cr5, {3}
 128:	5a2f7374 	bpl	bdcf00 <_bss_end+0xbd4c70>
 12c:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; ffffffa0 <_bss_end+0xffff7d10>
 130:	2f657461 	svccs	0x00657461
 134:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
 138:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
 13c:	2d37312f 	ldfcss	f3, [r7, #-188]!	; 0xffffff44
 140:	2f555046 	svccs	0x00555046
 144:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 148:	732f6c65 			; <UNDEFINED> instruction: 0x732f6c65
 14c:	632f6372 			; <UNDEFINED> instruction: 0x632f6372
 150:	632e7878 			; <UNDEFINED> instruction: 0x632e7878
 154:	5f007070 	svcpl	0x00007070
 158:	6178635f 	cmnvs	r8, pc, asr r3
 15c:	6574615f 	ldrbvs	r6, [r4, #-351]!	; 0xfffffea1
 160:	00746978 	rsbseq	r6, r4, r8, ror r9
 164:	73645f5f 	cmnvc	r4, #380	; 0x17c
 168:	61685f6f 	cmnvs	r8, pc, ror #30
 16c:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
 170:	635f5f00 	cmpvs	pc, #0, 30
 174:	675f6178 			; <UNDEFINED> instruction: 0x675f6178
 178:	64726175 	ldrbtvs	r6, [r2], #-373	; 0xfffffe8b
 17c:	7163615f 	cmnvc	r3, pc, asr r1
 180:	65726975 	ldrbvs	r6, [r2, #-2421]!	; 0xfffff68b
 184:	635f5f00 	cmpvs	pc, #0, 30
 188:	62617878 	rsbvs	r7, r1, #120, 16	; 0x780000
 18c:	00317669 	eorseq	r7, r1, r9, ror #12
 190:	78635f5f 	stmdavc	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, sl, fp, ip, lr}^
 194:	75705f61 	ldrbvc	r5, [r0, #-3937]!	; 0xfffff09f
 198:	765f6572 			; <UNDEFINED> instruction: 0x765f6572
 19c:	75747269 	ldrbvc	r7, [r4, #-617]!	; 0xfffffd97
 1a0:	5f006c61 	svcpl	0x00006c61
 1a4:	6165615f 	cmnvs	r5, pc, asr r1
 1a8:	755f6962 	ldrbvc	r6, [pc, #-2402]	; fffff84e <_bss_end+0xffff75be>
 1ac:	6e69776e 	cdpvs	7, 6, cr7, cr9, cr14, {3}
 1b0:	70635f64 	rsbvc	r5, r3, r4, ror #30
 1b4:	72705f70 	rsbsvc	r5, r0, #112, 30	; 0x1c0
 1b8:	5f5f0031 	svcpl	0x005f0031
 1bc:	72617567 	rsbvc	r7, r1, #432013312	; 0x19c00000
 1c0:	6f6c0064 	svcvs	0x006c0064
 1c4:	6c20676e 	stcvs	7, cr6, [r0], #-440	; 0xfffffe48
 1c8:	20676e6f 	rsbcs	r6, r7, pc, ror #28
 1cc:	00746e69 	rsbseq	r6, r4, r9, ror #28
 1d0:	31325a5f 	teqcc	r2, pc, asr sl
 1d4:	72686146 	rsbvc	r6, r8, #-2147483631	; 0x80000011
 1d8:	65686e65 	strbvs	r6, [r8, #-3685]!	; 0xfffff19b
 1dc:	545f7469 	ldrbpl	r7, [pc], #-1129	; 1e4 <_start-0x7e1c>
 1e0:	65435f6f 	strbvs	r5, [r3, #-3951]	; 0xfffff091
 1e4:	7569736c 	strbvc	r7, [r9, #-876]!	; 0xfffffc94
 1e8:	46006673 			; <UNDEFINED> instruction: 0x46006673
 1ec:	65726861 	ldrbvs	r6, [r2, #-2145]!	; 0xfffff79f
 1f0:	6965686e 	stmdbvs	r5!, {r1, r2, r3, r5, r6, fp, sp, lr}^
 1f4:	6f545f74 	svcvs	0x00545f74
 1f8:	6c65435f 	stclvs	3, cr4, [r5], #-380	; 0xfffffe84
 1fc:	73756973 	cmnvc	r5, #1884160	; 0x1cc000
 200:	656b5f00 	strbvs	r5, [fp, #-3840]!	; 0xfffff100
 204:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
 208:	69616d5f 	stmdbvs	r1!, {r0, r1, r2, r3, r4, r6, r8, sl, fp, sp, lr}^
 20c:	6166006e 	cmnvs	r6, lr, rrx
 210:	6e657268 	cdpvs	2, 6, cr7, cr5, cr8, {3}
 214:	74696568 	strbtvc	r6, [r9], #-1384	; 0xfffffa98
 218:	6e6d2f00 	cdpvs	15, 6, cr2, cr13, cr0, {0}
 21c:	2f632f74 	svccs	0x00632f74
 220:	72657355 	rsbvc	r7, r5, #1409286145	; 0x54000001
 224:	754b2f73 	strbvc	r2, [fp, #-3955]	; 0xfffff08d
 228:	442f6162 	strtmi	r6, [pc], #-354	; 230 <_start-0x7dd0>
 22c:	6d75636f 	ldclvs	3, cr6, [r5, #-444]!	; 0xfffffe44
 230:	73746e65 	cmnvc	r4, #1616	; 0x650
 234:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
 238:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
 23c:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 240:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
 244:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
 248:	50462d37 	subpl	r2, r6, r7, lsr sp
 24c:	656b2f55 	strbvs	r2, [fp, #-3925]!	; 0xfffff0ab
 250:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
 254:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
 258:	69616d2f 	stmdbvs	r1!, {r0, r1, r2, r3, r5, r8, sl, fp, sp, lr}^
 25c:	70632e6e 	rsbvc	r2, r3, lr, ror #28
 260:	65630070 	strbvs	r0, [r3, #-112]!	; 0xffffff90
 264:	7569736c 	strbvc	r7, [r9, #-876]!	; 0xfffffc94
 268:	6d2f0073 	stcvs	0, cr0, [pc, #-460]!	; a4 <_start-0x7f5c>
 26c:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
 270:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
 274:	4b2f7372 	blmi	bdd044 <_bss_end+0xbd4db4>
 278:	2f616275 	svccs	0x00616275
 27c:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
 280:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
 284:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
 288:	614d6f72 	hvcvs	55026	; 0xd6f2
 28c:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffd20 <_bss_end+0xffff7a90>
 290:	706d6178 	rsbvc	r6, sp, r8, ror r1
 294:	2f73656c 	svccs	0x0073656c
 298:	462d3731 			; <UNDEFINED> instruction: 0x462d3731
 29c:	6b2f5550 	blvs	bd57e4 <_bss_end+0xbcd554>
 2a0:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 2a4:	72732f6c 	rsbsvc	r2, r3, #108, 30	; 0x1b0
 2a8:	74732f63 	ldrbtvc	r2, [r3], #-3939	; 0xfffff09d
 2ac:	2e747261 	cdpcs	2, 7, cr7, cr4, cr1, {3}
 2b0:	4e470073 	mcrmi	0, 2, r0, cr7, cr3, {3}
 2b4:	53412055 	movtpl	r2, #4181	; 0x1055
 2b8:	332e3220 			; <UNDEFINED> instruction: 0x332e3220
 2bc:	6d2f0038 	stcvs	0, cr0, [pc, #-224]!	; 1e4 <_start-0x7e1c>
 2c0:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
 2c4:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
 2c8:	4b2f7372 	blmi	bdd098 <_bss_end+0xbd4e08>
 2cc:	2f616275 	svccs	0x00616275
 2d0:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
 2d4:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
 2d8:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
 2dc:	614d6f72 	hvcvs	55026	; 0xd6f2
 2e0:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffd74 <_bss_end+0xffff7ae4>
 2e4:	706d6178 	rsbvc	r6, sp, r8, ror r1
 2e8:	2f73656c 	svccs	0x0073656c
 2ec:	462d3731 			; <UNDEFINED> instruction: 0x462d3731
 2f0:	6b2f5550 	blvs	bd5838 <_bss_end+0xbcd5a8>
 2f4:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 2f8:	72732f6c 	rsbsvc	r2, r3, #108, 30	; 0x1b0
 2fc:	74732f63 	ldrbtvc	r2, [r3], #-3939	; 0xfffff09d
 300:	75747261 	ldrbvc	r7, [r4, #-609]!	; 0xfffffd9f
 304:	70632e70 	rsbvc	r2, r3, r0, ror lr
 308:	625f0070 	subsvs	r0, pc, #112	; 0x70
 30c:	735f7373 	cmpvc	pc, #-872415231	; 0xcc000001
 310:	74726174 	ldrbtvc	r6, [r2], #-372	; 0xfffffe8c
 314:	435f5f00 	cmpmi	pc, #0, 30
 318:	5f524f54 	svcpl	0x00524f54
 31c:	5f444e45 	svcpl	0x00444e45
 320:	5f5f005f 	svcpl	0x005f005f
 324:	524f5443 	subpl	r5, pc, #1124073472	; 0x43000000
 328:	53494c5f 	movtpl	r4, #40031	; 0x9c5f
 32c:	005f5f54 	subseq	r5, pc, r4, asr pc	; <UNPREDICTABLE>
 330:	54445f5f 	strbpl	r5, [r4], #-3935	; 0xfffff0a1
 334:	455f524f 	ldrbmi	r5, [pc, #-591]	; ed <_start-0x7f13>
 338:	5f5f444e 	svcpl	0x005f444e
 33c:	70635f00 	rsbvc	r5, r3, r0, lsl #30
 340:	68735f70 	ldmdavs	r3!, {r4, r5, r6, r8, r9, sl, fp, ip, lr}^
 344:	6f647475 	svcvs	0x00647475
 348:	5f006e77 	svcpl	0x00006e77
 34c:	5f737362 	svcpl	0x00737362
 350:	00646e65 	rsbeq	r6, r4, r5, ror #28
 354:	54445f5f 	strbpl	r5, [r4], #-3935	; 0xfffff0a1
 358:	4c5f524f 	lfmmi	f5, 2, [pc], {79}	; 0x4f
 35c:	5f545349 	svcpl	0x00545349
 360:	7464005f 	strbtvc	r0, [r4], #-95	; 0xffffffa1
 364:	705f726f 	subsvc	r7, pc, pc, ror #4
 368:	63007274 	movwvs	r7, #628	; 0x274
 36c:	5f726f74 	svcpl	0x00726f74
 370:	00727470 	rsbseq	r7, r2, r0, ror r4
 374:	735f635f 	cmpvc	pc, #2080374785	; 0x7c000001
 378:	74726174 	ldrbtvc	r6, [r2], #-372	; 0xfffffe8c
 37c:	5f007075 	svcpl	0x00007075
 380:	5f707063 	svcpl	0x00707063
 384:	72617473 	rsbvc	r7, r1, #1929379840	; 0x73000000
 388:	00707574 	rsbseq	r7, r0, r4, ror r5
 38c:	74706e66 	ldrbtvc	r6, [r0], #-3686	; 0xfffff19a
 390:	73690072 	cmnvc	r9, #114	; 0x72
 394:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 398:	72705f74 	rsbsvc	r5, r0, #116, 30	; 0x1d0
 39c:	65726465 	ldrbvs	r6, [r2, #-1125]!	; 0xfffffb9b
 3a0:	73690073 	cmnvc	r9, #115	; 0x73
 3a4:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 3a8:	66765f74 	uhsub16vs	r5, r6, r4
 3ac:	61625f70 	smcvs	9712	; 0x25f0
 3b0:	63006573 	movwvs	r6, #1395	; 0x573
 3b4:	6c706d6f 	ldclvs	13, cr6, [r0], #-444	; 0xfffffe44
 3b8:	66207865 	strtvs	r7, [r0], -r5, ror #16
 3bc:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
 3c0:	61736900 	cmnvs	r3, r0, lsl #18
 3c4:	626f6e5f 	rsbvs	r6, pc, #1520	; 0x5f0
 3c8:	69007469 	stmdbvs	r0, {r0, r3, r5, r6, sl, ip, sp, lr}
 3cc:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 3d0:	6d5f7469 	cfldrdvs	mvd7, [pc, #-420]	; 234 <_start-0x7dcc>
 3d4:	665f6576 			; <UNDEFINED> instruction: 0x665f6576
 3d8:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
 3dc:	61736900 	cmnvs	r3, r0, lsl #18
 3e0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 3e4:	3170665f 	cmncc	r0, pc, asr r6
 3e8:	68730036 	ldmdavs	r3!, {r1, r2, r4, r5}^
 3ec:	2074726f 	rsbscs	r7, r4, pc, ror #4
 3f0:	00746e69 	rsbseq	r6, r4, r9, ror #28
 3f4:	5f617369 	svcpl	0x00617369
 3f8:	5f746962 	svcpl	0x00746962
 3fc:	00636573 	rsbeq	r6, r3, r3, ror r5
 400:	5f617369 	svcpl	0x00617369
 404:	5f746962 	svcpl	0x00746962
 408:	76696461 	strbtvc	r6, [r9], -r1, ror #8
 40c:	61736900 	cmnvs	r3, r0, lsl #18
 410:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 414:	6975715f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, r8, ip, sp, lr}^
 418:	6e5f6b72 	vmovvs.s8	r6, d15[3]
 41c:	6f765f6f 	svcvs	0x00765f6f
 420:	6974616c 	ldmdbvs	r4!, {r2, r3, r5, r6, r8, sp, lr}^
 424:	635f656c 	cmpvs	pc, #108, 10	; 0x1b000000
 428:	73690065 	cmnvc	r9, #101	; 0x65
 42c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 430:	706d5f74 	rsbvc	r5, sp, r4, ror pc
 434:	61736900 	cmnvs	r3, r0, lsl #18
 438:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 43c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
 440:	00743576 	rsbseq	r3, r4, r6, ror r5
 444:	5f617369 	svcpl	0x00617369
 448:	5f746962 	svcpl	0x00746962
 44c:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
 450:	00657435 	rsbeq	r7, r5, r5, lsr r4
 454:	5f617369 	svcpl	0x00617369
 458:	5f746962 	svcpl	0x00746962
 45c:	6e6f656e 	cdpvs	5, 6, cr6, cr15, cr14, {3}
 460:	61736900 	cmnvs	r3, r0, lsl #18
 464:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 468:	3166625f 	cmncc	r6, pc, asr r2
 46c:	50460036 	subpl	r0, r6, r6, lsr r0
 470:	5f524353 	svcpl	0x00524353
 474:	4d554e45 	ldclmi	14, cr4, [r5, #-276]	; 0xfffffeec
 478:	53504600 	cmppl	r0, #0, 12
 47c:	6e5f5243 	cdpvs	2, 5, cr5, cr15, cr3, {2}
 480:	7176637a 	cmnvc	r6, sl, ror r3
 484:	4e455f63 	cdpmi	15, 4, cr5, cr5, cr3, {3}
 488:	56004d55 			; <UNDEFINED> instruction: 0x56004d55
 48c:	455f5250 	ldrbmi	r5, [pc, #-592]	; 244 <_start-0x7dbc>
 490:	004d554e 	subeq	r5, sp, lr, asr #10
 494:	74696266 	strbtvc	r6, [r9], #-614	; 0xfffffd9a
 498:	706d695f 	rsbvc	r6, sp, pc, asr r9
 49c:	6163696c 	cmnvs	r3, ip, ror #18
 4a0:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
 4a4:	5f305000 	svcpl	0x00305000
 4a8:	4d554e45 	ldclmi	14, cr4, [r5, #-276]	; 0xfffffeec
 4ac:	61736900 	cmnvs	r3, r0, lsl #18
 4b0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 4b4:	7972635f 	ldmdbvc	r2!, {r0, r1, r2, r3, r4, r6, r8, r9, sp, lr}^
 4b8:	006f7470 	rsbeq	r7, pc, r0, ror r4	; <UNPREDICTABLE>
 4bc:	20554e47 	subscs	r4, r5, r7, asr #28
 4c0:	20373143 	eorscs	r3, r7, r3, asr #2
 4c4:	332e3031 			; <UNDEFINED> instruction: 0x332e3031
 4c8:	3220312e 	eorcc	r3, r0, #-2147483637	; 0x8000000b
 4cc:	30313230 	eorscc	r3, r1, r0, lsr r2
 4d0:	20313236 	eorscs	r3, r1, r6, lsr r2
 4d4:	6c657228 	sfmvs	f7, 2, [r5], #-160	; 0xffffff60
 4d8:	65736165 	ldrbvs	r6, [r3, #-357]!	; 0xfffffe9b
 4dc:	6d2d2029 	stcvs	0, cr2, [sp, #-164]!	; 0xffffff5c
 4e0:	206d7261 	rsbcs	r7, sp, r1, ror #4
 4e4:	6c666d2d 	stclvs	13, cr6, [r6], #-180	; 0xffffff4c
 4e8:	2d74616f 	ldfcse	f6, [r4, #-444]!	; 0xfffffe44
 4ec:	3d696261 	sfmcc	f6, 2, [r9, #-388]!	; 0xfffffe7c
 4f0:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
 4f4:	616d2d20 	cmnvs	sp, r0, lsr #26
 4f8:	3d686372 	stclcc	3, cr6, [r8, #-456]!	; 0xfffffe38
 4fc:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
 500:	2b657435 	blcs	195d5dc <_bss_end+0x195534c>
 504:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
 508:	672d2067 	strvs	r2, [sp, -r7, rrx]!
 50c:	20672d20 	rsbcs	r2, r7, r0, lsr #26
 510:	20324f2d 	eorscs	r4, r2, sp, lsr #30
 514:	20324f2d 	eorscs	r4, r2, sp, lsr #30
 518:	20324f2d 	eorscs	r4, r2, sp, lsr #30
 51c:	7562662d 	strbvc	r6, [r2, #-1581]!	; 0xfffff9d3
 520:	69646c69 	stmdbvs	r4!, {r0, r3, r5, r6, sl, fp, sp, lr}^
 524:	6c2d676e 	stcvs	7, cr6, [sp], #-440	; 0xfffffe48
 528:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
 52c:	662d2063 	strtvs	r2, [sp], -r3, rrx
 530:	732d6f6e 			; <UNDEFINED> instruction: 0x732d6f6e
 534:	6b636174 	blvs	18d8b0c <_bss_end+0x18d087c>
 538:	6f72702d 	svcvs	0x0072702d
 53c:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
 540:	2d20726f 	sfmcs	f7, 4, [r0, #-444]!	; 0xfffffe44
 544:	2d6f6e66 	stclcs	14, cr6, [pc, #-408]!	; 3b4 <_start-0x7c4c>
 548:	696c6e69 	stmdbvs	ip!, {r0, r3, r5, r6, r9, sl, fp, sp, lr}^
 54c:	2d20656e 	cfstr32cs	mvfx6, [r0, #-440]!	; 0xfffffe48
 550:	73697666 	cmnvc	r9, #106954752	; 0x6600000
 554:	6c696269 	sfmvs	f6, 2, [r9], #-420	; 0xfffffe5c
 558:	3d797469 	cfldrdcc	mvd7, [r9, #-420]!	; 0xfffffe5c
 55c:	64646968 	strbtvs	r6, [r4], #-2408	; 0xfffff698
 560:	69006e65 	stmdbvs	r0, {r0, r2, r5, r6, r9, sl, fp, sp, lr}
 564:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 568:	745f7469 	ldrbvc	r7, [pc], #-1129	; 570 <_start-0x7a90>
 56c:	00766964 	rsbseq	r6, r6, r4, ror #18
 570:	736e6f63 	cmnvc	lr, #396	; 0x18c
 574:	61736900 	cmnvs	r3, r0, lsl #18
 578:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 57c:	6d77695f 			; <UNDEFINED> instruction: 0x6d77695f
 580:	0074786d 	rsbseq	r7, r4, sp, ror #16
 584:	58435046 	stmdapl	r3, {r1, r2, r6, ip, lr}^
 588:	455f5354 	ldrbmi	r5, [pc, #-852]	; 23c <_start-0x7dc4>
 58c:	004d554e 	subeq	r5, sp, lr, asr #10
 590:	5f617369 	svcpl	0x00617369
 594:	5f746962 	svcpl	0x00746962
 598:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
 59c:	73690036 	cmnvc	r9, #54	; 0x36
 5a0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 5a4:	766d5f74 	uqsub16vc	r5, sp, r4
 5a8:	73690065 	cmnvc	r9, #101	; 0x65
 5ac:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 5b0:	77695f74 			; <UNDEFINED> instruction: 0x77695f74
 5b4:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
 5b8:	73690032 	cmnvc	r9, #50	; 0x32
 5bc:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 5c0:	64635f74 	strbtvs	r5, [r3], #-3956	; 0xfffff08c
 5c4:	30706365 	rsbscc	r6, r0, r5, ror #6
 5c8:	61736900 	cmnvs	r3, r0, lsl #18
 5cc:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 5d0:	6564635f 	strbvs	r6, [r4, #-863]!	; 0xfffffca1
 5d4:	00317063 	eorseq	r7, r1, r3, rrx
 5d8:	5f617369 	svcpl	0x00617369
 5dc:	5f746962 	svcpl	0x00746962
 5e0:	63656463 	cmnvs	r5, #1660944384	; 0x63000000
 5e4:	69003270 	stmdbvs	r0, {r4, r5, r6, r9, ip, sp}
 5e8:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 5ec:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
 5f0:	70636564 	rsbvc	r6, r3, r4, ror #10
 5f4:	73690033 	cmnvc	r9, #51	; 0x33
 5f8:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 5fc:	64635f74 	strbtvs	r5, [r3], #-3956	; 0xfffff08c
 600:	34706365 	ldrbtcc	r6, [r0], #-869	; 0xfffffc9b
 604:	61736900 	cmnvs	r3, r0, lsl #18
 608:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 60c:	5f70665f 	svcpl	0x0070665f
 610:	006c6264 	rsbeq	r6, ip, r4, ror #4
 614:	5f617369 	svcpl	0x00617369
 618:	5f746962 	svcpl	0x00746962
 61c:	63656463 	cmnvs	r5, #1660944384	; 0x63000000
 620:	69003670 	stmdbvs	r0, {r4, r5, r6, r9, sl, ip, sp}
 624:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 628:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
 62c:	70636564 	rsbvc	r6, r3, r4, ror #10
 630:	73690037 	cmnvc	r9, #55	; 0x37
 634:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 638:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
 63c:	6b36766d 	blvs	d9dff8 <_bss_end+0xd95d68>
 640:	61736900 	cmnvs	r3, r0, lsl #18
 644:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 648:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
 64c:	315f3876 	cmpcc	pc, r6, ror r8	; <UNPREDICTABLE>
 650:	616d5f6d 	cmnvs	sp, sp, ror #30
 654:	61006e69 	tstvs	r0, r9, ror #28
 658:	0065746e 	rsbeq	r7, r5, lr, ror #8
 65c:	5f617369 	svcpl	0x00617369
 660:	5f746962 	svcpl	0x00746962
 664:	65736d63 	ldrbvs	r6, [r3, #-3427]!	; 0xfffff29d
 668:	6e6f6c00 	cdpvs	12, 6, cr6, cr15, cr0, {0}
 66c:	6f642067 	svcvs	0x00642067
 670:	656c6275 	strbvs	r6, [ip, #-629]!	; 0xfffffd8b
 674:	2f2e2e00 	svccs	0x002e2e00
 678:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 67c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 680:	2f2e2e2f 	svccs	0x002e2e2f
 684:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 5d4 <_start-0x7a2c>
 688:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
 68c:	696c2f63 	stmdbvs	ip!, {r0, r1, r5, r6, r8, r9, sl, fp, sp}^
 690:	63636762 	cmnvs	r3, #25690112	; 0x1880000
 694:	00632e32 	rsbeq	r2, r3, r2, lsr lr
 698:	69736e75 	ldmdbvs	r3!, {r0, r2, r4, r5, r6, r9, sl, fp, sp, lr}^
 69c:	64656e67 	strbtvs	r6, [r5], #-3687	; 0xfffff199
 6a0:	61686320 	cmnvs	r8, r0, lsr #6
 6a4:	73690072 	cmnvc	r9, #114	; 0x72
 6a8:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 6ac:	70665f74 	rsbvc	r5, r6, r4, ror pc
 6b0:	69003576 	stmdbvs	r0, {r1, r2, r4, r5, r6, r8, sl, ip, sp}
 6b4:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 6b8:	785f7469 	ldmdavc	pc, {r0, r3, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
 6bc:	6c616373 	stclvs	3, cr6, [r1], #-460	; 0xfffffe34
 6c0:	6f6c0065 	svcvs	0x006c0065
 6c4:	6c20676e 	stcvs	7, cr6, [r0], #-440	; 0xfffffe48
 6c8:	20676e6f 	rsbcs	r6, r7, pc, ror #28
 6cc:	69736e75 	ldmdbvs	r3!, {r0, r2, r4, r5, r6, r9, sl, fp, sp, lr}^
 6d0:	64656e67 	strbtvs	r6, [r5], #-3687	; 0xfffff199
 6d4:	746e6920 	strbtvc	r6, [lr], #-2336	; 0xfffff6e0
 6d8:	61736900 	cmnvs	r3, r0, lsl #18
 6dc:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 6e0:	6975715f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, r8, ip, sp, lr}^
 6e4:	635f6b72 	cmpvs	pc, #116736	; 0x1c800
 6e8:	6c5f336d 	mrrcvs	3, 6, r3, pc, cr13	; <UNPREDICTABLE>
 6ec:	00647264 	rsbeq	r7, r4, r4, ror #4
 6f0:	5f617369 	svcpl	0x00617369
 6f4:	5f746962 	svcpl	0x00746962
 6f8:	6d6d3869 	stclvs	8, cr3, [sp, #-420]!	; 0xfffffe5c
 6fc:	6f687300 	svcvs	0x00687300
 700:	75207472 	strvc	r7, [r0, #-1138]!	; 0xfffffb8e
 704:	6769736e 	strbvs	r7, [r9, -lr, ror #6]!
 708:	2064656e 	rsbcs	r6, r4, lr, ror #10
 70c:	00746e69 	rsbseq	r6, r4, r9, ror #28
 710:	5f617369 	svcpl	0x00617369
 714:	5f746962 	svcpl	0x00746962
 718:	645f7066 	ldrbvs	r7, [pc], #-102	; 720 <_start-0x78e0>
 71c:	69003233 	stmdbvs	r0, {r0, r1, r4, r5, r9, ip, sp}
 720:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 724:	615f7469 	cmpvs	pc, r9, ror #8
 728:	37766d72 			; <UNDEFINED> instruction: 0x37766d72
 72c:	69006d65 	stmdbvs	r0, {r0, r2, r5, r6, r8, sl, fp, sp, lr}
 730:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 734:	6c5f7469 	cfldrdvs	mvd7, [pc], {105}	; 0x69
 738:	00656170 	rsbeq	r6, r5, r0, ror r1
 73c:	5f6c6c61 	svcpl	0x006c6c61
 740:	6c706d69 	ldclvs	13, cr6, [r0], #-420	; 0xfffffe5c
 744:	5f646569 	svcpl	0x00646569
 748:	74696266 	strbtvc	r6, [r9], #-614	; 0xfffffd9a
 74c:	73690073 	cmnvc	r9, #115	; 0x73
 750:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 754:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
 758:	5f38766d 	svcpl	0x0038766d
 75c:	73690031 	cmnvc	r9, #49	; 0x31
 760:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 764:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
 768:	5f38766d 	svcpl	0x0038766d
 76c:	73690032 	cmnvc	r9, #50	; 0x32
 770:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 774:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
 778:	5f38766d 	svcpl	0x0038766d
 77c:	73690033 	cmnvc	r9, #51	; 0x33
 780:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 784:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
 788:	5f38766d 	svcpl	0x0038766d
 78c:	73690034 	cmnvc	r9, #52	; 0x34
 790:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 794:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
 798:	5f38766d 	svcpl	0x0038766d
 79c:	73690035 	cmnvc	r9, #53	; 0x35
 7a0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 7a4:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
 7a8:	5f38766d 	svcpl	0x0038766d
 7ac:	73690036 	cmnvc	r9, #54	; 0x36
 7b0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 7b4:	62735f74 	rsbsvs	r5, r3, #116, 30	; 0x1d0
 7b8:	61736900 	cmnvs	r3, r0, lsl #18
 7bc:	6d756e5f 	ldclvs	14, cr6, [r5, #-380]!	; 0xfffffe84
 7c0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 7c4:	73690073 	cmnvc	r9, #115	; 0x73
 7c8:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 7cc:	6d735f74 	ldclvs	15, cr5, [r3, #-464]!	; 0xfffffe30
 7d0:	6d6c6c61 	stclvs	12, cr6, [ip, #-388]!	; 0xfffffe7c
 7d4:	2f006c75 	svccs	0x00006c75
 7d8:	6c697562 	cfstr64vs	mvdx7, [r9], #-392	; 0xfffffe78
 7dc:	63672f64 	cmnvs	r7, #100, 30	; 0x190
 7e0:	72612d63 	rsbvc	r2, r1, #6336	; 0x18c0
 7e4:	6f6e2d6d 	svcvs	0x006e2d6d
 7e8:	652d656e 	strvs	r6, [sp, #-1390]!	; 0xfffffa92
 7ec:	2d696261 	sfmcs	f6, 2, [r9, #-388]!	; 0xfffffe7c
 7f0:	67665968 	strbvs	r5, [r6, -r8, ror #18]!
 7f4:	672f344b 	strvs	r3, [pc, -fp, asr #8]!
 7f8:	612d6363 			; <UNDEFINED> instruction: 0x612d6363
 7fc:	6e2d6d72 	mcrvs	13, 1, r6, cr13, cr2, {3}
 800:	2d656e6f 	stclcs	14, cr6, [r5, #-444]!	; 0xfffffe44
 804:	69626165 	stmdbvs	r2!, {r0, r2, r5, r6, r8, sp, lr}^
 808:	2e30312d 	rsfcssp	f3, f0, #5.0
 80c:	30322d33 	eorscc	r2, r2, r3, lsr sp
 810:	302e3132 	eorcc	r3, lr, r2, lsr r1
 814:	75622f37 	strbvc	r2, [r2, #-3895]!	; 0xfffff0c9
 818:	2f646c69 	svccs	0x00646c69
 81c:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
 820:	656e6f6e 	strbvs	r6, [lr, #-3950]!	; 0xfffff092
 824:	6261652d 	rsbvs	r6, r1, #188743680	; 0xb400000
 828:	72612f69 	rsbvc	r2, r1, #420	; 0x1a4
 82c:	35762f6d 	ldrbcc	r2, [r6, #-3949]!	; 0xfffff093
 830:	682f6574 	stmdavs	pc!, {r2, r4, r5, r6, r8, sl, sp, lr}	; <UNPREDICTABLE>
 834:	2f647261 	svccs	0x00647261
 838:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
 83c:	66006363 	strvs	r6, [r0], -r3, ror #6
 840:	5f636e75 	svcpl	0x00636e75
 844:	00727470 	rsbseq	r7, r2, r0, ror r4
 848:	706d6f63 	rsbvc	r6, sp, r3, ror #30
 84c:	2078656c 	rsbscs	r6, r8, ip, ror #10
 850:	62756f64 	rsbsvs	r6, r5, #100, 30	; 0x190
 854:	4e00656c 	cfsh32mi	mvfx6, mvfx0, #60
 858:	50465f42 	subpl	r5, r6, r2, asr #30
 85c:	5359535f 	cmppl	r9, #2080374785	; 0x7c000001
 860:	53474552 	movtpl	r4, #30034	; 0x7552
 864:	61736900 	cmnvs	r3, r0, lsl #18
 868:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 86c:	6564635f 	strbvs	r6, [r4, #-863]!	; 0xfffffca1
 870:	00357063 	eorseq	r7, r5, r3, rrx
 874:	5f617369 	svcpl	0x00617369
 878:	5f746962 	svcpl	0x00746962
 87c:	76706676 			; <UNDEFINED> instruction: 0x76706676
 880:	73690032 	cmnvc	r9, #50	; 0x32
 884:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 888:	66765f74 	uhsub16vs	r5, r6, r4
 88c:	00337670 	eorseq	r7, r3, r0, ror r6
 890:	5f617369 	svcpl	0x00617369
 894:	5f746962 	svcpl	0x00746962
 898:	76706676 			; <UNDEFINED> instruction: 0x76706676
 89c:	50460034 	subpl	r0, r6, r4, lsr r0
 8a0:	4e545843 	cdpmi	8, 5, cr5, cr4, cr3, {2}
 8a4:	4e455f53 	mcrmi	15, 2, r5, cr5, cr3, {2}
 8a8:	69004d55 	stmdbvs	r0, {r0, r2, r4, r6, r8, sl, fp, lr}
 8ac:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 8b0:	745f7469 	ldrbvc	r7, [pc], #-1129	; 8b8 <_start-0x7748>
 8b4:	626d7568 	rsbvs	r7, sp, #104, 10	; 0x1a000000
 8b8:	61736900 	cmnvs	r3, r0, lsl #18
 8bc:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 8c0:	3170665f 	cmncc	r0, pc, asr r6
 8c4:	6e6f6336 	mcrvs	3, 3, r6, cr15, cr6, {1}
 8c8:	73690076 	cmnvc	r9, #118	; 0x76
 8cc:	65665f61 	strbvs	r5, [r6, #-3937]!	; 0xfffff09f
 8d0:	72757461 	rsbsvc	r7, r5, #1627389952	; 0x61000000
 8d4:	73690065 	cmnvc	r9, #101	; 0x65
 8d8:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 8dc:	6f6e5f74 	svcvs	0x006e5f74
 8e0:	69006d74 	stmdbvs	r0, {r2, r4, r5, r6, r8, sl, fp, sp, lr}
 8e4:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 8e8:	715f7469 	cmpvc	pc, r9, ror #8
 8ec:	6b726975 	blvs	1c9aec8 <_bss_end+0x1c92c38>
 8f0:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
 8f4:	7a6b3676 	bvc	1ace2d4 <_bss_end+0x1ac6044>
 8f8:	61736900 	cmnvs	r3, r0, lsl #18
 8fc:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 900:	6372635f 	cmnvs	r2, #2080374785	; 0x7c000001
 904:	69003233 	stmdbvs	r0, {r0, r1, r4, r5, r9, ip, sp}
 908:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 90c:	715f7469 	cmpvc	pc, r9, ror #8
 910:	6b726975 	blvs	1c9aeec <_bss_end+0x1c92c5c>
 914:	5f6f6e5f 	svcpl	0x006f6e5f
 918:	636d7361 	cmnvs	sp, #-2080374783	; 0x84000001
 91c:	69007570 	stmdbvs	r0, {r4, r5, r6, r8, sl, ip, sp, lr}
 920:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 924:	615f7469 	cmpvs	pc, r9, ror #8
 928:	34766d72 	ldrbtcc	r6, [r6], #-3442	; 0xfffff28e
 92c:	61736900 	cmnvs	r3, r0, lsl #18
 930:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 934:	7568745f 	strbvc	r7, [r8, #-1119]!	; 0xfffffba1
 938:	0032626d 	eorseq	r6, r2, sp, ror #4
 93c:	5f617369 	svcpl	0x00617369
 940:	5f746962 	svcpl	0x00746962
 944:	00386562 	eorseq	r6, r8, r2, ror #10
 948:	5f617369 	svcpl	0x00617369
 94c:	5f746962 	svcpl	0x00746962
 950:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
 954:	73690037 	cmnvc	r9, #55	; 0x37
 958:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 95c:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
 960:	0038766d 	eorseq	r7, r8, sp, ror #12
 964:	5f706676 	svcpl	0x00706676
 968:	72737973 	rsbsvc	r7, r3, #1884160	; 0x1cc000
 96c:	5f736765 	svcpl	0x00736765
 970:	6f636e65 	svcvs	0x00636e65
 974:	676e6964 	strbvs	r6, [lr, -r4, ror #18]!
 978:	61736900 	cmnvs	r3, r0, lsl #18
 97c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 980:	3170665f 	cmncc	r0, pc, asr r6
 984:	6c6d6636 	stclvs	6, cr6, [sp], #-216	; 0xffffff28
 988:	61736900 	cmnvs	r3, r0, lsl #18
 98c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 990:	746f645f 	strbtvc	r6, [pc], #-1119	; 998 <_start-0x7668>
 994:	646f7270 	strbtvs	r7, [pc], #-624	; 99c <_start-0x7664>
	...

Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347 	bcc	10d0d24 <_bss_end+0x10c8a94>
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
  10:	4b5a3605 	blmi	168d82c <_bss_end+0x168559c>
  14:	08070600 	stmdaeq	r7, {r9, sl}
  18:	0a010901 	beq	42424 <_bss_end+0x3a194>
  1c:	14041202 	strne	r1, [r4], #-514	; 0xfffffdfe
  20:	17011501 	strne	r1, [r1, -r1, lsl #10]
  24:	1a011803 	bne	46038 <_bss_end+0x3dda8>
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
  20:	8b040e42 	blhi	103930 <_bss_end+0xfb6a0>
  24:	0b0d4201 	bleq	350830 <_bss_end+0x3485a0>
  28:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
  2c:	00000ecb 	andeq	r0, r0, fp, asr #29
  30:	0000001c 	andeq	r0, r0, ip, lsl r0
  34:	00000000 	andeq	r0, r0, r0
  38:	00008050 	andeq	r8, r0, r0, asr r0
  3c:	0000002c 	andeq	r0, r0, ip, lsr #32
  40:	8b040e42 	blhi	103950 <_bss_end+0xfb6c0>
  44:	0b0d4201 	bleq	350850 <_bss_end+0x3485c0>
  48:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
  4c:	00000ecb 	andeq	r0, r0, fp, asr #29
  50:	0000001c 	andeq	r0, r0, ip, lsl r0
  54:	00000000 	andeq	r0, r0, r0
  58:	0000807c 	andeq	r8, r0, ip, ror r0
  5c:	00000020 	andeq	r0, r0, r0, lsr #32
  60:	8b040e42 	blhi	103970 <_bss_end+0xfb6e0>
  64:	0b0d4201 	bleq	350870 <_bss_end+0x3485e0>
  68:	420d0d48 	andmi	r0, sp, #72, 26	; 0x1200
  6c:	00000ecb 	andeq	r0, r0, fp, asr #29
  70:	0000001c 	andeq	r0, r0, ip, lsl r0
  74:	00000000 	andeq	r0, r0, r0
  78:	0000809c 	muleq	r0, ip, r0
  7c:	00000018 	andeq	r0, r0, r8, lsl r0
  80:	8b040e42 	blhi	103990 <_bss_end+0xfb700>
  84:	0b0d4201 	bleq	350890 <_bss_end+0x348600>
  88:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  8c:	00000ecb 	andeq	r0, r0, fp, asr #29
  90:	0000001c 	andeq	r0, r0, ip, lsl r0
  94:	00000000 	andeq	r0, r0, r0
  98:	000080b4 	strheq	r8, [r0], -r4
  9c:	00000018 	andeq	r0, r0, r8, lsl r0
  a0:	8b040e42 	blhi	1039b0 <_bss_end+0xfb720>
  a4:	0b0d4201 	bleq	3508b0 <_bss_end+0x348620>
  a8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  ac:	00000ecb 	andeq	r0, r0, fp, asr #29
  b0:	0000001c 	andeq	r0, r0, ip, lsl r0
  b4:	00000000 	andeq	r0, r0, r0
  b8:	000080cc 	andeq	r8, r0, ip, asr #1
  bc:	00000018 	andeq	r0, r0, r8, lsl r0
  c0:	8b040e42 	blhi	1039d0 <_bss_end+0xfb740>
  c4:	0b0d4201 	bleq	3508d0 <_bss_end+0x348640>
  c8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  cc:	00000ecb 	andeq	r0, r0, fp, asr #29
  d0:	00000014 	andeq	r0, r0, r4, lsl r0
  d4:	00000000 	andeq	r0, r0, r0
  d8:	000080e4 	andeq	r8, r0, r4, ror #1
  dc:	0000000c 	andeq	r0, r0, ip
  e0:	8b040e42 	blhi	1039f0 <_bss_end+0xfb760>
  e4:	0b0d4201 	bleq	3508f0 <_bss_end+0x348660>
  e8:	0000000c 	andeq	r0, r0, ip
  ec:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  f0:	7c020001 	stcvc	0, cr0, [r2], {1}
  f4:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  f8:	0000001c 	andeq	r0, r0, ip, lsl r0
  fc:	000000e8 	andeq	r0, r0, r8, ror #1
 100:	000080f0 	strdeq	r8, [r0], -r0
 104:	0000004c 	andeq	r0, r0, ip, asr #32
 108:	8b040e42 	blhi	103a18 <_bss_end+0xfb788>
 10c:	0b0d4201 	bleq	350918 <_bss_end+0x348688>
 110:	420d0d58 	andmi	r0, sp, #88, 26	; 0x1600
 114:	00000ecb 	andeq	r0, r0, fp, asr #29
 118:	00000018 	andeq	r0, r0, r8, lsl r0
 11c:	000000e8 	andeq	r0, r0, r8, ror #1
 120:	0000813c 	andeq	r8, r0, ip, lsr r1
 124:	0000002c 	andeq	r0, r0, ip, lsr #32
 128:	8b080e42 	blhi	203a38 <_bss_end+0x1fb7a8>
 12c:	42018e02 	andmi	r8, r1, #2, 28
 130:	00040b0c 	andeq	r0, r4, ip, lsl #22
 134:	0000000c 	andeq	r0, r0, ip
 138:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 13c:	7c020001 	stcvc	0, cr0, [r2], {1}
 140:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 144:	0000001c 	andeq	r0, r0, ip, lsl r0
 148:	00000134 	andeq	r0, r0, r4, lsr r1
 14c:	00008168 	andeq	r8, r0, r8, ror #2
 150:	00000068 	andeq	r0, r0, r8, rrx
 154:	8b040e42 	blhi	103a64 <_bss_end+0xfb7d4>
 158:	0b0d4201 	bleq	350964 <_bss_end+0x3486d4>
 15c:	420d0d68 	andmi	r0, sp, #104, 26	; 0x1a00
 160:	00000ecb 	andeq	r0, r0, fp, asr #29
 164:	0000001c 	andeq	r0, r0, ip, lsl r0
 168:	00000134 	andeq	r0, r0, r4, lsr r1
 16c:	000081d0 	ldrdeq	r8, [r0], -r0
 170:	00000058 	andeq	r0, r0, r8, asr r0
 174:	8b080e42 	blhi	203a84 <_bss_end+0x1fb7f4>
 178:	42018e02 	andmi	r8, r1, #2, 28
 17c:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 180:	00080d0c 	andeq	r0, r8, ip, lsl #26
 184:	0000001c 	andeq	r0, r0, ip, lsl r0
 188:	00000134 	andeq	r0, r0, r4, lsr r1
 18c:	00008228 	andeq	r8, r0, r8, lsr #4
 190:	00000058 	andeq	r0, r0, r8, asr r0
 194:	8b080e42 	blhi	203aa4 <_bss_end+0x1fb814>
 198:	42018e02 	andmi	r8, r1, #2, 28
 19c:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 1a0:	00080d0c 	andeq	r0, r8, ip, lsl #26
