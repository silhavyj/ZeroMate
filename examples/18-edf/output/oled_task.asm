
./oled_task:     file format elf32-littlearm


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
    805c:	00009728 	andeq	r9, r0, r8, lsr #14
    8060:	00009738 	andeq	r9, r0, r8, lsr r7

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
    81cc:	00009714 	andeq	r9, r0, r4, lsl r7
    81d0:	00009714 	andeq	r9, r0, r4, lsl r7

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
    8224:	00009714 	andeq	r9, r0, r4, lsl r7
    8228:	00009714 	andeq	r9, r0, r4, lsl r7

0000822c <main>:
main():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/oled_task/main.cpp:27
	"My favourite sport is ARM wrestling",
	"Old MacDonald had a farm, EIGRP",
};

int main(int argc, char** argv)
{
    822c:	e92d4800 	push	{fp, lr}
    8230:	e28db004 	add	fp, sp, #4
    8234:	e24dd020 	sub	sp, sp, #32
    8238:	e50b0020 	str	r0, [fp, #-32]	; 0xffffffe0
    823c:	e50b1024 	str	r1, [fp, #-36]	; 0xffffffdc
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/oled_task/main.cpp:28
	COLED_Display disp("DEV:oled");
    8240:	e24b3014 	sub	r3, fp, #20
    8244:	e59f10d8 	ldr	r1, [pc, #216]	; 8324 <main+0xf8>
    8248:	e1a00003 	mov	r0, r3
    824c:	eb00027e 	bl	8c4c <_ZN13COLED_DisplayC1EPKc>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/oled_task/main.cpp:29
	disp.Clear(false);
    8250:	e24b3014 	sub	r3, fp, #20
    8254:	e3a01000 	mov	r1, #0
    8258:	e1a00003 	mov	r0, r3
    825c:	eb0002b1 	bl	8d28 <_ZN13COLED_Display5ClearEb>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/oled_task/main.cpp:30
	disp.Put_String(10, 10, "KIV-RTOS init...");
    8260:	e24b0014 	sub	r0, fp, #20
    8264:	e59f30bc 	ldr	r3, [pc, #188]	; 8328 <main+0xfc>
    8268:	e3a0200a 	mov	r2, #10
    826c:	e3a0100a 	mov	r1, #10
    8270:	eb000376 	bl	9050 <_ZN13COLED_Display10Put_StringEttPKc>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/oled_task/main.cpp:31
	disp.Flip();
    8274:	e24b3014 	sub	r3, fp, #20
    8278:	e1a00003 	mov	r0, r3
    827c:	eb00035d 	bl	8ff8 <_ZN13COLED_Display4FlipEv>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/oled_task/main.cpp:33

	uint32_t trng_file = open("DEV:trng", NFile_Open_Mode::Read_Only);
    8280:	e3a01000 	mov	r1, #0
    8284:	e59f00a0 	ldr	r0, [pc, #160]	; 832c <main+0x100>
    8288:	eb000047 	bl	83ac <_Z4openPKc15NFile_Open_Mode>
    828c:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/oled_task/main.cpp:34
	uint32_t num = 0;
    8290:	e3a03000 	mov	r3, #0
    8294:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/oled_task/main.cpp:36

	sleep(0x800, 0x800);
    8298:	e3a01b02 	mov	r1, #2048	; 0x800
    829c:	e3a00b02 	mov	r0, #2048	; 0x800
    82a0:	eb0000be 	bl	85a0 <_Z5sleepjj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/oled_task/main.cpp:41 (discriminator 1)

	while (true)
	{
		// ziskame si nahodne cislo a vybereme podle toho zpravu
		read(trng_file, reinterpret_cast<char*>(&num), sizeof(num));
    82a4:	e24b3018 	sub	r3, fp, #24
    82a8:	e3a02004 	mov	r2, #4
    82ac:	e1a01003 	mov	r1, r3
    82b0:	e51b0008 	ldr	r0, [fp, #-8]
    82b4:	eb00004d 	bl	83f0 <_Z4readjPcj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/oled_task/main.cpp:42 (discriminator 1)
		const char* msg = messages[num % (sizeof(messages) / sizeof(const char*))];
    82b8:	e51b1018 	ldr	r1, [fp, #-24]	; 0xffffffe8
    82bc:	e59f306c 	ldr	r3, [pc, #108]	; 8330 <main+0x104>
    82c0:	e0832193 	umull	r2, r3, r3, r1
    82c4:	e1a02123 	lsr	r2, r3, #2
    82c8:	e1a03002 	mov	r3, r2
    82cc:	e1a03103 	lsl	r3, r3, #2
    82d0:	e0833002 	add	r3, r3, r2
    82d4:	e0412003 	sub	r2, r1, r3
    82d8:	e59f3054 	ldr	r3, [pc, #84]	; 8334 <main+0x108>
    82dc:	e7933102 	ldr	r3, [r3, r2, lsl #2]
    82e0:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/oled_task/main.cpp:44 (discriminator 1)

		disp.Clear(false);
    82e4:	e24b3014 	sub	r3, fp, #20
    82e8:	e3a01000 	mov	r1, #0
    82ec:	e1a00003 	mov	r0, r3
    82f0:	eb00028c 	bl	8d28 <_ZN13COLED_Display5ClearEb>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/oled_task/main.cpp:45 (discriminator 1)
		disp.Put_String(0, 0, msg);
    82f4:	e24b0014 	sub	r0, fp, #20
    82f8:	e51b300c 	ldr	r3, [fp, #-12]
    82fc:	e3a02000 	mov	r2, #0
    8300:	e3a01000 	mov	r1, #0
    8304:	eb000351 	bl	9050 <_ZN13COLED_Display10Put_StringEttPKc>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/oled_task/main.cpp:46 (discriminator 1)
		disp.Flip();
    8308:	e24b3014 	sub	r3, fp, #20
    830c:	e1a00003 	mov	r0, r3
    8310:	eb000338 	bl	8ff8 <_ZN13COLED_Display4FlipEv>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/oled_task/main.cpp:48 (discriminator 1)

		sleep(0x4000, 0x800); // TODO: z tohohle bude casem cekani na podminkove promenne (na eventu) s timeoutem
    8314:	e3a01b02 	mov	r1, #2048	; 0x800
    8318:	e3a00901 	mov	r0, #16384	; 0x4000
    831c:	eb00009f 	bl	85a0 <_Z5sleepjj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/oled_task/main.cpp:49 (discriminator 1)
	}
    8320:	eaffffdf 	b	82a4 <main+0x78>
    8324:	000093f8 	strdeq	r9, [r0], -r8
    8328:	00009404 	andeq	r9, r0, r4, lsl #8
    832c:	00009418 	andeq	r9, r0, r8, lsl r4
    8330:	cccccccd 	stclgt	12, cr12, [ip], {205}	; 0xcd
    8334:	00009714 	andeq	r9, r0, r4, lsl r7

00008338 <_Z6getpidv>:
_Z6getpidv():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:5
#include <stdfile.h>
#include <stdstring.h>

uint32_t getpid()
{
    8338:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    833c:	e28db000 	add	fp, sp, #0
    8340:	e24dd00c 	sub	sp, sp, #12
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:8
    uint32_t pid;

    asm volatile("swi 0");
    8344:	ef000000 	svc	0x00000000
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:9
    asm volatile("mov %0, r0" : "=r" (pid));
    8348:	e1a03000 	mov	r3, r0
    834c:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:11

    return pid;
    8350:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:12
}
    8354:	e1a00003 	mov	r0, r3
    8358:	e28bd000 	add	sp, fp, #0
    835c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8360:	e12fff1e 	bx	lr

00008364 <_Z9terminatei>:
_Z9terminatei():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:15

void terminate(int exitcode)
{
    8364:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8368:	e28db000 	add	fp, sp, #0
    836c:	e24dd00c 	sub	sp, sp, #12
    8370:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:16
    asm volatile("mov r0, %0" : : "r" (exitcode));
    8374:	e51b3008 	ldr	r3, [fp, #-8]
    8378:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:17
    asm volatile("swi 1");
    837c:	ef000001 	svc	0x00000001
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:18
}
    8380:	e320f000 	nop	{0}
    8384:	e28bd000 	add	sp, fp, #0
    8388:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    838c:	e12fff1e 	bx	lr

00008390 <_Z11sched_yieldv>:
_Z11sched_yieldv():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:21

void sched_yield()
{
    8390:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8394:	e28db000 	add	fp, sp, #0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:22
    asm volatile("swi 2");
    8398:	ef000002 	svc	0x00000002
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:23
}
    839c:	e320f000 	nop	{0}
    83a0:	e28bd000 	add	sp, fp, #0
    83a4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    83a8:	e12fff1e 	bx	lr

000083ac <_Z4openPKc15NFile_Open_Mode>:
_Z4openPKc15NFile_Open_Mode():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:26

uint32_t open(const char* filename, NFile_Open_Mode mode)
{
    83ac:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    83b0:	e28db000 	add	fp, sp, #0
    83b4:	e24dd014 	sub	sp, sp, #20
    83b8:	e50b0010 	str	r0, [fp, #-16]
    83bc:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:29
    uint32_t file;

    asm volatile("mov r0, %0" : : "r" (filename));
    83c0:	e51b3010 	ldr	r3, [fp, #-16]
    83c4:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:30
    asm volatile("mov r1, %0" : : "r" (mode));
    83c8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    83cc:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:31
    asm volatile("swi 64");
    83d0:	ef000040 	svc	0x00000040
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:32
    asm volatile("mov %0, r0" : "=r" (file));
    83d4:	e1a03000 	mov	r3, r0
    83d8:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:34

    return file;
    83dc:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:35
}
    83e0:	e1a00003 	mov	r0, r3
    83e4:	e28bd000 	add	sp, fp, #0
    83e8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    83ec:	e12fff1e 	bx	lr

000083f0 <_Z4readjPcj>:
_Z4readjPcj():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:38

uint32_t read(uint32_t file, char* const buffer, uint32_t size)
{
    83f0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    83f4:	e28db000 	add	fp, sp, #0
    83f8:	e24dd01c 	sub	sp, sp, #28
    83fc:	e50b0010 	str	r0, [fp, #-16]
    8400:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8404:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:41
    uint32_t rdnum;

    asm volatile("mov r0, %0" : : "r" (file));
    8408:	e51b3010 	ldr	r3, [fp, #-16]
    840c:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:42
    asm volatile("mov r1, %0" : : "r" (buffer));
    8410:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8414:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:43
    asm volatile("mov r2, %0" : : "r" (size));
    8418:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    841c:	e1a02003 	mov	r2, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:44
    asm volatile("swi 65");
    8420:	ef000041 	svc	0x00000041
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:45
    asm volatile("mov %0, r0" : "=r" (rdnum));
    8424:	e1a03000 	mov	r3, r0
    8428:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:47

    return rdnum;
    842c:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:48
}
    8430:	e1a00003 	mov	r0, r3
    8434:	e28bd000 	add	sp, fp, #0
    8438:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    843c:	e12fff1e 	bx	lr

00008440 <_Z5writejPKcj>:
_Z5writejPKcj():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:51

uint32_t write(uint32_t file, const char* buffer, uint32_t size)
{
    8440:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8444:	e28db000 	add	fp, sp, #0
    8448:	e24dd01c 	sub	sp, sp, #28
    844c:	e50b0010 	str	r0, [fp, #-16]
    8450:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8454:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:54
    uint32_t wrnum;

    asm volatile("mov r0, %0" : : "r" (file));
    8458:	e51b3010 	ldr	r3, [fp, #-16]
    845c:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:55
    asm volatile("mov r1, %0" : : "r" (buffer));
    8460:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8464:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:56
    asm volatile("mov r2, %0" : : "r" (size));
    8468:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    846c:	e1a02003 	mov	r2, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:57
    asm volatile("swi 66");
    8470:	ef000042 	svc	0x00000042
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:58
    asm volatile("mov %0, r0" : "=r" (wrnum));
    8474:	e1a03000 	mov	r3, r0
    8478:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:60

    return wrnum;
    847c:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:61
}
    8480:	e1a00003 	mov	r0, r3
    8484:	e28bd000 	add	sp, fp, #0
    8488:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    848c:	e12fff1e 	bx	lr

00008490 <_Z5closej>:
_Z5closej():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:64

void close(uint32_t file)
{
    8490:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8494:	e28db000 	add	fp, sp, #0
    8498:	e24dd00c 	sub	sp, sp, #12
    849c:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:65
    asm volatile("mov r0, %0" : : "r" (file));
    84a0:	e51b3008 	ldr	r3, [fp, #-8]
    84a4:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:66
    asm volatile("swi 67");
    84a8:	ef000043 	svc	0x00000043
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:67
}
    84ac:	e320f000 	nop	{0}
    84b0:	e28bd000 	add	sp, fp, #0
    84b4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    84b8:	e12fff1e 	bx	lr

000084bc <_Z5ioctlj16NIOCtl_OperationPv>:
_Z5ioctlj16NIOCtl_OperationPv():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:70

uint32_t ioctl(uint32_t file, NIOCtl_Operation operation, void* param)
{
    84bc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    84c0:	e28db000 	add	fp, sp, #0
    84c4:	e24dd01c 	sub	sp, sp, #28
    84c8:	e50b0010 	str	r0, [fp, #-16]
    84cc:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    84d0:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:73
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    84d4:	e51b3010 	ldr	r3, [fp, #-16]
    84d8:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:74
    asm volatile("mov r1, %0" : : "r" (operation));
    84dc:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    84e0:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:75
    asm volatile("mov r2, %0" : : "r" (param));
    84e4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    84e8:	e1a02003 	mov	r2, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:76
    asm volatile("swi 68");
    84ec:	ef000044 	svc	0x00000044
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:77
    asm volatile("mov %0, r0" : "=r" (retcode));
    84f0:	e1a03000 	mov	r3, r0
    84f4:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:79

    return retcode;
    84f8:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:80
}
    84fc:	e1a00003 	mov	r0, r3
    8500:	e28bd000 	add	sp, fp, #0
    8504:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8508:	e12fff1e 	bx	lr

0000850c <_Z6notifyjj>:
_Z6notifyjj():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:83

uint32_t notify(uint32_t file, uint32_t count)
{
    850c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8510:	e28db000 	add	fp, sp, #0
    8514:	e24dd014 	sub	sp, sp, #20
    8518:	e50b0010 	str	r0, [fp, #-16]
    851c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:86
    uint32_t retcnt;

    asm volatile("mov r0, %0" : : "r" (file));
    8520:	e51b3010 	ldr	r3, [fp, #-16]
    8524:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:87
    asm volatile("mov r1, %0" : : "r" (count));
    8528:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    852c:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:88
    asm volatile("swi 69");
    8530:	ef000045 	svc	0x00000045
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:89
    asm volatile("mov %0, r0" : "=r" (retcnt));
    8534:	e1a03000 	mov	r3, r0
    8538:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:91

    return retcnt;
    853c:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:92
}
    8540:	e1a00003 	mov	r0, r3
    8544:	e28bd000 	add	sp, fp, #0
    8548:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    854c:	e12fff1e 	bx	lr

00008550 <_Z4waitjjj>:
_Z4waitjjj():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:95

NSWI_Result_Code wait(uint32_t file, uint32_t count, uint32_t notified_deadline)
{
    8550:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8554:	e28db000 	add	fp, sp, #0
    8558:	e24dd01c 	sub	sp, sp, #28
    855c:	e50b0010 	str	r0, [fp, #-16]
    8560:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8564:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:98
    NSWI_Result_Code retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    8568:	e51b3010 	ldr	r3, [fp, #-16]
    856c:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:99
    asm volatile("mov r1, %0" : : "r" (count));
    8570:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8574:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:100
    asm volatile("mov r2, %0" : : "r" (notified_deadline));
    8578:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    857c:	e1a02003 	mov	r2, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:101
    asm volatile("swi 70");
    8580:	ef000046 	svc	0x00000046
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:102
    asm volatile("mov %0, r0" : "=r" (retcode));
    8584:	e1a03000 	mov	r3, r0
    8588:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:104

    return retcode;
    858c:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:105
}
    8590:	e1a00003 	mov	r0, r3
    8594:	e28bd000 	add	sp, fp, #0
    8598:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    859c:	e12fff1e 	bx	lr

000085a0 <_Z5sleepjj>:
_Z5sleepjj():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:108

bool sleep(uint32_t ticks, uint32_t notified_deadline)
{
    85a0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    85a4:	e28db000 	add	fp, sp, #0
    85a8:	e24dd014 	sub	sp, sp, #20
    85ac:	e50b0010 	str	r0, [fp, #-16]
    85b0:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:111
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (ticks));
    85b4:	e51b3010 	ldr	r3, [fp, #-16]
    85b8:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:112
    asm volatile("mov r1, %0" : : "r" (notified_deadline));
    85bc:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    85c0:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:113
    asm volatile("swi 3");
    85c4:	ef000003 	svc	0x00000003
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:114
    asm volatile("mov %0, r0" : "=r" (retcode));
    85c8:	e1a03000 	mov	r3, r0
    85cc:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:116

    return retcode;
    85d0:	e51b3008 	ldr	r3, [fp, #-8]
    85d4:	e3530000 	cmp	r3, #0
    85d8:	13a03001 	movne	r3, #1
    85dc:	03a03000 	moveq	r3, #0
    85e0:	e6ef3073 	uxtb	r3, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:117
}
    85e4:	e1a00003 	mov	r0, r3
    85e8:	e28bd000 	add	sp, fp, #0
    85ec:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    85f0:	e12fff1e 	bx	lr

000085f4 <_Z24get_active_process_countv>:
_Z24get_active_process_countv():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:120

uint32_t get_active_process_count()
{
    85f4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    85f8:	e28db000 	add	fp, sp, #0
    85fc:	e24dd00c 	sub	sp, sp, #12
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:121
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Active_Process_Count;
    8600:	e3a03000 	mov	r3, #0
    8604:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:124
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r" (req));
    8608:	e3a03000 	mov	r3, #0
    860c:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:125
    asm volatile("mov r1, %0" : : "r" (&retval));
    8610:	e24b300c 	sub	r3, fp, #12
    8614:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:126
    asm volatile("swi 4");
    8618:	ef000004 	svc	0x00000004
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:128

    return retval;
    861c:	e51b300c 	ldr	r3, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:129
}
    8620:	e1a00003 	mov	r0, r3
    8624:	e28bd000 	add	sp, fp, #0
    8628:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    862c:	e12fff1e 	bx	lr

00008630 <_Z14get_tick_countv>:
_Z14get_tick_countv():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:132

uint32_t get_tick_count()
{
    8630:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8634:	e28db000 	add	fp, sp, #0
    8638:	e24dd00c 	sub	sp, sp, #12
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:133
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Tick_Count;
    863c:	e3a03001 	mov	r3, #1
    8640:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:136
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r" (req));
    8644:	e3a03001 	mov	r3, #1
    8648:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:137
    asm volatile("mov r1, %0" : : "r" (&retval));
    864c:	e24b300c 	sub	r3, fp, #12
    8650:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:138
    asm volatile("swi 4");
    8654:	ef000004 	svc	0x00000004
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:140

    return retval;
    8658:	e51b300c 	ldr	r3, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:141
}
    865c:	e1a00003 	mov	r0, r3
    8660:	e28bd000 	add	sp, fp, #0
    8664:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8668:	e12fff1e 	bx	lr

0000866c <_Z17set_task_deadlinej>:
_Z17set_task_deadlinej():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:144

void set_task_deadline(uint32_t tick_count_required)
{
    866c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8670:	e28db000 	add	fp, sp, #0
    8674:	e24dd014 	sub	sp, sp, #20
    8678:	e50b0010 	str	r0, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:145
    const NDeadline_Subservice req = NDeadline_Subservice::Set_Relative;
    867c:	e3a03000 	mov	r3, #0
    8680:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:147

    asm volatile("mov r0, %0" : : "r" (req));
    8684:	e3a03000 	mov	r3, #0
    8688:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:148
    asm volatile("mov r1, %0" : : "r" (&tick_count_required));
    868c:	e24b3010 	sub	r3, fp, #16
    8690:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:149
    asm volatile("swi 5");
    8694:	ef000005 	svc	0x00000005
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:150
}
    8698:	e320f000 	nop	{0}
    869c:	e28bd000 	add	sp, fp, #0
    86a0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    86a4:	e12fff1e 	bx	lr

000086a8 <_Z26get_task_ticks_to_deadlinev>:
_Z26get_task_ticks_to_deadlinev():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:153

uint32_t get_task_ticks_to_deadline()
{
    86a8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    86ac:	e28db000 	add	fp, sp, #0
    86b0:	e24dd00c 	sub	sp, sp, #12
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:154
    const NDeadline_Subservice req = NDeadline_Subservice::Get_Remaining;
    86b4:	e3a03001 	mov	r3, #1
    86b8:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:157
    uint32_t ticks;

    asm volatile("mov r0, %0" : : "r" (req));
    86bc:	e3a03001 	mov	r3, #1
    86c0:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:158
    asm volatile("mov r1, %0" : : "r" (&ticks));
    86c4:	e24b300c 	sub	r3, fp, #12
    86c8:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:159
    asm volatile("swi 5");
    86cc:	ef000005 	svc	0x00000005
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:161

    return ticks;
    86d0:	e51b300c 	ldr	r3, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:162
}
    86d4:	e1a00003 	mov	r0, r3
    86d8:	e28bd000 	add	sp, fp, #0
    86dc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    86e0:	e12fff1e 	bx	lr

000086e4 <_Z4pipePKcj>:
_Z4pipePKcj():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:167

const char Pipe_File_Prefix[] = "SYS:pipe/";

uint32_t pipe(const char* name, uint32_t buf_size)
{
    86e4:	e92d4800 	push	{fp, lr}
    86e8:	e28db004 	add	fp, sp, #4
    86ec:	e24dd050 	sub	sp, sp, #80	; 0x50
    86f0:	e50b0050 	str	r0, [fp, #-80]	; 0xffffffb0
    86f4:	e50b1054 	str	r1, [fp, #-84]	; 0xffffffac
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:169
    char fname[64];
    strncpy(fname, Pipe_File_Prefix, sizeof(Pipe_File_Prefix));
    86f8:	e24b3048 	sub	r3, fp, #72	; 0x48
    86fc:	e3a0200a 	mov	r2, #10
    8700:	e59f1088 	ldr	r1, [pc, #136]	; 8790 <_Z4pipePKcj+0xac>
    8704:	e1a00003 	mov	r0, r3
    8708:	eb0000a5 	bl	89a4 <_Z7strncpyPcPKci>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:170
    strncpy(fname + sizeof(Pipe_File_Prefix), name, sizeof(fname) - sizeof(Pipe_File_Prefix) - 1);
    870c:	e24b3048 	sub	r3, fp, #72	; 0x48
    8710:	e283300a 	add	r3, r3, #10
    8714:	e3a02035 	mov	r2, #53	; 0x35
    8718:	e51b1050 	ldr	r1, [fp, #-80]	; 0xffffffb0
    871c:	e1a00003 	mov	r0, r3
    8720:	eb00009f 	bl	89a4 <_Z7strncpyPcPKci>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:172

    int ncur = sizeof(Pipe_File_Prefix) + strlen(name);
    8724:	e51b0050 	ldr	r0, [fp, #-80]	; 0xffffffb0
    8728:	eb0000f8 	bl	8b10 <_Z6strlenPKc>
    872c:	e1a03000 	mov	r3, r0
    8730:	e283300a 	add	r3, r3, #10
    8734:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:174

    fname[ncur++] = '#';
    8738:	e51b3008 	ldr	r3, [fp, #-8]
    873c:	e2832001 	add	r2, r3, #1
    8740:	e50b2008 	str	r2, [fp, #-8]
    8744:	e2433004 	sub	r3, r3, #4
    8748:	e083300b 	add	r3, r3, fp
    874c:	e3a02023 	mov	r2, #35	; 0x23
    8750:	e5432044 	strb	r2, [r3, #-68]	; 0xffffffbc
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:176

    itoa(buf_size, &fname[ncur], 10);
    8754:	e24b2048 	sub	r2, fp, #72	; 0x48
    8758:	e51b3008 	ldr	r3, [fp, #-8]
    875c:	e0823003 	add	r3, r2, r3
    8760:	e3a0200a 	mov	r2, #10
    8764:	e1a01003 	mov	r1, r3
    8768:	e51b0054 	ldr	r0, [fp, #-84]	; 0xffffffac
    876c:	eb000008 	bl	8794 <_Z4itoajPcj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:178

    return open(fname, NFile_Open_Mode::Read_Write);
    8770:	e24b3048 	sub	r3, fp, #72	; 0x48
    8774:	e3a01002 	mov	r1, #2
    8778:	e1a00003 	mov	r0, r3
    877c:	ebffff0a 	bl	83ac <_Z4openPKc15NFile_Open_Mode>
    8780:	e1a03000 	mov	r3, r0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:179
}
    8784:	e1a00003 	mov	r0, r3
    8788:	e24bd004 	sub	sp, fp, #4
    878c:	e8bd8800 	pop	{fp, pc}
    8790:	00009450 	andeq	r9, r0, r0, asr r4

00008794 <_Z4itoajPcj>:
_Z4itoajPcj():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:9
{
    const char CharConvArr[] = "0123456789ABCDEF";
}

void itoa(unsigned int input, char* output, unsigned int base)
{
    8794:	e92d4800 	push	{fp, lr}
    8798:	e28db004 	add	fp, sp, #4
    879c:	e24dd020 	sub	sp, sp, #32
    87a0:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    87a4:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    87a8:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:10
	int i = 0;
    87ac:	e3a03000 	mov	r3, #0
    87b0:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:12

	while (input > 0)
    87b4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    87b8:	e3530000 	cmp	r3, #0
    87bc:	0a000014 	beq	8814 <_Z4itoajPcj+0x80>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:14
	{
		output[i] = CharConvArr[input % base];
    87c0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    87c4:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    87c8:	e1a00003 	mov	r0, r3
    87cc:	eb0002c6 	bl	92ec <__aeabi_uidivmod>
    87d0:	e1a03001 	mov	r3, r1
    87d4:	e1a01003 	mov	r1, r3
    87d8:	e51b3008 	ldr	r3, [fp, #-8]
    87dc:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    87e0:	e0823003 	add	r3, r2, r3
    87e4:	e59f2118 	ldr	r2, [pc, #280]	; 8904 <_Z4itoajPcj+0x170>
    87e8:	e7d22001 	ldrb	r2, [r2, r1]
    87ec:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:15
		input /= base;
    87f0:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    87f4:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    87f8:	eb000240 	bl	9100 <__udivsi3>
    87fc:	e1a03000 	mov	r3, r0
    8800:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:16
		i++;
    8804:	e51b3008 	ldr	r3, [fp, #-8]
    8808:	e2833001 	add	r3, r3, #1
    880c:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:12
	while (input > 0)
    8810:	eaffffe7 	b	87b4 <_Z4itoajPcj+0x20>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:19
	}

    if (i == 0)
    8814:	e51b3008 	ldr	r3, [fp, #-8]
    8818:	e3530000 	cmp	r3, #0
    881c:	1a000007 	bne	8840 <_Z4itoajPcj+0xac>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:21
    {
        output[i] = CharConvArr[0];
    8820:	e51b3008 	ldr	r3, [fp, #-8]
    8824:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8828:	e0823003 	add	r3, r2, r3
    882c:	e3a02030 	mov	r2, #48	; 0x30
    8830:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:22
        i++;
    8834:	e51b3008 	ldr	r3, [fp, #-8]
    8838:	e2833001 	add	r3, r3, #1
    883c:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:25
    }

	output[i] = '\0';
    8840:	e51b3008 	ldr	r3, [fp, #-8]
    8844:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8848:	e0823003 	add	r3, r2, r3
    884c:	e3a02000 	mov	r2, #0
    8850:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:26
	i--;
    8854:	e51b3008 	ldr	r3, [fp, #-8]
    8858:	e2433001 	sub	r3, r3, #1
    885c:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:28

	for (int j = 0; j <= i/2; j++)
    8860:	e3a03000 	mov	r3, #0
    8864:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:28 (discriminator 3)
    8868:	e51b3008 	ldr	r3, [fp, #-8]
    886c:	e1a02fa3 	lsr	r2, r3, #31
    8870:	e0823003 	add	r3, r2, r3
    8874:	e1a030c3 	asr	r3, r3, #1
    8878:	e1a02003 	mov	r2, r3
    887c:	e51b300c 	ldr	r3, [fp, #-12]
    8880:	e1530002 	cmp	r3, r2
    8884:	ca00001b 	bgt	88f8 <_Z4itoajPcj+0x164>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:30 (discriminator 2)
	{
		char c = output[i - j];
    8888:	e51b2008 	ldr	r2, [fp, #-8]
    888c:	e51b300c 	ldr	r3, [fp, #-12]
    8890:	e0423003 	sub	r3, r2, r3
    8894:	e1a02003 	mov	r2, r3
    8898:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    889c:	e0833002 	add	r3, r3, r2
    88a0:	e5d33000 	ldrb	r3, [r3]
    88a4:	e54b300d 	strb	r3, [fp, #-13]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:31 (discriminator 2)
		output[i - j] = output[j];
    88a8:	e51b300c 	ldr	r3, [fp, #-12]
    88ac:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    88b0:	e0822003 	add	r2, r2, r3
    88b4:	e51b1008 	ldr	r1, [fp, #-8]
    88b8:	e51b300c 	ldr	r3, [fp, #-12]
    88bc:	e0413003 	sub	r3, r1, r3
    88c0:	e1a01003 	mov	r1, r3
    88c4:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    88c8:	e0833001 	add	r3, r3, r1
    88cc:	e5d22000 	ldrb	r2, [r2]
    88d0:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:32 (discriminator 2)
		output[j] = c;
    88d4:	e51b300c 	ldr	r3, [fp, #-12]
    88d8:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    88dc:	e0823003 	add	r3, r2, r3
    88e0:	e55b200d 	ldrb	r2, [fp, #-13]
    88e4:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:28 (discriminator 2)
	for (int j = 0; j <= i/2; j++)
    88e8:	e51b300c 	ldr	r3, [fp, #-12]
    88ec:	e2833001 	add	r3, r3, #1
    88f0:	e50b300c 	str	r3, [fp, #-12]
    88f4:	eaffffdb 	b	8868 <_Z4itoajPcj+0xd4>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:34
	}
}
    88f8:	e320f000 	nop	{0}
    88fc:	e24bd004 	sub	sp, fp, #4
    8900:	e8bd8800 	pop	{fp, pc}
    8904:	0000945c 	andeq	r9, r0, ip, asr r4

00008908 <_Z4atoiPKc>:
_Z4atoiPKc():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:37

int atoi(const char* input)
{
    8908:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    890c:	e28db000 	add	fp, sp, #0
    8910:	e24dd014 	sub	sp, sp, #20
    8914:	e50b0010 	str	r0, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:38
	int output = 0;
    8918:	e3a03000 	mov	r3, #0
    891c:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:40

	while (*input != '\0')
    8920:	e51b3010 	ldr	r3, [fp, #-16]
    8924:	e5d33000 	ldrb	r3, [r3]
    8928:	e3530000 	cmp	r3, #0
    892c:	0a000017 	beq	8990 <_Z4atoiPKc+0x88>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:42
	{
		output *= 10;
    8930:	e51b2008 	ldr	r2, [fp, #-8]
    8934:	e1a03002 	mov	r3, r2
    8938:	e1a03103 	lsl	r3, r3, #2
    893c:	e0833002 	add	r3, r3, r2
    8940:	e1a03083 	lsl	r3, r3, #1
    8944:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:43
		if (*input > '9' || *input < '0')
    8948:	e51b3010 	ldr	r3, [fp, #-16]
    894c:	e5d33000 	ldrb	r3, [r3]
    8950:	e3530039 	cmp	r3, #57	; 0x39
    8954:	8a00000d 	bhi	8990 <_Z4atoiPKc+0x88>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:43 (discriminator 1)
    8958:	e51b3010 	ldr	r3, [fp, #-16]
    895c:	e5d33000 	ldrb	r3, [r3]
    8960:	e353002f 	cmp	r3, #47	; 0x2f
    8964:	9a000009 	bls	8990 <_Z4atoiPKc+0x88>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:46
			break;

		output += *input - '0';
    8968:	e51b3010 	ldr	r3, [fp, #-16]
    896c:	e5d33000 	ldrb	r3, [r3]
    8970:	e2433030 	sub	r3, r3, #48	; 0x30
    8974:	e51b2008 	ldr	r2, [fp, #-8]
    8978:	e0823003 	add	r3, r2, r3
    897c:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:48

		input++;
    8980:	e51b3010 	ldr	r3, [fp, #-16]
    8984:	e2833001 	add	r3, r3, #1
    8988:	e50b3010 	str	r3, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:40
	while (*input != '\0')
    898c:	eaffffe3 	b	8920 <_Z4atoiPKc+0x18>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:51
	}

	return output;
    8990:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:52
}
    8994:	e1a00003 	mov	r0, r3
    8998:	e28bd000 	add	sp, fp, #0
    899c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    89a0:	e12fff1e 	bx	lr

000089a4 <_Z7strncpyPcPKci>:
_Z7strncpyPcPKci():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:55

char* strncpy(char* dest, const char *src, int num)
{
    89a4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    89a8:	e28db000 	add	fp, sp, #0
    89ac:	e24dd01c 	sub	sp, sp, #28
    89b0:	e50b0010 	str	r0, [fp, #-16]
    89b4:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    89b8:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:58
	int i;

	for (i = 0; i < num && src[i] != '\0'; i++)
    89bc:	e3a03000 	mov	r3, #0
    89c0:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:58 (discriminator 4)
    89c4:	e51b2008 	ldr	r2, [fp, #-8]
    89c8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    89cc:	e1520003 	cmp	r2, r3
    89d0:	aa000011 	bge	8a1c <_Z7strncpyPcPKci+0x78>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:58 (discriminator 2)
    89d4:	e51b3008 	ldr	r3, [fp, #-8]
    89d8:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    89dc:	e0823003 	add	r3, r2, r3
    89e0:	e5d33000 	ldrb	r3, [r3]
    89e4:	e3530000 	cmp	r3, #0
    89e8:	0a00000b 	beq	8a1c <_Z7strncpyPcPKci+0x78>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:59 (discriminator 3)
		dest[i] = src[i];
    89ec:	e51b3008 	ldr	r3, [fp, #-8]
    89f0:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    89f4:	e0822003 	add	r2, r2, r3
    89f8:	e51b3008 	ldr	r3, [fp, #-8]
    89fc:	e51b1010 	ldr	r1, [fp, #-16]
    8a00:	e0813003 	add	r3, r1, r3
    8a04:	e5d22000 	ldrb	r2, [r2]
    8a08:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:58 (discriminator 3)
	for (i = 0; i < num && src[i] != '\0'; i++)
    8a0c:	e51b3008 	ldr	r3, [fp, #-8]
    8a10:	e2833001 	add	r3, r3, #1
    8a14:	e50b3008 	str	r3, [fp, #-8]
    8a18:	eaffffe9 	b	89c4 <_Z7strncpyPcPKci+0x20>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:60 (discriminator 2)
	for (; i < num; i++)
    8a1c:	e51b2008 	ldr	r2, [fp, #-8]
    8a20:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8a24:	e1520003 	cmp	r2, r3
    8a28:	aa000008 	bge	8a50 <_Z7strncpyPcPKci+0xac>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:61 (discriminator 1)
		dest[i] = '\0';
    8a2c:	e51b3008 	ldr	r3, [fp, #-8]
    8a30:	e51b2010 	ldr	r2, [fp, #-16]
    8a34:	e0823003 	add	r3, r2, r3
    8a38:	e3a02000 	mov	r2, #0
    8a3c:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:60 (discriminator 1)
	for (; i < num; i++)
    8a40:	e51b3008 	ldr	r3, [fp, #-8]
    8a44:	e2833001 	add	r3, r3, #1
    8a48:	e50b3008 	str	r3, [fp, #-8]
    8a4c:	eafffff2 	b	8a1c <_Z7strncpyPcPKci+0x78>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:63

   return dest;
    8a50:	e51b3010 	ldr	r3, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:64
}
    8a54:	e1a00003 	mov	r0, r3
    8a58:	e28bd000 	add	sp, fp, #0
    8a5c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8a60:	e12fff1e 	bx	lr

00008a64 <_Z7strncmpPKcS0_i>:
_Z7strncmpPKcS0_i():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:67

int strncmp(const char *s1, const char *s2, int num)
{
    8a64:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8a68:	e28db000 	add	fp, sp, #0
    8a6c:	e24dd01c 	sub	sp, sp, #28
    8a70:	e50b0010 	str	r0, [fp, #-16]
    8a74:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8a78:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:69
	unsigned char u1, u2;
  	while (num-- > 0)
    8a7c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8a80:	e2432001 	sub	r2, r3, #1
    8a84:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
    8a88:	e3530000 	cmp	r3, #0
    8a8c:	c3a03001 	movgt	r3, #1
    8a90:	d3a03000 	movle	r3, #0
    8a94:	e6ef3073 	uxtb	r3, r3
    8a98:	e3530000 	cmp	r3, #0
    8a9c:	0a000016 	beq	8afc <_Z7strncmpPKcS0_i+0x98>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:71
    {
      	u1 = (unsigned char) *s1++;
    8aa0:	e51b3010 	ldr	r3, [fp, #-16]
    8aa4:	e2832001 	add	r2, r3, #1
    8aa8:	e50b2010 	str	r2, [fp, #-16]
    8aac:	e5d33000 	ldrb	r3, [r3]
    8ab0:	e54b3005 	strb	r3, [fp, #-5]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:72
     	u2 = (unsigned char) *s2++;
    8ab4:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8ab8:	e2832001 	add	r2, r3, #1
    8abc:	e50b2014 	str	r2, [fp, #-20]	; 0xffffffec
    8ac0:	e5d33000 	ldrb	r3, [r3]
    8ac4:	e54b3006 	strb	r3, [fp, #-6]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:73
      	if (u1 != u2)
    8ac8:	e55b2005 	ldrb	r2, [fp, #-5]
    8acc:	e55b3006 	ldrb	r3, [fp, #-6]
    8ad0:	e1520003 	cmp	r2, r3
    8ad4:	0a000003 	beq	8ae8 <_Z7strncmpPKcS0_i+0x84>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:74
        	return u1 - u2;
    8ad8:	e55b2005 	ldrb	r2, [fp, #-5]
    8adc:	e55b3006 	ldrb	r3, [fp, #-6]
    8ae0:	e0423003 	sub	r3, r2, r3
    8ae4:	ea000005 	b	8b00 <_Z7strncmpPKcS0_i+0x9c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:75
      	if (u1 == '\0')
    8ae8:	e55b3005 	ldrb	r3, [fp, #-5]
    8aec:	e3530000 	cmp	r3, #0
    8af0:	1affffe1 	bne	8a7c <_Z7strncmpPKcS0_i+0x18>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:76
        	return 0;
    8af4:	e3a03000 	mov	r3, #0
    8af8:	ea000000 	b	8b00 <_Z7strncmpPKcS0_i+0x9c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:79
    }

  	return 0;
    8afc:	e3a03000 	mov	r3, #0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:80
}
    8b00:	e1a00003 	mov	r0, r3
    8b04:	e28bd000 	add	sp, fp, #0
    8b08:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8b0c:	e12fff1e 	bx	lr

00008b10 <_Z6strlenPKc>:
_Z6strlenPKc():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:83

int strlen(const char* s)
{
    8b10:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8b14:	e28db000 	add	fp, sp, #0
    8b18:	e24dd014 	sub	sp, sp, #20
    8b1c:	e50b0010 	str	r0, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:84
	int i = 0;
    8b20:	e3a03000 	mov	r3, #0
    8b24:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:86

	while (s[i] != '\0')
    8b28:	e51b3008 	ldr	r3, [fp, #-8]
    8b2c:	e51b2010 	ldr	r2, [fp, #-16]
    8b30:	e0823003 	add	r3, r2, r3
    8b34:	e5d33000 	ldrb	r3, [r3]
    8b38:	e3530000 	cmp	r3, #0
    8b3c:	0a000003 	beq	8b50 <_Z6strlenPKc+0x40>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:87
		i++;
    8b40:	e51b3008 	ldr	r3, [fp, #-8]
    8b44:	e2833001 	add	r3, r3, #1
    8b48:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:86
	while (s[i] != '\0')
    8b4c:	eafffff5 	b	8b28 <_Z6strlenPKc+0x18>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:89

	return i;
    8b50:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:90
}
    8b54:	e1a00003 	mov	r0, r3
    8b58:	e28bd000 	add	sp, fp, #0
    8b5c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8b60:	e12fff1e 	bx	lr

00008b64 <_Z5bzeroPvi>:
_Z5bzeroPvi():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:93

void bzero(void* memory, int length)
{
    8b64:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8b68:	e28db000 	add	fp, sp, #0
    8b6c:	e24dd014 	sub	sp, sp, #20
    8b70:	e50b0010 	str	r0, [fp, #-16]
    8b74:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:94
	char* mem = reinterpret_cast<char*>(memory);
    8b78:	e51b3010 	ldr	r3, [fp, #-16]
    8b7c:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:96

	for (int i = 0; i < length; i++)
    8b80:	e3a03000 	mov	r3, #0
    8b84:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:96 (discriminator 3)
    8b88:	e51b2008 	ldr	r2, [fp, #-8]
    8b8c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8b90:	e1520003 	cmp	r2, r3
    8b94:	aa000008 	bge	8bbc <_Z5bzeroPvi+0x58>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:97 (discriminator 2)
		mem[i] = 0;
    8b98:	e51b3008 	ldr	r3, [fp, #-8]
    8b9c:	e51b200c 	ldr	r2, [fp, #-12]
    8ba0:	e0823003 	add	r3, r2, r3
    8ba4:	e3a02000 	mov	r2, #0
    8ba8:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:96 (discriminator 2)
	for (int i = 0; i < length; i++)
    8bac:	e51b3008 	ldr	r3, [fp, #-8]
    8bb0:	e2833001 	add	r3, r3, #1
    8bb4:	e50b3008 	str	r3, [fp, #-8]
    8bb8:	eafffff2 	b	8b88 <_Z5bzeroPvi+0x24>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:98
}
    8bbc:	e320f000 	nop	{0}
    8bc0:	e28bd000 	add	sp, fp, #0
    8bc4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8bc8:	e12fff1e 	bx	lr

00008bcc <_Z6memcpyPKvPvi>:
_Z6memcpyPKvPvi():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:101

void memcpy(const void* src, void* dst, int num)
{
    8bcc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8bd0:	e28db000 	add	fp, sp, #0
    8bd4:	e24dd024 	sub	sp, sp, #36	; 0x24
    8bd8:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8bdc:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    8be0:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:102
	const char* memsrc = reinterpret_cast<const char*>(src);
    8be4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8be8:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:103
	char* memdst = reinterpret_cast<char*>(dst);
    8bec:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8bf0:	e50b3010 	str	r3, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:105

	for (int i = 0; i < num; i++)
    8bf4:	e3a03000 	mov	r3, #0
    8bf8:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:105 (discriminator 3)
    8bfc:	e51b2008 	ldr	r2, [fp, #-8]
    8c00:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8c04:	e1520003 	cmp	r2, r3
    8c08:	aa00000b 	bge	8c3c <_Z6memcpyPKvPvi+0x70>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:106 (discriminator 2)
		memdst[i] = memsrc[i];
    8c0c:	e51b3008 	ldr	r3, [fp, #-8]
    8c10:	e51b200c 	ldr	r2, [fp, #-12]
    8c14:	e0822003 	add	r2, r2, r3
    8c18:	e51b3008 	ldr	r3, [fp, #-8]
    8c1c:	e51b1010 	ldr	r1, [fp, #-16]
    8c20:	e0813003 	add	r3, r1, r3
    8c24:	e5d22000 	ldrb	r2, [r2]
    8c28:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:105 (discriminator 2)
	for (int i = 0; i < num; i++)
    8c2c:	e51b3008 	ldr	r3, [fp, #-8]
    8c30:	e2833001 	add	r3, r3, #1
    8c34:	e50b3008 	str	r3, [fp, #-8]
    8c38:	eaffffef 	b	8bfc <_Z6memcpyPKvPvi+0x30>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:107
}
    8c3c:	e320f000 	nop	{0}
    8c40:	e28bd000 	add	sp, fp, #0
    8c44:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8c48:	e12fff1e 	bx	lr

00008c4c <_ZN13COLED_DisplayC1EPKc>:
_ZN13COLED_DisplayC2EPKc():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdutils/src/oled.cpp:10
#include <drivers/bridges/display_protocol.h>

// tento soubor includujeme jen odtud
#include "oled_font.h"

COLED_Display::COLED_Display(const char* path)
    8c4c:	e92d4800 	push	{fp, lr}
    8c50:	e28db004 	add	fp, sp, #4
    8c54:	e24dd008 	sub	sp, sp, #8
    8c58:	e50b0008 	str	r0, [fp, #-8]
    8c5c:	e50b100c 	str	r1, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdutils/src/oled.cpp:11
    : mHandle{ open(path, NFile_Open_Mode::Write_Only) }, mOpened(false)
    8c60:	e3a01001 	mov	r1, #1
    8c64:	e51b000c 	ldr	r0, [fp, #-12]
    8c68:	ebfffdcf 	bl	83ac <_Z4openPKc15NFile_Open_Mode>
    8c6c:	e1a02000 	mov	r2, r0
    8c70:	e51b3008 	ldr	r3, [fp, #-8]
    8c74:	e5832000 	str	r2, [r3]
    8c78:	e51b3008 	ldr	r3, [fp, #-8]
    8c7c:	e3a02000 	mov	r2, #0
    8c80:	e5c32004 	strb	r2, [r3, #4]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdutils/src/oled.cpp:14
{
    // nastavime priznak dle toho, co vrati open
    mOpened = (mHandle != static_cast<uint32_t>(-1));
    8c84:	e51b3008 	ldr	r3, [fp, #-8]
    8c88:	e5933000 	ldr	r3, [r3]
    8c8c:	e3730001 	cmn	r3, #1
    8c90:	13a03001 	movne	r3, #1
    8c94:	03a03000 	moveq	r3, #0
    8c98:	e6ef2073 	uxtb	r2, r3
    8c9c:	e51b3008 	ldr	r3, [fp, #-8]
    8ca0:	e5c32004 	strb	r2, [r3, #4]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdutils/src/oled.cpp:15
}
    8ca4:	e51b3008 	ldr	r3, [fp, #-8]
    8ca8:	e1a00003 	mov	r0, r3
    8cac:	e24bd004 	sub	sp, fp, #4
    8cb0:	e8bd8800 	pop	{fp, pc}

00008cb4 <_ZN13COLED_DisplayD1Ev>:
_ZN13COLED_DisplayD2Ev():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdutils/src/oled.cpp:17

COLED_Display::~COLED_Display()
    8cb4:	e92d4800 	push	{fp, lr}
    8cb8:	e28db004 	add	fp, sp, #4
    8cbc:	e24dd008 	sub	sp, sp, #8
    8cc0:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdutils/src/oled.cpp:20
{
    // pokud byl displej otevreny, zavreme
    if (mOpened)
    8cc4:	e51b3008 	ldr	r3, [fp, #-8]
    8cc8:	e5d33004 	ldrb	r3, [r3, #4]
    8ccc:	e3530000 	cmp	r3, #0
    8cd0:	0a000006 	beq	8cf0 <_ZN13COLED_DisplayD1Ev+0x3c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdutils/src/oled.cpp:22
    {
        mOpened = false;
    8cd4:	e51b3008 	ldr	r3, [fp, #-8]
    8cd8:	e3a02000 	mov	r2, #0
    8cdc:	e5c32004 	strb	r2, [r3, #4]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdutils/src/oled.cpp:23
        close(mHandle);
    8ce0:	e51b3008 	ldr	r3, [fp, #-8]
    8ce4:	e5933000 	ldr	r3, [r3]
    8ce8:	e1a00003 	mov	r0, r3
    8cec:	ebfffde7 	bl	8490 <_Z5closej>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdutils/src/oled.cpp:25
    }
}
    8cf0:	e51b3008 	ldr	r3, [fp, #-8]
    8cf4:	e1a00003 	mov	r0, r3
    8cf8:	e24bd004 	sub	sp, fp, #4
    8cfc:	e8bd8800 	pop	{fp, pc}

00008d00 <_ZNK13COLED_Display9Is_OpenedEv>:
_ZNK13COLED_Display9Is_OpenedEv():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdutils/src/oled.cpp:28

bool COLED_Display::Is_Opened() const
{
    8d00:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8d04:	e28db000 	add	fp, sp, #0
    8d08:	e24dd00c 	sub	sp, sp, #12
    8d0c:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdutils/src/oled.cpp:29
    return mOpened;
    8d10:	e51b3008 	ldr	r3, [fp, #-8]
    8d14:	e5d33004 	ldrb	r3, [r3, #4]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdutils/src/oled.cpp:30
}
    8d18:	e1a00003 	mov	r0, r3
    8d1c:	e28bd000 	add	sp, fp, #0
    8d20:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8d24:	e12fff1e 	bx	lr

00008d28 <_ZN13COLED_Display5ClearEb>:
_ZN13COLED_Display5ClearEb():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdutils/src/oled.cpp:33

void COLED_Display::Clear(bool clearSet)
{
    8d28:	e92d4800 	push	{fp, lr}
    8d2c:	e28db004 	add	fp, sp, #4
    8d30:	e24dd010 	sub	sp, sp, #16
    8d34:	e50b0010 	str	r0, [fp, #-16]
    8d38:	e1a03001 	mov	r3, r1
    8d3c:	e54b3011 	strb	r3, [fp, #-17]	; 0xffffffef
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdutils/src/oled.cpp:34
    if (!mOpened)
    8d40:	e51b3010 	ldr	r3, [fp, #-16]
    8d44:	e5d33004 	ldrb	r3, [r3, #4]
    8d48:	e2233001 	eor	r3, r3, #1
    8d4c:	e6ef3073 	uxtb	r3, r3
    8d50:	e3530000 	cmp	r3, #0
    8d54:	1a00000f 	bne	8d98 <_ZN13COLED_Display5ClearEb+0x70>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdutils/src/oled.cpp:38
        return;

    TDisplay_Clear_Packet pkt;
	pkt.header.cmd = NDisplay_Command::Clear;
    8d58:	e3a03002 	mov	r3, #2
    8d5c:	e54b3008 	strb	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdutils/src/oled.cpp:39
	pkt.clearSet = clearSet ? 1 : 0;
    8d60:	e55b3011 	ldrb	r3, [fp, #-17]	; 0xffffffef
    8d64:	e3530000 	cmp	r3, #0
    8d68:	0a000001 	beq	8d74 <_ZN13COLED_Display5ClearEb+0x4c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdutils/src/oled.cpp:39 (discriminator 1)
    8d6c:	e3a03001 	mov	r3, #1
    8d70:	ea000000 	b	8d78 <_ZN13COLED_Display5ClearEb+0x50>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdutils/src/oled.cpp:39 (discriminator 2)
    8d74:	e3a03000 	mov	r3, #0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdutils/src/oled.cpp:39 (discriminator 4)
    8d78:	e54b3007 	strb	r3, [fp, #-7]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdutils/src/oled.cpp:40 (discriminator 4)
	write(mHandle, reinterpret_cast<char*>(&pkt), sizeof(pkt));
    8d7c:	e51b3010 	ldr	r3, [fp, #-16]
    8d80:	e5933000 	ldr	r3, [r3]
    8d84:	e24b1008 	sub	r1, fp, #8
    8d88:	e3a02002 	mov	r2, #2
    8d8c:	e1a00003 	mov	r0, r3
    8d90:	ebfffdaa 	bl	8440 <_Z5writejPKcj>
    8d94:	ea000000 	b	8d9c <_ZN13COLED_Display5ClearEb+0x74>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdutils/src/oled.cpp:35
        return;
    8d98:	e320f000 	nop	{0}
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdutils/src/oled.cpp:41
}
    8d9c:	e24bd004 	sub	sp, fp, #4
    8da0:	e8bd8800 	pop	{fp, pc}

00008da4 <_ZN13COLED_Display9Set_PixelEttb>:
_ZN13COLED_Display9Set_PixelEttb():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdutils/src/oled.cpp:44

void COLED_Display::Set_Pixel(uint16_t x, uint16_t y, bool set)
{
    8da4:	e92d4800 	push	{fp, lr}
    8da8:	e28db004 	add	fp, sp, #4
    8dac:	e24dd018 	sub	sp, sp, #24
    8db0:	e50b0010 	str	r0, [fp, #-16]
    8db4:	e1a00001 	mov	r0, r1
    8db8:	e1a01002 	mov	r1, r2
    8dbc:	e1a02003 	mov	r2, r3
    8dc0:	e1a03000 	mov	r3, r0
    8dc4:	e14b31b2 	strh	r3, [fp, #-18]	; 0xffffffee
    8dc8:	e1a03001 	mov	r3, r1
    8dcc:	e14b31b4 	strh	r3, [fp, #-20]	; 0xffffffec
    8dd0:	e1a03002 	mov	r3, r2
    8dd4:	e54b3015 	strb	r3, [fp, #-21]	; 0xffffffeb
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdutils/src/oled.cpp:45
    if (!mOpened)
    8dd8:	e51b3010 	ldr	r3, [fp, #-16]
    8ddc:	e5d33004 	ldrb	r3, [r3, #4]
    8de0:	e2233001 	eor	r3, r3, #1
    8de4:	e6ef3073 	uxtb	r3, r3
    8de8:	e3530000 	cmp	r3, #0
    8dec:	1a000024 	bne	8e84 <_ZN13COLED_Display9Set_PixelEttb+0xe0>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdutils/src/oled.cpp:50
        return;

    // nehospodarny zpusob, jak nastavit pixely, ale pro ted staci
    TDisplay_Draw_Pixel_Array_Packet pkt;
    pkt.header.cmd = NDisplay_Command::Draw_Pixel_Array;
    8df0:	e3a03003 	mov	r3, #3
    8df4:	e54b300c 	strb	r3, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdutils/src/oled.cpp:51
    pkt.count = 1;
    8df8:	e3a03000 	mov	r3, #0
    8dfc:	e3833001 	orr	r3, r3, #1
    8e00:	e54b300b 	strb	r3, [fp, #-11]
    8e04:	e3a03000 	mov	r3, #0
    8e08:	e54b300a 	strb	r3, [fp, #-10]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdutils/src/oled.cpp:52
    pkt.first.x = x;
    8e0c:	e55b3012 	ldrb	r3, [fp, #-18]	; 0xffffffee
    8e10:	e3a02000 	mov	r2, #0
    8e14:	e1823003 	orr	r3, r2, r3
    8e18:	e54b3009 	strb	r3, [fp, #-9]
    8e1c:	e55b3011 	ldrb	r3, [fp, #-17]	; 0xffffffef
    8e20:	e3a02000 	mov	r2, #0
    8e24:	e1823003 	orr	r3, r2, r3
    8e28:	e54b3008 	strb	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdutils/src/oled.cpp:53
    pkt.first.y = y;
    8e2c:	e55b3014 	ldrb	r3, [fp, #-20]	; 0xffffffec
    8e30:	e3a02000 	mov	r2, #0
    8e34:	e1823003 	orr	r3, r2, r3
    8e38:	e54b3007 	strb	r3, [fp, #-7]
    8e3c:	e55b3013 	ldrb	r3, [fp, #-19]	; 0xffffffed
    8e40:	e3a02000 	mov	r2, #0
    8e44:	e1823003 	orr	r3, r2, r3
    8e48:	e54b3006 	strb	r3, [fp, #-6]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdutils/src/oled.cpp:54
    pkt.first.set = set ? 1 : 0;
    8e4c:	e55b3015 	ldrb	r3, [fp, #-21]	; 0xffffffeb
    8e50:	e3530000 	cmp	r3, #0
    8e54:	0a000001 	beq	8e60 <_ZN13COLED_Display9Set_PixelEttb+0xbc>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdutils/src/oled.cpp:54 (discriminator 1)
    8e58:	e3a03001 	mov	r3, #1
    8e5c:	ea000000 	b	8e64 <_ZN13COLED_Display9Set_PixelEttb+0xc0>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdutils/src/oled.cpp:54 (discriminator 2)
    8e60:	e3a03000 	mov	r3, #0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdutils/src/oled.cpp:54 (discriminator 4)
    8e64:	e54b3005 	strb	r3, [fp, #-5]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdutils/src/oled.cpp:55 (discriminator 4)
    write(mHandle, reinterpret_cast<char*>(&pkt), sizeof(pkt));
    8e68:	e51b3010 	ldr	r3, [fp, #-16]
    8e6c:	e5933000 	ldr	r3, [r3]
    8e70:	e24b100c 	sub	r1, fp, #12
    8e74:	e3a02008 	mov	r2, #8
    8e78:	e1a00003 	mov	r0, r3
    8e7c:	ebfffd6f 	bl	8440 <_Z5writejPKcj>
    8e80:	ea000000 	b	8e88 <_ZN13COLED_Display9Set_PixelEttb+0xe4>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdutils/src/oled.cpp:46
        return;
    8e84:	e320f000 	nop	{0}
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdutils/src/oled.cpp:56
}
    8e88:	e24bd004 	sub	sp, fp, #4
    8e8c:	e8bd8800 	pop	{fp, pc}

00008e90 <_ZN13COLED_Display8Put_CharEttc>:
_ZN13COLED_Display8Put_CharEttc():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdutils/src/oled.cpp:59

void COLED_Display::Put_Char(uint16_t x, uint16_t y, char c)
{
    8e90:	e92d4800 	push	{fp, lr}
    8e94:	e28db004 	add	fp, sp, #4
    8e98:	e24dd028 	sub	sp, sp, #40	; 0x28
    8e9c:	e50b0020 	str	r0, [fp, #-32]	; 0xffffffe0
    8ea0:	e1a00001 	mov	r0, r1
    8ea4:	e1a01002 	mov	r1, r2
    8ea8:	e1a02003 	mov	r2, r3
    8eac:	e1a03000 	mov	r3, r0
    8eb0:	e14b32b2 	strh	r3, [fp, #-34]	; 0xffffffde
    8eb4:	e1a03001 	mov	r3, r1
    8eb8:	e14b32b4 	strh	r3, [fp, #-36]	; 0xffffffdc
    8ebc:	e1a03002 	mov	r3, r2
    8ec0:	e54b3025 	strb	r3, [fp, #-37]	; 0xffffffdb
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdutils/src/oled.cpp:60
    if (!mOpened)
    8ec4:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8ec8:	e5d33004 	ldrb	r3, [r3, #4]
    8ecc:	e2233001 	eor	r3, r3, #1
    8ed0:	e6ef3073 	uxtb	r3, r3
    8ed4:	e3530000 	cmp	r3, #0
    8ed8:	1a000040 	bne	8fe0 <_ZN13COLED_Display8Put_CharEttc+0x150>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdutils/src/oled.cpp:64
        return;

    // umime jen nektere znaky
    if (c < OLED_Font::Char_Begin || c >= OLED_Font::Char_End)
    8edc:	e55b3025 	ldrb	r3, [fp, #-37]	; 0xffffffdb
    8ee0:	e353001f 	cmp	r3, #31
    8ee4:	9a00003f 	bls	8fe8 <_ZN13COLED_Display8Put_CharEttc+0x158>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdutils/src/oled.cpp:64 (discriminator 1)
    8ee8:	e15b32d5 	ldrsb	r3, [fp, #-37]	; 0xffffffdb
    8eec:	e3530000 	cmp	r3, #0
    8ef0:	ba00003c 	blt	8fe8 <_ZN13COLED_Display8Put_CharEttc+0x158>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdutils/src/oled.cpp:69
        return;

    char buf[sizeof(TDisplay_Pixels_To_Rect) + OLED_Font::Char_Width];

    TDisplay_Pixels_To_Rect* ptr = reinterpret_cast<TDisplay_Pixels_To_Rect*>(buf);
    8ef4:	e24b301c 	sub	r3, fp, #28
    8ef8:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdutils/src/oled.cpp:70
    ptr->header.cmd = NDisplay_Command::Draw_Pixel_Array_To_Rect;
    8efc:	e51b3008 	ldr	r3, [fp, #-8]
    8f00:	e3a02004 	mov	r2, #4
    8f04:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdutils/src/oled.cpp:71
    ptr->w = OLED_Font::Char_Width;
    8f08:	e51b3008 	ldr	r3, [fp, #-8]
    8f0c:	e3a02000 	mov	r2, #0
    8f10:	e3822006 	orr	r2, r2, #6
    8f14:	e5c32005 	strb	r2, [r3, #5]
    8f18:	e3a02000 	mov	r2, #0
    8f1c:	e5c32006 	strb	r2, [r3, #6]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdutils/src/oled.cpp:72
    ptr->h = OLED_Font::Char_Height;
    8f20:	e51b3008 	ldr	r3, [fp, #-8]
    8f24:	e3a02000 	mov	r2, #0
    8f28:	e3822008 	orr	r2, r2, #8
    8f2c:	e5c32007 	strb	r2, [r3, #7]
    8f30:	e3a02000 	mov	r2, #0
    8f34:	e5c32008 	strb	r2, [r3, #8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdutils/src/oled.cpp:73
    ptr->x1 = x;
    8f38:	e51b3008 	ldr	r3, [fp, #-8]
    8f3c:	e55b2022 	ldrb	r2, [fp, #-34]	; 0xffffffde
    8f40:	e3a01000 	mov	r1, #0
    8f44:	e1812002 	orr	r2, r1, r2
    8f48:	e5c32001 	strb	r2, [r3, #1]
    8f4c:	e55b2021 	ldrb	r2, [fp, #-33]	; 0xffffffdf
    8f50:	e3a01000 	mov	r1, #0
    8f54:	e1812002 	orr	r2, r1, r2
    8f58:	e5c32002 	strb	r2, [r3, #2]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdutils/src/oled.cpp:74
    ptr->y1 = y;
    8f5c:	e51b3008 	ldr	r3, [fp, #-8]
    8f60:	e55b2024 	ldrb	r2, [fp, #-36]	; 0xffffffdc
    8f64:	e3a01000 	mov	r1, #0
    8f68:	e1812002 	orr	r2, r1, r2
    8f6c:	e5c32003 	strb	r2, [r3, #3]
    8f70:	e55b2023 	ldrb	r2, [fp, #-35]	; 0xffffffdd
    8f74:	e3a01000 	mov	r1, #0
    8f78:	e1812002 	orr	r2, r1, r2
    8f7c:	e5c32004 	strb	r2, [r3, #4]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdutils/src/oled.cpp:75
    ptr->vflip = OLED_Font::Flip_Chars ? 1 : 0;
    8f80:	e51b3008 	ldr	r3, [fp, #-8]
    8f84:	e3a02001 	mov	r2, #1
    8f88:	e5c32009 	strb	r2, [r3, #9]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdutils/src/oled.cpp:77
    
    memcpy(&OLED_Font::OLED_Font_Default[OLED_Font::Char_Width * (((uint16_t)c) - OLED_Font::Char_Begin)], &ptr->first, OLED_Font::Char_Width);
    8f8c:	e55b3025 	ldrb	r3, [fp, #-37]	; 0xffffffdb
    8f90:	e2432020 	sub	r2, r3, #32
    8f94:	e1a03002 	mov	r3, r2
    8f98:	e1a03083 	lsl	r3, r3, #1
    8f9c:	e0833002 	add	r3, r3, r2
    8fa0:	e1a03083 	lsl	r3, r3, #1
    8fa4:	e1a02003 	mov	r2, r3
    8fa8:	e59f3044 	ldr	r3, [pc, #68]	; 8ff4 <_ZN13COLED_Display8Put_CharEttc+0x164>
    8fac:	e0820003 	add	r0, r2, r3
    8fb0:	e51b3008 	ldr	r3, [fp, #-8]
    8fb4:	e283300a 	add	r3, r3, #10
    8fb8:	e3a02006 	mov	r2, #6
    8fbc:	e1a01003 	mov	r1, r3
    8fc0:	ebffff01 	bl	8bcc <_Z6memcpyPKvPvi>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdutils/src/oled.cpp:79

    write(mHandle, buf, sizeof(buf));
    8fc4:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8fc8:	e5933000 	ldr	r3, [r3]
    8fcc:	e24b101c 	sub	r1, fp, #28
    8fd0:	e3a02011 	mov	r2, #17
    8fd4:	e1a00003 	mov	r0, r3
    8fd8:	ebfffd18 	bl	8440 <_Z5writejPKcj>
    8fdc:	ea000002 	b	8fec <_ZN13COLED_Display8Put_CharEttc+0x15c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdutils/src/oled.cpp:61
        return;
    8fe0:	e320f000 	nop	{0}
    8fe4:	ea000000 	b	8fec <_ZN13COLED_Display8Put_CharEttc+0x15c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdutils/src/oled.cpp:65
        return;
    8fe8:	e320f000 	nop	{0}
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdutils/src/oled.cpp:80
}
    8fec:	e24bd004 	sub	sp, fp, #4
    8ff0:	e8bd8800 	pop	{fp, pc}
    8ff4:	000094d4 	ldrdeq	r9, [r0], -r4

00008ff8 <_ZN13COLED_Display4FlipEv>:
_ZN13COLED_Display4FlipEv():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdutils/src/oled.cpp:83

void COLED_Display::Flip()
{
    8ff8:	e92d4800 	push	{fp, lr}
    8ffc:	e28db004 	add	fp, sp, #4
    9000:	e24dd010 	sub	sp, sp, #16
    9004:	e50b0010 	str	r0, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdutils/src/oled.cpp:84
    if (!mOpened)
    9008:	e51b3010 	ldr	r3, [fp, #-16]
    900c:	e5d33004 	ldrb	r3, [r3, #4]
    9010:	e2233001 	eor	r3, r3, #1
    9014:	e6ef3073 	uxtb	r3, r3
    9018:	e3530000 	cmp	r3, #0
    901c:	1a000008 	bne	9044 <_ZN13COLED_Display4FlipEv+0x4c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdutils/src/oled.cpp:88
        return;

    TDisplay_NonParametric_Packet pkt;
    pkt.header.cmd = NDisplay_Command::Flip;
    9020:	e3a03001 	mov	r3, #1
    9024:	e54b3008 	strb	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdutils/src/oled.cpp:90

    write(mHandle, reinterpret_cast<char*>(&pkt), sizeof(pkt));
    9028:	e51b3010 	ldr	r3, [fp, #-16]
    902c:	e5933000 	ldr	r3, [r3]
    9030:	e24b1008 	sub	r1, fp, #8
    9034:	e3a02001 	mov	r2, #1
    9038:	e1a00003 	mov	r0, r3
    903c:	ebfffcff 	bl	8440 <_Z5writejPKcj>
    9040:	ea000000 	b	9048 <_ZN13COLED_Display4FlipEv+0x50>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdutils/src/oled.cpp:85
        return;
    9044:	e320f000 	nop	{0}
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdutils/src/oled.cpp:91
}
    9048:	e24bd004 	sub	sp, fp, #4
    904c:	e8bd8800 	pop	{fp, pc}

00009050 <_ZN13COLED_Display10Put_StringEttPKc>:
_ZN13COLED_Display10Put_StringEttPKc():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdutils/src/oled.cpp:94

void COLED_Display::Put_String(uint16_t x, uint16_t y, const char* str)
{
    9050:	e92d4800 	push	{fp, lr}
    9054:	e28db004 	add	fp, sp, #4
    9058:	e24dd018 	sub	sp, sp, #24
    905c:	e50b0010 	str	r0, [fp, #-16]
    9060:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
    9064:	e1a03001 	mov	r3, r1
    9068:	e14b31b2 	strh	r3, [fp, #-18]	; 0xffffffee
    906c:	e1a03002 	mov	r3, r2
    9070:	e14b31b4 	strh	r3, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdutils/src/oled.cpp:95
    if (!mOpened)
    9074:	e51b3010 	ldr	r3, [fp, #-16]
    9078:	e5d33004 	ldrb	r3, [r3, #4]
    907c:	e2233001 	eor	r3, r3, #1
    9080:	e6ef3073 	uxtb	r3, r3
    9084:	e3530000 	cmp	r3, #0
    9088:	1a000019 	bne	90f4 <_ZN13COLED_Display10Put_StringEttPKc+0xa4>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdutils/src/oled.cpp:98
        return;

    uint16_t xi = x;
    908c:	e15b31b2 	ldrh	r3, [fp, #-18]	; 0xffffffee
    9090:	e14b30b6 	strh	r3, [fp, #-6]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdutils/src/oled.cpp:99
    const char* ptr = str;
    9094:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9098:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdutils/src/oled.cpp:101
    // dokud nedojdeme na konec retezce nebo dokud nejsme 64 znaku daleko (limit, kdyby nahodou se neco pokazilo)
    while (*ptr != '\0' && ptr - str < 64)
    909c:	e51b300c 	ldr	r3, [fp, #-12]
    90a0:	e5d33000 	ldrb	r3, [r3]
    90a4:	e3530000 	cmp	r3, #0
    90a8:	0a000012 	beq	90f8 <_ZN13COLED_Display10Put_StringEttPKc+0xa8>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdutils/src/oled.cpp:101 (discriminator 1)
    90ac:	e51b200c 	ldr	r2, [fp, #-12]
    90b0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    90b4:	e0423003 	sub	r3, r2, r3
    90b8:	e353003f 	cmp	r3, #63	; 0x3f
    90bc:	ca00000d 	bgt	90f8 <_ZN13COLED_Display10Put_StringEttPKc+0xa8>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdutils/src/oled.cpp:103
    {
        Put_Char(xi, y, *ptr);
    90c0:	e51b300c 	ldr	r3, [fp, #-12]
    90c4:	e5d33000 	ldrb	r3, [r3]
    90c8:	e15b21b4 	ldrh	r2, [fp, #-20]	; 0xffffffec
    90cc:	e15b10b6 	ldrh	r1, [fp, #-6]
    90d0:	e51b0010 	ldr	r0, [fp, #-16]
    90d4:	ebffff6d 	bl	8e90 <_ZN13COLED_Display8Put_CharEttc>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdutils/src/oled.cpp:104
        xi += OLED_Font::Char_Width;
    90d8:	e15b30b6 	ldrh	r3, [fp, #-6]
    90dc:	e2833006 	add	r3, r3, #6
    90e0:	e14b30b6 	strh	r3, [fp, #-6]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdutils/src/oled.cpp:105
        ptr++;
    90e4:	e51b300c 	ldr	r3, [fp, #-12]
    90e8:	e2833001 	add	r3, r3, #1
    90ec:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdutils/src/oled.cpp:101
    while (*ptr != '\0' && ptr - str < 64)
    90f0:	eaffffe9 	b	909c <_ZN13COLED_Display10Put_StringEttPKc+0x4c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdutils/src/oled.cpp:96
        return;
    90f4:	e320f000 	nop	{0}
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdutils/src/oled.cpp:107
    }
}
    90f8:	e24bd004 	sub	sp, fp, #4
    90fc:	e8bd8800 	pop	{fp, pc}

00009100 <__udivsi3>:
__udivsi3():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1104
    9100:	e2512001 	subs	r2, r1, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1106
    9104:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1107
    9108:	3a000074 	bcc	92e0 <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1108
    910c:	e1500001 	cmp	r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1109
    9110:	9a00006b 	bls	92c4 <__udivsi3+0x1c4>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1110
    9114:	e1110002 	tst	r1, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1111
    9118:	0a00006c 	beq	92d0 <__udivsi3+0x1d0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1113
    911c:	e16f3f10 	clz	r3, r0
    9120:	e16f2f11 	clz	r2, r1
    9124:	e0423003 	sub	r3, r2, r3
    9128:	e273301f 	rsbs	r3, r3, #31
    912c:	10833083 	addne	r3, r3, r3, lsl #1
    9130:	e3a02000 	mov	r2, #0
    9134:	108ff103 	addne	pc, pc, r3, lsl #2
    9138:	e1a00000 	nop			; (mov r0, r0)
    913c:	e1500f81 	cmp	r0, r1, lsl #31
    9140:	e0a22002 	adc	r2, r2, r2
    9144:	20400f81 	subcs	r0, r0, r1, lsl #31
    9148:	e1500f01 	cmp	r0, r1, lsl #30
    914c:	e0a22002 	adc	r2, r2, r2
    9150:	20400f01 	subcs	r0, r0, r1, lsl #30
    9154:	e1500e81 	cmp	r0, r1, lsl #29
    9158:	e0a22002 	adc	r2, r2, r2
    915c:	20400e81 	subcs	r0, r0, r1, lsl #29
    9160:	e1500e01 	cmp	r0, r1, lsl #28
    9164:	e0a22002 	adc	r2, r2, r2
    9168:	20400e01 	subcs	r0, r0, r1, lsl #28
    916c:	e1500d81 	cmp	r0, r1, lsl #27
    9170:	e0a22002 	adc	r2, r2, r2
    9174:	20400d81 	subcs	r0, r0, r1, lsl #27
    9178:	e1500d01 	cmp	r0, r1, lsl #26
    917c:	e0a22002 	adc	r2, r2, r2
    9180:	20400d01 	subcs	r0, r0, r1, lsl #26
    9184:	e1500c81 	cmp	r0, r1, lsl #25
    9188:	e0a22002 	adc	r2, r2, r2
    918c:	20400c81 	subcs	r0, r0, r1, lsl #25
    9190:	e1500c01 	cmp	r0, r1, lsl #24
    9194:	e0a22002 	adc	r2, r2, r2
    9198:	20400c01 	subcs	r0, r0, r1, lsl #24
    919c:	e1500b81 	cmp	r0, r1, lsl #23
    91a0:	e0a22002 	adc	r2, r2, r2
    91a4:	20400b81 	subcs	r0, r0, r1, lsl #23
    91a8:	e1500b01 	cmp	r0, r1, lsl #22
    91ac:	e0a22002 	adc	r2, r2, r2
    91b0:	20400b01 	subcs	r0, r0, r1, lsl #22
    91b4:	e1500a81 	cmp	r0, r1, lsl #21
    91b8:	e0a22002 	adc	r2, r2, r2
    91bc:	20400a81 	subcs	r0, r0, r1, lsl #21
    91c0:	e1500a01 	cmp	r0, r1, lsl #20
    91c4:	e0a22002 	adc	r2, r2, r2
    91c8:	20400a01 	subcs	r0, r0, r1, lsl #20
    91cc:	e1500981 	cmp	r0, r1, lsl #19
    91d0:	e0a22002 	adc	r2, r2, r2
    91d4:	20400981 	subcs	r0, r0, r1, lsl #19
    91d8:	e1500901 	cmp	r0, r1, lsl #18
    91dc:	e0a22002 	adc	r2, r2, r2
    91e0:	20400901 	subcs	r0, r0, r1, lsl #18
    91e4:	e1500881 	cmp	r0, r1, lsl #17
    91e8:	e0a22002 	adc	r2, r2, r2
    91ec:	20400881 	subcs	r0, r0, r1, lsl #17
    91f0:	e1500801 	cmp	r0, r1, lsl #16
    91f4:	e0a22002 	adc	r2, r2, r2
    91f8:	20400801 	subcs	r0, r0, r1, lsl #16
    91fc:	e1500781 	cmp	r0, r1, lsl #15
    9200:	e0a22002 	adc	r2, r2, r2
    9204:	20400781 	subcs	r0, r0, r1, lsl #15
    9208:	e1500701 	cmp	r0, r1, lsl #14
    920c:	e0a22002 	adc	r2, r2, r2
    9210:	20400701 	subcs	r0, r0, r1, lsl #14
    9214:	e1500681 	cmp	r0, r1, lsl #13
    9218:	e0a22002 	adc	r2, r2, r2
    921c:	20400681 	subcs	r0, r0, r1, lsl #13
    9220:	e1500601 	cmp	r0, r1, lsl #12
    9224:	e0a22002 	adc	r2, r2, r2
    9228:	20400601 	subcs	r0, r0, r1, lsl #12
    922c:	e1500581 	cmp	r0, r1, lsl #11
    9230:	e0a22002 	adc	r2, r2, r2
    9234:	20400581 	subcs	r0, r0, r1, lsl #11
    9238:	e1500501 	cmp	r0, r1, lsl #10
    923c:	e0a22002 	adc	r2, r2, r2
    9240:	20400501 	subcs	r0, r0, r1, lsl #10
    9244:	e1500481 	cmp	r0, r1, lsl #9
    9248:	e0a22002 	adc	r2, r2, r2
    924c:	20400481 	subcs	r0, r0, r1, lsl #9
    9250:	e1500401 	cmp	r0, r1, lsl #8
    9254:	e0a22002 	adc	r2, r2, r2
    9258:	20400401 	subcs	r0, r0, r1, lsl #8
    925c:	e1500381 	cmp	r0, r1, lsl #7
    9260:	e0a22002 	adc	r2, r2, r2
    9264:	20400381 	subcs	r0, r0, r1, lsl #7
    9268:	e1500301 	cmp	r0, r1, lsl #6
    926c:	e0a22002 	adc	r2, r2, r2
    9270:	20400301 	subcs	r0, r0, r1, lsl #6
    9274:	e1500281 	cmp	r0, r1, lsl #5
    9278:	e0a22002 	adc	r2, r2, r2
    927c:	20400281 	subcs	r0, r0, r1, lsl #5
    9280:	e1500201 	cmp	r0, r1, lsl #4
    9284:	e0a22002 	adc	r2, r2, r2
    9288:	20400201 	subcs	r0, r0, r1, lsl #4
    928c:	e1500181 	cmp	r0, r1, lsl #3
    9290:	e0a22002 	adc	r2, r2, r2
    9294:	20400181 	subcs	r0, r0, r1, lsl #3
    9298:	e1500101 	cmp	r0, r1, lsl #2
    929c:	e0a22002 	adc	r2, r2, r2
    92a0:	20400101 	subcs	r0, r0, r1, lsl #2
    92a4:	e1500081 	cmp	r0, r1, lsl #1
    92a8:	e0a22002 	adc	r2, r2, r2
    92ac:	20400081 	subcs	r0, r0, r1, lsl #1
    92b0:	e1500001 	cmp	r0, r1
    92b4:	e0a22002 	adc	r2, r2, r2
    92b8:	20400001 	subcs	r0, r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1115
    92bc:	e1a00002 	mov	r0, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1116
    92c0:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1119
    92c4:	03a00001 	moveq	r0, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1120
    92c8:	13a00000 	movne	r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1121
    92cc:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1123
    92d0:	e16f2f11 	clz	r2, r1
    92d4:	e262201f 	rsb	r2, r2, #31
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1125
    92d8:	e1a00230 	lsr	r0, r0, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1126
    92dc:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1130
    92e0:	e3500000 	cmp	r0, #0
    92e4:	13e00000 	mvnne	r0, #0
    92e8:	ea000007 	b	930c <__aeabi_idiv0>

000092ec <__aeabi_uidivmod>:
__aeabi_uidivmod():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1161
    92ec:	e3510000 	cmp	r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1162
    92f0:	0afffffa 	beq	92e0 <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1163
    92f4:	e92d4003 	push	{r0, r1, lr}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1164
    92f8:	ebffff80 	bl	9100 <__udivsi3>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1165
    92fc:	e8bd4006 	pop	{r1, r2, lr}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1166
    9300:	e0030092 	mul	r3, r2, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1167
    9304:	e0411003 	sub	r1, r1, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1168
    9308:	e12fff1e 	bx	lr

0000930c <__aeabi_idiv0>:
__aeabi_ldiv0():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1466
    930c:	e12fff1e 	bx	lr

Disassembly of section .rodata:

00009310 <_ZL13Lock_Unlocked>:
    9310:	00000000 	andeq	r0, r0, r0

00009314 <_ZL11Lock_Locked>:
    9314:	00000001 	andeq	r0, r0, r1

00009318 <_ZL21MaxFSDriverNameLength>:
    9318:	00000010 	andeq	r0, r0, r0, lsl r0

0000931c <_ZL17MaxFilenameLength>:
    931c:	00000010 	andeq	r0, r0, r0, lsl r0

00009320 <_ZL13MaxPathLength>:
    9320:	00000080 	andeq	r0, r0, r0, lsl #1

00009324 <_ZL18NoFilesystemDriver>:
    9324:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009328 <_ZL9NotifyAll>:
    9328:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000932c <_ZL24Max_Process_Opened_Files>:
    932c:	00000010 	andeq	r0, r0, r0, lsl r0

00009330 <_ZL10Indefinite>:
    9330:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009334 <_ZL18Deadline_Unchanged>:
    9334:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00009338 <_ZL14Invalid_Handle>:
    9338:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000933c <_ZN3halL18Default_Clock_RateE>:
    933c:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

00009340 <_ZN3halL15Peripheral_BaseE>:
    9340:	20000000 	andcs	r0, r0, r0

00009344 <_ZN3halL9GPIO_BaseE>:
    9344:	20200000 	eorcs	r0, r0, r0

00009348 <_ZN3halL14GPIO_Pin_CountE>:
    9348:	00000036 	andeq	r0, r0, r6, lsr r0

0000934c <_ZN3halL8AUX_BaseE>:
    934c:	20215000 	eorcs	r5, r1, r0

00009350 <_ZN3halL25Interrupt_Controller_BaseE>:
    9350:	2000b200 	andcs	fp, r0, r0, lsl #4

00009354 <_ZN3halL10Timer_BaseE>:
    9354:	2000b400 	andcs	fp, r0, r0, lsl #8

00009358 <_ZN3halL9TRNG_BaseE>:
    9358:	20104000 	andscs	r4, r0, r0

0000935c <_ZN3halL9BSC0_BaseE>:
    935c:	20205000 	eorcs	r5, r0, r0

00009360 <_ZN3halL9BSC1_BaseE>:
    9360:	20804000 	addcs	r4, r0, r0

00009364 <_ZN3halL9BSC2_BaseE>:
    9364:	20805000 	addcs	r5, r0, r0

00009368 <_ZL11Invalid_Pin>:
    9368:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
    936c:	6c622049 	stclvs	0, cr2, [r2], #-292	; 0xfffffedc
    9370:	2c6b6e69 	stclcs	14, cr6, [fp], #-420	; 0xfffffe5c
    9374:	65687420 	strbvs	r7, [r8, #-1056]!	; 0xfffffbe0
    9378:	6f666572 	svcvs	0x00666572
    937c:	49206572 	stmdbmi	r0!, {r1, r4, r5, r6, r8, sl, sp, lr}
    9380:	2e6d6120 	powcsep	f6, f5, f0
    9384:	00000000 	andeq	r0, r0, r0
    9388:	65732049 	ldrbvs	r2, [r3, #-73]!	; 0xffffffb7
    938c:	65642065 	strbvs	r2, [r4, #-101]!	; 0xffffff9b
    9390:	70206461 	eorvc	r6, r0, r1, ror #8
    9394:	6c657869 	stclvs	8, cr7, [r5], #-420	; 0xfffffe5c
    9398:	00002e73 	andeq	r2, r0, r3, ror lr
    939c:	20656e4f 	rsbcs	r6, r5, pc, asr #28
    93a0:	20555043 	subscs	r5, r5, r3, asr #32
    93a4:	656c7572 	strbvs	r7, [ip, #-1394]!	; 0xfffffa8e
    93a8:	68742073 	ldmdavs	r4!, {r0, r1, r4, r5, r6, sp}^
    93ac:	61206d65 			; <UNDEFINED> instruction: 0x61206d65
    93b0:	002e6c6c 	eoreq	r6, lr, ip, ror #24
    93b4:	6620794d 	strtvs	r7, [r0], -sp, asr #18
    93b8:	756f7661 	strbvc	r7, [pc, #-1633]!	; 8d5f <_ZN13COLED_Display5ClearEb+0x37>
    93bc:	65746972 	ldrbvs	r6, [r4, #-2418]!	; 0xfffff68e
    93c0:	6f707320 	svcvs	0x00707320
    93c4:	69207472 	stmdbvs	r0!, {r1, r4, r5, r6, sl, ip, sp, lr}
    93c8:	52412073 	subpl	r2, r1, #115	; 0x73
    93cc:	7277204d 	rsbsvc	r2, r7, #77	; 0x4d
    93d0:	6c747365 	ldclvs	3, cr7, [r4], #-404	; 0xfffffe6c
    93d4:	00676e69 	rsbeq	r6, r7, r9, ror #28
    93d8:	20646c4f 	rsbcs	r6, r4, pc, asr #24
    93dc:	4463614d 	strbtmi	r6, [r3], #-333	; 0xfffffeb3
    93e0:	6c616e6f 	stclvs	14, cr6, [r1], #-444	; 0xfffffe44
    93e4:	61682064 	cmnvs	r8, r4, rrx
    93e8:	20612064 	rsbcs	r2, r1, r4, rrx
    93ec:	6d726166 	ldfvse	f6, [r2, #-408]!	; 0xfffffe68
    93f0:	4945202c 	stmdbmi	r5, {r2, r3, r5, sp}^
    93f4:	00505247 	subseq	r5, r0, r7, asr #4
    93f8:	3a564544 	bcc	159a910 <__bss_end+0x15911d8>
    93fc:	64656c6f 	strbtvs	r6, [r5], #-3183	; 0xfffff391
    9400:	00000000 	andeq	r0, r0, r0
    9404:	2d56494b 	vldrcs.16	s9, [r6, #-150]	; 0xffffff6a	; <UNPREDICTABLE>
    9408:	534f5452 	movtpl	r5, #62546	; 0xf452
    940c:	696e6920 	stmdbvs	lr!, {r5, r8, fp, sp, lr}^
    9410:	2e2e2e74 	mcrcs	14, 1, r2, cr14, cr4, {3}
    9414:	00000000 	andeq	r0, r0, r0
    9418:	3a564544 	bcc	159a930 <__bss_end+0x15911f8>
    941c:	676e7274 			; <UNDEFINED> instruction: 0x676e7274
    9420:	00000000 	andeq	r0, r0, r0

00009424 <_ZL13Lock_Unlocked>:
    9424:	00000000 	andeq	r0, r0, r0

00009428 <_ZL11Lock_Locked>:
    9428:	00000001 	andeq	r0, r0, r1

0000942c <_ZL21MaxFSDriverNameLength>:
    942c:	00000010 	andeq	r0, r0, r0, lsl r0

00009430 <_ZL17MaxFilenameLength>:
    9430:	00000010 	andeq	r0, r0, r0, lsl r0

00009434 <_ZL13MaxPathLength>:
    9434:	00000080 	andeq	r0, r0, r0, lsl #1

00009438 <_ZL18NoFilesystemDriver>:
    9438:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000943c <_ZL9NotifyAll>:
    943c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009440 <_ZL24Max_Process_Opened_Files>:
    9440:	00000010 	andeq	r0, r0, r0, lsl r0

00009444 <_ZL10Indefinite>:
    9444:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009448 <_ZL18Deadline_Unchanged>:
    9448:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

0000944c <_ZL14Invalid_Handle>:
    944c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009450 <_ZL16Pipe_File_Prefix>:
    9450:	3a535953 	bcc	14df9a4 <__bss_end+0x14d626c>
    9454:	65706970 	ldrbvs	r6, [r0, #-2416]!	; 0xfffff690
    9458:	0000002f 	andeq	r0, r0, pc, lsr #32

0000945c <_ZN12_GLOBAL__N_1L11CharConvArrE>:
    945c:	33323130 	teqcc	r2, #48, 2
    9460:	37363534 			; <UNDEFINED> instruction: 0x37363534
    9464:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    9468:	46454443 	strbmi	r4, [r5], -r3, asr #8
    946c:	00000000 	andeq	r0, r0, r0

00009470 <_ZL13Lock_Unlocked>:
    9470:	00000000 	andeq	r0, r0, r0

00009474 <_ZL11Lock_Locked>:
    9474:	00000001 	andeq	r0, r0, r1

00009478 <_ZL21MaxFSDriverNameLength>:
    9478:	00000010 	andeq	r0, r0, r0, lsl r0

0000947c <_ZL17MaxFilenameLength>:
    947c:	00000010 	andeq	r0, r0, r0, lsl r0

00009480 <_ZL13MaxPathLength>:
    9480:	00000080 	andeq	r0, r0, r0, lsl #1

00009484 <_ZL18NoFilesystemDriver>:
    9484:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009488 <_ZL9NotifyAll>:
    9488:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000948c <_ZL24Max_Process_Opened_Files>:
    948c:	00000010 	andeq	r0, r0, r0, lsl r0

00009490 <_ZL10Indefinite>:
    9490:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009494 <_ZL18Deadline_Unchanged>:
    9494:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00009498 <_ZL14Invalid_Handle>:
    9498:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000949c <_ZN3halL18Default_Clock_RateE>:
    949c:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

000094a0 <_ZN3halL15Peripheral_BaseE>:
    94a0:	20000000 	andcs	r0, r0, r0

000094a4 <_ZN3halL9GPIO_BaseE>:
    94a4:	20200000 	eorcs	r0, r0, r0

000094a8 <_ZN3halL14GPIO_Pin_CountE>:
    94a8:	00000036 	andeq	r0, r0, r6, lsr r0

000094ac <_ZN3halL8AUX_BaseE>:
    94ac:	20215000 	eorcs	r5, r1, r0

000094b0 <_ZN3halL25Interrupt_Controller_BaseE>:
    94b0:	2000b200 	andcs	fp, r0, r0, lsl #4

000094b4 <_ZN3halL10Timer_BaseE>:
    94b4:	2000b400 	andcs	fp, r0, r0, lsl #8

000094b8 <_ZN3halL9TRNG_BaseE>:
    94b8:	20104000 	andscs	r4, r0, r0

000094bc <_ZN3halL9BSC0_BaseE>:
    94bc:	20205000 	eorcs	r5, r0, r0

000094c0 <_ZN3halL9BSC1_BaseE>:
    94c0:	20804000 	addcs	r4, r0, r0

000094c4 <_ZN3halL9BSC2_BaseE>:
    94c4:	20805000 	addcs	r5, r0, r0

000094c8 <_ZN9OLED_FontL10Char_WidthE>:
    94c8:	 	andeq	r0, r8, r6

000094ca <_ZN9OLED_FontL11Char_HeightE>:
    94ca:	 	eoreq	r0, r0, r8

000094cc <_ZN9OLED_FontL10Char_BeginE>:
    94cc:	 	addeq	r0, r0, r0, lsr #32

000094ce <_ZN9OLED_FontL8Char_EndE>:
    94ce:	 	andeq	r0, r1, r0, lsl #1

000094d0 <_ZN9OLED_FontL10Flip_CharsE>:
    94d0:	00000001 	andeq	r0, r0, r1

000094d4 <_ZN9OLED_FontL17OLED_Font_DefaultE>:
	...
    94dc:	00002f00 	andeq	r2, r0, r0, lsl #30
    94e0:	00070000 	andeq	r0, r7, r0
    94e4:	14000007 	strne	r0, [r0], #-7
    94e8:	147f147f 	ldrbtne	r1, [pc], #-1151	; 94f0 <_ZN9OLED_FontL17OLED_Font_DefaultE+0x1c>
    94ec:	7f2a2400 	svcvc	0x002a2400
    94f0:	2300122a 	movwcs	r1, #554	; 0x22a
    94f4:	62640813 	rsbvs	r0, r4, #1245184	; 0x130000
    94f8:	55493600 	strbpl	r3, [r9, #-1536]	; 0xfffffa00
    94fc:	00005022 	andeq	r5, r0, r2, lsr #32
    9500:	00000305 	andeq	r0, r0, r5, lsl #6
    9504:	221c0000 	andscs	r0, ip, #0
    9508:	00000041 	andeq	r0, r0, r1, asr #32
    950c:	001c2241 	andseq	r2, ip, r1, asr #4
    9510:	3e081400 	cfcpyscc	mvf1, mvf8
    9514:	08001408 	stmdaeq	r0, {r3, sl, ip}
    9518:	08083e08 	stmdaeq	r8, {r3, r9, sl, fp, ip, sp}
    951c:	a0000000 	andge	r0, r0, r0
    9520:	08000060 	stmdaeq	r0, {r5, r6}
    9524:	08080808 	stmdaeq	r8, {r3, fp}
    9528:	60600000 	rsbvs	r0, r0, r0
    952c:	20000000 	andcs	r0, r0, r0
    9530:	02040810 	andeq	r0, r4, #16, 16	; 0x100000
    9534:	49513e00 	ldmdbmi	r1, {r9, sl, fp, ip, sp}^
    9538:	00003e45 	andeq	r3, r0, r5, asr #28
    953c:	00407f42 	subeq	r7, r0, r2, asr #30
    9540:	51614200 	cmnpl	r1, r0, lsl #4
    9544:	21004649 	tstcs	r0, r9, asr #12
    9548:	314b4541 	cmpcc	fp, r1, asr #10
    954c:	12141800 	andsne	r1, r4, #0, 16
    9550:	2700107f 	smlsdxcs	r0, pc, r0, r1	; <UNPREDICTABLE>
    9554:	39454545 	stmdbcc	r5, {r0, r2, r6, r8, sl, lr}^
    9558:	494a3c00 	stmdbmi	sl, {sl, fp, ip, sp}^
    955c:	01003049 	tsteq	r0, r9, asr #32
    9560:	03050971 	movweq	r0, #22897	; 0x5971
    9564:	49493600 	stmdbmi	r9, {r9, sl, ip, sp}^
    9568:	06003649 	streq	r3, [r0], -r9, asr #12
    956c:	1e294949 	vnmulne.f16	s8, s18, s18	; <UNPREDICTABLE>
    9570:	36360000 	ldrtcc	r0, [r6], -r0
    9574:	00000000 	andeq	r0, r0, r0
    9578:	00003656 	andeq	r3, r0, r6, asr r6
    957c:	22140800 	andscs	r0, r4, #0, 16
    9580:	14000041 	strne	r0, [r0], #-65	; 0xffffffbf
    9584:	14141414 	ldrne	r1, [r4], #-1044	; 0xfffffbec
    9588:	22410000 	subcs	r0, r1, #0
    958c:	02000814 	andeq	r0, r0, #20, 16	; 0x140000
    9590:	06095101 	streq	r5, [r9], -r1, lsl #2
    9594:	59493200 	stmdbpl	r9, {r9, ip, sp}^
    9598:	7c003e51 	stcvc	14, cr3, [r0], {81}	; 0x51
    959c:	7c121112 	ldfvcs	f1, [r2], {18}
    95a0:	49497f00 	stmdbmi	r9, {r8, r9, sl, fp, ip, sp, lr}^
    95a4:	3e003649 	cfmadd32cc	mvax2, mvfx3, mvfx0, mvfx9
    95a8:	22414141 	subcs	r4, r1, #1073741840	; 0x40000010
    95ac:	41417f00 	cmpmi	r1, r0, lsl #30
    95b0:	7f001c22 	svcvc	0x00001c22
    95b4:	41494949 	cmpmi	r9, r9, asr #18
    95b8:	09097f00 	stmdbeq	r9, {r8, r9, sl, fp, ip, sp, lr}
    95bc:	3e000109 	adfccs	f0, f0, #1.0
    95c0:	7a494941 	bvc	125bacc <__bss_end+0x1252394>
    95c4:	08087f00 	stmdaeq	r8, {r8, r9, sl, fp, ip, sp, lr}
    95c8:	00007f08 	andeq	r7, r0, r8, lsl #30
    95cc:	00417f41 	subeq	r7, r1, r1, asr #30
    95d0:	41402000 	mrsmi	r2, (UNDEF: 64)
    95d4:	7f00013f 	svcvc	0x0000013f
    95d8:	41221408 			; <UNDEFINED> instruction: 0x41221408
    95dc:	40407f00 	submi	r7, r0, r0, lsl #30
    95e0:	7f004040 	svcvc	0x00004040
    95e4:	7f020c02 	svcvc	0x00020c02
    95e8:	08047f00 	stmdaeq	r4, {r8, r9, sl, fp, ip, sp, lr}
    95ec:	3e007f10 	mcrcc	15, 0, r7, cr0, cr0, {0}
    95f0:	3e414141 	dvfccsm	f4, f1, f1
    95f4:	09097f00 	stmdbeq	r9, {r8, r9, sl, fp, ip, sp, lr}
    95f8:	3e000609 	cfmadd32cc	mvax0, mvfx0, mvfx0, mvfx9
    95fc:	5e215141 	sufplsm	f5, f1, f1
    9600:	19097f00 	stmdbne	r9, {r8, r9, sl, fp, ip, sp, lr}
    9604:	46004629 	strmi	r4, [r0], -r9, lsr #12
    9608:	31494949 	cmpcc	r9, r9, asr #18
    960c:	7f010100 	svcvc	0x00010100
    9610:	3f000101 	svccc	0x00000101
    9614:	3f404040 	svccc	0x00404040
    9618:	40201f00 	eormi	r1, r0, r0, lsl #30
    961c:	3f001f20 	svccc	0x00001f20
    9620:	3f403840 	svccc	0x00403840
    9624:	08146300 	ldmdaeq	r4, {r8, r9, sp, lr}
    9628:	07006314 	smladeq	r0, r4, r3, r6
    962c:	07087008 	streq	r7, [r8, -r8]
    9630:	49516100 	ldmdbmi	r1, {r8, sp, lr}^
    9634:	00004345 	andeq	r4, r0, r5, asr #6
    9638:	0041417f 	subeq	r4, r1, pc, ror r1
    963c:	552a5500 	strpl	r5, [sl, #-1280]!	; 0xfffffb00
    9640:	0000552a 	andeq	r5, r0, sl, lsr #10
    9644:	007f4141 	rsbseq	r4, pc, r1, asr #2
    9648:	01020400 	tsteq	r2, r0, lsl #8
    964c:	40000402 	andmi	r0, r0, r2, lsl #8
    9650:	40404040 	submi	r4, r0, r0, asr #32
    9654:	02010000 	andeq	r0, r1, #0
    9658:	20000004 	andcs	r0, r0, r4
    965c:	78545454 	ldmdavc	r4, {r2, r4, r6, sl, ip, lr}^
    9660:	44487f00 	strbmi	r7, [r8], #-3840	; 0xfffff100
    9664:	38003844 	stmdacc	r0, {r2, r6, fp, ip, sp}
    9668:	20444444 	subcs	r4, r4, r4, asr #8
    966c:	44443800 	strbmi	r3, [r4], #-2048	; 0xfffff800
    9670:	38007f48 	stmdacc	r0, {r3, r6, r8, r9, sl, fp, ip, sp, lr}
    9674:	18545454 	ldmdane	r4, {r2, r4, r6, sl, ip, lr}^
    9678:	097e0800 	ldmdbeq	lr!, {fp}^
    967c:	18000201 	stmdane	r0, {r0, r9}
    9680:	7ca4a4a4 	cfstrsvc	mvf10, [r4], #656	; 0x290
    9684:	04087f00 	streq	r7, [r8], #-3840	; 0xfffff100
    9688:	00007804 	andeq	r7, r0, r4, lsl #16
    968c:	00407d44 	subeq	r7, r0, r4, asr #26
    9690:	84804000 	strhi	r4, [r0], #0
    9694:	7f00007d 	svcvc	0x0000007d
    9698:	00442810 	subeq	r2, r4, r0, lsl r8
    969c:	7f410000 	svcvc	0x00410000
    96a0:	7c000040 	stcvc	0, cr0, [r0], {64}	; 0x40
    96a4:	78041804 	stmdavc	r4, {r2, fp, ip}
    96a8:	04087c00 	streq	r7, [r8], #-3072	; 0xfffff400
    96ac:	38007804 	stmdacc	r0, {r2, fp, ip, sp, lr}
    96b0:	38444444 	stmdacc	r4, {r2, r6, sl, lr}^
    96b4:	2424fc00 	strtcs	pc, [r4], #-3072	; 0xfffff400
    96b8:	18001824 	stmdane	r0, {r2, r5, fp, ip}
    96bc:	fc182424 	ldc2	4, cr2, [r8], {36}	; 0x24
    96c0:	04087c00 	streq	r7, [r8], #-3072	; 0xfffff400
    96c4:	48000804 	stmdami	r0, {r2, fp}
    96c8:	20545454 	subscs	r5, r4, r4, asr r4
    96cc:	443f0400 	ldrtmi	r0, [pc], #-1024	; 96d4 <_ZN9OLED_FontL17OLED_Font_DefaultE+0x200>
    96d0:	3c002040 	stccc	0, cr2, [r0], {64}	; 0x40
    96d4:	7c204040 	stcvc	0, cr4, [r0], #-256	; 0xffffff00
    96d8:	40201c00 	eormi	r1, r0, r0, lsl #24
    96dc:	3c001c20 	stccc	12, cr1, [r0], {32}
    96e0:	3c403040 	mcrrcc	0, 4, r3, r0, cr0
    96e4:	10284400 	eorne	r4, r8, r0, lsl #8
    96e8:	1c004428 	cfstrsne	mvf4, [r0], {40}	; 0x28
    96ec:	7ca0a0a0 	stcvc	0, cr10, [r0], #640	; 0x280
    96f0:	54644400 	strbtpl	r4, [r4], #-1024	; 0xfffffc00
    96f4:	0000444c 	andeq	r4, r0, ip, asr #8
    96f8:	00007708 	andeq	r7, r0, r8, lsl #14
    96fc:	7f000000 	svcvc	0x00000000
    9700:	00000000 	andeq	r0, r0, r0
    9704:	00000877 	andeq	r0, r0, r7, ror r8
    9708:	10081000 	andne	r1, r8, r0
    970c:	00000008 	andeq	r0, r0, r8
    9710:	00000000 	andeq	r0, r0, r0

Disassembly of section .data:

00009714 <messages>:
__DTOR_END__():
    9714:	0000936c 	andeq	r9, r0, ip, ror #6
    9718:	00009388 	andeq	r9, r0, r8, lsl #7
    971c:	0000939c 	muleq	r0, ip, r3
    9720:	000093b4 			; <UNDEFINED> instruction: 0x000093b4
    9724:	000093d8 	ldrdeq	r9, [r0], -r8

Disassembly of section .bss:

00009728 <__bss_start>:
	...

Disassembly of section .ARM.attributes:

00000000 <.ARM.attributes>:
   0:	00002e41 	andeq	r2, r0, r1, asr #28
   4:	61656100 	cmnvs	r5, r0, lsl #2
   8:	01006962 	tsteq	r0, r2, ror #18
   c:	00000024 	andeq	r0, r0, r4, lsr #32
  10:	4b5a3605 	blmi	168d82c <__bss_end+0x16840f4>
  14:	08070600 	stmdaeq	r7, {r9, sl}
  18:	0a010901 	beq	42424 <__bss_end+0x38cec>
  1c:	14041202 	strne	r1, [r4], #-514	; 0xfffffdfe
  20:	17011501 	strne	r1, [r1, -r1, lsl #10]
  24:	1a011803 	bne	46038 <__bss_end+0x3c900>
  28:	22011c01 	andcs	r1, r1, #256	; 0x100
  2c:	Address 0x000000000000002c is out of bounds.


Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347 	bcc	10d0d24 <__bss_end+0x10c75ec>
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
  34:	5a2f7374 	bpl	bdce0c <__bss_end+0xbd36d4>
  38:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; fffffeac <__bss_end+0xffff6774>
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
 124:	fb010200 	blx	4092e <__bss_end+0x371f6>
 128:	01000d0e 	tsteq	r0, lr, lsl #26
 12c:	00010101 	andeq	r0, r1, r1, lsl #2
 130:	00010000 	andeq	r0, r1, r0
 134:	6d2f0100 	stfvss	f0, [pc, #-0]	; 13c <shift+0x13c>
 138:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
 13c:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
 140:	4b2f7372 	blmi	bdcf10 <__bss_end+0xbd37d8>
 144:	2f616275 	svccs	0x00616275
 148:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
 14c:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
 150:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
 154:	614d6f72 	hvcvs	55026	; 0xd6f2
 158:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffbec <__bss_end+0xffff64b4>
 15c:	706d6178 	rsbvc	r6, sp, r8, ror r1
 160:	2f73656c 	svccs	0x0073656c
 164:	652d3831 	strvs	r3, [sp, #-2097]!	; 0xfffff7cf
 168:	752f6664 	strvc	r6, [pc, #-1636]!	; fffffb0c <__bss_end+0xffff63d4>
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
 1a0:	0a05830b 	beq	160dd4 <__bss_end+0x15769c>
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
 1cc:	4a030402 	bmi	c11dc <__bss_end+0xb7aa4>
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
 200:	4a020402 	bmi	81210 <__bss_end+0x77ad8>
 204:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
 208:	052d0204 	streq	r0, [sp, #-516]!	; 0xfffffdfc
 20c:	01058509 	tsteq	r5, r9, lsl #10
 210:	000a022f 	andeq	r0, sl, pc, lsr #4
 214:	02fd0101 	rscseq	r0, sp, #1073741824	; 0x40000000
 218:	00030000 	andeq	r0, r3, r0
 21c:	0000029b 	muleq	r0, fp, r2
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
 270:	64656c6f 	strbtvs	r6, [r5], #-3183	; 0xfffff391
 274:	7361745f 	cmnvc	r1, #1593835520	; 0x5f000000
 278:	6d2f006b 	stcvs	0, cr0, [pc, #-428]!	; d4 <shift+0xd4>
 27c:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
 280:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
 284:	4b2f7372 	blmi	bdd054 <__bss_end+0xbd391c>
 288:	2f616275 	svccs	0x00616275
 28c:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
 290:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
 294:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
 298:	614d6f72 	hvcvs	55026	; 0xd6f2
 29c:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffd30 <__bss_end+0xffff65f8>
 2a0:	706d6178 	rsbvc	r6, sp, r8, ror r1
 2a4:	2f73656c 	svccs	0x0073656c
 2a8:	652d3831 	strvs	r3, [sp, #-2097]!	; 0xfffff7cf
 2ac:	752f6664 	strvc	r6, [pc, #-1636]!	; fffffc50 <__bss_end+0xffff6518>
 2b0:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 2b4:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
 2b8:	2f2e2e2f 	svccs	0x002e2e2f
 2bc:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 2c0:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 2c4:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 2c8:	622f6564 	eorvs	r6, pc, #100, 10	; 0x19000000
 2cc:	6472616f 	ldrbtvs	r6, [r2], #-367	; 0xfffffe91
 2d0:	6970722f 	ldmdbvs	r0!, {r0, r1, r2, r3, r5, r9, ip, sp, lr}^
 2d4:	61682f30 	cmnvs	r8, r0, lsr pc
 2d8:	6d2f006c 	stcvs	0, cr0, [pc, #-432]!	; 130 <shift+0x130>
 2dc:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
 2e0:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
 2e4:	4b2f7372 	blmi	bdd0b4 <__bss_end+0xbd397c>
 2e8:	2f616275 	svccs	0x00616275
 2ec:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
 2f0:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
 2f4:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
 2f8:	614d6f72 	hvcvs	55026	; 0xd6f2
 2fc:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffd90 <__bss_end+0xffff6658>
 300:	706d6178 	rsbvc	r6, sp, r8, ror r1
 304:	2f73656c 	svccs	0x0073656c
 308:	652d3831 	strvs	r3, [sp, #-2097]!	; 0xfffff7cf
 30c:	752f6664 	strvc	r6, [pc, #-1636]!	; fffffcb0 <__bss_end+0xffff6578>
 310:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 314:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
 318:	2f2e2e2f 	svccs	0x002e2e2f
 31c:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 320:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 324:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 328:	702f6564 	eorvc	r6, pc, r4, ror #10
 32c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
 330:	2f007373 	svccs	0x00007373
 334:	2f746e6d 	svccs	0x00746e6d
 338:	73552f63 	cmpvc	r5, #396	; 0x18c
 33c:	2f737265 	svccs	0x00737265
 340:	6162754b 	cmnvs	r2, fp, asr #10
 344:	636f442f 	cmnvs	pc, #788529152	; 0x2f000000
 348:	6e656d75 	mcrvs	13, 3, r6, cr5, cr5, {3}
 34c:	5a2f7374 	bpl	bdd124 <__bss_end+0xbd39ec>
 350:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 1c4 <shift+0x1c4>
 354:	2f657461 	svccs	0x00657461
 358:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
 35c:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
 360:	2d38312f 	ldfcss	f3, [r8, #-188]!	; 0xffffff44
 364:	2f666465 	svccs	0x00666465
 368:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
 36c:	63617073 	cmnvs	r1, #115	; 0x73
 370:	2e2e2f65 	cdpcs	15, 2, cr2, cr14, cr5, {3}
 374:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 378:	2f6c656e 	svccs	0x006c656e
 37c:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 380:	2f656475 	svccs	0x00656475
 384:	2f007366 	svccs	0x00007366
 388:	2f746e6d 	svccs	0x00746e6d
 38c:	73552f63 	cmpvc	r5, #396	; 0x18c
 390:	2f737265 	svccs	0x00737265
 394:	6162754b 	cmnvs	r2, fp, asr #10
 398:	636f442f 	cmnvs	pc, #788529152	; 0x2f000000
 39c:	6e656d75 	mcrvs	13, 3, r6, cr5, cr5, {3}
 3a0:	5a2f7374 	bpl	bdd178 <__bss_end+0xbd3a40>
 3a4:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 218 <shift+0x218>
 3a8:	2f657461 	svccs	0x00657461
 3ac:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
 3b0:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
 3b4:	2d38312f 	ldfcss	f3, [r8, #-188]!	; 0xffffff44
 3b8:	2f666465 	svccs	0x00666465
 3bc:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
 3c0:	63617073 	cmnvs	r1, #115	; 0x73
 3c4:	2e2e2f65 	cdpcs	15, 2, cr2, cr14, cr5, {3}
 3c8:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
 3cc:	6c697475 	cfstrdvs	mvd7, [r9], #-468	; 0xfffffe2c
 3d0:	6e692f73 	mcrvs	15, 3, r2, cr9, cr3, {3}
 3d4:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 3d8:	6d2f0065 	stcvs	0, cr0, [pc, #-404]!	; 24c <shift+0x24c>
 3dc:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
 3e0:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
 3e4:	4b2f7372 	blmi	bdd1b4 <__bss_end+0xbd3a7c>
 3e8:	2f616275 	svccs	0x00616275
 3ec:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
 3f0:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
 3f4:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
 3f8:	614d6f72 	hvcvs	55026	; 0xd6f2
 3fc:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffe90 <__bss_end+0xffff6758>
 400:	706d6178 	rsbvc	r6, sp, r8, ror r1
 404:	2f73656c 	svccs	0x0073656c
 408:	652d3831 	strvs	r3, [sp, #-2097]!	; 0xfffff7cf
 40c:	752f6664 	strvc	r6, [pc, #-1636]!	; fffffdb0 <__bss_end+0xffff6678>
 410:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 414:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
 418:	2f2e2e2f 	svccs	0x002e2e2f
 41c:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 420:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 424:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 428:	642f6564 	strtvs	r6, [pc], #-1380	; 430 <shift+0x430>
 42c:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
 430:	00007372 	andeq	r7, r0, r2, ror r3
 434:	6e69616d 	powvsez	f6, f1, #5.0
 438:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
 43c:	00000100 	andeq	r0, r0, r0, lsl #2
 440:	64746e69 	ldrbtvs	r6, [r4], #-3689	; 0xfffff197
 444:	682e6665 	stmdavs	lr!, {r0, r2, r5, r6, r9, sl, sp, lr}
 448:	00000200 	andeq	r0, r0, r0, lsl #4
 44c:	2e697773 	mcrcs	7, 3, r7, cr9, cr3, {3}
 450:	00030068 	andeq	r0, r3, r8, rrx
 454:	69707300 	ldmdbvs	r0!, {r8, r9, ip, sp, lr}^
 458:	636f6c6e 	cmnvs	pc, #28160	; 0x6e00
 45c:	00682e6b 	rsbeq	r2, r8, fp, ror #28
 460:	66000003 	strvs	r0, [r0], -r3
 464:	73656c69 	cmnvc	r5, #26880	; 0x6900
 468:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
 46c:	00682e6d 	rsbeq	r2, r8, sp, ror #28
 470:	70000004 	andvc	r0, r0, r4
 474:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
 478:	682e7373 	stmdavs	lr!, {r0, r1, r4, r5, r6, r8, r9, ip, sp, lr}
 47c:	00000300 	andeq	r0, r0, r0, lsl #6
 480:	636f7270 	cmnvs	pc, #112, 4
 484:	5f737365 	svcpl	0x00737365
 488:	616e616d 	cmnvs	lr, sp, ror #2
 48c:	2e726567 	cdpcs	5, 7, cr6, cr2, cr7, {3}
 490:	00030068 	andeq	r0, r3, r8, rrx
 494:	656c6f00 	strbvs	r6, [ip, #-3840]!	; 0xfffff100
 498:	00682e64 	rsbeq	r2, r8, r4, ror #28
 49c:	70000005 	andvc	r0, r0, r5
 4a0:	70697265 	rsbvc	r7, r9, r5, ror #4
 4a4:	61726568 	cmnvs	r2, r8, ror #10
 4a8:	682e736c 	stmdavs	lr!, {r2, r3, r5, r6, r8, r9, ip, sp, lr}
 4ac:	00000200 	andeq	r0, r0, r0, lsl #4
 4b0:	6f697067 	svcvs	0x00697067
 4b4:	0600682e 	streq	r6, [r0], -lr, lsr #16
 4b8:	05000000 	streq	r0, [r0, #-0]
 4bc:	02050001 	andeq	r0, r5, #1
 4c0:	0000822c 	andeq	r8, r0, ip, lsr #4
 4c4:	05011a03 	streq	r1, [r1, #-2563]	; 0xfffff5fd
 4c8:	0c059f1f 	stceq	15, cr9, [r5], {31}
 4cc:	83110583 	tsthi	r1, #549453824	; 0x20c00000
 4d0:	059f0b05 	ldreq	r0, [pc, #2821]	; fdd <shift+0xfdd>
 4d4:	0b05681b 	bleq	15a548 <__bss_end+0x150e10>
 4d8:	4c070583 	cfstr32mi	mvfx0, [r7], {131}	; 0x83
 4dc:	01040200 	mrseq	r0, R12_usr
 4e0:	0022056b 	eoreq	r0, r2, fp, ror #10
 4e4:	9f010402 	svcls	0x00010402
 4e8:	02000f05 	andeq	r0, r0, #5, 30
 4ec:	05f20104 	ldrbeq	r0, [r2, #260]!	; 0x104
 4f0:	0402000d 	streq	r0, [r2], #-13
 4f4:	12056801 	andne	r6, r5, #65536	; 0x10000
 4f8:	01040200 	mrseq	r0, R12_usr
 4fc:	000c0583 	andeq	r0, ip, r3, lsl #11
 500:	9f010402 	svcls	0x00010402
 504:	02000805 	andeq	r0, r0, #327680	; 0x50000
 508:	05680104 	strbeq	r0, [r8, #-260]!	; 0xfffffefc
 50c:	04020002 	streq	r0, [r2], #-2
 510:	0c026701 	stceq	7, cr6, [r2], {1}
 514:	88010100 	stmdahi	r1, {r8}
 518:	03000002 	movweq	r0, #2
 51c:	00019d00 	andeq	r9, r1, r0, lsl #26
 520:	fb010200 	blx	40d2a <__bss_end+0x375f2>
 524:	01000d0e 	tsteq	r0, lr, lsl #26
 528:	00010101 	andeq	r0, r1, r1, lsl #2
 52c:	00010000 	andeq	r0, r1, r0
 530:	6d2f0100 	stfvss	f0, [pc, #-0]	; 538 <shift+0x538>
 534:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
 538:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
 53c:	4b2f7372 	blmi	bdd30c <__bss_end+0xbd3bd4>
 540:	2f616275 	svccs	0x00616275
 544:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
 548:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
 54c:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
 550:	614d6f72 	hvcvs	55026	; 0xd6f2
 554:	652f6574 	strvs	r6, [pc, #-1396]!	; ffffffe8 <__bss_end+0xffff68b0>
 558:	706d6178 	rsbvc	r6, sp, r8, ror r1
 55c:	2f73656c 	svccs	0x0073656c
 560:	652d3831 	strvs	r3, [sp, #-2097]!	; 0xfffff7cf
 564:	732f6664 			; <UNDEFINED> instruction: 0x732f6664
 568:	696c6474 	stmdbvs	ip!, {r2, r4, r5, r6, sl, sp, lr}^
 56c:	72732f62 	rsbsvc	r2, r3, #392	; 0x188
 570:	6d2f0063 	stcvs	0, cr0, [pc, #-396]!	; 3ec <shift+0x3ec>
 574:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
 578:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
 57c:	4b2f7372 	blmi	bdd34c <__bss_end+0xbd3c14>
 580:	2f616275 	svccs	0x00616275
 584:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
 588:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
 58c:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
 590:	614d6f72 	hvcvs	55026	; 0xd6f2
 594:	652f6574 	strvs	r6, [pc, #-1396]!	; 28 <shift+0x28>
 598:	706d6178 	rsbvc	r6, sp, r8, ror r1
 59c:	2f73656c 	svccs	0x0073656c
 5a0:	652d3831 	strvs	r3, [sp, #-2097]!	; 0xfffff7cf
 5a4:	6b2f6664 	blvs	bd9f3c <__bss_end+0xbd0804>
 5a8:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 5ac:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
 5b0:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 5b4:	72702f65 	rsbsvc	r2, r0, #404	; 0x194
 5b8:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
 5bc:	6d2f0073 	stcvs	0, cr0, [pc, #-460]!	; 3f8 <shift+0x3f8>
 5c0:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
 5c4:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
 5c8:	4b2f7372 	blmi	bdd398 <__bss_end+0xbd3c60>
 5cc:	2f616275 	svccs	0x00616275
 5d0:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
 5d4:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
 5d8:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
 5dc:	614d6f72 	hvcvs	55026	; 0xd6f2
 5e0:	652f6574 	strvs	r6, [pc, #-1396]!	; 74 <shift+0x74>
 5e4:	706d6178 	rsbvc	r6, sp, r8, ror r1
 5e8:	2f73656c 	svccs	0x0073656c
 5ec:	652d3831 	strvs	r3, [sp, #-2097]!	; 0xfffff7cf
 5f0:	6b2f6664 	blvs	bd9f88 <__bss_end+0xbd0850>
 5f4:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 5f8:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
 5fc:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 600:	73662f65 	cmnvc	r6, #404	; 0x194
 604:	6e6d2f00 	cdpvs	15, 6, cr2, cr13, cr0, {0}
 608:	2f632f74 	svccs	0x00632f74
 60c:	72657355 	rsbvc	r7, r5, #1409286145	; 0x54000001
 610:	754b2f73 	strbvc	r2, [fp, #-3955]	; 0xfffff08d
 614:	442f6162 	strtmi	r6, [pc], #-354	; 61c <shift+0x61c>
 618:	6d75636f 	ldclvs	3, cr6, [r5, #-444]!	; 0xfffffe44
 61c:	73746e65 	cmnvc	r4, #1616	; 0x650
 620:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
 624:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
 628:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 62c:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
 630:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
 634:	64652d38 	strbtvs	r2, [r5], #-3384	; 0xfffff2c8
 638:	656b2f66 	strbvs	r2, [fp, #-3942]!	; 0xfffff09a
 63c:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
 640:	636e692f 	cmnvs	lr, #770048	; 0xbc000
 644:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
 648:	616f622f 	cmnvs	pc, pc, lsr #4
 64c:	722f6472 	eorvc	r6, pc, #1912602624	; 0x72000000
 650:	2f306970 	svccs	0x00306970
 654:	006c6168 	rsbeq	r6, ip, r8, ror #2
 658:	64747300 	ldrbtvs	r7, [r4], #-768	; 0xfffffd00
 65c:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
 660:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
 664:	00000100 	andeq	r0, r0, r0, lsl #2
 668:	2e697773 	mcrcs	7, 3, r7, cr9, cr3, {3}
 66c:	00020068 	andeq	r0, r2, r8, rrx
 670:	69707300 	ldmdbvs	r0!, {r8, r9, ip, sp, lr}^
 674:	636f6c6e 	cmnvs	pc, #28160	; 0x6e00
 678:	00682e6b 	rsbeq	r2, r8, fp, ror #28
 67c:	66000002 	strvs	r0, [r0], -r2
 680:	73656c69 	cmnvc	r5, #26880	; 0x6900
 684:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
 688:	00682e6d 	rsbeq	r2, r8, sp, ror #28
 68c:	70000003 	andvc	r0, r0, r3
 690:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
 694:	682e7373 	stmdavs	lr!, {r0, r1, r4, r5, r6, r8, r9, ip, sp, lr}
 698:	00000200 	andeq	r0, r0, r0, lsl #4
 69c:	636f7270 	cmnvs	pc, #112, 4
 6a0:	5f737365 	svcpl	0x00737365
 6a4:	616e616d 	cmnvs	lr, sp, ror #2
 6a8:	2e726567 	cdpcs	5, 7, cr6, cr2, cr7, {3}
 6ac:	00020068 	andeq	r0, r2, r8, rrx
 6b0:	746e6900 	strbtvc	r6, [lr], #-2304	; 0xfffff700
 6b4:	2e666564 	cdpcs	5, 6, cr6, cr6, cr4, {3}
 6b8:	00040068 	andeq	r0, r4, r8, rrx
 6bc:	01050000 	mrseq	r0, (UNDEF: 5)
 6c0:	38020500 	stmdacc	r2, {r8, sl}
 6c4:	16000083 	strne	r0, [r0], -r3, lsl #1
 6c8:	2f690505 	svccs	0x00690505
 6cc:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 6d0:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 6d4:	054b8305 	strbeq	r8, [fp, #-773]	; 0xfffffcfb
 6d8:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 6dc:	01054b05 	tsteq	r5, r5, lsl #22
 6e0:	0505852f 	streq	r8, [r5, #-1327]	; 0xfffffad1
 6e4:	2f4b4ba1 	svccs	0x004b4ba1
 6e8:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 6ec:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 6f0:	4b4bbd05 	blmi	12efb0c <__bss_end+0x12e63d4>
 6f4:	0c052f4b 	stceq	15, cr2, [r5], {75}	; 0x4b
 6f8:	2f01054c 	svccs	0x0001054c
 6fc:	bd050585 	cfstr32lt	mvfx0, [r5, #-532]	; 0xfffffdec
 700:	2f4b4b4b 	svccs	0x004b4b4b
 704:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 708:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 70c:	054b8305 	strbeq	r8, [fp, #-773]	; 0xfffffcfb
 710:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 714:	4b4bbd05 	blmi	12efb30 <__bss_end+0x12e63f8>
 718:	0c052f4b 	stceq	15, cr2, [r5], {75}	; 0x4b
 71c:	2f01054c 	svccs	0x0001054c
 720:	a1050585 	smlabbge	r5, r5, r5, r0
 724:	052f4b4b 	streq	r4, [pc, #-2891]!	; fffffbe1 <__bss_end+0xffff64a9>
 728:	01054c0c 	tsteq	r5, ip, lsl #24
 72c:	0505852f 	streq	r8, [r5, #-1327]	; 0xfffffad1
 730:	4b4b4bbd 	blmi	12d362c <__bss_end+0x12c9ef4>
 734:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
 738:	852f0105 	strhi	r0, [pc, #-261]!	; 63b <shift+0x63b>
 73c:	4ba10505 	blmi	fe841b58 <__bss_end+0xfe838420>
 740:	0c052f4b 	stceq	15, cr2, [r5], {75}	; 0x4b
 744:	9f01054c 	svcls	0x0001054c
 748:	67200585 	strvs	r0, [r0, -r5, lsl #11]!
 74c:	4b4d0505 	blmi	1341b68 <__bss_end+0x1338430>
 750:	300c054b 	andcc	r0, ip, fp, asr #10
 754:	852f0105 	strhi	r0, [pc, #-261]!	; 657 <shift+0x657>
 758:	05672005 	strbeq	r2, [r7, #-5]!
 75c:	4b4b4d05 	blmi	12d3b78 <__bss_end+0x12ca440>
 760:	05300c05 	ldreq	r0, [r0, #-3077]!	; 0xfffff3fb
 764:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 768:	05058320 	streq	r8, [r5, #-800]	; 0xfffffce0
 76c:	054b4b4c 	strbeq	r4, [fp, #-2892]	; 0xfffff4b4
 770:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 774:	05056720 	streq	r6, [r5, #-1824]	; 0xfffff8e0
 778:	054b4b4d 	strbeq	r4, [fp, #-2893]	; 0xfffff4b3
 77c:	0105300c 	tsteq	r5, ip
 780:	0c05872f 	stceq	7, cr8, [r5], {47}	; 0x2f
 784:	31059fa0 	smlatbcc	r5, r0, pc, r9	; <UNPREDICTABLE>
 788:	662905bc 			; <UNDEFINED> instruction: 0x662905bc
 78c:	052e3605 	streq	r3, [lr, #-1541]!	; 0xfffff9fb
 790:	1305300f 	movwne	r3, #20495	; 0x500f
 794:	84090566 	strhi	r0, [r9], #-1382	; 0xfffffa9a
 798:	05d81005 	ldrbeq	r1, [r8, #5]
 79c:	08029f01 	stmdaeq	r2, {r0, r8, r9, sl, fp, ip, pc}
 7a0:	8b010100 	blhi	40ba8 <__bss_end+0x37470>
 7a4:	03000002 	movweq	r0, #2
 7a8:	00006400 	andeq	r6, r0, r0, lsl #8
 7ac:	fb010200 	blx	40fb6 <__bss_end+0x3787e>
 7b0:	01000d0e 	tsteq	r0, lr, lsl #26
 7b4:	00010101 	andeq	r0, r1, r1, lsl #2
 7b8:	00010000 	andeq	r0, r1, r0
 7bc:	6d2f0100 	stfvss	f0, [pc, #-0]	; 7c4 <shift+0x7c4>
 7c0:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
 7c4:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
 7c8:	4b2f7372 	blmi	bdd598 <__bss_end+0xbd3e60>
 7cc:	2f616275 	svccs	0x00616275
 7d0:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
 7d4:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
 7d8:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
 7dc:	614d6f72 	hvcvs	55026	; 0xd6f2
 7e0:	652f6574 	strvs	r6, [pc, #-1396]!	; 274 <shift+0x274>
 7e4:	706d6178 	rsbvc	r6, sp, r8, ror r1
 7e8:	2f73656c 	svccs	0x0073656c
 7ec:	652d3831 	strvs	r3, [sp, #-2097]!	; 0xfffff7cf
 7f0:	732f6664 			; <UNDEFINED> instruction: 0x732f6664
 7f4:	696c6474 	stmdbvs	ip!, {r2, r4, r5, r6, sl, sp, lr}^
 7f8:	72732f62 	rsbsvc	r2, r3, #392	; 0x188
 7fc:	73000063 	movwvc	r0, #99	; 0x63
 800:	74736474 	ldrbtvc	r6, [r3], #-1140	; 0xfffffb8c
 804:	676e6972 			; <UNDEFINED> instruction: 0x676e6972
 808:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
 80c:	00000100 	andeq	r0, r0, r0, lsl #2
 810:	00010500 	andeq	r0, r1, r0, lsl #10
 814:	87940205 	ldrhi	r0, [r4, r5, lsl #4]
 818:	051a0000 	ldreq	r0, [sl, #-0]
 81c:	0f05bb06 	svceq	0x0005bb06
 820:	6821054c 	stmdavs	r1!, {r2, r3, r6, r8, sl}
 824:	05ba0a05 	ldreq	r0, [sl, #2565]!	; 0xa05
 828:	27052e0b 	strcs	r2, [r5, -fp, lsl #28]
 82c:	4a0d054a 	bmi	341d5c <__bss_end+0x338624>
 830:	052f0905 	streq	r0, [pc, #-2309]!	; ffffff33 <__bss_end+0xffff67fb>
 834:	02059f04 	andeq	r9, r5, #4, 30
 838:	35050562 	strcc	r0, [r5, #-1378]	; 0xfffffa9e
 83c:	05681005 	strbeq	r1, [r8, #-5]!
 840:	22052e11 	andcs	r2, r5, #272	; 0x110
 844:	2e13054a 	cfmac32cs	mvfx0, mvfx3, mvfx10
 848:	052f0a05 	streq	r0, [pc, #-2565]!	; fffffe4b <__bss_end+0xffff6713>
 84c:	0a056909 	beq	15ac78 <__bss_end+0x151540>
 850:	4a0c052e 	bmi	301d10 <__bss_end+0x2f85d8>
 854:	054b0305 	strbeq	r0, [fp, #-773]	; 0xfffffcfb
 858:	1805680b 	stmdane	r5, {r0, r1, r3, fp, sp, lr}
 85c:	03040200 	movweq	r0, #16896	; 0x4200
 860:	0014054a 	andseq	r0, r4, sl, asr #10
 864:	9e030402 	cdpls	4, 0, cr0, cr3, cr2, {0}
 868:	02001505 	andeq	r1, r0, #20971520	; 0x1400000
 86c:	05680204 	strbeq	r0, [r8, #-516]!	; 0xfffffdfc
 870:	04020018 	streq	r0, [r2], #-24	; 0xffffffe8
 874:	08058202 	stmdaeq	r5, {r1, r9, pc}
 878:	02040200 	andeq	r0, r4, #0, 4
 87c:	001a054a 	andseq	r0, sl, sl, asr #10
 880:	4b020402 	blmi	81890 <__bss_end+0x78158>
 884:	02001b05 	andeq	r1, r0, #5120	; 0x1400
 888:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
 88c:	0402000c 	streq	r0, [r2], #-12
 890:	0f054a02 	svceq	0x00054a02
 894:	02040200 	andeq	r0, r4, #0, 4
 898:	001b0582 	andseq	r0, fp, r2, lsl #11
 89c:	4a020402 	bmi	818ac <__bss_end+0x78174>
 8a0:	02001105 	andeq	r1, r0, #1073741825	; 0x40000001
 8a4:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
 8a8:	0402000a 	streq	r0, [r2], #-10
 8ac:	0b052f02 	bleq	14c4bc <__bss_end+0x142d84>
 8b0:	02040200 	andeq	r0, r4, #0, 4
 8b4:	000d052e 	andeq	r0, sp, lr, lsr #10
 8b8:	4a020402 	bmi	818c8 <__bss_end+0x78190>
 8bc:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
 8c0:	05460204 	strbeq	r0, [r6, #-516]	; 0xfffffdfc
 8c4:	05858801 	streq	r8, [r5, #2049]	; 0x801
 8c8:	09058306 	stmdbeq	r5, {r1, r2, r8, r9, pc}
 8cc:	4a10054c 	bmi	401e04 <__bss_end+0x3f86cc>
 8d0:	054c0a05 	strbeq	r0, [ip, #-2565]	; 0xfffff5fb
 8d4:	0305bb07 	movweq	fp, #23303	; 0x5b07
 8d8:	0017054a 	andseq	r0, r7, sl, asr #10
 8dc:	4a010402 	bmi	418ec <__bss_end+0x381b4>
 8e0:	02001405 	andeq	r1, r0, #83886080	; 0x5000000
 8e4:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
 8e8:	14054d0d 	strne	r4, [r5], #-3341	; 0xfffff2f3
 8ec:	2e0a054a 	cfsh32cs	mvfx0, mvfx10, #42
 8f0:	05680805 	strbeq	r0, [r8, #-2053]!	; 0xfffff7fb
 8f4:	66780302 	ldrbtvs	r0, [r8], -r2, lsl #6
 8f8:	0b030905 	bleq	c2d14 <__bss_end+0xb95dc>
 8fc:	2f01052e 	svccs	0x0001052e
 900:	bd090585 	cfstr32lt	mvfx0, [r9, #-532]	; 0xfffffdec
 904:	02001605 	andeq	r1, r0, #5242880	; 0x500000
 908:	054a0404 	strbeq	r0, [sl, #-1028]	; 0xfffffbfc
 90c:	0402001d 	streq	r0, [r2], #-29	; 0xffffffe3
 910:	1e058202 	cdpne	2, 0, cr8, cr5, cr2, {0}
 914:	02040200 	andeq	r0, r4, #0, 4
 918:	0016052e 	andseq	r0, r6, lr, lsr #10
 91c:	66020402 	strvs	r0, [r2], -r2, lsl #8
 920:	02001105 	andeq	r1, r0, #1073741825	; 0x40000001
 924:	054b0304 	strbeq	r0, [fp, #-772]	; 0xfffffcfc
 928:	04020012 	streq	r0, [r2], #-18	; 0xffffffee
 92c:	08052e03 	stmdaeq	r5, {r0, r1, r9, sl, fp, sp}
 930:	03040200 	movweq	r0, #16896	; 0x4200
 934:	0009054a 	andeq	r0, r9, sl, asr #10
 938:	2e030402 	cdpcs	4, 0, cr0, cr3, cr2, {0}
 93c:	02001205 	andeq	r1, r0, #1342177280	; 0x50000000
 940:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
 944:	0402000b 	streq	r0, [r2], #-11
 948:	02052e03 	andeq	r2, r5, #3, 28	; 0x30
 94c:	03040200 	movweq	r0, #16896	; 0x4200
 950:	000b052d 	andeq	r0, fp, sp, lsr #10
 954:	84020402 	strhi	r0, [r2], #-1026	; 0xfffffbfe
 958:	02000805 	andeq	r0, r0, #327680	; 0x50000
 95c:	05830104 	streq	r0, [r3, #260]	; 0x104
 960:	04020009 	streq	r0, [r2], #-9
 964:	0b052e01 	bleq	14c170 <__bss_end+0x142a38>
 968:	01040200 	mrseq	r0, R12_usr
 96c:	0002054a 	andeq	r0, r2, sl, asr #10
 970:	49010402 	stmdbmi	r1, {r1, sl}
 974:	05850b05 	streq	r0, [r5, #2821]	; 0xb05
 978:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 97c:	1105bc0e 	tstne	r5, lr, lsl #24
 980:	bc200566 	cfstr32lt	mvfx0, [r0], #-408	; 0xfffffe68
 984:	05660b05 	strbeq	r0, [r6, #-2821]!	; 0xfffff4fb
 988:	0a054b1f 	beq	15360c <__bss_end+0x149ed4>
 98c:	4b080566 	blmi	201f2c <__bss_end+0x1f87f4>
 990:	05831105 	streq	r1, [r3, #261]	; 0x105
 994:	08052e16 	stmdaeq	r5, {r1, r2, r4, r9, sl, fp, sp}
 998:	67110567 	ldrvs	r0, [r1, -r7, ror #10]
 99c:	054d0b05 	strbeq	r0, [sp, #-2821]	; 0xfffff4fb
 9a0:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 9a4:	0b058306 	bleq	1615c4 <__bss_end+0x157e8c>
 9a8:	2e0c054c 	cfsh32cs	mvfx0, mvfx12, #44
 9ac:	05660e05 	strbeq	r0, [r6, #-3589]!	; 0xfffff1fb
 9b0:	02054b04 	andeq	r4, r5, #4, 22	; 0x1000
 9b4:	31090565 	tstcc	r9, r5, ror #10
 9b8:	852f0105 	strhi	r0, [pc, #-261]!	; 8bb <shift+0x8bb>
 9bc:	059f0805 	ldreq	r0, [pc, #2053]	; 11c9 <shift+0x11c9>
 9c0:	14054c0b 	strne	r4, [r5], #-3083	; 0xfffff3f5
 9c4:	03040200 	movweq	r0, #16896	; 0x4200
 9c8:	0007054a 	andeq	r0, r7, sl, asr #10
 9cc:	83020402 	movwhi	r0, #9218	; 0x2402
 9d0:	02000805 	andeq	r0, r0, #327680	; 0x50000
 9d4:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
 9d8:	0402000a 	streq	r0, [r2], #-10
 9dc:	02054a02 	andeq	r4, r5, #8192	; 0x2000
 9e0:	02040200 	andeq	r0, r4, #0, 4
 9e4:	84010549 	strhi	r0, [r1], #-1353	; 0xfffffab7
 9e8:	bb0e0585 	bllt	382004 <__bss_end+0x3788cc>
 9ec:	054b0805 	strbeq	r0, [fp, #-2053]	; 0xfffff7fb
 9f0:	14054c0b 	strne	r4, [r5], #-3083	; 0xfffff3f5
 9f4:	03040200 	movweq	r0, #16896	; 0x4200
 9f8:	0016054a 	andseq	r0, r6, sl, asr #10
 9fc:	83020402 	movwhi	r0, #9218	; 0x2402
 a00:	02001705 	andeq	r1, r0, #1310720	; 0x140000
 a04:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
 a08:	0402000a 	streq	r0, [r2], #-10
 a0c:	0b054a02 	bleq	15321c <__bss_end+0x149ae4>
 a10:	02040200 	andeq	r0, r4, #0, 4
 a14:	0017052e 	andseq	r0, r7, lr, lsr #10
 a18:	4a020402 	bmi	81a28 <__bss_end+0x782f0>
 a1c:	02000d05 	andeq	r0, r0, #320	; 0x140
 a20:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
 a24:	04020002 	streq	r0, [r2], #-2
 a28:	01052d02 	tsteq	r5, r2, lsl #26
 a2c:	00080284 	andeq	r0, r8, r4, lsl #5
 a30:	03b80101 			; <UNDEFINED> instruction: 0x03b80101
 a34:	00030000 	andeq	r0, r3, r0
 a38:	00000276 	andeq	r0, r0, r6, ror r2
 a3c:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
 a40:	0101000d 	tsteq	r1, sp
 a44:	00000101 	andeq	r0, r0, r1, lsl #2
 a48:	00000100 	andeq	r0, r0, r0, lsl #2
 a4c:	6e6d2f01 	cdpvs	15, 6, cr2, cr13, cr1, {0}
 a50:	2f632f74 	svccs	0x00632f74
 a54:	72657355 	rsbvc	r7, r5, #1409286145	; 0x54000001
 a58:	754b2f73 	strbvc	r2, [fp, #-3955]	; 0xfffff08d
 a5c:	442f6162 	strtmi	r6, [pc], #-354	; a64 <shift+0xa64>
 a60:	6d75636f 	ldclvs	3, cr6, [r5, #-444]!	; 0xfffffe44
 a64:	73746e65 	cmnvc	r4, #1616	; 0x650
 a68:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
 a6c:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
 a70:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 a74:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
 a78:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
 a7c:	64652d38 	strbtvs	r2, [r5], #-3384	; 0xfffff2c8
 a80:	74732f66 	ldrbtvc	r2, [r3], #-3942	; 0xfffff09a
 a84:	69747564 	ldmdbvs	r4!, {r2, r5, r6, r8, sl, ip, sp, lr}^
 a88:	732f736c 			; <UNDEFINED> instruction: 0x732f736c
 a8c:	2f006372 	svccs	0x00006372
 a90:	2f746e6d 	svccs	0x00746e6d
 a94:	73552f63 	cmpvc	r5, #396	; 0x18c
 a98:	2f737265 	svccs	0x00737265
 a9c:	6162754b 	cmnvs	r2, fp, asr #10
 aa0:	636f442f 	cmnvs	pc, #788529152	; 0x2f000000
 aa4:	6e656d75 	mcrvs	13, 3, r6, cr5, cr5, {3}
 aa8:	5a2f7374 	bpl	bdd880 <__bss_end+0xbd4148>
 aac:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 920 <shift+0x920>
 ab0:	2f657461 	svccs	0x00657461
 ab4:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
 ab8:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
 abc:	2d38312f 	ldfcss	f3, [r8, #-188]!	; 0xffffff44
 ac0:	2f666465 	svccs	0x00666465
 ac4:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 ac8:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 acc:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 ad0:	622f6564 	eorvs	r6, pc, #100, 10	; 0x19000000
 ad4:	6472616f 	ldrbtvs	r6, [r2], #-367	; 0xfffffe91
 ad8:	6970722f 	ldmdbvs	r0!, {r0, r1, r2, r3, r5, r9, ip, sp, lr}^
 adc:	61682f30 	cmnvs	r8, r0, lsr pc
 ae0:	6d2f006c 	stcvs	0, cr0, [pc, #-432]!	; 938 <shift+0x938>
 ae4:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
 ae8:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
 aec:	4b2f7372 	blmi	bdd8bc <__bss_end+0xbd4184>
 af0:	2f616275 	svccs	0x00616275
 af4:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
 af8:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
 afc:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
 b00:	614d6f72 	hvcvs	55026	; 0xd6f2
 b04:	652f6574 	strvs	r6, [pc, #-1396]!	; 598 <shift+0x598>
 b08:	706d6178 	rsbvc	r6, sp, r8, ror r1
 b0c:	2f73656c 	svccs	0x0073656c
 b10:	652d3831 	strvs	r3, [sp, #-2097]!	; 0xfffff7cf
 b14:	732f6664 			; <UNDEFINED> instruction: 0x732f6664
 b18:	74756474 	ldrbtvc	r6, [r5], #-1140	; 0xfffffb8c
 b1c:	2f736c69 	svccs	0x00736c69
 b20:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 b24:	00656475 	rsbeq	r6, r5, r5, ror r4
 b28:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
 b2c:	552f632f 	strpl	r6, [pc, #-815]!	; 805 <shift+0x805>
 b30:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 b34:	62754b2f 	rsbsvs	r4, r5, #48128	; 0xbc00
 b38:	6f442f61 	svcvs	0x00442f61
 b3c:	656d7563 	strbvs	r7, [sp, #-1379]!	; 0xfffffa9d
 b40:	2f73746e 	svccs	0x0073746e
 b44:	6f72655a 	svcvs	0x0072655a
 b48:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
 b4c:	6178652f 	cmnvs	r8, pc, lsr #10
 b50:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
 b54:	38312f73 	ldmdacc	r1!, {r0, r1, r4, r5, r6, r8, r9, sl, fp, sp}
 b58:	6664652d 	strbtvs	r6, [r4], -sp, lsr #10
 b5c:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 b60:	2f6c656e 	svccs	0x006c656e
 b64:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 b68:	2f656475 	svccs	0x00656475
 b6c:	636f7270 	cmnvs	pc, #112, 4
 b70:	00737365 	rsbseq	r7, r3, r5, ror #6
 b74:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
 b78:	552f632f 	strpl	r6, [pc, #-815]!	; 851 <shift+0x851>
 b7c:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 b80:	62754b2f 	rsbsvs	r4, r5, #48128	; 0xbc00
 b84:	6f442f61 	svcvs	0x00442f61
 b88:	656d7563 	strbvs	r7, [sp, #-1379]!	; 0xfffffa9d
 b8c:	2f73746e 	svccs	0x0073746e
 b90:	6f72655a 	svcvs	0x0072655a
 b94:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
 b98:	6178652f 	cmnvs	r8, pc, lsr #10
 b9c:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
 ba0:	38312f73 	ldmdacc	r1!, {r0, r1, r4, r5, r6, r8, r9, sl, fp, sp}
 ba4:	6664652d 	strbtvs	r6, [r4], -sp, lsr #10
 ba8:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 bac:	2f6c656e 	svccs	0x006c656e
 bb0:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 bb4:	2f656475 	svccs	0x00656475
 bb8:	2f007366 	svccs	0x00007366
 bbc:	2f746e6d 	svccs	0x00746e6d
 bc0:	73552f63 	cmpvc	r5, #396	; 0x18c
 bc4:	2f737265 	svccs	0x00737265
 bc8:	6162754b 	cmnvs	r2, fp, asr #10
 bcc:	636f442f 	cmnvs	pc, #788529152	; 0x2f000000
 bd0:	6e656d75 	mcrvs	13, 3, r6, cr5, cr5, {3}
 bd4:	5a2f7374 	bpl	bdd9ac <__bss_end+0xbd4274>
 bd8:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; a4c <shift+0xa4c>
 bdc:	2f657461 	svccs	0x00657461
 be0:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
 be4:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
 be8:	2d38312f 	ldfcss	f3, [r8, #-188]!	; 0xffffff44
 bec:	2f666465 	svccs	0x00666465
 bf0:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 bf4:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 bf8:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 bfc:	642f6564 	strtvs	r6, [pc], #-1380	; c04 <shift+0xc04>
 c00:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
 c04:	622f7372 	eorvs	r7, pc, #-939524095	; 0xc8000001
 c08:	67646972 			; <UNDEFINED> instruction: 0x67646972
 c0c:	00007365 	andeq	r7, r0, r5, ror #6
 c10:	64656c6f 	strbtvs	r6, [r5], #-3183	; 0xfffff391
 c14:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
 c18:	00000100 	andeq	r0, r0, r0, lsl #2
 c1c:	64746e69 	ldrbtvs	r6, [r4], #-3689	; 0xfffff197
 c20:	682e6665 	stmdavs	lr!, {r0, r2, r5, r6, r9, sl, sp, lr}
 c24:	00000200 	andeq	r0, r0, r0, lsl #4
 c28:	64656c6f 	strbtvs	r6, [r5], #-3183	; 0xfffff391
 c2c:	0300682e 	movweq	r6, #2094	; 0x82e
 c30:	77730000 	ldrbvc	r0, [r3, -r0]!
 c34:	00682e69 	rsbeq	r2, r8, r9, ror #28
 c38:	73000004 	movwvc	r0, #4
 c3c:	6c6e6970 			; <UNDEFINED> instruction: 0x6c6e6970
 c40:	2e6b636f 	cdpcs	3, 6, cr6, cr11, cr15, {3}
 c44:	00040068 	andeq	r0, r4, r8, rrx
 c48:	6c696600 	stclvs	6, cr6, [r9], #-0
 c4c:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
 c50:	2e6d6574 	mcrcs	5, 3, r6, cr13, cr4, {3}
 c54:	00050068 	andeq	r0, r5, r8, rrx
 c58:	6f727000 	svcvs	0x00727000
 c5c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
 c60:	0400682e 	streq	r6, [r0], #-2094	; 0xfffff7d2
 c64:	72700000 	rsbsvc	r0, r0, #0
 c68:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
 c6c:	616d5f73 	smcvs	54771	; 0xd5f3
 c70:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
 c74:	00682e72 	rsbeq	r2, r8, r2, ror lr
 c78:	64000004 	strvs	r0, [r0], #-4
 c7c:	6c707369 	ldclvs	3, cr7, [r0], #-420	; 0xfffffe5c
 c80:	705f7961 	subsvc	r7, pc, r1, ror #18
 c84:	6f746f72 	svcvs	0x00746f72
 c88:	2e6c6f63 	cdpcs	15, 6, cr6, cr12, cr3, {3}
 c8c:	00060068 	andeq	r0, r6, r8, rrx
 c90:	72657000 	rsbvc	r7, r5, #0
 c94:	65687069 	strbvs	r7, [r8, #-105]!	; 0xffffff97
 c98:	736c6172 	cmnvc	ip, #-2147483620	; 0x8000001c
 c9c:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 ca0:	6c6f0000 	stclvs	0, cr0, [pc], #-0	; ca8 <shift+0xca8>
 ca4:	665f6465 	ldrbvs	r6, [pc], -r5, ror #8
 ca8:	2e746e6f 	cdpcs	14, 7, cr6, cr4, cr15, {3}
 cac:	00010068 	andeq	r0, r1, r8, rrx
 cb0:	01050000 	mrseq	r0, (UNDEF: 5)
 cb4:	4c020500 	cfstr32mi	mvfx0, [r2], {-0}
 cb8:	0300008c 	movweq	r0, #140	; 0x8c
 cbc:	14050109 	strne	r0, [r5], #-265	; 0xfffffef7
 cc0:	8248059f 	subhi	r0, r8, #666894336	; 0x27c00000
 cc4:	05a11005 	streq	r1, [r1, #5]!
 cc8:	0d054a18 	vstreq	s8, [r5, #-96]	; 0xffffffa0
 ccc:	4b010582 	blmi	422dc <__bss_end+0x38ba4>
 cd0:	85090584 	strhi	r0, [r9, #-1412]	; 0xfffffa7c
 cd4:	054a0505 	strbeq	r0, [sl, #-1285]	; 0xfffffafb
 cd8:	0e054c11 	mcreq	12, 0, r4, cr5, cr1, {0}
 cdc:	84010567 	strhi	r0, [r1], #-1383	; 0xfffffa99
 ce0:	830c0585 	movwhi	r0, #50565	; 0xc585
 ce4:	854b0105 	strbhi	r0, [fp, #-261]	; 0xfffffefb
 ce8:	05bb0a05 	ldreq	r0, [fp, #2565]!	; 0xa05
 cec:	05054a09 	streq	r4, [r5, #-2569]	; 0xfffff5f7
 cf0:	4e11054a 	cfmac32mi	mvfx0, mvfx1, mvfx10
 cf4:	004b0f05 	subeq	r0, fp, r5, lsl #30
 cf8:	06010402 	streq	r0, [r1], -r2, lsl #8
 cfc:	04020066 	streq	r0, [r2], #-102	; 0xffffff9a
 d00:	02004a02 	andeq	r4, r0, #8192	; 0x2000
 d04:	052e0404 	streq	r0, [lr, #-1028]!	; 0xfffffbfc
 d08:	04020007 	streq	r0, [r2], #-7
 d0c:	052f0604 	streq	r0, [pc, #-1540]!	; 710 <shift+0x710>
 d10:	0105d109 	tsteq	r5, r9, lsl #2
 d14:	0a054d34 	beq	1541ec <__bss_end+0x14aab4>
 d18:	09059108 	stmdbeq	r5, {r3, r8, ip, pc}
 d1c:	4a05054a 	bmi	14224c <__bss_end+0x138b14>
 d20:	054f1405 	strbeq	r1, [pc, #-1029]	; 923 <shift+0x923>
 d24:	11054b0f 	tstne	r5, pc, lsl #22
 d28:	1305f39f 	movwne	pc, #21407	; 0x539f	; <UNPREDICTABLE>
 d2c:	040200f3 	streq	r0, [r2], #-243	; 0xffffff0d
 d30:	00660601 	rsbeq	r0, r6, r1, lsl #12
 d34:	4a020402 	bmi	81d44 <__bss_end+0x7860c>
 d38:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
 d3c:	000a052e 	andeq	r0, sl, lr, lsr #10
 d40:	06040402 	streq	r0, [r4], -r2, lsl #8
 d44:	0309052f 	movweq	r0, #38191	; 0x952f
 d48:	0105d677 	tsteq	r5, r7, ror r6
 d4c:	4d2e0a03 	vstmdbmi	lr!, {s0-s2}
 d50:	91080a05 	tstls	r8, r5, lsl #20
 d54:	054a0905 	strbeq	r0, [sl, #-2309]	; 0xfffff6fb
 d58:	054e4a05 	strbeq	r4, [lr, #-2565]	; 0xfffff5fb
 d5c:	04020028 	streq	r0, [r2], #-40	; 0xffffffd8
 d60:	23056601 	movwcs	r6, #22017	; 0x5601
 d64:	01040200 	mrseq	r0, R12_usr
 d68:	4f1e052e 	svcmi	0x001e052e
 d6c:	054b1505 	strbeq	r1, [fp, #-1285]	; 0xfffffafb
 d70:	05bb670c 	ldreq	r6, [fp, #1804]!	; 0x70c
 d74:	2108bb0d 	tstcs	r8, sp, lsl #22
 d78:	21081005 	tstcs	r8, r5
 d7c:	05684405 	strbeq	r4, [r8, #-1029]!	; 0xfffffbfb
 d80:	40052e51 	andmi	r2, r5, r1, asr lr
 d84:	9e0c052e 	cfsh32ls	mvfx0, mvfx12, #30
 d88:	054a6c05 	strbeq	r6, [sl, #-3077]	; 0xfffff3fb
 d8c:	0a054a0b 	beq	1535c0 <__bss_end+0x149e88>
 d90:	03090568 	movweq	r0, #38248	; 0x9568
 d94:	054ed66e 	strbeq	sp, [lr, #-1646]	; 0xfffff992
 d98:	2e0f0301 	cdpcs	3, 0, cr0, cr15, cr1, {0}
 d9c:	830a0569 	movwhi	r0, #42345	; 0xa569
 da0:	054a0905 	strbeq	r0, [sl, #-2309]	; 0xfffff6fb
 da4:	14054a05 	strne	r4, [r5], #-2565	; 0xfffff5fb
 da8:	4c0a054e 	cfstr32mi	mvfx0, [sl], {78}	; 0x4e
 dac:	05d10905 	ldrbeq	r0, [r1, #2309]	; 0x905
 db0:	054d3401 	strbeq	r3, [sp, #-1025]	; 0xfffffbff
 db4:	0521080a 	streq	r0, [r1, #-2058]!	; 0xfffff7f6
 db8:	05054a09 	streq	r4, [r5, #-2569]	; 0xfffff5f7
 dbc:	4d0e054a 	cfstr32mi	mvfx0, [lr, #-296]	; 0xfffffed8
 dc0:	054b1105 	strbeq	r1, [fp, #-261]	; 0xfffffefb
 dc4:	19054c0c 	stmdbne	r5, {r2, r3, sl, fp, lr}
 dc8:	0020054a 	eoreq	r0, r0, sl, asr #10
 dcc:	4a010402 	bmi	41ddc <__bss_end+0x386a4>
 dd0:	02001905 	andeq	r1, r0, #81920	; 0x14000
 dd4:	05660104 	strbeq	r0, [r6, #-260]!	; 0xfffffefc
 dd8:	0c054c11 	stceq	12, cr4, [r5], {17}
 ddc:	050567bb 	streq	r6, [r5, #-1979]	; 0xfffff845
 de0:	29090562 	stmdbcs	r9, {r1, r5, r6, r8, sl}
 de4:	0b030105 	bleq	c1200 <__bss_end+0xb7ac8>
 de8:	0004022e 	andeq	r0, r4, lr, lsr #4
 dec:	00790101 	rsbseq	r0, r9, r1, lsl #2
 df0:	00030000 	andeq	r0, r3, r0
 df4:	00000046 	andeq	r0, r0, r6, asr #32
 df8:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
 dfc:	0101000d 	tsteq	r1, sp
 e00:	00000101 	andeq	r0, r0, r1, lsl #2
 e04:	00000100 	andeq	r0, r0, r0, lsl #2
 e08:	2f2e2e01 	svccs	0x002e2e01
 e0c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 e10:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 e14:	2f2e2e2f 	svccs	0x002e2e2f
 e18:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; d68 <shift+0xd68>
 e1c:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
 e20:	6f632f63 	svcvs	0x00632f63
 e24:	6769666e 	strbvs	r6, [r9, -lr, ror #12]!
 e28:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
 e2c:	696c0000 	stmdbvs	ip!, {}^	; <UNPREDICTABLE>
 e30:	75663162 	strbvc	r3, [r6, #-354]!	; 0xfffffe9e
 e34:	2e73636e 	cdpcs	3, 7, cr6, cr3, cr14, {3}
 e38:	00010053 	andeq	r0, r1, r3, asr r0
 e3c:	05000000 	streq	r0, [r0, #-0]
 e40:	00910002 	addseq	r0, r1, r2
 e44:	08cf0300 	stmiaeq	pc, {r8, r9}^	; <UNPREDICTABLE>
 e48:	2f2f3001 	svccs	0x002f3001
 e4c:	302f2f2f 	eorcc	r2, pc, pc, lsr #30
 e50:	1401d002 	strne	sp, [r1], #-2
 e54:	2f2f312f 	svccs	0x002f312f
 e58:	322f4c30 	eorcc	r4, pc, #48, 24	; 0x3000
 e5c:	2f661f03 	svccs	0x00661f03
 e60:	2f2f2f2f 	svccs	0x002f2f2f
 e64:	02022f2f 	andeq	r2, r2, #47, 30	; 0xbc
 e68:	5c010100 	stfpls	f0, [r1], {-0}
 e6c:	03000000 	movweq	r0, #0
 e70:	00004600 	andeq	r4, r0, r0, lsl #12
 e74:	fb010200 	blx	4167e <__bss_end+0x37f46>
 e78:	01000d0e 	tsteq	r0, lr, lsl #26
 e7c:	00010101 	andeq	r0, r1, r1, lsl #2
 e80:	00010000 	andeq	r0, r1, r0
 e84:	2e2e0100 	sufcse	f0, f6, f0
 e88:	2f2e2e2f 	svccs	0x002e2e2f
 e8c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 e90:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 e94:	2f2e2e2f 	svccs	0x002e2e2f
 e98:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
 e9c:	632f6363 			; <UNDEFINED> instruction: 0x632f6363
 ea0:	69666e6f 	stmdbvs	r6!, {r0, r1, r2, r3, r5, r6, r9, sl, fp, sp, lr}^
 ea4:	72612f67 	rsbvc	r2, r1, #412	; 0x19c
 ea8:	6c00006d 	stcvs	0, cr0, [r0], {109}	; 0x6d
 eac:	66316269 	ldrtvs	r6, [r1], -r9, ror #4
 eb0:	73636e75 	cmnvc	r3, #1872	; 0x750
 eb4:	0100532e 	tsteq	r0, lr, lsr #6
 eb8:	00000000 	andeq	r0, r0, r0
 ebc:	930c0205 	movwls	r0, #49669	; 0xc205
 ec0:	b9030000 	stmdblt	r3, {}	; <UNPREDICTABLE>
 ec4:	0202010b 	andeq	r0, r2, #-1073741822	; 0xc0000002
 ec8:	a4010100 	strge	r0, [r1], #-256	; 0xffffff00
 ecc:	03000000 	movweq	r0, #0
 ed0:	00009e00 	andeq	r9, r0, r0, lsl #28
 ed4:	fb010200 	blx	416de <__bss_end+0x37fa6>
 ed8:	01000d0e 	tsteq	r0, lr, lsl #26
 edc:	00010101 	andeq	r0, r1, r1, lsl #2
 ee0:	00010000 	andeq	r0, r1, r0
 ee4:	2e2e0100 	sufcse	f0, f6, f0
 ee8:	2f2e2e2f 	svccs	0x002e2e2f
 eec:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 ef0:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 ef4:	672f2e2f 	strvs	r2, [pc, -pc, lsr #28]!
 ef8:	2e006363 	cdpcs	3, 0, cr6, cr0, cr3, {3}
 efc:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 f00:	2f2e2e2f 	svccs	0x002e2e2f
 f04:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 f08:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 f0c:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
 f10:	2f636367 	svccs	0x00636367
 f14:	672f2e2e 	strvs	r2, [pc, -lr, lsr #28]!
 f18:	632f6363 			; <UNDEFINED> instruction: 0x632f6363
 f1c:	69666e6f 	stmdbvs	r6!, {r0, r1, r2, r3, r5, r6, r9, sl, fp, sp, lr}^
 f20:	72612f67 	rsbvc	r2, r1, #412	; 0x19c
 f24:	2e2e006d 	cdpcs	0, 2, cr0, cr14, cr13, {3}
 f28:	2f2e2e2f 	svccs	0x002e2e2f
 f2c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 f30:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 f34:	2f2e2e2f 	svccs	0x002e2e2f
 f38:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
 f3c:	00006363 	andeq	r6, r0, r3, ror #6
 f40:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
 f44:	2e617369 	cdpcs	3, 6, cr7, cr1, cr9, {3}
 f48:	00010068 	andeq	r0, r1, r8, rrx
 f4c:	6d726100 	ldfvse	f6, [r2, #-0]
 f50:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 f54:	62670000 	rsbvs	r0, r7, #0
 f58:	74632d6c 	strbtvc	r2, [r3], #-3436	; 0xfffff294
 f5c:	2e73726f 	cdpcs	2, 7, cr7, cr3, cr15, {3}
 f60:	00030068 	andeq	r0, r3, r8, rrx
 f64:	62696c00 	rsbvs	r6, r9, #0, 24
 f68:	32636367 	rsbcc	r6, r3, #-1677721599	; 0x9c000001
 f6c:	0300632e 	movweq	r6, #814	; 0x32e
 f70:	Address 0x0000000000000f70 is out of bounds.


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
      34:	3a0c0000 	bcc	30003c <__bss_end+0x2f6904>
      38:	46000001 	strmi	r0, [r0], -r1
      3c:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
      40:	9c000080 	stcls	0, cr0, [r0], {128}	; 0x80
      44:	76000000 	strvc	r0, [r0], -r0
      48:	02000000 	andeq	r0, r0, #0
      4c:	000001a1 	andeq	r0, r0, r1, lsr #3
      50:	31150601 	tstcc	r5, r1, lsl #12
      54:	03000000 	movweq	r0, #0
      58:	17c40704 	strbne	r0, [r4, r4, lsl #14]
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
      b0:	0b010000 	bleq	400b8 <__bss_end+0x36980>
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
     11c:	17c40704 	strbne	r0, [r4, r4, lsl #14]
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
     15c:	3a010000 	bcc	40164 <__bss_end+0x36a2c>
     160:	00007615 	andeq	r7, r0, r5, lsl r6
     164:	01e00900 	mvneq	r0, r0, lsl #18
     168:	48010000 	stmdami	r1, {}	; <UNPREDICTABLE>
     16c:	0000cb10 	andeq	ip, r0, r0, lsl fp
     170:	0081d400 	addeq	sp, r1, r0, lsl #8
     174:	00005800 	andeq	r5, r0, r0, lsl #16
     178:	cb9c0100 	blgt	fe700580 <__bss_end+0xfe6f6e48>
     17c:	0a000000 	beq	184 <shift+0x184>
     180:	000001ee 	andeq	r0, r0, lr, ror #3
     184:	d20c4a01 	andle	r4, ip, #4096	; 0x1000
     188:	02000000 	andeq	r0, r0, #0
     18c:	0b007491 	bleq	1d3d8 <__bss_end+0x13ca0>
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
     254:	cb110a01 	blgt	442a60 <__bss_end+0x439328>
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
     2bc:	0a010067 	beq	40460 <__bss_end+0x36d28>
     2c0:	00019e2f 	andeq	r9, r1, pc, lsr #28
     2c4:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     2c8:	09540000 	ldmdbeq	r4, {}^	; <UNPREDICTABLE>
     2cc:	00040000 	andeq	r0, r4, r0
     2d0:	000001c6 	andeq	r0, r0, r6, asr #3
     2d4:	02d40104 	sbcseq	r0, r4, #4, 2
     2d8:	1b040000 	blne	1002e0 <__bss_end+0xf6ba8>
     2dc:	46000008 	strmi	r0, [r0], -r8
     2e0:	2c000000 	stccs	0, cr0, [r0], {-0}
     2e4:	0c000082 	stceq	0, cr0, [r0], {130}	; 0x82
     2e8:	16000001 	strne	r0, [r0], -r1
     2ec:	02000002 	andeq	r0, r0, #2
     2f0:	0b670801 	bleq	19c22fc <__bss_end+0x19b8bc4>
     2f4:	25030000 	strcs	r0, [r3, #-0]
     2f8:	02000000 	andeq	r0, r0, #0
     2fc:	0a020502 	beq	8170c <__bss_end+0x77fd4>
     300:	04040000 	streq	r0, [r4], #-0
     304:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
     308:	08010200 	stmdaeq	r1, {r9}
     30c:	00000b5e 	andeq	r0, r0, lr, asr fp
     310:	00099605 	andeq	r9, r9, r5, lsl #12
     314:	07080200 	streq	r0, [r8, -r0, lsl #4]
     318:	00000052 	andeq	r0, r0, r2, asr r0
     31c:	27070202 	strcs	r0, [r7, -r2, lsl #4]
     320:	0500000c 	streq	r0, [r0, #-12]
     324:	000005f1 	strdeq	r0, [r0], -r1
     328:	6a070902 	bvs	1c2738 <__bss_end+0x1b9000>
     32c:	03000000 	movweq	r0, #0
     330:	00000059 	andeq	r0, r0, r9, asr r0
     334:	c4070402 	strgt	r0, [r7], #-1026	; 0xfffffbfe
     338:	03000017 	movweq	r0, #23
     33c:	0000006a 	andeq	r0, r0, sl, rrx
     340:	000cd006 	andeq	sp, ip, r6
     344:	06030800 	streq	r0, [r3], -r0, lsl #16
     348:	00009c08 	andeq	r9, r0, r8, lsl #24
     34c:	30720700 	rsbscc	r0, r2, r0, lsl #14
     350:	0e080300 	cdpeq	3, 0, cr0, cr8, cr0, {0}
     354:	00000059 	andeq	r0, r0, r9, asr r0
     358:	31720700 	cmncc	r2, r0, lsl #14
     35c:	0e090300 	cdpeq	3, 0, cr0, cr9, cr0, {0}
     360:	00000059 	andeq	r0, r0, r9, asr r0
     364:	5c080004 	stcpl	0, cr0, [r8], {4}
     368:	0500000a 	streq	r0, [r0, #-10]
     36c:	00003804 	andeq	r3, r0, r4, lsl #16
     370:	0c1e0300 	ldceq	3, cr0, [lr], {-0}
     374:	000000d3 	ldrdeq	r0, [r0], -r3
     378:	0005e909 	andeq	lr, r5, r9, lsl #18
     37c:	40090000 	andmi	r0, r9, r0
     380:	01000007 	tsteq	r0, r7
     384:	000a7e09 	andeq	r7, sl, r9, lsl #28
     388:	7a090200 	bvc	240b90 <__bss_end+0x237458>
     38c:	0300000b 	movweq	r0, #11
     390:	00071e09 	andeq	r1, r7, r9, lsl #28
     394:	f9090400 			; <UNDEFINED> instruction: 0xf9090400
     398:	05000009 	streq	r0, [r0, #-9]
     39c:	0a440800 	beq	11023a4 <__bss_end+0x10f8c6c>
     3a0:	04050000 	streq	r0, [r5], #-0
     3a4:	00000038 	andeq	r0, r0, r8, lsr r0
     3a8:	100c3f03 	andne	r3, ip, r3, lsl #30
     3ac:	09000001 	stmdbeq	r0, {r0}
     3b0:	000006be 			; <UNDEFINED> instruction: 0x000006be
     3b4:	073b0900 	ldreq	r0, [fp, -r0, lsl #18]!
     3b8:	09010000 	stmdbeq	r1, {}	; <UNPREDICTABLE>
     3bc:	00000c69 	andeq	r0, r0, r9, ror #24
     3c0:	09440902 	stmdbeq	r4, {r1, r8, fp}^
     3c4:	09030000 	stmdbeq	r3, {}	; <UNPREDICTABLE>
     3c8:	0000072d 	andeq	r0, r0, sp, lsr #14
     3cc:	07a20904 	streq	r0, [r2, r4, lsl #18]!
     3d0:	09050000 	stmdbeq	r5, {}	; <UNPREDICTABLE>
     3d4:	00000628 	andeq	r0, r0, r8, lsr #12
     3d8:	220a0006 	andcs	r0, sl, #6
     3dc:	04000009 	streq	r0, [r0], #-9
     3e0:	00651405 	rsbeq	r1, r5, r5, lsl #8
     3e4:	03050000 	movweq	r0, #20480	; 0x5000
     3e8:	00009310 	andeq	r9, r0, r0, lsl r3
     3ec:	000ae80a 	andeq	lr, sl, sl, lsl #16
     3f0:	14060400 	strne	r0, [r6], #-1024	; 0xfffffc00
     3f4:	00000065 	andeq	r0, r0, r5, rrx
     3f8:	93140305 	tstls	r4, #335544320	; 0x14000000
     3fc:	b70a0000 	strlt	r0, [sl, -r0]
     400:	05000007 	streq	r0, [r0, #-7]
     404:	00651a07 	rsbeq	r1, r5, r7, lsl #20
     408:	03050000 	movweq	r0, #20480	; 0x5000
     40c:	00009318 	andeq	r9, r0, r8, lsl r3
     410:	000a1b0a 	andeq	r1, sl, sl, lsl #22
     414:	1a090500 	bne	24181c <__bss_end+0x2380e4>
     418:	00000065 	andeq	r0, r0, r5, rrx
     41c:	931c0305 	tstls	ip, #335544320	; 0x14000000
     420:	a90a0000 	stmdbge	sl, {}	; <UNPREDICTABLE>
     424:	05000007 	streq	r0, [r0, #-7]
     428:	00651a0b 	rsbeq	r1, r5, fp, lsl #20
     42c:	03050000 	movweq	r0, #20480	; 0x5000
     430:	00009320 	andeq	r9, r0, r0, lsr #6
     434:	0009cf0a 	andeq	ip, r9, sl, lsl #30
     438:	1a0d0500 	bne	341840 <__bss_end+0x338108>
     43c:	00000065 	andeq	r0, r0, r5, rrx
     440:	93240305 			; <UNDEFINED> instruction: 0x93240305
     444:	c90a0000 	stmdbgt	sl, {}	; <UNPREDICTABLE>
     448:	05000005 	streq	r0, [r0, #-5]
     44c:	00651a0f 	rsbeq	r1, r5, pc, lsl #20
     450:	03050000 	movweq	r0, #20480	; 0x5000
     454:	00009328 	andeq	r9, r0, r8, lsr #6
     458:	0010fd08 	andseq	pc, r0, r8, lsl #26
     45c:	38040500 	stmdacc	r4, {r8, sl}
     460:	05000000 	streq	r0, [r0, #-0]
     464:	01b30c1b 			; <UNDEFINED> instruction: 0x01b30c1b
     468:	55090000 	strpl	r0, [r9, #-0]
     46c:	00000005 	andeq	r0, r0, r5
     470:	000ba509 	andeq	sl, fp, r9, lsl #10
     474:	64090100 	strvs	r0, [r9], #-256	; 0xffffff00
     478:	0200000c 	andeq	r0, r0, #12
     47c:	041d0b00 	ldreq	r0, [sp], #-2816	; 0xfffff500
     480:	01020000 	mrseq	r0, (UNDEF: 2)
     484:	00086d02 	andeq	r6, r8, r2, lsl #26
     488:	2c040c00 	stccs	12, cr0, [r4], {-0}
     48c:	0c000000 	stceq	0, cr0, [r0], {-0}
     490:	0001b304 	andeq	fp, r1, r4, lsl #6
     494:	055f0a00 	ldrbeq	r0, [pc, #-2560]	; fffffa9c <__bss_end+0xffff6364>
     498:	04060000 	streq	r0, [r6], #-0
     49c:	00006514 	andeq	r6, r0, r4, lsl r5
     4a0:	2c030500 	cfstr32cs	mvfx0, [r3], {-0}
     4a4:	0a000093 	beq	6f8 <shift+0x6f8>
     4a8:	00000a84 	andeq	r0, r0, r4, lsl #21
     4ac:	65140706 	ldrvs	r0, [r4, #-1798]	; 0xfffff8fa
     4b0:	05000000 	streq	r0, [r0, #-0]
     4b4:	00933003 	addseq	r3, r3, r3
     4b8:	04a60a00 	strteq	r0, [r6], #2560	; 0xa00
     4bc:	0a060000 	beq	1804c4 <__bss_end+0x176d8c>
     4c0:	00006514 	andeq	r6, r0, r4, lsl r5
     4c4:	34030500 	strcc	r0, [r3], #-1280	; 0xfffffb00
     4c8:	08000093 	stmdaeq	r0, {r0, r1, r4, r7}
     4cc:	0000062d 	andeq	r0, r0, sp, lsr #12
     4d0:	00380405 	eorseq	r0, r8, r5, lsl #8
     4d4:	0d060000 	stceq	0, cr0, [r6, #-0]
     4d8:	0002380c 	andeq	r3, r2, ip, lsl #16
     4dc:	654e0d00 	strbvs	r0, [lr, #-3328]	; 0xfffff300
     4e0:	09000077 	stmdbeq	r0, {r0, r1, r2, r4, r5, r6}
     4e4:	00000486 	andeq	r0, r0, r6, lsl #9
     4e8:	049e0901 	ldreq	r0, [lr], #2305	; 0x901
     4ec:	09020000 	stmdbeq	r2, {}	; <UNPREDICTABLE>
     4f0:	00000646 	andeq	r0, r0, r6, asr #12
     4f4:	0b6c0903 	bleq	1b02908 <__bss_end+0x1af91d0>
     4f8:	09040000 	stmdbeq	r4, {}	; <UNPREDICTABLE>
     4fc:	0000047a 	andeq	r0, r0, sl, ror r4
     500:	78060005 	stmdavc	r6, {r0, r2}
     504:	10000005 	andne	r0, r0, r5
     508:	77081b06 	strvc	r1, [r8, -r6, lsl #22]
     50c:	07000002 	streq	r0, [r0, -r2]
     510:	0600726c 	streq	r7, [r0], -ip, ror #4
     514:	0277131d 	rsbseq	r1, r7, #1946157056	; 0x74000000
     518:	07000000 	streq	r0, [r0, -r0]
     51c:	06007073 			; <UNDEFINED> instruction: 0x06007073
     520:	0277131e 	rsbseq	r1, r7, #2013265920	; 0x78000000
     524:	07040000 	streq	r0, [r4, -r0]
     528:	06006370 			; <UNDEFINED> instruction: 0x06006370
     52c:	0277131f 	rsbseq	r1, r7, #2080374784	; 0x7c000000
     530:	0e080000 	cdpeq	0, 0, cr0, cr8, cr0, {0}
     534:	00000a3e 	andeq	r0, r0, lr, lsr sl
     538:	77132006 	ldrvc	r2, [r3, -r6]
     53c:	0c000002 	stceq	0, cr0, [r0], {2}
     540:	07040200 	streq	r0, [r4, -r0, lsl #4]
     544:	000017bf 			; <UNDEFINED> instruction: 0x000017bf
     548:	00027703 	andeq	r7, r2, r3, lsl #14
     54c:	07110600 	ldreq	r0, [r1, -r0, lsl #12]
     550:	06700000 	ldrbteq	r0, [r0], -r0
     554:	03130828 	tsteq	r3, #40, 16	; 0x280000
     558:	a30e0000 	movwge	r0, #57344	; 0xe000
     55c:	06000006 	streq	r0, [r0], -r6
     560:	0238122a 	eorseq	r1, r8, #-1610612734	; 0xa0000002
     564:	07000000 	streq	r0, [r0, -r0]
     568:	00646970 	rsbeq	r6, r4, r0, ror r9
     56c:	6a122b06 	bvs	48b18c <__bss_end+0x481a54>
     570:	10000000 	andne	r0, r0, r0
     574:	000b9f0e 	andeq	r9, fp, lr, lsl #30
     578:	112c0600 			; <UNDEFINED> instruction: 0x112c0600
     57c:	00000201 	andeq	r0, r0, r1, lsl #4
     580:	0b500e14 	bleq	1403dd8 <__bss_end+0x13fa6a0>
     584:	2d060000 	stccs	0, cr0, [r6, #-0]
     588:	00006a12 	andeq	r6, r0, r2, lsl sl
     58c:	ad0e1800 	stcge	8, cr1, [lr, #-0]
     590:	06000003 	streq	r0, [r0], -r3
     594:	006a122e 	rsbeq	r1, sl, lr, lsr #4
     598:	0e1c0000 	cdpeq	0, 1, cr0, cr12, cr0, {0}
     59c:	00000a71 	andeq	r0, r0, r1, ror sl
     5a0:	130c2f06 	movwne	r2, #52998	; 0xcf06
     5a4:	20000003 	andcs	r0, r0, r3
     5a8:	0004360e 	andeq	r3, r4, lr, lsl #12
     5ac:	09300600 	ldmdbeq	r0!, {r9, sl}
     5b0:	00000038 	andeq	r0, r0, r8, lsr r0
     5b4:	06610e60 	strbteq	r0, [r1], -r0, ror #28
     5b8:	31060000 	mrscc	r0, (UNDEF: 6)
     5bc:	0000590e 	andeq	r5, r0, lr, lsl #18
     5c0:	880e6400 	stmdahi	lr, {sl, sp, lr}
     5c4:	06000009 	streq	r0, [r0], -r9
     5c8:	00590e33 	subseq	r0, r9, r3, lsr lr
     5cc:	0e680000 	cdpeq	0, 6, cr0, cr8, cr0, {0}
     5d0:	0000097f 	andeq	r0, r0, pc, ror r9
     5d4:	590e3406 	stmdbpl	lr, {r1, r2, sl, ip, sp}
     5d8:	6c000000 	stcvs	0, cr0, [r0], {-0}
     5dc:	01c50f00 	biceq	r0, r5, r0, lsl #30
     5e0:	03230000 			; <UNDEFINED> instruction: 0x03230000
     5e4:	6a100000 	bvs	4005ec <__bss_end+0x3f6eb4>
     5e8:	0f000000 	svceq	0x00000000
     5ec:	048f0a00 	streq	r0, [pc], #2560	; 5f4 <shift+0x5f4>
     5f0:	0a070000 	beq	1c05f8 <__bss_end+0x1b6ec0>
     5f4:	00006514 	andeq	r6, r0, r4, lsl r5
     5f8:	38030500 	stmdacc	r3, {r8, sl}
     5fc:	08000093 	stmdaeq	r0, {r0, r1, r4, r7}
     600:	000007f2 	strdeq	r0, [r0], -r2
     604:	00380405 	eorseq	r0, r8, r5, lsl #8
     608:	0d070000 	stceq	0, cr0, [r7, #-0]
     60c:	0003540c 	andeq	r5, r3, ip, lsl #8
     610:	0c6f0900 			; <UNDEFINED> instruction: 0x0c6f0900
     614:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
     618:	00000bb9 			; <UNDEFINED> instruction: 0x00000bb9
     61c:	90060001 	andls	r0, r6, r1
     620:	0c000006 	stceq	0, cr0, [r0], {6}
     624:	89081b07 	stmdbhi	r8, {r0, r1, r2, r8, r9, fp, ip}
     628:	0e000003 	cdpeq	0, 0, cr0, cr0, cr3, {0}
     62c:	00000502 	andeq	r0, r0, r2, lsl #10
     630:	89191d07 	ldmdbhi	r9, {r0, r1, r2, r8, sl, fp, ip}
     634:	00000003 	andeq	r0, r0, r3
     638:	0004810e 	andeq	r8, r4, lr, lsl #2
     63c:	191e0700 	ldmdbne	lr, {r8, r9, sl}
     640:	00000389 	andeq	r0, r0, r9, lsl #7
     644:	08160e04 	ldmdaeq	r6, {r2, r9, sl, fp}
     648:	1f070000 	svcne	0x00070000
     64c:	00038f13 	andeq	r8, r3, r3, lsl pc
     650:	0c000800 	stceq	8, cr0, [r0], {-0}
     654:	00035404 	andeq	r5, r3, r4, lsl #8
     658:	83040c00 	movwhi	r0, #19456	; 0x4c00
     65c:	11000002 	tstne	r0, r2
     660:	00000a2d 	andeq	r0, r0, sp, lsr #20
     664:	07220714 			; <UNDEFINED> instruction: 0x07220714
     668:	00000617 	andeq	r0, r0, r7, lsl r6
     66c:	0009300e 	andeq	r3, r9, lr
     670:	12260700 	eorne	r0, r6, #0, 14
     674:	00000059 	andeq	r0, r0, r9, asr r0
     678:	08d20e00 	ldmeq	r2, {r9, sl, fp}^
     67c:	29070000 	stmdbcs	r7, {}	; <UNPREDICTABLE>
     680:	0003891d 	andeq	r8, r3, sp, lsl r9
     684:	4e0e0400 	cfcpysmi	mvf0, mvf14
     688:	07000006 	streq	r0, [r0, -r6]
     68c:	03891d2c 	orreq	r1, r9, #44, 26	; 0xb00
     690:	12080000 	andne	r0, r8, #0
     694:	0000093a 	andeq	r0, r0, sl, lsr r9
     698:	6d0e2f07 	stcvs	15, cr2, [lr, #-28]	; 0xffffffe4
     69c:	dd000006 	stcle	0, cr0, [r0, #-24]	; 0xffffffe8
     6a0:	e8000003 	stmda	r0, {r0, r1}
     6a4:	13000003 	movwne	r0, #3
     6a8:	0000061c 	andeq	r0, r0, ip, lsl r6
     6ac:	00038914 	andeq	r8, r3, r4, lsl r9
     6b0:	4a150000 	bmi	5406b8 <__bss_end+0x536f80>
     6b4:	07000007 	streq	r0, [r0, -r7]
     6b8:	06e80e31 			; <UNDEFINED> instruction: 0x06e80e31
     6bc:	01b80000 			; <UNDEFINED> instruction: 0x01b80000
     6c0:	04000000 	streq	r0, [r0], #-0
     6c4:	040b0000 	streq	r0, [fp], #-0
     6c8:	1c130000 	ldcne	0, cr0, [r3], {-0}
     6cc:	14000006 	strne	r0, [r0], #-6
     6d0:	0000038f 	andeq	r0, r0, pc, lsl #7
     6d4:	0b801600 	bleq	fe005edc <__bss_end+0xfdffc7a4>
     6d8:	35070000 	strcc	r0, [r7, #-0]
     6dc:	0007cd1d 	andeq	ip, r7, sp, lsl sp
     6e0:	00038900 	andeq	r8, r3, r0, lsl #18
     6e4:	04240200 	strteq	r0, [r4], #-512	; 0xfffffe00
     6e8:	042a0000 	strteq	r0, [sl], #-0
     6ec:	1c130000 	ldcne	0, cr0, [r3], {-0}
     6f0:	00000006 	andeq	r0, r0, r6
     6f4:	00063916 	andeq	r3, r6, r6, lsl r9
     6f8:	1d370700 	ldcne	7, cr0, [r7, #-0]
     6fc:	0000094a 	andeq	r0, r0, sl, asr #18
     700:	00000389 	andeq	r0, r0, r9, lsl #7
     704:	00044302 	andeq	r4, r4, r2, lsl #6
     708:	00044900 	andeq	r4, r4, r0, lsl #18
     70c:	061c1300 	ldreq	r1, [ip], -r0, lsl #6
     710:	17000000 	strne	r0, [r0, -r0]
     714:	000008e5 	andeq	r0, r0, r5, ror #17
     718:	35313907 	ldrcc	r3, [r1, #-2311]!	; 0xfffff6f9
     71c:	0c000006 	stceq	0, cr0, [r0], {6}
     720:	0a2d1602 	beq	b45f30 <__bss_end+0xb3c7f8>
     724:	3c070000 	stccc	0, cr0, [r7], {-0}
     728:	00075909 	andeq	r5, r7, r9, lsl #18
     72c:	00061c00 	andeq	r1, r6, r0, lsl #24
     730:	04700100 	ldrbteq	r0, [r0], #-256	; 0xffffff00
     734:	04760000 	ldrbteq	r0, [r6], #-0
     738:	1c130000 	ldcne	0, cr0, [r3], {-0}
     73c:	00000006 	andeq	r0, r0, r6
     740:	0006af16 	andeq	sl, r6, r6, lsl pc
     744:	123f0700 	eorsne	r0, pc, #0, 14
     748:	000004d7 	ldrdeq	r0, [r0], -r7
     74c:	00000059 	andeq	r0, r0, r9, asr r0
     750:	00048f01 	andeq	r8, r4, r1, lsl #30
     754:	0004a400 	andeq	sl, r4, r0, lsl #8
     758:	061c1300 	ldreq	r1, [ip], -r0, lsl #6
     75c:	3e140000 	cdpcc	0, 1, cr0, cr4, cr0, {0}
     760:	14000006 	strne	r0, [r0], #-6
     764:	0000006a 	andeq	r0, r0, sl, rrx
     768:	0001b814 	andeq	fp, r1, r4, lsl r8
     76c:	b0180000 	andslt	r0, r8, r0
     770:	0700000b 	streq	r0, [r0, -fp]
     774:	05850e42 	streq	r0, [r5, #3650]	; 0xe42
     778:	b9010000 	stmdblt	r1, {}	; <UNPREDICTABLE>
     77c:	bf000004 	svclt	0x00000004
     780:	13000004 	movwne	r0, #4
     784:	0000061c 	andeq	r0, r0, ip, lsl r6
     788:	04b91600 	ldrteq	r1, [r9], #1536	; 0x600
     78c:	45070000 	strmi	r0, [r7, #-0]
     790:	00052717 	andeq	r2, r5, r7, lsl r7
     794:	00038f00 	andeq	r8, r3, r0, lsl #30
     798:	04d80100 	ldrbeq	r0, [r8], #256	; 0x100
     79c:	04de0000 	ldrbeq	r0, [lr], #0
     7a0:	44130000 	ldrmi	r0, [r3], #-0
     7a4:	00000006 	andeq	r0, r0, r6
     7a8:	000a8f16 	andeq	r8, sl, r6, lsl pc
     7ac:	17480700 	strbne	r0, [r8, -r0, lsl #14]
     7b0:	000003c3 	andeq	r0, r0, r3, asr #7
     7b4:	0000038f 	andeq	r0, r0, pc, lsl #7
     7b8:	0004f701 	andeq	pc, r4, r1, lsl #14
     7bc:	00050200 	andeq	r0, r5, r0, lsl #4
     7c0:	06441300 	strbeq	r1, [r4], -r0, lsl #6
     7c4:	59140000 	ldmdbpl	r4, {}	; <UNPREDICTABLE>
     7c8:	00000000 	andeq	r0, r0, r0
     7cc:	0005d318 	andeq	sp, r5, r8, lsl r3
     7d0:	0e4b0700 	cdpeq	7, 4, cr0, cr11, cr0, {0}
     7d4:	000008f3 	strdeq	r0, [r0], -r3
     7d8:	00051701 	andeq	r1, r5, r1, lsl #14
     7dc:	00051d00 	andeq	r1, r5, r0, lsl #26
     7e0:	061c1300 	ldreq	r1, [ip], -r0, lsl #6
     7e4:	16000000 	strne	r0, [r0], -r0
     7e8:	0000074a 	andeq	r0, r0, sl, asr #14
     7ec:	a70e4d07 	strge	r4, [lr, -r7, lsl #26]
     7f0:	b8000009 	stmdalt	r0, {r0, r3}
     7f4:	01000001 	tsteq	r0, r1
     7f8:	00000536 	andeq	r0, r0, r6, lsr r5
     7fc:	00000541 	andeq	r0, r0, r1, asr #10
     800:	00061c13 	andeq	r1, r6, r3, lsl ip
     804:	00591400 	subseq	r1, r9, r0, lsl #8
     808:	16000000 	strne	r0, [r0], -r0
     80c:	00000466 	andeq	r0, r0, r6, ror #8
     810:	f0125007 			; <UNDEFINED> instruction: 0xf0125007
     814:	59000003 	stmdbpl	r0, {r0, r1}
     818:	01000000 	mrseq	r0, (UNDEF: 0)
     81c:	0000055a 	andeq	r0, r0, sl, asr r5
     820:	00000565 	andeq	r0, r0, r5, ror #10
     824:	00061c13 	andeq	r1, r6, r3, lsl ip
     828:	01c51400 	biceq	r1, r5, r0, lsl #8
     82c:	16000000 	strne	r0, [r0], -r0
     830:	00000423 	andeq	r0, r0, r3, lsr #8
     834:	e50e5307 	str	r5, [lr, #-775]	; 0xfffffcf9
     838:	b800000b 	stmdalt	r0, {r0, r1, r3}
     83c:	01000001 	tsteq	r0, r1
     840:	0000057e 	andeq	r0, r0, lr, ror r5
     844:	00000589 	andeq	r0, r0, r9, lsl #11
     848:	00061c13 	andeq	r1, r6, r3, lsl ip
     84c:	00591400 	subseq	r1, r9, r0, lsl #8
     850:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
     854:	00000440 	andeq	r0, r0, r0, asr #8
     858:	f40e5607 	vst1.8	{d5-d7}, [lr], r7
     85c:	0100000a 	tsteq	r0, sl
     860:	0000059e 	muleq	r0, lr, r5
     864:	000005bd 			; <UNDEFINED> instruction: 0x000005bd
     868:	00061c13 	andeq	r1, r6, r3, lsl ip
     86c:	009c1400 	addseq	r1, ip, r0, lsl #8
     870:	59140000 	ldmdbpl	r4, {}	; <UNPREDICTABLE>
     874:	14000000 	strne	r0, [r0], #-0
     878:	00000059 	andeq	r0, r0, r9, asr r0
     87c:	00005914 	andeq	r5, r0, r4, lsl r9
     880:	064a1400 	strbeq	r1, [sl], -r0, lsl #8
     884:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
     888:	00000c11 	andeq	r0, r0, r1, lsl ip
     88c:	840e5807 	strhi	r5, [lr], #-2055	; 0xfffff7f9
     890:	0100000c 	tsteq	r0, ip
     894:	000005d2 	ldrdeq	r0, [r0], -r2
     898:	000005f1 	strdeq	r0, [r0], -r1
     89c:	00061c13 	andeq	r1, r6, r3, lsl ip
     8a0:	00d31400 	sbcseq	r1, r3, r0, lsl #8
     8a4:	59140000 	ldmdbpl	r4, {}	; <UNPREDICTABLE>
     8a8:	14000000 	strne	r0, [r0], #-0
     8ac:	00000059 	andeq	r0, r0, r9, asr r0
     8b0:	00005914 	andeq	r5, r0, r4, lsl r9
     8b4:	064a1400 	strbeq	r1, [sl], -r0, lsl #8
     8b8:	19000000 	stmdbne	r0, {}	; <UNPREDICTABLE>
     8bc:	00000453 	andeq	r0, r0, r3, asr r4
     8c0:	720e5b07 	andvc	r5, lr, #7168	; 0x1c00
     8c4:	b8000008 	stmdalt	r0, {r3}
     8c8:	01000001 	tsteq	r0, r1
     8cc:	00000606 	andeq	r0, r0, r6, lsl #12
     8d0:	00061c13 	andeq	r1, r6, r3, lsl ip
     8d4:	03351400 	teqeq	r5, #0, 8
     8d8:	50140000 	andspl	r0, r4, r0
     8dc:	00000006 	andeq	r0, r0, r6
     8e0:	03950300 	orrseq	r0, r5, #0, 6
     8e4:	040c0000 	streq	r0, [ip], #-0
     8e8:	00000395 	muleq	r0, r5, r3
     8ec:	0003891a 	andeq	r8, r3, sl, lsl r9
     8f0:	00062f00 	andeq	r2, r6, r0, lsl #30
     8f4:	00063500 	andeq	r3, r6, r0, lsl #10
     8f8:	061c1300 	ldreq	r1, [ip], -r0, lsl #6
     8fc:	1b000000 	blne	904 <shift+0x904>
     900:	00000395 	muleq	r0, r5, r3
     904:	00000622 	andeq	r0, r0, r2, lsr #12
     908:	003f040c 	eorseq	r0, pc, ip, lsl #8
     90c:	040c0000 	streq	r0, [ip], #-0
     910:	00000617 	andeq	r0, r0, r7, lsl r6
     914:	0076041c 	rsbseq	r0, r6, ip, lsl r4
     918:	041d0000 	ldreq	r0, [sp], #-0
     91c:	000a0d11 	andeq	r0, sl, r1, lsl sp
     920:	06080800 	streq	r0, [r8], -r0, lsl #16
     924:	00079607 	andeq	r9, r7, r7, lsl #12
     928:	07330e00 	ldreq	r0, [r3, -r0, lsl #28]!
     92c:	0a080000 	beq	200934 <__bss_end+0x1f71fc>
     930:	00005912 	andeq	r5, r0, r2, lsl r9
     934:	9f0e0000 	svcls	0x000e0000
     938:	08000009 	stmdaeq	r0, {r0, r3}
     93c:	01b80e0c 			; <UNDEFINED> instruction: 0x01b80e0c
     940:	16040000 	strne	r0, [r4], -r0
     944:	00000a0d 	andeq	r0, r0, sp, lsl #20
     948:	a6091008 	strge	r1, [r9], -r8
     94c:	9b000005 	blls	968 <shift+0x968>
     950:	01000007 	tsteq	r0, r7
     954:	00000692 	muleq	r0, r2, r6
     958:	0000069d 	muleq	r0, sp, r6
     95c:	00079b13 	andeq	r9, r7, r3, lsl fp
     960:	01bf1400 			; <UNDEFINED> instruction: 0x01bf1400
     964:	16000000 	strne	r0, [r0], -r0
     968:	00000a0c 	andeq	r0, r0, ip, lsl #20
     96c:	e2151208 	ands	r1, r5, #8, 4	; 0x80000000
     970:	50000009 	andpl	r0, r0, r9
     974:	01000006 	tsteq	r0, r6
     978:	000006b6 			; <UNDEFINED> instruction: 0x000006b6
     97c:	000006c1 	andeq	r0, r0, r1, asr #13
     980:	00079b13 	andeq	r9, r7, r3, lsl fp
     984:	00381300 	eorseq	r1, r8, r0, lsl #6
     988:	16000000 	strne	r0, [r0], -r0
     98c:	000005bf 			; <UNDEFINED> instruction: 0x000005bf
     990:	820e1508 	andhi	r1, lr, #8, 10	; 0x2000000
     994:	b8000007 	stmdalt	r0, {r0, r1, r2}
     998:	01000001 	tsteq	r0, r1
     99c:	000006da 	ldrdeq	r0, [r0], -sl
     9a0:	000006e0 	andeq	r0, r0, r0, ror #13
     9a4:	0007a113 	andeq	sl, r7, r3, lsl r1
     9a8:	d7180000 	ldrle	r0, [r8, -r0]
     9ac:	0800000a 	stmdaeq	r0, {r1, r3}
     9b0:	06ce0e18 			; <UNDEFINED> instruction: 0x06ce0e18
     9b4:	f5010000 			; <UNDEFINED> instruction: 0xf5010000
     9b8:	fb000006 	blx	9da <shift+0x9da>
     9bc:	13000006 	movwne	r0, #6
     9c0:	0000079b 	muleq	r0, fp, r7
     9c4:	077c1800 	ldrbeq	r1, [ip, -r0, lsl #16]!
     9c8:	1b080000 	blne	2009d0 <__bss_end+0x1f7298>
     9cc:	0005fa0e 	andeq	pc, r5, lr, lsl #20
     9d0:	07100100 	ldreq	r0, [r0, -r0, lsl #2]
     9d4:	071b0000 	ldreq	r0, [fp, -r0]
     9d8:	9b130000 	blls	4c09e0 <__bss_end+0x4b72a8>
     9dc:	14000007 	strne	r0, [r0], #-7
     9e0:	000001b8 			; <UNDEFINED> instruction: 0x000001b8
     9e4:	0b461800 	bleq	11869ec <__bss_end+0x117d2b4>
     9e8:	1d080000 	stcne	0, cr0, [r8, #-0]
     9ec:	000bc40e 	andeq	ip, fp, lr, lsl #8
     9f0:	07300100 	ldreq	r0, [r0, -r0, lsl #2]!
     9f4:	07450000 	strbeq	r0, [r5, -r0]
     9f8:	9b130000 	blls	4c0a00 <__bss_end+0x4b72c8>
     9fc:	14000007 	strne	r0, [r0], #-7
     a00:	00000046 	andeq	r0, r0, r6, asr #32
     a04:	00004614 	andeq	r4, r0, r4, lsl r6
     a08:	01b81400 			; <UNDEFINED> instruction: 0x01b81400
     a0c:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
     a10:	0000061f 	andeq	r0, r0, pc, lsl r6
     a14:	070e1f08 	streq	r1, [lr, -r8, lsl #30]
     a18:	01000005 	tsteq	r0, r5
     a1c:	0000075a 	andeq	r0, r0, sl, asr r7
     a20:	0000076f 	andeq	r0, r0, pc, ror #14
     a24:	00079b13 	andeq	r9, r7, r3, lsl fp
     a28:	00461400 	subeq	r1, r6, r0, lsl #8
     a2c:	46140000 	ldrmi	r0, [r4], -r0
     a30:	14000000 	strne	r0, [r0], #-0
     a34:	00000025 	andeq	r0, r0, r5, lsr #32
     a38:	0c3f1e00 	ldceq	14, cr1, [pc], #-0	; a40 <shift+0xa40>
     a3c:	21080000 	mrscs	r0, (UNDEF: 8)
     a40:	000ab20e 	andeq	fp, sl, lr, lsl #4
     a44:	07800100 	streq	r0, [r0, r0, lsl #2]
     a48:	9b130000 	blls	4c0a50 <__bss_end+0x4b7318>
     a4c:	14000007 	strne	r0, [r0], #-7
     a50:	00000046 	andeq	r0, r0, r6, asr #32
     a54:	00004614 	andeq	r4, r0, r4, lsl r6
     a58:	01bf1400 			; <UNDEFINED> instruction: 0x01bf1400
     a5c:	00000000 	andeq	r0, r0, r0
     a60:	00065203 	andeq	r5, r6, r3, lsl #4
     a64:	52040c00 	andpl	r0, r4, #0, 24
     a68:	0c000006 	stceq	0, cr0, [r0], {6}
     a6c:	00079604 	andeq	r9, r7, r4, lsl #12
     a70:	61681f00 	cmnvs	r8, r0, lsl #30
     a74:	0509006c 	streq	r0, [r9, #-108]	; 0xffffff94
     a78:	0008610b 	andeq	r6, r8, fp, lsl #2
     a7c:	08bf2000 	ldmeq	pc!, {sp}	; <UNPREDICTABLE>
     a80:	07090000 	streq	r0, [r9, -r0]
     a84:	00007119 	andeq	r7, r0, r9, lsl r1
     a88:	e6b28000 	ldrt	r8, [r2], r0
     a8c:	0aa2200e 	beq	fe888acc <__bss_end+0xfe87f394>
     a90:	0a090000 	beq	240a98 <__bss_end+0x237360>
     a94:	00027e1a 	andeq	r7, r2, sl, lsl lr
     a98:	00000000 	andeq	r0, r0, r0
     a9c:	04cd2020 	strbeq	r2, [sp], #32
     aa0:	0d090000 	stceq	0, cr0, [r9, #-0]
     aa4:	00027e1a 	andeq	r7, r2, sl, lsl lr
     aa8:	20000000 	andcs	r0, r0, r0
     aac:	08072120 	stmdaeq	r7, {r5, r8, sp}
     ab0:	10090000 	andne	r0, r9, r0
     ab4:	00006515 	andeq	r6, r0, r5, lsl r5
     ab8:	8c203600 	stchi	6, cr3, [r0], #-0
     abc:	0900000b 	stmdbeq	r0, {r0, r1, r3}
     ac0:	027e1a42 	rsbseq	r1, lr, #270336	; 0x42000
     ac4:	50000000 	andpl	r0, r0, r0
     ac8:	4a202021 	bmi	808b54 <__bss_end+0x7ff41c>
     acc:	0900000c 	stmdbeq	r0, {r2, r3}
     ad0:	027e1a71 	rsbseq	r1, lr, #462848	; 0x71000
     ad4:	b2000000 	andlt	r0, r0, #0
     ad8:	c3202000 	nopgt	{0}	; <UNPREDICTABLE>
     adc:	09000006 	stmdbeq	r0, {r1, r2}
     ae0:	027e1aa4 	rsbseq	r1, lr, #164, 20	; 0xa4000
     ae4:	b4000000 	strlt	r0, [r0], #-0
     ae8:	b5202000 	strlt	r2, [r0, #-0]!
     aec:	09000008 	stmdbeq	r0, {r3}
     af0:	027e1ab3 	rsbseq	r1, lr, #733184	; 0xb3000
     af4:	40000000 	andmi	r0, r0, r0
     af8:	70202010 	eorvc	r2, r0, r0, lsl r0
     afc:	09000009 	stmdbeq	r0, {r0, r3}
     b00:	027e1abe 	rsbseq	r1, lr, #778240	; 0xbe000
     b04:	50000000 	andpl	r0, r0, r0
     b08:	15202020 	strne	r2, [r0, #-32]!	; 0xffffffe0
     b0c:	09000006 	stmdbeq	r0, {r1, r2}
     b10:	027e1abf 	rsbseq	r1, lr, #782336	; 0xbf000
     b14:	40000000 	andmi	r0, r0, r0
     b18:	95202080 	strls	r2, [r0, #-128]!	; 0xffffff80
     b1c:	0900000b 	stmdbeq	r0, {r0, r1, r3}
     b20:	027e1ac0 	rsbseq	r1, lr, #192, 20	; 0xc0000
     b24:	50000000 	andpl	r0, r0, r0
     b28:	22002080 	andcs	r2, r0, #128	; 0x80
     b2c:	000007b3 			; <UNDEFINED> instruction: 0x000007b3
     b30:	0007c322 	andeq	ip, r7, r2, lsr #6
     b34:	07d32200 	ldrbeq	r2, [r3, r0, lsl #4]
     b38:	e3220000 			; <UNDEFINED> instruction: 0xe3220000
     b3c:	22000007 	andcs	r0, r0, #7
     b40:	000007f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     b44:	00080022 	andeq	r0, r8, r2, lsr #32
     b48:	08102200 	ldmdaeq	r0, {r9, sp}
     b4c:	20220000 	eorcs	r0, r2, r0
     b50:	22000008 	andcs	r0, r0, #8
     b54:	00000830 	andeq	r0, r0, r0, lsr r8
     b58:	00084022 	andeq	r4, r8, r2, lsr #32
     b5c:	08502200 	ldmdaeq	r0, {r9, sp}^
     b60:	dc0a0000 	stcle	0, cr0, [sl], {-0}
     b64:	0a00000a 	beq	b94 <shift+0xb94>
     b68:	00651408 	rsbeq	r1, r5, r8, lsl #8
     b6c:	03050000 	movweq	r0, #20480	; 0x5000
     b70:	00009368 	andeq	r9, r0, r8, ror #6
     b74:	0001bf0f 	andeq	fp, r1, pc, lsl #30
     b78:	0008ba00 	andeq	fp, r8, r0, lsl #20
     b7c:	006a1000 	rsbeq	r1, sl, r0
     b80:	00040000 	andeq	r0, r4, r0
     b84:	00077323 	andeq	r7, r7, r3, lsr #6
     b88:	0d120100 	ldfeqs	f0, [r2, #-0]
     b8c:	000008aa 	andeq	r0, r0, sl, lsr #17
     b90:	97140305 	ldrls	r0, [r4, -r5, lsl #6]
     b94:	58240000 	stmdapl	r4!, {}	; <UNPREDICTABLE>
     b98:	01000017 	tsteq	r0, r7, lsl r0
     b9c:	0038051a 	eorseq	r0, r8, sl, lsl r5
     ba0:	822c0000 	eorhi	r0, ip, #0
     ba4:	010c0000 	mrseq	r0, (UNDEF: 12)
     ba8:	9c010000 	stcls	0, cr0, [r1], {-0}
     bac:	0000094b 	andeq	r0, r0, fp, asr #18
     bb0:	00097a25 	andeq	r7, r9, r5, lsr #20
     bb4:	0e1a0100 	mufeqe	f0, f2, f0
     bb8:	00000038 	andeq	r0, r0, r8, lsr r0
     bbc:	255c9102 	ldrbcs	r9, [ip, #-258]	; 0xfffffefe
     bc0:	00000991 	muleq	r0, r1, r9
     bc4:	4b1b1a01 	blmi	6c73d0 <__bss_end+0x6bdc98>
     bc8:	02000009 	andeq	r0, r0, #9
     bcc:	3a265891 	bcc	996e18 <__bss_end+0x98d6e0>
     bd0:	0100000c 	tsteq	r0, ip
     bd4:	0652101c 			; <UNDEFINED> instruction: 0x0652101c
     bd8:	91020000 	mrsls	r0, (UNDEF: 2)
     bdc:	0cdc2668 	ldcleq	6, cr2, [ip], {104}	; 0x68
     be0:	21010000 	mrscs	r0, (UNDEF: 1)
     be4:	0000590b 	andeq	r5, r0, fp, lsl #18
     be8:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     bec:	6d756e27 	ldclvs	14, cr6, [r5, #-156]!	; 0xffffff64
     bf0:	0b220100 	bleq	880ff8 <__bss_end+0x8778c0>
     bf4:	00000059 	andeq	r0, r0, r9, asr r0
     bf8:	28649102 	stmdacs	r4!, {r1, r8, ip, pc}^
     bfc:	000082a4 	andeq	r8, r0, r4, lsr #5
     c00:	0000007c 	andeq	r0, r0, ip, ror r0
     c04:	67736d27 	ldrbvs	r6, [r3, -r7, lsr #26]!
     c08:	0f2a0100 	svceq	0x002a0100
     c0c:	000001bf 			; <UNDEFINED> instruction: 0x000001bf
     c10:	00709102 	rsbseq	r9, r0, r2, lsl #2
     c14:	51040c00 	tstpl	r4, r0, lsl #24
     c18:	0c000009 	stceq	0, cr0, [r0], {9}
     c1c:	00002504 	andeq	r2, r0, r4, lsl #10
     c20:	0b1f0000 	bleq	7c0c28 <__bss_end+0x7b74f0>
     c24:	00040000 	andeq	r0, r4, r0
     c28:	00000430 	andeq	r0, r0, r0, lsr r4
     c2c:	0e620104 	poweqs	f0, f2, f4
     c30:	49040000 	stmdbmi	r4, {}	; <UNPREDICTABLE>
     c34:	8c00000d 	stchi	0, cr0, [r0], {13}
     c38:	3800000f 	stmdacc	r0, {r0, r1, r2, r3}
     c3c:	5c000083 	stcpl	0, cr0, [r0], {131}	; 0x83
     c40:	17000004 	strne	r0, [r0, -r4]
     c44:	02000005 	andeq	r0, r0, #5
     c48:	0b670801 	bleq	19c2c54 <__bss_end+0x19b951c>
     c4c:	25030000 	strcs	r0, [r3, #-0]
     c50:	02000000 	andeq	r0, r0, #0
     c54:	0a020502 	beq	82064 <__bss_end+0x7892c>
     c58:	04040000 	streq	r0, [r4], #-0
     c5c:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
     c60:	08010200 	stmdaeq	r1, {r9}
     c64:	00000b5e 	andeq	r0, r0, lr, asr fp
     c68:	27070202 	strcs	r0, [r7, -r2, lsl #4]
     c6c:	0500000c 	streq	r0, [r0, #-12]
     c70:	000005f1 	strdeq	r0, [r0], -r1
     c74:	5e070907 	vmlapl.f16	s0, s14, s14	; <UNPREDICTABLE>
     c78:	03000000 	movweq	r0, #0
     c7c:	0000004d 	andeq	r0, r0, sp, asr #32
     c80:	c4070402 	strgt	r0, [r7], #-1026	; 0xfffffbfe
     c84:	06000017 			; <UNDEFINED> instruction: 0x06000017
     c88:	00000cd0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     c8c:	08060208 	stmdaeq	r6, {r3, r9}
     c90:	0000008b 	andeq	r0, r0, fp, lsl #1
     c94:	00307207 	eorseq	r7, r0, r7, lsl #4
     c98:	4d0e0802 	stcmi	8, cr0, [lr, #-8]
     c9c:	00000000 	andeq	r0, r0, r0
     ca0:	00317207 	eorseq	r7, r1, r7, lsl #4
     ca4:	4d0e0902 	vstrmi.16	s0, [lr, #-4]	; <UNPREDICTABLE>
     ca8:	04000000 	streq	r0, [r0], #-0
     cac:	10340800 	eorsne	r0, r4, r0, lsl #16
     cb0:	04050000 	streq	r0, [r5], #-0
     cb4:	00000038 	andeq	r0, r0, r8, lsr r0
     cb8:	a90c0d02 	stmdbge	ip, {r1, r8, sl, fp}
     cbc:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
     cc0:	00004b4f 	andeq	r4, r0, pc, asr #22
     cc4:	000d950a 	andeq	r9, sp, sl, lsl #10
     cc8:	08000100 	stmdaeq	r0, {r8}
     ccc:	00000a5c 	andeq	r0, r0, ip, asr sl
     cd0:	00380405 	eorseq	r0, r8, r5, lsl #8
     cd4:	1e020000 	cdpne	0, 0, cr0, cr2, cr0, {0}
     cd8:	0000e00c 	andeq	lr, r0, ip
     cdc:	05e90a00 	strbeq	r0, [r9, #2560]!	; 0xa00
     ce0:	0a000000 	beq	ce8 <shift+0xce8>
     ce4:	00000740 	andeq	r0, r0, r0, asr #14
     ce8:	0a7e0a01 	beq	1f834f4 <__bss_end+0x1f79dbc>
     cec:	0a020000 	beq	80cf4 <__bss_end+0x775bc>
     cf0:	00000b7a 	andeq	r0, r0, sl, ror fp
     cf4:	071e0a03 	ldreq	r0, [lr, -r3, lsl #20]
     cf8:	0a040000 	beq	100d00 <__bss_end+0xf75c8>
     cfc:	000009f9 	strdeq	r0, [r0], -r9
     d00:	44080005 	strmi	r0, [r8], #-5
     d04:	0500000a 	streq	r0, [r0, #-10]
     d08:	00003804 	andeq	r3, r0, r4, lsl #16
     d0c:	0c3f0200 	lfmeq	f0, 4, [pc], #-0	; d14 <shift+0xd14>
     d10:	0000011d 	andeq	r0, r0, sp, lsl r1
     d14:	0006be0a 	andeq	fp, r6, sl, lsl #28
     d18:	3b0a0000 	blcc	280d20 <__bss_end+0x2775e8>
     d1c:	01000007 	tsteq	r0, r7
     d20:	000c690a 	andeq	r6, ip, sl, lsl #18
     d24:	440a0200 	strmi	r0, [sl], #-512	; 0xfffffe00
     d28:	03000009 	movweq	r0, #9
     d2c:	00072d0a 	andeq	r2, r7, sl, lsl #26
     d30:	a20a0400 	andge	r0, sl, #0, 8
     d34:	05000007 	streq	r0, [r0, #-7]
     d38:	0006280a 	andeq	r2, r6, sl, lsl #16
     d3c:	08000600 	stmdaeq	r0, {r9, sl}
     d40:	000010aa 	andeq	r1, r0, sl, lsr #1
     d44:	00380405 	eorseq	r0, r8, r5, lsl #8
     d48:	66020000 	strvs	r0, [r2], -r0
     d4c:	0001480c 	andeq	r4, r1, ip, lsl #16
     d50:	0fd90a00 	svceq	0x00d90a00
     d54:	0a000000 	beq	d5c <shift+0xd5c>
     d58:	00000df2 	strdeq	r0, [r0], -r2
     d5c:	0ffd0a01 	svceq	0x00fd0a01
     d60:	0a020000 	beq	80d68 <__bss_end+0x77630>
     d64:	00000e17 	andeq	r0, r0, r7, lsl lr
     d68:	220b0003 	andcs	r0, fp, #3
     d6c:	03000009 	movweq	r0, #9
     d70:	00591405 	subseq	r1, r9, r5, lsl #8
     d74:	03050000 	movweq	r0, #20480	; 0x5000
     d78:	00009424 	andeq	r9, r0, r4, lsr #8
     d7c:	000ae80b 	andeq	lr, sl, fp, lsl #16
     d80:	14060300 	strne	r0, [r6], #-768	; 0xfffffd00
     d84:	00000059 	andeq	r0, r0, r9, asr r0
     d88:	94280305 	strtls	r0, [r8], #-773	; 0xfffffcfb
     d8c:	b70b0000 	strlt	r0, [fp, -r0]
     d90:	04000007 	streq	r0, [r0], #-7
     d94:	00591a07 	subseq	r1, r9, r7, lsl #20
     d98:	03050000 	movweq	r0, #20480	; 0x5000
     d9c:	0000942c 	andeq	r9, r0, ip, lsr #8
     da0:	000a1b0b 	andeq	r1, sl, fp, lsl #22
     da4:	1a090400 	bne	241dac <__bss_end+0x238674>
     da8:	00000059 	andeq	r0, r0, r9, asr r0
     dac:	94300305 	ldrtls	r0, [r0], #-773	; 0xfffffcfb
     db0:	a90b0000 	stmdbge	fp, {}	; <UNPREDICTABLE>
     db4:	04000007 	streq	r0, [r0], #-7
     db8:	00591a0b 	subseq	r1, r9, fp, lsl #20
     dbc:	03050000 	movweq	r0, #20480	; 0x5000
     dc0:	00009434 	andeq	r9, r0, r4, lsr r4
     dc4:	0009cf0b 	andeq	ip, r9, fp, lsl #30
     dc8:	1a0d0400 	bne	341dd0 <__bss_end+0x338698>
     dcc:	00000059 	andeq	r0, r0, r9, asr r0
     dd0:	94380305 	ldrtls	r0, [r8], #-773	; 0xfffffcfb
     dd4:	c90b0000 	stmdbgt	fp, {}	; <UNPREDICTABLE>
     dd8:	04000005 	streq	r0, [r0], #-5
     ddc:	00591a0f 	subseq	r1, r9, pc, lsl #20
     de0:	03050000 	movweq	r0, #20480	; 0x5000
     de4:	0000943c 	andeq	r9, r0, ip, lsr r4
     de8:	0010fd08 	andseq	pc, r0, r8, lsl #26
     dec:	38040500 	stmdacc	r4, {r8, sl}
     df0:	04000000 	streq	r0, [r0], #-0
     df4:	01eb0c1b 	mvneq	r0, fp, lsl ip
     df8:	550a0000 	strpl	r0, [sl, #-0]
     dfc:	00000005 	andeq	r0, r0, r5
     e00:	000ba50a 	andeq	sl, fp, sl, lsl #10
     e04:	640a0100 	strvs	r0, [sl], #-256	; 0xffffff00
     e08:	0200000c 	andeq	r0, r0, #12
     e0c:	041d0c00 	ldreq	r0, [sp], #-3072	; 0xfffff400
     e10:	01020000 	mrseq	r0, (UNDEF: 2)
     e14:	00086d02 	andeq	r6, r8, r2, lsl #26
     e18:	2c040d00 	stccs	13, cr0, [r4], {-0}
     e1c:	0d000000 	stceq	0, cr0, [r0, #-0]
     e20:	0001eb04 	andeq	lr, r1, r4, lsl #22
     e24:	055f0b00 	ldrbeq	r0, [pc, #-2816]	; 32c <shift+0x32c>
     e28:	04050000 	streq	r0, [r5], #-0
     e2c:	00005914 	andeq	r5, r0, r4, lsl r9
     e30:	40030500 	andmi	r0, r3, r0, lsl #10
     e34:	0b000094 	bleq	108c <shift+0x108c>
     e38:	00000a84 	andeq	r0, r0, r4, lsl #21
     e3c:	59140705 	ldmdbpl	r4, {r0, r2, r8, r9, sl}
     e40:	05000000 	streq	r0, [r0, #-0]
     e44:	00944403 	addseq	r4, r4, r3, lsl #8
     e48:	04a60b00 	strteq	r0, [r6], #2816	; 0xb00
     e4c:	0a050000 	beq	140e54 <__bss_end+0x13771c>
     e50:	00005914 	andeq	r5, r0, r4, lsl r9
     e54:	48030500 	stmdami	r3, {r8, sl}
     e58:	08000094 	stmdaeq	r0, {r2, r4, r7}
     e5c:	0000062d 	andeq	r0, r0, sp, lsr #12
     e60:	00380405 	eorseq	r0, r8, r5, lsl #8
     e64:	0d050000 	stceq	0, cr0, [r5, #-0]
     e68:	0002700c 	andeq	r7, r2, ip
     e6c:	654e0900 	strbvs	r0, [lr, #-2304]	; 0xfffff700
     e70:	0a000077 	beq	1054 <shift+0x1054>
     e74:	00000486 	andeq	r0, r0, r6, lsl #9
     e78:	049e0a01 	ldreq	r0, [lr], #2561	; 0xa01
     e7c:	0a020000 	beq	80e84 <__bss_end+0x7774c>
     e80:	00000646 	andeq	r0, r0, r6, asr #12
     e84:	0b6c0a03 	bleq	1b03698 <__bss_end+0x1af9f60>
     e88:	0a040000 	beq	100e90 <__bss_end+0xf7758>
     e8c:	0000047a 	andeq	r0, r0, sl, ror r4
     e90:	78060005 	stmdavc	r6, {r0, r2}
     e94:	10000005 	andne	r0, r0, r5
     e98:	af081b05 	svcge	0x00081b05
     e9c:	07000002 	streq	r0, [r0, -r2]
     ea0:	0500726c 	streq	r7, [r0, #-620]	; 0xfffffd94
     ea4:	02af131d 	adceq	r1, pc, #1946157056	; 0x74000000
     ea8:	07000000 	streq	r0, [r0, -r0]
     eac:	05007073 	streq	r7, [r0, #-115]	; 0xffffff8d
     eb0:	02af131e 	adceq	r1, pc, #2013265920	; 0x78000000
     eb4:	07040000 	streq	r0, [r4, -r0]
     eb8:	05006370 	streq	r6, [r0, #-880]	; 0xfffffc90
     ebc:	02af131f 	adceq	r1, pc, #2080374784	; 0x7c000000
     ec0:	0e080000 	cdpeq	0, 0, cr0, cr8, cr0, {0}
     ec4:	00000a3e 	andeq	r0, r0, lr, lsr sl
     ec8:	af132005 	svcge	0x00132005
     ecc:	0c000002 	stceq	0, cr0, [r0], {2}
     ed0:	07040200 	streq	r0, [r4, -r0, lsl #4]
     ed4:	000017bf 			; <UNDEFINED> instruction: 0x000017bf
     ed8:	00071106 	andeq	r1, r7, r6, lsl #2
     edc:	28057000 	stmdacs	r5, {ip, sp, lr}
     ee0:	00034608 	andeq	r4, r3, r8, lsl #12
     ee4:	06a30e00 	strteq	r0, [r3], r0, lsl #28
     ee8:	2a050000 	bcs	140ef0 <__bss_end+0x1377b8>
     eec:	00027012 	andeq	r7, r2, r2, lsl r0
     ef0:	70070000 	andvc	r0, r7, r0
     ef4:	05006469 	streq	r6, [r0, #-1129]	; 0xfffffb97
     ef8:	005e122b 	subseq	r1, lr, fp, lsr #4
     efc:	0e100000 	cdpeq	0, 1, cr0, cr0, cr0, {0}
     f00:	00000b9f 	muleq	r0, pc, fp	; <UNPREDICTABLE>
     f04:	39112c05 	ldmdbcc	r1, {r0, r2, sl, fp, sp}
     f08:	14000002 	strne	r0, [r0], #-2
     f0c:	000b500e 	andeq	r5, fp, lr
     f10:	122d0500 	eorne	r0, sp, #0, 10
     f14:	0000005e 	andeq	r0, r0, lr, asr r0
     f18:	03ad0e18 			; <UNDEFINED> instruction: 0x03ad0e18
     f1c:	2e050000 	cdpcs	0, 0, cr0, cr5, cr0, {0}
     f20:	00005e12 	andeq	r5, r0, r2, lsl lr
     f24:	710e1c00 	tstvc	lr, r0, lsl #24
     f28:	0500000a 	streq	r0, [r0, #-10]
     f2c:	03460c2f 	movteq	r0, #27695	; 0x6c2f
     f30:	0e200000 	cdpeq	0, 2, cr0, cr0, cr0, {0}
     f34:	00000436 	andeq	r0, r0, r6, lsr r4
     f38:	38093005 	stmdacc	r9, {r0, r2, ip, sp}
     f3c:	60000000 	andvs	r0, r0, r0
     f40:	0006610e 	andeq	r6, r6, lr, lsl #2
     f44:	0e310500 	cfabs32eq	mvfx0, mvfx1
     f48:	0000004d 	andeq	r0, r0, sp, asr #32
     f4c:	09880e64 	stmibeq	r8, {r2, r5, r6, r9, sl, fp}
     f50:	33050000 	movwcc	r0, #20480	; 0x5000
     f54:	00004d0e 	andeq	r4, r0, lr, lsl #26
     f58:	7f0e6800 	svcvc	0x000e6800
     f5c:	05000009 	streq	r0, [r0, #-9]
     f60:	004d0e34 	subeq	r0, sp, r4, lsr lr
     f64:	006c0000 	rsbeq	r0, ip, r0
     f68:	0001fd0f 	andeq	pc, r1, pc, lsl #26
     f6c:	00035600 	andeq	r5, r3, r0, lsl #12
     f70:	005e1000 	subseq	r1, lr, r0
     f74:	000f0000 	andeq	r0, pc, r0
     f78:	00048f0b 	andeq	r8, r4, fp, lsl #30
     f7c:	140a0600 	strne	r0, [sl], #-1536	; 0xfffffa00
     f80:	00000059 	andeq	r0, r0, r9, asr r0
     f84:	944c0305 	strbls	r0, [ip], #-773	; 0xfffffcfb
     f88:	f2080000 	vhadd.s8	d0, d8, d0
     f8c:	05000007 	streq	r0, [r0, #-7]
     f90:	00003804 	andeq	r3, r0, r4, lsl #16
     f94:	0c0d0600 	stceq	6, cr0, [sp], {-0}
     f98:	00000387 	andeq	r0, r0, r7, lsl #7
     f9c:	000c6f0a 	andeq	r6, ip, sl, lsl #30
     fa0:	b90a0000 	stmdblt	sl, {}	; <UNPREDICTABLE>
     fa4:	0100000b 	tsteq	r0, fp
     fa8:	03680300 	cmneq	r8, #0, 6
     fac:	30080000 	andcc	r0, r8, r0
     fb0:	0500000f 	streq	r0, [r0, #-15]
     fb4:	00003804 	andeq	r3, r0, r4, lsl #16
     fb8:	0c140600 	ldceq	6, cr0, [r4], {-0}
     fbc:	000003ab 	andeq	r0, r0, fp, lsr #7
     fc0:	000cec0a 	andeq	lr, ip, sl, lsl #24
     fc4:	ef0a0000 	svc	0x000a0000
     fc8:	0100000f 	tsteq	r0, pc
     fcc:	038c0300 	orreq	r0, ip, #0, 6
     fd0:	90060000 	andls	r0, r6, r0
     fd4:	0c000006 	stceq	0, cr0, [r0], {6}
     fd8:	e5081b06 	str	r1, [r8, #-2822]	; 0xfffff4fa
     fdc:	0e000003 	cdpeq	0, 0, cr0, cr0, cr3, {0}
     fe0:	00000502 	andeq	r0, r0, r2, lsl #10
     fe4:	e5191d06 	ldr	r1, [r9, #-3334]	; 0xfffff2fa
     fe8:	00000003 	andeq	r0, r0, r3
     fec:	0004810e 	andeq	r8, r4, lr, lsl #2
     ff0:	191e0600 	ldmdbne	lr, {r9, sl}
     ff4:	000003e5 	andeq	r0, r0, r5, ror #7
     ff8:	08160e04 	ldmdaeq	r6, {r2, r9, sl, fp}
     ffc:	1f060000 	svcne	0x00060000
    1000:	0003eb13 	andeq	lr, r3, r3, lsl fp
    1004:	0d000800 	stceq	8, cr0, [r0, #-0]
    1008:	0003b004 	andeq	fp, r3, r4
    100c:	b6040d00 	strlt	r0, [r4], -r0, lsl #26
    1010:	11000002 	tstne	r0, r2
    1014:	00000a2d 	andeq	r0, r0, sp, lsr #20
    1018:	07220614 			; <UNDEFINED> instruction: 0x07220614
    101c:	00000673 	andeq	r0, r0, r3, ror r6
    1020:	0009300e 	andeq	r3, r9, lr
    1024:	12260600 	eorne	r0, r6, #0, 12
    1028:	0000004d 	andeq	r0, r0, sp, asr #32
    102c:	08d20e00 	ldmeq	r2, {r9, sl, fp}^
    1030:	29060000 	stmdbcs	r6, {}	; <UNPREDICTABLE>
    1034:	0003e51d 	andeq	lr, r3, sp, lsl r5
    1038:	4e0e0400 	cfcpysmi	mvf0, mvf14
    103c:	06000006 	streq	r0, [r0], -r6
    1040:	03e51d2c 	mvneq	r1, #44, 26	; 0xb00
    1044:	12080000 	andne	r0, r8, #0
    1048:	0000093a 	andeq	r0, r0, sl, lsr r9
    104c:	6d0e2f06 	stcvs	15, cr2, [lr, #-24]	; 0xffffffe8
    1050:	39000006 	stmdbcc	r0, {r1, r2}
    1054:	44000004 	strmi	r0, [r0], #-4
    1058:	13000004 	movwne	r0, #4
    105c:	00000678 	andeq	r0, r0, r8, ror r6
    1060:	0003e514 	andeq	lr, r3, r4, lsl r5
    1064:	4a150000 	bmi	54106c <__bss_end+0x537934>
    1068:	06000007 	streq	r0, [r0], -r7
    106c:	06e80e31 			; <UNDEFINED> instruction: 0x06e80e31
    1070:	01f00000 	mvnseq	r0, r0
    1074:	045c0000 	ldrbeq	r0, [ip], #-0
    1078:	04670000 	strbteq	r0, [r7], #-0
    107c:	78130000 	ldmdavc	r3, {}	; <UNPREDICTABLE>
    1080:	14000006 	strne	r0, [r0], #-6
    1084:	000003eb 	andeq	r0, r0, fp, ror #7
    1088:	0b801600 	bleq	fe006890 <__bss_end+0xfdffd158>
    108c:	35060000 	strcc	r0, [r6, #-0]
    1090:	0007cd1d 	andeq	ip, r7, sp, lsl sp
    1094:	0003e500 	andeq	lr, r3, r0, lsl #10
    1098:	04800200 	streq	r0, [r0], #512	; 0x200
    109c:	04860000 	streq	r0, [r6], #0
    10a0:	78130000 	ldmdavc	r3, {}	; <UNPREDICTABLE>
    10a4:	00000006 	andeq	r0, r0, r6
    10a8:	00063916 	andeq	r3, r6, r6, lsl r9
    10ac:	1d370600 	ldcne	6, cr0, [r7, #-0]
    10b0:	0000094a 	andeq	r0, r0, sl, asr #18
    10b4:	000003e5 	andeq	r0, r0, r5, ror #7
    10b8:	00049f02 	andeq	r9, r4, r2, lsl #30
    10bc:	0004a500 	andeq	sl, r4, r0, lsl #10
    10c0:	06781300 	ldrbteq	r1, [r8], -r0, lsl #6
    10c4:	17000000 	strne	r0, [r0, -r0]
    10c8:	000008e5 	andeq	r0, r0, r5, ror #17
    10cc:	91313906 	teqls	r1, r6, lsl #18
    10d0:	0c000006 	stceq	0, cr0, [r0], {6}
    10d4:	0a2d1602 	beq	b468e4 <__bss_end+0xb3d1ac>
    10d8:	3c060000 	stccc	0, cr0, [r6], {-0}
    10dc:	00075909 	andeq	r5, r7, r9, lsl #18
    10e0:	00067800 	andeq	r7, r6, r0, lsl #16
    10e4:	04cc0100 	strbeq	r0, [ip], #256	; 0x100
    10e8:	04d20000 	ldrbeq	r0, [r2], #0
    10ec:	78130000 	ldmdavc	r3, {}	; <UNPREDICTABLE>
    10f0:	00000006 	andeq	r0, r0, r6
    10f4:	0006af16 	andeq	sl, r6, r6, lsl pc
    10f8:	123f0600 	eorsne	r0, pc, #0, 12
    10fc:	000004d7 	ldrdeq	r0, [r0], -r7
    1100:	0000004d 	andeq	r0, r0, sp, asr #32
    1104:	0004eb01 	andeq	lr, r4, r1, lsl #22
    1108:	00050000 	andeq	r0, r5, r0
    110c:	06781300 	ldrbteq	r1, [r8], -r0, lsl #6
    1110:	9a140000 	bls	501118 <__bss_end+0x4f79e0>
    1114:	14000006 	strne	r0, [r0], #-6
    1118:	0000005e 	andeq	r0, r0, lr, asr r0
    111c:	0001f014 	andeq	pc, r1, r4, lsl r0	; <UNPREDICTABLE>
    1120:	b0180000 	andslt	r0, r8, r0
    1124:	0600000b 	streq	r0, [r0], -fp
    1128:	05850e42 	streq	r0, [r5, #3650]	; 0xe42
    112c:	15010000 	strne	r0, [r1, #-0]
    1130:	1b000005 	blne	114c <shift+0x114c>
    1134:	13000005 	movwne	r0, #5
    1138:	00000678 	andeq	r0, r0, r8, ror r6
    113c:	04b91600 	ldrteq	r1, [r9], #1536	; 0x600
    1140:	45060000 	strmi	r0, [r6, #-0]
    1144:	00052717 	andeq	r2, r5, r7, lsl r7
    1148:	0003eb00 	andeq	lr, r3, r0, lsl #22
    114c:	05340100 	ldreq	r0, [r4, #-256]!	; 0xffffff00
    1150:	053a0000 	ldreq	r0, [sl, #-0]!
    1154:	a0130000 	andsge	r0, r3, r0
    1158:	00000006 	andeq	r0, r0, r6
    115c:	000a8f16 	andeq	r8, sl, r6, lsl pc
    1160:	17480600 	strbne	r0, [r8, -r0, lsl #12]
    1164:	000003c3 	andeq	r0, r0, r3, asr #7
    1168:	000003eb 	andeq	r0, r0, fp, ror #7
    116c:	00055301 	andeq	r5, r5, r1, lsl #6
    1170:	00055e00 	andeq	r5, r5, r0, lsl #28
    1174:	06a01300 	strteq	r1, [r0], r0, lsl #6
    1178:	4d140000 	ldcmi	0, cr0, [r4, #-0]
    117c:	00000000 	andeq	r0, r0, r0
    1180:	0005d318 	andeq	sp, r5, r8, lsl r3
    1184:	0e4b0600 	cdpeq	6, 4, cr0, cr11, cr0, {0}
    1188:	000008f3 	strdeq	r0, [r0], -r3
    118c:	00057301 	andeq	r7, r5, r1, lsl #6
    1190:	00057900 	andeq	r7, r5, r0, lsl #18
    1194:	06781300 	ldrbteq	r1, [r8], -r0, lsl #6
    1198:	16000000 	strne	r0, [r0], -r0
    119c:	0000074a 	andeq	r0, r0, sl, asr #14
    11a0:	a70e4d06 	strge	r4, [lr, -r6, lsl #26]
    11a4:	f0000009 			; <UNDEFINED> instruction: 0xf0000009
    11a8:	01000001 	tsteq	r0, r1
    11ac:	00000592 	muleq	r0, r2, r5
    11b0:	0000059d 	muleq	r0, sp, r5
    11b4:	00067813 	andeq	r7, r6, r3, lsl r8
    11b8:	004d1400 	subeq	r1, sp, r0, lsl #8
    11bc:	16000000 	strne	r0, [r0], -r0
    11c0:	00000466 	andeq	r0, r0, r6, ror #8
    11c4:	f0125006 			; <UNDEFINED> instruction: 0xf0125006
    11c8:	4d000003 	stcmi	0, cr0, [r0, #-12]
    11cc:	01000000 	mrseq	r0, (UNDEF: 0)
    11d0:	000005b6 			; <UNDEFINED> instruction: 0x000005b6
    11d4:	000005c1 	andeq	r0, r0, r1, asr #11
    11d8:	00067813 	andeq	r7, r6, r3, lsl r8
    11dc:	01fd1400 	mvnseq	r1, r0, lsl #8
    11e0:	16000000 	strne	r0, [r0], -r0
    11e4:	00000423 	andeq	r0, r0, r3, lsr #8
    11e8:	e50e5306 	str	r5, [lr, #-774]	; 0xfffffcfa
    11ec:	f000000b 			; <UNDEFINED> instruction: 0xf000000b
    11f0:	01000001 	tsteq	r0, r1
    11f4:	000005da 	ldrdeq	r0, [r0], -sl
    11f8:	000005e5 	andeq	r0, r0, r5, ror #11
    11fc:	00067813 	andeq	r7, r6, r3, lsl r8
    1200:	004d1400 	subeq	r1, sp, r0, lsl #8
    1204:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
    1208:	00000440 	andeq	r0, r0, r0, asr #8
    120c:	f40e5606 	vst1.8	{d5-d7}, [lr], r6
    1210:	0100000a 	tsteq	r0, sl
    1214:	000005fa 	strdeq	r0, [r0], -sl
    1218:	00000619 	andeq	r0, r0, r9, lsl r6
    121c:	00067813 	andeq	r7, r6, r3, lsl r8
    1220:	00a91400 	adceq	r1, r9, r0, lsl #8
    1224:	4d140000 	ldcmi	0, cr0, [r4, #-0]
    1228:	14000000 	strne	r0, [r0], #-0
    122c:	0000004d 	andeq	r0, r0, sp, asr #32
    1230:	00004d14 	andeq	r4, r0, r4, lsl sp
    1234:	06a61400 	strteq	r1, [r6], r0, lsl #8
    1238:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
    123c:	00000c11 	andeq	r0, r0, r1, lsl ip
    1240:	840e5806 	strhi	r5, [lr], #-2054	; 0xfffff7fa
    1244:	0100000c 	tsteq	r0, ip
    1248:	0000062e 	andeq	r0, r0, lr, lsr #12
    124c:	0000064d 	andeq	r0, r0, sp, asr #12
    1250:	00067813 	andeq	r7, r6, r3, lsl r8
    1254:	00e01400 	rsceq	r1, r0, r0, lsl #8
    1258:	4d140000 	ldcmi	0, cr0, [r4, #-0]
    125c:	14000000 	strne	r0, [r0], #-0
    1260:	0000004d 	andeq	r0, r0, sp, asr #32
    1264:	00004d14 	andeq	r4, r0, r4, lsl sp
    1268:	06a61400 	strteq	r1, [r6], r0, lsl #8
    126c:	19000000 	stmdbne	r0, {}	; <UNPREDICTABLE>
    1270:	00000453 	andeq	r0, r0, r3, asr r4
    1274:	720e5b06 	andvc	r5, lr, #6144	; 0x1800
    1278:	f0000008 			; <UNDEFINED> instruction: 0xf0000008
    127c:	01000001 	tsteq	r0, r1
    1280:	00000662 	andeq	r0, r0, r2, ror #12
    1284:	00067813 	andeq	r7, r6, r3, lsl r8
    1288:	03681400 	cmneq	r8, #0, 8
    128c:	ac140000 	ldcge	0, cr0, [r4], {-0}
    1290:	00000006 	andeq	r0, r0, r6
    1294:	03f10300 	mvnseq	r0, #0, 6
    1298:	040d0000 	streq	r0, [sp], #-0
    129c:	000003f1 	strdeq	r0, [r0], -r1
    12a0:	0003e51a 	andeq	lr, r3, sl, lsl r5
    12a4:	00068b00 	andeq	r8, r6, r0, lsl #22
    12a8:	00069100 	andeq	r9, r6, r0, lsl #2
    12ac:	06781300 	ldrbteq	r1, [r8], -r0, lsl #6
    12b0:	1b000000 	blne	12b8 <shift+0x12b8>
    12b4:	000003f1 	strdeq	r0, [r0], -r1
    12b8:	0000067e 	andeq	r0, r0, lr, ror r6
    12bc:	003f040d 	eorseq	r0, pc, sp, lsl #8
    12c0:	040d0000 	streq	r0, [sp], #-0
    12c4:	00000673 	andeq	r0, r0, r3, ror r6
    12c8:	0065041c 	rsbeq	r0, r5, ip, lsl r4
    12cc:	041d0000 	ldreq	r0, [sp], #-0
    12d0:	00002c0f 	andeq	r2, r0, pc, lsl #24
    12d4:	0006be00 	andeq	fp, r6, r0, lsl #28
    12d8:	005e1000 	subseq	r1, lr, r0
    12dc:	00090000 	andeq	r0, r9, r0
    12e0:	0006ae03 	andeq	sl, r6, r3, lsl #28
    12e4:	0de11e00 	stcleq	14, cr1, [r1]
    12e8:	a4010000 	strge	r0, [r1], #-0
    12ec:	0006be0c 	andeq	fp, r6, ip, lsl #28
    12f0:	50030500 	andpl	r0, r3, r0, lsl #10
    12f4:	1f000094 	svcne	0x00000094
    12f8:	00000d05 	andeq	r0, r0, r5, lsl #26
    12fc:	240aa601 	strcs	sl, [sl], #-1537	; 0xfffff9ff
    1300:	4d00000f 	stcmi	0, cr0, [r0, #-60]	; 0xffffffc4
    1304:	e4000000 	str	r0, [r0], #-0
    1308:	b0000086 	andlt	r0, r0, r6, lsl #1
    130c:	01000000 	mrseq	r0, (UNDEF: 0)
    1310:	0007339c 	muleq	r7, ip, r3
    1314:	10e02000 	rscne	r2, r0, r0
    1318:	a6010000 	strge	r0, [r1], -r0
    131c:	0001f71b 	andeq	pc, r1, fp, lsl r7	; <UNPREDICTABLE>
    1320:	ac910300 	ldcge	3, cr0, [r1], {0}
    1324:	0f83207f 	svceq	0x0083207f
    1328:	a6010000 	strge	r0, [r1], -r0
    132c:	00004d2a 	andeq	r4, r0, sl, lsr #26
    1330:	a8910300 	ldmge	r1, {r8, r9}
    1334:	0e5c1e7f 	mrceq	14, 2, r1, cr12, cr15, {3}
    1338:	a8010000 	stmdage	r1, {}	; <UNPREDICTABLE>
    133c:	0007330a 	andeq	r3, r7, sl, lsl #6
    1340:	b4910300 	ldrlt	r0, [r1], #768	; 0x300
    1344:	0d001e7f 	stceq	14, cr1, [r0, #-508]	; 0xfffffe04
    1348:	ac010000 	stcge	0, cr0, [r1], {-0}
    134c:	00003809 	andeq	r3, r0, r9, lsl #16
    1350:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1354:	00250f00 	eoreq	r0, r5, r0, lsl #30
    1358:	07430000 	strbeq	r0, [r3, -r0]
    135c:	5e100000 	cdppl	0, 1, cr0, cr0, cr0, {0}
    1360:	3f000000 	svccc	0x00000000
    1364:	0f682100 	svceq	0x00682100
    1368:	98010000 	stmdals	r1, {}	; <UNPREDICTABLE>
    136c:	0010140a 	andseq	r1, r0, sl, lsl #8
    1370:	00004d00 	andeq	r4, r0, r0, lsl #26
    1374:	0086a800 	addeq	sl, r6, r0, lsl #16
    1378:	00003c00 	andeq	r3, r0, r0, lsl #24
    137c:	809c0100 	addshi	r0, ip, r0, lsl #2
    1380:	22000007 	andcs	r0, r0, #7
    1384:	00716572 	rsbseq	r6, r1, r2, ror r5
    1388:	ab209a01 	blge	827b94 <__bss_end+0x81e45c>
    138c:	02000003 	andeq	r0, r0, #3
    1390:	191e7491 	ldmdbne	lr, {r0, r4, r7, sl, ip, sp, lr}
    1394:	0100000f 	tsteq	r0, pc
    1398:	004d0e9b 	umaaleq	r0, sp, fp, lr
    139c:	91020000 	mrsls	r0, (UNDEF: 2)
    13a0:	c7230070 			; <UNDEFINED> instruction: 0xc7230070
    13a4:	0100000f 	tsteq	r0, pc
    13a8:	0d21068f 	stceq	6, cr0, [r1, #-572]!	; 0xfffffdc4
    13ac:	866c0000 	strbthi	r0, [ip], -r0
    13b0:	003c0000 	eorseq	r0, ip, r0
    13b4:	9c010000 	stcls	0, cr0, [r1], {-0}
    13b8:	000007b9 			; <UNDEFINED> instruction: 0x000007b9
    13bc:	000daf20 	andeq	sl, sp, r0, lsr #30
    13c0:	218f0100 	orrcs	r0, pc, r0, lsl #2
    13c4:	0000004d 	andeq	r0, r0, sp, asr #32
    13c8:	226c9102 	rsbcs	r9, ip, #-2147483648	; 0x80000000
    13cc:	00716572 	rsbseq	r6, r1, r2, ror r5
    13d0:	ab209101 	blge	8257dc <__bss_end+0x81c0a4>
    13d4:	02000003 	andeq	r0, r0, #3
    13d8:	21007491 			; <UNDEFINED> instruction: 0x21007491
    13dc:	00000f45 	andeq	r0, r0, r5, asr #30
    13e0:	fd0a8301 	stc2	3, cr8, [sl, #-4]
    13e4:	4d00000d 	stcmi	0, cr0, [r0, #-52]	; 0xffffffcc
    13e8:	30000000 	andcc	r0, r0, r0
    13ec:	3c000086 	stccc	0, cr0, [r0], {134}	; 0x86
    13f0:	01000000 	mrseq	r0, (UNDEF: 0)
    13f4:	0007f69c 	muleq	r7, ip, r6
    13f8:	65722200 	ldrbvs	r2, [r2, #-512]!	; 0xfffffe00
    13fc:	85010071 	strhi	r0, [r1, #-113]	; 0xffffff8f
    1400:	00038720 	andeq	r8, r3, r0, lsr #14
    1404:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1408:	000cf91e 	andeq	pc, ip, lr, lsl r9	; <UNPREDICTABLE>
    140c:	0e860100 	rmfeqs	f0, f6, f0
    1410:	0000004d 	andeq	r0, r0, sp, asr #32
    1414:	00709102 	rsbseq	r9, r0, r2, lsl #2
    1418:	0010c321 	andseq	ip, r0, r1, lsr #6
    141c:	0a770100 	beq	1dc1824 <__bss_end+0x1db80ec>
    1420:	00000dc3 	andeq	r0, r0, r3, asr #27
    1424:	0000004d 	andeq	r0, r0, sp, asr #32
    1428:	000085f4 	strdeq	r8, [r0], -r4
    142c:	0000003c 	andeq	r0, r0, ip, lsr r0
    1430:	08339c01 	ldmdaeq	r3!, {r0, sl, fp, ip, pc}
    1434:	72220000 	eorvc	r0, r2, #0
    1438:	01007165 	tsteq	r0, r5, ror #2
    143c:	03872079 	orreq	r2, r7, #121	; 0x79
    1440:	91020000 	mrsls	r0, (UNDEF: 2)
    1444:	0cf91e74 	ldcleq	14, cr1, [r9], #464	; 0x1d0
    1448:	7a010000 	bvc	41450 <__bss_end+0x37d18>
    144c:	00004d0e 	andeq	r4, r0, lr, lsl #26
    1450:	70910200 	addsvc	r0, r1, r0, lsl #4
    1454:	0e112100 	mufeqs	f2, f1, f0
    1458:	6b010000 	blvs	41460 <__bss_end+0x37d28>
    145c:	000fe406 	andeq	lr, pc, r6, lsl #8
    1460:	0001f000 	andeq	pc, r1, r0
    1464:	0085a000 	addeq	sl, r5, r0
    1468:	00005400 	andeq	r5, r0, r0, lsl #8
    146c:	7f9c0100 	svcvc	0x009c0100
    1470:	20000008 	andcs	r0, r0, r8
    1474:	00000f19 	andeq	r0, r0, r9, lsl pc
    1478:	4d156b01 	vldrmi	d6, [r5, #-4]
    147c:	02000000 	andeq	r0, r0, #0
    1480:	7f206c91 	svcvc	0x00206c91
    1484:	01000009 	tsteq	r0, r9
    1488:	004d256b 	subeq	r2, sp, fp, ror #10
    148c:	91020000 	mrsls	r0, (UNDEF: 2)
    1490:	10bb1e68 	adcsne	r1, fp, r8, ror #28
    1494:	6d010000 	stcvs	0, cr0, [r1, #-0]
    1498:	00004d0e 	andeq	r4, r0, lr, lsl #26
    149c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    14a0:	0d382100 	ldfeqs	f2, [r8, #-0]
    14a4:	5e010000 	cdppl	0, 0, cr0, cr1, cr0, {0}
    14a8:	00104b12 	andseq	r4, r0, r2, lsl fp
    14ac:	00008b00 	andeq	r8, r0, r0, lsl #22
    14b0:	00855000 	addeq	r5, r5, r0
    14b4:	00005000 	andeq	r5, r0, r0
    14b8:	da9c0100 	ble	fe7018c0 <__bss_end+0xfe6f8188>
    14bc:	20000008 	andcs	r0, r0, r8
    14c0:	00000ce1 	andeq	r0, r0, r1, ror #25
    14c4:	4d205e01 	stcmi	14, cr5, [r0, #-4]!
    14c8:	02000000 	andeq	r0, r0, #0
    14cc:	4e206c91 	mcrmi	12, 1, r6, cr0, cr1, {4}
    14d0:	0100000f 	tsteq	r0, pc
    14d4:	004d2f5e 	subeq	r2, sp, lr, asr pc
    14d8:	91020000 	mrsls	r0, (UNDEF: 2)
    14dc:	097f2068 	ldmdbeq	pc!, {r3, r5, r6, sp}^	; <UNPREDICTABLE>
    14e0:	5e010000 	cdppl	0, 0, cr0, cr1, cr0, {0}
    14e4:	00004d3f 	andeq	r4, r0, pc, lsr sp
    14e8:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    14ec:	0010bb1e 	andseq	fp, r0, lr, lsl fp
    14f0:	16600100 	strbtne	r0, [r0], -r0, lsl #2
    14f4:	0000008b 	andeq	r0, r0, fp, lsl #1
    14f8:	00749102 	rsbseq	r9, r4, r2, lsl #2
    14fc:	00108121 	andseq	r8, r0, r1, lsr #2
    1500:	0a520100 	beq	1481908 <__bss_end+0x14781d0>
    1504:	00000d3d 	andeq	r0, r0, sp, lsr sp
    1508:	0000004d 	andeq	r0, r0, sp, asr #32
    150c:	0000850c 	andeq	r8, r0, ip, lsl #10
    1510:	00000044 	andeq	r0, r0, r4, asr #32
    1514:	09269c01 	stmdbeq	r6!, {r0, sl, fp, ip, pc}
    1518:	e1200000 			; <UNDEFINED> instruction: 0xe1200000
    151c:	0100000c 	tsteq	r0, ip
    1520:	004d1a52 	subeq	r1, sp, r2, asr sl
    1524:	91020000 	mrsls	r0, (UNDEF: 2)
    1528:	0f4e206c 	svceq	0x004e206c
    152c:	52010000 	andpl	r0, r1, #0
    1530:	00004d29 	andeq	r4, r0, r9, lsr #26
    1534:	68910200 	ldmvs	r1, {r9}
    1538:	00107a1e 	andseq	r7, r0, lr, lsl sl
    153c:	0e540100 	rdfeqs	f0, f4, f0
    1540:	0000004d 	andeq	r0, r0, sp, asr #32
    1544:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1548:	00107421 	andseq	r7, r0, r1, lsr #8
    154c:	0a450100 	beq	1141954 <__bss_end+0x113821c>
    1550:	00001056 	andeq	r1, r0, r6, asr r0
    1554:	0000004d 	andeq	r0, r0, sp, asr #32
    1558:	000084bc 			; <UNDEFINED> instruction: 0x000084bc
    155c:	00000050 	andeq	r0, r0, r0, asr r0
    1560:	09819c01 	stmibeq	r1, {r0, sl, fp, ip, pc}
    1564:	e1200000 			; <UNDEFINED> instruction: 0xe1200000
    1568:	0100000c 	tsteq	r0, ip
    156c:	004d1945 	subeq	r1, sp, r5, asr #18
    1570:	91020000 	mrsls	r0, (UNDEF: 2)
    1574:	0e3d206c 	cdpeq	0, 3, cr2, cr13, cr12, {3}
    1578:	45010000 	strmi	r0, [r1, #-0]
    157c:	00011d30 	andeq	r1, r1, r0, lsr sp
    1580:	68910200 	ldmvs	r1, {r9}
    1584:	000f5420 	andeq	r5, pc, r0, lsr #8
    1588:	41450100 	mrsmi	r0, (UNDEF: 85)
    158c:	000006ac 	andeq	r0, r0, ip, lsr #13
    1590:	1e649102 	lgnnes	f1, f2
    1594:	000010bb 	strheq	r1, [r0], -fp
    1598:	4d0e4701 	stcmi	7, cr4, [lr, #-4]
    159c:	02000000 	andeq	r0, r0, #0
    15a0:	23007491 	movwcs	r7, #1169	; 0x491
    15a4:	00000ce6 	andeq	r0, r0, r6, ror #25
    15a8:	47063f01 	strmi	r3, [r6, -r1, lsl #30]
    15ac:	9000000e 	andls	r0, r0, lr
    15b0:	2c000084 	stccs	0, cr0, [r0], {132}	; 0x84
    15b4:	01000000 	mrseq	r0, (UNDEF: 0)
    15b8:	0009ab9c 	muleq	r9, ip, fp
    15bc:	0ce12000 	stcleq	0, cr2, [r1]
    15c0:	3f010000 	svccc	0x00010000
    15c4:	00004d15 	andeq	r4, r0, r5, lsl sp
    15c8:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    15cc:	0f132100 	svceq	0x00132100
    15d0:	32010000 	andcc	r0, r1, #0
    15d4:	000f5a0a 	andeq	r5, pc, sl, lsl #20
    15d8:	00004d00 	andeq	r4, r0, r0, lsl #26
    15dc:	00844000 	addeq	r4, r4, r0
    15e0:	00005000 	andeq	r5, r0, r0
    15e4:	069c0100 	ldreq	r0, [ip], r0, lsl #2
    15e8:	2000000a 	andcs	r0, r0, sl
    15ec:	00000ce1 	andeq	r0, r0, r1, ror #25
    15f0:	4d193201 	lfmmi	f3, 4, [r9, #-4]
    15f4:	02000000 	andeq	r0, r0, #0
    15f8:	97206c91 			; <UNDEFINED> instruction: 0x97206c91
    15fc:	01000010 	tsteq	r0, r0, lsl r0
    1600:	01f72b32 	mvnseq	r2, r2, lsr fp
    1604:	91020000 	mrsls	r0, (UNDEF: 2)
    1608:	0f872068 	svceq	0x00872068
    160c:	32010000 	andcc	r0, r1, #0
    1610:	00004d3c 	andeq	r4, r0, ip, lsr sp
    1614:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    1618:	0010451e 	andseq	r4, r0, lr, lsl r5
    161c:	0e340100 	rsfeqs	f0, f4, f0
    1620:	0000004d 	andeq	r0, r0, sp, asr #32
    1624:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1628:	0010e521 	andseq	lr, r0, r1, lsr #10
    162c:	0a250100 	beq	941a34 <__bss_end+0x9382fc>
    1630:	0000109e 	muleq	r0, lr, r0
    1634:	0000004d 	andeq	r0, r0, sp, asr #32
    1638:	000083f0 	strdeq	r8, [r0], -r0
    163c:	00000050 	andeq	r0, r0, r0, asr r0
    1640:	0a619c01 	beq	186864c <__bss_end+0x185ef14>
    1644:	e1200000 			; <UNDEFINED> instruction: 0xe1200000
    1648:	0100000c 	tsteq	r0, ip
    164c:	004d1825 	subeq	r1, sp, r5, lsr #16
    1650:	91020000 	mrsls	r0, (UNDEF: 2)
    1654:	1097206c 	addsne	r2, r7, ip, rrx
    1658:	25010000 	strcs	r0, [r1, #-0]
    165c:	000a672a 	andeq	r6, sl, sl, lsr #14
    1660:	68910200 	ldmvs	r1, {r9}
    1664:	000f8720 	andeq	r8, pc, r0, lsr #14
    1668:	3b250100 	blcc	941a70 <__bss_end+0x938338>
    166c:	0000004d 	andeq	r0, r0, sp, asr #32
    1670:	1e649102 	lgnnes	f1, f2
    1674:	00000d0a 	andeq	r0, r0, sl, lsl #26
    1678:	4d0e2701 	stcmi	7, cr2, [lr, #-4]
    167c:	02000000 	andeq	r0, r0, #0
    1680:	0d007491 	cfstrseq	mvf7, [r0, #-580]	; 0xfffffdbc
    1684:	00002504 	andeq	r2, r0, r4, lsl #10
    1688:	0a610300 	beq	1842290 <__bss_end+0x1838b58>
    168c:	1f210000 	svcne	0x00210000
    1690:	0100000f 	tsteq	r0, pc
    1694:	10f10a19 	rscsne	r0, r1, r9, lsl sl
    1698:	004d0000 	subeq	r0, sp, r0
    169c:	83ac0000 			; <UNDEFINED> instruction: 0x83ac0000
    16a0:	00440000 	subeq	r0, r4, r0
    16a4:	9c010000 	stcls	0, cr0, [r1], {-0}
    16a8:	00000ab8 			; <UNDEFINED> instruction: 0x00000ab8
    16ac:	0010dc20 	andseq	sp, r0, r0, lsr #24
    16b0:	1b190100 	blne	641ab8 <__bss_end+0x638380>
    16b4:	000001f7 	strdeq	r0, [r0], -r7
    16b8:	206c9102 	rsbcs	r9, ip, r2, lsl #2
    16bc:	00001092 	muleq	r0, r2, r0
    16c0:	c6351901 	ldrtgt	r1, [r5], -r1, lsl #18
    16c4:	02000001 	andeq	r0, r0, #1
    16c8:	e11e6891 			; <UNDEFINED> instruction: 0xe11e6891
    16cc:	0100000c 	tsteq	r0, ip
    16d0:	004d0e1b 	subeq	r0, sp, fp, lsl lr
    16d4:	91020000 	mrsls	r0, (UNDEF: 2)
    16d8:	a3240074 			; <UNDEFINED> instruction: 0xa3240074
    16dc:	0100000d 	tsteq	r0, sp
    16e0:	0d100614 	ldceq	6, cr0, [r0, #-80]	; 0xffffffb0
    16e4:	83900000 	orrshi	r0, r0, #0
    16e8:	001c0000 	andseq	r0, ip, r0
    16ec:	9c010000 	stcls	0, cr0, [r1], {-0}
    16f0:	00108823 	andseq	r8, r0, r3, lsr #16
    16f4:	060e0100 	streq	r0, [lr], -r0, lsl #2
    16f8:	00000e2f 	andeq	r0, r0, pc, lsr #28
    16fc:	00008364 	andeq	r8, r0, r4, ror #6
    1700:	0000002c 	andeq	r0, r0, ip, lsr #32
    1704:	0af89c01 	beq	ffe28710 <__bss_end+0xffe1efd8>
    1708:	9a200000 	bls	801710 <__bss_end+0x7f7fd8>
    170c:	0100000d 	tsteq	r0, sp
    1710:	0038140e 	eorseq	r1, r8, lr, lsl #8
    1714:	91020000 	mrsls	r0, (UNDEF: 2)
    1718:	ea250074 	b	9418f0 <__bss_end+0x9381b8>
    171c:	01000010 	tsteq	r0, r0, lsl r0
    1720:	0e510a04 	vnmlseq.f32	s1, s2, s8
    1724:	004d0000 	subeq	r0, sp, r0
    1728:	83380000 	teqhi	r8, #0
    172c:	002c0000 	eoreq	r0, ip, r0
    1730:	9c010000 	stcls	0, cr0, [r1], {-0}
    1734:	64697022 	strbtvs	r7, [r9], #-34	; 0xffffffde
    1738:	0e060100 	adfeqs	f0, f6, f0
    173c:	0000004d 	andeq	r0, r0, sp, asr #32
    1740:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1744:	00032e00 	andeq	r2, r3, r0, lsl #28
    1748:	99000400 	stmdbls	r0, {sl}
    174c:	04000006 	streq	r0, [r0], #-6
    1750:	000e6201 	andeq	r6, lr, r1, lsl #4
    1754:	11cc0400 	bicne	r0, ip, r0, lsl #8
    1758:	0f8c0000 	svceq	0x008c0000
    175c:	87940000 	ldrhi	r0, [r4, r0]
    1760:	04b80000 	ldrteq	r0, [r8], #0
    1764:	07a30000 	streq	r0, [r3, r0]!
    1768:	49020000 	stmdbmi	r2, {}	; <UNPREDICTABLE>
    176c:	03000000 	movweq	r0, #0
    1770:	00001144 	andeq	r1, r0, r4, asr #2
    1774:	61100501 	tstvs	r0, r1, lsl #10
    1778:	11000000 	mrsne	r0, (UNDEF: 0)
    177c:	33323130 	teqcc	r2, #48, 2
    1780:	37363534 			; <UNDEFINED> instruction: 0x37363534
    1784:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    1788:	46454443 	strbmi	r4, [r5], -r3, asr #8
    178c:	01040000 	mrseq	r0, (UNDEF: 4)
    1790:	00250103 	eoreq	r0, r5, r3, lsl #2
    1794:	74050000 	strvc	r0, [r5], #-0
    1798:	61000000 	mrsvs	r0, (UNDEF: 0)
    179c:	06000000 	streq	r0, [r0], -r0
    17a0:	00000066 	andeq	r0, r0, r6, rrx
    17a4:	51070010 	tstpl	r7, r0, lsl r0
    17a8:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    17ac:	17c40704 	strbne	r0, [r4, r4, lsl #14]
    17b0:	01080000 	mrseq	r0, (UNDEF: 8)
    17b4:	000b6708 	andeq	r6, fp, r8, lsl #14
    17b8:	006d0700 	rsbeq	r0, sp, r0, lsl #14
    17bc:	2a090000 	bcs	2417c4 <__bss_end+0x23808c>
    17c0:	0a000000 	beq	17c8 <shift+0x17c8>
    17c4:	0000116e 	andeq	r1, r0, lr, ror #2
    17c8:	5e066401 	cdppl	4, 0, cr6, cr6, cr1, {0}
    17cc:	cc000011 	stcgt	0, cr0, [r0], {17}
    17d0:	8000008b 	andhi	r0, r0, fp, lsl #1
    17d4:	01000000 	mrseq	r0, (UNDEF: 0)
    17d8:	0000fb9c 	muleq	r0, ip, fp
    17dc:	72730b00 	rsbsvc	r0, r3, #0, 22
    17e0:	64010063 	strvs	r0, [r1], #-99	; 0xffffff9d
    17e4:	0000fb19 	andeq	pc, r0, r9, lsl fp	; <UNPREDICTABLE>
    17e8:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    17ec:	7473640b 	ldrbtvc	r6, [r3], #-1035	; 0xfffffbf5
    17f0:	24640100 	strbtcs	r0, [r4], #-256	; 0xffffff00
    17f4:	00000102 	andeq	r0, r0, r2, lsl #2
    17f8:	0b609102 	bleq	1825c08 <__bss_end+0x181c4d0>
    17fc:	006d756e 	rsbeq	r7, sp, lr, ror #10
    1800:	042d6401 	strteq	r6, [sp], #-1025	; 0xfffffbff
    1804:	02000001 	andeq	r0, r0, #1
    1808:	c00c5c91 	mulgt	ip, r1, ip
    180c:	01000011 	tsteq	r0, r1, lsl r0
    1810:	010b0e66 	tsteq	fp, r6, ror #28
    1814:	91020000 	mrsls	r0, (UNDEF: 2)
    1818:	11500c70 	cmpne	r0, r0, ror ip
    181c:	67010000 	strvs	r0, [r1, -r0]
    1820:	00011108 	andeq	r1, r1, r8, lsl #2
    1824:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1828:	008bf40d 	addeq	pc, fp, sp, lsl #8
    182c:	00004800 	andeq	r4, r0, r0, lsl #16
    1830:	00690e00 	rsbeq	r0, r9, r0, lsl #28
    1834:	040b6901 	streq	r6, [fp], #-2305	; 0xfffff6ff
    1838:	02000001 	andeq	r0, r0, #1
    183c:	00007491 	muleq	r0, r1, r4
    1840:	0101040f 	tsteq	r1, pc, lsl #8
    1844:	11100000 	tstne	r0, r0
    1848:	05041204 	streq	r1, [r4, #-516]	; 0xfffffdfc
    184c:	00746e69 	rsbseq	r6, r4, r9, ror #28
    1850:	0074040f 	rsbseq	r0, r4, pc, lsl #8
    1854:	040f0000 	streq	r0, [pc], #-0	; 185c <shift+0x185c>
    1858:	0000006d 	andeq	r0, r0, sp, rrx
    185c:	0011180a 	andseq	r1, r1, sl, lsl #16
    1860:	065c0100 	ldrbeq	r0, [ip], -r0, lsl #2
    1864:	00001125 	andeq	r1, r0, r5, lsr #2
    1868:	00008b64 	andeq	r8, r0, r4, ror #22
    186c:	00000068 	andeq	r0, r0, r8, rrx
    1870:	01769c01 	cmneq	r6, r1, lsl #24
    1874:	b9130000 	ldmdblt	r3, {}	; <UNPREDICTABLE>
    1878:	01000011 	tsteq	r0, r1, lsl r0
    187c:	0102125c 	tsteq	r2, ip, asr r2
    1880:	91020000 	mrsls	r0, (UNDEF: 2)
    1884:	111e136c 	tstne	lr, ip, ror #6
    1888:	5c010000 	stcpl	0, cr0, [r1], {-0}
    188c:	0001041e 	andeq	r0, r1, lr, lsl r4
    1890:	68910200 	ldmvs	r1, {r9}
    1894:	6d656d0e 	stclvs	13, cr6, [r5, #-56]!	; 0xffffffc8
    1898:	085e0100 	ldmdaeq	lr, {r8}^
    189c:	00000111 	andeq	r0, r0, r1, lsl r1
    18a0:	0d709102 	ldfeqp	f1, [r0, #-8]!
    18a4:	00008b80 	andeq	r8, r0, r0, lsl #23
    18a8:	0000003c 	andeq	r0, r0, ip, lsr r0
    18ac:	0100690e 	tsteq	r0, lr, lsl #18
    18b0:	01040b60 	tsteq	r4, r0, ror #22
    18b4:	91020000 	mrsls	r0, (UNDEF: 2)
    18b8:	14000074 	strne	r0, [r0], #-116	; 0xffffff8c
    18bc:	00001175 	andeq	r1, r0, r5, ror r1
    18c0:	8e055201 	cdphi	2, 0, cr5, cr5, cr1, {0}
    18c4:	04000011 	streq	r0, [r0], #-17	; 0xffffffef
    18c8:	10000001 	andne	r0, r0, r1
    18cc:	5400008b 	strpl	r0, [r0], #-139	; 0xffffff75
    18d0:	01000000 	mrseq	r0, (UNDEF: 0)
    18d4:	0001af9c 	muleq	r1, ip, pc	; <UNPREDICTABLE>
    18d8:	00730b00 	rsbseq	r0, r3, r0, lsl #22
    18dc:	0b185201 	bleq	6160e8 <__bss_end+0x60c9b0>
    18e0:	02000001 	andeq	r0, r0, #1
    18e4:	690e6c91 	stmdbvs	lr, {r0, r4, r7, sl, fp, sp, lr}
    18e8:	06540100 	ldrbeq	r0, [r4], -r0, lsl #2
    18ec:	00000104 	andeq	r0, r0, r4, lsl #2
    18f0:	00749102 	rsbseq	r9, r4, r2, lsl #2
    18f4:	0011b114 	andseq	fp, r1, r4, lsl r1
    18f8:	05420100 	strbeq	r0, [r2, #-256]	; 0xffffff00
    18fc:	0000117c 	andeq	r1, r0, ip, ror r1
    1900:	00000104 	andeq	r0, r0, r4, lsl #2
    1904:	00008a64 	andeq	r8, r0, r4, ror #20
    1908:	000000ac 	andeq	r0, r0, ip, lsr #1
    190c:	02159c01 	andseq	r9, r5, #256	; 0x100
    1910:	730b0000 	movwvc	r0, #45056	; 0xb000
    1914:	42010031 	andmi	r0, r1, #49	; 0x31
    1918:	00010b19 	andeq	r0, r1, r9, lsl fp
    191c:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1920:	0032730b 	eorseq	r7, r2, fp, lsl #6
    1924:	0b294201 	bleq	a52130 <__bss_end+0xa489f8>
    1928:	02000001 	andeq	r0, r0, #1
    192c:	6e0b6891 	mcrvs	8, 0, r6, cr11, cr1, {4}
    1930:	01006d75 	tsteq	r0, r5, ror sp
    1934:	01043142 	tsteq	r4, r2, asr #2
    1938:	91020000 	mrsls	r0, (UNDEF: 2)
    193c:	31750e64 	cmncc	r5, r4, ror #28
    1940:	10440100 	subne	r0, r4, r0, lsl #2
    1944:	00000215 	andeq	r0, r0, r5, lsl r2
    1948:	0e779102 	expeqs	f1, f2
    194c:	01003275 	tsteq	r0, r5, ror r2
    1950:	02151444 	andseq	r1, r5, #68, 8	; 0x44000000
    1954:	91020000 	mrsls	r0, (UNDEF: 2)
    1958:	01080076 	tsteq	r8, r6, ror r0
    195c:	000b5e08 	andeq	r5, fp, r8, lsl #28
    1960:	11311400 	teqne	r1, r0, lsl #8
    1964:	36010000 	strcc	r0, [r1], -r0
    1968:	0011a007 	andseq	sl, r1, r7
    196c:	00011100 	andeq	r1, r1, r0, lsl #2
    1970:	0089a400 	addeq	sl, r9, r0, lsl #8
    1974:	0000c000 	andeq	ip, r0, r0
    1978:	759c0100 	ldrvc	r0, [ip, #256]	; 0x100
    197c:	13000002 	movwne	r0, #2
    1980:	00001113 	andeq	r1, r0, r3, lsl r1
    1984:	11153601 	tstne	r5, r1, lsl #12
    1988:	02000001 	andeq	r0, r0, #1
    198c:	730b6c91 	movwvc	r6, #48273	; 0xbc91
    1990:	01006372 	tsteq	r0, r2, ror r3
    1994:	010b2736 	tsteq	fp, r6, lsr r7
    1998:	91020000 	mrsls	r0, (UNDEF: 2)
    199c:	756e0b68 	strbvc	r0, [lr, #-2920]!	; 0xfffff498
    19a0:	3601006d 	strcc	r0, [r1], -sp, rrx
    19a4:	00010430 	andeq	r0, r1, r0, lsr r4
    19a8:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    19ac:	0100690e 	tsteq	r0, lr, lsl #18
    19b0:	01040638 	tsteq	r4, r8, lsr r6
    19b4:	91020000 	mrsls	r0, (UNDEF: 2)
    19b8:	9b140074 	blls	501b90 <__bss_end+0x4f8458>
    19bc:	01000011 	tsteq	r0, r1, lsl r0
    19c0:	11390524 	teqne	r9, r4, lsr #10
    19c4:	01040000 	mrseq	r0, (UNDEF: 4)
    19c8:	89080000 	stmdbhi	r8, {}	; <UNPREDICTABLE>
    19cc:	009c0000 	addseq	r0, ip, r0
    19d0:	9c010000 	stcls	0, cr0, [r1], {-0}
    19d4:	000002b2 			; <UNDEFINED> instruction: 0x000002b2
    19d8:	00110d13 	andseq	r0, r1, r3, lsl sp
    19dc:	16240100 	strtne	r0, [r4], -r0, lsl #2
    19e0:	0000010b 	andeq	r0, r0, fp, lsl #2
    19e4:	0c6c9102 	stfeqp	f1, [ip], #-8
    19e8:	00001157 	andeq	r1, r0, r7, asr r1
    19ec:	04062601 	streq	r2, [r6], #-1537	; 0xfffff9ff
    19f0:	02000001 	andeq	r0, r0, #1
    19f4:	15007491 	strne	r7, [r0, #-1169]	; 0xfffffb6f
    19f8:	000011c7 	andeq	r1, r0, r7, asr #3
    19fc:	1a060801 	bne	183a08 <__bss_end+0x17a2d0>
    1a00:	94000012 	strls	r0, [r0], #-18	; 0xffffffee
    1a04:	74000087 	strvc	r0, [r0], #-135	; 0xffffff79
    1a08:	01000001 	tsteq	r0, r1
    1a0c:	110d139c 			; <UNDEFINED> instruction: 0x110d139c
    1a10:	08010000 	stmdaeq	r1, {}	; <UNPREDICTABLE>
    1a14:	00006618 	andeq	r6, r0, r8, lsl r6
    1a18:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    1a1c:	00115713 	andseq	r5, r1, r3, lsl r7
    1a20:	25080100 	strcs	r0, [r8, #-256]	; 0xffffff00
    1a24:	00000111 	andeq	r0, r0, r1, lsl r1
    1a28:	13609102 	cmnne	r0, #-2147483648	; 0x80000000
    1a2c:	000014be 			; <UNDEFINED> instruction: 0x000014be
    1a30:	663a0801 	ldrtvs	r0, [sl], -r1, lsl #16
    1a34:	02000000 	andeq	r0, r0, #0
    1a38:	690e5c91 	stmdbvs	lr, {r0, r4, r7, sl, fp, ip, lr}
    1a3c:	060a0100 	streq	r0, [sl], -r0, lsl #2
    1a40:	00000104 	andeq	r0, r0, r4, lsl #2
    1a44:	0d749102 	ldfeqp	f1, [r4, #-8]!
    1a48:	00008860 	andeq	r8, r0, r0, ror #16
    1a4c:	00000098 	muleq	r0, r8, r0
    1a50:	01006a0e 	tsteq	r0, lr, lsl #20
    1a54:	01040b1c 	tsteq	r4, ip, lsl fp
    1a58:	91020000 	mrsls	r0, (UNDEF: 2)
    1a5c:	88880d70 	stmhi	r8, {r4, r5, r6, r8, sl, fp}
    1a60:	00600000 	rsbeq	r0, r0, r0
    1a64:	630e0000 	movwvs	r0, #57344	; 0xe000
    1a68:	081e0100 	ldmdaeq	lr, {r8}
    1a6c:	0000006d 	andeq	r0, r0, sp, rrx
    1a70:	006f9102 	rsbeq	r9, pc, r2, lsl #2
    1a74:	4d000000 	stcmi	0, cr0, [r0, #-0]
    1a78:	0400000f 	streq	r0, [r0], #-15
    1a7c:	0007c000 	andeq	ip, r7, r0
    1a80:	62010400 	andvs	r0, r1, #0, 8
    1a84:	0400000e 	streq	r0, [r0], #-14
    1a88:	00001282 	andeq	r1, r0, r2, lsl #5
    1a8c:	00000f8c 	andeq	r0, r0, ip, lsl #31
    1a90:	00008c4c 	andeq	r8, r0, ip, asr #24
    1a94:	000004b4 			; <UNDEFINED> instruction: 0x000004b4
    1a98:	00000a32 	andeq	r0, r0, r2, lsr sl
    1a9c:	67080102 	strvs	r0, [r8, -r2, lsl #2]
    1aa0:	0300000b 	movweq	r0, #11
    1aa4:	00000025 	andeq	r0, r0, r5, lsr #32
    1aa8:	02050202 	andeq	r0, r5, #536870912	; 0x20000000
    1aac:	0400000a 	streq	r0, [r0], #-10
    1ab0:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
    1ab4:	38030074 	stmdacc	r3, {r2, r4, r5, r6}
    1ab8:	05000000 	streq	r0, [r0, #-0]
    1abc:	000013c1 	andeq	r1, r0, r1, asr #7
    1ac0:	55070702 	strpl	r0, [r7, #-1794]	; 0xfffff8fe
    1ac4:	03000000 	movweq	r0, #0
    1ac8:	00000044 	andeq	r0, r0, r4, asr #32
    1acc:	5e080102 	adfple	f0, f0, f2
    1ad0:	0500000b 	streq	r0, [r0, #-11]
    1ad4:	00000996 	muleq	r0, r6, r9
    1ad8:	6d070802 	stcvs	8, cr0, [r7, #-8]
    1adc:	03000000 	movweq	r0, #0
    1ae0:	0000005c 	andeq	r0, r0, ip, asr r0
    1ae4:	27070202 	strcs	r0, [r7, -r2, lsl #4]
    1ae8:	0500000c 	streq	r0, [r0, #-12]
    1aec:	000005f1 	strdeq	r0, [r0], -r1
    1af0:	85070902 	strhi	r0, [r7, #-2306]	; 0xfffff6fe
    1af4:	03000000 	movweq	r0, #0
    1af8:	00000074 	andeq	r0, r0, r4, ror r0
    1afc:	c4070402 	strgt	r0, [r7], #-1026	; 0xfffffbfe
    1b00:	03000017 	movweq	r0, #23
    1b04:	00000085 	andeq	r0, r0, r5, lsl #1
    1b08:	000a0d06 	andeq	r0, sl, r6, lsl #26
    1b0c:	06030800 	streq	r0, [r3], -r0, lsl #16
    1b10:	0001d507 	andeq	sp, r1, r7, lsl #10
    1b14:	07330700 	ldreq	r0, [r3, -r0, lsl #14]!
    1b18:	0a030000 	beq	c1b20 <__bss_end+0xb83e8>
    1b1c:	00007412 	andeq	r7, r0, r2, lsl r4
    1b20:	9f070000 	svcls	0x00070000
    1b24:	03000009 	movweq	r0, #9
    1b28:	01da0e0c 	bicseq	r0, sl, ip, lsl #28
    1b2c:	08040000 	stmdaeq	r4, {}	; <UNPREDICTABLE>
    1b30:	00000a0d 	andeq	r0, r0, sp, lsl #20
    1b34:	a6091003 	strge	r1, [r9], -r3
    1b38:	e6000005 	str	r0, [r0], -r5
    1b3c:	01000001 	tsteq	r0, r1
    1b40:	000000d1 	ldrdeq	r0, [r0], -r1
    1b44:	000000dc 	ldrdeq	r0, [r0], -ip
    1b48:	0001e609 	andeq	lr, r1, r9, lsl #12
    1b4c:	01f10a00 	mvnseq	r0, r0, lsl #20
    1b50:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    1b54:	00000a0c 	andeq	r0, r0, ip, lsl #20
    1b58:	e2151203 	ands	r1, r5, #805306368	; 0x30000000
    1b5c:	f7000009 			; <UNDEFINED> instruction: 0xf7000009
    1b60:	01000001 	tsteq	r0, r1
    1b64:	000000f5 	strdeq	r0, [r0], -r5
    1b68:	00000100 	andeq	r0, r0, r0, lsl #2
    1b6c:	0001e609 	andeq	lr, r1, r9, lsl #12
    1b70:	00380900 	eorseq	r0, r8, r0, lsl #18
    1b74:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    1b78:	000005bf 			; <UNDEFINED> instruction: 0x000005bf
    1b7c:	820e1503 	andhi	r1, lr, #12582912	; 0xc00000
    1b80:	da000007 	ble	1ba4 <shift+0x1ba4>
    1b84:	01000001 	tsteq	r0, r1
    1b88:	00000119 	andeq	r0, r0, r9, lsl r1
    1b8c:	0000011f 	andeq	r0, r0, pc, lsl r1
    1b90:	0001f909 	andeq	pc, r1, r9, lsl #18
    1b94:	d70b0000 	strle	r0, [fp, -r0]
    1b98:	0300000a 	movweq	r0, #10
    1b9c:	06ce0e18 			; <UNDEFINED> instruction: 0x06ce0e18
    1ba0:	34010000 	strcc	r0, [r1], #-0
    1ba4:	3a000001 	bcc	1bb0 <shift+0x1bb0>
    1ba8:	09000001 	stmdbeq	r0, {r0}
    1bac:	000001e6 	andeq	r0, r0, r6, ror #3
    1bb0:	077c0b00 	ldrbeq	r0, [ip, -r0, lsl #22]!
    1bb4:	1b030000 	blne	c1bbc <__bss_end+0xb8484>
    1bb8:	0005fa0e 	andeq	pc, r5, lr, lsl #20
    1bbc:	014f0100 	mrseq	r0, (UNDEF: 95)
    1bc0:	015a0000 	cmpeq	sl, r0
    1bc4:	e6090000 	str	r0, [r9], -r0
    1bc8:	0a000001 	beq	1bd4 <shift+0x1bd4>
    1bcc:	000001da 	ldrdeq	r0, [r0], -sl
    1bd0:	0b460b00 	bleq	11847d8 <__bss_end+0x117b0a0>
    1bd4:	1d030000 	stcne	0, cr0, [r3, #-0]
    1bd8:	000bc40e 	andeq	ip, fp, lr, lsl #8
    1bdc:	016f0100 	cmneq	pc, r0, lsl #2
    1be0:	01840000 	orreq	r0, r4, r0
    1be4:	e6090000 	str	r0, [r9], -r0
    1be8:	0a000001 	beq	1bf4 <shift+0x1bf4>
    1bec:	0000005c 	andeq	r0, r0, ip, asr r0
    1bf0:	00005c0a 	andeq	r5, r0, sl, lsl #24
    1bf4:	01da0a00 	bicseq	r0, sl, r0, lsl #20
    1bf8:	0b000000 	bleq	1c00 <shift+0x1c00>
    1bfc:	0000061f 	andeq	r0, r0, pc, lsl r6
    1c00:	070e1f03 	streq	r1, [lr, -r3, lsl #30]
    1c04:	01000005 	tsteq	r0, r5
    1c08:	00000199 	muleq	r0, r9, r1
    1c0c:	000001ae 	andeq	r0, r0, lr, lsr #3
    1c10:	0001e609 	andeq	lr, r1, r9, lsl #12
    1c14:	005c0a00 	subseq	r0, ip, r0, lsl #20
    1c18:	5c0a0000 	stcpl	0, cr0, [sl], {-0}
    1c1c:	0a000000 	beq	1c24 <shift+0x1c24>
    1c20:	00000025 	andeq	r0, r0, r5, lsr #32
    1c24:	0c3f0c00 	ldceq	12, cr0, [pc], #-0	; 1c2c <shift+0x1c2c>
    1c28:	21030000 	mrscs	r0, (UNDEF: 3)
    1c2c:	000ab20e 	andeq	fp, sl, lr, lsl #4
    1c30:	01bf0100 			; <UNDEFINED> instruction: 0x01bf0100
    1c34:	e6090000 	str	r0, [r9], -r0
    1c38:	0a000001 	beq	1c44 <shift+0x1c44>
    1c3c:	0000005c 	andeq	r0, r0, ip, asr r0
    1c40:	00005c0a 	andeq	r5, r0, sl, lsl #24
    1c44:	01f10a00 	mvnseq	r0, r0, lsl #20
    1c48:	00000000 	andeq	r0, r0, r0
    1c4c:	00009103 	andeq	r9, r0, r3, lsl #2
    1c50:	02010200 	andeq	r0, r1, #0, 4
    1c54:	0000086d 	andeq	r0, r0, sp, ror #16
    1c58:	0001da03 	andeq	sp, r1, r3, lsl #20
    1c5c:	91040d00 	tstls	r4, r0, lsl #26
    1c60:	03000000 	movweq	r0, #0
    1c64:	000001e6 	andeq	r0, r0, r6, ror #3
    1c68:	002c040d 	eoreq	r0, ip, sp, lsl #8
    1c6c:	040e0000 	streq	r0, [lr], #-0
    1c70:	01d5040d 	bicseq	r0, r5, sp, lsl #8
    1c74:	f9030000 			; <UNDEFINED> instruction: 0xf9030000
    1c78:	0f000001 	svceq	0x00000001
    1c7c:	00000cd0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    1c80:	08060408 	stmdaeq	r6, {r3, sl}
    1c84:	0000022a 	andeq	r0, r0, sl, lsr #4
    1c88:	00307210 	eorseq	r7, r0, r0, lsl r2
    1c8c:	740e0804 	strvc	r0, [lr], #-2052	; 0xfffff7fc
    1c90:	00000000 	andeq	r0, r0, r0
    1c94:	00317210 	eorseq	r7, r1, r0, lsl r2
    1c98:	740e0904 	strvc	r0, [lr], #-2308	; 0xfffff6fc
    1c9c:	04000000 	streq	r0, [r0], #-0
    1ca0:	0a5c1100 	beq	17060a8 <__bss_end+0x16fc970>
    1ca4:	04050000 	streq	r0, [r5], #-0
    1ca8:	00000038 	andeq	r0, r0, r8, lsr r0
    1cac:	610c1e04 	tstvs	ip, r4, lsl #28
    1cb0:	12000002 	andne	r0, r0, #2
    1cb4:	000005e9 	andeq	r0, r0, r9, ror #11
    1cb8:	07401200 	strbeq	r1, [r0, -r0, lsl #4]
    1cbc:	12010000 	andne	r0, r1, #0
    1cc0:	00000a7e 	andeq	r0, r0, lr, ror sl
    1cc4:	0b7a1202 	bleq	1e864d4 <__bss_end+0x1e7cd9c>
    1cc8:	12030000 	andne	r0, r3, #0
    1ccc:	0000071e 	andeq	r0, r0, lr, lsl r7
    1cd0:	09f91204 	ldmibeq	r9!, {r2, r9, ip}^
    1cd4:	00050000 	andeq	r0, r5, r0
    1cd8:	000a4411 	andeq	r4, sl, r1, lsl r4
    1cdc:	38040500 	stmdacc	r4, {r8, sl}
    1ce0:	04000000 	streq	r0, [r0], #-0
    1ce4:	029e0c3f 	addseq	r0, lr, #16128	; 0x3f00
    1ce8:	be120000 	cdplt	0, 1, cr0, cr2, cr0, {0}
    1cec:	00000006 	andeq	r0, r0, r6
    1cf0:	00073b12 	andeq	r3, r7, r2, lsl fp
    1cf4:	69120100 	ldmdbvs	r2, {r8}
    1cf8:	0200000c 	andeq	r0, r0, #12
    1cfc:	00094412 	andeq	r4, r9, r2, lsl r4
    1d00:	2d120300 	ldccs	3, cr0, [r2, #-0]
    1d04:	04000007 	streq	r0, [r0], #-7
    1d08:	0007a212 	andeq	sl, r7, r2, lsl r2
    1d0c:	28120500 	ldmdacs	r2, {r8, sl}
    1d10:	06000006 	streq	r0, [r0], -r6
    1d14:	09221300 	stmdbeq	r2!, {r8, r9, ip}
    1d18:	05050000 	streq	r0, [r5, #-0]
    1d1c:	00008014 	andeq	r8, r0, r4, lsl r0
    1d20:	70030500 	andvc	r0, r3, r0, lsl #10
    1d24:	13000094 	movwne	r0, #148	; 0x94
    1d28:	00000ae8 	andeq	r0, r0, r8, ror #21
    1d2c:	80140605 	andshi	r0, r4, r5, lsl #12
    1d30:	05000000 	streq	r0, [r0, #-0]
    1d34:	00947403 	addseq	r7, r4, r3, lsl #8
    1d38:	07b71300 	ldreq	r1, [r7, r0, lsl #6]!
    1d3c:	07060000 	streq	r0, [r6, -r0]
    1d40:	0000801a 	andeq	r8, r0, sl, lsl r0
    1d44:	78030500 	stmdavc	r3, {r8, sl}
    1d48:	13000094 	movwne	r0, #148	; 0x94
    1d4c:	00000a1b 	andeq	r0, r0, fp, lsl sl
    1d50:	801a0906 	andshi	r0, sl, r6, lsl #18
    1d54:	05000000 	streq	r0, [r0, #-0]
    1d58:	00947c03 	addseq	r7, r4, r3, lsl #24
    1d5c:	07a91300 	streq	r1, [r9, r0, lsl #6]!
    1d60:	0b060000 	bleq	181d68 <__bss_end+0x178630>
    1d64:	0000801a 	andeq	r8, r0, sl, lsl r0
    1d68:	80030500 	andhi	r0, r3, r0, lsl #10
    1d6c:	13000094 	movwne	r0, #148	; 0x94
    1d70:	000009cf 	andeq	r0, r0, pc, asr #19
    1d74:	801a0d06 	andshi	r0, sl, r6, lsl #26
    1d78:	05000000 	streq	r0, [r0, #-0]
    1d7c:	00948403 	addseq	r8, r4, r3, lsl #8
    1d80:	05c91300 	strbeq	r1, [r9, #768]	; 0x300
    1d84:	0f060000 	svceq	0x00060000
    1d88:	0000801a 	andeq	r8, r0, sl, lsl r0
    1d8c:	88030500 	stmdahi	r3, {r8, sl}
    1d90:	14000094 	strne	r0, [r0], #-148	; 0xffffff6c
    1d94:	0000041d 	andeq	r0, r0, sp, lsl r4
    1d98:	031c040d 	tsteq	ip, #218103808	; 0xd000000
    1d9c:	5f130000 	svcpl	0x00130000
    1da0:	07000005 	streq	r0, [r0, -r5]
    1da4:	00801404 	addeq	r1, r0, r4, lsl #8
    1da8:	03050000 	movweq	r0, #20480	; 0x5000
    1dac:	0000948c 	andeq	r9, r0, ip, lsl #9
    1db0:	000a8413 	andeq	r8, sl, r3, lsl r4
    1db4:	14070700 	strne	r0, [r7], #-1792	; 0xfffff900
    1db8:	00000080 	andeq	r0, r0, r0, lsl #1
    1dbc:	94900305 	ldrls	r0, [r0], #773	; 0x305
    1dc0:	a6130000 	ldrge	r0, [r3], -r0
    1dc4:	07000004 	streq	r0, [r0, -r4]
    1dc8:	0080140a 	addeq	r1, r0, sl, lsl #8
    1dcc:	03050000 	movweq	r0, #20480	; 0x5000
    1dd0:	00009494 	muleq	r0, r4, r4
    1dd4:	00062d11 	andeq	r2, r6, r1, lsl sp
    1dd8:	38040500 	stmdacc	r4, {r8, sl}
    1ddc:	07000000 	streq	r0, [r0, -r0]
    1de0:	03940c0d 	orrseq	r0, r4, #3328	; 0xd00
    1de4:	4e150000 	cdpmi	0, 1, cr0, cr5, cr0, {0}
    1de8:	00007765 	andeq	r7, r0, r5, ror #14
    1dec:	00048612 	andeq	r8, r4, r2, lsl r6
    1df0:	9e120100 	muflss	f0, f2, f0
    1df4:	02000004 	andeq	r0, r0, #4
    1df8:	00064612 	andeq	r4, r6, r2, lsl r6
    1dfc:	6c120300 	ldcvs	3, cr0, [r2], {-0}
    1e00:	0400000b 	streq	r0, [r0], #-11
    1e04:	00047a12 	andeq	r7, r4, r2, lsl sl
    1e08:	0f000500 	svceq	0x00000500
    1e0c:	00000578 	andeq	r0, r0, r8, ror r5
    1e10:	081b0710 	ldmdaeq	fp, {r4, r8, r9, sl}
    1e14:	000003d3 	ldrdeq	r0, [r0], -r3
    1e18:	00726c10 	rsbseq	r6, r2, r0, lsl ip
    1e1c:	d3131d07 	tstle	r3, #448	; 0x1c0
    1e20:	00000003 	andeq	r0, r0, r3
    1e24:	00707310 	rsbseq	r7, r0, r0, lsl r3
    1e28:	d3131e07 	tstle	r3, #7, 28	; 0x70
    1e2c:	04000003 	streq	r0, [r0], #-3
    1e30:	00637010 	rsbeq	r7, r3, r0, lsl r0
    1e34:	d3131f07 	tstle	r3, #7, 30
    1e38:	08000003 	stmdaeq	r0, {r0, r1}
    1e3c:	000a3e07 	andeq	r3, sl, r7, lsl #28
    1e40:	13200700 	nopne	{0}	; <UNPREDICTABLE>
    1e44:	000003d3 	ldrdeq	r0, [r0], -r3
    1e48:	0402000c 	streq	r0, [r2], #-12
    1e4c:	0017bf07 	andseq	fp, r7, r7, lsl #30
    1e50:	03d30300 	bicseq	r0, r3, #0, 6
    1e54:	110f0000 	mrsne	r0, CPSR
    1e58:	70000007 	andvc	r0, r0, r7
    1e5c:	6f082807 	svcvs	0x00082807
    1e60:	07000004 	streq	r0, [r0, -r4]
    1e64:	000006a3 	andeq	r0, r0, r3, lsr #13
    1e68:	94122a07 	ldrls	r2, [r2], #-2567	; 0xfffff5f9
    1e6c:	00000003 	andeq	r0, r0, r3
    1e70:	64697010 	strbtvs	r7, [r9], #-16
    1e74:	122b0700 	eorne	r0, fp, #0, 14
    1e78:	00000085 	andeq	r0, r0, r5, lsl #1
    1e7c:	0b9f0710 	bleq	fe7c3ac4 <__bss_end+0xfe7ba38c>
    1e80:	2c070000 	stccs	0, cr0, [r7], {-0}
    1e84:	00035d11 	andeq	r5, r3, r1, lsl sp
    1e88:	50071400 	andpl	r1, r7, r0, lsl #8
    1e8c:	0700000b 	streq	r0, [r0, -fp]
    1e90:	0085122d 	addeq	r1, r5, sp, lsr #4
    1e94:	07180000 	ldreq	r0, [r8, -r0]
    1e98:	000003ad 	andeq	r0, r0, sp, lsr #7
    1e9c:	85122e07 	ldrhi	r2, [r2, #-3591]	; 0xfffff1f9
    1ea0:	1c000000 	stcne	0, cr0, [r0], {-0}
    1ea4:	000a7107 	andeq	r7, sl, r7, lsl #2
    1ea8:	0c2f0700 	stceq	7, cr0, [pc], #-0	; 1eb0 <shift+0x1eb0>
    1eac:	0000046f 	andeq	r0, r0, pc, ror #8
    1eb0:	04360720 	ldrteq	r0, [r6], #-1824	; 0xfffff8e0
    1eb4:	30070000 	andcc	r0, r7, r0
    1eb8:	00003809 	andeq	r3, r0, r9, lsl #16
    1ebc:	61076000 	mrsvs	r6, (UNDEF: 7)
    1ec0:	07000006 	streq	r0, [r0, -r6]
    1ec4:	00740e31 	rsbseq	r0, r4, r1, lsr lr
    1ec8:	07640000 	strbeq	r0, [r4, -r0]!
    1ecc:	00000988 	andeq	r0, r0, r8, lsl #19
    1ed0:	740e3307 	strvc	r3, [lr], #-775	; 0xfffffcf9
    1ed4:	68000000 	stmdavs	r0, {}	; <UNPREDICTABLE>
    1ed8:	00097f07 	andeq	r7, r9, r7, lsl #30
    1edc:	0e340700 	cdpeq	7, 3, cr0, cr4, cr0, {0}
    1ee0:	00000074 	andeq	r0, r0, r4, ror r0
    1ee4:	2116006c 	tstcs	r6, ip, rrx
    1ee8:	7f000003 	svcvc	0x00000003
    1eec:	17000004 	strne	r0, [r0, -r4]
    1ef0:	00000085 	andeq	r0, r0, r5, lsl #1
    1ef4:	8f13000f 	svchi	0x0013000f
    1ef8:	08000004 	stmdaeq	r0, {r2}
    1efc:	0080140a 	addeq	r1, r0, sl, lsl #8
    1f00:	03050000 	movweq	r0, #20480	; 0x5000
    1f04:	00009498 	muleq	r0, r8, r4
    1f08:	0007f211 	andeq	pc, r7, r1, lsl r2	; <UNPREDICTABLE>
    1f0c:	38040500 	stmdacc	r4, {r8, sl}
    1f10:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    1f14:	04b00c0d 	ldrteq	r0, [r0], #3085	; 0xc0d
    1f18:	6f120000 	svcvs	0x00120000
    1f1c:	0000000c 	andeq	r0, r0, ip
    1f20:	000bb912 	andeq	fp, fp, r2, lsl r9
    1f24:	0f000100 	svceq	0x00000100
    1f28:	00000690 	muleq	r0, r0, r6
    1f2c:	081b080c 	ldmdaeq	fp, {r2, r3, fp}
    1f30:	000004e5 	andeq	r0, r0, r5, ror #9
    1f34:	00050207 	andeq	r0, r5, r7, lsl #4
    1f38:	191d0800 	ldmdbne	sp, {fp}
    1f3c:	000004e5 	andeq	r0, r0, r5, ror #9
    1f40:	04810700 	streq	r0, [r1], #1792	; 0x700
    1f44:	1e080000 	cdpne	0, 0, cr0, cr8, cr0, {0}
    1f48:	0004e519 	andeq	lr, r4, r9, lsl r5
    1f4c:	16070400 	strne	r0, [r7], -r0, lsl #8
    1f50:	08000008 	stmdaeq	r0, {r3}
    1f54:	04eb131f 	strbteq	r1, [fp], #799	; 0x31f
    1f58:	00080000 	andeq	r0, r8, r0
    1f5c:	04b0040d 	ldrteq	r0, [r0], #1037	; 0x40d
    1f60:	040d0000 	streq	r0, [sp], #-0
    1f64:	000003df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    1f68:	000a2d06 	andeq	r2, sl, r6, lsl #26
    1f6c:	22081400 	andcs	r1, r8, #0, 8
    1f70:	00077307 	andeq	r7, r7, r7, lsl #6
    1f74:	09300700 	ldmdbeq	r0!, {r8, r9, sl}
    1f78:	26080000 	strcs	r0, [r8], -r0
    1f7c:	00007412 	andeq	r7, r0, r2, lsl r4
    1f80:	d2070000 	andle	r0, r7, #0
    1f84:	08000008 	stmdaeq	r0, {r3}
    1f88:	04e51d29 	strbteq	r1, [r5], #3369	; 0xd29
    1f8c:	07040000 	streq	r0, [r4, -r0]
    1f90:	0000064e 	andeq	r0, r0, lr, asr #12
    1f94:	e51d2c08 	ldr	r2, [sp, #-3080]	; 0xfffff3f8
    1f98:	08000004 	stmdaeq	r0, {r2}
    1f9c:	00093a18 	andeq	r3, r9, r8, lsl sl
    1fa0:	0e2f0800 	cdpeq	8, 2, cr0, cr15, cr0, {0}
    1fa4:	0000066d 	andeq	r0, r0, sp, ror #12
    1fa8:	00000539 	andeq	r0, r0, r9, lsr r5
    1fac:	00000544 	andeq	r0, r0, r4, asr #10
    1fb0:	00077809 	andeq	r7, r7, r9, lsl #16
    1fb4:	04e50a00 	strbteq	r0, [r5], #2560	; 0xa00
    1fb8:	19000000 	stmdbne	r0, {}	; <UNPREDICTABLE>
    1fbc:	0000074a 	andeq	r0, r0, sl, asr #14
    1fc0:	e80e3108 	stmda	lr, {r3, r8, ip, sp}
    1fc4:	da000006 	ble	1fe4 <shift+0x1fe4>
    1fc8:	5c000001 	stcpl	0, cr0, [r0], {1}
    1fcc:	67000005 	strvs	r0, [r0, -r5]
    1fd0:	09000005 	stmdbeq	r0, {r0, r2}
    1fd4:	00000778 	andeq	r0, r0, r8, ror r7
    1fd8:	0004eb0a 	andeq	lr, r4, sl, lsl #22
    1fdc:	80080000 	andhi	r0, r8, r0
    1fe0:	0800000b 	stmdaeq	r0, {r0, r1, r3}
    1fe4:	07cd1d35 			; <UNDEFINED> instruction: 0x07cd1d35
    1fe8:	04e50000 	strbteq	r0, [r5], #0
    1fec:	80020000 	andhi	r0, r2, r0
    1ff0:	86000005 	strhi	r0, [r0], -r5
    1ff4:	09000005 	stmdbeq	r0, {r0, r2}
    1ff8:	00000778 	andeq	r0, r0, r8, ror r7
    1ffc:	06390800 	ldrteq	r0, [r9], -r0, lsl #16
    2000:	37080000 	strcc	r0, [r8, -r0]
    2004:	00094a1d 	andeq	r4, r9, sp, lsl sl
    2008:	0004e500 	andeq	lr, r4, r0, lsl #10
    200c:	059f0200 	ldreq	r0, [pc, #512]	; 2214 <shift+0x2214>
    2010:	05a50000 	streq	r0, [r5, #0]!
    2014:	78090000 	stmdavc	r9, {}	; <UNPREDICTABLE>
    2018:	00000007 	andeq	r0, r0, r7
    201c:	0008e51a 	andeq	lr, r8, sl, lsl r5
    2020:	31390800 	teqcc	r9, r0, lsl #16
    2024:	00000791 	muleq	r0, r1, r7
    2028:	2d08020c 	sfmcs	f0, 4, [r8, #-48]	; 0xffffffd0
    202c:	0800000a 	stmdaeq	r0, {r1, r3}
    2030:	0759093c 	smmlareq	r9, ip, r9, r0
    2034:	07780000 	ldrbeq	r0, [r8, -r0]!
    2038:	cc010000 	stcgt	0, cr0, [r1], {-0}
    203c:	d2000005 	andle	r0, r0, #5
    2040:	09000005 	stmdbeq	r0, {r0, r2}
    2044:	00000778 	andeq	r0, r0, r8, ror r7
    2048:	06af0800 	strteq	r0, [pc], r0, lsl #16
    204c:	3f080000 	svccc	0x00080000
    2050:	0004d712 	andeq	sp, r4, r2, lsl r7
    2054:	00007400 	andeq	r7, r0, r0, lsl #8
    2058:	05eb0100 	strbeq	r0, [fp, #256]!	; 0x100
    205c:	06000000 	streq	r0, [r0], -r0
    2060:	78090000 	stmdavc	r9, {}	; <UNPREDICTABLE>
    2064:	0a000007 	beq	2088 <shift+0x2088>
    2068:	0000079a 	muleq	r0, sl, r7
    206c:	0000850a 	andeq	r8, r0, sl, lsl #10
    2070:	01da0a00 	bicseq	r0, sl, r0, lsl #20
    2074:	0b000000 	bleq	207c <shift+0x207c>
    2078:	00000bb0 			; <UNDEFINED> instruction: 0x00000bb0
    207c:	850e4208 	strhi	r4, [lr, #-520]	; 0xfffffdf8
    2080:	01000005 	tsteq	r0, r5
    2084:	00000615 	andeq	r0, r0, r5, lsl r6
    2088:	0000061b 	andeq	r0, r0, fp, lsl r6
    208c:	00077809 	andeq	r7, r7, r9, lsl #16
    2090:	b9080000 	stmdblt	r8, {}	; <UNPREDICTABLE>
    2094:	08000004 	stmdaeq	r0, {r2}
    2098:	05271745 	streq	r1, [r7, #-1861]!	; 0xfffff8bb
    209c:	04eb0000 	strbteq	r0, [fp], #0
    20a0:	34010000 	strcc	r0, [r1], #-0
    20a4:	3a000006 	bcc	20c4 <shift+0x20c4>
    20a8:	09000006 	stmdbeq	r0, {r1, r2}
    20ac:	000007a0 	andeq	r0, r0, r0, lsr #15
    20b0:	0a8f0800 	beq	fe3c40b8 <__bss_end+0xfe3ba980>
    20b4:	48080000 	stmdami	r8, {}	; <UNPREDICTABLE>
    20b8:	0003c317 	andeq	ip, r3, r7, lsl r3
    20bc:	0004eb00 	andeq	lr, r4, r0, lsl #22
    20c0:	06530100 	ldrbeq	r0, [r3], -r0, lsl #2
    20c4:	065e0000 	ldrbeq	r0, [lr], -r0
    20c8:	a0090000 	andge	r0, r9, r0
    20cc:	0a000007 	beq	20f0 <shift+0x20f0>
    20d0:	00000074 	andeq	r0, r0, r4, ror r0
    20d4:	05d30b00 	ldrbeq	r0, [r3, #2816]	; 0xb00
    20d8:	4b080000 	blmi	2020e0 <__bss_end+0x1f89a8>
    20dc:	0008f30e 	andeq	pc, r8, lr, lsl #6
    20e0:	06730100 	ldrbteq	r0, [r3], -r0, lsl #2
    20e4:	06790000 	ldrbteq	r0, [r9], -r0
    20e8:	78090000 	stmdavc	r9, {}	; <UNPREDICTABLE>
    20ec:	00000007 	andeq	r0, r0, r7
    20f0:	00074a08 	andeq	r4, r7, r8, lsl #20
    20f4:	0e4d0800 	cdpeq	8, 4, cr0, cr13, cr0, {0}
    20f8:	000009a7 	andeq	r0, r0, r7, lsr #19
    20fc:	000001da 	ldrdeq	r0, [r0], -sl
    2100:	00069201 	andeq	r9, r6, r1, lsl #4
    2104:	00069d00 	andeq	r9, r6, r0, lsl #26
    2108:	07780900 	ldrbeq	r0, [r8, -r0, lsl #18]!
    210c:	740a0000 	strvc	r0, [sl], #-0
    2110:	00000000 	andeq	r0, r0, r0
    2114:	00046608 	andeq	r6, r4, r8, lsl #12
    2118:	12500800 	subsne	r0, r0, #0, 16
    211c:	000003f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    2120:	00000074 	andeq	r0, r0, r4, ror r0
    2124:	0006b601 	andeq	fp, r6, r1, lsl #12
    2128:	0006c100 	andeq	ip, r6, r0, lsl #2
    212c:	07780900 	ldrbeq	r0, [r8, -r0, lsl #18]!
    2130:	210a0000 	mrscs	r0, (UNDEF: 10)
    2134:	00000003 	andeq	r0, r0, r3
    2138:	00042308 	andeq	r2, r4, r8, lsl #6
    213c:	0e530800 	cdpeq	8, 5, cr0, cr3, cr0, {0}
    2140:	00000be5 	andeq	r0, r0, r5, ror #23
    2144:	000001da 	ldrdeq	r0, [r0], -sl
    2148:	0006da01 	andeq	sp, r6, r1, lsl #20
    214c:	0006e500 	andeq	lr, r6, r0, lsl #10
    2150:	07780900 	ldrbeq	r0, [r8, -r0, lsl #18]!
    2154:	740a0000 	strvc	r0, [sl], #-0
    2158:	00000000 	andeq	r0, r0, r0
    215c:	0004400b 	andeq	r4, r4, fp
    2160:	0e560800 	cdpeq	8, 5, cr0, cr6, cr0, {0}
    2164:	00000af4 	strdeq	r0, [r0], -r4
    2168:	0006fa01 	andeq	pc, r6, r1, lsl #20
    216c:	00071900 	andeq	r1, r7, r0, lsl #18
    2170:	07780900 	ldrbeq	r0, [r8, -r0, lsl #18]!
    2174:	2a0a0000 	bcs	28217c <__bss_end+0x278a44>
    2178:	0a000002 	beq	2188 <shift+0x2188>
    217c:	00000074 	andeq	r0, r0, r4, ror r0
    2180:	0000740a 	andeq	r7, r0, sl, lsl #8
    2184:	00740a00 	rsbseq	r0, r4, r0, lsl #20
    2188:	a60a0000 	strge	r0, [sl], -r0
    218c:	00000007 	andeq	r0, r0, r7
    2190:	000c110b 	andeq	r1, ip, fp, lsl #2
    2194:	0e580800 	cdpeq	8, 5, cr0, cr8, cr0, {0}
    2198:	00000c84 	andeq	r0, r0, r4, lsl #25
    219c:	00072e01 	andeq	r2, r7, r1, lsl #28
    21a0:	00074d00 	andeq	r4, r7, r0, lsl #26
    21a4:	07780900 	ldrbeq	r0, [r8, -r0, lsl #18]!
    21a8:	610a0000 	mrsvs	r0, (UNDEF: 10)
    21ac:	0a000002 	beq	21bc <shift+0x21bc>
    21b0:	00000074 	andeq	r0, r0, r4, ror r0
    21b4:	0000740a 	andeq	r7, r0, sl, lsl #8
    21b8:	00740a00 	rsbseq	r0, r4, r0, lsl #20
    21bc:	a60a0000 	strge	r0, [sl], -r0
    21c0:	00000007 	andeq	r0, r0, r7
    21c4:	0004531b 	andeq	r5, r4, fp, lsl r3
    21c8:	0e5b0800 	cdpeq	8, 5, cr0, cr11, cr0, {0}
    21cc:	00000872 	andeq	r0, r0, r2, ror r8
    21d0:	000001da 	ldrdeq	r0, [r0], -sl
    21d4:	00076201 	andeq	r6, r7, r1, lsl #4
    21d8:	07780900 	ldrbeq	r0, [r8, -r0, lsl #18]!
    21dc:	910a0000 	mrsls	r0, (UNDEF: 10)
    21e0:	0a000004 	beq	21f8 <shift+0x21f8>
    21e4:	000001f7 	strdeq	r0, [r0], -r7
    21e8:	f1030000 			; <UNDEFINED> instruction: 0xf1030000
    21ec:	0d000004 	stceq	0, cr0, [r0, #-16]
    21f0:	0004f104 	andeq	pc, r4, r4, lsl #2
    21f4:	04e51c00 	strbteq	r1, [r5], #3072	; 0xc00
    21f8:	078b0000 	streq	r0, [fp, r0]
    21fc:	07910000 	ldreq	r0, [r1, r0]
    2200:	78090000 	stmdavc	r9, {}	; <UNPREDICTABLE>
    2204:	00000007 	andeq	r0, r0, r7
    2208:	0004f11d 	andeq	pc, r4, sp, lsl r1	; <UNPREDICTABLE>
    220c:	00077e00 	andeq	r7, r7, r0, lsl #28
    2210:	55040d00 	strpl	r0, [r4, #-3328]	; 0xfffff300
    2214:	0d000000 	stceq	0, cr0, [r0, #-0]
    2218:	00077304 	andeq	r7, r7, r4, lsl #6
    221c:	04041e00 	streq	r1, [r4], #-3584	; 0xfffff200
    2220:	11000002 	tstne	r0, r2
    2224:	00001388 	andeq	r1, r0, r8, lsl #7
    2228:	00440107 	subeq	r0, r4, r7, lsl #2
    222c:	06090000 	streq	r0, [r9], -r0
    2230:	0007dd0c 	andeq	sp, r7, ip, lsl #26
    2234:	6f4e1500 	svcvs	0x004e1500
    2238:	12000070 	andne	r0, r0, #112	; 0x70
    223c:	00000ad7 	ldrdeq	r0, [r0], -r7
    2240:	077c1201 	ldrbeq	r1, [ip, -r1, lsl #4]!
    2244:	12020000 	andne	r0, r2, #0
    2248:	00001341 	andeq	r1, r0, r1, asr #6
    224c:	12ee1203 	rscne	r1, lr, #805306368	; 0x30000000
    2250:	00040000 	andeq	r0, r4, r0
    2254:	0013070f 	andseq	r0, r3, pc, lsl #14
    2258:	22090500 	andcs	r0, r9, #0, 10
    225c:	00080e08 	andeq	r0, r8, r8, lsl #28
    2260:	00781000 	rsbseq	r1, r8, r0
    2264:	5c0e2409 	cfstrspl	mvf2, [lr], {9}
    2268:	00000000 	andeq	r0, r0, r0
    226c:	09007910 	stmdbeq	r0, {r4, r8, fp, ip, sp, lr}
    2270:	005c0e25 	subseq	r0, ip, r5, lsr #28
    2274:	10020000 	andne	r0, r2, r0
    2278:	00746573 	rsbseq	r6, r4, r3, ror r5
    227c:	440d2609 	strmi	r2, [sp], #-1545	; 0xfffff9f7
    2280:	04000000 	streq	r0, [r0], #-0
    2284:	12300f00 	eorsne	r0, r0, #0, 30
    2288:	09010000 	stmdbeq	r1, {}	; <UNPREDICTABLE>
    228c:	0829082a 	stmdaeq	r9!, {r1, r3, r5, fp}
    2290:	63100000 	tstvs	r0, #0
    2294:	0900646d 	stmdbeq	r0, {r0, r2, r3, r5, r6, sl, sp, lr}
    2298:	07ac162c 	streq	r1, [ip, ip, lsr #12]!
    229c:	00000000 	andeq	r0, r0, r0
    22a0:	0012470f 	andseq	r4, r2, pc, lsl #14
    22a4:	30090100 	andcc	r0, r9, r0, lsl #2
    22a8:	00084408 	andeq	r4, r8, r8, lsl #8
    22ac:	13d50700 	bicsne	r0, r5, #0, 14
    22b0:	32090000 	andcc	r0, r9, #0
    22b4:	00080e1c 	andeq	r0, r8, ip, lsl lr
    22b8:	0f000000 	svceq	0x00000000
    22bc:	0000135d 	andeq	r1, r0, sp, asr r3
    22c0:	08360902 	ldmdaeq	r6!, {r1, r8, fp}
    22c4:	0000086c 	andeq	r0, r0, ip, ror #16
    22c8:	0013d507 	andseq	sp, r3, r7, lsl #10
    22cc:	1c380900 			; <UNDEFINED> instruction: 0x1c380900
    22d0:	0000080e 	andeq	r0, r0, lr, lsl #16
    22d4:	139f0700 	orrsne	r0, pc, #0, 14
    22d8:	39090000 	stmdbcc	r9, {}	; <UNPREDICTABLE>
    22dc:	0000440d 	andeq	r4, r0, sp, lsl #8
    22e0:	0f000100 	svceq	0x00000100
    22e4:	000012cd 	andeq	r1, r0, sp, asr #5
    22e8:	083d0908 	ldmdaeq	sp!, {r3, r8, fp}
    22ec:	000008a1 	andeq	r0, r0, r1, lsr #17
    22f0:	0013d507 	andseq	sp, r3, r7, lsl #10
    22f4:	1c3f0900 			; <UNDEFINED> instruction: 0x1c3f0900
    22f8:	0000080e 	andeq	r0, r0, lr, lsl #16
    22fc:	0f4e0700 	svceq	0x004e0700
    2300:	40090000 	andmi	r0, r9, r0
    2304:	00005c0e 	andeq	r5, r0, lr, lsl #24
    2308:	99070100 	stmdbls	r7, {r8}
    230c:	09000013 	stmdbeq	r0, {r0, r1, r4}
    2310:	07dd1942 	ldrbeq	r1, [sp, r2, asr #18]
    2314:	00030000 	andeq	r0, r3, r0
    2318:	0013200f 	andseq	r2, r3, pc
    231c:	46090b00 	strmi	r0, [r9], -r0, lsl #22
    2320:	00090408 	andeq	r0, r9, r8, lsl #8
    2324:	13d50700 	bicsne	r0, r5, #0, 14
    2328:	48090000 	stmdami	r9, {}	; <UNPREDICTABLE>
    232c:	00080e1c 	andeq	r0, r8, ip, lsl lr
    2330:	78100000 	ldmdavc	r0, {}	; <UNPREDICTABLE>
    2334:	49090031 	stmdbmi	r9, {r0, r4, r5}
    2338:	00005c0e 	andeq	r5, r0, lr, lsl #24
    233c:	79100100 	ldmdbvc	r0, {r8}
    2340:	49090031 	stmdbmi	r9, {r0, r4, r5}
    2344:	00005c12 	andeq	r5, r0, r2, lsl ip
    2348:	77100300 	ldrvc	r0, [r0, -r0, lsl #6]
    234c:	0e4a0900 	vmlaeq.f16	s1, s20, s0	; <UNPREDICTABLE>
    2350:	0000005c 	andeq	r0, r0, ip, asr r0
    2354:	00681005 	rsbeq	r1, r8, r5
    2358:	5c114a09 			; <UNDEFINED> instruction: 0x5c114a09
    235c:	07000000 	streq	r0, [r0, -r0]
    2360:	00127c07 	andseq	r7, r2, r7, lsl #24
    2364:	0d4b0900 	vstreq.16	s1, [fp, #-0]	; <UNPREDICTABLE>
    2368:	00000044 	andeq	r0, r0, r4, asr #32
    236c:	13990709 	orrsne	r0, r9, #2359296	; 0x240000
    2370:	4d090000 	stcmi	0, cr0, [r9, #-0]
    2374:	0000440d 	andeq	r4, r0, sp, lsl #8
    2378:	1f000a00 	svcne	0x00000a00
    237c:	006c6168 	rsbeq	r6, ip, r8, ror #2
    2380:	be0b050a 	cfsh32lt	mvfx0, mvfx11, #10
    2384:	20000009 	andcs	r0, r0, r9
    2388:	000008bf 			; <UNDEFINED> instruction: 0x000008bf
    238c:	8c19070a 	ldchi	7, cr0, [r9], {10}
    2390:	80000000 	andhi	r0, r0, r0
    2394:	200ee6b2 			; <UNDEFINED> instruction: 0x200ee6b2
    2398:	00000aa2 	andeq	r0, r0, r2, lsr #21
    239c:	da1a0a0a 	ble	684bcc <__bss_end+0x67b494>
    23a0:	00000003 	andeq	r0, r0, r3
    23a4:	20200000 	eorcs	r0, r0, r0
    23a8:	000004cd 	andeq	r0, r0, sp, asr #9
    23ac:	da1a0d0a 	ble	6857dc <__bss_end+0x67c0a4>
    23b0:	00000003 	andeq	r0, r0, r3
    23b4:	21202000 			; <UNDEFINED> instruction: 0x21202000
    23b8:	00000807 	andeq	r0, r0, r7, lsl #16
    23bc:	8015100a 	andshi	r1, r5, sl
    23c0:	36000000 	strcc	r0, [r0], -r0
    23c4:	000b8c20 	andeq	r8, fp, r0, lsr #24
    23c8:	1a420a00 	bne	1084bd0 <__bss_end+0x107b498>
    23cc:	000003da 	ldrdeq	r0, [r0], -sl
    23d0:	20215000 	eorcs	r5, r1, r0
    23d4:	000c4a20 	andeq	r4, ip, r0, lsr #20
    23d8:	1a710a00 	bne	1c44be0 <__bss_end+0x1c3b4a8>
    23dc:	000003da 	ldrdeq	r0, [r0], -sl
    23e0:	2000b200 	andcs	fp, r0, r0, lsl #4
    23e4:	0006c320 	andeq	ip, r6, r0, lsr #6
    23e8:	1aa40a00 	bne	fe904bf0 <__bss_end+0xfe8fb4b8>
    23ec:	000003da 	ldrdeq	r0, [r0], -sl
    23f0:	2000b400 	andcs	fp, r0, r0, lsl #8
    23f4:	0008b520 	andeq	fp, r8, r0, lsr #10
    23f8:	1ab30a00 	bne	fecc4c00 <__bss_end+0xfecbb4c8>
    23fc:	000003da 	ldrdeq	r0, [r0], -sl
    2400:	20104000 	andscs	r4, r0, r0
    2404:	00097020 	andeq	r7, r9, r0, lsr #32
    2408:	1abe0a00 	bne	fef84c10 <__bss_end+0xfef7b4d8>
    240c:	000003da 	ldrdeq	r0, [r0], -sl
    2410:	20205000 	eorcs	r5, r0, r0
    2414:	00061520 	andeq	r1, r6, r0, lsr #10
    2418:	1abf0a00 	bne	fefc4c20 <__bss_end+0xfefbb4e8>
    241c:	000003da 	ldrdeq	r0, [r0], -sl
    2420:	20804000 	addcs	r4, r0, r0
    2424:	000b9520 	andeq	r9, fp, r0, lsr #10
    2428:	1ac00a00 	bne	ff004c30 <__bss_end+0xfeffb4f8>
    242c:	000003da 	ldrdeq	r0, [r0], -sl
    2430:	20805000 	addcs	r5, r0, r0
    2434:	09102200 	ldmdbeq	r0, {r9, sp}
    2438:	20220000 	eorcs	r0, r2, r0
    243c:	22000009 	andcs	r0, r0, #9
    2440:	00000930 	andeq	r0, r0, r0, lsr r9
    2444:	00094022 	andeq	r4, r9, r2, lsr #32
    2448:	094d2200 	stmdbeq	sp, {r9, sp}^
    244c:	5d220000 	stcpl	0, cr0, [r2, #-0]
    2450:	22000009 	andcs	r0, r0, #9
    2454:	0000096d 	andeq	r0, r0, sp, ror #18
    2458:	00097d22 	andeq	r7, r9, r2, lsr #26
    245c:	098d2200 	stmibeq	sp, {r9, sp}
    2460:	9d220000 	stcls	0, cr0, [r2, #-0]
    2464:	22000009 	andcs	r0, r0, #9
    2468:	000009ad 	andeq	r0, r0, sp, lsr #19
    246c:	00137e23 	andseq	r7, r3, r3, lsr #28
    2470:	0b040b00 	bleq	105078 <__bss_end+0xfb940>
    2474:	00000c91 	muleq	r0, r1, ip
    2478:	00137321 	andseq	r7, r3, r1, lsr #6
    247c:	18070b00 	stmdane	r7, {r8, r9, fp}
    2480:	00000068 	andeq	r0, r0, r8, rrx
    2484:	13c92106 	bicne	r2, r9, #-2147483647	; 0x80000001
    2488:	090b0000 	stmdbeq	fp, {}	; <UNPREDICTABLE>
    248c:	00006818 	andeq	r6, r0, r8, lsl r8
    2490:	dc210800 	stcle	8, cr0, [r1], #-0
    2494:	0b000013 	bleq	24e8 <shift+0x24e8>
    2498:	0068180c 	rsbeq	r1, r8, ip, lsl #16
    249c:	21200000 			; <UNDEFINED> instruction: 0x21200000
    24a0:	00001338 	andeq	r1, r0, r8, lsr r3
    24a4:	68180e0b 	ldmdavs	r8, {r0, r1, r3, r9, sl, fp}
    24a8:	80000000 	andhi	r0, r0, r0
    24ac:	00135221 	andseq	r5, r3, r1, lsr #4
    24b0:	14110b00 	ldrne	r0, [r1], #-2816	; 0xfffff500
    24b4:	000001e1 	andeq	r0, r0, r1, ror #3
    24b8:	126a2401 	rsbne	r2, sl, #16777216	; 0x1000000
    24bc:	140b0000 	strne	r0, [fp], #-0
    24c0:	000cbb13 	andeq	fp, ip, r3, lsl fp
    24c4:	00024000 	andeq	r4, r2, r0
	...
    24d0:	0000002f 	andeq	r0, r0, pc, lsr #32
    24d4:	07000700 	streq	r0, [r0, -r0, lsl #14]
    24d8:	7f140000 	svcvc	0x00140000
    24dc:	00147f14 	andseq	r7, r4, r4, lsl pc
    24e0:	2a7f2a24 	bcs	1fccd78 <__bss_end+0x1fc3640>
    24e4:	13230012 			; <UNDEFINED> instruction: 0x13230012
    24e8:	00626408 	rsbeq	r6, r2, r8, lsl #8
    24ec:	22554936 	subscs	r4, r5, #884736	; 0xd8000
    24f0:	05000050 	streq	r0, [r0, #-80]	; 0xffffffb0
    24f4:	00000003 	andeq	r0, r0, r3
    24f8:	41221c00 			; <UNDEFINED> instruction: 0x41221c00
    24fc:	41000000 	mrsmi	r0, (UNDEF: 0)
    2500:	00001c22 	andeq	r1, r0, r2, lsr #24
    2504:	083e0814 	ldmdaeq	lr!, {r2, r4, fp}
    2508:	08080014 	stmdaeq	r8, {r2, r4}
    250c:	0008083e 	andeq	r0, r8, lr, lsr r8
    2510:	60a00000 	adcvs	r0, r0, r0
    2514:	08080000 	stmdaeq	r8, {}	; <UNPREDICTABLE>
    2518:	00080808 	andeq	r0, r8, r8, lsl #16
    251c:	00606000 	rsbeq	r6, r0, r0
    2520:	10200000 	eorne	r0, r0, r0
    2524:	00020408 	andeq	r0, r2, r8, lsl #8
    2528:	4549513e 	strbmi	r5, [r9, #-318]	; 0xfffffec2
    252c:	4200003e 	andmi	r0, r0, #62	; 0x3e
    2530:	0000407f 	andeq	r4, r0, pc, ror r0
    2534:	49516142 	ldmdbmi	r1, {r1, r6, r8, sp, lr}^
    2538:	41210046 			; <UNDEFINED> instruction: 0x41210046
    253c:	00314b45 	eorseq	r4, r1, r5, asr #22
    2540:	7f121418 	svcvc	0x00121418
    2544:	45270010 	strmi	r0, [r7, #-16]!
    2548:	00394545 	eorseq	r4, r9, r5, asr #10
    254c:	49494a3c 	stmdbmi	r9, {r2, r3, r4, r5, r9, fp, lr}^
    2550:	71010030 	tstvc	r1, r0, lsr r0
    2554:	00030509 	andeq	r0, r3, r9, lsl #10
    2558:	49494936 	stmdbmi	r9, {r1, r2, r4, r5, r8, fp, lr}^
    255c:	49060036 	stmdbmi	r6, {r1, r2, r4, r5}
    2560:	001e2949 	andseq	r2, lr, r9, asr #18
    2564:	00363600 	eorseq	r3, r6, r0, lsl #12
    2568:	56000000 	strpl	r0, [r0], -r0
    256c:	00000036 	andeq	r0, r0, r6, lsr r0
    2570:	41221408 			; <UNDEFINED> instruction: 0x41221408
    2574:	14140000 	ldrne	r0, [r4], #-0
    2578:	00141414 	andseq	r1, r4, r4, lsl r4
    257c:	14224100 	strtne	r4, [r2], #-256	; 0xffffff00
    2580:	01020008 	tsteq	r2, r8
    2584:	00060951 	andeq	r0, r6, r1, asr r9
    2588:	51594932 	cmppl	r9, r2, lsr r9
    258c:	127c003e 	rsbsne	r0, ip, #62	; 0x3e
    2590:	007c1211 	rsbseq	r1, ip, r1, lsl r2
    2594:	4949497f 	stmdbmi	r9, {r0, r1, r2, r3, r4, r5, r6, r8, fp, lr}^
    2598:	413e0036 	teqmi	lr, r6, lsr r0
    259c:	00224141 	eoreq	r4, r2, r1, asr #2
    25a0:	2241417f 	subcs	r4, r1, #-1073741793	; 0xc000001f
    25a4:	497f001c 	ldmdbmi	pc!, {r2, r3, r4}^	; <UNPREDICTABLE>
    25a8:	00414949 	subeq	r4, r1, r9, asr #18
    25ac:	0909097f 	stmdbeq	r9, {r0, r1, r2, r3, r4, r5, r6, r8, fp}
    25b0:	413e0001 	teqmi	lr, r1
    25b4:	007a4949 	rsbseq	r4, sl, r9, asr #18
    25b8:	0808087f 	stmdaeq	r8, {r0, r1, r2, r3, r4, r5, r6, fp}
    25bc:	4100007f 	tstmi	r0, pc, ror r0
    25c0:	0000417f 	andeq	r4, r0, pc, ror r1
    25c4:	3f414020 	svccc	0x00414020
    25c8:	087f0001 	ldmdaeq	pc!, {r0}^	; <UNPREDICTABLE>
    25cc:	00412214 	subeq	r2, r1, r4, lsl r2
    25d0:	4040407f 	submi	r4, r0, pc, ror r0
    25d4:	027f0040 	rsbseq	r0, pc, #64	; 0x40
    25d8:	007f020c 	rsbseq	r0, pc, ip, lsl #4
    25dc:	1008047f 	andne	r0, r8, pc, ror r4
    25e0:	413e007f 	teqmi	lr, pc, ror r0
    25e4:	003e4141 	eorseq	r4, lr, r1, asr #2
    25e8:	0909097f 	stmdbeq	r9, {r0, r1, r2, r3, r4, r5, r6, r8, fp}
    25ec:	413e0006 	teqmi	lr, r6
    25f0:	005e2151 	subseq	r2, lr, r1, asr r1
    25f4:	2919097f 	ldmdbcs	r9, {r0, r1, r2, r3, r4, r5, r6, r8, fp}
    25f8:	49460046 	stmdbmi	r6, {r1, r2, r6}^
    25fc:	00314949 	eorseq	r4, r1, r9, asr #18
    2600:	017f0101 	cmneq	pc, r1, lsl #2
    2604:	403f0001 	eorsmi	r0, pc, r1
    2608:	003f4040 	eorseq	r4, pc, r0, asr #32
    260c:	2040201f 	subcs	r2, r0, pc, lsl r0
    2610:	403f001f 	eorsmi	r0, pc, pc, lsl r0	; <UNPREDICTABLE>
    2614:	003f4038 	eorseq	r4, pc, r8, lsr r0	; <UNPREDICTABLE>
    2618:	14081463 	strne	r1, [r8], #-1123	; 0xfffffb9d
    261c:	08070063 	stmdaeq	r7, {r0, r1, r5, r6}
    2620:	00070870 	andeq	r0, r7, r0, ror r8
    2624:	45495161 	strbmi	r5, [r9, #-353]	; 0xfffffe9f
    2628:	7f000043 	svcvc	0x00000043
    262c:	00004141 	andeq	r4, r0, r1, asr #2
    2630:	2a552a55 	bcs	154cf8c <__bss_end+0x1543854>
    2634:	41000055 	qaddmi	r0, r5, r0
    2638:	00007f41 	andeq	r7, r0, r1, asr #30
    263c:	02010204 	andeq	r0, r1, #4, 4	; 0x40000000
    2640:	40400004 	submi	r0, r0, r4
    2644:	00404040 	subeq	r4, r0, r0, asr #32
    2648:	04020100 	streq	r0, [r2], #-256	; 0xffffff00
    264c:	54200000 	strtpl	r0, [r0], #-0
    2650:	00785454 	rsbseq	r5, r8, r4, asr r4
    2654:	4444487f 	strbmi	r4, [r4], #-2175	; 0xfffff781
    2658:	44380038 	ldrtmi	r0, [r8], #-56	; 0xffffffc8
    265c:	00204444 	eoreq	r4, r0, r4, asr #8
    2660:	48444438 	stmdami	r4, {r3, r4, r5, sl, lr}^
    2664:	5438007f 	ldrtpl	r0, [r8], #-127	; 0xffffff81
    2668:	00185454 	andseq	r5, r8, r4, asr r4
    266c:	01097e08 	tsteq	r9, r8, lsl #28
    2670:	a4180002 	ldrge	r0, [r8], #-2
    2674:	007ca4a4 	rsbseq	sl, ip, r4, lsr #9
    2678:	0404087f 	streq	r0, [r4], #-2175	; 0xfffff781
    267c:	44000078 	strmi	r0, [r0], #-120	; 0xffffff88
    2680:	0000407d 	andeq	r4, r0, sp, ror r0
    2684:	7d848040 	stcvc	0, cr8, [r4, #256]	; 0x100
    2688:	107f0000 	rsbsne	r0, pc, r0
    268c:	00004428 	andeq	r4, r0, r8, lsr #8
    2690:	407f4100 	rsbsmi	r4, pc, r0, lsl #2
    2694:	047c0000 	ldrbteq	r0, [ip], #-0
    2698:	00780418 	rsbseq	r0, r8, r8, lsl r4
    269c:	0404087c 	streq	r0, [r4], #-2172	; 0xfffff784
    26a0:	44380078 	ldrtmi	r0, [r8], #-120	; 0xffffff88
    26a4:	00384444 	eorseq	r4, r8, r4, asr #8
    26a8:	242424fc 	strtcs	r2, [r4], #-1276	; 0xfffffb04
    26ac:	24180018 	ldrcs	r0, [r8], #-24	; 0xffffffe8
    26b0:	00fc1824 	rscseq	r1, ip, r4, lsr #16
    26b4:	0404087c 	streq	r0, [r4], #-2172	; 0xfffff784
    26b8:	54480008 	strbpl	r0, [r8], #-8
    26bc:	00205454 	eoreq	r5, r0, r4, asr r4
    26c0:	40443f04 	submi	r3, r4, r4, lsl #30
    26c4:	403c0020 	eorsmi	r0, ip, r0, lsr #32
    26c8:	007c2040 	rsbseq	r2, ip, r0, asr #32
    26cc:	2040201c 	subcs	r2, r0, ip, lsl r0
    26d0:	403c001c 	eorsmi	r0, ip, ip, lsl r0
    26d4:	003c4030 	eorseq	r4, ip, r0, lsr r0
    26d8:	28102844 	ldmdacs	r0, {r2, r6, fp, sp}
    26dc:	a01c0044 	andsge	r0, ip, r4, asr #32
    26e0:	007ca0a0 	rsbseq	sl, ip, r0, lsr #1
    26e4:	4c546444 	cfldrdmi	mvd6, [r4], {68}	; 0x44
    26e8:	08000044 	stmdaeq	r0, {r2, r6}
    26ec:	00000077 	andeq	r0, r0, r7, ror r0
    26f0:	007f0000 	rsbseq	r0, pc, r0
    26f4:	77000000 	strvc	r0, [r0, -r0]
    26f8:	00000008 	andeq	r0, r0, r8
    26fc:	08100810 	ldmdaeq	r0, {r4, fp}
	...
    2708:	000a0122 	andeq	r0, sl, r2, lsr #2
    270c:	0a0e2200 	beq	38af14 <__bss_end+0x3817dc>
    2710:	1b220000 	blne	882718 <__bss_end+0x878fe0>
    2714:	2200000a 	andcs	r0, r0, #10
    2718:	00000a28 	andeq	r0, r0, r8, lsr #20
    271c:	000a3522 	andeq	r3, sl, r2, lsr #10
    2720:	00501600 	subseq	r1, r0, r0, lsl #12
    2724:	0cbb0000 	ldceq	0, cr0, [fp]
    2728:	85250000 	strhi	r0, [r5, #-0]!
    272c:	3f000000 	svccc	0x00000000
    2730:	aa030002 	bge	c2740 <__bss_end+0xb9008>
    2734:	2200000c 	andcs	r0, r0, #12
    2738:	00000a42 	andeq	r0, r0, r2, asr #20
    273c:	0001ae26 	andeq	sl, r1, r6, lsr #28
    2740:	065d0100 	ldrbeq	r0, [sp], -r0, lsl #2
    2744:	00000cdf 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    2748:	00009050 	andeq	r9, r0, r0, asr r0
    274c:	000000b0 	strheq	r0, [r0], -r0	; <UNPREDICTABLE>
    2750:	0d329c01 	ldceq	12, cr9, [r2, #-4]!
    2754:	65270000 	strvs	r0, [r7, #-0]!
    2758:	ec000012 	stc	0, cr0, [r0], {18}
    275c:	02000001 	andeq	r0, r0, #1
    2760:	78286c91 	stmdavc	r8!, {r0, r4, r7, sl, fp, sp, lr}
    2764:	295d0100 	ldmdbcs	sp, {r8}^
    2768:	0000005c 	andeq	r0, r0, ip, asr r0
    276c:	286a9102 	stmdacs	sl!, {r1, r8, ip, pc}^
    2770:	5d010079 	stcpl	0, cr0, [r1, #-484]	; 0xfffffe1c
    2774:	00005c35 	andeq	r5, r0, r5, lsr ip
    2778:	68910200 	ldmvs	r1, {r9}
    277c:	72747328 	rsbsvc	r7, r4, #40, 6	; 0xa0000000
    2780:	445d0100 	ldrbmi	r0, [sp], #-256	; 0xffffff00
    2784:	000001f1 	strdeq	r0, [r0], -r1
    2788:	29649102 	stmdbcs	r4!, {r1, r8, ip, pc}^
    278c:	01006978 	tsteq	r0, r8, ror r9
    2790:	005c0e62 	subseq	r0, ip, r2, ror #28
    2794:	91020000 	mrsls	r0, (UNDEF: 2)
    2798:	74702976 	ldrbtvc	r2, [r0], #-2422	; 0xfffff68a
    279c:	63010072 	movwvs	r0, #4210	; 0x1072
    27a0:	0001f111 	andeq	pc, r1, r1, lsl r1	; <UNPREDICTABLE>
    27a4:	70910200 	addsvc	r0, r1, r0, lsl #4
    27a8:	011f2600 	tsteq	pc, r0, lsl #12
    27ac:	52010000 	andpl	r0, r1, #0
    27b0:	000d4c06 	andeq	r4, sp, r6, lsl #24
    27b4:	008ff800 	addeq	pc, pc, r0, lsl #16
    27b8:	00005800 	andeq	r5, r0, r0, lsl #16
    27bc:	689c0100 	ldmvs	ip, {r8}
    27c0:	2700000d 	strcs	r0, [r0, -sp]
    27c4:	00001265 	andeq	r1, r0, r5, ror #4
    27c8:	000001ec 	andeq	r0, r0, ip, ror #3
    27cc:	296c9102 	stmdbcs	ip!, {r1, r8, ip, pc}^
    27d0:	00746b70 	rsbseq	r6, r4, r0, ror fp
    27d4:	29235701 	stmdbcs	r3!, {r0, r8, r9, sl, ip, lr}
    27d8:	02000008 	andeq	r0, r0, #8
    27dc:	26007491 			; <UNDEFINED> instruction: 0x26007491
    27e0:	00000184 	andeq	r0, r0, r4, lsl #3
    27e4:	82063a01 	andhi	r3, r6, #4096	; 0x1000
    27e8:	9000000d 	andls	r0, r0, sp
    27ec:	6800008e 	stmdavs	r0, {r1, r2, r3, r7}
    27f0:	01000001 	tsteq	r0, r1
    27f4:	000dd49c 	muleq	sp, ip, r4
    27f8:	12652700 	rsbne	r2, r5, #0, 14
    27fc:	01ec0000 	mvneq	r0, r0
    2800:	91020000 	mrsls	r0, (UNDEF: 2)
    2804:	0078285c 	rsbseq	r2, r8, ip, asr r8
    2808:	5c273a01 			; <UNDEFINED> instruction: 0x5c273a01
    280c:	02000000 	andeq	r0, r0, #0
    2810:	79285a91 	stmdbvc	r8!, {r0, r4, r7, r9, fp, ip, lr}
    2814:	333a0100 	teqcc	sl, #0, 2
    2818:	0000005c 	andeq	r0, r0, ip, asr r0
    281c:	28589102 	ldmdacs	r8, {r1, r8, ip, pc}^
    2820:	3a010063 	bcc	429b4 <__bss_end+0x3927c>
    2824:	0000253b 	andeq	r2, r0, fp, lsr r5
    2828:	57910200 	ldrpl	r0, [r1, r0, lsl #4]
    282c:	66756229 	ldrbtvs	r6, [r5], -r9, lsr #4
    2830:	0a430100 	beq	10c2c38 <__bss_end+0x10b9500>
    2834:	00000dd4 	ldrdeq	r0, [r0], -r4
    2838:	29609102 	stmdbcs	r0!, {r1, r8, ip, pc}^
    283c:	00727470 	rsbseq	r7, r2, r0, ror r4
    2840:	e41e4501 	ldr	r4, [lr], #-1281	; 0xfffffaff
    2844:	0200000d 	andeq	r0, r0, #13
    2848:	16007491 			; <UNDEFINED> instruction: 0x16007491
    284c:	00000025 	andeq	r0, r0, r5, lsr #32
    2850:	00000de4 	andeq	r0, r0, r4, ror #27
    2854:	00008517 	andeq	r8, r0, r7, lsl r5
    2858:	0d001000 	stceq	0, cr1, [r0, #-0]
    285c:	0008a104 	andeq	sl, r8, r4, lsl #2
    2860:	015a2600 	cmpeq	sl, r0, lsl #12
    2864:	2b010000 	blcs	4286c <__bss_end+0x39134>
    2868:	000e0406 	andeq	r0, lr, r6, lsl #8
    286c:	008da400 	addeq	sl, sp, r0, lsl #8
    2870:	0000ec00 	andeq	lr, r0, r0, lsl #24
    2874:	499c0100 	ldmibmi	ip, {r8}
    2878:	2700000e 	strcs	r0, [r0, -lr]
    287c:	00001265 	andeq	r1, r0, r5, ror #4
    2880:	000001ec 	andeq	r0, r0, ip, ror #3
    2884:	286c9102 	stmdacs	ip!, {r1, r8, ip, pc}^
    2888:	2b010078 	blcs	42a70 <__bss_end+0x39338>
    288c:	00005c28 	andeq	r5, r0, r8, lsr #24
    2890:	6a910200 	bvs	fe443098 <__bss_end+0xfe439960>
    2894:	01007928 	tsteq	r0, r8, lsr #18
    2898:	005c342b 	subseq	r3, ip, fp, lsr #8
    289c:	91020000 	mrsls	r0, (UNDEF: 2)
    28a0:	65732868 	ldrbvs	r2, [r3, #-2152]!	; 0xfffff798
    28a4:	2b010074 	blcs	42a7c <__bss_end+0x39344>
    28a8:	0001da3c 	andeq	sp, r1, ip, lsr sl
    28ac:	67910200 	ldrvs	r0, [r1, r0, lsl #4]
    28b0:	746b7029 	strbtvc	r7, [fp], #-41	; 0xffffffd7
    28b4:	26310100 	ldrtcs	r0, [r1], -r0, lsl #2
    28b8:	0000086c 	andeq	r0, r0, ip, ror #16
    28bc:	00709102 	rsbseq	r9, r0, r2, lsl #2
    28c0:	00013a26 	andeq	r3, r1, r6, lsr #20
    28c4:	06200100 	strteq	r0, [r0], -r0, lsl #2
    28c8:	00000e63 	andeq	r0, r0, r3, ror #28
    28cc:	00008d28 	andeq	r8, r0, r8, lsr #26
    28d0:	0000007c 	andeq	r0, r0, ip, ror r0
    28d4:	0e8e9c01 	cdpeq	12, 8, cr9, cr14, cr1, {0}
    28d8:	65270000 	strvs	r0, [r7, #-0]!
    28dc:	ec000012 	stc	0, cr0, [r0], {18}
    28e0:	02000001 	andeq	r0, r0, #1
    28e4:	9f2a6c91 	svcls	0x002a6c91
    28e8:	01000013 	tsteq	r0, r3, lsl r0
    28ec:	01da2020 	bicseq	r2, sl, r0, lsr #32
    28f0:	91020000 	mrsls	r0, (UNDEF: 2)
    28f4:	6b70296b 	blvs	1c0cea8 <__bss_end+0x1c03770>
    28f8:	25010074 	strcs	r0, [r1, #-116]	; 0xffffff8c
    28fc:	0008441b 	andeq	r4, r8, fp, lsl r4
    2900:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    2904:	01002b00 	tsteq	r0, r0, lsl #22
    2908:	1b010000 	blne	42910 <__bss_end+0x391d8>
    290c:	000ea806 	andeq	sl, lr, r6, lsl #16
    2910:	008d0000 	addeq	r0, sp, r0
    2914:	00002800 	andeq	r2, r0, r0, lsl #16
    2918:	b59c0100 	ldrlt	r0, [ip, #256]	; 0x100
    291c:	2700000e 	strcs	r0, [r0, -lr]
    2920:	00001265 	andeq	r1, r0, r5, ror #4
    2924:	000001ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    2928:	00749102 	rsbseq	r9, r4, r2, lsl #2
    292c:	0000dc2c 	andeq	sp, r0, ip, lsr #24
    2930:	01110100 	tsteq	r1, r0, lsl #2
    2934:	000001f7 	strdeq	r0, [r0], -r7
    2938:	00000eca 	andeq	r0, r0, sl, asr #29
    293c:	000edd00 	andeq	sp, lr, r0, lsl #26
    2940:	12652d00 	rsbne	r2, r5, #0, 26
    2944:	01ec0000 	mvneq	r0, r0
    2948:	262d0000 	strtcs	r0, [sp], -r0
    294c:	3f000012 	svccc	0x00000012
    2950:	00000000 	andeq	r0, r0, r0
    2954:	000eb52e 	andeq	fp, lr, lr, lsr #10
    2958:	0013e700 	andseq	lr, r3, r0, lsl #14
    295c:	000ef800 	andeq	pc, lr, r0, lsl #16
    2960:	008cb400 	addeq	fp, ip, r0, lsl #8
    2964:	00004c00 	andeq	r4, r0, r0, lsl #24
    2968:	019c0100 	orrseq	r0, ip, r0, lsl #2
    296c:	2f00000f 	svccs	0x0000000f
    2970:	00000eca 	andeq	r0, r0, sl, asr #29
    2974:	00749102 	rsbseq	r9, r4, r2, lsl #2
    2978:	0000b830 	andeq	fp, r0, r0, lsr r8
    297c:	010a0100 	mrseq	r0, (UNDEF: 26)
    2980:	00000f12 	andeq	r0, r0, r2, lsl pc
    2984:	000f2800 	andeq	r2, pc, r0, lsl #16
    2988:	12652d00 	rsbne	r2, r5, #0, 26
    298c:	01ec0000 	mvneq	r0, r0
    2990:	1b310000 	blne	c42998 <__bss_end+0xc39260>
    2994:	01000013 	tsteq	r0, r3, lsl r0
    2998:	01f12a0a 	mvnseq	r2, sl, lsl #20
    299c:	32000000 	andcc	r0, r0, #0
    29a0:	00000f01 	andeq	r0, r0, r1, lsl #30
    29a4:	000013a8 	andeq	r1, r0, r8, lsr #7
    29a8:	00000f3f 	andeq	r0, r0, pc, lsr pc
    29ac:	00008c4c 	andeq	r8, r0, ip, asr #24
    29b0:	00000068 	andeq	r0, r0, r8, rrx
    29b4:	122f9c01 	eorne	r9, pc, #256	; 0x100
    29b8:	0200000f 	andeq	r0, r0, #15
    29bc:	1b2f7491 	blne	bdfc08 <__bss_end+0xbd64d0>
    29c0:	0200000f 	andeq	r0, r0, #15
    29c4:	00007091 	muleq	r0, r1, r0
    29c8:	00000022 	andeq	r0, r0, r2, lsr #32
    29cc:	0ad30002 	beq	ff4c29dc <__bss_end+0xff4b92a4>
    29d0:	01040000 	mrseq	r0, (UNDEF: 4)
    29d4:	00000dee 	andeq	r0, r0, lr, ror #27
    29d8:	00009100 	andeq	r9, r0, r0, lsl #2
    29dc:	0000930c 	andeq	r9, r0, ip, lsl #6
    29e0:	000013fe 	strdeq	r1, [r0], -lr
    29e4:	0000142e 	andeq	r1, r0, lr, lsr #8
    29e8:	00001496 	muleq	r0, r6, r4
    29ec:	00228001 	eoreq	r8, r2, r1
    29f0:	00020000 	andeq	r0, r2, r0
    29f4:	00000ae7 	andeq	r0, r0, r7, ror #21
    29f8:	0e6b0104 	poweqe	f0, f3, f4
    29fc:	930c0000 	movwls	r0, #49152	; 0xc000
    2a00:	93100000 	tstls	r0, #0
    2a04:	13fe0000 	mvnsne	r0, #0
    2a08:	142e0000 	strtne	r0, [lr], #-0
    2a0c:	14960000 	ldrne	r0, [r6], #0
    2a10:	80010000 	andhi	r0, r1, r0
    2a14:	0000032a 	andeq	r0, r0, sl, lsr #6
    2a18:	0afb0004 	beq	ffec2a30 <__bss_end+0xffeb92f8>
    2a1c:	01040000 	mrseq	r0, (UNDEF: 4)
    2a20:	000015c2 	andeq	r1, r0, r2, asr #11
    2a24:	00177b0c 	andseq	r7, r7, ip, lsl #22
    2a28:	00142e00 	andseq	r2, r4, r0, lsl #28
    2a2c:	000ecb00 	andeq	ip, lr, r0, lsl #22
    2a30:	05040200 	streq	r0, [r4, #-512]	; 0xfffffe00
    2a34:	00746e69 	rsbseq	r6, r4, r9, ror #28
    2a38:	c4070403 	strgt	r0, [r7], #-1027	; 0xfffffbfd
    2a3c:	03000017 	movweq	r0, #23
    2a40:	02b90508 	adcseq	r0, r9, #8, 10	; 0x2000000
    2a44:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    2a48:	00176f04 	andseq	r6, r7, r4, lsl #30
    2a4c:	08010300 	stmdaeq	r1, {r8, r9}
    2a50:	00000b5e 	andeq	r0, r0, lr, asr fp
    2a54:	60060103 	andvs	r0, r6, r3, lsl #2
    2a58:	0400000b 	streq	r0, [r0], #-11
    2a5c:	00001947 	andeq	r1, r0, r7, asr #18
    2a60:	00390107 	eorseq	r0, r9, r7, lsl #2
    2a64:	17010000 	strne	r0, [r1, -r0]
    2a68:	0001d406 	andeq	sp, r1, r6, lsl #8
    2a6c:	14d10500 	ldrbne	r0, [r1], #1280	; 0x500
    2a70:	05000000 	streq	r0, [r0, #-0]
    2a74:	000019f6 	strdeq	r1, [r0], -r6
    2a78:	16a40501 	strtne	r0, [r4], r1, lsl #10
    2a7c:	05020000 	streq	r0, [r2, #-0]
    2a80:	00001762 	andeq	r1, r0, r2, ror #14
    2a84:	19600503 	stmdbne	r0!, {r0, r1, r8, sl}^
    2a88:	05040000 	streq	r0, [r4, #-0]
    2a8c:	00001a06 	andeq	r1, r0, r6, lsl #20
    2a90:	19760505 	ldmdbne	r6!, {r0, r2, r8, sl}^
    2a94:	05060000 	streq	r0, [r6, #-0]
    2a98:	000017ab 	andeq	r1, r0, fp, lsr #15
    2a9c:	18f10507 	ldmne	r1!, {r0, r1, r2, r8, sl}^
    2aa0:	05080000 	streq	r0, [r8, #-0]
    2aa4:	000018ff 	strdeq	r1, [r0], -pc	; <UNPREDICTABLE>
    2aa8:	190d0509 	stmdbne	sp, {r0, r3, r8, sl}
    2aac:	050a0000 	streq	r0, [sl, #-0]
    2ab0:	00001814 	andeq	r1, r0, r4, lsl r8
    2ab4:	1804050b 	stmdane	r4, {r0, r1, r3, r8, sl}
    2ab8:	050c0000 	streq	r0, [ip, #-0]
    2abc:	000014ed 	andeq	r1, r0, sp, ror #9
    2ac0:	1506050d 	strne	r0, [r6, #-1293]	; 0xfffffaf3
    2ac4:	050e0000 	streq	r0, [lr, #-0]
    2ac8:	000017f5 	strdeq	r1, [r0], -r5
    2acc:	19b9050f 	ldmibne	r9!, {r0, r1, r2, r3, r8, sl}
    2ad0:	05100000 	ldreq	r0, [r0, #-0]
    2ad4:	00001936 	andeq	r1, r0, r6, lsr r9
    2ad8:	19aa0511 	stmibne	sl!, {r0, r4, r8, sl}
    2adc:	05120000 	ldreq	r0, [r2, #-0]
    2ae0:	000015b3 			; <UNDEFINED> instruction: 0x000015b3
    2ae4:	15300513 	ldrne	r0, [r0, #-1299]!	; 0xfffffaed
    2ae8:	05140000 	ldreq	r0, [r4, #-0]
    2aec:	000014fa 	strdeq	r1, [r0], -sl
    2af0:	18930515 	ldmne	r3, {r0, r2, r4, r8, sl}
    2af4:	05160000 	ldreq	r0, [r6, #-0]
    2af8:	00001567 	andeq	r1, r0, r7, ror #10
    2afc:	14a20517 	strtne	r0, [r2], #1303	; 0x517
    2b00:	05180000 	ldreq	r0, [r8, #-0]
    2b04:	0000199c 	muleq	r0, ip, r9
    2b08:	17d10519 	bfine	r0, r9, #10, #8
    2b0c:	051a0000 	ldreq	r0, [sl, #-0]
    2b10:	000018ab 	andeq	r1, r0, fp, lsr #17
    2b14:	153b051b 	ldrne	r0, [fp, #-1307]!	; 0xfffffae5
    2b18:	051c0000 	ldreq	r0, [ip, #-0]
    2b1c:	00001747 	andeq	r1, r0, r7, asr #14
    2b20:	1696051d 			; <UNDEFINED> instruction: 0x1696051d
    2b24:	051e0000 	ldreq	r0, [lr, #-0]
    2b28:	00001928 	andeq	r1, r0, r8, lsr #18
    2b2c:	1984051f 	stmibne	r4, {r0, r1, r2, r3, r4, r8, sl}
    2b30:	05200000 	streq	r0, [r0, #-0]!
    2b34:	000019c5 	andeq	r1, r0, r5, asr #19
    2b38:	19d30521 	ldmibne	r3, {r0, r5, r8, sl}^
    2b3c:	05220000 	streq	r0, [r2, #-0]!
    2b40:	000017e8 	andeq	r1, r0, r8, ror #15
    2b44:	170b0523 	strne	r0, [fp, -r3, lsr #10]
    2b48:	05240000 	streq	r0, [r4, #-0]!
    2b4c:	0000154a 	andeq	r1, r0, sl, asr #10
    2b50:	179e0525 	ldrne	r0, [lr, r5, lsr #10]
    2b54:	05260000 	streq	r0, [r6, #-0]!
    2b58:	000016b0 			; <UNDEFINED> instruction: 0x000016b0
    2b5c:	19530527 	ldmdbne	r3, {r0, r1, r2, r5, r8, sl}^
    2b60:	05280000 	streq	r0, [r8, #-0]!
    2b64:	000016c0 	andeq	r1, r0, r0, asr #13
    2b68:	16cf0529 	strbne	r0, [pc], r9, lsr #10
    2b6c:	052a0000 	streq	r0, [sl, #-0]!
    2b70:	000016de 	ldrdeq	r1, [r0], -lr
    2b74:	16ed052b 	strbtne	r0, [sp], fp, lsr #10
    2b78:	052c0000 	streq	r0, [ip, #-0]!
    2b7c:	0000167b 	andeq	r1, r0, fp, ror r6
    2b80:	16fc052d 	ldrbtne	r0, [ip], sp, lsr #10
    2b84:	052e0000 	streq	r0, [lr, #-0]!
    2b88:	000018e2 	andeq	r1, r0, r2, ror #17
    2b8c:	171a052f 	ldrne	r0, [sl, -pc, lsr #10]
    2b90:	05300000 	ldreq	r0, [r0, #-0]!
    2b94:	00001729 	andeq	r1, r0, r9, lsr #14
    2b98:	14db0531 	ldrbne	r0, [fp], #1329	; 0x531
    2b9c:	05320000 	ldreq	r0, [r2, #-0]!
    2ba0:	00001833 	andeq	r1, r0, r3, lsr r8
    2ba4:	18430533 	stmdane	r3, {r0, r1, r4, r5, r8, sl}^
    2ba8:	05340000 	ldreq	r0, [r4, #-0]!
    2bac:	00001853 	andeq	r1, r0, r3, asr r8
    2bb0:	16690535 			; <UNDEFINED> instruction: 0x16690535
    2bb4:	05360000 	ldreq	r0, [r6, #-0]!
    2bb8:	00001863 	andeq	r1, r0, r3, ror #16
    2bbc:	18730537 	ldmdane	r3!, {r0, r1, r2, r4, r5, r8, sl}^
    2bc0:	05380000 	ldreq	r0, [r8, #-0]!
    2bc4:	00001883 	andeq	r1, r0, r3, lsl #17
    2bc8:	155a0539 	ldrbne	r0, [sl, #-1337]	; 0xfffffac7
    2bcc:	053a0000 	ldreq	r0, [sl, #-0]!
    2bd0:	00001513 	andeq	r1, r0, r3, lsl r5
    2bd4:	1738053b 			; <UNDEFINED> instruction: 0x1738053b
    2bd8:	053c0000 	ldreq	r0, [ip, #-0]!
    2bdc:	000014b2 			; <UNDEFINED> instruction: 0x000014b2
    2be0:	189e053d 	ldmne	lr, {r0, r2, r3, r4, r5, r8, sl}
    2be4:	003e0000 	eorseq	r0, lr, r0
    2be8:	00159a06 	andseq	r9, r5, r6, lsl #20
    2bec:	6b010200 	blvs	433f4 <__bss_end+0x39cbc>
    2bf0:	01ff0802 	mvnseq	r0, r2, lsl #16
    2bf4:	5d070000 	stcpl	0, cr0, [r7, #-0]
    2bf8:	01000017 	tsteq	r0, r7, lsl r0
    2bfc:	47140270 			; <UNDEFINED> instruction: 0x47140270
    2c00:	00000000 	andeq	r0, r0, r0
    2c04:	00167607 	andseq	r7, r6, r7, lsl #12
    2c08:	02710100 	rsbseq	r0, r1, #0, 2
    2c0c:	00004714 	andeq	r4, r0, r4, lsl r7
    2c10:	08000100 	stmdaeq	r0, {r8}
    2c14:	000001d4 	ldrdeq	r0, [r0], -r4
    2c18:	0001ff09 	andeq	pc, r1, r9, lsl #30
    2c1c:	00021400 	andeq	r1, r2, r0, lsl #8
    2c20:	00240a00 	eoreq	r0, r4, r0, lsl #20
    2c24:	00110000 	andseq	r0, r1, r0
    2c28:	00020408 	andeq	r0, r2, r8, lsl #8
    2c2c:	18210b00 	stmdane	r1!, {r8, r9, fp}
    2c30:	74010000 	strvc	r0, [r1], #-0
    2c34:	02142602 	andseq	r2, r4, #2097152	; 0x200000
    2c38:	3a240000 	bcc	902c40 <__bss_end+0x8f9508>
    2c3c:	0f3d0a3d 	svceq	0x003d0a3d
    2c40:	323d243d 	eorscc	r2, sp, #1023410176	; 0x3d000000
    2c44:	053d023d 	ldreq	r0, [sp, #-573]!	; 0xfffffdc3
    2c48:	0d3d133d 	ldceq	3, cr1, [sp, #-244]!	; 0xffffff0c
    2c4c:	233d0c3d 	teqcs	sp, #15616	; 0x3d00
    2c50:	263d113d 			; <UNDEFINED> instruction: 0x263d113d
    2c54:	173d013d 			; <UNDEFINED> instruction: 0x173d013d
    2c58:	093d083d 	ldmdbeq	sp!, {r0, r2, r3, r4, r5, fp}
    2c5c:	0300003d 	movweq	r0, #61	; 0x3d
    2c60:	0c270702 	stceq	7, cr0, [r7], #-8
    2c64:	01030000 	mrseq	r0, (UNDEF: 3)
    2c68:	000b6708 	andeq	r6, fp, r8, lsl #14
    2c6c:	040d0c00 	streq	r0, [sp], #-3072	; 0xfffff400
    2c70:	00000259 	andeq	r0, r0, r9, asr r2
    2c74:	0019e10e 	andseq	lr, r9, lr, lsl #2
    2c78:	39010700 	stmdbcc	r1, {r8, r9, sl}
    2c7c:	02000000 	andeq	r0, r0, #0
    2c80:	9e0604f7 	mcrls	4, 0, r0, cr6, cr7, {7}
    2c84:	05000002 	streq	r0, [r0, #-2]
    2c88:	00001574 	andeq	r1, r0, r4, ror r5
    2c8c:	157f0500 	ldrbne	r0, [pc, #-1280]!	; 2794 <shift+0x2794>
    2c90:	05010000 	streq	r0, [r1, #-0]
    2c94:	00001591 	muleq	r0, r1, r5
    2c98:	15ab0502 	strne	r0, [fp, #1282]!	; 0x502
    2c9c:	05030000 	streq	r0, [r3, #-0]
    2ca0:	0000191b 	andeq	r1, r0, fp, lsl r9
    2ca4:	168a0504 	strne	r0, [sl], r4, lsl #10
    2ca8:	05050000 	streq	r0, [r5, #-0]
    2cac:	000018d4 	ldrdeq	r1, [r0], -r4
    2cb0:	02030006 	andeq	r0, r3, #6
    2cb4:	000a0205 	andeq	r0, sl, r5, lsl #4
    2cb8:	07080300 	streq	r0, [r8, -r0, lsl #6]
    2cbc:	000017ba 			; <UNDEFINED> instruction: 0x000017ba
    2cc0:	cb040403 	blgt	103cd4 <__bss_end+0xfa59c>
    2cc4:	03000014 	movweq	r0, #20
    2cc8:	14c30308 	strbne	r0, [r3], #776	; 0x308
    2ccc:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    2cd0:	00177404 	andseq	r7, r7, r4, lsl #8
    2cd4:	03100300 	tsteq	r0, #0, 6
    2cd8:	000018c5 	andeq	r1, r0, r5, asr #17
    2cdc:	0018bc0f 	andseq	fp, r8, pc, lsl #24
    2ce0:	102a0300 	eorne	r0, sl, r0, lsl #6
    2ce4:	0000025a 	andeq	r0, r0, sl, asr r2
    2ce8:	0002c809 	andeq	ip, r2, r9, lsl #16
    2cec:	0002df00 	andeq	sp, r2, r0, lsl #30
    2cf0:	11001000 	mrsne	r1, (UNDEF: 0)
    2cf4:	00000382 	andeq	r0, r0, r2, lsl #7
    2cf8:	d4112f03 	ldrle	r2, [r1], #-3843	; 0xfffff0fd
    2cfc:	11000002 	tstne	r0, r2
    2d00:	00000276 	andeq	r0, r0, r6, ror r2
    2d04:	d4113003 	ldrle	r3, [r1], #-3
    2d08:	09000002 	stmdbeq	r0, {r1}
    2d0c:	000002c8 	andeq	r0, r0, r8, asr #5
    2d10:	00000307 	andeq	r0, r0, r7, lsl #6
    2d14:	0000240a 	andeq	r2, r0, sl, lsl #8
    2d18:	12000100 	andne	r0, r0, #0, 2
    2d1c:	000002df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    2d20:	0a093304 	beq	24f938 <__bss_end+0x246200>
    2d24:	000002f7 	strdeq	r0, [r0], -r7
    2d28:	97140305 	ldrls	r0, [r4, -r5, lsl #6]
    2d2c:	eb120000 	bl	482d34 <__bss_end+0x4795fc>
    2d30:	04000002 	streq	r0, [r0], #-2
    2d34:	f70a0934 			; <UNDEFINED> instruction: 0xf70a0934
    2d38:	05000002 	streq	r0, [r0, #-2]
    2d3c:	00971403 	addseq	r1, r7, r3, lsl #8
	...

Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
   0:	10001101 	andne	r1, r0, r1, lsl #2
   4:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
   8:	1b0e0301 	blne	380c14 <__bss_end+0x3774dc>
   c:	130e250e 	movwne	r2, #58638	; 0xe50e
  10:	00000005 	andeq	r0, r0, r5
  14:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
  18:	030b130e 	movweq	r1, #45838	; 0xb30e
  1c:	110e1b0e 	tstne	lr, lr, lsl #22
  20:	10061201 	andne	r1, r6, r1, lsl #4
  24:	02000017 	andeq	r0, r0, #23
  28:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  2c:	0b3b0b3a 	bleq	ec2d1c <__bss_end+0xeb95e4>
  30:	13490b39 	movtne	r0, #39737	; 0x9b39
  34:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
  38:	24030000 	strcs	r0, [r3], #-0
  3c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
  40:	000e030b 	andeq	r0, lr, fp, lsl #6
  44:	012e0400 			; <UNDEFINED> instruction: 0x012e0400
  48:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
  4c:	0b3b0b3a 	bleq	ec2d3c <__bss_end+0xeb9604>
  50:	01110b39 	tsteq	r1, r9, lsr fp
  54:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
  58:	01194296 			; <UNDEFINED> instruction: 0x01194296
  5c:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
  60:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  64:	0b3b0b3a 	bleq	ec2d54 <__bss_end+0xeb961c>
  68:	13490b39 	movtne	r0, #39737	; 0x9b39
  6c:	00001802 	andeq	r1, r0, r2, lsl #16
  70:	0b002406 	bleq	9090 <_ZN13COLED_Display10Put_StringEttPKc+0x40>
  74:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
  78:	07000008 	streq	r0, [r0, -r8]
  7c:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
  80:	0b3a0e03 	bleq	e83894 <__bss_end+0xe7a15c>
  84:	0b390b3b 	bleq	e42d78 <__bss_end+0xe39640>
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
  b4:	3a0e0300 	bcc	380cbc <__bss_end+0x377584>
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
  e4:	0b3e0b0b 	bleq	f82d18 <__bss_end+0xf795e0>
  e8:	00000e03 	andeq	r0, r0, r3, lsl #28
  ec:	03003408 	movweq	r3, #1032	; 0x408
  f0:	3b0b3a0e 	blcc	2ce930 <__bss_end+0x2c51f8>
  f4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
  f8:	3c193f13 	ldccc	15, cr3, [r9], {19}
  fc:	09000019 	stmdbeq	r0, {r0, r3, r4}
 100:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 104:	0b3a0e03 	bleq	e83918 <__bss_end+0xe7a1e0>
 108:	0b390b3b 	bleq	e42dfc <__bss_end+0xe396c4>
 10c:	01111349 	tsteq	r1, r9, asr #6
 110:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 114:	01194296 			; <UNDEFINED> instruction: 0x01194296
 118:	0a000013 	beq	16c <shift+0x16c>
 11c:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 120:	0b3b0b3a 	bleq	ec2e10 <__bss_end+0xeb96d8>
 124:	13490b39 	movtne	r0, #39737	; 0x9b39
 128:	00001802 	andeq	r1, r0, r2, lsl #16
 12c:	0b00240b 	bleq	9160 <__udivsi3+0x60>
 130:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 134:	0c000008 	stceq	0, cr0, [r0], {8}
 138:	193f002e 	ldmdbne	pc!, {r1, r2, r3, r5}	; <UNPREDICTABLE>
 13c:	0b3a0e03 	bleq	e83950 <__bss_end+0xe7a218>
 140:	0b390b3b 	bleq	e42e34 <__bss_end+0xe396fc>
 144:	06120111 			; <UNDEFINED> instruction: 0x06120111
 148:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 14c:	0d000019 	stceq	0, cr0, [r0, #-100]	; 0xffffff9c
 150:	0e030139 	mcreq	1, 0, r0, cr3, cr9, {1}
 154:	0b3b0b3a 	bleq	ec2e44 <__bss_end+0xeb970c>
 158:	00001301 	andeq	r1, r0, r1, lsl #6
 15c:	3f012e0e 	svccc	0x00012e0e
 160:	3a0e0319 	bcc	380dcc <__bss_end+0x377694>
 164:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 168:	01193c0b 	tsteq	r9, fp, lsl #24
 16c:	0f000013 	svceq	0x00000013
 170:	13490005 	movtne	r0, #36869	; 0x9005
 174:	2e100000 	cdpcs	0, 1, cr0, cr0, cr0, {0}
 178:	03193f01 	tsteq	r9, #1, 30
 17c:	3b0b3a0e 	blcc	2ce9bc <__bss_end+0x2c5284>
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
 1a8:	3b0b3a08 	blcc	2ce9d0 <__bss_end+0x2c5298>
 1ac:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 1b0:	00180213 	andseq	r0, r8, r3, lsl r2
 1b4:	012e1400 			; <UNDEFINED> instruction: 0x012e1400
 1b8:	01111347 	tsteq	r1, r7, asr #6
 1bc:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 1c0:	00194297 	mulseq	r9, r7, r2
 1c4:	11010000 	mrsne	r0, (UNDEF: 1)
 1c8:	130e2501 	movwne	r2, #58625	; 0xe501
 1cc:	1b0e030b 	blne	380e00 <__bss_end+0x3776c8>
 1d0:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 1d4:	00171006 	andseq	r1, r7, r6
 1d8:	00240200 	eoreq	r0, r4, r0, lsl #4
 1dc:	0b3e0b0b 	bleq	f82e10 <__bss_end+0xf796d8>
 1e0:	00000e03 	andeq	r0, r0, r3, lsl #28
 1e4:	49002603 	stmdbmi	r0, {r0, r1, r9, sl, sp}
 1e8:	04000013 	streq	r0, [r0], #-19	; 0xffffffed
 1ec:	0b0b0024 	bleq	2c0284 <__bss_end+0x2b6b4c>
 1f0:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
 1f4:	16050000 	strne	r0, [r5], -r0
 1f8:	3a0e0300 	bcc	380e00 <__bss_end+0x3776c8>
 1fc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 200:	0013490b 	andseq	r4, r3, fp, lsl #18
 204:	01130600 	tsteq	r3, r0, lsl #12
 208:	0b0b0e03 	bleq	2c3a1c <__bss_end+0x2ba2e4>
 20c:	0b3b0b3a 	bleq	ec2efc <__bss_end+0xeb97c4>
 210:	13010b39 	movwne	r0, #6969	; 0x1b39
 214:	0d070000 	stceq	0, cr0, [r7, #-0]
 218:	3a080300 	bcc	200e20 <__bss_end+0x1f76e8>
 21c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 220:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 224:	0800000b 	stmdaeq	r0, {r0, r1, r3}
 228:	0e030104 	adfeqs	f0, f3, f4
 22c:	0b3e196d 	bleq	f867e8 <__bss_end+0xf7d0b0>
 230:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 234:	0b3b0b3a 	bleq	ec2f24 <__bss_end+0xeb97ec>
 238:	13010b39 	movwne	r0, #6969	; 0x1b39
 23c:	28090000 	stmdacs	r9, {}	; <UNPREDICTABLE>
 240:	1c0e0300 	stcne	3, cr0, [lr], {-0}
 244:	0a00000b 	beq	278 <shift+0x278>
 248:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 24c:	0b3b0b3a 	bleq	ec2f3c <__bss_end+0xeb9804>
 250:	13490b39 	movtne	r0, #39737	; 0x9b39
 254:	1802196c 	stmdane	r2, {r2, r3, r5, r6, r8, fp, ip}
 258:	020b0000 	andeq	r0, fp, #0
 25c:	3c0e0300 	stccc	3, cr0, [lr], {-0}
 260:	0c000019 	stceq	0, cr0, [r0], {25}
 264:	0b0b000f 	bleq	2c02a8 <__bss_end+0x2b6b70>
 268:	00001349 	andeq	r1, r0, r9, asr #6
 26c:	0300280d 	movweq	r2, #2061	; 0x80d
 270:	000b1c08 	andeq	r1, fp, r8, lsl #24
 274:	000d0e00 	andeq	r0, sp, r0, lsl #28
 278:	0b3a0e03 	bleq	e83a8c <__bss_end+0xe7a354>
 27c:	0b390b3b 	bleq	e42f70 <__bss_end+0xe39838>
 280:	0b381349 	bleq	e04fac <__bss_end+0xdfb874>
 284:	010f0000 	mrseq	r0, CPSR
 288:	01134901 	tsteq	r3, r1, lsl #18
 28c:	10000013 	andne	r0, r0, r3, lsl r0
 290:	13490021 	movtne	r0, #36897	; 0x9021
 294:	00000b2f 	andeq	r0, r0, pc, lsr #22
 298:	03010211 	movweq	r0, #4625	; 0x1211
 29c:	3a0b0b0e 	bcc	2c2edc <__bss_end+0x2b97a4>
 2a0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 2a4:	0013010b 	andseq	r0, r3, fp, lsl #2
 2a8:	012e1200 			; <UNDEFINED> instruction: 0x012e1200
 2ac:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 2b0:	0b3b0b3a 	bleq	ec2fa0 <__bss_end+0xeb9868>
 2b4:	0e6e0b39 	vmoveq.8	d14[5], r0
 2b8:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 2bc:	00001301 	andeq	r1, r0, r1, lsl #6
 2c0:	49000513 	stmdbmi	r0, {r0, r1, r4, r8, sl}
 2c4:	00193413 	andseq	r3, r9, r3, lsl r4
 2c8:	00051400 	andeq	r1, r5, r0, lsl #8
 2cc:	00001349 	andeq	r1, r0, r9, asr #6
 2d0:	3f012e15 	svccc	0x00012e15
 2d4:	3a0e0319 	bcc	380f40 <__bss_end+0x377808>
 2d8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 2dc:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 2e0:	64193c13 	ldrvs	r3, [r9], #-3091	; 0xfffff3ed
 2e4:	00130113 	andseq	r0, r3, r3, lsl r1
 2e8:	012e1600 			; <UNDEFINED> instruction: 0x012e1600
 2ec:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 2f0:	0b3b0b3a 	bleq	ec2fe0 <__bss_end+0xeb98a8>
 2f4:	0e6e0b39 	vmoveq.8	d14[5], r0
 2f8:	0b321349 	bleq	c85024 <__bss_end+0xc7b8ec>
 2fc:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 300:	00001301 	andeq	r1, r0, r1, lsl #6
 304:	03000d17 	movweq	r0, #3351	; 0xd17
 308:	3b0b3a0e 	blcc	2ceb48 <__bss_end+0x2c5410>
 30c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 310:	320b3813 	andcc	r3, fp, #1245184	; 0x130000
 314:	1800000b 	stmdane	r0, {r0, r1, r3}
 318:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 31c:	0b3a0e03 	bleq	e83b30 <__bss_end+0xe7a3f8>
 320:	0b390b3b 	bleq	e43014 <__bss_end+0xe398dc>
 324:	0b320e6e 	bleq	c83ce4 <__bss_end+0xc7a5ac>
 328:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 32c:	00001301 	andeq	r1, r0, r1, lsl #6
 330:	3f012e19 	svccc	0x00012e19
 334:	3a0e0319 	bcc	380fa0 <__bss_end+0x377868>
 338:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 33c:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 340:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
 344:	00136419 	andseq	r6, r3, r9, lsl r4
 348:	01151a00 	tsteq	r5, r0, lsl #20
 34c:	13641349 	cmnne	r4, #603979777	; 0x24000001
 350:	00001301 	andeq	r1, r0, r1, lsl #6
 354:	1d001f1b 	stcne	15, cr1, [r0, #-108]	; 0xffffff94
 358:	00134913 	andseq	r4, r3, r3, lsl r9
 35c:	00101c00 	andseq	r1, r0, r0, lsl #24
 360:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 364:	0f1d0000 	svceq	0x001d0000
 368:	000b0b00 	andeq	r0, fp, r0, lsl #22
 36c:	012e1e00 			; <UNDEFINED> instruction: 0x012e1e00
 370:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 374:	0b3b0b3a 	bleq	ec3064 <__bss_end+0xeb992c>
 378:	0e6e0b39 	vmoveq.8	d14[5], r0
 37c:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 380:	00001364 	andeq	r1, r0, r4, ror #6
 384:	0301391f 	movweq	r3, #6431	; 0x191f
 388:	3b0b3a08 	blcc	2cebb0 <__bss_end+0x2c5478>
 38c:	010b390b 	tsteq	fp, fp, lsl #18
 390:	20000013 	andcs	r0, r0, r3, lsl r0
 394:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 398:	0b3b0b3a 	bleq	ec3088 <__bss_end+0xeb9950>
 39c:	13490b39 	movtne	r0, #39737	; 0x9b39
 3a0:	061c193c 			; <UNDEFINED> instruction: 0x061c193c
 3a4:	0000196c 	andeq	r1, r0, ip, ror #18
 3a8:	03003421 	movweq	r3, #1057	; 0x421
 3ac:	3b0b3a0e 	blcc	2cebec <__bss_end+0x2c54b4>
 3b0:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 3b4:	1c193c13 	ldcne	12, cr3, [r9], {19}
 3b8:	00196c0b 	andseq	r6, r9, fp, lsl #24
 3bc:	00342200 	eorseq	r2, r4, r0, lsl #4
 3c0:	00001347 	andeq	r1, r0, r7, asr #6
 3c4:	03003423 	movweq	r3, #1059	; 0x423
 3c8:	3b0b3a0e 	blcc	2cec08 <__bss_end+0x2c54d0>
 3cc:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 3d0:	02193f13 	andseq	r3, r9, #19, 30	; 0x4c
 3d4:	24000018 	strcs	r0, [r0], #-24	; 0xffffffe8
 3d8:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 3dc:	0b3a0e03 	bleq	e83bf0 <__bss_end+0xe7a4b8>
 3e0:	0b390b3b 	bleq	e430d4 <__bss_end+0xe3999c>
 3e4:	01111349 	tsteq	r1, r9, asr #6
 3e8:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 3ec:	01194296 			; <UNDEFINED> instruction: 0x01194296
 3f0:	25000013 	strcs	r0, [r0, #-19]	; 0xffffffed
 3f4:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
 3f8:	0b3b0b3a 	bleq	ec30e8 <__bss_end+0xeb99b0>
 3fc:	13490b39 	movtne	r0, #39737	; 0x9b39
 400:	00001802 	andeq	r1, r0, r2, lsl #16
 404:	03003426 	movweq	r3, #1062	; 0x426
 408:	3b0b3a0e 	blcc	2cec48 <__bss_end+0x2c5510>
 40c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 410:	00180213 	andseq	r0, r8, r3, lsl r2
 414:	00342700 	eorseq	r2, r4, r0, lsl #14
 418:	0b3a0803 	bleq	e8242c <__bss_end+0xe78cf4>
 41c:	0b390b3b 	bleq	e43110 <__bss_end+0xe399d8>
 420:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 424:	0b280000 	bleq	a0042c <__bss_end+0x9f6cf4>
 428:	12011101 	andne	r1, r1, #1073741824	; 0x40000000
 42c:	00000006 	andeq	r0, r0, r6
 430:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
 434:	030b130e 	movweq	r1, #45838	; 0xb30e
 438:	110e1b0e 	tstne	lr, lr, lsl #22
 43c:	10061201 	andne	r1, r6, r1, lsl #4
 440:	02000017 	andeq	r0, r0, #23
 444:	0b0b0024 	bleq	2c04dc <__bss_end+0x2b6da4>
 448:	0e030b3e 	vmoveq.16	d3[0], r0
 44c:	26030000 	strcs	r0, [r3], -r0
 450:	00134900 	andseq	r4, r3, r0, lsl #18
 454:	00240400 	eoreq	r0, r4, r0, lsl #8
 458:	0b3e0b0b 	bleq	f8308c <__bss_end+0xf79954>
 45c:	00000803 	andeq	r0, r0, r3, lsl #16
 460:	03001605 	movweq	r1, #1541	; 0x605
 464:	3b0b3a0e 	blcc	2ceca4 <__bss_end+0x2c556c>
 468:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 46c:	06000013 			; <UNDEFINED> instruction: 0x06000013
 470:	0e030113 	mcreq	1, 0, r0, cr3, cr3, {0}
 474:	0b3a0b0b 	bleq	e830a8 <__bss_end+0xe79970>
 478:	0b390b3b 	bleq	e4316c <__bss_end+0xe39a34>
 47c:	00001301 	andeq	r1, r0, r1, lsl #6
 480:	03000d07 	movweq	r0, #3335	; 0xd07
 484:	3b0b3a08 	blcc	2cecac <__bss_end+0x2c5574>
 488:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 48c:	000b3813 	andeq	r3, fp, r3, lsl r8
 490:	01040800 	tsteq	r4, r0, lsl #16
 494:	196d0e03 	stmdbne	sp!, {r0, r1, r9, sl, fp}^
 498:	0b0b0b3e 	bleq	2c3198 <__bss_end+0x2b9a60>
 49c:	0b3a1349 	bleq	e851c8 <__bss_end+0xe7ba90>
 4a0:	0b390b3b 	bleq	e43194 <__bss_end+0xe39a5c>
 4a4:	00001301 	andeq	r1, r0, r1, lsl #6
 4a8:	03002809 	movweq	r2, #2057	; 0x809
 4ac:	000b1c08 	andeq	r1, fp, r8, lsl #24
 4b0:	00280a00 	eoreq	r0, r8, r0, lsl #20
 4b4:	0b1c0e03 	bleq	703cc8 <__bss_end+0x6fa590>
 4b8:	340b0000 	strcc	r0, [fp], #-0
 4bc:	3a0e0300 	bcc	3810c4 <__bss_end+0x37798c>
 4c0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 4c4:	6c13490b 			; <UNDEFINED> instruction: 0x6c13490b
 4c8:	00180219 	andseq	r0, r8, r9, lsl r2
 4cc:	00020c00 	andeq	r0, r2, r0, lsl #24
 4d0:	193c0e03 	ldmdbne	ip!, {r0, r1, r9, sl, fp}
 4d4:	0f0d0000 	svceq	0x000d0000
 4d8:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 4dc:	0e000013 	mcreq	0, 0, r0, cr0, cr3, {0}
 4e0:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 4e4:	0b3b0b3a 	bleq	ec31d4 <__bss_end+0xeb9a9c>
 4e8:	13490b39 	movtne	r0, #39737	; 0x9b39
 4ec:	00000b38 	andeq	r0, r0, r8, lsr fp
 4f0:	4901010f 	stmdbmi	r1, {r0, r1, r2, r3, r8}
 4f4:	00130113 	andseq	r0, r3, r3, lsl r1
 4f8:	00211000 	eoreq	r1, r1, r0
 4fc:	0b2f1349 	bleq	bc5228 <__bss_end+0xbbbaf0>
 500:	02110000 	andseq	r0, r1, #0
 504:	0b0e0301 	bleq	381110 <__bss_end+0x3779d8>
 508:	3b0b3a0b 	blcc	2ced3c <__bss_end+0x2c5604>
 50c:	010b390b 	tsteq	fp, fp, lsl #18
 510:	12000013 	andne	r0, r0, #19
 514:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 518:	0b3a0e03 	bleq	e83d2c <__bss_end+0xe7a5f4>
 51c:	0b390b3b 	bleq	e43210 <__bss_end+0xe39ad8>
 520:	193c0e6e 	ldmdbne	ip!, {r1, r2, r3, r5, r6, r9, sl, fp}
 524:	13011364 	movwne	r1, #4964	; 0x1364
 528:	05130000 	ldreq	r0, [r3, #-0]
 52c:	34134900 	ldrcc	r4, [r3], #-2304	; 0xfffff700
 530:	14000019 	strne	r0, [r0], #-25	; 0xffffffe7
 534:	13490005 	movtne	r0, #36869	; 0x9005
 538:	2e150000 	cdpcs	0, 1, cr0, cr5, cr0, {0}
 53c:	03193f01 	tsteq	r9, #1, 30
 540:	3b0b3a0e 	blcc	2ced80 <__bss_end+0x2c5648>
 544:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 548:	3c13490e 			; <UNDEFINED> instruction: 0x3c13490e
 54c:	01136419 	tsteq	r3, r9, lsl r4
 550:	16000013 			; <UNDEFINED> instruction: 0x16000013
 554:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 558:	0b3a0e03 	bleq	e83d6c <__bss_end+0xe7a634>
 55c:	0b390b3b 	bleq	e43250 <__bss_end+0xe39b18>
 560:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 564:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 568:	13011364 	movwne	r1, #4964	; 0x1364
 56c:	0d170000 	ldceq	0, cr0, [r7, #-0]
 570:	3a0e0300 	bcc	381178 <__bss_end+0x377a40>
 574:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 578:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 57c:	000b320b 	andeq	r3, fp, fp, lsl #4
 580:	012e1800 			; <UNDEFINED> instruction: 0x012e1800
 584:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 588:	0b3b0b3a 	bleq	ec3278 <__bss_end+0xeb9b40>
 58c:	0e6e0b39 	vmoveq.8	d14[5], r0
 590:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 594:	13011364 	movwne	r1, #4964	; 0x1364
 598:	2e190000 	cdpcs	0, 1, cr0, cr9, cr0, {0}
 59c:	03193f01 	tsteq	r9, #1, 30
 5a0:	3b0b3a0e 	blcc	2cede0 <__bss_end+0x2c56a8>
 5a4:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 5a8:	3213490e 	andscc	r4, r3, #229376	; 0x38000
 5ac:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 5b0:	1a000013 	bne	604 <shift+0x604>
 5b4:	13490115 	movtne	r0, #37141	; 0x9115
 5b8:	13011364 	movwne	r1, #4964	; 0x1364
 5bc:	1f1b0000 	svcne	0x001b0000
 5c0:	49131d00 	ldmdbmi	r3, {r8, sl, fp, ip}
 5c4:	1c000013 	stcne	0, cr0, [r0], {19}
 5c8:	0b0b0010 	bleq	2c0610 <__bss_end+0x2b6ed8>
 5cc:	00001349 	andeq	r1, r0, r9, asr #6
 5d0:	0b000f1d 	bleq	424c <shift+0x424c>
 5d4:	1e00000b 	cdpne	0, 0, cr0, cr0, cr11, {0}
 5d8:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 5dc:	0b3b0b3a 	bleq	ec32cc <__bss_end+0xeb9b94>
 5e0:	13490b39 	movtne	r0, #39737	; 0x9b39
 5e4:	00001802 	andeq	r1, r0, r2, lsl #16
 5e8:	3f012e1f 	svccc	0x00012e1f
 5ec:	3a0e0319 	bcc	381258 <__bss_end+0x377b20>
 5f0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 5f4:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 5f8:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 5fc:	96184006 	ldrls	r4, [r8], -r6
 600:	13011942 	movwne	r1, #6466	; 0x1942
 604:	05200000 	streq	r0, [r0, #-0]!
 608:	3a0e0300 	bcc	381210 <__bss_end+0x377ad8>
 60c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 610:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 614:	21000018 	tstcs	r0, r8, lsl r0
 618:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 61c:	0b3a0e03 	bleq	e83e30 <__bss_end+0xe7a6f8>
 620:	0b390b3b 	bleq	e43314 <__bss_end+0xe39bdc>
 624:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 628:	06120111 			; <UNDEFINED> instruction: 0x06120111
 62c:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 630:	00130119 	andseq	r0, r3, r9, lsl r1
 634:	00342200 	eorseq	r2, r4, r0, lsl #4
 638:	0b3a0803 	bleq	e8264c <__bss_end+0xe78f14>
 63c:	0b390b3b 	bleq	e43330 <__bss_end+0xe39bf8>
 640:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 644:	2e230000 	cdpcs	0, 2, cr0, cr3, cr0, {0}
 648:	03193f01 	tsteq	r9, #1, 30
 64c:	3b0b3a0e 	blcc	2cee8c <__bss_end+0x2c5754>
 650:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 654:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 658:	97184006 	ldrls	r4, [r8, -r6]
 65c:	13011942 	movwne	r1, #6466	; 0x1942
 660:	2e240000 	cdpcs	0, 2, cr0, cr4, cr0, {0}
 664:	03193f00 	tsteq	r9, #0, 30
 668:	3b0b3a0e 	blcc	2ceea8 <__bss_end+0x2c5770>
 66c:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 670:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 674:	97184006 	ldrls	r4, [r8, -r6]
 678:	00001942 	andeq	r1, r0, r2, asr #18
 67c:	3f012e25 	svccc	0x00012e25
 680:	3a0e0319 	bcc	3812ec <__bss_end+0x377bb4>
 684:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 688:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 68c:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 690:	97184006 	ldrls	r4, [r8, -r6]
 694:	00001942 	andeq	r1, r0, r2, asr #18
 698:	01110100 	tsteq	r1, r0, lsl #2
 69c:	0b130e25 	bleq	4c3f38 <__bss_end+0x4ba800>
 6a0:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
 6a4:	06120111 			; <UNDEFINED> instruction: 0x06120111
 6a8:	00001710 	andeq	r1, r0, r0, lsl r7
 6ac:	01013902 	tsteq	r1, r2, lsl #18
 6b0:	03000013 	movweq	r0, #19
 6b4:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 6b8:	0b3b0b3a 	bleq	ec33a8 <__bss_end+0xeb9c70>
 6bc:	13490b39 	movtne	r0, #39737	; 0x9b39
 6c0:	0a1c193c 	beq	706bb8 <__bss_end+0x6fd480>
 6c4:	3a040000 	bcc	1006cc <__bss_end+0xf6f94>
 6c8:	3b0b3a00 	blcc	2ceed0 <__bss_end+0x2c5798>
 6cc:	180b390b 	stmdane	fp, {r0, r1, r3, r8, fp, ip, sp}
 6d0:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
 6d4:	13490101 	movtne	r0, #37121	; 0x9101
 6d8:	00001301 	andeq	r1, r0, r1, lsl #6
 6dc:	49002106 	stmdbmi	r0, {r1, r2, r8, sp}
 6e0:	000b2f13 	andeq	r2, fp, r3, lsl pc
 6e4:	00260700 	eoreq	r0, r6, r0, lsl #14
 6e8:	00001349 	andeq	r1, r0, r9, asr #6
 6ec:	0b002408 	bleq	9714 <messages>
 6f0:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 6f4:	0900000e 	stmdbeq	r0, {r1, r2, r3}
 6f8:	13470034 	movtne	r0, #28724	; 0x7034
 6fc:	2e0a0000 	cdpcs	0, 0, cr0, cr10, cr0, {0}
 700:	03193f01 	tsteq	r9, #1, 30
 704:	3b0b3a0e 	blcc	2cef44 <__bss_end+0x2c580c>
 708:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 70c:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 710:	97184006 	ldrls	r4, [r8, -r6]
 714:	13011942 	movwne	r1, #6466	; 0x1942
 718:	050b0000 	streq	r0, [fp, #-0]
 71c:	3a080300 	bcc	201324 <__bss_end+0x1f7bec>
 720:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 724:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 728:	0c000018 	stceq	0, cr0, [r0], {24}
 72c:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 730:	0b3b0b3a 	bleq	ec3420 <__bss_end+0xeb9ce8>
 734:	13490b39 	movtne	r0, #39737	; 0x9b39
 738:	00001802 	andeq	r1, r0, r2, lsl #16
 73c:	11010b0d 	tstne	r1, sp, lsl #22
 740:	00061201 	andeq	r1, r6, r1, lsl #4
 744:	00340e00 	eorseq	r0, r4, r0, lsl #28
 748:	0b3a0803 	bleq	e8275c <__bss_end+0xe79024>
 74c:	0b390b3b 	bleq	e43440 <__bss_end+0xe39d08>
 750:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 754:	0f0f0000 	svceq	0x000f0000
 758:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 75c:	10000013 	andne	r0, r0, r3, lsl r0
 760:	00000026 	andeq	r0, r0, r6, lsr #32
 764:	0b000f11 	bleq	43b0 <shift+0x43b0>
 768:	1200000b 	andne	r0, r0, #11
 76c:	0b0b0024 	bleq	2c0804 <__bss_end+0x2b70cc>
 770:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
 774:	05130000 	ldreq	r0, [r3, #-0]
 778:	3a0e0300 	bcc	381380 <__bss_end+0x377c48>
 77c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 780:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 784:	14000018 	strne	r0, [r0], #-24	; 0xffffffe8
 788:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 78c:	0b3a0e03 	bleq	e83fa0 <__bss_end+0xe7a868>
 790:	0b390b3b 	bleq	e43484 <__bss_end+0xe39d4c>
 794:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 798:	06120111 			; <UNDEFINED> instruction: 0x06120111
 79c:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 7a0:	00130119 	andseq	r0, r3, r9, lsl r1
 7a4:	012e1500 			; <UNDEFINED> instruction: 0x012e1500
 7a8:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 7ac:	0b3b0b3a 	bleq	ec349c <__bss_end+0xeb9d64>
 7b0:	0e6e0b39 	vmoveq.8	d14[5], r0
 7b4:	06120111 			; <UNDEFINED> instruction: 0x06120111
 7b8:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 7bc:	00000019 	andeq	r0, r0, r9, lsl r0
 7c0:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
 7c4:	030b130e 	movweq	r1, #45838	; 0xb30e
 7c8:	110e1b0e 	tstne	lr, lr, lsl #22
 7cc:	10061201 	andne	r1, r6, r1, lsl #4
 7d0:	02000017 	andeq	r0, r0, #23
 7d4:	0b0b0024 	bleq	2c086c <__bss_end+0x2b7134>
 7d8:	0e030b3e 	vmoveq.16	d3[0], r0
 7dc:	26030000 	strcs	r0, [r3], -r0
 7e0:	00134900 	andseq	r4, r3, r0, lsl #18
 7e4:	00240400 	eoreq	r0, r4, r0, lsl #8
 7e8:	0b3e0b0b 	bleq	f8341c <__bss_end+0xf79ce4>
 7ec:	00000803 	andeq	r0, r0, r3, lsl #16
 7f0:	03001605 	movweq	r1, #1541	; 0x605
 7f4:	3b0b3a0e 	blcc	2cf034 <__bss_end+0x2c58fc>
 7f8:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 7fc:	06000013 			; <UNDEFINED> instruction: 0x06000013
 800:	0e030102 	adfeqs	f0, f3, f2
 804:	0b3a0b0b 	bleq	e83438 <__bss_end+0xe79d00>
 808:	0b390b3b 	bleq	e434fc <__bss_end+0xe39dc4>
 80c:	00001301 	andeq	r1, r0, r1, lsl #6
 810:	03000d07 	movweq	r0, #3335	; 0xd07
 814:	3b0b3a0e 	blcc	2cf054 <__bss_end+0x2c591c>
 818:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 81c:	000b3813 	andeq	r3, fp, r3, lsl r8
 820:	012e0800 			; <UNDEFINED> instruction: 0x012e0800
 824:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 828:	0b3b0b3a 	bleq	ec3518 <__bss_end+0xeb9de0>
 82c:	0e6e0b39 	vmoveq.8	d14[5], r0
 830:	0b321349 	bleq	c8555c <__bss_end+0xc7be24>
 834:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 838:	00001301 	andeq	r1, r0, r1, lsl #6
 83c:	49000509 	stmdbmi	r0, {r0, r3, r8, sl}
 840:	00193413 	andseq	r3, r9, r3, lsl r4
 844:	00050a00 	andeq	r0, r5, r0, lsl #20
 848:	00001349 	andeq	r1, r0, r9, asr #6
 84c:	3f012e0b 	svccc	0x00012e0b
 850:	3a0e0319 	bcc	3814bc <__bss_end+0x377d84>
 854:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 858:	320e6e0b 	andcc	r6, lr, #11, 28	; 0xb0
 85c:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 860:	00130113 	andseq	r0, r3, r3, lsl r1
 864:	012e0c00 			; <UNDEFINED> instruction: 0x012e0c00
 868:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 86c:	0b3b0b3a 	bleq	ec355c <__bss_end+0xeb9e24>
 870:	0e6e0b39 	vmoveq.8	d14[5], r0
 874:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 878:	00001364 	andeq	r1, r0, r4, ror #6
 87c:	0b000f0d 	bleq	44b8 <shift+0x44b8>
 880:	0013490b 	andseq	r4, r3, fp, lsl #18
 884:	000f0e00 	andeq	r0, pc, r0, lsl #28
 888:	00000b0b 	andeq	r0, r0, fp, lsl #22
 88c:	0301130f 	movweq	r1, #4879	; 0x130f
 890:	3a0b0b0e 	bcc	2c34d0 <__bss_end+0x2b9d98>
 894:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 898:	0013010b 	andseq	r0, r3, fp, lsl #2
 89c:	000d1000 	andeq	r1, sp, r0
 8a0:	0b3a0803 	bleq	e828b4 <__bss_end+0xe7917c>
 8a4:	0b390b3b 	bleq	e43598 <__bss_end+0xe39e60>
 8a8:	0b381349 	bleq	e055d4 <__bss_end+0xdfbe9c>
 8ac:	04110000 	ldreq	r0, [r1], #-0
 8b0:	6d0e0301 	stcvs	3, cr0, [lr, #-4]
 8b4:	0b0b3e19 	bleq	2d0120 <__bss_end+0x2c69e8>
 8b8:	3a13490b 	bcc	4d2cec <__bss_end+0x4c95b4>
 8bc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 8c0:	0013010b 	andseq	r0, r3, fp, lsl #2
 8c4:	00281200 	eoreq	r1, r8, r0, lsl #4
 8c8:	0b1c0e03 	bleq	7040dc <__bss_end+0x6fa9a4>
 8cc:	34130000 	ldrcc	r0, [r3], #-0
 8d0:	3a0e0300 	bcc	3814d8 <__bss_end+0x377da0>
 8d4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 8d8:	6c13490b 			; <UNDEFINED> instruction: 0x6c13490b
 8dc:	00180219 	andseq	r0, r8, r9, lsl r2
 8e0:	00021400 	andeq	r1, r2, r0, lsl #8
 8e4:	193c0e03 	ldmdbne	ip!, {r0, r1, r9, sl, fp}
 8e8:	28150000 	ldmdacs	r5, {}	; <UNPREDICTABLE>
 8ec:	1c080300 	stcne	3, cr0, [r8], {-0}
 8f0:	1600000b 	strne	r0, [r0], -fp
 8f4:	13490101 	movtne	r0, #37121	; 0x9101
 8f8:	00001301 	andeq	r1, r0, r1, lsl #6
 8fc:	49002117 	stmdbmi	r0, {r0, r1, r2, r4, r8, sp}
 900:	000b2f13 	andeq	r2, fp, r3, lsl pc
 904:	012e1800 			; <UNDEFINED> instruction: 0x012e1800
 908:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 90c:	0b3b0b3a 	bleq	ec35fc <__bss_end+0xeb9ec4>
 910:	0e6e0b39 	vmoveq.8	d14[5], r0
 914:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 918:	00001301 	andeq	r1, r0, r1, lsl #6
 91c:	3f012e19 	svccc	0x00012e19
 920:	3a0e0319 	bcc	38158c <__bss_end+0x377e54>
 924:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 928:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 92c:	64193c13 	ldrvs	r3, [r9], #-3091	; 0xfffff3ed
 930:	00130113 	andseq	r0, r3, r3, lsl r1
 934:	000d1a00 	andeq	r1, sp, r0, lsl #20
 938:	0b3a0e03 	bleq	e8414c <__bss_end+0xe7aa14>
 93c:	0b390b3b 	bleq	e43630 <__bss_end+0xe39ef8>
 940:	0b381349 	bleq	e0566c <__bss_end+0xdfbf34>
 944:	00000b32 	andeq	r0, r0, r2, lsr fp
 948:	3f012e1b 	svccc	0x00012e1b
 94c:	3a0e0319 	bcc	3815b8 <__bss_end+0x377e80>
 950:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 954:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 958:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
 95c:	00136419 	andseq	r6, r3, r9, lsl r4
 960:	01151c00 	tsteq	r5, r0, lsl #24
 964:	13641349 	cmnne	r4, #603979777	; 0x24000001
 968:	00001301 	andeq	r1, r0, r1, lsl #6
 96c:	1d001f1d 	stcne	15, cr1, [r0, #-116]	; 0xffffff8c
 970:	00134913 	andseq	r4, r3, r3, lsl r9
 974:	00101e00 	andseq	r1, r0, r0, lsl #28
 978:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 97c:	391f0000 	ldmdbcc	pc, {}	; <UNPREDICTABLE>
 980:	3a080301 	bcc	20158c <__bss_end+0x1f7e54>
 984:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 988:	0013010b 	andseq	r0, r3, fp, lsl #2
 98c:	00342000 	eorseq	r2, r4, r0
 990:	0b3a0e03 	bleq	e841a4 <__bss_end+0xe7aa6c>
 994:	0b390b3b 	bleq	e43688 <__bss_end+0xe39f50>
 998:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 99c:	196c061c 	stmdbne	ip!, {r2, r3, r4, r9, sl}^
 9a0:	34210000 	strtcc	r0, [r1], #-0
 9a4:	3a0e0300 	bcc	3815ac <__bss_end+0x377e74>
 9a8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 9ac:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
 9b0:	6c0b1c19 	stcvs	12, cr1, [fp], {25}
 9b4:	22000019 	andcs	r0, r0, #25
 9b8:	13470034 	movtne	r0, #28724	; 0x7034
 9bc:	39230000 	stmdbcc	r3!, {}	; <UNPREDICTABLE>
 9c0:	3a0e0301 	bcc	3815cc <__bss_end+0x377e94>
 9c4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 9c8:	0013010b 	andseq	r0, r3, fp, lsl #2
 9cc:	00342400 	eorseq	r2, r4, r0, lsl #8
 9d0:	0b3a0e03 	bleq	e841e4 <__bss_end+0xe7aaac>
 9d4:	0b390b3b 	bleq	e436c8 <__bss_end+0xe39f90>
 9d8:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 9dc:	0000031c 	andeq	r0, r0, ip, lsl r3
 9e0:	49002125 	stmdbmi	r0, {r0, r2, r5, r8, sp}
 9e4:	00052f13 	andeq	r2, r5, r3, lsl pc
 9e8:	012e2600 			; <UNDEFINED> instruction: 0x012e2600
 9ec:	0b3a1347 	bleq	e85710 <__bss_end+0xe7bfd8>
 9f0:	0b390b3b 	bleq	e436e4 <__bss_end+0xe39fac>
 9f4:	01111364 	tsteq	r1, r4, ror #6
 9f8:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 9fc:	01194296 			; <UNDEFINED> instruction: 0x01194296
 a00:	27000013 	smladcs	r0, r3, r0, r0
 a04:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
 a08:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
 a0c:	00001802 	andeq	r1, r0, r2, lsl #16
 a10:	03000528 	movweq	r0, #1320	; 0x528
 a14:	3b0b3a08 	blcc	2cf23c <__bss_end+0x2c5b04>
 a18:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 a1c:	00180213 	andseq	r0, r8, r3, lsl r2
 a20:	00342900 	eorseq	r2, r4, r0, lsl #18
 a24:	0b3a0803 	bleq	e82a38 <__bss_end+0xe79300>
 a28:	0b390b3b 	bleq	e4371c <__bss_end+0xe39fe4>
 a2c:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 a30:	052a0000 	streq	r0, [sl, #-0]!
 a34:	3a0e0300 	bcc	38163c <__bss_end+0x377f04>
 a38:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 a3c:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 a40:	2b000018 	blcs	aa8 <shift+0xaa8>
 a44:	1347012e 	movtne	r0, #28974	; 0x712e
 a48:	0b3b0b3a 	bleq	ec3738 <__bss_end+0xeba000>
 a4c:	13640b39 	cmnne	r4, #58368	; 0xe400
 a50:	06120111 			; <UNDEFINED> instruction: 0x06120111
 a54:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 a58:	00130119 	andseq	r0, r3, r9, lsl r1
 a5c:	012e2c00 			; <UNDEFINED> instruction: 0x012e2c00
 a60:	0b3a1347 	bleq	e85784 <__bss_end+0xe7c04c>
 a64:	0b390b3b 	bleq	e43758 <__bss_end+0xe3a020>
 a68:	13641349 	cmnne	r4, #603979777	; 0x24000001
 a6c:	13010b20 	movwne	r0, #6944	; 0x1b20
 a70:	052d0000 	streq	r0, [sp, #-0]!
 a74:	490e0300 	stmdbmi	lr, {r8, r9}
 a78:	00193413 	andseq	r3, r9, r3, lsl r4
 a7c:	012e2e00 			; <UNDEFINED> instruction: 0x012e2e00
 a80:	0e6e1331 	mcreq	3, 3, r1, cr14, cr1, {1}
 a84:	01111364 	tsteq	r1, r4, ror #6
 a88:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 a8c:	01194296 			; <UNDEFINED> instruction: 0x01194296
 a90:	2f000013 	svccs	0x00000013
 a94:	13310005 	teqne	r1, #5
 a98:	00001802 	andeq	r1, r0, r2, lsl #16
 a9c:	47012e30 	smladxmi	r1, r0, lr, r2
 aa0:	3b0b3a13 	blcc	2cf2f4 <__bss_end+0x2c5bbc>
 aa4:	640b390b 	strvs	r3, [fp], #-2315	; 0xfffff6f5
 aa8:	010b2013 	tsteq	fp, r3, lsl r0
 aac:	31000013 	tstcc	r0, r3, lsl r0
 ab0:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
 ab4:	0b3b0b3a 	bleq	ec37a4 <__bss_end+0xeba06c>
 ab8:	13490b39 	movtne	r0, #39737	; 0x9b39
 abc:	2e320000 	cdpcs	0, 3, cr0, cr2, cr0, {0}
 ac0:	6e133101 	mufvss	f3, f3, f1
 ac4:	1113640e 	tstne	r3, lr, lsl #8
 ac8:	40061201 	andmi	r1, r6, r1, lsl #4
 acc:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
 ad0:	01000000 	mrseq	r0, (UNDEF: 0)
 ad4:	06100011 			; <UNDEFINED> instruction: 0x06100011
 ad8:	01120111 	tsteq	r2, r1, lsl r1
 adc:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
 ae0:	05130e25 	ldreq	r0, [r3, #-3621]	; 0xfffff1db
 ae4:	01000000 	mrseq	r0, (UNDEF: 0)
 ae8:	06100011 			; <UNDEFINED> instruction: 0x06100011
 aec:	01120111 	tsteq	r2, r1, lsl r1
 af0:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
 af4:	05130e25 	ldreq	r0, [r3, #-3621]	; 0xfffff1db
 af8:	01000000 	mrseq	r0, (UNDEF: 0)
 afc:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
 b00:	0e030b13 	vmoveq.32	d3[0], r0
 b04:	17100e1b 			; <UNDEFINED> instruction: 0x17100e1b
 b08:	24020000 	strcs	r0, [r2], #-0
 b0c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 b10:	0008030b 	andeq	r0, r8, fp, lsl #6
 b14:	00240300 	eoreq	r0, r4, r0, lsl #6
 b18:	0b3e0b0b 	bleq	f8374c <__bss_end+0xf7a014>
 b1c:	00000e03 	andeq	r0, r0, r3, lsl #28
 b20:	03010404 	movweq	r0, #5124	; 0x1404
 b24:	0b0b3e0e 	bleq	2d0364 <__bss_end+0x2c6c2c>
 b28:	3a13490b 	bcc	4d2f5c <__bss_end+0x4c9824>
 b2c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 b30:	0013010b 	andseq	r0, r3, fp, lsl #2
 b34:	00280500 	eoreq	r0, r8, r0, lsl #10
 b38:	0b1c0e03 	bleq	70434c <__bss_end+0x6fac14>
 b3c:	13060000 	movwne	r0, #24576	; 0x6000
 b40:	0b0e0301 	bleq	38174c <__bss_end+0x378014>
 b44:	3b0b3a0b 	blcc	2cf378 <__bss_end+0x2c5c40>
 b48:	010b3905 	tsteq	fp, r5, lsl #18
 b4c:	07000013 	smladeq	r0, r3, r0, r0
 b50:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 b54:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 b58:	13490b39 	movtne	r0, #39737	; 0x9b39
 b5c:	00000b38 	andeq	r0, r0, r8, lsr fp
 b60:	49002608 	stmdbmi	r0, {r3, r9, sl, sp}
 b64:	09000013 	stmdbeq	r0, {r0, r1, r4}
 b68:	13490101 	movtne	r0, #37121	; 0x9101
 b6c:	00001301 	andeq	r1, r0, r1, lsl #6
 b70:	4900210a 	stmdbmi	r0, {r1, r3, r8, sp}
 b74:	000b2f13 	andeq	r2, fp, r3, lsl pc
 b78:	00340b00 	eorseq	r0, r4, r0, lsl #22
 b7c:	0b3a0e03 	bleq	e84390 <__bss_end+0xe7ac58>
 b80:	0b39053b 	bleq	e42074 <__bss_end+0xe3893c>
 b84:	0a1c1349 	beq	7058b0 <__bss_end+0x6fc178>
 b88:	150c0000 	strne	r0, [ip, #-0]
 b8c:	00192700 	andseq	r2, r9, r0, lsl #14
 b90:	000f0d00 	andeq	r0, pc, r0, lsl #26
 b94:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 b98:	040e0000 	streq	r0, [lr], #-0
 b9c:	3e0e0301 	cdpcc	3, 0, cr0, cr14, cr1, {0}
 ba0:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
 ba4:	3b0b3a13 	blcc	2cf3f8 <__bss_end+0x2c5cc0>
 ba8:	010b3905 	tsteq	fp, r5, lsl #18
 bac:	0f000013 	svceq	0x00000013
 bb0:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
 bb4:	0b3b0b3a 	bleq	ec38a4 <__bss_end+0xeba16c>
 bb8:	13490b39 	movtne	r0, #39737	; 0x9b39
 bbc:	21100000 	tstcs	r0, r0
 bc0:	11000000 	mrsne	r0, (UNDEF: 0)
 bc4:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 bc8:	0b3b0b3a 	bleq	ec38b8 <__bss_end+0xeba180>
 bcc:	13490b39 	movtne	r0, #39737	; 0x9b39
 bd0:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
 bd4:	34120000 	ldrcc	r0, [r2], #-0
 bd8:	3a134700 	bcc	4d27e0 <__bss_end+0x4c90a8>
 bdc:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 be0:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 be4:	00000018 	andeq	r0, r0, r8, lsl r0

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
  74:	0000010c 	andeq	r0, r0, ip, lsl #2
	...
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	0c220002 	stceq	0, cr0, [r2], #-8
  88:	00040000 	andeq	r0, r4, r0
  8c:	00000000 	andeq	r0, r0, r0
  90:	00008338 	andeq	r8, r0, r8, lsr r3
  94:	0000045c 	andeq	r0, r0, ip, asr r4
	...
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	17450002 	strbne	r0, [r5, -r2]
  a8:	00040000 	andeq	r0, r4, r0
  ac:	00000000 	andeq	r0, r0, r0
  b0:	00008794 	muleq	r0, r4, r7
  b4:	000004b8 			; <UNDEFINED> instruction: 0x000004b8
	...
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	1a770002 	bne	1dc00d4 <__bss_end+0x1db699c>
  c8:	00040000 	andeq	r0, r4, r0
  cc:	00000000 	andeq	r0, r0, r0
  d0:	00008c4c 	andeq	r8, r0, ip, asr #24
  d4:	000004b4 			; <UNDEFINED> instruction: 0x000004b4
	...
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	29c80002 	stmibcs	r8, {r1}^
  e8:	00040000 	andeq	r0, r4, r0
  ec:	00000000 	andeq	r0, r0, r0
  f0:	00009100 	andeq	r9, r0, r0, lsl #2
  f4:	0000020c 	andeq	r0, r0, ip, lsl #4
	...
 100:	0000001c 	andeq	r0, r0, ip, lsl r0
 104:	29ee0002 	stmibcs	lr!, {r1}^
 108:	00040000 	andeq	r0, r4, r0
 10c:	00000000 	andeq	r0, r0, r0
 110:	0000930c 	andeq	r9, r0, ip, lsl #6
 114:	00000004 	andeq	r0, r0, r4
	...
 120:	00000014 	andeq	r0, r0, r4, lsl r0
 124:	2a140002 	bcs	500134 <__bss_end+0x4f69fc>
 128:	00040000 	andeq	r0, r4, r0
	...

Disassembly of section .debug_str:

00000000 <.debug_str>:
       0:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
       4:	552f632f 	strpl	r6, [pc, #-815]!	; fffffcdd <__bss_end+0xffff65a5>
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
      44:	6d2f0073 	stcvs	0, cr0, [pc, #-460]!	; fffffe80 <__bss_end+0xffff6748>
      48:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
      4c:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
      50:	4b2f7372 	blmi	bdce20 <__bss_end+0xbd36e8>
      54:	2f616275 	svccs	0x00616275
      58:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
      5c:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
      60:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
      64:	614d6f72 	hvcvs	55026	; 0xd6f2
      68:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffafc <__bss_end+0xffff63c4>
      6c:	706d6178 	rsbvc	r6, sp, r8, ror r1
      70:	2f73656c 	svccs	0x0073656c
      74:	652d3831 	strvs	r3, [sp, #-2097]!	; 0xfffff7cf
      78:	752f6664 	strvc	r6, [pc, #-1636]!	; fffffa1c <__bss_end+0xffff62e4>
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
     114:	2b6b7a36 	blcs	1ade9f4 <__bss_end+0x1ad52bc>
     118:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
     11c:	672d2067 	strvs	r2, [sp, -r7, rrx]!
     120:	304f2d20 	subcc	r2, pc, r0, lsr #26
     124:	304f2d20 	subcc	r2, pc, r0, lsr #26
     128:	625f5f00 	subsvs	r5, pc, #0, 30
     12c:	655f7373 	ldrbvs	r7, [pc, #-883]	; fffffdc1 <__bss_end+0xffff6689>
     130:	7200646e 	andvc	r6, r0, #1845493760	; 0x6e000000
     134:	6c757365 	ldclvs	3, cr7, [r5], #-404	; 0xfffffe6c
     138:	6d2f0074 	stcvs	0, cr0, [pc, #-464]!	; ffffff70 <__bss_end+0xffff6838>
     13c:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
     140:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
     144:	4b2f7372 	blmi	bdcf14 <__bss_end+0xbd37dc>
     148:	2f616275 	svccs	0x00616275
     14c:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
     150:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
     154:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
     158:	614d6f72 	hvcvs	55026	; 0xd6f2
     15c:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffbf0 <__bss_end+0xffff64b8>
     160:	706d6178 	rsbvc	r6, sp, r8, ror r1
     164:	2f73656c 	svccs	0x0073656c
     168:	652d3831 	strvs	r3, [sp, #-2097]!	; 0xfffff7cf
     16c:	752f6664 	strvc	r6, [pc, #-1636]!	; fffffb10 <__bss_end+0xffff63d8>
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
     21c:	4b2f7372 	blmi	bdcfec <__bss_end+0xbd38b4>
     220:	2f616275 	svccs	0x00616275
     224:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
     228:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
     22c:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
     230:	614d6f72 	hvcvs	55026	; 0xd6f2
     234:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffcc8 <__bss_end+0xffff6590>
     238:	706d6178 	rsbvc	r6, sp, r8, ror r1
     23c:	2f73656c 	svccs	0x0073656c
     240:	652d3831 	strvs	r3, [sp, #-2097]!	; 0xfffff7cf
     244:	752f6664 	strvc	r6, [pc, #-1636]!	; fffffbe8 <__bss_end+0xffff64b0>
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
     3ac:	68637300 	stmdavs	r3!, {r8, r9, ip, sp, lr}^
     3b0:	735f6465 	cmpvc	pc, #1694498816	; 0x65000000
     3b4:	69746174 	ldmdbvs	r4!, {r2, r4, r5, r6, r8, sp, lr}^
     3b8:	72705f63 	rsbsvc	r5, r0, #396	; 0x18c
     3bc:	69726f69 	ldmdbvs	r2!, {r0, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
     3c0:	5f007974 	svcpl	0x00007974
     3c4:	314b4e5a 	cmpcc	fp, sl, asr lr
     3c8:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     3cc:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     3d0:	614d5f73 	hvcvs	54771	; 0xd5f3
     3d4:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     3d8:	47383172 			; <UNDEFINED> instruction: 0x47383172
     3dc:	505f7465 	subspl	r7, pc, r5, ror #8
     3e0:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     3e4:	425f7373 	subsmi	r7, pc, #-872415231	; 0xcc000001
     3e8:	49505f79 	ldmdbmi	r0, {r0, r3, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     3ec:	006a4544 	rsbeq	r4, sl, r4, asr #10
     3f0:	314e5a5f 	cmpcc	lr, pc, asr sl
     3f4:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     3f8:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     3fc:	614d5f73 	hvcvs	54771	; 0xd5f3
     400:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     404:	4d393172 	ldfmis	f3, [r9, #-456]!	; 0xfffffe38
     408:	465f7061 	ldrbmi	r7, [pc], -r1, rrx
     40c:	5f656c69 	svcpl	0x00656c69
     410:	435f6f54 	cmpmi	pc, #84, 30	; 0x150
     414:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     418:	5045746e 	subpl	r7, r5, lr, ror #8
     41c:	69464935 	stmdbvs	r6, {r0, r2, r4, r5, r8, fp, lr}^
     420:	5500656c 	strpl	r6, [r0, #-1388]	; 0xfffffa94
     424:	70616d6e 	rsbvc	r6, r1, lr, ror #26
     428:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     42c:	75435f65 	strbvc	r5, [r3, #-3941]	; 0xfffff09b
     430:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
     434:	78650074 	stmdavc	r5!, {r2, r4, r5, r6}^
     438:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
     43c:	0065646f 	rsbeq	r6, r5, pc, ror #8
     440:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     444:	505f656c 	subspl	r6, pc, ip, ror #10
     448:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     44c:	535f7373 	cmppl	pc, #-872415231	; 0xcc000001
     450:	47004957 	smlsdmi	r0, r7, r9, r4
     454:	535f7465 	cmppl	pc, #1694498816	; 0x65000000
     458:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     45c:	72656c75 	rsbvc	r6, r5, #29952	; 0x7500
     460:	666e495f 			; <UNDEFINED> instruction: 0x666e495f
     464:	614d006f 	cmpvs	sp, pc, rrx
     468:	69465f70 	stmdbvs	r6, {r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     46c:	545f656c 	ldrbpl	r6, [pc], #-1388	; 474 <shift+0x474>
     470:	75435f6f 	strbvc	r5, [r3, #-3951]	; 0xfffff091
     474:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
     478:	6f5a0074 	svcvs	0x005a0074
     47c:	6569626d 	strbvs	r6, [r9, #-621]!	; 0xfffffd93
     480:	78656e00 	stmdavc	r5!, {r9, sl, fp, sp, lr}^
     484:	75520074 	ldrbvc	r0, [r2, #-116]	; 0xffffff8c
     488:	62616e6e 	rsbvs	r6, r1, #1760	; 0x6e0
     48c:	4900656c 	stmdbmi	r0, {r2, r3, r5, r6, r8, sl, sp, lr}
     490:	6c61766e 	stclvs	6, cr7, [r1], #-440	; 0xfffffe48
     494:	485f6469 	ldmdami	pc, {r0, r3, r5, r6, sl, sp, lr}^	; <UNPREDICTABLE>
     498:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     49c:	75520065 	ldrbvc	r0, [r2, #-101]	; 0xffffff9b
     4a0:	6e696e6e 	cdpvs	14, 6, cr6, cr9, cr14, {3}
     4a4:	65440067 	strbvs	r0, [r4, #-103]	; 0xffffff99
     4a8:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
     4ac:	555f656e 	ldrbpl	r6, [pc, #-1390]	; ffffff46 <__bss_end+0xffff680e>
     4b0:	6168636e 	cmnvs	r8, lr, ror #6
     4b4:	6465676e 	strbtvs	r6, [r5], #-1902	; 0xfffff892
     4b8:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     4bc:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     4c0:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     4c4:	6f72505f 	svcvs	0x0072505f
     4c8:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     4cc:	49504700 	ldmdbmi	r0, {r8, r9, sl, lr}^
     4d0:	61425f4f 	cmpvs	r2, pc, asr #30
     4d4:	5f006573 	svcpl	0x00006573
     4d8:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     4dc:	6f725043 	svcvs	0x00725043
     4e0:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     4e4:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     4e8:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     4ec:	72433431 	subvc	r3, r3, #822083584	; 0x31000000
     4f0:	65746165 	ldrbvs	r6, [r4, #-357]!	; 0xfffffe9b
     4f4:	6f72505f 	svcvs	0x0072505f
     4f8:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     4fc:	6a685045 	bvs	1a14618 <__bss_end+0x1a0aee0>
     500:	72700062 	rsbsvc	r0, r0, #98	; 0x62
     504:	5f007665 	svcpl	0x00007665
     508:	33314e5a 	teqcc	r1, #1440	; 0x5a0
     50c:	454c4f43 	strbmi	r4, [ip, #-3907]	; 0xfffff0bd
     510:	69445f44 	stmdbvs	r4, {r2, r6, r8, r9, sl, fp, ip, lr}^
     514:	616c7073 	smcvs	50947	; 0xc703
     518:	75503879 	ldrbvc	r3, [r0, #-2169]	; 0xfffff787
     51c:	68435f74 	stmdavs	r3, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     520:	74457261 	strbvc	r7, [r5], #-609	; 0xfffffd9f
     524:	5f006374 	svcpl	0x00006374
     528:	314b4e5a 	cmpcc	fp, sl, asr lr
     52c:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     530:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     534:	614d5f73 	hvcvs	54771	; 0xd5f3
     538:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     53c:	47393172 			; <UNDEFINED> instruction: 0x47393172
     540:	435f7465 	cmpmi	pc, #1694498816	; 0x65000000
     544:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     548:	505f746e 	subspl	r7, pc, lr, ror #8
     54c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     550:	76457373 			; <UNDEFINED> instruction: 0x76457373
     554:	61655200 	cmnvs	r5, r0, lsl #4
     558:	6e4f5f64 	cdpvs	15, 4, cr5, cr15, cr4, {3}
     55c:	4d00796c 	vstrmi.16	s14, [r0, #-216]	; 0xffffff28	; <UNPREDICTABLE>
     560:	505f7861 	subspl	r7, pc, r1, ror #16
     564:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     568:	4f5f7373 	svcmi	0x005f7373
     56c:	656e6570 	strbvs	r6, [lr, #-1392]!	; 0xfffffa90
     570:	69465f64 	stmdbvs	r6, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     574:	0073656c 	rsbseq	r6, r3, ip, ror #10
     578:	55504354 	ldrbpl	r4, [r0, #-852]	; 0xfffffcac
     57c:	6e6f435f 	mcrvs	3, 3, r4, cr15, cr15, {2}
     580:	74786574 	ldrbtvc	r6, [r8], #-1396	; 0xfffffa8c
     584:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     588:	50433631 	subpl	r3, r3, r1, lsr r6
     58c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     590:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 3cc <shift+0x3cc>
     594:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     598:	53387265 	teqpl	r8, #1342177286	; 0x50000006
     59c:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     5a0:	45656c75 	strbmi	r6, [r5, #-3189]!	; 0xfffff38b
     5a4:	5a5f0076 	bpl	17c0784 <__bss_end+0x17b704c>
     5a8:	4333314e 	teqmi	r3, #-2147483629	; 0x80000013
     5ac:	44454c4f 	strbmi	r4, [r5], #-3151	; 0xfffff3b1
     5b0:	7369445f 	cmnvc	r9, #1593835520	; 0x5f000000
     5b4:	79616c70 	stmdbvc	r1!, {r4, r5, r6, sl, fp, sp, lr}^
     5b8:	50453443 	subpl	r3, r5, r3, asr #8
     5bc:	4900634b 	stmdbmi	r0, {r0, r1, r3, r6, r8, r9, sp, lr}
     5c0:	704f5f73 	subvc	r5, pc, r3, ror pc	; <UNPREDICTABLE>
     5c4:	64656e65 	strbtvs	r6, [r5], #-3685	; 0xfffff19b
     5c8:	746f4e00 	strbtvc	r4, [pc], #-3584	; 5d0 <shift+0x5d0>
     5cc:	41796669 	cmnmi	r9, r9, ror #12
     5d0:	42006c6c 	andmi	r6, r0, #108, 24	; 0x6c00
     5d4:	6b636f6c 	blvs	18dc38c <__bss_end+0x18d2c54>
     5d8:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     5dc:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     5e0:	6f72505f 	svcvs	0x0072505f
     5e4:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     5e8:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     5ec:	4449505f 	strbmi	r5, [r9], #-95	; 0xffffffa1
     5f0:	6e697500 	cdpvs	5, 6, cr7, cr9, cr0, {0}
     5f4:	5f323374 	svcpl	0x00323374
     5f8:	5a5f0074 	bpl	17c07d0 <__bss_end+0x17b7098>
     5fc:	4333314e 	teqmi	r3, #-2147483629	; 0x80000013
     600:	44454c4f 	strbmi	r4, [r5], #-3151	; 0xfffff3b1
     604:	7369445f 	cmnvc	r9, #1593835520	; 0x5f000000
     608:	79616c70 	stmdbvc	r1!, {r4, r5, r6, sl, fp, sp, lr}^
     60c:	656c4335 	strbvs	r4, [ip, #-821]!	; 0xfffffccb
     610:	62457261 	subvs	r7, r5, #268435462	; 0x10000006
     614:	43534200 	cmpmi	r3, #0, 4
     618:	61425f31 	cmpvs	r2, r1, lsr pc
     61c:	50006573 	andpl	r6, r0, r3, ror r5
     620:	435f7475 	cmpmi	pc, #1962934272	; 0x75000000
     624:	00726168 	rsbseq	r6, r2, r8, ror #2
     628:	74696157 	strbtvc	r6, [r9], #-343	; 0xfffffea9
     62c:	61544e00 	cmpvs	r4, r0, lsl #28
     630:	535f6b73 	cmppl	pc, #117760	; 0x1cc00
     634:	65746174 	ldrbvs	r6, [r4, #-372]!	; 0xfffffe8c
     638:	68635300 	stmdavs	r3!, {r8, r9, ip, lr}^
     63c:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     640:	44455f65 	strbmi	r5, [r5], #-3941	; 0xfffff09b
     644:	6c420046 	mcrrvs	0, 4, r0, r2, cr6
     648:	656b636f 	strbvs	r6, [fp, #-879]!	; 0xfffffc91
     64c:	436d0064 	cmnmi	sp, #100	; 0x64
     650:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     654:	545f746e 	ldrbpl	r7, [pc], #-1134	; 65c <shift+0x65c>
     658:	5f6b7361 	svcpl	0x006b7361
     65c:	65646f4e 	strbvs	r6, [r4, #-3918]!	; 0xfffff0b2
     660:	656c7300 	strbvs	r7, [ip, #-768]!	; 0xfffffd00
     664:	745f7065 	ldrbvc	r7, [pc], #-101	; 66c <shift+0x66c>
     668:	72656d69 	rsbvc	r6, r5, #6720	; 0x1a40
     66c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     670:	50433631 	subpl	r3, r3, r1, lsr r6
     674:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     678:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 4b4 <shift+0x4b4>
     67c:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     680:	53397265 	teqpl	r9, #1342177286	; 0x50000006
     684:	63746977 	cmnvs	r4, #1949696	; 0x1dc000
     688:	6f545f68 	svcvs	0x00545f68
     68c:	38315045 	ldmdacc	r1!, {r0, r2, r6, ip, lr}
     690:	6f725043 	svcvs	0x00725043
     694:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     698:	73694c5f 	cmnvc	r9, #24320	; 0x5f00
     69c:	6f4e5f74 	svcvs	0x004e5f74
     6a0:	63006564 	movwvs	r6, #1380	; 0x564
     6a4:	635f7570 	cmpvs	pc, #112, 10	; 0x1c000000
     6a8:	65746e6f 	ldrbvs	r6, [r4, #-3695]!	; 0xfffff191
     6ac:	43007478 	movwmi	r7, #1144	; 0x478
     6b0:	74616572 	strbtvc	r6, [r1], #-1394	; 0xfffffa8e
     6b4:	72505f65 	subsvc	r5, r0, #404	; 0x194
     6b8:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     6bc:	704f0073 	subvc	r0, pc, r3, ror r0	; <UNPREDICTABLE>
     6c0:	54006e65 	strpl	r6, [r0], #-3685	; 0xfffff19b
     6c4:	72656d69 	rsbvc	r6, r5, #6720	; 0x1a40
     6c8:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
     6cc:	5a5f0065 	bpl	17c0868 <__bss_end+0x17b7130>
     6d0:	4333314e 	teqmi	r3, #-2147483629	; 0x80000013
     6d4:	44454c4f 	strbmi	r4, [r5], #-3151	; 0xfffff3b1
     6d8:	7369445f 	cmnvc	r9, #1593835520	; 0x5f000000
     6dc:	79616c70 	stmdbvc	r1!, {r4, r5, r6, sl, fp, sp, lr}^
     6e0:	696c4634 	stmdbvs	ip!, {r2, r4, r5, r9, sl, lr}^
     6e4:	00764570 	rsbseq	r4, r6, r0, ror r5
     6e8:	314e5a5f 	cmpcc	lr, pc, asr sl
     6ec:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     6f0:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     6f4:	614d5f73 	hvcvs	54771	; 0xd5f3
     6f8:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     6fc:	4e343172 	mrcmi	1, 1, r3, cr4, cr2, {3}
     700:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     704:	72505f79 	subsvc	r5, r0, #484	; 0x1e4
     708:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     70c:	31504573 	cmpcc	r0, r3, ror r5
     710:	61545432 	cmpvs	r4, r2, lsr r4
     714:	535f6b73 	cmppl	pc, #117760	; 0x1cc00
     718:	63757274 	cmnvs	r5, #116, 4	; 0x40000007
     71c:	65470074 	strbvs	r0, [r7, #-116]	; 0xffffff8c
     720:	63535f74 	cmpvs	r3, #116, 30	; 0x1d0
     724:	5f646568 	svcpl	0x00646568
     728:	6f666e49 	svcvs	0x00666e49
     72c:	434f4900 	movtmi	r4, #63744	; 0xf900
     730:	6d006c74 	stcvs	12, cr6, [r0, #-464]	; 0xfffffe30
     734:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     738:	5200656c 	andpl	r6, r0, #108, 10	; 0x1b000000
     73c:	00646165 	rsbeq	r6, r4, r5, ror #2
     740:	6d726554 	cfldr64vs	mvdx6, [r2, #-336]!	; 0xfffffeb0
     744:	74616e69 	strbtvc	r6, [r1], #-3689	; 0xfffff197
     748:	6f4e0065 	svcvs	0x004e0065
     74c:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     750:	6f72505f 	svcvs	0x0072505f
     754:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     758:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     75c:	50433631 	subpl	r3, r3, r1, lsr r6
     760:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     764:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 5a0 <shift+0x5a0>
     768:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     76c:	34437265 	strbcc	r7, [r3], #-613	; 0xfffffd9b
     770:	6d007645 	stcvs	6, cr7, [r0, #-276]	; 0xfffffeec
     774:	61737365 	cmnvs	r3, r5, ror #6
     778:	00736567 	rsbseq	r6, r3, r7, ror #10
     77c:	61656c43 	cmnvs	r5, r3, asr #24
     780:	5a5f0072 	bpl	17c0950 <__bss_end+0x17b7218>
     784:	33314b4e 	teqcc	r1, #79872	; 0x13800
     788:	454c4f43 	strbmi	r4, [ip, #-3907]	; 0xfffff0bd
     78c:	69445f44 	stmdbvs	r4, {r2, r6, r8, r9, sl, fp, ip, lr}^
     790:	616c7073 	smcvs	50947	; 0xc703
     794:	73493979 	movtvc	r3, #39289	; 0x9979
     798:	65704f5f 	ldrbvs	r4, [r0, #-3935]!	; 0xfffff0a1
     79c:	4564656e 	strbmi	r6, [r4, #-1390]!	; 0xfffffa92
     7a0:	6f4e0076 	svcvs	0x004e0076
     7a4:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     7a8:	78614d00 	stmdavc	r1!, {r8, sl, fp, lr}^
     7ac:	68746150 	ldmdavs	r4!, {r4, r6, r8, sp, lr}^
     7b0:	676e654c 	strbvs	r6, [lr, -ip, asr #10]!
     7b4:	4d006874 	stcmi	8, cr6, [r0, #-464]	; 0xfffffe30
     7b8:	53467861 	movtpl	r7, #26721	; 0x6861
     7bc:	76697244 	strbtvc	r7, [r9], -r4, asr #4
     7c0:	614e7265 	cmpvs	lr, r5, ror #4
     7c4:	654c656d 	strbvs	r6, [ip, #-1389]	; 0xfffffa93
     7c8:	6874676e 	ldmdavs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}^
     7cc:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     7d0:	50433631 	subpl	r3, r3, r1, lsr r6
     7d4:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     7d8:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 614 <shift+0x614>
     7dc:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     7e0:	31317265 	teqcc	r1, r5, ror #4
     7e4:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     7e8:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     7ec:	4552525f 	ldrbmi	r5, [r2, #-607]	; 0xfffffda1
     7f0:	474e0076 	smlsldxmi	r0, lr, r6, r0
     7f4:	535f7465 	cmppl	pc, #1694498816	; 0x65000000
     7f8:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     7fc:	666e495f 			; <UNDEFINED> instruction: 0x666e495f
     800:	79545f6f 	ldmdbvc	r4, {r0, r1, r2, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
     804:	47006570 	smlsdxmi	r0, r0, r5, r6
     808:	5f4f4950 	svcpl	0x004f4950
     80c:	5f6e6950 	svcpl	0x006e6950
     810:	6e756f43 	cdpvs	15, 7, cr6, cr5, cr3, {2}
     814:	61740074 	cmnvs	r4, r4, ror r0
     818:	2f006b73 	svccs	0x00006b73
     81c:	2f746e6d 	svccs	0x00746e6d
     820:	73552f63 	cmpvc	r5, #396	; 0x18c
     824:	2f737265 	svccs	0x00737265
     828:	6162754b 	cmnvs	r2, fp, asr #10
     82c:	636f442f 	cmnvs	pc, #788529152	; 0x2f000000
     830:	6e656d75 	mcrvs	13, 3, r6, cr5, cr5, {3}
     834:	5a2f7374 	bpl	bdd60c <__bss_end+0xbd3ed4>
     838:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 6ac <shift+0x6ac>
     83c:	2f657461 	svccs	0x00657461
     840:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
     844:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
     848:	2d38312f 	ldfcss	f3, [r8, #-188]!	; 0xffffff44
     84c:	2f666465 	svccs	0x00666465
     850:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
     854:	63617073 	cmnvs	r1, #115	; 0x73
     858:	6c6f2f65 	stclvs	15, cr2, [pc], #-404	; 6cc <shift+0x6cc>
     85c:	745f6465 	ldrbvc	r6, [pc], #-1125	; 864 <shift+0x864>
     860:	2f6b7361 	svccs	0x006b7361
     864:	6e69616d 	powvsez	f6, f1, #5.0
     868:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
     86c:	6f6f6200 	svcvs	0x006f6200
     870:	5a5f006c 	bpl	17c0a28 <__bss_end+0x17b72f0>
     874:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     878:	636f7250 	cmnvs	pc, #80, 4
     87c:	5f737365 	svcpl	0x00737365
     880:	616e614d 	cmnvs	lr, sp, asr #2
     884:	31726567 	cmncc	r2, r7, ror #10
     888:	74654738 	strbtvc	r4, [r5], #-1848	; 0xfffff8c8
     88c:	6863535f 	stmdavs	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     890:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     894:	495f7265 	ldmdbmi	pc, {r0, r2, r5, r6, r9, ip, sp, lr}^	; <UNPREDICTABLE>
     898:	456f666e 	strbmi	r6, [pc, #-1646]!	; 232 <shift+0x232>
     89c:	474e3032 	smlaldxmi	r3, lr, r2, r0
     8a0:	535f7465 	cmppl	pc, #1694498816	; 0x65000000
     8a4:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     8a8:	666e495f 			; <UNDEFINED> instruction: 0x666e495f
     8ac:	79545f6f 	ldmdbvc	r4, {r0, r1, r2, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
     8b0:	76506570 			; <UNDEFINED> instruction: 0x76506570
     8b4:	4e525400 	cdpmi	4, 5, cr5, cr2, cr0, {0}
     8b8:	61425f47 	cmpvs	r2, r7, asr #30
     8bc:	44006573 	strmi	r6, [r0], #-1395	; 0xfffffa8d
     8c0:	75616665 	strbvc	r6, [r1, #-1637]!	; 0xfffff99b
     8c4:	435f746c 	cmpmi	pc, #108, 8	; 0x6c000000
     8c8:	6b636f6c 	blvs	18dc680 <__bss_end+0x18d2f48>
     8cc:	7461525f 	strbtvc	r5, [r1], #-607	; 0xfffffda1
     8d0:	506d0065 	rsbpl	r0, sp, r5, rrx
     8d4:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     8d8:	4c5f7373 	mrrcmi	3, 7, r7, pc, cr3	; <UNPREDICTABLE>
     8dc:	5f747369 	svcpl	0x00747369
     8e0:	64616548 	strbtvs	r6, [r1], #-1352	; 0xfffffab8
     8e4:	63536d00 	cmpvs	r3, #0, 26
     8e8:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     8ec:	465f656c 	ldrbmi	r6, [pc], -ip, ror #10
     8f0:	5f00636e 	svcpl	0x0000636e
     8f4:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     8f8:	6f725043 	svcvs	0x00725043
     8fc:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     900:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     904:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     908:	6c423132 	stfvse	f3, [r2], {50}	; 0x32
     90c:	5f6b636f 	svcpl	0x006b636f
     910:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
     914:	5f746e65 	svcpl	0x00746e65
     918:	636f7250 	cmnvs	pc, #80, 4
     91c:	45737365 	ldrbmi	r7, [r3, #-869]!	; 0xfffffc9b
     920:	6f4c0076 	svcvs	0x004c0076
     924:	555f6b63 	ldrbpl	r6, [pc, #-2915]	; fffffdc9 <__bss_end+0xffff6691>
     928:	636f6c6e 	cmnvs	pc, #28160	; 0x6e00
     92c:	0064656b 	rsbeq	r6, r4, fp, ror #10
     930:	73614c6d 	cmnvc	r1, #27904	; 0x6d00
     934:	49505f74 	ldmdbmi	r0, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     938:	77530044 	ldrbvc	r0, [r3, -r4, asr #32]
     93c:	68637469 	stmdavs	r3!, {r0, r3, r5, r6, sl, ip, sp, lr}^
     940:	006f545f 	rsbeq	r5, pc, pc, asr r4	; <UNPREDICTABLE>
     944:	736f6c43 	cmnvc	pc, #17152	; 0x4300
     948:	5a5f0065 	bpl	17c0ae4 <__bss_end+0x17b73ac>
     94c:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     950:	636f7250 	cmnvs	pc, #80, 4
     954:	5f737365 	svcpl	0x00737365
     958:	616e614d 	cmnvs	lr, sp, asr #2
     95c:	31726567 	cmncc	r2, r7, ror #10
     960:	68635332 	stmdavs	r3!, {r1, r4, r5, r8, r9, ip, lr}^
     964:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     968:	44455f65 	strbmi	r5, [r5], #-3941	; 0xfffff09b
     96c:	00764546 	rsbseq	r4, r6, r6, asr #10
     970:	30435342 	subcc	r5, r3, r2, asr #6
     974:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
     978:	72610065 	rsbvc	r0, r1, #101	; 0x65
     97c:	6e006367 	cdpvs	3, 0, cr6, cr0, cr7, {3}
     980:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     984:	5f646569 	svcpl	0x00646569
     988:	64616564 	strbtvs	r6, [r1], #-1380	; 0xfffffa9c
     98c:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
     990:	67726100 	ldrbvs	r6, [r2, -r0, lsl #2]!
     994:	69750076 	ldmdbvs	r5!, {r1, r2, r4, r5, r6}^
     998:	3631746e 	ldrtcc	r7, [r1], -lr, ror #8
     99c:	6d00745f 	cfstrsvs	mvf7, [r0, #-380]	; 0xfffffe84
     9a0:	6e65704f 	cdpvs	0, 6, cr7, cr5, cr15, {2}
     9a4:	5f006465 	svcpl	0x00006465
     9a8:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     9ac:	6f725043 	svcvs	0x00725043
     9b0:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     9b4:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     9b8:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     9bc:	6f4e3431 	svcvs	0x004e3431
     9c0:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     9c4:	6f72505f 	svcvs	0x0072505f
     9c8:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     9cc:	4e006a45 	vmlsmi.f32	s12, s0, s10
     9d0:	6c69466f 	stclvs	6, cr4, [r9], #-444	; 0xfffffe44
     9d4:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     9d8:	446d6574 	strbtmi	r6, [sp], #-1396	; 0xfffffa8c
     9dc:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
     9e0:	5a5f0072 	bpl	17c0bb0 <__bss_end+0x17b7478>
     9e4:	4333314e 	teqmi	r3, #-2147483629	; 0x80000013
     9e8:	44454c4f 	strbmi	r4, [r5], #-3151	; 0xfffff3b1
     9ec:	7369445f 	cmnvc	r9, #1593835520	; 0x5f000000
     9f0:	79616c70 	stmdbvc	r1!, {r4, r5, r6, sl, fp, sp, lr}^
     9f4:	76453444 	strbvc	r3, [r5], -r4, asr #8
     9f8:	61654400 	cmnvs	r5, r0, lsl #8
     9fc:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
     a00:	68730065 	ldmdavs	r3!, {r0, r2, r5, r6}^
     a04:	2074726f 	rsbscs	r7, r4, pc, ror #4
     a08:	00746e69 	rsbseq	r6, r4, r9, ror #28
     a0c:	4c4f437e 	mcrrmi	3, 7, r4, pc, cr14
     a10:	445f4445 	ldrbmi	r4, [pc], #-1093	; a18 <shift+0xa18>
     a14:	6c707369 	ldclvs	3, cr7, [r0], #-420	; 0xfffffe5c
     a18:	4d007961 	vstrmi.16	s14, [r0, #-194]	; 0xffffff3e	; <UNPREDICTABLE>
     a1c:	69467861 	stmdbvs	r6, {r0, r5, r6, fp, ip, sp, lr}^
     a20:	616e656c 	cmnvs	lr, ip, ror #10
     a24:	654c656d 	strbvs	r6, [ip, #-1389]	; 0xfffffa93
     a28:	6874676e 	ldmdavs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}^
     a2c:	72504300 	subsvc	r4, r0, #0, 6
     a30:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     a34:	614d5f73 	hvcvs	54771	; 0xd5f3
     a38:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     a3c:	74740072 	ldrbtvc	r0, [r4], #-114	; 0xffffff8e
     a40:	00307262 	eorseq	r7, r0, r2, ror #4
     a44:	4957534e 	ldmdbmi	r7, {r1, r2, r3, r6, r8, r9, ip, lr}^
     a48:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     a4c:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     a50:	5f6d6574 	svcpl	0x006d6574
     a54:	76726553 			; <UNDEFINED> instruction: 0x76726553
     a58:	00656369 	rsbeq	r6, r5, r9, ror #6
     a5c:	4957534e 	ldmdbmi	r7, {r1, r2, r3, r6, r8, r9, ip, lr}^
     a60:	6f72505f 	svcvs	0x0072505f
     a64:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     a68:	7265535f 	rsbvc	r5, r5, #2080374785	; 0x7c000001
     a6c:	65636976 	strbvs	r6, [r3, #-2422]!	; 0xfffff68a
     a70:	65706f00 	ldrbvs	r6, [r0, #-3840]!	; 0xfffff100
     a74:	5f64656e 	svcpl	0x0064656e
     a78:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
     a7c:	69590073 	ldmdbvs	r9, {r0, r1, r4, r5, r6}^
     a80:	00646c65 	rsbeq	r6, r4, r5, ror #24
     a84:	65646e49 	strbvs	r6, [r4, #-3657]!	; 0xfffff1b7
     a88:	696e6966 	stmdbvs	lr!, {r1, r2, r5, r6, r8, fp, sp, lr}^
     a8c:	47006574 	smlsdxmi	r0, r4, r5, r6
     a90:	505f7465 	subspl	r7, pc, r5, ror #8
     a94:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     a98:	425f7373 	subsmi	r7, pc, #-872415231	; 0xcc000001
     a9c:	49505f79 	ldmdbmi	r0, {r0, r3, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     aa0:	65500044 	ldrbvs	r0, [r0, #-68]	; 0xffffffbc
     aa4:	68706972 	ldmdavs	r0!, {r1, r4, r5, r6, r8, fp, sp, lr}^
     aa8:	6c617265 	sfmvs	f7, 2, [r1], #-404	; 0xfffffe6c
     aac:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
     ab0:	5a5f0065 	bpl	17c0c4c <__bss_end+0x17b7514>
     ab4:	4333314e 	teqmi	r3, #-2147483629	; 0x80000013
     ab8:	44454c4f 	strbmi	r4, [r5], #-3151	; 0xfffff3b1
     abc:	7369445f 	cmnvc	r9, #1593835520	; 0x5f000000
     ac0:	79616c70 	stmdbvc	r1!, {r4, r5, r6, sl, fp, sp, lr}^
     ac4:	75503031 	ldrbvc	r3, [r0, #-49]	; 0xffffffcf
     ac8:	74535f74 	ldrbvc	r5, [r3], #-3956	; 0xfffff08c
     acc:	676e6972 			; <UNDEFINED> instruction: 0x676e6972
     ad0:	50747445 	rsbspl	r7, r4, r5, asr #8
     ad4:	4600634b 	strmi	r6, [r0], -fp, asr #6
     ad8:	0070696c 	rsbseq	r6, r0, ip, ror #18
     adc:	61766e49 	cmnvs	r6, r9, asr #28
     ae0:	5f64696c 	svcpl	0x0064696c
     ae4:	006e6950 	rsbeq	r6, lr, r0, asr r9
     ae8:	6b636f4c 	blvs	18dc820 <__bss_end+0x18d30e8>
     aec:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     af0:	0064656b 	rsbeq	r6, r4, fp, ror #10
     af4:	314e5a5f 	cmpcc	lr, pc, asr sl
     af8:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     afc:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     b00:	614d5f73 	hvcvs	54771	; 0xd5f3
     b04:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     b08:	48383172 	ldmdami	r8!, {r1, r4, r5, r6, r8, ip, sp}
     b0c:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     b10:	72505f65 	subsvc	r5, r0, #404	; 0x194
     b14:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     b18:	57535f73 			; <UNDEFINED> instruction: 0x57535f73
     b1c:	30324549 	eorscc	r4, r2, r9, asr #10
     b20:	4957534e 	ldmdbmi	r7, {r1, r2, r3, r6, r8, r9, ip, lr}^
     b24:	6f72505f 	svcvs	0x0072505f
     b28:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     b2c:	7265535f 	rsbvc	r5, r5, #2080374785	; 0x7c000001
     b30:	65636976 	strbvs	r6, [r3, #-2422]!	; 0xfffff68a
     b34:	526a6a6a 	rsbpl	r6, sl, #434176	; 0x6a000
     b38:	53543131 	cmppl	r4, #1073741836	; 0x4000000c
     b3c:	525f4957 	subspl	r4, pc, #1425408	; 0x15c000
     b40:	6c757365 	ldclvs	3, cr7, [r5], #-404	; 0xfffffe6c
     b44:	65530074 	ldrbvs	r0, [r3, #-116]	; 0xffffff8c
     b48:	69505f74 	ldmdbvs	r0, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     b4c:	006c6578 	rsbeq	r6, ip, r8, ror r5
     b50:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
     b54:	6f635f64 	svcvs	0x00635f64
     b58:	65746e75 	ldrbvs	r6, [r4, #-3701]!	; 0xfffff18b
     b5c:	6e750072 	mrcvs	0, 3, r0, cr5, cr2, {3}
     b60:	6e676973 			; <UNDEFINED> instruction: 0x6e676973
     b64:	63206465 			; <UNDEFINED> instruction: 0x63206465
     b68:	00726168 	rsbseq	r6, r2, r8, ror #2
     b6c:	65746e49 	ldrbvs	r6, [r4, #-3657]!	; 0xfffff1b7
     b70:	70757272 	rsbsvc	r7, r5, r2, ror r2
     b74:	6c626174 	stfvse	f6, [r2], #-464	; 0xfffffe30
     b78:	6c535f65 	mrrcvs	15, 6, r5, r3, cr5
     b7c:	00706565 	rsbseq	r6, r0, r5, ror #10
     b80:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     b84:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     b88:	0052525f 	subseq	r5, r2, pc, asr r2
     b8c:	5f585541 	svcpl	0x00585541
     b90:	65736142 	ldrbvs	r6, [r3, #-322]!	; 0xfffffebe
     b94:	43534200 	cmpmi	r3, #0, 4
     b98:	61425f32 	cmpvs	r2, r2, lsr pc
     b9c:	73006573 	movwvc	r6, #1395	; 0x573
     ba0:	65746174 	ldrbvs	r6, [r4, #-372]!	; 0xfffffe8c
     ba4:	69725700 	ldmdbvs	r2!, {r8, r9, sl, ip, lr}^
     ba8:	4f5f6574 	svcmi	0x005f6574
     bac:	00796c6e 	rsbseq	r6, r9, lr, ror #24
     bb0:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     bb4:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     bb8:	63695400 	cmnvs	r9, #0, 8
     bbc:	6f435f6b 	svcvs	0x00435f6b
     bc0:	00746e75 	rsbseq	r6, r4, r5, ror lr
     bc4:	314e5a5f 	cmpcc	lr, pc, asr sl
     bc8:	4c4f4333 	mcrrmi	3, 3, r4, pc, cr3
     bcc:	445f4445 	ldrbmi	r4, [pc], #-1093	; bd4 <shift+0xbd4>
     bd0:	6c707369 	ldclvs	3, cr7, [r0], #-420	; 0xfffffe5c
     bd4:	53397961 	teqpl	r9, #1589248	; 0x184000
     bd8:	505f7465 	subspl	r7, pc, r5, ror #8
     bdc:	6c657869 	stclvs	8, cr7, [r5], #-420	; 0xfffffe5c
     be0:	62747445 	rsbsvs	r7, r4, #1157627904	; 0x45000000
     be4:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     be8:	50433631 	subpl	r3, r3, r1, lsr r6
     bec:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     bf0:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; a2c <shift+0xa2c>
     bf4:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     bf8:	38317265 	ldmdacc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     bfc:	616d6e55 	cmnvs	sp, r5, asr lr
     c00:	69465f70 	stmdbvs	r6, {r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     c04:	435f656c 	cmpmi	pc, #108, 10	; 0x1b000000
     c08:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     c0c:	6a45746e 	bvs	115ddcc <__bss_end+0x1154694>
     c10:	6e614800 	cdpvs	8, 6, cr4, cr1, cr0, {0}
     c14:	5f656c64 	svcpl	0x00656c64
     c18:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     c1c:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     c20:	535f6d65 	cmppl	pc, #6464	; 0x1940
     c24:	73004957 	movwvc	r4, #2391	; 0x957
     c28:	74726f68 	ldrbtvc	r6, [r2], #-3944	; 0xfffff098
     c2c:	736e7520 	cmnvc	lr, #32, 10	; 0x8000000
     c30:	656e6769 	strbvs	r6, [lr, #-1897]!	; 0xfffff897
     c34:	6e692064 	cdpvs	0, 6, cr2, cr9, cr4, {3}
     c38:	69640074 	stmdbvs	r4!, {r2, r4, r5, r6}^
     c3c:	50007073 	andpl	r7, r0, r3, ror r0
     c40:	535f7475 	cmppl	pc, #1962934272	; 0x75000000
     c44:	6e697274 	mcrvs	2, 3, r7, cr9, cr4, {3}
     c48:	6e490067 	cdpvs	0, 4, cr0, cr9, cr7, {3}
     c4c:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
     c50:	5f747075 	svcpl	0x00747075
     c54:	746e6f43 	strbtvc	r6, [lr], #-3907	; 0xfffff0bd
     c58:	6c6c6f72 	stclvs	15, cr6, [ip], #-456	; 0xfffffe38
     c5c:	425f7265 	subsmi	r7, pc, #1342177286	; 0x50000006
     c60:	00657361 	rsbeq	r7, r5, r1, ror #6
     c64:	64616552 	strbtvs	r6, [r1], #-1362	; 0xfffffaae
     c68:	6972575f 	ldmdbvs	r2!, {r0, r1, r2, r3, r4, r6, r8, r9, sl, ip, lr}^
     c6c:	41006574 	tstmi	r0, r4, ror r5
     c70:	76697463 	strbtvc	r7, [r9], -r3, ror #8
     c74:	72505f65 	subsvc	r5, r0, #404	; 0x194
     c78:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     c7c:	6f435f73 	svcvs	0x00435f73
     c80:	00746e75 	rsbseq	r6, r4, r5, ror lr
     c84:	314e5a5f 	cmpcc	lr, pc, asr sl
     c88:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     c8c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     c90:	614d5f73 	hvcvs	54771	; 0xd5f3
     c94:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     c98:	48313272 	ldmdami	r1!, {r1, r4, r5, r6, r9, ip, sp}
     c9c:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     ca0:	69465f65 	stmdbvs	r6, {r0, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     ca4:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     ca8:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     cac:	4957535f 	ldmdbmi	r7, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     cb0:	4e333245 	cdpmi	2, 3, cr3, cr3, cr5, {2}
     cb4:	5f495753 	svcpl	0x00495753
     cb8:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     cbc:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     cc0:	535f6d65 	cmppl	pc, #6464	; 0x1940
     cc4:	69767265 	ldmdbvs	r6!, {r0, r2, r5, r6, r9, ip, sp, lr}^
     cc8:	6a6a6563 	bvs	1a9a25c <__bss_end+0x1a90b24>
     ccc:	3131526a 	teqcc	r1, sl, ror #4
     cd0:	49575354 	ldmdbmi	r7, {r2, r4, r6, r8, r9, ip, lr}^
     cd4:	7365525f 	cmnvc	r5, #-268435451	; 0xf0000005
     cd8:	00746c75 	rsbseq	r6, r4, r5, ror ip
     cdc:	676e7274 			; <UNDEFINED> instruction: 0x676e7274
     ce0:	6c69665f 	stclvs	6, cr6, [r9], #-380	; 0xfffffe84
     ce4:	6c630065 	stclvs	0, cr0, [r3], #-404	; 0xfffffe6c
     ce8:	0065736f 	rsbeq	r7, r5, pc, ror #6
     cec:	5f746553 	svcpl	0x00746553
     cf0:	616c6552 	cmnvs	ip, r2, asr r5
     cf4:	65766974 	ldrbvs	r6, [r6, #-2420]!	; 0xfffff68c
     cf8:	74657200 	strbtvc	r7, [r5], #-512	; 0xfffffe00
     cfc:	006c6176 	rsbeq	r6, ip, r6, ror r1
     d00:	7275636e 	rsbsvc	r6, r5, #-1207959551	; 0xb8000001
     d04:	70697000 	rsbvc	r7, r9, r0
     d08:	64720065 	ldrbtvs	r0, [r2], #-101	; 0xffffff9b
     d0c:	006d756e 	rsbeq	r7, sp, lr, ror #10
     d10:	31315a5f 	teqcc	r1, pc, asr sl
     d14:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
     d18:	69795f64 	ldmdbvs	r9!, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     d1c:	76646c65 	strbtvc	r6, [r4], -r5, ror #24
     d20:	315a5f00 	cmpcc	sl, r0, lsl #30
     d24:	74657337 	strbtvc	r7, [r5], #-823	; 0xfffffcc9
     d28:	7361745f 	cmnvc	r1, #1593835520	; 0x5f000000
     d2c:	65645f6b 	strbvs	r5, [r4, #-3947]!	; 0xfffff095
     d30:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
     d34:	006a656e 	rsbeq	r6, sl, lr, ror #10
     d38:	74696177 	strbtvc	r6, [r9], #-375	; 0xfffffe89
     d3c:	365a5f00 	ldrbcc	r5, [sl], -r0, lsl #30
     d40:	69746f6e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
     d44:	6a6a7966 	bvs	1a9f2e4 <__bss_end+0x1a95bac>
     d48:	6e6d2f00 	cdpvs	15, 6, cr2, cr13, cr0, {0}
     d4c:	2f632f74 	svccs	0x00632f74
     d50:	72657355 	rsbvc	r7, r5, #1409286145	; 0x54000001
     d54:	754b2f73 	strbvc	r2, [fp, #-3955]	; 0xfffff08d
     d58:	442f6162 	strtmi	r6, [pc], #-354	; d60 <shift+0xd60>
     d5c:	6d75636f 	ldclvs	3, cr6, [r5, #-444]!	; 0xfffffe44
     d60:	73746e65 	cmnvc	r4, #1616	; 0x650
     d64:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
     d68:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
     d6c:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
     d70:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
     d74:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
     d78:	64652d38 	strbtvs	r2, [r5], #-3384	; 0xfffff2c8
     d7c:	74732f66 	ldrbtvc	r2, [r3], #-3942	; 0xfffff09a
     d80:	62696c64 	rsbvs	r6, r9, #100, 24	; 0x6400
     d84:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
     d88:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
     d8c:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
     d90:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
     d94:	69614600 	stmdbvs	r1!, {r9, sl, lr}^
     d98:	7865006c 	stmdavc	r5!, {r2, r3, r5, r6}^
     d9c:	6f637469 	svcvs	0x00637469
     da0:	73006564 	movwvc	r6, #1380	; 0x564
     da4:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     da8:	6569795f 	strbvs	r7, [r9, #-2399]!	; 0xfffff6a1
     dac:	7400646c 	strvc	r6, [r0], #-1132	; 0xfffffb94
     db0:	5f6b6369 	svcpl	0x006b6369
     db4:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
     db8:	65725f74 	ldrbvs	r5, [r2, #-3956]!	; 0xfffff08c
     dbc:	72697571 	rsbvc	r7, r9, #473956352	; 0x1c400000
     dc0:	5f006465 	svcpl	0x00006465
     dc4:	6734325a 			; <UNDEFINED> instruction: 0x6734325a
     dc8:	615f7465 	cmpvs	pc, r5, ror #8
     dcc:	76697463 	strbtvc	r7, [r9], -r3, ror #8
     dd0:	72705f65 	rsbsvc	r5, r0, #404	; 0x194
     dd4:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     dd8:	6f635f73 	svcvs	0x00635f73
     ddc:	76746e75 			; <UNDEFINED> instruction: 0x76746e75
     de0:	70695000 	rsbvc	r5, r9, r0
     de4:	69465f65 	stmdbvs	r6, {r0, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     de8:	505f656c 	subspl	r6, pc, ip, ror #10
     dec:	69666572 	stmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
     df0:	65530078 	ldrbvs	r0, [r3, #-120]	; 0xffffff88
     df4:	61505f74 	cmpvs	r0, r4, ror pc
     df8:	736d6172 	cmnvc	sp, #-2147483620	; 0x8000001c
     dfc:	315a5f00 	cmpcc	sl, r0, lsl #30
     e00:	74656734 	strbtvc	r6, [r5], #-1844	; 0xfffff8cc
     e04:	6369745f 	cmnvs	r9, #1593835520	; 0x5f000000
     e08:	6f635f6b 	svcvs	0x00635f6b
     e0c:	76746e75 			; <UNDEFINED> instruction: 0x76746e75
     e10:	656c7300 	strbvs	r7, [ip, #-768]!	; 0xfffffd00
     e14:	44007065 	strmi	r7, [r0], #-101	; 0xffffff9b
     e18:	62617369 	rsbvs	r7, r1, #-1543503871	; 0xa4000001
     e1c:	455f656c 	ldrbmi	r6, [pc, #-1388]	; 8b8 <shift+0x8b8>
     e20:	746e6576 	strbtvc	r6, [lr], #-1398	; 0xfffffa8a
     e24:	7465445f 	strbtvc	r4, [r5], #-1119	; 0xfffffba1
     e28:	69746365 	ldmdbvs	r4!, {r0, r2, r5, r6, r8, r9, sp, lr}^
     e2c:	5f006e6f 	svcpl	0x00006e6f
     e30:	6574395a 	ldrbvs	r3, [r4, #-2394]!	; 0xfffff6a6
     e34:	6e696d72 	mcrvs	13, 3, r6, cr9, cr2, {3}
     e38:	69657461 	stmdbvs	r5!, {r0, r5, r6, sl, ip, sp, lr}^
     e3c:	65706f00 	ldrbvs	r6, [r0, #-3840]!	; 0xfffff100
     e40:	69746172 	ldmdbvs	r4!, {r1, r4, r5, r6, r8, sp, lr}^
     e44:	5f006e6f 	svcpl	0x00006e6f
     e48:	6c63355a 	cfstr64vs	mvdx3, [r3], #-360	; 0xfffffe98
     e4c:	6a65736f 	bvs	195dc10 <__bss_end+0x19544d8>
     e50:	365a5f00 	ldrbcc	r5, [sl], -r0, lsl #30
     e54:	70746567 	rsbsvc	r6, r4, r7, ror #10
     e58:	00766469 	rsbseq	r6, r6, r9, ror #8
     e5c:	6d616e66 	stclvs	14, cr6, [r1, #-408]!	; 0xfffffe68
     e60:	4e470065 	cdpmi	0, 4, cr0, cr7, cr5, {3}
     e64:	2b432055 	blcs	10c8fc0 <__bss_end+0x10bf888>
     e68:	2034312b 	eorscs	r3, r4, fp, lsr #2
     e6c:	332e3031 			; <UNDEFINED> instruction: 0x332e3031
     e70:	3220312e 	eorcc	r3, r0, #-2147483637	; 0x8000000b
     e74:	30313230 	eorscc	r3, r1, r0, lsr r2
     e78:	20313236 	eorscs	r3, r1, r6, lsr r2
     e7c:	6c657228 	sfmvs	f7, 2, [r5], #-160	; 0xffffff60
     e80:	65736165 	ldrbvs	r6, [r3, #-357]!	; 0xfffffe9b
     e84:	6d2d2029 	stcvs	0, cr2, [sp, #-164]!	; 0xffffff5c
     e88:	616f6c66 	cmnvs	pc, r6, ror #24
     e8c:	62612d74 	rsbvs	r2, r1, #116, 26	; 0x1d00
     e90:	61683d69 	cmnvs	r8, r9, ror #26
     e94:	2d206472 	cfstrscs	mvf6, [r0, #-456]!	; 0xfffffe38
     e98:	7570666d 	ldrbvc	r6, [r0, #-1645]!	; 0xfffff993
     e9c:	7066763d 	rsbvc	r7, r6, sp, lsr r6
     ea0:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
     ea4:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
     ea8:	6962612d 	stmdbvs	r2!, {r0, r2, r3, r5, r8, sp, lr}^
     eac:	7261683d 	rsbvc	r6, r1, #3997696	; 0x3d0000
     eb0:	6d2d2064 	stcvs	0, cr2, [sp, #-400]!	; 0xfffffe70
     eb4:	3d757066 	ldclcc	0, cr7, [r5, #-408]!	; 0xfffffe68
     eb8:	20706676 	rsbscs	r6, r0, r6, ror r6
     ebc:	75746d2d 	ldrbvc	r6, [r4, #-3373]!	; 0xfffff2d3
     ec0:	613d656e 	teqvs	sp, lr, ror #10
     ec4:	31316d72 	teqcc	r1, r2, ror sp
     ec8:	7a6a3637 	bvc	1a8e7ac <__bss_end+0x1a85074>
     ecc:	20732d66 	rsbscs	r2, r3, r6, ror #26
     ed0:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
     ed4:	6d2d206d 	stcvs	0, cr2, [sp, #-436]!	; 0xfffffe4c
     ed8:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
     edc:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
     ee0:	6b7a3676 	blvs	1e8e8c0 <__bss_end+0x1e85188>
     ee4:	2070662b 	rsbscs	r6, r0, fp, lsr #12
     ee8:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
     eec:	672d2067 	strvs	r2, [sp, -r7, rrx]!
     ef0:	304f2d20 	subcc	r2, pc, r0, lsr #26
     ef4:	304f2d20 	subcc	r2, pc, r0, lsr #26
     ef8:	6e662d20 	cdpvs	13, 6, cr2, cr6, cr0, {1}
     efc:	78652d6f 	stmdavc	r5!, {r0, r1, r2, r3, r5, r6, r8, sl, fp, sp}^
     f00:	74706563 	ldrbtvc	r6, [r0], #-1379	; 0xfffffa9d
     f04:	736e6f69 	cmnvc	lr, #420	; 0x1a4
     f08:	6e662d20 	cdpvs	13, 6, cr2, cr6, cr0, {1}
     f0c:	74722d6f 	ldrbtvc	r2, [r2], #-3439	; 0xfffff291
     f10:	77006974 	smlsdxvc	r0, r4, r9, r6
     f14:	65746972 	ldrbvs	r6, [r4, #-2418]!	; 0xfffff68e
     f18:	63697400 	cmnvs	r9, #0, 8
     f1c:	6f00736b 	svcvs	0x0000736b
     f20:	006e6570 	rsbeq	r6, lr, r0, ror r5
     f24:	70345a5f 	eorsvc	r5, r4, pc, asr sl
     f28:	50657069 	rsbpl	r7, r5, r9, rrx
     f2c:	006a634b 	rsbeq	r6, sl, fp, asr #6
     f30:	6165444e 	cmnvs	r5, lr, asr #8
     f34:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
     f38:	75535f65 	ldrbvc	r5, [r3, #-3941]	; 0xfffff09b
     f3c:	72657362 	rsbvc	r7, r5, #-2013265919	; 0x88000001
     f40:	65636976 	strbvs	r6, [r3, #-2422]!	; 0xfffff68a
     f44:	74656700 	strbtvc	r6, [r5], #-1792	; 0xfffff900
     f48:	6369745f 	cmnvs	r9, #1593835520	; 0x5f000000
     f4c:	6f635f6b 	svcvs	0x00635f6b
     f50:	00746e75 	rsbseq	r6, r4, r5, ror lr
     f54:	61726170 	cmnvs	r2, r0, ror r1
     f58:	5a5f006d 	bpl	17c1114 <__bss_end+0x17b79dc>
     f5c:	69727735 	ldmdbvs	r2!, {r0, r2, r4, r5, r8, r9, sl, ip, sp, lr}^
     f60:	506a6574 	rsbpl	r6, sl, r4, ror r5
     f64:	006a634b 	rsbeq	r6, sl, fp, asr #6
     f68:	5f746567 	svcpl	0x00746567
     f6c:	6b736174 	blvs	1cd9544 <__bss_end+0x1ccfe0c>
     f70:	6369745f 	cmnvs	r9, #1593835520	; 0x5f000000
     f74:	745f736b 	ldrbvc	r7, [pc], #-875	; f7c <shift+0xf7c>
     f78:	65645f6f 	strbvs	r5, [r4, #-3951]!	; 0xfffff091
     f7c:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
     f80:	6200656e 	andvs	r6, r0, #461373440	; 0x1b800000
     f84:	735f6675 	cmpvc	pc, #122683392	; 0x7500000
     f88:	00657a69 	rsbeq	r7, r5, r9, ror #20
     f8c:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
     f90:	552f632f 	strpl	r6, [pc, #-815]!	; c69 <shift+0xc69>
     f94:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
     f98:	62754b2f 	rsbsvs	r4, r5, #48128	; 0xbc00
     f9c:	6f442f61 	svcvs	0x00442f61
     fa0:	656d7563 	strbvs	r7, [sp, #-1379]!	; 0xfffffa9d
     fa4:	2f73746e 	svccs	0x0073746e
     fa8:	6f72655a 	svcvs	0x0072655a
     fac:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
     fb0:	6178652f 	cmnvs	r8, pc, lsr #10
     fb4:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
     fb8:	38312f73 	ldmdacc	r1!, {r0, r1, r4, r5, r6, r8, r9, sl, fp, sp}
     fbc:	6664652d 	strbtvs	r6, [r4], -sp, lsr #10
     fc0:	6975622f 	ldmdbvs	r5!, {r0, r1, r2, r3, r5, r9, sp, lr}^
     fc4:	7300646c 	movwvc	r6, #1132	; 0x46c
     fc8:	745f7465 	ldrbvc	r7, [pc], #-1125	; fd0 <shift+0xfd0>
     fcc:	5f6b7361 	svcpl	0x006b7361
     fd0:	64616564 	strbtvs	r6, [r1], #-1380	; 0xfffffa9c
     fd4:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
     fd8:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     fdc:	7261505f 	rsbvc	r5, r1, #95	; 0x5f
     fe0:	00736d61 	rsbseq	r6, r3, r1, ror #26
     fe4:	73355a5f 	teqvc	r5, #389120	; 0x5f000
     fe8:	7065656c 	rsbvc	r6, r5, ip, ror #10
     fec:	47006a6a 	strmi	r6, [r0, -sl, ror #20]
     ff0:	525f7465 	subspl	r7, pc, #1694498816	; 0x65000000
     ff4:	69616d65 	stmdbvs	r1!, {r0, r2, r5, r6, r8, sl, fp, sp, lr}^
     ff8:	676e696e 	strbvs	r6, [lr, -lr, ror #18]!
     ffc:	616e4500 	cmnvs	lr, r0, lsl #10
    1000:	5f656c62 	svcpl	0x00656c62
    1004:	6e657645 	cdpvs	6, 6, cr7, cr5, cr5, {2}
    1008:	65445f74 	strbvs	r5, [r4, #-3956]	; 0xfffff08c
    100c:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
    1010:	006e6f69 	rsbeq	r6, lr, r9, ror #30
    1014:	36325a5f 			; <UNDEFINED> instruction: 0x36325a5f
    1018:	5f746567 	svcpl	0x00746567
    101c:	6b736174 	blvs	1cd95f4 <__bss_end+0x1ccfebc>
    1020:	6369745f 	cmnvs	r9, #1593835520	; 0x5f000000
    1024:	745f736b 	ldrbvc	r7, [pc], #-875	; 102c <shift+0x102c>
    1028:	65645f6f 	strbvs	r5, [r4, #-3951]!	; 0xfffff091
    102c:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
    1030:	0076656e 	rsbseq	r6, r6, lr, ror #10
    1034:	4957534e 	ldmdbmi	r7, {r1, r2, r3, r6, r8, r9, ip, lr}^
    1038:	7365525f 	cmnvc	r5, #-268435451	; 0xf0000005
    103c:	5f746c75 	svcpl	0x00746c75
    1040:	65646f43 	strbvs	r6, [r4, #-3907]!	; 0xfffff0bd
    1044:	6e727700 	cdpvs	7, 7, cr7, cr2, cr0, {0}
    1048:	5f006d75 	svcpl	0x00006d75
    104c:	6177345a 	cmnvs	r7, sl, asr r4
    1050:	6a6a7469 	bvs	1a9e1fc <__bss_end+0x1a94ac4>
    1054:	5a5f006a 	bpl	17c1204 <__bss_end+0x17b7acc>
    1058:	636f6935 	cmnvs	pc, #868352	; 0xd4000
    105c:	316a6c74 	smccc	42692	; 0xa6c4
    1060:	4f494e36 	svcmi	0x00494e36
    1064:	5f6c7443 	svcpl	0x006c7443
    1068:	7265704f 	rsbvc	r7, r5, #79	; 0x4f
    106c:	6f697461 	svcvs	0x00697461
    1070:	0076506e 	rsbseq	r5, r6, lr, rrx
    1074:	74636f69 	strbtvc	r6, [r3], #-3945	; 0xfffff097
    1078:	6572006c 	ldrbvs	r0, [r2, #-108]!	; 0xffffff94
    107c:	746e6374 	strbtvc	r6, [lr], #-884	; 0xfffffc8c
    1080:	746f6e00 	strbtvc	r6, [pc], #-3584	; 1088 <shift+0x1088>
    1084:	00796669 	rsbseq	r6, r9, r9, ror #12
    1088:	6d726574 	cfldr64vs	mvdx6, [r2, #-464]!	; 0xfffffe30
    108c:	74616e69 	strbtvc	r6, [r1], #-3689	; 0xfffff197
    1090:	6f6d0065 	svcvs	0x006d0065
    1094:	62006564 	andvs	r6, r0, #100, 10	; 0x19000000
    1098:	65666675 	strbvs	r6, [r6, #-1653]!	; 0xfffff98b
    109c:	5a5f0072 	bpl	17c126c <__bss_end+0x17b7b34>
    10a0:	61657234 	cmnvs	r5, r4, lsr r2
    10a4:	63506a64 	cmpvs	r0, #100, 20	; 0x64000
    10a8:	494e006a 	stmdbmi	lr, {r1, r3, r5, r6}^
    10ac:	6c74434f 	ldclvs	3, cr4, [r4], #-316	; 0xfffffec4
    10b0:	65704f5f 	ldrbvs	r4, [r0, #-3935]!	; 0xfffff0a1
    10b4:	69746172 	ldmdbvs	r4!, {r1, r4, r5, r6, r8, sp, lr}^
    10b8:	72006e6f 	andvc	r6, r0, #1776	; 0x6f0
    10bc:	6f637465 	svcvs	0x00637465
    10c0:	67006564 	strvs	r6, [r0, -r4, ror #10]
    10c4:	615f7465 	cmpvs	pc, r5, ror #8
    10c8:	76697463 	strbtvc	r7, [r9], -r3, ror #8
    10cc:	72705f65 	rsbsvc	r5, r0, #404	; 0x194
    10d0:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    10d4:	6f635f73 	svcvs	0x00635f73
    10d8:	00746e75 	rsbseq	r6, r4, r5, ror lr
    10dc:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
    10e0:	656d616e 	strbvs	r6, [sp, #-366]!	; 0xfffffe92
    10e4:	61657200 	cmnvs	r5, r0, lsl #4
    10e8:	65670064 	strbvs	r0, [r7, #-100]!	; 0xffffff9c
    10ec:	64697074 	strbtvs	r7, [r9], #-116	; 0xffffff8c
    10f0:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
    10f4:	6e65706f 	cdpvs	0, 6, cr7, cr5, cr15, {3}
    10f8:	31634b50 	cmncc	r3, r0, asr fp
    10fc:	69464e35 	stmdbvs	r6, {r0, r2, r4, r5, r9, sl, fp, lr}^
    1100:	4f5f656c 	svcmi	0x005f656c
    1104:	5f6e6570 	svcpl	0x006e6570
    1108:	65646f4d 	strbvs	r6, [r4, #-3917]!	; 0xfffff0b3
    110c:	706e6900 	rsbvc	r6, lr, r0, lsl #18
    1110:	64007475 	strvs	r7, [r0], #-1141	; 0xfffffb8b
    1114:	00747365 	rsbseq	r7, r4, r5, ror #6
    1118:	72657a62 	rsbvc	r7, r5, #401408	; 0x62000
    111c:	656c006f 	strbvs	r0, [ip, #-111]!	; 0xffffff91
    1120:	6874676e 	ldmdavs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}^
    1124:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
    1128:	72657a62 	rsbvc	r7, r5, #401408	; 0x62000
    112c:	6976506f 	ldmdbvs	r6!, {r0, r1, r2, r3, r5, r6, ip, lr}^
    1130:	72747300 	rsbsvc	r7, r4, #0, 6
    1134:	7970636e 	ldmdbvc	r0!, {r1, r2, r3, r5, r6, r8, r9, sp, lr}^
    1138:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
    113c:	696f7461 	stmdbvs	pc!, {r0, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    1140:	00634b50 	rsbeq	r4, r3, r0, asr fp
    1144:	72616843 	rsbvc	r6, r1, #4390912	; 0x430000
    1148:	766e6f43 	strbtvc	r6, [lr], -r3, asr #30
    114c:	00727241 	rsbseq	r7, r2, r1, asr #4
    1150:	646d656d 	strbtvs	r6, [sp], #-1389	; 0xfffffa93
    1154:	6f007473 	svcvs	0x00007473
    1158:	75707475 	ldrbvc	r7, [r0, #-1141]!	; 0xfffffb8b
    115c:	5a5f0074 	bpl	17c1334 <__bss_end+0x17b7bfc>
    1160:	6d656d36 	stclvs	13, cr6, [r5, #-216]!	; 0xffffff28
    1164:	50797063 	rsbspl	r7, r9, r3, rrx
    1168:	7650764b 	ldrbvc	r7, [r0], -fp, asr #12
    116c:	656d0069 	strbvs	r0, [sp, #-105]!	; 0xffffff97
    1170:	7970636d 	ldmdbvc	r0!, {r0, r2, r3, r5, r6, r8, r9, sp, lr}^
    1174:	72747300 	rsbsvc	r7, r4, #0, 6
    1178:	006e656c 	rsbeq	r6, lr, ip, ror #10
    117c:	73375a5f 	teqvc	r7, #389120	; 0x5f000
    1180:	636e7274 	cmnvs	lr, #116, 4	; 0x40000007
    1184:	4b50706d 	blmi	141d340 <__bss_end+0x1413c08>
    1188:	5f305363 	svcpl	0x00305363
    118c:	5a5f0069 	bpl	17c1338 <__bss_end+0x17b7c00>
    1190:	72747336 	rsbsvc	r7, r4, #-671088640	; 0xd8000000
    1194:	506e656c 	rsbpl	r6, lr, ip, ror #10
    1198:	6100634b 	tstvs	r0, fp, asr #6
    119c:	00696f74 	rsbeq	r6, r9, r4, ror pc
    11a0:	73375a5f 	teqvc	r7, #389120	; 0x5f000
    11a4:	636e7274 	cmnvs	lr, #116, 4	; 0x40000007
    11a8:	63507970 	cmpvs	r0, #112, 18	; 0x1c0000
    11ac:	69634b50 	stmdbvs	r3!, {r4, r6, r8, r9, fp, lr}^
    11b0:	72747300 	rsbsvc	r7, r4, #0, 6
    11b4:	706d636e 	rsbvc	r6, sp, lr, ror #6
    11b8:	6d656d00 	stclvs	13, cr6, [r5, #-0]
    11bc:	0079726f 	rsbseq	r7, r9, pc, ror #4
    11c0:	736d656d 	cmnvc	sp, #457179136	; 0x1b400000
    11c4:	69006372 	stmdbvs	r0, {r1, r4, r5, r6, r8, r9, sp, lr}
    11c8:	00616f74 	rsbeq	r6, r1, r4, ror pc
    11cc:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
    11d0:	552f632f 	strpl	r6, [pc, #-815]!	; ea9 <shift+0xea9>
    11d4:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
    11d8:	62754b2f 	rsbsvs	r4, r5, #48128	; 0xbc00
    11dc:	6f442f61 	svcvs	0x00442f61
    11e0:	656d7563 	strbvs	r7, [sp, #-1379]!	; 0xfffffa9d
    11e4:	2f73746e 	svccs	0x0073746e
    11e8:	6f72655a 	svcvs	0x0072655a
    11ec:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
    11f0:	6178652f 	cmnvs	r8, pc, lsr #10
    11f4:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
    11f8:	38312f73 	ldmdacc	r1!, {r0, r1, r4, r5, r6, r8, r9, sl, fp, sp}
    11fc:	6664652d 	strbtvs	r6, [r4], -sp, lsr #10
    1200:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
    1204:	2f62696c 	svccs	0x0062696c
    1208:	2f637273 	svccs	0x00637273
    120c:	73647473 	cmnvc	r4, #1929379840	; 0x73000000
    1210:	6e697274 	mcrvs	2, 3, r7, cr9, cr4, {3}
    1214:	70632e67 	rsbvc	r2, r3, r7, ror #28
    1218:	5a5f0070 	bpl	17c13e0 <__bss_end+0x17b7ca8>
    121c:	6f746934 	svcvs	0x00746934
    1220:	63506a61 	cmpvs	r0, #397312	; 0x61000
    1224:	5f5f006a 	svcpl	0x005f006a
    1228:	635f6e69 	cmpvs	pc, #1680	; 0x690
    122c:	00677268 	rsbeq	r7, r7, r8, ror #4
    1230:	73694454 	cmnvc	r9, #84, 8	; 0x54000000
    1234:	79616c70 	stmdbvc	r1!, {r4, r5, r6, sl, fp, sp, lr}^
    1238:	6361505f 	cmnvs	r1, #95	; 0x5f
    123c:	5f74656b 	svcpl	0x0074656b
    1240:	64616548 	strbtvs	r6, [r1], #-1352	; 0xfffffab8
    1244:	54007265 	strpl	r7, [r0], #-613	; 0xfffffd9b
    1248:	70736944 	rsbsvc	r6, r3, r4, asr #18
    124c:	5f79616c 	svcpl	0x0079616c
    1250:	506e6f4e 	rsbpl	r6, lr, lr, asr #30
    1254:	6d617261 	sfmvs	f7, 2, [r1, #-388]!	; 0xfffffe7c
    1258:	69727465 	ldmdbvs	r2!, {r0, r2, r5, r6, sl, ip, sp, lr}^
    125c:	61505f63 	cmpvs	r0, r3, ror #30
    1260:	74656b63 	strbtvc	r6, [r5], #-2915	; 0xfffff49d
    1264:	69687400 	stmdbvs	r8!, {sl, ip, sp, lr}^
    1268:	4c4f0073 	mcrrmi	0, 7, r0, pc, cr3
    126c:	465f4445 	ldrbmi	r4, [pc], -r5, asr #8
    1270:	5f746e6f 	svcpl	0x00746e6f
    1274:	61666544 	cmnvs	r6, r4, asr #10
    1278:	00746c75 	rsbseq	r6, r4, r5, ror ip
    127c:	696c6676 	stmdbvs	ip!, {r1, r2, r4, r5, r6, r9, sl, sp, lr}^
    1280:	6d2f0070 	stcvs	0, cr0, [pc, #-448]!	; 10c8 <shift+0x10c8>
    1284:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
    1288:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
    128c:	4b2f7372 	blmi	bde05c <__bss_end+0xbd4924>
    1290:	2f616275 	svccs	0x00616275
    1294:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
    1298:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
    129c:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
    12a0:	614d6f72 	hvcvs	55026	; 0xd6f2
    12a4:	652f6574 	strvs	r6, [pc, #-1396]!	; d38 <shift+0xd38>
    12a8:	706d6178 	rsbvc	r6, sp, r8, ror r1
    12ac:	2f73656c 	svccs	0x0073656c
    12b0:	652d3831 	strvs	r3, [sp, #-2097]!	; 0xfffff7cf
    12b4:	732f6664 			; <UNDEFINED> instruction: 0x732f6664
    12b8:	74756474 	ldrbtvc	r6, [r5], #-1140	; 0xfffffb8c
    12bc:	2f736c69 	svccs	0x00736c69
    12c0:	2f637273 	svccs	0x00637273
    12c4:	64656c6f 	strbtvs	r6, [r5], #-3183	; 0xfffff391
    12c8:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
    12cc:	69445400 	stmdbvs	r4, {sl, ip, lr}^
    12d0:	616c7073 	smcvs	50947	; 0xc703
    12d4:	72445f79 	subvc	r5, r4, #484	; 0x1e4
    12d8:	505f7761 	subspl	r7, pc, r1, ror #14
    12dc:	6c657869 	stclvs	8, cr7, [r5], #-420	; 0xfffffe5c
    12e0:	7272415f 	rsbsvc	r4, r2, #-1073741801	; 0xc0000017
    12e4:	505f7961 	subspl	r7, pc, r1, ror #18
    12e8:	656b6361 	strbvs	r6, [fp, #-865]!	; 0xfffffc9f
    12ec:	72440074 	subvc	r0, r4, #116	; 0x74
    12f0:	505f7761 	subspl	r7, pc, r1, ror #14
    12f4:	6c657869 	stclvs	8, cr7, [r5], #-420	; 0xfffffe5c
    12f8:	7272415f 	rsbsvc	r4, r2, #-1073741801	; 0xc0000017
    12fc:	545f7961 	ldrbpl	r7, [pc], #-2401	; 1304 <shift+0x1304>
    1300:	65525f6f 	ldrbvs	r5, [r2, #-3951]	; 0xfffff091
    1304:	54007463 	strpl	r7, [r0], #-1123	; 0xfffffb9d
    1308:	70736944 	rsbsvc	r6, r3, r4, asr #18
    130c:	5f79616c 	svcpl	0x0079616c
    1310:	65786950 	ldrbvs	r6, [r8, #-2384]!	; 0xfffff6b0
    1314:	70535f6c 	subsvc	r5, r3, ip, ror #30
    1318:	70006365 	andvc	r6, r0, r5, ror #6
    131c:	00687461 	rsbeq	r7, r8, r1, ror #8
    1320:	73694454 	cmnvc	r9, #84, 8	; 0x54000000
    1324:	79616c70 	stmdbvc	r1!, {r4, r5, r6, sl, fp, sp, lr}^
    1328:	7869505f 	stmdavc	r9!, {r0, r1, r2, r3, r4, r6, ip, lr}^
    132c:	5f736c65 	svcpl	0x00736c65
    1330:	525f6f54 	subspl	r6, pc, #84, 30	; 0x150
    1334:	00746365 	rsbseq	r6, r4, r5, ror #6
    1338:	72616843 	rsbvc	r6, r1, #4390912	; 0x430000
    133c:	646e455f 	strbtvs	r4, [lr], #-1375	; 0xfffffaa1
    1340:	61724400 	cmnvs	r2, r0, lsl #8
    1344:	69505f77 	ldmdbvs	r0, {r0, r1, r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    1348:	5f6c6578 	svcpl	0x006c6578
    134c:	61727241 	cmnvs	r2, r1, asr #4
    1350:	6c460079 	mcrrvs	0, 7, r0, r6, cr9
    1354:	435f7069 	cmpmi	pc, #105	; 0x69
    1358:	73726168 	cmnvc	r2, #104, 2
    135c:	69445400 	stmdbvs	r4, {sl, ip, lr}^
    1360:	616c7073 	smcvs	50947	; 0xc703
    1364:	6c435f79 	mcrrvs	15, 7, r5, r3, cr9
    1368:	5f726165 	svcpl	0x00726165
    136c:	6b636150 	blvs	18d98b4 <__bss_end+0x18d017c>
    1370:	43007465 	movwmi	r7, #1125	; 0x465
    1374:	5f726168 	svcpl	0x00726168
    1378:	74646957 	strbtvc	r6, [r4], #-2391	; 0xfffff6a9
    137c:	4c4f0068 	mcrrmi	0, 6, r0, pc, cr8
    1380:	465f4445 	ldrbmi	r4, [pc], -r5, asr #8
    1384:	00746e6f 	rsbseq	r6, r4, pc, ror #28
    1388:	7369444e 	cmnvc	r9, #1308622848	; 0x4e000000
    138c:	79616c70 	stmdbvc	r1!, {r4, r5, r6, sl, fp, sp, lr}^
    1390:	6d6f435f 	stclvs	3, cr4, [pc, #-380]!	; 121c <shift+0x121c>
    1394:	646e616d 	strbtvs	r6, [lr], #-365	; 0xfffffe93
    1398:	72696600 	rsbvc	r6, r9, #0, 12
    139c:	63007473 	movwvs	r7, #1139	; 0x473
    13a0:	7261656c 	rsbvc	r6, r1, #108, 10	; 0x1b000000
    13a4:	00746553 	rsbseq	r6, r4, r3, asr r5
    13a8:	314e5a5f 	cmpcc	lr, pc, asr sl
    13ac:	4c4f4333 	mcrrmi	3, 3, r4, pc, cr3
    13b0:	445f4445 	ldrbmi	r4, [pc], #-1093	; 13b8 <shift+0x13b8>
    13b4:	6c707369 	ldclvs	3, cr7, [r0], #-420	; 0xfffffe5c
    13b8:	32437961 	subcc	r7, r3, #1589248	; 0x184000
    13bc:	634b5045 	movtvs	r5, #45125	; 0xb045
    13c0:	6e697500 	cdpvs	5, 6, cr7, cr9, cr0, {0}
    13c4:	745f3874 	ldrbvc	r3, [pc], #-2164	; 13cc <shift+0x13cc>
    13c8:	61684300 	cmnvs	r8, r0, lsl #6
    13cc:	65485f72 	strbvs	r5, [r8, #-3954]	; 0xfffff08e
    13d0:	74686769 	strbtvc	r6, [r8], #-1897	; 0xfffff897
    13d4:	61656800 	cmnvs	r5, r0, lsl #16
    13d8:	00726564 	rsbseq	r6, r2, r4, ror #10
    13dc:	72616843 	rsbvc	r6, r1, #4390912	; 0x430000
    13e0:	6765425f 			; <UNDEFINED> instruction: 0x6765425f
    13e4:	5f006e69 	svcpl	0x00006e69
    13e8:	33314e5a 	teqcc	r1, #1440	; 0x5a0
    13ec:	454c4f43 	strbmi	r4, [ip, #-3907]	; 0xfffff0bd
    13f0:	69445f44 	stmdbvs	r4, {r2, r6, r8, r9, sl, fp, ip, lr}^
    13f4:	616c7073 	smcvs	50947	; 0xc703
    13f8:	45324479 	ldrmi	r4, [r2, #-1145]!	; 0xfffffb87
    13fc:	2e2e0076 	mcrcs	0, 1, r0, cr14, cr6, {3}
    1400:	2f2e2e2f 	svccs	0x002e2e2f
    1404:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1408:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    140c:	2f2e2e2f 	svccs	0x002e2e2f
    1410:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    1414:	632f6363 			; <UNDEFINED> instruction: 0x632f6363
    1418:	69666e6f 	stmdbvs	r6!, {r0, r1, r2, r3, r5, r6, r9, sl, fp, sp, lr}^
    141c:	72612f67 	rsbvc	r2, r1, #412	; 0x19c
    1420:	696c2f6d 	stmdbvs	ip!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp}^
    1424:	75663162 	strbvc	r3, [r6, #-354]!	; 0xfffffe9e
    1428:	2e73636e 	cdpcs	3, 7, cr6, cr3, cr14, {3}
    142c:	622f0053 	eorvs	r0, pc, #83	; 0x53
    1430:	646c6975 	strbtvs	r6, [ip], #-2421	; 0xfffff68b
    1434:	6363672f 	cmnvs	r3, #12320768	; 0xbc0000
    1438:	6d72612d 	ldfvse	f6, [r2, #-180]!	; 0xffffff4c
    143c:	6e6f6e2d 	cdpvs	14, 6, cr6, cr15, cr13, {1}
    1440:	61652d65 	cmnvs	r5, r5, ror #26
    1444:	682d6962 	stmdavs	sp!, {r1, r5, r6, r8, fp, sp, lr}
    1448:	4b676659 	blmi	19dadb4 <__bss_end+0x19d167c>
    144c:	63672f34 	cmnvs	r7, #52, 30	; 0xd0
    1450:	72612d63 	rsbvc	r2, r1, #6336	; 0x18c0
    1454:	6f6e2d6d 	svcvs	0x006e2d6d
    1458:	652d656e 	strvs	r6, [sp, #-1390]!	; 0xfffffa92
    145c:	2d696261 	sfmcs	f6, 2, [r9, #-388]!	; 0xfffffe7c
    1460:	332e3031 			; <UNDEFINED> instruction: 0x332e3031
    1464:	3230322d 	eorscc	r3, r0, #-805306366	; 0xd0000002
    1468:	37302e31 			; <UNDEFINED> instruction: 0x37302e31
    146c:	6975622f 	ldmdbvs	r5!, {r0, r1, r2, r3, r5, r9, sp, lr}^
    1470:	612f646c 			; <UNDEFINED> instruction: 0x612f646c
    1474:	6e2d6d72 	mcrvs	13, 1, r6, cr13, cr2, {3}
    1478:	2d656e6f 	stclcs	14, cr6, [r5, #-444]!	; 0xfffffe44
    147c:	69626165 	stmdbvs	r2!, {r0, r2, r5, r6, r8, sp, lr}^
    1480:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
    1484:	7435762f 	ldrtvc	r7, [r5], #-1583	; 0xfffff9d1
    1488:	61682f65 	cmnvs	r8, r5, ror #30
    148c:	6c2f6472 	cfstrsvs	mvf6, [pc], #-456	; 12cc <shift+0x12cc>
    1490:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1494:	4e470063 	cdpmi	0, 4, cr0, cr7, cr3, {3}
    1498:	53412055 	movtpl	r2, #4181	; 0x1055
    149c:	332e3220 			; <UNDEFINED> instruction: 0x332e3220
    14a0:	73690037 	cmnvc	r9, #55	; 0x37
    14a4:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    14a8:	72705f74 	rsbsvc	r5, r0, #116, 30	; 0x1d0
    14ac:	65726465 	ldrbvs	r6, [r2, #-1125]!	; 0xfffffb9b
    14b0:	73690073 	cmnvc	r9, #115	; 0x73
    14b4:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    14b8:	66765f74 	uhsub16vs	r5, r6, r4
    14bc:	61625f70 	smcvs	9712	; 0x25f0
    14c0:	63006573 	movwvs	r6, #1395	; 0x573
    14c4:	6c706d6f 	ldclvs	13, cr6, [r0], #-444	; 0xfffffe44
    14c8:	66207865 	strtvs	r7, [r0], -r5, ror #16
    14cc:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
    14d0:	61736900 	cmnvs	r3, r0, lsl #18
    14d4:	626f6e5f 	rsbvs	r6, pc, #1520	; 0x5f0
    14d8:	69007469 	stmdbvs	r0, {r0, r3, r5, r6, sl, ip, sp, lr}
    14dc:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    14e0:	6d5f7469 	cfldrdvs	mvd7, [pc, #-420]	; 1344 <shift+0x1344>
    14e4:	665f6576 			; <UNDEFINED> instruction: 0x665f6576
    14e8:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
    14ec:	61736900 	cmnvs	r3, r0, lsl #18
    14f0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    14f4:	3170665f 	cmncc	r0, pc, asr r6
    14f8:	73690036 	cmnvc	r9, #54	; 0x36
    14fc:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1500:	65735f74 	ldrbvs	r5, [r3, #-3956]!	; 0xfffff08c
    1504:	73690063 	cmnvc	r9, #99	; 0x63
    1508:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    150c:	64615f74 	strbtvs	r5, [r1], #-3956	; 0xfffff08c
    1510:	69007669 	stmdbvs	r0, {r0, r3, r5, r6, r9, sl, ip, sp, lr}
    1514:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1518:	715f7469 	cmpvc	pc, r9, ror #8
    151c:	6b726975 	blvs	1c9baf8 <__bss_end+0x1c923c0>
    1520:	5f6f6e5f 	svcpl	0x006f6e5f
    1524:	616c6f76 	smcvs	50934	; 0xc6f6
    1528:	656c6974 	strbvs	r6, [ip, #-2420]!	; 0xfffff68c
    152c:	0065635f 	rsbeq	r6, r5, pc, asr r3
    1530:	5f617369 	svcpl	0x00617369
    1534:	5f746962 	svcpl	0x00746962
    1538:	6900706d 	stmdbvs	r0, {r0, r2, r3, r5, r6, ip, sp, lr}
    153c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1540:	615f7469 	cmpvs	pc, r9, ror #8
    1544:	35766d72 	ldrbcc	r6, [r6, #-3442]!	; 0xfffff28e
    1548:	73690074 	cmnvc	r9, #116	; 0x74
    154c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1550:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1554:	7435766d 	ldrtvc	r7, [r5], #-1645	; 0xfffff993
    1558:	73690065 	cmnvc	r9, #101	; 0x65
    155c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1560:	656e5f74 	strbvs	r5, [lr, #-3956]!	; 0xfffff08c
    1564:	69006e6f 	stmdbvs	r0, {r0, r1, r2, r3, r5, r6, r9, sl, fp, sp, lr}
    1568:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    156c:	625f7469 	subsvs	r7, pc, #1761607680	; 0x69000000
    1570:	00363166 	eorseq	r3, r6, r6, ror #2
    1574:	43535046 	cmpmi	r3, #70	; 0x46
    1578:	4e455f52 	mcrmi	15, 2, r5, cr5, cr2, {2}
    157c:	46004d55 			; <UNDEFINED> instruction: 0x46004d55
    1580:	52435350 	subpl	r5, r3, #80, 6	; 0x40000001
    1584:	637a6e5f 	cmnvs	sl, #1520	; 0x5f0
    1588:	5f637176 	svcpl	0x00637176
    158c:	4d554e45 	ldclmi	14, cr4, [r5, #-276]	; 0xfffffeec
    1590:	52505600 	subspl	r5, r0, #0, 12
    1594:	554e455f 	strbpl	r4, [lr, #-1375]	; 0xfffffaa1
    1598:	6266004d 	rsbvs	r0, r6, #77	; 0x4d
    159c:	695f7469 	ldmdbvs	pc, {r0, r3, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    15a0:	696c706d 	stmdbvs	ip!, {r0, r2, r3, r5, r6, ip, sp, lr}^
    15a4:	69746163 	ldmdbvs	r4!, {r0, r1, r5, r6, r8, sp, lr}^
    15a8:	50006e6f 	andpl	r6, r0, pc, ror #28
    15ac:	4e455f30 	mcrmi	15, 2, r5, cr5, cr0, {1}
    15b0:	69004d55 	stmdbvs	r0, {r0, r2, r4, r6, r8, sl, fp, lr}
    15b4:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    15b8:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    15bc:	74707972 	ldrbtvc	r7, [r0], #-2418	; 0xfffff68e
    15c0:	4e47006f 	cdpmi	0, 4, cr0, cr7, cr15, {3}
    15c4:	31432055 	qdaddcc	r2, r5, r3
    15c8:	30312037 	eorscc	r2, r1, r7, lsr r0
    15cc:	312e332e 			; <UNDEFINED> instruction: 0x312e332e
    15d0:	32303220 	eorscc	r3, r0, #32, 4
    15d4:	32363031 	eorscc	r3, r6, #49	; 0x31
    15d8:	72282031 	eorvc	r2, r8, #49	; 0x31
    15dc:	61656c65 	cmnvs	r5, r5, ror #24
    15e0:	20296573 	eorcs	r6, r9, r3, ror r5
    15e4:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
    15e8:	6d2d206d 	stcvs	0, cr2, [sp, #-436]!	; 0xfffffe4c
    15ec:	616f6c66 	cmnvs	pc, r6, ror #24
    15f0:	62612d74 	rsbvs	r2, r1, #116, 26	; 0x1d00
    15f4:	61683d69 	cmnvs	r8, r9, ror #26
    15f8:	2d206472 	cfstrscs	mvf6, [r0, #-456]!	; 0xfffffe38
    15fc:	6372616d 	cmnvs	r2, #1073741851	; 0x4000001b
    1600:	72613d68 	rsbvc	r3, r1, #104, 26	; 0x1a00
    1604:	7435766d 	ldrtvc	r7, [r5], #-1645	; 0xfffff993
    1608:	70662b65 	rsbvc	r2, r6, r5, ror #22
    160c:	20672d20 	rsbcs	r2, r7, r0, lsr #26
    1610:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
    1614:	4f2d2067 	svcmi	0x002d2067
    1618:	4f2d2032 	svcmi	0x002d2032
    161c:	4f2d2032 	svcmi	0x002d2032
    1620:	662d2032 			; <UNDEFINED> instruction: 0x662d2032
    1624:	6c697562 	cfstr64vs	mvdx7, [r9], #-392	; 0xfffffe78
    1628:	676e6964 	strbvs	r6, [lr, -r4, ror #18]!
    162c:	62696c2d 	rsbvs	r6, r9, #11520	; 0x2d00
    1630:	20636367 	rsbcs	r6, r3, r7, ror #6
    1634:	6f6e662d 	svcvs	0x006e662d
    1638:	6174732d 	cmnvs	r4, sp, lsr #6
    163c:	702d6b63 	eorvc	r6, sp, r3, ror #22
    1640:	65746f72 	ldrbvs	r6, [r4, #-3954]!	; 0xfffff08e
    1644:	726f7463 	rsbvc	r7, pc, #1660944384	; 0x63000000
    1648:	6e662d20 	cdpvs	13, 6, cr2, cr6, cr0, {1}
    164c:	6e692d6f 	cdpvs	13, 6, cr2, cr9, cr15, {3}
    1650:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
    1654:	76662d20 	strbtvc	r2, [r6], -r0, lsr #26
    1658:	62697369 	rsbvs	r7, r9, #-1543503871	; 0xa4000001
    165c:	74696c69 	strbtvc	r6, [r9], #-3177	; 0xfffff397
    1660:	69683d79 	stmdbvs	r8!, {r0, r3, r4, r5, r6, r8, sl, fp, ip, sp}^
    1664:	6e656464 	cdpvs	4, 6, cr6, cr5, cr4, {3}
    1668:	61736900 	cmnvs	r3, r0, lsl #18
    166c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1670:	6964745f 	stmdbvs	r4!, {r0, r1, r2, r3, r4, r6, sl, ip, sp, lr}^
    1674:	6f630076 	svcvs	0x00630076
    1678:	6900736e 	stmdbvs	r0, {r1, r2, r3, r5, r6, r8, r9, ip, sp, lr}
    167c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1680:	695f7469 	ldmdbvs	pc, {r0, r3, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    1684:	786d6d77 	stmdavc	sp!, {r0, r1, r2, r4, r5, r6, r8, sl, fp, sp, lr}^
    1688:	50460074 	subpl	r0, r6, r4, ror r0
    168c:	53545843 	cmppl	r4, #4390912	; 0x430000
    1690:	554e455f 	strbpl	r4, [lr, #-1375]	; 0xfffffaa1
    1694:	7369004d 	cmnvc	r9, #77	; 0x4d
    1698:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    169c:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    16a0:	0036766d 	eorseq	r7, r6, sp, ror #12
    16a4:	5f617369 	svcpl	0x00617369
    16a8:	5f746962 	svcpl	0x00746962
    16ac:	0065766d 	rsbeq	r7, r5, sp, ror #12
    16b0:	5f617369 	svcpl	0x00617369
    16b4:	5f746962 	svcpl	0x00746962
    16b8:	6d6d7769 	stclvs	7, cr7, [sp, #-420]!	; 0xfffffe5c
    16bc:	00327478 	eorseq	r7, r2, r8, ror r4
    16c0:	5f617369 	svcpl	0x00617369
    16c4:	5f746962 	svcpl	0x00746962
    16c8:	63656463 	cmnvs	r5, #1660944384	; 0x63000000
    16cc:	69003070 	stmdbvs	r0, {r4, r5, r6, ip, sp}
    16d0:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    16d4:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    16d8:	70636564 	rsbvc	r6, r3, r4, ror #10
    16dc:	73690031 	cmnvc	r9, #49	; 0x31
    16e0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    16e4:	64635f74 	strbtvs	r5, [r3], #-3956	; 0xfffff08c
    16e8:	32706365 	rsbscc	r6, r0, #-1811939327	; 0x94000001
    16ec:	61736900 	cmnvs	r3, r0, lsl #18
    16f0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    16f4:	6564635f 	strbvs	r6, [r4, #-863]!	; 0xfffffca1
    16f8:	00337063 	eorseq	r7, r3, r3, rrx
    16fc:	5f617369 	svcpl	0x00617369
    1700:	5f746962 	svcpl	0x00746962
    1704:	63656463 	cmnvs	r5, #1660944384	; 0x63000000
    1708:	69003470 	stmdbvs	r0, {r4, r5, r6, sl, ip, sp}
    170c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1710:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    1714:	62645f70 	rsbvs	r5, r4, #112, 30	; 0x1c0
    1718:	7369006c 	cmnvc	r9, #108	; 0x6c
    171c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1720:	64635f74 	strbtvs	r5, [r3], #-3956	; 0xfffff08c
    1724:	36706365 	ldrbtcc	r6, [r0], -r5, ror #6
    1728:	61736900 	cmnvs	r3, r0, lsl #18
    172c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1730:	6564635f 	strbvs	r6, [r4, #-863]!	; 0xfffffca1
    1734:	00377063 	eorseq	r7, r7, r3, rrx
    1738:	5f617369 	svcpl	0x00617369
    173c:	5f746962 	svcpl	0x00746962
    1740:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1744:	69006b36 	stmdbvs	r0, {r1, r2, r4, r5, r8, r9, fp, sp, lr}
    1748:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    174c:	615f7469 	cmpvs	pc, r9, ror #8
    1750:	38766d72 	ldmdacc	r6!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^
    1754:	5f6d315f 	svcpl	0x006d315f
    1758:	6e69616d 	powvsez	f6, f1, #5.0
    175c:	746e6100 	strbtvc	r6, [lr], #-256	; 0xffffff00
    1760:	73690065 	cmnvc	r9, #101	; 0x65
    1764:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1768:	6d635f74 	stclvs	15, cr5, [r3, #-464]!	; 0xfffffe30
    176c:	6c006573 	cfstr32vs	mvfx6, [r0], {115}	; 0x73
    1770:	20676e6f 	rsbcs	r6, r7, pc, ror #28
    1774:	62756f64 	rsbsvs	r6, r5, #100, 30	; 0x190
    1778:	2e00656c 	cfsh32cs	mvfx6, mvfx0, #60
    177c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1780:	2f2e2e2f 	svccs	0x002e2e2f
    1784:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1788:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    178c:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    1790:	2f636367 	svccs	0x00636367
    1794:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    1798:	2e326363 	cdpcs	3, 3, cr6, cr2, cr3, {3}
    179c:	73690063 	cmnvc	r9, #99	; 0x63
    17a0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    17a4:	70665f74 	rsbvc	r5, r6, r4, ror pc
    17a8:	69003576 	stmdbvs	r0, {r1, r2, r4, r5, r6, r8, sl, ip, sp}
    17ac:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    17b0:	785f7469 	ldmdavc	pc, {r0, r3, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    17b4:	6c616373 	stclvs	3, cr6, [r1], #-460	; 0xfffffe34
    17b8:	6f6c0065 	svcvs	0x006c0065
    17bc:	6c20676e 	stcvs	7, cr6, [r0], #-440	; 0xfffffe48
    17c0:	20676e6f 	rsbcs	r6, r7, pc, ror #28
    17c4:	69736e75 	ldmdbvs	r3!, {r0, r2, r4, r5, r6, r9, sl, fp, sp, lr}^
    17c8:	64656e67 	strbtvs	r6, [r5], #-3687	; 0xfffff199
    17cc:	746e6920 	strbtvc	r6, [lr], #-2336	; 0xfffff6e0
    17d0:	61736900 	cmnvs	r3, r0, lsl #18
    17d4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    17d8:	6975715f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, r8, ip, sp, lr}^
    17dc:	635f6b72 	cmpvs	pc, #116736	; 0x1c800
    17e0:	6c5f336d 	mrrcvs	3, 6, r3, pc, cr13	; <UNPREDICTABLE>
    17e4:	00647264 	rsbeq	r7, r4, r4, ror #4
    17e8:	5f617369 	svcpl	0x00617369
    17ec:	5f746962 	svcpl	0x00746962
    17f0:	6d6d3869 	stclvs	8, cr3, [sp, #-420]!	; 0xfffffe5c
    17f4:	61736900 	cmnvs	r3, r0, lsl #18
    17f8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    17fc:	5f70665f 	svcpl	0x0070665f
    1800:	00323364 	eorseq	r3, r2, r4, ror #6
    1804:	5f617369 	svcpl	0x00617369
    1808:	5f746962 	svcpl	0x00746962
    180c:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1810:	006d6537 	rsbeq	r6, sp, r7, lsr r5
    1814:	5f617369 	svcpl	0x00617369
    1818:	5f746962 	svcpl	0x00746962
    181c:	6561706c 	strbvs	r7, [r1, #-108]!	; 0xffffff94
    1820:	6c6c6100 	stfvse	f6, [ip], #-0
    1824:	706d695f 	rsbvc	r6, sp, pc, asr r9
    1828:	6465696c 	strbtvs	r6, [r5], #-2412	; 0xfffff694
    182c:	6962665f 	stmdbvs	r2!, {r0, r1, r2, r3, r4, r6, r9, sl, sp, lr}^
    1830:	69007374 	stmdbvs	r0, {r2, r4, r5, r6, r8, r9, ip, sp, lr}
    1834:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1838:	615f7469 	cmpvs	pc, r9, ror #8
    183c:	38766d72 	ldmdacc	r6!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^
    1840:	6900315f 	stmdbvs	r0, {r0, r1, r2, r3, r4, r6, r8, ip, sp}
    1844:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1848:	615f7469 	cmpvs	pc, r9, ror #8
    184c:	38766d72 	ldmdacc	r6!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^
    1850:	6900325f 	stmdbvs	r0, {r0, r1, r2, r3, r4, r6, r9, ip, sp}
    1854:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1858:	615f7469 	cmpvs	pc, r9, ror #8
    185c:	38766d72 	ldmdacc	r6!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^
    1860:	6900335f 	stmdbvs	r0, {r0, r1, r2, r3, r4, r6, r8, r9, ip, sp}
    1864:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1868:	615f7469 	cmpvs	pc, r9, ror #8
    186c:	38766d72 	ldmdacc	r6!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^
    1870:	6900345f 	stmdbvs	r0, {r0, r1, r2, r3, r4, r6, sl, ip, sp}
    1874:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1878:	615f7469 	cmpvs	pc, r9, ror #8
    187c:	38766d72 	ldmdacc	r6!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^
    1880:	6900355f 	stmdbvs	r0, {r0, r1, r2, r3, r4, r6, r8, sl, ip, sp}
    1884:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1888:	615f7469 	cmpvs	pc, r9, ror #8
    188c:	38766d72 	ldmdacc	r6!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^
    1890:	6900365f 	stmdbvs	r0, {r0, r1, r2, r3, r4, r6, r9, sl, ip, sp}
    1894:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1898:	735f7469 	cmpvc	pc, #1761607680	; 0x69000000
    189c:	73690062 	cmnvc	r9, #98	; 0x62
    18a0:	756e5f61 	strbvc	r5, [lr, #-3937]!	; 0xfffff09f
    18a4:	69625f6d 	stmdbvs	r2!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
    18a8:	69007374 	stmdbvs	r0, {r2, r4, r5, r6, r8, r9, ip, sp, lr}
    18ac:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    18b0:	735f7469 	cmpvc	pc, #1761607680	; 0x69000000
    18b4:	6c6c616d 	stfvse	f6, [ip], #-436	; 0xfffffe4c
    18b8:	006c756d 	rsbeq	r7, ip, sp, ror #10
    18bc:	636e7566 	cmnvs	lr, #427819008	; 0x19800000
    18c0:	7274705f 	rsbsvc	r7, r4, #95	; 0x5f
    18c4:	6d6f6300 	stclvs	3, cr6, [pc, #-0]	; 18cc <shift+0x18cc>
    18c8:	78656c70 	stmdavc	r5!, {r4, r5, r6, sl, fp, sp, lr}^
    18cc:	756f6420 	strbvc	r6, [pc, #-1056]!	; 14b4 <shift+0x14b4>
    18d0:	00656c62 	rsbeq	r6, r5, r2, ror #24
    18d4:	465f424e 	ldrbmi	r4, [pc], -lr, asr #4
    18d8:	59535f50 	ldmdbpl	r3, {r4, r6, r8, r9, sl, fp, ip, lr}^
    18dc:	47455253 	smlsldmi	r5, r5, r3, r2	; <UNPREDICTABLE>
    18e0:	73690053 	cmnvc	r9, #83	; 0x53
    18e4:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    18e8:	64635f74 	strbtvs	r5, [r3], #-3956	; 0xfffff08c
    18ec:	35706365 	ldrbcc	r6, [r0, #-869]!	; 0xfffffc9b
    18f0:	61736900 	cmnvs	r3, r0, lsl #18
    18f4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    18f8:	7066765f 	rsbvc	r7, r6, pc, asr r6
    18fc:	69003276 	stmdbvs	r0, {r1, r2, r4, r5, r6, r9, ip, sp}
    1900:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1904:	765f7469 	ldrbvc	r7, [pc], -r9, ror #8
    1908:	33767066 	cmncc	r6, #102	; 0x66
    190c:	61736900 	cmnvs	r3, r0, lsl #18
    1910:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1914:	7066765f 	rsbvc	r7, r6, pc, asr r6
    1918:	46003476 			; <UNDEFINED> instruction: 0x46003476
    191c:	54584350 	ldrbpl	r4, [r8], #-848	; 0xfffffcb0
    1920:	455f534e 	ldrbmi	r5, [pc, #-846]	; 15da <shift+0x15da>
    1924:	004d554e 	subeq	r5, sp, lr, asr #10
    1928:	5f617369 	svcpl	0x00617369
    192c:	5f746962 	svcpl	0x00746962
    1930:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    1934:	73690062 	cmnvc	r9, #98	; 0x62
    1938:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    193c:	70665f74 	rsbvc	r5, r6, r4, ror pc
    1940:	6f633631 	svcvs	0x00633631
    1944:	6900766e 	stmdbvs	r0, {r1, r2, r3, r5, r6, r9, sl, ip, sp, lr}
    1948:	665f6173 			; <UNDEFINED> instruction: 0x665f6173
    194c:	75746165 	ldrbvc	r6, [r4, #-357]!	; 0xfffffe9b
    1950:	69006572 	stmdbvs	r0, {r1, r4, r5, r6, r8, sl, sp, lr}
    1954:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1958:	6e5f7469 	cdpvs	4, 5, cr7, cr15, cr9, {3}
    195c:	006d746f 	rsbeq	r7, sp, pc, ror #8
    1960:	5f617369 	svcpl	0x00617369
    1964:	5f746962 	svcpl	0x00746962
    1968:	72697571 	rsbvc	r7, r9, #473956352	; 0x1c400000
    196c:	72615f6b 	rsbvc	r5, r1, #428	; 0x1ac
    1970:	6b36766d 	blvs	d9f32c <__bss_end+0xd95bf4>
    1974:	7369007a 	cmnvc	r9, #122	; 0x7a
    1978:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    197c:	72635f74 	rsbvc	r5, r3, #116, 30	; 0x1d0
    1980:	00323363 	eorseq	r3, r2, r3, ror #6
    1984:	5f617369 	svcpl	0x00617369
    1988:	5f746962 	svcpl	0x00746962
    198c:	72697571 	rsbvc	r7, r9, #473956352	; 0x1c400000
    1990:	6f6e5f6b 	svcvs	0x006e5f6b
    1994:	6d73615f 	ldfvse	f6, [r3, #-380]!	; 0xfffffe84
    1998:	00757063 	rsbseq	r7, r5, r3, rrx
    199c:	5f617369 	svcpl	0x00617369
    19a0:	5f746962 	svcpl	0x00746962
    19a4:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    19a8:	73690034 	cmnvc	r9, #52	; 0x34
    19ac:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    19b0:	68745f74 	ldmdavs	r4!, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    19b4:	32626d75 	rsbcc	r6, r2, #7488	; 0x1d40
    19b8:	61736900 	cmnvs	r3, r0, lsl #18
    19bc:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    19c0:	3865625f 	stmdacc	r5!, {r0, r1, r2, r3, r4, r6, r9, sp, lr}^
    19c4:	61736900 	cmnvs	r3, r0, lsl #18
    19c8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    19cc:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    19d0:	69003776 	stmdbvs	r0, {r1, r2, r4, r5, r6, r8, r9, sl, ip, sp}
    19d4:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    19d8:	615f7469 	cmpvs	pc, r9, ror #8
    19dc:	38766d72 	ldmdacc	r6!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^
    19e0:	70667600 	rsbvc	r7, r6, r0, lsl #12
    19e4:	7379735f 	cmnvc	r9, #2080374785	; 0x7c000001
    19e8:	73676572 	cmnvc	r7, #478150656	; 0x1c800000
    19ec:	636e655f 	cmnvs	lr, #398458880	; 0x17c00000
    19f0:	6e69646f 	cdpvs	4, 6, cr6, cr9, cr15, {3}
    19f4:	73690067 	cmnvc	r9, #103	; 0x67
    19f8:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    19fc:	70665f74 	rsbvc	r5, r6, r4, ror pc
    1a00:	6d663631 	stclvs	6, cr3, [r6, #-196]!	; 0xffffff3c
    1a04:	7369006c 	cmnvc	r9, #108	; 0x6c
    1a08:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1a0c:	6f645f74 	svcvs	0x00645f74
    1a10:	6f727074 	svcvs	0x00727074
    1a14:	Address 0x0000000000001a14 is out of bounds.


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
  20:	8b040e42 	blhi	103930 <__bss_end+0xfa1f8>
  24:	0b0d4201 	bleq	350830 <__bss_end+0x3470f8>
  28:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
  2c:	00000ecb 	andeq	r0, r0, fp, asr #29
  30:	0000001c 	andeq	r0, r0, ip, lsl r0
  34:	00000000 	andeq	r0, r0, r0
  38:	00008064 	andeq	r8, r0, r4, rrx
  3c:	00000040 	andeq	r0, r0, r0, asr #32
  40:	8b080e42 	blhi	203950 <__bss_end+0x1fa218>
  44:	42018e02 	andmi	r8, r1, #2, 28
  48:	5a040b0c 	bpl	102c80 <__bss_end+0xf9548>
  4c:	00080d0c 	andeq	r0, r8, ip, lsl #26
  50:	0000000c 	andeq	r0, r0, ip
  54:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  58:	7c020001 	stcvc	0, cr0, [r2], {1}
  5c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  60:	0000001c 	andeq	r0, r0, ip, lsl r0
  64:	00000050 	andeq	r0, r0, r0, asr r0
  68:	000080a4 	andeq	r8, r0, r4, lsr #1
  6c:	00000038 	andeq	r0, r0, r8, lsr r0
  70:	8b040e42 	blhi	103980 <__bss_end+0xfa248>
  74:	0b0d4201 	bleq	350880 <__bss_end+0x347148>
  78:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
  7c:	00000ecb 	andeq	r0, r0, fp, asr #29
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	00000050 	andeq	r0, r0, r0, asr r0
  88:	000080dc 	ldrdeq	r8, [r0], -ip
  8c:	0000002c 	andeq	r0, r0, ip, lsr #32
  90:	8b040e42 	blhi	1039a0 <__bss_end+0xfa268>
  94:	0b0d4201 	bleq	3508a0 <__bss_end+0x347168>
  98:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
  9c:	00000ecb 	andeq	r0, r0, fp, asr #29
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	00000050 	andeq	r0, r0, r0, asr r0
  a8:	00008108 	andeq	r8, r0, r8, lsl #2
  ac:	00000020 	andeq	r0, r0, r0, lsr #32
  b0:	8b040e42 	blhi	1039c0 <__bss_end+0xfa288>
  b4:	0b0d4201 	bleq	3508c0 <__bss_end+0x347188>
  b8:	420d0d48 	andmi	r0, sp, #72, 26	; 0x1200
  bc:	00000ecb 	andeq	r0, r0, fp, asr #29
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	00000050 	andeq	r0, r0, r0, asr r0
  c8:	00008128 	andeq	r8, r0, r8, lsr #2
  cc:	00000018 	andeq	r0, r0, r8, lsl r0
  d0:	8b040e42 	blhi	1039e0 <__bss_end+0xfa2a8>
  d4:	0b0d4201 	bleq	3508e0 <__bss_end+0x3471a8>
  d8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  dc:	00000ecb 	andeq	r0, r0, fp, asr #29
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	00000050 	andeq	r0, r0, r0, asr r0
  e8:	00008140 	andeq	r8, r0, r0, asr #2
  ec:	00000018 	andeq	r0, r0, r8, lsl r0
  f0:	8b040e42 	blhi	103a00 <__bss_end+0xfa2c8>
  f4:	0b0d4201 	bleq	350900 <__bss_end+0x3471c8>
  f8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  fc:	00000ecb 	andeq	r0, r0, fp, asr #29
 100:	0000001c 	andeq	r0, r0, ip, lsl r0
 104:	00000050 	andeq	r0, r0, r0, asr r0
 108:	00008158 	andeq	r8, r0, r8, asr r1
 10c:	00000018 	andeq	r0, r0, r8, lsl r0
 110:	8b040e42 	blhi	103a20 <__bss_end+0xfa2e8>
 114:	0b0d4201 	bleq	350920 <__bss_end+0x3471e8>
 118:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
 11c:	00000ecb 	andeq	r0, r0, fp, asr #29
 120:	00000014 	andeq	r0, r0, r4, lsl r0
 124:	00000050 	andeq	r0, r0, r0, asr r0
 128:	00008170 	andeq	r8, r0, r0, ror r1
 12c:	0000000c 	andeq	r0, r0, ip
 130:	8b040e42 	blhi	103a40 <__bss_end+0xfa308>
 134:	0b0d4201 	bleq	350940 <__bss_end+0x347208>
 138:	0000001c 	andeq	r0, r0, ip, lsl r0
 13c:	00000050 	andeq	r0, r0, r0, asr r0
 140:	0000817c 	andeq	r8, r0, ip, ror r1
 144:	00000058 	andeq	r0, r0, r8, asr r0
 148:	8b080e42 	blhi	203a58 <__bss_end+0x1fa320>
 14c:	42018e02 	andmi	r8, r1, #2, 28
 150:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 154:	00080d0c 	andeq	r0, r8, ip, lsl #26
 158:	0000001c 	andeq	r0, r0, ip, lsl r0
 15c:	00000050 	andeq	r0, r0, r0, asr r0
 160:	000081d4 	ldrdeq	r8, [r0], -r4
 164:	00000058 	andeq	r0, r0, r8, asr r0
 168:	8b080e42 	blhi	203a78 <__bss_end+0x1fa340>
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
 194:	0000010c 	andeq	r0, r0, ip, lsl #2
 198:	8b080e42 	blhi	203aa8 <__bss_end+0x1fa370>
 19c:	42018e02 	andmi	r8, r1, #2, 28
 1a0:	00040b0c 	andeq	r0, r4, ip, lsl #22
 1a4:	0000000c 	andeq	r0, r0, ip
 1a8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 1ac:	7c020001 	stcvc	0, cr0, [r2], {1}
 1b0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 1b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1b8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1bc:	00008338 	andeq	r8, r0, r8, lsr r3
 1c0:	0000002c 	andeq	r0, r0, ip, lsr #32
 1c4:	8b040e42 	blhi	103ad4 <__bss_end+0xfa39c>
 1c8:	0b0d4201 	bleq	3509d4 <__bss_end+0x34729c>
 1cc:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 1d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 1d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1d8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1dc:	00008364 	andeq	r8, r0, r4, ror #6
 1e0:	0000002c 	andeq	r0, r0, ip, lsr #32
 1e4:	8b040e42 	blhi	103af4 <__bss_end+0xfa3bc>
 1e8:	0b0d4201 	bleq	3509f4 <__bss_end+0x3472bc>
 1ec:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 1f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 1f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1f8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1fc:	00008390 	muleq	r0, r0, r3
 200:	0000001c 	andeq	r0, r0, ip, lsl r0
 204:	8b040e42 	blhi	103b14 <__bss_end+0xfa3dc>
 208:	0b0d4201 	bleq	350a14 <__bss_end+0x3472dc>
 20c:	420d0d46 	andmi	r0, sp, #4480	; 0x1180
 210:	00000ecb 	andeq	r0, r0, fp, asr #29
 214:	0000001c 	andeq	r0, r0, ip, lsl r0
 218:	000001a4 	andeq	r0, r0, r4, lsr #3
 21c:	000083ac 	andeq	r8, r0, ip, lsr #7
 220:	00000044 	andeq	r0, r0, r4, asr #32
 224:	8b040e42 	blhi	103b34 <__bss_end+0xfa3fc>
 228:	0b0d4201 	bleq	350a34 <__bss_end+0x3472fc>
 22c:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 230:	00000ecb 	andeq	r0, r0, fp, asr #29
 234:	0000001c 	andeq	r0, r0, ip, lsl r0
 238:	000001a4 	andeq	r0, r0, r4, lsr #3
 23c:	000083f0 	strdeq	r8, [r0], -r0
 240:	00000050 	andeq	r0, r0, r0, asr r0
 244:	8b040e42 	blhi	103b54 <__bss_end+0xfa41c>
 248:	0b0d4201 	bleq	350a54 <__bss_end+0x34731c>
 24c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 250:	00000ecb 	andeq	r0, r0, fp, asr #29
 254:	0000001c 	andeq	r0, r0, ip, lsl r0
 258:	000001a4 	andeq	r0, r0, r4, lsr #3
 25c:	00008440 	andeq	r8, r0, r0, asr #8
 260:	00000050 	andeq	r0, r0, r0, asr r0
 264:	8b040e42 	blhi	103b74 <__bss_end+0xfa43c>
 268:	0b0d4201 	bleq	350a74 <__bss_end+0x34733c>
 26c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 270:	00000ecb 	andeq	r0, r0, fp, asr #29
 274:	0000001c 	andeq	r0, r0, ip, lsl r0
 278:	000001a4 	andeq	r0, r0, r4, lsr #3
 27c:	00008490 	muleq	r0, r0, r4
 280:	0000002c 	andeq	r0, r0, ip, lsr #32
 284:	8b040e42 	blhi	103b94 <__bss_end+0xfa45c>
 288:	0b0d4201 	bleq	350a94 <__bss_end+0x34735c>
 28c:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 290:	00000ecb 	andeq	r0, r0, fp, asr #29
 294:	0000001c 	andeq	r0, r0, ip, lsl r0
 298:	000001a4 	andeq	r0, r0, r4, lsr #3
 29c:	000084bc 			; <UNDEFINED> instruction: 0x000084bc
 2a0:	00000050 	andeq	r0, r0, r0, asr r0
 2a4:	8b040e42 	blhi	103bb4 <__bss_end+0xfa47c>
 2a8:	0b0d4201 	bleq	350ab4 <__bss_end+0x34737c>
 2ac:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 2b0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2b8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2bc:	0000850c 	andeq	r8, r0, ip, lsl #10
 2c0:	00000044 	andeq	r0, r0, r4, asr #32
 2c4:	8b040e42 	blhi	103bd4 <__bss_end+0xfa49c>
 2c8:	0b0d4201 	bleq	350ad4 <__bss_end+0x34739c>
 2cc:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 2d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2d8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2dc:	00008550 	andeq	r8, r0, r0, asr r5
 2e0:	00000050 	andeq	r0, r0, r0, asr r0
 2e4:	8b040e42 	blhi	103bf4 <__bss_end+0xfa4bc>
 2e8:	0b0d4201 	bleq	350af4 <__bss_end+0x3473bc>
 2ec:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 2f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2f8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2fc:	000085a0 	andeq	r8, r0, r0, lsr #11
 300:	00000054 	andeq	r0, r0, r4, asr r0
 304:	8b040e42 	blhi	103c14 <__bss_end+0xfa4dc>
 308:	0b0d4201 	bleq	350b14 <__bss_end+0x3473dc>
 30c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 310:	00000ecb 	andeq	r0, r0, fp, asr #29
 314:	0000001c 	andeq	r0, r0, ip, lsl r0
 318:	000001a4 	andeq	r0, r0, r4, lsr #3
 31c:	000085f4 	strdeq	r8, [r0], -r4
 320:	0000003c 	andeq	r0, r0, ip, lsr r0
 324:	8b040e42 	blhi	103c34 <__bss_end+0xfa4fc>
 328:	0b0d4201 	bleq	350b34 <__bss_end+0x3473fc>
 32c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 330:	00000ecb 	andeq	r0, r0, fp, asr #29
 334:	0000001c 	andeq	r0, r0, ip, lsl r0
 338:	000001a4 	andeq	r0, r0, r4, lsr #3
 33c:	00008630 	andeq	r8, r0, r0, lsr r6
 340:	0000003c 	andeq	r0, r0, ip, lsr r0
 344:	8b040e42 	blhi	103c54 <__bss_end+0xfa51c>
 348:	0b0d4201 	bleq	350b54 <__bss_end+0x34741c>
 34c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 350:	00000ecb 	andeq	r0, r0, fp, asr #29
 354:	0000001c 	andeq	r0, r0, ip, lsl r0
 358:	000001a4 	andeq	r0, r0, r4, lsr #3
 35c:	0000866c 	andeq	r8, r0, ip, ror #12
 360:	0000003c 	andeq	r0, r0, ip, lsr r0
 364:	8b040e42 	blhi	103c74 <__bss_end+0xfa53c>
 368:	0b0d4201 	bleq	350b74 <__bss_end+0x34743c>
 36c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 370:	00000ecb 	andeq	r0, r0, fp, asr #29
 374:	0000001c 	andeq	r0, r0, ip, lsl r0
 378:	000001a4 	andeq	r0, r0, r4, lsr #3
 37c:	000086a8 	andeq	r8, r0, r8, lsr #13
 380:	0000003c 	andeq	r0, r0, ip, lsr r0
 384:	8b040e42 	blhi	103c94 <__bss_end+0xfa55c>
 388:	0b0d4201 	bleq	350b94 <__bss_end+0x34745c>
 38c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 390:	00000ecb 	andeq	r0, r0, fp, asr #29
 394:	0000001c 	andeq	r0, r0, ip, lsl r0
 398:	000001a4 	andeq	r0, r0, r4, lsr #3
 39c:	000086e4 	andeq	r8, r0, r4, ror #13
 3a0:	000000b0 	strheq	r0, [r0], -r0	; <UNPREDICTABLE>
 3a4:	8b080e42 	blhi	203cb4 <__bss_end+0x1fa57c>
 3a8:	42018e02 	andmi	r8, r1, #2, 28
 3ac:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 3b0:	080d0c50 	stmdaeq	sp, {r4, r6, sl, fp}
 3b4:	0000000c 	andeq	r0, r0, ip
 3b8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 3bc:	7c020001 	stcvc	0, cr0, [r2], {1}
 3c0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 3c4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3c8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 3cc:	00008794 	muleq	r0, r4, r7
 3d0:	00000174 	andeq	r0, r0, r4, ror r1
 3d4:	8b080e42 	blhi	203ce4 <__bss_end+0x1fa5ac>
 3d8:	42018e02 	andmi	r8, r1, #2, 28
 3dc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 3e0:	080d0cb2 	stmdaeq	sp, {r1, r4, r5, r7, sl, fp}
 3e4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3e8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 3ec:	00008908 	andeq	r8, r0, r8, lsl #18
 3f0:	0000009c 	muleq	r0, ip, r0
 3f4:	8b040e42 	blhi	103d04 <__bss_end+0xfa5cc>
 3f8:	0b0d4201 	bleq	350c04 <__bss_end+0x3474cc>
 3fc:	0d0d4602 	stceq	6, cr4, [sp, #-8]
 400:	000ecb42 	andeq	ip, lr, r2, asr #22
 404:	0000001c 	andeq	r0, r0, ip, lsl r0
 408:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 40c:	000089a4 	andeq	r8, r0, r4, lsr #19
 410:	000000c0 	andeq	r0, r0, r0, asr #1
 414:	8b040e42 	blhi	103d24 <__bss_end+0xfa5ec>
 418:	0b0d4201 	bleq	350c24 <__bss_end+0x3474ec>
 41c:	0d0d5802 	stceq	8, cr5, [sp, #-8]
 420:	000ecb42 	andeq	ip, lr, r2, asr #22
 424:	0000001c 	andeq	r0, r0, ip, lsl r0
 428:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 42c:	00008a64 	andeq	r8, r0, r4, ror #20
 430:	000000ac 	andeq	r0, r0, ip, lsr #1
 434:	8b040e42 	blhi	103d44 <__bss_end+0xfa60c>
 438:	0b0d4201 	bleq	350c44 <__bss_end+0x34750c>
 43c:	0d0d4e02 	stceq	14, cr4, [sp, #-8]
 440:	000ecb42 	andeq	ip, lr, r2, asr #22
 444:	0000001c 	andeq	r0, r0, ip, lsl r0
 448:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 44c:	00008b10 	andeq	r8, r0, r0, lsl fp
 450:	00000054 	andeq	r0, r0, r4, asr r0
 454:	8b040e42 	blhi	103d64 <__bss_end+0xfa62c>
 458:	0b0d4201 	bleq	350c64 <__bss_end+0x34752c>
 45c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 460:	00000ecb 	andeq	r0, r0, fp, asr #29
 464:	0000001c 	andeq	r0, r0, ip, lsl r0
 468:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 46c:	00008b64 	andeq	r8, r0, r4, ror #22
 470:	00000068 	andeq	r0, r0, r8, rrx
 474:	8b040e42 	blhi	103d84 <__bss_end+0xfa64c>
 478:	0b0d4201 	bleq	350c84 <__bss_end+0x34754c>
 47c:	420d0d6c 	andmi	r0, sp, #108, 26	; 0x1b00
 480:	00000ecb 	andeq	r0, r0, fp, asr #29
 484:	0000001c 	andeq	r0, r0, ip, lsl r0
 488:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 48c:	00008bcc 	andeq	r8, r0, ip, asr #23
 490:	00000080 	andeq	r0, r0, r0, lsl #1
 494:	8b040e42 	blhi	103da4 <__bss_end+0xfa66c>
 498:	0b0d4201 	bleq	350ca4 <__bss_end+0x34756c>
 49c:	420d0d78 	andmi	r0, sp, #120, 26	; 0x1e00
 4a0:	00000ecb 	andeq	r0, r0, fp, asr #29
 4a4:	0000000c 	andeq	r0, r0, ip
 4a8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 4ac:	7c020001 	stcvc	0, cr0, [r2], {1}
 4b0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 4b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 4b8:	000004a4 	andeq	r0, r0, r4, lsr #9
 4bc:	00008c4c 	andeq	r8, r0, ip, asr #24
 4c0:	00000068 	andeq	r0, r0, r8, rrx
 4c4:	8b080e42 	blhi	203dd4 <__bss_end+0x1fa69c>
 4c8:	42018e02 	andmi	r8, r1, #2, 28
 4cc:	6e040b0c 	vmlavs.f64	d0, d4, d12
 4d0:	00080d0c 	andeq	r0, r8, ip, lsl #26
 4d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 4d8:	000004a4 	andeq	r0, r0, r4, lsr #9
 4dc:	00008cb4 			; <UNDEFINED> instruction: 0x00008cb4
 4e0:	0000004c 	andeq	r0, r0, ip, asr #32
 4e4:	8b080e42 	blhi	203df4 <__bss_end+0x1fa6bc>
 4e8:	42018e02 	andmi	r8, r1, #2, 28
 4ec:	60040b0c 	andvs	r0, r4, ip, lsl #22
 4f0:	00080d0c 	andeq	r0, r8, ip, lsl #26
 4f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 4f8:	000004a4 	andeq	r0, r0, r4, lsr #9
 4fc:	00008d00 	andeq	r8, r0, r0, lsl #26
 500:	00000028 	andeq	r0, r0, r8, lsr #32
 504:	8b040e42 	blhi	103e14 <__bss_end+0xfa6dc>
 508:	0b0d4201 	bleq	350d14 <__bss_end+0x3475dc>
 50c:	420d0d4c 	andmi	r0, sp, #76, 26	; 0x1300
 510:	00000ecb 	andeq	r0, r0, fp, asr #29
 514:	0000001c 	andeq	r0, r0, ip, lsl r0
 518:	000004a4 	andeq	r0, r0, r4, lsr #9
 51c:	00008d28 	andeq	r8, r0, r8, lsr #26
 520:	0000007c 	andeq	r0, r0, ip, ror r0
 524:	8b080e42 	blhi	203e34 <__bss_end+0x1fa6fc>
 528:	42018e02 	andmi	r8, r1, #2, 28
 52c:	78040b0c 	stmdavc	r4, {r2, r3, r8, r9, fp}
 530:	00080d0c 	andeq	r0, r8, ip, lsl #26
 534:	0000001c 	andeq	r0, r0, ip, lsl r0
 538:	000004a4 	andeq	r0, r0, r4, lsr #9
 53c:	00008da4 	andeq	r8, r0, r4, lsr #27
 540:	000000ec 	andeq	r0, r0, ip, ror #1
 544:	8b080e42 	blhi	203e54 <__bss_end+0x1fa71c>
 548:	42018e02 	andmi	r8, r1, #2, 28
 54c:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 550:	080d0c70 	stmdaeq	sp, {r4, r5, r6, sl, fp}
 554:	0000001c 	andeq	r0, r0, ip, lsl r0
 558:	000004a4 	andeq	r0, r0, r4, lsr #9
 55c:	00008e90 	muleq	r0, r0, lr
 560:	00000168 	andeq	r0, r0, r8, ror #2
 564:	8b080e42 	blhi	203e74 <__bss_end+0x1fa73c>
 568:	42018e02 	andmi	r8, r1, #2, 28
 56c:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 570:	080d0cac 	stmdaeq	sp, {r2, r3, r5, r7, sl, fp}
 574:	0000001c 	andeq	r0, r0, ip, lsl r0
 578:	000004a4 	andeq	r0, r0, r4, lsr #9
 57c:	00008ff8 	strdeq	r8, [r0], -r8	; <UNPREDICTABLE>
 580:	00000058 	andeq	r0, r0, r8, asr r0
 584:	8b080e42 	blhi	203e94 <__bss_end+0x1fa75c>
 588:	42018e02 	andmi	r8, r1, #2, 28
 58c:	66040b0c 	strvs	r0, [r4], -ip, lsl #22
 590:	00080d0c 	andeq	r0, r8, ip, lsl #26
 594:	0000001c 	andeq	r0, r0, ip, lsl r0
 598:	000004a4 	andeq	r0, r0, r4, lsr #9
 59c:	00009050 	andeq	r9, r0, r0, asr r0
 5a0:	000000b0 	strheq	r0, [r0], -r0	; <UNPREDICTABLE>
 5a4:	8b080e42 	blhi	203eb4 <__bss_end+0x1fa77c>
 5a8:	42018e02 	andmi	r8, r1, #2, 28
 5ac:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 5b0:	080d0c52 	stmdaeq	sp, {r1, r4, r6, sl, fp}
 5b4:	0000000c 	andeq	r0, r0, ip
 5b8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 5bc:	7c010001 	stcvc	0, cr0, [r1], {1}
 5c0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 5c4:	0000000c 	andeq	r0, r0, ip
 5c8:	000005b4 			; <UNDEFINED> instruction: 0x000005b4
 5cc:	00009100 	andeq	r9, r0, r0, lsl #2
 5d0:	000001ec 	andeq	r0, r0, ip, ror #3
