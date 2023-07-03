
./idle_process:     file format elf32-littlearm


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
    805c:	0000843c 	andeq	r8, r0, ip, lsr r4
    8060:	0000844c 	andeq	r8, r0, ip, asr #8

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
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/crt0.c:28

    // volani funkce main
    // nebudeme se zde zabyvat predavanim parametru do funkce main
    // jinak by se mohly predavat napr. namapovane do virtualniho adr. prostoru a odkazem pres zasobnik (kam nam muze OS
    // pushnout co chce)
    int result = main(0, 0);
    8078:	e3a01000 	mov	r1, #0
    807c:	e3a00000 	mov	r0, #0
    8080:	eb000069 	bl	822c <main>
    8084:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/crt0.c:31

    // volani destruktoru globalnich trid (C++)
    _cpp_shutdown();
    8088:	eb000051 	bl	81d4 <_cpp_shutdown>
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/crt0.c:34

    // volani terminate() syscallu s navratovym kodem funkce main
    asm volatile("mov r0, %0" : : "r"(result));
    808c:	e51b3008 	ldr	r3, [fp, #-8]
    8090:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/crt0.c:35
    asm volatile("svc #1");
    8094:	ef000001 	svc	0x00000001
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/crt0.c:36
}
    8098:	e320f000 	nop	{0}
    809c:	e24bd004 	sub	sp, fp, #4
    80a0:	e8bd8800 	pop	{fp, pc}

