
./init_task:     file format elf32-littlearm


Disassembly of section .text:

00008000 <_start>:
_start():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/crt0.s:10
;@ startovaci symbol - vstupni bod z jadra OS do uzivatelskeho programu
;@ v podstate jen ihned zavola nejakou C funkci, nepotrebujeme nic tak kritickeho, abychom to vsechno museli psal v ASM
;@ jen _start vlastne ani neni funkce, takze by tento vstupni bod mel byt psany takto; rovnez je treba se ujistit, ze
;@ je tento symbol relokovany spravne na 0x8000 (tam OS ocekava, ze se nachazi vstupni bod)
_start:
    bl __crt0_run
    8000:	eb000017 	bl	8064 <__crt0_run>

00008004 <_hang>:
_hang():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/crt0.s:13
    ;@ z funkce __crt0_run by se nemel proces uz vratit, ale kdyby neco, tak se zacyklime
_hang:
    b _hang
    8004:	eafffffe 	b	8004 <_hang>

00008008 <__crt0_init_bss>:
__crt0_init_bss():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/crt0.c:10

extern unsigned int __bss_start;
extern unsigned int __bss_end;

void __crt0_init_bss()
{
    8008:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    800c:	e28db000 	add	fp, sp, #0
    8010:	e24dd00c 	sub	sp, sp, #12
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/crt0.c:11
    unsigned int* begin = (unsigned int*)&__bss_start;
    8014:	e59f3040 	ldr	r3, [pc, #64]	; 805c <__crt0_init_bss+0x54>
    8018:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/crt0.c:12
    for (; begin < (unsigned int*)&__bss_end; begin++)
    801c:	ea000005 	b	8038 <__crt0_init_bss+0x30>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/crt0.c:13 (discriminator 2)
        *begin = 0;
    8020:	e51b3008 	ldr	r3, [fp, #-8]
    8024:	e3a02000 	mov	r2, #0
    8028:	e5832000 	str	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/crt0.c:12 (discriminator 2)
    for (; begin < (unsigned int*)&__bss_end; begin++)
    802c:	e51b3008 	ldr	r3, [fp, #-8]
    8030:	e2833004 	add	r3, r3, #4
    8034:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/crt0.c:12 (discriminator 1)
    8038:	e51b3008 	ldr	r3, [fp, #-8]
    803c:	e59f201c 	ldr	r2, [pc, #28]	; 8060 <__crt0_init_bss+0x58>
    8040:	e1530002 	cmp	r3, r2
    8044:	3afffff5 	bcc	8020 <__crt0_init_bss+0x18>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/crt0.c:14
}
    8048:	e320f000 	nop	{0}
    804c:	e320f000 	nop	{0}
    8050:	e28bd000 	add	sp, fp, #0
    8054:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8058:	e12fff1e 	bx	lr
    805c:	00008de8 	andeq	r8, r0, r8, ror #27
    8060:	00008df8 	strdeq	r8, [r0], -r8	; <UNPREDICTABLE>

00008064 <__crt0_run>:
__crt0_run():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/crt0.c:17

void __crt0_run()
{
    8064:	e92d4800 	push	{fp, lr}
    8068:	e28db004 	add	fp, sp, #4
    806c:	e24dd008 	sub	sp, sp, #8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/crt0.c:19
    // inicializace .bss sekce (vynulovani)
    __crt0_init_bss();
    8070:	ebffffe4 	bl	8008 <__crt0_init_bss>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/crt0.c:22

    // volani konstruktoru globalnich trid (C++)
    _cpp_startup();
    8074:	eb000040 	bl	817c <_cpp_startup>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/crt0.c:27

    // volani funkce main
    // nebudeme se zde zabyvat predavanim parametru do funkce main
    // jinak by se mohly predavat napr. namapovane do virtualniho adr. prostoru a odkazem pres zasobnik (kam nam muze OS pushnout co chce)
    int result = main(0, 0);
    8078:	e3a01000 	mov	r1, #0
    807c:	e3a00000 	mov	r0, #0
    8080:	eb000069 	bl	822c <main>
    8084:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/crt0.c:30

    // volani destruktoru globalnich trid (C++)
    _cpp_shutdown();
    8088:	eb000051 	bl	81d4 <_cpp_shutdown>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/crt0.c:33

    // volani terminate() syscallu s navratovym kodem funkce main
    asm volatile("mov r0, %0" : : "r" (result));
    808c:	e51b3008 	ldr	r3, [fp, #-8]
    8090:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/crt0.c:34
    asm volatile("svc #1");
    8094:	ef000001 	svc	0x00000001
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/crt0.c:35
}
    8098:	e320f000 	nop	{0}
    809c:	e24bd004 	sub	sp, fp, #4
    80a0:	e8bd8800 	pop	{fp, pc}

000080a4 <__cxa_guard_acquire>:
__cxa_guard_acquire():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/cxxabi.cpp:11
	extern "C" int __cxa_guard_acquire (__guard *);
	extern "C" void __cxa_guard_release (__guard *);
	extern "C" void __cxa_guard_abort (__guard *);

	extern "C" int __cxa_guard_acquire (__guard *g)
	{
    80a4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    80a8:	e28db000 	add	fp, sp, #0
    80ac:	e24dd00c 	sub	sp, sp, #12
    80b0:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/cxxabi.cpp:12
		return !*(char *)(g);
    80b4:	e51b3008 	ldr	r3, [fp, #-8]
    80b8:	e5d33000 	ldrb	r3, [r3]
    80bc:	e3530000 	cmp	r3, #0
    80c0:	03a03001 	moveq	r3, #1
    80c4:	13a03000 	movne	r3, #0
    80c8:	e6ef3073 	uxtb	r3, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/cxxabi.cpp:13
	}
    80cc:	e1a00003 	mov	r0, r3
    80d0:	e28bd000 	add	sp, fp, #0
    80d4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    80d8:	e12fff1e 	bx	lr

000080dc <__cxa_guard_release>:
__cxa_guard_release():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/cxxabi.cpp:16

	extern "C" void __cxa_guard_release (__guard *g)
	{
    80dc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    80e0:	e28db000 	add	fp, sp, #0
    80e4:	e24dd00c 	sub	sp, sp, #12
    80e8:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/cxxabi.cpp:17
		*(char *)g = 1;
    80ec:	e51b3008 	ldr	r3, [fp, #-8]
    80f0:	e3a02001 	mov	r2, #1
    80f4:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/cxxabi.cpp:18
	}
    80f8:	e320f000 	nop	{0}
    80fc:	e28bd000 	add	sp, fp, #0
    8100:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8104:	e12fff1e 	bx	lr

00008108 <__cxa_guard_abort>:
__cxa_guard_abort():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/cxxabi.cpp:21

	extern "C" void __cxa_guard_abort (__guard *)
	{
    8108:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    810c:	e28db000 	add	fp, sp, #0
    8110:	e24dd00c 	sub	sp, sp, #12
    8114:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/cxxabi.cpp:23

	}
    8118:	e320f000 	nop	{0}
    811c:	e28bd000 	add	sp, fp, #0
    8120:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8124:	e12fff1e 	bx	lr

00008128 <__dso_handle>:
__dso_handle():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/cxxabi.cpp:27
}

extern "C" void __dso_handle()
{
    8128:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    812c:	e28db000 	add	fp, sp, #0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/cxxabi.cpp:29
    // ignore dtors for now
}
    8130:	e320f000 	nop	{0}
    8134:	e28bd000 	add	sp, fp, #0
    8138:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    813c:	e12fff1e 	bx	lr

00008140 <__cxa_atexit>:
__cxa_atexit():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/cxxabi.cpp:32

extern "C" void __cxa_atexit()
{
    8140:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8144:	e28db000 	add	fp, sp, #0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/cxxabi.cpp:34
    // ignore dtors for now
}
    8148:	e320f000 	nop	{0}
    814c:	e28bd000 	add	sp, fp, #0
    8150:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8154:	e12fff1e 	bx	lr

00008158 <__cxa_pure_virtual>:
__cxa_pure_virtual():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/cxxabi.cpp:37

extern "C" void __cxa_pure_virtual()
{
    8158:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    815c:	e28db000 	add	fp, sp, #0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/cxxabi.cpp:39
    // pure virtual method called
}
    8160:	e320f000 	nop	{0}
    8164:	e28bd000 	add	sp, fp, #0
    8168:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    816c:	e12fff1e 	bx	lr

00008170 <__aeabi_unwind_cpp_pr1>:
__aeabi_unwind_cpp_pr1():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/cxxabi.cpp:42

extern "C" void __aeabi_unwind_cpp_pr1()
{
    8170:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8174:	e28db000 	add	fp, sp, #0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/cxxabi.cpp:43 (discriminator 1)
	while (true)
    8178:	eafffffe 	b	8178 <__aeabi_unwind_cpp_pr1+0x8>

0000817c <_cpp_startup>:
_cpp_startup():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/cxxabi.cpp:61
extern "C" dtor_ptr __DTOR_LIST__[0];
// konec pole destruktoru
extern "C" dtor_ptr __DTOR_END__[0];

extern "C" int _cpp_startup(void)
{
    817c:	e92d4800 	push	{fp, lr}
    8180:	e28db004 	add	fp, sp, #4
    8184:	e24dd008 	sub	sp, sp, #8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/cxxabi.cpp:66
	ctor_ptr* fnptr;
	
	// zavolame konstruktory globalnich C++ trid
	// v poli __CTOR_LIST__ jsou ukazatele na vygenerovane stuby volani konstruktoru
	for (fnptr = __CTOR_LIST__; fnptr < __CTOR_END__; fnptr++)
    8188:	e59f303c 	ldr	r3, [pc, #60]	; 81cc <_cpp_startup+0x50>
    818c:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/cxxabi.cpp:66 (discriminator 3)
    8190:	e51b3008 	ldr	r3, [fp, #-8]
    8194:	e59f2034 	ldr	r2, [pc, #52]	; 81d0 <_cpp_startup+0x54>
    8198:	e1530002 	cmp	r3, r2
    819c:	2a000006 	bcs	81bc <_cpp_startup+0x40>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/cxxabi.cpp:67 (discriminator 2)
		(*fnptr)();
    81a0:	e51b3008 	ldr	r3, [fp, #-8]
    81a4:	e5933000 	ldr	r3, [r3]
    81a8:	e12fff33 	blx	r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/cxxabi.cpp:66 (discriminator 2)
	for (fnptr = __CTOR_LIST__; fnptr < __CTOR_END__; fnptr++)
    81ac:	e51b3008 	ldr	r3, [fp, #-8]
    81b0:	e2833004 	add	r3, r3, #4
    81b4:	e50b3008 	str	r3, [fp, #-8]
    81b8:	eafffff4 	b	8190 <_cpp_startup+0x14>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/cxxabi.cpp:69
	
	return 0;
    81bc:	e3a03000 	mov	r3, #0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/cxxabi.cpp:70
}
    81c0:	e1a00003 	mov	r0, r3
    81c4:	e24bd004 	sub	sp, fp, #4
    81c8:	e8bd8800 	pop	{fp, pc}
    81cc:	00008de5 	andeq	r8, r0, r5, ror #27
    81d0:	00008de5 	andeq	r8, r0, r5, ror #27

000081d4 <_cpp_shutdown>:
_cpp_shutdown():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/cxxabi.cpp:73

extern "C" int _cpp_shutdown(void)
{
    81d4:	e92d4800 	push	{fp, lr}
    81d8:	e28db004 	add	fp, sp, #4
    81dc:	e24dd008 	sub	sp, sp, #8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/cxxabi.cpp:77
	dtor_ptr* fnptr;
	
	// zavolame destruktory globalnich C++ trid
	for (fnptr = __DTOR_LIST__; fnptr < __DTOR_END__; fnptr++)
    81e0:	e59f303c 	ldr	r3, [pc, #60]	; 8224 <_cpp_shutdown+0x50>
    81e4:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/cxxabi.cpp:77 (discriminator 3)
    81e8:	e51b3008 	ldr	r3, [fp, #-8]
    81ec:	e59f2034 	ldr	r2, [pc, #52]	; 8228 <_cpp_shutdown+0x54>
    81f0:	e1530002 	cmp	r3, r2
    81f4:	2a000006 	bcs	8214 <_cpp_shutdown+0x40>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/cxxabi.cpp:78 (discriminator 2)
		(*fnptr)();
    81f8:	e51b3008 	ldr	r3, [fp, #-8]
    81fc:	e5933000 	ldr	r3, [r3]
    8200:	e12fff33 	blx	r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/cxxabi.cpp:77 (discriminator 2)
	for (fnptr = __DTOR_LIST__; fnptr < __DTOR_END__; fnptr++)
    8204:	e51b3008 	ldr	r3, [fp, #-8]
    8208:	e2833004 	add	r3, r3, #4
    820c:	e50b3008 	str	r3, [fp, #-8]
    8210:	eafffff4 	b	81e8 <_cpp_shutdown+0x14>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/cxxabi.cpp:80
	
	return 0;
    8214:	e3a03000 	mov	r3, #0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/cxxabi.cpp:81
}
    8218:	e1a00003 	mov	r0, r3
    821c:	e24bd004 	sub	sp, fp, #4
    8220:	e8bd8800 	pop	{fp, pc}
    8224:	00008de5 	andeq	r8, r0, r5, ror #27
    8228:	00008de5 	andeq	r8, r0, r5, ror #27

0000822c <main>:
main():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/init_task/main.cpp:6
#include <stdfile.h>

#include <process/process_manager.h>

int main(int argc, char** argv)
{
    822c:	e92d4800 	push	{fp, lr}
    8230:	e28db004 	add	fp, sp, #4
    8234:	e24dd008 	sub	sp, sp, #8
    8238:	e50b0008 	str	r0, [fp, #-8]
    823c:	e50b100c 	str	r1, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/init_task/main.cpp:11
	// systemovy init task startuje jako prvni, a ma nejnizsi prioritu ze vsech - bude se tedy planovat v podstate jen tehdy,
	// kdy nic jineho nikdo nema na praci

	// nastavime deadline na "nekonecno" = vlastne snizime dynamickou prioritu na nejnizsi moznou
	set_task_deadline(Indefinite);
    8240:	e3e00000 	mvn	r0, #0
    8244:	eb0000cd 	bl	8580 <_Z17set_task_deadlinej>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/init_task/main.cpp:15 (discriminator 1)

	// TODO: tady budeme chtit nechat spoustet zbytek procesu, az budeme umet nacitat treba z eMMC a SD karty
	
	while (true)
    8248:	eafffffe 	b	8248 <main+0x1c>

0000824c <_Z6getpidv>:
_Z6getpidv():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:5
#include <stdfile.h>
#include <stdstring.h>

uint32_t getpid()
{
    824c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8250:	e28db000 	add	fp, sp, #0
    8254:	e24dd00c 	sub	sp, sp, #12
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:8
    uint32_t pid;

    asm volatile("swi 0");
    8258:	ef000000 	svc	0x00000000
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:9
    asm volatile("mov %0, r0" : "=r" (pid));
    825c:	e1a03000 	mov	r3, r0
    8260:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:11

    return pid;
    8264:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:12
}
    8268:	e1a00003 	mov	r0, r3
    826c:	e28bd000 	add	sp, fp, #0
    8270:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8274:	e12fff1e 	bx	lr

00008278 <_Z9terminatei>:
_Z9terminatei():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:15

void terminate(int exitcode)
{
    8278:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    827c:	e28db000 	add	fp, sp, #0
    8280:	e24dd00c 	sub	sp, sp, #12
    8284:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:16
    asm volatile("mov r0, %0" : : "r" (exitcode));
    8288:	e51b3008 	ldr	r3, [fp, #-8]
    828c:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:17
    asm volatile("swi 1");
    8290:	ef000001 	svc	0x00000001
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:18
}
    8294:	e320f000 	nop	{0}
    8298:	e28bd000 	add	sp, fp, #0
    829c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    82a0:	e12fff1e 	bx	lr

000082a4 <_Z11sched_yieldv>:
_Z11sched_yieldv():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:21

void sched_yield()
{
    82a4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    82a8:	e28db000 	add	fp, sp, #0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:22
    asm volatile("swi 2");
    82ac:	ef000002 	svc	0x00000002
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:23
}
    82b0:	e320f000 	nop	{0}
    82b4:	e28bd000 	add	sp, fp, #0
    82b8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    82bc:	e12fff1e 	bx	lr

000082c0 <_Z4openPKc15NFile_Open_Mode>:
_Z4openPKc15NFile_Open_Mode():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:26

uint32_t open(const char* filename, NFile_Open_Mode mode)
{
    82c0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    82c4:	e28db000 	add	fp, sp, #0
    82c8:	e24dd014 	sub	sp, sp, #20
    82cc:	e50b0010 	str	r0, [fp, #-16]
    82d0:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:29
    uint32_t file;

    asm volatile("mov r0, %0" : : "r" (filename));
    82d4:	e51b3010 	ldr	r3, [fp, #-16]
    82d8:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:30
    asm volatile("mov r1, %0" : : "r" (mode));
    82dc:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    82e0:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:31
    asm volatile("swi 64");
    82e4:	ef000040 	svc	0x00000040
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:32
    asm volatile("mov %0, r0" : "=r" (file));
    82e8:	e1a03000 	mov	r3, r0
    82ec:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:34

    return file;
    82f0:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:35
}
    82f4:	e1a00003 	mov	r0, r3
    82f8:	e28bd000 	add	sp, fp, #0
    82fc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8300:	e12fff1e 	bx	lr

00008304 <_Z4readjPcj>:
_Z4readjPcj():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:38

uint32_t read(uint32_t file, char* const buffer, uint32_t size)
{
    8304:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8308:	e28db000 	add	fp, sp, #0
    830c:	e24dd01c 	sub	sp, sp, #28
    8310:	e50b0010 	str	r0, [fp, #-16]
    8314:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8318:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:41
    uint32_t rdnum;

    asm volatile("mov r0, %0" : : "r" (file));
    831c:	e51b3010 	ldr	r3, [fp, #-16]
    8320:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:42
    asm volatile("mov r1, %0" : : "r" (buffer));
    8324:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8328:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:43
    asm volatile("mov r2, %0" : : "r" (size));
    832c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8330:	e1a02003 	mov	r2, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:44
    asm volatile("swi 65");
    8334:	ef000041 	svc	0x00000041
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:45
    asm volatile("mov %0, r0" : "=r" (rdnum));
    8338:	e1a03000 	mov	r3, r0
    833c:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:47

    return rdnum;
    8340:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:48
}
    8344:	e1a00003 	mov	r0, r3
    8348:	e28bd000 	add	sp, fp, #0
    834c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8350:	e12fff1e 	bx	lr

00008354 <_Z5writejPKcj>:
_Z5writejPKcj():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:51

uint32_t write(uint32_t file, const char* buffer, uint32_t size)
{
    8354:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8358:	e28db000 	add	fp, sp, #0
    835c:	e24dd01c 	sub	sp, sp, #28
    8360:	e50b0010 	str	r0, [fp, #-16]
    8364:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8368:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:54
    uint32_t wrnum;

    asm volatile("mov r0, %0" : : "r" (file));
    836c:	e51b3010 	ldr	r3, [fp, #-16]
    8370:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:55
    asm volatile("mov r1, %0" : : "r" (buffer));
    8374:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8378:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:56
    asm volatile("mov r2, %0" : : "r" (size));
    837c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8380:	e1a02003 	mov	r2, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:57
    asm volatile("swi 66");
    8384:	ef000042 	svc	0x00000042
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:58
    asm volatile("mov %0, r0" : "=r" (wrnum));
    8388:	e1a03000 	mov	r3, r0
    838c:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:60

    return wrnum;
    8390:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:61
}
    8394:	e1a00003 	mov	r0, r3
    8398:	e28bd000 	add	sp, fp, #0
    839c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    83a0:	e12fff1e 	bx	lr

000083a4 <_Z5closej>:
_Z5closej():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:64

void close(uint32_t file)
{
    83a4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    83a8:	e28db000 	add	fp, sp, #0
    83ac:	e24dd00c 	sub	sp, sp, #12
    83b0:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:65
    asm volatile("mov r0, %0" : : "r" (file));
    83b4:	e51b3008 	ldr	r3, [fp, #-8]
    83b8:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:66
    asm volatile("swi 67");
    83bc:	ef000043 	svc	0x00000043
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:67
}
    83c0:	e320f000 	nop	{0}
    83c4:	e28bd000 	add	sp, fp, #0
    83c8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    83cc:	e12fff1e 	bx	lr

000083d0 <_Z5ioctlj16NIOCtl_OperationPv>:
_Z5ioctlj16NIOCtl_OperationPv():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:70

uint32_t ioctl(uint32_t file, NIOCtl_Operation operation, void* param)
{
    83d0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    83d4:	e28db000 	add	fp, sp, #0
    83d8:	e24dd01c 	sub	sp, sp, #28
    83dc:	e50b0010 	str	r0, [fp, #-16]
    83e0:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    83e4:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:73
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    83e8:	e51b3010 	ldr	r3, [fp, #-16]
    83ec:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:74
    asm volatile("mov r1, %0" : : "r" (operation));
    83f0:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    83f4:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:75
    asm volatile("mov r2, %0" : : "r" (param));
    83f8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    83fc:	e1a02003 	mov	r2, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:76
    asm volatile("swi 68");
    8400:	ef000044 	svc	0x00000044
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:77
    asm volatile("mov %0, r0" : "=r" (retcode));
    8404:	e1a03000 	mov	r3, r0
    8408:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:79

    return retcode;
    840c:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:80
}
    8410:	e1a00003 	mov	r0, r3
    8414:	e28bd000 	add	sp, fp, #0
    8418:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    841c:	e12fff1e 	bx	lr

00008420 <_Z6notifyjj>:
_Z6notifyjj():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:83

uint32_t notify(uint32_t file, uint32_t count)
{
    8420:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8424:	e28db000 	add	fp, sp, #0
    8428:	e24dd014 	sub	sp, sp, #20
    842c:	e50b0010 	str	r0, [fp, #-16]
    8430:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:86
    uint32_t retcnt;

    asm volatile("mov r0, %0" : : "r" (file));
    8434:	e51b3010 	ldr	r3, [fp, #-16]
    8438:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:87
    asm volatile("mov r1, %0" : : "r" (count));
    843c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8440:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:88
    asm volatile("swi 69");
    8444:	ef000045 	svc	0x00000045
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:89
    asm volatile("mov %0, r0" : "=r" (retcnt));
    8448:	e1a03000 	mov	r3, r0
    844c:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:91

    return retcnt;
    8450:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:92
}
    8454:	e1a00003 	mov	r0, r3
    8458:	e28bd000 	add	sp, fp, #0
    845c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8460:	e12fff1e 	bx	lr

00008464 <_Z4waitjjj>:
_Z4waitjjj():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:95

NSWI_Result_Code wait(uint32_t file, uint32_t count, uint32_t notified_deadline)
{
    8464:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8468:	e28db000 	add	fp, sp, #0
    846c:	e24dd01c 	sub	sp, sp, #28
    8470:	e50b0010 	str	r0, [fp, #-16]
    8474:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8478:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:98
    NSWI_Result_Code retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    847c:	e51b3010 	ldr	r3, [fp, #-16]
    8480:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:99
    asm volatile("mov r1, %0" : : "r" (count));
    8484:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8488:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:100
    asm volatile("mov r2, %0" : : "r" (notified_deadline));
    848c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8490:	e1a02003 	mov	r2, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:101
    asm volatile("swi 70");
    8494:	ef000046 	svc	0x00000046
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:102
    asm volatile("mov %0, r0" : "=r" (retcode));
    8498:	e1a03000 	mov	r3, r0
    849c:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:104

    return retcode;
    84a0:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:105
}
    84a4:	e1a00003 	mov	r0, r3
    84a8:	e28bd000 	add	sp, fp, #0
    84ac:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    84b0:	e12fff1e 	bx	lr

000084b4 <_Z5sleepjj>:
_Z5sleepjj():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:108

bool sleep(uint32_t ticks, uint32_t notified_deadline)
{
    84b4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    84b8:	e28db000 	add	fp, sp, #0
    84bc:	e24dd014 	sub	sp, sp, #20
    84c0:	e50b0010 	str	r0, [fp, #-16]
    84c4:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:111
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (ticks));
    84c8:	e51b3010 	ldr	r3, [fp, #-16]
    84cc:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:112
    asm volatile("mov r1, %0" : : "r" (notified_deadline));
    84d0:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    84d4:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:113
    asm volatile("swi 3");
    84d8:	ef000003 	svc	0x00000003
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:114
    asm volatile("mov %0, r0" : "=r" (retcode));
    84dc:	e1a03000 	mov	r3, r0
    84e0:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:116

    return retcode;
    84e4:	e51b3008 	ldr	r3, [fp, #-8]
    84e8:	e3530000 	cmp	r3, #0
    84ec:	13a03001 	movne	r3, #1
    84f0:	03a03000 	moveq	r3, #0
    84f4:	e6ef3073 	uxtb	r3, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:117
}
    84f8:	e1a00003 	mov	r0, r3
    84fc:	e28bd000 	add	sp, fp, #0
    8500:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8504:	e12fff1e 	bx	lr

00008508 <_Z24get_active_process_countv>:
_Z24get_active_process_countv():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:120

uint32_t get_active_process_count()
{
    8508:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    850c:	e28db000 	add	fp, sp, #0
    8510:	e24dd00c 	sub	sp, sp, #12
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:121
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Active_Process_Count;
    8514:	e3a03000 	mov	r3, #0
    8518:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:124
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r" (req));
    851c:	e3a03000 	mov	r3, #0
    8520:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:125
    asm volatile("mov r1, %0" : : "r" (&retval));
    8524:	e24b300c 	sub	r3, fp, #12
    8528:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:126
    asm volatile("swi 4");
    852c:	ef000004 	svc	0x00000004
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:128

    return retval;
    8530:	e51b300c 	ldr	r3, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:129
}
    8534:	e1a00003 	mov	r0, r3
    8538:	e28bd000 	add	sp, fp, #0
    853c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8540:	e12fff1e 	bx	lr

00008544 <_Z14get_tick_countv>:
_Z14get_tick_countv():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:132

uint32_t get_tick_count()
{
    8544:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8548:	e28db000 	add	fp, sp, #0
    854c:	e24dd00c 	sub	sp, sp, #12
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:133
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Tick_Count;
    8550:	e3a03001 	mov	r3, #1
    8554:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:136
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r" (req));
    8558:	e3a03001 	mov	r3, #1
    855c:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:137
    asm volatile("mov r1, %0" : : "r" (&retval));
    8560:	e24b300c 	sub	r3, fp, #12
    8564:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:138
    asm volatile("swi 4");
    8568:	ef000004 	svc	0x00000004
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:140

    return retval;
    856c:	e51b300c 	ldr	r3, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:141
}
    8570:	e1a00003 	mov	r0, r3
    8574:	e28bd000 	add	sp, fp, #0
    8578:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    857c:	e12fff1e 	bx	lr

00008580 <_Z17set_task_deadlinej>:
_Z17set_task_deadlinej():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:144

void set_task_deadline(uint32_t tick_count_required)
{
    8580:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8584:	e28db000 	add	fp, sp, #0
    8588:	e24dd014 	sub	sp, sp, #20
    858c:	e50b0010 	str	r0, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:145
    const NDeadline_Subservice req = NDeadline_Subservice::Set_Relative;
    8590:	e3a03000 	mov	r3, #0
    8594:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:147

    asm volatile("mov r0, %0" : : "r" (req));
    8598:	e3a03000 	mov	r3, #0
    859c:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:148
    asm volatile("mov r1, %0" : : "r" (&tick_count_required));
    85a0:	e24b3010 	sub	r3, fp, #16
    85a4:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:149
    asm volatile("swi 5");
    85a8:	ef000005 	svc	0x00000005
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:150
}
    85ac:	e320f000 	nop	{0}
    85b0:	e28bd000 	add	sp, fp, #0
    85b4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    85b8:	e12fff1e 	bx	lr

000085bc <_Z26get_task_ticks_to_deadlinev>:
_Z26get_task_ticks_to_deadlinev():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:153

uint32_t get_task_ticks_to_deadline()
{
    85bc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    85c0:	e28db000 	add	fp, sp, #0
    85c4:	e24dd00c 	sub	sp, sp, #12
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:154
    const NDeadline_Subservice req = NDeadline_Subservice::Get_Remaining;
    85c8:	e3a03001 	mov	r3, #1
    85cc:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:157
    uint32_t ticks;

    asm volatile("mov r0, %0" : : "r" (req));
    85d0:	e3a03001 	mov	r3, #1
    85d4:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:158
    asm volatile("mov r1, %0" : : "r" (&ticks));
    85d8:	e24b300c 	sub	r3, fp, #12
    85dc:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:159
    asm volatile("swi 5");
    85e0:	ef000005 	svc	0x00000005
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:161

    return ticks;
    85e4:	e51b300c 	ldr	r3, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:162
}
    85e8:	e1a00003 	mov	r0, r3
    85ec:	e28bd000 	add	sp, fp, #0
    85f0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    85f4:	e12fff1e 	bx	lr

000085f8 <_Z4pipePKcj>:
_Z4pipePKcj():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:167

const char Pipe_File_Prefix[] = "SYS:pipe/";

uint32_t pipe(const char* name, uint32_t buf_size)
{
    85f8:	e92d4800 	push	{fp, lr}
    85fc:	e28db004 	add	fp, sp, #4
    8600:	e24dd050 	sub	sp, sp, #80	; 0x50
    8604:	e50b0050 	str	r0, [fp, #-80]	; 0xffffffb0
    8608:	e50b1054 	str	r1, [fp, #-84]	; 0xffffffac
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:169
    char fname[64];
    strncpy(fname, Pipe_File_Prefix, sizeof(Pipe_File_Prefix));
    860c:	e24b3048 	sub	r3, fp, #72	; 0x48
    8610:	e3a0200a 	mov	r2, #10
    8614:	e59f1088 	ldr	r1, [pc, #136]	; 86a4 <_Z4pipePKcj+0xac>
    8618:	e1a00003 	mov	r0, r3
    861c:	eb0000a5 	bl	88b8 <_Z7strncpyPcPKci>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:170
    strncpy(fname + sizeof(Pipe_File_Prefix), name, sizeof(fname) - sizeof(Pipe_File_Prefix) - 1);
    8620:	e24b3048 	sub	r3, fp, #72	; 0x48
    8624:	e283300a 	add	r3, r3, #10
    8628:	e3a02035 	mov	r2, #53	; 0x35
    862c:	e51b1050 	ldr	r1, [fp, #-80]	; 0xffffffb0
    8630:	e1a00003 	mov	r0, r3
    8634:	eb00009f 	bl	88b8 <_Z7strncpyPcPKci>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:172

    int ncur = sizeof(Pipe_File_Prefix) + strlen(name);
    8638:	e51b0050 	ldr	r0, [fp, #-80]	; 0xffffffb0
    863c:	eb0000f8 	bl	8a24 <_Z6strlenPKc>
    8640:	e1a03000 	mov	r3, r0
    8644:	e283300a 	add	r3, r3, #10
    8648:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:174

    fname[ncur++] = '#';
    864c:	e51b3008 	ldr	r3, [fp, #-8]
    8650:	e2832001 	add	r2, r3, #1
    8654:	e50b2008 	str	r2, [fp, #-8]
    8658:	e2433004 	sub	r3, r3, #4
    865c:	e083300b 	add	r3, r3, fp
    8660:	e3a02023 	mov	r2, #35	; 0x23
    8664:	e5432044 	strb	r2, [r3, #-68]	; 0xffffffbc
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:176

    itoa(buf_size, &fname[ncur], 10);
    8668:	e24b2048 	sub	r2, fp, #72	; 0x48
    866c:	e51b3008 	ldr	r3, [fp, #-8]
    8670:	e0823003 	add	r3, r2, r3
    8674:	e3a0200a 	mov	r2, #10
    8678:	e1a01003 	mov	r1, r3
    867c:	e51b0054 	ldr	r0, [fp, #-84]	; 0xffffffac
    8680:	eb000008 	bl	86a8 <_Z4itoajPcj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:178

    return open(fname, NFile_Open_Mode::Read_Write);
    8684:	e24b3048 	sub	r3, fp, #72	; 0x48
    8688:	e3a01002 	mov	r1, #2
    868c:	e1a00003 	mov	r0, r3
    8690:	ebffff0a 	bl	82c0 <_Z4openPKc15NFile_Open_Mode>
    8694:	e1a03000 	mov	r3, r0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:179
}
    8698:	e1a00003 	mov	r0, r3
    869c:	e24bd004 	sub	sp, fp, #4
    86a0:	e8bd8800 	pop	{fp, pc}
    86a4:	00008dc8 	andeq	r8, r0, r8, asr #27

000086a8 <_Z4itoajPcj>:
_Z4itoajPcj():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:9
{
    const char CharConvArr[] = "0123456789ABCDEF";
}

void itoa(unsigned int input, char* output, unsigned int base)
{
    86a8:	e92d4800 	push	{fp, lr}
    86ac:	e28db004 	add	fp, sp, #4
    86b0:	e24dd020 	sub	sp, sp, #32
    86b4:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    86b8:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    86bc:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:10
	int i = 0;
    86c0:	e3a03000 	mov	r3, #0
    86c4:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:12

	while (input > 0)
    86c8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    86cc:	e3530000 	cmp	r3, #0
    86d0:	0a000014 	beq	8728 <_Z4itoajPcj+0x80>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:14
	{
		output[i] = CharConvArr[input % base];
    86d4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    86d8:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    86dc:	e1a00003 	mov	r0, r3
    86e0:	eb000199 	bl	8d4c <__aeabi_uidivmod>
    86e4:	e1a03001 	mov	r3, r1
    86e8:	e1a01003 	mov	r1, r3
    86ec:	e51b3008 	ldr	r3, [fp, #-8]
    86f0:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    86f4:	e0823003 	add	r3, r2, r3
    86f8:	e59f2118 	ldr	r2, [pc, #280]	; 8818 <_Z4itoajPcj+0x170>
    86fc:	e7d22001 	ldrb	r2, [r2, r1]
    8700:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:15
		input /= base;
    8704:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    8708:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    870c:	eb000113 	bl	8b60 <__udivsi3>
    8710:	e1a03000 	mov	r3, r0
    8714:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:16
		i++;
    8718:	e51b3008 	ldr	r3, [fp, #-8]
    871c:	e2833001 	add	r3, r3, #1
    8720:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:12
	while (input > 0)
    8724:	eaffffe7 	b	86c8 <_Z4itoajPcj+0x20>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:19
	}

    if (i == 0)
    8728:	e51b3008 	ldr	r3, [fp, #-8]
    872c:	e3530000 	cmp	r3, #0
    8730:	1a000007 	bne	8754 <_Z4itoajPcj+0xac>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:21
    {
        output[i] = CharConvArr[0];
    8734:	e51b3008 	ldr	r3, [fp, #-8]
    8738:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    873c:	e0823003 	add	r3, r2, r3
    8740:	e3a02030 	mov	r2, #48	; 0x30
    8744:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:22
        i++;
    8748:	e51b3008 	ldr	r3, [fp, #-8]
    874c:	e2833001 	add	r3, r3, #1
    8750:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:25
    }

	output[i] = '\0';
    8754:	e51b3008 	ldr	r3, [fp, #-8]
    8758:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    875c:	e0823003 	add	r3, r2, r3
    8760:	e3a02000 	mov	r2, #0
    8764:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:26
	i--;
    8768:	e51b3008 	ldr	r3, [fp, #-8]
    876c:	e2433001 	sub	r3, r3, #1
    8770:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:28

	for (int j = 0; j <= i/2; j++)
    8774:	e3a03000 	mov	r3, #0
    8778:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:28 (discriminator 3)
    877c:	e51b3008 	ldr	r3, [fp, #-8]
    8780:	e1a02fa3 	lsr	r2, r3, #31
    8784:	e0823003 	add	r3, r2, r3
    8788:	e1a030c3 	asr	r3, r3, #1
    878c:	e1a02003 	mov	r2, r3
    8790:	e51b300c 	ldr	r3, [fp, #-12]
    8794:	e1530002 	cmp	r3, r2
    8798:	ca00001b 	bgt	880c <_Z4itoajPcj+0x164>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:30 (discriminator 2)
	{
		char c = output[i - j];
    879c:	e51b2008 	ldr	r2, [fp, #-8]
    87a0:	e51b300c 	ldr	r3, [fp, #-12]
    87a4:	e0423003 	sub	r3, r2, r3
    87a8:	e1a02003 	mov	r2, r3
    87ac:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    87b0:	e0833002 	add	r3, r3, r2
    87b4:	e5d33000 	ldrb	r3, [r3]
    87b8:	e54b300d 	strb	r3, [fp, #-13]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:31 (discriminator 2)
		output[i - j] = output[j];
    87bc:	e51b300c 	ldr	r3, [fp, #-12]
    87c0:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    87c4:	e0822003 	add	r2, r2, r3
    87c8:	e51b1008 	ldr	r1, [fp, #-8]
    87cc:	e51b300c 	ldr	r3, [fp, #-12]
    87d0:	e0413003 	sub	r3, r1, r3
    87d4:	e1a01003 	mov	r1, r3
    87d8:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    87dc:	e0833001 	add	r3, r3, r1
    87e0:	e5d22000 	ldrb	r2, [r2]
    87e4:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:32 (discriminator 2)
		output[j] = c;
    87e8:	e51b300c 	ldr	r3, [fp, #-12]
    87ec:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    87f0:	e0823003 	add	r3, r2, r3
    87f4:	e55b200d 	ldrb	r2, [fp, #-13]
    87f8:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:28 (discriminator 2)
	for (int j = 0; j <= i/2; j++)
    87fc:	e51b300c 	ldr	r3, [fp, #-12]
    8800:	e2833001 	add	r3, r3, #1
    8804:	e50b300c 	str	r3, [fp, #-12]
    8808:	eaffffdb 	b	877c <_Z4itoajPcj+0xd4>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:34
	}
}
    880c:	e320f000 	nop	{0}
    8810:	e24bd004 	sub	sp, fp, #4
    8814:	e8bd8800 	pop	{fp, pc}
    8818:	00008dd4 	ldrdeq	r8, [r0], -r4

0000881c <_Z4atoiPKc>:
_Z4atoiPKc():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:37

int atoi(const char* input)
{
    881c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8820:	e28db000 	add	fp, sp, #0
    8824:	e24dd014 	sub	sp, sp, #20
    8828:	e50b0010 	str	r0, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:38
	int output = 0;
    882c:	e3a03000 	mov	r3, #0
    8830:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:40

	while (*input != '\0')
    8834:	e51b3010 	ldr	r3, [fp, #-16]
    8838:	e5d33000 	ldrb	r3, [r3]
    883c:	e3530000 	cmp	r3, #0
    8840:	0a000017 	beq	88a4 <_Z4atoiPKc+0x88>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:42
	{
		output *= 10;
    8844:	e51b2008 	ldr	r2, [fp, #-8]
    8848:	e1a03002 	mov	r3, r2
    884c:	e1a03103 	lsl	r3, r3, #2
    8850:	e0833002 	add	r3, r3, r2
    8854:	e1a03083 	lsl	r3, r3, #1
    8858:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:43
		if (*input > '9' || *input < '0')
    885c:	e51b3010 	ldr	r3, [fp, #-16]
    8860:	e5d33000 	ldrb	r3, [r3]
    8864:	e3530039 	cmp	r3, #57	; 0x39
    8868:	8a00000d 	bhi	88a4 <_Z4atoiPKc+0x88>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:43 (discriminator 1)
    886c:	e51b3010 	ldr	r3, [fp, #-16]
    8870:	e5d33000 	ldrb	r3, [r3]
    8874:	e353002f 	cmp	r3, #47	; 0x2f
    8878:	9a000009 	bls	88a4 <_Z4atoiPKc+0x88>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:46
			break;

		output += *input - '0';
    887c:	e51b3010 	ldr	r3, [fp, #-16]
    8880:	e5d33000 	ldrb	r3, [r3]
    8884:	e2433030 	sub	r3, r3, #48	; 0x30
    8888:	e51b2008 	ldr	r2, [fp, #-8]
    888c:	e0823003 	add	r3, r2, r3
    8890:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:48

		input++;
    8894:	e51b3010 	ldr	r3, [fp, #-16]
    8898:	e2833001 	add	r3, r3, #1
    889c:	e50b3010 	str	r3, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:40
	while (*input != '\0')
    88a0:	eaffffe3 	b	8834 <_Z4atoiPKc+0x18>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:51
	}

	return output;
    88a4:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:52
}
    88a8:	e1a00003 	mov	r0, r3
    88ac:	e28bd000 	add	sp, fp, #0
    88b0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    88b4:	e12fff1e 	bx	lr

000088b8 <_Z7strncpyPcPKci>:
_Z7strncpyPcPKci():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:55

char* strncpy(char* dest, const char *src, int num)
{
    88b8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    88bc:	e28db000 	add	fp, sp, #0
    88c0:	e24dd01c 	sub	sp, sp, #28
    88c4:	e50b0010 	str	r0, [fp, #-16]
    88c8:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    88cc:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:58
	int i;

	for (i = 0; i < num && src[i] != '\0'; i++)
    88d0:	e3a03000 	mov	r3, #0
    88d4:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:58 (discriminator 4)
    88d8:	e51b2008 	ldr	r2, [fp, #-8]
    88dc:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    88e0:	e1520003 	cmp	r2, r3
    88e4:	aa000011 	bge	8930 <_Z7strncpyPcPKci+0x78>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:58 (discriminator 2)
    88e8:	e51b3008 	ldr	r3, [fp, #-8]
    88ec:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    88f0:	e0823003 	add	r3, r2, r3
    88f4:	e5d33000 	ldrb	r3, [r3]
    88f8:	e3530000 	cmp	r3, #0
    88fc:	0a00000b 	beq	8930 <_Z7strncpyPcPKci+0x78>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:59 (discriminator 3)
		dest[i] = src[i];
    8900:	e51b3008 	ldr	r3, [fp, #-8]
    8904:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8908:	e0822003 	add	r2, r2, r3
    890c:	e51b3008 	ldr	r3, [fp, #-8]
    8910:	e51b1010 	ldr	r1, [fp, #-16]
    8914:	e0813003 	add	r3, r1, r3
    8918:	e5d22000 	ldrb	r2, [r2]
    891c:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:58 (discriminator 3)
	for (i = 0; i < num && src[i] != '\0'; i++)
    8920:	e51b3008 	ldr	r3, [fp, #-8]
    8924:	e2833001 	add	r3, r3, #1
    8928:	e50b3008 	str	r3, [fp, #-8]
    892c:	eaffffe9 	b	88d8 <_Z7strncpyPcPKci+0x20>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:60 (discriminator 2)
	for (; i < num; i++)
    8930:	e51b2008 	ldr	r2, [fp, #-8]
    8934:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8938:	e1520003 	cmp	r2, r3
    893c:	aa000008 	bge	8964 <_Z7strncpyPcPKci+0xac>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:61 (discriminator 1)
		dest[i] = '\0';
    8940:	e51b3008 	ldr	r3, [fp, #-8]
    8944:	e51b2010 	ldr	r2, [fp, #-16]
    8948:	e0823003 	add	r3, r2, r3
    894c:	e3a02000 	mov	r2, #0
    8950:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:60 (discriminator 1)
	for (; i < num; i++)
    8954:	e51b3008 	ldr	r3, [fp, #-8]
    8958:	e2833001 	add	r3, r3, #1
    895c:	e50b3008 	str	r3, [fp, #-8]
    8960:	eafffff2 	b	8930 <_Z7strncpyPcPKci+0x78>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:63

   return dest;
    8964:	e51b3010 	ldr	r3, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:64
}
    8968:	e1a00003 	mov	r0, r3
    896c:	e28bd000 	add	sp, fp, #0
    8970:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8974:	e12fff1e 	bx	lr

00008978 <_Z7strncmpPKcS0_i>:
_Z7strncmpPKcS0_i():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:67

int strncmp(const char *s1, const char *s2, int num)
{
    8978:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    897c:	e28db000 	add	fp, sp, #0
    8980:	e24dd01c 	sub	sp, sp, #28
    8984:	e50b0010 	str	r0, [fp, #-16]
    8988:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    898c:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:69
	unsigned char u1, u2;
  	while (num-- > 0)
    8990:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8994:	e2432001 	sub	r2, r3, #1
    8998:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
    899c:	e3530000 	cmp	r3, #0
    89a0:	c3a03001 	movgt	r3, #1
    89a4:	d3a03000 	movle	r3, #0
    89a8:	e6ef3073 	uxtb	r3, r3
    89ac:	e3530000 	cmp	r3, #0
    89b0:	0a000016 	beq	8a10 <_Z7strncmpPKcS0_i+0x98>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:71
    {
      	u1 = (unsigned char) *s1++;
    89b4:	e51b3010 	ldr	r3, [fp, #-16]
    89b8:	e2832001 	add	r2, r3, #1
    89bc:	e50b2010 	str	r2, [fp, #-16]
    89c0:	e5d33000 	ldrb	r3, [r3]
    89c4:	e54b3005 	strb	r3, [fp, #-5]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:72
     	u2 = (unsigned char) *s2++;
    89c8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    89cc:	e2832001 	add	r2, r3, #1
    89d0:	e50b2014 	str	r2, [fp, #-20]	; 0xffffffec
    89d4:	e5d33000 	ldrb	r3, [r3]
    89d8:	e54b3006 	strb	r3, [fp, #-6]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:73
      	if (u1 != u2)
    89dc:	e55b2005 	ldrb	r2, [fp, #-5]
    89e0:	e55b3006 	ldrb	r3, [fp, #-6]
    89e4:	e1520003 	cmp	r2, r3
    89e8:	0a000003 	beq	89fc <_Z7strncmpPKcS0_i+0x84>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:74
        	return u1 - u2;
    89ec:	e55b2005 	ldrb	r2, [fp, #-5]
    89f0:	e55b3006 	ldrb	r3, [fp, #-6]
    89f4:	e0423003 	sub	r3, r2, r3
    89f8:	ea000005 	b	8a14 <_Z7strncmpPKcS0_i+0x9c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:75
      	if (u1 == '\0')
    89fc:	e55b3005 	ldrb	r3, [fp, #-5]
    8a00:	e3530000 	cmp	r3, #0
    8a04:	1affffe1 	bne	8990 <_Z7strncmpPKcS0_i+0x18>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:76
        	return 0;
    8a08:	e3a03000 	mov	r3, #0
    8a0c:	ea000000 	b	8a14 <_Z7strncmpPKcS0_i+0x9c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:79
    }

  	return 0;
    8a10:	e3a03000 	mov	r3, #0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:80
}
    8a14:	e1a00003 	mov	r0, r3
    8a18:	e28bd000 	add	sp, fp, #0
    8a1c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8a20:	e12fff1e 	bx	lr

00008a24 <_Z6strlenPKc>:
_Z6strlenPKc():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:83

int strlen(const char* s)
{
    8a24:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8a28:	e28db000 	add	fp, sp, #0
    8a2c:	e24dd014 	sub	sp, sp, #20
    8a30:	e50b0010 	str	r0, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:84
	int i = 0;
    8a34:	e3a03000 	mov	r3, #0
    8a38:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:86

	while (s[i] != '\0')
    8a3c:	e51b3008 	ldr	r3, [fp, #-8]
    8a40:	e51b2010 	ldr	r2, [fp, #-16]
    8a44:	e0823003 	add	r3, r2, r3
    8a48:	e5d33000 	ldrb	r3, [r3]
    8a4c:	e3530000 	cmp	r3, #0
    8a50:	0a000003 	beq	8a64 <_Z6strlenPKc+0x40>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:87
		i++;
    8a54:	e51b3008 	ldr	r3, [fp, #-8]
    8a58:	e2833001 	add	r3, r3, #1
    8a5c:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:86
	while (s[i] != '\0')
    8a60:	eafffff5 	b	8a3c <_Z6strlenPKc+0x18>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:89

	return i;
    8a64:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:90
}
    8a68:	e1a00003 	mov	r0, r3
    8a6c:	e28bd000 	add	sp, fp, #0
    8a70:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8a74:	e12fff1e 	bx	lr

00008a78 <_Z5bzeroPvi>:
_Z5bzeroPvi():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:93

void bzero(void* memory, int length)
{
    8a78:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8a7c:	e28db000 	add	fp, sp, #0
    8a80:	e24dd014 	sub	sp, sp, #20
    8a84:	e50b0010 	str	r0, [fp, #-16]
    8a88:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:94
	char* mem = reinterpret_cast<char*>(memory);
    8a8c:	e51b3010 	ldr	r3, [fp, #-16]
    8a90:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:96

	for (int i = 0; i < length; i++)
    8a94:	e3a03000 	mov	r3, #0
    8a98:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:96 (discriminator 3)
    8a9c:	e51b2008 	ldr	r2, [fp, #-8]
    8aa0:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8aa4:	e1520003 	cmp	r2, r3
    8aa8:	aa000008 	bge	8ad0 <_Z5bzeroPvi+0x58>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:97 (discriminator 2)
		mem[i] = 0;
    8aac:	e51b3008 	ldr	r3, [fp, #-8]
    8ab0:	e51b200c 	ldr	r2, [fp, #-12]
    8ab4:	e0823003 	add	r3, r2, r3
    8ab8:	e3a02000 	mov	r2, #0
    8abc:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:96 (discriminator 2)
	for (int i = 0; i < length; i++)
    8ac0:	e51b3008 	ldr	r3, [fp, #-8]
    8ac4:	e2833001 	add	r3, r3, #1
    8ac8:	e50b3008 	str	r3, [fp, #-8]
    8acc:	eafffff2 	b	8a9c <_Z5bzeroPvi+0x24>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:98
}
    8ad0:	e320f000 	nop	{0}
    8ad4:	e28bd000 	add	sp, fp, #0
    8ad8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8adc:	e12fff1e 	bx	lr

00008ae0 <_Z6memcpyPKvPvi>:
_Z6memcpyPKvPvi():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:101

void memcpy(const void* src, void* dst, int num)
{
    8ae0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8ae4:	e28db000 	add	fp, sp, #0
    8ae8:	e24dd024 	sub	sp, sp, #36	; 0x24
    8aec:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8af0:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    8af4:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:102
	const char* memsrc = reinterpret_cast<const char*>(src);
    8af8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8afc:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:103
	char* memdst = reinterpret_cast<char*>(dst);
    8b00:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8b04:	e50b3010 	str	r3, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:105

	for (int i = 0; i < num; i++)
    8b08:	e3a03000 	mov	r3, #0
    8b0c:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:105 (discriminator 3)
    8b10:	e51b2008 	ldr	r2, [fp, #-8]
    8b14:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8b18:	e1520003 	cmp	r2, r3
    8b1c:	aa00000b 	bge	8b50 <_Z6memcpyPKvPvi+0x70>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:106 (discriminator 2)
		memdst[i] = memsrc[i];
    8b20:	e51b3008 	ldr	r3, [fp, #-8]
    8b24:	e51b200c 	ldr	r2, [fp, #-12]
    8b28:	e0822003 	add	r2, r2, r3
    8b2c:	e51b3008 	ldr	r3, [fp, #-8]
    8b30:	e51b1010 	ldr	r1, [fp, #-16]
    8b34:	e0813003 	add	r3, r1, r3
    8b38:	e5d22000 	ldrb	r2, [r2]
    8b3c:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:105 (discriminator 2)
	for (int i = 0; i < num; i++)
    8b40:	e51b3008 	ldr	r3, [fp, #-8]
    8b44:	e2833001 	add	r3, r3, #1
    8b48:	e50b3008 	str	r3, [fp, #-8]
    8b4c:	eaffffef 	b	8b10 <_Z6memcpyPKvPvi+0x30>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:107
}
    8b50:	e320f000 	nop	{0}
    8b54:	e28bd000 	add	sp, fp, #0
    8b58:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8b5c:	e12fff1e 	bx	lr

00008b60 <__udivsi3>:
__udivsi3():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1104
    8b60:	e2512001 	subs	r2, r1, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1106
    8b64:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1107
    8b68:	3a000074 	bcc	8d40 <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1108
    8b6c:	e1500001 	cmp	r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1109
    8b70:	9a00006b 	bls	8d24 <__udivsi3+0x1c4>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1110
    8b74:	e1110002 	tst	r1, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1111
    8b78:	0a00006c 	beq	8d30 <__udivsi3+0x1d0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1113
    8b7c:	e16f3f10 	clz	r3, r0
    8b80:	e16f2f11 	clz	r2, r1
    8b84:	e0423003 	sub	r3, r2, r3
    8b88:	e273301f 	rsbs	r3, r3, #31
    8b8c:	10833083 	addne	r3, r3, r3, lsl #1
    8b90:	e3a02000 	mov	r2, #0
    8b94:	108ff103 	addne	pc, pc, r3, lsl #2
    8b98:	e1a00000 	nop			; (mov r0, r0)
    8b9c:	e1500f81 	cmp	r0, r1, lsl #31
    8ba0:	e0a22002 	adc	r2, r2, r2
    8ba4:	20400f81 	subcs	r0, r0, r1, lsl #31
    8ba8:	e1500f01 	cmp	r0, r1, lsl #30
    8bac:	e0a22002 	adc	r2, r2, r2
    8bb0:	20400f01 	subcs	r0, r0, r1, lsl #30
    8bb4:	e1500e81 	cmp	r0, r1, lsl #29
    8bb8:	e0a22002 	adc	r2, r2, r2
    8bbc:	20400e81 	subcs	r0, r0, r1, lsl #29
    8bc0:	e1500e01 	cmp	r0, r1, lsl #28
    8bc4:	e0a22002 	adc	r2, r2, r2
    8bc8:	20400e01 	subcs	r0, r0, r1, lsl #28
    8bcc:	e1500d81 	cmp	r0, r1, lsl #27
    8bd0:	e0a22002 	adc	r2, r2, r2
    8bd4:	20400d81 	subcs	r0, r0, r1, lsl #27
    8bd8:	e1500d01 	cmp	r0, r1, lsl #26
    8bdc:	e0a22002 	adc	r2, r2, r2
    8be0:	20400d01 	subcs	r0, r0, r1, lsl #26
    8be4:	e1500c81 	cmp	r0, r1, lsl #25
    8be8:	e0a22002 	adc	r2, r2, r2
    8bec:	20400c81 	subcs	r0, r0, r1, lsl #25
    8bf0:	e1500c01 	cmp	r0, r1, lsl #24
    8bf4:	e0a22002 	adc	r2, r2, r2
    8bf8:	20400c01 	subcs	r0, r0, r1, lsl #24
    8bfc:	e1500b81 	cmp	r0, r1, lsl #23
    8c00:	e0a22002 	adc	r2, r2, r2
    8c04:	20400b81 	subcs	r0, r0, r1, lsl #23
    8c08:	e1500b01 	cmp	r0, r1, lsl #22
    8c0c:	e0a22002 	adc	r2, r2, r2
    8c10:	20400b01 	subcs	r0, r0, r1, lsl #22
    8c14:	e1500a81 	cmp	r0, r1, lsl #21
    8c18:	e0a22002 	adc	r2, r2, r2
    8c1c:	20400a81 	subcs	r0, r0, r1, lsl #21
    8c20:	e1500a01 	cmp	r0, r1, lsl #20
    8c24:	e0a22002 	adc	r2, r2, r2
    8c28:	20400a01 	subcs	r0, r0, r1, lsl #20
    8c2c:	e1500981 	cmp	r0, r1, lsl #19
    8c30:	e0a22002 	adc	r2, r2, r2
    8c34:	20400981 	subcs	r0, r0, r1, lsl #19
    8c38:	e1500901 	cmp	r0, r1, lsl #18
    8c3c:	e0a22002 	adc	r2, r2, r2
    8c40:	20400901 	subcs	r0, r0, r1, lsl #18
    8c44:	e1500881 	cmp	r0, r1, lsl #17
    8c48:	e0a22002 	adc	r2, r2, r2
    8c4c:	20400881 	subcs	r0, r0, r1, lsl #17
    8c50:	e1500801 	cmp	r0, r1, lsl #16
    8c54:	e0a22002 	adc	r2, r2, r2
    8c58:	20400801 	subcs	r0, r0, r1, lsl #16
    8c5c:	e1500781 	cmp	r0, r1, lsl #15
    8c60:	e0a22002 	adc	r2, r2, r2
    8c64:	20400781 	subcs	r0, r0, r1, lsl #15
    8c68:	e1500701 	cmp	r0, r1, lsl #14
    8c6c:	e0a22002 	adc	r2, r2, r2
    8c70:	20400701 	subcs	r0, r0, r1, lsl #14
    8c74:	e1500681 	cmp	r0, r1, lsl #13
    8c78:	e0a22002 	adc	r2, r2, r2
    8c7c:	20400681 	subcs	r0, r0, r1, lsl #13
    8c80:	e1500601 	cmp	r0, r1, lsl #12
    8c84:	e0a22002 	adc	r2, r2, r2
    8c88:	20400601 	subcs	r0, r0, r1, lsl #12
    8c8c:	e1500581 	cmp	r0, r1, lsl #11
    8c90:	e0a22002 	adc	r2, r2, r2
    8c94:	20400581 	subcs	r0, r0, r1, lsl #11
    8c98:	e1500501 	cmp	r0, r1, lsl #10
    8c9c:	e0a22002 	adc	r2, r2, r2
    8ca0:	20400501 	subcs	r0, r0, r1, lsl #10
    8ca4:	e1500481 	cmp	r0, r1, lsl #9
    8ca8:	e0a22002 	adc	r2, r2, r2
    8cac:	20400481 	subcs	r0, r0, r1, lsl #9
    8cb0:	e1500401 	cmp	r0, r1, lsl #8
    8cb4:	e0a22002 	adc	r2, r2, r2
    8cb8:	20400401 	subcs	r0, r0, r1, lsl #8
    8cbc:	e1500381 	cmp	r0, r1, lsl #7
    8cc0:	e0a22002 	adc	r2, r2, r2
    8cc4:	20400381 	subcs	r0, r0, r1, lsl #7
    8cc8:	e1500301 	cmp	r0, r1, lsl #6
    8ccc:	e0a22002 	adc	r2, r2, r2
    8cd0:	20400301 	subcs	r0, r0, r1, lsl #6
    8cd4:	e1500281 	cmp	r0, r1, lsl #5
    8cd8:	e0a22002 	adc	r2, r2, r2
    8cdc:	20400281 	subcs	r0, r0, r1, lsl #5
    8ce0:	e1500201 	cmp	r0, r1, lsl #4
    8ce4:	e0a22002 	adc	r2, r2, r2
    8ce8:	20400201 	subcs	r0, r0, r1, lsl #4
    8cec:	e1500181 	cmp	r0, r1, lsl #3
    8cf0:	e0a22002 	adc	r2, r2, r2
    8cf4:	20400181 	subcs	r0, r0, r1, lsl #3
    8cf8:	e1500101 	cmp	r0, r1, lsl #2
    8cfc:	e0a22002 	adc	r2, r2, r2
    8d00:	20400101 	subcs	r0, r0, r1, lsl #2
    8d04:	e1500081 	cmp	r0, r1, lsl #1
    8d08:	e0a22002 	adc	r2, r2, r2
    8d0c:	20400081 	subcs	r0, r0, r1, lsl #1
    8d10:	e1500001 	cmp	r0, r1
    8d14:	e0a22002 	adc	r2, r2, r2
    8d18:	20400001 	subcs	r0, r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1115
    8d1c:	e1a00002 	mov	r0, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1116
    8d20:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1119
    8d24:	03a00001 	moveq	r0, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1120
    8d28:	13a00000 	movne	r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1121
    8d2c:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1123
    8d30:	e16f2f11 	clz	r2, r1
    8d34:	e262201f 	rsb	r2, r2, #31
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1125
    8d38:	e1a00230 	lsr	r0, r0, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1126
    8d3c:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1130
    8d40:	e3500000 	cmp	r0, #0
    8d44:	13e00000 	mvnne	r0, #0
    8d48:	ea000007 	b	8d6c <__aeabi_idiv0>

00008d4c <__aeabi_uidivmod>:
__aeabi_uidivmod():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1161
    8d4c:	e3510000 	cmp	r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1162
    8d50:	0afffffa 	beq	8d40 <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1163
    8d54:	e92d4003 	push	{r0, r1, lr}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1164
    8d58:	ebffff80 	bl	8b60 <__udivsi3>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1165
    8d5c:	e8bd4006 	pop	{r1, r2, lr}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1166
    8d60:	e0030092 	mul	r3, r2, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1167
    8d64:	e0411003 	sub	r1, r1, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1168
    8d68:	e12fff1e 	bx	lr

00008d6c <__aeabi_idiv0>:
__aeabi_ldiv0():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1466
    8d6c:	e12fff1e 	bx	lr

Disassembly of section .rodata:

00008d70 <_ZL13Lock_Unlocked>:
    8d70:	00000000 	andeq	r0, r0, r0

00008d74 <_ZL11Lock_Locked>:
    8d74:	00000001 	andeq	r0, r0, r1

00008d78 <_ZL21MaxFSDriverNameLength>:
    8d78:	00000010 	andeq	r0, r0, r0, lsl r0

00008d7c <_ZL17MaxFilenameLength>:
    8d7c:	00000010 	andeq	r0, r0, r0, lsl r0

00008d80 <_ZL13MaxPathLength>:
    8d80:	00000080 	andeq	r0, r0, r0, lsl #1

00008d84 <_ZL18NoFilesystemDriver>:
    8d84:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008d88 <_ZL9NotifyAll>:
    8d88:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008d8c <_ZL24Max_Process_Opened_Files>:
    8d8c:	00000010 	andeq	r0, r0, r0, lsl r0

00008d90 <_ZL10Indefinite>:
    8d90:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008d94 <_ZL18Deadline_Unchanged>:
    8d94:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00008d98 <_ZL14Invalid_Handle>:
    8d98:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008d9c <_ZL13Lock_Unlocked>:
    8d9c:	00000000 	andeq	r0, r0, r0

00008da0 <_ZL11Lock_Locked>:
    8da0:	00000001 	andeq	r0, r0, r1

00008da4 <_ZL21MaxFSDriverNameLength>:
    8da4:	00000010 	andeq	r0, r0, r0, lsl r0

00008da8 <_ZL17MaxFilenameLength>:
    8da8:	00000010 	andeq	r0, r0, r0, lsl r0

00008dac <_ZL13MaxPathLength>:
    8dac:	00000080 	andeq	r0, r0, r0, lsl #1

00008db0 <_ZL18NoFilesystemDriver>:
    8db0:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008db4 <_ZL9NotifyAll>:
    8db4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008db8 <_ZL24Max_Process_Opened_Files>:
    8db8:	00000010 	andeq	r0, r0, r0, lsl r0

00008dbc <_ZL10Indefinite>:
    8dbc:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008dc0 <_ZL18Deadline_Unchanged>:
    8dc0:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00008dc4 <_ZL14Invalid_Handle>:
    8dc4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008dc8 <_ZL16Pipe_File_Prefix>:
    8dc8:	3a535953 	bcc	14df31c <__bss_end+0x14d6524>
    8dcc:	65706970 	ldrbvs	r6, [r0, #-2416]!	; 0xfffff690
    8dd0:	0000002f 	andeq	r0, r0, pc, lsr #32

00008dd4 <_ZN12_GLOBAL__N_1L11CharConvArrE>:
    8dd4:	33323130 	teqcc	r2, #48, 2
    8dd8:	37363534 			; <UNDEFINED> instruction: 0x37363534
    8ddc:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    8de0:	46454443 	strbmi	r4, [r5], -r3, asr #8
	...

Disassembly of section .bss:

00008de8 <__bss_start>:
	...

Disassembly of section .ARM.attributes:

00000000 <.ARM.attributes>:
   0:	00002e41 	andeq	r2, r0, r1, asr #28
   4:	61656100 	cmnvs	r5, r0, lsl #2
   8:	01006962 	tsteq	r0, r2, ror #18
   c:	00000024 	andeq	r0, r0, r4, lsr #32
  10:	4b5a3605 	blmi	168d82c <__bss_end+0x1684a34>
  14:	08070600 	stmdaeq	r7, {r9, sl}
  18:	0a010901 	beq	42424 <__bss_end+0x3962c>
  1c:	14041202 	strne	r1, [r4], #-514	; 0xfffffdfe
  20:	17011501 	strne	r1, [r1, -r1, lsl #10]
  24:	1a011803 	bne	46038 <__bss_end+0x3d240>
  28:	22011c01 	andcs	r1, r1, #256	; 0x100
  2c:	Address 0x000000000000002c is out of bounds.


Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347 	bcc	10d0d24 <__bss_end+0x10c7f2c>
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
   0:	00000072 	andeq	r0, r0, r2, ror r0
   4:	005c0003 	subseq	r0, ip, r3
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
  34:	5a2f7374 	bpl	bdce0c <__bss_end+0xbd4014>
  38:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; fffffeac <__bss_end+0xffff70b4>
  3c:	2f657461 	svccs	0x00657461
  40:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
  44:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
  48:	2d38312f 	ldfcss	f3, [r8, #-188]!	; 0xffffff44
  4c:	2f666465 	svccs	0x00666465
  50:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
  54:	63617073 	cmnvs	r1, #115	; 0x73
  58:	63000065 	movwvs	r0, #101	; 0x65
  5c:	2e307472 	mrccs	4, 1, r7, cr0, cr2, {3}
  60:	00010073 	andeq	r0, r1, r3, ror r0
  64:	05000000 	streq	r0, [r0, #-0]
  68:	00800002 	addeq	r0, r0, r2
  6c:	01090300 	mrseq	r0, (UNDEF: 57)
  70:	00020231 	andeq	r0, r2, r1, lsr r2
  74:	00a10101 	adceq	r0, r1, r1, lsl #2
  78:	00030000 	andeq	r0, r3, r0
  7c:	0000005c 	andeq	r0, r0, ip, asr r0
  80:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
  84:	0101000d 	tsteq	r1, sp
  88:	00000101 	andeq	r0, r0, r1, lsl #2
  8c:	00000100 	andeq	r0, r0, r0, lsl #2
  90:	6e6d2f01 	cdpvs	15, 6, cr2, cr13, cr1, {0}
  94:	2f632f74 	svccs	0x00632f74
  98:	72657355 	rsbvc	r7, r5, #1409286145	; 0x54000001
  9c:	754b2f73 	strbvc	r2, [fp, #-3955]	; 0xfffff08d
  a0:	442f6162 	strtmi	r6, [pc], #-354	; a8 <shift+0xa8>
  a4:	6d75636f 	ldclvs	3, cr6, [r5, #-444]!	; 0xfffffe44
  a8:	73746e65 	cmnvc	r4, #1616	; 0x650
  ac:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
  b0:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
  b4:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
  b8:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
  bc:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
  c0:	64652d38 	strbtvs	r2, [r5], #-3384	; 0xfffff2c8
  c4:	73752f66 	cmnvc	r5, #408	; 0x198
  c8:	70737265 	rsbsvc	r7, r3, r5, ror #4
  cc:	00656361 	rsbeq	r6, r5, r1, ror #6
  d0:	74726300 	ldrbtvc	r6, [r2], #-768	; 0xfffffd00
  d4:	00632e30 	rsbeq	r2, r3, r0, lsr lr
  d8:	00000001 	andeq	r0, r0, r1
  dc:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
  e0:	00800802 	addeq	r0, r0, r2, lsl #16
  e4:	01090300 	mrseq	r0, (UNDEF: 57)
  e8:	05671305 	strbeq	r1, [r7, #-773]!	; 0xfffffcfb
  ec:	10054b05 	andne	r4, r5, r5, lsl #22
  f0:	02040200 	andeq	r0, r4, #0, 4
  f4:	0034052f 	eorseq	r0, r4, pc, lsr #10
  f8:	65020402 	strvs	r0, [r2, #-1026]	; 0xfffffbfe
  fc:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
 100:	05660104 	strbeq	r0, [r6, #-260]!	; 0xfffffefc
 104:	05d98401 	ldrbeq	r8, [r9, #1025]	; 0x401
 108:	05316805 	ldreq	r6, [r1, #-2053]!	; 0xfffff7fb
 10c:	05053312 	streq	r3, [r5, #-786]	; 0xfffffcee
 110:	054b3185 	strbeq	r3, [fp, #-389]	; 0xfffffe7b
 114:	06022f01 	streq	r2, [r2], -r1, lsl #30
 118:	f7010100 			; <UNDEFINED> instruction: 0xf7010100
 11c:	03000000 	movweq	r0, #0
 120:	00006e00 	andeq	r6, r0, r0, lsl #28
 124:	fb010200 	blx	4092e <__bss_end+0x37b36>
 128:	01000d0e 	tsteq	r0, lr, lsl #26
 12c:	00010101 	andeq	r0, r1, r1, lsl #2
 130:	00010000 	andeq	r0, r1, r0
 134:	6d2f0100 	stfvss	f0, [pc, #-0]	; 13c <shift+0x13c>
 138:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
 13c:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
 140:	4b2f7372 	blmi	bdcf10 <__bss_end+0xbd4118>
 144:	2f616275 	svccs	0x00616275
 148:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
 14c:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
 150:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
 154:	614d6f72 	hvcvs	55026	; 0xd6f2
 158:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffbec <__bss_end+0xffff6df4>
 15c:	706d6178 	rsbvc	r6, sp, r8, ror r1
 160:	2f73656c 	svccs	0x0073656c
 164:	652d3831 	strvs	r3, [sp, #-2097]!	; 0xfffff7cf
 168:	752f6664 	strvc	r6, [pc, #-1636]!	; fffffb0c <__bss_end+0xffff6d14>
 16c:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 170:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
 174:	78630000 	stmdavc	r3!, {}^	; <UNPREDICTABLE>
 178:	69626178 	stmdbvs	r2!, {r3, r4, r5, r6, r8, sp, lr}^
 17c:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
 180:	00000100 	andeq	r0, r0, r0, lsl #2
 184:	6975623c 	ldmdbvs	r5!, {r2, r3, r4, r5, r9, sp, lr}^
 188:	692d746c 	pushvs	{r2, r3, r5, r6, sl, ip, sp, lr}
 18c:	00003e6e 	andeq	r3, r0, lr, ror #28
 190:	05000000 	streq	r0, [r0, #-0]
 194:	02050002 	andeq	r0, r5, #2
 198:	000080a4 	andeq	r8, r0, r4, lsr #1
 19c:	05010a03 	streq	r0, [r1, #-2563]	; 0xfffff5fd
 1a0:	0a05830b 	beq	160dd4 <__bss_end+0x157fdc>
 1a4:	8302054a 	movwhi	r0, #9546	; 0x254a
 1a8:	830e0585 	movwhi	r0, #58757	; 0xe585
 1ac:	85670205 	strbhi	r0, [r7, #-517]!	; 0xfffffdfb
 1b0:	86010584 	strhi	r0, [r1], -r4, lsl #11
 1b4:	854c854c 	strbhi	r8, [ip, #-1356]	; 0xfffffab4
 1b8:	0205854c 	andeq	r8, r5, #76, 10	; 0x13000000
 1bc:	01040200 	mrseq	r0, R12_usr
 1c0:	0301054b 	movweq	r0, #5451	; 0x154b
 1c4:	0d052e12 	stceq	14, cr2, [r5, #-72]	; 0xffffffb8
 1c8:	0024056b 	eoreq	r0, r4, fp, ror #10
 1cc:	4a030402 	bmi	c11dc <__bss_end+0xb83e4>
 1d0:	02000405 	andeq	r0, r0, #83886080	; 0x5000000
 1d4:	05830204 	streq	r0, [r3, #516]	; 0x204
 1d8:	0402000b 	streq	r0, [r2], #-11
 1dc:	02054a02 	andeq	r4, r5, #8192	; 0x2000
 1e0:	02040200 	andeq	r0, r4, #0, 4
 1e4:	8509052d 	strhi	r0, [r9, #-1325]	; 0xfffffad3
 1e8:	a12f0105 			; <UNDEFINED> instruction: 0xa12f0105
 1ec:	056a0d05 	strbeq	r0, [sl, #-3333]!	; 0xfffff2fb
 1f0:	04020024 	streq	r0, [r2], #-36	; 0xffffffdc
 1f4:	04054a03 	streq	r4, [r5], #-2563	; 0xfffff5fd
 1f8:	02040200 	andeq	r0, r4, #0, 4
 1fc:	000b0583 	andeq	r0, fp, r3, lsl #11
 200:	4a020402 	bmi	81210 <__bss_end+0x78418>
 204:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
 208:	052d0204 	streq	r0, [sp, #-516]!	; 0xfffffdfc
 20c:	01058509 	tsteq	r5, r9, lsl #10
 210:	000a022f 	andeq	r0, sl, pc, lsr #4
 214:	01e00101 	mvneq	r0, r1, lsl #2
 218:	00030000 	andeq	r0, r3, r0
 21c:	000001c1 	andeq	r0, r0, r1, asr #3
 220:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
 224:	0101000d 	tsteq	r1, sp
 228:	00000101 	andeq	r0, r0, r1, lsl #2
 22c:	00000100 	andeq	r0, r0, r0, lsl #2
 230:	6e6d2f01 	cdpvs	15, 6, cr2, cr13, cr1, {0}
 234:	2f632f74 	svccs	0x00632f74
 238:	72657355 	rsbvc	r7, r5, #1409286145	; 0x54000001
 23c:	754b2f73 	strbvc	r2, [fp, #-3955]	; 0xfffff08d
 240:	442f6162 	strtmi	r6, [pc], #-354	; 248 <shift+0x248>
 244:	6d75636f 	ldclvs	3, cr6, [r5, #-444]!	; 0xfffffe44
 248:	73746e65 	cmnvc	r4, #1616	; 0x650
 24c:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
 250:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
 254:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 258:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
 25c:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
 260:	64652d38 	strbtvs	r2, [r5], #-3384	; 0xfffff2c8
 264:	73752f66 	cmnvc	r5, #408	; 0x198
 268:	70737265 	rsbsvc	r7, r3, r5, ror #4
 26c:	2f656361 	svccs	0x00656361
 270:	74696e69 	strbtvc	r6, [r9], #-3689	; 0xfffff197
 274:	7361745f 	cmnvc	r1, #1593835520	; 0x5f000000
 278:	6d2f006b 	stcvs	0, cr0, [pc, #-428]!	; d4 <shift+0xd4>
 27c:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
 280:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
 284:	4b2f7372 	blmi	bdd054 <__bss_end+0xbd425c>
 288:	2f616275 	svccs	0x00616275
 28c:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
 290:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
 294:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
 298:	614d6f72 	hvcvs	55026	; 0xd6f2
 29c:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffd30 <__bss_end+0xffff6f38>
 2a0:	706d6178 	rsbvc	r6, sp, r8, ror r1
 2a4:	2f73656c 	svccs	0x0073656c
 2a8:	652d3831 	strvs	r3, [sp, #-2097]!	; 0xfffff7cf
 2ac:	752f6664 	strvc	r6, [pc, #-1636]!	; fffffc50 <__bss_end+0xffff6e58>
 2b0:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 2b4:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
 2b8:	2f2e2e2f 	svccs	0x002e2e2f
 2bc:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 2c0:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 2c4:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 2c8:	702f6564 	eorvc	r6, pc, r4, ror #10
 2cc:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
 2d0:	2f007373 	svccs	0x00007373
 2d4:	2f746e6d 	svccs	0x00746e6d
 2d8:	73552f63 	cmpvc	r5, #396	; 0x18c
 2dc:	2f737265 	svccs	0x00737265
 2e0:	6162754b 	cmnvs	r2, fp, asr #10
 2e4:	636f442f 	cmnvs	pc, #788529152	; 0x2f000000
 2e8:	6e656d75 	mcrvs	13, 3, r6, cr5, cr5, {3}
 2ec:	5a2f7374 	bpl	bdd0c4 <__bss_end+0xbd42cc>
 2f0:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 164 <shift+0x164>
 2f4:	2f657461 	svccs	0x00657461
 2f8:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
 2fc:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
 300:	2d38312f 	ldfcss	f3, [r8, #-188]!	; 0xffffff44
 304:	2f666465 	svccs	0x00666465
 308:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
 30c:	63617073 	cmnvs	r1, #115	; 0x73
 310:	2e2e2f65 	cdpcs	15, 2, cr2, cr14, cr5, {3}
 314:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 318:	2f6c656e 	svccs	0x006c656e
 31c:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 320:	2f656475 	svccs	0x00656475
 324:	2f007366 	svccs	0x00007366
 328:	2f746e6d 	svccs	0x00746e6d
 32c:	73552f63 	cmpvc	r5, #396	; 0x18c
 330:	2f737265 	svccs	0x00737265
 334:	6162754b 	cmnvs	r2, fp, asr #10
 338:	636f442f 	cmnvs	pc, #788529152	; 0x2f000000
 33c:	6e656d75 	mcrvs	13, 3, r6, cr5, cr5, {3}
 340:	5a2f7374 	bpl	bdd118 <__bss_end+0xbd4320>
 344:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 1b8 <shift+0x1b8>
 348:	2f657461 	svccs	0x00657461
 34c:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
 350:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
 354:	2d38312f 	ldfcss	f3, [r8, #-188]!	; 0xffffff44
 358:	2f666465 	svccs	0x00666465
 35c:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
 360:	63617073 	cmnvs	r1, #115	; 0x73
 364:	2e2e2f65 	cdpcs	15, 2, cr2, cr14, cr5, {3}
 368:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 36c:	2f6c656e 	svccs	0x006c656e
 370:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 374:	2f656475 	svccs	0x00656475
 378:	72616f62 	rsbvc	r6, r1, #392	; 0x188
 37c:	70722f64 	rsbsvc	r2, r2, r4, ror #30
 380:	682f3069 	stmdavs	pc!, {r0, r3, r5, r6, ip, sp}	; <UNPREDICTABLE>
 384:	00006c61 	andeq	r6, r0, r1, ror #24
 388:	6e69616d 	powvsez	f6, f1, #5.0
 38c:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
 390:	00000100 	andeq	r0, r0, r0, lsl #2
 394:	6e697073 	mcrvs	0, 3, r7, cr9, cr3, {3}
 398:	6b636f6c 	blvs	18dc150 <__bss_end+0x18d3358>
 39c:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 3a0:	69660000 	stmdbvs	r6!, {}^	; <UNPREDICTABLE>
 3a4:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
 3a8:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
 3ac:	0300682e 	movweq	r6, #2094	; 0x82e
 3b0:	72700000 	rsbsvc	r0, r0, #0
 3b4:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
 3b8:	00682e73 	rsbeq	r2, r8, r3, ror lr
 3bc:	70000002 	andvc	r0, r0, r2
 3c0:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
 3c4:	6d5f7373 	ldclvs	3, cr7, [pc, #-460]	; 200 <shift+0x200>
 3c8:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
 3cc:	682e7265 	stmdavs	lr!, {r0, r2, r5, r6, r9, ip, sp, lr}
 3d0:	00000200 	andeq	r0, r0, r0, lsl #4
 3d4:	64746e69 	ldrbtvs	r6, [r4], #-3689	; 0xfffff197
 3d8:	682e6665 	stmdavs	lr!, {r0, r2, r5, r6, r9, sl, sp, lr}
 3dc:	00000400 	andeq	r0, r0, r0, lsl #8
 3e0:	00010500 	andeq	r0, r1, r0, lsl #10
 3e4:	822c0205 	eorhi	r0, ip, #1342177280	; 0x50000000
 3e8:	05170000 	ldreq	r0, [r7, #-0]
 3ec:	0205a313 	andeq	sl, r5, #1275068416	; 0x4c000000
 3f0:	01040200 	mrseq	r0, R12_usr
 3f4:	0002024e 	andeq	r0, r2, lr, asr #4
 3f8:	02880101 	addeq	r0, r8, #1073741824	; 0x40000000
 3fc:	00030000 	andeq	r0, r3, r0
 400:	0000019d 	muleq	r0, sp, r1
 404:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
 408:	0101000d 	tsteq	r1, sp
 40c:	00000101 	andeq	r0, r0, r1, lsl #2
 410:	00000100 	andeq	r0, r0, r0, lsl #2
 414:	6e6d2f01 	cdpvs	15, 6, cr2, cr13, cr1, {0}
 418:	2f632f74 	svccs	0x00632f74
 41c:	72657355 	rsbvc	r7, r5, #1409286145	; 0x54000001
 420:	754b2f73 	strbvc	r2, [fp, #-3955]	; 0xfffff08d
 424:	442f6162 	strtmi	r6, [pc], #-354	; 42c <shift+0x42c>
 428:	6d75636f 	ldclvs	3, cr6, [r5, #-444]!	; 0xfffffe44
 42c:	73746e65 	cmnvc	r4, #1616	; 0x650
 430:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
 434:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
 438:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 43c:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
 440:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
 444:	64652d38 	strbtvs	r2, [r5], #-3384	; 0xfffff2c8
 448:	74732f66 	ldrbtvc	r2, [r3], #-3942	; 0xfffff09a
 44c:	62696c64 	rsbvs	r6, r9, #100, 24	; 0x6400
 450:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
 454:	6e6d2f00 	cdpvs	15, 6, cr2, cr13, cr0, {0}
 458:	2f632f74 	svccs	0x00632f74
 45c:	72657355 	rsbvc	r7, r5, #1409286145	; 0x54000001
 460:	754b2f73 	strbvc	r2, [fp, #-3955]	; 0xfffff08d
 464:	442f6162 	strtmi	r6, [pc], #-354	; 46c <shift+0x46c>
 468:	6d75636f 	ldclvs	3, cr6, [r5, #-444]!	; 0xfffffe44
 46c:	73746e65 	cmnvc	r4, #1616	; 0x650
 470:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
 474:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
 478:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 47c:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
 480:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
 484:	64652d38 	strbtvs	r2, [r5], #-3384	; 0xfffff2c8
 488:	656b2f66 	strbvs	r2, [fp, #-3942]!	; 0xfffff09a
 48c:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
 490:	636e692f 	cmnvs	lr, #770048	; 0xbc000
 494:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
 498:	6f72702f 	svcvs	0x0072702f
 49c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
 4a0:	6e6d2f00 	cdpvs	15, 6, cr2, cr13, cr0, {0}
 4a4:	2f632f74 	svccs	0x00632f74
 4a8:	72657355 	rsbvc	r7, r5, #1409286145	; 0x54000001
 4ac:	754b2f73 	strbvc	r2, [fp, #-3955]	; 0xfffff08d
 4b0:	442f6162 	strtmi	r6, [pc], #-354	; 4b8 <shift+0x4b8>
 4b4:	6d75636f 	ldclvs	3, cr6, [r5, #-444]!	; 0xfffffe44
 4b8:	73746e65 	cmnvc	r4, #1616	; 0x650
 4bc:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
 4c0:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
 4c4:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 4c8:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
 4cc:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
 4d0:	64652d38 	strbtvs	r2, [r5], #-3384	; 0xfffff2c8
 4d4:	656b2f66 	strbvs	r2, [fp, #-3942]!	; 0xfffff09a
 4d8:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
 4dc:	636e692f 	cmnvs	lr, #770048	; 0xbc000
 4e0:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
 4e4:	0073662f 	rsbseq	r6, r3, pc, lsr #12
 4e8:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
 4ec:	552f632f 	strpl	r6, [pc, #-815]!	; 1c5 <shift+0x1c5>
 4f0:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 4f4:	62754b2f 	rsbsvs	r4, r5, #48128	; 0xbc00
 4f8:	6f442f61 	svcvs	0x00442f61
 4fc:	656d7563 	strbvs	r7, [sp, #-1379]!	; 0xfffffa9d
 500:	2f73746e 	svccs	0x0073746e
 504:	6f72655a 	svcvs	0x0072655a
 508:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
 50c:	6178652f 	cmnvs	r8, pc, lsr #10
 510:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
 514:	38312f73 	ldmdacc	r1!, {r0, r1, r4, r5, r6, r8, r9, sl, fp, sp}
 518:	6664652d 	strbtvs	r6, [r4], -sp, lsr #10
 51c:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 520:	2f6c656e 	svccs	0x006c656e
 524:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 528:	2f656475 	svccs	0x00656475
 52c:	72616f62 	rsbvc	r6, r1, #392	; 0x188
 530:	70722f64 	rsbsvc	r2, r2, r4, ror #30
 534:	682f3069 	stmdavs	pc!, {r0, r3, r5, r6, ip, sp}	; <UNPREDICTABLE>
 538:	00006c61 	andeq	r6, r0, r1, ror #24
 53c:	66647473 			; <UNDEFINED> instruction: 0x66647473
 540:	2e656c69 	cdpcs	12, 6, cr6, cr5, cr9, {3}
 544:	00707063 	rsbseq	r7, r0, r3, rrx
 548:	73000001 	movwvc	r0, #1
 54c:	682e6977 	stmdavs	lr!, {r0, r1, r2, r4, r5, r6, r8, fp, sp, lr}
 550:	00000200 	andeq	r0, r0, r0, lsl #4
 554:	6e697073 	mcrvs	0, 3, r7, cr9, cr3, {3}
 558:	6b636f6c 	blvs	18dc310 <__bss_end+0x18d3518>
 55c:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 560:	69660000 	stmdbvs	r6!, {}^	; <UNPREDICTABLE>
 564:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
 568:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
 56c:	0300682e 	movweq	r6, #2094	; 0x82e
 570:	72700000 	rsbsvc	r0, r0, #0
 574:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
 578:	00682e73 	rsbeq	r2, r8, r3, ror lr
 57c:	70000002 	andvc	r0, r0, r2
 580:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
 584:	6d5f7373 	ldclvs	3, cr7, [pc, #-460]	; 3c0 <shift+0x3c0>
 588:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
 58c:	682e7265 	stmdavs	lr!, {r0, r2, r5, r6, r9, ip, sp, lr}
 590:	00000200 	andeq	r0, r0, r0, lsl #4
 594:	64746e69 	ldrbtvs	r6, [r4], #-3689	; 0xfffff197
 598:	682e6665 	stmdavs	lr!, {r0, r2, r5, r6, r9, sl, sp, lr}
 59c:	00000400 	andeq	r0, r0, r0, lsl #8
 5a0:	00010500 	andeq	r0, r1, r0, lsl #10
 5a4:	824c0205 	subhi	r0, ip, #1342177280	; 0x50000000
 5a8:	05160000 	ldreq	r0, [r6, #-0]
 5ac:	052f6905 	streq	r6, [pc, #-2309]!	; fffffcaf <__bss_end+0xffff6eb7>
 5b0:	01054c0c 	tsteq	r5, ip, lsl #24
 5b4:	0505852f 	streq	r8, [r5, #-1327]	; 0xfffffad1
 5b8:	01054b83 	smlabbeq	r5, r3, fp, r4
 5bc:	0505852f 	streq	r8, [r5, #-1327]	; 0xfffffad1
 5c0:	2f01054b 	svccs	0x0001054b
 5c4:	a1050585 	smlabbge	r5, r5, r5, r0
 5c8:	052f4b4b 	streq	r4, [pc, #-2891]!	; fffffa85 <__bss_end+0xffff6c8d>
 5cc:	01054c0c 	tsteq	r5, ip, lsl #24
 5d0:	0505852f 	streq	r8, [r5, #-1327]	; 0xfffffad1
 5d4:	4b4b4bbd 	blmi	12d34d0 <__bss_end+0x12ca6d8>
 5d8:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
 5dc:	852f0105 	strhi	r0, [pc, #-261]!	; 4df <shift+0x4df>
 5e0:	4bbd0505 	blmi	fef419fc <__bss_end+0xfef38c04>
 5e4:	052f4b4b 	streq	r4, [pc, #-2891]!	; fffffaa1 <__bss_end+0xffff6ca9>
 5e8:	01054c0c 	tsteq	r5, ip, lsl #24
 5ec:	0505852f 	streq	r8, [r5, #-1327]	; 0xfffffad1
 5f0:	01054b83 	smlabbeq	r5, r3, fp, r4
 5f4:	0505852f 	streq	r8, [r5, #-1327]	; 0xfffffad1
 5f8:	4b4b4bbd 	blmi	12d34f4 <__bss_end+0x12ca6fc>
 5fc:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
 600:	852f0105 	strhi	r0, [pc, #-261]!	; 503 <shift+0x503>
 604:	4ba10505 	blmi	fe841a20 <__bss_end+0xfe838c28>
 608:	0c052f4b 	stceq	15, cr2, [r5], {75}	; 0x4b
 60c:	2f01054c 	svccs	0x0001054c
 610:	bd050585 	cfstr32lt	mvfx0, [r5, #-532]	; 0xfffffdec
 614:	2f4b4b4b 	svccs	0x004b4b4b
 618:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 61c:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 620:	4b4ba105 	blmi	12e8a3c <__bss_end+0x12dfc44>
 624:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
 628:	859f0105 	ldrhi	r0, [pc, #261]	; 735 <shift+0x735>
 62c:	05672005 	strbeq	r2, [r7, #-5]!
 630:	4b4b4d05 	blmi	12d3a4c <__bss_end+0x12cac54>
 634:	05300c05 	ldreq	r0, [r0, #-3077]!	; 0xfffff3fb
 638:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 63c:	05056720 	streq	r6, [r5, #-1824]	; 0xfffff8e0
 640:	054b4b4d 	strbeq	r4, [fp, #-2893]	; 0xfffff4b3
 644:	0105300c 	tsteq	r5, ip
 648:	2005852f 	andcs	r8, r5, pc, lsr #10
 64c:	4c050583 	cfstr32mi	mvfx0, [r5], {131}	; 0x83
 650:	01054b4b 	tsteq	r5, fp, asr #22
 654:	2005852f 	andcs	r8, r5, pc, lsr #10
 658:	4d050567 	cfstr32mi	mvfx0, [r5, #-412]	; 0xfffffe64
 65c:	0c054b4b 			; <UNDEFINED> instruction: 0x0c054b4b
 660:	2f010530 	svccs	0x00010530
 664:	a00c0587 	andge	r0, ip, r7, lsl #11
 668:	bc31059f 	cfldr32lt	mvfx0, [r1], #-636	; 0xfffffd84
 66c:	05662905 	strbeq	r2, [r6, #-2309]!	; 0xfffff6fb
 670:	0f052e36 	svceq	0x00052e36
 674:	66130530 			; <UNDEFINED> instruction: 0x66130530
 678:	05840905 	streq	r0, [r4, #2309]	; 0x905
 67c:	0105d810 	tsteq	r5, r0, lsl r8
 680:	0008029f 	muleq	r8, pc, r2	; <UNPREDICTABLE>
 684:	028b0101 	addeq	r0, fp, #1073741824	; 0x40000000
 688:	00030000 	andeq	r0, r3, r0
 68c:	00000064 	andeq	r0, r0, r4, rrx
 690:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
 694:	0101000d 	tsteq	r1, sp
 698:	00000101 	andeq	r0, r0, r1, lsl #2
 69c:	00000100 	andeq	r0, r0, r0, lsl #2
 6a0:	6e6d2f01 	cdpvs	15, 6, cr2, cr13, cr1, {0}
 6a4:	2f632f74 	svccs	0x00632f74
 6a8:	72657355 	rsbvc	r7, r5, #1409286145	; 0x54000001
 6ac:	754b2f73 	strbvc	r2, [fp, #-3955]	; 0xfffff08d
 6b0:	442f6162 	strtmi	r6, [pc], #-354	; 6b8 <shift+0x6b8>
 6b4:	6d75636f 	ldclvs	3, cr6, [r5, #-444]!	; 0xfffffe44
 6b8:	73746e65 	cmnvc	r4, #1616	; 0x650
 6bc:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
 6c0:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
 6c4:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 6c8:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
 6cc:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
 6d0:	64652d38 	strbtvs	r2, [r5], #-3384	; 0xfffff2c8
 6d4:	74732f66 	ldrbtvc	r2, [r3], #-3942	; 0xfffff09a
 6d8:	62696c64 	rsbvs	r6, r9, #100, 24	; 0x6400
 6dc:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
 6e0:	74730000 	ldrbtvc	r0, [r3], #-0
 6e4:	72747364 	rsbsvc	r7, r4, #100, 6	; 0x90000001
 6e8:	2e676e69 	cdpcs	14, 6, cr6, cr7, cr9, {3}
 6ec:	00707063 	rsbseq	r7, r0, r3, rrx
 6f0:	00000001 	andeq	r0, r0, r1
 6f4:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
 6f8:	0086a802 	addeq	sl, r6, r2, lsl #16
 6fc:	06051a00 	streq	r1, [r5], -r0, lsl #20
 700:	4c0f05bb 	cfstr32mi	mvfx0, [pc], {187}	; 0xbb
 704:	05682105 	strbeq	r2, [r8, #-261]!	; 0xfffffefb
 708:	0b05ba0a 	bleq	16ef38 <__bss_end+0x166140>
 70c:	4a27052e 	bmi	9c1bcc <__bss_end+0x9b8dd4>
 710:	054a0d05 	strbeq	r0, [sl, #-3333]	; 0xfffff2fb
 714:	04052f09 	streq	r2, [r5], #-3849	; 0xfffff0f7
 718:	6202059f 	andvs	r0, r2, #666894336	; 0x27c00000
 71c:	05350505 	ldreq	r0, [r5, #-1285]!	; 0xfffffafb
 720:	11056810 	tstne	r5, r0, lsl r8
 724:	4a22052e 	bmi	881be4 <__bss_end+0x878dec>
 728:	052e1305 	streq	r1, [lr, #-773]!	; 0xfffffcfb
 72c:	09052f0a 	stmdbeq	r5, {r1, r3, r8, r9, sl, fp, sp}
 730:	2e0a0569 	cfsh32cs	mvfx0, mvfx10, #57
 734:	054a0c05 	strbeq	r0, [sl, #-3077]	; 0xfffff3fb
 738:	0b054b03 	bleq	15334c <__bss_end+0x14a554>
 73c:	00180568 	andseq	r0, r8, r8, ror #10
 740:	4a030402 	bmi	c1750 <__bss_end+0xb8958>
 744:	02001405 	andeq	r1, r0, #83886080	; 0x5000000
 748:	059e0304 	ldreq	r0, [lr, #772]	; 0x304
 74c:	04020015 	streq	r0, [r2], #-21	; 0xffffffeb
 750:	18056802 	stmdane	r5, {r1, fp, sp, lr}
 754:	02040200 	andeq	r0, r4, #0, 4
 758:	00080582 	andeq	r0, r8, r2, lsl #11
 75c:	4a020402 	bmi	8176c <__bss_end+0x78974>
 760:	02001a05 	andeq	r1, r0, #20480	; 0x5000
 764:	054b0204 	strbeq	r0, [fp, #-516]	; 0xfffffdfc
 768:	0402001b 	streq	r0, [r2], #-27	; 0xffffffe5
 76c:	0c052e02 	stceq	14, cr2, [r5], {2}
 770:	02040200 	andeq	r0, r4, #0, 4
 774:	000f054a 	andeq	r0, pc, sl, asr #10
 778:	82020402 	andhi	r0, r2, #33554432	; 0x2000000
 77c:	02001b05 	andeq	r1, r0, #5120	; 0x1400
 780:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 784:	04020011 	streq	r0, [r2], #-17	; 0xffffffef
 788:	0a052e02 	beq	14bf98 <__bss_end+0x1431a0>
 78c:	02040200 	andeq	r0, r4, #0, 4
 790:	000b052f 	andeq	r0, fp, pc, lsr #10
 794:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
 798:	02000d05 	andeq	r0, r0, #320	; 0x140
 79c:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 7a0:	04020002 	streq	r0, [r2], #-2
 7a4:	01054602 	tsteq	r5, r2, lsl #12
 7a8:	06058588 	streq	r8, [r5], -r8, lsl #11
 7ac:	4c090583 	cfstr32mi	mvfx0, [r9], {131}	; 0x83
 7b0:	054a1005 	strbeq	r1, [sl, #-5]
 7b4:	07054c0a 	streq	r4, [r5, -sl, lsl #24]
 7b8:	4a0305bb 	bmi	c1eac <__bss_end+0xb90b4>
 7bc:	02001705 	andeq	r1, r0, #1310720	; 0x140000
 7c0:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
 7c4:	04020014 	streq	r0, [r2], #-20	; 0xffffffec
 7c8:	0d054a01 	vstreq	s8, [r5, #-4]
 7cc:	4a14054d 	bmi	501d08 <__bss_end+0x4f8f10>
 7d0:	052e0a05 	streq	r0, [lr, #-2565]!	; 0xfffff5fb
 7d4:	02056808 	andeq	r6, r5, #8, 16	; 0x80000
 7d8:	05667803 	strbeq	r7, [r6, #-2051]!	; 0xfffff7fd
 7dc:	2e0b0309 	cdpcs	3, 0, cr0, cr11, cr9, {0}
 7e0:	852f0105 	strhi	r0, [pc, #-261]!	; 6e3 <shift+0x6e3>
 7e4:	05bd0905 	ldreq	r0, [sp, #2309]!	; 0x905
 7e8:	04020016 	streq	r0, [r2], #-22	; 0xffffffea
 7ec:	1d054a04 	vstrne	s8, [r5, #-16]
 7f0:	02040200 	andeq	r0, r4, #0, 4
 7f4:	001e0582 	andseq	r0, lr, r2, lsl #11
 7f8:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
 7fc:	02001605 	andeq	r1, r0, #5242880	; 0x500000
 800:	05660204 	strbeq	r0, [r6, #-516]!	; 0xfffffdfc
 804:	04020011 	streq	r0, [r2], #-17	; 0xffffffef
 808:	12054b03 	andne	r4, r5, #3072	; 0xc00
 80c:	03040200 	movweq	r0, #16896	; 0x4200
 810:	0008052e 	andeq	r0, r8, lr, lsr #10
 814:	4a030402 	bmi	c1824 <__bss_end+0xb8a2c>
 818:	02000905 	andeq	r0, r0, #81920	; 0x14000
 81c:	052e0304 	streq	r0, [lr, #-772]!	; 0xfffffcfc
 820:	04020012 	streq	r0, [r2], #-18	; 0xffffffee
 824:	0b054a03 	bleq	153038 <__bss_end+0x14a240>
 828:	03040200 	movweq	r0, #16896	; 0x4200
 82c:	0002052e 	andeq	r0, r2, lr, lsr #10
 830:	2d030402 	cfstrscs	mvf0, [r3, #-8]
 834:	02000b05 	andeq	r0, r0, #5120	; 0x1400
 838:	05840204 	streq	r0, [r4, #516]	; 0x204
 83c:	04020008 	streq	r0, [r2], #-8
 840:	09058301 	stmdbeq	r5, {r0, r8, r9, pc}
 844:	01040200 	mrseq	r0, R12_usr
 848:	000b052e 	andeq	r0, fp, lr, lsr #10
 84c:	4a010402 	bmi	4185c <__bss_end+0x38a64>
 850:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
 854:	05490104 	strbeq	r0, [r9, #-260]	; 0xfffffefc
 858:	0105850b 	tsteq	r5, fp, lsl #10
 85c:	0e05852f 	cfsh32eq	mvfx8, mvfx5, #31
 860:	661105bc 			; <UNDEFINED> instruction: 0x661105bc
 864:	05bc2005 	ldreq	r2, [ip, #5]!
 868:	1f05660b 	svcne	0x0005660b
 86c:	660a054b 	strvs	r0, [sl], -fp, asr #10
 870:	054b0805 	strbeq	r0, [fp, #-2053]	; 0xfffff7fb
 874:	16058311 			; <UNDEFINED> instruction: 0x16058311
 878:	6708052e 	strvs	r0, [r8, -lr, lsr #10]
 87c:	05671105 	strbeq	r1, [r7, #-261]!	; 0xfffffefb
 880:	01054d0b 	tsteq	r5, fp, lsl #26
 884:	0605852f 	streq	r8, [r5], -pc, lsr #10
 888:	4c0b0583 	cfstr32mi	mvfx0, [fp], {131}	; 0x83
 88c:	052e0c05 	streq	r0, [lr, #-3077]!	; 0xfffff3fb
 890:	0405660e 	streq	r6, [r5], #-1550	; 0xfffff9f2
 894:	6502054b 	strvs	r0, [r2, #-1355]	; 0xfffffab5
 898:	05310905 	ldreq	r0, [r1, #-2309]!	; 0xfffff6fb
 89c:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 8a0:	0b059f08 	bleq	1684c8 <__bss_end+0x15f6d0>
 8a4:	0014054c 	andseq	r0, r4, ip, asr #10
 8a8:	4a030402 	bmi	c18b8 <__bss_end+0xb8ac0>
 8ac:	02000705 	andeq	r0, r0, #1310720	; 0x140000
 8b0:	05830204 	streq	r0, [r3, #516]	; 0x204
 8b4:	04020008 	streq	r0, [r2], #-8
 8b8:	0a052e02 	beq	14c0c8 <__bss_end+0x1432d0>
 8bc:	02040200 	andeq	r0, r4, #0, 4
 8c0:	0002054a 	andeq	r0, r2, sl, asr #10
 8c4:	49020402 	stmdbmi	r2, {r1, sl}
 8c8:	85840105 	strhi	r0, [r4, #261]	; 0x105
 8cc:	05bb0e05 	ldreq	r0, [fp, #3589]!	; 0xe05
 8d0:	0b054b08 	bleq	1534f8 <__bss_end+0x14a700>
 8d4:	0014054c 	andseq	r0, r4, ip, asr #10
 8d8:	4a030402 	bmi	c18e8 <__bss_end+0xb8af0>
 8dc:	02001605 	andeq	r1, r0, #5242880	; 0x500000
 8e0:	05830204 	streq	r0, [r3, #516]	; 0x204
 8e4:	04020017 	streq	r0, [r2], #-23	; 0xffffffe9
 8e8:	0a052e02 	beq	14c0f8 <__bss_end+0x143300>
 8ec:	02040200 	andeq	r0, r4, #0, 4
 8f0:	000b054a 	andeq	r0, fp, sl, asr #10
 8f4:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
 8f8:	02001705 	andeq	r1, r0, #1310720	; 0x140000
 8fc:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 900:	0402000d 	streq	r0, [r2], #-13
 904:	02052e02 	andeq	r2, r5, #2, 28
 908:	02040200 	andeq	r0, r4, #0, 4
 90c:	8401052d 	strhi	r0, [r1], #-1325	; 0xfffffad3
 910:	01000802 	tsteq	r0, r2, lsl #16
 914:	00007901 	andeq	r7, r0, r1, lsl #18
 918:	46000300 	strmi	r0, [r0], -r0, lsl #6
 91c:	02000000 	andeq	r0, r0, #0
 920:	0d0efb01 	vstreq	d15, [lr, #-4]
 924:	01010100 	mrseq	r0, (UNDEF: 17)
 928:	00000001 	andeq	r0, r0, r1
 92c:	01000001 	tsteq	r0, r1
 930:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 934:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 938:	2f2e2e2f 	svccs	0x002e2e2f
 93c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 940:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
 944:	63636762 	cmnvs	r3, #25690112	; 0x1880000
 948:	6e6f632f 	cdpvs	3, 6, cr6, cr15, cr15, {1}
 94c:	2f676966 	svccs	0x00676966
 950:	006d7261 	rsbeq	r7, sp, r1, ror #4
 954:	62696c00 	rsbvs	r6, r9, #0, 24
 958:	6e756631 	mrcvs	6, 3, r6, cr5, cr1, {1}
 95c:	532e7363 			; <UNDEFINED> instruction: 0x532e7363
 960:	00000100 	andeq	r0, r0, r0, lsl #2
 964:	02050000 	andeq	r0, r5, #0
 968:	00008b60 	andeq	r8, r0, r0, ror #22
 96c:	0108cf03 	tsteq	r8, r3, lsl #30
 970:	2f2f2f30 	svccs	0x002f2f30
 974:	02302f2f 	eorseq	r2, r0, #47, 30	; 0xbc
 978:	2f1401d0 	svccs	0x001401d0
 97c:	302f2f31 	eorcc	r2, pc, r1, lsr pc	; <UNPREDICTABLE>
 980:	03322f4c 	teqeq	r2, #76, 30	; 0x130
 984:	2f2f661f 	svccs	0x002f661f
 988:	2f2f2f2f 	svccs	0x002f2f2f
 98c:	0002022f 	andeq	r0, r2, pc, lsr #4
 990:	005c0101 	subseq	r0, ip, r1, lsl #2
 994:	00030000 	andeq	r0, r3, r0
 998:	00000046 	andeq	r0, r0, r6, asr #32
 99c:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
 9a0:	0101000d 	tsteq	r1, sp
 9a4:	00000101 	andeq	r0, r0, r1, lsl #2
 9a8:	00000100 	andeq	r0, r0, r0, lsl #2
 9ac:	2f2e2e01 	svccs	0x002e2e01
 9b0:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 9b4:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 9b8:	2f2e2e2f 	svccs	0x002e2e2f
 9bc:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 90c <shift+0x90c>
 9c0:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
 9c4:	6f632f63 	svcvs	0x00632f63
 9c8:	6769666e 	strbvs	r6, [r9, -lr, ror #12]!
 9cc:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
 9d0:	696c0000 	stmdbvs	ip!, {}^	; <UNPREDICTABLE>
 9d4:	75663162 	strbvc	r3, [r6, #-354]!	; 0xfffffe9e
 9d8:	2e73636e 	cdpcs	3, 7, cr6, cr3, cr14, {3}
 9dc:	00010053 	andeq	r0, r1, r3, asr r0
 9e0:	05000000 	streq	r0, [r0, #-0]
 9e4:	008d6c02 	addeq	r6, sp, r2, lsl #24
 9e8:	0bb90300 	bleq	fee415f0 <__bss_end+0xfee387f8>
 9ec:	00020201 	andeq	r0, r2, r1, lsl #4
 9f0:	00a40101 	adceq	r0, r4, r1, lsl #2
 9f4:	00030000 	andeq	r0, r3, r0
 9f8:	0000009e 	muleq	r0, lr, r0
 9fc:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
 a00:	0101000d 	tsteq	r1, sp
 a04:	00000101 	andeq	r0, r0, r1, lsl #2
 a08:	00000100 	andeq	r0, r0, r0, lsl #2
 a0c:	2f2e2e01 	svccs	0x002e2e01
 a10:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 a14:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 a18:	2f2e2e2f 	svccs	0x002e2e2f
 a1c:	63672f2e 	cmnvs	r7, #46, 30	; 0xb8
 a20:	2e2e0063 	cdpcs	0, 2, cr0, cr14, cr3, {3}
 a24:	2f2e2e2f 	svccs	0x002e2e2f
 a28:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 a2c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 a30:	2f2e2e2f 	svccs	0x002e2e2f
 a34:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
 a38:	2e2f6363 	cdpcs	3, 2, cr6, cr15, cr3, {3}
 a3c:	63672f2e 	cmnvs	r7, #46, 30	; 0xb8
 a40:	6f632f63 	svcvs	0x00632f63
 a44:	6769666e 	strbvs	r6, [r9, -lr, ror #12]!
 a48:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
 a4c:	2f2e2e00 	svccs	0x002e2e00
 a50:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 a54:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 a58:	2f2e2e2f 	svccs	0x002e2e2f
 a5c:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 9ac <shift+0x9ac>
 a60:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
 a64:	61000063 	tstvs	r0, r3, rrx
 a68:	692d6d72 	pushvs	{r1, r4, r5, r6, r8, sl, fp, sp, lr}
 a6c:	682e6173 	stmdavs	lr!, {r0, r1, r4, r5, r6, r8, sp, lr}
 a70:	00000100 	andeq	r0, r0, r0, lsl #2
 a74:	2e6d7261 	cdpcs	2, 6, cr7, cr13, cr1, {3}
 a78:	00020068 	andeq	r0, r2, r8, rrx
 a7c:	6c626700 	stclvs	7, cr6, [r2], #-0
 a80:	6f74632d 	svcvs	0x0074632d
 a84:	682e7372 	stmdavs	lr!, {r1, r4, r5, r6, r8, r9, ip, sp, lr}
 a88:	00000300 	andeq	r0, r0, r0, lsl #6
 a8c:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
 a90:	2e326363 	cdpcs	3, 3, cr6, cr2, cr3, {3}
 a94:	00030063 	andeq	r0, r3, r3, rrx
	...

Disassembly of section .debug_info:

00000000 <.debug_info>:
       0:	00000022 	andeq	r0, r0, r2, lsr #32
       4:	00000002 	andeq	r0, r0, r2
       8:	01040000 	mrseq	r0, (UNDEF: 4)
       c:	00000000 	andeq	r0, r0, r0
      10:	00008000 	andeq	r8, r0, r0
      14:	00008008 	andeq	r8, r0, r8
      18:	00000000 	andeq	r0, r0, r0
      1c:	00000046 	andeq	r0, r0, r6, asr #32
      20:	0000008b 	andeq	r0, r0, fp, lsl #1
      24:	009a8001 	addseq	r8, sl, r1
      28:	00040000 	andeq	r0, r4, r0
      2c:	00000014 	andeq	r0, r0, r4, lsl r0
      30:	00970104 	addseq	r0, r7, r4, lsl #2
      34:	3a0c0000 	bcc	30003c <__bss_end+0x2f7244>
      38:	46000001 	strmi	r0, [r0], -r1
      3c:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
      40:	9c000080 	stcls	0, cr0, [r0], {128}	; 0x80
      44:	76000000 	strvc	r0, [r0], -r0
      48:	02000000 	andeq	r0, r0, #0
      4c:	000001a1 	andeq	r0, r0, r1, lsr #3
      50:	31150601 	tstcc	r5, r1, lsl #12
      54:	03000000 	movweq	r0, #0
      58:	13f50704 	mvnsne	r0, #4, 14	; 0x100000
      5c:	29020000 	stmdbcs	r2, {}	; <UNPREDICTABLE>
      60:	01000001 	tsteq	r0, r1
      64:	00311507 	eorseq	r1, r1, r7, lsl #10
      68:	96040000 	strls	r0, [r4], -r0
      6c:	01000001 	tsteq	r0, r1
      70:	80640610 	rsbhi	r0, r4, r0, lsl r6
      74:	00400000 	subeq	r0, r0, r0
      78:	9c010000 	stcls	0, cr0, [r1], {-0}
      7c:	0000006a 	andeq	r0, r0, sl, rrx
      80:	00013305 	andeq	r3, r1, r5, lsl #6
      84:	091b0100 	ldmdbeq	fp, {r8}
      88:	0000006a 	andeq	r0, r0, sl, rrx
      8c:	00749102 	rsbseq	r9, r4, r2, lsl #2
      90:	69050406 	stmdbvs	r5, {r1, r2, sl}
      94:	0700746e 	streq	r7, [r0, -lr, ror #8]
      98:	00000180 	andeq	r0, r0, r0, lsl #3
      9c:	08060901 	stmdaeq	r6, {r0, r8, fp}
      a0:	5c000080 	stcpl	0, cr0, [r0], {128}	; 0x80
      a4:	01000000 	mrseq	r0, (UNDEF: 0)
      a8:	0000979c 	muleq	r0, ip, r7
      ac:	01900500 	orrseq	r0, r0, r0, lsl #10
      b0:	0b010000 	bleq	400b8 <__bss_end+0x372c0>
      b4:	00009713 	andeq	r9, r0, r3, lsl r7
      b8:	74910200 	ldrvc	r0, [r1], #512	; 0x200
      bc:	31040800 	tstcc	r4, r0, lsl #16
      c0:	00000000 	andeq	r0, r0, r0
      c4:	00000202 	andeq	r0, r0, r2, lsl #4
      c8:	009f0004 	addseq	r0, pc, r4
      cc:	01040000 	mrseq	r0, (UNDEF: 4)
      d0:	000002d4 	ldrdeq	r0, [r0], -r4
      d4:	00021204 	andeq	r1, r2, r4, lsl #4
      d8:	00004600 	andeq	r4, r0, r0, lsl #12
      dc:	0080a400 	addeq	sl, r0, r0, lsl #8
      e0:	00018800 	andeq	r8, r1, r0, lsl #16
      e4:	00011b00 	andeq	r1, r1, r0, lsl #22
      e8:	03900200 	orrseq	r0, r0, #0, 4
      ec:	2f010000 	svccs	0x00010000
      f0:	00003107 	andeq	r3, r0, r7, lsl #2
      f4:	37040300 	strcc	r0, [r4, -r0, lsl #6]
      f8:	04000000 	streq	r0, [r0], #-0
      fc:	00029602 	andeq	r9, r2, r2, lsl #12
     100:	07300100 	ldreq	r0, [r0, -r0, lsl #2]!
     104:	00000031 	andeq	r0, r0, r1, lsr r0
     108:	00002505 	andeq	r2, r0, r5, lsl #10
     10c:	00005700 	andeq	r5, r0, r0, lsl #14
     110:	00570600 	subseq	r0, r7, r0, lsl #12
     114:	ffff0000 			; <UNDEFINED> instruction: 0xffff0000
     118:	0700ffff 			; <UNDEFINED> instruction: 0x0700ffff
     11c:	13f50704 	mvnsne	r0, #4, 14	; 0x100000
     120:	82080000 	andhi	r0, r8, #0
     124:	01000003 	tsteq	r0, r3
     128:	00441533 	subeq	r1, r4, r3, lsr r5
     12c:	5c080000 	stcpl	0, cr0, [r8], {-0}
     130:	01000002 	tsteq	r0, r2
     134:	00441535 	subeq	r1, r4, r5, lsr r5
     138:	38050000 	stmdacc	r5, {}	; <UNPREDICTABLE>
     13c:	89000000 	stmdbhi	r0, {}	; <UNPREDICTABLE>
     140:	06000000 	streq	r0, [r0], -r0
     144:	00000057 	andeq	r0, r0, r7, asr r0
     148:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
     14c:	02760800 	rsbseq	r0, r6, #0, 16
     150:	38010000 	stmdacc	r1, {}	; <UNPREDICTABLE>
     154:	00007615 	andeq	r7, r0, r5, lsl r6
     158:	029f0800 	addseq	r0, pc, #0, 16
     15c:	3a010000 	bcc	40164 <__bss_end+0x3736c>
     160:	00007615 	andeq	r7, r0, r5, lsl r6
     164:	01e00900 	mvneq	r0, r0, lsl #18
     168:	48010000 	stmdami	r1, {}	; <UNPREDICTABLE>
     16c:	0000cb10 	andeq	ip, r0, r0, lsl fp
     170:	0081d400 	addeq	sp, r1, r0, lsl #8
     174:	00005800 	andeq	r5, r0, r0, lsl #16
     178:	cb9c0100 	blgt	fe700580 <__bss_end+0xfe6f7788>
     17c:	0a000000 	beq	184 <shift+0x184>
     180:	000001ee 	andeq	r0, r0, lr, ror #3
     184:	d20c4a01 	andle	r4, ip, #4096	; 0x1000
     188:	02000000 	andeq	r0, r0, #0
     18c:	0b007491 	bleq	1d3d8 <__bss_end+0x145e0>
     190:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
     194:	04030074 	streq	r0, [r3], #-116	; 0xffffff8c
     198:	00000038 	andeq	r0, r0, r8, lsr r0
     19c:	0002c709 	andeq	ip, r2, r9, lsl #14
     1a0:	103c0100 	eorsne	r0, ip, r0, lsl #2
     1a4:	000000cb 	andeq	r0, r0, fp, asr #1
     1a8:	0000817c 	andeq	r8, r0, ip, ror r1
     1ac:	00000058 	andeq	r0, r0, r8, asr r0
     1b0:	01029c01 	tsteq	r2, r1, lsl #24
     1b4:	ee0a0000 	cdp	0, 0, cr0, cr10, cr0, {0}
     1b8:	01000001 	tsteq	r0, r1
     1bc:	01020c3e 	tsteq	r2, lr, lsr ip
     1c0:	91020000 	mrsls	r0, (UNDEF: 2)
     1c4:	04030074 	streq	r0, [r3], #-116	; 0xffffff8c
     1c8:	00000025 	andeq	r0, r0, r5, lsr #32
     1cc:	0001b50c 	andeq	fp, r1, ip, lsl #10
     1d0:	11290100 			; <UNDEFINED> instruction: 0x11290100
     1d4:	00008170 	andeq	r8, r0, r0, ror r1
     1d8:	0000000c 	andeq	r0, r0, ip
     1dc:	ff0c9c01 			; <UNDEFINED> instruction: 0xff0c9c01
     1e0:	01000001 	tsteq	r0, r1
     1e4:	81581124 	cmphi	r8, r4, lsr #2
     1e8:	00180000 	andseq	r0, r8, r0
     1ec:	9c010000 	stcls	0, cr0, [r1], {-0}
     1f0:	0002ac0c 	andeq	sl, r2, ip, lsl #24
     1f4:	111f0100 	tstne	pc, r0, lsl #2
     1f8:	00008140 	andeq	r8, r0, r0, asr #2
     1fc:	00000018 	andeq	r0, r0, r8, lsl r0
     200:	690c9c01 	stmdbvs	ip, {r0, sl, fp, ip, pc}
     204:	01000002 	tsteq	r0, r2
     208:	8128111a 			; <UNDEFINED> instruction: 0x8128111a
     20c:	00180000 	andseq	r0, r8, r0
     210:	9c010000 	stcls	0, cr0, [r1], {-0}
     214:	0001f40d 	andeq	pc, r1, sp, lsl #8
     218:	9e000200 	cdpls	2, 0, cr0, cr0, cr0, {0}
     21c:	0e000001 	cdpeq	0, 0, cr0, cr0, cr1, {0}
     220:	00000284 	andeq	r0, r0, r4, lsl #5
     224:	6d121401 	cfldrsvs	mvf1, [r2, #-4]
     228:	0f000001 	svceq	0x00000001
     22c:	0000019e 	muleq	r0, lr, r1
     230:	01ad0200 			; <UNDEFINED> instruction: 0x01ad0200
     234:	04010000 	streq	r0, [r1], #-0
     238:	0001a41c 	andeq	sl, r1, ip, lsl r4
     23c:	01cc0e00 	biceq	r0, ip, r0, lsl #28
     240:	0f010000 	svceq	0x00010000
     244:	00018b12 	andeq	r8, r1, r2, lsl fp
     248:	019e0f00 	orrseq	r0, lr, r0, lsl #30
     24c:	10000000 	andne	r0, r0, r0
     250:	00000399 	muleq	r0, r9, r3
     254:	cb110a01 	blgt	442a60 <__bss_end+0x439c68>
     258:	0f000000 	svceq	0x00000000
     25c:	0000019e 	muleq	r0, lr, r1
     260:	04030000 	streq	r0, [r3], #-0
     264:	0000016d 	andeq	r0, r0, sp, ror #2
     268:	b9050807 	stmdblt	r5, {r0, r1, r2, fp}
     26c:	11000002 	tstne	r0, r2
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
     2bc:	0a010067 	beq	40460 <__bss_end+0x37668>
     2c0:	00019e2f 	andeq	r9, r1, pc, lsr #28
     2c4:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     2c8:	01760000 	cmneq	r6, r0
     2cc:	00040000 	andeq	r0, r4, r0
     2d0:	000001c6 	andeq	r0, r0, r6, asr #3
     2d4:	02d40104 	sbcseq	r0, r4, #4, 2
     2d8:	f4040000 	vst4.8	{d0-d3}, [r4], r0
     2dc:	46000003 	strmi	r0, [r0], -r3
     2e0:	2c000000 	stccs	0, cr0, [r0], {-0}
     2e4:	20000082 	andcs	r0, r0, r2, lsl #1
     2e8:	16000000 	strne	r0, [r0], -r0
     2ec:	02000002 	andeq	r0, r0, #2
     2f0:	047a0801 	ldrbteq	r0, [sl], #-2049	; 0xfffff7ff
     2f4:	02020000 	andeq	r0, r2, #0
     2f8:	0004d005 	andeq	sp, r4, r5
     2fc:	05040300 	streq	r0, [r4, #-768]	; 0xfffffd00
     300:	00746e69 	rsbseq	r6, r4, r9, ror #28
     304:	71080102 	tstvc	r8, r2, lsl #2
     308:	02000004 	andeq	r0, r0, #4
     30c:	03ad0702 			; <UNDEFINED> instruction: 0x03ad0702
     310:	89040000 	stmdbhi	r4, {}	; <UNPREDICTABLE>
     314:	06000004 	streq	r0, [r0], -r4
     318:	00590709 	subseq	r0, r9, r9, lsl #14
     31c:	48050000 	stmdami	r5, {}	; <UNPREDICTABLE>
     320:	02000000 	andeq	r0, r0, #0
     324:	13f50704 	mvnsne	r0, #4, 14	; 0x100000
     328:	d7060000 	strle	r0, [r6, -r0]
     32c:	02000003 	andeq	r0, r0, #3
     330:	00541405 	subseq	r1, r4, r5, lsl #8
     334:	03050000 	movweq	r0, #20480	; 0x5000
     338:	00008d70 	andeq	r8, r0, r0, ror sp
     33c:	00049206 	andeq	r9, r4, r6, lsl #4
     340:	14060200 	strne	r0, [r6], #-512	; 0xfffffe00
     344:	00000054 	andeq	r0, r0, r4, asr r0
     348:	8d740305 	ldclhi	3, cr0, [r4, #-20]!	; 0xffffffec
     34c:	da060000 	ble	180354 <__bss_end+0x17755c>
     350:	03000004 	movweq	r0, #4
     354:	00541a07 	subseq	r1, r4, r7, lsl #20
     358:	03050000 	movweq	r0, #20480	; 0x5000
     35c:	00008d78 	andeq	r8, r0, r8, ror sp
     360:	0003c006 	andeq	ip, r3, r6
     364:	1a090300 	bne	240f6c <__bss_end+0x238174>
     368:	00000054 	andeq	r0, r0, r4, asr r0
     36c:	8d7c0305 	ldclhi	3, cr0, [ip, #-20]!	; 0xffffffec
     370:	c2060000 	andgt	r0, r6, #0
     374:	03000004 	movweq	r0, #4
     378:	00541a0b 	subseq	r1, r4, fp, lsl #20
     37c:	03050000 	movweq	r0, #20480	; 0x5000
     380:	00008d80 	andeq	r8, r0, r0, lsl #27
     384:	00045e06 	andeq	r5, r4, r6, lsl #28
     388:	1a0d0300 	bne	340f90 <__bss_end+0x338198>
     38c:	00000054 	andeq	r0, r0, r4, asr r0
     390:	8d840305 	stchi	3, cr0, [r4, #20]
     394:	7f060000 	svcvc	0x00060000
     398:	03000004 	movweq	r0, #4
     39c:	00541a0f 	subseq	r1, r4, pc, lsl #20
     3a0:	03050000 	movweq	r0, #20480	; 0x5000
     3a4:	00008d88 	andeq	r8, r0, r8, lsl #27
     3a8:	46020102 	strmi	r0, [r2], -r2, lsl #2
     3ac:	06000004 	streq	r0, [r0], -r4
     3b0:	000004a9 	andeq	r0, r0, r9, lsr #9
     3b4:	54140404 	ldrpl	r0, [r4], #-1028	; 0xfffffbfc
     3b8:	05000000 	streq	r0, [r0, #-0]
     3bc:	008d8c03 	addeq	r8, sp, r3, lsl #24
     3c0:	049e0600 	ldreq	r0, [lr], #1536	; 0x600
     3c4:	07040000 	streq	r0, [r4, -r0]
     3c8:	00005414 	andeq	r5, r0, r4, lsl r4
     3cc:	90030500 	andls	r0, r3, r0, lsl #10
     3d0:	0600008d 	streq	r0, [r0], -sp, lsl #1
     3d4:	0000044b 	andeq	r0, r0, fp, asr #8
     3d8:	54140a04 	ldrpl	r0, [r4], #-2564	; 0xfffff5fc
     3dc:	05000000 	streq	r0, [r0, #-0]
     3e0:	008d9403 	addeq	r9, sp, r3, lsl #8
     3e4:	07040200 	streq	r0, [r4, -r0, lsl #4]
     3e8:	000013f0 	strdeq	r1, [r0], -r0
     3ec:	0003e506 	andeq	lr, r3, r6, lsl #10
     3f0:	140a0500 	strne	r0, [sl], #-1280	; 0xfffffb00
     3f4:	00000054 	andeq	r0, r0, r4, asr r0
     3f8:	8d980305 	ldchi	3, cr0, [r8, #20]
     3fc:	89070000 	stmdbhi	r7, {}	; <UNPREDICTABLE>
     400:	01000013 	tsteq	r0, r3, lsl r0
     404:	00330505 	eorseq	r0, r3, r5, lsl #10
     408:	822c0000 	eorhi	r0, ip, #0
     40c:	00200000 	eoreq	r0, r0, r0
     410:	9c010000 	stcls	0, cr0, [r1], {-0}
     414:	0000016d 	andeq	r0, r0, sp, ror #2
     418:	0003d208 	andeq	sp, r3, r8, lsl #4
     41c:	0e050100 	adfeqs	f0, f5, f0
     420:	00000033 	andeq	r0, r0, r3, lsr r0
     424:	08749102 	ldmdaeq	r4!, {r1, r8, ip, pc}^
     428:	000004f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     42c:	6d1b0501 	cfldr32vs	mvfx0, [fp, #-4]
     430:	02000001 	andeq	r0, r0, #1
     434:	09007091 	stmdbeq	r0, {r0, r4, r7, ip, sp, lr}
     438:	00017304 	andeq	r7, r1, r4, lsl #6
     43c:	25040900 	strcs	r0, [r4, #-2304]	; 0xfffff700
     440:	00000000 	andeq	r0, r0, r0
     444:	00000b1f 	andeq	r0, r0, pc, lsl fp
     448:	024f0004 	subeq	r0, pc, #4
     44c:	01040000 	mrseq	r0, (UNDEF: 4)
     450:	000009a3 	andeq	r0, r0, r3, lsr #19
     454:	00071804 	andeq	r1, r7, r4, lsl #16
     458:	000b0d00 	andeq	r0, fp, r0, lsl #26
     45c:	00824c00 	addeq	r4, r2, r0, lsl #24
     460:	00045c00 	andeq	r5, r4, r0, lsl #24
     464:	0003fa00 	andeq	pc, r3, r0, lsl #20
     468:	08010200 	stmdaeq	r1, {r9}
     46c:	0000047a 	andeq	r0, r0, sl, ror r4
     470:	00002503 	andeq	r2, r0, r3, lsl #10
     474:	05020200 	streq	r0, [r2, #-512]	; 0xfffffe00
     478:	000004d0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     47c:	69050404 	stmdbvs	r5, {r2, sl}
     480:	0200746e 	andeq	r7, r0, #1845493760	; 0x6e000000
     484:	04710801 	ldrbteq	r0, [r1], #-2049	; 0xfffff7ff
     488:	02020000 	andeq	r0, r2, #0
     48c:	0003ad07 	andeq	sl, r3, r7, lsl #26
     490:	04890500 	streq	r0, [r9], #1280	; 0x500
     494:	09070000 	stmdbeq	r7, {}	; <UNPREDICTABLE>
     498:	00005e07 	andeq	r5, r0, r7, lsl #28
     49c:	004d0300 	subeq	r0, sp, r0, lsl #6
     4a0:	04020000 	streq	r0, [r2], #-0
     4a4:	0013f507 	andseq	pc, r3, r7, lsl #10
     4a8:	06ff0600 	ldrbteq	r0, [pc], r0, lsl #12
     4ac:	02080000 	andeq	r0, r8, #0
     4b0:	008b0806 	addeq	r0, fp, r6, lsl #16
     4b4:	72070000 	andvc	r0, r7, #0
     4b8:	08020030 	stmdaeq	r2, {r4, r5}
     4bc:	00004d0e 	andeq	r4, r0, lr, lsl #26
     4c0:	72070000 	andvc	r0, r7, #0
     4c4:	09020031 	stmdbeq	r2, {r0, r4, r5}
     4c8:	00004d0e 	andeq	r4, r0, lr, lsl #26
     4cc:	08000400 	stmdaeq	r0, {sl}
     4d0:	00000c43 	andeq	r0, r0, r3, asr #24
     4d4:	00380405 	eorseq	r0, r8, r5, lsl #8
     4d8:	0d020000 	stceq	0, cr0, [r2, #-0]
     4dc:	0000a90c 	andeq	sl, r0, ip, lsl #18
     4e0:	4b4f0900 	blmi	13c28e8 <__bss_end+0x13b9af0>
     4e4:	640a0000 	strvs	r0, [sl], #-0
     4e8:	01000007 	tsteq	r0, r7
     4ec:	05e00800 	strbeq	r0, [r0, #2048]!	; 0x800
     4f0:	04050000 	streq	r0, [r5], #-0
     4f4:	00000038 	andeq	r0, r0, r8, lsr r0
     4f8:	e00c1e02 	and	r1, ip, r2, lsl #28
     4fc:	0a000000 	beq	504 <shift+0x504>
     500:	000007b6 			; <UNDEFINED> instruction: 0x000007b6
     504:	0f060a00 	svceq	0x00060a00
     508:	0a010000 	beq	40510 <__bss_end+0x37718>
     50c:	00000ee6 	andeq	r0, r0, r6, ror #29
     510:	092e0a02 	stmdbeq	lr!, {r1, r9, fp}
     514:	0a030000 	beq	c051c <__bss_end+0xb7724>
     518:	00000b48 	andeq	r0, r0, r8, asr #22
     51c:	07760a04 	ldrbeq	r0, [r6, -r4, lsl #20]!
     520:	00050000 	andeq	r0, r5, r0
     524:	000e5508 	andeq	r5, lr, r8, lsl #10
     528:	38040500 	stmdacc	r4, {r8, sl}
     52c:	02000000 	andeq	r0, r0, #0
     530:	011d0c3f 	tsteq	sp, pc, lsr ip
     534:	000a0000 	andeq	r0, sl, r0
     538:	00000005 	andeq	r0, r0, r5
     53c:	0005f50a 	andeq	pc, r5, sl, lsl #10
     540:	070a0100 	streq	r0, [sl, -r0, lsl #2]
     544:	0200000b 	andeq	r0, r0, #11
     548:	000eb20a 	andeq	fp, lr, sl, lsl #4
     54c:	100a0300 	andne	r0, sl, r0, lsl #6
     550:	0400000f 	streq	r0, [r0], #-15
     554:	000ac30a 	andeq	ip, sl, sl, lsl #6
     558:	f50a0500 			; <UNDEFINED> instruction: 0xf50a0500
     55c:	06000008 	streq	r0, [r0], -r8
     560:	0e0f0800 	cdpeq	8, 0, cr0, cr15, cr0, {0}
     564:	04050000 	streq	r0, [r5], #-0
     568:	00000038 	andeq	r0, r0, r8, lsr r0
     56c:	480c6602 	stmdami	ip, {r1, r9, sl, sp, lr}
     570:	0a000001 	beq	57c <shift+0x57c>
     574:	00000bbd 			; <UNDEFINED> instruction: 0x00000bbd
     578:	08b00a00 	ldmeq	r0!, {r9, fp}
     57c:	0a010000 	beq	40584 <__bss_end+0x3778c>
     580:	00000c0c 	andeq	r0, r0, ip, lsl #24
     584:	08fa0a02 	ldmeq	sl!, {r1, r9, fp}^
     588:	00030000 	andeq	r0, r3, r0
     58c:	0003d70b 	andeq	sp, r3, fp, lsl #14
     590:	14050300 	strne	r0, [r5], #-768	; 0xfffffd00
     594:	00000059 	andeq	r0, r0, r9, asr r0
     598:	8d9c0305 	ldchi	3, cr0, [ip, #20]
     59c:	920b0000 	andls	r0, fp, #0
     5a0:	03000004 	movweq	r0, #4
     5a4:	00591406 	subseq	r1, r9, r6, lsl #8
     5a8:	03050000 	movweq	r0, #20480	; 0x5000
     5ac:	00008da0 	andeq	r8, r0, r0, lsr #27
     5b0:	0004da0b 	andeq	sp, r4, fp, lsl #20
     5b4:	1a070400 	bne	1c15bc <__bss_end+0x1b87c4>
     5b8:	00000059 	andeq	r0, r0, r9, asr r0
     5bc:	8da40305 	stchi	3, cr0, [r4, #20]!
     5c0:	c00b0000 	andgt	r0, fp, r0
     5c4:	04000003 	streq	r0, [r0], #-3
     5c8:	00591a09 	subseq	r1, r9, r9, lsl #20
     5cc:	03050000 	movweq	r0, #20480	; 0x5000
     5d0:	00008da8 	andeq	r8, r0, r8, lsr #27
     5d4:	0004c20b 	andeq	ip, r4, fp, lsl #4
     5d8:	1a0b0400 	bne	2c15e0 <__bss_end+0x2b87e8>
     5dc:	00000059 	andeq	r0, r0, r9, asr r0
     5e0:	8dac0305 	stchi	3, cr0, [ip, #20]!
     5e4:	5e0b0000 	cdppl	0, 0, cr0, cr11, cr0, {0}
     5e8:	04000004 	streq	r0, [r0], #-4
     5ec:	00591a0d 	subseq	r1, r9, sp, lsl #20
     5f0:	03050000 	movweq	r0, #20480	; 0x5000
     5f4:	00008db0 			; <UNDEFINED> instruction: 0x00008db0
     5f8:	00047f0b 	andeq	r7, r4, fp, lsl #30
     5fc:	1a0f0400 	bne	3c1604 <__bss_end+0x3b880c>
     600:	00000059 	andeq	r0, r0, r9, asr r0
     604:	8db40305 	ldchi	3, cr0, [r4, #20]!
     608:	cb080000 	blgt	200610 <__bss_end+0x1f7818>
     60c:	0500000e 	streq	r0, [r0, #-14]
     610:	00003804 	andeq	r3, r0, r4, lsl #16
     614:	0c1b0400 	cfldrseq	mvf0, [fp], {-0}
     618:	000001eb 	andeq	r0, r0, fp, ror #3
     61c:	000ccd0a 	andeq	ip, ip, sl, lsl #26
     620:	db0a0000 	blle	280628 <__bss_end+0x277830>
     624:	0100000e 	tsteq	r0, lr
     628:	000b020a 	andeq	r0, fp, sl, lsl #4
     62c:	0c000200 	sfmeq	f0, 4, [r0], {-0}
     630:	00000bb7 			; <UNDEFINED> instruction: 0x00000bb7
     634:	46020102 	strmi	r0, [r2], -r2, lsl #2
     638:	0d000004 	stceq	0, cr0, [r0, #-16]
     63c:	00002c04 	andeq	r2, r0, r4, lsl #24
     640:	eb040d00 	bl	103a48 <__bss_end+0xfac50>
     644:	0b000001 	bleq	650 <shift+0x650>
     648:	000004a9 	andeq	r0, r0, r9, lsr #9
     64c:	59140405 	ldmdbpl	r4, {r0, r2, sl}
     650:	05000000 	streq	r0, [r0, #-0]
     654:	008db803 	addeq	fp, sp, r3, lsl #16
     658:	049e0b00 	ldreq	r0, [lr], #2816	; 0xb00
     65c:	07050000 	streq	r0, [r5, -r0]
     660:	00005914 	andeq	r5, r0, r4, lsl r9
     664:	bc030500 	cfstr32lt	mvfx0, [r3], {-0}
     668:	0b00008d 	bleq	8a4 <shift+0x8a4>
     66c:	0000044b 	andeq	r0, r0, fp, asr #8
     670:	59140a05 	ldmdbpl	r4, {r0, r2, r9, fp}
     674:	05000000 	streq	r0, [r0, #-0]
     678:	008dc003 	addeq	ip, sp, r3
     67c:	09890800 	stmibeq	r9, {fp}
     680:	04050000 	streq	r0, [r5], #-0
     684:	00000038 	andeq	r0, r0, r8, lsr r0
     688:	700c0d05 	andvc	r0, ip, r5, lsl #26
     68c:	09000002 	stmdbeq	r0, {r1}
     690:	0077654e 	rsbseq	r6, r7, lr, asr #10
     694:	09800a00 	stmibeq	r0, {r9, fp}
     698:	0a010000 	beq	406a0 <__bss_end+0x378a8>
     69c:	00000c54 	andeq	r0, r0, r4, asr ip
     6a0:	09520a02 	ldmdbeq	r2, {r1, r9, fp}^
     6a4:	0a030000 	beq	c06ac <__bss_end+0xb78b4>
     6a8:	00000920 	andeq	r0, r0, r0, lsr #18
     6ac:	08520a04 	ldmdaeq	r2, {r2, r9, fp}^
     6b0:	00050000 	andeq	r0, r5, r0
     6b4:	00076906 	andeq	r6, r7, r6, lsl #18
     6b8:	1b051000 	blne	1446c0 <__bss_end+0x13b8c8>
     6bc:	0002af08 	andeq	sl, r2, r8, lsl #30
     6c0:	726c0700 	rsbvc	r0, ip, #0, 14
     6c4:	131d0500 	tstne	sp, #0, 10
     6c8:	000002af 	andeq	r0, r0, pc, lsr #5
     6cc:	70730700 	rsbsvc	r0, r3, r0, lsl #14
     6d0:	131e0500 	tstne	lr, #0, 10
     6d4:	000002af 	andeq	r0, r0, pc, lsr #5
     6d8:	63700704 	cmnvs	r0, #4, 14	; 0x100000
     6dc:	131f0500 	tstne	pc, #0, 10
     6e0:	000002af 	andeq	r0, r0, pc, lsr #5
     6e4:	07880e08 	streq	r0, [r8, r8, lsl #28]
     6e8:	20050000 	andcs	r0, r5, r0
     6ec:	0002af13 	andeq	sl, r2, r3, lsl pc
     6f0:	02000c00 	andeq	r0, r0, #0, 24
     6f4:	13f00704 	mvnsne	r0, #4, 14	; 0x100000
     6f8:	25060000 	strcs	r0, [r6, #-0]
     6fc:	70000008 	andvc	r0, r0, r8
     700:	46082805 	strmi	r2, [r8], -r5, lsl #16
     704:	0e000003 	cdpeq	0, 0, cr0, cr0, cr3, {0}
     708:	00000cc1 	andeq	r0, r0, r1, asr #25
     70c:	70122a05 	andsvc	r2, r2, r5, lsl #20
     710:	00000002 	andeq	r0, r0, r2
     714:	64697007 	strbtvs	r7, [r9], #-7
     718:	122b0500 	eorne	r0, fp, #0, 10
     71c:	0000005e 	andeq	r0, r0, lr, asr r0
     720:	063a0e10 			; <UNDEFINED> instruction: 0x063a0e10
     724:	2c050000 	stccs	0, cr0, [r5], {-0}
     728:	00023911 	andeq	r3, r2, r1, lsl r9
     72c:	950e1400 	strls	r1, [lr, #-1024]	; 0xfffffc00
     730:	05000009 	streq	r0, [r0, #-9]
     734:	005e122d 	subseq	r1, lr, sp, lsr #4
     738:	0e180000 	cdpeq	0, 1, cr0, cr8, cr0, {0}
     73c:	00000a64 	andeq	r0, r0, r4, ror #20
     740:	5e122e05 	cdppl	14, 1, cr2, cr2, cr5, {0}
     744:	1c000000 	stcne	0, cr0, [r0], {-0}
     748:	00070b0e 	andeq	r0, r7, lr, lsl #22
     74c:	0c2f0500 	cfstr32eq	mvfx0, [pc], #-0	; 754 <shift+0x754>
     750:	00000346 	andeq	r0, r0, r6, asr #6
     754:	0a5a0e20 	beq	1683fdc <__bss_end+0x167b1e4>
     758:	30050000 	andcc	r0, r5, r0
     75c:	00003809 	andeq	r3, r0, r9, lsl #16
     760:	de0e6000 	cdple	0, 0, cr6, cr14, cr0, {0}
     764:	0500000c 	streq	r0, [r0, #-12]
     768:	004d0e31 	subeq	r0, sp, r1, lsr lr
     76c:	0e640000 	cdpeq	0, 6, cr0, cr4, cr0, {0}
     770:	000007c7 	andeq	r0, r0, r7, asr #15
     774:	4d0e3305 	stcmi	3, cr3, [lr, #-20]	; 0xffffffec
     778:	68000000 	stmdavs	r0, {}	; <UNPREDICTABLE>
     77c:	0007be0e 	andeq	fp, r7, lr, lsl #28
     780:	0e340500 	cfabs32eq	mvfx0, mvfx4
     784:	0000004d 	andeq	r0, r0, sp, asr #32
     788:	fd0f006c 	stc2	0, cr0, [pc, #-432]	; 5e0 <shift+0x5e0>
     78c:	56000001 	strpl	r0, [r0], -r1
     790:	10000003 	andne	r0, r0, r3
     794:	0000005e 	andeq	r0, r0, lr, asr r0
     798:	e50b000f 	str	r0, [fp, #-15]
     79c:	06000003 	streq	r0, [r0], -r3
     7a0:	0059140a 	subseq	r1, r9, sl, lsl #8
     7a4:	03050000 	movweq	r0, #20480	; 0x5000
     7a8:	00008dc4 	andeq	r8, r0, r4, asr #27
     7ac:	00095a08 	andeq	r5, r9, r8, lsl #20
     7b0:	38040500 	stmdacc	r4, {r8, sl}
     7b4:	06000000 	streq	r0, [r0], -r0
     7b8:	03870c0d 	orreq	r0, r7, #3328	; 0xd00
     7bc:	fa0a0000 	blx	2807c4 <__bss_end+0x2779cc>
     7c0:	00000005 	andeq	r0, r0, r5
     7c4:	0004f50a 	andeq	pc, r4, sl, lsl #10
     7c8:	03000100 	movweq	r0, #256	; 0x100
     7cc:	00000368 	andeq	r0, r0, r8, ror #6
     7d0:	000a9f08 	andeq	r9, sl, r8, lsl #30
     7d4:	38040500 	stmdacc	r4, {r8, sl}
     7d8:	06000000 	streq	r0, [r0], -r0
     7dc:	03ab0c14 			; <UNDEFINED> instruction: 0x03ab0c14
     7e0:	3f0a0000 	svccc	0x000a0000
     7e4:	00000005 	andeq	r0, r0, r5
     7e8:	000bfe0a 	andeq	pc, fp, sl, lsl #28
     7ec:	03000100 	movweq	r0, #256	; 0x100
     7f0:	0000038c 	andeq	r0, r0, ip, lsl #7
     7f4:	000d9e06 	andeq	r9, sp, r6, lsl #28
     7f8:	1b060c00 	blne	183800 <__bss_end+0x17aa08>
     7fc:	0003e508 	andeq	lr, r3, r8, lsl #10
     800:	053a0e00 	ldreq	r0, [sl, #-3584]!	; 0xfffff200
     804:	1d060000 	stcne	0, cr0, [r6, #-0]
     808:	0003e519 	andeq	lr, r3, r9, lsl r5
     80c:	b70e0000 	strlt	r0, [lr, -r0]
     810:	06000005 	streq	r0, [r0], -r5
     814:	03e5191e 	mvneq	r1, #491520	; 0x78000
     818:	0e040000 	cdpeq	0, 0, cr0, cr4, cr0, {0}
     81c:	00000d52 	andeq	r0, r0, r2, asr sp
     820:	eb131f06 	bl	4c8440 <__bss_end+0x4bf648>
     824:	08000003 	stmdaeq	r0, {r0, r1}
     828:	b0040d00 	andlt	r0, r4, r0, lsl #26
     82c:	0d000003 	stceq	0, cr0, [r0, #-12]
     830:	0002b604 	andeq	fp, r2, r4, lsl #12
     834:	065f1100 	ldrbeq	r1, [pc], -r0, lsl #2
     838:	06140000 	ldreq	r0, [r4], -r0
     83c:	06730722 	ldrbteq	r0, [r3], -r2, lsr #14
     840:	480e0000 	stmdami	lr, {}	; <UNPREDICTABLE>
     844:	06000009 	streq	r0, [r0], -r9
     848:	004d1226 	subeq	r1, sp, r6, lsr #4
     84c:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
     850:	0000056b 	andeq	r0, r0, fp, ror #10
     854:	e51d2906 	ldr	r2, [sp, #-2310]	; 0xfffff6fa
     858:	04000003 	streq	r0, [r0], #-3
     85c:	000c980e 	andeq	r9, ip, lr, lsl #16
     860:	1d2c0600 	stcne	6, cr0, [ip, #-0]
     864:	000003e5 	andeq	r0, r0, r5, ror #7
     868:	0e4b1208 	cdpeq	2, 4, cr1, cr11, cr8, {0}
     86c:	2f060000 	svccs	0x00060000
     870:	000d7b0e 	andeq	r7, sp, lr, lsl #22
     874:	00043900 	andeq	r3, r4, r0, lsl #18
     878:	00044400 	andeq	r4, r4, r0, lsl #8
     87c:	06781300 	ldrbteq	r1, [r8], -r0, lsl #6
     880:	e5140000 	ldr	r0, [r4, #-0]
     884:	00000003 	andeq	r0, r0, r3
     888:	000d6315 	andeq	r6, sp, r5, lsl r3
     88c:	0e310600 	cfmsuba32eq	mvax0, mvax0, mvfx1, mvfx0
     890:	000007fc 	strdeq	r0, [r0], -ip
     894:	000001f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     898:	0000045c 	andeq	r0, r0, ip, asr r4
     89c:	00000467 	andeq	r0, r0, r7, ror #8
     8a0:	00067813 	andeq	r7, r6, r3, lsl r8
     8a4:	03eb1400 	mvneq	r1, #0, 8
     8a8:	16000000 	strne	r0, [r0], -r0
     8ac:	00000db1 			; <UNDEFINED> instruction: 0x00000db1
     8b0:	2d1d3506 	cfldr32cs	mvfx3, [sp, #-24]	; 0xffffffe8
     8b4:	e500000d 	str	r0, [r0, #-13]
     8b8:	02000003 	andeq	r0, r0, #3
     8bc:	00000480 	andeq	r0, r0, r0, lsl #9
     8c0:	00000486 	andeq	r0, r0, r6, lsl #9
     8c4:	00067813 	andeq	r7, r6, r3, lsl r8
     8c8:	e8160000 	ldmda	r6, {}	; <UNPREDICTABLE>
     8cc:	06000008 	streq	r0, [r0], -r8
     8d0:	0bc81d37 	bleq	ff207db4 <__bss_end+0xff1fefbc>
     8d4:	03e50000 	mvneq	r0, #0
     8d8:	9f020000 	svcls	0x00020000
     8dc:	a5000004 	strge	r0, [r0, #-4]
     8e0:	13000004 	movwne	r0, #4
     8e4:	00000678 	andeq	r0, r0, r8, ror r6
     8e8:	0a801700 	beq	fe0064f0 <__bss_end+0xfdffd6f8>
     8ec:	39060000 	stmdbcc	r6, {}	; <UNPREDICTABLE>
     8f0:	00069131 	andeq	r9, r6, r1, lsr r1
     8f4:	16020c00 	strne	r0, [r2], -r0, lsl #24
     8f8:	0000065f 	andeq	r0, r0, pc, asr r6
     8fc:	ec093c06 	stc	12, cr3, [r9], {6}
     900:	7800000e 	stmdavc	r0, {r1, r2, r3}
     904:	01000006 	tsteq	r0, r6
     908:	000004cc 	andeq	r0, r0, ip, asr #9
     90c:	000004d2 	ldrdeq	r0, [r0], -r2
     910:	00067813 	andeq	r7, r6, r3, lsl r8
     914:	0f160000 	svceq	0x00160000
     918:	06000006 	streq	r0, [r0], -r6
     91c:	0e20123f 	mcreq	2, 1, r1, cr0, cr15, {1}
     920:	004d0000 	subeq	r0, sp, r0
     924:	eb010000 	bl	4092c <__bss_end+0x37b34>
     928:	00000004 	andeq	r0, r0, r4
     92c:	13000005 	movwne	r0, #5
     930:	00000678 	andeq	r0, r0, r8, ror r6
     934:	00069a14 	andeq	r9, r6, r4, lsl sl
     938:	005e1400 	subseq	r1, lr, r0, lsl #8
     93c:	f0140000 			; <UNDEFINED> instruction: 0xf0140000
     940:	00000001 	andeq	r0, r0, r1
     944:	000d7218 	andeq	r7, sp, r8, lsl r2
     948:	0e420600 	cdpeq	6, 4, cr0, cr2, cr0, {0}
     94c:	00000b69 	andeq	r0, r0, r9, ror #22
     950:	00051501 	andeq	r1, r5, r1, lsl #10
     954:	00051b00 	andeq	r1, r5, r0, lsl #22
     958:	06781300 	ldrbteq	r1, [r8], -r0, lsl #6
     95c:	16000000 	strne	r0, [r0], -r0
     960:	00000877 	andeq	r0, r0, r7, ror r8
     964:	83174506 	tsthi	r7, #25165824	; 0x1800000
     968:	eb000005 	bl	984 <shift+0x984>
     96c:	01000003 	tsteq	r0, r3
     970:	00000534 	andeq	r0, r0, r4, lsr r5
     974:	0000053a 	andeq	r0, r0, sl, lsr r5
     978:	0006a013 	andeq	sl, r6, r3, lsl r0
     97c:	bc160000 	ldclt	0, cr0, [r6], {-0}
     980:	06000005 	streq	r0, [r0], -r5
     984:	0cea1748 	stcleq	7, cr1, [sl], #288	; 0x120
     988:	03eb0000 	mvneq	r0, #0
     98c:	53010000 	movwpl	r0, #4096	; 0x1000
     990:	5e000005 	cdppl	0, 0, cr0, cr0, cr5, {0}
     994:	13000005 	movwne	r0, #5
     998:	000006a0 	andeq	r0, r0, r0, lsr #13
     99c:	00004d14 	andeq	r4, r0, r4, lsl sp
     9a0:	97180000 	ldrls	r0, [r8, -r0]
     9a4:	0600000e 	streq	r0, [r0], -lr
     9a8:	05050e4b 	streq	r0, [r5, #-3659]	; 0xfffff1b5
     9ac:	73010000 	movwvc	r0, #4096	; 0x1000
     9b0:	79000005 	stmdbvc	r0, {r0, r2}
     9b4:	13000005 	movwne	r0, #5
     9b8:	00000678 	andeq	r0, r0, r8, ror r6
     9bc:	0d631600 	stcleq	6, cr1, [r3, #-0]
     9c0:	4d060000 	stcmi	0, cr0, [r6, #-0]
     9c4:	00078e0e 	andeq	r8, r7, lr, lsl #28
     9c8:	0001f000 	andeq	pc, r1, r0
     9cc:	05920100 	ldreq	r0, [r2, #256]	; 0x100
     9d0:	059d0000 	ldreq	r0, [sp]
     9d4:	78130000 	ldmdavc	r3, {}	; <UNPREDICTABLE>
     9d8:	14000006 	strne	r0, [r0], #-6
     9dc:	0000004d 	andeq	r0, r0, sp, asr #32
     9e0:	089c1600 	ldmeq	ip, {r9, sl, ip}
     9e4:	50060000 	andpl	r0, r6, r0
     9e8:	000b8a12 	andeq	r8, fp, r2, lsl sl
     9ec:	00004d00 	andeq	r4, r0, r0, lsl #26
     9f0:	05b60100 	ldreq	r0, [r6, #256]!	; 0x100
     9f4:	05c10000 	strbeq	r0, [r1]
     9f8:	78130000 	ldmdavc	r3, {}	; <UNPREDICTABLE>
     9fc:	14000006 	strne	r0, [r0], #-6
     a00:	000001fd 	strdeq	r0, [r0], -sp
     a04:	054c1600 	strbeq	r1, [ip, #-1536]	; 0xfffffa00
     a08:	53060000 	movwpl	r0, #24576	; 0x6000
     a0c:	0007d00e 	andeq	sp, r7, lr
     a10:	0001f000 	andeq	pc, r1, r0
     a14:	05da0100 	ldrbeq	r0, [sl, #256]	; 0x100
     a18:	05e50000 	strbeq	r0, [r5, #0]!
     a1c:	78130000 	ldmdavc	r3, {}	; <UNPREDICTABLE>
     a20:	14000006 	strne	r0, [r0], #-6
     a24:	0000004d 	andeq	r0, r0, sp, asr #32
     a28:	08cf1800 	stmiaeq	pc, {fp, ip}^	; <UNPREDICTABLE>
     a2c:	56060000 	strpl	r0, [r6], -r0
     a30:	000dbd0e 	andeq	fp, sp, lr, lsl #26
     a34:	05fa0100 	ldrbeq	r0, [sl, #256]!	; 0x100
     a38:	06190000 	ldreq	r0, [r9], -r0
     a3c:	78130000 	ldmdavc	r3, {}	; <UNPREDICTABLE>
     a40:	14000006 	strne	r0, [r0], #-6
     a44:	000000a9 	andeq	r0, r0, r9, lsr #1
     a48:	00004d14 	andeq	r4, r0, r4, lsl sp
     a4c:	004d1400 	subeq	r1, sp, r0, lsl #8
     a50:	4d140000 	ldcmi	0, cr0, [r4, #-0]
     a54:	14000000 	strne	r0, [r0], #-0
     a58:	000006a6 	andeq	r0, r0, r6, lsr #13
     a5c:	0d171800 	ldceq	8, cr1, [r7, #-0]
     a60:	58060000 	stmdapl	r6, {}	; <UNPREDICTABLE>
     a64:	0006b30e 	andeq	fp, r6, lr, lsl #6
     a68:	062e0100 	strteq	r0, [lr], -r0, lsl #2
     a6c:	064d0000 	strbeq	r0, [sp], -r0
     a70:	78130000 	ldmdavc	r3, {}	; <UNPREDICTABLE>
     a74:	14000006 	strne	r0, [r0], #-6
     a78:	000000e0 	andeq	r0, r0, r0, ror #1
     a7c:	00004d14 	andeq	r4, r0, r4, lsl sp
     a80:	004d1400 	subeq	r1, sp, r0, lsl #8
     a84:	4d140000 	ldcmi	0, cr0, [r4, #-0]
     a88:	14000000 	strne	r0, [r0], #-0
     a8c:	000006a6 	andeq	r0, r0, r6, lsr #13
     a90:	064c1900 	strbeq	r1, [ip], -r0, lsl #18
     a94:	5b060000 	blpl	180a9c <__bss_end+0x177ca4>
     a98:	0006700e 	andeq	r7, r6, lr
     a9c:	0001f000 	andeq	pc, r1, r0
     aa0:	06620100 	strbteq	r0, [r2], -r0, lsl #2
     aa4:	78130000 	ldmdavc	r3, {}	; <UNPREDICTABLE>
     aa8:	14000006 	strne	r0, [r0], #-6
     aac:	00000368 	andeq	r0, r0, r8, ror #6
     ab0:	0006ac14 	andeq	sl, r6, r4, lsl ip
     ab4:	03000000 	movweq	r0, #0
     ab8:	000003f1 	strdeq	r0, [r0], -r1
     abc:	03f1040d 	mvnseq	r0, #218103808	; 0xd000000
     ac0:	e51a0000 	ldr	r0, [sl, #-0]
     ac4:	8b000003 	blhi	ad8 <shift+0xad8>
     ac8:	91000006 	tstls	r0, r6
     acc:	13000006 	movwne	r0, #6
     ad0:	00000678 	andeq	r0, r0, r8, ror r6
     ad4:	03f11b00 	mvnseq	r1, #0, 22
     ad8:	067e0000 	ldrbteq	r0, [lr], -r0
     adc:	040d0000 	streq	r0, [sp], #-0
     ae0:	0000003f 	andeq	r0, r0, pc, lsr r0
     ae4:	0673040d 	ldrbteq	r0, [r3], -sp, lsl #8
     ae8:	041c0000 	ldreq	r0, [ip], #-0
     aec:	00000065 	andeq	r0, r0, r5, rrx
     af0:	2c0f041d 	cfstrscs	mvf0, [pc], {29}
     af4:	be000000 	cdplt	0, 0, cr0, cr0, cr0, {0}
     af8:	10000006 	andne	r0, r0, r6
     afc:	0000005e 	andeq	r0, r0, lr, asr r0
     b00:	ae030009 	cdpge	0, 0, cr0, cr3, cr9, {0}
     b04:	1e000006 	cdpne	0, 0, cr0, cr0, cr6, {0}
     b08:	0000088b 	andeq	r0, r0, fp, lsl #17
     b0c:	be0ca401 	cdplt	4, 0, cr10, cr12, cr1, {0}
     b10:	05000006 	streq	r0, [r0, #-6]
     b14:	008dc803 	addeq	ip, sp, r3, lsl #16
     b18:	057e1f00 	ldrbeq	r1, [lr, #-3840]!	; 0xfffff100
     b1c:	a6010000 	strge	r0, [r1], -r0
     b20:	000a930a 	andeq	r9, sl, sl, lsl #6
     b24:	00004d00 	andeq	r4, r0, r0, lsl #26
     b28:	0085f800 	addeq	pc, r5, r0, lsl #16
     b2c:	0000b000 	andeq	fp, r0, r0
     b30:	339c0100 	orrscc	r0, ip, #0, 2
     b34:	20000007 	andcs	r0, r0, r7
     b38:	00000e92 	muleq	r0, r2, lr
     b3c:	f71ba601 			; <UNDEFINED> instruction: 0xf71ba601
     b40:	03000001 	movweq	r0, #1
     b44:	207fac91 			; <UNDEFINED> instruction: 0x207fac91
     b48:	00000af9 	strdeq	r0, [r0], -r9
     b4c:	4d2aa601 	stcmi	6, cr10, [sl, #-4]!
     b50:	03000000 	movweq	r0, #0
     b54:	1e7fa891 	mrcne	8, 3, sl, cr15, cr1, {4}
     b58:	0000097a 	andeq	r0, r0, sl, ror r9
     b5c:	330aa801 	movwcc	sl, #43009	; 0xa801
     b60:	03000007 	movweq	r0, #7
     b64:	1e7fb491 	mrcne	4, 3, fp, cr15, cr1, {4}
     b68:	00000566 	andeq	r0, r0, r6, ror #10
     b6c:	3809ac01 	stmdacc	r9, {r0, sl, fp, sp, pc}
     b70:	02000000 	andeq	r0, r0, #0
     b74:	0f007491 	svceq	0x00007491
     b78:	00000025 	andeq	r0, r0, r5, lsr #32
     b7c:	00000743 	andeq	r0, r0, r3, asr #14
     b80:	00005e10 	andeq	r5, r0, r0, lsl lr
     b84:	21003f00 	tstcs	r0, r0, lsl #30
     b88:	00000ade 	ldrdeq	r0, [r0], -lr
     b8c:	230a9801 	movwcs	r9, #43009	; 0xa801
     b90:	4d00000c 	stcmi	0, cr0, [r0, #-48]	; 0xffffffd0
     b94:	bc000000 	stclt	0, cr0, [r0], {-0}
     b98:	3c000085 	stccc	0, cr0, [r0], {133}	; 0x85
     b9c:	01000000 	mrseq	r0, (UNDEF: 0)
     ba0:	0007809c 	muleq	r7, ip, r0
     ba4:	65722200 	ldrbvs	r2, [r2, #-512]!	; 0xfffffe00
     ba8:	9a010071 	bls	40d74 <__bss_end+0x37f7c>
     bac:	0003ab20 	andeq	sl, r3, r0, lsr #22
     bb0:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     bb4:	000a7a1e 	andeq	r7, sl, lr, lsl sl
     bb8:	0e9b0100 	fmleqe	f0, f3, f0
     bbc:	0000004d 	andeq	r0, r0, sp, asr #32
     bc0:	00709102 	rsbseq	r9, r0, r2, lsl #2
     bc4:	000b5723 	andeq	r5, fp, r3, lsr #14
     bc8:	068f0100 	streq	r0, [pc], r0, lsl #2
     bcc:	0000061e 	andeq	r0, r0, lr, lsl r6
     bd0:	00008580 	andeq	r8, r0, r0, lsl #11
     bd4:	0000003c 	andeq	r0, r0, ip, lsr r0
     bd8:	07b99c01 	ldreq	r9, [r9, r1, lsl #24]!
     bdc:	3e200000 	cdpcc	0, 2, cr0, cr0, cr0, {0}
     be0:	01000008 	tsteq	r0, r8
     be4:	004d218f 	subeq	r2, sp, pc, lsl #3
     be8:	91020000 	mrsls	r0, (UNDEF: 2)
     bec:	6572226c 	ldrbvs	r2, [r2, #-620]!	; 0xfffffd94
     bf0:	91010071 	tstls	r1, r1, ror r0
     bf4:	0003ab20 	andeq	sl, r3, r0, lsr #22
     bf8:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     bfc:	0ab42100 	beq	fed09004 <__bss_end+0xfed0020c>
     c00:	83010000 	movwhi	r0, #4096	; 0x1000
     c04:	0008bb0a 	andeq	fp, r8, sl, lsl #22
     c08:	00004d00 	andeq	r4, r0, r0, lsl #26
     c0c:	00854400 	addeq	r4, r5, r0, lsl #8
     c10:	00003c00 	andeq	r3, r0, r0, lsl #24
     c14:	f69c0100 			; <UNDEFINED> instruction: 0xf69c0100
     c18:	22000007 	andcs	r0, r0, #7
     c1c:	00716572 	rsbseq	r6, r1, r2, ror r5
     c20:	87208501 	strhi	r8, [r0, -r1, lsl #10]!
     c24:	02000003 	andeq	r0, r0, #3
     c28:	5f1e7491 	svcpl	0x001e7491
     c2c:	01000005 	tsteq	r0, r5
     c30:	004d0e86 	subeq	r0, sp, r6, lsl #29
     c34:	91020000 	mrsls	r0, (UNDEF: 2)
     c38:	75210070 	strvc	r0, [r1, #-112]!	; 0xffffff90
     c3c:	0100000e 	tsteq	r0, lr
     c40:	08590a77 	ldmdaeq	r9, {r0, r1, r2, r4, r5, r6, r9, fp}^
     c44:	004d0000 	subeq	r0, sp, r0
     c48:	85080000 	strhi	r0, [r8, #-0]
     c4c:	003c0000 	eorseq	r0, ip, r0
     c50:	9c010000 	stcls	0, cr0, [r1], {-0}
     c54:	00000833 	andeq	r0, r0, r3, lsr r8
     c58:	71657222 	cmnvc	r5, r2, lsr #4
     c5c:	20790100 	rsbscs	r0, r9, r0, lsl #2
     c60:	00000387 	andeq	r0, r0, r7, lsl #7
     c64:	1e749102 	expnes	f1, f2
     c68:	0000055f 	andeq	r0, r0, pc, asr r5
     c6c:	4d0e7a01 	vstrmi	s14, [lr, #-4]
     c70:	02000000 	andeq	r0, r0, #0
     c74:	21007091 	swpcs	r7, r1, [r0]
     c78:	000008e2 	andeq	r0, r0, r2, ror #17
     c7c:	ee066b01 	vmla.f64	d6, d6, d1
     c80:	f000000b 			; <UNDEFINED> instruction: 0xf000000b
     c84:	b4000001 	strlt	r0, [r0], #-1
     c88:	54000084 	strpl	r0, [r0], #-132	; 0xffffff7c
     c8c:	01000000 	mrseq	r0, (UNDEF: 0)
     c90:	00087f9c 	muleq	r8, ip, pc	; <UNPREDICTABLE>
     c94:	0a7a2000 	beq	1e88c9c <__bss_end+0x1e7fea4>
     c98:	6b010000 	blvs	40ca0 <__bss_end+0x37ea8>
     c9c:	00004d15 	andeq	r4, r0, r5, lsl sp
     ca0:	6c910200 	lfmvs	f0, 4, [r1], {0}
     ca4:	0007be20 	andeq	fp, r7, r0, lsr #28
     ca8:	256b0100 	strbcs	r0, [fp, #-256]!	; 0xffffff00
     cac:	0000004d 	andeq	r0, r0, sp, asr #32
     cb0:	1e689102 	lgnnee	f1, f2
     cb4:	00000e6d 	andeq	r0, r0, sp, ror #28
     cb8:	4d0e6d01 	stcmi	13, cr6, [lr, #-4]
     cbc:	02000000 	andeq	r0, r0, #0
     cc0:	21007491 			; <UNDEFINED> instruction: 0x21007491
     cc4:	00000635 	andeq	r0, r0, r5, lsr r6
     cc8:	62125e01 	andsvs	r5, r2, #1, 28
     ccc:	8b00000c 	blhi	d04 <shift+0xd04>
     cd0:	64000000 	strvs	r0, [r0], #-0
     cd4:	50000084 	andpl	r0, r0, r4, lsl #1
     cd8:	01000000 	mrseq	r0, (UNDEF: 0)
     cdc:	0008da9c 	muleq	r8, ip, sl
     ce0:	0bf92000 	bleq	ffe48ce8 <__bss_end+0xffe3fef0>
     ce4:	5e010000 	cdppl	0, 0, cr0, cr1, cr0, {0}
     ce8:	00004d20 	andeq	r4, r0, r0, lsr #26
     cec:	6c910200 	lfmvs	f0, 4, [r1], {0}
     cf0:	000abd20 	andeq	fp, sl, r0, lsr #26
     cf4:	2f5e0100 	svccs	0x005e0100
     cf8:	0000004d 	andeq	r0, r0, sp, asr #32
     cfc:	20689102 	rsbcs	r9, r8, r2, lsl #2
     d00:	000007be 			; <UNDEFINED> instruction: 0x000007be
     d04:	4d3f5e01 	ldcmi	14, cr5, [pc, #-4]!	; d08 <shift+0xd08>
     d08:	02000000 	andeq	r0, r0, #0
     d0c:	6d1e6491 	cfldrsvs	mvf6, [lr, #-580]	; 0xfffffdbc
     d10:	0100000e 	tsteq	r0, lr
     d14:	008b1660 	addeq	r1, fp, r0, ror #12
     d18:	91020000 	mrsls	r0, (UNDEF: 2)
     d1c:	ab210074 	blge	840ef4 <__bss_end+0x8380fc>
     d20:	0100000c 	tsteq	r0, ip
     d24:	06400a52 			; <UNDEFINED> instruction: 0x06400a52
     d28:	004d0000 	subeq	r0, sp, r0
     d2c:	84200000 	strthi	r0, [r0], #-0
     d30:	00440000 	subeq	r0, r4, r0
     d34:	9c010000 	stcls	0, cr0, [r1], {-0}
     d38:	00000926 	andeq	r0, r0, r6, lsr #18
     d3c:	000bf920 	andeq	pc, fp, r0, lsr #18
     d40:	1a520100 	bne	1481148 <__bss_end+0x1478350>
     d44:	0000004d 	andeq	r0, r0, sp, asr #32
     d48:	206c9102 	rsbcs	r9, ip, r2, lsl #2
     d4c:	00000abd 			; <UNDEFINED> instruction: 0x00000abd
     d50:	4d295201 	sfmmi	f5, 4, [r9, #-4]!
     d54:	02000000 	andeq	r0, r0, #0
     d58:	911e6891 			; <UNDEFINED> instruction: 0x911e6891
     d5c:	0100000c 	tsteq	r0, ip
     d60:	004d0e54 	subeq	r0, sp, r4, asr lr
     d64:	91020000 	mrsls	r0, (UNDEF: 2)
     d68:	8b210074 	blhi	840f40 <__bss_end+0x838148>
     d6c:	0100000c 	tsteq	r0, ip
     d70:	0c6d0a45 			; <UNDEFINED> instruction: 0x0c6d0a45
     d74:	004d0000 	subeq	r0, sp, r0
     d78:	83d00000 	bicshi	r0, r0, #0
     d7c:	00500000 	subseq	r0, r0, r0
     d80:	9c010000 	stcls	0, cr0, [r1], {-0}
     d84:	00000981 	andeq	r0, r0, r1, lsl #19
     d88:	000bf920 	andeq	pc, fp, r0, lsr #18
     d8c:	19450100 	stmdbne	r5, {r8}^
     d90:	0000004d 	andeq	r0, r0, sp, asr #32
     d94:	206c9102 	rsbcs	r9, ip, r2, lsl #2
     d98:	00000934 	andeq	r0, r0, r4, lsr r9
     d9c:	1d304501 	cfldr32ne	mvfx4, [r0, #-4]!
     da0:	02000001 	andeq	r0, r0, #1
     da4:	ca206891 	bgt	81aff0 <__bss_end+0x8121f8>
     da8:	0100000a 	tsteq	r0, sl
     dac:	06ac4145 	strteq	r4, [ip], r5, asr #2
     db0:	91020000 	mrsls	r0, (UNDEF: 2)
     db4:	0e6d1e64 	cdpeq	14, 6, cr1, cr13, cr4, {3}
     db8:	47010000 	strmi	r0, [r1, -r0]
     dbc:	00004d0e 	andeq	r4, r0, lr, lsl #26
     dc0:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     dc4:	05342300 	ldreq	r2, [r4, #-768]!	; 0xfffffd00
     dc8:	3f010000 	svccc	0x00010000
     dcc:	00093e06 	andeq	r3, r9, r6, lsl #28
     dd0:	0083a400 	addeq	sl, r3, r0, lsl #8
     dd4:	00002c00 	andeq	r2, r0, r0, lsl #24
     dd8:	ab9c0100 	blge	fe7011e0 <__bss_end+0xfe6f83e8>
     ddc:	20000009 	andcs	r0, r0, r9
     de0:	00000bf9 	strdeq	r0, [r0], -r9
     de4:	4d153f01 	ldcmi	15, cr3, [r5, #-4]
     de8:	02000000 	andeq	r0, r0, #0
     dec:	21007491 			; <UNDEFINED> instruction: 0x21007491
     df0:	00000a54 	andeq	r0, r0, r4, asr sl
     df4:	d00a3201 	andle	r3, sl, r1, lsl #4
     df8:	4d00000a 	stcmi	0, cr0, [r0, #-40]	; 0xffffffd8
     dfc:	54000000 	strpl	r0, [r0], #-0
     e00:	50000083 	andpl	r0, r0, r3, lsl #1
     e04:	01000000 	mrseq	r0, (UNDEF: 0)
     e08:	000a069c 	muleq	sl, ip, r6
     e0c:	0bf92000 	bleq	ffe48e14 <__bss_end+0xffe4001c>
     e10:	32010000 	andcc	r0, r1, #0
     e14:	00004d19 	andeq	r4, r0, r9, lsl sp
     e18:	6c910200 	lfmvs	f0, 4, [r1], {0}
     e1c:	000cd720 	andeq	sp, ip, r0, lsr #14
     e20:	2b320100 	blcs	c81228 <__bss_end+0xc78430>
     e24:	000001f7 	strdeq	r0, [r0], -r7
     e28:	20689102 	rsbcs	r9, r8, r2, lsl #2
     e2c:	00000afd 	strdeq	r0, [r0], -sp
     e30:	4d3c3201 	lfmmi	f3, 4, [ip, #-4]!
     e34:	02000000 	andeq	r0, r0, #0
     e38:	5c1e6491 	cfldrspl	mvf6, [lr], {145}	; 0x91
     e3c:	0100000c 	tsteq	r0, ip
     e40:	004d0e34 	subeq	r0, sp, r4, lsr lr
     e44:	91020000 	mrsls	r0, (UNDEF: 2)
     e48:	ad210074 	stcge	0, cr0, [r1, #-464]!	; 0xfffffe30
     e4c:	0100000e 	tsteq	r0, lr
     e50:	0d570a25 	vldreq	s1, [r7, #-148]	; 0xffffff6c
     e54:	004d0000 	subeq	r0, sp, r0
     e58:	83040000 	movwhi	r0, #16384	; 0x4000
     e5c:	00500000 	subseq	r0, r0, r0
     e60:	9c010000 	stcls	0, cr0, [r1], {-0}
     e64:	00000a61 	andeq	r0, r0, r1, ror #20
     e68:	000bf920 	andeq	pc, fp, r0, lsr #18
     e6c:	18250100 	stmdane	r5!, {r8}
     e70:	0000004d 	andeq	r0, r0, sp, asr #32
     e74:	206c9102 	rsbcs	r9, ip, r2, lsl #2
     e78:	00000cd7 	ldrdeq	r0, [r0], -r7
     e7c:	672a2501 	strvs	r2, [sl, -r1, lsl #10]!
     e80:	0200000a 	andeq	r0, r0, #10
     e84:	fd206891 	stc2	8, cr6, [r0, #-580]!	; 0xfffffdbc
     e88:	0100000a 	tsteq	r0, sl
     e8c:	004d3b25 	subeq	r3, sp, r5, lsr #22
     e90:	91020000 	mrsls	r0, (UNDEF: 2)
     e94:	05b11e64 	ldreq	r1, [r1, #3684]!	; 0xe64
     e98:	27010000 	strcs	r0, [r1, -r0]
     e9c:	00004d0e 	andeq	r4, r0, lr, lsl #26
     ea0:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     ea4:	25040d00 	strcs	r0, [r4, #-3328]	; 0xfffff300
     ea8:	03000000 	movweq	r0, #0
     eac:	00000a61 	andeq	r0, r0, r1, ror #20
     eb0:	000a8e21 	andeq	r8, sl, r1, lsr #28
     eb4:	0a190100 	beq	6412bc <__bss_end+0x6384c4>
     eb8:	00000ebf 			; <UNDEFINED> instruction: 0x00000ebf
     ebc:	0000004d 	andeq	r0, r0, sp, asr #32
     ec0:	000082c0 	andeq	r8, r0, r0, asr #5
     ec4:	00000044 	andeq	r0, r0, r4, asr #32
     ec8:	0ab89c01 	beq	fee27ed4 <__bss_end+0xfee1f0dc>
     ecc:	8e200000 	cdphi	0, 2, cr0, cr0, cr0, {0}
     ed0:	0100000e 	tsteq	r0, lr
     ed4:	01f71b19 	mvnseq	r1, r9, lsl fp
     ed8:	91020000 	mrsls	r0, (UNDEF: 2)
     edc:	0cbc206c 	ldceq	0, cr2, [ip], #432	; 0x1b0
     ee0:	19010000 	stmdbne	r1, {}	; <UNPREDICTABLE>
     ee4:	0001c635 	andeq	ip, r1, r5, lsr r6
     ee8:	68910200 	ldmvs	r1, {r9}
     eec:	000bf91e 	andeq	pc, fp, lr, lsl r9	; <UNPREDICTABLE>
     ef0:	0e1b0100 	mufeqe	f0, f3, f0
     ef4:	0000004d 	andeq	r0, r0, sp, asr #32
     ef8:	00749102 	rsbseq	r9, r4, r2, lsl #2
     efc:	00083224 	andeq	r3, r8, r4, lsr #4
     f00:	06140100 	ldreq	r0, [r4], -r0, lsl #2
     f04:	000005cf 	andeq	r0, r0, pc, asr #11
     f08:	000082a4 	andeq	r8, r0, r4, lsr #5
     f0c:	0000001c 	andeq	r0, r0, ip, lsl r0
     f10:	b2239c01 	eorlt	r9, r3, #256	; 0x100
     f14:	0100000c 	tsteq	r0, ip
     f18:	0912060e 	ldmdbeq	r2, {r1, r2, r3, r9, sl}
     f1c:	82780000 	rsbshi	r0, r8, #0
     f20:	002c0000 	eoreq	r0, ip, r0
     f24:	9c010000 	stcls	0, cr0, [r1], {-0}
     f28:	00000af8 	strdeq	r0, [r0], -r8
     f2c:	00077f20 	andeq	r7, r7, r0, lsr #30
     f30:	140e0100 	strne	r0, [lr], #-256	; 0xffffff00
     f34:	00000038 	andeq	r0, r0, r8, lsr r0
     f38:	00749102 	rsbseq	r9, r4, r2, lsl #2
     f3c:	000eb825 	andeq	fp, lr, r5, lsr #16
     f40:	0a040100 	beq	101348 <__bss_end+0xf8550>
     f44:	0000096f 	andeq	r0, r0, pc, ror #18
     f48:	0000004d 	andeq	r0, r0, sp, asr #32
     f4c:	0000824c 	andeq	r8, r0, ip, asr #4
     f50:	0000002c 	andeq	r0, r0, ip, lsr #32
     f54:	70229c01 	eorvc	r9, r2, r1, lsl #24
     f58:	01006469 	tsteq	r0, r9, ror #8
     f5c:	004d0e06 	subeq	r0, sp, r6, lsl #28
     f60:	91020000 	mrsls	r0, (UNDEF: 2)
     f64:	2e000074 	mcrcs	0, 0, r0, cr0, cr4, {3}
     f68:	04000003 	streq	r0, [r0], #-3
     f6c:	0004b800 	andeq	fp, r4, r0, lsl #16
     f70:	a3010400 	movwge	r0, #5120	; 0x1400
     f74:	04000009 	streq	r0, [r0], #-9
     f78:	00000fd5 	ldrdeq	r0, [r0], -r5
     f7c:	00000b0d 	andeq	r0, r0, sp, lsl #22
     f80:	000086a8 	andeq	r8, r0, r8, lsr #13
     f84:	000004b8 			; <UNDEFINED> instruction: 0x000004b8
     f88:	00000686 	andeq	r0, r0, r6, lsl #13
     f8c:	00004902 	andeq	r4, r0, r2, lsl #18
     f90:	0f4d0300 	svceq	0x004d0300
     f94:	05010000 	streq	r0, [r1, #-0]
     f98:	00006110 	andeq	r6, r0, r0, lsl r1
     f9c:	31301100 	teqcc	r0, r0, lsl #2
     fa0:	35343332 	ldrcc	r3, [r4, #-818]!	; 0xfffffcce
     fa4:	39383736 	ldmdbcc	r8!, {r1, r2, r4, r5, r8, r9, sl, ip, sp}
     fa8:	44434241 	strbmi	r4, [r3], #-577	; 0xfffffdbf
     fac:	00004645 	andeq	r4, r0, r5, asr #12
     fb0:	01030104 	tsteq	r3, r4, lsl #2
     fb4:	00000025 	andeq	r0, r0, r5, lsr #32
     fb8:	00007405 	andeq	r7, r0, r5, lsl #8
     fbc:	00006100 	andeq	r6, r0, r0, lsl #2
     fc0:	00660600 	rsbeq	r0, r6, r0, lsl #12
     fc4:	00100000 	andseq	r0, r0, r0
     fc8:	00005107 	andeq	r5, r0, r7, lsl #2
     fcc:	07040800 	streq	r0, [r4, -r0, lsl #16]
     fd0:	000013f5 	strdeq	r1, [r0], -r5
     fd4:	7a080108 	bvc	2013fc <__bss_end+0x1f8604>
     fd8:	07000004 	streq	r0, [r0, -r4]
     fdc:	0000006d 	andeq	r0, r0, sp, rrx
     fe0:	00002a09 	andeq	r2, r0, r9, lsl #20
     fe4:	0f770a00 	svceq	0x00770a00
     fe8:	64010000 	strvs	r0, [r1], #-0
     fec:	000f6706 	andeq	r6, pc, r6, lsl #14
     ff0:	008ae000 	addeq	lr, sl, r0
     ff4:	00008000 	andeq	r8, r0, r0
     ff8:	fb9c0100 	blx	fe701402 <__bss_end+0xfe6f860a>
     ffc:	0b000000 	bleq	1004 <shift+0x1004>
    1000:	00637273 	rsbeq	r7, r3, r3, ror r2
    1004:	fb196401 	blx	65a012 <__bss_end+0x65121a>
    1008:	02000000 	andeq	r0, r0, #0
    100c:	640b6491 	strvs	r6, [fp], #-1169	; 0xfffffb6f
    1010:	01007473 	tsteq	r0, r3, ror r4
    1014:	01022464 	tsteq	r2, r4, ror #8
    1018:	91020000 	mrsls	r0, (UNDEF: 2)
    101c:	756e0b60 	strbvc	r0, [lr, #-2912]!	; 0xfffff4a0
    1020:	6401006d 	strvs	r0, [r1], #-109	; 0xffffff93
    1024:	0001042d 	andeq	r0, r1, sp, lsr #8
    1028:	5c910200 	lfmpl	f0, 4, [r1], {0}
    102c:	000fc90c 	andeq	ip, pc, ip, lsl #18
    1030:	0e660100 	poweqs	f0, f6, f0
    1034:	0000010b 	andeq	r0, r0, fp, lsl #2
    1038:	0c709102 	ldfeqp	f1, [r0], #-8
    103c:	00000f59 	andeq	r0, r0, r9, asr pc
    1040:	11086701 	tstne	r8, r1, lsl #14
    1044:	02000001 	andeq	r0, r0, #1
    1048:	080d6c91 	stmdaeq	sp, {r0, r4, r7, sl, fp, sp, lr}
    104c:	4800008b 	stmdami	r0, {r0, r1, r3, r7}
    1050:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    1054:	69010069 	stmdbvs	r1, {r0, r3, r5, r6}
    1058:	0001040b 	andeq	r0, r1, fp, lsl #8
    105c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1060:	040f0000 	streq	r0, [pc], #-0	; 1068 <shift+0x1068>
    1064:	00000101 	andeq	r0, r0, r1, lsl #2
    1068:	12041110 	andne	r1, r4, #16, 2
    106c:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
    1070:	040f0074 	streq	r0, [pc], #-116	; 1078 <shift+0x1078>
    1074:	00000074 	andeq	r0, r0, r4, ror r0
    1078:	006d040f 	rsbeq	r0, sp, pc, lsl #8
    107c:	210a0000 	mrscs	r0, (UNDEF: 10)
    1080:	0100000f 	tsteq	r0, pc
    1084:	0f2e065c 	svceq	0x002e065c
    1088:	8a780000 	bhi	1e01090 <__bss_end+0x1df8298>
    108c:	00680000 	rsbeq	r0, r8, r0
    1090:	9c010000 	stcls	0, cr0, [r1], {-0}
    1094:	00000176 	andeq	r0, r0, r6, ror r1
    1098:	000fc213 	andeq	ip, pc, r3, lsl r2	; <UNPREDICTABLE>
    109c:	125c0100 	subsne	r0, ip, #0, 2
    10a0:	00000102 	andeq	r0, r0, r2, lsl #2
    10a4:	136c9102 	cmnne	ip, #-2147483648	; 0x80000000
    10a8:	00000f27 	andeq	r0, r0, r7, lsr #30
    10ac:	041e5c01 	ldreq	r5, [lr], #-3073	; 0xfffff3ff
    10b0:	02000001 	andeq	r0, r0, #1
    10b4:	6d0e6891 	stcvs	8, cr6, [lr, #-580]	; 0xfffffdbc
    10b8:	01006d65 	tsteq	r0, r5, ror #26
    10bc:	0111085e 	tsteq	r1, lr, asr r8
    10c0:	91020000 	mrsls	r0, (UNDEF: 2)
    10c4:	8a940d70 	bhi	fe50468c <__bss_end+0xfe4fb894>
    10c8:	003c0000 	eorseq	r0, ip, r0
    10cc:	690e0000 	stmdbvs	lr, {}	; <UNPREDICTABLE>
    10d0:	0b600100 	bleq	18014d8 <__bss_end+0x17f86e0>
    10d4:	00000104 	andeq	r0, r0, r4, lsl #2
    10d8:	00749102 	rsbseq	r9, r4, r2, lsl #2
    10dc:	0f7e1400 	svceq	0x007e1400
    10e0:	52010000 	andpl	r0, r1, #0
    10e4:	000f9705 	andeq	r9, pc, r5, lsl #14
    10e8:	00010400 	andeq	r0, r1, r0, lsl #8
    10ec:	008a2400 	addeq	r2, sl, r0, lsl #8
    10f0:	00005400 	andeq	r5, r0, r0, lsl #8
    10f4:	af9c0100 	svcge	0x009c0100
    10f8:	0b000001 	bleq	1104 <shift+0x1104>
    10fc:	52010073 	andpl	r0, r1, #115	; 0x73
    1100:	00010b18 	andeq	r0, r1, r8, lsl fp
    1104:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1108:	0100690e 	tsteq	r0, lr, lsl #18
    110c:	01040654 	tsteq	r4, r4, asr r6
    1110:	91020000 	mrsls	r0, (UNDEF: 2)
    1114:	ba140074 	blt	5012ec <__bss_end+0x4f84f4>
    1118:	0100000f 	tsteq	r0, pc
    111c:	0f850542 	svceq	0x00850542
    1120:	01040000 	mrseq	r0, (UNDEF: 4)
    1124:	89780000 	ldmdbhi	r8!, {}^	; <UNPREDICTABLE>
    1128:	00ac0000 	adceq	r0, ip, r0
    112c:	9c010000 	stcls	0, cr0, [r1], {-0}
    1130:	00000215 	andeq	r0, r0, r5, lsl r2
    1134:	0031730b 	eorseq	r7, r1, fp, lsl #6
    1138:	0b194201 	bleq	651944 <__bss_end+0x648b4c>
    113c:	02000001 	andeq	r0, r0, #1
    1140:	730b6c91 	movwvc	r6, #48273	; 0xbc91
    1144:	42010032 	andmi	r0, r1, #50	; 0x32
    1148:	00010b29 	andeq	r0, r1, r9, lsr #22
    114c:	68910200 	ldmvs	r1, {r9}
    1150:	6d756e0b 	ldclvs	14, cr6, [r5, #-44]!	; 0xffffffd4
    1154:	31420100 	mrscc	r0, (UNDEF: 82)
    1158:	00000104 	andeq	r0, r0, r4, lsl #2
    115c:	0e649102 	lgneqs	f1, f2
    1160:	01003175 	tsteq	r0, r5, ror r1
    1164:	02151044 	andseq	r1, r5, #68	; 0x44
    1168:	91020000 	mrsls	r0, (UNDEF: 2)
    116c:	32750e77 	rsbscc	r0, r5, #1904	; 0x770
    1170:	14440100 	strbne	r0, [r4], #-256	; 0xffffff00
    1174:	00000215 	andeq	r0, r0, r5, lsl r2
    1178:	00769102 	rsbseq	r9, r6, r2, lsl #2
    117c:	71080108 	tstvc	r8, r8, lsl #2
    1180:	14000004 	strne	r0, [r0], #-4
    1184:	00000f3a 	andeq	r0, r0, sl, lsr pc
    1188:	a9073601 	stmdbge	r7, {r0, r9, sl, ip, sp}
    118c:	1100000f 	tstne	r0, pc
    1190:	b8000001 	stmdalt	r0, {r0}
    1194:	c0000088 	andgt	r0, r0, r8, lsl #1
    1198:	01000000 	mrseq	r0, (UNDEF: 0)
    119c:	0002759c 	muleq	r2, ip, r5
    11a0:	0f1c1300 	svceq	0x001c1300
    11a4:	36010000 	strcc	r0, [r1], -r0
    11a8:	00011115 	andeq	r1, r1, r5, lsl r1
    11ac:	6c910200 	lfmvs	f0, 4, [r1], {0}
    11b0:	6372730b 	cmnvs	r2, #738197504	; 0x2c000000
    11b4:	27360100 	ldrcs	r0, [r6, -r0, lsl #2]!
    11b8:	0000010b 	andeq	r0, r0, fp, lsl #2
    11bc:	0b689102 	bleq	1a255cc <__bss_end+0x1a1c7d4>
    11c0:	006d756e 	rsbeq	r7, sp, lr, ror #10
    11c4:	04303601 	ldrteq	r3, [r0], #-1537	; 0xfffff9ff
    11c8:	02000001 	andeq	r0, r0, #1
    11cc:	690e6491 	stmdbvs	lr, {r0, r4, r7, sl, sp, lr}
    11d0:	06380100 	ldrteq	r0, [r8], -r0, lsl #2
    11d4:	00000104 	andeq	r0, r0, r4, lsl #2
    11d8:	00749102 	rsbseq	r9, r4, r2, lsl #2
    11dc:	000fa414 	andeq	sl, pc, r4, lsl r4	; <UNPREDICTABLE>
    11e0:	05240100 	streq	r0, [r4, #-256]!	; 0xffffff00
    11e4:	00000f42 	andeq	r0, r0, r2, asr #30
    11e8:	00000104 	andeq	r0, r0, r4, lsl #2
    11ec:	0000881c 	andeq	r8, r0, ip, lsl r8
    11f0:	0000009c 	muleq	r0, ip, r0
    11f4:	02b29c01 	adcseq	r9, r2, #256	; 0x100
    11f8:	16130000 	ldrne	r0, [r3], -r0
    11fc:	0100000f 	tsteq	r0, pc
    1200:	010b1624 	tsteq	fp, r4, lsr #12
    1204:	91020000 	mrsls	r0, (UNDEF: 2)
    1208:	0f600c6c 	svceq	0x00600c6c
    120c:	26010000 	strcs	r0, [r1], -r0
    1210:	00010406 	andeq	r0, r1, r6, lsl #8
    1214:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1218:	0fd01500 	svceq	0x00d01500
    121c:	08010000 	stmdaeq	r1, {}	; <UNPREDICTABLE>
    1220:	00102306 	andseq	r2, r0, r6, lsl #6
    1224:	0086a800 	addeq	sl, r6, r0, lsl #16
    1228:	00017400 	andeq	r7, r1, r0, lsl #8
    122c:	139c0100 	orrsne	r0, ip, #0, 2
    1230:	00000f16 	andeq	r0, r0, r6, lsl pc
    1234:	66180801 	ldrvs	r0, [r8], -r1, lsl #16
    1238:	02000000 	andeq	r0, r0, #0
    123c:	60136491 	mulsvs	r3, r1, r4
    1240:	0100000f 	tsteq	r0, pc
    1244:	01112508 	tsteq	r1, r8, lsl #10
    1248:	91020000 	mrsls	r0, (UNDEF: 2)
    124c:	10ef1360 	rscne	r1, pc, r0, ror #6
    1250:	08010000 	stmdaeq	r1, {}	; <UNPREDICTABLE>
    1254:	0000663a 	andeq	r6, r0, sl, lsr r6
    1258:	5c910200 	lfmpl	f0, 4, [r1], {0}
    125c:	0100690e 	tsteq	r0, lr, lsl #18
    1260:	0104060a 	tsteq	r4, sl, lsl #12
    1264:	91020000 	mrsls	r0, (UNDEF: 2)
    1268:	87740d74 			; <UNDEFINED> instruction: 0x87740d74
    126c:	00980000 	addseq	r0, r8, r0
    1270:	6a0e0000 	bvs	381278 <__bss_end+0x378480>
    1274:	0b1c0100 	bleq	70167c <__bss_end+0x6f8884>
    1278:	00000104 	andeq	r0, r0, r4, lsl #2
    127c:	0d709102 	ldfeqp	f1, [r0, #-8]!
    1280:	0000879c 	muleq	r0, ip, r7
    1284:	00000060 	andeq	r0, r0, r0, rrx
    1288:	0100630e 	tsteq	r0, lr, lsl #6
    128c:	006d081e 	rsbeq	r0, sp, lr, lsl r8
    1290:	91020000 	mrsls	r0, (UNDEF: 2)
    1294:	0000006f 	andeq	r0, r0, pc, rrx
    1298:	00002200 	andeq	r2, r0, r0, lsl #4
    129c:	df000200 	svcle	0x00000200
    12a0:	04000005 	streq	r0, [r0], #-5
    12a4:	00091501 	andeq	r1, r9, r1, lsl #10
    12a8:	008b6000 	addeq	r6, fp, r0
    12ac:	008d6c00 	addeq	r6, sp, r0, lsl #24
    12b0:	00102f00 	andseq	r2, r0, r0, lsl #30
    12b4:	00105f00 	andseq	r5, r0, r0, lsl #30
    12b8:	0010c700 	andseq	ip, r0, r0, lsl #14
    12bc:	22800100 	addcs	r0, r0, #0, 2
    12c0:	02000000 	andeq	r0, r0, #0
    12c4:	0005f300 	andeq	pc, r5, r0, lsl #6
    12c8:	92010400 	andls	r0, r1, #0, 8
    12cc:	6c000009 	stcvs	0, cr0, [r0], {9}
    12d0:	7000008d 	andvc	r0, r0, sp, lsl #1
    12d4:	2f00008d 	svccs	0x0000008d
    12d8:	5f000010 	svcpl	0x00000010
    12dc:	c7000010 	smladgt	r0, r0, r0, r0
    12e0:	01000010 	tsteq	r0, r0, lsl r0
    12e4:	00032a80 	andeq	r2, r3, r0, lsl #21
    12e8:	07000400 	streq	r0, [r0, -r0, lsl #8]
    12ec:	04000006 	streq	r0, [r0], #-6
    12f0:	0011f301 	andseq	pc, r1, r1, lsl #6
    12f4:	13ac0c00 			; <UNDEFINED> instruction: 0x13ac0c00
    12f8:	105f0000 	subsne	r0, pc, r0
    12fc:	09f20000 	ldmibeq	r2!, {}^	; <UNPREDICTABLE>
    1300:	04020000 	streq	r0, [r2], #-0
    1304:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
    1308:	07040300 	streq	r0, [r4, -r0, lsl #6]
    130c:	000013f5 	strdeq	r1, [r0], -r5
    1310:	b9050803 	stmdblt	r5, {r0, r1, fp}
    1314:	03000002 	movweq	r0, #2
    1318:	13a00408 	movne	r0, #8, 8	; 0x8000000
    131c:	01030000 	mrseq	r0, (UNDEF: 3)
    1320:	00047108 	andeq	r7, r4, r8, lsl #2
    1324:	06010300 	streq	r0, [r1], -r0, lsl #6
    1328:	00000473 	andeq	r0, r0, r3, ror r4
    132c:	00157804 	andseq	r7, r5, r4, lsl #16
    1330:	39010700 	stmdbcc	r1, {r8, r9, sl}
    1334:	01000000 	mrseq	r0, (UNDEF: 0)
    1338:	01d40617 	bicseq	r0, r4, r7, lsl r6
    133c:	02050000 	andeq	r0, r5, #0
    1340:	00000011 	andeq	r0, r0, r1, lsl r0
    1344:	00162705 	andseq	r2, r6, r5, lsl #14
    1348:	d5050100 	strle	r0, [r5, #-256]	; 0xffffff00
    134c:	02000012 	andeq	r0, r0, #18
    1350:	00139305 	andseq	r9, r3, r5, lsl #6
    1354:	91050300 	mrsls	r0, SP_abt
    1358:	04000015 	streq	r0, [r0], #-21	; 0xffffffeb
    135c:	00163705 	andseq	r3, r6, r5, lsl #14
    1360:	a7050500 	strge	r0, [r5, -r0, lsl #10]
    1364:	06000015 			; <UNDEFINED> instruction: 0x06000015
    1368:	0013dc05 	andseq	sp, r3, r5, lsl #24
    136c:	22050700 	andcs	r0, r5, #0, 14
    1370:	08000015 	stmdaeq	r0, {r0, r2, r4}
    1374:	00153005 	andseq	r3, r5, r5
    1378:	3e050900 	vmlacc.f16	s0, s10, s0	; <UNPREDICTABLE>
    137c:	0a000015 	beq	13d8 <shift+0x13d8>
    1380:	00144505 	andseq	r4, r4, r5, lsl #10
    1384:	35050b00 	strcc	r0, [r5, #-2816]	; 0xfffff500
    1388:	0c000014 	stceq	0, cr0, [r0], {20}
    138c:	00111e05 	andseq	r1, r1, r5, lsl #28
    1390:	37050d00 	strcc	r0, [r5, -r0, lsl #26]
    1394:	0e000011 	mcreq	0, 0, r0, cr0, cr1, {0}
    1398:	00142605 	andseq	r2, r4, r5, lsl #12
    139c:	ea050f00 	b	144fa4 <__bss_end+0x13c1ac>
    13a0:	10000015 	andne	r0, r0, r5, lsl r0
    13a4:	00156705 	andseq	r6, r5, r5, lsl #14
    13a8:	db051100 	blle	1457b0 <__bss_end+0x13c9b8>
    13ac:	12000015 	andne	r0, r0, #21
    13b0:	0011e405 	andseq	lr, r1, r5, lsl #8
    13b4:	61051300 	mrsvs	r1, SP_abt
    13b8:	14000011 	strne	r0, [r0], #-17	; 0xffffffef
    13bc:	00112b05 	andseq	r2, r1, r5, lsl #22
    13c0:	c4051500 	strgt	r1, [r5], #-1280	; 0xfffffb00
    13c4:	16000014 			; <UNDEFINED> instruction: 0x16000014
    13c8:	00119805 	andseq	r9, r1, r5, lsl #16
    13cc:	d3051700 	movwle	r1, #22272	; 0x5700
    13d0:	18000010 	stmdane	r0, {r4}
    13d4:	0015cd05 	andseq	ip, r5, r5, lsl #26
    13d8:	02051900 	andeq	r1, r5, #0, 18
    13dc:	1a000014 	bne	1434 <shift+0x1434>
    13e0:	0014dc05 	andseq	sp, r4, r5, lsl #24
    13e4:	6c051b00 			; <UNDEFINED> instruction: 0x6c051b00
    13e8:	1c000011 	stcne	0, cr0, [r0], {17}
    13ec:	00137805 	andseq	r7, r3, r5, lsl #16
    13f0:	c7051d00 	strgt	r1, [r5, -r0, lsl #26]
    13f4:	1e000012 	mcrne	0, 0, r0, cr0, cr2, {0}
    13f8:	00155905 	andseq	r5, r5, r5, lsl #18
    13fc:	b5051f00 	strlt	r1, [r5, #-3840]	; 0xfffff100
    1400:	20000015 	andcs	r0, r0, r5, lsl r0
    1404:	0015f605 	andseq	pc, r5, r5, lsl #12
    1408:	04052100 	streq	r2, [r5], #-256	; 0xffffff00
    140c:	22000016 	andcs	r0, r0, #22
    1410:	00141905 	andseq	r1, r4, r5, lsl #18
    1414:	3c052300 	stccc	3, cr2, [r5], {-0}
    1418:	24000013 	strcs	r0, [r0], #-19	; 0xffffffed
    141c:	00117b05 	andseq	r7, r1, r5, lsl #22
    1420:	cf052500 	svcgt	0x00052500
    1424:	26000013 			; <UNDEFINED> instruction: 0x26000013
    1428:	0012e105 	andseq	lr, r2, r5, lsl #2
    142c:	84052700 	strhi	r2, [r5], #-1792	; 0xfffff900
    1430:	28000015 	stmdacs	r0, {r0, r2, r4}
    1434:	0012f105 	andseq	pc, r2, r5, lsl #2
    1438:	00052900 	andeq	r2, r5, r0, lsl #18
    143c:	2a000013 	bcs	1490 <shift+0x1490>
    1440:	00130f05 	andseq	r0, r3, r5, lsl #30
    1444:	1e052b00 	vmlane.f64	d2, d5, d0
    1448:	2c000013 	stccs	0, cr0, [r0], {19}
    144c:	0012ac05 	andseq	sl, r2, r5, lsl #24
    1450:	2d052d00 	stccs	13, cr2, [r5, #-0]
    1454:	2e000013 	mcrcs	0, 0, r0, cr0, cr3, {0}
    1458:	00151305 	andseq	r1, r5, r5, lsl #6
    145c:	4b052f00 	blmi	14d064 <__bss_end+0x14426c>
    1460:	30000013 	andcc	r0, r0, r3, lsl r0
    1464:	00135a05 	andseq	r5, r3, r5, lsl #20
    1468:	0c053100 	stfeqs	f3, [r5], {-0}
    146c:	32000011 	andcc	r0, r0, #17
    1470:	00146405 	andseq	r6, r4, r5, lsl #8
    1474:	74053300 	strvc	r3, [r5], #-768	; 0xfffffd00
    1478:	34000014 	strcc	r0, [r0], #-20	; 0xffffffec
    147c:	00148405 	andseq	r8, r4, r5, lsl #8
    1480:	9a053500 	bls	14e888 <__bss_end+0x145a90>
    1484:	36000012 			; <UNDEFINED> instruction: 0x36000012
    1488:	00149405 	andseq	r9, r4, r5, lsl #8
    148c:	a4053700 	strge	r3, [r5], #-1792	; 0xfffff900
    1490:	38000014 	stmdacc	r0, {r2, r4}
    1494:	0014b405 	andseq	fp, r4, r5, lsl #8
    1498:	8b053900 	blhi	14f8a0 <__bss_end+0x146aa8>
    149c:	3a000011 	bcc	14e8 <shift+0x14e8>
    14a0:	00114405 	andseq	r4, r1, r5, lsl #8
    14a4:	69053b00 	stmdbvs	r5, {r8, r9, fp, ip, sp}
    14a8:	3c000013 	stccc	0, cr0, [r0], {19}
    14ac:	0010e305 	andseq	lr, r0, r5, lsl #6
    14b0:	cf053d00 	svcgt	0x00053d00
    14b4:	3e000014 	mcrcc	0, 0, r0, cr0, cr4, {0}
    14b8:	11cb0600 	bicne	r0, fp, r0, lsl #12
    14bc:	01020000 	mrseq	r0, (UNDEF: 2)
    14c0:	ff08026b 			; <UNDEFINED> instruction: 0xff08026b
    14c4:	07000001 	streq	r0, [r0, -r1]
    14c8:	0000138e 	andeq	r1, r0, lr, lsl #7
    14cc:	14027001 	strne	r7, [r2], #-1
    14d0:	00000047 	andeq	r0, r0, r7, asr #32
    14d4:	12a70700 	adcne	r0, r7, #0, 14
    14d8:	71010000 	mrsvc	r0, (UNDEF: 1)
    14dc:	00471402 	subeq	r1, r7, r2, lsl #8
    14e0:	00010000 	andeq	r0, r1, r0
    14e4:	0001d408 	andeq	sp, r1, r8, lsl #8
    14e8:	01ff0900 	mvnseq	r0, r0, lsl #18
    14ec:	02140000 	andseq	r0, r4, #0
    14f0:	240a0000 	strcs	r0, [sl], #-0
    14f4:	11000000 	mrsne	r0, (UNDEF: 0)
    14f8:	02040800 	andeq	r0, r4, #0, 16
    14fc:	520b0000 	andpl	r0, fp, #0
    1500:	01000014 	tsteq	r0, r4, lsl r0
    1504:	14260274 	strtne	r0, [r6], #-628	; 0xfffffd8c
    1508:	24000002 	strcs	r0, [r0], #-2
    150c:	3d0a3d3a 	stccc	13, cr3, [sl, #-232]	; 0xffffff18
    1510:	3d243d0f 	stccc	13, cr3, [r4, #-60]!	; 0xffffffc4
    1514:	3d023d32 	stccc	13, cr3, [r2, #-200]	; 0xffffff38
    1518:	3d133d05 	ldccc	13, cr3, [r3, #-20]	; 0xffffffec
    151c:	3d0c3d0d 	stccc	13, cr3, [ip, #-52]	; 0xffffffcc
    1520:	3d113d23 	ldccc	13, cr3, [r1, #-140]	; 0xffffff74
    1524:	3d013d26 	stccc	13, cr3, [r1, #-152]	; 0xffffff68
    1528:	3d083d17 	stccc	13, cr3, [r8, #-92]	; 0xffffffa4
    152c:	00003d09 	andeq	r3, r0, r9, lsl #26
    1530:	ad070203 	sfmge	f0, 4, [r7, #-12]
    1534:	03000003 	movweq	r0, #3
    1538:	047a0801 	ldrbteq	r0, [sl], #-2049	; 0xfffff7ff
    153c:	0d0c0000 	stceq	0, cr0, [ip, #-0]
    1540:	00025904 	andeq	r5, r2, r4, lsl #18
    1544:	16120e00 	ldrne	r0, [r2], -r0, lsl #28
    1548:	01070000 	mrseq	r0, (UNDEF: 7)
    154c:	00000039 	andeq	r0, r0, r9, lsr r0
    1550:	0604f702 	streq	pc, [r4], -r2, lsl #14
    1554:	0000029e 	muleq	r0, lr, r2
    1558:	0011a505 	andseq	sl, r1, r5, lsl #10
    155c:	b0050000 	andlt	r0, r5, r0
    1560:	01000011 	tsteq	r0, r1, lsl r0
    1564:	0011c205 	andseq	ip, r1, r5, lsl #4
    1568:	dc050200 	sfmle	f0, 4, [r5], {-0}
    156c:	03000011 	movweq	r0, #17
    1570:	00154c05 	andseq	r4, r5, r5, lsl #24
    1574:	bb050400 	bllt	14257c <__bss_end+0x139784>
    1578:	05000012 	streq	r0, [r0, #-18]	; 0xffffffee
    157c:	00150505 	andseq	r0, r5, r5, lsl #10
    1580:	03000600 	movweq	r0, #1536	; 0x600
    1584:	04d00502 	ldrbeq	r0, [r0], #1282	; 0x502
    1588:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    158c:	0013eb07 	andseq	lr, r3, r7, lsl #22
    1590:	04040300 	streq	r0, [r4], #-768	; 0xfffffd00
    1594:	000010fc 	strdeq	r1, [r0], -ip
    1598:	f4030803 	vst2.8	{d0-d1}, [r3], r3
    159c:	03000010 	movweq	r0, #16
    15a0:	13a50408 			; <UNDEFINED> instruction: 0x13a50408
    15a4:	10030000 	andne	r0, r3, r0
    15a8:	0014f603 	andseq	pc, r4, r3, lsl #12
    15ac:	14ed0f00 	strbtne	r0, [sp], #3840	; 0xf00
    15b0:	2a030000 	bcs	c15b8 <__bss_end+0xb87c0>
    15b4:	00025a10 	andeq	r5, r2, r0, lsl sl
    15b8:	02c80900 	sbceq	r0, r8, #0, 18
    15bc:	02df0000 	sbcseq	r0, pc, #0
    15c0:	00100000 	andseq	r0, r0, r0
    15c4:	00038211 	andeq	r8, r3, r1, lsl r2
    15c8:	112f0300 			; <UNDEFINED> instruction: 0x112f0300
    15cc:	000002d4 	ldrdeq	r0, [r0], -r4
    15d0:	00027611 	andeq	r7, r2, r1, lsl r6
    15d4:	11300300 	teqne	r0, r0, lsl #6
    15d8:	000002d4 	ldrdeq	r0, [r0], -r4
    15dc:	0002c809 	andeq	ip, r2, r9, lsl #16
    15e0:	00030700 	andeq	r0, r3, r0, lsl #14
    15e4:	00240a00 	eoreq	r0, r4, r0, lsl #20
    15e8:	00010000 	andeq	r0, r1, r0
    15ec:	0002df12 	andeq	sp, r2, r2, lsl pc
    15f0:	09330400 	ldmdbeq	r3!, {sl}
    15f4:	0002f70a 	andeq	pc, r2, sl, lsl #14
    15f8:	e5030500 	str	r0, [r3, #-1280]	; 0xfffffb00
    15fc:	1200008d 	andne	r0, r0, #141	; 0x8d
    1600:	000002eb 	andeq	r0, r0, fp, ror #5
    1604:	0a093404 	beq	24e61c <__bss_end+0x245824>
    1608:	000002f7 	strdeq	r0, [r0], -r7
    160c:	8de50305 	stclhi	3, cr0, [r5, #20]!
    1610:	Address 0x0000000000001610 is out of bounds.


Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
   0:	10001101 	andne	r1, r0, r1, lsl #2
   4:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
   8:	1b0e0301 	blne	380c14 <__bss_end+0x377e1c>
   c:	130e250e 	movwne	r2, #58638	; 0xe50e
  10:	00000005 	andeq	r0, r0, r5
  14:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
  18:	030b130e 	movweq	r1, #45838	; 0xb30e
  1c:	110e1b0e 	tstne	lr, lr, lsl #22
  20:	10061201 	andne	r1, r6, r1, lsl #4
  24:	02000017 	andeq	r0, r0, #23
  28:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  2c:	0b3b0b3a 	bleq	ec2d1c <__bss_end+0xeb9f24>
  30:	13490b39 	movtne	r0, #39737	; 0x9b39
  34:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
  38:	24030000 	strcs	r0, [r3], #-0
  3c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
  40:	000e030b 	andeq	r0, lr, fp, lsl #6
  44:	012e0400 			; <UNDEFINED> instruction: 0x012e0400
  48:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
  4c:	0b3b0b3a 	bleq	ec2d3c <__bss_end+0xeb9f44>
  50:	01110b39 	tsteq	r1, r9, lsr fp
  54:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
  58:	01194296 			; <UNDEFINED> instruction: 0x01194296
  5c:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
  60:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  64:	0b3b0b3a 	bleq	ec2d54 <__bss_end+0xeb9f5c>
  68:	13490b39 	movtne	r0, #39737	; 0x9b39
  6c:	00001802 	andeq	r1, r0, r2, lsl #16
  70:	0b002406 	bleq	9090 <__bss_end+0x298>
  74:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
  78:	07000008 	streq	r0, [r0, -r8]
  7c:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
  80:	0b3a0e03 	bleq	e83894 <__bss_end+0xe7aa9c>
  84:	0b390b3b 	bleq	e42d78 <__bss_end+0xe39f80>
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
  b4:	3a0e0300 	bcc	380cbc <__bss_end+0x377ec4>
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
  e4:	0b3e0b0b 	bleq	f82d18 <__bss_end+0xf79f20>
  e8:	00000e03 	andeq	r0, r0, r3, lsl #28
  ec:	03003408 	movweq	r3, #1032	; 0x408
  f0:	3b0b3a0e 	blcc	2ce930 <__bss_end+0x2c5b38>
  f4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
  f8:	3c193f13 	ldccc	15, cr3, [r9], {19}
  fc:	09000019 	stmdbeq	r0, {r0, r3, r4}
 100:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 104:	0b3a0e03 	bleq	e83918 <__bss_end+0xe7ab20>
 108:	0b390b3b 	bleq	e42dfc <__bss_end+0xe3a004>
 10c:	01111349 	tsteq	r1, r9, asr #6
 110:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 114:	01194296 			; <UNDEFINED> instruction: 0x01194296
 118:	0a000013 	beq	16c <shift+0x16c>
 11c:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 120:	0b3b0b3a 	bleq	ec2e10 <__bss_end+0xeba018>
 124:	13490b39 	movtne	r0, #39737	; 0x9b39
 128:	00001802 	andeq	r1, r0, r2, lsl #16
 12c:	0b00240b 	bleq	9160 <__bss_end+0x368>
 130:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 134:	0c000008 	stceq	0, cr0, [r0], {8}
 138:	193f002e 	ldmdbne	pc!, {r1, r2, r3, r5}	; <UNPREDICTABLE>
 13c:	0b3a0e03 	bleq	e83950 <__bss_end+0xe7ab58>
 140:	0b390b3b 	bleq	e42e34 <__bss_end+0xe3a03c>
 144:	06120111 			; <UNDEFINED> instruction: 0x06120111
 148:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 14c:	0d000019 	stceq	0, cr0, [r0, #-100]	; 0xffffff9c
 150:	0e030139 	mcreq	1, 0, r0, cr3, cr9, {1}
 154:	0b3b0b3a 	bleq	ec2e44 <__bss_end+0xeba04c>
 158:	00001301 	andeq	r1, r0, r1, lsl #6
 15c:	3f012e0e 	svccc	0x00012e0e
 160:	3a0e0319 	bcc	380dcc <__bss_end+0x377fd4>
 164:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 168:	01193c0b 	tsteq	r9, fp, lsl #24
 16c:	0f000013 	svceq	0x00000013
 170:	13490005 	movtne	r0, #36869	; 0x9005
 174:	2e100000 	cdpcs	0, 1, cr0, cr0, cr0, {0}
 178:	03193f01 	tsteq	r9, #1, 30
 17c:	3b0b3a0e 	blcc	2ce9bc <__bss_end+0x2c5bc4>
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
 1a8:	3b0b3a08 	blcc	2ce9d0 <__bss_end+0x2c5bd8>
 1ac:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 1b0:	00180213 	andseq	r0, r8, r3, lsl r2
 1b4:	012e1400 			; <UNDEFINED> instruction: 0x012e1400
 1b8:	01111347 	tsteq	r1, r7, asr #6
 1bc:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 1c0:	00194297 	mulseq	r9, r7, r2
 1c4:	11010000 	mrsne	r0, (UNDEF: 1)
 1c8:	130e2501 	movwne	r2, #58625	; 0xe501
 1cc:	1b0e030b 	blne	380e00 <__bss_end+0x378008>
 1d0:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 1d4:	00171006 	andseq	r1, r7, r6
 1d8:	00240200 	eoreq	r0, r4, r0, lsl #4
 1dc:	0b3e0b0b 	bleq	f82e10 <__bss_end+0xf7a018>
 1e0:	00000e03 	andeq	r0, r0, r3, lsl #28
 1e4:	0b002403 	bleq	91f8 <__bss_end+0x400>
 1e8:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 1ec:	04000008 	streq	r0, [r0], #-8
 1f0:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
 1f4:	0b3b0b3a 	bleq	ec2ee4 <__bss_end+0xeba0ec>
 1f8:	13490b39 	movtne	r0, #39737	; 0x9b39
 1fc:	26050000 	strcs	r0, [r5], -r0
 200:	00134900 	andseq	r4, r3, r0, lsl #18
 204:	00340600 	eorseq	r0, r4, r0, lsl #12
 208:	0b3a0e03 	bleq	e83a1c <__bss_end+0xe7ac24>
 20c:	0b390b3b 	bleq	e42f00 <__bss_end+0xe3a108>
 210:	196c1349 	stmdbne	ip!, {r0, r3, r6, r8, r9, ip}^
 214:	00001802 	andeq	r1, r0, r2, lsl #16
 218:	3f012e07 	svccc	0x00012e07
 21c:	3a0e0319 	bcc	380e88 <__bss_end+0x378090>
 220:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 224:	1113490b 	tstne	r3, fp, lsl #18
 228:	40061201 	andmi	r1, r6, r1, lsl #4
 22c:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
 230:	00001301 	andeq	r1, r0, r1, lsl #6
 234:	03000508 	movweq	r0, #1288	; 0x508
 238:	3b0b3a0e 	blcc	2cea78 <__bss_end+0x2c5c80>
 23c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 240:	00180213 	andseq	r0, r8, r3, lsl r2
 244:	000f0900 	andeq	r0, pc, r0, lsl #18
 248:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 24c:	01000000 	mrseq	r0, (UNDEF: 0)
 250:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
 254:	0e030b13 	vmoveq.32	d3[0], r0
 258:	01110e1b 	tsteq	r1, fp, lsl lr
 25c:	17100612 			; <UNDEFINED> instruction: 0x17100612
 260:	24020000 	strcs	r0, [r2], #-0
 264:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 268:	000e030b 	andeq	r0, lr, fp, lsl #6
 26c:	00260300 	eoreq	r0, r6, r0, lsl #6
 270:	00001349 	andeq	r1, r0, r9, asr #6
 274:	0b002404 	bleq	928c <__bss_end+0x494>
 278:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 27c:	05000008 	streq	r0, [r0, #-8]
 280:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
 284:	0b3b0b3a 	bleq	ec2f74 <__bss_end+0xeba17c>
 288:	13490b39 	movtne	r0, #39737	; 0x9b39
 28c:	13060000 	movwne	r0, #24576	; 0x6000
 290:	0b0e0301 	bleq	380e9c <__bss_end+0x3780a4>
 294:	3b0b3a0b 	blcc	2ceac8 <__bss_end+0x2c5cd0>
 298:	010b390b 	tsteq	fp, fp, lsl #18
 29c:	07000013 	smladeq	r0, r3, r0, r0
 2a0:	0803000d 	stmdaeq	r3, {r0, r2, r3}
 2a4:	0b3b0b3a 	bleq	ec2f94 <__bss_end+0xeba19c>
 2a8:	13490b39 	movtne	r0, #39737	; 0x9b39
 2ac:	00000b38 	andeq	r0, r0, r8, lsr fp
 2b0:	03010408 	movweq	r0, #5128	; 0x1408
 2b4:	3e196d0e 	cdpcc	13, 1, cr6, cr9, cr14, {0}
 2b8:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
 2bc:	3b0b3a13 	blcc	2ceb10 <__bss_end+0x2c5d18>
 2c0:	010b390b 	tsteq	fp, fp, lsl #18
 2c4:	09000013 	stmdbeq	r0, {r0, r1, r4}
 2c8:	08030028 	stmdaeq	r3, {r3, r5}
 2cc:	00000b1c 	andeq	r0, r0, ip, lsl fp
 2d0:	0300280a 	movweq	r2, #2058	; 0x80a
 2d4:	000b1c0e 	andeq	r1, fp, lr, lsl #24
 2d8:	00340b00 	eorseq	r0, r4, r0, lsl #22
 2dc:	0b3a0e03 	bleq	e83af0 <__bss_end+0xe7acf8>
 2e0:	0b390b3b 	bleq	e42fd4 <__bss_end+0xe3a1dc>
 2e4:	196c1349 	stmdbne	ip!, {r0, r3, r6, r8, r9, ip}^
 2e8:	00001802 	andeq	r1, r0, r2, lsl #16
 2ec:	0300020c 	movweq	r0, #524	; 0x20c
 2f0:	00193c0e 	andseq	r3, r9, lr, lsl #24
 2f4:	000f0d00 	andeq	r0, pc, r0, lsl #26
 2f8:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 2fc:	0d0e0000 	stceq	0, cr0, [lr, #-0]
 300:	3a0e0300 	bcc	380f08 <__bss_end+0x378110>
 304:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 308:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 30c:	0f00000b 	svceq	0x0000000b
 310:	13490101 	movtne	r0, #37121	; 0x9101
 314:	00001301 	andeq	r1, r0, r1, lsl #6
 318:	49002110 	stmdbmi	r0, {r4, r8, sp}
 31c:	000b2f13 	andeq	r2, fp, r3, lsl pc
 320:	01021100 	mrseq	r1, (UNDEF: 18)
 324:	0b0b0e03 	bleq	2c3b38 <__bss_end+0x2bad40>
 328:	0b3b0b3a 	bleq	ec3018 <__bss_end+0xeba220>
 32c:	13010b39 	movwne	r0, #6969	; 0x1b39
 330:	2e120000 	cdpcs	0, 1, cr0, cr2, cr0, {0}
 334:	03193f01 	tsteq	r9, #1, 30
 338:	3b0b3a0e 	blcc	2ceb78 <__bss_end+0x2c5d80>
 33c:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 340:	64193c0e 	ldrvs	r3, [r9], #-3086	; 0xfffff3f2
 344:	00130113 	andseq	r0, r3, r3, lsl r1
 348:	00051300 	andeq	r1, r5, r0, lsl #6
 34c:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
 350:	05140000 	ldreq	r0, [r4, #-0]
 354:	00134900 	andseq	r4, r3, r0, lsl #18
 358:	012e1500 			; <UNDEFINED> instruction: 0x012e1500
 35c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 360:	0b3b0b3a 	bleq	ec3050 <__bss_end+0xeba258>
 364:	0e6e0b39 	vmoveq.8	d14[5], r0
 368:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 36c:	13011364 	movwne	r1, #4964	; 0x1364
 370:	2e160000 	cdpcs	0, 1, cr0, cr6, cr0, {0}
 374:	03193f01 	tsteq	r9, #1, 30
 378:	3b0b3a0e 	blcc	2cebb8 <__bss_end+0x2c5dc0>
 37c:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 380:	3213490e 	andscc	r4, r3, #229376	; 0x38000
 384:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 388:	00130113 	andseq	r0, r3, r3, lsl r1
 38c:	000d1700 	andeq	r1, sp, r0, lsl #14
 390:	0b3a0e03 	bleq	e83ba4 <__bss_end+0xe7adac>
 394:	0b390b3b 	bleq	e43088 <__bss_end+0xe3a290>
 398:	0b381349 	bleq	e050c4 <__bss_end+0xdfc2cc>
 39c:	00000b32 	andeq	r0, r0, r2, lsr fp
 3a0:	3f012e18 	svccc	0x00012e18
 3a4:	3a0e0319 	bcc	381010 <__bss_end+0x378218>
 3a8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 3ac:	320e6e0b 	andcc	r6, lr, #11, 28	; 0xb0
 3b0:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 3b4:	00130113 	andseq	r0, r3, r3, lsl r1
 3b8:	012e1900 			; <UNDEFINED> instruction: 0x012e1900
 3bc:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 3c0:	0b3b0b3a 	bleq	ec30b0 <__bss_end+0xeba2b8>
 3c4:	0e6e0b39 	vmoveq.8	d14[5], r0
 3c8:	0b321349 	bleq	c850f4 <__bss_end+0xc7c2fc>
 3cc:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 3d0:	151a0000 	ldrne	r0, [sl, #-0]
 3d4:	64134901 	ldrvs	r4, [r3], #-2305	; 0xfffff6ff
 3d8:	00130113 	andseq	r0, r3, r3, lsl r1
 3dc:	001f1b00 	andseq	r1, pc, r0, lsl #22
 3e0:	1349131d 	movtne	r1, #37661	; 0x931d
 3e4:	101c0000 	andsne	r0, ip, r0
 3e8:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 3ec:	1d000013 	stcne	0, cr0, [r0, #-76]	; 0xffffffb4
 3f0:	0b0b000f 	bleq	2c0434 <__bss_end+0x2b763c>
 3f4:	341e0000 	ldrcc	r0, [lr], #-0
 3f8:	3a0e0300 	bcc	381000 <__bss_end+0x378208>
 3fc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 400:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 404:	1f000018 	svcne	0x00000018
 408:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 40c:	0b3a0e03 	bleq	e83c20 <__bss_end+0xe7ae28>
 410:	0b390b3b 	bleq	e43104 <__bss_end+0xe3a30c>
 414:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 418:	06120111 			; <UNDEFINED> instruction: 0x06120111
 41c:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 420:	00130119 	andseq	r0, r3, r9, lsl r1
 424:	00052000 	andeq	r2, r5, r0
 428:	0b3a0e03 	bleq	e83c3c <__bss_end+0xe7ae44>
 42c:	0b390b3b 	bleq	e43120 <__bss_end+0xe3a328>
 430:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 434:	2e210000 	cdpcs	0, 2, cr0, cr1, cr0, {0}
 438:	03193f01 	tsteq	r9, #1, 30
 43c:	3b0b3a0e 	blcc	2cec7c <__bss_end+0x2c5e84>
 440:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 444:	1113490e 	tstne	r3, lr, lsl #18
 448:	40061201 	andmi	r1, r6, r1, lsl #4
 44c:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 450:	00001301 	andeq	r1, r0, r1, lsl #6
 454:	03003422 	movweq	r3, #1058	; 0x422
 458:	3b0b3a08 	blcc	2cec80 <__bss_end+0x2c5e88>
 45c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 460:	00180213 	andseq	r0, r8, r3, lsl r2
 464:	012e2300 			; <UNDEFINED> instruction: 0x012e2300
 468:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 46c:	0b3b0b3a 	bleq	ec315c <__bss_end+0xeba364>
 470:	0e6e0b39 	vmoveq.8	d14[5], r0
 474:	06120111 			; <UNDEFINED> instruction: 0x06120111
 478:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 47c:	00130119 	andseq	r0, r3, r9, lsl r1
 480:	002e2400 	eoreq	r2, lr, r0, lsl #8
 484:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 488:	0b3b0b3a 	bleq	ec3178 <__bss_end+0xeba380>
 48c:	0e6e0b39 	vmoveq.8	d14[5], r0
 490:	06120111 			; <UNDEFINED> instruction: 0x06120111
 494:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 498:	25000019 	strcs	r0, [r0, #-25]	; 0xffffffe7
 49c:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 4a0:	0b3a0e03 	bleq	e83cb4 <__bss_end+0xe7aebc>
 4a4:	0b390b3b 	bleq	e43198 <__bss_end+0xe3a3a0>
 4a8:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 4ac:	06120111 			; <UNDEFINED> instruction: 0x06120111
 4b0:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 4b4:	00000019 	andeq	r0, r0, r9, lsl r0
 4b8:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
 4bc:	030b130e 	movweq	r1, #45838	; 0xb30e
 4c0:	110e1b0e 	tstne	lr, lr, lsl #22
 4c4:	10061201 	andne	r1, r6, r1, lsl #4
 4c8:	02000017 	andeq	r0, r0, #23
 4cc:	13010139 	movwne	r0, #4409	; 0x1139
 4d0:	34030000 	strcc	r0, [r3], #-0
 4d4:	3a0e0300 	bcc	3810dc <__bss_end+0x3782e4>
 4d8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 4dc:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
 4e0:	000a1c19 	andeq	r1, sl, r9, lsl ip
 4e4:	003a0400 	eorseq	r0, sl, r0, lsl #8
 4e8:	0b3b0b3a 	bleq	ec31d8 <__bss_end+0xeba3e0>
 4ec:	13180b39 	tstne	r8, #58368	; 0xe400
 4f0:	01050000 	mrseq	r0, (UNDEF: 5)
 4f4:	01134901 	tsteq	r3, r1, lsl #18
 4f8:	06000013 			; <UNDEFINED> instruction: 0x06000013
 4fc:	13490021 	movtne	r0, #36897	; 0x9021
 500:	00000b2f 	andeq	r0, r0, pc, lsr #22
 504:	49002607 	stmdbmi	r0, {r0, r1, r2, r9, sl, sp}
 508:	08000013 	stmdaeq	r0, {r0, r1, r4}
 50c:	0b0b0024 	bleq	2c05a4 <__bss_end+0x2b77ac>
 510:	0e030b3e 	vmoveq.16	d3[0], r0
 514:	34090000 	strcc	r0, [r9], #-0
 518:	00134700 	andseq	r4, r3, r0, lsl #14
 51c:	012e0a00 			; <UNDEFINED> instruction: 0x012e0a00
 520:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 524:	0b3b0b3a 	bleq	ec3214 <__bss_end+0xeba41c>
 528:	0e6e0b39 	vmoveq.8	d14[5], r0
 52c:	06120111 			; <UNDEFINED> instruction: 0x06120111
 530:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 534:	00130119 	andseq	r0, r3, r9, lsl r1
 538:	00050b00 	andeq	r0, r5, r0, lsl #22
 53c:	0b3a0803 	bleq	e82550 <__bss_end+0xe79758>
 540:	0b390b3b 	bleq	e43234 <__bss_end+0xe3a43c>
 544:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 548:	340c0000 	strcc	r0, [ip], #-0
 54c:	3a0e0300 	bcc	381154 <__bss_end+0x37835c>
 550:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 554:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 558:	0d000018 	stceq	0, cr0, [r0, #-96]	; 0xffffffa0
 55c:	0111010b 	tsteq	r1, fp, lsl #2
 560:	00000612 	andeq	r0, r0, r2, lsl r6
 564:	0300340e 	movweq	r3, #1038	; 0x40e
 568:	3b0b3a08 	blcc	2ced90 <__bss_end+0x2c5f98>
 56c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 570:	00180213 	andseq	r0, r8, r3, lsl r2
 574:	000f0f00 	andeq	r0, pc, r0, lsl #30
 578:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 57c:	26100000 	ldrcs	r0, [r0], -r0
 580:	11000000 	mrsne	r0, (UNDEF: 0)
 584:	0b0b000f 	bleq	2c05c8 <__bss_end+0x2b77d0>
 588:	24120000 	ldrcs	r0, [r2], #-0
 58c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 590:	0008030b 	andeq	r0, r8, fp, lsl #6
 594:	00051300 	andeq	r1, r5, r0, lsl #6
 598:	0b3a0e03 	bleq	e83dac <__bss_end+0xe7afb4>
 59c:	0b390b3b 	bleq	e43290 <__bss_end+0xe3a498>
 5a0:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 5a4:	2e140000 	cdpcs	0, 1, cr0, cr4, cr0, {0}
 5a8:	03193f01 	tsteq	r9, #1, 30
 5ac:	3b0b3a0e 	blcc	2cedec <__bss_end+0x2c5ff4>
 5b0:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 5b4:	1113490e 	tstne	r3, lr, lsl #18
 5b8:	40061201 	andmi	r1, r6, r1, lsl #4
 5bc:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 5c0:	00001301 	andeq	r1, r0, r1, lsl #6
 5c4:	3f012e15 	svccc	0x00012e15
 5c8:	3a0e0319 	bcc	381234 <__bss_end+0x37843c>
 5cc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 5d0:	110e6e0b 	tstne	lr, fp, lsl #28
 5d4:	40061201 	andmi	r1, r6, r1, lsl #4
 5d8:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
 5dc:	01000000 	mrseq	r0, (UNDEF: 0)
 5e0:	06100011 			; <UNDEFINED> instruction: 0x06100011
 5e4:	01120111 	tsteq	r2, r1, lsl r1
 5e8:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
 5ec:	05130e25 	ldreq	r0, [r3, #-3621]	; 0xfffff1db
 5f0:	01000000 	mrseq	r0, (UNDEF: 0)
 5f4:	06100011 			; <UNDEFINED> instruction: 0x06100011
 5f8:	01120111 	tsteq	r2, r1, lsl r1
 5fc:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
 600:	05130e25 	ldreq	r0, [r3, #-3621]	; 0xfffff1db
 604:	01000000 	mrseq	r0, (UNDEF: 0)
 608:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
 60c:	0e030b13 	vmoveq.32	d3[0], r0
 610:	17100e1b 			; <UNDEFINED> instruction: 0x17100e1b
 614:	24020000 	strcs	r0, [r2], #-0
 618:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 61c:	0008030b 	andeq	r0, r8, fp, lsl #6
 620:	00240300 	eoreq	r0, r4, r0, lsl #6
 624:	0b3e0b0b 	bleq	f83258 <__bss_end+0xf7a460>
 628:	00000e03 	andeq	r0, r0, r3, lsl #28
 62c:	03010404 	movweq	r0, #5124	; 0x1404
 630:	0b0b3e0e 	bleq	2cfe70 <__bss_end+0x2c7078>
 634:	3a13490b 	bcc	4d2a68 <__bss_end+0x4c9c70>
 638:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 63c:	0013010b 	andseq	r0, r3, fp, lsl #2
 640:	00280500 	eoreq	r0, r8, r0, lsl #10
 644:	0b1c0e03 	bleq	703e58 <__bss_end+0x6fb060>
 648:	13060000 	movwne	r0, #24576	; 0x6000
 64c:	0b0e0301 	bleq	381258 <__bss_end+0x378460>
 650:	3b0b3a0b 	blcc	2cee84 <__bss_end+0x2c608c>
 654:	010b3905 	tsteq	fp, r5, lsl #18
 658:	07000013 	smladeq	r0, r3, r0, r0
 65c:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 660:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 664:	13490b39 	movtne	r0, #39737	; 0x9b39
 668:	00000b38 	andeq	r0, r0, r8, lsr fp
 66c:	49002608 	stmdbmi	r0, {r3, r9, sl, sp}
 670:	09000013 	stmdbeq	r0, {r0, r1, r4}
 674:	13490101 	movtne	r0, #37121	; 0x9101
 678:	00001301 	andeq	r1, r0, r1, lsl #6
 67c:	4900210a 	stmdbmi	r0, {r1, r3, r8, sp}
 680:	000b2f13 	andeq	r2, fp, r3, lsl pc
 684:	00340b00 	eorseq	r0, r4, r0, lsl #22
 688:	0b3a0e03 	bleq	e83e9c <__bss_end+0xe7b0a4>
 68c:	0b39053b 	bleq	e41b80 <__bss_end+0xe38d88>
 690:	0a1c1349 	beq	7053bc <__bss_end+0x6fc5c4>
 694:	150c0000 	strne	r0, [ip, #-0]
 698:	00192700 	andseq	r2, r9, r0, lsl #14
 69c:	000f0d00 	andeq	r0, pc, r0, lsl #26
 6a0:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 6a4:	040e0000 	streq	r0, [lr], #-0
 6a8:	3e0e0301 	cdpcc	3, 0, cr0, cr14, cr1, {0}
 6ac:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
 6b0:	3b0b3a13 	blcc	2cef04 <__bss_end+0x2c610c>
 6b4:	010b3905 	tsteq	fp, r5, lsl #18
 6b8:	0f000013 	svceq	0x00000013
 6bc:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
 6c0:	0b3b0b3a 	bleq	ec33b0 <__bss_end+0xeba5b8>
 6c4:	13490b39 	movtne	r0, #39737	; 0x9b39
 6c8:	21100000 	tstcs	r0, r0
 6cc:	11000000 	mrsne	r0, (UNDEF: 0)
 6d0:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 6d4:	0b3b0b3a 	bleq	ec33c4 <__bss_end+0xeba5cc>
 6d8:	13490b39 	movtne	r0, #39737	; 0x9b39
 6dc:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
 6e0:	34120000 	ldrcc	r0, [r2], #-0
 6e4:	3a134700 	bcc	4d22ec <__bss_end+0x4c94f4>
 6e8:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 6ec:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 6f0:	00000018 	andeq	r0, r0, r8, lsl r0

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
  74:	00000020 	andeq	r0, r0, r0, lsr #32
	...
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	04440002 	strbeq	r0, [r4], #-2
  88:	00040000 	andeq	r0, r4, r0
  8c:	00000000 	andeq	r0, r0, r0
  90:	0000824c 	andeq	r8, r0, ip, asr #4
  94:	0000045c 	andeq	r0, r0, ip, asr r4
	...
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	0f670002 	svceq	0x00670002
  a8:	00040000 	andeq	r0, r4, r0
  ac:	00000000 	andeq	r0, r0, r0
  b0:	000086a8 	andeq	r8, r0, r8, lsr #13
  b4:	000004b8 			; <UNDEFINED> instruction: 0x000004b8
	...
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	12990002 	addsne	r0, r9, #2
  c8:	00040000 	andeq	r0, r4, r0
  cc:	00000000 	andeq	r0, r0, r0
  d0:	00008b60 	andeq	r8, r0, r0, ror #22
  d4:	0000020c 	andeq	r0, r0, ip, lsl #4
	...
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	12bf0002 	adcsne	r0, pc, #2
  e8:	00040000 	andeq	r0, r4, r0
  ec:	00000000 	andeq	r0, r0, r0
  f0:	00008d6c 	andeq	r8, r0, ip, ror #26
  f4:	00000004 	andeq	r0, r0, r4
	...
 100:	00000014 	andeq	r0, r0, r4, lsl r0
 104:	12e50002 	rscne	r0, r5, #2
 108:	00040000 	andeq	r0, r4, r0
	...

Disassembly of section .debug_str:

00000000 <.debug_str>:
       0:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
       4:	552f632f 	strpl	r6, [pc, #-815]!	; fffffcdd <__bss_end+0xffff6ee5>
       8:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
       c:	62754b2f 	rsbsvs	r4, r5, #48128	; 0xbc00
      10:	6f442f61 	svcvs	0x00442f61
      14:	656d7563 	strbvs	r7, [sp, #-1379]!	; 0xfffffa9d
      18:	2f73746e 	svccs	0x0073746e
      1c:	6f72655a 	svcvs	0x0072655a
      20:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
      24:	6178652f 	cmnvs	r8, pc, lsr #10
      28:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
      2c:	38312f73 	ldmdacc	r1!, {r0, r1, r4, r5, r6, r8, r9, sl, fp, sp}
      30:	6664652d 	strbtvs	r6, [r4], -sp, lsr #10
      34:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
      38:	61707372 	cmnvs	r0, r2, ror r3
      3c:	632f6563 			; <UNDEFINED> instruction: 0x632f6563
      40:	2e307472 	mrccs	4, 1, r7, cr0, cr2, {3}
      44:	6d2f0073 	stcvs	0, cr0, [pc, #-460]!	; fffffe80 <__bss_end+0xffff7088>
      48:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
      4c:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
      50:	4b2f7372 	blmi	bdce20 <__bss_end+0xbd4028>
      54:	2f616275 	svccs	0x00616275
      58:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
      5c:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
      60:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
      64:	614d6f72 	hvcvs	55026	; 0xd6f2
      68:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffafc <__bss_end+0xffff6d04>
      6c:	706d6178 	rsbvc	r6, sp, r8, ror r1
      70:	2f73656c 	svccs	0x0073656c
      74:	652d3831 	strvs	r3, [sp, #-2097]!	; 0xfffff7cf
      78:	752f6664 	strvc	r6, [pc, #-1636]!	; fffffa1c <__bss_end+0xffff6c24>
      7c:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
      80:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
      84:	6975622f 	ldmdbvs	r5!, {r0, r1, r2, r3, r5, r9, sp, lr}^
      88:	4700646c 	strmi	r6, [r0, -ip, ror #8]
      8c:	4120554e 			; <UNDEFINED> instruction: 0x4120554e
      90:	2e322053 	mrccs	0, 1, r2, cr2, cr3, {2}
      94:	47003833 	smladxmi	r0, r3, r8, r3
      98:	4320554e 			; <UNDEFINED> instruction: 0x4320554e
      9c:	31203731 			; <UNDEFINED> instruction: 0x31203731
      a0:	2e332e30 	mrccs	14, 1, r2, cr3, cr0, {1}
      a4:	30322031 	eorscc	r2, r2, r1, lsr r0
      a8:	36303132 			; <UNDEFINED> instruction: 0x36303132
      ac:	28203132 	stmdacs	r0!, {r1, r4, r5, r8, ip, sp}
      b0:	656c6572 	strbvs	r6, [ip, #-1394]!	; 0xfffffa8e
      b4:	29657361 	stmdbcs	r5!, {r0, r5, r6, r8, r9, ip, sp, lr}^
      b8:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
      bc:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
      c0:	6962612d 	stmdbvs	r2!, {r0, r2, r3, r5, r8, sp, lr}^
      c4:	7261683d 	rsbvc	r6, r1, #3997696	; 0x3d0000
      c8:	6d2d2064 	stcvs	0, cr2, [sp, #-400]!	; 0xfffffe70
      cc:	3d757066 	ldclcc	0, cr7, [r5, #-408]!	; 0xfffffe68
      d0:	20706676 	rsbscs	r6, r0, r6, ror r6
      d4:	6c666d2d 	stclvs	13, cr6, [r6], #-180	; 0xffffff4c
      d8:	2d74616f 	ldfcse	f6, [r4, #-444]!	; 0xfffffe44
      dc:	3d696261 	sfmcc	f6, 2, [r9, #-388]!	; 0xfffffe7c
      e0:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
      e4:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
      e8:	763d7570 			; <UNDEFINED> instruction: 0x763d7570
      ec:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
      f0:	6e75746d 	cdpvs	4, 7, cr7, cr5, cr13, {3}
      f4:	72613d65 	rsbvc	r3, r1, #6464	; 0x1940
      f8:	3731316d 	ldrcc	r3, [r1, -sp, ror #2]!
      fc:	667a6a36 			; <UNDEFINED> instruction: 0x667a6a36
     100:	2d20732d 	stccs	3, cr7, [r0, #-180]!	; 0xffffff4c
     104:	6d72616d 	ldfvse	f6, [r2, #-436]!	; 0xfffffe4c
     108:	616d2d20 	cmnvs	sp, r0, lsr #26
     10c:	3d686372 	stclcc	3, cr6, [r8, #-456]!	; 0xfffffe38
     110:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
     114:	2b6b7a36 	blcs	1ade9f4 <__bss_end+0x1ad5bfc>
     118:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
     11c:	672d2067 	strvs	r2, [sp, -r7, rrx]!
     120:	304f2d20 	subcc	r2, pc, r0, lsr #26
     124:	304f2d20 	subcc	r2, pc, r0, lsr #26
     128:	625f5f00 	subsvs	r5, pc, #0, 30
     12c:	655f7373 	ldrbvs	r7, [pc, #-883]	; fffffdc1 <__bss_end+0xffff6fc9>
     130:	7200646e 	andvc	r6, r0, #1845493760	; 0x6e000000
     134:	6c757365 	ldclvs	3, cr7, [r5], #-404	; 0xfffffe6c
     138:	6d2f0074 	stcvs	0, cr0, [pc, #-464]!	; ffffff70 <__bss_end+0xffff7178>
     13c:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
     140:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
     144:	4b2f7372 	blmi	bdcf14 <__bss_end+0xbd411c>
     148:	2f616275 	svccs	0x00616275
     14c:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
     150:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
     154:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
     158:	614d6f72 	hvcvs	55026	; 0xd6f2
     15c:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffbf0 <__bss_end+0xffff6df8>
     160:	706d6178 	rsbvc	r6, sp, r8, ror r1
     164:	2f73656c 	svccs	0x0073656c
     168:	652d3831 	strvs	r3, [sp, #-2097]!	; 0xfffff7cf
     16c:	752f6664 	strvc	r6, [pc, #-1636]!	; fffffb10 <__bss_end+0xffff6d18>
     170:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
     174:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
     178:	7472632f 	ldrbtvc	r6, [r2], #-815	; 0xfffffcd1
     17c:	00632e30 	rsbeq	r2, r3, r0, lsr lr
     180:	72635f5f 	rsbvc	r5, r3, #380	; 0x17c
     184:	695f3074 	ldmdbvs	pc, {r2, r4, r5, r6, ip, sp}^	; <UNPREDICTABLE>
     188:	5f74696e 	svcpl	0x0074696e
     18c:	00737362 	rsbseq	r7, r3, r2, ror #6
     190:	69676562 	stmdbvs	r7!, {r1, r5, r6, r8, sl, sp, lr}^
     194:	5f5f006e 	svcpl	0x005f006e
     198:	30747263 	rsbscc	r7, r4, r3, ror #4
     19c:	6e75725f 	mrcvs	2, 3, r7, cr5, cr15, {2}
     1a0:	625f5f00 	subsvs	r5, pc, #0, 30
     1a4:	735f7373 	cmpvc	pc, #-872415231	; 0xcc000001
     1a8:	74726174 	ldrbtvc	r6, [r2], #-372	; 0xfffffe8c
     1ac:	675f5f00 	ldrbvs	r5, [pc, -r0, lsl #30]
     1b0:	64726175 	ldrbtvs	r6, [r2], #-373	; 0xfffffe8b
     1b4:	615f5f00 	cmpvs	pc, r0, lsl #30
     1b8:	69626165 	stmdbvs	r2!, {r0, r2, r5, r6, r8, sp, lr}^
     1bc:	776e755f 			; <UNDEFINED> instruction: 0x776e755f
     1c0:	5f646e69 	svcpl	0x00646e69
     1c4:	5f707063 	svcpl	0x00707063
     1c8:	00317270 	eorseq	r7, r1, r0, ror r2
     1cc:	78635f5f 	stmdavc	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, sl, fp, ip, lr}^
     1d0:	75675f61 	strbvc	r5, [r7, #-3937]!	; 0xfffff09f
     1d4:	5f647261 	svcpl	0x00647261
     1d8:	656c6572 	strbvs	r6, [ip, #-1394]!	; 0xfffffa8e
     1dc:	00657361 	rsbeq	r7, r5, r1, ror #6
     1e0:	7070635f 	rsbsvc	r6, r0, pc, asr r3
     1e4:	7568735f 	strbvc	r7, [r8, #-863]!	; 0xfffffca1
     1e8:	776f6474 			; <UNDEFINED> instruction: 0x776f6474
     1ec:	6e66006e 	cdpvs	0, 6, cr0, cr6, cr14, {3}
     1f0:	00727470 	rsbseq	r7, r2, r0, ror r4
     1f4:	78635f5f 	stmdavc	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, sl, fp, ip, lr}^
     1f8:	69626178 	stmdbvs	r2!, {r3, r4, r5, r6, r8, sp, lr}^
     1fc:	5f003176 	svcpl	0x00003176
     200:	6178635f 	cmnvs	r8, pc, asr r3
     204:	7275705f 	rsbsvc	r7, r5, #95	; 0x5f
     208:	69765f65 	ldmdbvs	r6!, {r0, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     20c:	61757472 	cmnvs	r5, r2, ror r4
     210:	6d2f006c 	stcvs	0, cr0, [pc, #-432]!	; 68 <shift+0x68>
     214:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
     218:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
     21c:	4b2f7372 	blmi	bdcfec <__bss_end+0xbd41f4>
     220:	2f616275 	svccs	0x00616275
     224:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
     228:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
     22c:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
     230:	614d6f72 	hvcvs	55026	; 0xd6f2
     234:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffcc8 <__bss_end+0xffff6ed0>
     238:	706d6178 	rsbvc	r6, sp, r8, ror r1
     23c:	2f73656c 	svccs	0x0073656c
     240:	652d3831 	strvs	r3, [sp, #-2097]!	; 0xfffff7cf
     244:	752f6664 	strvc	r6, [pc, #-1636]!	; fffffbe8 <__bss_end+0xffff6df0>
     248:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
     24c:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
     250:	7878632f 	ldmdavc	r8!, {r0, r1, r2, r3, r5, r8, r9, sp, lr}^
     254:	2e696261 	cdpcs	2, 6, cr6, cr9, cr1, {3}
     258:	00707063 	rsbseq	r7, r0, r3, rrx
     25c:	54435f5f 	strbpl	r5, [r3], #-3935	; 0xfffff0a1
     260:	455f524f 	ldrbmi	r5, [pc, #-591]	; 19 <shift+0x19>
     264:	5f5f444e 	svcpl	0x005f444e
     268:	645f5f00 	ldrbvs	r5, [pc], #-3840	; 270 <shift+0x270>
     26c:	685f6f73 	ldmdavs	pc, {r0, r1, r4, r5, r6, r8, r9, sl, fp, sp, lr}^	; <UNPREDICTABLE>
     270:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     274:	5f5f0065 	svcpl	0x005f0065
     278:	524f5444 	subpl	r5, pc, #68, 8	; 0x44000000
     27c:	53494c5f 	movtpl	r4, #40031	; 0x9c5f
     280:	005f5f54 	subseq	r5, pc, r4, asr pc	; <UNPREDICTABLE>
     284:	78635f5f 	stmdavc	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, sl, fp, ip, lr}^
     288:	75675f61 	strbvc	r5, [r7, #-3937]!	; 0xfffff09f
     28c:	5f647261 	svcpl	0x00647261
     290:	726f6261 	rsbvc	r6, pc, #268435462	; 0x10000006
     294:	74640074 	strbtvc	r0, [r4], #-116	; 0xffffff8c
     298:	705f726f 	subsvc	r7, pc, pc, ror #4
     29c:	5f007274 	svcpl	0x00007274
     2a0:	4f54445f 	svcmi	0x0054445f
     2a4:	4e455f52 	mcrmi	15, 2, r5, cr5, cr2, {2}
     2a8:	005f5f44 	subseq	r5, pc, r4, asr #30
     2ac:	78635f5f 	stmdavc	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, sl, fp, ip, lr}^
     2b0:	74615f61 	strbtvc	r5, [r1], #-3937	; 0xfffff09f
     2b4:	74697865 	strbtvc	r7, [r9], #-2149	; 0xfffff79b
     2b8:	6e6f6c00 	cdpvs	12, 6, cr6, cr15, cr0, {0}
     2bc:	6f6c2067 	svcvs	0x006c2067
     2c0:	6920676e 	stmdbvs	r0!, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}
     2c4:	5f00746e 	svcpl	0x0000746e
     2c8:	5f707063 	svcpl	0x00707063
     2cc:	72617473 	rsbvc	r7, r1, #1929379840	; 0x73000000
     2d0:	00707574 	rsbseq	r7, r0, r4, ror r5
     2d4:	20554e47 	subscs	r4, r5, r7, asr #28
     2d8:	312b2b43 			; <UNDEFINED> instruction: 0x312b2b43
     2dc:	30312034 	eorscc	r2, r1, r4, lsr r0
     2e0:	312e332e 			; <UNDEFINED> instruction: 0x312e332e
     2e4:	32303220 	eorscc	r3, r0, #32, 4
     2e8:	32363031 	eorscc	r3, r6, #49	; 0x31
     2ec:	72282031 	eorvc	r2, r8, #49	; 0x31
     2f0:	61656c65 	cmnvs	r5, r5, ror #24
     2f4:	20296573 	eorcs	r6, r9, r3, ror r5
     2f8:	6c666d2d 	stclvs	13, cr6, [r6], #-180	; 0xffffff4c
     2fc:	2d74616f 	ldfcse	f6, [r4, #-444]!	; 0xfffffe44
     300:	3d696261 	sfmcc	f6, 2, [r9, #-388]!	; 0xfffffe7c
     304:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
     308:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
     30c:	763d7570 			; <UNDEFINED> instruction: 0x763d7570
     310:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
     314:	6f6c666d 	svcvs	0x006c666d
     318:	612d7461 			; <UNDEFINED> instruction: 0x612d7461
     31c:	683d6962 	ldmdavs	sp!, {r1, r5, r6, r8, fp, sp, lr}
     320:	20647261 	rsbcs	r7, r4, r1, ror #4
     324:	70666d2d 	rsbvc	r6, r6, sp, lsr #26
     328:	66763d75 			; <UNDEFINED> instruction: 0x66763d75
     32c:	6d2d2070 	stcvs	0, cr2, [sp, #-448]!	; 0xfffffe40
     330:	656e7574 	strbvs	r7, [lr, #-1396]!	; 0xfffffa8c
     334:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
     338:	36373131 			; <UNDEFINED> instruction: 0x36373131
     33c:	2d667a6a 	vstmdbcs	r6!, {s15-s120}
     340:	6d2d2073 	stcvs	0, cr2, [sp, #-460]!	; 0xfffffe34
     344:	206d7261 	rsbcs	r7, sp, r1, ror #4
     348:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
     34c:	613d6863 	teqvs	sp, r3, ror #16
     350:	36766d72 			; <UNDEFINED> instruction: 0x36766d72
     354:	662b6b7a 			; <UNDEFINED> instruction: 0x662b6b7a
     358:	672d2070 			; <UNDEFINED> instruction: 0x672d2070
     35c:	20672d20 	rsbcs	r2, r7, r0, lsr #26
     360:	20304f2d 	eorscs	r4, r0, sp, lsr #30
     364:	20304f2d 	eorscs	r4, r0, sp, lsr #30
     368:	6f6e662d 	svcvs	0x006e662d
     36c:	6378652d 	cmnvs	r8, #188743680	; 0xb400000
     370:	69747065 	ldmdbvs	r4!, {r0, r2, r5, r6, ip, sp, lr}^
     374:	20736e6f 	rsbscs	r6, r3, pc, ror #28
     378:	6f6e662d 	svcvs	0x006e662d
     37c:	7474722d 	ldrbtvc	r7, [r4], #-557	; 0xfffffdd3
     380:	5f5f0069 	svcpl	0x005f0069
     384:	524f5443 	subpl	r5, pc, #1124073472	; 0x43000000
     388:	53494c5f 	movtpl	r4, #40031	; 0x9c5f
     38c:	005f5f54 	subseq	r5, pc, r4, asr pc	; <UNPREDICTABLE>
     390:	726f7463 	rsbvc	r7, pc, #1660944384	; 0x63000000
     394:	7274705f 	rsbsvc	r7, r4, #95	; 0x5f
     398:	635f5f00 	cmpvs	pc, #0, 30
     39c:	675f6178 			; <UNDEFINED> instruction: 0x675f6178
     3a0:	64726175 	ldrbtvs	r6, [r2], #-373	; 0xfffffe8b
     3a4:	7163615f 	cmnvc	r3, pc, asr r1
     3a8:	65726975 	ldrbvs	r6, [r2, #-2421]!	; 0xfffff68b
     3ac:	6f687300 	svcvs	0x00687300
     3b0:	75207472 	strvc	r7, [r0, #-1138]!	; 0xfffffb8e
     3b4:	6769736e 	strbvs	r7, [r9, -lr, ror #6]!
     3b8:	2064656e 	rsbcs	r6, r4, lr, ror #10
     3bc:	00746e69 	rsbseq	r6, r4, r9, ror #28
     3c0:	4678614d 	ldrbtmi	r6, [r8], -sp, asr #2
     3c4:	6e656c69 	cdpvs	12, 6, cr6, cr5, cr9, {3}
     3c8:	4c656d61 	stclmi	13, cr6, [r5], #-388	; 0xfffffe7c
     3cc:	74676e65 	strbtvc	r6, [r7], #-3685	; 0xfffff19b
     3d0:	72610068 	rsbvc	r0, r1, #104	; 0x68
     3d4:	4c006367 	stcmi	3, cr6, [r0], {103}	; 0x67
     3d8:	5f6b636f 	svcpl	0x006b636f
     3dc:	6f6c6e55 	svcvs	0x006c6e55
     3e0:	64656b63 	strbtvs	r6, [r5], #-2915	; 0xfffff49d
     3e4:	766e4900 	strbtvc	r4, [lr], -r0, lsl #18
     3e8:	64696c61 	strbtvs	r6, [r9], #-3169	; 0xfffff39f
     3ec:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     3f0:	00656c64 	rsbeq	r6, r5, r4, ror #24
     3f4:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
     3f8:	552f632f 	strpl	r6, [pc, #-815]!	; d1 <shift+0xd1>
     3fc:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
     400:	62754b2f 	rsbsvs	r4, r5, #48128	; 0xbc00
     404:	6f442f61 	svcvs	0x00442f61
     408:	656d7563 	strbvs	r7, [sp, #-1379]!	; 0xfffffa9d
     40c:	2f73746e 	svccs	0x0073746e
     410:	6f72655a 	svcvs	0x0072655a
     414:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
     418:	6178652f 	cmnvs	r8, pc, lsr #10
     41c:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
     420:	38312f73 	ldmdacc	r1!, {r0, r1, r4, r5, r6, r8, r9, sl, fp, sp}
     424:	6664652d 	strbtvs	r6, [r4], -sp, lsr #10
     428:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
     42c:	61707372 	cmnvs	r0, r2, ror r3
     430:	692f6563 	stmdbvs	pc!, {r0, r1, r5, r6, r8, sl, sp, lr}	; <UNPREDICTABLE>
     434:	5f74696e 	svcpl	0x0074696e
     438:	6b736174 	blvs	1cd8a10 <__bss_end+0x1ccfc18>
     43c:	69616d2f 	stmdbvs	r1!, {r0, r1, r2, r3, r5, r8, sl, fp, sp, lr}^
     440:	70632e6e 	rsbvc	r2, r3, lr, ror #28
     444:	6f620070 	svcvs	0x00620070
     448:	44006c6f 	strmi	r6, [r0], #-3183	; 0xfffff391
     44c:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
     450:	5f656e69 	svcpl	0x00656e69
     454:	68636e55 	stmdavs	r3!, {r0, r2, r4, r6, r9, sl, fp, sp, lr}^
     458:	65676e61 	strbvs	r6, [r7, #-3681]!	; 0xfffff19f
     45c:	6f4e0064 	svcvs	0x004e0064
     460:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     464:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     468:	72446d65 	subvc	r6, r4, #6464	; 0x1940
     46c:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
     470:	736e7500 	cmnvc	lr, #0, 10
     474:	656e6769 	strbvs	r6, [lr, #-1897]!	; 0xfffff897
     478:	68632064 	stmdavs	r3!, {r2, r5, r6, sp}^
     47c:	4e007261 	cdpmi	2, 0, cr7, cr0, cr1, {3}
     480:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     484:	6c6c4179 	stfvse	f4, [ip], #-484	; 0xfffffe1c
     488:	6e697500 	cdpvs	5, 6, cr7, cr9, cr0, {0}
     48c:	5f323374 	svcpl	0x00323374
     490:	6f4c0074 	svcvs	0x004c0074
     494:	4c5f6b63 	mrrcmi	11, 6, r6, pc, cr3	; <UNPREDICTABLE>
     498:	656b636f 	strbvs	r6, [fp, #-879]!	; 0xfffffc91
     49c:	6e490064 	cdpvs	0, 4, cr0, cr9, cr4, {3}
     4a0:	69666564 	stmdbvs	r6!, {r2, r5, r6, r8, sl, sp, lr}^
     4a4:	6574696e 	ldrbvs	r6, [r4, #-2414]!	; 0xfffff692
     4a8:	78614d00 	stmdavc	r1!, {r8, sl, fp, lr}^
     4ac:	6f72505f 	svcvs	0x0072505f
     4b0:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     4b4:	65704f5f 	ldrbvs	r4, [r0, #-3935]!	; 0xfffff0a1
     4b8:	5f64656e 	svcpl	0x0064656e
     4bc:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     4c0:	614d0073 	hvcvs	53251	; 0xd003
     4c4:	74615078 	strbtvc	r5, [r1], #-120	; 0xffffff88
     4c8:	6e654c68 	cdpvs	12, 6, cr4, cr5, cr8, {3}
     4cc:	00687467 	rsbeq	r7, r8, r7, ror #8
     4d0:	726f6873 	rsbvc	r6, pc, #7536640	; 0x730000
     4d4:	6e692074 	mcrvs	0, 3, r2, cr9, cr4, {3}
     4d8:	614d0074 	hvcvs	53252	; 0xd004
     4dc:	44534678 	ldrbmi	r4, [r3], #-1656	; 0xfffff988
     4e0:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
     4e4:	6d614e72 	stclvs	14, cr4, [r1, #-456]!	; 0xfffffe38
     4e8:	6e654c65 	cdpvs	12, 6, cr4, cr5, cr5, {3}
     4ec:	00687467 	rsbeq	r7, r8, r7, ror #8
     4f0:	76677261 	strbtvc	r7, [r7], -r1, ror #4
     4f4:	63695400 	cmnvs	r9, #0, 8
     4f8:	6f435f6b 	svcvs	0x00435f6b
     4fc:	00746e75 	rsbseq	r6, r4, r5, ror lr
     500:	6e65704f 	cdpvs	0, 6, cr7, cr5, cr15, {2}
     504:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     508:	50433631 	subpl	r3, r3, r1, lsr r6
     50c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     510:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 34c <shift+0x34c>
     514:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     518:	31327265 	teqcc	r2, r5, ror #4
     51c:	636f6c42 	cmnvs	pc, #16896	; 0x4200
     520:	75435f6b 	strbvc	r5, [r3, #-3947]	; 0xfffff095
     524:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
     528:	72505f74 	subsvc	r5, r0, #116, 30	; 0x1d0
     52c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     530:	00764573 	rsbseq	r4, r6, r3, ror r5
     534:	736f6c63 	cmnvc	pc, #25344	; 0x6300
     538:	72700065 	rsbsvc	r0, r0, #101	; 0x65
     53c:	53007665 	movwpl	r7, #1637	; 0x665
     540:	525f7465 	subspl	r7, pc, #1694498816	; 0x65000000
     544:	74616c65 	strbtvc	r6, [r1], #-3173	; 0xfffff39b
     548:	00657669 	rsbeq	r7, r5, r9, ror #12
     54c:	616d6e55 	cmnvs	sp, r5, asr lr
     550:	69465f70 	stmdbvs	r6, {r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     554:	435f656c 	cmpmi	pc, #108, 10	; 0x1b000000
     558:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     55c:	7200746e 	andvc	r7, r0, #1845493760	; 0x6e000000
     560:	61767465 	cmnvs	r6, r5, ror #8
     564:	636e006c 	cmnvs	lr, #108	; 0x6c
     568:	6d007275 	sfmvs	f7, 4, [r0, #-468]	; 0xfffffe2c
     56c:	636f7250 	cmnvs	pc, #80, 4
     570:	5f737365 	svcpl	0x00737365
     574:	7473694c 	ldrbtvc	r6, [r3], #-2380	; 0xfffff6b4
     578:	6165485f 	cmnvs	r5, pc, asr r8
     57c:	69700064 	ldmdbvs	r0!, {r2, r5, r6}^
     580:	5f006570 	svcpl	0x00006570
     584:	314b4e5a 	cmpcc	fp, sl, asr lr
     588:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     58c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     590:	614d5f73 	hvcvs	54771	; 0xd5f3
     594:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     598:	47393172 			; <UNDEFINED> instruction: 0x47393172
     59c:	435f7465 	cmpmi	pc, #1694498816	; 0x65000000
     5a0:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     5a4:	505f746e 	subspl	r7, pc, lr, ror #8
     5a8:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     5ac:	76457373 			; <UNDEFINED> instruction: 0x76457373
     5b0:	6e647200 	cdpvs	2, 6, cr7, cr4, cr0, {0}
     5b4:	6e006d75 	mcrvs	13, 0, r6, cr0, cr5, {3}
     5b8:	00747865 	rsbseq	r7, r4, r5, ror #16
     5bc:	5f746547 	svcpl	0x00746547
     5c0:	636f7250 	cmnvs	pc, #80, 4
     5c4:	5f737365 	svcpl	0x00737365
     5c8:	505f7942 	subspl	r7, pc, r2, asr #18
     5cc:	5f004449 	svcpl	0x00004449
     5d0:	7331315a 	teqvc	r1, #-2147483626	; 0x80000016
     5d4:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     5d8:	6569795f 	strbvs	r7, [r9, #-2399]!	; 0xfffff6a1
     5dc:	0076646c 	rsbseq	r6, r6, ip, ror #8
     5e0:	4957534e 	ldmdbmi	r7, {r1, r2, r3, r6, r8, r9, ip, lr}^
     5e4:	6f72505f 	svcvs	0x0072505f
     5e8:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     5ec:	7265535f 	rsbvc	r5, r5, #2080374785	; 0x7c000001
     5f0:	65636976 	strbvs	r6, [r3, #-2422]!	; 0xfffff68a
     5f4:	61655200 	cmnvs	r5, r0, lsl #4
     5f8:	63410064 	movtvs	r0, #4196	; 0x1064
     5fc:	65766974 	ldrbvs	r6, [r6, #-2420]!	; 0xfffff68c
     600:	6f72505f 	svcvs	0x0072505f
     604:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     608:	756f435f 	strbvc	r4, [pc, #-863]!	; 2b1 <shift+0x2b1>
     60c:	4300746e 	movwmi	r7, #1134	; 0x46e
     610:	74616572 	strbtvc	r6, [r1], #-1394	; 0xfffffa8e
     614:	72505f65 	subsvc	r5, r0, #404	; 0x194
     618:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     61c:	5a5f0073 	bpl	17c07f0 <__bss_end+0x17b79f8>
     620:	65733731 	ldrbvs	r3, [r3, #-1841]!	; 0xfffff8cf
     624:	61745f74 	cmnvs	r4, r4, ror pc
     628:	645f6b73 	ldrbvs	r6, [pc], #-2931	; 630 <shift+0x630>
     62c:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
     630:	6a656e69 	bvs	195bfdc <__bss_end+0x19531e4>
     634:	69617700 	stmdbvs	r1!, {r8, r9, sl, ip, sp, lr}^
     638:	74730074 	ldrbtvc	r0, [r3], #-116	; 0xffffff8c
     63c:	00657461 	rsbeq	r7, r5, r1, ror #8
     640:	6e365a5f 			; <UNDEFINED> instruction: 0x6e365a5f
     644:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     648:	006a6a79 	rsbeq	r6, sl, r9, ror sl
     64c:	5f746547 	svcpl	0x00746547
     650:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     654:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     658:	6e495f72 	mcrvs	15, 2, r5, cr9, cr2, {3}
     65c:	43006f66 	movwmi	r6, #3942	; 0xf66
     660:	636f7250 	cmnvs	pc, #80, 4
     664:	5f737365 	svcpl	0x00737365
     668:	616e614d 	cmnvs	lr, sp, asr #2
     66c:	00726567 	rsbseq	r6, r2, r7, ror #10
     670:	314e5a5f 	cmpcc	lr, pc, asr sl
     674:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     678:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     67c:	614d5f73 	hvcvs	54771	; 0xd5f3
     680:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     684:	47383172 			; <UNDEFINED> instruction: 0x47383172
     688:	535f7465 	cmppl	pc, #1694498816	; 0x65000000
     68c:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     690:	72656c75 	rsbvc	r6, r5, #29952	; 0x7500
     694:	666e495f 			; <UNDEFINED> instruction: 0x666e495f
     698:	3032456f 	eorscc	r4, r2, pc, ror #10
     69c:	7465474e 	strbtvc	r4, [r5], #-1870	; 0xfffff8b2
     6a0:	6863535f 	stmdavs	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     6a4:	495f6465 	ldmdbmi	pc, {r0, r2, r5, r6, sl, sp, lr}^	; <UNPREDICTABLE>
     6a8:	5f6f666e 	svcpl	0x006f666e
     6ac:	65707954 	ldrbvs	r7, [r0, #-2388]!	; 0xfffff6ac
     6b0:	5f007650 	svcpl	0x00007650
     6b4:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     6b8:	6f725043 	svcvs	0x00725043
     6bc:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     6c0:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     6c4:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     6c8:	61483132 	cmpvs	r8, r2, lsr r1
     6cc:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     6d0:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     6d4:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     6d8:	5f6d6574 	svcpl	0x006d6574
     6dc:	45495753 	strbmi	r5, [r9, #-1875]	; 0xfffff8ad
     6e0:	534e3332 	movtpl	r3, #58162	; 0xe332
     6e4:	465f4957 			; <UNDEFINED> instruction: 0x465f4957
     6e8:	73656c69 	cmnvc	r5, #26880	; 0x6900
     6ec:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     6f0:	65535f6d 	ldrbvs	r5, [r3, #-3949]	; 0xfffff093
     6f4:	63697672 	cmnvs	r9, #119537664	; 0x7200000
     6f8:	6a6a6a65 	bvs	1a9b094 <__bss_end+0x1a9229c>
     6fc:	54313152 	ldrtpl	r3, [r1], #-338	; 0xfffffeae
     700:	5f495753 	svcpl	0x00495753
     704:	75736552 	ldrbvc	r6, [r3, #-1362]!	; 0xfffffaae
     708:	6f00746c 	svcvs	0x0000746c
     70c:	656e6570 	strbvs	r6, [lr, #-1392]!	; 0xfffffa90
     710:	69665f64 	stmdbvs	r6!, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     714:	0073656c 	rsbseq	r6, r3, ip, ror #10
     718:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
     71c:	552f632f 	strpl	r6, [pc, #-815]!	; 3f5 <shift+0x3f5>
     720:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
     724:	62754b2f 	rsbsvs	r4, r5, #48128	; 0xbc00
     728:	6f442f61 	svcvs	0x00442f61
     72c:	656d7563 	strbvs	r7, [sp, #-1379]!	; 0xfffffa9d
     730:	2f73746e 	svccs	0x0073746e
     734:	6f72655a 	svcvs	0x0072655a
     738:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
     73c:	6178652f 	cmnvs	r8, pc, lsr #10
     740:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
     744:	38312f73 	ldmdacc	r1!, {r0, r1, r4, r5, r6, r8, r9, sl, fp, sp}
     748:	6664652d 	strbtvs	r6, [r4], -sp, lsr #10
     74c:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
     750:	2f62696c 	svccs	0x0062696c
     754:	2f637273 	svccs	0x00637273
     758:	66647473 			; <UNDEFINED> instruction: 0x66647473
     75c:	2e656c69 	cdpcs	12, 6, cr6, cr5, cr9, {3}
     760:	00707063 	rsbseq	r7, r0, r3, rrx
     764:	6c696146 	stfvse	f6, [r9], #-280	; 0xfffffee8
     768:	50435400 	subpl	r5, r3, r0, lsl #8
     76c:	6f435f55 	svcvs	0x00435f55
     770:	7865746e 	stmdavc	r5!, {r1, r2, r3, r5, r6, sl, ip, sp, lr}^
     774:	65440074 	strbvs	r0, [r4, #-116]	; 0xffffff8c
     778:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
     77c:	6500656e 	strvs	r6, [r0, #-1390]	; 0xfffffa92
     780:	63746978 	cmnvs	r4, #120, 18	; 0x1e0000
     784:	0065646f 	rsbeq	r6, r5, pc, ror #8
     788:	72627474 	rsbvc	r7, r2, #116, 8	; 0x74000000
     78c:	5a5f0030 	bpl	17c0854 <__bss_end+0x17b7a5c>
     790:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     794:	636f7250 	cmnvs	pc, #80, 4
     798:	5f737365 	svcpl	0x00737365
     79c:	616e614d 	cmnvs	lr, sp, asr #2
     7a0:	31726567 	cmncc	r2, r7, ror #10
     7a4:	746f4e34 	strbtvc	r4, [pc], #-3636	; 7ac <shift+0x7ac>
     7a8:	5f796669 	svcpl	0x00796669
     7ac:	636f7250 	cmnvs	pc, #80, 4
     7b0:	45737365 	ldrbmi	r7, [r3, #-869]!	; 0xfffffc9b
     7b4:	6547006a 	strbvs	r0, [r7, #-106]	; 0xffffff96
     7b8:	49505f74 	ldmdbmi	r0, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     7bc:	6f6e0044 	svcvs	0x006e0044
     7c0:	69666974 	stmdbvs	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     7c4:	645f6465 	ldrbvs	r6, [pc], #-1125	; 7cc <shift+0x7cc>
     7c8:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
     7cc:	00656e69 	rsbeq	r6, r5, r9, ror #28
     7d0:	314e5a5f 	cmpcc	lr, pc, asr sl
     7d4:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     7d8:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     7dc:	614d5f73 	hvcvs	54771	; 0xd5f3
     7e0:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     7e4:	55383172 	ldrpl	r3, [r8, #-370]!	; 0xfffffe8e
     7e8:	70616d6e 	rsbvc	r6, r1, lr, ror #26
     7ec:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     7f0:	75435f65 	strbvc	r5, [r3, #-3941]	; 0xfffff09b
     7f4:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
     7f8:	006a4574 	rsbeq	r4, sl, r4, ror r5
     7fc:	314e5a5f 	cmpcc	lr, pc, asr sl
     800:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     804:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     808:	614d5f73 	hvcvs	54771	; 0xd5f3
     80c:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     810:	4e343172 	mrcmi	1, 1, r3, cr4, cr2, {3}
     814:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     818:	72505f79 	subsvc	r5, r0, #484	; 0x1e4
     81c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     820:	31504573 	cmpcc	r0, r3, ror r5
     824:	61545432 	cmpvs	r4, r2, lsr r4
     828:	535f6b73 	cmppl	pc, #117760	; 0x1cc00
     82c:	63757274 	cmnvs	r5, #116, 4	; 0x40000007
     830:	63730074 	cmnvs	r3, #116	; 0x74
     834:	5f646568 	svcpl	0x00646568
     838:	6c656979 			; <UNDEFINED> instruction: 0x6c656979
     83c:	69740064 	ldmdbvs	r4!, {r2, r5, r6}^
     840:	635f6b63 	cmpvs	pc, #101376	; 0x18c00
     844:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
     848:	7165725f 	cmnvc	r5, pc, asr r2
     84c:	65726975 	ldrbvs	r6, [r2, #-2421]!	; 0xfffff68b
     850:	6f5a0064 	svcvs	0x005a0064
     854:	6569626d 	strbvs	r6, [r9, #-621]!	; 0xfffffd93
     858:	325a5f00 	subscc	r5, sl, #0, 30
     85c:	74656734 	strbtvc	r6, [r5], #-1844	; 0xfffff8cc
     860:	7463615f 	strbtvc	r6, [r3], #-351	; 0xfffffea1
     864:	5f657669 	svcpl	0x00657669
     868:	636f7270 	cmnvs	pc, #112, 4
     86c:	5f737365 	svcpl	0x00737365
     870:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
     874:	47007674 	smlsdxmi	r0, r4, r6, r7
     878:	435f7465 	cmpmi	pc, #1694498816	; 0x65000000
     87c:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     880:	505f746e 	subspl	r7, pc, lr, ror #8
     884:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     888:	50007373 	andpl	r7, r0, r3, ror r3
     88c:	5f657069 	svcpl	0x00657069
     890:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     894:	6572505f 	ldrbvs	r5, [r2, #-95]!	; 0xffffffa1
     898:	00786966 	rsbseq	r6, r8, r6, ror #18
     89c:	5f70614d 	svcpl	0x0070614d
     8a0:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     8a4:	5f6f545f 	svcpl	0x006f545f
     8a8:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
     8ac:	00746e65 	rsbseq	r6, r4, r5, ror #28
     8b0:	5f746553 	svcpl	0x00746553
     8b4:	61726150 	cmnvs	r2, r0, asr r1
     8b8:	5f00736d 	svcpl	0x0000736d
     8bc:	6734315a 			; <UNDEFINED> instruction: 0x6734315a
     8c0:	745f7465 	ldrbvc	r7, [pc], #-1125	; 8c8 <shift+0x8c8>
     8c4:	5f6b6369 	svcpl	0x006b6369
     8c8:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
     8cc:	48007674 	stmdami	r0, {r2, r4, r5, r6, r9, sl, ip, sp, lr}
     8d0:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     8d4:	72505f65 	subsvc	r5, r0, #404	; 0x194
     8d8:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     8dc:	57535f73 			; <UNDEFINED> instruction: 0x57535f73
     8e0:	6c730049 	ldclvs	0, cr0, [r3], #-292	; 0xfffffedc
     8e4:	00706565 	rsbseq	r6, r0, r5, ror #10
     8e8:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     8ec:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     8f0:	4644455f 			; <UNDEFINED> instruction: 0x4644455f
     8f4:	69615700 	stmdbvs	r1!, {r8, r9, sl, ip, lr}^
     8f8:	69440074 	stmdbvs	r4, {r2, r4, r5, r6}^
     8fc:	6c626173 	stfvse	f6, [r2], #-460	; 0xfffffe34
     900:	76455f65 	strbvc	r5, [r5], -r5, ror #30
     904:	5f746e65 	svcpl	0x00746e65
     908:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
     90c:	6f697463 	svcvs	0x00697463
     910:	5a5f006e 	bpl	17c0ad0 <__bss_end+0x17b7cd8>
     914:	72657439 	rsbvc	r7, r5, #956301312	; 0x39000000
     918:	616e696d 	cmnvs	lr, sp, ror #18
     91c:	00696574 	rsbeq	r6, r9, r4, ror r5
     920:	65746e49 	ldrbvs	r6, [r4, #-3657]!	; 0xfffff1b7
     924:	70757272 	rsbsvc	r7, r5, r2, ror r2
     928:	6c626174 	stfvse	f6, [r2], #-464	; 0xfffffe30
     92c:	6c535f65 	mrrcvs	15, 6, r5, r3, cr5
     930:	00706565 	rsbseq	r6, r0, r5, ror #10
     934:	7265706f 	rsbvc	r7, r5, #111	; 0x6f
     938:	6f697461 	svcvs	0x00697461
     93c:	5a5f006e 	bpl	17c0afc <__bss_end+0x17b7d04>
     940:	6f6c6335 	svcvs	0x006c6335
     944:	006a6573 	rsbeq	r6, sl, r3, ror r5
     948:	73614c6d 	cmnvc	r1, #27904	; 0x6d00
     94c:	49505f74 	ldmdbmi	r0, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     950:	6c420044 	mcrrvs	0, 4, r0, r2, cr4
     954:	656b636f 	strbvs	r6, [fp, #-879]!	; 0xfffffc91
     958:	474e0064 	strbmi	r0, [lr, -r4, rrx]
     95c:	535f7465 	cmppl	pc, #1694498816	; 0x65000000
     960:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     964:	666e495f 			; <UNDEFINED> instruction: 0x666e495f
     968:	79545f6f 	ldmdbvc	r4, {r0, r1, r2, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
     96c:	5f006570 	svcpl	0x00006570
     970:	6567365a 	strbvs	r3, [r7, #-1626]!	; 0xfffff9a6
     974:	64697074 	strbtvs	r7, [r9], #-116	; 0xffffff8c
     978:	6e660076 	mcrvs	0, 3, r0, cr6, cr6, {3}
     97c:	00656d61 	rsbeq	r6, r5, r1, ror #26
     980:	6e6e7552 	mcrvs	5, 3, r7, cr14, cr2, {2}
     984:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     988:	61544e00 	cmpvs	r4, r0, lsl #28
     98c:	535f6b73 	cmppl	pc, #117760	; 0x1cc00
     990:	65746174 	ldrbvs	r6, [r4, #-372]!	; 0xfffffe8c
     994:	68637300 	stmdavs	r3!, {r8, r9, ip, sp, lr}^
     998:	635f6465 	cmpvs	pc, #1694498816	; 0x65000000
     99c:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
     9a0:	47007265 	strmi	r7, [r0, -r5, ror #4]
     9a4:	4320554e 			; <UNDEFINED> instruction: 0x4320554e
     9a8:	34312b2b 	ldrtcc	r2, [r1], #-2859	; 0xfffff4d5
     9ac:	2e303120 	rsfcssp	f3, f0, f0
     9b0:	20312e33 	eorscs	r2, r1, r3, lsr lr
     9b4:	31323032 	teqcc	r2, r2, lsr r0
     9b8:	31323630 	teqcc	r2, r0, lsr r6
     9bc:	65722820 	ldrbvs	r2, [r2, #-2080]!	; 0xfffff7e0
     9c0:	7361656c 	cmnvc	r1, #108, 10	; 0x1b000000
     9c4:	2d202965 			; <UNDEFINED> instruction: 0x2d202965
     9c8:	6f6c666d 	svcvs	0x006c666d
     9cc:	612d7461 			; <UNDEFINED> instruction: 0x612d7461
     9d0:	683d6962 	ldmdavs	sp!, {r1, r5, r6, r8, fp, sp, lr}
     9d4:	20647261 	rsbcs	r7, r4, r1, ror #4
     9d8:	70666d2d 	rsbvc	r6, r6, sp, lsr #26
     9dc:	66763d75 			; <UNDEFINED> instruction: 0x66763d75
     9e0:	6d2d2070 	stcvs	0, cr2, [sp, #-448]!	; 0xfffffe40
     9e4:	616f6c66 	cmnvs	pc, r6, ror #24
     9e8:	62612d74 	rsbvs	r2, r1, #116, 26	; 0x1d00
     9ec:	61683d69 	cmnvs	r8, r9, ror #26
     9f0:	2d206472 	cfstrscs	mvf6, [r0, #-456]!	; 0xfffffe38
     9f4:	7570666d 	ldrbvc	r6, [r0, #-1645]!	; 0xfffff993
     9f8:	7066763d 	rsbvc	r7, r6, sp, lsr r6
     9fc:	746d2d20 	strbtvc	r2, [sp], #-3360	; 0xfffff2e0
     a00:	3d656e75 	stclcc	14, cr6, [r5, #-468]!	; 0xfffffe2c
     a04:	316d7261 	cmncc	sp, r1, ror #4
     a08:	6a363731 	bvs	d8e6d4 <__bss_end+0xd858dc>
     a0c:	732d667a 			; <UNDEFINED> instruction: 0x732d667a
     a10:	616d2d20 	cmnvs	sp, r0, lsr #26
     a14:	2d206d72 	stccs	13, cr6, [r0, #-456]!	; 0xfffffe38
     a18:	6372616d 	cmnvs	r2, #1073741851	; 0x4000001b
     a1c:	72613d68 	rsbvc	r3, r1, #104, 26	; 0x1a00
     a20:	7a36766d 	bvc	d9e3dc <__bss_end+0xd955e4>
     a24:	70662b6b 	rsbvc	r2, r6, fp, ror #22
     a28:	20672d20 	rsbcs	r2, r7, r0, lsr #26
     a2c:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
     a30:	4f2d2067 	svcmi	0x002d2067
     a34:	4f2d2030 	svcmi	0x002d2030
     a38:	662d2030 			; <UNDEFINED> instruction: 0x662d2030
     a3c:	652d6f6e 	strvs	r6, [sp, #-3950]!	; 0xfffff092
     a40:	70656378 	rsbvc	r6, r5, r8, ror r3
     a44:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     a48:	662d2073 			; <UNDEFINED> instruction: 0x662d2073
     a4c:	722d6f6e 	eorvc	r6, sp, #440	; 0x1b8
     a50:	00697474 	rsbeq	r7, r9, r4, ror r4
     a54:	74697277 	strbtvc	r7, [r9], #-631	; 0xfffffd89
     a58:	78650065 	stmdavc	r5!, {r0, r2, r5, r6}^
     a5c:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
     a60:	0065646f 	rsbeq	r6, r5, pc, ror #8
     a64:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
     a68:	74735f64 	ldrbtvc	r5, [r3], #-3940	; 0xfffff09c
     a6c:	63697461 	cmnvs	r9, #1627389952	; 0x61000000
     a70:	6972705f 	ldmdbvs	r2!, {r0, r1, r2, r3, r4, r6, ip, sp, lr}^
     a74:	7469726f 	strbtvc	r7, [r9], #-623	; 0xfffffd91
     a78:	69740079 	ldmdbvs	r4!, {r0, r3, r4, r5, r6}^
     a7c:	00736b63 	rsbseq	r6, r3, r3, ror #22
     a80:	6863536d 	stmdavs	r3!, {r0, r2, r3, r5, r6, r8, r9, ip, lr}^
     a84:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     a88:	6e465f65 	cdpvs	15, 4, cr5, cr6, cr5, {3}
     a8c:	706f0063 	rsbvc	r0, pc, r3, rrx
     a90:	5f006e65 	svcpl	0x00006e65
     a94:	6970345a 	ldmdbvs	r0!, {r1, r3, r4, r6, sl, ip, sp}^
     a98:	4b506570 	blmi	141a060 <__bss_end+0x1411268>
     a9c:	4e006a63 	vmlsmi.f32	s12, s0, s7
     aa0:	64616544 	strbtvs	r6, [r1], #-1348	; 0xfffffabc
     aa4:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
     aa8:	6275535f 	rsbsvs	r5, r5, #2080374785	; 0x7c000001
     aac:	76726573 			; <UNDEFINED> instruction: 0x76726573
     ab0:	00656369 	rsbeq	r6, r5, r9, ror #6
     ab4:	5f746567 	svcpl	0x00746567
     ab8:	6b636974 	blvs	18db090 <__bss_end+0x18d2298>
     abc:	756f635f 	strbvc	r6, [pc, #-863]!	; 765 <shift+0x765>
     ac0:	4e00746e 	cdpmi	4, 0, cr7, cr0, cr14, {3}
     ac4:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     ac8:	61700079 	cmnvs	r0, r9, ror r0
     acc:	006d6172 	rsbeq	r6, sp, r2, ror r1
     ad0:	77355a5f 			; <UNDEFINED> instruction: 0x77355a5f
     ad4:	65746972 	ldrbvs	r6, [r4, #-2418]!	; 0xfffff68e
     ad8:	634b506a 	movtvs	r5, #45162	; 0xb06a
     adc:	6567006a 	strbvs	r0, [r7, #-106]!	; 0xffffff96
     ae0:	61745f74 	cmnvs	r4, r4, ror pc
     ae4:	745f6b73 	ldrbvc	r6, [pc], #-2931	; aec <shift+0xaec>
     ae8:	736b6369 	cmnvc	fp, #-1543503871	; 0xa4000001
     aec:	5f6f745f 	svcpl	0x006f745f
     af0:	64616564 	strbtvs	r6, [r1], #-1380	; 0xfffffa9c
     af4:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
     af8:	66756200 	ldrbtvs	r6, [r5], -r0, lsl #4
     afc:	7a69735f 	bvc	1a5d880 <__bss_end+0x1a54a88>
     b00:	65520065 	ldrbvs	r0, [r2, #-101]	; 0xffffff9b
     b04:	575f6461 	ldrbpl	r6, [pc, -r1, ror #8]
     b08:	65746972 	ldrbvs	r6, [r4, #-2418]!	; 0xfffff68e
     b0c:	6e6d2f00 	cdpvs	15, 6, cr2, cr13, cr0, {0}
     b10:	2f632f74 	svccs	0x00632f74
     b14:	72657355 	rsbvc	r7, r5, #1409286145	; 0x54000001
     b18:	754b2f73 	strbvc	r2, [fp, #-3955]	; 0xfffff08d
     b1c:	442f6162 	strtmi	r6, [pc], #-354	; b24 <shift+0xb24>
     b20:	6d75636f 	ldclvs	3, cr6, [r5, #-444]!	; 0xfffffe44
     b24:	73746e65 	cmnvc	r4, #1616	; 0x650
     b28:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
     b2c:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
     b30:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
     b34:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
     b38:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
     b3c:	64652d38 	strbtvs	r2, [r5], #-3384	; 0xfffff2c8
     b40:	75622f66 	strbvc	r2, [r2, #-3942]!	; 0xfffff09a
     b44:	00646c69 	rsbeq	r6, r4, r9, ror #24
     b48:	5f746547 	svcpl	0x00746547
     b4c:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     b50:	6e495f64 	cdpvs	15, 4, cr5, cr9, cr4, {3}
     b54:	73006f66 	movwvc	r6, #3942	; 0xf66
     b58:	745f7465 	ldrbvc	r7, [pc], #-1125	; b60 <shift+0xb60>
     b5c:	5f6b7361 	svcpl	0x006b7361
     b60:	64616564 	strbtvs	r6, [r1], #-1380	; 0xfffffa9c
     b64:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
     b68:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     b6c:	50433631 	subpl	r3, r3, r1, lsr r6
     b70:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     b74:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 9b0 <shift+0x9b0>
     b78:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     b7c:	53387265 	teqpl	r8, #1342177286	; 0x50000006
     b80:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     b84:	45656c75 	strbmi	r6, [r5, #-3189]!	; 0xfffff38b
     b88:	5a5f0076 	bpl	17c0d68 <__bss_end+0x17b7f70>
     b8c:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     b90:	636f7250 	cmnvs	pc, #80, 4
     b94:	5f737365 	svcpl	0x00737365
     b98:	616e614d 	cmnvs	lr, sp, asr #2
     b9c:	31726567 	cmncc	r2, r7, ror #10
     ba0:	70614d39 	rsbvc	r4, r1, r9, lsr sp
     ba4:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     ba8:	6f545f65 	svcvs	0x00545f65
     bac:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     bb0:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     bb4:	49355045 	ldmdbmi	r5!, {r0, r2, r6, ip, lr}
     bb8:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     bbc:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     bc0:	7261505f 	rsbvc	r5, r1, #95	; 0x5f
     bc4:	00736d61 	rsbseq	r6, r3, r1, ror #26
     bc8:	314e5a5f 	cmpcc	lr, pc, asr sl
     bcc:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     bd0:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     bd4:	614d5f73 	hvcvs	54771	; 0xd5f3
     bd8:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     bdc:	53323172 	teqpl	r2, #-2147483620	; 0x8000001c
     be0:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     be4:	5f656c75 	svcpl	0x00656c75
     be8:	45464445 	strbmi	r4, [r6, #-1093]	; 0xfffffbbb
     bec:	5a5f0076 	bpl	17c0dcc <__bss_end+0x17b7fd4>
     bf0:	656c7335 	strbvs	r7, [ip, #-821]!	; 0xfffffccb
     bf4:	6a6a7065 	bvs	1a9cd90 <__bss_end+0x1a93f98>
     bf8:	6c696600 	stclvs	6, cr6, [r9], #-0
     bfc:	65470065 	strbvs	r0, [r7, #-101]	; 0xffffff9b
     c00:	65525f74 	ldrbvs	r5, [r2, #-3956]	; 0xfffff08c
     c04:	6e69616d 	powvsez	f6, f1, #5.0
     c08:	00676e69 	rsbeq	r6, r7, r9, ror #28
     c0c:	62616e45 	rsbvs	r6, r1, #1104	; 0x450
     c10:	455f656c 	ldrbmi	r6, [pc, #-1388]	; 6ac <shift+0x6ac>
     c14:	746e6576 	strbtvc	r6, [lr], #-1398	; 0xfffffa8a
     c18:	7465445f 	strbtvc	r4, [r5], #-1119	; 0xfffffba1
     c1c:	69746365 	ldmdbvs	r4!, {r0, r2, r5, r6, r8, r9, sp, lr}^
     c20:	5f006e6f 	svcpl	0x00006e6f
     c24:	6736325a 			; <UNDEFINED> instruction: 0x6736325a
     c28:	745f7465 	ldrbvc	r7, [pc], #-1125	; c30 <shift+0xc30>
     c2c:	5f6b7361 	svcpl	0x006b7361
     c30:	6b636974 	blvs	18db208 <__bss_end+0x18d2410>
     c34:	6f745f73 	svcvs	0x00745f73
     c38:	6165645f 	cmnvs	r5, pc, asr r4
     c3c:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
     c40:	4e007665 	cfmadd32mi	mvax3, mvfx7, mvfx0, mvfx5
     c44:	5f495753 	svcpl	0x00495753
     c48:	75736552 	ldrbvc	r6, [r3, #-1362]!	; 0xfffffaae
     c4c:	435f746c 	cmpmi	pc, #108, 8	; 0x6c000000
     c50:	0065646f 	rsbeq	r6, r5, pc, ror #8
     c54:	6e6e7552 	mcrvs	5, 3, r7, cr14, cr2, {2}
     c58:	00676e69 	rsbeq	r6, r7, r9, ror #28
     c5c:	756e7277 	strbvc	r7, [lr, #-631]!	; 0xfffffd89
     c60:	5a5f006d 	bpl	17c0e1c <__bss_end+0x17b8024>
     c64:	69617734 	stmdbvs	r1!, {r2, r4, r5, r8, r9, sl, ip, sp, lr}^
     c68:	6a6a6a74 	bvs	1a9b640 <__bss_end+0x1a92848>
     c6c:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
     c70:	74636f69 	strbtvc	r6, [r3], #-3945	; 0xfffff097
     c74:	36316a6c 	ldrtcc	r6, [r1], -ip, ror #20
     c78:	434f494e 	movtmi	r4, #63822	; 0xf94e
     c7c:	4f5f6c74 	svcmi	0x005f6c74
     c80:	61726570 	cmnvs	r2, r0, ror r5
     c84:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     c88:	69007650 	stmdbvs	r0, {r4, r6, r9, sl, ip, sp, lr}
     c8c:	6c74636f 	ldclvs	3, cr6, [r4], #-444	; 0xfffffe44
     c90:	74657200 	strbtvc	r7, [r5], #-512	; 0xfffffe00
     c94:	00746e63 	rsbseq	r6, r4, r3, ror #28
     c98:	7275436d 	rsbsvc	r4, r5, #-1275068415	; 0xb4000001
     c9c:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     ca0:	7361545f 	cmnvc	r1, #1593835520	; 0x5f000000
     ca4:	6f4e5f6b 	svcvs	0x004e5f6b
     ca8:	6e006564 	cfsh32vs	mvfx6, mvfx0, #52
     cac:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     cb0:	65740079 	ldrbvs	r0, [r4, #-121]!	; 0xffffff87
     cb4:	6e696d72 	mcrvs	13, 3, r6, cr9, cr2, {3}
     cb8:	00657461 	rsbeq	r7, r5, r1, ror #8
     cbc:	65646f6d 	strbvs	r6, [r4, #-3949]!	; 0xfffff093
     cc0:	75706300 	ldrbvc	r6, [r0, #-768]!	; 0xfffffd00
     cc4:	6e6f635f 	mcrvs	3, 3, r6, cr15, cr15, {2}
     cc8:	74786574 	ldrbtvc	r6, [r8], #-1396	; 0xfffffa8c
     ccc:	61655200 	cmnvs	r5, r0, lsl #4
     cd0:	6e4f5f64 	cdpvs	15, 4, cr5, cr15, cr4, {3}
     cd4:	6200796c 	andvs	r7, r0, #108, 18	; 0x1b0000
     cd8:	65666675 	strbvs	r6, [r6, #-1653]!	; 0xfffff98b
     cdc:	6c730072 	ldclvs	0, cr0, [r3], #-456	; 0xfffffe38
     ce0:	5f706565 	svcpl	0x00706565
     ce4:	656d6974 	strbvs	r6, [sp, #-2420]!	; 0xfffff68c
     ce8:	5a5f0072 	bpl	17c0eb8 <__bss_end+0x17b80c0>
     cec:	36314b4e 	ldrtcc	r4, [r1], -lr, asr #22
     cf0:	6f725043 	svcvs	0x00725043
     cf4:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     cf8:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     cfc:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     d00:	65473831 	strbvs	r3, [r7, #-2097]	; 0xfffff7cf
     d04:	72505f74 	subsvc	r5, r0, #116, 30	; 0x1d0
     d08:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     d0c:	79425f73 	stmdbvc	r2, {r0, r1, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     d10:	4449505f 	strbmi	r5, [r9], #-95	; 0xffffffa1
     d14:	48006a45 	stmdami	r0, {r0, r2, r6, r9, fp, sp, lr}
     d18:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     d1c:	69465f65 	stmdbvs	r6, {r0, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     d20:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     d24:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     d28:	4957535f 	ldmdbmi	r7, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     d2c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     d30:	50433631 	subpl	r3, r3, r1, lsr r6
     d34:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     d38:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; b74 <shift+0xb74>
     d3c:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     d40:	31317265 	teqcc	r1, r5, ror #4
     d44:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     d48:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     d4c:	4552525f 	ldrbmi	r5, [r2, #-607]	; 0xfffffda1
     d50:	61740076 	cmnvs	r4, r6, ror r0
     d54:	5f006b73 	svcpl	0x00006b73
     d58:	6572345a 	ldrbvs	r3, [r2, #-1114]!	; 0xfffffba6
     d5c:	506a6461 	rsbpl	r6, sl, r1, ror #8
     d60:	4e006a63 	vmlsmi.f32	s12, s0, s7
     d64:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     d68:	72505f79 	subsvc	r5, r0, #484	; 0x1e4
     d6c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     d70:	63530073 	cmpvs	r3, #115	; 0x73
     d74:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     d78:	5f00656c 	svcpl	0x0000656c
     d7c:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     d80:	6f725043 	svcvs	0x00725043
     d84:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     d88:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     d8c:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     d90:	69775339 	ldmdbvs	r7!, {r0, r3, r4, r5, r8, r9, ip, lr}^
     d94:	5f686374 	svcpl	0x00686374
     d98:	50456f54 	subpl	r6, r5, r4, asr pc
     d9c:	50433831 	subpl	r3, r3, r1, lsr r8
     da0:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     da4:	4c5f7373 	mrrcmi	3, 7, r7, pc, cr3	; <UNPREDICTABLE>
     da8:	5f747369 	svcpl	0x00747369
     dac:	65646f4e 	strbvs	r6, [r4, #-3918]!	; 0xfffff0b2
     db0:	68635300 	stmdavs	r3!, {r8, r9, ip, lr}^
     db4:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     db8:	52525f65 	subspl	r5, r2, #404	; 0x194
     dbc:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     dc0:	50433631 	subpl	r3, r3, r1, lsr r6
     dc4:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     dc8:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; c04 <shift+0xc04>
     dcc:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     dd0:	38317265 	ldmdacc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     dd4:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     dd8:	505f656c 	subspl	r6, pc, ip, ror #10
     ddc:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     de0:	535f7373 	cmppl	pc, #-872415231	; 0xcc000001
     de4:	32454957 	subcc	r4, r5, #1425408	; 0x15c000
     de8:	57534e30 	smmlarpl	r3, r0, lr, r4
     dec:	72505f49 	subsvc	r5, r0, #292	; 0x124
     df0:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     df4:	65535f73 	ldrbvs	r5, [r3, #-3955]	; 0xfffff08d
     df8:	63697672 	cmnvs	r9, #119537664	; 0x7200000
     dfc:	6a6a6a65 	bvs	1a9b798 <__bss_end+0x1a929a0>
     e00:	54313152 	ldrtpl	r3, [r1], #-338	; 0xfffffeae
     e04:	5f495753 	svcpl	0x00495753
     e08:	75736552 	ldrbvc	r6, [r3, #-1362]!	; 0xfffffaae
     e0c:	4e00746c 	cdpmi	4, 0, cr7, cr0, cr12, {3}
     e10:	74434f49 	strbvc	r4, [r3], #-3913	; 0xfffff0b7
     e14:	704f5f6c 	subvc	r5, pc, ip, ror #30
     e18:	74617265 	strbtvc	r7, [r1], #-613	; 0xfffffd9b
     e1c:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     e20:	314e5a5f 	cmpcc	lr, pc, asr sl
     e24:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     e28:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     e2c:	614d5f73 	hvcvs	54771	; 0xd5f3
     e30:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     e34:	43343172 	teqmi	r4, #-2147483620	; 0x8000001c
     e38:	74616572 	strbtvc	r6, [r1], #-1394	; 0xfffffa8e
     e3c:	72505f65 	subsvc	r5, r0, #404	; 0x194
     e40:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     e44:	68504573 	ldmdavs	r0, {r0, r1, r4, r5, r6, r8, sl, lr}^
     e48:	5300626a 	movwpl	r6, #618	; 0x26a
     e4c:	63746977 	cmnvs	r4, #1949696	; 0x1dc000
     e50:	6f545f68 	svcvs	0x00545f68
     e54:	57534e00 	ldrbpl	r4, [r3, -r0, lsl #28]
     e58:	69465f49 	stmdbvs	r6, {r0, r3, r6, r8, r9, sl, fp, ip, lr}^
     e5c:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     e60:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     e64:	7265535f 	rsbvc	r5, r5, #2080374785	; 0x7c000001
     e68:	65636976 	strbvs	r6, [r3, #-2422]!	; 0xfffff68a
     e6c:	74657200 	strbtvc	r7, [r5], #-512	; 0xfffffe00
     e70:	65646f63 	strbvs	r6, [r4, #-3939]!	; 0xfffff09d
     e74:	74656700 	strbtvc	r6, [r5], #-1792	; 0xfffff900
     e78:	7463615f 	strbtvc	r6, [r3], #-351	; 0xfffffea1
     e7c:	5f657669 	svcpl	0x00657669
     e80:	636f7270 	cmnvs	pc, #112, 4
     e84:	5f737365 	svcpl	0x00737365
     e88:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
     e8c:	69660074 	stmdbvs	r6!, {r2, r4, r5, r6}^
     e90:	616e656c 	cmnvs	lr, ip, ror #10
     e94:	4200656d 	andmi	r6, r0, #457179136	; 0x1b400000
     e98:	6b636f6c 	blvs	18dcc50 <__bss_end+0x18d3e58>
     e9c:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     ea0:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     ea4:	6f72505f 	svcvs	0x0072505f
     ea8:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     eac:	61657200 	cmnvs	r5, r0, lsl #4
     eb0:	6c430064 	mcrrvs	0, 6, r0, r3, cr4
     eb4:	0065736f 	rsbeq	r7, r5, pc, ror #6
     eb8:	70746567 	rsbsvc	r6, r4, r7, ror #10
     ebc:	5f006469 	svcpl	0x00006469
     ec0:	706f345a 	rsbvc	r3, pc, sl, asr r4	; <UNPREDICTABLE>
     ec4:	4b506e65 	blmi	141c860 <__bss_end+0x1413a68>
     ec8:	4e353163 	rsfmisz	f3, f5, f3
     ecc:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     ed0:	65704f5f 	ldrbvs	r4, [r0, #-3935]!	; 0xfffff0a1
     ed4:	6f4d5f6e 	svcvs	0x004d5f6e
     ed8:	57006564 	strpl	r6, [r0, -r4, ror #10]
     edc:	65746972 	ldrbvs	r6, [r4, #-2418]!	; 0xfffff68e
     ee0:	6c6e4f5f 	stclvs	15, cr4, [lr], #-380	; 0xfffffe84
     ee4:	69590079 	ldmdbvs	r9, {r0, r3, r4, r5, r6}^
     ee8:	00646c65 	rsbeq	r6, r4, r5, ror #24
     eec:	314e5a5f 	cmpcc	lr, pc, asr sl
     ef0:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     ef4:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     ef8:	614d5f73 	hvcvs	54771	; 0xd5f3
     efc:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     f00:	45344372 	ldrmi	r4, [r4, #-882]!	; 0xfffffc8e
     f04:	65540076 	ldrbvs	r0, [r4, #-118]	; 0xffffff8a
     f08:	6e696d72 	mcrvs	13, 3, r6, cr9, cr2, {3}
     f0c:	00657461 	rsbeq	r7, r5, r1, ror #8
     f10:	74434f49 	strbvc	r4, [r3], #-3913	; 0xfffff0b7
     f14:	6e69006c 	cdpvs	0, 6, cr0, cr9, cr12, {3}
     f18:	00747570 	rsbseq	r7, r4, r0, ror r5
     f1c:	74736564 	ldrbtvc	r6, [r3], #-1380	; 0xfffffa9c
     f20:	657a6200 	ldrbvs	r6, [sl, #-512]!	; 0xfffffe00
     f24:	6c006f72 	stcvs	15, cr6, [r0], {114}	; 0x72
     f28:	74676e65 	strbtvc	r6, [r7], #-3685	; 0xfffff19b
     f2c:	5a5f0068 	bpl	17c10d4 <__bss_end+0x17b82dc>
     f30:	657a6235 	ldrbvs	r6, [sl, #-565]!	; 0xfffffdcb
     f34:	76506f72 	usub16vc	r6, r0, r2
     f38:	74730069 	ldrbtvc	r0, [r3], #-105	; 0xffffff97
     f3c:	70636e72 	rsbvc	r6, r3, r2, ror lr
     f40:	5a5f0079 	bpl	17c112c <__bss_end+0x17b8334>
     f44:	6f746134 	svcvs	0x00746134
     f48:	634b5069 	movtvs	r5, #45161	; 0xb069
     f4c:	61684300 	cmnvs	r8, r0, lsl #6
     f50:	6e6f4372 	mcrvs	3, 3, r4, cr15, cr2, {3}
     f54:	72724176 	rsbsvc	r4, r2, #-2147483619	; 0x8000001d
     f58:	6d656d00 	stclvs	13, cr6, [r5, #-0]
     f5c:	00747364 	rsbseq	r7, r4, r4, ror #6
     f60:	7074756f 	rsbsvc	r7, r4, pc, ror #10
     f64:	5f007475 	svcpl	0x00007475
     f68:	656d365a 	strbvs	r3, [sp, #-1626]!	; 0xfffff9a6
     f6c:	7970636d 	ldmdbvc	r0!, {r0, r2, r3, r5, r6, r8, r9, sp, lr}^
     f70:	50764b50 	rsbspl	r4, r6, r0, asr fp
     f74:	6d006976 	vstrvs.16	s12, [r0, #-236]	; 0xffffff14	; <UNPREDICTABLE>
     f78:	70636d65 	rsbvc	r6, r3, r5, ror #26
     f7c:	74730079 	ldrbtvc	r0, [r3], #-121	; 0xffffff87
     f80:	6e656c72 	mcrvs	12, 3, r6, cr5, cr2, {3}
     f84:	375a5f00 	ldrbcc	r5, [sl, -r0, lsl #30]
     f88:	6e727473 	mrcvs	4, 3, r7, cr2, cr3, {3}
     f8c:	50706d63 	rsbspl	r6, r0, r3, ror #26
     f90:	3053634b 	subscc	r6, r3, fp, asr #6
     f94:	5f00695f 	svcpl	0x0000695f
     f98:	7473365a 	ldrbtvc	r3, [r3], #-1626	; 0xfffff9a6
     f9c:	6e656c72 	mcrvs	12, 3, r6, cr5, cr2, {3}
     fa0:	00634b50 	rsbeq	r4, r3, r0, asr fp
     fa4:	696f7461 	stmdbvs	pc!, {r0, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
     fa8:	375a5f00 	ldrbcc	r5, [sl, -r0, lsl #30]
     fac:	6e727473 	mrcvs	4, 3, r7, cr2, cr3, {3}
     fb0:	50797063 	rsbspl	r7, r9, r3, rrx
     fb4:	634b5063 	movtvs	r5, #45155	; 0xb063
     fb8:	74730069 	ldrbtvc	r0, [r3], #-105	; 0xffffff97
     fbc:	6d636e72 	stclvs	14, cr6, [r3, #-456]!	; 0xfffffe38
     fc0:	656d0070 	strbvs	r0, [sp, #-112]!	; 0xffffff90
     fc4:	79726f6d 	ldmdbvc	r2!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
     fc8:	6d656d00 	stclvs	13, cr6, [r5, #-0]
     fcc:	00637273 	rsbeq	r7, r3, r3, ror r2
     fd0:	616f7469 	cmnvs	pc, r9, ror #8
     fd4:	6e6d2f00 	cdpvs	15, 6, cr2, cr13, cr0, {0}
     fd8:	2f632f74 	svccs	0x00632f74
     fdc:	72657355 	rsbvc	r7, r5, #1409286145	; 0x54000001
     fe0:	754b2f73 	strbvc	r2, [fp, #-3955]	; 0xfffff08d
     fe4:	442f6162 	strtmi	r6, [pc], #-354	; fec <shift+0xfec>
     fe8:	6d75636f 	ldclvs	3, cr6, [r5, #-444]!	; 0xfffffe44
     fec:	73746e65 	cmnvc	r4, #1616	; 0x650
     ff0:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
     ff4:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
     ff8:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
     ffc:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
    1000:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
    1004:	64652d38 	strbtvs	r2, [r5], #-3384	; 0xfffff2c8
    1008:	74732f66 	ldrbtvc	r2, [r3], #-3942	; 0xfffff09a
    100c:	62696c64 	rsbvs	r6, r9, #100, 24	; 0x6400
    1010:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
    1014:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
    1018:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
    101c:	632e676e 			; <UNDEFINED> instruction: 0x632e676e
    1020:	5f007070 	svcpl	0x00007070
    1024:	7469345a 	strbtvc	r3, [r9], #-1114	; 0xfffffba6
    1028:	506a616f 	rsbpl	r6, sl, pc, ror #2
    102c:	2e006a63 	vmlscs.f32	s12, s0, s7
    1030:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1034:	2f2e2e2f 	svccs	0x002e2e2f
    1038:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    103c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1040:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    1044:	2f636367 	svccs	0x00636367
    1048:	666e6f63 	strbtvs	r6, [lr], -r3, ror #30
    104c:	612f6769 			; <UNDEFINED> instruction: 0x612f6769
    1050:	6c2f6d72 	stcvs	13, cr6, [pc], #-456	; e90 <shift+0xe90>
    1054:	66316269 	ldrtvs	r6, [r1], -r9, ror #4
    1058:	73636e75 	cmnvc	r3, #1872	; 0x750
    105c:	2f00532e 	svccs	0x0000532e
    1060:	6c697562 	cfstr64vs	mvdx7, [r9], #-392	; 0xfffffe78
    1064:	63672f64 	cmnvs	r7, #100, 30	; 0x190
    1068:	72612d63 	rsbvc	r2, r1, #6336	; 0x18c0
    106c:	6f6e2d6d 	svcvs	0x006e2d6d
    1070:	652d656e 	strvs	r6, [sp, #-1390]!	; 0xfffffa92
    1074:	2d696261 	sfmcs	f6, 2, [r9, #-388]!	; 0xfffffe7c
    1078:	67665968 	strbvs	r5, [r6, -r8, ror #18]!
    107c:	672f344b 	strvs	r3, [pc, -fp, asr #8]!
    1080:	612d6363 			; <UNDEFINED> instruction: 0x612d6363
    1084:	6e2d6d72 	mcrvs	13, 1, r6, cr13, cr2, {3}
    1088:	2d656e6f 	stclcs	14, cr6, [r5, #-444]!	; 0xfffffe44
    108c:	69626165 	stmdbvs	r2!, {r0, r2, r5, r6, r8, sp, lr}^
    1090:	2e30312d 	rsfcssp	f3, f0, #5.0
    1094:	30322d33 	eorscc	r2, r2, r3, lsr sp
    1098:	302e3132 	eorcc	r3, lr, r2, lsr r1
    109c:	75622f37 	strbvc	r2, [r2, #-3895]!	; 0xfffff0c9
    10a0:	2f646c69 	svccs	0x00646c69
    10a4:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
    10a8:	656e6f6e 	strbvs	r6, [lr, #-3950]!	; 0xfffff092
    10ac:	6261652d 	rsbvs	r6, r1, #188743680	; 0xb400000
    10b0:	72612f69 	rsbvc	r2, r1, #420	; 0x1a4
    10b4:	35762f6d 	ldrbcc	r2, [r6, #-3949]!	; 0xfffff093
    10b8:	682f6574 	stmdavs	pc!, {r2, r4, r5, r6, r8, sl, sp, lr}	; <UNPREDICTABLE>
    10bc:	2f647261 	svccs	0x00647261
    10c0:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    10c4:	47006363 	strmi	r6, [r0, -r3, ror #6]
    10c8:	4120554e 			; <UNDEFINED> instruction: 0x4120554e
    10cc:	2e322053 	mrccs	0, 1, r2, cr2, cr3, {2}
    10d0:	69003733 	stmdbvs	r0, {r0, r1, r4, r5, r8, r9, sl, ip, sp}
    10d4:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    10d8:	705f7469 	subsvc	r7, pc, r9, ror #8
    10dc:	72646572 	rsbvc	r6, r4, #478150656	; 0x1c800000
    10e0:	69007365 	stmdbvs	r0, {r0, r2, r5, r6, r8, r9, ip, sp, lr}
    10e4:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    10e8:	765f7469 	ldrbvc	r7, [pc], -r9, ror #8
    10ec:	625f7066 	subsvs	r7, pc, #102	; 0x66
    10f0:	00657361 	rsbeq	r7, r5, r1, ror #6
    10f4:	706d6f63 	rsbvc	r6, sp, r3, ror #30
    10f8:	2078656c 	rsbscs	r6, r8, ip, ror #10
    10fc:	616f6c66 	cmnvs	pc, r6, ror #24
    1100:	73690074 	cmnvc	r9, #116	; 0x74
    1104:	6f6e5f61 	svcvs	0x006e5f61
    1108:	00746962 	rsbseq	r6, r4, r2, ror #18
    110c:	5f617369 	svcpl	0x00617369
    1110:	5f746962 	svcpl	0x00746962
    1114:	5f65766d 	svcpl	0x0065766d
    1118:	616f6c66 	cmnvs	pc, r6, ror #24
    111c:	73690074 	cmnvc	r9, #116	; 0x74
    1120:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1124:	70665f74 	rsbvc	r5, r6, r4, ror pc
    1128:	69003631 	stmdbvs	r0, {r0, r4, r5, r9, sl, ip, sp}
    112c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1130:	735f7469 	cmpvc	pc, #1761607680	; 0x69000000
    1134:	69006365 	stmdbvs	r0, {r0, r2, r5, r6, r8, r9, sp, lr}
    1138:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    113c:	615f7469 	cmpvs	pc, r9, ror #8
    1140:	00766964 	rsbseq	r6, r6, r4, ror #18
    1144:	5f617369 	svcpl	0x00617369
    1148:	5f746962 	svcpl	0x00746962
    114c:	72697571 	rsbvc	r7, r9, #473956352	; 0x1c400000
    1150:	6f6e5f6b 	svcvs	0x006e5f6b
    1154:	6c6f765f 	stclvs	6, cr7, [pc], #-380	; fe0 <shift+0xfe0>
    1158:	6c697461 	cfstrdvs	mvd7, [r9], #-388	; 0xfffffe7c
    115c:	65635f65 	strbvs	r5, [r3, #-3941]!	; 0xfffff09b
    1160:	61736900 	cmnvs	r3, r0, lsl #18
    1164:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1168:	00706d5f 	rsbseq	r6, r0, pc, asr sp
    116c:	5f617369 	svcpl	0x00617369
    1170:	5f746962 	svcpl	0x00746962
    1174:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1178:	69007435 	stmdbvs	r0, {r0, r2, r4, r5, sl, ip, sp, lr}
    117c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1180:	615f7469 	cmpvs	pc, r9, ror #8
    1184:	35766d72 	ldrbcc	r6, [r6, #-3442]!	; 0xfffff28e
    1188:	69006574 	stmdbvs	r0, {r2, r4, r5, r6, r8, sl, sp, lr}
    118c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1190:	6e5f7469 	cdpvs	4, 5, cr7, cr15, cr9, {3}
    1194:	006e6f65 	rsbeq	r6, lr, r5, ror #30
    1198:	5f617369 	svcpl	0x00617369
    119c:	5f746962 	svcpl	0x00746962
    11a0:	36316662 	ldrtcc	r6, [r1], -r2, ror #12
    11a4:	53504600 	cmppl	r0, #0, 12
    11a8:	455f5243 	ldrbmi	r5, [pc, #-579]	; f6d <shift+0xf6d>
    11ac:	004d554e 	subeq	r5, sp, lr, asr #10
    11b0:	43535046 	cmpmi	r3, #70	; 0x46
    11b4:	7a6e5f52 	bvc	1b98f04 <__bss_end+0x1b9010c>
    11b8:	63717663 	cmnvs	r1, #103809024	; 0x6300000
    11bc:	554e455f 	strbpl	r4, [lr, #-1375]	; 0xfffffaa1
    11c0:	5056004d 	subspl	r0, r6, sp, asr #32
    11c4:	4e455f52 	mcrmi	15, 2, r5, cr5, cr2, {2}
    11c8:	66004d55 			; <UNDEFINED> instruction: 0x66004d55
    11cc:	5f746962 	svcpl	0x00746962
    11d0:	6c706d69 	ldclvs	13, cr6, [r0], #-420	; 0xfffffe5c
    11d4:	74616369 	strbtvc	r6, [r1], #-873	; 0xfffffc97
    11d8:	006e6f69 	rsbeq	r6, lr, r9, ror #30
    11dc:	455f3050 	ldrbmi	r3, [pc, #-80]	; 1194 <shift+0x1194>
    11e0:	004d554e 	subeq	r5, sp, lr, asr #10
    11e4:	5f617369 	svcpl	0x00617369
    11e8:	5f746962 	svcpl	0x00746962
    11ec:	70797263 	rsbsvc	r7, r9, r3, ror #4
    11f0:	47006f74 	smlsdxmi	r0, r4, pc, r6	; <UNPREDICTABLE>
    11f4:	4320554e 			; <UNDEFINED> instruction: 0x4320554e
    11f8:	31203731 			; <UNDEFINED> instruction: 0x31203731
    11fc:	2e332e30 	mrccs	14, 1, r2, cr3, cr0, {1}
    1200:	30322031 	eorscc	r2, r2, r1, lsr r0
    1204:	36303132 			; <UNDEFINED> instruction: 0x36303132
    1208:	28203132 	stmdacs	r0!, {r1, r4, r5, r8, ip, sp}
    120c:	656c6572 	strbvs	r6, [ip, #-1394]!	; 0xfffffa8e
    1210:	29657361 	stmdbcs	r5!, {r0, r5, r6, r8, r9, ip, sp, lr}^
    1214:	616d2d20 	cmnvs	sp, r0, lsr #26
    1218:	2d206d72 	stccs	13, cr6, [r0, #-456]!	; 0xfffffe38
    121c:	6f6c666d 	svcvs	0x006c666d
    1220:	612d7461 			; <UNDEFINED> instruction: 0x612d7461
    1224:	683d6962 	ldmdavs	sp!, {r1, r5, r6, r8, fp, sp, lr}
    1228:	20647261 	rsbcs	r7, r4, r1, ror #4
    122c:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
    1230:	613d6863 	teqvs	sp, r3, ror #16
    1234:	35766d72 	ldrbcc	r6, [r6, #-3442]!	; 0xfffff28e
    1238:	662b6574 			; <UNDEFINED> instruction: 0x662b6574
    123c:	672d2070 			; <UNDEFINED> instruction: 0x672d2070
    1240:	20672d20 	rsbcs	r2, r7, r0, lsr #26
    1244:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
    1248:	2d20324f 	sfmcs	f3, 4, [r0, #-316]!	; 0xfffffec4
    124c:	2d20324f 	sfmcs	f3, 4, [r0, #-316]!	; 0xfffffec4
    1250:	2d20324f 	sfmcs	f3, 4, [r0, #-316]!	; 0xfffffec4
    1254:	69756266 	ldmdbvs	r5!, {r1, r2, r5, r6, r9, sp, lr}^
    1258:	6e69646c 	cdpvs	4, 6, cr6, cr9, cr12, {3}
    125c:	696c2d67 	stmdbvs	ip!, {r0, r1, r2, r5, r6, r8, sl, fp, sp}^
    1260:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    1264:	6e662d20 	cdpvs	13, 6, cr2, cr6, cr0, {1}
    1268:	74732d6f 	ldrbtvc	r2, [r3], #-3439	; 0xfffff291
    126c:	2d6b6361 	stclcs	3, cr6, [fp, #-388]!	; 0xfffffe7c
    1270:	746f7270 	strbtvc	r7, [pc], #-624	; 1278 <shift+0x1278>
    1274:	6f746365 	svcvs	0x00746365
    1278:	662d2072 			; <UNDEFINED> instruction: 0x662d2072
    127c:	692d6f6e 	pushvs	{r1, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}
    1280:	6e696c6e 	cdpvs	12, 6, cr6, cr9, cr14, {3}
    1284:	662d2065 	strtvs	r2, [sp], -r5, rrx
    1288:	69736976 	ldmdbvs	r3!, {r1, r2, r4, r5, r6, r8, fp, sp, lr}^
    128c:	696c6962 	stmdbvs	ip!, {r1, r5, r6, r8, fp, sp, lr}^
    1290:	683d7974 	ldmdavs	sp!, {r2, r4, r5, r6, r8, fp, ip, sp, lr}
    1294:	65646469 	strbvs	r6, [r4, #-1129]!	; 0xfffffb97
    1298:	7369006e 	cmnvc	r9, #110	; 0x6e
    129c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    12a0:	64745f74 	ldrbtvs	r5, [r4], #-3956	; 0xfffff08c
    12a4:	63007669 	movwvs	r7, #1641	; 0x669
    12a8:	00736e6f 	rsbseq	r6, r3, pc, ror #28
    12ac:	5f617369 	svcpl	0x00617369
    12b0:	5f746962 	svcpl	0x00746962
    12b4:	6d6d7769 	stclvs	7, cr7, [sp, #-420]!	; 0xfffffe5c
    12b8:	46007478 			; <UNDEFINED> instruction: 0x46007478
    12bc:	54584350 	ldrbpl	r4, [r8], #-848	; 0xfffffcb0
    12c0:	4e455f53 	mcrmi	15, 2, r5, cr5, cr3, {2}
    12c4:	69004d55 	stmdbvs	r0, {r0, r2, r4, r6, r8, sl, fp, lr}
    12c8:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    12cc:	615f7469 	cmpvs	pc, r9, ror #8
    12d0:	36766d72 			; <UNDEFINED> instruction: 0x36766d72
    12d4:	61736900 	cmnvs	r3, r0, lsl #18
    12d8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    12dc:	65766d5f 	ldrbvs	r6, [r6, #-3423]!	; 0xfffff2a1
    12e0:	61736900 	cmnvs	r3, r0, lsl #18
    12e4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    12e8:	6d77695f 			; <UNDEFINED> instruction: 0x6d77695f
    12ec:	3274786d 	rsbscc	r7, r4, #7143424	; 0x6d0000
    12f0:	61736900 	cmnvs	r3, r0, lsl #18
    12f4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    12f8:	6564635f 	strbvs	r6, [r4, #-863]!	; 0xfffffca1
    12fc:	00307063 	eorseq	r7, r0, r3, rrx
    1300:	5f617369 	svcpl	0x00617369
    1304:	5f746962 	svcpl	0x00746962
    1308:	63656463 	cmnvs	r5, #1660944384	; 0x63000000
    130c:	69003170 	stmdbvs	r0, {r4, r5, r6, r8, ip, sp}
    1310:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1314:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    1318:	70636564 	rsbvc	r6, r3, r4, ror #10
    131c:	73690032 	cmnvc	r9, #50	; 0x32
    1320:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1324:	64635f74 	strbtvs	r5, [r3], #-3956	; 0xfffff08c
    1328:	33706365 	cmncc	r0, #-1811939327	; 0x94000001
    132c:	61736900 	cmnvs	r3, r0, lsl #18
    1330:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1334:	6564635f 	strbvs	r6, [r4, #-863]!	; 0xfffffca1
    1338:	00347063 	eorseq	r7, r4, r3, rrx
    133c:	5f617369 	svcpl	0x00617369
    1340:	5f746962 	svcpl	0x00746962
    1344:	645f7066 	ldrbvs	r7, [pc], #-102	; 134c <shift+0x134c>
    1348:	69006c62 	stmdbvs	r0, {r1, r5, r6, sl, fp, sp, lr}
    134c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1350:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    1354:	70636564 	rsbvc	r6, r3, r4, ror #10
    1358:	73690036 	cmnvc	r9, #54	; 0x36
    135c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1360:	64635f74 	strbtvs	r5, [r3], #-3956	; 0xfffff08c
    1364:	37706365 	ldrbcc	r6, [r0, -r5, ror #6]!
    1368:	61736900 	cmnvs	r3, r0, lsl #18
    136c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1370:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1374:	006b3676 	rsbeq	r3, fp, r6, ror r6
    1378:	5f617369 	svcpl	0x00617369
    137c:	5f746962 	svcpl	0x00746962
    1380:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1384:	6d315f38 	ldcvs	15, cr5, [r1, #-224]!	; 0xffffff20
    1388:	69616d5f 	stmdbvs	r1!, {r0, r1, r2, r3, r4, r6, r8, sl, fp, sp, lr}^
    138c:	6e61006e 	cdpvs	0, 6, cr0, cr1, cr14, {3}
    1390:	69006574 	stmdbvs	r0, {r2, r4, r5, r6, r8, sl, sp, lr}
    1394:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1398:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    139c:	0065736d 	rsbeq	r7, r5, sp, ror #6
    13a0:	676e6f6c 	strbvs	r6, [lr, -ip, ror #30]!
    13a4:	756f6420 	strbvc	r6, [pc, #-1056]!	; f8c <shift+0xf8c>
    13a8:	00656c62 	rsbeq	r6, r5, r2, ror #24
    13ac:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    13b0:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    13b4:	2f2e2e2f 	svccs	0x002e2e2f
    13b8:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    13bc:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
    13c0:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    13c4:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    13c8:	32636367 	rsbcc	r6, r3, #-1677721599	; 0x9c000001
    13cc:	6900632e 	stmdbvs	r0, {r1, r2, r3, r5, r8, r9, sp, lr}
    13d0:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    13d4:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    13d8:	00357670 	eorseq	r7, r5, r0, ror r6
    13dc:	5f617369 	svcpl	0x00617369
    13e0:	5f746962 	svcpl	0x00746962
    13e4:	61637378 	smcvs	14136	; 0x3738
    13e8:	6c00656c 	cfstr32vs	mvfx6, [r0], {108}	; 0x6c
    13ec:	20676e6f 	rsbcs	r6, r7, pc, ror #28
    13f0:	676e6f6c 	strbvs	r6, [lr, -ip, ror #30]!
    13f4:	736e7520 	cmnvc	lr, #32, 10	; 0x8000000
    13f8:	656e6769 	strbvs	r6, [lr, #-1897]!	; 0xfffff897
    13fc:	6e692064 	cdpvs	0, 6, cr2, cr9, cr4, {3}
    1400:	73690074 	cmnvc	r9, #116	; 0x74
    1404:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1408:	75715f74 	ldrbvc	r5, [r1, #-3956]!	; 0xfffff08c
    140c:	5f6b7269 	svcpl	0x006b7269
    1410:	5f336d63 	svcpl	0x00336d63
    1414:	6472646c 	ldrbtvs	r6, [r2], #-1132	; 0xfffffb94
    1418:	61736900 	cmnvs	r3, r0, lsl #18
    141c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1420:	6d38695f 			; <UNDEFINED> instruction: 0x6d38695f
    1424:	7369006d 	cmnvc	r9, #109	; 0x6d
    1428:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    142c:	70665f74 	rsbvc	r5, r6, r4, ror pc
    1430:	3233645f 	eorscc	r6, r3, #1593835520	; 0x5f000000
    1434:	61736900 	cmnvs	r3, r0, lsl #18
    1438:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    143c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1440:	6d653776 	stclvs	7, cr3, [r5, #-472]!	; 0xfffffe28
    1444:	61736900 	cmnvs	r3, r0, lsl #18
    1448:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    144c:	61706c5f 	cmnvs	r0, pc, asr ip
    1450:	6c610065 	stclvs	0, cr0, [r1], #-404	; 0xfffffe6c
    1454:	6d695f6c 	stclvs	15, cr5, [r9, #-432]!	; 0xfffffe50
    1458:	65696c70 	strbvs	r6, [r9, #-3184]!	; 0xfffff390
    145c:	62665f64 	rsbvs	r5, r6, #100, 30	; 0x190
    1460:	00737469 	rsbseq	r7, r3, r9, ror #8
    1464:	5f617369 	svcpl	0x00617369
    1468:	5f746962 	svcpl	0x00746962
    146c:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1470:	00315f38 	eorseq	r5, r1, r8, lsr pc
    1474:	5f617369 	svcpl	0x00617369
    1478:	5f746962 	svcpl	0x00746962
    147c:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1480:	00325f38 	eorseq	r5, r2, r8, lsr pc
    1484:	5f617369 	svcpl	0x00617369
    1488:	5f746962 	svcpl	0x00746962
    148c:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1490:	00335f38 	eorseq	r5, r3, r8, lsr pc
    1494:	5f617369 	svcpl	0x00617369
    1498:	5f746962 	svcpl	0x00746962
    149c:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    14a0:	00345f38 	eorseq	r5, r4, r8, lsr pc
    14a4:	5f617369 	svcpl	0x00617369
    14a8:	5f746962 	svcpl	0x00746962
    14ac:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    14b0:	00355f38 	eorseq	r5, r5, r8, lsr pc
    14b4:	5f617369 	svcpl	0x00617369
    14b8:	5f746962 	svcpl	0x00746962
    14bc:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    14c0:	00365f38 	eorseq	r5, r6, r8, lsr pc
    14c4:	5f617369 	svcpl	0x00617369
    14c8:	5f746962 	svcpl	0x00746962
    14cc:	69006273 	stmdbvs	r0, {r0, r1, r4, r5, r6, r9, sp, lr}
    14d0:	6e5f6173 	mrcvs	1, 2, r6, cr15, cr3, {3}
    14d4:	625f6d75 	subsvs	r6, pc, #7488	; 0x1d40
    14d8:	00737469 	rsbseq	r7, r3, r9, ror #8
    14dc:	5f617369 	svcpl	0x00617369
    14e0:	5f746962 	svcpl	0x00746962
    14e4:	6c616d73 	stclvs	13, cr6, [r1], #-460	; 0xfffffe34
    14e8:	6c756d6c 	ldclvs	13, cr6, [r5], #-432	; 0xfffffe50
    14ec:	6e756600 	cdpvs	6, 7, cr6, cr5, cr0, {0}
    14f0:	74705f63 	ldrbtvc	r5, [r0], #-3939	; 0xfffff09d
    14f4:	6f630072 	svcvs	0x00630072
    14f8:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
    14fc:	6f642078 	svcvs	0x00642078
    1500:	656c6275 	strbvs	r6, [ip, #-629]!	; 0xfffffd8b
    1504:	5f424e00 	svcpl	0x00424e00
    1508:	535f5046 	cmppl	pc, #70	; 0x46
    150c:	45525359 	ldrbmi	r5, [r2, #-857]	; 0xfffffca7
    1510:	69005347 	stmdbvs	r0, {r0, r1, r2, r6, r8, r9, ip, lr}
    1514:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1518:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    151c:	70636564 	rsbvc	r6, r3, r4, ror #10
    1520:	73690035 	cmnvc	r9, #53	; 0x35
    1524:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1528:	66765f74 	uhsub16vs	r5, r6, r4
    152c:	00327670 	eorseq	r7, r2, r0, ror r6
    1530:	5f617369 	svcpl	0x00617369
    1534:	5f746962 	svcpl	0x00746962
    1538:	76706676 			; <UNDEFINED> instruction: 0x76706676
    153c:	73690033 	cmnvc	r9, #51	; 0x33
    1540:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1544:	66765f74 	uhsub16vs	r5, r6, r4
    1548:	00347670 	eorseq	r7, r4, r0, ror r6
    154c:	58435046 	stmdapl	r3, {r1, r2, r6, ip, lr}^
    1550:	5f534e54 	svcpl	0x00534e54
    1554:	4d554e45 	ldclmi	14, cr4, [r5, #-276]	; 0xfffffeec
    1558:	61736900 	cmnvs	r3, r0, lsl #18
    155c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1560:	7568745f 	strbvc	r7, [r8, #-1119]!	; 0xfffffba1
    1564:	6900626d 	stmdbvs	r0, {r0, r2, r3, r5, r6, r9, sp, lr}
    1568:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    156c:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    1570:	63363170 	teqvs	r6, #112, 2
    1574:	00766e6f 	rsbseq	r6, r6, pc, ror #28
    1578:	5f617369 	svcpl	0x00617369
    157c:	74616566 	strbtvc	r6, [r1], #-1382	; 0xfffffa9a
    1580:	00657275 	rsbeq	r7, r5, r5, ror r2
    1584:	5f617369 	svcpl	0x00617369
    1588:	5f746962 	svcpl	0x00746962
    158c:	6d746f6e 	ldclvs	15, cr6, [r4, #-440]!	; 0xfffffe48
    1590:	61736900 	cmnvs	r3, r0, lsl #18
    1594:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1598:	6975715f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, r8, ip, sp, lr}^
    159c:	615f6b72 	cmpvs	pc, r2, ror fp	; <UNPREDICTABLE>
    15a0:	36766d72 			; <UNDEFINED> instruction: 0x36766d72
    15a4:	69007a6b 	stmdbvs	r0, {r0, r1, r3, r5, r6, r9, fp, ip, sp, lr}
    15a8:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    15ac:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    15b0:	32336372 	eorscc	r6, r3, #-939524095	; 0xc8000001
    15b4:	61736900 	cmnvs	r3, r0, lsl #18
    15b8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    15bc:	6975715f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, r8, ip, sp, lr}^
    15c0:	6e5f6b72 	vmovvs.s8	r6, d15[3]
    15c4:	73615f6f 	cmnvc	r1, #444	; 0x1bc
    15c8:	7570636d 	ldrbvc	r6, [r0, #-877]!	; 0xfffffc93
    15cc:	61736900 	cmnvs	r3, r0, lsl #18
    15d0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    15d4:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    15d8:	69003476 	stmdbvs	r0, {r1, r2, r4, r5, r6, sl, ip, sp}
    15dc:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    15e0:	745f7469 	ldrbvc	r7, [pc], #-1129	; 15e8 <shift+0x15e8>
    15e4:	626d7568 	rsbvs	r7, sp, #104, 10	; 0x1a000000
    15e8:	73690032 	cmnvc	r9, #50	; 0x32
    15ec:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    15f0:	65625f74 	strbvs	r5, [r2, #-3956]!	; 0xfffff08c
    15f4:	73690038 	cmnvc	r9, #56	; 0x38
    15f8:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    15fc:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1600:	0037766d 	eorseq	r7, r7, sp, ror #12
    1604:	5f617369 	svcpl	0x00617369
    1608:	5f746962 	svcpl	0x00746962
    160c:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1610:	66760038 			; <UNDEFINED> instruction: 0x66760038
    1614:	79735f70 	ldmdbvc	r3!, {r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    1618:	67657273 			; <UNDEFINED> instruction: 0x67657273
    161c:	6e655f73 	mcrvs	15, 3, r5, cr5, cr3, {3}
    1620:	69646f63 	stmdbvs	r4!, {r0, r1, r5, r6, r8, r9, sl, fp, sp, lr}^
    1624:	6900676e 	stmdbvs	r0, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}
    1628:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    162c:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    1630:	66363170 			; <UNDEFINED> instruction: 0x66363170
    1634:	69006c6d 	stmdbvs	r0, {r0, r2, r3, r5, r6, sl, fp, sp, lr}
    1638:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    163c:	645f7469 	ldrbvs	r7, [pc], #-1129	; 1644 <shift+0x1644>
    1640:	7270746f 	rsbsvc	r7, r0, #1862270976	; 0x6f000000
    1644:	Address 0x0000000000001644 is out of bounds.


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
  20:	8b040e42 	blhi	103930 <__bss_end+0xfab38>
  24:	0b0d4201 	bleq	350830 <__bss_end+0x347a38>
  28:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
  2c:	00000ecb 	andeq	r0, r0, fp, asr #29
  30:	0000001c 	andeq	r0, r0, ip, lsl r0
  34:	00000000 	andeq	r0, r0, r0
  38:	00008064 	andeq	r8, r0, r4, rrx
  3c:	00000040 	andeq	r0, r0, r0, asr #32
  40:	8b080e42 	blhi	203950 <__bss_end+0x1fab58>
  44:	42018e02 	andmi	r8, r1, #2, 28
  48:	5a040b0c 	bpl	102c80 <__bss_end+0xf9e88>
  4c:	00080d0c 	andeq	r0, r8, ip, lsl #26
  50:	0000000c 	andeq	r0, r0, ip
  54:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  58:	7c020001 	stcvc	0, cr0, [r2], {1}
  5c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  60:	0000001c 	andeq	r0, r0, ip, lsl r0
  64:	00000050 	andeq	r0, r0, r0, asr r0
  68:	000080a4 	andeq	r8, r0, r4, lsr #1
  6c:	00000038 	andeq	r0, r0, r8, lsr r0
  70:	8b040e42 	blhi	103980 <__bss_end+0xfab88>
  74:	0b0d4201 	bleq	350880 <__bss_end+0x347a88>
  78:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
  7c:	00000ecb 	andeq	r0, r0, fp, asr #29
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	00000050 	andeq	r0, r0, r0, asr r0
  88:	000080dc 	ldrdeq	r8, [r0], -ip
  8c:	0000002c 	andeq	r0, r0, ip, lsr #32
  90:	8b040e42 	blhi	1039a0 <__bss_end+0xfaba8>
  94:	0b0d4201 	bleq	3508a0 <__bss_end+0x347aa8>
  98:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
  9c:	00000ecb 	andeq	r0, r0, fp, asr #29
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	00000050 	andeq	r0, r0, r0, asr r0
  a8:	00008108 	andeq	r8, r0, r8, lsl #2
  ac:	00000020 	andeq	r0, r0, r0, lsr #32
  b0:	8b040e42 	blhi	1039c0 <__bss_end+0xfabc8>
  b4:	0b0d4201 	bleq	3508c0 <__bss_end+0x347ac8>
  b8:	420d0d48 	andmi	r0, sp, #72, 26	; 0x1200
  bc:	00000ecb 	andeq	r0, r0, fp, asr #29
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	00000050 	andeq	r0, r0, r0, asr r0
  c8:	00008128 	andeq	r8, r0, r8, lsr #2
  cc:	00000018 	andeq	r0, r0, r8, lsl r0
  d0:	8b040e42 	blhi	1039e0 <__bss_end+0xfabe8>
  d4:	0b0d4201 	bleq	3508e0 <__bss_end+0x347ae8>
  d8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  dc:	00000ecb 	andeq	r0, r0, fp, asr #29
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	00000050 	andeq	r0, r0, r0, asr r0
  e8:	00008140 	andeq	r8, r0, r0, asr #2
  ec:	00000018 	andeq	r0, r0, r8, lsl r0
  f0:	8b040e42 	blhi	103a00 <__bss_end+0xfac08>
  f4:	0b0d4201 	bleq	350900 <__bss_end+0x347b08>
  f8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  fc:	00000ecb 	andeq	r0, r0, fp, asr #29
 100:	0000001c 	andeq	r0, r0, ip, lsl r0
 104:	00000050 	andeq	r0, r0, r0, asr r0
 108:	00008158 	andeq	r8, r0, r8, asr r1
 10c:	00000018 	andeq	r0, r0, r8, lsl r0
 110:	8b040e42 	blhi	103a20 <__bss_end+0xfac28>
 114:	0b0d4201 	bleq	350920 <__bss_end+0x347b28>
 118:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
 11c:	00000ecb 	andeq	r0, r0, fp, asr #29
 120:	00000014 	andeq	r0, r0, r4, lsl r0
 124:	00000050 	andeq	r0, r0, r0, asr r0
 128:	00008170 	andeq	r8, r0, r0, ror r1
 12c:	0000000c 	andeq	r0, r0, ip
 130:	8b040e42 	blhi	103a40 <__bss_end+0xfac48>
 134:	0b0d4201 	bleq	350940 <__bss_end+0x347b48>
 138:	0000001c 	andeq	r0, r0, ip, lsl r0
 13c:	00000050 	andeq	r0, r0, r0, asr r0
 140:	0000817c 	andeq	r8, r0, ip, ror r1
 144:	00000058 	andeq	r0, r0, r8, asr r0
 148:	8b080e42 	blhi	203a58 <__bss_end+0x1fac60>
 14c:	42018e02 	andmi	r8, r1, #2, 28
 150:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 154:	00080d0c 	andeq	r0, r8, ip, lsl #26
 158:	0000001c 	andeq	r0, r0, ip, lsl r0
 15c:	00000050 	andeq	r0, r0, r0, asr r0
 160:	000081d4 	ldrdeq	r8, [r0], -r4
 164:	00000058 	andeq	r0, r0, r8, asr r0
 168:	8b080e42 	blhi	203a78 <__bss_end+0x1fac80>
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
 194:	00000020 	andeq	r0, r0, r0, lsr #32
 198:	8b080e42 	blhi	203aa8 <__bss_end+0x1facb0>
 19c:	42018e02 	andmi	r8, r1, #2, 28
 1a0:	00040b0c 	andeq	r0, r4, ip, lsl #22
 1a4:	0000000c 	andeq	r0, r0, ip
 1a8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 1ac:	7c020001 	stcvc	0, cr0, [r2], {1}
 1b0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 1b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1b8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1bc:	0000824c 	andeq	r8, r0, ip, asr #4
 1c0:	0000002c 	andeq	r0, r0, ip, lsr #32
 1c4:	8b040e42 	blhi	103ad4 <__bss_end+0xfacdc>
 1c8:	0b0d4201 	bleq	3509d4 <__bss_end+0x347bdc>
 1cc:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 1d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 1d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1d8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1dc:	00008278 	andeq	r8, r0, r8, ror r2
 1e0:	0000002c 	andeq	r0, r0, ip, lsr #32
 1e4:	8b040e42 	blhi	103af4 <__bss_end+0xfacfc>
 1e8:	0b0d4201 	bleq	3509f4 <__bss_end+0x347bfc>
 1ec:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 1f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 1f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1f8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1fc:	000082a4 	andeq	r8, r0, r4, lsr #5
 200:	0000001c 	andeq	r0, r0, ip, lsl r0
 204:	8b040e42 	blhi	103b14 <__bss_end+0xfad1c>
 208:	0b0d4201 	bleq	350a14 <__bss_end+0x347c1c>
 20c:	420d0d46 	andmi	r0, sp, #4480	; 0x1180
 210:	00000ecb 	andeq	r0, r0, fp, asr #29
 214:	0000001c 	andeq	r0, r0, ip, lsl r0
 218:	000001a4 	andeq	r0, r0, r4, lsr #3
 21c:	000082c0 	andeq	r8, r0, r0, asr #5
 220:	00000044 	andeq	r0, r0, r4, asr #32
 224:	8b040e42 	blhi	103b34 <__bss_end+0xfad3c>
 228:	0b0d4201 	bleq	350a34 <__bss_end+0x347c3c>
 22c:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 230:	00000ecb 	andeq	r0, r0, fp, asr #29
 234:	0000001c 	andeq	r0, r0, ip, lsl r0
 238:	000001a4 	andeq	r0, r0, r4, lsr #3
 23c:	00008304 	andeq	r8, r0, r4, lsl #6
 240:	00000050 	andeq	r0, r0, r0, asr r0
 244:	8b040e42 	blhi	103b54 <__bss_end+0xfad5c>
 248:	0b0d4201 	bleq	350a54 <__bss_end+0x347c5c>
 24c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 250:	00000ecb 	andeq	r0, r0, fp, asr #29
 254:	0000001c 	andeq	r0, r0, ip, lsl r0
 258:	000001a4 	andeq	r0, r0, r4, lsr #3
 25c:	00008354 	andeq	r8, r0, r4, asr r3
 260:	00000050 	andeq	r0, r0, r0, asr r0
 264:	8b040e42 	blhi	103b74 <__bss_end+0xfad7c>
 268:	0b0d4201 	bleq	350a74 <__bss_end+0x347c7c>
 26c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 270:	00000ecb 	andeq	r0, r0, fp, asr #29
 274:	0000001c 	andeq	r0, r0, ip, lsl r0
 278:	000001a4 	andeq	r0, r0, r4, lsr #3
 27c:	000083a4 	andeq	r8, r0, r4, lsr #7
 280:	0000002c 	andeq	r0, r0, ip, lsr #32
 284:	8b040e42 	blhi	103b94 <__bss_end+0xfad9c>
 288:	0b0d4201 	bleq	350a94 <__bss_end+0x347c9c>
 28c:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 290:	00000ecb 	andeq	r0, r0, fp, asr #29
 294:	0000001c 	andeq	r0, r0, ip, lsl r0
 298:	000001a4 	andeq	r0, r0, r4, lsr #3
 29c:	000083d0 	ldrdeq	r8, [r0], -r0
 2a0:	00000050 	andeq	r0, r0, r0, asr r0
 2a4:	8b040e42 	blhi	103bb4 <__bss_end+0xfadbc>
 2a8:	0b0d4201 	bleq	350ab4 <__bss_end+0x347cbc>
 2ac:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 2b0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2b8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2bc:	00008420 	andeq	r8, r0, r0, lsr #8
 2c0:	00000044 	andeq	r0, r0, r4, asr #32
 2c4:	8b040e42 	blhi	103bd4 <__bss_end+0xfaddc>
 2c8:	0b0d4201 	bleq	350ad4 <__bss_end+0x347cdc>
 2cc:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 2d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2d8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2dc:	00008464 	andeq	r8, r0, r4, ror #8
 2e0:	00000050 	andeq	r0, r0, r0, asr r0
 2e4:	8b040e42 	blhi	103bf4 <__bss_end+0xfadfc>
 2e8:	0b0d4201 	bleq	350af4 <__bss_end+0x347cfc>
 2ec:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 2f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2f8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2fc:	000084b4 			; <UNDEFINED> instruction: 0x000084b4
 300:	00000054 	andeq	r0, r0, r4, asr r0
 304:	8b040e42 	blhi	103c14 <__bss_end+0xfae1c>
 308:	0b0d4201 	bleq	350b14 <__bss_end+0x347d1c>
 30c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 310:	00000ecb 	andeq	r0, r0, fp, asr #29
 314:	0000001c 	andeq	r0, r0, ip, lsl r0
 318:	000001a4 	andeq	r0, r0, r4, lsr #3
 31c:	00008508 	andeq	r8, r0, r8, lsl #10
 320:	0000003c 	andeq	r0, r0, ip, lsr r0
 324:	8b040e42 	blhi	103c34 <__bss_end+0xfae3c>
 328:	0b0d4201 	bleq	350b34 <__bss_end+0x347d3c>
 32c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 330:	00000ecb 	andeq	r0, r0, fp, asr #29
 334:	0000001c 	andeq	r0, r0, ip, lsl r0
 338:	000001a4 	andeq	r0, r0, r4, lsr #3
 33c:	00008544 	andeq	r8, r0, r4, asr #10
 340:	0000003c 	andeq	r0, r0, ip, lsr r0
 344:	8b040e42 	blhi	103c54 <__bss_end+0xfae5c>
 348:	0b0d4201 	bleq	350b54 <__bss_end+0x347d5c>
 34c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 350:	00000ecb 	andeq	r0, r0, fp, asr #29
 354:	0000001c 	andeq	r0, r0, ip, lsl r0
 358:	000001a4 	andeq	r0, r0, r4, lsr #3
 35c:	00008580 	andeq	r8, r0, r0, lsl #11
 360:	0000003c 	andeq	r0, r0, ip, lsr r0
 364:	8b040e42 	blhi	103c74 <__bss_end+0xfae7c>
 368:	0b0d4201 	bleq	350b74 <__bss_end+0x347d7c>
 36c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 370:	00000ecb 	andeq	r0, r0, fp, asr #29
 374:	0000001c 	andeq	r0, r0, ip, lsl r0
 378:	000001a4 	andeq	r0, r0, r4, lsr #3
 37c:	000085bc 			; <UNDEFINED> instruction: 0x000085bc
 380:	0000003c 	andeq	r0, r0, ip, lsr r0
 384:	8b040e42 	blhi	103c94 <__bss_end+0xfae9c>
 388:	0b0d4201 	bleq	350b94 <__bss_end+0x347d9c>
 38c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 390:	00000ecb 	andeq	r0, r0, fp, asr #29
 394:	0000001c 	andeq	r0, r0, ip, lsl r0
 398:	000001a4 	andeq	r0, r0, r4, lsr #3
 39c:	000085f8 	strdeq	r8, [r0], -r8	; <UNPREDICTABLE>
 3a0:	000000b0 	strheq	r0, [r0], -r0	; <UNPREDICTABLE>
 3a4:	8b080e42 	blhi	203cb4 <__bss_end+0x1faebc>
 3a8:	42018e02 	andmi	r8, r1, #2, 28
 3ac:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 3b0:	080d0c50 	stmdaeq	sp, {r4, r6, sl, fp}
 3b4:	0000000c 	andeq	r0, r0, ip
 3b8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 3bc:	7c020001 	stcvc	0, cr0, [r2], {1}
 3c0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 3c4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3c8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 3cc:	000086a8 	andeq	r8, r0, r8, lsr #13
 3d0:	00000174 	andeq	r0, r0, r4, ror r1
 3d4:	8b080e42 	blhi	203ce4 <__bss_end+0x1faeec>
 3d8:	42018e02 	andmi	r8, r1, #2, 28
 3dc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 3e0:	080d0cb2 	stmdaeq	sp, {r1, r4, r5, r7, sl, fp}
 3e4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3e8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 3ec:	0000881c 	andeq	r8, r0, ip, lsl r8
 3f0:	0000009c 	muleq	r0, ip, r0
 3f4:	8b040e42 	blhi	103d04 <__bss_end+0xfaf0c>
 3f8:	0b0d4201 	bleq	350c04 <__bss_end+0x347e0c>
 3fc:	0d0d4602 	stceq	6, cr4, [sp, #-8]
 400:	000ecb42 	andeq	ip, lr, r2, asr #22
 404:	0000001c 	andeq	r0, r0, ip, lsl r0
 408:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 40c:	000088b8 			; <UNDEFINED> instruction: 0x000088b8
 410:	000000c0 	andeq	r0, r0, r0, asr #1
 414:	8b040e42 	blhi	103d24 <__bss_end+0xfaf2c>
 418:	0b0d4201 	bleq	350c24 <__bss_end+0x347e2c>
 41c:	0d0d5802 	stceq	8, cr5, [sp, #-8]
 420:	000ecb42 	andeq	ip, lr, r2, asr #22
 424:	0000001c 	andeq	r0, r0, ip, lsl r0
 428:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 42c:	00008978 	andeq	r8, r0, r8, ror r9
 430:	000000ac 	andeq	r0, r0, ip, lsr #1
 434:	8b040e42 	blhi	103d44 <__bss_end+0xfaf4c>
 438:	0b0d4201 	bleq	350c44 <__bss_end+0x347e4c>
 43c:	0d0d4e02 	stceq	14, cr4, [sp, #-8]
 440:	000ecb42 	andeq	ip, lr, r2, asr #22
 444:	0000001c 	andeq	r0, r0, ip, lsl r0
 448:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 44c:	00008a24 	andeq	r8, r0, r4, lsr #20
 450:	00000054 	andeq	r0, r0, r4, asr r0
 454:	8b040e42 	blhi	103d64 <__bss_end+0xfaf6c>
 458:	0b0d4201 	bleq	350c64 <__bss_end+0x347e6c>
 45c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 460:	00000ecb 	andeq	r0, r0, fp, asr #29
 464:	0000001c 	andeq	r0, r0, ip, lsl r0
 468:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 46c:	00008a78 	andeq	r8, r0, r8, ror sl
 470:	00000068 	andeq	r0, r0, r8, rrx
 474:	8b040e42 	blhi	103d84 <__bss_end+0xfaf8c>
 478:	0b0d4201 	bleq	350c84 <__bss_end+0x347e8c>
 47c:	420d0d6c 	andmi	r0, sp, #108, 26	; 0x1b00
 480:	00000ecb 	andeq	r0, r0, fp, asr #29
 484:	0000001c 	andeq	r0, r0, ip, lsl r0
 488:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 48c:	00008ae0 	andeq	r8, r0, r0, ror #21
 490:	00000080 	andeq	r0, r0, r0, lsl #1
 494:	8b040e42 	blhi	103da4 <__bss_end+0xfafac>
 498:	0b0d4201 	bleq	350ca4 <__bss_end+0x347eac>
 49c:	420d0d78 	andmi	r0, sp, #120, 26	; 0x1e00
 4a0:	00000ecb 	andeq	r0, r0, fp, asr #29
 4a4:	0000000c 	andeq	r0, r0, ip
 4a8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 4ac:	7c010001 	stcvc	0, cr0, [r1], {1}
 4b0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 4b4:	0000000c 	andeq	r0, r0, ip
 4b8:	000004a4 	andeq	r0, r0, r4, lsr #9
 4bc:	00008b60 	andeq	r8, r0, r0, ror #22
 4c0:	000001ec 	andeq	r0, r0, ip, ror #3
