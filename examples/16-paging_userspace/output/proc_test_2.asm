
./proc_test_2:     file format elf32-littlearm


Disassembly of section .text:

00008000 <_start>:
_start():
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/crt0.s:10
;@ startovaci symbol - vstupni bod z jadra OS do uzivatelskeho programu
;@ v podstate jen ihned zavola nejakou C funkci, nepotrebujeme nic tak kritickeho, abychom to vsechno museli psal v ASM
;@ jen _start vlastne ani neni funkce, takze by tento vstupni bod mel byt psany takto; rovnez je treba se ujistit, ze
;@ je tento symbol relokovany spravne na 0x8000 (tam OS ocekava, ze se nachazi vstupni bod)
_start:
    bl __crt0_run
    8000:	eb000017 	bl	8064 <__crt0_run>

00008004 <_hang>:
_hang():
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/crt0.s:13
    ;@ z funkce __crt0_run by se nemel proces uz vratit, ale kdyby neco, tak se zacyklime
_hang:
    b _hang
    8004:	eafffffe 	b	8004 <_hang>

00008008 <__crt0_init_bss>:
__crt0_init_bss():
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/crt0.c:10

extern unsigned int __bss_start;
extern unsigned int __bss_end;

void __crt0_init_bss()
{
    8008:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    800c:	e28db000 	add	fp, sp, #0
    8010:	e24dd00c 	sub	sp, sp, #12
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/crt0.c:11
    unsigned int* begin = (unsigned int*)&__bss_start;
    8014:	e59f3040 	ldr	r3, [pc, #64]	; 805c <__crt0_init_bss+0x54>
    8018:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/crt0.c:12
    for (; begin < (unsigned int*)&__bss_end; begin++)
    801c:	ea000005 	b	8038 <__crt0_init_bss+0x30>
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/crt0.c:13 (discriminator 2)
        *begin = 0;
    8020:	e51b3008 	ldr	r3, [fp, #-8]
    8024:	e3a02000 	mov	r2, #0
    8028:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/crt0.c:12 (discriminator 2)
    for (; begin < (unsigned int*)&__bss_end; begin++)
    802c:	e51b3008 	ldr	r3, [fp, #-8]
    8030:	e2833004 	add	r3, r3, #4
    8034:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/crt0.c:12 (discriminator 1)
    8038:	e51b3008 	ldr	r3, [fp, #-8]
    803c:	e59f201c 	ldr	r2, [pc, #28]	; 8060 <__crt0_init_bss+0x58>
    8040:	e1530002 	cmp	r3, r2
    8044:	3afffff5 	bcc	8020 <__crt0_init_bss+0x18>
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/crt0.c:14
}
    8048:	e320f000 	nop	{0}
    804c:	e320f000 	nop	{0}
    8050:	e28bd000 	add	sp, fp, #0
    8054:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8058:	e12fff1e 	bx	lr
    805c:	00008bf8 	strdeq	r8, [r0], -r8	; <UNPREDICTABLE>
    8060:	00008c08 	andeq	r8, r0, r8, lsl #24

00008064 <__crt0_run>:
__crt0_run():
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/crt0.c:17

void __crt0_run()
{
    8064:	e92d4800 	push	{fp, lr}
    8068:	e28db004 	add	fp, sp, #4
    806c:	e24dd008 	sub	sp, sp, #8
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/crt0.c:19
    // inicializace .bss sekce (vynulovani)
    __crt0_init_bss();
    8070:	ebffffe4 	bl	8008 <__crt0_init_bss>
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/crt0.c:22

    // volani konstruktoru globalnich trid (C++)
    _cpp_startup();
    8074:	eb000040 	bl	817c <_cpp_startup>
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/crt0.c:27

    // volani funkce main
    // nebudeme se zde zabyvat predavanim parametru do funkce main
    // jinak by se mohly predavat napr. namapovane do virtualniho adr. prostoru a odkazem pres zasobnik (kam nam muze OS pushnout co chce)
    int result = main(0, 0);
    8078:	e3a01000 	mov	r1, #0
    807c:	e3a00000 	mov	r0, #0
    8080:	eb000069 	bl	822c <main>
    8084:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/crt0.c:30

    // volani destruktoru globalnich trid (C++)
    _cpp_shutdown();
    8088:	eb000051 	bl	81d4 <_cpp_shutdown>
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/crt0.c:33

    // volani terminate() syscallu s navratovym kodem funkce main
    asm volatile("mov r0, %0" : : "r" (result));
    808c:	e51b3008 	ldr	r3, [fp, #-8]
    8090:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/crt0.c:34
    asm volatile("svc #1");
    8094:	ef000001 	svc	0x00000001
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/crt0.c:35
}
    8098:	e320f000 	nop	{0}
    809c:	e24bd004 	sub	sp, fp, #4
    80a0:	e8bd8800 	pop	{fp, pc}

000080a4 <__cxa_guard_acquire>:
__cxa_guard_acquire():
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/cxxabi.cpp:11
	extern "C" int __cxa_guard_acquire (__guard *);
	extern "C" void __cxa_guard_release (__guard *);
	extern "C" void __cxa_guard_abort (__guard *);

	extern "C" int __cxa_guard_acquire (__guard *g)
	{
    80a4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    80a8:	e28db000 	add	fp, sp, #0
    80ac:	e24dd00c 	sub	sp, sp, #12
    80b0:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/cxxabi.cpp:12
		return !*(char *)(g);
    80b4:	e51b3008 	ldr	r3, [fp, #-8]
    80b8:	e5d33000 	ldrb	r3, [r3]
    80bc:	e3530000 	cmp	r3, #0
    80c0:	03a03001 	moveq	r3, #1
    80c4:	13a03000 	movne	r3, #0
    80c8:	e6ef3073 	uxtb	r3, r3
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/cxxabi.cpp:13
	}
    80cc:	e1a00003 	mov	r0, r3
    80d0:	e28bd000 	add	sp, fp, #0
    80d4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    80d8:	e12fff1e 	bx	lr

000080dc <__cxa_guard_release>:
__cxa_guard_release():
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/cxxabi.cpp:16

	extern "C" void __cxa_guard_release (__guard *g)
	{
    80dc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    80e0:	e28db000 	add	fp, sp, #0
    80e4:	e24dd00c 	sub	sp, sp, #12
    80e8:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/cxxabi.cpp:17
		*(char *)g = 1;
    80ec:	e51b3008 	ldr	r3, [fp, #-8]
    80f0:	e3a02001 	mov	r2, #1
    80f4:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/cxxabi.cpp:18
	}
    80f8:	e320f000 	nop	{0}
    80fc:	e28bd000 	add	sp, fp, #0
    8100:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8104:	e12fff1e 	bx	lr

00008108 <__cxa_guard_abort>:
__cxa_guard_abort():
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/cxxabi.cpp:21

	extern "C" void __cxa_guard_abort (__guard *)
	{
    8108:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    810c:	e28db000 	add	fp, sp, #0
    8110:	e24dd00c 	sub	sp, sp, #12
    8114:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/cxxabi.cpp:23

	}
    8118:	e320f000 	nop	{0}
    811c:	e28bd000 	add	sp, fp, #0
    8120:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8124:	e12fff1e 	bx	lr

00008128 <__dso_handle>:
__dso_handle():
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/cxxabi.cpp:27
}

extern "C" void __dso_handle()
{
    8128:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    812c:	e28db000 	add	fp, sp, #0
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/cxxabi.cpp:29
    // ignore dtors for now
}
    8130:	e320f000 	nop	{0}
    8134:	e28bd000 	add	sp, fp, #0
    8138:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    813c:	e12fff1e 	bx	lr

00008140 <__cxa_atexit>:
__cxa_atexit():
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/cxxabi.cpp:32

extern "C" void __cxa_atexit()
{
    8140:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8144:	e28db000 	add	fp, sp, #0
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/cxxabi.cpp:34
    // ignore dtors for now
}
    8148:	e320f000 	nop	{0}
    814c:	e28bd000 	add	sp, fp, #0
    8150:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8154:	e12fff1e 	bx	lr

00008158 <__cxa_pure_virtual>:
__cxa_pure_virtual():
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/cxxabi.cpp:37

extern "C" void __cxa_pure_virtual()
{
    8158:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    815c:	e28db000 	add	fp, sp, #0
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/cxxabi.cpp:39
    // pure virtual method called
}
    8160:	e320f000 	nop	{0}
    8164:	e28bd000 	add	sp, fp, #0
    8168:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    816c:	e12fff1e 	bx	lr

00008170 <__aeabi_unwind_cpp_pr1>:
__aeabi_unwind_cpp_pr1():
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/cxxabi.cpp:42

extern "C" void __aeabi_unwind_cpp_pr1()
{
    8170:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8174:	e28db000 	add	fp, sp, #0
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/cxxabi.cpp:43 (discriminator 1)
	while (true)
    8178:	eafffffe 	b	8178 <__aeabi_unwind_cpp_pr1+0x8>

0000817c <_cpp_startup>:
_cpp_startup():
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/cxxabi.cpp:61
extern "C" dtor_ptr __DTOR_LIST__[0];
// konec pole destruktoru
extern "C" dtor_ptr __DTOR_END__[0];

extern "C" int _cpp_startup(void)
{
    817c:	e92d4800 	push	{fp, lr}
    8180:	e28db004 	add	fp, sp, #4
    8184:	e24dd008 	sub	sp, sp, #8
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/cxxabi.cpp:66
	ctor_ptr* fnptr;
	
	// zavolame konstruktory globalnich C++ trid
	// v poli __CTOR_LIST__ jsou ukazatele na vygenerovane stuby volani konstruktoru
	for (fnptr = __CTOR_LIST__; fnptr < __CTOR_END__; fnptr++)
    8188:	e59f303c 	ldr	r3, [pc, #60]	; 81cc <_cpp_startup+0x50>
    818c:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/cxxabi.cpp:66 (discriminator 3)
    8190:	e51b3008 	ldr	r3, [fp, #-8]
    8194:	e59f2034 	ldr	r2, [pc, #52]	; 81d0 <_cpp_startup+0x54>
    8198:	e1530002 	cmp	r3, r2
    819c:	2a000006 	bcs	81bc <_cpp_startup+0x40>
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/cxxabi.cpp:67 (discriminator 2)
		(*fnptr)();
    81a0:	e51b3008 	ldr	r3, [fp, #-8]
    81a4:	e5933000 	ldr	r3, [r3]
    81a8:	e12fff33 	blx	r3
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/cxxabi.cpp:66 (discriminator 2)
	for (fnptr = __CTOR_LIST__; fnptr < __CTOR_END__; fnptr++)
    81ac:	e51b3008 	ldr	r3, [fp, #-8]
    81b0:	e2833004 	add	r3, r3, #4
    81b4:	e50b3008 	str	r3, [fp, #-8]
    81b8:	eafffff4 	b	8190 <_cpp_startup+0x14>
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/cxxabi.cpp:69
	
	return 0;
    81bc:	e3a03000 	mov	r3, #0
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/cxxabi.cpp:70
}
    81c0:	e1a00003 	mov	r0, r3
    81c4:	e24bd004 	sub	sp, fp, #4
    81c8:	e8bd8800 	pop	{fp, pc}
    81cc:	00008bf5 	strdeq	r8, [r0], -r5
    81d0:	00008bf5 	strdeq	r8, [r0], -r5

000081d4 <_cpp_shutdown>:
_cpp_shutdown():
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/cxxabi.cpp:73

extern "C" int _cpp_shutdown(void)
{
    81d4:	e92d4800 	push	{fp, lr}
    81d8:	e28db004 	add	fp, sp, #4
    81dc:	e24dd008 	sub	sp, sp, #8
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/cxxabi.cpp:77
	dtor_ptr* fnptr;
	
	// zavolame destruktory globalnich C++ trid
	for (fnptr = __DTOR_LIST__; fnptr < __DTOR_END__; fnptr++)
    81e0:	e59f303c 	ldr	r3, [pc, #60]	; 8224 <_cpp_shutdown+0x50>
    81e4:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/cxxabi.cpp:77 (discriminator 3)
    81e8:	e51b3008 	ldr	r3, [fp, #-8]
    81ec:	e59f2034 	ldr	r2, [pc, #52]	; 8228 <_cpp_shutdown+0x54>
    81f0:	e1530002 	cmp	r3, r2
    81f4:	2a000006 	bcs	8214 <_cpp_shutdown+0x40>
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/cxxabi.cpp:78 (discriminator 2)
		(*fnptr)();
    81f8:	e51b3008 	ldr	r3, [fp, #-8]
    81fc:	e5933000 	ldr	r3, [r3]
    8200:	e12fff33 	blx	r3
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/cxxabi.cpp:77 (discriminator 2)
	for (fnptr = __DTOR_LIST__; fnptr < __DTOR_END__; fnptr++)
    8204:	e51b3008 	ldr	r3, [fp, #-8]
    8208:	e2833004 	add	r3, r3, #4
    820c:	e50b3008 	str	r3, [fp, #-8]
    8210:	eafffff4 	b	81e8 <_cpp_shutdown+0x14>
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/cxxabi.cpp:80
	
	return 0;
    8214:	e3a03000 	mov	r3, #0
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/cxxabi.cpp:81
}
    8218:	e1a00003 	mov	r0, r3
    821c:	e24bd004 	sub	sp, fp, #4
    8220:	e8bd8800 	pop	{fp, pc}
    8224:	00008bf5 	strdeq	r8, [r0], -r5
    8228:	00008bf5 	strdeq	r8, [r0], -r5

0000822c <main>:
main():
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/test_process_2/main.cpp:5
#include <stdstring.h>
#include <stdfile.h>

int main(int argc, char** argv)
{
    822c:	e92d4800 	push	{fp, lr}
    8230:	e28db004 	add	fp, sp, #4
    8234:	e24dd030 	sub	sp, sp, #48	; 0x30
    8238:	e50b0030 	str	r0, [fp, #-48]	; 0xffffffd0
    823c:	e50b1034 	str	r1, [fp, #-52]	; 0xffffffcc
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/test_process_2/main.cpp:8
	volatile int i;

    const char* msg = "Hello!\n";
    8240:	e59f30b0 	ldr	r3, [pc, #176]	; 82f8 <main+0xcc>
    8244:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/test_process_2/main.cpp:10

    uint32_t f = open("DEV:monitor/0", NFile_Open_Mode::Read_Write);
    8248:	e3a01002 	mov	r1, #2
    824c:	e59f00a8 	ldr	r0, [pc, #168]	; 82fc <main+0xd0>
    8250:	eb000048 	bl	8378 <_Z4openPKc15NFile_Open_Mode>
    8254:	e50b000c 	str	r0, [fp, #-12]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/test_process_2/main.cpp:11
    uint32_t rndf = open("DEV:trng", NFile_Open_Mode::Read_Only);
    8258:	e3a01000 	mov	r1, #0
    825c:	e59f009c 	ldr	r0, [pc, #156]	; 8300 <main+0xd4>
    8260:	eb000044 	bl	8378 <_Z4openPKc15NFile_Open_Mode>
    8264:	e50b0010 	str	r0, [fp, #-16]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/test_process_2/main.cpp:18
    uint32_t rdbuf;
    char numbuf[16];

    while (true)
    {
        read(rndf, reinterpret_cast<char*>(&rdbuf), 4);
    8268:	e24b3018 	sub	r3, fp, #24
    826c:	e3a02004 	mov	r2, #4
    8270:	e1a01003 	mov	r1, r3
    8274:	e51b0010 	ldr	r0, [fp, #-16]
    8278:	eb00004f 	bl	83bc <_Z4readjPcj>
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/test_process_2/main.cpp:20

        bzero(numbuf, 16);
    827c:	e24b3028 	sub	r3, fp, #40	; 0x28
    8280:	e3a01010 	mov	r1, #16
    8284:	e1a00003 	mov	r0, r3
    8288:	eb000186 	bl	88a8 <_Z5bzeroPvi>
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/test_process_2/main.cpp:21
        itoa(rdbuf, numbuf, 10);
    828c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8290:	e24b1028 	sub	r1, fp, #40	; 0x28
    8294:	e3a0200a 	mov	r2, #10
    8298:	e1a00003 	mov	r0, r3
    829c:	eb00008d 	bl	84d8 <_Z4itoajPcj>
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/test_process_2/main.cpp:23

        write(f, numbuf, strlen(numbuf));
    82a0:	e24b3028 	sub	r3, fp, #40	; 0x28
    82a4:	e1a00003 	mov	r0, r3
    82a8:	eb000169 	bl	8854 <_Z6strlenPKc>
    82ac:	e1a03000 	mov	r3, r0
    82b0:	e1a02003 	mov	r2, r3
    82b4:	e24b3028 	sub	r3, fp, #40	; 0x28
    82b8:	e1a01003 	mov	r1, r3
    82bc:	e51b000c 	ldr	r0, [fp, #-12]
    82c0:	eb000051 	bl	840c <_Z5writejPKcj>
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/test_process_2/main.cpp:25

        for (i = 0; i < 0x800; i++)
    82c4:	e3a03000 	mov	r3, #0
    82c8:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/test_process_2/main.cpp:25 (discriminator 3)
    82cc:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    82d0:	e3530b02 	cmp	r3, #2048	; 0x800
    82d4:	b3a03001 	movlt	r3, #1
    82d8:	a3a03000 	movge	r3, #0
    82dc:	e6ef3073 	uxtb	r3, r3
    82e0:	e3530000 	cmp	r3, #0
    82e4:	0affffdf 	beq	8268 <main+0x3c>
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/test_process_2/main.cpp:25 (discriminator 2)
    82e8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    82ec:	e2833001 	add	r3, r3, #1
    82f0:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
    82f4:	eafffff4 	b	82cc <main+0xa0>
    82f8:	00008bb0 			; <UNDEFINED> instruction: 0x00008bb0
    82fc:	00008bb8 			; <UNDEFINED> instruction: 0x00008bb8
    8300:	00008bc8 	andeq	r8, r0, r8, asr #23

00008304 <_Z6getpidv>:
_Z6getpidv():
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:4
#include <stdfile.h>

uint32_t getpid()
{
    8304:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8308:	e28db000 	add	fp, sp, #0
    830c:	e24dd00c 	sub	sp, sp, #12
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:7
    uint32_t pid;

    asm volatile("swi 0");
    8310:	ef000000 	svc	0x00000000
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:8
    asm volatile("mov %0, r0" : "=r" (pid));
    8314:	e1a03000 	mov	r3, r0
    8318:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:10

    return pid;
    831c:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:11
}
    8320:	e1a00003 	mov	r0, r3
    8324:	e28bd000 	add	sp, fp, #0
    8328:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    832c:	e12fff1e 	bx	lr

00008330 <_Z9terminatei>:
_Z9terminatei():
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:14

void terminate(int exitcode)
{
    8330:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8334:	e28db000 	add	fp, sp, #0
    8338:	e24dd00c 	sub	sp, sp, #12
    833c:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:15
    asm volatile("mov r0, %0" : : "r" (exitcode));
    8340:	e51b3008 	ldr	r3, [fp, #-8]
    8344:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:16
    asm volatile("swi 1");
    8348:	ef000001 	svc	0x00000001
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:17
}
    834c:	e320f000 	nop	{0}
    8350:	e28bd000 	add	sp, fp, #0
    8354:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8358:	e12fff1e 	bx	lr

0000835c <_Z11sched_yieldv>:
_Z11sched_yieldv():
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:20

void sched_yield()
{
    835c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8360:	e28db000 	add	fp, sp, #0
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:21
    asm volatile("swi 2");
    8364:	ef000002 	svc	0x00000002
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:22
}
    8368:	e320f000 	nop	{0}
    836c:	e28bd000 	add	sp, fp, #0
    8370:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8374:	e12fff1e 	bx	lr

00008378 <_Z4openPKc15NFile_Open_Mode>:
_Z4openPKc15NFile_Open_Mode():
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:25

uint32_t open(const char* filename, NFile_Open_Mode mode)
{
    8378:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    837c:	e28db000 	add	fp, sp, #0
    8380:	e24dd014 	sub	sp, sp, #20
    8384:	e50b0010 	str	r0, [fp, #-16]
    8388:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:28
    uint32_t file;

    asm volatile("mov r0, %0" : : "r" (filename));
    838c:	e51b3010 	ldr	r3, [fp, #-16]
    8390:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:29
    asm volatile("mov r1, %0" : : "r" (mode));
    8394:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8398:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:30
    asm volatile("swi 64");
    839c:	ef000040 	svc	0x00000040
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:31
    asm volatile("mov %0, r0" : "=r" (file));
    83a0:	e1a03000 	mov	r3, r0
    83a4:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:33

    return file;
    83a8:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:34
}
    83ac:	e1a00003 	mov	r0, r3
    83b0:	e28bd000 	add	sp, fp, #0
    83b4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    83b8:	e12fff1e 	bx	lr

000083bc <_Z4readjPcj>:
_Z4readjPcj():
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:37

uint32_t read(uint32_t file, char* const buffer, uint32_t size)
{
    83bc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    83c0:	e28db000 	add	fp, sp, #0
    83c4:	e24dd01c 	sub	sp, sp, #28
    83c8:	e50b0010 	str	r0, [fp, #-16]
    83cc:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    83d0:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:40
    uint32_t rdnum;

    asm volatile("mov r0, %0" : : "r" (file));
    83d4:	e51b3010 	ldr	r3, [fp, #-16]
    83d8:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:41
    asm volatile("mov r1, %0" : : "r" (buffer));
    83dc:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    83e0:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:42
    asm volatile("mov r2, %0" : : "r" (size));
    83e4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    83e8:	e1a02003 	mov	r2, r3
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:43
    asm volatile("swi 65");
    83ec:	ef000041 	svc	0x00000041
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:44
    asm volatile("mov %0, r0" : "=r" (rdnum));
    83f0:	e1a03000 	mov	r3, r0
    83f4:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:46

    return rdnum;
    83f8:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:47
}
    83fc:	e1a00003 	mov	r0, r3
    8400:	e28bd000 	add	sp, fp, #0
    8404:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8408:	e12fff1e 	bx	lr

0000840c <_Z5writejPKcj>:
_Z5writejPKcj():
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:50

uint32_t write(uint32_t file, const char* buffer, uint32_t size)
{
    840c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8410:	e28db000 	add	fp, sp, #0
    8414:	e24dd01c 	sub	sp, sp, #28
    8418:	e50b0010 	str	r0, [fp, #-16]
    841c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8420:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:53
    uint32_t wrnum;

    asm volatile("mov r0, %0" : : "r" (file));
    8424:	e51b3010 	ldr	r3, [fp, #-16]
    8428:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:54
    asm volatile("mov r1, %0" : : "r" (buffer));
    842c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8430:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:55
    asm volatile("mov r2, %0" : : "r" (size));
    8434:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8438:	e1a02003 	mov	r2, r3
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:56
    asm volatile("swi 66");
    843c:	ef000042 	svc	0x00000042
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:57
    asm volatile("mov %0, r0" : "=r" (wrnum));
    8440:	e1a03000 	mov	r3, r0
    8444:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:59

    return wrnum;
    8448:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:60
}
    844c:	e1a00003 	mov	r0, r3
    8450:	e28bd000 	add	sp, fp, #0
    8454:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8458:	e12fff1e 	bx	lr

0000845c <_Z5closej>:
_Z5closej():
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:63

void close(uint32_t file)
{
    845c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8460:	e28db000 	add	fp, sp, #0
    8464:	e24dd00c 	sub	sp, sp, #12
    8468:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:64
    asm volatile("mov r0, %0" : : "r" (file));
    846c:	e51b3008 	ldr	r3, [fp, #-8]
    8470:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:65
    asm volatile("swi 67");
    8474:	ef000043 	svc	0x00000043
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:66
}
    8478:	e320f000 	nop	{0}
    847c:	e28bd000 	add	sp, fp, #0
    8480:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8484:	e12fff1e 	bx	lr

00008488 <_Z5ioctlj16NIOCtl_OperationPv>:
_Z5ioctlj16NIOCtl_OperationPv():
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:69

uint32_t ioctl(uint32_t file, NIOCtl_Operation operation, void* param)
{
    8488:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    848c:	e28db000 	add	fp, sp, #0
    8490:	e24dd01c 	sub	sp, sp, #28
    8494:	e50b0010 	str	r0, [fp, #-16]
    8498:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    849c:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:72
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    84a0:	e51b3010 	ldr	r3, [fp, #-16]
    84a4:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:73
    asm volatile("mov r1, %0" : : "r" (operation));
    84a8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    84ac:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:74
    asm volatile("mov r2, %0" : : "r" (param));
    84b0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    84b4:	e1a02003 	mov	r2, r3
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:75
    asm volatile("swi 68");
    84b8:	ef000044 	svc	0x00000044
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:76
    asm volatile("mov %0, r0" : "=r" (retcode));
    84bc:	e1a03000 	mov	r3, r0
    84c0:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:78

    return retcode;
    84c4:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:79
}
    84c8:	e1a00003 	mov	r0, r3
    84cc:	e28bd000 	add	sp, fp, #0
    84d0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    84d4:	e12fff1e 	bx	lr

000084d8 <_Z4itoajPcj>:
_Z4itoajPcj():
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:9
{
    const char CharConvArr[] = "0123456789ABCDEF";
}

void itoa(unsigned int input, char* output, unsigned int base)
{
    84d8:	e92d4800 	push	{fp, lr}
    84dc:	e28db004 	add	fp, sp, #4
    84e0:	e24dd020 	sub	sp, sp, #32
    84e4:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    84e8:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    84ec:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:10
	int i = 0;
    84f0:	e3a03000 	mov	r3, #0
    84f4:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:12

	while (input > 0)
    84f8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    84fc:	e3530000 	cmp	r3, #0
    8500:	0a000014 	beq	8558 <_Z4itoajPcj+0x80>
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:14
	{
		output[i] = CharConvArr[input % base];
    8504:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8508:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    850c:	e1a00003 	mov	r0, r3
    8510:	eb000199 	bl	8b7c <__aeabi_uidivmod>
    8514:	e1a03001 	mov	r3, r1
    8518:	e1a01003 	mov	r1, r3
    851c:	e51b3008 	ldr	r3, [fp, #-8]
    8520:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8524:	e0823003 	add	r3, r2, r3
    8528:	e59f2118 	ldr	r2, [pc, #280]	; 8648 <_Z4itoajPcj+0x170>
    852c:	e7d22001 	ldrb	r2, [r2, r1]
    8530:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:15
		input /= base;
    8534:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    8538:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    853c:	eb000113 	bl	8990 <__udivsi3>
    8540:	e1a03000 	mov	r3, r0
    8544:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:16
		i++;
    8548:	e51b3008 	ldr	r3, [fp, #-8]
    854c:	e2833001 	add	r3, r3, #1
    8550:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:12
	while (input > 0)
    8554:	eaffffe7 	b	84f8 <_Z4itoajPcj+0x20>
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:19
	}

    if (i == 0)
    8558:	e51b3008 	ldr	r3, [fp, #-8]
    855c:	e3530000 	cmp	r3, #0
    8560:	1a000007 	bne	8584 <_Z4itoajPcj+0xac>
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:21
    {
        output[i] = CharConvArr[0];
    8564:	e51b3008 	ldr	r3, [fp, #-8]
    8568:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    856c:	e0823003 	add	r3, r2, r3
    8570:	e3a02030 	mov	r2, #48	; 0x30
    8574:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:22
        i++;
    8578:	e51b3008 	ldr	r3, [fp, #-8]
    857c:	e2833001 	add	r3, r3, #1
    8580:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:25
    }

	output[i] = '\0';
    8584:	e51b3008 	ldr	r3, [fp, #-8]
    8588:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    858c:	e0823003 	add	r3, r2, r3
    8590:	e3a02000 	mov	r2, #0
    8594:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:26
	i--;
    8598:	e51b3008 	ldr	r3, [fp, #-8]
    859c:	e2433001 	sub	r3, r3, #1
    85a0:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:28

	for (int j = 0; j <= i/2; j++)
    85a4:	e3a03000 	mov	r3, #0
    85a8:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:28 (discriminator 3)
    85ac:	e51b3008 	ldr	r3, [fp, #-8]
    85b0:	e1a02fa3 	lsr	r2, r3, #31
    85b4:	e0823003 	add	r3, r2, r3
    85b8:	e1a030c3 	asr	r3, r3, #1
    85bc:	e1a02003 	mov	r2, r3
    85c0:	e51b300c 	ldr	r3, [fp, #-12]
    85c4:	e1530002 	cmp	r3, r2
    85c8:	ca00001b 	bgt	863c <_Z4itoajPcj+0x164>
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:30 (discriminator 2)
	{
		char c = output[i - j];
    85cc:	e51b2008 	ldr	r2, [fp, #-8]
    85d0:	e51b300c 	ldr	r3, [fp, #-12]
    85d4:	e0423003 	sub	r3, r2, r3
    85d8:	e1a02003 	mov	r2, r3
    85dc:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    85e0:	e0833002 	add	r3, r3, r2
    85e4:	e5d33000 	ldrb	r3, [r3]
    85e8:	e54b300d 	strb	r3, [fp, #-13]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:31 (discriminator 2)
		output[i - j] = output[j];
    85ec:	e51b300c 	ldr	r3, [fp, #-12]
    85f0:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    85f4:	e0822003 	add	r2, r2, r3
    85f8:	e51b1008 	ldr	r1, [fp, #-8]
    85fc:	e51b300c 	ldr	r3, [fp, #-12]
    8600:	e0413003 	sub	r3, r1, r3
    8604:	e1a01003 	mov	r1, r3
    8608:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    860c:	e0833001 	add	r3, r3, r1
    8610:	e5d22000 	ldrb	r2, [r2]
    8614:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:32 (discriminator 2)
		output[j] = c;
    8618:	e51b300c 	ldr	r3, [fp, #-12]
    861c:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8620:	e0823003 	add	r3, r2, r3
    8624:	e55b200d 	ldrb	r2, [fp, #-13]
    8628:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:28 (discriminator 2)
	for (int j = 0; j <= i/2; j++)
    862c:	e51b300c 	ldr	r3, [fp, #-12]
    8630:	e2833001 	add	r3, r3, #1
    8634:	e50b300c 	str	r3, [fp, #-12]
    8638:	eaffffdb 	b	85ac <_Z4itoajPcj+0xd4>
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:34
	}
}
    863c:	e320f000 	nop	{0}
    8640:	e24bd004 	sub	sp, fp, #4
    8644:	e8bd8800 	pop	{fp, pc}
    8648:	00008be4 	andeq	r8, r0, r4, ror #23

0000864c <_Z4atoiPKc>:
_Z4atoiPKc():
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:37

int atoi(const char* input)
{
    864c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8650:	e28db000 	add	fp, sp, #0
    8654:	e24dd014 	sub	sp, sp, #20
    8658:	e50b0010 	str	r0, [fp, #-16]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:38
	int output = 0;
    865c:	e3a03000 	mov	r3, #0
    8660:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:40

	while (*input != '\0')
    8664:	e51b3010 	ldr	r3, [fp, #-16]
    8668:	e5d33000 	ldrb	r3, [r3]
    866c:	e3530000 	cmp	r3, #0
    8670:	0a000017 	beq	86d4 <_Z4atoiPKc+0x88>
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:42
	{
		output *= 10;
    8674:	e51b2008 	ldr	r2, [fp, #-8]
    8678:	e1a03002 	mov	r3, r2
    867c:	e1a03103 	lsl	r3, r3, #2
    8680:	e0833002 	add	r3, r3, r2
    8684:	e1a03083 	lsl	r3, r3, #1
    8688:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:43
		if (*input > '9' || *input < '0')
    868c:	e51b3010 	ldr	r3, [fp, #-16]
    8690:	e5d33000 	ldrb	r3, [r3]
    8694:	e3530039 	cmp	r3, #57	; 0x39
    8698:	8a00000d 	bhi	86d4 <_Z4atoiPKc+0x88>
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:43 (discriminator 1)
    869c:	e51b3010 	ldr	r3, [fp, #-16]
    86a0:	e5d33000 	ldrb	r3, [r3]
    86a4:	e353002f 	cmp	r3, #47	; 0x2f
    86a8:	9a000009 	bls	86d4 <_Z4atoiPKc+0x88>
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:46
			break;

		output += *input - '0';
    86ac:	e51b3010 	ldr	r3, [fp, #-16]
    86b0:	e5d33000 	ldrb	r3, [r3]
    86b4:	e2433030 	sub	r3, r3, #48	; 0x30
    86b8:	e51b2008 	ldr	r2, [fp, #-8]
    86bc:	e0823003 	add	r3, r2, r3
    86c0:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:48

		input++;
    86c4:	e51b3010 	ldr	r3, [fp, #-16]
    86c8:	e2833001 	add	r3, r3, #1
    86cc:	e50b3010 	str	r3, [fp, #-16]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:40
	while (*input != '\0')
    86d0:	eaffffe3 	b	8664 <_Z4atoiPKc+0x18>
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:51
	}

	return output;
    86d4:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:52
}
    86d8:	e1a00003 	mov	r0, r3
    86dc:	e28bd000 	add	sp, fp, #0
    86e0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    86e4:	e12fff1e 	bx	lr

000086e8 <_Z7strncpyPcPKci>:
_Z7strncpyPcPKci():
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:55

char* strncpy(char* dest, const char *src, int num)
{
    86e8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    86ec:	e28db000 	add	fp, sp, #0
    86f0:	e24dd01c 	sub	sp, sp, #28
    86f4:	e50b0010 	str	r0, [fp, #-16]
    86f8:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    86fc:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:58
	int i;

	for (i = 0; i < num && src[i] != '\0'; i++)
    8700:	e3a03000 	mov	r3, #0
    8704:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:58 (discriminator 4)
    8708:	e51b2008 	ldr	r2, [fp, #-8]
    870c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8710:	e1520003 	cmp	r2, r3
    8714:	aa000011 	bge	8760 <_Z7strncpyPcPKci+0x78>
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:58 (discriminator 2)
    8718:	e51b3008 	ldr	r3, [fp, #-8]
    871c:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8720:	e0823003 	add	r3, r2, r3
    8724:	e5d33000 	ldrb	r3, [r3]
    8728:	e3530000 	cmp	r3, #0
    872c:	0a00000b 	beq	8760 <_Z7strncpyPcPKci+0x78>
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:59 (discriminator 3)
		dest[i] = src[i];
    8730:	e51b3008 	ldr	r3, [fp, #-8]
    8734:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8738:	e0822003 	add	r2, r2, r3
    873c:	e51b3008 	ldr	r3, [fp, #-8]
    8740:	e51b1010 	ldr	r1, [fp, #-16]
    8744:	e0813003 	add	r3, r1, r3
    8748:	e5d22000 	ldrb	r2, [r2]
    874c:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:58 (discriminator 3)
	for (i = 0; i < num && src[i] != '\0'; i++)
    8750:	e51b3008 	ldr	r3, [fp, #-8]
    8754:	e2833001 	add	r3, r3, #1
    8758:	e50b3008 	str	r3, [fp, #-8]
    875c:	eaffffe9 	b	8708 <_Z7strncpyPcPKci+0x20>
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:60 (discriminator 2)
	for (; i < num; i++)
    8760:	e51b2008 	ldr	r2, [fp, #-8]
    8764:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8768:	e1520003 	cmp	r2, r3
    876c:	aa000008 	bge	8794 <_Z7strncpyPcPKci+0xac>
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:61 (discriminator 1)
		dest[i] = '\0';
    8770:	e51b3008 	ldr	r3, [fp, #-8]
    8774:	e51b2010 	ldr	r2, [fp, #-16]
    8778:	e0823003 	add	r3, r2, r3
    877c:	e3a02000 	mov	r2, #0
    8780:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:60 (discriminator 1)
	for (; i < num; i++)
    8784:	e51b3008 	ldr	r3, [fp, #-8]
    8788:	e2833001 	add	r3, r3, #1
    878c:	e50b3008 	str	r3, [fp, #-8]
    8790:	eafffff2 	b	8760 <_Z7strncpyPcPKci+0x78>
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:63

   return dest;
    8794:	e51b3010 	ldr	r3, [fp, #-16]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:64
}
    8798:	e1a00003 	mov	r0, r3
    879c:	e28bd000 	add	sp, fp, #0
    87a0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    87a4:	e12fff1e 	bx	lr

000087a8 <_Z7strncmpPKcS0_i>:
_Z7strncmpPKcS0_i():
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:67

int strncmp(const char *s1, const char *s2, int num)
{
    87a8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    87ac:	e28db000 	add	fp, sp, #0
    87b0:	e24dd01c 	sub	sp, sp, #28
    87b4:	e50b0010 	str	r0, [fp, #-16]
    87b8:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    87bc:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:69
	unsigned char u1, u2;
  	while (num-- > 0)
    87c0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    87c4:	e2432001 	sub	r2, r3, #1
    87c8:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
    87cc:	e3530000 	cmp	r3, #0
    87d0:	c3a03001 	movgt	r3, #1
    87d4:	d3a03000 	movle	r3, #0
    87d8:	e6ef3073 	uxtb	r3, r3
    87dc:	e3530000 	cmp	r3, #0
    87e0:	0a000016 	beq	8840 <_Z7strncmpPKcS0_i+0x98>
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:71
    {
      	u1 = (unsigned char) *s1++;
    87e4:	e51b3010 	ldr	r3, [fp, #-16]
    87e8:	e2832001 	add	r2, r3, #1
    87ec:	e50b2010 	str	r2, [fp, #-16]
    87f0:	e5d33000 	ldrb	r3, [r3]
    87f4:	e54b3005 	strb	r3, [fp, #-5]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:72
     	u2 = (unsigned char) *s2++;
    87f8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    87fc:	e2832001 	add	r2, r3, #1
    8800:	e50b2014 	str	r2, [fp, #-20]	; 0xffffffec
    8804:	e5d33000 	ldrb	r3, [r3]
    8808:	e54b3006 	strb	r3, [fp, #-6]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:73
      	if (u1 != u2)
    880c:	e55b2005 	ldrb	r2, [fp, #-5]
    8810:	e55b3006 	ldrb	r3, [fp, #-6]
    8814:	e1520003 	cmp	r2, r3
    8818:	0a000003 	beq	882c <_Z7strncmpPKcS0_i+0x84>
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:74
        	return u1 - u2;
    881c:	e55b2005 	ldrb	r2, [fp, #-5]
    8820:	e55b3006 	ldrb	r3, [fp, #-6]
    8824:	e0423003 	sub	r3, r2, r3
    8828:	ea000005 	b	8844 <_Z7strncmpPKcS0_i+0x9c>
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:75
      	if (u1 == '\0')
    882c:	e55b3005 	ldrb	r3, [fp, #-5]
    8830:	e3530000 	cmp	r3, #0
    8834:	1affffe1 	bne	87c0 <_Z7strncmpPKcS0_i+0x18>
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:76
        	return 0;
    8838:	e3a03000 	mov	r3, #0
    883c:	ea000000 	b	8844 <_Z7strncmpPKcS0_i+0x9c>
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:79
    }

  	return 0;
    8840:	e3a03000 	mov	r3, #0
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:80
}
    8844:	e1a00003 	mov	r0, r3
    8848:	e28bd000 	add	sp, fp, #0
    884c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8850:	e12fff1e 	bx	lr

00008854 <_Z6strlenPKc>:
_Z6strlenPKc():
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:83

int strlen(const char* s)
{
    8854:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8858:	e28db000 	add	fp, sp, #0
    885c:	e24dd014 	sub	sp, sp, #20
    8860:	e50b0010 	str	r0, [fp, #-16]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:84
	int i = 0;
    8864:	e3a03000 	mov	r3, #0
    8868:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:86

	while (s[i] != '\0')
    886c:	e51b3008 	ldr	r3, [fp, #-8]
    8870:	e51b2010 	ldr	r2, [fp, #-16]
    8874:	e0823003 	add	r3, r2, r3
    8878:	e5d33000 	ldrb	r3, [r3]
    887c:	e3530000 	cmp	r3, #0
    8880:	0a000003 	beq	8894 <_Z6strlenPKc+0x40>
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:87
		i++;
    8884:	e51b3008 	ldr	r3, [fp, #-8]
    8888:	e2833001 	add	r3, r3, #1
    888c:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:86
	while (s[i] != '\0')
    8890:	eafffff5 	b	886c <_Z6strlenPKc+0x18>
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:89

	return i;
    8894:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:90
}
    8898:	e1a00003 	mov	r0, r3
    889c:	e28bd000 	add	sp, fp, #0
    88a0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    88a4:	e12fff1e 	bx	lr

000088a8 <_Z5bzeroPvi>:
_Z5bzeroPvi():
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:93

void bzero(void* memory, int length)
{
    88a8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    88ac:	e28db000 	add	fp, sp, #0
    88b0:	e24dd014 	sub	sp, sp, #20
    88b4:	e50b0010 	str	r0, [fp, #-16]
    88b8:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:94
	char* mem = reinterpret_cast<char*>(memory);
    88bc:	e51b3010 	ldr	r3, [fp, #-16]
    88c0:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:96

	for (int i = 0; i < length; i++)
    88c4:	e3a03000 	mov	r3, #0
    88c8:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:96 (discriminator 3)
    88cc:	e51b2008 	ldr	r2, [fp, #-8]
    88d0:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    88d4:	e1520003 	cmp	r2, r3
    88d8:	aa000008 	bge	8900 <_Z5bzeroPvi+0x58>
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:97 (discriminator 2)
		mem[i] = 0;
    88dc:	e51b3008 	ldr	r3, [fp, #-8]
    88e0:	e51b200c 	ldr	r2, [fp, #-12]
    88e4:	e0823003 	add	r3, r2, r3
    88e8:	e3a02000 	mov	r2, #0
    88ec:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:96 (discriminator 2)
	for (int i = 0; i < length; i++)
    88f0:	e51b3008 	ldr	r3, [fp, #-8]
    88f4:	e2833001 	add	r3, r3, #1
    88f8:	e50b3008 	str	r3, [fp, #-8]
    88fc:	eafffff2 	b	88cc <_Z5bzeroPvi+0x24>
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:98
}
    8900:	e320f000 	nop	{0}
    8904:	e28bd000 	add	sp, fp, #0
    8908:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    890c:	e12fff1e 	bx	lr

00008910 <_Z6memcpyPKvPvi>:
_Z6memcpyPKvPvi():
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:101

void memcpy(const void* src, void* dst, int num)
{
    8910:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8914:	e28db000 	add	fp, sp, #0
    8918:	e24dd024 	sub	sp, sp, #36	; 0x24
    891c:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8920:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    8924:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:102
	const char* memsrc = reinterpret_cast<const char*>(src);
    8928:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    892c:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:103
	char* memdst = reinterpret_cast<char*>(dst);
    8930:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8934:	e50b3010 	str	r3, [fp, #-16]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:105

	for (int i = 0; i < num; i++)
    8938:	e3a03000 	mov	r3, #0
    893c:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:105 (discriminator 3)
    8940:	e51b2008 	ldr	r2, [fp, #-8]
    8944:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8948:	e1520003 	cmp	r2, r3
    894c:	aa00000b 	bge	8980 <_Z6memcpyPKvPvi+0x70>
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:106 (discriminator 2)
		memdst[i] = memsrc[i];
    8950:	e51b3008 	ldr	r3, [fp, #-8]
    8954:	e51b200c 	ldr	r2, [fp, #-12]
    8958:	e0822003 	add	r2, r2, r3
    895c:	e51b3008 	ldr	r3, [fp, #-8]
    8960:	e51b1010 	ldr	r1, [fp, #-16]
    8964:	e0813003 	add	r3, r1, r3
    8968:	e5d22000 	ldrb	r2, [r2]
    896c:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:105 (discriminator 2)
	for (int i = 0; i < num; i++)
    8970:	e51b3008 	ldr	r3, [fp, #-8]
    8974:	e2833001 	add	r3, r3, #1
    8978:	e50b3008 	str	r3, [fp, #-8]
    897c:	eaffffef 	b	8940 <_Z6memcpyPKvPvi+0x30>
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdstring.cpp:107
}
    8980:	e320f000 	nop	{0}
    8984:	e28bd000 	add	sp, fp, #0
    8988:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    898c:	e12fff1e 	bx	lr

00008990 <__udivsi3>:
__udivsi3():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1104
    8990:	e2512001 	subs	r2, r1, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1106
    8994:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1107
    8998:	3a000074 	bcc	8b70 <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1108
    899c:	e1500001 	cmp	r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1109
    89a0:	9a00006b 	bls	8b54 <__udivsi3+0x1c4>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1110
    89a4:	e1110002 	tst	r1, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1111
    89a8:	0a00006c 	beq	8b60 <__udivsi3+0x1d0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1113
    89ac:	e16f3f10 	clz	r3, r0
    89b0:	e16f2f11 	clz	r2, r1
    89b4:	e0423003 	sub	r3, r2, r3
    89b8:	e273301f 	rsbs	r3, r3, #31
    89bc:	10833083 	addne	r3, r3, r3, lsl #1
    89c0:	e3a02000 	mov	r2, #0
    89c4:	108ff103 	addne	pc, pc, r3, lsl #2
    89c8:	e1a00000 	nop			; (mov r0, r0)
    89cc:	e1500f81 	cmp	r0, r1, lsl #31
    89d0:	e0a22002 	adc	r2, r2, r2
    89d4:	20400f81 	subcs	r0, r0, r1, lsl #31
    89d8:	e1500f01 	cmp	r0, r1, lsl #30
    89dc:	e0a22002 	adc	r2, r2, r2
    89e0:	20400f01 	subcs	r0, r0, r1, lsl #30
    89e4:	e1500e81 	cmp	r0, r1, lsl #29
    89e8:	e0a22002 	adc	r2, r2, r2
    89ec:	20400e81 	subcs	r0, r0, r1, lsl #29
    89f0:	e1500e01 	cmp	r0, r1, lsl #28
    89f4:	e0a22002 	adc	r2, r2, r2
    89f8:	20400e01 	subcs	r0, r0, r1, lsl #28
    89fc:	e1500d81 	cmp	r0, r1, lsl #27
    8a00:	e0a22002 	adc	r2, r2, r2
    8a04:	20400d81 	subcs	r0, r0, r1, lsl #27
    8a08:	e1500d01 	cmp	r0, r1, lsl #26
    8a0c:	e0a22002 	adc	r2, r2, r2
    8a10:	20400d01 	subcs	r0, r0, r1, lsl #26
    8a14:	e1500c81 	cmp	r0, r1, lsl #25
    8a18:	e0a22002 	adc	r2, r2, r2
    8a1c:	20400c81 	subcs	r0, r0, r1, lsl #25
    8a20:	e1500c01 	cmp	r0, r1, lsl #24
    8a24:	e0a22002 	adc	r2, r2, r2
    8a28:	20400c01 	subcs	r0, r0, r1, lsl #24
    8a2c:	e1500b81 	cmp	r0, r1, lsl #23
    8a30:	e0a22002 	adc	r2, r2, r2
    8a34:	20400b81 	subcs	r0, r0, r1, lsl #23
    8a38:	e1500b01 	cmp	r0, r1, lsl #22
    8a3c:	e0a22002 	adc	r2, r2, r2
    8a40:	20400b01 	subcs	r0, r0, r1, lsl #22
    8a44:	e1500a81 	cmp	r0, r1, lsl #21
    8a48:	e0a22002 	adc	r2, r2, r2
    8a4c:	20400a81 	subcs	r0, r0, r1, lsl #21
    8a50:	e1500a01 	cmp	r0, r1, lsl #20
    8a54:	e0a22002 	adc	r2, r2, r2
    8a58:	20400a01 	subcs	r0, r0, r1, lsl #20
    8a5c:	e1500981 	cmp	r0, r1, lsl #19
    8a60:	e0a22002 	adc	r2, r2, r2
    8a64:	20400981 	subcs	r0, r0, r1, lsl #19
    8a68:	e1500901 	cmp	r0, r1, lsl #18
    8a6c:	e0a22002 	adc	r2, r2, r2
    8a70:	20400901 	subcs	r0, r0, r1, lsl #18
    8a74:	e1500881 	cmp	r0, r1, lsl #17
    8a78:	e0a22002 	adc	r2, r2, r2
    8a7c:	20400881 	subcs	r0, r0, r1, lsl #17
    8a80:	e1500801 	cmp	r0, r1, lsl #16
    8a84:	e0a22002 	adc	r2, r2, r2
    8a88:	20400801 	subcs	r0, r0, r1, lsl #16
    8a8c:	e1500781 	cmp	r0, r1, lsl #15
    8a90:	e0a22002 	adc	r2, r2, r2
    8a94:	20400781 	subcs	r0, r0, r1, lsl #15
    8a98:	e1500701 	cmp	r0, r1, lsl #14
    8a9c:	e0a22002 	adc	r2, r2, r2
    8aa0:	20400701 	subcs	r0, r0, r1, lsl #14
    8aa4:	e1500681 	cmp	r0, r1, lsl #13
    8aa8:	e0a22002 	adc	r2, r2, r2
    8aac:	20400681 	subcs	r0, r0, r1, lsl #13
    8ab0:	e1500601 	cmp	r0, r1, lsl #12
    8ab4:	e0a22002 	adc	r2, r2, r2
    8ab8:	20400601 	subcs	r0, r0, r1, lsl #12
    8abc:	e1500581 	cmp	r0, r1, lsl #11
    8ac0:	e0a22002 	adc	r2, r2, r2
    8ac4:	20400581 	subcs	r0, r0, r1, lsl #11
    8ac8:	e1500501 	cmp	r0, r1, lsl #10
    8acc:	e0a22002 	adc	r2, r2, r2
    8ad0:	20400501 	subcs	r0, r0, r1, lsl #10
    8ad4:	e1500481 	cmp	r0, r1, lsl #9
    8ad8:	e0a22002 	adc	r2, r2, r2
    8adc:	20400481 	subcs	r0, r0, r1, lsl #9
    8ae0:	e1500401 	cmp	r0, r1, lsl #8
    8ae4:	e0a22002 	adc	r2, r2, r2
    8ae8:	20400401 	subcs	r0, r0, r1, lsl #8
    8aec:	e1500381 	cmp	r0, r1, lsl #7
    8af0:	e0a22002 	adc	r2, r2, r2
    8af4:	20400381 	subcs	r0, r0, r1, lsl #7
    8af8:	e1500301 	cmp	r0, r1, lsl #6
    8afc:	e0a22002 	adc	r2, r2, r2
    8b00:	20400301 	subcs	r0, r0, r1, lsl #6
    8b04:	e1500281 	cmp	r0, r1, lsl #5
    8b08:	e0a22002 	adc	r2, r2, r2
    8b0c:	20400281 	subcs	r0, r0, r1, lsl #5
    8b10:	e1500201 	cmp	r0, r1, lsl #4
    8b14:	e0a22002 	adc	r2, r2, r2
    8b18:	20400201 	subcs	r0, r0, r1, lsl #4
    8b1c:	e1500181 	cmp	r0, r1, lsl #3
    8b20:	e0a22002 	adc	r2, r2, r2
    8b24:	20400181 	subcs	r0, r0, r1, lsl #3
    8b28:	e1500101 	cmp	r0, r1, lsl #2
    8b2c:	e0a22002 	adc	r2, r2, r2
    8b30:	20400101 	subcs	r0, r0, r1, lsl #2
    8b34:	e1500081 	cmp	r0, r1, lsl #1
    8b38:	e0a22002 	adc	r2, r2, r2
    8b3c:	20400081 	subcs	r0, r0, r1, lsl #1
    8b40:	e1500001 	cmp	r0, r1
    8b44:	e0a22002 	adc	r2, r2, r2
    8b48:	20400001 	subcs	r0, r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1115
    8b4c:	e1a00002 	mov	r0, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1116
    8b50:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1119
    8b54:	03a00001 	moveq	r0, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1120
    8b58:	13a00000 	movne	r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1121
    8b5c:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1123
    8b60:	e16f2f11 	clz	r2, r1
    8b64:	e262201f 	rsb	r2, r2, #31
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1125
    8b68:	e1a00230 	lsr	r0, r0, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1126
    8b6c:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1130
    8b70:	e3500000 	cmp	r0, #0
    8b74:	13e00000 	mvnne	r0, #0
    8b78:	ea000007 	b	8b9c <__aeabi_idiv0>

00008b7c <__aeabi_uidivmod>:
__aeabi_uidivmod():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1161
    8b7c:	e3510000 	cmp	r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1162
    8b80:	0afffffa 	beq	8b70 <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1163
    8b84:	e92d4003 	push	{r0, r1, lr}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1164
    8b88:	ebffff80 	bl	8990 <__udivsi3>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1165
    8b8c:	e8bd4006 	pop	{r1, r2, lr}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1166
    8b90:	e0030092 	mul	r3, r2, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1167
    8b94:	e0411003 	sub	r1, r1, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1168
    8b98:	e12fff1e 	bx	lr

00008b9c <__aeabi_idiv0>:
__aeabi_ldiv0():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1466
    8b9c:	e12fff1e 	bx	lr

Disassembly of section .rodata:

00008ba0 <_ZL21MaxFSDriverNameLength>:
    8ba0:	00000010 	andeq	r0, r0, r0, lsl r0

00008ba4 <_ZL17MaxFilenameLength>:
    8ba4:	00000010 	andeq	r0, r0, r0, lsl r0

00008ba8 <_ZL13MaxPathLength>:
    8ba8:	00000080 	andeq	r0, r0, r0, lsl #1

00008bac <_ZL18NoFilesystemDriver>:
    8bac:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
    8bb0:	6c6c6548 	cfstr64vs	mvdx6, [ip], #-288	; 0xfffffee0
    8bb4:	000a216f 	andeq	r2, sl, pc, ror #2
    8bb8:	3a564544 	bcc	159a0d0 <__bss_end+0x15914c8>
    8bbc:	696e6f6d 	stmdbvs	lr!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
    8bc0:	2f726f74 	svccs	0x00726f74
    8bc4:	00000030 	andeq	r0, r0, r0, lsr r0
    8bc8:	3a564544 	bcc	159a0e0 <__bss_end+0x15914d8>
    8bcc:	676e7274 			; <UNDEFINED> instruction: 0x676e7274
    8bd0:	00000000 	andeq	r0, r0, r0

00008bd4 <_ZL21MaxFSDriverNameLength>:
    8bd4:	00000010 	andeq	r0, r0, r0, lsl r0

00008bd8 <_ZL17MaxFilenameLength>:
    8bd8:	00000010 	andeq	r0, r0, r0, lsl r0

00008bdc <_ZL13MaxPathLength>:
    8bdc:	00000080 	andeq	r0, r0, r0, lsl #1

00008be0 <_ZL18NoFilesystemDriver>:
    8be0:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008be4 <_ZN12_GLOBAL__N_1L11CharConvArrE>:
    8be4:	33323130 	teqcc	r2, #48, 2
    8be8:	37363534 			; <UNDEFINED> instruction: 0x37363534
    8bec:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    8bf0:	46454443 	strbmi	r4, [r5], -r3, asr #8
	...

Disassembly of section .bss:

00008bf8 <__bss_start>:
	...

Disassembly of section .ARM.attributes:

00000000 <.ARM.attributes>:
   0:	00002e41 	andeq	r2, r0, r1, asr #28
   4:	61656100 	cmnvs	r5, r0, lsl #2
   8:	01006962 	tsteq	r0, r2, ror #18
   c:	00000024 	andeq	r0, r0, r4, lsr #32
  10:	4b5a3605 	blmi	168d82c <__bss_end+0x1684c24>
  14:	08070600 	stmdaeq	r7, {r9, sl}
  18:	0a010901 	beq	42424 <__bss_end+0x3981c>
  1c:	14041202 	strne	r1, [r4], #-514	; 0xfffffdfe
  20:	17011501 	strne	r1, [r1, -r1, lsl #10]
  24:	1a011803 	bne	46038 <__bss_end+0x3d430>
  28:	22011c01 	andcs	r1, r1, #256	; 0x100
  2c:	Address 0x000000000000002c is out of bounds.


Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347 	bcc	10d0d24 <__bss_end+0x10c811c>
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


Disassembly of section .debug_line:

00000000 <.debug_line>:
   0:	00000086 	andeq	r0, r0, r6, lsl #1
   4:	00700003 	rsbseq	r0, r0, r3
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
  34:	532f7374 			; <UNDEFINED> instruction: 0x532f7374
  38:	6f6f6863 	svcvs	0x006f6863
  3c:	655a2f6c 	ldrbvs	r2, [sl, #-3948]	; 0xfffff094
  40:	614d6f72 	hvcvs	55026	; 0xd6f2
  44:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffad8 <__bss_end+0xffff6ed0>
  48:	706d6178 	rsbvc	r6, sp, r8, ror r1
  4c:	2f73656c 	svccs	0x0073656c
  50:	702d3631 	eorvc	r3, sp, r1, lsr r6
  54:	6e696761 	cdpvs	7, 6, cr6, cr9, cr1, {3}
  58:	73755f67 	cmnvc	r5, #412	; 0x19c
  5c:	70737265 	rsbsvc	r7, r3, r5, ror #4
  60:	2f656361 	svccs	0x00656361
  64:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
  68:	63617073 	cmnvs	r1, #115	; 0x73
  6c:	63000065 	movwvs	r0, #101	; 0x65
  70:	2e307472 	mrccs	4, 1, r7, cr0, cr2, {3}
  74:	00010073 	andeq	r0, r1, r3, ror r0
  78:	05000000 	streq	r0, [r0, #-0]
  7c:	00800002 	addeq	r0, r0, r2
  80:	01090300 	mrseq	r0, (UNDEF: 57)
  84:	00020231 	andeq	r0, r2, r1, lsr r2
  88:	00b50101 	adcseq	r0, r5, r1, lsl #2
  8c:	00030000 	andeq	r0, r3, r0
  90:	00000070 	andeq	r0, r0, r0, ror r0
  94:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
  98:	0101000d 	tsteq	r1, sp
  9c:	00000101 	andeq	r0, r0, r1, lsl #2
  a0:	00000100 	andeq	r0, r0, r0, lsl #2
  a4:	6e6d2f01 	cdpvs	15, 6, cr2, cr13, cr1, {0}
  a8:	2f632f74 	svccs	0x00632f74
  ac:	72657355 	rsbvc	r7, r5, #1409286145	; 0x54000001
  b0:	754b2f73 	strbvc	r2, [fp, #-3955]	; 0xfffff08d
  b4:	442f6162 	strtmi	r6, [pc], #-354	; bc <shift+0xbc>
  b8:	6d75636f 	ldclvs	3, cr6, [r5, #-444]!	; 0xfffffe44
  bc:	73746e65 	cmnvc	r4, #1616	; 0x650
  c0:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
  c4:	2f6c6f6f 	svccs	0x006c6f6f
  c8:	6f72655a 	svcvs	0x0072655a
  cc:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
  d0:	6178652f 	cmnvs	r8, pc, lsr #10
  d4:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
  d8:	36312f73 	shsub16cc	r2, r1, r3
  dc:	6761702d 	strbvs	r7, [r1, -sp, lsr #32]!
  e0:	5f676e69 	svcpl	0x00676e69
  e4:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
  e8:	63617073 	cmnvs	r1, #115	; 0x73
  ec:	73752f65 	cmnvc	r5, #404	; 0x194
  f0:	70737265 	rsbsvc	r7, r3, r5, ror #4
  f4:	00656361 	rsbeq	r6, r5, r1, ror #6
  f8:	74726300 	ldrbtvc	r6, [r2], #-768	; 0xfffffd00
  fc:	00632e30 	rsbeq	r2, r3, r0, lsr lr
 100:	00000001 	andeq	r0, r0, r1
 104:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
 108:	00800802 	addeq	r0, r0, r2, lsl #16
 10c:	01090300 	mrseq	r0, (UNDEF: 57)
 110:	05671305 	strbeq	r1, [r7, #-773]!	; 0xfffffcfb
 114:	10054b05 	andne	r4, r5, r5, lsl #22
 118:	02040200 	andeq	r0, r4, #0, 4
 11c:	0034052f 	eorseq	r0, r4, pc, lsr #10
 120:	65020402 	strvs	r0, [r2, #-1026]	; 0xfffffbfe
 124:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
 128:	05660104 	strbeq	r0, [r6, #-260]!	; 0xfffffefc
 12c:	05d98401 	ldrbeq	r8, [r9, #1025]	; 0x401
 130:	05316805 	ldreq	r6, [r1, #-2053]!	; 0xfffff7fb
 134:	05053312 	streq	r3, [r5, #-786]	; 0xfffffcee
 138:	054b3185 	strbeq	r3, [fp, #-389]	; 0xfffffe7b
 13c:	06022f01 	streq	r2, [r2], -r1, lsl #30
 140:	0b010100 	bleq	40548 <__bss_end+0x37940>
 144:	03000001 	movweq	r0, #1
 148:	00008200 	andeq	r8, r0, r0, lsl #4
 14c:	fb010200 	blx	40956 <__bss_end+0x37d4e>
 150:	01000d0e 	tsteq	r0, lr, lsl #26
 154:	00010101 	andeq	r0, r1, r1, lsl #2
 158:	00010000 	andeq	r0, r1, r0
 15c:	6d2f0100 	stfvss	f0, [pc, #-0]	; 164 <shift+0x164>
 160:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
 164:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
 168:	4b2f7372 	blmi	bdcf38 <__bss_end+0xbd4330>
 16c:	2f616275 	svccs	0x00616275
 170:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
 174:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
 178:	63532f73 	cmpvs	r3, #460	; 0x1cc
 17c:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; ffffffe4 <__bss_end+0xffff73dc>
 180:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
 184:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
 188:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 18c:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
 190:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
 194:	61702d36 	cmnvs	r0, r6, lsr sp
 198:	676e6967 	strbvs	r6, [lr, -r7, ror #18]!
 19c:	6573755f 	ldrbvs	r7, [r3, #-1375]!	; 0xfffffaa1
 1a0:	61707372 	cmnvs	r0, r2, ror r3
 1a4:	752f6563 	strvc	r6, [pc, #-1379]!	; fffffc49 <__bss_end+0xffff7041>
 1a8:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 1ac:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
 1b0:	78630000 	stmdavc	r3!, {}^	; <UNPREDICTABLE>
 1b4:	69626178 	stmdbvs	r2!, {r3, r4, r5, r6, r8, sp, lr}^
 1b8:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
 1bc:	00000100 	andeq	r0, r0, r0, lsl #2
 1c0:	6975623c 	ldmdbvs	r5!, {r2, r3, r4, r5, r9, sp, lr}^
 1c4:	692d746c 	pushvs	{r2, r3, r5, r6, sl, ip, sp, lr}
 1c8:	00003e6e 	andeq	r3, r0, lr, ror #28
 1cc:	05000000 	streq	r0, [r0, #-0]
 1d0:	02050002 	andeq	r0, r5, #2
 1d4:	000080a4 	andeq	r8, r0, r4, lsr #1
 1d8:	05010a03 	streq	r0, [r1, #-2563]	; 0xfffff5fd
 1dc:	0a05830b 	beq	160e10 <__bss_end+0x158208>
 1e0:	8302054a 	movwhi	r0, #9546	; 0x254a
 1e4:	830e0585 	movwhi	r0, #58757	; 0xe585
 1e8:	85670205 	strbhi	r0, [r7, #-517]!	; 0xfffffdfb
 1ec:	86010584 	strhi	r0, [r1], -r4, lsl #11
 1f0:	854c854c 	strbhi	r8, [ip, #-1356]	; 0xfffffab4
 1f4:	0205854c 	andeq	r8, r5, #76, 10	; 0x13000000
 1f8:	01040200 	mrseq	r0, R12_usr
 1fc:	0301054b 	movweq	r0, #5451	; 0x154b
 200:	0d052e12 	stceq	14, cr2, [r5, #-72]	; 0xffffffb8
 204:	0024056b 	eoreq	r0, r4, fp, ror #10
 208:	4a030402 	bmi	c1218 <__bss_end+0xb8610>
 20c:	02000405 	andeq	r0, r0, #83886080	; 0x5000000
 210:	05830204 	streq	r0, [r3, #516]	; 0x204
 214:	0402000b 	streq	r0, [r2], #-11
 218:	02054a02 	andeq	r4, r5, #8192	; 0x2000
 21c:	02040200 	andeq	r0, r4, #0, 4
 220:	8509052d 	strhi	r0, [r9, #-1325]	; 0xfffffad3
 224:	a12f0105 			; <UNDEFINED> instruction: 0xa12f0105
 228:	056a0d05 	strbeq	r0, [sl, #-3333]!	; 0xfffff2fb
 22c:	04020024 	streq	r0, [r2], #-36	; 0xffffffdc
 230:	04054a03 	streq	r4, [r5], #-2563	; 0xfffff5fd
 234:	02040200 	andeq	r0, r4, #0, 4
 238:	000b0583 	andeq	r0, fp, r3, lsl #11
 23c:	4a020402 	bmi	8124c <__bss_end+0x78644>
 240:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
 244:	052d0204 	streq	r0, [sp, #-516]!	; 0xfffffdfc
 248:	01058509 	tsteq	r5, r9, lsl #10
 24c:	000a022f 	andeq	r0, sl, pc, lsr #4
 250:	01b70101 			; <UNDEFINED> instruction: 0x01b70101
 254:	00030000 	andeq	r0, r3, r0
 258:	00000179 	andeq	r0, r0, r9, ror r1
 25c:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
 260:	0101000d 	tsteq	r1, sp
 264:	00000101 	andeq	r0, r0, r1, lsl #2
 268:	00000100 	andeq	r0, r0, r0, lsl #2
 26c:	6e6d2f01 	cdpvs	15, 6, cr2, cr13, cr1, {0}
 270:	2f632f74 	svccs	0x00632f74
 274:	72657355 	rsbvc	r7, r5, #1409286145	; 0x54000001
 278:	754b2f73 	strbvc	r2, [fp, #-3955]	; 0xfffff08d
 27c:	442f6162 	strtmi	r6, [pc], #-354	; 284 <shift+0x284>
 280:	6d75636f 	ldclvs	3, cr6, [r5, #-444]!	; 0xfffffe44
 284:	73746e65 	cmnvc	r4, #1616	; 0x650
 288:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
 28c:	2f6c6f6f 	svccs	0x006c6f6f
 290:	6f72655a 	svcvs	0x0072655a
 294:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
 298:	6178652f 	cmnvs	r8, pc, lsr #10
 29c:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
 2a0:	36312f73 	shsub16cc	r2, r1, r3
 2a4:	6761702d 	strbvs	r7, [r1, -sp, lsr #32]!
 2a8:	5f676e69 	svcpl	0x00676e69
 2ac:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
 2b0:	63617073 	cmnvs	r1, #115	; 0x73
 2b4:	73752f65 	cmnvc	r5, #404	; 0x194
 2b8:	70737265 	rsbsvc	r7, r3, r5, ror #4
 2bc:	2f656361 	svccs	0x00656361
 2c0:	74736574 	ldrbtvc	r6, [r3], #-1396	; 0xfffffa8c
 2c4:	6f72705f 	svcvs	0x0072705f
 2c8:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
 2cc:	2f00325f 	svccs	0x0000325f
 2d0:	2f746e6d 	svccs	0x00746e6d
 2d4:	73552f63 	cmpvc	r5, #396	; 0x18c
 2d8:	2f737265 	svccs	0x00737265
 2dc:	6162754b 	cmnvs	r2, fp, asr #10
 2e0:	636f442f 	cmnvs	pc, #788529152	; 0x2f000000
 2e4:	6e656d75 	mcrvs	13, 3, r6, cr5, cr5, {3}
 2e8:	532f7374 			; <UNDEFINED> instruction: 0x532f7374
 2ec:	6f6f6863 	svcvs	0x006f6863
 2f0:	655a2f6c 	ldrbvs	r2, [sl, #-3948]	; 0xfffff094
 2f4:	614d6f72 	hvcvs	55026	; 0xd6f2
 2f8:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffd8c <__bss_end+0xffff7184>
 2fc:	706d6178 	rsbvc	r6, sp, r8, ror r1
 300:	2f73656c 	svccs	0x0073656c
 304:	702d3631 	eorvc	r3, sp, r1, lsr r6
 308:	6e696761 	cdpvs	7, 6, cr6, cr9, cr1, {3}
 30c:	73755f67 	cmnvc	r5, #412	; 0x19c
 310:	70737265 	rsbsvc	r7, r3, r5, ror #4
 314:	2f656361 	svccs	0x00656361
 318:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
 31c:	63617073 	cmnvs	r1, #115	; 0x73
 320:	2e2e2f65 	cdpcs	15, 2, cr2, cr14, cr5, {3}
 324:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 328:	2f6c656e 	svccs	0x006c656e
 32c:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 330:	2f656475 	svccs	0x00656475
 334:	2f007366 	svccs	0x00007366
 338:	2f746e6d 	svccs	0x00746e6d
 33c:	73552f63 	cmpvc	r5, #396	; 0x18c
 340:	2f737265 	svccs	0x00737265
 344:	6162754b 	cmnvs	r2, fp, asr #10
 348:	636f442f 	cmnvs	pc, #788529152	; 0x2f000000
 34c:	6e656d75 	mcrvs	13, 3, r6, cr5, cr5, {3}
 350:	532f7374 			; <UNDEFINED> instruction: 0x532f7374
 354:	6f6f6863 	svcvs	0x006f6863
 358:	655a2f6c 	ldrbvs	r2, [sl, #-3948]	; 0xfffff094
 35c:	614d6f72 	hvcvs	55026	; 0xd6f2
 360:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffdf4 <__bss_end+0xffff71ec>
 364:	706d6178 	rsbvc	r6, sp, r8, ror r1
 368:	2f73656c 	svccs	0x0073656c
 36c:	702d3631 	eorvc	r3, sp, r1, lsr r6
 370:	6e696761 	cdpvs	7, 6, cr6, cr9, cr1, {3}
 374:	73755f67 	cmnvc	r5, #412	; 0x19c
 378:	70737265 	rsbsvc	r7, r3, r5, ror #4
 37c:	2f656361 	svccs	0x00656361
 380:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
 384:	63617073 	cmnvs	r1, #115	; 0x73
 388:	2e2e2f65 	cdpcs	15, 2, cr2, cr14, cr5, {3}
 38c:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 390:	2f6c656e 	svccs	0x006c656e
 394:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 398:	2f656475 	svccs	0x00656475
 39c:	72616f62 	rsbvc	r6, r1, #392	; 0x188
 3a0:	70722f64 	rsbsvc	r2, r2, r4, ror #30
 3a4:	682f3069 	stmdavs	pc!, {r0, r3, r5, r6, ip, sp}	; <UNPREDICTABLE>
 3a8:	00006c61 	andeq	r6, r0, r1, ror #24
 3ac:	6e69616d 	powvsez	f6, f1, #5.0
 3b0:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
 3b4:	00000100 	andeq	r0, r0, r0, lsl #2
 3b8:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
 3bc:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
 3c0:	682e6d65 	stmdavs	lr!, {r0, r2, r5, r6, r8, sl, fp, sp, lr}
 3c4:	00000200 	andeq	r0, r0, r0, lsl #4
 3c8:	64746e69 	ldrbtvs	r6, [r4], #-3689	; 0xfffff197
 3cc:	682e6665 	stmdavs	lr!, {r0, r2, r5, r6, r9, sl, sp, lr}
 3d0:	00000300 	andeq	r0, r0, r0, lsl #6
 3d4:	00010500 	andeq	r0, r1, r0, lsl #10
 3d8:	822c0205 	eorhi	r0, ip, #1342177280	; 0x50000000
 3dc:	05160000 	ldreq	r0, [r6, #-0]
 3e0:	1605a111 			; <UNDEFINED> instruction: 0x1605a111
 3e4:	8319054c 	tsthi	r9, #76, 10	; 0x13000000
 3e8:	05890d05 	streq	r0, [r9, #3333]	; 0xd05
 3ec:	0d05a00e 	stceq	0, cr10, [r5, #-56]	; 0xffffffc8
 3f0:	a0200583 	eorge	r0, r0, r3, lsl #11
 3f4:	05820e05 	streq	r0, [r2, #3589]	; 0xe05
 3f8:	1705a010 	smladne	r5, r0, r0, sl
 3fc:	03040200 	movweq	r0, #16896	; 0x4200
 400:	0009054a 	andeq	r0, r9, sl, asr #10
 404:	d6020402 	strle	r0, [r2], -r2, lsl #8
 408:	01000e02 	tsteq	r0, r2, lsl #28
 40c:	00022a01 	andeq	r2, r2, r1, lsl #20
 410:	bd000300 	stclt	3, cr0, [r0, #-0]
 414:	02000001 	andeq	r0, r0, #1
 418:	0d0efb01 	vstreq	d15, [lr, #-4]
 41c:	01010100 	mrseq	r0, (UNDEF: 17)
 420:	00000001 	andeq	r0, r0, r1
 424:	01000001 	tsteq	r0, r1
 428:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
 42c:	552f632f 	strpl	r6, [pc, #-815]!	; 105 <shift+0x105>
 430:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 434:	62754b2f 	rsbsvs	r4, r5, #48128	; 0xbc00
 438:	6f442f61 	svcvs	0x00442f61
 43c:	656d7563 	strbvs	r7, [sp, #-1379]!	; 0xfffffa9d
 440:	2f73746e 	svccs	0x0073746e
 444:	6f686353 	svcvs	0x00686353
 448:	5a2f6c6f 	bpl	bdb60c <__bss_end+0xbd2a04>
 44c:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 2c0 <shift+0x2c0>
 450:	2f657461 	svccs	0x00657461
 454:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
 458:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
 45c:	2d36312f 	ldfcss	f3, [r6, #-188]!	; 0xffffff44
 460:	69676170 	stmdbvs	r7!, {r4, r5, r6, r8, sp, lr}^
 464:	755f676e 	ldrbvc	r6, [pc, #-1902]	; fffffcfe <__bss_end+0xffff70f6>
 468:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 46c:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
 470:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
 474:	2f62696c 	svccs	0x0062696c
 478:	00637273 	rsbeq	r7, r3, r3, ror r2
 47c:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
 480:	552f632f 	strpl	r6, [pc, #-815]!	; 159 <shift+0x159>
 484:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 488:	62754b2f 	rsbsvs	r4, r5, #48128	; 0xbc00
 48c:	6f442f61 	svcvs	0x00442f61
 490:	656d7563 	strbvs	r7, [sp, #-1379]!	; 0xfffffa9d
 494:	2f73746e 	svccs	0x0073746e
 498:	6f686353 	svcvs	0x00686353
 49c:	5a2f6c6f 	bpl	bdb660 <__bss_end+0xbd2a58>
 4a0:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 314 <shift+0x314>
 4a4:	2f657461 	svccs	0x00657461
 4a8:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
 4ac:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
 4b0:	2d36312f 	ldfcss	f3, [r6, #-188]!	; 0xffffff44
 4b4:	69676170 	stmdbvs	r7!, {r4, r5, r6, r8, sp, lr}^
 4b8:	755f676e 	ldrbvc	r6, [pc, #-1902]	; fffffd52 <__bss_end+0xffff714a>
 4bc:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 4c0:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
 4c4:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 4c8:	2f6c656e 	svccs	0x006c656e
 4cc:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 4d0:	2f656475 	svccs	0x00656475
 4d4:	2f007366 	svccs	0x00007366
 4d8:	2f746e6d 	svccs	0x00746e6d
 4dc:	73552f63 	cmpvc	r5, #396	; 0x18c
 4e0:	2f737265 	svccs	0x00737265
 4e4:	6162754b 	cmnvs	r2, fp, asr #10
 4e8:	636f442f 	cmnvs	pc, #788529152	; 0x2f000000
 4ec:	6e656d75 	mcrvs	13, 3, r6, cr5, cr5, {3}
 4f0:	532f7374 			; <UNDEFINED> instruction: 0x532f7374
 4f4:	6f6f6863 	svcvs	0x006f6863
 4f8:	655a2f6c 	ldrbvs	r2, [sl, #-3948]	; 0xfffff094
 4fc:	614d6f72 	hvcvs	55026	; 0xd6f2
 500:	652f6574 	strvs	r6, [pc, #-1396]!	; ffffff94 <__bss_end+0xffff738c>
 504:	706d6178 	rsbvc	r6, sp, r8, ror r1
 508:	2f73656c 	svccs	0x0073656c
 50c:	702d3631 	eorvc	r3, sp, r1, lsr r6
 510:	6e696761 	cdpvs	7, 6, cr6, cr9, cr1, {3}
 514:	73755f67 	cmnvc	r5, #412	; 0x19c
 518:	70737265 	rsbsvc	r7, r3, r5, ror #4
 51c:	2f656361 	svccs	0x00656361
 520:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 524:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 528:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 52c:	702f6564 	eorvc	r6, pc, r4, ror #10
 530:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
 534:	2f007373 	svccs	0x00007373
 538:	2f746e6d 	svccs	0x00746e6d
 53c:	73552f63 	cmpvc	r5, #396	; 0x18c
 540:	2f737265 	svccs	0x00737265
 544:	6162754b 	cmnvs	r2, fp, asr #10
 548:	636f442f 	cmnvs	pc, #788529152	; 0x2f000000
 54c:	6e656d75 	mcrvs	13, 3, r6, cr5, cr5, {3}
 550:	532f7374 			; <UNDEFINED> instruction: 0x532f7374
 554:	6f6f6863 	svcvs	0x006f6863
 558:	655a2f6c 	ldrbvs	r2, [sl, #-3948]	; 0xfffff094
 55c:	614d6f72 	hvcvs	55026	; 0xd6f2
 560:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffff4 <__bss_end+0xffff73ec>
 564:	706d6178 	rsbvc	r6, sp, r8, ror r1
 568:	2f73656c 	svccs	0x0073656c
 56c:	702d3631 	eorvc	r3, sp, r1, lsr r6
 570:	6e696761 	cdpvs	7, 6, cr6, cr9, cr1, {3}
 574:	73755f67 	cmnvc	r5, #412	; 0x19c
 578:	70737265 	rsbsvc	r7, r3, r5, ror #4
 57c:	2f656361 	svccs	0x00656361
 580:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 584:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 588:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 58c:	622f6564 	eorvs	r6, pc, #100, 10	; 0x19000000
 590:	6472616f 	ldrbtvs	r6, [r2], #-367	; 0xfffffe91
 594:	6970722f 	ldmdbvs	r0!, {r0, r1, r2, r3, r5, r9, ip, sp, lr}^
 598:	61682f30 	cmnvs	r8, r0, lsr pc
 59c:	7300006c 	movwvc	r0, #108	; 0x6c
 5a0:	69666474 	stmdbvs	r6!, {r2, r4, r5, r6, sl, sp, lr}^
 5a4:	632e656c 			; <UNDEFINED> instruction: 0x632e656c
 5a8:	01007070 	tsteq	r0, r0, ror r0
 5ac:	69660000 	stmdbvs	r6!, {}^	; <UNPREDICTABLE>
 5b0:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
 5b4:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
 5b8:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 5bc:	77730000 	ldrbvc	r0, [r3, -r0]!
 5c0:	00682e69 	rsbeq	r2, r8, r9, ror #28
 5c4:	69000003 	stmdbvs	r0, {r0, r1}
 5c8:	6564746e 	strbvs	r7, [r4, #-1134]!	; 0xfffffb92
 5cc:	00682e66 	rsbeq	r2, r8, r6, ror #28
 5d0:	00000004 	andeq	r0, r0, r4
 5d4:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
 5d8:	00830402 	addeq	r0, r3, r2, lsl #8
 5dc:	05051500 	streq	r1, [r5, #-1280]	; 0xfffffb00
 5e0:	0c052f69 	stceq	15, cr2, [r5], {105}	; 0x69
 5e4:	2f01054c 	svccs	0x0001054c
 5e8:	83050585 	movwhi	r0, #21893	; 0x5585
 5ec:	2f01054b 	svccs	0x0001054b
 5f0:	4b050585 	blmi	141c0c <__bss_end+0x139004>
 5f4:	852f0105 	strhi	r0, [pc, #-261]!	; 4f7 <shift+0x4f7>
 5f8:	4ba10505 	blmi	fe841a14 <__bss_end+0xfe838e0c>
 5fc:	0c052f4b 	stceq	15, cr2, [r5], {75}	; 0x4b
 600:	2f01054c 	svccs	0x0001054c
 604:	bd050585 	cfstr32lt	mvfx0, [r5, #-532]	; 0xfffffdec
 608:	2f4b4b4b 	svccs	0x004b4b4b
 60c:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 610:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 614:	4b4bbd05 	blmi	12efa30 <__bss_end+0x12e6e28>
 618:	0c052f4b 	stceq	15, cr2, [r5], {75}	; 0x4b
 61c:	2f01054c 	svccs	0x0001054c
 620:	83050585 	movwhi	r0, #21893	; 0x5585
 624:	2f01054b 	svccs	0x0001054b
 628:	bd050585 	cfstr32lt	mvfx0, [r5, #-532]	; 0xfffffdec
 62c:	2f4b4b4b 	svccs	0x004b4b4b
 630:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 634:	08022f01 	stmdaeq	r2, {r0, r8, r9, sl, fp, sp}
 638:	9f010100 	svcls	0x00010100
 63c:	03000002 	movweq	r0, #2
 640:	00007800 	andeq	r7, r0, r0, lsl #16
 644:	fb010200 	blx	40e4e <__bss_end+0x38246>
 648:	01000d0e 	tsteq	r0, lr, lsl #26
 64c:	00010101 	andeq	r0, r1, r1, lsl #2
 650:	00010000 	andeq	r0, r1, r0
 654:	6d2f0100 	stfvss	f0, [pc, #-0]	; 65c <shift+0x65c>
 658:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
 65c:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
 660:	4b2f7372 	blmi	bdd430 <__bss_end+0xbd4828>
 664:	2f616275 	svccs	0x00616275
 668:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
 66c:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
 670:	63532f73 	cmpvs	r3, #460	; 0x1cc
 674:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; 4dc <shift+0x4dc>
 678:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
 67c:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
 680:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 684:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
 688:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
 68c:	61702d36 	cmnvs	r0, r6, lsr sp
 690:	676e6967 	strbvs	r6, [lr, -r7, ror #18]!
 694:	6573755f 	ldrbvs	r7, [r3, #-1375]!	; 0xfffffaa1
 698:	61707372 	cmnvs	r0, r2, ror r3
 69c:	732f6563 			; <UNDEFINED> instruction: 0x732f6563
 6a0:	696c6474 	stmdbvs	ip!, {r2, r4, r5, r6, sl, sp, lr}^
 6a4:	72732f62 	rsbsvc	r2, r3, #392	; 0x188
 6a8:	73000063 	movwvc	r0, #99	; 0x63
 6ac:	74736474 	ldrbtvc	r6, [r3], #-1140	; 0xfffffb8c
 6b0:	676e6972 			; <UNDEFINED> instruction: 0x676e6972
 6b4:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
 6b8:	00000100 	andeq	r0, r0, r0, lsl #2
 6bc:	00010500 	andeq	r0, r1, r0, lsl #10
 6c0:	84d80205 	ldrbhi	r0, [r8], #517	; 0x205
 6c4:	051a0000 	ldreq	r0, [sl, #-0]
 6c8:	0f05bb06 	svceq	0x0005bb06
 6cc:	6821054c 	stmdavs	r1!, {r2, r3, r6, r8, sl}
 6d0:	05ba0a05 	ldreq	r0, [sl, #2565]!	; 0xa05
 6d4:	27052e0b 	strcs	r2, [r5, -fp, lsl #28]
 6d8:	4a0d054a 	bmi	341c08 <__bss_end+0x339000>
 6dc:	052f0905 	streq	r0, [pc, #-2309]!	; fffffddf <__bss_end+0xffff71d7>
 6e0:	02059f04 	andeq	r9, r5, #4, 30
 6e4:	35050562 	strcc	r0, [r5, #-1378]	; 0xfffffa9e
 6e8:	05681005 	strbeq	r1, [r8, #-5]!
 6ec:	22052e11 	andcs	r2, r5, #272	; 0x110
 6f0:	2e13054a 	cfmac32cs	mvfx0, mvfx3, mvfx10
 6f4:	052f0a05 	streq	r0, [pc, #-2565]!	; fffffcf7 <__bss_end+0xffff70ef>
 6f8:	0a056909 	beq	15ab24 <__bss_end+0x151f1c>
 6fc:	4a0c052e 	bmi	301bbc <__bss_end+0x2f8fb4>
 700:	054b0305 	strbeq	r0, [fp, #-773]	; 0xfffffcfb
 704:	1805680b 	stmdane	r5, {r0, r1, r3, fp, sp, lr}
 708:	03040200 	movweq	r0, #16896	; 0x4200
 70c:	0014054a 	andseq	r0, r4, sl, asr #10
 710:	9e030402 	cdpls	4, 0, cr0, cr3, cr2, {0}
 714:	02001505 	andeq	r1, r0, #20971520	; 0x1400000
 718:	05680204 	strbeq	r0, [r8, #-516]!	; 0xfffffdfc
 71c:	04020018 	streq	r0, [r2], #-24	; 0xffffffe8
 720:	08058202 	stmdaeq	r5, {r1, r9, pc}
 724:	02040200 	andeq	r0, r4, #0, 4
 728:	001a054a 	andseq	r0, sl, sl, asr #10
 72c:	4b020402 	blmi	8173c <__bss_end+0x78b34>
 730:	02001b05 	andeq	r1, r0, #5120	; 0x1400
 734:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
 738:	0402000c 	streq	r0, [r2], #-12
 73c:	0f054a02 	svceq	0x00054a02
 740:	02040200 	andeq	r0, r4, #0, 4
 744:	001b0582 	andseq	r0, fp, r2, lsl #11
 748:	4a020402 	bmi	81758 <__bss_end+0x78b50>
 74c:	02001105 	andeq	r1, r0, #1073741825	; 0x40000001
 750:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
 754:	0402000a 	streq	r0, [r2], #-10
 758:	0b052f02 	bleq	14c368 <__bss_end+0x143760>
 75c:	02040200 	andeq	r0, r4, #0, 4
 760:	000d052e 	andeq	r0, sp, lr, lsr #10
 764:	4a020402 	bmi	81774 <__bss_end+0x78b6c>
 768:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
 76c:	05460204 	strbeq	r0, [r6, #-516]	; 0xfffffdfc
 770:	05858801 	streq	r8, [r5, #2049]	; 0x801
 774:	09058306 	stmdbeq	r5, {r1, r2, r8, r9, pc}
 778:	4a10054c 	bmi	401cb0 <__bss_end+0x3f90a8>
 77c:	054c0a05 	strbeq	r0, [ip, #-2565]	; 0xfffff5fb
 780:	0305bb07 	movweq	fp, #23303	; 0x5b07
 784:	0017054a 	andseq	r0, r7, sl, asr #10
 788:	4a010402 	bmi	41798 <__bss_end+0x38b90>
 78c:	02001405 	andeq	r1, r0, #83886080	; 0x5000000
 790:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
 794:	14054d0d 	strne	r4, [r5], #-3341	; 0xfffff2f3
 798:	2e0a054a 	cfsh32cs	mvfx0, mvfx10, #42
 79c:	05680805 	strbeq	r0, [r8, #-2053]!	; 0xfffff7fb
 7a0:	66780302 	ldrbtvs	r0, [r8], -r2, lsl #6
 7a4:	0b030905 	bleq	c2bc0 <__bss_end+0xb9fb8>
 7a8:	2f01052e 	svccs	0x0001052e
 7ac:	bd090585 	cfstr32lt	mvfx0, [r9, #-532]	; 0xfffffdec
 7b0:	02001605 	andeq	r1, r0, #5242880	; 0x500000
 7b4:	054a0404 	strbeq	r0, [sl, #-1028]	; 0xfffffbfc
 7b8:	0402001d 	streq	r0, [r2], #-29	; 0xffffffe3
 7bc:	1e058202 	cdpne	2, 0, cr8, cr5, cr2, {0}
 7c0:	02040200 	andeq	r0, r4, #0, 4
 7c4:	0016052e 	andseq	r0, r6, lr, lsr #10
 7c8:	66020402 	strvs	r0, [r2], -r2, lsl #8
 7cc:	02001105 	andeq	r1, r0, #1073741825	; 0x40000001
 7d0:	054b0304 	strbeq	r0, [fp, #-772]	; 0xfffffcfc
 7d4:	04020012 	streq	r0, [r2], #-18	; 0xffffffee
 7d8:	08052e03 	stmdaeq	r5, {r0, r1, r9, sl, fp, sp}
 7dc:	03040200 	movweq	r0, #16896	; 0x4200
 7e0:	0009054a 	andeq	r0, r9, sl, asr #10
 7e4:	2e030402 	cdpcs	4, 0, cr0, cr3, cr2, {0}
 7e8:	02001205 	andeq	r1, r0, #1342177280	; 0x50000000
 7ec:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
 7f0:	0402000b 	streq	r0, [r2], #-11
 7f4:	02052e03 	andeq	r2, r5, #3, 28	; 0x30
 7f8:	03040200 	movweq	r0, #16896	; 0x4200
 7fc:	000b052d 	andeq	r0, fp, sp, lsr #10
 800:	84020402 	strhi	r0, [r2], #-1026	; 0xfffffbfe
 804:	02000805 	andeq	r0, r0, #327680	; 0x50000
 808:	05830104 	streq	r0, [r3, #260]	; 0x104
 80c:	04020009 	streq	r0, [r2], #-9
 810:	0b052e01 	bleq	14c01c <__bss_end+0x143414>
 814:	01040200 	mrseq	r0, R12_usr
 818:	0002054a 	andeq	r0, r2, sl, asr #10
 81c:	49010402 	stmdbmi	r1, {r1, sl}
 820:	05850b05 	streq	r0, [r5, #2821]	; 0xb05
 824:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 828:	1105bc0e 	tstne	r5, lr, lsl #24
 82c:	bc200566 	cfstr32lt	mvfx0, [r0], #-408	; 0xfffffe68
 830:	05660b05 	strbeq	r0, [r6, #-2821]!	; 0xfffff4fb
 834:	0a054b1f 	beq	1534b8 <__bss_end+0x14a8b0>
 838:	4b080566 	blmi	201dd8 <__bss_end+0x1f91d0>
 83c:	05831105 	streq	r1, [r3, #261]	; 0x105
 840:	08052e16 	stmdaeq	r5, {r1, r2, r4, r9, sl, fp, sp}
 844:	67110567 	ldrvs	r0, [r1, -r7, ror #10]
 848:	054d0b05 	strbeq	r0, [sp, #-2821]	; 0xfffff4fb
 84c:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 850:	0b058306 	bleq	161470 <__bss_end+0x158868>
 854:	2e0c054c 	cfsh32cs	mvfx0, mvfx12, #44
 858:	05660e05 	strbeq	r0, [r6, #-3589]!	; 0xfffff1fb
 85c:	02054b04 	andeq	r4, r5, #4, 22	; 0x1000
 860:	31090565 	tstcc	r9, r5, ror #10
 864:	852f0105 	strhi	r0, [pc, #-261]!	; 767 <shift+0x767>
 868:	059f0805 	ldreq	r0, [pc, #2053]	; 1075 <shift+0x1075>
 86c:	14054c0b 	strne	r4, [r5], #-3083	; 0xfffff3f5
 870:	03040200 	movweq	r0, #16896	; 0x4200
 874:	0007054a 	andeq	r0, r7, sl, asr #10
 878:	83020402 	movwhi	r0, #9218	; 0x2402
 87c:	02000805 	andeq	r0, r0, #327680	; 0x50000
 880:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
 884:	0402000a 	streq	r0, [r2], #-10
 888:	02054a02 	andeq	r4, r5, #8192	; 0x2000
 88c:	02040200 	andeq	r0, r4, #0, 4
 890:	84010549 	strhi	r0, [r1], #-1353	; 0xfffffab7
 894:	bb0e0585 	bllt	381eb0 <__bss_end+0x3792a8>
 898:	054b0805 	strbeq	r0, [fp, #-2053]	; 0xfffff7fb
 89c:	14054c0b 	strne	r4, [r5], #-3083	; 0xfffff3f5
 8a0:	03040200 	movweq	r0, #16896	; 0x4200
 8a4:	0016054a 	andseq	r0, r6, sl, asr #10
 8a8:	83020402 	movwhi	r0, #9218	; 0x2402
 8ac:	02001705 	andeq	r1, r0, #1310720	; 0x140000
 8b0:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
 8b4:	0402000a 	streq	r0, [r2], #-10
 8b8:	0b054a02 	bleq	1530c8 <__bss_end+0x14a4c0>
 8bc:	02040200 	andeq	r0, r4, #0, 4
 8c0:	0017052e 	andseq	r0, r7, lr, lsr #10
 8c4:	4a020402 	bmi	818d4 <__bss_end+0x78ccc>
 8c8:	02000d05 	andeq	r0, r0, #320	; 0x140
 8cc:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
 8d0:	04020002 	streq	r0, [r2], #-2
 8d4:	01052d02 	tsteq	r5, r2, lsl #26
 8d8:	00080284 	andeq	r0, r8, r4, lsl #5
 8dc:	00790101 	rsbseq	r0, r9, r1, lsl #2
 8e0:	00030000 	andeq	r0, r3, r0
 8e4:	00000046 	andeq	r0, r0, r6, asr #32
 8e8:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
 8ec:	0101000d 	tsteq	r1, sp
 8f0:	00000101 	andeq	r0, r0, r1, lsl #2
 8f4:	00000100 	andeq	r0, r0, r0, lsl #2
 8f8:	2f2e2e01 	svccs	0x002e2e01
 8fc:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 900:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 904:	2f2e2e2f 	svccs	0x002e2e2f
 908:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 858 <shift+0x858>
 90c:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
 910:	6f632f63 	svcvs	0x00632f63
 914:	6769666e 	strbvs	r6, [r9, -lr, ror #12]!
 918:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
 91c:	696c0000 	stmdbvs	ip!, {}^	; <UNPREDICTABLE>
 920:	75663162 	strbvc	r3, [r6, #-354]!	; 0xfffffe9e
 924:	2e73636e 	cdpcs	3, 7, cr6, cr3, cr14, {3}
 928:	00010053 	andeq	r0, r1, r3, asr r0
 92c:	05000000 	streq	r0, [r0, #-0]
 930:	00899002 	addeq	r9, r9, r2
 934:	08cf0300 	stmiaeq	pc, {r8, r9}^	; <UNPREDICTABLE>
 938:	2f2f3001 	svccs	0x002f3001
 93c:	302f2f2f 	eorcc	r2, pc, pc, lsr #30
 940:	1401d002 	strne	sp, [r1], #-2
 944:	2f2f312f 	svccs	0x002f312f
 948:	322f4c30 	eorcc	r4, pc, #48, 24	; 0x3000
 94c:	2f661f03 	svccs	0x00661f03
 950:	2f2f2f2f 	svccs	0x002f2f2f
 954:	02022f2f 	andeq	r2, r2, #47, 30	; 0xbc
 958:	5c010100 	stfpls	f0, [r1], {-0}
 95c:	03000000 	movweq	r0, #0
 960:	00004600 	andeq	r4, r0, r0, lsl #12
 964:	fb010200 	blx	4116e <__bss_end+0x38566>
 968:	01000d0e 	tsteq	r0, lr, lsl #26
 96c:	00010101 	andeq	r0, r1, r1, lsl #2
 970:	00010000 	andeq	r0, r1, r0
 974:	2e2e0100 	sufcse	f0, f6, f0
 978:	2f2e2e2f 	svccs	0x002e2e2f
 97c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 980:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 984:	2f2e2e2f 	svccs	0x002e2e2f
 988:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
 98c:	632f6363 			; <UNDEFINED> instruction: 0x632f6363
 990:	69666e6f 	stmdbvs	r6!, {r0, r1, r2, r3, r5, r6, r9, sl, fp, sp, lr}^
 994:	72612f67 	rsbvc	r2, r1, #412	; 0x19c
 998:	6c00006d 	stcvs	0, cr0, [r0], {109}	; 0x6d
 99c:	66316269 	ldrtvs	r6, [r1], -r9, ror #4
 9a0:	73636e75 	cmnvc	r3, #1872	; 0x750
 9a4:	0100532e 	tsteq	r0, lr, lsr #6
 9a8:	00000000 	andeq	r0, r0, r0
 9ac:	8b9c0205 	blhi	fe7011c8 <__bss_end+0xfe6f85c0>
 9b0:	b9030000 	stmdblt	r3, {}	; <UNPREDICTABLE>
 9b4:	0202010b 	andeq	r0, r2, #-1073741822	; 0xc0000002
 9b8:	a4010100 	strge	r0, [r1], #-256	; 0xffffff00
 9bc:	03000000 	movweq	r0, #0
 9c0:	00009e00 	andeq	r9, r0, r0, lsl #28
 9c4:	fb010200 	blx	411ce <__bss_end+0x385c6>
 9c8:	01000d0e 	tsteq	r0, lr, lsl #26
 9cc:	00010101 	andeq	r0, r1, r1, lsl #2
 9d0:	00010000 	andeq	r0, r1, r0
 9d4:	2e2e0100 	sufcse	f0, f6, f0
 9d8:	2f2e2e2f 	svccs	0x002e2e2f
 9dc:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 9e0:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 9e4:	672f2e2f 	strvs	r2, [pc, -pc, lsr #28]!
 9e8:	2e006363 	cdpcs	3, 0, cr6, cr0, cr3, {3}
 9ec:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 9f0:	2f2e2e2f 	svccs	0x002e2e2f
 9f4:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 9f8:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 9fc:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
 a00:	2f636367 	svccs	0x00636367
 a04:	672f2e2e 	strvs	r2, [pc, -lr, lsr #28]!
 a08:	632f6363 			; <UNDEFINED> instruction: 0x632f6363
 a0c:	69666e6f 	stmdbvs	r6!, {r0, r1, r2, r3, r5, r6, r9, sl, fp, sp, lr}^
 a10:	72612f67 	rsbvc	r2, r1, #412	; 0x19c
 a14:	2e2e006d 	cdpcs	0, 2, cr0, cr14, cr13, {3}
 a18:	2f2e2e2f 	svccs	0x002e2e2f
 a1c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 a20:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 a24:	2f2e2e2f 	svccs	0x002e2e2f
 a28:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
 a2c:	00006363 	andeq	r6, r0, r3, ror #6
 a30:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
 a34:	2e617369 	cdpcs	3, 6, cr7, cr1, cr9, {3}
 a38:	00010068 	andeq	r0, r1, r8, rrx
 a3c:	6d726100 	ldfvse	f6, [r2, #-0]
 a40:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 a44:	62670000 	rsbvs	r0, r7, #0
 a48:	74632d6c 	strbtvc	r2, [r3], #-3436	; 0xfffff294
 a4c:	2e73726f 	cdpcs	2, 7, cr7, cr3, cr15, {3}
 a50:	00030068 	andeq	r0, r3, r8, rrx
 a54:	62696c00 	rsbvs	r6, r9, #0, 24
 a58:	32636367 	rsbcc	r6, r3, #-1677721599	; 0x9c000001
 a5c:	0300632e 	movweq	r6, #814	; 0x32e
 a60:	Address 0x0000000000000a60 is out of bounds.


Disassembly of section .debug_info:

00000000 <.debug_info>:
   0:	00000022 	andeq	r0, r0, r2, lsr #32
   4:	00000002 	andeq	r0, r0, r2
   8:	01040000 	mrseq	r0, (UNDEF: 4)
   c:	00000000 	andeq	r0, r0, r0
  10:	00008000 	andeq	r8, r0, r0
  14:	00008008 	andeq	r8, r0, r8
  18:	00000000 	andeq	r0, r0, r0
  1c:	0000005a 	andeq	r0, r0, sl, asr r0
  20:	000000b3 	strheq	r0, [r0], -r3
  24:	009a8001 	addseq	r8, sl, r1
  28:	00040000 	andeq	r0, r4, r0
  2c:	00000014 	andeq	r0, r0, r4, lsl r0
  30:	00bf0104 	adcseq	r0, pc, r4, lsl #2
  34:	620c0000 	andvs	r0, ip, #0
  38:	5a000001 	bpl	44 <shift+0x44>
  3c:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
  40:	9c000080 	stcls	0, cr0, [r0], {128}	; 0x80
  44:	8a000000 	bhi	4c <shift+0x4c>
  48:	02000000 	andeq	r0, r0, #0
  4c:	000001bc 			; <UNDEFINED> instruction: 0x000001bc
  50:	31150601 	tstcc	r5, r1, lsl #12
  54:	03000000 	movweq	r0, #0
  58:	0cad0704 	stceq	7, cr0, [sp], #16
  5c:	51020000 	mrspl	r0, (UNDEF: 2)
  60:	01000001 	tsteq	r0, r1
  64:	00311507 	eorseq	r1, r1, r7, lsl #10
  68:	de040000 	cdple	0, 0, cr0, cr4, cr0, {0}
  6c:	01000001 	tsteq	r0, r1
  70:	80640610 	rsbhi	r0, r4, r0, lsl r6
  74:	00400000 	subeq	r0, r0, r0
  78:	9c010000 	stcls	0, cr0, [r1], {-0}
  7c:	0000006a 	andeq	r0, r0, sl, rrx
  80:	00015b05 	andeq	r5, r1, r5, lsl #22
  84:	091b0100 	ldmdbeq	fp, {r8}
  88:	0000006a 	andeq	r0, r0, sl, rrx
  8c:	00749102 	rsbseq	r9, r4, r2, lsl #2
  90:	69050406 	stmdbvs	r5, {r1, r2, sl}
  94:	0700746e 	streq	r7, [r0, -lr, ror #8]
  98:	000001c8 	andeq	r0, r0, r8, asr #3
  9c:	08060901 	stmdaeq	r6, {r0, r8, fp}
  a0:	5c000080 	stcpl	0, cr0, [r0], {128}	; 0x80
  a4:	01000000 	mrseq	r0, (UNDEF: 0)
  a8:	0000979c 	muleq	r0, ip, r7
  ac:	01d80500 	bicseq	r0, r8, r0, lsl #10
  b0:	0b010000 	bleq	400b8 <__bss_end+0x374b0>
  b4:	00009713 	andeq	r9, r0, r3, lsl r7
  b8:	74910200 	ldrvc	r0, [r1], #512	; 0x200
  bc:	31040800 	tstcc	r4, r0, lsl #16
  c0:	00000000 	andeq	r0, r0, r0
  c4:	00000202 	andeq	r0, r0, r2, lsl #4
  c8:	009f0004 	addseq	r0, pc, r4
  cc:	01040000 	mrseq	r0, (UNDEF: 4)
  d0:	00000324 	andeq	r0, r0, r4, lsr #6
  d4:	00029104 	andeq	r9, r2, r4, lsl #2
  d8:	00005a00 	andeq	r5, r0, r0, lsl #20
  dc:	0080a400 	addeq	sl, r0, r0, lsl #8
  e0:	00018800 	andeq	r8, r1, r0, lsl #16
  e4:	00014300 	andeq	r4, r1, r0, lsl #6
  e8:	03e00200 	mvneq	r0, #0, 4
  ec:	2f010000 	svccs	0x00010000
  f0:	00003107 	andeq	r3, r0, r7, lsl #2
  f4:	37040300 	strcc	r0, [r4, -r0, lsl #6]
  f8:	04000000 	streq	r0, [r0], #-0
  fc:	00028802 	andeq	r8, r2, r2, lsl #16
 100:	07300100 	ldreq	r0, [r0, -r0, lsl #2]!
 104:	00000031 	andeq	r0, r0, r1, lsr r0
 108:	00002505 	andeq	r2, r0, r5, lsl #10
 10c:	00005700 	andeq	r5, r0, r0, lsl #14
 110:	00570600 	subseq	r0, r7, r0, lsl #12
 114:	ffff0000 			; <UNDEFINED> instruction: 0xffff0000
 118:	0700ffff 			; <UNDEFINED> instruction: 0x0700ffff
 11c:	0cad0704 	stceq	7, cr0, [sp], #16
 120:	d2080000 	andle	r0, r8, #0
 124:	01000003 	tsteq	r0, r3
 128:	00441533 	subeq	r1, r4, r3, lsr r5
 12c:	4e080000 	cdpmi	0, 0, cr0, cr8, cr0, {0}
 130:	01000002 	tsteq	r0, r2
 134:	00441535 	subeq	r1, r4, r5, lsr r5
 138:	38050000 	stmdacc	r5, {}	; <UNPREDICTABLE>
 13c:	89000000 	stmdbhi	r0, {}	; <UNPREDICTABLE>
 140:	06000000 	streq	r0, [r0], -r0
 144:	00000057 	andeq	r0, r0, r7, asr r0
 148:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 14c:	02680800 	rsbeq	r0, r8, #0, 16
 150:	38010000 	stmdacc	r1, {}	; <UNPREDICTABLE>
 154:	00007615 	andeq	r7, r0, r5, lsl r6
 158:	02ef0800 	rsceq	r0, pc, #0, 16
 15c:	3a010000 	bcc	40164 <__bss_end+0x3755c>
 160:	00007615 	andeq	r7, r0, r5, lsl r6
 164:	02080900 	andeq	r0, r8, #0, 18
 168:	48010000 	stmdami	r1, {}	; <UNPREDICTABLE>
 16c:	0000cb10 	andeq	ip, r0, r0, lsl fp
 170:	0081d400 	addeq	sp, r1, r0, lsl #8
 174:	00005800 	andeq	r5, r0, r0, lsl #16
 178:	cb9c0100 	blgt	fe700580 <__bss_end+0xfe6f7978>
 17c:	0a000000 	beq	184 <shift+0x184>
 180:	00000216 	andeq	r0, r0, r6, lsl r2
 184:	d20c4a01 	andle	r4, ip, #4096	; 0x1000
 188:	02000000 	andeq	r0, r0, #0
 18c:	0b007491 	bleq	1d3d8 <__bss_end+0x147d0>
 190:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
 194:	04030074 	streq	r0, [r3], #-116	; 0xffffff8c
 198:	00000038 	andeq	r0, r0, r8, lsr r0
 19c:	00031709 	andeq	r1, r3, r9, lsl #14
 1a0:	103c0100 	eorsne	r0, ip, r0, lsl #2
 1a4:	000000cb 	andeq	r0, r0, fp, asr #1
 1a8:	0000817c 	andeq	r8, r0, ip, ror r1
 1ac:	00000058 	andeq	r0, r0, r8, asr r0
 1b0:	01029c01 	tsteq	r2, r1, lsl #24
 1b4:	160a0000 	strne	r0, [sl], -r0
 1b8:	01000002 	tsteq	r0, r2
 1bc:	01020c3e 	tsteq	r2, lr, lsr ip
 1c0:	91020000 	mrsls	r0, (UNDEF: 2)
 1c4:	04030074 	streq	r0, [r3], #-116	; 0xffffff8c
 1c8:	00000025 	andeq	r0, r0, r5, lsr #32
 1cc:	0001f10c 	andeq	pc, r1, ip, lsl #2
 1d0:	11290100 			; <UNDEFINED> instruction: 0x11290100
 1d4:	00008170 	andeq	r8, r0, r0, ror r1
 1d8:	0000000c 	andeq	r0, r0, ip
 1dc:	270c9c01 	strcs	r9, [ip, -r1, lsl #24]
 1e0:	01000002 	tsteq	r0, r2
 1e4:	81581124 	cmphi	r8, r4, lsr #2
 1e8:	00180000 	andseq	r0, r8, r0
 1ec:	9c010000 	stcls	0, cr0, [r1], {-0}
 1f0:	0002fc0c 	andeq	pc, r2, ip, lsl #24
 1f4:	111f0100 	tstne	pc, r0, lsl #2
 1f8:	00008140 	andeq	r8, r0, r0, asr #2
 1fc:	00000018 	andeq	r0, r0, r8, lsl r0
 200:	5b0c9c01 	blpl	32720c <__bss_end+0x31e604>
 204:	01000002 	tsteq	r0, r2
 208:	8128111a 			; <UNDEFINED> instruction: 0x8128111a
 20c:	00180000 	andseq	r0, r8, r0
 210:	9c010000 	stcls	0, cr0, [r1], {-0}
 214:	00021c0d 	andeq	r1, r2, sp, lsl #24
 218:	9e000200 	cdpls	2, 0, cr0, cr0, cr0, {0}
 21c:	0e000001 	cdpeq	0, 0, cr0, cr0, cr1, {0}
 220:	00000276 	andeq	r0, r0, r6, ror r2
 224:	6d121401 	cfldrsvs	mvf1, [r2, #-4]
 228:	0f000001 	svceq	0x00000001
 22c:	0000019e 	muleq	r0, lr, r1
 230:	01e90200 	mvneq	r0, r0, lsl #4
 234:	04010000 	streq	r0, [r1], #-0
 238:	0001a41c 	andeq	sl, r1, ip, lsl r4
 23c:	023a0e00 	eorseq	r0, sl, #0, 28
 240:	0f010000 	svceq	0x00010000
 244:	00018b12 	andeq	r8, r1, r2, lsl fp
 248:	019e0f00 	orrseq	r0, lr, r0, lsl #30
 24c:	10000000 	andne	r0, r0, r0
 250:	000003e9 	andeq	r0, r0, r9, ror #7
 254:	cb110a01 	blgt	442a60 <__bss_end+0x439e58>
 258:	0f000000 	svceq	0x00000000
 25c:	0000019e 	muleq	r0, lr, r1
 260:	04030000 	streq	r0, [r3], #-0
 264:	0000016d 	andeq	r0, r0, sp, ror #2
 268:	09050807 	stmdbeq	r5, {r0, r1, r2, fp}
 26c:	11000003 	tstne	r0, r3
 270:	0000015b 	andeq	r0, r0, fp, asr r1
 274:	00008108 	andeq	r8, r0, r8, lsl #2
 278:	00000020 	andeq	r0, r0, r0, lsr #32
 27c:	01c79c01 	biceq	r9, r7, r1, lsl #24
 280:	9e120000 	cdpls	0, 1, cr0, cr2, cr0, {0}
 284:	02000001 	andeq	r0, r0, #1
 288:	11007491 			; <UNDEFINED> instruction: 0x11007491
 28c:	00000179 	andeq	r0, r0, r9, ror r1
 290:	000080dc 	ldrdeq	r8, [r0], -ip
 294:	0000002c 	andeq	r0, r0, ip, lsr #32
 298:	01e89c01 	mvneq	r9, r1, lsl #24
 29c:	67130000 	ldrvs	r0, [r3, -r0]
 2a0:	300f0100 	andcc	r0, pc, r0, lsl #2
 2a4:	0000019e 	muleq	r0, lr, r1
 2a8:	00749102 	rsbseq	r9, r4, r2, lsl #2
 2ac:	00018b14 	andeq	r8, r1, r4, lsl fp
 2b0:	0080a400 	addeq	sl, r0, r0, lsl #8
 2b4:	00003800 	andeq	r3, r0, r0, lsl #16
 2b8:	139c0100 	orrsne	r0, ip, #0, 2
 2bc:	0a010067 	beq	40460 <__bss_end+0x37858>
 2c0:	00019e2f 	andeq	r9, r1, pc, lsr #28
 2c4:	74910200 	ldrvc	r0, [r1], #512	; 0x200
 2c8:	018c0000 	orreq	r0, ip, r0
 2cc:	00040000 	andeq	r0, r4, r0
 2d0:	000001c6 	andeq	r0, r0, r6, asr #3
 2d4:	03240104 			; <UNDEFINED> instruction: 0x03240104
 2d8:	bb040000 	bllt	1002e0 <__bss_end+0xf76d8>
 2dc:	5a000004 	bpl	2f4 <shift+0x2f4>
 2e0:	2c000000 	stccs	0, cr0, [r0], {-0}
 2e4:	d8000082 	stmdale	r0, {r1, r7}
 2e8:	52000000 	andpl	r0, r0, #0
 2ec:	02000002 	andeq	r0, r0, #2
 2f0:	046b0801 	strbteq	r0, [fp], #-2049	; 0xfffff7ff
 2f4:	25030000 	strcs	r0, [r3, #-0]
 2f8:	02000000 	andeq	r0, r0, #0
 2fc:	049d0502 	ldreq	r0, [sp], #1282	; 0x502
 300:	04040000 	streq	r0, [r4], #-0
 304:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
 308:	00380500 	eorseq	r0, r8, r0, lsl #10
 30c:	01020000 	mrseq	r0, (UNDEF: 2)
 310:	00046208 	andeq	r6, r4, r8, lsl #4
 314:	07020200 	streq	r0, [r2, -r0, lsl #4]
 318:	00000470 	andeq	r0, r0, r0, ror r4
 31c:	0004b206 	andeq	fp, r4, r6, lsl #4
 320:	07090300 	streq	r0, [r9, -r0, lsl #6]
 324:	00000063 	andeq	r0, r0, r3, rrx
 328:	00005203 	andeq	r5, r0, r3, lsl #4
 32c:	07040200 	streq	r0, [r4, -r0, lsl #4]
 330:	00000cad 	andeq	r0, r0, sp, lsr #25
 334:	00040407 	andeq	r0, r4, r7, lsl #8
 338:	1a060200 	bne	180b40 <__bss_end+0x177f38>
 33c:	0000005e 	andeq	r0, r0, lr, asr r0
 340:	8ba00305 	blhi	fe800f5c <__bss_end+0xfe7f8354>
 344:	3c070000 	stccc	0, cr0, [r7], {-0}
 348:	02000004 	andeq	r0, r0, #4
 34c:	005e1a08 	subseq	r1, lr, r8, lsl #20
 350:	03050000 	movweq	r0, #20480	; 0x5000
 354:	00008ba4 	andeq	r8, r0, r4, lsr #23
 358:	00044e07 	andeq	r4, r4, r7, lsl #28
 35c:	1a0a0200 	bne	280b64 <__bss_end+0x277f5c>
 360:	0000005e 	andeq	r0, r0, lr, asr r0
 364:	8ba80305 	blhi	fea00f80 <__bss_end+0xfe9f8378>
 368:	29070000 	stmdbcs	r7, {}	; <UNPREDICTABLE>
 36c:	02000004 	andeq	r0, r0, #4
 370:	005e1a0c 	subseq	r1, lr, ip, lsl #20
 374:	03050000 	movweq	r0, #20480	; 0x5000
 378:	00008bac 	andeq	r8, r0, ip, lsr #23
 37c:	0005ff08 	andeq	pc, r5, r8, lsl #30
 380:	38040500 	stmdacc	r4, {r8, sl}
 384:	02000000 	andeq	r0, r0, #0
 388:	00d70c0e 	sbcseq	r0, r7, lr, lsl #24
 38c:	8e090000 	cdphi	0, 0, cr0, cr9, cr0, {0}
 390:	00000004 	andeq	r0, r0, r4
 394:	0004a709 	andeq	sl, r4, r9, lsl #14
 398:	83090100 	movwhi	r0, #37120	; 0x9100
 39c:	02000004 	andeq	r0, r0, #4
 3a0:	00250a00 	eoreq	r0, r5, r0, lsl #20
 3a4:	00e70000 	rsceq	r0, r7, r0
 3a8:	630b0000 	movwvs	r0, #45056	; 0xb000
 3ac:	0f000000 	svceq	0x00000000
 3b0:	02010200 	andeq	r0, r1, #0, 4
 3b4:	0000041f 	andeq	r0, r0, pc, lsl r4
 3b8:	002c040c 	eoreq	r0, ip, ip, lsl #8
 3bc:	410d0000 	mrsmi	r0, (UNDEF: 13)
 3c0:	0100000c 	tsteq	r0, ip
 3c4:	00380504 	eorseq	r0, r8, r4, lsl #10
 3c8:	822c0000 	eorhi	r0, ip, #0
 3cc:	00d80000 	sbcseq	r0, r8, r0
 3d0:	9c010000 	stcls	0, cr0, [r1], {-0}
 3d4:	00000183 	andeq	r0, r0, r3, lsl #3
 3d8:	0004980e 	andeq	r9, r4, lr, lsl #16
 3dc:	0e040100 	adfeqs	f0, f4, f0
 3e0:	00000038 	andeq	r0, r0, r8, lsr r0
 3e4:	0e4c9102 	sqteqe	f1, f2
 3e8:	0000041a 	andeq	r0, r0, sl, lsl r4
 3ec:	831b0401 	tsthi	fp, #16777216	; 0x1000000
 3f0:	02000001 	andeq	r0, r0, #1
 3f4:	690f4891 	stmdbvs	pc, {r0, r4, r7, fp, lr}	; <UNPREDICTABLE>
 3f8:	0f060100 	svceq	0x00060100
 3fc:	0000003f 	andeq	r0, r0, pc, lsr r0
 400:	0f689102 	svceq	0x00689102
 404:	0067736d 	rsbeq	r7, r7, sp, ror #6
 408:	ee110801 	cdp	8, 1, cr0, cr1, cr1, {0}
 40c:	02000000 	andeq	r0, r0, #0
 410:	660f7491 			; <UNDEFINED> instruction: 0x660f7491
 414:	0e0a0100 	adfeqe	f0, f2, f0
 418:	00000052 	andeq	r0, r0, r2, asr r0
 41c:	10709102 	rsbsne	r9, r0, r2, lsl #2
 420:	00000424 	andeq	r0, r0, r4, lsr #8
 424:	520e0b01 	andpl	r0, lr, #1024	; 0x400
 428:	02000000 	andeq	r0, r0, #0
 42c:	5c106c91 	ldcpl	12, cr6, [r0], {145}	; 0x91
 430:	01000004 	tsteq	r0, r4
 434:	00520e0d 	subseq	r0, r2, sp, lsl #28
 438:	91020000 	mrsls	r0, (UNDEF: 2)
 43c:	03fd1064 	mvnseq	r1, #100	; 0x64
 440:	0e010000 	cdpeq	0, 0, cr0, cr1, cr0, {0}
 444:	0000d70a 	andeq	sp, r0, sl, lsl #14
 448:	54910200 	ldrpl	r0, [r1], #512	; 0x200
 44c:	89040c00 	stmdbhi	r4, {sl, fp}
 450:	0c000001 	stceq	0, cr0, [r0], {1}
 454:	00002504 	andeq	r2, r0, r4, lsl #10
 458:	02f90000 	rscseq	r0, r9, #0
 45c:	00040000 	andeq	r0, r4, r0
 460:	000002aa 	andeq	r0, r0, sl, lsr #5
 464:	06740104 	ldrbteq	r0, [r4], -r4, lsl #2
 468:	49040000 	stmdbmi	r4, {}	; <UNPREDICTABLE>
 46c:	67000007 	strvs	r0, [r0, -r7]
 470:	04000005 	streq	r0, [r0], #-5
 474:	d4000083 	strle	r0, [r0], #-131	; 0xffffff7d
 478:	0d000001 	stceq	0, cr0, [r0, #-4]
 47c:	02000004 	andeq	r0, r0, #4
 480:	046b0801 	strbteq	r0, [fp], #-2049	; 0xfffff7ff
 484:	25030000 	strcs	r0, [r3, #-0]
 488:	02000000 	andeq	r0, r0, #0
 48c:	049d0502 	ldreq	r0, [sp], #1282	; 0x502
 490:	04040000 	streq	r0, [r4], #-0
 494:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
 498:	08010200 	stmdaeq	r1, {r9}
 49c:	00000462 	andeq	r0, r0, r2, ror #8
 4a0:	70070202 	andvc	r0, r7, r2, lsl #4
 4a4:	05000004 	streq	r0, [r0, #-4]
 4a8:	000004b2 			; <UNDEFINED> instruction: 0x000004b2
 4ac:	5e070904 	vmlapl.f16	s0, s14, s8	; <UNPREDICTABLE>
 4b0:	03000000 	movweq	r0, #0
 4b4:	0000004d 	andeq	r0, r0, sp, asr #32
 4b8:	ad070402 	cfstrsge	mvf0, [r7, #-8]
 4bc:	0600000c 	streq	r0, [r0], -ip
 4c0:	000005c1 	andeq	r0, r0, r1, asr #11
 4c4:	00380405 	eorseq	r0, r8, r5, lsl #8
 4c8:	4d030000 	stcmi	0, cr0, [r3, #-0]
 4cc:	0000840c 	andeq	r8, r0, ip, lsl #8
 4d0:	05b60700 	ldreq	r0, [r6, #1792]!	; 0x700
 4d4:	07000000 	streq	r0, [r0, -r0]
 4d8:	00000624 	andeq	r0, r0, r4, lsr #12
 4dc:	04080001 	streq	r0, [r8], #-1
 4e0:	02000004 	andeq	r0, r0, #4
 4e4:	00591a06 	subseq	r1, r9, r6, lsl #20
 4e8:	03050000 	movweq	r0, #20480	; 0x5000
 4ec:	00008bd4 	ldrdeq	r8, [r0], -r4
 4f0:	00043c08 	andeq	r3, r4, r8, lsl #24
 4f4:	1a080200 	bne	200cfc <__bss_end+0x1f80f4>
 4f8:	00000059 	andeq	r0, r0, r9, asr r0
 4fc:	8bd80305 	blhi	ff601118 <__bss_end+0xff5f8510>
 500:	4e080000 	cdpmi	0, 0, cr0, cr8, cr0, {0}
 504:	02000004 	andeq	r0, r0, #4
 508:	00591a0a 	subseq	r1, r9, sl, lsl #20
 50c:	03050000 	movweq	r0, #20480	; 0x5000
 510:	00008bdc 	ldrdeq	r8, [r0], -ip
 514:	00042908 	andeq	r2, r4, r8, lsl #18
 518:	1a0c0200 	bne	300d20 <__bss_end+0x2f8118>
 51c:	00000059 	andeq	r0, r0, r9, asr r0
 520:	8be00305 	blhi	ff80113c <__bss_end+0xff7f8534>
 524:	ff060000 			; <UNDEFINED> instruction: 0xff060000
 528:	05000005 	streq	r0, [r0, #-5]
 52c:	00003804 	andeq	r3, r0, r4, lsl #16
 530:	0c0e0200 	sfmeq	f0, 4, [lr], {-0}
 534:	000000f1 	strdeq	r0, [r0], -r1
 538:	00048e07 	andeq	r8, r4, r7, lsl #28
 53c:	a7070000 	strge	r0, [r7, -r0]
 540:	01000004 	tsteq	r0, r4
 544:	00048307 	andeq	r8, r4, r7, lsl #6
 548:	02000200 	andeq	r0, r0, #0, 4
 54c:	041f0201 	ldreq	r0, [pc], #-513	; 554 <shift+0x554>
 550:	04090000 	streq	r0, [r9], #-0
 554:	0000002c 	andeq	r0, r0, ip, lsr #32
 558:	0006540a 	andeq	r5, r6, sl, lsl #8
 55c:	0a440100 	beq	1100964 <__bss_end+0x10f7d5c>
 560:	0000062f 	andeq	r0, r0, pc, lsr #12
 564:	0000004d 	andeq	r0, r0, sp, asr #32
 568:	00008488 	andeq	r8, r0, r8, lsl #9
 56c:	00000050 	andeq	r0, r0, r0, asr r0
 570:	01599c01 	cmpeq	r9, r1, lsl #24
 574:	e00b0000 	and	r0, fp, r0
 578:	01000005 	tsteq	r0, r5
 57c:	004d1944 	subeq	r1, sp, r4, asr #18
 580:	91020000 	mrsls	r0, (UNDEF: 2)
 584:	060f0b6c 	streq	r0, [pc], -ip, ror #22
 588:	44010000 	strmi	r0, [r1], #-0
 58c:	00006530 	andeq	r6, r0, r0, lsr r5
 590:	68910200 	ldmvs	r1, {r9}
 594:	0006650b 	andeq	r6, r6, fp, lsl #10
 598:	41440100 	mrsmi	r0, (UNDEF: 84)
 59c:	00000159 	andeq	r0, r0, r9, asr r1
 5a0:	0c649102 	stfeqp	f1, [r4], #-8
 5a4:	0000072c 	andeq	r0, r0, ip, lsr #14
 5a8:	4d0e4601 	stcmi	6, cr4, [lr, #-4]
 5ac:	02000000 	andeq	r0, r0, #0
 5b0:	0d007491 	cfstrseq	mvf7, [r0, #-580]	; 0xfffffdbc
 5b4:	05260e04 	streq	r0, [r6, #-3588]!	; 0xfffff1fc
 5b8:	3e010000 	cdpcc	0, 0, cr0, cr1, cr0, {0}
 5bc:	00073f06 	andeq	r3, r7, r6, lsl #30
 5c0:	00845c00 	addeq	r5, r4, r0, lsl #24
 5c4:	00002c00 	andeq	r2, r0, r0, lsl #24
 5c8:	859c0100 	ldrhi	r0, [ip, #256]	; 0x100
 5cc:	0b000001 	bleq	5d8 <shift+0x5d8>
 5d0:	000005e0 	andeq	r0, r0, r0, ror #11
 5d4:	4d153e01 	ldcmi	14, cr3, [r5, #-4]
 5d8:	02000000 	andeq	r0, r0, #0
 5dc:	0a007491 	beq	1d828 <__bss_end+0x14c20>
 5e0:	00000538 	andeq	r0, r0, r8, lsr r5
 5e4:	e50a3101 	str	r3, [sl, #-257]	; 0xfffffeff
 5e8:	4d000005 	stcmi	0, cr0, [r0, #-20]	; 0xffffffec
 5ec:	0c000000 	stceq	0, cr0, [r0], {-0}
 5f0:	50000084 	andpl	r0, r0, r4, lsl #1
 5f4:	01000000 	mrseq	r0, (UNDEF: 0)
 5f8:	0001e09c 	muleq	r1, ip, r0
 5fc:	05e00b00 	strbeq	r0, [r0, #2816]!	; 0xb00
 600:	31010000 	mrscc	r0, (UNDEF: 1)
 604:	00004d19 	andeq	r4, r0, r9, lsl sp
 608:	6c910200 	lfmvs	f0, 4, [r1], {0}
 60c:	0007250b 	andeq	r2, r7, fp, lsl #10
 610:	2b310100 	blcs	c40a18 <__bss_end+0xc37e10>
 614:	000000f8 	strdeq	r0, [r0], -r8
 618:	0b689102 	bleq	1a24a28 <__bss_end+0x1a1be20>
 61c:	00000734 	andeq	r0, r0, r4, lsr r7
 620:	4d3c3101 	ldfmis	f3, [ip, #-4]!
 624:	02000000 	andeq	r0, r0, #0
 628:	390c6491 	stmdbcc	ip, {r0, r4, r7, sl, sp, lr}
 62c:	01000007 	tsteq	r0, r7
 630:	004d0e33 	subeq	r0, sp, r3, lsr lr
 634:	91020000 	mrsls	r0, (UNDEF: 2)
 638:	190a0074 	stmdbne	sl, {r2, r4, r5, r6}
 63c:	01000006 	tsteq	r0, r6
 640:	07ae0a24 	streq	r0, [lr, r4, lsr #20]!
 644:	004d0000 	subeq	r0, sp, r0
 648:	83bc0000 			; <UNDEFINED> instruction: 0x83bc0000
 64c:	00500000 	subseq	r0, r0, r0
 650:	9c010000 	stcls	0, cr0, [r1], {-0}
 654:	0000023b 	andeq	r0, r0, fp, lsr r2
 658:	0005e00b 	andeq	lr, r5, fp
 65c:	18240100 	stmdane	r4!, {r8}
 660:	0000004d 	andeq	r0, r0, sp, asr #32
 664:	0b6c9102 	bleq	1b24a74 <__bss_end+0x1b1be6c>
 668:	00000725 	andeq	r0, r0, r5, lsr #14
 66c:	412a2401 			; <UNDEFINED> instruction: 0x412a2401
 670:	02000002 	andeq	r0, r0, #2
 674:	340b6891 	strcc	r6, [fp], #-2193	; 0xfffff76f
 678:	01000007 	tsteq	r0, r7
 67c:	004d3b24 	subeq	r3, sp, r4, lsr #22
 680:	91020000 	mrsls	r0, (UNDEF: 2)
 684:	061e0c64 	ldreq	r0, [lr], -r4, ror #24
 688:	26010000 	strcs	r0, [r1], -r0
 68c:	00004d0e 	andeq	r4, r0, lr, lsl #26
 690:	74910200 	ldrvc	r0, [r1], #512	; 0x200
 694:	25040900 	strcs	r0, [r4, #-2304]	; 0xfffff700
 698:	03000000 	movweq	r0, #0
 69c:	0000023b 	andeq	r0, r0, fp, lsr r2
 6a0:	0007a90a 	andeq	sl, r7, sl, lsl #18
 6a4:	0a180100 	beq	600aac <__bss_end+0x5f7ea4>
 6a8:	000005f3 	strdeq	r0, [r0], -r3
 6ac:	0000004d 	andeq	r0, r0, sp, asr #32
 6b0:	00008378 	andeq	r8, r0, r8, ror r3
 6b4:	00000044 	andeq	r0, r0, r4, asr #32
 6b8:	02929c01 	addseq	r9, r2, #256	; 0x100
 6bc:	d20b0000 	andle	r0, fp, #0
 6c0:	01000005 	tsteq	r0, r5
 6c4:	00f81b18 	rscseq	r1, r8, r8, lsl fp
 6c8:	91020000 	mrsls	r0, (UNDEF: 2)
 6cc:	05db0b6c 	ldrbeq	r0, [fp, #2924]	; 0xb6c
 6d0:	18010000 	stmdane	r1, {}	; <UNPREDICTABLE>
 6d4:	0000cc35 	andeq	ip, r0, r5, lsr ip
 6d8:	68910200 	ldmvs	r1, {r9}
 6dc:	0005e00c 	andeq	lr, r5, ip
 6e0:	0e1a0100 	mufeqe	f0, f2, f0
 6e4:	0000004d 	andeq	r0, r0, sp, asr #32
 6e8:	00749102 	rsbseq	r9, r4, r2, lsl #2
 6ec:	00052c0f 	andeq	r2, r5, pc, lsl #24
 6f0:	06130100 	ldreq	r0, [r3], -r0, lsl #2
 6f4:	0000054c 	andeq	r0, r0, ip, asr #10
 6f8:	0000835c 	andeq	r8, r0, ip, asr r3
 6fc:	0000001c 	andeq	r0, r0, ip, lsl r0
 700:	5d0e9c01 	stcpl	12, cr9, [lr, #-4]
 704:	01000005 	tsteq	r0, r5
 708:	053e060d 	ldreq	r0, [lr, #-1549]!	; 0xfffff9f3
 70c:	83300000 	teqhi	r0, #0
 710:	002c0000 	eoreq	r0, ip, r0
 714:	9c010000 	stcls	0, cr0, [r1], {-0}
 718:	000002d2 	ldrdeq	r0, [r0], -r2
 71c:	00066b0b 	andeq	r6, r6, fp, lsl #22
 720:	140d0100 	strne	r0, [sp], #-256	; 0xffffff00
 724:	00000038 	andeq	r0, r0, r8, lsr r0
 728:	00749102 	rsbseq	r9, r4, r2, lsl #2
 72c:	00064d10 	andeq	r4, r6, r0, lsl sp
 730:	0a030100 	beq	c0b38 <__bss_end+0xb7f30>
 734:	0000065a 	andeq	r0, r0, sl, asr r6
 738:	0000004d 	andeq	r0, r0, sp, asr #32
 73c:	00008304 	andeq	r8, r0, r4, lsl #6
 740:	0000002c 	andeq	r0, r0, ip, lsr #32
 744:	70119c01 	andsvc	r9, r1, r1, lsl #24
 748:	01006469 	tsteq	r0, r9, ror #8
 74c:	004d0e05 	subeq	r0, sp, r5, lsl #28
 750:	91020000 	mrsls	r0, (UNDEF: 2)
 754:	2e000074 	mcrcs	0, 0, r0, cr0, cr4, {3}
 758:	04000003 	streq	r0, [r0], #-3
 75c:	0003d000 	andeq	sp, r3, r0
 760:	74010400 	strvc	r0, [r1], #-1024	; 0xfffffc00
 764:	04000006 	streq	r0, [r0], #-6
 768:	000007de 	ldrdeq	r0, [r0], -lr
 76c:	00000567 	andeq	r0, r0, r7, ror #10
 770:	000084d8 	ldrdeq	r8, [r0], -r8	; <UNPREDICTABLE>
 774:	000004b8 			; <UNDEFINED> instruction: 0x000004b8
 778:	0000063b 	andeq	r0, r0, fp, lsr r6
 77c:	00004902 	andeq	r4, r0, r2, lsl #18
 780:	08400300 	stmdaeq	r0, {r8, r9}^
 784:	05010000 	streq	r0, [r1, #-0]
 788:	00006110 	andeq	r6, r0, r0, lsl r1
 78c:	31301100 	teqcc	r0, r0, lsl #2
 790:	35343332 	ldrcc	r3, [r4, #-818]!	; 0xfffffcce
 794:	39383736 	ldmdbcc	r8!, {r1, r2, r4, r5, r8, r9, sl, ip, sp}
 798:	44434241 	strbmi	r4, [r3], #-577	; 0xfffffdbf
 79c:	00004645 	andeq	r4, r0, r5, asr #12
 7a0:	01030104 	tsteq	r3, r4, lsl #2
 7a4:	00000025 	andeq	r0, r0, r5, lsr #32
 7a8:	00007405 	andeq	r7, r0, r5, lsl #8
 7ac:	00006100 	andeq	r6, r0, r0, lsl #2
 7b0:	00660600 	rsbeq	r0, r6, r0, lsl #12
 7b4:	00100000 	andseq	r0, r0, r0
 7b8:	00005107 	andeq	r5, r0, r7, lsl #2
 7bc:	07040800 	streq	r0, [r4, -r0, lsl #16]
 7c0:	00000cad 	andeq	r0, r0, sp, lsr #25
 7c4:	6b080108 	blvs	200bec <__bss_end+0x1f7fe4>
 7c8:	07000004 	streq	r0, [r0, -r4]
 7cc:	0000006d 	andeq	r0, r0, sp, rrx
 7d0:	00002a09 	andeq	r2, r0, r9, lsl #20
 7d4:	086a0a00 	stmdaeq	sl!, {r9, fp}^
 7d8:	64010000 	strvs	r0, [r1], #-0
 7dc:	00085a06 	andeq	r5, r8, r6, lsl #20
 7e0:	00891000 	addeq	r1, r9, r0
 7e4:	00008000 	andeq	r8, r0, r0
 7e8:	fb9c0100 	blx	fe700bf2 <__bss_end+0xfe6f7fea>
 7ec:	0b000000 	bleq	7f4 <shift+0x7f4>
 7f0:	00637273 	rsbeq	r7, r3, r3, ror r2
 7f4:	fb196401 	blx	659802 <__bss_end+0x650bfa>
 7f8:	02000000 	andeq	r0, r0, #0
 7fc:	640b6491 	strvs	r6, [fp], #-1169	; 0xfffffb6f
 800:	01007473 	tsteq	r0, r3, ror r4
 804:	01022464 	tsteq	r2, r4, ror #8
 808:	91020000 	mrsls	r0, (UNDEF: 2)
 80c:	756e0b60 	strbvc	r0, [lr, #-2912]!	; 0xfffff4a0
 810:	6401006d 	strvs	r0, [r1], #-109	; 0xffffff93
 814:	0001042d 	andeq	r0, r1, sp, lsr #8
 818:	5c910200 	lfmpl	f0, 4, [r1], {0}
 81c:	0008cf0c 	andeq	ip, r8, ip, lsl #30
 820:	0e660100 	poweqs	f0, f6, f0
 824:	0000010b 	andeq	r0, r0, fp, lsl #2
 828:	0c709102 	ldfeqp	f1, [r0], #-8
 82c:	0000084c 	andeq	r0, r0, ip, asr #16
 830:	11086701 	tstne	r8, r1, lsl #14
 834:	02000001 	andeq	r0, r0, #1
 838:	380d6c91 	stmdacc	sp, {r0, r4, r7, sl, fp, sp, lr}
 83c:	48000089 	stmdami	r0, {r0, r3, r7}
 840:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
 844:	69010069 	stmdbvs	r1, {r0, r3, r5, r6}
 848:	0001040b 	andeq	r0, r1, fp, lsl #8
 84c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
 850:	040f0000 	streq	r0, [pc], #-0	; 858 <shift+0x858>
 854:	00000101 	andeq	r0, r0, r1, lsl #2
 858:	12041110 	andne	r1, r4, #16, 2
 85c:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
 860:	040f0074 	streq	r0, [pc], #-116	; 868 <shift+0x868>
 864:	00000074 	andeq	r0, r0, r4, ror r0
 868:	006d040f 	rsbeq	r0, sp, pc, lsl #8
 86c:	c50a0000 	strgt	r0, [sl, #-0]
 870:	01000007 	tsteq	r0, r7
 874:	07d2065c 			; <UNDEFINED> instruction: 0x07d2065c
 878:	88a80000 	stmiahi	r8!, {}	; <UNPREDICTABLE>
 87c:	00680000 	rsbeq	r0, r8, r0
 880:	9c010000 	stcls	0, cr0, [r1], {-0}
 884:	00000176 	andeq	r0, r0, r6, ror r1
 888:	0008c813 	andeq	ip, r8, r3, lsl r8
 88c:	125c0100 	subsne	r0, ip, #0, 2
 890:	00000102 	andeq	r0, r0, r2, lsl #2
 894:	136c9102 	cmnne	ip, #-2147483648	; 0x80000000
 898:	000007cb 	andeq	r0, r0, fp, asr #15
 89c:	041e5c01 	ldreq	r5, [lr], #-3073	; 0xfffff3ff
 8a0:	02000001 	andeq	r0, r0, #1
 8a4:	6d0e6891 	stcvs	8, cr6, [lr, #-580]	; 0xfffffdbc
 8a8:	01006d65 	tsteq	r0, r5, ror #26
 8ac:	0111085e 	tsteq	r1, lr, asr r8
 8b0:	91020000 	mrsls	r0, (UNDEF: 2)
 8b4:	88c40d70 	stmiahi	r4, {r4, r5, r6, r8, sl, fp}^
 8b8:	003c0000 	eorseq	r0, ip, r0
 8bc:	690e0000 	stmdbvs	lr, {}	; <UNPREDICTABLE>
 8c0:	0b600100 	bleq	1800cc8 <__bss_end+0x17f80c0>
 8c4:	00000104 	andeq	r0, r0, r4, lsl #2
 8c8:	00749102 	rsbseq	r9, r4, r2, lsl #2
 8cc:	08711400 	ldmdaeq	r1!, {sl, ip}^
 8d0:	52010000 	andpl	r0, r1, #0
 8d4:	00088a05 	andeq	r8, r8, r5, lsl #20
 8d8:	00010400 	andeq	r0, r1, r0, lsl #8
 8dc:	00885400 	addeq	r5, r8, r0, lsl #8
 8e0:	00005400 	andeq	r5, r0, r0, lsl #8
 8e4:	af9c0100 	svcge	0x009c0100
 8e8:	0b000001 	bleq	8f4 <shift+0x8f4>
 8ec:	52010073 	andpl	r0, r1, #115	; 0x73
 8f0:	00010b18 	andeq	r0, r1, r8, lsl fp
 8f4:	6c910200 	lfmvs	f0, 4, [r1], {0}
 8f8:	0100690e 	tsteq	r0, lr, lsl #18
 8fc:	01040654 	tsteq	r4, r4, asr r6
 900:	91020000 	mrsls	r0, (UNDEF: 2)
 904:	b8140074 	ldmdalt	r4, {r2, r4, r5, r6}
 908:	01000008 	tsteq	r0, r8
 90c:	08780542 	ldmdaeq	r8!, {r1, r6, r8, sl}^
 910:	01040000 	mrseq	r0, (UNDEF: 4)
 914:	87a80000 	strhi	r0, [r8, r0]!
 918:	00ac0000 	adceq	r0, ip, r0
 91c:	9c010000 	stcls	0, cr0, [r1], {-0}
 920:	00000215 	andeq	r0, r0, r5, lsl r2
 924:	0031730b 	eorseq	r7, r1, fp, lsl #6
 928:	0b194201 	bleq	651134 <__bss_end+0x64852c>
 92c:	02000001 	andeq	r0, r0, #1
 930:	730b6c91 	movwvc	r6, #48273	; 0xbc91
 934:	42010032 	andmi	r0, r1, #50	; 0x32
 938:	00010b29 	andeq	r0, r1, r9, lsr #22
 93c:	68910200 	ldmvs	r1, {r9}
 940:	6d756e0b 	ldclvs	14, cr6, [r5, #-44]!	; 0xffffffd4
 944:	31420100 	mrscc	r0, (UNDEF: 82)
 948:	00000104 	andeq	r0, r0, r4, lsl #2
 94c:	0e649102 	lgneqs	f1, f2
 950:	01003175 	tsteq	r0, r5, ror r1
 954:	02151044 	andseq	r1, r5, #68	; 0x44
 958:	91020000 	mrsls	r0, (UNDEF: 2)
 95c:	32750e77 	rsbscc	r0, r5, #1904	; 0x770
 960:	14440100 	strbne	r0, [r4], #-256	; 0xffffff00
 964:	00000215 	andeq	r0, r0, r5, lsl r2
 968:	00769102 	rsbseq	r9, r6, r2, lsl #2
 96c:	62080108 	andvs	r0, r8, #8, 2
 970:	14000004 	strne	r0, [r0], #-4
 974:	000008c0 	andeq	r0, r0, r0, asr #17
 978:	a7073601 	strge	r3, [r7, -r1, lsl #12]
 97c:	11000008 	tstne	r0, r8
 980:	e8000001 	stmda	r0, {r0}
 984:	c0000086 	andgt	r0, r0, r6, lsl #1
 988:	01000000 	mrseq	r0, (UNDEF: 0)
 98c:	0002759c 	muleq	r2, ip, r5
 990:	07c01300 	strbeq	r1, [r0, r0, lsl #6]
 994:	36010000 	strcc	r0, [r1], -r0
 998:	00011115 	andeq	r1, r1, r5, lsl r1
 99c:	6c910200 	lfmvs	f0, 4, [r1], {0}
 9a0:	6372730b 	cmnvs	r2, #738197504	; 0x2c000000
 9a4:	27360100 	ldrcs	r0, [r6, -r0, lsl #2]!
 9a8:	0000010b 	andeq	r0, r0, fp, lsl #2
 9ac:	0b689102 	bleq	1a24dbc <__bss_end+0x1a1c1b4>
 9b0:	006d756e 	rsbeq	r7, sp, lr, ror #10
 9b4:	04303601 	ldrteq	r3, [r0], #-1537	; 0xfffff9ff
 9b8:	02000001 	andeq	r0, r0, #1
 9bc:	690e6491 	stmdbvs	lr, {r0, r4, r7, sl, sp, lr}
 9c0:	06380100 	ldrteq	r0, [r8], -r0, lsl #2
 9c4:	00000104 	andeq	r0, r0, r4, lsl #2
 9c8:	00749102 	rsbseq	r9, r4, r2, lsl #2
 9cc:	00089714 	andeq	r9, r8, r4, lsl r7
 9d0:	05240100 	streq	r0, [r4, #-256]!	; 0xffffff00
 9d4:	0000089c 	muleq	r0, ip, r8
 9d8:	00000104 	andeq	r0, r0, r4, lsl #2
 9dc:	0000864c 	andeq	r8, r0, ip, asr #12
 9e0:	0000009c 	muleq	r0, ip, r0
 9e4:	02b29c01 	adcseq	r9, r2, #256	; 0x100
 9e8:	ba130000 	blt	4c09f0 <__bss_end+0x4b7de8>
 9ec:	01000007 	tsteq	r0, r7
 9f0:	010b1624 	tsteq	fp, r4, lsr #12
 9f4:	91020000 	mrsls	r0, (UNDEF: 2)
 9f8:	08530c6c 	ldmdaeq	r3, {r2, r3, r5, r6, sl, fp}^
 9fc:	26010000 	strcs	r0, [r1], -r0
 a00:	00010406 	andeq	r0, r1, r6, lsl #8
 a04:	74910200 	ldrvc	r0, [r1], #512	; 0x200
 a08:	08d61500 	ldmeq	r6, {r8, sl, ip}^
 a0c:	08010000 	stmdaeq	r1, {}	; <UNPREDICTABLE>
 a10:	0008db06 	andeq	sp, r8, r6, lsl #22
 a14:	0084d800 	addeq	sp, r4, r0, lsl #16
 a18:	00017400 	andeq	r7, r1, r0, lsl #8
 a1c:	139c0100 	orrsne	r0, ip, #0, 2
 a20:	000007ba 			; <UNDEFINED> instruction: 0x000007ba
 a24:	66180801 	ldrvs	r0, [r8], -r1, lsl #16
 a28:	02000000 	andeq	r0, r0, #0
 a2c:	53136491 	tstpl	r3, #-1862270976	; 0x91000000
 a30:	01000008 	tsteq	r0, r8
 a34:	01112508 	tsteq	r1, r8, lsl #10
 a38:	91020000 	mrsls	r0, (UNDEF: 2)
 a3c:	09a71360 	stmibeq	r7!, {r5, r6, r8, r9, ip}
 a40:	08010000 	stmdaeq	r1, {}	; <UNPREDICTABLE>
 a44:	0000663a 	andeq	r6, r0, sl, lsr r6
 a48:	5c910200 	lfmpl	f0, 4, [r1], {0}
 a4c:	0100690e 	tsteq	r0, lr, lsl #18
 a50:	0104060a 	tsteq	r4, sl, lsl #12
 a54:	91020000 	mrsls	r0, (UNDEF: 2)
 a58:	85a40d74 	strhi	r0, [r4, #3444]!	; 0xd74
 a5c:	00980000 	addseq	r0, r8, r0
 a60:	6a0e0000 	bvs	380a68 <__bss_end+0x377e60>
 a64:	0b1c0100 	bleq	700e6c <__bss_end+0x6f8264>
 a68:	00000104 	andeq	r0, r0, r4, lsl #2
 a6c:	0d709102 	ldfeqp	f1, [r0, #-8]!
 a70:	000085cc 	andeq	r8, r0, ip, asr #11
 a74:	00000060 	andeq	r0, r0, r0, rrx
 a78:	0100630e 	tsteq	r0, lr, lsl #6
 a7c:	006d081e 	rsbeq	r0, sp, lr, lsl r8
 a80:	91020000 	mrsls	r0, (UNDEF: 2)
 a84:	0000006f 	andeq	r0, r0, pc, rrx
 a88:	00002200 	andeq	r2, r0, r0, lsl #4
 a8c:	f7000200 			; <UNDEFINED> instruction: 0xf7000200
 a90:	04000004 	streq	r0, [r0], #-4
 a94:	0008de01 	andeq	sp, r8, r1, lsl #28
 a98:	00899000 	addeq	r9, r9, r0
 a9c:	008b9c00 	addeq	r9, fp, r0, lsl #24
 aa0:	0008e700 	andeq	lr, r8, r0, lsl #14
 aa4:	00091700 	andeq	r1, r9, r0, lsl #14
 aa8:	00097f00 	andeq	r7, r9, r0, lsl #30
 aac:	22800100 	addcs	r0, r0, #0, 2
 ab0:	02000000 	andeq	r0, r0, #0
 ab4:	00050b00 	andeq	r0, r5, r0, lsl #22
 ab8:	5b010400 	blpl	41ac0 <__bss_end+0x38eb8>
 abc:	9c000009 	stcls	0, cr0, [r0], {9}
 ac0:	a000008b 	andge	r0, r0, fp, lsl #1
 ac4:	e700008b 	str	r0, [r0, -fp, lsl #1]
 ac8:	17000008 	strne	r0, [r0, -r8]
 acc:	7f000009 	svcvc	0x00000009
 ad0:	01000009 	tsteq	r0, r9
 ad4:	00032a80 	andeq	r2, r3, r0, lsl #21
 ad8:	1f000400 	svcne	0x00000400
 adc:	04000005 	streq	r0, [r0], #-5
 ae0:	000aab01 	andeq	sl, sl, r1, lsl #22
 ae4:	0c640c00 	stcleq	12, cr0, [r4], #-0
 ae8:	09170000 	ldmdbeq	r7, {}	; <UNPREDICTABLE>
 aec:	09bb0000 	ldmibeq	fp!, {}	; <UNPREDICTABLE>
 af0:	04020000 	streq	r0, [r2], #-0
 af4:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
 af8:	07040300 	streq	r0, [r4, -r0, lsl #6]
 afc:	00000cad 	andeq	r0, r0, sp, lsr #25
 b00:	09050803 	stmdbeq	r5, {r0, r1, fp}
 b04:	03000003 	movweq	r0, #3
 b08:	0c580408 	cfldrdeq	mvd0, [r8], {8}
 b0c:	01030000 	mrseq	r0, (UNDEF: 3)
 b10:	00046208 	andeq	r6, r4, r8, lsl #4
 b14:	06010300 	streq	r0, [r1], -r0, lsl #6
 b18:	00000464 	andeq	r0, r0, r4, ror #8
 b1c:	000e3004 	andeq	r3, lr, r4
 b20:	39010700 	stmdbcc	r1, {r8, r9, sl}
 b24:	01000000 	mrseq	r0, (UNDEF: 0)
 b28:	01d40617 	bicseq	r0, r4, r7, lsl r6
 b2c:	ba050000 	blt	140b34 <__bss_end+0x137f2c>
 b30:	00000009 	andeq	r0, r0, r9
 b34:	000edf05 	andeq	sp, lr, r5, lsl #30
 b38:	8d050100 	stfhis	f0, [r5, #-0]
 b3c:	0200000b 	andeq	r0, r0, #11
 b40:	000c4b05 	andeq	r4, ip, r5, lsl #22
 b44:	49050300 	stmdbmi	r5, {r8, r9}
 b48:	0400000e 	streq	r0, [r0], #-14
 b4c:	000eef05 	andeq	lr, lr, r5, lsl #30
 b50:	5f050500 	svcpl	0x00050500
 b54:	0600000e 	streq	r0, [r0], -lr
 b58:	000c9405 	andeq	r9, ip, r5, lsl #8
 b5c:	da050700 	ble	142764 <__bss_end+0x139b5c>
 b60:	0800000d 	stmdaeq	r0, {r0, r2, r3}
 b64:	000de805 	andeq	lr, sp, r5, lsl #16
 b68:	f6050900 			; <UNDEFINED> instruction: 0xf6050900
 b6c:	0a00000d 	beq	ba8 <shift+0xba8>
 b70:	000cfd05 	andeq	pc, ip, r5, lsl #26
 b74:	ed050b00 	vstr	d0, [r5, #-0]
 b78:	0c00000c 	stceq	0, cr0, [r0], {12}
 b7c:	0009d605 	andeq	sp, r9, r5, lsl #12
 b80:	ef050d00 	svc	0x00050d00
 b84:	0e000009 	cdpeq	0, 0, cr0, cr0, cr9, {0}
 b88:	000cde05 	andeq	sp, ip, r5, lsl #28
 b8c:	a2050f00 	andge	r0, r5, #0, 30
 b90:	1000000e 	andne	r0, r0, lr
 b94:	000e1f05 	andeq	r1, lr, r5, lsl #30
 b98:	93051100 	movwls	r1, #20736	; 0x5100
 b9c:	1200000e 	andne	r0, r0, #14
 ba0:	000a9c05 	andeq	r9, sl, r5, lsl #24
 ba4:	19051300 	stmdbne	r5, {r8, r9, ip}
 ba8:	1400000a 	strne	r0, [r0], #-10
 bac:	0009e305 	andeq	lr, r9, r5, lsl #6
 bb0:	7c051500 	cfstr32vc	mvfx1, [r5], {-0}
 bb4:	1600000d 	strne	r0, [r0], -sp
 bb8:	000a5005 	andeq	r5, sl, r5
 bbc:	8b051700 	blhi	1467c4 <__bss_end+0x13dbbc>
 bc0:	18000009 	stmdane	r0, {r0, r3}
 bc4:	000e8505 	andeq	r8, lr, r5, lsl #10
 bc8:	ba051900 	blt	146fd0 <__bss_end+0x13e3c8>
 bcc:	1a00000c 	bne	c04 <shift+0xc04>
 bd0:	000d9405 	andeq	r9, sp, r5, lsl #8
 bd4:	24051b00 	strcs	r1, [r5], #-2816	; 0xfffff500
 bd8:	1c00000a 	stcne	0, cr0, [r0], {10}
 bdc:	000c3005 	andeq	r3, ip, r5
 be0:	7f051d00 	svcvc	0x00051d00
 be4:	1e00000b 	cdpne	0, 0, cr0, cr0, cr11, {0}
 be8:	000e1105 	andeq	r1, lr, r5, lsl #2
 bec:	6d051f00 	stcvs	15, cr1, [r5, #-0]
 bf0:	2000000e 	andcs	r0, r0, lr
 bf4:	000eae05 	andeq	sl, lr, r5, lsl #28
 bf8:	bc052100 	stflts	f2, [r5], {-0}
 bfc:	2200000e 	andcs	r0, r0, #14
 c00:	000cd105 	andeq	sp, ip, r5, lsl #2
 c04:	f4052300 	vst2.8	{d2-d5}, [r5], r0
 c08:	2400000b 	strcs	r0, [r0], #-11
 c0c:	000a3305 	andeq	r3, sl, r5, lsl #6
 c10:	87052500 	strhi	r2, [r5, -r0, lsl #10]
 c14:	2600000c 	strcs	r0, [r0], -ip
 c18:	000b9905 	andeq	r9, fp, r5, lsl #18
 c1c:	3c052700 	stccc	7, cr2, [r5], {-0}
 c20:	2800000e 	stmdacs	r0, {r1, r2, r3}
 c24:	000ba905 	andeq	sl, fp, r5, lsl #18
 c28:	b8052900 	stmdalt	r5, {r8, fp, sp}
 c2c:	2a00000b 	bcs	c60 <shift+0xc60>
 c30:	000bc705 	andeq	ip, fp, r5, lsl #14
 c34:	d6052b00 	strle	r2, [r5], -r0, lsl #22
 c38:	2c00000b 	stccs	0, cr0, [r0], {11}
 c3c:	000b6405 	andeq	r6, fp, r5, lsl #8
 c40:	e5052d00 	str	r2, [r5, #-3328]	; 0xfffff300
 c44:	2e00000b 	cdpcs	0, 0, cr0, cr0, cr11, {0}
 c48:	000dcb05 	andeq	ip, sp, r5, lsl #22
 c4c:	03052f00 	movweq	r2, #24320	; 0x5f00
 c50:	3000000c 	andcc	r0, r0, ip
 c54:	000c1205 	andeq	r1, ip, r5, lsl #4
 c58:	c4053100 	strgt	r3, [r5], #-256	; 0xffffff00
 c5c:	32000009 	andcc	r0, r0, #9
 c60:	000d1c05 	andeq	r1, sp, r5, lsl #24
 c64:	2c053300 	stccs	3, cr3, [r5], {-0}
 c68:	3400000d 	strcc	r0, [r0], #-13
 c6c:	000d3c05 	andeq	r3, sp, r5, lsl #24
 c70:	52053500 	andpl	r3, r5, #0, 10
 c74:	3600000b 	strcc	r0, [r0], -fp
 c78:	000d4c05 	andeq	r4, sp, r5, lsl #24
 c7c:	5c053700 	stcpl	7, cr3, [r5], {-0}
 c80:	3800000d 	stmdacc	r0, {r0, r2, r3}
 c84:	000d6c05 	andeq	r6, sp, r5, lsl #24
 c88:	43053900 	movwmi	r3, #22784	; 0x5900
 c8c:	3a00000a 	bcc	cbc <shift+0xcbc>
 c90:	0009fc05 	andeq	pc, r9, r5, lsl #24
 c94:	21053b00 	tstcs	r5, r0, lsl #22
 c98:	3c00000c 	stccc	0, cr0, [r0], {12}
 c9c:	00099b05 	andeq	r9, r9, r5, lsl #22
 ca0:	87053d00 	strhi	r3, [r5, -r0, lsl #26]
 ca4:	3e00000d 	cdpcc	0, 0, cr0, cr0, cr13, {0}
 ca8:	0a830600 	beq	fe0c24b0 <__bss_end+0xfe0b98a8>
 cac:	01020000 	mrseq	r0, (UNDEF: 2)
 cb0:	ff08026b 			; <UNDEFINED> instruction: 0xff08026b
 cb4:	07000001 	streq	r0, [r0, -r1]
 cb8:	00000c46 	andeq	r0, r0, r6, asr #24
 cbc:	14027001 	strne	r7, [r2], #-1
 cc0:	00000047 	andeq	r0, r0, r7, asr #32
 cc4:	0b5f0700 	bleq	17c28cc <__bss_end+0x17b9cc4>
 cc8:	71010000 	mrsvc	r0, (UNDEF: 1)
 ccc:	00471402 	subeq	r1, r7, r2, lsl #8
 cd0:	00010000 	andeq	r0, r1, r0
 cd4:	0001d408 	andeq	sp, r1, r8, lsl #8
 cd8:	01ff0900 	mvnseq	r0, r0, lsl #18
 cdc:	02140000 	andseq	r0, r4, #0
 ce0:	240a0000 	strcs	r0, [sl], #-0
 ce4:	11000000 	mrsne	r0, (UNDEF: 0)
 ce8:	02040800 	andeq	r0, r4, #0, 16
 cec:	0a0b0000 	beq	2c0cf4 <__bss_end+0x2b80ec>
 cf0:	0100000d 	tsteq	r0, sp
 cf4:	14260274 	strtne	r0, [r6], #-628	; 0xfffffd8c
 cf8:	24000002 	strcs	r0, [r0], #-2
 cfc:	3d0a3d3a 	stccc	13, cr3, [sl, #-232]	; 0xffffff18
 d00:	3d243d0f 	stccc	13, cr3, [r4, #-60]!	; 0xffffffc4
 d04:	3d023d32 	stccc	13, cr3, [r2, #-200]	; 0xffffff38
 d08:	3d133d05 	ldccc	13, cr3, [r3, #-20]	; 0xffffffec
 d0c:	3d0c3d0d 	stccc	13, cr3, [ip, #-52]	; 0xffffffcc
 d10:	3d113d23 	ldccc	13, cr3, [r1, #-140]	; 0xffffff74
 d14:	3d013d26 	stccc	13, cr3, [r1, #-152]	; 0xffffff68
 d18:	3d083d17 	stccc	13, cr3, [r8, #-92]	; 0xffffffa4
 d1c:	00003d09 	andeq	r3, r0, r9, lsl #26
 d20:	70070203 	andvc	r0, r7, r3, lsl #4
 d24:	03000004 	movweq	r0, #4
 d28:	046b0801 	strbteq	r0, [fp], #-2049	; 0xfffff7ff
 d2c:	0d0c0000 	stceq	0, cr0, [ip, #-0]
 d30:	00025904 	andeq	r5, r2, r4, lsl #18
 d34:	0eca0e00 	cdpeq	14, 12, cr0, cr10, cr0, {0}
 d38:	01070000 	mrseq	r0, (UNDEF: 7)
 d3c:	00000039 	andeq	r0, r0, r9, lsr r0
 d40:	0604f702 	streq	pc, [r4], -r2, lsl #14
 d44:	0000029e 	muleq	r0, lr, r2
 d48:	000a5d05 	andeq	r5, sl, r5, lsl #26
 d4c:	68050000 	stmdavs	r5, {}	; <UNPREDICTABLE>
 d50:	0100000a 	tsteq	r0, sl
 d54:	000a7a05 	andeq	r7, sl, r5, lsl #20
 d58:	94050200 	strls	r0, [r5], #-512	; 0xfffffe00
 d5c:	0300000a 	movweq	r0, #10
 d60:	000e0405 	andeq	r0, lr, r5, lsl #8
 d64:	73050400 	movwvc	r0, #21504	; 0x5400
 d68:	0500000b 	streq	r0, [r0, #-11]
 d6c:	000dbd05 	andeq	fp, sp, r5, lsl #26
 d70:	03000600 	movweq	r0, #1536	; 0x600
 d74:	049d0502 	ldreq	r0, [sp], #1282	; 0x502
 d78:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
 d7c:	000ca307 	andeq	sl, ip, r7, lsl #6
 d80:	04040300 	streq	r0, [r4], #-768	; 0xfffffd00
 d84:	000009b4 			; <UNDEFINED> instruction: 0x000009b4
 d88:	ac030803 	stcge	8, cr0, [r3], {3}
 d8c:	03000009 	movweq	r0, #9
 d90:	0c5d0408 	cfldrdeq	mvd0, [sp], {8}
 d94:	10030000 	andne	r0, r3, r0
 d98:	000dae03 	andeq	sl, sp, r3, lsl #28
 d9c:	0da50f00 	stceq	15, cr0, [r5]
 da0:	2a030000 	bcs	c0da8 <__bss_end+0xb81a0>
 da4:	00025a10 	andeq	r5, r2, r0, lsl sl
 da8:	02c80900 	sbceq	r0, r8, #0, 18
 dac:	02df0000 	sbcseq	r0, pc, #0
 db0:	00100000 	andseq	r0, r0, r0
 db4:	0003d211 	andeq	sp, r3, r1, lsl r2
 db8:	112f0300 			; <UNDEFINED> instruction: 0x112f0300
 dbc:	000002d4 	ldrdeq	r0, [r0], -r4
 dc0:	00026811 	andeq	r6, r2, r1, lsl r8
 dc4:	11300300 	teqne	r0, r0, lsl #6
 dc8:	000002d4 	ldrdeq	r0, [r0], -r4
 dcc:	0002c809 	andeq	ip, r2, r9, lsl #16
 dd0:	00030700 	andeq	r0, r3, r0, lsl #14
 dd4:	00240a00 	eoreq	r0, r4, r0, lsl #20
 dd8:	00010000 	andeq	r0, r1, r0
 ddc:	0002df12 	andeq	sp, r2, r2, lsl pc
 de0:	09330400 	ldmdbeq	r3!, {sl}
 de4:	0002f70a 	andeq	pc, r2, sl, lsl #14
 de8:	f5030500 			; <UNDEFINED> instruction: 0xf5030500
 dec:	1200008b 	andne	r0, r0, #139	; 0x8b
 df0:	000002eb 	andeq	r0, r0, fp, ror #5
 df4:	0a093404 	beq	24de0c <__bss_end+0x245204>
 df8:	000002f7 	strdeq	r0, [r0], -r7
 dfc:	8bf50305 	blhi	ffd41a18 <__bss_end+0xffd38e10>
 e00:	Address 0x0000000000000e00 is out of bounds.


Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
   0:	10001101 	andne	r1, r0, r1, lsl #2
   4:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
   8:	1b0e0301 	blne	380c14 <__bss_end+0x37800c>
   c:	130e250e 	movwne	r2, #58638	; 0xe50e
  10:	00000005 	andeq	r0, r0, r5
  14:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
  18:	030b130e 	movweq	r1, #45838	; 0xb30e
  1c:	110e1b0e 	tstne	lr, lr, lsl #22
  20:	10061201 	andne	r1, r6, r1, lsl #4
  24:	02000017 	andeq	r0, r0, #23
  28:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  2c:	0b3b0b3a 	bleq	ec2d1c <__bss_end+0xeba114>
  30:	13490b39 	movtne	r0, #39737	; 0x9b39
  34:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
  38:	24030000 	strcs	r0, [r3], #-0
  3c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
  40:	000e030b 	andeq	r0, lr, fp, lsl #6
  44:	012e0400 			; <UNDEFINED> instruction: 0x012e0400
  48:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
  4c:	0b3b0b3a 	bleq	ec2d3c <__bss_end+0xeba134>
  50:	01110b39 	tsteq	r1, r9, lsr fp
  54:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
  58:	01194296 			; <UNDEFINED> instruction: 0x01194296
  5c:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
  60:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  64:	0b3b0b3a 	bleq	ec2d54 <__bss_end+0xeba14c>
  68:	13490b39 	movtne	r0, #39737	; 0x9b39
  6c:	00001802 	andeq	r1, r0, r2, lsl #16
  70:	0b002406 	bleq	9090 <__bss_end+0x488>
  74:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
  78:	07000008 	streq	r0, [r0, -r8]
  7c:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
  80:	0b3a0e03 	bleq	e83894 <__bss_end+0xe7ac8c>
  84:	0b390b3b 	bleq	e42d78 <__bss_end+0xe3a170>
  88:	06120111 			; <UNDEFINED> instruction: 0x06120111
  8c:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
  90:	00130119 	andseq	r0, r3, r9, lsl r1
  94:	000f0800 	andeq	r0, pc, r0, lsl #16
  98:	13490b0b 	movtne	r0, #39691	; 0x9b0b
  9c:	01000000 	mrseq	r0, (UNDEF: 0)
  a0:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
  a4:	0e030b13 	vmoveq.32	d3[0], r0
  a8:	01110e1b 	tsteq	r1, fp, lsl lr
  ac:	17100612 			; <UNDEFINED> instruction: 0x17100612
  b0:	16020000 	strne	r0, [r2], -r0
  b4:	3a0e0300 	bcc	380cbc <__bss_end+0x3780b4>
  b8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
  bc:	0013490b 	andseq	r4, r3, fp, lsl #18
  c0:	000f0300 	andeq	r0, pc, r0, lsl #6
  c4:	13490b0b 	movtne	r0, #39691	; 0x9b0b
  c8:	15040000 	strne	r0, [r4, #-0]
  cc:	05000000 	streq	r0, [r0, #-0]
  d0:	13490101 	movtne	r0, #37121	; 0x9101
  d4:	00001301 	andeq	r1, r0, r1, lsl #6
  d8:	49002106 	stmdbmi	r0, {r1, r2, r8, sp}
  dc:	00062f13 	andeq	r2, r6, r3, lsl pc
  e0:	00240700 	eoreq	r0, r4, r0, lsl #14
  e4:	0b3e0b0b 	bleq	f82d18 <__bss_end+0xf7a110>
  e8:	00000e03 	andeq	r0, r0, r3, lsl #28
  ec:	03003408 	movweq	r3, #1032	; 0x408
  f0:	3b0b3a0e 	blcc	2ce930 <__bss_end+0x2c5d28>
  f4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
  f8:	3c193f13 	ldccc	15, cr3, [r9], {19}
  fc:	09000019 	stmdbeq	r0, {r0, r3, r4}
 100:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 104:	0b3a0e03 	bleq	e83918 <__bss_end+0xe7ad10>
 108:	0b390b3b 	bleq	e42dfc <__bss_end+0xe3a1f4>
 10c:	01111349 	tsteq	r1, r9, asr #6
 110:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 114:	01194296 			; <UNDEFINED> instruction: 0x01194296
 118:	0a000013 	beq	16c <shift+0x16c>
 11c:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 120:	0b3b0b3a 	bleq	ec2e10 <__bss_end+0xeba208>
 124:	13490b39 	movtne	r0, #39737	; 0x9b39
 128:	00001802 	andeq	r1, r0, r2, lsl #16
 12c:	0b00240b 	bleq	9160 <__bss_end+0x558>
 130:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 134:	0c000008 	stceq	0, cr0, [r0], {8}
 138:	193f002e 	ldmdbne	pc!, {r1, r2, r3, r5}	; <UNPREDICTABLE>
 13c:	0b3a0e03 	bleq	e83950 <__bss_end+0xe7ad48>
 140:	0b390b3b 	bleq	e42e34 <__bss_end+0xe3a22c>
 144:	06120111 			; <UNDEFINED> instruction: 0x06120111
 148:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 14c:	0d000019 	stceq	0, cr0, [r0, #-100]	; 0xffffff9c
 150:	0e030139 	mcreq	1, 0, r0, cr3, cr9, {1}
 154:	0b3b0b3a 	bleq	ec2e44 <__bss_end+0xeba23c>
 158:	00001301 	andeq	r1, r0, r1, lsl #6
 15c:	3f012e0e 	svccc	0x00012e0e
 160:	3a0e0319 	bcc	380dcc <__bss_end+0x3781c4>
 164:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 168:	01193c0b 	tsteq	r9, fp, lsl #24
 16c:	0f000013 	svceq	0x00000013
 170:	13490005 	movtne	r0, #36869	; 0x9005
 174:	2e100000 	cdpcs	0, 1, cr0, cr0, cr0, {0}
 178:	03193f01 	tsteq	r9, #1, 30
 17c:	3b0b3a0e 	blcc	2ce9bc <__bss_end+0x2c5db4>
 180:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 184:	00193c13 	andseq	r3, r9, r3, lsl ip
 188:	012e1100 			; <UNDEFINED> instruction: 0x012e1100
 18c:	01111347 	tsteq	r1, r7, asr #6
 190:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 194:	01194297 			; <UNDEFINED> instruction: 0x01194297
 198:	12000013 	andne	r0, r0, #19
 19c:	13490005 	movtne	r0, #36869	; 0x9005
 1a0:	00001802 	andeq	r1, r0, r2, lsl #16
 1a4:	03000513 	movweq	r0, #1299	; 0x513
 1a8:	3b0b3a08 	blcc	2ce9d0 <__bss_end+0x2c5dc8>
 1ac:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 1b0:	00180213 	andseq	r0, r8, r3, lsl r2
 1b4:	012e1400 			; <UNDEFINED> instruction: 0x012e1400
 1b8:	01111347 	tsteq	r1, r7, asr #6
 1bc:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 1c0:	00194297 	mulseq	r9, r7, r2
 1c4:	11010000 	mrsne	r0, (UNDEF: 1)
 1c8:	130e2501 	movwne	r2, #58625	; 0xe501
 1cc:	1b0e030b 	blne	380e00 <__bss_end+0x3781f8>
 1d0:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 1d4:	00171006 	andseq	r1, r7, r6
 1d8:	00240200 	eoreq	r0, r4, r0, lsl #4
 1dc:	0b3e0b0b 	bleq	f82e10 <__bss_end+0xf7a208>
 1e0:	00000e03 	andeq	r0, r0, r3, lsl #28
 1e4:	49002603 	stmdbmi	r0, {r0, r1, r9, sl, sp}
 1e8:	04000013 	streq	r0, [r0], #-19	; 0xffffffed
 1ec:	0b0b0024 	bleq	2c0284 <__bss_end+0x2b767c>
 1f0:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
 1f4:	35050000 	strcc	r0, [r5, #-0]
 1f8:	00134900 	andseq	r4, r3, r0, lsl #18
 1fc:	00160600 	andseq	r0, r6, r0, lsl #12
 200:	0b3a0e03 	bleq	e83a14 <__bss_end+0xe7ae0c>
 204:	0b390b3b 	bleq	e42ef8 <__bss_end+0xe3a2f0>
 208:	00001349 	andeq	r1, r0, r9, asr #6
 20c:	03003407 	movweq	r3, #1031	; 0x407
 210:	3b0b3a0e 	blcc	2cea50 <__bss_end+0x2c5e48>
 214:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 218:	02196c13 	andseq	r6, r9, #4864	; 0x1300
 21c:	08000018 	stmdaeq	r0, {r3, r4}
 220:	0e030104 	adfeqs	f0, f3, f4
 224:	0b3e196d 	bleq	f867e0 <__bss_end+0xf7dbd8>
 228:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 22c:	0b3b0b3a 	bleq	ec2f1c <__bss_end+0xeba314>
 230:	13010b39 	movwne	r0, #6969	; 0x1b39
 234:	28090000 	stmdacs	r9, {}	; <UNPREDICTABLE>
 238:	1c0e0300 	stcne	3, cr0, [lr], {-0}
 23c:	0a00000b 	beq	270 <shift+0x270>
 240:	13490101 	movtne	r0, #37121	; 0x9101
 244:	00001301 	andeq	r1, r0, r1, lsl #6
 248:	4900210b 	stmdbmi	r0, {r0, r1, r3, r8, sp}
 24c:	000b2f13 	andeq	r2, fp, r3, lsl pc
 250:	000f0c00 	andeq	r0, pc, r0, lsl #24
 254:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 258:	2e0d0000 	cdpcs	0, 0, cr0, cr13, cr0, {0}
 25c:	03193f01 	tsteq	r9, #1, 30
 260:	3b0b3a0e 	blcc	2ceaa0 <__bss_end+0x2c5e98>
 264:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 268:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 26c:	96184006 	ldrls	r4, [r8], -r6
 270:	13011942 	movwne	r1, #6466	; 0x1942
 274:	050e0000 	streq	r0, [lr, #-0]
 278:	3a0e0300 	bcc	380e80 <__bss_end+0x378278>
 27c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 280:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 284:	0f000018 	svceq	0x00000018
 288:	08030034 	stmdaeq	r3, {r2, r4, r5}
 28c:	0b3b0b3a 	bleq	ec2f7c <__bss_end+0xeba374>
 290:	13490b39 	movtne	r0, #39737	; 0x9b39
 294:	00001802 	andeq	r1, r0, r2, lsl #16
 298:	03003410 	movweq	r3, #1040	; 0x410
 29c:	3b0b3a0e 	blcc	2ceadc <__bss_end+0x2c5ed4>
 2a0:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 2a4:	00180213 	andseq	r0, r8, r3, lsl r2
 2a8:	11010000 	mrsne	r0, (UNDEF: 1)
 2ac:	130e2501 	movwne	r2, #58625	; 0xe501
 2b0:	1b0e030b 	blne	380ee4 <__bss_end+0x3782dc>
 2b4:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 2b8:	00171006 	andseq	r1, r7, r6
 2bc:	00240200 	eoreq	r0, r4, r0, lsl #4
 2c0:	0b3e0b0b 	bleq	f82ef4 <__bss_end+0xf7a2ec>
 2c4:	00000e03 	andeq	r0, r0, r3, lsl #28
 2c8:	49002603 	stmdbmi	r0, {r0, r1, r9, sl, sp}
 2cc:	04000013 	streq	r0, [r0], #-19	; 0xffffffed
 2d0:	0b0b0024 	bleq	2c0368 <__bss_end+0x2b7760>
 2d4:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
 2d8:	16050000 	strne	r0, [r5], -r0
 2dc:	3a0e0300 	bcc	380ee4 <__bss_end+0x3782dc>
 2e0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 2e4:	0013490b 	andseq	r4, r3, fp, lsl #18
 2e8:	01040600 	tsteq	r4, r0, lsl #12
 2ec:	196d0e03 	stmdbne	sp!, {r0, r1, r9, sl, fp}^
 2f0:	0b0b0b3e 	bleq	2c2ff0 <__bss_end+0x2ba3e8>
 2f4:	0b3a1349 	bleq	e85020 <__bss_end+0xe7c418>
 2f8:	0b390b3b 	bleq	e42fec <__bss_end+0xe3a3e4>
 2fc:	00001301 	andeq	r1, r0, r1, lsl #6
 300:	03002807 	movweq	r2, #2055	; 0x807
 304:	000b1c0e 	andeq	r1, fp, lr, lsl #24
 308:	00340800 	eorseq	r0, r4, r0, lsl #16
 30c:	0b3a0e03 	bleq	e83b20 <__bss_end+0xe7af18>
 310:	0b390b3b 	bleq	e43004 <__bss_end+0xe3a3fc>
 314:	196c1349 	stmdbne	ip!, {r0, r3, r6, r8, r9, ip}^
 318:	00001802 	andeq	r1, r0, r2, lsl #16
 31c:	0b000f09 	bleq	3f48 <shift+0x3f48>
 320:	0013490b 	andseq	r4, r3, fp, lsl #18
 324:	012e0a00 			; <UNDEFINED> instruction: 0x012e0a00
 328:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 32c:	0b3b0b3a 	bleq	ec301c <__bss_end+0xeba414>
 330:	0e6e0b39 	vmoveq.8	d14[5], r0
 334:	01111349 	tsteq	r1, r9, asr #6
 338:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 33c:	01194297 			; <UNDEFINED> instruction: 0x01194297
 340:	0b000013 	bleq	394 <shift+0x394>
 344:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
 348:	0b3b0b3a 	bleq	ec3038 <__bss_end+0xeba430>
 34c:	13490b39 	movtne	r0, #39737	; 0x9b39
 350:	00001802 	andeq	r1, r0, r2, lsl #16
 354:	0300340c 	movweq	r3, #1036	; 0x40c
 358:	3b0b3a0e 	blcc	2ceb98 <__bss_end+0x2c5f90>
 35c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 360:	00180213 	andseq	r0, r8, r3, lsl r2
 364:	000f0d00 	andeq	r0, pc, r0, lsl #26
 368:	00000b0b 	andeq	r0, r0, fp, lsl #22
 36c:	3f012e0e 	svccc	0x00012e0e
 370:	3a0e0319 	bcc	380fdc <__bss_end+0x3783d4>
 374:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 378:	110e6e0b 	tstne	lr, fp, lsl #28
 37c:	40061201 	andmi	r1, r6, r1, lsl #4
 380:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 384:	00001301 	andeq	r1, r0, r1, lsl #6
 388:	3f002e0f 	svccc	0x00002e0f
 38c:	3a0e0319 	bcc	380ff8 <__bss_end+0x3783f0>
 390:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 394:	110e6e0b 	tstne	lr, fp, lsl #28
 398:	40061201 	andmi	r1, r6, r1, lsl #4
 39c:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 3a0:	2e100000 	cdpcs	0, 1, cr0, cr0, cr0, {0}
 3a4:	03193f01 	tsteq	r9, #1, 30
 3a8:	3b0b3a0e 	blcc	2cebe8 <__bss_end+0x2c5fe0>
 3ac:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 3b0:	1113490e 	tstne	r3, lr, lsl #18
 3b4:	40061201 	andmi	r1, r6, r1, lsl #4
 3b8:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 3bc:	34110000 	ldrcc	r0, [r1], #-0
 3c0:	3a080300 	bcc	200fc8 <__bss_end+0x1f83c0>
 3c4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 3c8:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 3cc:	00000018 	andeq	r0, r0, r8, lsl r0
 3d0:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
 3d4:	030b130e 	movweq	r1, #45838	; 0xb30e
 3d8:	110e1b0e 	tstne	lr, lr, lsl #22
 3dc:	10061201 	andne	r1, r6, r1, lsl #4
 3e0:	02000017 	andeq	r0, r0, #23
 3e4:	13010139 	movwne	r0, #4409	; 0x1139
 3e8:	34030000 	strcc	r0, [r3], #-0
 3ec:	3a0e0300 	bcc	380ff4 <__bss_end+0x3783ec>
 3f0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 3f4:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
 3f8:	000a1c19 	andeq	r1, sl, r9, lsl ip
 3fc:	003a0400 	eorseq	r0, sl, r0, lsl #8
 400:	0b3b0b3a 	bleq	ec30f0 <__bss_end+0xeba4e8>
 404:	13180b39 	tstne	r8, #58368	; 0xe400
 408:	01050000 	mrseq	r0, (UNDEF: 5)
 40c:	01134901 	tsteq	r3, r1, lsl #18
 410:	06000013 			; <UNDEFINED> instruction: 0x06000013
 414:	13490021 	movtne	r0, #36897	; 0x9021
 418:	00000b2f 	andeq	r0, r0, pc, lsr #22
 41c:	49002607 	stmdbmi	r0, {r0, r1, r2, r9, sl, sp}
 420:	08000013 	stmdaeq	r0, {r0, r1, r4}
 424:	0b0b0024 	bleq	2c04bc <__bss_end+0x2b78b4>
 428:	0e030b3e 	vmoveq.16	d3[0], r0
 42c:	34090000 	strcc	r0, [r9], #-0
 430:	00134700 	andseq	r4, r3, r0, lsl #14
 434:	012e0a00 			; <UNDEFINED> instruction: 0x012e0a00
 438:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 43c:	0b3b0b3a 	bleq	ec312c <__bss_end+0xeba524>
 440:	0e6e0b39 	vmoveq.8	d14[5], r0
 444:	06120111 			; <UNDEFINED> instruction: 0x06120111
 448:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 44c:	00130119 	andseq	r0, r3, r9, lsl r1
 450:	00050b00 	andeq	r0, r5, r0, lsl #22
 454:	0b3a0803 	bleq	e82468 <__bss_end+0xe79860>
 458:	0b390b3b 	bleq	e4314c <__bss_end+0xe3a544>
 45c:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 460:	340c0000 	strcc	r0, [ip], #-0
 464:	3a0e0300 	bcc	38106c <__bss_end+0x378464>
 468:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 46c:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 470:	0d000018 	stceq	0, cr0, [r0, #-96]	; 0xffffffa0
 474:	0111010b 	tsteq	r1, fp, lsl #2
 478:	00000612 	andeq	r0, r0, r2, lsl r6
 47c:	0300340e 	movweq	r3, #1038	; 0x40e
 480:	3b0b3a08 	blcc	2ceca8 <__bss_end+0x2c60a0>
 484:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 488:	00180213 	andseq	r0, r8, r3, lsl r2
 48c:	000f0f00 	andeq	r0, pc, r0, lsl #30
 490:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 494:	26100000 	ldrcs	r0, [r0], -r0
 498:	11000000 	mrsne	r0, (UNDEF: 0)
 49c:	0b0b000f 	bleq	2c04e0 <__bss_end+0x2b78d8>
 4a0:	24120000 	ldrcs	r0, [r2], #-0
 4a4:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 4a8:	0008030b 	andeq	r0, r8, fp, lsl #6
 4ac:	00051300 	andeq	r1, r5, r0, lsl #6
 4b0:	0b3a0e03 	bleq	e83cc4 <__bss_end+0xe7b0bc>
 4b4:	0b390b3b 	bleq	e431a8 <__bss_end+0xe3a5a0>
 4b8:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 4bc:	2e140000 	cdpcs	0, 1, cr0, cr4, cr0, {0}
 4c0:	03193f01 	tsteq	r9, #1, 30
 4c4:	3b0b3a0e 	blcc	2ced04 <__bss_end+0x2c60fc>
 4c8:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 4cc:	1113490e 	tstne	r3, lr, lsl #18
 4d0:	40061201 	andmi	r1, r6, r1, lsl #4
 4d4:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 4d8:	00001301 	andeq	r1, r0, r1, lsl #6
 4dc:	3f012e15 	svccc	0x00012e15
 4e0:	3a0e0319 	bcc	38114c <__bss_end+0x378544>
 4e4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 4e8:	110e6e0b 	tstne	lr, fp, lsl #28
 4ec:	40061201 	andmi	r1, r6, r1, lsl #4
 4f0:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
 4f4:	01000000 	mrseq	r0, (UNDEF: 0)
 4f8:	06100011 			; <UNDEFINED> instruction: 0x06100011
 4fc:	01120111 	tsteq	r2, r1, lsl r1
 500:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
 504:	05130e25 	ldreq	r0, [r3, #-3621]	; 0xfffff1db
 508:	01000000 	mrseq	r0, (UNDEF: 0)
 50c:	06100011 			; <UNDEFINED> instruction: 0x06100011
 510:	01120111 	tsteq	r2, r1, lsl r1
 514:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
 518:	05130e25 	ldreq	r0, [r3, #-3621]	; 0xfffff1db
 51c:	01000000 	mrseq	r0, (UNDEF: 0)
 520:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
 524:	0e030b13 	vmoveq.32	d3[0], r0
 528:	17100e1b 			; <UNDEFINED> instruction: 0x17100e1b
 52c:	24020000 	strcs	r0, [r2], #-0
 530:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 534:	0008030b 	andeq	r0, r8, fp, lsl #6
 538:	00240300 	eoreq	r0, r4, r0, lsl #6
 53c:	0b3e0b0b 	bleq	f83170 <__bss_end+0xf7a568>
 540:	00000e03 	andeq	r0, r0, r3, lsl #28
 544:	03010404 	movweq	r0, #5124	; 0x1404
 548:	0b0b3e0e 	bleq	2cfd88 <__bss_end+0x2c7180>
 54c:	3a13490b 	bcc	4d2980 <__bss_end+0x4c9d78>
 550:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 554:	0013010b 	andseq	r0, r3, fp, lsl #2
 558:	00280500 	eoreq	r0, r8, r0, lsl #10
 55c:	0b1c0e03 	bleq	703d70 <__bss_end+0x6fb168>
 560:	13060000 	movwne	r0, #24576	; 0x6000
 564:	0b0e0301 	bleq	381170 <__bss_end+0x378568>
 568:	3b0b3a0b 	blcc	2ced9c <__bss_end+0x2c6194>
 56c:	010b3905 	tsteq	fp, r5, lsl #18
 570:	07000013 	smladeq	r0, r3, r0, r0
 574:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 578:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 57c:	13490b39 	movtne	r0, #39737	; 0x9b39
 580:	00000b38 	andeq	r0, r0, r8, lsr fp
 584:	49002608 	stmdbmi	r0, {r3, r9, sl, sp}
 588:	09000013 	stmdbeq	r0, {r0, r1, r4}
 58c:	13490101 	movtne	r0, #37121	; 0x9101
 590:	00001301 	andeq	r1, r0, r1, lsl #6
 594:	4900210a 	stmdbmi	r0, {r1, r3, r8, sp}
 598:	000b2f13 	andeq	r2, fp, r3, lsl pc
 59c:	00340b00 	eorseq	r0, r4, r0, lsl #22
 5a0:	0b3a0e03 	bleq	e83db4 <__bss_end+0xe7b1ac>
 5a4:	0b39053b 	bleq	e41a98 <__bss_end+0xe38e90>
 5a8:	0a1c1349 	beq	7052d4 <__bss_end+0x6fc6cc>
 5ac:	150c0000 	strne	r0, [ip, #-0]
 5b0:	00192700 	andseq	r2, r9, r0, lsl #14
 5b4:	000f0d00 	andeq	r0, pc, r0, lsl #26
 5b8:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 5bc:	040e0000 	streq	r0, [lr], #-0
 5c0:	3e0e0301 	cdpcc	3, 0, cr0, cr14, cr1, {0}
 5c4:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
 5c8:	3b0b3a13 	blcc	2cee1c <__bss_end+0x2c6214>
 5cc:	010b3905 	tsteq	fp, r5, lsl #18
 5d0:	0f000013 	svceq	0x00000013
 5d4:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
 5d8:	0b3b0b3a 	bleq	ec32c8 <__bss_end+0xeba6c0>
 5dc:	13490b39 	movtne	r0, #39737	; 0x9b39
 5e0:	21100000 	tstcs	r0, r0
 5e4:	11000000 	mrsne	r0, (UNDEF: 0)
 5e8:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 5ec:	0b3b0b3a 	bleq	ec32dc <__bss_end+0xeba6d4>
 5f0:	13490b39 	movtne	r0, #39737	; 0x9b39
 5f4:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
 5f8:	34120000 	ldrcc	r0, [r2], #-0
 5fc:	3a134700 	bcc	4d2204 <__bss_end+0x4c95fc>
 600:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 604:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 608:	00000018 	andeq	r0, r0, r8, lsl r0

Disassembly of section .debug_aranges:

00000000 <.debug_aranges>:
   0:	0000001c 	andeq	r0, r0, ip, lsl r0
   4:	00000002 	andeq	r0, r0, r2
   8:	00040000 	andeq	r0, r4, r0
   c:	00000000 	andeq	r0, r0, r0
  10:	00008000 	andeq	r8, r0, r0
  14:	00000008 	andeq	r0, r0, r8
	...
  20:	0000001c 	andeq	r0, r0, ip, lsl r0
  24:	00260002 	eoreq	r0, r6, r2
  28:	00040000 	andeq	r0, r4, r0
  2c:	00000000 	andeq	r0, r0, r0
  30:	00008008 	andeq	r8, r0, r8
  34:	0000009c 	muleq	r0, ip, r0
	...
  40:	0000001c 	andeq	r0, r0, ip, lsl r0
  44:	00c40002 	sbceq	r0, r4, r2
  48:	00040000 	andeq	r0, r4, r0
  4c:	00000000 	andeq	r0, r0, r0
  50:	000080a4 	andeq	r8, r0, r4, lsr #1
  54:	00000188 	andeq	r0, r0, r8, lsl #3
	...
  60:	0000001c 	andeq	r0, r0, ip, lsl r0
  64:	02ca0002 	sbceq	r0, sl, #2
  68:	00040000 	andeq	r0, r4, r0
  6c:	00000000 	andeq	r0, r0, r0
  70:	0000822c 	andeq	r8, r0, ip, lsr #4
  74:	000000d8 	ldrdeq	r0, [r0], -r8
	...
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	045a0002 	ldrbeq	r0, [sl], #-2
  88:	00040000 	andeq	r0, r4, r0
  8c:	00000000 	andeq	r0, r0, r0
  90:	00008304 	andeq	r8, r0, r4, lsl #6
  94:	000001d4 	ldrdeq	r0, [r0], -r4
	...
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	07570002 	ldrbeq	r0, [r7, -r2]
  a8:	00040000 	andeq	r0, r4, r0
  ac:	00000000 	andeq	r0, r0, r0
  b0:	000084d8 	ldrdeq	r8, [r0], -r8	; <UNPREDICTABLE>
  b4:	000004b8 			; <UNDEFINED> instruction: 0x000004b8
	...
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	0a890002 	beq	fe2400d4 <__bss_end+0xfe2374cc>
  c8:	00040000 	andeq	r0, r4, r0
  cc:	00000000 	andeq	r0, r0, r0
  d0:	00008990 	muleq	r0, r0, r9
  d4:	0000020c 	andeq	r0, r0, ip, lsl #4
	...
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	0aaf0002 	beq	febc00f4 <__bss_end+0xfebb74ec>
  e8:	00040000 	andeq	r0, r4, r0
  ec:	00000000 	andeq	r0, r0, r0
  f0:	00008b9c 	muleq	r0, ip, fp
  f4:	00000004 	andeq	r0, r0, r4
	...
 100:	00000014 	andeq	r0, r0, r4, lsl r0
 104:	0ad50002 	beq	ff540114 <__bss_end+0xff53750c>
 108:	00040000 	andeq	r0, r4, r0
	...

Disassembly of section .debug_str:

00000000 <.debug_str>:
   0:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
   4:	552f632f 	strpl	r6, [pc, #-815]!	; fffffcdd <__bss_end+0xffff70d5>
   8:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
   c:	62754b2f 	rsbsvs	r4, r5, #48128	; 0xbc00
  10:	6f442f61 	svcvs	0x00442f61
  14:	656d7563 	strbvs	r7, [sp, #-1379]!	; 0xfffffa9d
  18:	2f73746e 	svccs	0x0073746e
  1c:	6f686353 	svcvs	0x00686353
  20:	5a2f6c6f 	bpl	bdb1e4 <__bss_end+0xbd25dc>
  24:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; fffffe98 <__bss_end+0xffff7290>
  28:	2f657461 	svccs	0x00657461
  2c:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
  30:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
  34:	2d36312f 	ldfcss	f3, [r6, #-188]!	; 0xffffff44
  38:	69676170 	stmdbvs	r7!, {r4, r5, r6, r8, sp, lr}^
  3c:	755f676e 	ldrbvc	r6, [pc, #-1902]	; fffff8d6 <__bss_end+0xffff6cce>
  40:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
  44:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
  48:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
  4c:	61707372 	cmnvs	r0, r2, ror r3
  50:	632f6563 			; <UNDEFINED> instruction: 0x632f6563
  54:	2e307472 	mrccs	4, 1, r7, cr0, cr2, {3}
  58:	6d2f0073 	stcvs	0, cr0, [pc, #-460]!	; fffffe94 <__bss_end+0xffff728c>
  5c:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
  60:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
  64:	4b2f7372 	blmi	bdce34 <__bss_end+0xbd422c>
  68:	2f616275 	svccs	0x00616275
  6c:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
  70:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
  74:	63532f73 	cmpvs	r3, #460	; 0x1cc
  78:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; fffffee0 <__bss_end+0xffff72d8>
  7c:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
  80:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
  84:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
  88:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
  8c:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
  90:	61702d36 	cmnvs	r0, r6, lsr sp
  94:	676e6967 	strbvs	r6, [lr, -r7, ror #18]!
  98:	6573755f 	ldrbvs	r7, [r3, #-1375]!	; 0xfffffaa1
  9c:	61707372 	cmnvs	r0, r2, ror r3
  a0:	752f6563 	strvc	r6, [pc, #-1379]!	; fffffb45 <__bss_end+0xffff6f3d>
  a4:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
  a8:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
  ac:	6975622f 	ldmdbvs	r5!, {r0, r1, r2, r3, r5, r9, sp, lr}^
  b0:	4700646c 	strmi	r6, [r0, -ip, ror #8]
  b4:	4120554e 			; <UNDEFINED> instruction: 0x4120554e
  b8:	2e322053 	mrccs	0, 1, r2, cr2, cr3, {2}
  bc:	47003833 	smladxmi	r0, r3, r8, r3
  c0:	4320554e 			; <UNDEFINED> instruction: 0x4320554e
  c4:	31203731 			; <UNDEFINED> instruction: 0x31203731
  c8:	2e332e30 	mrccs	14, 1, r2, cr3, cr0, {1}
  cc:	30322031 	eorscc	r2, r2, r1, lsr r0
  d0:	36303132 			; <UNDEFINED> instruction: 0x36303132
  d4:	28203132 	stmdacs	r0!, {r1, r4, r5, r8, ip, sp}
  d8:	656c6572 	strbvs	r6, [ip, #-1394]!	; 0xfffffa8e
  dc:	29657361 	stmdbcs	r5!, {r0, r5, r6, r8, r9, ip, sp, lr}^
  e0:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
  e4:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
  e8:	6962612d 	stmdbvs	r2!, {r0, r2, r3, r5, r8, sp, lr}^
  ec:	7261683d 	rsbvc	r6, r1, #3997696	; 0x3d0000
  f0:	6d2d2064 	stcvs	0, cr2, [sp, #-400]!	; 0xfffffe70
  f4:	3d757066 	ldclcc	0, cr7, [r5, #-408]!	; 0xfffffe68
  f8:	20706676 	rsbscs	r6, r0, r6, ror r6
  fc:	6c666d2d 	stclvs	13, cr6, [r6], #-180	; 0xffffff4c
 100:	2d74616f 	ldfcse	f6, [r4, #-444]!	; 0xfffffe44
 104:	3d696261 	sfmcc	f6, 2, [r9, #-388]!	; 0xfffffe7c
 108:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
 10c:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
 110:	763d7570 			; <UNDEFINED> instruction: 0x763d7570
 114:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
 118:	6e75746d 	cdpvs	4, 7, cr7, cr5, cr13, {3}
 11c:	72613d65 	rsbvc	r3, r1, #6464	; 0x1940
 120:	3731316d 	ldrcc	r3, [r1, -sp, ror #2]!
 124:	667a6a36 			; <UNDEFINED> instruction: 0x667a6a36
 128:	2d20732d 	stccs	3, cr7, [r0, #-180]!	; 0xffffff4c
 12c:	6d72616d 	ldfvse	f6, [r2, #-436]!	; 0xfffffe4c
 130:	616d2d20 	cmnvs	sp, r0, lsr #26
 134:	3d686372 	stclcc	3, cr6, [r8, #-456]!	; 0xfffffe38
 138:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
 13c:	2b6b7a36 	blcs	1adea1c <__bss_end+0x1ad5e14>
 140:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
 144:	672d2067 	strvs	r2, [sp, -r7, rrx]!
 148:	304f2d20 	subcc	r2, pc, r0, lsr #26
 14c:	304f2d20 	subcc	r2, pc, r0, lsr #26
 150:	625f5f00 	subsvs	r5, pc, #0, 30
 154:	655f7373 	ldrbvs	r7, [pc, #-883]	; fffffde9 <__bss_end+0xffff71e1>
 158:	7200646e 	andvc	r6, r0, #1845493760	; 0x6e000000
 15c:	6c757365 	ldclvs	3, cr7, [r5], #-404	; 0xfffffe6c
 160:	6d2f0074 	stcvs	0, cr0, [pc, #-464]!	; ffffff98 <__bss_end+0xffff7390>
 164:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
 168:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
 16c:	4b2f7372 	blmi	bdcf3c <__bss_end+0xbd4334>
 170:	2f616275 	svccs	0x00616275
 174:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
 178:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
 17c:	63532f73 	cmpvs	r3, #460	; 0x1cc
 180:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; ffffffe8 <__bss_end+0xffff73e0>
 184:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
 188:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
 18c:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 190:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
 194:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
 198:	61702d36 	cmnvs	r0, r6, lsr sp
 19c:	676e6967 	strbvs	r6, [lr, -r7, ror #18]!
 1a0:	6573755f 	ldrbvs	r7, [r3, #-1375]!	; 0xfffffaa1
 1a4:	61707372 	cmnvs	r0, r2, ror r3
 1a8:	752f6563 	strvc	r6, [pc, #-1379]!	; fffffc4d <__bss_end+0xffff7045>
 1ac:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 1b0:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
 1b4:	7472632f 	ldrbtvc	r6, [r2], #-815	; 0xfffffcd1
 1b8:	00632e30 	rsbeq	r2, r3, r0, lsr lr
 1bc:	73625f5f 	cmnvc	r2, #380	; 0x17c
 1c0:	74735f73 	ldrbtvc	r5, [r3], #-3955	; 0xfffff08d
 1c4:	00747261 	rsbseq	r7, r4, r1, ror #4
 1c8:	72635f5f 	rsbvc	r5, r3, #380	; 0x17c
 1cc:	695f3074 	ldmdbvs	pc, {r2, r4, r5, r6, ip, sp}^	; <UNPREDICTABLE>
 1d0:	5f74696e 	svcpl	0x0074696e
 1d4:	00737362 	rsbseq	r7, r3, r2, ror #6
 1d8:	69676562 	stmdbvs	r7!, {r1, r5, r6, r8, sl, sp, lr}^
 1dc:	5f5f006e 	svcpl	0x005f006e
 1e0:	30747263 	rsbscc	r7, r4, r3, ror #4
 1e4:	6e75725f 	mrcvs	2, 3, r7, cr5, cr15, {2}
 1e8:	675f5f00 	ldrbvs	r5, [pc, -r0, lsl #30]
 1ec:	64726175 	ldrbtvs	r6, [r2], #-373	; 0xfffffe8b
 1f0:	615f5f00 	cmpvs	pc, r0, lsl #30
 1f4:	69626165 	stmdbvs	r2!, {r0, r2, r5, r6, r8, sp, lr}^
 1f8:	776e755f 			; <UNDEFINED> instruction: 0x776e755f
 1fc:	5f646e69 	svcpl	0x00646e69
 200:	5f707063 	svcpl	0x00707063
 204:	00317270 	eorseq	r7, r1, r0, ror r2
 208:	7070635f 	rsbsvc	r6, r0, pc, asr r3
 20c:	7568735f 	strbvc	r7, [r8, #-863]!	; 0xfffffca1
 210:	776f6474 			; <UNDEFINED> instruction: 0x776f6474
 214:	6e66006e 	cdpvs	0, 6, cr0, cr6, cr14, {3}
 218:	00727470 	rsbseq	r7, r2, r0, ror r4
 21c:	78635f5f 	stmdavc	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, sl, fp, ip, lr}^
 220:	69626178 	stmdbvs	r2!, {r3, r4, r5, r6, r8, sp, lr}^
 224:	5f003176 	svcpl	0x00003176
 228:	6178635f 	cmnvs	r8, pc, asr r3
 22c:	7275705f 	rsbsvc	r7, r5, #95	; 0x5f
 230:	69765f65 	ldmdbvs	r6!, {r0, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
 234:	61757472 	cmnvs	r5, r2, ror r4
 238:	5f5f006c 	svcpl	0x005f006c
 23c:	5f617863 	svcpl	0x00617863
 240:	72617567 	rsbvc	r7, r1, #432013312	; 0x19c00000
 244:	65725f64 	ldrbvs	r5, [r2, #-3940]!	; 0xfffff09c
 248:	7361656c 	cmnvc	r1, #108, 10	; 0x1b000000
 24c:	5f5f0065 	svcpl	0x005f0065
 250:	524f5443 	subpl	r5, pc, #1124073472	; 0x43000000
 254:	444e455f 	strbmi	r4, [lr], #-1375	; 0xfffffaa1
 258:	5f005f5f 	svcpl	0x00005f5f
 25c:	6f73645f 	svcvs	0x0073645f
 260:	6e61685f 	mcrvs	8, 3, r6, cr1, cr15, {2}
 264:	00656c64 	rsbeq	r6, r5, r4, ror #24
 268:	54445f5f 	strbpl	r5, [r4], #-3935	; 0xfffff0a1
 26c:	4c5f524f 	lfmmi	f5, 2, [pc], {79}	; 0x4f
 270:	5f545349 	svcpl	0x00545349
 274:	5f5f005f 	svcpl	0x005f005f
 278:	5f617863 	svcpl	0x00617863
 27c:	72617567 	rsbvc	r7, r1, #432013312	; 0x19c00000
 280:	62615f64 	rsbvs	r5, r1, #100, 30	; 0x190
 284:	0074726f 	rsbseq	r7, r4, pc, ror #4
 288:	726f7464 	rsbvc	r7, pc, #100, 8	; 0x64000000
 28c:	7274705f 	rsbsvc	r7, r4, #95	; 0x5f
 290:	6e6d2f00 	cdpvs	15, 6, cr2, cr13, cr0, {0}
 294:	2f632f74 	svccs	0x00632f74
 298:	72657355 	rsbvc	r7, r5, #1409286145	; 0x54000001
 29c:	754b2f73 	strbvc	r2, [fp, #-3955]	; 0xfffff08d
 2a0:	442f6162 	strtmi	r6, [pc], #-354	; 2a8 <shift+0x2a8>
 2a4:	6d75636f 	ldclvs	3, cr6, [r5, #-444]!	; 0xfffffe44
 2a8:	73746e65 	cmnvc	r4, #1616	; 0x650
 2ac:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
 2b0:	2f6c6f6f 	svccs	0x006c6f6f
 2b4:	6f72655a 	svcvs	0x0072655a
 2b8:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
 2bc:	6178652f 	cmnvs	r8, pc, lsr #10
 2c0:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
 2c4:	36312f73 	shsub16cc	r2, r1, r3
 2c8:	6761702d 	strbvs	r7, [r1, -sp, lsr #32]!
 2cc:	5f676e69 	svcpl	0x00676e69
 2d0:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
 2d4:	63617073 	cmnvs	r1, #115	; 0x73
 2d8:	73752f65 	cmnvc	r5, #404	; 0x194
 2dc:	70737265 	rsbsvc	r7, r3, r5, ror #4
 2e0:	2f656361 	svccs	0x00656361
 2e4:	61787863 	cmnvs	r8, r3, ror #16
 2e8:	632e6962 			; <UNDEFINED> instruction: 0x632e6962
 2ec:	5f007070 	svcpl	0x00007070
 2f0:	4f54445f 	svcmi	0x0054445f
 2f4:	4e455f52 	mcrmi	15, 2, r5, cr5, cr2, {2}
 2f8:	005f5f44 	subseq	r5, pc, r4, asr #30
 2fc:	78635f5f 	stmdavc	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, sl, fp, ip, lr}^
 300:	74615f61 	strbtvc	r5, [r1], #-3937	; 0xfffff09f
 304:	74697865 	strbtvc	r7, [r9], #-2149	; 0xfffff79b
 308:	6e6f6c00 	cdpvs	12, 6, cr6, cr15, cr0, {0}
 30c:	6f6c2067 	svcvs	0x006c2067
 310:	6920676e 	stmdbvs	r0!, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}
 314:	5f00746e 	svcpl	0x0000746e
 318:	5f707063 	svcpl	0x00707063
 31c:	72617473 	rsbvc	r7, r1, #1929379840	; 0x73000000
 320:	00707574 	rsbseq	r7, r0, r4, ror r5
 324:	20554e47 	subscs	r4, r5, r7, asr #28
 328:	312b2b43 			; <UNDEFINED> instruction: 0x312b2b43
 32c:	30312034 	eorscc	r2, r1, r4, lsr r0
 330:	312e332e 			; <UNDEFINED> instruction: 0x312e332e
 334:	32303220 	eorscc	r3, r0, #32, 4
 338:	32363031 	eorscc	r3, r6, #49	; 0x31
 33c:	72282031 	eorvc	r2, r8, #49	; 0x31
 340:	61656c65 	cmnvs	r5, r5, ror #24
 344:	20296573 	eorcs	r6, r9, r3, ror r5
 348:	6c666d2d 	stclvs	13, cr6, [r6], #-180	; 0xffffff4c
 34c:	2d74616f 	ldfcse	f6, [r4, #-444]!	; 0xfffffe44
 350:	3d696261 	sfmcc	f6, 2, [r9, #-388]!	; 0xfffffe7c
 354:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
 358:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
 35c:	763d7570 			; <UNDEFINED> instruction: 0x763d7570
 360:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
 364:	6f6c666d 	svcvs	0x006c666d
 368:	612d7461 			; <UNDEFINED> instruction: 0x612d7461
 36c:	683d6962 	ldmdavs	sp!, {r1, r5, r6, r8, fp, sp, lr}
 370:	20647261 	rsbcs	r7, r4, r1, ror #4
 374:	70666d2d 	rsbvc	r6, r6, sp, lsr #26
 378:	66763d75 			; <UNDEFINED> instruction: 0x66763d75
 37c:	6d2d2070 	stcvs	0, cr2, [sp, #-448]!	; 0xfffffe40
 380:	656e7574 	strbvs	r7, [lr, #-1396]!	; 0xfffffa8c
 384:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
 388:	36373131 			; <UNDEFINED> instruction: 0x36373131
 38c:	2d667a6a 	vstmdbcs	r6!, {s15-s120}
 390:	6d2d2073 	stcvs	0, cr2, [sp, #-460]!	; 0xfffffe34
 394:	206d7261 	rsbcs	r7, sp, r1, ror #4
 398:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
 39c:	613d6863 	teqvs	sp, r3, ror #16
 3a0:	36766d72 			; <UNDEFINED> instruction: 0x36766d72
 3a4:	662b6b7a 			; <UNDEFINED> instruction: 0x662b6b7a
 3a8:	672d2070 			; <UNDEFINED> instruction: 0x672d2070
 3ac:	20672d20 	rsbcs	r2, r7, r0, lsr #26
 3b0:	20304f2d 	eorscs	r4, r0, sp, lsr #30
 3b4:	20304f2d 	eorscs	r4, r0, sp, lsr #30
 3b8:	6f6e662d 	svcvs	0x006e662d
 3bc:	6378652d 	cmnvs	r8, #188743680	; 0xb400000
 3c0:	69747065 	ldmdbvs	r4!, {r0, r2, r5, r6, ip, sp, lr}^
 3c4:	20736e6f 	rsbscs	r6, r3, pc, ror #28
 3c8:	6f6e662d 	svcvs	0x006e662d
 3cc:	7474722d 	ldrbtvc	r7, [r4], #-557	; 0xfffffdd3
 3d0:	5f5f0069 	svcpl	0x005f0069
 3d4:	524f5443 	subpl	r5, pc, #1124073472	; 0x43000000
 3d8:	53494c5f 	movtpl	r4, #40031	; 0x9c5f
 3dc:	005f5f54 	subseq	r5, pc, r4, asr pc	; <UNPREDICTABLE>
 3e0:	726f7463 	rsbvc	r7, pc, #1660944384	; 0x63000000
 3e4:	7274705f 	rsbsvc	r7, r4, #95	; 0x5f
 3e8:	635f5f00 	cmpvs	pc, #0, 30
 3ec:	675f6178 			; <UNDEFINED> instruction: 0x675f6178
 3f0:	64726175 	ldrbtvs	r6, [r2], #-373	; 0xfffffe8b
 3f4:	7163615f 	cmnvc	r3, pc, asr r1
 3f8:	65726975 	ldrbvs	r6, [r2, #-2421]!	; 0xfffff68b
 3fc:	6d756e00 	ldclvs	14, cr6, [r5, #-0]
 400:	00667562 	rsbeq	r7, r6, r2, ror #10
 404:	4678614d 	ldrbtmi	r6, [r8], -sp, asr #2
 408:	69724453 	ldmdbvs	r2!, {r0, r1, r4, r6, sl, lr}^
 40c:	4e726576 	mrcmi	5, 3, r6, cr2, cr6, {3}
 410:	4c656d61 	stclmi	13, cr6, [r5], #-388	; 0xfffffe7c
 414:	74676e65 	strbtvc	r6, [r7], #-3685	; 0xfffff19b
 418:	72610068 	rsbvc	r0, r1, #104	; 0x68
 41c:	62007667 	andvs	r7, r0, #108003328	; 0x6700000
 420:	006c6f6f 	rsbeq	r6, ip, pc, ror #30
 424:	66646e72 			; <UNDEFINED> instruction: 0x66646e72
 428:	466f4e00 	strbtmi	r4, [pc], -r0, lsl #28
 42c:	73656c69 	cmnvc	r5, #26880	; 0x6900
 430:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
 434:	6972446d 	ldmdbvs	r2!, {r0, r2, r3, r5, r6, sl, lr}^
 438:	00726576 	rsbseq	r6, r2, r6, ror r5
 43c:	4678614d 	ldrbtmi	r6, [r8], -sp, asr #2
 440:	6e656c69 	cdpvs	12, 6, cr6, cr5, cr9, {3}
 444:	4c656d61 	stclmi	13, cr6, [r5], #-388	; 0xfffffe7c
 448:	74676e65 	strbtvc	r6, [r7], #-3685	; 0xfffff19b
 44c:	614d0068 	cmpvs	sp, r8, rrx
 450:	74615078 	strbtvc	r5, [r1], #-120	; 0xffffff88
 454:	6e654c68 	cdpvs	12, 6, cr4, cr5, cr8, {3}
 458:	00687467 	rsbeq	r7, r8, r7, ror #8
 45c:	75626472 	strbvc	r6, [r2, #-1138]!	; 0xfffffb8e
 460:	6e750066 	cdpvs	0, 7, cr0, cr5, cr6, {3}
 464:	6e676973 			; <UNDEFINED> instruction: 0x6e676973
 468:	63206465 			; <UNDEFINED> instruction: 0x63206465
 46c:	00726168 	rsbseq	r6, r2, r8, ror #2
 470:	726f6873 	rsbvc	r6, pc, #7536640	; 0x730000
 474:	6e752074 	mrcvs	0, 3, r2, cr5, cr4, {3}
 478:	6e676973 			; <UNDEFINED> instruction: 0x6e676973
 47c:	69206465 	stmdbvs	r0!, {r0, r2, r5, r6, sl, sp, lr}
 480:	5200746e 	andpl	r7, r0, #1845493760	; 0x6e000000
 484:	5f646165 	svcpl	0x00646165
 488:	74697257 	strbtvc	r7, [r9], #-599	; 0xfffffda9
 48c:	65520065 	ldrbvs	r0, [r2, #-101]	; 0xffffff9b
 490:	4f5f6461 	svcmi	0x005f6461
 494:	00796c6e 	rsbseq	r6, r9, lr, ror #24
 498:	63677261 	cmnvs	r7, #268435462	; 0x10000006
 49c:	6f687300 	svcvs	0x00687300
 4a0:	69207472 	stmdbvs	r0!, {r1, r4, r5, r6, sl, ip, sp, lr}
 4a4:	5700746e 	strpl	r7, [r0, -lr, ror #8]
 4a8:	65746972 	ldrbvs	r6, [r4, #-2418]!	; 0xfffff68e
 4ac:	6c6e4f5f 	stclvs	15, cr4, [lr], #-380	; 0xfffffe84
 4b0:	69750079 	ldmdbvs	r5!, {r0, r3, r4, r5, r6}^
 4b4:	3233746e 	eorscc	r7, r3, #1845493760	; 0x6e000000
 4b8:	2f00745f 	svccs	0x0000745f
 4bc:	2f746e6d 	svccs	0x00746e6d
 4c0:	73552f63 	cmpvc	r5, #396	; 0x18c
 4c4:	2f737265 	svccs	0x00737265
 4c8:	6162754b 	cmnvs	r2, fp, asr #10
 4cc:	636f442f 	cmnvs	pc, #788529152	; 0x2f000000
 4d0:	6e656d75 	mcrvs	13, 3, r6, cr5, cr5, {3}
 4d4:	532f7374 			; <UNDEFINED> instruction: 0x532f7374
 4d8:	6f6f6863 	svcvs	0x006f6863
 4dc:	655a2f6c 	ldrbvs	r2, [sl, #-3948]	; 0xfffff094
 4e0:	614d6f72 	hvcvs	55026	; 0xd6f2
 4e4:	652f6574 	strvs	r6, [pc, #-1396]!	; ffffff78 <__bss_end+0xffff7370>
 4e8:	706d6178 	rsbvc	r6, sp, r8, ror r1
 4ec:	2f73656c 	svccs	0x0073656c
 4f0:	702d3631 	eorvc	r3, sp, r1, lsr r6
 4f4:	6e696761 	cdpvs	7, 6, cr6, cr9, cr1, {3}
 4f8:	73755f67 	cmnvc	r5, #412	; 0x19c
 4fc:	70737265 	rsbsvc	r7, r3, r5, ror #4
 500:	2f656361 	svccs	0x00656361
 504:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
 508:	63617073 	cmnvs	r1, #115	; 0x73
 50c:	65742f65 	ldrbvs	r2, [r4, #-3941]!	; 0xfffff09b
 510:	705f7473 	subsvc	r7, pc, r3, ror r4	; <UNPREDICTABLE>
 514:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
 518:	325f7373 	subscc	r7, pc, #-872415231	; 0xcc000001
 51c:	69616d2f 	stmdbvs	r1!, {r0, r1, r2, r3, r5, r8, sl, fp, sp, lr}^
 520:	70632e6e 	rsbvc	r2, r3, lr, ror #28
 524:	6c630070 	stclvs	0, cr0, [r3], #-448	; 0xfffffe40
 528:	0065736f 	rsbeq	r7, r5, pc, ror #6
 52c:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
 530:	69795f64 	ldmdbvs	r9!, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
 534:	00646c65 	rsbeq	r6, r4, r5, ror #24
 538:	74697277 	strbtvc	r7, [r9], #-631	; 0xfffffd89
 53c:	5a5f0065 	bpl	17c06d8 <__bss_end+0x17b7ad0>
 540:	72657439 	rsbvc	r7, r5, #956301312	; 0x39000000
 544:	616e696d 	cmnvs	lr, sp, ror #18
 548:	00696574 	rsbeq	r6, r9, r4, ror r5
 54c:	31315a5f 	teqcc	r1, pc, asr sl
 550:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
 554:	69795f64 	ldmdbvs	r9!, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
 558:	76646c65 	strbtvc	r6, [r4], -r5, ror #24
 55c:	72657400 	rsbvc	r7, r5, #0, 8
 560:	616e696d 	cmnvs	lr, sp, ror #18
 564:	2f006574 	svccs	0x00006574
 568:	2f746e6d 	svccs	0x00746e6d
 56c:	73552f63 	cmpvc	r5, #396	; 0x18c
 570:	2f737265 	svccs	0x00737265
 574:	6162754b 	cmnvs	r2, fp, asr #10
 578:	636f442f 	cmnvs	pc, #788529152	; 0x2f000000
 57c:	6e656d75 	mcrvs	13, 3, r6, cr5, cr5, {3}
 580:	532f7374 			; <UNDEFINED> instruction: 0x532f7374
 584:	6f6f6863 	svcvs	0x006f6863
 588:	655a2f6c 	ldrbvs	r2, [sl, #-3948]	; 0xfffff094
 58c:	614d6f72 	hvcvs	55026	; 0xd6f2
 590:	652f6574 	strvs	r6, [pc, #-1396]!	; 24 <shift+0x24>
 594:	706d6178 	rsbvc	r6, sp, r8, ror r1
 598:	2f73656c 	svccs	0x0073656c
 59c:	702d3631 	eorvc	r3, sp, r1, lsr r6
 5a0:	6e696761 	cdpvs	7, 6, cr6, cr9, cr1, {3}
 5a4:	73755f67 	cmnvc	r5, #412	; 0x19c
 5a8:	70737265 	rsbsvc	r7, r3, r5, ror #4
 5ac:	2f656361 	svccs	0x00656361
 5b0:	6c697562 	cfstr64vs	mvdx7, [r9], #-392	; 0xfffffe78
 5b4:	65470064 	strbvs	r0, [r7, #-100]	; 0xffffff9c
 5b8:	61505f74 	cmpvs	r0, r4, ror pc
 5bc:	736d6172 	cmnvc	sp, #-2147483620	; 0x8000001c
 5c0:	4f494e00 	svcmi	0x00494e00
 5c4:	5f6c7443 	svcpl	0x006c7443
 5c8:	7265704f 	rsbvc	r7, r5, #79	; 0x4f
 5cc:	6f697461 	svcvs	0x00697461
 5d0:	6966006e 	stmdbvs	r6!, {r1, r2, r3, r5, r6}^
 5d4:	616e656c 	cmnvs	lr, ip, ror #10
 5d8:	6d00656d 	cfstr32vs	mvfx6, [r0, #-436]	; 0xfffffe4c
 5dc:	0065646f 	rsbeq	r6, r5, pc, ror #8
 5e0:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
 5e4:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
 5e8:	74697277 	strbtvc	r7, [r9], #-631	; 0xfffffd89
 5ec:	4b506a65 	blmi	141af88 <__bss_end+0x1412380>
 5f0:	5f006a63 	svcpl	0x00006a63
 5f4:	706f345a 	rsbvc	r3, pc, sl, asr r4	; <UNPREDICTABLE>
 5f8:	4b506e65 	blmi	141bf94 <__bss_end+0x141338c>
 5fc:	4e353163 	rsfmisz	f3, f5, f3
 600:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
 604:	65704f5f 	ldrbvs	r4, [r0, #-3935]!	; 0xfffff0a1
 608:	6f4d5f6e 	svcvs	0x004d5f6e
 60c:	6f006564 	svcvs	0x00006564
 610:	61726570 	cmnvs	r2, r0, ror r5
 614:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
 618:	61657200 	cmnvs	r5, r0, lsl #4
 61c:	64720064 	ldrbtvs	r0, [r2], #-100	; 0xffffff9c
 620:	006d756e 	rsbeq	r7, sp, lr, ror #10
 624:	5f746553 	svcpl	0x00746553
 628:	61726150 	cmnvs	r2, r0, asr r1
 62c:	5f00736d 	svcpl	0x0000736d
 630:	6f69355a 	svcvs	0x0069355a
 634:	6a6c7463 	bvs	1b1d7c8 <__bss_end+0x1b14bc0>
 638:	494e3631 	stmdbmi	lr, {r0, r4, r5, r9, sl, ip, sp}^
 63c:	6c74434f 	ldclvs	3, cr4, [r4], #-316	; 0xfffffec4
 640:	65704f5f 	ldrbvs	r4, [r0, #-3935]!	; 0xfffff0a1
 644:	69746172 	ldmdbvs	r4!, {r1, r4, r5, r6, r8, sp, lr}^
 648:	76506e6f 	ldrbvc	r6, [r0], -pc, ror #28
 64c:	74656700 	strbtvc	r6, [r5], #-1792	; 0xfffff900
 650:	00646970 	rsbeq	r6, r4, r0, ror r9
 654:	74636f69 	strbtvc	r6, [r3], #-3945	; 0xfffff097
 658:	5a5f006c 	bpl	17c0810 <__bss_end+0x17b7c08>
 65c:	74656736 	strbtvc	r6, [r5], #-1846	; 0xfffff8ca
 660:	76646970 			; <UNDEFINED> instruction: 0x76646970
 664:	72617000 	rsbvc	r7, r1, #0
 668:	65006d61 	strvs	r6, [r0, #-3425]	; 0xfffff29f
 66c:	63746978 	cmnvs	r4, #120, 18	; 0x1e0000
 670:	0065646f 	rsbeq	r6, r5, pc, ror #8
 674:	20554e47 	subscs	r4, r5, r7, asr #28
 678:	312b2b43 			; <UNDEFINED> instruction: 0x312b2b43
 67c:	30312034 	eorscc	r2, r1, r4, lsr r0
 680:	312e332e 			; <UNDEFINED> instruction: 0x312e332e
 684:	32303220 	eorscc	r3, r0, #32, 4
 688:	32363031 	eorscc	r3, r6, #49	; 0x31
 68c:	72282031 	eorvc	r2, r8, #49	; 0x31
 690:	61656c65 	cmnvs	r5, r5, ror #24
 694:	20296573 	eorcs	r6, r9, r3, ror r5
 698:	6c666d2d 	stclvs	13, cr6, [r6], #-180	; 0xffffff4c
 69c:	2d74616f 	ldfcse	f6, [r4, #-444]!	; 0xfffffe44
 6a0:	3d696261 	sfmcc	f6, 2, [r9, #-388]!	; 0xfffffe7c
 6a4:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
 6a8:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
 6ac:	763d7570 			; <UNDEFINED> instruction: 0x763d7570
 6b0:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
 6b4:	6f6c666d 	svcvs	0x006c666d
 6b8:	612d7461 			; <UNDEFINED> instruction: 0x612d7461
 6bc:	683d6962 	ldmdavs	sp!, {r1, r5, r6, r8, fp, sp, lr}
 6c0:	20647261 	rsbcs	r7, r4, r1, ror #4
 6c4:	70666d2d 	rsbvc	r6, r6, sp, lsr #26
 6c8:	66763d75 			; <UNDEFINED> instruction: 0x66763d75
 6cc:	6d2d2070 	stcvs	0, cr2, [sp, #-448]!	; 0xfffffe40
 6d0:	656e7574 	strbvs	r7, [lr, #-1396]!	; 0xfffffa8c
 6d4:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
 6d8:	36373131 			; <UNDEFINED> instruction: 0x36373131
 6dc:	2d667a6a 	vstmdbcs	r6!, {s15-s120}
 6e0:	6d2d2073 	stcvs	0, cr2, [sp, #-460]!	; 0xfffffe34
 6e4:	206d7261 	rsbcs	r7, sp, r1, ror #4
 6e8:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
 6ec:	613d6863 	teqvs	sp, r3, ror #16
 6f0:	36766d72 			; <UNDEFINED> instruction: 0x36766d72
 6f4:	662b6b7a 			; <UNDEFINED> instruction: 0x662b6b7a
 6f8:	672d2070 			; <UNDEFINED> instruction: 0x672d2070
 6fc:	20672d20 	rsbcs	r2, r7, r0, lsr #26
 700:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
 704:	2d20304f 	stccs	0, cr3, [r0, #-316]!	; 0xfffffec4
 708:	2d20304f 	stccs	0, cr3, [r0, #-316]!	; 0xfffffec4
 70c:	2d6f6e66 	stclcs	14, cr6, [pc, #-408]!	; 57c <shift+0x57c>
 710:	65637865 	strbvs	r7, [r3, #-2149]!	; 0xfffff79b
 714:	6f697470 	svcvs	0x00697470
 718:	2d20736e 	stccs	3, cr7, [r0, #-440]!	; 0xfffffe48
 71c:	2d6f6e66 	stclcs	14, cr6, [pc, #-408]!	; 58c <shift+0x58c>
 720:	69747472 	ldmdbvs	r4!, {r1, r4, r5, r6, sl, ip, sp, lr}^
 724:	66756200 	ldrbtvs	r6, [r5], -r0, lsl #4
 728:	00726566 	rsbseq	r6, r2, r6, ror #10
 72c:	63746572 	cmnvs	r4, #478150656	; 0x1c800000
 730:	0065646f 	rsbeq	r6, r5, pc, ror #8
 734:	657a6973 	ldrbvs	r6, [sl, #-2419]!	; 0xfffff68d
 738:	6e727700 	cdpvs	7, 7, cr7, cr2, cr0, {0}
 73c:	5f006d75 	svcpl	0x00006d75
 740:	6c63355a 	cfstr64vs	mvdx3, [r3], #-360	; 0xfffffe98
 744:	6a65736f 	bvs	195d508 <__bss_end+0x1954900>
 748:	6e6d2f00 	cdpvs	15, 6, cr2, cr13, cr0, {0}
 74c:	2f632f74 	svccs	0x00632f74
 750:	72657355 	rsbvc	r7, r5, #1409286145	; 0x54000001
 754:	754b2f73 	strbvc	r2, [fp, #-3955]	; 0xfffff08d
 758:	442f6162 	strtmi	r6, [pc], #-354	; 760 <shift+0x760>
 75c:	6d75636f 	ldclvs	3, cr6, [r5, #-444]!	; 0xfffffe44
 760:	73746e65 	cmnvc	r4, #1616	; 0x650
 764:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
 768:	2f6c6f6f 	svccs	0x006c6f6f
 76c:	6f72655a 	svcvs	0x0072655a
 770:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
 774:	6178652f 	cmnvs	r8, pc, lsr #10
 778:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
 77c:	36312f73 	shsub16cc	r2, r1, r3
 780:	6761702d 	strbvs	r7, [r1, -sp, lsr #32]!
 784:	5f676e69 	svcpl	0x00676e69
 788:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
 78c:	63617073 	cmnvs	r1, #115	; 0x73
 790:	74732f65 	ldrbtvc	r2, [r3], #-3941	; 0xfffff09b
 794:	62696c64 	rsbvs	r6, r9, #100, 24	; 0x6400
 798:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
 79c:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
 7a0:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
 7a4:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
 7a8:	65706f00 	ldrbvs	r6, [r0, #-3840]!	; 0xfffff100
 7ac:	5a5f006e 	bpl	17c096c <__bss_end+0x17b7d64>
 7b0:	61657234 	cmnvs	r5, r4, lsr r2
 7b4:	63506a64 	cmpvs	r0, #100, 20	; 0x64000
 7b8:	6e69006a 	cdpvs	0, 6, cr0, cr9, cr10, {3}
 7bc:	00747570 	rsbseq	r7, r4, r0, ror r5
 7c0:	74736564 	ldrbtvc	r6, [r3], #-1380	; 0xfffffa9c
 7c4:	657a6200 	ldrbvs	r6, [sl, #-512]!	; 0xfffffe00
 7c8:	6c006f72 	stcvs	15, cr6, [r0], {114}	; 0x72
 7cc:	74676e65 	strbtvc	r6, [r7], #-3685	; 0xfffff19b
 7d0:	5a5f0068 	bpl	17c0978 <__bss_end+0x17b7d70>
 7d4:	657a6235 	ldrbvs	r6, [sl, #-565]!	; 0xfffffdcb
 7d8:	76506f72 	usub16vc	r6, r0, r2
 7dc:	6d2f0069 	stcvs	0, cr0, [pc, #-420]!	; 640 <shift+0x640>
 7e0:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
 7e4:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
 7e8:	4b2f7372 	blmi	bdd5b8 <__bss_end+0xbd49b0>
 7ec:	2f616275 	svccs	0x00616275
 7f0:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
 7f4:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
 7f8:	63532f73 	cmpvs	r3, #460	; 0x1cc
 7fc:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; 664 <shift+0x664>
 800:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
 804:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
 808:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 80c:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
 810:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
 814:	61702d36 	cmnvs	r0, r6, lsr sp
 818:	676e6967 	strbvs	r6, [lr, -r7, ror #18]!
 81c:	6573755f 	ldrbvs	r7, [r3, #-1375]!	; 0xfffffaa1
 820:	61707372 	cmnvs	r0, r2, ror r3
 824:	732f6563 			; <UNDEFINED> instruction: 0x732f6563
 828:	696c6474 	stmdbvs	ip!, {r2, r4, r5, r6, sl, sp, lr}^
 82c:	72732f62 	rsbsvc	r2, r3, #392	; 0x188
 830:	74732f63 	ldrbtvc	r2, [r3], #-3939	; 0xfffff09d
 834:	72747364 	rsbsvc	r7, r4, #100, 6	; 0x90000001
 838:	2e676e69 	cdpcs	14, 6, cr6, cr7, cr9, {3}
 83c:	00707063 	rsbseq	r7, r0, r3, rrx
 840:	72616843 	rsbvc	r6, r1, #4390912	; 0x430000
 844:	766e6f43 	strbtvc	r6, [lr], -r3, asr #30
 848:	00727241 	rsbseq	r7, r2, r1, asr #4
 84c:	646d656d 	strbtvs	r6, [sp], #-1389	; 0xfffffa93
 850:	6f007473 	svcvs	0x00007473
 854:	75707475 	ldrbvc	r7, [r0, #-1141]!	; 0xfffffb8b
 858:	5a5f0074 	bpl	17c0a30 <__bss_end+0x17b7e28>
 85c:	6d656d36 	stclvs	13, cr6, [r5, #-216]!	; 0xffffff28
 860:	50797063 	rsbspl	r7, r9, r3, rrx
 864:	7650764b 	ldrbvc	r7, [r0], -fp, asr #12
 868:	656d0069 	strbvs	r0, [sp, #-105]!	; 0xffffff97
 86c:	7970636d 	ldmdbvc	r0!, {r0, r2, r3, r5, r6, r8, r9, sp, lr}^
 870:	72747300 	rsbsvc	r7, r4, #0, 6
 874:	006e656c 	rsbeq	r6, lr, ip, ror #10
 878:	73375a5f 	teqvc	r7, #389120	; 0x5f000
 87c:	636e7274 	cmnvs	lr, #116, 4	; 0x40000007
 880:	4b50706d 	blmi	141ca3c <__bss_end+0x1413e34>
 884:	5f305363 	svcpl	0x00305363
 888:	5a5f0069 	bpl	17c0a34 <__bss_end+0x17b7e2c>
 88c:	72747336 	rsbsvc	r7, r4, #-671088640	; 0xd8000000
 890:	506e656c 	rsbpl	r6, lr, ip, ror #10
 894:	6100634b 	tstvs	r0, fp, asr #6
 898:	00696f74 	rsbeq	r6, r9, r4, ror pc
 89c:	61345a5f 	teqvs	r4, pc, asr sl
 8a0:	50696f74 	rsbpl	r6, r9, r4, ror pc
 8a4:	5f00634b 	svcpl	0x0000634b
 8a8:	7473375a 	ldrbtvc	r3, [r3], #-1882	; 0xfffff8a6
 8ac:	70636e72 	rsbvc	r6, r3, r2, ror lr
 8b0:	50635079 	rsbpl	r5, r3, r9, ror r0
 8b4:	0069634b 	rsbeq	r6, r9, fp, asr #6
 8b8:	6e727473 	mrcvs	4, 3, r7, cr2, cr3, {3}
 8bc:	00706d63 	rsbseq	r6, r0, r3, ror #26
 8c0:	6e727473 	mrcvs	4, 3, r7, cr2, cr3, {3}
 8c4:	00797063 	rsbseq	r7, r9, r3, rrx
 8c8:	6f6d656d 	svcvs	0x006d656d
 8cc:	6d007972 	vstrvs.16	s14, [r0, #-228]	; 0xffffff1c	; <UNPREDICTABLE>
 8d0:	72736d65 	rsbsvc	r6, r3, #6464	; 0x1940
 8d4:	74690063 	strbtvc	r0, [r9], #-99	; 0xffffff9d
 8d8:	5f00616f 	svcpl	0x0000616f
 8dc:	7469345a 	strbtvc	r3, [r9], #-1114	; 0xfffffba6
 8e0:	506a616f 	rsbpl	r6, sl, pc, ror #2
 8e4:	2e006a63 	vmlscs.f32	s12, s0, s7
 8e8:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 8ec:	2f2e2e2f 	svccs	0x002e2e2f
 8f0:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 8f4:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 8f8:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
 8fc:	2f636367 	svccs	0x00636367
 900:	666e6f63 	strbtvs	r6, [lr], -r3, ror #30
 904:	612f6769 			; <UNDEFINED> instruction: 0x612f6769
 908:	6c2f6d72 	stcvs	13, cr6, [pc], #-456	; 748 <shift+0x748>
 90c:	66316269 	ldrtvs	r6, [r1], -r9, ror #4
 910:	73636e75 	cmnvc	r3, #1872	; 0x750
 914:	2f00532e 	svccs	0x0000532e
 918:	6c697562 	cfstr64vs	mvdx7, [r9], #-392	; 0xfffffe78
 91c:	63672f64 	cmnvs	r7, #100, 30	; 0x190
 920:	72612d63 	rsbvc	r2, r1, #6336	; 0x18c0
 924:	6f6e2d6d 	svcvs	0x006e2d6d
 928:	652d656e 	strvs	r6, [sp, #-1390]!	; 0xfffffa92
 92c:	2d696261 	sfmcs	f6, 2, [r9, #-388]!	; 0xfffffe7c
 930:	67665968 	strbvs	r5, [r6, -r8, ror #18]!
 934:	672f344b 	strvs	r3, [pc, -fp, asr #8]!
 938:	612d6363 			; <UNDEFINED> instruction: 0x612d6363
 93c:	6e2d6d72 	mcrvs	13, 1, r6, cr13, cr2, {3}
 940:	2d656e6f 	stclcs	14, cr6, [r5, #-444]!	; 0xfffffe44
 944:	69626165 	stmdbvs	r2!, {r0, r2, r5, r6, r8, sp, lr}^
 948:	2e30312d 	rsfcssp	f3, f0, #5.0
 94c:	30322d33 	eorscc	r2, r2, r3, lsr sp
 950:	302e3132 	eorcc	r3, lr, r2, lsr r1
 954:	75622f37 	strbvc	r2, [r2, #-3895]!	; 0xfffff0c9
 958:	2f646c69 	svccs	0x00646c69
 95c:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
 960:	656e6f6e 	strbvs	r6, [lr, #-3950]!	; 0xfffff092
 964:	6261652d 	rsbvs	r6, r1, #188743680	; 0xb400000
 968:	72612f69 	rsbvc	r2, r1, #420	; 0x1a4
 96c:	35762f6d 	ldrbcc	r2, [r6, #-3949]!	; 0xfffff093
 970:	682f6574 	stmdavs	pc!, {r2, r4, r5, r6, r8, sl, sp, lr}	; <UNPREDICTABLE>
 974:	2f647261 	svccs	0x00647261
 978:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
 97c:	47006363 	strmi	r6, [r0, -r3, ror #6]
 980:	4120554e 			; <UNDEFINED> instruction: 0x4120554e
 984:	2e322053 	mrccs	0, 1, r2, cr2, cr3, {2}
 988:	69003733 	stmdbvs	r0, {r0, r1, r4, r5, r8, r9, sl, ip, sp}
 98c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 990:	705f7469 	subsvc	r7, pc, r9, ror #8
 994:	72646572 	rsbvc	r6, r4, #478150656	; 0x1c800000
 998:	69007365 	stmdbvs	r0, {r0, r2, r5, r6, r8, r9, ip, sp, lr}
 99c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 9a0:	765f7469 	ldrbvc	r7, [pc], -r9, ror #8
 9a4:	625f7066 	subsvs	r7, pc, #102	; 0x66
 9a8:	00657361 	rsbeq	r7, r5, r1, ror #6
 9ac:	706d6f63 	rsbvc	r6, sp, r3, ror #30
 9b0:	2078656c 	rsbscs	r6, r8, ip, ror #10
 9b4:	616f6c66 	cmnvs	pc, r6, ror #24
 9b8:	73690074 	cmnvc	r9, #116	; 0x74
 9bc:	6f6e5f61 	svcvs	0x006e5f61
 9c0:	00746962 	rsbseq	r6, r4, r2, ror #18
 9c4:	5f617369 	svcpl	0x00617369
 9c8:	5f746962 	svcpl	0x00746962
 9cc:	5f65766d 	svcpl	0x0065766d
 9d0:	616f6c66 	cmnvs	pc, r6, ror #24
 9d4:	73690074 	cmnvc	r9, #116	; 0x74
 9d8:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 9dc:	70665f74 	rsbvc	r5, r6, r4, ror pc
 9e0:	69003631 	stmdbvs	r0, {r0, r4, r5, r9, sl, ip, sp}
 9e4:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 9e8:	735f7469 	cmpvc	pc, #1761607680	; 0x69000000
 9ec:	69006365 	stmdbvs	r0, {r0, r2, r5, r6, r8, r9, sp, lr}
 9f0:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 9f4:	615f7469 	cmpvs	pc, r9, ror #8
 9f8:	00766964 	rsbseq	r6, r6, r4, ror #18
 9fc:	5f617369 	svcpl	0x00617369
 a00:	5f746962 	svcpl	0x00746962
 a04:	72697571 	rsbvc	r7, r9, #473956352	; 0x1c400000
 a08:	6f6e5f6b 	svcvs	0x006e5f6b
 a0c:	6c6f765f 	stclvs	6, cr7, [pc], #-380	; 898 <shift+0x898>
 a10:	6c697461 	cfstrdvs	mvd7, [r9], #-388	; 0xfffffe7c
 a14:	65635f65 	strbvs	r5, [r3, #-3941]!	; 0xfffff09b
 a18:	61736900 	cmnvs	r3, r0, lsl #18
 a1c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 a20:	00706d5f 	rsbseq	r6, r0, pc, asr sp
 a24:	5f617369 	svcpl	0x00617369
 a28:	5f746962 	svcpl	0x00746962
 a2c:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
 a30:	69007435 	stmdbvs	r0, {r0, r2, r4, r5, sl, ip, sp, lr}
 a34:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 a38:	615f7469 	cmpvs	pc, r9, ror #8
 a3c:	35766d72 	ldrbcc	r6, [r6, #-3442]!	; 0xfffff28e
 a40:	69006574 	stmdbvs	r0, {r2, r4, r5, r6, r8, sl, sp, lr}
 a44:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 a48:	6e5f7469 	cdpvs	4, 5, cr7, cr15, cr9, {3}
 a4c:	006e6f65 	rsbeq	r6, lr, r5, ror #30
 a50:	5f617369 	svcpl	0x00617369
 a54:	5f746962 	svcpl	0x00746962
 a58:	36316662 	ldrtcc	r6, [r1], -r2, ror #12
 a5c:	53504600 	cmppl	r0, #0, 12
 a60:	455f5243 	ldrbmi	r5, [pc, #-579]	; 825 <shift+0x825>
 a64:	004d554e 	subeq	r5, sp, lr, asr #10
 a68:	43535046 	cmpmi	r3, #70	; 0x46
 a6c:	7a6e5f52 	bvc	1b987bc <__bss_end+0x1b8fbb4>
 a70:	63717663 	cmnvs	r1, #103809024	; 0x6300000
 a74:	554e455f 	strbpl	r4, [lr, #-1375]	; 0xfffffaa1
 a78:	5056004d 	subspl	r0, r6, sp, asr #32
 a7c:	4e455f52 	mcrmi	15, 2, r5, cr5, cr2, {2}
 a80:	66004d55 			; <UNDEFINED> instruction: 0x66004d55
 a84:	5f746962 	svcpl	0x00746962
 a88:	6c706d69 	ldclvs	13, cr6, [r0], #-420	; 0xfffffe5c
 a8c:	74616369 	strbtvc	r6, [r1], #-873	; 0xfffffc97
 a90:	006e6f69 	rsbeq	r6, lr, r9, ror #30
 a94:	455f3050 	ldrbmi	r3, [pc, #-80]	; a4c <shift+0xa4c>
 a98:	004d554e 	subeq	r5, sp, lr, asr #10
 a9c:	5f617369 	svcpl	0x00617369
 aa0:	5f746962 	svcpl	0x00746962
 aa4:	70797263 	rsbsvc	r7, r9, r3, ror #4
 aa8:	47006f74 	smlsdxmi	r0, r4, pc, r6	; <UNPREDICTABLE>
 aac:	4320554e 			; <UNDEFINED> instruction: 0x4320554e
 ab0:	31203731 			; <UNDEFINED> instruction: 0x31203731
 ab4:	2e332e30 	mrccs	14, 1, r2, cr3, cr0, {1}
 ab8:	30322031 	eorscc	r2, r2, r1, lsr r0
 abc:	36303132 			; <UNDEFINED> instruction: 0x36303132
 ac0:	28203132 	stmdacs	r0!, {r1, r4, r5, r8, ip, sp}
 ac4:	656c6572 	strbvs	r6, [ip, #-1394]!	; 0xfffffa8e
 ac8:	29657361 	stmdbcs	r5!, {r0, r5, r6, r8, r9, ip, sp, lr}^
 acc:	616d2d20 	cmnvs	sp, r0, lsr #26
 ad0:	2d206d72 	stccs	13, cr6, [r0, #-456]!	; 0xfffffe38
 ad4:	6f6c666d 	svcvs	0x006c666d
 ad8:	612d7461 			; <UNDEFINED> instruction: 0x612d7461
 adc:	683d6962 	ldmdavs	sp!, {r1, r5, r6, r8, fp, sp, lr}
 ae0:	20647261 	rsbcs	r7, r4, r1, ror #4
 ae4:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
 ae8:	613d6863 	teqvs	sp, r3, ror #16
 aec:	35766d72 	ldrbcc	r6, [r6, #-3442]!	; 0xfffff28e
 af0:	662b6574 			; <UNDEFINED> instruction: 0x662b6574
 af4:	672d2070 			; <UNDEFINED> instruction: 0x672d2070
 af8:	20672d20 	rsbcs	r2, r7, r0, lsr #26
 afc:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
 b00:	2d20324f 	sfmcs	f3, 4, [r0, #-316]!	; 0xfffffec4
 b04:	2d20324f 	sfmcs	f3, 4, [r0, #-316]!	; 0xfffffec4
 b08:	2d20324f 	sfmcs	f3, 4, [r0, #-316]!	; 0xfffffec4
 b0c:	69756266 	ldmdbvs	r5!, {r1, r2, r5, r6, r9, sp, lr}^
 b10:	6e69646c 	cdpvs	4, 6, cr6, cr9, cr12, {3}
 b14:	696c2d67 	stmdbvs	ip!, {r0, r1, r2, r5, r6, r8, sl, fp, sp}^
 b18:	63636762 	cmnvs	r3, #25690112	; 0x1880000
 b1c:	6e662d20 	cdpvs	13, 6, cr2, cr6, cr0, {1}
 b20:	74732d6f 	ldrbtvc	r2, [r3], #-3439	; 0xfffff291
 b24:	2d6b6361 	stclcs	3, cr6, [fp, #-388]!	; 0xfffffe7c
 b28:	746f7270 	strbtvc	r7, [pc], #-624	; b30 <shift+0xb30>
 b2c:	6f746365 	svcvs	0x00746365
 b30:	662d2072 			; <UNDEFINED> instruction: 0x662d2072
 b34:	692d6f6e 	pushvs	{r1, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}
 b38:	6e696c6e 	cdpvs	12, 6, cr6, cr9, cr14, {3}
 b3c:	662d2065 	strtvs	r2, [sp], -r5, rrx
 b40:	69736976 	ldmdbvs	r3!, {r1, r2, r4, r5, r6, r8, fp, sp, lr}^
 b44:	696c6962 	stmdbvs	ip!, {r1, r5, r6, r8, fp, sp, lr}^
 b48:	683d7974 	ldmdavs	sp!, {r2, r4, r5, r6, r8, fp, ip, sp, lr}
 b4c:	65646469 	strbvs	r6, [r4, #-1129]!	; 0xfffffb97
 b50:	7369006e 	cmnvc	r9, #110	; 0x6e
 b54:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 b58:	64745f74 	ldrbtvs	r5, [r4], #-3956	; 0xfffff08c
 b5c:	63007669 	movwvs	r7, #1641	; 0x669
 b60:	00736e6f 	rsbseq	r6, r3, pc, ror #28
 b64:	5f617369 	svcpl	0x00617369
 b68:	5f746962 	svcpl	0x00746962
 b6c:	6d6d7769 	stclvs	7, cr7, [sp, #-420]!	; 0xfffffe5c
 b70:	46007478 			; <UNDEFINED> instruction: 0x46007478
 b74:	54584350 	ldrbpl	r4, [r8], #-848	; 0xfffffcb0
 b78:	4e455f53 	mcrmi	15, 2, r5, cr5, cr3, {2}
 b7c:	69004d55 	stmdbvs	r0, {r0, r2, r4, r6, r8, sl, fp, lr}
 b80:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 b84:	615f7469 	cmpvs	pc, r9, ror #8
 b88:	36766d72 			; <UNDEFINED> instruction: 0x36766d72
 b8c:	61736900 	cmnvs	r3, r0, lsl #18
 b90:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 b94:	65766d5f 	ldrbvs	r6, [r6, #-3423]!	; 0xfffff2a1
 b98:	61736900 	cmnvs	r3, r0, lsl #18
 b9c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 ba0:	6d77695f 			; <UNDEFINED> instruction: 0x6d77695f
 ba4:	3274786d 	rsbscc	r7, r4, #7143424	; 0x6d0000
 ba8:	61736900 	cmnvs	r3, r0, lsl #18
 bac:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 bb0:	6564635f 	strbvs	r6, [r4, #-863]!	; 0xfffffca1
 bb4:	00307063 	eorseq	r7, r0, r3, rrx
 bb8:	5f617369 	svcpl	0x00617369
 bbc:	5f746962 	svcpl	0x00746962
 bc0:	63656463 	cmnvs	r5, #1660944384	; 0x63000000
 bc4:	69003170 	stmdbvs	r0, {r4, r5, r6, r8, ip, sp}
 bc8:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 bcc:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
 bd0:	70636564 	rsbvc	r6, r3, r4, ror #10
 bd4:	73690032 	cmnvc	r9, #50	; 0x32
 bd8:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 bdc:	64635f74 	strbtvs	r5, [r3], #-3956	; 0xfffff08c
 be0:	33706365 	cmncc	r0, #-1811939327	; 0x94000001
 be4:	61736900 	cmnvs	r3, r0, lsl #18
 be8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 bec:	6564635f 	strbvs	r6, [r4, #-863]!	; 0xfffffca1
 bf0:	00347063 	eorseq	r7, r4, r3, rrx
 bf4:	5f617369 	svcpl	0x00617369
 bf8:	5f746962 	svcpl	0x00746962
 bfc:	645f7066 	ldrbvs	r7, [pc], #-102	; c04 <shift+0xc04>
 c00:	69006c62 	stmdbvs	r0, {r1, r5, r6, sl, fp, sp, lr}
 c04:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 c08:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
 c0c:	70636564 	rsbvc	r6, r3, r4, ror #10
 c10:	73690036 	cmnvc	r9, #54	; 0x36
 c14:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 c18:	64635f74 	strbtvs	r5, [r3], #-3956	; 0xfffff08c
 c1c:	37706365 	ldrbcc	r6, [r0, -r5, ror #6]!
 c20:	61736900 	cmnvs	r3, r0, lsl #18
 c24:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 c28:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
 c2c:	006b3676 	rsbeq	r3, fp, r6, ror r6
 c30:	5f617369 	svcpl	0x00617369
 c34:	5f746962 	svcpl	0x00746962
 c38:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
 c3c:	6d315f38 	ldcvs	15, cr5, [r1, #-224]!	; 0xffffff20
 c40:	69616d5f 	stmdbvs	r1!, {r0, r1, r2, r3, r4, r6, r8, sl, fp, sp, lr}^
 c44:	6e61006e 	cdpvs	0, 6, cr0, cr1, cr14, {3}
 c48:	69006574 	stmdbvs	r0, {r2, r4, r5, r6, r8, sl, sp, lr}
 c4c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 c50:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
 c54:	0065736d 	rsbeq	r7, r5, sp, ror #6
 c58:	676e6f6c 	strbvs	r6, [lr, -ip, ror #30]!
 c5c:	756f6420 	strbvc	r6, [pc, #-1056]!	; 844 <shift+0x844>
 c60:	00656c62 	rsbeq	r6, r5, r2, ror #24
 c64:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 c68:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 c6c:	2f2e2e2f 	svccs	0x002e2e2f
 c70:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 c74:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
 c78:	63636762 	cmnvs	r3, #25690112	; 0x1880000
 c7c:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
 c80:	32636367 	rsbcc	r6, r3, #-1677721599	; 0x9c000001
 c84:	6900632e 	stmdbvs	r0, {r1, r2, r3, r5, r8, r9, sp, lr}
 c88:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 c8c:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
 c90:	00357670 	eorseq	r7, r5, r0, ror r6
 c94:	5f617369 	svcpl	0x00617369
 c98:	5f746962 	svcpl	0x00746962
 c9c:	61637378 	smcvs	14136	; 0x3738
 ca0:	6c00656c 	cfstr32vs	mvfx6, [r0], {108}	; 0x6c
 ca4:	20676e6f 	rsbcs	r6, r7, pc, ror #28
 ca8:	676e6f6c 	strbvs	r6, [lr, -ip, ror #30]!
 cac:	736e7520 	cmnvc	lr, #32, 10	; 0x8000000
 cb0:	656e6769 	strbvs	r6, [lr, #-1897]!	; 0xfffff897
 cb4:	6e692064 	cdpvs	0, 6, cr2, cr9, cr4, {3}
 cb8:	73690074 	cmnvc	r9, #116	; 0x74
 cbc:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 cc0:	75715f74 	ldrbvc	r5, [r1, #-3956]!	; 0xfffff08c
 cc4:	5f6b7269 	svcpl	0x006b7269
 cc8:	5f336d63 	svcpl	0x00336d63
 ccc:	6472646c 	ldrbtvs	r6, [r2], #-1132	; 0xfffffb94
 cd0:	61736900 	cmnvs	r3, r0, lsl #18
 cd4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 cd8:	6d38695f 			; <UNDEFINED> instruction: 0x6d38695f
 cdc:	7369006d 	cmnvc	r9, #109	; 0x6d
 ce0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 ce4:	70665f74 	rsbvc	r5, r6, r4, ror pc
 ce8:	3233645f 	eorscc	r6, r3, #1593835520	; 0x5f000000
 cec:	61736900 	cmnvs	r3, r0, lsl #18
 cf0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 cf4:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
 cf8:	6d653776 	stclvs	7, cr3, [r5, #-472]!	; 0xfffffe28
 cfc:	61736900 	cmnvs	r3, r0, lsl #18
 d00:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 d04:	61706c5f 	cmnvs	r0, pc, asr ip
 d08:	6c610065 	stclvs	0, cr0, [r1], #-404	; 0xfffffe6c
 d0c:	6d695f6c 	stclvs	15, cr5, [r9, #-432]!	; 0xfffffe50
 d10:	65696c70 	strbvs	r6, [r9, #-3184]!	; 0xfffff390
 d14:	62665f64 	rsbvs	r5, r6, #100, 30	; 0x190
 d18:	00737469 	rsbseq	r7, r3, r9, ror #8
 d1c:	5f617369 	svcpl	0x00617369
 d20:	5f746962 	svcpl	0x00746962
 d24:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
 d28:	00315f38 	eorseq	r5, r1, r8, lsr pc
 d2c:	5f617369 	svcpl	0x00617369
 d30:	5f746962 	svcpl	0x00746962
 d34:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
 d38:	00325f38 	eorseq	r5, r2, r8, lsr pc
 d3c:	5f617369 	svcpl	0x00617369
 d40:	5f746962 	svcpl	0x00746962
 d44:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
 d48:	00335f38 	eorseq	r5, r3, r8, lsr pc
 d4c:	5f617369 	svcpl	0x00617369
 d50:	5f746962 	svcpl	0x00746962
 d54:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
 d58:	00345f38 	eorseq	r5, r4, r8, lsr pc
 d5c:	5f617369 	svcpl	0x00617369
 d60:	5f746962 	svcpl	0x00746962
 d64:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
 d68:	00355f38 	eorseq	r5, r5, r8, lsr pc
 d6c:	5f617369 	svcpl	0x00617369
 d70:	5f746962 	svcpl	0x00746962
 d74:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
 d78:	00365f38 	eorseq	r5, r6, r8, lsr pc
 d7c:	5f617369 	svcpl	0x00617369
 d80:	5f746962 	svcpl	0x00746962
 d84:	69006273 	stmdbvs	r0, {r0, r1, r4, r5, r6, r9, sp, lr}
 d88:	6e5f6173 	mrcvs	1, 2, r6, cr15, cr3, {3}
 d8c:	625f6d75 	subsvs	r6, pc, #7488	; 0x1d40
 d90:	00737469 	rsbseq	r7, r3, r9, ror #8
 d94:	5f617369 	svcpl	0x00617369
 d98:	5f746962 	svcpl	0x00746962
 d9c:	6c616d73 	stclvs	13, cr6, [r1], #-460	; 0xfffffe34
 da0:	6c756d6c 	ldclvs	13, cr6, [r5], #-432	; 0xfffffe50
 da4:	6e756600 	cdpvs	6, 7, cr6, cr5, cr0, {0}
 da8:	74705f63 	ldrbtvc	r5, [r0], #-3939	; 0xfffff09d
 dac:	6f630072 	svcvs	0x00630072
 db0:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
 db4:	6f642078 	svcvs	0x00642078
 db8:	656c6275 	strbvs	r6, [ip, #-629]!	; 0xfffffd8b
 dbc:	5f424e00 	svcpl	0x00424e00
 dc0:	535f5046 	cmppl	pc, #70	; 0x46
 dc4:	45525359 	ldrbmi	r5, [r2, #-857]	; 0xfffffca7
 dc8:	69005347 	stmdbvs	r0, {r0, r1, r2, r6, r8, r9, ip, lr}
 dcc:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 dd0:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
 dd4:	70636564 	rsbvc	r6, r3, r4, ror #10
 dd8:	73690035 	cmnvc	r9, #53	; 0x35
 ddc:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 de0:	66765f74 	uhsub16vs	r5, r6, r4
 de4:	00327670 	eorseq	r7, r2, r0, ror r6
 de8:	5f617369 	svcpl	0x00617369
 dec:	5f746962 	svcpl	0x00746962
 df0:	76706676 			; <UNDEFINED> instruction: 0x76706676
 df4:	73690033 	cmnvc	r9, #51	; 0x33
 df8:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 dfc:	66765f74 	uhsub16vs	r5, r6, r4
 e00:	00347670 	eorseq	r7, r4, r0, ror r6
 e04:	58435046 	stmdapl	r3, {r1, r2, r6, ip, lr}^
 e08:	5f534e54 	svcpl	0x00534e54
 e0c:	4d554e45 	ldclmi	14, cr4, [r5, #-276]	; 0xfffffeec
 e10:	61736900 	cmnvs	r3, r0, lsl #18
 e14:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 e18:	7568745f 	strbvc	r7, [r8, #-1119]!	; 0xfffffba1
 e1c:	6900626d 	stmdbvs	r0, {r0, r2, r3, r5, r6, r9, sp, lr}
 e20:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 e24:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
 e28:	63363170 	teqvs	r6, #112, 2
 e2c:	00766e6f 	rsbseq	r6, r6, pc, ror #28
 e30:	5f617369 	svcpl	0x00617369
 e34:	74616566 	strbtvc	r6, [r1], #-1382	; 0xfffffa9a
 e38:	00657275 	rsbeq	r7, r5, r5, ror r2
 e3c:	5f617369 	svcpl	0x00617369
 e40:	5f746962 	svcpl	0x00746962
 e44:	6d746f6e 	ldclvs	15, cr6, [r4, #-440]!	; 0xfffffe48
 e48:	61736900 	cmnvs	r3, r0, lsl #18
 e4c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 e50:	6975715f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, r8, ip, sp, lr}^
 e54:	615f6b72 	cmpvs	pc, r2, ror fp	; <UNPREDICTABLE>
 e58:	36766d72 			; <UNDEFINED> instruction: 0x36766d72
 e5c:	69007a6b 	stmdbvs	r0, {r0, r1, r3, r5, r6, r9, fp, ip, sp, lr}
 e60:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 e64:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
 e68:	32336372 	eorscc	r6, r3, #-939524095	; 0xc8000001
 e6c:	61736900 	cmnvs	r3, r0, lsl #18
 e70:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 e74:	6975715f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, r8, ip, sp, lr}^
 e78:	6e5f6b72 	vmovvs.s8	r6, d15[3]
 e7c:	73615f6f 	cmnvc	r1, #444	; 0x1bc
 e80:	7570636d 	ldrbvc	r6, [r0, #-877]!	; 0xfffffc93
 e84:	61736900 	cmnvs	r3, r0, lsl #18
 e88:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 e8c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
 e90:	69003476 	stmdbvs	r0, {r1, r2, r4, r5, r6, sl, ip, sp}
 e94:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 e98:	745f7469 	ldrbvc	r7, [pc], #-1129	; ea0 <shift+0xea0>
 e9c:	626d7568 	rsbvs	r7, sp, #104, 10	; 0x1a000000
 ea0:	73690032 	cmnvc	r9, #50	; 0x32
 ea4:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 ea8:	65625f74 	strbvs	r5, [r2, #-3956]!	; 0xfffff08c
 eac:	73690038 	cmnvc	r9, #56	; 0x38
 eb0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 eb4:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
 eb8:	0037766d 	eorseq	r7, r7, sp, ror #12
 ebc:	5f617369 	svcpl	0x00617369
 ec0:	5f746962 	svcpl	0x00746962
 ec4:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
 ec8:	66760038 			; <UNDEFINED> instruction: 0x66760038
 ecc:	79735f70 	ldmdbvc	r3!, {r4, r5, r6, r8, r9, sl, fp, ip, lr}^
 ed0:	67657273 			; <UNDEFINED> instruction: 0x67657273
 ed4:	6e655f73 	mcrvs	15, 3, r5, cr5, cr3, {3}
 ed8:	69646f63 	stmdbvs	r4!, {r0, r1, r5, r6, r8, r9, sl, fp, sp, lr}^
 edc:	6900676e 	stmdbvs	r0, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}
 ee0:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 ee4:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
 ee8:	66363170 			; <UNDEFINED> instruction: 0x66363170
 eec:	69006c6d 	stmdbvs	r0, {r0, r2, r3, r5, r6, sl, fp, sp, lr}
 ef0:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 ef4:	645f7469 	ldrbvs	r7, [pc], #-1129	; efc <shift+0xefc>
 ef8:	7270746f 	rsbsvc	r7, r0, #1862270976	; 0x6f000000
 efc:	Address 0x0000000000000efc is out of bounds.


Disassembly of section .debug_frame:

00000000 <.debug_frame>:
   0:	0000000c 	andeq	r0, r0, ip
   4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
   8:	7c020001 	stcvc	0, cr0, [r2], {1}
   c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  10:	0000001c 	andeq	r0, r0, ip, lsl r0
  14:	00000000 	andeq	r0, r0, r0
  18:	00008008 	andeq	r8, r0, r8
  1c:	0000005c 	andeq	r0, r0, ip, asr r0
  20:	8b040e42 	blhi	103930 <__bss_end+0xfad28>
  24:	0b0d4201 	bleq	350830 <__bss_end+0x347c28>
  28:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
  2c:	00000ecb 	andeq	r0, r0, fp, asr #29
  30:	0000001c 	andeq	r0, r0, ip, lsl r0
  34:	00000000 	andeq	r0, r0, r0
  38:	00008064 	andeq	r8, r0, r4, rrx
  3c:	00000040 	andeq	r0, r0, r0, asr #32
  40:	8b080e42 	blhi	203950 <__bss_end+0x1fad48>
  44:	42018e02 	andmi	r8, r1, #2, 28
  48:	5a040b0c 	bpl	102c80 <__bss_end+0xfa078>
  4c:	00080d0c 	andeq	r0, r8, ip, lsl #26
  50:	0000000c 	andeq	r0, r0, ip
  54:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  58:	7c020001 	stcvc	0, cr0, [r2], {1}
  5c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  60:	0000001c 	andeq	r0, r0, ip, lsl r0
  64:	00000050 	andeq	r0, r0, r0, asr r0
  68:	000080a4 	andeq	r8, r0, r4, lsr #1
  6c:	00000038 	andeq	r0, r0, r8, lsr r0
  70:	8b040e42 	blhi	103980 <__bss_end+0xfad78>
  74:	0b0d4201 	bleq	350880 <__bss_end+0x347c78>
  78:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
  7c:	00000ecb 	andeq	r0, r0, fp, asr #29
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	00000050 	andeq	r0, r0, r0, asr r0
  88:	000080dc 	ldrdeq	r8, [r0], -ip
  8c:	0000002c 	andeq	r0, r0, ip, lsr #32
  90:	8b040e42 	blhi	1039a0 <__bss_end+0xfad98>
  94:	0b0d4201 	bleq	3508a0 <__bss_end+0x347c98>
  98:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
  9c:	00000ecb 	andeq	r0, r0, fp, asr #29
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	00000050 	andeq	r0, r0, r0, asr r0
  a8:	00008108 	andeq	r8, r0, r8, lsl #2
  ac:	00000020 	andeq	r0, r0, r0, lsr #32
  b0:	8b040e42 	blhi	1039c0 <__bss_end+0xfadb8>
  b4:	0b0d4201 	bleq	3508c0 <__bss_end+0x347cb8>
  b8:	420d0d48 	andmi	r0, sp, #72, 26	; 0x1200
  bc:	00000ecb 	andeq	r0, r0, fp, asr #29
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	00000050 	andeq	r0, r0, r0, asr r0
  c8:	00008128 	andeq	r8, r0, r8, lsr #2
  cc:	00000018 	andeq	r0, r0, r8, lsl r0
  d0:	8b040e42 	blhi	1039e0 <__bss_end+0xfadd8>
  d4:	0b0d4201 	bleq	3508e0 <__bss_end+0x347cd8>
  d8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  dc:	00000ecb 	andeq	r0, r0, fp, asr #29
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	00000050 	andeq	r0, r0, r0, asr r0
  e8:	00008140 	andeq	r8, r0, r0, asr #2
  ec:	00000018 	andeq	r0, r0, r8, lsl r0
  f0:	8b040e42 	blhi	103a00 <__bss_end+0xfadf8>
  f4:	0b0d4201 	bleq	350900 <__bss_end+0x347cf8>
  f8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  fc:	00000ecb 	andeq	r0, r0, fp, asr #29
 100:	0000001c 	andeq	r0, r0, ip, lsl r0
 104:	00000050 	andeq	r0, r0, r0, asr r0
 108:	00008158 	andeq	r8, r0, r8, asr r1
 10c:	00000018 	andeq	r0, r0, r8, lsl r0
 110:	8b040e42 	blhi	103a20 <__bss_end+0xfae18>
 114:	0b0d4201 	bleq	350920 <__bss_end+0x347d18>
 118:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
 11c:	00000ecb 	andeq	r0, r0, fp, asr #29
 120:	00000014 	andeq	r0, r0, r4, lsl r0
 124:	00000050 	andeq	r0, r0, r0, asr r0
 128:	00008170 	andeq	r8, r0, r0, ror r1
 12c:	0000000c 	andeq	r0, r0, ip
 130:	8b040e42 	blhi	103a40 <__bss_end+0xfae38>
 134:	0b0d4201 	bleq	350940 <__bss_end+0x347d38>
 138:	0000001c 	andeq	r0, r0, ip, lsl r0
 13c:	00000050 	andeq	r0, r0, r0, asr r0
 140:	0000817c 	andeq	r8, r0, ip, ror r1
 144:	00000058 	andeq	r0, r0, r8, asr r0
 148:	8b080e42 	blhi	203a58 <__bss_end+0x1fae50>
 14c:	42018e02 	andmi	r8, r1, #2, 28
 150:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 154:	00080d0c 	andeq	r0, r8, ip, lsl #26
 158:	0000001c 	andeq	r0, r0, ip, lsl r0
 15c:	00000050 	andeq	r0, r0, r0, asr r0
 160:	000081d4 	ldrdeq	r8, [r0], -r4
 164:	00000058 	andeq	r0, r0, r8, asr r0
 168:	8b080e42 	blhi	203a78 <__bss_end+0x1fae70>
 16c:	42018e02 	andmi	r8, r1, #2, 28
 170:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 174:	00080d0c 	andeq	r0, r8, ip, lsl #26
 178:	0000000c 	andeq	r0, r0, ip
 17c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 180:	7c020001 	stcvc	0, cr0, [r2], {1}
 184:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 188:	00000018 	andeq	r0, r0, r8, lsl r0
 18c:	00000178 	andeq	r0, r0, r8, ror r1
 190:	0000822c 	andeq	r8, r0, ip, lsr #4
 194:	000000d8 	ldrdeq	r0, [r0], -r8
 198:	8b080e42 	blhi	203aa8 <__bss_end+0x1faea0>
 19c:	42018e02 	andmi	r8, r1, #2, 28
 1a0:	00040b0c 	andeq	r0, r4, ip, lsl #22
 1a4:	0000000c 	andeq	r0, r0, ip
 1a8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 1ac:	7c020001 	stcvc	0, cr0, [r2], {1}
 1b0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 1b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1b8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1bc:	00008304 	andeq	r8, r0, r4, lsl #6
 1c0:	0000002c 	andeq	r0, r0, ip, lsr #32
 1c4:	8b040e42 	blhi	103ad4 <__bss_end+0xfaecc>
 1c8:	0b0d4201 	bleq	3509d4 <__bss_end+0x347dcc>
 1cc:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 1d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 1d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1d8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1dc:	00008330 	andeq	r8, r0, r0, lsr r3
 1e0:	0000002c 	andeq	r0, r0, ip, lsr #32
 1e4:	8b040e42 	blhi	103af4 <__bss_end+0xfaeec>
 1e8:	0b0d4201 	bleq	3509f4 <__bss_end+0x347dec>
 1ec:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 1f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 1f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1f8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1fc:	0000835c 	andeq	r8, r0, ip, asr r3
 200:	0000001c 	andeq	r0, r0, ip, lsl r0
 204:	8b040e42 	blhi	103b14 <__bss_end+0xfaf0c>
 208:	0b0d4201 	bleq	350a14 <__bss_end+0x347e0c>
 20c:	420d0d46 	andmi	r0, sp, #4480	; 0x1180
 210:	00000ecb 	andeq	r0, r0, fp, asr #29
 214:	0000001c 	andeq	r0, r0, ip, lsl r0
 218:	000001a4 	andeq	r0, r0, r4, lsr #3
 21c:	00008378 	andeq	r8, r0, r8, ror r3
 220:	00000044 	andeq	r0, r0, r4, asr #32
 224:	8b040e42 	blhi	103b34 <__bss_end+0xfaf2c>
 228:	0b0d4201 	bleq	350a34 <__bss_end+0x347e2c>
 22c:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 230:	00000ecb 	andeq	r0, r0, fp, asr #29
 234:	0000001c 	andeq	r0, r0, ip, lsl r0
 238:	000001a4 	andeq	r0, r0, r4, lsr #3
 23c:	000083bc 			; <UNDEFINED> instruction: 0x000083bc
 240:	00000050 	andeq	r0, r0, r0, asr r0
 244:	8b040e42 	blhi	103b54 <__bss_end+0xfaf4c>
 248:	0b0d4201 	bleq	350a54 <__bss_end+0x347e4c>
 24c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 250:	00000ecb 	andeq	r0, r0, fp, asr #29
 254:	0000001c 	andeq	r0, r0, ip, lsl r0
 258:	000001a4 	andeq	r0, r0, r4, lsr #3
 25c:	0000840c 	andeq	r8, r0, ip, lsl #8
 260:	00000050 	andeq	r0, r0, r0, asr r0
 264:	8b040e42 	blhi	103b74 <__bss_end+0xfaf6c>
 268:	0b0d4201 	bleq	350a74 <__bss_end+0x347e6c>
 26c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 270:	00000ecb 	andeq	r0, r0, fp, asr #29
 274:	0000001c 	andeq	r0, r0, ip, lsl r0
 278:	000001a4 	andeq	r0, r0, r4, lsr #3
 27c:	0000845c 	andeq	r8, r0, ip, asr r4
 280:	0000002c 	andeq	r0, r0, ip, lsr #32
 284:	8b040e42 	blhi	103b94 <__bss_end+0xfaf8c>
 288:	0b0d4201 	bleq	350a94 <__bss_end+0x347e8c>
 28c:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 290:	00000ecb 	andeq	r0, r0, fp, asr #29
 294:	0000001c 	andeq	r0, r0, ip, lsl r0
 298:	000001a4 	andeq	r0, r0, r4, lsr #3
 29c:	00008488 	andeq	r8, r0, r8, lsl #9
 2a0:	00000050 	andeq	r0, r0, r0, asr r0
 2a4:	8b040e42 	blhi	103bb4 <__bss_end+0xfafac>
 2a8:	0b0d4201 	bleq	350ab4 <__bss_end+0x347eac>
 2ac:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 2b0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2b4:	0000000c 	andeq	r0, r0, ip
 2b8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 2bc:	7c020001 	stcvc	0, cr0, [r2], {1}
 2c0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 2c4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2c8:	000002b4 			; <UNDEFINED> instruction: 0x000002b4
 2cc:	000084d8 	ldrdeq	r8, [r0], -r8	; <UNPREDICTABLE>
 2d0:	00000174 	andeq	r0, r0, r4, ror r1
 2d4:	8b080e42 	blhi	203be4 <__bss_end+0x1fafdc>
 2d8:	42018e02 	andmi	r8, r1, #2, 28
 2dc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 2e0:	080d0cb2 	stmdaeq	sp, {r1, r4, r5, r7, sl, fp}
 2e4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2e8:	000002b4 			; <UNDEFINED> instruction: 0x000002b4
 2ec:	0000864c 	andeq	r8, r0, ip, asr #12
 2f0:	0000009c 	muleq	r0, ip, r0
 2f4:	8b040e42 	blhi	103c04 <__bss_end+0xfaffc>
 2f8:	0b0d4201 	bleq	350b04 <__bss_end+0x347efc>
 2fc:	0d0d4602 	stceq	6, cr4, [sp, #-8]
 300:	000ecb42 	andeq	ip, lr, r2, asr #22
 304:	0000001c 	andeq	r0, r0, ip, lsl r0
 308:	000002b4 			; <UNDEFINED> instruction: 0x000002b4
 30c:	000086e8 	andeq	r8, r0, r8, ror #13
 310:	000000c0 	andeq	r0, r0, r0, asr #1
 314:	8b040e42 	blhi	103c24 <__bss_end+0xfb01c>
 318:	0b0d4201 	bleq	350b24 <__bss_end+0x347f1c>
 31c:	0d0d5802 	stceq	8, cr5, [sp, #-8]
 320:	000ecb42 	andeq	ip, lr, r2, asr #22
 324:	0000001c 	andeq	r0, r0, ip, lsl r0
 328:	000002b4 			; <UNDEFINED> instruction: 0x000002b4
 32c:	000087a8 	andeq	r8, r0, r8, lsr #15
 330:	000000ac 	andeq	r0, r0, ip, lsr #1
 334:	8b040e42 	blhi	103c44 <__bss_end+0xfb03c>
 338:	0b0d4201 	bleq	350b44 <__bss_end+0x347f3c>
 33c:	0d0d4e02 	stceq	14, cr4, [sp, #-8]
 340:	000ecb42 	andeq	ip, lr, r2, asr #22
 344:	0000001c 	andeq	r0, r0, ip, lsl r0
 348:	000002b4 			; <UNDEFINED> instruction: 0x000002b4
 34c:	00008854 	andeq	r8, r0, r4, asr r8
 350:	00000054 	andeq	r0, r0, r4, asr r0
 354:	8b040e42 	blhi	103c64 <__bss_end+0xfb05c>
 358:	0b0d4201 	bleq	350b64 <__bss_end+0x347f5c>
 35c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 360:	00000ecb 	andeq	r0, r0, fp, asr #29
 364:	0000001c 	andeq	r0, r0, ip, lsl r0
 368:	000002b4 			; <UNDEFINED> instruction: 0x000002b4
 36c:	000088a8 	andeq	r8, r0, r8, lsr #17
 370:	00000068 	andeq	r0, r0, r8, rrx
 374:	8b040e42 	blhi	103c84 <__bss_end+0xfb07c>
 378:	0b0d4201 	bleq	350b84 <__bss_end+0x347f7c>
 37c:	420d0d6c 	andmi	r0, sp, #108, 26	; 0x1b00
 380:	00000ecb 	andeq	r0, r0, fp, asr #29
 384:	0000001c 	andeq	r0, r0, ip, lsl r0
 388:	000002b4 			; <UNDEFINED> instruction: 0x000002b4
 38c:	00008910 	andeq	r8, r0, r0, lsl r9
 390:	00000080 	andeq	r0, r0, r0, lsl #1
 394:	8b040e42 	blhi	103ca4 <__bss_end+0xfb09c>
 398:	0b0d4201 	bleq	350ba4 <__bss_end+0x347f9c>
 39c:	420d0d78 	andmi	r0, sp, #120, 26	; 0x1e00
 3a0:	00000ecb 	andeq	r0, r0, fp, asr #29
 3a4:	0000000c 	andeq	r0, r0, ip
 3a8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 3ac:	7c010001 	stcvc	0, cr0, [r1], {1}
 3b0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 3b4:	0000000c 	andeq	r0, r0, ip
 3b8:	000003a4 	andeq	r0, r0, r4, lsr #7
 3bc:	00008990 	muleq	r0, r0, r9
 3c0:	000001ec 	andeq	r0, r0, ip, ror #3