000080a4 <__cxa_guard_acquire>:
__cxa_guard_acquire():
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/cxxabi.cpp:11
    extern "C" int __cxa_guard_acquire(__guard*);
    extern "C" void __cxa_guard_release(__guard*);
    extern "C" void __cxa_guard_abort(__guard*);

    extern "C" int __cxa_guard_acquire(__guard* g)
    {
    80a4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    80a8:	e28db000 	add	fp, sp, #0
    80ac:	e24dd00c 	sub	sp, sp, #12
    80b0:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/cxxabi.cpp:12
        return !*(char*)(g);
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

    extern "C" void __cxa_guard_release(__guard* g)
    {
    80dc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    80e0:	e28db000 	add	fp, sp, #0
    80e4:	e24dd00c 	sub	sp, sp, #12
    80e8:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/cxxabi.cpp:17
        *(char*)g = 1;
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

    extern "C" void __cxa_guard_abort(__guard*)
    {
    8108:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    810c:	e28db000 	add	fp, sp, #0
    8110:	e24dd00c 	sub	sp, sp, #12
    8114:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/cxxabi.cpp:22
    }
    8118:	e320f000 	nop	{0}
    811c:	e28bd000 	add	sp, fp, #0
    8120:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8124:	e12fff1e 	bx	lr

00008128 <__dso_handle>:
__dso_handle():
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/cxxabi.cpp:26
}

extern "C" void __dso_handle()
{
    8128:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    812c:	e28db000 	add	fp, sp, #0
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/cxxabi.cpp:28
    // ignore dtors for now
}
    8130:	e320f000 	nop	{0}
    8134:	e28bd000 	add	sp, fp, #0
    8138:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    813c:	e12fff1e 	bx	lr

00008140 <__cxa_atexit>:
__cxa_atexit():
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/cxxabi.cpp:31

extern "C" void __cxa_atexit()
{
    8140:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8144:	e28db000 	add	fp, sp, #0
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/cxxabi.cpp:33
    // ignore dtors for now
}
    8148:	e320f000 	nop	{0}
    814c:	e28bd000 	add	sp, fp, #0
    8150:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8154:	e12fff1e 	bx	lr

00008158 <__cxa_pure_virtual>:
__cxa_pure_virtual():
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/cxxabi.cpp:36

extern "C" void __cxa_pure_virtual()
{
    8158:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    815c:	e28db000 	add	fp, sp, #0
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/cxxabi.cpp:38
    // pure virtual method called
}
    8160:	e320f000 	nop	{0}
    8164:	e28bd000 	add	sp, fp, #0
    8168:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    816c:	e12fff1e 	bx	lr

00008170 <__aeabi_unwind_cpp_pr1>:
__aeabi_unwind_cpp_pr1():
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/cxxabi.cpp:41

extern "C" void __aeabi_unwind_cpp_pr1()
{
    8170:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8174:	e28db000 	add	fp, sp, #0
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/cxxabi.cpp:42 (discriminator 1)
    while (true)
    8178:	eafffffe 	b	8178 <__aeabi_unwind_cpp_pr1+0x8>

0000817c <_cpp_startup>:
_cpp_startup():
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/cxxabi.cpp:60
extern "C" dtor_ptr __DTOR_LIST__[0];
// konec pole destruktoru
extern "C" dtor_ptr __DTOR_END__[0];

extern "C" int _cpp_startup(void)
{
    817c:	e92d4800 	push	{fp, lr}
    8180:	e28db004 	add	fp, sp, #4
    8184:	e24dd008 	sub	sp, sp, #8
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/cxxabi.cpp:65
    ctor_ptr* fnptr;

    // zavolame konstruktory globalnich C++ trid
    // v poli __CTOR_LIST__ jsou ukazatele na vygenerovane stuby volani konstruktoru
    for (fnptr = __CTOR_LIST__; fnptr < __CTOR_END__; fnptr++)
    8188:	e59f303c 	ldr	r3, [pc, #60]	; 81cc <_cpp_startup+0x50>
    818c:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/cxxabi.cpp:65 (discriminator 3)
    8190:	e51b3008 	ldr	r3, [fp, #-8]
    8194:	e59f2034 	ldr	r2, [pc, #52]	; 81d0 <_cpp_startup+0x54>
    8198:	e1530002 	cmp	r3, r2
    819c:	2a000006 	bcs	81bc <_cpp_startup+0x40>
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/cxxabi.cpp:66 (discriminator 2)
        (*fnptr)();
    81a0:	e51b3008 	ldr	r3, [fp, #-8]
    81a4:	e5933000 	ldr	r3, [r3]
    81a8:	e12fff33 	blx	r3
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/cxxabi.cpp:65 (discriminator 2)
    for (fnptr = __CTOR_LIST__; fnptr < __CTOR_END__; fnptr++)
    81ac:	e51b3008 	ldr	r3, [fp, #-8]
    81b0:	e2833004 	add	r3, r3, #4
    81b4:	e50b3008 	str	r3, [fp, #-8]
    81b8:	eafffff4 	b	8190 <_cpp_startup+0x14>
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/cxxabi.cpp:68

    return 0;
    81bc:	e3a03000 	mov	r3, #0
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/cxxabi.cpp:69
}
    81c0:	e1a00003 	mov	r0, r3
    81c4:	e24bd004 	sub	sp, fp, #4
    81c8:	e8bd8800 	pop	{fp, pc}
    81cc:	0000843c 	andeq	r8, r0, ip, lsr r4
    81d0:	0000843c 	andeq	r8, r0, ip, lsr r4

000081d4 <_cpp_shutdown>:
_cpp_shutdown():
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/cxxabi.cpp:72

extern "C" int _cpp_shutdown(void)
{
    81d4:	e92d4800 	push	{fp, lr}
    81d8:	e28db004 	add	fp, sp, #4
    81dc:	e24dd008 	sub	sp, sp, #8
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/cxxabi.cpp:76
    dtor_ptr* fnptr;

    // zavolame destruktory globalnich C++ trid
    for (fnptr = __DTOR_LIST__; fnptr < __DTOR_END__; fnptr++)
    81e0:	e59f303c 	ldr	r3, [pc, #60]	; 8224 <_cpp_shutdown+0x50>
    81e4:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/cxxabi.cpp:76 (discriminator 3)
    81e8:	e51b3008 	ldr	r3, [fp, #-8]
    81ec:	e59f2034 	ldr	r2, [pc, #52]	; 8228 <_cpp_shutdown+0x54>
    81f0:	e1530002 	cmp	r3, r2
    81f4:	2a000006 	bcs	8214 <_cpp_shutdown+0x40>
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/cxxabi.cpp:77 (discriminator 2)
        (*fnptr)();
    81f8:	e51b3008 	ldr	r3, [fp, #-8]
    81fc:	e5933000 	ldr	r3, [r3]
    8200:	e12fff33 	blx	r3
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/cxxabi.cpp:76 (discriminator 2)
    for (fnptr = __DTOR_LIST__; fnptr < __DTOR_END__; fnptr++)
    8204:	e51b3008 	ldr	r3, [fp, #-8]
    8208:	e2833004 	add	r3, r3, #4
    820c:	e50b3008 	str	r3, [fp, #-8]
    8210:	eafffff4 	b	81e8 <_cpp_shutdown+0x14>
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/cxxabi.cpp:79

    return 0;
    8214:	e3a03000 	mov	r3, #0
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/cxxabi.cpp:80
}
    8218:	e1a00003 	mov	r0, r3
    821c:	e24bd004 	sub	sp, fp, #4
    8220:	e8bd8800 	pop	{fp, pc}
    8224:	0000843c 	andeq	r8, r0, ip, lsr r4
    8228:	0000843c 	andeq	r8, r0, ip, lsr r4

0000822c <main>:
main():
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/idle_process/main.cpp:4
#include <stdfile.h>

int main(int argc, char** argv)
{
    822c:	e92d4800 	push	{fp, lr}
    8230:	e28db004 	add	fp, sp, #4
    8234:	e24dd008 	sub	sp, sp, #8
    8238:	e50b0008 	str	r0, [fp, #-8]
    823c:	e50b100c 	str	r1, [fp, #-12]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/idle_process/main.cpp:11 (discriminator 1)
    // treba

    while (true)
    {
        // predame zbytek casoveho kvanta dalsimu procesu
        sched_yield();
    8240:	eb000016 	bl	82a0 <_Z11sched_yieldv>
    8244:	eafffffd 	b	8240 <main+0x14>

00008248 <_Z6getpidv>:
_Z6getpidv():
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:4
#include <stdfile.h>

uint32_t getpid()
{
    8248:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    824c:	e28db000 	add	fp, sp, #0
    8250:	e24dd00c 	sub	sp, sp, #12
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:7
    uint32_t pid;

    asm volatile("swi 0");
    8254:	ef000000 	svc	0x00000000
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:8
    asm volatile("mov %0, r0" : "=r"(pid));
    8258:	e1a03000 	mov	r3, r0
    825c:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:10

    return pid;
    8260:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:11
}
    8264:	e1a00003 	mov	r0, r3
    8268:	e28bd000 	add	sp, fp, #0
    826c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8270:	e12fff1e 	bx	lr

00008274 <_Z9terminatei>:
_Z9terminatei():
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:14

void terminate(int exitcode)
{
    8274:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8278:	e28db000 	add	fp, sp, #0
    827c:	e24dd00c 	sub	sp, sp, #12
    8280:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:15
    asm volatile("mov r0, %0" : : "r"(exitcode));
    8284:	e51b3008 	ldr	r3, [fp, #-8]
    8288:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:16
    asm volatile("swi 1");
    828c:	ef000001 	svc	0x00000001
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:17
}
    8290:	e320f000 	nop	{0}
    8294:	e28bd000 	add	sp, fp, #0
    8298:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    829c:	e12fff1e 	bx	lr

000082a0 <_Z11sched_yieldv>:
_Z11sched_yieldv():
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:20

void sched_yield()
{
    82a0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    82a4:	e28db000 	add	fp, sp, #0
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:21
    asm volatile("swi 2");
    82a8:	ef000002 	svc	0x00000002
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:22
}
    82ac:	e320f000 	nop	{0}
    82b0:	e28bd000 	add	sp, fp, #0
    82b4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    82b8:	e12fff1e 	bx	lr

000082bc <_Z4openPKc15NFile_Open_Mode>:
_Z4openPKc15NFile_Open_Mode():
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:25

uint32_t open(const char* filename, NFile_Open_Mode mode)
{
    82bc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    82c0:	e28db000 	add	fp, sp, #0
    82c4:	e24dd014 	sub	sp, sp, #20
    82c8:	e50b0010 	str	r0, [fp, #-16]
    82cc:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:28
    uint32_t file;

    asm volatile("mov r0, %0" : : "r"(filename));
    82d0:	e51b3010 	ldr	r3, [fp, #-16]
    82d4:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:29
    asm volatile("mov r1, %0" : : "r"(mode));
    82d8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    82dc:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:30
    asm volatile("swi 64");
    82e0:	ef000040 	svc	0x00000040
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:31
    asm volatile("mov %0, r0" : "=r"(file));
    82e4:	e1a03000 	mov	r3, r0
    82e8:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:33

    return file;
    82ec:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:34
}
    82f0:	e1a00003 	mov	r0, r3
    82f4:	e28bd000 	add	sp, fp, #0
    82f8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    82fc:	e12fff1e 	bx	lr

00008300 <_Z4readjPcj>:
_Z4readjPcj():
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:37

uint32_t read(uint32_t file, char* const buffer, uint32_t size)
{
    8300:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8304:	e28db000 	add	fp, sp, #0
    8308:	e24dd01c 	sub	sp, sp, #28
    830c:	e50b0010 	str	r0, [fp, #-16]
    8310:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8314:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:40
    uint32_t rdnum;

    asm volatile("mov r0, %0" : : "r"(file));
    8318:	e51b3010 	ldr	r3, [fp, #-16]
    831c:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:41
    asm volatile("mov r1, %0" : : "r"(buffer));
    8320:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8324:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:42
    asm volatile("mov r2, %0" : : "r"(size));
    8328:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    832c:	e1a02003 	mov	r2, r3
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:43
    asm volatile("swi 65");
    8330:	ef000041 	svc	0x00000041
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:44
    asm volatile("mov %0, r0" : "=r"(rdnum));
    8334:	e1a03000 	mov	r3, r0
    8338:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:46

    return rdnum;
    833c:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:47
}
    8340:	e1a00003 	mov	r0, r3
    8344:	e28bd000 	add	sp, fp, #0
    8348:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    834c:	e12fff1e 	bx	lr

00008350 <_Z5writejPKcj>:
_Z5writejPKcj():
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:50

uint32_t write(uint32_t file, const char* buffer, uint32_t size)
{
    8350:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8354:	e28db000 	add	fp, sp, #0
    8358:	e24dd01c 	sub	sp, sp, #28
    835c:	e50b0010 	str	r0, [fp, #-16]
    8360:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8364:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:53
    uint32_t wrnum;

    asm volatile("mov r0, %0" : : "r"(file));
    8368:	e51b3010 	ldr	r3, [fp, #-16]
    836c:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:54
    asm volatile("mov r1, %0" : : "r"(buffer));
    8370:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8374:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:55
    asm volatile("mov r2, %0" : : "r"(size));
    8378:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    837c:	e1a02003 	mov	r2, r3
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:56
    asm volatile("swi 66");
    8380:	ef000042 	svc	0x00000042
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:57
    asm volatile("mov %0, r0" : "=r"(wrnum));
    8384:	e1a03000 	mov	r3, r0
    8388:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:59

    return wrnum;
    838c:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:60
}
    8390:	e1a00003 	mov	r0, r3
    8394:	e28bd000 	add	sp, fp, #0
    8398:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    839c:	e12fff1e 	bx	lr

000083a0 <_Z5closej>:
_Z5closej():
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:63

void close(uint32_t file)
{
    83a0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    83a4:	e28db000 	add	fp, sp, #0
    83a8:	e24dd00c 	sub	sp, sp, #12
    83ac:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:64
    asm volatile("mov r0, %0" : : "r"(file));
    83b0:	e51b3008 	ldr	r3, [fp, #-8]
    83b4:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:65
    asm volatile("swi 67");
    83b8:	ef000043 	svc	0x00000043
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:66
}
    83bc:	e320f000 	nop	{0}
    83c0:	e28bd000 	add	sp, fp, #0
    83c4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    83c8:	e12fff1e 	bx	lr

000083cc <_Z5ioctlj16NIOCtl_OperationPv>:
_Z5ioctlj16NIOCtl_OperationPv():
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:69

uint32_t ioctl(uint32_t file, NIOCtl_Operation operation, void* param)
{
    83cc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    83d0:	e28db000 	add	fp, sp, #0
    83d4:	e24dd01c 	sub	sp, sp, #28
    83d8:	e50b0010 	str	r0, [fp, #-16]
    83dc:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    83e0:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:72
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r"(file));
    83e4:	e51b3010 	ldr	r3, [fp, #-16]
    83e8:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:73
    asm volatile("mov r1, %0" : : "r"(operation));
    83ec:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    83f0:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:74
    asm volatile("mov r2, %0" : : "r"(param));
    83f4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    83f8:	e1a02003 	mov	r2, r3
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:75
    asm volatile("swi 68");
    83fc:	ef000044 	svc	0x00000044
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:76
    asm volatile("mov %0, r0" : "=r"(retcode));
    8400:	e1a03000 	mov	r3, r0
    8404:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:78

    return retcode;
    8408:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:79
}
    840c:	e1a00003 	mov	r0, r3
    8410:	e28bd000 	add	sp, fp, #0
    8414:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8418:	e12fff1e 	bx	lr

Disassembly of section .rodata:

0000841c <_ZL21MaxFSDriverNameLength>:
    841c:	00000010 	andeq	r0, r0, r0, lsl r0

00008420 <_ZL17MaxFilenameLength>:
    8420:	00000010 	andeq	r0, r0, r0, lsl r0

00008424 <_ZL13MaxPathLength>:
    8424:	00000080 	andeq	r0, r0, r0, lsl #1

00008428 <_ZL18NoFilesystemDriver>:
    8428:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000842c <_ZL21MaxFSDriverNameLength>:
    842c:	00000010 	andeq	r0, r0, r0, lsl r0

00008430 <_ZL17MaxFilenameLength>:
    8430:	00000010 	andeq	r0, r0, r0, lsl r0

00008434 <_ZL13MaxPathLength>:
    8434:	00000080 	andeq	r0, r0, r0, lsl #1

00008438 <_ZL18NoFilesystemDriver>:
    8438:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

Disassembly of section .bss:

0000843c <__bss_start>:
	...

Disassembly of section .ARM.attributes:

00000000 <.ARM.attributes>:
   0:	00002e41 	andeq	r2, r0, r1, asr #28
   4:	61656100 	cmnvs	r5, r0, lsl #2
   8:	01006962 	tsteq	r0, r2, ror #18
   c:	00000024 	andeq	r0, r0, r4, lsr #32
  10:	4b5a3605 	blmi	168d82c <__bss_end+0x16853e0>
  14:	08070600 	stmdaeq	r7, {r9, sl}
  18:	0a010901 	beq	42424 <__bss_end+0x39fd8>
  1c:	14041202 	strne	r1, [r4], #-514	; 0xfffffdfe
  20:	17011501 	strne	r1, [r1, -r1, lsl #10]
  24:	1a011803 	bne	46038 <__bss_end+0x3dbec>
  28:	22011c01 	andcs	r1, r1, #256	; 0x100
  2c:	Address 0x000000000000002c is out of bounds.


Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347 	bcc	10d0d24 <__bss_end+0x10c88d8>
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
  44:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffad8 <__bss_end+0xffff768c>
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
  b4:	442f6162 	strtmi	r6, [pc], #-354	; bc <_start-0x7f44>
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
 134:	05053412 	streq	r3, [r5, #-1042]	; 0xfffffbee
 138:	054b3185 	strbeq	r3, [fp, #-389]	; 0xfffffe7b
 13c:	06022f01 	streq	r2, [r2], -r1, lsl #30
 140:	0b010100 	bleq	40548 <__bss_end+0x380fc>
 144:	03000001 	movweq	r0, #1
 148:	00008200 	andeq	r8, r0, r0, lsl #4
 14c:	fb010200 	blx	40956 <__bss_end+0x3850a>
 150:	01000d0e 	tsteq	r0, lr, lsl #26
 154:	00010101 	andeq	r0, r1, r1, lsl #2
 158:	00010000 	andeq	r0, r1, r0
 15c:	6d2f0100 	stfvss	f0, [pc, #-0]	; 164 <_start-0x7e9c>
 160:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
 164:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
 168:	4b2f7372 	blmi	bdcf38 <__bss_end+0xbd4aec>
 16c:	2f616275 	svccs	0x00616275
 170:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
 174:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
 178:	63532f73 	cmpvs	r3, #460	; 0x1cc
 17c:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; ffffffe4 <__bss_end+0xffff7b98>
 180:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
 184:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
 188:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 18c:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
 190:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
 194:	61702d36 	cmnvs	r0, r6, lsr sp
 198:	676e6967 	strbvs	r6, [lr, -r7, ror #18]!
 19c:	6573755f 	ldrbvs	r7, [r3, #-1375]!	; 0xfffffaa1
 1a0:	61707372 	cmnvs	r0, r2, ror r3
 1a4:	752f6563 	strvc	r6, [pc, #-1379]!	; fffffc49 <__bss_end+0xffff77fd>
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
 1d0:	02050005 	andeq	r0, r5, #5
 1d4:	000080a4 	andeq	r8, r0, r4, lsr #1
 1d8:	05010a03 	streq	r0, [r1, #-2563]	; 0xfffff5fd
 1dc:	10058311 	andne	r8, r5, r1, lsl r3
 1e0:	8305054a 	movwhi	r0, #21834	; 0x554a
 1e4:	83130585 	tsthi	r3, #557842432	; 0x21400000
 1e8:	85670505 	strbhi	r0, [r7, #-1285]!	; 0xfffffafb
 1ec:	86010583 	strhi	r0, [r1], -r3, lsl #11
 1f0:	854c854c 	strbhi	r8, [ip, #-1356]	; 0xfffffab4
 1f4:	0505854c 	streq	r8, [r5, #-1356]	; 0xfffffab4
 1f8:	01040200 	mrseq	r0, R12_usr
 1fc:	0301054b 	movweq	r0, #5451	; 0x154b
 200:	10052e12 	andne	r2, r5, r2, lsl lr
 204:	0027056b 	eoreq	r0, r7, fp, ror #10
 208:	4a030402 	bmi	c1218 <__bss_end+0xb8dcc>
 20c:	02000a05 	andeq	r0, r0, #20480	; 0x5000
 210:	05830204 	streq	r0, [r3, #516]	; 0x204
 214:	04020011 	streq	r0, [r2], #-17	; 0xffffffef
 218:	05054a02 	streq	r4, [r5, #-2562]	; 0xfffff5fe
 21c:	02040200 	andeq	r0, r4, #0, 4
 220:	850c052d 	strhi	r0, [ip, #-1325]	; 0xfffffad3
 224:	a12f0105 			; <UNDEFINED> instruction: 0xa12f0105
 228:	056a1005 	strbeq	r1, [sl, #-5]!
 22c:	04020027 	streq	r0, [r2], #-39	; 0xffffffd9
 230:	0a054a03 	beq	152a44 <__bss_end+0x14a5f8>
 234:	02040200 	andeq	r0, r4, #0, 4
 238:	00110583 	andseq	r0, r1, r3, lsl #11
 23c:	4a020402 	bmi	8124c <__bss_end+0x78e00>
 240:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
 244:	052d0204 	streq	r0, [sp, #-516]!	; 0xfffffdfc
 248:	0105850c 	tsteq	r5, ip, lsl #10
 24c:	000a022f 	andeq	r0, sl, pc, lsr #4
 250:	01930101 	orrseq	r0, r3, r1, lsl #2
 254:	00030000 	andeq	r0, r3, r0
 258:	00000177 	andeq	r0, r0, r7, ror r1
 25c:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
 260:	0101000d 	tsteq	r1, sp
 264:	00000101 	andeq	r0, r0, r1, lsl #2
 268:	00000100 	andeq	r0, r0, r0, lsl #2
 26c:	6e6d2f01 	cdpvs	15, 6, cr2, cr13, cr1, {0}
 270:	2f632f74 	svccs	0x00632f74
 274:	72657355 	rsbvc	r7, r5, #1409286145	; 0x54000001
 278:	754b2f73 	strbvc	r2, [fp, #-3955]	; 0xfffff08d
 27c:	442f6162 	strtmi	r6, [pc], #-354	; 284 <_start-0x7d7c>
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
 2c0:	656c6469 	strbvs	r6, [ip, #-1129]!	; 0xfffffb97
 2c4:	6f72705f 	svcvs	0x0072705f
 2c8:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
 2cc:	6e6d2f00 	cdpvs	15, 6, cr2, cr13, cr0, {0}
 2d0:	2f632f74 	svccs	0x00632f74
 2d4:	72657355 	rsbvc	r7, r5, #1409286145	; 0x54000001
 2d8:	754b2f73 	strbvc	r2, [fp, #-3955]	; 0xfffff08d
 2dc:	442f6162 	strtmi	r6, [pc], #-354	; 2e4 <_start-0x7d1c>
 2e0:	6d75636f 	ldclvs	3, cr6, [r5, #-444]!	; 0xfffffe44
 2e4:	73746e65 	cmnvc	r4, #1616	; 0x650
 2e8:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
 2ec:	2f6c6f6f 	svccs	0x006c6f6f
 2f0:	6f72655a 	svcvs	0x0072655a
 2f4:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
 2f8:	6178652f 	cmnvs	r8, pc, lsr #10
 2fc:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
 300:	36312f73 	shsub16cc	r2, r1, r3
 304:	6761702d 	strbvs	r7, [r1, -sp, lsr #32]!
 308:	5f676e69 	svcpl	0x00676e69
 30c:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
 310:	63617073 	cmnvs	r1, #115	; 0x73
 314:	73752f65 	cmnvc	r5, #404	; 0x194
 318:	70737265 	rsbsvc	r7, r3, r5, ror #4
 31c:	2f656361 	svccs	0x00656361
 320:	6b2f2e2e 	blvs	bcbbe0 <__bss_end+0xbc3794>
 324:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 328:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
 32c:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 330:	73662f65 	cmnvc	r6, #404	; 0x194
 334:	6e6d2f00 	cdpvs	15, 6, cr2, cr13, cr0, {0}
 338:	2f632f74 	svccs	0x00632f74
 33c:	72657355 	rsbvc	r7, r5, #1409286145	; 0x54000001
 340:	754b2f73 	strbvc	r2, [fp, #-3955]	; 0xfffff08d
 344:	442f6162 	strtmi	r6, [pc], #-354	; 34c <_start-0x7cb4>
 348:	6d75636f 	ldclvs	3, cr6, [r5, #-444]!	; 0xfffffe44
 34c:	73746e65 	cmnvc	r4, #1616	; 0x650
 350:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
 354:	2f6c6f6f 	svccs	0x006c6f6f
 358:	6f72655a 	svcvs	0x0072655a
 35c:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
 360:	6178652f 	cmnvs	r8, pc, lsr #10
 364:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
 368:	36312f73 	shsub16cc	r2, r1, r3
 36c:	6761702d 	strbvs	r7, [r1, -sp, lsr #32]!
 370:	5f676e69 	svcpl	0x00676e69
 374:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
 378:	63617073 	cmnvs	r1, #115	; 0x73
 37c:	73752f65 	cmnvc	r5, #404	; 0x194
 380:	70737265 	rsbsvc	r7, r3, r5, ror #4
 384:	2f656361 	svccs	0x00656361
 388:	6b2f2e2e 	blvs	bcbc48 <__bss_end+0xbc37fc>
 38c:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 390:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
 394:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 398:	6f622f65 	svcvs	0x00622f65
 39c:	2f647261 	svccs	0x00647261
 3a0:	30697072 	rsbcc	r7, r9, r2, ror r0
 3a4:	6c61682f 	stclvs	8, cr6, [r1], #-188	; 0xffffff44
 3a8:	616d0000 	cmnvs	sp, r0
 3ac:	632e6e69 			; <UNDEFINED> instruction: 0x632e6e69
 3b0:	01007070 	tsteq	r0, r0, ror r0
 3b4:	69660000 	stmdbvs	r6!, {}^	; <UNPREDICTABLE>
 3b8:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
 3bc:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
 3c0:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 3c4:	6e690000 	cdpvs	0, 6, cr0, cr9, cr0, {0}
 3c8:	66656474 			; <UNDEFINED> instruction: 0x66656474
 3cc:	0300682e 	movweq	r6, #2094	; 0x82e
 3d0:	05000000 	streq	r0, [r0, #-0]
 3d4:	02050001 	andeq	r0, r5, #1
 3d8:	0000822c 	andeq	r8, r0, ip, lsr #4
 3dc:	00140515 	andseq	r0, r4, r5, lsl r5
 3e0:	a5010402 	strge	r0, [r1, #-1026]	; 0xfffffbfe
 3e4:	01000402 	tsteq	r0, r2, lsl #8
 3e8:	00022a01 	andeq	r2, r2, r1, lsl #20
 3ec:	bd000300 	stclt	3, cr0, [r0, #-0]
 3f0:	02000001 	andeq	r0, r0, #1
 3f4:	0d0efb01 	vstreq	d15, [lr, #-4]
 3f8:	01010100 	mrseq	r0, (UNDEF: 17)
 3fc:	00000001 	andeq	r0, r0, r1
 400:	01000001 	tsteq	r0, r1
 404:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
 408:	552f632f 	strpl	r6, [pc, #-815]!	; e1 <_start-0x7f1f>
 40c:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 410:	62754b2f 	rsbsvs	r4, r5, #48128	; 0xbc00
 414:	6f442f61 	svcvs	0x00442f61
 418:	656d7563 	strbvs	r7, [sp, #-1379]!	; 0xfffffa9d
 41c:	2f73746e 	svccs	0x0073746e
 420:	6f686353 	svcvs	0x00686353
 424:	5a2f6c6f 	bpl	bdb5e8 <__bss_end+0xbd319c>
 428:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 29c <_start-0x7d64>
 42c:	2f657461 	svccs	0x00657461
 430:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
 434:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
 438:	2d36312f 	ldfcss	f3, [r6, #-188]!	; 0xffffff44
 43c:	69676170 	stmdbvs	r7!, {r4, r5, r6, r8, sp, lr}^
 440:	755f676e 	ldrbvc	r6, [pc, #-1902]	; fffffcda <__bss_end+0xffff788e>
 444:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 448:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
 44c:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
 450:	2f62696c 	svccs	0x0062696c
 454:	00637273 	rsbeq	r7, r3, r3, ror r2
 458:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
 45c:	552f632f 	strpl	r6, [pc, #-815]!	; 135 <_start-0x7ecb>
 460:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 464:	62754b2f 	rsbsvs	r4, r5, #48128	; 0xbc00
 468:	6f442f61 	svcvs	0x00442f61
 46c:	656d7563 	strbvs	r7, [sp, #-1379]!	; 0xfffffa9d
 470:	2f73746e 	svccs	0x0073746e
 474:	6f686353 	svcvs	0x00686353
 478:	5a2f6c6f 	bpl	bdb63c <__bss_end+0xbd31f0>
 47c:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 2f0 <_start-0x7d10>
 480:	2f657461 	svccs	0x00657461
 484:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
 488:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
 48c:	2d36312f 	ldfcss	f3, [r6, #-188]!	; 0xffffff44
 490:	69676170 	stmdbvs	r7!, {r4, r5, r6, r8, sp, lr}^
 494:	755f676e 	ldrbvc	r6, [pc, #-1902]	; fffffd2e <__bss_end+0xffff78e2>
 498:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 49c:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
 4a0:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 4a4:	2f6c656e 	svccs	0x006c656e
 4a8:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 4ac:	2f656475 	svccs	0x00656475
 4b0:	2f007366 	svccs	0x00007366
 4b4:	2f746e6d 	svccs	0x00746e6d
 4b8:	73552f63 	cmpvc	r5, #396	; 0x18c
 4bc:	2f737265 	svccs	0x00737265
 4c0:	6162754b 	cmnvs	r2, fp, asr #10
 4c4:	636f442f 	cmnvs	pc, #788529152	; 0x2f000000
 4c8:	6e656d75 	mcrvs	13, 3, r6, cr5, cr5, {3}
 4cc:	532f7374 			; <UNDEFINED> instruction: 0x532f7374
 4d0:	6f6f6863 	svcvs	0x006f6863
 4d4:	655a2f6c 	ldrbvs	r2, [sl, #-3948]	; 0xfffff094
 4d8:	614d6f72 	hvcvs	55026	; 0xd6f2
 4dc:	652f6574 	strvs	r6, [pc, #-1396]!	; ffffff70 <__bss_end+0xffff7b24>
 4e0:	706d6178 	rsbvc	r6, sp, r8, ror r1
 4e4:	2f73656c 	svccs	0x0073656c
 4e8:	702d3631 	eorvc	r3, sp, r1, lsr r6
 4ec:	6e696761 	cdpvs	7, 6, cr6, cr9, cr1, {3}
 4f0:	73755f67 	cmnvc	r5, #412	; 0x19c
 4f4:	70737265 	rsbsvc	r7, r3, r5, ror #4
 4f8:	2f656361 	svccs	0x00656361
 4fc:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 500:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 504:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 508:	702f6564 	eorvc	r6, pc, r4, ror #10
 50c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
 510:	2f007373 	svccs	0x00007373
 514:	2f746e6d 	svccs	0x00746e6d
 518:	73552f63 	cmpvc	r5, #396	; 0x18c
 51c:	2f737265 	svccs	0x00737265
 520:	6162754b 	cmnvs	r2, fp, asr #10
 524:	636f442f 	cmnvs	pc, #788529152	; 0x2f000000
 528:	6e656d75 	mcrvs	13, 3, r6, cr5, cr5, {3}
 52c:	532f7374 			; <UNDEFINED> instruction: 0x532f7374
 530:	6f6f6863 	svcvs	0x006f6863
 534:	655a2f6c 	ldrbvs	r2, [sl, #-3948]	; 0xfffff094
 538:	614d6f72 	hvcvs	55026	; 0xd6f2
 53c:	652f6574 	strvs	r6, [pc, #-1396]!	; ffffffd0 <__bss_end+0xffff7b84>
 540:	706d6178 	rsbvc	r6, sp, r8, ror r1
 544:	2f73656c 	svccs	0x0073656c
 548:	702d3631 	eorvc	r3, sp, r1, lsr r6
 54c:	6e696761 	cdpvs	7, 6, cr6, cr9, cr1, {3}
 550:	73755f67 	cmnvc	r5, #412	; 0x19c
 554:	70737265 	rsbsvc	r7, r3, r5, ror #4
 558:	2f656361 	svccs	0x00656361
 55c:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 560:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 564:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 568:	622f6564 	eorvs	r6, pc, #100, 10	; 0x19000000
 56c:	6472616f 	ldrbtvs	r6, [r2], #-367	; 0xfffffe91
 570:	6970722f 	ldmdbvs	r0!, {r0, r1, r2, r3, r5, r9, ip, sp, lr}^
 574:	61682f30 	cmnvs	r8, r0, lsr pc
 578:	7300006c 	movwvc	r0, #108	; 0x6c
 57c:	69666474 	stmdbvs	r6!, {r2, r4, r5, r6, sl, sp, lr}^
 580:	632e656c 			; <UNDEFINED> instruction: 0x632e656c
 584:	01007070 	tsteq	r0, r0, ror r0
 588:	69660000 	stmdbvs	r6!, {}^	; <UNPREDICTABLE>
 58c:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
 590:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
 594:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 598:	77730000 	ldrbvc	r0, [r3, -r0]!
 59c:	00682e69 	rsbeq	r2, r8, r9, ror #28
 5a0:	69000003 	stmdbvs	r0, {r0, r1}
 5a4:	6564746e 	strbvs	r7, [r4, #-1134]!	; 0xfffffb92
 5a8:	00682e66 	rsbeq	r2, r8, r6, ror #28
 5ac:	00000004 	andeq	r0, r0, r4
 5b0:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
 5b4:	00824802 	addeq	r4, r2, r2, lsl #16
 5b8:	05051500 	streq	r1, [r5, #-1280]	; 0xfffffb00
 5bc:	0c052f69 	stceq	15, cr2, [r5], {105}	; 0x69
 5c0:	2f01054c 	svccs	0x0001054c
 5c4:	83050585 	movwhi	r0, #21893	; 0x5585
 5c8:	2f01054b 	svccs	0x0001054b
 5cc:	4b050585 	blmi	141be8 <__bss_end+0x13979c>
 5d0:	852f0105 	strhi	r0, [pc, #-261]!	; 4d3 <_start-0x7b2d>
 5d4:	4ba10505 	blmi	fe8419f0 <__bss_end+0xfe8395a4>
 5d8:	0c052f4b 	stceq	15, cr2, [r5], {75}	; 0x4b
 5dc:	2f01054c 	svccs	0x0001054c
 5e0:	bd050585 	cfstr32lt	mvfx0, [r5, #-532]	; 0xfffffdec
 5e4:	2f4b4b4b 	svccs	0x004b4b4b
 5e8:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 5ec:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 5f0:	4b4bbd05 	blmi	12efa0c <__bss_end+0x12e75c0>
 5f4:	0c052f4b 	stceq	15, cr2, [r5], {75}	; 0x4b
 5f8:	2f01054c 	svccs	0x0001054c
 5fc:	83050585 	movwhi	r0, #21893	; 0x5585
 600:	2f01054b 	svccs	0x0001054b
 604:	bd050585 	cfstr32lt	mvfx0, [r5, #-532]	; 0xfffffdec
 608:	2f4b4b4b 	svccs	0x004b4b4b
 60c:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 610:	08022f01 	stmdaeq	r2, {r0, r8, r9, sl, fp, sp}
 614:	a4010100 	strge	r0, [r1], #-256	; 0xffffff00
 618:	03000000 	movweq	r0, #0
 61c:	00009e00 	andeq	r9, r0, r0, lsl #28
 620:	fb010200 	blx	40e2a <__bss_end+0x389de>
 624:	01000d0e 	tsteq	r0, lr, lsl #26
 628:	00010101 	andeq	r0, r1, r1, lsl #2
 62c:	00010000 	andeq	r0, r1, r0
 630:	2e2e0100 	sufcse	f0, f6, f0
 634:	2f2e2e2f 	svccs	0x002e2e2f
 638:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 63c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 640:	672f2e2f 	strvs	r2, [pc, -pc, lsr #28]!
 644:	2e006363 	cdpcs	3, 0, cr6, cr0, cr3, {3}
 648:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 64c:	2f2e2e2f 	svccs	0x002e2e2f
 650:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 654:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 658:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
 65c:	2f636367 	svccs	0x00636367
 660:	672f2e2e 	strvs	r2, [pc, -lr, lsr #28]!
 664:	632f6363 			; <UNDEFINED> instruction: 0x632f6363
 668:	69666e6f 	stmdbvs	r6!, {r0, r1, r2, r3, r5, r6, r9, sl, fp, sp, lr}^
 66c:	72612f67 	rsbvc	r2, r1, #412	; 0x19c
 670:	2e2e006d 	cdpcs	0, 2, cr0, cr14, cr13, {3}
 674:	2f2e2e2f 	svccs	0x002e2e2f
 678:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 67c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 680:	2f2e2e2f 	svccs	0x002e2e2f
 684:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
 688:	00006363 	andeq	r6, r0, r3, ror #6
 68c:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
 690:	2e617369 	cdpcs	3, 6, cr7, cr1, cr9, {3}
 694:	00010068 	andeq	r0, r1, r8, rrx
 698:	6d726100 	ldfvse	f6, [r2, #-0]
 69c:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 6a0:	62670000 	rsbvs	r0, r7, #0
 6a4:	74632d6c 	strbtvc	r2, [r3], #-3436	; 0xfffff294
 6a8:	2e73726f 	cdpcs	2, 7, cr7, cr3, cr15, {3}
 6ac:	00030068 	andeq	r0, r3, r8, rrx
 6b0:	62696c00 	rsbvs	r6, r9, #0, 24
 6b4:	32636367 	rsbcc	r6, r3, #-1677721599	; 0x9c000001
 6b8:	0300632e 	movweq	r6, #814	; 0x32e
 6bc:	Address 0x00000000000006bc is out of bounds.


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
  38:	5a000001 	bpl	44 <_start-0x7fbc>
  3c:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
  40:	9c000080 	stcls	0, cr0, [r0], {128}	; 0x80
  44:	8a000000 	bhi	4c <_start-0x7fb4>
  48:	02000000 	andeq	r0, r0, #0
  4c:	000001bc 			; <UNDEFINED> instruction: 0x000001bc
  50:	31150601 	tstcc	r5, r1, lsl #12
  54:	03000000 	movweq	r0, #0
  58:	0ac80704 	beq	ff201c70 <__bss_end+0xff1f9824>
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
  84:	091c0100 	ldmdbeq	ip, {r8}
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
  b0:	0b010000 	bleq	400b8 <__bss_end+0x37c6c>
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
  ec:	2e010000 	cdpcs	0, 0, cr0, cr1, cr0, {0}
  f0:	00003107 	andeq	r3, r0, r7, lsl #2
  f4:	37040300 	strcc	r0, [r4, -r0, lsl #6]
  f8:	04000000 	streq	r0, [r0], #-0
  fc:	00028802 	andeq	r8, r2, r2, lsl #16
 100:	072f0100 	streq	r0, [pc, -r0, lsl #2]!
 104:	00000031 	andeq	r0, r0, r1, lsr r0
 108:	00002505 	andeq	r2, r0, r5, lsl #10
 10c:	00005700 	andeq	r5, r0, r0, lsl #14
 110:	00570600 	subseq	r0, r7, r0, lsl #12
 114:	ffff0000 			; <UNDEFINED> instruction: 0xffff0000
 118:	0700ffff 			; <UNDEFINED> instruction: 0x0700ffff
 11c:	0ac80704 	beq	ff201d34 <__bss_end+0xff1f98e8>
 120:	d2080000 	andle	r0, r8, #0
 124:	01000003 	tsteq	r0, r3
 128:	00441532 	subeq	r1, r4, r2, lsr r5
 12c:	4e080000 	cdpmi	0, 0, cr0, cr8, cr0, {0}
 130:	01000002 	tsteq	r0, r2
 134:	00441534 	subeq	r1, r4, r4, lsr r5
 138:	38050000 	stmdacc	r5, {}	; <UNPREDICTABLE>
 13c:	89000000 	stmdbhi	r0, {}	; <UNPREDICTABLE>
 140:	06000000 	streq	r0, [r0], -r0
 144:	00000057 	andeq	r0, r0, r7, asr r0
 148:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 14c:	02680800 	rsbeq	r0, r8, #0, 16
 150:	37010000 	strcc	r0, [r1, -r0]
 154:	00007615 	andeq	r7, r0, r5, lsl r6
 158:	02ef0800 	rsceq	r0, pc, #0, 16
 15c:	39010000 	stmdbcc	r1, {}	; <UNPREDICTABLE>
 160:	00007615 	andeq	r7, r0, r5, lsl r6
 164:	02080900 	andeq	r0, r8, #0, 18
 168:	47010000 	strmi	r0, [r1, -r0]
 16c:	0000cb10 	andeq	ip, r0, r0, lsl fp
 170:	0081d400 	addeq	sp, r1, r0, lsl #8
 174:	00005800 	andeq	r5, r0, r0, lsl #16
 178:	cb9c0100 	blgt	fe700580 <__bss_end+0xfe6f8134>
 17c:	0a000000 	beq	184 <_start-0x7e7c>
 180:	00000216 	andeq	r0, r0, r6, lsl r2
 184:	d20f4901 	andle	r4, pc, #16384	; 0x4000
 188:	02000000 	andeq	r0, r0, #0
 18c:	0b007491 	bleq	1d3d8 <__bss_end+0x14f8c>
 190:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
 194:	04030074 	streq	r0, [r3], #-116	; 0xffffff8c
 198:	00000038 	andeq	r0, r0, r8, lsr r0
 19c:	00031709 	andeq	r1, r3, r9, lsl #14
 1a0:	103b0100 	eorsne	r0, fp, r0, lsl #2
 1a4:	000000cb 	andeq	r0, r0, fp, asr #1
 1a8:	0000817c 	andeq	r8, r0, ip, ror r1
 1ac:	00000058 	andeq	r0, r0, r8, asr r0
 1b0:	01029c01 	tsteq	r2, r1, lsl #24
 1b4:	160a0000 	strne	r0, [sl], -r0
 1b8:	01000002 	tsteq	r0, r2
 1bc:	01020f3d 	tsteq	r2, sp, lsr pc
 1c0:	91020000 	mrsls	r0, (UNDEF: 2)
 1c4:	04030074 	streq	r0, [r3], #-116	; 0xffffff8c
 1c8:	00000025 	andeq	r0, r0, r5, lsr #32
 1cc:	0001f10c 	andeq	pc, r1, ip, lsl #2
 1d0:	11280100 			; <UNDEFINED> instruction: 0x11280100
 1d4:	00008170 	andeq	r8, r0, r0, ror r1
 1d8:	0000000c 	andeq	r0, r0, ip
 1dc:	270c9c01 	strcs	r9, [ip, -r1, lsl #24]
 1e0:	01000002 	tsteq	r0, r2
 1e4:	81581123 	cmphi	r8, r3, lsr #2
 1e8:	00180000 	andseq	r0, r8, r0
 1ec:	9c010000 	stcls	0, cr0, [r1], {-0}
 1f0:	0002fc0c 	andeq	pc, r2, ip, lsl #24
 1f4:	111e0100 	tstne	lr, r0, lsl #2
 1f8:	00008140 	andeq	r8, r0, r0, asr #2
 1fc:	00000018 	andeq	r0, r0, r8, lsl r0
 200:	5b0c9c01 	blpl	32720c <__bss_end+0x31edc0>
 204:	01000002 	tsteq	r0, r2
 208:	81281119 			; <UNDEFINED> instruction: 0x81281119
 20c:	00180000 	andseq	r0, r8, r0
 210:	9c010000 	stcls	0, cr0, [r1], {-0}
 214:	00021c0d 	andeq	r1, r2, sp, lsl #24
 218:	9e000200 	cdpls	2, 0, cr0, cr0, cr0, {0}
 21c:	0e000001 	cdpeq	0, 0, cr0, cr0, cr1, {0}
 220:	00000276 	andeq	r0, r0, r6, ror r2
 224:	6d151401 	cfldrsvs	mvf1, [r5, #-4]
 228:	0f000001 	svceq	0x00000001
 22c:	0000019e 	muleq	r0, lr, r1
 230:	01e90200 	mvneq	r0, r0, lsl #4
 234:	04010000 	streq	r0, [r1], #-0
 238:	0001a41f 	andeq	sl, r1, pc, lsl r4
 23c:	023a0e00 	eorseq	r0, sl, #0, 28
 240:	0f010000 	svceq	0x00010000
 244:	00018b15 	andeq	r8, r1, r5, lsl fp
 248:	019e0f00 	orrseq	r0, lr, r0, lsl #30
 24c:	10000000 	andne	r0, r0, r0
 250:	000003e9 	andeq	r0, r0, r9, ror #7
 254:	cb140a01 	blgt	502a60 <__bss_end+0x4fa614>
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
 2a0:	320f0100 	andcc	r0, pc, #0, 2
 2a4:	0000019e 	muleq	r0, lr, r1
 2a8:	00749102 	rsbseq	r9, r4, r2, lsl #2
 2ac:	00018b14 	andeq	r8, r1, r4, lsl fp
 2b0:	0080a400 	addeq	sl, r0, r0, lsl #8
 2b4:	00003800 	andeq	r3, r0, r0, lsl #16
 2b8:	139c0100 	orrsne	r0, ip, #0, 2
 2bc:	0a010067 	beq	40460 <__bss_end+0x38014>
 2c0:	00019e31 	andeq	r9, r1, r1, lsr lr
 2c4:	74910200 	ldrvc	r0, [r1], #512	; 0x200
 2c8:	00f10000 	rscseq	r0, r1, r0
 2cc:	00040000 	andeq	r0, r4, r0
 2d0:	000001c6 	andeq	r0, r0, r6, asr #3
 2d4:	03240104 			; <UNDEFINED> instruction: 0x03240104
 2d8:	fd040000 	stc2	0, cr0, [r4, #-0]
 2dc:	5a000003 	bpl	2f0 <_start-0x7d10>
 2e0:	2c000000 	stccs	0, cr0, [r0], {-0}
 2e4:	1c000082 	stcne	0, cr0, [r0], {130}	; 0x82
 2e8:	52000000 	andpl	r0, r0, #0
 2ec:	02000002 	andeq	r0, r0, #2
 2f0:	04bd0801 	ldrteq	r0, [sp], #2049	; 0x801
 2f4:	02020000 	andeq	r0, r2, #0
 2f8:	0004da05 	andeq	sp, r4, r5, lsl #20
 2fc:	05040300 	streq	r0, [r4, #-768]	; 0xfffffd00
 300:	00746e69 	rsbseq	r6, r4, r9, ror #28
 304:	b4080102 	strlt	r0, [r8], #-258	; 0xfffffefe
 308:	02000004 	andeq	r0, r0, #4
 30c:	04c20702 	strbeq	r0, [r2], #1794	; 0x702
 310:	e9040000 	stmdb	r4, {}	; <UNPREDICTABLE>
 314:	03000004 	movweq	r0, #4
 318:	00590709 	subseq	r0, r9, r9, lsl #14
 31c:	48050000 	stmdami	r5, {}	; <UNPREDICTABLE>
 320:	02000000 	andeq	r0, r0, #0
 324:	0ac80704 	beq	ff201f3c <__bss_end+0xff1f9af0>
 328:	66060000 	strvs	r0, [r6], -r0
 32c:	02000004 	andeq	r0, r0, #4
 330:	00541a06 	subseq	r1, r4, r6, lsl #20
 334:	03050000 	movweq	r0, #20480	; 0x5000
 338:	0000841c 	andeq	r8, r0, ip, lsl r4
 33c:	00049406 	andeq	r9, r4, r6, lsl #8
 340:	1a080200 	bne	200b48 <__bss_end+0x1f86fc>
 344:	00000054 	andeq	r0, r0, r4, asr r0
 348:	84200305 	strthi	r0, [r0], #-773	; 0xfffffcfb
 34c:	a6060000 	strge	r0, [r6], -r0
 350:	02000004 	andeq	r0, r0, #4
 354:	00541a0a 	subseq	r1, r4, sl, lsl #20
 358:	03050000 	movweq	r0, #20480	; 0x5000
 35c:	00008424 	andeq	r8, r0, r4, lsr #8
 360:	00048106 	andeq	r8, r4, r6, lsl #2
 364:	1a0c0200 	bne	300b6c <__bss_end+0x2f8720>
 368:	00000054 	andeq	r0, r0, r4, asr r0
 36c:	84280305 	strthi	r0, [r8], #-773	; 0xfffffcfb
 370:	01020000 	mrseq	r0, (UNDEF: 2)
 374:	00047c02 	andeq	r7, r4, r2, lsl #24
 378:	0a5c0700 	beq	1701f80 <__bss_end+0x16f9b34>
 37c:	03010000 	movweq	r0, #4096	; 0x1000
 380:	00003305 	andeq	r3, r0, r5, lsl #6
 384:	00822c00 	addeq	r2, r2, r0, lsl #24
 388:	00001c00 	andeq	r1, r0, r0, lsl #24
 38c:	e89c0100 	ldm	ip, {r8}
 390:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
 394:	000004d5 	ldrdeq	r0, [r0], -r5
 398:	330e0301 	movwcc	r0, #58113	; 0xe301
 39c:	02000000 	andeq	r0, r0, #0
 3a0:	e4087491 	str	r7, [r8], #-1169	; 0xfffffb6f
 3a4:	01000004 	tsteq	r0, r4
 3a8:	00e81b03 	rsceq	r1, r8, r3, lsl #22
 3ac:	91020000 	mrsls	r0, (UNDEF: 2)
 3b0:	04090070 	streq	r0, [r9], #-112	; 0xffffff90
 3b4:	000000ee 	andeq	r0, r0, lr, ror #1
 3b8:	00250409 	eoreq	r0, r5, r9, lsl #8
 3bc:	f9000000 			; <UNDEFINED> instruction: 0xf9000000
 3c0:	04000002 	streq	r0, [r0], #-2
 3c4:	00024f00 	andeq	r4, r2, r0, lsl #30
 3c8:	55010400 	strpl	r0, [r1, #-1024]	; 0xfffffc00
 3cc:	04000006 	streq	r0, [r0], #-6
 3d0:	0000072a 	andeq	r0, r0, sl, lsr #14
 3d4:	00000533 	andeq	r0, r0, r3, lsr r5
 3d8:	00008248 	andeq	r8, r0, r8, asr #4
 3dc:	000001d4 	ldrdeq	r0, [r0], -r4
 3e0:	000003e9 	andeq	r0, r0, r9, ror #7
 3e4:	bd080102 	stflts	f0, [r8, #-8]
 3e8:	03000004 	movweq	r0, #4
 3ec:	00000025 	andeq	r0, r0, r5, lsr #32
 3f0:	da050202 	ble	140c00 <__bss_end+0x1387b4>
 3f4:	04000004 	streq	r0, [r0], #-4
 3f8:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
 3fc:	01020074 	tsteq	r2, r4, ror r0
 400:	0004b408 	andeq	fp, r4, r8, lsl #8
 404:	07020200 	streq	r0, [r2, -r0, lsl #4]
 408:	000004c2 	andeq	r0, r0, r2, asr #9
 40c:	0004e905 	andeq	lr, r4, r5, lsl #18
 410:	07090400 	streq	r0, [r9, -r0, lsl #8]
 414:	0000005e 	andeq	r0, r0, lr, asr r0
 418:	00004d03 	andeq	r4, r0, r3, lsl #26
 41c:	07040200 	streq	r0, [r4, -r0, lsl #4]
 420:	00000ac8 	andeq	r0, r0, r8, asr #21
 424:	00058d06 	andeq	r8, r5, r6, lsl #26
 428:	38040500 	stmdacc	r4, {r8, sl}
 42c:	03000000 	movweq	r0, #0
 430:	00840c4d 	addeq	r0, r4, sp, asr #24
 434:	82070000 	andhi	r0, r7, #0
 438:	00000005 	andeq	r0, r0, r5
 43c:	0005f007 	andeq	pc, r5, r7
 440:	08000100 	stmdaeq	r0, {r8}
 444:	00000466 	andeq	r0, r0, r6, ror #8
 448:	591a0602 	ldmdbpl	sl, {r1, r9, sl}
 44c:	05000000 	streq	r0, [r0, #-0]
 450:	00842c03 	addeq	r2, r4, r3, lsl #24
 454:	04940800 	ldreq	r0, [r4], #2048	; 0x800
 458:	08020000 	stmdaeq	r2, {}	; <UNPREDICTABLE>
 45c:	0000591a 	andeq	r5, r0, sl, lsl r9
 460:	30030500 	andcc	r0, r3, r0, lsl #10
 464:	08000084 	stmdaeq	r0, {r2, r7}
 468:	000004a6 	andeq	r0, r0, r6, lsr #9
 46c:	591a0a02 	ldmdbpl	sl, {r1, r9, fp}
 470:	05000000 	streq	r0, [r0, #-0]
 474:	00843403 	addeq	r3, r4, r3, lsl #8
 478:	04810800 	streq	r0, [r1], #2048	; 0x800
 47c:	0c020000 	stceq	0, cr0, [r2], {-0}
 480:	0000591a 	andeq	r5, r0, sl, lsl r9
 484:	38030500 	stmdacc	r3, {r8, sl}
 488:	06000084 	streq	r0, [r0], -r4, lsl #1
 48c:	000005cb 	andeq	r0, r0, fp, asr #11
 490:	00380405 	eorseq	r0, r8, r5, lsl #8
 494:	0e020000 	cdpeq	0, 0, cr0, cr2, cr0, {0}
 498:	0000f10c 	andeq	pc, r0, ip, lsl #2
 49c:	064b0700 	strbeq	r0, [fp], -r0, lsl #14
 4a0:	07000000 	streq	r0, [r0, -r0]
 4a4:	0000079b 	muleq	r0, fp, r7
 4a8:	06190701 	ldreq	r0, [r9], -r1, lsl #14
 4ac:	00020000 	andeq	r0, r2, r0
 4b0:	7c020102 	stfvcs	f0, [r2], {2}
 4b4:	09000004 	stmdbeq	r0, {r2}
 4b8:	00002c04 	andeq	r2, r0, r4, lsl #24
 4bc:	062b0a00 	strteq	r0, [fp], -r0, lsl #20
 4c0:	44010000 	strmi	r0, [r1], #-0
 4c4:	0005fb0a 	andeq	pc, r5, sl, lsl #22
 4c8:	00004d00 	andeq	r4, r0, r0, lsl #26
 4cc:	0083cc00 	addeq	ip, r3, r0, lsl #24
 4d0:	00005000 	andeq	r5, r0, r0
 4d4:	599c0100 	ldmibpl	ip, {r8}
 4d8:	0b000001 	bleq	4e4 <_start-0x7b1c>
 4dc:	000005ac 	andeq	r0, r0, ip, lsr #11
 4e0:	4d194401 	cfldrsmi	mvf4, [r9, #-4]
 4e4:	02000000 	andeq	r0, r0, #0
 4e8:	db0b6c91 	blle	2db734 <__bss_end+0x2d32e8>
 4ec:	01000005 	tsteq	r0, r5
 4f0:	00653044 	rsbeq	r3, r5, r4, asr #32
 4f4:	91020000 	mrsls	r0, (UNDEF: 2)
 4f8:	063c0b68 	ldrteq	r0, [ip], -r8, ror #22
 4fc:	44010000 	strmi	r0, [r1], #-0
 500:	00015941 	andeq	r5, r1, r1, asr #18
 504:	64910200 	ldrvs	r0, [r1], #512	; 0x200
 508:	00070d0c 	andeq	r0, r7, ip, lsl #26
 50c:	0e460100 	dvfeqs	f0, f6, f0
 510:	0000004d 	andeq	r0, r0, sp, asr #32
 514:	00749102 	rsbseq	r9, r4, r2, lsl #2
 518:	f20e040d 	vshl.s8	d0, d13, d14
 51c:	01000004 	tsteq	r0, r4
 520:	0720063e 			; <UNDEFINED> instruction: 0x0720063e
 524:	83a00000 	movhi	r0, #0
 528:	002c0000 	eoreq	r0, ip, r0
 52c:	9c010000 	stcls	0, cr0, [r1], {-0}
 530:	00000185 	andeq	r0, r0, r5, lsl #3
 534:	0005ac0b 	andeq	sl, r5, fp, lsl #24
 538:	153e0100 	ldrne	r0, [lr, #-256]!	; 0xffffff00
 53c:	0000004d 	andeq	r0, r0, sp, asr #32
 540:	00749102 	rsbseq	r9, r4, r2, lsl #2
 544:	0005040a 	andeq	r0, r5, sl, lsl #8
 548:	0a310100 	beq	c40950 <__bss_end+0xc38504>
 54c:	000005b1 			; <UNDEFINED> instruction: 0x000005b1
 550:	0000004d 	andeq	r0, r0, sp, asr #32
 554:	00008350 	andeq	r8, r0, r0, asr r3
 558:	00000050 	andeq	r0, r0, r0, asr r0
 55c:	01e09c01 	mvneq	r9, r1, lsl #24
 560:	ac0b0000 	stcge	0, cr0, [fp], {-0}
 564:	01000005 	tsteq	r0, r5
 568:	004d1931 	subeq	r1, sp, r1, lsr r9
 56c:	91020000 	mrsls	r0, (UNDEF: 2)
 570:	07060b6c 	streq	r0, [r6, -ip, ror #22]
 574:	31010000 	mrscc	r0, (UNDEF: 1)
 578:	0000f82b 	andeq	pc, r0, fp, lsr #16
 57c:	68910200 	ldmvs	r1, {r9}
 580:	0007150b 	andeq	r1, r7, fp, lsl #10
 584:	3c310100 	ldfccs	f0, [r1], #-0
 588:	0000004d 	andeq	r0, r0, sp, asr #32
 58c:	0c649102 	stfeqp	f1, [r4], #-8
 590:	0000071a 	andeq	r0, r0, sl, lsl r7
 594:	4d0e3301 	stcmi	3, cr3, [lr, #-4]
 598:	02000000 	andeq	r0, r0, #0
 59c:	0a007491 	beq	1d7e8 <__bss_end+0x1539c>
 5a0:	000005e5 	andeq	r0, r0, r5, ror #11
 5a4:	8f0a2401 	svchi	0x000a2401
 5a8:	4d000007 	stcmi	0, cr0, [r0, #-28]	; 0xffffffe4
 5ac:	00000000 	andeq	r0, r0, r0
 5b0:	50000083 	andpl	r0, r0, r3, lsl #1
 5b4:	01000000 	mrseq	r0, (UNDEF: 0)
 5b8:	00023b9c 	muleq	r2, ip, fp
 5bc:	05ac0b00 	streq	r0, [ip, #2816]!	; 0xb00
 5c0:	24010000 	strcs	r0, [r1], #-0
 5c4:	00004d18 	andeq	r4, r0, r8, lsl sp
 5c8:	6c910200 	lfmvs	f0, 4, [r1], {0}
 5cc:	0007060b 	andeq	r0, r7, fp, lsl #12
 5d0:	2a240100 	bcs	9009d8 <__bss_end+0x8f858c>
 5d4:	00000241 	andeq	r0, r0, r1, asr #4
 5d8:	0b689102 	bleq	1a249e8 <__bss_end+0x1a1c59c>
 5dc:	00000715 	andeq	r0, r0, r5, lsl r7
 5e0:	4d3b2401 	cfldrsmi	mvf2, [fp, #-4]!
 5e4:	02000000 	andeq	r0, r0, #0
 5e8:	ea0c6491 	b	319834 <__bss_end+0x3113e8>
 5ec:	01000005 	tsteq	r0, r5
 5f0:	004d0e26 	subeq	r0, sp, r6, lsr #28
 5f4:	91020000 	mrsls	r0, (UNDEF: 2)
 5f8:	04090074 	streq	r0, [r9], #-116	; 0xffffff8c
 5fc:	00000025 	andeq	r0, r0, r5, lsr #32
 600:	00023b03 	andeq	r3, r2, r3, lsl #22
 604:	078a0a00 	streq	r0, [sl, r0, lsl #20]
 608:	18010000 	stmdane	r1, {}	; <UNPREDICTABLE>
 60c:	0005bf0a 	andeq	fp, r5, sl, lsl #30
 610:	00004d00 	andeq	r4, r0, r0, lsl #26
 614:	0082bc00 	addeq	fp, r2, r0, lsl #24
 618:	00004400 	andeq	r4, r0, r0, lsl #8
 61c:	929c0100 	addsls	r0, ip, #0, 2
 620:	0b000002 	bleq	630 <_start-0x79d0>
 624:	0000059e 	muleq	r0, lr, r5
 628:	f81b1801 			; <UNDEFINED> instruction: 0xf81b1801
 62c:	02000000 	andeq	r0, r0, #0
 630:	a70b6c91 			; <UNDEFINED> instruction: 0xa70b6c91
 634:	01000005 	tsteq	r0, r5
 638:	00cc3518 	sbceq	r3, ip, r8, lsl r5
 63c:	91020000 	mrsls	r0, (UNDEF: 2)
 640:	05ac0c68 	streq	r0, [ip, #3176]!	; 0xc68
 644:	1a010000 	bne	4064c <__bss_end+0x38200>
 648:	00004d0e 	andeq	r4, r0, lr, lsl #26
 64c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
 650:	04f80f00 	ldrbteq	r0, [r8], #3840	; 0xf00
 654:	13010000 	movwne	r0, #4096	; 0x1000
 658:	00051806 	andeq	r1, r5, r6, lsl #16
 65c:	0082a000 	addeq	sl, r2, r0
 660:	00001c00 	andeq	r1, r0, r0, lsl #24
 664:	0e9c0100 	fmleqe	f0, f4, f0
 668:	00000529 	andeq	r0, r0, r9, lsr #10
 66c:	0a060d01 	beq	183a78 <__bss_end+0x17b62c>
 670:	74000005 	strvc	r0, [r0], #-5
 674:	2c000082 	stccs	0, cr0, [r0], {130}	; 0x82
 678:	01000000 	mrseq	r0, (UNDEF: 0)
 67c:	0002d29c 	muleq	r2, ip, r2
 680:	06420b00 	strbeq	r0, [r2], -r0, lsl #22
 684:	0d010000 	stceq	0, cr0, [r1, #-0]
 688:	00003814 	andeq	r3, r0, r4, lsl r8
 68c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
 690:	06241000 	strteq	r1, [r4], -r0
 694:	03010000 	movweq	r0, #4096	; 0x1000
 698:	0006310a 	andeq	r3, r6, sl, lsl #2
 69c:	00004d00 	andeq	r4, r0, r0, lsl #26
 6a0:	00824800 	addeq	r4, r2, r0, lsl #16
 6a4:	00002c00 	andeq	r2, r0, r0, lsl #24
 6a8:	119c0100 	orrsne	r0, ip, r0, lsl #2
 6ac:	00646970 	rsbeq	r6, r4, r0, ror r9
 6b0:	4d0e0501 	cfstr32mi	mvfx0, [lr, #-4]
 6b4:	02000000 	andeq	r0, r0, #0
 6b8:	00007491 	muleq	r0, r1, r4
 6bc:	0000032a 	andeq	r0, r0, sl, lsr #6
 6c0:	03750004 	cmneq	r5, #4
 6c4:	01040000 	mrseq	r0, (UNDEF: 4)
 6c8:	000008c6 	andeq	r0, r0, r6, asr #17
 6cc:	000a7f0c 	andeq	r7, sl, ip, lsl #30
 6d0:	000bc000 	andeq	ip, fp, r0
 6d4:	00061700 	andeq	r1, r6, r0, lsl #14
 6d8:	05040200 	streq	r0, [r4, #-512]	; 0xfffffe00
 6dc:	00746e69 	rsbseq	r6, r4, r9, ror #28
 6e0:	c8070403 	stmdagt	r7, {r0, r1, sl}
 6e4:	0300000a 	movweq	r0, #10
 6e8:	03090508 	movweq	r0, #38152	; 0x9508
 6ec:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
 6f0:	000a7304 	andeq	r7, sl, r4, lsl #6
 6f4:	08010300 	stmdaeq	r1, {r8, r9}
 6f8:	000004b4 			; <UNDEFINED> instruction: 0x000004b4
 6fc:	b6060103 	strlt	r0, [r6], -r3, lsl #2
 700:	04000004 	streq	r0, [r0], #-4
 704:	00000cb3 			; <UNDEFINED> instruction: 0x00000cb3
 708:	00390107 	eorseq	r0, r9, r7, lsl #2
 70c:	17010000 	strne	r0, [r1, -r0]
 710:	0001d406 	andeq	sp, r1, r6, lsl #8
 714:	07d50500 	ldrbeq	r0, [r5, r0, lsl #10]
 718:	05000000 	streq	r0, [r0, #-0]
 71c:	00000d62 	andeq	r0, r0, r2, ror #26
 720:	09a80501 	stmibeq	r8!, {r0, r8, sl}
 724:	05020000 	streq	r0, [r2, #-0]
 728:	00000a66 	andeq	r0, r0, r6, ror #20
 72c:	0ccc0503 	cfstr64eq	mvdx0, [ip], {3}
 730:	05040000 	streq	r0, [r4, #-0]
 734:	00000d72 	andeq	r0, r0, r2, ror sp
 738:	0ce20505 	cfstr64eq	mvdx0, [r2], #20
 73c:	05060000 	streq	r0, [r6, #-0]
 740:	00000aaf 	andeq	r0, r0, pc, lsr #21
 744:	0c5d0507 	cfldr64eq	mvdx0, [sp], {7}
 748:	05080000 	streq	r0, [r8, #-0]
 74c:	00000c6b 	andeq	r0, r0, fp, ror #24
 750:	0c790509 	cfldr64eq	mvdx0, [r9], #-36	; 0xffffffdc
 754:	050a0000 	streq	r0, [sl, #-0]
 758:	00000b18 	andeq	r0, r0, r8, lsl fp
 75c:	0b08050b 	bleq	201b90 <__bss_end+0x1f9744>
 760:	050c0000 	streq	r0, [ip, #-0]
 764:	000007f1 	strdeq	r0, [r0], -r1
 768:	080a050d 	stmdaeq	sl, {r0, r2, r3, r8, sl}
 76c:	050e0000 	streq	r0, [lr, #-0]
 770:	00000af9 	strdeq	r0, [r0], -r9
 774:	0d25050f 	cfstr32eq	mvfx0, [r5, #-60]!	; 0xffffffc4
 778:	05100000 	ldreq	r0, [r0, #-0]
 77c:	00000ca2 	andeq	r0, r0, r2, lsr #25
 780:	0d160511 	cfldr32eq	mvfx0, [r6, #-68]	; 0xffffffbc
 784:	05120000 	ldreq	r0, [r2, #-0]
 788:	000008b7 			; <UNDEFINED> instruction: 0x000008b7
 78c:	08340513 	ldmdaeq	r4!, {r0, r1, r4, r8, sl}
 790:	05140000 	ldreq	r0, [r4, #-0]
 794:	000007fe 	strdeq	r0, [r0], -lr
 798:	0b970515 	bleq	fe5c1bf4 <__bss_end+0xfe5b97a8>
 79c:	05160000 	ldreq	r0, [r6, #-0]
 7a0:	0000086b 	andeq	r0, r0, fp, ror #16
 7a4:	07a60517 			; <UNDEFINED> instruction: 0x07a60517
 7a8:	05180000 	ldreq	r0, [r8, #-0]
 7ac:	00000d08 	andeq	r0, r0, r8, lsl #26
 7b0:	0ad50519 	beq	ff541c1c <__bss_end+0xff5397d0>
 7b4:	051a0000 	ldreq	r0, [sl, #-0]
 7b8:	00000baf 	andeq	r0, r0, pc, lsr #23
 7bc:	083f051b 	ldmdaeq	pc!, {r0, r1, r3, r4, r8, sl}	; <UNPREDICTABLE>
 7c0:	051c0000 	ldreq	r0, [ip, #-0]
 7c4:	00000a4b 	andeq	r0, r0, fp, asr #20
 7c8:	099a051d 	ldmibeq	sl, {r0, r2, r3, r4, r8, sl}
 7cc:	051e0000 	ldreq	r0, [lr, #-0]
 7d0:	00000c94 	muleq	r0, r4, ip
 7d4:	0cf0051f 	cfldr64eq	mvdx0, [r0], #124	; 0x7c
 7d8:	05200000 	streq	r0, [r0, #-0]!
 7dc:	00000d31 	andeq	r0, r0, r1, lsr sp
 7e0:	0d3f0521 	cfldr32eq	mvfx0, [pc, #-132]!	; 764 <_start-0x789c>
 7e4:	05220000 	streq	r0, [r2, #-0]!
 7e8:	00000aec 	andeq	r0, r0, ip, ror #21
 7ec:	0a0f0523 	beq	3c1c80 <__bss_end+0x3b9834>
 7f0:	05240000 	streq	r0, [r4, #-0]!
 7f4:	0000084e 	andeq	r0, r0, lr, asr #16
 7f8:	0aa20525 	beq	fe881c94 <__bss_end+0xfe879848>
 7fc:	05260000 	streq	r0, [r6, #-0]!
 800:	000009b4 			; <UNDEFINED> instruction: 0x000009b4
 804:	0cbf0527 	cfldr32eq	mvfx0, [pc], #156	; 8a8 <_start-0x7758>
 808:	05280000 	streq	r0, [r8, #-0]!
 80c:	000009c4 	andeq	r0, r0, r4, asr #19
 810:	09d30529 	ldmibeq	r3, {r0, r3, r5, r8, sl}^
 814:	052a0000 	streq	r0, [sl, #-0]!
 818:	000009e2 	andeq	r0, r0, r2, ror #19
 81c:	09f1052b 	ldmibeq	r1!, {r0, r1, r3, r5, r8, sl}^
 820:	052c0000 	streq	r0, [ip, #-0]!
 824:	0000097f 	andeq	r0, r0, pc, ror r9
 828:	0a00052d 	beq	1ce4 <_start-0x631c>
 82c:	052e0000 	streq	r0, [lr, #-0]!
 830:	00000c4e 	andeq	r0, r0, lr, asr #24
 834:	0a1e052f 	beq	781cf8 <__bss_end+0x7798ac>
 838:	05300000 	ldreq	r0, [r0, #-0]!
 83c:	00000a2d 	andeq	r0, r0, sp, lsr #20
 840:	07df0531 			; <UNDEFINED> instruction: 0x07df0531
 844:	05320000 	ldreq	r0, [r2, #-0]!
 848:	00000b37 	andeq	r0, r0, r7, lsr fp
 84c:	0b470533 	bleq	11c1d20 <__bss_end+0x11b98d4>
 850:	05340000 	ldreq	r0, [r4, #-0]!
 854:	00000b57 	andeq	r0, r0, r7, asr fp
 858:	096d0535 	stmdbeq	sp!, {r0, r2, r4, r5, r8, sl}^
 85c:	05360000 	ldreq	r0, [r6, #-0]!
 860:	00000b67 	andeq	r0, r0, r7, ror #22
 864:	0b770537 	bleq	1dc1d48 <__bss_end+0x1db98fc>
 868:	05380000 	ldreq	r0, [r8, #-0]!
 86c:	00000b87 	andeq	r0, r0, r7, lsl #23
 870:	085e0539 	ldmdaeq	lr, {r0, r3, r4, r5, r8, sl}^
 874:	053a0000 	ldreq	r0, [sl, #-0]!
 878:	00000817 	andeq	r0, r0, r7, lsl r8
 87c:	0a3c053b 	beq	f01d70 <__bss_end+0xef9924>
 880:	053c0000 	ldreq	r0, [ip, #-0]!
 884:	000007b6 			; <UNDEFINED> instruction: 0x000007b6
 888:	0ba2053d 	bleq	fe881d84 <__bss_end+0xfe879938>
 88c:	003e0000 	eorseq	r0, lr, r0
 890:	00089e06 	andeq	r9, r8, r6, lsl #28
 894:	6b010200 	blvs	4109c <__bss_end+0x38c50>
 898:	01ff0802 	mvnseq	r0, r2, lsl #16
 89c:	61070000 	mrsvs	r0, (UNDEF: 7)
 8a0:	0100000a 	tsteq	r0, sl
 8a4:	47140270 			; <UNDEFINED> instruction: 0x47140270
 8a8:	00000000 	andeq	r0, r0, r0
 8ac:	00097a07 	andeq	r7, r9, r7, lsl #20
 8b0:	02710100 	rsbseq	r0, r1, #0, 2
 8b4:	00004714 	andeq	r4, r0, r4, lsl r7
 8b8:	08000100 	stmdaeq	r0, {r8}
 8bc:	000001d4 	ldrdeq	r0, [r0], -r4
 8c0:	0001ff09 	andeq	pc, r1, r9, lsl #30
 8c4:	00021400 	andeq	r1, r2, r0, lsl #8
 8c8:	00240a00 	eoreq	r0, r4, r0, lsl #20
 8cc:	00110000 	andseq	r0, r1, r0
 8d0:	00020408 	andeq	r0, r2, r8, lsl #8
 8d4:	0b250b00 	bleq	9434dc <__bss_end+0x93b090>
 8d8:	74010000 	strvc	r0, [r1], #-0
 8dc:	02142602 	andseq	r2, r4, #2097152	; 0x200000
 8e0:	3a240000 	bcc	9008e8 <__bss_end+0x8f849c>
 8e4:	0f3d0a3d 	svceq	0x003d0a3d
 8e8:	323d243d 	eorscc	r2, sp, #1023410176	; 0x3d000000
 8ec:	053d023d 	ldreq	r0, [sp, #-573]!	; 0xfffffdc3
 8f0:	0d3d133d 	ldceq	3, cr1, [sp, #-244]!	; 0xffffff0c
 8f4:	233d0c3d 	teqcs	sp, #15616	; 0x3d00
 8f8:	263d113d 			; <UNDEFINED> instruction: 0x263d113d
 8fc:	173d013d 			; <UNDEFINED> instruction: 0x173d013d
 900:	093d083d 	ldmdbeq	sp!, {r0, r2, r3, r4, r5, fp}
 904:	0300003d 	movweq	r0, #61	; 0x3d
 908:	04c20702 	strbeq	r0, [r2], #1794	; 0x702
 90c:	01030000 	mrseq	r0, (UNDEF: 3)
 910:	0004bd08 	andeq	fp, r4, r8, lsl #26
 914:	040d0c00 	streq	r0, [sp], #-3072	; 0xfffff400
 918:	00000259 	andeq	r0, r0, r9, asr r2
 91c:	000d4d0e 	andeq	r4, sp, lr, lsl #26
 920:	39010700 	stmdbcc	r1, {r8, r9, sl}
 924:	02000000 	andeq	r0, r0, #0
 928:	9e0604f7 	mcrls	4, 0, r0, cr6, cr7, {7}
 92c:	05000002 	streq	r0, [r0, #-2]
 930:	00000878 	andeq	r0, r0, r8, ror r8
 934:	08830500 	stmeq	r3, {r8, sl}
 938:	05010000 	streq	r0, [r1, #-0]
 93c:	00000895 	muleq	r0, r5, r8
 940:	08af0502 	stmiaeq	pc!, {r1, r8, sl}	; <UNPREDICTABLE>
 944:	05030000 	streq	r0, [r3, #-0]
 948:	00000c87 	andeq	r0, r0, r7, lsl #25
 94c:	098e0504 	stmibeq	lr, {r2, r8, sl}
 950:	05050000 	streq	r0, [r5, #-0]
 954:	00000c40 	andeq	r0, r0, r0, asr #24
 958:	02030006 	andeq	r0, r3, #6
 95c:	0004da05 	andeq	sp, r4, r5, lsl #20
 960:	07080300 	streq	r0, [r8, -r0, lsl #6]
 964:	00000abe 			; <UNDEFINED> instruction: 0x00000abe
 968:	cf040403 	svcgt	0x00040403
 96c:	03000007 	movweq	r0, #7
 970:	07c70308 	strbeq	r0, [r7, r8, lsl #6]
 974:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
 978:	000a7804 	andeq	r7, sl, r4, lsl #16
 97c:	03100300 	tsteq	r0, #0, 6
 980:	00000c31 	andeq	r0, r0, r1, lsr ip
 984:	000c280f 	andeq	r2, ip, pc, lsl #16
 988:	102a0300 	eorne	r0, sl, r0, lsl #6
 98c:	0000025a 	andeq	r0, r0, sl, asr r2
 990:	0002c809 	andeq	ip, r2, r9, lsl #16
 994:	0002df00 	andeq	sp, r2, r0, lsl #30
 998:	11001000 	mrsne	r1, (UNDEF: 0)
 99c:	000003d2 	ldrdeq	r0, [r0], -r2
 9a0:	d4112f03 	ldrle	r2, [r1], #-3843	; 0xfffff0fd
 9a4:	11000002 	tstne	r0, r2
 9a8:	00000268 	andeq	r0, r0, r8, ror #4
 9ac:	d4113003 	ldrle	r3, [r1], #-3
 9b0:	09000002 	stmdbeq	r0, {r1}
 9b4:	000002c8 	andeq	r0, r0, r8, asr #5
 9b8:	00000307 	andeq	r0, r0, r7, lsl #6
 9bc:	0000240a 	andeq	r2, r0, sl, lsl #8
 9c0:	12000100 	andne	r0, r0, #0, 2
 9c4:	000002df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
 9c8:	0a093304 	beq	24d5e0 <__bss_end+0x245194>
 9cc:	000002f7 	strdeq	r0, [r0], -r7
 9d0:	843c0305 	ldrthi	r0, [ip], #-773	; 0xfffffcfb
 9d4:	eb120000 	bl	4809dc <__bss_end+0x478590>
 9d8:	04000002 	streq	r0, [r0], #-2
 9dc:	f70a0934 			; <UNDEFINED> instruction: 0xf70a0934
 9e0:	05000002 	streq	r0, [r0, #-2]
 9e4:	00843c03 	addeq	r3, r4, r3, lsl #24
	...

Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
   0:	10001101 	andne	r1, r0, r1, lsl #2
   4:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
   8:	1b0e0301 	blne	380c14 <__bss_end+0x3787c8>
   c:	130e250e 	movwne	r2, #58638	; 0xe50e
  10:	00000005 	andeq	r0, r0, r5
  14:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
  18:	030b130e 	movweq	r1, #45838	; 0xb30e
  1c:	110e1b0e 	tstne	lr, lr, lsl #22
  20:	10061201 	andne	r1, r6, r1, lsl #4
  24:	02000017 	andeq	r0, r0, #23
  28:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  2c:	0b3b0b3a 	bleq	ec2d1c <__bss_end+0xeba8d0>
  30:	13490b39 	movtne	r0, #39737	; 0x9b39
  34:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
  38:	24030000 	strcs	r0, [r3], #-0
  3c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
  40:	000e030b 	andeq	r0, lr, fp, lsl #6
  44:	012e0400 			; <UNDEFINED> instruction: 0x012e0400
  48:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
  4c:	0b3b0b3a 	bleq	ec2d3c <__bss_end+0xeba8f0>
  50:	01110b39 	tsteq	r1, r9, lsr fp
  54:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
  58:	01194296 			; <UNDEFINED> instruction: 0x01194296
  5c:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
  60:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  64:	0b3b0b3a 	bleq	ec2d54 <__bss_end+0xeba908>
  68:	13490b39 	movtne	r0, #39737	; 0x9b39
  6c:	00001802 	andeq	r1, r0, r2, lsl #16
  70:	0b002406 	bleq	9090 <__bss_end+0xc44>
  74:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
  78:	07000008 	streq	r0, [r0, -r8]
  7c:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
  80:	0b3a0e03 	bleq	e83894 <__bss_end+0xe7b448>
  84:	0b390b3b 	bleq	e42d78 <__bss_end+0xe3a92c>
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
  b4:	3a0e0300 	bcc	380cbc <__bss_end+0x378870>
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
  e4:	0b3e0b0b 	bleq	f82d18 <__bss_end+0xf7a8cc>
  e8:	00000e03 	andeq	r0, r0, r3, lsl #28
  ec:	03003408 	movweq	r3, #1032	; 0x408
  f0:	3b0b3a0e 	blcc	2ce930 <__bss_end+0x2c64e4>
  f4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
  f8:	3c193f13 	ldccc	15, cr3, [r9], {19}
  fc:	09000019 	stmdbeq	r0, {r0, r3, r4}
 100:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 104:	0b3a0e03 	bleq	e83918 <__bss_end+0xe7b4cc>
 108:	0b390b3b 	bleq	e42dfc <__bss_end+0xe3a9b0>
 10c:	01111349 	tsteq	r1, r9, asr #6
 110:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 114:	01194296 			; <UNDEFINED> instruction: 0x01194296
 118:	0a000013 	beq	16c <_start-0x7e94>
 11c:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 120:	0b3b0b3a 	bleq	ec2e10 <__bss_end+0xeba9c4>
 124:	13490b39 	movtne	r0, #39737	; 0x9b39
 128:	00001802 	andeq	r1, r0, r2, lsl #16
 12c:	0b00240b 	bleq	9160 <__bss_end+0xd14>
 130:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 134:	0c000008 	stceq	0, cr0, [r0], {8}
 138:	193f002e 	ldmdbne	pc!, {r1, r2, r3, r5}	; <UNPREDICTABLE>
 13c:	0b3a0e03 	bleq	e83950 <__bss_end+0xe7b504>
 140:	0b390b3b 	bleq	e42e34 <__bss_end+0xe3a9e8>
 144:	06120111 			; <UNDEFINED> instruction: 0x06120111
 148:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 14c:	0d000019 	stceq	0, cr0, [r0, #-100]	; 0xffffff9c
 150:	0e030139 	mcreq	1, 0, r0, cr3, cr9, {1}
 154:	0b3b0b3a 	bleq	ec2e44 <__bss_end+0xeba9f8>
 158:	00001301 	andeq	r1, r0, r1, lsl #6
 15c:	3f012e0e 	svccc	0x00012e0e
 160:	3a0e0319 	bcc	380dcc <__bss_end+0x378980>
 164:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 168:	01193c0b 	tsteq	r9, fp, lsl #24
 16c:	0f000013 	svceq	0x00000013
 170:	13490005 	movtne	r0, #36869	; 0x9005
 174:	2e100000 	cdpcs	0, 1, cr0, cr0, cr0, {0}
 178:	03193f01 	tsteq	r9, #1, 30
 17c:	3b0b3a0e 	blcc	2ce9bc <__bss_end+0x2c6570>
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
 1a8:	3b0b3a08 	blcc	2ce9d0 <__bss_end+0x2c6584>
 1ac:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 1b0:	00180213 	andseq	r0, r8, r3, lsl r2
 1b4:	012e1400 			; <UNDEFINED> instruction: 0x012e1400
 1b8:	01111347 	tsteq	r1, r7, asr #6
 1bc:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 1c0:	00194297 	mulseq	r9, r7, r2
 1c4:	11010000 	mrsne	r0, (UNDEF: 1)
 1c8:	130e2501 	movwne	r2, #58625	; 0xe501
 1cc:	1b0e030b 	blne	380e00 <__bss_end+0x3789b4>
 1d0:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 1d4:	00171006 	andseq	r1, r7, r6
 1d8:	00240200 	eoreq	r0, r4, r0, lsl #4
 1dc:	0b3e0b0b 	bleq	f82e10 <__bss_end+0xf7a9c4>
 1e0:	00000e03 	andeq	r0, r0, r3, lsl #28
 1e4:	0b002403 	bleq	91f8 <__bss_end+0xdac>
 1e8:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 1ec:	04000008 	streq	r0, [r0], #-8
 1f0:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
 1f4:	0b3b0b3a 	bleq	ec2ee4 <__bss_end+0xebaa98>
 1f8:	13490b39 	movtne	r0, #39737	; 0x9b39
 1fc:	26050000 	strcs	r0, [r5], -r0
 200:	00134900 	andseq	r4, r3, r0, lsl #18
 204:	00340600 	eorseq	r0, r4, r0, lsl #12
 208:	0b3a0e03 	bleq	e83a1c <__bss_end+0xe7b5d0>
 20c:	0b390b3b 	bleq	e42f00 <__bss_end+0xe3aab4>
 210:	196c1349 	stmdbne	ip!, {r0, r3, r6, r8, r9, ip}^
 214:	00001802 	andeq	r1, r0, r2, lsl #16
 218:	3f012e07 	svccc	0x00012e07
 21c:	3a0e0319 	bcc	380e88 <__bss_end+0x378a3c>
 220:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 224:	1113490b 	tstne	r3, fp, lsl #18
 228:	40061201 	andmi	r1, r6, r1, lsl #4
 22c:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
 230:	00001301 	andeq	r1, r0, r1, lsl #6
 234:	03000508 	movweq	r0, #1288	; 0x508
 238:	3b0b3a0e 	blcc	2cea78 <__bss_end+0x2c662c>
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
 274:	0b002404 	bleq	928c <__bss_end+0xe40>
 278:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 27c:	05000008 	streq	r0, [r0, #-8]
 280:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
 284:	0b3b0b3a 	bleq	ec2f74 <__bss_end+0xebab28>
 288:	13490b39 	movtne	r0, #39737	; 0x9b39
 28c:	04060000 	streq	r0, [r6], #-0
 290:	6d0e0301 	stcvs	3, cr0, [lr, #-4]
 294:	0b0b3e19 	bleq	2cfb00 <__bss_end+0x2c76b4>
 298:	3a13490b 	bcc	4d26cc <__bss_end+0x4ca280>
 29c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 2a0:	0013010b 	andseq	r0, r3, fp, lsl #2
 2a4:	00280700 	eoreq	r0, r8, r0, lsl #14
 2a8:	0b1c0e03 	bleq	703abc <__bss_end+0x6fb670>
 2ac:	34080000 	strcc	r0, [r8], #-0
 2b0:	3a0e0300 	bcc	380eb8 <__bss_end+0x378a6c>
 2b4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 2b8:	6c13490b 			; <UNDEFINED> instruction: 0x6c13490b
 2bc:	00180219 	andseq	r0, r8, r9, lsl r2
 2c0:	000f0900 	andeq	r0, pc, r0, lsl #18
 2c4:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 2c8:	2e0a0000 	cdpcs	0, 0, cr0, cr10, cr0, {0}
 2cc:	03193f01 	tsteq	r9, #1, 30
 2d0:	3b0b3a0e 	blcc	2ceb10 <__bss_end+0x2c66c4>
 2d4:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 2d8:	1113490e 	tstne	r3, lr, lsl #18
 2dc:	40061201 	andmi	r1, r6, r1, lsl #4
 2e0:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 2e4:	00001301 	andeq	r1, r0, r1, lsl #6
 2e8:	0300050b 	movweq	r0, #1291	; 0x50b
 2ec:	3b0b3a0e 	blcc	2ceb2c <__bss_end+0x2c66e0>
 2f0:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 2f4:	00180213 	andseq	r0, r8, r3, lsl r2
 2f8:	00340c00 	eorseq	r0, r4, r0, lsl #24
 2fc:	0b3a0e03 	bleq	e83b10 <__bss_end+0xe7b6c4>
 300:	0b390b3b 	bleq	e42ff4 <__bss_end+0xe3aba8>
 304:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 308:	0f0d0000 	svceq	0x000d0000
 30c:	000b0b00 	andeq	r0, fp, r0, lsl #22
 310:	012e0e00 			; <UNDEFINED> instruction: 0x012e0e00
 314:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 318:	0b3b0b3a 	bleq	ec3008 <__bss_end+0xebabbc>
 31c:	0e6e0b39 	vmoveq.8	d14[5], r0
 320:	06120111 			; <UNDEFINED> instruction: 0x06120111
 324:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 328:	00130119 	andseq	r0, r3, r9, lsl r1
 32c:	002e0f00 	eoreq	r0, lr, r0, lsl #30
 330:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 334:	0b3b0b3a 	bleq	ec3024 <__bss_end+0xebabd8>
 338:	0e6e0b39 	vmoveq.8	d14[5], r0
 33c:	06120111 			; <UNDEFINED> instruction: 0x06120111
 340:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 344:	10000019 	andne	r0, r0, r9, lsl r0
 348:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 34c:	0b3a0e03 	bleq	e83b60 <__bss_end+0xe7b714>
 350:	0b390b3b 	bleq	e43044 <__bss_end+0xe3abf8>
 354:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 358:	06120111 			; <UNDEFINED> instruction: 0x06120111
 35c:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 360:	11000019 	tstne	r0, r9, lsl r0
 364:	08030034 	stmdaeq	r3, {r2, r4, r5}
 368:	0b3b0b3a 	bleq	ec3058 <__bss_end+0xebac0c>
 36c:	13490b39 	movtne	r0, #39737	; 0x9b39
 370:	00001802 	andeq	r1, r0, r2, lsl #16
 374:	01110100 	tsteq	r1, r0, lsl #2
 378:	0b130e25 	bleq	4c3c14 <__bss_end+0x4bb7c8>
 37c:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
 380:	00001710 	andeq	r1, r0, r0, lsl r7
 384:	0b002402 	bleq	9394 <__bss_end+0xf48>
 388:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 38c:	03000008 	movweq	r0, #8
 390:	0b0b0024 	bleq	2c0428 <__bss_end+0x2b7fdc>
 394:	0e030b3e 	vmoveq.16	d3[0], r0
 398:	04040000 	streq	r0, [r4], #-0
 39c:	3e0e0301 	cdpcc	3, 0, cr0, cr14, cr1, {0}
 3a0:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
 3a4:	3b0b3a13 	blcc	2cebf8 <__bss_end+0x2c67ac>
 3a8:	010b390b 	tsteq	fp, fp, lsl #18
 3ac:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
 3b0:	0e030028 	cdpeq	0, 0, cr0, cr3, cr8, {1}
 3b4:	00000b1c 	andeq	r0, r0, ip, lsl fp
 3b8:	03011306 	movweq	r1, #4870	; 0x1306
 3bc:	3a0b0b0e 	bcc	2c2ffc <__bss_end+0x2babb0>
 3c0:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 3c4:	0013010b 	andseq	r0, r3, fp, lsl #2
 3c8:	000d0700 	andeq	r0, sp, r0, lsl #14
 3cc:	0b3a0e03 	bleq	e83be0 <__bss_end+0xe7b794>
 3d0:	0b39053b 	bleq	e418c4 <__bss_end+0xe39478>
 3d4:	0b381349 	bleq	e05100 <__bss_end+0xdfccb4>
 3d8:	26080000 	strcs	r0, [r8], -r0
 3dc:	00134900 	andseq	r4, r3, r0, lsl #18
 3e0:	01010900 	tsteq	r1, r0, lsl #18
 3e4:	13011349 	movwne	r1, #4937	; 0x1349
 3e8:	210a0000 	mrscs	r0, (UNDEF: 10)
 3ec:	2f134900 	svccs	0x00134900
 3f0:	0b00000b 	bleq	424 <_start-0x7bdc>
 3f4:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 3f8:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 3fc:	13490b39 	movtne	r0, #39737	; 0x9b39
 400:	00000a1c 	andeq	r0, r0, ip, lsl sl
 404:	2700150c 	strcs	r1, [r0, -ip, lsl #10]
 408:	0d000019 	stceq	0, cr0, [r0, #-100]	; 0xffffff9c
 40c:	0b0b000f 	bleq	2c0450 <__bss_end+0x2b8004>
 410:	00001349 	andeq	r1, r0, r9, asr #6
 414:	0301040e 	movweq	r0, #5134	; 0x140e
 418:	0b0b3e0e 	bleq	2cfc58 <__bss_end+0x2c780c>
 41c:	3a13490b 	bcc	4d2850 <__bss_end+0x4ca404>
 420:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 424:	0013010b 	andseq	r0, r3, fp, lsl #2
 428:	00160f00 	andseq	r0, r6, r0, lsl #30
 42c:	0b3a0e03 	bleq	e83c40 <__bss_end+0xe7b7f4>
 430:	0b390b3b 	bleq	e43124 <__bss_end+0xe3acd8>
 434:	00001349 	andeq	r1, r0, r9, asr #6
 438:	00002110 	andeq	r2, r0, r0, lsl r1
 43c:	00341100 	eorseq	r1, r4, r0, lsl #2
 440:	0b3a0e03 	bleq	e83c54 <__bss_end+0xe7b808>
 444:	0b390b3b 	bleq	e43138 <__bss_end+0xe3acec>
 448:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
 44c:	0000193c 	andeq	r1, r0, ip, lsr r9
 450:	47003412 	smladmi	r0, r2, r4, r3
 454:	3b0b3a13 	blcc	2ceca8 <__bss_end+0x2c685c>
 458:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
 45c:	00180213 	andseq	r0, r8, r3, lsl r2
	...

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
  74:	0000001c 	andeq	r0, r0, ip, lsl r0
	...
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	03bf0002 			; <UNDEFINED> instruction: 0x03bf0002
  88:	00040000 	andeq	r0, r4, r0
  8c:	00000000 	andeq	r0, r0, r0
  90:	00008248 	andeq	r8, r0, r8, asr #4
  94:	000001d4 	ldrdeq	r0, [r0], -r4
	...
  a0:	00000014 	andeq	r0, r0, r4, lsl r0
  a4:	06bc0002 	ldrteq	r0, [ip], r2
  a8:	00040000 	andeq	r0, r4, r0
	...

Disassembly of section .debug_str:

00000000 <.debug_str>:
   0:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
   4:	552f632f 	strpl	r6, [pc, #-815]!	; fffffcdd <__bss_end+0xffff7891>
   8:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
   c:	62754b2f 	rsbsvs	r4, r5, #48128	; 0xbc00
  10:	6f442f61 	svcvs	0x00442f61
  14:	656d7563 	strbvs	r7, [sp, #-1379]!	; 0xfffffa9d
  18:	2f73746e 	svccs	0x0073746e
  1c:	6f686353 	svcvs	0x00686353
  20:	5a2f6c6f 	bpl	bdb1e4 <__bss_end+0xbd2d98>
  24:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; fffffe98 <__bss_end+0xffff7a4c>
  28:	2f657461 	svccs	0x00657461
  2c:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
  30:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
  34:	2d36312f 	ldfcss	f3, [r6, #-188]!	; 0xffffff44
  38:	69676170 	stmdbvs	r7!, {r4, r5, r6, r8, sp, lr}^
  3c:	755f676e 	ldrbvc	r6, [pc, #-1902]	; fffff8d6 <__bss_end+0xffff748a>
  40:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
  44:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
  48:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
  4c:	61707372 	cmnvs	r0, r2, ror r3
  50:	632f6563 			; <UNDEFINED> instruction: 0x632f6563
  54:	2e307472 	mrccs	4, 1, r7, cr0, cr2, {3}
  58:	6d2f0073 	stcvs	0, cr0, [pc, #-460]!	; fffffe94 <__bss_end+0xffff7a48>
  5c:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
  60:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
  64:	4b2f7372 	blmi	bdce34 <__bss_end+0xbd49e8>
  68:	2f616275 	svccs	0x00616275
  6c:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
  70:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
  74:	63532f73 	cmpvs	r3, #460	; 0x1cc
  78:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; fffffee0 <__bss_end+0xffff7a94>
  7c:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
  80:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
  84:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
  88:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
  8c:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
  90:	61702d36 	cmnvs	r0, r6, lsr sp
  94:	676e6967 	strbvs	r6, [lr, -r7, ror #18]!
  98:	6573755f 	ldrbvs	r7, [r3, #-1375]!	; 0xfffffaa1
  9c:	61707372 	cmnvs	r0, r2, ror r3
  a0:	752f6563 	strvc	r6, [pc, #-1379]!	; fffffb45 <__bss_end+0xffff76f9>
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
 13c:	2b6b7a36 	blcs	1adea1c <__bss_end+0x1ad65d0>
 140:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
 144:	672d2067 	strvs	r2, [sp, -r7, rrx]!
 148:	304f2d20 	subcc	r2, pc, r0, lsr #26
 14c:	304f2d20 	subcc	r2, pc, r0, lsr #26
 150:	625f5f00 	subsvs	r5, pc, #0, 30
 154:	655f7373 	ldrbvs	r7, [pc, #-883]	; fffffde9 <__bss_end+0xffff799d>
 158:	7200646e 	andvc	r6, r0, #1845493760	; 0x6e000000
 15c:	6c757365 	ldclvs	3, cr7, [r5], #-404	; 0xfffffe6c
 160:	6d2f0074 	stcvs	0, cr0, [pc, #-464]!	; ffffff98 <__bss_end+0xffff7b4c>
 164:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
 168:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
 16c:	4b2f7372 	blmi	bdcf3c <__bss_end+0xbd4af0>
 170:	2f616275 	svccs	0x00616275
 174:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
 178:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
 17c:	63532f73 	cmpvs	r3, #460	; 0x1cc
 180:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; ffffffe8 <__bss_end+0xffff7b9c>
 184:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
 188:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
 18c:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 190:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
 194:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
 198:	61702d36 	cmnvs	r0, r6, lsr sp
 19c:	676e6967 	strbvs	r6, [lr, -r7, ror #18]!
 1a0:	6573755f 	ldrbvs	r7, [r3, #-1375]!	; 0xfffffaa1
 1a4:	61707372 	cmnvs	r0, r2, ror r3
 1a8:	752f6563 	strvc	r6, [pc, #-1379]!	; fffffc4d <__bss_end+0xffff7801>
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
 2a0:	442f6162 	strtmi	r6, [pc], #-354	; 2a8 <_start-0x7d58>
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
 3fc:	6e6d2f00 	cdpvs	15, 6, cr2, cr13, cr0, {0}
 400:	2f632f74 	svccs	0x00632f74
 404:	72657355 	rsbvc	r7, r5, #1409286145	; 0x54000001
 408:	754b2f73 	strbvc	r2, [fp, #-3955]	; 0xfffff08d
 40c:	442f6162 	strtmi	r6, [pc], #-354	; 414 <_start-0x7bec>
 410:	6d75636f 	ldclvs	3, cr6, [r5, #-444]!	; 0xfffffe44
 414:	73746e65 	cmnvc	r4, #1616	; 0x650
 418:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
 41c:	2f6c6f6f 	svccs	0x006c6f6f
 420:	6f72655a 	svcvs	0x0072655a
 424:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
 428:	6178652f 	cmnvs	r8, pc, lsr #10
 42c:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
 430:	36312f73 	shsub16cc	r2, r1, r3
 434:	6761702d 	strbvs	r7, [r1, -sp, lsr #32]!
 438:	5f676e69 	svcpl	0x00676e69
 43c:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
 440:	63617073 	cmnvs	r1, #115	; 0x73
 444:	73752f65 	cmnvc	r5, #404	; 0x194
 448:	70737265 	rsbsvc	r7, r3, r5, ror #4
 44c:	2f656361 	svccs	0x00656361
 450:	656c6469 	strbvs	r6, [ip, #-1129]!	; 0xfffffb97
 454:	6f72705f 	svcvs	0x0072705f
 458:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
 45c:	69616d2f 	stmdbvs	r1!, {r0, r1, r2, r3, r5, r8, sl, fp, sp, lr}^
 460:	70632e6e 	rsbvc	r2, r3, lr, ror #28
 464:	614d0070 	hvcvs	53248	; 0xd000
 468:	44534678 	ldrbmi	r4, [r3], #-1656	; 0xfffff988
 46c:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
 470:	6d614e72 	stclvs	14, cr4, [r1, #-456]!	; 0xfffffe38
 474:	6e654c65 	cdpvs	12, 6, cr4, cr5, cr5, {3}
 478:	00687467 	rsbeq	r7, r8, r7, ror #8
 47c:	6c6f6f62 	stclvs	15, cr6, [pc], #-392	; 2fc <_start-0x7d04>
 480:	466f4e00 	strbtmi	r4, [pc], -r0, lsl #28
 484:	73656c69 	cmnvc	r5, #26880	; 0x6900
 488:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
 48c:	6972446d 	ldmdbvs	r2!, {r0, r2, r3, r5, r6, sl, lr}^
 490:	00726576 	rsbseq	r6, r2, r6, ror r5
 494:	4678614d 	ldrbtmi	r6, [r8], -sp, asr #2
 498:	6e656c69 	cdpvs	12, 6, cr6, cr5, cr9, {3}
 49c:	4c656d61 	stclmi	13, cr6, [r5], #-388	; 0xfffffe7c
 4a0:	74676e65 	strbtvc	r6, [r7], #-3685	; 0xfffff19b
 4a4:	614d0068 	cmpvs	sp, r8, rrx
 4a8:	74615078 	strbtvc	r5, [r1], #-120	; 0xffffff88
 4ac:	6e654c68 	cdpvs	12, 6, cr4, cr5, cr8, {3}
 4b0:	00687467 	rsbeq	r7, r8, r7, ror #8
 4b4:	69736e75 	ldmdbvs	r3!, {r0, r2, r4, r5, r6, r9, sl, fp, sp, lr}^
 4b8:	64656e67 	strbtvs	r6, [r5], #-3687	; 0xfffff199
 4bc:	61686320 	cmnvs	r8, r0, lsr #6
 4c0:	68730072 	ldmdavs	r3!, {r1, r4, r5, r6}^
 4c4:	2074726f 	rsbscs	r7, r4, pc, ror #4
 4c8:	69736e75 	ldmdbvs	r3!, {r0, r2, r4, r5, r6, r9, sl, fp, sp, lr}^
 4cc:	64656e67 	strbtvs	r6, [r5], #-3687	; 0xfffff199
 4d0:	746e6920 	strbtvc	r6, [lr], #-2336	; 0xfffff6e0
 4d4:	67726100 	ldrbvs	r6, [r2, -r0, lsl #2]!
 4d8:	68730063 	ldmdavs	r3!, {r0, r1, r5, r6}^
 4dc:	2074726f 	rsbscs	r7, r4, pc, ror #4
 4e0:	00746e69 	rsbseq	r6, r4, r9, ror #28
 4e4:	76677261 	strbtvc	r7, [r7], -r1, ror #4
 4e8:	6e697500 	cdpvs	5, 6, cr7, cr9, cr0, {0}
 4ec:	5f323374 	svcpl	0x00323374
 4f0:	6c630074 	stclvs	0, cr0, [r3], #-464	; 0xfffffe30
 4f4:	0065736f 	rsbeq	r7, r5, pc, ror #6
 4f8:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
 4fc:	69795f64 	ldmdbvs	r9!, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
 500:	00646c65 	rsbeq	r6, r4, r5, ror #24
 504:	74697277 	strbtvc	r7, [r9], #-631	; 0xfffffd89
 508:	5a5f0065 	bpl	17c06a4 <__bss_end+0x17b8258>
 50c:	72657439 	rsbvc	r7, r5, #956301312	; 0x39000000
 510:	616e696d 	cmnvs	lr, sp, ror #18
 514:	00696574 	rsbeq	r6, r9, r4, ror r5
 518:	31315a5f 	teqcc	r1, pc, asr sl
 51c:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
 520:	69795f64 	ldmdbvs	r9!, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
 524:	76646c65 	strbtvc	r6, [r4], -r5, ror #24
 528:	72657400 	rsbvc	r7, r5, #0, 8
 52c:	616e696d 	cmnvs	lr, sp, ror #18
 530:	2f006574 	svccs	0x00006574
 534:	2f746e6d 	svccs	0x00746e6d
 538:	73552f63 	cmpvc	r5, #396	; 0x18c
 53c:	2f737265 	svccs	0x00737265
 540:	6162754b 	cmnvs	r2, fp, asr #10
 544:	636f442f 	cmnvs	pc, #788529152	; 0x2f000000
 548:	6e656d75 	mcrvs	13, 3, r6, cr5, cr5, {3}
 54c:	532f7374 			; <UNDEFINED> instruction: 0x532f7374
 550:	6f6f6863 	svcvs	0x006f6863
 554:	655a2f6c 	ldrbvs	r2, [sl, #-3948]	; 0xfffff094
 558:	614d6f72 	hvcvs	55026	; 0xd6f2
 55c:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffff0 <__bss_end+0xffff7ba4>
 560:	706d6178 	rsbvc	r6, sp, r8, ror r1
 564:	2f73656c 	svccs	0x0073656c
 568:	702d3631 	eorvc	r3, sp, r1, lsr r6
 56c:	6e696761 	cdpvs	7, 6, cr6, cr9, cr1, {3}
 570:	73755f67 	cmnvc	r5, #412	; 0x19c
 574:	70737265 	rsbsvc	r7, r3, r5, ror #4
 578:	2f656361 	svccs	0x00656361
 57c:	6c697562 	cfstr64vs	mvdx7, [r9], #-392	; 0xfffffe78
 580:	65470064 	strbvs	r0, [r7, #-100]	; 0xffffff9c
 584:	61505f74 	cmpvs	r0, r4, ror pc
 588:	736d6172 	cmnvc	sp, #-2147483620	; 0x8000001c
 58c:	4f494e00 	svcmi	0x00494e00
 590:	5f6c7443 	svcpl	0x006c7443
 594:	7265704f 	rsbvc	r7, r5, #79	; 0x4f
 598:	6f697461 	svcvs	0x00697461
 59c:	6966006e 	stmdbvs	r6!, {r1, r2, r3, r5, r6}^
 5a0:	616e656c 	cmnvs	lr, ip, ror #10
 5a4:	6d00656d 	cfstr32vs	mvfx6, [r0, #-436]	; 0xfffffe4c
 5a8:	0065646f 	rsbeq	r6, r5, pc, ror #8
 5ac:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
 5b0:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
 5b4:	74697277 	strbtvc	r7, [r9], #-631	; 0xfffffd89
 5b8:	4b506a65 	blmi	141af54 <__bss_end+0x1412b08>
 5bc:	5f006a63 	svcpl	0x00006a63
 5c0:	706f345a 	rsbvc	r3, pc, sl, asr r4	; <UNPREDICTABLE>
 5c4:	4b506e65 	blmi	141bf60 <__bss_end+0x1413b14>
 5c8:	4e353163 	rsfmisz	f3, f5, f3
 5cc:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
 5d0:	65704f5f 	ldrbvs	r4, [r0, #-3935]!	; 0xfffff0a1
 5d4:	6f4d5f6e 	svcvs	0x004d5f6e
 5d8:	6f006564 	svcvs	0x00006564
 5dc:	61726570 	cmnvs	r2, r0, ror r5
 5e0:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
 5e4:	61657200 	cmnvs	r5, r0, lsl #4
 5e8:	64720064 	ldrbtvs	r0, [r2], #-100	; 0xffffff9c
 5ec:	006d756e 	rsbeq	r7, sp, lr, ror #10
 5f0:	5f746553 	svcpl	0x00746553
 5f4:	61726150 	cmnvs	r2, r0, asr r1
 5f8:	5f00736d 	svcpl	0x0000736d
 5fc:	6f69355a 	svcvs	0x0069355a
 600:	6a6c7463 	bvs	1b1d794 <__bss_end+0x1b15348>
 604:	494e3631 	stmdbmi	lr, {r0, r4, r5, r9, sl, ip, sp}^
 608:	6c74434f 	ldclvs	3, cr4, [r4], #-316	; 0xfffffec4
 60c:	65704f5f 	ldrbvs	r4, [r0, #-3935]!	; 0xfffff0a1
 610:	69746172 	ldmdbvs	r4!, {r1, r4, r5, r6, r8, sp, lr}^
 614:	76506e6f 	ldrbvc	r6, [r0], -pc, ror #28
 618:	61655200 	cmnvs	r5, r0, lsl #4
 61c:	72575f64 	subsvc	r5, r7, #100, 30	; 0x190
 620:	00657469 	rsbeq	r7, r5, r9, ror #8
 624:	70746567 	rsbsvc	r6, r4, r7, ror #10
 628:	69006469 	stmdbvs	r0, {r0, r3, r5, r6, sl, sp, lr}
 62c:	6c74636f 	ldclvs	3, cr6, [r4], #-444	; 0xfffffe44
 630:	365a5f00 	ldrbcc	r5, [sl], -r0, lsl #30
 634:	70746567 	rsbsvc	r6, r4, r7, ror #10
 638:	00766469 	rsbseq	r6, r6, r9, ror #8
 63c:	61726170 	cmnvs	r2, r0, ror r1
 640:	7865006d 	stmdavc	r5!, {r0, r2, r3, r5, r6}^
 644:	6f637469 	svcvs	0x00637469
 648:	52006564 	andpl	r6, r0, #100, 10	; 0x19000000
 64c:	5f646165 	svcpl	0x00646165
 650:	796c6e4f 	stmdbvc	ip!, {r0, r1, r2, r3, r6, r9, sl, fp, sp, lr}^
 654:	554e4700 	strbpl	r4, [lr, #-1792]	; 0xfffff900
 658:	2b2b4320 	blcs	ad12e0 <__bss_end+0xac8e94>
 65c:	31203431 			; <UNDEFINED> instruction: 0x31203431
 660:	2e332e30 	mrccs	14, 1, r2, cr3, cr0, {1}
 664:	30322031 	eorscc	r2, r2, r1, lsr r0
 668:	36303132 			; <UNDEFINED> instruction: 0x36303132
 66c:	28203132 	stmdacs	r0!, {r1, r4, r5, r8, ip, sp}
 670:	656c6572 	strbvs	r6, [ip, #-1394]!	; 0xfffffa8e
 674:	29657361 	stmdbcs	r5!, {r0, r5, r6, r8, r9, ip, sp, lr}^
 678:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
 67c:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
 680:	6962612d 	stmdbvs	r2!, {r0, r2, r3, r5, r8, sp, lr}^
 684:	7261683d 	rsbvc	r6, r1, #3997696	; 0x3d0000
 688:	6d2d2064 	stcvs	0, cr2, [sp, #-400]!	; 0xfffffe70
 68c:	3d757066 	ldclcc	0, cr7, [r5, #-408]!	; 0xfffffe68
 690:	20706676 	rsbscs	r6, r0, r6, ror r6
 694:	6c666d2d 	stclvs	13, cr6, [r6], #-180	; 0xffffff4c
 698:	2d74616f 	ldfcse	f6, [r4, #-444]!	; 0xfffffe44
 69c:	3d696261 	sfmcc	f6, 2, [r9, #-388]!	; 0xfffffe7c
 6a0:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
 6a4:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
 6a8:	763d7570 			; <UNDEFINED> instruction: 0x763d7570
 6ac:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
 6b0:	6e75746d 	cdpvs	4, 7, cr7, cr5, cr13, {3}
 6b4:	72613d65 	rsbvc	r3, r1, #6464	; 0x1940
 6b8:	3731316d 	ldrcc	r3, [r1, -sp, ror #2]!
 6bc:	667a6a36 			; <UNDEFINED> instruction: 0x667a6a36
 6c0:	2d20732d 	stccs	3, cr7, [r0, #-180]!	; 0xffffff4c
 6c4:	6d72616d 	ldfvse	f6, [r2, #-436]!	; 0xfffffe4c
 6c8:	616d2d20 	cmnvs	sp, r0, lsr #26
 6cc:	3d686372 	stclcc	3, cr6, [r8, #-456]!	; 0xfffffe38
 6d0:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
 6d4:	2b6b7a36 	blcs	1adefb4 <__bss_end+0x1ad6b68>
 6d8:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
 6dc:	672d2067 	strvs	r2, [sp, -r7, rrx]!
 6e0:	20672d20 	rsbcs	r2, r7, r0, lsr #26
 6e4:	20304f2d 	eorscs	r4, r0, sp, lsr #30
 6e8:	20304f2d 	eorscs	r4, r0, sp, lsr #30
 6ec:	6f6e662d 	svcvs	0x006e662d
 6f0:	6378652d 	cmnvs	r8, #188743680	; 0xb400000
 6f4:	69747065 	ldmdbvs	r4!, {r0, r2, r5, r6, ip, sp, lr}^
 6f8:	20736e6f 	rsbscs	r6, r3, pc, ror #28
 6fc:	6f6e662d 	svcvs	0x006e662d
 700:	7474722d 	ldrbtvc	r7, [r4], #-557	; 0xfffffdd3
 704:	75620069 	strbvc	r0, [r2, #-105]!	; 0xffffff97
 708:	72656666 	rsbvc	r6, r5, #106954752	; 0x6600000
 70c:	74657200 	strbtvc	r7, [r5], #-512	; 0xfffffe00
 710:	65646f63 	strbvs	r6, [r4, #-3939]!	; 0xfffff09d
 714:	7a697300 	bvc	1a5d31c <__bss_end+0x1a54ed0>
 718:	72770065 	rsbsvc	r0, r7, #101	; 0x65
 71c:	006d756e 	rsbeq	r7, sp, lr, ror #10
 720:	63355a5f 	teqvs	r5, #389120	; 0x5f000
 724:	65736f6c 	ldrbvs	r6, [r3, #-3948]!	; 0xfffff094
 728:	6d2f006a 	stcvs	0, cr0, [pc, #-424]!	; 588 <_start-0x7a78>
 72c:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
 730:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
 734:	4b2f7372 	blmi	bdd504 <__bss_end+0xbd50b8>
 738:	2f616275 	svccs	0x00616275
 73c:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
 740:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
 744:	63532f73 	cmpvs	r3, #460	; 0x1cc
 748:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; 5b0 <_start-0x7a50>
 74c:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
 750:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
 754:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 758:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
 75c:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
 760:	61702d36 	cmnvs	r0, r6, lsr sp
 764:	676e6967 	strbvs	r6, [lr, -r7, ror #18]!
 768:	6573755f 	ldrbvs	r7, [r3, #-1375]!	; 0xfffffaa1
 76c:	61707372 	cmnvs	r0, r2, ror r3
 770:	732f6563 			; <UNDEFINED> instruction: 0x732f6563
 774:	696c6474 	stmdbvs	ip!, {r2, r4, r5, r6, sl, sp, lr}^
 778:	72732f62 	rsbsvc	r2, r3, #392	; 0x188
 77c:	74732f63 	ldrbtvc	r2, [r3], #-3939	; 0xfffff09d
 780:	6c696664 	stclvs	6, cr6, [r9], #-400	; 0xfffffe70
 784:	70632e65 	rsbvc	r2, r3, r5, ror #28
 788:	706f0070 	rsbvc	r0, pc, r0, ror r0	; <UNPREDICTABLE>
 78c:	5f006e65 	svcpl	0x00006e65
 790:	6572345a 	ldrbvs	r3, [r2, #-1114]!	; 0xfffffba6
 794:	506a6461 	rsbpl	r6, sl, r1, ror #8
 798:	57006a63 	strpl	r6, [r0, -r3, ror #20]
 79c:	65746972 	ldrbvs	r6, [r4, #-2418]!	; 0xfffff68e
 7a0:	6c6e4f5f 	stclvs	15, cr4, [lr], #-380	; 0xfffffe84
 7a4:	73690079 	cmnvc	r9, #121	; 0x79
 7a8:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 7ac:	72705f74 	rsbsvc	r5, r0, #116, 30	; 0x1d0
 7b0:	65726465 	ldrbvs	r6, [r2, #-1125]!	; 0xfffffb9b
 7b4:	73690073 	cmnvc	r9, #115	; 0x73
 7b8:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 7bc:	66765f74 	uhsub16vs	r5, r6, r4
 7c0:	61625f70 	smcvs	9712	; 0x25f0
 7c4:	63006573 	movwvs	r6, #1395	; 0x573
 7c8:	6c706d6f 	ldclvs	13, cr6, [r0], #-444	; 0xfffffe44
 7cc:	66207865 	strtvs	r7, [r0], -r5, ror #16
 7d0:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
 7d4:	61736900 	cmnvs	r3, r0, lsl #18
 7d8:	626f6e5f 	rsbvs	r6, pc, #1520	; 0x5f0
 7dc:	69007469 	stmdbvs	r0, {r0, r3, r5, r6, sl, ip, sp, lr}
 7e0:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 7e4:	6d5f7469 	cfldrdvs	mvd7, [pc, #-420]	; 648 <_start-0x79b8>
 7e8:	665f6576 			; <UNDEFINED> instruction: 0x665f6576
 7ec:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
 7f0:	61736900 	cmnvs	r3, r0, lsl #18
 7f4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 7f8:	3170665f 	cmncc	r0, pc, asr r6
 7fc:	73690036 	cmnvc	r9, #54	; 0x36
 800:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 804:	65735f74 	ldrbvs	r5, [r3, #-3956]!	; 0xfffff08c
 808:	73690063 	cmnvc	r9, #99	; 0x63
 80c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 810:	64615f74 	strbtvs	r5, [r1], #-3956	; 0xfffff08c
 814:	69007669 	stmdbvs	r0, {r0, r3, r5, r6, r9, sl, ip, sp, lr}
 818:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 81c:	715f7469 	cmpvc	pc, r9, ror #8
 820:	6b726975 	blvs	1c9adfc <__bss_end+0x1c929b0>
 824:	5f6f6e5f 	svcpl	0x006f6e5f
 828:	616c6f76 	smcvs	50934	; 0xc6f6
 82c:	656c6974 	strbvs	r6, [ip, #-2420]!	; 0xfffff68c
 830:	0065635f 	rsbeq	r6, r5, pc, asr r3
 834:	5f617369 	svcpl	0x00617369
 838:	5f746962 	svcpl	0x00746962
 83c:	6900706d 	stmdbvs	r0, {r0, r2, r3, r5, r6, ip, sp, lr}
 840:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 844:	615f7469 	cmpvs	pc, r9, ror #8
 848:	35766d72 	ldrbcc	r6, [r6, #-3442]!	; 0xfffff28e
 84c:	73690074 	cmnvc	r9, #116	; 0x74
 850:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 854:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
 858:	7435766d 	ldrtvc	r7, [r5], #-1645	; 0xfffff993
 85c:	73690065 	cmnvc	r9, #101	; 0x65
 860:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 864:	656e5f74 	strbvs	r5, [lr, #-3956]!	; 0xfffff08c
 868:	69006e6f 	stmdbvs	r0, {r0, r1, r2, r3, r5, r6, r9, sl, fp, sp, lr}
 86c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 870:	625f7469 	subsvs	r7, pc, #1761607680	; 0x69000000
 874:	00363166 	eorseq	r3, r6, r6, ror #2
 878:	43535046 	cmpmi	r3, #70	; 0x46
 87c:	4e455f52 	mcrmi	15, 2, r5, cr5, cr2, {2}
 880:	46004d55 			; <UNDEFINED> instruction: 0x46004d55
 884:	52435350 	subpl	r5, r3, #80, 6	; 0x40000001
 888:	637a6e5f 	cmnvs	sl, #1520	; 0x5f0
 88c:	5f637176 	svcpl	0x00637176
 890:	4d554e45 	ldclmi	14, cr4, [r5, #-276]	; 0xfffffeec
 894:	52505600 	subspl	r5, r0, #0, 12
 898:	554e455f 	strbpl	r4, [lr, #-1375]	; 0xfffffaa1
 89c:	6266004d 	rsbvs	r0, r6, #77	; 0x4d
 8a0:	695f7469 	ldmdbvs	pc, {r0, r3, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
 8a4:	696c706d 	stmdbvs	ip!, {r0, r2, r3, r5, r6, ip, sp, lr}^
 8a8:	69746163 	ldmdbvs	r4!, {r0, r1, r5, r6, r8, sp, lr}^
 8ac:	50006e6f 	andpl	r6, r0, pc, ror #28
 8b0:	4e455f30 	mcrmi	15, 2, r5, cr5, cr0, {1}
 8b4:	69004d55 	stmdbvs	r0, {r0, r2, r4, r6, r8, sl, fp, lr}
 8b8:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 8bc:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
 8c0:	74707972 	ldrbtvc	r7, [r0], #-2418	; 0xfffff68e
 8c4:	4e47006f 	cdpmi	0, 4, cr0, cr7, cr15, {3}
 8c8:	31432055 	qdaddcc	r2, r5, r3
 8cc:	30312037 	eorscc	r2, r1, r7, lsr r0
 8d0:	312e332e 			; <UNDEFINED> instruction: 0x312e332e
 8d4:	32303220 	eorscc	r3, r0, #32, 4
 8d8:	32363031 	eorscc	r3, r6, #49	; 0x31
 8dc:	72282031 	eorvc	r2, r8, #49	; 0x31
 8e0:	61656c65 	cmnvs	r5, r5, ror #24
 8e4:	20296573 	eorcs	r6, r9, r3, ror r5
 8e8:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
 8ec:	6d2d206d 	stcvs	0, cr2, [sp, #-436]!	; 0xfffffe4c
 8f0:	616f6c66 	cmnvs	pc, r6, ror #24
 8f4:	62612d74 	rsbvs	r2, r1, #116, 26	; 0x1d00
 8f8:	61683d69 	cmnvs	r8, r9, ror #26
 8fc:	2d206472 	cfstrscs	mvf6, [r0, #-456]!	; 0xfffffe38
 900:	6372616d 	cmnvs	r2, #1073741851	; 0x4000001b
 904:	72613d68 	rsbvc	r3, r1, #104, 26	; 0x1a00
 908:	7435766d 	ldrtvc	r7, [r5], #-1645	; 0xfffff993
 90c:	70662b65 	rsbvc	r2, r6, r5, ror #22
 910:	20672d20 	rsbcs	r2, r7, r0, lsr #26
 914:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
 918:	4f2d2067 	svcmi	0x002d2067
 91c:	4f2d2032 	svcmi	0x002d2032
 920:	4f2d2032 	svcmi	0x002d2032
 924:	662d2032 			; <UNDEFINED> instruction: 0x662d2032
 928:	6c697562 	cfstr64vs	mvdx7, [r9], #-392	; 0xfffffe78
 92c:	676e6964 	strbvs	r6, [lr, -r4, ror #18]!
 930:	62696c2d 	rsbvs	r6, r9, #11520	; 0x2d00
 934:	20636367 	rsbcs	r6, r3, r7, ror #6
 938:	6f6e662d 	svcvs	0x006e662d
 93c:	6174732d 	cmnvs	r4, sp, lsr #6
 940:	702d6b63 	eorvc	r6, sp, r3, ror #22
 944:	65746f72 	ldrbvs	r6, [r4, #-3954]!	; 0xfffff08e
 948:	726f7463 	rsbvc	r7, pc, #1660944384	; 0x63000000
 94c:	6e662d20 	cdpvs	13, 6, cr2, cr6, cr0, {1}
 950:	6e692d6f 	cdpvs	13, 6, cr2, cr9, cr15, {3}
 954:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
 958:	76662d20 	strbtvc	r2, [r6], -r0, lsr #26
 95c:	62697369 	rsbvs	r7, r9, #-1543503871	; 0xa4000001
 960:	74696c69 	strbtvc	r6, [r9], #-3177	; 0xfffff397
 964:	69683d79 	stmdbvs	r8!, {r0, r3, r4, r5, r6, r8, sl, fp, ip, sp}^
 968:	6e656464 	cdpvs	4, 6, cr6, cr5, cr4, {3}
 96c:	61736900 	cmnvs	r3, r0, lsl #18
 970:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 974:	6964745f 	stmdbvs	r4!, {r0, r1, r2, r3, r4, r6, sl, ip, sp, lr}^
 978:	6f630076 	svcvs	0x00630076
 97c:	6900736e 	stmdbvs	r0, {r1, r2, r3, r5, r6, r8, r9, ip, sp, lr}
 980:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 984:	695f7469 	ldmdbvs	pc, {r0, r3, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
 988:	786d6d77 	stmdavc	sp!, {r0, r1, r2, r4, r5, r6, r8, sl, fp, sp, lr}^
 98c:	50460074 	subpl	r0, r6, r4, ror r0
 990:	53545843 	cmppl	r4, #4390912	; 0x430000
 994:	554e455f 	strbpl	r4, [lr, #-1375]	; 0xfffffaa1
 998:	7369004d 	cmnvc	r9, #77	; 0x4d
 99c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 9a0:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
 9a4:	0036766d 	eorseq	r7, r6, sp, ror #12
 9a8:	5f617369 	svcpl	0x00617369
 9ac:	5f746962 	svcpl	0x00746962
 9b0:	0065766d 	rsbeq	r7, r5, sp, ror #12
 9b4:	5f617369 	svcpl	0x00617369
 9b8:	5f746962 	svcpl	0x00746962
 9bc:	6d6d7769 	stclvs	7, cr7, [sp, #-420]!	; 0xfffffe5c
 9c0:	00327478 	eorseq	r7, r2, r8, ror r4
 9c4:	5f617369 	svcpl	0x00617369
 9c8:	5f746962 	svcpl	0x00746962
 9cc:	63656463 	cmnvs	r5, #1660944384	; 0x63000000
 9d0:	69003070 	stmdbvs	r0, {r4, r5, r6, ip, sp}
 9d4:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 9d8:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
 9dc:	70636564 	rsbvc	r6, r3, r4, ror #10
 9e0:	73690031 	cmnvc	r9, #49	; 0x31
 9e4:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 9e8:	64635f74 	strbtvs	r5, [r3], #-3956	; 0xfffff08c
 9ec:	32706365 	rsbscc	r6, r0, #-1811939327	; 0x94000001
 9f0:	61736900 	cmnvs	r3, r0, lsl #18
 9f4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 9f8:	6564635f 	strbvs	r6, [r4, #-863]!	; 0xfffffca1
 9fc:	00337063 	eorseq	r7, r3, r3, rrx
 a00:	5f617369 	svcpl	0x00617369
 a04:	5f746962 	svcpl	0x00746962
 a08:	63656463 	cmnvs	r5, #1660944384	; 0x63000000
 a0c:	69003470 	stmdbvs	r0, {r4, r5, r6, sl, ip, sp}
 a10:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 a14:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
 a18:	62645f70 	rsbvs	r5, r4, #112, 30	; 0x1c0
 a1c:	7369006c 	cmnvc	r9, #108	; 0x6c
 a20:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 a24:	64635f74 	strbtvs	r5, [r3], #-3956	; 0xfffff08c
 a28:	36706365 	ldrbtcc	r6, [r0], -r5, ror #6
 a2c:	61736900 	cmnvs	r3, r0, lsl #18
 a30:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 a34:	6564635f 	strbvs	r6, [r4, #-863]!	; 0xfffffca1
 a38:	00377063 	eorseq	r7, r7, r3, rrx
 a3c:	5f617369 	svcpl	0x00617369
 a40:	5f746962 	svcpl	0x00746962
 a44:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
 a48:	69006b36 	stmdbvs	r0, {r1, r2, r4, r5, r8, r9, fp, sp, lr}
 a4c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 a50:	615f7469 	cmpvs	pc, r9, ror #8
 a54:	38766d72 	ldmdacc	r6!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^
 a58:	5f6d315f 	svcpl	0x006d315f
 a5c:	6e69616d 	powvsez	f6, f1, #5.0
 a60:	746e6100 	strbtvc	r6, [lr], #-256	; 0xffffff00
 a64:	73690065 	cmnvc	r9, #101	; 0x65
 a68:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 a6c:	6d635f74 	stclvs	15, cr5, [r3, #-464]!	; 0xfffffe30
 a70:	6c006573 	cfstr32vs	mvfx6, [r0], {115}	; 0x73
 a74:	20676e6f 	rsbcs	r6, r7, pc, ror #28
 a78:	62756f64 	rsbsvs	r6, r5, #100, 30	; 0x190
 a7c:	2e00656c 	cfsh32cs	mvfx6, mvfx0, #60
 a80:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 a84:	2f2e2e2f 	svccs	0x002e2e2f
 a88:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 a8c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 a90:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
 a94:	2f636367 	svccs	0x00636367
 a98:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
 a9c:	2e326363 	cdpcs	3, 3, cr6, cr2, cr3, {3}
 aa0:	73690063 	cmnvc	r9, #99	; 0x63
 aa4:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 aa8:	70665f74 	rsbvc	r5, r6, r4, ror pc
 aac:	69003576 	stmdbvs	r0, {r1, r2, r4, r5, r6, r8, sl, ip, sp}
 ab0:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 ab4:	785f7469 	ldmdavc	pc, {r0, r3, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
 ab8:	6c616373 	stclvs	3, cr6, [r1], #-460	; 0xfffffe34
 abc:	6f6c0065 	svcvs	0x006c0065
 ac0:	6c20676e 	stcvs	7, cr6, [r0], #-440	; 0xfffffe48
 ac4:	20676e6f 	rsbcs	r6, r7, pc, ror #28
 ac8:	69736e75 	ldmdbvs	r3!, {r0, r2, r4, r5, r6, r9, sl, fp, sp, lr}^
 acc:	64656e67 	strbtvs	r6, [r5], #-3687	; 0xfffff199
 ad0:	746e6920 	strbtvc	r6, [lr], #-2336	; 0xfffff6e0
 ad4:	61736900 	cmnvs	r3, r0, lsl #18
 ad8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 adc:	6975715f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, r8, ip, sp, lr}^
 ae0:	635f6b72 	cmpvs	pc, #116736	; 0x1c800
 ae4:	6c5f336d 	mrrcvs	3, 6, r3, pc, cr13	; <UNPREDICTABLE>
 ae8:	00647264 	rsbeq	r7, r4, r4, ror #4
 aec:	5f617369 	svcpl	0x00617369
 af0:	5f746962 	svcpl	0x00746962
 af4:	6d6d3869 	stclvs	8, cr3, [sp, #-420]!	; 0xfffffe5c
 af8:	61736900 	cmnvs	r3, r0, lsl #18
 afc:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 b00:	5f70665f 	svcpl	0x0070665f
 b04:	00323364 	eorseq	r3, r2, r4, ror #6
 b08:	5f617369 	svcpl	0x00617369
 b0c:	5f746962 	svcpl	0x00746962
 b10:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
 b14:	006d6537 	rsbeq	r6, sp, r7, lsr r5
 b18:	5f617369 	svcpl	0x00617369
 b1c:	5f746962 	svcpl	0x00746962
 b20:	6561706c 	strbvs	r7, [r1, #-108]!	; 0xffffff94
 b24:	6c6c6100 	stfvse	f6, [ip], #-0
 b28:	706d695f 	rsbvc	r6, sp, pc, asr r9
 b2c:	6465696c 	strbtvs	r6, [r5], #-2412	; 0xfffff694
 b30:	6962665f 	stmdbvs	r2!, {r0, r1, r2, r3, r4, r6, r9, sl, sp, lr}^
 b34:	69007374 	stmdbvs	r0, {r2, r4, r5, r6, r8, r9, ip, sp, lr}
 b38:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 b3c:	615f7469 	cmpvs	pc, r9, ror #8
 b40:	38766d72 	ldmdacc	r6!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^
 b44:	6900315f 	stmdbvs	r0, {r0, r1, r2, r3, r4, r6, r8, ip, sp}
 b48:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 b4c:	615f7469 	cmpvs	pc, r9, ror #8
 b50:	38766d72 	ldmdacc	r6!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^
 b54:	6900325f 	stmdbvs	r0, {r0, r1, r2, r3, r4, r6, r9, ip, sp}
 b58:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 b5c:	615f7469 	cmpvs	pc, r9, ror #8
 b60:	38766d72 	ldmdacc	r6!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^
 b64:	6900335f 	stmdbvs	r0, {r0, r1, r2, r3, r4, r6, r8, r9, ip, sp}
 b68:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 b6c:	615f7469 	cmpvs	pc, r9, ror #8
 b70:	38766d72 	ldmdacc	r6!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^
 b74:	6900345f 	stmdbvs	r0, {r0, r1, r2, r3, r4, r6, sl, ip, sp}
 b78:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 b7c:	615f7469 	cmpvs	pc, r9, ror #8
 b80:	38766d72 	ldmdacc	r6!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^
 b84:	6900355f 	stmdbvs	r0, {r0, r1, r2, r3, r4, r6, r8, sl, ip, sp}
 b88:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 b8c:	615f7469 	cmpvs	pc, r9, ror #8
 b90:	38766d72 	ldmdacc	r6!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^
 b94:	6900365f 	stmdbvs	r0, {r0, r1, r2, r3, r4, r6, r9, sl, ip, sp}
 b98:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 b9c:	735f7469 	cmpvc	pc, #1761607680	; 0x69000000
 ba0:	73690062 	cmnvc	r9, #98	; 0x62
 ba4:	756e5f61 	strbvc	r5, [lr, #-3937]!	; 0xfffff09f
 ba8:	69625f6d 	stmdbvs	r2!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
 bac:	69007374 	stmdbvs	r0, {r2, r4, r5, r6, r8, r9, ip, sp, lr}
 bb0:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 bb4:	735f7469 	cmpvc	pc, #1761607680	; 0x69000000
 bb8:	6c6c616d 	stfvse	f6, [ip], #-436	; 0xfffffe4c
 bbc:	006c756d 	rsbeq	r7, ip, sp, ror #10
 bc0:	6975622f 	ldmdbvs	r5!, {r0, r1, r2, r3, r5, r9, sp, lr}^
 bc4:	672f646c 	strvs	r6, [pc, -ip, ror #8]!
 bc8:	612d6363 			; <UNDEFINED> instruction: 0x612d6363
 bcc:	6e2d6d72 	mcrvs	13, 1, r6, cr13, cr2, {3}
 bd0:	2d656e6f 	stclcs	14, cr6, [r5, #-444]!	; 0xfffffe44
 bd4:	69626165 	stmdbvs	r2!, {r0, r2, r5, r6, r8, sp, lr}^
 bd8:	6659682d 	ldrbvs	r6, [r9], -sp, lsr #16
 bdc:	2f344b67 	svccs	0x00344b67
 be0:	2d636367 	stclcs	3, cr6, [r3, #-412]!	; 0xfffffe64
 be4:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
 be8:	656e6f6e 	strbvs	r6, [lr, #-3950]!	; 0xfffff092
 bec:	6261652d 	rsbvs	r6, r1, #188743680	; 0xb400000
 bf0:	30312d69 	eorscc	r2, r1, r9, ror #26
 bf4:	322d332e 	eorcc	r3, sp, #-1207959552	; 0xb8000000
 bf8:	2e313230 	mrccs	2, 1, r3, cr1, cr0, {1}
 bfc:	622f3730 	eorvs	r3, pc, #48, 14	; 0xc00000
 c00:	646c6975 	strbtvs	r6, [ip], #-2421	; 0xfffff68b
 c04:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
 c08:	6e6f6e2d 	cdpvs	14, 6, cr6, cr15, cr13, {1}
 c0c:	61652d65 	cmnvs	r5, r5, ror #26
 c10:	612f6962 			; <UNDEFINED> instruction: 0x612f6962
 c14:	762f6d72 			; <UNDEFINED> instruction: 0x762f6d72
 c18:	2f657435 	svccs	0x00657435
 c1c:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
 c20:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
 c24:	00636367 	rsbeq	r6, r3, r7, ror #6
 c28:	636e7566 	cmnvs	lr, #427819008	; 0x19800000
 c2c:	7274705f 	rsbsvc	r7, r4, #95	; 0x5f
 c30:	6d6f6300 	stclvs	3, cr6, [pc, #-0]	; c38 <_start-0x73c8>
 c34:	78656c70 	stmdavc	r5!, {r4, r5, r6, sl, fp, sp, lr}^
 c38:	756f6420 	strbvc	r6, [pc, #-1056]!	; 820 <_start-0x77e0>
 c3c:	00656c62 	rsbeq	r6, r5, r2, ror #24
 c40:	465f424e 	ldrbmi	r4, [pc], -lr, asr #4
 c44:	59535f50 	ldmdbpl	r3, {r4, r6, r8, r9, sl, fp, ip, lr}^
 c48:	47455253 	smlsldmi	r5, r5, r3, r2	; <UNPREDICTABLE>
 c4c:	73690053 	cmnvc	r9, #83	; 0x53
 c50:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 c54:	64635f74 	strbtvs	r5, [r3], #-3956	; 0xfffff08c
 c58:	35706365 	ldrbcc	r6, [r0, #-869]!	; 0xfffffc9b
 c5c:	61736900 	cmnvs	r3, r0, lsl #18
 c60:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 c64:	7066765f 	rsbvc	r7, r6, pc, asr r6
 c68:	69003276 	stmdbvs	r0, {r1, r2, r4, r5, r6, r9, ip, sp}
 c6c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 c70:	765f7469 	ldrbvc	r7, [pc], -r9, ror #8
 c74:	33767066 	cmncc	r6, #102	; 0x66
 c78:	61736900 	cmnvs	r3, r0, lsl #18
 c7c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 c80:	7066765f 	rsbvc	r7, r6, pc, asr r6
 c84:	46003476 			; <UNDEFINED> instruction: 0x46003476
 c88:	54584350 	ldrbpl	r4, [r8], #-848	; 0xfffffcb0
 c8c:	455f534e 	ldrbmi	r5, [pc, #-846]	; 946 <_start-0x76ba>
 c90:	004d554e 	subeq	r5, sp, lr, asr #10
 c94:	5f617369 	svcpl	0x00617369
 c98:	5f746962 	svcpl	0x00746962
 c9c:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
 ca0:	73690062 	cmnvc	r9, #98	; 0x62
 ca4:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 ca8:	70665f74 	rsbvc	r5, r6, r4, ror pc
 cac:	6f633631 	svcvs	0x00633631
 cb0:	6900766e 	stmdbvs	r0, {r1, r2, r3, r5, r6, r9, sl, ip, sp, lr}
 cb4:	665f6173 			; <UNDEFINED> instruction: 0x665f6173
 cb8:	75746165 	ldrbvc	r6, [r4, #-357]!	; 0xfffffe9b
 cbc:	69006572 	stmdbvs	r0, {r1, r4, r5, r6, r8, sl, sp, lr}
 cc0:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 cc4:	6e5f7469 	cdpvs	4, 5, cr7, cr15, cr9, {3}
 cc8:	006d746f 	rsbeq	r7, sp, pc, ror #8
 ccc:	5f617369 	svcpl	0x00617369
 cd0:	5f746962 	svcpl	0x00746962
 cd4:	72697571 	rsbvc	r7, r9, #473956352	; 0x1c400000
 cd8:	72615f6b 	rsbvc	r5, r1, #428	; 0x1ac
 cdc:	6b36766d 	blvs	d9e698 <__bss_end+0xd9624c>
 ce0:	7369007a 	cmnvc	r9, #122	; 0x7a
 ce4:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 ce8:	72635f74 	rsbvc	r5, r3, #116, 30	; 0x1d0
 cec:	00323363 	eorseq	r3, r2, r3, ror #6
 cf0:	5f617369 	svcpl	0x00617369
 cf4:	5f746962 	svcpl	0x00746962
 cf8:	72697571 	rsbvc	r7, r9, #473956352	; 0x1c400000
 cfc:	6f6e5f6b 	svcvs	0x006e5f6b
 d00:	6d73615f 	ldfvse	f6, [r3, #-380]!	; 0xfffffe84
 d04:	00757063 	rsbseq	r7, r5, r3, rrx
 d08:	5f617369 	svcpl	0x00617369
 d0c:	5f746962 	svcpl	0x00746962
 d10:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
 d14:	73690034 	cmnvc	r9, #52	; 0x34
 d18:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 d1c:	68745f74 	ldmdavs	r4!, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
 d20:	32626d75 	rsbcc	r6, r2, #7488	; 0x1d40
 d24:	61736900 	cmnvs	r3, r0, lsl #18
 d28:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 d2c:	3865625f 	stmdacc	r5!, {r0, r1, r2, r3, r4, r6, r9, sp, lr}^
 d30:	61736900 	cmnvs	r3, r0, lsl #18
 d34:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 d38:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
 d3c:	69003776 	stmdbvs	r0, {r1, r2, r4, r5, r6, r8, r9, sl, ip, sp}
 d40:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 d44:	615f7469 	cmpvs	pc, r9, ror #8
 d48:	38766d72 	ldmdacc	r6!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^
 d4c:	70667600 	rsbvc	r7, r6, r0, lsl #12
 d50:	7379735f 	cmnvc	r9, #2080374785	; 0x7c000001
 d54:	73676572 	cmnvc	r7, #478150656	; 0x1c800000
 d58:	636e655f 	cmnvs	lr, #398458880	; 0x17c00000
 d5c:	6e69646f 	cdpvs	4, 6, cr6, cr9, cr15, {3}
 d60:	73690067 	cmnvc	r9, #103	; 0x67
 d64:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 d68:	70665f74 	rsbvc	r5, r6, r4, ror pc
 d6c:	6d663631 	stclvs	6, cr3, [r6, #-196]!	; 0xffffff3c
 d70:	7369006c 	cmnvc	r9, #108	; 0x6c
 d74:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 d78:	6f645f74 	svcvs	0x00645f74
 d7c:	6f727074 	svcvs	0x00727074
 d80:	Address 0x0000000000000d80 is out of bounds.


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
  20:	8b040e42 	blhi	103930 <__bss_end+0xfb4e4>
  24:	0b0d4201 	bleq	350830 <__bss_end+0x3483e4>
  28:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
  2c:	00000ecb 	andeq	r0, r0, fp, asr #29
  30:	0000001c 	andeq	r0, r0, ip, lsl r0
  34:	00000000 	andeq	r0, r0, r0
  38:	00008064 	andeq	r8, r0, r4, rrx
  3c:	00000040 	andeq	r0, r0, r0, asr #32
  40:	8b080e42 	blhi	203950 <__bss_end+0x1fb504>
  44:	42018e02 	andmi	r8, r1, #2, 28
  48:	5a040b0c 	bpl	102c80 <__bss_end+0xfa834>
  4c:	00080d0c 	andeq	r0, r8, ip, lsl #26
  50:	0000000c 	andeq	r0, r0, ip
  54:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  58:	7c020001 	stcvc	0, cr0, [r2], {1}
  5c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  60:	0000001c 	andeq	r0, r0, ip, lsl r0
  64:	00000050 	andeq	r0, r0, r0, asr r0
  68:	000080a4 	andeq	r8, r0, r4, lsr #1
  6c:	00000038 	andeq	r0, r0, r8, lsr r0
  70:	8b040e42 	blhi	103980 <__bss_end+0xfb534>
  74:	0b0d4201 	bleq	350880 <__bss_end+0x348434>
  78:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
  7c:	00000ecb 	andeq	r0, r0, fp, asr #29
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	00000050 	andeq	r0, r0, r0, asr r0
  88:	000080dc 	ldrdeq	r8, [r0], -ip
  8c:	0000002c 	andeq	r0, r0, ip, lsr #32
  90:	8b040e42 	blhi	1039a0 <__bss_end+0xfb554>
  94:	0b0d4201 	bleq	3508a0 <__bss_end+0x348454>
  98:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
  9c:	00000ecb 	andeq	r0, r0, fp, asr #29
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	00000050 	andeq	r0, r0, r0, asr r0
  a8:	00008108 	andeq	r8, r0, r8, lsl #2
  ac:	00000020 	andeq	r0, r0, r0, lsr #32
  b0:	8b040e42 	blhi	1039c0 <__bss_end+0xfb574>
  b4:	0b0d4201 	bleq	3508c0 <__bss_end+0x348474>
  b8:	420d0d48 	andmi	r0, sp, #72, 26	; 0x1200
  bc:	00000ecb 	andeq	r0, r0, fp, asr #29
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	00000050 	andeq	r0, r0, r0, asr r0
  c8:	00008128 	andeq	r8, r0, r8, lsr #2
  cc:	00000018 	andeq	r0, r0, r8, lsl r0
  d0:	8b040e42 	blhi	1039e0 <__bss_end+0xfb594>
  d4:	0b0d4201 	bleq	3508e0 <__bss_end+0x348494>
  d8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  dc:	00000ecb 	andeq	r0, r0, fp, asr #29
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	00000050 	andeq	r0, r0, r0, asr r0
  e8:	00008140 	andeq	r8, r0, r0, asr #2
  ec:	00000018 	andeq	r0, r0, r8, lsl r0
  f0:	8b040e42 	blhi	103a00 <__bss_end+0xfb5b4>
  f4:	0b0d4201 	bleq	350900 <__bss_end+0x3484b4>
  f8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  fc:	00000ecb 	andeq	r0, r0, fp, asr #29
 100:	0000001c 	andeq	r0, r0, ip, lsl r0
 104:	00000050 	andeq	r0, r0, r0, asr r0
 108:	00008158 	andeq	r8, r0, r8, asr r1
 10c:	00000018 	andeq	r0, r0, r8, lsl r0
 110:	8b040e42 	blhi	103a20 <__bss_end+0xfb5d4>
 114:	0b0d4201 	bleq	350920 <__bss_end+0x3484d4>
 118:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
 11c:	00000ecb 	andeq	r0, r0, fp, asr #29
 120:	00000014 	andeq	r0, r0, r4, lsl r0
 124:	00000050 	andeq	r0, r0, r0, asr r0
 128:	00008170 	andeq	r8, r0, r0, ror r1
 12c:	0000000c 	andeq	r0, r0, ip
 130:	8b040e42 	blhi	103a40 <__bss_end+0xfb5f4>
 134:	0b0d4201 	bleq	350940 <__bss_end+0x3484f4>
 138:	0000001c 	andeq	r0, r0, ip, lsl r0
 13c:	00000050 	andeq	r0, r0, r0, asr r0
 140:	0000817c 	andeq	r8, r0, ip, ror r1
 144:	00000058 	andeq	r0, r0, r8, asr r0
 148:	8b080e42 	blhi	203a58 <__bss_end+0x1fb60c>
 14c:	42018e02 	andmi	r8, r1, #2, 28
 150:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 154:	00080d0c 	andeq	r0, r8, ip, lsl #26
 158:	0000001c 	andeq	r0, r0, ip, lsl r0
 15c:	00000050 	andeq	r0, r0, r0, asr r0
 160:	000081d4 	ldrdeq	r8, [r0], -r4
 164:	00000058 	andeq	r0, r0, r8, asr r0
 168:	8b080e42 	blhi	203a78 <__bss_end+0x1fb62c>
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
 194:	0000001c 	andeq	r0, r0, ip, lsl r0
 198:	8b080e42 	blhi	203aa8 <__bss_end+0x1fb65c>
 19c:	42018e02 	andmi	r8, r1, #2, 28
 1a0:	00040b0c 	andeq	r0, r4, ip, lsl #22
 1a4:	0000000c 	andeq	r0, r0, ip
 1a8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 1ac:	7c020001 	stcvc	0, cr0, [r2], {1}
 1b0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 1b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1b8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1bc:	00008248 	andeq	r8, r0, r8, asr #4
 1c0:	0000002c 	andeq	r0, r0, ip, lsr #32
 1c4:	8b040e42 	blhi	103ad4 <__bss_end+0xfb688>
 1c8:	0b0d4201 	bleq	3509d4 <__bss_end+0x348588>
 1cc:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 1d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 1d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1d8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1dc:	00008274 	andeq	r8, r0, r4, ror r2
 1e0:	0000002c 	andeq	r0, r0, ip, lsr #32
 1e4:	8b040e42 	blhi	103af4 <__bss_end+0xfb6a8>
 1e8:	0b0d4201 	bleq	3509f4 <__bss_end+0x3485a8>
 1ec:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 1f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 1f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1f8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1fc:	000082a0 	andeq	r8, r0, r0, lsr #5
 200:	0000001c 	andeq	r0, r0, ip, lsl r0
 204:	8b040e42 	blhi	103b14 <__bss_end+0xfb6c8>
 208:	0b0d4201 	bleq	350a14 <__bss_end+0x3485c8>
 20c:	420d0d46 	andmi	r0, sp, #4480	; 0x1180
 210:	00000ecb 	andeq	r0, r0, fp, asr #29
 214:	0000001c 	andeq	r0, r0, ip, lsl r0
 218:	000001a4 	andeq	r0, r0, r4, lsr #3
 21c:	000082bc 			; <UNDEFINED> instruction: 0x000082bc
 220:	00000044 	andeq	r0, r0, r4, asr #32
 224:	8b040e42 	blhi	103b34 <__bss_end+0xfb6e8>
 228:	0b0d4201 	bleq	350a34 <__bss_end+0x3485e8>
 22c:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 230:	00000ecb 	andeq	r0, r0, fp, asr #29
 234:	0000001c 	andeq	r0, r0, ip, lsl r0
 238:	000001a4 	andeq	r0, r0, r4, lsr #3
 23c:	00008300 	andeq	r8, r0, r0, lsl #6
 240:	00000050 	andeq	r0, r0, r0, asr r0
 244:	8b040e42 	blhi	103b54 <__bss_end+0xfb708>
 248:	0b0d4201 	bleq	350a54 <__bss_end+0x348608>
 24c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 250:	00000ecb 	andeq	r0, r0, fp, asr #29
 254:	0000001c 	andeq	r0, r0, ip, lsl r0
 258:	000001a4 	andeq	r0, r0, r4, lsr #3
 25c:	00008350 	andeq	r8, r0, r0, asr r3
 260:	00000050 	andeq	r0, r0, r0, asr r0
 264:	8b040e42 	blhi	103b74 <__bss_end+0xfb728>
 268:	0b0d4201 	bleq	350a74 <__bss_end+0x348628>
 26c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 270:	00000ecb 	andeq	r0, r0, fp, asr #29
 274:	0000001c 	andeq	r0, r0, ip, lsl r0
 278:	000001a4 	andeq	r0, r0, r4, lsr #3
 27c:	000083a0 	andeq	r8, r0, r0, lsr #7
 280:	0000002c 	andeq	r0, r0, ip, lsr #32
 284:	8b040e42 	blhi	103b94 <__bss_end+0xfb748>
 288:	0b0d4201 	bleq	350a94 <__bss_end+0x348648>
 28c:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 290:	00000ecb 	andeq	r0, r0, fp, asr #29
 294:	0000001c 	andeq	r0, r0, ip, lsl r0
 298:	000001a4 	andeq	r0, r0, r4, lsr #3
 29c:	000083cc 	andeq	r8, r0, ip, asr #7
 2a0:	00000050 	andeq	r0, r0, r0, asr r0
 2a4:	8b040e42 	blhi	103bb4 <__bss_end+0xfb768>
 2a8:	0b0d4201 	bleq	350ab4 <__bss_end+0x348668>
 2ac:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 2b0:	00000ecb 	andeq	r0, r0, fp, asr #29
