
./sos_task:     file format elf32-littlearm


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
    805c:	00009018 	andeq	r9, r0, r8, lsl r0
    8060:	00009030 	andeq	r9, r0, r0, lsr r0

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
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/crt0.c:28

    // volani funkce main
    // nebudeme se zde zabyvat predavanim parametru do funkce main
    // jinak by se mohly predavat napr. namapovane do virtualniho adr. prostoru a odkazem pres zasobnik (kam nam muze OS
    // pushnout co chce)
    int result = main(0, 0);
    8078:	e3a01000 	mov	r1, #0
    807c:	e3a00000 	mov	r0, #0
    8080:	eb000089 	bl	82ac <main>
    8084:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/crt0.c:31

    // volani destruktoru globalnich trid (C++)
    _cpp_shutdown();
    8088:	eb000051 	bl	81d4 <_cpp_shutdown>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/crt0.c:34

    // volani terminate() syscallu s navratovym kodem funkce main
    asm volatile("mov r0, %0" : : "r"(result));
    808c:	e51b3008 	ldr	r3, [fp, #-8]
    8090:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/crt0.c:35
    asm volatile("svc #1");
    8094:	ef000001 	svc	0x00000001
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/crt0.c:36
}
    8098:	e320f000 	nop	{0}
    809c:	e24bd004 	sub	sp, fp, #4
    80a0:	e8bd8800 	pop	{fp, pc}

000080a4 <__cxa_guard_acquire>:
__cxa_guard_acquire():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/cxxabi.cpp:11
    extern "C" int __cxa_guard_acquire(__guard*);
    extern "C" void __cxa_guard_release(__guard*);
    extern "C" void __cxa_guard_abort(__guard*);

    extern "C" int __cxa_guard_acquire(__guard* g)
    {
    80a4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    80a8:	e28db000 	add	fp, sp, #0
    80ac:	e24dd00c 	sub	sp, sp, #12
    80b0:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/cxxabi.cpp:12
        return !*(char*)(g);
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

    extern "C" void __cxa_guard_release(__guard* g)
    {
    80dc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    80e0:	e28db000 	add	fp, sp, #0
    80e4:	e24dd00c 	sub	sp, sp, #12
    80e8:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/cxxabi.cpp:17
        *(char*)g = 1;
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

    extern "C" void __cxa_guard_abort(__guard*)
    {
    8108:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    810c:	e28db000 	add	fp, sp, #0
    8110:	e24dd00c 	sub	sp, sp, #12
    8114:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/cxxabi.cpp:22
    }
    8118:	e320f000 	nop	{0}
    811c:	e28bd000 	add	sp, fp, #0
    8120:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8124:	e12fff1e 	bx	lr

00008128 <__dso_handle>:
__dso_handle():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/cxxabi.cpp:26
}

extern "C" void __dso_handle()
{
    8128:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    812c:	e28db000 	add	fp, sp, #0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/cxxabi.cpp:28
    // ignore dtors for now
}
    8130:	e320f000 	nop	{0}
    8134:	e28bd000 	add	sp, fp, #0
    8138:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    813c:	e12fff1e 	bx	lr

00008140 <__cxa_atexit>:
__cxa_atexit():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/cxxabi.cpp:31

extern "C" void __cxa_atexit()
{
    8140:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8144:	e28db000 	add	fp, sp, #0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/cxxabi.cpp:33
    // ignore dtors for now
}
    8148:	e320f000 	nop	{0}
    814c:	e28bd000 	add	sp, fp, #0
    8150:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8154:	e12fff1e 	bx	lr

00008158 <__cxa_pure_virtual>:
__cxa_pure_virtual():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/cxxabi.cpp:36

extern "C" void __cxa_pure_virtual()
{
    8158:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    815c:	e28db000 	add	fp, sp, #0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/cxxabi.cpp:38
    // pure virtual method called
}
    8160:	e320f000 	nop	{0}
    8164:	e28bd000 	add	sp, fp, #0
    8168:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    816c:	e12fff1e 	bx	lr

00008170 <__aeabi_unwind_cpp_pr1>:
__aeabi_unwind_cpp_pr1():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/cxxabi.cpp:41

extern "C" void __aeabi_unwind_cpp_pr1()
{
    8170:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8174:	e28db000 	add	fp, sp, #0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/cxxabi.cpp:42 (discriminator 1)
    while (true)
    8178:	eafffffe 	b	8178 <__aeabi_unwind_cpp_pr1+0x8>

0000817c <_cpp_startup>:
_cpp_startup():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/cxxabi.cpp:60
extern "C" dtor_ptr __DTOR_LIST__[0];
// konec pole destruktoru
extern "C" dtor_ptr __DTOR_END__[0];

extern "C" int _cpp_startup(void)
{
    817c:	e92d4800 	push	{fp, lr}
    8180:	e28db004 	add	fp, sp, #4
    8184:	e24dd008 	sub	sp, sp, #8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/cxxabi.cpp:65
    ctor_ptr* fnptr;

    // zavolame konstruktory globalnich C++ trid
    // v poli __CTOR_LIST__ jsou ukazatele na vygenerovane stuby volani konstruktoru
    for (fnptr = __CTOR_LIST__; fnptr < __CTOR_END__; fnptr++)
    8188:	e59f303c 	ldr	r3, [pc, #60]	; 81cc <_cpp_startup+0x50>
    818c:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/cxxabi.cpp:65 (discriminator 3)
    8190:	e51b3008 	ldr	r3, [fp, #-8]
    8194:	e59f2034 	ldr	r2, [pc, #52]	; 81d0 <_cpp_startup+0x54>
    8198:	e1530002 	cmp	r3, r2
    819c:	2a000006 	bcs	81bc <_cpp_startup+0x40>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/cxxabi.cpp:66 (discriminator 2)
        (*fnptr)();
    81a0:	e51b3008 	ldr	r3, [fp, #-8]
    81a4:	e5933000 	ldr	r3, [r3]
    81a8:	e12fff33 	blx	r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/cxxabi.cpp:65 (discriminator 2)
    for (fnptr = __CTOR_LIST__; fnptr < __CTOR_END__; fnptr++)
    81ac:	e51b3008 	ldr	r3, [fp, #-8]
    81b0:	e2833004 	add	r3, r3, #4
    81b4:	e50b3008 	str	r3, [fp, #-8]
    81b8:	eafffff4 	b	8190 <_cpp_startup+0x14>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/cxxabi.cpp:68

    return 0;
    81bc:	e3a03000 	mov	r3, #0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/cxxabi.cpp:69
}
    81c0:	e1a00003 	mov	r0, r3
    81c4:	e24bd004 	sub	sp, fp, #4
    81c8:	e8bd8800 	pop	{fp, pc}
    81cc:	00009015 	andeq	r9, r0, r5, lsl r0
    81d0:	00009015 	andeq	r9, r0, r5, lsl r0

000081d4 <_cpp_shutdown>:
_cpp_shutdown():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/cxxabi.cpp:72

extern "C" int _cpp_shutdown(void)
{
    81d4:	e92d4800 	push	{fp, lr}
    81d8:	e28db004 	add	fp, sp, #4
    81dc:	e24dd008 	sub	sp, sp, #8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/cxxabi.cpp:76
    dtor_ptr* fnptr;

    // zavolame destruktory globalnich C++ trid
    for (fnptr = __DTOR_LIST__; fnptr < __DTOR_END__; fnptr++)
    81e0:	e59f303c 	ldr	r3, [pc, #60]	; 8224 <_cpp_shutdown+0x50>
    81e4:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/cxxabi.cpp:76 (discriminator 3)
    81e8:	e51b3008 	ldr	r3, [fp, #-8]
    81ec:	e59f2034 	ldr	r2, [pc, #52]	; 8228 <_cpp_shutdown+0x54>
    81f0:	e1530002 	cmp	r3, r2
    81f4:	2a000006 	bcs	8214 <_cpp_shutdown+0x40>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/cxxabi.cpp:77 (discriminator 2)
        (*fnptr)();
    81f8:	e51b3008 	ldr	r3, [fp, #-8]
    81fc:	e5933000 	ldr	r3, [r3]
    8200:	e12fff33 	blx	r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/cxxabi.cpp:76 (discriminator 2)
    for (fnptr = __DTOR_LIST__; fnptr < __DTOR_END__; fnptr++)
    8204:	e51b3008 	ldr	r3, [fp, #-8]
    8208:	e2833004 	add	r3, r3, #4
    820c:	e50b3008 	str	r3, [fp, #-8]
    8210:	eafffff4 	b	81e8 <_cpp_shutdown+0x14>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/cxxabi.cpp:79

    return 0;
    8214:	e3a03000 	mov	r3, #0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/cxxabi.cpp:80
}
    8218:	e1a00003 	mov	r0, r3
    821c:	e24bd004 	sub	sp, fp, #4
    8220:	e8bd8800 	pop	{fp, pc}
    8224:	00009015 	andeq	r9, r0, r5, lsl r0
    8228:	00009015 	andeq	r9, r0, r5, lsl r0

0000822c <_Z5blinkb>:
_Z5blinkb():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/sos_task/main.cpp:23

uint32_t sos_led;
uint32_t button;

void blink(bool short_blink)
{
    822c:	e92d4800 	push	{fp, lr}
    8230:	e28db004 	add	fp, sp, #4
    8234:	e24dd008 	sub	sp, sp, #8
    8238:	e1a03000 	mov	r3, r0
    823c:	e54b3005 	strb	r3, [fp, #-5]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/sos_task/main.cpp:24
    write(sos_led, "1", 1);
    8240:	e59f3058 	ldr	r3, [pc, #88]	; 82a0 <_Z5blinkb+0x74>
    8244:	e5933000 	ldr	r3, [r3]
    8248:	e3a02001 	mov	r2, #1
    824c:	e59f1050 	ldr	r1, [pc, #80]	; 82a4 <_Z5blinkb+0x78>
    8250:	e1a00003 	mov	r0, r3
    8254:	eb0000b1 	bl	8520 <_Z5writejPKcj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/sos_task/main.cpp:25
    sleep(short_blink ? 8 : 10);
    8258:	e55b3005 	ldrb	r3, [fp, #-5]
    825c:	e3530000 	cmp	r3, #0
    8260:	0a000001 	beq	826c <_Z5blinkb+0x40>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/sos_task/main.cpp:25 (discriminator 1)
    8264:	e3a03008 	mov	r3, #8
    8268:	ea000000 	b	8270 <_Z5blinkb+0x44>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/sos_task/main.cpp:25 (discriminator 2)
    826c:	e3a0300a 	mov	r3, #10
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/sos_task/main.cpp:25 (discriminator 4)
    8270:	e3e01001 	mvn	r1, #1
    8274:	e1a00003 	mov	r0, r3
    8278:	eb000100 	bl	8680 <_Z5sleepjj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/sos_task/main.cpp:26 (discriminator 4)
    write(sos_led, "0", 1);
    827c:	e59f301c 	ldr	r3, [pc, #28]	; 82a0 <_Z5blinkb+0x74>
    8280:	e5933000 	ldr	r3, [r3]
    8284:	e3a02001 	mov	r2, #1
    8288:	e59f1018 	ldr	r1, [pc, #24]	; 82a8 <_Z5blinkb+0x7c>
    828c:	e1a00003 	mov	r0, r3
    8290:	eb0000a2 	bl	8520 <_Z5writejPKcj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/sos_task/main.cpp:27 (discriminator 4)
}
    8294:	e320f000 	nop	{0}
    8298:	e24bd004 	sub	sp, fp, #4
    829c:	e8bd8800 	pop	{fp, pc}
    82a0:	00009018 	andeq	r9, r0, r8, lsl r0
    82a4:	00008fa0 	andeq	r8, r0, r0, lsr #31
    82a8:	00008fa4 	andeq	r8, r0, r4, lsr #31

000082ac <main>:
main():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/sos_task/main.cpp:30

int main(int argc, char** argv)
{
    82ac:	e92d4800 	push	{fp, lr}
    82b0:	e28db004 	add	fp, sp, #4
    82b4:	e24dd010 	sub	sp, sp, #16
    82b8:	e50b0010 	str	r0, [fp, #-16]
    82bc:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/sos_task/main.cpp:31
    sos_led = open("DEV:gpio/18", NFile_Open_Mode::Write_Only);
    82c0:	e3a01001 	mov	r1, #1
    82c4:	e59f0134 	ldr	r0, [pc, #308]	; 8400 <main+0x154>
    82c8:	eb00006f 	bl	848c <_Z4openPKc15NFile_Open_Mode>
    82cc:	e1a03000 	mov	r3, r0
    82d0:	e59f212c 	ldr	r2, [pc, #300]	; 8404 <main+0x158>
    82d4:	e5823000 	str	r3, [r2]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/sos_task/main.cpp:32
    button = open("DEV:gpio/16", NFile_Open_Mode::Read_Only);
    82d8:	e3a01000 	mov	r1, #0
    82dc:	e59f0124 	ldr	r0, [pc, #292]	; 8408 <main+0x15c>
    82e0:	eb000069 	bl	848c <_Z4openPKc15NFile_Open_Mode>
    82e4:	e1a03000 	mov	r3, r0
    82e8:	e59f211c 	ldr	r2, [pc, #284]	; 840c <main+0x160>
    82ec:	e5823000 	str	r3, [r2]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/sos_task/main.cpp:34

    NGPIO_Interrupt_Type irtype = NGPIO_Interrupt_Type::Rising_Edge;
    82f0:	e3a03000 	mov	r3, #0
    82f4:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/sos_task/main.cpp:35
    ioctl(button, NIOCtl_Operation::Enable_Event_Detection, &irtype);
    82f8:	e59f310c 	ldr	r3, [pc, #268]	; 840c <main+0x160>
    82fc:	e5933000 	ldr	r3, [r3]
    8300:	e24b200c 	sub	r2, fp, #12
    8304:	e3a01002 	mov	r1, #2
    8308:	e1a00003 	mov	r0, r3
    830c:	eb0000a2 	bl	859c <_Z5ioctlj16NIOCtl_OperationPv>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/sos_task/main.cpp:37

    uint32_t logpipe = pipe("log", 32);
    8310:	e3a01020 	mov	r1, #32
    8314:	e59f00f4 	ldr	r0, [pc, #244]	; 8410 <main+0x164>
    8318:	eb000129 	bl	87c4 <_Z4pipePKcj>
    831c:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/sos_task/main.cpp:42 (discriminator 1)

    while (true)
    {
        // pockame na stisk klavesy
        wait(button, 1, 30);
    8320:	e59f30e4 	ldr	r3, [pc, #228]	; 840c <main+0x160>
    8324:	e5933000 	ldr	r3, [r3]
    8328:	e3a0201e 	mov	r2, #30
    832c:	e3a01001 	mov	r1, #1
    8330:	e1a00003 	mov	r0, r3
    8334:	eb0000bd 	bl	8630 <_Z4waitjjj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/sos_task/main.cpp:53 (discriminator 1)
        // 4) jiny task ma deadline 0x500
        // jiny task dostane prednost pred log taskem, a pokud nesplni v kratkem case svou ulohu, tento task prekroci
        // deadline
        // TODO: inverzi priorit bychom docasne zvysili prioritu (zkratili deadline) log tasku, aby vyprazdnil pipe a my
        // se mohli odblokovat co nejdrive
        write(logpipe, "SOS!", 5);
    8338:	e3a02005 	mov	r2, #5
    833c:	e59f10d0 	ldr	r1, [pc, #208]	; 8414 <main+0x168>
    8340:	e51b0008 	ldr	r0, [fp, #-8]
    8344:	eb000075 	bl	8520 <_Z5writejPKcj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/sos_task/main.cpp:55 (discriminator 1)

        blink(true);
    8348:	e3a00001 	mov	r0, #1
    834c:	ebffffb6 	bl	822c <_Z5blinkb>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/sos_task/main.cpp:56 (discriminator 1)
        sleep(symbol_tick_delay);
    8350:	e3e01001 	mvn	r1, #1
    8354:	e3a00008 	mov	r0, #8
    8358:	eb0000c8 	bl	8680 <_Z5sleepjj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/sos_task/main.cpp:57 (discriminator 1)
        blink(true);
    835c:	e3a00001 	mov	r0, #1
    8360:	ebffffb1 	bl	822c <_Z5blinkb>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/sos_task/main.cpp:58 (discriminator 1)
        sleep(symbol_tick_delay);
    8364:	e3e01001 	mvn	r1, #1
    8368:	e3a00008 	mov	r0, #8
    836c:	eb0000c3 	bl	8680 <_Z5sleepjj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/sos_task/main.cpp:59 (discriminator 1)
        blink(true);
    8370:	e3a00001 	mov	r0, #1
    8374:	ebffffac 	bl	822c <_Z5blinkb>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/sos_task/main.cpp:61 (discriminator 1)

        sleep(char_tick_delay);
    8378:	e3e01001 	mvn	r1, #1
    837c:	e3a00002 	mov	r0, #2
    8380:	eb0000be 	bl	8680 <_Z5sleepjj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/sos_task/main.cpp:63 (discriminator 1)

        blink(false);
    8384:	e3a00000 	mov	r0, #0
    8388:	ebffffa7 	bl	822c <_Z5blinkb>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/sos_task/main.cpp:64 (discriminator 1)
        sleep(symbol_tick_delay);
    838c:	e3e01001 	mvn	r1, #1
    8390:	e3a00008 	mov	r0, #8
    8394:	eb0000b9 	bl	8680 <_Z5sleepjj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/sos_task/main.cpp:65 (discriminator 1)
        blink(false);
    8398:	e3a00000 	mov	r0, #0
    839c:	ebffffa2 	bl	822c <_Z5blinkb>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/sos_task/main.cpp:66 (discriminator 1)
        sleep(symbol_tick_delay);
    83a0:	e3e01001 	mvn	r1, #1
    83a4:	e3a00008 	mov	r0, #8
    83a8:	eb0000b4 	bl	8680 <_Z5sleepjj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/sos_task/main.cpp:67 (discriminator 1)
        blink(false);
    83ac:	e3a00000 	mov	r0, #0
    83b0:	ebffff9d 	bl	822c <_Z5blinkb>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/sos_task/main.cpp:68 (discriminator 1)
        sleep(symbol_tick_delay);
    83b4:	e3e01001 	mvn	r1, #1
    83b8:	e3a00008 	mov	r0, #8
    83bc:	eb0000af 	bl	8680 <_Z5sleepjj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/sos_task/main.cpp:70 (discriminator 1)

        sleep(char_tick_delay);
    83c0:	e3e01001 	mvn	r1, #1
    83c4:	e3a00002 	mov	r0, #2
    83c8:	eb0000ac 	bl	8680 <_Z5sleepjj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/sos_task/main.cpp:72 (discriminator 1)

        blink(true);
    83cc:	e3a00001 	mov	r0, #1
    83d0:	ebffff95 	bl	822c <_Z5blinkb>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/sos_task/main.cpp:73 (discriminator 1)
        sleep(symbol_tick_delay);
    83d4:	e3e01001 	mvn	r1, #1
    83d8:	e3a00008 	mov	r0, #8
    83dc:	eb0000a7 	bl	8680 <_Z5sleepjj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/sos_task/main.cpp:74 (discriminator 1)
        blink(true);
    83e0:	e3a00001 	mov	r0, #1
    83e4:	ebffff90 	bl	822c <_Z5blinkb>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/sos_task/main.cpp:75 (discriminator 1)
        sleep(symbol_tick_delay);
    83e8:	e3e01001 	mvn	r1, #1
    83ec:	e3a00008 	mov	r0, #8
    83f0:	eb0000a2 	bl	8680 <_Z5sleepjj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/sos_task/main.cpp:76 (discriminator 1)
        blink(true);
    83f4:	e3a00001 	mov	r0, #1
    83f8:	ebffff8b 	bl	822c <_Z5blinkb>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/sos_task/main.cpp:42 (discriminator 1)
        wait(button, 1, 30);
    83fc:	eaffffc7 	b	8320 <main+0x74>
    8400:	00008fa8 	andeq	r8, r0, r8, lsr #31
    8404:	00009018 	andeq	r9, r0, r8, lsl r0
    8408:	00008fb4 			; <UNDEFINED> instruction: 0x00008fb4
    840c:	0000901c 	andeq	r9, r0, ip, lsl r0
    8410:	00008fc0 	andeq	r8, r0, r0, asr #31
    8414:	00008fc4 	andeq	r8, r0, r4, asr #31

00008418 <_Z6getpidv>:
_Z6getpidv():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:5
#include <stdfile.h>
#include <stdstring.h>

uint32_t getpid()
{
    8418:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    841c:	e28db000 	add	fp, sp, #0
    8420:	e24dd00c 	sub	sp, sp, #12
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:8
    uint32_t pid;

    asm volatile("swi 0");
    8424:	ef000000 	svc	0x00000000
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:9
    asm volatile("mov %0, r0" : "=r"(pid));
    8428:	e1a03000 	mov	r3, r0
    842c:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:11

    return pid;
    8430:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:12
}
    8434:	e1a00003 	mov	r0, r3
    8438:	e28bd000 	add	sp, fp, #0
    843c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8440:	e12fff1e 	bx	lr

00008444 <_Z9terminatei>:
_Z9terminatei():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:15

void terminate(int exitcode)
{
    8444:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8448:	e28db000 	add	fp, sp, #0
    844c:	e24dd00c 	sub	sp, sp, #12
    8450:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:16
    asm volatile("mov r0, %0" : : "r"(exitcode));
    8454:	e51b3008 	ldr	r3, [fp, #-8]
    8458:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:17
    asm volatile("swi 1");
    845c:	ef000001 	svc	0x00000001
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:18
}
    8460:	e320f000 	nop	{0}
    8464:	e28bd000 	add	sp, fp, #0
    8468:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    846c:	e12fff1e 	bx	lr

00008470 <_Z11sched_yieldv>:
_Z11sched_yieldv():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:21

void sched_yield()
{
    8470:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8474:	e28db000 	add	fp, sp, #0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:22
    asm volatile("swi 2");
    8478:	ef000002 	svc	0x00000002
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:23
}
    847c:	e320f000 	nop	{0}
    8480:	e28bd000 	add	sp, fp, #0
    8484:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8488:	e12fff1e 	bx	lr

0000848c <_Z4openPKc15NFile_Open_Mode>:
_Z4openPKc15NFile_Open_Mode():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:26

uint32_t open(const char* filename, NFile_Open_Mode mode)
{
    848c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8490:	e28db000 	add	fp, sp, #0
    8494:	e24dd014 	sub	sp, sp, #20
    8498:	e50b0010 	str	r0, [fp, #-16]
    849c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:29
    uint32_t file;

    asm volatile("mov r0, %0" : : "r"(filename));
    84a0:	e51b3010 	ldr	r3, [fp, #-16]
    84a4:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:30
    asm volatile("mov r1, %0" : : "r"(mode));
    84a8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    84ac:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:31
    asm volatile("swi 64");
    84b0:	ef000040 	svc	0x00000040
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:32
    asm volatile("mov %0, r0" : "=r"(file));
    84b4:	e1a03000 	mov	r3, r0
    84b8:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:34

    return file;
    84bc:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:35
}
    84c0:	e1a00003 	mov	r0, r3
    84c4:	e28bd000 	add	sp, fp, #0
    84c8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    84cc:	e12fff1e 	bx	lr

000084d0 <_Z4readjPcj>:
_Z4readjPcj():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:38

uint32_t read(uint32_t file, char* const buffer, uint32_t size)
{
    84d0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    84d4:	e28db000 	add	fp, sp, #0
    84d8:	e24dd01c 	sub	sp, sp, #28
    84dc:	e50b0010 	str	r0, [fp, #-16]
    84e0:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    84e4:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:41
    uint32_t rdnum;

    asm volatile("mov r0, %0" : : "r"(file));
    84e8:	e51b3010 	ldr	r3, [fp, #-16]
    84ec:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:42
    asm volatile("mov r1, %0" : : "r"(buffer));
    84f0:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    84f4:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:43
    asm volatile("mov r2, %0" : : "r"(size));
    84f8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    84fc:	e1a02003 	mov	r2, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:44
    asm volatile("swi 65");
    8500:	ef000041 	svc	0x00000041
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:45
    asm volatile("mov %0, r0" : "=r"(rdnum));
    8504:	e1a03000 	mov	r3, r0
    8508:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:47

    return rdnum;
    850c:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:48
}
    8510:	e1a00003 	mov	r0, r3
    8514:	e28bd000 	add	sp, fp, #0
    8518:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    851c:	e12fff1e 	bx	lr

00008520 <_Z5writejPKcj>:
_Z5writejPKcj():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:51

uint32_t write(uint32_t file, const char* buffer, uint32_t size)
{
    8520:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8524:	e28db000 	add	fp, sp, #0
    8528:	e24dd01c 	sub	sp, sp, #28
    852c:	e50b0010 	str	r0, [fp, #-16]
    8530:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8534:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:54
    uint32_t wrnum;

    asm volatile("mov r0, %0" : : "r"(file));
    8538:	e51b3010 	ldr	r3, [fp, #-16]
    853c:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:55
    asm volatile("mov r1, %0" : : "r"(buffer));
    8540:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8544:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:56
    asm volatile("mov r2, %0" : : "r"(size));
    8548:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    854c:	e1a02003 	mov	r2, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:57
    asm volatile("swi 66");
    8550:	ef000042 	svc	0x00000042
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:58
    asm volatile("mov %0, r0" : "=r"(wrnum));
    8554:	e1a03000 	mov	r3, r0
    8558:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:60

    return wrnum;
    855c:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:61
}
    8560:	e1a00003 	mov	r0, r3
    8564:	e28bd000 	add	sp, fp, #0
    8568:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    856c:	e12fff1e 	bx	lr

00008570 <_Z5closej>:
_Z5closej():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:64

void close(uint32_t file)
{
    8570:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8574:	e28db000 	add	fp, sp, #0
    8578:	e24dd00c 	sub	sp, sp, #12
    857c:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:65
    asm volatile("mov r0, %0" : : "r"(file));
    8580:	e51b3008 	ldr	r3, [fp, #-8]
    8584:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:66
    asm volatile("swi 67");
    8588:	ef000043 	svc	0x00000043
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:67
}
    858c:	e320f000 	nop	{0}
    8590:	e28bd000 	add	sp, fp, #0
    8594:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8598:	e12fff1e 	bx	lr

0000859c <_Z5ioctlj16NIOCtl_OperationPv>:
_Z5ioctlj16NIOCtl_OperationPv():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:70

uint32_t ioctl(uint32_t file, NIOCtl_Operation operation, void* param)
{
    859c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    85a0:	e28db000 	add	fp, sp, #0
    85a4:	e24dd01c 	sub	sp, sp, #28
    85a8:	e50b0010 	str	r0, [fp, #-16]
    85ac:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    85b0:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:73
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r"(file));
    85b4:	e51b3010 	ldr	r3, [fp, #-16]
    85b8:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:74
    asm volatile("mov r1, %0" : : "r"(operation));
    85bc:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    85c0:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:75
    asm volatile("mov r2, %0" : : "r"(param));
    85c4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    85c8:	e1a02003 	mov	r2, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:76
    asm volatile("swi 68");
    85cc:	ef000044 	svc	0x00000044
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:77
    asm volatile("mov %0, r0" : "=r"(retcode));
    85d0:	e1a03000 	mov	r3, r0
    85d4:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:79

    return retcode;
    85d8:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:80
}
    85dc:	e1a00003 	mov	r0, r3
    85e0:	e28bd000 	add	sp, fp, #0
    85e4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    85e8:	e12fff1e 	bx	lr

000085ec <_Z6notifyjj>:
_Z6notifyjj():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:83

uint32_t notify(uint32_t file, uint32_t count)
{
    85ec:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    85f0:	e28db000 	add	fp, sp, #0
    85f4:	e24dd014 	sub	sp, sp, #20
    85f8:	e50b0010 	str	r0, [fp, #-16]
    85fc:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:86
    uint32_t retcnt;

    asm volatile("mov r0, %0" : : "r"(file));
    8600:	e51b3010 	ldr	r3, [fp, #-16]
    8604:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:87
    asm volatile("mov r1, %0" : : "r"(count));
    8608:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    860c:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:88
    asm volatile("swi 69");
    8610:	ef000045 	svc	0x00000045
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:89
    asm volatile("mov %0, r0" : "=r"(retcnt));
    8614:	e1a03000 	mov	r3, r0
    8618:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:91

    return retcnt;
    861c:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:92
}
    8620:	e1a00003 	mov	r0, r3
    8624:	e28bd000 	add	sp, fp, #0
    8628:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    862c:	e12fff1e 	bx	lr

00008630 <_Z4waitjjj>:
_Z4waitjjj():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:95

NSWI_Result_Code wait(uint32_t file, uint32_t count, uint32_t notified_deadline)
{
    8630:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8634:	e28db000 	add	fp, sp, #0
    8638:	e24dd01c 	sub	sp, sp, #28
    863c:	e50b0010 	str	r0, [fp, #-16]
    8640:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8644:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:98
    NSWI_Result_Code retcode;

    asm volatile("mov r0, %0" : : "r"(file));
    8648:	e51b3010 	ldr	r3, [fp, #-16]
    864c:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:99
    asm volatile("mov r1, %0" : : "r"(count));
    8650:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8654:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:100
    asm volatile("mov r2, %0" : : "r"(notified_deadline));
    8658:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    865c:	e1a02003 	mov	r2, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:101
    asm volatile("swi 70");
    8660:	ef000046 	svc	0x00000046
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:102
    asm volatile("mov %0, r0" : "=r"(retcode));
    8664:	e1a03000 	mov	r3, r0
    8668:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:104

    return retcode;
    866c:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:105
}
    8670:	e1a00003 	mov	r0, r3
    8674:	e28bd000 	add	sp, fp, #0
    8678:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    867c:	e12fff1e 	bx	lr

00008680 <_Z5sleepjj>:
_Z5sleepjj():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:108

bool sleep(uint32_t ticks, uint32_t notified_deadline)
{
    8680:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8684:	e28db000 	add	fp, sp, #0
    8688:	e24dd014 	sub	sp, sp, #20
    868c:	e50b0010 	str	r0, [fp, #-16]
    8690:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:111
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r"(ticks));
    8694:	e51b3010 	ldr	r3, [fp, #-16]
    8698:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:112
    asm volatile("mov r1, %0" : : "r"(notified_deadline));
    869c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    86a0:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:113
    asm volatile("swi 3");
    86a4:	ef000003 	svc	0x00000003
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:114
    asm volatile("mov %0, r0" : "=r"(retcode));
    86a8:	e1a03000 	mov	r3, r0
    86ac:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:116

    return retcode;
    86b0:	e51b3008 	ldr	r3, [fp, #-8]
    86b4:	e3530000 	cmp	r3, #0
    86b8:	13a03001 	movne	r3, #1
    86bc:	03a03000 	moveq	r3, #0
    86c0:	e6ef3073 	uxtb	r3, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:117
}
    86c4:	e1a00003 	mov	r0, r3
    86c8:	e28bd000 	add	sp, fp, #0
    86cc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    86d0:	e12fff1e 	bx	lr

000086d4 <_Z24get_active_process_countv>:
_Z24get_active_process_countv():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:120

uint32_t get_active_process_count()
{
    86d4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    86d8:	e28db000 	add	fp, sp, #0
    86dc:	e24dd00c 	sub	sp, sp, #12
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:121
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Active_Process_Count;
    86e0:	e3a03000 	mov	r3, #0
    86e4:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:124
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r"(req));
    86e8:	e3a03000 	mov	r3, #0
    86ec:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:125
    asm volatile("mov r1, %0" : : "r"(&retval));
    86f0:	e24b300c 	sub	r3, fp, #12
    86f4:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:126
    asm volatile("swi 4");
    86f8:	ef000004 	svc	0x00000004
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:128

    return retval;
    86fc:	e51b300c 	ldr	r3, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:129
}
    8700:	e1a00003 	mov	r0, r3
    8704:	e28bd000 	add	sp, fp, #0
    8708:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    870c:	e12fff1e 	bx	lr

00008710 <_Z14get_tick_countv>:
_Z14get_tick_countv():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:132

uint32_t get_tick_count()
{
    8710:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8714:	e28db000 	add	fp, sp, #0
    8718:	e24dd00c 	sub	sp, sp, #12
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:133
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Tick_Count;
    871c:	e3a03001 	mov	r3, #1
    8720:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:136
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r"(req));
    8724:	e3a03001 	mov	r3, #1
    8728:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:137
    asm volatile("mov r1, %0" : : "r"(&retval));
    872c:	e24b300c 	sub	r3, fp, #12
    8730:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:138
    asm volatile("swi 4");
    8734:	ef000004 	svc	0x00000004
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:140

    return retval;
    8738:	e51b300c 	ldr	r3, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:141
}
    873c:	e1a00003 	mov	r0, r3
    8740:	e28bd000 	add	sp, fp, #0
    8744:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8748:	e12fff1e 	bx	lr

0000874c <_Z17set_task_deadlinej>:
_Z17set_task_deadlinej():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:144

void set_task_deadline(uint32_t tick_count_required)
{
    874c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8750:	e28db000 	add	fp, sp, #0
    8754:	e24dd014 	sub	sp, sp, #20
    8758:	e50b0010 	str	r0, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:145
    const NDeadline_Subservice req = NDeadline_Subservice::Set_Relative;
    875c:	e3a03000 	mov	r3, #0
    8760:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:147

    asm volatile("mov r0, %0" : : "r"(req));
    8764:	e3a03000 	mov	r3, #0
    8768:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:148
    asm volatile("mov r1, %0" : : "r"(&tick_count_required));
    876c:	e24b3010 	sub	r3, fp, #16
    8770:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:149
    asm volatile("swi 5");
    8774:	ef000005 	svc	0x00000005
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:150
}
    8778:	e320f000 	nop	{0}
    877c:	e28bd000 	add	sp, fp, #0
    8780:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8784:	e12fff1e 	bx	lr

00008788 <_Z26get_task_ticks_to_deadlinev>:
_Z26get_task_ticks_to_deadlinev():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:153

uint32_t get_task_ticks_to_deadline()
{
    8788:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    878c:	e28db000 	add	fp, sp, #0
    8790:	e24dd00c 	sub	sp, sp, #12
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:154
    const NDeadline_Subservice req = NDeadline_Subservice::Get_Remaining;
    8794:	e3a03001 	mov	r3, #1
    8798:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:157
    uint32_t ticks;

    asm volatile("mov r0, %0" : : "r"(req));
    879c:	e3a03001 	mov	r3, #1
    87a0:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:158
    asm volatile("mov r1, %0" : : "r"(&ticks));
    87a4:	e24b300c 	sub	r3, fp, #12
    87a8:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:159
    asm volatile("swi 5");
    87ac:	ef000005 	svc	0x00000005
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:161

    return ticks;
    87b0:	e51b300c 	ldr	r3, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:162
}
    87b4:	e1a00003 	mov	r0, r3
    87b8:	e28bd000 	add	sp, fp, #0
    87bc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    87c0:	e12fff1e 	bx	lr

000087c4 <_Z4pipePKcj>:
_Z4pipePKcj():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:167

const char Pipe_File_Prefix[] = "SYS:pipe/";

uint32_t pipe(const char* name, uint32_t buf_size)
{
    87c4:	e92d4800 	push	{fp, lr}
    87c8:	e28db004 	add	fp, sp, #4
    87cc:	e24dd050 	sub	sp, sp, #80	; 0x50
    87d0:	e50b0050 	str	r0, [fp, #-80]	; 0xffffffb0
    87d4:	e50b1054 	str	r1, [fp, #-84]	; 0xffffffac
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:169
    char fname[64];
    strncpy(fname, Pipe_File_Prefix, sizeof(Pipe_File_Prefix));
    87d8:	e24b3048 	sub	r3, fp, #72	; 0x48
    87dc:	e3a0200a 	mov	r2, #10
    87e0:	e59f1088 	ldr	r1, [pc, #136]	; 8870 <_Z4pipePKcj+0xac>
    87e4:	e1a00003 	mov	r0, r3
    87e8:	eb0000a5 	bl	8a84 <_Z7strncpyPcPKci>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:170
    strncpy(fname + sizeof(Pipe_File_Prefix), name, sizeof(fname) - sizeof(Pipe_File_Prefix) - 1);
    87ec:	e24b3048 	sub	r3, fp, #72	; 0x48
    87f0:	e283300a 	add	r3, r3, #10
    87f4:	e3a02035 	mov	r2, #53	; 0x35
    87f8:	e51b1050 	ldr	r1, [fp, #-80]	; 0xffffffb0
    87fc:	e1a00003 	mov	r0, r3
    8800:	eb00009f 	bl	8a84 <_Z7strncpyPcPKci>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:172

    int ncur = sizeof(Pipe_File_Prefix) + strlen(name);
    8804:	e51b0050 	ldr	r0, [fp, #-80]	; 0xffffffb0
    8808:	eb0000f8 	bl	8bf0 <_Z6strlenPKc>
    880c:	e1a03000 	mov	r3, r0
    8810:	e283300a 	add	r3, r3, #10
    8814:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:174

    fname[ncur++] = '#';
    8818:	e51b3008 	ldr	r3, [fp, #-8]
    881c:	e2832001 	add	r2, r3, #1
    8820:	e50b2008 	str	r2, [fp, #-8]
    8824:	e2433004 	sub	r3, r3, #4
    8828:	e083300b 	add	r3, r3, fp
    882c:	e3a02023 	mov	r2, #35	; 0x23
    8830:	e5432044 	strb	r2, [r3, #-68]	; 0xffffffbc
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:176

    itoa(buf_size, &fname[ncur], 10);
    8834:	e24b2048 	sub	r2, fp, #72	; 0x48
    8838:	e51b3008 	ldr	r3, [fp, #-8]
    883c:	e0823003 	add	r3, r2, r3
    8840:	e3a0200a 	mov	r2, #10
    8844:	e1a01003 	mov	r1, r3
    8848:	e51b0054 	ldr	r0, [fp, #-84]	; 0xffffffac
    884c:	eb000008 	bl	8874 <_Z4itoajPcj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:178

    return open(fname, NFile_Open_Mode::Read_Write);
    8850:	e24b3048 	sub	r3, fp, #72	; 0x48
    8854:	e3a01002 	mov	r1, #2
    8858:	e1a00003 	mov	r0, r3
    885c:	ebffff0a 	bl	848c <_Z4openPKc15NFile_Open_Mode>
    8860:	e1a03000 	mov	r3, r0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:179
}
    8864:	e1a00003 	mov	r0, r3
    8868:	e24bd004 	sub	sp, fp, #4
    886c:	e8bd8800 	pop	{fp, pc}
    8870:	00008ff8 	strdeq	r8, [r0], -r8	; <UNPREDICTABLE>

00008874 <_Z4itoajPcj>:
_Z4itoajPcj():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:9
{
    const char CharConvArr[] = "0123456789ABCDEF";
}

void itoa(unsigned int input, char* output, unsigned int base)
{
    8874:	e92d4800 	push	{fp, lr}
    8878:	e28db004 	add	fp, sp, #4
    887c:	e24dd020 	sub	sp, sp, #32
    8880:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8884:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    8888:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:10
    int i = 0;
    888c:	e3a03000 	mov	r3, #0
    8890:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:12

    while (input > 0)
    8894:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8898:	e3530000 	cmp	r3, #0
    889c:	0a000014 	beq	88f4 <_Z4itoajPcj+0x80>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:14
    {
        output[i] = CharConvArr[input % base];
    88a0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    88a4:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    88a8:	e1a00003 	mov	r0, r3
    88ac:	eb000199 	bl	8f18 <__aeabi_uidivmod>
    88b0:	e1a03001 	mov	r3, r1
    88b4:	e1a01003 	mov	r1, r3
    88b8:	e51b3008 	ldr	r3, [fp, #-8]
    88bc:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    88c0:	e0823003 	add	r3, r2, r3
    88c4:	e59f2118 	ldr	r2, [pc, #280]	; 89e4 <_Z4itoajPcj+0x170>
    88c8:	e7d22001 	ldrb	r2, [r2, r1]
    88cc:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:15
        input /= base;
    88d0:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    88d4:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    88d8:	eb000113 	bl	8d2c <__udivsi3>
    88dc:	e1a03000 	mov	r3, r0
    88e0:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:16
        i++;
    88e4:	e51b3008 	ldr	r3, [fp, #-8]
    88e8:	e2833001 	add	r3, r3, #1
    88ec:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:12
    while (input > 0)
    88f0:	eaffffe7 	b	8894 <_Z4itoajPcj+0x20>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:19
    }

    if (i == 0)
    88f4:	e51b3008 	ldr	r3, [fp, #-8]
    88f8:	e3530000 	cmp	r3, #0
    88fc:	1a000007 	bne	8920 <_Z4itoajPcj+0xac>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:21
    {
        output[i] = CharConvArr[0];
    8900:	e51b3008 	ldr	r3, [fp, #-8]
    8904:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8908:	e0823003 	add	r3, r2, r3
    890c:	e3a02030 	mov	r2, #48	; 0x30
    8910:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:22
        i++;
    8914:	e51b3008 	ldr	r3, [fp, #-8]
    8918:	e2833001 	add	r3, r3, #1
    891c:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:25
    }

    output[i] = '\0';
    8920:	e51b3008 	ldr	r3, [fp, #-8]
    8924:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8928:	e0823003 	add	r3, r2, r3
    892c:	e3a02000 	mov	r2, #0
    8930:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:26
    i--;
    8934:	e51b3008 	ldr	r3, [fp, #-8]
    8938:	e2433001 	sub	r3, r3, #1
    893c:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:28

    for (int j = 0; j <= i / 2; j++)
    8940:	e3a03000 	mov	r3, #0
    8944:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:28 (discriminator 3)
    8948:	e51b3008 	ldr	r3, [fp, #-8]
    894c:	e1a02fa3 	lsr	r2, r3, #31
    8950:	e0823003 	add	r3, r2, r3
    8954:	e1a030c3 	asr	r3, r3, #1
    8958:	e1a02003 	mov	r2, r3
    895c:	e51b300c 	ldr	r3, [fp, #-12]
    8960:	e1530002 	cmp	r3, r2
    8964:	ca00001b 	bgt	89d8 <_Z4itoajPcj+0x164>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:30 (discriminator 2)
    {
        char c = output[i - j];
    8968:	e51b2008 	ldr	r2, [fp, #-8]
    896c:	e51b300c 	ldr	r3, [fp, #-12]
    8970:	e0423003 	sub	r3, r2, r3
    8974:	e1a02003 	mov	r2, r3
    8978:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    897c:	e0833002 	add	r3, r3, r2
    8980:	e5d33000 	ldrb	r3, [r3]
    8984:	e54b300d 	strb	r3, [fp, #-13]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:31 (discriminator 2)
        output[i - j] = output[j];
    8988:	e51b300c 	ldr	r3, [fp, #-12]
    898c:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8990:	e0822003 	add	r2, r2, r3
    8994:	e51b1008 	ldr	r1, [fp, #-8]
    8998:	e51b300c 	ldr	r3, [fp, #-12]
    899c:	e0413003 	sub	r3, r1, r3
    89a0:	e1a01003 	mov	r1, r3
    89a4:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    89a8:	e0833001 	add	r3, r3, r1
    89ac:	e5d22000 	ldrb	r2, [r2]
    89b0:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:32 (discriminator 2)
        output[j] = c;
    89b4:	e51b300c 	ldr	r3, [fp, #-12]
    89b8:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    89bc:	e0823003 	add	r3, r2, r3
    89c0:	e55b200d 	ldrb	r2, [fp, #-13]
    89c4:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:28 (discriminator 2)
    for (int j = 0; j <= i / 2; j++)
    89c8:	e51b300c 	ldr	r3, [fp, #-12]
    89cc:	e2833001 	add	r3, r3, #1
    89d0:	e50b300c 	str	r3, [fp, #-12]
    89d4:	eaffffdb 	b	8948 <_Z4itoajPcj+0xd4>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:34
    }
}
    89d8:	e320f000 	nop	{0}
    89dc:	e24bd004 	sub	sp, fp, #4
    89e0:	e8bd8800 	pop	{fp, pc}
    89e4:	00009004 	andeq	r9, r0, r4

000089e8 <_Z4atoiPKc>:
_Z4atoiPKc():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:37

int atoi(const char* input)
{
    89e8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    89ec:	e28db000 	add	fp, sp, #0
    89f0:	e24dd014 	sub	sp, sp, #20
    89f4:	e50b0010 	str	r0, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:38
    int output = 0;
    89f8:	e3a03000 	mov	r3, #0
    89fc:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:40

    while (*input != '\0')
    8a00:	e51b3010 	ldr	r3, [fp, #-16]
    8a04:	e5d33000 	ldrb	r3, [r3]
    8a08:	e3530000 	cmp	r3, #0
    8a0c:	0a000017 	beq	8a70 <_Z4atoiPKc+0x88>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:42
    {
        output *= 10;
    8a10:	e51b2008 	ldr	r2, [fp, #-8]
    8a14:	e1a03002 	mov	r3, r2
    8a18:	e1a03103 	lsl	r3, r3, #2
    8a1c:	e0833002 	add	r3, r3, r2
    8a20:	e1a03083 	lsl	r3, r3, #1
    8a24:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:43
        if (*input > '9' || *input < '0')
    8a28:	e51b3010 	ldr	r3, [fp, #-16]
    8a2c:	e5d33000 	ldrb	r3, [r3]
    8a30:	e3530039 	cmp	r3, #57	; 0x39
    8a34:	8a00000d 	bhi	8a70 <_Z4atoiPKc+0x88>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:43 (discriminator 1)
    8a38:	e51b3010 	ldr	r3, [fp, #-16]
    8a3c:	e5d33000 	ldrb	r3, [r3]
    8a40:	e353002f 	cmp	r3, #47	; 0x2f
    8a44:	9a000009 	bls	8a70 <_Z4atoiPKc+0x88>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:46
            break;

        output += *input - '0';
    8a48:	e51b3010 	ldr	r3, [fp, #-16]
    8a4c:	e5d33000 	ldrb	r3, [r3]
    8a50:	e2433030 	sub	r3, r3, #48	; 0x30
    8a54:	e51b2008 	ldr	r2, [fp, #-8]
    8a58:	e0823003 	add	r3, r2, r3
    8a5c:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:48

        input++;
    8a60:	e51b3010 	ldr	r3, [fp, #-16]
    8a64:	e2833001 	add	r3, r3, #1
    8a68:	e50b3010 	str	r3, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:40
    while (*input != '\0')
    8a6c:	eaffffe3 	b	8a00 <_Z4atoiPKc+0x18>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:51
    }

    return output;
    8a70:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:52
}
    8a74:	e1a00003 	mov	r0, r3
    8a78:	e28bd000 	add	sp, fp, #0
    8a7c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8a80:	e12fff1e 	bx	lr

00008a84 <_Z7strncpyPcPKci>:
_Z7strncpyPcPKci():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:55

char* strncpy(char* dest, const char* src, int num)
{
    8a84:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8a88:	e28db000 	add	fp, sp, #0
    8a8c:	e24dd01c 	sub	sp, sp, #28
    8a90:	e50b0010 	str	r0, [fp, #-16]
    8a94:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8a98:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:58
    int i;

    for (i = 0; i < num && src[i] != '\0'; i++)
    8a9c:	e3a03000 	mov	r3, #0
    8aa0:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:58 (discriminator 4)
    8aa4:	e51b2008 	ldr	r2, [fp, #-8]
    8aa8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8aac:	e1520003 	cmp	r2, r3
    8ab0:	aa000011 	bge	8afc <_Z7strncpyPcPKci+0x78>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:58 (discriminator 2)
    8ab4:	e51b3008 	ldr	r3, [fp, #-8]
    8ab8:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8abc:	e0823003 	add	r3, r2, r3
    8ac0:	e5d33000 	ldrb	r3, [r3]
    8ac4:	e3530000 	cmp	r3, #0
    8ac8:	0a00000b 	beq	8afc <_Z7strncpyPcPKci+0x78>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:59 (discriminator 3)
        dest[i] = src[i];
    8acc:	e51b3008 	ldr	r3, [fp, #-8]
    8ad0:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8ad4:	e0822003 	add	r2, r2, r3
    8ad8:	e51b3008 	ldr	r3, [fp, #-8]
    8adc:	e51b1010 	ldr	r1, [fp, #-16]
    8ae0:	e0813003 	add	r3, r1, r3
    8ae4:	e5d22000 	ldrb	r2, [r2]
    8ae8:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:58 (discriminator 3)
    for (i = 0; i < num && src[i] != '\0'; i++)
    8aec:	e51b3008 	ldr	r3, [fp, #-8]
    8af0:	e2833001 	add	r3, r3, #1
    8af4:	e50b3008 	str	r3, [fp, #-8]
    8af8:	eaffffe9 	b	8aa4 <_Z7strncpyPcPKci+0x20>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:60 (discriminator 2)
    for (; i < num; i++)
    8afc:	e51b2008 	ldr	r2, [fp, #-8]
    8b00:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8b04:	e1520003 	cmp	r2, r3
    8b08:	aa000008 	bge	8b30 <_Z7strncpyPcPKci+0xac>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:61 (discriminator 1)
        dest[i] = '\0';
    8b0c:	e51b3008 	ldr	r3, [fp, #-8]
    8b10:	e51b2010 	ldr	r2, [fp, #-16]
    8b14:	e0823003 	add	r3, r2, r3
    8b18:	e3a02000 	mov	r2, #0
    8b1c:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:60 (discriminator 1)
    for (; i < num; i++)
    8b20:	e51b3008 	ldr	r3, [fp, #-8]
    8b24:	e2833001 	add	r3, r3, #1
    8b28:	e50b3008 	str	r3, [fp, #-8]
    8b2c:	eafffff2 	b	8afc <_Z7strncpyPcPKci+0x78>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:63

    return dest;
    8b30:	e51b3010 	ldr	r3, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:64
}
    8b34:	e1a00003 	mov	r0, r3
    8b38:	e28bd000 	add	sp, fp, #0
    8b3c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8b40:	e12fff1e 	bx	lr

00008b44 <_Z7strncmpPKcS0_i>:
_Z7strncmpPKcS0_i():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:67

int strncmp(const char* s1, const char* s2, int num)
{
    8b44:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8b48:	e28db000 	add	fp, sp, #0
    8b4c:	e24dd01c 	sub	sp, sp, #28
    8b50:	e50b0010 	str	r0, [fp, #-16]
    8b54:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8b58:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:69
    unsigned char u1, u2;
    while (num-- > 0)
    8b5c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8b60:	e2432001 	sub	r2, r3, #1
    8b64:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
    8b68:	e3530000 	cmp	r3, #0
    8b6c:	c3a03001 	movgt	r3, #1
    8b70:	d3a03000 	movle	r3, #0
    8b74:	e6ef3073 	uxtb	r3, r3
    8b78:	e3530000 	cmp	r3, #0
    8b7c:	0a000016 	beq	8bdc <_Z7strncmpPKcS0_i+0x98>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:71
    {
        u1 = (unsigned char)*s1++;
    8b80:	e51b3010 	ldr	r3, [fp, #-16]
    8b84:	e2832001 	add	r2, r3, #1
    8b88:	e50b2010 	str	r2, [fp, #-16]
    8b8c:	e5d33000 	ldrb	r3, [r3]
    8b90:	e54b3005 	strb	r3, [fp, #-5]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:72
        u2 = (unsigned char)*s2++;
    8b94:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8b98:	e2832001 	add	r2, r3, #1
    8b9c:	e50b2014 	str	r2, [fp, #-20]	; 0xffffffec
    8ba0:	e5d33000 	ldrb	r3, [r3]
    8ba4:	e54b3006 	strb	r3, [fp, #-6]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:73
        if (u1 != u2)
    8ba8:	e55b2005 	ldrb	r2, [fp, #-5]
    8bac:	e55b3006 	ldrb	r3, [fp, #-6]
    8bb0:	e1520003 	cmp	r2, r3
    8bb4:	0a000003 	beq	8bc8 <_Z7strncmpPKcS0_i+0x84>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:74
            return u1 - u2;
    8bb8:	e55b2005 	ldrb	r2, [fp, #-5]
    8bbc:	e55b3006 	ldrb	r3, [fp, #-6]
    8bc0:	e0423003 	sub	r3, r2, r3
    8bc4:	ea000005 	b	8be0 <_Z7strncmpPKcS0_i+0x9c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:75
        if (u1 == '\0')
    8bc8:	e55b3005 	ldrb	r3, [fp, #-5]
    8bcc:	e3530000 	cmp	r3, #0
    8bd0:	1affffe1 	bne	8b5c <_Z7strncmpPKcS0_i+0x18>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:76
            return 0;
    8bd4:	e3a03000 	mov	r3, #0
    8bd8:	ea000000 	b	8be0 <_Z7strncmpPKcS0_i+0x9c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:79
    }

    return 0;
    8bdc:	e3a03000 	mov	r3, #0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:80
}
    8be0:	e1a00003 	mov	r0, r3
    8be4:	e28bd000 	add	sp, fp, #0
    8be8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8bec:	e12fff1e 	bx	lr

00008bf0 <_Z6strlenPKc>:
_Z6strlenPKc():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:83

int strlen(const char* s)
{
    8bf0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8bf4:	e28db000 	add	fp, sp, #0
    8bf8:	e24dd014 	sub	sp, sp, #20
    8bfc:	e50b0010 	str	r0, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:84
    int i = 0;
    8c00:	e3a03000 	mov	r3, #0
    8c04:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:86

    while (s[i] != '\0')
    8c08:	e51b3008 	ldr	r3, [fp, #-8]
    8c0c:	e51b2010 	ldr	r2, [fp, #-16]
    8c10:	e0823003 	add	r3, r2, r3
    8c14:	e5d33000 	ldrb	r3, [r3]
    8c18:	e3530000 	cmp	r3, #0
    8c1c:	0a000003 	beq	8c30 <_Z6strlenPKc+0x40>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:87
        i++;
    8c20:	e51b3008 	ldr	r3, [fp, #-8]
    8c24:	e2833001 	add	r3, r3, #1
    8c28:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:86
    while (s[i] != '\0')
    8c2c:	eafffff5 	b	8c08 <_Z6strlenPKc+0x18>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:89

    return i;
    8c30:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:90
}
    8c34:	e1a00003 	mov	r0, r3
    8c38:	e28bd000 	add	sp, fp, #0
    8c3c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8c40:	e12fff1e 	bx	lr

00008c44 <_Z5bzeroPvi>:
_Z5bzeroPvi():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:93

void bzero(void* memory, int length)
{
    8c44:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8c48:	e28db000 	add	fp, sp, #0
    8c4c:	e24dd014 	sub	sp, sp, #20
    8c50:	e50b0010 	str	r0, [fp, #-16]
    8c54:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:94
    char* mem = reinterpret_cast<char*>(memory);
    8c58:	e51b3010 	ldr	r3, [fp, #-16]
    8c5c:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:96

    for (int i = 0; i < length; i++)
    8c60:	e3a03000 	mov	r3, #0
    8c64:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:96 (discriminator 3)
    8c68:	e51b2008 	ldr	r2, [fp, #-8]
    8c6c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8c70:	e1520003 	cmp	r2, r3
    8c74:	aa000008 	bge	8c9c <_Z5bzeroPvi+0x58>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:97 (discriminator 2)
        mem[i] = 0;
    8c78:	e51b3008 	ldr	r3, [fp, #-8]
    8c7c:	e51b200c 	ldr	r2, [fp, #-12]
    8c80:	e0823003 	add	r3, r2, r3
    8c84:	e3a02000 	mov	r2, #0
    8c88:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:96 (discriminator 2)
    for (int i = 0; i < length; i++)
    8c8c:	e51b3008 	ldr	r3, [fp, #-8]
    8c90:	e2833001 	add	r3, r3, #1
    8c94:	e50b3008 	str	r3, [fp, #-8]
    8c98:	eafffff2 	b	8c68 <_Z5bzeroPvi+0x24>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:98
}
    8c9c:	e320f000 	nop	{0}
    8ca0:	e28bd000 	add	sp, fp, #0
    8ca4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8ca8:	e12fff1e 	bx	lr

00008cac <_Z6memcpyPKvPvi>:
_Z6memcpyPKvPvi():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:101

void memcpy(const void* src, void* dst, int num)
{
    8cac:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8cb0:	e28db000 	add	fp, sp, #0
    8cb4:	e24dd024 	sub	sp, sp, #36	; 0x24
    8cb8:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8cbc:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    8cc0:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:102
    const char* memsrc = reinterpret_cast<const char*>(src);
    8cc4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8cc8:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:103
    char* memdst = reinterpret_cast<char*>(dst);
    8ccc:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8cd0:	e50b3010 	str	r3, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:105

    for (int i = 0; i < num; i++)
    8cd4:	e3a03000 	mov	r3, #0
    8cd8:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:105 (discriminator 3)
    8cdc:	e51b2008 	ldr	r2, [fp, #-8]
    8ce0:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8ce4:	e1520003 	cmp	r2, r3
    8ce8:	aa00000b 	bge	8d1c <_Z6memcpyPKvPvi+0x70>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:106 (discriminator 2)
        memdst[i] = memsrc[i];
    8cec:	e51b3008 	ldr	r3, [fp, #-8]
    8cf0:	e51b200c 	ldr	r2, [fp, #-12]
    8cf4:	e0822003 	add	r2, r2, r3
    8cf8:	e51b3008 	ldr	r3, [fp, #-8]
    8cfc:	e51b1010 	ldr	r1, [fp, #-16]
    8d00:	e0813003 	add	r3, r1, r3
    8d04:	e5d22000 	ldrb	r2, [r2]
    8d08:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:105 (discriminator 2)
    for (int i = 0; i < num; i++)
    8d0c:	e51b3008 	ldr	r3, [fp, #-8]
    8d10:	e2833001 	add	r3, r3, #1
    8d14:	e50b3008 	str	r3, [fp, #-8]
    8d18:	eaffffef 	b	8cdc <_Z6memcpyPKvPvi+0x30>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:107
}
    8d1c:	e320f000 	nop	{0}
    8d20:	e28bd000 	add	sp, fp, #0
    8d24:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8d28:	e12fff1e 	bx	lr

00008d2c <__udivsi3>:
__udivsi3():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1104
    8d2c:	e2512001 	subs	r2, r1, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1106
    8d30:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1107
    8d34:	3a000074 	bcc	8f0c <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1108
    8d38:	e1500001 	cmp	r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1109
    8d3c:	9a00006b 	bls	8ef0 <__udivsi3+0x1c4>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1110
    8d40:	e1110002 	tst	r1, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1111
    8d44:	0a00006c 	beq	8efc <__udivsi3+0x1d0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1113
    8d48:	e16f3f10 	clz	r3, r0
    8d4c:	e16f2f11 	clz	r2, r1
    8d50:	e0423003 	sub	r3, r2, r3
    8d54:	e273301f 	rsbs	r3, r3, #31
    8d58:	10833083 	addne	r3, r3, r3, lsl #1
    8d5c:	e3a02000 	mov	r2, #0
    8d60:	108ff103 	addne	pc, pc, r3, lsl #2
    8d64:	e1a00000 	nop			; (mov r0, r0)
    8d68:	e1500f81 	cmp	r0, r1, lsl #31
    8d6c:	e0a22002 	adc	r2, r2, r2
    8d70:	20400f81 	subcs	r0, r0, r1, lsl #31
    8d74:	e1500f01 	cmp	r0, r1, lsl #30
    8d78:	e0a22002 	adc	r2, r2, r2
    8d7c:	20400f01 	subcs	r0, r0, r1, lsl #30
    8d80:	e1500e81 	cmp	r0, r1, lsl #29
    8d84:	e0a22002 	adc	r2, r2, r2
    8d88:	20400e81 	subcs	r0, r0, r1, lsl #29
    8d8c:	e1500e01 	cmp	r0, r1, lsl #28
    8d90:	e0a22002 	adc	r2, r2, r2
    8d94:	20400e01 	subcs	r0, r0, r1, lsl #28
    8d98:	e1500d81 	cmp	r0, r1, lsl #27
    8d9c:	e0a22002 	adc	r2, r2, r2
    8da0:	20400d81 	subcs	r0, r0, r1, lsl #27
    8da4:	e1500d01 	cmp	r0, r1, lsl #26
    8da8:	e0a22002 	adc	r2, r2, r2
    8dac:	20400d01 	subcs	r0, r0, r1, lsl #26
    8db0:	e1500c81 	cmp	r0, r1, lsl #25
    8db4:	e0a22002 	adc	r2, r2, r2
    8db8:	20400c81 	subcs	r0, r0, r1, lsl #25
    8dbc:	e1500c01 	cmp	r0, r1, lsl #24
    8dc0:	e0a22002 	adc	r2, r2, r2
    8dc4:	20400c01 	subcs	r0, r0, r1, lsl #24
    8dc8:	e1500b81 	cmp	r0, r1, lsl #23
    8dcc:	e0a22002 	adc	r2, r2, r2
    8dd0:	20400b81 	subcs	r0, r0, r1, lsl #23
    8dd4:	e1500b01 	cmp	r0, r1, lsl #22
    8dd8:	e0a22002 	adc	r2, r2, r2
    8ddc:	20400b01 	subcs	r0, r0, r1, lsl #22
    8de0:	e1500a81 	cmp	r0, r1, lsl #21
    8de4:	e0a22002 	adc	r2, r2, r2
    8de8:	20400a81 	subcs	r0, r0, r1, lsl #21
    8dec:	e1500a01 	cmp	r0, r1, lsl #20
    8df0:	e0a22002 	adc	r2, r2, r2
    8df4:	20400a01 	subcs	r0, r0, r1, lsl #20
    8df8:	e1500981 	cmp	r0, r1, lsl #19
    8dfc:	e0a22002 	adc	r2, r2, r2
    8e00:	20400981 	subcs	r0, r0, r1, lsl #19
    8e04:	e1500901 	cmp	r0, r1, lsl #18
    8e08:	e0a22002 	adc	r2, r2, r2
    8e0c:	20400901 	subcs	r0, r0, r1, lsl #18
    8e10:	e1500881 	cmp	r0, r1, lsl #17
    8e14:	e0a22002 	adc	r2, r2, r2
    8e18:	20400881 	subcs	r0, r0, r1, lsl #17
    8e1c:	e1500801 	cmp	r0, r1, lsl #16
    8e20:	e0a22002 	adc	r2, r2, r2
    8e24:	20400801 	subcs	r0, r0, r1, lsl #16
    8e28:	e1500781 	cmp	r0, r1, lsl #15
    8e2c:	e0a22002 	adc	r2, r2, r2
    8e30:	20400781 	subcs	r0, r0, r1, lsl #15
    8e34:	e1500701 	cmp	r0, r1, lsl #14
    8e38:	e0a22002 	adc	r2, r2, r2
    8e3c:	20400701 	subcs	r0, r0, r1, lsl #14
    8e40:	e1500681 	cmp	r0, r1, lsl #13
    8e44:	e0a22002 	adc	r2, r2, r2
    8e48:	20400681 	subcs	r0, r0, r1, lsl #13
    8e4c:	e1500601 	cmp	r0, r1, lsl #12
    8e50:	e0a22002 	adc	r2, r2, r2
    8e54:	20400601 	subcs	r0, r0, r1, lsl #12
    8e58:	e1500581 	cmp	r0, r1, lsl #11
    8e5c:	e0a22002 	adc	r2, r2, r2
    8e60:	20400581 	subcs	r0, r0, r1, lsl #11
    8e64:	e1500501 	cmp	r0, r1, lsl #10
    8e68:	e0a22002 	adc	r2, r2, r2
    8e6c:	20400501 	subcs	r0, r0, r1, lsl #10
    8e70:	e1500481 	cmp	r0, r1, lsl #9
    8e74:	e0a22002 	adc	r2, r2, r2
    8e78:	20400481 	subcs	r0, r0, r1, lsl #9
    8e7c:	e1500401 	cmp	r0, r1, lsl #8
    8e80:	e0a22002 	adc	r2, r2, r2
    8e84:	20400401 	subcs	r0, r0, r1, lsl #8
    8e88:	e1500381 	cmp	r0, r1, lsl #7
    8e8c:	e0a22002 	adc	r2, r2, r2
    8e90:	20400381 	subcs	r0, r0, r1, lsl #7
    8e94:	e1500301 	cmp	r0, r1, lsl #6
    8e98:	e0a22002 	adc	r2, r2, r2
    8e9c:	20400301 	subcs	r0, r0, r1, lsl #6
    8ea0:	e1500281 	cmp	r0, r1, lsl #5
    8ea4:	e0a22002 	adc	r2, r2, r2
    8ea8:	20400281 	subcs	r0, r0, r1, lsl #5
    8eac:	e1500201 	cmp	r0, r1, lsl #4
    8eb0:	e0a22002 	adc	r2, r2, r2
    8eb4:	20400201 	subcs	r0, r0, r1, lsl #4
    8eb8:	e1500181 	cmp	r0, r1, lsl #3
    8ebc:	e0a22002 	adc	r2, r2, r2
    8ec0:	20400181 	subcs	r0, r0, r1, lsl #3
    8ec4:	e1500101 	cmp	r0, r1, lsl #2
    8ec8:	e0a22002 	adc	r2, r2, r2
    8ecc:	20400101 	subcs	r0, r0, r1, lsl #2
    8ed0:	e1500081 	cmp	r0, r1, lsl #1
    8ed4:	e0a22002 	adc	r2, r2, r2
    8ed8:	20400081 	subcs	r0, r0, r1, lsl #1
    8edc:	e1500001 	cmp	r0, r1
    8ee0:	e0a22002 	adc	r2, r2, r2
    8ee4:	20400001 	subcs	r0, r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1115
    8ee8:	e1a00002 	mov	r0, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1116
    8eec:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1119
    8ef0:	03a00001 	moveq	r0, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1120
    8ef4:	13a00000 	movne	r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1121
    8ef8:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1123
    8efc:	e16f2f11 	clz	r2, r1
    8f00:	e262201f 	rsb	r2, r2, #31
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1125
    8f04:	e1a00230 	lsr	r0, r0, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1126
    8f08:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1130
    8f0c:	e3500000 	cmp	r0, #0
    8f10:	13e00000 	mvnne	r0, #0
    8f14:	ea000007 	b	8f38 <__aeabi_idiv0>

00008f18 <__aeabi_uidivmod>:
__aeabi_uidivmod():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1161
    8f18:	e3510000 	cmp	r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1162
    8f1c:	0afffffa 	beq	8f0c <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1163
    8f20:	e92d4003 	push	{r0, r1, lr}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1164
    8f24:	ebffff80 	bl	8d2c <__udivsi3>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1165
    8f28:	e8bd4006 	pop	{r1, r2, lr}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1166
    8f2c:	e0030092 	mul	r3, r2, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1167
    8f30:	e0411003 	sub	r1, r1, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1168
    8f34:	e12fff1e 	bx	lr

00008f38 <__aeabi_idiv0>:
__aeabi_ldiv0():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1466
    8f38:	e12fff1e 	bx	lr

Disassembly of section .rodata:

00008f3c <_ZL13Lock_Unlocked>:
    8f3c:	00000000 	andeq	r0, r0, r0

00008f40 <_ZL11Lock_Locked>:
    8f40:	00000001 	andeq	r0, r0, r1

00008f44 <_ZL21MaxFSDriverNameLength>:
    8f44:	00000010 	andeq	r0, r0, r0, lsl r0

00008f48 <_ZL17MaxFilenameLength>:
    8f48:	00000010 	andeq	r0, r0, r0, lsl r0

00008f4c <_ZL13MaxPathLength>:
    8f4c:	00000080 	andeq	r0, r0, r0, lsl #1

00008f50 <_ZL18NoFilesystemDriver>:
    8f50:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008f54 <_ZL9NotifyAll>:
    8f54:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008f58 <_ZL24Max_Process_Opened_Files>:
    8f58:	00000010 	andeq	r0, r0, r0, lsl r0

00008f5c <_ZL10Indefinite>:
    8f5c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008f60 <_ZL18Deadline_Unchanged>:
    8f60:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00008f64 <_ZL14Invalid_Handle>:
    8f64:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008f68 <_ZN3halL18Default_Clock_RateE>:
    8f68:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

00008f6c <_ZN3halL15Peripheral_BaseE>:
    8f6c:	20000000 	andcs	r0, r0, r0

00008f70 <_ZN3halL9GPIO_BaseE>:
    8f70:	20200000 	eorcs	r0, r0, r0

00008f74 <_ZN3halL14GPIO_Pin_CountE>:
    8f74:	00000036 	andeq	r0, r0, r6, lsr r0

00008f78 <_ZN3halL8AUX_BaseE>:
    8f78:	20215000 	eorcs	r5, r1, r0

00008f7c <_ZN3halL25Interrupt_Controller_BaseE>:
    8f7c:	2000b200 	andcs	fp, r0, r0, lsl #4

00008f80 <_ZN3halL10Timer_BaseE>:
    8f80:	2000b400 	andcs	fp, r0, r0, lsl #8

00008f84 <_ZN3halL9TRNG_BaseE>:
    8f84:	20104000 	andscs	r4, r0, r0

00008f88 <_ZN3halL9BSC0_BaseE>:
    8f88:	20205000 	eorcs	r5, r0, r0

00008f8c <_ZN3halL9BSC1_BaseE>:
    8f8c:	20804000 	addcs	r4, r0, r0

00008f90 <_ZN3halL9BSC2_BaseE>:
    8f90:	20805000 	addcs	r5, r0, r0

00008f94 <_ZL11Invalid_Pin>:
    8f94:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008f98 <_ZL17symbol_tick_delay>:
    8f98:	00000008 	andeq	r0, r0, r8

00008f9c <_ZL15char_tick_delay>:
    8f9c:	00000002 	andeq	r0, r0, r2
    8fa0:	00000031 	andeq	r0, r0, r1, lsr r0
    8fa4:	00000030 	andeq	r0, r0, r0, lsr r0
    8fa8:	3a564544 	bcc	159a4c0 <__bss_end+0x1591490>
    8fac:	6f697067 	svcvs	0x00697067
    8fb0:	0038312f 	eorseq	r3, r8, pc, lsr #2
    8fb4:	3a564544 	bcc	159a4cc <__bss_end+0x159149c>
    8fb8:	6f697067 	svcvs	0x00697067
    8fbc:	0036312f 	eorseq	r3, r6, pc, lsr #2
    8fc0:	00676f6c 	rsbeq	r6, r7, ip, ror #30
    8fc4:	21534f53 	cmpcs	r3, r3, asr pc
    8fc8:	00000000 	andeq	r0, r0, r0

00008fcc <_ZL13Lock_Unlocked>:
    8fcc:	00000000 	andeq	r0, r0, r0

00008fd0 <_ZL11Lock_Locked>:
    8fd0:	00000001 	andeq	r0, r0, r1

00008fd4 <_ZL21MaxFSDriverNameLength>:
    8fd4:	00000010 	andeq	r0, r0, r0, lsl r0

00008fd8 <_ZL17MaxFilenameLength>:
    8fd8:	00000010 	andeq	r0, r0, r0, lsl r0

00008fdc <_ZL13MaxPathLength>:
    8fdc:	00000080 	andeq	r0, r0, r0, lsl #1

00008fe0 <_ZL18NoFilesystemDriver>:
    8fe0:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008fe4 <_ZL9NotifyAll>:
    8fe4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008fe8 <_ZL24Max_Process_Opened_Files>:
    8fe8:	00000010 	andeq	r0, r0, r0, lsl r0

00008fec <_ZL10Indefinite>:
    8fec:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008ff0 <_ZL18Deadline_Unchanged>:
    8ff0:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00008ff4 <_ZL14Invalid_Handle>:
    8ff4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008ff8 <_ZL16Pipe_File_Prefix>:
    8ff8:	3a535953 	bcc	14df54c <__bss_end+0x14d651c>
    8ffc:	65706970 	ldrbvs	r6, [r0, #-2416]!	; 0xfffff690
    9000:	0000002f 	andeq	r0, r0, pc, lsr #32

00009004 <_ZN12_GLOBAL__N_1L11CharConvArrE>:
    9004:	33323130 	teqcc	r2, #48, 2
    9008:	37363534 			; <UNDEFINED> instruction: 0x37363534
    900c:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    9010:	46454443 	strbmi	r4, [r5], -r3, asr #8
	...

Disassembly of section .bss:

00009018 <sos_led>:
__bss_start():
    9018:	00000000 	andeq	r0, r0, r0

0000901c <button>:
	...

Disassembly of section .ARM.attributes:

00000000 <.ARM.attributes>:
   0:	00002e41 	andeq	r2, r0, r1, asr #28
   4:	61656100 	cmnvs	r5, r0, lsl #2
   8:	01006962 	tsteq	r0, r2, ror #18
   c:	00000024 	andeq	r0, r0, r4, lsr #32
  10:	4b5a3605 	blmi	168d82c <__bss_end+0x16847fc>
  14:	08070600 	stmdaeq	r7, {r9, sl}
  18:	0a010901 	beq	42424 <__bss_end+0x393f4>
  1c:	14041202 	strne	r1, [r4], #-514	; 0xfffffdfe
  20:	17011501 	strne	r1, [r1, -r1, lsl #10]
  24:	1a011803 	bne	46038 <__bss_end+0x3d008>
  28:	22011c01 	andcs	r1, r1, #256	; 0x100
  2c:	Address 0x000000000000002c is out of bounds.


Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347 	bcc	10d0d24 <__bss_end+0x10c7cf4>
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
  34:	5a2f7374 	bpl	bdce0c <__bss_end+0xbd3ddc>
  38:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; fffffeac <__bss_end+0xffff6e7c>
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
 10c:	05053412 	streq	r3, [r5, #-1042]	; 0xfffffbee
 110:	054b3185 	strbeq	r3, [fp, #-389]	; 0xfffffe7b
 114:	06022f01 	streq	r2, [r2], -r1, lsl #30
 118:	f7010100 			; <UNDEFINED> instruction: 0xf7010100
 11c:	03000000 	movweq	r0, #0
 120:	00006e00 	andeq	r6, r0, r0, lsl #28
 124:	fb010200 	blx	4092e <__bss_end+0x378fe>
 128:	01000d0e 	tsteq	r0, lr, lsl #26
 12c:	00010101 	andeq	r0, r1, r1, lsl #2
 130:	00010000 	andeq	r0, r1, r0
 134:	6d2f0100 	stfvss	f0, [pc, #-0]	; 13c <shift+0x13c>
 138:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
 13c:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
 140:	4b2f7372 	blmi	bdcf10 <__bss_end+0xbd3ee0>
 144:	2f616275 	svccs	0x00616275
 148:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
 14c:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
 150:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
 154:	614d6f72 	hvcvs	55026	; 0xd6f2
 158:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffbec <__bss_end+0xffff6bbc>
 15c:	706d6178 	rsbvc	r6, sp, r8, ror r1
 160:	2f73656c 	svccs	0x0073656c
 164:	652d3831 	strvs	r3, [sp, #-2097]!	; 0xfffff7cf
 168:	752f6664 	strvc	r6, [pc, #-1636]!	; fffffb0c <__bss_end+0xffff6adc>
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
 194:	02050005 	andeq	r0, r5, #5
 198:	000080a4 	andeq	r8, r0, r4, lsr #1
 19c:	05010a03 	streq	r0, [r1, #-2563]	; 0xfffff5fd
 1a0:	10058311 	andne	r8, r5, r1, lsl r3
 1a4:	8305054a 	movwhi	r0, #21834	; 0x554a
 1a8:	83130585 	tsthi	r3, #557842432	; 0x21400000
 1ac:	85670505 	strbhi	r0, [r7, #-1285]!	; 0xfffffafb
 1b0:	86010583 	strhi	r0, [r1], -r3, lsl #11
 1b4:	854c854c 	strbhi	r8, [ip, #-1356]	; 0xfffffab4
 1b8:	0505854c 	streq	r8, [r5, #-1356]	; 0xfffffab4
 1bc:	01040200 	mrseq	r0, R12_usr
 1c0:	0301054b 	movweq	r0, #5451	; 0x154b
 1c4:	10052e12 	andne	r2, r5, r2, lsl lr
 1c8:	0027056b 	eoreq	r0, r7, fp, ror #10
 1cc:	4a030402 	bmi	c11dc <__bss_end+0xb81ac>
 1d0:	02000a05 	andeq	r0, r0, #20480	; 0x5000
 1d4:	05830204 	streq	r0, [r3, #516]	; 0x204
 1d8:	04020011 	streq	r0, [r2], #-17	; 0xffffffef
 1dc:	05054a02 	streq	r4, [r5, #-2562]	; 0xfffff5fe
 1e0:	02040200 	andeq	r0, r4, #0, 4
 1e4:	850c052d 	strhi	r0, [ip, #-1325]	; 0xfffffad3
 1e8:	a12f0105 			; <UNDEFINED> instruction: 0xa12f0105
 1ec:	056a1005 	strbeq	r1, [sl, #-5]!
 1f0:	04020027 	streq	r0, [r2], #-39	; 0xffffffd9
 1f4:	0a054a03 	beq	152a08 <__bss_end+0x1499d8>
 1f8:	02040200 	andeq	r0, r4, #0, 4
 1fc:	00110583 	andseq	r0, r1, r3, lsl #11
 200:	4a020402 	bmi	81210 <__bss_end+0x781e0>
 204:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
 208:	052d0204 	streq	r0, [sp, #-516]!	; 0xfffffdfc
 20c:	0105850c 	tsteq	r5, ip, lsl #10
 210:	000a022f 	andeq	r0, sl, pc, lsr #4
 214:	02fe0101 	rscseq	r0, lr, #1073741824	; 0x40000000
 218:	00030000 	andeq	r0, r3, r0
 21c:	0000023d 	andeq	r0, r0, sp, lsr r2
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
 270:	5f736f73 	svcpl	0x00736f73
 274:	6b736174 	blvs	1cd884c <__bss_end+0x1ccf81c>
 278:	6e6d2f00 	cdpvs	15, 6, cr2, cr13, cr0, {0}
 27c:	2f632f74 	svccs	0x00632f74
 280:	72657355 	rsbvc	r7, r5, #1409286145	; 0x54000001
 284:	754b2f73 	strbvc	r2, [fp, #-3955]	; 0xfffff08d
 288:	442f6162 	strtmi	r6, [pc], #-354	; 290 <shift+0x290>
 28c:	6d75636f 	ldclvs	3, cr6, [r5, #-444]!	; 0xfffffe44
 290:	73746e65 	cmnvc	r4, #1616	; 0x650
 294:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
 298:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
 29c:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 2a0:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
 2a4:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
 2a8:	64652d38 	strbtvs	r2, [r5], #-3384	; 0xfffff2c8
 2ac:	73752f66 	cmnvc	r5, #408	; 0x198
 2b0:	70737265 	rsbsvc	r7, r3, r5, ror #4
 2b4:	2f656361 	svccs	0x00656361
 2b8:	6b2f2e2e 	blvs	bcbb78 <__bss_end+0xbc2b48>
 2bc:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 2c0:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
 2c4:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 2c8:	72702f65 	rsbsvc	r2, r0, #404	; 0x194
 2cc:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
 2d0:	6d2f0073 	stcvs	0, cr0, [pc, #-460]!	; 10c <shift+0x10c>
 2d4:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
 2d8:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
 2dc:	4b2f7372 	blmi	bdd0ac <__bss_end+0xbd407c>
 2e0:	2f616275 	svccs	0x00616275
 2e4:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
 2e8:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
 2ec:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
 2f0:	614d6f72 	hvcvs	55026	; 0xd6f2
 2f4:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffd88 <__bss_end+0xffff6d58>
 2f8:	706d6178 	rsbvc	r6, sp, r8, ror r1
 2fc:	2f73656c 	svccs	0x0073656c
 300:	652d3831 	strvs	r3, [sp, #-2097]!	; 0xfffff7cf
 304:	752f6664 	strvc	r6, [pc, #-1636]!	; fffffca8 <__bss_end+0xffff6c78>
 308:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 30c:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
 310:	2f2e2e2f 	svccs	0x002e2e2f
 314:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 318:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 31c:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 320:	662f6564 	strtvs	r6, [pc], -r4, ror #10
 324:	6d2f0073 	stcvs	0, cr0, [pc, #-460]!	; 160 <shift+0x160>
 328:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
 32c:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
 330:	4b2f7372 	blmi	bdd100 <__bss_end+0xbd40d0>
 334:	2f616275 	svccs	0x00616275
 338:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
 33c:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
 340:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
 344:	614d6f72 	hvcvs	55026	; 0xd6f2
 348:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffddc <__bss_end+0xffff6dac>
 34c:	706d6178 	rsbvc	r6, sp, r8, ror r1
 350:	2f73656c 	svccs	0x0073656c
 354:	652d3831 	strvs	r3, [sp, #-2097]!	; 0xfffff7cf
 358:	752f6664 	strvc	r6, [pc, #-1636]!	; fffffcfc <__bss_end+0xffff6ccc>
 35c:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 360:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
 364:	2f2e2e2f 	svccs	0x002e2e2f
 368:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 36c:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 370:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 374:	622f6564 	eorvs	r6, pc, #100, 10	; 0x19000000
 378:	6472616f 	ldrbtvs	r6, [r2], #-367	; 0xfffffe91
 37c:	6970722f 	ldmdbvs	r0!, {r0, r1, r2, r3, r5, r9, ip, sp, lr}^
 380:	61682f30 	cmnvs	r8, r0, lsr pc
 384:	6d2f006c 	stcvs	0, cr0, [pc, #-432]!	; 1dc <shift+0x1dc>
 388:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
 38c:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
 390:	4b2f7372 	blmi	bdd160 <__bss_end+0xbd4130>
 394:	2f616275 	svccs	0x00616275
 398:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
 39c:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
 3a0:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
 3a4:	614d6f72 	hvcvs	55026	; 0xd6f2
 3a8:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffe3c <__bss_end+0xffff6e0c>
 3ac:	706d6178 	rsbvc	r6, sp, r8, ror r1
 3b0:	2f73656c 	svccs	0x0073656c
 3b4:	652d3831 	strvs	r3, [sp, #-2097]!	; 0xfffff7cf
 3b8:	752f6664 	strvc	r6, [pc, #-1636]!	; fffffd5c <__bss_end+0xffff6d2c>
 3bc:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 3c0:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
 3c4:	2f2e2e2f 	svccs	0x002e2e2f
 3c8:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 3cc:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 3d0:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 3d4:	642f6564 	strtvs	r6, [pc], #-1380	; 3dc <shift+0x3dc>
 3d8:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
 3dc:	00007372 	andeq	r7, r0, r2, ror r3
 3e0:	6e69616d 	powvsez	f6, f1, #5.0
 3e4:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
 3e8:	00000100 	andeq	r0, r0, r0, lsl #2
 3ec:	2e697773 	mcrcs	7, 3, r7, cr9, cr3, {3}
 3f0:	00020068 	andeq	r0, r2, r8, rrx
 3f4:	69707300 	ldmdbvs	r0!, {r8, r9, ip, sp, lr}^
 3f8:	636f6c6e 	cmnvs	pc, #28160	; 0x6e00
 3fc:	00682e6b 	rsbeq	r2, r8, fp, ror #28
 400:	66000002 	strvs	r0, [r0], -r2
 404:	73656c69 	cmnvc	r5, #26880	; 0x6900
 408:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
 40c:	00682e6d 	rsbeq	r2, r8, sp, ror #28
 410:	70000003 	andvc	r0, r0, r3
 414:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
 418:	682e7373 	stmdavs	lr!, {r0, r1, r4, r5, r6, r8, r9, ip, sp, lr}
 41c:	00000200 	andeq	r0, r0, r0, lsl #4
 420:	636f7270 	cmnvs	pc, #112, 4
 424:	5f737365 	svcpl	0x00737365
 428:	616e616d 	cmnvs	lr, sp, ror #2
 42c:	2e726567 	cdpcs	5, 7, cr6, cr2, cr7, {3}
 430:	00020068 	andeq	r0, r2, r8, rrx
 434:	72657000 	rsbvc	r7, r5, #0
 438:	65687069 	strbvs	r7, [r8, #-105]!	; 0xffffff97
 43c:	736c6172 	cmnvc	ip, #-2147483620	; 0x8000001c
 440:	0400682e 	streq	r6, [r0], #-2094	; 0xfffff7d2
 444:	70670000 	rsbvc	r0, r7, r0
 448:	682e6f69 	stmdavs	lr!, {r0, r3, r5, r6, r8, r9, sl, fp, sp, lr}
 44c:	00000500 	andeq	r0, r0, r0, lsl #10
 450:	64746e69 	ldrbtvs	r6, [r4], #-3689	; 0xfffff197
 454:	682e6665 	stmdavs	lr!, {r0, r2, r5, r6, r9, sl, sp, lr}
 458:	00000400 	andeq	r0, r0, r0, lsl #8
 45c:	00010500 	andeq	r0, r1, r0, lsl #10
 460:	822c0205 	eorhi	r0, ip, #1342177280	; 0x50000000
 464:	16030000 	strne	r0, [r3], -r0
 468:	9f0a0501 	svcls	0x000a0501
 46c:	040200bb 	streq	r0, [r2], #-187	; 0xffffff45
 470:	00660601 	rsbeq	r0, r6, r1, lsl #12
 474:	4a020402 	bmi	81484 <__bss_end+0x78454>
 478:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
 47c:	0402002e 	streq	r0, [r2], #-46	; 0xffffffd2
 480:	05670604 	strbeq	r0, [r7, #-1540]!	; 0xfffff9fc
 484:	04020001 	streq	r0, [r2], #-1
 488:	05bdbb04 	ldreq	fp, [sp, #2820]!	; 0xb04
 48c:	0d059f13 	stceq	15, cr9, [r5, #-76]	; 0xffffffb4
 490:	4b120582 	blmi	481aa0 <__bss_end+0x478a70>
 494:	05820c05 	streq	r0, [r2, #3077]	; 0xc05
 498:	0a054c1a 	beq	153508 <__bss_end+0x14a4d8>
 49c:	bc1c054b 	cfldr32lt	mvfx0, [ip], {75}	; 0x4b
 4a0:	02000d05 	andeq	r0, r0, #320	; 0x140
 4a4:	05870104 	streq	r0, [r7, #260]	; 0x104
 4a8:	0402000e 	streq	r0, [r2], #-14
 4ac:	ba0b0301 	blt	2c10b8 <__bss_end+0x2b8088>
 4b0:	01040200 	mrseq	r0, R12_usr
 4b4:	04020084 	streq	r0, [r2], #-132	; 0xffffff7c
 4b8:	02004b01 	andeq	r4, r0, #1024	; 0x400
 4bc:	00670104 	rsbeq	r0, r7, r4, lsl #2
 4c0:	4b010402 	blmi	414d0 <__bss_end+0x384a0>
 4c4:	01040200 	mrseq	r0, R12_usr
 4c8:	04020067 	streq	r0, [r2], #-103	; 0xffffff99
 4cc:	02004c01 	andeq	r4, r0, #256	; 0x100
 4d0:	00680104 	rsbeq	r0, r8, r4, lsl #2
 4d4:	4b010402 	blmi	414e4 <__bss_end+0x384b4>
 4d8:	01040200 	mrseq	r0, R12_usr
 4dc:	04020067 	streq	r0, [r2], #-103	; 0xffffff99
 4e0:	02004b01 	andeq	r4, r0, #1024	; 0x400
 4e4:	00670104 	rsbeq	r0, r7, r4, lsl #2
 4e8:	4b010402 	blmi	414f8 <__bss_end+0x384c8>
 4ec:	01040200 	mrseq	r0, R12_usr
 4f0:	04020068 	streq	r0, [r2], #-104	; 0xffffff98
 4f4:	02006801 	andeq	r6, r0, #65536	; 0x10000
 4f8:	004b0104 	subeq	r0, fp, r4, lsl #2
 4fc:	67010402 	strvs	r0, [r1, -r2, lsl #8]
 500:	01040200 	mrseq	r0, R12_usr
 504:	0402004b 	streq	r0, [r2], #-75	; 0xffffffb5
 508:	0d056701 	stceq	7, cr6, [r5, #-4]
 50c:	01040200 	mrseq	r0, R12_usr
 510:	024a5e03 	subeq	r5, sl, #3, 28	; 0x30
 514:	0101000e 	tsteq	r1, lr
 518:	00000288 	andeq	r0, r0, r8, lsl #5
 51c:	019d0003 	orrseq	r0, sp, r3
 520:	01020000 	mrseq	r0, (UNDEF: 2)
 524:	000d0efb 	strdeq	r0, [sp], -fp
 528:	01010101 	tsteq	r1, r1, lsl #2
 52c:	01000000 	mrseq	r0, (UNDEF: 0)
 530:	2f010000 	svccs	0x00010000
 534:	2f746e6d 	svccs	0x00746e6d
 538:	73552f63 	cmpvc	r5, #396	; 0x18c
 53c:	2f737265 	svccs	0x00737265
 540:	6162754b 	cmnvs	r2, fp, asr #10
 544:	636f442f 	cmnvs	pc, #788529152	; 0x2f000000
 548:	6e656d75 	mcrvs	13, 3, r6, cr5, cr5, {3}
 54c:	5a2f7374 	bpl	bdd324 <__bss_end+0xbd42f4>
 550:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 3c4 <shift+0x3c4>
 554:	2f657461 	svccs	0x00657461
 558:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
 55c:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
 560:	2d38312f 	ldfcss	f3, [r8, #-188]!	; 0xffffff44
 564:	2f666465 	svccs	0x00666465
 568:	6c647473 	cfstrdvs	mvd7, [r4], #-460	; 0xfffffe34
 56c:	732f6269 			; <UNDEFINED> instruction: 0x732f6269
 570:	2f006372 	svccs	0x00006372
 574:	2f746e6d 	svccs	0x00746e6d
 578:	73552f63 	cmpvc	r5, #396	; 0x18c
 57c:	2f737265 	svccs	0x00737265
 580:	6162754b 	cmnvs	r2, fp, asr #10
 584:	636f442f 	cmnvs	pc, #788529152	; 0x2f000000
 588:	6e656d75 	mcrvs	13, 3, r6, cr5, cr5, {3}
 58c:	5a2f7374 	bpl	bdd364 <__bss_end+0xbd4334>
 590:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 404 <shift+0x404>
 594:	2f657461 	svccs	0x00657461
 598:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
 59c:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
 5a0:	2d38312f 	ldfcss	f3, [r8, #-188]!	; 0xffffff44
 5a4:	2f666465 	svccs	0x00666465
 5a8:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 5ac:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 5b0:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 5b4:	702f6564 	eorvc	r6, pc, r4, ror #10
 5b8:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
 5bc:	2f007373 	svccs	0x00007373
 5c0:	2f746e6d 	svccs	0x00746e6d
 5c4:	73552f63 	cmpvc	r5, #396	; 0x18c
 5c8:	2f737265 	svccs	0x00737265
 5cc:	6162754b 	cmnvs	r2, fp, asr #10
 5d0:	636f442f 	cmnvs	pc, #788529152	; 0x2f000000
 5d4:	6e656d75 	mcrvs	13, 3, r6, cr5, cr5, {3}
 5d8:	5a2f7374 	bpl	bdd3b0 <__bss_end+0xbd4380>
 5dc:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 450 <shift+0x450>
 5e0:	2f657461 	svccs	0x00657461
 5e4:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
 5e8:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
 5ec:	2d38312f 	ldfcss	f3, [r8, #-188]!	; 0xffffff44
 5f0:	2f666465 	svccs	0x00666465
 5f4:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 5f8:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 5fc:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 600:	662f6564 	strtvs	r6, [pc], -r4, ror #10
 604:	6d2f0073 	stcvs	0, cr0, [pc, #-460]!	; 440 <shift+0x440>
 608:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
 60c:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
 610:	4b2f7372 	blmi	bdd3e0 <__bss_end+0xbd43b0>
 614:	2f616275 	svccs	0x00616275
 618:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
 61c:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
 620:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
 624:	614d6f72 	hvcvs	55026	; 0xd6f2
 628:	652f6574 	strvs	r6, [pc, #-1396]!	; bc <shift+0xbc>
 62c:	706d6178 	rsbvc	r6, sp, r8, ror r1
 630:	2f73656c 	svccs	0x0073656c
 634:	652d3831 	strvs	r3, [sp, #-2097]!	; 0xfffff7cf
 638:	6b2f6664 	blvs	bd9fd0 <__bss_end+0xbd0fa0>
 63c:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 640:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
 644:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 648:	6f622f65 	svcvs	0x00622f65
 64c:	2f647261 	svccs	0x00647261
 650:	30697072 	rsbcc	r7, r9, r2, ror r0
 654:	6c61682f 	stclvs	8, cr6, [r1], #-188	; 0xffffff44
 658:	74730000 	ldrbtvc	r0, [r3], #-0
 65c:	6c696664 	stclvs	6, cr6, [r9], #-400	; 0xfffffe70
 660:	70632e65 	rsbvc	r2, r3, r5, ror #28
 664:	00010070 	andeq	r0, r1, r0, ror r0
 668:	69777300 	ldmdbvs	r7!, {r8, r9, ip, sp, lr}^
 66c:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 670:	70730000 	rsbsvc	r0, r3, r0
 674:	6f6c6e69 	svcvs	0x006c6e69
 678:	682e6b63 	stmdavs	lr!, {r0, r1, r5, r6, r8, r9, fp, sp, lr}
 67c:	00000200 	andeq	r0, r0, r0, lsl #4
 680:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
 684:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
 688:	682e6d65 	stmdavs	lr!, {r0, r2, r5, r6, r8, sl, fp, sp, lr}
 68c:	00000300 	andeq	r0, r0, r0, lsl #6
 690:	636f7270 	cmnvs	pc, #112, 4
 694:	2e737365 	cdpcs	3, 7, cr7, cr3, cr5, {3}
 698:	00020068 	andeq	r0, r2, r8, rrx
 69c:	6f727000 	svcvs	0x00727000
 6a0:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
 6a4:	6e616d5f 	mcrvs	13, 3, r6, cr1, cr15, {2}
 6a8:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
 6ac:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 6b0:	6e690000 	cdpvs	0, 6, cr0, cr9, cr0, {0}
 6b4:	66656474 			; <UNDEFINED> instruction: 0x66656474
 6b8:	0400682e 	streq	r6, [r0], #-2094	; 0xfffff7d2
 6bc:	05000000 	streq	r0, [r0, #-0]
 6c0:	02050001 	andeq	r0, r5, #1
 6c4:	00008418 	andeq	r8, r0, r8, lsl r4
 6c8:	69050516 	stmdbvs	r5, {r1, r2, r4, r8, sl}
 6cc:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
 6d0:	852f0105 	strhi	r0, [pc, #-261]!	; 5d3 <shift+0x5d3>
 6d4:	4b830505 	blmi	fe0c1af0 <__bss_end+0xfe0b8ac0>
 6d8:	852f0105 	strhi	r0, [pc, #-261]!	; 5db <shift+0x5db>
 6dc:	054b0505 	strbeq	r0, [fp, #-1285]	; 0xfffffafb
 6e0:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 6e4:	4b4ba105 	blmi	12e8b00 <__bss_end+0x12dfad0>
 6e8:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
 6ec:	852f0105 	strhi	r0, [pc, #-261]!	; 5ef <shift+0x5ef>
 6f0:	4bbd0505 	blmi	fef41b0c <__bss_end+0xfef38adc>
 6f4:	052f4b4b 	streq	r4, [pc, #-2891]!	; fffffbb1 <__bss_end+0xffff6b81>
 6f8:	01054c0c 	tsteq	r5, ip, lsl #24
 6fc:	0505852f 	streq	r8, [r5, #-1327]	; 0xfffffad1
 700:	4b4b4bbd 	blmi	12d35fc <__bss_end+0x12ca5cc>
 704:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
 708:	852f0105 	strhi	r0, [pc, #-261]!	; 60b <shift+0x60b>
 70c:	4b830505 	blmi	fe0c1b28 <__bss_end+0xfe0b8af8>
 710:	852f0105 	strhi	r0, [pc, #-261]!	; 613 <shift+0x613>
 714:	4bbd0505 	blmi	fef41b30 <__bss_end+0xfef38b00>
 718:	052f4b4b 	streq	r4, [pc, #-2891]!	; fffffbd5 <__bss_end+0xffff6ba5>
 71c:	01054c0c 	tsteq	r5, ip, lsl #24
 720:	0505852f 	streq	r8, [r5, #-1327]	; 0xfffffad1
 724:	2f4b4ba1 	svccs	0x004b4ba1
 728:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 72c:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 730:	4b4bbd05 	blmi	12efb4c <__bss_end+0x12e6b1c>
 734:	0c052f4b 	stceq	15, cr2, [r5], {75}	; 0x4b
 738:	2f01054c 	svccs	0x0001054c
 73c:	a1050585 	smlabbge	r5, r5, r5, r0
 740:	052f4b4b 	streq	r4, [pc, #-2891]!	; fffffbfd <__bss_end+0xffff6bcd>
 744:	01054c0c 	tsteq	r5, ip, lsl #24
 748:	2005859f 	mulcs	r5, pc, r5	; <UNPREDICTABLE>
 74c:	4d050567 	cfstr32mi	mvfx0, [r5, #-412]	; 0xfffffe64
 750:	0c054b4b 			; <UNDEFINED> instruction: 0x0c054b4b
 754:	2f010530 	svccs	0x00010530
 758:	67200585 	strvs	r0, [r0, -r5, lsl #11]!
 75c:	4b4d0505 	blmi	1341b78 <__bss_end+0x1338b48>
 760:	300c054b 	andcc	r0, ip, fp, asr #10
 764:	852f0105 	strhi	r0, [pc, #-261]!	; 667 <shift+0x667>
 768:	05832005 	streq	r2, [r3, #5]
 76c:	4b4b4c05 	blmi	12d3788 <__bss_end+0x12ca758>
 770:	852f0105 	strhi	r0, [pc, #-261]!	; 673 <shift+0x673>
 774:	05672005 	strbeq	r2, [r7, #-5]!
 778:	4b4b4d05 	blmi	12d3b94 <__bss_end+0x12cab64>
 77c:	05300c05 	ldreq	r0, [r0, #-3077]!	; 0xfffff3fb
 780:	05872f01 	streq	r2, [r7, #3841]	; 0xf01
 784:	059fa00c 	ldreq	sl, [pc, #12]	; 798 <shift+0x798>
 788:	2905bc31 	stmdbcs	r5, {r0, r4, r5, sl, fp, ip, sp, pc}
 78c:	2e360566 	cdpcs	5, 3, cr0, cr6, cr6, {3}
 790:	05300f05 	ldreq	r0, [r0, #-3845]!	; 0xfffff0fb
 794:	09056613 	stmdbeq	r5, {r0, r1, r4, r9, sl, sp, lr}
 798:	d8100584 	ldmdale	r0, {r2, r7, r8, sl}
 79c:	029f0105 	addseq	r0, pc, #1073741825	; 0x40000001
 7a0:	01010008 	tsteq	r1, r8
 7a4:	00000287 	andeq	r0, r0, r7, lsl #5
 7a8:	00640003 	rsbeq	r0, r4, r3
 7ac:	01020000 	mrseq	r0, (UNDEF: 2)
 7b0:	000d0efb 	strdeq	r0, [sp], -fp
 7b4:	01010101 	tsteq	r1, r1, lsl #2
 7b8:	01000000 	mrseq	r0, (UNDEF: 0)
 7bc:	2f010000 	svccs	0x00010000
 7c0:	2f746e6d 	svccs	0x00746e6d
 7c4:	73552f63 	cmpvc	r5, #396	; 0x18c
 7c8:	2f737265 	svccs	0x00737265
 7cc:	6162754b 	cmnvs	r2, fp, asr #10
 7d0:	636f442f 	cmnvs	pc, #788529152	; 0x2f000000
 7d4:	6e656d75 	mcrvs	13, 3, r6, cr5, cr5, {3}
 7d8:	5a2f7374 	bpl	bdd5b0 <__bss_end+0xbd4580>
 7dc:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 650 <shift+0x650>
 7e0:	2f657461 	svccs	0x00657461
 7e4:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
 7e8:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
 7ec:	2d38312f 	ldfcss	f3, [r8, #-188]!	; 0xffffff44
 7f0:	2f666465 	svccs	0x00666465
 7f4:	6c647473 	cfstrdvs	mvd7, [r4], #-460	; 0xfffffe34
 7f8:	732f6269 			; <UNDEFINED> instruction: 0x732f6269
 7fc:	00006372 	andeq	r6, r0, r2, ror r3
 800:	73647473 	cmnvc	r4, #1929379840	; 0x73000000
 804:	6e697274 	mcrvs	2, 3, r7, cr9, cr4, {3}
 808:	70632e67 	rsbvc	r2, r3, r7, ror #28
 80c:	00010070 	andeq	r0, r1, r0, ror r0
 810:	01050000 	mrseq	r0, (UNDEF: 5)
 814:	74020500 	strvc	r0, [r2], #-1280	; 0xfffffb00
 818:	1a000088 	bne	a40 <shift+0xa40>
 81c:	05bb0905 	ldreq	r0, [fp, #2309]!	; 0x905
 820:	27054c12 	smladcs	r5, r2, ip, r4
 824:	ba100568 	blt	401dcc <__bss_end+0x3f8d9c>
 828:	052e1105 	streq	r1, [lr, #-261]!	; 0xfffffefb
 82c:	13054a2d 	movwne	r4, #23085	; 0x5a2d
 830:	2f0f054a 	svccs	0x000f054a
 834:	059f0a05 	ldreq	r0, [pc, #2565]	; 1241 <shift+0x1241>
 838:	05356205 	ldreq	r6, [r5, #-517]!	; 0xfffffdfb
 83c:	11056810 	tstne	r5, r0, lsl r8
 840:	4a22052e 	bmi	881d00 <__bss_end+0x878cd0>
 844:	052e1305 	streq	r1, [lr, #-773]!	; 0xfffffcfb
 848:	0c052f0a 	stceq	15, cr2, [r5], {10}
 84c:	2e0d0569 	cfsh32cs	mvfx0, mvfx13, #57
 850:	054a0f05 	strbeq	r0, [sl, #-3845]	; 0xfffff0fb
 854:	0e054b06 	vmlaeq.f64	d4, d5, d6
 858:	001c0568 	andseq	r0, ip, r8, ror #10
 85c:	4a030402 	bmi	c186c <__bss_end+0xb883c>
 860:	02001705 	andeq	r1, r0, #1310720	; 0x140000
 864:	059e0304 	ldreq	r0, [lr, #772]	; 0x304
 868:	0402001b 	streq	r0, [r2], #-27	; 0xffffffe5
 86c:	1e056802 	cdpne	8, 0, cr6, cr5, cr2, {0}
 870:	02040200 	andeq	r0, r4, #0, 4
 874:	000e0582 	andeq	r0, lr, r2, lsl #11
 878:	4a020402 	bmi	81888 <__bss_end+0x78858>
 87c:	02002005 	andeq	r2, r0, #5
 880:	054b0204 	strbeq	r0, [fp, #-516]	; 0xfffffdfc
 884:	04020021 	streq	r0, [r2], #-33	; 0xffffffdf
 888:	12052e02 	andne	r2, r5, #2, 28
 88c:	02040200 	andeq	r0, r4, #0, 4
 890:	0015054a 	andseq	r0, r5, sl, asr #10
 894:	82020402 	andhi	r0, r2, #33554432	; 0x2000000
 898:	02002105 	andeq	r2, r0, #1073741825	; 0x40000001
 89c:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 8a0:	04020017 	streq	r0, [r2], #-23	; 0xffffffe9
 8a4:	10052e02 	andne	r2, r5, r2, lsl #28
 8a8:	02040200 	andeq	r0, r4, #0, 4
 8ac:	0011052f 	andseq	r0, r1, pc, lsr #10
 8b0:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
 8b4:	02001305 	andeq	r1, r0, #335544320	; 0x14000000
 8b8:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 8bc:	04020005 	streq	r0, [r2], #-5
 8c0:	01054602 	tsteq	r5, r2, lsl #12
 8c4:	09058588 	stmdbeq	r5, {r3, r7, r8, sl, pc}
 8c8:	4c0c0583 	cfstr32mi	mvfx0, [ip], {131}	; 0x83
 8cc:	054a1305 	strbeq	r1, [sl, #-773]	; 0xfffffcfb
 8d0:	0d054c10 	stceq	12, cr4, [r5, #-64]	; 0xffffffc0
 8d4:	4a0905bb 	bmi	241fc8 <__bss_end+0x238f98>
 8d8:	02001d05 	andeq	r1, r0, #320	; 0x140
 8dc:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
 8e0:	0402001a 	streq	r0, [r2], #-26	; 0xffffffe6
 8e4:	13054a01 	movwne	r4, #23041	; 0x5a01
 8e8:	4a1a054d 	bmi	681e24 <__bss_end+0x678df4>
 8ec:	052e1005 	streq	r1, [lr, #-5]!
 8f0:	0505680e 	streq	r6, [r5, #-2062]	; 0xfffff7f2
 8f4:	05667803 	strbeq	r7, [r6, #-2051]!	; 0xfffff7fd
 8f8:	2e0b030c 	cdpcs	3, 0, cr0, cr11, cr12, {0}
 8fc:	852f0105 	strhi	r0, [pc, #-261]!	; 7ff <shift+0x7ff>
 900:	05bd0c05 	ldreq	r0, [sp, #3077]!	; 0xc05
 904:	04020019 	streq	r0, [r2], #-25	; 0xffffffe7
 908:	20054a04 	andcs	r4, r5, r4, lsl #20
 90c:	02040200 	andeq	r0, r4, #0, 4
 910:	00210582 	eoreq	r0, r1, r2, lsl #11
 914:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
 918:	02001905 	andeq	r1, r0, #81920	; 0x14000
 91c:	05660204 	strbeq	r0, [r6, #-516]!	; 0xfffffdfc
 920:	04020017 	streq	r0, [r2], #-23	; 0xffffffe9
 924:	18054b03 	stmdane	r5, {r0, r1, r8, r9, fp, lr}
 928:	03040200 	movweq	r0, #16896	; 0x4200
 92c:	000e052e 	andeq	r0, lr, lr, lsr #10
 930:	4a030402 	bmi	c1940 <__bss_end+0xb8910>
 934:	02000f05 	andeq	r0, r0, #5, 30
 938:	052e0304 	streq	r0, [lr, #-772]!	; 0xfffffcfc
 93c:	04020018 	streq	r0, [r2], #-24	; 0xffffffe8
 940:	11054a03 	tstne	r5, r3, lsl #20
 944:	03040200 	movweq	r0, #16896	; 0x4200
 948:	0005052e 	andeq	r0, r5, lr, lsr #10
 94c:	2d030402 	cfstrscs	mvf0, [r3, #-8]
 950:	02000e05 	andeq	r0, r0, #5, 28	; 0x50
 954:	00840204 	addeq	r0, r4, r4, lsl #4
 958:	83010402 	movwhi	r0, #5122	; 0x1402
 95c:	02000f05 	andeq	r0, r0, #5, 30
 960:	052e0104 	streq	r0, [lr, #-260]!	; 0xfffffefc
 964:	04020011 	streq	r0, [r2], #-17	; 0xffffffef
 968:	05054a01 	streq	r4, [r5, #-2561]	; 0xfffff5ff
 96c:	01040200 	mrseq	r0, R12_usr
 970:	850c0549 	strhi	r0, [ip, #-1353]	; 0xfffffab7
 974:	852f0105 	strhi	r0, [pc, #-261]!	; 877 <shift+0x877>
 978:	05bc0f05 	ldreq	r0, [ip, #3845]!	; 0xf05
 97c:	20056612 	andcs	r6, r5, r2, lsl r6
 980:	660c05bc 			; <UNDEFINED> instruction: 0x660c05bc
 984:	054b2005 	strbeq	r2, [fp, #-5]
 988:	0905660c 	stmdbeq	r5, {r2, r3, r9, sl, sp, lr}
 98c:	8314054b 	tsthi	r4, #314572800	; 0x12c00000
 990:	052e1905 	streq	r1, [lr, #-2309]!	; 0xfffff6fb
 994:	14056709 	strne	r6, [r5], #-1801	; 0xfffff8f7
 998:	4d0c0567 	cfstr32mi	mvfx0, [ip, #-412]	; 0xfffffe64
 99c:	852f0105 	strhi	r0, [pc, #-261]!	; 89f <shift+0x89f>
 9a0:	05830905 	streq	r0, [r3, #2309]	; 0x905
 9a4:	0f054c0e 	svceq	0x00054c0e
 9a8:	6611052e 	ldrvs	r0, [r1], -lr, lsr #10
 9ac:	054b0a05 	strbeq	r0, [fp, #-2565]	; 0xfffff5fb
 9b0:	0c056505 	cfstr32eq	mvfx6, [r5], {5}
 9b4:	2f010531 	svccs	0x00010531
 9b8:	9f0b0585 	svcls	0x000b0585
 9bc:	054c0e05 	strbeq	r0, [ip, #-3589]	; 0xfffff1fb
 9c0:	04020017 	streq	r0, [r2], #-23	; 0xffffffe9
 9c4:	0d054a03 	vstreq	s8, [r5, #-12]
 9c8:	02040200 	andeq	r0, r4, #0, 4
 9cc:	000e0583 	andeq	r0, lr, r3, lsl #11
 9d0:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
 9d4:	02001005 	andeq	r1, r0, #5
 9d8:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 9dc:	04020005 	streq	r0, [r2], #-5
 9e0:	01054902 	tsteq	r5, r2, lsl #18
 9e4:	11058584 	smlabbne	r5, r4, r5, r8
 9e8:	4b0b05bb 	blmi	2c20dc <__bss_end+0x2b90ac>
 9ec:	054c0e05 	strbeq	r0, [ip, #-3589]	; 0xfffff1fb
 9f0:	04020017 	streq	r0, [r2], #-23	; 0xffffffe9
 9f4:	1c054a03 			; <UNDEFINED> instruction: 0x1c054a03
 9f8:	02040200 	andeq	r0, r4, #0, 4
 9fc:	001d0583 	andseq	r0, sp, r3, lsl #11
 a00:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
 a04:	02001005 	andeq	r1, r0, #5
 a08:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 a0c:	04020011 	streq	r0, [r2], #-17	; 0xffffffef
 a10:	1d052e02 	stcne	14, cr2, [r5, #-8]
 a14:	02040200 	andeq	r0, r4, #0, 4
 a18:	0013054a 	andseq	r0, r3, sl, asr #10
 a1c:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
 a20:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
 a24:	052d0204 	streq	r0, [sp, #-516]!	; 0xfffffdfc
 a28:	08028401 	stmdaeq	r2, {r0, sl, pc}
 a2c:	79010100 	stmdbvc	r1, {r8}
 a30:	03000000 	movweq	r0, #0
 a34:	00004600 	andeq	r4, r0, r0, lsl #12
 a38:	fb010200 	blx	41242 <__bss_end+0x38212>
 a3c:	01000d0e 	tsteq	r0, lr, lsl #26
 a40:	00010101 	andeq	r0, r1, r1, lsl #2
 a44:	00010000 	andeq	r0, r1, r0
 a48:	2e2e0100 	sufcse	f0, f6, f0
 a4c:	2f2e2e2f 	svccs	0x002e2e2f
 a50:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 a54:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 a58:	2f2e2e2f 	svccs	0x002e2e2f
 a5c:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
 a60:	632f6363 			; <UNDEFINED> instruction: 0x632f6363
 a64:	69666e6f 	stmdbvs	r6!, {r0, r1, r2, r3, r5, r6, r9, sl, fp, sp, lr}^
 a68:	72612f67 	rsbvc	r2, r1, #412	; 0x19c
 a6c:	6c00006d 	stcvs	0, cr0, [r0], {109}	; 0x6d
 a70:	66316269 	ldrtvs	r6, [r1], -r9, ror #4
 a74:	73636e75 	cmnvc	r3, #1872	; 0x750
 a78:	0100532e 	tsteq	r0, lr, lsr #6
 a7c:	00000000 	andeq	r0, r0, r0
 a80:	8d2c0205 	sfmhi	f0, 4, [ip, #-20]!	; 0xffffffec
 a84:	cf030000 	svcgt	0x00030000
 a88:	2f300108 	svccs	0x00300108
 a8c:	2f2f2f2f 	svccs	0x002f2f2f
 a90:	01d00230 	bicseq	r0, r0, r0, lsr r2
 a94:	2f312f14 	svccs	0x00312f14
 a98:	2f4c302f 	svccs	0x004c302f
 a9c:	661f0332 			; <UNDEFINED> instruction: 0x661f0332
 aa0:	2f2f2f2f 	svccs	0x002f2f2f
 aa4:	022f2f2f 	eoreq	r2, pc, #47, 30	; 0xbc
 aa8:	01010002 	tsteq	r1, r2
 aac:	0000005c 	andeq	r0, r0, ip, asr r0
 ab0:	00460003 	subeq	r0, r6, r3
 ab4:	01020000 	mrseq	r0, (UNDEF: 2)
 ab8:	000d0efb 	strdeq	r0, [sp], -fp
 abc:	01010101 	tsteq	r1, r1, lsl #2
 ac0:	01000000 	mrseq	r0, (UNDEF: 0)
 ac4:	2e010000 	cdpcs	0, 0, cr0, cr1, cr0, {0}
 ac8:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 acc:	2f2e2e2f 	svccs	0x002e2e2f
 ad0:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 ad4:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 ad8:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
 adc:	2f636367 	svccs	0x00636367
 ae0:	666e6f63 	strbtvs	r6, [lr], -r3, ror #30
 ae4:	612f6769 			; <UNDEFINED> instruction: 0x612f6769
 ae8:	00006d72 	andeq	r6, r0, r2, ror sp
 aec:	3162696c 	cmncc	r2, ip, ror #18
 af0:	636e7566 	cmnvs	lr, #427819008	; 0x19800000
 af4:	00532e73 	subseq	r2, r3, r3, ror lr
 af8:	00000001 	andeq	r0, r0, r1
 afc:	38020500 	stmdacc	r2, {r8, sl}
 b00:	0300008f 	movweq	r0, #143	; 0x8f
 b04:	02010bb9 	andeq	r0, r1, #189440	; 0x2e400
 b08:	01010002 	tsteq	r1, r2
 b0c:	000000a4 	andeq	r0, r0, r4, lsr #1
 b10:	009e0003 	addseq	r0, lr, r3
 b14:	01020000 	mrseq	r0, (UNDEF: 2)
 b18:	000d0efb 	strdeq	r0, [sp], -fp
 b1c:	01010101 	tsteq	r1, r1, lsl #2
 b20:	01000000 	mrseq	r0, (UNDEF: 0)
 b24:	2e010000 	cdpcs	0, 0, cr0, cr1, cr0, {0}
 b28:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 b2c:	2f2e2e2f 	svccs	0x002e2e2f
 b30:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 b34:	2f2e2f2e 	svccs	0x002e2f2e
 b38:	00636367 	rsbeq	r6, r3, r7, ror #6
 b3c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 b40:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 b44:	2f2e2e2f 	svccs	0x002e2e2f
 b48:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 b4c:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
 b50:	63636762 	cmnvs	r3, #25690112	; 0x1880000
 b54:	2f2e2e2f 	svccs	0x002e2e2f
 b58:	2f636367 	svccs	0x00636367
 b5c:	666e6f63 	strbtvs	r6, [lr], -r3, ror #30
 b60:	612f6769 			; <UNDEFINED> instruction: 0x612f6769
 b64:	2e006d72 	mcrcs	13, 0, r6, cr0, cr2, {3}
 b68:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 b6c:	2f2e2e2f 	svccs	0x002e2e2f
 b70:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 b74:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 b78:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
 b7c:	00636367 	rsbeq	r6, r3, r7, ror #6
 b80:	6d726100 	ldfvse	f6, [r2, #-0]
 b84:	6173692d 	cmnvs	r3, sp, lsr #18
 b88:	0100682e 	tsteq	r0, lr, lsr #16
 b8c:	72610000 	rsbvc	r0, r1, #0
 b90:	00682e6d 	rsbeq	r2, r8, sp, ror #28
 b94:	67000002 	strvs	r0, [r0, -r2]
 b98:	632d6c62 			; <UNDEFINED> instruction: 0x632d6c62
 b9c:	73726f74 	cmnvc	r2, #116, 30	; 0x1d0
 ba0:	0300682e 	movweq	r6, #2094	; 0x82e
 ba4:	696c0000 	stmdbvs	ip!, {}^	; <UNPREDICTABLE>
 ba8:	63636762 	cmnvs	r3, #25690112	; 0x1880000
 bac:	00632e32 	rsbeq	r2, r3, r2, lsr lr
 bb0:	00000003 	andeq	r0, r0, r3

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
      34:	3a0c0000 	bcc	30003c <__bss_end+0x2f700c>
      38:	46000001 	strmi	r0, [r0], -r1
      3c:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
      40:	9c000080 	stcls	0, cr0, [r0], {128}	; 0x80
      44:	76000000 	strvc	r0, [r0], -r0
      48:	02000000 	andeq	r0, r0, #0
      4c:	000001a1 	andeq	r0, r0, r1, lsr #3
      50:	31150601 	tstcc	r5, r1, lsl #12
      54:	03000000 	movweq	r0, #0
      58:	15160704 	ldrne	r0, [r6, #-1796]	; 0xfffff8fc
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
      84:	091c0100 	ldmdbeq	ip, {r8}
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
      b0:	0b010000 	bleq	400b8 <__bss_end+0x37088>
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
      ec:	2e010000 	cdpcs	0, 0, cr0, cr1, cr0, {0}
      f0:	00003107 	andeq	r3, r0, r7, lsl #2
      f4:	37040300 	strcc	r0, [r4, -r0, lsl #6]
      f8:	04000000 	streq	r0, [r0], #-0
      fc:	00029602 	andeq	r9, r2, r2, lsl #12
     100:	072f0100 	streq	r0, [pc, -r0, lsl #2]!
     104:	00000031 	andeq	r0, r0, r1, lsr r0
     108:	00002505 	andeq	r2, r0, r5, lsl #10
     10c:	00005700 	andeq	r5, r0, r0, lsl #14
     110:	00570600 	subseq	r0, r7, r0, lsl #12
     114:	ffff0000 			; <UNDEFINED> instruction: 0xffff0000
     118:	0700ffff 			; <UNDEFINED> instruction: 0x0700ffff
     11c:	15160704 	ldrne	r0, [r6, #-1796]	; 0xfffff8fc
     120:	82080000 	andhi	r0, r8, #0
     124:	01000003 	tsteq	r0, r3
     128:	00441532 	subeq	r1, r4, r2, lsr r5
     12c:	5c080000 	stcpl	0, cr0, [r8], {-0}
     130:	01000002 	tsteq	r0, r2
     134:	00441534 	subeq	r1, r4, r4, lsr r5
     138:	38050000 	stmdacc	r5, {}	; <UNPREDICTABLE>
     13c:	89000000 	stmdbhi	r0, {}	; <UNPREDICTABLE>
     140:	06000000 	streq	r0, [r0], -r0
     144:	00000057 	andeq	r0, r0, r7, asr r0
     148:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
     14c:	02760800 	rsbseq	r0, r6, #0, 16
     150:	37010000 	strcc	r0, [r1, -r0]
     154:	00007615 	andeq	r7, r0, r5, lsl r6
     158:	029f0800 	addseq	r0, pc, #0, 16
     15c:	39010000 	stmdbcc	r1, {}	; <UNPREDICTABLE>
     160:	00007615 	andeq	r7, r0, r5, lsl r6
     164:	01e00900 	mvneq	r0, r0, lsl #18
     168:	47010000 	strmi	r0, [r1, -r0]
     16c:	0000cb10 	andeq	ip, r0, r0, lsl fp
     170:	0081d400 	addeq	sp, r1, r0, lsl #8
     174:	00005800 	andeq	r5, r0, r0, lsl #16
     178:	cb9c0100 	blgt	fe700580 <__bss_end+0xfe6f7550>
     17c:	0a000000 	beq	184 <shift+0x184>
     180:	000001ee 	andeq	r0, r0, lr, ror #3
     184:	d20f4901 	andle	r4, pc, #16384	; 0x4000
     188:	02000000 	andeq	r0, r0, #0
     18c:	0b007491 	bleq	1d3d8 <__bss_end+0x143a8>
     190:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
     194:	04030074 	streq	r0, [r3], #-116	; 0xffffff8c
     198:	00000038 	andeq	r0, r0, r8, lsr r0
     19c:	0002c709 	andeq	ip, r2, r9, lsl #14
     1a0:	103b0100 	eorsne	r0, fp, r0, lsl #2
     1a4:	000000cb 	andeq	r0, r0, fp, asr #1
     1a8:	0000817c 	andeq	r8, r0, ip, ror r1
     1ac:	00000058 	andeq	r0, r0, r8, asr r0
     1b0:	01029c01 	tsteq	r2, r1, lsl #24
     1b4:	ee0a0000 	cdp	0, 0, cr0, cr10, cr0, {0}
     1b8:	01000001 	tsteq	r0, r1
     1bc:	01020f3d 	tsteq	r2, sp, lsr pc
     1c0:	91020000 	mrsls	r0, (UNDEF: 2)
     1c4:	04030074 	streq	r0, [r3], #-116	; 0xffffff8c
     1c8:	00000025 	andeq	r0, r0, r5, lsr #32
     1cc:	0001b50c 	andeq	fp, r1, ip, lsl #10
     1d0:	11280100 			; <UNDEFINED> instruction: 0x11280100
     1d4:	00008170 	andeq	r8, r0, r0, ror r1
     1d8:	0000000c 	andeq	r0, r0, ip
     1dc:	ff0c9c01 			; <UNDEFINED> instruction: 0xff0c9c01
     1e0:	01000001 	tsteq	r0, r1
     1e4:	81581123 	cmphi	r8, r3, lsr #2
     1e8:	00180000 	andseq	r0, r8, r0
     1ec:	9c010000 	stcls	0, cr0, [r1], {-0}
     1f0:	0002ac0c 	andeq	sl, r2, ip, lsl #24
     1f4:	111e0100 	tstne	lr, r0, lsl #2
     1f8:	00008140 	andeq	r8, r0, r0, asr #2
     1fc:	00000018 	andeq	r0, r0, r8, lsl r0
     200:	690c9c01 	stmdbvs	ip, {r0, sl, fp, ip, pc}
     204:	01000002 	tsteq	r0, r2
     208:	81281119 			; <UNDEFINED> instruction: 0x81281119
     20c:	00180000 	andseq	r0, r8, r0
     210:	9c010000 	stcls	0, cr0, [r1], {-0}
     214:	0001f40d 	andeq	pc, r1, sp, lsl #8
     218:	9e000200 	cdpls	2, 0, cr0, cr0, cr0, {0}
     21c:	0e000001 	cdpeq	0, 0, cr0, cr0, cr1, {0}
     220:	00000284 	andeq	r0, r0, r4, lsl #5
     224:	6d151401 	cfldrsvs	mvf1, [r5, #-4]
     228:	0f000001 	svceq	0x00000001
     22c:	0000019e 	muleq	r0, lr, r1
     230:	01ad0200 			; <UNDEFINED> instruction: 0x01ad0200
     234:	04010000 	streq	r0, [r1], #-0
     238:	0001a41f 	andeq	sl, r1, pc, lsl r4
     23c:	01cc0e00 	biceq	r0, ip, r0, lsl #28
     240:	0f010000 	svceq	0x00010000
     244:	00018b15 	andeq	r8, r1, r5, lsl fp
     248:	019e0f00 	orrseq	r0, lr, r0, lsl #30
     24c:	10000000 	andne	r0, r0, r0
     250:	00000399 	muleq	r0, r9, r3
     254:	cb140a01 	blgt	502a60 <__bss_end+0x4f9a30>
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
     2a0:	320f0100 	andcc	r0, pc, #0, 2
     2a4:	0000019e 	muleq	r0, lr, r1
     2a8:	00749102 	rsbseq	r9, r4, r2, lsl #2
     2ac:	00018b14 	andeq	r8, r1, r4, lsl fp
     2b0:	0080a400 	addeq	sl, r0, r0, lsl #8
     2b4:	00003800 	andeq	r3, r0, r0, lsl #16
     2b8:	139c0100 	orrsne	r0, ip, #0, 2
     2bc:	0a010067 	beq	40460 <__bss_end+0x37430>
     2c0:	00019e31 	andeq	r9, r1, r1, lsr lr
     2c4:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     2c8:	08620000 	stmdaeq	r2!, {}^	; <UNPREDICTABLE>
     2cc:	00040000 	andeq	r0, r4, r0
     2d0:	000001c6 	andeq	r0, r0, r6, asr #3
     2d4:	02d40104 	sbcseq	r0, r4, #4, 2
     2d8:	fd040000 	stc2	0, cr0, [r4, #-0]
     2dc:	4600000a 	strmi	r0, [r0], -sl
     2e0:	2c000000 	stccs	0, cr0, [r0], {-0}
     2e4:	ec000082 	stc	0, cr0, [r0], {130}	; 0x82
     2e8:	16000001 	strne	r0, [r0], -r1
     2ec:	02000002 	andeq	r0, r0, #2
     2f0:	0abf0801 	beq	fefc22fc <__bss_end+0xfefb92cc>
     2f4:	02020000 	andeq	r0, r2, #0
     2f8:	00097405 	andeq	r7, r9, r5, lsl #8
     2fc:	05040300 	streq	r0, [r4, #-768]	; 0xfffffd00
     300:	00746e69 	rsbseq	r6, r4, r9, ror #28
     304:	b6080102 	strlt	r0, [r8], -r2, lsl #2
     308:	0200000a 	andeq	r0, r0, #10
     30c:	0baf0702 	bleq	febc1f1c <__bss_end+0xfebb8eec>
     310:	cd040000 	stcgt	0, cr0, [r4, #-0]
     314:	09000005 	stmdbeq	r0, {r0, r2}
     318:	00590709 	subseq	r0, r9, r9, lsl #14
     31c:	48050000 	stmdami	r5, {}	; <UNPREDICTABLE>
     320:	02000000 	andeq	r0, r0, #0
     324:	15160704 	ldrne	r0, [r6, #-1796]	; 0xfffff8fc
     328:	59050000 	stmdbpl	r5, {}	; <UNPREDICTABLE>
     32c:	06000000 	streq	r0, [r0], -r0
     330:	00000c5a 	andeq	r0, r0, sl, asr ip
     334:	08060208 	stmdaeq	r6, {r3, r9}
     338:	0000008b 	andeq	r0, r0, fp, lsl #1
     33c:	00307207 	eorseq	r7, r0, r7, lsl #4
     340:	480e0802 	stmdami	lr, {r1, fp}
     344:	00000000 	andeq	r0, r0, r0
     348:	00317207 	eorseq	r7, r1, r7, lsl #4
     34c:	480e0902 	stmdami	lr, {r1, r8, fp}
     350:	04000000 	streq	r0, [r0], #-0
     354:	09c60800 	stmibeq	r6, {fp}^
     358:	04050000 	streq	r0, [r5], #-0
     35c:	00000033 	andeq	r0, r0, r3, lsr r0
     360:	c20c1e02 	andgt	r1, ip, #2, 28
     364:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
     368:	000005c5 	andeq	r0, r0, r5, asr #11
     36c:	06fe0900 	ldrbteq	r0, [lr], r0, lsl #18
     370:	09010000 	stmdbeq	r1, {}	; <UNPREDICTABLE>
     374:	000009e8 	andeq	r0, r0, r8, ror #19
     378:	0ad20902 	beq	ff482788 <__bss_end+0xff479758>
     37c:	09030000 	stmdbeq	r3, {}	; <UNPREDICTABLE>
     380:	000006e4 	andeq	r0, r0, r4, ror #13
     384:	09530904 	ldmdbeq	r3, {r2, r8, fp}^
     388:	00050000 	andeq	r0, r5, r0
     38c:	0009ae08 	andeq	sl, r9, r8, lsl #28
     390:	33040500 	movwcc	r0, #17664	; 0x4500
     394:	02000000 	andeq	r0, r0, #0
     398:	00ff0c40 	rscseq	r0, pc, r0, asr #24
     39c:	97090000 	strls	r0, [r9, -r0]
     3a0:	00000006 	andeq	r0, r0, r6
     3a4:	0006f909 	andeq	pc, r6, r9, lsl #18
     3a8:	e1090100 	mrs	r0, (UNDEF: 25)
     3ac:	0200000b 	andeq	r0, r0, #11
     3b0:	0008a009 	andeq	sl, r8, r9
     3b4:	f3090300 	vcgt.u8	d0, d9, d0
     3b8:	04000006 	streq	r0, [r0], #-6
     3bc:	00073109 	andeq	r3, r7, r9, lsl #2
     3c0:	f1090500 			; <UNDEFINED> instruction: 0xf1090500
     3c4:	06000005 	streq	r0, [r0], -r5
     3c8:	05d60800 	ldrbeq	r0, [r6, #2048]	; 0x800
     3cc:	04050000 	streq	r0, [r5], #-0
     3d0:	00000033 	andeq	r0, r0, r3, lsr r0
     3d4:	2a0c6702 	bcs	319fe4 <__bss_end+0x310fb4>
     3d8:	09000001 	stmdbeq	r0, {r0}
     3dc:	00000aab 	andeq	r0, r0, fp, lsr #21
     3e0:	050a0900 	streq	r0, [sl, #-2304]	; 0xfffff700
     3e4:	09010000 	stmdbeq	r1, {}	; <UNPREDICTABLE>
     3e8:	00000a0c 	andeq	r0, r0, ip, lsl #20
     3ec:	095c0902 	ldmdbeq	ip, {r1, r8, fp}^
     3f0:	00030000 	andeq	r0, r3, r0
     3f4:	0008740a 	andeq	r7, r8, sl, lsl #8
     3f8:	14050300 	strne	r0, [r5], #-768	; 0xfffffd00
     3fc:	00000054 	andeq	r0, r0, r4, asr r0
     400:	8f3c0305 	svchi	0x003c0305
     404:	3f0a0000 	svccc	0x000a0000
     408:	0300000a 	movweq	r0, #10
     40c:	00541406 	subseq	r1, r4, r6, lsl #8
     410:	03050000 	movweq	r0, #20480	; 0x5000
     414:	00008f40 	andeq	r8, r0, r0, asr #30
     418:	0007460a 	andeq	r4, r7, sl, lsl #12
     41c:	1a070400 	bne	1c1424 <__bss_end+0x1b83f4>
     420:	00000054 	andeq	r0, r0, r4, asr r0
     424:	8f440305 	svchi	0x00440305
     428:	850a0000 	strhi	r0, [sl, #-0]
     42c:	04000009 	streq	r0, [r0], #-9
     430:	00541a09 	subseq	r1, r4, r9, lsl #20
     434:	03050000 	movweq	r0, #20480	; 0x5000
     438:	00008f48 	andeq	r8, r0, r8, asr #30
     43c:	0007380a 	andeq	r3, r7, sl, lsl #16
     440:	1a0b0400 	bne	2c1448 <__bss_end+0x2b8418>
     444:	00000054 	andeq	r0, r0, r4, asr r0
     448:	8f4c0305 	svchi	0x004c0305
     44c:	380a0000 	stmdacc	sl, {}	; <UNPREDICTABLE>
     450:	04000009 	streq	r0, [r0], #-9
     454:	00541a0d 	subseq	r1, r4, sp, lsl #20
     458:	03050000 	movweq	r0, #20480	; 0x5000
     45c:	00008f50 	andeq	r8, r0, r0, asr pc
     460:	0005a50a 	andeq	sl, r5, sl, lsl #10
     464:	1a0f0400 	bne	3c146c <__bss_end+0x3b843c>
     468:	00000054 	andeq	r0, r0, r4, asr r0
     46c:	8f540305 	svchi	0x00540305
     470:	27080000 	strcs	r0, [r8, -r0]
     474:	05000010 	streq	r0, [r0, #-16]
     478:	00003304 	andeq	r3, r0, r4, lsl #6
     47c:	0c1b0400 	cfldrseq	mvf0, [fp], {-0}
     480:	000001cd 	andeq	r0, r0, sp, asr #3
     484:	00054809 	andeq	r4, r5, r9, lsl #16
     488:	4e090000 	cdpmi	0, 0, cr0, cr9, cr0, {0}
     48c:	0100000b 	tsteq	r0, fp
     490:	000bdc09 	andeq	sp, fp, r9, lsl #24
     494:	0b000200 	bleq	c9c <shift+0xc9c>
     498:	0000041d 	andeq	r0, r0, sp, lsl r4
     49c:	aa020102 	bge	808ac <__bss_end+0x7787c>
     4a0:	0c000007 	stceq	0, cr0, [r0], {7}
     4a4:	0001cd04 	andeq	ip, r1, r4, lsl #26
     4a8:	055e0a00 	ldrbeq	r0, [lr, #-2560]	; 0xfffff600
     4ac:	04050000 	streq	r0, [r5], #-0
     4b0:	00005414 	andeq	r5, r0, r4, lsl r4
     4b4:	58030500 	stmdapl	r3, {r8, sl}
     4b8:	0a00008f 	beq	6fc <shift+0x6fc>
     4bc:	000009ee 	andeq	r0, r0, lr, ror #19
     4c0:	54140705 	ldrpl	r0, [r4], #-1797	; 0xfffff8fb
     4c4:	05000000 	streq	r0, [r0, #-0]
     4c8:	008f5c03 	addeq	r5, pc, r3, lsl #24
     4cc:	04ae0a00 	strteq	r0, [lr], #2560	; 0xa00
     4d0:	0a050000 	beq	1404d8 <__bss_end+0x1374a8>
     4d4:	00005414 	andeq	r5, r0, r4, lsl r4
     4d8:	60030500 	andvs	r0, r3, r0, lsl #10
     4dc:	0800008f 	stmdaeq	r0, {r0, r1, r2, r3, r7}
     4e0:	000005f6 	strdeq	r0, [r0], -r6
     4e4:	00330405 	eorseq	r0, r3, r5, lsl #8
     4e8:	0d050000 	stceq	0, cr0, [r5, #-0]
     4ec:	00024c0c 	andeq	r4, r2, ip, lsl #24
     4f0:	654e0d00 	strbvs	r0, [lr, #-3328]	; 0xfffff300
     4f4:	09000077 	stmdbeq	r0, {r0, r1, r2, r4, r5, r6}
     4f8:	00000486 	andeq	r0, r0, r6, lsl #9
     4fc:	04a60901 	strteq	r0, [r6], #2305	; 0x901
     500:	09020000 	stmdbeq	r2, {}	; <UNPREDICTABLE>
     504:	0000060f 	andeq	r0, r0, pc, lsl #12
     508:	0ac40903 	beq	ff10291c <__bss_end+0xff0f98ec>
     50c:	09040000 	stmdbeq	r4, {}	; <UNPREDICTABLE>
     510:	0000047a 	andeq	r0, r0, sl, ror r4
     514:	77060005 	strvc	r0, [r6, -r5]
     518:	10000005 	andne	r0, r0, r5
     51c:	8b081d05 	blhi	207938 <__bss_end+0x1fe908>
     520:	07000002 	streq	r0, [r0, -r2]
     524:	0500726c 	streq	r7, [r0, #-620]	; 0xfffffd94
     528:	028b131f 	addeq	r1, fp, #2080374784	; 0x7c000000
     52c:	07000000 	streq	r0, [r0, -r0]
     530:	05007073 	streq	r7, [r0, #-115]	; 0xffffff8d
     534:	028b1320 	addeq	r1, fp, #32, 6	; 0x80000000
     538:	07040000 	streq	r0, [r4, -r0]
     53c:	05006370 	streq	r6, [r0, #-880]	; 0xfffffc90
     540:	028b1321 	addeq	r1, fp, #-2080374784	; 0x84000000
     544:	0e080000 	cdpeq	0, 0, cr0, cr8, cr0, {0}
     548:	000009a8 	andeq	r0, r0, r8, lsr #19
     54c:	8b132205 	blhi	4c8d68 <__bss_end+0x4bfd38>
     550:	0c000002 	stceq	0, cr0, [r0], {2}
     554:	07040200 	streq	r0, [r4, -r0, lsl #4]
     558:	00001511 	andeq	r1, r0, r1, lsl r5
     55c:	00028b05 	andeq	r8, r2, r5, lsl #22
     560:	06d70600 	ldrbeq	r0, [r7], r0, lsl #12
     564:	05700000 	ldrbeq	r0, [r0, #-0]!
     568:	0327082a 			; <UNDEFINED> instruction: 0x0327082a
     56c:	7c0e0000 	stcvc	0, cr0, [lr], {-0}
     570:	05000006 	streq	r0, [r0, #-6]
     574:	024c122c 	subeq	r1, ip, #44, 4	; 0xc0000002
     578:	07000000 	streq	r0, [r0, -r0]
     57c:	00646970 	rsbeq	r6, r4, r0, ror r9
     580:	59122d05 	ldmdbpl	r2, {r0, r2, r8, sl, fp, sp}
     584:	10000000 	andne	r0, r0, r0
     588:	000af70e 	andeq	pc, sl, lr, lsl #14
     58c:	112e0500 			; <UNDEFINED> instruction: 0x112e0500
     590:	00000215 	andeq	r0, r0, r5, lsl r2
     594:	0a9d0e14 	beq	fe743dec <__bss_end+0xfe73adbc>
     598:	2f050000 	svccs	0x00050000
     59c:	00005912 	andeq	r5, r0, r2, lsl r9
     5a0:	ad0e1800 	stcge	8, cr1, [lr, #-0]
     5a4:	05000003 	streq	r0, [r0, #-3]
     5a8:	00591231 	subseq	r1, r9, r1, lsr r2
     5ac:	0e1c0000 	cdpeq	0, 1, cr0, cr12, cr0, {0}
     5b0:	000009db 	ldrdeq	r0, [r0], -fp
     5b4:	270c3205 	strcs	r3, [ip, -r5, lsl #4]
     5b8:	20000003 	andcs	r0, r0, r3
     5bc:	0004360e 	andeq	r3, r4, lr, lsl #12
     5c0:	05340500 	ldreq	r0, [r4, #-1280]!	; 0xfffffb00
     5c4:	00000033 	andeq	r0, r0, r3, lsr r0
     5c8:	063a0e60 	ldrteq	r0, [sl], -r0, ror #28
     5cc:	35050000 	strcc	r0, [r5, #-0]
     5d0:	0000480e 	andeq	r4, r0, lr, lsl #16
     5d4:	f50e6400 			; <UNDEFINED> instruction: 0xf50e6400
     5d8:	05000008 	streq	r0, [r0, #-8]
     5dc:	00480e38 	subeq	r0, r8, r8, lsr lr
     5e0:	0e680000 	cdpeq	0, 6, cr0, cr8, cr0, {0}
     5e4:	000008ec 	andeq	r0, r0, ip, ror #17
     5e8:	480e3905 	stmdami	lr, {r0, r2, r8, fp, ip, sp}
     5ec:	6c000000 	stcvs	0, cr0, [r0], {-0}
     5f0:	01d90f00 	bicseq	r0, r9, r0, lsl #30
     5f4:	03370000 	teqeq	r7, #0
     5f8:	59100000 	ldmdbpl	r0, {}	; <UNPREDICTABLE>
     5fc:	0f000000 	svceq	0x00000000
     600:	04970a00 	ldreq	r0, [r7], #2560	; 0xa00
     604:	0a060000 	beq	18060c <__bss_end+0x1775dc>
     608:	00005414 	andeq	r5, r0, r4, lsl r4
     60c:	64030500 	strvs	r0, [r3], #-1280	; 0xfffffb00
     610:	0800008f 	stmdaeq	r0, {r0, r1, r2, r3, r7}
     614:	00000781 	andeq	r0, r0, r1, lsl #15
     618:	00330405 	eorseq	r0, r3, r5, lsl #8
     61c:	0d060000 	stceq	0, cr0, [r6, #-0]
     620:	0003680c 	andeq	r6, r3, ip, lsl #16
     624:	0be70900 	bleq	ff9c2a2c <__bss_end+0xff9b99fc>
     628:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
     62c:	00000b62 	andeq	r0, r0, r2, ror #22
     630:	69060001 	stmdbvs	r6, {r0}
     634:	0c000006 	stceq	0, cr0, [r0], {6}
     638:	9d081b06 	vstrls	d1, [r8, #-24]	; 0xffffffe8
     63c:	0e000003 	cdpeq	0, 0, cr0, cr0, cr3, {0}
     640:	00000515 	andeq	r0, r0, r5, lsl r5
     644:	9d191d06 	ldcls	13, cr1, [r9, #-24]	; 0xffffffe8
     648:	00000003 	andeq	r0, r0, r3
     64c:	0004810e 	andeq	r8, r4, lr, lsl #2
     650:	191e0600 	ldmdbne	lr, {r9, sl}
     654:	0000039d 	muleq	r0, sp, r3
     658:	07a50e04 	streq	r0, [r5, r4, lsl #28]!
     65c:	1f060000 	svcne	0x00060000
     660:	0003a313 	andeq	sl, r3, r3, lsl r3
     664:	0c000800 	stceq	8, cr0, [r0], {-0}
     668:	00036804 	andeq	r6, r3, r4, lsl #16
     66c:	97040c00 	strls	r0, [r4, -r0, lsl #24]
     670:	11000002 	tstne	r0, r2
     674:	00000997 	muleq	r0, r7, r9
     678:	07220614 			; <UNDEFINED> instruction: 0x07220614
     67c:	0000062b 	andeq	r0, r0, fp, lsr #12
     680:	0008820e 	andeq	r8, r8, lr, lsl #4
     684:	0e260600 	cfmadda32eq	mvax0, mvax0, mvfx6, mvfx0
     688:	00000048 	andeq	r0, r0, r8, asr #32
     68c:	08240e00 	stmdaeq	r4!, {r9, sl, fp}
     690:	29060000 	stmdbcs	r6, {}	; <UNPREDICTABLE>
     694:	00039d19 	andeq	r9, r3, r9, lsl sp
     698:	170e0400 	strne	r0, [lr, -r0, lsl #8]
     69c:	06000006 	streq	r0, [r0], -r6
     6a0:	039d192c 	orrseq	r1, sp, #44, 18	; 0xb0000
     6a4:	12080000 	andne	r0, r8, #0
     6a8:	00000896 	muleq	r0, r6, r8
     6ac:	460a2f06 	strmi	r2, [sl], -r6, lsl #30
     6b0:	f1000006 	cps	#6
     6b4:	fc000003 	stc2	0, cr0, [r0], {3}
     6b8:	13000003 	movwne	r0, #3
     6bc:	00000630 	andeq	r0, r0, r0, lsr r6
     6c0:	00039d14 	andeq	r9, r3, r4, lsl sp
     6c4:	08150000 	ldmdaeq	r5, {}	; <UNPREDICTABLE>
     6c8:	06000007 	streq	r0, [r0], -r7
     6cc:	06ae0a31 			; <UNDEFINED> instruction: 0x06ae0a31
     6d0:	01d20000 	bicseq	r0, r2, r0
     6d4:	04140000 	ldreq	r0, [r4], #-0
     6d8:	041f0000 	ldreq	r0, [pc], #-0	; 6e0 <shift+0x6e0>
     6dc:	30130000 	andscc	r0, r3, r0
     6e0:	14000006 	strne	r0, [r0], #-6
     6e4:	000003a3 	andeq	r0, r0, r3, lsr #7
     6e8:	0ad81600 	beq	ff605ef0 <__bss_end+0xff5fcec0>
     6ec:	35060000 	strcc	r0, [r6, #-0]
     6f0:	00075c19 	andeq	r5, r7, r9, lsl ip
     6f4:	00039d00 	andeq	r9, r3, r0, lsl #26
     6f8:	04380200 	ldrteq	r0, [r8], #-512	; 0xfffffe00
     6fc:	043e0000 	ldrteq	r0, [lr], #-0
     700:	30130000 	andscc	r0, r3, r0
     704:	00000006 	andeq	r0, r0, r6
     708:	00060216 	andeq	r0, r6, r6, lsl r2
     70c:	19370600 	ldmdbne	r7!, {r9, sl}
     710:	000008a6 	andeq	r0, r0, r6, lsr #17
     714:	0000039d 	muleq	r0, sp, r3
     718:	00045702 	andeq	r5, r4, r2, lsl #14
     71c:	00045d00 	andeq	r5, r4, r0, lsl #26
     720:	06301300 	ldrteq	r1, [r0], -r0, lsl #6
     724:	17000000 	strne	r0, [r0, -r0]
     728:	00000837 	andeq	r0, r0, r7, lsr r8
     72c:	492d3906 	pushmi	{r1, r2, r8, fp, ip, sp}
     730:	0c000006 	stceq	0, cr0, [r0], {6}
     734:	09971602 	ldmibeq	r7, {r1, r9, sl, ip}
     738:	3c060000 	stccc	0, cr0, [r6], {-0}
     73c:	00071705 	andeq	r1, r7, r5, lsl #14
     740:	00063000 	andeq	r3, r6, r0
     744:	04840100 	streq	r0, [r4], #256	; 0x100
     748:	048a0000 	streq	r0, [sl], #0
     74c:	30130000 	andscc	r0, r3, r0
     750:	00000006 	andeq	r0, r0, r6
     754:	00068816 	andeq	r8, r6, r6, lsl r8
     758:	0e3f0600 	cfmsuba32eq	mvax0, mvax0, mvfx15, mvfx0
     75c:	000004df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
     760:	00000048 	andeq	r0, r0, r8, asr #32
     764:	0004a301 	andeq	sl, r4, r1, lsl #6
     768:	0004b800 	andeq	fp, r4, r0, lsl #16
     76c:	06301300 	ldrteq	r1, [r0], -r0, lsl #6
     770:	52140000 	andspl	r0, r4, #0
     774:	14000006 	strne	r0, [r0], #-6
     778:	00000059 	andeq	r0, r0, r9, asr r0
     77c:	0001d214 	andeq	sp, r1, r4, lsl r2
     780:	59180000 	ldmdbpl	r8, {}	; <UNPREDICTABLE>
     784:	0600000b 	streq	r0, [r0], -fp
     788:	05840a43 	streq	r0, [r4, #2627]	; 0xa43
     78c:	cd010000 	stcgt	0, cr0, [r1, #-0]
     790:	d3000004 	movwle	r0, #4
     794:	13000004 	movwne	r0, #4
     798:	00000630 	andeq	r0, r0, r0, lsr r6
     79c:	04c11600 	strbeq	r1, [r1], #1536	; 0x600
     7a0:	46060000 	strmi	r0, [r6], -r0
     7a4:	00051a13 	andeq	r1, r5, r3, lsl sl
     7a8:	0003a300 	andeq	sl, r3, r0, lsl #6
     7ac:	04ec0100 	strbteq	r0, [ip], #256	; 0x100
     7b0:	04f20000 	ldrbteq	r0, [r2], #0
     7b4:	58130000 	ldmdapl	r3, {}	; <UNPREDICTABLE>
     7b8:	00000006 	andeq	r0, r0, r6
     7bc:	0009f916 	andeq	pc, r9, r6, lsl r9	; <UNPREDICTABLE>
     7c0:	13490600 	movtne	r0, #38400	; 0x9600
     7c4:	000003c3 	andeq	r0, r0, r3, asr #7
     7c8:	000003a3 	andeq	r0, r0, r3, lsr #7
     7cc:	00050b01 	andeq	r0, r5, r1, lsl #22
     7d0:	00051600 	andeq	r1, r5, r0, lsl #12
     7d4:	06581300 	ldrbeq	r1, [r8], -r0, lsl #6
     7d8:	48140000 	ldmdami	r4, {}	; <UNPREDICTABLE>
     7dc:	00000000 	andeq	r0, r0, r0
     7e0:	0005af18 	andeq	sl, r5, r8, lsl pc
     7e4:	0a4c0600 	beq	1301fec <__bss_end+0x12f8fbc>
     7e8:	00000845 	andeq	r0, r0, r5, asr #16
     7ec:	00052b01 	andeq	r2, r5, r1, lsl #22
     7f0:	00053100 	andeq	r3, r5, r0, lsl #2
     7f4:	06301300 	ldrteq	r1, [r0], -r0, lsl #6
     7f8:	16000000 	strne	r0, [r0], -r0
     7fc:	00000708 	andeq	r0, r0, r8, lsl #14
     800:	100a4e06 	andne	r4, sl, r6, lsl #28
     804:	d2000009 	andle	r0, r0, #9
     808:	01000001 	tsteq	r0, r1
     80c:	0000054a 	andeq	r0, r0, sl, asr #10
     810:	00000555 	andeq	r0, r0, r5, asr r5
     814:	00063013 	andeq	r3, r6, r3, lsl r0
     818:	00481400 	subeq	r1, r8, r0, lsl #8
     81c:	16000000 	strne	r0, [r0], -r0
     820:	00000466 	andeq	r0, r0, r6, ror #8
     824:	f00e5106 			; <UNDEFINED> instruction: 0xf00e5106
     828:	48000003 	stmdami	r0, {r0, r1}
     82c:	01000000 	mrseq	r0, (UNDEF: 0)
     830:	0000056e 	andeq	r0, r0, lr, ror #10
     834:	00000579 	andeq	r0, r0, r9, ror r5
     838:	00063013 	andeq	r3, r6, r3, lsl r0
     83c:	01d91400 	bicseq	r1, r9, r0, lsl #8
     840:	16000000 	strne	r0, [r0], -r0
     844:	00000423 	andeq	r0, r0, r3, lsr #8
     848:	6d0a5406 	cfstrsvs	mvf5, [sl, #-24]	; 0xffffffe8
     84c:	d200000b 	andle	r0, r0, #11
     850:	01000001 	tsteq	r0, r1
     854:	00000592 	muleq	r0, r2, r5
     858:	0000059d 	muleq	r0, sp, r5
     85c:	00063013 	andeq	r3, r6, r3, lsl r0
     860:	00481400 	subeq	r1, r8, r0, lsl #8
     864:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
     868:	00000440 	andeq	r0, r0, r0, asr #8
     86c:	4b0a5706 	blmi	29648c <__bss_end+0x28d45c>
     870:	0100000a 	tsteq	r0, sl
     874:	000005b2 			; <UNDEFINED> instruction: 0x000005b2
     878:	000005d1 	ldrdeq	r0, [r0], -r1
     87c:	00063013 	andeq	r3, r6, r3, lsl r0
     880:	008b1400 	addeq	r1, fp, r0, lsl #8
     884:	48140000 	ldmdami	r4, {}	; <UNPREDICTABLE>
     888:	14000000 	strne	r0, [r0], #-0
     88c:	00000048 	andeq	r0, r0, r8, asr #32
     890:	00004814 	andeq	r4, r0, r4, lsl r8
     894:	065e1400 	ldrbeq	r1, [lr], -r0, lsl #8
     898:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
     89c:	00000b99 	muleq	r0, r9, fp
     8a0:	0e055a06 	vmlaeq.f32	s10, s10, s12
     8a4:	0100000c 	tsteq	r0, ip
     8a8:	000005e6 	andeq	r0, r0, r6, ror #11
     8ac:	00000605 	andeq	r0, r0, r5, lsl #12
     8b0:	00063013 	andeq	r3, r6, r3, lsl r0
     8b4:	00c21400 	sbceq	r1, r2, r0, lsl #8
     8b8:	48140000 	ldmdami	r4, {}	; <UNPREDICTABLE>
     8bc:	14000000 	strne	r0, [r0], #-0
     8c0:	00000048 	andeq	r0, r0, r8, asr #32
     8c4:	00004814 	andeq	r4, r0, r4, lsl r8
     8c8:	065e1400 	ldrbeq	r1, [lr], -r0, lsl #8
     8cc:	19000000 	stmdbne	r0, {}	; <UNPREDICTABLE>
     8d0:	00000453 	andeq	r0, r0, r3, asr r4
     8d4:	af0a5d06 	svcge	0x000a5d06
     8d8:	d2000007 	andle	r0, r0, #7
     8dc:	01000001 	tsteq	r0, r1
     8e0:	0000061a 	andeq	r0, r0, sl, lsl r6
     8e4:	00063013 	andeq	r3, r6, r3, lsl r0
     8e8:	03491400 	movteq	r1, #37888	; 0x9400
     8ec:	64140000 	ldrvs	r0, [r4], #-0
     8f0:	00000006 	andeq	r0, r0, r6
     8f4:	03a90500 			; <UNDEFINED> instruction: 0x03a90500
     8f8:	040c0000 	streq	r0, [ip], #-0
     8fc:	000003a9 	andeq	r0, r0, r9, lsr #7
     900:	00039d1a 	andeq	r9, r3, sl, lsl sp
     904:	00064300 	andeq	r4, r6, r0, lsl #6
     908:	00064900 	andeq	r4, r6, r0, lsl #18
     90c:	06301300 	ldrteq	r1, [r0], -r0, lsl #6
     910:	1b000000 	blne	918 <shift+0x918>
     914:	000003a9 	andeq	r0, r0, r9, lsr #7
     918:	00000636 	andeq	r0, r0, r6, lsr r6
     91c:	003a040c 	eorseq	r0, sl, ip, lsl #8
     920:	040c0000 	streq	r0, [ip], #-0
     924:	0000062b 	andeq	r0, r0, fp, lsr #12
     928:	0065041c 	rsbeq	r0, r5, ip, lsl r4
     92c:	041d0000 	ldreq	r0, [sp], #-0
     930:	6c61681e 	stclvs	8, cr6, [r1], #-120	; 0xffffff88
     934:	0b050700 	bleq	14253c <__bss_end+0x13950c>
     938:	00000720 	andeq	r0, r0, r0, lsr #14
     93c:	0008111f 	andeq	r1, r8, pc, lsl r1
     940:	1c070700 	stcne	7, cr0, [r7], {-0}
     944:	00000060 	andeq	r0, r0, r0, rrx
     948:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}
     94c:	000a231f 	andeq	r2, sl, pc, lsl r3
     950:	1d0a0700 	stcne	7, cr0, [sl, #-0]
     954:	00000292 	muleq	r0, r2, r2
     958:	20000000 	andcs	r0, r0, r0
     95c:	0004d51f 	andeq	sp, r4, pc, lsl r5
     960:	1d0d0700 	stcne	7, cr0, [sp, #-0]
     964:	00000292 	muleq	r0, r2, r2
     968:	20200000 	eorcs	r0, r0, r0
     96c:	00079620 	andeq	r9, r7, r0, lsr #12
     970:	18100700 	ldmdane	r0, {r8, r9, sl}
     974:	00000054 	andeq	r0, r0, r4, asr r0
     978:	0ae41f36 	beq	ff908658 <__bss_end+0xff8ff628>
     97c:	42070000 	andmi	r0, r7, #0
     980:	0002921d 	andeq	r9, r2, sp, lsl r2
     984:	21500000 	cmpcs	r0, r0
     988:	0bc21f20 	bleq	ff088610 <__bss_end+0xff07f5e0>
     98c:	71070000 	mrsvc	r0, (UNDEF: 7)
     990:	0002921d 	andeq	r9, r2, sp, lsl r2
     994:	00b20000 	adcseq	r0, r2, r0
     998:	069c1f20 	ldreq	r1, [ip], r0, lsr #30
     99c:	a4070000 	strge	r0, [r7], #-0
     9a0:	0002921d 	andeq	r9, r2, sp, lsl r2
     9a4:	00b40000 	adcseq	r0, r4, r0
     9a8:	08071f20 	stmdaeq	r7, {r5, r8, r9, sl, fp, ip}
     9ac:	b3070000 	movwlt	r0, #28672	; 0x7000
     9b0:	0002921d 	andeq	r9, r2, sp, lsl r2
     9b4:	10400000 	subne	r0, r0, r0
     9b8:	08cc1f20 	stmiaeq	ip, {r5, r8, r9, sl, fp, ip}^
     9bc:	be070000 	cdplt	0, 0, cr0, cr7, cr0, {0}
     9c0:	0002921d 	andeq	r9, r2, sp, lsl r2
     9c4:	20500000 	subscs	r0, r0, r0
     9c8:	05e71f20 	strbeq	r1, [r7, #3872]!	; 0xf20
     9cc:	bf070000 	svclt	0x00070000
     9d0:	0002921d 	andeq	r9, r2, sp, lsl r2
     9d4:	80400000 	subhi	r0, r0, r0
     9d8:	0aed1f20 	beq	ffb48660 <__bss_end+0xffb3f630>
     9dc:	c0070000 	andgt	r0, r7, r0
     9e0:	0002921d 	andeq	r9, r2, sp, lsl r2
     9e4:	80500000 	subshi	r0, r0, r0
     9e8:	72210020 	eorvc	r0, r1, #32
     9ec:	21000006 	tstcs	r0, r6
     9f0:	00000682 	andeq	r0, r0, r2, lsl #13
     9f4:	00069221 	andeq	r9, r6, r1, lsr #4
     9f8:	06a22100 	strteq	r2, [r2], r0, lsl #2
     9fc:	af210000 	svcge	0x00210000
     a00:	21000006 	tstcs	r0, r6
     a04:	000006bf 			; <UNDEFINED> instruction: 0x000006bf
     a08:	0006cf21 	andeq	ip, r6, r1, lsr #30
     a0c:	06df2100 	ldrbeq	r2, [pc], r0, lsl #2
     a10:	ef210000 	svc	0x00210000
     a14:	21000006 	tstcs	r0, r6
     a18:	000006ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
     a1c:	00070f21 	andeq	r0, r7, r1, lsr #30
     a20:	0a330a00 	beq	cc3228 <__bss_end+0xcba1f8>
     a24:	08080000 	stmdaeq	r8, {}	; <UNPREDICTABLE>
     a28:	00005414 	andeq	r5, r0, r4, lsl r4
     a2c:	94030500 	strls	r0, [r3], #-1280	; 0xfffffb00
     a30:	0800008f 	stmdaeq	r0, {r0, r1, r2, r3, r7}
     a34:	000007f2 	strdeq	r0, [r0], -r2
     a38:	00330405 	eorseq	r0, r3, r5, lsl #8
     a3c:	1d080000 	stcne	0, cr0, [r8, #-0]
     a40:	0007940c 	andeq	r9, r7, ip, lsl #8
     a44:	08d60900 	ldmeq	r6, {r8, fp}^
     a48:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
     a4c:	00000903 	andeq	r0, r0, r3, lsl #18
     a50:	08e70901 	stmiaeq	r7!, {r0, r8, fp}^
     a54:	0d020000 	stceq	0, cr0, [r2, #-0]
     a58:	00776f4c 	rsbseq	r6, r7, ip, asr #30
     a5c:	fc0a0003 	stc2	0, cr0, [sl], {3}
     a60:	0100000b 	tsteq	r0, fp
     a64:	00541410 	subseq	r1, r4, r0, lsl r4
     a68:	03050000 	movweq	r0, #20480	; 0x5000
     a6c:	00008f98 	muleq	r0, r8, pc	; <UNPREDICTABLE>
     a70:	00062a0a 	andeq	r2, r6, sl, lsl #20
     a74:	14110100 	ldrne	r0, [r1], #-256	; 0xffffff00
     a78:	00000054 	andeq	r0, r0, r4, asr r0
     a7c:	8f9c0305 	svchi	0x009c0305
     a80:	8f220000 	svchi	0x00220000
     a84:	01000004 	tsteq	r0, r4
     a88:	00480a13 	subeq	r0, r8, r3, lsl sl
     a8c:	03050000 	movweq	r0, #20480	; 0x5000
     a90:	00009018 	andeq	r9, r0, r8, lsl r0
     a94:	0006a722 	andeq	sl, r6, r2, lsr #14
     a98:	0a140100 	beq	500ea0 <__bss_end+0x4f7e70>
     a9c:	00000048 	andeq	r0, r0, r8, asr #32
     aa0:	901c0305 	andsls	r0, ip, r5, lsl #6
     aa4:	aa230000 	bge	8c0aac <__bss_end+0x8b7a7c>
     aa8:	01000014 	tsteq	r0, r4, lsl r0
     aac:	0033051d 	eorseq	r0, r3, sp, lsl r5
     ab0:	82ac0000 	adchi	r0, ip, #0
     ab4:	016c0000 	cmneq	ip, r0
     ab8:	9c010000 	stcls	0, cr0, [r1], {-0}
     abc:	00000833 	andeq	r0, r0, r3, lsr r8
     ac0:	0008e224 	andeq	lr, r8, r4, lsr #4
     ac4:	0e1d0100 	mufeqe	f0, f5, f0
     ac8:	00000033 	andeq	r0, r0, r3, lsr r0
     acc:	246c9102 	strbtcs	r9, [ip], #-258	; 0xfffffefe
     ad0:	000008fe 	strdeq	r0, [r0], -lr
     ad4:	331b1d01 	tstcc	fp, #1, 26	; 0x40
     ad8:	02000008 	andeq	r0, r0, #8
     adc:	7e256891 	mcrvc	8, 1, r6, cr5, cr1, {4}
     ae0:	01000009 	tsteq	r0, r9
     ae4:	07691a22 	strbeq	r1, [r9, -r2, lsr #20]!
     ae8:	91020000 	mrsls	r0, (UNDEF: 2)
     aec:	094b2570 	stmdbeq	fp, {r4, r5, r6, r8, sl, sp}^
     af0:	25010000 	strcs	r0, [r1, #-0]
     af4:	0000480e 	andeq	r4, r0, lr, lsl #16
     af8:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     afc:	39040c00 	stmdbcc	r4, {sl, fp}
     b00:	0c000008 	stceq	0, cr0, [r0], {8}
     b04:	00002504 	andeq	r2, r0, r4, lsl #10
     b08:	05582600 	ldrbeq	r2, [r8, #-1536]	; 0xfffffa00
     b0c:	16010000 	strne	r0, [r1], -r0
     b10:	00088c06 	andeq	r8, r8, r6, lsl #24
     b14:	00822c00 	addeq	r2, r2, r0, lsl #24
     b18:	00008000 	andeq	r8, r0, r0
     b1c:	249c0100 	ldrcs	r0, [ip], #256	; 0x100
     b20:	00000552 	andeq	r0, r0, r2, asr r5
     b24:	d2111601 	andsle	r1, r1, #1048576	; 0x100000
     b28:	02000001 	andeq	r0, r0, #1
     b2c:	00007791 	muleq	r0, r1, r7
     b30:	00000b1f 	andeq	r0, r0, pc, lsl fp
     b34:	04190004 	ldreq	r0, [r9], #-4
     b38:	01040000 	mrseq	r0, (UNDEF: 4)
     b3c:	00000dba 			; <UNDEFINED> instruction: 0x00000dba
     b40:	000cc404 	andeq	ip, ip, r4, lsl #8
     b44:	000ee400 	andeq	lr, lr, r0, lsl #8
     b48:	00841800 	addeq	r1, r4, r0, lsl #16
     b4c:	00045c00 	andeq	r5, r4, r0, lsl #24
     b50:	00051800 	andeq	r1, r5, r0, lsl #16
     b54:	08010200 	stmdaeq	r1, {r9}
     b58:	00000abf 			; <UNDEFINED> instruction: 0x00000abf
     b5c:	00002503 	andeq	r2, r0, r3, lsl #10
     b60:	05020200 	streq	r0, [r2, #-512]	; 0xfffffe00
     b64:	00000974 	andeq	r0, r0, r4, ror r9
     b68:	69050404 	stmdbvs	r5, {r2, sl}
     b6c:	0200746e 	andeq	r7, r0, #1845493760	; 0x6e000000
     b70:	0ab60801 	beq	fed82b7c <__bss_end+0xfed79b4c>
     b74:	02020000 	andeq	r0, r2, #0
     b78:	000baf07 	andeq	sl, fp, r7, lsl #30
     b7c:	05cd0500 	strbeq	r0, [sp, #1280]	; 0x500
     b80:	09070000 	stmdbeq	r7, {}	; <UNPREDICTABLE>
     b84:	00005e07 	andeq	r5, r0, r7, lsl #28
     b88:	004d0300 	subeq	r0, sp, r0, lsl #6
     b8c:	04020000 	streq	r0, [r2], #-0
     b90:	00151607 	andseq	r1, r5, r7, lsl #12
     b94:	0c5a0600 	mrrceq	6, 0, r0, sl, cr0
     b98:	02080000 	andeq	r0, r8, #0
     b9c:	008b0806 	addeq	r0, fp, r6, lsl #16
     ba0:	72070000 	andvc	r0, r7, #0
     ba4:	08020030 	stmdaeq	r2, {r4, r5}
     ba8:	00004d0e 	andeq	r4, r0, lr, lsl #26
     bac:	72070000 	andvc	r0, r7, #0
     bb0:	09020031 	stmdbeq	r2, {r0, r4, r5}
     bb4:	00004d0e 	andeq	r4, r0, lr, lsl #26
     bb8:	08000400 	stmdaeq	r0, {sl}
     bbc:	00000f6f 	andeq	r0, r0, pc, ror #30
     bc0:	00380405 	eorseq	r0, r8, r5, lsl #8
     bc4:	0d020000 	stceq	0, cr0, [r2, #-0]
     bc8:	0000a90c 	andeq	sl, r0, ip, lsl #18
     bcc:	4b4f0900 	blmi	13c2fd4 <__bss_end+0x13b9fa4>
     bd0:	100a0000 	andne	r0, sl, r0
     bd4:	0100000d 	tsteq	r0, sp
     bd8:	09c60800 	stmibeq	r6, {fp}^
     bdc:	04050000 	streq	r0, [r5], #-0
     be0:	00000038 	andeq	r0, r0, r8, lsr r0
     be4:	e00c1e02 	and	r1, ip, r2, lsl #28
     be8:	0a000000 	beq	bf0 <shift+0xbf0>
     bec:	000005c5 	andeq	r0, r0, r5, asr #11
     bf0:	06fe0a00 	ldrbteq	r0, [lr], r0, lsl #20
     bf4:	0a010000 	beq	40bfc <__bss_end+0x37bcc>
     bf8:	000009e8 	andeq	r0, r0, r8, ror #19
     bfc:	0ad20a02 	beq	ff48340c <__bss_end+0xff47a3dc>
     c00:	0a030000 	beq	c0c08 <__bss_end+0xb7bd8>
     c04:	000006e4 	andeq	r0, r0, r4, ror #13
     c08:	09530a04 	ldmdbeq	r3, {r2, r9, fp}^
     c0c:	00050000 	andeq	r0, r5, r0
     c10:	0009ae08 	andeq	sl, r9, r8, lsl #28
     c14:	38040500 	stmdacc	r4, {r8, sl}
     c18:	02000000 	andeq	r0, r0, #0
     c1c:	011d0c40 	tsteq	sp, r0, asr #24
     c20:	970a0000 	strls	r0, [sl, -r0]
     c24:	00000006 	andeq	r0, r0, r6
     c28:	0006f90a 	andeq	pc, r6, sl, lsl #18
     c2c:	e10a0100 	mrs	r0, (UNDEF: 26)
     c30:	0200000b 	andeq	r0, r0, #11
     c34:	0008a00a 	andeq	sl, r8, sl
     c38:	f30a0300 	vcgt.u8	d0, d10, d0
     c3c:	04000006 	streq	r0, [r0], #-6
     c40:	0007310a 	andeq	r3, r7, sl, lsl #2
     c44:	f10a0500 			; <UNDEFINED> instruction: 0xf10a0500
     c48:	06000005 	streq	r0, [r0], -r5
     c4c:	05d60800 	ldrbeq	r0, [r6, #2048]	; 0x800
     c50:	04050000 	streq	r0, [r5], #-0
     c54:	00000038 	andeq	r0, r0, r8, lsr r0
     c58:	480c6702 	stmdami	ip, {r1, r8, r9, sl, sp, lr}
     c5c:	0a000001 	beq	c68 <shift+0xc68>
     c60:	00000aab 	andeq	r0, r0, fp, lsr #21
     c64:	050a0a00 	streq	r0, [sl, #-2560]	; 0xfffff600
     c68:	0a010000 	beq	40c70 <__bss_end+0x37c40>
     c6c:	00000a0c 	andeq	r0, r0, ip, lsl #20
     c70:	095c0a02 	ldmdbeq	ip, {r1, r9, fp}^
     c74:	00030000 	andeq	r0, r3, r0
     c78:	0008740b 	andeq	r7, r8, fp, lsl #8
     c7c:	14050300 	strne	r0, [r5], #-768	; 0xfffffd00
     c80:	00000059 	andeq	r0, r0, r9, asr r0
     c84:	8fcc0305 	svchi	0x00cc0305
     c88:	3f0b0000 	svccc	0x000b0000
     c8c:	0300000a 	movweq	r0, #10
     c90:	00591406 	subseq	r1, r9, r6, lsl #8
     c94:	03050000 	movweq	r0, #20480	; 0x5000
     c98:	00008fd0 	ldrdeq	r8, [r0], -r0
     c9c:	0007460b 	andeq	r4, r7, fp, lsl #12
     ca0:	1a070400 	bne	1c1ca8 <__bss_end+0x1b8c78>
     ca4:	00000059 	andeq	r0, r0, r9, asr r0
     ca8:	8fd40305 	svchi	0x00d40305
     cac:	850b0000 	strhi	r0, [fp, #-0]
     cb0:	04000009 	streq	r0, [r0], #-9
     cb4:	00591a09 	subseq	r1, r9, r9, lsl #20
     cb8:	03050000 	movweq	r0, #20480	; 0x5000
     cbc:	00008fd8 	ldrdeq	r8, [r0], -r8	; <UNPREDICTABLE>
     cc0:	0007380b 	andeq	r3, r7, fp, lsl #16
     cc4:	1a0b0400 	bne	2c1ccc <__bss_end+0x2b8c9c>
     cc8:	00000059 	andeq	r0, r0, r9, asr r0
     ccc:	8fdc0305 	svchi	0x00dc0305
     cd0:	380b0000 	stmdacc	fp, {}	; <UNPREDICTABLE>
     cd4:	04000009 	streq	r0, [r0], #-9
     cd8:	00591a0d 	subseq	r1, r9, sp, lsl #20
     cdc:	03050000 	movweq	r0, #20480	; 0x5000
     ce0:	00008fe0 	andeq	r8, r0, r0, ror #31
     ce4:	0005a50b 	andeq	sl, r5, fp, lsl #10
     ce8:	1a0f0400 	bne	3c1cf0 <__bss_end+0x3b8cc0>
     cec:	00000059 	andeq	r0, r0, r9, asr r0
     cf0:	8fe40305 	svchi	0x00e40305
     cf4:	27080000 	strcs	r0, [r8, -r0]
     cf8:	05000010 	streq	r0, [r0, #-16]
     cfc:	00003804 	andeq	r3, r0, r4, lsl #16
     d00:	0c1b0400 	cfldrseq	mvf0, [fp], {-0}
     d04:	000001eb 	andeq	r0, r0, fp, ror #3
     d08:	0005480a 	andeq	r4, r5, sl, lsl #16
     d0c:	4e0a0000 	cdpmi	0, 0, cr0, cr10, cr0, {0}
     d10:	0100000b 	tsteq	r0, fp
     d14:	000bdc0a 	andeq	sp, fp, sl, lsl #24
     d18:	0c000200 	sfmeq	f0, 4, [r0], {-0}
     d1c:	0000041d 	andeq	r0, r0, sp, lsl r4
     d20:	aa020102 	bge	81130 <__bss_end+0x78100>
     d24:	0d000007 	stceq	0, cr0, [r0, #-28]	; 0xffffffe4
     d28:	00002c04 	andeq	r2, r0, r4, lsl #24
     d2c:	eb040d00 	bl	104134 <__bss_end+0xfb104>
     d30:	0b000001 	bleq	d3c <shift+0xd3c>
     d34:	0000055e 	andeq	r0, r0, lr, asr r5
     d38:	59140405 	ldmdbpl	r4, {r0, r2, sl}
     d3c:	05000000 	streq	r0, [r0, #-0]
     d40:	008fe803 	addeq	lr, pc, r3, lsl #16
     d44:	09ee0b00 	stmibeq	lr!, {r8, r9, fp}^
     d48:	07050000 	streq	r0, [r5, -r0]
     d4c:	00005914 	andeq	r5, r0, r4, lsl r9
     d50:	ec030500 	cfstr32	mvfx0, [r3], {-0}
     d54:	0b00008f 	bleq	f98 <shift+0xf98>
     d58:	000004ae 	andeq	r0, r0, lr, lsr #9
     d5c:	59140a05 	ldmdbpl	r4, {r0, r2, r9, fp}
     d60:	05000000 	streq	r0, [r0, #-0]
     d64:	008ff003 	addeq	pc, pc, r3
     d68:	05f60800 	ldrbeq	r0, [r6, #2048]!	; 0x800
     d6c:	04050000 	streq	r0, [r5], #-0
     d70:	00000038 	andeq	r0, r0, r8, lsr r0
     d74:	700c0d05 	andvc	r0, ip, r5, lsl #26
     d78:	09000002 	stmdbeq	r0, {r1}
     d7c:	0077654e 	rsbseq	r6, r7, lr, asr #10
     d80:	04860a00 	streq	r0, [r6], #2560	; 0xa00
     d84:	0a010000 	beq	40d8c <__bss_end+0x37d5c>
     d88:	000004a6 	andeq	r0, r0, r6, lsr #9
     d8c:	060f0a02 	streq	r0, [pc], -r2, lsl #20
     d90:	0a030000 	beq	c0d98 <__bss_end+0xb7d68>
     d94:	00000ac4 	andeq	r0, r0, r4, asr #21
     d98:	047a0a04 	ldrbteq	r0, [sl], #-2564	; 0xfffff5fc
     d9c:	00050000 	andeq	r0, r5, r0
     da0:	00057706 	andeq	r7, r5, r6, lsl #14
     da4:	1d051000 	stcne	0, cr1, [r5, #-0]
     da8:	0002af08 	andeq	sl, r2, r8, lsl #30
     dac:	726c0700 	rsbvc	r0, ip, #0, 14
     db0:	131f0500 	tstne	pc, #0, 10
     db4:	000002af 	andeq	r0, r0, pc, lsr #5
     db8:	70730700 	rsbsvc	r0, r3, r0, lsl #14
     dbc:	13200500 	nopne	{0}	; <UNPREDICTABLE>
     dc0:	000002af 	andeq	r0, r0, pc, lsr #5
     dc4:	63700704 	cmnvs	r0, #4, 14	; 0x100000
     dc8:	13210500 			; <UNDEFINED> instruction: 0x13210500
     dcc:	000002af 	andeq	r0, r0, pc, lsr #5
     dd0:	09a80e08 	stmibeq	r8!, {r3, r9, sl, fp}
     dd4:	22050000 	andcs	r0, r5, #0
     dd8:	0002af13 	andeq	sl, r2, r3, lsl pc
     ddc:	02000c00 	andeq	r0, r0, #0, 24
     de0:	15110704 	ldrne	r0, [r1, #-1796]	; 0xfffff8fc
     de4:	d7060000 	strle	r0, [r6, -r0]
     de8:	70000006 	andvc	r0, r0, r6
     dec:	46082a05 	strmi	r2, [r8], -r5, lsl #20
     df0:	0e000003 	cdpeq	0, 0, cr0, cr0, cr3, {0}
     df4:	0000067c 	andeq	r0, r0, ip, ror r6
     df8:	70122c05 	andsvc	r2, r2, r5, lsl #24
     dfc:	00000002 	andeq	r0, r0, r2
     e00:	64697007 	strbtvs	r7, [r9], #-7
     e04:	122d0500 	eorne	r0, sp, #0, 10
     e08:	0000005e 	andeq	r0, r0, lr, asr r0
     e0c:	0af70e10 	beq	ffdc4654 <__bss_end+0xffdbb624>
     e10:	2e050000 	cdpcs	0, 0, cr0, cr5, cr0, {0}
     e14:	00023911 	andeq	r3, r2, r1, lsl r9
     e18:	9d0e1400 	cfstrsls	mvf1, [lr, #-0]
     e1c:	0500000a 	streq	r0, [r0, #-10]
     e20:	005e122f 	subseq	r1, lr, pc, lsr #4
     e24:	0e180000 	cdpeq	0, 1, cr0, cr8, cr0, {0}
     e28:	000003ad 	andeq	r0, r0, sp, lsr #7
     e2c:	5e123105 	mufpls	f3, f2, f5
     e30:	1c000000 	stcne	0, cr0, [r0], {-0}
     e34:	0009db0e 	andeq	sp, r9, lr, lsl #22
     e38:	0c320500 	cfldr32eq	mvfx0, [r2], #-0
     e3c:	00000346 	andeq	r0, r0, r6, asr #6
     e40:	04360e20 	ldrteq	r0, [r6], #-3616	; 0xfffff1e0
     e44:	34050000 	strcc	r0, [r5], #-0
     e48:	00003805 	andeq	r3, r0, r5, lsl #16
     e4c:	3a0e6000 	bcc	398e54 <__bss_end+0x38fe24>
     e50:	05000006 	streq	r0, [r0, #-6]
     e54:	004d0e35 	subeq	r0, sp, r5, lsr lr
     e58:	0e640000 	cdpeq	0, 6, cr0, cr4, cr0, {0}
     e5c:	000008f5 	strdeq	r0, [r0], -r5
     e60:	4d0e3805 	stcmi	8, cr3, [lr, #-20]	; 0xffffffec
     e64:	68000000 	stmdavs	r0, {}	; <UNPREDICTABLE>
     e68:	0008ec0e 	andeq	lr, r8, lr, lsl #24
     e6c:	0e390500 	cfabs32eq	mvfx0, mvfx9
     e70:	0000004d 	andeq	r0, r0, sp, asr #32
     e74:	fd0f006c 	stc2	0, cr0, [pc, #-432]	; ccc <shift+0xccc>
     e78:	56000001 	strpl	r0, [r0], -r1
     e7c:	10000003 	andne	r0, r0, r3
     e80:	0000005e 	andeq	r0, r0, lr, asr r0
     e84:	970b000f 	strls	r0, [fp, -pc]
     e88:	06000004 	streq	r0, [r0], -r4
     e8c:	0059140a 	subseq	r1, r9, sl, lsl #8
     e90:	03050000 	movweq	r0, #20480	; 0x5000
     e94:	00008ff4 	strdeq	r8, [r0], -r4
     e98:	00078108 	andeq	r8, r7, r8, lsl #2
     e9c:	38040500 	stmdacc	r4, {r8, sl}
     ea0:	06000000 	streq	r0, [r0], -r0
     ea4:	03870c0d 	orreq	r0, r7, #3328	; 0xd00
     ea8:	e70a0000 	str	r0, [sl, -r0]
     eac:	0000000b 	andeq	r0, r0, fp
     eb0:	000b620a 	andeq	r6, fp, sl, lsl #4
     eb4:	03000100 	movweq	r0, #256	; 0x100
     eb8:	00000368 	andeq	r0, r0, r8, ror #6
     ebc:	000e8808 	andeq	r8, lr, r8, lsl #16
     ec0:	38040500 	stmdacc	r4, {r8, sl}
     ec4:	06000000 	streq	r0, [r0], -r0
     ec8:	03ab0c14 			; <UNDEFINED> instruction: 0x03ab0c14
     ecc:	6c0a0000 	stcvs	0, cr0, [sl], {-0}
     ed0:	0000000c 	andeq	r0, r0, ip
     ed4:	000f410a 	andeq	r4, pc, sl, lsl #2
     ed8:	03000100 	movweq	r0, #256	; 0x100
     edc:	0000038c 	andeq	r0, r0, ip, lsl #7
     ee0:	00066906 	andeq	r6, r6, r6, lsl #18
     ee4:	1b060c00 	blne	183eec <__bss_end+0x17aebc>
     ee8:	0003e508 	andeq	lr, r3, r8, lsl #10
     eec:	05150e00 	ldreq	r0, [r5, #-3584]	; 0xfffff200
     ef0:	1d060000 	stcne	0, cr0, [r6, #-0]
     ef4:	0003e519 	andeq	lr, r3, r9, lsl r5
     ef8:	810e0000 	mrshi	r0, (UNDEF: 14)
     efc:	06000004 	streq	r0, [r0], -r4
     f00:	03e5191e 	mvneq	r1, #491520	; 0x78000
     f04:	0e040000 	cdpeq	0, 0, cr0, cr4, cr0, {0}
     f08:	000007a5 	andeq	r0, r0, r5, lsr #15
     f0c:	eb131f06 	bl	4c8b2c <__bss_end+0x4bfafc>
     f10:	08000003 	stmdaeq	r0, {r0, r1}
     f14:	b0040d00 	andlt	r0, r4, r0, lsl #26
     f18:	0d000003 	stceq	0, cr0, [r0, #-12]
     f1c:	0002b604 	andeq	fp, r2, r4, lsl #12
     f20:	09971100 	ldmibeq	r7, {r8, ip}
     f24:	06140000 	ldreq	r0, [r4], -r0
     f28:	06730722 	ldrbteq	r0, [r3], -r2, lsr #14
     f2c:	820e0000 	andhi	r0, lr, #0
     f30:	06000008 	streq	r0, [r0], -r8
     f34:	004d0e26 	subeq	r0, sp, r6, lsr #28
     f38:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
     f3c:	00000824 	andeq	r0, r0, r4, lsr #16
     f40:	e5192906 	ldr	r2, [r9, #-2310]	; 0xfffff6fa
     f44:	04000003 	streq	r0, [r0], #-3
     f48:	0006170e 	andeq	r1, r6, lr, lsl #14
     f4c:	192c0600 	stmdbne	ip!, {r9, sl}
     f50:	000003e5 	andeq	r0, r0, r5, ror #7
     f54:	08961208 	ldmeq	r6, {r3, r9, ip}
     f58:	2f060000 	svccs	0x00060000
     f5c:	0006460a 	andeq	r4, r6, sl, lsl #12
     f60:	00043900 	andeq	r3, r4, r0, lsl #18
     f64:	00044400 	andeq	r4, r4, r0, lsl #8
     f68:	06781300 	ldrbteq	r1, [r8], -r0, lsl #6
     f6c:	e5140000 	ldr	r0, [r4, #-0]
     f70:	00000003 	andeq	r0, r0, r3
     f74:	00070815 	andeq	r0, r7, r5, lsl r8
     f78:	0a310600 	beq	c42780 <__bss_end+0xc39750>
     f7c:	000006ae 	andeq	r0, r0, lr, lsr #13
     f80:	000001f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     f84:	0000045c 	andeq	r0, r0, ip, asr r4
     f88:	00000467 	andeq	r0, r0, r7, ror #8
     f8c:	00067813 	andeq	r7, r6, r3, lsl r8
     f90:	03eb1400 	mvneq	r1, #0, 8
     f94:	16000000 	strne	r0, [r0], -r0
     f98:	00000ad8 	ldrdeq	r0, [r0], -r8
     f9c:	5c193506 	cfldr32pl	mvfx3, [r9], {6}
     fa0:	e5000007 	str	r0, [r0, #-7]
     fa4:	02000003 	andeq	r0, r0, #3
     fa8:	00000480 	andeq	r0, r0, r0, lsl #9
     fac:	00000486 	andeq	r0, r0, r6, lsl #9
     fb0:	00067813 	andeq	r7, r6, r3, lsl r8
     fb4:	02160000 	andseq	r0, r6, #0
     fb8:	06000006 	streq	r0, [r0], -r6
     fbc:	08a61937 	stmiaeq	r6!, {r0, r1, r2, r4, r5, r8, fp, ip}
     fc0:	03e50000 	mvneq	r0, #0
     fc4:	9f020000 	svcls	0x00020000
     fc8:	a5000004 	strge	r0, [r0, #-4]
     fcc:	13000004 	movwne	r0, #4
     fd0:	00000678 	andeq	r0, r0, r8, ror r6
     fd4:	08371700 	ldmdaeq	r7!, {r8, r9, sl, ip}
     fd8:	39060000 	stmdbcc	r6, {}	; <UNPREDICTABLE>
     fdc:	0006912d 	andeq	r9, r6, sp, lsr #2
     fe0:	16020c00 	strne	r0, [r2], -r0, lsl #24
     fe4:	00000997 	muleq	r0, r7, r9
     fe8:	17053c06 	strne	r3, [r5, -r6, lsl #24]
     fec:	78000007 	stmdavc	r0, {r0, r1, r2}
     ff0:	01000006 	tsteq	r0, r6
     ff4:	000004cc 	andeq	r0, r0, ip, asr #9
     ff8:	000004d2 	ldrdeq	r0, [r0], -r2
     ffc:	00067813 	andeq	r7, r6, r3, lsl r8
    1000:	88160000 	ldmdahi	r6, {}	; <UNPREDICTABLE>
    1004:	06000006 	streq	r0, [r0], -r6
    1008:	04df0e3f 	ldrbeq	r0, [pc], #3647	; 1010 <shift+0x1010>
    100c:	004d0000 	subeq	r0, sp, r0
    1010:	eb010000 	bl	41018 <__bss_end+0x37fe8>
    1014:	00000004 	andeq	r0, r0, r4
    1018:	13000005 	movwne	r0, #5
    101c:	00000678 	andeq	r0, r0, r8, ror r6
    1020:	00069a14 	andeq	r9, r6, r4, lsl sl
    1024:	005e1400 	subseq	r1, lr, r0, lsl #8
    1028:	f0140000 			; <UNDEFINED> instruction: 0xf0140000
    102c:	00000001 	andeq	r0, r0, r1
    1030:	000b5918 	andeq	r5, fp, r8, lsl r9
    1034:	0a430600 	beq	10c283c <__bss_end+0x10b980c>
    1038:	00000584 	andeq	r0, r0, r4, lsl #11
    103c:	00051501 	andeq	r1, r5, r1, lsl #10
    1040:	00051b00 	andeq	r1, r5, r0, lsl #22
    1044:	06781300 	ldrbteq	r1, [r8], -r0, lsl #6
    1048:	16000000 	strne	r0, [r0], -r0
    104c:	000004c1 	andeq	r0, r0, r1, asr #9
    1050:	1a134606 	bne	4d2870 <__bss_end+0x4c9840>
    1054:	eb000005 	bl	1070 <shift+0x1070>
    1058:	01000003 	tsteq	r0, r3
    105c:	00000534 	andeq	r0, r0, r4, lsr r5
    1060:	0000053a 	andeq	r0, r0, sl, lsr r5
    1064:	0006a013 	andeq	sl, r6, r3, lsl r0
    1068:	f9160000 			; <UNDEFINED> instruction: 0xf9160000
    106c:	06000009 	streq	r0, [r0], -r9
    1070:	03c31349 	biceq	r1, r3, #603979777	; 0x24000001
    1074:	03eb0000 	mvneq	r0, #0
    1078:	53010000 	movwpl	r0, #4096	; 0x1000
    107c:	5e000005 	cdppl	0, 0, cr0, cr0, cr5, {0}
    1080:	13000005 	movwne	r0, #5
    1084:	000006a0 	andeq	r0, r0, r0, lsr #13
    1088:	00004d14 	andeq	r4, r0, r4, lsl sp
    108c:	af180000 	svcge	0x00180000
    1090:	06000005 	streq	r0, [r0], -r5
    1094:	08450a4c 	stmdaeq	r5, {r2, r3, r6, r9, fp}^
    1098:	73010000 	movwvc	r0, #4096	; 0x1000
    109c:	79000005 	stmdbvc	r0, {r0, r2}
    10a0:	13000005 	movwne	r0, #5
    10a4:	00000678 	andeq	r0, r0, r8, ror r6
    10a8:	07081600 	streq	r1, [r8, -r0, lsl #12]
    10ac:	4e060000 	cdpmi	0, 0, cr0, cr6, cr0, {0}
    10b0:	0009100a 	andeq	r1, r9, sl
    10b4:	0001f000 	andeq	pc, r1, r0
    10b8:	05920100 	ldreq	r0, [r2, #256]	; 0x100
    10bc:	059d0000 	ldreq	r0, [sp]
    10c0:	78130000 	ldmdavc	r3, {}	; <UNPREDICTABLE>
    10c4:	14000006 	strne	r0, [r0], #-6
    10c8:	0000004d 	andeq	r0, r0, sp, asr #32
    10cc:	04661600 	strbteq	r1, [r6], #-1536	; 0xfffffa00
    10d0:	51060000 	mrspl	r0, (UNDEF: 6)
    10d4:	0003f00e 	andeq	pc, r3, lr
    10d8:	00004d00 	andeq	r4, r0, r0, lsl #26
    10dc:	05b60100 	ldreq	r0, [r6, #256]!	; 0x100
    10e0:	05c10000 	strbeq	r0, [r1]
    10e4:	78130000 	ldmdavc	r3, {}	; <UNPREDICTABLE>
    10e8:	14000006 	strne	r0, [r0], #-6
    10ec:	000001fd 	strdeq	r0, [r0], -sp
    10f0:	04231600 	strteq	r1, [r3], #-1536	; 0xfffffa00
    10f4:	54060000 	strpl	r0, [r6], #-0
    10f8:	000b6d0a 	andeq	r6, fp, sl, lsl #26
    10fc:	0001f000 	andeq	pc, r1, r0
    1100:	05da0100 	ldrbeq	r0, [sl, #256]	; 0x100
    1104:	05e50000 	strbeq	r0, [r5, #0]!
    1108:	78130000 	ldmdavc	r3, {}	; <UNPREDICTABLE>
    110c:	14000006 	strne	r0, [r0], #-6
    1110:	0000004d 	andeq	r0, r0, sp, asr #32
    1114:	04401800 	strbeq	r1, [r0], #-2048	; 0xfffff800
    1118:	57060000 	strpl	r0, [r6, -r0]
    111c:	000a4b0a 	andeq	r4, sl, sl, lsl #22
    1120:	05fa0100 	ldrbeq	r0, [sl, #256]!	; 0x100
    1124:	06190000 	ldreq	r0, [r9], -r0
    1128:	78130000 	ldmdavc	r3, {}	; <UNPREDICTABLE>
    112c:	14000006 	strne	r0, [r0], #-6
    1130:	000000a9 	andeq	r0, r0, r9, lsr #1
    1134:	00004d14 	andeq	r4, r0, r4, lsl sp
    1138:	004d1400 	subeq	r1, sp, r0, lsl #8
    113c:	4d140000 	ldcmi	0, cr0, [r4, #-0]
    1140:	14000000 	strne	r0, [r0], #-0
    1144:	000006a6 	andeq	r0, r0, r6, lsr #13
    1148:	0b991800 	bleq	fe647150 <__bss_end+0xfe63e120>
    114c:	5a060000 	bpl	181154 <__bss_end+0x178124>
    1150:	000c0e05 	andeq	r0, ip, r5, lsl #28
    1154:	062e0100 	strteq	r0, [lr], -r0, lsl #2
    1158:	064d0000 	strbeq	r0, [sp], -r0
    115c:	78130000 	ldmdavc	r3, {}	; <UNPREDICTABLE>
    1160:	14000006 	strne	r0, [r0], #-6
    1164:	000000e0 	andeq	r0, r0, r0, ror #1
    1168:	00004d14 	andeq	r4, r0, r4, lsl sp
    116c:	004d1400 	subeq	r1, sp, r0, lsl #8
    1170:	4d140000 	ldcmi	0, cr0, [r4, #-0]
    1174:	14000000 	strne	r0, [r0], #-0
    1178:	000006a6 	andeq	r0, r0, r6, lsr #13
    117c:	04531900 	ldrbeq	r1, [r3], #-2304	; 0xfffff700
    1180:	5d060000 	stcpl	0, cr0, [r6, #-0]
    1184:	0007af0a 	andeq	sl, r7, sl, lsl #30
    1188:	0001f000 	andeq	pc, r1, r0
    118c:	06620100 	strbteq	r0, [r2], -r0, lsl #2
    1190:	78130000 	ldmdavc	r3, {}	; <UNPREDICTABLE>
    1194:	14000006 	strne	r0, [r0], #-6
    1198:	00000368 	andeq	r0, r0, r8, ror #6
    119c:	0006ac14 	andeq	sl, r6, r4, lsl ip
    11a0:	03000000 	movweq	r0, #0
    11a4:	000003f1 	strdeq	r0, [r0], -r1
    11a8:	03f1040d 	mvnseq	r0, #218103808	; 0xd000000
    11ac:	e51a0000 	ldr	r0, [sl, #-0]
    11b0:	8b000003 	blhi	11c4 <shift+0x11c4>
    11b4:	91000006 	tstls	r0, r6
    11b8:	13000006 	movwne	r0, #6
    11bc:	00000678 	andeq	r0, r0, r8, ror r6
    11c0:	03f11b00 	mvnseq	r1, #0, 22
    11c4:	067e0000 	ldrbteq	r0, [lr], -r0
    11c8:	040d0000 	streq	r0, [sp], #-0
    11cc:	0000003f 	andeq	r0, r0, pc, lsr r0
    11d0:	0673040d 	ldrbteq	r0, [r3], -sp, lsl #8
    11d4:	041c0000 	ldreq	r0, [ip], #-0
    11d8:	00000065 	andeq	r0, r0, r5, rrx
    11dc:	2c0f041d 	cfstrscs	mvf0, [pc], {29}
    11e0:	be000000 	cdplt	0, 0, cr0, cr0, cr0, {0}
    11e4:	10000006 	andne	r0, r0, r6
    11e8:	0000005e 	andeq	r0, r0, lr, asr r0
    11ec:	ae030009 	cdpge	0, 0, cr0, cr3, cr9, {0}
    11f0:	1e000006 	cdpne	0, 0, cr0, cr0, cr6, {0}
    11f4:	00000d5c 	andeq	r0, r0, ip, asr sp
    11f8:	be0ca401 	cdplt	4, 0, cr10, cr12, cr1, {0}
    11fc:	05000006 	streq	r0, [r0, #-6]
    1200:	008ff803 	addeq	pc, pc, r3, lsl #16
    1204:	094e1f00 	stmdbeq	lr, {r8, r9, sl, fp, ip}^
    1208:	a6010000 	strge	r0, [r1], -r0
    120c:	000e7c0a 	andeq	r7, lr, sl, lsl #24
    1210:	00004d00 	andeq	r4, r0, r0, lsl #26
    1214:	0087c400 	addeq	ip, r7, r0, lsl #8
    1218:	0000b000 	andeq	fp, r0, r0
    121c:	339c0100 	orrscc	r0, ip, #0, 2
    1220:	20000007 	andcs	r0, r0, r7
    1224:	0000100a 	andeq	r1, r0, sl
    1228:	f71ba601 			; <UNDEFINED> instruction: 0xf71ba601
    122c:	03000001 	movweq	r0, #1
    1230:	207fac91 			; <UNDEFINED> instruction: 0x207fac91
    1234:	00000edb 	ldrdeq	r0, [r0], -fp
    1238:	4d2aa601 	stcmi	6, cr10, [sl, #-4]!
    123c:	03000000 	movweq	r0, #0
    1240:	1e7fa891 	mrcne	8, 3, sl, cr15, cr1, {4}
    1244:	00000db4 			; <UNDEFINED> instruction: 0x00000db4
    1248:	330aa801 	movwcc	sl, #43009	; 0xa801
    124c:	03000007 	movweq	r0, #7
    1250:	1e7fb491 	mrcne	4, 3, fp, cr15, cr1, {4}
    1254:	00000c80 	andeq	r0, r0, r0, lsl #25
    1258:	3809ac01 	stmdacc	r9, {r0, sl, fp, sp, pc}
    125c:	02000000 	andeq	r0, r0, #0
    1260:	0f007491 	svceq	0x00007491
    1264:	00000025 	andeq	r0, r0, r5, lsr #32
    1268:	00000743 	andeq	r0, r0, r3, asr #14
    126c:	00005e10 	andeq	r5, r0, r0, lsl lr
    1270:	21003f00 	tstcs	r0, r0, lsl #30
    1274:	00000ec0 	andeq	r0, r0, r0, asr #29
    1278:	4f0a9801 	svcmi	0x000a9801
    127c:	4d00000f 	stcmi	0, cr0, [r0, #-60]	; 0xffffffc4
    1280:	88000000 	stmdahi	r0, {}	; <UNPREDICTABLE>
    1284:	3c000087 	stccc	0, cr0, [r0], {135}	; 0x87
    1288:	01000000 	mrseq	r0, (UNDEF: 0)
    128c:	0007809c 	muleq	r7, ip, r0
    1290:	65722200 	ldrbvs	r2, [r2, #-512]!	; 0xfffffe00
    1294:	9a010071 	bls	41460 <__bss_end+0x38430>
    1298:	0003ab20 	andeq	sl, r3, r0, lsr #22
    129c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    12a0:	000e711e 	andeq	r7, lr, lr, lsl r1
    12a4:	0e9b0100 	fmleqe	f0, f3, f0
    12a8:	0000004d 	andeq	r0, r0, sp, asr #32
    12ac:	00709102 	rsbseq	r9, r0, r2, lsl #2
    12b0:	000f1f23 	andeq	r1, pc, r3, lsr #30
    12b4:	068f0100 	streq	r0, [pc], r0, lsl #2
    12b8:	00000c9c 	muleq	r0, ip, ip
    12bc:	0000874c 	andeq	r8, r0, ip, asr #14
    12c0:	0000003c 	andeq	r0, r0, ip, lsr r0
    12c4:	07b99c01 	ldreq	r9, [r9, r1, lsl #24]!
    12c8:	2a200000 	bcs	8012d0 <__bss_end+0x7f82a0>
    12cc:	0100000d 	tsteq	r0, sp
    12d0:	004d218f 	subeq	r2, sp, pc, lsl #3
    12d4:	91020000 	mrsls	r0, (UNDEF: 2)
    12d8:	6572226c 	ldrbvs	r2, [r2, #-620]!	; 0xfffffd94
    12dc:	91010071 	tstls	r1, r1, ror r0
    12e0:	0003ab20 	andeq	sl, r3, r0, lsr #22
    12e4:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    12e8:	0e9d2100 	fmleqe	f2, f5, f0
    12ec:	83010000 	movwhi	r0, #4096	; 0x1000
    12f0:	000d6d0a 	andeq	r6, sp, sl, lsl #26
    12f4:	00004d00 	andeq	r4, r0, r0, lsl #26
    12f8:	00871000 	addeq	r1, r7, r0
    12fc:	00003c00 	andeq	r3, r0, r0, lsl #24
    1300:	f69c0100 			; <UNDEFINED> instruction: 0xf69c0100
    1304:	22000007 	andcs	r0, r0, #7
    1308:	00716572 	rsbseq	r6, r1, r2, ror r5
    130c:	87208501 	strhi	r8, [r0, -r1, lsl #10]!
    1310:	02000003 	andeq	r0, r0, #3
    1314:	791e7491 	ldmdbvc	lr, {r0, r4, r7, sl, ip, sp, lr}
    1318:	0100000c 	tsteq	r0, ip
    131c:	004d0e86 	subeq	r0, sp, r6, lsl #29
    1320:	91020000 	mrsls	r0, (UNDEF: 2)
    1324:	ed210070 	stc	0, cr0, [r1, #-448]!	; 0xfffffe40
    1328:	0100000f 	tsteq	r0, pc
    132c:	0d3e0a77 	vldmdbeq	lr!, {s0-s118}
    1330:	004d0000 	subeq	r0, sp, r0
    1334:	86d40000 	ldrbhi	r0, [r4], r0
    1338:	003c0000 	eorseq	r0, ip, r0
    133c:	9c010000 	stcls	0, cr0, [r1], {-0}
    1340:	00000833 	andeq	r0, r0, r3, lsr r8
    1344:	71657222 	cmnvc	r5, r2, lsr #4
    1348:	20790100 	rsbscs	r0, r9, r0, lsl #2
    134c:	00000387 	andeq	r0, r0, r7, lsl #7
    1350:	1e749102 	expnes	f1, f2
    1354:	00000c79 	andeq	r0, r0, r9, ror ip
    1358:	4d0e7a01 	vstrmi	s14, [lr, #-4]
    135c:	02000000 	andeq	r0, r0, #0
    1360:	21007091 	swpcs	r7, r1, [r0]
    1364:	00000d81 	andeq	r0, r0, r1, lsl #27
    1368:	31066b01 	tstcc	r6, r1, lsl #22
    136c:	f000000f 			; <UNDEFINED> instruction: 0xf000000f
    1370:	80000001 	andhi	r0, r0, r1
    1374:	54000086 	strpl	r0, [r0], #-134	; 0xffffff7a
    1378:	01000000 	mrseq	r0, (UNDEF: 0)
    137c:	00087f9c 	muleq	r8, ip, pc	; <UNPREDICTABLE>
    1380:	0e712000 	cdpeq	0, 7, cr2, cr1, cr0, {0}
    1384:	6b010000 	blvs	4138c <__bss_end+0x3835c>
    1388:	00004d15 	andeq	r4, r0, r5, lsl sp
    138c:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1390:	0008ec20 	andeq	lr, r8, r0, lsr #24
    1394:	256b0100 	strbcs	r0, [fp, #-256]!	; 0xffffff00
    1398:	0000004d 	andeq	r0, r0, sp, asr #32
    139c:	1e689102 	lgnnee	f1, f2
    13a0:	00000fe5 	andeq	r0, r0, r5, ror #31
    13a4:	4d0e6d01 	stcmi	13, cr6, [lr, #-4]
    13a8:	02000000 	andeq	r0, r0, #0
    13ac:	21007491 			; <UNDEFINED> instruction: 0x21007491
    13b0:	00000cb3 			; <UNDEFINED> instruction: 0x00000cb3
    13b4:	86125e01 	ldrhi	r5, [r2], -r1, lsl #28
    13b8:	8b00000f 	blhi	13fc <shift+0x13fc>
    13bc:	30000000 	andcc	r0, r0, r0
    13c0:	50000086 	andpl	r0, r0, r6, lsl #1
    13c4:	01000000 	mrseq	r0, (UNDEF: 0)
    13c8:	0008da9c 	muleq	r8, ip, sl
    13cc:	0f3c2000 	svceq	0x003c2000
    13d0:	5e010000 	cdppl	0, 0, cr0, cr1, cr0, {0}
    13d4:	00004d20 	andeq	r4, r0, r0, lsr #26
    13d8:	6c910200 	lfmvs	f0, 4, [r1], {0}
    13dc:	000ea620 	andeq	sl, lr, r0, lsr #12
    13e0:	2f5e0100 	svccs	0x005e0100
    13e4:	0000004d 	andeq	r0, r0, sp, asr #32
    13e8:	20689102 	rsbcs	r9, r8, r2, lsl #2
    13ec:	000008ec 	andeq	r0, r0, ip, ror #17
    13f0:	4d3f5e01 	ldcmi	14, cr5, [pc, #-4]!	; 13f4 <shift+0x13f4>
    13f4:	02000000 	andeq	r0, r0, #0
    13f8:	e51e6491 	ldr	r6, [lr, #-1169]	; 0xfffffb6f
    13fc:	0100000f 	tsteq	r0, pc
    1400:	008b1660 	addeq	r1, fp, r0, ror #12
    1404:	91020000 	mrsls	r0, (UNDEF: 2)
    1408:	bc210074 	stclt	0, cr0, [r1], #-464	; 0xfffffe30
    140c:	0100000f 	tsteq	r0, pc
    1410:	0cb80a52 	vldmiaeq	r8!, {s0-s81}
    1414:	004d0000 	subeq	r0, sp, r0
    1418:	85ec0000 	strbhi	r0, [ip, #0]!
    141c:	00440000 	subeq	r0, r4, r0
    1420:	9c010000 	stcls	0, cr0, [r1], {-0}
    1424:	00000926 	andeq	r0, r0, r6, lsr #18
    1428:	000f3c20 	andeq	r3, pc, r0, lsr #24
    142c:	1a520100 	bne	1481834 <__bss_end+0x1478804>
    1430:	0000004d 	andeq	r0, r0, sp, asr #32
    1434:	206c9102 	rsbcs	r9, ip, r2, lsl #2
    1438:	00000ea6 	andeq	r0, r0, r6, lsr #29
    143c:	4d295201 	sfmmi	f5, 4, [r9, #-4]!
    1440:	02000000 	andeq	r0, r0, #0
    1444:	b51e6891 	ldrlt	r6, [lr, #-2193]	; 0xfffff76f
    1448:	0100000f 	tsteq	r0, pc
    144c:	004d0e54 	subeq	r0, sp, r4, asr lr
    1450:	91020000 	mrsls	r0, (UNDEF: 2)
    1454:	af210074 	svcge	0x00210074
    1458:	0100000f 	tsteq	r0, pc
    145c:	0f910a45 	svceq	0x00910a45
    1460:	004d0000 	subeq	r0, sp, r0
    1464:	859c0000 	ldrhi	r0, [ip]
    1468:	00500000 	subseq	r0, r0, r0
    146c:	9c010000 	stcls	0, cr0, [r1], {-0}
    1470:	00000981 	andeq	r0, r0, r1, lsl #19
    1474:	000f3c20 	andeq	r3, pc, r0, lsr #24
    1478:	19450100 	stmdbne	r5, {r8}^
    147c:	0000004d 	andeq	r0, r0, sp, asr #32
    1480:	206c9102 	rsbcs	r9, ip, r2, lsl #2
    1484:	00000d95 	muleq	r0, r5, sp
    1488:	1d304501 	cfldr32ne	mvfx4, [r0, #-4]!
    148c:	02000001 	andeq	r0, r0, #1
    1490:	ac206891 	stcge	8, cr6, [r0], #-580	; 0xfffffdbc
    1494:	0100000e 	tsteq	r0, lr
    1498:	06ac4145 	strteq	r4, [ip], r5, asr #2
    149c:	91020000 	mrsls	r0, (UNDEF: 2)
    14a0:	0fe51e64 	svceq	0x00e51e64
    14a4:	47010000 	strmi	r0, [r1, -r0]
    14a8:	00004d0e 	andeq	r4, r0, lr, lsl #26
    14ac:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    14b0:	0c662300 	stcleq	3, cr2, [r6], #-0
    14b4:	3f010000 	svccc	0x00010000
    14b8:	000d9f06 	andeq	r9, sp, r6, lsl #30
    14bc:	00857000 	addeq	r7, r5, r0
    14c0:	00002c00 	andeq	r2, r0, r0, lsl #24
    14c4:	ab9c0100 	blge	fe7018cc <__bss_end+0xfe6f889c>
    14c8:	20000009 	andcs	r0, r0, r9
    14cc:	00000f3c 	andeq	r0, r0, ip, lsr pc
    14d0:	4d153f01 	ldcmi	15, cr3, [r5, #-4]
    14d4:	02000000 	andeq	r0, r0, #0
    14d8:	21007491 			; <UNDEFINED> instruction: 0x21007491
    14dc:	00000e6b 	andeq	r0, r0, fp, ror #28
    14e0:	b20a3201 	andlt	r3, sl, #268435456	; 0x10000000
    14e4:	4d00000e 	stcmi	0, cr0, [r0, #-56]	; 0xffffffc8
    14e8:	20000000 	andcs	r0, r0, r0
    14ec:	50000085 	andpl	r0, r0, r5, lsl #1
    14f0:	01000000 	mrseq	r0, (UNDEF: 0)
    14f4:	000a069c 	muleq	sl, ip, r6
    14f8:	0f3c2000 	svceq	0x003c2000
    14fc:	32010000 	andcc	r0, r1, #0
    1500:	00004d19 	andeq	r4, r0, r9, lsl sp
    1504:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1508:	000fd220 	andeq	sp, pc, r0, lsr #4
    150c:	2b320100 	blcs	c81914 <__bss_end+0xc788e4>
    1510:	000001f7 	strdeq	r0, [r0], -r7
    1514:	20689102 	rsbcs	r9, r8, r2, lsl #2
    1518:	00000edf 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    151c:	4d3c3201 	lfmmi	f3, 4, [ip, #-4]!
    1520:	02000000 	andeq	r0, r0, #0
    1524:	801e6491 	mulshi	lr, r1, r4
    1528:	0100000f 	tsteq	r0, pc
    152c:	004d0e34 	subeq	r0, sp, r4, lsr lr
    1530:	91020000 	mrsls	r0, (UNDEF: 2)
    1534:	0f210074 	svceq	0x00210074
    1538:	01000010 	tsteq	r0, r0, lsl r0
    153c:	0fd90a25 	svceq	0x00d90a25
    1540:	004d0000 	subeq	r0, sp, r0
    1544:	84d00000 	ldrbhi	r0, [r0], #0
    1548:	00500000 	subseq	r0, r0, r0
    154c:	9c010000 	stcls	0, cr0, [r1], {-0}
    1550:	00000a61 	andeq	r0, r0, r1, ror #20
    1554:	000f3c20 	andeq	r3, pc, r0, lsr #24
    1558:	18250100 	stmdane	r5!, {r8}
    155c:	0000004d 	andeq	r0, r0, sp, asr #32
    1560:	206c9102 	rsbcs	r9, ip, r2, lsl #2
    1564:	00000fd2 	ldrdeq	r0, [r0], -r2
    1568:	672a2501 	strvs	r2, [sl, -r1, lsl #10]!
    156c:	0200000a 	andeq	r0, r0, #10
    1570:	df206891 	svcle	0x00206891
    1574:	0100000e 	tsteq	r0, lr
    1578:	004d3b25 	subeq	r3, sp, r5, lsr #22
    157c:	91020000 	mrsls	r0, (UNDEF: 2)
    1580:	0c851e64 	stceq	14, cr1, [r5], {100}	; 0x64
    1584:	27010000 	strcs	r0, [r1, -r0]
    1588:	00004d0e 	andeq	r4, r0, lr, lsl #26
    158c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1590:	25040d00 	strcs	r0, [r4, #-3328]	; 0xfffff300
    1594:	03000000 	movweq	r0, #0
    1598:	00000a61 	andeq	r0, r0, r1, ror #20
    159c:	000e7721 	andeq	r7, lr, r1, lsr #14
    15a0:	0a190100 	beq	6419a8 <__bss_end+0x638978>
    15a4:	0000101b 	andeq	r1, r0, fp, lsl r0
    15a8:	0000004d 	andeq	r0, r0, sp, asr #32
    15ac:	0000848c 	andeq	r8, r0, ip, lsl #9
    15b0:	00000044 	andeq	r0, r0, r4, asr #32
    15b4:	0ab89c01 	beq	fee285c0 <__bss_end+0xfee1f590>
    15b8:	06200000 	strteq	r0, [r0], -r0
    15bc:	01000010 	tsteq	r0, r0, lsl r0
    15c0:	01f71b19 	mvnseq	r1, r9, lsl fp
    15c4:	91020000 	mrsls	r0, (UNDEF: 2)
    15c8:	0fcd206c 	svceq	0x00cd206c
    15cc:	19010000 	stmdbne	r1, {}	; <UNPREDICTABLE>
    15d0:	0001c635 	andeq	ip, r1, r5, lsr r6
    15d4:	68910200 	ldmvs	r1, {r9}
    15d8:	000f3c1e 	andeq	r3, pc, lr, lsl ip	; <UNPREDICTABLE>
    15dc:	0e1b0100 	mufeqe	f0, f3, f0
    15e0:	0000004d 	andeq	r0, r0, sp, asr #32
    15e4:	00749102 	rsbseq	r9, r4, r2, lsl #2
    15e8:	000d1e24 	andeq	r1, sp, r4, lsr #28
    15ec:	06140100 	ldreq	r0, [r4], -r0, lsl #2
    15f0:	00000c8b 	andeq	r0, r0, fp, lsl #25
    15f4:	00008470 	andeq	r8, r0, r0, ror r4
    15f8:	0000001c 	andeq	r0, r0, ip, lsl r0
    15fc:	c3239c01 			; <UNDEFINED> instruction: 0xc3239c01
    1600:	0100000f 	tsteq	r0, pc
    1604:	0d87060e 	stceq	6, cr0, [r7, #56]	; 0x38
    1608:	84440000 	strbhi	r0, [r4], #-0
    160c:	002c0000 	eoreq	r0, ip, r0
    1610:	9c010000 	stcls	0, cr0, [r1], {-0}
    1614:	00000af8 	strdeq	r0, [r0], -r8
    1618:	000d1520 	andeq	r1, sp, r0, lsr #10
    161c:	140e0100 	strne	r0, [lr], #-256	; 0xffffff00
    1620:	00000038 	andeq	r0, r0, r8, lsr r0
    1624:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1628:	00101425 	andseq	r1, r0, r5, lsr #8
    162c:	0a040100 	beq	101a34 <__bss_end+0xf8a04>
    1630:	00000da9 	andeq	r0, r0, r9, lsr #27
    1634:	0000004d 	andeq	r0, r0, sp, asr #32
    1638:	00008418 	andeq	r8, r0, r8, lsl r4
    163c:	0000002c 	andeq	r0, r0, ip, lsr #32
    1640:	70229c01 	eorvc	r9, r2, r1, lsl #24
    1644:	01006469 	tsteq	r0, r9, ror #8
    1648:	004d0e06 	subeq	r0, sp, r6, lsl #28
    164c:	91020000 	mrsls	r0, (UNDEF: 2)
    1650:	2e000074 	mcrcs	0, 0, r0, cr0, cr4, {3}
    1654:	04000003 	streq	r0, [r0], #-3
    1658:	00068200 	andeq	r8, r6, r0, lsl #4
    165c:	ba010400 	blt	42664 <__bss_end+0x39634>
    1660:	0400000d 	streq	r0, [r0], #-13
    1664:	000010f6 	strdeq	r1, [r0], -r6
    1668:	00000ee4 	andeq	r0, r0, r4, ror #29
    166c:	00008874 	andeq	r8, r0, r4, ror r8
    1670:	000004b8 			; <UNDEFINED> instruction: 0x000004b8
    1674:	000007a4 	andeq	r0, r0, r4, lsr #15
    1678:	00004902 	andeq	r4, r0, r2, lsl #18
    167c:	106e0300 	rsbne	r0, lr, r0, lsl #6
    1680:	05010000 	streq	r0, [r1, #-0]
    1684:	00006110 	andeq	r6, r0, r0, lsl r1
    1688:	31301100 	teqcc	r0, r0, lsl #2
    168c:	35343332 	ldrcc	r3, [r4, #-818]!	; 0xfffffcce
    1690:	39383736 	ldmdbcc	r8!, {r1, r2, r4, r5, r8, r9, sl, ip, sp}
    1694:	44434241 	strbmi	r4, [r3], #-577	; 0xfffffdbf
    1698:	00004645 	andeq	r4, r0, r5, asr #12
    169c:	01030104 	tsteq	r3, r4, lsl #2
    16a0:	00000025 	andeq	r0, r0, r5, lsr #32
    16a4:	00007405 	andeq	r7, r0, r5, lsl #8
    16a8:	00006100 	andeq	r6, r0, r0, lsl #2
    16ac:	00660600 	rsbeq	r0, r6, r0, lsl #12
    16b0:	00100000 	andseq	r0, r0, r0
    16b4:	00005107 	andeq	r5, r0, r7, lsl #2
    16b8:	07040800 	streq	r0, [r4, -r0, lsl #16]
    16bc:	00001516 	andeq	r1, r0, r6, lsl r5
    16c0:	bf080108 	svclt	0x00080108
    16c4:	0700000a 	streq	r0, [r0, -sl]
    16c8:	0000006d 	andeq	r0, r0, sp, rrx
    16cc:	00002a09 	andeq	r2, r0, r9, lsl #20
    16d0:	10980a00 	addsne	r0, r8, r0, lsl #20
    16d4:	64010000 	strvs	r0, [r1], #-0
    16d8:	00108806 	andseq	r8, r0, r6, lsl #16
    16dc:	008cac00 	addeq	sl, ip, r0, lsl #24
    16e0:	00008000 	andeq	r8, r0, r0
    16e4:	fb9c0100 	blx	fe701aee <__bss_end+0xfe6f8abe>
    16e8:	0b000000 	bleq	16f0 <shift+0x16f0>
    16ec:	00637273 	rsbeq	r7, r3, r3, ror r2
    16f0:	fb196401 	blx	65a6fe <__bss_end+0x6516ce>
    16f4:	02000000 	andeq	r0, r0, #0
    16f8:	640b6491 	strvs	r6, [fp], #-1169	; 0xfffffb6f
    16fc:	01007473 	tsteq	r0, r3, ror r4
    1700:	01022464 	tsteq	r2, r4, ror #8
    1704:	91020000 	mrsls	r0, (UNDEF: 2)
    1708:	756e0b60 	strbvc	r0, [lr, #-2912]!	; 0xfffff4a0
    170c:	6401006d 	strvs	r0, [r1], #-109	; 0xffffff93
    1710:	0001042d 	andeq	r0, r1, sp, lsr #8
    1714:	5c910200 	lfmpl	f0, 4, [r1], {0}
    1718:	0010ea0c 	andseq	lr, r0, ip, lsl #20
    171c:	11660100 	cmnne	r6, r0, lsl #2
    1720:	0000010b 	andeq	r0, r0, fp, lsl #2
    1724:	0c709102 	ldfeqp	f1, [r0], #-8
    1728:	0000107a 	andeq	r1, r0, sl, ror r0
    172c:	110b6701 	tstne	fp, r1, lsl #14
    1730:	02000001 	andeq	r0, r0, #1
    1734:	d40d6c91 	strle	r6, [sp], #-3217	; 0xfffff36f
    1738:	4800008c 	stmdami	r0, {r2, r3, r7}
    173c:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    1740:	69010069 	stmdbvs	r1, {r0, r3, r5, r6}
    1744:	0001040e 	andeq	r0, r1, lr, lsl #8
    1748:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    174c:	040f0000 	streq	r0, [pc], #-0	; 1754 <shift+0x1754>
    1750:	00000101 	andeq	r0, r0, r1, lsl #2
    1754:	12041110 	andne	r1, r4, #16, 2
    1758:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
    175c:	040f0074 	streq	r0, [pc], #-116	; 1764 <shift+0x1764>
    1760:	00000074 	andeq	r0, r0, r4, ror r0
    1764:	006d040f 	rsbeq	r0, sp, pc, lsl #8
    1768:	420a0000 	andmi	r0, sl, #0
    176c:	01000010 	tsteq	r0, r0, lsl r0
    1770:	104f065c 	subne	r0, pc, ip, asr r6	; <UNPREDICTABLE>
    1774:	8c440000 	marhi	acc0, r0, r4
    1778:	00680000 	rsbeq	r0, r8, r0
    177c:	9c010000 	stcls	0, cr0, [r1], {-0}
    1780:	00000176 	andeq	r0, r0, r6, ror r1
    1784:	0010e313 	andseq	lr, r0, r3, lsl r3
    1788:	125c0100 	subsne	r0, ip, #0, 2
    178c:	00000102 	andeq	r0, r0, r2, lsl #2
    1790:	136c9102 	cmnne	ip, #-2147483648	; 0x80000000
    1794:	00001048 	andeq	r1, r0, r8, asr #32
    1798:	041e5c01 	ldreq	r5, [lr], #-3073	; 0xfffff3ff
    179c:	02000001 	andeq	r0, r0, #1
    17a0:	6d0e6891 	stcvs	8, cr6, [lr, #-580]	; 0xfffffdbc
    17a4:	01006d65 	tsteq	r0, r5, ror #26
    17a8:	01110b5e 	tsteq	r1, lr, asr fp
    17ac:	91020000 	mrsls	r0, (UNDEF: 2)
    17b0:	8c600d70 	stclhi	13, cr0, [r0], #-448	; 0xfffffe40
    17b4:	003c0000 	eorseq	r0, ip, r0
    17b8:	690e0000 	stmdbvs	lr, {}	; <UNPREDICTABLE>
    17bc:	0e600100 	poweqs	f0, f0, f0
    17c0:	00000104 	andeq	r0, r0, r4, lsl #2
    17c4:	00749102 	rsbseq	r9, r4, r2, lsl #2
    17c8:	109f1400 	addsne	r1, pc, r0, lsl #8
    17cc:	52010000 	andpl	r0, r1, #0
    17d0:	0010b805 	andseq	fp, r0, r5, lsl #16
    17d4:	00010400 	andeq	r0, r1, r0, lsl #8
    17d8:	008bf000 	addeq	pc, fp, r0
    17dc:	00005400 	andeq	r5, r0, r0, lsl #8
    17e0:	af9c0100 	svcge	0x009c0100
    17e4:	0b000001 	bleq	17f0 <shift+0x17f0>
    17e8:	52010073 	andpl	r0, r1, #115	; 0x73
    17ec:	00010b18 	andeq	r0, r1, r8, lsl fp
    17f0:	6c910200 	lfmvs	f0, 4, [r1], {0}
    17f4:	0100690e 	tsteq	r0, lr, lsl #18
    17f8:	01040954 	tsteq	r4, r4, asr r9
    17fc:	91020000 	mrsls	r0, (UNDEF: 2)
    1800:	db140074 	blle	5019d8 <__bss_end+0x4f89a8>
    1804:	01000010 	tsteq	r0, r0, lsl r0
    1808:	10a60542 	adcne	r0, r6, r2, asr #10
    180c:	01040000 	mrseq	r0, (UNDEF: 4)
    1810:	8b440000 	blhi	1101818 <__bss_end+0x10f87e8>
    1814:	00ac0000 	adceq	r0, ip, r0
    1818:	9c010000 	stcls	0, cr0, [r1], {-0}
    181c:	00000215 	andeq	r0, r0, r5, lsl r2
    1820:	0031730b 	eorseq	r7, r1, fp, lsl #6
    1824:	0b194201 	bleq	652030 <__bss_end+0x649000>
    1828:	02000001 	andeq	r0, r0, #1
    182c:	730b6c91 	movwvc	r6, #48273	; 0xbc91
    1830:	42010032 	andmi	r0, r1, #50	; 0x32
    1834:	00010b29 	andeq	r0, r1, r9, lsr #22
    1838:	68910200 	ldmvs	r1, {r9}
    183c:	6d756e0b 	ldclvs	14, cr6, [r5, #-44]!	; 0xffffffd4
    1840:	31420100 	mrscc	r0, (UNDEF: 82)
    1844:	00000104 	andeq	r0, r0, r4, lsl #2
    1848:	0e649102 	lgneqs	f1, f2
    184c:	01003175 	tsteq	r0, r5, ror r1
    1850:	02151344 	andseq	r1, r5, #68, 6	; 0x10000001
    1854:	91020000 	mrsls	r0, (UNDEF: 2)
    1858:	32750e77 	rsbscc	r0, r5, #1904	; 0x770
    185c:	17440100 	strbne	r0, [r4, -r0, lsl #2]
    1860:	00000215 	andeq	r0, r0, r5, lsl r2
    1864:	00769102 	rsbseq	r9, r6, r2, lsl #2
    1868:	b6080108 	strlt	r0, [r8], -r8, lsl #2
    186c:	1400000a 	strne	r0, [r0], #-10
    1870:	0000105b 	andeq	r1, r0, fp, asr r0
    1874:	ca073601 	bgt	1cf080 <__bss_end+0x1c6050>
    1878:	11000010 	tstne	r0, r0, lsl r0
    187c:	84000001 	strhi	r0, [r0], #-1
    1880:	c000008a 	andgt	r0, r0, sl, lsl #1
    1884:	01000000 	mrseq	r0, (UNDEF: 0)
    1888:	0002759c 	muleq	r2, ip, r5
    188c:	103d1300 	eorsne	r1, sp, r0, lsl #6
    1890:	36010000 	strcc	r0, [r1], -r0
    1894:	00011115 	andeq	r1, r1, r5, lsl r1
    1898:	6c910200 	lfmvs	f0, 4, [r1], {0}
    189c:	6372730b 	cmnvs	r2, #738197504	; 0x2c000000
    18a0:	27360100 	ldrcs	r0, [r6, -r0, lsl #2]!
    18a4:	0000010b 	andeq	r0, r0, fp, lsl #2
    18a8:	0b689102 	bleq	1a25cb8 <__bss_end+0x1a1cc88>
    18ac:	006d756e 	rsbeq	r7, sp, lr, ror #10
    18b0:	04303601 	ldrteq	r3, [r0], #-1537	; 0xfffff9ff
    18b4:	02000001 	andeq	r0, r0, #1
    18b8:	690e6491 	stmdbvs	lr, {r0, r4, r7, sl, sp, lr}
    18bc:	09380100 	ldmdbeq	r8!, {r8}
    18c0:	00000104 	andeq	r0, r0, r4, lsl #2
    18c4:	00749102 	rsbseq	r9, r4, r2, lsl #2
    18c8:	0010c514 	andseq	ip, r0, r4, lsl r5
    18cc:	05240100 	streq	r0, [r4, #-256]!	; 0xffffff00
    18d0:	00001063 	andeq	r1, r0, r3, rrx
    18d4:	00000104 	andeq	r0, r0, r4, lsl #2
    18d8:	000089e8 	andeq	r8, r0, r8, ror #19
    18dc:	0000009c 	muleq	r0, ip, r0
    18e0:	02b29c01 	adcseq	r9, r2, #256	; 0x100
    18e4:	37130000 	ldrcc	r0, [r3, -r0]
    18e8:	01000010 	tsteq	r0, r0, lsl r0
    18ec:	010b1624 	tsteq	fp, r4, lsr #12
    18f0:	91020000 	mrsls	r0, (UNDEF: 2)
    18f4:	10810c6c 	addne	r0, r1, ip, ror #24
    18f8:	26010000 	strcs	r0, [r1], -r0
    18fc:	00010409 	andeq	r0, r1, r9, lsl #8
    1900:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1904:	10f11500 	rscsne	r1, r1, r0, lsl #10
    1908:	08010000 	stmdaeq	r1, {}	; <UNPREDICTABLE>
    190c:	00114406 	andseq	r4, r1, r6, lsl #8
    1910:	00887400 	addeq	r7, r8, r0, lsl #8
    1914:	00017400 	andeq	r7, r1, r0, lsl #8
    1918:	139c0100 	orrsne	r0, ip, #0, 2
    191c:	00001037 	andeq	r1, r0, r7, lsr r0
    1920:	66180801 	ldrvs	r0, [r8], -r1, lsl #16
    1924:	02000000 	andeq	r0, r0, #0
    1928:	81136491 			; <UNDEFINED> instruction: 0x81136491
    192c:	01000010 	tsteq	r0, r0, lsl r0
    1930:	01112508 	tsteq	r1, r8, lsl #10
    1934:	91020000 	mrsls	r0, (UNDEF: 2)
    1938:	12101360 	andsne	r1, r0, #96, 6	; 0x80000001
    193c:	08010000 	stmdaeq	r1, {}	; <UNPREDICTABLE>
    1940:	0000663a 	andeq	r6, r0, sl, lsr r6
    1944:	5c910200 	lfmpl	f0, 4, [r1], {0}
    1948:	0100690e 	tsteq	r0, lr, lsl #18
    194c:	0104090a 	tsteq	r4, sl, lsl #18
    1950:	91020000 	mrsls	r0, (UNDEF: 2)
    1954:	89400d74 	stmdbhi	r0, {r2, r4, r5, r6, r8, sl, fp}^
    1958:	00980000 	addseq	r0, r8, r0
    195c:	6a0e0000 	bvs	381964 <__bss_end+0x378934>
    1960:	0e1c0100 	mufeqe	f0, f4, f0
    1964:	00000104 	andeq	r0, r0, r4, lsl #2
    1968:	0d709102 	ldfeqp	f1, [r0, #-8]!
    196c:	00008968 	andeq	r8, r0, r8, ror #18
    1970:	00000060 	andeq	r0, r0, r0, rrx
    1974:	0100630e 	tsteq	r0, lr, lsl #6
    1978:	006d0e1e 	rsbeq	r0, sp, lr, lsl lr
    197c:	91020000 	mrsls	r0, (UNDEF: 2)
    1980:	0000006f 	andeq	r0, r0, pc, rrx
    1984:	00002200 	andeq	r2, r0, r0, lsl #4
    1988:	a9000200 	stmdbge	r0, {r9}
    198c:	04000007 	streq	r0, [r0], #-7
    1990:	000a2f01 	andeq	r2, sl, r1, lsl #30
    1994:	008d2c00 	addeq	r2, sp, r0, lsl #24
    1998:	008f3800 	addeq	r3, pc, r0, lsl #16
    199c:	00115000 	andseq	r5, r1, r0
    19a0:	00118000 	andseq	r8, r1, r0
    19a4:	0011e800 	andseq	lr, r1, r0, lsl #16
    19a8:	22800100 	addcs	r0, r0, #0, 2
    19ac:	02000000 	andeq	r0, r0, #0
    19b0:	0007bd00 	andeq	fp, r7, r0, lsl #26
    19b4:	ac010400 	cfstrsge	mvf0, [r1], {-0}
    19b8:	3800000a 	stmdacc	r0, {r1, r3}
    19bc:	3c00008f 	stccc	0, cr0, [r0], {143}	; 0x8f
    19c0:	5000008f 	andpl	r0, r0, pc, lsl #1
    19c4:	80000011 	andhi	r0, r0, r1, lsl r0
    19c8:	e8000011 	stmda	r0, {r0, r4}
    19cc:	01000011 	tsteq	r0, r1, lsl r0
    19d0:	00032a80 	andeq	r2, r3, r0, lsl #21
    19d4:	d1000400 	tstle	r0, r0, lsl #8
    19d8:	04000007 	streq	r0, [r0], #-7
    19dc:	00131401 	andseq	r1, r3, r1, lsl #8
    19e0:	14cd0c00 	strbne	r0, [sp], #3072	; 0xc00
    19e4:	11800000 	orrne	r0, r0, r0
    19e8:	0b0c0000 	bleq	3019f0 <__bss_end+0x2f89c0>
    19ec:	04020000 	streq	r0, [r2], #-0
    19f0:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
    19f4:	07040300 	streq	r0, [r4, -r0, lsl #6]
    19f8:	00001516 	andeq	r1, r0, r6, lsl r5
    19fc:	b9050803 	stmdblt	r5, {r0, r1, fp}
    1a00:	03000002 	movweq	r0, #2
    1a04:	14c10408 	strbne	r0, [r1], #1032	; 0x408
    1a08:	01030000 	mrseq	r0, (UNDEF: 3)
    1a0c:	000ab608 	andeq	fp, sl, r8, lsl #12
    1a10:	06010300 	streq	r0, [r1], -r0, lsl #6
    1a14:	00000ab8 			; <UNDEFINED> instruction: 0x00000ab8
    1a18:	00169904 	andseq	r9, r6, r4, lsl #18
    1a1c:	39010700 	stmdbcc	r1, {r8, r9, sl}
    1a20:	01000000 	mrseq	r0, (UNDEF: 0)
    1a24:	01d40617 	bicseq	r0, r4, r7, lsl r6
    1a28:	23050000 	movwcs	r0, #20480	; 0x5000
    1a2c:	00000012 	andeq	r0, r0, r2, lsl r0
    1a30:	00174805 	andseq	r4, r7, r5, lsl #16
    1a34:	f6050100 			; <UNDEFINED> instruction: 0xf6050100
    1a38:	02000013 	andeq	r0, r0, #19
    1a3c:	0014b405 	andseq	fp, r4, r5, lsl #8
    1a40:	b2050300 	andlt	r0, r5, #0, 6
    1a44:	04000016 	streq	r0, [r0], #-22	; 0xffffffea
    1a48:	00175805 	andseq	r5, r7, r5, lsl #16
    1a4c:	c8050500 	stmdagt	r5, {r8, sl}
    1a50:	06000016 			; <UNDEFINED> instruction: 0x06000016
    1a54:	0014fd05 	andseq	pc, r4, r5, lsl #26
    1a58:	43050700 	movwmi	r0, #22272	; 0x5700
    1a5c:	08000016 	stmdaeq	r0, {r1, r2, r4}
    1a60:	00165105 	andseq	r5, r6, r5, lsl #2
    1a64:	5f050900 	svcpl	0x00050900
    1a68:	0a000016 	beq	1ac8 <shift+0x1ac8>
    1a6c:	00156605 	andseq	r6, r5, r5, lsl #12
    1a70:	56050b00 	strpl	r0, [r5], -r0, lsl #22
    1a74:	0c000015 	stceq	0, cr0, [r0], {21}
    1a78:	00123f05 	andseq	r3, r2, r5, lsl #30
    1a7c:	58050d00 	stmdapl	r5, {r8, sl, fp}
    1a80:	0e000012 	mcreq	0, 0, r0, cr0, cr2, {0}
    1a84:	00154705 	andseq	r4, r5, r5, lsl #14
    1a88:	0b050f00 	bleq	145690 <__bss_end+0x13c660>
    1a8c:	10000017 	andne	r0, r0, r7, lsl r0
    1a90:	00168805 	andseq	r8, r6, r5, lsl #16
    1a94:	fc051100 	stc2	1, cr1, [r5], {-0}
    1a98:	12000016 	andne	r0, r0, #22
    1a9c:	00130505 	andseq	r0, r3, r5, lsl #10
    1aa0:	82051300 	andhi	r1, r5, #0, 6
    1aa4:	14000012 	strne	r0, [r0], #-18	; 0xffffffee
    1aa8:	00124c05 	andseq	r4, r2, r5, lsl #24
    1aac:	e5051500 	str	r1, [r5, #-1280]	; 0xfffffb00
    1ab0:	16000015 			; <UNDEFINED> instruction: 0x16000015
    1ab4:	0012b905 	andseq	fp, r2, r5, lsl #18
    1ab8:	f4051700 	vst1.8	{d1}, [r5], r0
    1abc:	18000011 	stmdane	r0, {r0, r4}
    1ac0:	0016ee05 	andseq	lr, r6, r5, lsl #28
    1ac4:	23051900 	movwcs	r1, #22784	; 0x5900
    1ac8:	1a000015 	bne	1b24 <shift+0x1b24>
    1acc:	0015fd05 	andseq	pc, r5, r5, lsl #26
    1ad0:	8d051b00 	vstrhi	d1, [r5, #-0]
    1ad4:	1c000012 	stcne	0, cr0, [r0], {18}
    1ad8:	00149905 	andseq	r9, r4, r5, lsl #18
    1adc:	e8051d00 	stmda	r5, {r8, sl, fp, ip}
    1ae0:	1e000013 	mcrne	0, 0, r0, cr0, cr3, {0}
    1ae4:	00167a05 	andseq	r7, r6, r5, lsl #20
    1ae8:	d6051f00 	strle	r1, [r5], -r0, lsl #30
    1aec:	20000016 	andcs	r0, r0, r6, lsl r0
    1af0:	00171705 	andseq	r1, r7, r5, lsl #14
    1af4:	25052100 	strcs	r2, [r5, #-256]	; 0xffffff00
    1af8:	22000017 	andcs	r0, r0, #23
    1afc:	00153a05 	andseq	r3, r5, r5, lsl #20
    1b00:	5d052300 	stcpl	3, cr2, [r5, #-0]
    1b04:	24000014 	strcs	r0, [r0], #-20	; 0xffffffec
    1b08:	00129c05 	andseq	r9, r2, r5, lsl #24
    1b0c:	f0052500 			; <UNDEFINED> instruction: 0xf0052500
    1b10:	26000014 			; <UNDEFINED> instruction: 0x26000014
    1b14:	00140205 	andseq	r0, r4, r5, lsl #4
    1b18:	a5052700 	strge	r2, [r5, #-1792]	; 0xfffff900
    1b1c:	28000016 	stmdacs	r0, {r1, r2, r4}
    1b20:	00141205 	andseq	r1, r4, r5, lsl #4
    1b24:	21052900 	tstcs	r5, r0, lsl #18
    1b28:	2a000014 	bcs	1b80 <shift+0x1b80>
    1b2c:	00143005 	andseq	r3, r4, r5
    1b30:	3f052b00 	svccc	0x00052b00
    1b34:	2c000014 	stccs	0, cr0, [r0], {20}
    1b38:	0013cd05 	andseq	ip, r3, r5, lsl #26
    1b3c:	4e052d00 	cdpmi	13, 0, cr2, cr5, cr0, {0}
    1b40:	2e000014 	mcrcs	0, 0, r0, cr0, cr4, {0}
    1b44:	00163405 	andseq	r3, r6, r5, lsl #8
    1b48:	6c052f00 	stcvs	15, cr2, [r5], {-0}
    1b4c:	30000014 	andcc	r0, r0, r4, lsl r0
    1b50:	00147b05 	andseq	r7, r4, r5, lsl #22
    1b54:	2d053100 	stfcss	f3, [r5, #-0]
    1b58:	32000012 	andcc	r0, r0, #18
    1b5c:	00158505 	andseq	r8, r5, r5, lsl #10
    1b60:	95053300 	strls	r3, [r5, #-768]	; 0xfffffd00
    1b64:	34000015 	strcc	r0, [r0], #-21	; 0xffffffeb
    1b68:	0015a505 	andseq	sl, r5, r5, lsl #10
    1b6c:	bb053500 	bllt	14ef74 <__bss_end+0x145f44>
    1b70:	36000013 			; <UNDEFINED> instruction: 0x36000013
    1b74:	0015b505 	andseq	fp, r5, r5, lsl #10
    1b78:	c5053700 	strgt	r3, [r5, #-1792]	; 0xfffff900
    1b7c:	38000015 	stmdacc	r0, {r0, r2, r4}
    1b80:	0015d505 	andseq	sp, r5, r5, lsl #10
    1b84:	ac053900 			; <UNDEFINED> instruction: 0xac053900
    1b88:	3a000012 	bcc	1bd8 <shift+0x1bd8>
    1b8c:	00126505 	andseq	r6, r2, r5, lsl #10
    1b90:	8a053b00 	bhi	150798 <__bss_end+0x147768>
    1b94:	3c000014 	stccc	0, cr0, [r0], {20}
    1b98:	00120405 	andseq	r0, r2, r5, lsl #8
    1b9c:	f0053d00 			; <UNDEFINED> instruction: 0xf0053d00
    1ba0:	3e000015 	mcrcc	0, 0, r0, cr0, cr5, {0}
    1ba4:	12ec0600 	rscne	r0, ip, #0, 12
    1ba8:	01020000 	mrseq	r0, (UNDEF: 2)
    1bac:	ff08026b 			; <UNDEFINED> instruction: 0xff08026b
    1bb0:	07000001 	streq	r0, [r0, -r1]
    1bb4:	000014af 	andeq	r1, r0, pc, lsr #9
    1bb8:	14027001 	strne	r7, [r2], #-1
    1bbc:	00000047 	andeq	r0, r0, r7, asr #32
    1bc0:	13c80700 	bicne	r0, r8, #0, 14
    1bc4:	71010000 	mrsvc	r0, (UNDEF: 1)
    1bc8:	00471402 	subeq	r1, r7, r2, lsl #8
    1bcc:	00010000 	andeq	r0, r1, r0
    1bd0:	0001d408 	andeq	sp, r1, r8, lsl #8
    1bd4:	01ff0900 	mvnseq	r0, r0, lsl #18
    1bd8:	02140000 	andseq	r0, r4, #0
    1bdc:	240a0000 	strcs	r0, [sl], #-0
    1be0:	11000000 	mrsne	r0, (UNDEF: 0)
    1be4:	02040800 	andeq	r0, r4, #0, 16
    1be8:	730b0000 	movwvc	r0, #45056	; 0xb000
    1bec:	01000015 	tsteq	r0, r5, lsl r0
    1bf0:	14260274 	strtne	r0, [r6], #-628	; 0xfffffd8c
    1bf4:	24000002 	strcs	r0, [r0], #-2
    1bf8:	3d0a3d3a 	stccc	13, cr3, [sl, #-232]	; 0xffffff18
    1bfc:	3d243d0f 	stccc	13, cr3, [r4, #-60]!	; 0xffffffc4
    1c00:	3d023d32 	stccc	13, cr3, [r2, #-200]	; 0xffffff38
    1c04:	3d133d05 	ldccc	13, cr3, [r3, #-20]	; 0xffffffec
    1c08:	3d0c3d0d 	stccc	13, cr3, [ip, #-52]	; 0xffffffcc
    1c0c:	3d113d23 	ldccc	13, cr3, [r1, #-140]	; 0xffffff74
    1c10:	3d013d26 	stccc	13, cr3, [r1, #-152]	; 0xffffff68
    1c14:	3d083d17 	stccc	13, cr3, [r8, #-92]	; 0xffffffa4
    1c18:	00003d09 	andeq	r3, r0, r9, lsl #26
    1c1c:	af070203 	svcge	0x00070203
    1c20:	0300000b 	movweq	r0, #11
    1c24:	0abf0801 	beq	fefc3c30 <__bss_end+0xfefbac00>
    1c28:	0d0c0000 	stceq	0, cr0, [ip, #-0]
    1c2c:	00025904 	andeq	r5, r2, r4, lsl #18
    1c30:	17330e00 	ldrne	r0, [r3, -r0, lsl #28]!
    1c34:	01070000 	mrseq	r0, (UNDEF: 7)
    1c38:	00000039 	andeq	r0, r0, r9, lsr r0
    1c3c:	0604f702 	streq	pc, [r4], -r2, lsl #14
    1c40:	0000029e 	muleq	r0, lr, r2
    1c44:	0012c605 	andseq	ip, r2, r5, lsl #12
    1c48:	d1050000 	mrsle	r0, (UNDEF: 5)
    1c4c:	01000012 	tsteq	r0, r2, lsl r0
    1c50:	0012e305 	andseq	lr, r2, r5, lsl #6
    1c54:	fd050200 	stc2	2, cr0, [r5, #-0]
    1c58:	03000012 	movweq	r0, #18
    1c5c:	00166d05 	andseq	r6, r6, r5, lsl #26
    1c60:	dc050400 	cfstrsle	mvf0, [r5], {-0}
    1c64:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
    1c68:	00162605 	andseq	r2, r6, r5, lsl #12
    1c6c:	03000600 	movweq	r0, #1536	; 0x600
    1c70:	09740502 	ldmdbeq	r4!, {r1, r8, sl}^
    1c74:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    1c78:	00150c07 	andseq	r0, r5, r7, lsl #24
    1c7c:	04040300 	streq	r0, [r4], #-768	; 0xfffffd00
    1c80:	0000121d 	andeq	r1, r0, sp, lsl r2
    1c84:	15030803 	strne	r0, [r3, #-2051]	; 0xfffff7fd
    1c88:	03000012 	movweq	r0, #18
    1c8c:	14c60408 	strbne	r0, [r6], #1032	; 0x408
    1c90:	10030000 	andne	r0, r3, r0
    1c94:	00161703 	andseq	r1, r6, r3, lsl #14
    1c98:	160e0f00 	strne	r0, [lr], -r0, lsl #30
    1c9c:	2a030000 	bcs	c1ca4 <__bss_end+0xb8c74>
    1ca0:	00025a10 	andeq	r5, r2, r0, lsl sl
    1ca4:	02c80900 	sbceq	r0, r8, #0, 18
    1ca8:	02df0000 	sbcseq	r0, pc, #0
    1cac:	00100000 	andseq	r0, r0, r0
    1cb0:	00038211 	andeq	r8, r3, r1, lsl r2
    1cb4:	112f0300 			; <UNDEFINED> instruction: 0x112f0300
    1cb8:	000002d4 	ldrdeq	r0, [r0], -r4
    1cbc:	00027611 	andeq	r7, r2, r1, lsl r6
    1cc0:	11300300 	teqne	r0, r0, lsl #6
    1cc4:	000002d4 	ldrdeq	r0, [r0], -r4
    1cc8:	0002c809 	andeq	ip, r2, r9, lsl #16
    1ccc:	00030700 	andeq	r0, r3, r0, lsl #14
    1cd0:	00240a00 	eoreq	r0, r4, r0, lsl #20
    1cd4:	00010000 	andeq	r0, r1, r0
    1cd8:	0002df12 	andeq	sp, r2, r2, lsl pc
    1cdc:	09330400 	ldmdbeq	r3!, {sl}
    1ce0:	0002f70a 	andeq	pc, r2, sl, lsl #14
    1ce4:	15030500 	strne	r0, [r3, #-1280]	; 0xfffffb00
    1ce8:	12000090 	andne	r0, r0, #144	; 0x90
    1cec:	000002eb 	andeq	r0, r0, fp, ror #5
    1cf0:	0a093404 	beq	24ed08 <__bss_end+0x245cd8>
    1cf4:	000002f7 	strdeq	r0, [r0], -r7
    1cf8:	90150305 	andsls	r0, r5, r5, lsl #6
    1cfc:	Address 0x0000000000001cfc is out of bounds.


Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
   0:	10001101 	andne	r1, r0, r1, lsl #2
   4:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
   8:	1b0e0301 	blne	380c14 <__bss_end+0x377be4>
   c:	130e250e 	movwne	r2, #58638	; 0xe50e
  10:	00000005 	andeq	r0, r0, r5
  14:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
  18:	030b130e 	movweq	r1, #45838	; 0xb30e
  1c:	110e1b0e 	tstne	lr, lr, lsl #22
  20:	10061201 	andne	r1, r6, r1, lsl #4
  24:	02000017 	andeq	r0, r0, #23
  28:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  2c:	0b3b0b3a 	bleq	ec2d1c <__bss_end+0xeb9cec>
  30:	13490b39 	movtne	r0, #39737	; 0x9b39
  34:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
  38:	24030000 	strcs	r0, [r3], #-0
  3c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
  40:	000e030b 	andeq	r0, lr, fp, lsl #6
  44:	012e0400 			; <UNDEFINED> instruction: 0x012e0400
  48:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
  4c:	0b3b0b3a 	bleq	ec2d3c <__bss_end+0xeb9d0c>
  50:	01110b39 	tsteq	r1, r9, lsr fp
  54:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
  58:	01194296 			; <UNDEFINED> instruction: 0x01194296
  5c:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
  60:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  64:	0b3b0b3a 	bleq	ec2d54 <__bss_end+0xeb9d24>
  68:	13490b39 	movtne	r0, #39737	; 0x9b39
  6c:	00001802 	andeq	r1, r0, r2, lsl #16
  70:	0b002406 	bleq	9090 <__bss_end+0x60>
  74:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
  78:	07000008 	streq	r0, [r0, -r8]
  7c:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
  80:	0b3a0e03 	bleq	e83894 <__bss_end+0xe7a864>
  84:	0b390b3b 	bleq	e42d78 <__bss_end+0xe39d48>
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
  b4:	3a0e0300 	bcc	380cbc <__bss_end+0x377c8c>
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
  e4:	0b3e0b0b 	bleq	f82d18 <__bss_end+0xf79ce8>
  e8:	00000e03 	andeq	r0, r0, r3, lsl #28
  ec:	03003408 	movweq	r3, #1032	; 0x408
  f0:	3b0b3a0e 	blcc	2ce930 <__bss_end+0x2c5900>
  f4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
  f8:	3c193f13 	ldccc	15, cr3, [r9], {19}
  fc:	09000019 	stmdbeq	r0, {r0, r3, r4}
 100:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 104:	0b3a0e03 	bleq	e83918 <__bss_end+0xe7a8e8>
 108:	0b390b3b 	bleq	e42dfc <__bss_end+0xe39dcc>
 10c:	01111349 	tsteq	r1, r9, asr #6
 110:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 114:	01194296 			; <UNDEFINED> instruction: 0x01194296
 118:	0a000013 	beq	16c <shift+0x16c>
 11c:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 120:	0b3b0b3a 	bleq	ec2e10 <__bss_end+0xeb9de0>
 124:	13490b39 	movtne	r0, #39737	; 0x9b39
 128:	00001802 	andeq	r1, r0, r2, lsl #16
 12c:	0b00240b 	bleq	9160 <__bss_end+0x130>
 130:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 134:	0c000008 	stceq	0, cr0, [r0], {8}
 138:	193f002e 	ldmdbne	pc!, {r1, r2, r3, r5}	; <UNPREDICTABLE>
 13c:	0b3a0e03 	bleq	e83950 <__bss_end+0xe7a920>
 140:	0b390b3b 	bleq	e42e34 <__bss_end+0xe39e04>
 144:	06120111 			; <UNDEFINED> instruction: 0x06120111
 148:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 14c:	0d000019 	stceq	0, cr0, [r0, #-100]	; 0xffffff9c
 150:	0e030139 	mcreq	1, 0, r0, cr3, cr9, {1}
 154:	0b3b0b3a 	bleq	ec2e44 <__bss_end+0xeb9e14>
 158:	00001301 	andeq	r1, r0, r1, lsl #6
 15c:	3f012e0e 	svccc	0x00012e0e
 160:	3a0e0319 	bcc	380dcc <__bss_end+0x377d9c>
 164:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 168:	01193c0b 	tsteq	r9, fp, lsl #24
 16c:	0f000013 	svceq	0x00000013
 170:	13490005 	movtne	r0, #36869	; 0x9005
 174:	2e100000 	cdpcs	0, 1, cr0, cr0, cr0, {0}
 178:	03193f01 	tsteq	r9, #1, 30
 17c:	3b0b3a0e 	blcc	2ce9bc <__bss_end+0x2c598c>
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
 1a8:	3b0b3a08 	blcc	2ce9d0 <__bss_end+0x2c59a0>
 1ac:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 1b0:	00180213 	andseq	r0, r8, r3, lsl r2
 1b4:	012e1400 			; <UNDEFINED> instruction: 0x012e1400
 1b8:	01111347 	tsteq	r1, r7, asr #6
 1bc:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 1c0:	00194297 	mulseq	r9, r7, r2
 1c4:	11010000 	mrsne	r0, (UNDEF: 1)
 1c8:	130e2501 	movwne	r2, #58625	; 0xe501
 1cc:	1b0e030b 	blne	380e00 <__bss_end+0x377dd0>
 1d0:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 1d4:	00171006 	andseq	r1, r7, r6
 1d8:	00240200 	eoreq	r0, r4, r0, lsl #4
 1dc:	0b3e0b0b 	bleq	f82e10 <__bss_end+0xf79de0>
 1e0:	00000e03 	andeq	r0, r0, r3, lsl #28
 1e4:	0b002403 	bleq	91f8 <__bss_end+0x1c8>
 1e8:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 1ec:	04000008 	streq	r0, [r0], #-8
 1f0:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
 1f4:	0b3b0b3a 	bleq	ec2ee4 <__bss_end+0xeb9eb4>
 1f8:	13490b39 	movtne	r0, #39737	; 0x9b39
 1fc:	26050000 	strcs	r0, [r5], -r0
 200:	00134900 	andseq	r4, r3, r0, lsl #18
 204:	01130600 	tsteq	r3, r0, lsl #12
 208:	0b0b0e03 	bleq	2c3a1c <__bss_end+0x2ba9ec>
 20c:	0b3b0b3a 	bleq	ec2efc <__bss_end+0xeb9ecc>
 210:	13010b39 	movwne	r0, #6969	; 0x1b39
 214:	0d070000 	stceq	0, cr0, [r7, #-0]
 218:	3a080300 	bcc	200e20 <__bss_end+0x1f7df0>
 21c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 220:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 224:	0800000b 	stmdaeq	r0, {r0, r1, r3}
 228:	0e030104 	adfeqs	f0, f3, f4
 22c:	0b3e196d 	bleq	f867e8 <__bss_end+0xf7d7b8>
 230:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 234:	0b3b0b3a 	bleq	ec2f24 <__bss_end+0xeb9ef4>
 238:	13010b39 	movwne	r0, #6969	; 0x1b39
 23c:	28090000 	stmdacs	r9, {}	; <UNPREDICTABLE>
 240:	1c0e0300 	stcne	3, cr0, [lr], {-0}
 244:	0a00000b 	beq	278 <shift+0x278>
 248:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 24c:	0b3b0b3a 	bleq	ec2f3c <__bss_end+0xeb9f0c>
 250:	13490b39 	movtne	r0, #39737	; 0x9b39
 254:	1802196c 	stmdane	r2, {r2, r3, r5, r6, r8, fp, ip}
 258:	020b0000 	andeq	r0, fp, #0
 25c:	3c0e0300 	stccc	3, cr0, [lr], {-0}
 260:	0c000019 	stceq	0, cr0, [r0], {25}
 264:	0b0b000f 	bleq	2c02a8 <__bss_end+0x2b7278>
 268:	00001349 	andeq	r1, r0, r9, asr #6
 26c:	0300280d 	movweq	r2, #2061	; 0x80d
 270:	000b1c08 	andeq	r1, fp, r8, lsl #24
 274:	000d0e00 	andeq	r0, sp, r0, lsl #28
 278:	0b3a0e03 	bleq	e83a8c <__bss_end+0xe7aa5c>
 27c:	0b390b3b 	bleq	e42f70 <__bss_end+0xe39f40>
 280:	0b381349 	bleq	e04fac <__bss_end+0xdfbf7c>
 284:	010f0000 	mrseq	r0, CPSR
 288:	01134901 	tsteq	r3, r1, lsl #18
 28c:	10000013 	andne	r0, r0, r3, lsl r0
 290:	13490021 	movtne	r0, #36897	; 0x9021
 294:	00000b2f 	andeq	r0, r0, pc, lsr #22
 298:	03010211 	movweq	r0, #4625	; 0x1211
 29c:	3a0b0b0e 	bcc	2c2edc <__bss_end+0x2b9eac>
 2a0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 2a4:	0013010b 	andseq	r0, r3, fp, lsl #2
 2a8:	012e1200 			; <UNDEFINED> instruction: 0x012e1200
 2ac:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 2b0:	0b3b0b3a 	bleq	ec2fa0 <__bss_end+0xeb9f70>
 2b4:	0e6e0b39 	vmoveq.8	d14[5], r0
 2b8:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 2bc:	00001301 	andeq	r1, r0, r1, lsl #6
 2c0:	49000513 	stmdbmi	r0, {r0, r1, r4, r8, sl}
 2c4:	00193413 	andseq	r3, r9, r3, lsl r4
 2c8:	00051400 	andeq	r1, r5, r0, lsl #8
 2cc:	00001349 	andeq	r1, r0, r9, asr #6
 2d0:	3f012e15 	svccc	0x00012e15
 2d4:	3a0e0319 	bcc	380f40 <__bss_end+0x377f10>
 2d8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 2dc:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 2e0:	64193c13 	ldrvs	r3, [r9], #-3091	; 0xfffff3ed
 2e4:	00130113 	andseq	r0, r3, r3, lsl r1
 2e8:	012e1600 			; <UNDEFINED> instruction: 0x012e1600
 2ec:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 2f0:	0b3b0b3a 	bleq	ec2fe0 <__bss_end+0xeb9fb0>
 2f4:	0e6e0b39 	vmoveq.8	d14[5], r0
 2f8:	0b321349 	bleq	c85024 <__bss_end+0xc7bff4>
 2fc:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 300:	00001301 	andeq	r1, r0, r1, lsl #6
 304:	03000d17 	movweq	r0, #3351	; 0xd17
 308:	3b0b3a0e 	blcc	2ceb48 <__bss_end+0x2c5b18>
 30c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 310:	320b3813 	andcc	r3, fp, #1245184	; 0x130000
 314:	1800000b 	stmdane	r0, {r0, r1, r3}
 318:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 31c:	0b3a0e03 	bleq	e83b30 <__bss_end+0xe7ab00>
 320:	0b390b3b 	bleq	e43014 <__bss_end+0xe39fe4>
 324:	0b320e6e 	bleq	c83ce4 <__bss_end+0xc7acb4>
 328:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 32c:	00001301 	andeq	r1, r0, r1, lsl #6
 330:	3f012e19 	svccc	0x00012e19
 334:	3a0e0319 	bcc	380fa0 <__bss_end+0x377f70>
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
 36c:	01391e00 	teqeq	r9, r0, lsl #28
 370:	0b3a0803 	bleq	e82384 <__bss_end+0xe79354>
 374:	0b390b3b 	bleq	e43068 <__bss_end+0xe3a038>
 378:	00001301 	andeq	r1, r0, r1, lsl #6
 37c:	0300341f 	movweq	r3, #1055	; 0x41f
 380:	3b0b3a0e 	blcc	2cebc0 <__bss_end+0x2c5b90>
 384:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 388:	1c193c13 	ldcne	12, cr3, [r9], {19}
 38c:	00196c06 	andseq	r6, r9, r6, lsl #24
 390:	00342000 	eorseq	r2, r4, r0
 394:	0b3a0e03 	bleq	e83ba8 <__bss_end+0xe7ab78>
 398:	0b390b3b 	bleq	e4308c <__bss_end+0xe3a05c>
 39c:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 3a0:	196c0b1c 	stmdbne	ip!, {r2, r3, r4, r8, r9, fp}^
 3a4:	34210000 	strtcc	r0, [r1], #-0
 3a8:	00134700 	andseq	r4, r3, r0, lsl #14
 3ac:	00342200 	eorseq	r2, r4, r0, lsl #4
 3b0:	0b3a0e03 	bleq	e83bc4 <__bss_end+0xe7ab94>
 3b4:	0b390b3b 	bleq	e430a8 <__bss_end+0xe3a078>
 3b8:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
 3bc:	00001802 	andeq	r1, r0, r2, lsl #16
 3c0:	3f012e23 	svccc	0x00012e23
 3c4:	3a0e0319 	bcc	381030 <__bss_end+0x378000>
 3c8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 3cc:	1113490b 	tstne	r3, fp, lsl #18
 3d0:	40061201 	andmi	r1, r6, r1, lsl #4
 3d4:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
 3d8:	00001301 	andeq	r1, r0, r1, lsl #6
 3dc:	03000524 	movweq	r0, #1316	; 0x524
 3e0:	3b0b3a0e 	blcc	2cec20 <__bss_end+0x2c5bf0>
 3e4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 3e8:	00180213 	andseq	r0, r8, r3, lsl r2
 3ec:	00342500 	eorseq	r2, r4, r0, lsl #10
 3f0:	0b3a0e03 	bleq	e83c04 <__bss_end+0xe7abd4>
 3f4:	0b390b3b 	bleq	e430e8 <__bss_end+0xe3a0b8>
 3f8:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 3fc:	2e260000 	cdpcs	0, 2, cr0, cr6, cr0, {0}
 400:	03193f01 	tsteq	r9, #1, 30
 404:	3b0b3a0e 	blcc	2cec44 <__bss_end+0x2c5c14>
 408:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 40c:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 410:	96184006 	ldrls	r4, [r8], -r6
 414:	00001942 	andeq	r1, r0, r2, asr #18
 418:	01110100 	tsteq	r1, r0, lsl #2
 41c:	0b130e25 	bleq	4c3cb8 <__bss_end+0x4bac88>
 420:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
 424:	06120111 			; <UNDEFINED> instruction: 0x06120111
 428:	00001710 	andeq	r1, r0, r0, lsl r7
 42c:	0b002402 	bleq	943c <__bss_end+0x40c>
 430:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 434:	0300000e 	movweq	r0, #14
 438:	13490026 	movtne	r0, #36902	; 0x9026
 43c:	24040000 	strcs	r0, [r4], #-0
 440:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 444:	0008030b 	andeq	r0, r8, fp, lsl #6
 448:	00160500 	andseq	r0, r6, r0, lsl #10
 44c:	0b3a0e03 	bleq	e83c60 <__bss_end+0xe7ac30>
 450:	0b390b3b 	bleq	e43144 <__bss_end+0xe3a114>
 454:	00001349 	andeq	r1, r0, r9, asr #6
 458:	03011306 	movweq	r1, #4870	; 0x1306
 45c:	3a0b0b0e 	bcc	2c309c <__bss_end+0x2ba06c>
 460:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 464:	0013010b 	andseq	r0, r3, fp, lsl #2
 468:	000d0700 	andeq	r0, sp, r0, lsl #14
 46c:	0b3a0803 	bleq	e82480 <__bss_end+0xe79450>
 470:	0b390b3b 	bleq	e43164 <__bss_end+0xe3a134>
 474:	0b381349 	bleq	e051a0 <__bss_end+0xdfc170>
 478:	04080000 	streq	r0, [r8], #-0
 47c:	6d0e0301 	stcvs	3, cr0, [lr, #-4]
 480:	0b0b3e19 	bleq	2cfcec <__bss_end+0x2c6cbc>
 484:	3a13490b 	bcc	4d28b8 <__bss_end+0x4c9888>
 488:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 48c:	0013010b 	andseq	r0, r3, fp, lsl #2
 490:	00280900 	eoreq	r0, r8, r0, lsl #18
 494:	0b1c0803 	bleq	7024a8 <__bss_end+0x6f9478>
 498:	280a0000 	stmdacs	sl, {}	; <UNPREDICTABLE>
 49c:	1c0e0300 	stcne	3, cr0, [lr], {-0}
 4a0:	0b00000b 	bleq	4d4 <shift+0x4d4>
 4a4:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 4a8:	0b3b0b3a 	bleq	ec3198 <__bss_end+0xeba168>
 4ac:	13490b39 	movtne	r0, #39737	; 0x9b39
 4b0:	1802196c 	stmdane	r2, {r2, r3, r5, r6, r8, fp, ip}
 4b4:	020c0000 	andeq	r0, ip, #0
 4b8:	3c0e0300 	stccc	3, cr0, [lr], {-0}
 4bc:	0d000019 	stceq	0, cr0, [r0, #-100]	; 0xffffff9c
 4c0:	0b0b000f 	bleq	2c0504 <__bss_end+0x2b74d4>
 4c4:	00001349 	andeq	r1, r0, r9, asr #6
 4c8:	03000d0e 	movweq	r0, #3342	; 0xd0e
 4cc:	3b0b3a0e 	blcc	2ced0c <__bss_end+0x2c5cdc>
 4d0:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 4d4:	000b3813 	andeq	r3, fp, r3, lsl r8
 4d8:	01010f00 	tsteq	r1, r0, lsl #30
 4dc:	13011349 	movwne	r1, #4937	; 0x1349
 4e0:	21100000 	tstcs	r0, r0
 4e4:	2f134900 	svccs	0x00134900
 4e8:	1100000b 	tstne	r0, fp
 4ec:	0e030102 	adfeqs	f0, f3, f2
 4f0:	0b3a0b0b 	bleq	e83124 <__bss_end+0xe7a0f4>
 4f4:	0b390b3b 	bleq	e431e8 <__bss_end+0xe3a1b8>
 4f8:	00001301 	andeq	r1, r0, r1, lsl #6
 4fc:	3f012e12 	svccc	0x00012e12
 500:	3a0e0319 	bcc	38116c <__bss_end+0x37813c>
 504:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 508:	3c0e6e0b 	stccc	14, cr6, [lr], {11}
 50c:	01136419 	tsteq	r3, r9, lsl r4
 510:	13000013 	movwne	r0, #19
 514:	13490005 	movtne	r0, #36869	; 0x9005
 518:	00001934 	andeq	r1, r0, r4, lsr r9
 51c:	49000514 	stmdbmi	r0, {r2, r4, r8, sl}
 520:	15000013 	strne	r0, [r0, #-19]	; 0xffffffed
 524:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 528:	0b3a0e03 	bleq	e83d3c <__bss_end+0xe7ad0c>
 52c:	0b390b3b 	bleq	e43220 <__bss_end+0xe3a1f0>
 530:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 534:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 538:	00001301 	andeq	r1, r0, r1, lsl #6
 53c:	3f012e16 	svccc	0x00012e16
 540:	3a0e0319 	bcc	3811ac <__bss_end+0x37817c>
 544:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 548:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 54c:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
 550:	01136419 	tsteq	r3, r9, lsl r4
 554:	17000013 	smladne	r0, r3, r0, r0
 558:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 55c:	0b3b0b3a 	bleq	ec324c <__bss_end+0xeba21c>
 560:	13490b39 	movtne	r0, #39737	; 0x9b39
 564:	0b320b38 	bleq	c8324c <__bss_end+0xc7a21c>
 568:	2e180000 	cdpcs	0, 1, cr0, cr8, cr0, {0}
 56c:	03193f01 	tsteq	r9, #1, 30
 570:	3b0b3a0e 	blcc	2cedb0 <__bss_end+0x2c5d80>
 574:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 578:	3c0b320e 	sfmcc	f3, 4, [fp], {14}
 57c:	01136419 	tsteq	r3, r9, lsl r4
 580:	19000013 	stmdbne	r0, {r0, r1, r4}
 584:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 588:	0b3a0e03 	bleq	e83d9c <__bss_end+0xe7ad6c>
 58c:	0b390b3b 	bleq	e43280 <__bss_end+0xe3a250>
 590:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 594:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 598:	00001364 	andeq	r1, r0, r4, ror #6
 59c:	4901151a 	stmdbmi	r1, {r1, r3, r4, r8, sl, ip}
 5a0:	01136413 	tsteq	r3, r3, lsl r4
 5a4:	1b000013 	blne	5f8 <shift+0x5f8>
 5a8:	131d001f 	tstne	sp, #31
 5ac:	00001349 	andeq	r1, r0, r9, asr #6
 5b0:	0b00101c 	bleq	4628 <shift+0x4628>
 5b4:	0013490b 	andseq	r4, r3, fp, lsl #18
 5b8:	000f1d00 	andeq	r1, pc, r0, lsl #26
 5bc:	00000b0b 	andeq	r0, r0, fp, lsl #22
 5c0:	0300341e 	movweq	r3, #1054	; 0x41e
 5c4:	3b0b3a0e 	blcc	2cee04 <__bss_end+0x2c5dd4>
 5c8:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 5cc:	00180213 	andseq	r0, r8, r3, lsl r2
 5d0:	012e1f00 			; <UNDEFINED> instruction: 0x012e1f00
 5d4:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 5d8:	0b3b0b3a 	bleq	ec32c8 <__bss_end+0xeba298>
 5dc:	0e6e0b39 	vmoveq.8	d14[5], r0
 5e0:	01111349 	tsteq	r1, r9, asr #6
 5e4:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 5e8:	01194296 			; <UNDEFINED> instruction: 0x01194296
 5ec:	20000013 	andcs	r0, r0, r3, lsl r0
 5f0:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
 5f4:	0b3b0b3a 	bleq	ec32e4 <__bss_end+0xeba2b4>
 5f8:	13490b39 	movtne	r0, #39737	; 0x9b39
 5fc:	00001802 	andeq	r1, r0, r2, lsl #16
 600:	3f012e21 	svccc	0x00012e21
 604:	3a0e0319 	bcc	381270 <__bss_end+0x378240>
 608:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 60c:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 610:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 614:	97184006 	ldrls	r4, [r8, -r6]
 618:	13011942 	movwne	r1, #6466	; 0x1942
 61c:	34220000 	strtcc	r0, [r2], #-0
 620:	3a080300 	bcc	201228 <__bss_end+0x1f81f8>
 624:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 628:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 62c:	23000018 	movwcs	r0, #24
 630:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 634:	0b3a0e03 	bleq	e83e48 <__bss_end+0xe7ae18>
 638:	0b390b3b 	bleq	e4332c <__bss_end+0xe3a2fc>
 63c:	01110e6e 	tsteq	r1, lr, ror #28
 640:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 644:	01194297 			; <UNDEFINED> instruction: 0x01194297
 648:	24000013 	strcs	r0, [r0], #-19	; 0xffffffed
 64c:	193f002e 	ldmdbne	pc!, {r1, r2, r3, r5}	; <UNPREDICTABLE>
 650:	0b3a0e03 	bleq	e83e64 <__bss_end+0xe7ae34>
 654:	0b390b3b 	bleq	e43348 <__bss_end+0xe3a318>
 658:	01110e6e 	tsteq	r1, lr, ror #28
 65c:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 660:	00194297 	mulseq	r9, r7, r2
 664:	012e2500 			; <UNDEFINED> instruction: 0x012e2500
 668:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 66c:	0b3b0b3a 	bleq	ec335c <__bss_end+0xeba32c>
 670:	0e6e0b39 	vmoveq.8	d14[5], r0
 674:	01111349 	tsteq	r1, r9, asr #6
 678:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 67c:	00194297 	mulseq	r9, r7, r2
 680:	11010000 	mrsne	r0, (UNDEF: 1)
 684:	130e2501 	movwne	r2, #58625	; 0xe501
 688:	1b0e030b 	blne	3812bc <__bss_end+0x37828c>
 68c:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 690:	00171006 	andseq	r1, r7, r6
 694:	01390200 	teqeq	r9, r0, lsl #4
 698:	00001301 	andeq	r1, r0, r1, lsl #6
 69c:	03003403 	movweq	r3, #1027	; 0x403
 6a0:	3b0b3a0e 	blcc	2ceee0 <__bss_end+0x2c5eb0>
 6a4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 6a8:	1c193c13 	ldcne	12, cr3, [r9], {19}
 6ac:	0400000a 	streq	r0, [r0], #-10
 6b0:	0b3a003a 	bleq	e807a0 <__bss_end+0xe77770>
 6b4:	0b390b3b 	bleq	e433a8 <__bss_end+0xe3a378>
 6b8:	00001318 	andeq	r1, r0, r8, lsl r3
 6bc:	49010105 	stmdbmi	r1, {r0, r2, r8}
 6c0:	00130113 	andseq	r0, r3, r3, lsl r1
 6c4:	00210600 	eoreq	r0, r1, r0, lsl #12
 6c8:	0b2f1349 	bleq	bc53f4 <__bss_end+0xbbc3c4>
 6cc:	26070000 	strcs	r0, [r7], -r0
 6d0:	00134900 	andseq	r4, r3, r0, lsl #18
 6d4:	00240800 	eoreq	r0, r4, r0, lsl #16
 6d8:	0b3e0b0b 	bleq	f8330c <__bss_end+0xf7a2dc>
 6dc:	00000e03 	andeq	r0, r0, r3, lsl #28
 6e0:	47003409 	strmi	r3, [r0, -r9, lsl #8]
 6e4:	0a000013 	beq	738 <shift+0x738>
 6e8:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 6ec:	0b3a0e03 	bleq	e83f00 <__bss_end+0xe7aed0>
 6f0:	0b390b3b 	bleq	e433e4 <__bss_end+0xe3a3b4>
 6f4:	01110e6e 	tsteq	r1, lr, ror #28
 6f8:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 6fc:	01194297 			; <UNDEFINED> instruction: 0x01194297
 700:	0b000013 	bleq	754 <shift+0x754>
 704:	08030005 	stmdaeq	r3, {r0, r2}
 708:	0b3b0b3a 	bleq	ec33f8 <__bss_end+0xeba3c8>
 70c:	13490b39 	movtne	r0, #39737	; 0x9b39
 710:	00001802 	andeq	r1, r0, r2, lsl #16
 714:	0300340c 	movweq	r3, #1036	; 0x40c
 718:	3b0b3a0e 	blcc	2cef58 <__bss_end+0x2c5f28>
 71c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 720:	00180213 	andseq	r0, r8, r3, lsl r2
 724:	010b0d00 	tsteq	fp, r0, lsl #26
 728:	06120111 			; <UNDEFINED> instruction: 0x06120111
 72c:	340e0000 	strcc	r0, [lr], #-0
 730:	3a080300 	bcc	201338 <__bss_end+0x1f8308>
 734:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 738:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 73c:	0f000018 	svceq	0x00000018
 740:	0b0b000f 	bleq	2c0784 <__bss_end+0x2b7754>
 744:	00001349 	andeq	r1, r0, r9, asr #6
 748:	00002610 	andeq	r2, r0, r0, lsl r6
 74c:	000f1100 	andeq	r1, pc, r0, lsl #2
 750:	00000b0b 	andeq	r0, r0, fp, lsl #22
 754:	0b002412 	bleq	97a4 <__bss_end+0x774>
 758:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 75c:	13000008 	movwne	r0, #8
 760:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
 764:	0b3b0b3a 	bleq	ec3454 <__bss_end+0xeba424>
 768:	13490b39 	movtne	r0, #39737	; 0x9b39
 76c:	00001802 	andeq	r1, r0, r2, lsl #16
 770:	3f012e14 	svccc	0x00012e14
 774:	3a0e0319 	bcc	3813e0 <__bss_end+0x3783b0>
 778:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 77c:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 780:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 784:	97184006 	ldrls	r4, [r8, -r6]
 788:	13011942 	movwne	r1, #6466	; 0x1942
 78c:	2e150000 	cdpcs	0, 1, cr0, cr5, cr0, {0}
 790:	03193f01 	tsteq	r9, #1, 30
 794:	3b0b3a0e 	blcc	2cefd4 <__bss_end+0x2c5fa4>
 798:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 79c:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 7a0:	96184006 	ldrls	r4, [r8], -r6
 7a4:	00001942 	andeq	r1, r0, r2, asr #18
 7a8:	00110100 	andseq	r0, r1, r0, lsl #2
 7ac:	01110610 	tsteq	r1, r0, lsl r6
 7b0:	0e030112 	mcreq	1, 0, r0, cr3, cr2, {0}
 7b4:	0e250e1b 	mcreq	14, 1, r0, cr5, cr11, {0}
 7b8:	00000513 	andeq	r0, r0, r3, lsl r5
 7bc:	00110100 	andseq	r0, r1, r0, lsl #2
 7c0:	01110610 	tsteq	r1, r0, lsl r6
 7c4:	0e030112 	mcreq	1, 0, r0, cr3, cr2, {0}
 7c8:	0e250e1b 	mcreq	14, 1, r0, cr5, cr11, {0}
 7cc:	00000513 	andeq	r0, r0, r3, lsl r5
 7d0:	01110100 	tsteq	r1, r0, lsl #2
 7d4:	0b130e25 	bleq	4c4070 <__bss_end+0x4bb040>
 7d8:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
 7dc:	00001710 	andeq	r1, r0, r0, lsl r7
 7e0:	0b002402 	bleq	97f0 <__bss_end+0x7c0>
 7e4:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 7e8:	03000008 	movweq	r0, #8
 7ec:	0b0b0024 	bleq	2c0884 <__bss_end+0x2b7854>
 7f0:	0e030b3e 	vmoveq.16	d3[0], r0
 7f4:	04040000 	streq	r0, [r4], #-0
 7f8:	3e0e0301 	cdpcc	3, 0, cr0, cr14, cr1, {0}
 7fc:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
 800:	3b0b3a13 	blcc	2cf054 <__bss_end+0x2c6024>
 804:	010b390b 	tsteq	fp, fp, lsl #18
 808:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
 80c:	0e030028 	cdpeq	0, 0, cr0, cr3, cr8, {1}
 810:	00000b1c 	andeq	r0, r0, ip, lsl fp
 814:	03011306 	movweq	r1, #4870	; 0x1306
 818:	3a0b0b0e 	bcc	2c3458 <__bss_end+0x2ba428>
 81c:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 820:	0013010b 	andseq	r0, r3, fp, lsl #2
 824:	000d0700 	andeq	r0, sp, r0, lsl #14
 828:	0b3a0e03 	bleq	e8403c <__bss_end+0xe7b00c>
 82c:	0b39053b 	bleq	e41d20 <__bss_end+0xe38cf0>
 830:	0b381349 	bleq	e0555c <__bss_end+0xdfc52c>
 834:	26080000 	strcs	r0, [r8], -r0
 838:	00134900 	andseq	r4, r3, r0, lsl #18
 83c:	01010900 	tsteq	r1, r0, lsl #18
 840:	13011349 	movwne	r1, #4937	; 0x1349
 844:	210a0000 	mrscs	r0, (UNDEF: 10)
 848:	2f134900 	svccs	0x00134900
 84c:	0b00000b 	bleq	880 <shift+0x880>
 850:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 854:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 858:	13490b39 	movtne	r0, #39737	; 0x9b39
 85c:	00000a1c 	andeq	r0, r0, ip, lsl sl
 860:	2700150c 	strcs	r1, [r0, -ip, lsl #10]
 864:	0d000019 	stceq	0, cr0, [r0, #-100]	; 0xffffff9c
 868:	0b0b000f 	bleq	2c08ac <__bss_end+0x2b787c>
 86c:	00001349 	andeq	r1, r0, r9, asr #6
 870:	0301040e 	movweq	r0, #5134	; 0x140e
 874:	0b0b3e0e 	bleq	2d00b4 <__bss_end+0x2c7084>
 878:	3a13490b 	bcc	4d2cac <__bss_end+0x4c9c7c>
 87c:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 880:	0013010b 	andseq	r0, r3, fp, lsl #2
 884:	00160f00 	andseq	r0, r6, r0, lsl #30
 888:	0b3a0e03 	bleq	e8409c <__bss_end+0xe7b06c>
 88c:	0b390b3b 	bleq	e43580 <__bss_end+0xe3a550>
 890:	00001349 	andeq	r1, r0, r9, asr #6
 894:	00002110 	andeq	r2, r0, r0, lsl r1
 898:	00341100 	eorseq	r1, r4, r0, lsl #2
 89c:	0b3a0e03 	bleq	e840b0 <__bss_end+0xe7b080>
 8a0:	0b390b3b 	bleq	e43594 <__bss_end+0xe3a564>
 8a4:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
 8a8:	0000193c 	andeq	r1, r0, ip, lsr r9
 8ac:	47003412 	smladmi	r0, r2, r4, r3
 8b0:	3b0b3a13 	blcc	2cf104 <__bss_end+0x2c60d4>
 8b4:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
 8b8:	00180213 	andseq	r0, r8, r3, lsl r2
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
  74:	000001ec 	andeq	r0, r0, ip, ror #3
	...
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	0b300002 	bleq	c00094 <__bss_end+0xbf7064>
  88:	00040000 	andeq	r0, r4, r0
  8c:	00000000 	andeq	r0, r0, r0
  90:	00008418 	andeq	r8, r0, r8, lsl r4
  94:	0000045c 	andeq	r0, r0, ip, asr r4
	...
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	16530002 	ldrbne	r0, [r3], -r2
  a8:	00040000 	andeq	r0, r4, r0
  ac:	00000000 	andeq	r0, r0, r0
  b0:	00008874 	andeq	r8, r0, r4, ror r8
  b4:	000004b8 			; <UNDEFINED> instruction: 0x000004b8
	...
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	19850002 	stmibne	r5, {r1}
  c8:	00040000 	andeq	r0, r4, r0
  cc:	00000000 	andeq	r0, r0, r0
  d0:	00008d2c 	andeq	r8, r0, ip, lsr #26
  d4:	0000020c 	andeq	r0, r0, ip, lsl #4
	...
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	19ab0002 	stmibne	fp!, {r1}
  e8:	00040000 	andeq	r0, r4, r0
  ec:	00000000 	andeq	r0, r0, r0
  f0:	00008f38 	andeq	r8, r0, r8, lsr pc
  f4:	00000004 	andeq	r0, r0, r4
	...
 100:	00000014 	andeq	r0, r0, r4, lsl r0
 104:	19d10002 	ldmibne	r1, {r1}^
 108:	00040000 	andeq	r0, r4, r0
	...

Disassembly of section .debug_str:

00000000 <.debug_str>:
       0:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
       4:	552f632f 	strpl	r6, [pc, #-815]!	; fffffcdd <__bss_end+0xffff6cad>
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
      44:	6d2f0073 	stcvs	0, cr0, [pc, #-460]!	; fffffe80 <__bss_end+0xffff6e50>
      48:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
      4c:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
      50:	4b2f7372 	blmi	bdce20 <__bss_end+0xbd3df0>
      54:	2f616275 	svccs	0x00616275
      58:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
      5c:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
      60:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
      64:	614d6f72 	hvcvs	55026	; 0xd6f2
      68:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffafc <__bss_end+0xffff6acc>
      6c:	706d6178 	rsbvc	r6, sp, r8, ror r1
      70:	2f73656c 	svccs	0x0073656c
      74:	652d3831 	strvs	r3, [sp, #-2097]!	; 0xfffff7cf
      78:	752f6664 	strvc	r6, [pc, #-1636]!	; fffffa1c <__bss_end+0xffff69ec>
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
     114:	2b6b7a36 	blcs	1ade9f4 <__bss_end+0x1ad59c4>
     118:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
     11c:	672d2067 	strvs	r2, [sp, -r7, rrx]!
     120:	304f2d20 	subcc	r2, pc, r0, lsr #26
     124:	304f2d20 	subcc	r2, pc, r0, lsr #26
     128:	625f5f00 	subsvs	r5, pc, #0, 30
     12c:	655f7373 	ldrbvs	r7, [pc, #-883]	; fffffdc1 <__bss_end+0xffff6d91>
     130:	7200646e 	andvc	r6, r0, #1845493760	; 0x6e000000
     134:	6c757365 	ldclvs	3, cr7, [r5], #-404	; 0xfffffe6c
     138:	6d2f0074 	stcvs	0, cr0, [pc, #-464]!	; ffffff70 <__bss_end+0xffff6f40>
     13c:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
     140:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
     144:	4b2f7372 	blmi	bdcf14 <__bss_end+0xbd3ee4>
     148:	2f616275 	svccs	0x00616275
     14c:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
     150:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
     154:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
     158:	614d6f72 	hvcvs	55026	; 0xd6f2
     15c:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffbf0 <__bss_end+0xffff6bc0>
     160:	706d6178 	rsbvc	r6, sp, r8, ror r1
     164:	2f73656c 	svccs	0x0073656c
     168:	652d3831 	strvs	r3, [sp, #-2097]!	; 0xfffff7cf
     16c:	752f6664 	strvc	r6, [pc, #-1636]!	; fffffb10 <__bss_end+0xffff6ae0>
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
     21c:	4b2f7372 	blmi	bdcfec <__bss_end+0xbd3fbc>
     220:	2f616275 	svccs	0x00616275
     224:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
     228:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
     22c:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
     230:	614d6f72 	hvcvs	55026	; 0xd6f2
     234:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffcc8 <__bss_end+0xffff6c98>
     238:	706d6178 	rsbvc	r6, sp, r8, ror r1
     23c:	2f73656c 	svccs	0x0073656c
     240:	652d3831 	strvs	r3, [sp, #-2097]!	; 0xfffff7cf
     244:	752f6664 	strvc	r6, [pc, #-1636]!	; fffffbe8 <__bss_end+0xffff6bb8>
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
     48c:	7300656c 	movwvc	r6, #1388	; 0x56c
     490:	6c5f736f 	mrrcvs	3, 6, r7, pc, cr15	; <UNPREDICTABLE>
     494:	49006465 	stmdbmi	r0, {r0, r2, r5, r6, sl, sp, lr}
     498:	6c61766e 	stclvs	6, cr7, [r1], #-440	; 0xfffffe48
     49c:	485f6469 	ldmdami	pc, {r0, r3, r5, r6, sl, sp, lr}^	; <UNPREDICTABLE>
     4a0:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     4a4:	75520065 	ldrbvc	r0, [r2, #-101]	; 0xffffff9b
     4a8:	6e696e6e 	cdpvs	14, 6, cr6, cr9, cr14, {3}
     4ac:	65440067 	strbvs	r0, [r4, #-103]	; 0xffffff99
     4b0:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
     4b4:	555f656e 	ldrbpl	r6, [pc, #-1390]	; ffffff4e <__bss_end+0xffff6f1e>
     4b8:	6168636e 	cmnvs	r8, lr, ror #6
     4bc:	6465676e 	strbtvs	r6, [r5], #-1902	; 0xfffff892
     4c0:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     4c4:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     4c8:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     4cc:	6f72505f 	svcvs	0x0072505f
     4d0:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     4d4:	49504700 	ldmdbmi	r0, {r8, r9, sl, lr}^
     4d8:	61425f4f 	cmpvs	r2, pc, asr #30
     4dc:	5f006573 	svcpl	0x00006573
     4e0:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     4e4:	6f725043 	svcvs	0x00725043
     4e8:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     4ec:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     4f0:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     4f4:	72433431 	subvc	r3, r3, #822083584	; 0x31000000
     4f8:	65746165 	ldrbvs	r6, [r4, #-357]!	; 0xfffffe9b
     4fc:	6f72505f 	svcvs	0x0072505f
     500:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     504:	6a685045 	bvs	1a14620 <__bss_end+0x1a0b5f0>
     508:	65530062 	ldrbvs	r0, [r3, #-98]	; 0xffffff9e
     50c:	61505f74 	cmpvs	r0, r4, ror pc
     510:	736d6172 	cmnvc	sp, #-2147483620	; 0x8000001c
     514:	65727000 	ldrbvs	r7, [r2, #-0]!
     518:	5a5f0076 	bpl	17c06f8 <__bss_end+0x17b76c8>
     51c:	36314b4e 	ldrtcc	r4, [r1], -lr, asr #22
     520:	6f725043 	svcvs	0x00725043
     524:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     528:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     52c:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     530:	65473931 	strbvs	r3, [r7, #-2353]	; 0xfffff6cf
     534:	75435f74 	strbvc	r5, [r3, #-3956]	; 0xfffff08c
     538:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
     53c:	72505f74 	subsvc	r5, r0, #116, 30	; 0x1d0
     540:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     544:	00764573 	rsbseq	r4, r6, r3, ror r5
     548:	64616552 	strbtvs	r6, [r1], #-1362	; 0xfffffaae
     54c:	6c6e4f5f 	stclvs	15, cr4, [lr], #-380	; 0xfffffe84
     550:	68730079 	ldmdavs	r3!, {r0, r3, r4, r5, r6}^
     554:	5f74726f 	svcpl	0x0074726f
     558:	6e696c62 	cdpvs	12, 6, cr6, cr9, cr2, {3}
     55c:	614d006b 	cmpvs	sp, fp, rrx
     560:	72505f78 	subsvc	r5, r0, #120, 30	; 0x1e0
     564:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     568:	704f5f73 	subvc	r5, pc, r3, ror pc	; <UNPREDICTABLE>
     56c:	64656e65 	strbtvs	r6, [r5], #-3685	; 0xfffff19b
     570:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     574:	54007365 	strpl	r7, [r0], #-869	; 0xfffffc9b
     578:	5f555043 	svcpl	0x00555043
     57c:	746e6f43 	strbtvc	r6, [lr], #-3907	; 0xfffff0bd
     580:	00747865 	rsbseq	r7, r4, r5, ror #16
     584:	314e5a5f 	cmpcc	lr, pc, asr sl
     588:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     58c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     590:	614d5f73 	hvcvs	54771	; 0xd5f3
     594:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     598:	63533872 	cmpvs	r3, #7471104	; 0x720000
     59c:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     5a0:	7645656c 	strbvc	r6, [r5], -ip, ror #10
     5a4:	746f4e00 	strbtvc	r4, [pc], #-3584	; 5ac <shift+0x5ac>
     5a8:	41796669 	cmnmi	r9, r9, ror #12
     5ac:	42006c6c 	andmi	r6, r0, #108, 24	; 0x6c00
     5b0:	6b636f6c 	blvs	18dc368 <__bss_end+0x18d3338>
     5b4:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     5b8:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     5bc:	6f72505f 	svcvs	0x0072505f
     5c0:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     5c4:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     5c8:	4449505f 	strbmi	r5, [r9], #-95	; 0xffffffa1
     5cc:	6e697500 	cdpvs	5, 6, cr7, cr9, cr0, {0}
     5d0:	5f323374 	svcpl	0x00323374
     5d4:	494e0074 	stmdbmi	lr, {r2, r4, r5, r6}^
     5d8:	6c74434f 	ldclvs	3, cr4, [r4], #-316	; 0xfffffec4
     5dc:	65704f5f 	ldrbvs	r4, [r0, #-3935]!	; 0xfffff0a1
     5e0:	69746172 	ldmdbvs	r4!, {r1, r4, r5, r6, r8, sp, lr}^
     5e4:	42006e6f 	andmi	r6, r0, #1776	; 0x6f0
     5e8:	5f314353 	svcpl	0x00314353
     5ec:	65736142 	ldrbvs	r6, [r3, #-322]!	; 0xfffffebe
     5f0:	69615700 	stmdbvs	r1!, {r8, r9, sl, ip, lr}^
     5f4:	544e0074 	strbpl	r0, [lr], #-116	; 0xffffff8c
     5f8:	5f6b7361 	svcpl	0x006b7361
     5fc:	74617453 	strbtvc	r7, [r1], #-1107	; 0xfffffbad
     600:	63530065 	cmpvs	r3, #101	; 0x65
     604:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     608:	455f656c 	ldrbmi	r6, [pc, #-1388]	; a4 <shift+0xa4>
     60c:	42004644 	andmi	r4, r0, #68, 12	; 0x4400000
     610:	6b636f6c 	blvs	18dc3c8 <__bss_end+0x18d3398>
     614:	6d006465 	cfstrsvs	mvf6, [r0, #-404]	; 0xfffffe6c
     618:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
     61c:	5f746e65 	svcpl	0x00746e65
     620:	6b736154 	blvs	1cd8b78 <__bss_end+0x1ccfb48>
     624:	646f4e5f 	strbtvs	r4, [pc], #-3679	; 62c <shift+0x62c>
     628:	68630065 	stmdavs	r3!, {r0, r2, r5, r6}^
     62c:	745f7261 	ldrbvc	r7, [pc], #-609	; 634 <shift+0x634>
     630:	5f6b6369 	svcpl	0x006b6369
     634:	616c6564 	cmnvs	ip, r4, ror #10
     638:	6c730079 	ldclvs	0, cr0, [r3], #-484	; 0xfffffe1c
     63c:	5f706565 	svcpl	0x00706565
     640:	656d6974 	strbvs	r6, [sp, #-2420]!	; 0xfffff68c
     644:	5a5f0072 	bpl	17c0814 <__bss_end+0x17b77e4>
     648:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     64c:	636f7250 	cmnvs	pc, #80, 4
     650:	5f737365 	svcpl	0x00737365
     654:	616e614d 	cmnvs	lr, sp, asr #2
     658:	39726567 	ldmdbcc	r2!, {r0, r1, r2, r5, r6, r8, sl, sp, lr}^
     65c:	74697753 	strbtvc	r7, [r9], #-1875	; 0xfffff8ad
     660:	545f6863 	ldrbpl	r6, [pc], #-2147	; 668 <shift+0x668>
     664:	3150456f 	cmpcc	r0, pc, ror #10
     668:	72504338 	subsvc	r4, r0, #56, 6	; 0xe0000000
     66c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     670:	694c5f73 	stmdbvs	ip, {r0, r1, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     674:	4e5f7473 	mrcmi	4, 2, r7, cr15, cr3, {3}
     678:	0065646f 	rsbeq	r6, r5, pc, ror #8
     67c:	5f757063 	svcpl	0x00757063
     680:	746e6f63 	strbtvc	r6, [lr], #-3939	; 0xfffff09d
     684:	00747865 	rsbseq	r7, r4, r5, ror #16
     688:	61657243 	cmnvs	r5, r3, asr #4
     68c:	505f6574 	subspl	r6, pc, r4, ror r5	; <UNPREDICTABLE>
     690:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     694:	4f007373 	svcmi	0x00007373
     698:	006e6570 	rsbeq	r6, lr, r0, ror r5
     69c:	656d6954 	strbvs	r6, [sp, #-2388]!	; 0xfffff6ac
     6a0:	61425f72 	hvcvs	9714	; 0x25f2
     6a4:	62006573 	andvs	r6, r0, #482344960	; 0x1cc00000
     6a8:	6f747475 	svcvs	0x00747475
     6ac:	5a5f006e 	bpl	17c086c <__bss_end+0x17b783c>
     6b0:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     6b4:	636f7250 	cmnvs	pc, #80, 4
     6b8:	5f737365 	svcpl	0x00737365
     6bc:	616e614d 	cmnvs	lr, sp, asr #2
     6c0:	31726567 	cmncc	r2, r7, ror #10
     6c4:	746f4e34 	strbtvc	r4, [pc], #-3636	; 6cc <shift+0x6cc>
     6c8:	5f796669 	svcpl	0x00796669
     6cc:	636f7250 	cmnvs	pc, #80, 4
     6d0:	45737365 	ldrbmi	r7, [r3, #-869]!	; 0xfffffc9b
     6d4:	54323150 	ldrtpl	r3, [r2], #-336	; 0xfffffeb0
     6d8:	6b736154 	blvs	1cd8c30 <__bss_end+0x1ccfc00>
     6dc:	7274535f 	rsbsvc	r5, r4, #2080374785	; 0x7c000001
     6e0:	00746375 	rsbseq	r6, r4, r5, ror r3
     6e4:	5f746547 	svcpl	0x00746547
     6e8:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     6ec:	6e495f64 	cdpvs	15, 4, cr5, cr9, cr4, {3}
     6f0:	49006f66 	stmdbmi	r0, {r1, r2, r5, r6, r8, r9, sl, fp, sp, lr}
     6f4:	6c74434f 	ldclvs	3, cr4, [r4], #-316	; 0xfffffec4
     6f8:	61655200 	cmnvs	r5, r0, lsl #4
     6fc:	65540064 	ldrbvs	r0, [r4, #-100]	; 0xffffff9c
     700:	6e696d72 	mcrvs	13, 3, r6, cr9, cr2, {3}
     704:	00657461 	rsbeq	r7, r5, r1, ror #8
     708:	69746f4e 	ldmdbvs	r4!, {r1, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     70c:	505f7966 	subspl	r7, pc, r6, ror #18
     710:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     714:	5f007373 	svcpl	0x00007373
     718:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     71c:	6f725043 	svcvs	0x00725043
     720:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     724:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     728:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     72c:	76453443 	strbvc	r3, [r5], -r3, asr #8
     730:	746f4e00 	strbtvc	r4, [pc], #-3584	; 738 <shift+0x738>
     734:	00796669 	rsbseq	r6, r9, r9, ror #12
     738:	5078614d 	rsbspl	r6, r8, sp, asr #2
     73c:	4c687461 	cfstrdmi	mvd7, [r8], #-388	; 0xfffffe7c
     740:	74676e65 	strbtvc	r6, [r7], #-3685	; 0xfffff19b
     744:	614d0068 	cmpvs	sp, r8, rrx
     748:	44534678 	ldrbmi	r4, [r3], #-1656	; 0xfffff988
     74c:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
     750:	6d614e72 	stclvs	14, cr4, [r1, #-456]!	; 0xfffffe38
     754:	6e654c65 	cdpvs	12, 6, cr4, cr5, cr5, {3}
     758:	00687467 	rsbeq	r7, r8, r7, ror #8
     75c:	314e5a5f 	cmpcc	lr, pc, asr sl
     760:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     764:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     768:	614d5f73 	hvcvs	54771	; 0xd5f3
     76c:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     770:	53313172 	teqpl	r1, #-2147483620	; 0x8000001c
     774:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     778:	5f656c75 	svcpl	0x00656c75
     77c:	76455252 			; <UNDEFINED> instruction: 0x76455252
     780:	65474e00 	strbvs	r4, [r7, #-3584]	; 0xfffff200
     784:	63535f74 	cmpvs	r3, #116, 30	; 0x1d0
     788:	5f646568 	svcpl	0x00646568
     78c:	6f666e49 	svcvs	0x00666e49
     790:	7079545f 	rsbsvc	r5, r9, pc, asr r4
     794:	50470065 	subpl	r0, r7, r5, rrx
     798:	505f4f49 	subspl	r4, pc, r9, asr #30
     79c:	435f6e69 	cmpmi	pc, #1680	; 0x690
     7a0:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
     7a4:	73617400 	cmnvc	r1, #0, 8
     7a8:	6f62006b 	svcvs	0x0062006b
     7ac:	5f006c6f 	svcpl	0x00006c6f
     7b0:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     7b4:	6f725043 	svcvs	0x00725043
     7b8:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     7bc:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     7c0:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     7c4:	65473831 	strbvs	r3, [r7, #-2097]	; 0xfffff7cf
     7c8:	63535f74 	cmpvs	r3, #116, 30	; 0x1d0
     7cc:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     7d0:	5f72656c 	svcpl	0x0072656c
     7d4:	6f666e49 	svcvs	0x00666e49
     7d8:	4e303245 	cdpmi	2, 3, cr3, cr0, cr5, {2}
     7dc:	5f746547 	svcpl	0x00746547
     7e0:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     7e4:	6e495f64 	cdpvs	15, 4, cr5, cr9, cr4, {3}
     7e8:	545f6f66 	ldrbpl	r6, [pc], #-3942	; 7f0 <shift+0x7f0>
     7ec:	50657079 	rsbpl	r7, r5, r9, ror r0
     7f0:	474e0076 	smlsldxmi	r0, lr, r6, r0
     7f4:	5f4f4950 	svcpl	0x004f4950
     7f8:	65746e49 	ldrbvs	r6, [r4, #-3657]!	; 0xfffff1b7
     7fc:	70757272 	rsbsvc	r7, r5, r2, ror r2
     800:	79545f74 	ldmdbvc	r4, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     804:	54006570 	strpl	r6, [r0], #-1392	; 0xfffffa90
     808:	5f474e52 	svcpl	0x00474e52
     80c:	65736142 	ldrbvs	r6, [r3, #-322]!	; 0xfffffebe
     810:	66654400 	strbtvs	r4, [r5], -r0, lsl #8
     814:	746c7561 	strbtvc	r7, [ip], #-1377	; 0xfffffa9f
     818:	6f6c435f 	svcvs	0x006c435f
     81c:	525f6b63 	subspl	r6, pc, #101376	; 0x18c00
     820:	00657461 	rsbeq	r7, r5, r1, ror #8
     824:	6f72506d 	svcvs	0x0072506d
     828:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     82c:	73694c5f 	cmnvc	r9, #24320	; 0x5f00
     830:	65485f74 	strbvs	r5, [r8, #-3956]	; 0xfffff08c
     834:	6d006461 	cfstrsvs	mvf6, [r0, #-388]	; 0xfffffe7c
     838:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     83c:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     840:	636e465f 	cmnvs	lr, #99614720	; 0x5f00000
     844:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     848:	50433631 	subpl	r3, r3, r1, lsr r6
     84c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     850:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 68c <shift+0x68c>
     854:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     858:	31327265 	teqcc	r2, r5, ror #4
     85c:	636f6c42 	cmnvs	pc, #16896	; 0x4200
     860:	75435f6b 	strbvc	r5, [r3, #-3947]	; 0xfffff095
     864:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
     868:	72505f74 	subsvc	r5, r0, #116, 30	; 0x1d0
     86c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     870:	00764573 	rsbseq	r4, r6, r3, ror r5
     874:	6b636f4c 	blvs	18dc5ac <__bss_end+0x18d357c>
     878:	6c6e555f 	cfstr64vs	mvdx5, [lr], #-380	; 0xfffffe84
     87c:	656b636f 	strbvs	r6, [fp, #-879]!	; 0xfffffc91
     880:	4c6d0064 	stclmi	0, cr0, [sp], #-400	; 0xfffffe70
     884:	5f747361 	svcpl	0x00747361
     888:	00444950 	subeq	r4, r4, r0, asr r9
     88c:	62355a5f 	eorsvs	r5, r5, #389120	; 0x5f000
     890:	6b6e696c 	blvs	1b9ae48 <__bss_end+0x1b91e18>
     894:	77530062 	ldrbvc	r0, [r3, -r2, rrx]
     898:	68637469 	stmdavs	r3!, {r0, r3, r5, r6, sl, ip, sp, lr}^
     89c:	006f545f 	rsbeq	r5, pc, pc, asr r4	; <UNPREDICTABLE>
     8a0:	736f6c43 	cmnvc	pc, #17152	; 0x4300
     8a4:	5a5f0065 	bpl	17c0a40 <__bss_end+0x17b7a10>
     8a8:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     8ac:	636f7250 	cmnvs	pc, #80, 4
     8b0:	5f737365 	svcpl	0x00737365
     8b4:	616e614d 	cmnvs	lr, sp, asr #2
     8b8:	31726567 	cmncc	r2, r7, ror #10
     8bc:	68635332 	stmdavs	r3!, {r1, r4, r5, r8, r9, ip, lr}^
     8c0:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     8c4:	44455f65 	strbmi	r5, [r5], #-3941	; 0xfffff09b
     8c8:	00764546 	rsbseq	r4, r6, r6, asr #10
     8cc:	30435342 	subcc	r5, r3, r2, asr #6
     8d0:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
     8d4:	69520065 	ldmdbvs	r2, {r0, r2, r5, r6}^
     8d8:	676e6973 			; <UNDEFINED> instruction: 0x676e6973
     8dc:	6764455f 			; <UNDEFINED> instruction: 0x6764455f
     8e0:	72610065 	rsbvc	r0, r1, #101	; 0x65
     8e4:	48006367 	stmdami	r0, {r0, r1, r2, r5, r6, r8, r9, sp, lr}
     8e8:	00686769 	rsbeq	r6, r8, r9, ror #14
     8ec:	69746f6e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
     8f0:	64656966 	strbtvs	r6, [r5], #-2406	; 0xfffff69a
     8f4:	6165645f 	cmnvs	r5, pc, asr r4
     8f8:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
     8fc:	72610065 	rsbvc	r0, r1, #101	; 0x65
     900:	46007667 	strmi	r7, [r0], -r7, ror #12
     904:	696c6c61 	stmdbvs	ip!, {r0, r5, r6, sl, fp, sp, lr}^
     908:	455f676e 	ldrbmi	r6, [pc, #-1902]	; 1a2 <shift+0x1a2>
     90c:	00656764 	rsbeq	r6, r5, r4, ror #14
     910:	314e5a5f 	cmpcc	lr, pc, asr sl
     914:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     918:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     91c:	614d5f73 	hvcvs	54771	; 0xd5f3
     920:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     924:	4e343172 	mrcmi	1, 1, r3, cr4, cr2, {3}
     928:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     92c:	72505f79 	subsvc	r5, r0, #484	; 0x1e4
     930:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     934:	006a4573 	rsbeq	r4, sl, r3, ror r5
     938:	69466f4e 	stmdbvs	r6, {r1, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     93c:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     940:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     944:	76697244 	strbtvc	r7, [r9], -r4, asr #4
     948:	6c007265 	sfmvs	f7, 4, [r0], {101}	; 0x65
     94c:	6970676f 	ldmdbvs	r0!, {r0, r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}^
     950:	44006570 	strmi	r6, [r0], #-1392	; 0xfffffa90
     954:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
     958:	00656e69 	rsbeq	r6, r5, r9, ror #28
     95c:	61736944 	cmnvs	r3, r4, asr #18
     960:	5f656c62 	svcpl	0x00656c62
     964:	6e657645 	cdpvs	6, 6, cr7, cr5, cr5, {2}
     968:	65445f74 	strbvs	r5, [r4, #-3956]	; 0xfffff08c
     96c:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
     970:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     974:	726f6873 	rsbvc	r6, pc, #7536640	; 0x730000
     978:	6e692074 	mcrvs	0, 3, r2, cr9, cr4, {3}
     97c:	72690074 	rsbvc	r0, r9, #116	; 0x74
     980:	65707974 	ldrbvs	r7, [r0, #-2420]!	; 0xfffff68c
     984:	78614d00 	stmdavc	r1!, {r8, sl, fp, lr}^
     988:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     98c:	656d616e 	strbvs	r6, [sp, #-366]!	; 0xfffffe92
     990:	676e654c 	strbvs	r6, [lr, -ip, asr #10]!
     994:	43006874 	movwmi	r6, #2164	; 0x874
     998:	636f7250 	cmnvs	pc, #80, 4
     99c:	5f737365 	svcpl	0x00737365
     9a0:	616e614d 	cmnvs	lr, sp, asr #2
     9a4:	00726567 	rsbseq	r6, r2, r7, ror #10
     9a8:	72627474 	rsbvc	r7, r2, #116, 8	; 0x74000000
     9ac:	534e0030 	movtpl	r0, #57392	; 0xe030
     9b0:	465f4957 			; <UNDEFINED> instruction: 0x465f4957
     9b4:	73656c69 	cmnvc	r5, #26880	; 0x6900
     9b8:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     9bc:	65535f6d 	ldrbvs	r5, [r3, #-3949]	; 0xfffff093
     9c0:	63697672 	cmnvs	r9, #119537664	; 0x7200000
     9c4:	534e0065 	movtpl	r0, #57445	; 0xe065
     9c8:	505f4957 	subspl	r4, pc, r7, asr r9	; <UNPREDICTABLE>
     9cc:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     9d0:	535f7373 	cmppl	pc, #-872415231	; 0xcc000001
     9d4:	69767265 	ldmdbvs	r6!, {r0, r2, r5, r6, r9, ip, sp, lr}^
     9d8:	6f006563 	svcvs	0x00006563
     9dc:	656e6570 	strbvs	r6, [lr, #-1392]!	; 0xfffffa90
     9e0:	69665f64 	stmdbvs	r6!, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     9e4:	0073656c 	rsbseq	r6, r3, ip, ror #10
     9e8:	6c656959 			; <UNDEFINED> instruction: 0x6c656959
     9ec:	6e490064 	cdpvs	0, 4, cr0, cr9, cr4, {3}
     9f0:	69666564 	stmdbvs	r6!, {r2, r5, r6, r8, sl, sp, lr}^
     9f4:	6574696e 	ldrbvs	r6, [r4, #-2414]!	; 0xfffff692
     9f8:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     9fc:	6f72505f 	svcvs	0x0072505f
     a00:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     a04:	5f79425f 	svcpl	0x0079425f
     a08:	00444950 	subeq	r4, r4, r0, asr r9
     a0c:	62616e45 	rsbvs	r6, r1, #1104	; 0x450
     a10:	455f656c 	ldrbmi	r6, [pc, #-1388]	; 4ac <shift+0x4ac>
     a14:	746e6576 	strbtvc	r6, [lr], #-1398	; 0xfffffa8a
     a18:	7465445f 	strbtvc	r4, [r5], #-1119	; 0xfffffba1
     a1c:	69746365 	ldmdbvs	r4!, {r0, r2, r5, r6, r8, r9, sp, lr}^
     a20:	50006e6f 	andpl	r6, r0, pc, ror #28
     a24:	70697265 	rsbvc	r7, r9, r5, ror #4
     a28:	61726568 	cmnvs	r2, r8, ror #10
     a2c:	61425f6c 	cmpvs	r2, ip, ror #30
     a30:	49006573 	stmdbmi	r0, {r0, r1, r4, r5, r6, r8, sl, sp, lr}
     a34:	6c61766e 	stclvs	6, cr7, [r1], #-440	; 0xfffffe48
     a38:	505f6469 	subspl	r6, pc, r9, ror #8
     a3c:	4c006e69 	stcmi	14, cr6, [r0], {105}	; 0x69
     a40:	5f6b636f 	svcpl	0x006b636f
     a44:	6b636f4c 	blvs	18dc77c <__bss_end+0x18d374c>
     a48:	5f006465 	svcpl	0x00006465
     a4c:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     a50:	6f725043 	svcvs	0x00725043
     a54:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     a58:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     a5c:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     a60:	61483831 	cmpvs	r8, r1, lsr r8
     a64:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     a68:	6f72505f 	svcvs	0x0072505f
     a6c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     a70:	4957535f 	ldmdbmi	r7, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     a74:	4e303245 	cdpmi	2, 3, cr3, cr0, cr5, {2}
     a78:	5f495753 	svcpl	0x00495753
     a7c:	636f7250 	cmnvs	pc, #80, 4
     a80:	5f737365 	svcpl	0x00737365
     a84:	76726553 			; <UNDEFINED> instruction: 0x76726553
     a88:	6a656369 	bvs	1959834 <__bss_end+0x1950804>
     a8c:	31526a6a 	cmpcc	r2, sl, ror #20
     a90:	57535431 	smmlarpl	r3, r1, r4, r5
     a94:	65525f49 	ldrbvs	r5, [r2, #-3913]	; 0xfffff0b7
     a98:	746c7573 	strbtvc	r7, [ip], #-1395	; 0xfffffa8d
     a9c:	68637300 	stmdavs	r3!, {r8, r9, ip, sp, lr}^
     aa0:	635f6465 	cmpvs	pc, #1694498816	; 0x65000000
     aa4:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
     aa8:	47007265 	strmi	r7, [r0, -r5, ror #4]
     aac:	505f7465 	subspl	r7, pc, r5, ror #8
     ab0:	6d617261 	sfmvs	f7, 2, [r1, #-388]!	; 0xfffffe7c
     ab4:	6e750073 	mrcvs	0, 3, r0, cr5, cr3, {3}
     ab8:	6e676973 			; <UNDEFINED> instruction: 0x6e676973
     abc:	63206465 			; <UNDEFINED> instruction: 0x63206465
     ac0:	00726168 	rsbseq	r6, r2, r8, ror #2
     ac4:	65746e49 	ldrbvs	r6, [r4, #-3657]!	; 0xfffff1b7
     ac8:	70757272 	rsbsvc	r7, r5, r2, ror r2
     acc:	6c626174 	stfvse	f6, [r2], #-464	; 0xfffffe30
     ad0:	6c535f65 	mrrcvs	15, 6, r5, r3, cr5
     ad4:	00706565 	rsbseq	r6, r0, r5, ror #10
     ad8:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     adc:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     ae0:	0052525f 	subseq	r5, r2, pc, asr r2
     ae4:	5f585541 	svcpl	0x00585541
     ae8:	65736142 	ldrbvs	r6, [r3, #-322]!	; 0xfffffebe
     aec:	43534200 	cmpmi	r3, #0, 4
     af0:	61425f32 	cmpvs	r2, r2, lsr pc
     af4:	73006573 	movwvc	r6, #1395	; 0x573
     af8:	65746174 	ldrbvs	r6, [r4, #-372]!	; 0xfffffe8c
     afc:	6e6d2f00 	cdpvs	15, 6, cr2, cr13, cr0, {0}
     b00:	2f632f74 	svccs	0x00632f74
     b04:	72657355 	rsbvc	r7, r5, #1409286145	; 0x54000001
     b08:	754b2f73 	strbvc	r2, [fp, #-3955]	; 0xfffff08d
     b0c:	442f6162 	strtmi	r6, [pc], #-354	; b14 <shift+0xb14>
     b10:	6d75636f 	ldclvs	3, cr6, [r5, #-444]!	; 0xfffffe44
     b14:	73746e65 	cmnvc	r4, #1616	; 0x650
     b18:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
     b1c:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
     b20:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
     b24:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
     b28:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
     b2c:	64652d38 	strbtvs	r2, [r5], #-3384	; 0xfffff2c8
     b30:	73752f66 	cmnvc	r5, #408	; 0x198
     b34:	70737265 	rsbsvc	r7, r3, r5, ror #4
     b38:	2f656361 	svccs	0x00656361
     b3c:	5f736f73 	svcpl	0x00736f73
     b40:	6b736174 	blvs	1cd9118 <__bss_end+0x1cd00e8>
     b44:	69616d2f 	stmdbvs	r1!, {r0, r1, r2, r3, r5, r8, sl, fp, sp, lr}^
     b48:	70632e6e 	rsbvc	r2, r3, lr, ror #28
     b4c:	72570070 	subsvc	r0, r7, #112	; 0x70
     b50:	5f657469 	svcpl	0x00657469
     b54:	796c6e4f 	stmdbvc	ip!, {r0, r1, r2, r3, r6, r9, sl, fp, sp, lr}^
     b58:	68635300 	stmdavs	r3!, {r8, r9, ip, lr}^
     b5c:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     b60:	69540065 	ldmdbvs	r4, {r0, r2, r5, r6}^
     b64:	435f6b63 	cmpmi	pc, #101376	; 0x18c00
     b68:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
     b6c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     b70:	50433631 	subpl	r3, r3, r1, lsr r6
     b74:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     b78:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 9b4 <shift+0x9b4>
     b7c:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     b80:	38317265 	ldmdacc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     b84:	616d6e55 	cmnvs	sp, r5, asr lr
     b88:	69465f70 	stmdbvs	r6, {r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     b8c:	435f656c 	cmpmi	pc, #108, 10	; 0x1b000000
     b90:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     b94:	6a45746e 	bvs	115dd54 <__bss_end+0x1154d24>
     b98:	6e614800 	cdpvs	8, 6, cr4, cr1, cr0, {0}
     b9c:	5f656c64 	svcpl	0x00656c64
     ba0:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     ba4:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     ba8:	535f6d65 	cmppl	pc, #6464	; 0x1940
     bac:	73004957 	movwvc	r4, #2391	; 0x957
     bb0:	74726f68 	ldrbtvc	r6, [r2], #-3944	; 0xfffff098
     bb4:	736e7520 	cmnvc	lr, #32, 10	; 0x8000000
     bb8:	656e6769 	strbvs	r6, [lr, #-1897]!	; 0xfffff897
     bbc:	6e692064 	cdpvs	0, 6, cr2, cr9, cr4, {3}
     bc0:	6e490074 	mcrvs	0, 2, r0, cr9, cr4, {3}
     bc4:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
     bc8:	5f747075 	svcpl	0x00747075
     bcc:	746e6f43 	strbtvc	r6, [lr], #-3907	; 0xfffff0bd
     bd0:	6c6c6f72 	stclvs	15, cr6, [ip], #-456	; 0xfffffe38
     bd4:	425f7265 	subsmi	r7, pc, #1342177286	; 0x50000006
     bd8:	00657361 	rsbeq	r7, r5, r1, ror #6
     bdc:	64616552 	strbtvs	r6, [r1], #-1362	; 0xfffffaae
     be0:	6972575f 	ldmdbvs	r2!, {r0, r1, r2, r3, r4, r6, r8, r9, sl, ip, lr}^
     be4:	41006574 	tstmi	r0, r4, ror r5
     be8:	76697463 	strbtvc	r7, [r9], -r3, ror #8
     bec:	72505f65 	subsvc	r5, r0, #404	; 0x194
     bf0:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     bf4:	6f435f73 	svcvs	0x00435f73
     bf8:	00746e75 	rsbseq	r6, r4, r5, ror lr
     bfc:	626d7973 	rsbvs	r7, sp, #1884160	; 0x1cc000
     c00:	745f6c6f 	ldrbvc	r6, [pc], #-3183	; c08 <shift+0xc08>
     c04:	5f6b6369 	svcpl	0x006b6369
     c08:	616c6564 	cmnvs	ip, r4, ror #10
     c0c:	5a5f0079 	bpl	17c0df8 <__bss_end+0x17b7dc8>
     c10:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     c14:	636f7250 	cmnvs	pc, #80, 4
     c18:	5f737365 	svcpl	0x00737365
     c1c:	616e614d 	cmnvs	lr, sp, asr #2
     c20:	32726567 	rsbscc	r6, r2, #432013312	; 0x19c00000
     c24:	6e614831 	mcrvs	8, 3, r4, cr1, cr1, {1}
     c28:	5f656c64 	svcpl	0x00656c64
     c2c:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     c30:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     c34:	535f6d65 	cmppl	pc, #6464	; 0x1940
     c38:	32454957 	subcc	r4, r5, #1425408	; 0x15c000
     c3c:	57534e33 	smmlarpl	r3, r3, lr, r4
     c40:	69465f49 	stmdbvs	r6, {r0, r3, r6, r8, r9, sl, fp, ip, lr}^
     c44:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     c48:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     c4c:	7265535f 	rsbvc	r5, r5, #2080374785	; 0x7c000001
     c50:	65636976 	strbvs	r6, [r3, #-2422]!	; 0xfffff68a
     c54:	526a6a6a 	rsbpl	r6, sl, #434176	; 0x6a000
     c58:	53543131 	cmppl	r4, #1073741836	; 0x4000000c
     c5c:	525f4957 	subspl	r4, pc, #1425408	; 0x15c000
     c60:	6c757365 	ldclvs	3, cr7, [r5], #-404	; 0xfffffe6c
     c64:	6c630074 	stclvs	0, cr0, [r3], #-464	; 0xfffffe30
     c68:	0065736f 	rsbeq	r7, r5, pc, ror #6
     c6c:	5f746553 	svcpl	0x00746553
     c70:	616c6552 	cmnvs	ip, r2, asr r5
     c74:	65766974 	ldrbvs	r6, [r6, #-2420]!	; 0xfffff68c
     c78:	74657200 	strbtvc	r7, [r5], #-512	; 0xfffffe00
     c7c:	006c6176 	rsbeq	r6, ip, r6, ror r1
     c80:	7275636e 	rsbsvc	r6, r5, #-1207959551	; 0xb8000001
     c84:	6e647200 	cdpvs	2, 6, cr7, cr4, cr0, {0}
     c88:	5f006d75 	svcpl	0x00006d75
     c8c:	7331315a 	teqvc	r1, #-2147483626	; 0x80000016
     c90:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     c94:	6569795f 	strbvs	r7, [r9, #-2399]!	; 0xfffff6a1
     c98:	0076646c 	rsbseq	r6, r6, ip, ror #8
     c9c:	37315a5f 			; <UNDEFINED> instruction: 0x37315a5f
     ca0:	5f746573 	svcpl	0x00746573
     ca4:	6b736174 	blvs	1cd927c <__bss_end+0x1cd024c>
     ca8:	6165645f 	cmnvs	r5, pc, asr r4
     cac:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
     cb0:	77006a65 	strvc	r6, [r0, -r5, ror #20]
     cb4:	00746961 	rsbseq	r6, r4, r1, ror #18
     cb8:	6e365a5f 			; <UNDEFINED> instruction: 0x6e365a5f
     cbc:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     cc0:	006a6a79 	rsbeq	r6, sl, r9, ror sl
     cc4:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
     cc8:	552f632f 	strpl	r6, [pc, #-815]!	; 9a1 <shift+0x9a1>
     ccc:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
     cd0:	62754b2f 	rsbsvs	r4, r5, #48128	; 0xbc00
     cd4:	6f442f61 	svcvs	0x00442f61
     cd8:	656d7563 	strbvs	r7, [sp, #-1379]!	; 0xfffffa9d
     cdc:	2f73746e 	svccs	0x0073746e
     ce0:	6f72655a 	svcvs	0x0072655a
     ce4:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
     ce8:	6178652f 	cmnvs	r8, pc, lsr #10
     cec:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
     cf0:	38312f73 	ldmdacc	r1!, {r0, r1, r4, r5, r6, r8, r9, sl, fp, sp}
     cf4:	6664652d 	strbtvs	r6, [r4], -sp, lsr #10
     cf8:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
     cfc:	2f62696c 	svccs	0x0062696c
     d00:	2f637273 	svccs	0x00637273
     d04:	66647473 			; <UNDEFINED> instruction: 0x66647473
     d08:	2e656c69 	cdpcs	12, 6, cr6, cr5, cr9, {3}
     d0c:	00707063 	rsbseq	r7, r0, r3, rrx
     d10:	6c696146 	stfvse	f6, [r9], #-280	; 0xfffffee8
     d14:	69786500 	ldmdbvs	r8!, {r8, sl, sp, lr}^
     d18:	646f6374 	strbtvs	r6, [pc], #-884	; d20 <shift+0xd20>
     d1c:	63730065 	cmnvs	r3, #101	; 0x65
     d20:	5f646568 	svcpl	0x00646568
     d24:	6c656979 			; <UNDEFINED> instruction: 0x6c656979
     d28:	69740064 	ldmdbvs	r4!, {r2, r5, r6}^
     d2c:	635f6b63 	cmpvs	pc, #101376	; 0x18c00
     d30:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
     d34:	7165725f 	cmnvc	r5, pc, asr r2
     d38:	65726975 	ldrbvs	r6, [r2, #-2421]!	; 0xfffff68b
     d3c:	5a5f0064 	bpl	17c0ed4 <__bss_end+0x17b7ea4>
     d40:	65673432 	strbvs	r3, [r7, #-1074]!	; 0xfffffbce
     d44:	63615f74 	cmnvs	r1, #116, 30	; 0x1d0
     d48:	65766974 	ldrbvs	r6, [r6, #-2420]!	; 0xfffff68c
     d4c:	6f72705f 	svcvs	0x0072705f
     d50:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     d54:	756f635f 	strbvc	r6, [pc, #-863]!	; 9fd <shift+0x9fd>
     d58:	0076746e 	rsbseq	r7, r6, lr, ror #8
     d5c:	65706950 	ldrbvs	r6, [r0, #-2384]!	; 0xfffff6b0
     d60:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     d64:	72505f65 	subsvc	r5, r0, #404	; 0x194
     d68:	78696665 	stmdavc	r9!, {r0, r2, r5, r6, r9, sl, sp, lr}^
     d6c:	315a5f00 	cmpcc	sl, r0, lsl #30
     d70:	74656734 	strbtvc	r6, [r5], #-1844	; 0xfffff8cc
     d74:	6369745f 	cmnvs	r9, #1593835520	; 0x5f000000
     d78:	6f635f6b 	svcvs	0x00635f6b
     d7c:	76746e75 			; <UNDEFINED> instruction: 0x76746e75
     d80:	656c7300 	strbvs	r7, [ip, #-768]!	; 0xfffffd00
     d84:	5f007065 	svcpl	0x00007065
     d88:	6574395a 	ldrbvs	r3, [r4, #-2394]!	; 0xfffff6a6
     d8c:	6e696d72 	mcrvs	13, 3, r6, cr9, cr2, {3}
     d90:	69657461 	stmdbvs	r5!, {r0, r5, r6, sl, ip, sp, lr}^
     d94:	65706f00 	ldrbvs	r6, [r0, #-3840]!	; 0xfffff100
     d98:	69746172 	ldmdbvs	r4!, {r1, r4, r5, r6, r8, sp, lr}^
     d9c:	5f006e6f 	svcpl	0x00006e6f
     da0:	6c63355a 	cfstr64vs	mvdx3, [r3], #-360	; 0xfffffe98
     da4:	6a65736f 	bvs	195db68 <__bss_end+0x1954b38>
     da8:	365a5f00 	ldrbcc	r5, [sl], -r0, lsl #30
     dac:	70746567 	rsbsvc	r6, r4, r7, ror #10
     db0:	00766469 	rsbseq	r6, r6, r9, ror #8
     db4:	6d616e66 	stclvs	14, cr6, [r1, #-408]!	; 0xfffffe68
     db8:	4e470065 	cdpmi	0, 4, cr0, cr7, cr5, {3}
     dbc:	2b432055 	blcs	10c8f18 <__bss_end+0x10bfee8>
     dc0:	2034312b 	eorscs	r3, r4, fp, lsr #2
     dc4:	332e3031 			; <UNDEFINED> instruction: 0x332e3031
     dc8:	3220312e 	eorcc	r3, r0, #-2147483637	; 0x8000000b
     dcc:	30313230 	eorscc	r3, r1, r0, lsr r2
     dd0:	20313236 	eorscs	r3, r1, r6, lsr r2
     dd4:	6c657228 	sfmvs	f7, 2, [r5], #-160	; 0xffffff60
     dd8:	65736165 	ldrbvs	r6, [r3, #-357]!	; 0xfffffe9b
     ddc:	6d2d2029 	stcvs	0, cr2, [sp, #-164]!	; 0xffffff5c
     de0:	616f6c66 	cmnvs	pc, r6, ror #24
     de4:	62612d74 	rsbvs	r2, r1, #116, 26	; 0x1d00
     de8:	61683d69 	cmnvs	r8, r9, ror #26
     dec:	2d206472 	cfstrscs	mvf6, [r0, #-456]!	; 0xfffffe38
     df0:	7570666d 	ldrbvc	r6, [r0, #-1645]!	; 0xfffff993
     df4:	7066763d 	rsbvc	r7, r6, sp, lsr r6
     df8:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
     dfc:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
     e00:	6962612d 	stmdbvs	r2!, {r0, r2, r3, r5, r8, sp, lr}^
     e04:	7261683d 	rsbvc	r6, r1, #3997696	; 0x3d0000
     e08:	6d2d2064 	stcvs	0, cr2, [sp, #-400]!	; 0xfffffe70
     e0c:	3d757066 	ldclcc	0, cr7, [r5, #-408]!	; 0xfffffe68
     e10:	20706676 	rsbscs	r6, r0, r6, ror r6
     e14:	75746d2d 	ldrbvc	r6, [r4, #-3373]!	; 0xfffff2d3
     e18:	613d656e 	teqvs	sp, lr, ror #10
     e1c:	31316d72 	teqcc	r1, r2, ror sp
     e20:	7a6a3637 	bvc	1a8e704 <__bss_end+0x1a856d4>
     e24:	20732d66 	rsbscs	r2, r3, r6, ror #26
     e28:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
     e2c:	6d2d206d 	stcvs	0, cr2, [sp, #-436]!	; 0xfffffe4c
     e30:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
     e34:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
     e38:	6b7a3676 	blvs	1e8e818 <__bss_end+0x1e857e8>
     e3c:	2070662b 	rsbscs	r6, r0, fp, lsr #12
     e40:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
     e44:	672d2067 	strvs	r2, [sp, -r7, rrx]!
     e48:	304f2d20 	subcc	r2, pc, r0, lsr #26
     e4c:	304f2d20 	subcc	r2, pc, r0, lsr #26
     e50:	6e662d20 	cdpvs	13, 6, cr2, cr6, cr0, {1}
     e54:	78652d6f 	stmdavc	r5!, {r0, r1, r2, r3, r5, r6, r8, sl, fp, sp}^
     e58:	74706563 	ldrbtvc	r6, [r0], #-1379	; 0xfffffa9d
     e5c:	736e6f69 	cmnvc	lr, #420	; 0x1a4
     e60:	6e662d20 	cdpvs	13, 6, cr2, cr6, cr0, {1}
     e64:	74722d6f 	ldrbtvc	r2, [r2], #-3439	; 0xfffff291
     e68:	77006974 	smlsdxvc	r0, r4, r9, r6
     e6c:	65746972 	ldrbvs	r6, [r4, #-2418]!	; 0xfffff68e
     e70:	63697400 	cmnvs	r9, #0, 8
     e74:	6f00736b 	svcvs	0x0000736b
     e78:	006e6570 	rsbeq	r6, lr, r0, ror r5
     e7c:	70345a5f 	eorsvc	r5, r4, pc, asr sl
     e80:	50657069 	rsbpl	r7, r5, r9, rrx
     e84:	006a634b 	rsbeq	r6, sl, fp, asr #6
     e88:	6165444e 	cmnvs	r5, lr, asr #8
     e8c:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
     e90:	75535f65 	ldrbvc	r5, [r3, #-3941]	; 0xfffff09b
     e94:	72657362 	rsbvc	r7, r5, #-2013265919	; 0x88000001
     e98:	65636976 	strbvs	r6, [r3, #-2422]!	; 0xfffff68a
     e9c:	74656700 	strbtvc	r6, [r5], #-1792	; 0xfffff900
     ea0:	6369745f 	cmnvs	r9, #1593835520	; 0x5f000000
     ea4:	6f635f6b 	svcvs	0x00635f6b
     ea8:	00746e75 	rsbseq	r6, r4, r5, ror lr
     eac:	61726170 	cmnvs	r2, r0, ror r1
     eb0:	5a5f006d 	bpl	17c106c <__bss_end+0x17b803c>
     eb4:	69727735 	ldmdbvs	r2!, {r0, r2, r4, r5, r8, r9, sl, ip, sp, lr}^
     eb8:	506a6574 	rsbpl	r6, sl, r4, ror r5
     ebc:	006a634b 	rsbeq	r6, sl, fp, asr #6
     ec0:	5f746567 	svcpl	0x00746567
     ec4:	6b736174 	blvs	1cd949c <__bss_end+0x1cd046c>
     ec8:	6369745f 	cmnvs	r9, #1593835520	; 0x5f000000
     ecc:	745f736b 	ldrbvc	r7, [pc], #-875	; ed4 <shift+0xed4>
     ed0:	65645f6f 	strbvs	r5, [r4, #-3951]!	; 0xfffff091
     ed4:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
     ed8:	6200656e 	andvs	r6, r0, #461373440	; 0x1b800000
     edc:	735f6675 	cmpvc	pc, #122683392	; 0x7500000
     ee0:	00657a69 	rsbeq	r7, r5, r9, ror #20
     ee4:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
     ee8:	552f632f 	strpl	r6, [pc, #-815]!	; bc1 <shift+0xbc1>
     eec:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
     ef0:	62754b2f 	rsbsvs	r4, r5, #48128	; 0xbc00
     ef4:	6f442f61 	svcvs	0x00442f61
     ef8:	656d7563 	strbvs	r7, [sp, #-1379]!	; 0xfffffa9d
     efc:	2f73746e 	svccs	0x0073746e
     f00:	6f72655a 	svcvs	0x0072655a
     f04:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
     f08:	6178652f 	cmnvs	r8, pc, lsr #10
     f0c:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
     f10:	38312f73 	ldmdacc	r1!, {r0, r1, r4, r5, r6, r8, r9, sl, fp, sp}
     f14:	6664652d 	strbtvs	r6, [r4], -sp, lsr #10
     f18:	6975622f 	ldmdbvs	r5!, {r0, r1, r2, r3, r5, r9, sp, lr}^
     f1c:	7300646c 	movwvc	r6, #1132	; 0x46c
     f20:	745f7465 	ldrbvc	r7, [pc], #-1125	; f28 <shift+0xf28>
     f24:	5f6b7361 	svcpl	0x006b7361
     f28:	64616564 	strbtvs	r6, [r1], #-1380	; 0xfffffa9c
     f2c:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
     f30:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
     f34:	65656c73 	strbvs	r6, [r5, #-3187]!	; 0xfffff38d
     f38:	006a6a70 	rsbeq	r6, sl, r0, ror sl
     f3c:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
     f40:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     f44:	6d65525f 	sfmvs	f5, 2, [r5, #-380]!	; 0xfffffe84
     f48:	696e6961 	stmdbvs	lr!, {r0, r5, r6, r8, fp, sp, lr}^
     f4c:	5f00676e 	svcpl	0x0000676e
     f50:	6736325a 			; <UNDEFINED> instruction: 0x6736325a
     f54:	745f7465 	ldrbvc	r7, [pc], #-1125	; f5c <shift+0xf5c>
     f58:	5f6b7361 	svcpl	0x006b7361
     f5c:	6b636974 	blvs	18db534 <__bss_end+0x18d2504>
     f60:	6f745f73 	svcvs	0x00745f73
     f64:	6165645f 	cmnvs	r5, pc, asr r4
     f68:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
     f6c:	4e007665 	cfmadd32mi	mvax3, mvfx7, mvfx0, mvfx5
     f70:	5f495753 	svcpl	0x00495753
     f74:	75736552 	ldrbvc	r6, [r3, #-1362]!	; 0xfffffaae
     f78:	435f746c 	cmpmi	pc, #108, 8	; 0x6c000000
     f7c:	0065646f 	rsbeq	r6, r5, pc, ror #8
     f80:	756e7277 	strbvc	r7, [lr, #-631]!	; 0xfffffd89
     f84:	5a5f006d 	bpl	17c1140 <__bss_end+0x17b8110>
     f88:	69617734 	stmdbvs	r1!, {r2, r4, r5, r8, r9, sl, ip, sp, lr}^
     f8c:	6a6a6a74 	bvs	1a9b964 <__bss_end+0x1a92934>
     f90:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
     f94:	74636f69 	strbtvc	r6, [r3], #-3945	; 0xfffff097
     f98:	36316a6c 	ldrtcc	r6, [r1], -ip, ror #20
     f9c:	434f494e 	movtmi	r4, #63822	; 0xf94e
     fa0:	4f5f6c74 	svcmi	0x005f6c74
     fa4:	61726570 	cmnvs	r2, r0, ror r5
     fa8:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     fac:	69007650 	stmdbvs	r0, {r4, r6, r9, sl, ip, sp, lr}
     fb0:	6c74636f 	ldclvs	3, cr6, [r4], #-444	; 0xfffffe44
     fb4:	74657200 	strbtvc	r7, [r5], #-512	; 0xfffffe00
     fb8:	00746e63 	rsbseq	r6, r4, r3, ror #28
     fbc:	69746f6e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
     fc0:	74007966 	strvc	r7, [r0], #-2406	; 0xfffff69a
     fc4:	696d7265 	stmdbvs	sp!, {r0, r2, r5, r6, r9, ip, sp, lr}^
     fc8:	6574616e 	ldrbvs	r6, [r4, #-366]!	; 0xfffffe92
     fcc:	646f6d00 	strbtvs	r6, [pc], #-3328	; fd4 <shift+0xfd4>
     fd0:	75620065 	strbvc	r0, [r2, #-101]!	; 0xffffff9b
     fd4:	72656666 	rsbvc	r6, r5, #106954752	; 0x6600000
     fd8:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
     fdc:	64616572 	strbtvs	r6, [r1], #-1394	; 0xfffffa8e
     fe0:	6a63506a 	bvs	18d5190 <__bss_end+0x18cc160>
     fe4:	74657200 	strbtvc	r7, [r5], #-512	; 0xfffffe00
     fe8:	65646f63 	strbvs	r6, [r4, #-3939]!	; 0xfffff09d
     fec:	74656700 	strbtvc	r6, [r5], #-1792	; 0xfffff900
     ff0:	7463615f 	strbtvc	r6, [r3], #-351	; 0xfffffea1
     ff4:	5f657669 	svcpl	0x00657669
     ff8:	636f7270 	cmnvs	pc, #112, 4
     ffc:	5f737365 	svcpl	0x00737365
    1000:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
    1004:	69660074 	stmdbvs	r6!, {r2, r4, r5, r6}^
    1008:	616e656c 	cmnvs	lr, ip, ror #10
    100c:	7200656d 	andvc	r6, r0, #457179136	; 0x1b400000
    1010:	00646165 	rsbeq	r6, r4, r5, ror #2
    1014:	70746567 	rsbsvc	r6, r4, r7, ror #10
    1018:	5f006469 	svcpl	0x00006469
    101c:	706f345a 	rsbvc	r3, pc, sl, asr r4	; <UNPREDICTABLE>
    1020:	4b506e65 	blmi	141c9bc <__bss_end+0x141398c>
    1024:	4e353163 	rsfmisz	f3, f5, f3
    1028:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
    102c:	65704f5f 	ldrbvs	r4, [r0, #-3935]!	; 0xfffff0a1
    1030:	6f4d5f6e 	svcvs	0x004d5f6e
    1034:	69006564 	stmdbvs	r0, {r2, r5, r6, r8, sl, sp, lr}
    1038:	7475706e 	ldrbtvc	r7, [r5], #-110	; 0xffffff92
    103c:	73656400 	cmnvc	r5, #0, 8
    1040:	7a620074 	bvc	1881218 <__bss_end+0x18781e8>
    1044:	006f7265 	rsbeq	r7, pc, r5, ror #4
    1048:	676e656c 	strbvs	r6, [lr, -ip, ror #10]!
    104c:	5f006874 	svcpl	0x00006874
    1050:	7a62355a 	bvc	188e5c0 <__bss_end+0x1885590>
    1054:	506f7265 	rsbpl	r7, pc, r5, ror #4
    1058:	73006976 	movwvc	r6, #2422	; 0x976
    105c:	636e7274 	cmnvs	lr, #116, 4	; 0x40000007
    1060:	5f007970 	svcpl	0x00007970
    1064:	7461345a 	strbtvc	r3, [r1], #-1114	; 0xfffffba6
    1068:	4b50696f 	blmi	141b62c <__bss_end+0x14125fc>
    106c:	68430063 	stmdavs	r3, {r0, r1, r5, r6}^
    1070:	6f437261 	svcvs	0x00437261
    1074:	7241766e 	subvc	r7, r1, #115343360	; 0x6e00000
    1078:	656d0072 	strbvs	r0, [sp, #-114]!	; 0xffffff8e
    107c:	7473646d 	ldrbtvc	r6, [r3], #-1133	; 0xfffffb93
    1080:	74756f00 	ldrbtvc	r6, [r5], #-3840	; 0xfffff100
    1084:	00747570 	rsbseq	r7, r4, r0, ror r5
    1088:	6d365a5f 	vldmdbvs	r6!, {s10-s104}
    108c:	70636d65 	rsbvc	r6, r3, r5, ror #26
    1090:	764b5079 			; <UNDEFINED> instruction: 0x764b5079
    1094:	00697650 	rsbeq	r7, r9, r0, asr r6
    1098:	636d656d 	cmnvs	sp, #457179136	; 0x1b400000
    109c:	73007970 	movwvc	r7, #2416	; 0x970
    10a0:	656c7274 	strbvs	r7, [ip, #-628]!	; 0xfffffd8c
    10a4:	5a5f006e 	bpl	17c1264 <__bss_end+0x17b8234>
    10a8:	72747337 	rsbsvc	r7, r4, #-603979776	; 0xdc000000
    10ac:	706d636e 	rsbvc	r6, sp, lr, ror #6
    10b0:	53634b50 	cmnpl	r3, #80, 22	; 0x14000
    10b4:	00695f30 	rsbeq	r5, r9, r0, lsr pc
    10b8:	73365a5f 	teqvc	r6, #389120	; 0x5f000
    10bc:	656c7274 	strbvs	r7, [ip, #-628]!	; 0xfffffd8c
    10c0:	634b506e 	movtvs	r5, #45166	; 0xb06e
    10c4:	6f746100 	svcvs	0x00746100
    10c8:	5a5f0069 	bpl	17c1274 <__bss_end+0x17b8244>
    10cc:	72747337 	rsbsvc	r7, r4, #-603979776	; 0xdc000000
    10d0:	7970636e 	ldmdbvc	r0!, {r1, r2, r3, r5, r6, r8, r9, sp, lr}^
    10d4:	4b506350 	blmi	1419e1c <__bss_end+0x1410dec>
    10d8:	73006963 	movwvc	r6, #2403	; 0x963
    10dc:	636e7274 	cmnvs	lr, #116, 4	; 0x40000007
    10e0:	6d00706d 	stcvs	0, cr7, [r0, #-436]	; 0xfffffe4c
    10e4:	726f6d65 	rsbvc	r6, pc, #6464	; 0x1940
    10e8:	656d0079 	strbvs	r0, [sp, #-121]!	; 0xffffff87
    10ec:	6372736d 	cmnvs	r2, #-1275068415	; 0xb4000001
    10f0:	6f746900 	svcvs	0x00746900
    10f4:	6d2f0061 	stcvs	0, cr0, [pc, #-388]!	; f78 <shift+0xf78>
    10f8:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
    10fc:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
    1100:	4b2f7372 	blmi	bdded0 <__bss_end+0xbd4ea0>
    1104:	2f616275 	svccs	0x00616275
    1108:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
    110c:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
    1110:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
    1114:	614d6f72 	hvcvs	55026	; 0xd6f2
    1118:	652f6574 	strvs	r6, [pc, #-1396]!	; bac <shift+0xbac>
    111c:	706d6178 	rsbvc	r6, sp, r8, ror r1
    1120:	2f73656c 	svccs	0x0073656c
    1124:	652d3831 	strvs	r3, [sp, #-2097]!	; 0xfffff7cf
    1128:	732f6664 			; <UNDEFINED> instruction: 0x732f6664
    112c:	696c6474 	stmdbvs	ip!, {r2, r4, r5, r6, sl, sp, lr}^
    1130:	72732f62 	rsbsvc	r2, r3, #392	; 0x188
    1134:	74732f63 	ldrbtvc	r2, [r3], #-3939	; 0xfffff09d
    1138:	72747364 	rsbsvc	r7, r4, #100, 6	; 0x90000001
    113c:	2e676e69 	cdpcs	14, 6, cr6, cr7, cr9, {3}
    1140:	00707063 	rsbseq	r7, r0, r3, rrx
    1144:	69345a5f 	ldmdbvs	r4!, {r0, r1, r2, r3, r4, r6, r9, fp, ip, lr}
    1148:	6a616f74 	bvs	185cf20 <__bss_end+0x1853ef0>
    114c:	006a6350 	rsbeq	r6, sl, r0, asr r3
    1150:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1154:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1158:	2f2e2e2f 	svccs	0x002e2e2f
    115c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1160:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
    1164:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    1168:	6e6f632f 	cdpvs	3, 6, cr6, cr15, cr15, {1}
    116c:	2f676966 	svccs	0x00676966
    1170:	2f6d7261 	svccs	0x006d7261
    1174:	3162696c 	cmncc	r2, ip, ror #18
    1178:	636e7566 	cmnvs	lr, #427819008	; 0x19800000
    117c:	00532e73 	subseq	r2, r3, r3, ror lr
    1180:	6975622f 	ldmdbvs	r5!, {r0, r1, r2, r3, r5, r9, sp, lr}^
    1184:	672f646c 	strvs	r6, [pc, -ip, ror #8]!
    1188:	612d6363 			; <UNDEFINED> instruction: 0x612d6363
    118c:	6e2d6d72 	mcrvs	13, 1, r6, cr13, cr2, {3}
    1190:	2d656e6f 	stclcs	14, cr6, [r5, #-444]!	; 0xfffffe44
    1194:	69626165 	stmdbvs	r2!, {r0, r2, r5, r6, r8, sp, lr}^
    1198:	6659682d 	ldrbvs	r6, [r9], -sp, lsr #16
    119c:	2f344b67 	svccs	0x00344b67
    11a0:	2d636367 	stclcs	3, cr6, [r3, #-412]!	; 0xfffffe64
    11a4:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
    11a8:	656e6f6e 	strbvs	r6, [lr, #-3950]!	; 0xfffff092
    11ac:	6261652d 	rsbvs	r6, r1, #188743680	; 0xb400000
    11b0:	30312d69 	eorscc	r2, r1, r9, ror #26
    11b4:	322d332e 	eorcc	r3, sp, #-1207959552	; 0xb8000000
    11b8:	2e313230 	mrccs	2, 1, r3, cr1, cr0, {1}
    11bc:	622f3730 	eorvs	r3, pc, #48, 14	; 0xc00000
    11c0:	646c6975 	strbtvs	r6, [ip], #-2421	; 0xfffff68b
    11c4:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
    11c8:	6e6f6e2d 	cdpvs	14, 6, cr6, cr15, cr13, {1}
    11cc:	61652d65 	cmnvs	r5, r5, ror #26
    11d0:	612f6962 			; <UNDEFINED> instruction: 0x612f6962
    11d4:	762f6d72 			; <UNDEFINED> instruction: 0x762f6d72
    11d8:	2f657435 	svccs	0x00657435
    11dc:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
    11e0:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    11e4:	00636367 	rsbeq	r6, r3, r7, ror #6
    11e8:	20554e47 	subscs	r4, r5, r7, asr #28
    11ec:	32205341 	eorcc	r5, r0, #67108865	; 0x4000001
    11f0:	0037332e 	eorseq	r3, r7, lr, lsr #6
    11f4:	5f617369 	svcpl	0x00617369
    11f8:	5f746962 	svcpl	0x00746962
    11fc:	64657270 	strbtvs	r7, [r5], #-624	; 0xfffffd90
    1200:	00736572 	rsbseq	r6, r3, r2, ror r5
    1204:	5f617369 	svcpl	0x00617369
    1208:	5f746962 	svcpl	0x00746962
    120c:	5f706676 	svcpl	0x00706676
    1210:	65736162 	ldrbvs	r6, [r3, #-354]!	; 0xfffffe9e
    1214:	6d6f6300 	stclvs	3, cr6, [pc, #-0]	; 121c <shift+0x121c>
    1218:	78656c70 	stmdavc	r5!, {r4, r5, r6, sl, fp, sp, lr}^
    121c:	6f6c6620 	svcvs	0x006c6620
    1220:	69007461 	stmdbvs	r0, {r0, r5, r6, sl, ip, sp, lr}
    1224:	6e5f6173 	mrcvs	1, 2, r6, cr15, cr3, {3}
    1228:	7469626f 	strbtvc	r6, [r9], #-623	; 0xfffffd91
    122c:	61736900 	cmnvs	r3, r0, lsl #18
    1230:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1234:	65766d5f 	ldrbvs	r6, [r6, #-3423]!	; 0xfffff2a1
    1238:	6f6c665f 	svcvs	0x006c665f
    123c:	69007461 	stmdbvs	r0, {r0, r5, r6, sl, ip, sp, lr}
    1240:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1244:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    1248:	00363170 	eorseq	r3, r6, r0, ror r1
    124c:	5f617369 	svcpl	0x00617369
    1250:	5f746962 	svcpl	0x00746962
    1254:	00636573 	rsbeq	r6, r3, r3, ror r5
    1258:	5f617369 	svcpl	0x00617369
    125c:	5f746962 	svcpl	0x00746962
    1260:	76696461 	strbtvc	r6, [r9], -r1, ror #8
    1264:	61736900 	cmnvs	r3, r0, lsl #18
    1268:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    126c:	6975715f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, r8, ip, sp, lr}^
    1270:	6e5f6b72 	vmovvs.s8	r6, d15[3]
    1274:	6f765f6f 	svcvs	0x00765f6f
    1278:	6974616c 	ldmdbvs	r4!, {r2, r3, r5, r6, r8, sp, lr}^
    127c:	635f656c 	cmpvs	pc, #108, 10	; 0x1b000000
    1280:	73690065 	cmnvc	r9, #101	; 0x65
    1284:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1288:	706d5f74 	rsbvc	r5, sp, r4, ror pc
    128c:	61736900 	cmnvs	r3, r0, lsl #18
    1290:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1294:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1298:	00743576 	rsbseq	r3, r4, r6, ror r5
    129c:	5f617369 	svcpl	0x00617369
    12a0:	5f746962 	svcpl	0x00746962
    12a4:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    12a8:	00657435 	rsbeq	r7, r5, r5, lsr r4
    12ac:	5f617369 	svcpl	0x00617369
    12b0:	5f746962 	svcpl	0x00746962
    12b4:	6e6f656e 	cdpvs	5, 6, cr6, cr15, cr14, {3}
    12b8:	61736900 	cmnvs	r3, r0, lsl #18
    12bc:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    12c0:	3166625f 	cmncc	r6, pc, asr r2
    12c4:	50460036 	subpl	r0, r6, r6, lsr r0
    12c8:	5f524353 	svcpl	0x00524353
    12cc:	4d554e45 	ldclmi	14, cr4, [r5, #-276]	; 0xfffffeec
    12d0:	53504600 	cmppl	r0, #0, 12
    12d4:	6e5f5243 	cdpvs	2, 5, cr5, cr15, cr3, {2}
    12d8:	7176637a 	cmnvc	r6, sl, ror r3
    12dc:	4e455f63 	cdpmi	15, 4, cr5, cr5, cr3, {3}
    12e0:	56004d55 			; <UNDEFINED> instruction: 0x56004d55
    12e4:	455f5250 	ldrbmi	r5, [pc, #-592]	; 109c <shift+0x109c>
    12e8:	004d554e 	subeq	r5, sp, lr, asr #10
    12ec:	74696266 	strbtvc	r6, [r9], #-614	; 0xfffffd9a
    12f0:	706d695f 	rsbvc	r6, sp, pc, asr r9
    12f4:	6163696c 	cmnvs	r3, ip, ror #18
    12f8:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
    12fc:	5f305000 	svcpl	0x00305000
    1300:	4d554e45 	ldclmi	14, cr4, [r5, #-276]	; 0xfffffeec
    1304:	61736900 	cmnvs	r3, r0, lsl #18
    1308:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    130c:	7972635f 	ldmdbvc	r2!, {r0, r1, r2, r3, r4, r6, r8, r9, sp, lr}^
    1310:	006f7470 	rsbeq	r7, pc, r0, ror r4	; <UNPREDICTABLE>
    1314:	20554e47 	subscs	r4, r5, r7, asr #28
    1318:	20373143 	eorscs	r3, r7, r3, asr #2
    131c:	332e3031 			; <UNDEFINED> instruction: 0x332e3031
    1320:	3220312e 	eorcc	r3, r0, #-2147483637	; 0x8000000b
    1324:	30313230 	eorscc	r3, r1, r0, lsr r2
    1328:	20313236 	eorscs	r3, r1, r6, lsr r2
    132c:	6c657228 	sfmvs	f7, 2, [r5], #-160	; 0xffffff60
    1330:	65736165 	ldrbvs	r6, [r3, #-357]!	; 0xfffffe9b
    1334:	6d2d2029 	stcvs	0, cr2, [sp, #-164]!	; 0xffffff5c
    1338:	206d7261 	rsbcs	r7, sp, r1, ror #4
    133c:	6c666d2d 	stclvs	13, cr6, [r6], #-180	; 0xffffff4c
    1340:	2d74616f 	ldfcse	f6, [r4, #-444]!	; 0xfffffe44
    1344:	3d696261 	sfmcc	f6, 2, [r9, #-388]!	; 0xfffffe7c
    1348:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
    134c:	616d2d20 	cmnvs	sp, r0, lsr #26
    1350:	3d686372 	stclcc	3, cr6, [r8, #-456]!	; 0xfffffe38
    1354:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1358:	2b657435 	blcs	195e434 <__bss_end+0x1955404>
    135c:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
    1360:	672d2067 	strvs	r2, [sp, -r7, rrx]!
    1364:	20672d20 	rsbcs	r2, r7, r0, lsr #26
    1368:	20324f2d 	eorscs	r4, r2, sp, lsr #30
    136c:	20324f2d 	eorscs	r4, r2, sp, lsr #30
    1370:	20324f2d 	eorscs	r4, r2, sp, lsr #30
    1374:	7562662d 	strbvc	r6, [r2, #-1581]!	; 0xfffff9d3
    1378:	69646c69 	stmdbvs	r4!, {r0, r3, r5, r6, sl, fp, sp, lr}^
    137c:	6c2d676e 	stcvs	7, cr6, [sp], #-440	; 0xfffffe48
    1380:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1384:	662d2063 	strtvs	r2, [sp], -r3, rrx
    1388:	732d6f6e 			; <UNDEFINED> instruction: 0x732d6f6e
    138c:	6b636174 	blvs	18d9964 <__bss_end+0x18d0934>
    1390:	6f72702d 	svcvs	0x0072702d
    1394:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
    1398:	2d20726f 	sfmcs	f7, 4, [r0, #-444]!	; 0xfffffe44
    139c:	2d6f6e66 	stclcs	14, cr6, [pc, #-408]!	; 120c <shift+0x120c>
    13a0:	696c6e69 	stmdbvs	ip!, {r0, r3, r5, r6, r9, sl, fp, sp, lr}^
    13a4:	2d20656e 	cfstr32cs	mvfx6, [r0, #-440]!	; 0xfffffe48
    13a8:	73697666 	cmnvc	r9, #106954752	; 0x6600000
    13ac:	6c696269 	sfmvs	f6, 2, [r9], #-420	; 0xfffffe5c
    13b0:	3d797469 	cfldrdcc	mvd7, [r9, #-420]!	; 0xfffffe5c
    13b4:	64646968 	strbtvs	r6, [r4], #-2408	; 0xfffff698
    13b8:	69006e65 	stmdbvs	r0, {r0, r2, r5, r6, r9, sl, fp, sp, lr}
    13bc:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    13c0:	745f7469 	ldrbvc	r7, [pc], #-1129	; 13c8 <shift+0x13c8>
    13c4:	00766964 	rsbseq	r6, r6, r4, ror #18
    13c8:	736e6f63 	cmnvc	lr, #396	; 0x18c
    13cc:	61736900 	cmnvs	r3, r0, lsl #18
    13d0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    13d4:	6d77695f 			; <UNDEFINED> instruction: 0x6d77695f
    13d8:	0074786d 	rsbseq	r7, r4, sp, ror #16
    13dc:	58435046 	stmdapl	r3, {r1, r2, r6, ip, lr}^
    13e0:	455f5354 	ldrbmi	r5, [pc, #-852]	; 1094 <shift+0x1094>
    13e4:	004d554e 	subeq	r5, sp, lr, asr #10
    13e8:	5f617369 	svcpl	0x00617369
    13ec:	5f746962 	svcpl	0x00746962
    13f0:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    13f4:	73690036 	cmnvc	r9, #54	; 0x36
    13f8:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    13fc:	766d5f74 	uqsub16vc	r5, sp, r4
    1400:	73690065 	cmnvc	r9, #101	; 0x65
    1404:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1408:	77695f74 			; <UNDEFINED> instruction: 0x77695f74
    140c:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
    1410:	73690032 	cmnvc	r9, #50	; 0x32
    1414:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1418:	64635f74 	strbtvs	r5, [r3], #-3956	; 0xfffff08c
    141c:	30706365 	rsbscc	r6, r0, r5, ror #6
    1420:	61736900 	cmnvs	r3, r0, lsl #18
    1424:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1428:	6564635f 	strbvs	r6, [r4, #-863]!	; 0xfffffca1
    142c:	00317063 	eorseq	r7, r1, r3, rrx
    1430:	5f617369 	svcpl	0x00617369
    1434:	5f746962 	svcpl	0x00746962
    1438:	63656463 	cmnvs	r5, #1660944384	; 0x63000000
    143c:	69003270 	stmdbvs	r0, {r4, r5, r6, r9, ip, sp}
    1440:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1444:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    1448:	70636564 	rsbvc	r6, r3, r4, ror #10
    144c:	73690033 	cmnvc	r9, #51	; 0x33
    1450:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1454:	64635f74 	strbtvs	r5, [r3], #-3956	; 0xfffff08c
    1458:	34706365 	ldrbtcc	r6, [r0], #-869	; 0xfffffc9b
    145c:	61736900 	cmnvs	r3, r0, lsl #18
    1460:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1464:	5f70665f 	svcpl	0x0070665f
    1468:	006c6264 	rsbeq	r6, ip, r4, ror #4
    146c:	5f617369 	svcpl	0x00617369
    1470:	5f746962 	svcpl	0x00746962
    1474:	63656463 	cmnvs	r5, #1660944384	; 0x63000000
    1478:	69003670 	stmdbvs	r0, {r4, r5, r6, r9, sl, ip, sp}
    147c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1480:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    1484:	70636564 	rsbvc	r6, r3, r4, ror #10
    1488:	73690037 	cmnvc	r9, #55	; 0x37
    148c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1490:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1494:	6b36766d 	blvs	d9ee50 <__bss_end+0xd95e20>
    1498:	61736900 	cmnvs	r3, r0, lsl #18
    149c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    14a0:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    14a4:	315f3876 	cmpcc	pc, r6, ror r8	; <UNPREDICTABLE>
    14a8:	616d5f6d 	cmnvs	sp, sp, ror #30
    14ac:	61006e69 	tstvs	r0, r9, ror #28
    14b0:	0065746e 	rsbeq	r7, r5, lr, ror #8
    14b4:	5f617369 	svcpl	0x00617369
    14b8:	5f746962 	svcpl	0x00746962
    14bc:	65736d63 	ldrbvs	r6, [r3, #-3427]!	; 0xfffff29d
    14c0:	6e6f6c00 	cdpvs	12, 6, cr6, cr15, cr0, {0}
    14c4:	6f642067 	svcvs	0x00642067
    14c8:	656c6275 	strbvs	r6, [ip, #-629]!	; 0xfffffd8b
    14cc:	2f2e2e00 	svccs	0x002e2e00
    14d0:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    14d4:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    14d8:	2f2e2e2f 	svccs	0x002e2e2f
    14dc:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 142c <shift+0x142c>
    14e0:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    14e4:	696c2f63 	stmdbvs	ip!, {r0, r1, r5, r6, r8, r9, sl, fp, sp}^
    14e8:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    14ec:	00632e32 	rsbeq	r2, r3, r2, lsr lr
    14f0:	5f617369 	svcpl	0x00617369
    14f4:	5f746962 	svcpl	0x00746962
    14f8:	35767066 	ldrbcc	r7, [r6, #-102]!	; 0xffffff9a
    14fc:	61736900 	cmnvs	r3, r0, lsl #18
    1500:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1504:	6373785f 	cmnvs	r3, #6225920	; 0x5f0000
    1508:	00656c61 	rsbeq	r6, r5, r1, ror #24
    150c:	676e6f6c 	strbvs	r6, [lr, -ip, ror #30]!
    1510:	6e6f6c20 	cdpvs	12, 6, cr6, cr15, cr0, {1}
    1514:	6e752067 	cdpvs	0, 7, cr2, cr5, cr7, {3}
    1518:	6e676973 			; <UNDEFINED> instruction: 0x6e676973
    151c:	69206465 	stmdbvs	r0!, {r0, r2, r5, r6, sl, sp, lr}
    1520:	6900746e 	stmdbvs	r0, {r1, r2, r3, r5, r6, sl, ip, sp, lr}
    1524:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1528:	715f7469 	cmpvc	pc, r9, ror #8
    152c:	6b726975 	blvs	1c9bb08 <__bss_end+0x1c92ad8>
    1530:	336d635f 	cmncc	sp, #2080374785	; 0x7c000001
    1534:	72646c5f 	rsbvc	r6, r4, #24320	; 0x5f00
    1538:	73690064 	cmnvc	r9, #100	; 0x64
    153c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1540:	38695f74 	stmdacc	r9!, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    1544:	69006d6d 	stmdbvs	r0, {r0, r2, r3, r5, r6, r8, sl, fp, sp, lr}
    1548:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    154c:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    1550:	33645f70 	cmncc	r4, #112, 30	; 0x1c0
    1554:	73690032 	cmnvc	r9, #50	; 0x32
    1558:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    155c:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1560:	6537766d 	ldrvs	r7, [r7, #-1645]!	; 0xfffff993
    1564:	7369006d 	cmnvc	r9, #109	; 0x6d
    1568:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    156c:	706c5f74 	rsbvc	r5, ip, r4, ror pc
    1570:	61006561 	tstvs	r0, r1, ror #10
    1574:	695f6c6c 	ldmdbvs	pc, {r2, r3, r5, r6, sl, fp, sp, lr}^	; <UNPREDICTABLE>
    1578:	696c706d 	stmdbvs	ip!, {r0, r2, r3, r5, r6, ip, sp, lr}^
    157c:	665f6465 	ldrbvs	r6, [pc], -r5, ror #8
    1580:	73746962 	cmnvc	r4, #1605632	; 0x188000
    1584:	61736900 	cmnvs	r3, r0, lsl #18
    1588:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    158c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1590:	315f3876 	cmpcc	pc, r6, ror r8	; <UNPREDICTABLE>
    1594:	61736900 	cmnvs	r3, r0, lsl #18
    1598:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    159c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    15a0:	325f3876 	subscc	r3, pc, #7733248	; 0x760000
    15a4:	61736900 	cmnvs	r3, r0, lsl #18
    15a8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    15ac:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    15b0:	335f3876 	cmpcc	pc, #7733248	; 0x760000
    15b4:	61736900 	cmnvs	r3, r0, lsl #18
    15b8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    15bc:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    15c0:	345f3876 	ldrbcc	r3, [pc], #-2166	; 15c8 <shift+0x15c8>
    15c4:	61736900 	cmnvs	r3, r0, lsl #18
    15c8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    15cc:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    15d0:	355f3876 	ldrbcc	r3, [pc, #-2166]	; d62 <shift+0xd62>
    15d4:	61736900 	cmnvs	r3, r0, lsl #18
    15d8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    15dc:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    15e0:	365f3876 			; <UNDEFINED> instruction: 0x365f3876
    15e4:	61736900 	cmnvs	r3, r0, lsl #18
    15e8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    15ec:	0062735f 	rsbeq	r7, r2, pc, asr r3
    15f0:	5f617369 	svcpl	0x00617369
    15f4:	5f6d756e 	svcpl	0x006d756e
    15f8:	73746962 	cmnvc	r4, #1605632	; 0x188000
    15fc:	61736900 	cmnvs	r3, r0, lsl #18
    1600:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1604:	616d735f 	cmnvs	sp, pc, asr r3
    1608:	756d6c6c 	strbvc	r6, [sp, #-3180]!	; 0xfffff394
    160c:	7566006c 	strbvc	r0, [r6, #-108]!	; 0xffffff94
    1610:	705f636e 	subsvc	r6, pc, lr, ror #6
    1614:	63007274 	movwvs	r7, #628	; 0x274
    1618:	6c706d6f 	ldclvs	13, cr6, [r0], #-444	; 0xfffffe44
    161c:	64207865 	strtvs	r7, [r0], #-2149	; 0xfffff79b
    1620:	6c62756f 	cfstr64vs	mvdx7, [r2], #-444	; 0xfffffe44
    1624:	424e0065 	submi	r0, lr, #101	; 0x65
    1628:	5f50465f 	svcpl	0x0050465f
    162c:	52535953 	subspl	r5, r3, #1359872	; 0x14c000
    1630:	00534745 	subseq	r4, r3, r5, asr #14
    1634:	5f617369 	svcpl	0x00617369
    1638:	5f746962 	svcpl	0x00746962
    163c:	63656463 	cmnvs	r5, #1660944384	; 0x63000000
    1640:	69003570 	stmdbvs	r0, {r4, r5, r6, r8, sl, ip, sp}
    1644:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1648:	765f7469 	ldrbvc	r7, [pc], -r9, ror #8
    164c:	32767066 	rsbscc	r7, r6, #102	; 0x66
    1650:	61736900 	cmnvs	r3, r0, lsl #18
    1654:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1658:	7066765f 	rsbvc	r7, r6, pc, asr r6
    165c:	69003376 	stmdbvs	r0, {r1, r2, r4, r5, r6, r8, r9, ip, sp}
    1660:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1664:	765f7469 	ldrbvc	r7, [pc], -r9, ror #8
    1668:	34767066 	ldrbtcc	r7, [r6], #-102	; 0xffffff9a
    166c:	43504600 	cmpmi	r0, #0, 12
    1670:	534e5458 	movtpl	r5, #58456	; 0xe458
    1674:	554e455f 	strbpl	r4, [lr, #-1375]	; 0xfffffaa1
    1678:	7369004d 	cmnvc	r9, #77	; 0x4d
    167c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1680:	68745f74 	ldmdavs	r4!, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    1684:	00626d75 	rsbeq	r6, r2, r5, ror sp
    1688:	5f617369 	svcpl	0x00617369
    168c:	5f746962 	svcpl	0x00746962
    1690:	36317066 	ldrtcc	r7, [r1], -r6, rrx
    1694:	766e6f63 	strbtvc	r6, [lr], -r3, ror #30
    1698:	61736900 	cmnvs	r3, r0, lsl #18
    169c:	6165665f 	cmnvs	r5, pc, asr r6
    16a0:	65727574 	ldrbvs	r7, [r2, #-1396]!	; 0xfffffa8c
    16a4:	61736900 	cmnvs	r3, r0, lsl #18
    16a8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    16ac:	746f6e5f 	strbtvc	r6, [pc], #-3679	; 16b4 <shift+0x16b4>
    16b0:	7369006d 	cmnvc	r9, #109	; 0x6d
    16b4:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    16b8:	75715f74 	ldrbvc	r5, [r1, #-3956]!	; 0xfffff08c
    16bc:	5f6b7269 	svcpl	0x006b7269
    16c0:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    16c4:	007a6b36 	rsbseq	r6, sl, r6, lsr fp
    16c8:	5f617369 	svcpl	0x00617369
    16cc:	5f746962 	svcpl	0x00746962
    16d0:	33637263 	cmncc	r3, #805306374	; 0x30000006
    16d4:	73690032 	cmnvc	r9, #50	; 0x32
    16d8:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    16dc:	75715f74 	ldrbvc	r5, [r1, #-3956]!	; 0xfffff08c
    16e0:	5f6b7269 	svcpl	0x006b7269
    16e4:	615f6f6e 	cmpvs	pc, lr, ror #30
    16e8:	70636d73 	rsbvc	r6, r3, r3, ror sp
    16ec:	73690075 	cmnvc	r9, #117	; 0x75
    16f0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    16f4:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    16f8:	0034766d 	eorseq	r7, r4, sp, ror #12
    16fc:	5f617369 	svcpl	0x00617369
    1700:	5f746962 	svcpl	0x00746962
    1704:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    1708:	69003262 	stmdbvs	r0, {r1, r5, r6, r9, ip, sp}
    170c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1710:	625f7469 	subsvs	r7, pc, #1761607680	; 0x69000000
    1714:	69003865 	stmdbvs	r0, {r0, r2, r5, r6, fp, ip, sp}
    1718:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    171c:	615f7469 	cmpvs	pc, r9, ror #8
    1720:	37766d72 			; <UNDEFINED> instruction: 0x37766d72
    1724:	61736900 	cmnvs	r3, r0, lsl #18
    1728:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    172c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1730:	76003876 			; <UNDEFINED> instruction: 0x76003876
    1734:	735f7066 	cmpvc	pc, #102	; 0x66
    1738:	65727379 	ldrbvs	r7, [r2, #-889]!	; 0xfffffc87
    173c:	655f7367 	ldrbvs	r7, [pc, #-871]	; 13dd <shift+0x13dd>
    1740:	646f636e 	strbtvs	r6, [pc], #-878	; 1748 <shift+0x1748>
    1744:	00676e69 	rsbeq	r6, r7, r9, ror #28
    1748:	5f617369 	svcpl	0x00617369
    174c:	5f746962 	svcpl	0x00746962
    1750:	36317066 	ldrtcc	r7, [r1], -r6, rrx
    1754:	006c6d66 	rsbeq	r6, ip, r6, ror #26
    1758:	5f617369 	svcpl	0x00617369
    175c:	5f746962 	svcpl	0x00746962
    1760:	70746f64 	rsbsvc	r6, r4, r4, ror #30
    1764:	00646f72 	rsbeq	r6, r4, r2, ror pc

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
  20:	8b040e42 	blhi	103930 <__bss_end+0xfa900>
  24:	0b0d4201 	bleq	350830 <__bss_end+0x347800>
  28:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
  2c:	00000ecb 	andeq	r0, r0, fp, asr #29
  30:	0000001c 	andeq	r0, r0, ip, lsl r0
  34:	00000000 	andeq	r0, r0, r0
  38:	00008064 	andeq	r8, r0, r4, rrx
  3c:	00000040 	andeq	r0, r0, r0, asr #32
  40:	8b080e42 	blhi	203950 <__bss_end+0x1fa920>
  44:	42018e02 	andmi	r8, r1, #2, 28
  48:	5a040b0c 	bpl	102c80 <__bss_end+0xf9c50>
  4c:	00080d0c 	andeq	r0, r8, ip, lsl #26
  50:	0000000c 	andeq	r0, r0, ip
  54:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  58:	7c020001 	stcvc	0, cr0, [r2], {1}
  5c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  60:	0000001c 	andeq	r0, r0, ip, lsl r0
  64:	00000050 	andeq	r0, r0, r0, asr r0
  68:	000080a4 	andeq	r8, r0, r4, lsr #1
  6c:	00000038 	andeq	r0, r0, r8, lsr r0
  70:	8b040e42 	blhi	103980 <__bss_end+0xfa950>
  74:	0b0d4201 	bleq	350880 <__bss_end+0x347850>
  78:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
  7c:	00000ecb 	andeq	r0, r0, fp, asr #29
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	00000050 	andeq	r0, r0, r0, asr r0
  88:	000080dc 	ldrdeq	r8, [r0], -ip
  8c:	0000002c 	andeq	r0, r0, ip, lsr #32
  90:	8b040e42 	blhi	1039a0 <__bss_end+0xfa970>
  94:	0b0d4201 	bleq	3508a0 <__bss_end+0x347870>
  98:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
  9c:	00000ecb 	andeq	r0, r0, fp, asr #29
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	00000050 	andeq	r0, r0, r0, asr r0
  a8:	00008108 	andeq	r8, r0, r8, lsl #2
  ac:	00000020 	andeq	r0, r0, r0, lsr #32
  b0:	8b040e42 	blhi	1039c0 <__bss_end+0xfa990>
  b4:	0b0d4201 	bleq	3508c0 <__bss_end+0x347890>
  b8:	420d0d48 	andmi	r0, sp, #72, 26	; 0x1200
  bc:	00000ecb 	andeq	r0, r0, fp, asr #29
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	00000050 	andeq	r0, r0, r0, asr r0
  c8:	00008128 	andeq	r8, r0, r8, lsr #2
  cc:	00000018 	andeq	r0, r0, r8, lsl r0
  d0:	8b040e42 	blhi	1039e0 <__bss_end+0xfa9b0>
  d4:	0b0d4201 	bleq	3508e0 <__bss_end+0x3478b0>
  d8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  dc:	00000ecb 	andeq	r0, r0, fp, asr #29
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	00000050 	andeq	r0, r0, r0, asr r0
  e8:	00008140 	andeq	r8, r0, r0, asr #2
  ec:	00000018 	andeq	r0, r0, r8, lsl r0
  f0:	8b040e42 	blhi	103a00 <__bss_end+0xfa9d0>
  f4:	0b0d4201 	bleq	350900 <__bss_end+0x3478d0>
  f8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  fc:	00000ecb 	andeq	r0, r0, fp, asr #29
 100:	0000001c 	andeq	r0, r0, ip, lsl r0
 104:	00000050 	andeq	r0, r0, r0, asr r0
 108:	00008158 	andeq	r8, r0, r8, asr r1
 10c:	00000018 	andeq	r0, r0, r8, lsl r0
 110:	8b040e42 	blhi	103a20 <__bss_end+0xfa9f0>
 114:	0b0d4201 	bleq	350920 <__bss_end+0x3478f0>
 118:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
 11c:	00000ecb 	andeq	r0, r0, fp, asr #29
 120:	00000014 	andeq	r0, r0, r4, lsl r0
 124:	00000050 	andeq	r0, r0, r0, asr r0
 128:	00008170 	andeq	r8, r0, r0, ror r1
 12c:	0000000c 	andeq	r0, r0, ip
 130:	8b040e42 	blhi	103a40 <__bss_end+0xfaa10>
 134:	0b0d4201 	bleq	350940 <__bss_end+0x347910>
 138:	0000001c 	andeq	r0, r0, ip, lsl r0
 13c:	00000050 	andeq	r0, r0, r0, asr r0
 140:	0000817c 	andeq	r8, r0, ip, ror r1
 144:	00000058 	andeq	r0, r0, r8, asr r0
 148:	8b080e42 	blhi	203a58 <__bss_end+0x1faa28>
 14c:	42018e02 	andmi	r8, r1, #2, 28
 150:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 154:	00080d0c 	andeq	r0, r8, ip, lsl #26
 158:	0000001c 	andeq	r0, r0, ip, lsl r0
 15c:	00000050 	andeq	r0, r0, r0, asr r0
 160:	000081d4 	ldrdeq	r8, [r0], -r4
 164:	00000058 	andeq	r0, r0, r8, asr r0
 168:	8b080e42 	blhi	203a78 <__bss_end+0x1faa48>
 16c:	42018e02 	andmi	r8, r1, #2, 28
 170:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 174:	00080d0c 	andeq	r0, r8, ip, lsl #26
 178:	0000000c 	andeq	r0, r0, ip
 17c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 180:	7c020001 	stcvc	0, cr0, [r2], {1}
 184:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 188:	0000001c 	andeq	r0, r0, ip, lsl r0
 18c:	00000178 	andeq	r0, r0, r8, ror r1
 190:	0000822c 	andeq	r8, r0, ip, lsr #4
 194:	00000080 	andeq	r0, r0, r0, lsl #1
 198:	8b080e42 	blhi	203aa8 <__bss_end+0x1faa78>
 19c:	42018e02 	andmi	r8, r1, #2, 28
 1a0:	74040b0c 	strvc	r0, [r4], #-2828	; 0xfffff4f4
 1a4:	00080d0c 	andeq	r0, r8, ip, lsl #26
 1a8:	00000018 	andeq	r0, r0, r8, lsl r0
 1ac:	00000178 	andeq	r0, r0, r8, ror r1
 1b0:	000082ac 	andeq	r8, r0, ip, lsr #5
 1b4:	0000016c 	andeq	r0, r0, ip, ror #2
 1b8:	8b080e42 	blhi	203ac8 <__bss_end+0x1faa98>
 1bc:	42018e02 	andmi	r8, r1, #2, 28
 1c0:	00040b0c 	andeq	r0, r4, ip, lsl #22
 1c4:	0000000c 	andeq	r0, r0, ip
 1c8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 1cc:	7c020001 	stcvc	0, cr0, [r2], {1}
 1d0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 1d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1d8:	000001c4 	andeq	r0, r0, r4, asr #3
 1dc:	00008418 	andeq	r8, r0, r8, lsl r4
 1e0:	0000002c 	andeq	r0, r0, ip, lsr #32
 1e4:	8b040e42 	blhi	103af4 <__bss_end+0xfaac4>
 1e8:	0b0d4201 	bleq	3509f4 <__bss_end+0x3479c4>
 1ec:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 1f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 1f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1f8:	000001c4 	andeq	r0, r0, r4, asr #3
 1fc:	00008444 	andeq	r8, r0, r4, asr #8
 200:	0000002c 	andeq	r0, r0, ip, lsr #32
 204:	8b040e42 	blhi	103b14 <__bss_end+0xfaae4>
 208:	0b0d4201 	bleq	350a14 <__bss_end+0x3479e4>
 20c:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 210:	00000ecb 	andeq	r0, r0, fp, asr #29
 214:	0000001c 	andeq	r0, r0, ip, lsl r0
 218:	000001c4 	andeq	r0, r0, r4, asr #3
 21c:	00008470 	andeq	r8, r0, r0, ror r4
 220:	0000001c 	andeq	r0, r0, ip, lsl r0
 224:	8b040e42 	blhi	103b34 <__bss_end+0xfab04>
 228:	0b0d4201 	bleq	350a34 <__bss_end+0x347a04>
 22c:	420d0d46 	andmi	r0, sp, #4480	; 0x1180
 230:	00000ecb 	andeq	r0, r0, fp, asr #29
 234:	0000001c 	andeq	r0, r0, ip, lsl r0
 238:	000001c4 	andeq	r0, r0, r4, asr #3
 23c:	0000848c 	andeq	r8, r0, ip, lsl #9
 240:	00000044 	andeq	r0, r0, r4, asr #32
 244:	8b040e42 	blhi	103b54 <__bss_end+0xfab24>
 248:	0b0d4201 	bleq	350a54 <__bss_end+0x347a24>
 24c:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 250:	00000ecb 	andeq	r0, r0, fp, asr #29
 254:	0000001c 	andeq	r0, r0, ip, lsl r0
 258:	000001c4 	andeq	r0, r0, r4, asr #3
 25c:	000084d0 	ldrdeq	r8, [r0], -r0
 260:	00000050 	andeq	r0, r0, r0, asr r0
 264:	8b040e42 	blhi	103b74 <__bss_end+0xfab44>
 268:	0b0d4201 	bleq	350a74 <__bss_end+0x347a44>
 26c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 270:	00000ecb 	andeq	r0, r0, fp, asr #29
 274:	0000001c 	andeq	r0, r0, ip, lsl r0
 278:	000001c4 	andeq	r0, r0, r4, asr #3
 27c:	00008520 	andeq	r8, r0, r0, lsr #10
 280:	00000050 	andeq	r0, r0, r0, asr r0
 284:	8b040e42 	blhi	103b94 <__bss_end+0xfab64>
 288:	0b0d4201 	bleq	350a94 <__bss_end+0x347a64>
 28c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 290:	00000ecb 	andeq	r0, r0, fp, asr #29
 294:	0000001c 	andeq	r0, r0, ip, lsl r0
 298:	000001c4 	andeq	r0, r0, r4, asr #3
 29c:	00008570 	andeq	r8, r0, r0, ror r5
 2a0:	0000002c 	andeq	r0, r0, ip, lsr #32
 2a4:	8b040e42 	blhi	103bb4 <__bss_end+0xfab84>
 2a8:	0b0d4201 	bleq	350ab4 <__bss_end+0x347a84>
 2ac:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 2b0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2b8:	000001c4 	andeq	r0, r0, r4, asr #3
 2bc:	0000859c 	muleq	r0, ip, r5
 2c0:	00000050 	andeq	r0, r0, r0, asr r0
 2c4:	8b040e42 	blhi	103bd4 <__bss_end+0xfaba4>
 2c8:	0b0d4201 	bleq	350ad4 <__bss_end+0x347aa4>
 2cc:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 2d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2d8:	000001c4 	andeq	r0, r0, r4, asr #3
 2dc:	000085ec 	andeq	r8, r0, ip, ror #11
 2e0:	00000044 	andeq	r0, r0, r4, asr #32
 2e4:	8b040e42 	blhi	103bf4 <__bss_end+0xfabc4>
 2e8:	0b0d4201 	bleq	350af4 <__bss_end+0x347ac4>
 2ec:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 2f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2f8:	000001c4 	andeq	r0, r0, r4, asr #3
 2fc:	00008630 	andeq	r8, r0, r0, lsr r6
 300:	00000050 	andeq	r0, r0, r0, asr r0
 304:	8b040e42 	blhi	103c14 <__bss_end+0xfabe4>
 308:	0b0d4201 	bleq	350b14 <__bss_end+0x347ae4>
 30c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 310:	00000ecb 	andeq	r0, r0, fp, asr #29
 314:	0000001c 	andeq	r0, r0, ip, lsl r0
 318:	000001c4 	andeq	r0, r0, r4, asr #3
 31c:	00008680 	andeq	r8, r0, r0, lsl #13
 320:	00000054 	andeq	r0, r0, r4, asr r0
 324:	8b040e42 	blhi	103c34 <__bss_end+0xfac04>
 328:	0b0d4201 	bleq	350b34 <__bss_end+0x347b04>
 32c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 330:	00000ecb 	andeq	r0, r0, fp, asr #29
 334:	0000001c 	andeq	r0, r0, ip, lsl r0
 338:	000001c4 	andeq	r0, r0, r4, asr #3
 33c:	000086d4 	ldrdeq	r8, [r0], -r4
 340:	0000003c 	andeq	r0, r0, ip, lsr r0
 344:	8b040e42 	blhi	103c54 <__bss_end+0xfac24>
 348:	0b0d4201 	bleq	350b54 <__bss_end+0x347b24>
 34c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 350:	00000ecb 	andeq	r0, r0, fp, asr #29
 354:	0000001c 	andeq	r0, r0, ip, lsl r0
 358:	000001c4 	andeq	r0, r0, r4, asr #3
 35c:	00008710 	andeq	r8, r0, r0, lsl r7
 360:	0000003c 	andeq	r0, r0, ip, lsr r0
 364:	8b040e42 	blhi	103c74 <__bss_end+0xfac44>
 368:	0b0d4201 	bleq	350b74 <__bss_end+0x347b44>
 36c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 370:	00000ecb 	andeq	r0, r0, fp, asr #29
 374:	0000001c 	andeq	r0, r0, ip, lsl r0
 378:	000001c4 	andeq	r0, r0, r4, asr #3
 37c:	0000874c 	andeq	r8, r0, ip, asr #14
 380:	0000003c 	andeq	r0, r0, ip, lsr r0
 384:	8b040e42 	blhi	103c94 <__bss_end+0xfac64>
 388:	0b0d4201 	bleq	350b94 <__bss_end+0x347b64>
 38c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 390:	00000ecb 	andeq	r0, r0, fp, asr #29
 394:	0000001c 	andeq	r0, r0, ip, lsl r0
 398:	000001c4 	andeq	r0, r0, r4, asr #3
 39c:	00008788 	andeq	r8, r0, r8, lsl #15
 3a0:	0000003c 	andeq	r0, r0, ip, lsr r0
 3a4:	8b040e42 	blhi	103cb4 <__bss_end+0xfac84>
 3a8:	0b0d4201 	bleq	350bb4 <__bss_end+0x347b84>
 3ac:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 3b0:	00000ecb 	andeq	r0, r0, fp, asr #29
 3b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3b8:	000001c4 	andeq	r0, r0, r4, asr #3
 3bc:	000087c4 	andeq	r8, r0, r4, asr #15
 3c0:	000000b0 	strheq	r0, [r0], -r0	; <UNPREDICTABLE>
 3c4:	8b080e42 	blhi	203cd4 <__bss_end+0x1faca4>
 3c8:	42018e02 	andmi	r8, r1, #2, 28
 3cc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 3d0:	080d0c50 	stmdaeq	sp, {r4, r6, sl, fp}
 3d4:	0000000c 	andeq	r0, r0, ip
 3d8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 3dc:	7c020001 	stcvc	0, cr0, [r2], {1}
 3e0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 3e4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3e8:	000003d4 	ldrdeq	r0, [r0], -r4
 3ec:	00008874 	andeq	r8, r0, r4, ror r8
 3f0:	00000174 	andeq	r0, r0, r4, ror r1
 3f4:	8b080e42 	blhi	203d04 <__bss_end+0x1facd4>
 3f8:	42018e02 	andmi	r8, r1, #2, 28
 3fc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 400:	080d0cb2 	stmdaeq	sp, {r1, r4, r5, r7, sl, fp}
 404:	0000001c 	andeq	r0, r0, ip, lsl r0
 408:	000003d4 	ldrdeq	r0, [r0], -r4
 40c:	000089e8 	andeq	r8, r0, r8, ror #19
 410:	0000009c 	muleq	r0, ip, r0
 414:	8b040e42 	blhi	103d24 <__bss_end+0xfacf4>
 418:	0b0d4201 	bleq	350c24 <__bss_end+0x347bf4>
 41c:	0d0d4602 	stceq	6, cr4, [sp, #-8]
 420:	000ecb42 	andeq	ip, lr, r2, asr #22
 424:	0000001c 	andeq	r0, r0, ip, lsl r0
 428:	000003d4 	ldrdeq	r0, [r0], -r4
 42c:	00008a84 	andeq	r8, r0, r4, lsl #21
 430:	000000c0 	andeq	r0, r0, r0, asr #1
 434:	8b040e42 	blhi	103d44 <__bss_end+0xfad14>
 438:	0b0d4201 	bleq	350c44 <__bss_end+0x347c14>
 43c:	0d0d5802 	stceq	8, cr5, [sp, #-8]
 440:	000ecb42 	andeq	ip, lr, r2, asr #22
 444:	0000001c 	andeq	r0, r0, ip, lsl r0
 448:	000003d4 	ldrdeq	r0, [r0], -r4
 44c:	00008b44 	andeq	r8, r0, r4, asr #22
 450:	000000ac 	andeq	r0, r0, ip, lsr #1
 454:	8b040e42 	blhi	103d64 <__bss_end+0xfad34>
 458:	0b0d4201 	bleq	350c64 <__bss_end+0x347c34>
 45c:	0d0d4e02 	stceq	14, cr4, [sp, #-8]
 460:	000ecb42 	andeq	ip, lr, r2, asr #22
 464:	0000001c 	andeq	r0, r0, ip, lsl r0
 468:	000003d4 	ldrdeq	r0, [r0], -r4
 46c:	00008bf0 	strdeq	r8, [r0], -r0
 470:	00000054 	andeq	r0, r0, r4, asr r0
 474:	8b040e42 	blhi	103d84 <__bss_end+0xfad54>
 478:	0b0d4201 	bleq	350c84 <__bss_end+0x347c54>
 47c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 480:	00000ecb 	andeq	r0, r0, fp, asr #29
 484:	0000001c 	andeq	r0, r0, ip, lsl r0
 488:	000003d4 	ldrdeq	r0, [r0], -r4
 48c:	00008c44 	andeq	r8, r0, r4, asr #24
 490:	00000068 	andeq	r0, r0, r8, rrx
 494:	8b040e42 	blhi	103da4 <__bss_end+0xfad74>
 498:	0b0d4201 	bleq	350ca4 <__bss_end+0x347c74>
 49c:	420d0d6c 	andmi	r0, sp, #108, 26	; 0x1b00
 4a0:	00000ecb 	andeq	r0, r0, fp, asr #29
 4a4:	0000001c 	andeq	r0, r0, ip, lsl r0
 4a8:	000003d4 	ldrdeq	r0, [r0], -r4
 4ac:	00008cac 	andeq	r8, r0, ip, lsr #25
 4b0:	00000080 	andeq	r0, r0, r0, lsl #1
 4b4:	8b040e42 	blhi	103dc4 <__bss_end+0xfad94>
 4b8:	0b0d4201 	bleq	350cc4 <__bss_end+0x347c94>
 4bc:	420d0d78 	andmi	r0, sp, #120, 26	; 0x1e00
 4c0:	00000ecb 	andeq	r0, r0, fp, asr #29
 4c4:	0000000c 	andeq	r0, r0, ip
 4c8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 4cc:	7c010001 	stcvc	0, cr0, [r1], {1}
 4d0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 4d4:	0000000c 	andeq	r0, r0, ip
 4d8:	000004c4 	andeq	r0, r0, r4, asr #9
 4dc:	00008d2c 	andeq	r8, r0, ip, lsr #26
 4e0:	000001ec 	andeq	r0, r0, ip, ror #3
