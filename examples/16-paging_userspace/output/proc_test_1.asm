
./proc_test_1:     file format elf32-littlearm


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
    805c:	000084e4 	andeq	r8, r0, r4, ror #9
    8060:	000084f4 	strdeq	r8, [r0], -r4

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
    81cc:	000084e4 	andeq	r8, r0, r4, ror #9
    81d0:	000084e4 	andeq	r8, r0, r4, ror #9

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
    8224:	000084e4 	andeq	r8, r0, r4, ror #9
    8228:	000084e4 	andeq	r8, r0, r4, ror #9

0000822c <main>:
main():
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/test_process_1/main.cpp:7
#include <stdfile.h>

#include <drivers/bridges/uart_defs.h>

int main(int argc, char** argv)
{
    822c:	e92d4800 	push	{fp, lr}
    8230:	e28db004 	add	fp, sp, #4
    8234:	e24dd018 	sub	sp, sp, #24
    8238:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    823c:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/test_process_1/main.cpp:10
	volatile int i;

    uint32_t f = open("DEV:segd", NFile_Open_Mode::Write_Only);
    8240:	e3a01001 	mov	r1, #1
    8244:	e59f008c 	ldr	r0, [pc, #140]	; 82d8 <main+0xac>
    8248:	eb000041 	bl	8354 <_Z4openPKc15NFile_Open_Mode>
    824c:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/test_process_1/main.cpp:11
    write(f, "4", 1);
    8250:	e3a02001 	mov	r2, #1
    8254:	e59f1080 	ldr	r1, [pc, #128]	; 82dc <main+0xb0>
    8258:	e51b0008 	ldr	r0, [fp, #-8]
    825c:	eb000061 	bl	83e8 <_Z5writejPKcj>
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/test_process_1/main.cpp:13

    char message[] = "0";
    8260:	e3a03030 	mov	r3, #48	; 0x30
    8264:	e14b31b0 	strh	r3, [fp, #-16]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/test_process_1/main.cpp:17

    while (true)
    {
        if (message[0] == '9')
    8268:	e55b3010 	ldrb	r3, [fp, #-16]
    826c:	e3530039 	cmp	r3, #57	; 0x39
    8270:	1a000002 	bne	8280 <main+0x54>
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/test_process_1/main.cpp:19
        {
            message[0] = '0';
    8274:	e3a03030 	mov	r3, #48	; 0x30
    8278:	e54b3010 	strb	r3, [fp, #-16]
    827c:	ea000003 	b	8290 <main+0x64>
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/test_process_1/main.cpp:23
        }
        else
        {
            ++message[0];
    8280:	e55b3010 	ldrb	r3, [fp, #-16]
    8284:	e2833001 	add	r3, r3, #1
    8288:	e6ef3073 	uxtb	r3, r3
    828c:	e54b3010 	strb	r3, [fp, #-16]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/test_process_1/main.cpp:26
        }

        write(f, message, 1);
    8290:	e24b3010 	sub	r3, fp, #16
    8294:	e3a02001 	mov	r2, #1
    8298:	e1a01003 	mov	r1, r3
    829c:	e51b0008 	ldr	r0, [fp, #-8]
    82a0:	eb000050 	bl	83e8 <_Z5writejPKcj>
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/test_process_1/main.cpp:28

        for (i = 0; i < 0x1600; i++)
    82a4:	e3a03000 	mov	r3, #0
    82a8:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/test_process_1/main.cpp:28 (discriminator 3)
    82ac:	e51b300c 	ldr	r3, [fp, #-12]
    82b0:	e3530c16 	cmp	r3, #5632	; 0x1600
    82b4:	b3a03001 	movlt	r3, #1
    82b8:	a3a03000 	movge	r3, #0
    82bc:	e6ef3073 	uxtb	r3, r3
    82c0:	e3530000 	cmp	r3, #0
    82c4:	0affffe7 	beq	8268 <main+0x3c>
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/userspace/test_process_1/main.cpp:28 (discriminator 2)
    82c8:	e51b300c 	ldr	r3, [fp, #-12]
    82cc:	e2833001 	add	r3, r3, #1
    82d0:	e50b300c 	str	r3, [fp, #-12]
    82d4:	eafffff4 	b	82ac <main+0x80>
    82d8:	000084c4 	andeq	r8, r0, r4, asr #9
    82dc:	000084d0 	ldrdeq	r8, [r0], -r0

000082e0 <_Z6getpidv>:
_Z6getpidv():
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:4
#include <stdfile.h>

uint32_t getpid()
{
    82e0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    82e4:	e28db000 	add	fp, sp, #0
    82e8:	e24dd00c 	sub	sp, sp, #12
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:7
    uint32_t pid;

    asm volatile("swi 0");
    82ec:	ef000000 	svc	0x00000000
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:8
    asm volatile("mov %0, r0" : "=r" (pid));
    82f0:	e1a03000 	mov	r3, r0
    82f4:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:10

    return pid;
    82f8:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:11
}
    82fc:	e1a00003 	mov	r0, r3
    8300:	e28bd000 	add	sp, fp, #0
    8304:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8308:	e12fff1e 	bx	lr

0000830c <_Z9terminatei>:
_Z9terminatei():
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:14

void terminate(int exitcode)
{
    830c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8310:	e28db000 	add	fp, sp, #0
    8314:	e24dd00c 	sub	sp, sp, #12
    8318:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:15
    asm volatile("mov r0, %0" : : "r" (exitcode));
    831c:	e51b3008 	ldr	r3, [fp, #-8]
    8320:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:16
    asm volatile("swi 1");
    8324:	ef000001 	svc	0x00000001
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:17
}
    8328:	e320f000 	nop	{0}
    832c:	e28bd000 	add	sp, fp, #0
    8330:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8334:	e12fff1e 	bx	lr

00008338 <_Z11sched_yieldv>:
_Z11sched_yieldv():
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:20

void sched_yield()
{
    8338:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    833c:	e28db000 	add	fp, sp, #0
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:21
    asm volatile("swi 2");
    8340:	ef000002 	svc	0x00000002
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:22
}
    8344:	e320f000 	nop	{0}
    8348:	e28bd000 	add	sp, fp, #0
    834c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8350:	e12fff1e 	bx	lr

00008354 <_Z4openPKc15NFile_Open_Mode>:
_Z4openPKc15NFile_Open_Mode():
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:25

uint32_t open(const char* filename, NFile_Open_Mode mode)
{
    8354:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8358:	e28db000 	add	fp, sp, #0
    835c:	e24dd014 	sub	sp, sp, #20
    8360:	e50b0010 	str	r0, [fp, #-16]
    8364:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:28
    uint32_t file;

    asm volatile("mov r0, %0" : : "r" (filename));
    8368:	e51b3010 	ldr	r3, [fp, #-16]
    836c:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:29
    asm volatile("mov r1, %0" : : "r" (mode));
    8370:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8374:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:30
    asm volatile("swi 64");
    8378:	ef000040 	svc	0x00000040
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:31
    asm volatile("mov %0, r0" : "=r" (file));
    837c:	e1a03000 	mov	r3, r0
    8380:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:33

    return file;
    8384:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:34
}
    8388:	e1a00003 	mov	r0, r3
    838c:	e28bd000 	add	sp, fp, #0
    8390:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8394:	e12fff1e 	bx	lr

00008398 <_Z4readjPcj>:
_Z4readjPcj():
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:37

uint32_t read(uint32_t file, char* const buffer, uint32_t size)
{
    8398:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    839c:	e28db000 	add	fp, sp, #0
    83a0:	e24dd01c 	sub	sp, sp, #28
    83a4:	e50b0010 	str	r0, [fp, #-16]
    83a8:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    83ac:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:40
    uint32_t rdnum;

    asm volatile("mov r0, %0" : : "r" (file));
    83b0:	e51b3010 	ldr	r3, [fp, #-16]
    83b4:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:41
    asm volatile("mov r1, %0" : : "r" (buffer));
    83b8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    83bc:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:42
    asm volatile("mov r2, %0" : : "r" (size));
    83c0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    83c4:	e1a02003 	mov	r2, r3
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:43
    asm volatile("swi 65");
    83c8:	ef000041 	svc	0x00000041
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:44
    asm volatile("mov %0, r0" : "=r" (rdnum));
    83cc:	e1a03000 	mov	r3, r0
    83d0:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:46

    return rdnum;
    83d4:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:47
}
    83d8:	e1a00003 	mov	r0, r3
    83dc:	e28bd000 	add	sp, fp, #0
    83e0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    83e4:	e12fff1e 	bx	lr

000083e8 <_Z5writejPKcj>:
_Z5writejPKcj():
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:50

uint32_t write(uint32_t file, const char* buffer, uint32_t size)
{
    83e8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    83ec:	e28db000 	add	fp, sp, #0
    83f0:	e24dd01c 	sub	sp, sp, #28
    83f4:	e50b0010 	str	r0, [fp, #-16]
    83f8:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    83fc:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:53
    uint32_t wrnum;

    asm volatile("mov r0, %0" : : "r" (file));
    8400:	e51b3010 	ldr	r3, [fp, #-16]
    8404:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:54
    asm volatile("mov r1, %0" : : "r" (buffer));
    8408:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    840c:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:55
    asm volatile("mov r2, %0" : : "r" (size));
    8410:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8414:	e1a02003 	mov	r2, r3
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:56
    asm volatile("swi 66");
    8418:	ef000042 	svc	0x00000042
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:57
    asm volatile("mov %0, r0" : "=r" (wrnum));
    841c:	e1a03000 	mov	r3, r0
    8420:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:59

    return wrnum;
    8424:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:60
}
    8428:	e1a00003 	mov	r0, r3
    842c:	e28bd000 	add	sp, fp, #0
    8430:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8434:	e12fff1e 	bx	lr

00008438 <_Z5closej>:
_Z5closej():
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:63

void close(uint32_t file)
{
    8438:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    843c:	e28db000 	add	fp, sp, #0
    8440:	e24dd00c 	sub	sp, sp, #12
    8444:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:64
    asm volatile("mov r0, %0" : : "r" (file));
    8448:	e51b3008 	ldr	r3, [fp, #-8]
    844c:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:65
    asm volatile("swi 67");
    8450:	ef000043 	svc	0x00000043
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:66
}
    8454:	e320f000 	nop	{0}
    8458:	e28bd000 	add	sp, fp, #0
    845c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8460:	e12fff1e 	bx	lr

00008464 <_Z5ioctlj16NIOCtl_OperationPv>:
_Z5ioctlj16NIOCtl_OperationPv():
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:69

uint32_t ioctl(uint32_t file, NIOCtl_Operation operation, void* param)
{
    8464:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8468:	e28db000 	add	fp, sp, #0
    846c:	e24dd01c 	sub	sp, sp, #28
    8470:	e50b0010 	str	r0, [fp, #-16]
    8474:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8478:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:72
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    847c:	e51b3010 	ldr	r3, [fp, #-16]
    8480:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:73
    asm volatile("mov r1, %0" : : "r" (operation));
    8484:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8488:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:74
    asm volatile("mov r2, %0" : : "r" (param));
    848c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8490:	e1a02003 	mov	r2, r3
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:75
    asm volatile("swi 68");
    8494:	ef000044 	svc	0x00000044
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:76
    asm volatile("mov %0, r0" : "=r" (retcode));
    8498:	e1a03000 	mov	r3, r0
    849c:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:78

    return retcode;
    84a0:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/School/ZeroMate/examples/16-paging_userspace/stdlib/src/stdfile.cpp:79
}
    84a4:	e1a00003 	mov	r0, r3
    84a8:	e28bd000 	add	sp, fp, #0
    84ac:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    84b0:	e12fff1e 	bx	lr

Disassembly of section .rodata:

000084b4 <_ZL21MaxFSDriverNameLength>:
    84b4:	00000010 	andeq	r0, r0, r0, lsl r0

000084b8 <_ZL17MaxFilenameLength>:
    84b8:	00000010 	andeq	r0, r0, r0, lsl r0

000084bc <_ZL13MaxPathLength>:
    84bc:	00000080 	andeq	r0, r0, r0, lsl #1

000084c0 <_ZL18NoFilesystemDriver>:
    84c0:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
    84c4:	3a564544 	bcc	15999dc <__bss_end+0x15914e8>
    84c8:	64676573 	strbtvs	r6, [r7], #-1395	; 0xfffffa8d
    84cc:	00000000 	andeq	r0, r0, r0
    84d0:	00000034 	andeq	r0, r0, r4, lsr r0

000084d4 <_ZL21MaxFSDriverNameLength>:
    84d4:	00000010 	andeq	r0, r0, r0, lsl r0

000084d8 <_ZL17MaxFilenameLength>:
    84d8:	00000010 	andeq	r0, r0, r0, lsl r0

000084dc <_ZL13MaxPathLength>:
    84dc:	00000080 	andeq	r0, r0, r0, lsl #1

000084e0 <_ZL18NoFilesystemDriver>:
    84e0:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

Disassembly of section .bss:

000084e4 <__bss_start>:
	...

Disassembly of section .ARM.attributes:

00000000 <.ARM.attributes>:
   0:	00002e41 	andeq	r2, r0, r1, asr #28
   4:	61656100 	cmnvs	r5, r0, lsl #2
   8:	01006962 	tsteq	r0, r2, ror #18
   c:	00000024 	andeq	r0, r0, r4, lsr #32
  10:	4b5a3605 	blmi	168d82c <__bss_end+0x1685338>
  14:	08070600 	stmdaeq	r7, {r9, sl}
  18:	0a010901 	beq	42424 <__bss_end+0x39f30>
  1c:	14041202 	strne	r1, [r4], #-514	; 0xfffffdfe
  20:	17011501 	strne	r1, [r1, -r1, lsl #10]
  24:	1a011803 	bne	46038 <__bss_end+0x3db44>
  28:	22011c01 	andcs	r1, r1, #256	; 0x100
  2c:	Address 0x000000000000002c is out of bounds.


Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347 	bcc	10d0d24 <__bss_end+0x10c8830>
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
  44:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffad8 <__bss_end+0xffff75e4>
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
 134:	05053312 	streq	r3, [r5, #-786]	; 0xfffffcee
 138:	054b3185 	strbeq	r3, [fp, #-389]	; 0xfffffe7b
 13c:	06022f01 	streq	r2, [r2], -r1, lsl #30
 140:	0b010100 	bleq	40548 <__bss_end+0x38054>
 144:	03000001 	movweq	r0, #1
 148:	00008200 	andeq	r8, r0, r0, lsl #4
 14c:	fb010200 	blx	40956 <__bss_end+0x38462>
 150:	01000d0e 	tsteq	r0, lr, lsl #26
 154:	00010101 	andeq	r0, r1, r1, lsl #2
 158:	00010000 	andeq	r0, r1, r0
 15c:	6d2f0100 	stfvss	f0, [pc, #-0]	; 164 <_start-0x7e9c>
 160:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
 164:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
 168:	4b2f7372 	blmi	bdcf38 <__bss_end+0xbd4a44>
 16c:	2f616275 	svccs	0x00616275
 170:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
 174:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
 178:	63532f73 	cmpvs	r3, #460	; 0x1cc
 17c:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; ffffffe4 <__bss_end+0xffff7af0>
 180:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
 184:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
 188:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 18c:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
 190:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
 194:	61702d36 	cmnvs	r0, r6, lsr sp
 198:	676e6967 	strbvs	r6, [lr, -r7, ror #18]!
 19c:	6573755f 	ldrbvs	r7, [r3, #-1375]!	; 0xfffffaa1
 1a0:	61707372 	cmnvs	r0, r2, ror r3
 1a4:	752f6563 	strvc	r6, [pc, #-1379]!	; fffffc49 <__bss_end+0xffff7755>
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
 1dc:	0a05830b 	beq	160e10 <__bss_end+0x15891c>
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
 208:	4a030402 	bmi	c1218 <__bss_end+0xb8d24>
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
 23c:	4a020402 	bmi	8124c <__bss_end+0x78d58>
 240:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
 244:	052d0204 	streq	r0, [sp, #-516]!	; 0xfffffdfc
 248:	01058509 	tsteq	r5, r9, lsl #10
 24c:	000a022f 	andeq	r0, sl, pc, lsr #4
 250:	01b60101 			; <UNDEFINED> instruction: 0x01b60101
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
 2c0:	74736574 	ldrbtvc	r6, [r3], #-1396	; 0xfffffa8c
 2c4:	6f72705f 	svcvs	0x0072705f
 2c8:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
 2cc:	2f00315f 	svccs	0x0000315f
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
 2f8:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffd8c <__bss_end+0xffff7898>
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
 360:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffdf4 <__bss_end+0xffff7900>
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
 3dc:	05180000 	ldreq	r0, [r8, #-0]
 3e0:	0a05a116 	beq	168840 <__bss_end+0x16034c>
 3e4:	16058483 	strne	r8, [r5], -r3, lsl #9
 3e8:	2e09054e 	cfsh32cs	mvfx0, mvfx9, #46
 3ec:	6a4c1805 	bvs	1306408 <__bss_end+0x12fdf14>
 3f0:	052e0d05 	streq	r0, [lr, #-3333]!	; 0xfffff2fb
 3f4:	1005690e 	andne	r6, r5, lr, lsl #18
 3f8:	001705a0 	andseq	r0, r7, r0, lsr #11
 3fc:	4a030402 	bmi	c140c <__bss_end+0xb8f18>
 400:	02000905 	andeq	r0, r0, #81920	; 0x14000
 404:	02d60204 	sbcseq	r0, r6, #4, 4	; 0x40000000
 408:	0101000c 	tsteq	r1, ip
 40c:	0000022a 	andeq	r0, r0, sl, lsr #4
 410:	01bd0003 			; <UNDEFINED> instruction: 0x01bd0003
 414:	01020000 	mrseq	r0, (UNDEF: 2)
 418:	000d0efb 	strdeq	r0, [sp], -fp
 41c:	01010101 	tsteq	r1, r1, lsl #2
 420:	01000000 	mrseq	r0, (UNDEF: 0)
 424:	2f010000 	svccs	0x00010000
 428:	2f746e6d 	svccs	0x00746e6d
 42c:	73552f63 	cmpvc	r5, #396	; 0x18c
 430:	2f737265 	svccs	0x00737265
 434:	6162754b 	cmnvs	r2, fp, asr #10
 438:	636f442f 	cmnvs	pc, #788529152	; 0x2f000000
 43c:	6e656d75 	mcrvs	13, 3, r6, cr5, cr5, {3}
 440:	532f7374 			; <UNDEFINED> instruction: 0x532f7374
 444:	6f6f6863 	svcvs	0x006f6863
 448:	655a2f6c 	ldrbvs	r2, [sl, #-3948]	; 0xfffff094
 44c:	614d6f72 	hvcvs	55026	; 0xd6f2
 450:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffee4 <__bss_end+0xffff79f0>
 454:	706d6178 	rsbvc	r6, sp, r8, ror r1
 458:	2f73656c 	svccs	0x0073656c
 45c:	702d3631 	eorvc	r3, sp, r1, lsr r6
 460:	6e696761 	cdpvs	7, 6, cr6, cr9, cr1, {3}
 464:	73755f67 	cmnvc	r5, #412	; 0x19c
 468:	70737265 	rsbsvc	r7, r3, r5, ror #4
 46c:	2f656361 	svccs	0x00656361
 470:	6c647473 	cfstrdvs	mvd7, [r4], #-460	; 0xfffffe34
 474:	732f6269 			; <UNDEFINED> instruction: 0x732f6269
 478:	2f006372 	svccs	0x00006372
 47c:	2f746e6d 	svccs	0x00746e6d
 480:	73552f63 	cmpvc	r5, #396	; 0x18c
 484:	2f737265 	svccs	0x00737265
 488:	6162754b 	cmnvs	r2, fp, asr #10
 48c:	636f442f 	cmnvs	pc, #788529152	; 0x2f000000
 490:	6e656d75 	mcrvs	13, 3, r6, cr5, cr5, {3}
 494:	532f7374 			; <UNDEFINED> instruction: 0x532f7374
 498:	6f6f6863 	svcvs	0x006f6863
 49c:	655a2f6c 	ldrbvs	r2, [sl, #-3948]	; 0xfffff094
 4a0:	614d6f72 	hvcvs	55026	; 0xd6f2
 4a4:	652f6574 	strvs	r6, [pc, #-1396]!	; ffffff38 <__bss_end+0xffff7a44>
 4a8:	706d6178 	rsbvc	r6, sp, r8, ror r1
 4ac:	2f73656c 	svccs	0x0073656c
 4b0:	702d3631 	eorvc	r3, sp, r1, lsr r6
 4b4:	6e696761 	cdpvs	7, 6, cr6, cr9, cr1, {3}
 4b8:	73755f67 	cmnvc	r5, #412	; 0x19c
 4bc:	70737265 	rsbsvc	r7, r3, r5, ror #4
 4c0:	2f656361 	svccs	0x00656361
 4c4:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 4c8:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 4cc:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 4d0:	662f6564 	strtvs	r6, [pc], -r4, ror #10
 4d4:	6d2f0073 	stcvs	0, cr0, [pc, #-460]!	; 310 <_start-0x7cf0>
 4d8:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
 4dc:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
 4e0:	4b2f7372 	blmi	bdd2b0 <__bss_end+0xbd4dbc>
 4e4:	2f616275 	svccs	0x00616275
 4e8:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
 4ec:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
 4f0:	63532f73 	cmpvs	r3, #460	; 0x1cc
 4f4:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; 35c <_start-0x7ca4>
 4f8:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
 4fc:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
 500:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 504:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
 508:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
 50c:	61702d36 	cmnvs	r0, r6, lsr sp
 510:	676e6967 	strbvs	r6, [lr, -r7, ror #18]!
 514:	6573755f 	ldrbvs	r7, [r3, #-1375]!	; 0xfffffaa1
 518:	61707372 	cmnvs	r0, r2, ror r3
 51c:	6b2f6563 	blvs	bd9ab0 <__bss_end+0xbd15bc>
 520:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 524:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
 528:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 52c:	72702f65 	rsbsvc	r2, r0, #404	; 0x194
 530:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
 534:	6d2f0073 	stcvs	0, cr0, [pc, #-460]!	; 370 <_start-0x7c90>
 538:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
 53c:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
 540:	4b2f7372 	blmi	bdd310 <__bss_end+0xbd4e1c>
 544:	2f616275 	svccs	0x00616275
 548:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
 54c:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
 550:	63532f73 	cmpvs	r3, #460	; 0x1cc
 554:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; 3bc <_start-0x7c44>
 558:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
 55c:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
 560:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 564:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
 568:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
 56c:	61702d36 	cmnvs	r0, r6, lsr sp
 570:	676e6967 	strbvs	r6, [lr, -r7, ror #18]!
 574:	6573755f 	ldrbvs	r7, [r3, #-1375]!	; 0xfffffaa1
 578:	61707372 	cmnvs	r0, r2, ror r3
 57c:	6b2f6563 	blvs	bd9b10 <__bss_end+0xbd161c>
 580:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 584:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
 588:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 58c:	6f622f65 	svcvs	0x00622f65
 590:	2f647261 	svccs	0x00647261
 594:	30697072 	rsbcc	r7, r9, r2, ror r0
 598:	6c61682f 	stclvs	8, cr6, [r1], #-188	; 0xffffff44
 59c:	74730000 	ldrbtvc	r0, [r3], #-0
 5a0:	6c696664 	stclvs	6, cr6, [r9], #-400	; 0xfffffe70
 5a4:	70632e65 	rsbvc	r2, r3, r5, ror #28
 5a8:	00010070 	andeq	r0, r1, r0, ror r0
 5ac:	6c696600 	stclvs	6, cr6, [r9], #-0
 5b0:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
 5b4:	2e6d6574 	mcrcs	5, 3, r6, cr13, cr4, {3}
 5b8:	00020068 	andeq	r0, r2, r8, rrx
 5bc:	69777300 	ldmdbvs	r7!, {r8, r9, ip, sp, lr}^
 5c0:	0300682e 	movweq	r6, #2094	; 0x82e
 5c4:	6e690000 	cdpvs	0, 6, cr0, cr9, cr0, {0}
 5c8:	66656474 			; <UNDEFINED> instruction: 0x66656474
 5cc:	0400682e 	streq	r6, [r0], #-2094	; 0xfffff7d2
 5d0:	05000000 	streq	r0, [r0, #-0]
 5d4:	02050001 	andeq	r0, r5, #1
 5d8:	000082e0 	andeq	r8, r0, r0, ror #5
 5dc:	69050515 	stmdbvs	r5, {r0, r2, r4, r8, sl}
 5e0:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
 5e4:	852f0105 	strhi	r0, [pc, #-261]!	; 4e7 <_start-0x7b19>
 5e8:	4b830505 	blmi	fe0c1a04 <__bss_end+0xfe0b9510>
 5ec:	852f0105 	strhi	r0, [pc, #-261]!	; 4ef <_start-0x7b11>
 5f0:	054b0505 	strbeq	r0, [fp, #-1285]	; 0xfffffafb
 5f4:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 5f8:	4b4ba105 	blmi	12e8a14 <__bss_end+0x12e0520>
 5fc:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
 600:	852f0105 	strhi	r0, [pc, #-261]!	; 503 <_start-0x7afd>
 604:	4bbd0505 	blmi	fef41a20 <__bss_end+0xfef3952c>
 608:	052f4b4b 	streq	r4, [pc, #-2891]!	; fffffac5 <__bss_end+0xffff75d1>
 60c:	01054c0c 	tsteq	r5, ip, lsl #24
 610:	0505852f 	streq	r8, [r5, #-1327]	; 0xfffffad1
 614:	4b4b4bbd 	blmi	12d3510 <__bss_end+0x12cb01c>
 618:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
 61c:	852f0105 	strhi	r0, [pc, #-261]!	; 51f <_start-0x7ae1>
 620:	4b830505 	blmi	fe0c1a3c <__bss_end+0xfe0b9548>
 624:	852f0105 	strhi	r0, [pc, #-261]!	; 527 <_start-0x7ad9>
 628:	4bbd0505 	blmi	fef41a44 <__bss_end+0xfef39550>
 62c:	052f4b4b 	streq	r4, [pc, #-2891]!	; fffffae9 <__bss_end+0xffff75f5>
 630:	01054c0c 	tsteq	r5, ip, lsl #24
 634:	0008022f 	andeq	r0, r8, pc, lsr #4
 638:	00a40101 	adceq	r0, r4, r1, lsl #2
 63c:	00030000 	andeq	r0, r3, r0
 640:	0000009e 	muleq	r0, lr, r0
 644:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
 648:	0101000d 	tsteq	r1, sp
 64c:	00000101 	andeq	r0, r0, r1, lsl #2
 650:	00000100 	andeq	r0, r0, r0, lsl #2
 654:	2f2e2e01 	svccs	0x002e2e01
 658:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 65c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 660:	2f2e2e2f 	svccs	0x002e2e2f
 664:	63672f2e 	cmnvs	r7, #46, 30	; 0xb8
 668:	2e2e0063 	cdpcs	0, 2, cr0, cr14, cr3, {3}
 66c:	2f2e2e2f 	svccs	0x002e2e2f
 670:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 674:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 678:	2f2e2e2f 	svccs	0x002e2e2f
 67c:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
 680:	2e2f6363 	cdpcs	3, 2, cr6, cr15, cr3, {3}
 684:	63672f2e 	cmnvs	r7, #46, 30	; 0xb8
 688:	6f632f63 	svcvs	0x00632f63
 68c:	6769666e 	strbvs	r6, [r9, -lr, ror #12]!
 690:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
 694:	2f2e2e00 	svccs	0x002e2e00
 698:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 69c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 6a0:	2f2e2e2f 	svccs	0x002e2e2f
 6a4:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 5f4 <_start-0x7a0c>
 6a8:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
 6ac:	61000063 	tstvs	r0, r3, rrx
 6b0:	692d6d72 	pushvs	{r1, r4, r5, r6, r8, sl, fp, sp, lr}
 6b4:	682e6173 	stmdavs	lr!, {r0, r1, r4, r5, r6, r8, sp, lr}
 6b8:	00000100 	andeq	r0, r0, r0, lsl #2
 6bc:	2e6d7261 	cdpcs	2, 6, cr7, cr13, cr1, {3}
 6c0:	00020068 	andeq	r0, r2, r8, rrx
 6c4:	6c626700 	stclvs	7, cr6, [r2], #-0
 6c8:	6f74632d 	svcvs	0x0074632d
 6cc:	682e7372 	stmdavs	lr!, {r1, r4, r5, r6, r8, r9, ip, sp, lr}
 6d0:	00000300 	andeq	r0, r0, r0, lsl #6
 6d4:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
 6d8:	2e326363 	cdpcs	3, 3, cr6, cr2, cr3, {3}
 6dc:	00030063 	andeq	r0, r3, r3, rrx
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
  58:	0ad20704 	beq	ff481c70 <__bss_end+0xff47977c>
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
  b0:	0b010000 	bleq	400b8 <__bss_end+0x37bc4>
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
 11c:	0ad20704 	beq	ff481d34 <__bss_end+0xff479840>
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
 15c:	3a010000 	bcc	40164 <__bss_end+0x37c70>
 160:	00007615 	andeq	r7, r0, r5, lsl r6
 164:	02080900 	andeq	r0, r8, #0, 18
 168:	48010000 	stmdami	r1, {}	; <UNPREDICTABLE>
 16c:	0000cb10 	andeq	ip, r0, r0, lsl fp
 170:	0081d400 	addeq	sp, r1, r0, lsl #8
 174:	00005800 	andeq	r5, r0, r0, lsl #16
 178:	cb9c0100 	blgt	fe700580 <__bss_end+0xfe6f808c>
 17c:	0a000000 	beq	184 <_start-0x7e7c>
 180:	00000216 	andeq	r0, r0, r6, lsl r2
 184:	d20c4a01 	andle	r4, ip, #4096	; 0x1000
 188:	02000000 	andeq	r0, r0, #0
 18c:	0b007491 	bleq	1d3d8 <__bss_end+0x14ee4>
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
 200:	5b0c9c01 	blpl	32720c <__bss_end+0x31ed18>
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
 254:	cb110a01 	blgt	442a60 <__bss_end+0x43a56c>
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
 2bc:	0a010067 	beq	40460 <__bss_end+0x37f6c>
 2c0:	00019e2f 	andeq	r9, r1, pc, lsr #28
 2c4:	74910200 	ldrvc	r0, [r1], #512	; 0x200
 2c8:	01500000 	cmpeq	r0, r0
 2cc:	00040000 	andeq	r0, r4, r0
 2d0:	000001c6 	andeq	r0, r0, r6, asr #3
 2d4:	03240104 			; <UNDEFINED> instruction: 0x03240104
 2d8:	05040000 	streq	r0, [r4, #-0]
 2dc:	5a000004 	bpl	2f4 <_start-0x7d0c>
 2e0:	2c000000 	stccs	0, cr0, [r0], {-0}
 2e4:	b4000082 	strlt	r0, [r0], #-130	; 0xffffff7e
 2e8:	52000000 	andpl	r0, r0, #0
 2ec:	02000002 	andeq	r0, r0, #2
 2f0:	04cc0801 	strbeq	r0, [ip], #2049	; 0x801
 2f4:	02020000 	andeq	r0, r2, #0
 2f8:	0004fe05 	andeq	pc, r4, r5, lsl #28
 2fc:	05040300 	streq	r0, [r4, #-768]	; 0xfffffd00
 300:	00746e69 	rsbseq	r6, r4, r9, ror #28
 304:	00003304 	andeq	r3, r0, r4, lsl #6
 308:	08010200 	stmdaeq	r1, {r9}
 30c:	000004c3 	andeq	r0, r0, r3, asr #9
 310:	d1070202 	tstle	r7, r2, lsl #4
 314:	05000004 	streq	r0, [r0, #-4]
 318:	00000513 	andeq	r0, r0, r3, lsl r5
 31c:	5e070903 	vmlapl.f16	s0, s14, s6	; <UNPREDICTABLE>
 320:	06000000 	streq	r0, [r0], -r0
 324:	0000004d 	andeq	r0, r0, sp, asr #32
 328:	d2070402 	andle	r0, r7, #33554432	; 0x2000000
 32c:	0700000a 	streq	r0, [r0, -sl]
 330:	00000470 	andeq	r0, r0, r0, ror r4
 334:	591a0602 	ldmdbpl	sl, {r1, r9, sl}
 338:	05000000 	streq	r0, [r0, #-0]
 33c:	0084b403 	addeq	fp, r4, r3, lsl #8
 340:	04a30700 	strteq	r0, [r3], #1792	; 0x700
 344:	08020000 	stmdaeq	r2, {}	; <UNPREDICTABLE>
 348:	0000591a 	andeq	r5, r0, sl, lsl r9
 34c:	b8030500 	stmdalt	r3, {r8, sl}
 350:	07000084 	streq	r0, [r0, -r4, lsl #1]
 354:	000004b5 			; <UNDEFINED> instruction: 0x000004b5
 358:	591a0a02 	ldmdbpl	sl, {r1, r9, fp}
 35c:	05000000 	streq	r0, [r0, #-0]
 360:	0084bc03 	addeq	fp, r4, r3, lsl #24
 364:	04900700 	ldreq	r0, [r0], #1792	; 0x700
 368:	0c020000 	stceq	0, cr0, [r2], {-0}
 36c:	0000591a 	andeq	r5, r0, sl, lsl r9
 370:	c0030500 	andgt	r0, r3, r0, lsl #10
 374:	08000084 	stmdaeq	r0, {r2, r7}
 378:	000005f5 	strdeq	r0, [r0], -r5
 37c:	00330405 	eorseq	r0, r3, r5, lsl #8
 380:	0e020000 	cdpeq	0, 0, cr0, cr2, cr0, {0}
 384:	0000d20c 	andeq	sp, r0, ip, lsl #4
 388:	04ef0900 	strbteq	r0, [pc], #2304	; 390 <_start-0x7c70>
 38c:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
 390:	00000508 	andeq	r0, r0, r8, lsl #10
 394:	04e40901 	strbteq	r0, [r4], #2305	; 0x901
 398:	00020000 	andeq	r0, r2, r0
 39c:	8b020102 	blhi	807ac <__bss_end+0x782b8>
 3a0:	0a000004 	beq	3b8 <_start-0x7c48>
 3a4:	00000a66 	andeq	r0, r0, r6, ror #20
 3a8:	33050601 	movwcc	r0, #22017	; 0x5601
 3ac:	2c000000 	stccs	0, cr0, [r0], {-0}
 3b0:	b4000082 	strlt	r0, [r0], #-130	; 0xffffff7e
 3b4:	01000000 	mrseq	r0, (UNDEF: 0)
 3b8:	00013b9c 	muleq	r1, ip, fp
 3bc:	04f90b00 	ldrbteq	r0, [r9], #2816	; 0xb00
 3c0:	06010000 	streq	r0, [r1], -r0
 3c4:	0000330e 	andeq	r3, r0, lr, lsl #6
 3c8:	64910200 	ldrvs	r0, [r1], #512	; 0x200
 3cc:	0004860b 	andeq	r8, r4, fp, lsl #12
 3d0:	1b060100 	blne	1807d8 <__bss_end+0x1782e4>
 3d4:	0000013b 	andeq	r0, r0, fp, lsr r1
 3d8:	0c609102 	stfeqp	f1, [r0], #-8
 3dc:	08010069 	stmdaeq	r1, {r0, r3, r5, r6}
 3e0:	00003a0f 	andeq	r3, r0, pc, lsl #20
 3e4:	70910200 	addsvc	r0, r1, r0, lsl #4
 3e8:	0100660c 	tsteq	r0, ip, lsl #12
 3ec:	004d0e0a 	subeq	r0, sp, sl, lsl #28
 3f0:	91020000 	mrsls	r0, (UNDEF: 2)
 3f4:	03fd0d74 	mvnseq	r0, #116, 26	; 0x1d00
 3f8:	0d010000 	stceq	0, cr0, [r1, #-0]
 3fc:	0001470a 	andeq	r4, r1, sl, lsl #14
 400:	6c910200 	lfmvs	f0, 4, [r1], {0}
 404:	41040e00 	tstmi	r4, r0, lsl #28
 408:	0e000001 	cdpeq	0, 0, cr0, cr0, cr1, {0}
 40c:	00002504 	andeq	r2, r0, r4, lsl #10
 410:	00250f00 	eoreq	r0, r5, r0, lsl #30
 414:	5e100000 	cdppl	0, 1, cr0, cr0, cr0, {0}
 418:	01000000 	mrseq	r0, (UNDEF: 0)
 41c:	02f90000 	rscseq	r0, r9, #0
 420:	00040000 	andeq	r0, r4, r0
 424:	000002a8 	andeq	r0, r0, r8, lsr #5
 428:	066a0104 	strbteq	r0, [sl], -r4, lsl #2
 42c:	3f040000 	svccc	0x00040000
 430:	5d000007 	stcpl	0, cr0, [r0, #-28]	; 0xffffffe4
 434:	e0000005 	and	r0, r0, r5
 438:	d4000082 	strle	r0, [r0], #-130	; 0xffffff7e
 43c:	0c000001 	stceq	0, cr0, [r0], {1}
 440:	02000004 	andeq	r0, r0, #4
 444:	04cc0801 	strbeq	r0, [ip], #2049	; 0x801
 448:	25030000 	strcs	r0, [r3, #-0]
 44c:	02000000 	andeq	r0, r0, #0
 450:	04fe0502 	ldrbteq	r0, [lr], #1282	; 0x502
 454:	04040000 	streq	r0, [r4], #-0
 458:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
 45c:	08010200 	stmdaeq	r1, {r9}
 460:	000004c3 	andeq	r0, r0, r3, asr #9
 464:	d1070202 	tstle	r7, r2, lsl #4
 468:	05000004 	streq	r0, [r0, #-4]
 46c:	00000513 	andeq	r0, r0, r3, lsl r5
 470:	5e070904 	vmlapl.f16	s0, s14, s8	; <UNPREDICTABLE>
 474:	03000000 	movweq	r0, #0
 478:	0000004d 	andeq	r0, r0, sp, asr #32
 47c:	d2070402 	andle	r0, r7, #33554432	; 0x2000000
 480:	0600000a 	streq	r0, [r0], -sl
 484:	000005b7 			; <UNDEFINED> instruction: 0x000005b7
 488:	00380405 	eorseq	r0, r8, r5, lsl #8
 48c:	4d030000 	stcmi	0, cr0, [r3, #-0]
 490:	0000840c 	andeq	r8, r0, ip, lsl #8
 494:	05ac0700 	streq	r0, [ip, #1792]!	; 0x700
 498:	07000000 	streq	r0, [r0, -r0]
 49c:	0000061a 	andeq	r0, r0, sl, lsl r6
 4a0:	70080001 	andvc	r0, r8, r1
 4a4:	02000004 	andeq	r0, r0, #4
 4a8:	00591a06 	subseq	r1, r9, r6, lsl #20
 4ac:	03050000 	movweq	r0, #20480	; 0x5000
 4b0:	000084d4 	ldrdeq	r8, [r0], -r4
 4b4:	0004a308 	andeq	sl, r4, r8, lsl #6
 4b8:	1a080200 	bne	200cc0 <__bss_end+0x1f87cc>
 4bc:	00000059 	andeq	r0, r0, r9, asr r0
 4c0:	84d80305 	ldrbhi	r0, [r8], #773	; 0x305
 4c4:	b5080000 	strlt	r0, [r8, #-0]
 4c8:	02000004 	andeq	r0, r0, #4
 4cc:	00591a0a 	subseq	r1, r9, sl, lsl #20
 4d0:	03050000 	movweq	r0, #20480	; 0x5000
 4d4:	000084dc 	ldrdeq	r8, [r0], -ip
 4d8:	00049008 	andeq	r9, r4, r8
 4dc:	1a0c0200 	bne	300ce4 <__bss_end+0x2f87f0>
 4e0:	00000059 	andeq	r0, r0, r9, asr r0
 4e4:	84e00305 	strbthi	r0, [r0], #773	; 0x305
 4e8:	f5060000 			; <UNDEFINED> instruction: 0xf5060000
 4ec:	05000005 	streq	r0, [r0, #-5]
 4f0:	00003804 	andeq	r3, r0, r4, lsl #16
 4f4:	0c0e0200 	sfmeq	f0, 4, [lr], {-0}
 4f8:	000000f1 	strdeq	r0, [r0], -r1
 4fc:	0004ef07 	andeq	lr, r4, r7, lsl #30
 500:	08070000 	stmdaeq	r7, {}	; <UNPREDICTABLE>
 504:	01000005 	tsteq	r0, r5
 508:	0004e407 	andeq	lr, r4, r7, lsl #8
 50c:	02000200 	andeq	r0, r0, #0, 4
 510:	048b0201 	streq	r0, [fp], #513	; 0x201
 514:	04090000 	streq	r0, [r9], #-0
 518:	0000002c 	andeq	r0, r0, ip, lsr #32
 51c:	00064a0a 	andeq	r4, r6, sl, lsl #20
 520:	0a440100 	beq	1100928 <__bss_end+0x10f8434>
 524:	00000625 	andeq	r0, r0, r5, lsr #12
 528:	0000004d 	andeq	r0, r0, sp, asr #32
 52c:	00008464 	andeq	r8, r0, r4, ror #8
 530:	00000050 	andeq	r0, r0, r0, asr r0
 534:	01599c01 	cmpeq	r9, r1, lsl #24
 538:	d60b0000 	strle	r0, [fp], -r0
 53c:	01000005 	tsteq	r0, r5
 540:	004d1944 	subeq	r1, sp, r4, asr #18
 544:	91020000 	mrsls	r0, (UNDEF: 2)
 548:	06050b6c 	streq	r0, [r5], -ip, ror #22
 54c:	44010000 	strmi	r0, [r1], #-0
 550:	00006530 	andeq	r6, r0, r0, lsr r5
 554:	68910200 	ldmvs	r1, {r9}
 558:	00065b0b 	andeq	r5, r6, fp, lsl #22
 55c:	41440100 	mrsmi	r0, (UNDEF: 84)
 560:	00000159 	andeq	r0, r0, r9, asr r1
 564:	0c649102 	stfeqp	f1, [r4], #-8
 568:	00000722 	andeq	r0, r0, r2, lsr #14
 56c:	4d0e4601 	stcmi	6, cr4, [lr, #-4]
 570:	02000000 	andeq	r0, r0, #0
 574:	0d007491 	cfstrseq	mvf7, [r0, #-580]	; 0xfffffdbc
 578:	051c0e04 	ldreq	r0, [ip, #-3588]	; 0xfffff1fc
 57c:	3e010000 	cdpcc	0, 0, cr0, cr1, cr0, {0}
 580:	00073506 	andeq	r3, r7, r6, lsl #10
 584:	00843800 	addeq	r3, r4, r0, lsl #16
 588:	00002c00 	andeq	r2, r0, r0, lsl #24
 58c:	859c0100 	ldrhi	r0, [ip, #256]	; 0x100
 590:	0b000001 	bleq	59c <_start-0x7a64>
 594:	000005d6 	ldrdeq	r0, [r0], -r6
 598:	4d153e01 	ldcmi	14, cr3, [r5, #-4]
 59c:	02000000 	andeq	r0, r0, #0
 5a0:	0a007491 	beq	1d7ec <__bss_end+0x152f8>
 5a4:	0000052e 	andeq	r0, r0, lr, lsr #10
 5a8:	db0a3101 	blle	28c9b4 <__bss_end+0x2844c0>
 5ac:	4d000005 	stcmi	0, cr0, [r0, #-20]	; 0xffffffec
 5b0:	e8000000 	stmda	r0, {}	; <UNPREDICTABLE>
 5b4:	50000083 	andpl	r0, r0, r3, lsl #1
 5b8:	01000000 	mrseq	r0, (UNDEF: 0)
 5bc:	0001e09c 	muleq	r1, ip, r0
 5c0:	05d60b00 	ldrbeq	r0, [r6, #2816]	; 0xb00
 5c4:	31010000 	mrscc	r0, (UNDEF: 1)
 5c8:	00004d19 	andeq	r4, r0, r9, lsl sp
 5cc:	6c910200 	lfmvs	f0, 4, [r1], {0}
 5d0:	00071b0b 	andeq	r1, r7, fp, lsl #22
 5d4:	2b310100 	blcs	c409dc <__bss_end+0xc384e8>
 5d8:	000000f8 	strdeq	r0, [r0], -r8
 5dc:	0b689102 	bleq	1a249ec <__bss_end+0x1a1c4f8>
 5e0:	0000072a 	andeq	r0, r0, sl, lsr #14
 5e4:	4d3c3101 	ldfmis	f3, [ip, #-4]!
 5e8:	02000000 	andeq	r0, r0, #0
 5ec:	2f0c6491 	svccs	0x000c6491
 5f0:	01000007 	tsteq	r0, r7
 5f4:	004d0e33 	subeq	r0, sp, r3, lsr lr
 5f8:	91020000 	mrsls	r0, (UNDEF: 2)
 5fc:	0f0a0074 	svceq	0x000a0074
 600:	01000006 	tsteq	r0, r6
 604:	07a40a24 	streq	r0, [r4, r4, lsr #20]!
 608:	004d0000 	subeq	r0, sp, r0
 60c:	83980000 	orrshi	r0, r8, #0
 610:	00500000 	subseq	r0, r0, r0
 614:	9c010000 	stcls	0, cr0, [r1], {-0}
 618:	0000023b 	andeq	r0, r0, fp, lsr r2
 61c:	0005d60b 	andeq	sp, r5, fp, lsl #12
 620:	18240100 	stmdane	r4!, {r8}
 624:	0000004d 	andeq	r0, r0, sp, asr #32
 628:	0b6c9102 	bleq	1b24a38 <__bss_end+0x1b1c544>
 62c:	0000071b 	andeq	r0, r0, fp, lsl r7
 630:	412a2401 			; <UNDEFINED> instruction: 0x412a2401
 634:	02000002 	andeq	r0, r0, #2
 638:	2a0b6891 	bcs	2da884 <__bss_end+0x2d2390>
 63c:	01000007 	tsteq	r0, r7
 640:	004d3b24 	subeq	r3, sp, r4, lsr #22
 644:	91020000 	mrsls	r0, (UNDEF: 2)
 648:	06140c64 	ldreq	r0, [r4], -r4, ror #24
 64c:	26010000 	strcs	r0, [r1], -r0
 650:	00004d0e 	andeq	r4, r0, lr, lsl #26
 654:	74910200 	ldrvc	r0, [r1], #512	; 0x200
 658:	25040900 	strcs	r0, [r4, #-2304]	; 0xfffff700
 65c:	03000000 	movweq	r0, #0
 660:	0000023b 	andeq	r0, r0, fp, lsr r2
 664:	00079f0a 	andeq	r9, r7, sl, lsl #30
 668:	0a180100 	beq	600a70 <__bss_end+0x5f857c>
 66c:	000005e9 	andeq	r0, r0, r9, ror #11
 670:	0000004d 	andeq	r0, r0, sp, asr #32
 674:	00008354 	andeq	r8, r0, r4, asr r3
 678:	00000044 	andeq	r0, r0, r4, asr #32
 67c:	02929c01 	addseq	r9, r2, #256	; 0x100
 680:	c80b0000 	stmdagt	fp, {}	; <UNPREDICTABLE>
 684:	01000005 	tsteq	r0, r5
 688:	00f81b18 	rscseq	r1, r8, r8, lsl fp
 68c:	91020000 	mrsls	r0, (UNDEF: 2)
 690:	05d10b6c 	ldrbeq	r0, [r1, #2924]	; 0xb6c
 694:	18010000 	stmdane	r1, {}	; <UNPREDICTABLE>
 698:	0000cc35 	andeq	ip, r0, r5, lsr ip
 69c:	68910200 	ldmvs	r1, {r9}
 6a0:	0005d60c 	andeq	sp, r5, ip, lsl #12
 6a4:	0e1a0100 	mufeqe	f0, f2, f0
 6a8:	0000004d 	andeq	r0, r0, sp, asr #32
 6ac:	00749102 	rsbseq	r9, r4, r2, lsl #2
 6b0:	0005220f 	andeq	r2, r5, pc, lsl #4
 6b4:	06130100 	ldreq	r0, [r3], -r0, lsl #2
 6b8:	00000542 	andeq	r0, r0, r2, asr #10
 6bc:	00008338 	andeq	r8, r0, r8, lsr r3
 6c0:	0000001c 	andeq	r0, r0, ip, lsl r0
 6c4:	530e9c01 	movwpl	r9, #60417	; 0xec01
 6c8:	01000005 	tsteq	r0, r5
 6cc:	0534060d 	ldreq	r0, [r4, #-1549]!	; 0xfffff9f3
 6d0:	830c0000 	movwhi	r0, #49152	; 0xc000
 6d4:	002c0000 	eoreq	r0, ip, r0
 6d8:	9c010000 	stcls	0, cr0, [r1], {-0}
 6dc:	000002d2 	ldrdeq	r0, [r0], -r2
 6e0:	0006610b 	andeq	r6, r6, fp, lsl #2
 6e4:	140d0100 	strne	r0, [sp], #-256	; 0xffffff00
 6e8:	00000038 	andeq	r0, r0, r8, lsr r0
 6ec:	00749102 	rsbseq	r9, r4, r2, lsl #2
 6f0:	00064310 	andeq	r4, r6, r0, lsl r3
 6f4:	0a030100 	beq	c0afc <__bss_end+0xb8608>
 6f8:	00000650 	andeq	r0, r0, r0, asr r6
 6fc:	0000004d 	andeq	r0, r0, sp, asr #32
 700:	000082e0 	andeq	r8, r0, r0, ror #5
 704:	0000002c 	andeq	r0, r0, ip, lsr #32
 708:	70119c01 	andsvc	r9, r1, r1, lsl #24
 70c:	01006469 	tsteq	r0, r9, ror #8
 710:	004d0e05 	subeq	r0, sp, r5, lsl #28
 714:	91020000 	mrsls	r0, (UNDEF: 2)
 718:	2a000074 	bcs	8f0 <_start-0x7710>
 71c:	04000003 	streq	r0, [r0], #-3
 720:	0003ce00 	andeq	ip, r3, r0, lsl #28
 724:	d0010400 	andle	r0, r1, r0, lsl #8
 728:	0c000008 	stceq	0, cr0, [r0], {8}
 72c:	00000a89 	andeq	r0, r0, r9, lsl #21
 730:	00000bca 	andeq	r0, r0, sl, asr #23
 734:	0000063a 	andeq	r0, r0, sl, lsr r6
 738:	69050402 	stmdbvs	r5, {r1, sl}
 73c:	0300746e 	movweq	r7, #1134	; 0x46e
 740:	0ad20704 	beq	ff482358 <__bss_end+0xff479e64>
 744:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
 748:	00030905 	andeq	r0, r3, r5, lsl #18
 74c:	04080300 	streq	r0, [r8], #-768	; 0xfffffd00
 750:	00000a7d 	andeq	r0, r0, sp, ror sl
 754:	c3080103 	movwgt	r0, #33027	; 0x8103
 758:	03000004 	movweq	r0, #4
 75c:	04c50601 	strbeq	r0, [r5], #1537	; 0x601
 760:	bd040000 	stclt	0, cr0, [r4, #-0]
 764:	0700000c 	streq	r0, [r0, -ip]
 768:	00003901 	andeq	r3, r0, r1, lsl #18
 76c:	06170100 	ldreq	r0, [r7], -r0, lsl #2
 770:	000001d4 	ldrdeq	r0, [r0], -r4
 774:	0007df05 	andeq	sp, r7, r5, lsl #30
 778:	6c050000 	stcvs	0, cr0, [r5], {-0}
 77c:	0100000d 	tsteq	r0, sp
 780:	0009b205 	andeq	fp, r9, r5, lsl #4
 784:	70050200 	andvc	r0, r5, r0, lsl #4
 788:	0300000a 	movweq	r0, #10
 78c:	000cd605 	andeq	sp, ip, r5, lsl #12
 790:	7c050400 	cfstrsvc	mvf0, [r5], {-0}
 794:	0500000d 	streq	r0, [r0, #-13]
 798:	000cec05 	andeq	lr, ip, r5, lsl #24
 79c:	b9050600 	stmdblt	r5, {r9, sl}
 7a0:	0700000a 	streq	r0, [r0, -sl]
 7a4:	000c6705 	andeq	r6, ip, r5, lsl #14
 7a8:	75050800 	strvc	r0, [r5, #-2048]	; 0xfffff800
 7ac:	0900000c 	stmdbeq	r0, {r2, r3}
 7b0:	000c8305 	andeq	r8, ip, r5, lsl #6
 7b4:	22050a00 	andcs	r0, r5, #0, 20
 7b8:	0b00000b 	bleq	7ec <_start-0x7814>
 7bc:	000b1205 	andeq	r1, fp, r5, lsl #4
 7c0:	fb050c00 	blx	1437ca <__bss_end+0x13b2d6>
 7c4:	0d000007 	stceq	0, cr0, [r0, #-28]	; 0xffffffe4
 7c8:	00081405 	andeq	r1, r8, r5, lsl #8
 7cc:	03050e00 	movweq	r0, #24064	; 0x5e00
 7d0:	0f00000b 	svceq	0x0000000b
 7d4:	000d2f05 	andeq	r2, sp, r5, lsl #30
 7d8:	ac051000 	stcge	0, cr1, [r5], {-0}
 7dc:	1100000c 	tstne	r0, ip
 7e0:	000d2005 	andeq	r2, sp, r5
 7e4:	c1051200 	mrsgt	r1, SP_usr
 7e8:	13000008 	movwne	r0, #8
 7ec:	00083e05 	andeq	r3, r8, r5, lsl #28
 7f0:	08051400 	stmdaeq	r5, {sl, ip}
 7f4:	15000008 	strne	r0, [r0, #-8]
 7f8:	000ba105 	andeq	sl, fp, r5, lsl #2
 7fc:	75051600 	strvc	r1, [r5, #-1536]	; 0xfffffa00
 800:	17000008 	strne	r0, [r0, -r8]
 804:	0007b005 	andeq	fp, r7, r5
 808:	12051800 	andne	r1, r5, #0, 16
 80c:	1900000d 	stmdbne	r0, {r0, r2, r3}
 810:	000adf05 	andeq	sp, sl, r5, lsl #30
 814:	b9051a00 	stmdblt	r5, {r9, fp, ip}
 818:	1b00000b 	blne	84c <_start-0x77b4>
 81c:	00084905 	andeq	r4, r8, r5, lsl #18
 820:	55051c00 	strpl	r1, [r5, #-3072]	; 0xfffff400
 824:	1d00000a 	stcne	0, cr0, [r0, #-40]	; 0xffffffd8
 828:	0009a405 	andeq	sl, r9, r5, lsl #8
 82c:	9e051e00 	cdpls	14, 0, cr1, cr5, cr0, {0}
 830:	1f00000c 	svcne	0x0000000c
 834:	000cfa05 	andeq	pc, ip, r5, lsl #20
 838:	3b052000 	blcc	148840 <__bss_end+0x14034c>
 83c:	2100000d 	tstcs	r0, sp
 840:	000d4905 	andeq	r4, sp, r5, lsl #18
 844:	f6052200 			; <UNDEFINED> instruction: 0xf6052200
 848:	2300000a 	movwcs	r0, #10
 84c:	000a1905 	andeq	r1, sl, r5, lsl #18
 850:	58052400 	stmdapl	r5, {sl, sp}
 854:	25000008 	strcs	r0, [r0, #-8]
 858:	000aac05 	andeq	sl, sl, r5, lsl #24
 85c:	be052600 	cfmadd32lt	mvax0, mvfx2, mvfx5, mvfx0
 860:	27000009 	strcs	r0, [r0, -r9]
 864:	000cc905 	andeq	ip, ip, r5, lsl #18
 868:	ce052800 	cdpgt	8, 0, cr2, cr5, cr0, {0}
 86c:	29000009 	stmdbcs	r0, {r0, r3}
 870:	0009dd05 	andeq	sp, r9, r5, lsl #26
 874:	ec052a00 			; <UNDEFINED> instruction: 0xec052a00
 878:	2b000009 	blcs	8a4 <_start-0x775c>
 87c:	0009fb05 	andeq	pc, r9, r5, lsl #22
 880:	89052c00 	stmdbhi	r5, {sl, fp, sp}
 884:	2d000009 	stccs	0, cr0, [r0, #-36]	; 0xffffffdc
 888:	000a0a05 	andeq	r0, sl, r5, lsl #20
 88c:	58052e00 	stmdapl	r5, {r9, sl, fp, sp}
 890:	2f00000c 	svccs	0x0000000c
 894:	000a2805 	andeq	r2, sl, r5, lsl #16
 898:	37053000 	strcc	r3, [r5, -r0]
 89c:	3100000a 	tstcc	r0, sl
 8a0:	0007e905 	andeq	lr, r7, r5, lsl #18
 8a4:	41053200 	mrsmi	r3, SP_usr
 8a8:	3300000b 	movwcc	r0, #11
 8ac:	000b5105 	andeq	r5, fp, r5, lsl #2
 8b0:	61053400 	tstvs	r5, r0, lsl #8
 8b4:	3500000b 	strcc	r0, [r0, #-11]
 8b8:	00097705 	andeq	r7, r9, r5, lsl #14
 8bc:	71053600 	tstvc	r5, r0, lsl #12
 8c0:	3700000b 	strcc	r0, [r0, -fp]
 8c4:	000b8105 	andeq	r8, fp, r5, lsl #2
 8c8:	91053800 	tstls	r5, r0, lsl #16
 8cc:	3900000b 	stmdbcc	r0, {r0, r1, r3}
 8d0:	00086805 	andeq	r6, r8, r5, lsl #16
 8d4:	21053a00 	tstcs	r5, r0, lsl #20
 8d8:	3b000008 	blcc	900 <_start-0x7700>
 8dc:	000a4605 	andeq	r4, sl, r5, lsl #12
 8e0:	c0053c00 	andgt	r3, r5, r0, lsl #24
 8e4:	3d000007 	stccc	0, cr0, [r0, #-28]	; 0xffffffe4
 8e8:	000bac05 	andeq	sl, fp, r5, lsl #24
 8ec:	06003e00 	streq	r3, [r0], -r0, lsl #28
 8f0:	000008a8 	andeq	r0, r0, r8, lsr #17
 8f4:	026b0102 	rsbeq	r0, fp, #-2147483648	; 0x80000000
 8f8:	0001ff08 	andeq	pc, r1, r8, lsl #30
 8fc:	0a6b0700 	beq	1ac2504 <__bss_end+0x1aba010>
 900:	70010000 	andvc	r0, r1, r0
 904:	00471402 	subeq	r1, r7, r2, lsl #8
 908:	07000000 	streq	r0, [r0, -r0]
 90c:	00000984 	andeq	r0, r0, r4, lsl #19
 910:	14027101 	strne	r7, [r2], #-257	; 0xfffffeff
 914:	00000047 	andeq	r0, r0, r7, asr #32
 918:	d4080001 	strle	r0, [r8], #-1
 91c:	09000001 	stmdbeq	r0, {r0}
 920:	000001ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
 924:	00000214 	andeq	r0, r0, r4, lsl r2
 928:	0000240a 	andeq	r2, r0, sl, lsl #8
 92c:	08001100 	stmdaeq	r0, {r8, ip}
 930:	00000204 	andeq	r0, r0, r4, lsl #4
 934:	000b2f0b 	andeq	r2, fp, fp, lsl #30
 938:	02740100 	rsbseq	r0, r4, #0, 2
 93c:	00021426 	andeq	r1, r2, r6, lsr #8
 940:	3d3a2400 	cfldrscc	mvf2, [sl, #-0]
 944:	3d0f3d0a 	stccc	13, cr3, [pc, #-40]	; 924 <_start-0x76dc>
 948:	3d323d24 	ldccc	13, cr3, [r2, #-144]!	; 0xffffff70
 94c:	3d053d02 	stccc	13, cr3, [r5, #-8]
 950:	3d0d3d13 	stccc	13, cr3, [sp, #-76]	; 0xffffffb4
 954:	3d233d0c 	stccc	13, cr3, [r3, #-48]!	; 0xffffffd0
 958:	3d263d11 	stccc	13, cr3, [r6, #-68]!	; 0xffffffbc
 95c:	3d173d01 	ldccc	13, cr3, [r7, #-4]
 960:	3d093d08 	stccc	13, cr3, [r9, #-32]	; 0xffffffe0
 964:	02030000 	andeq	r0, r3, #0
 968:	0004d107 	andeq	sp, r4, r7, lsl #2
 96c:	08010300 	stmdaeq	r1, {r8, r9}
 970:	000004cc 	andeq	r0, r0, ip, asr #9
 974:	59040d0c 	stmdbpl	r4, {r2, r3, r8, sl, fp}
 978:	0e000002 	cdpeq	0, 0, cr0, cr0, cr2, {0}
 97c:	00000d57 	andeq	r0, r0, r7, asr sp
 980:	00390107 	eorseq	r0, r9, r7, lsl #2
 984:	f7020000 			; <UNDEFINED> instruction: 0xf7020000
 988:	029e0604 	addseq	r0, lr, #4, 12	; 0x400000
 98c:	82050000 	andhi	r0, r5, #0
 990:	00000008 	andeq	r0, r0, r8
 994:	00088d05 	andeq	r8, r8, r5, lsl #26
 998:	9f050100 	svcls	0x00050100
 99c:	02000008 	andeq	r0, r0, #8
 9a0:	0008b905 	andeq	fp, r8, r5, lsl #18
 9a4:	91050300 	mrsls	r0, SP_abt
 9a8:	0400000c 	streq	r0, [r0], #-12
 9ac:	00099805 	andeq	r9, r9, r5, lsl #16
 9b0:	4a050500 	bmi	141db8 <__bss_end+0x1398c4>
 9b4:	0600000c 	streq	r0, [r0], -ip
 9b8:	05020300 	streq	r0, [r2, #-768]	; 0xfffffd00
 9bc:	000004fe 	strdeq	r0, [r0], -lr
 9c0:	c8070803 	stmdagt	r7, {r0, r1, fp}
 9c4:	0300000a 	movweq	r0, #10
 9c8:	07d90404 	ldrbeq	r0, [r9, r4, lsl #8]
 9cc:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
 9d0:	0007d103 	andeq	sp, r7, r3, lsl #2
 9d4:	04080300 	streq	r0, [r8], #-768	; 0xfffffd00
 9d8:	00000a82 	andeq	r0, r0, r2, lsl #21
 9dc:	3b031003 	blcc	c49f0 <__bss_end+0xbc4fc>
 9e0:	0f00000c 	svceq	0x0000000c
 9e4:	00000c32 	andeq	r0, r0, r2, lsr ip
 9e8:	5a102a03 	bpl	40b1fc <__bss_end+0x402d08>
 9ec:	09000002 	stmdbeq	r0, {r1}
 9f0:	000002c8 	andeq	r0, r0, r8, asr #5
 9f4:	000002df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
 9f8:	d2110010 	andsle	r0, r1, #16
 9fc:	03000003 	movweq	r0, #3
 a00:	02d4112f 	sbcseq	r1, r4, #-1073741813	; 0xc000000b
 a04:	68110000 	ldmdavs	r1, {}	; <UNPREDICTABLE>
 a08:	03000002 	movweq	r0, #2
 a0c:	02d41130 	sbcseq	r1, r4, #48, 2
 a10:	c8090000 	stmdagt	r9, {}	; <UNPREDICTABLE>
 a14:	07000002 	streq	r0, [r0, -r2]
 a18:	0a000003 	beq	a2c <_start-0x75d4>
 a1c:	00000024 	andeq	r0, r0, r4, lsr #32
 a20:	df120001 	svcle	0x00120001
 a24:	04000002 	streq	r0, [r0], #-2
 a28:	f70a0933 			; <UNDEFINED> instruction: 0xf70a0933
 a2c:	05000002 	streq	r0, [r0, #-2]
 a30:	0084e403 	addeq	lr, r4, r3, lsl #8
 a34:	02eb1200 	rsceq	r1, fp, #0, 4
 a38:	34040000 	strcc	r0, [r4], #-0
 a3c:	02f70a09 	rscseq	r0, r7, #36864	; 0x9000
 a40:	03050000 	movweq	r0, #20480	; 0x5000
 a44:	000084e4 	andeq	r8, r0, r4, ror #9
	...

Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
   0:	10001101 	andne	r1, r0, r1, lsl #2
   4:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
   8:	1b0e0301 	blne	380c14 <__bss_end+0x378720>
   c:	130e250e 	movwne	r2, #58638	; 0xe50e
  10:	00000005 	andeq	r0, r0, r5
  14:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
  18:	030b130e 	movweq	r1, #45838	; 0xb30e
  1c:	110e1b0e 	tstne	lr, lr, lsl #22
  20:	10061201 	andne	r1, r6, r1, lsl #4
  24:	02000017 	andeq	r0, r0, #23
  28:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  2c:	0b3b0b3a 	bleq	ec2d1c <__bss_end+0xeba828>
  30:	13490b39 	movtne	r0, #39737	; 0x9b39
  34:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
  38:	24030000 	strcs	r0, [r3], #-0
  3c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
  40:	000e030b 	andeq	r0, lr, fp, lsl #6
  44:	012e0400 			; <UNDEFINED> instruction: 0x012e0400
  48:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
  4c:	0b3b0b3a 	bleq	ec2d3c <__bss_end+0xeba848>
  50:	01110b39 	tsteq	r1, r9, lsr fp
  54:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
  58:	01194296 			; <UNDEFINED> instruction: 0x01194296
  5c:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
  60:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  64:	0b3b0b3a 	bleq	ec2d54 <__bss_end+0xeba860>
  68:	13490b39 	movtne	r0, #39737	; 0x9b39
  6c:	00001802 	andeq	r1, r0, r2, lsl #16
  70:	0b002406 	bleq	9090 <__bss_end+0xb9c>
  74:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
  78:	07000008 	streq	r0, [r0, -r8]
  7c:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
  80:	0b3a0e03 	bleq	e83894 <__bss_end+0xe7b3a0>
  84:	0b390b3b 	bleq	e42d78 <__bss_end+0xe3a884>
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
  b4:	3a0e0300 	bcc	380cbc <__bss_end+0x3787c8>
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
  e4:	0b3e0b0b 	bleq	f82d18 <__bss_end+0xf7a824>
  e8:	00000e03 	andeq	r0, r0, r3, lsl #28
  ec:	03003408 	movweq	r3, #1032	; 0x408
  f0:	3b0b3a0e 	blcc	2ce930 <__bss_end+0x2c643c>
  f4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
  f8:	3c193f13 	ldccc	15, cr3, [r9], {19}
  fc:	09000019 	stmdbeq	r0, {r0, r3, r4}
 100:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 104:	0b3a0e03 	bleq	e83918 <__bss_end+0xe7b424>
 108:	0b390b3b 	bleq	e42dfc <__bss_end+0xe3a908>
 10c:	01111349 	tsteq	r1, r9, asr #6
 110:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 114:	01194296 			; <UNDEFINED> instruction: 0x01194296
 118:	0a000013 	beq	16c <_start-0x7e94>
 11c:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 120:	0b3b0b3a 	bleq	ec2e10 <__bss_end+0xeba91c>
 124:	13490b39 	movtne	r0, #39737	; 0x9b39
 128:	00001802 	andeq	r1, r0, r2, lsl #16
 12c:	0b00240b 	bleq	9160 <__bss_end+0xc6c>
 130:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 134:	0c000008 	stceq	0, cr0, [r0], {8}
 138:	193f002e 	ldmdbne	pc!, {r1, r2, r3, r5}	; <UNPREDICTABLE>
 13c:	0b3a0e03 	bleq	e83950 <__bss_end+0xe7b45c>
 140:	0b390b3b 	bleq	e42e34 <__bss_end+0xe3a940>
 144:	06120111 			; <UNDEFINED> instruction: 0x06120111
 148:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 14c:	0d000019 	stceq	0, cr0, [r0, #-100]	; 0xffffff9c
 150:	0e030139 	mcreq	1, 0, r0, cr3, cr9, {1}
 154:	0b3b0b3a 	bleq	ec2e44 <__bss_end+0xeba950>
 158:	00001301 	andeq	r1, r0, r1, lsl #6
 15c:	3f012e0e 	svccc	0x00012e0e
 160:	3a0e0319 	bcc	380dcc <__bss_end+0x3788d8>
 164:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 168:	01193c0b 	tsteq	r9, fp, lsl #24
 16c:	0f000013 	svceq	0x00000013
 170:	13490005 	movtne	r0, #36869	; 0x9005
 174:	2e100000 	cdpcs	0, 1, cr0, cr0, cr0, {0}
 178:	03193f01 	tsteq	r9, #1, 30
 17c:	3b0b3a0e 	blcc	2ce9bc <__bss_end+0x2c64c8>
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
 1a8:	3b0b3a08 	blcc	2ce9d0 <__bss_end+0x2c64dc>
 1ac:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 1b0:	00180213 	andseq	r0, r8, r3, lsl r2
 1b4:	012e1400 			; <UNDEFINED> instruction: 0x012e1400
 1b8:	01111347 	tsteq	r1, r7, asr #6
 1bc:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 1c0:	00194297 	mulseq	r9, r7, r2
 1c4:	11010000 	mrsne	r0, (UNDEF: 1)
 1c8:	130e2501 	movwne	r2, #58625	; 0xe501
 1cc:	1b0e030b 	blne	380e00 <__bss_end+0x37890c>
 1d0:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 1d4:	00171006 	andseq	r1, r7, r6
 1d8:	00240200 	eoreq	r0, r4, r0, lsl #4
 1dc:	0b3e0b0b 	bleq	f82e10 <__bss_end+0xf7a91c>
 1e0:	00000e03 	andeq	r0, r0, r3, lsl #28
 1e4:	0b002403 	bleq	91f8 <__bss_end+0xd04>
 1e8:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 1ec:	04000008 	streq	r0, [r0], #-8
 1f0:	13490035 	movtne	r0, #36917	; 0x9035
 1f4:	16050000 	strne	r0, [r5], -r0
 1f8:	3a0e0300 	bcc	380e00 <__bss_end+0x37890c>
 1fc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 200:	0013490b 	andseq	r4, r3, fp, lsl #18
 204:	00260600 	eoreq	r0, r6, r0, lsl #12
 208:	00001349 	andeq	r1, r0, r9, asr #6
 20c:	03003407 	movweq	r3, #1031	; 0x407
 210:	3b0b3a0e 	blcc	2cea50 <__bss_end+0x2c655c>
 214:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 218:	02196c13 	andseq	r6, r9, #4864	; 0x1300
 21c:	08000018 	stmdaeq	r0, {r3, r4}
 220:	0e030104 	adfeqs	f0, f3, f4
 224:	0b3e196d 	bleq	f867e0 <__bss_end+0xf7e2ec>
 228:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 22c:	0b3b0b3a 	bleq	ec2f1c <__bss_end+0xebaa28>
 230:	13010b39 	movwne	r0, #6969	; 0x1b39
 234:	28090000 	stmdacs	r9, {}	; <UNPREDICTABLE>
 238:	1c0e0300 	stcne	3, cr0, [lr], {-0}
 23c:	0a00000b 	beq	270 <_start-0x7d90>
 240:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 244:	0b3a0e03 	bleq	e83a58 <__bss_end+0xe7b564>
 248:	0b390b3b 	bleq	e42f3c <__bss_end+0xe3aa48>
 24c:	01111349 	tsteq	r1, r9, asr #6
 250:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 254:	01194296 			; <UNDEFINED> instruction: 0x01194296
 258:	0b000013 	bleq	2ac <_start-0x7d54>
 25c:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
 260:	0b3b0b3a 	bleq	ec2f50 <__bss_end+0xebaa5c>
 264:	13490b39 	movtne	r0, #39737	; 0x9b39
 268:	00001802 	andeq	r1, r0, r2, lsl #16
 26c:	0300340c 	movweq	r3, #1036	; 0x40c
 270:	3b0b3a08 	blcc	2cea98 <__bss_end+0x2c65a4>
 274:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 278:	00180213 	andseq	r0, r8, r3, lsl r2
 27c:	00340d00 	eorseq	r0, r4, r0, lsl #26
 280:	0b3a0e03 	bleq	e83a94 <__bss_end+0xe7b5a0>
 284:	0b390b3b 	bleq	e42f78 <__bss_end+0xe3aa84>
 288:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 28c:	0f0e0000 	svceq	0x000e0000
 290:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 294:	0f000013 	svceq	0x00000013
 298:	13490101 	movtne	r0, #37121	; 0x9101
 29c:	21100000 	tstcs	r0, r0
 2a0:	2f134900 	svccs	0x00134900
 2a4:	0000000b 	andeq	r0, r0, fp
 2a8:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
 2ac:	030b130e 	movweq	r1, #45838	; 0xb30e
 2b0:	110e1b0e 	tstne	lr, lr, lsl #22
 2b4:	10061201 	andne	r1, r6, r1, lsl #4
 2b8:	02000017 	andeq	r0, r0, #23
 2bc:	0b0b0024 	bleq	2c0354 <__bss_end+0x2b7e60>
 2c0:	0e030b3e 	vmoveq.16	d3[0], r0
 2c4:	26030000 	strcs	r0, [r3], -r0
 2c8:	00134900 	andseq	r4, r3, r0, lsl #18
 2cc:	00240400 	eoreq	r0, r4, r0, lsl #8
 2d0:	0b3e0b0b 	bleq	f82f04 <__bss_end+0xf7aa10>
 2d4:	00000803 	andeq	r0, r0, r3, lsl #16
 2d8:	03001605 	movweq	r1, #1541	; 0x605
 2dc:	3b0b3a0e 	blcc	2ceb1c <__bss_end+0x2c6628>
 2e0:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 2e4:	06000013 			; <UNDEFINED> instruction: 0x06000013
 2e8:	0e030104 	adfeqs	f0, f3, f4
 2ec:	0b3e196d 	bleq	f868a8 <__bss_end+0xf7e3b4>
 2f0:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 2f4:	0b3b0b3a 	bleq	ec2fe4 <__bss_end+0xebaaf0>
 2f8:	13010b39 	movwne	r0, #6969	; 0x1b39
 2fc:	28070000 	stmdacs	r7, {}	; <UNPREDICTABLE>
 300:	1c0e0300 	stcne	3, cr0, [lr], {-0}
 304:	0800000b 	stmdaeq	r0, {r0, r1, r3}
 308:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 30c:	0b3b0b3a 	bleq	ec2ffc <__bss_end+0xebab08>
 310:	13490b39 	movtne	r0, #39737	; 0x9b39
 314:	1802196c 	stmdane	r2, {r2, r3, r5, r6, r8, fp, ip}
 318:	0f090000 	svceq	0x00090000
 31c:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 320:	0a000013 	beq	374 <_start-0x7c8c>
 324:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 328:	0b3a0e03 	bleq	e83b3c <__bss_end+0xe7b648>
 32c:	0b390b3b 	bleq	e43020 <__bss_end+0xe3ab2c>
 330:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 334:	06120111 			; <UNDEFINED> instruction: 0x06120111
 338:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 33c:	00130119 	andseq	r0, r3, r9, lsl r1
 340:	00050b00 	andeq	r0, r5, r0, lsl #22
 344:	0b3a0e03 	bleq	e83b58 <__bss_end+0xe7b664>
 348:	0b390b3b 	bleq	e4303c <__bss_end+0xe3ab48>
 34c:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 350:	340c0000 	strcc	r0, [ip], #-0
 354:	3a0e0300 	bcc	380f5c <__bss_end+0x378a68>
 358:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 35c:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 360:	0d000018 	stceq	0, cr0, [r0, #-96]	; 0xffffffa0
 364:	0b0b000f 	bleq	2c03a8 <__bss_end+0x2b7eb4>
 368:	2e0e0000 	cdpcs	0, 0, cr0, cr14, cr0, {0}
 36c:	03193f01 	tsteq	r9, #1, 30
 370:	3b0b3a0e 	blcc	2cebb0 <__bss_end+0x2c66bc>
 374:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 378:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 37c:	97184006 	ldrls	r4, [r8, -r6]
 380:	13011942 	movwne	r1, #6466	; 0x1942
 384:	2e0f0000 	cdpcs	0, 0, cr0, cr15, cr0, {0}
 388:	03193f00 	tsteq	r9, #0, 30
 38c:	3b0b3a0e 	blcc	2cebcc <__bss_end+0x2c66d8>
 390:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 394:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 398:	97184006 	ldrls	r4, [r8, -r6]
 39c:	00001942 	andeq	r1, r0, r2, asr #18
 3a0:	3f012e10 	svccc	0x00012e10
 3a4:	3a0e0319 	bcc	381010 <__bss_end+0x378b1c>
 3a8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 3ac:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 3b0:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 3b4:	97184006 	ldrls	r4, [r8, -r6]
 3b8:	00001942 	andeq	r1, r0, r2, asr #18
 3bc:	03003411 	movweq	r3, #1041	; 0x411
 3c0:	3b0b3a08 	blcc	2cebe8 <__bss_end+0x2c66f4>
 3c4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 3c8:	00180213 	andseq	r0, r8, r3, lsl r2
 3cc:	11010000 	mrsne	r0, (UNDEF: 1)
 3d0:	130e2501 	movwne	r2, #58625	; 0xe501
 3d4:	1b0e030b 	blne	381008 <__bss_end+0x378b14>
 3d8:	0017100e 	andseq	r1, r7, lr
 3dc:	00240200 	eoreq	r0, r4, r0, lsl #4
 3e0:	0b3e0b0b 	bleq	f83014 <__bss_end+0xf7ab20>
 3e4:	00000803 	andeq	r0, r0, r3, lsl #16
 3e8:	0b002403 	bleq	93fc <__bss_end+0xf08>
 3ec:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 3f0:	0400000e 	streq	r0, [r0], #-14
 3f4:	0e030104 	adfeqs	f0, f3, f4
 3f8:	0b0b0b3e 	bleq	2c30f8 <__bss_end+0x2bac04>
 3fc:	0b3a1349 	bleq	e85128 <__bss_end+0xe7cc34>
 400:	0b390b3b 	bleq	e430f4 <__bss_end+0xe3ac00>
 404:	00001301 	andeq	r1, r0, r1, lsl #6
 408:	03002805 	movweq	r2, #2053	; 0x805
 40c:	000b1c0e 	andeq	r1, fp, lr, lsl #24
 410:	01130600 	tsteq	r3, r0, lsl #12
 414:	0b0b0e03 	bleq	2c3c28 <__bss_end+0x2bb734>
 418:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 41c:	13010b39 	movwne	r0, #6969	; 0x1b39
 420:	0d070000 	stceq	0, cr0, [r7, #-0]
 424:	3a0e0300 	bcc	38102c <__bss_end+0x378b38>
 428:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 42c:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 430:	0800000b 	stmdaeq	r0, {r0, r1, r3}
 434:	13490026 	movtne	r0, #36902	; 0x9026
 438:	01090000 	mrseq	r0, (UNDEF: 9)
 43c:	01134901 	tsteq	r3, r1, lsl #18
 440:	0a000013 	beq	494 <_start-0x7b6c>
 444:	13490021 	movtne	r0, #36897	; 0x9021
 448:	00000b2f 	andeq	r0, r0, pc, lsr #22
 44c:	0300340b 	movweq	r3, #1035	; 0x40b
 450:	3b0b3a0e 	blcc	2cec90 <__bss_end+0x2c679c>
 454:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
 458:	000a1c13 	andeq	r1, sl, r3, lsl ip
 45c:	00150c00 	andseq	r0, r5, r0, lsl #24
 460:	00001927 	andeq	r1, r0, r7, lsr #18
 464:	0b000f0d 	bleq	40a0 <_start-0x3f60>
 468:	0013490b 	andseq	r4, r3, fp, lsl #18
 46c:	01040e00 	tsteq	r4, r0, lsl #28
 470:	0b3e0e03 	bleq	f83c84 <__bss_end+0xf7b790>
 474:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 478:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 47c:	13010b39 	movwne	r0, #6969	; 0x1b39
 480:	160f0000 	strne	r0, [pc], -r0
 484:	3a0e0300 	bcc	38108c <__bss_end+0x378b98>
 488:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 48c:	0013490b 	andseq	r4, r3, fp, lsl #18
 490:	00211000 	eoreq	r1, r1, r0
 494:	34110000 	ldrcc	r0, [r1], #-0
 498:	3a0e0300 	bcc	3810a0 <__bss_end+0x378bac>
 49c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 4a0:	3f13490b 	svccc	0x0013490b
 4a4:	00193c19 	andseq	r3, r9, r9, lsl ip
 4a8:	00341200 	eorseq	r1, r4, r0, lsl #4
 4ac:	0b3a1347 	bleq	e851d0 <__bss_end+0xe7ccdc>
 4b0:	0b39053b 	bleq	e419a4 <__bss_end+0xe394b0>
 4b4:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 4b8:	Address 0x00000000000004b8 is out of bounds.


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
  74:	000000b4 	strheq	r0, [r0], -r4
	...
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	041e0002 	ldreq	r0, [lr], #-2
  88:	00040000 	andeq	r0, r4, r0
  8c:	00000000 	andeq	r0, r0, r0
  90:	000082e0 	andeq	r8, r0, r0, ror #5
  94:	000001d4 	ldrdeq	r0, [r0], -r4
	...
  a0:	00000014 	andeq	r0, r0, r4, lsl r0
  a4:	071b0002 	ldreq	r0, [fp, -r2]
  a8:	00040000 	andeq	r0, r4, r0
	...

Disassembly of section .debug_str:

00000000 <.debug_str>:
   0:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
   4:	552f632f 	strpl	r6, [pc, #-815]!	; fffffcdd <__bss_end+0xffff77e9>
   8:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
   c:	62754b2f 	rsbsvs	r4, r5, #48128	; 0xbc00
  10:	6f442f61 	svcvs	0x00442f61
  14:	656d7563 	strbvs	r7, [sp, #-1379]!	; 0xfffffa9d
  18:	2f73746e 	svccs	0x0073746e
  1c:	6f686353 	svcvs	0x00686353
  20:	5a2f6c6f 	bpl	bdb1e4 <__bss_end+0xbd2cf0>
  24:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; fffffe98 <__bss_end+0xffff79a4>
  28:	2f657461 	svccs	0x00657461
  2c:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
  30:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
  34:	2d36312f 	ldfcss	f3, [r6, #-188]!	; 0xffffff44
  38:	69676170 	stmdbvs	r7!, {r4, r5, r6, r8, sp, lr}^
  3c:	755f676e 	ldrbvc	r6, [pc, #-1902]	; fffff8d6 <__bss_end+0xffff73e2>
  40:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
  44:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
  48:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
  4c:	61707372 	cmnvs	r0, r2, ror r3
  50:	632f6563 			; <UNDEFINED> instruction: 0x632f6563
  54:	2e307472 	mrccs	4, 1, r7, cr0, cr2, {3}
  58:	6d2f0073 	stcvs	0, cr0, [pc, #-460]!	; fffffe94 <__bss_end+0xffff79a0>
  5c:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
  60:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
  64:	4b2f7372 	blmi	bdce34 <__bss_end+0xbd4940>
  68:	2f616275 	svccs	0x00616275
  6c:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
  70:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
  74:	63532f73 	cmpvs	r3, #460	; 0x1cc
  78:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; fffffee0 <__bss_end+0xffff79ec>
  7c:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
  80:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
  84:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
  88:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
  8c:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
  90:	61702d36 	cmnvs	r0, r6, lsr sp
  94:	676e6967 	strbvs	r6, [lr, -r7, ror #18]!
  98:	6573755f 	ldrbvs	r7, [r3, #-1375]!	; 0xfffffaa1
  9c:	61707372 	cmnvs	r0, r2, ror r3
  a0:	752f6563 	strvc	r6, [pc, #-1379]!	; fffffb45 <__bss_end+0xffff7651>
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
 13c:	2b6b7a36 	blcs	1adea1c <__bss_end+0x1ad6528>
 140:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
 144:	672d2067 	strvs	r2, [sp, -r7, rrx]!
 148:	304f2d20 	subcc	r2, pc, r0, lsr #26
 14c:	304f2d20 	subcc	r2, pc, r0, lsr #26
 150:	625f5f00 	subsvs	r5, pc, #0, 30
 154:	655f7373 	ldrbvs	r7, [pc, #-883]	; fffffde9 <__bss_end+0xffff78f5>
 158:	7200646e 	andvc	r6, r0, #1845493760	; 0x6e000000
 15c:	6c757365 	ldclvs	3, cr7, [r5], #-404	; 0xfffffe6c
 160:	6d2f0074 	stcvs	0, cr0, [pc, #-464]!	; ffffff98 <__bss_end+0xffff7aa4>
 164:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
 168:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
 16c:	4b2f7372 	blmi	bdcf3c <__bss_end+0xbd4a48>
 170:	2f616275 	svccs	0x00616275
 174:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
 178:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
 17c:	63532f73 	cmpvs	r3, #460	; 0x1cc
 180:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; ffffffe8 <__bss_end+0xffff7af4>
 184:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
 188:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
 18c:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 190:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
 194:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
 198:	61702d36 	cmnvs	r0, r6, lsr sp
 19c:	676e6967 	strbvs	r6, [lr, -r7, ror #18]!
 1a0:	6573755f 	ldrbvs	r7, [r3, #-1375]!	; 0xfffffaa1
 1a4:	61707372 	cmnvs	r0, r2, ror r3
 1a8:	752f6563 	strvc	r6, [pc, #-1379]!	; fffffc4d <__bss_end+0xffff7759>
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
 3fc:	73656d00 	cmnvc	r5, #0, 26
 400:	65676173 	strbvs	r6, [r7, #-371]!	; 0xfffffe8d
 404:	6e6d2f00 	cdpvs	15, 6, cr2, cr13, cr0, {0}
 408:	2f632f74 	svccs	0x00632f74
 40c:	72657355 	rsbvc	r7, r5, #1409286145	; 0x54000001
 410:	754b2f73 	strbvc	r2, [fp, #-3955]	; 0xfffff08d
 414:	442f6162 	strtmi	r6, [pc], #-354	; 41c <_start-0x7be4>
 418:	6d75636f 	ldclvs	3, cr6, [r5, #-444]!	; 0xfffffe44
 41c:	73746e65 	cmnvc	r4, #1616	; 0x650
 420:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
 424:	2f6c6f6f 	svccs	0x006c6f6f
 428:	6f72655a 	svcvs	0x0072655a
 42c:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
 430:	6178652f 	cmnvs	r8, pc, lsr #10
 434:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
 438:	36312f73 	shsub16cc	r2, r1, r3
 43c:	6761702d 	strbvs	r7, [r1, -sp, lsr #32]!
 440:	5f676e69 	svcpl	0x00676e69
 444:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
 448:	63617073 	cmnvs	r1, #115	; 0x73
 44c:	73752f65 	cmnvc	r5, #404	; 0x194
 450:	70737265 	rsbsvc	r7, r3, r5, ror #4
 454:	2f656361 	svccs	0x00656361
 458:	74736574 	ldrbtvc	r6, [r3], #-1396	; 0xfffffa8c
 45c:	6f72705f 	svcvs	0x0072705f
 460:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
 464:	6d2f315f 	stfvss	f3, [pc, #-380]!	; 2f0 <_start-0x7d10>
 468:	2e6e6961 	vnmulcs.f16	s13, s28, s3	; <UNPREDICTABLE>
 46c:	00707063 	rsbseq	r7, r0, r3, rrx
 470:	4678614d 	ldrbtmi	r6, [r8], -sp, asr #2
 474:	69724453 	ldmdbvs	r2!, {r0, r1, r4, r6, sl, lr}^
 478:	4e726576 	mrcmi	5, 3, r6, cr2, cr6, {3}
 47c:	4c656d61 	stclmi	13, cr6, [r5], #-388	; 0xfffffe7c
 480:	74676e65 	strbtvc	r6, [r7], #-3685	; 0xfffff19b
 484:	72610068 	rsbvc	r0, r1, #104	; 0x68
 488:	62007667 	andvs	r7, r0, #108003328	; 0x6700000
 48c:	006c6f6f 	rsbeq	r6, ip, pc, ror #30
 490:	69466f4e 	stmdbvs	r6, {r1, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
 494:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
 498:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
 49c:	76697244 	strbtvc	r7, [r9], -r4, asr #4
 4a0:	4d007265 	sfmmi	f7, 4, [r0, #-404]	; 0xfffffe6c
 4a4:	69467861 	stmdbvs	r6, {r0, r5, r6, fp, ip, sp, lr}^
 4a8:	616e656c 	cmnvs	lr, ip, ror #10
 4ac:	654c656d 	strbvs	r6, [ip, #-1389]	; 0xfffffa93
 4b0:	6874676e 	ldmdavs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}^
 4b4:	78614d00 	stmdavc	r1!, {r8, sl, fp, lr}^
 4b8:	68746150 	ldmdavs	r4!, {r4, r6, r8, sp, lr}^
 4bc:	676e654c 	strbvs	r6, [lr, -ip, asr #10]!
 4c0:	75006874 	strvc	r6, [r0, #-2164]	; 0xfffff78c
 4c4:	6769736e 	strbvs	r7, [r9, -lr, ror #6]!
 4c8:	2064656e 	rsbcs	r6, r4, lr, ror #10
 4cc:	72616863 	rsbvc	r6, r1, #6488064	; 0x630000
 4d0:	6f687300 	svcvs	0x00687300
 4d4:	75207472 	strvc	r7, [r0, #-1138]!	; 0xfffffb8e
 4d8:	6769736e 	strbvs	r7, [r9, -lr, ror #6]!
 4dc:	2064656e 	rsbcs	r6, r4, lr, ror #10
 4e0:	00746e69 	rsbseq	r6, r4, r9, ror #28
 4e4:	64616552 	strbtvs	r6, [r1], #-1362	; 0xfffffaae
 4e8:	6972575f 	ldmdbvs	r2!, {r0, r1, r2, r3, r4, r6, r8, r9, sl, ip, lr}^
 4ec:	52006574 	andpl	r6, r0, #116, 10	; 0x1d000000
 4f0:	5f646165 	svcpl	0x00646165
 4f4:	796c6e4f 	stmdbvc	ip!, {r0, r1, r2, r3, r6, r9, sl, fp, sp, lr}^
 4f8:	67726100 	ldrbvs	r6, [r2, -r0, lsl #2]!
 4fc:	68730063 	ldmdavs	r3!, {r0, r1, r5, r6}^
 500:	2074726f 	rsbscs	r7, r4, pc, ror #4
 504:	00746e69 	rsbseq	r6, r4, r9, ror #28
 508:	74697257 	strbtvc	r7, [r9], #-599	; 0xfffffda9
 50c:	6e4f5f65 	cdpvs	15, 4, cr5, cr15, cr5, {3}
 510:	7500796c 	strvc	r7, [r0, #-2412]	; 0xfffff694
 514:	33746e69 	cmncc	r4, #1680	; 0x690
 518:	00745f32 	rsbseq	r5, r4, r2, lsr pc
 51c:	736f6c63 	cmnvc	pc, #25344	; 0x6300
 520:	63730065 	cmnvs	r3, #101	; 0x65
 524:	5f646568 	svcpl	0x00646568
 528:	6c656979 			; <UNDEFINED> instruction: 0x6c656979
 52c:	72770064 	rsbsvc	r0, r7, #100	; 0x64
 530:	00657469 	rsbeq	r7, r5, r9, ror #8
 534:	74395a5f 	ldrtvc	r5, [r9], #-2655	; 0xfffff5a1
 538:	696d7265 	stmdbvs	sp!, {r0, r2, r5, r6, r9, ip, sp, lr}^
 53c:	6574616e 	ldrbvs	r6, [r4, #-366]!	; 0xfffffe92
 540:	5a5f0069 	bpl	17c06ec <__bss_end+0x17b81f8>
 544:	63733131 	cmnvs	r3, #1073741836	; 0x4000000c
 548:	5f646568 	svcpl	0x00646568
 54c:	6c656979 			; <UNDEFINED> instruction: 0x6c656979
 550:	74007664 	strvc	r7, [r0], #-1636	; 0xfffff99c
 554:	696d7265 	stmdbvs	sp!, {r0, r2, r5, r6, r9, ip, sp, lr}^
 558:	6574616e 	ldrbvs	r6, [r4, #-366]!	; 0xfffffe92
 55c:	6e6d2f00 	cdpvs	15, 6, cr2, cr13, cr0, {0}
 560:	2f632f74 	svccs	0x00632f74
 564:	72657355 	rsbvc	r7, r5, #1409286145	; 0x54000001
 568:	754b2f73 	strbvc	r2, [fp, #-3955]	; 0xfffff08d
 56c:	442f6162 	strtmi	r6, [pc], #-354	; 574 <_start-0x7a8c>
 570:	6d75636f 	ldclvs	3, cr6, [r5, #-444]!	; 0xfffffe44
 574:	73746e65 	cmnvc	r4, #1616	; 0x650
 578:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
 57c:	2f6c6f6f 	svccs	0x006c6f6f
 580:	6f72655a 	svcvs	0x0072655a
 584:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
 588:	6178652f 	cmnvs	r8, pc, lsr #10
 58c:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
 590:	36312f73 	shsub16cc	r2, r1, r3
 594:	6761702d 	strbvs	r7, [r1, -sp, lsr #32]!
 598:	5f676e69 	svcpl	0x00676e69
 59c:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
 5a0:	63617073 	cmnvs	r1, #115	; 0x73
 5a4:	75622f65 	strbvc	r2, [r2, #-3941]!	; 0xfffff09b
 5a8:	00646c69 	rsbeq	r6, r4, r9, ror #24
 5ac:	5f746547 	svcpl	0x00746547
 5b0:	61726150 	cmnvs	r2, r0, asr r1
 5b4:	4e00736d 	cdpmi	3, 0, cr7, cr0, cr13, {3}
 5b8:	74434f49 	strbvc	r4, [r3], #-3913	; 0xfffff0b7
 5bc:	704f5f6c 	subvc	r5, pc, ip, ror #30
 5c0:	74617265 	strbtvc	r7, [r1], #-613	; 0xfffffd9b
 5c4:	006e6f69 	rsbeq	r6, lr, r9, ror #30
 5c8:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
 5cc:	656d616e 	strbvs	r6, [sp, #-366]!	; 0xfffffe92
 5d0:	646f6d00 	strbtvs	r6, [pc], #-3328	; 5d8 <_start-0x7a28>
 5d4:	69660065 	stmdbvs	r6!, {r0, r2, r5, r6}^
 5d8:	5f00656c 	svcpl	0x0000656c
 5dc:	7277355a 	rsbsvc	r3, r7, #377487360	; 0x16800000
 5e0:	6a657469 	bvs	195d78c <__bss_end+0x1955298>
 5e4:	6a634b50 	bvs	18d332c <__bss_end+0x18cae38>
 5e8:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
 5ec:	6e65706f 	cdpvs	0, 6, cr7, cr5, cr15, {3}
 5f0:	31634b50 	cmncc	r3, r0, asr fp
 5f4:	69464e35 	stmdbvs	r6, {r0, r2, r4, r5, r9, sl, fp, lr}^
 5f8:	4f5f656c 	svcmi	0x005f656c
 5fc:	5f6e6570 	svcpl	0x006e6570
 600:	65646f4d 	strbvs	r6, [r4, #-3917]!	; 0xfffff0b3
 604:	65706f00 	ldrbvs	r6, [r0, #-3840]!	; 0xfffff100
 608:	69746172 	ldmdbvs	r4!, {r1, r4, r5, r6, r8, sp, lr}^
 60c:	72006e6f 	andvc	r6, r0, #1776	; 0x6f0
 610:	00646165 	rsbeq	r6, r4, r5, ror #2
 614:	756e6472 	strbvc	r6, [lr, #-1138]!	; 0xfffffb8e
 618:	6553006d 	ldrbvs	r0, [r3, #-109]	; 0xffffff93
 61c:	61505f74 	cmpvs	r0, r4, ror pc
 620:	736d6172 	cmnvc	sp, #-2147483620	; 0x8000001c
 624:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
 628:	74636f69 	strbtvc	r6, [r3], #-3945	; 0xfffff097
 62c:	36316a6c 	ldrtcc	r6, [r1], -ip, ror #20
 630:	434f494e 	movtmi	r4, #63822	; 0xf94e
 634:	4f5f6c74 	svcmi	0x005f6c74
 638:	61726570 	cmnvs	r2, r0, ror r5
 63c:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
 640:	67007650 	smlsdvs	r0, r0, r6, r7
 644:	69707465 	ldmdbvs	r0!, {r0, r2, r5, r6, sl, ip, sp, lr}^
 648:	6f690064 	svcvs	0x00690064
 64c:	006c7463 	rsbeq	r7, ip, r3, ror #8
 650:	67365a5f 			; <UNDEFINED> instruction: 0x67365a5f
 654:	69707465 	ldmdbvs	r0!, {r0, r2, r5, r6, sl, ip, sp, lr}^
 658:	70007664 	andvc	r7, r0, r4, ror #12
 65c:	6d617261 	sfmvs	f7, 2, [r1, #-388]!	; 0xfffffe7c
 660:	69786500 	ldmdbvs	r8!, {r8, sl, sp, lr}^
 664:	646f6374 	strbtvs	r6, [pc], #-884	; 66c <_start-0x7994>
 668:	4e470065 	cdpmi	0, 4, cr0, cr7, cr5, {3}
 66c:	2b432055 	blcs	10c87c8 <__bss_end+0x10c02d4>
 670:	2034312b 	eorscs	r3, r4, fp, lsr #2
 674:	332e3031 			; <UNDEFINED> instruction: 0x332e3031
 678:	3220312e 	eorcc	r3, r0, #-2147483637	; 0x8000000b
 67c:	30313230 	eorscc	r3, r1, r0, lsr r2
 680:	20313236 	eorscs	r3, r1, r6, lsr r2
 684:	6c657228 	sfmvs	f7, 2, [r5], #-160	; 0xffffff60
 688:	65736165 	ldrbvs	r6, [r3, #-357]!	; 0xfffffe9b
 68c:	6d2d2029 	stcvs	0, cr2, [sp, #-164]!	; 0xffffff5c
 690:	616f6c66 	cmnvs	pc, r6, ror #24
 694:	62612d74 	rsbvs	r2, r1, #116, 26	; 0x1d00
 698:	61683d69 	cmnvs	r8, r9, ror #26
 69c:	2d206472 	cfstrscs	mvf6, [r0, #-456]!	; 0xfffffe38
 6a0:	7570666d 	ldrbvc	r6, [r0, #-1645]!	; 0xfffff993
 6a4:	7066763d 	rsbvc	r7, r6, sp, lsr r6
 6a8:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
 6ac:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
 6b0:	6962612d 	stmdbvs	r2!, {r0, r2, r3, r5, r8, sp, lr}^
 6b4:	7261683d 	rsbvc	r6, r1, #3997696	; 0x3d0000
 6b8:	6d2d2064 	stcvs	0, cr2, [sp, #-400]!	; 0xfffffe70
 6bc:	3d757066 	ldclcc	0, cr7, [r5, #-408]!	; 0xfffffe68
 6c0:	20706676 	rsbscs	r6, r0, r6, ror r6
 6c4:	75746d2d 	ldrbvc	r6, [r4, #-3373]!	; 0xfffff2d3
 6c8:	613d656e 	teqvs	sp, lr, ror #10
 6cc:	31316d72 	teqcc	r1, r2, ror sp
 6d0:	7a6a3637 	bvc	1a8dfb4 <__bss_end+0x1a85ac0>
 6d4:	20732d66 	rsbscs	r2, r3, r6, ror #26
 6d8:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
 6dc:	6d2d206d 	stcvs	0, cr2, [sp, #-436]!	; 0xfffffe4c
 6e0:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
 6e4:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
 6e8:	6b7a3676 	blvs	1e8e0c8 <__bss_end+0x1e85bd4>
 6ec:	2070662b 	rsbscs	r6, r0, fp, lsr #12
 6f0:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
 6f4:	672d2067 	strvs	r2, [sp, -r7, rrx]!
 6f8:	304f2d20 	subcc	r2, pc, r0, lsr #26
 6fc:	304f2d20 	subcc	r2, pc, r0, lsr #26
 700:	6e662d20 	cdpvs	13, 6, cr2, cr6, cr0, {1}
 704:	78652d6f 	stmdavc	r5!, {r0, r1, r2, r3, r5, r6, r8, sl, fp, sp}^
 708:	74706563 	ldrbtvc	r6, [r0], #-1379	; 0xfffffa9d
 70c:	736e6f69 	cmnvc	lr, #420	; 0x1a4
 710:	6e662d20 	cdpvs	13, 6, cr2, cr6, cr0, {1}
 714:	74722d6f 	ldrbtvc	r2, [r2], #-3439	; 0xfffff291
 718:	62006974 	andvs	r6, r0, #116, 18	; 0x1d0000
 71c:	65666675 	strbvs	r6, [r6, #-1653]!	; 0xfffff98b
 720:	65720072 	ldrbvs	r0, [r2, #-114]!	; 0xffffff8e
 724:	646f6374 	strbtvs	r6, [pc], #-884	; 72c <_start-0x78d4>
 728:	69730065 	ldmdbvs	r3!, {r0, r2, r5, r6}^
 72c:	7700657a 	smlsdxvc	r0, sl, r5, r6
 730:	6d756e72 	ldclvs	14, cr6, [r5, #-456]!	; 0xfffffe38
 734:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
 738:	736f6c63 	cmnvc	pc, #25344	; 0x6300
 73c:	2f006a65 	svccs	0x00006a65
 740:	2f746e6d 	svccs	0x00746e6d
 744:	73552f63 	cmpvc	r5, #396	; 0x18c
 748:	2f737265 	svccs	0x00737265
 74c:	6162754b 	cmnvs	r2, fp, asr #10
 750:	636f442f 	cmnvs	pc, #788529152	; 0x2f000000
 754:	6e656d75 	mcrvs	13, 3, r6, cr5, cr5, {3}
 758:	532f7374 			; <UNDEFINED> instruction: 0x532f7374
 75c:	6f6f6863 	svcvs	0x006f6863
 760:	655a2f6c 	ldrbvs	r2, [sl, #-3948]	; 0xfffff094
 764:	614d6f72 	hvcvs	55026	; 0xd6f2
 768:	652f6574 	strvs	r6, [pc, #-1396]!	; 1fc <_start-0x7e04>
 76c:	706d6178 	rsbvc	r6, sp, r8, ror r1
 770:	2f73656c 	svccs	0x0073656c
 774:	702d3631 	eorvc	r3, sp, r1, lsr r6
 778:	6e696761 	cdpvs	7, 6, cr6, cr9, cr1, {3}
 77c:	73755f67 	cmnvc	r5, #412	; 0x19c
 780:	70737265 	rsbsvc	r7, r3, r5, ror #4
 784:	2f656361 	svccs	0x00656361
 788:	6c647473 	cfstrdvs	mvd7, [r4], #-460	; 0xfffffe34
 78c:	732f6269 			; <UNDEFINED> instruction: 0x732f6269
 790:	732f6372 			; <UNDEFINED> instruction: 0x732f6372
 794:	69666474 	stmdbvs	r6!, {r2, r4, r5, r6, sl, sp, lr}^
 798:	632e656c 			; <UNDEFINED> instruction: 0x632e656c
 79c:	6f007070 	svcvs	0x00007070
 7a0:	006e6570 	rsbeq	r6, lr, r0, ror r5
 7a4:	72345a5f 	eorsvc	r5, r4, #389120	; 0x5f000
 7a8:	6a646165 	bvs	1918d44 <__bss_end+0x1910850>
 7ac:	006a6350 	rsbeq	r6, sl, r0, asr r3
 7b0:	5f617369 	svcpl	0x00617369
 7b4:	5f746962 	svcpl	0x00746962
 7b8:	64657270 	strbtvs	r7, [r5], #-624	; 0xfffffd90
 7bc:	00736572 	rsbseq	r6, r3, r2, ror r5
 7c0:	5f617369 	svcpl	0x00617369
 7c4:	5f746962 	svcpl	0x00746962
 7c8:	5f706676 	svcpl	0x00706676
 7cc:	65736162 	ldrbvs	r6, [r3, #-354]!	; 0xfffffe9e
 7d0:	6d6f6300 	stclvs	3, cr6, [pc, #-0]	; 7d8 <_start-0x7828>
 7d4:	78656c70 	stmdavc	r5!, {r4, r5, r6, sl, fp, sp, lr}^
 7d8:	6f6c6620 	svcvs	0x006c6620
 7dc:	69007461 	stmdbvs	r0, {r0, r5, r6, sl, ip, sp, lr}
 7e0:	6e5f6173 	mrcvs	1, 2, r6, cr15, cr3, {3}
 7e4:	7469626f 	strbtvc	r6, [r9], #-623	; 0xfffffd91
 7e8:	61736900 	cmnvs	r3, r0, lsl #18
 7ec:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 7f0:	65766d5f 	ldrbvs	r6, [r6, #-3423]!	; 0xfffff2a1
 7f4:	6f6c665f 	svcvs	0x006c665f
 7f8:	69007461 	stmdbvs	r0, {r0, r5, r6, sl, ip, sp, lr}
 7fc:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 800:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
 804:	00363170 	eorseq	r3, r6, r0, ror r1
 808:	5f617369 	svcpl	0x00617369
 80c:	5f746962 	svcpl	0x00746962
 810:	00636573 	rsbeq	r6, r3, r3, ror r5
 814:	5f617369 	svcpl	0x00617369
 818:	5f746962 	svcpl	0x00746962
 81c:	76696461 	strbtvc	r6, [r9], -r1, ror #8
 820:	61736900 	cmnvs	r3, r0, lsl #18
 824:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 828:	6975715f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, r8, ip, sp, lr}^
 82c:	6e5f6b72 	vmovvs.s8	r6, d15[3]
 830:	6f765f6f 	svcvs	0x00765f6f
 834:	6974616c 	ldmdbvs	r4!, {r2, r3, r5, r6, r8, sp, lr}^
 838:	635f656c 	cmpvs	pc, #108, 10	; 0x1b000000
 83c:	73690065 	cmnvc	r9, #101	; 0x65
 840:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 844:	706d5f74 	rsbvc	r5, sp, r4, ror pc
 848:	61736900 	cmnvs	r3, r0, lsl #18
 84c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 850:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
 854:	00743576 	rsbseq	r3, r4, r6, ror r5
 858:	5f617369 	svcpl	0x00617369
 85c:	5f746962 	svcpl	0x00746962
 860:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
 864:	00657435 	rsbeq	r7, r5, r5, lsr r4
 868:	5f617369 	svcpl	0x00617369
 86c:	5f746962 	svcpl	0x00746962
 870:	6e6f656e 	cdpvs	5, 6, cr6, cr15, cr14, {3}
 874:	61736900 	cmnvs	r3, r0, lsl #18
 878:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 87c:	3166625f 	cmncc	r6, pc, asr r2
 880:	50460036 	subpl	r0, r6, r6, lsr r0
 884:	5f524353 	svcpl	0x00524353
 888:	4d554e45 	ldclmi	14, cr4, [r5, #-276]	; 0xfffffeec
 88c:	53504600 	cmppl	r0, #0, 12
 890:	6e5f5243 	cdpvs	2, 5, cr5, cr15, cr3, {2}
 894:	7176637a 	cmnvc	r6, sl, ror r3
 898:	4e455f63 	cdpmi	15, 4, cr5, cr5, cr3, {3}
 89c:	56004d55 			; <UNDEFINED> instruction: 0x56004d55
 8a0:	455f5250 	ldrbmi	r5, [pc, #-592]	; 658 <_start-0x79a8>
 8a4:	004d554e 	subeq	r5, sp, lr, asr #10
 8a8:	74696266 	strbtvc	r6, [r9], #-614	; 0xfffffd9a
 8ac:	706d695f 	rsbvc	r6, sp, pc, asr r9
 8b0:	6163696c 	cmnvs	r3, ip, ror #18
 8b4:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
 8b8:	5f305000 	svcpl	0x00305000
 8bc:	4d554e45 	ldclmi	14, cr4, [r5, #-276]	; 0xfffffeec
 8c0:	61736900 	cmnvs	r3, r0, lsl #18
 8c4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 8c8:	7972635f 	ldmdbvc	r2!, {r0, r1, r2, r3, r4, r6, r8, r9, sp, lr}^
 8cc:	006f7470 	rsbeq	r7, pc, r0, ror r4	; <UNPREDICTABLE>
 8d0:	20554e47 	subscs	r4, r5, r7, asr #28
 8d4:	20373143 	eorscs	r3, r7, r3, asr #2
 8d8:	332e3031 			; <UNDEFINED> instruction: 0x332e3031
 8dc:	3220312e 	eorcc	r3, r0, #-2147483637	; 0x8000000b
 8e0:	30313230 	eorscc	r3, r1, r0, lsr r2
 8e4:	20313236 	eorscs	r3, r1, r6, lsr r2
 8e8:	6c657228 	sfmvs	f7, 2, [r5], #-160	; 0xffffff60
 8ec:	65736165 	ldrbvs	r6, [r3, #-357]!	; 0xfffffe9b
 8f0:	6d2d2029 	stcvs	0, cr2, [sp, #-164]!	; 0xffffff5c
 8f4:	206d7261 	rsbcs	r7, sp, r1, ror #4
 8f8:	6c666d2d 	stclvs	13, cr6, [r6], #-180	; 0xffffff4c
 8fc:	2d74616f 	ldfcse	f6, [r4, #-444]!	; 0xfffffe44
 900:	3d696261 	sfmcc	f6, 2, [r9, #-388]!	; 0xfffffe7c
 904:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
 908:	616d2d20 	cmnvs	sp, r0, lsr #26
 90c:	3d686372 	stclcc	3, cr6, [r8, #-456]!	; 0xfffffe38
 910:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
 914:	2b657435 	blcs	195d9f0 <__bss_end+0x19554fc>
 918:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
 91c:	672d2067 	strvs	r2, [sp, -r7, rrx]!
 920:	20672d20 	rsbcs	r2, r7, r0, lsr #26
 924:	20324f2d 	eorscs	r4, r2, sp, lsr #30
 928:	20324f2d 	eorscs	r4, r2, sp, lsr #30
 92c:	20324f2d 	eorscs	r4, r2, sp, lsr #30
 930:	7562662d 	strbvc	r6, [r2, #-1581]!	; 0xfffff9d3
 934:	69646c69 	stmdbvs	r4!, {r0, r3, r5, r6, sl, fp, sp, lr}^
 938:	6c2d676e 	stcvs	7, cr6, [sp], #-440	; 0xfffffe48
 93c:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
 940:	662d2063 	strtvs	r2, [sp], -r3, rrx
 944:	732d6f6e 			; <UNDEFINED> instruction: 0x732d6f6e
 948:	6b636174 	blvs	18d8f20 <__bss_end+0x18d0a2c>
 94c:	6f72702d 	svcvs	0x0072702d
 950:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
 954:	2d20726f 	sfmcs	f7, 4, [r0, #-444]!	; 0xfffffe44
 958:	2d6f6e66 	stclcs	14, cr6, [pc, #-408]!	; 7c8 <_start-0x7838>
 95c:	696c6e69 	stmdbvs	ip!, {r0, r3, r5, r6, r9, sl, fp, sp, lr}^
 960:	2d20656e 	cfstr32cs	mvfx6, [r0, #-440]!	; 0xfffffe48
 964:	73697666 	cmnvc	r9, #106954752	; 0x6600000
 968:	6c696269 	sfmvs	f6, 2, [r9], #-420	; 0xfffffe5c
 96c:	3d797469 	cfldrdcc	mvd7, [r9, #-420]!	; 0xfffffe5c
 970:	64646968 	strbtvs	r6, [r4], #-2408	; 0xfffff698
 974:	69006e65 	stmdbvs	r0, {r0, r2, r5, r6, r9, sl, fp, sp, lr}
 978:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 97c:	745f7469 	ldrbvc	r7, [pc], #-1129	; 984 <_start-0x767c>
 980:	00766964 	rsbseq	r6, r6, r4, ror #18
 984:	736e6f63 	cmnvc	lr, #396	; 0x18c
 988:	61736900 	cmnvs	r3, r0, lsl #18
 98c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 990:	6d77695f 			; <UNDEFINED> instruction: 0x6d77695f
 994:	0074786d 	rsbseq	r7, r4, sp, ror #16
 998:	58435046 	stmdapl	r3, {r1, r2, r6, ip, lr}^
 99c:	455f5354 	ldrbmi	r5, [pc, #-852]	; 650 <_start-0x79b0>
 9a0:	004d554e 	subeq	r5, sp, lr, asr #10
 9a4:	5f617369 	svcpl	0x00617369
 9a8:	5f746962 	svcpl	0x00746962
 9ac:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
 9b0:	73690036 	cmnvc	r9, #54	; 0x36
 9b4:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 9b8:	766d5f74 	uqsub16vc	r5, sp, r4
 9bc:	73690065 	cmnvc	r9, #101	; 0x65
 9c0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 9c4:	77695f74 			; <UNDEFINED> instruction: 0x77695f74
 9c8:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
 9cc:	73690032 	cmnvc	r9, #50	; 0x32
 9d0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 9d4:	64635f74 	strbtvs	r5, [r3], #-3956	; 0xfffff08c
 9d8:	30706365 	rsbscc	r6, r0, r5, ror #6
 9dc:	61736900 	cmnvs	r3, r0, lsl #18
 9e0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 9e4:	6564635f 	strbvs	r6, [r4, #-863]!	; 0xfffffca1
 9e8:	00317063 	eorseq	r7, r1, r3, rrx
 9ec:	5f617369 	svcpl	0x00617369
 9f0:	5f746962 	svcpl	0x00746962
 9f4:	63656463 	cmnvs	r5, #1660944384	; 0x63000000
 9f8:	69003270 	stmdbvs	r0, {r4, r5, r6, r9, ip, sp}
 9fc:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 a00:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
 a04:	70636564 	rsbvc	r6, r3, r4, ror #10
 a08:	73690033 	cmnvc	r9, #51	; 0x33
 a0c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 a10:	64635f74 	strbtvs	r5, [r3], #-3956	; 0xfffff08c
 a14:	34706365 	ldrbtcc	r6, [r0], #-869	; 0xfffffc9b
 a18:	61736900 	cmnvs	r3, r0, lsl #18
 a1c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 a20:	5f70665f 	svcpl	0x0070665f
 a24:	006c6264 	rsbeq	r6, ip, r4, ror #4
 a28:	5f617369 	svcpl	0x00617369
 a2c:	5f746962 	svcpl	0x00746962
 a30:	63656463 	cmnvs	r5, #1660944384	; 0x63000000
 a34:	69003670 	stmdbvs	r0, {r4, r5, r6, r9, sl, ip, sp}
 a38:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 a3c:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
 a40:	70636564 	rsbvc	r6, r3, r4, ror #10
 a44:	73690037 	cmnvc	r9, #55	; 0x37
 a48:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 a4c:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
 a50:	6b36766d 	blvs	d9e40c <__bss_end+0xd95f18>
 a54:	61736900 	cmnvs	r3, r0, lsl #18
 a58:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 a5c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
 a60:	315f3876 	cmpcc	pc, r6, ror r8	; <UNPREDICTABLE>
 a64:	616d5f6d 	cmnvs	sp, sp, ror #30
 a68:	61006e69 	tstvs	r0, r9, ror #28
 a6c:	0065746e 	rsbeq	r7, r5, lr, ror #8
 a70:	5f617369 	svcpl	0x00617369
 a74:	5f746962 	svcpl	0x00746962
 a78:	65736d63 	ldrbvs	r6, [r3, #-3427]!	; 0xfffff29d
 a7c:	6e6f6c00 	cdpvs	12, 6, cr6, cr15, cr0, {0}
 a80:	6f642067 	svcvs	0x00642067
 a84:	656c6275 	strbvs	r6, [ip, #-629]!	; 0xfffffd8b
 a88:	2f2e2e00 	svccs	0x002e2e00
 a8c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 a90:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 a94:	2f2e2e2f 	svccs	0x002e2e2f
 a98:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 9e8 <_start-0x7618>
 a9c:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
 aa0:	696c2f63 	stmdbvs	ip!, {r0, r1, r5, r6, r8, r9, sl, fp, sp}^
 aa4:	63636762 	cmnvs	r3, #25690112	; 0x1880000
 aa8:	00632e32 	rsbeq	r2, r3, r2, lsr lr
 aac:	5f617369 	svcpl	0x00617369
 ab0:	5f746962 	svcpl	0x00746962
 ab4:	35767066 	ldrbcc	r7, [r6, #-102]!	; 0xffffff9a
 ab8:	61736900 	cmnvs	r3, r0, lsl #18
 abc:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 ac0:	6373785f 	cmnvs	r3, #6225920	; 0x5f0000
 ac4:	00656c61 	rsbeq	r6, r5, r1, ror #24
 ac8:	676e6f6c 	strbvs	r6, [lr, -ip, ror #30]!
 acc:	6e6f6c20 	cdpvs	12, 6, cr6, cr15, cr0, {1}
 ad0:	6e752067 	cdpvs	0, 7, cr2, cr5, cr7, {3}
 ad4:	6e676973 			; <UNDEFINED> instruction: 0x6e676973
 ad8:	69206465 	stmdbvs	r0!, {r0, r2, r5, r6, sl, sp, lr}
 adc:	6900746e 	stmdbvs	r0, {r1, r2, r3, r5, r6, sl, ip, sp, lr}
 ae0:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 ae4:	715f7469 	cmpvc	pc, r9, ror #8
 ae8:	6b726975 	blvs	1c9b0c4 <__bss_end+0x1c92bd0>
 aec:	336d635f 	cmncc	sp, #2080374785	; 0x7c000001
 af0:	72646c5f 	rsbvc	r6, r4, #24320	; 0x5f00
 af4:	73690064 	cmnvc	r9, #100	; 0x64
 af8:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 afc:	38695f74 	stmdacc	r9!, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
 b00:	69006d6d 	stmdbvs	r0, {r0, r2, r3, r5, r6, r8, sl, fp, sp, lr}
 b04:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 b08:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
 b0c:	33645f70 	cmncc	r4, #112, 30	; 0x1c0
 b10:	73690032 	cmnvc	r9, #50	; 0x32
 b14:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 b18:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
 b1c:	6537766d 	ldrvs	r7, [r7, #-1645]!	; 0xfffff993
 b20:	7369006d 	cmnvc	r9, #109	; 0x6d
 b24:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 b28:	706c5f74 	rsbvc	r5, ip, r4, ror pc
 b2c:	61006561 	tstvs	r0, r1, ror #10
 b30:	695f6c6c 	ldmdbvs	pc, {r2, r3, r5, r6, sl, fp, sp, lr}^	; <UNPREDICTABLE>
 b34:	696c706d 	stmdbvs	ip!, {r0, r2, r3, r5, r6, ip, sp, lr}^
 b38:	665f6465 	ldrbvs	r6, [pc], -r5, ror #8
 b3c:	73746962 	cmnvc	r4, #1605632	; 0x188000
 b40:	61736900 	cmnvs	r3, r0, lsl #18
 b44:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 b48:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
 b4c:	315f3876 	cmpcc	pc, r6, ror r8	; <UNPREDICTABLE>
 b50:	61736900 	cmnvs	r3, r0, lsl #18
 b54:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 b58:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
 b5c:	325f3876 	subscc	r3, pc, #7733248	; 0x760000
 b60:	61736900 	cmnvs	r3, r0, lsl #18
 b64:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 b68:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
 b6c:	335f3876 	cmpcc	pc, #7733248	; 0x760000
 b70:	61736900 	cmnvs	r3, r0, lsl #18
 b74:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 b78:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
 b7c:	345f3876 	ldrbcc	r3, [pc], #-2166	; b84 <_start-0x747c>
 b80:	61736900 	cmnvs	r3, r0, lsl #18
 b84:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 b88:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
 b8c:	355f3876 	ldrbcc	r3, [pc, #-2166]	; 31e <_start-0x7ce2>
 b90:	61736900 	cmnvs	r3, r0, lsl #18
 b94:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 b98:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
 b9c:	365f3876 			; <UNDEFINED> instruction: 0x365f3876
 ba0:	61736900 	cmnvs	r3, r0, lsl #18
 ba4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 ba8:	0062735f 	rsbeq	r7, r2, pc, asr r3
 bac:	5f617369 	svcpl	0x00617369
 bb0:	5f6d756e 	svcpl	0x006d756e
 bb4:	73746962 	cmnvc	r4, #1605632	; 0x188000
 bb8:	61736900 	cmnvs	r3, r0, lsl #18
 bbc:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 bc0:	616d735f 	cmnvs	sp, pc, asr r3
 bc4:	756d6c6c 	strbvc	r6, [sp, #-3180]!	; 0xfffff394
 bc8:	622f006c 	eorvs	r0, pc, #108	; 0x6c
 bcc:	646c6975 	strbtvs	r6, [ip], #-2421	; 0xfffff68b
 bd0:	6363672f 	cmnvs	r3, #12320768	; 0xbc0000
 bd4:	6d72612d 	ldfvse	f6, [r2, #-180]!	; 0xffffff4c
 bd8:	6e6f6e2d 	cdpvs	14, 6, cr6, cr15, cr13, {1}
 bdc:	61652d65 	cmnvs	r5, r5, ror #26
 be0:	682d6962 	stmdavs	sp!, {r1, r5, r6, r8, fp, sp, lr}
 be4:	4b676659 	blmi	19da550 <__bss_end+0x19d205c>
 be8:	63672f34 	cmnvs	r7, #52, 30	; 0xd0
 bec:	72612d63 	rsbvc	r2, r1, #6336	; 0x18c0
 bf0:	6f6e2d6d 	svcvs	0x006e2d6d
 bf4:	652d656e 	strvs	r6, [sp, #-1390]!	; 0xfffffa92
 bf8:	2d696261 	sfmcs	f6, 2, [r9, #-388]!	; 0xfffffe7c
 bfc:	332e3031 			; <UNDEFINED> instruction: 0x332e3031
 c00:	3230322d 	eorscc	r3, r0, #-805306366	; 0xd0000002
 c04:	37302e31 			; <UNDEFINED> instruction: 0x37302e31
 c08:	6975622f 	ldmdbvs	r5!, {r0, r1, r2, r3, r5, r9, sp, lr}^
 c0c:	612f646c 			; <UNDEFINED> instruction: 0x612f646c
 c10:	6e2d6d72 	mcrvs	13, 1, r6, cr13, cr2, {3}
 c14:	2d656e6f 	stclcs	14, cr6, [r5, #-444]!	; 0xfffffe44
 c18:	69626165 	stmdbvs	r2!, {r0, r2, r5, r6, r8, sp, lr}^
 c1c:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
 c20:	7435762f 	ldrtvc	r7, [r5], #-1583	; 0xfffff9d1
 c24:	61682f65 	cmnvs	r8, r5, ror #30
 c28:	6c2f6472 	cfstrsvs	mvf6, [pc], #-456	; a68 <_start-0x7598>
 c2c:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
 c30:	75660063 	strbvc	r0, [r6, #-99]!	; 0xffffff9d
 c34:	705f636e 	subsvc	r6, pc, lr, ror #6
 c38:	63007274 	movwvs	r7, #628	; 0x274
 c3c:	6c706d6f 	ldclvs	13, cr6, [r0], #-444	; 0xfffffe44
 c40:	64207865 	strtvs	r7, [r0], #-2149	; 0xfffff79b
 c44:	6c62756f 	cfstr64vs	mvdx7, [r2], #-444	; 0xfffffe44
 c48:	424e0065 	submi	r0, lr, #101	; 0x65
 c4c:	5f50465f 	svcpl	0x0050465f
 c50:	52535953 	subspl	r5, r3, #1359872	; 0x14c000
 c54:	00534745 	subseq	r4, r3, r5, asr #14
 c58:	5f617369 	svcpl	0x00617369
 c5c:	5f746962 	svcpl	0x00746962
 c60:	63656463 	cmnvs	r5, #1660944384	; 0x63000000
 c64:	69003570 	stmdbvs	r0, {r4, r5, r6, r8, sl, ip, sp}
 c68:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 c6c:	765f7469 	ldrbvc	r7, [pc], -r9, ror #8
 c70:	32767066 	rsbscc	r7, r6, #102	; 0x66
 c74:	61736900 	cmnvs	r3, r0, lsl #18
 c78:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 c7c:	7066765f 	rsbvc	r7, r6, pc, asr r6
 c80:	69003376 	stmdbvs	r0, {r1, r2, r4, r5, r6, r8, r9, ip, sp}
 c84:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 c88:	765f7469 	ldrbvc	r7, [pc], -r9, ror #8
 c8c:	34767066 	ldrbtcc	r7, [r6], #-102	; 0xffffff9a
 c90:	43504600 	cmpmi	r0, #0, 12
 c94:	534e5458 	movtpl	r5, #58456	; 0xe458
 c98:	554e455f 	strbpl	r4, [lr, #-1375]	; 0xfffffaa1
 c9c:	7369004d 	cmnvc	r9, #77	; 0x4d
 ca0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 ca4:	68745f74 	ldmdavs	r4!, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
 ca8:	00626d75 	rsbeq	r6, r2, r5, ror sp
 cac:	5f617369 	svcpl	0x00617369
 cb0:	5f746962 	svcpl	0x00746962
 cb4:	36317066 	ldrtcc	r7, [r1], -r6, rrx
 cb8:	766e6f63 	strbtvc	r6, [lr], -r3, ror #30
 cbc:	61736900 	cmnvs	r3, r0, lsl #18
 cc0:	6165665f 	cmnvs	r5, pc, asr r6
 cc4:	65727574 	ldrbvs	r7, [r2, #-1396]!	; 0xfffffa8c
 cc8:	61736900 	cmnvs	r3, r0, lsl #18
 ccc:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 cd0:	746f6e5f 	strbtvc	r6, [pc], #-3679	; cd8 <_start-0x7328>
 cd4:	7369006d 	cmnvc	r9, #109	; 0x6d
 cd8:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 cdc:	75715f74 	ldrbvc	r5, [r1, #-3956]!	; 0xfffff08c
 ce0:	5f6b7269 	svcpl	0x006b7269
 ce4:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
 ce8:	007a6b36 	rsbseq	r6, sl, r6, lsr fp
 cec:	5f617369 	svcpl	0x00617369
 cf0:	5f746962 	svcpl	0x00746962
 cf4:	33637263 	cmncc	r3, #805306374	; 0x30000006
 cf8:	73690032 	cmnvc	r9, #50	; 0x32
 cfc:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 d00:	75715f74 	ldrbvc	r5, [r1, #-3956]!	; 0xfffff08c
 d04:	5f6b7269 	svcpl	0x006b7269
 d08:	615f6f6e 	cmpvs	pc, lr, ror #30
 d0c:	70636d73 	rsbvc	r6, r3, r3, ror sp
 d10:	73690075 	cmnvc	r9, #117	; 0x75
 d14:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
 d18:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
 d1c:	0034766d 	eorseq	r7, r4, sp, ror #12
 d20:	5f617369 	svcpl	0x00617369
 d24:	5f746962 	svcpl	0x00746962
 d28:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
 d2c:	69003262 	stmdbvs	r0, {r1, r5, r6, r9, ip, sp}
 d30:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 d34:	625f7469 	subsvs	r7, pc, #1761607680	; 0x69000000
 d38:	69003865 	stmdbvs	r0, {r0, r2, r5, r6, fp, ip, sp}
 d3c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
 d40:	615f7469 	cmpvs	pc, r9, ror #8
 d44:	37766d72 			; <UNDEFINED> instruction: 0x37766d72
 d48:	61736900 	cmnvs	r3, r0, lsl #18
 d4c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
 d50:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
 d54:	76003876 			; <UNDEFINED> instruction: 0x76003876
 d58:	735f7066 	cmpvc	pc, #102	; 0x66
 d5c:	65727379 	ldrbvs	r7, [r2, #-889]!	; 0xfffffc87
 d60:	655f7367 	ldrbvs	r7, [pc, #-871]	; a01 <_start-0x75ff>
 d64:	646f636e 	strbtvs	r6, [pc], #-878	; d6c <_start-0x7294>
 d68:	00676e69 	rsbeq	r6, r7, r9, ror #28
 d6c:	5f617369 	svcpl	0x00617369
 d70:	5f746962 	svcpl	0x00746962
 d74:	36317066 	ldrtcc	r7, [r1], -r6, rrx
 d78:	006c6d66 	rsbeq	r6, ip, r6, ror #26
 d7c:	5f617369 	svcpl	0x00617369
 d80:	5f746962 	svcpl	0x00746962
 d84:	70746f64 	rsbsvc	r6, r4, r4, ror #30
 d88:	00646f72 	rsbeq	r6, r4, r2, ror pc

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
  20:	8b040e42 	blhi	103930 <__bss_end+0xfb43c>
  24:	0b0d4201 	bleq	350830 <__bss_end+0x34833c>
  28:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
  2c:	00000ecb 	andeq	r0, r0, fp, asr #29
  30:	0000001c 	andeq	r0, r0, ip, lsl r0
  34:	00000000 	andeq	r0, r0, r0
  38:	00008064 	andeq	r8, r0, r4, rrx
  3c:	00000040 	andeq	r0, r0, r0, asr #32
  40:	8b080e42 	blhi	203950 <__bss_end+0x1fb45c>
  44:	42018e02 	andmi	r8, r1, #2, 28
  48:	5a040b0c 	bpl	102c80 <__bss_end+0xfa78c>
  4c:	00080d0c 	andeq	r0, r8, ip, lsl #26
  50:	0000000c 	andeq	r0, r0, ip
  54:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  58:	7c020001 	stcvc	0, cr0, [r2], {1}
  5c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  60:	0000001c 	andeq	r0, r0, ip, lsl r0
  64:	00000050 	andeq	r0, r0, r0, asr r0
  68:	000080a4 	andeq	r8, r0, r4, lsr #1
  6c:	00000038 	andeq	r0, r0, r8, lsr r0
  70:	8b040e42 	blhi	103980 <__bss_end+0xfb48c>
  74:	0b0d4201 	bleq	350880 <__bss_end+0x34838c>
  78:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
  7c:	00000ecb 	andeq	r0, r0, fp, asr #29
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	00000050 	andeq	r0, r0, r0, asr r0
  88:	000080dc 	ldrdeq	r8, [r0], -ip
  8c:	0000002c 	andeq	r0, r0, ip, lsr #32
  90:	8b040e42 	blhi	1039a0 <__bss_end+0xfb4ac>
  94:	0b0d4201 	bleq	3508a0 <__bss_end+0x3483ac>
  98:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
  9c:	00000ecb 	andeq	r0, r0, fp, asr #29
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	00000050 	andeq	r0, r0, r0, asr r0
  a8:	00008108 	andeq	r8, r0, r8, lsl #2
  ac:	00000020 	andeq	r0, r0, r0, lsr #32
  b0:	8b040e42 	blhi	1039c0 <__bss_end+0xfb4cc>
  b4:	0b0d4201 	bleq	3508c0 <__bss_end+0x3483cc>
  b8:	420d0d48 	andmi	r0, sp, #72, 26	; 0x1200
  bc:	00000ecb 	andeq	r0, r0, fp, asr #29
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	00000050 	andeq	r0, r0, r0, asr r0
  c8:	00008128 	andeq	r8, r0, r8, lsr #2
  cc:	00000018 	andeq	r0, r0, r8, lsl r0
  d0:	8b040e42 	blhi	1039e0 <__bss_end+0xfb4ec>
  d4:	0b0d4201 	bleq	3508e0 <__bss_end+0x3483ec>
  d8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  dc:	00000ecb 	andeq	r0, r0, fp, asr #29
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	00000050 	andeq	r0, r0, r0, asr r0
  e8:	00008140 	andeq	r8, r0, r0, asr #2
  ec:	00000018 	andeq	r0, r0, r8, lsl r0
  f0:	8b040e42 	blhi	103a00 <__bss_end+0xfb50c>
  f4:	0b0d4201 	bleq	350900 <__bss_end+0x34840c>
  f8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  fc:	00000ecb 	andeq	r0, r0, fp, asr #29
 100:	0000001c 	andeq	r0, r0, ip, lsl r0
 104:	00000050 	andeq	r0, r0, r0, asr r0
 108:	00008158 	andeq	r8, r0, r8, asr r1
 10c:	00000018 	andeq	r0, r0, r8, lsl r0
 110:	8b040e42 	blhi	103a20 <__bss_end+0xfb52c>
 114:	0b0d4201 	bleq	350920 <__bss_end+0x34842c>
 118:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
 11c:	00000ecb 	andeq	r0, r0, fp, asr #29
 120:	00000014 	andeq	r0, r0, r4, lsl r0
 124:	00000050 	andeq	r0, r0, r0, asr r0
 128:	00008170 	andeq	r8, r0, r0, ror r1
 12c:	0000000c 	andeq	r0, r0, ip
 130:	8b040e42 	blhi	103a40 <__bss_end+0xfb54c>
 134:	0b0d4201 	bleq	350940 <__bss_end+0x34844c>
 138:	0000001c 	andeq	r0, r0, ip, lsl r0
 13c:	00000050 	andeq	r0, r0, r0, asr r0
 140:	0000817c 	andeq	r8, r0, ip, ror r1
 144:	00000058 	andeq	r0, r0, r8, asr r0
 148:	8b080e42 	blhi	203a58 <__bss_end+0x1fb564>
 14c:	42018e02 	andmi	r8, r1, #2, 28
 150:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 154:	00080d0c 	andeq	r0, r8, ip, lsl #26
 158:	0000001c 	andeq	r0, r0, ip, lsl r0
 15c:	00000050 	andeq	r0, r0, r0, asr r0
 160:	000081d4 	ldrdeq	r8, [r0], -r4
 164:	00000058 	andeq	r0, r0, r8, asr r0
 168:	8b080e42 	blhi	203a78 <__bss_end+0x1fb584>
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
 194:	000000b4 	strheq	r0, [r0], -r4
 198:	8b080e42 	blhi	203aa8 <__bss_end+0x1fb5b4>
 19c:	42018e02 	andmi	r8, r1, #2, 28
 1a0:	00040b0c 	andeq	r0, r4, ip, lsl #22
 1a4:	0000000c 	andeq	r0, r0, ip
 1a8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 1ac:	7c020001 	stcvc	0, cr0, [r2], {1}
 1b0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 1b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1b8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1bc:	000082e0 	andeq	r8, r0, r0, ror #5
 1c0:	0000002c 	andeq	r0, r0, ip, lsr #32
 1c4:	8b040e42 	blhi	103ad4 <__bss_end+0xfb5e0>
 1c8:	0b0d4201 	bleq	3509d4 <__bss_end+0x3484e0>
 1cc:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 1d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 1d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1d8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1dc:	0000830c 	andeq	r8, r0, ip, lsl #6
 1e0:	0000002c 	andeq	r0, r0, ip, lsr #32
 1e4:	8b040e42 	blhi	103af4 <__bss_end+0xfb600>
 1e8:	0b0d4201 	bleq	3509f4 <__bss_end+0x348500>
 1ec:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 1f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 1f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1f8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1fc:	00008338 	andeq	r8, r0, r8, lsr r3
 200:	0000001c 	andeq	r0, r0, ip, lsl r0
 204:	8b040e42 	blhi	103b14 <__bss_end+0xfb620>
 208:	0b0d4201 	bleq	350a14 <__bss_end+0x348520>
 20c:	420d0d46 	andmi	r0, sp, #4480	; 0x1180
 210:	00000ecb 	andeq	r0, r0, fp, asr #29
 214:	0000001c 	andeq	r0, r0, ip, lsl r0
 218:	000001a4 	andeq	r0, r0, r4, lsr #3
 21c:	00008354 	andeq	r8, r0, r4, asr r3
 220:	00000044 	andeq	r0, r0, r4, asr #32
 224:	8b040e42 	blhi	103b34 <__bss_end+0xfb640>
 228:	0b0d4201 	bleq	350a34 <__bss_end+0x348540>
 22c:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 230:	00000ecb 	andeq	r0, r0, fp, asr #29
 234:	0000001c 	andeq	r0, r0, ip, lsl r0
 238:	000001a4 	andeq	r0, r0, r4, lsr #3
 23c:	00008398 	muleq	r0, r8, r3
 240:	00000050 	andeq	r0, r0, r0, asr r0
 244:	8b040e42 	blhi	103b54 <__bss_end+0xfb660>
 248:	0b0d4201 	bleq	350a54 <__bss_end+0x348560>
 24c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 250:	00000ecb 	andeq	r0, r0, fp, asr #29
 254:	0000001c 	andeq	r0, r0, ip, lsl r0
 258:	000001a4 	andeq	r0, r0, r4, lsr #3
 25c:	000083e8 	andeq	r8, r0, r8, ror #7
 260:	00000050 	andeq	r0, r0, r0, asr r0
 264:	8b040e42 	blhi	103b74 <__bss_end+0xfb680>
 268:	0b0d4201 	bleq	350a74 <__bss_end+0x348580>
 26c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 270:	00000ecb 	andeq	r0, r0, fp, asr #29
 274:	0000001c 	andeq	r0, r0, ip, lsl r0
 278:	000001a4 	andeq	r0, r0, r4, lsr #3
 27c:	00008438 	andeq	r8, r0, r8, lsr r4
 280:	0000002c 	andeq	r0, r0, ip, lsr #32
 284:	8b040e42 	blhi	103b94 <__bss_end+0xfb6a0>
 288:	0b0d4201 	bleq	350a94 <__bss_end+0x3485a0>
 28c:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 290:	00000ecb 	andeq	r0, r0, fp, asr #29
 294:	0000001c 	andeq	r0, r0, ip, lsl r0
 298:	000001a4 	andeq	r0, r0, r4, lsr #3
 29c:	00008464 	andeq	r8, r0, r4, ror #8
 2a0:	00000050 	andeq	r0, r0, r0, asr r0
 2a4:	8b040e42 	blhi	103bb4 <__bss_end+0xfb6c0>
 2a8:	0b0d4201 	bleq	350ab4 <__bss_end+0x3485c0>
 2ac:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 2b0:	00000ecb 	andeq	r0, r0, fp, asr #29
